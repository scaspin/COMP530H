
obj/user/pingpong:     file format elf64-x86-64


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
  80003c:	e8 08 01 00 00       	callq  800149 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 83 ec 28          	sub    $0x28,%rsp
  80004c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80004f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	envid_t who;

	if ((who = fork()) != 0) {
  800053:	48 b8 fd 1c 80 00 00 	movabs $0x801cfd,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800062:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800065:	85 c0                	test   %eax,%eax
  800067:	74 4e                	je     8000b7 <umain+0x74>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800069:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  80006c:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  800073:	00 00 00 
  800076:	ff d0                	callq  *%rax
  800078:	89 da                	mov    %ebx,%edx
  80007a:	89 c6                	mov    %eax,%esi
  80007c:	48 bf 20 25 80 00 00 	movabs $0x802520,%rdi
  800083:	00 00 00 
  800086:	b8 00 00 00 00       	mov    $0x0,%eax
  80008b:	48 b9 13 03 80 00 00 	movabs $0x800313,%rcx
  800092:	00 00 00 
  800095:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  800097:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80009a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	be 00 00 00 00       	mov    $0x0,%esi
  8000a9:	89 c7                	mov    %eax,%edi
  8000ab:	48 b8 8d 21 80 00 00 	movabs $0x80218d,%rax
  8000b2:	00 00 00 
  8000b5:	ff d0                	callq  *%rax
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  8000b7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 00 00 00       	mov    $0x0,%esi
  8000c5:	48 89 c7             	mov    %rax,%rdi
  8000c8:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  8000cf:	00 00 00 
  8000d2:	ff d0                	callq  *%rax
  8000d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000d7:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  8000da:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  8000e1:	00 00 00 
  8000e4:	ff d0                	callq  *%rax
  8000e6:	89 c6                	mov    %eax,%esi
  8000e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000eb:	89 d9                	mov    %ebx,%ecx
  8000ed:	89 c2                	mov    %eax,%edx
  8000ef:	48 bf 36 25 80 00 00 	movabs $0x802536,%rdi
  8000f6:	00 00 00 
  8000f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fe:	49 b8 13 03 80 00 00 	movabs $0x800313,%r8
  800105:	00 00 00 
  800108:	41 ff d0             	callq  *%r8
		if (i == 10)
  80010b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
  80010f:	74 2d                	je     80013e <umain+0xfb>
			return;
		i++;
  800111:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
		ipc_send(who, i, 0, 0);
  800115:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800118:	8b 75 ec             	mov    -0x14(%rbp),%esi
  80011b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800120:	ba 00 00 00 00       	mov    $0x0,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	48 b8 8d 21 80 00 00 	movabs $0x80218d,%rax
  80012e:	00 00 00 
  800131:	ff d0                	callq  *%rax
		if (i == 10)
  800133:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
  800137:	74 08                	je     800141 <umain+0xfe>
			return;
	}
  800139:	e9 79 ff ff ff       	jmpq   8000b7 <umain+0x74>

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
		if (i == 10)
			return;
  80013e:	90                   	nop
  80013f:	eb 01                	jmp    800142 <umain+0xff>
		i++;
		ipc_send(who, i, 0, 0);
		if (i == 10)
			return;
  800141:	90                   	nop
	}

}
  800142:	48 83 c4 28          	add    $0x28,%rsp
  800146:	5b                   	pop    %rbx
  800147:	5d                   	pop    %rbp
  800148:	c3                   	retq   

0000000000800149 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800149:	55                   	push   %rbp
  80014a:	48 89 e5             	mov    %rsp,%rbp
  80014d:	48 83 ec 10          	sub    $0x10,%rsp
  800151:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800154:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  800158:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  80015f:	00 00 00 
  800162:	ff d0                	callq  *%rax
  800164:	25 ff 03 00 00       	and    $0x3ff,%eax
  800169:	48 63 d0             	movslq %eax,%rdx
  80016c:	48 89 d0             	mov    %rdx,%rax
  80016f:	48 c1 e0 03          	shl    $0x3,%rax
  800173:	48 01 d0             	add    %rdx,%rax
  800176:	48 c1 e0 05          	shl    $0x5,%rax
  80017a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800181:	00 00 00 
  800184:	48 01 c2             	add    %rax,%rdx
  800187:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80018e:	00 00 00 
  800191:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800194:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800198:	7e 14                	jle    8001ae <libmain+0x65>
		binaryname = argv[0];
  80019a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80019e:	48 8b 10             	mov    (%rax),%rdx
  8001a1:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8001a8:	00 00 00 
  8001ab:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001b5:	48 89 d6             	mov    %rdx,%rsi
  8001b8:	89 c7                	mov    %eax,%edi
  8001ba:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001c1:	00 00 00 
  8001c4:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001c6:	48 b8 d5 01 80 00 00 	movabs $0x8001d5,%rax
  8001cd:	00 00 00 
  8001d0:	ff d0                	callq  *%rax
}
  8001d2:	90                   	nop
  8001d3:	c9                   	leaveq 
  8001d4:	c3                   	retq   

00000000008001d5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d5:	55                   	push   %rbp
  8001d6:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8001d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8001de:	48 b8 1a 17 80 00 00 	movabs $0x80171a,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
}
  8001ea:	90                   	nop
  8001eb:	5d                   	pop    %rbp
  8001ec:	c3                   	retq   

00000000008001ed <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001ed:	55                   	push   %rbp
  8001ee:	48 89 e5             	mov    %rsp,%rbp
  8001f1:	48 83 ec 10          	sub    $0x10,%rsp
  8001f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8001fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800200:	8b 00                	mov    (%rax),%eax
  800202:	8d 48 01             	lea    0x1(%rax),%ecx
  800205:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800209:	89 0a                	mov    %ecx,(%rdx)
  80020b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80020e:	89 d1                	mov    %edx,%ecx
  800210:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800214:	48 98                	cltq   
  800216:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80021a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80021e:	8b 00                	mov    (%rax),%eax
  800220:	3d ff 00 00 00       	cmp    $0xff,%eax
  800225:	75 2c                	jne    800253 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800227:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022b:	8b 00                	mov    (%rax),%eax
  80022d:	48 98                	cltq   
  80022f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800233:	48 83 c2 08          	add    $0x8,%rdx
  800237:	48 89 c6             	mov    %rax,%rsi
  80023a:	48 89 d7             	mov    %rdx,%rdi
  80023d:	48 b8 91 16 80 00 00 	movabs $0x801691,%rax
  800244:	00 00 00 
  800247:	ff d0                	callq  *%rax
        b->idx = 0;
  800249:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80024d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800253:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800257:	8b 40 04             	mov    0x4(%rax),%eax
  80025a:	8d 50 01             	lea    0x1(%rax),%edx
  80025d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800261:	89 50 04             	mov    %edx,0x4(%rax)
}
  800264:	90                   	nop
  800265:	c9                   	leaveq 
  800266:	c3                   	retq   

0000000000800267 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800267:	55                   	push   %rbp
  800268:	48 89 e5             	mov    %rsp,%rbp
  80026b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800272:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800279:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800280:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800287:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80028e:	48 8b 0a             	mov    (%rdx),%rcx
  800291:	48 89 08             	mov    %rcx,(%rax)
  800294:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800298:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80029c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002a0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002a4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002ab:	00 00 00 
    b.cnt = 0;
  8002ae:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002b5:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002b8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002bf:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002c6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002cd:	48 89 c6             	mov    %rax,%rsi
  8002d0:	48 bf ed 01 80 00 00 	movabs $0x8001ed,%rdi
  8002d7:	00 00 00 
  8002da:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  8002e1:	00 00 00 
  8002e4:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002e6:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002ec:	48 98                	cltq   
  8002ee:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002f5:	48 83 c2 08          	add    $0x8,%rdx
  8002f9:	48 89 c6             	mov    %rax,%rsi
  8002fc:	48 89 d7             	mov    %rdx,%rdi
  8002ff:	48 b8 91 16 80 00 00 	movabs $0x801691,%rax
  800306:	00 00 00 
  800309:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80030b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800311:	c9                   	leaveq 
  800312:	c3                   	retq   

0000000000800313 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800313:	55                   	push   %rbp
  800314:	48 89 e5             	mov    %rsp,%rbp
  800317:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80031e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800325:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80032c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800333:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80033a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800341:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800348:	84 c0                	test   %al,%al
  80034a:	74 20                	je     80036c <cprintf+0x59>
  80034c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800350:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800354:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800358:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80035c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800360:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800364:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800368:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80036c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800373:	00 00 00 
  800376:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80037d:	00 00 00 
  800380:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800384:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80038b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800392:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800399:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003a0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003a7:	48 8b 0a             	mov    (%rdx),%rcx
  8003aa:	48 89 08             	mov    %rcx,(%rax)
  8003ad:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003b1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003b5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003b9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003bd:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003c4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003cb:	48 89 d6             	mov    %rdx,%rsi
  8003ce:	48 89 c7             	mov    %rax,%rdi
  8003d1:	48 b8 67 02 80 00 00 	movabs $0x800267,%rax
  8003d8:	00 00 00 
  8003db:	ff d0                	callq  *%rax
  8003dd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003e3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003e9:	c9                   	leaveq 
  8003ea:	c3                   	retq   

00000000008003eb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003eb:	55                   	push   %rbp
  8003ec:	48 89 e5             	mov    %rsp,%rbp
  8003ef:	48 83 ec 30          	sub    $0x30,%rsp
  8003f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8003fb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8003ff:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800402:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800406:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80040a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80040d:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800411:	77 54                	ja     800467 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800413:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800416:	8d 78 ff             	lea    -0x1(%rax),%edi
  800419:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80041c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420:	ba 00 00 00 00       	mov    $0x0,%edx
  800425:	48 f7 f6             	div    %rsi
  800428:	49 89 c2             	mov    %rax,%r10
  80042b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80042e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800431:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800439:	41 89 c9             	mov    %ecx,%r9d
  80043c:	41 89 f8             	mov    %edi,%r8d
  80043f:	89 d1                	mov    %edx,%ecx
  800441:	4c 89 d2             	mov    %r10,%rdx
  800444:	48 89 c7             	mov    %rax,%rdi
  800447:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  80044e:	00 00 00 
  800451:	ff d0                	callq  *%rax
  800453:	eb 1c                	jmp    800471 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800455:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800459:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80045c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800460:	48 89 ce             	mov    %rcx,%rsi
  800463:	89 d7                	mov    %edx,%edi
  800465:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800467:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80046b:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80046f:	7f e4                	jg     800455 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800471:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800474:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800478:	ba 00 00 00 00       	mov    $0x0,%edx
  80047d:	48 f7 f1             	div    %rcx
  800480:	48 b8 b0 26 80 00 00 	movabs $0x8026b0,%rax
  800487:	00 00 00 
  80048a:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80048e:	0f be d0             	movsbl %al,%edx
  800491:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800495:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800499:	48 89 ce             	mov    %rcx,%rsi
  80049c:	89 d7                	mov    %edx,%edi
  80049e:	ff d0                	callq  *%rax
}
  8004a0:	90                   	nop
  8004a1:	c9                   	leaveq 
  8004a2:	c3                   	retq   

00000000008004a3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004a3:	55                   	push   %rbp
  8004a4:	48 89 e5             	mov    %rsp,%rbp
  8004a7:	48 83 ec 20          	sub    $0x20,%rsp
  8004ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004af:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004b2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004b6:	7e 4f                	jle    800507 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8004b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bc:	8b 00                	mov    (%rax),%eax
  8004be:	83 f8 30             	cmp    $0x30,%eax
  8004c1:	73 24                	jae    8004e7 <getuint+0x44>
  8004c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cf:	8b 00                	mov    (%rax),%eax
  8004d1:	89 c0                	mov    %eax,%eax
  8004d3:	48 01 d0             	add    %rdx,%rax
  8004d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004da:	8b 12                	mov    (%rdx),%edx
  8004dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e3:	89 0a                	mov    %ecx,(%rdx)
  8004e5:	eb 14                	jmp    8004fb <getuint+0x58>
  8004e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004eb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004ef:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8004f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004fb:	48 8b 00             	mov    (%rax),%rax
  8004fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800502:	e9 9d 00 00 00       	jmpq   8005a4 <getuint+0x101>
	else if (lflag)
  800507:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80050b:	74 4c                	je     800559 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80050d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800511:	8b 00                	mov    (%rax),%eax
  800513:	83 f8 30             	cmp    $0x30,%eax
  800516:	73 24                	jae    80053c <getuint+0x99>
  800518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800524:	8b 00                	mov    (%rax),%eax
  800526:	89 c0                	mov    %eax,%eax
  800528:	48 01 d0             	add    %rdx,%rax
  80052b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80052f:	8b 12                	mov    (%rdx),%edx
  800531:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800534:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800538:	89 0a                	mov    %ecx,(%rdx)
  80053a:	eb 14                	jmp    800550 <getuint+0xad>
  80053c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800540:	48 8b 40 08          	mov    0x8(%rax),%rax
  800544:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800548:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800550:	48 8b 00             	mov    (%rax),%rax
  800553:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800557:	eb 4b                	jmp    8005a4 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055d:	8b 00                	mov    (%rax),%eax
  80055f:	83 f8 30             	cmp    $0x30,%eax
  800562:	73 24                	jae    800588 <getuint+0xe5>
  800564:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800568:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80056c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800570:	8b 00                	mov    (%rax),%eax
  800572:	89 c0                	mov    %eax,%eax
  800574:	48 01 d0             	add    %rdx,%rax
  800577:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057b:	8b 12                	mov    (%rdx),%edx
  80057d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800580:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800584:	89 0a                	mov    %ecx,(%rdx)
  800586:	eb 14                	jmp    80059c <getuint+0xf9>
  800588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800590:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800594:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800598:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80059c:	8b 00                	mov    (%rax),%eax
  80059e:	89 c0                	mov    %eax,%eax
  8005a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005a8:	c9                   	leaveq 
  8005a9:	c3                   	retq   

