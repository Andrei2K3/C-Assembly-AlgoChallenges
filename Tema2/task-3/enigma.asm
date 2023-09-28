%include "../include/io.mac"

;; defining constants, you can use these as immediate values in your code
LETTERS_COUNT EQU 26

section .data
    extern len_plain

section .bss
    x resd 1
    rotor resd 1 ;0,1,2
    forward resd 1
    auxiliar: resb 52
    i resd 1
    j resd 1
    k resd 1

section .text
    global rotate_x_positions
    global enigma
    extern printf

; void rotate_x_positions(int x, int rotor, char config[10][26], int forward);
rotate_x_positions:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; x
    mov ebx, [ebp + 12] ; rotor
    mov ecx, [ebp + 16] ; config (address of first element in matrix)
    mov edx, [ebp + 20] ; forward
    ;; DO NOT MODIFY
    ;; TODO: Implement rotate_x_positions
    ;; FREESTYLE STARTS HERE

    ;; Rotatiile le vom face in felul urmator:
    ;; spre exemplu luam sirul ABCDEFGHIJKLMNOPQRSTUVWXYZ
    ;; in auxiliar il punem pe el dublat adica 
    ;; ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ
    ;; ROTATIA la STANGA cu 3 pozitii devine de fapt 
    ;; copierea incepand cu pozitia 3 a 26 de litere
    ;; ROTATIA la DREAPTA cu 3 pozitii devine de fapt
    ;; copierea incepand cu pozitia 26-3=23 a 26 de litere
    
    mov [x], eax
    mov [rotor], ebx
    mov [forward], edx

    cmp dword [forward], 1; verificam daca e rotatie dreapta sau stanga
    je RIGHT
    jmp continuare

RIGHT:
    mov eax, 26
    sub eax, dword [x]
    mov [x], eax

continuare:
    push ecx; punem pe ecx pe stiva
    ;; ecx va indica in functie de rotor pe ecx sau ecx+52 sau pe ecx+104
    ;; by default consideram ca indica primul rotor
    cmp dword [rotor], 1
    je add1
    jmp exit1

add1:
    add ecx, 52; ecx indica al doilea rotor

exit1:
    cmp dword [rotor], 2
    je add2
    jmp exit2

add2:
    add ecx, 104; ecx indica al treilea rotor

exit2:

    mov dword [k], 0

doipasi:
    ;; Vom executa 2 pasi pentru cele 2 linii ale rotorului
    mov dword [i], 0;
    mov edx, auxiliar;

loop:
    ;; Punem in auxiliar linia
    mov ebx, [i]
    mov al, [ecx+ebx]
    mov [edx+ebx], al

    inc dword [i]
    cmp dword [i], 26
    jl loop
    
    ;; Concatenam la auxiliar inca o data linia
    mov dword [i], 0

loop2:
    mov ebx, [i]
    mov al, [ecx+ebx]
    mov [edx+ebx+26], al
    ;; PRINTF32 `%c %d\n\x0`, [edx+ebx+26], ebx
    inc dword [i]
    cmp dword [i], 26
    jl loop2

    ;; Copiem 26 de litere din aux incepand cu pozitia [x]
    mov dword [i], 0
    mov ebx, [x];
    mov dword [j], ebx;

loop3:
    mov ebx, [i]
    mov eax, [j]
    mov al, [edx+eax];
    mov [ecx+ebx], al;
    ;; PRINTF32 `%c \x0`, [ecx+ebx]
    inc dword [i]
    inc dword [j]
    cmp dword [i], 26
    jl loop3

    ;; Trecem la pasul 2, adica la a doua linie din rotor pe care o vom roti
    add ecx, 26
    inc dword [k];
    cmp dword [k], 2
    jl doipasi

    pop ecx; scoatem ecx de pe stiva
    mov edx, [forward];
    mov ebx, [rotor];
    mov eax, [x];

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

; void enigma(char *plain, char key[3], char notches[3], char config[10][26], char *enc);
enigma:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; plain (address of first element in string)
    mov ebx, [ebp + 12] ; key
    mov ecx, [ebp + 16] ; notches
    mov edx, [ebp + 20] ; config (address of first element in matrix)
    mov edi, [ebp + 24] ; enc
    ;; DO NOT MODIFY
    ;; TODO: Implement enigma
    ;; FREESTYLE STARTS HERE


    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY