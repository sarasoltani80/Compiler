%{
	#include<stdio.h>
	int Line = 1;

%}


%%


\n   { printf("TOKEN_WHITESPACE [newline] %s \n",yytext); Line=Line+1; }
\t   { printf("TOKEN_WHITESPACE [tab] %s \n",yytext); }
" "  { printf("TOKEN_WHITESPACE [space] %s \n",yytext); }

boolean  {printf("TOKEN_BOOLEANTYPE %s \n",yytext);}
break  {printf("TOKEN_BREAKSTMT %s \n",yytext);}
callout   {printf("TOKEN_CALLOUT %s \n",yytext);}
class   {printf("TOKEN_CLASS %s \n",yytext);}
continue   {printf("TOKEN_CONTINUESTMT %s \n",yytext);}
else   {printf("TOKEN_ELSECONDITION %s \n",yytext);}
false   {printf("TOKEN_BOOLEANCONST %s \n",yytext);}
for    {printf("TOKEN_LOOP %s \n",yytext);}
if   {printf("TOKEN_IFCONDITION %s \n",yytext);}
int  {printf("TOKEN_INTTYPE %s \n",yytext);}
return   {printf("TOKEN_RETURN %s \n",yytext);}
true   {printf("TOKEN_BOOLEANCONST %s \n",yytext);}
void   {printf("TOKEN_VOIDTYPE %s \n",yytext);}
program   {printf("TOKEN_PROGRAMCLASS %s \n",yytext);}
main   {printf("TOKEN_MAINFUNC %s \n",yytext);} 


(\+|-|\*|\/|\%)	{ printf("TOKEN_ARITHMATICOP %s \n",yytext); }


(&&|\|\|)	{ printf("TOKEN_CONDITIONOP %s \n",yytext); }


(<=|\<|\>|>=)	{ printf("TOKEN_RELATIONOP %s \n",yytext); }


[+][=]   {printf("TOKEN_ASSIGNOP %s \n",yytext);}

[-][=]   {printf("TOKEN_ASSIGNOP %s \n",yytext);}

(!=|==)	{ printf("TOKEN_EQUALITYOP %s \n",yytext); }

[!]   {printf("TOKEN_LOGICOP %s \n",yytext);}
[=]   {printf("TOKEN_ASSIGNOP %s \n",yytext);}
[;]   {printf("TOKEN_SEMICOLON %s \n",yytext);}
[,]   {printf("TOKEN_COMMA  %s \n",yytext);}

[(]   {printf("TOKEN_LP %s \n",yytext);}
[)]   {printf("TOKEN_RP %s \n",yytext);}

[{]   {printf("TOKEN_LCB %s \n",yytext);}
[}]   {printf("TOKEN_RCB %s \n",yytext);}

[[]       {printf("TOKEN_LB %s \n",yytext);}
[]]       {printf("TOKEN_RB %s \n",yytext);}

\/\/.* { printf("TOKEN_COMMENT %s\n",yytext);}   



\'([^(\00-\37\42\47\134\177)]|(\\')|(\\\")|(\\\\))\'	{ printf("TOKEN_CHARCONST %s\n",yytext);}
\'([^(\00-\37\42\47\134\177)]|(\\')|(\\\")|(\\\\))	{ printf("Error in line %d : Invalid token	\' unmatched\n",Line);}
\'(.|(\\')|(\\\")|(\\\\))\'	{ printf("Error in line %d : Invalid token	Invalid charecter\n",Line);}
\'(.|(\\')|(\\\")|(\\\\))		{ printf("Error in line %d : Invalid token	\' unmatched and Invalid charecter \n",Line);}



\"([^(\00-\37\42\47\134\177)]|(\\')|(\\\")|(\\\\))*\"	{ printf("TOKEN_STRINGCONST %s",yytext);}
\"([^(\00-\37\42\47\134\177)]|(\\')|(\\\")|(\\\\))*		{ printf("Error in line %d : Invalid token	\" unmatched\n",Line);}
\"(.|(\\')|(\\\")|(\\\\))*\"		{ printf("Error in line %d : Invalid token	Invalid charecters in string\n",Line);}
\"(.|(\\')|(\\\")|(\\\\))*		{ printf("Error in line %d : Invalid token	\" unmatched and Invalid charecters in string \n",Line);}


0x[a-fA-F0-9]{1,8}  {printf("TOKEN_HEXADECIMALCONST %s \n",yytext);}  

0x[a-fA-F0-9]{9,}    { printf("Error in line %d :invalid HEXADECIMALCONST\n",Line);}    

[0-9]+[_a-zA-Z]+[0-9]*      { printf("Error in line %d : wrong id form \n",Line); }  
[_a-zA-Z]+[_a-zA-Z0-9]*  {printf("TOKEN_ID %s \n",yytext);} 

(2[1][4][7][4][8][3][6][4][8-9]|[-]2[1][4][7][4][8][3][6][4][9]|[-]{0,1}2[1][4][7][4][8][3][6][5-9][0-9]|[-]{0,1}2[1][4][7][4][8][3][7-9][0-9]{2}|[-]{0,1}2[1][4][7][4][8][4-9][0-9]{3}|[-]{0,1}2[1][4][7][4][9][0-9]{4}|[-]{0,1}2[1][4][7][5-9][0-9]{5}|[-]{0,1}2[1][4][8-9][0-9]{6}|[-]{0,1}2[1][5-9][0-9]{7}|[-]{0,1}2[2-9][0-9]{8}|[-]{0,1}[3-9][0-9]{9}|[-]{0,1}[1-9][0-9]{10,})  { printf("Error in line %d : Invalid DECIMALCONST \n",Line); } 

([-]{0,1}[0-9]|[-]{0,1}[1-9][0-9]{1,8}|[-]{0,1}1[0-9]{1,9}|2[0-1][0-4][0-7][0-4][0-8][0-3][0-6][0-4][0-7]|[-]2[0-1][0-4][0-7][0-4][0-8][0-3][0-6][0-4][0-8]) {printf("TOKEN_DECIMALCONST %s \n",yytext); }

([^(\40\+\%\-\*\/\<\>\!=\<=\>=\==\&&\||\!\=\-=\+=\(\)\;\{\}\[\]\,\t\n)]|(\\')|(\\\")|(\\\\))*	 { printf("Error in line %d : Invalid token\n",Line); return; } 
&  { printf("Error in line %d : Invalid sign (&)\n",Line); }  
"|"  { printf("Error in line %d : Invalid sign (|)\n",Line); }  	

%%
int yywrap(){}

int main (int n,char **argcv) 
{
FILE * f = fopen(argcv[1], "r");
yyin = f;

yylex();
return 0;
}
