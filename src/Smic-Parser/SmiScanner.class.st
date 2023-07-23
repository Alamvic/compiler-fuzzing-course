Class {
	#name : #SmiScanner,
	#superclass : #SmaCCScanner,
	#category : #'Smic-Parser'
}

{ #category : #'generated-initialization' }
SmiScanner class >> initializeKeywordMap [

	keywordMap := Dictionary new.
	#( #( 29 'Array' 15 ) #( 29 'Print' 23 ) #( 29 'function' 2 )
	   #( 29 'if' 26 ) #( 29 'return' 22 ) #( 29 'size' 17 )
	   #( 29 'then' 25 ) ) do: [ :each |
		(keywordMap at: each first ifAbsentPut: [ Dictionary new ])
			at: (each at: 2)
			put: each last ].
	^ keywordMap
]

{ #category : #generated }
SmiScanner class >> states [

	^ #( #default )
]

{ #category : #generated }
SmiScanner >> emptySymbolTokenId [

	^ 41
]

{ #category : #generated }
SmiScanner >> errorTokenId [

	^ 42
]

{ #category : #generated }
SmiScanner >> scan1 [

	[
	self step.
	currentCharacter isDoubleQuote ifTrue: [
		^ self recordAndReportMatch: #( 30 ) ].
	currentCharacter == $\ ifTrue: [
		self step.
		^ self scan1 ].
	true ] whileTrue
]

{ #category : #generated }
SmiScanner >> scanForToken [

	self step.
	currentCharacter isDoubleQuote ifTrue: [ ^ self scan1 ].
	currentCharacter == $( ifTrue: [ ^ self recordAndReportMatch: #( 3 ) ].
	currentCharacter == $) ifTrue: [ ^ self recordAndReportMatch: #( 4 ) ].
	currentCharacter == $* ifTrue: [
		^ self recordAndReportMatch: #( 11 ) ].
	currentCharacter == $+ ifTrue: [ ^ self recordAndReportMatch: #( 9 ) ].
	currentCharacter == $, ifTrue: [ ^ self recordAndReportMatch: #( 7 ) ].
	currentCharacter == $- ifTrue: [
		^ self recordAndReportMatch: #( 10 ) ].
	currentCharacter == $. ifTrue: [
		^ self recordAndReportMatch: #( 16 ) ].
	currentCharacter == $/ ifTrue: [
		^ self recordAndReportMatch: #( 18 ) ].
	currentCharacter == $: ifTrue: [ ^ self scanForTokenX7 ].
	currentCharacter == $; ifTrue: [
		^ self recordAndReportMatch: #( 24 ) ].
	currentCharacter == $< ifTrue: [ ^ self scanForTokenX5 ].
	^ self scanForTokenX8
]

{ #category : #generated }
SmiScanner >> scanForTokenX1 [

	self recordMatch: #( 29 ).
	self step.
	currentCharacter isDoubleQuote ifTrue: [ ^ self scan1 ].
	((currentCharacter between: $0 and: $9) or: [
		 (currentCharacter between: $A and: $Z) or: [
			 currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ])
		ifTrue: [
			[
			self recordMatch: #( 29 ).
			self step.
			(currentCharacter between: $0 and: $9) or: [
				(currentCharacter between: $A and: $Z) or: [
					currentCharacter == $_ or: [
						currentCharacter between: $a and: $z ] ] ] ] whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SmiScanner >> scanForTokenX2 [

	[
	self recordMatch: #( 29 ).
	self step.
	(currentCharacter between: $0 and: $9) or: [
		(currentCharacter between: $A and: $Z) or: [
			currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
		whileTrue
]

{ #category : #generated }
SmiScanner >> scanForTokenX3 [

	[
	self recordMatch: #( 28 ).
	self step.
	currentCharacter isSeparator or: [
		currentCharacter == Character pageUp ] ] whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
SmiScanner >> scanForTokenX4 [

	self recordMatch: #( 6 ).
	self step.
	currentCharacter == $= ifTrue: [
		^ self recordAndReportMatch: #( 12 ) ].
	^ self reportLastMatch
]

{ #category : #generated }
SmiScanner >> scanForTokenX5 [

	self recordMatch: #( 13 ).
	self step.
	currentCharacter == $= ifTrue: [ ^ self recordAndReportMatch: #( 5 ) ].
	^ self reportLastMatch
]

{ #category : #generated }
SmiScanner >> scanForTokenX6 [

	[
	self recordMatch: #( 27 ).
	self step.
	currentCharacter between: $0 and: $9 ] whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
SmiScanner >> scanForTokenX7 [

	self step.
	currentCharacter == $= ifTrue: [ ^ self recordAndReportMatch: #( 8 ) ].
	^ self reportLastMatch
]

{ #category : #generated }
SmiScanner >> scanForTokenX8 [

	currentCharacter == $= ifTrue: [ ^ self recordAndReportMatch: #( 1 ) ].
	currentCharacter == $> ifTrue: [ ^ self scanForTokenX4 ].
	currentCharacter == $L ifTrue: [ ^ self scanForTokenX1 ].
	currentCharacter == $[ ifTrue: [
		^ self recordAndReportMatch: #( 19 ) ].
	currentCharacter == $] ifTrue: [
		^ self recordAndReportMatch: #( 20 ) ].
	currentCharacter == ${ ifTrue: [
		^ self recordAndReportMatch: #( 14 ) ].
	currentCharacter == $} ifTrue: [
		^ self recordAndReportMatch: #( 21 ) ].
	(currentCharacter between: $0 and: $9) ifTrue: [
		^ self scanForTokenX6 ].
	(currentCharacter isSeparator or: [
		 currentCharacter == Character pageUp ]) ifTrue: [
		^ self scanForTokenX3 ].
	currentCharacter isSafeForHTTP ifTrue: [ self scanForTokenX2 ].
	^ self reportLastMatch
]

{ #category : #generated }
SmiScanner >> tokenActions [

	^ #( nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	     nil nil nil nil nil nil nil nil nil nil nil #whitespace )
]
