%{ 
#include <stdio.h> 
#include <stdlib.h>
#include <math.h>
#include <string.h>

#include "phase2.tab.h"


extern int yylex();
void yyerror(const char *s);
float get_hash(char* key);
void put_hash(char* key,float value);
void add_hash(char* key,float value);
extern FILE* yyin;
//extern FILE* yyout;
float val;
int i;
void PRINT(struct  node* ROOT,int I);

//char* space = strdup(" ");

struct node {
    char* name;
    int tokene; //if it is terminal or nonterminal
    char* tname;
    
   struct  node* parent;
   struct  node* child1;
   struct  node* child2;
   struct  node* child3;
   struct  node* child4;
   struct  node* child5;  
   struct  node* child6;
   struct  node* child7;
};

struct node* new_node(const char* Name,int Tokene,const char* Tname,struct  node* Parent,struct  node* c1, struct  node* c2, struct  node* c3, struct  node* c4, struct  node* c5, struct  node* c6,struct  node* c7)
{
//struct node Node;
struct node* tNode = (struct node*)malloc(sizeof(struct node));
tNode -> name = strdup(Name);
tNode -> tokene = Tokene;
tNode -> tname = strdup(Tname);

tNode -> parent = Parent;
tNode -> child1 = c1;
tNode -> child2 = c2;
tNode-> child3 = c3;
tNode -> child4 = c4;
tNode -> child5 = c5;
tNode -> child5 = c6;
tNode -> child5 = c7;

return tNode;
}


//struct node* nul = new_node(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ; 


%}



%union {
  int ival;
  const char* sval;
  struct  node* Node;
};

%token <sval> TOKEN_PROGRAMCLASS
%token <sval> TOKEN_CLASS
%token <sval> TOKEN_MAINFUNC
%token <sval> TOKEN_ID
%token <sval>TOKEN_VOIDTYPE
%token <sval> TOKEN_INTTYPE
%token <sval> TOKEN_BOOLEANTYPE
%token <sval> TOKEN_BREAKSTMT
%token <sval> TOKEN_CONTINUESTMT
%token <sval> TOKEN_RETURN
%token <sval> TOKEN_IFCONDITION
%token <sval> TOKEN_LOOP
%token <sval> TOKEN_COMMA
%token <sval> TOKEN_HEXADECIMALCONST
%token <sval> TOKEN_DECIMALCONST
%token <sval> TOKEN_WHITESPACE
%token <sval> TOKEN_SEMICOLON
%token <sval> TOKEN_ARITHMATICOP
%token <sval> TOKEN_LCB
%token <sval> TOKEN_RCB
%token <sval> TOKEN_LP
%token <sval> TOKEN_RP
%token <sval> TOKEN_LB
%token <sval> TOKEN_RB
%token <sval> TOKEN_CHARCONST
%token <sval> TOKEN_CALLOUT
%token <sval> TOKEN_ELSECONDITION
%token <sval> TOKEN_BOOLEANCONST
%token <sval> TOKEN_RELATIONOP
%token <sval> TOKEN_EQUALITYOP
%token <sval> TOKEN_CONDITIONOP
%token <sval> TOKEN_STRINGCONST
%token <sval> TOKEN_ASSIGNOP_ADD
%token <sval> TOKEN_ASSIGNOP_SUB
%token <sval> TOKEN_ASSIGNOP
%token <sval> TOKEN_LOGICOP


// REVISED BY TA ------------------------
%token <sval> TOKEN_ARITHMATICOP_MUL
%token <sval> TOKEN_ARITHMATICOP_DIV
%token <sval> TOKEN_ARITHMATICOP_ADD
%token <sval> TOKEN_RELATIONOP_S
%token <sval> TOKEN_RELATIONOP_B
%token <sval> TOKEN_RELATIONOP_SE
%token <sval> TOKEN_RELATIONOP_BE
%token <sval> TOKEN_CONDITIONOP_OR
%token <sval> TOKEN_CONDITIONOP_AND
%token <sval> TOKEN_ARITHMATICOP_SUB
%token <sval> TOKEN_NOT_EQUALITYOP

//----------------------------------------





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


%nterm <Node> program
%nterm <Node> field_decl
%nterm <Node> method_decl

%nterm <Node> field_declG
%nterm <Node> method_declG
%nterm <Node> field_decl1G
%nterm <Node> field_decl2
//%nterm  method_return_type
%nterm <Node> method_name_m
%nterm <Node> method_arguments
%nterm <Node> method_argumentsG
%nterm <Node> idG
%nterm <Node> optional_argument
//%nterm <Node> optional_argument2
%nterm <Node> optional_else
%nterm <Node> optional_expr
%nterm <Node> optional_callout_arg
%nterm <Node> callout_argG
%nterm <Node> programm
%nterm <Node> class
%nterm <Node> mainfunc

%nterm <Node> type

%nterm <Node> int_literal
%nterm <Node> block
%nterm <Node> var_decl
%nterm <Node> statement
//%nterm  assign_op
%nterm <Node> expr
%nterm <Node> location
%nterm <Node> expr1
%nterm <Node> id
%nterm <Node> method_call
%nterm <Node> method_name
%nterm <Node> string_literal
%nterm <Node> callout_arg

