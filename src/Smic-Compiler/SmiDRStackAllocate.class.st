Class {
	#name : #SmiDRStackAllocate,
	#superclass : #DRInstruction,
	#category : #'Smic-Compiler-Midend'
}

{ #category : #visiting }
SmiDRStackAllocate >> acceptVisitor: aVisitor [ 
	
	^ aVisitor visitStackAllocate: self
]

{ #category : #printing }
SmiDRStackAllocate >> opcode [
	
	^ 'StackAllocate'
]

{ #category : #SCCP }
SmiDRStackAllocate >> sccpLatticeValueFor: sccp [

	"We know that we know nothing about the frame pointer"
	^ sccp bottom
]
