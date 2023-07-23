Class {
	#name : #SmiIRSysCall,
	#superclass : #DRInstruction,
	#category : #'Smic-Compiler-Midend'
}

{ #category : #visiting }
SmiIRSysCall >> acceptVisitor: aDRCogitOperandSorter [ 
	
	^ aDRCogitOperandSorter visitSmiIRSyscall: self
]

{ #category : #printing }
SmiIRSysCall >> opcode [
	
	^ 'SmiSyscall'
]

{ #category : #SCCP }
SmiIRSysCall >> sccpLatticeValueFor: sccp [

	"We know that we know nothing about the frame pointer"
	^ sccp bottom
]
