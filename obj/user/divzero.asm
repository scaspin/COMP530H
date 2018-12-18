
obj/user/divzero:     file format elf64-x86-64


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
  80003c:	e8 55 00 00 00       	callq  800096 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	zero = 0;
  800052:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800059:	00 00 00 
  80005c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	cprintf("1/0 is %08x!\n", 1/zero);
  800062:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800069:	00 00 00 
  80006c:	8b 08                	mov    (%rax),%ecx
  80006e:	b8 01 00 00 00       	mov    $0x1,%eax
  800073:	99                   	cltd   
  800074:	f7 f9                	idiv   %ecx
  800076:	89 c6                	mov    %eax,%esi
  800078:	48 bf 80 1a 80 00 00 	movabs $0x801a80,%rdi
  80007f:	00 00 00 
  800082:	b8 00 00 00 00       	mov    $0x0,%eax
  800087:	48 ba 60 02 80 00 00 	movabs $0x800260,%rdx
  80008e:	00 00 00 
  800091:	ff d2                	callq  *%rdx
}
  800093:	90                   	nop
  800094:	c9                   	leaveq 
  800095:	c3                   	retq   

0000000000800096 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800096:	55                   	push   %rbp
  800097:	48 89 e5             	mov    %rsp,%rbp
  80009a:	48 83 ec 10          	sub    $0x10,%rsp
  80009e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  8000a5:	48 b8 ad 16 80 00 00 	movabs $0x8016ad,%rax
  8000ac:	00 00 00 
  8000af:	ff d0                	callq  *%rax
  8000b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b6:	48 63 d0             	movslq %eax,%rdx
  8000b9:	48 89 d0             	mov    %rdx,%rax
  8000bc:	48 c1 e0 03          	shl    $0x3,%rax
  8000c0:	48 01 d0             	add    %rdx,%rax
  8000c3:	48 c1 e0 05          	shl    $0x5,%rax
  8000c7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000ce:	00 00 00 
  8000d1:	48 01 c2             	add    %rax,%rdx
  8000d4:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  8000db:	00 00 00 
  8000de:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000e5:	7e 14                	jle    8000fb <libmain+0x65>
		binaryname = argv[0];
  8000e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000eb:	48 8b 10             	mov    (%rax),%rdx
  8000ee:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000f5:	00 00 00 
  8000f8:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800102:	48 89 d6             	mov    %rdx,%rsi
  800105:	89 c7                	mov    %eax,%edi
  800107:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80010e:	00 00 00 
  800111:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800113:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  80011a:	00 00 00 
  80011d:	ff d0                	callq  *%rax
}
  80011f:	90                   	nop
  800120:	c9                   	leaveq 
  800121:	c3                   	retq   

0000000000800122 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800122:	55                   	push   %rbp
  800123:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800126:	bf 00 00 00 00       	mov    $0x0,%edi
  80012b:	48 b8 67 16 80 00 00 	movabs $0x801667,%rax
  800132:	00 00 00 
  800135:	ff d0                	callq  *%rax
}
  800137:	90                   	nop
  800138:	5d                   	pop    %rbp
  800139:	c3                   	retq   

000000000080013a <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80013a:	55                   	push   %rbp
  80013b:	48 89 e5             	mov    %rsp,%rbp
  80013e:	48 83 ec 10          	sub    $0x10,%rsp
  800142:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800145:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800149:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80014d:	8b 00                	mov    (%rax),%eax
  80014f:	8d 48 01             	lea    0x1(%rax),%ecx
  800152:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800156:	89 0a                	mov    %ecx,(%rdx)
  800158:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80015b:	89 d1                	mov    %edx,%ecx
  80015d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800161:	48 98                	cltq   
  800163:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800167:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80016b:	8b 00                	mov    (%rax),%eax
  80016d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800172:	75 2c                	jne    8001a0 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800178:	8b 00                	mov    (%rax),%eax
  80017a:	48 98                	cltq   
  80017c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800180:	48 83 c2 08          	add    $0x8,%rdx
  800184:	48 89 c6             	mov    %rax,%rsi
  800187:	48 89 d7             	mov    %rdx,%rdi
  80018a:	48 b8 de 15 80 00 00 	movabs $0x8015de,%rax
  800191:	00 00 00 
  800194:	ff d0                	callq  *%rax
        b->idx = 0;
  800196:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80019a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a4:	8b 40 04             	mov    0x4(%rax),%eax
  8001a7:	8d 50 01             	lea    0x1(%rax),%edx
  8001aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ae:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001b1:	90                   	nop
  8001b2:	c9                   	leaveq 
  8001b3:	c3                   	retq   

00000000008001b4 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001b4:	55                   	push   %rbp
  8001b5:	48 89 e5             	mov    %rsp,%rbp
  8001b8:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001bf:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001c6:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001cd:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001d4:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001db:	48 8b 0a             	mov    (%rdx),%rcx
  8001de:	48 89 08             	mov    %rcx,(%rax)
  8001e1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001e5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001e9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001ed:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001f1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001f8:	00 00 00 
    b.cnt = 0;
  8001fb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800202:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800205:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80020c:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800213:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80021a:	48 89 c6             	mov    %rax,%rsi
  80021d:	48 bf 3a 01 80 00 00 	movabs $0x80013a,%rdi
  800224:	00 00 00 
  800227:	48 b8 fe 05 80 00 00 	movabs $0x8005fe,%rax
  80022e:	00 00 00 
  800231:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800233:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800239:	48 98                	cltq   
  80023b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800242:	48 83 c2 08          	add    $0x8,%rdx
  800246:	48 89 c6             	mov    %rax,%rsi
  800249:	48 89 d7             	mov    %rdx,%rdi
  80024c:	48 b8 de 15 80 00 00 	movabs $0x8015de,%rax
  800253:	00 00 00 
  800256:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800258:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80025e:	c9                   	leaveq 
  80025f:	c3                   	retq   

0000000000800260 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800260:	55                   	push   %rbp
  800261:	48 89 e5             	mov    %rsp,%rbp
  800264:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80026b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800272:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800279:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800280:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800287:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80028e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800295:	84 c0                	test   %al,%al
  800297:	74 20                	je     8002b9 <cprintf+0x59>
  800299:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80029d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002a1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002a5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002a9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002ad:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002b1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002b5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002b9:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002c0:	00 00 00 
  8002c3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002ca:	00 00 00 
  8002cd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002d1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002d8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002df:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002e6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002ed:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002f4:	48 8b 0a             	mov    (%rdx),%rcx
  8002f7:	48 89 08             	mov    %rcx,(%rax)
  8002fa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002fe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800302:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800306:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80030a:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800311:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800318:	48 89 d6             	mov    %rdx,%rsi
  80031b:	48 89 c7             	mov    %rax,%rdi
  80031e:	48 b8 b4 01 80 00 00 	movabs $0x8001b4,%rax
  800325:	00 00 00 
  800328:	ff d0                	callq  *%rax
  80032a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800330:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800336:	c9                   	leaveq 
  800337:	c3                   	retq   

0000000000800338 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800338:	55                   	push   %rbp
  800339:	48 89 e5             	mov    %rsp,%rbp
  80033c:	48 83 ec 30          	sub    $0x30,%rsp
  800340:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800344:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800348:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80034c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80034f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800353:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800357:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80035a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80035e:	77 54                	ja     8003b4 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800360:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800363:	8d 78 ff             	lea    -0x1(%rax),%edi
  800366:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80036d:	ba 00 00 00 00       	mov    $0x0,%edx
  800372:	48 f7 f6             	div    %rsi
  800375:	49 89 c2             	mov    %rax,%r10
  800378:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80037b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80037e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800386:	41 89 c9             	mov    %ecx,%r9d
  800389:	41 89 f8             	mov    %edi,%r8d
  80038c:	89 d1                	mov    %edx,%ecx
  80038e:	4c 89 d2             	mov    %r10,%rdx
  800391:	48 89 c7             	mov    %rax,%rdi
  800394:	48 b8 38 03 80 00 00 	movabs $0x800338,%rax
  80039b:	00 00 00 
  80039e:	ff d0                	callq  *%rax
  8003a0:	eb 1c                	jmp    8003be <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8003a6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8003a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003ad:	48 89 ce             	mov    %rcx,%rsi
  8003b0:	89 d7                	mov    %edx,%edi
  8003b2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b4:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8003b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003bc:	7f e4                	jg     8003a2 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003be:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8003c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ca:	48 f7 f1             	div    %rcx
  8003cd:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  8003d4:	00 00 00 
  8003d7:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8003db:	0f be d0             	movsbl %al,%edx
  8003de:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8003e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003e6:	48 89 ce             	mov    %rcx,%rsi
  8003e9:	89 d7                	mov    %edx,%edi
  8003eb:	ff d0                	callq  *%rax
}
  8003ed:	90                   	nop
  8003ee:	c9                   	leaveq 
  8003ef:	c3                   	retq   

