Class {
	#name : #SmiArrayReadNode,
	#superclass : #SmiAbstractNode,
	#instVars : [
		'index',
		'variable'
	],
	#category : #'Smic-Parser'
}

{ #category : #generated }
SmiArrayReadNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitArrayRead: self
]

{ #category : #generated }
SmiArrayReadNode >> index [

	^ index
]

{ #category : #generated }
SmiArrayReadNode >> index: aSmiAbstractNode [

	self index notNil ifTrue: [ self index parent: nil ].
	index := aSmiAbstractNode.
	self index notNil ifTrue: [ self index parent: self ]
]

{ #category : #generated }
SmiArrayReadNode >> nodeVariables [

	^ #( #index )
]

{ #category : #generated }
SmiArrayReadNode >> tokenVariables [

	^ #( #variable )
]

{ #category : #generated }
SmiArrayReadNode >> variable [

	^ variable
]

{ #category : #generated }
SmiArrayReadNode >> variable: aSmaCCToken [

	variable := aSmaCCToken
]
