section .text
    global inorder_fixing


;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_fixing(struct node *node, struct node *parent)
;       functia va parcurge in inordine arborele binar de cautare, modificand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista.
;
;       Unde este nevoie de modificari se va aplica algoritmul:
;           - daca nodul actual este fiul stang, va primi valoare tatalui - 1,
;                altfel spus: node->value = parent->value - 1;
;           - daca nodul actual este fiul drept, va primi valoare tatalui + 1,
;                altfel spus: node->value = parent->value + 1;

;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;

; ATENTIE: DOAR in frunze pot aparea valori gresite! 
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

inorder_fixing:
    enter 0, 0
    push eax
    push ebx
    
    mov eax, [ebp+8]; node
    mov ebx, [ebp+12]; parent

    cmp eax, 0
    je sfarsit

    ;salvez parintele in edx
    mov edx, ebx
    push edx

    mov ebx, eax
    push ebx
    push dword [eax+4]
    call inorder_fixing; ma duc pe nod->left
    add esp, 8
    
    ;extrag parintele
    pop edx

    cmp edx, 0
    je salt
    cmp [edx+4],eax
    jne vecin_dreapta

    mov edx, [edx];
    cmp [eax],edx
    jl salt; e valid

    push ecx
    mov ecx, edx
    mov [eax], ecx
    pop ecx
    dec dword [eax]; aplic formula din enunt pentru fiu
    jmp salt

vecin_dreapta:
    cmp [edx+8],eax
    jne salt
    
    mov edx, [edx];
    cmp [eax],edx
    jg salt

    push ecx
    mov ecx, edx
    mov [eax], ecx
    pop ecx
    inc dword [eax]; aplic formula din enunt pentru fiu
salt:

    mov edx, ebx
    push edx
    mov ebx, eax
    push ebx
    push dword [eax+8]
    call inorder_fixing; ma duc pe nod->right
    add esp, 8
    pop edx

sfarsit:
    pop ebx
    pop eax
    leave
    ret