00000000008003f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003f0:	55                   	push   %rbp
  8003f1:	48 89 e5             	mov    %rsp,%rbp
  8003f4:	48 83 ec 20          	sub    $0x20,%rsp
  8003f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003fc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8003ff:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800403:	7e 4f                	jle    800454 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800405:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800409:	8b 00                	mov    (%rax),%eax
  80040b:	83 f8 30             	cmp    $0x30,%eax
  80040e:	73 24                	jae    800434 <getuint+0x44>
  800410:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800414:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800418:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041c:	8b 00                	mov    (%rax),%eax
  80041e:	89 c0                	mov    %eax,%eax
  800420:	48 01 d0             	add    %rdx,%rax
  800423:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800427:	8b 12                	mov    (%rdx),%edx
  800429:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80042c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800430:	89 0a                	mov    %ecx,(%rdx)
  800432:	eb 14                	jmp    800448 <getuint+0x58>
  800434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800438:	48 8b 40 08          	mov    0x8(%rax),%rax
  80043c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800440:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800444:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800448:	48 8b 00             	mov    (%rax),%rax
  80044b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80044f:	e9 9d 00 00 00       	jmpq   8004f1 <getuint+0x101>
	else if (lflag)
  800454:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800458:	74 4c                	je     8004a6 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80045a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80045e:	8b 00                	mov    (%rax),%eax
  800460:	83 f8 30             	cmp    $0x30,%eax
  800463:	73 24                	jae    800489 <getuint+0x99>
  800465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800469:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80046d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800471:	8b 00                	mov    (%rax),%eax
  800473:	89 c0                	mov    %eax,%eax
  800475:	48 01 d0             	add    %rdx,%rax
  800478:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80047c:	8b 12                	mov    (%rdx),%edx
  80047e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800481:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800485:	89 0a                	mov    %ecx,(%rdx)
  800487:	eb 14                	jmp    80049d <getuint+0xad>
  800489:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800491:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800495:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800499:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80049d:	48 8b 00             	mov    (%rax),%rax
  8004a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004a4:	eb 4b                	jmp    8004f1 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8004a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004aa:	8b 00                	mov    (%rax),%eax
  8004ac:	83 f8 30             	cmp    $0x30,%eax
  8004af:	73 24                	jae    8004d5 <getuint+0xe5>
  8004b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bd:	8b 00                	mov    (%rax),%eax
  8004bf:	89 c0                	mov    %eax,%eax
  8004c1:	48 01 d0             	add    %rdx,%rax
  8004c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c8:	8b 12                	mov    (%rdx),%edx
  8004ca:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d1:	89 0a                	mov    %ecx,(%rdx)
  8004d3:	eb 14                	jmp    8004e9 <getuint+0xf9>
  8004d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004dd:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8004e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004e9:	8b 00                	mov    (%rax),%eax
  8004eb:	89 c0                	mov    %eax,%eax
  8004ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004f5:	c9                   	leaveq 
  8004f6:	c3                   	retq   

00000000008004f7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f7:	55                   	push   %rbp
  8004f8:	48 89 e5             	mov    %rsp,%rbp
  8004fb:	48 83 ec 20          	sub    $0x20,%rsp
  8004ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800503:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800506:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80050a:	7e 4f                	jle    80055b <getint+0x64>
		x=va_arg(*ap, long long);
  80050c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800510:	8b 00                	mov    (%rax),%eax
  800512:	83 f8 30             	cmp    $0x30,%eax
  800515:	73 24                	jae    80053b <getint+0x44>
  800517:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80051f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800523:	8b 00                	mov    (%rax),%eax
  800525:	89 c0                	mov    %eax,%eax
  800527:	48 01 d0             	add    %rdx,%rax
  80052a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80052e:	8b 12                	mov    (%rdx),%edx
  800530:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800533:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800537:	89 0a                	mov    %ecx,(%rdx)
  800539:	eb 14                	jmp    80054f <getint+0x58>
  80053b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800543:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800547:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80054f:	48 8b 00             	mov    (%rax),%rax
  800552:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800556:	e9 9d 00 00 00       	jmpq   8005f8 <getint+0x101>
	else if (lflag)
  80055b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80055f:	74 4c                	je     8005ad <getint+0xb6>
		x=va_arg(*ap, long);
  800561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800565:	8b 00                	mov    (%rax),%eax
  800567:	83 f8 30             	cmp    $0x30,%eax
  80056a:	73 24                	jae    800590 <getint+0x99>
  80056c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800570:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800578:	8b 00                	mov    (%rax),%eax
  80057a:	89 c0                	mov    %eax,%eax
  80057c:	48 01 d0             	add    %rdx,%rax
  80057f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800583:	8b 12                	mov    (%rdx),%edx
  800585:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800588:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058c:	89 0a                	mov    %ecx,(%rdx)
  80058e:	eb 14                	jmp    8005a4 <getint+0xad>
  800590:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800594:	48 8b 40 08          	mov    0x8(%rax),%rax
  800598:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80059c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005a4:	48 8b 00             	mov    (%rax),%rax
  8005a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005ab:	eb 4b                	jmp    8005f8 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8005ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b1:	8b 00                	mov    (%rax),%eax
  8005b3:	83 f8 30             	cmp    $0x30,%eax
  8005b6:	73 24                	jae    8005dc <getint+0xe5>
  8005b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c4:	8b 00                	mov    (%rax),%eax
  8005c6:	89 c0                	mov    %eax,%eax
  8005c8:	48 01 d0             	add    %rdx,%rax
  8005cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005cf:	8b 12                	mov    (%rdx),%edx
  8005d1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d8:	89 0a                	mov    %ecx,(%rdx)
  8005da:	eb 14                	jmp    8005f0 <getint+0xf9>
  8005dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005e4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ec:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005f0:	8b 00                	mov    (%rax),%eax
  8005f2:	48 98                	cltq   
  8005f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005fc:	c9                   	leaveq 
  8005fd:	c3                   	retq   

