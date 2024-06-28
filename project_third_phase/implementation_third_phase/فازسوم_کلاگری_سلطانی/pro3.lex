%{
	#include<stdio.h>
	#include "pro3.tab.h"
	int Line = 1;

%}

%%


\n   { /*printf("TOKEN_WHITESPACE [newline] %s \n",yytext);*/ Line=Line+1 ;}
\t   { /*printf("TOKEN_WHITESPACE [tab] %s \n",yytext);*/  }
" "  { /*printf("TOKEN_WHITESPACE [space] %s \n",yytext);*/ }

boolean  {yylval.sval = strdup(yytext);/*printf("TOKEN_BOOLEANTYPE %s \n",yytext);*/ return TOKEN_BOOLEANTYPE;}
break  {yylval.sval = strdup(yytext);/*printf("TOKEN_BREAKSTMT %s \n",yytext);*/ return TOKEN_BREAKSTMT;}
callout   {yylval.sval = strdup(yytext);printf("TOKEN_CALLOUT %s \n",yytext); return TOKEN_CALLOUT;}
class   {yylval.sval = strdup(yytext);/*printf("TOKEN_CLASS %s \n",yytext);*/ return TOKEN_CLASS;}
continue   {yylval.sval = strdup(yytext);printf("TOKEN_CONTINUESTMT %s \n",yytext); return TOKEN_CONTINUESTMT;}
else   {yylval.sval = strdup(yytext);printf("TOKEN_ELSECONDITION %s \n",yytext); return TOKEN_ELSECONDITION;}
false   {yylval.sval = strdup(yytext);printf("TOKEN_BOOLEANCONST %s \n",yytext); return TOKEN_BOOLEANCONST;}
for    {yylval.sval = strdup(yytext);printf("TOKEN_LOOP %s \n",yytext); return TOKEN_LOOP;}
if   {yylval.sval = strdup(yytext);printf("TOKEN_IFCONDITION %s \n",yytext); return TOKEN_IFCONDITION;}
int  {yylval.sval = strdup(yytext);/*printf("TOKEN_INTTYPE %s \n",yytext);*/ return TOKEN_INTTYPE;}
return   {yylval.sval = strdup(yytext);printf("TOKEN_RETURN %s \n",yytext); return TOKEN_RETURN;}
true   {yylval.sval = strdup(yytext);printf("TOKEN_BOOLEANCONST %s \n",yytext); return TOKEN_BOOLEANCONST;}
void   {yylval.sval = strdup(yytext);/*printf("TOKEN_VOIDTYPE %s \n",yytext);*/ return TOKEN_VOIDTYPE;}
Program   {yylval.sval = strdup(yytext);/*printf("TOKEN_PROGRAMCLASS %s \n",yytext);*/ return TOKEN_PROGRAMCLASS;}
main   {yylval.sval = strdup(yytext);/*printf("TOKEN_MAINFUNC %s \n",yytext);*/ return TOKEN_MAINFUNC ;} 

[+]    { yylval.sval = strdup(yytext);return TOKEN_ARITHMATICOP_ADD;}
[-]    { yylval.sval = strdup(yytext);return TOKEN_ARITHMATICOP_SUB;}
[*]    { yylval.sval = strdup(yytext);return TOKEN_ARITHMATICOP_MUL;}
[/]    { yylval.sval = strdup(yytext);return TOKEN_ARITHMATICOP_DIV;}
[%]	{ yylval.sval = strdup(yytext);return TOKEN_ARITHMATICOP;}


(\|\|)	{ yylval.sval = strdup(yytext);return TOKEN_CONDITIONOP_OR;}
[&][&]    { yylval.sval = strdup(yytext);return TOKEN_CONDITIONOP_AND;}

[<][=]	{yylval.sval = strdup(yytext);return TOKEN_RELATIONOP_SE;}
[>][=]    {yylval.sval = strdup(yytext);return TOKEN_RELATIONOP_BE;}
[<]     {yylval.sval = strdup(yytext);return TOKEN_RELATIONOP_S;}
[>]     {yylval.sval = strdup(yytext);return TOKEN_RELATIONOP_B;}




[+][=]   { yylval.sval = strdup(yytext);return TOKEN_ASSIGNOP_ADD;}

[-][=]   { yylval.sval = strdup(yytext);return TOKEN_ASSIGNOP_SUB;}

[!][=]	{ yylval.sval = strdup(yytext);return TOKEN_NOT_EQUALITYOP;}
[=][=]    { yylval.sval = strdup(yytext);return TOKEN_EQUALITYOP;}

[!]   {yylval.sval = strdup(yytext); return TOKEN_LOGICOP;}
[=]   {yylval.sval = strdup(yytext);  return TOKEN_ASSIGNOP;}
[;]   {yylval.sval = strdup(yytext);  return TOKEN_SEMICOLON;}
[,]   {yylval.sval = strdup(yytext); return TOKEN_COMMA;}

