%{

    #include <string.h>
    #include <stdio.h>
    #include <stdlib.h>
	#include <stdbool.h>
	#include <string.h>
        
    extern int yylex();
    extern int yyparse();
    extern FILE* yyin;
    void yyerror();

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

    FILE* outputFile;

    struct declaration {
        char varName[260];
    }declarations[100];

	char code[90000];

    int noDeclarations = 0;

	void addToDeclarations(char*);
	void addToAttrs(char*, char*);
	void addPrintf(char*);
	void addScanf(char*);
	void addAddition(char*, char*, char*, bool, bool);
	void addSubtraction(char*, char*, char*, bool, bool);
	void addMultiplication(char*, char*, char*, bool, bool);
	void addDivision(char*, char*, char*, bool, bool);
%}


%token MAIN
%token PARD
%token PARI
%token ACD
%token ACI
%token SEMICOL
%token FLOAT
%token STRUCT
%token COM
%token EQ
%token SCANF
%token GH
%token AND
%token PRINTF

%token INT
%token PROCD

%token<varname> ID
%token<varname> CONST_INT
%token<varname> PLUS
%token<varname> MINUS
%token<varname> MUL
%token<varname> DIV
%token<varname> NEWLINE

%type<varname> lista_var
%type<varname> expr
%type<varname> termen
%type<varname> op_aritmetic

%union {
    char varname[1000];
}

%%


program: MAIN PARD PARI ACD bloc_instr ACI
        ;


bloc_instr: instr SEMICOL bloc_instr
        | instr SEMICOL
        ;


instr: instr_decl
        | instr_attr
        | instr_io
        ;


instr_decl: tip lista_var
        ;


tip: INT
        ;

lista_var: ID
        {
            strcpy($$, $1);
			addToDeclarations($1);
        } 

        | ID COM lista_var
        {
            strcpy($$, $1);
			addToDeclarations($1);
        }
        ;


expr: termen
		{
			strcpy($$, $1);
		}
        | termen op_aritmetic termen
		{
			strcpy($$, $1);
			strcat($$, " ");

			strcat($$, $2);
			strcat($$, " ");

			strcat($$, $3);
		}
        ;


termen: ID
		{
			strcpy($$, $1);
		}

        | CONST_INT
		{
			strcpy($$, $1);
		}
        ;


op_aritmetic: PLUS
		{
			strcpy($$, $1);
		}

        | MINUS
		{
			strcpy($$, $1);
		}

        | MUL
		{
			strcpy($$, $1);
		}

		| DIV
		{
			strcpy($$, $1);
		}
        ;


instr_attr: ID EQ expr
		{
			addToAttrs($1, $3);
		}
        ;


instr_io: instr_input
        | instr_output
        ;

    
instr_input: SCANF PARD format COM AND ID PARI
		{
			addScanf($6);
		}
        ;


instr_output: PRINTF PARD format COM ID PARI
		{
			addPrintf($5);
		}

		| PRINTF PARD NEWLINE PARI
		{
			addPrintf("");
		}
        ;


format: PROCD
        ;


%%

void addToDeclarations(char aux[300]) {
	for (int i = 0; i < noDeclarations; i++) {
		if (strcmp(declarations[i].varName, aux) == 0) {
			return;
		}
	}
	
    strcpy(declarations[noDeclarations++].varName, aux);
}

void addPrintf(char toPrint[300]) {
	if (strcmp(toPrint, "") == 0) {
		strcat(code, "\nPUSH dword newline\nCALL [printf]\nADD ESP, 4 * 1\n\n");
	} 
	
	else {
	strcat(code, "\nPUSH dword [");
	strcat(code, toPrint);
	strcat(code, "]\n");
	strcat(code, "PUSH dword format\nCALL [printf]\nADD ESP, 4 * 2\n\n");
	}
}

