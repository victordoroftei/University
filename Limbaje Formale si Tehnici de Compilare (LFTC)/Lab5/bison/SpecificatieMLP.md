# Tema 1: Analizator lexical

## Cerinte:

### 1) Specificarea minilimbajului de programare(MLP)
#
```C++
    <PROGRAM> -> 'main' '(' ')' '{' <BLOC_INSTRUCTIUNI> '}'

    <BLOC_INSTRUCTIUNI> -> <INSTRUCTIUNE> <BLOC_INSTRUCTIUNI> |
                           <INSTRUCTIUNE>

    <INSTRUCTIUNE> -> <INSTRUCTIUNE_DECLARATIVA> ';' |
                      <INSTRUCTIUNE_ATRIBUIRE> ';' |
                      <INSTRUCTIUNE_INPUT_OUTPUT> ';' |
                      <INSTRUCTIUNE_CONDITIONALA> |
                      <INSTRUCTIUNE_CICLARE> |
                      <INSTRUCTIUNE_CATTIMP>

    <INSTRUCTIUNE_DECLARATIVA> -> <TIP> <LISTA_VARIABILE>

    <TIP> -> <TIP_CLASIC> |
             <TIP_COMPLEX>

    <TIP_CLASIC> -> 'int' | 'float'

    <TIP_COMPLEX> -> 'struct' [a-zA-Z]+ '{' <BLOC_INSTRUCTIUNI_DECLARATIVE> '}' ';'

    <BLOC_INSTRUCTIUNI_DECLARATIVE> -> <INSTRUCTIUNE_DECLARATIVA> ';'
                                       <INSTRUCTIUNE_DECLARATIVA> ';'| <BLOC_INSTRUCTIUNI_DECLARATIVE>

    <LISTA_VARIABILE> -> <VARIABILA_GENERALA> |
                         <VARIABILA_GENERALA> ',' <LISTA_VARIABILE>

    <VARIABILA_GENERALA> -> <VARIABILA> |
                            <VARIABILA> '=' <EXPRESIE>

    <VARIABILA> -> ^[a-zA-Z]+$ |
                   ^[a-zA-Z]+\.[a-zA-Z]$

    <EXPRESIE> -> <TERMEN> <OPERATOR_ARITMETIC> <EXPRESIE> |
                  <TERMEN>

    <TERMEN> -> <VARIABILA> |
                <CONSTANTA_NUMERICA>

    <OPERATOR_ARITMETIC> -> '+' | '-' | '*' | '/' | '%'

    <CONSTANTA_NUMERICA> -> ^(([0-9]|[1-9](('?\d)*))|((0X|0x)([a-fA-F0-9]'?)*[a-fA-F0-9])|(0('?[0-7])+)|((0b|0B)([01]'?)*[01]))(u|U|l|L|ll|LL|ul|ull|UL|ULL|LU|LLU)?$ |
                            ^(((0x|0X)(((\d|[a-fA-F])*\.(\d|[a-fA-F])+)|((\d|[a-fA-F])+\.?))(p(\+|\-)?(\d|[a-fA-F])+)?(f|l)?)|(((\d*\.\d+)|(\d+\.?))([eE](\+|\-)?\d+)?(f|l|F|L)?))$

    <INSTRUCTIUNE_ATRIBUIRE> -> <VARIABILA> '=' <EXPRESIE>
    
    <INSTRUCTIUNE_INPUT_OUTPUT> -> <INSTRUCTIUNE_INPUT> |
                                   <INSTRUCTIUNE_OUTPUT>

    <INSTRUCTIUNE_INPUT> -> 'cin' '>>' <VARIABILA>

    <INSTRUCTIUNE_OUTPUT> -> 'cout' '<<' <VARIABILA> |
                             'cout' '<<' '"' <MESAJ> '"'

    <MESAJ> -> "^\"[a-zA-Z ]*\"$"

    <INSTRUCTIUNE_CONDITIONALA> -> <INSTRUCTIUNE_CONDITIONALA_IF> |
                                   <INSTRUCTIUNE_CONDITIONALA_ELSE>

    <INSTRUCTIUNE_CONDITIONALA_IF> -> 'if' '(' <EXPRESIE_BOOLEANA> ')' '{' <BLOC_INSTRUCTIUNI> '}'
    
    <INSTRUCTIUNE_CONDITIONALA_ELSE> -> <INSTRUCTIUNE_CONDITIONALA_IF> 'else' '{' <BLOC_INSTRUCTIUNI> '}'

    <EXPRESIE_BOOLEANA> -> <EXPRESIE_RELATIONALA> |
                           <EXPRESIE_RELATIONALA> <OPERATOR_BOOL> <EXPRESIE_BOOLEANA>

    <EXPRESIE_RELATIONALA> -> <EXPRESIE> <OPERATOR_RELATIONAL> <EXPRESIE> |
                              <EXPRESIE>

    <OPERATOR_RELATIONAL> -> '<' | '==' | '>' | '!='

    <OPERATOR_BOOL> -> '&&' | '||'

    <INSTRUCTIUNE_CICLARE> -> 'while' '(' <EXPRESIE_BOOLEANA> ')' '{' <BLOC_INSTRUCTIUNI> '}'

    <INSTRUCTIUNE_CATTIMP> -> 'cattimp' '(' <VARIABILA> ')' 'executa' <BLOC_INSTRUCTIUNI> 'sfcattimp'
```
### 2) Se cer textele sursa a 3 mini-programe
#
#### - Calculeaza perimetrul si aria cercului de o raza data
```C++
main() {
    float r;

    cout << "Introduceti raza cercului ";
    cin >> r;

    float arie = 3.14 * r * r;
    cout << "Aria cercului este ";
    cout << arie;

    cout << "\n";

    float perimetru = 3.14 * 2 * r;
    cout << "Perimetrul cercului este ";
    cout << perimetru;
}
```
#### - Determina cmmdc a 2 nr naturale
```C++
main() {
    int a, b;

    cout << "Introduceti valoarea lui a ";
    cin >> a;

    cout << "Introduceti valoarea lui b ";
    cin >> b;

    while (b != 0) {
        int r = a % b;
        a = b;
        b = r;
    }

    cout << "CMMDC = ";
    cout << a;
}
```
#### - Calculeaza suma a n numere citite de la tastatura
```C++
main() {
    int n, x, s = 0, i = 0;

    cout << "Introduceti numarul de numere n ";
    cin >> n;

    while (i < n) {
        cout << "Introduceti un numar x ";
        cin >> x;

        s = s + x;
        i = i + 1;
    }

    cout << "Suma numerelor este ";
    cout << s;
}
```
### 3) Se cer textele sursa a doua programe care contin erori conform MLP-ului definit
#
#### - Unul dintre programe contine doua erori care sunt in acelasi timp erori in limbajul original (pentru care MLP defineste un subset)
```C++
main() {
    int 1 = 1;

    float r;

    cout << "Introduceti raza cercului ";
    cin >> r;

    float arie = 3.14 * r *;
    cout << arie;
}
```
#### - Al doilea program contine doua erori conform MLP, dar care nu sunt erori in limbajul original. Se cere ca acesta sa fie compilat si executat in limbajul original ales.
```C++
main() {
    int n, x, s = 0, i = 0;

    cout << "Introduceti numarul de numere n ";
    cin >> n;

    while (i < n) {
        cout << "Introduceti un numar x ";
        cin >> x;

        s = s + x;
        i++;
    }

    cout << "Suma numerelor este " << s;
}
```