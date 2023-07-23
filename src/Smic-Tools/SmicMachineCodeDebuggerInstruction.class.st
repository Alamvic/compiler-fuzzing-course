Class {
	#name : #SmicMachineCodeDebuggerInstruction,
	#superclass : #Object,
	#instVars : [
		'instruction',
		'bytes',
		'machineSimulator',
		'debugger'
	],
	#category : #'Smic-Tools'
}

{ #category : #accessing }
SmicMachineCodeDebuggerInstruction >> address [
	
	^ instruction address
]

{ #category : #printing }
SmicMachineCodeDebuggerInstruction >> addressString [
	
	^ instruction address hex
]

{ #category : #printing }
SmicMachineCodeDebuggerInstruction >> assemblyCodeString [

	^ instruction assemblyCodeString 
]

{ #category : #accessing }
SmicMachineCodeDebuggerInstruction >> branchTargetAddress [
	
	^ instruction branchTargetAddress
]

{ #category : #accessor }
SmicMachineCodeDebuggerInstruction >> bytes: aByteArray [ 
	bytes := aByteArray
]

{ #category : #printing }
SmicMachineCodeDebuggerInstruction >> bytesString [

	^ String streamContents: [ :aStream |
		aStream nextPutAll: '#['.
		bytes
			do: [ :each | each hex printOn: aStream ]
			separatedBy: [ aStream nextPut: $ ].
		aStream nextPut: $]].


]

{ #category : #accessing }
SmicMachineCodeDebuggerInstruction >> debugger: aVMMachineCodeDebugger [ 
	
	debugger := aVMMachineCodeDebugger
]

{ #category : #showing }
SmicMachineCodeDebuggerInstruction >> icon [

	self address = machineSimulator instructionPointer 
		ifTrue: [ ^ self iconNamed: #forward ].
	
	debugger selectedInstruction 
		ifNotNil: [ :selectedInstruction |
				selectedInstruction branchTargetAddress = self address 
					ifTrue: [ ^ self iconNamed: #glamorousInto ]].

	^ nil
]

{ #category : #accessing }
SmicMachineCodeDebuggerInstruction >> instruction: aLLVMInstruction [ 
	instruction := aLLVMInstruction
]

{ #category : #accessing }
SmicMachineCodeDebuggerInstruction >> machineSimulator: anUnicornARMv8Simulator [ 
	machineSimulator := anUnicornARMv8Simulator
]
