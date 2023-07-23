Class {
	#name : #SmiCodeGenerator,
	#superclass : #Object,
	#instVars : [
		'cogit',
		'smiobject',
		'fallthroughBlock',
		'visitedBlocks',
		'deferredBranches',
		'architecture',
		'callsToPatch',
		'freeAddress',
		'machineCodeSize',
		'compilationUnit',
		'currentFunction'
	],
	#pools : [
		'CogAbstractRegisters'
	],
	#category : #'Smic-Compiler-Backend'
}

{ #category : #codegen }
SmiCodeGenerator >> architecture: aString [

	architecture := aString
]

{ #category : #branching }
SmiCodeGenerator >> cogitBranchFromCondition: condition type: aType [

	| branchPrefix |
	branchPrefix := aType isFloatType
		                ifTrue: [ 'JumpFP' ]
		                ifFalse: [ 'Jump' ].

	condition isEqualsThanComparison ifTrue: [ 
		^ aType isFloatType
			  ifTrue: [ branchPrefix , 'Equal:' ]
			  ifFalse: [ branchPrefix , 'Zero:' ] ].

	condition isNotEqualsThanComparison ifTrue: [ 
		^ aType isFloatType
			  ifTrue: [ branchPrefix , 'NotEqual:' ]
			  ifFalse: [ branchPrefix , 'NonZero:' ] ].

	condition isGreaterThanComparison ifTrue: [ 
		^ branchPrefix , 'Greater:' ].

	condition isGreaterOrEqualThanComparison ifTrue: [ 
		^ branchPrefix , 'GreaterOrEqual:' ].

	condition isLessThanComparison ifTrue: [ 
		^ branchPrefix , 'Less:' ].
	
	condition isLessOrEqualThanComparison ifTrue: [ 
		^ branchPrefix , 'LessOrEqual:' ].

	condition isOverflow ifTrue: [ 
		aType isFloatType
			ifTrue: [ self error: 'unsupported: cannot test the mask on a floating point number'  ].
		condition isMultiplyOverflow
			ifTrue: [ ^ branchPrefix , 'MultiplyOverflow:' ].
		^ branchPrefix , 'Overflow:' ].

	condition isNoOverflow ifTrue: [ 
		aType isFloatType
			ifTrue: [ self error: 'unsupported: cannot test the mask on a floating point number'  ].
		condition isNoMultiplyOverflow
			ifTrue: [ ^ branchPrefix , 'MultiplyNoOverflow:' ].
		^ branchPrefix , 'NoOverflow:' ].
	
	condition isTestMask ifTrue: [ 
		aType isFloatType
			ifTrue: [ self error: 'unsupported: cannot test the mask on a floating point number'  ].
		^ branchPrefix , 'NonZero:' ].
	
	condition isNoTestMask ifTrue: [ 
		aType isFloatType
			ifTrue: [ self error: 'unsupported: cannot test the mask on a floating point number'  ].
		^ branchPrefix , 'Zero:' ].

	1 halt
]

{ #category : #accessing }
SmiCodeGenerator >> compilationUnit: aSmiIRCompilationUnit [
	
	compilationUnit := aSmiIRCompilationUnit
]

{ #category : #'jump-management' }
SmiCodeGenerator >> deferBranch: aBranchInstruction to: aDRBasicBlock [ 
	
	(deferredBranches at: aDRBasicBlock ifAbsentPut: [ OrderedCollection new ])
		add: aBranchInstruction
]

{ #category : #accessing }
SmiCodeGenerator >> functionNamed: aString [

	^ compilationUnit functionNamed: aString	
]

{ #category : #codegen }
SmiCodeGenerator >> generateBlockIncomingJumps: aDRBasicBlock [

	| jumpInstructions |
	"If someother block is forward jumping to this block, create a label and wire deferred jumps to it"
	jumpInstructions := deferredBranches
		                    at: aDRBasicBlock
		                    ifAbsent: [ ^ self ].

	jumpInstructions do: [ :i |
		| targetLabel |
		targetLabel := self labelForBlock: aDRBasicBlock.
		i jmpTarget: targetLabel ]
]

{ #category : #codegen }
SmiCodeGenerator >> generateCogitIR [

	compilationUnit functions do: [ :f |
		self generateCogitIRForFunction: f ]
]

{ #category : #codegen }
SmiCodeGenerator >> generateCogitIRForFunction: aSmiIRFunction [

	| blocks functionLabel |
	currentFunction := aSmiIRFunction.
	cogit AlignmentNops: 8.
	functionLabel := cogit Label.
	aSmiIRFunction label: functionLabel.

	"Method preamble.
	First push the link register if RISC.
	Push the previous FP, the new FP should point to the saved FP"
	cogit backEnd hasLinkRegister
		ifTrue: [ cogit PushR: LinkReg ].
	cogit PushR: FPReg.
	cogit MoveR: SPReg R: FPReg.
	
	blocks := aSmiIRFunction controlFlowGraph reversePostOrderBlocks.
	blocks doWithIndex: [ :b :i |
		fallthroughBlock := blocks at: i + 1 ifAbsent: [ nil ].
		self generateMachineCodeForBlock: b ]
]

{ #category : #visiting }
SmiCodeGenerator >> generateJump: aString target: aTarget [ 
	
	| jumpStatement jumpVariableName jumpTarget jumpIndex |
	"If the jump target is the next block in the order, do not add any jump to it"
	aTarget = fallthroughBlock ifTrue: [ ^ self ].

	(self hasVisitedBlock: aTarget) ifTrue: [ 
		"Backwards branch, the jump target already exists with a label.
		Make the jump point to the already generated target"
		jumpTarget := self labelForBlock: aTarget.
		cogit perform: aString asSymbol with: jumpTarget.
	] ifFalse: [
		"Forward branch, the jump target does not yet exist.
		Put a 0 for now to generate `cogit Jump: 0`.
		Defer the branch so it is resolved when the target is created"
		self deferBranch: (cogit perform: aString asSymbol with: 0) to: aTarget ]
]

{ #category : #codegen }
SmiCodeGenerator >> generateMachineCode [

	| size finalAddress |
	cogit computeMaximumSizes.
	size := cogit generateInstructionsAt: freeAddress.
	finalAddress := cogit outputInstructionsAt: freeAddress.
	self patchCallInstructions.
	^ cogit objectMemory memoryManager
		  copyFrom: freeAddress
		  to: finalAddress
]

{ #category : #codegen }
SmiCodeGenerator >> generateMachineCodeForBlock: aDRBasicBlock [ 
	
	visitedBlocks at: aDRBasicBlock put: cogit Label.
	self generateBlockIncomingJumps: aDRBasicBlock.
	aDRBasicBlock instructions do: [ :e | e acceptVisitor: self ]
]

{ #category : #visiting }
SmiCodeGenerator >> generateSysCall: syscall operands: arguments [

	"Push to the arguments inverted, then stack the error code"
	arguments reversed do: [ :arg |
		self assert: arg isConstant.
		cogit PushCq: arg value.
	].
	cogit PushCq: syscall.
	cogit CallFull: 8.
]

{ #category : #testing }
SmiCodeGenerator >> hasVisitedBlock: aDRBasicBlock [ 
	
	^ visitedBlocks includesKey: aDRBasicBlock
]

{ #category : #initialization }
SmiCodeGenerator >> initialize [

	super initialize.	
	visitedBlocks := Dictionary new.
	deferredBranches := Dictionary new.
	callsToPatch := Dictionary new.
	smiobject := SmiObject new.
	
	freeAddress := 4096.
	machineCodeSize := 1000.
	
]

{ #category : #codegen }
SmiCodeGenerator >> initializeCompiler [

	| options interpreter memory |
	options := {
		           (#ISA -> architecture).
		           (#BytesPerWord -> 8).
		           (#ObjectMemory -> #Spur64BitCoMemoryManager).
		           (#SistaV1BytecodeSet -> false) } asDictionary.
	SpurMemoryManager initializeWithOptions: options.
	CoInterpreter initializeWithOptions: options.
	SimpleStackBasedCogit initializeWithOptions: options.
	cogit := SimpleStackBasedCogit new.
	interpreter := CoInterpreter new.
	memory := Spur64BitMMLECoSimulator new.
	memory memoryManager: (MachineSimulatorMemoryManager new
			 wordSize: 8;
			 yourself). "bytes of word size in 64 bits"
	interpreter memoryManager: memory memoryManager.
	interpreter objectMemory: memory.
	interpreter heapBase: 0.
	cogit setInterpreter: interpreter.

	"Prepare code memory"
	cogit objectMemory memoryManager
		allocate: machineCodeSize
		desiredPosition: freeAddress.

	cogit
		allocateOpcodes: 1000
		bytecodes: 0
		ifFail: [ self error: 'unexpected' ]. "opcodes? there should actually be **at least** one per instruction"
	cogit methodLabel address: freeAddress.
	cogit minValidCallAddress: 0.
	cogit methodZone
		manageFrom: freeAddress
		to: freeAddress + machineCodeSize
]

{ #category : #codegen }
SmiCodeGenerator >> labelForBlock: aDRBasicBlock [ 
	
	^ visitedBlocks at: aDRBasicBlock
]

{ #category : #'error codes' }
SmiCodeGenerator >> overflowErrorCode [

	^ -1 twoComplementOfBitSize: 64
]

{ #category : #patching }
SmiCodeGenerator >> patchCallInstructions [

	callsToPatch keysAndValuesDo: [ :functionName :calls |
		| functionAddress |
		functionAddress := (self functionNamed: functionName) address.
		calls do: [ :call |
			cogit backend
				rewriteCallAt: call address + call machineCodeSize
				target: functionAddress ] ]
]

{ #category : #patching }
SmiCodeGenerator >> registerCall: aCallInstruction to: aFunctionName [

	"Register a call instruction to a function.
	After addresses are computed but before code generation, we will patch all these with the corresponding value"
	
	(callsToPatch at: aFunctionName ifAbsentPut: [ Set new ]) add: aCallInstruction
]

{ #category : #configuration }
SmiCodeGenerator >> returnRegister [
	
	"The register encoded as 0 in the platform, e.g., X0 in aarch64, RAX in x64"
	^ 0
]

{ #category : #visiting }
SmiCodeGenerator >> visitAddition: aDRAdd [

	aDRAdd operand2 isConstant
		ifTrue: [ cogit AddCq: aDRAdd operand2 value R: aDRAdd result name ]
		ifFalse: [
		cogit AddR: aDRAdd operand2 result name R: aDRAdd result name ]
]

{ #category : #visiting }
SmiCodeGenerator >> visitBranchIfCondition: aDRBranchIfCondition [
	"Delegate the condition generation to the condition itself.
	It may be a Cmp, a Test or no instruction at all."

	aDRBranchIfCondition condition
		acceptVisitor: self
		withBranch: aDRBranchIfCondition.

	"Generate both jumps, the fallthorugh will get ignored"
	self
		generateJump: (self
				 cogitBranchFromCondition: aDRBranchIfCondition condition
				 type: aDRBranchIfCondition operand1 type)
		target: aDRBranchIfCondition trueBranch.
	self
		generateJump: (self
				 cogitBranchFromCondition: aDRBranchIfCondition condition negated
				 type: aDRBranchIfCondition operand1 type)
		target: aDRBranchIfCondition falseBranch
]

{ #category : #visiting }
SmiCodeGenerator >> visitCall: aDRCall [

	| callInstruction |
	"Calling convention, arguments go on the stack in reverse order, so push first the last one"
	aDRCall operands allButFirst reversed do: [ :e |
		e isConstant
			ifTrue: [ cogit PushCq: e value ]
			ifFalse: [ cogit PushR: e result name ] ].

	"Will patch it later"
	callInstruction := cogit Call: 4.
	self registerCall: callInstruction to: aDRCall operand1 value
]

{ #category : #visiting }
SmiCodeGenerator >> visitComparison: aComparison [
	"Generate comparison instruction. In cogit, if you want to do A < B, you have to generate:
	CMP B A
	JumpLessThan xxx
	Thus, operands are inverted always"

	| operands |
	operands := aComparison operands collect: [ :op |
		"True is the small integer 0, which means it's equals to 0 << 1 + 1 = 1"
		true = op value
			ifTrue: [ op value asBit << 1 + 1 ]
			ifFalse: [ op value ] ].

	aComparison operands second isConstant ifTrue: [
		self assert: aComparison operands first isConstant not.
		cogit CmpCq: operands second R: operands first result name.
		^ aComparison ].

	cogit CmpR: operands second result name R: operands first result name.
	^ aComparison
]

{ #category : #visiting }
SmiCodeGenerator >> visitCopy: aDRCopy [ 
	
	aDRCopy operand1 isConstant ifTrue: [
		cogit MoveCq: aDRCopy operand1 value R: aDRCopy result name.
		^ self
	].
	cogit MoveR: aDRCopy operand1 value result name R: aDRCopy result name.
]

{ #category : #visiting }
SmiCodeGenerator >> visitEqualsThan: aDRGreaterThanComparison inBranch: aDRBranchIfCondition [ 
	
	^ self visitComparison: aDRBranchIfCondition
]

{ #category : #visiting }
SmiCodeGenerator >> visitGetConditionCode: aDRGetConditionCode [
	"Generate the code of the form
		CMP
		JMP.COND true:
		RESULT := 0
		JUMP next:
	true:
		RESULT := 1
	next:
	"

	"Generate CMP; Jump.COND true; RESULT := 0; JUMP next"

	| comparisonToGenerate branch jumpTrue jumpNext |
	comparisonToGenerate := self visitComparison: aDRGetConditionCode.
	branch := self
		          cogitBranchFromCondition: comparisonToGenerate condition
		          type: comparisonToGenerate operand1 type.
	jumpTrue := cogit perform: branch asSymbol with: 0.
	"Set false to result"
	cogit MoveCq: 0 << 1 + 1 R: aDRGetConditionCode result name.
	jumpNext := cogit Jump: 0.

	"true label"
	jumpTrue jmpTarget: cogit Label.

	"Set true to result"
	cogit MoveCq: 1 << 1 + 1 R: aDRGetConditionCode result name.

	"next label"
	jumpNext jmpTarget: cogit Label
]

{ #category : #visiting }
SmiCodeGenerator >> visitGreaterThan: aDRGreaterThanComparison inBranch: aDRBranchIfCondition [ 

	^ self visitComparison: aDRBranchIfCondition
]

{ #category : #visiting }
SmiCodeGenerator >> visitJump: aDRJump [ 
	
	self
		generateJump: #Jump:
		target: aDRJump target
]

{ #category : #visiting }
SmiCodeGenerator >> visitLeftShift: aDRLeftShift [ 

	aDRLeftShift operand2 isConstant
		ifTrue: [
			cogit
				LogicalShiftLeftCq: aDRLeftShift operand2 value
				R: aDRLeftShift operand1 result name.
			^ self ]
		ifFalse: [ 1 halt ]
]

{ #category : #visiting }
SmiCodeGenerator >> visitLessThan: aDRLessThanComparison inBranch: aDRBranchIfCondition [ 
	
	^ self visitComparison: aDRBranchIfCondition
]

{ #category : #visiting }
SmiCodeGenerator >> visitLoad: aDRLoad [

	| base |
	aDRLoad operand1 isSpilledMemoryAddress
		ifTrue: [ base := FPReg ]
		ifFalse: [ base := aDRLoad operand1 base result name ].

	cogit MoveMw: aDRLoad operand1 offset r: base R: aDRLoad result name
]

{ #category : #visiting }
SmiCodeGenerator >> visitLoadArgument: aDRLoadArgument [
	"The arguments are in the stack, just behind the FP.
	For simplicity they are in reverse order.
	The first argument is the first one behind (+1 word), the second one is the second one (+2 words) and so on...
	Also, remember that stack grows downards"

	cogit
		MoveMw: aDRLoadArgument argNum * 8 + 8 "Skip the saved FP"
		r: FPReg
		R: aDRLoadArgument result name "wordSize"
]

{ #category : #visiting }
SmiCodeGenerator >> visitMultiply: aDRMultiply [

	^ cogit
		  MulR: aDRMultiply operand2 result name
		  R: aDRMultiply operand1 result name
]

{ #category : #visiting }
SmiCodeGenerator >> visitNoop: aDRNoop [ 
	
	"Do nothing..."
]

{ #category : #visiting }
SmiCodeGenerator >> visitOverflow: aDROverflow inBranch: aDRBranchIfCondition [ 
	
	"Nothing"
]

{ #category : #visiting }
SmiCodeGenerator >> visitPhiFunction: aDRPhiFunction [ 

	"For the moment nothing"
]

{ #category : #visiting }
SmiCodeGenerator >> visitPop: aDRPop [ 
	
	cogit PopR: aDRPop result name
]

{ #category : #visiting }
SmiCodeGenerator >> visitPush: aDRPush [ 

	cogit PushR: aDRPush operand1 name
]

{ #category : #visiting }
SmiCodeGenerator >> visitReturn: aDRReturn [
	"Calling convention: all arguments pass through the stack.
	It's the callee responsibility to pop them.
	The result is left in a register specified per platform"
	aDRReturn operand1 isConstant
		ifTrue: [
		cogit MoveCq: aDRReturn operand1 value R: self returnRegister ]
		ifFalse: [
		cogit MoveR: aDRReturn operand1 result name R: self returnRegister ].

	cogit MoveR: FPReg R: SPReg.
	cogit PopR: FPReg.
	cogit backEnd hasLinkRegister
		ifTrue: [ cogit PopR: LinkReg ].
	
	"return and pop the arguments from the stack"
	cogit RetN: currentFunction numberOfParameters * 8 "bytes"
]

{ #category : #visiting }
SmiCodeGenerator >> visitRightShift: aDRRightShift [

	aDRRightShift operand2 isConstant
		ifTrue: [
			cogit
				LogicalShiftRightCq: aDRRightShift operand2 value
				R: aDRRightShift operand1 result name.
			^ self ]
		ifFalse: [ 1 halt ]
]

{ #category : #visiting }
SmiCodeGenerator >> visitSmiIRSyscall: aSysCall [

	self assert: aSysCall operands first isConstant.
	self
		generateSysCall: aSysCall operands first value
		operands: aSysCall operands allButFirst
]

{ #category : #visiting }
SmiCodeGenerator >> visitStackAllocate: aDRStackAllocate [

	| slotsToAllocate |
	slotsToAllocate := aDRStackAllocate operand1.
	"Decrement the stack pointer by 8 bytes * slots.
	Replace *8 by <<3.
	Then undo the shifting in case the register is used for something else later"
	slotsToAllocate isConstant
		ifTrue: [ cogit SubCq: slotsToAllocate value R: SPReg ]
		ifFalse: [ cogit SubR: slotsToAllocate result name R: SPReg ].
	"Store the allocated address"
	cogit MoveR: SPReg R: aDRStackAllocate result name
]

{ #category : #visiting }
SmiCodeGenerator >> visitStore: aDRStore [

	| base |
	aDRStore operand1 isConstant ifTrue: [ self halt ].

	aDRStore operand2 isSpilledMemoryAddress
		ifTrue: [ base := FPReg ]
		ifFalse: [ base := aDRStore operand2 base result name ].
	cogit
		MoveR: aDRStore operand1 result name
		M64: aDRStore operand2 offset value
		r: base
]

{ #category : #visiting }
SmiCodeGenerator >> visitSubstract: aDRSubtract [

	aDRSubtract operand2 isConstant
		ifTrue: [
		cogit SubCq: aDRSubtract operand2 value R: aDRSubtract result name ]
		ifFalse: [
			cogit
				SubR: aDRSubtract operand2 result name
				R: aDRSubtract result name ]
]
