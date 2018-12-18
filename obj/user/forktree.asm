
obj/user/forktree:     file format elf64-x86-64


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
  80003c:	e8 2e 01 00 00       	callq  80016f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 f0                	mov    %esi,%eax
  800051:	88 45 e4             	mov    %al,-0x1c(%rbp)
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800058:	48 89 c7             	mov    %rax,%rdi
  80005b:	48 b8 5d 0e 80 00 00 	movabs $0x800e5d,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
  800067:	83 f8 02             	cmp    $0x2,%eax
  80006a:	7f 67                	jg     8000d3 <forkchild+0x90>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80006c:	0f be 4d e4          	movsbl -0x1c(%rbp),%ecx
  800070:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800074:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800078:	41 89 c8             	mov    %ecx,%r8d
  80007b:	48 89 d1             	mov    %rdx,%rcx
  80007e:	48 ba 80 23 80 00 00 	movabs $0x802380,%rdx
  800085:	00 00 00 
  800088:	be 04 00 00 00       	mov    $0x4,%esi
  80008d:	48 89 c7             	mov    %rax,%rdi
  800090:	b8 00 00 00 00       	mov    $0x0,%eax
  800095:	49 b9 7c 0d 80 00 00 	movabs $0x800d7c,%r9
  80009c:	00 00 00 
  80009f:	41 ff d1             	callq  *%r9
	if (fork() == 0) {
  8000a2:	48 b8 23 1d 80 00 00 	movabs $0x801d23,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 22                	jne    8000d4 <forkchild+0x91>
		forktree(nxt);
  8000b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000b6:	48 89 c7             	mov    %rax,%rdi
  8000b9:	48 b8 d6 00 80 00 00 	movabs $0x8000d6,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
		exit();
  8000c5:	48 b8 fb 01 80 00 00 	movabs $0x8001fb,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	callq  *%rax
  8000d1:	eb 01                	jmp    8000d4 <forkchild+0x91>
forkchild(const char *cur, char branch)
{
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
		return;
  8000d3:	90                   	nop
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
	if (fork() == 0) {
		forktree(nxt);
		exit();
	}
}
  8000d4:	c9                   	leaveq 
  8000d5:	c3                   	retq   

00000000008000d6 <forktree>:

void
forktree(const char *cur)
{
  8000d6:	55                   	push   %rbp
  8000d7:	48 89 e5             	mov    %rsp,%rbp
  8000da:	48 83 ec 10          	sub    $0x10,%rsp
  8000de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  8000e2:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	callq  *%rax
  8000ee:	89 c1                	mov    %eax,%ecx
  8000f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f4:	48 89 c2             	mov    %rax,%rdx
  8000f7:	89 ce                	mov    %ecx,%esi
  8000f9:	48 bf 85 23 80 00 00 	movabs $0x802385,%rdi
  800100:	00 00 00 
  800103:	b8 00 00 00 00       	mov    $0x0,%eax
  800108:	48 b9 39 03 80 00 00 	movabs $0x800339,%rcx
  80010f:	00 00 00 
  800112:	ff d1                	callq  *%rcx

	forkchild(cur, '0');
  800114:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800118:	be 30 00 00 00       	mov    $0x30,%esi
  80011d:	48 89 c7             	mov    %rax,%rdi
  800120:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800127:	00 00 00 
  80012a:	ff d0                	callq  *%rax
	forkchild(cur, '1');
  80012c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800130:	be 31 00 00 00       	mov    $0x31,%esi
  800135:	48 89 c7             	mov    %rax,%rdi
  800138:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80013f:	00 00 00 
  800142:	ff d0                	callq  *%rax
}
  800144:	90                   	nop
  800145:	c9                   	leaveq 
  800146:	c3                   	retq   

0000000000800147 <umain>:

void
umain(int argc, char **argv)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800152:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	forktree("");
  800156:	48 bf 96 23 80 00 00 	movabs $0x802396,%rdi
  80015d:	00 00 00 
  800160:	48 b8 d6 00 80 00 00 	movabs $0x8000d6,%rax
  800167:	00 00 00 
  80016a:	ff d0                	callq  *%rax
}
  80016c:	90                   	nop
  80016d:	c9                   	leaveq 
  80016e:	c3                   	retq   

000000000080016f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80016f:	55                   	push   %rbp
  800170:	48 89 e5             	mov    %rsp,%rbp
  800173:	48 83 ec 10          	sub    $0x10,%rsp
  800177:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80017a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  80017e:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  800185:	00 00 00 
  800188:	ff d0                	callq  *%rax
  80018a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80018f:	48 63 d0             	movslq %eax,%rdx
  800192:	48 89 d0             	mov    %rdx,%rax
  800195:	48 c1 e0 03          	shl    $0x3,%rax
  800199:	48 01 d0             	add    %rdx,%rax
  80019c:	48 c1 e0 05          	shl    $0x5,%rax
  8001a0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001a7:	00 00 00 
  8001aa:	48 01 c2             	add    %rax,%rdx
  8001ad:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8001b4:	00 00 00 
  8001b7:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001be:	7e 14                	jle    8001d4 <libmain+0x65>
		binaryname = argv[0];
  8001c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c4:	48 8b 10             	mov    (%rax),%rdx
  8001c7:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8001ce:	00 00 00 
  8001d1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001db:	48 89 d6             	mov    %rdx,%rsi
  8001de:	89 c7                	mov    %eax,%edi
  8001e0:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  8001e7:	00 00 00 
  8001ea:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001ec:	48 b8 fb 01 80 00 00 	movabs $0x8001fb,%rax
  8001f3:	00 00 00 
  8001f6:	ff d0                	callq  *%rax
}
  8001f8:	90                   	nop
  8001f9:	c9                   	leaveq 
  8001fa:	c3                   	retq   

00000000008001fb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001fb:	55                   	push   %rbp
  8001fc:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8001ff:	bf 00 00 00 00       	mov    $0x0,%edi
  800204:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  80020b:	00 00 00 
  80020e:	ff d0                	callq  *%rax
}
  800210:	90                   	nop
  800211:	5d                   	pop    %rbp
  800212:	c3                   	retq   

0000000000800213 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800213:	55                   	push   %rbp
  800214:	48 89 e5             	mov    %rsp,%rbp
  800217:	48 83 ec 10          	sub    $0x10,%rsp
  80021b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80021e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800226:	8b 00                	mov    (%rax),%eax
  800228:	8d 48 01             	lea    0x1(%rax),%ecx
  80022b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80022f:	89 0a                	mov    %ecx,(%rdx)
  800231:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800234:	89 d1                	mov    %edx,%ecx
  800236:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80023a:	48 98                	cltq   
  80023c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800240:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800244:	8b 00                	mov    (%rax),%eax
  800246:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024b:	75 2c                	jne    800279 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80024d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800251:	8b 00                	mov    (%rax),%eax
  800253:	48 98                	cltq   
  800255:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800259:	48 83 c2 08          	add    $0x8,%rdx
  80025d:	48 89 c6             	mov    %rax,%rsi
  800260:	48 89 d7             	mov    %rdx,%rdi
  800263:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  80026a:	00 00 00 
  80026d:	ff d0                	callq  *%rax
        b->idx = 0;
  80026f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800273:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800279:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80027d:	8b 40 04             	mov    0x4(%rax),%eax
  800280:	8d 50 01             	lea    0x1(%rax),%edx
  800283:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800287:	89 50 04             	mov    %edx,0x4(%rax)
}
  80028a:	90                   	nop
  80028b:	c9                   	leaveq 
  80028c:	c3                   	retq   

000000000080028d <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80028d:	55                   	push   %rbp
  80028e:	48 89 e5             	mov    %rsp,%rbp
  800291:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800298:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80029f:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8002a6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002ad:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002b4:	48 8b 0a             	mov    (%rdx),%rcx
  8002b7:	48 89 08             	mov    %rcx,(%rax)
  8002ba:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002be:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002c2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002c6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002ca:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002d1:	00 00 00 
    b.cnt = 0;
  8002d4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002db:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002de:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002e5:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002ec:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002f3:	48 89 c6             	mov    %rax,%rsi
  8002f6:	48 bf 13 02 80 00 00 	movabs $0x800213,%rdi
  8002fd:	00 00 00 
  800300:	48 b8 d7 06 80 00 00 	movabs $0x8006d7,%rax
  800307:	00 00 00 
  80030a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80030c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800312:	48 98                	cltq   
  800314:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80031b:	48 83 c2 08          	add    $0x8,%rdx
  80031f:	48 89 c6             	mov    %rax,%rsi
  800322:	48 89 d7             	mov    %rdx,%rdi
  800325:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  80032c:	00 00 00 
  80032f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800331:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800337:	c9                   	leaveq 
  800338:	c3                   	retq   

0000000000800339 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800339:	55                   	push   %rbp
  80033a:	48 89 e5             	mov    %rsp,%rbp
  80033d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800344:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80034b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800352:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800359:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800360:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800367:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80036e:	84 c0                	test   %al,%al
  800370:	74 20                	je     800392 <cprintf+0x59>
  800372:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800376:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80037a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80037e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800382:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800386:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80038a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80038e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800392:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800399:	00 00 00 
  80039c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003a3:	00 00 00 
  8003a6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003aa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8003b1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003b8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003bf:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003c6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003cd:	48 8b 0a             	mov    (%rdx),%rcx
  8003d0:	48 89 08             	mov    %rcx,(%rax)
  8003d3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003d7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003db:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003df:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003e3:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003ea:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003f1:	48 89 d6             	mov    %rdx,%rsi
  8003f4:	48 89 c7             	mov    %rax,%rdi
  8003f7:	48 b8 8d 02 80 00 00 	movabs $0x80028d,%rax
  8003fe:	00 00 00 
  800401:	ff d0                	callq  *%rax
  800403:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800409:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80040f:	c9                   	leaveq 
  800410:	c3                   	retq   

0000000000800411 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800411:	55                   	push   %rbp
  800412:	48 89 e5             	mov    %rsp,%rbp
  800415:	48 83 ec 30          	sub    $0x30,%rsp
  800419:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80041d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800421:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800425:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800428:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80042c:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800430:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800433:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800437:	77 54                	ja     80048d <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800439:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80043c:	8d 78 ff             	lea    -0x1(%rax),%edi
  80043f:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800442:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800446:	ba 00 00 00 00       	mov    $0x0,%edx
  80044b:	48 f7 f6             	div    %rsi
  80044e:	49 89 c2             	mov    %rax,%r10
  800451:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800454:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800457:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80045b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80045f:	41 89 c9             	mov    %ecx,%r9d
  800462:	41 89 f8             	mov    %edi,%r8d
  800465:	89 d1                	mov    %edx,%ecx
  800467:	4c 89 d2             	mov    %r10,%rdx
  80046a:	48 89 c7             	mov    %rax,%rdi
  80046d:	48 b8 11 04 80 00 00 	movabs $0x800411,%rax
  800474:	00 00 00 
  800477:	ff d0                	callq  *%rax
  800479:	eb 1c                	jmp    800497 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80047b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80047f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800482:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800486:	48 89 ce             	mov    %rcx,%rsi
  800489:	89 d7                	mov    %edx,%edi
  80048b:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80048d:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800491:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800495:	7f e4                	jg     80047b <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800497:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80049a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049e:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a3:	48 f7 f1             	div    %rcx
  8004a6:	48 b8 10 25 80 00 00 	movabs $0x802510,%rax
  8004ad:	00 00 00 
  8004b0:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8004b4:	0f be d0             	movsbl %al,%edx
  8004b7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8004bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004bf:	48 89 ce             	mov    %rcx,%rsi
  8004c2:	89 d7                	mov    %edx,%edi
  8004c4:	ff d0                	callq  *%rax
}
  8004c6:	90                   	nop
  8004c7:	c9                   	leaveq 
  8004c8:	c3                   	retq   

