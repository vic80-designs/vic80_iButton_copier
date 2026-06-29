;================================================================
; Всяческие дефайны
;================================================================
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Определяем частоту процессора
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	#define		XTAL							4000000 

	#define		tempreg							r16			; Временный регистр 1
	#define		tempreg1						r17			; Временный регистр 2
	#define		tempreg2						r18			; Временный регистр 3

	#define		flags							r20			; Регистр флагов
	#define		owi_master_read_flag			0			; пора опрашивать 1wire
	#define		ser_no_readed					1			; серийный номер считан
	#define		verify_error					2			; ошибка записи
	#define		blinker_flag					3			; флаг блинкера
	#define		light_off_flag					4			; флаг таймера отключения подсветки
	#define		ButOpros_flag					5			; пора опрашивать кнопку

	#define		mode							r21			; Регистр выбора режима работы
	#define		selection_mode					0			; Режим изменения режима работы
	#define		read_mode						1			; Режим чтения ключа
	#define		write_mode						2			; Режим записи ключа
	#define		edit_mode						3			; Режим редактирования ключа
	#define		edit_half_byte					4			; Режим редктирования конкретного полубайта

	#define		edited_half_byte				r22			; номер редактируемого полубайта (0-15)

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Другие инклюды
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	.include	"LCD_HD44780\Define_LCD_HD44780.asm"
	.include	"Buttons\Define_ButOpros.asm"
	.include	"Buzzer\Define_Buzzer.asm"
	.include	"Blinker\Define_Blinker.asm"
	.include	"OneWire\Define_OneWire.asm"


