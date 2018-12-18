
obj/user/faultdie:     file format elf64-x86-64


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
  80003c:	e8 9e 00 00 00       	callq  8000df <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void*)utf->utf_fault_va;
  80004f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800053:	48 8b 00             	mov    (%rax),%rax
  800056:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80005a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80005e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800062:	89 45 f4             	mov    %eax,-0xc(%rbp)
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800065:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800068:	83 e0 07             	and    $0x7,%eax
  80006b:	89 c2                	mov    %eax,%edx
  80006d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800071:	48 89 c6             	mov    %rax,%rsi
  800074:	48 bf 20 1c 80 00 00 	movabs $0x801c20,%rdi
  80007b:	00 00 00 
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	48 b9 a9 02 80 00 00 	movabs $0x8002a9,%rcx
  80008a:	00 00 00 
  80008d:	ff d1                	callq  *%rcx
	sys_env_destroy(sys_getenvid());
  80008f:	48 b8 f6 16 80 00 00 	movabs $0x8016f6,%rax
  800096:	00 00 00 
  800099:	ff d0                	callq  *%rax
  80009b:	89 c7                	mov    %eax,%edi
  80009d:	48 b8 b0 16 80 00 00 	movabs $0x8016b0,%rax
  8000a4:	00 00 00 
  8000a7:	ff d0                	callq  *%rax
}
  8000a9:	90                   	nop
  8000aa:	c9                   	leaveq 
  8000ab:	c3                   	retq   

00000000008000ac <umain>:

void
umain(int argc, char **argv)
{
  8000ac:	55                   	push   %rbp
  8000ad:	48 89 e5             	mov    %rsp,%rbp
  8000b0:	48 83 ec 10          	sub    $0x10,%rsp
  8000b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(handler);
  8000bb:	48 bf 43 00 80 00 00 	movabs $0x800043,%rdi
  8000c2:	00 00 00 
  8000c5:	48 b8 a3 19 80 00 00 	movabs $0x8019a3,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	callq  *%rax
	*(int*)0xDeadBeef = 0;
  8000d1:	b8 ef be ad de       	mov    $0xdeadbeef,%eax
  8000d6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  8000dc:	90                   	nop
  8000dd:	c9                   	leaveq 
  8000de:	c3                   	retq   

00000000008000df <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000df:	55                   	push   %rbp
  8000e0:	48 89 e5             	mov    %rsp,%rbp
  8000e3:	48 83 ec 10          	sub    $0x10,%rsp
  8000e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  8000ee:	48 b8 f6 16 80 00 00 	movabs $0x8016f6,%rax
  8000f5:	00 00 00 
  8000f8:	ff d0                	callq  *%rax
  8000fa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ff:	48 63 d0             	movslq %eax,%rdx
  800102:	48 89 d0             	mov    %rdx,%rax
  800105:	48 c1 e0 03          	shl    $0x3,%rax
  800109:	48 01 d0             	add    %rdx,%rax
  80010c:	48 c1 e0 05          	shl    $0x5,%rax
  800110:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800117:	00 00 00 
  80011a:	48 01 c2             	add    %rax,%rdx
  80011d:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800124:	00 00 00 
  800127:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80012e:	7e 14                	jle    800144 <libmain+0x65>
		binaryname = argv[0];
  800130:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800134:	48 8b 10             	mov    (%rax),%rdx
  800137:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80013e:	00 00 00 
  800141:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800144:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800148:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80014b:	48 89 d6             	mov    %rdx,%rsi
  80014e:	89 c7                	mov    %eax,%edi
  800150:	48 b8 ac 00 80 00 00 	movabs $0x8000ac,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80015c:	48 b8 6b 01 80 00 00 	movabs $0x80016b,%rax
  800163:	00 00 00 
  800166:	ff d0                	callq  *%rax
}
  800168:	90                   	nop
  800169:	c9                   	leaveq 
  80016a:	c3                   	retq   

000000000080016b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80016b:	55                   	push   %rbp
  80016c:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80016f:	bf 00 00 00 00       	mov    $0x0,%edi
  800174:	48 b8 b0 16 80 00 00 	movabs $0x8016b0,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
}
  800180:	90                   	nop
  800181:	5d                   	pop    %rbp
  800182:	c3                   	retq   

0000000000800183 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800183:	55                   	push   %rbp
  800184:	48 89 e5             	mov    %rsp,%rbp
  800187:	48 83 ec 10          	sub    $0x10,%rsp
  80018b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80018e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800192:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800196:	8b 00                	mov    (%rax),%eax
  800198:	8d 48 01             	lea    0x1(%rax),%ecx
  80019b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80019f:	89 0a                	mov    %ecx,(%rdx)
  8001a1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001a4:	89 d1                	mov    %edx,%ecx
  8001a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001aa:	48 98                	cltq   
  8001ac:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b4:	8b 00                	mov    (%rax),%eax
  8001b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001bb:	75 2c                	jne    8001e9 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8001bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c1:	8b 00                	mov    (%rax),%eax
  8001c3:	48 98                	cltq   
  8001c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c9:	48 83 c2 08          	add    $0x8,%rdx
  8001cd:	48 89 c6             	mov    %rax,%rsi
  8001d0:	48 89 d7             	mov    %rdx,%rdi
  8001d3:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  8001da:	00 00 00 
  8001dd:	ff d0                	callq  *%rax
        b->idx = 0;
  8001df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001e3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ed:	8b 40 04             	mov    0x4(%rax),%eax
  8001f0:	8d 50 01             	lea    0x1(%rax),%edx
  8001f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001f7:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001fa:	90                   	nop
  8001fb:	c9                   	leaveq 
  8001fc:	c3                   	retq   

00000000008001fd <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001fd:	55                   	push   %rbp
  8001fe:	48 89 e5             	mov    %rsp,%rbp
  800201:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800208:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80020f:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800216:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80021d:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800224:	48 8b 0a             	mov    (%rdx),%rcx
  800227:	48 89 08             	mov    %rcx,(%rax)
  80022a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80022e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800232:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800236:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80023a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800241:	00 00 00 
    b.cnt = 0;
  800244:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80024b:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80024e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800255:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80025c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800263:	48 89 c6             	mov    %rax,%rsi
  800266:	48 bf 83 01 80 00 00 	movabs $0x800183,%rdi
  80026d:	00 00 00 
  800270:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  800277:	00 00 00 
  80027a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80027c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800282:	48 98                	cltq   
  800284:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80028b:	48 83 c2 08          	add    $0x8,%rdx
  80028f:	48 89 c6             	mov    %rax,%rsi
  800292:	48 89 d7             	mov    %rdx,%rdi
  800295:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  80029c:	00 00 00 
  80029f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002a1:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002a7:	c9                   	leaveq 
  8002a8:	c3                   	retq   

00000000008002a9 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002a9:	55                   	push   %rbp
  8002aa:	48 89 e5             	mov    %rsp,%rbp
  8002ad:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002b4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8002bb:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002c2:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002c9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002d0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8002d7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002de:	84 c0                	test   %al,%al
  8002e0:	74 20                	je     800302 <cprintf+0x59>
  8002e2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002e6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002ea:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002ee:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002f2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002f6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002fa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002fe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800302:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800309:	00 00 00 
  80030c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800313:	00 00 00 
  800316:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80031a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800321:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800328:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80032f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800336:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80033d:	48 8b 0a             	mov    (%rdx),%rcx
  800340:	48 89 08             	mov    %rcx,(%rax)
  800343:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800347:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80034b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80034f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800353:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80035a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800361:	48 89 d6             	mov    %rdx,%rsi
  800364:	48 89 c7             	mov    %rax,%rdi
  800367:	48 b8 fd 01 80 00 00 	movabs $0x8001fd,%rax
  80036e:	00 00 00 
  800371:	ff d0                	callq  *%rax
  800373:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800379:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80037f:	c9                   	leaveq 
  800380:	c3                   	retq   

0000000000800381 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800381:	55                   	push   %rbp
  800382:	48 89 e5             	mov    %rsp,%rbp
  800385:	48 83 ec 30          	sub    $0x30,%rsp
  800389:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80038d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800391:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800395:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800398:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80039c:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003a0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8003a3:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8003a7:	77 54                	ja     8003fd <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003a9:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003ac:	8d 78 ff             	lea    -0x1(%rax),%edi
  8003af:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8003b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bb:	48 f7 f6             	div    %rsi
  8003be:	49 89 c2             	mov    %rax,%r10
  8003c1:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8003c4:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8003c7:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8003cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003cf:	41 89 c9             	mov    %ecx,%r9d
  8003d2:	41 89 f8             	mov    %edi,%r8d
  8003d5:	89 d1                	mov    %edx,%ecx
  8003d7:	4c 89 d2             	mov    %r10,%rdx
  8003da:	48 89 c7             	mov    %rax,%rdi
  8003dd:	48 b8 81 03 80 00 00 	movabs $0x800381,%rax
  8003e4:	00 00 00 
  8003e7:	ff d0                	callq  *%rax
  8003e9:	eb 1c                	jmp    800407 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003eb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8003ef:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8003f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f6:	48 89 ce             	mov    %rcx,%rsi
  8003f9:	89 d7                	mov    %edx,%edi
  8003fb:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003fd:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800401:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800405:	7f e4                	jg     8003eb <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800407:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80040a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80040e:	ba 00 00 00 00       	mov    $0x0,%edx
  800413:	48 f7 f1             	div    %rcx
  800416:	48 b8 b0 1d 80 00 00 	movabs $0x801db0,%rax
  80041d:	00 00 00 
  800420:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800424:	0f be d0             	movsbl %al,%edx
  800427:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80042b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042f:	48 89 ce             	mov    %rcx,%rsi
  800432:	89 d7                	mov    %edx,%edi
  800434:	ff d0                	callq  *%rax
}
  800436:	90                   	nop
  800437:	c9                   	leaveq 
  800438:	c3                   	retq   

