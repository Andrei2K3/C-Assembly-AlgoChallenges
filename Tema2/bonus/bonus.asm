section .data

section .bss
    k resd 1
    x resd 1
    y resd 1
    x_nou resd 1
    y_nou resd 1
    nr resd 1
    board resd 2

section .text
    global bonus

bonus:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; board

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE

    ;; Am implementat o scriere echivalenta a codului:
;;void modificare(int x, int y, int board[2])
;;{
;;    int nr;
;;    if (x >= 0 && x <= 7 && y >= 0 && y <= 7)
;;    {
;;        if (x < 4)
;;        {
;;            nr = 8 * (3 - x) + y;
;;            board[0] = board[0] | (1 << nr);
;;        }
;;        else
;;        {
;;            nr = 8 * (7 - x) + y;
;;            board[1] = board[1] | (1 << nr);
;;        }
;;    }
;;}
;;
;;void bonus(int x, int y, int board[2])
;;{
;;    x = 7 - x;
;;    board[0] = 0;
;;    board[1] = 0;
;;    int x_nou, y_nou, nr;
;;    x_nou = x - 1;
;;    y_nou = y - 1;
;;    modificare(x_nou, y_nou, board);
;;    x_nou = x - 1;
;;    y_nou = y + 1;
;;    modificare(x_nou, y_nou, board);
;;    x_nou = x + 1;
;;    y_nou = y - 1;
;;    modificare(x_nou, y_nou, board);
;;    x_nou = x + 1;
;;    y_nou = y + 1;
;;    modificare(x_nou, y_nou, board);
;;}
    ;;
    mov [x], eax
    mov [y], ebx
    mov edx, ecx; ecx->edx, caci vom avea nevoie de cl la shl
    push ecx; il punem pe stiva, iar la final il vom scoate
    mov eax, 7
    sub eax, [x]
    mov [x], eax; x<-7-x
    mov dword [edx], 0; board[0]=0
    mov dword [edx+4], 0; board[1]=0


    ;; k=1 stanga-sus
    ;; k=2 dreapta-sus 
    ;; k=3 stanga-jos
    ;; k=4 dreapta-jos
    ;; => vom avea de facut 4 iteratii pentru fiecare vecin de pe diagonale
    mov dword [k], 1

patru_iteratii:

    cmp dword [k], 1
    je stanga_sus
    cmp dword [k], 2
    je dreapta_sus
    cmp dword [k], 3
    je stanga_jos
    jmp dreapta_jos

stanga_sus:
    ;; x_nou=x-1, y_nou=y-1
    mov eax, [x]
    mov [x_nou], eax
    dec dword [x_nou]
    mov eax, [y]
    mov [y_nou], eax
    dec dword [y_nou]
    mov eax, [x_nou]
    mov ebx, [y_nou]
    jmp lucru

dreapta_sus:
    ;; x_nou=x-1, y_nou=y+1
    mov eax, [x]
    mov [x_nou], eax
    dec dword [x_nou]
    mov eax, [y]
    mov [y_nou], eax
    inc dword [y_nou]
    mov eax, [x_nou]
    mov ebx, [y_nou]
    jmp lucru

stanga_jos:
    ;; x_nou=x+1, y_nou=y-1
    mov eax, [x]
    mov [x_nou], eax
    inc dword [x_nou]
    mov eax, [y]
    mov [y_nou], eax
    dec dword [y_nou]
    mov eax, [x_nou]
    mov ebx, [y_nou]
    jmp lucru

dreapta_jos:
    ;; x_nou=x+1, y_nou=y+1
    mov eax, [x]
    mov [x_nou], eax
    inc dword [x_nou]
    mov eax, [y]
    mov [y_nou], eax
    inc dword [y_nou]
    mov eax, [x_nou]
    mov ebx, [y_nou]

lucru:
    cmp dword [x_nou], 0
    jl exit
    cmp dword [x_nou], 7
    jg exit
    cmp dword [y_nou], 0
    jl exit
    cmp dword [y_nou], 7
    jg exit
    ;;Deci punctul e in interiorul tablei
    
    cmp dword [x_nou], 4
    jge board_1 

;board_0: ; daca ne aflam in partea superioara a matricei
;; nr = 8 * (3 - x_nou) + y_nou;
;; board[0] = board[0] | (1 << nr);
    mov eax, [y_nou]
    mov [nr], eax; nr=y_nou
    push edx
    mov eax, 3
    sub eax, [x_nou]
    mov ebx, 8
    mul ebx
    pop edx
    add [nr], eax; nr=nr+8*(3-x_nou)
    mov eax, [nr]
    mov cl, [nr]
    mov eax, 1
    shl eax, cl
    mov ebx, [edx]
    or eax, ebx; eax=eax|[edx]
    mov [edx], eax; [edx]=eax
    jmp exit

board_1: ; daca ne aflam in partea inferioara a matricei
;; nr = 8 * (7 - x) + y;
;; board[1] = board[1] | (1 << nr);
    mov eax, [y_nou];
    mov [nr], eax; nr=y_nou
    push edx
    mov eax, 7
    sub eax, [x_nou]
    mov ebx, 8
    mul ebx
    pop edx
    add [nr], eax; nr=nr+8*(7-x_nou)
    mov eax, [nr]
    mov cl, [nr]
    mov eax, 1
    shl eax, cl
    or eax, dword [edx+4]; eax=eax|[edx+4]
    mov [edx+4], eax; [edx+4]=eax
    jmp exit

exit:
    inc dword [k];
    cmp dword [k], 5
    jl patru_iteratii

    pop ecx

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY