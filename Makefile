include makefile.conf
#NAME=minimum
NAME=main
STARTUP_DEFS=-D__STARTUP_CLEAR_BSS -D__START=main

MY_ROOT = $(CURDIR)/..
STM32_LIB = $(MY_ROOT)/STM32F10x_StdPeriph_Lib_V3.5.0
#declare library source folder
#MY_SRC_DIR = $(STM32_LIB)/Libraries/STM32F10x_StdPeriph_Driver/src
#declare library header folder
#MY_INC_DIR = $(STM32_LIB)/Libraries/STM32F10x_StdPeriph_Driver/inc
#MY_SOURCE := $(notdir $(wildcard $(MY_SRC_DIR)/*.c))
#MY_OBJECTS := $(addprefix $(OUTPUT_DIR)/, $(MY_SOURCE:.c=.rel))

CMSIS_LIB = $(STM32_LIB)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x
CORE_CM3 = $(STM32_LIB)/Libraries/CMSIS/CM3/CoreSupport
CONF_DIR = $(STM32_LIB)/Project/STM32F10x_StdPeriph_Template

OBJECTS += main.o
OBJECTS += stm32f10x_gpio.o
OBJECTS += stm32f10x_rcc.o

# collect all include folders
INCLUDE = -I$(CMSIS_LIB) -I$(CORE_CM3) -I$(CONF_DIR)

LDSCRIPTS=-L. -L$(BASE)/ldscripts -T nokeep.ld
LFLAGS=$(USE_NANO) $(USE_NOHOST) $(LDSCRIPTS) $(GC) $(MAP)

# rule to generate .o file(s) from .c files
%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDE) -c -o $@ $<

$(NAME)-$(CORE).bin: $(NAME)-$(CORE).axf
	arm-none-eabi-objcopy -v -O binary $(NAME)-$(CORE).axf $(NAME)-$(CORE).bin

$(NAME)-$(CORE).axf: $(NAME).c $(STARTUP)
	$(CC) $^ $(CFLAGS) $(LFLAGS) -o $@


.PHONY=clean
clean: 
	rm -f $(NAME)*.axf *.map *.o
