%include "../include/io.mac"

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

section .bss
    auxiliar: resb proc_size; pentru swap-ul a doua structuri
    lg resd 1; lungimea
    i resd 1; index
    j resd 1; index

section .text
    global sort_procs

sort_procs:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov edx, [ebp + 8]      ; processes
    mov eax, [ebp + 12]     ; length
    ;; DO NOT MODIFY

    ;; Your code starts here
    
    ;; Vom folosi variabile pentru a putea utiliza/'elibera' registrii
    ;; Vom sorta folosind sortarea prin interschimbarile
    ;; for(i = 0; i < length; i++)
    ;;    for(j = i+1; j < length; j++)
    ;;        if(processes[i].prio > processes[j].prio)
    ;;            swap(processes[i],processes[j]);
    ;;        else if(processes[i].prio == processes[j].prio)
    ;;            if(processes[i].time > processes[j].time)
    ;;                swap(processes[i],processes[j]);
    ;;            else if(processes[i].time == processes[j].time)
    ;;                if(processes[i].pid > processes[j].pid)
    ;;                    swap(processes[i],processes[j]);
    
    mov [lg], eax

    mov dword [i], 0; i = 0
    mov ecx, [i]
    cmp ecx, [lg]
    jge exit_i

loop_i:
    mov ecx, [i]
    mov [j], ecx
    inc dword [j]; j = i+1
    
    ;; Determinam elementul processes[i]
    ;; ebx = proc_size*i
    push edx
    mov eax, [i]
    mov ecx, proc_size
    mul ecx
    mov ebx, eax
    pop edx
    ;; PRINTF32 `\ni: %d\n Rezultatul este: %d\n\x0`, [i], ebx

    mov ecx, [j]; j = i
    cmp ecx, [lg]
    jge exit_j

loop_j:
    ;; Determinam elementul processes[j]
    ;; eax = proc_size*j
    push edx
    mov eax, [j]
    mov ecx, proc_size
    mul ecx
    pop edx
    ;; PRINTF32 `\nj: %d\n Rezultatul este: %d\n\x0`, [j], eax
    
    ;; Facem interschimbarile
    mov cl, [edx + ebx + proc.prio];
    cmp cl, [edx + eax + proc.prio];
    jg swapp; if(processes[i].prio>processes[j].prio)
    je prioritati_egale; 
    jmp continuam_cu_pasul_urmator

swapp:
    mov cx, [edx + ebx + proc.pid];
    mov [auxiliar + proc.pid], cx;
    mov cl, [edx + ebx + proc.prio];
    mov [auxiliar + proc.prio], cl;
    mov cx, [edx + ebx + proc.time];
    mov [auxiliar + proc.time], cx;

    mov cx,[edx + eax + proc.pid]
    mov [edx + ebx + proc.pid],cx
    mov cl,[edx + eax +proc.prio]
    mov [edx + ebx + proc.prio],cl
    mov cx,[edx + eax +proc.time]
    mov [edx + ebx + proc.time],cx

    mov cx,[auxiliar + proc.pid];
    mov [edx + eax + proc.pid],cx;
    mov cl,[auxiliar + proc.prio];
    mov [edx + eax + proc.prio],cl;
    mov cx,[auxiliar + proc.time];
    mov [edx + eax + proc.time],cx;

    jmp continuam_cu_pasul_urmator

prioritati_egale:
    mov cx, [edx + ebx + proc.time];
    cmp cx, [edx + eax + proc.time];
    jg swapp; if(processes[i].time>processes[j].time)
    je cuante_egale
    jmp continuam_cu_pasul_urmator

cuante_egale:
    mov cx, [edx + ebx + proc.pid];
    cmp cx, [edx + eax + proc.pid];
    jg swapp; if(processes[i].pid>processes[j].pid)

continuam_cu_pasul_urmator:
    inc dword [j]
    mov ecx, [j]
    cmp ecx, [lg]
    jl loop_j

exit_j:
    inc dword [i]
    mov ecx, [i]
    cmp ecx, [lg]
    jl loop_i

exit_i:
    ;; mov eax, [lg]
    
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY