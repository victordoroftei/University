%{
    /*
        Cum sa rulezi?
            1) flex analizator.l      
            2) bison -d analizator_s.y
            3) gcc lex.yy.c analizator_s.tab.c -o program
            4) ./program input/testt.cpp 
    */
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    struct Node {
        char val[101];
        int poz;
        struct Node *left;
        struct Node *right;
    };

    typedef struct {
        char atom[101];
        int poz;
    } Element;

    typedef struct {
        int poz_normala;
        int poz_speciala;
    } FIP_Element;

    extern struct Node* TS_ID;
    extern int TS_ID_CT;
    extern struct Node* TS_CONST;
    extern int TS_CONST_CT;

    extern Element atomi[1001];
    extern int atomi_ct;

    extern FIP_Element FIP[1001];
    extern int fip_ct;

    extern char error[1001];

    extern int yylex();
    extern int yyparse();
    extern FILE* yyin;

    extern void inorder();

    void yyerror();
%}

%token ID
%token ID_SIMPLU
%token CONST_STRING
%token CONST_INT
%token CONST_FLOAT
%token MAIN
%token PD
%token PI
%token AD
%token AI
%token PV
%token INT
%token FLOAT
%token STRUCT
%token VIRGULA
%token EGAL
%token PLUS
%token MINUS
%token INMUL
%token DIV
%token MOD
%token CIN
%token COUT
%token OP_INP
%token OP_OUT
%token IF
%token ELSE
%token MIC
%token MARE
%token EGAL_EGAL
%token DIFERIT
%token AND
%token OR
%token WHILE
%token CATTIMP
%token EXECUTA
%token SFCATTIMP

%%
program : MAIN PD PI AD bloc_instructiuni AI
        ;
bloc_instructiuni : instructiune bloc_instructiuni
                  | instructiune
                  ;
instructiune : instructiune_declarativa PV
             | instructiune_atriburire PV
             | instructiune_input_output PV
             | instructiune_conditionala
             | instructiune_ciclare
             | instructiune_cattimp
             ;
instructiune_declarativa : tip lista_variabile
                         ;
tip : tip_clasic
    | tip_complex
    ;
tip_clasic : INT
           | FLOAT
           ;
tip_complex : STRUCT ID_SIMPLU AD bloc_instructiuni_declarative AI
            ;
bloc_instructiuni_declarative : instructiune_declarativa PV
                              | instructiune_declarativa PV bloc_instructiuni_declarative
                              ;
id : ID
   | ID_SIMPLU
   ;
lista_variabile : variabila_generala
                | variabila_generala VIRGULA lista_variabile
                ;
variabila_generala : id
                   | id EGAL expresie
                   ;
expresie : termen operator_aritmetic expresie
         | termen
         ;
termen : id
       | CONST_INT
       | CONST_FLOAT
       ;
operator_aritmetic : PLUS
                   | MINUS
                   | INMUL
                   | DIV
                   | MOD
                   ;
instructiune_atriburire : id EGAL expresie
                        ;
instructiune_input_output : instructiune_input
                          | instructiune_output
                          ;
instructiune_input : CIN OP_INP id
                   ;
instructiune_output : COUT OP_OUT id
                    | COUT OP_OUT CONST_STRING
                    ;
instructiune_conditionala : instructiune_conditionala_if
                          | instructiune_conditionala_else
                          ;
instructiune_conditionala_if : IF PD expresie_booleana PI AD bloc_instructiuni AI
                             ;
instructiune_conditionala_else : instructiune_conditionala_if ELSE AD bloc_instructiuni AI
                               ;
expresie_booleana : expresie_relationala
                  | expresie_relationala operator_bool expresie_booleana
                  ;
expresie_relationala : expresie operator_relational expresie 
                     | expresie
                     ;
operator_relational : MIC
                    | MARE
                    | EGAL_EGAL
                    | DIFERIT
                    ;
operator_bool : AND
              | OR
              ;
instructiune_ciclare : WHILE PD expresie_booleana PI AD bloc_instructiuni AI
                     ;
instructiune_cattimp : CATTIMP PD id PI EXECUTA bloc_instructiuni SFCATTIMP
                     ;

%%
void yyerror() {
    printf("Fisierul primit ca si parametru nu este corect sintactic!\n");
    exit(1);
}

int main(int argc, char* argv[]) {
    ++argv, --argc;
    
    // setam fisierul pt input
    if (argc > 0) 
        yyin = fopen(argv[0], "r"); 
    else 
        yyin = stdin; 
    
    //cititm fiecare linie si o procesam
    while (!feof(yyin)) {
        yyparse();
    }

   if (strlen(error) != 0) {
        printf("Eroare %s\n", error);
    } else {

        printf("\n");
        printf("Atomii sunt: \n\n");
        for(int i = 0; i < atomi_ct; i++) {
            printf("Atomul %s si poz %d\n", atomi[i].atom, atomi[i].poz);
        }

        printf("\n");
        printf("Tabela simboluri id-uri: \n\n");
        inorder(TS_ID);

        printf("\n");
        printf("Tabela simboluri constante: \n\n");
        inorder(TS_CONST);

        printf("\n");
        printf("FIP: \n\n");
        for(int i = 0 ; i < fip_ct; i++) {
            if (FIP[i].poz_speciala != -1) {
                printf("[%d,%d]\n", FIP[i].poz_normala, FIP[i].poz_speciala);
            } else {
                printf("%d\n", FIP[i].poz_normala);
            }
        }
    }
   
    return 0;
}