00000000008004c9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004c9:	55                   	push   %rbp
  8004ca:	48 89 e5             	mov    %rsp,%rbp
  8004cd:	48 83 ec 20          	sub    $0x20,%rsp
  8004d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004d5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004d8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004dc:	7e 4f                	jle    80052d <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8004de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e2:	8b 00                	mov    (%rax),%eax
  8004e4:	83 f8 30             	cmp    $0x30,%eax
  8004e7:	73 24                	jae    80050d <getuint+0x44>
  8004e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ed:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f5:	8b 00                	mov    (%rax),%eax
  8004f7:	89 c0                	mov    %eax,%eax
  8004f9:	48 01 d0             	add    %rdx,%rax
  8004fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800500:	8b 12                	mov    (%rdx),%edx
  800502:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800505:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800509:	89 0a                	mov    %ecx,(%rdx)
  80050b:	eb 14                	jmp    800521 <getuint+0x58>
  80050d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800511:	48 8b 40 08          	mov    0x8(%rax),%rax
  800515:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800519:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800521:	48 8b 00             	mov    (%rax),%rax
  800524:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800528:	e9 9d 00 00 00       	jmpq   8005ca <getuint+0x101>
	else if (lflag)
  80052d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800531:	74 4c                	je     80057f <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800537:	8b 00                	mov    (%rax),%eax
  800539:	83 f8 30             	cmp    $0x30,%eax
  80053c:	73 24                	jae    800562 <getuint+0x99>
  80053e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800542:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800546:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054a:	8b 00                	mov    (%rax),%eax
  80054c:	89 c0                	mov    %eax,%eax
  80054e:	48 01 d0             	add    %rdx,%rax
  800551:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800555:	8b 12                	mov    (%rdx),%edx
  800557:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80055a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055e:	89 0a                	mov    %ecx,(%rdx)
  800560:	eb 14                	jmp    800576 <getuint+0xad>
  800562:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800566:	48 8b 40 08          	mov    0x8(%rax),%rax
  80056a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80056e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800572:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800576:	48 8b 00             	mov    (%rax),%rax
  800579:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80057d:	eb 4b                	jmp    8005ca <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  80057f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800583:	8b 00                	mov    (%rax),%eax
  800585:	83 f8 30             	cmp    $0x30,%eax
  800588:	73 24                	jae    8005ae <getuint+0xe5>
  80058a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800596:	8b 00                	mov    (%rax),%eax
  800598:	89 c0                	mov    %eax,%eax
  80059a:	48 01 d0             	add    %rdx,%rax
  80059d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a1:	8b 12                	mov    (%rdx),%edx
  8005a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005aa:	89 0a                	mov    %ecx,(%rdx)
  8005ac:	eb 14                	jmp    8005c2 <getuint+0xf9>
  8005ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005b6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005be:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c2:	8b 00                	mov    (%rax),%eax
  8005c4:	89 c0                	mov    %eax,%eax
  8005c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005ce:	c9                   	leaveq 
  8005cf:	c3                   	retq   

00000000008005d0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d0:	55                   	push   %rbp
  8005d1:	48 89 e5             	mov    %rsp,%rbp
  8005d4:	48 83 ec 20          	sub    $0x20,%rsp
  8005d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005dc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005df:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005e3:	7e 4f                	jle    800634 <getint+0x64>
		x=va_arg(*ap, long long);
  8005e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e9:	8b 00                	mov    (%rax),%eax
  8005eb:	83 f8 30             	cmp    $0x30,%eax
  8005ee:	73 24                	jae    800614 <getint+0x44>
  8005f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fc:	8b 00                	mov    (%rax),%eax
  8005fe:	89 c0                	mov    %eax,%eax
  800600:	48 01 d0             	add    %rdx,%rax
  800603:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800607:	8b 12                	mov    (%rdx),%edx
  800609:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80060c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800610:	89 0a                	mov    %ecx,(%rdx)
  800612:	eb 14                	jmp    800628 <getint+0x58>
  800614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800618:	48 8b 40 08          	mov    0x8(%rax),%rax
  80061c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800620:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800624:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800628:	48 8b 00             	mov    (%rax),%rax
  80062b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80062f:	e9 9d 00 00 00       	jmpq   8006d1 <getint+0x101>
	else if (lflag)
  800634:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800638:	74 4c                	je     800686 <getint+0xb6>
		x=va_arg(*ap, long);
  80063a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063e:	8b 00                	mov    (%rax),%eax
  800640:	83 f8 30             	cmp    $0x30,%eax
  800643:	73 24                	jae    800669 <getint+0x99>
  800645:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800649:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80064d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800651:	8b 00                	mov    (%rax),%eax
  800653:	89 c0                	mov    %eax,%eax
  800655:	48 01 d0             	add    %rdx,%rax
  800658:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065c:	8b 12                	mov    (%rdx),%edx
  80065e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800661:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800665:	89 0a                	mov    %ecx,(%rdx)
  800667:	eb 14                	jmp    80067d <getint+0xad>
  800669:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800671:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800675:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800679:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80067d:	48 8b 00             	mov    (%rax),%rax
  800680:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800684:	eb 4b                	jmp    8006d1 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800686:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068a:	8b 00                	mov    (%rax),%eax
  80068c:	83 f8 30             	cmp    $0x30,%eax
  80068f:	73 24                	jae    8006b5 <getint+0xe5>
  800691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800695:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800699:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069d:	8b 00                	mov    (%rax),%eax
  80069f:	89 c0                	mov    %eax,%eax
  8006a1:	48 01 d0             	add    %rdx,%rax
  8006a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a8:	8b 12                	mov    (%rdx),%edx
  8006aa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b1:	89 0a                	mov    %ecx,(%rdx)
  8006b3:	eb 14                	jmp    8006c9 <getint+0xf9>
  8006b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006bd:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c9:	8b 00                	mov    (%rax),%eax
  8006cb:	48 98                	cltq   
  8006cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006d5:	c9                   	leaveq 
  8006d6:	c3                   	retq   

00000000008006d7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006d7:	55                   	push   %rbp
  8006d8:	48 89 e5             	mov    %rsp,%rbp
  8006db:	41 54                	push   %r12
  8006dd:	53                   	push   %rbx
  8006de:	48 83 ec 60          	sub    $0x60,%rsp
  8006e2:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006e6:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006ea:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006ee:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006f2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006f6:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006fa:	48 8b 0a             	mov    (%rdx),%rcx
  8006fd:	48 89 08             	mov    %rcx,(%rax)
  800700:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800704:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800708:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80070c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800710:	eb 17                	jmp    800729 <vprintfmt+0x52>
			if (ch == '\0')
  800712:	85 db                	test   %ebx,%ebx
  800714:	0f 84 b9 04 00 00    	je     800bd3 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80071a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80071e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800722:	48 89 d6             	mov    %rdx,%rsi
  800725:	89 df                	mov    %ebx,%edi
  800727:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800729:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80072d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800731:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800735:	0f b6 00             	movzbl (%rax),%eax
  800738:	0f b6 d8             	movzbl %al,%ebx
  80073b:	83 fb 25             	cmp    $0x25,%ebx
  80073e:	75 d2                	jne    800712 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800740:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800744:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80074b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800752:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800759:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800760:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800764:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800768:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80076c:	0f b6 00             	movzbl (%rax),%eax
  80076f:	0f b6 d8             	movzbl %al,%ebx
  800772:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800775:	83 f8 55             	cmp    $0x55,%eax
  800778:	0f 87 22 04 00 00    	ja     800ba0 <vprintfmt+0x4c9>
  80077e:	89 c0                	mov    %eax,%eax
  800780:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800787:	00 
  800788:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  80078f:	00 00 00 
  800792:	48 01 d0             	add    %rdx,%rax
  800795:	48 8b 00             	mov    (%rax),%rax
  800798:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80079a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80079e:	eb c0                	jmp    800760 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007a0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007a4:	eb ba                	jmp    800760 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007ad:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007b0:	89 d0                	mov    %edx,%eax
  8007b2:	c1 e0 02             	shl    $0x2,%eax
  8007b5:	01 d0                	add    %edx,%eax
  8007b7:	01 c0                	add    %eax,%eax
  8007b9:	01 d8                	add    %ebx,%eax
  8007bb:	83 e8 30             	sub    $0x30,%eax
  8007be:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007c1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007c5:	0f b6 00             	movzbl (%rax),%eax
  8007c8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007cb:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ce:	7e 60                	jle    800830 <vprintfmt+0x159>
  8007d0:	83 fb 39             	cmp    $0x39,%ebx
  8007d3:	7f 5b                	jg     800830 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007da:	eb d1                	jmp    8007ad <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8007dc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007df:	83 f8 30             	cmp    $0x30,%eax
  8007e2:	73 17                	jae    8007fb <vprintfmt+0x124>
  8007e4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8007e8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007eb:	89 d2                	mov    %edx,%edx
  8007ed:	48 01 d0             	add    %rdx,%rax
  8007f0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007f3:	83 c2 08             	add    $0x8,%edx
  8007f6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007f9:	eb 0c                	jmp    800807 <vprintfmt+0x130>
  8007fb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8007ff:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800803:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800807:	8b 00                	mov    (%rax),%eax
  800809:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80080c:	eb 23                	jmp    800831 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  80080e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800812:	0f 89 48 ff ff ff    	jns    800760 <vprintfmt+0x89>
				width = 0;
  800818:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80081f:	e9 3c ff ff ff       	jmpq   800760 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800824:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80082b:	e9 30 ff ff ff       	jmpq   800760 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800830:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800831:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800835:	0f 89 25 ff ff ff    	jns    800760 <vprintfmt+0x89>
				width = precision, precision = -1;
  80083b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80083e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800841:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800848:	e9 13 ff ff ff       	jmpq   800760 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800851:	e9 0a ff ff ff       	jmpq   800760 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800856:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800859:	83 f8 30             	cmp    $0x30,%eax
  80085c:	73 17                	jae    800875 <vprintfmt+0x19e>
  80085e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800862:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800865:	89 d2                	mov    %edx,%edx
  800867:	48 01 d0             	add    %rdx,%rax
  80086a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80086d:	83 c2 08             	add    $0x8,%edx
  800870:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800873:	eb 0c                	jmp    800881 <vprintfmt+0x1aa>
  800875:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800879:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80087d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800881:	8b 10                	mov    (%rax),%edx
  800883:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800887:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80088b:	48 89 ce             	mov    %rcx,%rsi
  80088e:	89 d7                	mov    %edx,%edi
  800890:	ff d0                	callq  *%rax
			break;
  800892:	e9 37 03 00 00       	jmpq   800bce <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800897:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089a:	83 f8 30             	cmp    $0x30,%eax
  80089d:	73 17                	jae    8008b6 <vprintfmt+0x1df>
  80089f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8008a3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008a6:	89 d2                	mov    %edx,%edx
  8008a8:	48 01 d0             	add    %rdx,%rax
  8008ab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008ae:	83 c2 08             	add    $0x8,%edx
  8008b1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b4:	eb 0c                	jmp    8008c2 <vprintfmt+0x1eb>
  8008b6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8008ba:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8008be:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008c2:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008c4:	85 db                	test   %ebx,%ebx
  8008c6:	79 02                	jns    8008ca <vprintfmt+0x1f3>
				err = -err;
  8008c8:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008ca:	83 fb 15             	cmp    $0x15,%ebx
  8008cd:	7f 16                	jg     8008e5 <vprintfmt+0x20e>
  8008cf:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  8008d6:	00 00 00 
  8008d9:	48 63 d3             	movslq %ebx,%rdx
  8008dc:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008e0:	4d 85 e4             	test   %r12,%r12
  8008e3:	75 2e                	jne    800913 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  8008e5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008e9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ed:	89 d9                	mov    %ebx,%ecx
  8008ef:	48 ba 21 25 80 00 00 	movabs $0x802521,%rdx
  8008f6:	00 00 00 
  8008f9:	48 89 c7             	mov    %rax,%rdi
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800901:	49 b8 dd 0b 80 00 00 	movabs $0x800bdd,%r8
  800908:	00 00 00 
  80090b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80090e:	e9 bb 02 00 00       	jmpq   800bce <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800913:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800917:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80091b:	4c 89 e1             	mov    %r12,%rcx
  80091e:	48 ba 2a 25 80 00 00 	movabs $0x80252a,%rdx
  800925:	00 00 00 
  800928:	48 89 c7             	mov    %rax,%rdi
  80092b:	b8 00 00 00 00       	mov    $0x0,%eax
  800930:	49 b8 dd 0b 80 00 00 	movabs $0x800bdd,%r8
  800937:	00 00 00 
  80093a:	41 ff d0             	callq  *%r8
			break;
  80093d:	e9 8c 02 00 00       	jmpq   800bce <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800942:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800945:	83 f8 30             	cmp    $0x30,%eax
  800948:	73 17                	jae    800961 <vprintfmt+0x28a>
  80094a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80094e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800951:	89 d2                	mov    %edx,%edx
  800953:	48 01 d0             	add    %rdx,%rax
  800956:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800959:	83 c2 08             	add    $0x8,%edx
  80095c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80095f:	eb 0c                	jmp    80096d <vprintfmt+0x296>
  800961:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800965:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800969:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80096d:	4c 8b 20             	mov    (%rax),%r12
  800970:	4d 85 e4             	test   %r12,%r12
  800973:	75 0a                	jne    80097f <vprintfmt+0x2a8>
				p = "(null)";
  800975:	49 bc 2d 25 80 00 00 	movabs $0x80252d,%r12
  80097c:	00 00 00 
			if (width > 0 && padc != '-')
  80097f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800983:	7e 78                	jle    8009fd <vprintfmt+0x326>
  800985:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800989:	74 72                	je     8009fd <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  80098b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80098e:	48 98                	cltq   
  800990:	48 89 c6             	mov    %rax,%rsi
  800993:	4c 89 e7             	mov    %r12,%rdi
  800996:	48 b8 8b 0e 80 00 00 	movabs $0x800e8b,%rax
  80099d:	00 00 00 
  8009a0:	ff d0                	callq  *%rax
  8009a2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009a5:	eb 17                	jmp    8009be <vprintfmt+0x2e7>
					putch(padc, putdat);
  8009a7:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009ab:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b3:	48 89 ce             	mov    %rcx,%rsi
  8009b6:	89 d7                	mov    %edx,%edi
  8009b8:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ba:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009be:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c2:	7f e3                	jg     8009a7 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c4:	eb 37                	jmp    8009fd <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  8009c6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009ca:	74 1e                	je     8009ea <vprintfmt+0x313>
  8009cc:	83 fb 1f             	cmp    $0x1f,%ebx
  8009cf:	7e 05                	jle    8009d6 <vprintfmt+0x2ff>
  8009d1:	83 fb 7e             	cmp    $0x7e,%ebx
  8009d4:	7e 14                	jle    8009ea <vprintfmt+0x313>
					putch('?', putdat);
  8009d6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009da:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009de:	48 89 d6             	mov    %rdx,%rsi
  8009e1:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009e6:	ff d0                	callq  *%rax
  8009e8:	eb 0f                	jmp    8009f9 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  8009ea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f2:	48 89 d6             	mov    %rdx,%rsi
  8009f5:	89 df                	mov    %ebx,%edi
  8009f7:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009fd:	4c 89 e0             	mov    %r12,%rax
  800a00:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a04:	0f b6 00             	movzbl (%rax),%eax
  800a07:	0f be d8             	movsbl %al,%ebx
  800a0a:	85 db                	test   %ebx,%ebx
  800a0c:	74 28                	je     800a36 <vprintfmt+0x35f>
  800a0e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a12:	78 b2                	js     8009c6 <vprintfmt+0x2ef>
  800a14:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a18:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a1c:	79 a8                	jns    8009c6 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a1e:	eb 16                	jmp    800a36 <vprintfmt+0x35f>
				putch(' ', putdat);
  800a20:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a28:	48 89 d6             	mov    %rdx,%rsi
  800a2b:	bf 20 00 00 00       	mov    $0x20,%edi
  800a30:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a32:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a36:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3a:	7f e4                	jg     800a20 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800a3c:	e9 8d 01 00 00       	jmpq   800bce <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a41:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a45:	be 03 00 00 00       	mov    $0x3,%esi
  800a4a:	48 89 c7             	mov    %rax,%rdi
  800a4d:	48 b8 d0 05 80 00 00 	movabs $0x8005d0,%rax
  800a54:	00 00 00 
  800a57:	ff d0                	callq  *%rax
  800a59:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a61:	48 85 c0             	test   %rax,%rax
  800a64:	79 1d                	jns    800a83 <vprintfmt+0x3ac>
				putch('-', putdat);
  800a66:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6e:	48 89 d6             	mov    %rdx,%rsi
  800a71:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a76:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7c:	48 f7 d8             	neg    %rax
  800a7f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a83:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a8a:	e9 d2 00 00 00       	jmpq   800b61 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a8f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a93:	be 03 00 00 00       	mov    $0x3,%esi
  800a98:	48 89 c7             	mov    %rax,%rdi
  800a9b:	48 b8 c9 04 80 00 00 	movabs $0x8004c9,%rax
  800aa2:	00 00 00 
  800aa5:	ff d0                	callq  *%rax
  800aa7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800aab:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ab2:	e9 aa 00 00 00       	jmpq   800b61 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800ab7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800abb:	be 03 00 00 00       	mov    $0x3,%esi
  800ac0:	48 89 c7             	mov    %rax,%rdi
  800ac3:	48 b8 c9 04 80 00 00 	movabs $0x8004c9,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	callq  *%rax
  800acf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ad3:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ada:	e9 82 00 00 00       	jmpq   800b61 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800adf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae7:	48 89 d6             	mov    %rdx,%rsi
  800aea:	bf 30 00 00 00       	mov    $0x30,%edi
  800aef:	ff d0                	callq  *%rax
			putch('x', putdat);
  800af1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af9:	48 89 d6             	mov    %rdx,%rsi
  800afc:	bf 78 00 00 00       	mov    $0x78,%edi
  800b01:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b06:	83 f8 30             	cmp    $0x30,%eax
  800b09:	73 17                	jae    800b22 <vprintfmt+0x44b>
  800b0b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b0f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b12:	89 d2                	mov    %edx,%edx
  800b14:	48 01 d0             	add    %rdx,%rax
  800b17:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b1a:	83 c2 08             	add    $0x8,%edx
  800b1d:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b20:	eb 0c                	jmp    800b2e <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800b22:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b26:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b2a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b2e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b35:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b3c:	eb 23                	jmp    800b61 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b3e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b42:	be 03 00 00 00       	mov    $0x3,%esi
  800b47:	48 89 c7             	mov    %rax,%rdi
  800b4a:	48 b8 c9 04 80 00 00 	movabs $0x8004c9,%rax
  800b51:	00 00 00 
  800b54:	ff d0                	callq  *%rax
  800b56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b5a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b61:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b66:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b69:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b6c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b70:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b78:	45 89 c1             	mov    %r8d,%r9d
  800b7b:	41 89 f8             	mov    %edi,%r8d
  800b7e:	48 89 c7             	mov    %rax,%rdi
  800b81:	48 b8 11 04 80 00 00 	movabs $0x800411,%rax
  800b88:	00 00 00 
  800b8b:	ff d0                	callq  *%rax
			break;
  800b8d:	eb 3f                	jmp    800bce <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b8f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b97:	48 89 d6             	mov    %rdx,%rsi
  800b9a:	89 df                	mov    %ebx,%edi
  800b9c:	ff d0                	callq  *%rax
			break;
  800b9e:	eb 2e                	jmp    800bce <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba8:	48 89 d6             	mov    %rdx,%rsi
  800bab:	bf 25 00 00 00       	mov    $0x25,%edi
  800bb0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bb7:	eb 05                	jmp    800bbe <vprintfmt+0x4e7>
  800bb9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bbe:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bc2:	48 83 e8 01          	sub    $0x1,%rax
  800bc6:	0f b6 00             	movzbl (%rax),%eax
  800bc9:	3c 25                	cmp    $0x25,%al
  800bcb:	75 ec                	jne    800bb9 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800bcd:	90                   	nop
		}
	}
  800bce:	e9 3d fb ff ff       	jmpq   800710 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bd3:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bd4:	48 83 c4 60          	add    $0x60,%rsp
  800bd8:	5b                   	pop    %rbx
  800bd9:	41 5c                	pop    %r12
  800bdb:	5d                   	pop    %rbp
  800bdc:	c3                   	retq   