00000000008005fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005fe:	55                   	push   %rbp
  8005ff:	48 89 e5             	mov    %rsp,%rbp
  800602:	41 54                	push   %r12
  800604:	53                   	push   %rbx
  800605:	48 83 ec 60          	sub    $0x60,%rsp
  800609:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80060d:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800611:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800615:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800619:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80061d:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800621:	48 8b 0a             	mov    (%rdx),%rcx
  800624:	48 89 08             	mov    %rcx,(%rax)
  800627:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80062b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80062f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800633:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800637:	eb 17                	jmp    800650 <vprintfmt+0x52>
			if (ch == '\0')
  800639:	85 db                	test   %ebx,%ebx
  80063b:	0f 84 b9 04 00 00    	je     800afa <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800641:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800645:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800649:	48 89 d6             	mov    %rdx,%rsi
  80064c:	89 df                	mov    %ebx,%edi
  80064e:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800650:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800654:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800658:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80065c:	0f b6 00             	movzbl (%rax),%eax
  80065f:	0f b6 d8             	movzbl %al,%ebx
  800662:	83 fb 25             	cmp    $0x25,%ebx
  800665:	75 d2                	jne    800639 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800667:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80066b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800672:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800679:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800680:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800687:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80068b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80068f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800693:	0f b6 00             	movzbl (%rax),%eax
  800696:	0f b6 d8             	movzbl %al,%ebx
  800699:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80069c:	83 f8 55             	cmp    $0x55,%eax
  80069f:	0f 87 22 04 00 00    	ja     800ac7 <vprintfmt+0x4c9>
  8006a5:	89 c0                	mov    %eax,%eax
  8006a7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006ae:	00 
  8006af:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  8006b6:	00 00 00 
  8006b9:	48 01 d0             	add    %rdx,%rax
  8006bc:	48 8b 00             	mov    (%rax),%rax
  8006bf:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006c1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006c5:	eb c0                	jmp    800687 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006c7:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006cb:	eb ba                	jmp    800687 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006cd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006d4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006d7:	89 d0                	mov    %edx,%eax
  8006d9:	c1 e0 02             	shl    $0x2,%eax
  8006dc:	01 d0                	add    %edx,%eax
  8006de:	01 c0                	add    %eax,%eax
  8006e0:	01 d8                	add    %ebx,%eax
  8006e2:	83 e8 30             	sub    $0x30,%eax
  8006e5:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006e8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006ec:	0f b6 00             	movzbl (%rax),%eax
  8006ef:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006f2:	83 fb 2f             	cmp    $0x2f,%ebx
  8006f5:	7e 60                	jle    800757 <vprintfmt+0x159>
  8006f7:	83 fb 39             	cmp    $0x39,%ebx
  8006fa:	7f 5b                	jg     800757 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006fc:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800701:	eb d1                	jmp    8006d4 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800703:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800706:	83 f8 30             	cmp    $0x30,%eax
  800709:	73 17                	jae    800722 <vprintfmt+0x124>
  80070b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80070f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800712:	89 d2                	mov    %edx,%edx
  800714:	48 01 d0             	add    %rdx,%rax
  800717:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80071a:	83 c2 08             	add    $0x8,%edx
  80071d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800720:	eb 0c                	jmp    80072e <vprintfmt+0x130>
  800722:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800726:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80072a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80072e:	8b 00                	mov    (%rax),%eax
  800730:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800733:	eb 23                	jmp    800758 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800735:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800739:	0f 89 48 ff ff ff    	jns    800687 <vprintfmt+0x89>
				width = 0;
  80073f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800746:	e9 3c ff ff ff       	jmpq   800687 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80074b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800752:	e9 30 ff ff ff       	jmpq   800687 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800757:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800758:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80075c:	0f 89 25 ff ff ff    	jns    800687 <vprintfmt+0x89>
				width = precision, precision = -1;
  800762:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800765:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800768:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80076f:	e9 13 ff ff ff       	jmpq   800687 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800774:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800778:	e9 0a ff ff ff       	jmpq   800687 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80077d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800780:	83 f8 30             	cmp    $0x30,%eax
  800783:	73 17                	jae    80079c <vprintfmt+0x19e>
  800785:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800789:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80078c:	89 d2                	mov    %edx,%edx
  80078e:	48 01 d0             	add    %rdx,%rax
  800791:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800794:	83 c2 08             	add    $0x8,%edx
  800797:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80079a:	eb 0c                	jmp    8007a8 <vprintfmt+0x1aa>
  80079c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8007a0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8007a4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007a8:	8b 10                	mov    (%rax),%edx
  8007aa:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007ae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007b2:	48 89 ce             	mov    %rcx,%rsi
  8007b5:	89 d7                	mov    %edx,%edi
  8007b7:	ff d0                	callq  *%rax
			break;
  8007b9:	e9 37 03 00 00       	jmpq   800af5 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007be:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c1:	83 f8 30             	cmp    $0x30,%eax
  8007c4:	73 17                	jae    8007dd <vprintfmt+0x1df>
  8007c6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8007ca:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007cd:	89 d2                	mov    %edx,%edx
  8007cf:	48 01 d0             	add    %rdx,%rax
  8007d2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007d5:	83 c2 08             	add    $0x8,%edx
  8007d8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007db:	eb 0c                	jmp    8007e9 <vprintfmt+0x1eb>
  8007dd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8007e1:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8007e5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007e9:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8007eb:	85 db                	test   %ebx,%ebx
  8007ed:	79 02                	jns    8007f1 <vprintfmt+0x1f3>
				err = -err;
  8007ef:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007f1:	83 fb 15             	cmp    $0x15,%ebx
  8007f4:	7f 16                	jg     80080c <vprintfmt+0x20e>
  8007f6:	48 b8 40 1b 80 00 00 	movabs $0x801b40,%rax
  8007fd:	00 00 00 
  800800:	48 63 d3             	movslq %ebx,%rdx
  800803:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800807:	4d 85 e4             	test   %r12,%r12
  80080a:	75 2e                	jne    80083a <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  80080c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800810:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800814:	89 d9                	mov    %ebx,%ecx
  800816:	48 ba 01 1c 80 00 00 	movabs $0x801c01,%rdx
  80081d:	00 00 00 
  800820:	48 89 c7             	mov    %rax,%rdi
  800823:	b8 00 00 00 00       	mov    $0x0,%eax
  800828:	49 b8 04 0b 80 00 00 	movabs $0x800b04,%r8
  80082f:	00 00 00 
  800832:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800835:	e9 bb 02 00 00       	jmpq   800af5 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80083a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80083e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800842:	4c 89 e1             	mov    %r12,%rcx
  800845:	48 ba 0a 1c 80 00 00 	movabs $0x801c0a,%rdx
  80084c:	00 00 00 
  80084f:	48 89 c7             	mov    %rax,%rdi
  800852:	b8 00 00 00 00       	mov    $0x0,%eax
  800857:	49 b8 04 0b 80 00 00 	movabs $0x800b04,%r8
  80085e:	00 00 00 
  800861:	41 ff d0             	callq  *%r8
			break;
  800864:	e9 8c 02 00 00       	jmpq   800af5 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800869:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086c:	83 f8 30             	cmp    $0x30,%eax
  80086f:	73 17                	jae    800888 <vprintfmt+0x28a>
  800871:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800875:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800878:	89 d2                	mov    %edx,%edx
  80087a:	48 01 d0             	add    %rdx,%rax
  80087d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800880:	83 c2 08             	add    $0x8,%edx
  800883:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800886:	eb 0c                	jmp    800894 <vprintfmt+0x296>
  800888:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80088c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800890:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800894:	4c 8b 20             	mov    (%rax),%r12
  800897:	4d 85 e4             	test   %r12,%r12
  80089a:	75 0a                	jne    8008a6 <vprintfmt+0x2a8>
				p = "(null)";
  80089c:	49 bc 0d 1c 80 00 00 	movabs $0x801c0d,%r12
  8008a3:	00 00 00 
			if (width > 0 && padc != '-')
  8008a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008aa:	7e 78                	jle    800924 <vprintfmt+0x326>
  8008ac:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008b0:	74 72                	je     800924 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008b5:	48 98                	cltq   
  8008b7:	48 89 c6             	mov    %rax,%rsi
  8008ba:	4c 89 e7             	mov    %r12,%rdi
  8008bd:	48 b8 b2 0d 80 00 00 	movabs $0x800db2,%rax
  8008c4:	00 00 00 
  8008c7:	ff d0                	callq  *%rax
  8008c9:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008cc:	eb 17                	jmp    8008e5 <vprintfmt+0x2e7>
					putch(padc, putdat);
  8008ce:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008d2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008d6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008da:	48 89 ce             	mov    %rcx,%rsi
  8008dd:	89 d7                	mov    %edx,%edi
  8008df:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e9:	7f e3                	jg     8008ce <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008eb:	eb 37                	jmp    800924 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8008f1:	74 1e                	je     800911 <vprintfmt+0x313>
  8008f3:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f6:	7e 05                	jle    8008fd <vprintfmt+0x2ff>
  8008f8:	83 fb 7e             	cmp    $0x7e,%ebx
  8008fb:	7e 14                	jle    800911 <vprintfmt+0x313>
					putch('?', putdat);
  8008fd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800901:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800905:	48 89 d6             	mov    %rdx,%rsi
  800908:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80090d:	ff d0                	callq  *%rax
  80090f:	eb 0f                	jmp    800920 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800911:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800915:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800919:	48 89 d6             	mov    %rdx,%rsi
  80091c:	89 df                	mov    %ebx,%edi
  80091e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800920:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800924:	4c 89 e0             	mov    %r12,%rax
  800927:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80092b:	0f b6 00             	movzbl (%rax),%eax
  80092e:	0f be d8             	movsbl %al,%ebx
  800931:	85 db                	test   %ebx,%ebx
  800933:	74 28                	je     80095d <vprintfmt+0x35f>
  800935:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800939:	78 b2                	js     8008ed <vprintfmt+0x2ef>
  80093b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80093f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800943:	79 a8                	jns    8008ed <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800945:	eb 16                	jmp    80095d <vprintfmt+0x35f>
				putch(' ', putdat);
  800947:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80094b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80094f:	48 89 d6             	mov    %rdx,%rsi
  800952:	bf 20 00 00 00       	mov    $0x20,%edi
  800957:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800959:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80095d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800961:	7f e4                	jg     800947 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800963:	e9 8d 01 00 00       	jmpq   800af5 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800968:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80096c:	be 03 00 00 00       	mov    $0x3,%esi
  800971:	48 89 c7             	mov    %rax,%rdi
  800974:	48 b8 f7 04 80 00 00 	movabs $0x8004f7,%rax
  80097b:	00 00 00 
  80097e:	ff d0                	callq  *%rax
  800980:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800984:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800988:	48 85 c0             	test   %rax,%rax
  80098b:	79 1d                	jns    8009aa <vprintfmt+0x3ac>
				putch('-', putdat);
  80098d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800991:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800995:	48 89 d6             	mov    %rdx,%rsi
  800998:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80099d:	ff d0                	callq  *%rax
				num = -(long long) num;
  80099f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a3:	48 f7 d8             	neg    %rax
  8009a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009aa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009b1:	e9 d2 00 00 00       	jmpq   800a88 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009b6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009ba:	be 03 00 00 00       	mov    $0x3,%esi
  8009bf:	48 89 c7             	mov    %rax,%rdi
  8009c2:	48 b8 f0 03 80 00 00 	movabs $0x8003f0,%rax
  8009c9:	00 00 00 
  8009cc:	ff d0                	callq  *%rax
  8009ce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009d2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009d9:	e9 aa 00 00 00       	jmpq   800a88 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  8009de:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009e2:	be 03 00 00 00       	mov    $0x3,%esi
  8009e7:	48 89 c7             	mov    %rax,%rdi
  8009ea:	48 b8 f0 03 80 00 00 	movabs $0x8003f0,%rax
  8009f1:	00 00 00 
  8009f4:	ff d0                	callq  *%rax
  8009f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8009fa:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a01:	e9 82 00 00 00       	jmpq   800a88 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800a06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0e:	48 89 d6             	mov    %rdx,%rsi
  800a11:	bf 30 00 00 00       	mov    $0x30,%edi
  800a16:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a18:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a20:	48 89 d6             	mov    %rdx,%rsi
  800a23:	bf 78 00 00 00       	mov    $0x78,%edi
  800a28:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2d:	83 f8 30             	cmp    $0x30,%eax
  800a30:	73 17                	jae    800a49 <vprintfmt+0x44b>
  800a32:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a36:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a39:	89 d2                	mov    %edx,%edx
  800a3b:	48 01 d0             	add    %rdx,%rax
  800a3e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a41:	83 c2 08             	add    $0x8,%edx
  800a44:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a47:	eb 0c                	jmp    800a55 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800a49:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a4d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a51:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a55:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a58:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a5c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a63:	eb 23                	jmp    800a88 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a65:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a69:	be 03 00 00 00       	mov    $0x3,%esi
  800a6e:	48 89 c7             	mov    %rax,%rdi
  800a71:	48 b8 f0 03 80 00 00 	movabs $0x8003f0,%rax
  800a78:	00 00 00 
  800a7b:	ff d0                	callq  *%rax
  800a7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800a81:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a88:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800a8d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800a90:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800a93:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a97:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9f:	45 89 c1             	mov    %r8d,%r9d
  800aa2:	41 89 f8             	mov    %edi,%r8d
  800aa5:	48 89 c7             	mov    %rax,%rdi
  800aa8:	48 b8 38 03 80 00 00 	movabs $0x800338,%rax
  800aaf:	00 00 00 
  800ab2:	ff d0                	callq  *%rax
			break;
  800ab4:	eb 3f                	jmp    800af5 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ab6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800abe:	48 89 d6             	mov    %rdx,%rsi
  800ac1:	89 df                	mov    %ebx,%edi
  800ac3:	ff d0                	callq  *%rax
			break;
  800ac5:	eb 2e                	jmp    800af5 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ac7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800acb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800acf:	48 89 d6             	mov    %rdx,%rsi
  800ad2:	bf 25 00 00 00       	mov    $0x25,%edi
  800ad7:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ade:	eb 05                	jmp    800ae5 <vprintfmt+0x4e7>
  800ae0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ae5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ae9:	48 83 e8 01          	sub    $0x1,%rax
  800aed:	0f b6 00             	movzbl (%rax),%eax
  800af0:	3c 25                	cmp    $0x25,%al
  800af2:	75 ec                	jne    800ae0 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800af4:	90                   	nop
		}
	}
  800af5:	e9 3d fb ff ff       	jmpq   800637 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800afa:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800afb:	48 83 c4 60          	add    $0x60,%rsp
  800aff:	5b                   	pop    %rbx
  800b00:	41 5c                	pop    %r12
  800b02:	5d                   	pop    %rbp
  800b03:	c3                   	retq   

