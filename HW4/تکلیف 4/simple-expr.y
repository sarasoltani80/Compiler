%{ 
#include <stdio.h> 
#include <math.h>
#include <string.h>


extern int yylex();
void yyerror(const char *s);
float gethash(char* word);
void addhash(char* word, float num);
int count = 0;

struct hash
{
   float number;
   char* harf;
};

struct hash arr[52];

%} 
%union {
  float fval;
  char* sval;
}

%token <fval> FLOAT 
%token <sval> NAME 
%token <sval> PLUS
%token <sval> MINUS
%token <sval> DIV
%token <sval> MUL
%token <sval> MOD
%token <sval> EXP
%token <sval> EQUAL
%token newline_token


%nterm <fval> statement
%nterm <fval> expression
%nterm <fval> program

%left PLUS
%left MINUS
%left MUL
%left DIV
%left MOD
%right EXP

%%
program: statement newline_token program
          | statement
          ;

statement:  NAME EQUAL expression {  addhash($1,$3);}
     | expression  { $$ = $1; }
     | newline_token
     ;

expression: expression PLUS expression { $$ = $1 + $3; }
     | expression MINUS expression { $$ = $1 - $3; }
     | NAME { 
          if(gethash($1)< INFINITY){
               $$ = gethash($1);
               printf("%s = %f\n",$1, $$);
          }
          else{
               printf("this variable has not defined\n");
          }
     }
     | expression MUL expression { $$ = $1 * $3; }
     | expression DIV expression { $$ = $1 / $3; }
     | expression MOD expression { $$ = remainder($1 , $3); }
     | expression EXP expression { $$ = pow($1 , $3); }
     | FLOAT { $$ = $1; }
    
     ;

%%

int main() { 
   
     yyparse();
     return 0;
}
float gethash(char* word)
{
     for(int i=0; i<52; i++)
     {
          if(strcmp(arr[i].harf , word)==0){
               return arr[i].number;
          }
     }
     return INFINITY;
}
void addhash(char* word, float num)
{
     int exist = 0;
          
     arr[count].harf = word;
     arr[count].number = num; 
     count++;
          

}
void yyerror(const char *s)
{
     printf("%s", s);
}




