Extension { #name : #SmiObject }

{ #category : #'*Smic-Runner' }
SmiObject >> simulator [
	
	| simulator stackMemory mappedMemory |
	simulator := SmiSimulator perform: architecture.
	"Map 4K of stack at address 16M"
	stackMemory := ByteArray new: 4096.
	stackMemory pinInMemory.
	simulator
		mapHostMemory: stackMemory
		atAddress: 4096 * 4096.
	simulator stackPointer: 4096 * 4096 + 4096 - 8 "word size".
	
	mappedMemory := ByteArray new: 4096.
	mappedMemory
		replaceFrom: 1
		to: machinecode size
		with: machinecode.
	simulator
		mapHostMemory: mappedMemory
		atAddress: 4096.
	
	simulator returnAddress: 16rBEEF.
	^ simulator
]
