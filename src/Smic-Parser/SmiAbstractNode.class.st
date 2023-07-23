Class {
	#name : #SmiAbstractNode,
	#superclass : #SmaCCParseNode,
	#category : #'Smic-Parser'
}

{ #category : #generated }
SmiAbstractNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitAbstract: self
]
