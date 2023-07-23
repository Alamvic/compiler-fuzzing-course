Class {
	#name : #SmiFunctionCallNode,
	#superclass : #SmiAbstractNode,
	#instVars : [
		'functionName',
		'arguments'
	],
	#category : #'Smic-Parser'
}

{ #category : #generated }
SmiFunctionCallNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitFunctionCall: self
]

{ #category : #generated }
SmiFunctionCallNode >> arguments [

	^ arguments
]

{ #category : #generated }
SmiFunctionCallNode >> arguments: anObject [

	arguments := anObject
]

{ #category : #generated }
SmiFunctionCallNode >> functionName [

	^ functionName
]

{ #category : #generated }
SmiFunctionCallNode >> functionName: aSmaCCToken [

	functionName := aSmaCCToken
]

{ #category : #generated }
SmiFunctionCallNode >> otherVariables [

	^ #( #arguments )
]

{ #category : #generated }
SmiFunctionCallNode >> tokenVariables [

	^ #( #functionName )
]