void addScanf(char toRead[300]) {
	strcat(code, "\nPUSH dword ");
	strcat(code, toRead);
	strcat(code, "\nPUSH dword format\nCALL [scanf]\nADD ESP, 4 * 2\n\n");
}

void addToAttrs(char leftPart[300], char rightPart[600]) {
	bool isLeftInt = false, isRightInt = false, isInt = false;
	int leftInt, rightInt, aInt;
	char op = '?';

	if (strchr(rightPart, ' ') == NULL) {	// ex.: x = 5; or x = a;
		strcat(code, "MOV AL, ");

		if (isdigit(rightPart[0])) {
			isInt = true;
			aInt = atoi(rightPart);

			strcat(code, rightPart);
			strcat(code, "\n");
			strcat(code, "MOV [");
			strcat(code, leftPart);
			strcat(code, "], AL\n");

		} else {
			strcat(code, "[");
			strcat(code, rightPart);
			strcat(code, "]\n");
			strcat(code, "MOV [");
			strcat(code, leftPart);
			strcat(code, "], AL\n");
		}
	} 
	
	else {
		char* ptr = strtok(rightPart, " ");
		char first[300], second[300];
		if (isdigit(ptr[0])) {
			isLeftInt = true;
			leftInt = atoi(ptr);
		}

		strcpy(first, ptr);

		ptr = strtok(NULL, " ");
		op = ptr[0];

		ptr = strtok(NULL, " ");
		if (isdigit(ptr[0])) {
			isRightInt = true;
			rightInt = atoi(ptr);
		}

		strcpy(second, ptr);

		if (op == '+') {
			addAddition(leftPart, first, second, isLeftInt, isRightInt);
		} else if (op == '-') {
			addSubtraction(leftPart, first, second, isLeftInt, isRightInt);
		} else if (op == '*') {
			addMultiplication(leftPart, first, second, isLeftInt, isRightInt);
		} else if (op == '/') {
			addDivision(leftPart, first, second, isLeftInt, isRightInt);
		}
	}
}

void addAddition(char leftPart[300], char first[300], char second[300], bool isLeftInt, bool isRightInt) {
	if (isLeftInt == true) {
		strcat(code, "\nMOV AL, ");
		strcat(code, first);
		strcat(code, "\n");
	}

	else {
		strcat(code, "\nMOV AL, [");
		strcat(code, first);
		strcat(code, "]\n");
	}

	if (isRightInt == true) {
		strcat(code, "MOV BL, ");
		strcat(code, second);
		strcat(code, "\n");
	}

	else {
		strcat(code, "MOV BL, [");
		strcat(code, second);
		strcat(code, "]\n");
	}

	strcat(code, "ADD AL, BL\n");
	strcat(code, "MOV [");
	strcat(code, leftPart);
	strcat(code, "], AL\n");
}

void addSubtraction(char leftPart[300], char first[300], char second[300], bool isLeftInt, bool isRightInt) {
	if (isLeftInt == true) {
		strcat(code, "\nMOV AL, ");
		strcat(code, first);
		strcat(code, "\n");
	}

	else {
		strcat(code, "\nMOV AL, [");
		strcat(code, first);
		strcat(code, "]\n");
	}

	if (isRightInt == true) {
		strcat(code, "MOV BL, ");
		strcat(code, second);
		strcat(code, "\n");
	}

	else {
		strcat(code, "MOV BL, [");
		strcat(code, second);
		strcat(code, "]\n");
	}

	strcat(code, "SUB AL, BL\n");
	strcat(code, "MOV [");
	strcat(code, leftPart);
	strcat(code, "], AL\n");
}

