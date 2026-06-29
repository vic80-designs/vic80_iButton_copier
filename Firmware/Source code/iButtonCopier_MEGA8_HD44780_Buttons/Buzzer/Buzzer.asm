;================================================================
; Библиотека пищалки (со встроенным генератором)
;
; АХТУНГ!!! Файл располагать в сегменте кода, после файла с дефайнами!!!
;================================================================

OK_beep:
	BUZZER_ON
	rcall	buzzer_250ms_delay
	BUZZER_OFF
	ret

fail_beep:
	ldi		tempreg1,5
	BUZZER_ON
	rcall	buzzer_75ms_delay
	BUZZER_OFF
	rcall	buzzer_75ms_delay
	dec		tempreg1
	brne	pc-5
	ret

;================================================================
; Формирование выдержек времени для пищалки
;================================================================
buzzer_250ms_delay:
	ldi		tempreg,25
	rcall	buzzer_10ms_delay
	dec		tempreg
	brne	pc-2
	ret

buzzer_75ms_delay:
	ldi		tempreg,8
	rcall	buzzer_10ms_delay
	dec		tempreg
	brne	pc-2
	ret

buzzer_10ms_delay:											// Выдержка 10 мс	
	ldi		Xh,high(XTAL/417)
	ldi		Xl,low(XTAL/417)
	sbiw	X,1
	brne	pc-1
	ret
