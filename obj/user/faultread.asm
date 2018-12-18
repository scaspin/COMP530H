
obj/user/faultread:     file format elf64-x86-64


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
  80003c:	e8 38 00 00 00       	callq  800079 <libmain>
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
	cprintf("I read %08x from location 0!\n", *(unsigned*)0);
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
  800057:	8b 00                	mov    (%rax),%eax
  800059:	89 c6                	mov    %eax,%esi
  80005b:	48 bf 60 1a 80 00 00 	movabs $0x801a60,%rdi
  800062:	00 00 00 
  800065:	b8 00 00 00 00       	mov    $0x0,%eax
  80006a:	48 ba 43 02 80 00 00 	movabs $0x800243,%rdx
  800071:	00 00 00 
  800074:	ff d2                	callq  *%rdx
}
  800076:	90                   	nop
  800077:	c9                   	leaveq 
  800078:	c3                   	retq   

0000000000800079 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800079:	55                   	push   %rbp
  80007a:	48 89 e5             	mov    %rsp,%rbp
  80007d:	48 83 ec 10          	sub    $0x10,%rsp
  800081:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800084:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  800088:	48 b8 90 16 80 00 00 	movabs $0x801690,%rax
  80008f:	00 00 00 
  800092:	ff d0                	callq  *%rax
  800094:	25 ff 03 00 00       	and    $0x3ff,%eax
  800099:	48 63 d0             	movslq %eax,%rdx
  80009c:	48 89 d0             	mov    %rdx,%rax
  80009f:	48 c1 e0 03          	shl    $0x3,%rax
  8000a3:	48 01 d0             	add    %rdx,%rax
  8000a6:	48 c1 e0 05          	shl    $0x5,%rax
  8000aa:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000b1:	00 00 00 
  8000b4:	48 01 c2             	add    %rax,%rdx
  8000b7:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000be:	00 00 00 
  8000c1:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c8:	7e 14                	jle    8000de <libmain+0x65>
		binaryname = argv[0];
  8000ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000ce:	48 8b 10             	mov    (%rax),%rdx
  8000d1:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000d8:	00 00 00 
  8000db:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000e5:	48 89 d6             	mov    %rdx,%rsi
  8000e8:	89 c7                	mov    %eax,%edi
  8000ea:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f1:	00 00 00 
  8000f4:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000f6:	48 b8 05 01 80 00 00 	movabs $0x800105,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
}
  800102:	90                   	nop
  800103:	c9                   	leaveq 
  800104:	c3                   	retq   

0000000000800105 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800105:	55                   	push   %rbp
  800106:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800109:	bf 00 00 00 00       	mov    $0x0,%edi
  80010e:	48 b8 4a 16 80 00 00 	movabs $0x80164a,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
}
  80011a:	90                   	nop
  80011b:	5d                   	pop    %rbp
  80011c:	c3                   	retq   

000000000080011d <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80011d:	55                   	push   %rbp
  80011e:	48 89 e5             	mov    %rsp,%rbp
  800121:	48 83 ec 10          	sub    $0x10,%rsp
  800125:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800128:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80012c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800130:	8b 00                	mov    (%rax),%eax
  800132:	8d 48 01             	lea    0x1(%rax),%ecx
  800135:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800139:	89 0a                	mov    %ecx,(%rdx)
  80013b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80013e:	89 d1                	mov    %edx,%ecx
  800140:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800144:	48 98                	cltq   
  800146:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80014a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80014e:	8b 00                	mov    (%rax),%eax
  800150:	3d ff 00 00 00       	cmp    $0xff,%eax
  800155:	75 2c                	jne    800183 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800157:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80015b:	8b 00                	mov    (%rax),%eax
  80015d:	48 98                	cltq   
  80015f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800163:	48 83 c2 08          	add    $0x8,%rdx
  800167:	48 89 c6             	mov    %rax,%rsi
  80016a:	48 89 d7             	mov    %rdx,%rdi
  80016d:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  800174:	00 00 00 
  800177:	ff d0                	callq  *%rax
        b->idx = 0;
  800179:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80017d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800183:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800187:	8b 40 04             	mov    0x4(%rax),%eax
  80018a:	8d 50 01             	lea    0x1(%rax),%edx
  80018d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800191:	89 50 04             	mov    %edx,0x4(%rax)
}
  800194:	90                   	nop
  800195:	c9                   	leaveq 
  800196:	c3                   	retq   

0000000000800197 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800197:	55                   	push   %rbp
  800198:	48 89 e5             	mov    %rsp,%rbp
  80019b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001a2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001a9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001b0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001b7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001be:	48 8b 0a             	mov    (%rdx),%rcx
  8001c1:	48 89 08             	mov    %rcx,(%rax)
  8001c4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001c8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001cc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001d0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001db:	00 00 00 
    b.cnt = 0;
  8001de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8001e5:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8001e8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8001ef:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8001f6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001fd:	48 89 c6             	mov    %rax,%rsi
  800200:	48 bf 1d 01 80 00 00 	movabs $0x80011d,%rdi
  800207:	00 00 00 
  80020a:	48 b8 e1 05 80 00 00 	movabs $0x8005e1,%rax
  800211:	00 00 00 
  800214:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800216:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80021c:	48 98                	cltq   
  80021e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800225:	48 83 c2 08          	add    $0x8,%rdx
  800229:	48 89 c6             	mov    %rax,%rsi
  80022c:	48 89 d7             	mov    %rdx,%rdi
  80022f:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  800236:	00 00 00 
  800239:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80023b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800241:	c9                   	leaveq 
  800242:	c3                   	retq   

0000000000800243 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800243:	55                   	push   %rbp
  800244:	48 89 e5             	mov    %rsp,%rbp
  800247:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80024e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800255:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80025c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800263:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80026a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800271:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800278:	84 c0                	test   %al,%al
  80027a:	74 20                	je     80029c <cprintf+0x59>
  80027c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800280:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800284:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800288:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80028c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800290:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800294:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800298:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80029c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002a3:	00 00 00 
  8002a6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002ad:	00 00 00 
  8002b0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002b4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002bb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002c2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002c9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002d0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002d7:	48 8b 0a             	mov    (%rdx),%rcx
  8002da:	48 89 08             	mov    %rcx,(%rax)
  8002dd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002e1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002e5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002e9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8002ed:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8002f4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8002fb:	48 89 d6             	mov    %rdx,%rsi
  8002fe:	48 89 c7             	mov    %rax,%rdi
  800301:	48 b8 97 01 80 00 00 	movabs $0x800197,%rax
  800308:	00 00 00 
  80030b:	ff d0                	callq  *%rax
  80030d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800313:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800319:	c9                   	leaveq 
  80031a:	c3                   	retq   

000000000080031b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031b:	55                   	push   %rbp
  80031c:	48 89 e5             	mov    %rsp,%rbp
  80031f:	48 83 ec 30          	sub    $0x30,%rsp
  800323:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800327:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80032b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80032f:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800332:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800336:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80033d:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800341:	77 54                	ja     800397 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800343:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800346:	8d 78 ff             	lea    -0x1(%rax),%edi
  800349:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80034c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800350:	ba 00 00 00 00       	mov    $0x0,%edx
  800355:	48 f7 f6             	div    %rsi
  800358:	49 89 c2             	mov    %rax,%r10
  80035b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80035e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800361:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800365:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800369:	41 89 c9             	mov    %ecx,%r9d
  80036c:	41 89 f8             	mov    %edi,%r8d
  80036f:	89 d1                	mov    %edx,%ecx
  800371:	4c 89 d2             	mov    %r10,%rdx
  800374:	48 89 c7             	mov    %rax,%rdi
  800377:	48 b8 1b 03 80 00 00 	movabs $0x80031b,%rax
  80037e:	00 00 00 
  800381:	ff d0                	callq  *%rax
  800383:	eb 1c                	jmp    8003a1 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800385:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800389:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80038c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800390:	48 89 ce             	mov    %rcx,%rsi
  800393:	89 d7                	mov    %edx,%edi
  800395:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800397:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80039b:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80039f:	7f e4                	jg     800385 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003a1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8003a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ad:	48 f7 f1             	div    %rcx
  8003b0:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  8003b7:	00 00 00 
  8003ba:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8003be:	0f be d0             	movsbl %al,%edx
  8003c1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8003c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003c9:	48 89 ce             	mov    %rcx,%rsi
  8003cc:	89 d7                	mov    %edx,%edi
  8003ce:	ff d0                	callq  *%rax
}
  8003d0:	90                   	nop
  8003d1:	c9                   	leaveq 
  8003d2:	c3                   	retq   

