section .data
    msg db 'Guess a number between 1 and 100: ', 0
    correct_msg db 'Correct! The number was: ', 0
    wrong_msg db 'Try again!', 0
    number db 0
    guess db 0

section .text
    global _start

_start:
    ; Initialize random number
    mov ax, 0
    int 1Ah
    mov dx, [0x0040:0x001A] ; Get system time
    mov [number], dl ; Store random number

    ; Main game loop
game_loop:
    ; Print message
    mov ah, 09h
    lea dx, msg
    int 21h

    ; Read user input
    mov ah, 01h
    int 21h
    sub al, '0' ; Convert ASCII to number
    mov [guess], al

    ; Compare guess with number
    cmp [guess], [number]
    je correct
    jg wrong

wrong:
    ; Print wrong message
    mov ah, 09h
    lea dx, wrong_msg
    int 21h
    jmp game_loop

correct:
    ; Print correct message
    mov ah, 09h
    lea dx, correct_msg
    int 21h
    mov al, [number]
    add al, '0' ; Convert number to ASCII
    mov ah, 02h
    int 21h

    ; Exit program
    mov ax, 4C00h
    int 21h

