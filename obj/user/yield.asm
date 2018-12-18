
obj/user/yield:     file format elf64-x86-64


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
  80003c:	e8 c6 00 00 00       	callq  800107 <libmain>
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
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  800052:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf e0 1a 80 00 00 	movabs $0x801ae0,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba d1 02 80 00 00 	movabs $0x8002d1,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	for (i = 0; i < 5; i++) {
  800082:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800089:	eb 43                	jmp    8000ce <umain+0x8b>
		sys_yield();
  80008b:	48 b8 5a 17 80 00 00 	movabs $0x80175a,%rax
  800092:	00 00 00 
  800095:	ff d0                	callq  *%rax
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  800097:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80009e:	00 00 00 
  8000a1:	48 8b 00             	mov    (%rax),%rax
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
  8000a4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8000ad:	89 c6                	mov    %eax,%esi
  8000af:	48 bf 00 1b 80 00 00 	movabs $0x801b00,%rdi
  8000b6:	00 00 00 
  8000b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000be:	48 b9 d1 02 80 00 00 	movabs $0x8002d1,%rcx
  8000c5:	00 00 00 
  8000c8:	ff d1                	callq  *%rcx
umain(int argc, char **argv)
{
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
  8000ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000ce:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8000d2:	7e b7                	jle    80008b <umain+0x48>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  8000d4:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000db:	00 00 00 
  8000de:	48 8b 00             	mov    (%rax),%rax
  8000e1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000e7:	89 c6                	mov    %eax,%esi
  8000e9:	48 bf 30 1b 80 00 00 	movabs $0x801b30,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	48 ba d1 02 80 00 00 	movabs $0x8002d1,%rdx
  8000ff:	00 00 00 
  800102:	ff d2                	callq  *%rdx
}
  800104:	90                   	nop
  800105:	c9                   	leaveq 
  800106:	c3                   	retq   

0000000000800107 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800107:	55                   	push   %rbp
  800108:	48 89 e5             	mov    %rsp,%rbp
  80010b:	48 83 ec 10          	sub    $0x10,%rsp
  80010f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800112:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  800116:	48 b8 1e 17 80 00 00 	movabs $0x80171e,%rax
  80011d:	00 00 00 
  800120:	ff d0                	callq  *%rax
  800122:	25 ff 03 00 00       	and    $0x3ff,%eax
  800127:	48 63 d0             	movslq %eax,%rdx
  80012a:	48 89 d0             	mov    %rdx,%rax
  80012d:	48 c1 e0 03          	shl    $0x3,%rax
  800131:	48 01 d0             	add    %rdx,%rax
  800134:	48 c1 e0 05          	shl    $0x5,%rax
  800138:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80013f:	00 00 00 
  800142:	48 01 c2             	add    %rax,%rdx
  800145:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80014c:	00 00 00 
  80014f:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800156:	7e 14                	jle    80016c <libmain+0x65>
		binaryname = argv[0];
  800158:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80015c:	48 8b 10             	mov    (%rax),%rdx
  80015f:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800166:	00 00 00 
  800169:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80016c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800170:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800173:	48 89 d6             	mov    %rdx,%rsi
  800176:	89 c7                	mov    %eax,%edi
  800178:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80017f:	00 00 00 
  800182:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800184:	48 b8 93 01 80 00 00 	movabs $0x800193,%rax
  80018b:	00 00 00 
  80018e:	ff d0                	callq  *%rax
}
  800190:	90                   	nop
  800191:	c9                   	leaveq 
  800192:	c3                   	retq   

0000000000800193 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800193:	55                   	push   %rbp
  800194:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800197:	bf 00 00 00 00       	mov    $0x0,%edi
  80019c:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8001a3:	00 00 00 
  8001a6:	ff d0                	callq  *%rax
}
  8001a8:	90                   	nop
  8001a9:	5d                   	pop    %rbp
  8001aa:	c3                   	retq   

00000000008001ab <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001ab:	55                   	push   %rbp
  8001ac:	48 89 e5             	mov    %rsp,%rbp
  8001af:	48 83 ec 10          	sub    $0x10,%rsp
  8001b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8001ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001be:	8b 00                	mov    (%rax),%eax
  8001c0:	8d 48 01             	lea    0x1(%rax),%ecx
  8001c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c7:	89 0a                	mov    %ecx,(%rdx)
  8001c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d2:	48 98                	cltq   
  8001d4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001dc:	8b 00                	mov    (%rax),%eax
  8001de:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e3:	75 2c                	jne    800211 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8001e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001e9:	8b 00                	mov    (%rax),%eax
  8001eb:	48 98                	cltq   
  8001ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001f1:	48 83 c2 08          	add    $0x8,%rdx
  8001f5:	48 89 c6             	mov    %rax,%rsi
  8001f8:	48 89 d7             	mov    %rdx,%rdi
  8001fb:	48 b8 4f 16 80 00 00 	movabs $0x80164f,%rax
  800202:	00 00 00 
  800205:	ff d0                	callq  *%rax
        b->idx = 0;
  800207:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800215:	8b 40 04             	mov    0x4(%rax),%eax
  800218:	8d 50 01             	lea    0x1(%rax),%edx
  80021b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80021f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800222:	90                   	nop
  800223:	c9                   	leaveq 
  800224:	c3                   	retq   

0000000000800225 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800225:	55                   	push   %rbp
  800226:	48 89 e5             	mov    %rsp,%rbp
  800229:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800230:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800237:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80023e:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800245:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80024c:	48 8b 0a             	mov    (%rdx),%rcx
  80024f:	48 89 08             	mov    %rcx,(%rax)
  800252:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800256:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80025a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80025e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800262:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800269:	00 00 00 
    b.cnt = 0;
  80026c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800273:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800276:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80027d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800284:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80028b:	48 89 c6             	mov    %rax,%rsi
  80028e:	48 bf ab 01 80 00 00 	movabs $0x8001ab,%rdi
  800295:	00 00 00 
  800298:	48 b8 6f 06 80 00 00 	movabs $0x80066f,%rax
  80029f:	00 00 00 
  8002a2:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002a4:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002aa:	48 98                	cltq   
  8002ac:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002b3:	48 83 c2 08          	add    $0x8,%rdx
  8002b7:	48 89 c6             	mov    %rax,%rsi
  8002ba:	48 89 d7             	mov    %rdx,%rdi
  8002bd:	48 b8 4f 16 80 00 00 	movabs $0x80164f,%rax
  8002c4:	00 00 00 
  8002c7:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002cf:	c9                   	leaveq 
  8002d0:	c3                   	retq   

00000000008002d1 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002d1:	55                   	push   %rbp
  8002d2:	48 89 e5             	mov    %rsp,%rbp
  8002d5:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002dc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8002e3:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002ea:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002f1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002f8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8002ff:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800306:	84 c0                	test   %al,%al
  800308:	74 20                	je     80032a <cprintf+0x59>
  80030a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80030e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800312:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800316:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80031a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80031e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800322:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800326:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80032a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800331:	00 00 00 
  800334:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80033b:	00 00 00 
  80033e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800342:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800349:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800350:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800357:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80035e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800365:	48 8b 0a             	mov    (%rdx),%rcx
  800368:	48 89 08             	mov    %rcx,(%rax)
  80036b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80036f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800373:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800377:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80037b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800382:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800389:	48 89 d6             	mov    %rdx,%rsi
  80038c:	48 89 c7             	mov    %rax,%rdi
  80038f:	48 b8 25 02 80 00 00 	movabs $0x800225,%rax
  800396:	00 00 00 
  800399:	ff d0                	callq  *%rax
  80039b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003a1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003a7:	c9                   	leaveq 
  8003a8:	c3                   	retq   

00000000008003a9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a9:	55                   	push   %rbp
  8003aa:	48 89 e5             	mov    %rsp,%rbp
  8003ad:	48 83 ec 30          	sub    $0x30,%rsp
  8003b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8003b9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8003bd:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8003c0:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8003c4:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8003cb:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8003cf:	77 54                	ja     800425 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d1:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003d4:	8d 78 ff             	lea    -0x1(%rax),%edi
  8003d7:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8003da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003de:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e3:	48 f7 f6             	div    %rsi
  8003e6:	49 89 c2             	mov    %rax,%r10
  8003e9:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8003ec:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8003ef:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8003f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f7:	41 89 c9             	mov    %ecx,%r9d
  8003fa:	41 89 f8             	mov    %edi,%r8d
  8003fd:	89 d1                	mov    %edx,%ecx
  8003ff:	4c 89 d2             	mov    %r10,%rdx
  800402:	48 89 c7             	mov    %rax,%rdi
  800405:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  80040c:	00 00 00 
  80040f:	ff d0                	callq  *%rax
  800411:	eb 1c                	jmp    80042f <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800413:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800417:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80041a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80041e:	48 89 ce             	mov    %rcx,%rsi
  800421:	89 d7                	mov    %edx,%edi
  800423:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800425:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800429:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80042d:	7f e4                	jg     800413 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80042f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800432:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800436:	ba 00 00 00 00       	mov    $0x0,%edx
  80043b:	48 f7 f1             	div    %rcx
  80043e:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  800445:	00 00 00 
  800448:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80044c:	0f be d0             	movsbl %al,%edx
  80044f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800453:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800457:	48 89 ce             	mov    %rcx,%rsi
  80045a:	89 d7                	mov    %edx,%edi
  80045c:	ff d0                	callq  *%rax
}
  80045e:	90                   	nop
  80045f:	c9                   	leaveq 
  800460:	c3                   	retq   

