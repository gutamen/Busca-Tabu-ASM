printMatriz: ;void[rax] printMatriz(int *MatrizparaPrint[rdi], int Tamanhomatriz[rsi], int Tamanholinha[rdx],int *arquivo[rcx])
	push rbp
	mov rbp, rsp
	mov r15, rdi
	mov r14, rsi
	mov r13, rdx
	mov r12, rcx
	xor r10, r10
	xor rbx, rbx
	sub rsp,16
	mov qword[rsp+16], r12
	and qword[rsp+8], 0
	printMatrizFor1:
	mov rdi, [rsp+16]
	lea rsi, [printCtrl]
	mov rax, qword[rsp+8]
	mov	edx, [r15+rax*8]
	xor rax,rax
	call fprintf
	inc qword[rsp+8]
	inc rbx
	cmp rbx, r13
	jne printMatrizCond
		xor rax,rax
		mov rdi, [rsp+16]
		lea rsi, [println]
		call fprintf
		xor rbx, rbx
	printMatrizCond:
	cmp qword[rsp+8], r14
	jne printMatrizFor1

	mov rsp, rbp
	pop rbp
	ret

printVetor: ;void[rax] printVetor(int *VetorparaPrint[rdi], int Tamanholinha[rsi],int *arquivo[rdx])
	push rbp
	mov rbp, rsp
	mov r15, rdi
	mov r14, rsi
	mov r12, rdx
	xor r10, r10
	sub rsp,16
	mov qword[rsp+16], r12
	and qword[rsp+8], 0
	printVetorFor1:
	mov rdi, [rsp+16]
	lea rsi, [printCtrl]
	mov rax, qword[rsp+8]
	mov	edx, [r15+rax*8]
	xor rax,rax
	call fprintf
	inc qword[rsp+8]
	cmp qword[rsp+8], r14
	jne printVetorFor1
	mov rdi, [rsp+16]
	lea rsi, [println]
	xor rax,rax
	call fprintf
	mov rsp, rbp
	pop rbp
	ret