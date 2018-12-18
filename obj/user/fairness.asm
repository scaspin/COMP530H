
obj/user/fairness:     file format elf64-x86-64


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
  80003c:	e8 dd 00 00 00       	callq  80011e <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t who, id;

	id = sys_getenvid();
  800052:	48 b8 35 17 80 00 00 	movabs $0x801735,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if (thisenv == &envs[1]) {
  800061:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800068:	00 00 00 
  80006b:	48 8b 10             	mov    (%rax),%rdx
  80006e:	48 b8 20 01 80 00 80 	movabs $0x8000800120,%rax
  800075:	00 00 00 
  800078:	48 39 c2             	cmp    %rax,%rdx
  80007b:	75 42                	jne    8000bf <umain+0x7c>
		while (1) {
			ipc_recv(&who, 0, 0);
  80007d:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
  800081:	ba 00 00 00 00       	mov    $0x0,%edx
  800086:	be 00 00 00 00       	mov    $0x0,%esi
  80008b:	48 89 c7             	mov    %rax,%rdi
  80008e:	48 b8 e2 19 80 00 00 	movabs $0x8019e2,%rax
  800095:	00 00 00 
  800098:	ff d0                	callq  *%rax
			cprintf("%x recv from %x\n", id, who);
  80009a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80009d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a0:	89 c6                	mov    %eax,%esi
  8000a2:	48 bf e0 1c 80 00 00 	movabs $0x801ce0,%rdi
  8000a9:	00 00 00 
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	48 b9 e8 02 80 00 00 	movabs $0x8002e8,%rcx
  8000b8:	00 00 00 
  8000bb:	ff d1                	callq  *%rcx
		}
  8000bd:	eb be                	jmp    80007d <umain+0x3a>
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  8000bf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000c6:	00 00 00 
  8000c9:	8b 90 e8 01 00 00    	mov    0x1e8(%rax),%edx
  8000cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d2:	89 c6                	mov    %eax,%esi
  8000d4:	48 bf f1 1c 80 00 00 	movabs $0x801cf1,%rdi
  8000db:	00 00 00 
  8000de:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e3:	48 b9 e8 02 80 00 00 	movabs $0x8002e8,%rcx
  8000ea:	00 00 00 
  8000ed:	ff d1                	callq  *%rcx
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  8000ef:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000f6:	00 00 00 
  8000f9:	8b 80 e8 01 00 00    	mov    0x1e8(%rax),%eax
  8000ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800104:	ba 00 00 00 00       	mov    $0x0,%edx
  800109:	be 00 00 00 00       	mov    $0x0,%esi
  80010e:	89 c7                	mov    %eax,%edi
  800110:	48 b8 9d 1a 80 00 00 	movabs $0x801a9d,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
  80011c:	eb d1                	jmp    8000ef <umain+0xac>

000000000080011e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80011e:	55                   	push   %rbp
  80011f:	48 89 e5             	mov    %rsp,%rbp
  800122:	48 83 ec 10          	sub    $0x10,%rsp
  800126:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800129:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  80012d:	48 b8 35 17 80 00 00 	movabs $0x801735,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
  800139:	25 ff 03 00 00       	and    $0x3ff,%eax
  80013e:	48 63 d0             	movslq %eax,%rdx
  800141:	48 89 d0             	mov    %rdx,%rax
  800144:	48 c1 e0 03          	shl    $0x3,%rax
  800148:	48 01 d0             	add    %rdx,%rax
  80014b:	48 c1 e0 05          	shl    $0x5,%rax
  80014f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800156:	00 00 00 
  800159:	48 01 c2             	add    %rax,%rdx
  80015c:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800163:	00 00 00 
  800166:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800169:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80016d:	7e 14                	jle    800183 <libmain+0x65>
		binaryname = argv[0];
  80016f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800173:	48 8b 10             	mov    (%rax),%rdx
  800176:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80017d:	00 00 00 
  800180:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800183:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800187:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80018a:	48 89 d6             	mov    %rdx,%rsi
  80018d:	89 c7                	mov    %eax,%edi
  80018f:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800196:	00 00 00 
  800199:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80019b:	48 b8 aa 01 80 00 00 	movabs $0x8001aa,%rax
  8001a2:	00 00 00 
  8001a5:	ff d0                	callq  *%rax
}
  8001a7:	90                   	nop
  8001a8:	c9                   	leaveq 
  8001a9:	c3                   	retq   

00000000008001aa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001aa:	55                   	push   %rbp
  8001ab:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8001ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8001b3:	48 b8 ef 16 80 00 00 	movabs $0x8016ef,%rax
  8001ba:	00 00 00 
  8001bd:	ff d0                	callq  *%rax
}
  8001bf:	90                   	nop
  8001c0:	5d                   	pop    %rbp
  8001c1:	c3                   	retq   

00000000008001c2 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001c2:	55                   	push   %rbp
  8001c3:	48 89 e5             	mov    %rsp,%rbp
  8001c6:	48 83 ec 10          	sub    $0x10,%rsp
  8001ca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8001d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001d5:	8b 00                	mov    (%rax),%eax
  8001d7:	8d 48 01             	lea    0x1(%rax),%ecx
  8001da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001de:	89 0a                	mov    %ecx,(%rdx)
  8001e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001e3:	89 d1                	mov    %edx,%ecx
  8001e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001e9:	48 98                	cltq   
  8001eb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001f3:	8b 00                	mov    (%rax),%eax
  8001f5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001fa:	75 2c                	jne    800228 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8001fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800200:	8b 00                	mov    (%rax),%eax
  800202:	48 98                	cltq   
  800204:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800208:	48 83 c2 08          	add    $0x8,%rdx
  80020c:	48 89 c6             	mov    %rax,%rsi
  80020f:	48 89 d7             	mov    %rdx,%rdi
  800212:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  800219:	00 00 00 
  80021c:	ff d0                	callq  *%rax
        b->idx = 0;
  80021e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800222:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022c:	8b 40 04             	mov    0x4(%rax),%eax
  80022f:	8d 50 01             	lea    0x1(%rax),%edx
  800232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800236:	89 50 04             	mov    %edx,0x4(%rax)
}
  800239:	90                   	nop
  80023a:	c9                   	leaveq 
  80023b:	c3                   	retq   

000000000080023c <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80023c:	55                   	push   %rbp
  80023d:	48 89 e5             	mov    %rsp,%rbp
  800240:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800247:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80024e:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800255:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80025c:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800263:	48 8b 0a             	mov    (%rdx),%rcx
  800266:	48 89 08             	mov    %rcx,(%rax)
  800269:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80026d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800271:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800275:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800279:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800280:	00 00 00 
    b.cnt = 0;
  800283:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80028a:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80028d:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800294:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80029b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002a2:	48 89 c6             	mov    %rax,%rsi
  8002a5:	48 bf c2 01 80 00 00 	movabs $0x8001c2,%rdi
  8002ac:	00 00 00 
  8002af:	48 b8 86 06 80 00 00 	movabs $0x800686,%rax
  8002b6:	00 00 00 
  8002b9:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002bb:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002c1:	48 98                	cltq   
  8002c3:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002ca:	48 83 c2 08          	add    $0x8,%rdx
  8002ce:	48 89 c6             	mov    %rax,%rsi
  8002d1:	48 89 d7             	mov    %rdx,%rdi
  8002d4:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  8002db:	00 00 00 
  8002de:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002e0:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002e6:	c9                   	leaveq 
  8002e7:	c3                   	retq   

00000000008002e8 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002e8:	55                   	push   %rbp
  8002e9:	48 89 e5             	mov    %rsp,%rbp
  8002ec:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002f3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8002fa:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800301:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800308:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80030f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800316:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80031d:	84 c0                	test   %al,%al
  80031f:	74 20                	je     800341 <cprintf+0x59>
  800321:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800325:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800329:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80032d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800331:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800335:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800339:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80033d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800341:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800348:	00 00 00 
  80034b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800352:	00 00 00 
  800355:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800359:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800360:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800367:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80036e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800375:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80037c:	48 8b 0a             	mov    (%rdx),%rcx
  80037f:	48 89 08             	mov    %rcx,(%rax)
  800382:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800386:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80038a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80038e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800392:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800399:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003a0:	48 89 d6             	mov    %rdx,%rsi
  8003a3:	48 89 c7             	mov    %rax,%rdi
  8003a6:	48 b8 3c 02 80 00 00 	movabs $0x80023c,%rax
  8003ad:	00 00 00 
  8003b0:	ff d0                	callq  *%rax
  8003b2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003b8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003be:	c9                   	leaveq 
  8003bf:	c3                   	retq   

00000000008003c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003c0:	55                   	push   %rbp
  8003c1:	48 89 e5             	mov    %rsp,%rbp
  8003c4:	48 83 ec 30          	sub    $0x30,%rsp
  8003c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8003d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8003d4:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8003d7:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8003db:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003df:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8003e2:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8003e6:	77 54                	ja     80043c <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003e8:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003eb:	8d 78 ff             	lea    -0x1(%rax),%edi
  8003ee:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8003f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fa:	48 f7 f6             	div    %rsi
  8003fd:	49 89 c2             	mov    %rax,%r10
  800400:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800403:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800406:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80040a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80040e:	41 89 c9             	mov    %ecx,%r9d
  800411:	41 89 f8             	mov    %edi,%r8d
  800414:	89 d1                	mov    %edx,%ecx
  800416:	4c 89 d2             	mov    %r10,%rdx
  800419:	48 89 c7             	mov    %rax,%rdi
  80041c:	48 b8 c0 03 80 00 00 	movabs $0x8003c0,%rax
  800423:	00 00 00 
  800426:	ff d0                	callq  *%rax
  800428:	eb 1c                	jmp    800446 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80042a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80042e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800431:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800435:	48 89 ce             	mov    %rcx,%rsi
  800438:	89 d7                	mov    %edx,%edi
  80043a:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80043c:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800440:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800444:	7f e4                	jg     80042a <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800446:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80044d:	ba 00 00 00 00       	mov    $0x0,%edx
  800452:	48 f7 f1             	div    %rcx
  800455:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  80045c:	00 00 00 
  80045f:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800463:	0f be d0             	movsbl %al,%edx
  800466:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80046a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80046e:	48 89 ce             	mov    %rcx,%rsi
  800471:	89 d7                	mov    %edx,%edi
  800473:	ff d0                	callq  *%rax
}
  800475:	90                   	nop
  800476:	c9                   	leaveq 
  800477:	c3                   	retq   

