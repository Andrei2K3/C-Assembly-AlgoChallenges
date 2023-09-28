section .data
	back db "..", 0
	curr db ".", 0
	slash db "/", 0
	; declare global vars here
	varf_stiva dd 0
	index_output dd 0
	index dd 0

section .text
	global pwd
	extern strcmp
	extern strcat

;;	void pwd(char **directories, int n, char *output)
;	Adauga in parametrul output path-ul rezultat din
;	parcurgerea celor n foldere din directories
pwd:
	enter 0, 0
	pusha

	mov edx, [ebp+8];directories
	mov ecx, [ebp+12];lg
	mov ebx, [ebp+16];output

	mov dword [varf_stiva],0

;;Punem pe stiva cuvintele, iar acolo unde intalnim . nu 
;;facem nimic, iar daca intalnim .. scoatem elementul din
;;varful stivei
parcurgere_directiories:

	push edx
	push ecx
	push dword [edx]
	push curr
	call strcmp
	add esp, 8
	pop ecx
	pop edx
	cmp eax, 0
	je next

	push edx
	push ecx
	push dword [edx]
	push back
	call strcmp
	add esp, 8
	pop ecx
	pop edx
	cmp eax, 0
	je mutare_un_pas_in_spate

	push edx
	inc dword [varf_stiva]

;;trecem la cuvantul urmator
next:
	add edx, 4
	loop parcurgere_directiories



	;;Initializez output cu caracterul null
	mov byte [ebx], 0
	;;Concatenam la ebx pe '\'
	push slash
	push ebx
	call strcat
	add esp, 8

;;Parcurgem elementele de pe stiva de la baza ei in sus(in jos
;;cum ar veni in assembly)
	mov dword [index_output], 1
	mov ecx, dword [varf_stiva]
parcurgere_baza_stiva:
	mov edx, dword [esp+(ecx-1)*4]

	push ecx
	push dword [edx]
	push ebx
	call strcat
	add esp, 8
	push slash
	push ebx
	call strcat
	add esp, 8

	pop ecx

	loop parcurgere_baza_stiva


;;Golesc stiva de cuvinte
	mov ecx, dword [varf_stiva]
loop2:
	pop eax
	loop loop2


	popa	
	leave
	ret

;;Am intalnit .. deci extrag varful stivei
mutare_un_pas_in_spate:
	cmp dword [varf_stiva], 0
	jg stergere_cuvant
	jmp next

stergere_cuvant:
	dec dword [varf_stiva]
	pop eax;extrag cuvant
	jmp next