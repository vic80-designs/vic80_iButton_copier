;----------------------------------------------------------------
; Работа с ТМ2004
;----------------------------------------------------------------

TM2004_write_ser_no:

	ldi		Zl,low(ibutton_ser_no)
	ldi		Zh,high(ibutton_ser_no)

	clr		tempreg1

TM2004_write_ser_no_cycle:

	rcall	owi_master_reset
	OWI_DELAY	75

	brts	pc+2									; Переход если 1wire не пуста
	rjmp	one_wire_timer_init						; инициализируем короткий таймер считывания (там и выйдем командой ret)

	ldi		tempreg,0x3C
	rcall	owi_write_byte

	mov		tempreg,tempreg1
	rcall	owi_write_byte
	
	clr		tempreg
	rcall	owi_write_byte

	ld		tempreg,Z+
	rcall	owi_write_byte

	rcall	owi_read_byte

	rcall	send_prog_impulse
	rcall	owi_read_byte

	inc		tempreg1

	cpi		tempreg1,8
	brne	TM2004_write_ser_no_cycle

	rcall	verify_ser_no
	
	ret

send_prog_impulse:

	OWI_MASTER_PULLUP
	OWI_MASTER_OUT
	OWI_DELAY	120	
	OWI_MASTER_PULLDWN
	OWI_DELAY	1
	OWI_MASTER_PULLUP

	push	tempreg1
	ldi		tempreg1,41
prog_imp_delay:
	OWI_DELAY	255
	dec		tempreg1
	brne	prog_imp_delay
	pop		tempreg1

	ret

