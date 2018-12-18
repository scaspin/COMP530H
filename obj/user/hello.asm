
obj/user/hello:     file format elf64-x86-64


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
  80003c:	e8 5f 00 00 00       	callq  8000a0 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cprintf("hello, world\n");
  800052:	48 bf 80 1a 80 00 00 	movabs $0x801a80,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006d:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800074:	00 00 00 
  800077:	48 8b 00             	mov    (%rax),%rax
  80007a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800080:	89 c6                	mov    %eax,%esi
  800082:	48 bf 8e 1a 80 00 00 	movabs $0x801a8e,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
}
  80009d:	90                   	nop
  80009e:	c9                   	leaveq 
  80009f:	c3                   	retq   

00000000008000a0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a0:	55                   	push   %rbp
  8000a1:	48 89 e5             	mov    %rsp,%rbp
  8000a4:	48 83 ec 10          	sub    $0x10,%rsp
  8000a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  8000af:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
  8000bb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000c0:	48 63 d0             	movslq %eax,%rdx
  8000c3:	48 89 d0             	mov    %rdx,%rax
  8000c6:	48 c1 e0 03          	shl    $0x3,%rax
  8000ca:	48 01 d0             	add    %rdx,%rax
  8000cd:	48 c1 e0 05          	shl    $0x5,%rax
  8000d1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000d8:	00 00 00 
  8000db:	48 01 c2             	add    %rax,%rdx
  8000de:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000e5:	00 00 00 
  8000e8:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000ef:	7e 14                	jle    800105 <libmain+0x65>
		binaryname = argv[0];
  8000f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000f5:	48 8b 10             	mov    (%rax),%rdx
  8000f8:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000ff:	00 00 00 
  800102:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800105:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800109:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80010c:	48 89 d6             	mov    %rdx,%rsi
  80010f:	89 c7                	mov    %eax,%edi
  800111:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800118:	00 00 00 
  80011b:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80011d:	48 b8 2c 01 80 00 00 	movabs $0x80012c,%rax
  800124:	00 00 00 
  800127:	ff d0                	callq  *%rax
}
  800129:	90                   	nop
  80012a:	c9                   	leaveq 
  80012b:	c3                   	retq   

000000000080012c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012c:	55                   	push   %rbp
  80012d:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800130:	bf 00 00 00 00       	mov    $0x0,%edi
  800135:	48 b8 71 16 80 00 00 	movabs $0x801671,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
}
  800141:	90                   	nop
  800142:	5d                   	pop    %rbp
  800143:	c3                   	retq   

0000000000800144 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800144:	55                   	push   %rbp
  800145:	48 89 e5             	mov    %rsp,%rbp
  800148:	48 83 ec 10          	sub    $0x10,%rsp
  80014c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80014f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800153:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800157:	8b 00                	mov    (%rax),%eax
  800159:	8d 48 01             	lea    0x1(%rax),%ecx
  80015c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800160:	89 0a                	mov    %ecx,(%rdx)
  800162:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800165:	89 d1                	mov    %edx,%ecx
  800167:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80016b:	48 98                	cltq   
  80016d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800171:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800175:	8b 00                	mov    (%rax),%eax
  800177:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017c:	75 2c                	jne    8001aa <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80017e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800182:	8b 00                	mov    (%rax),%eax
  800184:	48 98                	cltq   
  800186:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80018a:	48 83 c2 08          	add    $0x8,%rdx
  80018e:	48 89 c6             	mov    %rax,%rsi
  800191:	48 89 d7             	mov    %rdx,%rdi
  800194:	48 b8 e8 15 80 00 00 	movabs $0x8015e8,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax
        b->idx = 0;
  8001a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ae:	8b 40 04             	mov    0x4(%rax),%eax
  8001b1:	8d 50 01             	lea    0x1(%rax),%edx
  8001b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b8:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001bb:	90                   	nop
  8001bc:	c9                   	leaveq 
  8001bd:	c3                   	retq   

00000000008001be <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001be:	55                   	push   %rbp
  8001bf:	48 89 e5             	mov    %rsp,%rbp
  8001c2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001c9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001d0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001d7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001de:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001e5:	48 8b 0a             	mov    (%rdx),%rcx
  8001e8:	48 89 08             	mov    %rcx,(%rax)
  8001eb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001ef:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001f3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001f7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800202:	00 00 00 
    b.cnt = 0;
  800205:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80020c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80020f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800216:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80021d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800224:	48 89 c6             	mov    %rax,%rsi
  800227:	48 bf 44 01 80 00 00 	movabs $0x800144,%rdi
  80022e:	00 00 00 
  800231:	48 b8 08 06 80 00 00 	movabs $0x800608,%rax
  800238:	00 00 00 
  80023b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80023d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800243:	48 98                	cltq   
  800245:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80024c:	48 83 c2 08          	add    $0x8,%rdx
  800250:	48 89 c6             	mov    %rax,%rsi
  800253:	48 89 d7             	mov    %rdx,%rdi
  800256:	48 b8 e8 15 80 00 00 	movabs $0x8015e8,%rax
  80025d:	00 00 00 
  800260:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800262:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800268:	c9                   	leaveq 
  800269:	c3                   	retq   

000000000080026a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80026a:	55                   	push   %rbp
  80026b:	48 89 e5             	mov    %rsp,%rbp
  80026e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800275:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80027c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800283:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80028a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800291:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800298:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80029f:	84 c0                	test   %al,%al
  8002a1:	74 20                	je     8002c3 <cprintf+0x59>
  8002a3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002a7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002ab:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002af:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002b3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002b7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002bb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002bf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002c3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002ca:	00 00 00 
  8002cd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002d4:	00 00 00 
  8002d7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002db:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002e2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002e9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002f0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002f7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002fe:	48 8b 0a             	mov    (%rdx),%rcx
  800301:	48 89 08             	mov    %rcx,(%rax)
  800304:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800308:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80030c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800310:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800314:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80031b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800322:	48 89 d6             	mov    %rdx,%rsi
  800325:	48 89 c7             	mov    %rax,%rdi
  800328:	48 b8 be 01 80 00 00 	movabs $0x8001be,%rax
  80032f:	00 00 00 
  800332:	ff d0                	callq  *%rax
  800334:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80033a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800340:	c9                   	leaveq 
  800341:	c3                   	retq   

0000000000800342 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800342:	55                   	push   %rbp
  800343:	48 89 e5             	mov    %rsp,%rbp
  800346:	48 83 ec 30          	sub    $0x30,%rsp
  80034a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80034e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800352:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800356:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800359:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80035d:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800361:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800364:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800368:	77 54                	ja     8003be <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036a:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80036d:	8d 78 ff             	lea    -0x1(%rax),%edi
  800370:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800373:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800377:	ba 00 00 00 00       	mov    $0x0,%edx
  80037c:	48 f7 f6             	div    %rsi
  80037f:	49 89 c2             	mov    %rax,%r10
  800382:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800385:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800388:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80038c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800390:	41 89 c9             	mov    %ecx,%r9d
  800393:	41 89 f8             	mov    %edi,%r8d
  800396:	89 d1                	mov    %edx,%ecx
  800398:	4c 89 d2             	mov    %r10,%rdx
  80039b:	48 89 c7             	mov    %rax,%rdi
  80039e:	48 b8 42 03 80 00 00 	movabs $0x800342,%rax
  8003a5:	00 00 00 
  8003a8:	ff d0                	callq  *%rax
  8003aa:	eb 1c                	jmp    8003c8 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003ac:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8003b0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8003b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003b7:	48 89 ce             	mov    %rcx,%rsi
  8003ba:	89 d7                	mov    %edx,%edi
  8003bc:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003be:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8003c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003c6:	7f e4                	jg     8003ac <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8003cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d4:	48 f7 f1             	div    %rcx
  8003d7:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  8003de:	00 00 00 
  8003e1:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8003e5:	0f be d0             	movsbl %al,%edx
  8003e8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8003ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f0:	48 89 ce             	mov    %rcx,%rsi
  8003f3:	89 d7                	mov    %edx,%edi
  8003f5:	ff d0                	callq  *%rax
}
  8003f7:	90                   	nop
  8003f8:	c9                   	leaveq 
  8003f9:	c3                   	retq   

