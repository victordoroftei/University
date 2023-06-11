%{

    #include "analizor.tab.h"

    int line = 1;

    #include <stdlib.h>
    #include <string.h>
    #include <stdio.h>

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

    int currentTsValue = 1000, sizeTs = 0;
    int currentNumberMapValue = 41, sizeNumberMap = 0;
    int sizeFip = 0;
    int hasUnrecognizedSequences = 0, lastErrorLineNo = 0, sizeErrors = 0;;

    FipElem fip[501];
    FipElem numberMap[501];
    TsElem ts[501];
    ErrorElem errors[501];

    void addToTs(char atom[], int code) {   // code: 0 if ID, 1 if CONST
        int i;
        for (i = 0; i < sizeTs; i++) {
            if (strcmp(ts[i].atom, atom) == 0) {
                return;
            }
        }

        strcpy(ts[sizeTs].atom, atom);
        ts[sizeTs].value = currentTsValue;
        ts[sizeTs].code = code;

        currentTsValue++;
        sizeTs++;
    }

    void addToNumberMap(char atom[], int value) {   // value: 0 if ID, 1 if CONST, -1 for currentNumberMapValue
                                                    // main|float|int|if|else|while|printf|scanf|%d|%f|cattimp|executa|sfcattimp
                                                    // 2 - main, 3 - float, 4 - int, 5 - if, 6 - else, 7 - while, 8 - printf, 9 - scanf, 10 - %d, 11 - %f, 12 - cattimp, 13 - executa, 14 - sfcattimp
        int i;
        for (i = 0; i < sizeNumberMap; i++) {
            if (strcmp(numberMap[i].atom, atom) == 0) {
                return;
            }
        }

        strcpy(numberMap[sizeNumberMap].atom, atom);

        if (value == -1) {
            numberMap[sizeNumberMap].value = currentNumberMapValue;
            currentNumberMapValue++;
        } else {
            numberMap[sizeNumberMap].value = value;
        }

        sizeNumberMap++;
    }

    void addToFip(char atom[]) {
        int i, numberMapIndex = -1;
        for (i = 0; i < sizeNumberMap; i++) {
            if (strcmp(numberMap[i].atom, atom) == 0) {
                numberMapIndex = i;
                i = sizeNumberMap + 1;
            }
        }

        int numberMapValue = numberMap[numberMapIndex].value;
        if (numberMapValue != 0 && numberMapValue != 1) {
            strcpy(fip[sizeFip].atom, atom);
            fip[sizeFip].value = numberMapValue;
            fip[sizeFip].value2 = -1;
            sizeFip++;
        } else {
            strcpy(fip[sizeFip].atom, atom);
            
            int value, value2;
            for (i = 0; i < sizeTs; i++) {
                if (strcmp(ts[i].atom, atom) == 0) {
                    value = ts[i].code;
                    value2 = ts[i].value;
                }
            }

            fip[sizeFip].value = value;
            fip[sizeFip].value2 = value2;
            sizeFip++;
        }
    }

    void printNumberMap() {
        int i;
        for (i = 0; i < sizeNumberMap; i++) {
            printf("%s: %d\n", numberMap[i].atom, numberMap[i].value);
        }
    }

    void printTs() {
        printf("Tabela de Simboluri:\n");
        
        int i;
        for (i = 0; i < sizeTs; i++) {
            printf("(%s; %d)\n", ts[i].atom, ts[i].value);
        }
    }

    void printFip() {
        printf("Forma Interna a Programului:\n");

        int i;
        for (i = 0; i < sizeFip; i++) {
            if (fip[i].value2 == -1) {
                printf("%d\n", fip[i].value);
            } else {
                printf("[%d, %d]\n", fip[i].value, fip[i].value2);
            }
        }
    }

    void addToErrors(char sequence[], int line) {
        if (line > lastErrorLineNo) {
            lastErrorLineNo = line;
        }

        strcpy(errors[sizeErrors].sequence, sequence);
        errors[sizeErrors].line = line;
        sizeErrors++;
    }

    void printErrors() {
        int i, j, hasErrorsOnLine[10001];

        for (i = 1; i < lastErrorLineNo + 1; i++) {
            for (j = 0; j < sizeErrors; j++) {
                if (errors[j].line == i) {
                    hasErrorsOnLine[i] = 1;
                }
            }
        }

        for (i = 1; i < lastErrorLineNo + 1; i++) {
            if (hasErrorsOnLine[i] == 1) {
                printf("Errors on line %d: ", i);

                for (j = 0; j < sizeErrors; j++) {
                    if (errors[j].line == i) {
                        printf("%s ", errors[j].sequence);
                    }
                }

                printf("\n");
            }
        }
    }

    void sortTsByAtom() {
        int i, j;
        TsElem aux;
        for (i = 0; i < sizeTs - 1; i++) {
            for (j = i + 1; j < sizeTs; j++) {
                if (strcmp(ts[i].atom, ts[j].atom) > 0) {
                    aux = ts[i];
                    ts[i] = ts[j];
                    ts[j] = aux;
                }
            }
        }
    }

    void writeTsToFile(char fileName[]) {
        FILE* fptr;
        fptr = fopen(fileName, "w");
        fprintf(fptr, "Tabela de Simboluri:\n");

        int i;
        for (i = 0; i < sizeTs; i++) {
            fprintf(fptr, "(%s; %d)\n", ts[i].atom, ts[i].value);
        }

        fclose(fptr);
    }

    void writeFipToFile(char fileName[]) {
        FILE* fptr;
        fptr = fopen(fileName, "w");
        fprintf(fptr, "Forma Interna a Programului:\n");

        int i;
        for (i = 0; i < sizeFip; i++) {
            if (fip[i].value2 == -1) {
                fprintf(fptr, "%d\n", fip[i].value);
            } else {
                fprintf(fptr, "[%d, %d]\n", fip[i].value, fip[i].value2);
            }
        }

        fclose(fptr);
    }

    void writeErrorsToFile(char fileName[]) {
        FILE* fptr;
        fptr = fopen(fileName, "w");
        
        int i, j, hasErrorsOnLine[10001];
        for (i = 1; i < lastErrorLineNo + 1; i++) {
            for (j = 0; j < sizeErrors; j++) {
                if (errors[j].line == i) {
                    hasErrorsOnLine[i] = 1;
                }
            }
        }

        for (i = 1; i < lastErrorLineNo + 1; i++) {
            if (hasErrorsOnLine[i] == 1) {
                fprintf(fptr, "Errors on line %d: ", i);

                for (j = 0; j < sizeErrors; j++) {
                    if (errors[j].line == i) {
                        fprintf(fptr, "%s ", errors[j].sequence);
                    }
                }

                fprintf(fptr, "\n");
            }
        }

        fclose(fptr);
    }

// KEYWORD         main|float|int|if|else|while|printf|scanf|%d|%f|cattimp|executa|sfcattimp|struct
//                 2    3     4   5  6    7     8      9     10 11 12      13      14        38
// OPERATOR       \+\+|--|==|= |>=|<=|!=|&&|\|\||\+|- |\*|; |\(|\)|< |> |% |/
//                15   16 17 18 19 20 21 22 23   24 25 26 27 28 29 30 31 32 33
// SEPARATOR      , |{ |} |&
//                34 35 36 37

// KEYWORD         main|float|int|if|else|while|printf|scanf|%d|%f|cattimp|executa|sfcattimp|struct
//                 2    3     4   5  6    7     8      9     10 11 12      13      14        38
// OPERATOR       \+\+|--|==|= |>=|<=|!=|&&|\|\||\+|- |\*|; |\(|\)|< |> |% |/
//                15   16 17 18 19 20 21 22 23   24 25 26 27 28 29 30 31 32 33
// SEPARATOR      , |{ |} |& |.
//                34 35 36 37 39
%}