0000000000800bdd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bdd:	55                   	push   %rbp
  800bde:	48 89 e5             	mov    %rsp,%rbp
  800be1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800be8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bef:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bf6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800bfd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c04:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c0b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c12:	84 c0                	test   %al,%al
  800c14:	74 20                	je     800c36 <printfmt+0x59>
  800c16:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c1a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c1e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c22:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c26:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c2a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c2e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c32:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c36:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c3d:	00 00 00 
  800c40:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c47:	00 00 00 
  800c4a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c4e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c55:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c5c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c63:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c6a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c71:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c78:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c7f:	48 89 c7             	mov    %rax,%rdi
  800c82:	48 b8 d7 06 80 00 00 	movabs $0x8006d7,%rax
  800c89:	00 00 00 
  800c8c:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c8e:	90                   	nop
  800c8f:	c9                   	leaveq 
  800c90:	c3                   	retq   

0000000000800c91 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c91:	55                   	push   %rbp
  800c92:	48 89 e5             	mov    %rsp,%rbp
  800c95:	48 83 ec 10          	sub    $0x10,%rsp
  800c99:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c9c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ca0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca4:	8b 40 10             	mov    0x10(%rax),%eax
  800ca7:	8d 50 01             	lea    0x1(%rax),%edx
  800caa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cae:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb5:	48 8b 10             	mov    (%rax),%rdx
  800cb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cbc:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cc0:	48 39 c2             	cmp    %rax,%rdx
  800cc3:	73 17                	jae    800cdc <sprintputch+0x4b>
		*b->buf++ = ch;
  800cc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc9:	48 8b 00             	mov    (%rax),%rax
  800ccc:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cd0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cd4:	48 89 0a             	mov    %rcx,(%rdx)
  800cd7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cda:	88 10                	mov    %dl,(%rax)
}
  800cdc:	90                   	nop
  800cdd:	c9                   	leaveq 
  800cde:	c3                   	retq   

0000000000800cdf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cdf:	55                   	push   %rbp
  800ce0:	48 89 e5             	mov    %rsp,%rbp
  800ce3:	48 83 ec 50          	sub    $0x50,%rsp
  800ce7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ceb:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cee:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cf2:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cf6:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cfa:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800cfe:	48 8b 0a             	mov    (%rdx),%rcx
  800d01:	48 89 08             	mov    %rcx,(%rax)
  800d04:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d08:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d0c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d10:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d14:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d18:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d1c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d1f:	48 98                	cltq   
  800d21:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d25:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d29:	48 01 d0             	add    %rdx,%rax
  800d2c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d30:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d37:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d3c:	74 06                	je     800d44 <vsnprintf+0x65>
  800d3e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d42:	7f 07                	jg     800d4b <vsnprintf+0x6c>
		return -E_INVAL;
  800d44:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d49:	eb 2f                	jmp    800d7a <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d4b:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d4f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d53:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d57:	48 89 c6             	mov    %rax,%rsi
  800d5a:	48 bf 91 0c 80 00 00 	movabs $0x800c91,%rdi
  800d61:	00 00 00 
  800d64:	48 b8 d7 06 80 00 00 	movabs $0x8006d7,%rax
  800d6b:	00 00 00 
  800d6e:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d74:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d77:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d7a:	c9                   	leaveq 
  800d7b:	c3                   	retq   

0000000000800d7c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d7c:	55                   	push   %rbp
  800d7d:	48 89 e5             	mov    %rsp,%rbp
  800d80:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d87:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d8e:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d94:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800d9b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800da2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800da9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800db0:	84 c0                	test   %al,%al
  800db2:	74 20                	je     800dd4 <snprintf+0x58>
  800db4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800db8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dbc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dc0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dc4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dc8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dcc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dd0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800dd4:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800ddb:	00 00 00 
  800dde:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800de5:	00 00 00 
  800de8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dec:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800df3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dfa:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e01:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e08:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e0f:	48 8b 0a             	mov    (%rdx),%rcx
  800e12:	48 89 08             	mov    %rcx,(%rax)
  800e15:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e19:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e1d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e21:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e25:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e2c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e33:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e39:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e40:	48 89 c7             	mov    %rax,%rdi
  800e43:	48 b8 df 0c 80 00 00 	movabs $0x800cdf,%rax
  800e4a:	00 00 00 
  800e4d:	ff d0                	callq  *%rax
  800e4f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e55:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e5b:	c9                   	leaveq 
  800e5c:	c3                   	retq   

0000000000800e5d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e5d:	55                   	push   %rbp
  800e5e:	48 89 e5             	mov    %rsp,%rbp
  800e61:	48 83 ec 18          	sub    $0x18,%rsp
  800e65:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e70:	eb 09                	jmp    800e7b <strlen+0x1e>
		n++;
  800e72:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e76:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7f:	0f b6 00             	movzbl (%rax),%eax
  800e82:	84 c0                	test   %al,%al
  800e84:	75 ec                	jne    800e72 <strlen+0x15>
		n++;
	return n;
  800e86:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e89:	c9                   	leaveq 
  800e8a:	c3                   	retq   

0000000000800e8b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e8b:	55                   	push   %rbp
  800e8c:	48 89 e5             	mov    %rsp,%rbp
  800e8f:	48 83 ec 20          	sub    $0x20,%rsp
  800e93:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e97:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ea2:	eb 0e                	jmp    800eb2 <strnlen+0x27>
		n++;
  800ea4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ead:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800eb2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800eb7:	74 0b                	je     800ec4 <strnlen+0x39>
  800eb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebd:	0f b6 00             	movzbl (%rax),%eax
  800ec0:	84 c0                	test   %al,%al
  800ec2:	75 e0                	jne    800ea4 <strnlen+0x19>
		n++;
	return n;
  800ec4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ec7:	c9                   	leaveq 
  800ec8:	c3                   	retq   

0000000000800ec9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ec9:	55                   	push   %rbp
  800eca:	48 89 e5             	mov    %rsp,%rbp
  800ecd:	48 83 ec 20          	sub    $0x20,%rsp
  800ed1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ed5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800ed9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800edd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ee1:	90                   	nop
  800ee2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800eea:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800eee:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ef2:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ef6:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800efa:	0f b6 12             	movzbl (%rdx),%edx
  800efd:	88 10                	mov    %dl,(%rax)
  800eff:	0f b6 00             	movzbl (%rax),%eax
  800f02:	84 c0                	test   %al,%al
  800f04:	75 dc                	jne    800ee2 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f0a:	c9                   	leaveq 
  800f0b:	c3                   	retq   

