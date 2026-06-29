;================================================================
; Файл инициализации для библиотеки опроса кнопки
; 
; АХТУНГ!!! Файл располагать в сегменте кода, в файле инит!!!
;================================================================

one_wire_init:
	
	OWI_MASTER_IN												; OWI - на вход
	OWI_MASTER_PULLUP											; Ставим подтяжку	
	
	rcall	one_wire_timer_init

	ret

one_wire_timer_init:
	ldi		Zh,high(owi_master_read_tmr_init)			; Запускаем таймер считывания 1wire (мастер)
	ldi		Zl,low(owi_master_read_tmr_init)
	rjmp	pc+3
one_wire_long_timer_init:
	ldi		Zh,high(owi_master_read_long_tmr_init)			; Запускаем таймер считывания 1wire (мастер)
	ldi		Zl,low(owi_master_read_long_tmr_init)
	sts		owi_master_read_timer,Zl
	sts		owi_master_read_timer+1,Zh
	ret