0000000000800b04 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b04:	55                   	push   %rbp
  800b05:	48 89 e5             	mov    %rsp,%rbp
  800b08:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b0f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b16:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b1d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800b24:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b2b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b32:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b39:	84 c0                	test   %al,%al
  800b3b:	74 20                	je     800b5d <printfmt+0x59>
  800b3d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b41:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b45:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b49:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b4d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b51:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b55:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b59:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b5d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b64:	00 00 00 
  800b67:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b6e:	00 00 00 
  800b71:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b75:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800b7c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b83:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800b8a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800b91:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800b98:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800b9f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ba6:	48 89 c7             	mov    %rax,%rdi
  800ba9:	48 b8 fe 05 80 00 00 	movabs $0x8005fe,%rax
  800bb0:	00 00 00 
  800bb3:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bb5:	90                   	nop
  800bb6:	c9                   	leaveq 
  800bb7:	c3                   	retq   

0000000000800bb8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bb8:	55                   	push   %rbp
  800bb9:	48 89 e5             	mov    %rsp,%rbp
  800bbc:	48 83 ec 10          	sub    $0x10,%rsp
  800bc0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bc3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bcb:	8b 40 10             	mov    0x10(%rax),%eax
  800bce:	8d 50 01             	lea    0x1(%rax),%edx
  800bd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bd5:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800bd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bdc:	48 8b 10             	mov    (%rax),%rdx
  800bdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800be3:	48 8b 40 08          	mov    0x8(%rax),%rax
  800be7:	48 39 c2             	cmp    %rax,%rdx
  800bea:	73 17                	jae    800c03 <sprintputch+0x4b>
		*b->buf++ = ch;
  800bec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bf0:	48 8b 00             	mov    (%rax),%rax
  800bf3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800bf7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bfb:	48 89 0a             	mov    %rcx,(%rdx)
  800bfe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c01:	88 10                	mov    %dl,(%rax)
}
  800c03:	90                   	nop
  800c04:	c9                   	leaveq 
  800c05:	c3                   	retq   

0000000000800c06 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c06:	55                   	push   %rbp
  800c07:	48 89 e5             	mov    %rsp,%rbp
  800c0a:	48 83 ec 50          	sub    $0x50,%rsp
  800c0e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c12:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c15:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c19:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c1d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c21:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c25:	48 8b 0a             	mov    (%rdx),%rcx
  800c28:	48 89 08             	mov    %rcx,(%rax)
  800c2b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c2f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c33:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c37:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c3b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c3f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c43:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c46:	48 98                	cltq   
  800c48:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c4c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c50:	48 01 d0             	add    %rdx,%rax
  800c53:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c57:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c5e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c63:	74 06                	je     800c6b <vsnprintf+0x65>
  800c65:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c69:	7f 07                	jg     800c72 <vsnprintf+0x6c>
		return -E_INVAL;
  800c6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c70:	eb 2f                	jmp    800ca1 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c72:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c76:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800c7a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c7e:	48 89 c6             	mov    %rax,%rsi
  800c81:	48 bf b8 0b 80 00 00 	movabs $0x800bb8,%rdi
  800c88:	00 00 00 
  800c8b:	48 b8 fe 05 80 00 00 	movabs $0x8005fe,%rax
  800c92:	00 00 00 
  800c95:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800c97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c9b:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800c9e:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ca1:	c9                   	leaveq 
  800ca2:	c3                   	retq   

0000000000800ca3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ca3:	55                   	push   %rbp
  800ca4:	48 89 e5             	mov    %rsp,%rbp
  800ca7:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cae:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cb5:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cbb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800cc2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cc9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cd0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cd7:	84 c0                	test   %al,%al
  800cd9:	74 20                	je     800cfb <snprintf+0x58>
  800cdb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cdf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ce3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ce7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ceb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cef:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cf3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800cf7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800cfb:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d02:	00 00 00 
  800d05:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d0c:	00 00 00 
  800d0f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d13:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d1a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d21:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d28:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d2f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d36:	48 8b 0a             	mov    (%rdx),%rcx
  800d39:	48 89 08             	mov    %rcx,(%rax)
  800d3c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d40:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d44:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d48:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d4c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d53:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d5a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d60:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d67:	48 89 c7             	mov    %rax,%rdi
  800d6a:	48 b8 06 0c 80 00 00 	movabs $0x800c06,%rax
  800d71:	00 00 00 
  800d74:	ff d0                	callq  *%rax
  800d76:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800d7c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800d82:	c9                   	leaveq 
  800d83:	c3                   	retq   

0000000000800d84 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d84:	55                   	push   %rbp
  800d85:	48 89 e5             	mov    %rsp,%rbp
  800d88:	48 83 ec 18          	sub    $0x18,%rsp
  800d8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800d90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800d97:	eb 09                	jmp    800da2 <strlen+0x1e>
		n++;
  800d99:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d9d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800da2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da6:	0f b6 00             	movzbl (%rax),%eax
  800da9:	84 c0                	test   %al,%al
  800dab:	75 ec                	jne    800d99 <strlen+0x15>
		n++;
	return n;
  800dad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800db0:	c9                   	leaveq 
  800db1:	c3                   	retq   

0000000000800db2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800db2:	55                   	push   %rbp
  800db3:	48 89 e5             	mov    %rsp,%rbp
  800db6:	48 83 ec 20          	sub    $0x20,%rsp
  800dba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dbe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dc9:	eb 0e                	jmp    800dd9 <strnlen+0x27>
		n++;
  800dcb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dcf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dd4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800dd9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800dde:	74 0b                	je     800deb <strnlen+0x39>
  800de0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de4:	0f b6 00             	movzbl (%rax),%eax
  800de7:	84 c0                	test   %al,%al
  800de9:	75 e0                	jne    800dcb <strnlen+0x19>
		n++;
	return n;
  800deb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dee:	c9                   	leaveq 
  800def:	c3                   	retq   

0000000000800df0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800df0:	55                   	push   %rbp
  800df1:	48 89 e5             	mov    %rsp,%rbp
  800df4:	48 83 ec 20          	sub    $0x20,%rsp
  800df8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dfc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e04:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e08:	90                   	nop
  800e09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e0d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e11:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e15:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e19:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e1d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e21:	0f b6 12             	movzbl (%rdx),%edx
  800e24:	88 10                	mov    %dl,(%rax)
  800e26:	0f b6 00             	movzbl (%rax),%eax
  800e29:	84 c0                	test   %al,%al
  800e2b:	75 dc                	jne    800e09 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e31:	c9                   	leaveq 
  800e32:	c3                   	retq   

0000000000800e33 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e33:	55                   	push   %rbp
  800e34:	48 89 e5             	mov    %rsp,%rbp
  800e37:	48 83 ec 20          	sub    $0x20,%rsp
  800e3b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e3f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e47:	48 89 c7             	mov    %rax,%rdi
  800e4a:	48 b8 84 0d 80 00 00 	movabs $0x800d84,%rax
  800e51:	00 00 00 
  800e54:	ff d0                	callq  *%rax
  800e56:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e5c:	48 63 d0             	movslq %eax,%rdx
  800e5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e63:	48 01 c2             	add    %rax,%rdx
  800e66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e6a:	48 89 c6             	mov    %rax,%rsi
  800e6d:	48 89 d7             	mov    %rdx,%rdi
  800e70:	48 b8 f0 0d 80 00 00 	movabs $0x800df0,%rax
  800e77:	00 00 00 
  800e7a:	ff d0                	callq  *%rax
	return dst;
  800e7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800e80:	c9                   	leaveq 
  800e81:	c3                   	retq   