0000000000800478 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800478:	55                   	push   %rbp
  800479:	48 89 e5             	mov    %rsp,%rbp
  80047c:	48 83 ec 20          	sub    $0x20,%rsp
  800480:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800484:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800487:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80048b:	7e 4f                	jle    8004dc <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80048d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800491:	8b 00                	mov    (%rax),%eax
  800493:	83 f8 30             	cmp    $0x30,%eax
  800496:	73 24                	jae    8004bc <getuint+0x44>
  800498:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a4:	8b 00                	mov    (%rax),%eax
  8004a6:	89 c0                	mov    %eax,%eax
  8004a8:	48 01 d0             	add    %rdx,%rax
  8004ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004af:	8b 12                	mov    (%rdx),%edx
  8004b1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b8:	89 0a                	mov    %ecx,(%rdx)
  8004ba:	eb 14                	jmp    8004d0 <getuint+0x58>
  8004bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004c4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8004c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004cc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004d0:	48 8b 00             	mov    (%rax),%rax
  8004d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004d7:	e9 9d 00 00 00       	jmpq   800579 <getuint+0x101>
	else if (lflag)
  8004dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004e0:	74 4c                	je     80052e <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8004e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e6:	8b 00                	mov    (%rax),%eax
  8004e8:	83 f8 30             	cmp    $0x30,%eax
  8004eb:	73 24                	jae    800511 <getuint+0x99>
  8004ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f9:	8b 00                	mov    (%rax),%eax
  8004fb:	89 c0                	mov    %eax,%eax
  8004fd:	48 01 d0             	add    %rdx,%rax
  800500:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800504:	8b 12                	mov    (%rdx),%edx
  800506:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800509:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050d:	89 0a                	mov    %ecx,(%rdx)
  80050f:	eb 14                	jmp    800525 <getuint+0xad>
  800511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800515:	48 8b 40 08          	mov    0x8(%rax),%rax
  800519:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80051d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800521:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800525:	48 8b 00             	mov    (%rax),%rax
  800528:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80052c:	eb 4b                	jmp    800579 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  80052e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800532:	8b 00                	mov    (%rax),%eax
  800534:	83 f8 30             	cmp    $0x30,%eax
  800537:	73 24                	jae    80055d <getuint+0xe5>
  800539:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800541:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800545:	8b 00                	mov    (%rax),%eax
  800547:	89 c0                	mov    %eax,%eax
  800549:	48 01 d0             	add    %rdx,%rax
  80054c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800550:	8b 12                	mov    (%rdx),%edx
  800552:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800555:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800559:	89 0a                	mov    %ecx,(%rdx)
  80055b:	eb 14                	jmp    800571 <getuint+0xf9>
  80055d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800561:	48 8b 40 08          	mov    0x8(%rax),%rax
  800565:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800569:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800571:	8b 00                	mov    (%rax),%eax
  800573:	89 c0                	mov    %eax,%eax
  800575:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800579:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80057d:	c9                   	leaveq 
  80057e:	c3                   	retq   

000000000080057f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80057f:	55                   	push   %rbp
  800580:	48 89 e5             	mov    %rsp,%rbp
  800583:	48 83 ec 20          	sub    $0x20,%rsp
  800587:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80058b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80058e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800592:	7e 4f                	jle    8005e3 <getint+0x64>
		x=va_arg(*ap, long long);
  800594:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800598:	8b 00                	mov    (%rax),%eax
  80059a:	83 f8 30             	cmp    $0x30,%eax
  80059d:	73 24                	jae    8005c3 <getint+0x44>
  80059f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ab:	8b 00                	mov    (%rax),%eax
  8005ad:	89 c0                	mov    %eax,%eax
  8005af:	48 01 d0             	add    %rdx,%rax
  8005b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b6:	8b 12                	mov    (%rdx),%edx
  8005b8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bf:	89 0a                	mov    %ecx,(%rdx)
  8005c1:	eb 14                	jmp    8005d7 <getint+0x58>
  8005c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005cb:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d7:	48 8b 00             	mov    (%rax),%rax
  8005da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005de:	e9 9d 00 00 00       	jmpq   800680 <getint+0x101>
	else if (lflag)
  8005e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005e7:	74 4c                	je     800635 <getint+0xb6>
		x=va_arg(*ap, long);
  8005e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ed:	8b 00                	mov    (%rax),%eax
  8005ef:	83 f8 30             	cmp    $0x30,%eax
  8005f2:	73 24                	jae    800618 <getint+0x99>
  8005f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800600:	8b 00                	mov    (%rax),%eax
  800602:	89 c0                	mov    %eax,%eax
  800604:	48 01 d0             	add    %rdx,%rax
  800607:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060b:	8b 12                	mov    (%rdx),%edx
  80060d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800610:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800614:	89 0a                	mov    %ecx,(%rdx)
  800616:	eb 14                	jmp    80062c <getint+0xad>
  800618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800620:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800624:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800628:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80062c:	48 8b 00             	mov    (%rax),%rax
  80062f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800633:	eb 4b                	jmp    800680 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800639:	8b 00                	mov    (%rax),%eax
  80063b:	83 f8 30             	cmp    $0x30,%eax
  80063e:	73 24                	jae    800664 <getint+0xe5>
  800640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800644:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064c:	8b 00                	mov    (%rax),%eax
  80064e:	89 c0                	mov    %eax,%eax
  800650:	48 01 d0             	add    %rdx,%rax
  800653:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800657:	8b 12                	mov    (%rdx),%edx
  800659:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80065c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800660:	89 0a                	mov    %ecx,(%rdx)
  800662:	eb 14                	jmp    800678 <getint+0xf9>
  800664:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800668:	48 8b 40 08          	mov    0x8(%rax),%rax
  80066c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800670:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800674:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800678:	8b 00                	mov    (%rax),%eax
  80067a:	48 98                	cltq   
  80067c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800680:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800684:	c9                   	leaveq 
  800685:	c3                   	retq   