00000000008003d3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d3:	55                   	push   %rbp
  8003d4:	48 89 e5             	mov    %rsp,%rbp
  8003d7:	48 83 ec 20          	sub    $0x20,%rsp
  8003db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003df:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8003e2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003e6:	7e 4f                	jle    800437 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8003e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003ec:	8b 00                	mov    (%rax),%eax
  8003ee:	83 f8 30             	cmp    $0x30,%eax
  8003f1:	73 24                	jae    800417 <getuint+0x44>
  8003f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8003fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003ff:	8b 00                	mov    (%rax),%eax
  800401:	89 c0                	mov    %eax,%eax
  800403:	48 01 d0             	add    %rdx,%rax
  800406:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80040a:	8b 12                	mov    (%rdx),%edx
  80040c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80040f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800413:	89 0a                	mov    %ecx,(%rdx)
  800415:	eb 14                	jmp    80042b <getuint+0x58>
  800417:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80041f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800423:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800427:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80042b:	48 8b 00             	mov    (%rax),%rax
  80042e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800432:	e9 9d 00 00 00       	jmpq   8004d4 <getuint+0x101>
	else if (lflag)
  800437:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80043b:	74 4c                	je     800489 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80043d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800441:	8b 00                	mov    (%rax),%eax
  800443:	83 f8 30             	cmp    $0x30,%eax
  800446:	73 24                	jae    80046c <getuint+0x99>
  800448:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80044c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800450:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800454:	8b 00                	mov    (%rax),%eax
  800456:	89 c0                	mov    %eax,%eax
  800458:	48 01 d0             	add    %rdx,%rax
  80045b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80045f:	8b 12                	mov    (%rdx),%edx
  800461:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800464:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800468:	89 0a                	mov    %ecx,(%rdx)
  80046a:	eb 14                	jmp    800480 <getuint+0xad>
  80046c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800470:	48 8b 40 08          	mov    0x8(%rax),%rax
  800474:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800478:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80047c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800480:	48 8b 00             	mov    (%rax),%rax
  800483:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800487:	eb 4b                	jmp    8004d4 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800489:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048d:	8b 00                	mov    (%rax),%eax
  80048f:	83 f8 30             	cmp    $0x30,%eax
  800492:	73 24                	jae    8004b8 <getuint+0xe5>
  800494:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800498:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80049c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a0:	8b 00                	mov    (%rax),%eax
  8004a2:	89 c0                	mov    %eax,%eax
  8004a4:	48 01 d0             	add    %rdx,%rax
  8004a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ab:	8b 12                	mov    (%rdx),%edx
  8004ad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b4:	89 0a                	mov    %ecx,(%rdx)
  8004b6:	eb 14                	jmp    8004cc <getuint+0xf9>
  8004b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bc:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004c0:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8004c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004cc:	8b 00                	mov    (%rax),%eax
  8004ce:	89 c0                	mov    %eax,%eax
  8004d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004d8:	c9                   	leaveq 
  8004d9:	c3                   	retq   

00000000008004da <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004da:	55                   	push   %rbp
  8004db:	48 89 e5             	mov    %rsp,%rbp
  8004de:	48 83 ec 20          	sub    $0x20,%rsp
  8004e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004e6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8004e9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004ed:	7e 4f                	jle    80053e <getint+0x64>
		x=va_arg(*ap, long long);
  8004ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f3:	8b 00                	mov    (%rax),%eax
  8004f5:	83 f8 30             	cmp    $0x30,%eax
  8004f8:	73 24                	jae    80051e <getint+0x44>
  8004fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fe:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800502:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800506:	8b 00                	mov    (%rax),%eax
  800508:	89 c0                	mov    %eax,%eax
  80050a:	48 01 d0             	add    %rdx,%rax
  80050d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800511:	8b 12                	mov    (%rdx),%edx
  800513:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800516:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051a:	89 0a                	mov    %ecx,(%rdx)
  80051c:	eb 14                	jmp    800532 <getint+0x58>
  80051e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800522:	48 8b 40 08          	mov    0x8(%rax),%rax
  800526:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80052a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80052e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800532:	48 8b 00             	mov    (%rax),%rax
  800535:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800539:	e9 9d 00 00 00       	jmpq   8005db <getint+0x101>
	else if (lflag)
  80053e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800542:	74 4c                	je     800590 <getint+0xb6>
		x=va_arg(*ap, long);
  800544:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800548:	8b 00                	mov    (%rax),%eax
  80054a:	83 f8 30             	cmp    $0x30,%eax
  80054d:	73 24                	jae    800573 <getint+0x99>
  80054f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800553:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800557:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055b:	8b 00                	mov    (%rax),%eax
  80055d:	89 c0                	mov    %eax,%eax
  80055f:	48 01 d0             	add    %rdx,%rax
  800562:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800566:	8b 12                	mov    (%rdx),%edx
  800568:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80056b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056f:	89 0a                	mov    %ecx,(%rdx)
  800571:	eb 14                	jmp    800587 <getint+0xad>
  800573:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800577:	48 8b 40 08          	mov    0x8(%rax),%rax
  80057b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80057f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800583:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800587:	48 8b 00             	mov    (%rax),%rax
  80058a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80058e:	eb 4b                	jmp    8005db <getint+0x101>
	else
		x=va_arg(*ap, int);
  800590:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800594:	8b 00                	mov    (%rax),%eax
  800596:	83 f8 30             	cmp    $0x30,%eax
  800599:	73 24                	jae    8005bf <getint+0xe5>
  80059b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a7:	8b 00                	mov    (%rax),%eax
  8005a9:	89 c0                	mov    %eax,%eax
  8005ab:	48 01 d0             	add    %rdx,%rax
  8005ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b2:	8b 12                	mov    (%rdx),%edx
  8005b4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bb:	89 0a                	mov    %ecx,(%rdx)
  8005bd:	eb 14                	jmp    8005d3 <getint+0xf9>
  8005bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005c7:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005cf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d3:	8b 00                	mov    (%rax),%eax
  8005d5:	48 98                	cltq   
  8005d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005df:	c9                   	leaveq 
  8005e0:	c3                   	retq   

