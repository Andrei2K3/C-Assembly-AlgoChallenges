section .data
	; declare global vars here
	lungime_sir dd 0

section .text
	global reverse_vowels
	extern strchr

;;	void reverse_vowels(char *string)
;	Cauta toate vocalele din string-ul `string` si afiseaza-le
;	in ordine inversa. Consoanele raman nemodificate.
;	Modificare se va face in-place
reverse_vowels:
	push ebp
	;mov ebp, esp
	push esp
	pop ebp
	
	;mov edx, [esp+8]
	push dword [esp+8]
	pop edx;edx pointeaza la inceputul stringului
	pusha


	push edx
	pop ebx; cu ebx ma deplasez prin string

	push dword 0
	pop dword [lungime_sir]

;;Parcurgem caracter cu caracter stringul si verificam daca caracterul
;;curent e vocala, daca e il punem pe stiva pe el, urmat de caracterul 
;;de dupa el
parcurgere_string:
	;;Verificam daca caracterul curent e 'a'
	push dword 'a'
	push ebx
	call strchr
	add esp,8
	cmp eax, ebx
	je pereche_vocala_pe_stiva
	;;Verificam daca caracterul curent e 'e'
	push dword 'e'
	push ebx
	call strchr
	add esp,8
	cmp eax, ebx
	je pereche_vocala_pe_stiva
	;;Verificam daca caracterul curent e 'i'
	push dword 'i'
	push ebx
	call strchr
	add esp,8
	cmp eax, ebx
	je pereche_vocala_pe_stiva
	;;Verificam daca caracterul curent e 'o'
	push dword 'o'
	push ebx
	call strchr
	add esp,8
	cmp eax, ebx
	je pereche_vocala_pe_stiva
	;;Verificam daca caracterul curent e 'u'
	push dword 'u'
	push ebx
	call strchr
	add esp,8
	cmp eax, ebx
	je pereche_vocala_pe_stiva
continuare:
	inc ebx
	inc dword [lungime_sir]
	cmp byte [ebx],0
	jne parcurgere_string


	;;ebx indica la inceputul stringului din nou
	sub ebx, [lungime_sir]
;;Determinam vocalele din string la fel cum am facut si anterior
;;insa de data aceasta extragem de pe stiva perechea vocala, caracter
;;si vom face in asa fel incat sa actualizam vocala curenta
parcurgere_string_2:

	push dword 'a'
	push ebx
	call strchr
	add esp,8
	cmp eax, ebx
	je actualizare_vocala
	;;
	push dword 'e'
	push ebx
	call strchr
	add esp,8
	cmp eax, ebx
	je actualizare_vocala
	;;
	push dword 'i'
	push ebx
	call strchr
	add esp,8
	cmp eax, ebx
	je actualizare_vocala
	;;
	push dword 'o'
	push ebx
	call strchr
	add esp,8
	cmp eax, ebx
	je actualizare_vocala
	;;
	push dword 'u'
	push ebx
	call strchr
	add esp,8
	cmp eax, ebx
	je actualizare_vocala
continuare2:
	inc ebx
	cmp byte [ebx],0
	jne parcurgere_string_2
	;; Am terminat "de muncit"
	popa
	push ebp
	pop esp
	pop ebp
	ret

;;Punem pe stiva perechea formata dintr-o vocala urmata
;;de un caracter
pereche_vocala_pe_stiva:
	push word [ebx]
	jmp continuare

;;Actualizam vocala curenta cu cea din varful stivei
;;mai precis am pus prin intermediul primei parcurgeri 
;;toata vocalele pe stiva, iar acum le scoatem/extragem
;;evident in ordine inversa
;;Luam exemplul hello spre exemplificare:
;;-prima parcurgere:
;;punem pe stiva el
;;		 o0
;;-a doua parcurgere:
;;iau o0, stringul devine ho0lo
;;din acest motiv pun inainte pe stiva pe ll
;;si vom face modificarea a doua hollo
;;analog se face si cu el
actualizare_vocala:
	push word [ebx+1]
	pop cx
	pop word [ebx]
	push cx
	pop word [ebx+1]
	jmp continuare2