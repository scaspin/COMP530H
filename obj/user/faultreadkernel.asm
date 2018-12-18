
obj/user/faultreadkernel:     file format elf64-x86-64


Disassembly of section .text:

0000000000800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	movabs $USTACKTOP, %rax
  800020:	48 b8 00 e0 7f ef 00 	movabs $0xef7fe000,%rax
  800027:	00 00 00 
	cmpq %rax,%rsp
  80002a:	48 39 c4             	cmp    %rax,%rsp
	jne args_exist
  80002d:	75 04                	jne    800033 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushq $0
  80002f:	6a 00                	pushq  $0x0
	pushq $0
  800031:	6a 00                	pushq  $0x0

0000000000800033 <args_exist>:

args_exist:
	movq 8(%rsp), %rsi
  800033:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
	movq (%rsp), %rdi
  800038:	48 8b 3c 24          	mov    (%rsp),%rdi
	call libmain
  80003c:	e8 3d 00 00 00       	callq  80007e <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cprintf("I read %08x from location 0x8004000000!\n", *(unsigned*)0x8004000000);
  800052:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  800059:	00 00 00 
  80005c:	8b 00                	mov    (%rax),%eax
  80005e:	89 c6                	mov    %eax,%esi
  800060:	48 bf 60 1a 80 00 00 	movabs $0x801a60,%rdi
  800067:	00 00 00 
  80006a:	b8 00 00 00 00       	mov    $0x0,%eax
  80006f:	48 ba 48 02 80 00 00 	movabs $0x800248,%rdx
  800076:	00 00 00 
  800079:	ff d2                	callq  *%rdx
}
  80007b:	90                   	nop
  80007c:	c9                   	leaveq 
  80007d:	c3                   	retq   

000000000080007e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007e:	55                   	push   %rbp
  80007f:	48 89 e5             	mov    %rsp,%rbp
  800082:	48 83 ec 10          	sub    $0x10,%rsp
  800086:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800089:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  80008d:	48 b8 95 16 80 00 00 	movabs $0x801695,%rax
  800094:	00 00 00 
  800097:	ff d0                	callq  *%rax
  800099:	25 ff 03 00 00       	and    $0x3ff,%eax
  80009e:	48 63 d0             	movslq %eax,%rdx
  8000a1:	48 89 d0             	mov    %rdx,%rax
  8000a4:	48 c1 e0 03          	shl    $0x3,%rax
  8000a8:	48 01 d0             	add    %rdx,%rax
  8000ab:	48 c1 e0 05          	shl    $0x5,%rax
  8000af:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000b6:	00 00 00 
  8000b9:	48 01 c2             	add    %rax,%rdx
  8000bc:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000c3:	00 00 00 
  8000c6:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cd:	7e 14                	jle    8000e3 <libmain+0x65>
		binaryname = argv[0];
  8000cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000d3:	48 8b 10             	mov    (%rax),%rdx
  8000d6:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000dd:	00 00 00 
  8000e0:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000ea:	48 89 d6             	mov    %rdx,%rsi
  8000ed:	89 c7                	mov    %eax,%edi
  8000ef:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000fb:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  800102:	00 00 00 
  800105:	ff d0                	callq  *%rax
}
  800107:	90                   	nop
  800108:	c9                   	leaveq 
  800109:	c3                   	retq   

000000000080010a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010a:	55                   	push   %rbp
  80010b:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80010e:	bf 00 00 00 00       	mov    $0x0,%edi
  800113:	48 b8 4f 16 80 00 00 	movabs $0x80164f,%rax
  80011a:	00 00 00 
  80011d:	ff d0                	callq  *%rax
}
  80011f:	90                   	nop
  800120:	5d                   	pop    %rbp
  800121:	c3                   	retq   

0000000000800122 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800122:	55                   	push   %rbp
  800123:	48 89 e5             	mov    %rsp,%rbp
  800126:	48 83 ec 10          	sub    $0x10,%rsp
  80012a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80012d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800131:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800135:	8b 00                	mov    (%rax),%eax
  800137:	8d 48 01             	lea    0x1(%rax),%ecx
  80013a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80013e:	89 0a                	mov    %ecx,(%rdx)
  800140:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800143:	89 d1                	mov    %edx,%ecx
  800145:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800149:	48 98                	cltq   
  80014b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80014f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800153:	8b 00                	mov    (%rax),%eax
  800155:	3d ff 00 00 00       	cmp    $0xff,%eax
  80015a:	75 2c                	jne    800188 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80015c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800160:	8b 00                	mov    (%rax),%eax
  800162:	48 98                	cltq   
  800164:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800168:	48 83 c2 08          	add    $0x8,%rdx
  80016c:	48 89 c6             	mov    %rax,%rsi
  80016f:	48 89 d7             	mov    %rdx,%rdi
  800172:	48 b8 c6 15 80 00 00 	movabs $0x8015c6,%rax
  800179:	00 00 00 
  80017c:	ff d0                	callq  *%rax
        b->idx = 0;
  80017e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800182:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800188:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80018c:	8b 40 04             	mov    0x4(%rax),%eax
  80018f:	8d 50 01             	lea    0x1(%rax),%edx
  800192:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800196:	89 50 04             	mov    %edx,0x4(%rax)
}
  800199:	90                   	nop
  80019a:	c9                   	leaveq 
  80019b:	c3                   	retq   

000000000080019c <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80019c:	55                   	push   %rbp
  80019d:	48 89 e5             	mov    %rsp,%rbp
  8001a0:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001a7:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001ae:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001b5:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001bc:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001c3:	48 8b 0a             	mov    (%rdx),%rcx
  8001c6:	48 89 08             	mov    %rcx,(%rax)
  8001c9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001cd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001d1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001d5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001e0:	00 00 00 
    b.cnt = 0;
  8001e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8001ea:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8001ed:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8001f4:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8001fb:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800202:	48 89 c6             	mov    %rax,%rsi
  800205:	48 bf 22 01 80 00 00 	movabs $0x800122,%rdi
  80020c:	00 00 00 
  80020f:	48 b8 e6 05 80 00 00 	movabs $0x8005e6,%rax
  800216:	00 00 00 
  800219:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80021b:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800221:	48 98                	cltq   
  800223:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80022a:	48 83 c2 08          	add    $0x8,%rdx
  80022e:	48 89 c6             	mov    %rax,%rsi
  800231:	48 89 d7             	mov    %rdx,%rdi
  800234:	48 b8 c6 15 80 00 00 	movabs $0x8015c6,%rax
  80023b:	00 00 00 
  80023e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800240:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800246:	c9                   	leaveq 
  800247:	c3                   	retq   

0000000000800248 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800248:	55                   	push   %rbp
  800249:	48 89 e5             	mov    %rsp,%rbp
  80024c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800253:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80025a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800261:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800268:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80026f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800276:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80027d:	84 c0                	test   %al,%al
  80027f:	74 20                	je     8002a1 <cprintf+0x59>
  800281:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800285:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800289:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80028d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800291:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800295:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800299:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80029d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002a1:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002a8:	00 00 00 
  8002ab:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002b2:	00 00 00 
  8002b5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002b9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002c0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002c7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002ce:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002d5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002dc:	48 8b 0a             	mov    (%rdx),%rcx
  8002df:	48 89 08             	mov    %rcx,(%rax)
  8002e2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002e6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002ea:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002ee:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8002f2:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8002f9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800300:	48 89 d6             	mov    %rdx,%rsi
  800303:	48 89 c7             	mov    %rax,%rdi
  800306:	48 b8 9c 01 80 00 00 	movabs $0x80019c,%rax
  80030d:	00 00 00 
  800310:	ff d0                	callq  *%rax
  800312:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800318:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80031e:	c9                   	leaveq 
  80031f:	c3                   	retq   

0000000000800320 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800320:	55                   	push   %rbp
  800321:	48 89 e5             	mov    %rsp,%rbp
  800324:	48 83 ec 30          	sub    $0x30,%rsp
  800328:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80032c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800330:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800334:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800337:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80033b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800342:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800346:	77 54                	ja     80039c <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800348:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80034b:	8d 78 ff             	lea    -0x1(%rax),%edi
  80034e:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800351:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800355:	ba 00 00 00 00       	mov    $0x0,%edx
  80035a:	48 f7 f6             	div    %rsi
  80035d:	49 89 c2             	mov    %rax,%r10
  800360:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800363:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800366:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80036a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80036e:	41 89 c9             	mov    %ecx,%r9d
  800371:	41 89 f8             	mov    %edi,%r8d
  800374:	89 d1                	mov    %edx,%ecx
  800376:	4c 89 d2             	mov    %r10,%rdx
  800379:	48 89 c7             	mov    %rax,%rdi
  80037c:	48 b8 20 03 80 00 00 	movabs $0x800320,%rax
  800383:	00 00 00 
  800386:	ff d0                	callq  *%rax
  800388:	eb 1c                	jmp    8003a6 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80038a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80038e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800395:	48 89 ce             	mov    %rcx,%rsi
  800398:	89 d7                	mov    %edx,%edi
  80039a:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80039c:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8003a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003a4:	7f e4                	jg     80038a <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003a6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8003a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b2:	48 f7 f1             	div    %rcx
  8003b5:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  8003bc:	00 00 00 
  8003bf:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8003c3:	0f be d0             	movsbl %al,%edx
  8003c6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8003ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003ce:	48 89 ce             	mov    %rcx,%rsi
  8003d1:	89 d7                	mov    %edx,%edi
  8003d3:	ff d0                	callq  *%rax
}
  8003d5:	90                   	nop
  8003d6:	c9                   	leaveq 
  8003d7:	c3                   	retq   

