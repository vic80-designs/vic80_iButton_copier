;================================================================
; Дефайны для библиотеки блинкера
; 
; АХТУНГ!!! Файл располагать в сегменте кода, в файле дефайнов!!!
;================================================================

	#define		BLINKER_DDR			DDRB
	#define		BLINKER_PORT		PORTB
	
	#define		BLINKER_CAT			2
	#define		BLINKER_AN			3
	
	#define		blinker_tmr_init					1000			; частота моргания блинкера
	#define		blinker_long_tmr_init				3000			; частота моргания блинкера (после считывания)
;----------------------------------------------------------------
; Макрокоманды пищалки
;----------------------------------------------------------------
.MACRO		BLINKER_OFF
	cbi		BLINKER_PORT,BLINKER_CAT
	cbi		BLINKER_PORT,BLINKER_AN
.ENDM

.macro		BLINKER_RED
	sbi		BLINKER_PORT,BLINKER_CAT
	cbi		BLINKER_PORT,BLINKER_AN
.endm

.macro		BLINKER_GREEN
	cbi		BLINKER_PORT,BLINKER_CAT
	sbi		BLINKER_PORT,BLINKER_AN
.endm
