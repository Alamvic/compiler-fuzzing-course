Class {
	#name : #SmiSimulator,
	#superclass : #Object,
	#instVars : [
		'unicorn',
		'architecture',
		'registerAliases'
	],
	#category : #'Smic-Runner'
}

{ #category : #'instance creation' }
SmiSimulator class >> X64 [
	
	^ self new
		initializeForArchitecture: #x8664;
		yourself
]

{ #category : #'instance creation' }
SmiSimulator class >> aarch64 [
	
	^ self new
		initializeForArchitecture: #arm64;
		yourself
]

{ #category : #accessing }
SmiSimulator >> aliasForRegister: aRegisterName [

	^ registerAliases at: aRegisterName ifAbsent: [ '' ]
]

{ #category : #copying }
SmiSimulator >> copyFrom: anInteger to: anInteger2 [ 
	
	^ unicorn memoryAt: anInteger readNext: anInteger2 - anInteger + 1
]

{ #category : #disassembling }
SmiSimulator >> disassembler [

	^ LLVMDisassembler perform: (architecture = #x8664
			   ifTrue: [ #amd64 ]
			   ifFalse: [ architecture ])
]

{ #category : #accessing }
SmiSimulator >> fp [
	
	^ (unicorn readRegisterId: self framePointerRegisterID size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> framePointerRegisterID [

	architecture = #x8664 ifTrue: [ ^ UcX86Registers rbp value ].
	architecture = #arm64 ifTrue: [ ^ UcARM64Registers fp value ].

	self error: 'Unsupported architecture'
]

{ #category : #accessing }
SmiSimulator >> initialize [

	super initialize.
	registerAliases := Dictionary new
]

{ #category : #initialization }
SmiSimulator >> initializeForArchitecture: aString [ 
	
	architecture := aString.
	unicorn := Unicorn perform: aString
]

{ #category : #running }
SmiSimulator >> instructionPointer [

	^ (unicorn readRegisterId: self instructionPointerRegisterID size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #running }
SmiSimulator >> instructionPointer: aValue [

	| buffer |
	buffer := ByteArray new: 8.
	buffer integerAt: 1 put: aValue size: 8 signed: false.
	unicorn
		register: self instructionPointerRegisterID
		write: buffer
]

{ #category : #running }
SmiSimulator >> instructionPointerRegisterID [
		
	architecture = #x8664 ifTrue: [ ^ UcX86Registers rip value ].
	architecture = #arm64 ifTrue: [ ^ UcARM64Registers pc value ].
	
	self error: 'Unsupported architecture'
]

{ #category : #running }
SmiSimulator >> linkRegister [

	^ (unicorn readRegisterId: self linkRegisterID size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #running }
SmiSimulator >> linkRegister: aValue [

	| buffer |
	buffer := ByteArray new: 8.
	buffer integerAt: 1 put: aValue size: 8 signed: false.
	unicorn
		register: self linkRegisterID
		write: buffer
]

{ #category : #running }
SmiSimulator >> linkRegisterID [

	architecture = #arm64 ifTrue: [ ^ UcARM64Registers lr value ].

	self error: 'Unsupported architecture'
]

{ #category : #accessing }
SmiSimulator >> lr [
	
	"Move down"
	self assert: architecture = #arm64.
	^ self linkRegister
]

{ #category : #memory }
SmiSimulator >> mapHostMemory: aCollection atAddress: anInteger [

	unicorn
		mapHostMemory: aCollection
		atAddress: anInteger
		withPermissions: UnicornConstants permissionAll
]

{ #category : #accessing }
SmiSimulator >> memoryAt: anInteger readNext: anInteger2 [ 
	
	^ unicorn memoryAt: anInteger readNext: anInteger2
]

{ #category : #enumerating }
SmiSimulator >> onInvalidMemoryAccessDo: aFullBlockClosure [

	unicorn
		registerInvalidMemoryAccessHook:
		UcHookType invalidMemoryAccess value
		doing: [ :type :address :size :value |
			aFullBlockClosure
				value: type
				value: address
				value: size
				value: value.
			false ]
]

{ #category : #accessing }
SmiSimulator >> pc [

	"Move down"
	self assert: architecture = #arm64.
	^ self instructionPointer 
]

{ #category : #running }
SmiSimulator >> pop [

	| buffer |
	buffer := unicorn memoryAt: self stackPointer readNext: 8.
	self stackPointer: self stackPointer + 8.
	^ buffer int64AtOffset: 0
]

{ #category : #accessing }
SmiSimulator >> popReturnAddress [

	^ architecture = #x8664
		ifFalse: [ "RISC" self linkRegister ]
		ifTrue: [ "CISC" self pop ]
]

{ #category : #running }
SmiSimulator >> push: aValue [

	| buffer |
	self stackPointer: self stackPointer - 8.
	buffer := ByteArray new: 8.
	buffer int64AtOffset: 0 put: aValue.
	unicorn memoryAt: self stackPointer write: buffer
]

{ #category : #'as yet unclassified' }
SmiSimulator >> r10 [

	"Move down"
	self assert: architecture = #x8664.
	^ (unicorn readRegisterId: UcX86Registers r10 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> r11 [

	"Move down"
	self assert: architecture = #x8664.
	^ (unicorn readRegisterId: UcX86Registers r11 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> r12 [

	"Move down"
	self assert: architecture = #x8664.
	^ (unicorn readRegisterId: UcX86Registers r12 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> r8 [

	"Move down"
	self assert: architecture = #x8664.
	^ (unicorn readRegisterId: UcX86Registers r8 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> r9 [

	"Move down"
	self assert: architecture = #x8664.
	^ (unicorn readRegisterId: UcX86Registers r9 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #accessing }
SmiSimulator >> rax [

	"Move down"
	self assert: architecture = #x8664.
	^ (unicorn readRegisterId: UcX86Registers rax size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> rbp [

	"Move down"
	self assert: architecture = #x8664.
	^ (unicorn readRegisterId: UcX86Registers rbp size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> rbx [

	"Move down"
	self assert: architecture = #x8664.
	^ (unicorn readRegisterId: UcX86Registers rbx size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> rcx [

	"Move down"
	self assert: architecture = #x8664.
	^ (unicorn readRegisterId: UcX86Registers rcx size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> rdi [

	"Move down"
	self assert: architecture = #x8664.
	^ (unicorn readRegisterId: UcX86Registers rdi size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> rdx [

	"Move down"
	self assert: architecture = #x8664.
	^ (unicorn readRegisterId: UcX86Registers rdx size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #accessing }
SmiSimulator >> registerList [

	architecture = #arm64 ifTrue: [
		^ #( lr pc sp fp x28 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x16
		     x19 x20 x21 x22 x23 x24 x25 x26 x27 "zero negative carry overflow
		     v0 v1 v2" ) ].

	architecture = #x8664 ifTrue: [
		^ #(rip rax rbx rcx rdx rsp rbp r8 r9 r10 r11 r12 rsi rdi) ].
	self halt
]

{ #category : #accessing }
SmiSimulator >> returnAddress: returnAddress [

	architecture = #x8664
		ifFalse: [ "RISC" self linkRegister: returnAddress ]
		ifTrue: [ "CISC" self push: returnAddress ]
]

{ #category : #running }
SmiSimulator >> returnRegisterID [

	architecture = #x8664 ifTrue: [ ^ UcX86Registers rax value ].
	architecture = #arm64 ifTrue: [ ^ UcARM64Registers x0 value ].

	self error: 'Unsupported architecture'
]

{ #category : #accessing }
SmiSimulator >> returnValue [

	^ (unicorn readRegisterId: self returnRegisterID size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'phisical-registers' }
SmiSimulator >> rip [

	"Move down"
	self assert: architecture = #x8664.
	^ (unicorn readRegisterId: UcX86Registers rip size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> rsi [

	"Move down"
	self assert: architecture = #x8664.
	^ (unicorn readRegisterId: UcX86Registers rsi size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> rsp [

	"Move down"
	self assert: architecture = #x8664.
	^ (unicorn readRegisterId: UcX86Registers rsp size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #helpers }
SmiSimulator >> runFrom: startAddress until: returnAddress [

	unicorn
		doStartAt: startAddress
		until: returnAddress
		timeout: 0
		count: 0
]

{ #category : #accessing }
SmiSimulator >> sp [
	
	^ self stackPointer
]

{ #category : #running }
SmiSimulator >> stackPointer [

	^ (unicorn readRegisterId: self stackPointerRegisterID size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #running }
SmiSimulator >> stackPointer: aValue [

	| buffer |
	buffer := ByteArray new: 8.
	buffer integerAt: 1 put: aValue size: 8 signed: false.
	unicorn
		register: self stackPointerRegisterID
		write: buffer
]

{ #category : #running }
SmiSimulator >> stackPointerRegisterID [

	architecture = #x8664 ifTrue: [ ^ UcX86Registers rsp value ].
	architecture = #arm64 ifTrue: [ ^ UcARM64Registers x28 value ].

	self error: 'Unsupported architecture'
]

{ #category : #stepping }
SmiSimulator >> step [

	unicorn
		doStartAt: self instructionPointer
		until: 0
		timeout: 0
		count: 1
]

{ #category : #memory }
SmiSimulator >> wordAt: anAddress [

	^ unicorn memoryAt: anAddress readNext: 8
]

{ #category : #accessing }
SmiSimulator >> x0 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x0 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x1 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x1 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x10 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x10 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x11 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x11 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x12 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x12 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x13 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x13 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x14 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x14 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x15 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x15 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x16 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x16 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x17 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x17 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x18 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x18 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x19 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x19 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x2 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x2 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x20 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x20 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x21 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x21 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x22 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x22 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x23 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x23 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x24 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x24 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x25 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x25 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x26 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x26 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x27 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x27 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #register }
SmiSimulator >> x28 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x28 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x3 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x3 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x4 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x4 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x5 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x5 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x6 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x6 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x7 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x7 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x8 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x8 size: 8)
		  int64AtOffset: 0 "bytes"
]

{ #category : #'as yet unclassified' }
SmiSimulator >> x9 [

	"Move down"
	self assert: architecture = #arm64.
	^ (unicorn readRegisterId: UcARM64Registers x9 size: 8)
		  int64AtOffset: 0 "bytes"
]
