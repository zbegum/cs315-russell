%option yylineno

LC                     	"{"
RC                      "}"
LP                      "("
RP                      ")"
LS                      "["
RS                      "]"
newline                 \n
tab                     \t
semicolon               ";"
column                  ":"
comma                   ","
letter            	    [a-zA-Z]
digit             	    [0-9]
integer           	    [0-9]+
alphanumeric      	    {letter}+({letter}|{digit})*
lowerLetter 		    [a-z]
upperLetter        	    [A-Z]
identifier			    ({upperLetter}|{lowerLetter})*
boolean          	    (true|false)
string					(\"[^\"]*\"|\"({letter}|{digit})+{alphanumeric}\")
assign                  "="
and                     "&&"
or                      "||"
not                     "!"
eql                     "=="
fillWith 		        "..."{boolean}
neq                     "!="
imply                   "=>"
iff                     "<=>"
dec_sym                 "$bool"
func_                   "F:"
array_            	    "A:"
in_               	    ":in:"
out_            	    ":out:"
double_column     	    "::"
for_each_sym    	    "@"

%%
{LC}                          return LC;
{RC}                          return RC;
{LP}                          return LP;
{RP}                          return RP;
{LS}                          return LS;
{RS}                          return RS;
{semicolon}                   return SC;
{comma}                       return COMMA;
{column}            		  return COLUMN;
{double_column}               return DOUBLE_COLUMN;
{dec_sym}                     return VAR_TYPE;
{boolean}                     return BOOLEAN;
{string}                      return STRING;
{integer}                     return INTEGER;         
{assign}                      return ASSIGNMENT_OP;
{and}                         return AND_OP;
{or}                          return OR_OP;
{not}                         return NOT_OP;
{eql}                         return EQL_OP;
{neq}                         return NEQ_OP;
{imply}                    	  return IMPLY_OP;
{iff}                      	  return IFF_OP;
begin                         return PROGRAM_BEGIN;
end                           return PROGRAM_END;
if                            return IF;
elseif                        return ELSE_IF;
else                          return ELSE;
{for_each_sym}                return FOR_EACH_SYMBOL;
for_each                      return FOR_EACH;
while                    	  return WHILE;
break                     	  return BREAK;
return                    	  return RETURN;
{in_}                         return INPUT_SYMBOL;
{out_}                        return OUTPUT_SYMBOL;
"--".*						  return COMMENT;
{fillWith}				      return FILL_WITH;
{array_}{identifier}	      return ARRAY_IDENTIFIER;
{func_}{identifier}           return FUNCTION_IDENTIFIER;
{array_}{identifier}{LS}{integer}{RS}  return ARRAY_ELEMENT;
{identifier}                  return IDENTIFIER;
{newline} 							;
{tab} 								;
%%
int yywrap(){ return 1; }