# Mutation Fuzzing practice

In this practice, we will learn how to apply the ideas from mutation testing intto fuzz testing, to help us discover bugs in a library.
In its simpler form, fuzzing is about generating random input strings to feed to a library.
Grammars help us in generating structured inputs that satisfy certain syntactical properties.
Mutations help us slightly mutate thouse inputs to generate slightly structured inputs.

For this purpose, we will use the [phuzzer](https://github.com/Alamvic/phuzzer/) library on top of Pharo 11.

## Setup

For this practice, you will need to:
 - install the pharo launcher
 - install Pharo11 through the launcher
 - install phuzzer in Pharo:
   - open a playground
   - execute the following expression:
  
```smalltalk
Metacello new
  baseline: 'Phuzzer';
  repository: 'github://alamvic/phuzzer:main';
  onConflictUseIncoming;
  load.
```

## Generating a corpus to mutate

Mutation fuzzers will mutate a seed or corpus of elements.
Each fuzzing takes one element from the corpus and runs random mutations on it.
This means that we need a corpus before. We can create one using our grammar fuzzer.

```smalltalk
dateFuzzer := PzGrammarFuzzer on: PzDateMDYYYYGrammar new.
corpus := (1 to: 100) collect: [ :e | dateFuzzer fuzz ].
```

Things to think about:
- Could we have different corpus sets for different fuzzings?
- What if we want to fuzz an XML library?
- Could we have a corpus already stored in a file? What other variations could you think?
- What makes a good corpus? When an element should be there or not?

## Mutating the corpus

The mutation fuzzer works exactly as the previous fuzzers except that it is configured differently.
The most important part is to set the elements of the corpus, which could be in this case a collection.

```smalltalk
mutationFuzzer := PzMutationFuzzer new.
mutationFuzzer seed: corpus.

r := PzBlockRunner on: [ :e | e asDate ].
mutationFuzzer run: r times: 100
```

Fuzz for 1000 times and inspect the results.

Things to think about:
- What other string mutations can you think about?
- Could you write some domain specific mutations? E.g., swap first and second field of the date. What others could you think about?
- Implement a domain specific mutation, is it effective?

### Further?

These can be combined with code coverage, trying to generate inputs that cover new paths in the program.
