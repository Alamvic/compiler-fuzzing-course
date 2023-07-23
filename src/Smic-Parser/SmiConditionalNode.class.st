Class {
	#name : #SmiConditionalNode,
	#superclass : #SmiAbstractNode,
	#instVars : [
		'condition',
		'body'
	],
	#category : #'Smic-Parser'
}

{ #category : #generated }
SmiConditionalNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitConditional: self
]

{ #category : #generated }
SmiConditionalNode >> body [

	^ body
]

{ #category : #generated }
SmiConditionalNode >> body: aSmiBlockNode [

	self body notNil ifTrue: [ self body parent: nil ].
	body := aSmiBlockNode.
	self body notNil ifTrue: [ self body parent: self ]
]

{ #category : #generated }
SmiConditionalNode >> condition [

	^ condition
]

{ #category : #generated }
SmiConditionalNode >> condition: aSmiAbstractNode [

	self condition notNil ifTrue: [ self condition parent: nil ].
	condition := aSmiAbstractNode.
	self condition notNil ifTrue: [ self condition parent: self ]
]

{ #category : #generated }
SmiConditionalNode >> nodeVariables [

	^ #( #condition #body )
]