%nterm <Node>literal
%nterm <Node>decimal_literal
%nterm<Node> hex_literal
%nterm <Node>char_literal
%nterm <Node> bool_literal
//%nterm bin_op
//%nterm arith_op
//%nterm rel_op
//%nterm eq_op
//%nterm cond_op

%nterm <Node> here


// REVISED BY TA ------------------------
%nterm <Node> method_argumentsG1
%nterm <Node> method_argumentsG2
%nterm <Node> method_argumentsG3
%nterm <Node> var_declG
%nterm <Node> statementG
//%nterm <Node> optional_argument3
//%nterm <Node> optional_argument4



//----------------------------------------


%%


program:class programm TOKEN_LCB here TOKEN_RCB 

	{
	printf("\nfine10\n");
	struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
	
	//nul.name = NULL;nul.tokene = 1;nul.tname = NULL;nul.child1 = n;nul.child2 = n;nul.child3 = n;nul.child4 = n;nul.child5 = n;
	
	struct node* root = new_node("<program> ",0,"",nul, $1,$2,nul,$4,nul,nul,nul);
	
	$1->parent = root;
	$2->parent = root;
	$4->parent = root; 
	struct node* n3 = new_node($3,1,"TOKEN_LCB ",root, nul,nul,nul,nul,nul,nul,nul); 
	root->child3 = n3;
	struct node* n5 = new_node($5,1,"TOKEN_RCB ",root, nul,nul,nul,nul,nul,nul,nul); 
	root->child5 = n5;
	$$ = root;
	
	PRINT(root,i);
	//printf("\ngot rule 1\n%s %s %s %s %s "$1->name,$2->name,$3->name,$4->name,$5->name);
	};
	
here: 		field_declG method_declG
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,$2,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$2->parent = nn; 
			$$ = nn; 
		}
		
		|field_declG
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
			$1->parent = nn;  
			$$ = nn; 
		}
		
		|method_declG
		{
			printf("\nfine5\n");	
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
			$1->parent = nn;  
			$$ = nn; 
		}
 		| /*epsilon*/ {};
	
field_declG: 	field_decl
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$$ = nn;
		}
		
		|field_declG field_decl 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,$2,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$2->parent = nn; 
			$$ = nn; 
			printf("\ngot rule 2\n"); 
		}
		;
method_declG: 	method_decl
		{
			printf("\nfine11\n");
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$$ = nn;
		}
		
		|method_declG method_decl
		   
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,$2,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$2->parent = nn; 
			$$ = nn; 
			//printf("\ngot rule 3 \n\n nn%s %s",$1,$2);
		}
		;

class: 	TOKEN_CLASS 
		{
			printf("\nfine1\n");
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			printf("%d", nul->tokene);
			struct node* nn = new_node("", 0 , "",nul,nul,nul,nul,nul,nul,nul,nul);
			printf("\nfine2\n");
			struct node* n1 = new_node($1,1,"TOKEN_CLASS ",nn, nul,nul,nul,nul,nul,nul,nul); 
			printf("\nfine3\n");
			nn->child1 = n1;
			$$ = nn; 
			printf("TOKEN_CLASS\t");
		}
		;
		
programm: 	TOKEN_PROGRAMCLASS 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, nul,nul,nul,nul,nul,nul,nul);
			struct node* n1 = new_node($1,1,"TOKEN_PROGRAMCLASS ",nn, nul,nul,nul,nul,nul,nul,nul); 
			nn->child1 = n1;
			printf("%s", nn->child1->tname);
			$$ = nn; 
			printf("TOKEN_PROGRAMCLASS\t");
		}
		;

field_decl: 	type field_decl1G TOKEN_SEMICOLON 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<field_decl> ",0,"",nul, $1,$2,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$2->parent = nn; 
			struct node* n3 = new_node($3,1,"TOKEN_SEMICOLON ",nn, nul,nul,nul,nul,nul,nul,nul); 
			nn->child3 = n3;
			$$ = nn; 
			printf("\ngot rule 4\n");
		};
		
field_decl1G: 	field_decl1G TOKEN_COMMA field_decl2
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,nul,$3,nul,nul,nul,nul);
			$1->parent = nn;  
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_COMMA ",nn, nul,nul,nul,nul,nul,nul,nul); 
			nn->child2 = n2;
			$$ = nn;
		}
		
		|field_decl2 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$$ = nn; 
			printf("\ngot rule 5\n");
		}
		;
		
field_decl2: 	id
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
			$1->parent = nn;  
			$$ = nn;
		}
		
		|id TOKEN_LB int_literal TOKEN_RB 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul,$1,nul,$3,nul,nul,nul,nul);
			$1->parent = nn;  
			$3->parent = nn;
			struct node* n2 = new_node($2,1,"TOKEN_LB ",nn, nul,nul,nul,nul,nul,nul,nul); 
			nn->child2 = n2;
			struct node* n4 = new_node($4,1,"TOKEN_RB ",nn, nul,nul,nul,nul,nul,nul,nul); 
			nn->child2 = n4;
			$$ = nn;  
			printf("\ngot rule 6\n");
		}
		
		|/*epsilon*/ {} ;