00000000008003fa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003fa:	55                   	push   %rbp
  8003fb:	48 89 e5             	mov    %rsp,%rbp
  8003fe:	48 83 ec 20          	sub    $0x20,%rsp
  800402:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800406:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800409:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80040d:	7e 4f                	jle    80045e <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80040f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800413:	8b 00                	mov    (%rax),%eax
  800415:	83 f8 30             	cmp    $0x30,%eax
  800418:	73 24                	jae    80043e <getuint+0x44>
  80041a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800422:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800426:	8b 00                	mov    (%rax),%eax
  800428:	89 c0                	mov    %eax,%eax
  80042a:	48 01 d0             	add    %rdx,%rax
  80042d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800431:	8b 12                	mov    (%rdx),%edx
  800433:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800436:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80043a:	89 0a                	mov    %ecx,(%rdx)
  80043c:	eb 14                	jmp    800452 <getuint+0x58>
  80043e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800442:	48 8b 40 08          	mov    0x8(%rax),%rax
  800446:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80044a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80044e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800452:	48 8b 00             	mov    (%rax),%rax
  800455:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800459:	e9 9d 00 00 00       	jmpq   8004fb <getuint+0x101>
	else if (lflag)
  80045e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800462:	74 4c                	je     8004b0 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800468:	8b 00                	mov    (%rax),%eax
  80046a:	83 f8 30             	cmp    $0x30,%eax
  80046d:	73 24                	jae    800493 <getuint+0x99>
  80046f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800473:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800477:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047b:	8b 00                	mov    (%rax),%eax
  80047d:	89 c0                	mov    %eax,%eax
  80047f:	48 01 d0             	add    %rdx,%rax
  800482:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800486:	8b 12                	mov    (%rdx),%edx
  800488:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80048b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80048f:	89 0a                	mov    %ecx,(%rdx)
  800491:	eb 14                	jmp    8004a7 <getuint+0xad>
  800493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800497:	48 8b 40 08          	mov    0x8(%rax),%rax
  80049b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80049f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004a7:	48 8b 00             	mov    (%rax),%rax
  8004aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004ae:	eb 4b                	jmp    8004fb <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8004b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b4:	8b 00                	mov    (%rax),%eax
  8004b6:	83 f8 30             	cmp    $0x30,%eax
  8004b9:	73 24                	jae    8004df <getuint+0xe5>
  8004bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c7:	8b 00                	mov    (%rax),%eax
  8004c9:	89 c0                	mov    %eax,%eax
  8004cb:	48 01 d0             	add    %rdx,%rax
  8004ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d2:	8b 12                	mov    (%rdx),%edx
  8004d4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004db:	89 0a                	mov    %ecx,(%rdx)
  8004dd:	eb 14                	jmp    8004f3 <getuint+0xf9>
  8004df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004e7:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8004eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ef:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004f3:	8b 00                	mov    (%rax),%eax
  8004f5:	89 c0                	mov    %eax,%eax
  8004f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004ff:	c9                   	leaveq 
  800500:	c3                   	retq   

0000000000800501 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800501:	55                   	push   %rbp
  800502:	48 89 e5             	mov    %rsp,%rbp
  800505:	48 83 ec 20          	sub    $0x20,%rsp
  800509:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80050d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800510:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800514:	7e 4f                	jle    800565 <getint+0x64>
		x=va_arg(*ap, long long);
  800516:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051a:	8b 00                	mov    (%rax),%eax
  80051c:	83 f8 30             	cmp    $0x30,%eax
  80051f:	73 24                	jae    800545 <getint+0x44>
  800521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800525:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800529:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052d:	8b 00                	mov    (%rax),%eax
  80052f:	89 c0                	mov    %eax,%eax
  800531:	48 01 d0             	add    %rdx,%rax
  800534:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800538:	8b 12                	mov    (%rdx),%edx
  80053a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80053d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800541:	89 0a                	mov    %ecx,(%rdx)
  800543:	eb 14                	jmp    800559 <getint+0x58>
  800545:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800549:	48 8b 40 08          	mov    0x8(%rax),%rax
  80054d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800551:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800555:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800559:	48 8b 00             	mov    (%rax),%rax
  80055c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800560:	e9 9d 00 00 00       	jmpq   800602 <getint+0x101>
	else if (lflag)
  800565:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800569:	74 4c                	je     8005b7 <getint+0xb6>
		x=va_arg(*ap, long);
  80056b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056f:	8b 00                	mov    (%rax),%eax
  800571:	83 f8 30             	cmp    $0x30,%eax
  800574:	73 24                	jae    80059a <getint+0x99>
  800576:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80057e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800582:	8b 00                	mov    (%rax),%eax
  800584:	89 c0                	mov    %eax,%eax
  800586:	48 01 d0             	add    %rdx,%rax
  800589:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058d:	8b 12                	mov    (%rdx),%edx
  80058f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800592:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800596:	89 0a                	mov    %ecx,(%rdx)
  800598:	eb 14                	jmp    8005ae <getint+0xad>
  80059a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059e:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005a2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005aa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005ae:	48 8b 00             	mov    (%rax),%rax
  8005b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005b5:	eb 4b                	jmp    800602 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8005b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bb:	8b 00                	mov    (%rax),%eax
  8005bd:	83 f8 30             	cmp    $0x30,%eax
  8005c0:	73 24                	jae    8005e6 <getint+0xe5>
  8005c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ce:	8b 00                	mov    (%rax),%eax
  8005d0:	89 c0                	mov    %eax,%eax
  8005d2:	48 01 d0             	add    %rdx,%rax
  8005d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d9:	8b 12                	mov    (%rdx),%edx
  8005db:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e2:	89 0a                	mov    %ecx,(%rdx)
  8005e4:	eb 14                	jmp    8005fa <getint+0xf9>
  8005e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ea:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005ee:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005fa:	8b 00                	mov    (%rax),%eax
  8005fc:	48 98                	cltq   
  8005fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800602:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800606:	c9                   	leaveq 
  800607:	c3                   	retq   