0000000000800461 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800461:	55                   	push   %rbp
  800462:	48 89 e5             	mov    %rsp,%rbp
  800465:	48 83 ec 20          	sub    $0x20,%rsp
  800469:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80046d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800470:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800474:	7e 4f                	jle    8004c5 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800476:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047a:	8b 00                	mov    (%rax),%eax
  80047c:	83 f8 30             	cmp    $0x30,%eax
  80047f:	73 24                	jae    8004a5 <getuint+0x44>
  800481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800485:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800489:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048d:	8b 00                	mov    (%rax),%eax
  80048f:	89 c0                	mov    %eax,%eax
  800491:	48 01 d0             	add    %rdx,%rax
  800494:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800498:	8b 12                	mov    (%rdx),%edx
  80049a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80049d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a1:	89 0a                	mov    %ecx,(%rdx)
  8004a3:	eb 14                	jmp    8004b9 <getuint+0x58>
  8004a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004ad:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8004b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004b9:	48 8b 00             	mov    (%rax),%rax
  8004bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004c0:	e9 9d 00 00 00       	jmpq   800562 <getuint+0x101>
	else if (lflag)
  8004c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004c9:	74 4c                	je     800517 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8004cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cf:	8b 00                	mov    (%rax),%eax
  8004d1:	83 f8 30             	cmp    $0x30,%eax
  8004d4:	73 24                	jae    8004fa <getuint+0x99>
  8004d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004da:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e2:	8b 00                	mov    (%rax),%eax
  8004e4:	89 c0                	mov    %eax,%eax
  8004e6:	48 01 d0             	add    %rdx,%rax
  8004e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ed:	8b 12                	mov    (%rdx),%edx
  8004ef:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f6:	89 0a                	mov    %ecx,(%rdx)
  8004f8:	eb 14                	jmp    80050e <getuint+0xad>
  8004fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fe:	48 8b 40 08          	mov    0x8(%rax),%rax
  800502:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800506:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80050e:	48 8b 00             	mov    (%rax),%rax
  800511:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800515:	eb 4b                	jmp    800562 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800517:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051b:	8b 00                	mov    (%rax),%eax
  80051d:	83 f8 30             	cmp    $0x30,%eax
  800520:	73 24                	jae    800546 <getuint+0xe5>
  800522:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800526:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80052a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052e:	8b 00                	mov    (%rax),%eax
  800530:	89 c0                	mov    %eax,%eax
  800532:	48 01 d0             	add    %rdx,%rax
  800535:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800539:	8b 12                	mov    (%rdx),%edx
  80053b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80053e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800542:	89 0a                	mov    %ecx,(%rdx)
  800544:	eb 14                	jmp    80055a <getuint+0xf9>
  800546:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80054e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800552:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800556:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80055a:	8b 00                	mov    (%rax),%eax
  80055c:	89 c0                	mov    %eax,%eax
  80055e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800562:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800566:	c9                   	leaveq 
  800567:	c3                   	retq   

0000000000800568 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800568:	55                   	push   %rbp
  800569:	48 89 e5             	mov    %rsp,%rbp
  80056c:	48 83 ec 20          	sub    $0x20,%rsp
  800570:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800574:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800577:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80057b:	7e 4f                	jle    8005cc <getint+0x64>
		x=va_arg(*ap, long long);
  80057d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800581:	8b 00                	mov    (%rax),%eax
  800583:	83 f8 30             	cmp    $0x30,%eax
  800586:	73 24                	jae    8005ac <getint+0x44>
  800588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800590:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800594:	8b 00                	mov    (%rax),%eax
  800596:	89 c0                	mov    %eax,%eax
  800598:	48 01 d0             	add    %rdx,%rax
  80059b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059f:	8b 12                	mov    (%rdx),%edx
  8005a1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a8:	89 0a                	mov    %ecx,(%rdx)
  8005aa:	eb 14                	jmp    8005c0 <getint+0x58>
  8005ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005b4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c0:	48 8b 00             	mov    (%rax),%rax
  8005c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005c7:	e9 9d 00 00 00       	jmpq   800669 <getint+0x101>
	else if (lflag)
  8005cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005d0:	74 4c                	je     80061e <getint+0xb6>
		x=va_arg(*ap, long);
  8005d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d6:	8b 00                	mov    (%rax),%eax
  8005d8:	83 f8 30             	cmp    $0x30,%eax
  8005db:	73 24                	jae    800601 <getint+0x99>
  8005dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e9:	8b 00                	mov    (%rax),%eax
  8005eb:	89 c0                	mov    %eax,%eax
  8005ed:	48 01 d0             	add    %rdx,%rax
  8005f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f4:	8b 12                	mov    (%rdx),%edx
  8005f6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fd:	89 0a                	mov    %ecx,(%rdx)
  8005ff:	eb 14                	jmp    800615 <getint+0xad>
  800601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800605:	48 8b 40 08          	mov    0x8(%rax),%rax
  800609:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80060d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800611:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800615:	48 8b 00             	mov    (%rax),%rax
  800618:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80061c:	eb 4b                	jmp    800669 <getint+0x101>
	else
		x=va_arg(*ap, int);
  80061e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800622:	8b 00                	mov    (%rax),%eax
  800624:	83 f8 30             	cmp    $0x30,%eax
  800627:	73 24                	jae    80064d <getint+0xe5>
  800629:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800631:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800635:	8b 00                	mov    (%rax),%eax
  800637:	89 c0                	mov    %eax,%eax
  800639:	48 01 d0             	add    %rdx,%rax
  80063c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800640:	8b 12                	mov    (%rdx),%edx
  800642:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800645:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800649:	89 0a                	mov    %ecx,(%rdx)
  80064b:	eb 14                	jmp    800661 <getint+0xf9>
  80064d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800651:	48 8b 40 08          	mov    0x8(%rax),%rax
  800655:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800659:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800661:	8b 00                	mov    (%rax),%eax
  800663:	48 98                	cltq   
  800665:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800669:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80066d:	c9                   	leaveq 
  80066e:	c3                   	retq   

