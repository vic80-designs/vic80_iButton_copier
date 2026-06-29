;================================================================
; Всякие сообщения
;================================================================

;----------------------------------------------------------------
; печать слова "Чтение"
;----------------------------------------------------------------
print_reading:
	LCD_PrintStringFlash	string_reading

	LCD_RusSymbToCGRAM 0,12								// Ч
	LCD_RusSymbToCGRAM 1,10								// т
	LCD_RusSymbToCGRAM 2,7								// н
	LCD_RusSymbToCGRAM 3,5								// и

	ret

string_reading:
	.db		6,\
			0,1,'e',2,3,'e',0x00

;----------------------------------------------------------------
; печать слова "Запись"
;----------------------------------------------------------------
print_writing:
	LCD_PrintStringFlash	string_writing	
	LCD_RusSymbToCGRAM 0,3								// З
	LCD_RusSymbToCGRAM 1,9								// п
	LCD_RusSymbToCGRAM 2,5								// и
	LCD_RusSymbToCGRAM 3,14								// ь	

	ret

string_writing:
	.db		6,\
			0,'a',1,2,'c',3,0x00

;----------------------------------------------------------------
; печать слова "Ошибка"	(печатать только после печатания "Запись")
;----------------------------------------------------------------
print_error:

	LCD_PrintStringFlash	string_error	
	
	LCD_RusSymbToCGRAM 4,13								// ш
	LCD_RusSymbToCGRAM 5,0								// б
	LCD_RusSymbToCGRAM 6,6								// к
	LCD_RusSymbToCGRAM 7,4								// з

	ret

string_error:
	.db		13,\
			'O',4,2,5,6,'a',' ',7,'a',1,2,'c',2

;----------------------------------------------------------------
; печать сообщения "Пусто"	(печатать только после печатания "Запись")
;----------------------------------------------------------------
print_empty:

	LCD_PrintStringFlash	string_empty	
	
	LCD_RusSymbToCGRAM 4,8								// П
	LCD_RusSymbToCGRAM 5,10								// т

	ret

string_empty:
	.db		5,\
			4,'y','c',5,'o'

;----------------------------------------------------------------
; печать слова "Редактирование"
;----------------------------------------------------------------
print_editing:
	LCD_PrintStringFlash	string_editing
	LCD_RusSymbToCGRAM 0,2								// д
	LCD_RusSymbToCGRAM 1,6								// к
	LCD_RusSymbToCGRAM 2,10								// т
	LCD_RusSymbToCGRAM 3,5								// и
	LCD_RusSymbToCGRAM 4,1								// в
	LCD_RusSymbToCGRAM 5,7								// н

	ret

string_editing:
	.db		14,\
			'P','e',8,'a',1,2,3,'p','o',4,'a',5,3,'e',0x00

;----------------------------------------------------------------
; печать символов "<>"
;----------------------------------------------------------------
print_select_symbols:

	LCD_set_cursor	0,0
	LCD_put_symb	'<'
	LCD_set_cursor	0,15
	LCD_put_symb	'>'

	ret

;----------------------------------------------------------------
; Очистка строки
;----------------------------------------------------------------
clear_row:
	LCD_PrintStringFlash	string_clear_row
	ret

string_clear_row:
	.db		16,\
			' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',0x00


;----------------------------------------------------------------
; печать "CRC:"
;----------------------------------------------------------------
print_CRC:

	LCD_set_cursor	0,8
	LCD_PrintStringFlash	string_crc
	
	LCD_set_cursor	0,13	
	lds		tempreg,ibutton_ser_no_CRC
	rcall	print_byte

	ret

string_crc:
	.db		8,\
			'(','C','R','C',':',' ',' ',')',0x00