00000000008003d8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d8:	55                   	push   %rbp
  8003d9:	48 89 e5             	mov    %rsp,%rbp
  8003dc:	48 83 ec 20          	sub    $0x20,%rsp
  8003e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003e4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8003e7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003eb:	7e 4f                	jle    80043c <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8003ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f1:	8b 00                	mov    (%rax),%eax
  8003f3:	83 f8 30             	cmp    $0x30,%eax
  8003f6:	73 24                	jae    80041c <getuint+0x44>
  8003f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003fc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800400:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800404:	8b 00                	mov    (%rax),%eax
  800406:	89 c0                	mov    %eax,%eax
  800408:	48 01 d0             	add    %rdx,%rax
  80040b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80040f:	8b 12                	mov    (%rdx),%edx
  800411:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800414:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800418:	89 0a                	mov    %ecx,(%rdx)
  80041a:	eb 14                	jmp    800430 <getuint+0x58>
  80041c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420:	48 8b 40 08          	mov    0x8(%rax),%rax
  800424:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800428:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800430:	48 8b 00             	mov    (%rax),%rax
  800433:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800437:	e9 9d 00 00 00       	jmpq   8004d9 <getuint+0x101>
	else if (lflag)
  80043c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800440:	74 4c                	je     80048e <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800442:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800446:	8b 00                	mov    (%rax),%eax
  800448:	83 f8 30             	cmp    $0x30,%eax
  80044b:	73 24                	jae    800471 <getuint+0x99>
  80044d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800451:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800455:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800459:	8b 00                	mov    (%rax),%eax
  80045b:	89 c0                	mov    %eax,%eax
  80045d:	48 01 d0             	add    %rdx,%rax
  800460:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800464:	8b 12                	mov    (%rdx),%edx
  800466:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800469:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80046d:	89 0a                	mov    %ecx,(%rdx)
  80046f:	eb 14                	jmp    800485 <getuint+0xad>
  800471:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800475:	48 8b 40 08          	mov    0x8(%rax),%rax
  800479:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80047d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800481:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800485:	48 8b 00             	mov    (%rax),%rax
  800488:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80048c:	eb 4b                	jmp    8004d9 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  80048e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800492:	8b 00                	mov    (%rax),%eax
  800494:	83 f8 30             	cmp    $0x30,%eax
  800497:	73 24                	jae    8004bd <getuint+0xe5>
  800499:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a5:	8b 00                	mov    (%rax),%eax
  8004a7:	89 c0                	mov    %eax,%eax
  8004a9:	48 01 d0             	add    %rdx,%rax
  8004ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b0:	8b 12                	mov    (%rdx),%edx
  8004b2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b9:	89 0a                	mov    %ecx,(%rdx)
  8004bb:	eb 14                	jmp    8004d1 <getuint+0xf9>
  8004bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004c5:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8004c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004cd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004d1:	8b 00                	mov    (%rax),%eax
  8004d3:	89 c0                	mov    %eax,%eax
  8004d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004dd:	c9                   	leaveq 
  8004de:	c3                   	retq   

00000000008004df <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004df:	55                   	push   %rbp
  8004e0:	48 89 e5             	mov    %rsp,%rbp
  8004e3:	48 83 ec 20          	sub    $0x20,%rsp
  8004e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004eb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8004ee:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004f2:	7e 4f                	jle    800543 <getint+0x64>
		x=va_arg(*ap, long long);
  8004f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f8:	8b 00                	mov    (%rax),%eax
  8004fa:	83 f8 30             	cmp    $0x30,%eax
  8004fd:	73 24                	jae    800523 <getint+0x44>
  8004ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800503:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050b:	8b 00                	mov    (%rax),%eax
  80050d:	89 c0                	mov    %eax,%eax
  80050f:	48 01 d0             	add    %rdx,%rax
  800512:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800516:	8b 12                	mov    (%rdx),%edx
  800518:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80051b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051f:	89 0a                	mov    %ecx,(%rdx)
  800521:	eb 14                	jmp    800537 <getint+0x58>
  800523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800527:	48 8b 40 08          	mov    0x8(%rax),%rax
  80052b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80052f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800533:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800537:	48 8b 00             	mov    (%rax),%rax
  80053a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80053e:	e9 9d 00 00 00       	jmpq   8005e0 <getint+0x101>
	else if (lflag)
  800543:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800547:	74 4c                	je     800595 <getint+0xb6>
		x=va_arg(*ap, long);
  800549:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054d:	8b 00                	mov    (%rax),%eax
  80054f:	83 f8 30             	cmp    $0x30,%eax
  800552:	73 24                	jae    800578 <getint+0x99>
  800554:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800558:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80055c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800560:	8b 00                	mov    (%rax),%eax
  800562:	89 c0                	mov    %eax,%eax
  800564:	48 01 d0             	add    %rdx,%rax
  800567:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056b:	8b 12                	mov    (%rdx),%edx
  80056d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800570:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800574:	89 0a                	mov    %ecx,(%rdx)
  800576:	eb 14                	jmp    80058c <getint+0xad>
  800578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800580:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800584:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800588:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80058c:	48 8b 00             	mov    (%rax),%rax
  80058f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800593:	eb 4b                	jmp    8005e0 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800599:	8b 00                	mov    (%rax),%eax
  80059b:	83 f8 30             	cmp    $0x30,%eax
  80059e:	73 24                	jae    8005c4 <getint+0xe5>
  8005a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ac:	8b 00                	mov    (%rax),%eax
  8005ae:	89 c0                	mov    %eax,%eax
  8005b0:	48 01 d0             	add    %rdx,%rax
  8005b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b7:	8b 12                	mov    (%rdx),%edx
  8005b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c0:	89 0a                	mov    %ecx,(%rdx)
  8005c2:	eb 14                	jmp    8005d8 <getint+0xf9>
  8005c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005cc:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d8:	8b 00                	mov    (%rax),%eax
  8005da:	48 98                	cltq   
  8005dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005e4:	c9                   	leaveq 
  8005e5:	c3                   	retq   

