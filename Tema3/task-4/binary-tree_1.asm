extern array_idx_1      ;; int array_idx_1

section .text
    global inorder_parc

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_parc(struct node *node, int *array);
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor in vectorul array.
;    @params:
;        node  -> nodul actual din arborele de cautare;
;        array -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!
; HINT: folositi variabila importata array_idx_1 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test.

inorder_parc:
    enter 0, 0
    pusha
    
    mov eax, [ebp+8]; node
    mov ebx, [ebp+12]; array

    cmp eax, 0; nod diferint de NULL
    je sfarsit

    push ebx
    push dword [eax+4]; apel recursiv pentru nod->left
    call inorder_parc
    add esp, 8

    ;PRINTF32 `%d \x0`, [eax]
    ;;Adaugam pe [eax] in vector
    mov edx, dword [array_idx_1]
    mov ecx, [eax]
    mov [ebx+4*edx], ecx
    inc dword [array_idx_1]

    push ebx
    push dword [eax+8]; apel recursiv pentru nod->right
    call inorder_parc
    add esp, 8

sfarsit:
    popa
    leave
    ret
