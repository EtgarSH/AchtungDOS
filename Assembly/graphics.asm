proc DrawFrame
	push ax
	push cx
	push di
	push es

	mov ax, 0a000h
	mov es, ax
	mov di, 0

	mov ax, 5
	mov cx, 1280 ; 320 * 4
	cld
	rep stosb

	mov di, 64000
	mov cx, 1280
	std
	rep stosb

	pop es
	pop di
	pop cx
	pop ax
	ret
endp DrawFrame

proc ColorScreen ; al - color
	push cx
	push di
	push es

	push ax
	mov ax, 0a000h
	mov es, ax

	mov di, 0
	pop ax
	push ax
	mov ah, al
	mov cx, 32000
	cld
	rep stosw

	push ax
	pop es
	pop di
	pop cx
	ret
endp ColorScreen

proc WhoWin 
	
endp WhoWin