void addMultiplication(char leftPart[300], char first[300], char second[300], bool isLeftInt, bool isRightInt) {
	if (isLeftInt == true && isRightInt == true) {
		strcat(code, "\nMOV AL, ");
		strcat(code, first);
		strcat(code, "\nMOV DL, ");
		strcat(code, second);
		strcat(code, "\nMUL DL\nMOV [");
		strcat(code, leftPart);
		strcat(code, "], AX\n");
	}

	if (isLeftInt == true && isRightInt == false) {
		strcat(code, "\nMOV AL, ");
		strcat(code, first);
		strcat(code, "\nMUL byte [");
		strcat(code, second);
		strcat(code, "]\nMOV [");
		strcat(code, leftPart);
		strcat(code, "], AX\n");
	}

	if (isLeftInt == false && isRightInt == true) {
		strcat(code, "\nMOV AL, ");
		strcat(code, second);
		strcat(code, "\nMUL byte [");
		strcat(code, first);
		strcat(code, "]\nMOV [");
		strcat(code, leftPart);
		strcat(code, "], AX\n");
	}

	if (isLeftInt == false && isRightInt == false) {
		strcat(code, "\nMOV AL, [");
		strcat(code, first);
		strcat(code, "]\nMUL byte [");
		strcat(code, second);
		strcat(code, "]\nMOV [");
		strcat(code, leftPart);
		strcat(code, "], AX\n");
	}
}

void addDivision(char leftPart[300], char first[300], char second[300], bool isLeftInt, bool isRightInt) {
	if (isLeftInt == true && isRightInt == true) {
		strcat(code, "\nMOV AX, ");
		strcat(code, first);
		strcat(code, "\nMOV CL, ");
		strcat(code, second);
		strcat(code, "\nDIV CL\nMOV [");
		strcat(code, leftPart);
		strcat(code, "], AL\n");
	}

	if (isLeftInt == false && isRightInt == true) {
		strcat(code, "\nMOV AX, [");
		strcat(code, first);
		strcat(code, "]\nMOV CL, ");
		strcat(code, second);
		strcat(code, "\nDIV CL\nMOV [");
		strcat(code, leftPart);
		strcat(code, "], AL\n");
	}

	if (isLeftInt == true && isRightInt == false) {
		strcat(code, "\nMOV AX, ");
		strcat(code, first);
		strcat(code, "\nMOV CL, [");
		strcat(code, second);
		strcat(code, "]\nDIV CL\nMOV [");
		strcat(code, leftPart);
		strcat(code, "], AL\n");
	}

	if (isLeftInt == false && isRightInt == false) {
		strcat(code, "\nMOV AX, [");
		strcat(code, first);
		strcat(code, "]\nMOV CL, [");
		strcat(code, second);
		strcat(code, "]\nDIV CL\nMOV [");
		strcat(code, leftPart);
		strcat(code, "], AL\n");
	}
}

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

		printf("\nThe file IS syntactically correct!\nASM output has been written to asmOutput.asm\n");
    } else {
        printErrors();
        
        char errorsFileName[101];
        strcpy(errorsFileName, argv[0]);
        strcat(errorsFileName, "-errors.txt");
        writeErrorsToFile(errorsFileName);

		return 0;
    }

    outputFile = fopen("asmOutput.asm", "w+");
    fprintf(outputFile, "bits 32\nglobal start\n\n");
    fprintf(outputFile, "extern exit\nimport exit msvcrt.dll\nextern scanf\nimport scanf msvcrt.dll\nextern printf\nimport printf msvcrt.dll\nextern printf\nimport printf msvcrt.dll\n");
    
	fprintf(outputFile, "\nsegment data use32 class=data\n");
	for (int i = 0; i < noDeclarations; i++) {
		fprintf(outputFile,  "\t%s times 4 db 0\n", declarations[i].varName);
	}
	fprintf(outputFile, "\tformat db \"%%d\", 0\n");
	fprintf(outputFile, "\tnewline db 10, 0\n");

    fprintf(outputFile, "\nsegment code use32 class=code\n\tstart:\n\n");

	strcat(code, "\nPUSH dword 0\nCALL [exit]");
	fprintf(outputFile, "%s", code);

    return 0;
}

void yyerror() {
    printf("\nThe file IS NOT syntactically correct!\n");
    exit(1);
}