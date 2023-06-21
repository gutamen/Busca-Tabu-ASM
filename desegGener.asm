; nasm -f elf64 desegGener.asm ; gcc -m64 -no-pie desegGener.o -o desegGener.x
extern printf
extern scanf
extern fopen
extern fclose
extern fprintf
extern fscanf
extern rewind
extern fgetc
extern ftell
extern fseek
extern atoi

%define MINIMO 0x80000000
%define PENALIZACAO 0x2
;%define TABUTIME 0x4
;%define MAXITERACOES 0x100

section .data
	;fileName  		: db "PDG3.txt", 0
	fileRes   		: db "result.txt", 0
	openWrite 		: db "w+", 0
	openRead  		: db "r+", 0
	scanCtrl  	 	: db "%d", 0
	printchar		: db "%c",9,0
	printCtrl 		: db "%12.1d",9, 0
	printIteracao	: db "Iteracao = %d", 10, "Melhor custo atual = %d", 10, 0
	printmelhorou	: db "Custo melhorado e possivel",10,0
	printinalt		: db "Melhor custo se mantem igual",10,0
	printimpo		: db "Solucao impossivel encontrada no passo atual, custo inalterado", 10, 0
	printatual		: db "Custo da iteracao atual = %d",10,0
	println	  		: db 10,0
	printlnfortab	: db "|",9,10,"|",9,0
	
	
section .bss
	quantProg   		: resd 1
	melhorcusto			: resd 1	
	pontArq    	 		: resq 1
	quantTarf   		: resd 1
	MatrizCH 			: resq 1
	ForI				: resq 1
	ForJ				: resq 1
	ForK 				: resq 1
	ForL				: resq 1
	ForN				: resq 1
	CargaH				: resq 1
	MatrizCusto 		: resq 1
	MatrixMut   		: resq 1
	CopiaCH				: resq 1
	Arrependimento    	: resq 1
	Memoria1    		: resq 1
	Memoria2    		: resq 1
	TabTabu				: resq 1
	Tabcontas			: resq 1
	VetorColuna			: resq 1
	MenorValor			: resq 1
	TamanhoMatriz		: resd 1
	Iteracao   			: resd 1
	melhordist			: resq 1
	fileHandle1 		: resq 10
	fileHandle2 		: resq 10
	fileName			: resq 1
	MAXITERACOES		: resq 1
	TABUTIME			: resq 1
	custoatual			: resq 1


section .text
	global main

main:
	
	push rbp
	mov rbp, rsp

	mov rbx, [rsi+8]
	mov [fileName], rbx	
	%include "pushall.asm"
	mov rdi, [rsi+16]
	call atoi
	mov [MAXITERACOES], rax
	%include "popall.asm"
	%include "pushall.asm"
	mov rdi, [rsi+24]
	call atoi
	mov [TABUTIME], rax
	%include "popall.asm"
	and qword[rsp-8],0
	and qword[rsp-16],0
	and qword[rsp-24],0
	and qword[rsp-32],0
	and qword[rsp-40],0
	and qword[rsp-48],0
	and qword[rsp-56],0
	and qword[rsp-64],0
	and qword[rsp-72],0
	and qword[rsp-80],0
	and qword[rsp-88],0
	and qword[rsp-96],0
	and qword[rsp-104],0
	and qword[rsp-112],0
	and qword[rsp-120],0

openArq1:
	and dword[Iteracao], 0
	mov rdi, [fileName]
	lea rsi, [openRead]
	call fopen
	
	mov [fileHandle1], rax
	
%include "leitor.asm"

openArq2:
	lea rdi, [fileRes]
	lea rsi, [openWrite]
	call fopen
	mov [fileHandle2], rax

	xor rax,rax
	movsx rax, dword[quantProg]
	movsx rbx, dword[quantTarf]
	imul rax, rbx
	mov dword[TamanhoMatriz], eax

PrimeiraDistribuicao:

	movsx rax, dword[TamanhoMatriz]
	mov qword[ForJ], rax
	imul rax, 8
	sub rsp,rax

	mov rax, rsp
    and rax, 8
    cmp rax, 8
	jne par4
	sub rsp, 8
	par4:

	mov [MatrixMut], rsp

	xor r15, r15
	mov qword[ForI], 0

	mov r14, rsp
	mov r13, [MatrizCH]
copiaMatrizCargaHoraria:
	
 	mov r15, [ForI]

	mov rdx, [r13+r15*8]

	mov [r14+r15*8], rdx 

	inc qword[ForI]

	mov rax, [ForI]
	cmp rax, [ForJ]
	jne copiaMatrizCargaHoraria


	xor rax,rax
	movsx rax, dword[quantProg]
	mov qword[ForJ], rax
	imul rax, 8
	sub rsp,rax

	mov rax, rsp
    and rax, 8
    cmp rax, 8 
	jne par5
	sub rsp, 8
	par5:

	mov [CopiaCH], rsp

	xor r15, r15
	mov qword[ForI], 0

	mov r14, rsp
	mov r13, [CargaH]
copiaCargaHoraria:
	
 	mov r15, [ForI]

	mov rdx, [r13+r15*8]

	mov [r14+r15*8], rdx 

	inc qword[ForI]

	mov rax, [ForI]
	cmp rax, [ForJ]
	jne copiaCargaHoraria	
	
preArrependimento:

	xor rax, rax
	movsx rax, dword[quantTarf]
	imul rax, 8
	sub rsp, rax

	mov rax, rsp
	and rax, 8
	cmp rax, 8
	jne par6
	sub rsp, 8
	par6:

	mov qword[Arrependimento], rsp



	mov qword[ForI], 2
	and qword[ForJ], 0

	mov r14, [Arrependimento]

	mov r13, [MatrixMut]

forRunTarefa:
	
	mov r15, [ForJ]
	mov edx, [r13+r15*8]
	mov [Memoria1], edx

	movsx r8, dword[quantTarf]
	add r8, r15
	mov ebx, [r13+r8*8]
	mov [Memoria2], ebx
	mov qword[ForI],2

trocatroca:
	cmp ebx, edx
	jg forRunProg
	mov [Memoria2], edx
	mov [Memoria1], ebx
	jmp forRunProg

trocaMem2:
	mov [Memoria2], edx

	forRunProg:
		movsx r11, dword[quantProg]
		cmp qword[ForI], r11
		je parada
		mov r15, [ForJ]
		movsx r12, dword[quantTarf]
		imul r12, [ForI]
		add r15, r12
		mov edx, [r13+r15*8]

		inc qword[ForI]
		cmp edx, [Memoria2]
		jg forRunProg
		cmp edx, [Memoria1]
		jg trocaMem2
		mov ecx, [Memoria1]
		mov [Memoria2], ecx
		mov [Memoria1], edx
		jmp forRunProg

parada:
		
	mov r15, [ForJ]
	mov r14, [Arrependimento]
	mov r11d, dword[Memoria2]
	sub r11d, dword[Memoria1]
	mov [r14+r15*8], r11d
	mov r9d, dword[quantTarf]
	dec r9d
	cmp dword[ForJ], r9d
	je geratabu					;cuidar aqui
	inc dword[ForJ]
	jmp forRunTarefa





	

geratabu:

	movsx rax, dword[TamanhoMatriz]
	mov qword[ForI],rax
	
	imul rax, 8
	sub rsp,rax

	mov rax, rsp
    and rax, 8
    cmp rax, 8
	jne par7
	sub rsp, 8
	par7:

	mov [Tabcontas], rsp
	and qword[ForN],0
zeratabcontas:
	mov r15,qword[ForN]
	inc qword[ForN]
	mov dword[rsp+r15*8],0
	mov rax,qword[ForI]
	cmp rax,[ForN]
	jne zeratabcontas
	


preselectTarefa:
	xor r15, r15
	xor r14, r14
	mov r13,[Arrependimento]
	mov r9,[MatrixMut]
	and qword[Memoria1],0
	and qword[ForI],0
	and qword[ForK],0

