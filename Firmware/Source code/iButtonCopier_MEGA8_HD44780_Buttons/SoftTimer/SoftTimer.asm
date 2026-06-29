;================================================================
; ПП софт-таймера
; для работы необходим временный регистр Z
; !!!!!!! В дефайнах задать XTAL (напр. #define XTAL 4000000)
; также включить прерывания и назначить в таблице векторов прерываний переход
; на данную ПП по прерыванию OCR1addr
;================================================================
Soft_timer:
	push	Zl
	push	Zh
	in		Zl,SREG
	push	Zl

;+++++++++++++++++++++++++++++++++++++++++++++++++++
; Таймер одноразовый (срабатывает один раз, и поднимает флаг. Не цикличный)
; До 65535/20 мс
; Таймер отключения подсветки
;+++++++++++++++++++++++++++++++++++++++++++++++++++

	lds		Zh,light_off_timer+1
	lds		Zl,light_off_timer
	push	Zh
	or		Zh,Zl
	pop		Zh

	breq	pc+4								; переход на следующий таймер

	sbiw	Z,1

	brne	pc+2								; переход на сохранение таймера
	sbr		flags,(1<<light_off_flag)

	sts		light_off_timer,Zl					; сохранение таймера
	sts		light_off_timer+1,Zh
	
;+++++++++++++++++++++++++++++++++++++++++++++++++++
; Циклический таймер до 255 мс.
; По окончании поднимает флаг
; Таймер опроса кнопок
;+++++++++++++++++++++++++++++++++++++++++++++++++++

	lds		Zl,ButOpros_timer
	dec		Zl
	brne	pc+3							; переход на сохранение таймера

	sbr		flags,(1<<ButOpros_flag)
	ldi		Zl,ButOpros_tmr_init

	sts		ButOpros_timer,Zl

;+++++++++++++++++++++++++++++++++++++++++++++++++++
; Таймер одноразовый (срабатывает один раз, и поднимает флаг. Не цикличный)
; До 65535 мс
; Таймер долгого нажатия кнопки
;+++++++++++++++++++++++++++++++++++++++++++++++++++

	lds		Zh,Autorepeat_timer+1
	lds		Zl,Autorepeat_timer
	push	Zh
	or		Zh,Zl
	pop		Zh

	breq	pc+4								; переход на следующий таймер

	sbiw	Z,1

	brne	pc+2								; переход на сохранение таймера
	sbr		buttons,(1<<end_autorepeat)

	sts		Autorepeat_timer,Zl					; сохранение таймера
	sts		Autorepeat_timer+1,Zh

;+++++++++++++++++++++++++++++++++++++++++++++++++++
; Таймер одноразовый (срабатывает один раз, и поднимает флаг. Не цикличный)
; До 65535 мс
; Таймер долгого опроса 1-wire
;+++++++++++++++++++++++++++++++++++++++++++++++++++
	lds		Zh,owi_master_read_timer+1
	lds		Zl,owi_master_read_timer
	push	Zh
	or		Zh,Zl
	pop		Zh

	breq	pc+4								; переход на следующий таймер

	sbiw	Z,1

	brne	pc+2								; переход на сохранение таймера
	sbr		flags,(1<<owi_master_read_flag)

	sts		owi_master_read_timer,Zl					; сохранение таймера
	sts		owi_master_read_timer+1,Zh







	lds		Zh,blinker_timer+1
	lds		Zl,blinker_timer

	sbiw	Z,1
	brne	pc+4

	sbr		flags,(1<<blinker_flag)
	ldi		Zh,high(1000)
	ldi		Zl,low(1000)

	sts		blinker_timer,Zl
	sts		blinker_timer+1,Zh





	pop		Zl
	out		SREG,Zl
	pop		Zh
	pop		Zl

	reti