00000000008005e1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005e1:	55                   	push   %rbp
  8005e2:	48 89 e5             	mov    %rsp,%rbp
  8005e5:	41 54                	push   %r12
  8005e7:	53                   	push   %rbx
  8005e8:	48 83 ec 60          	sub    $0x60,%rsp
  8005ec:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8005f0:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8005f4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8005f8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8005fc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800600:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800604:	48 8b 0a             	mov    (%rdx),%rcx
  800607:	48 89 08             	mov    %rcx,(%rax)
  80060a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80060e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800612:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800616:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80061a:	eb 17                	jmp    800633 <vprintfmt+0x52>
			if (ch == '\0')
  80061c:	85 db                	test   %ebx,%ebx
  80061e:	0f 84 b9 04 00 00    	je     800add <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800624:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800628:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80062c:	48 89 d6             	mov    %rdx,%rsi
  80062f:	89 df                	mov    %ebx,%edi
  800631:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800633:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800637:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80063b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80063f:	0f b6 00             	movzbl (%rax),%eax
  800642:	0f b6 d8             	movzbl %al,%ebx
  800645:	83 fb 25             	cmp    $0x25,%ebx
  800648:	75 d2                	jne    80061c <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80064a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80064e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800655:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80065c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800663:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80066e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800672:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800676:	0f b6 00             	movzbl (%rax),%eax
  800679:	0f b6 d8             	movzbl %al,%ebx
  80067c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80067f:	83 f8 55             	cmp    $0x55,%eax
  800682:	0f 87 22 04 00 00    	ja     800aaa <vprintfmt+0x4c9>
  800688:	89 c0                	mov    %eax,%eax
  80068a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800691:	00 
  800692:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  800699:	00 00 00 
  80069c:	48 01 d0             	add    %rdx,%rax
  80069f:	48 8b 00             	mov    (%rax),%rax
  8006a2:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006a4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006a8:	eb c0                	jmp    80066a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006aa:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006ae:	eb ba                	jmp    80066a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006b7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006ba:	89 d0                	mov    %edx,%eax
  8006bc:	c1 e0 02             	shl    $0x2,%eax
  8006bf:	01 d0                	add    %edx,%eax
  8006c1:	01 c0                	add    %eax,%eax
  8006c3:	01 d8                	add    %ebx,%eax
  8006c5:	83 e8 30             	sub    $0x30,%eax
  8006c8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006cb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006cf:	0f b6 00             	movzbl (%rax),%eax
  8006d2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006d5:	83 fb 2f             	cmp    $0x2f,%ebx
  8006d8:	7e 60                	jle    80073a <vprintfmt+0x159>
  8006da:	83 fb 39             	cmp    $0x39,%ebx
  8006dd:	7f 5b                	jg     80073a <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006df:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e4:	eb d1                	jmp    8006b7 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8006e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006e9:	83 f8 30             	cmp    $0x30,%eax
  8006ec:	73 17                	jae    800705 <vprintfmt+0x124>
  8006ee:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8006f2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8006f5:	89 d2                	mov    %edx,%edx
  8006f7:	48 01 d0             	add    %rdx,%rax
  8006fa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8006fd:	83 c2 08             	add    $0x8,%edx
  800700:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800703:	eb 0c                	jmp    800711 <vprintfmt+0x130>
  800705:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800709:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80070d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800711:	8b 00                	mov    (%rax),%eax
  800713:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800716:	eb 23                	jmp    80073b <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800718:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80071c:	0f 89 48 ff ff ff    	jns    80066a <vprintfmt+0x89>
				width = 0;
  800722:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800729:	e9 3c ff ff ff       	jmpq   80066a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80072e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800735:	e9 30 ff ff ff       	jmpq   80066a <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80073a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80073b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80073f:	0f 89 25 ff ff ff    	jns    80066a <vprintfmt+0x89>
				width = precision, precision = -1;
  800745:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800748:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80074b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800752:	e9 13 ff ff ff       	jmpq   80066a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800757:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80075b:	e9 0a ff ff ff       	jmpq   80066a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800760:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800763:	83 f8 30             	cmp    $0x30,%eax
  800766:	73 17                	jae    80077f <vprintfmt+0x19e>
  800768:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80076c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80076f:	89 d2                	mov    %edx,%edx
  800771:	48 01 d0             	add    %rdx,%rax
  800774:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800777:	83 c2 08             	add    $0x8,%edx
  80077a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80077d:	eb 0c                	jmp    80078b <vprintfmt+0x1aa>
  80077f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800783:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800787:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80078b:	8b 10                	mov    (%rax),%edx
  80078d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800791:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800795:	48 89 ce             	mov    %rcx,%rsi
  800798:	89 d7                	mov    %edx,%edi
  80079a:	ff d0                	callq  *%rax
			break;
  80079c:	e9 37 03 00 00       	jmpq   800ad8 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007a1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a4:	83 f8 30             	cmp    $0x30,%eax
  8007a7:	73 17                	jae    8007c0 <vprintfmt+0x1df>
  8007a9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8007ad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007b0:	89 d2                	mov    %edx,%edx
  8007b2:	48 01 d0             	add    %rdx,%rax
  8007b5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007b8:	83 c2 08             	add    $0x8,%edx
  8007bb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007be:	eb 0c                	jmp    8007cc <vprintfmt+0x1eb>
  8007c0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8007c4:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8007c8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007cc:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8007ce:	85 db                	test   %ebx,%ebx
  8007d0:	79 02                	jns    8007d4 <vprintfmt+0x1f3>
				err = -err;
  8007d2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007d4:	83 fb 15             	cmp    $0x15,%ebx
  8007d7:	7f 16                	jg     8007ef <vprintfmt+0x20e>
  8007d9:	48 b8 40 1b 80 00 00 	movabs $0x801b40,%rax
  8007e0:	00 00 00 
  8007e3:	48 63 d3             	movslq %ebx,%rdx
  8007e6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8007ea:	4d 85 e4             	test   %r12,%r12
  8007ed:	75 2e                	jne    80081d <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  8007ef:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8007f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007f7:	89 d9                	mov    %ebx,%ecx
  8007f9:	48 ba 01 1c 80 00 00 	movabs $0x801c01,%rdx
  800800:	00 00 00 
  800803:	48 89 c7             	mov    %rax,%rdi
  800806:	b8 00 00 00 00       	mov    $0x0,%eax
  80080b:	49 b8 e7 0a 80 00 00 	movabs $0x800ae7,%r8
  800812:	00 00 00 
  800815:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800818:	e9 bb 02 00 00       	jmpq   800ad8 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80081d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800821:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800825:	4c 89 e1             	mov    %r12,%rcx
  800828:	48 ba 0a 1c 80 00 00 	movabs $0x801c0a,%rdx
  80082f:	00 00 00 
  800832:	48 89 c7             	mov    %rax,%rdi
  800835:	b8 00 00 00 00       	mov    $0x0,%eax
  80083a:	49 b8 e7 0a 80 00 00 	movabs $0x800ae7,%r8
  800841:	00 00 00 
  800844:	41 ff d0             	callq  *%r8
			break;
  800847:	e9 8c 02 00 00       	jmpq   800ad8 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80084c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80084f:	83 f8 30             	cmp    $0x30,%eax
  800852:	73 17                	jae    80086b <vprintfmt+0x28a>
  800854:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800858:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80085b:	89 d2                	mov    %edx,%edx
  80085d:	48 01 d0             	add    %rdx,%rax
  800860:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800863:	83 c2 08             	add    $0x8,%edx
  800866:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800869:	eb 0c                	jmp    800877 <vprintfmt+0x296>
  80086b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80086f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800873:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800877:	4c 8b 20             	mov    (%rax),%r12
  80087a:	4d 85 e4             	test   %r12,%r12
  80087d:	75 0a                	jne    800889 <vprintfmt+0x2a8>
				p = "(null)";
  80087f:	49 bc 0d 1c 80 00 00 	movabs $0x801c0d,%r12
  800886:	00 00 00 
			if (width > 0 && padc != '-')
  800889:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80088d:	7e 78                	jle    800907 <vprintfmt+0x326>
  80088f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800893:	74 72                	je     800907 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800895:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800898:	48 98                	cltq   
  80089a:	48 89 c6             	mov    %rax,%rsi
  80089d:	4c 89 e7             	mov    %r12,%rdi
  8008a0:	48 b8 95 0d 80 00 00 	movabs $0x800d95,%rax
  8008a7:	00 00 00 
  8008aa:	ff d0                	callq  *%rax
  8008ac:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008af:	eb 17                	jmp    8008c8 <vprintfmt+0x2e7>
					putch(padc, putdat);
  8008b1:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008b5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008b9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008bd:	48 89 ce             	mov    %rcx,%rsi
  8008c0:	89 d7                	mov    %edx,%edi
  8008c2:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008cc:	7f e3                	jg     8008b1 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ce:	eb 37                	jmp    800907 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  8008d0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8008d4:	74 1e                	je     8008f4 <vprintfmt+0x313>
  8008d6:	83 fb 1f             	cmp    $0x1f,%ebx
  8008d9:	7e 05                	jle    8008e0 <vprintfmt+0x2ff>
  8008db:	83 fb 7e             	cmp    $0x7e,%ebx
  8008de:	7e 14                	jle    8008f4 <vprintfmt+0x313>
					putch('?', putdat);
  8008e0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008e4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008e8:	48 89 d6             	mov    %rdx,%rsi
  8008eb:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8008f0:	ff d0                	callq  *%rax
  8008f2:	eb 0f                	jmp    800903 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  8008f4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008fc:	48 89 d6             	mov    %rdx,%rsi
  8008ff:	89 df                	mov    %ebx,%edi
  800901:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800903:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800907:	4c 89 e0             	mov    %r12,%rax
  80090a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80090e:	0f b6 00             	movzbl (%rax),%eax
  800911:	0f be d8             	movsbl %al,%ebx
  800914:	85 db                	test   %ebx,%ebx
  800916:	74 28                	je     800940 <vprintfmt+0x35f>
  800918:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80091c:	78 b2                	js     8008d0 <vprintfmt+0x2ef>
  80091e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800922:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800926:	79 a8                	jns    8008d0 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800928:	eb 16                	jmp    800940 <vprintfmt+0x35f>
				putch(' ', putdat);
  80092a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80092e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800932:	48 89 d6             	mov    %rdx,%rsi
  800935:	bf 20 00 00 00       	mov    $0x20,%edi
  80093a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800940:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800944:	7f e4                	jg     80092a <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800946:	e9 8d 01 00 00       	jmpq   800ad8 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80094b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80094f:	be 03 00 00 00       	mov    $0x3,%esi
  800954:	48 89 c7             	mov    %rax,%rdi
  800957:	48 b8 da 04 80 00 00 	movabs $0x8004da,%rax
  80095e:	00 00 00 
  800961:	ff d0                	callq  *%rax
  800963:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800967:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096b:	48 85 c0             	test   %rax,%rax
  80096e:	79 1d                	jns    80098d <vprintfmt+0x3ac>
				putch('-', putdat);
  800970:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800974:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800978:	48 89 d6             	mov    %rdx,%rsi
  80097b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800980:	ff d0                	callq  *%rax
				num = -(long long) num;
  800982:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800986:	48 f7 d8             	neg    %rax
  800989:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80098d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800994:	e9 d2 00 00 00       	jmpq   800a6b <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800999:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80099d:	be 03 00 00 00       	mov    $0x3,%esi
  8009a2:	48 89 c7             	mov    %rax,%rdi
  8009a5:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  8009ac:	00 00 00 
  8009af:	ff d0                	callq  *%rax
  8009b1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009b5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009bc:	e9 aa 00 00 00       	jmpq   800a6b <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  8009c1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009c5:	be 03 00 00 00       	mov    $0x3,%esi
  8009ca:	48 89 c7             	mov    %rax,%rdi
  8009cd:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  8009d4:	00 00 00 
  8009d7:	ff d0                	callq  *%rax
  8009d9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8009dd:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8009e4:	e9 82 00 00 00       	jmpq   800a6b <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  8009e9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f1:	48 89 d6             	mov    %rdx,%rsi
  8009f4:	bf 30 00 00 00       	mov    $0x30,%edi
  8009f9:	ff d0                	callq  *%rax
			putch('x', putdat);
  8009fb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a03:	48 89 d6             	mov    %rdx,%rsi
  800a06:	bf 78 00 00 00       	mov    $0x78,%edi
  800a0b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a0d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a10:	83 f8 30             	cmp    $0x30,%eax
  800a13:	73 17                	jae    800a2c <vprintfmt+0x44b>
  800a15:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a19:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a1c:	89 d2                	mov    %edx,%edx
  800a1e:	48 01 d0             	add    %rdx,%rax
  800a21:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a24:	83 c2 08             	add    $0x8,%edx
  800a27:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a2a:	eb 0c                	jmp    800a38 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800a2c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a30:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a34:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a38:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a3b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a3f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a46:	eb 23                	jmp    800a6b <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a48:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a4c:	be 03 00 00 00       	mov    $0x3,%esi
  800a51:	48 89 c7             	mov    %rax,%rdi
  800a54:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  800a5b:	00 00 00 
  800a5e:	ff d0                	callq  *%rax
  800a60:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800a64:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a6b:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800a70:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800a73:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800a76:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a82:	45 89 c1             	mov    %r8d,%r9d
  800a85:	41 89 f8             	mov    %edi,%r8d
  800a88:	48 89 c7             	mov    %rax,%rdi
  800a8b:	48 b8 1b 03 80 00 00 	movabs $0x80031b,%rax
  800a92:	00 00 00 
  800a95:	ff d0                	callq  *%rax
			break;
  800a97:	eb 3f                	jmp    800ad8 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a99:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa1:	48 89 d6             	mov    %rdx,%rsi
  800aa4:	89 df                	mov    %ebx,%edi
  800aa6:	ff d0                	callq  *%rax
			break;
  800aa8:	eb 2e                	jmp    800ad8 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aaa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab2:	48 89 d6             	mov    %rdx,%rsi
  800ab5:	bf 25 00 00 00       	mov    $0x25,%edi
  800aba:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800abc:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ac1:	eb 05                	jmp    800ac8 <vprintfmt+0x4e7>
  800ac3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ac8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800acc:	48 83 e8 01          	sub    $0x1,%rax
  800ad0:	0f b6 00             	movzbl (%rax),%eax
  800ad3:	3c 25                	cmp    $0x25,%al
  800ad5:	75 ec                	jne    800ac3 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800ad7:	90                   	nop
		}
	}
  800ad8:	e9 3d fb ff ff       	jmpq   80061a <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800add:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ade:	48 83 c4 60          	add    $0x60,%rsp
  800ae2:	5b                   	pop    %rbx
  800ae3:	41 5c                	pop    %r12
  800ae5:	5d                   	pop    %rbp
  800ae6:	c3                   	retq   

