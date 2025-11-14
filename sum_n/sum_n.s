    .data
input_addr:      .word  0x80
output_addr:     .word  0x84

    .text
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

_start:
    @p input_addr a! @       \ n:[]
    sum_n
    @p output_addr a! !
    halt

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

sum_n:
    lit 0                    \ 0:n[]
    a!                       \ n:[]     (аккумулятор в R-стек)

sum_loop:
    \ Проверяем условие продолжения
    \ проверяем на 0
    dup                      \ n:n:[]
    if n_0_or_less_0
    dup                      \ n:n:[]
    -if contue               \ Если >= 0, продолжаем

n_0_or_less_0:
    lit -1
    ;

contue:
    \ Добавляем текущее значение к аккумулятору
    dup                      \ n:n:[]
    a                        \ acc:n:n:[]
    +                        \ acc+n:n:[]
    a!                       \ n:[]     сохраняем новую сумму

    \ Уменьшаем n на 1
    lit -1                   \ -1:n:[]
    +                        \ n-1:[]
    dup                      \ n:n:[]
    -if contue               \ Если не ноль, продолжаем

done:
    drop                     \ Удаляем 0
    a
    ;