00000000008005e6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005e6:	55                   	push   %rbp
  8005e7:	48 89 e5             	mov    %rsp,%rbp
  8005ea:	41 54                	push   %r12
  8005ec:	53                   	push   %rbx
  8005ed:	48 83 ec 60          	sub    $0x60,%rsp
  8005f1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8005f5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8005f9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8005fd:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800601:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800605:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800609:	48 8b 0a             	mov    (%rdx),%rcx
  80060c:	48 89 08             	mov    %rcx,(%rax)
  80060f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800613:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800617:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80061b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80061f:	eb 17                	jmp    800638 <vprintfmt+0x52>
			if (ch == '\0')
  800621:	85 db                	test   %ebx,%ebx
  800623:	0f 84 b9 04 00 00    	je     800ae2 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800629:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80062d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800631:	48 89 d6             	mov    %rdx,%rsi
  800634:	89 df                	mov    %ebx,%edi
  800636:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800638:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80063c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800640:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800644:	0f b6 00             	movzbl (%rax),%eax
  800647:	0f b6 d8             	movzbl %al,%ebx
  80064a:	83 fb 25             	cmp    $0x25,%ebx
  80064d:	75 d2                	jne    800621 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80064f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800653:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80065a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800661:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800668:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800673:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800677:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80067b:	0f b6 00             	movzbl (%rax),%eax
  80067e:	0f b6 d8             	movzbl %al,%ebx
  800681:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800684:	83 f8 55             	cmp    $0x55,%eax
  800687:	0f 87 22 04 00 00    	ja     800aaf <vprintfmt+0x4c9>
  80068d:	89 c0                	mov    %eax,%eax
  80068f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800696:	00 
  800697:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  80069e:	00 00 00 
  8006a1:	48 01 d0             	add    %rdx,%rax
  8006a4:	48 8b 00             	mov    (%rax),%rax
  8006a7:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006a9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006ad:	eb c0                	jmp    80066f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006af:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006b3:	eb ba                	jmp    80066f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006bc:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006bf:	89 d0                	mov    %edx,%eax
  8006c1:	c1 e0 02             	shl    $0x2,%eax
  8006c4:	01 d0                	add    %edx,%eax
  8006c6:	01 c0                	add    %eax,%eax
  8006c8:	01 d8                	add    %ebx,%eax
  8006ca:	83 e8 30             	sub    $0x30,%eax
  8006cd:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006d0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006d4:	0f b6 00             	movzbl (%rax),%eax
  8006d7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006da:	83 fb 2f             	cmp    $0x2f,%ebx
  8006dd:	7e 60                	jle    80073f <vprintfmt+0x159>
  8006df:	83 fb 39             	cmp    $0x39,%ebx
  8006e2:	7f 5b                	jg     80073f <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e9:	eb d1                	jmp    8006bc <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8006eb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006ee:	83 f8 30             	cmp    $0x30,%eax
  8006f1:	73 17                	jae    80070a <vprintfmt+0x124>
  8006f3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8006f7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8006fa:	89 d2                	mov    %edx,%edx
  8006fc:	48 01 d0             	add    %rdx,%rax
  8006ff:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800702:	83 c2 08             	add    $0x8,%edx
  800705:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800708:	eb 0c                	jmp    800716 <vprintfmt+0x130>
  80070a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80070e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800712:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800716:	8b 00                	mov    (%rax),%eax
  800718:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80071b:	eb 23                	jmp    800740 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  80071d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800721:	0f 89 48 ff ff ff    	jns    80066f <vprintfmt+0x89>
				width = 0;
  800727:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80072e:	e9 3c ff ff ff       	jmpq   80066f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800733:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80073a:	e9 30 ff ff ff       	jmpq   80066f <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80073f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800740:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800744:	0f 89 25 ff ff ff    	jns    80066f <vprintfmt+0x89>
				width = precision, precision = -1;
  80074a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80074d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800750:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800757:	e9 13 ff ff ff       	jmpq   80066f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80075c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800760:	e9 0a ff ff ff       	jmpq   80066f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800765:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800768:	83 f8 30             	cmp    $0x30,%eax
  80076b:	73 17                	jae    800784 <vprintfmt+0x19e>
  80076d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800771:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800774:	89 d2                	mov    %edx,%edx
  800776:	48 01 d0             	add    %rdx,%rax
  800779:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80077c:	83 c2 08             	add    $0x8,%edx
  80077f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800782:	eb 0c                	jmp    800790 <vprintfmt+0x1aa>
  800784:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800788:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80078c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800790:	8b 10                	mov    (%rax),%edx
  800792:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800796:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80079a:	48 89 ce             	mov    %rcx,%rsi
  80079d:	89 d7                	mov    %edx,%edi
  80079f:	ff d0                	callq  *%rax
			break;
  8007a1:	e9 37 03 00 00       	jmpq   800add <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007a6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a9:	83 f8 30             	cmp    $0x30,%eax
  8007ac:	73 17                	jae    8007c5 <vprintfmt+0x1df>
  8007ae:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8007b2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007b5:	89 d2                	mov    %edx,%edx
  8007b7:	48 01 d0             	add    %rdx,%rax
  8007ba:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007bd:	83 c2 08             	add    $0x8,%edx
  8007c0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007c3:	eb 0c                	jmp    8007d1 <vprintfmt+0x1eb>
  8007c5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8007c9:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8007cd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007d1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8007d3:	85 db                	test   %ebx,%ebx
  8007d5:	79 02                	jns    8007d9 <vprintfmt+0x1f3>
				err = -err;
  8007d7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007d9:	83 fb 15             	cmp    $0x15,%ebx
  8007dc:	7f 16                	jg     8007f4 <vprintfmt+0x20e>
  8007de:	48 b8 40 1b 80 00 00 	movabs $0x801b40,%rax
  8007e5:	00 00 00 
  8007e8:	48 63 d3             	movslq %ebx,%rdx
  8007eb:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8007ef:	4d 85 e4             	test   %r12,%r12
  8007f2:	75 2e                	jne    800822 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  8007f4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8007f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007fc:	89 d9                	mov    %ebx,%ecx
  8007fe:	48 ba 01 1c 80 00 00 	movabs $0x801c01,%rdx
  800805:	00 00 00 
  800808:	48 89 c7             	mov    %rax,%rdi
  80080b:	b8 00 00 00 00       	mov    $0x0,%eax
  800810:	49 b8 ec 0a 80 00 00 	movabs $0x800aec,%r8
  800817:	00 00 00 
  80081a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80081d:	e9 bb 02 00 00       	jmpq   800add <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800822:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800826:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80082a:	4c 89 e1             	mov    %r12,%rcx
  80082d:	48 ba 0a 1c 80 00 00 	movabs $0x801c0a,%rdx
  800834:	00 00 00 
  800837:	48 89 c7             	mov    %rax,%rdi
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	49 b8 ec 0a 80 00 00 	movabs $0x800aec,%r8
  800846:	00 00 00 
  800849:	41 ff d0             	callq  *%r8
			break;
  80084c:	e9 8c 02 00 00       	jmpq   800add <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800851:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800854:	83 f8 30             	cmp    $0x30,%eax
  800857:	73 17                	jae    800870 <vprintfmt+0x28a>
  800859:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80085d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800860:	89 d2                	mov    %edx,%edx
  800862:	48 01 d0             	add    %rdx,%rax
  800865:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800868:	83 c2 08             	add    $0x8,%edx
  80086b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80086e:	eb 0c                	jmp    80087c <vprintfmt+0x296>
  800870:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800874:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800878:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80087c:	4c 8b 20             	mov    (%rax),%r12
  80087f:	4d 85 e4             	test   %r12,%r12
  800882:	75 0a                	jne    80088e <vprintfmt+0x2a8>
				p = "(null)";
  800884:	49 bc 0d 1c 80 00 00 	movabs $0x801c0d,%r12
  80088b:	00 00 00 
			if (width > 0 && padc != '-')
  80088e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800892:	7e 78                	jle    80090c <vprintfmt+0x326>
  800894:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800898:	74 72                	je     80090c <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  80089a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80089d:	48 98                	cltq   
  80089f:	48 89 c6             	mov    %rax,%rsi
  8008a2:	4c 89 e7             	mov    %r12,%rdi
  8008a5:	48 b8 9a 0d 80 00 00 	movabs $0x800d9a,%rax
  8008ac:	00 00 00 
  8008af:	ff d0                	callq  *%rax
  8008b1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008b4:	eb 17                	jmp    8008cd <vprintfmt+0x2e7>
					putch(padc, putdat);
  8008b6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008ba:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008be:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008c2:	48 89 ce             	mov    %rcx,%rsi
  8008c5:	89 d7                	mov    %edx,%edi
  8008c7:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008cd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008d1:	7f e3                	jg     8008b6 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008d3:	eb 37                	jmp    80090c <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  8008d5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8008d9:	74 1e                	je     8008f9 <vprintfmt+0x313>
  8008db:	83 fb 1f             	cmp    $0x1f,%ebx
  8008de:	7e 05                	jle    8008e5 <vprintfmt+0x2ff>
  8008e0:	83 fb 7e             	cmp    $0x7e,%ebx
  8008e3:	7e 14                	jle    8008f9 <vprintfmt+0x313>
					putch('?', putdat);
  8008e5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008e9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ed:	48 89 d6             	mov    %rdx,%rsi
  8008f0:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8008f5:	ff d0                	callq  *%rax
  8008f7:	eb 0f                	jmp    800908 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  8008f9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008fd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800901:	48 89 d6             	mov    %rdx,%rsi
  800904:	89 df                	mov    %ebx,%edi
  800906:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800908:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80090c:	4c 89 e0             	mov    %r12,%rax
  80090f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800913:	0f b6 00             	movzbl (%rax),%eax
  800916:	0f be d8             	movsbl %al,%ebx
  800919:	85 db                	test   %ebx,%ebx
  80091b:	74 28                	je     800945 <vprintfmt+0x35f>
  80091d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800921:	78 b2                	js     8008d5 <vprintfmt+0x2ef>
  800923:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800927:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80092b:	79 a8                	jns    8008d5 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80092d:	eb 16                	jmp    800945 <vprintfmt+0x35f>
				putch(' ', putdat);
  80092f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800933:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800937:	48 89 d6             	mov    %rdx,%rsi
  80093a:	bf 20 00 00 00       	mov    $0x20,%edi
  80093f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800941:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800945:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800949:	7f e4                	jg     80092f <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  80094b:	e9 8d 01 00 00       	jmpq   800add <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800950:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800954:	be 03 00 00 00       	mov    $0x3,%esi
  800959:	48 89 c7             	mov    %rax,%rdi
  80095c:	48 b8 df 04 80 00 00 	movabs $0x8004df,%rax
  800963:	00 00 00 
  800966:	ff d0                	callq  *%rax
  800968:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80096c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800970:	48 85 c0             	test   %rax,%rax
  800973:	79 1d                	jns    800992 <vprintfmt+0x3ac>
				putch('-', putdat);
  800975:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800979:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80097d:	48 89 d6             	mov    %rdx,%rsi
  800980:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800985:	ff d0                	callq  *%rax
				num = -(long long) num;
  800987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098b:	48 f7 d8             	neg    %rax
  80098e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800992:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800999:	e9 d2 00 00 00       	jmpq   800a70 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80099e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009a2:	be 03 00 00 00       	mov    $0x3,%esi
  8009a7:	48 89 c7             	mov    %rax,%rdi
  8009aa:	48 b8 d8 03 80 00 00 	movabs $0x8003d8,%rax
  8009b1:	00 00 00 
  8009b4:	ff d0                	callq  *%rax
  8009b6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009ba:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009c1:	e9 aa 00 00 00       	jmpq   800a70 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  8009c6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009ca:	be 03 00 00 00       	mov    $0x3,%esi
  8009cf:	48 89 c7             	mov    %rax,%rdi
  8009d2:	48 b8 d8 03 80 00 00 	movabs $0x8003d8,%rax
  8009d9:	00 00 00 
  8009dc:	ff d0                	callq  *%rax
  8009de:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8009e2:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8009e9:	e9 82 00 00 00       	jmpq   800a70 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  8009ee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f6:	48 89 d6             	mov    %rdx,%rsi
  8009f9:	bf 30 00 00 00       	mov    $0x30,%edi
  8009fe:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a08:	48 89 d6             	mov    %rdx,%rsi
  800a0b:	bf 78 00 00 00       	mov    $0x78,%edi
  800a10:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a15:	83 f8 30             	cmp    $0x30,%eax
  800a18:	73 17                	jae    800a31 <vprintfmt+0x44b>
  800a1a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a1e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a21:	89 d2                	mov    %edx,%edx
  800a23:	48 01 d0             	add    %rdx,%rax
  800a26:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a29:	83 c2 08             	add    $0x8,%edx
  800a2c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a2f:	eb 0c                	jmp    800a3d <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800a31:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a35:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a39:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a3d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a40:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a44:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a4b:	eb 23                	jmp    800a70 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a4d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a51:	be 03 00 00 00       	mov    $0x3,%esi
  800a56:	48 89 c7             	mov    %rax,%rdi
  800a59:	48 b8 d8 03 80 00 00 	movabs $0x8003d8,%rax
  800a60:	00 00 00 
  800a63:	ff d0                	callq  *%rax
  800a65:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800a69:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a70:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800a75:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800a78:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800a7b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a87:	45 89 c1             	mov    %r8d,%r9d
  800a8a:	41 89 f8             	mov    %edi,%r8d
  800a8d:	48 89 c7             	mov    %rax,%rdi
  800a90:	48 b8 20 03 80 00 00 	movabs $0x800320,%rax
  800a97:	00 00 00 
  800a9a:	ff d0                	callq  *%rax
			break;
  800a9c:	eb 3f                	jmp    800add <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a9e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa6:	48 89 d6             	mov    %rdx,%rsi
  800aa9:	89 df                	mov    %ebx,%edi
  800aab:	ff d0                	callq  *%rax
			break;
  800aad:	eb 2e                	jmp    800add <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aaf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ab3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab7:	48 89 d6             	mov    %rdx,%rsi
  800aba:	bf 25 00 00 00       	mov    $0x25,%edi
  800abf:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ac6:	eb 05                	jmp    800acd <vprintfmt+0x4e7>
  800ac8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800acd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ad1:	48 83 e8 01          	sub    $0x1,%rax
  800ad5:	0f b6 00             	movzbl (%rax),%eax
  800ad8:	3c 25                	cmp    $0x25,%al
  800ada:	75 ec                	jne    800ac8 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800adc:	90                   	nop
		}
	}
  800add:	e9 3d fb ff ff       	jmpq   80061f <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ae2:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ae3:	48 83 c4 60          	add    $0x60,%rsp
  800ae7:	5b                   	pop    %rbx
  800ae8:	41 5c                	pop    %r12
  800aea:	5d                   	pop    %rbp
  800aeb:	c3                   	retq   

0000000000800aec <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aec:	55                   	push   %rbp
  800aed:	48 89 e5             	mov    %rsp,%rbp
  800af0:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800af7:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800afe:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b05:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800b0c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b13:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b1a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b21:	84 c0                	test   %al,%al
  800b23:	74 20                	je     800b45 <printfmt+0x59>
  800b25:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b29:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b2d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b31:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b35:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b39:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b3d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b41:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b45:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b4c:	00 00 00 
  800b4f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b56:	00 00 00 
  800b59:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b5d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800b64:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b6b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800b72:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800b79:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800b80:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800b87:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800b8e:	48 89 c7             	mov    %rax,%rdi
  800b91:	48 b8 e6 05 80 00 00 	movabs $0x8005e6,%rax
  800b98:	00 00 00 
  800b9b:	ff d0                	callq  *%rax
	va_end(ap);
}
  800b9d:	90                   	nop
  800b9e:	c9                   	leaveq 
  800b9f:	c3                   	retq   

0000000000800ba0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ba0:	55                   	push   %rbp
  800ba1:	48 89 e5             	mov    %rsp,%rbp
  800ba4:	48 83 ec 10          	sub    $0x10,%rsp
  800ba8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800baf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bb3:	8b 40 10             	mov    0x10(%rax),%eax
  800bb6:	8d 50 01             	lea    0x1(%rax),%edx
  800bb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bbd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800bc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bc4:	48 8b 10             	mov    (%rax),%rdx
  800bc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bcb:	48 8b 40 08          	mov    0x8(%rax),%rax
  800bcf:	48 39 c2             	cmp    %rax,%rdx
  800bd2:	73 17                	jae    800beb <sprintputch+0x4b>
		*b->buf++ = ch;
  800bd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bd8:	48 8b 00             	mov    (%rax),%rax
  800bdb:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800bdf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800be3:	48 89 0a             	mov    %rcx,(%rdx)
  800be6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800be9:	88 10                	mov    %dl,(%rax)
}
  800beb:	90                   	nop
  800bec:	c9                   	leaveq 
  800bed:	c3                   	retq   

0000000000800bee <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bee:	55                   	push   %rbp
  800bef:	48 89 e5             	mov    %rsp,%rbp
  800bf2:	48 83 ec 50          	sub    $0x50,%rsp
  800bf6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800bfa:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800bfd:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c01:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c05:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c09:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c0d:	48 8b 0a             	mov    (%rdx),%rcx
  800c10:	48 89 08             	mov    %rcx,(%rax)
  800c13:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c17:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c1b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c1f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c23:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c27:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c2b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c2e:	48 98                	cltq   
  800c30:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c34:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c38:	48 01 d0             	add    %rdx,%rax
  800c3b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c3f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c46:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c4b:	74 06                	je     800c53 <vsnprintf+0x65>
  800c4d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c51:	7f 07                	jg     800c5a <vsnprintf+0x6c>
		return -E_INVAL;
  800c53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c58:	eb 2f                	jmp    800c89 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c5a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c5e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800c62:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c66:	48 89 c6             	mov    %rax,%rsi
  800c69:	48 bf a0 0b 80 00 00 	movabs $0x800ba0,%rdi
  800c70:	00 00 00 
  800c73:	48 b8 e6 05 80 00 00 	movabs $0x8005e6,%rax
  800c7a:	00 00 00 
  800c7d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800c7f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c83:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800c86:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800c89:	c9                   	leaveq 
  800c8a:	c3                   	retq   

0000000000800c8b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c8b:	55                   	push   %rbp
  800c8c:	48 89 e5             	mov    %rsp,%rbp
  800c8f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800c96:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800c9d:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ca3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800caa:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cb1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cb8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cbf:	84 c0                	test   %al,%al
  800cc1:	74 20                	je     800ce3 <snprintf+0x58>
  800cc3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cc7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ccb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ccf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cd3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cd7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cdb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800cdf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ce3:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800cea:	00 00 00 
  800ced:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800cf4:	00 00 00 
  800cf7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cfb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d02:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d09:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d10:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d17:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d1e:	48 8b 0a             	mov    (%rdx),%rcx
  800d21:	48 89 08             	mov    %rcx,(%rax)
  800d24:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d28:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d2c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d30:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d34:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d3b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d42:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d48:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d4f:	48 89 c7             	mov    %rax,%rdi
  800d52:	48 b8 ee 0b 80 00 00 	movabs $0x800bee,%rax
  800d59:	00 00 00 
  800d5c:	ff d0                	callq  *%rax
  800d5e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800d64:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800d6a:	c9                   	leaveq 
  800d6b:	c3                   	retq   

0000000000800d6c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d6c:	55                   	push   %rbp
  800d6d:	48 89 e5             	mov    %rsp,%rbp
  800d70:	48 83 ec 18          	sub    $0x18,%rsp
  800d74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800d78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800d7f:	eb 09                	jmp    800d8a <strlen+0x1e>
		n++;
  800d81:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d85:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800d8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d8e:	0f b6 00             	movzbl (%rax),%eax
  800d91:	84 c0                	test   %al,%al
  800d93:	75 ec                	jne    800d81 <strlen+0x15>
		n++;
	return n;
  800d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800d98:	c9                   	leaveq 
  800d99:	c3                   	retq   

0000000000800d9a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d9a:	55                   	push   %rbp
  800d9b:	48 89 e5             	mov    %rsp,%rbp
  800d9e:	48 83 ec 20          	sub    $0x20,%rsp
  800da2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800da6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800daa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800db1:	eb 0e                	jmp    800dc1 <strnlen+0x27>
		n++;
  800db3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800db7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dbc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800dc1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800dc6:	74 0b                	je     800dd3 <strnlen+0x39>
  800dc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dcc:	0f b6 00             	movzbl (%rax),%eax
  800dcf:	84 c0                	test   %al,%al
  800dd1:	75 e0                	jne    800db3 <strnlen+0x19>
		n++;
	return n;
  800dd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dd6:	c9                   	leaveq 
  800dd7:	c3                   	retq   

0000000000800dd8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dd8:	55                   	push   %rbp
  800dd9:	48 89 e5             	mov    %rsp,%rbp
  800ddc:	48 83 ec 20          	sub    $0x20,%rsp
  800de0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800de4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800de8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800df0:	90                   	nop
  800df1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800df9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800dfd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e01:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e05:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e09:	0f b6 12             	movzbl (%rdx),%edx
  800e0c:	88 10                	mov    %dl,(%rax)
  800e0e:	0f b6 00             	movzbl (%rax),%eax
  800e11:	84 c0                	test   %al,%al
  800e13:	75 dc                	jne    800df1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e19:	c9                   	leaveq 
  800e1a:	c3                   	retq   

