# Readme

This directory contains code and instructions to run the Smic learning compiler.

## About Smi and Smic

Smi is a small imperative programming language meant for learning, and in this case, to learn compiler testing.
It's compiler is named Smic after Smi compiler.
The name has been inspired by many sources:
 - *salaire minimum de croissance*, the French name for the minimum salary, because this is the smallest you can live with.
 - **Smi** (Small integer) **c**ompiler, because it was originally intended as a language with just small numbers.

The following sections explain Smi main concepts, grammar, and the architecture of its compiler Smic.

### Operations

Smic has functions, operators, and array operations.
Functions receive arbitrary arguments and return always a single value.
Binary operators are infix, operate between two values and produce a value.
Array operations allow to read or write a value of an array.

Smic also provides a simple `Print` instruction for debugging purposes that receives a single string as an argument.
Strings can only be used in `Print` statements, and Smic does not provide operations to manipulate strings (e.g., concatenate, iterate, craft strings).

### Values

Smic has the following values:
 - Integers
   - 63-bit integers in 64-bit systems, 31-bit integers in 32-bit systems
   - Binary arithmetic operators: `+`, `-`, `*`, `/`
   - Overflow is checked at runtime
 - Arrays
   - Stack allocated
   - 1-based index (Smalltalk inspired ;))
   - Contain other values (integers or arrays)
   - Bounds are checked at runtime

### Control flow

Smic contains only single conditional statements (i.e., `if` statements) without `else`.
Loops are achieved through recursion.

### Type System

Smic is dynamically typed. Types of parameters, variables, and arrays are not specified in the syntax.
Types are nevertheless checked at runtime.
Invalid operations yield a runtime error and make the program exit.

### A Program in a Nutshell

```c
function main(){
  Print "Starting!";
  anArray := array[3];
  anArray[1] = 7;
  anArray[2] = 42;
  anArray[3] = 17;
  return sum(anArray)
}
function sum(anArray){
  return sum_from(anArray, 1);
}
function sum_from(anArray, i){
  if i = anArray.size then { return anArray[i]; }
  return anArray[i] + sum_from(anArray, i + 1);
}
```

### Smi Grammar

Smi's grammar, as it was used to generate it's parser and AST can be found in [this file](grammar.txt).
The syntax of the grammar is the one expected by Smacc, the smalltalk compiler compiler.
You can find more information about Smacc in [its book](http://books.pharo.org/booklet-Smacc/pdf/2018-10-21-Smacc-Compiler.pdf).
The version of Smacc used for this course can be found in [this repository](https://github.com/guillep/Smacc) and is a derivative of the work in [here](https://github.com/SmaCCRefactoring/SmaCC).

## Installing Smic

- smic loading
- what pharo version
- install unicorn

## Day 1 - Exercises
## Day 2 - Exercises
## Day 3 - Exercises
## Day 4 - Exercises
## Day 5 - Exercises
