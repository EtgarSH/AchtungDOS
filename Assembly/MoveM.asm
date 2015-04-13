CODESEG

macro UpdateDot DOT_X, DOT_Y, DOT_SPEED_X, DOT_SPEED_Y
	push ax

	mov ax, [DOT_X]
	add ax, [DOT_SPEED_X]
	mov [DOT_X], ax

	mov ax, [DOT_Y]
	add ax, [DOT_SPEED_Y]
	mov [DOT_Y], ax

	pop ax
endm UpdateDot

macro PrintDot DOT_X, DOT_Y, COLOR
	push ax
	push bx
	push dx
	push cx

	mov ah, 0ch
	mov al, [COLOR]
	xor bh, bh
	mov cx, [DOT_X]
	mov dx, [DOT_Y]
	int 10h

	pop cx
	pop dx
	pop bx
	pop ax
endm PrintDot

macro ConvertToMovement R_KEY, L_KEY, DOT_SPEED_X, DOT_SPEED_Y
	local @@right_key_pressed
	local @@left_key_pressed
	local @@continue

	cmp [pressed_key], R_KEY
	jz @@right_key_pressed

	cmp [pressed_key], L_KEY
	jz @@left_key_pressed

	jmp @@continue

@@right_key_pressed:
	MoveDotRight DOT_SPEED_X, DOT_SPEED_Y
	jmp @@continue
@@left_key_pressed:
	MoveDotLeft DOT_SPEED_X, DOT_SPEED_Y
	jmp @@continue

@@continue:

endm ConverToMovement

macro MoveDotLeft DOT_SPEED_X, DOT_SPEED_Y
	local @@moving_right
	local @@moving_left
	local @@moving_up
	local @@moving_down
	local @@continue

	cmp [DOT_SPEED_X], 0
	jg @@moving_right
	jl @@moving_left

	cmp [DOT_SPEED_Y], 0
	jg @@moving_down
	jl @@moving_up

@@moving_right:
	mov [DOT_SPEED_X], 0
	mov [DOT_SPEED_Y], -1
	jmp @@continue
@@moving_left:
	mov [DOT_SPEED_X], 0
	mov [DOT_SPEED_Y], 1
	jmp @@continue
@@moving_up:
	mov [DOT_SPEED_X], -1
	mov [DOT_SPEED_Y], 0
	jmp @@continue
@@moving_down:
	mov [DOT_SPEED_X], 1
	mov [DOT_SPEED_Y], 0
	jmp @@continue
@@continue:

endm MoveDotLeft

macro MoveDotRight DOT_SPEED_X, DOT_SPEED_Y
	local @@moving_right
	local @@moving_left
	local @@moving_down
	local @@moving_up
	local @@continue

	cmp [DOT_SPEED_X], 0
	jg @@moving_right
	jl @@moving_left

	cmp [DOT_SPEED_Y], 0
	jg @@moving_down
	jl @@moving_up

@@moving_right:
	mov [DOT_SPEED_X], 0
	mov [DOT_SPEED_Y], 1
	jmp @@continue
@@moving_left:
	mov [DOT_SPEED_X], 0
	mov [DOT_SPEED_Y], -1
	jmp @@continue
@@moving_up:
	mov [DOT_SPEED_X], 1
	mov [DOT_SPEED_Y], 0
	jmp @@continue
@@moving_down:
	mov [DOT_SPEED_X], -1
	mov [DOT_SPEED_Y], 0
	jmp @@continue

@@continue:
endm MoveDotRight

macro CheckLocation DOT_X, DOT_Y
	local @@return

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
	jz @@return

	pop dx
	pop cx
	pop ax
	pop bx
	jmp menu_creation
@@return:
	pop dx
	pop cx
	pop ax
	pop bx
endm CheckLocation

macro Lose DOT_IN_GAME
	mov [DOT_IN_GAME], 0
endm Lose