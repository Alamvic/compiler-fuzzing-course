Class {
	#name : #SmiIRCompilationUnit,
	#superclass : #Object,
	#instVars : [
		'functions',
		'literals'
	],
	#category : #'Smic-Compiler-Midend'
}

{ #category : #adding }
SmiIRCompilationUnit >> addFunction: aSmiIRFunction [ 
	
	functions add: aSmiIRFunction 
]

{ #category : #'compile abstract instructions' }
SmiIRCompilationUnit >> allocateLiteral: aLiteral [

	| literalId |
	literalId := literals size.
	literals at: literalId put: aLiteral.
	^ literalId
]

{ #category : #accessing }
SmiIRCompilationUnit >> functionNamed: aString [ 
	
	^ functions detect: [ :e | e name = aString ]
]

{ #category : #accessing }
SmiIRCompilationUnit >> functions [

	^ functions
]

{ #category : #accessing }
SmiIRCompilationUnit >> functions: anObject [

	functions := anObject
]

{ #category : #accessing }
SmiIRCompilationUnit >> initialize [

	super initialize.
	functions := OrderedCollection new.
	literals := Dictionary new
]

{ #category : #accessing }
SmiIRCompilationUnit >> literals [

	^ literals
]