0000000000800439 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800439:	55                   	push   %rbp
  80043a:	48 89 e5             	mov    %rsp,%rbp
  80043d:	48 83 ec 20          	sub    $0x20,%rsp
  800441:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800445:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800448:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80044c:	7e 4f                	jle    80049d <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80044e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800452:	8b 00                	mov    (%rax),%eax
  800454:	83 f8 30             	cmp    $0x30,%eax
  800457:	73 24                	jae    80047d <getuint+0x44>
  800459:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80045d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800461:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800465:	8b 00                	mov    (%rax),%eax
  800467:	89 c0                	mov    %eax,%eax
  800469:	48 01 d0             	add    %rdx,%rax
  80046c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800470:	8b 12                	mov    (%rdx),%edx
  800472:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800475:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800479:	89 0a                	mov    %ecx,(%rdx)
  80047b:	eb 14                	jmp    800491 <getuint+0x58>
  80047d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800481:	48 8b 40 08          	mov    0x8(%rax),%rax
  800485:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800489:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80048d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800491:	48 8b 00             	mov    (%rax),%rax
  800494:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800498:	e9 9d 00 00 00       	jmpq   80053a <getuint+0x101>
	else if (lflag)
  80049d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004a1:	74 4c                	je     8004ef <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8004a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a7:	8b 00                	mov    (%rax),%eax
  8004a9:	83 f8 30             	cmp    $0x30,%eax
  8004ac:	73 24                	jae    8004d2 <getuint+0x99>
  8004ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ba:	8b 00                	mov    (%rax),%eax
  8004bc:	89 c0                	mov    %eax,%eax
  8004be:	48 01 d0             	add    %rdx,%rax
  8004c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c5:	8b 12                	mov    (%rdx),%edx
  8004c7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ce:	89 0a                	mov    %ecx,(%rdx)
  8004d0:	eb 14                	jmp    8004e6 <getuint+0xad>
  8004d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004da:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8004de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004e6:	48 8b 00             	mov    (%rax),%rax
  8004e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004ed:	eb 4b                	jmp    80053a <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8004ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f3:	8b 00                	mov    (%rax),%eax
  8004f5:	83 f8 30             	cmp    $0x30,%eax
  8004f8:	73 24                	jae    80051e <getuint+0xe5>
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
  80051c:	eb 14                	jmp    800532 <getuint+0xf9>
  80051e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800522:	48 8b 40 08          	mov    0x8(%rax),%rax
  800526:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80052a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80052e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800532:	8b 00                	mov    (%rax),%eax
  800534:	89 c0                	mov    %eax,%eax
  800536:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80053a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80053e:	c9                   	leaveq 
  80053f:	c3                   	retq   

0000000000800540 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800540:	55                   	push   %rbp
  800541:	48 89 e5             	mov    %rsp,%rbp
  800544:	48 83 ec 20          	sub    $0x20,%rsp
  800548:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80054c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80054f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800553:	7e 4f                	jle    8005a4 <getint+0x64>
		x=va_arg(*ap, long long);
  800555:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800559:	8b 00                	mov    (%rax),%eax
  80055b:	83 f8 30             	cmp    $0x30,%eax
  80055e:	73 24                	jae    800584 <getint+0x44>
  800560:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800564:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056c:	8b 00                	mov    (%rax),%eax
  80056e:	89 c0                	mov    %eax,%eax
  800570:	48 01 d0             	add    %rdx,%rax
  800573:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800577:	8b 12                	mov    (%rdx),%edx
  800579:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80057c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800580:	89 0a                	mov    %ecx,(%rdx)
  800582:	eb 14                	jmp    800598 <getint+0x58>
  800584:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800588:	48 8b 40 08          	mov    0x8(%rax),%rax
  80058c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800590:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800594:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800598:	48 8b 00             	mov    (%rax),%rax
  80059b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80059f:	e9 9d 00 00 00       	jmpq   800641 <getint+0x101>
	else if (lflag)
  8005a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005a8:	74 4c                	je     8005f6 <getint+0xb6>
		x=va_arg(*ap, long);
  8005aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ae:	8b 00                	mov    (%rax),%eax
  8005b0:	83 f8 30             	cmp    $0x30,%eax
  8005b3:	73 24                	jae    8005d9 <getint+0x99>
  8005b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c1:	8b 00                	mov    (%rax),%eax
  8005c3:	89 c0                	mov    %eax,%eax
  8005c5:	48 01 d0             	add    %rdx,%rax
  8005c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005cc:	8b 12                	mov    (%rdx),%edx
  8005ce:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d5:	89 0a                	mov    %ecx,(%rdx)
  8005d7:	eb 14                	jmp    8005ed <getint+0xad>
  8005d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dd:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005e1:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005ed:	48 8b 00             	mov    (%rax),%rax
  8005f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005f4:	eb 4b                	jmp    800641 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8005f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fa:	8b 00                	mov    (%rax),%eax
  8005fc:	83 f8 30             	cmp    $0x30,%eax
  8005ff:	73 24                	jae    800625 <getint+0xe5>
  800601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800605:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800609:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060d:	8b 00                	mov    (%rax),%eax
  80060f:	89 c0                	mov    %eax,%eax
  800611:	48 01 d0             	add    %rdx,%rax
  800614:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800618:	8b 12                	mov    (%rdx),%edx
  80061a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80061d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800621:	89 0a                	mov    %ecx,(%rdx)
  800623:	eb 14                	jmp    800639 <getint+0xf9>
  800625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800629:	48 8b 40 08          	mov    0x8(%rax),%rax
  80062d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800631:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800635:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800639:	8b 00                	mov    (%rax),%eax
  80063b:	48 98                	cltq   
  80063d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800641:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800645:	c9                   	leaveq 
  800646:	c3                   	retq   

