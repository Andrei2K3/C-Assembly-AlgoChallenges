extern array_idx_2      ;; int array_idx_2

section .text
    global inorder_intruders

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_intruders(struct node *node, struct node *parent, int *array)
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista
;
;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;
;        array  -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: DOAR in frunze pot aparea valori gresite!
;          vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

; HINT: folositi variabila importata array_idx_2 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test al functiei inorder_intruders.      

inorder_intruders:
    enter 0, 0
    push eax
    push ebx
    push ecx
    
    mov eax, [ebp+8];;node
    mov ebx, [ebp+12];;parent
    mov ecx, [ebp+16];;array
    cmp eax, 0
    je sfarsit

    ;;pun parintele in edx si pe edx pe stiva
    mov edx, ebx
    push edx

    push ecx
    mov ebx, eax
    push ebx
    push dword [eax+4]
    call inorder_intruders
    add esp, 12

    pop edx; scot parintele de pe stiva
    cmp edx, 0; verific sa nu fie NULL cum este 
    ;;transmis initial ca parametru
    je salt

    cmp [edx+4],eax
    jne vecin_dreapta
    ;PRINTF32 `Nod_stanga=%d Parinte=%d   \x0`, [eax], [edx]

    mov edx, [edx];
    cmp [eax],edx
    jl salt; e valida inegalitatea

    ;PRINTF32 `%d\n\x0`, [eax]
    ;;Punem valorile cerute in vector
    mov edx, dword [array_idx_2]
    push eax
    mov eax, [eax]
    mov [ecx+edx*4], eax
    inc dword [array_idx_2]
    pop eax
    jmp salt

vecin_dreapta:
    cmp [edx+8],eax
    jne salt
    ;PRINTF32 `Nod_dreapta=%d Parinte=%d   \x0`, [eax], [edx]

    mov edx, [edx];
    cmp [eax],edx
    jg salt; e valida inegalitatea
    
    ;PRINTF32 `%d\n\x0`, [eax]
    ;;Punem valorile cerute in vector
    mov edx, dword [array_idx_2]
    push eax
    mov eax, [eax]
    mov [ecx+edx*4], eax
    inc dword [array_idx_2]
    pop eax
    
salt:

    mov edx, ebx
    push edx
    push ecx
    mov ebx, eax
    push ebx
    push dword [eax+8]
    call inorder_intruders
    add esp, 12
    pop edx

sfarsit:
    pop ecx
    pop ebx
    pop eax
    leave
    ret
