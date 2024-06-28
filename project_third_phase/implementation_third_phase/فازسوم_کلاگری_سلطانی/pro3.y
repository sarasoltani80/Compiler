%{ 
#include <stdio.h> 
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <iostream>
#include <string.h>
#include <stack>
#include <vector>
#include <string>
#include <limits.h>
  using namespace std;


#include "pro3.tab.h"

extern int yylex();
void yyerror(const char *s);
//float get_hash(char* key);
//void put_hash(char* key,float value);
//void add_hash(char* key,float value);
extern FILE* yyin;
FILE* ASM;
//extern FILE* yyout;
//float val;
//int i = 0;
bool in_for = 0;
string AssignRegister(char registerType);
void FreeRegister(string reg);

struct identifier{
    char* id_name;
    char type; //int or boolean
   // string scope;
    string reg;
  };
struct method{
    char* name;
    char outType; //int or boolean
    int args;  ///chera int?
    
  };

void add_identifier(char *identifier/*, string scope*/,string reg,char type);
struct identifier* search_identifier(char* identifier/*,string scope*/);


void add_method(char* name,char outType,int args);
struct method* search_method(const char* name);

vector <struct identifier*> identifiers;
vector <struct method*> methods;


  /*Temporary Registers*/
string t_registers[10] = {"$t0","$t1","$t2","$t3","$t4","$t5","$t6","$t7","$t8","$t9"};
bool t_registers_state[10] = {0};
  /*Saved Values Registers*/
string s_registers[8] = {"$s0","$s1","$s2","$s3","$s4","$s5","$s6","$s7"};
bool s_registers_state[8] = {0};
  /*Function Argument Registers*/
string a_registers[4] = {"$a0","$a1","$a2","$a3"};
bool a_registers_state[4] = {0};
  /*Return Values Registers*/
string v_registers[2] = {"$v0","$v1"};

stack <string> Stack;
int Label = 0;
int label = Label -1;
int number_of_args = 0;
char type_id_at_hand = 'i';
char type_of_expr_at_hand = 'i';
stack <string> where_i_am  ;

  

%}



%union {
  int ival;
 // _Bool bval;
  char* sval;
  char cval;
 // string string;
}




%define parse.error verbose

%token TOKEN_PROGRAMCLASS
%token TOKEN_CLASS
%token TOKEN_MAINFUNC
%token <sval>TOKEN_ID
%token <sval> TOKEN_VOIDTYPE
%token <sval> TOKEN_INTTYPE
%token <sval> TOKEN_BOOLEANTYPE
%token TOKEN_BREAKSTMT
%token TOKEN_CONTINUESTMT
%token TOKEN_RETURN
%token TOKEN_IFCONDITION
%token TOKEN_LOOP
%token <sval> TOKEN_COMMA
%token <sval> TOKEN_HEXADECIMALCONST
%token <sval> TOKEN_DECIMALCONST
%token TOKEN_WHITESPACE
%token <sval> TOKEN_SEMICOLON
%token TOKEN_ARITHMATICOP
%token TOKEN_LCB
%token TOKEN_RCB
%token TOKEN_LP
%token TOKEN_RP
%token TOKEN_LB
%token TOKEN_RB
%token <sval> TOKEN_CHARCONST
%token TOKEN_CALLOUT
%token TOKEN_ELSECONDITION
%token <sval> TOKEN_BOOLEANCONST
%token TOKEN_RELATIONOP
%token TOKEN_EQUALITYOP
%token TOKEN_CONDITIONOP
%token <sval> TOKEN_STRINGCONST
%token TOKEN_ASSIGNOP_ADD
%token TOKEN_ASSIGNOP_SUB
%token TOKEN_ASSIGNOP
%token TOKEN_LOGICOP

/*
%nonassoc TOKEN_BOOLEANTYPE
%nonassoc TOKEN_INTTYPE
%nonassoc  TOKEN_CONDITIONOP
%nonassoc  TOKEN_EQUALITYOP
%nonassoc  TOKEN_RELATIONOP
%nonassoc  TOKEN_ARITHMATICOP
%nonassoc TOKEN_LOGICOP
//%nonassoc  TOKEN_WHITESPACE
*/
%left TOKEN_ARITHMATICOP_ADD
%left TOKEN_ARITHMATICOP_SUB
%left TOKEN_ARITHMATICOP_MUL
%left TOKEN_ARITHMATICOP_DIV
%left TOKEN_ARITHMATICOP

%left TOKEN_RELATIONOP_SE
%left TOKEN_RELATIONOP_BE
%left TOKEN_RELATIONOP_S
%left TOKEN_RELATIONOP_B

%left TOKEN_EQUALITYOP
%left TOKEN_NOT_EQUALITYOP
%left TOKEN_CONDITIONOP_OR
%left TOKEN_CONDITIONOP_AND
%right TOKEN_LOGICOP


%nterm  program
%nterm <sval> field_decl
%nterm  method_decl

%nterm  field_declG
%nterm  method_declG
%nterm <sval> field_decl1G
%nterm  field_decl2
//%nterm  method_return_type
%nterm <sval> method_name_m
%nterm  method_arguments
%nterm  method_argumentsG
%nterm <sval> idG
%nterm <ival> optional_argument
//%nterm  optional_argument2
%nterm  optional_else
//%nterm  optional_expr
%nterm  optional_callout_arg
%nterm  callout_argG
%nterm  programm
%nterm  class
%nterm <sval> mainfunc


%nterm <sval> type

%nterm  <ival> int_literal
%nterm  block
%nterm  var_decl
%nterm  statement
//%nterm  assign_op
%nterm  <sval>location
%nterm <ival> expr
%nterm <ival> expr1
%nterm <sval> id
%nterm <cval> method_call
%nterm <sval> method_name
%nterm <sval> string_literal
%nterm  callout_arg

%nterm <ival> literal
%nterm <ival> decimal_literal
%nterm <ival>hex_literal
%nterm <ival> char_literal
%nterm <ival> bool_literal

//%nterm bin_op
//%nterm arith_op
//%nterm rel_op
//%nterm eq_op
//%nterm cond_op

%nterm here




%%


program:class programm TOKEN_LCB here TOKEN_RCB 
	{
		ASM = fopen("Output.asm", "a+");
		
		 fclose(ASM);
	
	
	
	
	
	printf("\ngot rule 1\n");};
	
here: 	field_declG method_declG|field_declG| method_declG| /*epsilon*/{};
	
field_declG: field_decl|field_declG field_decl {printf("\ngot rule 2\n");};
method_declG: method_decl|method_declG method_decl   {printf("\ngot rule 3\n");};

class: TOKEN_CLASS {
			ASM = fopen("Output.asm", "w+");		
			fclose(ASM);
			};
programm: TOKEN_PROGRAMCLASS {};


field_decl: type  field_decl1G TOKEN_SEMICOLON 
	{
		int just_one = 1;
		char*string_of_ids = $2;//.c_str();
		char* token;
		token = strtok(string_of_ids, ",");
		printf("%s", token);
		
		for (; token != NULL ; )
			{
				
				 just_one = 0;
				 char* check_for_array = strchr(token, '[');
				 if(check_for_array == NULL)
				 {
				 	///nemidoonam ba araye che bayad kard
				 }
				 else//not an array
				 {
				 	add_identifier(token/*, string scope*/,AssignRegister('s'),$1[0]);
				 }
				 
				  token = strtok(NULL, ",");
			}
		if (token == NULL && just_one == 1)
		 {
		 	 char* check_for_array = strchr(token, '[');
				 if(check_for_array != NULL)
				 {
				 	///nemidoonam ba araye che bayad kard
				 }
				 else//not an array
				 {
				 	add_identifier(token/*, string scope*/,AssignRegister('s'),$1[0]);
				 }
		 }	
		printf("\ngot a field declaration\n");
		
	};
field_decl1G: field_decl1G TOKEN_COMMA field_decl2|field_decl2 {printf("\ngot rule 5\n");};
field_decl2: id|id TOKEN_LB int_literal TOKEN_RB |/*epsilon*/ {printf("\ngot rule 6\n");};

method_decl: type method_name_m method_arguments 
		{	
			add_method($2,$1[0],number_of_args );
			number_of_args = 0;
			
			where_i_am.push(string($2));
			//printf("\ngot a method declaration p1\n");
		
		}block 
	| TOKEN_VOIDTYPE method_name_m method_arguments 
		{
			add_method($2,$1[0],number_of_args );
			number_of_args = 0;
			where_i_am.push(string($2));	
			//printf("\ngot a method declaration p1\n");
			
			
		}block 
			{};
//method_return_type: type|TOKEN_VOIDTYPE {printf("\ngot rule 8\n");};
method_name_m: id
		{
			$$ = strdup($1);
			//printf("\n%s $1 in method name\n",$1);
			ASM = fopen("Output.asm", "a+");
        		fprintf(ASM,"%s:\n",$1);
        		fclose(ASM);
		}
		|mainfunc 
		{
			$$ = strdup($1);
			printf("\ngot main method declaration p1\n");
			ASM = fopen("Output.asm", "a+");
        		fprintf(ASM,"main:\n");
        		fclose(ASM);
		};
method_arguments: TOKEN_LP method_argumentsG TOKEN_RP
		|TOKEN_LP TOKEN_RP {printf("\ngot rule 10\n");};
		
method_argumentsG: type id {

				add_identifier($2,AssignRegister('a'),$1[0]);
				number_of_args = number_of_args + 1;
				
				
			}TOKEN_COMMA method_argumentsG1 
			{
					
			}
		|type id {

				add_identifier($2,AssignRegister('a'),$1[0]);
				number_of_args = number_of_args + 1;
				
			};
		
method_argumentsG1: type id {

				add_identifier($2,AssignRegister('a'),$1[0]);
				number_of_args = number_of_args + 1;
				
			}method_argumentsG2 {};
			
method_argumentsG2: TOKEN_COMMA type id {

				add_identifier($3,AssignRegister('a'),$2[0]);
				number_of_args = number_of_args + 1;
				
			}method_argumentsG3 | /*epsilon*/ {};
			
method_argumentsG3: TOKEN_COMMA type id 
			{

				add_identifier($3,AssignRegister('a'),$2[0]);
				number_of_args = number_of_args + 1;
				
			}
		| /*epsilon*/ {};
 

block: TOKEN_LCB var_declG statementG TOKEN_RCB {printf("\n\n\nhere\n");}
	|TOKEN_LCB var_declG {printf("\n\n\nhere\n");}TOKEN_RCB 
	|TOKEN_LCB statementG TOKEN_RCB {printf("\nroooool 20\n");}
	|TOKEN_LCB  TOKEN_RCB {printf("\ngot rule 15\n");};
	
var_declG: var_declG var_decl|var_decl {printf("\ngot rule 16\n");};;
statementG: statementG statement|statement {printf("\ngot rule 17\n");};

var_decl: type idG TOKEN_SEMICOLON 
		{
		type_id_at_hand = $1[0];
			
		printf("\ngot a var declaration\n");

		};


idG: idG TOKEN_COMMA id 
		{
			add_identifier($3/*, string scope*/,AssignRegister('s'),type_id_at_hand);
	
		}
	|id 
		{
			add_identifier($1/*, string scope*/,AssignRegister('s'),type_id_at_hand);

		};

type: TOKEN_INTTYPE {$$ = strdup($1);} 
	|TOKEN_BOOLEANTYPE {$$ = strdup($1);}


statement: location TOKEN_ASSIGNOP expr TOKEN_SEMICOLON 
			{
				  
				string Rs = Stack.top(); //expr
				printf("\nexpr === %s\n",Stack.top().c_str());
				Stack.pop();
                  	
                  		printf("\nlocation === %s\n",Stack.top().c_str());
				string Rt = Stack.top();//location
				
				Stack.pop();

				ASM = fopen("Output.asm", "a+");

				if(Rs[0]!='$')
					fprintf(ASM, "\taddi %s, $zero, %s \n", Rt.c_str(), Rs.c_str());
				else
				{
                    			fprintf(ASM, "\tmove %s, %s \n", Rt.c_str(), Rs.c_str());
                   			if(Rs[1] == 't')
                    			FreeRegister(Rs);
                		}

                 		fclose(ASM);
                 		printf("\ngot a statement\n");
			}
		|location TOKEN_ASSIGNOP_ADD expr TOKEN_SEMICOLON 
			{				
				string Rs = Stack.top(); //expr
				printf("\nexpr === %s\n",Stack.top().c_str());
				Stack.pop();
                  	
                  		printf("\nlocation === %s\n",Stack.top().c_str());
				string Rt = Stack.top();//location
				
				Stack.pop();

				ASM = fopen("Output.asm", "a+");

				if(Rs[0]!='$')
					fprintf(ASM, "\taddi %s, %s, %s \n", Rt.c_str(), Rt.c_str(), Rs.c_str());
				else
				{
                    			fprintf(ASM, "\tadd %s, %s, %s \n", Rt.c_str(), Rt.c_str(), Rs.c_str());
                   			if(Rs[1] == 't')
                    			FreeRegister(Rs);
                		}

                 		fclose(ASM);
                 		printf("\ngot a += statement\n");
			}
		|location TOKEN_ASSIGNOP_SUB expr TOKEN_SEMICOLON
			{				
				string Rs = Stack.top(); //expr
				printf("\nexpr === %s\n",Stack.top().c_str());
				Stack.pop();
                  	
                  		printf("\nlocation === %s\n",Stack.top().c_str());
				string Rt = Stack.top();//location
				
				Stack.pop();

				ASM = fopen("Output.asm", "a+");

				if(Rs[0]!='$')
					fprintf(ASM, "\taddi %s, %s, -%s \n", Rt.c_str(), Rt.c_str(), Rs.c_str());
				else
				{
                    			fprintf(ASM, "\tsub %s, %s, %s \n", Rt.c_str(), Rt.c_str(), Rs.c_str());
                   			if(Rs[1] == 't')
                    			FreeRegister(Rs);
                		}

                 		fclose(ASM);
                 		printf("\ngot a -= statement\n");
			}
		|method_call TOKEN_SEMICOLON
		|TOKEN_IFCONDITION TOKEN_LP expr 
			{
				
				if($3 != INT_MIN)	
				{
					if($3 != INT_MAX)
					{yyerror((strdup("\nthe conditon must be boolean\n ")));}
				}		
              			string e = Stack.top();
              			Stack.pop();
              			Label++;
              			ASM = fopen("Output.asm", "a+");
              			if((e[0]=='$'))
        			{
        				fprintf(ASM,"\tbeq %s,$zero,L%d\n", e.c_str(), Label); //branch to what'a after the "if" block 
   	  				
        			}
        			if((e[0]!='$'))
        			{
        				string tReg = AssignRegister('t');
        				fprintf(ASM,"\taddi %s,$zero,%s\n", tReg.c_str(), e.c_str());
        				fprintf(ASM,"\tbeq %s,$zero,L%d\n", e.c_str(), Label); //branch to what'a after the "if" block
   	  				
        			}
              			
           			fclose(ASM);
            
			}TOKEN_RP block 
				{
					ASM = fopen("Output.asm", "a+");
					label = Label;
					Label++;
					fprintf(ASM,"\tbeq $zero,$zero,L%d\n",Label); //branch to after the  "optional_else" block
        				fprintf(ASM,"\tL%d:\n",label);
        				
        				fclose(ASM);
				}optional_else
				{
					ASM = fopen("Output.asm", "a+");
        				fprintf(ASM,"\tL%d:\n",Label);
        				fclose(ASM);
				}
				
			
			
		|TOKEN_LOOP id TOKEN_ASSIGNOP expr TOKEN_COMMA expr 
			{
				in_for = 1;
				ASM = fopen("Output.asm", "a+");
				printf("\n\t\t\t\tin loop\n");
				
				string e2 = Stack.top();
				Stack.pop();
				string e1 = Stack.top();
				Stack.pop();
				
				string tReg = AssignRegister('t');
				
				if((e1[0]=='$')&&(e1[0]=='$'))
        			{
        			
        				printf("\n\t\t\t\tin loop1\n");
        				Label++;
        				fprintf(ASM,"\tL%d:\n",Label);
        				Label++; 
        				label = Label; //after the loop
        				
          				fprintf(ASM,"\tslt %s,%s,%s\n",tReg.c_str() ,e1.c_str(), e2.c_str());
  					fprintf(ASM,"\tslt %s,$zero,%s\n", tReg.c_str(), tReg.c_str());
  					fprintf(ASM,"\tbne %s,$zero,L%d\n", tReg.c_str(), Label); //branch to what's after the "loop" block
  					
        			}
        					
				else if((e1[0]!='$')&&(e1[0]=='$'))
  				{
          				printf("\n\t\t\t\tin loop2\n");
          				Label++;
        				fprintf(ASM,"\tL%d:\n",Label);
        				Label++; 
        				label = Label; //after the loop
        				
          				fprintf(ASM,"\tslti %s,%s,%s\n",tReg.c_str() ,e2.c_str(), (std::to_string(stoi(e1)-1)).c_str());
  					fprintf(ASM,"\tbne %s,$zero,L%d\n", tReg.c_str(), Label); //branch to what's after the "loop" block
        			}
        			
        			else if((e1[0]!='$')&&(e1[0]!='$'))
  				{
          				printf("\n\t\t\t\tin loop3\n");
          				Label++;
        				fprintf(ASM,"\tL%d:\n",Label);
        				Label++; 
        				label = Label; //after the loop
        				
        				fprintf(ASM,"\taddi %s,$zero,%s\n", tReg.c_str(), e2.c_str());
          				fprintf(ASM,"\tslti %s,%s,%s\n",tReg.c_str() ,e2.c_str(), (std::to_string(stoi(e1)-1)).c_str());
  					fprintf(ASM,"\tbne %s,$zero,L%d\n", tReg.c_str(), Label); //branch to what's after the "loop" block
        			}
        			printf("\n\t\t\t\tin loop4\n");
        			fclose(ASM);	
			}block 
				{
					ASM = fopen("Output.asm", "a+");
        				fprintf(ASM,"\tL%d:\n",label);
        				fclose(ASM);
        				in_for = 0;
				}
			

		|TOKEN_RETURN expr TOKEN_SEMICOLON 
			{
				struct method* m = search_method((where_i_am.top()).c_str());
				where_i_am.pop();
				string Rs = Stack.top(); //expr
				printf("\n \treturn val expr === %d\n",$2);
				//Stack.pop();
				
				if(m -> outType != type_of_expr_at_hand)
					{yyerror((string("\nincorrect type of return value in function ") + m->name+string("\n")).c_str());}
				else
					{
						string Rv = "$v0";
            					ASM = fopen("Output.asm", "a+");
              					if(Rs[0]!='$')
              					fprintf(ASM, "\taddi %s, $zero, %s \n",Rv.c_str() , Rs.c_str());
              					else
              					{
                					fprintf(ASM, "\tmove %s, %s \n",Rv.c_str(), Rs.c_str());
                					if(Rs[1] == 't')
                					FreeRegister(Rs);
            					}
            					fclose(ASM);
					}
			}
			
		|TOKEN_RETURN TOKEN_SEMICOLON 
			{
				struct method* m = search_method((where_i_am.top()).c_str());
				if(m->outType != 'v')
					{
						yyerror(strdup("\nwrong return type\n"));
						
					}
			}	
			
		|TOKEN_BREAKSTMT TOKEN_SEMICOLON
			{
				if (in_for == 0)
					{yyerror(strdup("\nbreak statement outside of 'for' block is not allowed\n"));}
				else
					{
					ASM = fopen("Output.asm", "a+");
					int tLabel = Label ;
					fprintf(ASM,"\tbeq $zero,$zero,L%d\n",tLabel); 
        				fclose(ASM);
        				}
			}
		|TOKEN_CONTINUESTMT TOKEN_SEMICOLON
			{
				if (in_for == 0)
					{yyerror(strdup("\ncontinue statement outside of 'for' block is not allowed\n"));}
				else
					{
					ASM = fopen("Output.asm", "a+");
					int tLabel = Label - 1;
					fprintf(ASM,"\tbeq $zero,$zero,L%d\n",tLabel);
        				fclose(ASM);
        				}	
			}
		|block
		{};
optional_else:	TOKEN_ELSECONDITION block| /*epsilon*/ {};	
//optional_expr: expr {printf("\nrule 2100\n");} |{};

//assign_op:TOKEN_ASSIGNOP {printf("rule 10");};

method_call: method_name TOKEN_LP optional_argument TOKEN_RP  //!expr ha bayad hameshoon akharesh push karde bashan too stack!
		{
			struct method* m = search_method($1);
			 if(m == NULL)
			 	 {yyerror(strdup("\nundefined method\n"));}
			 else
			 	{
			 		 printf("\n\t$3 === %d\t === %d\n",$3,m->args);
			 		 if(m->args != $3) 
			 		
			 		 	{yyerror(strdup("\nthe number of arguments does not match\n"));}
			 		 
			 		  else{
            					 
          					 string arguments[4];
            					 for(int i=$3-1 ; i>=0 ; i--)
            					 	{
            					 		arguments[i] = Stack.top();
             							Stack.pop();
            						}
            					 ASM = fopen("Output.asm", "a+");	
          					 for(int i=0; i<$3; i++)
          					 	{
   							 	if(arguments[i][0]!='$')
   									fprintf(ASM,"\taddi $a%d,$zero,%s\n",i, arguments[i].c_str());
   								else
   									fprintf(ASM,"\tmove $a%d,%s\n",i, arguments[i].c_str());
   							}
          					 fprintf(ASM,"\tjal %s\n", $1);  ///jal ro az roo dastoorat bayad dobare bekhoonam
  						 fclose(ASM);	
			 			}	 
			        }
			   $$ = m->outType; 
		}   
		   
	|TOKEN_CALLOUT TOKEN_LP string_literal optional_callout_arg TOKEN_RP {};
	
optional_argument: expr {$$ = 1;}
	| expr TOKEN_COMMA expr {$$ = 2;}	
	| expr TOKEN_COMMA expr TOKEN_COMMA expr {$$ = 3;}
	| expr TOKEN_COMMA expr TOKEN_COMMA expr TOKEN_COMMA expr	{$$ = 4;}
	| {$$ = 0;} /*epsilon*/ 	//optional_argument2|/*epsilon*/ {};
//optional_argument2: optional_expr TOKEN_COMMA expr optional_argument3 | expr	{};
//optional_argument3: TOKEN_COMMA expr optional_argument4 | /*epsilon*/ {};
//optional_argument4: TOKEN_COMMA expr | /*epsilon*/ {};
optional_callout_arg: TOKEN_COMMA callout_argG {};
callout_argG: callout_argG TOKEN_COMMA callout_arg|callout_arg {};