0000000000800608 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800608:	55                   	push   %rbp
  800609:	48 89 e5             	mov    %rsp,%rbp
  80060c:	41 54                	push   %r12
  80060e:	53                   	push   %rbx
  80060f:	48 83 ec 60          	sub    $0x60,%rsp
  800613:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800617:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80061b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80061f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800623:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800627:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80062b:	48 8b 0a             	mov    (%rdx),%rcx
  80062e:	48 89 08             	mov    %rcx,(%rax)
  800631:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800635:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800639:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80063d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800641:	eb 17                	jmp    80065a <vprintfmt+0x52>
			if (ch == '\0')
  800643:	85 db                	test   %ebx,%ebx
  800645:	0f 84 b9 04 00 00    	je     800b04 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80064b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80064f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800653:	48 89 d6             	mov    %rdx,%rsi
  800656:	89 df                	mov    %ebx,%edi
  800658:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80065e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800662:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800666:	0f b6 00             	movzbl (%rax),%eax
  800669:	0f b6 d8             	movzbl %al,%ebx
  80066c:	83 fb 25             	cmp    $0x25,%ebx
  80066f:	75 d2                	jne    800643 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800671:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800675:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80067c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800683:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80068a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800691:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800695:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800699:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80069d:	0f b6 00             	movzbl (%rax),%eax
  8006a0:	0f b6 d8             	movzbl %al,%ebx
  8006a3:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006a6:	83 f8 55             	cmp    $0x55,%eax
  8006a9:	0f 87 22 04 00 00    	ja     800ad1 <vprintfmt+0x4c9>
  8006af:	89 c0                	mov    %eax,%eax
  8006b1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006b8:	00 
  8006b9:	48 b8 38 1c 80 00 00 	movabs $0x801c38,%rax
  8006c0:	00 00 00 
  8006c3:	48 01 d0             	add    %rdx,%rax
  8006c6:	48 8b 00             	mov    (%rax),%rax
  8006c9:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006cb:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006cf:	eb c0                	jmp    800691 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006d1:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006d5:	eb ba                	jmp    800691 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006d7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006de:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006e1:	89 d0                	mov    %edx,%eax
  8006e3:	c1 e0 02             	shl    $0x2,%eax
  8006e6:	01 d0                	add    %edx,%eax
  8006e8:	01 c0                	add    %eax,%eax
  8006ea:	01 d8                	add    %ebx,%eax
  8006ec:	83 e8 30             	sub    $0x30,%eax
  8006ef:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006f2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006f6:	0f b6 00             	movzbl (%rax),%eax
  8006f9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006fc:	83 fb 2f             	cmp    $0x2f,%ebx
  8006ff:	7e 60                	jle    800761 <vprintfmt+0x159>
  800701:	83 fb 39             	cmp    $0x39,%ebx
  800704:	7f 5b                	jg     800761 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800706:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80070b:	eb d1                	jmp    8006de <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80070d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800710:	83 f8 30             	cmp    $0x30,%eax
  800713:	73 17                	jae    80072c <vprintfmt+0x124>
  800715:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800719:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80071c:	89 d2                	mov    %edx,%edx
  80071e:	48 01 d0             	add    %rdx,%rax
  800721:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800724:	83 c2 08             	add    $0x8,%edx
  800727:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80072a:	eb 0c                	jmp    800738 <vprintfmt+0x130>
  80072c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800730:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800734:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800738:	8b 00                	mov    (%rax),%eax
  80073a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80073d:	eb 23                	jmp    800762 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  80073f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800743:	0f 89 48 ff ff ff    	jns    800691 <vprintfmt+0x89>
				width = 0;
  800749:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800750:	e9 3c ff ff ff       	jmpq   800691 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800755:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80075c:	e9 30 ff ff ff       	jmpq   800691 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800761:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800762:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800766:	0f 89 25 ff ff ff    	jns    800691 <vprintfmt+0x89>
				width = precision, precision = -1;
  80076c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80076f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800772:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800779:	e9 13 ff ff ff       	jmpq   800691 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80077e:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800782:	e9 0a ff ff ff       	jmpq   800691 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800787:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80078a:	83 f8 30             	cmp    $0x30,%eax
  80078d:	73 17                	jae    8007a6 <vprintfmt+0x19e>
  80078f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800793:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800796:	89 d2                	mov    %edx,%edx
  800798:	48 01 d0             	add    %rdx,%rax
  80079b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80079e:	83 c2 08             	add    $0x8,%edx
  8007a1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007a4:	eb 0c                	jmp    8007b2 <vprintfmt+0x1aa>
  8007a6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8007aa:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8007ae:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007b2:	8b 10                	mov    (%rax),%edx
  8007b4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007b8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007bc:	48 89 ce             	mov    %rcx,%rsi
  8007bf:	89 d7                	mov    %edx,%edi
  8007c1:	ff d0                	callq  *%rax
			break;
  8007c3:	e9 37 03 00 00       	jmpq   800aff <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007cb:	83 f8 30             	cmp    $0x30,%eax
  8007ce:	73 17                	jae    8007e7 <vprintfmt+0x1df>
  8007d0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8007d4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007d7:	89 d2                	mov    %edx,%edx
  8007d9:	48 01 d0             	add    %rdx,%rax
  8007dc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007df:	83 c2 08             	add    $0x8,%edx
  8007e2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007e5:	eb 0c                	jmp    8007f3 <vprintfmt+0x1eb>
  8007e7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8007eb:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8007ef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007f3:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8007f5:	85 db                	test   %ebx,%ebx
  8007f7:	79 02                	jns    8007fb <vprintfmt+0x1f3>
				err = -err;
  8007f9:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007fb:	83 fb 15             	cmp    $0x15,%ebx
  8007fe:	7f 16                	jg     800816 <vprintfmt+0x20e>
  800800:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  800807:	00 00 00 
  80080a:	48 63 d3             	movslq %ebx,%rdx
  80080d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800811:	4d 85 e4             	test   %r12,%r12
  800814:	75 2e                	jne    800844 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800816:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80081a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80081e:	89 d9                	mov    %ebx,%ecx
  800820:	48 ba 21 1c 80 00 00 	movabs $0x801c21,%rdx
  800827:	00 00 00 
  80082a:	48 89 c7             	mov    %rax,%rdi
  80082d:	b8 00 00 00 00       	mov    $0x0,%eax
  800832:	49 b8 0e 0b 80 00 00 	movabs $0x800b0e,%r8
  800839:	00 00 00 
  80083c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80083f:	e9 bb 02 00 00       	jmpq   800aff <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800844:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800848:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80084c:	4c 89 e1             	mov    %r12,%rcx
  80084f:	48 ba 2a 1c 80 00 00 	movabs $0x801c2a,%rdx
  800856:	00 00 00 
  800859:	48 89 c7             	mov    %rax,%rdi
  80085c:	b8 00 00 00 00       	mov    $0x0,%eax
  800861:	49 b8 0e 0b 80 00 00 	movabs $0x800b0e,%r8
  800868:	00 00 00 
  80086b:	41 ff d0             	callq  *%r8
			break;
  80086e:	e9 8c 02 00 00       	jmpq   800aff <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800873:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800876:	83 f8 30             	cmp    $0x30,%eax
  800879:	73 17                	jae    800892 <vprintfmt+0x28a>
  80087b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80087f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800882:	89 d2                	mov    %edx,%edx
  800884:	48 01 d0             	add    %rdx,%rax
  800887:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80088a:	83 c2 08             	add    $0x8,%edx
  80088d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800890:	eb 0c                	jmp    80089e <vprintfmt+0x296>
  800892:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800896:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80089a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80089e:	4c 8b 20             	mov    (%rax),%r12
  8008a1:	4d 85 e4             	test   %r12,%r12
  8008a4:	75 0a                	jne    8008b0 <vprintfmt+0x2a8>
				p = "(null)";
  8008a6:	49 bc 2d 1c 80 00 00 	movabs $0x801c2d,%r12
  8008ad:	00 00 00 
			if (width > 0 && padc != '-')
  8008b0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008b4:	7e 78                	jle    80092e <vprintfmt+0x326>
  8008b6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008ba:	74 72                	je     80092e <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bc:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008bf:	48 98                	cltq   
  8008c1:	48 89 c6             	mov    %rax,%rsi
  8008c4:	4c 89 e7             	mov    %r12,%rdi
  8008c7:	48 b8 bc 0d 80 00 00 	movabs $0x800dbc,%rax
  8008ce:	00 00 00 
  8008d1:	ff d0                	callq  *%rax
  8008d3:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008d6:	eb 17                	jmp    8008ef <vprintfmt+0x2e7>
					putch(padc, putdat);
  8008d8:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008dc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008e0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008e4:	48 89 ce             	mov    %rcx,%rsi
  8008e7:	89 d7                	mov    %edx,%edi
  8008e9:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008eb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008f3:	7f e3                	jg     8008d8 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f5:	eb 37                	jmp    80092e <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8008fb:	74 1e                	je     80091b <vprintfmt+0x313>
  8008fd:	83 fb 1f             	cmp    $0x1f,%ebx
  800900:	7e 05                	jle    800907 <vprintfmt+0x2ff>
  800902:	83 fb 7e             	cmp    $0x7e,%ebx
  800905:	7e 14                	jle    80091b <vprintfmt+0x313>
					putch('?', putdat);
  800907:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80090b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80090f:	48 89 d6             	mov    %rdx,%rsi
  800912:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800917:	ff d0                	callq  *%rax
  800919:	eb 0f                	jmp    80092a <vprintfmt+0x322>
				else
					putch(ch, putdat);
  80091b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80091f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800923:	48 89 d6             	mov    %rdx,%rsi
  800926:	89 df                	mov    %ebx,%edi
  800928:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80092e:	4c 89 e0             	mov    %r12,%rax
  800931:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800935:	0f b6 00             	movzbl (%rax),%eax
  800938:	0f be d8             	movsbl %al,%ebx
  80093b:	85 db                	test   %ebx,%ebx
  80093d:	74 28                	je     800967 <vprintfmt+0x35f>
  80093f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800943:	78 b2                	js     8008f7 <vprintfmt+0x2ef>
  800945:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800949:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80094d:	79 a8                	jns    8008f7 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094f:	eb 16                	jmp    800967 <vprintfmt+0x35f>
				putch(' ', putdat);
  800951:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800955:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800959:	48 89 d6             	mov    %rdx,%rsi
  80095c:	bf 20 00 00 00       	mov    $0x20,%edi
  800961:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800963:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800967:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80096b:	7f e4                	jg     800951 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  80096d:	e9 8d 01 00 00       	jmpq   800aff <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800972:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800976:	be 03 00 00 00       	mov    $0x3,%esi
  80097b:	48 89 c7             	mov    %rax,%rdi
  80097e:	48 b8 01 05 80 00 00 	movabs $0x800501,%rax
  800985:	00 00 00 
  800988:	ff d0                	callq  *%rax
  80098a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80098e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800992:	48 85 c0             	test   %rax,%rax
  800995:	79 1d                	jns    8009b4 <vprintfmt+0x3ac>
				putch('-', putdat);
  800997:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80099b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80099f:	48 89 d6             	mov    %rdx,%rsi
  8009a2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009a7:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ad:	48 f7 d8             	neg    %rax
  8009b0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009b4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009bb:	e9 d2 00 00 00       	jmpq   800a92 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009c0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009c4:	be 03 00 00 00       	mov    $0x3,%esi
  8009c9:	48 89 c7             	mov    %rax,%rdi
  8009cc:	48 b8 fa 03 80 00 00 	movabs $0x8003fa,%rax
  8009d3:	00 00 00 
  8009d6:	ff d0                	callq  *%rax
  8009d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009dc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009e3:	e9 aa 00 00 00       	jmpq   800a92 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  8009e8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009ec:	be 03 00 00 00       	mov    $0x3,%esi
  8009f1:	48 89 c7             	mov    %rax,%rdi
  8009f4:	48 b8 fa 03 80 00 00 	movabs $0x8003fa,%rax
  8009fb:	00 00 00 
  8009fe:	ff d0                	callq  *%rax
  800a00:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a04:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a0b:	e9 82 00 00 00       	jmpq   800a92 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800a10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a18:	48 89 d6             	mov    %rdx,%rsi
  800a1b:	bf 30 00 00 00       	mov    $0x30,%edi
  800a20:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2a:	48 89 d6             	mov    %rdx,%rsi
  800a2d:	bf 78 00 00 00       	mov    $0x78,%edi
  800a32:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a34:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a37:	83 f8 30             	cmp    $0x30,%eax
  800a3a:	73 17                	jae    800a53 <vprintfmt+0x44b>
  800a3c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a40:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a43:	89 d2                	mov    %edx,%edx
  800a45:	48 01 d0             	add    %rdx,%rax
  800a48:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a4b:	83 c2 08             	add    $0x8,%edx
  800a4e:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a51:	eb 0c                	jmp    800a5f <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800a53:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a57:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a5b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a5f:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a62:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a66:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a6d:	eb 23                	jmp    800a92 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a6f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a73:	be 03 00 00 00       	mov    $0x3,%esi
  800a78:	48 89 c7             	mov    %rax,%rdi
  800a7b:	48 b8 fa 03 80 00 00 	movabs $0x8003fa,%rax
  800a82:	00 00 00 
  800a85:	ff d0                	callq  *%rax
  800a87:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800a8b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a92:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800a97:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800a9a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800a9d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aa5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa9:	45 89 c1             	mov    %r8d,%r9d
  800aac:	41 89 f8             	mov    %edi,%r8d
  800aaf:	48 89 c7             	mov    %rax,%rdi
  800ab2:	48 b8 42 03 80 00 00 	movabs $0x800342,%rax
  800ab9:	00 00 00 
  800abc:	ff d0                	callq  *%rax
			break;
  800abe:	eb 3f                	jmp    800aff <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ac4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac8:	48 89 d6             	mov    %rdx,%rsi
  800acb:	89 df                	mov    %ebx,%edi
  800acd:	ff d0                	callq  *%rax
			break;
  800acf:	eb 2e                	jmp    800aff <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ad1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad9:	48 89 d6             	mov    %rdx,%rsi
  800adc:	bf 25 00 00 00       	mov    $0x25,%edi
  800ae1:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ae8:	eb 05                	jmp    800aef <vprintfmt+0x4e7>
  800aea:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800aef:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800af3:	48 83 e8 01          	sub    $0x1,%rax
  800af7:	0f b6 00             	movzbl (%rax),%eax
  800afa:	3c 25                	cmp    $0x25,%al
  800afc:	75 ec                	jne    800aea <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800afe:	90                   	nop
		}
	}
  800aff:	e9 3d fb ff ff       	jmpq   800641 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b04:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b05:	48 83 c4 60          	add    $0x60,%rsp
  800b09:	5b                   	pop    %rbx
  800b0a:	41 5c                	pop    %r12
  800b0c:	5d                   	pop    %rbp
  800b0d:	c3                   	retq   

