Class {
	#name : #SmicMachineCodeDebugger,
	#superclass : #SpPresenter,
	#instVars : [
		'machineSimulator',
		'instructions',
		'stepButton',
		'disassembleAtPCButton',
		'machineState',
		'initialInstructionToDisassemble',
		'stack',
		'ipInput',
		'jumpToButton'
	],
	#category : #'Smic-Tools'
}

{ #category : #layout }
SmicMachineCodeDebugger class >> defaultLayout [

	^  SpBoxLayout newVertical 
		add:(SpBoxLayout newHorizontal
			add: #instructions expand: true fill: true padding: 5;		
			add: #machineState expand: true fill: true padding: 5;	
			add: #stack expand: true fill: true padding: 5; 
			yourself) expand: true fill: true padding: 5;
		add: (SpBoxLayout newHorizontal 
			add: (SpBoxLayout newVertical
				add: #ipInput;
				add: #jumpToButton) expand: true fill: true padding: 5;
			add: #stepButton expand: true fill: true padding: 5;
			add: #disassembleAtPCButton expand: true fill: true padding: 5) width: 200;
		yourself
]

{ #category : #'as yet unclassified' }
SmicMachineCodeDebugger class >> openOnSimulator: simulator ip: anInstructionPointer [

	self new
		machineSimulator: simulator;
		initialInstructionToDisassemble: anInstructionPointer;
		openWithSpec.
]

{ #category : #initialization }
SmicMachineCodeDebugger >> connectMachineStatePresenter [

	| contextMenu |
	
	contextMenu := SpMenuPresenter new.
	contextMenu addItem: [ :item |
		item 
			name: 'Inspect Value'; 
			action: [ machineState selection selectedItem inspectValue ] ].

	contextMenu addItem: [ :item |
		item 
			name: 'Copy Value to Clipboard'; 
			action: [ machineState selection selectedItem copyValueToClipboard ] ].

	contextMenu addItem: [ :item |
		item 
			name: 'Print Value'; 
			action: [ machineState selection selectedItem printValue ] ].

	machineState contextMenu: contextMenu.

	

]

{ #category : #initialization }
SmicMachineCodeDebugger >> connectPresenters [

	| instructionsContextMenu |
	stepButton action: [ self step ].
	disassembleAtPCButton action: [ self disassembleAtPC ].
	
	instructionsContextMenu := SpMenuPresenter new.
	instructionsContextMenu addItem: [ :item |
		item 
			name: 'Set Intruction Pointer Here'; 
			action: [ self setInstructionPointerToSelectedInstruction. self refreshAll ] ].

	instructionsContextMenu addItem: [ :item |
		item 
			name: 'Run to Here'; 
			action: [ self runToSelectedInstruction. self refreshAll ] ].

	instructionsContextMenu addItem: [ :item |
		item 
			name: 'Inspect'; 
			action: [ self inspectSelectedInstruction ] ].
	instructions contextMenu: instructionsContextMenu.
	
	self connectMachineStatePresenter.
	
	jumpToButton action: [ self jump ].
]

{ #category : #actions }
SmicMachineCodeDebugger >> disassembleAtPC [

	self initialInstructionToDisassemble:  machineSimulator instructionPointer.
	self refreshInstructions.
]

{ #category : #showing }
SmicMachineCodeDebugger >> doInitialDisassemble [

	^ machineSimulator disassembler
		printImmediatesInHexa;
		useAlternatePrinterVariant;
		disassembleNext: 600
		instructionsIn: (machineSimulator memoryAt: self initialInstructionToDisassemble readNext: 300)
		startAddress: self initialInstructionToDisassemble
		pc: machineSimulator instructionPointer 
]

{ #category : #showing }
SmicMachineCodeDebugger >> initialDisassembly [

	^ self doInitialDisassemble collect: [ :anInstruction | 
			SmicMachineCodeDebuggerInstruction new
				instruction: anInstruction;
				bytes: (anInstruction codeBytes: machineSimulator);
				debugger: self;
				machineSimulator: machineSimulator;
				yourself ]
]

{ #category : #showing }
SmicMachineCodeDebugger >> initialExtent [ 

	^ 1000@600
]

{ #category : #showing }
SmicMachineCodeDebugger >> initialInstructionToDisassemble [

	^ initialInstructionToDisassemble
		ifNil: [ machineSimulator instructionPointerRegisterValue ]
]

{ #category : #showing }
SmicMachineCodeDebugger >> initialInstructionToDisassemble: anInstructionAddress [

	initialInstructionToDisassemble := anInstructionAddress
]

{ #category : #initialization }
SmicMachineCodeDebugger >> initializePresenters [

	machineState := self newTable.
	machineState
		addColumn: (SpStringTableColumn evaluated: #name);
		addColumn: (SpStringTableColumn evaluated: #alias);
		addColumn: (SpStringTableColumn evaluated: [ :register | register printString ]).

	instructions := self newTable.
	instructions
		isResizable: true;
		addColumn: ((SpStringTableColumn 
			title: 'Address'
			evaluated: #addressString) 
				isSortable: false; 
				yourself);
		addColumn:
			((SpImageTableColumn 
				title: ''
				evaluated: #icon )
				width: 50;
				beNotExpandable;
				yourself);
		addColumn: ((SpStringTableColumn 
			title: 'ASM'
			evaluated: #assemblyCodeString) 
				isSortable: false;
				yourself);
		addColumn: ((SpStringTableColumn title: 'Bytes'
			evaluated: #bytesString) 
			isSortable: false; 
			yourself);		
		showColumnHeaders.
	
	stack := self newTable.
	stack
		addColumn: (SpStringTableColumn evaluated: [ :aPosition | aPosition specialRegister ] );
		addColumn: (SpStringTableColumn evaluated: [ :aPosition | aPosition address hex ] );
		addColumn: (SpStringTableColumn evaluated: [ :aPosition | 
			[aPosition value hex] on: Error do: [ 'Error' ] ]).
	
	stepButton := self newButton.
	stepButton label: 'Step'.
	
	disassembleAtPCButton := self newButton.
	disassembleAtPCButton label: 'Disassemble at PC'.
	
	ipInput := self newTextInput.
	jumpToButton := self newButton.
	jumpToButton label: 'Jump to'
]

{ #category : #actions }
SmicMachineCodeDebugger >> inspectSelectedInstruction [

	instructions selection selectedItem inspect
]

{ #category : #actions }
SmicMachineCodeDebugger >> jump [

	machineSimulator instructionPointer: (NumberParser parse: ipInput text).
	self refreshInstructions.
	self refreshRegisters.
]

{ #category : #accessing }
SmicMachineCodeDebugger >> machineSimulator [
	^ machineSimulator
]

{ #category : #accessing }
SmicMachineCodeDebugger >> machineSimulator: anObject [
	machineSimulator := anObject
]

{ #category : #showing }
SmicMachineCodeDebugger >> openWithSpec [

	self refreshAll.
	super open
]

{ #category : #showing }
SmicMachineCodeDebugger >> refreshAll [ 
	
	self refreshInstructions.
	self refreshStack.
	self refreshRegisters.
]

{ #category : #showing }
SmicMachineCodeDebugger >> refreshInstructions [

	instructions items: self initialDisassembly
]

{ #category : #showing }
SmicMachineCodeDebugger >> refreshRegisters [

	machineState items: machineSimulator registerDescriptors
]

{ #category : #showing }
SmicMachineCodeDebugger >> refreshStack [

	stack items: machineSimulator stackValues
]

{ #category : #'as yet unclassified' }
SmicMachineCodeDebugger >> runToSelectedInstruction [
	
	| selectedInstruction |

	selectedInstruction := self selectedInstruction.

	machineSimulator
		startAt: machineSimulator instructionPointerRegisterValue
		until: selectedInstruction address
		timeout: 100000 "microseconds = 100ms"
		count: 0.
	self refreshStack.
]

{ #category : #'as yet unclassified' }
SmicMachineCodeDebugger >> selectedInstruction [

	^ instructions selection selectedItem
]

{ #category : #actions }
SmicMachineCodeDebugger >> setInstructionPointerToSelectedInstruction [
	
	machineSimulator instructionPointer: instructions selection selectedItem address
]

{ #category : #actions }
SmicMachineCodeDebugger >> step [

	machineSimulator step.
	self refreshAll
]

{ #category : #showing }
SmicMachineCodeDebugger >> title [ 

	^ 'VM Debugger'
]

{ #category : #accessing }
SmicMachineCodeDebugger >> x26 [
	
	^ machineSimulator x26
]