0000000000800f0c <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f0c:	55                   	push   %rbp
  800f0d:	48 89 e5             	mov    %rsp,%rbp
  800f10:	48 83 ec 20          	sub    $0x20,%rsp
  800f14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f18:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f20:	48 89 c7             	mov    %rax,%rdi
  800f23:	48 b8 5d 0e 80 00 00 	movabs $0x800e5d,%rax
  800f2a:	00 00 00 
  800f2d:	ff d0                	callq  *%rax
  800f2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f35:	48 63 d0             	movslq %eax,%rdx
  800f38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3c:	48 01 c2             	add    %rax,%rdx
  800f3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f43:	48 89 c6             	mov    %rax,%rsi
  800f46:	48 89 d7             	mov    %rdx,%rdi
  800f49:	48 b8 c9 0e 80 00 00 	movabs $0x800ec9,%rax
  800f50:	00 00 00 
  800f53:	ff d0                	callq  *%rax
	return dst;
  800f55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f59:	c9                   	leaveq 
  800f5a:	c3                   	retq   

0000000000800f5b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f5b:	55                   	push   %rbp
  800f5c:	48 89 e5             	mov    %rsp,%rbp
  800f5f:	48 83 ec 28          	sub    $0x28,%rsp
  800f63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f67:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f6b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f73:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f77:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f7e:	00 
  800f7f:	eb 2a                	jmp    800fab <strncpy+0x50>
		*dst++ = *src;
  800f81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f85:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f89:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f8d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f91:	0f b6 12             	movzbl (%rdx),%edx
  800f94:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f9a:	0f b6 00             	movzbl (%rax),%eax
  800f9d:	84 c0                	test   %al,%al
  800f9f:	74 05                	je     800fa6 <strncpy+0x4b>
			src++;
  800fa1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fa6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800faf:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fb3:	72 cc                	jb     800f81 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fb9:	c9                   	leaveq 
  800fba:	c3                   	retq   

0000000000800fbb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fbb:	55                   	push   %rbp
  800fbc:	48 89 e5             	mov    %rsp,%rbp
  800fbf:	48 83 ec 28          	sub    $0x28,%rsp
  800fc3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fc7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fcb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fd7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fdc:	74 3d                	je     80101b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fde:	eb 1d                	jmp    800ffd <strlcpy+0x42>
			*dst++ = *src++;
  800fe0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fe8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fec:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ff0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ff4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ff8:	0f b6 12             	movzbl (%rdx),%edx
  800ffb:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ffd:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801002:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801007:	74 0b                	je     801014 <strlcpy+0x59>
  801009:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80100d:	0f b6 00             	movzbl (%rax),%eax
  801010:	84 c0                	test   %al,%al
  801012:	75 cc                	jne    800fe0 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801014:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801018:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80101b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80101f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801023:	48 29 c2             	sub    %rax,%rdx
  801026:	48 89 d0             	mov    %rdx,%rax
}
  801029:	c9                   	leaveq 
  80102a:	c3                   	retq   

000000000080102b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80102b:	55                   	push   %rbp
  80102c:	48 89 e5             	mov    %rsp,%rbp
  80102f:	48 83 ec 10          	sub    $0x10,%rsp
  801033:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801037:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80103b:	eb 0a                	jmp    801047 <strcmp+0x1c>
		p++, q++;
  80103d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801042:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801047:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104b:	0f b6 00             	movzbl (%rax),%eax
  80104e:	84 c0                	test   %al,%al
  801050:	74 12                	je     801064 <strcmp+0x39>
  801052:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801056:	0f b6 10             	movzbl (%rax),%edx
  801059:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80105d:	0f b6 00             	movzbl (%rax),%eax
  801060:	38 c2                	cmp    %al,%dl
  801062:	74 d9                	je     80103d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801064:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801068:	0f b6 00             	movzbl (%rax),%eax
  80106b:	0f b6 d0             	movzbl %al,%edx
  80106e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801072:	0f b6 00             	movzbl (%rax),%eax
  801075:	0f b6 c0             	movzbl %al,%eax
  801078:	29 c2                	sub    %eax,%edx
  80107a:	89 d0                	mov    %edx,%eax
}
  80107c:	c9                   	leaveq 
  80107d:	c3                   	retq   

000000000080107e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80107e:	55                   	push   %rbp
  80107f:	48 89 e5             	mov    %rsp,%rbp
  801082:	48 83 ec 18          	sub    $0x18,%rsp
  801086:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80108a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80108e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801092:	eb 0f                	jmp    8010a3 <strncmp+0x25>
		n--, p++, q++;
  801094:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801099:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80109e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010a3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010a8:	74 1d                	je     8010c7 <strncmp+0x49>
  8010aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ae:	0f b6 00             	movzbl (%rax),%eax
  8010b1:	84 c0                	test   %al,%al
  8010b3:	74 12                	je     8010c7 <strncmp+0x49>
  8010b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b9:	0f b6 10             	movzbl (%rax),%edx
  8010bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c0:	0f b6 00             	movzbl (%rax),%eax
  8010c3:	38 c2                	cmp    %al,%dl
  8010c5:	74 cd                	je     801094 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010c7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010cc:	75 07                	jne    8010d5 <strncmp+0x57>
		return 0;
  8010ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d3:	eb 18                	jmp    8010ed <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d9:	0f b6 00             	movzbl (%rax),%eax
  8010dc:	0f b6 d0             	movzbl %al,%edx
  8010df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e3:	0f b6 00             	movzbl (%rax),%eax
  8010e6:	0f b6 c0             	movzbl %al,%eax
  8010e9:	29 c2                	sub    %eax,%edx
  8010eb:	89 d0                	mov    %edx,%eax
}
  8010ed:	c9                   	leaveq 
  8010ee:	c3                   	retq   

00000000008010ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010ef:	55                   	push   %rbp
  8010f0:	48 89 e5             	mov    %rsp,%rbp
  8010f3:	48 83 ec 10          	sub    $0x10,%rsp
  8010f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010fb:	89 f0                	mov    %esi,%eax
  8010fd:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801100:	eb 17                	jmp    801119 <strchr+0x2a>
		if (*s == c)
  801102:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801106:	0f b6 00             	movzbl (%rax),%eax
  801109:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80110c:	75 06                	jne    801114 <strchr+0x25>
			return (char *) s;
  80110e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801112:	eb 15                	jmp    801129 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801114:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801119:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111d:	0f b6 00             	movzbl (%rax),%eax
  801120:	84 c0                	test   %al,%al
  801122:	75 de                	jne    801102 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801124:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801129:	c9                   	leaveq 
  80112a:	c3                   	retq   

000000000080112b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80112b:	55                   	push   %rbp
  80112c:	48 89 e5             	mov    %rsp,%rbp
  80112f:	48 83 ec 10          	sub    $0x10,%rsp
  801133:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801137:	89 f0                	mov    %esi,%eax
  801139:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80113c:	eb 11                	jmp    80114f <strfind+0x24>
		if (*s == c)
  80113e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801142:	0f b6 00             	movzbl (%rax),%eax
  801145:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801148:	74 12                	je     80115c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80114a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80114f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801153:	0f b6 00             	movzbl (%rax),%eax
  801156:	84 c0                	test   %al,%al
  801158:	75 e4                	jne    80113e <strfind+0x13>
  80115a:	eb 01                	jmp    80115d <strfind+0x32>
		if (*s == c)
			break;
  80115c:	90                   	nop
	return (char *) s;
  80115d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801161:	c9                   	leaveq 
  801162:	c3                   	retq   

0000000000801163 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801163:	55                   	push   %rbp
  801164:	48 89 e5             	mov    %rsp,%rbp
  801167:	48 83 ec 18          	sub    $0x18,%rsp
  80116b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80116f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801172:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801176:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80117b:	75 06                	jne    801183 <memset+0x20>
		return v;
  80117d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801181:	eb 69                	jmp    8011ec <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801183:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801187:	83 e0 03             	and    $0x3,%eax
  80118a:	48 85 c0             	test   %rax,%rax
  80118d:	75 48                	jne    8011d7 <memset+0x74>
  80118f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801193:	83 e0 03             	and    $0x3,%eax
  801196:	48 85 c0             	test   %rax,%rax
  801199:	75 3c                	jne    8011d7 <memset+0x74>
		c &= 0xFF;
  80119b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011a2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011a5:	c1 e0 18             	shl    $0x18,%eax
  8011a8:	89 c2                	mov    %eax,%edx
  8011aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ad:	c1 e0 10             	shl    $0x10,%eax
  8011b0:	09 c2                	or     %eax,%edx
  8011b2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b5:	c1 e0 08             	shl    $0x8,%eax
  8011b8:	09 d0                	or     %edx,%eax
  8011ba:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c1:	48 c1 e8 02          	shr    $0x2,%rax
  8011c5:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011cc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011cf:	48 89 d7             	mov    %rdx,%rdi
  8011d2:	fc                   	cld    
  8011d3:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011d5:	eb 11                	jmp    8011e8 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011de:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011e2:	48 89 d7             	mov    %rdx,%rdi
  8011e5:	fc                   	cld    
  8011e6:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ec:	c9                   	leaveq 
  8011ed:	c3                   	retq   

00000000008011ee <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011ee:	55                   	push   %rbp
  8011ef:	48 89 e5             	mov    %rsp,%rbp
  8011f2:	48 83 ec 28          	sub    $0x28,%rsp
  8011f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801202:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801206:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80120a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801216:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80121a:	0f 83 88 00 00 00    	jae    8012a8 <memmove+0xba>
  801220:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801224:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801228:	48 01 d0             	add    %rdx,%rax
  80122b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80122f:	76 77                	jbe    8012a8 <memmove+0xba>
		s += n;
  801231:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801235:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801239:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801241:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801245:	83 e0 03             	and    $0x3,%eax
  801248:	48 85 c0             	test   %rax,%rax
  80124b:	75 3b                	jne    801288 <memmove+0x9a>
  80124d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801251:	83 e0 03             	and    $0x3,%eax
  801254:	48 85 c0             	test   %rax,%rax
  801257:	75 2f                	jne    801288 <memmove+0x9a>
  801259:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80125d:	83 e0 03             	and    $0x3,%eax
  801260:	48 85 c0             	test   %rax,%rax
  801263:	75 23                	jne    801288 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801265:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801269:	48 83 e8 04          	sub    $0x4,%rax
  80126d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801271:	48 83 ea 04          	sub    $0x4,%rdx
  801275:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801279:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80127d:	48 89 c7             	mov    %rax,%rdi
  801280:	48 89 d6             	mov    %rdx,%rsi
  801283:	fd                   	std    
  801284:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801286:	eb 1d                	jmp    8012a5 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801288:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801294:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801298:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80129c:	48 89 d7             	mov    %rdx,%rdi
  80129f:	48 89 c1             	mov    %rax,%rcx
  8012a2:	fd                   	std    
  8012a3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012a5:	fc                   	cld    
  8012a6:	eb 57                	jmp    8012ff <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ac:	83 e0 03             	and    $0x3,%eax
  8012af:	48 85 c0             	test   %rax,%rax
  8012b2:	75 36                	jne    8012ea <memmove+0xfc>
  8012b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b8:	83 e0 03             	and    $0x3,%eax
  8012bb:	48 85 c0             	test   %rax,%rax
  8012be:	75 2a                	jne    8012ea <memmove+0xfc>
  8012c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c4:	83 e0 03             	and    $0x3,%eax
  8012c7:	48 85 c0             	test   %rax,%rax
  8012ca:	75 1e                	jne    8012ea <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d0:	48 c1 e8 02          	shr    $0x2,%rax
  8012d4:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012df:	48 89 c7             	mov    %rax,%rdi
  8012e2:	48 89 d6             	mov    %rdx,%rsi
  8012e5:	fc                   	cld    
  8012e6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012e8:	eb 15                	jmp    8012ff <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012f6:	48 89 c7             	mov    %rax,%rdi
  8012f9:	48 89 d6             	mov    %rdx,%rsi
  8012fc:	fc                   	cld    
  8012fd:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801303:	c9                   	leaveq 
  801304:	c3                   	retq   

0000000000801305 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801305:	55                   	push   %rbp
  801306:	48 89 e5             	mov    %rsp,%rbp
  801309:	48 83 ec 18          	sub    $0x18,%rsp
  80130d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801311:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801315:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801319:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80131d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801321:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801325:	48 89 ce             	mov    %rcx,%rsi
  801328:	48 89 c7             	mov    %rax,%rdi
  80132b:	48 b8 ee 11 80 00 00 	movabs $0x8011ee,%rax
  801332:	00 00 00 
  801335:	ff d0                	callq  *%rax
}
  801337:	c9                   	leaveq 
  801338:	c3                   	retq   

