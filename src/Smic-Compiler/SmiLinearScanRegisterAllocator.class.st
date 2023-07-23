Class {
	#name : #SmiLinearScanRegisterAllocator,
	#superclass : #DRCogitLinearScanRegisterAllocator,
	#instVars : [
		'returnValueRegister'
	],
	#category : #'Smic-Compiler-Backend'
}

{ #category : #steps }
SmiLinearScanRegisterAllocator >> assignRegisterToResultInInstruction: i [

	| liveIntervals currentLiveInterval |
	super assignRegisterToResultInInstruction: i.
	i isCall ifFalse: [ ^ self ].

	"Calling convention states that all registers are callee saved and return value comes in a register.
	Move the return value to the allocated register.
	Then restore from the stack all registers that were saved after this instruction."
	currentLiveInterval := self liveSetOf: i.
	liveIntervals := (liveSets values asSet sorted: [ :a :b |
		                  a start < b start ]) select: [ :e |
		                 e ~= currentLiveInterval and: [
			                 e isActiveAt: currentLiveInterval start ] ].
	liveIntervals do: [ :interval |
		i addNext: ((DRPop operands: #(  )) result: interval location) ].
	i addNext: ((i instructionFactory copy: self returnValueRegister)
			 result: i result;
			 yourself)
]

{ #category : #steps }
SmiLinearScanRegisterAllocator >> assignRegistersToOperandsInInstruction: i [

	| liveIntervals currentLiveInterval |
	super assignRegistersToOperandsInInstruction: i.
	i isCall ifFalse: [ ^ self ].

	"Calling convention states that all registers are callee saved.
	Save in the stack all registers that are still live after this instruction."
	currentLiveInterval := self liveSetOf: i.
	liveIntervals := (liveSets values asSet sorted: [ :a :b |
		                  a start < b start ]) select: [ :e |
		                 e ~= currentLiveInterval and: [
			                 e isActiveAt: currentLiveInterval start ] ].
	liveIntervals do: [ :interval |
		i addBefore: (DRPush operands: { interval location }) ]
]

{ #category : #'calling convention' }
SmiLinearScanRegisterAllocator >> returnValueRegister [
	
	^ returnValueRegister
]

{ #category : #accessing }
SmiLinearScanRegisterAllocator >> returnValueRegister: aDRPhysicalGeneralPurposeRegister [ 
	returnValueRegister := aDRPhysicalGeneralPurposeRegister
]