selectTarefa:
	mov r14, [ForI]
	inc qword[ForI]
	mov edx,[r13+r14*8]
	cmp edx,dword[Memoria1]
	jl menor
	mov dword[Memoria1],edx
	mov qword[ForL],r14
	

menor:
	;mov rax,[ForJ]
	movsx rax, dword[quantTarf]
	cmp rax,[ForI]
	jne selectTarefa
	inc rax
	inc qword[ForK]



	cmp rax,[ForK]
	je comecodaconta					; sai do conjunto de for's
	xor r14,r14
	mov dword[MenorValor],5000000
	and qword[ForN],0
	
preenchervetor:
	movsx rbx,dword[quantTarf]
	mov r14,[ForL]
	imul rbx, qword[ForN]
	inc qword[ForN]
	
	add r14,rbx
	
	
	mov ecx, [r9+r14*8]
	cmp ecx, dword[MenorValor]
	jnl passou
	inc ecx
	jecxz passou						; se existir trabalho com ch 0 impossibilita isto
	dec ecx
	mov dword[MenorValor],ecx
	mov rbx,qword[ForN]
	dec rbx
	mov qword[Memoria2],rbx 			; linha em que esta a menor CH
	passou:
	

	mov rax, qword[quantProg]
	cmp rax, qword[ForN]
	jne preenchervetor


matrizdostrabalhos:
	mov r10,[Tabcontas]
	movsx rbx,dword[quantTarf]
	imul rbx,qword[Memoria2]
	add rbx, qword[ForL]
	mov ecx,dword[MenorValor]
	mov [r10+rbx*8],ecx
	mov rax,[CopiaCH]
	mov rbx,qword[Memoria2]
	sub [rax+rbx*8],ecx
	mov edx,[rax+rbx*8]

	mov rax,[Arrependimento]
	mov rbx,[ForL]
	mov dword[rax+rbx*8],-1

	xor rax,rax
	movsx rbx, dword[quantTarf]
	imul rbx,qword[Memoria2]
	and qword[ForN],0
	mov esi,-1
calculodeCH:

	mov rax, qword[ForN]
	add rax,rbx
	inc qword[ForN]
	mov ecx, [r9+rax*8]
	cmp edx,ecx
	jnle passe
	mov	[r9+rax*8],esi
	passe:
	

	mov rax, qword[ForN]
	cmp eax,dword[quantTarf]
	jne calculodeCH 



	and qword[ForN],0


	
Arranjo:
	
	and qword[ForJ], 0

	mov r14, [Arrependimento]

	mov r13, [MatrixMut]

forRunTarefa1:
	
	mov r15, [ForJ]
	mov edx, [r13+r15*8]
	mov [Memoria1], edx

	movsx r8, dword[quantTarf]
	add r8, r15
	mov ebx, [r13+r8*8]
	mov [Memoria2], ebx
	mov qword[ForI],2

trocatroca1:
	cmp ebx, edx
	ja forRunProg1
	mov [Memoria2], edx
	mov [Memoria1], ebx
	jmp forRunProg1

trocaMem21:
	mov [Memoria2], edx

	forRunProg1:
		movsx r11, dword[quantProg]
		cmp qword[ForI], r11
		je parada1
		mov r15, [ForJ]
		movsx r12, dword[quantTarf]
		imul r12, [ForI]
		add r15, r12
		mov edx, [r13+r15*8]

		inc qword[ForI]
		cmp edx, [Memoria2]
		ja forRunProg1
		cmp edx, [Memoria1]
		ja trocaMem21
		mov ecx, [Memoria1]
		mov [Memoria2], ecx
		mov [Memoria1], edx
		jmp forRunProg1

parada1:
		
	mov r15, [ForJ]
	mov r14, [Arrependimento]
	mov eax,[r14+r15*8]
	cmp eax, -1
	je fora
	mov r11d, dword[Memoria2]
	cmp r11d, -1
	je sobrou1
	sub r11d, dword[Memoria1]
	mov [r14+r15*8], r11d
	jmp fora
	sobrou1:
	mov r11d, dword[Memoria1]
	mov [r14+r15*8], r11d
	fora:
	mov r9d, dword[quantTarf]
	dec r9d
	cmp dword[ForJ], r9d
	je corrigetopofor				;cuidar aqui
	inc dword[ForJ]
	jmp forRunTarefa1
	
