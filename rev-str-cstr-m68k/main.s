        .data
buff:   .byte '________________________________'

input_addr:  .word 0x80
output_addr: .word 0x84
stack_addr:  .word 0x150

        .text
        .org 0x200

_start:
        movea.l stack_addr, A7
        movea.l (A7), A7

        movea.l input_addr, A0
        movea.l (A0), A0
        movea.l output_addr, A1
        movea.l (A1), A1

        ; Подготовка буфера
        movea.l buff, A5


        ; Инициализация констант
        move.b 10, D1     ; '\n'
        move.b 255, D2    ; Маска 0xFF
        move.b 0, D3      ; Счётчик символов = 0

read_loop:
        move.b (A0), D0

        cmp.b D1, D0
        beq end_read

        cmp.b 31, D3
        bge overflow

        move.b D0, (A5)+
        add.b 1, D3
        jmp read_loop

end_read:
        move.b 0, (A5)

        cmp.b 0, D3
        beq write_output

        ; Настройка указателей: D2 = 0, D3 = end - 1; A5 - начало буффера
        movea.l buff, A5
        move.l 0, D2

        move.l 0, D3
length_cycle:
        cmp.b 0, 0(A5, D3)
        beq end_length_cycle
        add.l 1, D3
        jmp length_cycle
end_length_cycle:
        sub.l 1, D3
        
reverse_loop:
        cmp.l D3, D2
        bge write_output

swap_chars:
        move.b 0(A5, D2), D0
        move.b 0(A5, D3), 0(A5, D2)
        move.b D0, 0(A5, D3)

        add.l 1, D2
        sub.l 1, D3

        jmp reverse_loop

write_output:
        movea.l buff, A5

output_loop:
        move.b (A5)+, D0
        cmp.b 0, D0
        beq end_program

        move.b D0, (A1)
        jmp output_loop

overflow:
        move.l 0xCCCCCCCC, D0
        move.l D0, (A1)

end_program:
        halt
