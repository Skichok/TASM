.model small
.stack 100h

.data
    prompt db 'Enter a digit: $'        ; Строка для запроса ввода
    result db 'The square is: $'         ; Строка для вывода квадрата числа
    newline db 13, 10, '$'               ; Символы для новой строки (CR, LF)

.code
main:
    ; Инициализация сегмента данных
    mov ax, @data
    mov ds, ax

    ; Печать запроса
    mov ah, 09h
    lea dx, prompt
    int 21h

    ; Считывание символа с клавиатуры
    mov ah, 01h
    int 21h
    sub al, '0'       ; Преобразуем символ в число (от '0' до '9')
    
    ; Вычисление квадрата числа
    mov bl, al        ; Копируем число в BL
    imul bl            ; AL = AL * AL (AL теперь содержит квадрат числа)

    ; Печать строки "The square is:"
    mov ah, 09h
    lea dx, result
    int 21h

    ; Печать квадрата числа
    add al, '0'       ; Преобразуем результат обратно в символ
    mov dl, al        ; Помещаем символ в DL для вывода
    mov ah, 02h       ; Функция вывода символа
    int 21h

    ; Печать новой строки (перенос на новую строку)
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Завершение программы
    mov ah, 4Ch
    int 21h
end main

