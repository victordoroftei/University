bits 32
global start

extern exit
import exit msvcrt.dll
extern scanf
import scanf msvcrt.dll
extern printf
import printf msvcrt.dll
extern printf
import printf msvcrt.dll

segment data use32 class=data
	c times 4 db 0
	b times 4 db 0
	a times 4 db 0
	format db "%d", 0
	newline db 10, 0

segment code use32 class=code
	start:


PUSH dword a
PUSH dword format
CALL [scanf]
ADD ESP, 4 * 2


PUSH dword b
PUSH dword format
CALL [scanf]
ADD ESP, 4 * 2


MOV AL, [a]
MOV BL, [b]
ADD AL, BL
MOV [c], AL

PUSH dword newline
CALL [printf]
ADD ESP, 4 * 1


PUSH dword [c]
PUSH dword format
CALL [printf]
ADD ESP, 4 * 2


PUSH dword 0
CALL [exit]