0000000000800b0e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b0e:	55                   	push   %rbp
  800b0f:	48 89 e5             	mov    %rsp,%rbp
  800b12:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b19:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b20:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b27:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800b2e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b35:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b3c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b43:	84 c0                	test   %al,%al
  800b45:	74 20                	je     800b67 <printfmt+0x59>
  800b47:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b4b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b4f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b53:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b57:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b5b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b5f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b63:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b67:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b6e:	00 00 00 
  800b71:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b78:	00 00 00 
  800b7b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b7f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800b86:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b8d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800b94:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800b9b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ba2:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ba9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bb0:	48 89 c7             	mov    %rax,%rdi
  800bb3:	48 b8 08 06 80 00 00 	movabs $0x800608,%rax
  800bba:	00 00 00 
  800bbd:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bbf:	90                   	nop
  800bc0:	c9                   	leaveq 
  800bc1:	c3                   	retq   

0000000000800bc2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bc2:	55                   	push   %rbp
  800bc3:	48 89 e5             	mov    %rsp,%rbp
  800bc6:	48 83 ec 10          	sub    $0x10,%rsp
  800bca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bcd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bd5:	8b 40 10             	mov    0x10(%rax),%eax
  800bd8:	8d 50 01             	lea    0x1(%rax),%edx
  800bdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bdf:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800be2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800be6:	48 8b 10             	mov    (%rax),%rdx
  800be9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bed:	48 8b 40 08          	mov    0x8(%rax),%rax
  800bf1:	48 39 c2             	cmp    %rax,%rdx
  800bf4:	73 17                	jae    800c0d <sprintputch+0x4b>
		*b->buf++ = ch;
  800bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bfa:	48 8b 00             	mov    (%rax),%rax
  800bfd:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c05:	48 89 0a             	mov    %rcx,(%rdx)
  800c08:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c0b:	88 10                	mov    %dl,(%rax)
}
  800c0d:	90                   	nop
  800c0e:	c9                   	leaveq 
  800c0f:	c3                   	retq   

0000000000800c10 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c10:	55                   	push   %rbp
  800c11:	48 89 e5             	mov    %rsp,%rbp
  800c14:	48 83 ec 50          	sub    $0x50,%rsp
  800c18:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c1c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c1f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c23:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c27:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c2b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c2f:	48 8b 0a             	mov    (%rdx),%rcx
  800c32:	48 89 08             	mov    %rcx,(%rax)
  800c35:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c39:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c3d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c41:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c45:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c49:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c4d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c50:	48 98                	cltq   
  800c52:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c56:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c5a:	48 01 d0             	add    %rdx,%rax
  800c5d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c61:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c68:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c6d:	74 06                	je     800c75 <vsnprintf+0x65>
  800c6f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c73:	7f 07                	jg     800c7c <vsnprintf+0x6c>
		return -E_INVAL;
  800c75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c7a:	eb 2f                	jmp    800cab <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c7c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c80:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800c84:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c88:	48 89 c6             	mov    %rax,%rsi
  800c8b:	48 bf c2 0b 80 00 00 	movabs $0x800bc2,%rdi
  800c92:	00 00 00 
  800c95:	48 b8 08 06 80 00 00 	movabs $0x800608,%rax
  800c9c:	00 00 00 
  800c9f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ca1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ca5:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ca8:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cab:	c9                   	leaveq 
  800cac:	c3                   	retq   

0000000000800cad <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cad:	55                   	push   %rbp
  800cae:	48 89 e5             	mov    %rsp,%rbp
  800cb1:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cb8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cbf:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cc5:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800ccc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cd3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cda:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ce1:	84 c0                	test   %al,%al
  800ce3:	74 20                	je     800d05 <snprintf+0x58>
  800ce5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ce9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ced:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cf1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cf5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cf9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cfd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d01:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d05:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d0c:	00 00 00 
  800d0f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d16:	00 00 00 
  800d19:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d1d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d24:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d2b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d32:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d39:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d40:	48 8b 0a             	mov    (%rdx),%rcx
  800d43:	48 89 08             	mov    %rcx,(%rax)
  800d46:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d4a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d4e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d52:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d56:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d5d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d64:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d6a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d71:	48 89 c7             	mov    %rax,%rdi
  800d74:	48 b8 10 0c 80 00 00 	movabs $0x800c10,%rax
  800d7b:	00 00 00 
  800d7e:	ff d0                	callq  *%rax
  800d80:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800d86:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800d8c:	c9                   	leaveq 
  800d8d:	c3                   	retq   

0000000000800d8e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d8e:	55                   	push   %rbp
  800d8f:	48 89 e5             	mov    %rsp,%rbp
  800d92:	48 83 ec 18          	sub    $0x18,%rsp
  800d96:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800d9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800da1:	eb 09                	jmp    800dac <strlen+0x1e>
		n++;
  800da3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800da7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db0:	0f b6 00             	movzbl (%rax),%eax
  800db3:	84 c0                	test   %al,%al
  800db5:	75 ec                	jne    800da3 <strlen+0x15>
		n++;
	return n;
  800db7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dba:	c9                   	leaveq 
  800dbb:	c3                   	retq   

0000000000800dbc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dbc:	55                   	push   %rbp
  800dbd:	48 89 e5             	mov    %rsp,%rbp
  800dc0:	48 83 ec 20          	sub    $0x20,%rsp
  800dc4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dc8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dd3:	eb 0e                	jmp    800de3 <strnlen+0x27>
		n++;
  800dd5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dde:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800de3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800de8:	74 0b                	je     800df5 <strnlen+0x39>
  800dea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dee:	0f b6 00             	movzbl (%rax),%eax
  800df1:	84 c0                	test   %al,%al
  800df3:	75 e0                	jne    800dd5 <strnlen+0x19>
		n++;
	return n;
  800df5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800df8:	c9                   	leaveq 
  800df9:	c3                   	retq   

0000000000800dfa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dfa:	55                   	push   %rbp
  800dfb:	48 89 e5             	mov    %rsp,%rbp
  800dfe:	48 83 ec 20          	sub    $0x20,%rsp
  800e02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e06:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e12:	90                   	nop
  800e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e17:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e1b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e1f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e23:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e27:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e2b:	0f b6 12             	movzbl (%rdx),%edx
  800e2e:	88 10                	mov    %dl,(%rax)
  800e30:	0f b6 00             	movzbl (%rax),%eax
  800e33:	84 c0                	test   %al,%al
  800e35:	75 dc                	jne    800e13 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e3b:	c9                   	leaveq 
  800e3c:	c3                   	retq   

0000000000800e3d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e3d:	55                   	push   %rbp
  800e3e:	48 89 e5             	mov    %rsp,%rbp
  800e41:	48 83 ec 20          	sub    $0x20,%rsp
  800e45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e51:	48 89 c7             	mov    %rax,%rdi
  800e54:	48 b8 8e 0d 80 00 00 	movabs $0x800d8e,%rax
  800e5b:	00 00 00 
  800e5e:	ff d0                	callq  *%rax
  800e60:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e66:	48 63 d0             	movslq %eax,%rdx
  800e69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6d:	48 01 c2             	add    %rax,%rdx
  800e70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e74:	48 89 c6             	mov    %rax,%rsi
  800e77:	48 89 d7             	mov    %rdx,%rdi
  800e7a:	48 b8 fa 0d 80 00 00 	movabs $0x800dfa,%rax
  800e81:	00 00 00 
  800e84:	ff d0                	callq  *%rax
	return dst;
  800e86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800e8a:	c9                   	leaveq 
  800e8b:	c3                   	retq   