0000000000800e82 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e82:	55                   	push   %rbp
  800e83:	48 89 e5             	mov    %rsp,%rbp
  800e86:	48 83 ec 28          	sub    $0x28,%rsp
  800e8a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e8e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e92:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800e9e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ea5:	00 
  800ea6:	eb 2a                	jmp    800ed2 <strncpy+0x50>
		*dst++ = *src;
  800ea8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800eb0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800eb4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800eb8:	0f b6 12             	movzbl (%rdx),%edx
  800ebb:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ebd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ec1:	0f b6 00             	movzbl (%rax),%eax
  800ec4:	84 c0                	test   %al,%al
  800ec6:	74 05                	je     800ecd <strncpy+0x4b>
			src++;
  800ec8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ecd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ed2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ed6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800eda:	72 cc                	jb     800ea8 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800edc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800ee0:	c9                   	leaveq 
  800ee1:	c3                   	retq   

0000000000800ee2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ee2:	55                   	push   %rbp
  800ee3:	48 89 e5             	mov    %rsp,%rbp
  800ee6:	48 83 ec 28          	sub    $0x28,%rsp
  800eea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ef2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800ef6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800efe:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f03:	74 3d                	je     800f42 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f05:	eb 1d                	jmp    800f24 <strlcpy+0x42>
			*dst++ = *src++;
  800f07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f0f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f13:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f17:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f1b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f1f:	0f b6 12             	movzbl (%rdx),%edx
  800f22:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f24:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f29:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f2e:	74 0b                	je     800f3b <strlcpy+0x59>
  800f30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f34:	0f b6 00             	movzbl (%rax),%eax
  800f37:	84 c0                	test   %al,%al
  800f39:	75 cc                	jne    800f07 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3f:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f42:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f4a:	48 29 c2             	sub    %rax,%rdx
  800f4d:	48 89 d0             	mov    %rdx,%rax
}
  800f50:	c9                   	leaveq 
  800f51:	c3                   	retq   

0000000000800f52 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f52:	55                   	push   %rbp
  800f53:	48 89 e5             	mov    %rsp,%rbp
  800f56:	48 83 ec 10          	sub    $0x10,%rsp
  800f5a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f62:	eb 0a                	jmp    800f6e <strcmp+0x1c>
		p++, q++;
  800f64:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f69:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f72:	0f b6 00             	movzbl (%rax),%eax
  800f75:	84 c0                	test   %al,%al
  800f77:	74 12                	je     800f8b <strcmp+0x39>
  800f79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f7d:	0f b6 10             	movzbl (%rax),%edx
  800f80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f84:	0f b6 00             	movzbl (%rax),%eax
  800f87:	38 c2                	cmp    %al,%dl
  800f89:	74 d9                	je     800f64 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f8f:	0f b6 00             	movzbl (%rax),%eax
  800f92:	0f b6 d0             	movzbl %al,%edx
  800f95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f99:	0f b6 00             	movzbl (%rax),%eax
  800f9c:	0f b6 c0             	movzbl %al,%eax
  800f9f:	29 c2                	sub    %eax,%edx
  800fa1:	89 d0                	mov    %edx,%eax
}
  800fa3:	c9                   	leaveq 
  800fa4:	c3                   	retq   

0000000000800fa5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fa5:	55                   	push   %rbp
  800fa6:	48 89 e5             	mov    %rsp,%rbp
  800fa9:	48 83 ec 18          	sub    $0x18,%rsp
  800fad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fb1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fb5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fb9:	eb 0f                	jmp    800fca <strncmp+0x25>
		n--, p++, q++;
  800fbb:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fc0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fc5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800fca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fcf:	74 1d                	je     800fee <strncmp+0x49>
  800fd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fd5:	0f b6 00             	movzbl (%rax),%eax
  800fd8:	84 c0                	test   %al,%al
  800fda:	74 12                	je     800fee <strncmp+0x49>
  800fdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fe0:	0f b6 10             	movzbl (%rax),%edx
  800fe3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe7:	0f b6 00             	movzbl (%rax),%eax
  800fea:	38 c2                	cmp    %al,%dl
  800fec:	74 cd                	je     800fbb <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  800fee:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800ff3:	75 07                	jne    800ffc <strncmp+0x57>
		return 0;
  800ff5:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffa:	eb 18                	jmp    801014 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ffc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801000:	0f b6 00             	movzbl (%rax),%eax
  801003:	0f b6 d0             	movzbl %al,%edx
  801006:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100a:	0f b6 00             	movzbl (%rax),%eax
  80100d:	0f b6 c0             	movzbl %al,%eax
  801010:	29 c2                	sub    %eax,%edx
  801012:	89 d0                	mov    %edx,%eax
}
  801014:	c9                   	leaveq 
  801015:	c3                   	retq   

0000000000801016 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801016:	55                   	push   %rbp
  801017:	48 89 e5             	mov    %rsp,%rbp
  80101a:	48 83 ec 10          	sub    $0x10,%rsp
  80101e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801022:	89 f0                	mov    %esi,%eax
  801024:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801027:	eb 17                	jmp    801040 <strchr+0x2a>
		if (*s == c)
  801029:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102d:	0f b6 00             	movzbl (%rax),%eax
  801030:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801033:	75 06                	jne    80103b <strchr+0x25>
			return (char *) s;
  801035:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801039:	eb 15                	jmp    801050 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80103b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801040:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801044:	0f b6 00             	movzbl (%rax),%eax
  801047:	84 c0                	test   %al,%al
  801049:	75 de                	jne    801029 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801050:	c9                   	leaveq 
  801051:	c3                   	retq   

0000000000801052 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801052:	55                   	push   %rbp
  801053:	48 89 e5             	mov    %rsp,%rbp
  801056:	48 83 ec 10          	sub    $0x10,%rsp
  80105a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80105e:	89 f0                	mov    %esi,%eax
  801060:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801063:	eb 11                	jmp    801076 <strfind+0x24>
		if (*s == c)
  801065:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801069:	0f b6 00             	movzbl (%rax),%eax
  80106c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80106f:	74 12                	je     801083 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801071:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801076:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107a:	0f b6 00             	movzbl (%rax),%eax
  80107d:	84 c0                	test   %al,%al
  80107f:	75 e4                	jne    801065 <strfind+0x13>
  801081:	eb 01                	jmp    801084 <strfind+0x32>
		if (*s == c)
			break;
  801083:	90                   	nop
	return (char *) s;
  801084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801088:	c9                   	leaveq 
  801089:	c3                   	retq   

000000000080108a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80108a:	55                   	push   %rbp
  80108b:	48 89 e5             	mov    %rsp,%rbp
  80108e:	48 83 ec 18          	sub    $0x18,%rsp
  801092:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801096:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801099:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80109d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010a2:	75 06                	jne    8010aa <memset+0x20>
		return v;
  8010a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a8:	eb 69                	jmp    801113 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ae:	83 e0 03             	and    $0x3,%eax
  8010b1:	48 85 c0             	test   %rax,%rax
  8010b4:	75 48                	jne    8010fe <memset+0x74>
  8010b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ba:	83 e0 03             	and    $0x3,%eax
  8010bd:	48 85 c0             	test   %rax,%rax
  8010c0:	75 3c                	jne    8010fe <memset+0x74>
		c &= 0xFF;
  8010c2:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010cc:	c1 e0 18             	shl    $0x18,%eax
  8010cf:	89 c2                	mov    %eax,%edx
  8010d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010d4:	c1 e0 10             	shl    $0x10,%eax
  8010d7:	09 c2                	or     %eax,%edx
  8010d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010dc:	c1 e0 08             	shl    $0x8,%eax
  8010df:	09 d0                	or     %edx,%eax
  8010e1:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8010e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e8:	48 c1 e8 02          	shr    $0x2,%rax
  8010ec:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8010ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8010f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010f6:	48 89 d7             	mov    %rdx,%rdi
  8010f9:	fc                   	cld    
  8010fa:	f3 ab                	rep stos %eax,%es:(%rdi)
  8010fc:	eb 11                	jmp    80110f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8010fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801102:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801105:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801109:	48 89 d7             	mov    %rdx,%rdi
  80110c:	fc                   	cld    
  80110d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80110f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801113:	c9                   	leaveq 
  801114:	c3                   	retq   