00000000008005aa <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005aa:	55                   	push   %rbp
  8005ab:	48 89 e5             	mov    %rsp,%rbp
  8005ae:	48 83 ec 20          	sub    $0x20,%rsp
  8005b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005b6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005b9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005bd:	7e 4f                	jle    80060e <getint+0x64>
		x=va_arg(*ap, long long);
  8005bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c3:	8b 00                	mov    (%rax),%eax
  8005c5:	83 f8 30             	cmp    $0x30,%eax
  8005c8:	73 24                	jae    8005ee <getint+0x44>
  8005ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ce:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d6:	8b 00                	mov    (%rax),%eax
  8005d8:	89 c0                	mov    %eax,%eax
  8005da:	48 01 d0             	add    %rdx,%rax
  8005dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e1:	8b 12                	mov    (%rdx),%edx
  8005e3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ea:	89 0a                	mov    %ecx,(%rdx)
  8005ec:	eb 14                	jmp    800602 <getint+0x58>
  8005ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005f6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800602:	48 8b 00             	mov    (%rax),%rax
  800605:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800609:	e9 9d 00 00 00       	jmpq   8006ab <getint+0x101>
	else if (lflag)
  80060e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800612:	74 4c                	je     800660 <getint+0xb6>
		x=va_arg(*ap, long);
  800614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800618:	8b 00                	mov    (%rax),%eax
  80061a:	83 f8 30             	cmp    $0x30,%eax
  80061d:	73 24                	jae    800643 <getint+0x99>
  80061f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800623:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062b:	8b 00                	mov    (%rax),%eax
  80062d:	89 c0                	mov    %eax,%eax
  80062f:	48 01 d0             	add    %rdx,%rax
  800632:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800636:	8b 12                	mov    (%rdx),%edx
  800638:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80063b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063f:	89 0a                	mov    %ecx,(%rdx)
  800641:	eb 14                	jmp    800657 <getint+0xad>
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	48 8b 40 08          	mov    0x8(%rax),%rax
  80064b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80064f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800653:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800657:	48 8b 00             	mov    (%rax),%rax
  80065a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80065e:	eb 4b                	jmp    8006ab <getint+0x101>
	else
		x=va_arg(*ap, int);
  800660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800664:	8b 00                	mov    (%rax),%eax
  800666:	83 f8 30             	cmp    $0x30,%eax
  800669:	73 24                	jae    80068f <getint+0xe5>
  80066b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800677:	8b 00                	mov    (%rax),%eax
  800679:	89 c0                	mov    %eax,%eax
  80067b:	48 01 d0             	add    %rdx,%rax
  80067e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800682:	8b 12                	mov    (%rdx),%edx
  800684:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800687:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068b:	89 0a                	mov    %ecx,(%rdx)
  80068d:	eb 14                	jmp    8006a3 <getint+0xf9>
  80068f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800693:	48 8b 40 08          	mov    0x8(%rax),%rax
  800697:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80069b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006a3:	8b 00                	mov    (%rax),%eax
  8006a5:	48 98                	cltq   
  8006a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006af:	c9                   	leaveq 
  8006b0:	c3                   	retq   

00000000008006b1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006b1:	55                   	push   %rbp
  8006b2:	48 89 e5             	mov    %rsp,%rbp
  8006b5:	41 54                	push   %r12
  8006b7:	53                   	push   %rbx
  8006b8:	48 83 ec 60          	sub    $0x60,%rsp
  8006bc:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006c0:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006c4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006c8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006cc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006d0:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006d4:	48 8b 0a             	mov    (%rdx),%rcx
  8006d7:	48 89 08             	mov    %rcx,(%rax)
  8006da:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006de:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ea:	eb 17                	jmp    800703 <vprintfmt+0x52>
			if (ch == '\0')
  8006ec:	85 db                	test   %ebx,%ebx
  8006ee:	0f 84 b9 04 00 00    	je     800bad <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  8006f4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006fc:	48 89 d6             	mov    %rdx,%rsi
  8006ff:	89 df                	mov    %ebx,%edi
  800701:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800703:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800707:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80070b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80070f:	0f b6 00             	movzbl (%rax),%eax
  800712:	0f b6 d8             	movzbl %al,%ebx
  800715:	83 fb 25             	cmp    $0x25,%ebx
  800718:	75 d2                	jne    8006ec <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80071a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80071e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800725:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80072c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800733:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80073e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800742:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800746:	0f b6 00             	movzbl (%rax),%eax
  800749:	0f b6 d8             	movzbl %al,%ebx
  80074c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80074f:	83 f8 55             	cmp    $0x55,%eax
  800752:	0f 87 22 04 00 00    	ja     800b7a <vprintfmt+0x4c9>
  800758:	89 c0                	mov    %eax,%eax
  80075a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800761:	00 
  800762:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  800769:	00 00 00 
  80076c:	48 01 d0             	add    %rdx,%rax
  80076f:	48 8b 00             	mov    (%rax),%rax
  800772:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800774:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800778:	eb c0                	jmp    80073a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80077a:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80077e:	eb ba                	jmp    80073a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800780:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800787:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80078a:	89 d0                	mov    %edx,%eax
  80078c:	c1 e0 02             	shl    $0x2,%eax
  80078f:	01 d0                	add    %edx,%eax
  800791:	01 c0                	add    %eax,%eax
  800793:	01 d8                	add    %ebx,%eax
  800795:	83 e8 30             	sub    $0x30,%eax
  800798:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80079b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80079f:	0f b6 00             	movzbl (%rax),%eax
  8007a2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a8:	7e 60                	jle    80080a <vprintfmt+0x159>
  8007aa:	83 fb 39             	cmp    $0x39,%ebx
  8007ad:	7f 5b                	jg     80080a <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007af:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b4:	eb d1                	jmp    800787 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8007b6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b9:	83 f8 30             	cmp    $0x30,%eax
  8007bc:	73 17                	jae    8007d5 <vprintfmt+0x124>
  8007be:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8007c2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007c5:	89 d2                	mov    %edx,%edx
  8007c7:	48 01 d0             	add    %rdx,%rax
  8007ca:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007cd:	83 c2 08             	add    $0x8,%edx
  8007d0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007d3:	eb 0c                	jmp    8007e1 <vprintfmt+0x130>
  8007d5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8007d9:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8007dd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007e1:	8b 00                	mov    (%rax),%eax
  8007e3:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007e6:	eb 23                	jmp    80080b <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  8007e8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007ec:	0f 89 48 ff ff ff    	jns    80073a <vprintfmt+0x89>
				width = 0;
  8007f2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007f9:	e9 3c ff ff ff       	jmpq   80073a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007fe:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800805:	e9 30 ff ff ff       	jmpq   80073a <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80080a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80080b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80080f:	0f 89 25 ff ff ff    	jns    80073a <vprintfmt+0x89>
				width = precision, precision = -1;
  800815:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800818:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80081b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800822:	e9 13 ff ff ff       	jmpq   80073a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800827:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80082b:	e9 0a ff ff ff       	jmpq   80073a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800830:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800833:	83 f8 30             	cmp    $0x30,%eax
  800836:	73 17                	jae    80084f <vprintfmt+0x19e>
  800838:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80083c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80083f:	89 d2                	mov    %edx,%edx
  800841:	48 01 d0             	add    %rdx,%rax
  800844:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800847:	83 c2 08             	add    $0x8,%edx
  80084a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80084d:	eb 0c                	jmp    80085b <vprintfmt+0x1aa>
  80084f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800853:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800857:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80085b:	8b 10                	mov    (%rax),%edx
  80085d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800861:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800865:	48 89 ce             	mov    %rcx,%rsi
  800868:	89 d7                	mov    %edx,%edi
  80086a:	ff d0                	callq  *%rax
			break;
  80086c:	e9 37 03 00 00       	jmpq   800ba8 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800871:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800874:	83 f8 30             	cmp    $0x30,%eax
  800877:	73 17                	jae    800890 <vprintfmt+0x1df>
  800879:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80087d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800880:	89 d2                	mov    %edx,%edx
  800882:	48 01 d0             	add    %rdx,%rax
  800885:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800888:	83 c2 08             	add    $0x8,%edx
  80088b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80088e:	eb 0c                	jmp    80089c <vprintfmt+0x1eb>
  800890:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800894:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800898:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80089c:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80089e:	85 db                	test   %ebx,%ebx
  8008a0:	79 02                	jns    8008a4 <vprintfmt+0x1f3>
				err = -err;
  8008a2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008a4:	83 fb 15             	cmp    $0x15,%ebx
  8008a7:	7f 16                	jg     8008bf <vprintfmt+0x20e>
  8008a9:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  8008b0:	00 00 00 
  8008b3:	48 63 d3             	movslq %ebx,%rdx
  8008b6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008ba:	4d 85 e4             	test   %r12,%r12
  8008bd:	75 2e                	jne    8008ed <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  8008bf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008c3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008c7:	89 d9                	mov    %ebx,%ecx
  8008c9:	48 ba c1 26 80 00 00 	movabs $0x8026c1,%rdx
  8008d0:	00 00 00 
  8008d3:	48 89 c7             	mov    %rax,%rdi
  8008d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008db:	49 b8 b7 0b 80 00 00 	movabs $0x800bb7,%r8
  8008e2:	00 00 00 
  8008e5:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e8:	e9 bb 02 00 00       	jmpq   800ba8 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ed:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008f1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f5:	4c 89 e1             	mov    %r12,%rcx
  8008f8:	48 ba ca 26 80 00 00 	movabs $0x8026ca,%rdx
  8008ff:	00 00 00 
  800902:	48 89 c7             	mov    %rax,%rdi
  800905:	b8 00 00 00 00       	mov    $0x0,%eax
  80090a:	49 b8 b7 0b 80 00 00 	movabs $0x800bb7,%r8
  800911:	00 00 00 
  800914:	41 ff d0             	callq  *%r8
			break;
  800917:	e9 8c 02 00 00       	jmpq   800ba8 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80091c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091f:	83 f8 30             	cmp    $0x30,%eax
  800922:	73 17                	jae    80093b <vprintfmt+0x28a>
  800924:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800928:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80092b:	89 d2                	mov    %edx,%edx
  80092d:	48 01 d0             	add    %rdx,%rax
  800930:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800933:	83 c2 08             	add    $0x8,%edx
  800936:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800939:	eb 0c                	jmp    800947 <vprintfmt+0x296>
  80093b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80093f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800943:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800947:	4c 8b 20             	mov    (%rax),%r12
  80094a:	4d 85 e4             	test   %r12,%r12
  80094d:	75 0a                	jne    800959 <vprintfmt+0x2a8>
				p = "(null)";
  80094f:	49 bc cd 26 80 00 00 	movabs $0x8026cd,%r12
  800956:	00 00 00 
			if (width > 0 && padc != '-')
  800959:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80095d:	7e 78                	jle    8009d7 <vprintfmt+0x326>
  80095f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800963:	74 72                	je     8009d7 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800965:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800968:	48 98                	cltq   
  80096a:	48 89 c6             	mov    %rax,%rsi
  80096d:	4c 89 e7             	mov    %r12,%rdi
  800970:	48 b8 65 0e 80 00 00 	movabs $0x800e65,%rax
  800977:	00 00 00 
  80097a:	ff d0                	callq  *%rax
  80097c:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80097f:	eb 17                	jmp    800998 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800981:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800985:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800989:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098d:	48 89 ce             	mov    %rcx,%rsi
  800990:	89 d7                	mov    %edx,%edi
  800992:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800994:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800998:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80099c:	7f e3                	jg     800981 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80099e:	eb 37                	jmp    8009d7 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009a4:	74 1e                	je     8009c4 <vprintfmt+0x313>
  8009a6:	83 fb 1f             	cmp    $0x1f,%ebx
  8009a9:	7e 05                	jle    8009b0 <vprintfmt+0x2ff>
  8009ab:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ae:	7e 14                	jle    8009c4 <vprintfmt+0x313>
					putch('?', putdat);
  8009b0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009b4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b8:	48 89 d6             	mov    %rdx,%rsi
  8009bb:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009c0:	ff d0                	callq  *%rax
  8009c2:	eb 0f                	jmp    8009d3 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  8009c4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009c8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009cc:	48 89 d6             	mov    %rdx,%rsi
  8009cf:	89 df                	mov    %ebx,%edi
  8009d1:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009d7:	4c 89 e0             	mov    %r12,%rax
  8009da:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009de:	0f b6 00             	movzbl (%rax),%eax
  8009e1:	0f be d8             	movsbl %al,%ebx
  8009e4:	85 db                	test   %ebx,%ebx
  8009e6:	74 28                	je     800a10 <vprintfmt+0x35f>
  8009e8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009ec:	78 b2                	js     8009a0 <vprintfmt+0x2ef>
  8009ee:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009f2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009f6:	79 a8                	jns    8009a0 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f8:	eb 16                	jmp    800a10 <vprintfmt+0x35f>
				putch(' ', putdat);
  8009fa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009fe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a02:	48 89 d6             	mov    %rdx,%rsi
  800a05:	bf 20 00 00 00       	mov    $0x20,%edi
  800a0a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a10:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a14:	7f e4                	jg     8009fa <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800a16:	e9 8d 01 00 00       	jmpq   800ba8 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a1b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a1f:	be 03 00 00 00       	mov    $0x3,%esi
  800a24:	48 89 c7             	mov    %rax,%rdi
  800a27:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  800a2e:	00 00 00 
  800a31:	ff d0                	callq  *%rax
  800a33:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3b:	48 85 c0             	test   %rax,%rax
  800a3e:	79 1d                	jns    800a5d <vprintfmt+0x3ac>
				putch('-', putdat);
  800a40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a48:	48 89 d6             	mov    %rdx,%rsi
  800a4b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a50:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a56:	48 f7 d8             	neg    %rax
  800a59:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a5d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a64:	e9 d2 00 00 00       	jmpq   800b3b <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a69:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a6d:	be 03 00 00 00       	mov    $0x3,%esi
  800a72:	48 89 c7             	mov    %rax,%rdi
  800a75:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a7c:	00 00 00 
  800a7f:	ff d0                	callq  *%rax
  800a81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a85:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a8c:	e9 aa 00 00 00       	jmpq   800b3b <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800a91:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a95:	be 03 00 00 00       	mov    $0x3,%esi
  800a9a:	48 89 c7             	mov    %rax,%rdi
  800a9d:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800aa4:	00 00 00 
  800aa7:	ff d0                	callq  *%rax
  800aa9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800aad:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ab4:	e9 82 00 00 00       	jmpq   800b3b <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800ab9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800abd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac1:	48 89 d6             	mov    %rdx,%rsi
  800ac4:	bf 30 00 00 00       	mov    $0x30,%edi
  800ac9:	ff d0                	callq  *%rax
			putch('x', putdat);
  800acb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800acf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad3:	48 89 d6             	mov    %rdx,%rsi
  800ad6:	bf 78 00 00 00       	mov    $0x78,%edi
  800adb:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800add:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae0:	83 f8 30             	cmp    $0x30,%eax
  800ae3:	73 17                	jae    800afc <vprintfmt+0x44b>
  800ae5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ae9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aec:	89 d2                	mov    %edx,%edx
  800aee:	48 01 d0             	add    %rdx,%rax
  800af1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af4:	83 c2 08             	add    $0x8,%edx
  800af7:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800afa:	eb 0c                	jmp    800b08 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800afc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b00:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b04:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b08:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b0b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b0f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b16:	eb 23                	jmp    800b3b <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b18:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b1c:	be 03 00 00 00       	mov    $0x3,%esi
  800b21:	48 89 c7             	mov    %rax,%rdi
  800b24:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b2b:	00 00 00 
  800b2e:	ff d0                	callq  *%rax
  800b30:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b34:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b3b:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b40:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b43:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b46:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b4a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b52:	45 89 c1             	mov    %r8d,%r9d
  800b55:	41 89 f8             	mov    %edi,%r8d
  800b58:	48 89 c7             	mov    %rax,%rdi
  800b5b:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  800b62:	00 00 00 
  800b65:	ff d0                	callq  *%rax
			break;
  800b67:	eb 3f                	jmp    800ba8 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b69:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b71:	48 89 d6             	mov    %rdx,%rsi
  800b74:	89 df                	mov    %ebx,%edi
  800b76:	ff d0                	callq  *%rax
			break;
  800b78:	eb 2e                	jmp    800ba8 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b7a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b82:	48 89 d6             	mov    %rdx,%rsi
  800b85:	bf 25 00 00 00       	mov    $0x25,%edi
  800b8a:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b8c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b91:	eb 05                	jmp    800b98 <vprintfmt+0x4e7>
  800b93:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b98:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b9c:	48 83 e8 01          	sub    $0x1,%rax
  800ba0:	0f b6 00             	movzbl (%rax),%eax
  800ba3:	3c 25                	cmp    $0x25,%al
  800ba5:	75 ec                	jne    800b93 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800ba7:	90                   	nop
		}
	}
  800ba8:	e9 3d fb ff ff       	jmpq   8006ea <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bad:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bae:	48 83 c4 60          	add    $0x60,%rsp
  800bb2:	5b                   	pop    %rbx
  800bb3:	41 5c                	pop    %r12
  800bb5:	5d                   	pop    %rbp
  800bb6:	c3                   	retq   

