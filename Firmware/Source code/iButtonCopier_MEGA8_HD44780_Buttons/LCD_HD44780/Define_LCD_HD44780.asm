;================================================================
; Дефайны для библиотеки экрана на HD44780
; 
; АХТУНГ!!! Файл располагать в сегменте кода, в файле дефайнов!!!
;================================================================

	#define		USE_LIGHT								// используем управление подсветкой

	#define		USE_RUS_SYMB							// используем таблицу русских символов

	#define		light_off_tmr_init			10000		// инициализация таймера отключения подсветки

// Определим порты связи:
// Порт обмена данными с LCD контроллером
	#define		LCD_DATA_PORT				PORTD       // передача
	#define		LCD_DATA_DDR				DDRD        // направление

	#define		D4							4
	#define		D5							3
	#define		D6							2
	#define		D7							1

// Определим линию включения/выключения подсветки (если используется)
	#define		LCD_LIGHT_PORT				PORTD       // порт (выход)
	#define		LCD_LIGHT_DDR				DDRD
	#define		LIGHT_BIT					0			// маска бита
// Определим линию команд/данных (R/S)
	#define		LCD_RS_PORT					PORTD       // порт (выход)
	#define		LCD_RS_DDR					DDRD
	#define		RS_BIT						7			// маска бита
// Определим линию синхронизации (E)
	#define		LCD_E_PORT					PORTD       // порт (выход)
	#define		LCD_E_DDR					DDRD
	#define		E_BIT						5			// маска бита


// Типы курсоров для отображения
	#define		LCD_cur_blink				1			// мигающий курсор
	#define		LCD_cur_underl				2			// курсор черта


;================================================================
; Макрокоманды
;================================================================

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Управление светом
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
.macro	LightOn								// включение света
	sbi		LCD_LIGHT_PORT,LIGHT_BIT
.endm
	
.macro	LightOff							// выключение света
	cbi		LCD_LIGHT_PORT,LIGHT_BIT
.endm

.macro	LightSwitch							// переключение света
	sbis	LCD_LIGHT_PORT,LIGHT_BIT
	rjmp	LCD_TURN_LIGHT_ON
	cbi		LCD_LIGHT_PORT,LIGHT_BIT
	rjmp	END_LightSwitch
LCD_TURN_LIGHT_ON:
	sbi		LCD_LIGHT_PORT,LIGHT_BIT
END_LightSwitch:
.endm

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Команды
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
.macro		SetRS
	sbi		LCD_RS_PORT,RS_BIT
.endm

.macro		ClearRS
	cbi		LCD_RS_PORT,RS_BIT
.endm

.macro		SetE
	sbi		LCD_E_PORT,E_BIT
.endm

.macro		ClearE
	cbi		LCD_E_PORT,E_BIT
.endm

.macro		LCD_Delay
	nop
	nop
	nop
	nop
.endm

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Данные
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
.macro		DataPullUp
	in		tempreg,LCD_DATA_PORT
	sbr		tempreg,(1<<D4|1<<D5|1<<D6|1<<D7)
	out		LCD_DATA_PORT,tempreg
.endm

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Передача данных
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
.macro		LCD_CommandStringFlash
	ldi		Zl,low(@0*2)
	ldi		Zh,high(@0*2)
	lpm		tempreg2,Z+
	
	ClearRS			
	rcall	flash_to_lcd
.endm

/*.macro		LCD_CommandStringSRAM
	ClearRS
	ldi		Zl,low(@0)
	ldi		Zh,high(@0)
	rcall	RAM_to_lcd
.endm*/

/*.macro		LCD_PrintStringSRAM
	SetRS
	ldi		Zl,low(@0)
	ldi		Zh,high(@0)
	rcall	RAM_to_lcd
.endm*/

.macro		LCD_PrintStringFlash
	ldi		Zl,low(@0*2)
	ldi		Zh,high(@0*2)
	lpm		tempreg2,Z+
	
	SetRS	
	rcall	flash_to_lcd
.endm

/*.macro		LCD_PutSymbToCGRAM			// Символ в CG_RAM. На входе @0 - куда (адрес CG_RAM 0-8),
	ldi		tempreg,(0x40+@0*8)			//  @1 - адрес начала таблицы
	ClearRS								// передаем команду
	rcall	lcd_write_byte		
	ldi		Zl,low(@1*2)
	ldi		Zh,high(@1*2)
	ldi		tempreg1,8
	SetRS								// передаем данные
	rcall	flash_to_CG_RAM_lcd
.endm*/


#ifdef		USE_RUS_SYMB
.macro		LCD_RusSymbToCGRAM			// Символ из таблицы русских символов в CG_RAM. На входе @0 - куда (адрес CG_RAM 0-8),
	ldi		tempreg,(0x40+@0*8)			//  @1 - номер символа из таблицы русских символов
	ClearRS								// передаем команду
	rcall	lcd_write_byte		
	ldi		Zl,low(Rus_Symb_Table*2+@1*8)
	ldi		Zh,high(Rus_Symb_Table*2+@1*8)
	ldi		tempreg2,8
	SetRS								// передаем данные
	rcall	flash_to_CG_RAM_lcd
.endm
#endif


.macro		LCD_put_symb
	ldi		tempreg,@0
	SetRS							// передаем данные
	rcall	lcd_write_byte
.endm

.macro		LCD_command
	ldi		tempreg,@0
	ClearRS							// передаем данные
	rcall	lcd_write_byte
.endm

.macro		LCD_command_high_nibble
	ldi		tempreg,@0
	ClearRS							// передаем данные
	rcall	lcd_write_high_nibble
.endm

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Команды управления LCD
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
.macro		LCD_cls					// Очистка LCD курсор на позицию 0;0
	ClearRS							// Передаем команду
	ldi		tempreg,0x01
	rcall	lcd_write_byte
	rcall	LCD_1ms_delay
.endm

.macro		LCD_cursor_off			// Выключение курсора
	ClearRS							// Передаем команду
	ldi		tempreg,0x0C			// изображение вкл, - курсоры отключены
	rcall	lcd_write_byte
.endm

.macro		LCD_cursor_on			// Выключение курсора
	ClearRS							// Передаем команду
	ldi		tempreg,@0
	ori		tempreg,0x0C
	rcall	lcd_write_byte
.endm

.macro		LCD_set_cursor			// установка курсора на позицию
	ldi		tempreg1,@0				// строка
	ldi		tempreg,@1				// столбец
	rcall	lcd_set_cur
.endm
