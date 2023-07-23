Class {
	#name : #SmiAbstractNodeVisitor,
	#superclass : #SmaCCParseNodeVisitor,
	#category : #'Smic-Parser'
}

{ #category : #generated }
SmiAbstractNodeVisitor >> visitAbstract: anAbstract [

	^ self visitSmaCCParseNode: anAbstract
]

{ #category : #generated }
SmiAbstractNodeVisitor >> visitArray: anArray [

	^ self visitAbstract: anArray
]

{ #category : #generated }
SmiAbstractNodeVisitor >> visitArrayRead: anArrayRead [

	^ self visitAbstract: anArrayRead
]

{ #category : #generated }
SmiAbstractNodeVisitor >> visitArraySize: anArraySize [

	^ self visitAbstract: anArraySize
]

{ #category : #generated }
SmiAbstractNodeVisitor >> visitArrayWrite: anArrayWrite [

	^ self visitAbstract: anArrayWrite
]

{ #category : #generated }
SmiAbstractNodeVisitor >> visitAssignment: anAssignment [

	^ self visitAbstract: anAssignment
]

{ #category : #generated }
SmiAbstractNodeVisitor >> visitBinaryOperator: aBinaryOperator [

	^ self visitAbstract: aBinaryOperator
]

{ #category : #generated }
SmiAbstractNodeVisitor >> visitBlock: aBlock [

	^ self visitAbstract: aBlock
]

{ #category : #generated }
SmiAbstractNodeVisitor >> visitConditional: aConditional [

	^ self visitAbstract: aConditional
]

{ #category : #generated }
SmiAbstractNodeVisitor >> visitFunction: aFunction [

	^ self visitAbstract: aFunction
]

{ #category : #generated }
SmiAbstractNodeVisitor >> visitFunctionCall: aFunctionCall [

	^ self visitAbstract: aFunctionCall
]

{ #category : #generated }
SmiAbstractNodeVisitor >> visitNumber: aNumber [

	^ self visitAbstract: aNumber
]

{ #category : #generated }
SmiAbstractNodeVisitor >> visitPrintStatement: aPrintStatement [

	^ self visitAbstract: aPrintStatement
]

{ #category : #generated }
SmiAbstractNodeVisitor >> visitProgram: aProgram [

	^ self visitAbstract: aProgram
]

{ #category : #generated }
SmiAbstractNodeVisitor >> visitReturn: aReturn [

	^ self visitAbstract: aReturn
]

{ #category : #generated }
SmiAbstractNodeVisitor >> visitVariableRead: aVariableRead [

	^ self visitAbstract: aVariableRead
]
