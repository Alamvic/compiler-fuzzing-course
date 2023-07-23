Class {
	#name : #SmiProgramNode,
	#superclass : #SmiAbstractNode,
	#instVars : [
		'functions'
	],
	#category : #'Smic-Parser'
}

{ #category : #generated }
SmiProgramNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitProgram: self
]

{ #category : #generated }
SmiProgramNode >> functions [

	^ functions
]

{ #category : #generated }
SmiProgramNode >> functions: anObject [

	functions := anObject
]

{ #category : #generated }
SmiProgramNode >> otherVariables [

	^ #( #functions )
]