[(]   {yylval.sval = strdup(yytext); return TOKEN_LP;}
[)]   {yylval.sval = strdup(yytext); return TOKEN_RP;}

[{]   { yylval.sval = strdup(yytext); /*printf("paranthes1 %s \n",yytext);*/ return TOKEN_LCB;}
[}]   { yylval.sval = strdup(yytext); /*printf("paranthes %s \n",yytext);*/ return TOKEN_RCB;}

[\[]       {yylval.sval = strdup(yytext); return TOKEN_LB;}
[]]       { yylval.sval = strdup(yytext); return TOKEN_RB;}

\/\/.* { yylval.sval = strdup(yytext); printf("TOKEN_COMMENT %s\n",yytext);}   



\'([^(\00-\37\42\47\134\177)]|(\\')|(\\\")|(\\\\))\'	{yylval.sval = strdup(yytext); printf("TOKEN_CHARCONST %s\n",yytext); return TOKEN_CHARCONST;}
\'([^(\00-\37\42\47\134\177)]|(\\')|(\\\")|(\\\\))	{ printf("Error in line %d : Invalid token	\' unmatched\n",Line);}
\'(.|(\\')|(\\\")|(\\\\))\'	{ printf("Error in line %d : Invalid token	Invalid charecter\n",Line);}
\'(.|(\\')|(\\\")|(\\\\))		{ printf("Error in line %d : Invalid token	\' unmatched and Invalid charecter \n",Line);}



\"([^(\00-\37\42\47\134\177)]|(\\')|(\\\")|(\\\\))*\"	{yylval.sval = strdup(yytext); printf("TOKEN_STRINGCONST %s",yytext); return TOKEN_STRINGCONST;}
\"([^(\00-\37\42\47\134\177)]|(\\')|(\\\")|(\\\\))*		{ printf("Error in line %d : Invalid token	\" unmatched\n",Line);}
\"(.|(\\')|(\\\")|(\\\\))*\"		{ printf("Error in line %d : Invalid token	Invalid charecters in string\n",Line);}
\"(.|(\\')|(\\\")|(\\\\))*		{ printf("Error in line %d : Invalid token	\" unmatched and Invalid charecters in string \n",Line);}


0x[a-fA-F0-9]{1,8}  {yylval.sval = strdup(yytext);printf("TOKEN_HEXADECIMALCONST %s \n",yytext);return TOKEN_HEXADECIMALCONST;}  

0x[a-fA-F0-9]{9,}    { yylval.sval = strdup(yytext);printf("Error in line %d :invalid HEXADECIMALCONST\n",Line); return TOKEN_HEXADECIMALCONST;}    

[0-9]+[_a-zA-Z]+[0-9]*      { printf("Error in line %d : wrong id form \n",Line); }  
[_a-zA-Z]+[_a-zA-Z0-9]*  {yylval.sval = strdup(yytext);/*printf("TOKEN_ID %s \n",yytext); */return TOKEN_ID;} 

(2[1][4][7][4][8][3][6][4][8-9]|[-]2[1][4][7][4][8][3][6][4][9]|[-]{0,1}2[1][4][7][4][8][3][6][5-9][0-9]|[-]{0,1}2[1][4][7][4][8][3][7-9][0-9]{2}|[-]{0,1}2[1][4][7][4][8][4-9][0-9]{3}|[-]{0,1}2[1][4][7][4][9][0-9]{4}|[-]{0,1}2[1][4][7][5-9][0-9]{5}|[-]{0,1}2[1][4][8-9][0-9]{6}|[-]{0,1}2[1][5-9][0-9]{7}|[-]{0,1}2[2-9][0-9]{8}|[-]{0,1}[3-9][0-9]{9}|[-]{0,1}[1-9][0-9]{10,})  { printf("Error in line %d : Invalid DECIMALCONST \n",Line); } 

([-]{0,1}[0-9]|[-]{0,1}[1-9][0-9]{1,8}|[-]{0,1}1[0-9]{1,9}|2[0-1][0-4][0-7][0-4][0-8][0-3][0-6][0-4][0-7]|[-]2[0-1][0-4][0-7][0-4][0-8][0-3][0-6][0-4][0-8]) {yylval.sval = strdup(yytext);printf("TOKEN_DECIMALCONST %s \n",yytext); return TOKEN_DECIMALCONST;}

([^(\40\+\%\-\*\/\<\>\!=\<=\>=\==\&&\||\!\=\-=\+=\(\)\;\{\}\[\]\,\t\n)]|(\\')|(\\\")|(\\\\))* { /*printf("Errdlkcnlsor in line %d : Invalid token\n",Line);*/ /*return;*/ } 
&  { printf("Error in line %d : Invalid sign (&)\n",Line); }  
"|"  { printf("Error in line %d : Invalid sign (|)\n",Line); }  	

%%
int yywrap(){}