0000000000800bb7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bb7:	55                   	push   %rbp
  800bb8:	48 89 e5             	mov    %rsp,%rbp
  800bbb:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bc2:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bc9:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bd0:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800bd7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800bde:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800be5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bec:	84 c0                	test   %al,%al
  800bee:	74 20                	je     800c10 <printfmt+0x59>
  800bf0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bf4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bf8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bfc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c00:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c04:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c08:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c0c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c10:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c17:	00 00 00 
  800c1a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c21:	00 00 00 
  800c24:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c28:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c2f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c36:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c3d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c44:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c4b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c52:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c59:	48 89 c7             	mov    %rax,%rdi
  800c5c:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  800c63:	00 00 00 
  800c66:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c68:	90                   	nop
  800c69:	c9                   	leaveq 
  800c6a:	c3                   	retq   

0000000000800c6b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c6b:	55                   	push   %rbp
  800c6c:	48 89 e5             	mov    %rsp,%rbp
  800c6f:	48 83 ec 10          	sub    $0x10,%rsp
  800c73:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c7e:	8b 40 10             	mov    0x10(%rax),%eax
  800c81:	8d 50 01             	lea    0x1(%rax),%edx
  800c84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c88:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8f:	48 8b 10             	mov    (%rax),%rdx
  800c92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c96:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c9a:	48 39 c2             	cmp    %rax,%rdx
  800c9d:	73 17                	jae    800cb6 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca3:	48 8b 00             	mov    (%rax),%rax
  800ca6:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800caa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cae:	48 89 0a             	mov    %rcx,(%rdx)
  800cb1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cb4:	88 10                	mov    %dl,(%rax)
}
  800cb6:	90                   	nop
  800cb7:	c9                   	leaveq 
  800cb8:	c3                   	retq   

0000000000800cb9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb9:	55                   	push   %rbp
  800cba:	48 89 e5             	mov    %rsp,%rbp
  800cbd:	48 83 ec 50          	sub    $0x50,%rsp
  800cc1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cc5:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cc8:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ccc:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cd0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cd4:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800cd8:	48 8b 0a             	mov    (%rdx),%rcx
  800cdb:	48 89 08             	mov    %rcx,(%rax)
  800cde:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ce2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ce6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cea:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cee:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cf2:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cf6:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cf9:	48 98                	cltq   
  800cfb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800cff:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d03:	48 01 d0             	add    %rdx,%rax
  800d06:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d0a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d11:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d16:	74 06                	je     800d1e <vsnprintf+0x65>
  800d18:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d1c:	7f 07                	jg     800d25 <vsnprintf+0x6c>
		return -E_INVAL;
  800d1e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d23:	eb 2f                	jmp    800d54 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d25:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d29:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d2d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d31:	48 89 c6             	mov    %rax,%rsi
  800d34:	48 bf 6b 0c 80 00 00 	movabs $0x800c6b,%rdi
  800d3b:	00 00 00 
  800d3e:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  800d45:	00 00 00 
  800d48:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d4a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d4e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d51:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d54:	c9                   	leaveq 
  800d55:	c3                   	retq   

0000000000800d56 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d56:	55                   	push   %rbp
  800d57:	48 89 e5             	mov    %rsp,%rbp
  800d5a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d61:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d68:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d6e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800d75:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d7c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d83:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d8a:	84 c0                	test   %al,%al
  800d8c:	74 20                	je     800dae <snprintf+0x58>
  800d8e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d92:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d96:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d9a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d9e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800da2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800da6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800daa:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800dae:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800db5:	00 00 00 
  800db8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800dbf:	00 00 00 
  800dc2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dc6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dcd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dd4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ddb:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800de2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800de9:	48 8b 0a             	mov    (%rdx),%rcx
  800dec:	48 89 08             	mov    %rcx,(%rax)
  800def:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800df3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800df7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dfb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800dff:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e06:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e0d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e13:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e1a:	48 89 c7             	mov    %rax,%rdi
  800e1d:	48 b8 b9 0c 80 00 00 	movabs $0x800cb9,%rax
  800e24:	00 00 00 
  800e27:	ff d0                	callq  *%rax
  800e29:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e2f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e35:	c9                   	leaveq 
  800e36:	c3                   	retq   

0000000000800e37 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e37:	55                   	push   %rbp
  800e38:	48 89 e5             	mov    %rsp,%rbp
  800e3b:	48 83 ec 18          	sub    $0x18,%rsp
  800e3f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e4a:	eb 09                	jmp    800e55 <strlen+0x1e>
		n++;
  800e4c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e50:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e59:	0f b6 00             	movzbl (%rax),%eax
  800e5c:	84 c0                	test   %al,%al
  800e5e:	75 ec                	jne    800e4c <strlen+0x15>
		n++;
	return n;
  800e60:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e63:	c9                   	leaveq 
  800e64:	c3                   	retq   

0000000000800e65 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e65:	55                   	push   %rbp
  800e66:	48 89 e5             	mov    %rsp,%rbp
  800e69:	48 83 ec 20          	sub    $0x20,%rsp
  800e6d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e71:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e7c:	eb 0e                	jmp    800e8c <strnlen+0x27>
		n++;
  800e7e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e82:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e87:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e8c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e91:	74 0b                	je     800e9e <strnlen+0x39>
  800e93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e97:	0f b6 00             	movzbl (%rax),%eax
  800e9a:	84 c0                	test   %al,%al
  800e9c:	75 e0                	jne    800e7e <strnlen+0x19>
		n++;
	return n;
  800e9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ea1:	c9                   	leaveq 
  800ea2:	c3                   	retq   

0000000000800ea3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ea3:	55                   	push   %rbp
  800ea4:	48 89 e5             	mov    %rsp,%rbp
  800ea7:	48 83 ec 20          	sub    $0x20,%rsp
  800eab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eaf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800eb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ebb:	90                   	nop
  800ebc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ec4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ec8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ecc:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ed0:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ed4:	0f b6 12             	movzbl (%rdx),%edx
  800ed7:	88 10                	mov    %dl,(%rax)
  800ed9:	0f b6 00             	movzbl (%rax),%eax
  800edc:	84 c0                	test   %al,%al
  800ede:	75 dc                	jne    800ebc <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ee0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ee4:	c9                   	leaveq 
  800ee5:	c3                   	retq   

0000000000800ee6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ee6:	55                   	push   %rbp
  800ee7:	48 89 e5             	mov    %rsp,%rbp
  800eea:	48 83 ec 20          	sub    $0x20,%rsp
  800eee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ef2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800ef6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efa:	48 89 c7             	mov    %rax,%rdi
  800efd:	48 b8 37 0e 80 00 00 	movabs $0x800e37,%rax
  800f04:	00 00 00 
  800f07:	ff d0                	callq  *%rax
  800f09:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f0f:	48 63 d0             	movslq %eax,%rdx
  800f12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f16:	48 01 c2             	add    %rax,%rdx
  800f19:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f1d:	48 89 c6             	mov    %rax,%rsi
  800f20:	48 89 d7             	mov    %rdx,%rdi
  800f23:	48 b8 a3 0e 80 00 00 	movabs $0x800ea3,%rax
  800f2a:	00 00 00 
  800f2d:	ff d0                	callq  *%rax
	return dst;
  800f2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f33:	c9                   	leaveq 
  800f34:	c3                   	retq   

0000000000800f35 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f35:	55                   	push   %rbp
  800f36:	48 89 e5             	mov    %rsp,%rbp
  800f39:	48 83 ec 28          	sub    $0x28,%rsp
  800f3d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f41:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f45:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f51:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f58:	00 
  800f59:	eb 2a                	jmp    800f85 <strncpy+0x50>
		*dst++ = *src;
  800f5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f63:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f67:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f6b:	0f b6 12             	movzbl (%rdx),%edx
  800f6e:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f74:	0f b6 00             	movzbl (%rax),%eax
  800f77:	84 c0                	test   %al,%al
  800f79:	74 05                	je     800f80 <strncpy+0x4b>
			src++;
  800f7b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f80:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f89:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f8d:	72 cc                	jb     800f5b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f93:	c9                   	leaveq 
  800f94:	c3                   	retq   

0000000000800f95 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f95:	55                   	push   %rbp
  800f96:	48 89 e5             	mov    %rsp,%rbp
  800f99:	48 83 ec 28          	sub    $0x28,%rsp
  800f9d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fa1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fa5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fb1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fb6:	74 3d                	je     800ff5 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fb8:	eb 1d                	jmp    800fd7 <strlcpy+0x42>
			*dst++ = *src++;
  800fba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fbe:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fc2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fc6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fca:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fce:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fd2:	0f b6 12             	movzbl (%rdx),%edx
  800fd5:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fd7:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fdc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fe1:	74 0b                	je     800fee <strlcpy+0x59>
  800fe3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fe7:	0f b6 00             	movzbl (%rax),%eax
  800fea:	84 c0                	test   %al,%al
  800fec:	75 cc                	jne    800fba <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff2:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800ff5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ff9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ffd:	48 29 c2             	sub    %rax,%rdx
  801000:	48 89 d0             	mov    %rdx,%rax
}
  801003:	c9                   	leaveq 
  801004:	c3                   	retq   

0000000000801005 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801005:	55                   	push   %rbp
  801006:	48 89 e5             	mov    %rsp,%rbp
  801009:	48 83 ec 10          	sub    $0x10,%rsp
  80100d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801011:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801015:	eb 0a                	jmp    801021 <strcmp+0x1c>
		p++, q++;
  801017:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80101c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801021:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801025:	0f b6 00             	movzbl (%rax),%eax
  801028:	84 c0                	test   %al,%al
  80102a:	74 12                	je     80103e <strcmp+0x39>
  80102c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801030:	0f b6 10             	movzbl (%rax),%edx
  801033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801037:	0f b6 00             	movzbl (%rax),%eax
  80103a:	38 c2                	cmp    %al,%dl
  80103c:	74 d9                	je     801017 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80103e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801042:	0f b6 00             	movzbl (%rax),%eax
  801045:	0f b6 d0             	movzbl %al,%edx
  801048:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80104c:	0f b6 00             	movzbl (%rax),%eax
  80104f:	0f b6 c0             	movzbl %al,%eax
  801052:	29 c2                	sub    %eax,%edx
  801054:	89 d0                	mov    %edx,%eax
}
  801056:	c9                   	leaveq 
  801057:	c3                   	retq   