corrigetopofor:
	and qword[ForI],0
	and qword[Memoria1],0
	mov r13,[Arrependimento]
	mov r9,[MatrixMut]
	jmp selectTarefa

	


	
comecodaconta:
;%include "pushall.asm"
;void[rax] printVetor(int *VetorparaPrint[rdi], int Tamanholinha[rsi],int *arquivo[rdx])
;	mov rdi, [CargaH]
;	movsx rsi, dword[quantProg]
;	mov rdx, [fileHandle2]
;	call printVetor	
;%include "popall.asm"


	movsx rax, dword[quantTarf]
	mov qword[ForJ], rax
	imul rax, 8
	sub rsp,rax
	
	mov rax, rsp
    and rax, 8
    cmp rax, 8
	jne par8
	sub rsp, 8
	par8:

	mov [TabTabu], rsp
	and qword[ForN],0
	movsx rax,dword[quantTarf]
zeratabcontas2:
	mov r15,qword[ForN]
	inc qword[ForN]
	mov dword[rsp+r15*8],0
	cmp rax,[ForN]
	jne zeratabcontas2



	mov r14,[MatrixMut]
	and qword[ForN],0
zeratabcontas3:
	mov r15,qword[ForN]
	inc qword[ForN]
	mov dword[r14+r15*8],0
	cmp rax,[ForN]
	jne zeratabcontas3

melhordistdelargada:
	movsx rax, dword[TamanhoMatriz]
	imul rax, 8
	sub rsp,rax
	
	mov rax, rsp
    and rax, 8
    cmp rax, 8
	jne par9
	sub rsp, 8
	par9:

	mov [melhordist], rsp
	and qword[ForN],0
	movsx rax,dword[TamanhoMatriz]
	mov r14, [Tabcontas]
geramelhordist:
	mov r15,qword[ForN]
	mov ebx, [r14+r15*8]
	inc qword[ForN]
	mov [rsp+r15*8],ebx
	cmp rax,[ForN]
	jne geramelhordist

	mov r14, [CopiaCH]
	mov r15, [CargaH]
	xor rax,rax
	movsx rbx, dword[quantProg]
bestCHresto:
	mov ecx, [r14+rax*8]
	mov [r15+rax*8], ecx
	inc rax
	cmp rax,rbx
	jne bestCHresto




preFordeNiteracoes:
;int[rax] calculaCusto(int *matrizCusto[rdi], int *matrizTrabalho[rsi], int tamanhoMatriz[rdx])
	mov rdi, [MatrizCusto]
	mov rsi, [Tabcontas]
	movsx rdx, dword[TamanhoMatriz]

	call CalculoCusto
	mov dword[melhorcusto],eax
FordeNiteracoes:

	mov ecx, [melhorcusto]
	mov rdi, [fileHandle2]
	lea rsi, [printIteracao]
	mov edx, dword[Iteracao]
	xor rax, rax
	
	
	call fprintf
;%include "pushall.asm"
;void[rax] printVetor(int *VetorparaPrint[rdi], int Tamanholinha[rsi],int *arquivo[rdx])
	;mov rdi, [TabTabu]
	;movsx rsi, dword[quantTarf]
	;mov rdx, [fileHandle2]
	;call printVetor	
;%include "popall.asm"

;%include "pushall.asm"
;void[rax] printMatriz(int *MatrizparaPrint[rdi], int Tamanhomatriz[rsi], int Tamanholinha[rdx],int *arquivo[rcx])
	;mov rdi, [MatrixMut]
	;movsx rsi, dword[TamanhoMatriz]
	;movsx rdx, dword[quantTarf]
	;mov rcx, [fileHandle2]
	;call printMatriz
;%include "popall.asm"

;void calculaDisposicao(int *matrizCusto[rdi], int *matrizTrabalho[rsi], int *matriDisposicao[rdx],
; int *matrizCH[rcx], int quanttarefa[r8],int quantprog[r9{r12}], int *tabtabu[rbp+24], int *cargahorialivre[rbp+16])
	mov rdi,[MatrizCusto]
	mov rsi,[Tabcontas]
	mov rdx,[MatrixMut]
	mov rcx,[MatrizCH]
	movsx r8,dword[quantTarf]
	movsx r9,dword[quantProg]
	mov rax,[TabTabu]
	push rax
	mov rax,[CopiaCH]
	push rax
	
	call CalculoDisposicao
	add rsp, 16
	and qword[rsp-8],0
	and qword[rsp-16],0

%include "pushall.asm"
;void[rax] printVetor(int *VetorparaPrint[rdi], int Tamanholinha[rsi],int *arquivo[rdx])
	mov rdi, [TabTabu]
	movsx rsi, dword[quantTarf]
	mov rdx, [fileHandle2]
	call printVetor	
%include "popall.asm"

;void[rax] TrocaTarefa(int *matrizTrabalho[rdi], int *matrizdisposicao[rsi], 
;int *listatabu[rdx], int TamanhoMatriz[rcx], int quantTarf[r8], int QualTabu[r9])
	mov rdi, [Tabcontas]
	mov rsi, [MatrixMut]
	mov rdx, [TabTabu]
	movsx rcx, dword[TamanhoMatriz]
	movsx r8, dword[quantTarf]
	mov r9, [TABUTIME]
	mov rax, [MatrizCH]
	push rax
	mov rax,[CopiaCH]
	push rax
	call TrocaTarefa
	add rsp, 16
	and qword[rsp-8],0
	and qword[rsp-16],0


	

	;%include "pushall.asm"
;void[rax] printVetor(int *VetorparaPrint[rdi], int Tamanholinha[rsi],int *arquivo[rdx])
	;mov rdi, [TabTabu]
	;movsx rsi, dword[quantTarf]
	;mov rdx, [fileHandle2]
	;call printVetor	
;%include "popall.asm"

;void[rax] calculodemelhor(int *matriztrabalho[rsi], int *melhorcusto, 
;int *matrizcusto[rdx], int tamanhomatriz[rcx], int *cargaH[r8], int quantProg[r9])	
	mov rdi, [Tabcontas]
	lea rsi, [melhorcusto]
	mov rdx, [MatrizCusto]
	mov rcx, [TamanhoMatriz]
	mov r8, [CopiaCH]
	
	movsx r9, dword[quantProg]
	call calculodemelhor

;print do custo na iteraçao
	xor rax, rax
	mov	rdi, [fileHandle2]
	lea rsi, [printatual]
	mov rdx, [custoatual]
	call fprintf



	inc dword[Iteracao]
	mov rax, [MAXITERACOES]
	cmp dword[Iteracao], eax
	jne FordeNiteracoes


	xor rax, rax
	mov r10, [melhordist]
apresentabilidadedamatrizmelhor:
	mov ecx,[r10+rax*8]
	jecxz trocaletra
		mov qword[r10+rax*8], 0
		mov byte[r10+rax*8], 88
		jmp trocaX
	trocaletra:
		mov qword[r10+rax*8], 0
		mov byte[r10+rax*8], 48
	trocaX:
	inc rax
	cmp eax, dword[TamanhoMatriz]
	jne apresentabilidadedamatrizmelhor
	
	xor rax, rax
	mov rdi, [fileHandle2]
	lea rsi, [printchar]
	mov dl, 124
	call fprintf
	xor rax,rax
	mov r15, [melhordist]
	movsx r14, dword[TamanhoMatriz]
	movsx r13, dword[quantTarf]
	mov r12, [fileHandle2]
	xor r10, r10
	xor rbx, rbx
	sub rsp,32
	mov qword[rsp+16], r12
	and qword[rsp+8], 0
	printMatrizFor11:
	mov rdi, [rsp+16]
	lea rsi, [printchar]
	mov rax, qword[rsp+8]
	mov	dl, byte[r15+rax*8]
	xor rax,rax
	call fprintf
	inc qword[rsp+8]
	inc rbx
	cmp rbx, r13
	jne printMatrizCond1
		xor rax,rax
		mov rdi, [rsp+16]
		lea rsi, [printlnfortab]
		call fprintf
		xor rbx, rbx
	printMatrizCond1:
	cmp qword[rsp+8], r14
	jne printMatrizFor11
	add rsp,32



close:
	mov rdi, [fileHandle1]

	call fclose

	mov rdi, [fileHandle2]

	call fclose

fim:
	
    mov rsp, rbp
    pop rbp

    mov rax, 60
    mov rdi, 0
    syscall



%include "printers.asm"

calculodemelhor: ;void[rax] calculodemelhor(int *matriztrabalho[rdi], int *melhorcusto[rsi], int *matrizcusto[rdx], int tamanhomatriz[rcx], int *cargaH[r8], int quantProg[r9])
	push rbp
	mov rbp, rsp
	sub rsp,16
	mov r11, rsi
	mov r12, rdi
	mov r10d, ecx
	xor rax, rax
	melhorfor:
	mov ecx, [r8+rax*8]
	inc rax
	cmp ecx, 0
	jnl semneg
		
		xor rax,rax
		mov rdi, [fileHandle2]
		lea rsi, [printimpo]
		call fprintf
		
		mov rsp, rbp
		pop rbp
		ret
 


	semneg:
	cmp rax, r9
	jne melhorfor

	%include "pushall.asm"
	;int[rax] calculaCusto(int *matrizCusto[rdi], int *matrizTrabalho[rsi], int tamanhoMatriz[rdx])
	mov rsi,rdi
	mov rdi,rdx
	mov edx,r10d
	call CalculoCusto
	mov [rsp+120], rax
	%include "popall.asm"
	mov eax, [rsp+8]
	mov [custoatual],eax
	cmp eax, dword[rsi]
	jge naomuda
		mov dword[rsi], eax
		xor rax, rax
		mov rdi, [fileHandle2]
		lea rsi, [printmelhorou]
		
		call fprintf

		xor rax,rax
		mov rbx, [melhordist]
		novamatrizmelhor:
		mov ecx, [r12+rax*8]
		mov [rbx+rax*8], ecx
		inc rax
		cmp rax,r10
		jne novamatrizmelhor


		mov rsp, rbp
		pop rbp
		ret

	naomuda:
	xor rax, rax
	mov rdi, [fileHandle2]
	lea rsi, [printinalt]
	call fprintf
	mov rsp, rbp
	pop rbp
	ret

TrocaTarefa: ;void[rax] TrocaTarefa(int *matrizTrabalho[rdi], int *matrizdisposicao[rsi], int *listatabu[rdx], int TamanhoMatriz[rcx], int quantTarf[r8], int QualTabu[r9], int *matrizCH[rbp+24],  int *cargaH[rbp+16])

	push rbp
	mov rbp, rsp
	mov r13,rcx
	sub rsp, 32
	mov r12,[rbp+16]
	mov r11,[rbp+24]
	and qword[rsp+8],0
	and qword[rsp+16],0
	and qword[rsp+24],0
	xor rax,rax
	mov r14,rdx
	mov ebx,MINIMO
	
	
	ForTrocaL:
	mov rax, qword[rsp+8]
	mov ecx,[rsi+rax*8]
	mov [rsp+16], ecx
	inc qword[rsp+8]
	xor rdx, rdx
	idiv r8
	mov ecx, [r14+rdx*8]
	jecxz troque
	jmp pulatroca
	troque:
	mov ecx, [rsp+16]
	cmp ecx,ebx
	jle pulatroca
		mov ebx,ecx
		mov r15,[rsp+8]
		dec r15
	pulatroca:
	mov rax, qword[rsp+8]
	cmp rax,r13
	jne ForTrocaL



	xor rax,rax
	tabuUpadate:
	mov ecx,[r14+rax*8]
	inc rax
	jecxz Updated
	dec ecx
	dec rax
	mov [r14+rax*8], ecx
	inc rax
	Updated:
	cmp rax,r8
	jne tabuUpadate


	xor rdx,rdx
	mov rax,r15
	idiv r8

	xor r10, r10
	mov rbx, rdx
	ForTrocaR:
	mov ecx,[rdi+rbx*8]
	add rbx,r8
	inc r10
	jecxz ForTrocaR
	dec r10
	sub rbx,r8
	mov dword[rdi+rbx*8],0
	mov ecx, [r11+rbx*8]
	add dword[r12+r10*8],ecx
	mov dword[rdi+r15*8],10
	mov dword[r14+rdx*8],r9d
	mov ecx,[r11+r15*8]
	sub dword[r12+rax*8],ecx
	

	


	mov rsp, rbp
	pop rbp
	ret
 
	