0000000000800e8c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e8c:	55                   	push   %rbp
  800e8d:	48 89 e5             	mov    %rsp,%rbp
  800e90:	48 83 ec 28          	sub    $0x28,%rsp
  800e94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e9c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ea0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ea8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800eaf:	00 
  800eb0:	eb 2a                	jmp    800edc <strncpy+0x50>
		*dst++ = *src;
  800eb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800eba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ebe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ec2:	0f b6 12             	movzbl (%rdx),%edx
  800ec5:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ec7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ecb:	0f b6 00             	movzbl (%rax),%eax
  800ece:	84 c0                	test   %al,%al
  800ed0:	74 05                	je     800ed7 <strncpy+0x4b>
			src++;
  800ed2:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800edc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ee0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ee4:	72 cc                	jb     800eb2 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800eea:	c9                   	leaveq 
  800eeb:	c3                   	retq   

0000000000800eec <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800eec:	55                   	push   %rbp
  800eed:	48 89 e5             	mov    %rsp,%rbp
  800ef0:	48 83 ec 28          	sub    $0x28,%rsp
  800ef4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ef8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800efc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f04:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f08:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f0d:	74 3d                	je     800f4c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f0f:	eb 1d                	jmp    800f2e <strlcpy+0x42>
			*dst++ = *src++;
  800f11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f15:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f19:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f1d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f21:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f25:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f29:	0f b6 12             	movzbl (%rdx),%edx
  800f2c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f2e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f33:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f38:	74 0b                	je     800f45 <strlcpy+0x59>
  800f3a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f3e:	0f b6 00             	movzbl (%rax),%eax
  800f41:	84 c0                	test   %al,%al
  800f43:	75 cc                	jne    800f11 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f49:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f4c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f54:	48 29 c2             	sub    %rax,%rdx
  800f57:	48 89 d0             	mov    %rdx,%rax
}
  800f5a:	c9                   	leaveq 
  800f5b:	c3                   	retq   

0000000000800f5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f5c:	55                   	push   %rbp
  800f5d:	48 89 e5             	mov    %rsp,%rbp
  800f60:	48 83 ec 10          	sub    $0x10,%rsp
  800f64:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f68:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f6c:	eb 0a                	jmp    800f78 <strcmp+0x1c>
		p++, q++;
  800f6e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f73:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f7c:	0f b6 00             	movzbl (%rax),%eax
  800f7f:	84 c0                	test   %al,%al
  800f81:	74 12                	je     800f95 <strcmp+0x39>
  800f83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f87:	0f b6 10             	movzbl (%rax),%edx
  800f8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f8e:	0f b6 00             	movzbl (%rax),%eax
  800f91:	38 c2                	cmp    %al,%dl
  800f93:	74 d9                	je     800f6e <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f99:	0f b6 00             	movzbl (%rax),%eax
  800f9c:	0f b6 d0             	movzbl %al,%edx
  800f9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa3:	0f b6 00             	movzbl (%rax),%eax
  800fa6:	0f b6 c0             	movzbl %al,%eax
  800fa9:	29 c2                	sub    %eax,%edx
  800fab:	89 d0                	mov    %edx,%eax
}
  800fad:	c9                   	leaveq 
  800fae:	c3                   	retq   

0000000000800faf <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800faf:	55                   	push   %rbp
  800fb0:	48 89 e5             	mov    %rsp,%rbp
  800fb3:	48 83 ec 18          	sub    $0x18,%rsp
  800fb7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fbb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fbf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fc3:	eb 0f                	jmp    800fd4 <strncmp+0x25>
		n--, p++, q++;
  800fc5:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fca:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fcf:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800fd4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fd9:	74 1d                	je     800ff8 <strncmp+0x49>
  800fdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fdf:	0f b6 00             	movzbl (%rax),%eax
  800fe2:	84 c0                	test   %al,%al
  800fe4:	74 12                	je     800ff8 <strncmp+0x49>
  800fe6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fea:	0f b6 10             	movzbl (%rax),%edx
  800fed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff1:	0f b6 00             	movzbl (%rax),%eax
  800ff4:	38 c2                	cmp    %al,%dl
  800ff6:	74 cd                	je     800fc5 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  800ff8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800ffd:	75 07                	jne    801006 <strncmp+0x57>
		return 0;
  800fff:	b8 00 00 00 00       	mov    $0x0,%eax
  801004:	eb 18                	jmp    80101e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801006:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80100a:	0f b6 00             	movzbl (%rax),%eax
  80100d:	0f b6 d0             	movzbl %al,%edx
  801010:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801014:	0f b6 00             	movzbl (%rax),%eax
  801017:	0f b6 c0             	movzbl %al,%eax
  80101a:	29 c2                	sub    %eax,%edx
  80101c:	89 d0                	mov    %edx,%eax
}
  80101e:	c9                   	leaveq 
  80101f:	c3                   	retq   

0000000000801020 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801020:	55                   	push   %rbp
  801021:	48 89 e5             	mov    %rsp,%rbp
  801024:	48 83 ec 10          	sub    $0x10,%rsp
  801028:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80102c:	89 f0                	mov    %esi,%eax
  80102e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801031:	eb 17                	jmp    80104a <strchr+0x2a>
		if (*s == c)
  801033:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801037:	0f b6 00             	movzbl (%rax),%eax
  80103a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80103d:	75 06                	jne    801045 <strchr+0x25>
			return (char *) s;
  80103f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801043:	eb 15                	jmp    80105a <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801045:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80104a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104e:	0f b6 00             	movzbl (%rax),%eax
  801051:	84 c0                	test   %al,%al
  801053:	75 de                	jne    801033 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801055:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80105a:	c9                   	leaveq 
  80105b:	c3                   	retq   

000000000080105c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80105c:	55                   	push   %rbp
  80105d:	48 89 e5             	mov    %rsp,%rbp
  801060:	48 83 ec 10          	sub    $0x10,%rsp
  801064:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801068:	89 f0                	mov    %esi,%eax
  80106a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80106d:	eb 11                	jmp    801080 <strfind+0x24>
		if (*s == c)
  80106f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801073:	0f b6 00             	movzbl (%rax),%eax
  801076:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801079:	74 12                	je     80108d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80107b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801080:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801084:	0f b6 00             	movzbl (%rax),%eax
  801087:	84 c0                	test   %al,%al
  801089:	75 e4                	jne    80106f <strfind+0x13>
  80108b:	eb 01                	jmp    80108e <strfind+0x32>
		if (*s == c)
			break;
  80108d:	90                   	nop
	return (char *) s;
  80108e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801092:	c9                   	leaveq 
  801093:	c3                   	retq   

0000000000801094 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801094:	55                   	push   %rbp
  801095:	48 89 e5             	mov    %rsp,%rbp
  801098:	48 83 ec 18          	sub    $0x18,%rsp
  80109c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010a0:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010a3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010a7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010ac:	75 06                	jne    8010b4 <memset+0x20>
		return v;
  8010ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b2:	eb 69                	jmp    80111d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b8:	83 e0 03             	and    $0x3,%eax
  8010bb:	48 85 c0             	test   %rax,%rax
  8010be:	75 48                	jne    801108 <memset+0x74>
  8010c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c4:	83 e0 03             	and    $0x3,%eax
  8010c7:	48 85 c0             	test   %rax,%rax
  8010ca:	75 3c                	jne    801108 <memset+0x74>
		c &= 0xFF;
  8010cc:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010d6:	c1 e0 18             	shl    $0x18,%eax
  8010d9:	89 c2                	mov    %eax,%edx
  8010db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010de:	c1 e0 10             	shl    $0x10,%eax
  8010e1:	09 c2                	or     %eax,%edx
  8010e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010e6:	c1 e0 08             	shl    $0x8,%eax
  8010e9:	09 d0                	or     %edx,%eax
  8010eb:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8010ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f2:	48 c1 e8 02          	shr    $0x2,%rax
  8010f6:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8010f9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8010fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801100:	48 89 d7             	mov    %rdx,%rdi
  801103:	fc                   	cld    
  801104:	f3 ab                	rep stos %eax,%es:(%rdi)
  801106:	eb 11                	jmp    801119 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801108:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80110c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80110f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801113:	48 89 d7             	mov    %rdx,%rdi
  801116:	fc                   	cld    
  801117:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801119:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80111d:	c9                   	leaveq 
  80111e:	c3                   	retq   

