Class {
	#name : #SmiAssignmentNode,
	#superclass : #SmiAbstractNode,
	#instVars : [
		'variable',
		'value'
	],
	#category : #'Smic-Parser'
}

{ #category : #generated }
SmiAssignmentNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitAssignment: self
]

{ #category : #generated }
SmiAssignmentNode >> nodeVariables [

	^ #( #value )
]

{ #category : #generated }
SmiAssignmentNode >> tokenVariables [

	^ #( #variable )
]

{ #category : #generated }
SmiAssignmentNode >> value [

	^ value
]

{ #category : #generated }
SmiAssignmentNode >> value: aSmiAbstractNode [

	self value notNil ifTrue: [ self value parent: nil ].
	value := aSmiAbstractNode.
	self value notNil ifTrue: [ self value parent: self ]
]

{ #category : #generated }
SmiAssignmentNode >> variable [

	^ variable
]

{ #category : #generated }
SmiAssignmentNode >> variable: aSmaCCToken [

	variable := aSmaCCToken
]
