"Randomly generate some inputs with default values"
PzRandomFuzzer new fuzz.

"Do not generate inputs above 10 characters"
PzRandomFuzzer new
	maxLength: 10;
	fuzz.

"Only generate characters between $A and $A+50"
PzRandomFuzzer new
	charStart: $A;
	charRange: 50;
	fuzz