0000000000800e1b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e1b:	55                   	push   %rbp
  800e1c:	48 89 e5             	mov    %rsp,%rbp
  800e1f:	48 83 ec 20          	sub    $0x20,%rsp
  800e23:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e27:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2f:	48 89 c7             	mov    %rax,%rdi
  800e32:	48 b8 6c 0d 80 00 00 	movabs $0x800d6c,%rax
  800e39:	00 00 00 
  800e3c:	ff d0                	callq  *%rax
  800e3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e44:	48 63 d0             	movslq %eax,%rdx
  800e47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4b:	48 01 c2             	add    %rax,%rdx
  800e4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e52:	48 89 c6             	mov    %rax,%rsi
  800e55:	48 89 d7             	mov    %rdx,%rdi
  800e58:	48 b8 d8 0d 80 00 00 	movabs $0x800dd8,%rax
  800e5f:	00 00 00 
  800e62:	ff d0                	callq  *%rax
	return dst;
  800e64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800e68:	c9                   	leaveq 
  800e69:	c3                   	retq   

0000000000800e6a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e6a:	55                   	push   %rbp
  800e6b:	48 89 e5             	mov    %rsp,%rbp
  800e6e:	48 83 ec 28          	sub    $0x28,%rsp
  800e72:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e7a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e82:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800e86:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800e8d:	00 
  800e8e:	eb 2a                	jmp    800eba <strncpy+0x50>
		*dst++ = *src;
  800e90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e94:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e98:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e9c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ea0:	0f b6 12             	movzbl (%rdx),%edx
  800ea3:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ea5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ea9:	0f b6 00             	movzbl (%rax),%eax
  800eac:	84 c0                	test   %al,%al
  800eae:	74 05                	je     800eb5 <strncpy+0x4b>
			src++;
  800eb0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eb5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800eba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ebe:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ec2:	72 cc                	jb     800e90 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800ec8:	c9                   	leaveq 
  800ec9:	c3                   	retq   

0000000000800eca <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800eca:	55                   	push   %rbp
  800ecb:	48 89 e5             	mov    %rsp,%rbp
  800ece:	48 83 ec 28          	sub    $0x28,%rsp
  800ed2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ed6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800eda:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800ede:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800ee6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800eeb:	74 3d                	je     800f2a <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800eed:	eb 1d                	jmp    800f0c <strlcpy+0x42>
			*dst++ = *src++;
  800eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ef7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800efb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800eff:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f03:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f07:	0f b6 12             	movzbl (%rdx),%edx
  800f0a:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f0c:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f11:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f16:	74 0b                	je     800f23 <strlcpy+0x59>
  800f18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f1c:	0f b6 00             	movzbl (%rax),%eax
  800f1f:	84 c0                	test   %al,%al
  800f21:	75 cc                	jne    800eef <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f27:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f2a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f32:	48 29 c2             	sub    %rax,%rdx
  800f35:	48 89 d0             	mov    %rdx,%rax
}
  800f38:	c9                   	leaveq 
  800f39:	c3                   	retq   

0000000000800f3a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f3a:	55                   	push   %rbp
  800f3b:	48 89 e5             	mov    %rsp,%rbp
  800f3e:	48 83 ec 10          	sub    $0x10,%rsp
  800f42:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f46:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f4a:	eb 0a                	jmp    800f56 <strcmp+0x1c>
		p++, q++;
  800f4c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f51:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f5a:	0f b6 00             	movzbl (%rax),%eax
  800f5d:	84 c0                	test   %al,%al
  800f5f:	74 12                	je     800f73 <strcmp+0x39>
  800f61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f65:	0f b6 10             	movzbl (%rax),%edx
  800f68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6c:	0f b6 00             	movzbl (%rax),%eax
  800f6f:	38 c2                	cmp    %al,%dl
  800f71:	74 d9                	je     800f4c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f77:	0f b6 00             	movzbl (%rax),%eax
  800f7a:	0f b6 d0             	movzbl %al,%edx
  800f7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f81:	0f b6 00             	movzbl (%rax),%eax
  800f84:	0f b6 c0             	movzbl %al,%eax
  800f87:	29 c2                	sub    %eax,%edx
  800f89:	89 d0                	mov    %edx,%eax
}
  800f8b:	c9                   	leaveq 
  800f8c:	c3                   	retq   

0000000000800f8d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800f8d:	55                   	push   %rbp
  800f8e:	48 89 e5             	mov    %rsp,%rbp
  800f91:	48 83 ec 18          	sub    $0x18,%rsp
  800f95:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f99:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800f9d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fa1:	eb 0f                	jmp    800fb2 <strncmp+0x25>
		n--, p++, q++;
  800fa3:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fa8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fad:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800fb2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fb7:	74 1d                	je     800fd6 <strncmp+0x49>
  800fb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fbd:	0f b6 00             	movzbl (%rax),%eax
  800fc0:	84 c0                	test   %al,%al
  800fc2:	74 12                	je     800fd6 <strncmp+0x49>
  800fc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc8:	0f b6 10             	movzbl (%rax),%edx
  800fcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcf:	0f b6 00             	movzbl (%rax),%eax
  800fd2:	38 c2                	cmp    %al,%dl
  800fd4:	74 cd                	je     800fa3 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  800fd6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fdb:	75 07                	jne    800fe4 <strncmp+0x57>
		return 0;
  800fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe2:	eb 18                	jmp    800ffc <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fe4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fe8:	0f b6 00             	movzbl (%rax),%eax
  800feb:	0f b6 d0             	movzbl %al,%edx
  800fee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff2:	0f b6 00             	movzbl (%rax),%eax
  800ff5:	0f b6 c0             	movzbl %al,%eax
  800ff8:	29 c2                	sub    %eax,%edx
  800ffa:	89 d0                	mov    %edx,%eax
}
  800ffc:	c9                   	leaveq 
  800ffd:	c3                   	retq   

0000000000800ffe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ffe:	55                   	push   %rbp
  800fff:	48 89 e5             	mov    %rsp,%rbp
  801002:	48 83 ec 10          	sub    $0x10,%rsp
  801006:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80100a:	89 f0                	mov    %esi,%eax
  80100c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80100f:	eb 17                	jmp    801028 <strchr+0x2a>
		if (*s == c)
  801011:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801015:	0f b6 00             	movzbl (%rax),%eax
  801018:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80101b:	75 06                	jne    801023 <strchr+0x25>
			return (char *) s;
  80101d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801021:	eb 15                	jmp    801038 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801023:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801028:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102c:	0f b6 00             	movzbl (%rax),%eax
  80102f:	84 c0                	test   %al,%al
  801031:	75 de                	jne    801011 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801033:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801038:	c9                   	leaveq 
  801039:	c3                   	retq   

000000000080103a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80103a:	55                   	push   %rbp
  80103b:	48 89 e5             	mov    %rsp,%rbp
  80103e:	48 83 ec 10          	sub    $0x10,%rsp
  801042:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801046:	89 f0                	mov    %esi,%eax
  801048:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80104b:	eb 11                	jmp    80105e <strfind+0x24>
		if (*s == c)
  80104d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801051:	0f b6 00             	movzbl (%rax),%eax
  801054:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801057:	74 12                	je     80106b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801059:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80105e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801062:	0f b6 00             	movzbl (%rax),%eax
  801065:	84 c0                	test   %al,%al
  801067:	75 e4                	jne    80104d <strfind+0x13>
  801069:	eb 01                	jmp    80106c <strfind+0x32>
		if (*s == c)
			break;
  80106b:	90                   	nop
	return (char *) s;
  80106c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801070:	c9                   	leaveq 
  801071:	c3                   	retq   

0000000000801072 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801072:	55                   	push   %rbp
  801073:	48 89 e5             	mov    %rsp,%rbp
  801076:	48 83 ec 18          	sub    $0x18,%rsp
  80107a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80107e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801081:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801085:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80108a:	75 06                	jne    801092 <memset+0x20>
		return v;
  80108c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801090:	eb 69                	jmp    8010fb <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801092:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801096:	83 e0 03             	and    $0x3,%eax
  801099:	48 85 c0             	test   %rax,%rax
  80109c:	75 48                	jne    8010e6 <memset+0x74>
  80109e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a2:	83 e0 03             	and    $0x3,%eax
  8010a5:	48 85 c0             	test   %rax,%rax
  8010a8:	75 3c                	jne    8010e6 <memset+0x74>
		c &= 0xFF;
  8010aa:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010b4:	c1 e0 18             	shl    $0x18,%eax
  8010b7:	89 c2                	mov    %eax,%edx
  8010b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010bc:	c1 e0 10             	shl    $0x10,%eax
  8010bf:	09 c2                	or     %eax,%edx
  8010c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010c4:	c1 e0 08             	shl    $0x8,%eax
  8010c7:	09 d0                	or     %edx,%eax
  8010c9:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8010cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d0:	48 c1 e8 02          	shr    $0x2,%rax
  8010d4:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8010d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8010db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010de:	48 89 d7             	mov    %rdx,%rdi
  8010e1:	fc                   	cld    
  8010e2:	f3 ab                	rep stos %eax,%es:(%rdi)
  8010e4:	eb 11                	jmp    8010f7 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8010e6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8010ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010ed:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8010f1:	48 89 d7             	mov    %rdx,%rdi
  8010f4:	fc                   	cld    
  8010f5:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8010f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010fb:	c9                   	leaveq 
  8010fc:	c3                   	retq   

