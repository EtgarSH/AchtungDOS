CODESEG

proc InitializeColorPage
	mov
	ret
endp InitializeColorPage

proc ShowColorChoosePage
	push ax

	mov ah, 5h
	mov al, 1

	int 10h

	pop ax
	ret
endp ShowColorChoosePage

proc DrawColorSquare ; cx - x, dx - y, al - color
	mov ah, 0ch
	mov bh, 1

	mov 
@@loop:
	int 10h

	

	loop @@loop


	ret
endp DrawColorSquare

proc DrawLine ; dh - x, dl - y, al - color, cl - length
	push ax
	push es

	mov

	pop es
	pop ax
endp DrawLine