%option noyywrap

ID              [a-zA-Z]+
CONST_INT       ((0)|([+-]?[1-9][0-9]*[uU]?(l|ll|L|LL)?)|([+-]?0[0-7]*[uU]?(l|ll|L|LL)?)|([+-]?0b[01]+[uU]?(l|ll|L|LL)?)|([+-]?0B[01]+[uU]?(l|ll|L|LL)?)|([+-]?(0x|0X)[0-9a-fA-F]+[uU]?(l|ll|L|LL)?))
DEC_KEYWORD     \"%d\"
NEWLINE         \"\\n\"

%%

{DEC_KEYWORD}   {
                    if (hasUnrecognizedSequences == 0) {
                        addToNumberMap(yytext, 10);
                        addToFip(yytext);
                    }

                    return PROCD;
                }

{NEWLINE}       {
                    if (hasUnrecognizedSequences == 0) {
                        addToNumberMap(yytext, 39);
                        addToFip(yytext);
                    }

                    return NEWLINE;
                }

{CONST_INT}     {
                    if (hasUnrecognizedSequences == 0) {
                        addToNumberMap(yytext, 1);
                        addToTs(yytext, 1);
                        addToFip(yytext);
                    }

                    strcpy(yylval.varname, yytext);
                    return CONST_INT;
                }