0000000000800ae7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae7:	55                   	push   %rbp
  800ae8:	48 89 e5             	mov    %rsp,%rbp
  800aeb:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800af2:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800af9:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b00:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800b07:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b0e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b15:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b1c:	84 c0                	test   %al,%al
  800b1e:	74 20                	je     800b40 <printfmt+0x59>
  800b20:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b24:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b28:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b2c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b30:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b34:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b38:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b3c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b40:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b47:	00 00 00 
  800b4a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b51:	00 00 00 
  800b54:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b58:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800b5f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b66:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800b6d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800b74:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800b7b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800b82:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800b89:	48 89 c7             	mov    %rax,%rdi
  800b8c:	48 b8 e1 05 80 00 00 	movabs $0x8005e1,%rax
  800b93:	00 00 00 
  800b96:	ff d0                	callq  *%rax
	va_end(ap);
}
  800b98:	90                   	nop
  800b99:	c9                   	leaveq 
  800b9a:	c3                   	retq   

0000000000800b9b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b9b:	55                   	push   %rbp
  800b9c:	48 89 e5             	mov    %rsp,%rbp
  800b9f:	48 83 ec 10          	sub    $0x10,%rsp
  800ba3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ba6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800baa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bae:	8b 40 10             	mov    0x10(%rax),%eax
  800bb1:	8d 50 01             	lea    0x1(%rax),%edx
  800bb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bb8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800bbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bbf:	48 8b 10             	mov    (%rax),%rdx
  800bc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bc6:	48 8b 40 08          	mov    0x8(%rax),%rax
  800bca:	48 39 c2             	cmp    %rax,%rdx
  800bcd:	73 17                	jae    800be6 <sprintputch+0x4b>
		*b->buf++ = ch;
  800bcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bd3:	48 8b 00             	mov    (%rax),%rax
  800bd6:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800bda:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bde:	48 89 0a             	mov    %rcx,(%rdx)
  800be1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800be4:	88 10                	mov    %dl,(%rax)
}
  800be6:	90                   	nop
  800be7:	c9                   	leaveq 
  800be8:	c3                   	retq   

0000000000800be9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be9:	55                   	push   %rbp
  800bea:	48 89 e5             	mov    %rsp,%rbp
  800bed:	48 83 ec 50          	sub    $0x50,%rsp
  800bf1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800bf5:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800bf8:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800bfc:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c00:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c04:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c08:	48 8b 0a             	mov    (%rdx),%rcx
  800c0b:	48 89 08             	mov    %rcx,(%rax)
  800c0e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c12:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c16:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c1a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c1e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c22:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c26:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c29:	48 98                	cltq   
  800c2b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c2f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c33:	48 01 d0             	add    %rdx,%rax
  800c36:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c3a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c41:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c46:	74 06                	je     800c4e <vsnprintf+0x65>
  800c48:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c4c:	7f 07                	jg     800c55 <vsnprintf+0x6c>
		return -E_INVAL;
  800c4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c53:	eb 2f                	jmp    800c84 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c55:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c59:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800c5d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c61:	48 89 c6             	mov    %rax,%rsi
  800c64:	48 bf 9b 0b 80 00 00 	movabs $0x800b9b,%rdi
  800c6b:	00 00 00 
  800c6e:	48 b8 e1 05 80 00 00 	movabs $0x8005e1,%rax
  800c75:	00 00 00 
  800c78:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800c7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c7e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800c81:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800c84:	c9                   	leaveq 
  800c85:	c3                   	retq   

0000000000800c86 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c86:	55                   	push   %rbp
  800c87:	48 89 e5             	mov    %rsp,%rbp
  800c8a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800c91:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800c98:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800c9e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800ca5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cac:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cb3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cba:	84 c0                	test   %al,%al
  800cbc:	74 20                	je     800cde <snprintf+0x58>
  800cbe:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cc2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cc6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cca:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cce:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cd2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cd6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800cda:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800cde:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800ce5:	00 00 00 
  800ce8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800cef:	00 00 00 
  800cf2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cf6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800cfd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d04:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d0b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d12:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d19:	48 8b 0a             	mov    (%rdx),%rcx
  800d1c:	48 89 08             	mov    %rcx,(%rax)
  800d1f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d23:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d27:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d2b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d2f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d36:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d3d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d43:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d4a:	48 89 c7             	mov    %rax,%rdi
  800d4d:	48 b8 e9 0b 80 00 00 	movabs $0x800be9,%rax
  800d54:	00 00 00 
  800d57:	ff d0                	callq  *%rax
  800d59:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800d5f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800d65:	c9                   	leaveq 
  800d66:	c3                   	retq   

0000000000800d67 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d67:	55                   	push   %rbp
  800d68:	48 89 e5             	mov    %rsp,%rbp
  800d6b:	48 83 ec 18          	sub    $0x18,%rsp
  800d6f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800d73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800d7a:	eb 09                	jmp    800d85 <strlen+0x1e>
		n++;
  800d7c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d80:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800d85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d89:	0f b6 00             	movzbl (%rax),%eax
  800d8c:	84 c0                	test   %al,%al
  800d8e:	75 ec                	jne    800d7c <strlen+0x15>
		n++;
	return n;
  800d90:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800d93:	c9                   	leaveq 
  800d94:	c3                   	retq   

0000000000800d95 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d95:	55                   	push   %rbp
  800d96:	48 89 e5             	mov    %rsp,%rbp
  800d99:	48 83 ec 20          	sub    $0x20,%rsp
  800d9d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800da1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800da5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dac:	eb 0e                	jmp    800dbc <strnlen+0x27>
		n++;
  800dae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800db2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800db7:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800dbc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800dc1:	74 0b                	je     800dce <strnlen+0x39>
  800dc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc7:	0f b6 00             	movzbl (%rax),%eax
  800dca:	84 c0                	test   %al,%al
  800dcc:	75 e0                	jne    800dae <strnlen+0x19>
		n++;
	return n;
  800dce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dd1:	c9                   	leaveq 
  800dd2:	c3                   	retq   

0000000000800dd3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dd3:	55                   	push   %rbp
  800dd4:	48 89 e5             	mov    %rsp,%rbp
  800dd7:	48 83 ec 20          	sub    $0x20,%rsp
  800ddb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ddf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800de3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800deb:	90                   	nop
  800dec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800df4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800df8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800dfc:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e00:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e04:	0f b6 12             	movzbl (%rdx),%edx
  800e07:	88 10                	mov    %dl,(%rax)
  800e09:	0f b6 00             	movzbl (%rax),%eax
  800e0c:	84 c0                	test   %al,%al
  800e0e:	75 dc                	jne    800dec <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e14:	c9                   	leaveq 
  800e15:	c3                   	retq   

0000000000800e16 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e16:	55                   	push   %rbp
  800e17:	48 89 e5             	mov    %rsp,%rbp
  800e1a:	48 83 ec 20          	sub    $0x20,%rsp
  800e1e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e22:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2a:	48 89 c7             	mov    %rax,%rdi
  800e2d:	48 b8 67 0d 80 00 00 	movabs $0x800d67,%rax
  800e34:	00 00 00 
  800e37:	ff d0                	callq  *%rax
  800e39:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e3f:	48 63 d0             	movslq %eax,%rdx
  800e42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e46:	48 01 c2             	add    %rax,%rdx
  800e49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e4d:	48 89 c6             	mov    %rax,%rsi
  800e50:	48 89 d7             	mov    %rdx,%rdi
  800e53:	48 b8 d3 0d 80 00 00 	movabs $0x800dd3,%rax
  800e5a:	00 00 00 
  800e5d:	ff d0                	callq  *%rax
	return dst;
  800e5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800e63:	c9                   	leaveq 
  800e64:	c3                   	retq   

