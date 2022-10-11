#include "stm32f10x_gpio.h"
#include "stm32f10x_rcc.h"

#ifndef __NO_SYSTEM_INIT
void SystemInit()
{}
#endif

#define LEDPORT (GPIOC)
#define LED1 (13)
#define ENABLE_GPIO_CLOCK (RCC->APB2ENR |= RCC_APB2ENR_IOPCEN)
#define _MODER    CRH
#define GPIOMODER (GPIO_CRH_MODE13_0)

void ms_delay(int ms)
{
   while (ms-- > 0) {
      volatile int x=500;
      while (x-- > 0)
         __asm("nop");
   }
}

//Alternates blue and green LEDs quickly
int main(void){
    ENABLE_GPIO_CLOCK;              // enable the clock to GPIO
    LEDPORT->_MODER |= GPIOMODER;   // set pins to be general purpose output
    for (;;) {
      ms_delay(500);
      LEDPORT->ODR ^= (1<<LED1);  // toggle diodes
    }
}