000000000080066f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80066f:	55                   	push   %rbp
  800670:	48 89 e5             	mov    %rsp,%rbp
  800673:	41 54                	push   %r12
  800675:	53                   	push   %rbx
  800676:	48 83 ec 60          	sub    $0x60,%rsp
  80067a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80067e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800682:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800686:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80068a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80068e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800692:	48 8b 0a             	mov    (%rdx),%rcx
  800695:	48 89 08             	mov    %rcx,(%rax)
  800698:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80069c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006a0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006a4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a8:	eb 17                	jmp    8006c1 <vprintfmt+0x52>
			if (ch == '\0')
  8006aa:	85 db                	test   %ebx,%ebx
  8006ac:	0f 84 b9 04 00 00    	je     800b6b <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  8006b2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006b6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006ba:	48 89 d6             	mov    %rdx,%rsi
  8006bd:	89 df                	mov    %ebx,%edi
  8006bf:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006c5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006c9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006cd:	0f b6 00             	movzbl (%rax),%eax
  8006d0:	0f b6 d8             	movzbl %al,%ebx
  8006d3:	83 fb 25             	cmp    $0x25,%ebx
  8006d6:	75 d2                	jne    8006aa <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006d8:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006dc:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8006e3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006ea:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006f1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006f8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006fc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800700:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800704:	0f b6 00             	movzbl (%rax),%eax
  800707:	0f b6 d8             	movzbl %al,%ebx
  80070a:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80070d:	83 f8 55             	cmp    $0x55,%eax
  800710:	0f 87 22 04 00 00    	ja     800b38 <vprintfmt+0x4c9>
  800716:	89 c0                	mov    %eax,%eax
  800718:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80071f:	00 
  800720:	48 b8 d8 1c 80 00 00 	movabs $0x801cd8,%rax
  800727:	00 00 00 
  80072a:	48 01 d0             	add    %rdx,%rax
  80072d:	48 8b 00             	mov    (%rax),%rax
  800730:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800732:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800736:	eb c0                	jmp    8006f8 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800738:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80073c:	eb ba                	jmp    8006f8 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80073e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800745:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800748:	89 d0                	mov    %edx,%eax
  80074a:	c1 e0 02             	shl    $0x2,%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	01 c0                	add    %eax,%eax
  800751:	01 d8                	add    %ebx,%eax
  800753:	83 e8 30             	sub    $0x30,%eax
  800756:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800759:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80075d:	0f b6 00             	movzbl (%rax),%eax
  800760:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800763:	83 fb 2f             	cmp    $0x2f,%ebx
  800766:	7e 60                	jle    8007c8 <vprintfmt+0x159>
  800768:	83 fb 39             	cmp    $0x39,%ebx
  80076b:	7f 5b                	jg     8007c8 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80076d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800772:	eb d1                	jmp    800745 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800774:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800777:	83 f8 30             	cmp    $0x30,%eax
  80077a:	73 17                	jae    800793 <vprintfmt+0x124>
  80077c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800780:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800783:	89 d2                	mov    %edx,%edx
  800785:	48 01 d0             	add    %rdx,%rax
  800788:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80078b:	83 c2 08             	add    $0x8,%edx
  80078e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800791:	eb 0c                	jmp    80079f <vprintfmt+0x130>
  800793:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800797:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80079b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80079f:	8b 00                	mov    (%rax),%eax
  8007a1:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007a4:	eb 23                	jmp    8007c9 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  8007a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007aa:	0f 89 48 ff ff ff    	jns    8006f8 <vprintfmt+0x89>
				width = 0;
  8007b0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007b7:	e9 3c ff ff ff       	jmpq   8006f8 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007bc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007c3:	e9 30 ff ff ff       	jmpq   8006f8 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007c8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007cd:	0f 89 25 ff ff ff    	jns    8006f8 <vprintfmt+0x89>
				width = precision, precision = -1;
  8007d3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007d6:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007d9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007e0:	e9 13 ff ff ff       	jmpq   8006f8 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007e5:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007e9:	e9 0a ff ff ff       	jmpq   8006f8 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f1:	83 f8 30             	cmp    $0x30,%eax
  8007f4:	73 17                	jae    80080d <vprintfmt+0x19e>
  8007f6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8007fa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007fd:	89 d2                	mov    %edx,%edx
  8007ff:	48 01 d0             	add    %rdx,%rax
  800802:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800805:	83 c2 08             	add    $0x8,%edx
  800808:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80080b:	eb 0c                	jmp    800819 <vprintfmt+0x1aa>
  80080d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800811:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800815:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800819:	8b 10                	mov    (%rax),%edx
  80081b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80081f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800823:	48 89 ce             	mov    %rcx,%rsi
  800826:	89 d7                	mov    %edx,%edi
  800828:	ff d0                	callq  *%rax
			break;
  80082a:	e9 37 03 00 00       	jmpq   800b66 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80082f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800832:	83 f8 30             	cmp    $0x30,%eax
  800835:	73 17                	jae    80084e <vprintfmt+0x1df>
  800837:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80083b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80083e:	89 d2                	mov    %edx,%edx
  800840:	48 01 d0             	add    %rdx,%rax
  800843:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800846:	83 c2 08             	add    $0x8,%edx
  800849:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80084c:	eb 0c                	jmp    80085a <vprintfmt+0x1eb>
  80084e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800852:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800856:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80085a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80085c:	85 db                	test   %ebx,%ebx
  80085e:	79 02                	jns    800862 <vprintfmt+0x1f3>
				err = -err;
  800860:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800862:	83 fb 15             	cmp    $0x15,%ebx
  800865:	7f 16                	jg     80087d <vprintfmt+0x20e>
  800867:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  80086e:	00 00 00 
  800871:	48 63 d3             	movslq %ebx,%rdx
  800874:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800878:	4d 85 e4             	test   %r12,%r12
  80087b:	75 2e                	jne    8008ab <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  80087d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800881:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800885:	89 d9                	mov    %ebx,%ecx
  800887:	48 ba c1 1c 80 00 00 	movabs $0x801cc1,%rdx
  80088e:	00 00 00 
  800891:	48 89 c7             	mov    %rax,%rdi
  800894:	b8 00 00 00 00       	mov    $0x0,%eax
  800899:	49 b8 75 0b 80 00 00 	movabs $0x800b75,%r8
  8008a0:	00 00 00 
  8008a3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008a6:	e9 bb 02 00 00       	jmpq   800b66 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ab:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b3:	4c 89 e1             	mov    %r12,%rcx
  8008b6:	48 ba ca 1c 80 00 00 	movabs $0x801cca,%rdx
  8008bd:	00 00 00 
  8008c0:	48 89 c7             	mov    %rax,%rdi
  8008c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c8:	49 b8 75 0b 80 00 00 	movabs $0x800b75,%r8
  8008cf:	00 00 00 
  8008d2:	41 ff d0             	callq  *%r8
			break;
  8008d5:	e9 8c 02 00 00       	jmpq   800b66 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008dd:	83 f8 30             	cmp    $0x30,%eax
  8008e0:	73 17                	jae    8008f9 <vprintfmt+0x28a>
  8008e2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8008e6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008e9:	89 d2                	mov    %edx,%edx
  8008eb:	48 01 d0             	add    %rdx,%rax
  8008ee:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008f1:	83 c2 08             	add    $0x8,%edx
  8008f4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008f7:	eb 0c                	jmp    800905 <vprintfmt+0x296>
  8008f9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8008fd:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800901:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800905:	4c 8b 20             	mov    (%rax),%r12
  800908:	4d 85 e4             	test   %r12,%r12
  80090b:	75 0a                	jne    800917 <vprintfmt+0x2a8>
				p = "(null)";
  80090d:	49 bc cd 1c 80 00 00 	movabs $0x801ccd,%r12
  800914:	00 00 00 
			if (width > 0 && padc != '-')
  800917:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80091b:	7e 78                	jle    800995 <vprintfmt+0x326>
  80091d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800921:	74 72                	je     800995 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800923:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800926:	48 98                	cltq   
  800928:	48 89 c6             	mov    %rax,%rsi
  80092b:	4c 89 e7             	mov    %r12,%rdi
  80092e:	48 b8 23 0e 80 00 00 	movabs $0x800e23,%rax
  800935:	00 00 00 
  800938:	ff d0                	callq  *%rax
  80093a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80093d:	eb 17                	jmp    800956 <vprintfmt+0x2e7>
					putch(padc, putdat);
  80093f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800943:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800947:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80094b:	48 89 ce             	mov    %rcx,%rsi
  80094e:	89 d7                	mov    %edx,%edi
  800950:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800952:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800956:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80095a:	7f e3                	jg     80093f <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095c:	eb 37                	jmp    800995 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  80095e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800962:	74 1e                	je     800982 <vprintfmt+0x313>
  800964:	83 fb 1f             	cmp    $0x1f,%ebx
  800967:	7e 05                	jle    80096e <vprintfmt+0x2ff>
  800969:	83 fb 7e             	cmp    $0x7e,%ebx
  80096c:	7e 14                	jle    800982 <vprintfmt+0x313>
					putch('?', putdat);
  80096e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800972:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800976:	48 89 d6             	mov    %rdx,%rsi
  800979:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80097e:	ff d0                	callq  *%rax
  800980:	eb 0f                	jmp    800991 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800982:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800986:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098a:	48 89 d6             	mov    %rdx,%rsi
  80098d:	89 df                	mov    %ebx,%edi
  80098f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800991:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800995:	4c 89 e0             	mov    %r12,%rax
  800998:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80099c:	0f b6 00             	movzbl (%rax),%eax
  80099f:	0f be d8             	movsbl %al,%ebx
  8009a2:	85 db                	test   %ebx,%ebx
  8009a4:	74 28                	je     8009ce <vprintfmt+0x35f>
  8009a6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009aa:	78 b2                	js     80095e <vprintfmt+0x2ef>
  8009ac:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009b0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009b4:	79 a8                	jns    80095e <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009b6:	eb 16                	jmp    8009ce <vprintfmt+0x35f>
				putch(' ', putdat);
  8009b8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009bc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c0:	48 89 d6             	mov    %rdx,%rsi
  8009c3:	bf 20 00 00 00       	mov    $0x20,%edi
  8009c8:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ca:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009d2:	7f e4                	jg     8009b8 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  8009d4:	e9 8d 01 00 00       	jmpq   800b66 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8009d9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009dd:	be 03 00 00 00       	mov    $0x3,%esi
  8009e2:	48 89 c7             	mov    %rax,%rdi
  8009e5:	48 b8 68 05 80 00 00 	movabs $0x800568,%rax
  8009ec:	00 00 00 
  8009ef:	ff d0                	callq  *%rax
  8009f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f9:	48 85 c0             	test   %rax,%rax
  8009fc:	79 1d                	jns    800a1b <vprintfmt+0x3ac>
				putch('-', putdat);
  8009fe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a06:	48 89 d6             	mov    %rdx,%rsi
  800a09:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a0e:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a14:	48 f7 d8             	neg    %rax
  800a17:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a1b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a22:	e9 d2 00 00 00       	jmpq   800af9 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a27:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a2b:	be 03 00 00 00       	mov    $0x3,%esi
  800a30:	48 89 c7             	mov    %rax,%rdi
  800a33:	48 b8 61 04 80 00 00 	movabs $0x800461,%rax
  800a3a:	00 00 00 
  800a3d:	ff d0                	callq  *%rax
  800a3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a43:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a4a:	e9 aa 00 00 00       	jmpq   800af9 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800a4f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a53:	be 03 00 00 00       	mov    $0x3,%esi
  800a58:	48 89 c7             	mov    %rax,%rdi
  800a5b:	48 b8 61 04 80 00 00 	movabs $0x800461,%rax
  800a62:	00 00 00 
  800a65:	ff d0                	callq  *%rax
  800a67:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a6b:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a72:	e9 82 00 00 00       	jmpq   800af9 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800a77:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a7f:	48 89 d6             	mov    %rdx,%rsi
  800a82:	bf 30 00 00 00       	mov    $0x30,%edi
  800a87:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a91:	48 89 d6             	mov    %rdx,%rsi
  800a94:	bf 78 00 00 00       	mov    $0x78,%edi
  800a99:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9e:	83 f8 30             	cmp    $0x30,%eax
  800aa1:	73 17                	jae    800aba <vprintfmt+0x44b>
  800aa3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800aa7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aaa:	89 d2                	mov    %edx,%edx
  800aac:	48 01 d0             	add    %rdx,%rax
  800aaf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ab2:	83 c2 08             	add    $0x8,%edx
  800ab5:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ab8:	eb 0c                	jmp    800ac6 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800aba:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800abe:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ac2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ac6:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ac9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800acd:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ad4:	eb 23                	jmp    800af9 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ad6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ada:	be 03 00 00 00       	mov    $0x3,%esi
  800adf:	48 89 c7             	mov    %rax,%rdi
  800ae2:	48 b8 61 04 80 00 00 	movabs $0x800461,%rax
  800ae9:	00 00 00 
  800aec:	ff d0                	callq  *%rax
  800aee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800af2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800af9:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800afe:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b01:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b04:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b08:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b10:	45 89 c1             	mov    %r8d,%r9d
  800b13:	41 89 f8             	mov    %edi,%r8d
  800b16:	48 89 c7             	mov    %rax,%rdi
  800b19:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  800b20:	00 00 00 
  800b23:	ff d0                	callq  *%rax
			break;
  800b25:	eb 3f                	jmp    800b66 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b27:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2f:	48 89 d6             	mov    %rdx,%rsi
  800b32:	89 df                	mov    %ebx,%edi
  800b34:	ff d0                	callq  *%rax
			break;
  800b36:	eb 2e                	jmp    800b66 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b38:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b40:	48 89 d6             	mov    %rdx,%rsi
  800b43:	bf 25 00 00 00       	mov    $0x25,%edi
  800b48:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b4a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b4f:	eb 05                	jmp    800b56 <vprintfmt+0x4e7>
  800b51:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b56:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b5a:	48 83 e8 01          	sub    $0x1,%rax
  800b5e:	0f b6 00             	movzbl (%rax),%eax
  800b61:	3c 25                	cmp    $0x25,%al
  800b63:	75 ec                	jne    800b51 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800b65:	90                   	nop
		}
	}
  800b66:	e9 3d fb ff ff       	jmpq   8006a8 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b6b:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b6c:	48 83 c4 60          	add    $0x60,%rsp
  800b70:	5b                   	pop    %rbx
  800b71:	41 5c                	pop    %r12
  800b73:	5d                   	pop    %rbp
  800b74:	c3                   	retq   

