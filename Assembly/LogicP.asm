CODESEG

proc HowManyPlayersInGame
	push ax

	xor al, al ; counter of players

	UpdateRemPlayers al, dot_in_game, dot_name
	UpdateRemPlayers al, dot2_in_game, dot2_name

	mov [remaining_players], al

	pop ax
	ret
endp HowManyPlayersInGame


proc TryEnd ; using HowManyPlayersInGame procedure

	call HowManyPlayersInGame
	cmp [remaining_players], 1
	jnz @@return
	call EndGame
@@return:
	ret
endp TryEnd

proc EndGame
	push ax
	push dx
	push di
@@end_game_creator:

	mov ah, 9
	mov dx, offset winner_msg
	int 21h

	mov di, offset winner
	call PrintColoredString

	push cx
	mov cl, [pressed_key]
@@end_game_loop:
	call ReadKey
	cmp [pressed_key], ENTER_KEY
	jnz @@end_game_loop

	mov [pressed_key], cl
	pop cx
	pop di
	pop dx
	pop ax
	jmp game_creation
endp EndGame

proc PrintColoredString ; di - offset
	push ax
	push bx
	push cx
	push dx
	push si

	mov ah, 0eh

	xor bh, bh

	mov bl, 0eh

	mov si, 0
@@print_loop:
	push di
	add di, si
	mov al, [byte ptr di]
	pop di

	cmp al, '&'
	jnz @@not_color_sign

@@color_sign:
	push si
	push di
	inc si
	add di, si
	mov cl, [byte ptr di]
	sub cl, 30
	pop di
	pop si
	inc si
	jmp @@return_loop
@@not_color_sign:
	int 10h
	inc si

	cmp al, '$'

@@return_loop:
	jnz @@print_loop


	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp PrintColoredString