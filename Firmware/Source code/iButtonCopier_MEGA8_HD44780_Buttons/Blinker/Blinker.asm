;================================================================
; Библиотека пищалки (со встроенным генератором)
;
; АХТУНГ!!! Файл располагать в сегменте кода, после файла с дефайнами!!!
;================================================================

blinker_blink:
	cbr		flags,(1<<blinker_flag)
	
	BLINKER_RED
	rcall	blinker_100ms_delay
	BLINKER_GREEN
	rcall	blinker_100ms_delay
	BLINKER_OFF

	ret

;================================================================
; Формирование выдержек времени для блинкера
;================================================================

blinker_100ms_delay:
	ldi		tempreg,10
	rcall	blinker_10ms_delay
	dec		tempreg
	brne	pc-2
	ret

blinker_10ms_delay:											// Выдержка 10 мс	
	ldi		Xh,high(XTAL/400)
	ldi		Xl,low(XTAL/400)
	sbiw	X,1
	brne	pc-1
	ret