0000000000801339 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801339:	55                   	push   %rbp
  80133a:	48 89 e5             	mov    %rsp,%rbp
  80133d:	48 83 ec 28          	sub    $0x28,%rsp
  801341:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801345:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801349:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80134d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801351:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801355:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801359:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80135d:	eb 36                	jmp    801395 <memcmp+0x5c>
		if (*s1 != *s2)
  80135f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801363:	0f b6 10             	movzbl (%rax),%edx
  801366:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136a:	0f b6 00             	movzbl (%rax),%eax
  80136d:	38 c2                	cmp    %al,%dl
  80136f:	74 1a                	je     80138b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801371:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801375:	0f b6 00             	movzbl (%rax),%eax
  801378:	0f b6 d0             	movzbl %al,%edx
  80137b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137f:	0f b6 00             	movzbl (%rax),%eax
  801382:	0f b6 c0             	movzbl %al,%eax
  801385:	29 c2                	sub    %eax,%edx
  801387:	89 d0                	mov    %edx,%eax
  801389:	eb 20                	jmp    8013ab <memcmp+0x72>
		s1++, s2++;
  80138b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801390:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801395:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801399:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80139d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013a1:	48 85 c0             	test   %rax,%rax
  8013a4:	75 b9                	jne    80135f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ab:	c9                   	leaveq 
  8013ac:	c3                   	retq   

00000000008013ad <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013ad:	55                   	push   %rbp
  8013ae:	48 89 e5             	mov    %rsp,%rbp
  8013b1:	48 83 ec 28          	sub    $0x28,%rsp
  8013b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013b9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c8:	48 01 d0             	add    %rdx,%rax
  8013cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013cf:	eb 19                	jmp    8013ea <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d5:	0f b6 00             	movzbl (%rax),%eax
  8013d8:	0f b6 d0             	movzbl %al,%edx
  8013db:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013de:	0f b6 c0             	movzbl %al,%eax
  8013e1:	39 c2                	cmp    %eax,%edx
  8013e3:	74 11                	je     8013f6 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013e5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ee:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013f2:	72 dd                	jb     8013d1 <memfind+0x24>
  8013f4:	eb 01                	jmp    8013f7 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013f6:	90                   	nop
	return (void *) s;
  8013f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013fb:	c9                   	leaveq 
  8013fc:	c3                   	retq   

00000000008013fd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013fd:	55                   	push   %rbp
  8013fe:	48 89 e5             	mov    %rsp,%rbp
  801401:	48 83 ec 38          	sub    $0x38,%rsp
  801405:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801409:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80140d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801417:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80141e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80141f:	eb 05                	jmp    801426 <strtol+0x29>
		s++;
  801421:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801426:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142a:	0f b6 00             	movzbl (%rax),%eax
  80142d:	3c 20                	cmp    $0x20,%al
  80142f:	74 f0                	je     801421 <strtol+0x24>
  801431:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801435:	0f b6 00             	movzbl (%rax),%eax
  801438:	3c 09                	cmp    $0x9,%al
  80143a:	74 e5                	je     801421 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80143c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801440:	0f b6 00             	movzbl (%rax),%eax
  801443:	3c 2b                	cmp    $0x2b,%al
  801445:	75 07                	jne    80144e <strtol+0x51>
		s++;
  801447:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80144c:	eb 17                	jmp    801465 <strtol+0x68>
	else if (*s == '-')
  80144e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801452:	0f b6 00             	movzbl (%rax),%eax
  801455:	3c 2d                	cmp    $0x2d,%al
  801457:	75 0c                	jne    801465 <strtol+0x68>
		s++, neg = 1;
  801459:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80145e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801465:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801469:	74 06                	je     801471 <strtol+0x74>
  80146b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80146f:	75 28                	jne    801499 <strtol+0x9c>
  801471:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801475:	0f b6 00             	movzbl (%rax),%eax
  801478:	3c 30                	cmp    $0x30,%al
  80147a:	75 1d                	jne    801499 <strtol+0x9c>
  80147c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801480:	48 83 c0 01          	add    $0x1,%rax
  801484:	0f b6 00             	movzbl (%rax),%eax
  801487:	3c 78                	cmp    $0x78,%al
  801489:	75 0e                	jne    801499 <strtol+0x9c>
		s += 2, base = 16;
  80148b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801490:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801497:	eb 2c                	jmp    8014c5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801499:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80149d:	75 19                	jne    8014b8 <strtol+0xbb>
  80149f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a3:	0f b6 00             	movzbl (%rax),%eax
  8014a6:	3c 30                	cmp    $0x30,%al
  8014a8:	75 0e                	jne    8014b8 <strtol+0xbb>
		s++, base = 8;
  8014aa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014af:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014b6:	eb 0d                	jmp    8014c5 <strtol+0xc8>
	else if (base == 0)
  8014b8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014bc:	75 07                	jne    8014c5 <strtol+0xc8>
		base = 10;
  8014be:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c9:	0f b6 00             	movzbl (%rax),%eax
  8014cc:	3c 2f                	cmp    $0x2f,%al
  8014ce:	7e 1d                	jle    8014ed <strtol+0xf0>
  8014d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d4:	0f b6 00             	movzbl (%rax),%eax
  8014d7:	3c 39                	cmp    $0x39,%al
  8014d9:	7f 12                	jg     8014ed <strtol+0xf0>
			dig = *s - '0';
  8014db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014df:	0f b6 00             	movzbl (%rax),%eax
  8014e2:	0f be c0             	movsbl %al,%eax
  8014e5:	83 e8 30             	sub    $0x30,%eax
  8014e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014eb:	eb 4e                	jmp    80153b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f1:	0f b6 00             	movzbl (%rax),%eax
  8014f4:	3c 60                	cmp    $0x60,%al
  8014f6:	7e 1d                	jle    801515 <strtol+0x118>
  8014f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fc:	0f b6 00             	movzbl (%rax),%eax
  8014ff:	3c 7a                	cmp    $0x7a,%al
  801501:	7f 12                	jg     801515 <strtol+0x118>
			dig = *s - 'a' + 10;
  801503:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801507:	0f b6 00             	movzbl (%rax),%eax
  80150a:	0f be c0             	movsbl %al,%eax
  80150d:	83 e8 57             	sub    $0x57,%eax
  801510:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801513:	eb 26                	jmp    80153b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801515:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801519:	0f b6 00             	movzbl (%rax),%eax
  80151c:	3c 40                	cmp    $0x40,%al
  80151e:	7e 47                	jle    801567 <strtol+0x16a>
  801520:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801524:	0f b6 00             	movzbl (%rax),%eax
  801527:	3c 5a                	cmp    $0x5a,%al
  801529:	7f 3c                	jg     801567 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80152b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152f:	0f b6 00             	movzbl (%rax),%eax
  801532:	0f be c0             	movsbl %al,%eax
  801535:	83 e8 37             	sub    $0x37,%eax
  801538:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80153b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80153e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801541:	7d 23                	jge    801566 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801543:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801548:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80154b:	48 98                	cltq   
  80154d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801552:	48 89 c2             	mov    %rax,%rdx
  801555:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801558:	48 98                	cltq   
  80155a:	48 01 d0             	add    %rdx,%rax
  80155d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801561:	e9 5f ff ff ff       	jmpq   8014c5 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801566:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801567:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80156c:	74 0b                	je     801579 <strtol+0x17c>
		*endptr = (char *) s;
  80156e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801572:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801576:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801579:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80157d:	74 09                	je     801588 <strtol+0x18b>
  80157f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801583:	48 f7 d8             	neg    %rax
  801586:	eb 04                	jmp    80158c <strtol+0x18f>
  801588:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80158c:	c9                   	leaveq 
  80158d:	c3                   	retq   

000000000080158e <strstr>:

char * strstr(const char *in, const char *str)
{
  80158e:	55                   	push   %rbp
  80158f:	48 89 e5             	mov    %rsp,%rbp
  801592:	48 83 ec 30          	sub    $0x30,%rsp
  801596:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80159a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80159e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015a2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015a6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8015b0:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015b4:	75 06                	jne    8015bc <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ba:	eb 6b                	jmp    801627 <strstr+0x99>

	len = strlen(str);
  8015bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015c0:	48 89 c7             	mov    %rax,%rdi
  8015c3:	48 b8 5d 0e 80 00 00 	movabs $0x800e5d,%rax
  8015ca:	00 00 00 
  8015cd:	ff d0                	callq  *%rax
  8015cf:	48 98                	cltq   
  8015d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015e1:	0f b6 00             	movzbl (%rax),%eax
  8015e4:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015e7:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015eb:	75 07                	jne    8015f4 <strstr+0x66>
				return (char *) 0;
  8015ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f2:	eb 33                	jmp    801627 <strstr+0x99>
		} while (sc != c);
  8015f4:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015f8:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015fb:	75 d8                	jne    8015d5 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8015fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801601:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801605:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801609:	48 89 ce             	mov    %rcx,%rsi
  80160c:	48 89 c7             	mov    %rax,%rdi
  80160f:	48 b8 7e 10 80 00 00 	movabs $0x80107e,%rax
  801616:	00 00 00 
  801619:	ff d0                	callq  *%rax
  80161b:	85 c0                	test   %eax,%eax
  80161d:	75 b6                	jne    8015d5 <strstr+0x47>

	return (char *) (in - 1);
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	48 83 e8 01          	sub    $0x1,%rax
}
  801627:	c9                   	leaveq 
  801628:	c3                   	retq   

0000000000801629 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801629:	55                   	push   %rbp
  80162a:	48 89 e5             	mov    %rsp,%rbp
  80162d:	53                   	push   %rbx
  80162e:	48 83 ec 48          	sub    $0x48,%rsp
  801632:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801635:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801638:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80163c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801640:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801644:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801648:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80164b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80164f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801653:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801657:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80165b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80165f:	4c 89 c3             	mov    %r8,%rbx
  801662:	cd 30                	int    $0x30
  801664:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801668:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80166c:	74 3e                	je     8016ac <syscall+0x83>
  80166e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801673:	7e 37                	jle    8016ac <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801675:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801679:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80167c:	49 89 d0             	mov    %rdx,%r8
  80167f:	89 c1                	mov    %eax,%ecx
  801681:	48 ba e8 27 80 00 00 	movabs $0x8027e8,%rdx
  801688:	00 00 00 
  80168b:	be 23 00 00 00       	mov    $0x23,%esi
  801690:	48 bf 05 28 80 00 00 	movabs $0x802805,%rdi
  801697:	00 00 00 
  80169a:	b8 00 00 00 00       	mov    $0x0,%eax
  80169f:	49 b9 f8 20 80 00 00 	movabs $0x8020f8,%r9
  8016a6:	00 00 00 
  8016a9:	41 ff d1             	callq  *%r9

	return ret;
  8016ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016b0:	48 83 c4 48          	add    $0x48,%rsp
  8016b4:	5b                   	pop    %rbx
  8016b5:	5d                   	pop    %rbp
  8016b6:	c3                   	retq   

00000000008016b7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016b7:	55                   	push   %rbp
  8016b8:	48 89 e5             	mov    %rsp,%rbp
  8016bb:	48 83 ec 10          	sub    $0x10,%rsp
  8016bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016cf:	48 83 ec 08          	sub    $0x8,%rsp
  8016d3:	6a 00                	pushq  $0x0
  8016d5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016db:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e1:	48 89 d1             	mov    %rdx,%rcx
  8016e4:	48 89 c2             	mov    %rax,%rdx
  8016e7:	be 00 00 00 00       	mov    $0x0,%esi
  8016ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8016f1:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8016f8:	00 00 00 
  8016fb:	ff d0                	callq  *%rax
  8016fd:	48 83 c4 10          	add    $0x10,%rsp
}
  801701:	90                   	nop
  801702:	c9                   	leaveq 
  801703:	c3                   	retq   

0000000000801704 <sys_cgetc>:

int
sys_cgetc(void)
{
  801704:	55                   	push   %rbp
  801705:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801708:	48 83 ec 08          	sub    $0x8,%rsp
  80170c:	6a 00                	pushq  $0x0
  80170e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801714:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80171a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80171f:	ba 00 00 00 00       	mov    $0x0,%edx
  801724:	be 00 00 00 00       	mov    $0x0,%esi
  801729:	bf 01 00 00 00       	mov    $0x1,%edi
  80172e:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801735:	00 00 00 
  801738:	ff d0                	callq  *%rax
  80173a:	48 83 c4 10          	add    $0x10,%rsp
}
  80173e:	c9                   	leaveq 
  80173f:	c3                   	retq   

0000000000801740 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801740:	55                   	push   %rbp
  801741:	48 89 e5             	mov    %rsp,%rbp
  801744:	48 83 ec 10          	sub    $0x10,%rsp
  801748:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80174b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80174e:	48 98                	cltq   
  801750:	48 83 ec 08          	sub    $0x8,%rsp
  801754:	6a 00                	pushq  $0x0
  801756:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80175c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801762:	b9 00 00 00 00       	mov    $0x0,%ecx
  801767:	48 89 c2             	mov    %rax,%rdx
  80176a:	be 01 00 00 00       	mov    $0x1,%esi
  80176f:	bf 03 00 00 00       	mov    $0x3,%edi
  801774:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  80177b:	00 00 00 
  80177e:	ff d0                	callq  *%rax
  801780:	48 83 c4 10          	add    $0x10,%rsp
}
  801784:	c9                   	leaveq 
  801785:	c3                   	retq   

