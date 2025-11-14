        .data
buff:   .byte '________________________________'

input_addr:  .word 0x0080
output_addr: .word 0x0084
stack_addr:  .word 0x0150

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
        move.b (A0)+, D0
        cmp.b 0, D0
        beq end_read
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

        ; Настройка указателей: A0 = start, A1 = end - 1
        movea.l buff, A0
        movea.l A5, A1
        move.l A1, D0
        sub.l 1, D0
        movea.l D0, A1

reverse_loop:
        move.l A0, D0
        cmp.l A1, D0
        bge write_output

swap_chars:
        move.b (A0), D0
        move.b (A1), D1
        move.b D0, (A1)
        move.b D1, (A0)

        move.l A0, D0
        add.l 1, D0
        movea.l D0, A0
        move.l A1, D0
        sub.l 1, D0
        movea.l D0, A1
        jmp reverse_loop

write_output:
        movea.l buff, A5

output_loop:
        move.b (A5)+, D0
        cmp.b 0, D0
        beq end_program

        move.b D0, (A1)+
        jmp output_loop

overflow:
        move.l 0xCCCCCCCC, D0
        move.l D0, (A1)

end_program:
        halt