0000000000800b75 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b75:	55                   	push   %rbp
  800b76:	48 89 e5             	mov    %rsp,%rbp
  800b79:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b80:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b87:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b8e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800b95:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b9c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ba3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800baa:	84 c0                	test   %al,%al
  800bac:	74 20                	je     800bce <printfmt+0x59>
  800bae:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bb2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bb6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bba:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bbe:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bc2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bc6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bca:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800bce:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800bd5:	00 00 00 
  800bd8:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800bdf:	00 00 00 
  800be2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800be6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bed:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bf4:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bfb:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c02:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c09:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c10:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c17:	48 89 c7             	mov    %rax,%rdi
  800c1a:	48 b8 6f 06 80 00 00 	movabs $0x80066f,%rax
  800c21:	00 00 00 
  800c24:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c26:	90                   	nop
  800c27:	c9                   	leaveq 
  800c28:	c3                   	retq   

0000000000800c29 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c29:	55                   	push   %rbp
  800c2a:	48 89 e5             	mov    %rsp,%rbp
  800c2d:	48 83 ec 10          	sub    $0x10,%rsp
  800c31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c34:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c3c:	8b 40 10             	mov    0x10(%rax),%eax
  800c3f:	8d 50 01             	lea    0x1(%rax),%edx
  800c42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c46:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c4d:	48 8b 10             	mov    (%rax),%rdx
  800c50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c54:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c58:	48 39 c2             	cmp    %rax,%rdx
  800c5b:	73 17                	jae    800c74 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c61:	48 8b 00             	mov    (%rax),%rax
  800c64:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c6c:	48 89 0a             	mov    %rcx,(%rdx)
  800c6f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c72:	88 10                	mov    %dl,(%rax)
}
  800c74:	90                   	nop
  800c75:	c9                   	leaveq 
  800c76:	c3                   	retq   

0000000000800c77 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c77:	55                   	push   %rbp
  800c78:	48 89 e5             	mov    %rsp,%rbp
  800c7b:	48 83 ec 50          	sub    $0x50,%rsp
  800c7f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c83:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c86:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c8a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c8e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c92:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c96:	48 8b 0a             	mov    (%rdx),%rcx
  800c99:	48 89 08             	mov    %rcx,(%rax)
  800c9c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ca0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ca4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ca8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cac:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cb0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cb4:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cb7:	48 98                	cltq   
  800cb9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800cbd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cc1:	48 01 d0             	add    %rdx,%rax
  800cc4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800cc8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ccf:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800cd4:	74 06                	je     800cdc <vsnprintf+0x65>
  800cd6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800cda:	7f 07                	jg     800ce3 <vsnprintf+0x6c>
		return -E_INVAL;
  800cdc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ce1:	eb 2f                	jmp    800d12 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ce3:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ce7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ceb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cef:	48 89 c6             	mov    %rax,%rsi
  800cf2:	48 bf 29 0c 80 00 00 	movabs $0x800c29,%rdi
  800cf9:	00 00 00 
  800cfc:	48 b8 6f 06 80 00 00 	movabs $0x80066f,%rax
  800d03:	00 00 00 
  800d06:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d08:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d0c:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d0f:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d12:	c9                   	leaveq 
  800d13:	c3                   	retq   

0000000000800d14 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d14:	55                   	push   %rbp
  800d15:	48 89 e5             	mov    %rsp,%rbp
  800d18:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d1f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d26:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d2c:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800d33:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d3a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d41:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d48:	84 c0                	test   %al,%al
  800d4a:	74 20                	je     800d6c <snprintf+0x58>
  800d4c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d50:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d54:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d58:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d5c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d60:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d64:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d68:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d6c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d73:	00 00 00 
  800d76:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d7d:	00 00 00 
  800d80:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d84:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d8b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d92:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d99:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800da0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800da7:	48 8b 0a             	mov    (%rdx),%rcx
  800daa:	48 89 08             	mov    %rcx,(%rax)
  800dad:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800db1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800db5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800db9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800dbd:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800dc4:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800dcb:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800dd1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800dd8:	48 89 c7             	mov    %rax,%rdi
  800ddb:	48 b8 77 0c 80 00 00 	movabs $0x800c77,%rax
  800de2:	00 00 00 
  800de5:	ff d0                	callq  *%rax
  800de7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ded:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800df3:	c9                   	leaveq 
  800df4:	c3                   	retq   

0000000000800df5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800df5:	55                   	push   %rbp
  800df6:	48 89 e5             	mov    %rsp,%rbp
  800df9:	48 83 ec 18          	sub    $0x18,%rsp
  800dfd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e08:	eb 09                	jmp    800e13 <strlen+0x1e>
		n++;
  800e0a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e0e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e17:	0f b6 00             	movzbl (%rax),%eax
  800e1a:	84 c0                	test   %al,%al
  800e1c:	75 ec                	jne    800e0a <strlen+0x15>
		n++;
	return n;
  800e1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e21:	c9                   	leaveq 
  800e22:	c3                   	retq   

0000000000800e23 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e23:	55                   	push   %rbp
  800e24:	48 89 e5             	mov    %rsp,%rbp
  800e27:	48 83 ec 20          	sub    $0x20,%rsp
  800e2b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e2f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e3a:	eb 0e                	jmp    800e4a <strnlen+0x27>
		n++;
  800e3c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e40:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e45:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e4a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e4f:	74 0b                	je     800e5c <strnlen+0x39>
  800e51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e55:	0f b6 00             	movzbl (%rax),%eax
  800e58:	84 c0                	test   %al,%al
  800e5a:	75 e0                	jne    800e3c <strnlen+0x19>
		n++;
	return n;
  800e5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e5f:	c9                   	leaveq 
  800e60:	c3                   	retq   

0000000000800e61 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e61:	55                   	push   %rbp
  800e62:	48 89 e5             	mov    %rsp,%rbp
  800e65:	48 83 ec 20          	sub    $0x20,%rsp
  800e69:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e6d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e75:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e79:	90                   	nop
  800e7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e82:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e86:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e8a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e8e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e92:	0f b6 12             	movzbl (%rdx),%edx
  800e95:	88 10                	mov    %dl,(%rax)
  800e97:	0f b6 00             	movzbl (%rax),%eax
  800e9a:	84 c0                	test   %al,%al
  800e9c:	75 dc                	jne    800e7a <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ea2:	c9                   	leaveq 
  800ea3:	c3                   	retq   

