Class {
	#name : #SmiFunctionNode,
	#superclass : #SmiAbstractNode,
	#instVars : [
		'name',
		'body',
		'parameters'
	],
	#category : #'Smic-Parser'
}

{ #category : #generated }
SmiFunctionNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitFunction: self
]

{ #category : #generated }
SmiFunctionNode >> body [

	^ body
]

{ #category : #generated }
SmiFunctionNode >> body: aSmiBlockNode [

	self body notNil ifTrue: [ self body parent: nil ].
	body := aSmiBlockNode.
	self body notNil ifTrue: [ self body parent: self ]
]

{ #category : #generated }
SmiFunctionNode >> name [

	^ name
]

{ #category : #generated }
SmiFunctionNode >> name: aSmaCCToken [

	name := aSmaCCToken
]

{ #category : #generated }
SmiFunctionNode >> nodeVariables [

	^ #( #body )
]

{ #category : #generated }
SmiFunctionNode >> otherVariables [

	^ #( #parameters )
]

{ #category : #generated }
SmiFunctionNode >> parameters [

	^ parameters
]

{ #category : #generated }
SmiFunctionNode >> parameters: anObject [

	parameters := anObject
]

{ #category : #generated }
SmiFunctionNode >> tokenVariables [

	^ #( #name )
]
