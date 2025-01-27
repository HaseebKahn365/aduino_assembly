//port b for square wave and 
//port c [pushbuttons] to d for led array

.INCLUDE "M32DEF.INC"

.ORG 0X0 //FOR MAIN
    JMP MAIN
.ORG 0X16 //TOV0ISR
    JMP TOV0ISR

.0RG OX100 //MAIN PROGRAM FOR TRANSFERING DATA FROM PORT C TO PORT D
MAIN:
    LDI R20, HIGH(RAMEND)
    OUT SPH, R20
    LDI R20, LOW(RAMEND)
    OUT SPL , R20

    //PD5 AS OUTPUT FOR SQUARE WAVE
    SBI DDRB, 5
    //PORT C AS INPUT AND PORT D AS OUTPUT
    LDI RR20, 0X00
    OUT DDRC, R20
    LDI R20, OXFF,
    OUT PORTD, R20

    //ENABLING GLOBAL AND TIMSK FOR INTERRUPT TOV0
    LDI R20, (1<<TOIE0)
    OUT TIMSK, R20

    //INIT THE TIMER
    LDI R20, -32 //TIMER VALUE FOR 4microseconds
    OUT TCNT0, R20

    //NORMAL MODE, NO PRESCALER, INTERNAL CLOCK
    LDI R20, 1<<CS00
    OUT TCCRO, R20

//INFINITE LOOP FOR DATA TRANSFER
DATA_TRANSFER:
    INR20, PORTC
    OUT PORTD, R20
    RJMP DATA_TRANSFER


//DEFINITION OF ISR FOR TIMER0 OVERFLOW
//WE WILL TOGGLE PB5 IN THIS ISR

.ORG 0X200
TOV0ISR:
    IN R16, PORTB
    LDI R20, 0X20
    EOR R20, R16
    OUT DDRB, R20
    //RESET TCNT0
    LDI R20, -32
    OUT TCNT0, R20
    RETI