0000000000800ea4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ea4:	55                   	push   %rbp
  800ea5:	48 89 e5             	mov    %rsp,%rbp
  800ea8:	48 83 ec 20          	sub    $0x20,%rsp
  800eac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800eb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb8:	48 89 c7             	mov    %rax,%rdi
  800ebb:	48 b8 f5 0d 80 00 00 	movabs $0x800df5,%rax
  800ec2:	00 00 00 
  800ec5:	ff d0                	callq  *%rax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800eca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ecd:	48 63 d0             	movslq %eax,%rdx
  800ed0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed4:	48 01 c2             	add    %rax,%rdx
  800ed7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800edb:	48 89 c6             	mov    %rax,%rsi
  800ede:	48 89 d7             	mov    %rdx,%rdi
  800ee1:	48 b8 61 0e 80 00 00 	movabs $0x800e61,%rax
  800ee8:	00 00 00 
  800eeb:	ff d0                	callq  *%rax
	return dst;
  800eed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ef1:	c9                   	leaveq 
  800ef2:	c3                   	retq   

0000000000800ef3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ef3:	55                   	push   %rbp
  800ef4:	48 89 e5             	mov    %rsp,%rbp
  800ef7:	48 83 ec 28          	sub    $0x28,%rsp
  800efb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f03:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f0f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f16:	00 
  800f17:	eb 2a                	jmp    800f43 <strncpy+0x50>
		*dst++ = *src;
  800f19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f1d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f21:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f25:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f29:	0f b6 12             	movzbl (%rdx),%edx
  800f2c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f2e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f32:	0f b6 00             	movzbl (%rax),%eax
  800f35:	84 c0                	test   %al,%al
  800f37:	74 05                	je     800f3e <strncpy+0x4b>
			src++;
  800f39:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f3e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f47:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f4b:	72 cc                	jb     800f19 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f51:	c9                   	leaveq 
  800f52:	c3                   	retq   

0000000000800f53 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f53:	55                   	push   %rbp
  800f54:	48 89 e5             	mov    %rsp,%rbp
  800f57:	48 83 ec 28          	sub    $0x28,%rsp
  800f5b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f5f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f63:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f6f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f74:	74 3d                	je     800fb3 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f76:	eb 1d                	jmp    800f95 <strlcpy+0x42>
			*dst++ = *src++;
  800f78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f80:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f84:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f88:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f8c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f90:	0f b6 12             	movzbl (%rdx),%edx
  800f93:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f95:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f9a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f9f:	74 0b                	je     800fac <strlcpy+0x59>
  800fa1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fa5:	0f b6 00             	movzbl (%rax),%eax
  800fa8:	84 c0                	test   %al,%al
  800faa:	75 cc                	jne    800f78 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb0:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800fb3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fbb:	48 29 c2             	sub    %rax,%rdx
  800fbe:	48 89 d0             	mov    %rdx,%rax
}
  800fc1:	c9                   	leaveq 
  800fc2:	c3                   	retq   

0000000000800fc3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fc3:	55                   	push   %rbp
  800fc4:	48 89 e5             	mov    %rsp,%rbp
  800fc7:	48 83 ec 10          	sub    $0x10,%rsp
  800fcb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fcf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800fd3:	eb 0a                	jmp    800fdf <strcmp+0x1c>
		p++, q++;
  800fd5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fda:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fe3:	0f b6 00             	movzbl (%rax),%eax
  800fe6:	84 c0                	test   %al,%al
  800fe8:	74 12                	je     800ffc <strcmp+0x39>
  800fea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fee:	0f b6 10             	movzbl (%rax),%edx
  800ff1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff5:	0f b6 00             	movzbl (%rax),%eax
  800ff8:	38 c2                	cmp    %al,%dl
  800ffa:	74 d9                	je     800fd5 <strcmp+0x12>
		p++, q++;
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

0000000000801016 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801016:	55                   	push   %rbp
  801017:	48 89 e5             	mov    %rsp,%rbp
  80101a:	48 83 ec 18          	sub    $0x18,%rsp
  80101e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801022:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801026:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80102a:	eb 0f                	jmp    80103b <strncmp+0x25>
		n--, p++, q++;
  80102c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801031:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801036:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80103b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801040:	74 1d                	je     80105f <strncmp+0x49>
  801042:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801046:	0f b6 00             	movzbl (%rax),%eax
  801049:	84 c0                	test   %al,%al
  80104b:	74 12                	je     80105f <strncmp+0x49>
  80104d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801051:	0f b6 10             	movzbl (%rax),%edx
  801054:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801058:	0f b6 00             	movzbl (%rax),%eax
  80105b:	38 c2                	cmp    %al,%dl
  80105d:	74 cd                	je     80102c <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80105f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801064:	75 07                	jne    80106d <strncmp+0x57>
		return 0;
  801066:	b8 00 00 00 00       	mov    $0x0,%eax
  80106b:	eb 18                	jmp    801085 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80106d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801071:	0f b6 00             	movzbl (%rax),%eax
  801074:	0f b6 d0             	movzbl %al,%edx
  801077:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80107b:	0f b6 00             	movzbl (%rax),%eax
  80107e:	0f b6 c0             	movzbl %al,%eax
  801081:	29 c2                	sub    %eax,%edx
  801083:	89 d0                	mov    %edx,%eax
}
  801085:	c9                   	leaveq 
  801086:	c3                   	retq   

0000000000801087 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801087:	55                   	push   %rbp
  801088:	48 89 e5             	mov    %rsp,%rbp
  80108b:	48 83 ec 10          	sub    $0x10,%rsp
  80108f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801093:	89 f0                	mov    %esi,%eax
  801095:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801098:	eb 17                	jmp    8010b1 <strchr+0x2a>
		if (*s == c)
  80109a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109e:	0f b6 00             	movzbl (%rax),%eax
  8010a1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010a4:	75 06                	jne    8010ac <strchr+0x25>
			return (char *) s;
  8010a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010aa:	eb 15                	jmp    8010c1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b5:	0f b6 00             	movzbl (%rax),%eax
  8010b8:	84 c0                	test   %al,%al
  8010ba:	75 de                	jne    80109a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c1:	c9                   	leaveq 
  8010c2:	c3                   	retq   

00000000008010c3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010c3:	55                   	push   %rbp
  8010c4:	48 89 e5             	mov    %rsp,%rbp
  8010c7:	48 83 ec 10          	sub    $0x10,%rsp
  8010cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010cf:	89 f0                	mov    %esi,%eax
  8010d1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010d4:	eb 11                	jmp    8010e7 <strfind+0x24>
		if (*s == c)
  8010d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010da:	0f b6 00             	movzbl (%rax),%eax
  8010dd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010e0:	74 12                	je     8010f4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010e2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010eb:	0f b6 00             	movzbl (%rax),%eax
  8010ee:	84 c0                	test   %al,%al
  8010f0:	75 e4                	jne    8010d6 <strfind+0x13>
  8010f2:	eb 01                	jmp    8010f5 <strfind+0x32>
		if (*s == c)
			break;
  8010f4:	90                   	nop
	return (char *) s;
  8010f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010f9:	c9                   	leaveq 
  8010fa:	c3                   	retq   

00000000008010fb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010fb:	55                   	push   %rbp
  8010fc:	48 89 e5             	mov    %rsp,%rbp
  8010ff:	48 83 ec 18          	sub    $0x18,%rsp
  801103:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801107:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80110a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80110e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801113:	75 06                	jne    80111b <memset+0x20>
		return v;
  801115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801119:	eb 69                	jmp    801184 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80111b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111f:	83 e0 03             	and    $0x3,%eax
  801122:	48 85 c0             	test   %rax,%rax
  801125:	75 48                	jne    80116f <memset+0x74>
  801127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112b:	83 e0 03             	and    $0x3,%eax
  80112e:	48 85 c0             	test   %rax,%rax
  801131:	75 3c                	jne    80116f <memset+0x74>
		c &= 0xFF;
  801133:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80113a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80113d:	c1 e0 18             	shl    $0x18,%eax
  801140:	89 c2                	mov    %eax,%edx
  801142:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801145:	c1 e0 10             	shl    $0x10,%eax
  801148:	09 c2                	or     %eax,%edx
  80114a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80114d:	c1 e0 08             	shl    $0x8,%eax
  801150:	09 d0                	or     %edx,%eax
  801152:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801159:	48 c1 e8 02          	shr    $0x2,%rax
  80115d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801160:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801164:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801167:	48 89 d7             	mov    %rdx,%rdi
  80116a:	fc                   	cld    
  80116b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80116d:	eb 11                	jmp    801180 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80116f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801173:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801176:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80117a:	48 89 d7             	mov    %rdx,%rdi
  80117d:	fc                   	cld    
  80117e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801180:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801184:	c9                   	leaveq 
  801185:	c3                   	retq   