0000000000800e65 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e65:	55                   	push   %rbp
  800e66:	48 89 e5             	mov    %rsp,%rbp
  800e69:	48 83 ec 28          	sub    $0x28,%rsp
  800e6d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e71:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e75:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800e79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800e81:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800e88:	00 
  800e89:	eb 2a                	jmp    800eb5 <strncpy+0x50>
		*dst++ = *src;
  800e8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e93:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e97:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e9b:	0f b6 12             	movzbl (%rdx),%edx
  800e9e:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ea0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ea4:	0f b6 00             	movzbl (%rax),%eax
  800ea7:	84 c0                	test   %al,%al
  800ea9:	74 05                	je     800eb0 <strncpy+0x4b>
			src++;
  800eab:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eb0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800eb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800eb9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ebd:	72 cc                	jb     800e8b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ebf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800ec3:	c9                   	leaveq 
  800ec4:	c3                   	retq   

0000000000800ec5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ec5:	55                   	push   %rbp
  800ec6:	48 89 e5             	mov    %rsp,%rbp
  800ec9:	48 83 ec 28          	sub    $0x28,%rsp
  800ecd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ed1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ed5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800ed9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800edd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800ee1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800ee6:	74 3d                	je     800f25 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800ee8:	eb 1d                	jmp    800f07 <strlcpy+0x42>
			*dst++ = *src++;
  800eea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ef2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ef6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800efa:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800efe:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f02:	0f b6 12             	movzbl (%rdx),%edx
  800f05:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f07:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f0c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f11:	74 0b                	je     800f1e <strlcpy+0x59>
  800f13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f17:	0f b6 00             	movzbl (%rax),%eax
  800f1a:	84 c0                	test   %al,%al
  800f1c:	75 cc                	jne    800eea <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f22:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f25:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f2d:	48 29 c2             	sub    %rax,%rdx
  800f30:	48 89 d0             	mov    %rdx,%rax
}
  800f33:	c9                   	leaveq 
  800f34:	c3                   	retq   

0000000000800f35 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f35:	55                   	push   %rbp
  800f36:	48 89 e5             	mov    %rsp,%rbp
  800f39:	48 83 ec 10          	sub    $0x10,%rsp
  800f3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f45:	eb 0a                	jmp    800f51 <strcmp+0x1c>
		p++, q++;
  800f47:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f4c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f55:	0f b6 00             	movzbl (%rax),%eax
  800f58:	84 c0                	test   %al,%al
  800f5a:	74 12                	je     800f6e <strcmp+0x39>
  800f5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f60:	0f b6 10             	movzbl (%rax),%edx
  800f63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f67:	0f b6 00             	movzbl (%rax),%eax
  800f6a:	38 c2                	cmp    %al,%dl
  800f6c:	74 d9                	je     800f47 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f72:	0f b6 00             	movzbl (%rax),%eax
  800f75:	0f b6 d0             	movzbl %al,%edx
  800f78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f7c:	0f b6 00             	movzbl (%rax),%eax
  800f7f:	0f b6 c0             	movzbl %al,%eax
  800f82:	29 c2                	sub    %eax,%edx
  800f84:	89 d0                	mov    %edx,%eax
}
  800f86:	c9                   	leaveq 
  800f87:	c3                   	retq   

0000000000800f88 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800f88:	55                   	push   %rbp
  800f89:	48 89 e5             	mov    %rsp,%rbp
  800f8c:	48 83 ec 18          	sub    $0x18,%rsp
  800f90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800f98:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800f9c:	eb 0f                	jmp    800fad <strncmp+0x25>
		n--, p++, q++;
  800f9e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fa3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fa8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800fad:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fb2:	74 1d                	je     800fd1 <strncmp+0x49>
  800fb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb8:	0f b6 00             	movzbl (%rax),%eax
  800fbb:	84 c0                	test   %al,%al
  800fbd:	74 12                	je     800fd1 <strncmp+0x49>
  800fbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc3:	0f b6 10             	movzbl (%rax),%edx
  800fc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fca:	0f b6 00             	movzbl (%rax),%eax
  800fcd:	38 c2                	cmp    %al,%dl
  800fcf:	74 cd                	je     800f9e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  800fd1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fd6:	75 07                	jne    800fdf <strncmp+0x57>
		return 0;
  800fd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdd:	eb 18                	jmp    800ff7 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fe3:	0f b6 00             	movzbl (%rax),%eax
  800fe6:	0f b6 d0             	movzbl %al,%edx
  800fe9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fed:	0f b6 00             	movzbl (%rax),%eax
  800ff0:	0f b6 c0             	movzbl %al,%eax
  800ff3:	29 c2                	sub    %eax,%edx
  800ff5:	89 d0                	mov    %edx,%eax
}
  800ff7:	c9                   	leaveq 
  800ff8:	c3                   	retq   

0000000000800ff9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ff9:	55                   	push   %rbp
  800ffa:	48 89 e5             	mov    %rsp,%rbp
  800ffd:	48 83 ec 10          	sub    $0x10,%rsp
  801001:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801005:	89 f0                	mov    %esi,%eax
  801007:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80100a:	eb 17                	jmp    801023 <strchr+0x2a>
		if (*s == c)
  80100c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801010:	0f b6 00             	movzbl (%rax),%eax
  801013:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801016:	75 06                	jne    80101e <strchr+0x25>
			return (char *) s;
  801018:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80101c:	eb 15                	jmp    801033 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80101e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801023:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801027:	0f b6 00             	movzbl (%rax),%eax
  80102a:	84 c0                	test   %al,%al
  80102c:	75 de                	jne    80100c <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80102e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801033:	c9                   	leaveq 
  801034:	c3                   	retq   

0000000000801035 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801035:	55                   	push   %rbp
  801036:	48 89 e5             	mov    %rsp,%rbp
  801039:	48 83 ec 10          	sub    $0x10,%rsp
  80103d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801041:	89 f0                	mov    %esi,%eax
  801043:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801046:	eb 11                	jmp    801059 <strfind+0x24>
		if (*s == c)
  801048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104c:	0f b6 00             	movzbl (%rax),%eax
  80104f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801052:	74 12                	je     801066 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801054:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801059:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105d:	0f b6 00             	movzbl (%rax),%eax
  801060:	84 c0                	test   %al,%al
  801062:	75 e4                	jne    801048 <strfind+0x13>
  801064:	eb 01                	jmp    801067 <strfind+0x32>
		if (*s == c)
			break;
  801066:	90                   	nop
	return (char *) s;
  801067:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80106b:	c9                   	leaveq 
  80106c:	c3                   	retq   

000000000080106d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80106d:	55                   	push   %rbp
  80106e:	48 89 e5             	mov    %rsp,%rbp
  801071:	48 83 ec 18          	sub    $0x18,%rsp
  801075:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801079:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80107c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801080:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801085:	75 06                	jne    80108d <memset+0x20>
		return v;
  801087:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108b:	eb 69                	jmp    8010f6 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80108d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801091:	83 e0 03             	and    $0x3,%eax
  801094:	48 85 c0             	test   %rax,%rax
  801097:	75 48                	jne    8010e1 <memset+0x74>
  801099:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109d:	83 e0 03             	and    $0x3,%eax
  8010a0:	48 85 c0             	test   %rax,%rax
  8010a3:	75 3c                	jne    8010e1 <memset+0x74>
		c &= 0xFF;
  8010a5:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010af:	c1 e0 18             	shl    $0x18,%eax
  8010b2:	89 c2                	mov    %eax,%edx
  8010b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010b7:	c1 e0 10             	shl    $0x10,%eax
  8010ba:	09 c2                	or     %eax,%edx
  8010bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010bf:	c1 e0 08             	shl    $0x8,%eax
  8010c2:	09 d0                	or     %edx,%eax
  8010c4:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8010c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cb:	48 c1 e8 02          	shr    $0x2,%rax
  8010cf:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8010d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8010d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010d9:	48 89 d7             	mov    %rdx,%rdi
  8010dc:	fc                   	cld    
  8010dd:	f3 ab                	rep stos %eax,%es:(%rdi)
  8010df:	eb 11                	jmp    8010f2 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8010e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8010e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010e8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8010ec:	48 89 d7             	mov    %rdx,%rdi
  8010ef:	fc                   	cld    
  8010f0:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8010f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010f6:	c9                   	leaveq 
  8010f7:	c3                   	retq   