0000000000800686 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800686:	55                   	push   %rbp
  800687:	48 89 e5             	mov    %rsp,%rbp
  80068a:	41 54                	push   %r12
  80068c:	53                   	push   %rbx
  80068d:	48 83 ec 60          	sub    $0x60,%rsp
  800691:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800695:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800699:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80069d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006a1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006a5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006a9:	48 8b 0a             	mov    (%rdx),%rcx
  8006ac:	48 89 08             	mov    %rcx,(%rax)
  8006af:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006b3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006b7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006bb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006bf:	eb 17                	jmp    8006d8 <vprintfmt+0x52>
			if (ch == '\0')
  8006c1:	85 db                	test   %ebx,%ebx
  8006c3:	0f 84 b9 04 00 00    	je     800b82 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  8006c9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006cd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006d1:	48 89 d6             	mov    %rdx,%rsi
  8006d4:	89 df                	mov    %ebx,%edi
  8006d6:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006d8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006dc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006e0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006e4:	0f b6 00             	movzbl (%rax),%eax
  8006e7:	0f b6 d8             	movzbl %al,%ebx
  8006ea:	83 fb 25             	cmp    $0x25,%ebx
  8006ed:	75 d2                	jne    8006c1 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006ef:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006f3:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8006fa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800701:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800708:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80070f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800713:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800717:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80071b:	0f b6 00             	movzbl (%rax),%eax
  80071e:	0f b6 d8             	movzbl %al,%ebx
  800721:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800724:	83 f8 55             	cmp    $0x55,%eax
  800727:	0f 87 22 04 00 00    	ja     800b4f <vprintfmt+0x4c9>
  80072d:	89 c0                	mov    %eax,%eax
  80072f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800736:	00 
  800737:	48 b8 98 1e 80 00 00 	movabs $0x801e98,%rax
  80073e:	00 00 00 
  800741:	48 01 d0             	add    %rdx,%rax
  800744:	48 8b 00             	mov    (%rax),%rax
  800747:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800749:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80074d:	eb c0                	jmp    80070f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80074f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800753:	eb ba                	jmp    80070f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800755:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80075c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80075f:	89 d0                	mov    %edx,%eax
  800761:	c1 e0 02             	shl    $0x2,%eax
  800764:	01 d0                	add    %edx,%eax
  800766:	01 c0                	add    %eax,%eax
  800768:	01 d8                	add    %ebx,%eax
  80076a:	83 e8 30             	sub    $0x30,%eax
  80076d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800770:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800774:	0f b6 00             	movzbl (%rax),%eax
  800777:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80077a:	83 fb 2f             	cmp    $0x2f,%ebx
  80077d:	7e 60                	jle    8007df <vprintfmt+0x159>
  80077f:	83 fb 39             	cmp    $0x39,%ebx
  800782:	7f 5b                	jg     8007df <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800784:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800789:	eb d1                	jmp    80075c <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80078b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80078e:	83 f8 30             	cmp    $0x30,%eax
  800791:	73 17                	jae    8007aa <vprintfmt+0x124>
  800793:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800797:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80079a:	89 d2                	mov    %edx,%edx
  80079c:	48 01 d0             	add    %rdx,%rax
  80079f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007a2:	83 c2 08             	add    $0x8,%edx
  8007a5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007a8:	eb 0c                	jmp    8007b6 <vprintfmt+0x130>
  8007aa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8007ae:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8007b2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007b6:	8b 00                	mov    (%rax),%eax
  8007b8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007bb:	eb 23                	jmp    8007e0 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  8007bd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007c1:	0f 89 48 ff ff ff    	jns    80070f <vprintfmt+0x89>
				width = 0;
  8007c7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007ce:	e9 3c ff ff ff       	jmpq   80070f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007d3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007da:	e9 30 ff ff ff       	jmpq   80070f <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007df:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007e4:	0f 89 25 ff ff ff    	jns    80070f <vprintfmt+0x89>
				width = precision, precision = -1;
  8007ea:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007ed:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007f0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007f7:	e9 13 ff ff ff       	jmpq   80070f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007fc:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800800:	e9 0a ff ff ff       	jmpq   80070f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800805:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800808:	83 f8 30             	cmp    $0x30,%eax
  80080b:	73 17                	jae    800824 <vprintfmt+0x19e>
  80080d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800811:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800814:	89 d2                	mov    %edx,%edx
  800816:	48 01 d0             	add    %rdx,%rax
  800819:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80081c:	83 c2 08             	add    $0x8,%edx
  80081f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800822:	eb 0c                	jmp    800830 <vprintfmt+0x1aa>
  800824:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800828:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80082c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800830:	8b 10                	mov    (%rax),%edx
  800832:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800836:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80083a:	48 89 ce             	mov    %rcx,%rsi
  80083d:	89 d7                	mov    %edx,%edi
  80083f:	ff d0                	callq  *%rax
			break;
  800841:	e9 37 03 00 00       	jmpq   800b7d <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800846:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800849:	83 f8 30             	cmp    $0x30,%eax
  80084c:	73 17                	jae    800865 <vprintfmt+0x1df>
  80084e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800852:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800855:	89 d2                	mov    %edx,%edx
  800857:	48 01 d0             	add    %rdx,%rax
  80085a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80085d:	83 c2 08             	add    $0x8,%edx
  800860:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800863:	eb 0c                	jmp    800871 <vprintfmt+0x1eb>
  800865:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800869:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80086d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800871:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800873:	85 db                	test   %ebx,%ebx
  800875:	79 02                	jns    800879 <vprintfmt+0x1f3>
				err = -err;
  800877:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800879:	83 fb 15             	cmp    $0x15,%ebx
  80087c:	7f 16                	jg     800894 <vprintfmt+0x20e>
  80087e:	48 b8 c0 1d 80 00 00 	movabs $0x801dc0,%rax
  800885:	00 00 00 
  800888:	48 63 d3             	movslq %ebx,%rdx
  80088b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80088f:	4d 85 e4             	test   %r12,%r12
  800892:	75 2e                	jne    8008c2 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800894:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800898:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80089c:	89 d9                	mov    %ebx,%ecx
  80089e:	48 ba 81 1e 80 00 00 	movabs $0x801e81,%rdx
  8008a5:	00 00 00 
  8008a8:	48 89 c7             	mov    %rax,%rdi
  8008ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b0:	49 b8 8c 0b 80 00 00 	movabs $0x800b8c,%r8
  8008b7:	00 00 00 
  8008ba:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008bd:	e9 bb 02 00 00       	jmpq   800b7d <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008c2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008c6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ca:	4c 89 e1             	mov    %r12,%rcx
  8008cd:	48 ba 8a 1e 80 00 00 	movabs $0x801e8a,%rdx
  8008d4:	00 00 00 
  8008d7:	48 89 c7             	mov    %rax,%rdi
  8008da:	b8 00 00 00 00       	mov    $0x0,%eax
  8008df:	49 b8 8c 0b 80 00 00 	movabs $0x800b8c,%r8
  8008e6:	00 00 00 
  8008e9:	41 ff d0             	callq  *%r8
			break;
  8008ec:	e9 8c 02 00 00       	jmpq   800b7d <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008f1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f4:	83 f8 30             	cmp    $0x30,%eax
  8008f7:	73 17                	jae    800910 <vprintfmt+0x28a>
  8008f9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8008fd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800900:	89 d2                	mov    %edx,%edx
  800902:	48 01 d0             	add    %rdx,%rax
  800905:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800908:	83 c2 08             	add    $0x8,%edx
  80090b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80090e:	eb 0c                	jmp    80091c <vprintfmt+0x296>
  800910:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800914:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800918:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80091c:	4c 8b 20             	mov    (%rax),%r12
  80091f:	4d 85 e4             	test   %r12,%r12
  800922:	75 0a                	jne    80092e <vprintfmt+0x2a8>
				p = "(null)";
  800924:	49 bc 8d 1e 80 00 00 	movabs $0x801e8d,%r12
  80092b:	00 00 00 
			if (width > 0 && padc != '-')
  80092e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800932:	7e 78                	jle    8009ac <vprintfmt+0x326>
  800934:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800938:	74 72                	je     8009ac <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  80093a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80093d:	48 98                	cltq   
  80093f:	48 89 c6             	mov    %rax,%rsi
  800942:	4c 89 e7             	mov    %r12,%rdi
  800945:	48 b8 3a 0e 80 00 00 	movabs $0x800e3a,%rax
  80094c:	00 00 00 
  80094f:	ff d0                	callq  *%rax
  800951:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800954:	eb 17                	jmp    80096d <vprintfmt+0x2e7>
					putch(padc, putdat);
  800956:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80095a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80095e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800962:	48 89 ce             	mov    %rcx,%rsi
  800965:	89 d7                	mov    %edx,%edi
  800967:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800969:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80096d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800971:	7f e3                	jg     800956 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800973:	eb 37                	jmp    8009ac <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800975:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800979:	74 1e                	je     800999 <vprintfmt+0x313>
  80097b:	83 fb 1f             	cmp    $0x1f,%ebx
  80097e:	7e 05                	jle    800985 <vprintfmt+0x2ff>
  800980:	83 fb 7e             	cmp    $0x7e,%ebx
  800983:	7e 14                	jle    800999 <vprintfmt+0x313>
					putch('?', putdat);
  800985:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800989:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098d:	48 89 d6             	mov    %rdx,%rsi
  800990:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800995:	ff d0                	callq  *%rax
  800997:	eb 0f                	jmp    8009a8 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800999:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80099d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a1:	48 89 d6             	mov    %rdx,%rsi
  8009a4:	89 df                	mov    %ebx,%edi
  8009a6:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009ac:	4c 89 e0             	mov    %r12,%rax
  8009af:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009b3:	0f b6 00             	movzbl (%rax),%eax
  8009b6:	0f be d8             	movsbl %al,%ebx
  8009b9:	85 db                	test   %ebx,%ebx
  8009bb:	74 28                	je     8009e5 <vprintfmt+0x35f>
  8009bd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009c1:	78 b2                	js     800975 <vprintfmt+0x2ef>
  8009c3:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009c7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009cb:	79 a8                	jns    800975 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009cd:	eb 16                	jmp    8009e5 <vprintfmt+0x35f>
				putch(' ', putdat);
  8009cf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009d3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d7:	48 89 d6             	mov    %rdx,%rsi
  8009da:	bf 20 00 00 00       	mov    $0x20,%edi
  8009df:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009e9:	7f e4                	jg     8009cf <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  8009eb:	e9 8d 01 00 00       	jmpq   800b7d <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8009f0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009f4:	be 03 00 00 00       	mov    $0x3,%esi
  8009f9:	48 89 c7             	mov    %rax,%rdi
  8009fc:	48 b8 7f 05 80 00 00 	movabs $0x80057f,%rax
  800a03:	00 00 00 
  800a06:	ff d0                	callq  *%rax
  800a08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a10:	48 85 c0             	test   %rax,%rax
  800a13:	79 1d                	jns    800a32 <vprintfmt+0x3ac>
				putch('-', putdat);
  800a15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a1d:	48 89 d6             	mov    %rdx,%rsi
  800a20:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a25:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2b:	48 f7 d8             	neg    %rax
  800a2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a32:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a39:	e9 d2 00 00 00       	jmpq   800b10 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a3e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a42:	be 03 00 00 00       	mov    $0x3,%esi
  800a47:	48 89 c7             	mov    %rax,%rdi
  800a4a:	48 b8 78 04 80 00 00 	movabs $0x800478,%rax
  800a51:	00 00 00 
  800a54:	ff d0                	callq  *%rax
  800a56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a5a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a61:	e9 aa 00 00 00       	jmpq   800b10 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800a66:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a6a:	be 03 00 00 00       	mov    $0x3,%esi
  800a6f:	48 89 c7             	mov    %rax,%rdi
  800a72:	48 b8 78 04 80 00 00 	movabs $0x800478,%rax
  800a79:	00 00 00 
  800a7c:	ff d0                	callq  *%rax
  800a7e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a82:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a89:	e9 82 00 00 00       	jmpq   800b10 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800a8e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a96:	48 89 d6             	mov    %rdx,%rsi
  800a99:	bf 30 00 00 00       	mov    $0x30,%edi
  800a9e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800aa0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa8:	48 89 d6             	mov    %rdx,%rsi
  800aab:	bf 78 00 00 00       	mov    $0x78,%edi
  800ab0:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ab2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab5:	83 f8 30             	cmp    $0x30,%eax
  800ab8:	73 17                	jae    800ad1 <vprintfmt+0x44b>
  800aba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800abe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac1:	89 d2                	mov    %edx,%edx
  800ac3:	48 01 d0             	add    %rdx,%rax
  800ac6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac9:	83 c2 08             	add    $0x8,%edx
  800acc:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800acf:	eb 0c                	jmp    800add <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800ad1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ad5:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ad9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800add:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ae4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800aeb:	eb 23                	jmp    800b10 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800aed:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800af1:	be 03 00 00 00       	mov    $0x3,%esi
  800af6:	48 89 c7             	mov    %rax,%rdi
  800af9:	48 b8 78 04 80 00 00 	movabs $0x800478,%rax
  800b00:	00 00 00 
  800b03:	ff d0                	callq  *%rax
  800b05:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b09:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b10:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b15:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b18:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b1b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b1f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b27:	45 89 c1             	mov    %r8d,%r9d
  800b2a:	41 89 f8             	mov    %edi,%r8d
  800b2d:	48 89 c7             	mov    %rax,%rdi
  800b30:	48 b8 c0 03 80 00 00 	movabs $0x8003c0,%rax
  800b37:	00 00 00 
  800b3a:	ff d0                	callq  *%rax
			break;
  800b3c:	eb 3f                	jmp    800b7d <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b46:	48 89 d6             	mov    %rdx,%rsi
  800b49:	89 df                	mov    %ebx,%edi
  800b4b:	ff d0                	callq  *%rax
			break;
  800b4d:	eb 2e                	jmp    800b7d <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b4f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b57:	48 89 d6             	mov    %rdx,%rsi
  800b5a:	bf 25 00 00 00       	mov    $0x25,%edi
  800b5f:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b61:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b66:	eb 05                	jmp    800b6d <vprintfmt+0x4e7>
  800b68:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b6d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b71:	48 83 e8 01          	sub    $0x1,%rax
  800b75:	0f b6 00             	movzbl (%rax),%eax
  800b78:	3c 25                	cmp    $0x25,%al
  800b7a:	75 ec                	jne    800b68 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800b7c:	90                   	nop
		}
	}
  800b7d:	e9 3d fb ff ff       	jmpq   8006bf <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b82:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b83:	48 83 c4 60          	add    $0x60,%rsp
  800b87:	5b                   	pop    %rbx
  800b88:	41 5c                	pop    %r12
  800b8a:	5d                   	pop    %rbp
  800b8b:	c3                   	retq   

