Class {
	#name : #SmiReturnNode,
	#superclass : #SmiAbstractNode,
	#instVars : [
		'expression'
	],
	#category : #'Smic-Parser'
}

{ #category : #generated }
SmiReturnNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitReturn: self
]

{ #category : #generated }
SmiReturnNode >> expression [

	^ expression
]

{ #category : #generated }
SmiReturnNode >> expression: aSmiAbstractNode [

	self expression notNil ifTrue: [ self expression parent: nil ].
	expression := aSmiAbstractNode.
	self expression notNil ifTrue: [ self expression parent: self ]
]

{ #category : #generated }
SmiReturnNode >> nodeVariables [

	^ #( #expression )
]
