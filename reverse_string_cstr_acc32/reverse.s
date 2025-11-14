    .data
buffer:          .byte  '________________________________' ; 20 endlines
buffer_pointer:  .word  0x00
counter:         .word  0x00
input_addr:      .word  0x80               
output_addr:     .word  0x84   
new_line:        .word  0xA
tmp:             .word  0x0
tmp2:            .word  0x0
const_1:         .word  0x01  
const_0:         .word  0x00
mask:            .word  0xFFFF_FF00 
mask_small_byte: .word  0xFF 


buffer_size:     .word  0x20
error:           .word  0xCCCC_CCCC
null_term:       .word  0x0

left_ptr:        .word  0x0
right_ptr:       .word  0x0   


    .text
.org 0x200
_start:

while:
    load_ind       input_addr
    store_addr     tmp
    sub            new_line ; проверка на окончание строки
    beqz           store_null_term

    load_addr      buffer_pointer ;проверка на переполнение буффера
    sub            buffer_size
    add            const_1   ; потому что с-строка  
    beqz           overflow

    load_ind       buffer_pointer ; устраняем нули
    and            mask
    or             tmp
    store_ind      buffer_pointer

    load_addr      buffer_pointer 
    add            const_1
    store_addr     buffer_pointer

    jmp while

store_null_term:
    load_ind       buffer_pointer 
    and            mask
    or             null_term
    store_ind      buffer_pointer

reverse: 
    load_addr       buffer_pointer 
    sub             const_1
    store_addr      right_ptr

reverse_while:
    load_addr       left_ptr
    sub             right_ptr ;проверка на то что левый поинтер больше правого
    ble             continue
    jmp             print_answer

continue:      

    load_ind        left_ptr
    and             mask_small_byte
    store_addr      tmp

    load_ind        right_ptr
    and             mask_small_byte
    store_addr      tmp2

    load_ind       left_ptr 
    and            mask
    or             tmp2
    store_ind      left_ptr

    load_ind       right_ptr 
    and            mask
    or             tmp
    store_ind      right_ptr

    load_addr      left_ptr 
    add            const_1
    store_addr     left_ptr

    load_addr      right_ptr 
    sub            const_1
    store_addr     right_ptr

    jmp reverse_while

print_answer:
    load_addr      const_0
    store_addr     buffer_pointer

print_cycle:
    load_ind       buffer_pointer
    and            mask_small_byte
    beqz           end
    
    store_ind      output_addr
    load_addr      buffer_pointer
    add            const_1
    store_addr     buffer_pointer
    jmp            print_cycle

overflow:
    load_addr      error
    store_ind      output_addr
end:
    halt
