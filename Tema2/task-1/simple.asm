%include "../include/io.mac"

section .text
    global simple
    extern printf

simple:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

    ;; DO NOT MODIFY
   
    ;; Your code starts here

    ;; Parcurgem stringul caracter cu caracter si facem modificarile necesare
    ;; for(i = 0; i < len; i++)
    ;; {
    ;;     char c = *plain;
    ;;     for(j = 0; j < step; j++)
    ;;     {
    ;;         c++;
    ;;         if(c>'Z')
    ;;             c-=26;
    ;;     }
    ;;     *enc_string=c;
    ;;     plain++;
    ;;     enc_string++;
    ;; }
    
    ;; Facem 000...0dl=edx
    mov eax, edx;
    xor edx, edx;
    mov dl, al;
    xor eax,eax

    mov eax, ecx; punem len in eax
    xor ebx,ebx

parcurgere:
    mov bl, [esi]
    mov dh, 0
    ;; for(dh = 0; dh != step; dh++)
    ;;      bl++;
    cmp dh, dl
    je step_e_zero

encode:
    inc dh
    inc bl
    cmp bl, 'Z'
    jle mai_mic_ca_Z
    sub bl, 26

mai_mic_ca_Z:
    cmp dh, dl
    jne encode
    
step_e_zero:
    mov [edi], bl
    ;; PRINTF32 `char_y: %c\n\x0`, [edi]
    inc esi
    inc edi
    loop parcurgere

    mov byte [edi], 0; punem caracterul NULL
    ;; sub edi, eax; facem ca edi sa indice inceputul lui enc_string

    ;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