method_name: id {};


location: id 
		{
      			struct identifier* Rt=search_identifier($1/*,currentScope*/);
      			if(Rt == NULL)
       		{
  				string message = "undefined id " + string($1);
  				yyerror(message.c_str()); 
  			}
  			else
  			{
      				Stack.push(Rt->reg);
      				printf("\npushed id %s to stack at location === %s \n",Rt->id_name,(Rt->reg).c_str());
      			}	
      			
		}
	| id TOKEN_LB expr TOKEN_RB TOKEN_SEMICOLON 
		{
			string Rs = Stack.top();
     			Stack.pop();
       		string Rd = AssignRegister('t');
      			struct identifier* Rt=search_identifier($1/*,currentScope*/);
       		if(Rt == NULL)
       		{
  				string message = "undefined array " + string($1);
  				yyerror(message.c_str());  ///////////koja dide mishes? nemidoonam felan
  			}
  			else{
  				ASM = fopen("Output.asm", "a+");
  				if(Rs[0]!='$')
  					fprintf(ASM,"\tlw %s,%d(%s)\n", Rd.c_str(), stoi(Rs)*4, (Rt->reg).c_str());
  				else{
  					fprintf(ASM,"\tsll %s,%s,2\n", Rd.c_str(), Rs.c_str()); //multiply the value of the register by 4 (2 shifts to left)
  					fprintf(ASM,"\tadd %s,%s,%s\n", Rd.c_str(), Rd.c_str(), (Rt->reg).c_str());
  					fprintf(ASM,"\tlw %s,0(%s)\n", Rd.c_str(), Rd.c_str());
  				}
        		fclose(ASM);
    			Stack.push(Rd);
    			printf("\npushed to stack\n");
  			}			
		}; 

