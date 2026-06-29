;----------------------------------------------------------------
; –абота с RW1990
;----------------------------------------------------------------

rw1990_write_ser_no:

	ldi		Zl,low(ibutton_ser_no)
	ldi		Zh,high(ibutton_ser_no)

	rcall	owi_master_reset
	OWI_DELAY	75

	brts	pc+2									; ѕереход если 1wire не пуста
	rjmp	one_wire_timer_init						; инициализируем короткий таймер считывани€ (там и выйдем командой ret)
	
	ldi		tempreg,0xD1
	rcall	owi_write_byte

	clc												; нолик на 1wire (разрешаем запись)
	rcall	rw1990_owi_write_bit

	rcall	owi_master_reset
	OWI_DELAY	75

	brts	pc+2									; ѕереход если 1wire не пуста
	rjmp	one_wire_timer_init						; инициализируем короткий таймер считывани€ (там и выйдем командой ret)

	ldi		tempreg,0xD5
	rcall	owi_write_byte

	ldi		tempreg1,8

rw1990_write_ser_no_cycle:

	ld		tempreg,Z+
	com		tempreg
	rcall	rw1990_owi_write_byte
	
	dec		tempreg1
	brne	rw1990_write_ser_no_cycle

	rcall	owi_master_reset
	OWI_DELAY	75

	brts	pc+2									; ѕереход если 1wire не пуста
	rjmp	one_wire_timer_init						; инициализируем короткий таймер считывани€ (там и выйдем командой ret)
	
	ldi		tempreg,0xD1
	rcall	owi_write_byte

	sec												; единичка на 1wire (запрещаем запись)
	rcall	rw1990_owi_write_bit
	
	rcall	verify_ser_no

	ret

rw1990_owi_write_bit:
	rcall	owi_write_bit
	push	tempreg
	OWI_DELAY	200
	OWI_DELAY	200
	OWI_DELAY	200
	OWI_DELAY	200
	OWI_DELAY	200
	OWI_DELAY	200
	OWI_DELAY	200
	OWI_DELAY	200
	OWI_DELAY	200
	OWI_DELAY	200
	pop		tempreg
	ret

rw1990_owi_write_byte:
	push	tempreg1
	ldi		tempreg1,8
rw1990_cycle_owi_write_byte:
	lsr		tempreg
	rcall	rw1990_owi_write_bit
	dec		tempreg1
	brne	rw1990_cycle_owi_write_byte
	OWI_MASTER_OUT
	OWI_MASTER_PULLUP
	pop		tempreg1
	ret
