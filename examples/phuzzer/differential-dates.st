f := PzGrammarFuzzer on: PzDateDDMMYYYYGrammar new.

runnerA := PzBlockRunner on: [ :e | Date readFrom: e readStream ].
runnerA expectedException: DateError.
runnerB := PzBlockRunner on: [ :e | (Date readFrom: e readStream pattern: 'dd-mm-yyyy') ].
runnerB expectedException: DateError.

diffRunner := PzDifferentialRunner new
	runnerA: runnerA;
	runnerB: runnerB;
	yourself.

f run: diffRunner times: 100.
