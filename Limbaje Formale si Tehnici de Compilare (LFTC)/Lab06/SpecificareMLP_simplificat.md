# Laboratorul 1


## 1. Specificarea minilimbajului de programare (MLP)

```
<PROGRAM> -> 'main' '(' ')' '{' <BLOC_INSTR> '}'

<BLOC_INSTR> -> <INSTR> ';' <BLOC_INSTR> | 
                <INSTR> ';'
                
<INSTR> -> <INSTR_DECL> |
           <INSTR_ATTR> |
           <INSTR_IO>
           
<INSTR_DECL> -> <TIP> <LISTA_VAR>

<TIP> -> 'int'
         
<LISTA_VAR> -> <ID> |
               <ID> ',' <LISTA_VAR>

<ID> -> ('A' | 'B' | ... | 'Z' | 'a' | 'b' | ... | 'z')+

<EXPR> -> <TERMEN> |
          <TERMEN> <OP_ARITMETIC> <EXPR>
          
<TERMEN> -> <ID> | <CONST_NUM>

<OP_ARITMETIC> -> '+' | '-' | '*' | '/'

<CONST_INT> -> ^0|([+-]?[1-9][0-9]*[uU]?(l|ll|L|LL)?)|([+-]?0[0-7]*[uU]?(l|ll|L|LL)?)|([+-]?(0b|0B)?[01]+[uU]?(l|ll|L|LL)?)|([+-]?(0x|0X)[0-9a-fA-F]+[uU]?(l|ll|L|LL)?)$

<INSTR_ATTR> -> <ID> '=' <EXPR>

<INSTR_IO> -> <INSTR_INPUT> |
              <INSTR_OUTPUT>
              
<INSTR_INPUT> -> 'scanf' '(' '"' <FORMAT> '"' ',' '&' <ID> ')'
                
<INSTR_OUTPUT> -> 'printf' '(' '"' <FORMAT> '"' ',' <ID> ')' |
                  'printf' '(' '"\n"' ')'
                

<FORMAT> -> '%d'
```

## 2. Se cer textele sursa a 3 mini-programe

### Calculeaza perimetrul si aria cercului de o raza data data

```
main() {
    int r = 5;
    
    float a = 3.1415 * r * r;
    printf("Aria ");
    printf("%f", a);
    
    float p = 2 * 3.1415 * r;
    printf("\nPerimetrul ");
    printf("%f", p);
}
```


### Determina CMMDC a 2 numere naturale

```
main() {
    int x = 60, y = 25;
    
    while (x != y) {
        if (x > y) {
            x = x - y;
        } else {
            y = y - x;
        }
    }
    
    printf("CMMDC ");
    printf("%d", x);
}
```


### Calculeaza suma a n numere citite de la tastatura

```
main() {
    int n, x, s = 0;
    
    printf("Introduceti n ");
    scanf("%d", &n);
    
    while (n > 0) {
        scanf("%d", &x);
        s = s + x;
        n = n - 1;
    }
    
    printf("Suma ");
    printf("%d", s);
}
```

## 3. Se cer textele sursa a doua programe care contin erori conform MLP-ului definit:

### Unul dintre programe contine doua erori care sunt in acelasi timp erori in limbajul original (pentru care MLP defineste un subset)

```
main() {
    int 70r = 5;
    
    float a = 3.1415 * r ** 2;
    printf("Aria ");
    printf("%f", a);
    
    float p = 2 * 3.1415 * r;
    printf("\nPerimetrul ");
    printf("%f", p);
}
```

### Al doilea program contine doua erori conform MLP, dar care nu sunt erori in limbajul original. Se cere ca acesta sa fie compilat si executat in limbajul original ales.

```
int main() {
    int n, x, s = 0;
    
    printf("Introduceti n ");
    scanf("%d", &n);
    
    while (n > 0) {
        scanf("%d", &x);
        s = s + x;
        n--;
    }
    
    printf("Suma ");
    printf("%d", s);
    
    return 0;
}
```