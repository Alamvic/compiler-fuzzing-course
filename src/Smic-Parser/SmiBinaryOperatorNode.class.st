Class {
	#name : #SmiBinaryOperatorNode,
	#superclass : #SmiAbstractNode,
	#instVars : [
		'left',
		'operator',
		'right'
	],
	#category : #'Smic-Parser'
}

{ #category : #generated }
SmiBinaryOperatorNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitBinaryOperator: self
]

{ #category : #generated }
SmiBinaryOperatorNode >> left [

	^ left
]

{ #category : #generated }
SmiBinaryOperatorNode >> left: aSmiAbstractNode [

	self left notNil ifTrue: [ self left parent: nil ].
	left := aSmiAbstractNode.
	self left notNil ifTrue: [ self left parent: self ]
]

{ #category : #generated }
SmiBinaryOperatorNode >> nodeVariables [

	^ #( #left #right )
]

{ #category : #generated }
SmiBinaryOperatorNode >> operator [

	^ operator
]

{ #category : #generated }
SmiBinaryOperatorNode >> operator: aSmaCCToken [

	operator := aSmaCCToken
]

{ #category : #generated }
SmiBinaryOperatorNode >> right [

	^ right
]

{ #category : #generated }
SmiBinaryOperatorNode >> right: aSmiAbstractNode [

	self right notNil ifTrue: [ self right parent: nil ].
	right := aSmiAbstractNode.
	self right notNil ifTrue: [ self right parent: self ]
]

{ #category : #generated }
SmiBinaryOperatorNode >> tokenVariables [

	^ #( #operator )
]
