Extension { #name : #SmiObject }

{ #category : #'*Smic-Tools' }
SmiObject >> debug [
	
	SmicMachineCodeDebugger openOnSimulator: self simulator ip: 4096
]