method_decl: 	type method_name_m method_arguments block 
		{
			printf("\nfine12\n");
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<method_decl> ",0,"",nul, $1,$2,$3,$4,nul,nul,nul);
			$1->parent = nn; 
			$2->parent = nn; 
			$3->parent = nn; 
			$4->parent = nn; 
			$$ = nn;
		}
		| TOKEN_VOIDTYPE method_name_m method_arguments block 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<method_decl> ",0,"",nul, nul,$2,$3,$4,nul,nul,nul); 
			$2->parent = nn; 
			$3->parent = nn; 
			$4->parent = nn;
			struct node* n1 = new_node($1,1,"TOKEN_VOIDTYPE ",nn, nul,nul,nul,nul,nul,nul,nul); 
			nn->child1 = n1; 
			$$ = nn;  
			printf("\ngot rule 7\n");
		}
		;

//method_return_type: type|TOKEN_VOIDTYPE {printf("\ngot rule 8\n");};

method_name_m: 	id
			{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
				$1->parent = nn; 
				$$ = nn;
			}
			
			|mainfunc 
			{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
				$1->parent = nn; 
				$$ = nn;  
				printf("\ngot rule 9\n");
			}
			;
			
method_arguments: 	TOKEN_LP method_argumentsG TOKEN_RP
			{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("",0,"",nul, nul,$2,nul,nul,nul,nul,nul); 
				$2->parent = nn; 
				struct node* n1 = new_node($1,1,"TOKEN_LP ",nn, nul,nul,nul,nul,nul,nul,nul); 
				nn->child1 = n1;
				struct node* n3 = new_node($3,1,"TOKEN_RP ",nn, nul,nul,nul,nul,nul,nul,nul);
				nn->child3 = n3;
				$$ = nn;
			}
			
			|TOKEN_LP TOKEN_RP 
			{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("",0,"",nul, nul,nul,nul,nul,nul,nul,nul);
				struct node* n1 = new_node($1,1,"TOKEN_LP ",nn, nul,nul,nul,nul,nul,nul,nul);
				struct node* n2 = new_node($2,1,"TOKEN_RP ",nn, nul,nul,nul,nul,nul,nul,nul);
				nn->child1 = n1;
				nn->child2 = n2;
				$$ = nn;  
				printf("\ngot rule 10\n");
			}
			;

method_argumentsG: 	type id TOKEN_COMMA method_argumentsG1 
			{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("",0,"",nul, $1,$2,nul,$4,nul,nul,nul);
				$1->parent = nn; 
				$2->parent = nn;  
				$4->parent = nn; 
				struct node* n3 = new_node($3,1,"TOKEN_COMMA ",nn, nul,nul,nul,nul,nul,nul,nul);
				nn->child3 = n3;
				$$ = nn;
			}
			
			|type id 
			{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("",0,"",nul, $1,$2,nul,nul,nul,nul,nul);
				$1->parent = nn; 
				$2->parent = nn;  
				$$ = nn;
			}
			;
			
method_argumentsG1: 	type id method_argumentsG2  
			{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("",0,"",nul, $1,$2,$3,nul,nul,nul,nul);
				$1->parent = nn; 
				$2->parent = nn; 
				$3->parent = nn; 
				$$ = nn;
			};
			
method_argumentsG2: 	TOKEN_COMMA type id method_argumentsG3 
			{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("",0,"",nul, nul,$2,$3,$4,nul,nul,nul); 
				$2->parent = nn; 
				$3->parent = nn; 
				$4->parent = nn; 
				struct node* n1 = new_node($1,1,"TOKEN_COMMA ",nn, nul,nul,nul,nul,nul,nul,nul);
				nn->child1 = n1;
				$$ = nn;
			}
			
 			| /*epsilon*/ {};
 
method_argumentsG3: 	TOKEN_COMMA type id 
			{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("",0,"",nul, nul,$2,$3,nul,nul,nul,nul); 
				$2->parent = nn; 
				$3->parent = nn;
				struct node* n1 = new_node($1,1,"TOKEN_COMMA ",nn, nul,nul,nul,nul,nul,nul,nul);
				nn->child1 = n1;
				$$ = nn;
			}
			| /*epsilon*/ {};  ////takmil 
 

