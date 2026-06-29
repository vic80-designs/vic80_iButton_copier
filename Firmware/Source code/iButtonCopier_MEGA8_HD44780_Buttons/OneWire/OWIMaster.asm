;================================================================
; ПП обработки шины 1-Wire
; для работы необходиме временные регистры tempreg, tempreg1
; регистр флагов flags
; и обозначить в регистре флагов - owi_bit
; все процедуры влияют на бит Т
; Работает при частоте процессора:2,4,8,10,12,16 МГЦ
; !!!!!!! В дефайнах задать XTAL (напр. #define XTAL 4000000)
;================================================================
owi_master_reset:
	cli
	set										; устанавливаем бит Т (если после ресета установлен - значит есть ответ по 1wire, иначе на шине пусто)

	OWI_MASTER_OUT
	OWI_MASTER_PULLDWN
	OWI_DELAY	110
	OWI_MASTER_IN
	OWI_DELAY	20
	sbic	OWI_PIN,OWI_MASTER_BUS
	clt										; что то есть на шине
	
	sei

	ret


;================================================================
; Чтение бита с шины 1-wire
;================================================================
owi_read_bit:
	cli
	
	push	tempreg
	OWI_MASTER_OUT
	OWI_MASTER_PULLDWN
	OWI_DELAY	1
	OWI_MASTER_IN
	OWI_MASTER_PULLUP
	OWI_DELAY	2
	clc
	sbic	OWI_PIN,OWI_MASTER_BUS
	sec
	OWI_DELAY	10
	pop		tempreg
	
	sei
	ret

;================================================================
; Чтение байта с шины 1-wire (на выходе - байт
; в регистре tempreg)
;================================================================
owi_read_byte:
	push	tempreg1
	clr		tempreg
	ldi		tempreg1,8
cycle_owi_read_byte:
	rcall	owi_read_bit
	ror		tempreg
	dec		tempreg1
	brne	cycle_owi_read_byte
	OWI_MASTER_OUT
	OWI_MASTER_PULLUP
	pop		tempreg1
	ret

;================================================================
; Запись бита на шину 1-wire
;================================================================
owi_write_bit:
	cli

	push	tempreg
	OWI_MASTER_OUT
	OWI_MASTER_PULLDWN
	OWI_DELAY	2
	brcc	pc+2
	OWI_MASTER_PULLUP
	OWI_DELAY	12
	OWI_MASTER_PULLUP
	OWI_DELAY	2
	pop		tempreg

	sei
	ret

;================================================================
; Запись байта на шину 1-wire (на входе - байт
; в регистре tempreg)
;================================================================
owi_write_byte:
	push	tempreg1
	ldi		tempreg1,8
cycle_owi_write_byte:
	lsr		tempreg
	rcall	owi_write_bit
	dec		tempreg1
	brne	cycle_owi_write_byte
	OWI_MASTER_OUT
	OWI_MASTER_PULLUP
	pop		tempreg1
	ret

	owi_delay_cycle:
#if		XTAL==2000000
	ret
#else
	push	tempreg1
	#if		XTAL==4000000
		ldi		tempreg1,2
	#endif
	#if		XTAL==8000000
		ldi		tempreg1,8
	#endif
	#if		XTAL==10000000
		ldi		tempreg1,12
	#endif
	#if		XTAL==12000000
		ldi		tempreg1,15
	#endif
	#if		XTAL==16000000
		ldi		tempreg1,22
	#endif
#endif
wait_delay:
	dec		tempreg1
	brne	wait_delay
	pop		tempreg1
	ret