00000000008010f8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8010f8:	55                   	push   %rbp
  8010f9:	48 89 e5             	mov    %rsp,%rbp
  8010fc:	48 83 ec 28          	sub    $0x28,%rsp
  801100:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801104:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801108:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80110c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801110:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801114:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801118:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80111c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801120:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801124:	0f 83 88 00 00 00    	jae    8011b2 <memmove+0xba>
  80112a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80112e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801132:	48 01 d0             	add    %rdx,%rax
  801135:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801139:	76 77                	jbe    8011b2 <memmove+0xba>
		s += n;
  80113b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80113f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801143:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801147:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80114b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114f:	83 e0 03             	and    $0x3,%eax
  801152:	48 85 c0             	test   %rax,%rax
  801155:	75 3b                	jne    801192 <memmove+0x9a>
  801157:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80115b:	83 e0 03             	and    $0x3,%eax
  80115e:	48 85 c0             	test   %rax,%rax
  801161:	75 2f                	jne    801192 <memmove+0x9a>
  801163:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801167:	83 e0 03             	and    $0x3,%eax
  80116a:	48 85 c0             	test   %rax,%rax
  80116d:	75 23                	jne    801192 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80116f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801173:	48 83 e8 04          	sub    $0x4,%rax
  801177:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80117b:	48 83 ea 04          	sub    $0x4,%rdx
  80117f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801183:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801187:	48 89 c7             	mov    %rax,%rdi
  80118a:	48 89 d6             	mov    %rdx,%rsi
  80118d:	fd                   	std    
  80118e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801190:	eb 1d                	jmp    8011af <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801192:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801196:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80119a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011a6:	48 89 d7             	mov    %rdx,%rdi
  8011a9:	48 89 c1             	mov    %rax,%rcx
  8011ac:	fd                   	std    
  8011ad:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011af:	fc                   	cld    
  8011b0:	eb 57                	jmp    801209 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b6:	83 e0 03             	and    $0x3,%eax
  8011b9:	48 85 c0             	test   %rax,%rax
  8011bc:	75 36                	jne    8011f4 <memmove+0xfc>
  8011be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c2:	83 e0 03             	and    $0x3,%eax
  8011c5:	48 85 c0             	test   %rax,%rax
  8011c8:	75 2a                	jne    8011f4 <memmove+0xfc>
  8011ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011ce:	83 e0 03             	and    $0x3,%eax
  8011d1:	48 85 c0             	test   %rax,%rax
  8011d4:	75 1e                	jne    8011f4 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8011d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011da:	48 c1 e8 02          	shr    $0x2,%rax
  8011de:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8011e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011e9:	48 89 c7             	mov    %rax,%rdi
  8011ec:	48 89 d6             	mov    %rdx,%rsi
  8011ef:	fc                   	cld    
  8011f0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011f2:	eb 15                	jmp    801209 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8011f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011fc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801200:	48 89 c7             	mov    %rax,%rdi
  801203:	48 89 d6             	mov    %rdx,%rsi
  801206:	fc                   	cld    
  801207:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801209:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80120d:	c9                   	leaveq 
  80120e:	c3                   	retq   

000000000080120f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80120f:	55                   	push   %rbp
  801210:	48 89 e5             	mov    %rsp,%rbp
  801213:	48 83 ec 18          	sub    $0x18,%rsp
  801217:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80121b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80121f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801223:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801227:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122f:	48 89 ce             	mov    %rcx,%rsi
  801232:	48 89 c7             	mov    %rax,%rdi
  801235:	48 b8 f8 10 80 00 00 	movabs $0x8010f8,%rax
  80123c:	00 00 00 
  80123f:	ff d0                	callq  *%rax
}
  801241:	c9                   	leaveq 
  801242:	c3                   	retq   

0000000000801243 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801243:	55                   	push   %rbp
  801244:	48 89 e5             	mov    %rsp,%rbp
  801247:	48 83 ec 28          	sub    $0x28,%rsp
  80124b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80124f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801253:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801257:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80125f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801263:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801267:	eb 36                	jmp    80129f <memcmp+0x5c>
		if (*s1 != *s2)
  801269:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126d:	0f b6 10             	movzbl (%rax),%edx
  801270:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801274:	0f b6 00             	movzbl (%rax),%eax
  801277:	38 c2                	cmp    %al,%dl
  801279:	74 1a                	je     801295 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80127b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127f:	0f b6 00             	movzbl (%rax),%eax
  801282:	0f b6 d0             	movzbl %al,%edx
  801285:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801289:	0f b6 00             	movzbl (%rax),%eax
  80128c:	0f b6 c0             	movzbl %al,%eax
  80128f:	29 c2                	sub    %eax,%edx
  801291:	89 d0                	mov    %edx,%eax
  801293:	eb 20                	jmp    8012b5 <memcmp+0x72>
		s1++, s2++;
  801295:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80129a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80129f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012a7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012ab:	48 85 c0             	test   %rax,%rax
  8012ae:	75 b9                	jne    801269 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b5:	c9                   	leaveq 
  8012b6:	c3                   	retq   

00000000008012b7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012b7:	55                   	push   %rbp
  8012b8:	48 89 e5             	mov    %rsp,%rbp
  8012bb:	48 83 ec 28          	sub    $0x28,%rsp
  8012bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012c6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8012ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d2:	48 01 d0             	add    %rdx,%rax
  8012d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8012d9:	eb 19                	jmp    8012f4 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012df:	0f b6 00             	movzbl (%rax),%eax
  8012e2:	0f b6 d0             	movzbl %al,%edx
  8012e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8012e8:	0f b6 c0             	movzbl %al,%eax
  8012eb:	39 c2                	cmp    %eax,%edx
  8012ed:	74 11                	je     801300 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8012ef:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f8:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8012fc:	72 dd                	jb     8012db <memfind+0x24>
  8012fe:	eb 01                	jmp    801301 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801300:	90                   	nop
	return (void *) s;
  801301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801305:	c9                   	leaveq 
  801306:	c3                   	retq   

0000000000801307 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801307:	55                   	push   %rbp
  801308:	48 89 e5             	mov    %rsp,%rbp
  80130b:	48 83 ec 38          	sub    $0x38,%rsp
  80130f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801313:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801317:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80131a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801321:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801328:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801329:	eb 05                	jmp    801330 <strtol+0x29>
		s++;
  80132b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801330:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801334:	0f b6 00             	movzbl (%rax),%eax
  801337:	3c 20                	cmp    $0x20,%al
  801339:	74 f0                	je     80132b <strtol+0x24>
  80133b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80133f:	0f b6 00             	movzbl (%rax),%eax
  801342:	3c 09                	cmp    $0x9,%al
  801344:	74 e5                	je     80132b <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801346:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80134a:	0f b6 00             	movzbl (%rax),%eax
  80134d:	3c 2b                	cmp    $0x2b,%al
  80134f:	75 07                	jne    801358 <strtol+0x51>
		s++;
  801351:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801356:	eb 17                	jmp    80136f <strtol+0x68>
	else if (*s == '-')
  801358:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135c:	0f b6 00             	movzbl (%rax),%eax
  80135f:	3c 2d                	cmp    $0x2d,%al
  801361:	75 0c                	jne    80136f <strtol+0x68>
		s++, neg = 1;
  801363:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801368:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80136f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801373:	74 06                	je     80137b <strtol+0x74>
  801375:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801379:	75 28                	jne    8013a3 <strtol+0x9c>
  80137b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137f:	0f b6 00             	movzbl (%rax),%eax
  801382:	3c 30                	cmp    $0x30,%al
  801384:	75 1d                	jne    8013a3 <strtol+0x9c>
  801386:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138a:	48 83 c0 01          	add    $0x1,%rax
  80138e:	0f b6 00             	movzbl (%rax),%eax
  801391:	3c 78                	cmp    $0x78,%al
  801393:	75 0e                	jne    8013a3 <strtol+0x9c>
		s += 2, base = 16;
  801395:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80139a:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013a1:	eb 2c                	jmp    8013cf <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013a7:	75 19                	jne    8013c2 <strtol+0xbb>
  8013a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ad:	0f b6 00             	movzbl (%rax),%eax
  8013b0:	3c 30                	cmp    $0x30,%al
  8013b2:	75 0e                	jne    8013c2 <strtol+0xbb>
		s++, base = 8;
  8013b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013b9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013c0:	eb 0d                	jmp    8013cf <strtol+0xc8>
	else if (base == 0)
  8013c2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013c6:	75 07                	jne    8013cf <strtol+0xc8>
		base = 10;
  8013c8:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d3:	0f b6 00             	movzbl (%rax),%eax
  8013d6:	3c 2f                	cmp    $0x2f,%al
  8013d8:	7e 1d                	jle    8013f7 <strtol+0xf0>
  8013da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013de:	0f b6 00             	movzbl (%rax),%eax
  8013e1:	3c 39                	cmp    $0x39,%al
  8013e3:	7f 12                	jg     8013f7 <strtol+0xf0>
			dig = *s - '0';
  8013e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e9:	0f b6 00             	movzbl (%rax),%eax
  8013ec:	0f be c0             	movsbl %al,%eax
  8013ef:	83 e8 30             	sub    $0x30,%eax
  8013f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8013f5:	eb 4e                	jmp    801445 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8013f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fb:	0f b6 00             	movzbl (%rax),%eax
  8013fe:	3c 60                	cmp    $0x60,%al
  801400:	7e 1d                	jle    80141f <strtol+0x118>
  801402:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801406:	0f b6 00             	movzbl (%rax),%eax
  801409:	3c 7a                	cmp    $0x7a,%al
  80140b:	7f 12                	jg     80141f <strtol+0x118>
			dig = *s - 'a' + 10;
  80140d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801411:	0f b6 00             	movzbl (%rax),%eax
  801414:	0f be c0             	movsbl %al,%eax
  801417:	83 e8 57             	sub    $0x57,%eax
  80141a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80141d:	eb 26                	jmp    801445 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80141f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801423:	0f b6 00             	movzbl (%rax),%eax
  801426:	3c 40                	cmp    $0x40,%al
  801428:	7e 47                	jle    801471 <strtol+0x16a>
  80142a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	3c 5a                	cmp    $0x5a,%al
  801433:	7f 3c                	jg     801471 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801435:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801439:	0f b6 00             	movzbl (%rax),%eax
  80143c:	0f be c0             	movsbl %al,%eax
  80143f:	83 e8 37             	sub    $0x37,%eax
  801442:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801445:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801448:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80144b:	7d 23                	jge    801470 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80144d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801452:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801455:	48 98                	cltq   
  801457:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80145c:	48 89 c2             	mov    %rax,%rdx
  80145f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801462:	48 98                	cltq   
  801464:	48 01 d0             	add    %rdx,%rax
  801467:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80146b:	e9 5f ff ff ff       	jmpq   8013cf <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801470:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801471:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801476:	74 0b                	je     801483 <strtol+0x17c>
		*endptr = (char *) s;
  801478:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80147c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801480:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801483:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801487:	74 09                	je     801492 <strtol+0x18b>
  801489:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148d:	48 f7 d8             	neg    %rax
  801490:	eb 04                	jmp    801496 <strtol+0x18f>
  801492:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801496:	c9                   	leaveq 
  801497:	c3                   	retq   

