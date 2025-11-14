.data
input_addr: .word 0x80
output_addr: .word 0x84
d: .word 0x2

.text
.org 0x100

_start:
@p input_addr a! @
is_prime
@p output_addr a! !
end

is_prime:
dup -if more_then_zero \ Проверка на >= 0
drop lit -1 \ Если отрицательно то возврат -1
;

more_then_zero:
dup if zero \ Если 0 то возврат

dup lit -1 + \ Если 1 то не простое
if not_prime

prime_loop:
\ dup
\ @p d dup a! lit 0 multiply  Выполнили возведение делителя в квадрат
\ over inv lit 1 +  Получили инвертированое текущее значение
\ + lit -1 + -if prime_success  проверили на >= 0
@p d !b
dup a! lit 0 lit 0 \ Загрузили текущий делитель
divmod \ Получили остаток от деления
inv lit 1 + @b + -if last_check 
if not_prime \ Проверили что остаток не 0
@p d lit 1 + !p d \ Увеличили делитель
prime_loop ;

divmod:
lit 31 >r \ Счётчик битов = 32
div_loop:
+/ \ Выполняем шаг деления
next div_loop \ Повторять, пока R != 0

;
not_prime:
drop lit 0
;
prime_success:
drop lit 1
;

last_check:
if not_prime
prime_success
;

zero:
drop lit -1
;
end:
halt
