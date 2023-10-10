# Learning Pharo

The objectives of these exercises are to get acquainted to the Pharo programming language.
This step is important to correctly follow the rest of the lectures, which will increase in complexity and will assume that you have some mastery of the language.

Of course, you will not be asked to know obscure or implementation specific details of the language.
But, you will need to learn how to write simple programs including:
- classes and methods
- the syntax, operator precedence
- assignments, conditional and loops
- tests

## ProfStef interactive tutorial

Pharo includes an interactive tutorial inside the IDE called *ProfStef*.
You can open it from a playground that you can get in the menu *Browse > Playground*.
A playground is like an interactive console with vitamins.
Inside you can type any code you want and execute it by 
 - selecting the code you want
 - right click -> *Do it*

<img width="510" alt="imagen" src="https://github.com/UnivLille-Meta/Miage23/assets/708322/af8f9f82-4ad7-4a51-8e82-19fb0ca94b02">

If you tried the two lines of code before, you probably noticed that a *Do it* on *1 + 1* did nothing.
That is because *1 + 1* is an expression with a value, but it does not have any observable side effect.
If you want to see the return value of an expression, you need to do *Print it* or *Do it and go* instead.
For more, the ProfStef tutorial will guide you through the syntax of the language and the main ways to interact with the playground.

## Writing classes, methods and tests

The next step to get acquainted to Pharo is to write some *real* code (what's real anyways?).
For that, follow the PDF tutorial in http://rmod-pharo-mooc.lille.inria.fr/MOOC/PharoMOOC/Week1/Exo-Counter.pdf.

This tutorial will guide you on writing a `Counter` class that has `increment` and `decrement` methods using a TDD approach.
It will also show you how to use the code browser and the debugger a bit.

You may want to check the videos here: 
- *Creating packages, classes and methods:* https://www.youtube.com/watch?v=8Do1TjMHLAI&list=PL2okA_2qDJ-kCHVcNXdO5wsUZJCY31zwf&index=11
- *Creating tests:* https://www.youtube.com/watch?v=FZBDNRJWpLE&list=PL2okA_2qDJ-kCHVcNXdO5wsUZJCY31zwf&index=12
- *Alternative method creation:* https://www.youtube.com/watch?v=iAPo3j_DaXE&list=PL2okA_2qDJ-kCHVcNXdO5wsUZJCY31zwf&index=13
- *Committing the code in Git:* https://www.youtube.com/watch?v=iAPo3j_DaXE&list=PL2okA_2qDJ-kCHVcNXdO5wsUZJCY31zwf&index=14

Or the powerful version with eXtrement TDD (Test driven development):
- https://www.youtube.com/watch?v=K8CVAKE_9pI&list=PL2okA_2qDJ-kCHVcNXdO5wsUZJCY31zwf&index=32

You can check for more info on Pharo in the mooc website: http://mooc.pharo.org
