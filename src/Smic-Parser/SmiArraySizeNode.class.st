Class {
	#name : #SmiArraySizeNode,
	#superclass : #SmiAbstractNode,
	#instVars : [
		'array'
	],
	#category : #'Smic-Parser'
}

{ #category : #generated }
SmiArraySizeNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitArraySize: self
]

{ #category : #generated }
SmiArraySizeNode >> array [

	^ array
]

{ #category : #generated }
SmiArraySizeNode >> array: aSmiAbstractNode [

	self array notNil ifTrue: [ self array parent: nil ].
	array := aSmiAbstractNode.
	self array notNil ifTrue: [ self array parent: self ]
]

{ #category : #generated }
SmiArraySizeNode >> nodeVariables [

	^ #( #array )
]