0000000000800647 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800647:	55                   	push   %rbp
  800648:	48 89 e5             	mov    %rsp,%rbp
  80064b:	41 54                	push   %r12
  80064d:	53                   	push   %rbx
  80064e:	48 83 ec 60          	sub    $0x60,%rsp
  800652:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800656:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80065a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80065e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800662:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800666:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80066a:	48 8b 0a             	mov    (%rdx),%rcx
  80066d:	48 89 08             	mov    %rcx,(%rax)
  800670:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800674:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800678:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80067c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800680:	eb 17                	jmp    800699 <vprintfmt+0x52>
			if (ch == '\0')
  800682:	85 db                	test   %ebx,%ebx
  800684:	0f 84 b9 04 00 00    	je     800b43 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80068a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80068e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800692:	48 89 d6             	mov    %rdx,%rsi
  800695:	89 df                	mov    %ebx,%edi
  800697:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800699:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80069d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006a1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006a5:	0f b6 00             	movzbl (%rax),%eax
  8006a8:	0f b6 d8             	movzbl %al,%ebx
  8006ab:	83 fb 25             	cmp    $0x25,%ebx
  8006ae:	75 d2                	jne    800682 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006b0:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006b4:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8006bb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006c9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006d4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006d8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006dc:	0f b6 00             	movzbl (%rax),%eax
  8006df:	0f b6 d8             	movzbl %al,%ebx
  8006e2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006e5:	83 f8 55             	cmp    $0x55,%eax
  8006e8:	0f 87 22 04 00 00    	ja     800b10 <vprintfmt+0x4c9>
  8006ee:	89 c0                	mov    %eax,%eax
  8006f0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006f7:	00 
  8006f8:	48 b8 d8 1d 80 00 00 	movabs $0x801dd8,%rax
  8006ff:	00 00 00 
  800702:	48 01 d0             	add    %rdx,%rax
  800705:	48 8b 00             	mov    (%rax),%rax
  800708:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80070a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80070e:	eb c0                	jmp    8006d0 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800710:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800714:	eb ba                	jmp    8006d0 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800716:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80071d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800720:	89 d0                	mov    %edx,%eax
  800722:	c1 e0 02             	shl    $0x2,%eax
  800725:	01 d0                	add    %edx,%eax
  800727:	01 c0                	add    %eax,%eax
  800729:	01 d8                	add    %ebx,%eax
  80072b:	83 e8 30             	sub    $0x30,%eax
  80072e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800731:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800735:	0f b6 00             	movzbl (%rax),%eax
  800738:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80073b:	83 fb 2f             	cmp    $0x2f,%ebx
  80073e:	7e 60                	jle    8007a0 <vprintfmt+0x159>
  800740:	83 fb 39             	cmp    $0x39,%ebx
  800743:	7f 5b                	jg     8007a0 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800745:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80074a:	eb d1                	jmp    80071d <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80074c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80074f:	83 f8 30             	cmp    $0x30,%eax
  800752:	73 17                	jae    80076b <vprintfmt+0x124>
  800754:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800758:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80075b:	89 d2                	mov    %edx,%edx
  80075d:	48 01 d0             	add    %rdx,%rax
  800760:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800763:	83 c2 08             	add    $0x8,%edx
  800766:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800769:	eb 0c                	jmp    800777 <vprintfmt+0x130>
  80076b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80076f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800773:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800777:	8b 00                	mov    (%rax),%eax
  800779:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80077c:	eb 23                	jmp    8007a1 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  80077e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800782:	0f 89 48 ff ff ff    	jns    8006d0 <vprintfmt+0x89>
				width = 0;
  800788:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80078f:	e9 3c ff ff ff       	jmpq   8006d0 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800794:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80079b:	e9 30 ff ff ff       	jmpq   8006d0 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007a0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007a1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007a5:	0f 89 25 ff ff ff    	jns    8006d0 <vprintfmt+0x89>
				width = precision, precision = -1;
  8007ab:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007ae:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007b1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007b8:	e9 13 ff ff ff       	jmpq   8006d0 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007bd:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007c1:	e9 0a ff ff ff       	jmpq   8006d0 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c9:	83 f8 30             	cmp    $0x30,%eax
  8007cc:	73 17                	jae    8007e5 <vprintfmt+0x19e>
  8007ce:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8007d2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007d5:	89 d2                	mov    %edx,%edx
  8007d7:	48 01 d0             	add    %rdx,%rax
  8007da:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007dd:	83 c2 08             	add    $0x8,%edx
  8007e0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007e3:	eb 0c                	jmp    8007f1 <vprintfmt+0x1aa>
  8007e5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8007e9:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8007ed:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007f1:	8b 10                	mov    (%rax),%edx
  8007f3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007f7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007fb:	48 89 ce             	mov    %rcx,%rsi
  8007fe:	89 d7                	mov    %edx,%edi
  800800:	ff d0                	callq  *%rax
			break;
  800802:	e9 37 03 00 00       	jmpq   800b3e <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800807:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80080a:	83 f8 30             	cmp    $0x30,%eax
  80080d:	73 17                	jae    800826 <vprintfmt+0x1df>
  80080f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800813:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800816:	89 d2                	mov    %edx,%edx
  800818:	48 01 d0             	add    %rdx,%rax
  80081b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80081e:	83 c2 08             	add    $0x8,%edx
  800821:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800824:	eb 0c                	jmp    800832 <vprintfmt+0x1eb>
  800826:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80082a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80082e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800832:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800834:	85 db                	test   %ebx,%ebx
  800836:	79 02                	jns    80083a <vprintfmt+0x1f3>
				err = -err;
  800838:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80083a:	83 fb 15             	cmp    $0x15,%ebx
  80083d:	7f 16                	jg     800855 <vprintfmt+0x20e>
  80083f:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  800846:	00 00 00 
  800849:	48 63 d3             	movslq %ebx,%rdx
  80084c:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800850:	4d 85 e4             	test   %r12,%r12
  800853:	75 2e                	jne    800883 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800855:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800859:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80085d:	89 d9                	mov    %ebx,%ecx
  80085f:	48 ba c1 1d 80 00 00 	movabs $0x801dc1,%rdx
  800866:	00 00 00 
  800869:	48 89 c7             	mov    %rax,%rdi
  80086c:	b8 00 00 00 00       	mov    $0x0,%eax
  800871:	49 b8 4d 0b 80 00 00 	movabs $0x800b4d,%r8
  800878:	00 00 00 
  80087b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087e:	e9 bb 02 00 00       	jmpq   800b3e <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800883:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800887:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80088b:	4c 89 e1             	mov    %r12,%rcx
  80088e:	48 ba ca 1d 80 00 00 	movabs $0x801dca,%rdx
  800895:	00 00 00 
  800898:	48 89 c7             	mov    %rax,%rdi
  80089b:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a0:	49 b8 4d 0b 80 00 00 	movabs $0x800b4d,%r8
  8008a7:	00 00 00 
  8008aa:	41 ff d0             	callq  *%r8
			break;
  8008ad:	e9 8c 02 00 00       	jmpq   800b3e <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b5:	83 f8 30             	cmp    $0x30,%eax
  8008b8:	73 17                	jae    8008d1 <vprintfmt+0x28a>
  8008ba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8008be:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008c1:	89 d2                	mov    %edx,%edx
  8008c3:	48 01 d0             	add    %rdx,%rax
  8008c6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008c9:	83 c2 08             	add    $0x8,%edx
  8008cc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008cf:	eb 0c                	jmp    8008dd <vprintfmt+0x296>
  8008d1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8008d5:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8008d9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008dd:	4c 8b 20             	mov    (%rax),%r12
  8008e0:	4d 85 e4             	test   %r12,%r12
  8008e3:	75 0a                	jne    8008ef <vprintfmt+0x2a8>
				p = "(null)";
  8008e5:	49 bc cd 1d 80 00 00 	movabs $0x801dcd,%r12
  8008ec:	00 00 00 
			if (width > 0 && padc != '-')
  8008ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008f3:	7e 78                	jle    80096d <vprintfmt+0x326>
  8008f5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008f9:	74 72                	je     80096d <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008fe:	48 98                	cltq   
  800900:	48 89 c6             	mov    %rax,%rsi
  800903:	4c 89 e7             	mov    %r12,%rdi
  800906:	48 b8 fb 0d 80 00 00 	movabs $0x800dfb,%rax
  80090d:	00 00 00 
  800910:	ff d0                	callq  *%rax
  800912:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800915:	eb 17                	jmp    80092e <vprintfmt+0x2e7>
					putch(padc, putdat);
  800917:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80091b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80091f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800923:	48 89 ce             	mov    %rcx,%rsi
  800926:	89 d7                	mov    %edx,%edi
  800928:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80092a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80092e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800932:	7f e3                	jg     800917 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800934:	eb 37                	jmp    80096d <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800936:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80093a:	74 1e                	je     80095a <vprintfmt+0x313>
  80093c:	83 fb 1f             	cmp    $0x1f,%ebx
  80093f:	7e 05                	jle    800946 <vprintfmt+0x2ff>
  800941:	83 fb 7e             	cmp    $0x7e,%ebx
  800944:	7e 14                	jle    80095a <vprintfmt+0x313>
					putch('?', putdat);
  800946:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80094a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80094e:	48 89 d6             	mov    %rdx,%rsi
  800951:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800956:	ff d0                	callq  *%rax
  800958:	eb 0f                	jmp    800969 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  80095a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80095e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800962:	48 89 d6             	mov    %rdx,%rsi
  800965:	89 df                	mov    %ebx,%edi
  800967:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800969:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80096d:	4c 89 e0             	mov    %r12,%rax
  800970:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800974:	0f b6 00             	movzbl (%rax),%eax
  800977:	0f be d8             	movsbl %al,%ebx
  80097a:	85 db                	test   %ebx,%ebx
  80097c:	74 28                	je     8009a6 <vprintfmt+0x35f>
  80097e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800982:	78 b2                	js     800936 <vprintfmt+0x2ef>
  800984:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800988:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80098c:	79 a8                	jns    800936 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098e:	eb 16                	jmp    8009a6 <vprintfmt+0x35f>
				putch(' ', putdat);
  800990:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800994:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800998:	48 89 d6             	mov    %rdx,%rsi
  80099b:	bf 20 00 00 00       	mov    $0x20,%edi
  8009a0:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009aa:	7f e4                	jg     800990 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  8009ac:	e9 8d 01 00 00       	jmpq   800b3e <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8009b1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009b5:	be 03 00 00 00       	mov    $0x3,%esi
  8009ba:	48 89 c7             	mov    %rax,%rdi
  8009bd:	48 b8 40 05 80 00 00 	movabs $0x800540,%rax
  8009c4:	00 00 00 
  8009c7:	ff d0                	callq  *%rax
  8009c9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d1:	48 85 c0             	test   %rax,%rax
  8009d4:	79 1d                	jns    8009f3 <vprintfmt+0x3ac>
				putch('-', putdat);
  8009d6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009da:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009de:	48 89 d6             	mov    %rdx,%rsi
  8009e1:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009e6:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ec:	48 f7 d8             	neg    %rax
  8009ef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009f3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009fa:	e9 d2 00 00 00       	jmpq   800ad1 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009ff:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a03:	be 03 00 00 00       	mov    $0x3,%esi
  800a08:	48 89 c7             	mov    %rax,%rdi
  800a0b:	48 b8 39 04 80 00 00 	movabs $0x800439,%rax
  800a12:	00 00 00 
  800a15:	ff d0                	callq  *%rax
  800a17:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a1b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a22:	e9 aa 00 00 00       	jmpq   800ad1 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800a27:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a2b:	be 03 00 00 00       	mov    $0x3,%esi
  800a30:	48 89 c7             	mov    %rax,%rdi
  800a33:	48 b8 39 04 80 00 00 	movabs $0x800439,%rax
  800a3a:	00 00 00 
  800a3d:	ff d0                	callq  *%rax
  800a3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a43:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a4a:	e9 82 00 00 00       	jmpq   800ad1 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800a4f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a57:	48 89 d6             	mov    %rdx,%rsi
  800a5a:	bf 30 00 00 00       	mov    $0x30,%edi
  800a5f:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a61:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a69:	48 89 d6             	mov    %rdx,%rsi
  800a6c:	bf 78 00 00 00       	mov    $0x78,%edi
  800a71:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a73:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a76:	83 f8 30             	cmp    $0x30,%eax
  800a79:	73 17                	jae    800a92 <vprintfmt+0x44b>
  800a7b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a7f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a82:	89 d2                	mov    %edx,%edx
  800a84:	48 01 d0             	add    %rdx,%rax
  800a87:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a8a:	83 c2 08             	add    $0x8,%edx
  800a8d:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a90:	eb 0c                	jmp    800a9e <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800a92:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a96:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a9a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800aa5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800aac:	eb 23                	jmp    800ad1 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800aae:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ab2:	be 03 00 00 00       	mov    $0x3,%esi
  800ab7:	48 89 c7             	mov    %rax,%rdi
  800aba:	48 b8 39 04 80 00 00 	movabs $0x800439,%rax
  800ac1:	00 00 00 
  800ac4:	ff d0                	callq  *%rax
  800ac6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800aca:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ad1:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ad6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ad9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800adc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ae4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae8:	45 89 c1             	mov    %r8d,%r9d
  800aeb:	41 89 f8             	mov    %edi,%r8d
  800aee:	48 89 c7             	mov    %rax,%rdi
  800af1:	48 b8 81 03 80 00 00 	movabs $0x800381,%rax
  800af8:	00 00 00 
  800afb:	ff d0                	callq  *%rax
			break;
  800afd:	eb 3f                	jmp    800b3e <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b03:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b07:	48 89 d6             	mov    %rdx,%rsi
  800b0a:	89 df                	mov    %ebx,%edi
  800b0c:	ff d0                	callq  *%rax
			break;
  800b0e:	eb 2e                	jmp    800b3e <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b18:	48 89 d6             	mov    %rdx,%rsi
  800b1b:	bf 25 00 00 00       	mov    $0x25,%edi
  800b20:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b22:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b27:	eb 05                	jmp    800b2e <vprintfmt+0x4e7>
  800b29:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b2e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b32:	48 83 e8 01          	sub    $0x1,%rax
  800b36:	0f b6 00             	movzbl (%rax),%eax
  800b39:	3c 25                	cmp    $0x25,%al
  800b3b:	75 ec                	jne    800b29 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800b3d:	90                   	nop
		}
	}
  800b3e:	e9 3d fb ff ff       	jmpq   800680 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b43:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b44:	48 83 c4 60          	add    $0x60,%rsp
  800b48:	5b                   	pop    %rbx
  800b49:	41 5c                	pop    %r12
  800b4b:	5d                   	pop    %rbp
  800b4c:	c3                   	retq   

0000000000800b4d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b4d:	55                   	push   %rbp
  800b4e:	48 89 e5             	mov    %rsp,%rbp
  800b51:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b58:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b5f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b66:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800b6d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b74:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b7b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b82:	84 c0                	test   %al,%al
  800b84:	74 20                	je     800ba6 <printfmt+0x59>
  800b86:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b8a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b8e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b92:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b96:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b9a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b9e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ba2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ba6:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800bad:	00 00 00 
  800bb0:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800bb7:	00 00 00 
  800bba:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bbe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bc5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bcc:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd3:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bda:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800be1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800be8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bef:	48 89 c7             	mov    %rax,%rdi
  800bf2:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  800bf9:	00 00 00 
  800bfc:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bfe:	90                   	nop
  800bff:	c9                   	leaveq 
  800c00:	c3                   	retq   

0000000000800c01 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c01:	55                   	push   %rbp
  800c02:	48 89 e5             	mov    %rsp,%rbp
  800c05:	48 83 ec 10          	sub    $0x10,%rsp
  800c09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c14:	8b 40 10             	mov    0x10(%rax),%eax
  800c17:	8d 50 01             	lea    0x1(%rax),%edx
  800c1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c1e:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c25:	48 8b 10             	mov    (%rax),%rdx
  800c28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c2c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c30:	48 39 c2             	cmp    %rax,%rdx
  800c33:	73 17                	jae    800c4c <sprintputch+0x4b>
		*b->buf++ = ch;
  800c35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c39:	48 8b 00             	mov    (%rax),%rax
  800c3c:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c44:	48 89 0a             	mov    %rcx,(%rdx)
  800c47:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c4a:	88 10                	mov    %dl,(%rax)
}
  800c4c:	90                   	nop
  800c4d:	c9                   	leaveq 
  800c4e:	c3                   	retq   

0000000000800c4f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c4f:	55                   	push   %rbp
  800c50:	48 89 e5             	mov    %rsp,%rbp
  800c53:	48 83 ec 50          	sub    $0x50,%rsp
  800c57:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c5b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c5e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c62:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c66:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c6a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c6e:	48 8b 0a             	mov    (%rdx),%rcx
  800c71:	48 89 08             	mov    %rcx,(%rax)
  800c74:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c78:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c7c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c80:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c84:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c88:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c8c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c8f:	48 98                	cltq   
  800c91:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c95:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c99:	48 01 d0             	add    %rdx,%rax
  800c9c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ca0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ca7:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800cac:	74 06                	je     800cb4 <vsnprintf+0x65>
  800cae:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800cb2:	7f 07                	jg     800cbb <vsnprintf+0x6c>
		return -E_INVAL;
  800cb4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cb9:	eb 2f                	jmp    800cea <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800cbb:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800cbf:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cc3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cc7:	48 89 c6             	mov    %rax,%rsi
  800cca:	48 bf 01 0c 80 00 00 	movabs $0x800c01,%rdi
  800cd1:	00 00 00 
  800cd4:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  800cdb:	00 00 00 
  800cde:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ce0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ce4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ce7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cea:	c9                   	leaveq 
  800ceb:	c3                   	retq   

0000000000800cec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cec:	55                   	push   %rbp
  800ced:	48 89 e5             	mov    %rsp,%rbp
  800cf0:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cf7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cfe:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d04:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800d0b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d12:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d19:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d20:	84 c0                	test   %al,%al
  800d22:	74 20                	je     800d44 <snprintf+0x58>
  800d24:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d28:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d2c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d30:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d34:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d38:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d3c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d40:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d44:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d4b:	00 00 00 
  800d4e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d55:	00 00 00 
  800d58:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d5c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d63:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d6a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d71:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d78:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d7f:	48 8b 0a             	mov    (%rdx),%rcx
  800d82:	48 89 08             	mov    %rcx,(%rax)
  800d85:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d89:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d8d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d91:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d95:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d9c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800da3:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800da9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800db0:	48 89 c7             	mov    %rax,%rdi
  800db3:	48 b8 4f 0c 80 00 00 	movabs $0x800c4f,%rax
  800dba:	00 00 00 
  800dbd:	ff d0                	callq  *%rax
  800dbf:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800dc5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800dcb:	c9                   	leaveq 
  800dcc:	c3                   	retq   

0000000000800dcd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800dcd:	55                   	push   %rbp
  800dce:	48 89 e5             	mov    %rsp,%rbp
  800dd1:	48 83 ec 18          	sub    $0x18,%rsp
  800dd5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800de0:	eb 09                	jmp    800deb <strlen+0x1e>
		n++;
  800de2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800deb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800def:	0f b6 00             	movzbl (%rax),%eax
  800df2:	84 c0                	test   %al,%al
  800df4:	75 ec                	jne    800de2 <strlen+0x15>
		n++;
	return n;
  800df6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800df9:	c9                   	leaveq 
  800dfa:	c3                   	retq   

0000000000800dfb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dfb:	55                   	push   %rbp
  800dfc:	48 89 e5             	mov    %rsp,%rbp
  800dff:	48 83 ec 20          	sub    $0x20,%rsp
  800e03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e12:	eb 0e                	jmp    800e22 <strnlen+0x27>
		n++;
  800e14:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e18:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e1d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e22:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e27:	74 0b                	je     800e34 <strnlen+0x39>
  800e29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2d:	0f b6 00             	movzbl (%rax),%eax
  800e30:	84 c0                	test   %al,%al
  800e32:	75 e0                	jne    800e14 <strnlen+0x19>
		n++;
	return n;
  800e34:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e37:	c9                   	leaveq 
  800e38:	c3                   	retq   

0000000000800e39 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e39:	55                   	push   %rbp
  800e3a:	48 89 e5             	mov    %rsp,%rbp
  800e3d:	48 83 ec 20          	sub    $0x20,%rsp
  800e41:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e45:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e51:	90                   	nop
  800e52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e56:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e5a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e5e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e62:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e66:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e6a:	0f b6 12             	movzbl (%rdx),%edx
  800e6d:	88 10                	mov    %dl,(%rax)
  800e6f:	0f b6 00             	movzbl (%rax),%eax
  800e72:	84 c0                	test   %al,%al
  800e74:	75 dc                	jne    800e52 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e7a:	c9                   	leaveq 
  800e7b:	c3                   	retq   

0000000000800e7c <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e7c:	55                   	push   %rbp
  800e7d:	48 89 e5             	mov    %rsp,%rbp
  800e80:	48 83 ec 20          	sub    $0x20,%rsp
  800e84:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e88:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e90:	48 89 c7             	mov    %rax,%rdi
  800e93:	48 b8 cd 0d 80 00 00 	movabs $0x800dcd,%rax
  800e9a:	00 00 00 
  800e9d:	ff d0                	callq  *%rax
  800e9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ea2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea5:	48 63 d0             	movslq %eax,%rdx
  800ea8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eac:	48 01 c2             	add    %rax,%rdx
  800eaf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800eb3:	48 89 c6             	mov    %rax,%rsi
  800eb6:	48 89 d7             	mov    %rdx,%rdi
  800eb9:	48 b8 39 0e 80 00 00 	movabs $0x800e39,%rax
  800ec0:	00 00 00 
  800ec3:	ff d0                	callq  *%rax
	return dst;
  800ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ec9:	c9                   	leaveq 
  800eca:	c3                   	retq   

0000000000800ecb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ecb:	55                   	push   %rbp
  800ecc:	48 89 e5             	mov    %rsp,%rbp
  800ecf:	48 83 ec 28          	sub    $0x28,%rsp
  800ed3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ed7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800edb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800edf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ee7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800eee:	00 
  800eef:	eb 2a                	jmp    800f1b <strncpy+0x50>
		*dst++ = *src;
  800ef1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ef9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800efd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f01:	0f b6 12             	movzbl (%rdx),%edx
  800f04:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f0a:	0f b6 00             	movzbl (%rax),%eax
  800f0d:	84 c0                	test   %al,%al
  800f0f:	74 05                	je     800f16 <strncpy+0x4b>
			src++;
  800f11:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f16:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f1f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f23:	72 cc                	jb     800ef1 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f29:	c9                   	leaveq 
  800f2a:	c3                   	retq   

0000000000800f2b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f2b:	55                   	push   %rbp
  800f2c:	48 89 e5             	mov    %rsp,%rbp
  800f2f:	48 83 ec 28          	sub    $0x28,%rsp
  800f33:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f37:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f3b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f43:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f47:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f4c:	74 3d                	je     800f8b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f4e:	eb 1d                	jmp    800f6d <strlcpy+0x42>
			*dst++ = *src++;
  800f50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f54:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f58:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f5c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f60:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f64:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f68:	0f b6 12             	movzbl (%rdx),%edx
  800f6b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f6d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f72:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f77:	74 0b                	je     800f84 <strlcpy+0x59>
  800f79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f7d:	0f b6 00             	movzbl (%rax),%eax
  800f80:	84 c0                	test   %al,%al
  800f82:	75 cc                	jne    800f50 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f88:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f8b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f93:	48 29 c2             	sub    %rax,%rdx
  800f96:	48 89 d0             	mov    %rdx,%rax
}
  800f99:	c9                   	leaveq 
  800f9a:	c3                   	retq   

