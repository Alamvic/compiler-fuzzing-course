Class {
	#name : #SmiIRFunction,
	#superclass : #Object,
	#instVars : [
		'name',
		'controlFlowGraph',
		'initialBasicBlock',
		'label',
		'numberOfParameters'
	],
	#category : #'Smic-Compiler-Midend'
}

{ #category : #accessing }
SmiIRFunction >> address [
	
	^ label address
]

{ #category : #'accessing-attributes' }
SmiIRFunction >> attributeNamed: aString [ 
	
	aString = #basicBlock ifFalse: [ self error ].
	^ initialBasicBlock
]

{ #category : #accessing }
SmiIRFunction >> basicBlock [
	
	^ initialBasicBlock
]

{ #category : #accessing }
SmiIRFunction >> controlFlowGraph [
	^ controlFlowGraph
]

{ #category : #accessing }
SmiIRFunction >> initialBasicBlock [
	
	^ initialBasicBlock
]

{ #category : #accessing }
SmiIRFunction >> initialize [

	super initialize.
	controlFlowGraph := DRControlFlowGraph new.
	initialBasicBlock := controlFlowGraph newBasicBlock.
	controlFlowGraph initialBasicBlock jumpTo: initialBasicBlock
]

{ #category : #accessing }
SmiIRFunction >> label: aLabelInstruction [ 
	label := aLabelInstruction
]

{ #category : #accessing }
SmiIRFunction >> name [
	^ name
]

{ #category : #accessing }
SmiIRFunction >> name: aName [

	name := aName
]

{ #category : #accessing }
SmiIRFunction >> numberOfParameters [
	^ numberOfParameters
]

{ #category : #accessing }
SmiIRFunction >> numberOfParameters: anInteger [ 
	
	numberOfParameters := anInteger
]

{ #category : #handling }
SmiIRFunction >> return: anInteger [ 
	self shouldBeImplemented.
]

{ #category : #'name resolution' }
SmiIRFunction >> scopeDefining: aString [ 
	
	^ nil
]
