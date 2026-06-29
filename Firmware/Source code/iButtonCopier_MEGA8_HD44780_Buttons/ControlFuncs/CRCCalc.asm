;================================================================
; Вычисления CRC
;================================================================

;----------------------------------------------------------------
; Вычисление CRC серийного номера
;----------------------------------------------------------------
ser_no_CRC_calc:
	
	ldi		Yl,low(ibutton_ser_no)
	ldi		Yh,high(ibutton_ser_no)

	ldi		Zl,low(ibutton_ser_no_CRC)
	ldi		Zh,high(ibutton_ser_no_CRC)

	ldi		tempreg2,7

	ld		tempreg,Y+
	st		Z+,tempreg

	dec		tempreg2
	brne	pc-3

	ldi		tempreg1,56

ser_no_CRC_calc_cycle:

	ldi		Zl,low(ibutton_ser_no_CRC+7)
	ldi		Zh,high(ibutton_ser_no_CRC+7)

	ldi		tempreg2,7
	clc

	ld		tempreg,-Z
	ror		tempreg
	st		Z,tempreg
	dec		tempreg2
	brne	pc-4

	brcc	pc+4

	ldi		tempreg2,0x8C
	eor		tempreg,tempreg2
	st		Z,tempreg

	dec		tempreg1
	brne	ser_no_CRC_calc_cycle

	ret

;----------------------------------------------------------------
; Вычисление CRC команды записи
;----------------------------------------------------------------
/*	sent_cmd_CRC_calc:

	push	tempreg1
	push	Zl
	push	Zh
		
	ldi		tempreg1,32

sent_cmd_CRC_calc_cycle:

	ldi		Zl,low(ibutton_write_cmd+4)
	ldi		Zh,high(ibutton_write_cmd+4)

	ldi		tempreg2,4
	clc

	ld		tempreg,-Z
	ror		tempreg
	st		Z,tempreg
	dec		tempreg2
	brne	pc-4

	brcc	pc+4

	ldi		tempreg2,0x8C
	eor		tempreg,tempreg2
	st		Z,tempreg

	dec		tempreg1
	brne	sent_cmd_CRC_calc_cycle

	pop		Zh
	pop		Zl
	pop		tempreg1

	ret*/
