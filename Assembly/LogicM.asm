CODESEG

macro CheckLocation DOT_X, DOT_Y, DOT_IN_GAME
	local @@return
	local @@lose

	push bx
	push ax
	push cx
	push dx

	mov cx, [DOT_X]
	mov dx, [DOT_Y]

	mov ah, 0dh
	xor bh, bh
	int 10h

	cmp al, 0
	jnz @@lose
	jmp @@return

@@lose:
	pop dx
	pop cx
	pop ax
	pop bx
	mov [DOT_IN_GAME], 0
;	jmp menu_creation

@@return:
	pop dx
	pop cx
	pop ax
	pop bx
endm CheckLocation

; Updating the remaining players counter by a player. Used in HowManyPlayersInGame.
macro UpdateRemPlayers COUNTER, DOT_IN_GAME, DOT_NAME
	local @@return

	cmp [DOT_IN_GAME], 1
	jnz @@return
	inc COUNTER
	SetWinner DOT_NAME
@@return:

endm UpdateRemPlayers

macro SetWinner DOT_NAME
	local @@CopyLoop

	push si
	push di
	push cx
	push dx

	mov si, offset DOT_NAME
	mov di, offset winner

	mov cx, 20
@@CopyLoop:
	mov dl, [byte ptr si]
	mov [byte ptr di], dl
	inc si
	inc di

	loop @@CopyLoop

	pop dx
	pop cx
	pop di
	pop si
endm SetWinner