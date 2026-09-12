%include {
    #include <stdio.h>
    #include <stdlib.h>
    #include <assert.h>
    #include "grammar.h"   
}

%token_type { char* }	//The data type for all terminal tokens
%default_type { char* }	//The default data type for non-terminals
%type main { char* }
%type cmd_expr { char* }
%type expr_list { char* }
%type expr { char* }

// Destructor prevents memory leaks on syntax errors or stack overflows
//%destructor expr { free($$); }

%syntax_error {
    printf("Syntax Error");
}

main ::= cmd_expr.
cmd_expr ::= READ expr(A). { 
	printf("Reading Recipe %s \n", A); 
}

cmd_expr ::= WRITE expr(A) INSTRUCTIONS expr(B) INGREDIENTS expr_list(C). {
	printf("Writing Recipe %s using ingredients %s with instructions %s \n", A, B, C); 
}

cmd_expr ::= COOK expr(A) INGREDIENTS expr_list(B). {
	printf("Cooking Recipe %s using ingredients %s \n", A, B); 
}

expr_list ::= expr.
expr_list(A) ::= expr_list(B) expr(C). {
    if (asprintf(&A, "%s, %s", B, C) == -1) {
        A = NULL; // Handle allocation failure safely
    }
    //free(B); // Free the older intermediate chunk to avoid leaks
}

expr(A) ::= STRING(B). {
    A = B;
}