0000000000801115 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801115:	55                   	push   %rbp
  801116:	48 89 e5             	mov    %rsp,%rbp
  801119:	48 83 ec 28          	sub    $0x28,%rsp
  80111d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801121:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801125:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801129:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80112d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801131:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801135:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801139:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801141:	0f 83 88 00 00 00    	jae    8011cf <memmove+0xba>
  801147:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80114b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80114f:	48 01 d0             	add    %rdx,%rax
  801152:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801156:	76 77                	jbe    8011cf <memmove+0xba>
		s += n;
  801158:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80115c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801160:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801164:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801168:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116c:	83 e0 03             	and    $0x3,%eax
  80116f:	48 85 c0             	test   %rax,%rax
  801172:	75 3b                	jne    8011af <memmove+0x9a>
  801174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801178:	83 e0 03             	and    $0x3,%eax
  80117b:	48 85 c0             	test   %rax,%rax
  80117e:	75 2f                	jne    8011af <memmove+0x9a>
  801180:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801184:	83 e0 03             	and    $0x3,%eax
  801187:	48 85 c0             	test   %rax,%rax
  80118a:	75 23                	jne    8011af <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80118c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801190:	48 83 e8 04          	sub    $0x4,%rax
  801194:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801198:	48 83 ea 04          	sub    $0x4,%rdx
  80119c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011a0:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011a4:	48 89 c7             	mov    %rax,%rdi
  8011a7:	48 89 d6             	mov    %rdx,%rsi
  8011aa:	fd                   	std    
  8011ab:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011ad:	eb 1d                	jmp    8011cc <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bb:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011c3:	48 89 d7             	mov    %rdx,%rdi
  8011c6:	48 89 c1             	mov    %rax,%rcx
  8011c9:	fd                   	std    
  8011ca:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011cc:	fc                   	cld    
  8011cd:	eb 57                	jmp    801226 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d3:	83 e0 03             	and    $0x3,%eax
  8011d6:	48 85 c0             	test   %rax,%rax
  8011d9:	75 36                	jne    801211 <memmove+0xfc>
  8011db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011df:	83 e0 03             	and    $0x3,%eax
  8011e2:	48 85 c0             	test   %rax,%rax
  8011e5:	75 2a                	jne    801211 <memmove+0xfc>
  8011e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011eb:	83 e0 03             	and    $0x3,%eax
  8011ee:	48 85 c0             	test   %rax,%rax
  8011f1:	75 1e                	jne    801211 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8011f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f7:	48 c1 e8 02          	shr    $0x2,%rax
  8011fb:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8011fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801202:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801206:	48 89 c7             	mov    %rax,%rdi
  801209:	48 89 d6             	mov    %rdx,%rsi
  80120c:	fc                   	cld    
  80120d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80120f:	eb 15                	jmp    801226 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801215:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801219:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80121d:	48 89 c7             	mov    %rax,%rdi
  801220:	48 89 d6             	mov    %rdx,%rsi
  801223:	fc                   	cld    
  801224:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801226:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80122a:	c9                   	leaveq 
  80122b:	c3                   	retq   

000000000080122c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80122c:	55                   	push   %rbp
  80122d:	48 89 e5             	mov    %rsp,%rbp
  801230:	48 83 ec 18          	sub    $0x18,%rsp
  801234:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801238:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80123c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801240:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801244:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801248:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124c:	48 89 ce             	mov    %rcx,%rsi
  80124f:	48 89 c7             	mov    %rax,%rdi
  801252:	48 b8 15 11 80 00 00 	movabs $0x801115,%rax
  801259:	00 00 00 
  80125c:	ff d0                	callq  *%rax
}
  80125e:	c9                   	leaveq 
  80125f:	c3                   	retq   

0000000000801260 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801260:	55                   	push   %rbp
  801261:	48 89 e5             	mov    %rsp,%rbp
  801264:	48 83 ec 28          	sub    $0x28,%rsp
  801268:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80126c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801270:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801274:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801278:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80127c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801280:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801284:	eb 36                	jmp    8012bc <memcmp+0x5c>
		if (*s1 != *s2)
  801286:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128a:	0f b6 10             	movzbl (%rax),%edx
  80128d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801291:	0f b6 00             	movzbl (%rax),%eax
  801294:	38 c2                	cmp    %al,%dl
  801296:	74 1a                	je     8012b2 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801298:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129c:	0f b6 00             	movzbl (%rax),%eax
  80129f:	0f b6 d0             	movzbl %al,%edx
  8012a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a6:	0f b6 00             	movzbl (%rax),%eax
  8012a9:	0f b6 c0             	movzbl %al,%eax
  8012ac:	29 c2                	sub    %eax,%edx
  8012ae:	89 d0                	mov    %edx,%eax
  8012b0:	eb 20                	jmp    8012d2 <memcmp+0x72>
		s1++, s2++;
  8012b2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012c8:	48 85 c0             	test   %rax,%rax
  8012cb:	75 b9                	jne    801286 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d2:	c9                   	leaveq 
  8012d3:	c3                   	retq   

00000000008012d4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012d4:	55                   	push   %rbp
  8012d5:	48 89 e5             	mov    %rsp,%rbp
  8012d8:	48 83 ec 28          	sub    $0x28,%rsp
  8012dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8012e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ef:	48 01 d0             	add    %rdx,%rax
  8012f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8012f6:	eb 19                	jmp    801311 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fc:	0f b6 00             	movzbl (%rax),%eax
  8012ff:	0f b6 d0             	movzbl %al,%edx
  801302:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801305:	0f b6 c0             	movzbl %al,%eax
  801308:	39 c2                	cmp    %eax,%edx
  80130a:	74 11                	je     80131d <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80130c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801315:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801319:	72 dd                	jb     8012f8 <memfind+0x24>
  80131b:	eb 01                	jmp    80131e <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80131d:	90                   	nop
	return (void *) s;
  80131e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801322:	c9                   	leaveq 
  801323:	c3                   	retq   

0000000000801324 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801324:	55                   	push   %rbp
  801325:	48 89 e5             	mov    %rsp,%rbp
  801328:	48 83 ec 38          	sub    $0x38,%rsp
  80132c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801330:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801334:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801337:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80133e:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801345:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801346:	eb 05                	jmp    80134d <strtol+0x29>
		s++;
  801348:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80134d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801351:	0f b6 00             	movzbl (%rax),%eax
  801354:	3c 20                	cmp    $0x20,%al
  801356:	74 f0                	je     801348 <strtol+0x24>
  801358:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135c:	0f b6 00             	movzbl (%rax),%eax
  80135f:	3c 09                	cmp    $0x9,%al
  801361:	74 e5                	je     801348 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801363:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801367:	0f b6 00             	movzbl (%rax),%eax
  80136a:	3c 2b                	cmp    $0x2b,%al
  80136c:	75 07                	jne    801375 <strtol+0x51>
		s++;
  80136e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801373:	eb 17                	jmp    80138c <strtol+0x68>
	else if (*s == '-')
  801375:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801379:	0f b6 00             	movzbl (%rax),%eax
  80137c:	3c 2d                	cmp    $0x2d,%al
  80137e:	75 0c                	jne    80138c <strtol+0x68>
		s++, neg = 1;
  801380:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801385:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80138c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801390:	74 06                	je     801398 <strtol+0x74>
  801392:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801396:	75 28                	jne    8013c0 <strtol+0x9c>
  801398:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139c:	0f b6 00             	movzbl (%rax),%eax
  80139f:	3c 30                	cmp    $0x30,%al
  8013a1:	75 1d                	jne    8013c0 <strtol+0x9c>
  8013a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a7:	48 83 c0 01          	add    $0x1,%rax
  8013ab:	0f b6 00             	movzbl (%rax),%eax
  8013ae:	3c 78                	cmp    $0x78,%al
  8013b0:	75 0e                	jne    8013c0 <strtol+0x9c>
		s += 2, base = 16;
  8013b2:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013b7:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013be:	eb 2c                	jmp    8013ec <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013c0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013c4:	75 19                	jne    8013df <strtol+0xbb>
  8013c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ca:	0f b6 00             	movzbl (%rax),%eax
  8013cd:	3c 30                	cmp    $0x30,%al
  8013cf:	75 0e                	jne    8013df <strtol+0xbb>
		s++, base = 8;
  8013d1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013d6:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013dd:	eb 0d                	jmp    8013ec <strtol+0xc8>
	else if (base == 0)
  8013df:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013e3:	75 07                	jne    8013ec <strtol+0xc8>
		base = 10;
  8013e5:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f0:	0f b6 00             	movzbl (%rax),%eax
  8013f3:	3c 2f                	cmp    $0x2f,%al
  8013f5:	7e 1d                	jle    801414 <strtol+0xf0>
  8013f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fb:	0f b6 00             	movzbl (%rax),%eax
  8013fe:	3c 39                	cmp    $0x39,%al
  801400:	7f 12                	jg     801414 <strtol+0xf0>
			dig = *s - '0';
  801402:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801406:	0f b6 00             	movzbl (%rax),%eax
  801409:	0f be c0             	movsbl %al,%eax
  80140c:	83 e8 30             	sub    $0x30,%eax
  80140f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801412:	eb 4e                	jmp    801462 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801414:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801418:	0f b6 00             	movzbl (%rax),%eax
  80141b:	3c 60                	cmp    $0x60,%al
  80141d:	7e 1d                	jle    80143c <strtol+0x118>
  80141f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801423:	0f b6 00             	movzbl (%rax),%eax
  801426:	3c 7a                	cmp    $0x7a,%al
  801428:	7f 12                	jg     80143c <strtol+0x118>
			dig = *s - 'a' + 10;
  80142a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	0f be c0             	movsbl %al,%eax
  801434:	83 e8 57             	sub    $0x57,%eax
  801437:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80143a:	eb 26                	jmp    801462 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80143c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801440:	0f b6 00             	movzbl (%rax),%eax
  801443:	3c 40                	cmp    $0x40,%al
  801445:	7e 47                	jle    80148e <strtol+0x16a>
  801447:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144b:	0f b6 00             	movzbl (%rax),%eax
  80144e:	3c 5a                	cmp    $0x5a,%al
  801450:	7f 3c                	jg     80148e <strtol+0x16a>
			dig = *s - 'A' + 10;
  801452:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801456:	0f b6 00             	movzbl (%rax),%eax
  801459:	0f be c0             	movsbl %al,%eax
  80145c:	83 e8 37             	sub    $0x37,%eax
  80145f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801462:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801465:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801468:	7d 23                	jge    80148d <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80146a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80146f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801472:	48 98                	cltq   
  801474:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801479:	48 89 c2             	mov    %rax,%rdx
  80147c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80147f:	48 98                	cltq   
  801481:	48 01 d0             	add    %rdx,%rax
  801484:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801488:	e9 5f ff ff ff       	jmpq   8013ec <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80148d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80148e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801493:	74 0b                	je     8014a0 <strtol+0x17c>
		*endptr = (char *) s;
  801495:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801499:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80149d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014a4:	74 09                	je     8014af <strtol+0x18b>
  8014a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014aa:	48 f7 d8             	neg    %rax
  8014ad:	eb 04                	jmp    8014b3 <strtol+0x18f>
  8014af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014b3:	c9                   	leaveq 
  8014b4:	c3                   	retq   

