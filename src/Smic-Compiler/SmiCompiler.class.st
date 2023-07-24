Class {
	#name : #SmiCompiler,
	#superclass : #Object,
	#instVars : [
		'optimisations',
		'architecture'
	],
	#category : #'Smic-Compiler-Frontend'
}

{ #category : #'as yet unclassified' }
SmiCompiler class >> supportedOptimizations [

	^ {
		DRBranchCollapse new.
		DRCopyPropagation new.
		DRPhiSimplication new.
		(DRDeadCodeElimination then: DRRedundantCopyElimination).
		DRCleanControlFlow new.
		(DRDeadEdgeSplitting then: DRDeadBranchElimination).
		DRGlobalValueNumbering new.
		DRCogitCanonicaliser new.
		(DRSCCP then: DRDeadBlockElimination) }
]

{ #category : #compiling }
SmiCompiler >> allocateRegisters: ir [

	| fr |
	fr := DRPhysicalFloatingPointRegister name: 1.

	ir functions do: [ :f |
		"Massage first the IR for cogit generation and register allocation"	
		DRCogitOperandSorter new applyTo: f controlFlowGraph.
		
		"Then do register allocation"	
		SmiLinearScanRegisterAllocator new
			returnValueRegister: self returnValueRegister;
			integerRegisters: self availableRegisters;
			floatRegisters: { fr };
			spillRegisters: self spillRegisters;
			allocateRegistersIn: f controlFlowGraph ]
]

{ #category : #codegen }
SmiCompiler >> architecture: anArchitecture [

	architecture := anArchitecture
]

{ #category : #registers }
SmiCompiler >> availableRegisters [

	architecture = #X64 ifTrue: [
		^ (1 to: 14) collect: [ :e | DRPhysicalGeneralPurposeRegister name: e ] ].

	architecture = #aarch64 ifTrue: [
		^ (1 to: 26) collect: [ :e | DRPhysicalGeneralPurposeRegister name: e ] ].

	self error: 'Unsupported architecture ', architecture
]

{ #category : #compiling }
SmiCompiler >> compile: aSmiProgram [

	| ir code |
	ir := self computeIR: aSmiProgram.
	self optimize: ir.

	self allocateRegisters: ir.
	code := self generateObjectCode: ir.

	^ SmiObject new
		  architecture: architecture;
		  machinecode: code;
		  literals: ir literals;
		  yourself
]

{ #category : #compiling }
SmiCompiler >> computeIR: aSmiProgram [

	| builder |
	builder := SmiIRBuilder new.
	aSmiProgram acceptVisitor: builder.
	^ builder compilationUnit
]

{ #category : #codegen }
SmiCompiler >> generateObjectCode: aSmiIRCompilationUnit [
	"Roughly: generate the machine code for all functions.
	Leave calls unlinked, but remember them.
	Link calls later once we know the address of each unit."

	^ SmiCodeGenerator new
		  architecture: architecture;
		  compilationUnit: aSmiIRCompilationUnit;
		  initializeCompiler;
		  generateCogitIR;
		  generateMachineCode
]

{ #category : #initialization }
SmiCompiler >> initialize [

	super initialize.
	architecture := #aarch64.
	self o0
]

{ #category : #configuration }
SmiCompiler >> o0 [

	optimisations := #(  )
]

{ #category : #configuration }
SmiCompiler >> o1 [

	optimisations := {
		                 DRBranchCollapse new.
		                 DRCopyPropagation new.
		                 DRPhiSimplication new.
		                 (DRDeadCodeElimination then:
			                  DRRedundantCopyElimination).
		                 DRCleanControlFlow new }
]

{ #category : #configuration }
SmiCompiler >> o2 [

	self o1.
	optimisations := optimisations , {
		                 (DRDeadEdgeSplitting then: DRDeadBranchElimination).
		                 DRGlobalValueNumbering new.
		                 DRCogitCanonicaliser new.
		                 (DRSCCP then: DRDeadBlockElimination) }
]

{ #category : #accessing }
SmiCompiler >> optimisations [

	^ optimisations
]

{ #category : #accessing }
SmiCompiler >> optimisations: anObject [

	optimisations := anObject
]

{ #category : #compiling }
SmiCompiler >> optimize: ir [

	ir functions do: [ :f |
		1 to: 5 do: [ :i |
		optimisations do: [ :e | e applyTo: f controlFlowGraph ] ] ]
]

{ #category : #'calling convention' }
SmiCompiler >> returnValueRegister [

	architecture = #X64 ifTrue: [ 
		^ DRPhysicalGeneralPurposeRegister name: 0 ].
	architecture = #aarch64 ifTrue: [ 
		^ DRPhysicalGeneralPurposeRegister name: 0 ].

	self error: 'Unsupported architecture ', architecture
]

{ #category : #accessing }
SmiCompiler >> spillRegisters [

	architecture = #X64 ifTrue: [
		^ { (DRPhysicalGeneralPurposeRegister name: 15) } ].

	architecture = #aarch64 ifTrue: [
		^ { (DRPhysicalGeneralPurposeRegister name: 27) } ].


	self error: 'Unsupported architecture ' , architecture
]