0000000000800b8c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b8c:	55                   	push   %rbp
  800b8d:	48 89 e5             	mov    %rsp,%rbp
  800b90:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b97:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b9e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ba5:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800bac:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800bb3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800bba:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bc1:	84 c0                	test   %al,%al
  800bc3:	74 20                	je     800be5 <printfmt+0x59>
  800bc5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bc9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bcd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bd1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bd5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bd9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bdd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800be1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800be5:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800bec:	00 00 00 
  800bef:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800bf6:	00 00 00 
  800bf9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bfd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c04:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c0b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c12:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c19:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c20:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c27:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c2e:	48 89 c7             	mov    %rax,%rdi
  800c31:	48 b8 86 06 80 00 00 	movabs $0x800686,%rax
  800c38:	00 00 00 
  800c3b:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c3d:	90                   	nop
  800c3e:	c9                   	leaveq 
  800c3f:	c3                   	retq   

0000000000800c40 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c40:	55                   	push   %rbp
  800c41:	48 89 e5             	mov    %rsp,%rbp
  800c44:	48 83 ec 10          	sub    $0x10,%rsp
  800c48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c53:	8b 40 10             	mov    0x10(%rax),%eax
  800c56:	8d 50 01             	lea    0x1(%rax),%edx
  800c59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c5d:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c64:	48 8b 10             	mov    (%rax),%rdx
  800c67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c6b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c6f:	48 39 c2             	cmp    %rax,%rdx
  800c72:	73 17                	jae    800c8b <sprintputch+0x4b>
		*b->buf++ = ch;
  800c74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c78:	48 8b 00             	mov    (%rax),%rax
  800c7b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c83:	48 89 0a             	mov    %rcx,(%rdx)
  800c86:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c89:	88 10                	mov    %dl,(%rax)
}
  800c8b:	90                   	nop
  800c8c:	c9                   	leaveq 
  800c8d:	c3                   	retq   

0000000000800c8e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c8e:	55                   	push   %rbp
  800c8f:	48 89 e5             	mov    %rsp,%rbp
  800c92:	48 83 ec 50          	sub    $0x50,%rsp
  800c96:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c9a:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c9d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ca1:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ca5:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ca9:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800cad:	48 8b 0a             	mov    (%rdx),%rcx
  800cb0:	48 89 08             	mov    %rcx,(%rax)
  800cb3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cb7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cbb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cbf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cc3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cc7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ccb:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cce:	48 98                	cltq   
  800cd0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800cd4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cd8:	48 01 d0             	add    %rdx,%rax
  800cdb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800cdf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ce6:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ceb:	74 06                	je     800cf3 <vsnprintf+0x65>
  800ced:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800cf1:	7f 07                	jg     800cfa <vsnprintf+0x6c>
		return -E_INVAL;
  800cf3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cf8:	eb 2f                	jmp    800d29 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800cfa:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800cfe:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d02:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d06:	48 89 c6             	mov    %rax,%rsi
  800d09:	48 bf 40 0c 80 00 00 	movabs $0x800c40,%rdi
  800d10:	00 00 00 
  800d13:	48 b8 86 06 80 00 00 	movabs $0x800686,%rax
  800d1a:	00 00 00 
  800d1d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d23:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d26:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d29:	c9                   	leaveq 
  800d2a:	c3                   	retq   

0000000000800d2b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d2b:	55                   	push   %rbp
  800d2c:	48 89 e5             	mov    %rsp,%rbp
  800d2f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d36:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d3d:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d43:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800d4a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d51:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d58:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d5f:	84 c0                	test   %al,%al
  800d61:	74 20                	je     800d83 <snprintf+0x58>
  800d63:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d67:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d6b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d6f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d73:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d77:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d7b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d7f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d83:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d8a:	00 00 00 
  800d8d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d94:	00 00 00 
  800d97:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d9b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800da2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800da9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800db0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800db7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dbe:	48 8b 0a             	mov    (%rdx),%rcx
  800dc1:	48 89 08             	mov    %rcx,(%rax)
  800dc4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dc8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dcc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dd0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800dd4:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ddb:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800de2:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800de8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800def:	48 89 c7             	mov    %rax,%rdi
  800df2:	48 b8 8e 0c 80 00 00 	movabs $0x800c8e,%rax
  800df9:	00 00 00 
  800dfc:	ff d0                	callq  *%rax
  800dfe:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e04:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e0a:	c9                   	leaveq 
  800e0b:	c3                   	retq   

0000000000800e0c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e0c:	55                   	push   %rbp
  800e0d:	48 89 e5             	mov    %rsp,%rbp
  800e10:	48 83 ec 18          	sub    $0x18,%rsp
  800e14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e1f:	eb 09                	jmp    800e2a <strlen+0x1e>
		n++;
  800e21:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e25:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2e:	0f b6 00             	movzbl (%rax),%eax
  800e31:	84 c0                	test   %al,%al
  800e33:	75 ec                	jne    800e21 <strlen+0x15>
		n++;
	return n;
  800e35:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e38:	c9                   	leaveq 
  800e39:	c3                   	retq   

0000000000800e3a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e3a:	55                   	push   %rbp
  800e3b:	48 89 e5             	mov    %rsp,%rbp
  800e3e:	48 83 ec 20          	sub    $0x20,%rsp
  800e42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e46:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e51:	eb 0e                	jmp    800e61 <strnlen+0x27>
		n++;
  800e53:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e57:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e5c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e61:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e66:	74 0b                	je     800e73 <strnlen+0x39>
  800e68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6c:	0f b6 00             	movzbl (%rax),%eax
  800e6f:	84 c0                	test   %al,%al
  800e71:	75 e0                	jne    800e53 <strnlen+0x19>
		n++;
	return n;
  800e73:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e76:	c9                   	leaveq 
  800e77:	c3                   	retq   

0000000000800e78 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e78:	55                   	push   %rbp
  800e79:	48 89 e5             	mov    %rsp,%rbp
  800e7c:	48 83 ec 20          	sub    $0x20,%rsp
  800e80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e90:	90                   	nop
  800e91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e95:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e99:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e9d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ea1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ea5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ea9:	0f b6 12             	movzbl (%rdx),%edx
  800eac:	88 10                	mov    %dl,(%rax)
  800eae:	0f b6 00             	movzbl (%rax),%eax
  800eb1:	84 c0                	test   %al,%al
  800eb3:	75 dc                	jne    800e91 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800eb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800eb9:	c9                   	leaveq 
  800eba:	c3                   	retq   

0000000000800ebb <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ebb:	55                   	push   %rbp
  800ebc:	48 89 e5             	mov    %rsp,%rbp
  800ebf:	48 83 ec 20          	sub    $0x20,%rsp
  800ec3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ec7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800ecb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ecf:	48 89 c7             	mov    %rax,%rdi
  800ed2:	48 b8 0c 0e 80 00 00 	movabs $0x800e0c,%rax
  800ed9:	00 00 00 
  800edc:	ff d0                	callq  *%rax
  800ede:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ee1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ee4:	48 63 d0             	movslq %eax,%rdx
  800ee7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eeb:	48 01 c2             	add    %rax,%rdx
  800eee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ef2:	48 89 c6             	mov    %rax,%rsi
  800ef5:	48 89 d7             	mov    %rdx,%rdi
  800ef8:	48 b8 78 0e 80 00 00 	movabs $0x800e78,%rax
  800eff:	00 00 00 
  800f02:	ff d0                	callq  *%rax
	return dst;
  800f04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f08:	c9                   	leaveq 
  800f09:	c3                   	retq   

0000000000800f0a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f0a:	55                   	push   %rbp
  800f0b:	48 89 e5             	mov    %rsp,%rbp
  800f0e:	48 83 ec 28          	sub    $0x28,%rsp
  800f12:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f16:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f1a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f22:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f26:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f2d:	00 
  800f2e:	eb 2a                	jmp    800f5a <strncpy+0x50>
		*dst++ = *src;
  800f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f34:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f38:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f3c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f40:	0f b6 12             	movzbl (%rdx),%edx
  800f43:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f49:	0f b6 00             	movzbl (%rax),%eax
  800f4c:	84 c0                	test   %al,%al
  800f4e:	74 05                	je     800f55 <strncpy+0x4b>
			src++;
  800f50:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f55:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f5e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f62:	72 cc                	jb     800f30 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f68:	c9                   	leaveq 
  800f69:	c3                   	retq   

0000000000800f6a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f6a:	55                   	push   %rbp
  800f6b:	48 89 e5             	mov    %rsp,%rbp
  800f6e:	48 83 ec 28          	sub    $0x28,%rsp
  800f72:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f7a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f82:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f86:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f8b:	74 3d                	je     800fca <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f8d:	eb 1d                	jmp    800fac <strlcpy+0x42>
			*dst++ = *src++;
  800f8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f93:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f97:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f9b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f9f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fa3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fa7:	0f b6 12             	movzbl (%rdx),%edx
  800faa:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fac:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fb1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fb6:	74 0b                	je     800fc3 <strlcpy+0x59>
  800fb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fbc:	0f b6 00             	movzbl (%rax),%eax
  800fbf:	84 c0                	test   %al,%al
  800fc1:	75 cc                	jne    800f8f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800fc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc7:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800fca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fd2:	48 29 c2             	sub    %rax,%rdx
  800fd5:	48 89 d0             	mov    %rdx,%rax
}
  800fd8:	c9                   	leaveq 
  800fd9:	c3                   	retq   

0000000000800fda <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fda:	55                   	push   %rbp
  800fdb:	48 89 e5             	mov    %rsp,%rbp
  800fde:	48 83 ec 10          	sub    $0x10,%rsp
  800fe2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fe6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800fea:	eb 0a                	jmp    800ff6 <strcmp+0x1c>
		p++, q++;
  800fec:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ff1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ff6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ffa:	0f b6 00             	movzbl (%rax),%eax
  800ffd:	84 c0                	test   %al,%al
  800fff:	74 12                	je     801013 <strcmp+0x39>
  801001:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801005:	0f b6 10             	movzbl (%rax),%edx
  801008:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100c:	0f b6 00             	movzbl (%rax),%eax
  80100f:	38 c2                	cmp    %al,%dl
  801011:	74 d9                	je     800fec <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801013:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801017:	0f b6 00             	movzbl (%rax),%eax
  80101a:	0f b6 d0             	movzbl %al,%edx
  80101d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801021:	0f b6 00             	movzbl (%rax),%eax
  801024:	0f b6 c0             	movzbl %al,%eax
  801027:	29 c2                	sub    %eax,%edx
  801029:	89 d0                	mov    %edx,%eax
}
  80102b:	c9                   	leaveq 
  80102c:	c3                   	retq   

000000000080102d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80102d:	55                   	push   %rbp
  80102e:	48 89 e5             	mov    %rsp,%rbp
  801031:	48 83 ec 18          	sub    $0x18,%rsp
  801035:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801039:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80103d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801041:	eb 0f                	jmp    801052 <strncmp+0x25>
		n--, p++, q++;
  801043:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801048:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80104d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801052:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801057:	74 1d                	je     801076 <strncmp+0x49>
  801059:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105d:	0f b6 00             	movzbl (%rax),%eax
  801060:	84 c0                	test   %al,%al
  801062:	74 12                	je     801076 <strncmp+0x49>
  801064:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801068:	0f b6 10             	movzbl (%rax),%edx
  80106b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80106f:	0f b6 00             	movzbl (%rax),%eax
  801072:	38 c2                	cmp    %al,%dl
  801074:	74 cd                	je     801043 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801076:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80107b:	75 07                	jne    801084 <strncmp+0x57>
		return 0;
  80107d:	b8 00 00 00 00       	mov    $0x0,%eax
  801082:	eb 18                	jmp    80109c <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801088:	0f b6 00             	movzbl (%rax),%eax
  80108b:	0f b6 d0             	movzbl %al,%edx
  80108e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801092:	0f b6 00             	movzbl (%rax),%eax
  801095:	0f b6 c0             	movzbl %al,%eax
  801098:	29 c2                	sub    %eax,%edx
  80109a:	89 d0                	mov    %edx,%eax
}
  80109c:	c9                   	leaveq 
  80109d:	c3                   	retq   

000000000080109e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80109e:	55                   	push   %rbp
  80109f:	48 89 e5             	mov    %rsp,%rbp
  8010a2:	48 83 ec 10          	sub    $0x10,%rsp
  8010a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010aa:	89 f0                	mov    %esi,%eax
  8010ac:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010af:	eb 17                	jmp    8010c8 <strchr+0x2a>
		if (*s == c)
  8010b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b5:	0f b6 00             	movzbl (%rax),%eax
  8010b8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010bb:	75 06                	jne    8010c3 <strchr+0x25>
			return (char *) s;
  8010bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c1:	eb 15                	jmp    8010d8 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010c3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010cc:	0f b6 00             	movzbl (%rax),%eax
  8010cf:	84 c0                	test   %al,%al
  8010d1:	75 de                	jne    8010b1 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d8:	c9                   	leaveq 
  8010d9:	c3                   	retq   

00000000008010da <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010da:	55                   	push   %rbp
  8010db:	48 89 e5             	mov    %rsp,%rbp
  8010de:	48 83 ec 10          	sub    $0x10,%rsp
  8010e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010e6:	89 f0                	mov    %esi,%eax
  8010e8:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010eb:	eb 11                	jmp    8010fe <strfind+0x24>
		if (*s == c)
  8010ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f1:	0f b6 00             	movzbl (%rax),%eax
  8010f4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010f7:	74 12                	je     80110b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801102:	0f b6 00             	movzbl (%rax),%eax
  801105:	84 c0                	test   %al,%al
  801107:	75 e4                	jne    8010ed <strfind+0x13>
  801109:	eb 01                	jmp    80110c <strfind+0x32>
		if (*s == c)
			break;
  80110b:	90                   	nop
	return (char *) s;
  80110c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801110:	c9                   	leaveq 
  801111:	c3                   	retq   

0000000000801112 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801112:	55                   	push   %rbp
  801113:	48 89 e5             	mov    %rsp,%rbp
  801116:	48 83 ec 18          	sub    $0x18,%rsp
  80111a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80111e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801121:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801125:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80112a:	75 06                	jne    801132 <memset+0x20>
		return v;
  80112c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801130:	eb 69                	jmp    80119b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801136:	83 e0 03             	and    $0x3,%eax
  801139:	48 85 c0             	test   %rax,%rax
  80113c:	75 48                	jne    801186 <memset+0x74>
  80113e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801142:	83 e0 03             	and    $0x3,%eax
  801145:	48 85 c0             	test   %rax,%rax
  801148:	75 3c                	jne    801186 <memset+0x74>
		c &= 0xFF;
  80114a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801151:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801154:	c1 e0 18             	shl    $0x18,%eax
  801157:	89 c2                	mov    %eax,%edx
  801159:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80115c:	c1 e0 10             	shl    $0x10,%eax
  80115f:	09 c2                	or     %eax,%edx
  801161:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801164:	c1 e0 08             	shl    $0x8,%eax
  801167:	09 d0                	or     %edx,%eax
  801169:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80116c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801170:	48 c1 e8 02          	shr    $0x2,%rax
  801174:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801177:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80117b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80117e:	48 89 d7             	mov    %rdx,%rdi
  801181:	fc                   	cld    
  801182:	f3 ab                	rep stos %eax,%es:(%rdi)
  801184:	eb 11                	jmp    801197 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801186:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80118a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80118d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801191:	48 89 d7             	mov    %rdx,%rdi
  801194:	fc                   	cld    
  801195:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801197:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80119b:	c9                   	leaveq 
  80119c:	c3                   	retq   

000000000080119d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80119d:	55                   	push   %rbp
  80119e:	48 89 e5             	mov    %rsp,%rbp
  8011a1:	48 83 ec 28          	sub    $0x28,%rsp
  8011a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011c9:	0f 83 88 00 00 00    	jae    801257 <memmove+0xba>
  8011cf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d7:	48 01 d0             	add    %rdx,%rax
  8011da:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011de:	76 77                	jbe    801257 <memmove+0xba>
		s += n;
  8011e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011e4:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011ec:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f4:	83 e0 03             	and    $0x3,%eax
  8011f7:	48 85 c0             	test   %rax,%rax
  8011fa:	75 3b                	jne    801237 <memmove+0x9a>
  8011fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801200:	83 e0 03             	and    $0x3,%eax
  801203:	48 85 c0             	test   %rax,%rax
  801206:	75 2f                	jne    801237 <memmove+0x9a>
  801208:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80120c:	83 e0 03             	and    $0x3,%eax
  80120f:	48 85 c0             	test   %rax,%rax
  801212:	75 23                	jne    801237 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801214:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801218:	48 83 e8 04          	sub    $0x4,%rax
  80121c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801220:	48 83 ea 04          	sub    $0x4,%rdx
  801224:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801228:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80122c:	48 89 c7             	mov    %rax,%rdi
  80122f:	48 89 d6             	mov    %rdx,%rsi
  801232:	fd                   	std    
  801233:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801235:	eb 1d                	jmp    801254 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801237:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80123f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801243:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801247:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80124b:	48 89 d7             	mov    %rdx,%rdi
  80124e:	48 89 c1             	mov    %rax,%rcx
  801251:	fd                   	std    
  801252:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801254:	fc                   	cld    
  801255:	eb 57                	jmp    8012ae <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801257:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125b:	83 e0 03             	and    $0x3,%eax
  80125e:	48 85 c0             	test   %rax,%rax
  801261:	75 36                	jne    801299 <memmove+0xfc>
  801263:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801267:	83 e0 03             	and    $0x3,%eax
  80126a:	48 85 c0             	test   %rax,%rax
  80126d:	75 2a                	jne    801299 <memmove+0xfc>
  80126f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801273:	83 e0 03             	and    $0x3,%eax
  801276:	48 85 c0             	test   %rax,%rax
  801279:	75 1e                	jne    801299 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80127b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80127f:	48 c1 e8 02          	shr    $0x2,%rax
  801283:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80128e:	48 89 c7             	mov    %rax,%rdi
  801291:	48 89 d6             	mov    %rdx,%rsi
  801294:	fc                   	cld    
  801295:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801297:	eb 15                	jmp    8012ae <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801299:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012a1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012a5:	48 89 c7             	mov    %rax,%rdi
  8012a8:	48 89 d6             	mov    %rdx,%rsi
  8012ab:	fc                   	cld    
  8012ac:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012b2:	c9                   	leaveq 
  8012b3:	c3                   	retq   

00000000008012b4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012b4:	55                   	push   %rbp
  8012b5:	48 89 e5             	mov    %rsp,%rbp
  8012b8:	48 83 ec 18          	sub    $0x18,%rsp
  8012bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012c4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012cc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d4:	48 89 ce             	mov    %rcx,%rsi
  8012d7:	48 89 c7             	mov    %rax,%rdi
  8012da:	48 b8 9d 11 80 00 00 	movabs $0x80119d,%rax
  8012e1:	00 00 00 
  8012e4:	ff d0                	callq  *%rax
}
  8012e6:	c9                   	leaveq 
  8012e7:	c3                   	retq   

00000000008012e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012e8:	55                   	push   %rbp
  8012e9:	48 89 e5             	mov    %rsp,%rbp
  8012ec:	48 83 ec 28          	sub    $0x28,%rsp
  8012f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801300:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801304:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801308:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80130c:	eb 36                	jmp    801344 <memcmp+0x5c>
		if (*s1 != *s2)
  80130e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801312:	0f b6 10             	movzbl (%rax),%edx
  801315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801319:	0f b6 00             	movzbl (%rax),%eax
  80131c:	38 c2                	cmp    %al,%dl
  80131e:	74 1a                	je     80133a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801324:	0f b6 00             	movzbl (%rax),%eax
  801327:	0f b6 d0             	movzbl %al,%edx
  80132a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132e:	0f b6 00             	movzbl (%rax),%eax
  801331:	0f b6 c0             	movzbl %al,%eax
  801334:	29 c2                	sub    %eax,%edx
  801336:	89 d0                	mov    %edx,%eax
  801338:	eb 20                	jmp    80135a <memcmp+0x72>
		s1++, s2++;
  80133a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80133f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801344:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801348:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80134c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801350:	48 85 c0             	test   %rax,%rax
  801353:	75 b9                	jne    80130e <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801355:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135a:	c9                   	leaveq 
  80135b:	c3                   	retq   

