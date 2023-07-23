Extension { #name : #SmiSimulator }

{ #category : #'*Smic-Tools' }
SmiSimulator >> registerDescriptors [

	^ self registerList collect: [ :reg |
		SmicRegisterDescriptor new
			simulator: self;
			alias: (self aliasForRegister: reg);
			name: reg;
			yourself ]
]

{ #category : #'*Smic-Tools' }
SmiSimulator >> stackValues [

	| initialValue |
	initialValue := self stackPointer.

	^ (1 to: 30) collect: [ :anIndex |
		SmicMachineCodeDebuggerStackItem address: initialValue + (8 * (anIndex - 1)) on: self.
	]
]