0000000000801786 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801786:	55                   	push   %rbp
  801787:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80178a:	48 83 ec 08          	sub    $0x8,%rsp
  80178e:	6a 00                	pushq  $0x0
  801790:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801796:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80179c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a6:	be 00 00 00 00       	mov    $0x0,%esi
  8017ab:	bf 02 00 00 00       	mov    $0x2,%edi
  8017b0:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8017b7:	00 00 00 
  8017ba:	ff d0                	callq  *%rax
  8017bc:	48 83 c4 10          	add    $0x10,%rsp
}
  8017c0:	c9                   	leaveq 
  8017c1:	c3                   	retq   

00000000008017c2 <sys_yield>:

void
sys_yield(void)
{
  8017c2:	55                   	push   %rbp
  8017c3:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017c6:	48 83 ec 08          	sub    $0x8,%rsp
  8017ca:	6a 00                	pushq  $0x0
  8017cc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e2:	be 00 00 00 00       	mov    $0x0,%esi
  8017e7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8017ec:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8017f3:	00 00 00 
  8017f6:	ff d0                	callq  *%rax
  8017f8:	48 83 c4 10          	add    $0x10,%rsp
}
  8017fc:	90                   	nop
  8017fd:	c9                   	leaveq 
  8017fe:	c3                   	retq   

00000000008017ff <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017ff:	55                   	push   %rbp
  801800:	48 89 e5             	mov    %rsp,%rbp
  801803:	48 83 ec 10          	sub    $0x10,%rsp
  801807:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80180a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80180e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801811:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801814:	48 63 c8             	movslq %eax,%rcx
  801817:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80181b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80181e:	48 98                	cltq   
  801820:	48 83 ec 08          	sub    $0x8,%rsp
  801824:	6a 00                	pushq  $0x0
  801826:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182c:	49 89 c8             	mov    %rcx,%r8
  80182f:	48 89 d1             	mov    %rdx,%rcx
  801832:	48 89 c2             	mov    %rax,%rdx
  801835:	be 01 00 00 00       	mov    $0x1,%esi
  80183a:	bf 04 00 00 00       	mov    $0x4,%edi
  80183f:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801846:	00 00 00 
  801849:	ff d0                	callq  *%rax
  80184b:	48 83 c4 10          	add    $0x10,%rsp
}
  80184f:	c9                   	leaveq 
  801850:	c3                   	retq   

0000000000801851 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801851:	55                   	push   %rbp
  801852:	48 89 e5             	mov    %rsp,%rbp
  801855:	48 83 ec 20          	sub    $0x20,%rsp
  801859:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80185c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801860:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801863:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801867:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80186b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80186e:	48 63 c8             	movslq %eax,%rcx
  801871:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801875:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801878:	48 63 f0             	movslq %eax,%rsi
  80187b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80187f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801882:	48 98                	cltq   
  801884:	48 83 ec 08          	sub    $0x8,%rsp
  801888:	51                   	push   %rcx
  801889:	49 89 f9             	mov    %rdi,%r9
  80188c:	49 89 f0             	mov    %rsi,%r8
  80188f:	48 89 d1             	mov    %rdx,%rcx
  801892:	48 89 c2             	mov    %rax,%rdx
  801895:	be 01 00 00 00       	mov    $0x1,%esi
  80189a:	bf 05 00 00 00       	mov    $0x5,%edi
  80189f:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8018a6:	00 00 00 
  8018a9:	ff d0                	callq  *%rax
  8018ab:	48 83 c4 10          	add    $0x10,%rsp
}
  8018af:	c9                   	leaveq 
  8018b0:	c3                   	retq   

00000000008018b1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018b1:	55                   	push   %rbp
  8018b2:	48 89 e5             	mov    %rsp,%rbp
  8018b5:	48 83 ec 10          	sub    $0x10,%rsp
  8018b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c7:	48 98                	cltq   
  8018c9:	48 83 ec 08          	sub    $0x8,%rsp
  8018cd:	6a 00                	pushq  $0x0
  8018cf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018db:	48 89 d1             	mov    %rdx,%rcx
  8018de:	48 89 c2             	mov    %rax,%rdx
  8018e1:	be 01 00 00 00       	mov    $0x1,%esi
  8018e6:	bf 06 00 00 00       	mov    $0x6,%edi
  8018eb:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8018f2:	00 00 00 
  8018f5:	ff d0                	callq  *%rax
  8018f7:	48 83 c4 10          	add    $0x10,%rsp
}
  8018fb:	c9                   	leaveq 
  8018fc:	c3                   	retq   

00000000008018fd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018fd:	55                   	push   %rbp
  8018fe:	48 89 e5             	mov    %rsp,%rbp
  801901:	48 83 ec 10          	sub    $0x10,%rsp
  801905:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801908:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80190b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80190e:	48 63 d0             	movslq %eax,%rdx
  801911:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801914:	48 98                	cltq   
  801916:	48 83 ec 08          	sub    $0x8,%rsp
  80191a:	6a 00                	pushq  $0x0
  80191c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801922:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801928:	48 89 d1             	mov    %rdx,%rcx
  80192b:	48 89 c2             	mov    %rax,%rdx
  80192e:	be 01 00 00 00       	mov    $0x1,%esi
  801933:	bf 08 00 00 00       	mov    $0x8,%edi
  801938:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  80193f:	00 00 00 
  801942:	ff d0                	callq  *%rax
  801944:	48 83 c4 10          	add    $0x10,%rsp
}
  801948:	c9                   	leaveq 
  801949:	c3                   	retq   

000000000080194a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80194a:	55                   	push   %rbp
  80194b:	48 89 e5             	mov    %rsp,%rbp
  80194e:	48 83 ec 10          	sub    $0x10,%rsp
  801952:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801955:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801959:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801960:	48 98                	cltq   
  801962:	48 83 ec 08          	sub    $0x8,%rsp
  801966:	6a 00                	pushq  $0x0
  801968:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80196e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801974:	48 89 d1             	mov    %rdx,%rcx
  801977:	48 89 c2             	mov    %rax,%rdx
  80197a:	be 01 00 00 00       	mov    $0x1,%esi
  80197f:	bf 09 00 00 00       	mov    $0x9,%edi
  801984:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  80198b:	00 00 00 
  80198e:	ff d0                	callq  *%rax
  801990:	48 83 c4 10          	add    $0x10,%rsp
}
  801994:	c9                   	leaveq 
  801995:	c3                   	retq   

0000000000801996 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801996:	55                   	push   %rbp
  801997:	48 89 e5             	mov    %rsp,%rbp
  80199a:	48 83 ec 20          	sub    $0x20,%rsp
  80199e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019a5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019a9:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019af:	48 63 f0             	movslq %eax,%rsi
  8019b2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b9:	48 98                	cltq   
  8019bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019bf:	48 83 ec 08          	sub    $0x8,%rsp
  8019c3:	6a 00                	pushq  $0x0
  8019c5:	49 89 f1             	mov    %rsi,%r9
  8019c8:	49 89 c8             	mov    %rcx,%r8
  8019cb:	48 89 d1             	mov    %rdx,%rcx
  8019ce:	48 89 c2             	mov    %rax,%rdx
  8019d1:	be 00 00 00 00       	mov    $0x0,%esi
  8019d6:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019db:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8019e2:	00 00 00 
  8019e5:	ff d0                	callq  *%rax
  8019e7:	48 83 c4 10          	add    $0x10,%rsp
}
  8019eb:	c9                   	leaveq 
  8019ec:	c3                   	retq   

00000000008019ed <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019ed:	55                   	push   %rbp
  8019ee:	48 89 e5             	mov    %rsp,%rbp
  8019f1:	48 83 ec 10          	sub    $0x10,%rsp
  8019f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019fd:	48 83 ec 08          	sub    $0x8,%rsp
  801a01:	6a 00                	pushq  $0x0
  801a03:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a09:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a14:	48 89 c2             	mov    %rax,%rdx
  801a17:	be 01 00 00 00       	mov    $0x1,%esi
  801a1c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a21:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801a28:	00 00 00 
  801a2b:	ff d0                	callq  *%rax
  801a2d:	48 83 c4 10          	add    $0x10,%rsp
}
  801a31:	c9                   	leaveq 
  801a32:	c3                   	retq   

0000000000801a33 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801a33:	55                   	push   %rbp
  801a34:	48 89 e5             	mov    %rsp,%rbp
  801a37:	53                   	push   %rbx
  801a38:	48 83 ec 38          	sub    $0x38,%rsp
  801a3c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = ROUNDDOWN((void *) utf->utf_fault_va, PGSIZE);
  801a40:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a44:	48 8b 00             	mov    (%rax),%rax
  801a47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801a4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a4f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801a55:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801a59:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a5d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801a61:	89 45 dc             	mov    %eax,-0x24(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//err is not a writing error & permissions are not PTE_COW
	if (!((uvpt[(uint64_t)addr/PGSIZE] & PTE_COW) && (err & FEC_WR))){
  801a64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a68:	48 c1 e8 0c          	shr    $0xc,%rax
  801a6c:	48 89 c2             	mov    %rax,%rdx
  801a6f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801a76:	01 00 00 
  801a79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a7d:	25 00 08 00 00       	and    $0x800,%eax
  801a82:	48 85 c0             	test   %rax,%rax
  801a85:	74 0a                	je     801a91 <pgfault+0x5e>
  801a87:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a8a:	83 e0 02             	and    $0x2,%eax
  801a8d:	85 c0                	test   %eax,%eax
  801a8f:	75 2a                	jne    801abb <pgfault+0x88>
		panic("not proper page fault");	
  801a91:	48 ba 18 28 80 00 00 	movabs $0x802818,%rdx
  801a98:	00 00 00 
  801a9b:	be 1e 00 00 00       	mov    $0x1e,%esi
  801aa0:	48 bf 2e 28 80 00 00 	movabs $0x80282e,%rdi
  801aa7:	00 00 00 
  801aaa:	b8 00 00 00 00       	mov    $0x0,%eax
  801aaf:	48 b9 f8 20 80 00 00 	movabs $0x8020f8,%rcx
  801ab6:	00 00 00 
  801ab9:	ff d1                	callq  *%rcx
	// LAB 4: Your code here.
	
	int result;

	//allocate new page & map it
	result = sys_page_alloc(sys_getenvid(), PFTEMP, PTE_P|PTE_U|PTE_W);
  801abb:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  801ac2:	00 00 00 
  801ac5:	ff d0                	callq  *%rax
  801ac7:	ba 07 00 00 00       	mov    $0x7,%edx
  801acc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ad1:	89 c7                	mov    %eax,%edi
  801ad3:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  801ada:	00 00 00 
  801add:	ff d0                	callq  *%rax
  801adf:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801ae2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801ae6:	79 2a                	jns    801b12 <pgfault+0xdf>
		panic("page allocation failed in copy-on-write faulting page");
  801ae8:	48 ba 40 28 80 00 00 	movabs $0x802840,%rdx
  801aef:	00 00 00 
  801af2:	be 2f 00 00 00       	mov    $0x2f,%esi
  801af7:	48 bf 2e 28 80 00 00 	movabs $0x80282e,%rdi
  801afe:	00 00 00 
  801b01:	b8 00 00 00 00       	mov    $0x0,%eax
  801b06:	48 b9 f8 20 80 00 00 	movabs $0x8020f8,%rcx
  801b0d:	00 00 00 
  801b10:	ff d1                	callq  *%rcx
	}
	
	//copy page
	memcpy(PFTEMP, addr, PGSIZE);
  801b12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b16:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b1b:	48 89 c6             	mov    %rax,%rsi
  801b1e:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801b23:	48 b8 05 13 80 00 00 	movabs $0x801305,%rax
  801b2a:	00 00 00 
  801b2d:	ff d0                	callq  *%rax
	
	//map new page into original page's space
	result = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_W|PTE_U|PTE_P);
  801b2f:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  801b36:	00 00 00 
  801b39:	ff d0                	callq  *%rax
  801b3b:	89 c3                	mov    %eax,%ebx
  801b3d:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  801b44:	00 00 00 
  801b47:	ff d0                	callq  *%rax
  801b49:	89 c7                	mov    %eax,%edi
  801b4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b4f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801b55:	48 89 c1             	mov    %rax,%rcx
  801b58:	89 da                	mov    %ebx,%edx
  801b5a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b5f:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  801b66:	00 00 00 
  801b69:	ff d0                	callq  *%rax
  801b6b:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801b6e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b72:	79 2a                	jns    801b9e <pgfault+0x16b>
                panic("page mapping failed in copy-on-write faulting page");
  801b74:	48 ba 78 28 80 00 00 	movabs $0x802878,%rdx
  801b7b:	00 00 00 
  801b7e:	be 38 00 00 00       	mov    $0x38,%esi
  801b83:	48 bf 2e 28 80 00 00 	movabs $0x80282e,%rdi
  801b8a:	00 00 00 
  801b8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b92:	48 b9 f8 20 80 00 00 	movabs $0x8020f8,%rcx
  801b99:	00 00 00 
  801b9c:	ff d1                	callq  *%rcx
        }

	//delete temporary location
	result = sys_page_unmap(sys_getenvid(), PFTEMP);
  801b9e:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  801ba5:	00 00 00 
  801ba8:	ff d0                	callq  *%rax
  801baa:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801baf:	89 c7                	mov    %eax,%edi
  801bb1:	48 b8 b1 18 80 00 00 	movabs $0x8018b1,%rax
  801bb8:	00 00 00 
  801bbb:	ff d0                	callq  *%rax
  801bbd:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801bc0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bc4:	79 2a                	jns    801bf0 <pgfault+0x1bd>
                panic("temporary page unmapping failed in copy-on-write faulting page");
  801bc6:	48 ba b0 28 80 00 00 	movabs $0x8028b0,%rdx
  801bcd:	00 00 00 
  801bd0:	be 3e 00 00 00       	mov    $0x3e,%esi
  801bd5:	48 bf 2e 28 80 00 00 	movabs $0x80282e,%rdi
  801bdc:	00 00 00 
  801bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801be4:	48 b9 f8 20 80 00 00 	movabs $0x8020f8,%rcx
  801beb:	00 00 00 
  801bee:	ff d1                	callq  *%rcx
        }	

	//panic("pgfault not implemented");

}
  801bf0:	90                   	nop
  801bf1:	48 83 c4 38          	add    $0x38,%rsp
  801bf5:	5b                   	pop    %rbx
  801bf6:	5d                   	pop    %rbp
  801bf7:	c3                   	retq   

