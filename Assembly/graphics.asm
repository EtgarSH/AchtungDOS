;------------------------------------------
; File        : graphics.asm
; Parent      : achtung.asm
; Authors     : Etgar
; Description : This file contains graphics procedure.
;------------------------------------------
DATASEG
	color db 2
	is_color_num db 0
CODESEG

proc DrawFrame ; Creates the purple frame - above the screen and below the screen.
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

; Change the color of the screen.
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

; Print a colored string
proc PrintColoredString ; bx - offset
	push ax
	push si
	push cx

	mov ah, 0eh
	xor si, si

@@string_iteration:
	mov al, [byte ptr bx+si]

	cmp al, '$'
	jz @@return

	cmp al, '&'
	jnz @@not_color_sign

@@color_sign:
	mov [is_color_num], 1
	inc si
	jmp @@string_iteration

@@not_color_sign:
	cmp [is_color_num], 1
	jnz @@not_color_num

	call AsciiToColor
	mov [color], al
	mov [is_color_num], 0
	inc si
	jmp @@string_iteration
@@not_color_num:
	push bx
	xor bh, bh
	mov bl, [color]
	int 10h
	pop bx
	inc si
	jmp @@string_iteration

@@return:
	pop cx
	pop si
	pop ax
	ret
endp PrintColoredString

; Converts an hex code to color code dependent on the DOS default palette.
proc AsciiToColor ; al - ascii
	
	cmp al, 'a'
	jl @@number
	sub al, 15h
	jmp @@return
@@number:
	sub al, 30h
	jmp @@return

@@return:
	ret
endp AsciiToColor

; Moves the cursor to the center
proc MoveCursorToCenter ; used in LogicP.asm
	push ax
	push bx
	push dx	


	mov ah, 2h
	xor bh, bh
	mov dh, 10
	mov dl, 9
	int 10h

	pop dx
	pop bx
	pop ax
	ret
endp MoveCursorToCenter