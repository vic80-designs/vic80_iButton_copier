;================================================================
; Дефайны для библиотеки опроса кнопки
; 
; АХТУНГ!!! Файл располагать в сегменте кода, в файле дефайнов!!!
;================================================================

	#define		buttons				r23
	#define		but_up_pr			0
	#define		but_dwn_pr			1
	#define		but_enter_pr		2
	#define		long_autorepeat		3
	#define		end_autorepeat		4

	#define		BUT_PORT		PORTC
	#define		BUT_PIN			PINC
	#define		BUT_DDR			DDRC
	#define		BUT_UP			4
	#define		BUT_DWN			3
	#define		BUT_ENTER		5

	#define		ButOpros_tmr_init			20
	#define		long_autorepeat_time		1000
	#define		short_autorepeat_time		200

	