0000000000801498 <strstr>:

char * strstr(const char *in, const char *str)
{
  801498:	55                   	push   %rbp
  801499:	48 89 e5             	mov    %rsp,%rbp
  80149c:	48 83 ec 30          	sub    $0x30,%rsp
  8014a0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014a4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014ac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014b0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014b4:	0f b6 00             	movzbl (%rax),%eax
  8014b7:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014ba:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014be:	75 06                	jne    8014c6 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8014c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c4:	eb 6b                	jmp    801531 <strstr+0x99>

	len = strlen(str);
  8014c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014ca:	48 89 c7             	mov    %rax,%rdi
  8014cd:	48 b8 67 0d 80 00 00 	movabs $0x800d67,%rax
  8014d4:	00 00 00 
  8014d7:	ff d0                	callq  *%rax
  8014d9:	48 98                	cltq   
  8014db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8014df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014eb:	0f b6 00             	movzbl (%rax),%eax
  8014ee:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8014f1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8014f5:	75 07                	jne    8014fe <strstr+0x66>
				return (char *) 0;
  8014f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fc:	eb 33                	jmp    801531 <strstr+0x99>
		} while (sc != c);
  8014fe:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801502:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801505:	75 d8                	jne    8014df <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801507:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80150b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80150f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801513:	48 89 ce             	mov    %rcx,%rsi
  801516:	48 89 c7             	mov    %rax,%rdi
  801519:	48 b8 88 0f 80 00 00 	movabs $0x800f88,%rax
  801520:	00 00 00 
  801523:	ff d0                	callq  *%rax
  801525:	85 c0                	test   %eax,%eax
  801527:	75 b6                	jne    8014df <strstr+0x47>

	return (char *) (in - 1);
  801529:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152d:	48 83 e8 01          	sub    $0x1,%rax
}
  801531:	c9                   	leaveq 
  801532:	c3                   	retq   

0000000000801533 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801533:	55                   	push   %rbp
  801534:	48 89 e5             	mov    %rsp,%rbp
  801537:	53                   	push   %rbx
  801538:	48 83 ec 48          	sub    $0x48,%rsp
  80153c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80153f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801542:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801546:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80154a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80154e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801552:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801555:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801559:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80155d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801561:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801565:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801569:	4c 89 c3             	mov    %r8,%rbx
  80156c:	cd 30                	int    $0x30
  80156e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801572:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801576:	74 3e                	je     8015b6 <syscall+0x83>
  801578:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80157d:	7e 37                	jle    8015b6 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80157f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801583:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801586:	49 89 d0             	mov    %rdx,%r8
  801589:	89 c1                	mov    %eax,%ecx
  80158b:	48 ba c8 1e 80 00 00 	movabs $0x801ec8,%rdx
  801592:	00 00 00 
  801595:	be 23 00 00 00       	mov    $0x23,%esi
  80159a:	48 bf e5 1e 80 00 00 	movabs $0x801ee5,%rdi
  8015a1:	00 00 00 
  8015a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a9:	49 b9 3d 19 80 00 00 	movabs $0x80193d,%r9
  8015b0:	00 00 00 
  8015b3:	41 ff d1             	callq  *%r9

	return ret;
  8015b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015ba:	48 83 c4 48          	add    $0x48,%rsp
  8015be:	5b                   	pop    %rbx
  8015bf:	5d                   	pop    %rbp
  8015c0:	c3                   	retq   

00000000008015c1 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8015c1:	55                   	push   %rbp
  8015c2:	48 89 e5             	mov    %rsp,%rbp
  8015c5:	48 83 ec 10          	sub    $0x10,%rsp
  8015c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8015d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015d9:	48 83 ec 08          	sub    $0x8,%rsp
  8015dd:	6a 00                	pushq  $0x0
  8015df:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8015e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8015eb:	48 89 d1             	mov    %rdx,%rcx
  8015ee:	48 89 c2             	mov    %rax,%rdx
  8015f1:	be 00 00 00 00       	mov    $0x0,%esi
  8015f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8015fb:	48 b8 33 15 80 00 00 	movabs $0x801533,%rax
  801602:	00 00 00 
  801605:	ff d0                	callq  *%rax
  801607:	48 83 c4 10          	add    $0x10,%rsp
}
  80160b:	90                   	nop
  80160c:	c9                   	leaveq 
  80160d:	c3                   	retq   

000000000080160e <sys_cgetc>:

int
sys_cgetc(void)
{
  80160e:	55                   	push   %rbp
  80160f:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801612:	48 83 ec 08          	sub    $0x8,%rsp
  801616:	6a 00                	pushq  $0x0
  801618:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80161e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801624:	b9 00 00 00 00       	mov    $0x0,%ecx
  801629:	ba 00 00 00 00       	mov    $0x0,%edx
  80162e:	be 00 00 00 00       	mov    $0x0,%esi
  801633:	bf 01 00 00 00       	mov    $0x1,%edi
  801638:	48 b8 33 15 80 00 00 	movabs $0x801533,%rax
  80163f:	00 00 00 
  801642:	ff d0                	callq  *%rax
  801644:	48 83 c4 10          	add    $0x10,%rsp
}
  801648:	c9                   	leaveq 
  801649:	c3                   	retq   

000000000080164a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80164a:	55                   	push   %rbp
  80164b:	48 89 e5             	mov    %rsp,%rbp
  80164e:	48 83 ec 10          	sub    $0x10,%rsp
  801652:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801655:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801658:	48 98                	cltq   
  80165a:	48 83 ec 08          	sub    $0x8,%rsp
  80165e:	6a 00                	pushq  $0x0
  801660:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801666:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80166c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801671:	48 89 c2             	mov    %rax,%rdx
  801674:	be 01 00 00 00       	mov    $0x1,%esi
  801679:	bf 03 00 00 00       	mov    $0x3,%edi
  80167e:	48 b8 33 15 80 00 00 	movabs $0x801533,%rax
  801685:	00 00 00 
  801688:	ff d0                	callq  *%rax
  80168a:	48 83 c4 10          	add    $0x10,%rsp
}
  80168e:	c9                   	leaveq 
  80168f:	c3                   	retq   

0000000000801690 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801690:	55                   	push   %rbp
  801691:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801694:	48 83 ec 08          	sub    $0x8,%rsp
  801698:	6a 00                	pushq  $0x0
  80169a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016a0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b0:	be 00 00 00 00       	mov    $0x0,%esi
  8016b5:	bf 02 00 00 00       	mov    $0x2,%edi
  8016ba:	48 b8 33 15 80 00 00 	movabs $0x801533,%rax
  8016c1:	00 00 00 
  8016c4:	ff d0                	callq  *%rax
  8016c6:	48 83 c4 10          	add    $0x10,%rsp
}
  8016ca:	c9                   	leaveq 
  8016cb:	c3                   	retq   

00000000008016cc <sys_yield>:

void
sys_yield(void)
{
  8016cc:	55                   	push   %rbp
  8016cd:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8016d0:	48 83 ec 08          	sub    $0x8,%rsp
  8016d4:	6a 00                	pushq  $0x0
  8016d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ec:	be 00 00 00 00       	mov    $0x0,%esi
  8016f1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8016f6:	48 b8 33 15 80 00 00 	movabs $0x801533,%rax
  8016fd:	00 00 00 
  801700:	ff d0                	callq  *%rax
  801702:	48 83 c4 10          	add    $0x10,%rsp
}
  801706:	90                   	nop
  801707:	c9                   	leaveq 
  801708:	c3                   	retq   

0000000000801709 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801709:	55                   	push   %rbp
  80170a:	48 89 e5             	mov    %rsp,%rbp
  80170d:	48 83 ec 10          	sub    $0x10,%rsp
  801711:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801714:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801718:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80171b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80171e:	48 63 c8             	movslq %eax,%rcx
  801721:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801725:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801728:	48 98                	cltq   
  80172a:	48 83 ec 08          	sub    $0x8,%rsp
  80172e:	6a 00                	pushq  $0x0
  801730:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801736:	49 89 c8             	mov    %rcx,%r8
  801739:	48 89 d1             	mov    %rdx,%rcx
  80173c:	48 89 c2             	mov    %rax,%rdx
  80173f:	be 01 00 00 00       	mov    $0x1,%esi
  801744:	bf 04 00 00 00       	mov    $0x4,%edi
  801749:	48 b8 33 15 80 00 00 	movabs $0x801533,%rax
  801750:	00 00 00 
  801753:	ff d0                	callq  *%rax
  801755:	48 83 c4 10          	add    $0x10,%rsp
}
  801759:	c9                   	leaveq 
  80175a:	c3                   	retq   