00000000008010fd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8010fd:	55                   	push   %rbp
  8010fe:	48 89 e5             	mov    %rsp,%rbp
  801101:	48 83 ec 28          	sub    $0x28,%rsp
  801105:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801109:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80110d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801111:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801115:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801119:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801121:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801125:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801129:	0f 83 88 00 00 00    	jae    8011b7 <memmove+0xba>
  80112f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801133:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801137:	48 01 d0             	add    %rdx,%rax
  80113a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80113e:	76 77                	jbe    8011b7 <memmove+0xba>
		s += n;
  801140:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801144:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801148:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80114c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801150:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801154:	83 e0 03             	and    $0x3,%eax
  801157:	48 85 c0             	test   %rax,%rax
  80115a:	75 3b                	jne    801197 <memmove+0x9a>
  80115c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801160:	83 e0 03             	and    $0x3,%eax
  801163:	48 85 c0             	test   %rax,%rax
  801166:	75 2f                	jne    801197 <memmove+0x9a>
  801168:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80116c:	83 e0 03             	and    $0x3,%eax
  80116f:	48 85 c0             	test   %rax,%rax
  801172:	75 23                	jne    801197 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801178:	48 83 e8 04          	sub    $0x4,%rax
  80117c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801180:	48 83 ea 04          	sub    $0x4,%rdx
  801184:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801188:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80118c:	48 89 c7             	mov    %rax,%rdi
  80118f:	48 89 d6             	mov    %rdx,%rsi
  801192:	fd                   	std    
  801193:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801195:	eb 1d                	jmp    8011b4 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801197:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80119f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011ab:	48 89 d7             	mov    %rdx,%rdi
  8011ae:	48 89 c1             	mov    %rax,%rcx
  8011b1:	fd                   	std    
  8011b2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011b4:	fc                   	cld    
  8011b5:	eb 57                	jmp    80120e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bb:	83 e0 03             	and    $0x3,%eax
  8011be:	48 85 c0             	test   %rax,%rax
  8011c1:	75 36                	jne    8011f9 <memmove+0xfc>
  8011c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c7:	83 e0 03             	and    $0x3,%eax
  8011ca:	48 85 c0             	test   %rax,%rax
  8011cd:	75 2a                	jne    8011f9 <memmove+0xfc>
  8011cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d3:	83 e0 03             	and    $0x3,%eax
  8011d6:	48 85 c0             	test   %rax,%rax
  8011d9:	75 1e                	jne    8011f9 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8011db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011df:	48 c1 e8 02          	shr    $0x2,%rax
  8011e3:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8011e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ee:	48 89 c7             	mov    %rax,%rdi
  8011f1:	48 89 d6             	mov    %rdx,%rsi
  8011f4:	fc                   	cld    
  8011f5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011f7:	eb 15                	jmp    80120e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8011f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801201:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801205:	48 89 c7             	mov    %rax,%rdi
  801208:	48 89 d6             	mov    %rdx,%rsi
  80120b:	fc                   	cld    
  80120c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80120e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801212:	c9                   	leaveq 
  801213:	c3                   	retq   

0000000000801214 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801214:	55                   	push   %rbp
  801215:	48 89 e5             	mov    %rsp,%rbp
  801218:	48 83 ec 18          	sub    $0x18,%rsp
  80121c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801220:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801224:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801228:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80122c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801230:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801234:	48 89 ce             	mov    %rcx,%rsi
  801237:	48 89 c7             	mov    %rax,%rdi
  80123a:	48 b8 fd 10 80 00 00 	movabs $0x8010fd,%rax
  801241:	00 00 00 
  801244:	ff d0                	callq  *%rax
}
  801246:	c9                   	leaveq 
  801247:	c3                   	retq   

0000000000801248 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801248:	55                   	push   %rbp
  801249:	48 89 e5             	mov    %rsp,%rbp
  80124c:	48 83 ec 28          	sub    $0x28,%rsp
  801250:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801254:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801258:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80125c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801260:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801264:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801268:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80126c:	eb 36                	jmp    8012a4 <memcmp+0x5c>
		if (*s1 != *s2)
  80126e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801272:	0f b6 10             	movzbl (%rax),%edx
  801275:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801279:	0f b6 00             	movzbl (%rax),%eax
  80127c:	38 c2                	cmp    %al,%dl
  80127e:	74 1a                	je     80129a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801284:	0f b6 00             	movzbl (%rax),%eax
  801287:	0f b6 d0             	movzbl %al,%edx
  80128a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128e:	0f b6 00             	movzbl (%rax),%eax
  801291:	0f b6 c0             	movzbl %al,%eax
  801294:	29 c2                	sub    %eax,%edx
  801296:	89 d0                	mov    %edx,%eax
  801298:	eb 20                	jmp    8012ba <memcmp+0x72>
		s1++, s2++;
  80129a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80129f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012b0:	48 85 c0             	test   %rax,%rax
  8012b3:	75 b9                	jne    80126e <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ba:	c9                   	leaveq 
  8012bb:	c3                   	retq   

00000000008012bc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012bc:	55                   	push   %rbp
  8012bd:	48 89 e5             	mov    %rsp,%rbp
  8012c0:	48 83 ec 28          	sub    $0x28,%rsp
  8012c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8012cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d7:	48 01 d0             	add    %rdx,%rax
  8012da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8012de:	eb 19                	jmp    8012f9 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e4:	0f b6 00             	movzbl (%rax),%eax
  8012e7:	0f b6 d0             	movzbl %al,%edx
  8012ea:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8012ed:	0f b6 c0             	movzbl %al,%eax
  8012f0:	39 c2                	cmp    %eax,%edx
  8012f2:	74 11                	je     801305 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8012f4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fd:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801301:	72 dd                	jb     8012e0 <memfind+0x24>
  801303:	eb 01                	jmp    801306 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801305:	90                   	nop
	return (void *) s;
  801306:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80130a:	c9                   	leaveq 
  80130b:	c3                   	retq   

000000000080130c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80130c:	55                   	push   %rbp
  80130d:	48 89 e5             	mov    %rsp,%rbp
  801310:	48 83 ec 38          	sub    $0x38,%rsp
  801314:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801318:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80131c:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80131f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801326:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80132d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80132e:	eb 05                	jmp    801335 <strtol+0x29>
		s++;
  801330:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801335:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801339:	0f b6 00             	movzbl (%rax),%eax
  80133c:	3c 20                	cmp    $0x20,%al
  80133e:	74 f0                	je     801330 <strtol+0x24>
  801340:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801344:	0f b6 00             	movzbl (%rax),%eax
  801347:	3c 09                	cmp    $0x9,%al
  801349:	74 e5                	je     801330 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80134b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80134f:	0f b6 00             	movzbl (%rax),%eax
  801352:	3c 2b                	cmp    $0x2b,%al
  801354:	75 07                	jne    80135d <strtol+0x51>
		s++;
  801356:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80135b:	eb 17                	jmp    801374 <strtol+0x68>
	else if (*s == '-')
  80135d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801361:	0f b6 00             	movzbl (%rax),%eax
  801364:	3c 2d                	cmp    $0x2d,%al
  801366:	75 0c                	jne    801374 <strtol+0x68>
		s++, neg = 1;
  801368:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80136d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801374:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801378:	74 06                	je     801380 <strtol+0x74>
  80137a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80137e:	75 28                	jne    8013a8 <strtol+0x9c>
  801380:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801384:	0f b6 00             	movzbl (%rax),%eax
  801387:	3c 30                	cmp    $0x30,%al
  801389:	75 1d                	jne    8013a8 <strtol+0x9c>
  80138b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138f:	48 83 c0 01          	add    $0x1,%rax
  801393:	0f b6 00             	movzbl (%rax),%eax
  801396:	3c 78                	cmp    $0x78,%al
  801398:	75 0e                	jne    8013a8 <strtol+0x9c>
		s += 2, base = 16;
  80139a:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80139f:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013a6:	eb 2c                	jmp    8013d4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013a8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013ac:	75 19                	jne    8013c7 <strtol+0xbb>
  8013ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b2:	0f b6 00             	movzbl (%rax),%eax
  8013b5:	3c 30                	cmp    $0x30,%al
  8013b7:	75 0e                	jne    8013c7 <strtol+0xbb>
		s++, base = 8;
  8013b9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013be:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013c5:	eb 0d                	jmp    8013d4 <strtol+0xc8>
	else if (base == 0)
  8013c7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013cb:	75 07                	jne    8013d4 <strtol+0xc8>
		base = 10;
  8013cd:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d8:	0f b6 00             	movzbl (%rax),%eax
  8013db:	3c 2f                	cmp    $0x2f,%al
  8013dd:	7e 1d                	jle    8013fc <strtol+0xf0>
  8013df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e3:	0f b6 00             	movzbl (%rax),%eax
  8013e6:	3c 39                	cmp    $0x39,%al
  8013e8:	7f 12                	jg     8013fc <strtol+0xf0>
			dig = *s - '0';
  8013ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ee:	0f b6 00             	movzbl (%rax),%eax
  8013f1:	0f be c0             	movsbl %al,%eax
  8013f4:	83 e8 30             	sub    $0x30,%eax
  8013f7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8013fa:	eb 4e                	jmp    80144a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8013fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801400:	0f b6 00             	movzbl (%rax),%eax
  801403:	3c 60                	cmp    $0x60,%al
  801405:	7e 1d                	jle    801424 <strtol+0x118>
  801407:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140b:	0f b6 00             	movzbl (%rax),%eax
  80140e:	3c 7a                	cmp    $0x7a,%al
  801410:	7f 12                	jg     801424 <strtol+0x118>
			dig = *s - 'a' + 10;
  801412:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801416:	0f b6 00             	movzbl (%rax),%eax
  801419:	0f be c0             	movsbl %al,%eax
  80141c:	83 e8 57             	sub    $0x57,%eax
  80141f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801422:	eb 26                	jmp    80144a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801424:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801428:	0f b6 00             	movzbl (%rax),%eax
  80142b:	3c 40                	cmp    $0x40,%al
  80142d:	7e 47                	jle    801476 <strtol+0x16a>
  80142f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801433:	0f b6 00             	movzbl (%rax),%eax
  801436:	3c 5a                	cmp    $0x5a,%al
  801438:	7f 3c                	jg     801476 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80143a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143e:	0f b6 00             	movzbl (%rax),%eax
  801441:	0f be c0             	movsbl %al,%eax
  801444:	83 e8 37             	sub    $0x37,%eax
  801447:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80144a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80144d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801450:	7d 23                	jge    801475 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801452:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801457:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80145a:	48 98                	cltq   
  80145c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801461:	48 89 c2             	mov    %rax,%rdx
  801464:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801467:	48 98                	cltq   
  801469:	48 01 d0             	add    %rdx,%rax
  80146c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801470:	e9 5f ff ff ff       	jmpq   8013d4 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801475:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801476:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80147b:	74 0b                	je     801488 <strtol+0x17c>
		*endptr = (char *) s;
  80147d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801481:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801485:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801488:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80148c:	74 09                	je     801497 <strtol+0x18b>
  80148e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801492:	48 f7 d8             	neg    %rax
  801495:	eb 04                	jmp    80149b <strtol+0x18f>
  801497:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80149b:	c9                   	leaveq 
  80149c:	c3                   	retq   

