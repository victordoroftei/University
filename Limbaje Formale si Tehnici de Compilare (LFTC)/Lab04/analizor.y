%{

    #include <string.h>
    #include <stdio.h>
    #include <stdlib.h>

    extern int yylex();
    extern int yyparse();
    extern FILE* yyin;

    extern int line;

        typedef struct {
        char atom[501];
        int value;
        int code;   // 0 if ID, 1 if CONST
    }TsElem;

    typedef struct {
        char atom[501];
        int value;
        int value2;
    }FipElem;

    typedef struct {
        char sequence[501];
        int line;
    }ErrorElem;
    
    extern int currentTsValue, sizeTs;
    extern int currentNumberMapValue, sizeNumberMap;
    extern int sizeFip;
    extern int hasUnrecognizedSequences, lastErrorLineNo, sizeErrors;

    extern FipElem fip[501];
    extern FipElem numberMap[501];
    extern TsElem ts[501];
    extern ErrorElem errors[501];

    extern void printFip();
    extern void printTs();
    extern void printErrors();
    extern void sortTsByAtom();
    extern void writeFipToFile();
    extern void writeTsToFile();
    extern void writeErrorsToFile();

    void yyerror();
%}


%token MAIN
%token PARD
%token PARI
%token ACD
%token ACI
%token SEMICOL
%token INT
%token FLOAT
%token STRUCT
%token COM
%token EQ
%token ID
%token VAR_SIMPLU
%token PLUS
%token MINUS
%token MUL
%token DIV
%token PROC
%token CONST_INT
%token CONST_FLOAT
%token IF
%token ELSE
%token OROR
%token ANDAND
%token EQEQ
%token NOTEQ
%token LT
%token GT
%token LTE
%token GTE
%token SCANF
%token GH
%token AND
%token PRINTF
%token CONST_STRING
%token PROCD
%token PROCF
%token WHILE

%token CATTIMP
%token EXECUTA
%token SFCATTIMP
%token PLUSPLUS
%token MINUSMINUS

%%


program: MAIN PARD PARI ACD bloc_instr ACI
        ;


bloc_instr: instr SEMICOL bloc_instr
        | instr SEMICOL
        ;


instr: instr_decl
        | instr_attr
        | instr_io
        | instr_cond
        | instr_cicl
        ;


instr_decl: tip lista_var
        ;


tip: tip_simplu
        | tip_definit
        ;


tip_simplu: INT
        | FLOAT
        ;


tip_definit: STRUCT var_simplu ACD lista_instr_decl ACI
                ;

lista_instr_decl: instr_decl SEMICOL
                | instr_decl SEMICOL lista_instr_decl
                ;

lista_var: var_aux
        | var_aux COM lista_var
        ;


var_aux: var
        | var EQ expr
        ;


var: var_simplu
        | ID
        ;


var_simplu: VAR_SIMPLU
        ;


expr: termen
        | termen op_aritmetic expr
        ;


termen: var
        | const_num
        ;


op_aritmetic: PLUS
        | MINUS
        | MUL
        | DIV
        | PROC
        ;


const_num:  CONST_INT
        | CONST_FLOAT
        ;


instr_cond: instr_cond_if
        | instr_cond_if_else
        ;


instr_cond_if: IF PARD expr_bool PARI ACD bloc_instr ACI
        ;


instr_cond_if_else: instr_cond_if ELSE ACD bloc_instr ACI
        ;


expr_bool: expr_rel
        | expr_rel op_bool expr_bool
        ;


expr_rel: expr
        | expr op_rel expr
        ;


op_bool: OROR 
        | ANDAND
        ;


op_rel: EQEQ
        | NOTEQ
        | LT
        | GT
        | LTE
        | GTE
        ;


instr_attr: var EQ expr
        ;


instr_io: instr_input
        | instr_output
        ;

    
instr_input: SCANF PARD format COM AND var PARI
        ;


instr_output: PRINTF PARD mesaj PARI
        | PRINTF PARD format COM var PARI
        ;


mesaj: CONST_STRING
        ;


format: PROCD
        | PROCF
        ;


instr_cicl: WHILE PARD expr_bool PARI ACD bloc_instr ACI
        ;


%%

int main(int argc, char* argv[]) {
    ++argv, --argc;
    
    // sets the input for flex file
    if (argc > 0) 
        yyin = fopen(argv[0], "r"); 
    else 
        yyin = stdin; 
    
    //read each line from the input file and process it
    while (!feof(yyin)) {
        yyparse();
    }

    if (hasUnrecognizedSequences == 0) {
        sortTsByAtom();
        printTs();

        char tsFileName[101];
        strcpy(tsFileName, argv[0]);
        strcat(tsFileName, "-ts.txt");
        writeTsToFile(tsFileName);

        printf("\n");
        printFip();
        char fipFileName[101];
        strcpy(fipFileName, argv[0]);
        strcat(fipFileName, "-fip.txt");
        writeFipToFile(fipFileName);

        printf("\nThe file is syntactically correct!\n");
    } else {
        printErrors();
        
        char errorsFileName[101];
        strcpy(errorsFileName, argv[0]);
        strcat(errorsFileName, "-errors.txt");
        writeErrorsToFile(errorsFileName);
    }

    return 0;
}

void yyerror() {
    printf("The file is NOT syntactically correct!\n");
    exit(1);
}