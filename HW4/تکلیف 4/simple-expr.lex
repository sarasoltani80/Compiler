%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "simple-expr.tab.h"

%}
%option noyywrap

%%
[a-zA-Z]    { yylval.sval = strdup(yytext); return NAME; }
[-]{0,1}[0-9]+\.[0-9]+ { yylval.fval = atof(yytext); return FLOAT; }
[-]{0,1}[0-9]+   { yylval.fval = atof(yytext); return FLOAT; }


[\n]  {yylval.sval = strdup(yytext);  return newline_token;}
[ \t]   /*ignore*/
"+"	{yylval.sval = strdup(yytext); return PLUS;}
"-"	{yylval.sval = strdup(yytext); return MINUS;}
"*"	{yylval.sval = strdup(yytext); return MUL;}
"/"	{yylval.sval = strdup(yytext); return DIV;}
"%" {yylval.sval = strdup(yytext); return MOD;}
"^" {yylval.sval = strdup(yytext); return EXP;}
"=" {yylval.sval = strdup(yytext); return EQUAL; }

%%




