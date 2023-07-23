Class {
	#name : #SmiParser,
	#superclass : #SmaCCGLRParser,
	#category : #'Smic-Parser'
}

{ #category : #'generated-accessing' }
SmiParser class >> cacheId [
	^'2023-07-16T00:24:12.759807+02:00'
]

{ #category : #generated }
SmiParser class >> definitionComment [
"<number> : \d+;
		<whitespace> : \s+;
		<LETTER> : [a-zA-Z_];
		<IDENTIFIER>: <LETTER> (<LETTER>|\d)*;
		<STRING_LITERAL>: L? \"" ( (\\ .) | ([^\\\""]) )* \"";
		
		%glr;
		%root Abstract;
		%prefix Smi;
		%suffix Node;
		
		%left "":="";
		%left ""+"" ""-"" ""*"" ""<"" ""<="" "">"" ""="";
		
		Program : FunctionList 'functions' {{}};
		
		FunctionList
			: Function 'function' { OrderedCollection with: '1' }
			| FunctionList Function 'function'  { '1' copyWith: '2' }
			| { OrderedCollection new }
			;
		
		Function : ""function"" <IDENTIFIER> 'name' ""("" ParameterList 'parameters' "")"" Block 'body' {{Function}};

		ParameterList
			: <IDENTIFIER> 'parameter' { OrderedCollection with: '1' }
			| ParameterList "","" <IDENTIFIER> 'parameter'  { '1' copyWith: '3' }
			| { OrderedCollection new }
			;
	
		Block : ""{"" StatementList 'statements' ""}"" {{}};
		
		StatementList
			: Statement 'statement' { OrderedCollection with: '1' }
			| StatementList Statement 'Statement'  { '1' copyWith: '2' }
			| { OrderedCollection new }
			;
		
		Statement
			: ""return"" Expression 'expression' "";"" {{Return}}
			| ""if"" Expression 'condition' ""then"" Block 'body' {{Conditional}}
			| Expression 'expression' "";"" { '1' }
			| ""Print"" <STRING_LITERAL> 'string' "";"" {{PrintStatement}}
			;
		
		ExpressionList
			: Expression 'expression' { OrderedCollection with: '1' }
			| ExpressionList "","" Expression 'expression'  { '1' copyWith: '3' }
			| { OrderedCollection new }
			;
		
		Expression
			: <number> 'value' {{Number}}
			| <IDENTIFIER> 'variable' {{VariableRead}}
			| <IDENTIFIER> 'variable' ""["" Expression 'index' ""]""  {{ArrayRead}}
			| ""Array"" ""["" Expression 'size' ""]""  {{Array}}
			| Expression 'array' ""."" ""size""  {{ArraySize}}
			| <IDENTIFIER> 'variable' "":="" Expression 'value' {{Assignment}}
			| <IDENTIFIER> 'variable' ""["" Expression 'index' ""]"" "":="" Expression 'value' {{ArrayWrite}}
			| Expression 'left' BinaryOperator 'operator' Expression 'right' {{BinaryOperator}}
			| <IDENTIFIER> 'functionName' ""("" ExpressionList 'arguments' "")"" {{FunctionCall}}
			;
		BinaryOperator : ""+"" | ""-"" | ""*"" | ""/"" | ""<"" | ""<="" | ""="" | "">"" | "">="";"
]

{ #category : #'generated-accessing' }
SmiParser class >> scannerClass [
	^SmiScanner
]

{ #category : #generated }
SmiParser class >> startingStateForProgram [

	^ 1
]

{ #category : #generated }
SmiParser >> ambiguousTransitions [
^#(
#[ 0 6 0 9] 
#[ 0 30 0 65] 
#[ 0 30 0 69] 
#[ 0 30 0 73] 
#[ 0 30 0 77] 
#[ 0 30 0 81] 
#[ 0 30 0 85] 
#[ 0 86 0 161] 
#[ 0 86 0 169] 
#[ 0 86 0 173] 
#[ 0 94 0 161] 
#[ 0 94 0 169] 
#[ 0 94 0 173] 
#[ 0 118 0 161] 
#[ 0 118 0 169] 
#[ 0 118 0 173]
	).
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForBinaryOperator7: nodes [

	^ nodes at: 1
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForBlock1: nodes [

	| result |
	result := SmiBlockNode new.
	result statements: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForExpression1: nodes [

	| result |
	result := SmiNumberNode new.
	result value: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForExpression2: nodes [

	| result |
	result := SmiVariableReadNode new.
	result variable: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForExpression3: nodes [

	| result |
	result := SmiArrayReadNode new.
	result variable: (nodes at: 1).
	result index: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForExpression4: nodes [

	| result |
	result := SmiArrayNode new.
	result _size: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForExpression5: nodes [

	| result |
	result := SmiArraySizeNode new.
	result array: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForExpression6: nodes [

	| result |
	result := SmiAssignmentNode new.
	result variable: (nodes at: 1).
	result value: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForExpression7: nodes [

	| result |
	result := SmiArrayWriteNode new.
	result variable: (nodes at: 1).
	result index: (nodes at: 3).
	result value: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForExpression8: nodes [

	| result |
	result := SmiBinaryOperatorNode new.
	result left: (nodes at: 1).
	result operator: (nodes at: 2).
	result right: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForExpression9: nodes [

	| result |
	result := SmiFunctionCallNode new.
	result functionName: (nodes at: 1).
	result arguments: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForFunction1: nodes [

	| result |
	result := SmiFunctionNode new.
	result name: (nodes at: 2).
	result parameters: (nodes at: 4).
	result body: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForFunctionList1: nodes [

	^ OrderedCollection with: (nodes at: 1)
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForFunctionList2: nodes [

	^ (nodes at: 1) copyWith: (nodes at: 2)
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForFunctionList3: nodes [

	^ OrderedCollection new
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForParameterList2: nodes [

	^ (nodes at: 1) copyWith: (nodes at: 3)
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForProgram1: nodes [

	| result |
	result := SmiProgramNode new.
	result functions: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForStatement1: nodes [

	| result |
	result := SmiReturnNode new.
	result expression: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForStatement2: nodes [

	| result |
	result := SmiConditionalNode new.
	result condition: (nodes at: 2).
	result body: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
SmiParser >> reduceActionForStatement4: nodes [

	| result |
	result := SmiPrintStatementNode new.
	result string: (nodes at: 2).
	^ result
]

{ #category : #generated }
SmiParser >> reduceTable [
^#(
	#(39 0 #reduceActionForFunctionList3:) 
	#(39 1 #reduceActionForFunctionList1:) 
	#(37 1 #reduceActionForProgram1:) 
	#(39 2 #reduceActionForFunctionList2:) 
	#(32 0 #reduceActionForFunctionList3:) 
	#(32 1 #reduceActionForFunctionList1:) 
	#(34 0 #reduceActionForFunctionList3:) 
	#(31 6 #reduceActionForFunction1:) 
	#(32 3 #reduceActionForParameterList2:) 
	#(36 1 #reduceActionForExpression1:) 
	#(36 1 #reduceActionForExpression2:) 
	#(34 1 #reduceActionForFunctionList1:) 
	#(38 0 #reduceActionForFunctionList3:) 
	#(33 3 #reduceActionForBlock1:) 
	#(34 2 #reduceActionForFunctionList2:) 
	#(40 1 #reduceActionForBinaryOperator7:) 
	#(35 2 #reduceActionForBinaryOperator7:) 
	#(35 3 #reduceActionForStatement1:) 
	#(35 3 #reduceActionForStatement4:) 
	#(38 1 #reduceActionForFunctionList1:) 
	#(36 3 #reduceActionForExpression6:) 
	#(36 3 #reduceActionForExpression5:) 
	#(36 3 #reduceActionForExpression8:) 
	#(36 4 #reduceActionForExpression4:) 
	#(35 4 #reduceActionForStatement2:) 
	#(36 4 #reduceActionForExpression9:) 
	#(36 4 #reduceActionForExpression3:) 
	#(38 3 #reduceActionForParameterList2:) 
	#(36 6 #reduceActionForExpression7:)
	).
]

{ #category : #generated }
SmiParser >> symbolNames [

	^ #( '"="' '"function"' '"("' '")"' '"<="' '">"' '","' '":="' '"+"'
	     '"-"' '"*"' '">="' '"<"' '"{"' '"Array"' '"."' '"size"' '"/"'
	     '"["' '"]"' '"}"' '"return"' '"Print"' '";"' '"then"' '"if"'
	     '<number>' '<whitespace>' '<IDENTIFIER>' '<STRING_LITERAL>'
	     'Function' 'ParameterList' 'Block' 'StatementList'
	     'Statement' 'Expression' 'Program' 'ExpressionList'
	     'FunctionList' 'BinaryOperator' 'E O F' 'error' 'B e g i n' )
]

{ #category : #generated }
SmiParser >> symbolTypes [

	^ #( #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken
	     #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken
	     #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken
	     #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken
	     #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken
	     #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken
	     #SmiFunctionNode #Object #SmiBlockNode #Object #SmiAbstractNode
	     #SmiAbstractNode #SmiProgramNode #Object #Object #SmaCCToken
	     #SmaCCToken #SmaCCToken #SmiProgramNode )
]

{ #category : #generated }
SmiParser >> transitionTable [
^#(
#[1 0 7 0 2 0 13 0 31 0 17 0 37 0 21 0 39 0 6 0 41] 
#[0 0 25 0 29] 
#[0 0 10 0 2 0 41] 
#[0 0 0 0 41] 
#[1 0 9 0 2 0 29 0 31 0 14 0 41] 
#[0 0 33 0 3] 
#[0 0 18 0 2 0 41] 
#[1 0 22 0 4 0 22 0 7 0 37 0 29 0 41 0 32] 
#[0 0 26 0 4 0 7] 
#[1 0 45 0 4 0 49 0 7] 
#[1 0 53 0 14 0 57 0 33] 
#[0 0 61 0 29] 
#[1 0 11 0 15 0 30 0 21 0 15 0 22 0 19 0 23 0 23 0 26 0 27 0 27 0 31 0 29 0 89 0 34 0 93 0 35 0 97 0 36] 
#[0 0 34 0 2 0 41] 
#[0 0 38 0 4 0 7] 
#[0 0 101 0 19] 
#[1 0 65 0 15 0 81 0 27 0 85 0 29 0 105 0 36] 
#[0 0 109 0 30] 
#[1 0 65 0 15 0 81 0 27 0 85 0 29 0 113 0 36] 
#[0 0 42 0 1 0 4 0 5 0 6 0 7 0 9 0 10 0 11 0 12 0 13 0 16 0 18 0 20 0 24 0 25] 
#[1 0 46 0 1 0 117 0 3 0 46 0 4 0 46 0 5 0 46 0 6 0 46 0 7 0 121 0 8 0 46 0 9 0 46 0 10 0 46 0 11 0 46 0 12 0 46 0 13 0 46 0 16 0 46 0 18 0 125 0 19 0 46 0 20 0 46 0 24 0 46 0 25] 
#[1 0 65 0 15 0 129 0 21 0 69 0 22 0 73 0 23 0 77 0 26 0 81 0 27 0 85 0 29 0 133 0 35 0 97 0 36] 
#[0 0 50 0 15 0 21 0 22 0 23 0 26 0 27 0 29] 
#[1 0 137 0 1 0 141 0 5 0 145 0 6 0 149 0 9 0 153 0 10 0 157 0 11 0 161 0 12 0 165 0 13 0 169 0 16 0 173 0 18 0 177 0 24 0 181 0 40] 
#[1 0 65 0 15 0 81 0 27 0 85 0 29 0 185 0 36] 
#[1 0 137 0 1 0 141 0 5 0 145 0 6 0 149 0 9 0 153 0 10 0 157 0 11 0 161 0 12 0 165 0 13 0 169 0 16 0 173 0 18 0 189 0 24 0 181 0 40] 
#[0 0 193 0 24] 
#[1 0 137 0 1 0 141 0 5 0 145 0 6 0 149 0 9 0 153 0 10 0 157 0 11 0 161 0 12 0 165 0 13 0 169 0 16 0 173 0 18 0 197 0 25 0 181 0 40] 
#[1 0 54 0 4 0 54 0 7 0 65 0 15 0 81 0 27 0 85 0 29 0 201 0 36 0 205 0 38] 
#[1 0 65 0 15 0 81 0 27 0 85 0 29 0 209 0 36] 
#[1 0 65 0 15 0 81 0 27 0 85 0 29 0 213 0 36] 
#[0 0 58 0 2 0 15 0 21 0 22 0 23 0 26 0 27 0 29 0 41] 
#[0 0 62 0 15 0 21 0 22 0 23 0 26 0 27 0 29] 
#[0 0 66 0 15 0 27 0 29] 
#[0 0 66 0 15 0 27 0 29] 
#[0 0 66 0 15 0 27 0 29] 
#[0 0 66 0 15 0 27 0 29] 
#[0 0 66 0 15 0 27 0 29] 
#[0 0 66 0 15 0 27 0 29] 
#[0 0 66 0 15 0 27 0 29] 
#[0 0 66 0 15 0 27 0 29] 
#[0 0 217 0 17] 
#[0 0 66 0 15 0 27 0 29] 
#[0 0 70 0 15 0 21 0 22 0 23 0 26 0 27 0 29] 
#[1 0 65 0 15 0 81 0 27 0 85 0 29 0 221 0 36] 
#[1 0 137 0 1 0 141 0 5 0 145 0 6 0 149 0 9 0 153 0 10 0 157 0 11 0 161 0 12 0 165 0 13 0 169 0 16 0 173 0 18 0 225 0 20 0 181 0 40] 
#[0 0 74 0 15 0 21 0 22 0 23 0 26 0 27 0 29] 
#[0 0 78 0 15 0 21 0 22 0 23 0 26 0 27 0 29] 
#[1 0 53 0 14 0 229 0 33] 
#[1 0 137 0 1 0 82 0 4 0 141 0 5 0 145 0 6 0 82 0 7 0 149 0 9 0 153 0 10 0 157 0 11 0 161 0 12 0 165 0 13 0 169 0 16 0 173 0 18 0 181 0 40] 
#[1 0 233 0 4 0 237 0 7] 
#[1 0 137 0 1 0 86 0 4 0 141 0 5 0 145 0 6 0 86 0 7 0 149 0 9 0 153 0 10 0 157 0 11 0 35 0 12 0 165 0 13 0 39 0 16 0 43 0 18 0 86 0 20 0 86 0 24 0 86 0 25 0 181 0 40] 
#[1 0 137 0 1 0 141 0 5 0 145 0 6 0 149 0 9 0 153 0 10 0 157 0 11 0 161 0 12 0 165 0 13 0 169 0 16 0 173 0 18 0 241 0 20 0 181 0 40] 
#[0 0 90 0 1 0 4 0 5 0 6 0 7 0 9 0 10 0 11 0 12 0 13 0 16 0 18 0 20 0 24 0 25] 
#[1 0 137 0 1 0 94 0 4 0 141 0 5 0 145 0 6 0 94 0 7 0 149 0 9 0 153 0 10 0 157 0 11 0 47 0 12 0 165 0 13 0 51 0 16 0 55 0 18 0 94 0 20 0 94 0 24 0 94 0 25 0 181 0 40] 
#[0 0 98 0 1 0 4 0 5 0 6 0 7 0 9 0 10 0 11 0 12 0 13 0 16 0 18 0 20 0 24 0 25] 
#[0 0 102 0 15 0 21 0 22 0 23 0 26 0 27 0 29] 
#[0 0 106 0 1 0 4 0 5 0 6 0 7 0 9 0 10 0 11 0 12 0 13 0 16 0 18 0 20 0 24 0 25] 
#[1 0 65 0 15 0 81 0 27 0 85 0 29 0 245 0 36] 
#[1 0 110 0 1 0 110 0 4 0 110 0 5 0 110 0 6 0 110 0 7 0 249 0 8 0 110 0 9 0 110 0 10 0 110 0 11 0 110 0 12 0 110 0 13 0 110 0 16 0 110 0 18 0 110 0 20 0 110 0 24 0 110 0 25] 
#[1 0 137 0 1 0 114 0 4 0 141 0 5 0 145 0 6 0 114 0 7 0 149 0 9 0 153 0 10 0 157 0 11 0 161 0 12 0 165 0 13 0 169 0 16 0 173 0 18 0 181 0 40] 
#[1 0 65 0 15 0 81 0 27 0 85 0 29 0 253 0 36] 
#[1 0 137 0 1 0 118 0 4 0 141 0 5 0 145 0 6 0 118 0 7 0 149 0 9 0 153 0 10 0 157 0 11 0 59 0 12 0 165 0 13 0 63 0 16 0 67 0 18 0 118 0 20 0 118 0 24 0 118 0 25 0 181 0 40]
	).
]