expr:     location
		{
			$$ = atoi($1);
			printf("\n\n\\t\t loc = %d\n\\",$$);
		}
	| method_call 
		{
			if ($1 == 'v')
			{string message = "\nmethod with no returning value cannot be used as an expression\n";
			yyerror(message.c_str());}
			else 
			{       	
				string Rv = "$v0";
       		 	Stack.push(Rv);			
			}
		}
	| literal 
		{	
			$$ = $1; 
		 	printf("\nliteral === %d\n",$$);
		 	Stack.push(std::to_string($1));		 		 	
		 }
		 
	| expr1 {$$ = $1;}
	| expr TOKEN_ARITHMATICOP expr 
	{
		if($1 == INT_MAX || $1 == INT_MIN || $3 == INT_MIN || $3 == INT_MAX)
		{
			string message = "boolean variable can not div with another variable";  ///???????????
			yyerror(message.c_str());
		}
		else{
		ASM = fopen("Output.asm", "a+");
        	//$$ = $1 % $3;
        	
        	
  		string Rt = Stack.top();
        	Stack.pop();
  		string Rs = Stack.top();
       	Stack.pop();
       	
        	string Rd = AssignRegister('t');
        	
        	if($3==0 || Rs[1]=='s' || Rt[1]=='s'){
        		string message = "\ncan not divide by zero\n";
			yyerror(message.c_str());
		}
        	
  		if(Rs[0]!='$' && Rt[0]!='$')
  			fprintf(ASM,"\taddi %s,$zero,%d\n", Rd.c_str(),stoi(Rs)%stoi(Rt));
  			
  		else if(Rs[0]!='$'){
          		fprintf(ASM,"\taddi %s,$zero,%s", Rd.c_str(),Rs.c_str());
          		fprintf(ASM,"\tdiv %s,%s\n", Rd.c_str(), Rt.c_str());
          		fprintf(ASM,"\tmfhi %s\n", Rd.c_str());
        	}
        	
        	else if(Rt[0]!='$'){
          		fprintf(ASM,"\taddi %s,$zero,%s", Rd.c_str(),Rt.c_str());
          		fprintf(ASM,"\tdiv %s,%s\n", Rs.c_str(), Rd.c_str());
          		fprintf(ASM,"\tmfhi %s\n", Rd.c_str()); //hasele mod ke dar HI righte shode bood dar Rd mirizad
        	}
        	
  		else{
          		fprintf(ASM,"\tdiv %s,%s\n", Rs.c_str(), Rt.c_str());
          		fprintf(ASM,"\tmfhi %s\n", Rd.c_str());
          	}
          		
          		
        	if(Rs[1] == 't')
  			FreeRegister(Rs);
  		if(Rt[1] == 't')
  			FreeRegister(Rt);
  			
  		fclose(ASM);
  		Stack.push(Rd);
  		type_of_expr_at_hand = 'i';
  		$$ = 10;
  		}
	}
	| expr TOKEN_ARITHMATICOP_ADD expr 
	
	{
		if($1 == INT_MAX || $1 == INT_MIN || $3 == INT_MIN || $3 == INT_MAX)
		{
			string message = "\nboolean variable can not be added to another variable\n";
			yyerror(message.c_str());
		}
		else
		{
			//$$ = $1 + $3;
			printf("\n\t\tADD = %d\n",$$);
			ASM = fopen("Output.asm", "a+");

      		
  			string Rt = Stack.top();
     			Stack.pop();
     			
  			string Rs = Stack.top();
       		Stack.pop();

      			string Rd = AssignRegister('t');
      		
  			if(Rs[0]!='$' && Rt[0]!='$')
  				fprintf(ASM,"\taddi %s,$zero,%d\n", Rd.c_str(),stoi(Rs)+stoi(Rt)); //immediates not registers
  			
  			else if(Rs[0]!='$')
       			fprintf(ASM,"\taddi %s,%s,%s\n", Rd.c_str(), Rt.c_str(), Rs.c_str());
       		
        		else if(Rt[0]!='$')
     				fprintf(ASM,"\taddi %s,%s,%s\n", Rd.c_str(), Rs.c_str(), Rt.c_str());
     			
  			else
       			fprintf(ASM,"\tadd %s,%s,%s\n", Rd.c_str(), Rs.c_str(), Rt.c_str());//both registers
   		
   			    	
   			
   			if(Rs[1] == 't')	//temp registers
  				FreeRegister(Rs);
  			if(Rt[1] == 't')
  				FreeRegister(Rt);
  			
  			fclose(ASM);
  			Stack.push(Rd);  ///hanooz bayad daghigh tar sham koja ha lazememoon mishe
  			
  			type_of_expr_at_hand = 'i';
  			$$ = 10;
		
  		}
	}
	
	| expr TOKEN_ARITHMATICOP_SUB expr 
	
	{
		if($1 == INT_MAX || $1 == INT_MIN || $3 == INT_MIN || $3 == INT_MAX)
		{
			string message = "\nboolean variable can not be subtracted from another variable\n";
			yyerror(message.c_str());
		}
		else{
		
		ASM = fopen("Output.asm", "a+");
        	//$$ = $1 - $3;
        	
  		string Rt = Stack.top();
        	Stack.pop();
        	
  		string Rs = Stack.top();
        	Stack.pop();
        	
        	string Rd = AssignRegister('t');
        	
  		if(Rs[0]!='$' && Rt[0]!='$')
  			fprintf(ASM,"\taddi %s,$zero,%d\n", Rd.c_str(),stoi(Rs)-stoi(Rt));
  			
  		else if(Rs[0]!='$'){
          		fprintf(ASM,"\tsub %s,$zero,%s", Rd.c_str(),Rt.c_str());
          		fprintf(ASM,"\taddi %s,%s,%s\n", Rd.c_str(), Rd.c_str(), Rs.c_str());
        	}
        	else if(Rt[0]!='$')
          		fprintf(ASM,"\taddi %s,%s,-%s\n", Rd.c_str(), Rs.c_str(), Rt.c_str());
          		
  		else
          		fprintf(ASM,"\tsub %s,%s,%s\n", Rd.c_str(), Rs.c_str(), Rt.c_str());
          		
          		
        	if(Rs[1] == 't')
  			FreeRegister(Rs);
  			
  		if(Rt[1] == 't')
  			FreeRegister(Rt);
  			
  		fclose(ASM);
  		Stack.push(Rd);
  		type_of_expr_at_hand = 'i';
  		$$ = 10;
  		}
			
	}
	
	| expr TOKEN_ARITHMATICOP_MUL expr 
	{
		if($1 == INT_MAX || $1 == INT_MIN || $3 == INT_MIN || $3 == INT_MAX)
		{
			string message = "boolean variable can not mul with another variable";
			yyerror(message.c_str());
		}
		
		else{
		ASM = fopen("Output.asm", "a+");
        	//$$ = $1 * $3;
        	
  		string Rt = Stack.top();
        	Stack.pop();
        	
  		string Rs = Stack.top();
        	Stack.pop();
        	
        	string Rd = AssignRegister('t');
        	
  		if(Rs[0]!='$' && Rt[0]!='$')
  			fprintf(ASM,"\taddi %s,$zero,%d\n", Rd.c_str(),stoi(Rs)*stoi(Rt)); //both constants
  			
  		else if(Rs[0]!='$'){
  		
          		fprintf(ASM,"\taddi %s,$zero,%s", Rd.c_str(),Rs.c_str());
          		fprintf(ASM,"\tmul %s,%s,%s\n", Rd.c_str(), Rd.c_str(), Rt.c_str());
       	}
        	else if(Rt[0]!='$'){
        	
          		fprintf(ASM,"\taddi %s,$zero,%s", Rd.c_str(),Rt.c_str());
          		fprintf(ASM,"\tmul %s,%s,%s\n", Rd.c_str(), Rs.c_str(), Rt.c_str());
        	}
  		else
          		fprintf(ASM,"\tmul %s,%s,%s\n", Rd.c_str(), Rs.c_str(), Rt.c_str()); //both registers
          		
          		
        	if(Rs[1] == 't')
  			FreeRegister(Rs);
  		if(Rt[1] == 't')
  			FreeRegister(Rt);
  			
  		fclose(ASM);
  		Stack.push(Rd);
  		type_of_expr_at_hand = 'i';
  		$$ = 10;
  		}
	}
	| expr TOKEN_ARITHMATICOP_DIV expr 
	{
		/*if($1 == INT_MAX || $1 == INT_MIN || $3 == INT_MIN || $3 == INT_MAX)
		{
			string message = "\nboolean variable can not be divided by another variable\n";
			yyerror(message.c_str());
		}*/
		//else{
		ASM = fopen("Output.asm", "a+");
		printf("\n\t\t\t\t%d , %d\n",$1,$3);
        	//$$ = $1 / $3;
        	
  		string Rt = Stack.top();
        	Stack.pop();
  		string Rs = Stack.top();
       	Stack.pop();
       	
        	string Rd = AssignRegister('t');
        	
        	/*if($3==0 || Rs[1]=='s' || Rt[1]=='s') {
        	
        		string message = "can not calculate mod by zero";
			yyerror(message.c_str());
		}
        	*/
  		if(Rs[0]!='$' && Rt[0]!='$')
  			{
  				if (stoi(Rt)== 0)
  					{yyerror(strdup("\nboolean variable can not be divided by another variable\n"));}
  					
  				fprintf(ASM,"\taddi %s,$zero,%d\n", Rd.c_str(),stoi(Rs)/stoi(Rt));
  				
  			}	
  			
  		else if(Rs[0]!='$'){
          		fprintf(ASM,"\taddi %s,$zero,%s", Rd.c_str(),Rs.c_str());
          		fprintf(ASM,"\tdiv %s,%s\n", Rd.c_str(), Rt.c_str());
          		fprintf(ASM,"\tmflo %s\n", Rd.c_str());
        	}
        	
        	else if(Rt[0]!='$'){
        		if (stoi(Rt)== 0)
  					{yyerror(strdup("\nboolean variable can not be divided by another variable\n"));}
          		fprintf(ASM,"\taddi %s,$zero,%s", Rd.c_str(),Rt.c_str());
          		fprintf(ASM,"\tdiv %s,%s\n", Rs.c_str(), Rd.c_str());
          		fprintf(ASM,"\tmflo %s\n", Rd.c_str()); //hasele taghsim ke dar LO righte shode bood dar Rd mirizad
        	}
        	
  		else{
          		fprintf(ASM,"\tdiv %s,%s\n", Rs.c_str(), Rt.c_str());
          		fprintf(ASM,"\tmflo %s\n", Rd.c_str());
          	}
          		
          		
        	if(Rs[1] == 't')
  			FreeRegister(Rs);
  		if(Rt[1] == 't')
  			FreeRegister(Rt);
  			
  		fclose(ASM);
  		Stack.push(Rd);
  		type_of_expr_at_hand = 'i';
  		$$ = 10;
  		//}
	}
	| expr TOKEN_RELATIONOP_SE expr 
	{
		if(($1 != INT_MIN)&&($1 != INT_MIN))
		{
			yyerror(strdup("\nboolean variable can not compare with another type\n"));
			
		}
		else if(($3 != INT_MIN)&&($3 != INT_MIN))
		{
			yyerror(strdup("\nboolean variable can not compare with another type\n"));
		}
		else{
		ASM = fopen("Output.asm", "a+");
		
		if($1 <= $3) 
			$$ = INT_MAX;
		else 
			$$ = INT_MIN;
			
  		string Rt = Stack.top();
        	Stack.pop();
  		string Rs = Stack.top();
        	Stack.pop();
        	
        	string Rd = AssignRegister('t');
        	
  		if(Rs[0]!='$' && Rt[0]!='$')
  			fprintf(ASM,"\taddi %s,$zero,%d\n", Rd.c_str(),stoi(Rs)<=stoi(Rt));
  			
  		else if(Rs[0]!='$'){
  			fprintf(ASM,"\taddi %s,$zero,%s\n", Rd.c_str(), Rs.c_str());
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd.c_str(), Rd.c_str(), Rt.c_str()); //both registers
  		}
  		
  		else if(Rt[0]!='$')
  			fprintf(ASM,"\tslti %s,%s,%s\n", Rd.c_str(), Rs.c_str(), Rt.c_str()); //one of them is register
  		else
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd.c_str(), Rs.c_str(), Rt.c_str());
  			
       	fprintf(ASM,"\txori %s,%s,1\n", Rd.c_str(), Rd.c_str()); //xori $t, $s, imm ==> $t = $s ^ imm
       	
       	if(Rs[1] == 't')
  			FreeRegister(Rs);
  		if(Rt[1] == 't')
  			FreeRegister(Rt);
       	
  		fclose(ASM);
  		Stack.push(Rd);
  		type_of_expr_at_hand = 'b';
  		}
	}
	| expr TOKEN_RELATIONOP_BE expr 
	{
		if(($1 != INT_MIN)&&($1 != INT_MIN))
		{
			yyerror(strdup("\nboolean variable can not compare with another type\n"));
		}
		else if(($3 != INT_MIN)&&($3 != INT_MIN))
		{
			yyerror(strdup("\nboolean variable can not compare with another type\n"));
		}
		else{
		ASM = fopen("Output.asm", "a+");
		
        	if($1 >= $3) 
			$$ = INT_MAX;
		else 
			$$ = INT_MIN;
			
  		string Rt = Stack.top();
        	Stack.pop();
  		string Rs = Stack.top();
        	Stack.pop();
        	
        	string Rd = AssignRegister('t');
        	
  		if(Rs[0]!='$' && Rt[0]!='$')
  			fprintf(ASM,"\taddi %s,$zero,%d\n", Rd.c_str(),stoi(Rs)>=stoi(Rt));
  			
  		else if(Rs[0]!='$'){
          		fprintf(ASM,"\taddi %s,$zero,%s\n", Rd.c_str(), Rs.c_str());
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd.c_str(), Rd.c_str(), Rt.c_str());
        	}
        	
        	else if(Rt[0]!='$')
          		fprintf(ASM,"\tslti %s,%s,%s\n", Rd.c_str(), Rs.c_str(), Rt.c_str());
  		else
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd.c_str(), Rs.c_str(), Rt.c_str());
  			
        	fprintf(ASM,"\txori %s,%s,1\n", Rd.c_str(), Rd.c_str());
        	
        	if(Rs[1] == 't')
  			FreeRegister(Rs);
  		if(Rt[1] == 't')
  			FreeRegister(Rt);
  			
  		fclose(ASM);
  		Stack.push(Rd);
  		type_of_expr_at_hand = 'b';
  		}
	}
	| expr TOKEN_RELATIONOP_S expr 
	{
		if(($1 != INT_MIN)&&($1 != INT_MIN))
		{
			yyerror(strdup("\nboolean variable can not compare with another type\n"));
		}
		else if(($3 != INT_MIN)&&($3 != INT_MIN))
		{
			yyerror(strdup("\nboolean variable can not compare with another type\n"));
		}
		
		else{
		 ASM = fopen("Output.asm", "a+");
		 
        	 if($1 < $3) 
			$$ = INT_MAX;
		 else 
			$$ = INT_MIN;
			
  		string Rt = Stack.top();
        	Stack.pop();
  		string Rs = Stack.top();
        	Stack.pop();
        	
        	string Rd = AssignRegister('t');
        	
  		if(Rs[0]!='$' && Rt[0]!='$')
  			fprintf(ASM,"\taddi %s,$zero,%d\n", Rd.c_str(),stoi(Rs)<stoi(Rt));
  			
  		else if(Rs[0]!='$'){
  			fprintf(ASM,"\taddi %s,$zero,%s\n", Rd.c_str(), Rs.c_str());
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd.c_str(), Rd.c_str(), Rt.c_str());
  		}
  		
  		else if(Rt[0]!='$')
  			fprintf(ASM,"\tslti %s,%s,%s\n", Rd.c_str(), Rs.c_str(), Rt.c_str());
  		else
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd.c_str(), Rs.c_str(), Rt.c_str());
  			
  		if(Rs[1] == 't')
  			FreeRegister(Rs);
  		if(Rt[1] == 't')
  			FreeRegister(Rt);
  			
  		fclose(ASM);
  		Stack.push(Rd);
  		type_of_expr_at_hand = 'b';
  		}
	}
	| expr TOKEN_RELATIONOP_B expr 
	{
		if(($1 != INT_MIN)&&($1 != INT_MIN))
		{
			yyerror(strdup("\nboolean variable can not compare with another type\n"));
		}
		else if(($3 != INT_MIN)&&($3 != INT_MIN))
		{
			yyerror(strdup("\nboolean variable can not compare with another type\n"));
		}
		else{
		ASM = fopen("Output.asm", "a+");
		
         	if($1 > $3) 
			$$ = INT_MAX;
		 else 
			$$ = INT_MIN;
			
  		string Rt = Stack.top();
        	Stack.pop();
  		string Rs = Stack.top();
        	Stack.pop();
        	
        	string Rd = AssignRegister('t');
        	
  		if(Rs[0]!='$' && Rt[0]!='$')
  			fprintf(ASM,"\taddi %s,$zero,%d\n", Rd.c_str(),stoi(Rs)>stoi(Rt));
  			
  		else if(Rs[0]!='$')
          		fprintf(ASM,"\tslti %s,%s,%s\n", Rd.c_str(), Rt.c_str(), Rs.c_str());
          		
  		else if(Rt[0]!='$'){
          		fprintf(ASM,"\taddi %s,$zero,%s\n", Rd.c_str(), Rt.c_str());
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd.c_str(), Rd.c_str(), Rs.c_str());
        	}
        	
  		else
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd.c_str(), Rt.c_str(), Rs.c_str());
  			
  		if(Rs[1] == 't')
  			FreeRegister(Rs);
  		if(Rt[1] == 't')
  			FreeRegister(Rt);
  			
  		fclose(ASM);
  		Stack.push(Rd);
  		type_of_expr_at_hand = 'b';
  		}
	}
	| expr TOKEN_EQUALITYOP expr 
	{
		if((($1 == INT_MAX || $1 == INT_MIN) && ($3 == INT_MAX || $3 == INT_MIN)) || (($1 != INT_MAX && $1 != INT_MIN) && ($3 != INT_MAX && $3 != INT_MIN))){
		
		ASM = fopen("Output.asm", "a+");
		
        	if($1 == $3) 
			$$ = INT_MAX;
		 else 
			$$ = INT_MIN;
			
  		string Rt = Stack.top();
        	Stack.pop();
  		string Rs = Stack.top();
        	Stack.pop();
        	
        	string Rd1 = AssignRegister('t');
        	string Rd2 = AssignRegister('t');
        	
  		if(Rs[0]!='$' && Rt[0]!='$')
  			fprintf(ASM,"\taddi %s,$zero,%d\n", Rd1.c_str(),stoi(Rs)==stoi(Rt));
  			
  		else if(Rs[0]!='$'){    // if it is smaller Rd1 would be zero
          		fprintf(ASM,"\taddi %s,$zero,%s\n", Rd1.c_str(), Rs.c_str());
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rt.c_str());
          		fprintf(ASM,"\tslti %s,%s,%s\n", Rd2.c_str(), Rt.c_str(), Rs.c_str()); 
  			fprintf(ASM,"\txor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
        	}
        	
        	else if(Rt[0]!='$'){  // if it is smaller Rd1 would be zero
          		fprintf(ASM,"\taddi %s,$zero,%s\n", Rd2.c_str(), Rt.c_str());
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd2.c_str(), Rd2.c_str(), Rs.c_str()); // both registers
  			fprintf(ASM,"\tslti %s,%s,%s\n", Rd1.c_str(), Rs.c_str(), Rt.c_str()); // one of them is register
  			fprintf(ASM,"\txor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
        	}
        	
  		else{
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd1.c_str(), Rs.c_str(), Rt.c_str());
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd2.c_str(), Rt.c_str(), Rs.c_str());
  			fprintf(ASM,"\txor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
  		}
  		
        	FreeRegister(Rd2);
        	if(Rs[1] == 't')
  				FreeRegister(Rs);
  		if(Rt[1] == 't')
  				FreeRegister(Rt);
  				
  		fclose(ASM);
  		Stack.push(Rd1);
  		type_of_expr_at_hand = 'b';
  		}
  		
  		else{
  			string message = "two variables in diffrent types can not equal with each other";
			yyerror(message.c_str());
		}
		
	}
	| expr TOKEN_NOT_EQUALITYOP expr 
	{
		if((($1 == INT_MAX || $1 == INT_MIN) && ($3 == INT_MAX || $3 == INT_MIN)) || (($1 != INT_MAX && $1 != INT_MIN) && ($3 != INT_MAX && $3 != INT_MIN))){
		
		ASM = fopen("Output.asm", "a+");
		
        	if($1 != $3) 
			$$ = INT_MAX;
		 else 
			$$ = INT_MIN;
			
  		string Rt = Stack.top();
        	Stack.pop();
  		string Rs = Stack.top();
        	Stack.pop();
        	
        	string Rd1 = AssignRegister('t');
        	string Rd2 = AssignRegister('t');
        	
  		if(Rs[0]!='$' && Rt[0]!='$')
  			fprintf(ASM,"\taddi %s,$zero,%d\n", Rd1.c_str(),stoi(Rs)!=stoi(Rt));
  			
  		else if(Rs[0]!='$')
  		{
          		fprintf(ASM,"\taddi %s,$zero,%s\n", Rd1.c_str(), Rs.c_str());
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rt.c_str());
          		fprintf(ASM,"\tslti %s,%s,%s\n", Rd2.c_str(), Rt.c_str(), Rs.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
        	}
        	
        	else if(Rt[0]!='$')
        	{
          		fprintf(ASM,"\taddi %s,$zero,%s\n", Rd2.c_str(), Rt.c_str());
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd2.c_str(), Rd2.c_str(), Rs.c_str());
  			fprintf(ASM,"\tslti %s,%s,%s\n", Rd1.c_str(), Rs.c_str(), Rt.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
        	}
        	
  		else
  		{
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd1.c_str(), Rs.c_str(), Rt.c_str());
  			fprintf(ASM,"\tslt %s,%s,%s\n", Rd2.c_str(), Rt.c_str(), Rs.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
  		}
  		
        	FreeRegister(Rd2);
        	
        	if(Rs[1] == 't')
  			FreeRegister(Rs);
  		if(Rt[1] == 't')
  			FreeRegister(Rt);
  			
  		fclose(ASM);
  		Stack.push(Rd1);
  		type_of_expr_at_hand = 'b';
  		}
  		
  		else{
  			string message = "two variables in diffrent types can not equal or not equal with each other";
			yyerror(message.c_str());
		}
	}
	| expr TOKEN_CONDITIONOP_OR expr 
	{
		if( ( ($1 == INT_MAX || $1 == INT_MIN) && ($3 == INT_MAX || $3 == INT_MIN) ) ){
		
		ASM = fopen("Output.asm", "a+");

        	if( ( ($1 == INT_MIN) && ($3 == INT_MIN) ) ) 
			$$ = INT_MIN;
		 else 
			$$ = INT_MAX;
			
  		string Rt = Stack.top();
        	Stack.pop();
  		string Rs = Stack.top();
        	Stack.pop();
        	
        	string Rd1 = AssignRegister('t');
        	string Rd2 = AssignRegister('t');
        	
  		if(Rs[0]!='$' && Rt[0]!='$')
  			fprintf(ASM,"\taddi %s,$zero,%d\n", Rd1.c_str(),stoi(Rs)||stoi(Rt));
  			
  		else if(Rs[0]!='$')
  		{
          		fprintf(ASM,"\tslti %s,$zero,%s\n", Rd1.c_str(), Rs.c_str());
  			fprintf(ASM,"\taddi %s,$zero,%s\n", Rd2.c_str(), Rs.c_str());
  			fprintf(ASM,"\tslt %s,%s,$zero\n", Rd2.c_str(), Rd2.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
  			Label++;
          		fprintf(ASM,"\taddi %s,$zero,1\n", Rd2.c_str());
  			fprintf(ASM,"\tbeq %s,%s L%d\n", Rd2.c_str(), Rd1.c_str(), Label); //if Rd1 is equal to one go to pc + 4+ label
  			fprintf(ASM,"\tslt %s,$zero %s\n", Rd1.c_str(), Rt.c_str());
  			fprintf(ASM,"\tslt %s,%s,$ero\n", Rd2.c_str(), Rt.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
  			fprintf(ASM,"\tL%d:\n", Label);
        	}
        	else if(Rt[0]!='$')
        	{
          		fprintf(ASM,"\tslt %s,$zero,%s\n", Rd1.c_str(), Rs.c_str());
  			fprintf(ASM,"\tslt %s,%s,$zero\n", Rd2.c_str(), Rs.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
  			Label++;
          		fprintf(ASM,"\taddi %s,$zero,1\n",Rd2.c_str());
  			fprintf(ASM,"\tbeq %s,%s,L%d\n", Rd2.c_str(), Rd1.c_str(), Label);
  			fprintf(ASM,"\tslti %s,$zero,%s\n", Rd1.c_str(), Rt.c_str());
  			fprintf(ASM,"\taddi %s,$zero,%s\n", Rd2.c_str(), Rt.c_str());
  			fprintf(ASM,"\tslt %s,%s,$zero\n", Rd2.c_str(), Rd2.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
  			fprintf(ASM,"\tL%d:\n",Label);
        	}
        	
  		else
  		{
          		fprintf(ASM,"\tslt %s,$zero,%s\n", Rd1.c_str(), Rs.c_str());
  			fprintf(ASM,"\tslt %s,%s,$zero \n", Rd2.c_str(), Rs.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
  			Label++;
          		fprintf(ASM,"\taddi %s,$zero,1\n", Rd2.c_str());
  			fprintf(ASM,"\tbeq %s,%s,L%d\n", Rd2.c_str(), Rd1.c_str(), Label);
  			fprintf(ASM,"\tslt %s,$zero,%s\n", Rd1.c_str(), Rt.c_str());
  			fprintf(ASM,"\tslt %s,%s,$zero\n", Rd2.c_str(), Rt.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
  			fprintf(ASM,"\tL%d:\n", Label);
        	}
        	
        	FreeRegister(Rd2);
        	if(Rs[1] == 't')
  			FreeRegister(Rs);
  		if(Rt[1] == 't')
  			FreeRegister(Rt);
  			
  		fclose(ASM);
  		Stack.push(Rd1);
  		type_of_expr_at_hand = 'b';
  		}
  		
  		else{
  			string message = "only variables in boolean can or with each other";
			yyerror(message.c_str());
		}
	}
	| expr TOKEN_CONDITIONOP_AND expr 
	{
		if((($1 == INT_MAX || $1 == INT_MIN) && ($3 == INT_MAX || $3 == INT_MIN)))
		{
		
		ASM = fopen("Output.asm", "a+");
		
        	if( ( ($1 == INT_MAX) && ($3 == INT_MAX) ) ) 
			$$ = INT_MAX;
		 else 
			$$ = INT_MIN;
			
  		string Rt = Stack.top();
        	Stack.pop();
  		string Rs = Stack.top();
        	Stack.pop();
        	
        	string Rd1 = AssignRegister('t');
        	string Rd2 = AssignRegister('t');
        	
  		if(Rs[0]!='$' && Rt[0]!='$')
  			fprintf(ASM,"\taddi %s,$zero,%d\n", Rd1.c_str(),stoi(Rs)&&stoi(Rt));
  			
  		else if(Rs[0]!='$')
  		{
          		fprintf(ASM,"\tslti %s,$zero,%s\n", Rd1.c_str(), Rs.c_str());
  			fprintf(ASM,"\taddi %s,$zero,%s\n", Rd2.c_str(), Rs.c_str());
  			fprintf(ASM,"\tslt %s,%s,$zero\n", Rd2.c_str(), Rd2.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
  			Label++;
  			fprintf(ASM,"\tbeq %s,$zero L%d\n", Rd1.c_str(), Label); //if Rd1 is zero go to pc+4+labal
  			fprintf(ASM,"\tslt %s,$zero %s\n", Rd1.c_str(), Rt.c_str());
  			fprintf(ASM,"\tslt %s,%s,$ero\n", Rd2.c_str(), Rt.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
  			fprintf(ASM,"\tL%d:\n", Label);
        	}
        	
        	else if(Rt[0]!='$')
        	{
          		fprintf(ASM,"\tslt %s,$zero,%s\n", Rd1.c_str(), Rs.c_str());
  			fprintf(ASM,"\tslt %s,%s,$zero\n", Rd2.c_str(), Rs.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
  			Label++;
  			fprintf(ASM,"\tbeq %s,$zero,L%d\n", Rd1.c_str(), Label);
  			fprintf(ASM,"\tslti %s,$zero,%s\n", Rd1.c_str(), Rt.c_str());
  			fprintf(ASM,"\taddi %s,$zero,%s\n", Rd2.c_str(), Rt.c_str());
  			fprintf(ASM,"\tslt %s,%s,$zero\n", Rd2.c_str(), Rd2.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
  			fprintf(ASM,"\tL%d:\n",Label);
        	}
        	
  		else{
          		fprintf(ASM,"\tslt %s,$zero,%s\n", Rd1.c_str(), Rs.c_str());
  			fprintf(ASM,"\tslt %s,%s,$zero \n", Rd1.c_str(), Rs.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd1.c_str());
  			Label++;
  			fprintf(ASM,"\tbeq %s,$zero,L%d\n", Rd1.c_str(), Label);
  			fprintf(ASM,"\tslt %s,$zero,%s\n", Rd1.c_str(), Rt.c_str());
  			fprintf(ASM,"\tslt %s,%s,$zero\n", Rd1.c_str(), Rt.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
  			fprintf(ASM,"\tL%d:\n", Label);
        	}
        	
        	FreeRegister(Rd2);
        	if(Rs[1] == 't')
  			FreeRegister(Rs);
  		if(Rt[1] == 't')
  			FreeRegister(Rt);
  			
  		fclose(ASM);
  		Stack.push(Rd1);
  		type_of_expr_at_hand = 'b';
  		}
  		
  		else{
  			string message = "only variables in boolean can and with each other";
			yyerror(message.c_str());
		}
	}
	;
	
expr1: TOKEN_LP expr TOKEN_RP { $$ = $2; }
	| TOKEN_LOGICOP expr 
	{
		if( ($2 == INT_MAX) || ($2 == INT_MIN) ) {
		
		if( $2 == INT_MAX )
			$$ = INT_MIN;
		if($2 == INT_MIN)
			$$ = INT_MAX;
		
  		string Rs = Stack.top();
        	Stack.pop();
        	
        	if(Rs[0]!='$')
        	{
        	
  			if(Rs[0] == 0)
  			
  				Stack.push("1");
  			else
  				Stack.push("0");
        	}
        	
        	else
        	{
          		string Rd1 = AssignRegister('t');
          		string Rd2 = AssignRegister('t');
  			ASM = fopen("Output.asm", "a+");
  			fprintf(ASM,"\tslt %s,$zero,%s\n", Rd1.c_str(), Rs.c_str());
  			fprintf(ASM,"\tslt %s,%s,$zero\n", Rd2.c_str(), Rs.c_str());
  			fprintf(ASM,"\tor %s,%s,%s\n", Rd1.c_str(), Rd1.c_str(), Rd2.c_str());
  			fprintf(ASM,"\txori %s,%s,1\n", Rd1.c_str(), Rd1.c_str());
  			FreeRegister(Rd2);
  			
  			if(Rs[1] == 't')
  				FreeRegister(Rs);
  			
          		fclose(ASM);
    			Stack.push(Rd1);
    		
  		}
  		}
  		
  		else{
  			string message = "only variable in boolean can be not";
			yyerror(message.c_str());
		}
  			
	}
	| TOKEN_ARITHMATICOP_SUB expr 
	{
		if( ($2 != INT_MAX) && ($2 != INT_MIN) ) {
		
		$$ = -$2;
		
  		string Rs = Stack.top();
        	Stack.pop();
        	
        	if(Rs[0]!='$')
          		Stack.push("-"+to_string($2));
  		else
  		{
  			string Rd = AssignRegister('t');
  			ASM = fopen("Output.asm", "a+");
  			fprintf(ASM,"\tsub %s,$zero,%s\n", Rd.c_str(), Rs.c_str());
          		fclose(ASM);
    			Stack.push(Rd);
  		}
  		
  		}
  		
  		else{
  			string message = "boolean variables can not become negative ";
			yyerror(message.c_str());
		}
	}
	;
	

literal: int_literal
		{
			$$ = $1;
			printf("\nrule 5 	intliteral== %d\n",$1);
		} 
	| char_literal 
		{
			$$ = $1;
		}
	| bool_literal 
		{
			$$ = $1;
		};
int_literal: decimal_literal
			{
				$$ = $1;
			}
		 | hex_literal {};
decimal_literal: TOKEN_DECIMALCONST 
			{
				$$ = atoi($1);
			};
			
hex_literal: TOKEN_HEXADECIMALCONST 
			{
				$$ = atoi($1);
			};
			
char_literal: TOKEN_CHARCONST 
			{
				$$ = atoi($1);
			};
			
bool_literal: TOKEN_BOOLEANCONST 
			{
				$$ = atoi($1);
			};
			
string_literal: TOKEN_STRINGCONST 
			{
				$$ = strdup($1);
			};
id: TOKEN_ID  { $$ = $1;};


callout_arg: expr | string_literal{} ;  ////OM
mainfunc: TOKEN_MAINFUNC {};




%%

int main(int argc, char* argv[]) { 
     yyin = fopen(argv[1], "r");
	//yyout = fopen(3.output,"w");
     yyparse();
     return 0;
}
void yyerror(const char *s)
{
     printf("%s", s);
}




string AssignRegister(char registerType){

  switch(registerType){
		case 't':
				for(int i=0; i<=9; i++)
					if(t_registers_state[i] == 0) //free
						{t_registers_state[i] = 1;return "$t"+to_string(i);}
				break;
		case 's':
				for(int i=0; i<=7; i++)
					if(s_registers_state[i] == 0)
						{s_registers_state[i] = 1;return "$s"+to_string(i);}
				break;
		case 'a':
				for(int i=0; i<=3; i++)
					if(a_registers_state[i] == 0)
						{a_registers_state[i] = 1;return "$a"+to_string(i);}
				break;
	}
	
  return "$"; //no free register 
}

void FreeRegister(string reg){
  switch(reg[1]){
		case 't':
			t_registers_state[reg[2]-'0'] = 0;
			break;
		case 's':
			s_registers_state[reg[2]-'0'] = 0;
			break;
		case 'a':
			a_registers_state[reg[2]-'0'] = 0;
			break;
	}
}



void add_identifier(char* identifier/*,string scope*/,string reg,char type){
  struct identifier *ni = (struct identifier*)malloc(sizeof(struct identifier));///////////
  ni->id_name = identifier;
 // ns->scope=scope;
  ni->reg=reg;
  ni->type=type;
  identifiers.push_back(ni); //add to vector
  printf("\nadded id  === %s with reg == %s\n",strdup(identifiers[(identifiers.size()) - 1]->id_name),(identifiers[(identifiers.size()) - 1]->reg).c_str());
}

struct identifier* search_identifier(char* identifier/*,string scope*/)
{
  for(int i=0;i<identifiers.size();i++)
  {
    if (strcmp(identifier,identifiers[i]->id_name)==0){
      return identifiers[i];
    }
    }
   return NULL;
}


void add_method(char* name,char outType,int args){
struct method *nm = (struct method*)malloc(sizeof(struct method));///////////
  nm->name=name;
  nm->outType=outType;
  nm->args=args;
  methods.push_back(nm); //add to vector
  printf("\nadded method  === %s with %d arguments\n",strdup(methods[(methods.size()) - 1]->name),number_of_args);
  
}

struct method* search_method(const char* name){
  for(int i=0;i<methods.size();i++)
    if(strcmp(name,methods[i]->name)==0)
      return methods[i];
  return NULL;
}