0000000000800f9b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f9b:	55                   	push   %rbp
  800f9c:	48 89 e5             	mov    %rsp,%rbp
  800f9f:	48 83 ec 10          	sub    $0x10,%rsp
  800fa3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fa7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800fab:	eb 0a                	jmp    800fb7 <strcmp+0x1c>
		p++, q++;
  800fad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fb2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fbb:	0f b6 00             	movzbl (%rax),%eax
  800fbe:	84 c0                	test   %al,%al
  800fc0:	74 12                	je     800fd4 <strcmp+0x39>
  800fc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc6:	0f b6 10             	movzbl (%rax),%edx
  800fc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcd:	0f b6 00             	movzbl (%rax),%eax
  800fd0:	38 c2                	cmp    %al,%dl
  800fd2:	74 d9                	je     800fad <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fd8:	0f b6 00             	movzbl (%rax),%eax
  800fdb:	0f b6 d0             	movzbl %al,%edx
  800fde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe2:	0f b6 00             	movzbl (%rax),%eax
  800fe5:	0f b6 c0             	movzbl %al,%eax
  800fe8:	29 c2                	sub    %eax,%edx
  800fea:	89 d0                	mov    %edx,%eax
}
  800fec:	c9                   	leaveq 
  800fed:	c3                   	retq   

0000000000800fee <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fee:	55                   	push   %rbp
  800fef:	48 89 e5             	mov    %rsp,%rbp
  800ff2:	48 83 ec 18          	sub    $0x18,%rsp
  800ff6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800ffa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800ffe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801002:	eb 0f                	jmp    801013 <strncmp+0x25>
		n--, p++, q++;
  801004:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801009:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80100e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801013:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801018:	74 1d                	je     801037 <strncmp+0x49>
  80101a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80101e:	0f b6 00             	movzbl (%rax),%eax
  801021:	84 c0                	test   %al,%al
  801023:	74 12                	je     801037 <strncmp+0x49>
  801025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801029:	0f b6 10             	movzbl (%rax),%edx
  80102c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801030:	0f b6 00             	movzbl (%rax),%eax
  801033:	38 c2                	cmp    %al,%dl
  801035:	74 cd                	je     801004 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801037:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80103c:	75 07                	jne    801045 <strncmp+0x57>
		return 0;
  80103e:	b8 00 00 00 00       	mov    $0x0,%eax
  801043:	eb 18                	jmp    80105d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801045:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801049:	0f b6 00             	movzbl (%rax),%eax
  80104c:	0f b6 d0             	movzbl %al,%edx
  80104f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801053:	0f b6 00             	movzbl (%rax),%eax
  801056:	0f b6 c0             	movzbl %al,%eax
  801059:	29 c2                	sub    %eax,%edx
  80105b:	89 d0                	mov    %edx,%eax
}
  80105d:	c9                   	leaveq 
  80105e:	c3                   	retq   

000000000080105f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80105f:	55                   	push   %rbp
  801060:	48 89 e5             	mov    %rsp,%rbp
  801063:	48 83 ec 10          	sub    $0x10,%rsp
  801067:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80106b:	89 f0                	mov    %esi,%eax
  80106d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801070:	eb 17                	jmp    801089 <strchr+0x2a>
		if (*s == c)
  801072:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801076:	0f b6 00             	movzbl (%rax),%eax
  801079:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80107c:	75 06                	jne    801084 <strchr+0x25>
			return (char *) s;
  80107e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801082:	eb 15                	jmp    801099 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801084:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801089:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108d:	0f b6 00             	movzbl (%rax),%eax
  801090:	84 c0                	test   %al,%al
  801092:	75 de                	jne    801072 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801094:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801099:	c9                   	leaveq 
  80109a:	c3                   	retq   

000000000080109b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80109b:	55                   	push   %rbp
  80109c:	48 89 e5             	mov    %rsp,%rbp
  80109f:	48 83 ec 10          	sub    $0x10,%rsp
  8010a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010a7:	89 f0                	mov    %esi,%eax
  8010a9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010ac:	eb 11                	jmp    8010bf <strfind+0x24>
		if (*s == c)
  8010ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b2:	0f b6 00             	movzbl (%rax),%eax
  8010b5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010b8:	74 12                	je     8010cc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c3:	0f b6 00             	movzbl (%rax),%eax
  8010c6:	84 c0                	test   %al,%al
  8010c8:	75 e4                	jne    8010ae <strfind+0x13>
  8010ca:	eb 01                	jmp    8010cd <strfind+0x32>
		if (*s == c)
			break;
  8010cc:	90                   	nop
	return (char *) s;
  8010cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010d1:	c9                   	leaveq 
  8010d2:	c3                   	retq   

00000000008010d3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010d3:	55                   	push   %rbp
  8010d4:	48 89 e5             	mov    %rsp,%rbp
  8010d7:	48 83 ec 18          	sub    $0x18,%rsp
  8010db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010df:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010e2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010e6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010eb:	75 06                	jne    8010f3 <memset+0x20>
		return v;
  8010ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f1:	eb 69                	jmp    80115c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f7:	83 e0 03             	and    $0x3,%eax
  8010fa:	48 85 c0             	test   %rax,%rax
  8010fd:	75 48                	jne    801147 <memset+0x74>
  8010ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801103:	83 e0 03             	and    $0x3,%eax
  801106:	48 85 c0             	test   %rax,%rax
  801109:	75 3c                	jne    801147 <memset+0x74>
		c &= 0xFF;
  80110b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801112:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801115:	c1 e0 18             	shl    $0x18,%eax
  801118:	89 c2                	mov    %eax,%edx
  80111a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80111d:	c1 e0 10             	shl    $0x10,%eax
  801120:	09 c2                	or     %eax,%edx
  801122:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801125:	c1 e0 08             	shl    $0x8,%eax
  801128:	09 d0                	or     %edx,%eax
  80112a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80112d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801131:	48 c1 e8 02          	shr    $0x2,%rax
  801135:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801138:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80113c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80113f:	48 89 d7             	mov    %rdx,%rdi
  801142:	fc                   	cld    
  801143:	f3 ab                	rep stos %eax,%es:(%rdi)
  801145:	eb 11                	jmp    801158 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801147:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80114b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80114e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801152:	48 89 d7             	mov    %rdx,%rdi
  801155:	fc                   	cld    
  801156:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801158:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80115c:	c9                   	leaveq 
  80115d:	c3                   	retq   

000000000080115e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80115e:	55                   	push   %rbp
  80115f:	48 89 e5             	mov    %rsp,%rbp
  801162:	48 83 ec 28          	sub    $0x28,%rsp
  801166:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80116a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80116e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801172:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801176:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80117a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801182:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801186:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80118a:	0f 83 88 00 00 00    	jae    801218 <memmove+0xba>
  801190:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801194:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801198:	48 01 d0             	add    %rdx,%rax
  80119b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80119f:	76 77                	jbe    801218 <memmove+0xba>
		s += n;
  8011a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011a5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011ad:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b5:	83 e0 03             	and    $0x3,%eax
  8011b8:	48 85 c0             	test   %rax,%rax
  8011bb:	75 3b                	jne    8011f8 <memmove+0x9a>
  8011bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c1:	83 e0 03             	and    $0x3,%eax
  8011c4:	48 85 c0             	test   %rax,%rax
  8011c7:	75 2f                	jne    8011f8 <memmove+0x9a>
  8011c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011cd:	83 e0 03             	and    $0x3,%eax
  8011d0:	48 85 c0             	test   %rax,%rax
  8011d3:	75 23                	jne    8011f8 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d9:	48 83 e8 04          	sub    $0x4,%rax
  8011dd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011e1:	48 83 ea 04          	sub    $0x4,%rdx
  8011e5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011e9:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011ed:	48 89 c7             	mov    %rax,%rdi
  8011f0:	48 89 d6             	mov    %rdx,%rsi
  8011f3:	fd                   	std    
  8011f4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011f6:	eb 1d                	jmp    801215 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801200:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801204:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801208:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80120c:	48 89 d7             	mov    %rdx,%rdi
  80120f:	48 89 c1             	mov    %rax,%rcx
  801212:	fd                   	std    
  801213:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801215:	fc                   	cld    
  801216:	eb 57                	jmp    80126f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801218:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121c:	83 e0 03             	and    $0x3,%eax
  80121f:	48 85 c0             	test   %rax,%rax
  801222:	75 36                	jne    80125a <memmove+0xfc>
  801224:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801228:	83 e0 03             	and    $0x3,%eax
  80122b:	48 85 c0             	test   %rax,%rax
  80122e:	75 2a                	jne    80125a <memmove+0xfc>
  801230:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801234:	83 e0 03             	and    $0x3,%eax
  801237:	48 85 c0             	test   %rax,%rax
  80123a:	75 1e                	jne    80125a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80123c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801240:	48 c1 e8 02          	shr    $0x2,%rax
  801244:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80124f:	48 89 c7             	mov    %rax,%rdi
  801252:	48 89 d6             	mov    %rdx,%rsi
  801255:	fc                   	cld    
  801256:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801258:	eb 15                	jmp    80126f <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80125a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801262:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801266:	48 89 c7             	mov    %rax,%rdi
  801269:	48 89 d6             	mov    %rdx,%rsi
  80126c:	fc                   	cld    
  80126d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80126f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801273:	c9                   	leaveq 
  801274:	c3                   	retq   

0000000000801275 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801275:	55                   	push   %rbp
  801276:	48 89 e5             	mov    %rsp,%rbp
  801279:	48 83 ec 18          	sub    $0x18,%rsp
  80127d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801281:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801285:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801289:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80128d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801291:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801295:	48 89 ce             	mov    %rcx,%rsi
  801298:	48 89 c7             	mov    %rax,%rdi
  80129b:	48 b8 5e 11 80 00 00 	movabs $0x80115e,%rax
  8012a2:	00 00 00 
  8012a5:	ff d0                	callq  *%rax
}
  8012a7:	c9                   	leaveq 
  8012a8:	c3                   	retq   