000000000080149d <strstr>:

char * strstr(const char *in, const char *str)
{
  80149d:	55                   	push   %rbp
  80149e:	48 89 e5             	mov    %rsp,%rbp
  8014a1:	48 83 ec 30          	sub    $0x30,%rsp
  8014a5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014b1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014b5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014b9:	0f b6 00             	movzbl (%rax),%eax
  8014bc:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014bf:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014c3:	75 06                	jne    8014cb <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8014c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c9:	eb 6b                	jmp    801536 <strstr+0x99>

	len = strlen(str);
  8014cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014cf:	48 89 c7             	mov    %rax,%rdi
  8014d2:	48 b8 6c 0d 80 00 00 	movabs $0x800d6c,%rax
  8014d9:	00 00 00 
  8014dc:	ff d0                	callq  *%rax
  8014de:	48 98                	cltq   
  8014e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8014e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014f0:	0f b6 00             	movzbl (%rax),%eax
  8014f3:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8014f6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8014fa:	75 07                	jne    801503 <strstr+0x66>
				return (char *) 0;
  8014fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801501:	eb 33                	jmp    801536 <strstr+0x99>
		} while (sc != c);
  801503:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801507:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80150a:	75 d8                	jne    8014e4 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80150c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801510:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801514:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801518:	48 89 ce             	mov    %rcx,%rsi
  80151b:	48 89 c7             	mov    %rax,%rdi
  80151e:	48 b8 8d 0f 80 00 00 	movabs $0x800f8d,%rax
  801525:	00 00 00 
  801528:	ff d0                	callq  *%rax
  80152a:	85 c0                	test   %eax,%eax
  80152c:	75 b6                	jne    8014e4 <strstr+0x47>

	return (char *) (in - 1);
  80152e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801532:	48 83 e8 01          	sub    $0x1,%rax
}
  801536:	c9                   	leaveq 
  801537:	c3                   	retq   

0000000000801538 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801538:	55                   	push   %rbp
  801539:	48 89 e5             	mov    %rsp,%rbp
  80153c:	53                   	push   %rbx
  80153d:	48 83 ec 48          	sub    $0x48,%rsp
  801541:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801544:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801547:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80154b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80154f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801553:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801557:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80155a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80155e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801562:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801566:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80156a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80156e:	4c 89 c3             	mov    %r8,%rbx
  801571:	cd 30                	int    $0x30
  801573:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801577:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80157b:	74 3e                	je     8015bb <syscall+0x83>
  80157d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801582:	7e 37                	jle    8015bb <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801584:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801588:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80158b:	49 89 d0             	mov    %rdx,%r8
  80158e:	89 c1                	mov    %eax,%ecx
  801590:	48 ba c8 1e 80 00 00 	movabs $0x801ec8,%rdx
  801597:	00 00 00 
  80159a:	be 23 00 00 00       	mov    $0x23,%esi
  80159f:	48 bf e5 1e 80 00 00 	movabs $0x801ee5,%rdi
  8015a6:	00 00 00 
  8015a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ae:	49 b9 42 19 80 00 00 	movabs $0x801942,%r9
  8015b5:	00 00 00 
  8015b8:	41 ff d1             	callq  *%r9

	return ret;
  8015bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015bf:	48 83 c4 48          	add    $0x48,%rsp
  8015c3:	5b                   	pop    %rbx
  8015c4:	5d                   	pop    %rbp
  8015c5:	c3                   	retq   

00000000008015c6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8015c6:	55                   	push   %rbp
  8015c7:	48 89 e5             	mov    %rsp,%rbp
  8015ca:	48 83 ec 10          	sub    $0x10,%rsp
  8015ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8015d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015de:	48 83 ec 08          	sub    $0x8,%rsp
  8015e2:	6a 00                	pushq  $0x0
  8015e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8015ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8015f0:	48 89 d1             	mov    %rdx,%rcx
  8015f3:	48 89 c2             	mov    %rax,%rdx
  8015f6:	be 00 00 00 00       	mov    $0x0,%esi
  8015fb:	bf 00 00 00 00       	mov    $0x0,%edi
  801600:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  801607:	00 00 00 
  80160a:	ff d0                	callq  *%rax
  80160c:	48 83 c4 10          	add    $0x10,%rsp
}
  801610:	90                   	nop
  801611:	c9                   	leaveq 
  801612:	c3                   	retq   

0000000000801613 <sys_cgetc>:

int
sys_cgetc(void)
{
  801613:	55                   	push   %rbp
  801614:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801617:	48 83 ec 08          	sub    $0x8,%rsp
  80161b:	6a 00                	pushq  $0x0
  80161d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801623:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801629:	b9 00 00 00 00       	mov    $0x0,%ecx
  80162e:	ba 00 00 00 00       	mov    $0x0,%edx
  801633:	be 00 00 00 00       	mov    $0x0,%esi
  801638:	bf 01 00 00 00       	mov    $0x1,%edi
  80163d:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  801644:	00 00 00 
  801647:	ff d0                	callq  *%rax
  801649:	48 83 c4 10          	add    $0x10,%rsp
}
  80164d:	c9                   	leaveq 
  80164e:	c3                   	retq   

000000000080164f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80164f:	55                   	push   %rbp
  801650:	48 89 e5             	mov    %rsp,%rbp
  801653:	48 83 ec 10          	sub    $0x10,%rsp
  801657:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80165a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80165d:	48 98                	cltq   
  80165f:	48 83 ec 08          	sub    $0x8,%rsp
  801663:	6a 00                	pushq  $0x0
  801665:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80166b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801671:	b9 00 00 00 00       	mov    $0x0,%ecx
  801676:	48 89 c2             	mov    %rax,%rdx
  801679:	be 01 00 00 00       	mov    $0x1,%esi
  80167e:	bf 03 00 00 00       	mov    $0x3,%edi
  801683:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  80168a:	00 00 00 
  80168d:	ff d0                	callq  *%rax
  80168f:	48 83 c4 10          	add    $0x10,%rsp
}
  801693:	c9                   	leaveq 
  801694:	c3                   	retq   

0000000000801695 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801695:	55                   	push   %rbp
  801696:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801699:	48 83 ec 08          	sub    $0x8,%rsp
  80169d:	6a 00                	pushq  $0x0
  80169f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b5:	be 00 00 00 00       	mov    $0x0,%esi
  8016ba:	bf 02 00 00 00       	mov    $0x2,%edi
  8016bf:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  8016c6:	00 00 00 
  8016c9:	ff d0                	callq  *%rax
  8016cb:	48 83 c4 10          	add    $0x10,%rsp
}
  8016cf:	c9                   	leaveq 
  8016d0:	c3                   	retq   

00000000008016d1 <sys_yield>:

void
sys_yield(void)
{
  8016d1:	55                   	push   %rbp
  8016d2:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8016d5:	48 83 ec 08          	sub    $0x8,%rsp
  8016d9:	6a 00                	pushq  $0x0
  8016db:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016e1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f1:	be 00 00 00 00       	mov    $0x0,%esi
  8016f6:	bf 0a 00 00 00       	mov    $0xa,%edi
  8016fb:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  801702:	00 00 00 
  801705:	ff d0                	callq  *%rax
  801707:	48 83 c4 10          	add    $0x10,%rsp
}
  80170b:	90                   	nop
  80170c:	c9                   	leaveq 
  80170d:	c3                   	retq   

