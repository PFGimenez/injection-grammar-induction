/* This ANTLR4 grammar has been generated by Poirot */

grammar parenthesis;

axiom : s EOF;
a : '(' a ')' | '[' a ']' | 'a';
s : a | a 'b' s;
