
section .data

section .data
    matrice: times 100 db 0; luam o matrice de 10x10, putea fi si neinitializata

section .bss
    x resd 1
    y resd 1
    i resd 1
    j resd 1

section .text
	global checkers

checkers:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; table

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE
    mov edx, matrice
    mov [x], eax
    mov [y], ebx

    ;; Pasul 1: Initializam 'matrice' cu 0
    mov dword [i], 0

initializare_cu_zero_matrice:
    mov eax, [i]
    mov byte [edx+eax], 0
    inc dword [i]
    cmp dword [i], 100
    jl initializare_cu_zero_matrice


    ;; Pasul 2: Bordam matricea table cu o coloana stanga, alta
    ;; dreapta, o linie deasupra si una sub => variabila globala matrice
    ;; Determinam pozitia curenta in 'matrice'
    inc dword [x]
    inc dword [y]
    mov eax, [x]
    mov ebx, [y]

    ;; Pentru linia x si coloana y vecinii de deasupra sunt de
    ;; coordonate 10(x-1)+(y-1) si 10(x-1)+(y+1)
    push edx; il punem pe stiva, deoarece la inmultire va fi modificat
    ;; eax = 10*(x-1)+y
    mov eax, [x]
    dec eax;
    mov ebx, 10
    mul ebx
    add eax, [y]
    ;;
    pop edx; am terminat cu inmultirea, avem nevoie de edx
    dec eax
    mov byte [edx+eax], 1; stanga-sus
    mov byte [edx+eax+2], 1; dreapta-sus

    ;; Pentru linia x si coloana y vecinii de sub acest punct 
    ;; sunt de coordonate 10(x+1)+(y-1) si 10(x+1)+(y+1)
    push edx; il punem pe stiva, deoarece la inmultire va fi modificat
    ;; eax = 10*(x+1)+y
    mov eax, [x]
    inc eax;
    mov ebx, 10
    mul ebx
    add eax, [y];
    ;;
    pop edx; am terminat cu inmultirea, avem nevoie de edx
    dec eax
    mov byte [edx+eax], 1; stanga-jos
    mov byte [edx+eax+2], 1; dreapta-jos

    ;; 'Decupam' submatricea table din 'matrice'
    ;; table[i-1][j-1]=matrice[i][j], i=1,8 j=1,8
    ;; matrice[i][j]=valoarea de pe pozitia 10*i+j
    ;; table[i-1][j-1]=valoarea de pe pozitia 8(i-1)+j-1
    mov dword [i], 1

for_i:
    mov dword [j], 1

for_j:
    push edx
    ;; Calculam 10*i+j, adica pozitia lui matrice[i][j]
    mov eax, [i]
    mov ebx, 10
    mul ebx
    add eax, [j]
    pop edx
    mov bl, [edx+eax]; bl=matrice[i][j]
    ;;
    
    push ebx
    ;Calculam 8(i-1)+j-1, adica pozitia lui table[i-1][j-1]
    push edx
    mov eax, [i]
    dec eax
    mov ebx, 8
    mul ebx
    add eax, [j]
    dec eax;
    pop edx
    ;;
    
    pop ebx;
    mov [ecx+eax],bl; table[i-1][j-1]=bl
    
    ;;Mergem o pozitie la dreapta
    inc dword [j]
    cmp dword [j], 9
    jl for_j
    
    ;;Trecem pe urmatoarea linie
    inc dword [i]
    cmp dword [i], 9
    jl for_i

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY