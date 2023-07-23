Class {
	#name : #SmiBlockNode,
	#superclass : #SmiAbstractNode,
	#instVars : [
		'statements'
	],
	#category : #'Smic-Parser'
}

{ #category : #generated }
SmiBlockNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitBlock: self
]

{ #category : #generated }
SmiBlockNode >> otherVariables [

	^ #( #statements )
]

{ #category : #generated }
SmiBlockNode >> statements [

	^ statements
]

{ #category : #generated }
SmiBlockNode >> statements: anObject [

	statements := anObject
]