block: 	TOKEN_LCB var_declG statementG TOKEN_RCB
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<block> ",0,"",nul, nul,$2,$3,nul,nul,nul,nul);  
			$2->parent = nn; 
			$3->parent = nn;
			struct node* n1 = new_node($1,1,"TOKEN_LCB ",nn, nul,nul,nul,nul,nul,nul,nul);
			nn->child1 = n1;
			struct node* n4 = new_node($4,1,"TOKEN_RCB ",nn, nul,nul,nul,nul,nul,nul,nul);
			nn->child4 = n4;
			$$ = nn;
		}
		
		|TOKEN_LCB var_declG TOKEN_RCB 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<block> ",0,"",nul, nul,$2,nul,nul,nul,nul,nul); 
			$2->parent = nn; 
			struct node* n1 = new_node($1,1,"TOKEN_LCB ",nn, nul,nul,nul,nul,nul,nul,nul);
			nn->child1 = n1;
			struct node* n3 = new_node($3,1,"TOKEN_RCB ",nn, nul,nul,nul,nul,nul,nul,nul);
			nn->child3 = n3;
			$$ = nn;
		}
		
		|TOKEN_LCB statementG TOKEN_RCB 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<block> ",0,"",nul, nul,$2,nul,nul,nul,nul,nul); 
			$2->parent = nn; 
			struct node* n1 = new_node($1,1,"TOKEN_LCB ",nn, nul,nul,nul,nul,nul,nul,nul);
			nn->child1 = n1;
			struct node* n3 = new_node($3,1,"TOKEN_RCB ",nn, nul,nul,nul,nul,nul,nul,nul);
			nn->child3 = n3;
			$$ = nn;  
			printf("roooool 20");
		}
		
		|TOKEN_LCB  TOKEN_RCB 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<block> ",0,"",nul, nul,nul,nul,nul,nul,nul,nul);
			struct node* n1 = new_node($1,1,"TOKEN_LCB ",nn, nul,nul,nul,nul,nul,nul,nul);
			nn->child1 = n1;
			struct node* n2 = new_node($2,1,"TOKEN_RCB ",nn, nul,nul,nul,nul,nul,nul,nul);
			nn->child2 = n2;
			$$ = nn; 
			printf("\ngot rule 15\n");
		}
		;
		
var_declG: 	var_declG var_decl
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,$2,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$2->parent = nn;  
			$$ = nn;
		}
		
		|var_decl 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$$ = nn;  
			printf("\ngot rule 16\n");
		}
		;
statementG: 	statementG statement
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,$2,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$2->parent = nn;  
			$$ = nn;
		}
		|statement 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$$ = nn;  
			printf("\ngot rule 17\n");
		}
		;

var_decl: 	type idG TOKEN_SEMICOLON 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<var_decl> ",0,"",nul, $1,$2,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$2->parent = nn; 
			struct node* n1 = new_node($3,1,"TOKEN_SEMICOLON ",nn, nul,nul,nul,nul,nul,nul,nul);
			nn->child3 = n1; 
			$$ = nn;  
			printf("\ngot rule 18\n");
		}
		;

idG: 		idG TOKEN_COMMA id
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,nul,$3,nul,nul,nul,nul);
			$1->parent = nn;  
			$3->parent = nn;
			struct node* n1 = new_node($2,1,"TOKEN_COMMA ",nn, nul,nul,nul,nul,nul,nul,nul);
			nn->child2 = n1;
			$$ = nn;
		}
		|id 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$$ = nn; 
			printf("\ngot rule 19\n");
		}
		;

type: 	TOKEN_INTTYPE
		{
			printf("\nfine13\n");
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<type> ",0,"",nul, nul,nul,nul,nul,nul,nul,nul);
			struct node* n1 = new_node($1,1,"TOKEN_INTTYPE ",nn, nul,nul,nul,nul,nul,nul,nul);
			nn->child1 = n1;  
			$$ = nn; 
		}
		
	|TOKEN_BOOLEANTYPE 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<type> ",0,"",nul, nul,nul,nul,nul,nul,nul,nul); 
			struct node* n1 = new_node($1,1,"TOKEN_BOOLEANTYPE ",nn, nul,nul,nul,nul,nul,nul,nul);
			nn->child1 = n1; 
			$$ = nn;  
			printf("\ngot rule 20\n");
		}
		;

