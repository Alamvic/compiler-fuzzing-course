Class {
	#name : #SmiNumberNode,
	#superclass : #SmiAbstractNode,
	#instVars : [
		'value'
	],
	#category : #'Smic-Parser'
}

{ #category : #generated }
SmiNumberNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitNumber: self
]

{ #category : #generated }
SmiNumberNode >> tokenVariables [

	^ #( #value )
]

{ #category : #generated }
SmiNumberNode >> value [

	^ value
]

{ #category : #generated }
SmiNumberNode >> value: aSmaCCToken [

	value := aSmaCCToken
]
