   .text
    .global loader                   # making entry point visible to linker

    # setting up the Multiboot header - see GRUB docs for details
    .set FLAGS,    0x0               # this is the Multiboot 'flag' field
    .set MAGIC,    0x1BADB002        # 'magic number' lets bootloader find the header
    .set CHECKSUM, -(MAGIC + FLAGS)  # checksum required

    .align 4
    .long MAGIC
    .long FLAGS
    .long CHECKSUM

# reserve initial kernel stack space
     .set STACKSIZE, 0x4000   # присвоить STACKSIZE = 0x4000
    .lcomm stack, STACKSIZE  # зарезервировать STACKSIZE байт. stack ссылается на диапазон
    .comm  mbd, 4            # зарезервировать 4 байта под переменную mdb в области COMMON
    .comm  magic, 4          # зарезервировать 4 байта под переменную magic в области COMMON               # we will use this in kmain

loader:
    movl  $(stack + STACKSIZE), %esp 	# инициализировать стек
    movl  %eax, magic                # записать %eax по адресу magic
    movl  %ebx, mbd                  # записать %ebx по адресу mbd
    call  main                       # вызвать функцию main
    cli				# отключить прерывания от оборудования
hang:
    hlt                     # остановить процессор пока не возникнет прерывание
    jmp   hang		# прыгнуть на метку hang

