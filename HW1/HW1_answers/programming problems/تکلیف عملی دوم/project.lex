%{
	#include<stdio.h>

	
%}



p1 \/\*

p2  \*\/


%%

\/\/(.*) ;


{p1}(.|\n)*{p2} ;

	
%%


int yywrap(){}

int main(){
	FILE * f = fopen("test.cpp", "r");
	yyin = f;
	yyout = fopen("out.cpp","w");
	yylex();
	return 0;
	
}