000000000080111f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80111f:	55                   	push   %rbp
  801120:	48 89 e5             	mov    %rsp,%rbp
  801123:	48 83 ec 28          	sub    $0x28,%rsp
  801127:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80112b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80112f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801133:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801137:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80113b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801143:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801147:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80114b:	0f 83 88 00 00 00    	jae    8011d9 <memmove+0xba>
  801151:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801155:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801159:	48 01 d0             	add    %rdx,%rax
  80115c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801160:	76 77                	jbe    8011d9 <memmove+0xba>
		s += n;
  801162:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801166:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80116a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80116e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801172:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801176:	83 e0 03             	and    $0x3,%eax
  801179:	48 85 c0             	test   %rax,%rax
  80117c:	75 3b                	jne    8011b9 <memmove+0x9a>
  80117e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801182:	83 e0 03             	and    $0x3,%eax
  801185:	48 85 c0             	test   %rax,%rax
  801188:	75 2f                	jne    8011b9 <memmove+0x9a>
  80118a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80118e:	83 e0 03             	and    $0x3,%eax
  801191:	48 85 c0             	test   %rax,%rax
  801194:	75 23                	jne    8011b9 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801196:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119a:	48 83 e8 04          	sub    $0x4,%rax
  80119e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011a2:	48 83 ea 04          	sub    $0x4,%rdx
  8011a6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011aa:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011ae:	48 89 c7             	mov    %rax,%rdi
  8011b1:	48 89 d6             	mov    %rdx,%rsi
  8011b4:	fd                   	std    
  8011b5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011b7:	eb 1d                	jmp    8011d6 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011cd:	48 89 d7             	mov    %rdx,%rdi
  8011d0:	48 89 c1             	mov    %rax,%rcx
  8011d3:	fd                   	std    
  8011d4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011d6:	fc                   	cld    
  8011d7:	eb 57                	jmp    801230 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011dd:	83 e0 03             	and    $0x3,%eax
  8011e0:	48 85 c0             	test   %rax,%rax
  8011e3:	75 36                	jne    80121b <memmove+0xfc>
  8011e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e9:	83 e0 03             	and    $0x3,%eax
  8011ec:	48 85 c0             	test   %rax,%rax
  8011ef:	75 2a                	jne    80121b <memmove+0xfc>
  8011f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f5:	83 e0 03             	and    $0x3,%eax
  8011f8:	48 85 c0             	test   %rax,%rax
  8011fb:	75 1e                	jne    80121b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8011fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801201:	48 c1 e8 02          	shr    $0x2,%rax
  801205:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801208:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801210:	48 89 c7             	mov    %rax,%rdi
  801213:	48 89 d6             	mov    %rdx,%rsi
  801216:	fc                   	cld    
  801217:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801219:	eb 15                	jmp    801230 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80121b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801223:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801227:	48 89 c7             	mov    %rax,%rdi
  80122a:	48 89 d6             	mov    %rdx,%rsi
  80122d:	fc                   	cld    
  80122e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801234:	c9                   	leaveq 
  801235:	c3                   	retq   

0000000000801236 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801236:	55                   	push   %rbp
  801237:	48 89 e5             	mov    %rsp,%rbp
  80123a:	48 83 ec 18          	sub    $0x18,%rsp
  80123e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801242:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801246:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80124a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80124e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801252:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801256:	48 89 ce             	mov    %rcx,%rsi
  801259:	48 89 c7             	mov    %rax,%rdi
  80125c:	48 b8 1f 11 80 00 00 	movabs $0x80111f,%rax
  801263:	00 00 00 
  801266:	ff d0                	callq  *%rax
}
  801268:	c9                   	leaveq 
  801269:	c3                   	retq   

000000000080126a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80126a:	55                   	push   %rbp
  80126b:	48 89 e5             	mov    %rsp,%rbp
  80126e:	48 83 ec 28          	sub    $0x28,%rsp
  801272:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801276:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80127a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80127e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801282:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801286:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80128a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80128e:	eb 36                	jmp    8012c6 <memcmp+0x5c>
		if (*s1 != *s2)
  801290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801294:	0f b6 10             	movzbl (%rax),%edx
  801297:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129b:	0f b6 00             	movzbl (%rax),%eax
  80129e:	38 c2                	cmp    %al,%dl
  8012a0:	74 1a                	je     8012bc <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a6:	0f b6 00             	movzbl (%rax),%eax
  8012a9:	0f b6 d0             	movzbl %al,%edx
  8012ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b0:	0f b6 00             	movzbl (%rax),%eax
  8012b3:	0f b6 c0             	movzbl %al,%eax
  8012b6:	29 c2                	sub    %eax,%edx
  8012b8:	89 d0                	mov    %edx,%eax
  8012ba:	eb 20                	jmp    8012dc <memcmp+0x72>
		s1++, s2++;
  8012bc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ca:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012d2:	48 85 c0             	test   %rax,%rax
  8012d5:	75 b9                	jne    801290 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012dc:	c9                   	leaveq 
  8012dd:	c3                   	retq   

00000000008012de <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012de:	55                   	push   %rbp
  8012df:	48 89 e5             	mov    %rsp,%rbp
  8012e2:	48 83 ec 28          	sub    $0x28,%rsp
  8012e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ea:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012ed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8012f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f9:	48 01 d0             	add    %rdx,%rax
  8012fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801300:	eb 19                	jmp    80131b <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801302:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801306:	0f b6 00             	movzbl (%rax),%eax
  801309:	0f b6 d0             	movzbl %al,%edx
  80130c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80130f:	0f b6 c0             	movzbl %al,%eax
  801312:	39 c2                	cmp    %eax,%edx
  801314:	74 11                	je     801327 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801316:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80131b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801323:	72 dd                	jb     801302 <memfind+0x24>
  801325:	eb 01                	jmp    801328 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801327:	90                   	nop
	return (void *) s;
  801328:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80132c:	c9                   	leaveq 
  80132d:	c3                   	retq   

000000000080132e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80132e:	55                   	push   %rbp
  80132f:	48 89 e5             	mov    %rsp,%rbp
  801332:	48 83 ec 38          	sub    $0x38,%rsp
  801336:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80133a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80133e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801341:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801348:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80134f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801350:	eb 05                	jmp    801357 <strtol+0x29>
		s++;
  801352:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801357:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135b:	0f b6 00             	movzbl (%rax),%eax
  80135e:	3c 20                	cmp    $0x20,%al
  801360:	74 f0                	je     801352 <strtol+0x24>
  801362:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801366:	0f b6 00             	movzbl (%rax),%eax
  801369:	3c 09                	cmp    $0x9,%al
  80136b:	74 e5                	je     801352 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80136d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801371:	0f b6 00             	movzbl (%rax),%eax
  801374:	3c 2b                	cmp    $0x2b,%al
  801376:	75 07                	jne    80137f <strtol+0x51>
		s++;
  801378:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80137d:	eb 17                	jmp    801396 <strtol+0x68>
	else if (*s == '-')
  80137f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801383:	0f b6 00             	movzbl (%rax),%eax
  801386:	3c 2d                	cmp    $0x2d,%al
  801388:	75 0c                	jne    801396 <strtol+0x68>
		s++, neg = 1;
  80138a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80138f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801396:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80139a:	74 06                	je     8013a2 <strtol+0x74>
  80139c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013a0:	75 28                	jne    8013ca <strtol+0x9c>
  8013a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a6:	0f b6 00             	movzbl (%rax),%eax
  8013a9:	3c 30                	cmp    $0x30,%al
  8013ab:	75 1d                	jne    8013ca <strtol+0x9c>
  8013ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b1:	48 83 c0 01          	add    $0x1,%rax
  8013b5:	0f b6 00             	movzbl (%rax),%eax
  8013b8:	3c 78                	cmp    $0x78,%al
  8013ba:	75 0e                	jne    8013ca <strtol+0x9c>
		s += 2, base = 16;
  8013bc:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013c1:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013c8:	eb 2c                	jmp    8013f6 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013ca:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013ce:	75 19                	jne    8013e9 <strtol+0xbb>
  8013d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d4:	0f b6 00             	movzbl (%rax),%eax
  8013d7:	3c 30                	cmp    $0x30,%al
  8013d9:	75 0e                	jne    8013e9 <strtol+0xbb>
		s++, base = 8;
  8013db:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013e0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013e7:	eb 0d                	jmp    8013f6 <strtol+0xc8>
	else if (base == 0)
  8013e9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013ed:	75 07                	jne    8013f6 <strtol+0xc8>
		base = 10;
  8013ef:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fa:	0f b6 00             	movzbl (%rax),%eax
  8013fd:	3c 2f                	cmp    $0x2f,%al
  8013ff:	7e 1d                	jle    80141e <strtol+0xf0>
  801401:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801405:	0f b6 00             	movzbl (%rax),%eax
  801408:	3c 39                	cmp    $0x39,%al
  80140a:	7f 12                	jg     80141e <strtol+0xf0>
			dig = *s - '0';
  80140c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801410:	0f b6 00             	movzbl (%rax),%eax
  801413:	0f be c0             	movsbl %al,%eax
  801416:	83 e8 30             	sub    $0x30,%eax
  801419:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80141c:	eb 4e                	jmp    80146c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80141e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801422:	0f b6 00             	movzbl (%rax),%eax
  801425:	3c 60                	cmp    $0x60,%al
  801427:	7e 1d                	jle    801446 <strtol+0x118>
  801429:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142d:	0f b6 00             	movzbl (%rax),%eax
  801430:	3c 7a                	cmp    $0x7a,%al
  801432:	7f 12                	jg     801446 <strtol+0x118>
			dig = *s - 'a' + 10;
  801434:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801438:	0f b6 00             	movzbl (%rax),%eax
  80143b:	0f be c0             	movsbl %al,%eax
  80143e:	83 e8 57             	sub    $0x57,%eax
  801441:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801444:	eb 26                	jmp    80146c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801446:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144a:	0f b6 00             	movzbl (%rax),%eax
  80144d:	3c 40                	cmp    $0x40,%al
  80144f:	7e 47                	jle    801498 <strtol+0x16a>
  801451:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801455:	0f b6 00             	movzbl (%rax),%eax
  801458:	3c 5a                	cmp    $0x5a,%al
  80145a:	7f 3c                	jg     801498 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80145c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801460:	0f b6 00             	movzbl (%rax),%eax
  801463:	0f be c0             	movsbl %al,%eax
  801466:	83 e8 37             	sub    $0x37,%eax
  801469:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80146c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80146f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801472:	7d 23                	jge    801497 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801474:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801479:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80147c:	48 98                	cltq   
  80147e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801483:	48 89 c2             	mov    %rax,%rdx
  801486:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801489:	48 98                	cltq   
  80148b:	48 01 d0             	add    %rdx,%rax
  80148e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801492:	e9 5f ff ff ff       	jmpq   8013f6 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801497:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801498:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80149d:	74 0b                	je     8014aa <strtol+0x17c>
		*endptr = (char *) s;
  80149f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014a3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014a7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014ae:	74 09                	je     8014b9 <strtol+0x18b>
  8014b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b4:	48 f7 d8             	neg    %rax
  8014b7:	eb 04                	jmp    8014bd <strtol+0x18f>
  8014b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014bd:	c9                   	leaveq 
  8014be:	c3                   	retq   

