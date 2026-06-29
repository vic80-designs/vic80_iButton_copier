;================================================================
; Печать серийного номера ключа
;================================================================

print_ser_no:

	LCD_set_cursor	1,0

	ldi		Zl,low(ibutton_ser_no+8)
	ldi		Zh,high(ibutton_ser_no+8)

print_ser_no_light:
	ldi		tempreg2,8

cycle_print_ser_no:
	ld		tempreg,-Z
	rcall	print_byte
	dec		tempreg2
	brne	cycle_print_ser_no

	ret


;----------------------------------------------------------------
; печать байта в hex формате (на входе в tempreg - байт)
;----------------------------------------------------------------
print_byte:
	push	tempreg

	swap	tempreg
	cbr		tempreg,0xF0

	rcall	print_half_byte
	
	pop		tempreg
	cbr		tempreg,0xF0
	
	rcall	print_half_byte

	ret

print_half_byte:
	subi	tempreg,(-0x30)
	cpi		tempreg,0x3A
	brlo	pc+2
	subi	tempreg,(-0x7)

	SetRS							// передаем данные
	rcall	lcd_write_byte
	ret