0000000000801bf8 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801bf8:	55                   	push   %rbp
  801bf9:	48 89 e5             	mov    %rsp,%rbp
  801bfc:	53                   	push   %rbx
  801bfd:	48 83 ec 28          	sub    $0x28,%rsp
  801c01:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801c04:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uint64_t)pn*PGSIZE);	
  801c07:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801c0a:	48 c1 e0 0c          	shl    $0xc,%rax
  801c0e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result;

	//COW or writable
	if ((uvpt[pn]&PTE_COW) || (uvpt[pn]&PTE_W)){
  801c12:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c19:	01 00 00 
  801c1c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801c1f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c23:	25 00 08 00 00       	and    $0x800,%eax
  801c28:	48 85 c0             	test   %rax,%rax
  801c2b:	75 1d                	jne    801c4a <duppage+0x52>
  801c2d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c34:	01 00 00 
  801c37:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801c3a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c3e:	83 e0 02             	and    $0x2,%eax
  801c41:	48 85 c0             	test   %rax,%rax
  801c44:	0f 84 8f 00 00 00    	je     801cd9 <duppage+0xe1>
		//map to child
		result = sys_page_map(sys_getenvid(), addr, envid, addr, PTE_COW|PTE_U|PTE_P);
  801c4a:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  801c51:	00 00 00 
  801c54:	ff d0                	callq  *%rax
  801c56:	89 c7                	mov    %eax,%edi
  801c58:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c5c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801c5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c63:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801c69:	48 89 c6             	mov    %rax,%rsi
  801c6c:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  801c73:	00 00 00 
  801c76:	ff d0                	callq  *%rax
  801c78:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (result<0){
  801c7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801c7f:	79 0a                	jns    801c8b <duppage+0x93>
			return -1;
  801c81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c86:	e9 91 00 00 00       	jmpq   801d1c <duppage+0x124>
		}

		//remap page with proper permissions COW
		result = sys_page_map(sys_getenvid(), addr, sys_getenvid(), addr, PTE_COW|PTE_U|PTE_P);
  801c8b:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  801c92:	00 00 00 
  801c95:	ff d0                	callq  *%rax
  801c97:	89 c3                	mov    %eax,%ebx
  801c99:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  801ca0:	00 00 00 
  801ca3:	ff d0                	callq  *%rax
  801ca5:	89 c7                	mov    %eax,%edi
  801ca7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801cab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801caf:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801cb5:	48 89 d1             	mov    %rdx,%rcx
  801cb8:	89 da                	mov    %ebx,%edx
  801cba:	48 89 c6             	mov    %rax,%rsi
  801cbd:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  801cc4:	00 00 00 
  801cc7:	ff d0                	callq  *%rax
  801cc9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (result<0){
  801ccc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801cd0:	79 45                	jns    801d17 <duppage+0x11f>
                        return -1;
  801cd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801cd7:	eb 43                	jmp    801d1c <duppage+0x124>
                } 	
	//not proper permissions
	}else{
		result=sys_page_map(sys_getenvid(), addr, envid, addr, PTE_P|PTE_U);
  801cd9:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  801ce0:	00 00 00 
  801ce3:	ff d0                	callq  *%rax
  801ce5:	89 c7                	mov    %eax,%edi
  801ce7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ceb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801cee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cf2:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  801cf8:	48 89 c6             	mov    %rax,%rsi
  801cfb:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  801d02:	00 00 00 
  801d05:	ff d0                	callq  *%rax
  801d07:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (result<0){
  801d0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801d0e:	79 07                	jns    801d17 <duppage+0x11f>
			return -1;
  801d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801d15:	eb 05                	jmp    801d1c <duppage+0x124>
		}
	}

	//panic("duppage not implemented");
	return 0;
  801d17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1c:	48 83 c4 28          	add    $0x28,%rsp
  801d20:	5b                   	pop    %rbx
  801d21:	5d                   	pop    %rbp
  801d22:	c3                   	retq   

0000000000801d23 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801d23:	55                   	push   %rbp
  801d24:	48 89 e5             	mov    %rsp,%rbp
  801d27:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	//LOOKED AT DUMBFORK FOR HELP :)	


	//step 1 
	set_pgfault_handler(pgfault);
  801d2b:	48 bf 33 1a 80 00 00 	movabs $0x801a33,%rdi
  801d32:	00 00 00 
  801d35:	48 b8 0c 22 80 00 00 	movabs $0x80220c,%rax
  801d3c:	00 00 00 
  801d3f:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801d41:	b8 07 00 00 00       	mov    $0x7,%eax
  801d46:	cd 30                	int    $0x30
  801d48:	89 45 e8             	mov    %eax,-0x18(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801d4b:	8b 45 e8             	mov    -0x18(%rbp),%eax
	
	//step 2
	envid_t child = sys_exofork();
  801d4e:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (child==0){
  801d51:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801d55:	75 46                	jne    801d9d <fork+0x7a>
		//fix env in child
		thisenv = &envs[ENVX(sys_getenvid())];
  801d57:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  801d5e:	00 00 00 
  801d61:	ff d0                	callq  *%rax
  801d63:	25 ff 03 00 00       	and    $0x3ff,%eax
  801d68:	48 63 d0             	movslq %eax,%rdx
  801d6b:	48 89 d0             	mov    %rdx,%rax
  801d6e:	48 c1 e0 03          	shl    $0x3,%rax
  801d72:	48 01 d0             	add    %rdx,%rax
  801d75:	48 c1 e0 05          	shl    $0x5,%rax
  801d79:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801d80:	00 00 00 
  801d83:	48 01 c2             	add    %rax,%rdx
  801d86:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  801d8d:	00 00 00 
  801d90:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801d93:	b8 00 00 00 00       	mov    $0x0,%eax
  801d98:	e9 2b 03 00 00       	jmpq   8020c8 <fork+0x3a5>
	}
	if(child<0){
  801d9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801da1:	79 0a                	jns    801dad <fork+0x8a>
		return -1; //exofork failed
  801da3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801da8:	e9 1b 03 00 00       	jmpq   8020c8 <fork+0x3a5>

//For each writable or copy-on-write page in its address space below UTOP, the parent calls duppage, which should map the page copy-on-write into the address space of the child and then remap the page copy-on-write in its own address space. duppage sets both PTEs so that the page is not writeable, and to contain PTE_COW in the "avail" field to distinguish copy-on-write pages from genuine read-only pages.

	uintptr_t addr;
	extern unsigned char end[];
	for (addr = (uintptr_t)UTEXT; addr < (uintptr_t)end; addr += PGSIZE){//taken from dumbfork
  801dad:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  801db4:	00 
  801db5:	e9 ec 00 00 00       	jmpq   801ea6 <fork+0x183>
		
		//check if page is copy on write
		int perms = (uvpml4e[VPML4E(addr)] & PTE_P);
  801dba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dbe:	48 c1 e8 27          	shr    $0x27,%rax
  801dc2:	48 89 c2             	mov    %rax,%rdx
  801dc5:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801dcc:	01 00 00 
  801dcf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd3:	83 e0 01             	and    $0x1,%eax
  801dd6:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpde[VPDPE(addr)] & PTE_P);
  801dd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801ddd:	74 28                	je     801e07 <fork+0xe4>
  801ddf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801de3:	48 c1 e8 1e          	shr    $0x1e,%rax
  801de7:	48 89 c2             	mov    %rax,%rdx
  801dea:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801df1:	01 00 00 
  801df4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801df8:	83 e0 01             	and    $0x1,%eax
  801dfb:	48 85 c0             	test   %rax,%rax
  801dfe:	74 07                	je     801e07 <fork+0xe4>
  801e00:	b8 01 00 00 00       	mov    $0x1,%eax
  801e05:	eb 05                	jmp    801e0c <fork+0xe9>
  801e07:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpd[VPD(addr)] & PTE_P);		
  801e0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801e13:	74 28                	je     801e3d <fork+0x11a>
  801e15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e19:	48 c1 e8 15          	shr    $0x15,%rax
  801e1d:	48 89 c2             	mov    %rax,%rdx
  801e20:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e27:	01 00 00 
  801e2a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e2e:	83 e0 01             	and    $0x1,%eax
  801e31:	48 85 c0             	test   %rax,%rax
  801e34:	74 07                	je     801e3d <fork+0x11a>
  801e36:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3b:	eb 05                	jmp    801e42 <fork+0x11f>
  801e3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e42:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpt[PGNUM(addr)] & (PTE_P | PTE_U));
  801e45:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801e49:	74 28                	je     801e73 <fork+0x150>
  801e4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e4f:	48 c1 e8 0c          	shr    $0xc,%rax
  801e53:	48 89 c2             	mov    %rax,%rdx
  801e56:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e5d:	01 00 00 
  801e60:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e64:	83 e0 05             	and    $0x5,%eax
  801e67:	48 85 c0             	test   %rax,%rax
  801e6a:	74 07                	je     801e73 <fork+0x150>
  801e6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e71:	eb 05                	jmp    801e78 <fork+0x155>
  801e73:	b8 00 00 00 00       	mov    $0x0,%eax
  801e78:	89 45 f0             	mov    %eax,-0x10(%rbp)

		if (perms){
  801e7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801e7f:	74 1d                	je     801e9e <fork+0x17b>
			duppage(child, PGNUM(addr));
  801e81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e85:	48 c1 e8 0c          	shr    $0xc,%rax
  801e89:	89 c2                	mov    %eax,%edx
  801e8b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e8e:	89 d6                	mov    %edx,%esi
  801e90:	89 c7                	mov    %eax,%edi
  801e92:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  801e99:	00 00 00 
  801e9c:	ff d0                	callq  *%rax

//For each writable or copy-on-write page in its address space below UTOP, the parent calls duppage, which should map the page copy-on-write into the address space of the child and then remap the page copy-on-write in its own address space. duppage sets both PTEs so that the page is not writeable, and to contain PTE_COW in the "avail" field to distinguish copy-on-write pages from genuine read-only pages.

	uintptr_t addr;
	extern unsigned char end[];
	for (addr = (uintptr_t)UTEXT; addr < (uintptr_t)end; addr += PGSIZE){//taken from dumbfork
  801e9e:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  801ea5:	00 
  801ea6:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  801ead:	00 00 00 
  801eb0:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  801eb4:	0f 82 00 ff ff ff    	jb     801dba <fork+0x97>
//The exception stack is not remapped this way, however. Instead you need to allocate a fresh page in the child for the exception stack. Since the page fault handler will be doing the actual copying and the page fault handler runs on the exception stack, the exception stack cannot be made copy-on-write: who would copy it?

	int result;

        //allocate new page & map it
        result = sys_page_alloc(sys_getenvid(), PFTEMP, PTE_P|PTE_U|PTE_W);
  801eba:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  801ec1:	00 00 00 
  801ec4:	ff d0                	callq  *%rax
  801ec6:	ba 07 00 00 00       	mov    $0x7,%edx
  801ecb:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ed0:	89 c7                	mov    %eax,%edi
  801ed2:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  801ed9:	00 00 00 
  801edc:	ff d0                	callq  *%rax
  801ede:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  801ee1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ee5:	79 2a                	jns    801f11 <fork+0x1ee>
                panic("page allocation failed in fork");
  801ee7:	48 ba f0 28 80 00 00 	movabs $0x8028f0,%rdx
  801eee:	00 00 00 
  801ef1:	be b0 00 00 00       	mov    $0xb0,%esi
  801ef6:	48 bf 2e 28 80 00 00 	movabs $0x80282e,%rdi
  801efd:	00 00 00 
  801f00:	b8 00 00 00 00       	mov    $0x0,%eax
  801f05:	48 b9 f8 20 80 00 00 	movabs $0x8020f8,%rcx
  801f0c:	00 00 00 
  801f0f:	ff d1                	callq  *%rcx
        }

        //copy page
        memcpy(PFTEMP, (void *)(USTACKTOP-PGSIZE), PGSIZE);
  801f11:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f16:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801f1b:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f20:	48 b8 05 13 80 00 00 	movabs $0x801305,%rax
  801f27:	00 00 00 
  801f2a:	ff d0                	callq  *%rax

        //map new page into original page's space
        result = sys_page_map(sys_getenvid(), PFTEMP, child,(void *)(USTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  801f2c:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  801f33:	00 00 00 
  801f36:	ff d0                	callq  *%rax
  801f38:	89 c7                	mov    %eax,%edi
  801f3a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f3d:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f43:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  801f48:	89 c2                	mov    %eax,%edx
  801f4a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f4f:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  801f56:	00 00 00 
  801f59:	ff d0                	callq  *%rax
  801f5b:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  801f5e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f62:	79 2a                	jns    801f8e <fork+0x26b>
                panic("page mapping failed in fork");
  801f64:	48 ba 0f 29 80 00 00 	movabs $0x80290f,%rdx
  801f6b:	00 00 00 
  801f6e:	be b9 00 00 00       	mov    $0xb9,%esi
  801f73:	48 bf 2e 28 80 00 00 	movabs $0x80282e,%rdi
  801f7a:	00 00 00 
  801f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f82:	48 b9 f8 20 80 00 00 	movabs $0x8020f8,%rcx
  801f89:	00 00 00 
  801f8c:	ff d1                	callq  *%rcx
        }

        //delete temporary location
        result = sys_page_unmap(sys_getenvid(), PFTEMP);
  801f8e:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  801f95:	00 00 00 
  801f98:	ff d0                	callq  *%rax
  801f9a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f9f:	89 c7                	mov    %eax,%edi
  801fa1:	48 b8 b1 18 80 00 00 	movabs $0x8018b1,%rax
  801fa8:	00 00 00 
  801fab:	ff d0                	callq  *%rax
  801fad:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  801fb0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fb4:	79 2a                	jns    801fe0 <fork+0x2bd>
                panic("temporary page unmapping failed in copy-on-write faulting page");
  801fb6:	48 ba b0 28 80 00 00 	movabs $0x8028b0,%rdx
  801fbd:	00 00 00 
  801fc0:	be bf 00 00 00       	mov    $0xbf,%esi
  801fc5:	48 bf 2e 28 80 00 00 	movabs $0x80282e,%rdi
  801fcc:	00 00 00 
  801fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd4:	48 b9 f8 20 80 00 00 	movabs $0x8020f8,%rcx
  801fdb:	00 00 00 
  801fde:	ff d1                	callq  *%rcx
        }
// STEP 4
//The parent sets the user page fault entrypoint for the child to look like its own.

	result=sys_page_alloc(child, (void*)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W);
  801fe0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fe3:	ba 07 00 00 00       	mov    $0x7,%edx
  801fe8:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801fed:	89 c7                	mov    %eax,%edi
  801fef:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  801ff6:	00 00 00 
  801ff9:	ff d0                	callq  *%rax
  801ffb:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  801ffe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802002:	79 2a                	jns    80202e <fork+0x30b>
		panic("page alloc of table failed in fork");
  802004:	48 ba 30 29 80 00 00 	movabs $0x802930,%rdx
  80200b:	00 00 00 
  80200e:	be c6 00 00 00       	mov    $0xc6,%esi
  802013:	48 bf 2e 28 80 00 00 	movabs $0x80282e,%rdi
  80201a:	00 00 00 
  80201d:	b8 00 00 00 00       	mov    $0x0,%eax
  802022:	48 b9 f8 20 80 00 00 	movabs $0x8020f8,%rcx
  802029:	00 00 00 
  80202c:	ff d1                	callq  *%rcx
	}

	extern void _pgfault_upcall();
	result = sys_env_set_pgfault_upcall(child, _pgfault_upcall);
  80202e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802031:	48 be f0 22 80 00 00 	movabs $0x8022f0,%rsi
  802038:	00 00 00 
  80203b:	89 c7                	mov    %eax,%edi
  80203d:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  802044:	00 00 00 
  802047:	ff d0                	callq  *%rax
  802049:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  80204c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802050:	79 2a                	jns    80207c <fork+0x359>
		panic("setting upcall failed in fork"); 
  802052:	48 ba 53 29 80 00 00 	movabs $0x802953,%rdx
  802059:	00 00 00 
  80205c:	be cc 00 00 00       	mov    $0xcc,%esi
  802061:	48 bf 2e 28 80 00 00 	movabs $0x80282e,%rdi
  802068:	00 00 00 
  80206b:	b8 00 00 00 00       	mov    $0x0,%eax
  802070:	48 b9 f8 20 80 00 00 	movabs $0x8020f8,%rcx
  802077:	00 00 00 
  80207a:	ff d1                	callq  *%rcx
	}