0000000000801186 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801186:	55                   	push   %rbp
  801187:	48 89 e5             	mov    %rsp,%rbp
  80118a:	48 83 ec 28          	sub    $0x28,%rsp
  80118e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801192:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801196:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80119a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80119e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ae:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011b2:	0f 83 88 00 00 00    	jae    801240 <memmove+0xba>
  8011b8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011c0:	48 01 d0             	add    %rdx,%rax
  8011c3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011c7:	76 77                	jbe    801240 <memmove+0xba>
		s += n;
  8011c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011cd:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011dd:	83 e0 03             	and    $0x3,%eax
  8011e0:	48 85 c0             	test   %rax,%rax
  8011e3:	75 3b                	jne    801220 <memmove+0x9a>
  8011e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e9:	83 e0 03             	and    $0x3,%eax
  8011ec:	48 85 c0             	test   %rax,%rax
  8011ef:	75 2f                	jne    801220 <memmove+0x9a>
  8011f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f5:	83 e0 03             	and    $0x3,%eax
  8011f8:	48 85 c0             	test   %rax,%rax
  8011fb:	75 23                	jne    801220 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801201:	48 83 e8 04          	sub    $0x4,%rax
  801205:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801209:	48 83 ea 04          	sub    $0x4,%rdx
  80120d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801211:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801215:	48 89 c7             	mov    %rax,%rdi
  801218:	48 89 d6             	mov    %rdx,%rsi
  80121b:	fd                   	std    
  80121c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80121e:	eb 1d                	jmp    80123d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801220:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801224:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801228:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801230:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801234:	48 89 d7             	mov    %rdx,%rdi
  801237:	48 89 c1             	mov    %rax,%rcx
  80123a:	fd                   	std    
  80123b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80123d:	fc                   	cld    
  80123e:	eb 57                	jmp    801297 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801240:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801244:	83 e0 03             	and    $0x3,%eax
  801247:	48 85 c0             	test   %rax,%rax
  80124a:	75 36                	jne    801282 <memmove+0xfc>
  80124c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801250:	83 e0 03             	and    $0x3,%eax
  801253:	48 85 c0             	test   %rax,%rax
  801256:	75 2a                	jne    801282 <memmove+0xfc>
  801258:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80125c:	83 e0 03             	and    $0x3,%eax
  80125f:	48 85 c0             	test   %rax,%rax
  801262:	75 1e                	jne    801282 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801264:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801268:	48 c1 e8 02          	shr    $0x2,%rax
  80126c:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80126f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801273:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801277:	48 89 c7             	mov    %rax,%rdi
  80127a:	48 89 d6             	mov    %rdx,%rsi
  80127d:	fc                   	cld    
  80127e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801280:	eb 15                	jmp    801297 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801282:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801286:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80128a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80128e:	48 89 c7             	mov    %rax,%rdi
  801291:	48 89 d6             	mov    %rdx,%rsi
  801294:	fc                   	cld    
  801295:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801297:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80129b:	c9                   	leaveq 
  80129c:	c3                   	retq   

000000000080129d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80129d:	55                   	push   %rbp
  80129e:	48 89 e5             	mov    %rsp,%rbp
  8012a1:	48 83 ec 18          	sub    $0x18,%rsp
  8012a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012ad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012b5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bd:	48 89 ce             	mov    %rcx,%rsi
  8012c0:	48 89 c7             	mov    %rax,%rdi
  8012c3:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  8012ca:	00 00 00 
  8012cd:	ff d0                	callq  *%rax
}
  8012cf:	c9                   	leaveq 
  8012d0:	c3                   	retq   

00000000008012d1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012d1:	55                   	push   %rbp
  8012d2:	48 89 e5             	mov    %rsp,%rbp
  8012d5:	48 83 ec 28          	sub    $0x28,%rsp
  8012d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012f5:	eb 36                	jmp    80132d <memcmp+0x5c>
		if (*s1 != *s2)
  8012f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fb:	0f b6 10             	movzbl (%rax),%edx
  8012fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801302:	0f b6 00             	movzbl (%rax),%eax
  801305:	38 c2                	cmp    %al,%dl
  801307:	74 1a                	je     801323 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130d:	0f b6 00             	movzbl (%rax),%eax
  801310:	0f b6 d0             	movzbl %al,%edx
  801313:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801317:	0f b6 00             	movzbl (%rax),%eax
  80131a:	0f b6 c0             	movzbl %al,%eax
  80131d:	29 c2                	sub    %eax,%edx
  80131f:	89 d0                	mov    %edx,%eax
  801321:	eb 20                	jmp    801343 <memcmp+0x72>
		s1++, s2++;
  801323:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801328:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80132d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801331:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801335:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801339:	48 85 c0             	test   %rax,%rax
  80133c:	75 b9                	jne    8012f7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80133e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801343:	c9                   	leaveq 
  801344:	c3                   	retq   

0000000000801345 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801345:	55                   	push   %rbp
  801346:	48 89 e5             	mov    %rsp,%rbp
  801349:	48 83 ec 28          	sub    $0x28,%rsp
  80134d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801351:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801354:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801358:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80135c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801360:	48 01 d0             	add    %rdx,%rax
  801363:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801367:	eb 19                	jmp    801382 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136d:	0f b6 00             	movzbl (%rax),%eax
  801370:	0f b6 d0             	movzbl %al,%edx
  801373:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801376:	0f b6 c0             	movzbl %al,%eax
  801379:	39 c2                	cmp    %eax,%edx
  80137b:	74 11                	je     80138e <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80137d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801382:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801386:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80138a:	72 dd                	jb     801369 <memfind+0x24>
  80138c:	eb 01                	jmp    80138f <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80138e:	90                   	nop
	return (void *) s;
  80138f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801393:	c9                   	leaveq 
  801394:	c3                   	retq   

0000000000801395 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801395:	55                   	push   %rbp
  801396:	48 89 e5             	mov    %rsp,%rbp
  801399:	48 83 ec 38          	sub    $0x38,%rsp
  80139d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013a1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013a5:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013af:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013b6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013b7:	eb 05                	jmp    8013be <strtol+0x29>
		s++;
  8013b9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c2:	0f b6 00             	movzbl (%rax),%eax
  8013c5:	3c 20                	cmp    $0x20,%al
  8013c7:	74 f0                	je     8013b9 <strtol+0x24>
  8013c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cd:	0f b6 00             	movzbl (%rax),%eax
  8013d0:	3c 09                	cmp    $0x9,%al
  8013d2:	74 e5                	je     8013b9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d8:	0f b6 00             	movzbl (%rax),%eax
  8013db:	3c 2b                	cmp    $0x2b,%al
  8013dd:	75 07                	jne    8013e6 <strtol+0x51>
		s++;
  8013df:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013e4:	eb 17                	jmp    8013fd <strtol+0x68>
	else if (*s == '-')
  8013e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ea:	0f b6 00             	movzbl (%rax),%eax
  8013ed:	3c 2d                	cmp    $0x2d,%al
  8013ef:	75 0c                	jne    8013fd <strtol+0x68>
		s++, neg = 1;
  8013f1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013fd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801401:	74 06                	je     801409 <strtol+0x74>
  801403:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801407:	75 28                	jne    801431 <strtol+0x9c>
  801409:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140d:	0f b6 00             	movzbl (%rax),%eax
  801410:	3c 30                	cmp    $0x30,%al
  801412:	75 1d                	jne    801431 <strtol+0x9c>
  801414:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801418:	48 83 c0 01          	add    $0x1,%rax
  80141c:	0f b6 00             	movzbl (%rax),%eax
  80141f:	3c 78                	cmp    $0x78,%al
  801421:	75 0e                	jne    801431 <strtol+0x9c>
		s += 2, base = 16;
  801423:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801428:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80142f:	eb 2c                	jmp    80145d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801431:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801435:	75 19                	jne    801450 <strtol+0xbb>
  801437:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143b:	0f b6 00             	movzbl (%rax),%eax
  80143e:	3c 30                	cmp    $0x30,%al
  801440:	75 0e                	jne    801450 <strtol+0xbb>
		s++, base = 8;
  801442:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801447:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80144e:	eb 0d                	jmp    80145d <strtol+0xc8>
	else if (base == 0)
  801450:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801454:	75 07                	jne    80145d <strtol+0xc8>
		base = 10;
  801456:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80145d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801461:	0f b6 00             	movzbl (%rax),%eax
  801464:	3c 2f                	cmp    $0x2f,%al
  801466:	7e 1d                	jle    801485 <strtol+0xf0>
  801468:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146c:	0f b6 00             	movzbl (%rax),%eax
  80146f:	3c 39                	cmp    $0x39,%al
  801471:	7f 12                	jg     801485 <strtol+0xf0>
			dig = *s - '0';
  801473:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801477:	0f b6 00             	movzbl (%rax),%eax
  80147a:	0f be c0             	movsbl %al,%eax
  80147d:	83 e8 30             	sub    $0x30,%eax
  801480:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801483:	eb 4e                	jmp    8014d3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801485:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801489:	0f b6 00             	movzbl (%rax),%eax
  80148c:	3c 60                	cmp    $0x60,%al
  80148e:	7e 1d                	jle    8014ad <strtol+0x118>
  801490:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801494:	0f b6 00             	movzbl (%rax),%eax
  801497:	3c 7a                	cmp    $0x7a,%al
  801499:	7f 12                	jg     8014ad <strtol+0x118>
			dig = *s - 'a' + 10;
  80149b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149f:	0f b6 00             	movzbl (%rax),%eax
  8014a2:	0f be c0             	movsbl %al,%eax
  8014a5:	83 e8 57             	sub    $0x57,%eax
  8014a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014ab:	eb 26                	jmp    8014d3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b1:	0f b6 00             	movzbl (%rax),%eax
  8014b4:	3c 40                	cmp    $0x40,%al
  8014b6:	7e 47                	jle    8014ff <strtol+0x16a>
  8014b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014bc:	0f b6 00             	movzbl (%rax),%eax
  8014bf:	3c 5a                	cmp    $0x5a,%al
  8014c1:	7f 3c                	jg     8014ff <strtol+0x16a>
			dig = *s - 'A' + 10;
  8014c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c7:	0f b6 00             	movzbl (%rax),%eax
  8014ca:	0f be c0             	movsbl %al,%eax
  8014cd:	83 e8 37             	sub    $0x37,%eax
  8014d0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014d6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014d9:	7d 23                	jge    8014fe <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8014db:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014e0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014e3:	48 98                	cltq   
  8014e5:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014ea:	48 89 c2             	mov    %rax,%rdx
  8014ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014f0:	48 98                	cltq   
  8014f2:	48 01 d0             	add    %rdx,%rax
  8014f5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014f9:	e9 5f ff ff ff       	jmpq   80145d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014fe:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014ff:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801504:	74 0b                	je     801511 <strtol+0x17c>
		*endptr = (char *) s;
  801506:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80150a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80150e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801511:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801515:	74 09                	je     801520 <strtol+0x18b>
  801517:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151b:	48 f7 d8             	neg    %rax
  80151e:	eb 04                	jmp    801524 <strtol+0x18f>
  801520:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801524:	c9                   	leaveq 
  801525:	c3                   	retq   

0000000000801526 <strstr>:

char * strstr(const char *in, const char *str)
{
  801526:	55                   	push   %rbp
  801527:	48 89 e5             	mov    %rsp,%rbp
  80152a:	48 83 ec 30          	sub    $0x30,%rsp
  80152e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801532:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801536:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80153a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80153e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801542:	0f b6 00             	movzbl (%rax),%eax
  801545:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801548:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80154c:	75 06                	jne    801554 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80154e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801552:	eb 6b                	jmp    8015bf <strstr+0x99>

	len = strlen(str);
  801554:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801558:	48 89 c7             	mov    %rax,%rdi
  80155b:	48 b8 f5 0d 80 00 00 	movabs $0x800df5,%rax
  801562:	00 00 00 
  801565:	ff d0                	callq  *%rax
  801567:	48 98                	cltq   
  801569:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80156d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801571:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801575:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801579:	0f b6 00             	movzbl (%rax),%eax
  80157c:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80157f:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801583:	75 07                	jne    80158c <strstr+0x66>
				return (char *) 0;
  801585:	b8 00 00 00 00       	mov    $0x0,%eax
  80158a:	eb 33                	jmp    8015bf <strstr+0x99>
		} while (sc != c);
  80158c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801590:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801593:	75 d8                	jne    80156d <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801595:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801599:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80159d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a1:	48 89 ce             	mov    %rcx,%rsi
  8015a4:	48 89 c7             	mov    %rax,%rdi
  8015a7:	48 b8 16 10 80 00 00 	movabs $0x801016,%rax
  8015ae:	00 00 00 
  8015b1:	ff d0                	callq  *%rax
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	75 b6                	jne    80156d <strstr+0x47>

	return (char *) (in - 1);
  8015b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bb:	48 83 e8 01          	sub    $0x1,%rax
}
  8015bf:	c9                   	leaveq 
  8015c0:	c3                   	retq   

00000000008015c1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015c1:	55                   	push   %rbp
  8015c2:	48 89 e5             	mov    %rsp,%rbp
  8015c5:	53                   	push   %rbx
  8015c6:	48 83 ec 48          	sub    $0x48,%rsp
  8015ca:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015cd:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015d0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015d4:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015d8:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015dc:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015e0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015e3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015e7:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015eb:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015ef:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015f3:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015f7:	4c 89 c3             	mov    %r8,%rbx
  8015fa:	cd 30                	int    $0x30
  8015fc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801600:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801604:	74 3e                	je     801644 <syscall+0x83>
  801606:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80160b:	7e 37                	jle    801644 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80160d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801611:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801614:	49 89 d0             	mov    %rdx,%r8
  801617:	89 c1                	mov    %eax,%ecx
  801619:	48 ba 88 1f 80 00 00 	movabs $0x801f88,%rdx
  801620:	00 00 00 
  801623:	be 23 00 00 00       	mov    $0x23,%esi
  801628:	48 bf a5 1f 80 00 00 	movabs $0x801fa5,%rdi
  80162f:	00 00 00 
  801632:	b8 00 00 00 00       	mov    $0x0,%eax
  801637:	49 b9 cb 19 80 00 00 	movabs $0x8019cb,%r9
  80163e:	00 00 00 
  801641:	41 ff d1             	callq  *%r9

	return ret;
  801644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801648:	48 83 c4 48          	add    $0x48,%rsp
  80164c:	5b                   	pop    %rbx
  80164d:	5d                   	pop    %rbp
  80164e:	c3                   	retq   

000000000080164f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80164f:	55                   	push   %rbp
  801650:	48 89 e5             	mov    %rsp,%rbp
  801653:	48 83 ec 10          	sub    $0x10,%rsp
  801657:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80165b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80165f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801663:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801667:	48 83 ec 08          	sub    $0x8,%rsp
  80166b:	6a 00                	pushq  $0x0
  80166d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801673:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801679:	48 89 d1             	mov    %rdx,%rcx
  80167c:	48 89 c2             	mov    %rax,%rdx
  80167f:	be 00 00 00 00       	mov    $0x0,%esi
  801684:	bf 00 00 00 00       	mov    $0x0,%edi
  801689:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  801690:	00 00 00 
  801693:	ff d0                	callq  *%rax
  801695:	48 83 c4 10          	add    $0x10,%rsp
}
  801699:	90                   	nop
  80169a:	c9                   	leaveq 
  80169b:	c3                   	retq   

000000000080169c <sys_cgetc>:

int
sys_cgetc(void)
{
  80169c:	55                   	push   %rbp
  80169d:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016a0:	48 83 ec 08          	sub    $0x8,%rsp
  8016a4:	6a 00                	pushq  $0x0
  8016a6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bc:	be 00 00 00 00       	mov    $0x0,%esi
  8016c1:	bf 01 00 00 00       	mov    $0x1,%edi
  8016c6:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  8016cd:	00 00 00 
  8016d0:	ff d0                	callq  *%rax
  8016d2:	48 83 c4 10          	add    $0x10,%rsp
}
  8016d6:	c9                   	leaveq 
  8016d7:	c3                   	retq   

00000000008016d8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016d8:	55                   	push   %rbp
  8016d9:	48 89 e5             	mov    %rsp,%rbp
  8016dc:	48 83 ec 10          	sub    $0x10,%rsp
  8016e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016e6:	48 98                	cltq   
  8016e8:	48 83 ec 08          	sub    $0x8,%rsp
  8016ec:	6a 00                	pushq  $0x0
  8016ee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016f4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016ff:	48 89 c2             	mov    %rax,%rdx
  801702:	be 01 00 00 00       	mov    $0x1,%esi
  801707:	bf 03 00 00 00       	mov    $0x3,%edi
  80170c:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  801713:	00 00 00 
  801716:	ff d0                	callq  *%rax
  801718:	48 83 c4 10          	add    $0x10,%rsp
}
  80171c:	c9                   	leaveq 
  80171d:	c3                   	retq   

000000000080171e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80171e:	55                   	push   %rbp
  80171f:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801722:	48 83 ec 08          	sub    $0x8,%rsp
  801726:	6a 00                	pushq  $0x0
  801728:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80172e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801734:	b9 00 00 00 00       	mov    $0x0,%ecx
  801739:	ba 00 00 00 00       	mov    $0x0,%edx
  80173e:	be 00 00 00 00       	mov    $0x0,%esi
  801743:	bf 02 00 00 00       	mov    $0x2,%edi
  801748:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  80174f:	00 00 00 
  801752:	ff d0                	callq  *%rax
  801754:	48 83 c4 10          	add    $0x10,%rsp
}
  801758:	c9                   	leaveq 
  801759:	c3                   	retq   

000000000080175a <sys_yield>:

void
sys_yield(void)
{
  80175a:	55                   	push   %rbp
  80175b:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80175e:	48 83 ec 08          	sub    $0x8,%rsp
  801762:	6a 00                	pushq  $0x0
  801764:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80176a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801770:	b9 00 00 00 00       	mov    $0x0,%ecx
  801775:	ba 00 00 00 00       	mov    $0x0,%edx
  80177a:	be 00 00 00 00       	mov    $0x0,%esi
  80177f:	bf 0a 00 00 00       	mov    $0xa,%edi
  801784:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  80178b:	00 00 00 
  80178e:	ff d0                	callq  *%rax
  801790:	48 83 c4 10          	add    $0x10,%rsp
}
  801794:	90                   	nop
  801795:	c9                   	leaveq 
  801796:	c3                   	retq   