00000000008012a9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012a9:	55                   	push   %rbp
  8012aa:	48 89 e5             	mov    %rsp,%rbp
  8012ad:	48 83 ec 28          	sub    $0x28,%rsp
  8012b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012cd:	eb 36                	jmp    801305 <memcmp+0x5c>
		if (*s1 != *s2)
  8012cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d3:	0f b6 10             	movzbl (%rax),%edx
  8012d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012da:	0f b6 00             	movzbl (%rax),%eax
  8012dd:	38 c2                	cmp    %al,%dl
  8012df:	74 1a                	je     8012fb <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e5:	0f b6 00             	movzbl (%rax),%eax
  8012e8:	0f b6 d0             	movzbl %al,%edx
  8012eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ef:	0f b6 00             	movzbl (%rax),%eax
  8012f2:	0f b6 c0             	movzbl %al,%eax
  8012f5:	29 c2                	sub    %eax,%edx
  8012f7:	89 d0                	mov    %edx,%eax
  8012f9:	eb 20                	jmp    80131b <memcmp+0x72>
		s1++, s2++;
  8012fb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801300:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801305:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801309:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80130d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801311:	48 85 c0             	test   %rax,%rax
  801314:	75 b9                	jne    8012cf <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801316:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131b:	c9                   	leaveq 
  80131c:	c3                   	retq   

000000000080131d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80131d:	55                   	push   %rbp
  80131e:	48 89 e5             	mov    %rsp,%rbp
  801321:	48 83 ec 28          	sub    $0x28,%rsp
  801325:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801329:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80132c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801330:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801334:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801338:	48 01 d0             	add    %rdx,%rax
  80133b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80133f:	eb 19                	jmp    80135a <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801341:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801345:	0f b6 00             	movzbl (%rax),%eax
  801348:	0f b6 d0             	movzbl %al,%edx
  80134b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80134e:	0f b6 c0             	movzbl %al,%eax
  801351:	39 c2                	cmp    %eax,%edx
  801353:	74 11                	je     801366 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801355:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80135a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801362:	72 dd                	jb     801341 <memfind+0x24>
  801364:	eb 01                	jmp    801367 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801366:	90                   	nop
	return (void *) s;
  801367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80136b:	c9                   	leaveq 
  80136c:	c3                   	retq   

000000000080136d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80136d:	55                   	push   %rbp
  80136e:	48 89 e5             	mov    %rsp,%rbp
  801371:	48 83 ec 38          	sub    $0x38,%rsp
  801375:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801379:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80137d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801380:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801387:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80138e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138f:	eb 05                	jmp    801396 <strtol+0x29>
		s++;
  801391:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801396:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139a:	0f b6 00             	movzbl (%rax),%eax
  80139d:	3c 20                	cmp    $0x20,%al
  80139f:	74 f0                	je     801391 <strtol+0x24>
  8013a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a5:	0f b6 00             	movzbl (%rax),%eax
  8013a8:	3c 09                	cmp    $0x9,%al
  8013aa:	74 e5                	je     801391 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b0:	0f b6 00             	movzbl (%rax),%eax
  8013b3:	3c 2b                	cmp    $0x2b,%al
  8013b5:	75 07                	jne    8013be <strtol+0x51>
		s++;
  8013b7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013bc:	eb 17                	jmp    8013d5 <strtol+0x68>
	else if (*s == '-')
  8013be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c2:	0f b6 00             	movzbl (%rax),%eax
  8013c5:	3c 2d                	cmp    $0x2d,%al
  8013c7:	75 0c                	jne    8013d5 <strtol+0x68>
		s++, neg = 1;
  8013c9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013d5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013d9:	74 06                	je     8013e1 <strtol+0x74>
  8013db:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013df:	75 28                	jne    801409 <strtol+0x9c>
  8013e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e5:	0f b6 00             	movzbl (%rax),%eax
  8013e8:	3c 30                	cmp    $0x30,%al
  8013ea:	75 1d                	jne    801409 <strtol+0x9c>
  8013ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f0:	48 83 c0 01          	add    $0x1,%rax
  8013f4:	0f b6 00             	movzbl (%rax),%eax
  8013f7:	3c 78                	cmp    $0x78,%al
  8013f9:	75 0e                	jne    801409 <strtol+0x9c>
		s += 2, base = 16;
  8013fb:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801400:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801407:	eb 2c                	jmp    801435 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801409:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80140d:	75 19                	jne    801428 <strtol+0xbb>
  80140f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801413:	0f b6 00             	movzbl (%rax),%eax
  801416:	3c 30                	cmp    $0x30,%al
  801418:	75 0e                	jne    801428 <strtol+0xbb>
		s++, base = 8;
  80141a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80141f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801426:	eb 0d                	jmp    801435 <strtol+0xc8>
	else if (base == 0)
  801428:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80142c:	75 07                	jne    801435 <strtol+0xc8>
		base = 10;
  80142e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801435:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801439:	0f b6 00             	movzbl (%rax),%eax
  80143c:	3c 2f                	cmp    $0x2f,%al
  80143e:	7e 1d                	jle    80145d <strtol+0xf0>
  801440:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801444:	0f b6 00             	movzbl (%rax),%eax
  801447:	3c 39                	cmp    $0x39,%al
  801449:	7f 12                	jg     80145d <strtol+0xf0>
			dig = *s - '0';
  80144b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144f:	0f b6 00             	movzbl (%rax),%eax
  801452:	0f be c0             	movsbl %al,%eax
  801455:	83 e8 30             	sub    $0x30,%eax
  801458:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80145b:	eb 4e                	jmp    8014ab <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80145d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801461:	0f b6 00             	movzbl (%rax),%eax
  801464:	3c 60                	cmp    $0x60,%al
  801466:	7e 1d                	jle    801485 <strtol+0x118>
  801468:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146c:	0f b6 00             	movzbl (%rax),%eax
  80146f:	3c 7a                	cmp    $0x7a,%al
  801471:	7f 12                	jg     801485 <strtol+0x118>
			dig = *s - 'a' + 10;
  801473:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801477:	0f b6 00             	movzbl (%rax),%eax
  80147a:	0f be c0             	movsbl %al,%eax
  80147d:	83 e8 57             	sub    $0x57,%eax
  801480:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801483:	eb 26                	jmp    8014ab <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801485:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801489:	0f b6 00             	movzbl (%rax),%eax
  80148c:	3c 40                	cmp    $0x40,%al
  80148e:	7e 47                	jle    8014d7 <strtol+0x16a>
  801490:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801494:	0f b6 00             	movzbl (%rax),%eax
  801497:	3c 5a                	cmp    $0x5a,%al
  801499:	7f 3c                	jg     8014d7 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80149b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149f:	0f b6 00             	movzbl (%rax),%eax
  8014a2:	0f be c0             	movsbl %al,%eax
  8014a5:	83 e8 37             	sub    $0x37,%eax
  8014a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014ae:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014b1:	7d 23                	jge    8014d6 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8014b3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014b8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014bb:	48 98                	cltq   
  8014bd:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014c2:	48 89 c2             	mov    %rax,%rdx
  8014c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014c8:	48 98                	cltq   
  8014ca:	48 01 d0             	add    %rdx,%rax
  8014cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014d1:	e9 5f ff ff ff       	jmpq   801435 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014d6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014d7:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014dc:	74 0b                	je     8014e9 <strtol+0x17c>
		*endptr = (char *) s;
  8014de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014e6:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014ed:	74 09                	je     8014f8 <strtol+0x18b>
  8014ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f3:	48 f7 d8             	neg    %rax
  8014f6:	eb 04                	jmp    8014fc <strtol+0x18f>
  8014f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014fc:	c9                   	leaveq 
  8014fd:	c3                   	retq   

00000000008014fe <strstr>:

char * strstr(const char *in, const char *str)
{
  8014fe:	55                   	push   %rbp
  8014ff:	48 89 e5             	mov    %rsp,%rbp
  801502:	48 83 ec 30          	sub    $0x30,%rsp
  801506:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80150a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80150e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801512:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801516:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80151a:	0f b6 00             	movzbl (%rax),%eax
  80151d:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801520:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801524:	75 06                	jne    80152c <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801526:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152a:	eb 6b                	jmp    801597 <strstr+0x99>

	len = strlen(str);
  80152c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801530:	48 89 c7             	mov    %rax,%rdi
  801533:	48 b8 cd 0d 80 00 00 	movabs $0x800dcd,%rax
  80153a:	00 00 00 
  80153d:	ff d0                	callq  *%rax
  80153f:	48 98                	cltq   
  801541:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801545:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801549:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80154d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801551:	0f b6 00             	movzbl (%rax),%eax
  801554:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801557:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80155b:	75 07                	jne    801564 <strstr+0x66>
				return (char *) 0;
  80155d:	b8 00 00 00 00       	mov    $0x0,%eax
  801562:	eb 33                	jmp    801597 <strstr+0x99>
		} while (sc != c);
  801564:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801568:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80156b:	75 d8                	jne    801545 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80156d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801571:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801579:	48 89 ce             	mov    %rcx,%rsi
  80157c:	48 89 c7             	mov    %rax,%rdi
  80157f:	48 b8 ee 0f 80 00 00 	movabs $0x800fee,%rax
  801586:	00 00 00 
  801589:	ff d0                	callq  *%rax
  80158b:	85 c0                	test   %eax,%eax
  80158d:	75 b6                	jne    801545 <strstr+0x47>

	return (char *) (in - 1);
  80158f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801593:	48 83 e8 01          	sub    $0x1,%rax
}
  801597:	c9                   	leaveq 
  801598:	c3                   	retq   

