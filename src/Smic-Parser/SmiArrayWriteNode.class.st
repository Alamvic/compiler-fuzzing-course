Class {
	#name : #SmiArrayWriteNode,
	#superclass : #SmiAbstractNode,
	#instVars : [
		'variable',
		'index',
		'value'
	],
	#category : #'Smic-Parser'
}

{ #category : #generated }
SmiArrayWriteNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitArrayWrite: self
]

{ #category : #generated }
SmiArrayWriteNode >> index [

	^ index
]

{ #category : #generated }
SmiArrayWriteNode >> index: aSmiAbstractNode [

	self index notNil ifTrue: [ self index parent: nil ].
	index := aSmiAbstractNode.
	self index notNil ifTrue: [ self index parent: self ]
]

{ #category : #generated }
SmiArrayWriteNode >> nodeVariables [

	^ #( #index #value )
]

{ #category : #generated }
SmiArrayWriteNode >> tokenVariables [

	^ #( #variable )
]

{ #category : #generated }
SmiArrayWriteNode >> value [

	^ value
]

{ #category : #generated }
SmiArrayWriteNode >> value: aSmiAbstractNode [

	self value notNil ifTrue: [ self value parent: nil ].
	value := aSmiAbstractNode.
	self value notNil ifTrue: [ self value parent: self ]
]

{ #category : #generated }
SmiArrayWriteNode >> variable [

	^ variable
]

{ #category : #generated }
SmiArrayWriteNode >> variable: aSmaCCToken [

	variable := aSmaCCToken
]