00000000008014bf <strstr>:

char * strstr(const char *in, const char *str)
{
  8014bf:	55                   	push   %rbp
  8014c0:	48 89 e5             	mov    %rsp,%rbp
  8014c3:	48 83 ec 30          	sub    $0x30,%rsp
  8014c7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014d3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014d7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014db:	0f b6 00             	movzbl (%rax),%eax
  8014de:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014e1:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014e5:	75 06                	jne    8014ed <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8014e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014eb:	eb 6b                	jmp    801558 <strstr+0x99>

	len = strlen(str);
  8014ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014f1:	48 89 c7             	mov    %rax,%rdi
  8014f4:	48 b8 8e 0d 80 00 00 	movabs $0x800d8e,%rax
  8014fb:	00 00 00 
  8014fe:	ff d0                	callq  *%rax
  801500:	48 98                	cltq   
  801502:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801506:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80150e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801512:	0f b6 00             	movzbl (%rax),%eax
  801515:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801518:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80151c:	75 07                	jne    801525 <strstr+0x66>
				return (char *) 0;
  80151e:	b8 00 00 00 00       	mov    $0x0,%eax
  801523:	eb 33                	jmp    801558 <strstr+0x99>
		} while (sc != c);
  801525:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801529:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80152c:	75 d8                	jne    801506 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80152e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801532:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801536:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153a:	48 89 ce             	mov    %rcx,%rsi
  80153d:	48 89 c7             	mov    %rax,%rdi
  801540:	48 b8 af 0f 80 00 00 	movabs $0x800faf,%rax
  801547:	00 00 00 
  80154a:	ff d0                	callq  *%rax
  80154c:	85 c0                	test   %eax,%eax
  80154e:	75 b6                	jne    801506 <strstr+0x47>

	return (char *) (in - 1);
  801550:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801554:	48 83 e8 01          	sub    $0x1,%rax
}
  801558:	c9                   	leaveq 
  801559:	c3                   	retq   

000000000080155a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80155a:	55                   	push   %rbp
  80155b:	48 89 e5             	mov    %rsp,%rbp
  80155e:	53                   	push   %rbx
  80155f:	48 83 ec 48          	sub    $0x48,%rsp
  801563:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801566:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801569:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80156d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801571:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801575:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801579:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80157c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801580:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801584:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801588:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80158c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801590:	4c 89 c3             	mov    %r8,%rbx
  801593:	cd 30                	int    $0x30
  801595:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801599:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80159d:	74 3e                	je     8015dd <syscall+0x83>
  80159f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015a4:	7e 37                	jle    8015dd <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015aa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015ad:	49 89 d0             	mov    %rdx,%r8
  8015b0:	89 c1                	mov    %eax,%ecx
  8015b2:	48 ba e8 1e 80 00 00 	movabs $0x801ee8,%rdx
  8015b9:	00 00 00 
  8015bc:	be 23 00 00 00       	mov    $0x23,%esi
  8015c1:	48 bf 05 1f 80 00 00 	movabs $0x801f05,%rdi
  8015c8:	00 00 00 
  8015cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d0:	49 b9 64 19 80 00 00 	movabs $0x801964,%r9
  8015d7:	00 00 00 
  8015da:	41 ff d1             	callq  *%r9

	return ret;
  8015dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015e1:	48 83 c4 48          	add    $0x48,%rsp
  8015e5:	5b                   	pop    %rbx
  8015e6:	5d                   	pop    %rbp
  8015e7:	c3                   	retq   

00000000008015e8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8015e8:	55                   	push   %rbp
  8015e9:	48 89 e5             	mov    %rsp,%rbp
  8015ec:	48 83 ec 10          	sub    $0x10,%rsp
  8015f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8015f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801600:	48 83 ec 08          	sub    $0x8,%rsp
  801604:	6a 00                	pushq  $0x0
  801606:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80160c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801612:	48 89 d1             	mov    %rdx,%rcx
  801615:	48 89 c2             	mov    %rax,%rdx
  801618:	be 00 00 00 00       	mov    $0x0,%esi
  80161d:	bf 00 00 00 00       	mov    $0x0,%edi
  801622:	48 b8 5a 15 80 00 00 	movabs $0x80155a,%rax
  801629:	00 00 00 
  80162c:	ff d0                	callq  *%rax
  80162e:	48 83 c4 10          	add    $0x10,%rsp
}
  801632:	90                   	nop
  801633:	c9                   	leaveq 
  801634:	c3                   	retq   

0000000000801635 <sys_cgetc>:

int
sys_cgetc(void)
{
  801635:	55                   	push   %rbp
  801636:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801639:	48 83 ec 08          	sub    $0x8,%rsp
  80163d:	6a 00                	pushq  $0x0
  80163f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801645:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80164b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801650:	ba 00 00 00 00       	mov    $0x0,%edx
  801655:	be 00 00 00 00       	mov    $0x0,%esi
  80165a:	bf 01 00 00 00       	mov    $0x1,%edi
  80165f:	48 b8 5a 15 80 00 00 	movabs $0x80155a,%rax
  801666:	00 00 00 
  801669:	ff d0                	callq  *%rax
  80166b:	48 83 c4 10          	add    $0x10,%rsp
}
  80166f:	c9                   	leaveq 
  801670:	c3                   	retq   

0000000000801671 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801671:	55                   	push   %rbp
  801672:	48 89 e5             	mov    %rsp,%rbp
  801675:	48 83 ec 10          	sub    $0x10,%rsp
  801679:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80167c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80167f:	48 98                	cltq   
  801681:	48 83 ec 08          	sub    $0x8,%rsp
  801685:	6a 00                	pushq  $0x0
  801687:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80168d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801693:	b9 00 00 00 00       	mov    $0x0,%ecx
  801698:	48 89 c2             	mov    %rax,%rdx
  80169b:	be 01 00 00 00       	mov    $0x1,%esi
  8016a0:	bf 03 00 00 00       	mov    $0x3,%edi
  8016a5:	48 b8 5a 15 80 00 00 	movabs $0x80155a,%rax
  8016ac:	00 00 00 
  8016af:	ff d0                	callq  *%rax
  8016b1:	48 83 c4 10          	add    $0x10,%rsp
}
  8016b5:	c9                   	leaveq 
  8016b6:	c3                   	retq   

00000000008016b7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016b7:	55                   	push   %rbp
  8016b8:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016bb:	48 83 ec 08          	sub    $0x8,%rsp
  8016bf:	6a 00                	pushq  $0x0
  8016c1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d7:	be 00 00 00 00       	mov    $0x0,%esi
  8016dc:	bf 02 00 00 00       	mov    $0x2,%edi
  8016e1:	48 b8 5a 15 80 00 00 	movabs $0x80155a,%rax
  8016e8:	00 00 00 
  8016eb:	ff d0                	callq  *%rax
  8016ed:	48 83 c4 10          	add    $0x10,%rsp
}
  8016f1:	c9                   	leaveq 
  8016f2:	c3                   	retq   

00000000008016f3 <sys_yield>:

void
sys_yield(void)
{
  8016f3:	55                   	push   %rbp
  8016f4:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8016f7:	48 83 ec 08          	sub    $0x8,%rsp
  8016fb:	6a 00                	pushq  $0x0
  8016fd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801703:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801709:	b9 00 00 00 00       	mov    $0x0,%ecx
  80170e:	ba 00 00 00 00       	mov    $0x0,%edx
  801713:	be 00 00 00 00       	mov    $0x0,%esi
  801718:	bf 0a 00 00 00       	mov    $0xa,%edi
  80171d:	48 b8 5a 15 80 00 00 	movabs $0x80155a,%rax
  801724:	00 00 00 
  801727:	ff d0                	callq  *%rax
  801729:	48 83 c4 10          	add    $0x10,%rsp
}
  80172d:	90                   	nop
  80172e:	c9                   	leaveq 
  80172f:	c3                   	retq   

0000000000801730 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801730:	55                   	push   %rbp
  801731:	48 89 e5             	mov    %rsp,%rbp
  801734:	48 83 ec 10          	sub    $0x10,%rsp
  801738:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80173b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80173f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801742:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801745:	48 63 c8             	movslq %eax,%rcx
  801748:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80174c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80174f:	48 98                	cltq   
  801751:	48 83 ec 08          	sub    $0x8,%rsp
  801755:	6a 00                	pushq  $0x0
  801757:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80175d:	49 89 c8             	mov    %rcx,%r8
  801760:	48 89 d1             	mov    %rdx,%rcx
  801763:	48 89 c2             	mov    %rax,%rdx
  801766:	be 01 00 00 00       	mov    $0x1,%esi
  80176b:	bf 04 00 00 00       	mov    $0x4,%edi
  801770:	48 b8 5a 15 80 00 00 	movabs $0x80155a,%rax
  801777:	00 00 00 
  80177a:	ff d0                	callq  *%rax
  80177c:	48 83 c4 10          	add    $0x10,%rsp
}
  801780:	c9                   	leaveq 
  801781:	c3                   	retq   