// STEP 5
//The child is now ready to run, so the parent marks it runnable.

	result = sys_env_set_status(child, ENV_RUNNABLE);
  80207c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80207f:	be 02 00 00 00       	mov    $0x2,%esi
  802084:	89 c7                	mov    %eax,%edi
  802086:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  80208d:	00 00 00 
  802090:	ff d0                	callq  *%rax
  802092:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  802095:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802099:	79 2a                	jns    8020c5 <fork+0x3a2>
		panic("changing statys is fork failed");
  80209b:	48 ba 78 29 80 00 00 	movabs $0x802978,%rdx
  8020a2:	00 00 00 
  8020a5:	be d3 00 00 00       	mov    $0xd3,%esi
  8020aa:	48 bf 2e 28 80 00 00 	movabs $0x80282e,%rdi
  8020b1:	00 00 00 
  8020b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b9:	48 b9 f8 20 80 00 00 	movabs $0x8020f8,%rcx
  8020c0:	00 00 00 
  8020c3:	ff d1                	callq  *%rcx
	}
	
	return child;
  8020c5:	8b 45 f4             	mov    -0xc(%rbp),%eax

}
  8020c8:	c9                   	leaveq 
  8020c9:	c3                   	retq   

00000000008020ca <sfork>:

// Challenge!
int
sfork(void)
{
  8020ca:	55                   	push   %rbp
  8020cb:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8020ce:	48 ba 97 29 80 00 00 	movabs $0x802997,%rdx
  8020d5:	00 00 00 
  8020d8:	be de 00 00 00       	mov    $0xde,%esi
  8020dd:	48 bf 2e 28 80 00 00 	movabs $0x80282e,%rdi
  8020e4:	00 00 00 
  8020e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ec:	48 b9 f8 20 80 00 00 	movabs $0x8020f8,%rcx
  8020f3:	00 00 00 
  8020f6:	ff d1                	callq  *%rcx

00000000008020f8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8020f8:	55                   	push   %rbp
  8020f9:	48 89 e5             	mov    %rsp,%rbp
  8020fc:	53                   	push   %rbx
  8020fd:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802104:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80210b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802111:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  802118:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80211f:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802126:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80212d:	84 c0                	test   %al,%al
  80212f:	74 23                	je     802154 <_panic+0x5c>
  802131:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802138:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80213c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802140:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802144:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802148:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80214c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802150:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802154:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80215b:	00 00 00 
  80215e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802165:	00 00 00 
  802168:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80216c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802173:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80217a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802181:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802188:	00 00 00 
  80218b:	48 8b 18             	mov    (%rax),%rbx
  80218e:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  802195:	00 00 00 
  802198:	ff d0                	callq  *%rax
  80219a:	89 c6                	mov    %eax,%esi
  80219c:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8021a2:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8021a9:	41 89 d0             	mov    %edx,%r8d
  8021ac:	48 89 c1             	mov    %rax,%rcx
  8021af:	48 89 da             	mov    %rbx,%rdx
  8021b2:	48 bf b0 29 80 00 00 	movabs $0x8029b0,%rdi
  8021b9:	00 00 00 
  8021bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c1:	49 b9 39 03 80 00 00 	movabs $0x800339,%r9
  8021c8:	00 00 00 
  8021cb:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021ce:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8021d5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8021dc:	48 89 d6             	mov    %rdx,%rsi
  8021df:	48 89 c7             	mov    %rax,%rdi
  8021e2:	48 b8 8d 02 80 00 00 	movabs $0x80028d,%rax
  8021e9:	00 00 00 
  8021ec:	ff d0                	callq  *%rax
	cprintf("\n");
  8021ee:	48 bf d3 29 80 00 00 	movabs $0x8029d3,%rdi
  8021f5:	00 00 00 
  8021f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fd:	48 ba 39 03 80 00 00 	movabs $0x800339,%rdx
  802204:	00 00 00 
  802207:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802209:	cc                   	int3   
  80220a:	eb fd                	jmp    802209 <_panic+0x111>

000000000080220c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80220c:	55                   	push   %rbp
  80220d:	48 89 e5             	mov    %rsp,%rbp
  802210:	48 83 ec 20          	sub    $0x20,%rsp
  802214:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler==0) {
  802218:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80221f:	00 00 00 
  802222:	48 8b 00             	mov    (%rax),%rax
  802225:	48 85 c0             	test   %rax,%rax
  802228:	0f 85 ae 00 00 00    	jne    8022dc <set_pgfault_handler+0xd0>
		//allocate space
		int result = sys_page_alloc(sys_getenvid(), (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  80222e:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  802235:	00 00 00 
  802238:	ff d0                	callq  *%rax
  80223a:	ba 07 00 00 00       	mov    $0x7,%edx
  80223f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802244:	89 c7                	mov    %eax,%edi
  802246:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  80224d:	00 00 00 
  802250:	ff d0                	callq  *%rax
  802252:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  802255:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802259:	79 2a                	jns    802285 <set_pgfault_handler+0x79>
			panic("sys_page_alloc for stack failed in setting page fault handler");
  80225b:	48 ba d8 29 80 00 00 	movabs $0x8029d8,%rdx
  802262:	00 00 00 
  802265:	be 21 00 00 00       	mov    $0x21,%esi
  80226a:	48 bf 16 2a 80 00 00 	movabs $0x802a16,%rdi
  802271:	00 00 00 
  802274:	b8 00 00 00 00       	mov    $0x0,%eax
  802279:	48 b9 f8 20 80 00 00 	movabs $0x8020f8,%rcx
  802280:	00 00 00 
  802283:	ff d1                	callq  *%rcx
		}

		//actual set upcall
		result = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  802285:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  80228c:	00 00 00 
  80228f:	ff d0                	callq  *%rax
  802291:	48 be f0 22 80 00 00 	movabs $0x8022f0,%rsi
  802298:	00 00 00 
  80229b:	89 c7                	mov    %eax,%edi
  80229d:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  8022a4:	00 00 00 
  8022a7:	ff d0                	callq  *%rax
  8022a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  8022ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b0:	79 2a                	jns    8022dc <set_pgfault_handler+0xd0>
                        panic("setting upcall failed in setting page fault handler");
  8022b2:	48 ba 28 2a 80 00 00 	movabs $0x802a28,%rdx
  8022b9:	00 00 00 
  8022bc:	be 27 00 00 00       	mov    $0x27,%esi
  8022c1:	48 bf 16 2a 80 00 00 	movabs $0x802a16,%rdi
  8022c8:	00 00 00 
  8022cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d0:	48 b9 f8 20 80 00 00 	movabs $0x8020f8,%rcx
  8022d7:	00 00 00 
  8022da:	ff d1                	callq  *%rcx
                }
		//panic("set_pgfault_handler not implemented");
	}

	_pgfault_handler = handler;
  8022dc:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  8022e3:	00 00 00 
  8022e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022ea:	48 89 10             	mov    %rdx,(%rax)

}
  8022ed:	90                   	nop
  8022ee:	c9                   	leaveq 
  8022ef:	c3                   	retq   

00000000008022f0 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8022f0:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8022f3:	48 a1 10 40 80 00 00 	movabs 0x804010,%rax
  8022fa:	00 00 00 
call *%rax
  8022fd:	ff d0                	callq  *%rax
	//MAKE STACK CALCS for getting parameters
	//20 = size of stack
	//8 = size of word	

	//(20-3)*8=17*8=136
	movq 136(%rsp), %rax
  8022ff:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  802306:	00 
	//(20-1)*8=152
	subq $8, 152(%rsp)
  802307:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  80230e:	00 08 
	movq 152(%rsp), %rbx
  802310:	48 8b 9c 24 98 00 00 	mov    0x98(%rsp),%rbx
  802317:	00 
	movq %rax, (%rbx)
  802318:	48 89 03             	mov    %rax,(%rbx)
	addq $16, %rsp
  80231b:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
	
    	POPA_
  80231f:	4c 8b 3c 24          	mov    (%rsp),%r15
  802323:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802328:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80232d:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802332:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802337:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80233c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802341:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802346:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80234b:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802350:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802355:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80235a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80235f:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802364:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802369:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
	//https://www.felixcloutier.com/x86/POPF:POPFD:POPFQ.html
    	addq $8, %rsp
  80236d:	48 83 c4 08          	add    $0x8,%rsp
    	popfq	
  802371:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    	popq %rsp
  802372:	5c                   	pop    %rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    	ret
  802373:	c3                   	retq   
