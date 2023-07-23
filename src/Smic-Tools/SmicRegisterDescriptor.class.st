Class {
	#name : #SmicRegisterDescriptor,
	#superclass : #Object,
	#instVars : [
		'simulator',
		'name',
		'alias'
	],
	#category : #'Smic-Tools'
}

{ #category : #accessing }
SmicRegisterDescriptor >> alias [
	^ alias
]

{ #category : #accessing }
SmicRegisterDescriptor >> alias: aString [ 
	
	alias := aString
]

{ #category : #actions }
SmicRegisterDescriptor >> copyValueToClipboard [
	
	Clipboard clipboardText: self value hex
]

{ #category : #actions }
SmicRegisterDescriptor >> inspectValue [

	self value inspect
]

{ #category : #accessing }
SmicRegisterDescriptor >> name [
	^ name
]

{ #category : #accessing }
SmicRegisterDescriptor >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SmicRegisterDescriptor >> printOn: aStream [

	(self value isKindOf: Boolean )
		ifTrue: [ ^ aStream print: self value ].
		
	aStream print: self value hex	

]

{ #category : #actions }
SmicRegisterDescriptor >> printValue [

	simulator memory interpreter longPrintOop: self value
]

{ #category : #accessing }
SmicRegisterDescriptor >> simulator [
	^ simulator
]

{ #category : #accessing }
SmicRegisterDescriptor >> simulator: anObject [
	simulator := anObject
]

{ #category : #accessing }
SmicRegisterDescriptor >> value [

	^ simulator perform: name
]
