.code 
;-------------------------------------------------------------------------------------------------------------------------------
Make_Sum proc
; int make_sum(int first_val, int second_val)
; RCX - first_val
; RDX - second_val
; return RAX

	mov eax, ecx
	add eax, edx

	ret

Make_Sum endp
;-------------------------------------------------------------------------------------------------------------------------------

Get_Pos_Address proc
; RCX - screen_buffer
; RDX - pos
; return RDI

; 1. Calculate output address: address_offset = (pos.Y_Pos * pos.Screen_Width + pox.X_Pos) * 4

; 1.1. Calculate pos.Y * pos.Screen_Width
	mov rax, rdx
	shr rax, 16    ; AX = pos.Y_Pos
	movzx rax, ax  ; RAX = AX == pos.Y_pos

	mov rbx, rdx
	shr rbx, 32    ; BX = pos.Screen_Width
	movzx rbx, bx  ; RBX = BX == pos.Screen_Width

	imul rax, rbx  ; RAX = RAX * RBX == pos.Y_Pos * pos.Screen_Width

; 1.2. Add pos.X to RAX
	movzx rbx, dx  ; RBX = DX = pos.X_Pos
	add rax, rbx   ; RAX = pos.Y_Pos * pos.Screen_Width + pos.X_Pos

; 1.3. RAX contains shift start of the string in bytes, but we need in bytes. 
; Hence each symbol has 4 bytes, we need to multiply this shift on 4.
	shl rax, 2     ; RAX = RAX * 4 = address_offset

	mov rdi, rcx   ; RDI = screen_buffer
	add rdi, rax   ; RDI = screen_buffer + address_offset

	ret

Get_Pos_Address endp
;-------------------------------------------------------------------------------------------------------------------------------

Draw_Line_Horizontal proc
; void Draw_Line_Horizontal(CHAR_INFO* screen_buffer, SPos pos, CHAR_INFO symbol)
; RCX - screen_buffer
; RDX - pos
; R8 - symbol
; return RAX
	
	push rax
	push rbx
	push rcx
	push rdi

; 1. Calculate output address
	call Get_Pos_Address  ; RDI = symbol position in buffer_screen in position "pos"

; 2. Output symbols 
	mov eax, r8d
	mov rcx, rdx
	shr rcx, 48    ; RCX = CX = pos.Len

	rep stosd

	pop rdi
	pop rcx
	pop rbx
	pop rax

	ret

Draw_Line_Horizontal endp
;-------------------------------------------------------------------------------------------------------------------------------

Show_Colors proc
; void Show_Colors(CHAR_INFO * screen_buffer, SPos pos, CHAR_INFO symbol);
; RCX - screen_buffer
; RDX - pos
; R8 - symbol
; return RAX

; 1. Calculate output address
	call Get_Pos_Address  ; RDI = symbol position in buffer_screen in position "pos"
	
	mov rax, r8

	stosd

	ret

Show_Colors endp
;-------------------------------------------------------------------------------------------------------------------------------
end
