%include "../include/io.mac"

    ;;
    ;;   TODO: Declare 'avg' struct to match its C counterpart
    ;;

struc avg
    .quo: resw 1
    .remain: resw 1
endstruc

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

    ;; Hint: you can use these global arrays
section .data
    prio_result dd 0, 0, 0, 0, 0
    time_result dd 0, 0, 0, 0, 0

section .bss
    lg resd 1
    i resd 1

section .text
    global run_procs

run_procs:
    ;; DO NOT MODIFY

    push ebp
    mov ebp, esp
    pusha

    xor ecx, ecx

clean_results:
    mov dword [time_result + 4 * ecx], dword 0
    mov dword [prio_result + 4 * ecx],  0

    inc ecx
    cmp ecx, 5
    jne clean_results

    mov ecx, [ebp + 8]      ; processes
    mov ebx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ; proc_avg
    ;; DO NOT MODIFY
   
    ;; Your code starts here

    push eax ; scapam de eax pentru moment
    mov [lg], ebx
    
    mov dword [i], 0; i = 0
    mov ebx, [i]
    cmp ebx, [lg]
    jge exitt

    ;; for(i = 0; i < lg; i++)
    ;;      time_result[processes[i].prio-1]+=procceses[i].time;
    ;;      prio_result[processes[i].prio-1]++;
loop:
    mov eax, [i]
    mov ebx, proc_size
    mul ebx
    ;; PRINTF32 `\ni: %d\n Rezultatul este: %d\n\x0`, [i], eax
    ;; eax = i*proc_size
    mov bl, [ecx + eax + proc.prio]
    mov bh, bl
    dec bh
    movzx edx, bh
    inc dword [prio_result+4*edx]; prio_result[processes[i].prio-1]++;
    mov bx,[ecx+eax+proc.time]
    add [time_result+4*edx], bx; time_result[processes[i].prio-1]+=procceses[i].time;
    ;
    inc dword [i]
    mov ebx, [i]
    cmp ebx, [lg]
    jl loop

exitt:

    mov ebx, 0
    pop eax
    push ecx
    mov ecx, eax

    ;; for(i = 0; i < 5; i++)
    ;;    if(prio_result[i])
    ;;      proc_avg[i].quo = time_result[i]/prio_result[i];
    ;;      proc_avg[i].remain = time_result[i]%prio_result[i];
    ;;    else
    ;;      proc_avg[i].quo = proc_avg[i].remain = 0;
bucla:
    xor edx, edx
    mov eax, [time_result + 4*ebx]
    cmp dword [prio_result + 4*ebx], 0
    je nu_se_poate_imparti
    div dword [prio_result + 4*ebx]

nu_se_poate_imparti:
    ;; PRINTF32 `i: %d\n Rezultatul este: %d %d\n\x0`, ebx, eax, edx
    mov [ecx+4*ebx+avg.quo], ax
    mov [ecx+4*ebx+avg.remain], dx
    inc ebx
    cmp ebx,5
    jl bucla
    
    mov eax, ecx
    mov ebx, [lg]
    pop ecx


    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY