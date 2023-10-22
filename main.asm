[org 0x100]

jmp start

x: dw 0
y: dw 0
xy: dw 0
len: dw 1
ltmv: dw 1

start:
    call bg
    call game

game:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es

    mov word[x], 20
    mov word[y], 2
    call snake

l4:
    call check_key ; This is where you check for keyboard input
    call delay
    call snake
    jmp l4

    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

check_key:
    mov ah, 0x1
    int 16h
	jz cont
	mov ah, 0x0
    int 16h
	
    cmp ah, 4Bh
    je left
    cmp ah, 4Dh
    je right
    cmp ah, 48h
    je up
    cmp ah, 50h
    je down
    jmp cont

left:
    cmp word[ltmv], 1
    je cont
    add word[x], -2
    mov word[ltmv], 0
    ret

right:
    cmp word[ltmv], 0
    je cont
    add word[x], 2
    mov word[ltmv], 1
    ret

up:
    cmp word[ltmv], 3
    je cont
    add word[y], -1
    mov word[ltmv], 2
    ret

down:
    cmp word[ltmv], 2
    je cont
    add word[y], 1
    mov word[ltmv], 3
    ret

cont:
    cmp word[ltmv], 0
    je left
    cmp word[ltmv], 1
    je right
    cmp word[ltmv], 2
    je up
    cmp word[ltmv], 3
    je down
    ret

snake:	
	push ax
	push dx
	push cx
	push di
	push es
	std
	
	;call bg
	mov dx, 0xB800
	mov es, dx
	mov dh, 0x02
	mov dl, 0xDC
	
	call get_cords
	
	mov di, word[xy]
	mov cx, [len]
	xchg ax, dx
	rep stosw
	xchg ax, dx
	
	
	pop es
	pop di
	pop cx
	pop dx
	pop ax
	ret
	
get_cords:
	push ax
	push bx

	mov al, byte[y]
	mov bl, 80
	mul bl
	add ax, word[x]
	shl ax, 1
	mov word[xy], ax
	
	pop bx
	pop ax
	ret
	
delay:
	push cx
	push dx
	push di
	
	mov cx, 5
	mov di, 0

	l1: 
		mov dx, 0xFFFF
		l2: 
			dec dx
			jnz l2
	loop l1
	
	pop di
	pop dx
	pop cx
	ret


bg:
	push ax
	push cx
	push di
	push es
	
	mov ax, 0xB800
	mov es, ax
	mov ah, 0x07
	mov al, 0xB1
	mov di, 0
	mov cx, 2000
	cld
	rep stosw
	
	mov al, 0x20	
	mov di, 160
	mov cx, 1840
	cld
	rep stosw
	mov di, 0
	mov al, 0xB1
	mov cx, 24
	l3:
		mov [es:di], ax
		add di, 158
		mov [es:di], ax
		add di, 2
		loop l3
	pop es
	pop di
	pop dx
	pop cx
	ret


mov ax, 0x4C00
int 0x21
