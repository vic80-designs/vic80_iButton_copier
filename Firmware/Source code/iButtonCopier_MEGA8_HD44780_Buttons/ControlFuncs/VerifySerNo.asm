;================================================================
; ПП проверки записанного номера
;================================================================

verify_ser_no:

	cbr		flags,(1<<verify_error)					; очищаем флаг ошибки записи
	
	rcall	owi_master_reset
	OWI_DELAY	75

	brts	pc+2									; Переход если 1wire не пуста
	ret												; Здесь выход из опроса мастера 1wire

	ldi		tempreg,0x33
	rcall	owi_write_byte

	ldi		Zl,low(ibutton_ser_no)
	ldi		Zh,high(ibutton_ser_no)
	ldi		tempreg2,8

verifing_sn_cycle:
	rcall	owi_read_byte
	ld		tempreg1,Z+

	cp		tempreg,tempreg1
	brne	verification_fail

	dec		tempreg2
	brne	verifing_sn_cycle

	ret

verification_fail:
	sbr		flags,(1<<verify_error)					; устанавливаем флаг ошибки записи
	ret