//////************************************************************************************************
statement: location TOKEN_ASSIGNOP expr TOKEN_SEMICOLON 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<statement> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn; 
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_ASSIGNOP ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			struct node* n4 = new_node($4,1,"TOKEN_SEMICOLON ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child4 = n4;
			$$ = nn; 
			printf("rule 2");
		}
		|location TOKEN_ASSIGNOP_ADD expr TOKEN_SEMICOLON 
			{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<statement> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn; 
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_ASSIGNOP_ADD ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			struct node* n4 = new_node($4,1,"TOKEN_SEMICOLON ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child4 = n4;
			$$ = nn; 
			printf("rule 2");
			}
		
		|location TOKEN_ASSIGNOP_SUB expr TOKEN_SEMICOLON
			{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<statement> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn; 
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_ASSIGNOP_SUB ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			struct node* n4 = new_node($4,1,"TOKEN_SEMICOLON ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child4 = n4;
			$$ = nn; 
			printf("rule 2");
			}
		
		
		|method_call TOKEN_SEMICOLON
			{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<statement> ",0,"",nul, $1,nul,nul,nul,nul,nul,nul); 
			$1->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_SEMICOLON ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			$$ = nn; 
			printf("rule 2");
			}
		
		|TOKEN_IFCONDITION TOKEN_LP expr TOKEN_RP block optional_else
			{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<statement> ",0,"",nul, nul,nul,$3,nul,$5,$6,nul); 
			$3->parent = nn; 
			$5->parent = nn; 
			$6->parent = nn; 
			struct node* n1 = new_node($1,1,"TOKEN_IFCONDITION ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child1 = n1;
			struct node* n2 = new_node($2,1,"TOKEN_LP ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			struct node* n4 = new_node($4,1,"TOKEN_RP ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child4 = n4;			
			$$ = nn;
			}
					
		|TOKEN_LOOP id TOKEN_EQUALITYOP expr TOKEN_COMMA expr block
			{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("<statement> ",0,"",nul, nul,$2,nul,$4,nul,$6,$7); 
				$2->parent = nn; 
				$4->parent = nn; 
				$6->parent = nn;
				$7->parent = nn; 
				struct node* n1 = new_node($1,1,"TOKEN_LOOP ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child1 = n1;
				struct node* n3 = new_node($3,1,"TOKEN_EQUALITYOP ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child3 = n3;
				struct node* n5 = new_node($5,1,"TOKEN_COMMA ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child5 = n5;
				$$ = nn;
				
			}
					
		|TOKEN_LOOP id TOKEN_NOT_EQUALITYOP expr TOKEN_COMMA expr block
			{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;	
				struct node* nn = new_node("<statement> ",0,"",nul, nul,$2,nul,$4,nul,$6,$7); 
				$2->parent = nn; 
				$4->parent = nn; 
				$6->parent = nn;
				$7->parent = nn; 
				struct node* n1 = new_node($1,1,"TOKEN_LOOP ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child1 = n1;
				struct node* n3 = new_node($3,1,"TOKEN_NOT_EQUALITYOP ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child3 = n3;
				struct node* n5 = new_node($5,1,"TOKEN_COMMA ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child5 = n5;
				$$ = nn;
				
			}
		
		|TOKEN_RETURN optional_expr TOKEN_SEMICOLON 
			{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;	
				struct node* nn = new_node("<statement> ",0,"",nul, nul,$2,nul,nul,nul,nul,nul); 
				$2->parent = nn;  
				struct node* n1 = new_node($1,1,"TOKEN_RETURN ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child1 = n1;
				struct node* n3 = new_node($3,1,"TOKEN_SEMICOLON ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child3 = n3;
				$$ = nn;
				
			}
		
		
		|TOKEN_BREAKSTMT TOKEN_SEMICOLON
			{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("<statement> ",0,"",nul,nul,nul,nul,nul,nul,nul,nul);		
				struct node* n1 = new_node($1,1,"TOKEN_BREAKSTMT ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child1 = n1;
				struct node* n2 = new_node($2,1,"TOKEN_SEMICOLON ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child2 = n2;			
				$$ = nn; 
			}
			
		|TOKEN_CONTINUESTMT TOKEN_SEMICOLON
		
			{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("<statement> ",0,"",nul,nul,nul,nul,nul,nul,nul,nul);		
				struct node* n1 = new_node($1,1,"TOKEN_CONTINUESTMT ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child1 = n1;
				struct node* n2 = new_node($2,1,"TOKEN_SEMICOLON ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child2 = n2;			
				$$ = nn; 
			}
		
		|block
			{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("<statement> ",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
				$1->parent = nn;  
				$$ = nn;
			}
		;
optional_else:	TOKEN_ELSECONDITION block
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;	
			struct node* nn = new_node("",0,"",nul, nul,$2,nul,nul,nul,nul,nul); 
			$2->parent = nn; 
			struct node* n1 = new_node($1,1,"TOKEN_ELSECONDITION ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child1 = n1;			
			$$ = nn;	
		}
	| /*epsilon*/ {};
		
optional_expr: expr 
	{
		struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
		struct node* nn = new_node("",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
		$1->parent = nn; 
		$$ = nn;  
		printf("rule 2100");
	};

//assign_op:TOKEN_ASSIGNOP {printf("rule 10");};

method_call: method_name TOKEN_LP optional_argument TOKEN_RP
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<method_call> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn; 
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_LP ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			struct node* n4 = new_node($4,1,"TOKEN_RP ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child4 = n4;				
			$$ = nn;
		}
	|TOKEN_CALLOUT TOKEN_LP string_literal optional_callout_arg TOKEN_RP 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<method_call> ",0,"",nul, nul,nul,$3,$4,nul,nul,nul); 
			$3->parent = nn; 
			$4->parent = nn; 
			struct node* n1 = new_node($1,1,"TOKEN_CALLOUT ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child1 = n1;
			struct node* n2 = new_node($2,1,"TOKEN_LP ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			struct node* n5 = new_node($5,1,"TOKEN_RP ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child5 = n5;			
			$$ = nn;
		};
		
optional_argument: expr 
		{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("",0,"",nul, $1,nul,nul,nul,nul,nul,nul); 
				$1->parent = nn; 
				$$ = nn; 
		}
	| expr TOKEN_COMMA expr 
		{		
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
				$1->parent = nn; 
				$3->parent = nn; 
				struct node* n2 = new_node($2,1,"TOKEN_COMMA ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child2 = n2;
				$$ = nn;
		}	
	| expr TOKEN_COMMA expr TOKEN_COMMA expr 
		{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("",0,"",nul, $1,nul,$3,nul,$5,nul,nul); 
				$1->parent = nn; 
				$3->parent = nn; 
				$5->parent = nn;
				struct node* n2 = new_node($2,1,"TOKEN_COMMA ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child2 = n2;
				struct node* n4 = new_node($4,1,"TOKEN_COMMA ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child4 = n4;
				$$ = nn;
		}
	| expr TOKEN_COMMA expr TOKEN_COMMA expr TOKEN_COMMA expr
		{
				struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
				struct node* nn = new_node("",0,"",nul, $1,nul,$3,nul,$5,nul,$7); 
				$1->parent = nn; 
				$3->parent = nn; 
				$5->parent = nn;
				$7->parent = nn; 
				struct node* n2 = new_node($2,1,"TOKEN_COMMA ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child2 = n2;
				struct node* n4 = new_node($4,1,"TOKEN_COMMA ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child4 = n4;
				struct node* n6 = new_node($6,1,"TOKEN_COMMA ",nn, nul,nul,nul,nul,nul,nul,nul);  
				nn->child6 = n6;
				$$ = nn;
		}
	| /*epsilon*/ {};
	
	
optional_callout_arg: TOKEN_COMMA callout_argG 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, nul,$2,nul,nul,nul,nul,nul); 
			$2->parent = nn; 
			struct node* n1 = new_node($1,1,"TOKEN_COMMA ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child1 = n1;
			$$ = nn;
		};
		
callout_argG: callout_argG TOKEN_COMMA callout_arg
		{	
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn; 
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_COMMA ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			$$ = nn;			
		}
		
		|callout_arg 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$$ = nn;
		};

method_name: id 	
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<method_name> ",0,"",nul, $1,nul,nul,nul,nul,nul,nul); 
			$1->parent = nn; 
			$$ = nn;
		};


location: id 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<location> ",0,"",nul, $1,nul,nul,nul,nul,nul,nul); 
			$1->parent = nn; 
			$$ = nn; 
			printf("rule 1");
		}
	| id TOKEN_LB expr TOKEN_RB TOKEN_SEMICOLON 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<location> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn; 
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_LB ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			struct node* n4 = new_node($4,1,"TOKEN_RB ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child4 = n4;
			struct node* n5 = new_node($5,1,"TOKEN_SEMICOLON ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child5 = n5;
			$$ = nn;
	
		}; 

expr: location 
		{	
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,nul,nul,nul,nul,nul); 
			$1->parent = nn; 
			$$ = nn;
		}
		
	| method_call 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,nul,nul,nul,nul,nul); 
			$1->parent = nn; 
			$$ = nn;
		}
		
	| literal 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,nul,nul,nul,nul,nul); 
			$1->parent = nn; 
			$$ = nn;
		}
	| expr1 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,nul,nul,nul,nul,nul); 
			$1->parent = nn; 
			$$ = nn;
		}
	
	| expr TOKEN_ARITHMATICOP expr 
		{
			struct node* nul =new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn;
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_ARITHMATICOP ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			$$ = nn;			
		}
		
	| expr TOKEN_ARITHMATICOP_ADD expr 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn;
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_ARITHMATICOP_ADD ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			$$ = nn;			
		}
	| expr TOKEN_ARITHMATICOP_SUB expr 
		{
			struct node* nul =new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn;
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_ARITHMATICOP_SUB ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			$$ = nn;			
		}
	| expr TOKEN_ARITHMATICOP_MUL expr 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn;
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_ARITHMATICOP_MUL ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			$$ = nn;			
		}
	| expr TOKEN_ARITHMATICOP_DIV expr 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn;
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_ARITHMATICOP_DIV ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			$$ = nn;			
		}
	| expr TOKEN_RELATIONOP_SE expr 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn;
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_RELATIONOP_SE ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			$$ = nn;			
		}
	| expr TOKEN_RELATIONOP_BE expr
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn;
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_RELATIONOP_BE ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			$$ = nn;			
		}
	
	| expr TOKEN_RELATIONOP_S expr 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn;
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_RELATIONOP_S ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			$$ = nn;			
		}
	| expr TOKEN_RELATIONOP_B expr 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn;
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_RELATIONOP_B ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			$$ = nn;			
		}
	| expr TOKEN_EQUALITYOP expr
		 {
		 	struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn;
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_EQUALITYOP ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			$$ = nn;			
		} 
		
	| expr TOKEN_NOT_EQUALITYOP expr 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn;
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_NOT_EQUALITYOP ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			$$ = nn;
			
		} 
	| expr TOKEN_CONDITIONOP_OR expr
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn;
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_CONDITIONOP_OR ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			$$ = nn;
			
		} 
	| expr TOKEN_CONDITIONOP_AND expr 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<expr> ",0,"",nul, $1,nul,$3,nul,nul,nul,nul); 
			$1->parent = nn;
			$3->parent = nn; 
			struct node* n2 = new_node($2,1,"TOKEN_CONDITIONOP_AND ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child2 = n2;
			$$ = nn;
			
		} 
	;
	
expr1: TOKEN_LP expr TOKEN_RP 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul,nul,$2,nul,nul,nul,nul,nul); 
			$2->parent = nn;
			struct node* n1 = new_node($1,1,"TOKEN_LP ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child1 = n1;
			struct node* n3 = new_node($3,1,"TOKEN_RP ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child3 = n3;
			$$ = nn;
			
		}
	| TOKEN_LOGICOP expr 
		{	
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul,nul,$2,nul,nul,nul,nul,nul); 
			$2->parent = nn;
			struct node* n1 = new_node($1,1,"TOKEN_LOGICOP ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child1 = n1;
			$$ = nn;
		
		}
	| TOKEN_ARITHMATICOP_SUB expr 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("",0,"",nul,nul,$2,nul,nul,nul,nul,nul); 
			$2->parent = nn;
			struct node* n1 = new_node($1,1,"TOKEN_ARITHMATICOP_SUB ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child1 = n1;
			$$ = nn;
			
		}
	;
	


literal: int_literal
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<literal> ",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$$ = nn;  
		} 
	| char_literal 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<literal> ",0,"",nul, $1,nul,nul,nul,nul,nul,nul); 
			$1->parent = nn; 
			$$ = nn;
		}
	| bool_literal
		 {
		 	struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
		 	struct node* nn = new_node("<literal> ",0,"",nul, $1,nul,nul,nul,nul,nul,nul); 
		 	$1->parent = nn; 
		 	$$ = nn;
		 };

int_literal: decimal_literal 
	{
		struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
		struct node* nn = new_node("<int_literal> ",0,"",nul, $1,nul,nul,nul,nul,nul,nul); 
		$1->parent = nn; 
		$$ = nn;
		
	}
	| hex_literal 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<int_literal> ",0,"",nul, $1,nul,nul,nul,nul,nul,nul);
			$1->parent = nn; 
			$$ = nn;
		};

decimal_literal: TOKEN_DECIMALCONST 
	{
		struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
		struct node* nn = new_node("<decimal_literal> ",0,"",nul, nul,nul,nul,nul,nul,nul,nul); 
		struct node* n1 = new_node($1,1,"TOKEN_DECIMALCONST ",nn, nul,nul,nul,nul,nul,nul,nul);  
		nn->child1 = n1;
		$$ = nn;
	};

hex_literal: TOKEN_HEXADECIMALCONST 
	{
		struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
		
		struct node* nn = new_node("<hex_literal> ",0,"",nul, nul,nul,nul,nul,nul,nul,nul); 
		struct node* n1 = new_node($1,1,"TOKEN_HEXADECIMALCONST ",nn, nul,nul,nul,nul,nul,nul,nul);  
		nn->child1 = n1;
		$$ = nn;
	};

char_literal: TOKEN_CHARCONST 
	{
		struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
		struct node* nn = new_node("<char_literal> ",0,"",nul, nul,nul,nul,nul,nul,nul,nul); 
		struct node* n1 = new_node($1,1,"TOKEN_CHARCONST ",nn, nul,nul,nul,nul,nul,nul,nul);  
		nn->child1 = n1;
		$$ = nn;
	};

bool_literal: TOKEN_BOOLEANCONST 
	{
		struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
		struct node* nn = new_node("<bool_literal> ",0,"",nul, nul,nul,nul,nul,nul,nul,nul); 
		struct node* n1 = new_node($1,1,"TOKEN_BOOLEANCONST ",nn, nul,nul,nul,nul,nul,nul,nul);  
		nn->child1 = n1;
		$$ = nn;
	};

string_literal: TOKEN_STRINGCONST 
	{
		struct node* nul =new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
		struct node* nn = new_node("<string_literal> ",0,"",nul, nul,nul,nul,nul,nul,nul,nul); 
		struct node* n1 = new_node($1,1,"TOKEN_STRINGCONST ",nn, nul,nul,nul,nul,nul,nul,nul);  
		nn->child1 = n1;
		$$ = nn;
	};

id: TOKEN_ID
	{	
		struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
		struct node* nn = new_node("<id> ",0,"",nul, nul,nul,nul,nul,nul,nul,nul); //node for <id>
		struct node* n1 = new_node($1,1,"TOKEN_ID ",nn, nul,nul,nul,nul,nul,nul,nul);  //node for Token_ID
		nn->child1 = n1;
		$$ = nn; 
		//printf("TOKEN_ID\t");
	};



callout_arg: 	expr
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("<callout_arg> ",0,"",nul, $1,nul,nul,nul,nul,nul,nul); 
			$1->parent = nn; 
			$$ = nn; 
		}
		
 		|string_literal
 		{
 			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
 			struct node* nn = new_node("<callout_arg> ",0,"",nul, $1,nul,nul,nul,nul,nul,nul); 
 			$1->parent = nn; 
 			$$ = nn;
 		} 
 		;
//bin_op: arith_op | rel_op | eq_op | cond_op{};
//arith_op:  TOKEN_ARITHMATICOP {};
//rel_op: TOKEN_RELATIONOP {};
//eq_op: TOKEN_EQUALITYOP {};
//cond_op: TOKEN_CONDITIONOP {};
mainfunc: 	TOKEN_MAINFUNC 
		{
			struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
			struct node* nn = new_node("main ",0,"",nul, nul,nul,nul,nul,nul,nul,nul);
			struct node* n1 = new_node($1,1,"TOKEN_MAINFUNC ",nn, nul,nul,nul,nul,nul,nul,nul);  
			nn->child1 = n1;
			$$ = nn;  
			printf("TOKEN_MAINFUNC\t");
		}
		;


//TOKEN_LP: TOKEN_LP{struct node* nn = new_node("( ",1,"TOKEN_LP ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn; };
//TOKEN_RP: TOKEN_RP{struct node* nn = new_node(") ",1,"TOKEN_RP ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn; };

//TOKEN_SEMICOLON: TOKEN_SEMICOLON{struct node* nn = new_node("; ",1,"TOKEN_SEMICOLON ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
//TOKEN_COMMA: TOKEN_COMMA{struct node* nn = new_node(", ",1,"TOKEN_COMMA ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
//TOKEN_LCB: TOKEN_LCB{struct node* nn = new_node("{ ",1,"TOKEN_LCB ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
//TOKEN_RCB: TOKEN_RCB{struct node* nn = new_node("} ",1,"TOKEN_RCB ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
//TOKEN_LB: TOKEN_LB{struct node* nn = new_node("[ ",1,"TOKEN_LB ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
//TOKEN_RB: TOKEN_RB{struct node* nn = new_node("] ",1,"TOKEN_RB ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
//TOKEN_INTTYPE: TOKEN_INTTYPE{struct node* nn = new_node(strcat($1,space),1,"TOKEN_INTTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
//Bool: TOKEN_BOOLEANTYPE{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
//////////////////////////////////
/*
TOKEN_ASSIGNOP_ADD:TOKEN_ASSIGNOP_ADD{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
TOKEN_ASSIGNOP_SUB:TOKEN_ASSIGNOP_SUB{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
assi:TOKEN_ASSIGNOP{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
if_con: TOKEN_IFCONDITION{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
loop: TOKEN_LOOP{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
equal: TOKEN_EQUALITYOP{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
n_equal: TOKEN_NOT_EQUALITYOP{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
return: TOKEN_RETURN{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
break: TOKEN_BREAKSTMT{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
continue: TOKEN_CONTINUESTMT{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
else_con: TOKEN_ELSECONDITION{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
callout: TOKEN_CALLOUT{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
logicop: TOKEN_LOGICOP{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
TOKEN_ARITHMATICOP_SUB: TOKEN_ARITHMATICOP_SUB {struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
TOKEN_ARITHMATICOP_ADD: TOKEN_ARITHMATICOP_ADD {struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
TOKEN_ARITHMATICOP_DIV:TOKEN_ARITHMATICOP_DIV{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
TOKEN_ARITHMATICOP_MUL:TOKEN_ARITHMATICOP_MUL{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
ari:TOKEN_ARITHMATICOP{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
cond_and: TOKEN_CONDITIONOP_AND{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
cond_or: TOKEN_CONDITIONOP_OR{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
TOKEN_RELATIONOP_Se: TOKEN_RELATIONOP_SE{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
TOKEN_RELATIONOP_BE:TOKEN_RELATIONOP_BE{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
TOKEN_RELATIONOP_B:TOKEN_RELATIONOP_B{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
TOKEN_RELATIONOP_S:TOKEN_RELATIONOP_S{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
deci_const: TOKEN_DECIMALCONST{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
hex_const:TOKEN_HEXADECIMALCONST{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
char_const: TOKEN_CHARCONST{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
bool_const: TOKEN_BOOLEANCONST {struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
string_const: TOKEN_STRINGCONST{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
t_id: TOKEN_ID{struct node* nn = new_node(strcat($1,space),1,"TOKEN_BOOLEANTYPE ",nul, $1,nul,nul,nul,nul,nul,nul);  $$ = nn;};
*/
%%

int main(int argc, char* argv[]) { 
	//printf("%s", argv[0]);
     yyin = fopen(argv[1], "r");
     //printf("%s", argv[0]);
     //printf("%s", argv[2]);
	//yyout = fopen(3.output,"w"); 
	i = atoi(argv[2]);
	//print("i  === %d\n",argv[2]);
     yyparse();
     return 0;
}
void yyerror(const char *s)
{
     printf("%s", s);
}


void PRINT(struct  node* n, int I)
{
	struct node* nul = new_node("",0,"",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ;
printf("\nheree\n");
	if (n->tokene == 0)//non terminal
	{
		printf("%s", n->name);
		if(n-> child1 != nul)
		{
			PRINT(n-> child1, I);
		}
		else if(n-> child2 != nul)
		{
			PRINT(n-> child1, I);
		}
		else if(n-> child3 != nul)
		{
			PRINT(n-> child3, I);
		}
		else if(n-> child4 != nul)
		{
			PRINT(n-> child4, I);
		}
		else if(n-> child5 != nul)
		{
			PRINT(n-> child5, I);
		}
		else if(n-> child6 != nul)
		{
			PRINT(n-> child6, I);
		}
		else if(n-> child7 != nul)
		{
			PRINT(n-> child7, I);
		}
			
	}
	
	if (n->tokene == 1)// terminal
	{
		if(I == 0)//value
		{
			if(n-> child1 != nul)
			{
				printf("%s", n->name);
			}
		
		}
		else //token name
		{
			if(n-> child1 != nul)
			{
				printf("%s", n->tname);
			}
		}
			
	}

}