000000000080175b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80175b:	55                   	push   %rbp
  80175c:	48 89 e5             	mov    %rsp,%rbp
  80175f:	48 83 ec 20          	sub    $0x20,%rsp
  801763:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801766:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80176a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80176d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801771:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801775:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801778:	48 63 c8             	movslq %eax,%rcx
  80177b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80177f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801782:	48 63 f0             	movslq %eax,%rsi
  801785:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801789:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80178c:	48 98                	cltq   
  80178e:	48 83 ec 08          	sub    $0x8,%rsp
  801792:	51                   	push   %rcx
  801793:	49 89 f9             	mov    %rdi,%r9
  801796:	49 89 f0             	mov    %rsi,%r8
  801799:	48 89 d1             	mov    %rdx,%rcx
  80179c:	48 89 c2             	mov    %rax,%rdx
  80179f:	be 01 00 00 00       	mov    $0x1,%esi
  8017a4:	bf 05 00 00 00       	mov    $0x5,%edi
  8017a9:	48 b8 33 15 80 00 00 	movabs $0x801533,%rax
  8017b0:	00 00 00 
  8017b3:	ff d0                	callq  *%rax
  8017b5:	48 83 c4 10          	add    $0x10,%rsp
}
  8017b9:	c9                   	leaveq 
  8017ba:	c3                   	retq   

00000000008017bb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8017bb:	55                   	push   %rbp
  8017bc:	48 89 e5             	mov    %rsp,%rbp
  8017bf:	48 83 ec 10          	sub    $0x10,%rsp
  8017c3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8017ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017d1:	48 98                	cltq   
  8017d3:	48 83 ec 08          	sub    $0x8,%rsp
  8017d7:	6a 00                	pushq  $0x0
  8017d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017e5:	48 89 d1             	mov    %rdx,%rcx
  8017e8:	48 89 c2             	mov    %rax,%rdx
  8017eb:	be 01 00 00 00       	mov    $0x1,%esi
  8017f0:	bf 06 00 00 00       	mov    $0x6,%edi
  8017f5:	48 b8 33 15 80 00 00 	movabs $0x801533,%rax
  8017fc:	00 00 00 
  8017ff:	ff d0                	callq  *%rax
  801801:	48 83 c4 10          	add    $0x10,%rsp
}
  801805:	c9                   	leaveq 
  801806:	c3                   	retq   

0000000000801807 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801807:	55                   	push   %rbp
  801808:	48 89 e5             	mov    %rsp,%rbp
  80180b:	48 83 ec 10          	sub    $0x10,%rsp
  80180f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801812:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801815:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801818:	48 63 d0             	movslq %eax,%rdx
  80181b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80181e:	48 98                	cltq   
  801820:	48 83 ec 08          	sub    $0x8,%rsp
  801824:	6a 00                	pushq  $0x0
  801826:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801832:	48 89 d1             	mov    %rdx,%rcx
  801835:	48 89 c2             	mov    %rax,%rdx
  801838:	be 01 00 00 00       	mov    $0x1,%esi
  80183d:	bf 08 00 00 00       	mov    $0x8,%edi
  801842:	48 b8 33 15 80 00 00 	movabs $0x801533,%rax
  801849:	00 00 00 
  80184c:	ff d0                	callq  *%rax
  80184e:	48 83 c4 10          	add    $0x10,%rsp
}
  801852:	c9                   	leaveq 
  801853:	c3                   	retq   

0000000000801854 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801854:	55                   	push   %rbp
  801855:	48 89 e5             	mov    %rsp,%rbp
  801858:	48 83 ec 10          	sub    $0x10,%rsp
  80185c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80185f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801863:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801867:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80186a:	48 98                	cltq   
  80186c:	48 83 ec 08          	sub    $0x8,%rsp
  801870:	6a 00                	pushq  $0x0
  801872:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801878:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80187e:	48 89 d1             	mov    %rdx,%rcx
  801881:	48 89 c2             	mov    %rax,%rdx
  801884:	be 01 00 00 00       	mov    $0x1,%esi
  801889:	bf 09 00 00 00       	mov    $0x9,%edi
  80188e:	48 b8 33 15 80 00 00 	movabs $0x801533,%rax
  801895:	00 00 00 
  801898:	ff d0                	callq  *%rax
  80189a:	48 83 c4 10          	add    $0x10,%rsp
}
  80189e:	c9                   	leaveq 
  80189f:	c3                   	retq   

00000000008018a0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8018a0:	55                   	push   %rbp
  8018a1:	48 89 e5             	mov    %rsp,%rbp
  8018a4:	48 83 ec 20          	sub    $0x20,%rsp
  8018a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018af:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018b3:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8018b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018b9:	48 63 f0             	movslq %eax,%rsi
  8018bc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8018c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c3:	48 98                	cltq   
  8018c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c9:	48 83 ec 08          	sub    $0x8,%rsp
  8018cd:	6a 00                	pushq  $0x0
  8018cf:	49 89 f1             	mov    %rsi,%r9
  8018d2:	49 89 c8             	mov    %rcx,%r8
  8018d5:	48 89 d1             	mov    %rdx,%rcx
  8018d8:	48 89 c2             	mov    %rax,%rdx
  8018db:	be 00 00 00 00       	mov    $0x0,%esi
  8018e0:	bf 0b 00 00 00       	mov    $0xb,%edi
  8018e5:	48 b8 33 15 80 00 00 	movabs $0x801533,%rax
  8018ec:	00 00 00 
  8018ef:	ff d0                	callq  *%rax
  8018f1:	48 83 c4 10          	add    $0x10,%rsp
}
  8018f5:	c9                   	leaveq 
  8018f6:	c3                   	retq   

00000000008018f7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8018f7:	55                   	push   %rbp
  8018f8:	48 89 e5             	mov    %rsp,%rbp
  8018fb:	48 83 ec 10          	sub    $0x10,%rsp
  8018ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801903:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801907:	48 83 ec 08          	sub    $0x8,%rsp
  80190b:	6a 00                	pushq  $0x0
  80190d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801913:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801919:	b9 00 00 00 00       	mov    $0x0,%ecx
  80191e:	48 89 c2             	mov    %rax,%rdx
  801921:	be 01 00 00 00       	mov    $0x1,%esi
  801926:	bf 0c 00 00 00       	mov    $0xc,%edi
  80192b:	48 b8 33 15 80 00 00 	movabs $0x801533,%rax
  801932:	00 00 00 
  801935:	ff d0                	callq  *%rax
  801937:	48 83 c4 10          	add    $0x10,%rsp
}
  80193b:	c9                   	leaveq 
  80193c:	c3                   	retq   

000000000080193d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80193d:	55                   	push   %rbp
  80193e:	48 89 e5             	mov    %rsp,%rbp
  801941:	53                   	push   %rbx
  801942:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801949:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801950:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801956:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80195d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801964:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80196b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801972:	84 c0                	test   %al,%al
  801974:	74 23                	je     801999 <_panic+0x5c>
  801976:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80197d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801981:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801985:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801989:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80198d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801991:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801995:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801999:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8019a0:	00 00 00 
  8019a3:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8019aa:	00 00 00 
  8019ad:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019b1:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8019b8:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8019bf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8019c6:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8019cd:	00 00 00 
  8019d0:	48 8b 18             	mov    (%rax),%rbx
  8019d3:	48 b8 90 16 80 00 00 	movabs $0x801690,%rax
  8019da:	00 00 00 
  8019dd:	ff d0                	callq  *%rax
  8019df:	89 c6                	mov    %eax,%esi
  8019e1:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8019e7:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8019ee:	41 89 d0             	mov    %edx,%r8d
  8019f1:	48 89 c1             	mov    %rax,%rcx
  8019f4:	48 89 da             	mov    %rbx,%rdx
  8019f7:	48 bf f8 1e 80 00 00 	movabs $0x801ef8,%rdi
  8019fe:	00 00 00 
  801a01:	b8 00 00 00 00       	mov    $0x0,%eax
  801a06:	49 b9 43 02 80 00 00 	movabs $0x800243,%r9
  801a0d:	00 00 00 
  801a10:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a13:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801a1a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a21:	48 89 d6             	mov    %rdx,%rsi
  801a24:	48 89 c7             	mov    %rax,%rdi
  801a27:	48 b8 97 01 80 00 00 	movabs $0x800197,%rax
  801a2e:	00 00 00 
  801a31:	ff d0                	callq  *%rax
	cprintf("\n");
  801a33:	48 bf 1b 1f 80 00 00 	movabs $0x801f1b,%rdi
  801a3a:	00 00 00 
  801a3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a42:	48 ba 43 02 80 00 00 	movabs $0x800243,%rdx
  801a49:	00 00 00 
  801a4c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a4e:	cc                   	int3   
  801a4f:	eb fd                	jmp    801a4e <_panic+0x111>
