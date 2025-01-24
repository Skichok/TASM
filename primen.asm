.model small
.stack 100h

.data
n dw 10                 ; Количество простых чисел для вывода
primes dw 100 dup(?)    ; Массив для хранения простых чисел
msg db "Prime numbers:", 13, 10, '$'
num_str db 6 dup(0), '$'

.code
main proc
    mov ax, @data       ; Инициализация сегмента данных
    mov ds, ax

    mov cx, n           ; Количество простых чисел
    lea di, primes      ; Указатель на массив простых чисел
    mov bx, 2           ; Начальное число для проверки

find_primes:
    push cx             ; Сохраняем значение cx
    mov ax, bx          ; Текущее число для проверки
    call is_prime       ; Проверка, является ли число простым
    cmp ax, 1
    jne not_prime       ; Если не простое, переход
    mov [di], bx        ; Сохраняем простое число в массив
    add di, 2           ; Смещение для следующего числа
    loop find_primes    ; Уменьшаем cx и повторяем

not_prime:
    pop cx              ; Восстанавливаем cx
    inc bx              ; Переходим к следующему числу
    jmp find_primes

print_primes:
    mov ah, 09h         ; Вывод строки
    lea dx, msg
    int 21h

    lea si, primes      ; Указатель на массив простых чисел
    mov cx, n           ; Количество чисел для вывода

print_loop:
    mov ax, [si]        ; Загружаем следующее число
    call print_number   ; Выводим число
    lea dx, num_str     ; Вывод строки
    mov ah, 09h
    int 21h

    add si, 2           ; Переход к следующему числу
    loop print_loop

    mov ah, 4Ch         ; Завершение программы
    int 21h

; Функция проверки простого числа
; Вход: AX - число для проверки
; Выход: AX = 1, если число простое; AX = 0, если не простое
is_prime proc
    cmp ax, 2
    jl not_prime_num
    cmp ax, 2
    je prime_num

    mov cx, 2           ; Делитель
    mov dx, 0           ; Результат деления

check_loop:
    mov bx, cx
    div bx              ; Деление AX на CX
    cmp dx, 0           ; Если остаток равен 0
    je not_prime_num
    inc cx              ; Переход к следующему делителю
    cmp cx, ax          ; Если CX >= AX, завершить проверку
    jl check_loop

prime_num:
    mov ax, 1           ; Простое число
    ret

not_prime_num:
    mov ax, 0           ; Не простое число
    ret
is_prime endp

; Функция для вывода числа в строковом формате
; Вход: AX - число для вывода
print_number proc
    lea di, num_str+5   ; Указатель на конец строки
    mov cx, 0           ; Счётчик цифр

convert_loop:
    xor dx, dx          ; Очистка DX
    div bx              ; Деление на 10
    add dl, '0'         ; Преобразование цифры в ASCII
    dec di
    mov [di], dl
    inc cx
    test ax, ax         ; Если AX = 0, выход
    jnz convert_loop

    lea dx, num_str+6   ; Указатель на строку числа
    sub dx, cx          ; Корректировка указателя
    ret
print_number endp

main endp
end main

