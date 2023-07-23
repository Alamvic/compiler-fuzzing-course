Class {
	#name : #SmiRunner,
	#superclass : #Object,
	#instVars : [
		'simulator',
		'error',
		'compilationUnit',
		'stdout',
		'architecture'
	],
	#category : #'Smic-Runner'
}

{ #category : #accessing }
SmiRunner >> architecture: aString [

	architecture := aString
	
]

{ #category : #running }
SmiRunner >> ensureSimulator [

	| stackMemory |
	simulator := SmiSimulator perform: architecture.
	simulator onInvalidMemoryAccessDo: [ :type :address :size :value |
		address = 8
			ifTrue: [ "System call!" self executeSystemCall ]
			ifFalse: [
				error := SmiInvalidMemoryAccessError new messageText:
					         'Invalid Memory Access: ' , address hex ].
		error ifNotNil: [ simulator stop ] ].

	"Map 4K of stack at address 16M"
	stackMemory := ByteArray new: 4096.
	stackMemory pinInMemory.
	simulator
		mapHostMemory: stackMemory
		atAddress: 4096 * 4096.
	simulator stackPointer: 4096 * 4096 + 4096 - 8 "word size"
]

{ #category : #running }
SmiRunner >> executeSystemCall [
	"pop return address, then system call id"

	| returnAddress syscallid |
	returnAddress := simulator popReturnAddress.

	syscallid := simulator pop.
	syscallid = -1 ifTrue: [
		error := SmiOverflowError new messageText: 'Overflow!'.
		^ self ].
	syscallid = -2 ifTrue: [
		| stringLiteralId |
		stringLiteralId := simulator pop.
		self print: (compilationUnit literalAt: stringLiteralId).
		"return!"
		simulator instructionPointer: returnAddress.
		^ self ].
	error := SmiUnexpectedError new messageText:
		         'Unknown syscall id = ' , syscallid asString
]

{ #category : #initialization }
SmiRunner >> initialize [

	super initialize.
	stdout := String empty writeStream
]

{ #category : #running }
SmiRunner >> loadProgram: aSmiIRCompilationUnit [

	| mappedMemory |
	compilationUnit := aSmiIRCompilationUnit.
	architecture ifNil: [ architecture := aSmiIRCompilationUnit architecture ].
	self ensureSimulator.
	
	mappedMemory := ByteArray new: 4096.
	mappedMemory
		replaceFrom: 1
		to: aSmiIRCompilationUnit machinecode size
		with: aSmiIRCompilationUnit machinecode.
	simulator
		mapHostMemory: mappedMemory
		atAddress: 4096
]

{ #category : #running }
SmiRunner >> output [

	^ stdout contents
]

{ #category : #running }
SmiRunner >> print: aString [

	stdout nextPutAll: aString
]

{ #category : #running }
SmiRunner >> run [
	"Setup return address"

	| returnAddress |
	"compilationUnit "
	returnAddress := 4000.
	simulator returnAddress: returnAddress.
	simulator instructionPointer: 4096.
	simulator runFrom: 4096 until: returnAddress.

	error ifNotNil: [ error signal ].

	"Untag it"
	^ simulator returnValue >> 1
]

{ #category : #running }
SmiRunner >> run: aProgram [

	^ self loadProgram: aProgram; run
]

{ #category : #accessing }
SmiRunner >> stdout: aWriteStream [ 
	stdout := aWriteStream
]
