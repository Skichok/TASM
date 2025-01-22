.model small
.stack 100h

.data
    prompt db 'Enter a number between 1 and 100 (or press Q to quit): $'
    win_msg db 'Congratulations, you guessed it!$'
    too_low_msg db 'Your number is too low. Try again.$'
    too_high_msg db 'Your number is too high. Try again.$'
    quit_msg db 'You chose to quit the game. Goodbye!$'
    number dw 50    ; The number to guess (stored as word)
    user_input_buf db 5, 0, 5 dup(' ')   ; A buffer for storing user input (max 5 digits)

.code
main:
    mov ax, @data
    mov ds, ax          ; Initialize the data segment

game_loop:
    ; Display prompt
    mov ah, 09h
    lea dx, prompt
    int 21h

    ; Read user input (multiple digits)
    lea di, user_input_buf
    mov ah, 0Ah         ; DOS interrupt to read a string
    int 21h

    ; Check if the user pressed 'Q' or 'q'
    lea si, user_input_buf + 2    ; Skip the first 2 bytes (buffer size info)
    lodsb                  ; Load the first character of input
    cmp al, 'Q'            ; Compare to 'Q'
    je exit_game           ; If 'Q', exit the game
    cmp al, 'q'            ; Compare to 'q'
    je exit_game           ; If 'q', exit the game

    ; Convert input from ASCII to number
    lea si, user_input_buf + 2    ; Skip the first 2 bytes
    xor ax, ax             ; Clear ax (to store the number)
convert_loop:
    lodsb                  ; Load byte from user_input_buf
    cmp al, 0Dh            ; Check for Enter key (carriage return)
    je done_convert
    sub al, '0'            ; Convert ASCII to integer
    imul ax, ax, 10        ; Multiply previous result by 10
    add ax, bx             ; Add the new digit to ax
    jmp convert_loop
done_convert:

    ; Compare the number with the target number
    cmp ax, [number]       ; Compare the guessed number with the target
    je win               ; If guessed correctly, jump to win message
    jl too_low           ; If the number is too low, show "too low"
    jg too_high          ; If the number is too high, show "too high"

too_low:
    ; Message "too low"
    mov ah, 09h
    lea dx, too_low_msg
    int 21h
    jmp game_loop

too_high:
    ; Message "too high"
    mov ah, 09h
    lea dx, too_high_msg
    int 21h
    jmp game_loop

win:
    ; Win message
    mov ah, 09h
    lea dx, win_msg
    int 21h
    jmp exit_game

exit_game:
    ; Exit message
    mov ah, 09h
    lea dx, quit_msg
    int 21h

    ; Exit the program
    mov ah, 4Ch
    int 21h
end main