0000000000801599 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801599:	55                   	push   %rbp
  80159a:	48 89 e5             	mov    %rsp,%rbp
  80159d:	53                   	push   %rbx
  80159e:	48 83 ec 48          	sub    $0x48,%rsp
  8015a2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015a5:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015a8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015ac:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015b0:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015b4:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015b8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015bb:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015bf:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015c3:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015c7:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015cb:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015cf:	4c 89 c3             	mov    %r8,%rbx
  8015d2:	cd 30                	int    $0x30
  8015d4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015d8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015dc:	74 3e                	je     80161c <syscall+0x83>
  8015de:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015e3:	7e 37                	jle    80161c <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015e9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015ec:	49 89 d0             	mov    %rdx,%r8
  8015ef:	89 c1                	mov    %eax,%ecx
  8015f1:	48 ba 88 20 80 00 00 	movabs $0x802088,%rdx
  8015f8:	00 00 00 
  8015fb:	be 23 00 00 00       	mov    $0x23,%esi
  801600:	48 bf a5 20 80 00 00 	movabs $0x8020a5,%rdi
  801607:	00 00 00 
  80160a:	b8 00 00 00 00       	mov    $0x0,%eax
  80160f:	49 b9 0b 1b 80 00 00 	movabs $0x801b0b,%r9
  801616:	00 00 00 
  801619:	41 ff d1             	callq  *%r9

	return ret;
  80161c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801620:	48 83 c4 48          	add    $0x48,%rsp
  801624:	5b                   	pop    %rbx
  801625:	5d                   	pop    %rbp
  801626:	c3                   	retq   

0000000000801627 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801627:	55                   	push   %rbp
  801628:	48 89 e5             	mov    %rsp,%rbp
  80162b:	48 83 ec 10          	sub    $0x10,%rsp
  80162f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801633:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801637:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80163b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80163f:	48 83 ec 08          	sub    $0x8,%rsp
  801643:	6a 00                	pushq  $0x0
  801645:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80164b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801651:	48 89 d1             	mov    %rdx,%rcx
  801654:	48 89 c2             	mov    %rax,%rdx
  801657:	be 00 00 00 00       	mov    $0x0,%esi
  80165c:	bf 00 00 00 00       	mov    $0x0,%edi
  801661:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  801668:	00 00 00 
  80166b:	ff d0                	callq  *%rax
  80166d:	48 83 c4 10          	add    $0x10,%rsp
}
  801671:	90                   	nop
  801672:	c9                   	leaveq 
  801673:	c3                   	retq   

0000000000801674 <sys_cgetc>:

int
sys_cgetc(void)
{
  801674:	55                   	push   %rbp
  801675:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801678:	48 83 ec 08          	sub    $0x8,%rsp
  80167c:	6a 00                	pushq  $0x0
  80167e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801684:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80168a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80168f:	ba 00 00 00 00       	mov    $0x0,%edx
  801694:	be 00 00 00 00       	mov    $0x0,%esi
  801699:	bf 01 00 00 00       	mov    $0x1,%edi
  80169e:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  8016a5:	00 00 00 
  8016a8:	ff d0                	callq  *%rax
  8016aa:	48 83 c4 10          	add    $0x10,%rsp
}
  8016ae:	c9                   	leaveq 
  8016af:	c3                   	retq   

00000000008016b0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016b0:	55                   	push   %rbp
  8016b1:	48 89 e5             	mov    %rsp,%rbp
  8016b4:	48 83 ec 10          	sub    $0x10,%rsp
  8016b8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016be:	48 98                	cltq   
  8016c0:	48 83 ec 08          	sub    $0x8,%rsp
  8016c4:	6a 00                	pushq  $0x0
  8016c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016d7:	48 89 c2             	mov    %rax,%rdx
  8016da:	be 01 00 00 00       	mov    $0x1,%esi
  8016df:	bf 03 00 00 00       	mov    $0x3,%edi
  8016e4:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  8016eb:	00 00 00 
  8016ee:	ff d0                	callq  *%rax
  8016f0:	48 83 c4 10          	add    $0x10,%rsp
}
  8016f4:	c9                   	leaveq 
  8016f5:	c3                   	retq   

00000000008016f6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016f6:	55                   	push   %rbp
  8016f7:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016fa:	48 83 ec 08          	sub    $0x8,%rsp
  8016fe:	6a 00                	pushq  $0x0
  801700:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801706:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80170c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801711:	ba 00 00 00 00       	mov    $0x0,%edx
  801716:	be 00 00 00 00       	mov    $0x0,%esi
  80171b:	bf 02 00 00 00       	mov    $0x2,%edi
  801720:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  801727:	00 00 00 
  80172a:	ff d0                	callq  *%rax
  80172c:	48 83 c4 10          	add    $0x10,%rsp
}
  801730:	c9                   	leaveq 
  801731:	c3                   	retq   

0000000000801732 <sys_yield>:

void
sys_yield(void)
{
  801732:	55                   	push   %rbp
  801733:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801736:	48 83 ec 08          	sub    $0x8,%rsp
  80173a:	6a 00                	pushq  $0x0
  80173c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801742:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801748:	b9 00 00 00 00       	mov    $0x0,%ecx
  80174d:	ba 00 00 00 00       	mov    $0x0,%edx
  801752:	be 00 00 00 00       	mov    $0x0,%esi
  801757:	bf 0a 00 00 00       	mov    $0xa,%edi
  80175c:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  801763:	00 00 00 
  801766:	ff d0                	callq  *%rax
  801768:	48 83 c4 10          	add    $0x10,%rsp
}
  80176c:	90                   	nop
  80176d:	c9                   	leaveq 
  80176e:	c3                   	retq   

000000000080176f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80176f:	55                   	push   %rbp
  801770:	48 89 e5             	mov    %rsp,%rbp
  801773:	48 83 ec 10          	sub    $0x10,%rsp
  801777:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80177a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80177e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801781:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801784:	48 63 c8             	movslq %eax,%rcx
  801787:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80178b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80178e:	48 98                	cltq   
  801790:	48 83 ec 08          	sub    $0x8,%rsp
  801794:	6a 00                	pushq  $0x0
  801796:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80179c:	49 89 c8             	mov    %rcx,%r8
  80179f:	48 89 d1             	mov    %rdx,%rcx
  8017a2:	48 89 c2             	mov    %rax,%rdx
  8017a5:	be 01 00 00 00       	mov    $0x1,%esi
  8017aa:	bf 04 00 00 00       	mov    $0x4,%edi
  8017af:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  8017b6:	00 00 00 
  8017b9:	ff d0                	callq  *%rax
  8017bb:	48 83 c4 10          	add    $0x10,%rsp
}
  8017bf:	c9                   	leaveq 
  8017c0:	c3                   	retq   

00000000008017c1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017c1:	55                   	push   %rbp
  8017c2:	48 89 e5             	mov    %rsp,%rbp
  8017c5:	48 83 ec 20          	sub    $0x20,%rsp
  8017c9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017d0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017d3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017d7:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017db:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017de:	48 63 c8             	movslq %eax,%rcx
  8017e1:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017e8:	48 63 f0             	movslq %eax,%rsi
  8017eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017f2:	48 98                	cltq   
  8017f4:	48 83 ec 08          	sub    $0x8,%rsp
  8017f8:	51                   	push   %rcx
  8017f9:	49 89 f9             	mov    %rdi,%r9
  8017fc:	49 89 f0             	mov    %rsi,%r8
  8017ff:	48 89 d1             	mov    %rdx,%rcx
  801802:	48 89 c2             	mov    %rax,%rdx
  801805:	be 01 00 00 00       	mov    $0x1,%esi
  80180a:	bf 05 00 00 00       	mov    $0x5,%edi
  80180f:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  801816:	00 00 00 
  801819:	ff d0                	callq  *%rax
  80181b:	48 83 c4 10          	add    $0x10,%rsp
}
  80181f:	c9                   	leaveq 
  801820:	c3                   	retq   

0000000000801821 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801821:	55                   	push   %rbp
  801822:	48 89 e5             	mov    %rsp,%rbp
  801825:	48 83 ec 10          	sub    $0x10,%rsp
  801829:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80182c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801830:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801834:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801837:	48 98                	cltq   
  801839:	48 83 ec 08          	sub    $0x8,%rsp
  80183d:	6a 00                	pushq  $0x0
  80183f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801845:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80184b:	48 89 d1             	mov    %rdx,%rcx
  80184e:	48 89 c2             	mov    %rax,%rdx
  801851:	be 01 00 00 00       	mov    $0x1,%esi
  801856:	bf 06 00 00 00       	mov    $0x6,%edi
  80185b:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  801862:	00 00 00 
  801865:	ff d0                	callq  *%rax
  801867:	48 83 c4 10          	add    $0x10,%rsp
}
  80186b:	c9                   	leaveq 
  80186c:	c3                   	retq   

000000000080186d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80186d:	55                   	push   %rbp
  80186e:	48 89 e5             	mov    %rsp,%rbp
  801871:	48 83 ec 10          	sub    $0x10,%rsp
  801875:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801878:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80187b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80187e:	48 63 d0             	movslq %eax,%rdx
  801881:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801884:	48 98                	cltq   
  801886:	48 83 ec 08          	sub    $0x8,%rsp
  80188a:	6a 00                	pushq  $0x0
  80188c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801892:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801898:	48 89 d1             	mov    %rdx,%rcx
  80189b:	48 89 c2             	mov    %rax,%rdx
  80189e:	be 01 00 00 00       	mov    $0x1,%esi
  8018a3:	bf 08 00 00 00       	mov    $0x8,%edi
  8018a8:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  8018af:	00 00 00 
  8018b2:	ff d0                	callq  *%rax
  8018b4:	48 83 c4 10          	add    $0x10,%rsp
}
  8018b8:	c9                   	leaveq 
  8018b9:	c3                   	retq   

