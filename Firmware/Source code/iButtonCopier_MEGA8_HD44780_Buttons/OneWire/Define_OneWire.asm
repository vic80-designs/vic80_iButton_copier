;================================================================
; Дефайны для библиотеки OneWire
; 
; АХТУНГ!!! Файл располагать в сегменте кода, в файле дефайнов!!!
;================================================================

	#define		OWI_PORT							PORTB
	#define		OWI_PIN								PINB
	#define		OWI_DDR								DDRB
	#define		OWI_MASTER_BUS						1			; номер шины OWI (SLAVE)
	#define		owi_bus_reg							r10

	#define		owi_master_read_tmr_init			10			; частота посылания reseta по 1wire
	#define		owi_master_read_long_tmr_init		3000		; частота посылания reseta по 1wire (после считывания)

;----------------------------------------------------------------
; Макрокоманды 1-Wire
;----------------------------------------------------------------
.MACRO		OWI_MASTER_OUT
	sbi		OWI_DDR,OWI_MASTER_BUS
.ENDM
.MACRO		OWI_MASTER_IN
	cbi		OWI_DDR,OWI_MASTER_BUS
.ENDM
.MACRO		OWI_MASTER_PULLUP
	sbi		OWI_PORT,OWI_MASTER_BUS
.ENDM
.MACRO		OWI_MASTER_PULLDWN
	cbi		OWI_PORT,OWI_MASTER_BUS
.ENDM

.MACRO		OWI_DELAY
	ldi		tempreg,@0
cont_delay:
	rcall	owi_delay_cycle
	dec		tempreg
	brne	cont_delay
.ENDM