000000000080135c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80135c:	55                   	push   %rbp
  80135d:	48 89 e5             	mov    %rsp,%rbp
  801360:	48 83 ec 28          	sub    $0x28,%rsp
  801364:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801368:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80136b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80136f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801373:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801377:	48 01 d0             	add    %rdx,%rax
  80137a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80137e:	eb 19                	jmp    801399 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801380:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801384:	0f b6 00             	movzbl (%rax),%eax
  801387:	0f b6 d0             	movzbl %al,%edx
  80138a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80138d:	0f b6 c0             	movzbl %al,%eax
  801390:	39 c2                	cmp    %eax,%edx
  801392:	74 11                	je     8013a5 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801394:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801399:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80139d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013a1:	72 dd                	jb     801380 <memfind+0x24>
  8013a3:	eb 01                	jmp    8013a6 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013a5:	90                   	nop
	return (void *) s;
  8013a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013aa:	c9                   	leaveq 
  8013ab:	c3                   	retq   

00000000008013ac <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013ac:	55                   	push   %rbp
  8013ad:	48 89 e5             	mov    %rsp,%rbp
  8013b0:	48 83 ec 38          	sub    $0x38,%rsp
  8013b4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013b8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013bc:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013c6:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013cd:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013ce:	eb 05                	jmp    8013d5 <strtol+0x29>
		s++;
  8013d0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d9:	0f b6 00             	movzbl (%rax),%eax
  8013dc:	3c 20                	cmp    $0x20,%al
  8013de:	74 f0                	je     8013d0 <strtol+0x24>
  8013e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e4:	0f b6 00             	movzbl (%rax),%eax
  8013e7:	3c 09                	cmp    $0x9,%al
  8013e9:	74 e5                	je     8013d0 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ef:	0f b6 00             	movzbl (%rax),%eax
  8013f2:	3c 2b                	cmp    $0x2b,%al
  8013f4:	75 07                	jne    8013fd <strtol+0x51>
		s++;
  8013f6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013fb:	eb 17                	jmp    801414 <strtol+0x68>
	else if (*s == '-')
  8013fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801401:	0f b6 00             	movzbl (%rax),%eax
  801404:	3c 2d                	cmp    $0x2d,%al
  801406:	75 0c                	jne    801414 <strtol+0x68>
		s++, neg = 1;
  801408:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80140d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801414:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801418:	74 06                	je     801420 <strtol+0x74>
  80141a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80141e:	75 28                	jne    801448 <strtol+0x9c>
  801420:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801424:	0f b6 00             	movzbl (%rax),%eax
  801427:	3c 30                	cmp    $0x30,%al
  801429:	75 1d                	jne    801448 <strtol+0x9c>
  80142b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142f:	48 83 c0 01          	add    $0x1,%rax
  801433:	0f b6 00             	movzbl (%rax),%eax
  801436:	3c 78                	cmp    $0x78,%al
  801438:	75 0e                	jne    801448 <strtol+0x9c>
		s += 2, base = 16;
  80143a:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80143f:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801446:	eb 2c                	jmp    801474 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801448:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80144c:	75 19                	jne    801467 <strtol+0xbb>
  80144e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801452:	0f b6 00             	movzbl (%rax),%eax
  801455:	3c 30                	cmp    $0x30,%al
  801457:	75 0e                	jne    801467 <strtol+0xbb>
		s++, base = 8;
  801459:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80145e:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801465:	eb 0d                	jmp    801474 <strtol+0xc8>
	else if (base == 0)
  801467:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80146b:	75 07                	jne    801474 <strtol+0xc8>
		base = 10;
  80146d:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801474:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801478:	0f b6 00             	movzbl (%rax),%eax
  80147b:	3c 2f                	cmp    $0x2f,%al
  80147d:	7e 1d                	jle    80149c <strtol+0xf0>
  80147f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801483:	0f b6 00             	movzbl (%rax),%eax
  801486:	3c 39                	cmp    $0x39,%al
  801488:	7f 12                	jg     80149c <strtol+0xf0>
			dig = *s - '0';
  80148a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148e:	0f b6 00             	movzbl (%rax),%eax
  801491:	0f be c0             	movsbl %al,%eax
  801494:	83 e8 30             	sub    $0x30,%eax
  801497:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80149a:	eb 4e                	jmp    8014ea <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80149c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a0:	0f b6 00             	movzbl (%rax),%eax
  8014a3:	3c 60                	cmp    $0x60,%al
  8014a5:	7e 1d                	jle    8014c4 <strtol+0x118>
  8014a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ab:	0f b6 00             	movzbl (%rax),%eax
  8014ae:	3c 7a                	cmp    $0x7a,%al
  8014b0:	7f 12                	jg     8014c4 <strtol+0x118>
			dig = *s - 'a' + 10;
  8014b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b6:	0f b6 00             	movzbl (%rax),%eax
  8014b9:	0f be c0             	movsbl %al,%eax
  8014bc:	83 e8 57             	sub    $0x57,%eax
  8014bf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014c2:	eb 26                	jmp    8014ea <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c8:	0f b6 00             	movzbl (%rax),%eax
  8014cb:	3c 40                	cmp    $0x40,%al
  8014cd:	7e 47                	jle    801516 <strtol+0x16a>
  8014cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d3:	0f b6 00             	movzbl (%rax),%eax
  8014d6:	3c 5a                	cmp    $0x5a,%al
  8014d8:	7f 3c                	jg     801516 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8014da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014de:	0f b6 00             	movzbl (%rax),%eax
  8014e1:	0f be c0             	movsbl %al,%eax
  8014e4:	83 e8 37             	sub    $0x37,%eax
  8014e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014ed:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014f0:	7d 23                	jge    801515 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8014f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014f7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014fa:	48 98                	cltq   
  8014fc:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801501:	48 89 c2             	mov    %rax,%rdx
  801504:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801507:	48 98                	cltq   
  801509:	48 01 d0             	add    %rdx,%rax
  80150c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801510:	e9 5f ff ff ff       	jmpq   801474 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801515:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801516:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80151b:	74 0b                	je     801528 <strtol+0x17c>
		*endptr = (char *) s;
  80151d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801521:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801525:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801528:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80152c:	74 09                	je     801537 <strtol+0x18b>
  80152e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801532:	48 f7 d8             	neg    %rax
  801535:	eb 04                	jmp    80153b <strtol+0x18f>
  801537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80153b:	c9                   	leaveq 
  80153c:	c3                   	retq   

000000000080153d <strstr>:

char * strstr(const char *in, const char *str)
{
  80153d:	55                   	push   %rbp
  80153e:	48 89 e5             	mov    %rsp,%rbp
  801541:	48 83 ec 30          	sub    $0x30,%rsp
  801545:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801549:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80154d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801551:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801555:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801559:	0f b6 00             	movzbl (%rax),%eax
  80155c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80155f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801563:	75 06                	jne    80156b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801565:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801569:	eb 6b                	jmp    8015d6 <strstr+0x99>

	len = strlen(str);
  80156b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80156f:	48 89 c7             	mov    %rax,%rdi
  801572:	48 b8 0c 0e 80 00 00 	movabs $0x800e0c,%rax
  801579:	00 00 00 
  80157c:	ff d0                	callq  *%rax
  80157e:	48 98                	cltq   
  801580:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801584:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801588:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80158c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801590:	0f b6 00             	movzbl (%rax),%eax
  801593:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801596:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80159a:	75 07                	jne    8015a3 <strstr+0x66>
				return (char *) 0;
  80159c:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a1:	eb 33                	jmp    8015d6 <strstr+0x99>
		} while (sc != c);
  8015a3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015a7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015aa:	75 d8                	jne    801584 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8015ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015b0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b8:	48 89 ce             	mov    %rcx,%rsi
  8015bb:	48 89 c7             	mov    %rax,%rdi
  8015be:	48 b8 2d 10 80 00 00 	movabs $0x80102d,%rax
  8015c5:	00 00 00 
  8015c8:	ff d0                	callq  *%rax
  8015ca:	85 c0                	test   %eax,%eax
  8015cc:	75 b6                	jne    801584 <strstr+0x47>

	return (char *) (in - 1);
  8015ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d2:	48 83 e8 01          	sub    $0x1,%rax
}
  8015d6:	c9                   	leaveq 
  8015d7:	c3                   	retq   

00000000008015d8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015d8:	55                   	push   %rbp
  8015d9:	48 89 e5             	mov    %rsp,%rbp
  8015dc:	53                   	push   %rbx
  8015dd:	48 83 ec 48          	sub    $0x48,%rsp
  8015e1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015e4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015e7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015eb:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015ef:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015f3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015f7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015fa:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015fe:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801602:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801606:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80160a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80160e:	4c 89 c3             	mov    %r8,%rbx
  801611:	cd 30                	int    $0x30
  801613:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801617:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80161b:	74 3e                	je     80165b <syscall+0x83>
  80161d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801622:	7e 37                	jle    80165b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801624:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801628:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80162b:	49 89 d0             	mov    %rdx,%r8
  80162e:	89 c1                	mov    %eax,%ecx
  801630:	48 ba 48 21 80 00 00 	movabs $0x802148,%rdx
  801637:	00 00 00 
  80163a:	be 23 00 00 00       	mov    $0x23,%esi
  80163f:	48 bf 65 21 80 00 00 	movabs $0x802165,%rdi
  801646:	00 00 00 
  801649:	b8 00 00 00 00       	mov    $0x0,%eax
  80164e:	49 b9 b0 1b 80 00 00 	movabs $0x801bb0,%r9
  801655:	00 00 00 
  801658:	41 ff d1             	callq  *%r9

	return ret;
  80165b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80165f:	48 83 c4 48          	add    $0x48,%rsp
  801663:	5b                   	pop    %rbx
  801664:	5d                   	pop    %rbp
  801665:	c3                   	retq   

