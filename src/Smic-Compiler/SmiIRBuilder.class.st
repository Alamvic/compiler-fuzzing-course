Class {
	#name : #SmiIRBuilder,
	#superclass : #Object,
	#instVars : [
		'scopes',
		'compilationUnit',
		'variables',
		'definedVariables'
	],
	#category : #'Smic-Compiler-Midend'
}

{ #category : #factory }
SmiIRBuilder >> allocateTemporaryRegister [
	
	^ self controlFlowGraph instructionFactory allocateTemporaryRegister
]

{ #category : #accessing }
SmiIRBuilder >> compilationUnit [
	^ compilationUnit
]

{ #category : #'instance creation' }
SmiIRBuilder >> controlFlowGraph [
	
	| functionScope |
	functionScope := scopes last.
	^ functionScope controlFlowGraph
]

{ #category : #private }
SmiIRBuilder >> currentBasicBlock [

	^ self currentScope attributeNamed: #basicBlock
]

{ #category : #private }
SmiIRBuilder >> currentScope [
	
	^ scopes top
]

{ #category : #'accessing - instances and variables' }
SmiIRBuilder >> definedVariables [
	
	^ definedVariables
]

{ #category : #initialization }
SmiIRBuilder >> initialize [

	super initialize.
	scopes := Stack new.
	compilationUnit := SmiIRCompilationUnit new.
	definedVariables := Dictionary new.
	
]

{ #category : #'control flow' }
SmiIRBuilder >> mergeChangedVariablesInto: previouslyDefinedVariables [
	
	| newDefinedVariables |
	newDefinedVariables := Dictionary new.
	previouslyDefinedVariables keysAndValuesDo: [ :k :leftBranchValue | | trueBranchValue joinValue |
		trueBranchValue := definedVariables at: k.
		joinValue := trueBranchValue = leftBranchValue
			ifTrue: [ trueBranchValue ]
			ifFalse: [ self currentBasicBlock phiWithVariables: { trueBranchValue . leftBranchValue } ].
		newDefinedVariables at: k put: joinValue
	].
	definedVariables := newDefinedVariables
]

{ #category : #'instance creation' }
SmiIRBuilder >> newBasicBlock [
	
	| basicBlock |
	basicBlock := self controlFlowGraph newBasicBlock.
	self currentScope attributeNamed: #basicBlock put: basicBlock.
	^ basicBlock
]

{ #category : #types }
SmiIRBuilder >> overflowErrorCode [

	^ -1 twoComplementOfBitSize: 64
]

{ #category : #printing }
SmiIRBuilder >> printStringErrorCode [
	
	^ -2
]

{ #category : #scopes }
SmiIRBuilder >> pushScope: aScope during: aBlock [
	
	scopes push: aScope.
	aBlock value.
	^ scopes pop
]

{ #category : #visiting }
SmiIRBuilder >> sysCall: number arguments: arguments [

	| syscall |
	syscall := SmiIRSysCall
		           operands: { number asDRValue } , arguments
		           result: DRNoRegister new.
	self currentBasicBlock addInstruction: syscall.
	^ syscall
]

{ #category : #types }
SmiIRBuilder >> tagInteger: anIntegerWithoutTag [

	| shiftedInt jumpIfOverflow overflowBlock nonOverflowBlock |
	shiftedInt := self currentBasicBlock
		              leftShift: anIntegerWithoutTag
		              by: 1.
	jumpIfOverflow := self currentBasicBlock jumpIfOverflowOn: shiftedInt.

	overflowBlock := self newBasicBlock.
	jumpIfOverflow trueBranch: overflowBlock.
	overflowBlock addPredecessor: jumpIfOverflow basicBlock.
	self sysCall: self overflowErrorCode arguments: #(  ).


	nonOverflowBlock := self newBasicBlock.
	jumpIfOverflow falseBranch: nonOverflowBlock.
	nonOverflowBlock addPredecessor: jumpIfOverflow basicBlock.

	^ self currentBasicBlock add: shiftedInt to: 1
]

{ #category : #types }
SmiIRBuilder >> untagInteger: aTaggedNumber [
	
	^ self currentBasicBlock rightShift: aTaggedNumber by: 1
]

{ #category : #visiting }
SmiIRBuilder >> visitArray: aSmiArrayNode [

	| size array |
	size := self untagInteger: (aSmiArrayNode _size acceptVisitor: self).
	array := self currentBasicBlock addInstruction: (SmiDRStackAllocate
			          operands: { (self currentBasicBlock
					           leftShift: (self currentBasicBlock add: size to: 1)
					           by: 3) }
			          result: self allocateTemporaryRegister).
	self currentBasicBlock storeSInt64: size at: array.
	^ array
]

{ #category : #visiting }
SmiIRBuilder >> visitArrayRead: aSmiArrayReadNode [

	| array index |
	array := definedVariables at: aSmiArrayReadNode variable.
	index := self untagInteger:
		         (aSmiArrayReadNode index acceptVisitor: self).

	^ self currentBasicBlock loadSInt64:
		(self currentBasicBlock add: array to: (self currentBasicBlock
				  leftShift: (self currentBasicBlock add: index to: 1)
				  by: 3))
]

{ #category : #visiting }
SmiIRBuilder >> visitArraySize: aSmiArraySizeNode [

	| array |
	array := aSmiArraySizeNode array acceptVisitor: self.
	"self checkNotInteger: array."
	^ self tagInteger: (self currentBasicBlock loadSInt64: array)
]

{ #category : #visiting }
SmiIRBuilder >> visitArrayWrite: aSmiArrayWriteNode [

	| array index value |
	array := definedVariables at: aSmiArrayWriteNode variable.
	index := self untagInteger:
		         (aSmiArrayWriteNode index acceptVisitor: self).
	value := aSmiArrayWriteNode value acceptVisitor: self.

	^ self currentBasicBlock
		storeSInt64: value
		at: (self currentBasicBlock add: array to: (self currentBasicBlock
					  leftShift: (self currentBasicBlock add: index to: 1)
					  by: 3))
]

{ #category : #visiting }
SmiIRBuilder >> visitAssignment: aSmiAssignment [
	"Let's convert everything to SSA here"

	| value |
	"Create a new name"
	value := aSmiAssignment value acceptVisitor: self.

	"And associate it to the variable"
	self definedVariables at: aSmiAssignment variable put: value
]

{ #category : #visiting }
SmiIRBuilder >> visitBinaryOperator: aSmiOperation [

	| operator left right |
	operator := aSmiOperation operator value.
	left := aSmiOperation left acceptVisitor: self.
	right := aSmiOperation right acceptVisitor: self.

	left := self untagInteger: left.
	right := self untagInteger: right.
	operator = #+ ifTrue: [
		^ self tagInteger: (self currentBasicBlock add: left to: right) ].
	operator = #- ifTrue: [
		^ self tagInteger:
			  (self currentBasicBlock subtract: right from: left) ].
	operator = #* ifTrue: [
		^ self tagInteger:
			  (self currentBasicBlock multiply: right by: left) ].
	operator = #> ifTrue: [
		^ self currentBasicBlock greater: left than: right ].
	operator = #< ifTrue: [
		^ self currentBasicBlock less: left than: right ].
	self halt
]

{ #category : #visiting }
SmiIRBuilder >> visitBlock: aSmiBlock [

	self
		pushScope: aSmiBlock
		during: [ aSmiBlock statements do: [ :e | e acceptVisitor: self ] ]
]

{ #category : #visiting }
SmiIRBuilder >> visitConditional: aSmiConditional [

	| condition jump lastBasicBlock joinBlock branchScope previouslyDefinedVariables |
	condition := aSmiConditional condition acceptVisitor: self.
	jump := self currentBasicBlock jumpIf: condition.
	previouslyDefinedVariables := definedVariables copy.

	branchScope := self pushScope: aSmiConditional body during: [
		               jump trueBranch: self newBasicBlock.
		               jump trueBranch addPredecessor: jump basicBlock.
		               aSmiConditional body statements do: [ :e |
			               e acceptVisitor: self ].
		               lastBasicBlock := self currentBasicBlock ].

	joinBlock := self newBasicBlock.
	lastBasicBlock hasFinalInstruction ifFalse: [
		lastBasicBlock jumpTo: joinBlock ].
	jump falseBranch: joinBlock.
	jump falseBranch addPredecessor: jump basicBlock.

	"Insert phi functions"
	self mergeChangedVariablesInto: previouslyDefinedVariables
]

{ #category : #visiting }
SmiIRBuilder >> visitFunction: aSmiFunction [

	| function |
	function := SmiIRFunction new.
	function numberOfParameters: aSmiFunction parameters size.
	function name: aSmiFunction name.
	compilationUnit addFunction: function.

	self pushScope: function during: [
		aSmiFunction body attributeNamed: #basicBlock put: function initialBasicBlock.
		aSmiFunction parameters doWithIndex: [ :argName :i |
			| value |
			value := self currentBasicBlock loadArgument: i.
			value classType: DRIntegerType new.
			self definedVariables at: argName put: value
		].		
		aSmiFunction body acceptVisitor: self ]
]

{ #category : #visiting }
SmiIRBuilder >> visitFunctionCall: aSmiCall [

	| irArguments |
	irArguments := aSmiCall arguments collect: [ :e | e acceptVisitor: self ].
	^ self currentBasicBlock addInstruction: (DRCall
			   operands: { aSmiCall functionName asDRValue } , irArguments
			   result: self allocateTemporaryRegister)
]

{ #category : #visiting }
SmiIRBuilder >> visitNumber: aSmiNumberNode [ 
	
	"Numbers are stored as tagged values"
	^ self currentBasicBlock copy: (aSmiNumberNode value value asInteger << 1) + 1
]

{ #category : #visiting }
SmiIRBuilder >> visitPrintStatement: aSmiPrint [

	| syscall literalIndex |
	literalIndex := compilationUnit allocateLiteral:
		                aSmiPrint string value allButFirst allButLast.
	syscall := SmiIRSysCall
		           operands: {
				           self printStringErrorCode asDRValue.
				           literalIndex asDRValue }
		           result: DRNoRegister new.
	self currentBasicBlock addInstruction: syscall
]

{ #category : #visiting }
SmiIRBuilder >> visitProgram: aSmiProgram [ 
	
	aSmiProgram functions do: [ :e | e acceptVisitor: self ]
]

{ #category : #visiting }
SmiIRBuilder >> visitReturn: aSmiReturn [ 
	
	| value |
	value := aSmiReturn expression acceptVisitor: self.
	self currentBasicBlock return: value
]

{ #category : #visiting }
SmiIRBuilder >> visitVariableRead: aVariableRead [ 
	
	"And associate it to the variable"
	^ definedVariables at: aVariableRead variable
]
