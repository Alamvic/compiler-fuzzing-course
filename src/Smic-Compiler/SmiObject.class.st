Class {
	#name : #SmiObject,
	#superclass : #Object,
	#instVars : [
		'machinecode',
		'literals',
		'architecture'
	],
	#category : #'Smic-Compiler-Frontend'
}

{ #category : #accessing }
SmiObject >> architecture [

	^ architecture
]

{ #category : #accessing }
SmiObject >> architecture: anObject [

	architecture := anObject
]

{ #category : #utilities }
SmiObject >> disassemble: size [

	^ (LLVMDisassembler perform: (architecture = #X64
			              ifTrue: [ #amd64 ]
			              ifFalse: [
				              architecture = #aarch64
					              ifTrue: [ #aarch64 ]
					              ifFalse: [ architecture ] ]))
		disassembleNext: size
		instructionsIn: machinecode
		startAddress: 4096
		pc: 4096
]

{ #category : #accessing }
SmiObject >> literalAt: anInteger [ 
	
	^ literals at: anInteger
]

{ #category : #accessing }
SmiObject >> literals [

	^ literals
]

{ #category : #accessing }
SmiObject >> literals: anObject [

	literals := anObject
]

{ #category : #accessing }
SmiObject >> machinecode [

	^ machinecode
]

{ #category : #accessing }
SmiObject >> machinecode: anObject [

	machinecode := anObject
]