0000000000801666 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801666:	55                   	push   %rbp
  801667:	48 89 e5             	mov    %rsp,%rbp
  80166a:	48 83 ec 10          	sub    $0x10,%rsp
  80166e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801672:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801676:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80167e:	48 83 ec 08          	sub    $0x8,%rsp
  801682:	6a 00                	pushq  $0x0
  801684:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80168a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801690:	48 89 d1             	mov    %rdx,%rcx
  801693:	48 89 c2             	mov    %rax,%rdx
  801696:	be 00 00 00 00       	mov    $0x0,%esi
  80169b:	bf 00 00 00 00       	mov    $0x0,%edi
  8016a0:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  8016a7:	00 00 00 
  8016aa:	ff d0                	callq  *%rax
  8016ac:	48 83 c4 10          	add    $0x10,%rsp
}
  8016b0:	90                   	nop
  8016b1:	c9                   	leaveq 
  8016b2:	c3                   	retq   

00000000008016b3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016b3:	55                   	push   %rbp
  8016b4:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016b7:	48 83 ec 08          	sub    $0x8,%rsp
  8016bb:	6a 00                	pushq  $0x0
  8016bd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d3:	be 00 00 00 00       	mov    $0x0,%esi
  8016d8:	bf 01 00 00 00       	mov    $0x1,%edi
  8016dd:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  8016e4:	00 00 00 
  8016e7:	ff d0                	callq  *%rax
  8016e9:	48 83 c4 10          	add    $0x10,%rsp
}
  8016ed:	c9                   	leaveq 
  8016ee:	c3                   	retq   

00000000008016ef <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016ef:	55                   	push   %rbp
  8016f0:	48 89 e5             	mov    %rsp,%rbp
  8016f3:	48 83 ec 10          	sub    $0x10,%rsp
  8016f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016fd:	48 98                	cltq   
  8016ff:	48 83 ec 08          	sub    $0x8,%rsp
  801703:	6a 00                	pushq  $0x0
  801705:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80170b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801711:	b9 00 00 00 00       	mov    $0x0,%ecx
  801716:	48 89 c2             	mov    %rax,%rdx
  801719:	be 01 00 00 00       	mov    $0x1,%esi
  80171e:	bf 03 00 00 00       	mov    $0x3,%edi
  801723:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  80172a:	00 00 00 
  80172d:	ff d0                	callq  *%rax
  80172f:	48 83 c4 10          	add    $0x10,%rsp
}
  801733:	c9                   	leaveq 
  801734:	c3                   	retq   

0000000000801735 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801735:	55                   	push   %rbp
  801736:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801739:	48 83 ec 08          	sub    $0x8,%rsp
  80173d:	6a 00                	pushq  $0x0
  80173f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801745:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80174b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801750:	ba 00 00 00 00       	mov    $0x0,%edx
  801755:	be 00 00 00 00       	mov    $0x0,%esi
  80175a:	bf 02 00 00 00       	mov    $0x2,%edi
  80175f:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  801766:	00 00 00 
  801769:	ff d0                	callq  *%rax
  80176b:	48 83 c4 10          	add    $0x10,%rsp
}
  80176f:	c9                   	leaveq 
  801770:	c3                   	retq   

0000000000801771 <sys_yield>:

void
sys_yield(void)
{
  801771:	55                   	push   %rbp
  801772:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801775:	48 83 ec 08          	sub    $0x8,%rsp
  801779:	6a 00                	pushq  $0x0
  80177b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801781:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801787:	b9 00 00 00 00       	mov    $0x0,%ecx
  80178c:	ba 00 00 00 00       	mov    $0x0,%edx
  801791:	be 00 00 00 00       	mov    $0x0,%esi
  801796:	bf 0a 00 00 00       	mov    $0xa,%edi
  80179b:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  8017a2:	00 00 00 
  8017a5:	ff d0                	callq  *%rax
  8017a7:	48 83 c4 10          	add    $0x10,%rsp
}
  8017ab:	90                   	nop
  8017ac:	c9                   	leaveq 
  8017ad:	c3                   	retq   

00000000008017ae <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017ae:	55                   	push   %rbp
  8017af:	48 89 e5             	mov    %rsp,%rbp
  8017b2:	48 83 ec 10          	sub    $0x10,%rsp
  8017b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017bd:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017c3:	48 63 c8             	movslq %eax,%rcx
  8017c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017cd:	48 98                	cltq   
  8017cf:	48 83 ec 08          	sub    $0x8,%rsp
  8017d3:	6a 00                	pushq  $0x0
  8017d5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017db:	49 89 c8             	mov    %rcx,%r8
  8017de:	48 89 d1             	mov    %rdx,%rcx
  8017e1:	48 89 c2             	mov    %rax,%rdx
  8017e4:	be 01 00 00 00       	mov    $0x1,%esi
  8017e9:	bf 04 00 00 00       	mov    $0x4,%edi
  8017ee:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  8017f5:	00 00 00 
  8017f8:	ff d0                	callq  *%rax
  8017fa:	48 83 c4 10          	add    $0x10,%rsp
}
  8017fe:	c9                   	leaveq 
  8017ff:	c3                   	retq   

0000000000801800 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801800:	55                   	push   %rbp
  801801:	48 89 e5             	mov    %rsp,%rbp
  801804:	48 83 ec 20          	sub    $0x20,%rsp
  801808:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80180b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80180f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801812:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801816:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80181a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80181d:	48 63 c8             	movslq %eax,%rcx
  801820:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801824:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801827:	48 63 f0             	movslq %eax,%rsi
  80182a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80182e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801831:	48 98                	cltq   
  801833:	48 83 ec 08          	sub    $0x8,%rsp
  801837:	51                   	push   %rcx
  801838:	49 89 f9             	mov    %rdi,%r9
  80183b:	49 89 f0             	mov    %rsi,%r8
  80183e:	48 89 d1             	mov    %rdx,%rcx
  801841:	48 89 c2             	mov    %rax,%rdx
  801844:	be 01 00 00 00       	mov    $0x1,%esi
  801849:	bf 05 00 00 00       	mov    $0x5,%edi
  80184e:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  801855:	00 00 00 
  801858:	ff d0                	callq  *%rax
  80185a:	48 83 c4 10          	add    $0x10,%rsp
}
  80185e:	c9                   	leaveq 
  80185f:	c3                   	retq   

0000000000801860 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801860:	55                   	push   %rbp
  801861:	48 89 e5             	mov    %rsp,%rbp
  801864:	48 83 ec 10          	sub    $0x10,%rsp
  801868:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80186b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80186f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801873:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801876:	48 98                	cltq   
  801878:	48 83 ec 08          	sub    $0x8,%rsp
  80187c:	6a 00                	pushq  $0x0
  80187e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801884:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80188a:	48 89 d1             	mov    %rdx,%rcx
  80188d:	48 89 c2             	mov    %rax,%rdx
  801890:	be 01 00 00 00       	mov    $0x1,%esi
  801895:	bf 06 00 00 00       	mov    $0x6,%edi
  80189a:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  8018a1:	00 00 00 
  8018a4:	ff d0                	callq  *%rax
  8018a6:	48 83 c4 10          	add    $0x10,%rsp
}
  8018aa:	c9                   	leaveq 
  8018ab:	c3                   	retq   

00000000008018ac <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018ac:	55                   	push   %rbp
  8018ad:	48 89 e5             	mov    %rsp,%rbp
  8018b0:	48 83 ec 10          	sub    $0x10,%rsp
  8018b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018bd:	48 63 d0             	movslq %eax,%rdx
  8018c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c3:	48 98                	cltq   
  8018c5:	48 83 ec 08          	sub    $0x8,%rsp
  8018c9:	6a 00                	pushq  $0x0
  8018cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018d7:	48 89 d1             	mov    %rdx,%rcx
  8018da:	48 89 c2             	mov    %rax,%rdx
  8018dd:	be 01 00 00 00       	mov    $0x1,%esi
  8018e2:	bf 08 00 00 00       	mov    $0x8,%edi
  8018e7:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  8018ee:	00 00 00 
  8018f1:	ff d0                	callq  *%rax
  8018f3:	48 83 c4 10          	add    $0x10,%rsp
}
  8018f7:	c9                   	leaveq 
  8018f8:	c3                   	retq   

00000000008018f9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018f9:	55                   	push   %rbp
  8018fa:	48 89 e5             	mov    %rsp,%rbp
  8018fd:	48 83 ec 10          	sub    $0x10,%rsp
  801901:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801904:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801908:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80190c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190f:	48 98                	cltq   
  801911:	48 83 ec 08          	sub    $0x8,%rsp
  801915:	6a 00                	pushq  $0x0
  801917:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80191d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801923:	48 89 d1             	mov    %rdx,%rcx
  801926:	48 89 c2             	mov    %rax,%rdx
  801929:	be 01 00 00 00       	mov    $0x1,%esi
  80192e:	bf 09 00 00 00       	mov    $0x9,%edi
  801933:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  80193a:	00 00 00 
  80193d:	ff d0                	callq  *%rax
  80193f:	48 83 c4 10          	add    $0x10,%rsp
}
  801943:	c9                   	leaveq 
  801944:	c3                   	retq   

0000000000801945 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801945:	55                   	push   %rbp
  801946:	48 89 e5             	mov    %rsp,%rbp
  801949:	48 83 ec 20          	sub    $0x20,%rsp
  80194d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801950:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801954:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801958:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80195b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80195e:	48 63 f0             	movslq %eax,%rsi
  801961:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801965:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801968:	48 98                	cltq   
  80196a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196e:	48 83 ec 08          	sub    $0x8,%rsp
  801972:	6a 00                	pushq  $0x0
  801974:	49 89 f1             	mov    %rsi,%r9
  801977:	49 89 c8             	mov    %rcx,%r8
  80197a:	48 89 d1             	mov    %rdx,%rcx
  80197d:	48 89 c2             	mov    %rax,%rdx
  801980:	be 00 00 00 00       	mov    $0x0,%esi
  801985:	bf 0b 00 00 00       	mov    $0xb,%edi
  80198a:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  801991:	00 00 00 
  801994:	ff d0                	callq  *%rax
  801996:	48 83 c4 10          	add    $0x10,%rsp
}
  80199a:	c9                   	leaveq 
  80199b:	c3                   	retq   

