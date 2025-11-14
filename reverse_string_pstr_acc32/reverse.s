    .data

buf:                .byte   '________________________________'
buf_start:          .word   0x0
intput_addr:        .word   0x80
output_addr:        .word   0x84
buf_size:           .word   0x20
eof:                .word   0xA

len:                .word   0x0
ptr:                .word   0x0
tmp:                .word   0x0
tmp2:               .word   0x0
left_ptr:           .word   0x0
right_ptr:          .word   0x0 

const_1:            .word   1
const_0:            .word   0
const_FF:           .word   0xFF
mask:               .word   0xFFFF_FF00
overflow_value:     .word   0xCCCC_CCCC  

    .text
    .org 0x100

_start:

    load_addr       buf_start                   ; buf_start + 1 -> ptr
    add             const_1
    store_addr      ptr

    load_addr       const_0                     ; 0 -> len
    store_addr      len

read_cycle:
    sub             buf_size                    ; if len == buf_size: overflow
    beqz            overflow

    load_ind        intput_addr                 ; lower byte of input -> tmp
    and             const_FF
    store_addr      tmp

    load_addr       eof                         ; if tmp == eof: store_str_len
    sub             tmp
    beqz            store_str_len

store_tmp:
    load_ind        ptr                         ; tmp -> M[ptr]
    and             mask
    or              tmp
    store_ind       ptr

    load_addr       ptr                         ; ptr++
    add             const_1
    store_addr      ptr

    load_addr       len                         ; len++
    add             const_1
    store_addr      len

    jmp             read_cycle                  ; continue cycle

store_str_len:
    load_ind        buf_start                   ; len -> M[buf_start]
    and             mask
    or              len
    store_ind       buf_start

reverse:
    load_addr       ptr                         ; ptr - 1 -> right_ptr  
    sub             const_1
    store_addr      right_ptr

    load_addr       buf_start                   ; buf_start + 1 -> left_ptr 
    add             const_1
    store_addr      left_ptr

reverse_while:
    load_addr       left_ptr                    ; if left_ptr > right_ptr: print_answer
    sub             right_ptr
    ble             continue
    jmp             print_answer

continue:
    load_ind        left_ptr                    ; M[left_ptr] -> tmp
    and             const_FF
    store_addr      tmp

    load_ind        right_ptr                   ; M[right_ptr] -> tmp2
    and             const_FF
    store_addr      tmp2

    load_ind        left_ptr                    ; tmp2 -> M[left_ptr] 
    and             mask
    or              tmp2
    store_ind       left_ptr

    load_ind        right_ptr                   ; tmp -> M[right_ptr]   
    and             mask
    or              tmp
    store_ind       right_ptr

    load_addr       left_ptr                    ; left_ptr++    
    add             const_1
    store_addr      left_ptr

    load_addr       right_ptr                   ; right_ptr--    
    sub             const_1
    store_addr      right_ptr

    jmp reverse_while                           ; continue cycle

print_answer:
    load_addr       buf_start                   ; buf_start + 1 -> ptr
    add             const_1
    store_addr      ptr    

    load_addr       len                         ; len -> acc

print_cycle:
    beqz            end                         ; if len == 0: goto end

    load_ind        ptr                         ; cout << lower byte of M[ptr]
    and             const_FF
    store_ind       output_addr

    load_addr       ptr                         ; ptr++
    add             const_1
    store_addr      ptr

    load_addr       len                         ; len--
    sub             const_1                    
    store_addr      len

    jmp             print_cycle                 ; continue cycle

end:
    halt

overflow:
    load_addr       overflow_value
    store_ind       output_addr
    halt
