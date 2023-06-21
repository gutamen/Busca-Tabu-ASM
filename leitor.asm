readProgramadores:	
	xor rax, rax	
	mov rdi, [fileHandle1]
	lea rsi, [scanCtrl]
	lea rdx, [quantProg]

	call fscanf
	
	
readTarefa:	
	xor rax, rax	
	mov rdi, [fileHandle1]
	lea rsi, [scanCtrl]
	lea rdx, [quantTarf]

	call fscanf
	

preReadMatrizCusto:

	xor rax,rax
	movsx rax, dword[quantProg]
	movsx rbx, dword[quantTarf]
	imul rax, rbx
	mov qword[ForJ], rax
	imul rax, 8
	sub rsp,rax
	

    mov rax, rsp
    and rax, 0b1000
    cmp rax, 8
	jne par1
	sub rsp,8
	par1:

	mov [MatrizCusto], rsp
	xor r15, r15
	mov qword[ForI], 0
	mov r14, rsp

readMatrizCusto:
	
	mov r15, qword[ForI]
	inc qword[ForI]

	xor rax, rax	
	mov rdi, [fileHandle1]
	lea rsi, [scanCtrl]
    mov r14, [MatrizCusto]
	lea rdx, [r14+r15*8]

	call fscanf
	
	
	mov rax,[ForI]
	cmp rax,[ForJ]
	jne readMatrizCusto


preReadMatrizCH:

	xor rax,rax
	movsx rax, dword[quantProg]
	movsx rbx, dword[quantTarf]
	imul rax, rbx
	mov qword[ForJ], rax
	imul rax, 8
	sub rsp,rax
	

    mov rax, rsp
    and rax, 8
    cmp rax, 8
	jne par2
	sub rsp,8
	par2:

	mov [MatrizCH], rsp
	xor r15, r15
	mov qword[ForI], 0
	mov r14, rsp

readMatrizCH:
	
	mov r15,[ForI]
	inc qword[ForI]

	xor rax, rax	
	mov rdi, [fileHandle1]
	lea rsi, [scanCtrl]

	lea rdx, [r14+r15*8]

	call fscanf

	mov rax, [ForI]
	cmp rax, [ForJ]
	jne readMatrizCH


preReadCargaH:

	xor rax,rax
	movsx rax, dword[quantProg] 
	mov qword[ForJ], rax
	imul rax,8
	sub rsp,rax
	
	mov rax, rsp
    and rax, 8
    cmp rax, 8
	jne par3
	sub rsp,8
	par3:

	mov [CargaH], rsp

	
	xor r15, r15
	mov qword[ForI], 0
	mov r14, rsp


readCargaH:
	
	mov r15,[ForI]
	inc qword[ForI]

	xor rax, rax	
	mov rdi, [fileHandle1]
	lea rsi, [scanCtrl]

	lea rdx, [r14+r15*8]

	call fscanf
	

	mov rax,[ForI]
	cmp rax,[ForJ]
	jne readCargaH