0000000000801058 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801058:	55                   	push   %rbp
  801059:	48 89 e5             	mov    %rsp,%rbp
  80105c:	48 83 ec 18          	sub    $0x18,%rsp
  801060:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801064:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801068:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80106c:	eb 0f                	jmp    80107d <strncmp+0x25>
		n--, p++, q++;
  80106e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801073:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801078:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80107d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801082:	74 1d                	je     8010a1 <strncmp+0x49>
  801084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801088:	0f b6 00             	movzbl (%rax),%eax
  80108b:	84 c0                	test   %al,%al
  80108d:	74 12                	je     8010a1 <strncmp+0x49>
  80108f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801093:	0f b6 10             	movzbl (%rax),%edx
  801096:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80109a:	0f b6 00             	movzbl (%rax),%eax
  80109d:	38 c2                	cmp    %al,%dl
  80109f:	74 cd                	je     80106e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010a1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010a6:	75 07                	jne    8010af <strncmp+0x57>
		return 0;
  8010a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ad:	eb 18                	jmp    8010c7 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b3:	0f b6 00             	movzbl (%rax),%eax
  8010b6:	0f b6 d0             	movzbl %al,%edx
  8010b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010bd:	0f b6 00             	movzbl (%rax),%eax
  8010c0:	0f b6 c0             	movzbl %al,%eax
  8010c3:	29 c2                	sub    %eax,%edx
  8010c5:	89 d0                	mov    %edx,%eax
}
  8010c7:	c9                   	leaveq 
  8010c8:	c3                   	retq   

00000000008010c9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010c9:	55                   	push   %rbp
  8010ca:	48 89 e5             	mov    %rsp,%rbp
  8010cd:	48 83 ec 10          	sub    $0x10,%rsp
  8010d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010d5:	89 f0                	mov    %esi,%eax
  8010d7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010da:	eb 17                	jmp    8010f3 <strchr+0x2a>
		if (*s == c)
  8010dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e0:	0f b6 00             	movzbl (%rax),%eax
  8010e3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010e6:	75 06                	jne    8010ee <strchr+0x25>
			return (char *) s;
  8010e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ec:	eb 15                	jmp    801103 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f7:	0f b6 00             	movzbl (%rax),%eax
  8010fa:	84 c0                	test   %al,%al
  8010fc:	75 de                	jne    8010dc <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801103:	c9                   	leaveq 
  801104:	c3                   	retq   

0000000000801105 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801105:	55                   	push   %rbp
  801106:	48 89 e5             	mov    %rsp,%rbp
  801109:	48 83 ec 10          	sub    $0x10,%rsp
  80110d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801111:	89 f0                	mov    %esi,%eax
  801113:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801116:	eb 11                	jmp    801129 <strfind+0x24>
		if (*s == c)
  801118:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111c:	0f b6 00             	movzbl (%rax),%eax
  80111f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801122:	74 12                	je     801136 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801124:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801129:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112d:	0f b6 00             	movzbl (%rax),%eax
  801130:	84 c0                	test   %al,%al
  801132:	75 e4                	jne    801118 <strfind+0x13>
  801134:	eb 01                	jmp    801137 <strfind+0x32>
		if (*s == c)
			break;
  801136:	90                   	nop
	return (char *) s;
  801137:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80113b:	c9                   	leaveq 
  80113c:	c3                   	retq   

000000000080113d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80113d:	55                   	push   %rbp
  80113e:	48 89 e5             	mov    %rsp,%rbp
  801141:	48 83 ec 18          	sub    $0x18,%rsp
  801145:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801149:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80114c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801150:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801155:	75 06                	jne    80115d <memset+0x20>
		return v;
  801157:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115b:	eb 69                	jmp    8011c6 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80115d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801161:	83 e0 03             	and    $0x3,%eax
  801164:	48 85 c0             	test   %rax,%rax
  801167:	75 48                	jne    8011b1 <memset+0x74>
  801169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116d:	83 e0 03             	and    $0x3,%eax
  801170:	48 85 c0             	test   %rax,%rax
  801173:	75 3c                	jne    8011b1 <memset+0x74>
		c &= 0xFF;
  801175:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80117c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80117f:	c1 e0 18             	shl    $0x18,%eax
  801182:	89 c2                	mov    %eax,%edx
  801184:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801187:	c1 e0 10             	shl    $0x10,%eax
  80118a:	09 c2                	or     %eax,%edx
  80118c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80118f:	c1 e0 08             	shl    $0x8,%eax
  801192:	09 d0                	or     %edx,%eax
  801194:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801197:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119b:	48 c1 e8 02          	shr    $0x2,%rax
  80119f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011a2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011a9:	48 89 d7             	mov    %rdx,%rdi
  8011ac:	fc                   	cld    
  8011ad:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011af:	eb 11                	jmp    8011c2 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011b1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011bc:	48 89 d7             	mov    %rdx,%rdi
  8011bf:	fc                   	cld    
  8011c0:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011c6:	c9                   	leaveq 
  8011c7:	c3                   	retq   

00000000008011c8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011c8:	55                   	push   %rbp
  8011c9:	48 89 e5             	mov    %rsp,%rbp
  8011cc:	48 83 ec 28          	sub    $0x28,%rsp
  8011d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011f4:	0f 83 88 00 00 00    	jae    801282 <memmove+0xba>
  8011fa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801202:	48 01 d0             	add    %rdx,%rax
  801205:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801209:	76 77                	jbe    801282 <memmove+0xba>
		s += n;
  80120b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80120f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801213:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801217:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80121b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121f:	83 e0 03             	and    $0x3,%eax
  801222:	48 85 c0             	test   %rax,%rax
  801225:	75 3b                	jne    801262 <memmove+0x9a>
  801227:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122b:	83 e0 03             	and    $0x3,%eax
  80122e:	48 85 c0             	test   %rax,%rax
  801231:	75 2f                	jne    801262 <memmove+0x9a>
  801233:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801237:	83 e0 03             	and    $0x3,%eax
  80123a:	48 85 c0             	test   %rax,%rax
  80123d:	75 23                	jne    801262 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80123f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801243:	48 83 e8 04          	sub    $0x4,%rax
  801247:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80124b:	48 83 ea 04          	sub    $0x4,%rdx
  80124f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801253:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801257:	48 89 c7             	mov    %rax,%rdi
  80125a:	48 89 d6             	mov    %rdx,%rsi
  80125d:	fd                   	std    
  80125e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801260:	eb 1d                	jmp    80127f <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801262:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801266:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80126a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801272:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801276:	48 89 d7             	mov    %rdx,%rdi
  801279:	48 89 c1             	mov    %rax,%rcx
  80127c:	fd                   	std    
  80127d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80127f:	fc                   	cld    
  801280:	eb 57                	jmp    8012d9 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801282:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801286:	83 e0 03             	and    $0x3,%eax
  801289:	48 85 c0             	test   %rax,%rax
  80128c:	75 36                	jne    8012c4 <memmove+0xfc>
  80128e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801292:	83 e0 03             	and    $0x3,%eax
  801295:	48 85 c0             	test   %rax,%rax
  801298:	75 2a                	jne    8012c4 <memmove+0xfc>
  80129a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80129e:	83 e0 03             	and    $0x3,%eax
  8012a1:	48 85 c0             	test   %rax,%rax
  8012a4:	75 1e                	jne    8012c4 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012aa:	48 c1 e8 02          	shr    $0x2,%rax
  8012ae:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012b9:	48 89 c7             	mov    %rax,%rdi
  8012bc:	48 89 d6             	mov    %rdx,%rsi
  8012bf:	fc                   	cld    
  8012c0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012c2:	eb 15                	jmp    8012d9 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012cc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012d0:	48 89 c7             	mov    %rax,%rdi
  8012d3:	48 89 d6             	mov    %rdx,%rsi
  8012d6:	fc                   	cld    
  8012d7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012dd:	c9                   	leaveq 
  8012de:	c3                   	retq   

00000000008012df <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012df:	55                   	push   %rbp
  8012e0:	48 89 e5             	mov    %rsp,%rbp
  8012e3:	48 83 ec 18          	sub    $0x18,%rsp
  8012e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012ef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012f7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ff:	48 89 ce             	mov    %rcx,%rsi
  801302:	48 89 c7             	mov    %rax,%rdi
  801305:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  80130c:	00 00 00 
  80130f:	ff d0                	callq  *%rax
}
  801311:	c9                   	leaveq 
  801312:	c3                   	retq   

0000000000801313 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801313:	55                   	push   %rbp
  801314:	48 89 e5             	mov    %rsp,%rbp
  801317:	48 83 ec 28          	sub    $0x28,%rsp
  80131b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80131f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801323:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80132f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801333:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801337:	eb 36                	jmp    80136f <memcmp+0x5c>
		if (*s1 != *s2)
  801339:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133d:	0f b6 10             	movzbl (%rax),%edx
  801340:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801344:	0f b6 00             	movzbl (%rax),%eax
  801347:	38 c2                	cmp    %al,%dl
  801349:	74 1a                	je     801365 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80134b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134f:	0f b6 00             	movzbl (%rax),%eax
  801352:	0f b6 d0             	movzbl %al,%edx
  801355:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801359:	0f b6 00             	movzbl (%rax),%eax
  80135c:	0f b6 c0             	movzbl %al,%eax
  80135f:	29 c2                	sub    %eax,%edx
  801361:	89 d0                	mov    %edx,%eax
  801363:	eb 20                	jmp    801385 <memcmp+0x72>
		s1++, s2++;
  801365:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80136a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80136f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801373:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801377:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80137b:	48 85 c0             	test   %rax,%rax
  80137e:	75 b9                	jne    801339 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801380:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801385:	c9                   	leaveq 
  801386:	c3                   	retq   

0000000000801387 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801387:	55                   	push   %rbp
  801388:	48 89 e5             	mov    %rsp,%rbp
  80138b:	48 83 ec 28          	sub    $0x28,%rsp
  80138f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801393:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801396:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80139a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80139e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a2:	48 01 d0             	add    %rdx,%rax
  8013a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013a9:	eb 19                	jmp    8013c4 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013af:	0f b6 00             	movzbl (%rax),%eax
  8013b2:	0f b6 d0             	movzbl %al,%edx
  8013b5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013b8:	0f b6 c0             	movzbl %al,%eax
  8013bb:	39 c2                	cmp    %eax,%edx
  8013bd:	74 11                	je     8013d0 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013bf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c8:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013cc:	72 dd                	jb     8013ab <memfind+0x24>
  8013ce:	eb 01                	jmp    8013d1 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013d0:	90                   	nop
	return (void *) s;
  8013d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013d5:	c9                   	leaveq 
  8013d6:	c3                   	retq   

00000000008013d7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013d7:	55                   	push   %rbp
  8013d8:	48 89 e5             	mov    %rsp,%rbp
  8013db:	48 83 ec 38          	sub    $0x38,%rsp
  8013df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013e7:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013f1:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013f8:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013f9:	eb 05                	jmp    801400 <strtol+0x29>
		s++;
  8013fb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801400:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801404:	0f b6 00             	movzbl (%rax),%eax
  801407:	3c 20                	cmp    $0x20,%al
  801409:	74 f0                	je     8013fb <strtol+0x24>
  80140b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140f:	0f b6 00             	movzbl (%rax),%eax
  801412:	3c 09                	cmp    $0x9,%al
  801414:	74 e5                	je     8013fb <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801416:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141a:	0f b6 00             	movzbl (%rax),%eax
  80141d:	3c 2b                	cmp    $0x2b,%al
  80141f:	75 07                	jne    801428 <strtol+0x51>
		s++;
  801421:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801426:	eb 17                	jmp    80143f <strtol+0x68>
	else if (*s == '-')
  801428:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142c:	0f b6 00             	movzbl (%rax),%eax
  80142f:	3c 2d                	cmp    $0x2d,%al
  801431:	75 0c                	jne    80143f <strtol+0x68>
		s++, neg = 1;
  801433:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801438:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80143f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801443:	74 06                	je     80144b <strtol+0x74>
  801445:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801449:	75 28                	jne    801473 <strtol+0x9c>
  80144b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144f:	0f b6 00             	movzbl (%rax),%eax
  801452:	3c 30                	cmp    $0x30,%al
  801454:	75 1d                	jne    801473 <strtol+0x9c>
  801456:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145a:	48 83 c0 01          	add    $0x1,%rax
  80145e:	0f b6 00             	movzbl (%rax),%eax
  801461:	3c 78                	cmp    $0x78,%al
  801463:	75 0e                	jne    801473 <strtol+0x9c>
		s += 2, base = 16;
  801465:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80146a:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801471:	eb 2c                	jmp    80149f <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801473:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801477:	75 19                	jne    801492 <strtol+0xbb>
  801479:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147d:	0f b6 00             	movzbl (%rax),%eax
  801480:	3c 30                	cmp    $0x30,%al
  801482:	75 0e                	jne    801492 <strtol+0xbb>
		s++, base = 8;
  801484:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801489:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801490:	eb 0d                	jmp    80149f <strtol+0xc8>
	else if (base == 0)
  801492:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801496:	75 07                	jne    80149f <strtol+0xc8>
		base = 10;
  801498:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80149f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a3:	0f b6 00             	movzbl (%rax),%eax
  8014a6:	3c 2f                	cmp    $0x2f,%al
  8014a8:	7e 1d                	jle    8014c7 <strtol+0xf0>
  8014aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ae:	0f b6 00             	movzbl (%rax),%eax
  8014b1:	3c 39                	cmp    $0x39,%al
  8014b3:	7f 12                	jg     8014c7 <strtol+0xf0>
			dig = *s - '0';
  8014b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b9:	0f b6 00             	movzbl (%rax),%eax
  8014bc:	0f be c0             	movsbl %al,%eax
  8014bf:	83 e8 30             	sub    $0x30,%eax
  8014c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014c5:	eb 4e                	jmp    801515 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cb:	0f b6 00             	movzbl (%rax),%eax
  8014ce:	3c 60                	cmp    $0x60,%al
  8014d0:	7e 1d                	jle    8014ef <strtol+0x118>
  8014d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d6:	0f b6 00             	movzbl (%rax),%eax
  8014d9:	3c 7a                	cmp    $0x7a,%al
  8014db:	7f 12                	jg     8014ef <strtol+0x118>
			dig = *s - 'a' + 10;
  8014dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e1:	0f b6 00             	movzbl (%rax),%eax
  8014e4:	0f be c0             	movsbl %al,%eax
  8014e7:	83 e8 57             	sub    $0x57,%eax
  8014ea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014ed:	eb 26                	jmp    801515 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f3:	0f b6 00             	movzbl (%rax),%eax
  8014f6:	3c 40                	cmp    $0x40,%al
  8014f8:	7e 47                	jle    801541 <strtol+0x16a>
  8014fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fe:	0f b6 00             	movzbl (%rax),%eax
  801501:	3c 5a                	cmp    $0x5a,%al
  801503:	7f 3c                	jg     801541 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801505:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801509:	0f b6 00             	movzbl (%rax),%eax
  80150c:	0f be c0             	movsbl %al,%eax
  80150f:	83 e8 37             	sub    $0x37,%eax
  801512:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801515:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801518:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80151b:	7d 23                	jge    801540 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80151d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801522:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801525:	48 98                	cltq   
  801527:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80152c:	48 89 c2             	mov    %rax,%rdx
  80152f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801532:	48 98                	cltq   
  801534:	48 01 d0             	add    %rdx,%rax
  801537:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80153b:	e9 5f ff ff ff       	jmpq   80149f <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801540:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801541:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801546:	74 0b                	je     801553 <strtol+0x17c>
		*endptr = (char *) s;
  801548:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80154c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801550:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801553:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801557:	74 09                	je     801562 <strtol+0x18b>
  801559:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80155d:	48 f7 d8             	neg    %rax
  801560:	eb 04                	jmp    801566 <strtol+0x18f>
  801562:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801566:	c9                   	leaveq 
  801567:	c3                   	retq   

0000000000801568 <strstr>:

char * strstr(const char *in, const char *str)
{
  801568:	55                   	push   %rbp
  801569:	48 89 e5             	mov    %rsp,%rbp
  80156c:	48 83 ec 30          	sub    $0x30,%rsp
  801570:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801574:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801578:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80157c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801580:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801584:	0f b6 00             	movzbl (%rax),%eax
  801587:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80158a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80158e:	75 06                	jne    801596 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801590:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801594:	eb 6b                	jmp    801601 <strstr+0x99>

	len = strlen(str);
  801596:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80159a:	48 89 c7             	mov    %rax,%rdi
  80159d:	48 b8 37 0e 80 00 00 	movabs $0x800e37,%rax
  8015a4:	00 00 00 
  8015a7:	ff d0                	callq  *%rax
  8015a9:	48 98                	cltq   
  8015ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015bb:	0f b6 00             	movzbl (%rax),%eax
  8015be:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015c1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015c5:	75 07                	jne    8015ce <strstr+0x66>
				return (char *) 0;
  8015c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015cc:	eb 33                	jmp    801601 <strstr+0x99>
		} while (sc != c);
  8015ce:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015d2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015d5:	75 d8                	jne    8015af <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8015d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015db:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e3:	48 89 ce             	mov    %rcx,%rsi
  8015e6:	48 89 c7             	mov    %rax,%rdi
  8015e9:	48 b8 58 10 80 00 00 	movabs $0x801058,%rax
  8015f0:	00 00 00 
  8015f3:	ff d0                	callq  *%rax
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	75 b6                	jne    8015af <strstr+0x47>

	return (char *) (in - 1);
  8015f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fd:	48 83 e8 01          	sub    $0x1,%rax
}
  801601:	c9                   	leaveq 
  801602:	c3                   	retq   

0000000000801603 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801603:	55                   	push   %rbp
  801604:	48 89 e5             	mov    %rsp,%rbp
  801607:	53                   	push   %rbx
  801608:	48 83 ec 48          	sub    $0x48,%rsp
  80160c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80160f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801612:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801616:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80161a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80161e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801622:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801625:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801629:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80162d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801631:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801635:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801639:	4c 89 c3             	mov    %r8,%rbx
  80163c:	cd 30                	int    $0x30
  80163e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801642:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801646:	74 3e                	je     801686 <syscall+0x83>
  801648:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80164d:	7e 37                	jle    801686 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80164f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801653:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801656:	49 89 d0             	mov    %rdx,%r8
  801659:	89 c1                	mov    %eax,%ecx
  80165b:	48 ba 88 29 80 00 00 	movabs $0x802988,%rdx
  801662:	00 00 00 
  801665:	be 23 00 00 00       	mov    $0x23,%esi
  80166a:	48 bf a5 29 80 00 00 	movabs $0x8029a5,%rdi
  801671:	00 00 00 
  801674:	b8 00 00 00 00       	mov    $0x0,%eax
  801679:	49 b9 a0 22 80 00 00 	movabs $0x8022a0,%r9
  801680:	00 00 00 
  801683:	41 ff d1             	callq  *%r9

	return ret;
  801686:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80168a:	48 83 c4 48          	add    $0x48,%rsp
  80168e:	5b                   	pop    %rbx
  80168f:	5d                   	pop    %rbp
  801690:	c3                   	retq   

0000000000801691 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801691:	55                   	push   %rbp
  801692:	48 89 e5             	mov    %rsp,%rbp
  801695:	48 83 ec 10          	sub    $0x10,%rsp
  801699:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80169d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016a9:	48 83 ec 08          	sub    $0x8,%rsp
  8016ad:	6a 00                	pushq  $0x0
  8016af:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016bb:	48 89 d1             	mov    %rdx,%rcx
  8016be:	48 89 c2             	mov    %rax,%rdx
  8016c1:	be 00 00 00 00       	mov    $0x0,%esi
  8016c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8016cb:	48 b8 03 16 80 00 00 	movabs $0x801603,%rax
  8016d2:	00 00 00 
  8016d5:	ff d0                	callq  *%rax
  8016d7:	48 83 c4 10          	add    $0x10,%rsp
}
  8016db:	90                   	nop
  8016dc:	c9                   	leaveq 
  8016dd:	c3                   	retq   

00000000008016de <sys_cgetc>:

int
sys_cgetc(void)
{
  8016de:	55                   	push   %rbp
  8016df:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016e2:	48 83 ec 08          	sub    $0x8,%rsp
  8016e6:	6a 00                	pushq  $0x0
  8016e8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fe:	be 00 00 00 00       	mov    $0x0,%esi
  801703:	bf 01 00 00 00       	mov    $0x1,%edi
  801708:	48 b8 03 16 80 00 00 	movabs $0x801603,%rax
  80170f:	00 00 00 
  801712:	ff d0                	callq  *%rax
  801714:	48 83 c4 10          	add    $0x10,%rsp
}
  801718:	c9                   	leaveq 
  801719:	c3                   	retq   

000000000080171a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80171a:	55                   	push   %rbp
  80171b:	48 89 e5             	mov    %rsp,%rbp
  80171e:	48 83 ec 10          	sub    $0x10,%rsp
  801722:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801725:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801728:	48 98                	cltq   
  80172a:	48 83 ec 08          	sub    $0x8,%rsp
  80172e:	6a 00                	pushq  $0x0
  801730:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801736:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80173c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801741:	48 89 c2             	mov    %rax,%rdx
  801744:	be 01 00 00 00       	mov    $0x1,%esi
  801749:	bf 03 00 00 00       	mov    $0x3,%edi
  80174e:	48 b8 03 16 80 00 00 	movabs $0x801603,%rax
  801755:	00 00 00 
  801758:	ff d0                	callq  *%rax
  80175a:	48 83 c4 10          	add    $0x10,%rsp
}
  80175e:	c9                   	leaveq 
  80175f:	c3                   	retq   

0000000000801760 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801760:	55                   	push   %rbp
  801761:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801764:	48 83 ec 08          	sub    $0x8,%rsp
  801768:	6a 00                	pushq  $0x0
  80176a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801770:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801776:	b9 00 00 00 00       	mov    $0x0,%ecx
  80177b:	ba 00 00 00 00       	mov    $0x0,%edx
  801780:	be 00 00 00 00       	mov    $0x0,%esi
  801785:	bf 02 00 00 00       	mov    $0x2,%edi
  80178a:	48 b8 03 16 80 00 00 	movabs $0x801603,%rax
  801791:	00 00 00 
  801794:	ff d0                	callq  *%rax
  801796:	48 83 c4 10          	add    $0x10,%rsp
}
  80179a:	c9                   	leaveq 
  80179b:	c3                   	retq   

000000000080179c <sys_yield>:

void
sys_yield(void)
{
  80179c:	55                   	push   %rbp
  80179d:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017a0:	48 83 ec 08          	sub    $0x8,%rsp
  8017a4:	6a 00                	pushq  $0x0
  8017a6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bc:	be 00 00 00 00       	mov    $0x0,%esi
  8017c1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8017c6:	48 b8 03 16 80 00 00 	movabs $0x801603,%rax
  8017cd:	00 00 00 
  8017d0:	ff d0                	callq  *%rax
  8017d2:	48 83 c4 10          	add    $0x10,%rsp
}
  8017d6:	90                   	nop
  8017d7:	c9                   	leaveq 
  8017d8:	c3                   	retq   

00000000008017d9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017d9:	55                   	push   %rbp
  8017da:	48 89 e5             	mov    %rsp,%rbp
  8017dd:	48 83 ec 10          	sub    $0x10,%rsp
  8017e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017e8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017ee:	48 63 c8             	movslq %eax,%rcx
  8017f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017f8:	48 98                	cltq   
  8017fa:	48 83 ec 08          	sub    $0x8,%rsp
  8017fe:	6a 00                	pushq  $0x0
  801800:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801806:	49 89 c8             	mov    %rcx,%r8
  801809:	48 89 d1             	mov    %rdx,%rcx
  80180c:	48 89 c2             	mov    %rax,%rdx
  80180f:	be 01 00 00 00       	mov    $0x1,%esi
  801814:	bf 04 00 00 00       	mov    $0x4,%edi
  801819:	48 b8 03 16 80 00 00 	movabs $0x801603,%rax
  801820:	00 00 00 
  801823:	ff d0                	callq  *%rax
  801825:	48 83 c4 10          	add    $0x10,%rsp
}
  801829:	c9                   	leaveq 
  80182a:	c3                   	retq   

000000000080182b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80182b:	55                   	push   %rbp
  80182c:	48 89 e5             	mov    %rsp,%rbp
  80182f:	48 83 ec 20          	sub    $0x20,%rsp
  801833:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801836:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80183a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80183d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801841:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801845:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801848:	48 63 c8             	movslq %eax,%rcx
  80184b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80184f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801852:	48 63 f0             	movslq %eax,%rsi
  801855:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801859:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80185c:	48 98                	cltq   
  80185e:	48 83 ec 08          	sub    $0x8,%rsp
  801862:	51                   	push   %rcx
  801863:	49 89 f9             	mov    %rdi,%r9
  801866:	49 89 f0             	mov    %rsi,%r8
  801869:	48 89 d1             	mov    %rdx,%rcx
  80186c:	48 89 c2             	mov    %rax,%rdx
  80186f:	be 01 00 00 00       	mov    $0x1,%esi
  801874:	bf 05 00 00 00       	mov    $0x5,%edi
  801879:	48 b8 03 16 80 00 00 	movabs $0x801603,%rax
  801880:	00 00 00 
  801883:	ff d0                	callq  *%rax
  801885:	48 83 c4 10          	add    $0x10,%rsp
}
  801889:	c9                   	leaveq 
  80188a:	c3                   	retq   

000000000080188b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80188b:	55                   	push   %rbp
  80188c:	48 89 e5             	mov    %rsp,%rbp
  80188f:	48 83 ec 10          	sub    $0x10,%rsp
  801893:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801896:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80189a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80189e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a1:	48 98                	cltq   
  8018a3:	48 83 ec 08          	sub    $0x8,%rsp
  8018a7:	6a 00                	pushq  $0x0
  8018a9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b5:	48 89 d1             	mov    %rdx,%rcx
  8018b8:	48 89 c2             	mov    %rax,%rdx
  8018bb:	be 01 00 00 00       	mov    $0x1,%esi
  8018c0:	bf 06 00 00 00       	mov    $0x6,%edi
  8018c5:	48 b8 03 16 80 00 00 	movabs $0x801603,%rax
  8018cc:	00 00 00 
  8018cf:	ff d0                	callq  *%rax
  8018d1:	48 83 c4 10          	add    $0x10,%rsp
}
  8018d5:	c9                   	leaveq 
  8018d6:	c3                   	retq   

00000000008018d7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018d7:	55                   	push   %rbp
  8018d8:	48 89 e5             	mov    %rsp,%rbp
  8018db:	48 83 ec 10          	sub    $0x10,%rsp
  8018df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018e2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018e8:	48 63 d0             	movslq %eax,%rdx
  8018eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ee:	48 98                	cltq   
  8018f0:	48 83 ec 08          	sub    $0x8,%rsp
  8018f4:	6a 00                	pushq  $0x0
  8018f6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801902:	48 89 d1             	mov    %rdx,%rcx
  801905:	48 89 c2             	mov    %rax,%rdx
  801908:	be 01 00 00 00       	mov    $0x1,%esi
  80190d:	bf 08 00 00 00       	mov    $0x8,%edi
  801912:	48 b8 03 16 80 00 00 	movabs $0x801603,%rax
  801919:	00 00 00 
  80191c:	ff d0                	callq  *%rax
  80191e:	48 83 c4 10          	add    $0x10,%rsp
}
  801922:	c9                   	leaveq 
  801923:	c3                   	retq   