"main"      {
                if (hasUnrecognizedSequences == 0) {
                    addToNumberMap(yytext, 2);
                    addToFip(yytext);
                }
                return MAIN;
            }

"int"       {
                if (hasUnrecognizedSequences == 0) {
                    addToNumberMap(yytext, 4);
                    addToFip(yytext);
                }
                return INT;
            }

"printf"    {
                if (hasUnrecognizedSequences == 0) {
                    addToNumberMap(yytext, 8);
                    addToFip(yytext);
                }
                return PRINTF;
            }

"scanf"     {
                if (hasUnrecognizedSequences == 0) {
                    addToNumberMap(yytext, 9);
                    addToFip(yytext);
                }
                return SCANF;
            }

"="     {
            if (hasUnrecognizedSequences == 0) {
                addToNumberMap(yytext, 18);
                addToFip(yytext);
            }
            return EQ;
        }

"+"     {
            if (hasUnrecognizedSequences == 0) {
                addToNumberMap(yytext, 24);
                addToFip(yytext);
            }

            strcpy(yylval.varname, yytext);
            return PLUS;
        }

"-"     {
            if (hasUnrecognizedSequences == 0) {
                addToNumberMap(yytext, 25);
                addToFip(yytext);
            }

            strcpy(yylval.varname, yytext);
            return MINUS;
        }

"*"     {
            if (hasUnrecognizedSequences == 0) {
                addToNumberMap(yytext, 26);
                addToFip(yytext);
            }

            strcpy(yylval.varname, yytext);
            return MUL;
        }

";"     {
            if (hasUnrecognizedSequences == 0) {
                addToNumberMap(yytext, 27);
                addToFip(yytext);
            }
            return SEMICOL;
        }

"("     {
            if (hasUnrecognizedSequences == 0) {
                addToNumberMap(yytext, 28);
                addToFip(yytext);
            }
            return PARD;
        }

")"     {
            if (hasUnrecognizedSequences == 0) {
                addToNumberMap(yytext, 29);
                addToFip(yytext);
            }
            return PARI;
        }

","     {
            if (hasUnrecognizedSequences == 0) {
                addToNumberMap(yytext, 34);
                addToFip(yytext);
            }
            return COM;
        }

"{"     {
            if (hasUnrecognizedSequences == 0) {
                addToNumberMap(yytext, 35);
                addToFip(yytext);
            }
            return ACD;
        }    

"}"     {
            if (hasUnrecognizedSequences == 0) {
                addToNumberMap(yytext, 36);
                addToFip(yytext);
            }
            return ACI;
        }

"&"     {
            if (hasUnrecognizedSequences == 0) {
                addToNumberMap(yytext, 37);
                addToFip(yytext);
            }
            return AND;
        }

"/"     {
            if (hasUnrecognizedSequences == 0) {
                addToNumberMap(yytext, 40);
                addToFip(yytext);
            }

            strcpy(yylval.varname, yytext);
            return DIV;
        }

{ID}        {
                if (hasUnrecognizedSequences == 0) {
                    addToNumberMap(yytext, 0);
                    addToTs(yytext, 0);
                    addToFip(yytext);
                }

                if (strlen(yytext) > 250) {
                    hasUnrecognizedSequences = 1;
                    addToErrors(yytext, yylineno);
                }
                strcpy(yylval.varname, yytext);
                return ID;
            }

[\n]    {
            line ++;
        }

[ \t\n]+ ; /* eat up whitespace */

%%
