Class {
	#name : #SmiArrayNode,
	#superclass : #SmiAbstractNode,
	#instVars : [
		'_size'
	],
	#category : #'Smic-Parser'
}

{ #category : #generated }
SmiArrayNode >> _size [

	^ _size
]

{ #category : #generated }
SmiArrayNode >> _size: aSmiAbstractNode [

	self _size notNil ifTrue: [ self _size parent: nil ].
	_size := aSmiAbstractNode.
	self _size notNil ifTrue: [ self _size parent: self ]
]

{ #category : #generated }
SmiArrayNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitArray: self
]

{ #category : #generated }
SmiArrayNode >> nodeVariables [

	^ #( #_size )
]
