;================================================================
; ПП обработки шины 1-Wire ЗАПИСЬ (для MASTER режима)
; для работы необходиме временные регистры tempreg, tempreg1
;================================================================

owi_master_write_ser_no:
	cbr		flags,(1<<owi_master_read_flag)
	rcall	one_wire_timer_init

	rcall	owi_master_reset						; проверяем 1-wire
	OWI_DELAY	75

	brts	pc+2									; Переход если 1wire не пуста
	ret												; Здесь выход если 1wire пуста

	rcall	rw1990_write_ser_no						; пробуем записать RW1990
	sbrs	flags,verify_error						; если была ошибка записи, то пробуем записать ТМ2004
	rjmp	write_ok

	rcall	TM2004_write_ser_no						; пробуем записать TM2004
	sbrs	flags,verify_error						; если была ошибка записи, то ошибка записи
	rjmp	write_ok

write_fail:
	rcall	lcd_backlight_on
	BLINKER_RED
	rcall	fail_beep		
	/*rcall	print_write_error*/
	rjmp	exit_owi_master_write_ser_no

exit_owi_master_write_ser_no:
	cbr		flags,(1<<owi_master_read_flag|1<<blinker_flag)
	rcall	one_wire_long_timer_init
	rcall	blinker_long_timer_init

/*	sbrs	flags,owi_master_read_flag
	rjmp	pc-1*/
/*	rcall	print_writing
	rcall	print_ser_no*/

	ret

write_ok:
	rcall	lcd_backlight_on
	BLINKER_GREEN
	rcall	OK_beep
	/*rcall	print_write_OK*/
	rjmp	exit_owi_master_write_ser_no


