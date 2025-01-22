.model small          ; Set memory model to 'small', which uses a single code and data segment
.stack 100h           ; Set stack size to 256 bytes

.data                 ; Start of data segment
message db 'hello world!$'  ; Define the message string, ending with '$'

.code                 ; Start of code segment
mov ax, @data         ; Initialize the data segment by loading its address into AX
mov ds, ax            ; Set DS (data segment register) to the value in AX

mov ah, 9             ; Function 9 of interrupt 21h to print a string
mov dx, offset message ; Load the address of the message string into DX
int 21h               ; Call DOS interrupt 21h to print the string

mov ah, 4Ch           ; Function 4Ch of interrupt 21h to terminate the program
int 21h               ; Call DOS interrupt 21h to exit the program
end                   ; End of the program
