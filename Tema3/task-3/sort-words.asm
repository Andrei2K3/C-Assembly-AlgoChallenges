global get_words
global compare_func
global sort

section .data
    delimitatori db " ,.",10,0

section .data
    mystring db "This is my string", 0

section .text
    extern strtok
    extern strcpy
    extern qsort
    extern strlen
    extern strcmp

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0
    pusha

    mov edx, [ebp+8]; words
	mov ecx, [ebp+12]; number_of_words
	mov ebx, [ebp+16]; size-ul unui char *

    ;;Punem argumentele functiei qsort pe stiva
    push compare_func
    push ebx
    push ecx
    push edx
    call qsort
    add esp, 16

    popa
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0
    pusha
    
    mov edx, [ebp+8]; s
	mov ecx, [ebp+12]; words
	mov ebx, [ebp+16]; number_of_words

    ;;Registrul eax ma intereseaza deoarece in el
    ;;returneaza functia strtok pointerul
    ;;Restul adreselor le conservam
    push ebx
    push ecx
    push edx

    ;;Separam cuvintele de delimitatori/separatori
    ;;folosind functia strtok
    ;;Tehnica folosita este cea clasica/obisnuita

    push delimitatori
    push edx
    call strtok
    add esp, 8

    ;;Aici recuperam adresele despre care am zis la 
    ;;linia 54
    ;;Asa vom face in tot programul
    pop edx
    pop ecx
    pop ebx

    ;PRINTF32 `%s %s\n\x0`, eax, edx

    push ebx
    push ecx
    push edx

    push eax
    push dword [ecx]
    call strcpy
    add esp, 8

    pop edx
    pop ecx
    pop ebx

    ;PRINTF32 `%s\n\x0`, [ecx]

    dec ebx
loop1:
    add ecx, 4

    push ebx
    push ecx
    push edx

    push delimitatori
    push dword 0
    call strtok
    add esp, 8

    pop edx
    pop ecx
    pop ebx

    ;PRINTF32 `%s %s\n\x0`, eax, edx
    push ebx
    push ecx
    push edx

    push eax
    push dword [ecx]
    call strcpy
    add esp, 8

    pop edx
    pop ecx
    pop ebx
    ;PRINTF32 `%s\n\x0`, [ecx]

    dec ebx
    cmp ebx, 0
    jne loop1

    popa
    leave
    ret


compare_func:
    enter 0,0
    push ebx
    push ecx
    push edx

    ;;ebx = primul string
    ;;ecx = al doilea string
    mov ebx, [ebp+8]
    mov ecx, [ebp+12]
    mov ebx, [ebx]
    mov ecx, [ecx]

    ;;
    push ebx
    push ecx

    push ebx
    call strlen
    add esp, 4
    mov edx, eax
    

    pop ecx
    pop ebx
    ;;

    push edx
    push ebx
    push ecx

    push ecx
    call strlen
    add esp, 4
    
    pop ecx
    pop ebx
    pop edx
    ;;

    ;;Comparam lungimea celor doua siruri de caractere
    sub edx, eax
    mov eax, edx
    cmp edx, 0
    jg mare
    jl mic
    jmp egale

sfarsit:
    pop edx
    pop ecx
    pop ebx

    leave
    ret

mare:
    mov eax, 1
    jmp sfarsit

mic:
    mov eax, -1
    jmp sfarsit

egale:
    mov eax, 0

    push ecx
    push ebx
    call strcmp
    add esp, 8
    ;;strcmp va intoarce prin eax o valoare
    ;;ce corespunde carui string e mai mare
    ;;lexicografic
    jmp sfarsit