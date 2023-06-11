%option noyywrap
%{
    /*
        comenzi:
            - flex analizator.l
            - gcc lex.yy.c -o exe
            - ./exe sau ./exe <test.c
        text copiat in fisierul generat
        incluziuni de fisiere, variabile globale 
    */

    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "analizator_s.tab.h"
    
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

    struct Node* newNode(char* val, int poz) {
        struct Node* temp = (struct Node*)malloc(sizeof(struct Node));
        strcpy(temp->val, val);
        temp->poz = poz;
        temp->left = temp->right = NULL;
        return temp;
    }

    struct Node* insert(struct Node* node, char* val, int poz) {
        if (node == NULL)
            return newNode(val, poz);
 
        if (strcmp(val, node->val) < 0)
            node->left = insert(node->left, val, poz);
        else if (strcmp(val, node->val) > 0)
            node->right = insert(node->right, val, poz);
    
        return node;
    }

    // Stanga Radacina Dreapta
    void inorder(struct Node* root) {
        if (root != NULL) {
            inorder(root->left);
            printf("Valoare: %s Pozitie: %d\n", root->val, root->poz);
            inorder(root->right);
        }
    }

    struct Node* search(struct Node* root, char* val) {
        if (root == NULL || strcmp(root->val, val) == 0)
            return root;
        
        if (strcmp(root->val, val) < 0)
            return search(root->right, val);
    
        return search(root->left, val);
    }

    int line_ct = 1;

    struct Node* TS_ID = NULL;
    int TS_ID_CT = 1000;
    struct Node* TS_CONST = NULL;
    int TS_CONST_CT = 2000;

    Element atomi[1001];
    int atomi_ct = 34;

    FIP_Element FIP[1001];
    int fip_ct = 0;

    char error[1001] = "";

    int cautaAtom(char* atom) {
        for (int i = 0; i < atomi_ct; i++) {
            if (strcmp(atomi[i].atom, atom) == 0)
                return 1;
        }

        return 0;
    }

    int cautInAtomi(char* atom) {
        int result = -1;
        for(int i = 0; i < atomi_ct; i++) {
            if (strcmp(atomi[i].atom, atom) == 0) {
                result = atomi[i].poz;
            }
        }
        return result;
    }

    void addAtom(int rand, char* atom, char* tip, int poz) {
        if (strcmp(tip, "Cuvant rezervat") == 0 || strcmp(tip, "Operator") == 0 || strcmp(tip, "Separator") == 0) {
            if (cautaAtom(atom) == 0) {
                strcpy(atomi[poz].atom, atom);
                atomi[poz].poz = poz;
                atomi_ct += 1;
            }
            // adauga in FIP
            FIP[fip_ct].poz_normala = cautInAtomi(atom);
            FIP[fip_ct].poz_speciala = -1;
            fip_ct += 1;
        } else {
            if (strcmp(tip, "Variabila") == 0) {
                strcpy(atomi[poz].atom, "ID");
                atomi[poz].poz = 0;

                if (strlen(atom) <= 8) {
                    if (TS_ID == NULL) {
                        //printf("Sunt in id - primul element\n");
                        TS_ID = insert(TS_ID, atom, TS_ID_CT);
                        TS_ID_CT += 1;
                    } else if (search(TS_ID, atom) == NULL) {
                        //printf("Sunt in id - alt element\n");
                        insert(TS_ID, atom, TS_ID_CT);
                        TS_ID_CT += 1;
                    }
                    // Adauga in FIP
                    FIP[fip_ct].poz_normala = 0;
                    FIP[fip_ct].poz_speciala = search(TS_ID, atom)->poz;
                    fip_ct += 1;
                } else {
                    // Arunca eroarea
                    //printf("Eroareeeeeee---------\n");
                    char intermediar[101] = "Lungimea variabilei ";
                    strcat(intermediar, atom);
                    strcat(intermediar, " pe linia ");
                    char cif[5];
                    sprintf(cif, "%d", rand);
                    strcat(intermediar, cif);
                    strcat(intermediar, " este mai mare decat 8!\n");
                    strcat(error, intermediar);
                }
            } else if (strcmp(tip, "Constanta") == 0) {
                strcpy(atomi[poz].atom, "CONST");
                atomi[poz].poz = 1;

                if (TS_CONST == NULL) {
                    //printf("Sunt in constanta - primul element\n");
                    TS_CONST = insert(TS_CONST, atom, TS_CONST_CT);
                    TS_CONST_CT += 1;
                } else if (search(TS_CONST, atom) == NULL) {
                    //printf("Sunt in constanta - alt element\n");
                    insert(TS_CONST, atom, TS_CONST_CT);
                    TS_CONST_CT += 1;
                }
                // Adauga in FIP
                FIP[fip_ct].poz_normala = 1;
                FIP[fip_ct].poz_speciala = search(TS_CONST, atom)->poz;
                fip_ct += 1;
            } else {
                // Arunca eroarea
                //printf("Eroareeeeeee---------\n");
                char intermediar[101] = "Atomul ";
                    strcat(intermediar, atom);
                    strcat(intermediar, " pe linia ");
                    char cif[5];
                    sprintf(cif, "%d", rand);
                    strcat(intermediar, cif);
                    strcat(intermediar, " nu apartine limbajului!\n");
                    strcat(error, intermediar);
            }
        }
    }
%}
/* definitii */
decimal_float ((((([0-9]('?[0-9])*)?\.[0-9]('?[0-9])*)|([0-9]('?[0-9])*\.))([eE](\+|\-)?[0-9]('?[0-9])*)?)|[0-9]('?[0-9])*([eE](\+|\-)?[0-9]('?[0-9])*))(f|l|F|L)?
hexa_float (0x|0X)((([0-9a-fA-F]('?[0-9a-fA-F])*)?\.[0-9a-fA-F]('?[0-9a-fA-F])*)|([0-9a-fA-F]('?[0-9a-fA-F])*\.?))([pP](\+|\-)?[0-9a-fA-F]('?[0-9a-fA-F])*)(f|l|F|L)?
decimal_integer (0|([1-9]('?[0-9])*))(u|U|l|L|ll|LL|ul|ull|UL|ULL|LU|LLU)?
hexa_integer ((0X|0x)([a-fA-F0-9]'?)*[a-fA-F0-9])(u|U|l|L|ll|LL|ul|ull|UL|ULL|LU|LLU)?
octa_integer (0('?[0-7])+)(u|U|l|L|ll|LL|ul|ull|UL|ULL|LU|LLU)?
binary_integer ((0b|0B)([01]'?)*[01])(u|U|l|L|ll|LL|ul|ull|UL|ULL|LU|LLU)?
%%
[ \t\r]             /* ignoram white spaces */
[\n]                line_ct++;
\"[a-zA-Z ]*\"      {
                        printf("%d ~ %s ~ Constanta\n", line_ct, yytext); 
                        addAtom(line_ct, yytext, "Constanta", 1);
                        return CONST_STRING;
                    }
"int"               {
                        printf("%d ~ int ~ Cuvant rezervat\n", line_ct); 
                        addAtom(line_ct, "int", "Cuvant rezervat", 2);
                        return INT;
                    }
"float"             {
                        printf("%d ~ float ~ Cuvant rezervat\n", line_ct); 
                        addAtom(line_ct, "float", "Cuvant rezervat", 3);
                        return FLOAT;
                    }
"main"              {
                        printf("%d ~ main ~ Cuvant rezervat\n", line_ct); 
                        addAtom(line_ct, "main", "Cuvant rezervat", 4);
                        return MAIN;
                    }
"if"                {
                        printf("%d ~ if ~ Cuvant rezervat\n", line_ct); 
                        addAtom(line_ct, "if", "Cuvant rezervat", 5);
                        return IF;
                    }
"else"              {
                        printf("%d ~ else ~ Cuvant rezervat\n", line_ct); 
                        addAtom(line_ct, "else", "Cuvant rezervat", 6);
                        return ELSE;
                    }
"while"             {
                        printf("%d ~ while ~ Cuvant rezervat\n", line_ct); 
                        addAtom(line_ct, "while", "Cuvant rezervat", 7);
                        return WHILE;
                    }
"cin"               {
                        printf("%d ~ cin ~ Cuvant rezervat\n", line_ct); 
                        addAtom(line_ct, "cin", "Cuvant rezervat", 8);
                        return CIN;
                    }
"cout"              {
                        printf("%d ~ cout ~ Cuvant rezervat\n", line_ct); 
                        addAtom(line_ct, "cout", "Cuvant rezervat", 9);
                        return COUT;
                    }
"struct"            {
                        printf("%d ~ struct ~ Cuvant rezervat\n", line_ct); 
                        addAtom(line_ct, "struct", "Cuvant rezervat", 10);
                        return STRUCT;
                    }
"cattimp"           {
                        printf("%d ~ cattimp ~ Cuvant rezervat\n", line_ct); 
                        addAtom(line_ct, "cattimp", "Cuvant rezervat", 31);
                        return CATTIMP;
                    }
"sfcattimp"         {
                        printf("%d ~ sfcattimp ~ Cuvant rezervat\n", line_ct); 
                        addAtom(line_ct, "sfcattimp", "Cuvant rezervat", 33);
                        return SFCATTIMP;
                    }
"executa"           {
                        printf("%d ~ executa ~ Cuvant rezervat\n", line_ct); 
                        addAtom(line_ct, "executa", "Cuvant rezervat", 32);
                        return EXECUTA;
                    }
[a-zA-Z]+           {
                        printf("%d ~ %s ~ Variabila\n", line_ct, yytext); 
                        addAtom(line_ct, yytext, "Variabila", 0);
                        return ID_SIMPLU;
                    }
[a-zA-Z]+\.[a-zA-Z] {
                        printf("%d ~ %s ~ Variabila\n", line_ct, yytext); 
                        addAtom(line_ct, yytext, "Variabila", 0);
                        return ID;
                    }
{decimal_float}     {
                        printf("%d ~ %s ~ Constanta\n", line_ct, yytext); 
                        addAtom(line_ct, yytext, "Constanta", 1);
                        return CONST_FLOAT;
                    }
{hexa_float}        {
                        printf("%d ~ %s ~ Constanta\n", line_ct, yytext); 
                        addAtom(line_ct, yytext, "Constanta", 1);
                        return CONST_FLOAT;
                    }
{decimal_integer}   {
                        printf("%d ~ %s ~ Constanta\n", line_ct, yytext); 
                        addAtom(line_ct, yytext, "Constanta", 1);
                        return CONST_INT;
                    }
{hexa_integer}      {
                        printf("%d ~ %s ~ Constanta\n", line_ct, yytext); 
                        addAtom(line_ct, yytext, "Constanta", 1);
                        return CONST_INT;
                    }
{octa_integer}      {
                        printf("%d ~ %s ~ Constanta\n", line_ct, yytext); 
                        addAtom(line_ct, yytext, "Constanta", 1);
                        return CONST_INT;
                    }
{binary_integer}    {
                        printf("%d ~ %s ~ Constanta\n", line_ct, yytext); 
                        addAtom(line_ct, yytext, "Constanta", 1);
                        return CONST_INT;
                    }
">>"                {
                        printf("%d ~ >> ~ Operator\n", line_ct); 
                        addAtom(line_ct, ">>", "Operator", 11);
                        return OP_INP;
                    }
"<<"                {
                        printf("%d ~ << ~ Operator\n", line_ct); 
                        addAtom(line_ct, "<<", "Operator", 12);
                        return OP_OUT;
                    }
"+"                 {
                        printf("%d ~ + ~ Operator\n", line_ct); 
                        addAtom(line_ct, "+", "Operator", 13);
                        return PLUS;
                    }
"-"                 {
                        printf("%d ~ - ~ Operator\n", line_ct); 
                        addAtom(line_ct, "-", "Operator", 14);
                        return MINUS;
                    }
"*"                 {
                        printf("%d ~ * ~ Operator\n", line_ct); 
                        addAtom(line_ct, "*", "Operator", 15);
                        return INMUL;
                    }
"/"                 {
                        printf("%d ~ / ~ Operator\n", line_ct); 
                        addAtom(line_ct, "/", "Operator", 16);
                        return DIV;
                    }
"%"                 {
                        printf("%d ~ %% ~ Operator\n", line_ct); 
                        addAtom(line_ct, "%", "Operator", 17);
                        return MOD;
                    }
"&&"                {
                        printf("%d ~ && ~ Operator\n", line_ct); 
                        addAtom(line_ct, "&&", "Operator", 18);
                        return AND;
                    }
"||"                {
                        printf("%d ~ || ~ Operator\n", line_ct); 
                        addAtom(line_ct, "||", "Operator", 19);
                        return OR;
                    }
"<"                 {
                        printf("%d ~ < ~ Operator\n", line_ct); 
                        addAtom(line_ct, "<", "Operator", 20);
                        return MIC;
                    }
">"                 {
                        printf("%d ~ > ~ Operator\n", line_ct); 
                        addAtom(line_ct, ">", "Operator", 21);
                        return MARE;
                    }
"!="                {
                        printf("%d ~ != ~ Operator\n", line_ct); 
                        addAtom(line_ct, "!=", "Operator", 22);
                        return DIFERIT;
                    }
"=="                {
                        printf("%d ~ == ~ Operator\n", line_ct); 
                        addAtom(line_ct, "==", "Operator", 23);
                        return EGAL_EGAL;
                    }
"="                 {
                        printf("%d ~ = ~ Operator\n", line_ct); 
                        addAtom(line_ct, "=", "Operator", 24);
                        return EGAL;
                    }
"("                 {
                        printf("%d ~ ( ~ Separator\n", line_ct); 
                        addAtom(line_ct, "(", "Separator", 25);
                        return PD;
                    }
")"                 {
                        printf("%d ~ ) ~ Separator\n", line_ct); 
                        addAtom(line_ct, ")", "Separator", 26);
                        return PI;
                    }
"{"                 {
                        printf("%d ~ { ~ Separator\n", line_ct); 
                        addAtom(line_ct, "{", "Separator", 27);
                        return AD;
                    }
"}"                 {
                        printf("%d ~ } ~ Separator\n", line_ct); 
                        addAtom(line_ct, "}", "Separator", 28);
                        return AI;
                    }
";"                 {
                        printf("%d ~ ; ~ Separator\n", line_ct); 
                        addAtom(line_ct, ";", "Separator", 29);
                        return PV;
                    }
","                 {
                        printf("%d ~ , ~ Separator\n", line_ct); 
                        addAtom(line_ct, ",", "Separator", 30);
                        return VIRGULA;
                    }
.                   {
                        printf("%d ~ %s ~ Eroare\n", line_ct, yytext); 
                        addAtom(line_ct, yytext, "Eroare", -1);
                    }
%%
/* cod utilizator */
/*int main(){
    strcpy(atomi[0].atom, "ID");
    atomi[0].poz = 0;

    strcpy(atomi[1].atom, "CONST");
    atomi[1].poz = 1;

    strcpy(atomi[2].atom, "int");
    atomi[2].poz = 2;

    strcpy(atomi[3].atom, "float");
    atomi[3].poz = 3;

    strcpy(atomi[4].atom, "main");
    atomi[4].poz = 4;

    strcpy(atomi[5].atom, "if");
    atomi[5].poz = 5;

    strcpy(atomi[6].atom, "else");
    atomi[6].poz = 6;

    strcpy(atomi[7].atom, "while");
    atomi[7].poz = 7;

    strcpy(atomi[8].atom, "cin");
    atomi[8].poz = 8;

    strcpy(atomi[9].atom, "cout");
    atomi[9].poz = 9;

    strcpy(atomi[10].atom, "struct");
    atomi[10].poz = 10;

    strcpy(atomi[11].atom, ">>");
    atomi[11].poz = 11;

    strcpy(atomi[12].atom, "<<");
    atomi[12].poz = 12;

    strcpy(atomi[13].atom, "+");
    atomi[13].poz = 13;

    strcpy(atomi[14].atom, "-");
    atomi[14].poz = 14;

    strcpy(atomi[15].atom, "*");
    atomi[15].poz = 15;

    strcpy(atomi[16].atom, "/");
    atomi[16].poz = 16;
    
    strcpy(atomi[17].atom, "%");
    atomi[17].poz = 17;

    strcpy(atomi[18].atom, "&&");
    atomi[18].poz = 18;

    strcpy(atomi[19].atom, "||");
    atomi[19].poz = 19;

    strcpy(atomi[20].atom, "<");
    atomi[20].poz = 20;

    strcpy(atomi[21].atom, ">");
    atomi[21].poz = 21;

    strcpy(atomi[22].atom, "!=");
    atomi[22].poz = 22;

    strcpy(atomi[23].atom, "==");
    atomi[23].poz = 23;

    strcpy(atomi[24].atom, "=");
    atomi[24].poz = 24;

    strcpy(atomi[25].atom, "(");
    atomi[25].poz = 25;

    strcpy(atomi[26].atom, ")");
    atomi[26].poz = 26;

    strcpy(atomi[27].atom, "{");
    atomi[27].poz = 27;

    strcpy(atomi[28].atom, "}");
    atomi[28].poz = 28;

    strcpy(atomi[29].atom, ";");
    atomi[29].poz = 29;

    strcpy(atomi[30].atom, ",");
    atomi[30].poz = 30;

    strcpy(atomi[31].atom, "cattimp");
    atomi[31].poz = 31;

    strcpy(atomi[32].atom, "executa");
    atomi[32].poz = 32;

    strcpy(atomi[33].atom, "sfcattimp");
    atomi[33].poz = 33;

    atomi_ct = 34;

	yylex();

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
}*/