0000000000801797 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801797:	55                   	push   %rbp
  801798:	48 89 e5             	mov    %rsp,%rbp
  80179b:	48 83 ec 10          	sub    $0x10,%rsp
  80179f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017a6:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017ac:	48 63 c8             	movslq %eax,%rcx
  8017af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017b6:	48 98                	cltq   
  8017b8:	48 83 ec 08          	sub    $0x8,%rsp
  8017bc:	6a 00                	pushq  $0x0
  8017be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017c4:	49 89 c8             	mov    %rcx,%r8
  8017c7:	48 89 d1             	mov    %rdx,%rcx
  8017ca:	48 89 c2             	mov    %rax,%rdx
  8017cd:	be 01 00 00 00       	mov    $0x1,%esi
  8017d2:	bf 04 00 00 00       	mov    $0x4,%edi
  8017d7:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  8017de:	00 00 00 
  8017e1:	ff d0                	callq  *%rax
  8017e3:	48 83 c4 10          	add    $0x10,%rsp
}
  8017e7:	c9                   	leaveq 
  8017e8:	c3                   	retq   

00000000008017e9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017e9:	55                   	push   %rbp
  8017ea:	48 89 e5             	mov    %rsp,%rbp
  8017ed:	48 83 ec 20          	sub    $0x20,%rsp
  8017f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017f8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017fb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017ff:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801803:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801806:	48 63 c8             	movslq %eax,%rcx
  801809:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80180d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801810:	48 63 f0             	movslq %eax,%rsi
  801813:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801817:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80181a:	48 98                	cltq   
  80181c:	48 83 ec 08          	sub    $0x8,%rsp
  801820:	51                   	push   %rcx
  801821:	49 89 f9             	mov    %rdi,%r9
  801824:	49 89 f0             	mov    %rsi,%r8
  801827:	48 89 d1             	mov    %rdx,%rcx
  80182a:	48 89 c2             	mov    %rax,%rdx
  80182d:	be 01 00 00 00       	mov    $0x1,%esi
  801832:	bf 05 00 00 00       	mov    $0x5,%edi
  801837:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  80183e:	00 00 00 
  801841:	ff d0                	callq  *%rax
  801843:	48 83 c4 10          	add    $0x10,%rsp
}
  801847:	c9                   	leaveq 
  801848:	c3                   	retq   

0000000000801849 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801849:	55                   	push   %rbp
  80184a:	48 89 e5             	mov    %rsp,%rbp
  80184d:	48 83 ec 10          	sub    $0x10,%rsp
  801851:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801854:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801858:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80185c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80185f:	48 98                	cltq   
  801861:	48 83 ec 08          	sub    $0x8,%rsp
  801865:	6a 00                	pushq  $0x0
  801867:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80186d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801873:	48 89 d1             	mov    %rdx,%rcx
  801876:	48 89 c2             	mov    %rax,%rdx
  801879:	be 01 00 00 00       	mov    $0x1,%esi
  80187e:	bf 06 00 00 00       	mov    $0x6,%edi
  801883:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  80188a:	00 00 00 
  80188d:	ff d0                	callq  *%rax
  80188f:	48 83 c4 10          	add    $0x10,%rsp
}
  801893:	c9                   	leaveq 
  801894:	c3                   	retq   

0000000000801895 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801895:	55                   	push   %rbp
  801896:	48 89 e5             	mov    %rsp,%rbp
  801899:	48 83 ec 10          	sub    $0x10,%rsp
  80189d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018a0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018a6:	48 63 d0             	movslq %eax,%rdx
  8018a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ac:	48 98                	cltq   
  8018ae:	48 83 ec 08          	sub    $0x8,%rsp
  8018b2:	6a 00                	pushq  $0x0
  8018b4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c0:	48 89 d1             	mov    %rdx,%rcx
  8018c3:	48 89 c2             	mov    %rax,%rdx
  8018c6:	be 01 00 00 00       	mov    $0x1,%esi
  8018cb:	bf 08 00 00 00       	mov    $0x8,%edi
  8018d0:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  8018d7:	00 00 00 
  8018da:	ff d0                	callq  *%rax
  8018dc:	48 83 c4 10          	add    $0x10,%rsp
}
  8018e0:	c9                   	leaveq 
  8018e1:	c3                   	retq   

00000000008018e2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018e2:	55                   	push   %rbp
  8018e3:	48 89 e5             	mov    %rsp,%rbp
  8018e6:	48 83 ec 10          	sub    $0x10,%rsp
  8018ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8018f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f8:	48 98                	cltq   
  8018fa:	48 83 ec 08          	sub    $0x8,%rsp
  8018fe:	6a 00                	pushq  $0x0
  801900:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801906:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190c:	48 89 d1             	mov    %rdx,%rcx
  80190f:	48 89 c2             	mov    %rax,%rdx
  801912:	be 01 00 00 00       	mov    $0x1,%esi
  801917:	bf 09 00 00 00       	mov    $0x9,%edi
  80191c:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  801923:	00 00 00 
  801926:	ff d0                	callq  *%rax
  801928:	48 83 c4 10          	add    $0x10,%rsp
}
  80192c:	c9                   	leaveq 
  80192d:	c3                   	retq   

000000000080192e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80192e:	55                   	push   %rbp
  80192f:	48 89 e5             	mov    %rsp,%rbp
  801932:	48 83 ec 20          	sub    $0x20,%rsp
  801936:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801939:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80193d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801941:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801944:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801947:	48 63 f0             	movslq %eax,%rsi
  80194a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80194e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801951:	48 98                	cltq   
  801953:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801957:	48 83 ec 08          	sub    $0x8,%rsp
  80195b:	6a 00                	pushq  $0x0
  80195d:	49 89 f1             	mov    %rsi,%r9
  801960:	49 89 c8             	mov    %rcx,%r8
  801963:	48 89 d1             	mov    %rdx,%rcx
  801966:	48 89 c2             	mov    %rax,%rdx
  801969:	be 00 00 00 00       	mov    $0x0,%esi
  80196e:	bf 0b 00 00 00       	mov    $0xb,%edi
  801973:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  80197a:	00 00 00 
  80197d:	ff d0                	callq  *%rax
  80197f:	48 83 c4 10          	add    $0x10,%rsp
}
  801983:	c9                   	leaveq 
  801984:	c3                   	retq   

0000000000801985 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801985:	55                   	push   %rbp
  801986:	48 89 e5             	mov    %rsp,%rbp
  801989:	48 83 ec 10          	sub    $0x10,%rsp
  80198d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801991:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801995:	48 83 ec 08          	sub    $0x8,%rsp
  801999:	6a 00                	pushq  $0x0
  80199b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ac:	48 89 c2             	mov    %rax,%rdx
  8019af:	be 01 00 00 00       	mov    $0x1,%esi
  8019b4:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019b9:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  8019c0:	00 00 00 
  8019c3:	ff d0                	callq  *%rax
  8019c5:	48 83 c4 10          	add    $0x10,%rsp
}
  8019c9:	c9                   	leaveq 
  8019ca:	c3                   	retq   

00000000008019cb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8019cb:	55                   	push   %rbp
  8019cc:	48 89 e5             	mov    %rsp,%rbp
  8019cf:	53                   	push   %rbx
  8019d0:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8019d7:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8019de:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8019e4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8019eb:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8019f2:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8019f9:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801a00:	84 c0                	test   %al,%al
  801a02:	74 23                	je     801a27 <_panic+0x5c>
  801a04:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801a0b:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801a0f:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801a13:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801a17:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801a1b:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801a1f:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801a23:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801a27:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801a2e:	00 00 00 
  801a31:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801a38:	00 00 00 
  801a3b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801a3f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801a46:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801a4d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801a54:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  801a5b:	00 00 00 
  801a5e:	48 8b 18             	mov    (%rax),%rbx
  801a61:	48 b8 1e 17 80 00 00 	movabs $0x80171e,%rax
  801a68:	00 00 00 
  801a6b:	ff d0                	callq  *%rax
  801a6d:	89 c6                	mov    %eax,%esi
  801a6f:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  801a75:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  801a7c:	41 89 d0             	mov    %edx,%r8d
  801a7f:	48 89 c1             	mov    %rax,%rcx
  801a82:	48 89 da             	mov    %rbx,%rdx
  801a85:	48 bf b8 1f 80 00 00 	movabs $0x801fb8,%rdi
  801a8c:	00 00 00 
  801a8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a94:	49 b9 d1 02 80 00 00 	movabs $0x8002d1,%r9
  801a9b:	00 00 00 
  801a9e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801aa1:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801aa8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801aaf:	48 89 d6             	mov    %rdx,%rsi
  801ab2:	48 89 c7             	mov    %rax,%rdi
  801ab5:	48 b8 25 02 80 00 00 	movabs $0x800225,%rax
  801abc:	00 00 00 
  801abf:	ff d0                	callq  *%rax
	cprintf("\n");
  801ac1:	48 bf db 1f 80 00 00 	movabs $0x801fdb,%rdi
  801ac8:	00 00 00 
  801acb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad0:	48 ba d1 02 80 00 00 	movabs $0x8002d1,%rdx
  801ad7:	00 00 00 
  801ada:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801adc:	cc                   	int3   
  801add:	eb fd                	jmp    801adc <_panic+0x111>