00000000008014b5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014b5:	55                   	push   %rbp
  8014b6:	48 89 e5             	mov    %rsp,%rbp
  8014b9:	48 83 ec 30          	sub    $0x30,%rsp
  8014bd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014c1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014c9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014cd:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014d1:	0f b6 00             	movzbl (%rax),%eax
  8014d4:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014d7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014db:	75 06                	jne    8014e3 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8014dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e1:	eb 6b                	jmp    80154e <strstr+0x99>

	len = strlen(str);
  8014e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014e7:	48 89 c7             	mov    %rax,%rdi
  8014ea:	48 b8 84 0d 80 00 00 	movabs $0x800d84,%rax
  8014f1:	00 00 00 
  8014f4:	ff d0                	callq  *%rax
  8014f6:	48 98                	cltq   
  8014f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8014fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801500:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801504:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801508:	0f b6 00             	movzbl (%rax),%eax
  80150b:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80150e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801512:	75 07                	jne    80151b <strstr+0x66>
				return (char *) 0;
  801514:	b8 00 00 00 00       	mov    $0x0,%eax
  801519:	eb 33                	jmp    80154e <strstr+0x99>
		} while (sc != c);
  80151b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80151f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801522:	75 d8                	jne    8014fc <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801524:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801528:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80152c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801530:	48 89 ce             	mov    %rcx,%rsi
  801533:	48 89 c7             	mov    %rax,%rdi
  801536:	48 b8 a5 0f 80 00 00 	movabs $0x800fa5,%rax
  80153d:	00 00 00 
  801540:	ff d0                	callq  *%rax
  801542:	85 c0                	test   %eax,%eax
  801544:	75 b6                	jne    8014fc <strstr+0x47>

	return (char *) (in - 1);
  801546:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154a:	48 83 e8 01          	sub    $0x1,%rax
}
  80154e:	c9                   	leaveq 
  80154f:	c3                   	retq   

0000000000801550 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801550:	55                   	push   %rbp
  801551:	48 89 e5             	mov    %rsp,%rbp
  801554:	53                   	push   %rbx
  801555:	48 83 ec 48          	sub    $0x48,%rsp
  801559:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80155c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80155f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801563:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801567:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80156b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80156f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801572:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801576:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80157a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80157e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801582:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801586:	4c 89 c3             	mov    %r8,%rbx
  801589:	cd 30                	int    $0x30
  80158b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80158f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801593:	74 3e                	je     8015d3 <syscall+0x83>
  801595:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80159a:	7e 37                	jle    8015d3 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80159c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015a0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015a3:	49 89 d0             	mov    %rdx,%r8
  8015a6:	89 c1                	mov    %eax,%ecx
  8015a8:	48 ba c8 1e 80 00 00 	movabs $0x801ec8,%rdx
  8015af:	00 00 00 
  8015b2:	be 23 00 00 00       	mov    $0x23,%esi
  8015b7:	48 bf e5 1e 80 00 00 	movabs $0x801ee5,%rdi
  8015be:	00 00 00 
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c6:	49 b9 5a 19 80 00 00 	movabs $0x80195a,%r9
  8015cd:	00 00 00 
  8015d0:	41 ff d1             	callq  *%r9

	return ret;
  8015d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015d7:	48 83 c4 48          	add    $0x48,%rsp
  8015db:	5b                   	pop    %rbx
  8015dc:	5d                   	pop    %rbp
  8015dd:	c3                   	retq   

00000000008015de <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8015de:	55                   	push   %rbp
  8015df:	48 89 e5             	mov    %rsp,%rbp
  8015e2:	48 83 ec 10          	sub    $0x10,%rsp
  8015e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8015ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015f6:	48 83 ec 08          	sub    $0x8,%rsp
  8015fa:	6a 00                	pushq  $0x0
  8015fc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801602:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801608:	48 89 d1             	mov    %rdx,%rcx
  80160b:	48 89 c2             	mov    %rax,%rdx
  80160e:	be 00 00 00 00       	mov    $0x0,%esi
  801613:	bf 00 00 00 00       	mov    $0x0,%edi
  801618:	48 b8 50 15 80 00 00 	movabs $0x801550,%rax
  80161f:	00 00 00 
  801622:	ff d0                	callq  *%rax
  801624:	48 83 c4 10          	add    $0x10,%rsp
}
  801628:	90                   	nop
  801629:	c9                   	leaveq 
  80162a:	c3                   	retq   

000000000080162b <sys_cgetc>:

int
sys_cgetc(void)
{
  80162b:	55                   	push   %rbp
  80162c:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80162f:	48 83 ec 08          	sub    $0x8,%rsp
  801633:	6a 00                	pushq  $0x0
  801635:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80163b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801641:	b9 00 00 00 00       	mov    $0x0,%ecx
  801646:	ba 00 00 00 00       	mov    $0x0,%edx
  80164b:	be 00 00 00 00       	mov    $0x0,%esi
  801650:	bf 01 00 00 00       	mov    $0x1,%edi
  801655:	48 b8 50 15 80 00 00 	movabs $0x801550,%rax
  80165c:	00 00 00 
  80165f:	ff d0                	callq  *%rax
  801661:	48 83 c4 10          	add    $0x10,%rsp
}
  801665:	c9                   	leaveq 
  801666:	c3                   	retq   

0000000000801667 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801667:	55                   	push   %rbp
  801668:	48 89 e5             	mov    %rsp,%rbp
  80166b:	48 83 ec 10          	sub    $0x10,%rsp
  80166f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801672:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801675:	48 98                	cltq   
  801677:	48 83 ec 08          	sub    $0x8,%rsp
  80167b:	6a 00                	pushq  $0x0
  80167d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801683:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801689:	b9 00 00 00 00       	mov    $0x0,%ecx
  80168e:	48 89 c2             	mov    %rax,%rdx
  801691:	be 01 00 00 00       	mov    $0x1,%esi
  801696:	bf 03 00 00 00       	mov    $0x3,%edi
  80169b:	48 b8 50 15 80 00 00 	movabs $0x801550,%rax
  8016a2:	00 00 00 
  8016a5:	ff d0                	callq  *%rax
  8016a7:	48 83 c4 10          	add    $0x10,%rsp
}
  8016ab:	c9                   	leaveq 
  8016ac:	c3                   	retq   

00000000008016ad <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016ad:	55                   	push   %rbp
  8016ae:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016b1:	48 83 ec 08          	sub    $0x8,%rsp
  8016b5:	6a 00                	pushq  $0x0
  8016b7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cd:	be 00 00 00 00       	mov    $0x0,%esi
  8016d2:	bf 02 00 00 00       	mov    $0x2,%edi
  8016d7:	48 b8 50 15 80 00 00 	movabs $0x801550,%rax
  8016de:	00 00 00 
  8016e1:	ff d0                	callq  *%rax
  8016e3:	48 83 c4 10          	add    $0x10,%rsp
}
  8016e7:	c9                   	leaveq 
  8016e8:	c3                   	retq   

00000000008016e9 <sys_yield>:

void
sys_yield(void)
{
  8016e9:	55                   	push   %rbp
  8016ea:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8016ed:	48 83 ec 08          	sub    $0x8,%rsp
  8016f1:	6a 00                	pushq  $0x0
  8016f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801704:	ba 00 00 00 00       	mov    $0x0,%edx
  801709:	be 00 00 00 00       	mov    $0x0,%esi
  80170e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801713:	48 b8 50 15 80 00 00 	movabs $0x801550,%rax
  80171a:	00 00 00 
  80171d:	ff d0                	callq  *%rax
  80171f:	48 83 c4 10          	add    $0x10,%rsp
}
  801723:	90                   	nop
  801724:	c9                   	leaveq 
  801725:	c3                   	retq   

0000000000801726 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801726:	55                   	push   %rbp
  801727:	48 89 e5             	mov    %rsp,%rbp
  80172a:	48 83 ec 10          	sub    $0x10,%rsp
  80172e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801731:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801735:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801738:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80173b:	48 63 c8             	movslq %eax,%rcx
  80173e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801742:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801745:	48 98                	cltq   
  801747:	48 83 ec 08          	sub    $0x8,%rsp
  80174b:	6a 00                	pushq  $0x0
  80174d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801753:	49 89 c8             	mov    %rcx,%r8
  801756:	48 89 d1             	mov    %rdx,%rcx
  801759:	48 89 c2             	mov    %rax,%rdx
  80175c:	be 01 00 00 00       	mov    $0x1,%esi
  801761:	bf 04 00 00 00       	mov    $0x4,%edi
  801766:	48 b8 50 15 80 00 00 	movabs $0x801550,%rax
  80176d:	00 00 00 
  801770:	ff d0                	callq  *%rax
  801772:	48 83 c4 10          	add    $0x10,%rsp
}
  801776:	c9                   	leaveq 
  801777:	c3                   	retq   

