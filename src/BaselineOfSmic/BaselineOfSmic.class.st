"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #BaselineOfSmic,
	#superclass : #BaselineOf,
	#category : #BaselineOfSmic
}

{ #category : #baseline }
BaselineOfSmic >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			baseline: 'Phuzzer'
				with: [ spec repository: 'github://alamvic/phuzzer:main' ];
			baseline: 'Druid'
				with: [ spec repository: 'github://alamvic/druid:smic' ];
			package: 'Smic-Compiler'
				with: [ spec requires: #( 'Phuzzer' 'Druid' ) ];
			package: 'Smic-Parser' with: [ spec requires: #( 'Druid' ) ];
			package: 'Smic-Runner'
				with: [ spec requires: #( 'Smic-Compiler' ) ];
			package: 'Smic-Tools'
				with: [ spec requires: #( 'Smic-Compiler' 'Smic-Runner' ) ] ]
]