CalculoCusto: ;int[rax] calculaCusto(int *matrizCusto[rdi], int *matrizTrabalho[rsi], int tamanhoMatriz[rdx])

	push rbp
	mov rbp, rsp

	
	xor rax, rax
	xor r8, r8
	;dec rdx

	CalcCustFo:

		mov ecx, [rsi+r8*8]
		jecxz IfZero
		add eax, [rdi+r8*8]

		IfZero:

		inc r8
		cmp r8, rdx
		jne CalcCustFo

	mov rsp, rbp
	pop rbp
	ret

CalculoDisposicao: ;void calculaDisposicao(int *matrizCusto[rdi], int *matrizTrabalho[rsi], int *matriDisposicao[rdx], int *matrizCH[rcx], int quanttarefa[r8],int quantprog[r9{r12}], int *tabtabu[rbp+24], int *cargahorialivre[rbp+16])

	push rbp
	mov rbp, rsp
	mov r13, rcx
	mov r15,[rbp+16]
	xor rcx, rcx
	mov r10,r8
	imul r10,r9		; tamanho das matrizes em r10		
	mov r12,r9
	xor r9, r9
	CalculoDisposicaoFor1:

	mov ecx,[rsi+r9*8]
	jecxz IfZero1
		mov dword[rdx+r9*8],MINIMO
		jmp true0
	IfZero1:
	mov dword[rdx+r9*8],0
	true0:
	inc r9
	cmp r10,r9
	jne CalculoDisposicaoFor1


		
	and qword[rsp-16],0	
	xor r9,r9
	xor r11,r11
	and qword[rsp-8], 0
	CalculoDisposicaoFor2:
		mov r9,[rsp-16]
		mov rcx,[rbp+24]
		mov ecx,[rcx+r9*8]
		jecxz ondeestaatarefa
			jmp pulapasso
		ondeestaatarefa:
			xor rcx,rcx
			mov ecx,[rsi+r9*8]
			jecxz IfZero2
				mov [rsp-8],r9
				jmp stop1
			IfZero2:
			add r9,r8
			cmp r10,r9
			jne ondeestaatarefa

		stop1:
			mov r9,[rsp-16]
			mov r14,[rsp-8]
			and qword[rsp-24],0
			CalculoDisposicaoFor3:
				mov ecx,[r13+r9*8]
				xor rax, rax 	
				cmp r9, r14
				je incremento
					mov rbx,[rsp-24]
					mov eax,[r15+rbx*8]
					sub eax,ecx
					cmp eax,0
					jnl semhoraextra
						
						neg eax
						imul eax, PENALIZACAO  ; da MERDA se passar de 0x7fffffff
						mov ecx, [rdi+r9*8]
						add ecx, eax
						sub ecx, [rdi+r14*8]
						neg ecx
						mov [rdx+r9*8], ecx
						jmp incremento
					
					semhoraextra:
					mov ecx, [rdi+r9*8]
					sub ecx, [rdi+r14*8]
					neg ecx		
					mov [rdx+r9*8], ecx
					jmp incremento


				incremento:
				inc qword[rsp-24]
				add r9,r8
				cmp qword[rsp-24],r12
				jne CalculoDisposicaoFor3



		pulapasso:
		inc qword[rsp-16]
		cmp qword[rsp-16],r8
		jne CalculoDisposicaoFor2






	mov rsp, rbp
	pop rbp
	ret