00000000008018ba <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018ba:	55                   	push   %rbp
  8018bb:	48 89 e5             	mov    %rsp,%rbp
  8018be:	48 83 ec 10          	sub    $0x10,%rsp
  8018c2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8018c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d0:	48 98                	cltq   
  8018d2:	48 83 ec 08          	sub    $0x8,%rsp
  8018d6:	6a 00                	pushq  $0x0
  8018d8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018e4:	48 89 d1             	mov    %rdx,%rcx
  8018e7:	48 89 c2             	mov    %rax,%rdx
  8018ea:	be 01 00 00 00       	mov    $0x1,%esi
  8018ef:	bf 09 00 00 00       	mov    $0x9,%edi
  8018f4:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  8018fb:	00 00 00 
  8018fe:	ff d0                	callq  *%rax
  801900:	48 83 c4 10          	add    $0x10,%rsp
}
  801904:	c9                   	leaveq 
  801905:	c3                   	retq   

0000000000801906 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801906:	55                   	push   %rbp
  801907:	48 89 e5             	mov    %rsp,%rbp
  80190a:	48 83 ec 20          	sub    $0x20,%rsp
  80190e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801911:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801915:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801919:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80191c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80191f:	48 63 f0             	movslq %eax,%rsi
  801922:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801926:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801929:	48 98                	cltq   
  80192b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80192f:	48 83 ec 08          	sub    $0x8,%rsp
  801933:	6a 00                	pushq  $0x0
  801935:	49 89 f1             	mov    %rsi,%r9
  801938:	49 89 c8             	mov    %rcx,%r8
  80193b:	48 89 d1             	mov    %rdx,%rcx
  80193e:	48 89 c2             	mov    %rax,%rdx
  801941:	be 00 00 00 00       	mov    $0x0,%esi
  801946:	bf 0b 00 00 00       	mov    $0xb,%edi
  80194b:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  801952:	00 00 00 
  801955:	ff d0                	callq  *%rax
  801957:	48 83 c4 10          	add    $0x10,%rsp
}
  80195b:	c9                   	leaveq 
  80195c:	c3                   	retq   

000000000080195d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80195d:	55                   	push   %rbp
  80195e:	48 89 e5             	mov    %rsp,%rbp
  801961:	48 83 ec 10          	sub    $0x10,%rsp
  801965:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801969:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80196d:	48 83 ec 08          	sub    $0x8,%rsp
  801971:	6a 00                	pushq  $0x0
  801973:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801979:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80197f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801984:	48 89 c2             	mov    %rax,%rdx
  801987:	be 01 00 00 00       	mov    $0x1,%esi
  80198c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801991:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  801998:	00 00 00 
  80199b:	ff d0                	callq  *%rax
  80199d:	48 83 c4 10          	add    $0x10,%rsp
}
  8019a1:	c9                   	leaveq 
  8019a2:	c3                   	retq   

00000000008019a3 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8019a3:	55                   	push   %rbp
  8019a4:	48 89 e5             	mov    %rsp,%rbp
  8019a7:	48 83 ec 20          	sub    $0x20,%rsp
  8019ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler==0) {
  8019af:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  8019b6:	00 00 00 
  8019b9:	48 8b 00             	mov    (%rax),%rax
  8019bc:	48 85 c0             	test   %rax,%rax
  8019bf:	0f 85 ae 00 00 00    	jne    801a73 <set_pgfault_handler+0xd0>
		//allocate space
		int result = sys_page_alloc(sys_getenvid(), (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  8019c5:	48 b8 f6 16 80 00 00 	movabs $0x8016f6,%rax
  8019cc:	00 00 00 
  8019cf:	ff d0                	callq  *%rax
  8019d1:	ba 07 00 00 00       	mov    $0x7,%edx
  8019d6:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8019db:	89 c7                	mov    %eax,%edi
  8019dd:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  8019e4:	00 00 00 
  8019e7:	ff d0                	callq  *%rax
  8019e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  8019ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019f0:	79 2a                	jns    801a1c <set_pgfault_handler+0x79>
			panic("sys_page_alloc for stack failed in setting page fault handler");
  8019f2:	48 ba b8 20 80 00 00 	movabs $0x8020b8,%rdx
  8019f9:	00 00 00 
  8019fc:	be 21 00 00 00       	mov    $0x21,%esi
  801a01:	48 bf f6 20 80 00 00 	movabs $0x8020f6,%rdi
  801a08:	00 00 00 
  801a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a10:	48 b9 0b 1b 80 00 00 	movabs $0x801b0b,%rcx
  801a17:	00 00 00 
  801a1a:	ff d1                	callq  *%rcx
		}

		//actual set upcall
		result = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801a1c:	48 b8 f6 16 80 00 00 	movabs $0x8016f6,%rax
  801a23:	00 00 00 
  801a26:	ff d0                	callq  *%rax
  801a28:	48 be 87 1a 80 00 00 	movabs $0x801a87,%rsi
  801a2f:	00 00 00 
  801a32:	89 c7                	mov    %eax,%edi
  801a34:	48 b8 ba 18 80 00 00 	movabs $0x8018ba,%rax
  801a3b:	00 00 00 
  801a3e:	ff d0                	callq  *%rax
  801a40:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  801a43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a47:	79 2a                	jns    801a73 <set_pgfault_handler+0xd0>
                        panic("setting upcall failed in setting page fault handler");
  801a49:	48 ba 08 21 80 00 00 	movabs $0x802108,%rdx
  801a50:	00 00 00 
  801a53:	be 27 00 00 00       	mov    $0x27,%esi
  801a58:	48 bf f6 20 80 00 00 	movabs $0x8020f6,%rdi
  801a5f:	00 00 00 
  801a62:	b8 00 00 00 00       	mov    $0x0,%eax
  801a67:	48 b9 0b 1b 80 00 00 	movabs $0x801b0b,%rcx
  801a6e:	00 00 00 
  801a71:	ff d1                	callq  *%rcx
                }
		//panic("set_pgfault_handler not implemented");
	}

	_pgfault_handler = handler;
  801a73:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801a7a:	00 00 00 
  801a7d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a81:	48 89 10             	mov    %rdx,(%rax)

}
  801a84:	90                   	nop
  801a85:	c9                   	leaveq 
  801a86:	c3                   	retq   

0000000000801a87 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  801a87:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  801a8a:	48 a1 10 30 80 00 00 	movabs 0x803010,%rax
  801a91:	00 00 00 
call *%rax
  801a94:	ff d0                	callq  *%rax
	//MAKE STACK CALCS for getting parameters
	//20 = size of stack
	//8 = size of word	

	//(20-3)*8=17*8=136
	movq 136(%rsp), %rax
  801a96:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  801a9d:	00 
	//(20-1)*8=152
	subq $8, 152(%rsp)
  801a9e:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  801aa5:	00 08 
	movq 152(%rsp), %rbx
  801aa7:	48 8b 9c 24 98 00 00 	mov    0x98(%rsp),%rbx
  801aae:	00 
	movq %rax, (%rbx)
  801aaf:	48 89 03             	mov    %rax,(%rbx)
	addq $16, %rsp
  801ab2:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
	
    	POPA_
  801ab6:	4c 8b 3c 24          	mov    (%rsp),%r15
  801aba:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801abf:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801ac4:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801ac9:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801ace:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801ad3:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801ad8:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801add:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801ae2:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801ae7:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801aec:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801af1:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801af6:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801afb:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801b00:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
	//https://www.felixcloutier.com/x86/POPF:POPFD:POPFQ.html
    	addq $8, %rsp
  801b04:	48 83 c4 08          	add    $0x8,%rsp
    	popfq	
  801b08:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    	popq %rsp
  801b09:	5c                   	pop    %rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    	ret
  801b0a:	c3                   	retq   

0000000000801b0b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b0b:	55                   	push   %rbp
  801b0c:	48 89 e5             	mov    %rsp,%rbp
  801b0f:	53                   	push   %rbx
  801b10:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801b17:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801b1e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801b24:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  801b2b:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801b32:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801b39:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801b40:	84 c0                	test   %al,%al
  801b42:	74 23                	je     801b67 <_panic+0x5c>
  801b44:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801b4b:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801b4f:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801b53:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801b57:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801b5b:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801b5f:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801b63:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801b67:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801b6e:	00 00 00 
  801b71:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801b78:	00 00 00 
  801b7b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801b7f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801b86:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801b8d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801b94:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  801b9b:	00 00 00 
  801b9e:	48 8b 18             	mov    (%rax),%rbx
  801ba1:	48 b8 f6 16 80 00 00 	movabs $0x8016f6,%rax
  801ba8:	00 00 00 
  801bab:	ff d0                	callq  *%rax
  801bad:	89 c6                	mov    %eax,%esi
  801baf:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  801bb5:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  801bbc:	41 89 d0             	mov    %edx,%r8d
  801bbf:	48 89 c1             	mov    %rax,%rcx
  801bc2:	48 89 da             	mov    %rbx,%rdx
  801bc5:	48 bf 40 21 80 00 00 	movabs $0x802140,%rdi
  801bcc:	00 00 00 
  801bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd4:	49 b9 a9 02 80 00 00 	movabs $0x8002a9,%r9
  801bdb:	00 00 00 
  801bde:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801be1:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801be8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801bef:	48 89 d6             	mov    %rdx,%rsi
  801bf2:	48 89 c7             	mov    %rax,%rdi
  801bf5:	48 b8 fd 01 80 00 00 	movabs $0x8001fd,%rax
  801bfc:	00 00 00 
  801bff:	ff d0                	callq  *%rax
	cprintf("\n");
  801c01:	48 bf 63 21 80 00 00 	movabs $0x802163,%rdi
  801c08:	00 00 00 
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c10:	48 ba a9 02 80 00 00 	movabs $0x8002a9,%rdx
  801c17:	00 00 00 
  801c1a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801c1c:	cc                   	int3   
  801c1d:	eb fd                	jmp    801c1c <_panic+0x111>
