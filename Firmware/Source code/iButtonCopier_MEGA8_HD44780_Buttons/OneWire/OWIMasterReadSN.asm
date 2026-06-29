;================================================================
; ПП обработки шины 1-Wire (для MASTER режима)
; для работы необходиме временные регистры tempreg, tempreg1
; Работает при частоте процессора: 8 МГЦ
;================================================================
owi_master_read_sn:

	cbr		flags,(1<<owi_master_read_flag)
	rcall	one_wire_timer_init

	rcall	owi_master_reset
	OWI_DELAY	75

	brts	pc+2									; Переход если 1wire не пуста
	ret												; Здесь выход из опроса мастера 1wire

	ldi		tempreg,0x33
	rcall	owi_write_byte

	ldi		Zl,low(ibutton_ser_no)
	ldi		Zh,high(ibutton_ser_no)
	ldi		tempreg2,8

read_sn_cycle:
	rcall	owi_read_byte
	st		Z+,tempreg

	dec		tempreg2
	brne	read_sn_cycle

	rcall	ser_no_CRC_calc

printing_read_result:
	rcall	lcd_backlight_on
	rcall	print_ser_no
	rcall	print_CRC

	lds		tempreg,ibutton_ser_no+7
	lds		tempreg1,ibutton_ser_no_CRC

	cp		tempreg,tempreg1
	breq	pc+5
	
	BLINKER_RED
	rcall	fail_beep
	rjmp	pc+4

	BLINKER_GREEN
	rcall	OK_beep

	cbr		flags,(1<<owi_master_read_flag|1<<blinker_flag)
	rcall	one_wire_long_timer_init
	rcall	blinker_long_timer_init

	sbr		flags,(1<<ser_no_readed)

	ret

