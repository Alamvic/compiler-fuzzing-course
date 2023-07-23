Class {
	#name : #SmicMachineCodeDebuggerStackItem,
	#superclass : #Object,
	#instVars : [
		'address',
		'machineSimulator'
	],
	#category : #'Smic-Tools'
}

{ #category : #'instance creation' }
SmicMachineCodeDebuggerStackItem class >> address: anInteger on: machineSimulator [ 
	
	^ self new
		address: anInteger;
		machineSimulator: machineSimulator;
		yourself
]

{ #category : #accessing }
SmicMachineCodeDebuggerStackItem >> address [
	^ address
]

{ #category : #accessing }
SmicMachineCodeDebuggerStackItem >> address: anInteger [ 
	address := anInteger
]

{ #category : #accessing }
SmicMachineCodeDebuggerStackItem >> machineSimulator: anUnicornARMv8Simulator [ 
	machineSimulator := anUnicornARMv8Simulator
]

{ #category : #evaluating }
SmicMachineCodeDebuggerStackItem >> specialRegister [

	| isSP isFP |
	isSP := machineSimulator stackPointer = address.
	isFP := machineSimulator fp = address.
	^ String streamContents: [ :str | 
		isSP ifTrue: [ str nextPutAll: 'SP ' ].
		isFP ifTrue: [ str nextPutAll: 'FP ' ]. ]

]

{ #category : #evaluating }
SmicMachineCodeDebuggerStackItem >> value [ 

	^ machineSimulator wordAt: address
]
