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

Smi has functions, operators, and array operations.
Functions receive arbitrary arguments and return always a single value.
Binary operators are infix, operate between two values and produce a value.
Array operations allow to read or write a value of an array.

Smi also provides a simple `Print` instruction for debugging purposes that receives a single string as an argument.
Strings can only be used in `Print` statements, and Smic does not provide operations to manipulate strings (e.g., concatenate, iterate, craft strings).

### Values

Smi has the following values:
 - Integers
   - 63-bit integers in 64-bit systems, 31-bit integers in 32-bit systems
   - Binary arithmetic operators: `+`, `-`, `*`, `/`
   - Binary comparison operators: `>`, `<`, `>=`, `<=`, `=`
   - Overflow is checked at runtime
 - Arrays
   - Stack allocated
   - 1-based index (Smalltalk inspired ;))
   - Contain other values (integers or arrays)
   - Bounds are checked at runtime

**About boolean values:** To avoid adding new types to the language, the language supports the idea of truthy values, inspired by Javascript and C :). In Smi, integer 0 is false, while all other values are true.

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

## The Smi infrastructure

### Installation

Follow the following steps to get a running environment. When using Pharo, do not forget to "Save" the image after each step using the menu item.

1. First, start by building the unicorn simulator from [this repo](https://github.com/pharo-project/unicorn/tree/pharo-vm-unicorn2), branch `pharo-vm-unicorn2`. Follow the readme installation and do not forget to change the branch. Also, be sure that you install the package, otherwise, see step 4.

 
3. Clone the [pharo-vm code repository](https://github.com/pharo-project/pharo-vm/). We are going to clone it from outside the IDE for current performance problems in libgit2 -- also, do not do a shallow clone as libgit2 does not yet support it.
4. Download a Pharo 11 image. You can follow the installation instructions in [Pharo's webpage](https://pharo.org), or:
    - Option 1: Use the Pharo launcher
    <img width="1088" alt="imagen" src="https://github.com/Alamvic/compiler-fuzzing-course/assets/708322/eb7e4d14-6161-42ba-8241-c22d7af5b4a1">
    
    - Option 2: [Use zeroconf installation](get.pharo.org/) with parameters 110+vm

4. If you couldn't our wouldn't install globally unicorn in your system, two other options open here: install a symlink to the unicorn library next to the downloaded VM executable. Or extend your `LD_LIBRARY_PATH` with Unicorn's library path. Be sure to restart all your terminals in the latter case.

5. Open Your Pharo 11 image.
<img width="1111" alt="imagen" src="https://github.com/Alamvic/compiler-fuzzing-course/assets/708322/8b408f11-6855-4412-b805-51151496e8b8">

6. Import the Pharo-vm repository from your disk into the system
<img width="1088" alt="imagen" src="https://github.com/Alamvic/compiler-fuzzing-course/assets/708322/87ae9e29-f687-4e03-b022-fdfba74d2dc2">

7. Load the baseline and lock it
<img width="573" alt="imagen" src="https://github.com/Alamvic/compiler-fuzzing-course/assets/708322/c3d9165e-d35c-4d26-8df6-b691399e8300">
<img width="503" alt="imagen" src="https://github.com/Alamvic/compiler-fuzzing-course/assets/708322/2b74965b-9701-4fd5-8031-f59aec0ae86a">


8. Install the course package by executing the following expression in a playground:

```smalltalk
Metacello new
	baseline: 'Smic';
	repository: 'github://alamvic/compiler-fuzzing-course:main';
	load
```

### Compiler Architecture

Smi compiler is divided into a classical pipeline architecture.

**Front-end:** A parser auto-generated using a tool like [yacc](https://es.wikipedia.org/wiki/Yacc) generates abstract syntax trees (ASTs) from source code. The parser performs the syntactic validation of programs. Then the front-end performs simple semantic analyses related to name resolution. Type analysis/checking is not done at the front-end: all type-checks are pushed as generated code. At the far end of the front-end, an IR generator translates ASTs into the compiler mid-end intermediate representation.

**Mid-end:** The mid-end of the compiler is made of phases that manipulate a language-independent and machine-independent intermediate language (IR).
The IR is made of a control flow graph in SSA form. Instructions are nodes in the graph of use-defs that needs to be maintained throughout all mid-end phases.
Phases are either analyses or transformations. Analyses produce information for subsequent phases. Transformations mutate the program in intermediate language to either simplify it (an optimization) or produce optimization opportunities for later phases.

**Back-end:** The back-end responsibility is to lower the IR into a machine-dependent representation. It is organized as phases such as register allocation and code generation.

### Compiler optimisations

Here is a list of compiler optimizations supported by Smic.

- **Sparse Conditional Constant Propagation:** Single pass constant propagation, constant folding, and dead branch elimination.
- **Dead code elimination:** A mark-and-sweep-like algorithm removing instructions with no uses and no side effects.
- **Branch simplifications:** Simplify boolean expressions and branches.
- **Clean control flow:** Simplify control flow patterns such as jumps to jumps, merge contiguous basic blocks...
- **Copy propagation:** Propagates the values of copy instructions in the program.
- **Dead path elimination:** Computes dead paths from data-flow paths, splits basic blocks, and eliminates dead branches.
- **Global value numbering:** Computes symbolic versions of expressions to find redundances and push them up in the program.
- **Redundant copy elimination:** Simplify copy instructions in the form `A:=A`.
- **Phi function simplification:** Simplify phi functions where all operands have the same value.
- **Canonicaliser:** Performs peephole optimizations that simplify sequences of instructions.

### Cross-compilation and Cross-execution

The Smi compiler allows for cross-compilation by specifying the target architecture.
This will produce a compiled program using the chosen ISA.
To run programs written in Smi, the Smi infrastructure also provides a runner.

The runner reads the architecture of the compiled program and configures itself to execute native code of the same architecture.
Inside, the runner uses [Unicorn](https://github.com/unicorn-engine/unicorn), a machine code simulator based on [QEMU](https://www.qemu.org/). 

The result of running a program is always the value returned by the `main` function.

### Usage Example

```smalltalk

programAST := SmiParser parse: 'function main(){
		x := 7;
		return x + 1;
}'.

objectProgram := SmiCompiler new
		o0;
		architecture: #aarch64;
		compile: programAST.

result := SmiRunner new run: objectProgram
```


## Day 1 - Exercises
## Day 2 - Exercises
## Day 3 - Exercises
## Day 4 - Exercises
## Day 5 - Exercises