000000000080199c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80199c:	55                   	push   %rbp
  80199d:	48 89 e5             	mov    %rsp,%rbp
  8019a0:	48 83 ec 10          	sub    $0x10,%rsp
  8019a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ac:	48 83 ec 08          	sub    $0x8,%rsp
  8019b0:	6a 00                	pushq  $0x0
  8019b2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019c3:	48 89 c2             	mov    %rax,%rdx
  8019c6:	be 01 00 00 00       	mov    $0x1,%esi
  8019cb:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019d0:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  8019d7:	00 00 00 
  8019da:	ff d0                	callq  *%rax
  8019dc:	48 83 c4 10          	add    $0x10,%rsp
}
  8019e0:	c9                   	leaveq 
  8019e1:	c3                   	retq   

00000000008019e2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8019e2:	55                   	push   %rbp
  8019e3:	48 89 e5             	mov    %rsp,%rbp
  8019e6:	48 83 ec 30          	sub    $0x30,%rsp
  8019ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	//cprintf("lib ipc_recv\n");
	// LAB 4: Your code here.
	if (pg==NULL){
  8019f6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8019fb:	75 08                	jne    801a05 <ipc_recv+0x23>
		pg = (void *) -1;	
  8019fd:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  801a04:	ff 
	}
	
	int result = sys_ipc_recv(pg);
  801a05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a09:	48 89 c7             	mov    %rax,%rdi
  801a0c:	48 b8 9c 19 80 00 00 	movabs $0x80199c,%rax
  801a13:	00 00 00 
  801a16:	ff d0                	callq  *%rax
  801a18:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (result<0){
  801a1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a1f:	79 27                	jns    801a48 <ipc_recv+0x66>
		if (from_env_store){
  801a21:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a26:	74 0a                	je     801a32 <ipc_recv+0x50>
			*from_env_store=0;
  801a28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a2c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if (perm_store){
  801a32:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a37:	74 0a                	je     801a43 <ipc_recv+0x61>
			*perm_store = 0;
  801a39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		return result;
  801a43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a46:	eb 53                	jmp    801a9b <ipc_recv+0xb9>
	}	
	if (from_env_store){
  801a48:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a4d:	74 19                	je     801a68 <ipc_recv+0x86>
	 	*from_env_store = thisenv->env_ipc_from;
  801a4f:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801a56:	00 00 00 
  801a59:	48 8b 00             	mov    (%rax),%rax
  801a5c:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  801a62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a66:	89 10                	mov    %edx,(%rax)
        }
        if (perm_store){
  801a68:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a6d:	74 19                	je     801a88 <ipc_recv+0xa6>
               	*perm_store = thisenv->env_ipc_perm;
  801a6f:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801a76:	00 00 00 
  801a79:	48 8b 00             	mov    (%rax),%rax
  801a7c:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  801a82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a86:	89 10                	mov    %edx,(%rax)
        }
	//panic("ipc_recv not implemented");
	return thisenv->env_ipc_value;
  801a88:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801a8f:	00 00 00 
  801a92:	48 8b 00             	mov    (%rax),%rax
  801a95:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  801a9b:	c9                   	leaveq 
  801a9c:	c3                   	retq   

0000000000801a9d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a9d:	55                   	push   %rbp
  801a9e:	48 89 e5             	mov    %rsp,%rbp
  801aa1:	48 83 ec 30          	sub    $0x30,%rsp
  801aa5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801aa8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801aab:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801aaf:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	//cprintf("lib ipc_send\n");
	// LAB 4: Your code here.
	if (pg==NULL){
  801ab2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801ab7:	75 4c                	jne    801b05 <ipc_send+0x68>
		pg = (void *)-1;
  801ab9:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  801ac0:	ff 
	}
	int result;
	while((result=sys_ipc_try_send(to_env, val, pg, perm))){
  801ac1:	eb 42                	jmp    801b05 <ipc_send+0x68>
		if (result==0){
  801ac3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ac7:	74 62                	je     801b2b <ipc_send+0x8e>
			break;
		}
		if (result!=-E_IPC_NOT_RECV){
  801ac9:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  801acd:	74 2a                	je     801af9 <ipc_send+0x5c>
			panic("syscall returned improper error");
  801acf:	48 ba 78 21 80 00 00 	movabs $0x802178,%rdx
  801ad6:	00 00 00 
  801ad9:	be 49 00 00 00       	mov    $0x49,%esi
  801ade:	48 bf 98 21 80 00 00 	movabs $0x802198,%rdi
  801ae5:	00 00 00 
  801ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  801aed:	48 b9 b0 1b 80 00 00 	movabs $0x801bb0,%rcx
  801af4:	00 00 00 
  801af7:	ff d1                	callq  *%rcx
		}
		sys_yield();
  801af9:	48 b8 71 17 80 00 00 	movabs $0x801771,%rax
  801b00:	00 00 00 
  801b03:	ff d0                	callq  *%rax
	// LAB 4: Your code here.
	if (pg==NULL){
		pg = (void *)-1;
	}
	int result;
	while((result=sys_ipc_try_send(to_env, val, pg, perm))){
  801b05:	8b 75 e8             	mov    -0x18(%rbp),%esi
  801b08:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801b0b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b0f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b12:	89 c7                	mov    %eax,%edi
  801b14:	48 b8 45 19 80 00 00 	movabs $0x801945,%rax
  801b1b:	00 00 00 
  801b1e:	ff d0                	callq  *%rax
  801b20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b27:	75 9a                	jne    801ac3 <ipc_send+0x26>
			panic("syscall returned improper error");
		}
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  801b29:	eb 01                	jmp    801b2c <ipc_send+0x8f>
		pg = (void *)-1;
	}
	int result;
	while((result=sys_ipc_try_send(to_env, val, pg, perm))){
		if (result==0){
			break;
  801b2b:	90                   	nop
			panic("syscall returned improper error");
		}
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  801b2c:	90                   	nop
  801b2d:	c9                   	leaveq 
  801b2e:	c3                   	retq   

0000000000801b2f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b2f:	55                   	push   %rbp
  801b30:	48 89 e5             	mov    %rsp,%rbp
  801b33:	48 83 ec 18          	sub    $0x18,%rsp
  801b37:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  801b3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b41:	eb 5d                	jmp    801ba0 <ipc_find_env+0x71>
		if (envs[i].env_type == type)
  801b43:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801b4a:	00 00 00 
  801b4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b50:	48 63 d0             	movslq %eax,%rdx
  801b53:	48 89 d0             	mov    %rdx,%rax
  801b56:	48 c1 e0 03          	shl    $0x3,%rax
  801b5a:	48 01 d0             	add    %rdx,%rax
  801b5d:	48 c1 e0 05          	shl    $0x5,%rax
  801b61:	48 01 c8             	add    %rcx,%rax
  801b64:	48 05 d0 00 00 00    	add    $0xd0,%rax
  801b6a:	8b 00                	mov    (%rax),%eax
  801b6c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801b6f:	75 2b                	jne    801b9c <ipc_find_env+0x6d>
			return envs[i].env_id;
  801b71:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801b78:	00 00 00 
  801b7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7e:	48 63 d0             	movslq %eax,%rdx
  801b81:	48 89 d0             	mov    %rdx,%rax
  801b84:	48 c1 e0 03          	shl    $0x3,%rax
  801b88:	48 01 d0             	add    %rdx,%rax
  801b8b:	48 c1 e0 05          	shl    $0x5,%rax
  801b8f:	48 01 c8             	add    %rcx,%rax
  801b92:	48 05 c8 00 00 00    	add    $0xc8,%rax
  801b98:	8b 00                	mov    (%rax),%eax
  801b9a:	eb 12                	jmp    801bae <ipc_find_env+0x7f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  801b9c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ba0:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801ba7:	7e 9a                	jle    801b43 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  801ba9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bae:	c9                   	leaveq 
  801baf:	c3                   	retq   

0000000000801bb0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801bb0:	55                   	push   %rbp
  801bb1:	48 89 e5             	mov    %rsp,%rbp
  801bb4:	53                   	push   %rbx
  801bb5:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801bbc:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801bc3:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801bc9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  801bd0:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801bd7:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801bde:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801be5:	84 c0                	test   %al,%al
  801be7:	74 23                	je     801c0c <_panic+0x5c>
  801be9:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801bf0:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801bf4:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801bf8:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801bfc:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801c00:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801c04:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801c08:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801c0c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801c13:	00 00 00 
  801c16:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801c1d:	00 00 00 
  801c20:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c24:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801c2b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801c32:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801c39:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  801c40:	00 00 00 
  801c43:	48 8b 18             	mov    (%rax),%rbx
  801c46:	48 b8 35 17 80 00 00 	movabs $0x801735,%rax
  801c4d:	00 00 00 
  801c50:	ff d0                	callq  *%rax
  801c52:	89 c6                	mov    %eax,%esi
  801c54:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  801c5a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  801c61:	41 89 d0             	mov    %edx,%r8d
  801c64:	48 89 c1             	mov    %rax,%rcx
  801c67:	48 89 da             	mov    %rbx,%rdx
  801c6a:	48 bf a8 21 80 00 00 	movabs $0x8021a8,%rdi
  801c71:	00 00 00 
  801c74:	b8 00 00 00 00       	mov    $0x0,%eax
  801c79:	49 b9 e8 02 80 00 00 	movabs $0x8002e8,%r9
  801c80:	00 00 00 
  801c83:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c86:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801c8d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801c94:	48 89 d6             	mov    %rdx,%rsi
  801c97:	48 89 c7             	mov    %rax,%rdi
  801c9a:	48 b8 3c 02 80 00 00 	movabs $0x80023c,%rax
  801ca1:	00 00 00 
  801ca4:	ff d0                	callq  *%rax
	cprintf("\n");
  801ca6:	48 bf cb 21 80 00 00 	movabs $0x8021cb,%rdi
  801cad:	00 00 00 
  801cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb5:	48 ba e8 02 80 00 00 	movabs $0x8002e8,%rdx
  801cbc:	00 00 00 
  801cbf:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801cc1:	cc                   	int3   
  801cc2:	eb fd                	jmp    801cc1 <_panic+0x111>