0000000000801924 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801924:	55                   	push   %rbp
  801925:	48 89 e5             	mov    %rsp,%rbp
  801928:	48 83 ec 10          	sub    $0x10,%rsp
  80192c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80192f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801933:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801937:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80193a:	48 98                	cltq   
  80193c:	48 83 ec 08          	sub    $0x8,%rsp
  801940:	6a 00                	pushq  $0x0
  801942:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801948:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194e:	48 89 d1             	mov    %rdx,%rcx
  801951:	48 89 c2             	mov    %rax,%rdx
  801954:	be 01 00 00 00       	mov    $0x1,%esi
  801959:	bf 09 00 00 00       	mov    $0x9,%edi
  80195e:	48 b8 03 16 80 00 00 	movabs $0x801603,%rax
  801965:	00 00 00 
  801968:	ff d0                	callq  *%rax
  80196a:	48 83 c4 10          	add    $0x10,%rsp
}
  80196e:	c9                   	leaveq 
  80196f:	c3                   	retq   

0000000000801970 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801970:	55                   	push   %rbp
  801971:	48 89 e5             	mov    %rsp,%rbp
  801974:	48 83 ec 20          	sub    $0x20,%rsp
  801978:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80197b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80197f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801983:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801986:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801989:	48 63 f0             	movslq %eax,%rsi
  80198c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801990:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801993:	48 98                	cltq   
  801995:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801999:	48 83 ec 08          	sub    $0x8,%rsp
  80199d:	6a 00                	pushq  $0x0
  80199f:	49 89 f1             	mov    %rsi,%r9
  8019a2:	49 89 c8             	mov    %rcx,%r8
  8019a5:	48 89 d1             	mov    %rdx,%rcx
  8019a8:	48 89 c2             	mov    %rax,%rdx
  8019ab:	be 00 00 00 00       	mov    $0x0,%esi
  8019b0:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019b5:	48 b8 03 16 80 00 00 	movabs $0x801603,%rax
  8019bc:	00 00 00 
  8019bf:	ff d0                	callq  *%rax
  8019c1:	48 83 c4 10          	add    $0x10,%rsp
}
  8019c5:	c9                   	leaveq 
  8019c6:	c3                   	retq   

00000000008019c7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019c7:	55                   	push   %rbp
  8019c8:	48 89 e5             	mov    %rsp,%rbp
  8019cb:	48 83 ec 10          	sub    $0x10,%rsp
  8019cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d7:	48 83 ec 08          	sub    $0x8,%rsp
  8019db:	6a 00                	pushq  $0x0
  8019dd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ee:	48 89 c2             	mov    %rax,%rdx
  8019f1:	be 01 00 00 00       	mov    $0x1,%esi
  8019f6:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019fb:	48 b8 03 16 80 00 00 	movabs $0x801603,%rax
  801a02:	00 00 00 
  801a05:	ff d0                	callq  *%rax
  801a07:	48 83 c4 10          	add    $0x10,%rsp
}
  801a0b:	c9                   	leaveq 
  801a0c:	c3                   	retq   

0000000000801a0d <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801a0d:	55                   	push   %rbp
  801a0e:	48 89 e5             	mov    %rsp,%rbp
  801a11:	53                   	push   %rbx
  801a12:	48 83 ec 38          	sub    $0x38,%rsp
  801a16:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = ROUNDDOWN((void *) utf->utf_fault_va, PGSIZE);
  801a1a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a1e:	48 8b 00             	mov    (%rax),%rax
  801a21:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801a25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a29:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801a2f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801a33:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a37:	48 8b 40 08          	mov    0x8(%rax),%rax
  801a3b:	89 45 dc             	mov    %eax,-0x24(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//err is not a writing error & permissions are not PTE_COW
	if (!((uvpt[(uint64_t)addr/PGSIZE] & PTE_COW) && (err & FEC_WR))){
  801a3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a42:	48 c1 e8 0c          	shr    $0xc,%rax
  801a46:	48 89 c2             	mov    %rax,%rdx
  801a49:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801a50:	01 00 00 
  801a53:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a57:	25 00 08 00 00       	and    $0x800,%eax
  801a5c:	48 85 c0             	test   %rax,%rax
  801a5f:	74 0a                	je     801a6b <pgfault+0x5e>
  801a61:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a64:	83 e0 02             	and    $0x2,%eax
  801a67:	85 c0                	test   %eax,%eax
  801a69:	75 2a                	jne    801a95 <pgfault+0x88>
		panic("not proper page fault");	
  801a6b:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  801a72:	00 00 00 
  801a75:	be 1e 00 00 00       	mov    $0x1e,%esi
  801a7a:	48 bf ce 29 80 00 00 	movabs $0x8029ce,%rdi
  801a81:	00 00 00 
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax
  801a89:	48 b9 a0 22 80 00 00 	movabs $0x8022a0,%rcx
  801a90:	00 00 00 
  801a93:	ff d1                	callq  *%rcx
	// LAB 4: Your code here.
	
	int result;

	//allocate new page & map it
	result = sys_page_alloc(sys_getenvid(), PFTEMP, PTE_P|PTE_U|PTE_W);
  801a95:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  801a9c:	00 00 00 
  801a9f:	ff d0                	callq  *%rax
  801aa1:	ba 07 00 00 00       	mov    $0x7,%edx
  801aa6:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801aab:	89 c7                	mov    %eax,%edi
  801aad:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  801ab4:	00 00 00 
  801ab7:	ff d0                	callq  *%rax
  801ab9:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801abc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801ac0:	79 2a                	jns    801aec <pgfault+0xdf>
		panic("page allocation failed in copy-on-write faulting page");
  801ac2:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  801ac9:	00 00 00 
  801acc:	be 2f 00 00 00       	mov    $0x2f,%esi
  801ad1:	48 bf ce 29 80 00 00 	movabs $0x8029ce,%rdi
  801ad8:	00 00 00 
  801adb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae0:	48 b9 a0 22 80 00 00 	movabs $0x8022a0,%rcx
  801ae7:	00 00 00 
  801aea:	ff d1                	callq  *%rcx
	}
	
	//copy page
	memcpy(PFTEMP, addr, PGSIZE);
  801aec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801af0:	ba 00 10 00 00       	mov    $0x1000,%edx
  801af5:	48 89 c6             	mov    %rax,%rsi
  801af8:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801afd:	48 b8 df 12 80 00 00 	movabs $0x8012df,%rax
  801b04:	00 00 00 
  801b07:	ff d0                	callq  *%rax
	
	//map new page into original page's space
	result = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_W|PTE_U|PTE_P);
  801b09:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  801b10:	00 00 00 
  801b13:	ff d0                	callq  *%rax
  801b15:	89 c3                	mov    %eax,%ebx
  801b17:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  801b1e:	00 00 00 
  801b21:	ff d0                	callq  *%rax
  801b23:	89 c7                	mov    %eax,%edi
  801b25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b29:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801b2f:	48 89 c1             	mov    %rax,%rcx
  801b32:	89 da                	mov    %ebx,%edx
  801b34:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b39:	48 b8 2b 18 80 00 00 	movabs $0x80182b,%rax
  801b40:	00 00 00 
  801b43:	ff d0                	callq  *%rax
  801b45:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801b48:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b4c:	79 2a                	jns    801b78 <pgfault+0x16b>
                panic("page mapping failed in copy-on-write faulting page");
  801b4e:	48 ba 18 2a 80 00 00 	movabs $0x802a18,%rdx
  801b55:	00 00 00 
  801b58:	be 38 00 00 00       	mov    $0x38,%esi
  801b5d:	48 bf ce 29 80 00 00 	movabs $0x8029ce,%rdi
  801b64:	00 00 00 
  801b67:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6c:	48 b9 a0 22 80 00 00 	movabs $0x8022a0,%rcx
  801b73:	00 00 00 
  801b76:	ff d1                	callq  *%rcx
        }

	//delete temporary location
	result = sys_page_unmap(sys_getenvid(), PFTEMP);
  801b78:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  801b7f:	00 00 00 
  801b82:	ff d0                	callq  *%rax
  801b84:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b89:	89 c7                	mov    %eax,%edi
  801b8b:	48 b8 8b 18 80 00 00 	movabs $0x80188b,%rax
  801b92:	00 00 00 
  801b95:	ff d0                	callq  *%rax
  801b97:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801b9a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b9e:	79 2a                	jns    801bca <pgfault+0x1bd>
                panic("temporary page unmapping failed in copy-on-write faulting page");
  801ba0:	48 ba 50 2a 80 00 00 	movabs $0x802a50,%rdx
  801ba7:	00 00 00 
  801baa:	be 3e 00 00 00       	mov    $0x3e,%esi
  801baf:	48 bf ce 29 80 00 00 	movabs $0x8029ce,%rdi
  801bb6:	00 00 00 
  801bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbe:	48 b9 a0 22 80 00 00 	movabs $0x8022a0,%rcx
  801bc5:	00 00 00 
  801bc8:	ff d1                	callq  *%rcx
        }	

	//panic("pgfault not implemented");

}
  801bca:	90                   	nop
  801bcb:	48 83 c4 38          	add    $0x38,%rsp
  801bcf:	5b                   	pop    %rbx
  801bd0:	5d                   	pop    %rbp
  801bd1:	c3                   	retq   

0000000000801bd2 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801bd2:	55                   	push   %rbp
  801bd3:	48 89 e5             	mov    %rsp,%rbp
  801bd6:	53                   	push   %rbx
  801bd7:	48 83 ec 28          	sub    $0x28,%rsp
  801bdb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801bde:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uint64_t)pn*PGSIZE);	
  801be1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801be4:	48 c1 e0 0c          	shl    $0xc,%rax
  801be8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result;

	//COW or writable
	if ((uvpt[pn]&PTE_COW) || (uvpt[pn]&PTE_W)){
  801bec:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bf3:	01 00 00 
  801bf6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801bf9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bfd:	25 00 08 00 00       	and    $0x800,%eax
  801c02:	48 85 c0             	test   %rax,%rax
  801c05:	75 1d                	jne    801c24 <duppage+0x52>
  801c07:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c0e:	01 00 00 
  801c11:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801c14:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c18:	83 e0 02             	and    $0x2,%eax
  801c1b:	48 85 c0             	test   %rax,%rax
  801c1e:	0f 84 8f 00 00 00    	je     801cb3 <duppage+0xe1>
		//map to child
		result = sys_page_map(sys_getenvid(), addr, envid, addr, PTE_COW|PTE_U|PTE_P);
  801c24:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  801c2b:	00 00 00 
  801c2e:	ff d0                	callq  *%rax
  801c30:	89 c7                	mov    %eax,%edi
  801c32:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c36:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801c39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c3d:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801c43:	48 89 c6             	mov    %rax,%rsi
  801c46:	48 b8 2b 18 80 00 00 	movabs $0x80182b,%rax
  801c4d:	00 00 00 
  801c50:	ff d0                	callq  *%rax
  801c52:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (result<0){
  801c55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801c59:	79 0a                	jns    801c65 <duppage+0x93>
			return -1;
  801c5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c60:	e9 91 00 00 00       	jmpq   801cf6 <duppage+0x124>
		}

		//remap page with proper permissions COW
		result = sys_page_map(sys_getenvid(), addr, sys_getenvid(), addr, PTE_COW|PTE_U|PTE_P);
  801c65:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  801c6c:	00 00 00 
  801c6f:	ff d0                	callq  *%rax
  801c71:	89 c3                	mov    %eax,%ebx
  801c73:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  801c7a:	00 00 00 
  801c7d:	ff d0                	callq  *%rax
  801c7f:	89 c7                	mov    %eax,%edi
  801c81:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c89:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801c8f:	48 89 d1             	mov    %rdx,%rcx
  801c92:	89 da                	mov    %ebx,%edx
  801c94:	48 89 c6             	mov    %rax,%rsi
  801c97:	48 b8 2b 18 80 00 00 	movabs $0x80182b,%rax
  801c9e:	00 00 00 
  801ca1:	ff d0                	callq  *%rax
  801ca3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (result<0){
  801ca6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801caa:	79 45                	jns    801cf1 <duppage+0x11f>
                        return -1;
  801cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801cb1:	eb 43                	jmp    801cf6 <duppage+0x124>
                } 	
	//not proper permissions
	}else{
		result=sys_page_map(sys_getenvid(), addr, envid, addr, PTE_P|PTE_U);
  801cb3:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  801cba:	00 00 00 
  801cbd:	ff d0                	callq  *%rax
  801cbf:	89 c7                	mov    %eax,%edi
  801cc1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cc5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801cc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ccc:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  801cd2:	48 89 c6             	mov    %rax,%rsi
  801cd5:	48 b8 2b 18 80 00 00 	movabs $0x80182b,%rax
  801cdc:	00 00 00 
  801cdf:	ff d0                	callq  *%rax
  801ce1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (result<0){
  801ce4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801ce8:	79 07                	jns    801cf1 <duppage+0x11f>
			return -1;
  801cea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801cef:	eb 05                	jmp    801cf6 <duppage+0x124>
		}
	}

	//panic("duppage not implemented");
	return 0;
  801cf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf6:	48 83 c4 28          	add    $0x28,%rsp
  801cfa:	5b                   	pop    %rbx
  801cfb:	5d                   	pop    %rbp
  801cfc:	c3                   	retq   

0000000000801cfd <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801cfd:	55                   	push   %rbp
  801cfe:	48 89 e5             	mov    %rsp,%rbp
  801d01:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	//LOOKED AT DUMBFORK FOR HELP :)	


	//step 1 
	set_pgfault_handler(pgfault);
  801d05:	48 bf 0d 1a 80 00 00 	movabs $0x801a0d,%rdi
  801d0c:	00 00 00 
  801d0f:	48 b8 b4 23 80 00 00 	movabs $0x8023b4,%rax
  801d16:	00 00 00 
  801d19:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801d1b:	b8 07 00 00 00       	mov    $0x7,%eax
  801d20:	cd 30                	int    $0x30
  801d22:	89 45 e8             	mov    %eax,-0x18(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801d25:	8b 45 e8             	mov    -0x18(%rbp),%eax
	
	//step 2
	envid_t child = sys_exofork();
  801d28:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (child==0){
  801d2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801d2f:	75 46                	jne    801d77 <fork+0x7a>
		//fix env in child
		thisenv = &envs[ENVX(sys_getenvid())];
  801d31:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  801d38:	00 00 00 
  801d3b:	ff d0                	callq  *%rax
  801d3d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801d42:	48 63 d0             	movslq %eax,%rdx
  801d45:	48 89 d0             	mov    %rdx,%rax
  801d48:	48 c1 e0 03          	shl    $0x3,%rax
  801d4c:	48 01 d0             	add    %rdx,%rax
  801d4f:	48 c1 e0 05          	shl    $0x5,%rax
  801d53:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801d5a:	00 00 00 
  801d5d:	48 01 c2             	add    %rax,%rdx
  801d60:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  801d67:	00 00 00 
  801d6a:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801d6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d72:	e9 2b 03 00 00       	jmpq   8020a2 <fork+0x3a5>
	}
	if(child<0){
  801d77:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801d7b:	79 0a                	jns    801d87 <fork+0x8a>
		return -1; //exofork failed
  801d7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801d82:	e9 1b 03 00 00       	jmpq   8020a2 <fork+0x3a5>

//For each writable or copy-on-write page in its address space below UTOP, the parent calls duppage, which should map the page copy-on-write into the address space of the child and then remap the page copy-on-write in its own address space. duppage sets both PTEs so that the page is not writeable, and to contain PTE_COW in the "avail" field to distinguish copy-on-write pages from genuine read-only pages.

	uintptr_t addr;
	extern unsigned char end[];
	for (addr = (uintptr_t)UTEXT; addr < (uintptr_t)end; addr += PGSIZE){//taken from dumbfork
  801d87:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  801d8e:	00 
  801d8f:	e9 ec 00 00 00       	jmpq   801e80 <fork+0x183>
		
		//check if page is copy on write
		int perms = (uvpml4e[VPML4E(addr)] & PTE_P);
  801d94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d98:	48 c1 e8 27          	shr    $0x27,%rax
  801d9c:	48 89 c2             	mov    %rax,%rdx
  801d9f:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801da6:	01 00 00 
  801da9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dad:	83 e0 01             	and    $0x1,%eax
  801db0:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpde[VPDPE(addr)] & PTE_P);
  801db3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801db7:	74 28                	je     801de1 <fork+0xe4>
  801db9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dbd:	48 c1 e8 1e          	shr    $0x1e,%rax
  801dc1:	48 89 c2             	mov    %rax,%rdx
  801dc4:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801dcb:	01 00 00 
  801dce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd2:	83 e0 01             	and    $0x1,%eax
  801dd5:	48 85 c0             	test   %rax,%rax
  801dd8:	74 07                	je     801de1 <fork+0xe4>
  801dda:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddf:	eb 05                	jmp    801de6 <fork+0xe9>
  801de1:	b8 00 00 00 00       	mov    $0x0,%eax
  801de6:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpd[VPD(addr)] & PTE_P);		
  801de9:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801ded:	74 28                	je     801e17 <fork+0x11a>
  801def:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801df3:	48 c1 e8 15          	shr    $0x15,%rax
  801df7:	48 89 c2             	mov    %rax,%rdx
  801dfa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e01:	01 00 00 
  801e04:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e08:	83 e0 01             	and    $0x1,%eax
  801e0b:	48 85 c0             	test   %rax,%rax
  801e0e:	74 07                	je     801e17 <fork+0x11a>
  801e10:	b8 01 00 00 00       	mov    $0x1,%eax
  801e15:	eb 05                	jmp    801e1c <fork+0x11f>
  801e17:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpt[PGNUM(addr)] & (PTE_P | PTE_U));
  801e1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801e23:	74 28                	je     801e4d <fork+0x150>
  801e25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e29:	48 c1 e8 0c          	shr    $0xc,%rax
  801e2d:	48 89 c2             	mov    %rax,%rdx
  801e30:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e37:	01 00 00 
  801e3a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e3e:	83 e0 05             	and    $0x5,%eax
  801e41:	48 85 c0             	test   %rax,%rax
  801e44:	74 07                	je     801e4d <fork+0x150>
  801e46:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4b:	eb 05                	jmp    801e52 <fork+0x155>
  801e4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e52:	89 45 f0             	mov    %eax,-0x10(%rbp)

		if (perms){
  801e55:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801e59:	74 1d                	je     801e78 <fork+0x17b>
			duppage(child, PGNUM(addr));
  801e5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e5f:	48 c1 e8 0c          	shr    $0xc,%rax
  801e63:	89 c2                	mov    %eax,%edx
  801e65:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e68:	89 d6                	mov    %edx,%esi
  801e6a:	89 c7                	mov    %eax,%edi
  801e6c:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  801e73:	00 00 00 
  801e76:	ff d0                	callq  *%rax

//For each writable or copy-on-write page in its address space below UTOP, the parent calls duppage, which should map the page copy-on-write into the address space of the child and then remap the page copy-on-write in its own address space. duppage sets both PTEs so that the page is not writeable, and to contain PTE_COW in the "avail" field to distinguish copy-on-write pages from genuine read-only pages.

	uintptr_t addr;
	extern unsigned char end[];
	for (addr = (uintptr_t)UTEXT; addr < (uintptr_t)end; addr += PGSIZE){//taken from dumbfork
  801e78:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  801e7f:	00 
  801e80:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  801e87:	00 00 00 
  801e8a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  801e8e:	0f 82 00 ff ff ff    	jb     801d94 <fork+0x97>
//The exception stack is not remapped this way, however. Instead you need to allocate a fresh page in the child for the exception stack. Since the page fault handler will be doing the actual copying and the page fault handler runs on the exception stack, the exception stack cannot be made copy-on-write: who would copy it?

	int result;

        //allocate new page & map it
        result = sys_page_alloc(sys_getenvid(), PFTEMP, PTE_P|PTE_U|PTE_W);
  801e94:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  801e9b:	00 00 00 
  801e9e:	ff d0                	callq  *%rax
  801ea0:	ba 07 00 00 00       	mov    $0x7,%edx
  801ea5:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801eaa:	89 c7                	mov    %eax,%edi
  801eac:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  801eb3:	00 00 00 
  801eb6:	ff d0                	callq  *%rax
  801eb8:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  801ebb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ebf:	79 2a                	jns    801eeb <fork+0x1ee>
                panic("page allocation failed in fork");
  801ec1:	48 ba 90 2a 80 00 00 	movabs $0x802a90,%rdx
  801ec8:	00 00 00 
  801ecb:	be b0 00 00 00       	mov    $0xb0,%esi
  801ed0:	48 bf ce 29 80 00 00 	movabs $0x8029ce,%rdi
  801ed7:	00 00 00 
  801eda:	b8 00 00 00 00       	mov    $0x0,%eax
  801edf:	48 b9 a0 22 80 00 00 	movabs $0x8022a0,%rcx
  801ee6:	00 00 00 
  801ee9:	ff d1                	callq  *%rcx
        }

        //copy page
        memcpy(PFTEMP, (void *)(USTACKTOP-PGSIZE), PGSIZE);
  801eeb:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ef0:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801ef5:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801efa:	48 b8 df 12 80 00 00 	movabs $0x8012df,%rax
  801f01:	00 00 00 
  801f04:	ff d0                	callq  *%rax

        //map new page into original page's space
        result = sys_page_map(sys_getenvid(), PFTEMP, child,(void *)(USTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  801f06:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  801f0d:	00 00 00 
  801f10:	ff d0                	callq  *%rax
  801f12:	89 c7                	mov    %eax,%edi
  801f14:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f17:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f1d:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  801f22:	89 c2                	mov    %eax,%edx
  801f24:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f29:	48 b8 2b 18 80 00 00 	movabs $0x80182b,%rax
  801f30:	00 00 00 
  801f33:	ff d0                	callq  *%rax
  801f35:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  801f38:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f3c:	79 2a                	jns    801f68 <fork+0x26b>
                panic("page mapping failed in fork");
  801f3e:	48 ba af 2a 80 00 00 	movabs $0x802aaf,%rdx
  801f45:	00 00 00 
  801f48:	be b9 00 00 00       	mov    $0xb9,%esi
  801f4d:	48 bf ce 29 80 00 00 	movabs $0x8029ce,%rdi
  801f54:	00 00 00 
  801f57:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5c:	48 b9 a0 22 80 00 00 	movabs $0x8022a0,%rcx
  801f63:	00 00 00 
  801f66:	ff d1                	callq  *%rcx
        }

        //delete temporary location
        result = sys_page_unmap(sys_getenvid(), PFTEMP);
  801f68:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  801f6f:	00 00 00 
  801f72:	ff d0                	callq  *%rax
  801f74:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f79:	89 c7                	mov    %eax,%edi
  801f7b:	48 b8 8b 18 80 00 00 	movabs $0x80188b,%rax
  801f82:	00 00 00 
  801f85:	ff d0                	callq  *%rax
  801f87:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  801f8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f8e:	79 2a                	jns    801fba <fork+0x2bd>
                panic("temporary page unmapping failed in copy-on-write faulting page");
  801f90:	48 ba 50 2a 80 00 00 	movabs $0x802a50,%rdx
  801f97:	00 00 00 
  801f9a:	be bf 00 00 00       	mov    $0xbf,%esi
  801f9f:	48 bf ce 29 80 00 00 	movabs $0x8029ce,%rdi
  801fa6:	00 00 00 
  801fa9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fae:	48 b9 a0 22 80 00 00 	movabs $0x8022a0,%rcx
  801fb5:	00 00 00 
  801fb8:	ff d1                	callq  *%rcx
        }
// STEP 4
//The parent sets the user page fault entrypoint for the child to look like its own.

	result=sys_page_alloc(child, (void*)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W);
  801fba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fbd:	ba 07 00 00 00       	mov    $0x7,%edx
  801fc2:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801fc7:	89 c7                	mov    %eax,%edi
  801fc9:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  801fd0:	00 00 00 
  801fd3:	ff d0                	callq  *%rax
  801fd5:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  801fd8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fdc:	79 2a                	jns    802008 <fork+0x30b>
		panic("page alloc of table failed in fork");
  801fde:	48 ba d0 2a 80 00 00 	movabs $0x802ad0,%rdx
  801fe5:	00 00 00 
  801fe8:	be c6 00 00 00       	mov    $0xc6,%esi
  801fed:	48 bf ce 29 80 00 00 	movabs $0x8029ce,%rdi
  801ff4:	00 00 00 
  801ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffc:	48 b9 a0 22 80 00 00 	movabs $0x8022a0,%rcx
  802003:	00 00 00 
  802006:	ff d1                	callq  *%rcx
	}

	extern void _pgfault_upcall();
	result = sys_env_set_pgfault_upcall(child, _pgfault_upcall);
  802008:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80200b:	48 be 98 24 80 00 00 	movabs $0x802498,%rsi
  802012:	00 00 00 
  802015:	89 c7                	mov    %eax,%edi
  802017:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  80201e:	00 00 00 
  802021:	ff d0                	callq  *%rax
  802023:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  802026:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80202a:	79 2a                	jns    802056 <fork+0x359>
		panic("setting upcall failed in fork"); 
  80202c:	48 ba f3 2a 80 00 00 	movabs $0x802af3,%rdx
  802033:	00 00 00 
  802036:	be cc 00 00 00       	mov    $0xcc,%esi
  80203b:	48 bf ce 29 80 00 00 	movabs $0x8029ce,%rdi
  802042:	00 00 00 
  802045:	b8 00 00 00 00       	mov    $0x0,%eax
  80204a:	48 b9 a0 22 80 00 00 	movabs $0x8022a0,%rcx
  802051:	00 00 00 
  802054:	ff d1                	callq  *%rcx
	}
// STEP 5
//The child is now ready to run, so the parent marks it runnable.

	result = sys_env_set_status(child, ENV_RUNNABLE);
  802056:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802059:	be 02 00 00 00       	mov    $0x2,%esi
  80205e:	89 c7                	mov    %eax,%edi
  802060:	48 b8 d7 18 80 00 00 	movabs $0x8018d7,%rax
  802067:	00 00 00 
  80206a:	ff d0                	callq  *%rax
  80206c:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  80206f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802073:	79 2a                	jns    80209f <fork+0x3a2>
		panic("changing statys is fork failed");
  802075:	48 ba 18 2b 80 00 00 	movabs $0x802b18,%rdx
  80207c:	00 00 00 
  80207f:	be d3 00 00 00       	mov    $0xd3,%esi
  802084:	48 bf ce 29 80 00 00 	movabs $0x8029ce,%rdi
  80208b:	00 00 00 
  80208e:	b8 00 00 00 00       	mov    $0x0,%eax
  802093:	48 b9 a0 22 80 00 00 	movabs $0x8022a0,%rcx
  80209a:	00 00 00 
  80209d:	ff d1                	callq  *%rcx
	}
	
	return child;
  80209f:	8b 45 f4             	mov    -0xc(%rbp),%eax

}
  8020a2:	c9                   	leaveq 
  8020a3:	c3                   	retq   

00000000008020a4 <sfork>:

// Challenge!
int
sfork(void)
{
  8020a4:	55                   	push   %rbp
  8020a5:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8020a8:	48 ba 37 2b 80 00 00 	movabs $0x802b37,%rdx
  8020af:	00 00 00 
  8020b2:	be de 00 00 00       	mov    $0xde,%esi
  8020b7:	48 bf ce 29 80 00 00 	movabs $0x8029ce,%rdi
  8020be:	00 00 00 
  8020c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c6:	48 b9 a0 22 80 00 00 	movabs $0x8022a0,%rcx
  8020cd:	00 00 00 
  8020d0:	ff d1                	callq  *%rcx

00000000008020d2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020d2:	55                   	push   %rbp
  8020d3:	48 89 e5             	mov    %rsp,%rbp
  8020d6:	48 83 ec 30          	sub    $0x30,%rsp
  8020da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8020de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8020e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	//cprintf("lib ipc_recv\n");
	// LAB 4: Your code here.
	if (pg==NULL){
  8020e6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8020eb:	75 08                	jne    8020f5 <ipc_recv+0x23>
		pg = (void *) -1;	
  8020ed:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8020f4:	ff 
	}
	
	int result = sys_ipc_recv(pg);
  8020f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020f9:	48 89 c7             	mov    %rax,%rdi
  8020fc:	48 b8 c7 19 80 00 00 	movabs $0x8019c7,%rax
  802103:	00 00 00 
  802106:	ff d0                	callq  *%rax
  802108:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (result<0){
  80210b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80210f:	79 27                	jns    802138 <ipc_recv+0x66>
		if (from_env_store){
  802111:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802116:	74 0a                	je     802122 <ipc_recv+0x50>
			*from_env_store=0;
  802118:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80211c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if (perm_store){
  802122:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802127:	74 0a                	je     802133 <ipc_recv+0x61>
			*perm_store = 0;
  802129:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80212d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		return result;
  802133:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802136:	eb 53                	jmp    80218b <ipc_recv+0xb9>
	}	
	if (from_env_store){
  802138:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80213d:	74 19                	je     802158 <ipc_recv+0x86>
	 	*from_env_store = thisenv->env_ipc_from;
  80213f:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  802146:	00 00 00 
  802149:	48 8b 00             	mov    (%rax),%rax
  80214c:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802152:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802156:	89 10                	mov    %edx,(%rax)
        }
        if (perm_store){
  802158:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80215d:	74 19                	je     802178 <ipc_recv+0xa6>
               	*perm_store = thisenv->env_ipc_perm;
  80215f:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  802166:	00 00 00 
  802169:	48 8b 00             	mov    (%rax),%rax
  80216c:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802172:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802176:	89 10                	mov    %edx,(%rax)
        }
	//panic("ipc_recv not implemented");
	return thisenv->env_ipc_value;
  802178:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80217f:	00 00 00 
  802182:	48 8b 00             	mov    (%rax),%rax
  802185:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  80218b:	c9                   	leaveq 
  80218c:	c3                   	retq   

000000000080218d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80218d:	55                   	push   %rbp
  80218e:	48 89 e5             	mov    %rsp,%rbp
  802191:	48 83 ec 30          	sub    $0x30,%rsp
  802195:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802198:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80219b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80219f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	//cprintf("lib ipc_send\n");
	// LAB 4: Your code here.
	if (pg==NULL){
  8021a2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8021a7:	75 4c                	jne    8021f5 <ipc_send+0x68>
		pg = (void *)-1;
  8021a9:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8021b0:	ff 
	}
	int result;
	while((result=sys_ipc_try_send(to_env, val, pg, perm))){
  8021b1:	eb 42                	jmp    8021f5 <ipc_send+0x68>
		if (result==0){
  8021b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b7:	74 62                	je     80221b <ipc_send+0x8e>
			break;
		}
		if (result!=-E_IPC_NOT_RECV){
  8021b9:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8021bd:	74 2a                	je     8021e9 <ipc_send+0x5c>
			panic("syscall returned improper error");
  8021bf:	48 ba 50 2b 80 00 00 	movabs $0x802b50,%rdx
  8021c6:	00 00 00 
  8021c9:	be 49 00 00 00       	mov    $0x49,%esi
  8021ce:	48 bf 70 2b 80 00 00 	movabs $0x802b70,%rdi
  8021d5:	00 00 00 
  8021d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021dd:	48 b9 a0 22 80 00 00 	movabs $0x8022a0,%rcx
  8021e4:	00 00 00 
  8021e7:	ff d1                	callq  *%rcx
		}
		sys_yield();
  8021e9:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  8021f0:	00 00 00 
  8021f3:	ff d0                	callq  *%rax
	// LAB 4: Your code here.
	if (pg==NULL){
		pg = (void *)-1;
	}
	int result;
	while((result=sys_ipc_try_send(to_env, val, pg, perm))){
  8021f5:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8021f8:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8021fb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802202:	89 c7                	mov    %eax,%edi
  802204:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  80220b:	00 00 00 
  80220e:	ff d0                	callq  *%rax
  802210:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802213:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802217:	75 9a                	jne    8021b3 <ipc_send+0x26>
			panic("syscall returned improper error");
		}
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  802219:	eb 01                	jmp    80221c <ipc_send+0x8f>
		pg = (void *)-1;
	}
	int result;
	while((result=sys_ipc_try_send(to_env, val, pg, perm))){
		if (result==0){
			break;
  80221b:	90                   	nop
			panic("syscall returned improper error");
		}
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80221c:	90                   	nop
  80221d:	c9                   	leaveq 
  80221e:	c3                   	retq   

000000000080221f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80221f:	55                   	push   %rbp
  802220:	48 89 e5             	mov    %rsp,%rbp
  802223:	48 83 ec 18          	sub    $0x18,%rsp
  802227:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80222a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802231:	eb 5d                	jmp    802290 <ipc_find_env+0x71>
		if (envs[i].env_type == type)
  802233:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80223a:	00 00 00 
  80223d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802240:	48 63 d0             	movslq %eax,%rdx
  802243:	48 89 d0             	mov    %rdx,%rax
  802246:	48 c1 e0 03          	shl    $0x3,%rax
  80224a:	48 01 d0             	add    %rdx,%rax
  80224d:	48 c1 e0 05          	shl    $0x5,%rax
  802251:	48 01 c8             	add    %rcx,%rax
  802254:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80225a:	8b 00                	mov    (%rax),%eax
  80225c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80225f:	75 2b                	jne    80228c <ipc_find_env+0x6d>
			return envs[i].env_id;
  802261:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802268:	00 00 00 
  80226b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80226e:	48 63 d0             	movslq %eax,%rdx
  802271:	48 89 d0             	mov    %rdx,%rax
  802274:	48 c1 e0 03          	shl    $0x3,%rax
  802278:	48 01 d0             	add    %rdx,%rax
  80227b:	48 c1 e0 05          	shl    $0x5,%rax
  80227f:	48 01 c8             	add    %rcx,%rax
  802282:	48 05 c8 00 00 00    	add    $0xc8,%rax
  802288:	8b 00                	mov    (%rax),%eax
  80228a:	eb 12                	jmp    80229e <ipc_find_env+0x7f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80228c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802290:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802297:	7e 9a                	jle    802233 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802299:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80229e:	c9                   	leaveq 
  80229f:	c3                   	retq   

00000000008022a0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8022a0:	55                   	push   %rbp
  8022a1:	48 89 e5             	mov    %rsp,%rbp
  8022a4:	53                   	push   %rbx
  8022a5:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8022ac:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8022b3:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8022b9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8022c0:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8022c7:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8022ce:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8022d5:	84 c0                	test   %al,%al
  8022d7:	74 23                	je     8022fc <_panic+0x5c>
  8022d9:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8022e0:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8022e4:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8022e8:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8022ec:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8022f0:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8022f4:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8022f8:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8022fc:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802303:	00 00 00 
  802306:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80230d:	00 00 00 
  802310:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802314:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80231b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802322:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802329:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802330:	00 00 00 
  802333:	48 8b 18             	mov    (%rax),%rbx
  802336:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  80233d:	00 00 00 
  802340:	ff d0                	callq  *%rax
  802342:	89 c6                	mov    %eax,%esi
  802344:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  80234a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  802351:	41 89 d0             	mov    %edx,%r8d
  802354:	48 89 c1             	mov    %rax,%rcx
  802357:	48 89 da             	mov    %rbx,%rdx
  80235a:	48 bf 80 2b 80 00 00 	movabs $0x802b80,%rdi
  802361:	00 00 00 
  802364:	b8 00 00 00 00       	mov    $0x0,%eax
  802369:	49 b9 13 03 80 00 00 	movabs $0x800313,%r9
  802370:	00 00 00 
  802373:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802376:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80237d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802384:	48 89 d6             	mov    %rdx,%rsi
  802387:	48 89 c7             	mov    %rax,%rdi
  80238a:	48 b8 67 02 80 00 00 	movabs $0x800267,%rax
  802391:	00 00 00 
  802394:	ff d0                	callq  *%rax
	cprintf("\n");
  802396:	48 bf a3 2b 80 00 00 	movabs $0x802ba3,%rdi
  80239d:	00 00 00 
  8023a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a5:	48 ba 13 03 80 00 00 	movabs $0x800313,%rdx
  8023ac:	00 00 00 
  8023af:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8023b1:	cc                   	int3   
  8023b2:	eb fd                	jmp    8023b1 <_panic+0x111>

00000000008023b4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8023b4:	55                   	push   %rbp
  8023b5:	48 89 e5             	mov    %rsp,%rbp
  8023b8:	48 83 ec 20          	sub    $0x20,%rsp
  8023bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler==0) {
  8023c0:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  8023c7:	00 00 00 
  8023ca:	48 8b 00             	mov    (%rax),%rax
  8023cd:	48 85 c0             	test   %rax,%rax
  8023d0:	0f 85 ae 00 00 00    	jne    802484 <set_pgfault_handler+0xd0>
		//allocate space
		int result = sys_page_alloc(sys_getenvid(), (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  8023d6:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  8023dd:	00 00 00 
  8023e0:	ff d0                	callq  *%rax
  8023e2:	ba 07 00 00 00       	mov    $0x7,%edx
  8023e7:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8023ec:	89 c7                	mov    %eax,%edi
  8023ee:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  8023f5:	00 00 00 
  8023f8:	ff d0                	callq  *%rax
  8023fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  8023fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802401:	79 2a                	jns    80242d <set_pgfault_handler+0x79>
			panic("sys_page_alloc for stack failed in setting page fault handler");
  802403:	48 ba a8 2b 80 00 00 	movabs $0x802ba8,%rdx
  80240a:	00 00 00 
  80240d:	be 21 00 00 00       	mov    $0x21,%esi
  802412:	48 bf e6 2b 80 00 00 	movabs $0x802be6,%rdi
  802419:	00 00 00 
  80241c:	b8 00 00 00 00       	mov    $0x0,%eax
  802421:	48 b9 a0 22 80 00 00 	movabs $0x8022a0,%rcx
  802428:	00 00 00 
  80242b:	ff d1                	callq  *%rcx
		}

		//actual set upcall
		result = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  80242d:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  802434:	00 00 00 
  802437:	ff d0                	callq  *%rax
  802439:	48 be 98 24 80 00 00 	movabs $0x802498,%rsi
  802440:	00 00 00 
  802443:	89 c7                	mov    %eax,%edi
  802445:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  80244c:	00 00 00 
  80244f:	ff d0                	callq  *%rax
  802451:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  802454:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802458:	79 2a                	jns    802484 <set_pgfault_handler+0xd0>
                        panic("setting upcall failed in setting page fault handler");
  80245a:	48 ba f8 2b 80 00 00 	movabs $0x802bf8,%rdx
  802461:	00 00 00 
  802464:	be 27 00 00 00       	mov    $0x27,%esi
  802469:	48 bf e6 2b 80 00 00 	movabs $0x802be6,%rdi
  802470:	00 00 00 
  802473:	b8 00 00 00 00       	mov    $0x0,%eax
  802478:	48 b9 a0 22 80 00 00 	movabs $0x8022a0,%rcx
  80247f:	00 00 00 
  802482:	ff d1                	callq  *%rcx
                }
		//panic("set_pgfault_handler not implemented");
	}

	_pgfault_handler = handler;
  802484:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80248b:	00 00 00 
  80248e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802492:	48 89 10             	mov    %rdx,(%rax)

}
  802495:	90                   	nop
  802496:	c9                   	leaveq 
  802497:	c3                   	retq   

0000000000802498 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  802498:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80249b:	48 a1 10 40 80 00 00 	movabs 0x804010,%rax
  8024a2:	00 00 00 
call *%rax
  8024a5:	ff d0                	callq  *%rax
	//MAKE STACK CALCS for getting parameters
	//20 = size of stack
	//8 = size of word	

	//(20-3)*8=17*8=136
	movq 136(%rsp), %rax
  8024a7:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  8024ae:	00 
	//(20-1)*8=152
	subq $8, 152(%rsp)
  8024af:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8024b6:	00 08 
	movq 152(%rsp), %rbx
  8024b8:	48 8b 9c 24 98 00 00 	mov    0x98(%rsp),%rbx
  8024bf:	00 
	movq %rax, (%rbx)
  8024c0:	48 89 03             	mov    %rax,(%rbx)
	addq $16, %rsp
  8024c3:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
	
    	POPA_
  8024c7:	4c 8b 3c 24          	mov    (%rsp),%r15
  8024cb:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8024d0:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8024d5:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8024da:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8024df:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8024e4:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8024e9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8024ee:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8024f3:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8024f8:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8024fd:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802502:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802507:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80250c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802511:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
	//https://www.felixcloutier.com/x86/POPF:POPFD:POPFQ.html
    	addq $8, %rsp
  802515:	48 83 c4 08          	add    $0x8,%rsp
    	popfq	
  802519:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    	popq %rsp
  80251a:	5c                   	pop    %rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    	ret
  80251b:	c3                   	retq   