0000000000801782 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801782:	55                   	push   %rbp
  801783:	48 89 e5             	mov    %rsp,%rbp
  801786:	48 83 ec 20          	sub    $0x20,%rsp
  80178a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80178d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801791:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801794:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801798:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80179c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80179f:	48 63 c8             	movslq %eax,%rcx
  8017a2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017a9:	48 63 f0             	movslq %eax,%rsi
  8017ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017b3:	48 98                	cltq   
  8017b5:	48 83 ec 08          	sub    $0x8,%rsp
  8017b9:	51                   	push   %rcx
  8017ba:	49 89 f9             	mov    %rdi,%r9
  8017bd:	49 89 f0             	mov    %rsi,%r8
  8017c0:	48 89 d1             	mov    %rdx,%rcx
  8017c3:	48 89 c2             	mov    %rax,%rdx
  8017c6:	be 01 00 00 00       	mov    $0x1,%esi
  8017cb:	bf 05 00 00 00       	mov    $0x5,%edi
  8017d0:	48 b8 5a 15 80 00 00 	movabs $0x80155a,%rax
  8017d7:	00 00 00 
  8017da:	ff d0                	callq  *%rax
  8017dc:	48 83 c4 10          	add    $0x10,%rsp
}
  8017e0:	c9                   	leaveq 
  8017e1:	c3                   	retq   

00000000008017e2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8017e2:	55                   	push   %rbp
  8017e3:	48 89 e5             	mov    %rsp,%rbp
  8017e6:	48 83 ec 10          	sub    $0x10,%rsp
  8017ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8017f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017f8:	48 98                	cltq   
  8017fa:	48 83 ec 08          	sub    $0x8,%rsp
  8017fe:	6a 00                	pushq  $0x0
  801800:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801806:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80180c:	48 89 d1             	mov    %rdx,%rcx
  80180f:	48 89 c2             	mov    %rax,%rdx
  801812:	be 01 00 00 00       	mov    $0x1,%esi
  801817:	bf 06 00 00 00       	mov    $0x6,%edi
  80181c:	48 b8 5a 15 80 00 00 	movabs $0x80155a,%rax
  801823:	00 00 00 
  801826:	ff d0                	callq  *%rax
  801828:	48 83 c4 10          	add    $0x10,%rsp
}
  80182c:	c9                   	leaveq 
  80182d:	c3                   	retq   

000000000080182e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80182e:	55                   	push   %rbp
  80182f:	48 89 e5             	mov    %rsp,%rbp
  801832:	48 83 ec 10          	sub    $0x10,%rsp
  801836:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801839:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80183c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80183f:	48 63 d0             	movslq %eax,%rdx
  801842:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801845:	48 98                	cltq   
  801847:	48 83 ec 08          	sub    $0x8,%rsp
  80184b:	6a 00                	pushq  $0x0
  80184d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801853:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801859:	48 89 d1             	mov    %rdx,%rcx
  80185c:	48 89 c2             	mov    %rax,%rdx
  80185f:	be 01 00 00 00       	mov    $0x1,%esi
  801864:	bf 08 00 00 00       	mov    $0x8,%edi
  801869:	48 b8 5a 15 80 00 00 	movabs $0x80155a,%rax
  801870:	00 00 00 
  801873:	ff d0                	callq  *%rax
  801875:	48 83 c4 10          	add    $0x10,%rsp
}
  801879:	c9                   	leaveq 
  80187a:	c3                   	retq   

000000000080187b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80187b:	55                   	push   %rbp
  80187c:	48 89 e5             	mov    %rsp,%rbp
  80187f:	48 83 ec 10          	sub    $0x10,%rsp
  801883:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801886:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80188a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80188e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801891:	48 98                	cltq   
  801893:	48 83 ec 08          	sub    $0x8,%rsp
  801897:	6a 00                	pushq  $0x0
  801899:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80189f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018a5:	48 89 d1             	mov    %rdx,%rcx
  8018a8:	48 89 c2             	mov    %rax,%rdx
  8018ab:	be 01 00 00 00       	mov    $0x1,%esi
  8018b0:	bf 09 00 00 00       	mov    $0x9,%edi
  8018b5:	48 b8 5a 15 80 00 00 	movabs $0x80155a,%rax
  8018bc:	00 00 00 
  8018bf:	ff d0                	callq  *%rax
  8018c1:	48 83 c4 10          	add    $0x10,%rsp
}
  8018c5:	c9                   	leaveq 
  8018c6:	c3                   	retq   

00000000008018c7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8018c7:	55                   	push   %rbp
  8018c8:	48 89 e5             	mov    %rsp,%rbp
  8018cb:	48 83 ec 20          	sub    $0x20,%rsp
  8018cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018da:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8018dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018e0:	48 63 f0             	movslq %eax,%rsi
  8018e3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8018e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ea:	48 98                	cltq   
  8018ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f0:	48 83 ec 08          	sub    $0x8,%rsp
  8018f4:	6a 00                	pushq  $0x0
  8018f6:	49 89 f1             	mov    %rsi,%r9
  8018f9:	49 89 c8             	mov    %rcx,%r8
  8018fc:	48 89 d1             	mov    %rdx,%rcx
  8018ff:	48 89 c2             	mov    %rax,%rdx
  801902:	be 00 00 00 00       	mov    $0x0,%esi
  801907:	bf 0b 00 00 00       	mov    $0xb,%edi
  80190c:	48 b8 5a 15 80 00 00 	movabs $0x80155a,%rax
  801913:	00 00 00 
  801916:	ff d0                	callq  *%rax
  801918:	48 83 c4 10          	add    $0x10,%rsp
}
  80191c:	c9                   	leaveq 
  80191d:	c3                   	retq   

000000000080191e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80191e:	55                   	push   %rbp
  80191f:	48 89 e5             	mov    %rsp,%rbp
  801922:	48 83 ec 10          	sub    $0x10,%rsp
  801926:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80192a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80192e:	48 83 ec 08          	sub    $0x8,%rsp
  801932:	6a 00                	pushq  $0x0
  801934:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80193a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801940:	b9 00 00 00 00       	mov    $0x0,%ecx
  801945:	48 89 c2             	mov    %rax,%rdx
  801948:	be 01 00 00 00       	mov    $0x1,%esi
  80194d:	bf 0c 00 00 00       	mov    $0xc,%edi
  801952:	48 b8 5a 15 80 00 00 	movabs $0x80155a,%rax
  801959:	00 00 00 
  80195c:	ff d0                	callq  *%rax
  80195e:	48 83 c4 10          	add    $0x10,%rsp
}
  801962:	c9                   	leaveq 
  801963:	c3                   	retq   

0000000000801964 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801964:	55                   	push   %rbp
  801965:	48 89 e5             	mov    %rsp,%rbp
  801968:	53                   	push   %rbx
  801969:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801970:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801977:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80197d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  801984:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80198b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801992:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801999:	84 c0                	test   %al,%al
  80199b:	74 23                	je     8019c0 <_panic+0x5c>
  80199d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8019a4:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8019a8:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8019ac:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8019b0:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8019b4:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8019b8:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8019bc:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8019c0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8019c7:	00 00 00 
  8019ca:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8019d1:	00 00 00 
  8019d4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019d8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8019df:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8019e6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8019ed:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8019f4:	00 00 00 
  8019f7:	48 8b 18             	mov    (%rax),%rbx
  8019fa:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  801a01:	00 00 00 
  801a04:	ff d0                	callq  *%rax
  801a06:	89 c6                	mov    %eax,%esi
  801a08:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  801a0e:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  801a15:	41 89 d0             	mov    %edx,%r8d
  801a18:	48 89 c1             	mov    %rax,%rcx
  801a1b:	48 89 da             	mov    %rbx,%rdx
  801a1e:	48 bf 18 1f 80 00 00 	movabs $0x801f18,%rdi
  801a25:	00 00 00 
  801a28:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2d:	49 b9 6a 02 80 00 00 	movabs $0x80026a,%r9
  801a34:	00 00 00 
  801a37:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a3a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801a41:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a48:	48 89 d6             	mov    %rdx,%rsi
  801a4b:	48 89 c7             	mov    %rax,%rdi
  801a4e:	48 b8 be 01 80 00 00 	movabs $0x8001be,%rax
  801a55:	00 00 00 
  801a58:	ff d0                	callq  *%rax
	cprintf("\n");
  801a5a:	48 bf 3b 1f 80 00 00 	movabs $0x801f3b,%rdi
  801a61:	00 00 00 
  801a64:	b8 00 00 00 00       	mov    $0x0,%eax
  801a69:	48 ba 6a 02 80 00 00 	movabs $0x80026a,%rdx
  801a70:	00 00 00 
  801a73:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a75:	cc                   	int3   
  801a76:	eb fd                	jmp    801a75 <_panic+0x111>