000000000080170e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80170e:	55                   	push   %rbp
  80170f:	48 89 e5             	mov    %rsp,%rbp
  801712:	48 83 ec 10          	sub    $0x10,%rsp
  801716:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801719:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80171d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801720:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801723:	48 63 c8             	movslq %eax,%rcx
  801726:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80172a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80172d:	48 98                	cltq   
  80172f:	48 83 ec 08          	sub    $0x8,%rsp
  801733:	6a 00                	pushq  $0x0
  801735:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80173b:	49 89 c8             	mov    %rcx,%r8
  80173e:	48 89 d1             	mov    %rdx,%rcx
  801741:	48 89 c2             	mov    %rax,%rdx
  801744:	be 01 00 00 00       	mov    $0x1,%esi
  801749:	bf 04 00 00 00       	mov    $0x4,%edi
  80174e:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  801755:	00 00 00 
  801758:	ff d0                	callq  *%rax
  80175a:	48 83 c4 10          	add    $0x10,%rsp
}
  80175e:	c9                   	leaveq 
  80175f:	c3                   	retq   

0000000000801760 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801760:	55                   	push   %rbp
  801761:	48 89 e5             	mov    %rsp,%rbp
  801764:	48 83 ec 20          	sub    $0x20,%rsp
  801768:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80176b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80176f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801772:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801776:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80177a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80177d:	48 63 c8             	movslq %eax,%rcx
  801780:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801784:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801787:	48 63 f0             	movslq %eax,%rsi
  80178a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80178e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801791:	48 98                	cltq   
  801793:	48 83 ec 08          	sub    $0x8,%rsp
  801797:	51                   	push   %rcx
  801798:	49 89 f9             	mov    %rdi,%r9
  80179b:	49 89 f0             	mov    %rsi,%r8
  80179e:	48 89 d1             	mov    %rdx,%rcx
  8017a1:	48 89 c2             	mov    %rax,%rdx
  8017a4:	be 01 00 00 00       	mov    $0x1,%esi
  8017a9:	bf 05 00 00 00       	mov    $0x5,%edi
  8017ae:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  8017b5:	00 00 00 
  8017b8:	ff d0                	callq  *%rax
  8017ba:	48 83 c4 10          	add    $0x10,%rsp
}
  8017be:	c9                   	leaveq 
  8017bf:	c3                   	retq   

00000000008017c0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8017c0:	55                   	push   %rbp
  8017c1:	48 89 e5             	mov    %rsp,%rbp
  8017c4:	48 83 ec 10          	sub    $0x10,%rsp
  8017c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8017cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017d6:	48 98                	cltq   
  8017d8:	48 83 ec 08          	sub    $0x8,%rsp
  8017dc:	6a 00                	pushq  $0x0
  8017de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017ea:	48 89 d1             	mov    %rdx,%rcx
  8017ed:	48 89 c2             	mov    %rax,%rdx
  8017f0:	be 01 00 00 00       	mov    $0x1,%esi
  8017f5:	bf 06 00 00 00       	mov    $0x6,%edi
  8017fa:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  801801:	00 00 00 
  801804:	ff d0                	callq  *%rax
  801806:	48 83 c4 10          	add    $0x10,%rsp
}
  80180a:	c9                   	leaveq 
  80180b:	c3                   	retq   

000000000080180c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80180c:	55                   	push   %rbp
  80180d:	48 89 e5             	mov    %rsp,%rbp
  801810:	48 83 ec 10          	sub    $0x10,%rsp
  801814:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801817:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80181a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80181d:	48 63 d0             	movslq %eax,%rdx
  801820:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801823:	48 98                	cltq   
  801825:	48 83 ec 08          	sub    $0x8,%rsp
  801829:	6a 00                	pushq  $0x0
  80182b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801831:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801837:	48 89 d1             	mov    %rdx,%rcx
  80183a:	48 89 c2             	mov    %rax,%rdx
  80183d:	be 01 00 00 00       	mov    $0x1,%esi
  801842:	bf 08 00 00 00       	mov    $0x8,%edi
  801847:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  80184e:	00 00 00 
  801851:	ff d0                	callq  *%rax
  801853:	48 83 c4 10          	add    $0x10,%rsp
}
  801857:	c9                   	leaveq 
  801858:	c3                   	retq   

0000000000801859 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801859:	55                   	push   %rbp
  80185a:	48 89 e5             	mov    %rsp,%rbp
  80185d:	48 83 ec 10          	sub    $0x10,%rsp
  801861:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801864:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801868:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80186c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80186f:	48 98                	cltq   
  801871:	48 83 ec 08          	sub    $0x8,%rsp
  801875:	6a 00                	pushq  $0x0
  801877:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80187d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801883:	48 89 d1             	mov    %rdx,%rcx
  801886:	48 89 c2             	mov    %rax,%rdx
  801889:	be 01 00 00 00       	mov    $0x1,%esi
  80188e:	bf 09 00 00 00       	mov    $0x9,%edi
  801893:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  80189a:	00 00 00 
  80189d:	ff d0                	callq  *%rax
  80189f:	48 83 c4 10          	add    $0x10,%rsp
}
  8018a3:	c9                   	leaveq 
  8018a4:	c3                   	retq   

00000000008018a5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8018a5:	55                   	push   %rbp
  8018a6:	48 89 e5             	mov    %rsp,%rbp
  8018a9:	48 83 ec 20          	sub    $0x20,%rsp
  8018ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018b4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018b8:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8018bb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018be:	48 63 f0             	movslq %eax,%rsi
  8018c1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8018c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c8:	48 98                	cltq   
  8018ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ce:	48 83 ec 08          	sub    $0x8,%rsp
  8018d2:	6a 00                	pushq  $0x0
  8018d4:	49 89 f1             	mov    %rsi,%r9
  8018d7:	49 89 c8             	mov    %rcx,%r8
  8018da:	48 89 d1             	mov    %rdx,%rcx
  8018dd:	48 89 c2             	mov    %rax,%rdx
  8018e0:	be 00 00 00 00       	mov    $0x0,%esi
  8018e5:	bf 0b 00 00 00       	mov    $0xb,%edi
  8018ea:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  8018f1:	00 00 00 
  8018f4:	ff d0                	callq  *%rax
  8018f6:	48 83 c4 10          	add    $0x10,%rsp
}
  8018fa:	c9                   	leaveq 
  8018fb:	c3                   	retq   

00000000008018fc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8018fc:	55                   	push   %rbp
  8018fd:	48 89 e5             	mov    %rsp,%rbp
  801900:	48 83 ec 10          	sub    $0x10,%rsp
  801904:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801908:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80190c:	48 83 ec 08          	sub    $0x8,%rsp
  801910:	6a 00                	pushq  $0x0
  801912:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801918:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80191e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801923:	48 89 c2             	mov    %rax,%rdx
  801926:	be 01 00 00 00       	mov    $0x1,%esi
  80192b:	bf 0c 00 00 00       	mov    $0xc,%edi
  801930:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  801937:	00 00 00 
  80193a:	ff d0                	callq  *%rax
  80193c:	48 83 c4 10          	add    $0x10,%rsp
}
  801940:	c9                   	leaveq 
  801941:	c3                   	retq   

0000000000801942 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801942:	55                   	push   %rbp
  801943:	48 89 e5             	mov    %rsp,%rbp
  801946:	53                   	push   %rbx
  801947:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80194e:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801955:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80195b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  801962:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801969:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801970:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801977:	84 c0                	test   %al,%al
  801979:	74 23                	je     80199e <_panic+0x5c>
  80197b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801982:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801986:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80198a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80198e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801992:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801996:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80199a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80199e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8019a5:	00 00 00 
  8019a8:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8019af:	00 00 00 
  8019b2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019b6:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8019bd:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8019c4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8019cb:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8019d2:	00 00 00 
  8019d5:	48 8b 18             	mov    (%rax),%rbx
  8019d8:	48 b8 95 16 80 00 00 	movabs $0x801695,%rax
  8019df:	00 00 00 
  8019e2:	ff d0                	callq  *%rax
  8019e4:	89 c6                	mov    %eax,%esi
  8019e6:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8019ec:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8019f3:	41 89 d0             	mov    %edx,%r8d
  8019f6:	48 89 c1             	mov    %rax,%rcx
  8019f9:	48 89 da             	mov    %rbx,%rdx
  8019fc:	48 bf f8 1e 80 00 00 	movabs $0x801ef8,%rdi
  801a03:	00 00 00 
  801a06:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0b:	49 b9 48 02 80 00 00 	movabs $0x800248,%r9
  801a12:	00 00 00 
  801a15:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a18:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801a1f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a26:	48 89 d6             	mov    %rdx,%rsi
  801a29:	48 89 c7             	mov    %rax,%rdi
  801a2c:	48 b8 9c 01 80 00 00 	movabs $0x80019c,%rax
  801a33:	00 00 00 
  801a36:	ff d0                	callq  *%rax
	cprintf("\n");
  801a38:	48 bf 1b 1f 80 00 00 	movabs $0x801f1b,%rdi
  801a3f:	00 00 00 
  801a42:	b8 00 00 00 00       	mov    $0x0,%eax
  801a47:	48 ba 48 02 80 00 00 	movabs $0x800248,%rdx
  801a4e:	00 00 00 
  801a51:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a53:	cc                   	int3   
  801a54:	eb fd                	jmp    801a53 <_panic+0x111>