0000000000801778 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801778:	55                   	push   %rbp
  801779:	48 89 e5             	mov    %rsp,%rbp
  80177c:	48 83 ec 20          	sub    $0x20,%rsp
  801780:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801783:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801787:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80178a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80178e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801792:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801795:	48 63 c8             	movslq %eax,%rcx
  801798:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80179c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80179f:	48 63 f0             	movslq %eax,%rsi
  8017a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017a9:	48 98                	cltq   
  8017ab:	48 83 ec 08          	sub    $0x8,%rsp
  8017af:	51                   	push   %rcx
  8017b0:	49 89 f9             	mov    %rdi,%r9
  8017b3:	49 89 f0             	mov    %rsi,%r8
  8017b6:	48 89 d1             	mov    %rdx,%rcx
  8017b9:	48 89 c2             	mov    %rax,%rdx
  8017bc:	be 01 00 00 00       	mov    $0x1,%esi
  8017c1:	bf 05 00 00 00       	mov    $0x5,%edi
  8017c6:	48 b8 50 15 80 00 00 	movabs $0x801550,%rax
  8017cd:	00 00 00 
  8017d0:	ff d0                	callq  *%rax
  8017d2:	48 83 c4 10          	add    $0x10,%rsp
}
  8017d6:	c9                   	leaveq 
  8017d7:	c3                   	retq   

00000000008017d8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8017d8:	55                   	push   %rbp
  8017d9:	48 89 e5             	mov    %rsp,%rbp
  8017dc:	48 83 ec 10          	sub    $0x10,%rsp
  8017e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8017e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017ee:	48 98                	cltq   
  8017f0:	48 83 ec 08          	sub    $0x8,%rsp
  8017f4:	6a 00                	pushq  $0x0
  8017f6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801802:	48 89 d1             	mov    %rdx,%rcx
  801805:	48 89 c2             	mov    %rax,%rdx
  801808:	be 01 00 00 00       	mov    $0x1,%esi
  80180d:	bf 06 00 00 00       	mov    $0x6,%edi
  801812:	48 b8 50 15 80 00 00 	movabs $0x801550,%rax
  801819:	00 00 00 
  80181c:	ff d0                	callq  *%rax
  80181e:	48 83 c4 10          	add    $0x10,%rsp
}
  801822:	c9                   	leaveq 
  801823:	c3                   	retq   

0000000000801824 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801824:	55                   	push   %rbp
  801825:	48 89 e5             	mov    %rsp,%rbp
  801828:	48 83 ec 10          	sub    $0x10,%rsp
  80182c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80182f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801832:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801835:	48 63 d0             	movslq %eax,%rdx
  801838:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80183b:	48 98                	cltq   
  80183d:	48 83 ec 08          	sub    $0x8,%rsp
  801841:	6a 00                	pushq  $0x0
  801843:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801849:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80184f:	48 89 d1             	mov    %rdx,%rcx
  801852:	48 89 c2             	mov    %rax,%rdx
  801855:	be 01 00 00 00       	mov    $0x1,%esi
  80185a:	bf 08 00 00 00       	mov    $0x8,%edi
  80185f:	48 b8 50 15 80 00 00 	movabs $0x801550,%rax
  801866:	00 00 00 
  801869:	ff d0                	callq  *%rax
  80186b:	48 83 c4 10          	add    $0x10,%rsp
}
  80186f:	c9                   	leaveq 
  801870:	c3                   	retq   

0000000000801871 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801871:	55                   	push   %rbp
  801872:	48 89 e5             	mov    %rsp,%rbp
  801875:	48 83 ec 10          	sub    $0x10,%rsp
  801879:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80187c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801880:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801884:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801887:	48 98                	cltq   
  801889:	48 83 ec 08          	sub    $0x8,%rsp
  80188d:	6a 00                	pushq  $0x0
  80188f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801895:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80189b:	48 89 d1             	mov    %rdx,%rcx
  80189e:	48 89 c2             	mov    %rax,%rdx
  8018a1:	be 01 00 00 00       	mov    $0x1,%esi
  8018a6:	bf 09 00 00 00       	mov    $0x9,%edi
  8018ab:	48 b8 50 15 80 00 00 	movabs $0x801550,%rax
  8018b2:	00 00 00 
  8018b5:	ff d0                	callq  *%rax
  8018b7:	48 83 c4 10          	add    $0x10,%rsp
}
  8018bb:	c9                   	leaveq 
  8018bc:	c3                   	retq   

00000000008018bd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8018bd:	55                   	push   %rbp
  8018be:	48 89 e5             	mov    %rsp,%rbp
  8018c1:	48 83 ec 20          	sub    $0x20,%rsp
  8018c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018cc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018d0:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8018d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018d6:	48 63 f0             	movslq %eax,%rsi
  8018d9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8018dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e0:	48 98                	cltq   
  8018e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e6:	48 83 ec 08          	sub    $0x8,%rsp
  8018ea:	6a 00                	pushq  $0x0
  8018ec:	49 89 f1             	mov    %rsi,%r9
  8018ef:	49 89 c8             	mov    %rcx,%r8
  8018f2:	48 89 d1             	mov    %rdx,%rcx
  8018f5:	48 89 c2             	mov    %rax,%rdx
  8018f8:	be 00 00 00 00       	mov    $0x0,%esi
  8018fd:	bf 0b 00 00 00       	mov    $0xb,%edi
  801902:	48 b8 50 15 80 00 00 	movabs $0x801550,%rax
  801909:	00 00 00 
  80190c:	ff d0                	callq  *%rax
  80190e:	48 83 c4 10          	add    $0x10,%rsp
}
  801912:	c9                   	leaveq 
  801913:	c3                   	retq   

0000000000801914 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801914:	55                   	push   %rbp
  801915:	48 89 e5             	mov    %rsp,%rbp
  801918:	48 83 ec 10          	sub    $0x10,%rsp
  80191c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801920:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801924:	48 83 ec 08          	sub    $0x8,%rsp
  801928:	6a 00                	pushq  $0x0
  80192a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801930:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801936:	b9 00 00 00 00       	mov    $0x0,%ecx
  80193b:	48 89 c2             	mov    %rax,%rdx
  80193e:	be 01 00 00 00       	mov    $0x1,%esi
  801943:	bf 0c 00 00 00       	mov    $0xc,%edi
  801948:	48 b8 50 15 80 00 00 	movabs $0x801550,%rax
  80194f:	00 00 00 
  801952:	ff d0                	callq  *%rax
  801954:	48 83 c4 10          	add    $0x10,%rsp
}
  801958:	c9                   	leaveq 
  801959:	c3                   	retq   

000000000080195a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80195a:	55                   	push   %rbp
  80195b:	48 89 e5             	mov    %rsp,%rbp
  80195e:	53                   	push   %rbx
  80195f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801966:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80196d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801973:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80197a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801981:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801988:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80198f:	84 c0                	test   %al,%al
  801991:	74 23                	je     8019b6 <_panic+0x5c>
  801993:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80199a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80199e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8019a2:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8019a6:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8019aa:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8019ae:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8019b2:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8019b6:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8019bd:	00 00 00 
  8019c0:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8019c7:	00 00 00 
  8019ca:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019ce:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8019d5:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8019dc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8019e3:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8019ea:	00 00 00 
  8019ed:	48 8b 18             	mov    (%rax),%rbx
  8019f0:	48 b8 ad 16 80 00 00 	movabs $0x8016ad,%rax
  8019f7:	00 00 00 
  8019fa:	ff d0                	callq  *%rax
  8019fc:	89 c6                	mov    %eax,%esi
  8019fe:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  801a04:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  801a0b:	41 89 d0             	mov    %edx,%r8d
  801a0e:	48 89 c1             	mov    %rax,%rcx
  801a11:	48 89 da             	mov    %rbx,%rdx
  801a14:	48 bf f8 1e 80 00 00 	movabs $0x801ef8,%rdi
  801a1b:	00 00 00 
  801a1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a23:	49 b9 60 02 80 00 00 	movabs $0x800260,%r9
  801a2a:	00 00 00 
  801a2d:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a30:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801a37:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a3e:	48 89 d6             	mov    %rdx,%rsi
  801a41:	48 89 c7             	mov    %rax,%rdi
  801a44:	48 b8 b4 01 80 00 00 	movabs $0x8001b4,%rax
  801a4b:	00 00 00 
  801a4e:	ff d0                	callq  *%rax
	cprintf("\n");
  801a50:	48 bf 1b 1f 80 00 00 	movabs $0x801f1b,%rdi
  801a57:	00 00 00 
  801a5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5f:	48 ba 60 02 80 00 00 	movabs $0x800260,%rdx
  801a66:	00 00 00 
  801a69:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a6b:	cc                   	int3   
  801a6c:	eb fd                	jmp    801a6b <_panic+0x111>
