    .data

buf:                .byte   '________________________________'
input_addr:         .word   0x80
output_addr:        .word   0x84

    .text
    .org 0x100

_start:

    move.l      0, D0
    move.b      1, D1

    move.l      0x20, D2

    movea.l     input_addr, A0
    movea.l     (A0), A0
    movea.l     output_addr, A1
    movea.l     (A1), A1

    movea.l     0, A2

read_cycle:
    cmp.l       D2, D0
    beq         overflow

    move.b      (A0), D3

    cmp.b       0xA, D3
    beq         store_null_term

    cmp.b       0x20, D3
    beq         set_cap_flag

    cmp.b       0, D1
    beq         to_lowercase

to_uppercase:                                   
    cmp.b       0x61, D3     
    ble         remove_cap_flag

    cmp.b       0x7A, D3   
    bge         remove_cap_flag

    sub.b       0x20, D3

remove_cap_flag:
    move.b      0, D1
    
    jmp         store_tmp                                

to_lowercase:
    cmp.b       0x41, D3
    ble         store_tmp

    cmp.b       0x5A, D3
    bge         store_tmp

    add.b       0x20, D3

    jmp         store_tmp       

set_cap_flag:
    move.b      1, D1

store_tmp:
    move.b      D3, (A2)+

    add.l       1, D0

    jmp         read_cycle

store_null_term:
    move.b      0, (A2)

    movea.l     0, A2
print_cycle:
    cmp.b       0, (A2)
    beq         end
    move.b      (A2)+, (A1)
    jmp         print_cycle

end:
    halt

overflow:
    move.l      0xCCCC_CCCC, (A1)
    halt
