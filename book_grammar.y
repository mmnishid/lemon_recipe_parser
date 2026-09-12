%include {
    #include <stdio.h>
    #include <stdlib.h>
    #include <assert.h>
    #include "book_grammar.h"   
}

%token_type { int }	//The data type for all terminal tokens
%default_type { int }	//The default data type for non-terminals
%type expr_e { int }
%type expr_t { int }
%type expr_f { int }


%syntax_error {
    printf("Syntax Error");
}

main ::= expr_e.
expr_e(A) ::= expr_e(B) PLUS expr_t(C). { A = B + C; }
expr_e(A) ::= expr_t(B). { A = B; }
expr_t(A) ::= expr_t(B) TIMES expr_f(C). { A = B * C; }
expr_t(A) ::= expr_f(B). { A = B; }
expr_f(A) ::= LPARREN expr_e(B) RPARREN. { A = (B); }
expr_f(A) ::= INT(B). { A = B }