;================================================================
; Инициализация  блинкеры
;
; АХТУНГ!!! Файл располагать в сегменте кода, в файле init!!!
;================================================================

blinker_init:
	BLINKER_OFF

	sbi		BLINKER_DDR,BLINKER_CAT
	sbi		BLINKER_DDR,BLINKER_AN

	rcall	blinker_timer_init

	ret

blinker_timer_init:
	ldi		Zh,high(blinker_tmr_init)						; Запускаем таймер считывания 1wire (мастер)
	ldi		Zl,low(blinker_tmr_init)
	rjmp	pc+3
blinker_long_timer_init:
	ldi		Zh,high(blinker_long_tmr_init)					; Запускаем таймер считывания 1wire (мастер)
	ldi		Zl,low(blinker_long_tmr_init)
	sts		blinker_timer,Zl
	sts		blinker_timer+1,Zh
	ret

