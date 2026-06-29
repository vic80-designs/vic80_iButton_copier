;++++++++++++++++++++++++++++++++++++++++++++++++++++
; Сегмент данных. Переменные
;++++++++++++++++++++++++++++++++++++++++++++++++++++

	.include	"OneWire\Data_OneWire.asm"
	.include	"LCD_HD44780\Data_LCD_HD44780.asm"
	.include	"Buttons\Data_ButOpros.asm"
	.include	"Blinker\Data_Blinker.asm"

	ibutton_ser_no:					.byte	8		; текущий номер ключа
	ibutton_ser_no_CRC:				.byte	7		; Вычисляемый CRC




