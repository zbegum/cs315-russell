%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
extern int yylineno;
%}


%token PROGRAM_BEGIN PROGRAM_END
%token LC RC LP RP LS RS SC COMMA COLUMN DOUBLE_COLUMN
%token VAR_TYPE BOOLEAN STRING INTEGER
%token IF ELSE_IF ELSE
%token FOR_EACH FOR_EACH_SYMBOL WHILE BREAK RETURN
%token ARRAY_IDENTIFIER FUNCTION_IDENTIFIER IDENTIFIER ARRAY_ELEMENT FILL_WITH
%token INPUT_SYMBOL OUTPUT_SYMBOL COMMENT

%left AND_OP OR_OP NOT_OP EQL_OP NEQ_OP IMPLY_OP IFF_OP
%right ASSIGNMENT_OP
%start russell

%%
russell:
	PROGRAM_BEGIN PROGRAM_END
	|PROGRAM_BEGIN stmnt_list PROGRAM_END
	|func_list PROGRAM_BEGIN PROGRAM_END
	|func_list PROGRAM_BEGIN stmnt_list PROGRAM_END

stmnt_list:
	stmnt_list stmnt
	|stmnt

func_list:
	func_list funct_decl
	|funct_decl

identifier_list:
    IDENTIFIER
    | IDENTIFIER COMMA identifier_list

binary_op:
	AND_OP
	|OR_OP
	|IMPLY_OP
	|IFF_OP

logic_expr:
	compound_expr
	|atomic_expr

atomic_expr:
	IDENTIFIER
	|ARRAY_ELEMENT
	|BOOLEAN 

compound_expr:
	LP logic_expr binary_op logic_expr RP
	| NOT_OP logic_expr

stmnt:
	if_stmnt
	|loop_stmnt
	|assign_stmnt
	|io_stmnt
	|decl_stmnt
	|func_call
	|COMMENT
	|return_stmnt
	|break_stmnt

if_stmnt:
	IF LP logic_expr RP LC stmnt_list RC
	|IF LP logic_expr RP LC stmnt_list RC ELSE LC stmnt_list RC
	|IF LP logic_expr RP LC stmnt_list RC elseif_list ELSE LC stmnt_list RC

elseif_list:
	ELSE_IF LP logic_expr RP LC stmnt_list RC
	|elseif_list ELSE_IF LP logic_expr RP LC stmnt_list RC

decl_stmnt: 
	var_decl
	|arr_decl
	|funct_decl

var_decl:
	VAR_TYPE identifier_list SC
	|VAR_TYPE IDENTIFIER ASSIGNMENT_OP logic_expr SC
	|VAR_TYPE IDENTIFIER ASSIGNMENT_OP func_call

arr_decl:
	ARRAY_IDENTIFIER ASSIGNMENT_OP INTEGER SC
	|ARRAY_IDENTIFIER ASSIGNMENT_OP INTEGER LC logic_expr_list RC SC

function_signature:
	FUNCTION_IDENTIFIER LP parameter_list RP

parameter_list:
	parameter
	|parameter COMMA parameter_list

parameter:
	logic_expr
	|ARRAY_IDENTIFIER

assign_stmnt:
	var_assign_stmnt
	|arr_assign_stmnt

var_assign_stmnt:
	IDENTIFIER ASSIGNMENT_OP logic_expr SC 
	| IDENTIFIER ASSIGNMENT_OP func_call

arr_assign_stmnt: 
	ARRAY_ELEMENT ASSIGNMENT_OP logic_expr SC
	|ARRAY_IDENTIFIER ASSIGNMENT_OP LC logic_expr_list RC SC

loop_stmnt:
	while_stmnt
	|for_each_stmnt

while_stmnt:
	WHILE LP logic_expr RP LC stmnt_list RC 

for_each_stmnt:
	FOR_EACH LP IDENTIFIER FOR_EACH_SYMBOL ARRAY_IDENTIFIER RP LC stmnt_list RC
	|FOR_EACH LP IDENTIFIER FOR_EACH_SYMBOL INTEGER LC logic_expr_list RC RP LC stmnt_list RC

io_stmnt:
	in_stmnt
	|out_stmnt

funct_decl:
	function_signature LC stmnt_list RC

in_stmnt:
	IDENTIFIER INPUT_SYMBOL SC

out_stmnt:
	OUTPUT_SYMBOL io_expr SC
	|IDENTIFIER OUTPUT_SYMBOL SC

io_expr:
	io
	|io DOUBLE_COLUMN io_expr

io:
	STRING
	|logic_expr

return_stmnt:
	RETURN logic_expr SC
	
break_stmnt:
	BREAK SC

func_call:
	function_signature SC

logic_expr_list:
    FILL_WITH
    | FILL_WITH COMMA logic_expr_terms %prec COMMA
    | logic_expr_terms COMMA FILL_WITH
    | logic_expr_terms COMMA FILL_WITH COMMA logic_expr_terms %prec COMMA
    | logic_expr_terms
 
logic_expr_terms:
    BOOLEAN %prec BOOLEAN
    | logic_expr_terms COMMA BOOLEAN %prec COMMA

%%

#include "lex.yy.c"

int yyerror(char *s){
  fprintf(stderr, "Syntax error on line %d\n", yylineno);
  return 1;
}

int main(){
  if (yyparse() == 0) { printf("Input program is valid!\n"); return 0;}
  else{
  return 1;
  }
  return 0;
}

