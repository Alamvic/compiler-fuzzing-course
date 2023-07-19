# Readme

This directory contains code and instructions to run the Smic learning compiler.

## About Smic

Smic (*salaire minimum de croissance* in French) is a small imperative programming language meant for learning, and in this case, to learn compiler testing.
Smic is a small programming language in terms of features:

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

## Installing Smic

- smic loading
- what pharo version
- install unicorn

## Day 1 - Exercises
## Day 2 - Exercises
## Day 3 - Exercises
## Day 4 - Exercises
## Day 5 - Exercises
