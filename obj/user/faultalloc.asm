
obj/user/faultalloc:     file format elf64-x86-64


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
  80003c:	e8 41 01 00 00       	callq  800182 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
  80004b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80004f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800053:	48 8b 00             	mov    (%rax),%rax
  800056:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	cprintf("fault %x\n", addr);
  80005a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80005e:	48 89 c6             	mov    %rax,%rsi
  800061:	48 bf e0 1c 80 00 00 	movabs $0x801ce0,%rdi
  800068:	00 00 00 
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
  800070:	48 ba 60 04 80 00 00 	movabs $0x800460,%rdx
  800077:	00 00 00 
  80007a:	ff d2                	callq  *%rdx
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80007c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800080:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800088:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80008e:	ba 07 00 00 00       	mov    $0x7,%edx
  800093:	48 89 c6             	mov    %rax,%rsi
  800096:	bf 00 00 00 00       	mov    $0x0,%edi
  80009b:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8000aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000ae:	79 38                	jns    8000e8 <handler+0xa5>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  8000b0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8000b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000b7:	41 89 d0             	mov    %edx,%r8d
  8000ba:	48 89 c1             	mov    %rax,%rcx
  8000bd:	48 ba f0 1c 80 00 00 	movabs $0x801cf0,%rdx
  8000c4:	00 00 00 
  8000c7:	be 0e 00 00 00       	mov    $0xe,%esi
  8000cc:	48 bf 1b 1d 80 00 00 	movabs $0x801d1b,%rdi
  8000d3:	00 00 00 
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	49 b9 26 02 80 00 00 	movabs $0x800226,%r9
  8000e2:	00 00 00 
  8000e5:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	48 89 d1             	mov    %rdx,%rcx
  8000f3:	48 ba 30 1d 80 00 00 	movabs $0x801d30,%rdx
  8000fa:	00 00 00 
  8000fd:	be 64 00 00 00       	mov    $0x64,%esi
  800102:	48 89 c7             	mov    %rax,%rdi
  800105:	b8 00 00 00 00       	mov    $0x0,%eax
  80010a:	49 b8 a3 0e 80 00 00 	movabs $0x800ea3,%r8
  800111:	00 00 00 
  800114:	41 ff d0             	callq  *%r8
}
  800117:	90                   	nop
  800118:	c9                   	leaveq 
  800119:	c3                   	retq   

000000000080011a <umain>:

void
umain(int argc, char **argv)
{
  80011a:	55                   	push   %rbp
  80011b:	48 89 e5             	mov    %rsp,%rbp
  80011e:	48 83 ec 10          	sub    $0x10,%rsp
  800122:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800125:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(handler);
  800129:	48 bf 43 00 80 00 00 	movabs $0x800043,%rdi
  800130:	00 00 00 
  800133:	48 b8 5a 1b 80 00 00 	movabs $0x801b5a,%rax
  80013a:	00 00 00 
  80013d:	ff d0                	callq  *%rax
	cprintf("%s\n", (char*)0xDeadBeef);
  80013f:	be ef be ad de       	mov    $0xdeadbeef,%esi
  800144:	48 bf 51 1d 80 00 00 	movabs $0x801d51,%rdi
  80014b:	00 00 00 
  80014e:	b8 00 00 00 00       	mov    $0x0,%eax
  800153:	48 ba 60 04 80 00 00 	movabs $0x800460,%rdx
  80015a:	00 00 00 
  80015d:	ff d2                	callq  *%rdx
	cprintf("%s\n", (char*)0xCafeBffe);
  80015f:	be fe bf fe ca       	mov    $0xcafebffe,%esi
  800164:	48 bf 51 1d 80 00 00 	movabs $0x801d51,%rdi
  80016b:	00 00 00 
  80016e:	b8 00 00 00 00       	mov    $0x0,%eax
  800173:	48 ba 60 04 80 00 00 	movabs $0x800460,%rdx
  80017a:	00 00 00 
  80017d:	ff d2                	callq  *%rdx
}
  80017f:	90                   	nop
  800180:	c9                   	leaveq 
  800181:	c3                   	retq   

0000000000800182 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800182:	55                   	push   %rbp
  800183:	48 89 e5             	mov    %rsp,%rbp
  800186:	48 83 ec 10          	sub    $0x10,%rsp
  80018a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80018d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  800191:	48 b8 ad 18 80 00 00 	movabs $0x8018ad,%rax
  800198:	00 00 00 
  80019b:	ff d0                	callq  *%rax
  80019d:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001a2:	48 63 d0             	movslq %eax,%rdx
  8001a5:	48 89 d0             	mov    %rdx,%rax
  8001a8:	48 c1 e0 03          	shl    $0x3,%rax
  8001ac:	48 01 d0             	add    %rdx,%rax
  8001af:	48 c1 e0 05          	shl    $0x5,%rax
  8001b3:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001ba:	00 00 00 
  8001bd:	48 01 c2             	add    %rax,%rdx
  8001c0:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8001c7:	00 00 00 
  8001ca:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d1:	7e 14                	jle    8001e7 <libmain+0x65>
		binaryname = argv[0];
  8001d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001d7:	48 8b 10             	mov    (%rax),%rdx
  8001da:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8001e1:	00 00 00 
  8001e4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001ee:	48 89 d6             	mov    %rdx,%rsi
  8001f1:	89 c7                	mov    %eax,%edi
  8001f3:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  8001fa:	00 00 00 
  8001fd:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001ff:	48 b8 0e 02 80 00 00 	movabs $0x80020e,%rax
  800206:	00 00 00 
  800209:	ff d0                	callq  *%rax
}
  80020b:	90                   	nop
  80020c:	c9                   	leaveq 
  80020d:	c3                   	retq   

000000000080020e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80020e:	55                   	push   %rbp
  80020f:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800212:	bf 00 00 00 00       	mov    $0x0,%edi
  800217:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  80021e:	00 00 00 
  800221:	ff d0                	callq  *%rax
}
  800223:	90                   	nop
  800224:	5d                   	pop    %rbp
  800225:	c3                   	retq   

0000000000800226 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800226:	55                   	push   %rbp
  800227:	48 89 e5             	mov    %rsp,%rbp
  80022a:	53                   	push   %rbx
  80022b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800232:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800239:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80023f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800246:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80024d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800254:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80025b:	84 c0                	test   %al,%al
  80025d:	74 23                	je     800282 <_panic+0x5c>
  80025f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800266:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80026a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80026e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800272:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800276:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80027a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80027e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800282:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800289:	00 00 00 
  80028c:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800293:	00 00 00 
  800296:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80029a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002a1:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002a8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002af:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8002b6:	00 00 00 
  8002b9:	48 8b 18             	mov    (%rax),%rbx
  8002bc:	48 b8 ad 18 80 00 00 	movabs $0x8018ad,%rax
  8002c3:	00 00 00 
  8002c6:	ff d0                	callq  *%rax
  8002c8:	89 c6                	mov    %eax,%esi
  8002ca:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8002d0:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8002d7:	41 89 d0             	mov    %edx,%r8d
  8002da:	48 89 c1             	mov    %rax,%rcx
  8002dd:	48 89 da             	mov    %rbx,%rdx
  8002e0:	48 bf 60 1d 80 00 00 	movabs $0x801d60,%rdi
  8002e7:	00 00 00 
  8002ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ef:	49 b9 60 04 80 00 00 	movabs $0x800460,%r9
  8002f6:	00 00 00 
  8002f9:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002fc:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800303:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80030a:	48 89 d6             	mov    %rdx,%rsi
  80030d:	48 89 c7             	mov    %rax,%rdi
  800310:	48 b8 b4 03 80 00 00 	movabs $0x8003b4,%rax
  800317:	00 00 00 
  80031a:	ff d0                	callq  *%rax
	cprintf("\n");
  80031c:	48 bf 83 1d 80 00 00 	movabs $0x801d83,%rdi
  800323:	00 00 00 
  800326:	b8 00 00 00 00       	mov    $0x0,%eax
  80032b:	48 ba 60 04 80 00 00 	movabs $0x800460,%rdx
  800332:	00 00 00 
  800335:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800337:	cc                   	int3   
  800338:	eb fd                	jmp    800337 <_panic+0x111>

000000000080033a <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80033a:	55                   	push   %rbp
  80033b:	48 89 e5             	mov    %rsp,%rbp
  80033e:	48 83 ec 10          	sub    $0x10,%rsp
  800342:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800345:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800349:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80034d:	8b 00                	mov    (%rax),%eax
  80034f:	8d 48 01             	lea    0x1(%rax),%ecx
  800352:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800356:	89 0a                	mov    %ecx,(%rdx)
  800358:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80035b:	89 d1                	mov    %edx,%ecx
  80035d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800361:	48 98                	cltq   
  800363:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80036b:	8b 00                	mov    (%rax),%eax
  80036d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800372:	75 2c                	jne    8003a0 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800374:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800378:	8b 00                	mov    (%rax),%eax
  80037a:	48 98                	cltq   
  80037c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800380:	48 83 c2 08          	add    $0x8,%rdx
  800384:	48 89 c6             	mov    %rax,%rsi
  800387:	48 89 d7             	mov    %rdx,%rdi
  80038a:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  800391:	00 00 00 
  800394:	ff d0                	callq  *%rax
        b->idx = 0;
  800396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80039a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a4:	8b 40 04             	mov    0x4(%rax),%eax
  8003a7:	8d 50 01             	lea    0x1(%rax),%edx
  8003aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ae:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003b1:	90                   	nop
  8003b2:	c9                   	leaveq 
  8003b3:	c3                   	retq   

00000000008003b4 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003b4:	55                   	push   %rbp
  8003b5:	48 89 e5             	mov    %rsp,%rbp
  8003b8:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003bf:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003c6:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003cd:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003d4:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003db:	48 8b 0a             	mov    (%rdx),%rcx
  8003de:	48 89 08             	mov    %rcx,(%rax)
  8003e1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003e5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003e9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003ed:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8003f1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8003f8:	00 00 00 
    b.cnt = 0;
  8003fb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800402:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800405:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80040c:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800413:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80041a:	48 89 c6             	mov    %rax,%rsi
  80041d:	48 bf 3a 03 80 00 00 	movabs $0x80033a,%rdi
  800424:	00 00 00 
  800427:	48 b8 fe 07 80 00 00 	movabs $0x8007fe,%rax
  80042e:	00 00 00 
  800431:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800433:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800439:	48 98                	cltq   
  80043b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800442:	48 83 c2 08          	add    $0x8,%rdx
  800446:	48 89 c6             	mov    %rax,%rsi
  800449:	48 89 d7             	mov    %rdx,%rdi
  80044c:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  800453:	00 00 00 
  800456:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800458:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80045e:	c9                   	leaveq 
  80045f:	c3                   	retq   

0000000000800460 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800460:	55                   	push   %rbp
  800461:	48 89 e5             	mov    %rsp,%rbp
  800464:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80046b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800472:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800479:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800480:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800487:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80048e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800495:	84 c0                	test   %al,%al
  800497:	74 20                	je     8004b9 <cprintf+0x59>
  800499:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80049d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004a1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004a5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004a9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004ad:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004b1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004b5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004b9:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004c0:	00 00 00 
  8004c3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004ca:	00 00 00 
  8004cd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004d1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004d8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004df:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8004e6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004ed:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004f4:	48 8b 0a             	mov    (%rdx),%rcx
  8004f7:	48 89 08             	mov    %rcx,(%rax)
  8004fa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004fe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800502:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800506:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80050a:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800511:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800518:	48 89 d6             	mov    %rdx,%rsi
  80051b:	48 89 c7             	mov    %rax,%rdi
  80051e:	48 b8 b4 03 80 00 00 	movabs $0x8003b4,%rax
  800525:	00 00 00 
  800528:	ff d0                	callq  *%rax
  80052a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800530:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800536:	c9                   	leaveq 
  800537:	c3                   	retq   

0000000000800538 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800538:	55                   	push   %rbp
  800539:	48 89 e5             	mov    %rsp,%rbp
  80053c:	48 83 ec 30          	sub    $0x30,%rsp
  800540:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800544:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800548:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80054c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80054f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800553:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800557:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80055a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80055e:	77 54                	ja     8005b4 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800560:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800563:	8d 78 ff             	lea    -0x1(%rax),%edi
  800566:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800569:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056d:	ba 00 00 00 00       	mov    $0x0,%edx
  800572:	48 f7 f6             	div    %rsi
  800575:	49 89 c2             	mov    %rax,%r10
  800578:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80057b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80057e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800586:	41 89 c9             	mov    %ecx,%r9d
  800589:	41 89 f8             	mov    %edi,%r8d
  80058c:	89 d1                	mov    %edx,%ecx
  80058e:	4c 89 d2             	mov    %r10,%rdx
  800591:	48 89 c7             	mov    %rax,%rdi
  800594:	48 b8 38 05 80 00 00 	movabs $0x800538,%rax
  80059b:	00 00 00 
  80059e:	ff d0                	callq  *%rax
  8005a0:	eb 1c                	jmp    8005be <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005a2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8005a6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8005a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005ad:	48 89 ce             	mov    %rcx,%rsi
  8005b0:	89 d7                	mov    %edx,%edi
  8005b2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005b4:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8005b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8005bc:	7f e4                	jg     8005a2 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005be:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8005c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ca:	48 f7 f1             	div    %rcx
  8005cd:	48 b8 f0 1e 80 00 00 	movabs $0x801ef0,%rax
  8005d4:	00 00 00 
  8005d7:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8005db:	0f be d0             	movsbl %al,%edx
  8005de:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8005e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005e6:	48 89 ce             	mov    %rcx,%rsi
  8005e9:	89 d7                	mov    %edx,%edi
  8005eb:	ff d0                	callq  *%rax
}
  8005ed:	90                   	nop
  8005ee:	c9                   	leaveq 
  8005ef:	c3                   	retq   

00000000008005f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005f0:	55                   	push   %rbp
  8005f1:	48 89 e5             	mov    %rsp,%rbp
  8005f4:	48 83 ec 20          	sub    $0x20,%rsp
  8005f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005fc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8005ff:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800603:	7e 4f                	jle    800654 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800609:	8b 00                	mov    (%rax),%eax
  80060b:	83 f8 30             	cmp    $0x30,%eax
  80060e:	73 24                	jae    800634 <getuint+0x44>
  800610:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800614:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061c:	8b 00                	mov    (%rax),%eax
  80061e:	89 c0                	mov    %eax,%eax
  800620:	48 01 d0             	add    %rdx,%rax
  800623:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800627:	8b 12                	mov    (%rdx),%edx
  800629:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80062c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800630:	89 0a                	mov    %ecx,(%rdx)
  800632:	eb 14                	jmp    800648 <getuint+0x58>
  800634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800638:	48 8b 40 08          	mov    0x8(%rax),%rax
  80063c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800640:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800644:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800648:	48 8b 00             	mov    (%rax),%rax
  80064b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80064f:	e9 9d 00 00 00       	jmpq   8006f1 <getuint+0x101>
	else if (lflag)
  800654:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800658:	74 4c                	je     8006a6 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80065a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065e:	8b 00                	mov    (%rax),%eax
  800660:	83 f8 30             	cmp    $0x30,%eax
  800663:	73 24                	jae    800689 <getuint+0x99>
  800665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800669:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	8b 00                	mov    (%rax),%eax
  800673:	89 c0                	mov    %eax,%eax
  800675:	48 01 d0             	add    %rdx,%rax
  800678:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067c:	8b 12                	mov    (%rdx),%edx
  80067e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800681:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800685:	89 0a                	mov    %ecx,(%rdx)
  800687:	eb 14                	jmp    80069d <getuint+0xad>
  800689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800691:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800695:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800699:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80069d:	48 8b 00             	mov    (%rax),%rax
  8006a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006a4:	eb 4b                	jmp    8006f1 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8006a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006aa:	8b 00                	mov    (%rax),%eax
  8006ac:	83 f8 30             	cmp    $0x30,%eax
  8006af:	73 24                	jae    8006d5 <getuint+0xe5>
  8006b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bd:	8b 00                	mov    (%rax),%eax
  8006bf:	89 c0                	mov    %eax,%eax
  8006c1:	48 01 d0             	add    %rdx,%rax
  8006c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c8:	8b 12                	mov    (%rdx),%edx
  8006ca:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d1:	89 0a                	mov    %ecx,(%rdx)
  8006d3:	eb 14                	jmp    8006e9 <getuint+0xf9>
  8006d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006dd:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e9:	8b 00                	mov    (%rax),%eax
  8006eb:	89 c0                	mov    %eax,%eax
  8006ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006f5:	c9                   	leaveq 
  8006f6:	c3                   	retq   

00000000008006f7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006f7:	55                   	push   %rbp
  8006f8:	48 89 e5             	mov    %rsp,%rbp
  8006fb:	48 83 ec 20          	sub    $0x20,%rsp
  8006ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800703:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800706:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80070a:	7e 4f                	jle    80075b <getint+0x64>
		x=va_arg(*ap, long long);
  80070c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800710:	8b 00                	mov    (%rax),%eax
  800712:	83 f8 30             	cmp    $0x30,%eax
  800715:	73 24                	jae    80073b <getint+0x44>
  800717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80071f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800723:	8b 00                	mov    (%rax),%eax
  800725:	89 c0                	mov    %eax,%eax
  800727:	48 01 d0             	add    %rdx,%rax
  80072a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072e:	8b 12                	mov    (%rdx),%edx
  800730:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800733:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800737:	89 0a                	mov    %ecx,(%rdx)
  800739:	eb 14                	jmp    80074f <getint+0x58>
  80073b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800743:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800747:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80074f:	48 8b 00             	mov    (%rax),%rax
  800752:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800756:	e9 9d 00 00 00       	jmpq   8007f8 <getint+0x101>
	else if (lflag)
  80075b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80075f:	74 4c                	je     8007ad <getint+0xb6>
		x=va_arg(*ap, long);
  800761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800765:	8b 00                	mov    (%rax),%eax
  800767:	83 f8 30             	cmp    $0x30,%eax
  80076a:	73 24                	jae    800790 <getint+0x99>
  80076c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800770:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800774:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800778:	8b 00                	mov    (%rax),%eax
  80077a:	89 c0                	mov    %eax,%eax
  80077c:	48 01 d0             	add    %rdx,%rax
  80077f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800783:	8b 12                	mov    (%rdx),%edx
  800785:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800788:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078c:	89 0a                	mov    %ecx,(%rdx)
  80078e:	eb 14                	jmp    8007a4 <getint+0xad>
  800790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800794:	48 8b 40 08          	mov    0x8(%rax),%rax
  800798:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80079c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007a4:	48 8b 00             	mov    (%rax),%rax
  8007a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007ab:	eb 4b                	jmp    8007f8 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8007ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b1:	8b 00                	mov    (%rax),%eax
  8007b3:	83 f8 30             	cmp    $0x30,%eax
  8007b6:	73 24                	jae    8007dc <getint+0xe5>
  8007b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c4:	8b 00                	mov    (%rax),%eax
  8007c6:	89 c0                	mov    %eax,%eax
  8007c8:	48 01 d0             	add    %rdx,%rax
  8007cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cf:	8b 12                	mov    (%rdx),%edx
  8007d1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d8:	89 0a                	mov    %ecx,(%rdx)
  8007da:	eb 14                	jmp    8007f0 <getint+0xf9>
  8007dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007e4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ec:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f0:	8b 00                	mov    (%rax),%eax
  8007f2:	48 98                	cltq   
  8007f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007fc:	c9                   	leaveq 
  8007fd:	c3                   	retq   

00000000008007fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007fe:	55                   	push   %rbp
  8007ff:	48 89 e5             	mov    %rsp,%rbp
  800802:	41 54                	push   %r12
  800804:	53                   	push   %rbx
  800805:	48 83 ec 60          	sub    $0x60,%rsp
  800809:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80080d:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800811:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800815:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800819:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80081d:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800821:	48 8b 0a             	mov    (%rdx),%rcx
  800824:	48 89 08             	mov    %rcx,(%rax)
  800827:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80082b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80082f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800833:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800837:	eb 17                	jmp    800850 <vprintfmt+0x52>
			if (ch == '\0')
  800839:	85 db                	test   %ebx,%ebx
  80083b:	0f 84 b9 04 00 00    	je     800cfa <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800841:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800845:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800849:	48 89 d6             	mov    %rdx,%rsi
  80084c:	89 df                	mov    %ebx,%edi
  80084e:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800850:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800854:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800858:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80085c:	0f b6 00             	movzbl (%rax),%eax
  80085f:	0f b6 d8             	movzbl %al,%ebx
  800862:	83 fb 25             	cmp    $0x25,%ebx
  800865:	75 d2                	jne    800839 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800867:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80086b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800872:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800879:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800880:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800887:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80088b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80088f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800893:	0f b6 00             	movzbl (%rax),%eax
  800896:	0f b6 d8             	movzbl %al,%ebx
  800899:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80089c:	83 f8 55             	cmp    $0x55,%eax
  80089f:	0f 87 22 04 00 00    	ja     800cc7 <vprintfmt+0x4c9>
  8008a5:	89 c0                	mov    %eax,%eax
  8008a7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008ae:	00 
  8008af:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  8008b6:	00 00 00 
  8008b9:	48 01 d0             	add    %rdx,%rax
  8008bc:	48 8b 00             	mov    (%rax),%rax
  8008bf:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008c1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008c5:	eb c0                	jmp    800887 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008c7:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008cb:	eb ba                	jmp    800887 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008cd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008d4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008d7:	89 d0                	mov    %edx,%eax
  8008d9:	c1 e0 02             	shl    $0x2,%eax
  8008dc:	01 d0                	add    %edx,%eax
  8008de:	01 c0                	add    %eax,%eax
  8008e0:	01 d8                	add    %ebx,%eax
  8008e2:	83 e8 30             	sub    $0x30,%eax
  8008e5:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8008e8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008ec:	0f b6 00             	movzbl (%rax),%eax
  8008ef:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008f2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008f5:	7e 60                	jle    800957 <vprintfmt+0x159>
  8008f7:	83 fb 39             	cmp    $0x39,%ebx
  8008fa:	7f 5b                	jg     800957 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008fc:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800901:	eb d1                	jmp    8008d4 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800903:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800906:	83 f8 30             	cmp    $0x30,%eax
  800909:	73 17                	jae    800922 <vprintfmt+0x124>
  80090b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80090f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800912:	89 d2                	mov    %edx,%edx
  800914:	48 01 d0             	add    %rdx,%rax
  800917:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80091a:	83 c2 08             	add    $0x8,%edx
  80091d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800920:	eb 0c                	jmp    80092e <vprintfmt+0x130>
  800922:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800926:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80092a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80092e:	8b 00                	mov    (%rax),%eax
  800930:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800933:	eb 23                	jmp    800958 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800935:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800939:	0f 89 48 ff ff ff    	jns    800887 <vprintfmt+0x89>
				width = 0;
  80093f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800946:	e9 3c ff ff ff       	jmpq   800887 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80094b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800952:	e9 30 ff ff ff       	jmpq   800887 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800957:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800958:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80095c:	0f 89 25 ff ff ff    	jns    800887 <vprintfmt+0x89>
				width = precision, precision = -1;
  800962:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800965:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800968:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80096f:	e9 13 ff ff ff       	jmpq   800887 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800974:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800978:	e9 0a ff ff ff       	jmpq   800887 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80097d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800980:	83 f8 30             	cmp    $0x30,%eax
  800983:	73 17                	jae    80099c <vprintfmt+0x19e>
  800985:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800989:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80098c:	89 d2                	mov    %edx,%edx
  80098e:	48 01 d0             	add    %rdx,%rax
  800991:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800994:	83 c2 08             	add    $0x8,%edx
  800997:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80099a:	eb 0c                	jmp    8009a8 <vprintfmt+0x1aa>
  80099c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009a0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009a4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009a8:	8b 10                	mov    (%rax),%edx
  8009aa:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009ae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b2:	48 89 ce             	mov    %rcx,%rsi
  8009b5:	89 d7                	mov    %edx,%edi
  8009b7:	ff d0                	callq  *%rax
			break;
  8009b9:	e9 37 03 00 00       	jmpq   800cf5 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009be:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c1:	83 f8 30             	cmp    $0x30,%eax
  8009c4:	73 17                	jae    8009dd <vprintfmt+0x1df>
  8009c6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009ca:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009cd:	89 d2                	mov    %edx,%edx
  8009cf:	48 01 d0             	add    %rdx,%rax
  8009d2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d5:	83 c2 08             	add    $0x8,%edx
  8009d8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009db:	eb 0c                	jmp    8009e9 <vprintfmt+0x1eb>
  8009dd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009e1:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009e5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009e9:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8009eb:	85 db                	test   %ebx,%ebx
  8009ed:	79 02                	jns    8009f1 <vprintfmt+0x1f3>
				err = -err;
  8009ef:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009f1:	83 fb 15             	cmp    $0x15,%ebx
  8009f4:	7f 16                	jg     800a0c <vprintfmt+0x20e>
  8009f6:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  8009fd:	00 00 00 
  800a00:	48 63 d3             	movslq %ebx,%rdx
  800a03:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a07:	4d 85 e4             	test   %r12,%r12
  800a0a:	75 2e                	jne    800a3a <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800a0c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a14:	89 d9                	mov    %ebx,%ecx
  800a16:	48 ba 01 1f 80 00 00 	movabs $0x801f01,%rdx
  800a1d:	00 00 00 
  800a20:	48 89 c7             	mov    %rax,%rdi
  800a23:	b8 00 00 00 00       	mov    $0x0,%eax
  800a28:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  800a2f:	00 00 00 
  800a32:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a35:	e9 bb 02 00 00       	jmpq   800cf5 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a3a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a42:	4c 89 e1             	mov    %r12,%rcx
  800a45:	48 ba 0a 1f 80 00 00 	movabs $0x801f0a,%rdx
  800a4c:	00 00 00 
  800a4f:	48 89 c7             	mov    %rax,%rdi
  800a52:	b8 00 00 00 00       	mov    $0x0,%eax
  800a57:	49 b8 04 0d 80 00 00 	movabs $0x800d04,%r8
  800a5e:	00 00 00 
  800a61:	41 ff d0             	callq  *%r8
			break;
  800a64:	e9 8c 02 00 00       	jmpq   800cf5 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6c:	83 f8 30             	cmp    $0x30,%eax
  800a6f:	73 17                	jae    800a88 <vprintfmt+0x28a>
  800a71:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a75:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a78:	89 d2                	mov    %edx,%edx
  800a7a:	48 01 d0             	add    %rdx,%rax
  800a7d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a80:	83 c2 08             	add    $0x8,%edx
  800a83:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a86:	eb 0c                	jmp    800a94 <vprintfmt+0x296>
  800a88:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a8c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a90:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a94:	4c 8b 20             	mov    (%rax),%r12
  800a97:	4d 85 e4             	test   %r12,%r12
  800a9a:	75 0a                	jne    800aa6 <vprintfmt+0x2a8>
				p = "(null)";
  800a9c:	49 bc 0d 1f 80 00 00 	movabs $0x801f0d,%r12
  800aa3:	00 00 00 
			if (width > 0 && padc != '-')
  800aa6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aaa:	7e 78                	jle    800b24 <vprintfmt+0x326>
  800aac:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ab0:	74 72                	je     800b24 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ab2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ab5:	48 98                	cltq   
  800ab7:	48 89 c6             	mov    %rax,%rsi
  800aba:	4c 89 e7             	mov    %r12,%rdi
  800abd:	48 b8 b2 0f 80 00 00 	movabs $0x800fb2,%rax
  800ac4:	00 00 00 
  800ac7:	ff d0                	callq  *%rax
  800ac9:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800acc:	eb 17                	jmp    800ae5 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800ace:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ad2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ad6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ada:	48 89 ce             	mov    %rcx,%rsi
  800add:	89 d7                	mov    %edx,%edi
  800adf:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ae5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ae9:	7f e3                	jg     800ace <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aeb:	eb 37                	jmp    800b24 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800aed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800af1:	74 1e                	je     800b11 <vprintfmt+0x313>
  800af3:	83 fb 1f             	cmp    $0x1f,%ebx
  800af6:	7e 05                	jle    800afd <vprintfmt+0x2ff>
  800af8:	83 fb 7e             	cmp    $0x7e,%ebx
  800afb:	7e 14                	jle    800b11 <vprintfmt+0x313>
					putch('?', putdat);
  800afd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b05:	48 89 d6             	mov    %rdx,%rsi
  800b08:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b0d:	ff d0                	callq  *%rax
  800b0f:	eb 0f                	jmp    800b20 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800b11:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b15:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b19:	48 89 d6             	mov    %rdx,%rsi
  800b1c:	89 df                	mov    %ebx,%edi
  800b1e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b20:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b24:	4c 89 e0             	mov    %r12,%rax
  800b27:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b2b:	0f b6 00             	movzbl (%rax),%eax
  800b2e:	0f be d8             	movsbl %al,%ebx
  800b31:	85 db                	test   %ebx,%ebx
  800b33:	74 28                	je     800b5d <vprintfmt+0x35f>
  800b35:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b39:	78 b2                	js     800aed <vprintfmt+0x2ef>
  800b3b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b3f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b43:	79 a8                	jns    800aed <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b45:	eb 16                	jmp    800b5d <vprintfmt+0x35f>
				putch(' ', putdat);
  800b47:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4f:	48 89 d6             	mov    %rdx,%rsi
  800b52:	bf 20 00 00 00       	mov    $0x20,%edi
  800b57:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b59:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b5d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b61:	7f e4                	jg     800b47 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800b63:	e9 8d 01 00 00       	jmpq   800cf5 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b68:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b6c:	be 03 00 00 00       	mov    $0x3,%esi
  800b71:	48 89 c7             	mov    %rax,%rdi
  800b74:	48 b8 f7 06 80 00 00 	movabs $0x8006f7,%rax
  800b7b:	00 00 00 
  800b7e:	ff d0                	callq  *%rax
  800b80:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b88:	48 85 c0             	test   %rax,%rax
  800b8b:	79 1d                	jns    800baa <vprintfmt+0x3ac>
				putch('-', putdat);
  800b8d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b91:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b95:	48 89 d6             	mov    %rdx,%rsi
  800b98:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b9d:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba3:	48 f7 d8             	neg    %rax
  800ba6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800baa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bb1:	e9 d2 00 00 00       	jmpq   800c88 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bb6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bba:	be 03 00 00 00       	mov    $0x3,%esi
  800bbf:	48 89 c7             	mov    %rax,%rdi
  800bc2:	48 b8 f0 05 80 00 00 	movabs $0x8005f0,%rax
  800bc9:	00 00 00 
  800bcc:	ff d0                	callq  *%rax
  800bce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800bd2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bd9:	e9 aa 00 00 00       	jmpq   800c88 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800bde:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800be2:	be 03 00 00 00       	mov    $0x3,%esi
  800be7:	48 89 c7             	mov    %rax,%rdi
  800bea:	48 b8 f0 05 80 00 00 	movabs $0x8005f0,%rax
  800bf1:	00 00 00 
  800bf4:	ff d0                	callq  *%rax
  800bf6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800bfa:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c01:	e9 82 00 00 00       	jmpq   800c88 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800c06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0e:	48 89 d6             	mov    %rdx,%rsi
  800c11:	bf 30 00 00 00       	mov    $0x30,%edi
  800c16:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c18:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c20:	48 89 d6             	mov    %rdx,%rsi
  800c23:	bf 78 00 00 00       	mov    $0x78,%edi
  800c28:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c2d:	83 f8 30             	cmp    $0x30,%eax
  800c30:	73 17                	jae    800c49 <vprintfmt+0x44b>
  800c32:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c36:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c39:	89 d2                	mov    %edx,%edx
  800c3b:	48 01 d0             	add    %rdx,%rax
  800c3e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c41:	83 c2 08             	add    $0x8,%edx
  800c44:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c47:	eb 0c                	jmp    800c55 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800c49:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c4d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c51:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c55:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c58:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c5c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c63:	eb 23                	jmp    800c88 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c65:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c69:	be 03 00 00 00       	mov    $0x3,%esi
  800c6e:	48 89 c7             	mov    %rax,%rdi
  800c71:	48 b8 f0 05 80 00 00 	movabs $0x8005f0,%rax
  800c78:	00 00 00 
  800c7b:	ff d0                	callq  *%rax
  800c7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c81:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c88:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c8d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c90:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c93:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c97:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9f:	45 89 c1             	mov    %r8d,%r9d
  800ca2:	41 89 f8             	mov    %edi,%r8d
  800ca5:	48 89 c7             	mov    %rax,%rdi
  800ca8:	48 b8 38 05 80 00 00 	movabs $0x800538,%rax
  800caf:	00 00 00 
  800cb2:	ff d0                	callq  *%rax
			break;
  800cb4:	eb 3f                	jmp    800cf5 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cb6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cbe:	48 89 d6             	mov    %rdx,%rsi
  800cc1:	89 df                	mov    %ebx,%edi
  800cc3:	ff d0                	callq  *%rax
			break;
  800cc5:	eb 2e                	jmp    800cf5 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cc7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ccb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ccf:	48 89 d6             	mov    %rdx,%rsi
  800cd2:	bf 25 00 00 00       	mov    $0x25,%edi
  800cd7:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800cde:	eb 05                	jmp    800ce5 <vprintfmt+0x4e7>
  800ce0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ce5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ce9:	48 83 e8 01          	sub    $0x1,%rax
  800ced:	0f b6 00             	movzbl (%rax),%eax
  800cf0:	3c 25                	cmp    $0x25,%al
  800cf2:	75 ec                	jne    800ce0 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800cf4:	90                   	nop
		}
	}
  800cf5:	e9 3d fb ff ff       	jmpq   800837 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cfa:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800cfb:	48 83 c4 60          	add    $0x60,%rsp
  800cff:	5b                   	pop    %rbx
  800d00:	41 5c                	pop    %r12
  800d02:	5d                   	pop    %rbp
  800d03:	c3                   	retq   

0000000000800d04 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d04:	55                   	push   %rbp
  800d05:	48 89 e5             	mov    %rsp,%rbp
  800d08:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d0f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d16:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d1d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800d24:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d2b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d32:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d39:	84 c0                	test   %al,%al
  800d3b:	74 20                	je     800d5d <printfmt+0x59>
  800d3d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d41:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d45:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d49:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d4d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d51:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d55:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d59:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d5d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d64:	00 00 00 
  800d67:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d6e:	00 00 00 
  800d71:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d75:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d7c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d83:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d8a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d91:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d98:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d9f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800da6:	48 89 c7             	mov    %rax,%rdi
  800da9:	48 b8 fe 07 80 00 00 	movabs $0x8007fe,%rax
  800db0:	00 00 00 
  800db3:	ff d0                	callq  *%rax
	va_end(ap);
}
  800db5:	90                   	nop
  800db6:	c9                   	leaveq 
  800db7:	c3                   	retq   

0000000000800db8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800db8:	55                   	push   %rbp
  800db9:	48 89 e5             	mov    %rsp,%rbp
  800dbc:	48 83 ec 10          	sub    $0x10,%rsp
  800dc0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800dc3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800dc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dcb:	8b 40 10             	mov    0x10(%rax),%eax
  800dce:	8d 50 01             	lea    0x1(%rax),%edx
  800dd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dd5:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800dd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ddc:	48 8b 10             	mov    (%rax),%rdx
  800ddf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800de3:	48 8b 40 08          	mov    0x8(%rax),%rax
  800de7:	48 39 c2             	cmp    %rax,%rdx
  800dea:	73 17                	jae    800e03 <sprintputch+0x4b>
		*b->buf++ = ch;
  800dec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df0:	48 8b 00             	mov    (%rax),%rax
  800df3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800df7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800dfb:	48 89 0a             	mov    %rcx,(%rdx)
  800dfe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e01:	88 10                	mov    %dl,(%rax)
}
  800e03:	90                   	nop
  800e04:	c9                   	leaveq 
  800e05:	c3                   	retq   

0000000000800e06 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e06:	55                   	push   %rbp
  800e07:	48 89 e5             	mov    %rsp,%rbp
  800e0a:	48 83 ec 50          	sub    $0x50,%rsp
  800e0e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e12:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e15:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e19:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e1d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e21:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e25:	48 8b 0a             	mov    (%rdx),%rcx
  800e28:	48 89 08             	mov    %rcx,(%rax)
  800e2b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e2f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e33:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e37:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e3b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e3f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e43:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e46:	48 98                	cltq   
  800e48:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e4c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e50:	48 01 d0             	add    %rdx,%rax
  800e53:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e57:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e5e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e63:	74 06                	je     800e6b <vsnprintf+0x65>
  800e65:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e69:	7f 07                	jg     800e72 <vsnprintf+0x6c>
		return -E_INVAL;
  800e6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e70:	eb 2f                	jmp    800ea1 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e72:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e76:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e7a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e7e:	48 89 c6             	mov    %rax,%rsi
  800e81:	48 bf b8 0d 80 00 00 	movabs $0x800db8,%rdi
  800e88:	00 00 00 
  800e8b:	48 b8 fe 07 80 00 00 	movabs $0x8007fe,%rax
  800e92:	00 00 00 
  800e95:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e9b:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e9e:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ea1:	c9                   	leaveq 
  800ea2:	c3                   	retq   

0000000000800ea3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ea3:	55                   	push   %rbp
  800ea4:	48 89 e5             	mov    %rsp,%rbp
  800ea7:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800eae:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800eb5:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ebb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800ec2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ec9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ed0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ed7:	84 c0                	test   %al,%al
  800ed9:	74 20                	je     800efb <snprintf+0x58>
  800edb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800edf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ee3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ee7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800eeb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800eef:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ef3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ef7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800efb:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f02:	00 00 00 
  800f05:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f0c:	00 00 00 
  800f0f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f13:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f1a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f21:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f28:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f2f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f36:	48 8b 0a             	mov    (%rdx),%rcx
  800f39:	48 89 08             	mov    %rcx,(%rax)
  800f3c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f40:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f44:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f48:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f4c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f53:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f5a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f60:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f67:	48 89 c7             	mov    %rax,%rdi
  800f6a:	48 b8 06 0e 80 00 00 	movabs $0x800e06,%rax
  800f71:	00 00 00 
  800f74:	ff d0                	callq  *%rax
  800f76:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f7c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f82:	c9                   	leaveq 
  800f83:	c3                   	retq   

0000000000800f84 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f84:	55                   	push   %rbp
  800f85:	48 89 e5             	mov    %rsp,%rbp
  800f88:	48 83 ec 18          	sub    $0x18,%rsp
  800f8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f97:	eb 09                	jmp    800fa2 <strlen+0x1e>
		n++;
  800f99:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f9d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa6:	0f b6 00             	movzbl (%rax),%eax
  800fa9:	84 c0                	test   %al,%al
  800fab:	75 ec                	jne    800f99 <strlen+0x15>
		n++;
	return n;
  800fad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fb0:	c9                   	leaveq 
  800fb1:	c3                   	retq   

0000000000800fb2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fb2:	55                   	push   %rbp
  800fb3:	48 89 e5             	mov    %rsp,%rbp
  800fb6:	48 83 ec 20          	sub    $0x20,%rsp
  800fba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fbe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fc9:	eb 0e                	jmp    800fd9 <strnlen+0x27>
		n++;
  800fcb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fcf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fd4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800fd9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800fde:	74 0b                	je     800feb <strnlen+0x39>
  800fe0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe4:	0f b6 00             	movzbl (%rax),%eax
  800fe7:	84 c0                	test   %al,%al
  800fe9:	75 e0                	jne    800fcb <strnlen+0x19>
		n++;
	return n;
  800feb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fee:	c9                   	leaveq 
  800fef:	c3                   	retq   

0000000000800ff0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ff0:	55                   	push   %rbp
  800ff1:	48 89 e5             	mov    %rsp,%rbp
  800ff4:	48 83 ec 20          	sub    $0x20,%rsp
  800ff8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ffc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801000:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801004:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801008:	90                   	nop
  801009:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801011:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801015:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801019:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80101d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801021:	0f b6 12             	movzbl (%rdx),%edx
  801024:	88 10                	mov    %dl,(%rax)
  801026:	0f b6 00             	movzbl (%rax),%eax
  801029:	84 c0                	test   %al,%al
  80102b:	75 dc                	jne    801009 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80102d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801031:	c9                   	leaveq 
  801032:	c3                   	retq   

0000000000801033 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801033:	55                   	push   %rbp
  801034:	48 89 e5             	mov    %rsp,%rbp
  801037:	48 83 ec 20          	sub    $0x20,%rsp
  80103b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80103f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801043:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801047:	48 89 c7             	mov    %rax,%rdi
  80104a:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  801051:	00 00 00 
  801054:	ff d0                	callq  *%rax
  801056:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801059:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80105c:	48 63 d0             	movslq %eax,%rdx
  80105f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801063:	48 01 c2             	add    %rax,%rdx
  801066:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80106a:	48 89 c6             	mov    %rax,%rsi
  80106d:	48 89 d7             	mov    %rdx,%rdi
  801070:	48 b8 f0 0f 80 00 00 	movabs $0x800ff0,%rax
  801077:	00 00 00 
  80107a:	ff d0                	callq  *%rax
	return dst;
  80107c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801080:	c9                   	leaveq 
  801081:	c3                   	retq   

0000000000801082 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801082:	55                   	push   %rbp
  801083:	48 89 e5             	mov    %rsp,%rbp
  801086:	48 83 ec 28          	sub    $0x28,%rsp
  80108a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80108e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801092:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801096:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80109e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010a5:	00 
  8010a6:	eb 2a                	jmp    8010d2 <strncpy+0x50>
		*dst++ = *src;
  8010a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010b0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010b4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010b8:	0f b6 12             	movzbl (%rdx),%edx
  8010bb:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010c1:	0f b6 00             	movzbl (%rax),%eax
  8010c4:	84 c0                	test   %al,%al
  8010c6:	74 05                	je     8010cd <strncpy+0x4b>
			src++;
  8010c8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010cd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010da:	72 cc                	jb     8010a8 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8010e0:	c9                   	leaveq 
  8010e1:	c3                   	retq   

00000000008010e2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010e2:	55                   	push   %rbp
  8010e3:	48 89 e5             	mov    %rsp,%rbp
  8010e6:	48 83 ec 28          	sub    $0x28,%rsp
  8010ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8010f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8010fe:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801103:	74 3d                	je     801142 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801105:	eb 1d                	jmp    801124 <strlcpy+0x42>
			*dst++ = *src++;
  801107:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80110f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801113:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801117:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80111b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80111f:	0f b6 12             	movzbl (%rdx),%edx
  801122:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801124:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801129:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80112e:	74 0b                	je     80113b <strlcpy+0x59>
  801130:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801134:	0f b6 00             	movzbl (%rax),%eax
  801137:	84 c0                	test   %al,%al
  801139:	75 cc                	jne    801107 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80113b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113f:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801142:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114a:	48 29 c2             	sub    %rax,%rdx
  80114d:	48 89 d0             	mov    %rdx,%rax
}
  801150:	c9                   	leaveq 
  801151:	c3                   	retq   

0000000000801152 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801152:	55                   	push   %rbp
  801153:	48 89 e5             	mov    %rsp,%rbp
  801156:	48 83 ec 10          	sub    $0x10,%rsp
  80115a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80115e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801162:	eb 0a                	jmp    80116e <strcmp+0x1c>
		p++, q++;
  801164:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801169:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80116e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801172:	0f b6 00             	movzbl (%rax),%eax
  801175:	84 c0                	test   %al,%al
  801177:	74 12                	je     80118b <strcmp+0x39>
  801179:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117d:	0f b6 10             	movzbl (%rax),%edx
  801180:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801184:	0f b6 00             	movzbl (%rax),%eax
  801187:	38 c2                	cmp    %al,%dl
  801189:	74 d9                	je     801164 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80118b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118f:	0f b6 00             	movzbl (%rax),%eax
  801192:	0f b6 d0             	movzbl %al,%edx
  801195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801199:	0f b6 00             	movzbl (%rax),%eax
  80119c:	0f b6 c0             	movzbl %al,%eax
  80119f:	29 c2                	sub    %eax,%edx
  8011a1:	89 d0                	mov    %edx,%eax
}
  8011a3:	c9                   	leaveq 
  8011a4:	c3                   	retq   

00000000008011a5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011a5:	55                   	push   %rbp
  8011a6:	48 89 e5             	mov    %rsp,%rbp
  8011a9:	48 83 ec 18          	sub    $0x18,%rsp
  8011ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011b9:	eb 0f                	jmp    8011ca <strncmp+0x25>
		n--, p++, q++;
  8011bb:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011c5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011ca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011cf:	74 1d                	je     8011ee <strncmp+0x49>
  8011d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d5:	0f b6 00             	movzbl (%rax),%eax
  8011d8:	84 c0                	test   %al,%al
  8011da:	74 12                	je     8011ee <strncmp+0x49>
  8011dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e0:	0f b6 10             	movzbl (%rax),%edx
  8011e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e7:	0f b6 00             	movzbl (%rax),%eax
  8011ea:	38 c2                	cmp    %al,%dl
  8011ec:	74 cd                	je     8011bb <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8011ee:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011f3:	75 07                	jne    8011fc <strncmp+0x57>
		return 0;
  8011f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fa:	eb 18                	jmp    801214 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801200:	0f b6 00             	movzbl (%rax),%eax
  801203:	0f b6 d0             	movzbl %al,%edx
  801206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120a:	0f b6 00             	movzbl (%rax),%eax
  80120d:	0f b6 c0             	movzbl %al,%eax
  801210:	29 c2                	sub    %eax,%edx
  801212:	89 d0                	mov    %edx,%eax
}
  801214:	c9                   	leaveq 
  801215:	c3                   	retq   

0000000000801216 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801216:	55                   	push   %rbp
  801217:	48 89 e5             	mov    %rsp,%rbp
  80121a:	48 83 ec 10          	sub    $0x10,%rsp
  80121e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801222:	89 f0                	mov    %esi,%eax
  801224:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801227:	eb 17                	jmp    801240 <strchr+0x2a>
		if (*s == c)
  801229:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122d:	0f b6 00             	movzbl (%rax),%eax
  801230:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801233:	75 06                	jne    80123b <strchr+0x25>
			return (char *) s;
  801235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801239:	eb 15                	jmp    801250 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80123b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801240:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801244:	0f b6 00             	movzbl (%rax),%eax
  801247:	84 c0                	test   %al,%al
  801249:	75 de                	jne    801229 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80124b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801250:	c9                   	leaveq 
  801251:	c3                   	retq   

0000000000801252 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801252:	55                   	push   %rbp
  801253:	48 89 e5             	mov    %rsp,%rbp
  801256:	48 83 ec 10          	sub    $0x10,%rsp
  80125a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80125e:	89 f0                	mov    %esi,%eax
  801260:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801263:	eb 11                	jmp    801276 <strfind+0x24>
		if (*s == c)
  801265:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801269:	0f b6 00             	movzbl (%rax),%eax
  80126c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80126f:	74 12                	je     801283 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801271:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127a:	0f b6 00             	movzbl (%rax),%eax
  80127d:	84 c0                	test   %al,%al
  80127f:	75 e4                	jne    801265 <strfind+0x13>
  801281:	eb 01                	jmp    801284 <strfind+0x32>
		if (*s == c)
			break;
  801283:	90                   	nop
	return (char *) s;
  801284:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801288:	c9                   	leaveq 
  801289:	c3                   	retq   

000000000080128a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80128a:	55                   	push   %rbp
  80128b:	48 89 e5             	mov    %rsp,%rbp
  80128e:	48 83 ec 18          	sub    $0x18,%rsp
  801292:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801296:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801299:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80129d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012a2:	75 06                	jne    8012aa <memset+0x20>
		return v;
  8012a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a8:	eb 69                	jmp    801313 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ae:	83 e0 03             	and    $0x3,%eax
  8012b1:	48 85 c0             	test   %rax,%rax
  8012b4:	75 48                	jne    8012fe <memset+0x74>
  8012b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ba:	83 e0 03             	and    $0x3,%eax
  8012bd:	48 85 c0             	test   %rax,%rax
  8012c0:	75 3c                	jne    8012fe <memset+0x74>
		c &= 0xFF;
  8012c2:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012cc:	c1 e0 18             	shl    $0x18,%eax
  8012cf:	89 c2                	mov    %eax,%edx
  8012d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012d4:	c1 e0 10             	shl    $0x10,%eax
  8012d7:	09 c2                	or     %eax,%edx
  8012d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012dc:	c1 e0 08             	shl    $0x8,%eax
  8012df:	09 d0                	or     %edx,%eax
  8012e1:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8012e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e8:	48 c1 e8 02          	shr    $0x2,%rax
  8012ec:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8012ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012f6:	48 89 d7             	mov    %rdx,%rdi
  8012f9:	fc                   	cld    
  8012fa:	f3 ab                	rep stos %eax,%es:(%rdi)
  8012fc:	eb 11                	jmp    80130f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8012fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801302:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801305:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801309:	48 89 d7             	mov    %rdx,%rdi
  80130c:	fc                   	cld    
  80130d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80130f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801313:	c9                   	leaveq 
  801314:	c3                   	retq   

0000000000801315 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801315:	55                   	push   %rbp
  801316:	48 89 e5             	mov    %rsp,%rbp
  801319:	48 83 ec 28          	sub    $0x28,%rsp
  80131d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801321:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801325:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801329:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80132d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801331:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801335:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801339:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801341:	0f 83 88 00 00 00    	jae    8013cf <memmove+0xba>
  801347:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80134b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80134f:	48 01 d0             	add    %rdx,%rax
  801352:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801356:	76 77                	jbe    8013cf <memmove+0xba>
		s += n;
  801358:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801360:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801364:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801368:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136c:	83 e0 03             	and    $0x3,%eax
  80136f:	48 85 c0             	test   %rax,%rax
  801372:	75 3b                	jne    8013af <memmove+0x9a>
  801374:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801378:	83 e0 03             	and    $0x3,%eax
  80137b:	48 85 c0             	test   %rax,%rax
  80137e:	75 2f                	jne    8013af <memmove+0x9a>
  801380:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801384:	83 e0 03             	and    $0x3,%eax
  801387:	48 85 c0             	test   %rax,%rax
  80138a:	75 23                	jne    8013af <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80138c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801390:	48 83 e8 04          	sub    $0x4,%rax
  801394:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801398:	48 83 ea 04          	sub    $0x4,%rdx
  80139c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013a0:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013a4:	48 89 c7             	mov    %rax,%rdi
  8013a7:	48 89 d6             	mov    %rdx,%rsi
  8013aa:	fd                   	std    
  8013ab:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013ad:	eb 1d                	jmp    8013cc <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bb:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c3:	48 89 d7             	mov    %rdx,%rdi
  8013c6:	48 89 c1             	mov    %rax,%rcx
  8013c9:	fd                   	std    
  8013ca:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013cc:	fc                   	cld    
  8013cd:	eb 57                	jmp    801426 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d3:	83 e0 03             	and    $0x3,%eax
  8013d6:	48 85 c0             	test   %rax,%rax
  8013d9:	75 36                	jne    801411 <memmove+0xfc>
  8013db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013df:	83 e0 03             	and    $0x3,%eax
  8013e2:	48 85 c0             	test   %rax,%rax
  8013e5:	75 2a                	jne    801411 <memmove+0xfc>
  8013e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013eb:	83 e0 03             	and    $0x3,%eax
  8013ee:	48 85 c0             	test   %rax,%rax
  8013f1:	75 1e                	jne    801411 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8013f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f7:	48 c1 e8 02          	shr    $0x2,%rax
  8013fb:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8013fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801402:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801406:	48 89 c7             	mov    %rax,%rdi
  801409:	48 89 d6             	mov    %rdx,%rsi
  80140c:	fc                   	cld    
  80140d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80140f:	eb 15                	jmp    801426 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801411:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801415:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801419:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80141d:	48 89 c7             	mov    %rax,%rdi
  801420:	48 89 d6             	mov    %rdx,%rsi
  801423:	fc                   	cld    
  801424:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801426:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80142a:	c9                   	leaveq 
  80142b:	c3                   	retq   

000000000080142c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80142c:	55                   	push   %rbp
  80142d:	48 89 e5             	mov    %rsp,%rbp
  801430:	48 83 ec 18          	sub    $0x18,%rsp
  801434:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801438:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80143c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801440:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801444:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801448:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144c:	48 89 ce             	mov    %rcx,%rsi
  80144f:	48 89 c7             	mov    %rax,%rdi
  801452:	48 b8 15 13 80 00 00 	movabs $0x801315,%rax
  801459:	00 00 00 
  80145c:	ff d0                	callq  *%rax
}
  80145e:	c9                   	leaveq 
  80145f:	c3                   	retq   

0000000000801460 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801460:	55                   	push   %rbp
  801461:	48 89 e5             	mov    %rsp,%rbp
  801464:	48 83 ec 28          	sub    $0x28,%rsp
  801468:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801470:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801474:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801478:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80147c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801480:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801484:	eb 36                	jmp    8014bc <memcmp+0x5c>
		if (*s1 != *s2)
  801486:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148a:	0f b6 10             	movzbl (%rax),%edx
  80148d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801491:	0f b6 00             	movzbl (%rax),%eax
  801494:	38 c2                	cmp    %al,%dl
  801496:	74 1a                	je     8014b2 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801498:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149c:	0f b6 00             	movzbl (%rax),%eax
  80149f:	0f b6 d0             	movzbl %al,%edx
  8014a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a6:	0f b6 00             	movzbl (%rax),%eax
  8014a9:	0f b6 c0             	movzbl %al,%eax
  8014ac:	29 c2                	sub    %eax,%edx
  8014ae:	89 d0                	mov    %edx,%eax
  8014b0:	eb 20                	jmp    8014d2 <memcmp+0x72>
		s1++, s2++;
  8014b2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014c8:	48 85 c0             	test   %rax,%rax
  8014cb:	75 b9                	jne    801486 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d2:	c9                   	leaveq 
  8014d3:	c3                   	retq   

00000000008014d4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014d4:	55                   	push   %rbp
  8014d5:	48 89 e5             	mov    %rsp,%rbp
  8014d8:	48 83 ec 28          	sub    $0x28,%rsp
  8014dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014e0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8014e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8014e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ef:	48 01 d0             	add    %rdx,%rax
  8014f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8014f6:	eb 19                	jmp    801511 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fc:	0f b6 00             	movzbl (%rax),%eax
  8014ff:	0f b6 d0             	movzbl %al,%edx
  801502:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801505:	0f b6 c0             	movzbl %al,%eax
  801508:	39 c2                	cmp    %eax,%edx
  80150a:	74 11                	je     80151d <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80150c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801515:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801519:	72 dd                	jb     8014f8 <memfind+0x24>
  80151b:	eb 01                	jmp    80151e <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80151d:	90                   	nop
	return (void *) s;
  80151e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801522:	c9                   	leaveq 
  801523:	c3                   	retq   

0000000000801524 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801524:	55                   	push   %rbp
  801525:	48 89 e5             	mov    %rsp,%rbp
  801528:	48 83 ec 38          	sub    $0x38,%rsp
  80152c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801530:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801534:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801537:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80153e:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801545:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801546:	eb 05                	jmp    80154d <strtol+0x29>
		s++;
  801548:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80154d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801551:	0f b6 00             	movzbl (%rax),%eax
  801554:	3c 20                	cmp    $0x20,%al
  801556:	74 f0                	je     801548 <strtol+0x24>
  801558:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155c:	0f b6 00             	movzbl (%rax),%eax
  80155f:	3c 09                	cmp    $0x9,%al
  801561:	74 e5                	je     801548 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801563:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801567:	0f b6 00             	movzbl (%rax),%eax
  80156a:	3c 2b                	cmp    $0x2b,%al
  80156c:	75 07                	jne    801575 <strtol+0x51>
		s++;
  80156e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801573:	eb 17                	jmp    80158c <strtol+0x68>
	else if (*s == '-')
  801575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801579:	0f b6 00             	movzbl (%rax),%eax
  80157c:	3c 2d                	cmp    $0x2d,%al
  80157e:	75 0c                	jne    80158c <strtol+0x68>
		s++, neg = 1;
  801580:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801585:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80158c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801590:	74 06                	je     801598 <strtol+0x74>
  801592:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801596:	75 28                	jne    8015c0 <strtol+0x9c>
  801598:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159c:	0f b6 00             	movzbl (%rax),%eax
  80159f:	3c 30                	cmp    $0x30,%al
  8015a1:	75 1d                	jne    8015c0 <strtol+0x9c>
  8015a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a7:	48 83 c0 01          	add    $0x1,%rax
  8015ab:	0f b6 00             	movzbl (%rax),%eax
  8015ae:	3c 78                	cmp    $0x78,%al
  8015b0:	75 0e                	jne    8015c0 <strtol+0x9c>
		s += 2, base = 16;
  8015b2:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015b7:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015be:	eb 2c                	jmp    8015ec <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015c0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015c4:	75 19                	jne    8015df <strtol+0xbb>
  8015c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ca:	0f b6 00             	movzbl (%rax),%eax
  8015cd:	3c 30                	cmp    $0x30,%al
  8015cf:	75 0e                	jne    8015df <strtol+0xbb>
		s++, base = 8;
  8015d1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d6:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8015dd:	eb 0d                	jmp    8015ec <strtol+0xc8>
	else if (base == 0)
  8015df:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015e3:	75 07                	jne    8015ec <strtol+0xc8>
		base = 10;
  8015e5:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f0:	0f b6 00             	movzbl (%rax),%eax
  8015f3:	3c 2f                	cmp    $0x2f,%al
  8015f5:	7e 1d                	jle    801614 <strtol+0xf0>
  8015f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fb:	0f b6 00             	movzbl (%rax),%eax
  8015fe:	3c 39                	cmp    $0x39,%al
  801600:	7f 12                	jg     801614 <strtol+0xf0>
			dig = *s - '0';
  801602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801606:	0f b6 00             	movzbl (%rax),%eax
  801609:	0f be c0             	movsbl %al,%eax
  80160c:	83 e8 30             	sub    $0x30,%eax
  80160f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801612:	eb 4e                	jmp    801662 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801618:	0f b6 00             	movzbl (%rax),%eax
  80161b:	3c 60                	cmp    $0x60,%al
  80161d:	7e 1d                	jle    80163c <strtol+0x118>
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	0f b6 00             	movzbl (%rax),%eax
  801626:	3c 7a                	cmp    $0x7a,%al
  801628:	7f 12                	jg     80163c <strtol+0x118>
			dig = *s - 'a' + 10;
  80162a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162e:	0f b6 00             	movzbl (%rax),%eax
  801631:	0f be c0             	movsbl %al,%eax
  801634:	83 e8 57             	sub    $0x57,%eax
  801637:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80163a:	eb 26                	jmp    801662 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80163c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801640:	0f b6 00             	movzbl (%rax),%eax
  801643:	3c 40                	cmp    $0x40,%al
  801645:	7e 47                	jle    80168e <strtol+0x16a>
  801647:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164b:	0f b6 00             	movzbl (%rax),%eax
  80164e:	3c 5a                	cmp    $0x5a,%al
  801650:	7f 3c                	jg     80168e <strtol+0x16a>
			dig = *s - 'A' + 10;
  801652:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801656:	0f b6 00             	movzbl (%rax),%eax
  801659:	0f be c0             	movsbl %al,%eax
  80165c:	83 e8 37             	sub    $0x37,%eax
  80165f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801662:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801665:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801668:	7d 23                	jge    80168d <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80166a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80166f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801672:	48 98                	cltq   
  801674:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801679:	48 89 c2             	mov    %rax,%rdx
  80167c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80167f:	48 98                	cltq   
  801681:	48 01 d0             	add    %rdx,%rax
  801684:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801688:	e9 5f ff ff ff       	jmpq   8015ec <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80168d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80168e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801693:	74 0b                	je     8016a0 <strtol+0x17c>
		*endptr = (char *) s;
  801695:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801699:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80169d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016a4:	74 09                	je     8016af <strtol+0x18b>
  8016a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016aa:	48 f7 d8             	neg    %rax
  8016ad:	eb 04                	jmp    8016b3 <strtol+0x18f>
  8016af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016b3:	c9                   	leaveq 
  8016b4:	c3                   	retq   

00000000008016b5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016b5:	55                   	push   %rbp
  8016b6:	48 89 e5             	mov    %rsp,%rbp
  8016b9:	48 83 ec 30          	sub    $0x30,%rsp
  8016bd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016c1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016cd:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016d1:	0f b6 00             	movzbl (%rax),%eax
  8016d4:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8016d7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8016db:	75 06                	jne    8016e3 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8016dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e1:	eb 6b                	jmp    80174e <strstr+0x99>

	len = strlen(str);
  8016e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016e7:	48 89 c7             	mov    %rax,%rdi
  8016ea:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  8016f1:	00 00 00 
  8016f4:	ff d0                	callq  *%rax
  8016f6:	48 98                	cltq   
  8016f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8016fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801700:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801704:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801708:	0f b6 00             	movzbl (%rax),%eax
  80170b:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80170e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801712:	75 07                	jne    80171b <strstr+0x66>
				return (char *) 0;
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
  801719:	eb 33                	jmp    80174e <strstr+0x99>
		} while (sc != c);
  80171b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80171f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801722:	75 d8                	jne    8016fc <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801724:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801728:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80172c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801730:	48 89 ce             	mov    %rcx,%rsi
  801733:	48 89 c7             	mov    %rax,%rdi
  801736:	48 b8 a5 11 80 00 00 	movabs $0x8011a5,%rax
  80173d:	00 00 00 
  801740:	ff d0                	callq  *%rax
  801742:	85 c0                	test   %eax,%eax
  801744:	75 b6                	jne    8016fc <strstr+0x47>

	return (char *) (in - 1);
  801746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174a:	48 83 e8 01          	sub    $0x1,%rax
}
  80174e:	c9                   	leaveq 
  80174f:	c3                   	retq   

0000000000801750 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801750:	55                   	push   %rbp
  801751:	48 89 e5             	mov    %rsp,%rbp
  801754:	53                   	push   %rbx
  801755:	48 83 ec 48          	sub    $0x48,%rsp
  801759:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80175c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80175f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801763:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801767:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80176b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80176f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801772:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801776:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80177a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80177e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801782:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801786:	4c 89 c3             	mov    %r8,%rbx
  801789:	cd 30                	int    $0x30
  80178b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80178f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801793:	74 3e                	je     8017d3 <syscall+0x83>
  801795:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80179a:	7e 37                	jle    8017d3 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80179c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017a0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017a3:	49 89 d0             	mov    %rdx,%r8
  8017a6:	89 c1                	mov    %eax,%ecx
  8017a8:	48 ba c8 21 80 00 00 	movabs $0x8021c8,%rdx
  8017af:	00 00 00 
  8017b2:	be 23 00 00 00       	mov    $0x23,%esi
  8017b7:	48 bf e5 21 80 00 00 	movabs $0x8021e5,%rdi
  8017be:	00 00 00 
  8017c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c6:	49 b9 26 02 80 00 00 	movabs $0x800226,%r9
  8017cd:	00 00 00 
  8017d0:	41 ff d1             	callq  *%r9

	return ret;
  8017d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017d7:	48 83 c4 48          	add    $0x48,%rsp
  8017db:	5b                   	pop    %rbx
  8017dc:	5d                   	pop    %rbp
  8017dd:	c3                   	retq   

00000000008017de <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8017de:	55                   	push   %rbp
  8017df:	48 89 e5             	mov    %rsp,%rbp
  8017e2:	48 83 ec 10          	sub    $0x10,%rsp
  8017e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8017ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f6:	48 83 ec 08          	sub    $0x8,%rsp
  8017fa:	6a 00                	pushq  $0x0
  8017fc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801802:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801808:	48 89 d1             	mov    %rdx,%rcx
  80180b:	48 89 c2             	mov    %rax,%rdx
  80180e:	be 00 00 00 00       	mov    $0x0,%esi
  801813:	bf 00 00 00 00       	mov    $0x0,%edi
  801818:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  80181f:	00 00 00 
  801822:	ff d0                	callq  *%rax
  801824:	48 83 c4 10          	add    $0x10,%rsp
}
  801828:	90                   	nop
  801829:	c9                   	leaveq 
  80182a:	c3                   	retq   

000000000080182b <sys_cgetc>:

int
sys_cgetc(void)
{
  80182b:	55                   	push   %rbp
  80182c:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80182f:	48 83 ec 08          	sub    $0x8,%rsp
  801833:	6a 00                	pushq  $0x0
  801835:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80183b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801841:	b9 00 00 00 00       	mov    $0x0,%ecx
  801846:	ba 00 00 00 00       	mov    $0x0,%edx
  80184b:	be 00 00 00 00       	mov    $0x0,%esi
  801850:	bf 01 00 00 00       	mov    $0x1,%edi
  801855:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  80185c:	00 00 00 
  80185f:	ff d0                	callq  *%rax
  801861:	48 83 c4 10          	add    $0x10,%rsp
}
  801865:	c9                   	leaveq 
  801866:	c3                   	retq   

0000000000801867 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801867:	55                   	push   %rbp
  801868:	48 89 e5             	mov    %rsp,%rbp
  80186b:	48 83 ec 10          	sub    $0x10,%rsp
  80186f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801872:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801875:	48 98                	cltq   
  801877:	48 83 ec 08          	sub    $0x8,%rsp
  80187b:	6a 00                	pushq  $0x0
  80187d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801883:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801889:	b9 00 00 00 00       	mov    $0x0,%ecx
  80188e:	48 89 c2             	mov    %rax,%rdx
  801891:	be 01 00 00 00       	mov    $0x1,%esi
  801896:	bf 03 00 00 00       	mov    $0x3,%edi
  80189b:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  8018a2:	00 00 00 
  8018a5:	ff d0                	callq  *%rax
  8018a7:	48 83 c4 10          	add    $0x10,%rsp
}
  8018ab:	c9                   	leaveq 
  8018ac:	c3                   	retq   

00000000008018ad <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018ad:	55                   	push   %rbp
  8018ae:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018b1:	48 83 ec 08          	sub    $0x8,%rsp
  8018b5:	6a 00                	pushq  $0x0
  8018b7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cd:	be 00 00 00 00       	mov    $0x0,%esi
  8018d2:	bf 02 00 00 00       	mov    $0x2,%edi
  8018d7:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  8018de:	00 00 00 
  8018e1:	ff d0                	callq  *%rax
  8018e3:	48 83 c4 10          	add    $0x10,%rsp
}
  8018e7:	c9                   	leaveq 
  8018e8:	c3                   	retq   

00000000008018e9 <sys_yield>:

void
sys_yield(void)
{
  8018e9:	55                   	push   %rbp
  8018ea:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8018ed:	48 83 ec 08          	sub    $0x8,%rsp
  8018f1:	6a 00                	pushq  $0x0
  8018f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801904:	ba 00 00 00 00       	mov    $0x0,%edx
  801909:	be 00 00 00 00       	mov    $0x0,%esi
  80190e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801913:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  80191a:	00 00 00 
  80191d:	ff d0                	callq  *%rax
  80191f:	48 83 c4 10          	add    $0x10,%rsp
}
  801923:	90                   	nop
  801924:	c9                   	leaveq 
  801925:	c3                   	retq   

0000000000801926 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801926:	55                   	push   %rbp
  801927:	48 89 e5             	mov    %rsp,%rbp
  80192a:	48 83 ec 10          	sub    $0x10,%rsp
  80192e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801931:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801935:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801938:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80193b:	48 63 c8             	movslq %eax,%rcx
  80193e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801942:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801945:	48 98                	cltq   
  801947:	48 83 ec 08          	sub    $0x8,%rsp
  80194b:	6a 00                	pushq  $0x0
  80194d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801953:	49 89 c8             	mov    %rcx,%r8
  801956:	48 89 d1             	mov    %rdx,%rcx
  801959:	48 89 c2             	mov    %rax,%rdx
  80195c:	be 01 00 00 00       	mov    $0x1,%esi
  801961:	bf 04 00 00 00       	mov    $0x4,%edi
  801966:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  80196d:	00 00 00 
  801970:	ff d0                	callq  *%rax
  801972:	48 83 c4 10          	add    $0x10,%rsp
}
  801976:	c9                   	leaveq 
  801977:	c3                   	retq   

0000000000801978 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801978:	55                   	push   %rbp
  801979:	48 89 e5             	mov    %rsp,%rbp
  80197c:	48 83 ec 20          	sub    $0x20,%rsp
  801980:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801983:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801987:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80198a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80198e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801992:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801995:	48 63 c8             	movslq %eax,%rcx
  801998:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80199c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80199f:	48 63 f0             	movslq %eax,%rsi
  8019a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a9:	48 98                	cltq   
  8019ab:	48 83 ec 08          	sub    $0x8,%rsp
  8019af:	51                   	push   %rcx
  8019b0:	49 89 f9             	mov    %rdi,%r9
  8019b3:	49 89 f0             	mov    %rsi,%r8
  8019b6:	48 89 d1             	mov    %rdx,%rcx
  8019b9:	48 89 c2             	mov    %rax,%rdx
  8019bc:	be 01 00 00 00       	mov    $0x1,%esi
  8019c1:	bf 05 00 00 00       	mov    $0x5,%edi
  8019c6:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  8019cd:	00 00 00 
  8019d0:	ff d0                	callq  *%rax
  8019d2:	48 83 c4 10          	add    $0x10,%rsp
}
  8019d6:	c9                   	leaveq 
  8019d7:	c3                   	retq   

00000000008019d8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019d8:	55                   	push   %rbp
  8019d9:	48 89 e5             	mov    %rsp,%rbp
  8019dc:	48 83 ec 10          	sub    $0x10,%rsp
  8019e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8019e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ee:	48 98                	cltq   
  8019f0:	48 83 ec 08          	sub    $0x8,%rsp
  8019f4:	6a 00                	pushq  $0x0
  8019f6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a02:	48 89 d1             	mov    %rdx,%rcx
  801a05:	48 89 c2             	mov    %rax,%rdx
  801a08:	be 01 00 00 00       	mov    $0x1,%esi
  801a0d:	bf 06 00 00 00       	mov    $0x6,%edi
  801a12:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801a19:	00 00 00 
  801a1c:	ff d0                	callq  *%rax
  801a1e:	48 83 c4 10          	add    $0x10,%rsp
}
  801a22:	c9                   	leaveq 
  801a23:	c3                   	retq   

0000000000801a24 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a24:	55                   	push   %rbp
  801a25:	48 89 e5             	mov    %rsp,%rbp
  801a28:	48 83 ec 10          	sub    $0x10,%rsp
  801a2c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a2f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a35:	48 63 d0             	movslq %eax,%rdx
  801a38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a3b:	48 98                	cltq   
  801a3d:	48 83 ec 08          	sub    $0x8,%rsp
  801a41:	6a 00                	pushq  $0x0
  801a43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4f:	48 89 d1             	mov    %rdx,%rcx
  801a52:	48 89 c2             	mov    %rax,%rdx
  801a55:	be 01 00 00 00       	mov    $0x1,%esi
  801a5a:	bf 08 00 00 00       	mov    $0x8,%edi
  801a5f:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801a66:	00 00 00 
  801a69:	ff d0                	callq  *%rax
  801a6b:	48 83 c4 10          	add    $0x10,%rsp
}
  801a6f:	c9                   	leaveq 
  801a70:	c3                   	retq   

0000000000801a71 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a71:	55                   	push   %rbp
  801a72:	48 89 e5             	mov    %rsp,%rbp
  801a75:	48 83 ec 10          	sub    $0x10,%rsp
  801a79:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a7c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a87:	48 98                	cltq   
  801a89:	48 83 ec 08          	sub    $0x8,%rsp
  801a8d:	6a 00                	pushq  $0x0
  801a8f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a95:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9b:	48 89 d1             	mov    %rdx,%rcx
  801a9e:	48 89 c2             	mov    %rax,%rdx
  801aa1:	be 01 00 00 00       	mov    $0x1,%esi
  801aa6:	bf 09 00 00 00       	mov    $0x9,%edi
  801aab:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801ab2:	00 00 00 
  801ab5:	ff d0                	callq  *%rax
  801ab7:	48 83 c4 10          	add    $0x10,%rsp
}
  801abb:	c9                   	leaveq 
  801abc:	c3                   	retq   

0000000000801abd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801abd:	55                   	push   %rbp
  801abe:	48 89 e5             	mov    %rsp,%rbp
  801ac1:	48 83 ec 20          	sub    $0x20,%rsp
  801ac5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801acc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ad0:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ad3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ad6:	48 63 f0             	movslq %eax,%rsi
  801ad9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801add:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae0:	48 98                	cltq   
  801ae2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae6:	48 83 ec 08          	sub    $0x8,%rsp
  801aea:	6a 00                	pushq  $0x0
  801aec:	49 89 f1             	mov    %rsi,%r9
  801aef:	49 89 c8             	mov    %rcx,%r8
  801af2:	48 89 d1             	mov    %rdx,%rcx
  801af5:	48 89 c2             	mov    %rax,%rdx
  801af8:	be 00 00 00 00       	mov    $0x0,%esi
  801afd:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b02:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801b09:	00 00 00 
  801b0c:	ff d0                	callq  *%rax
  801b0e:	48 83 c4 10          	add    $0x10,%rsp
}
  801b12:	c9                   	leaveq 
  801b13:	c3                   	retq   

0000000000801b14 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b14:	55                   	push   %rbp
  801b15:	48 89 e5             	mov    %rsp,%rbp
  801b18:	48 83 ec 10          	sub    $0x10,%rsp
  801b1c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b24:	48 83 ec 08          	sub    $0x8,%rsp
  801b28:	6a 00                	pushq  $0x0
  801b2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b36:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b3b:	48 89 c2             	mov    %rax,%rdx
  801b3e:	be 01 00 00 00       	mov    $0x1,%esi
  801b43:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b48:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801b4f:	00 00 00 
  801b52:	ff d0                	callq  *%rax
  801b54:	48 83 c4 10          	add    $0x10,%rsp
}
  801b58:	c9                   	leaveq 
  801b59:	c3                   	retq   

0000000000801b5a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801b5a:	55                   	push   %rbp
  801b5b:	48 89 e5             	mov    %rsp,%rbp
  801b5e:	48 83 ec 20          	sub    $0x20,%rsp
  801b62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler==0) {
  801b66:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801b6d:	00 00 00 
  801b70:	48 8b 00             	mov    (%rax),%rax
  801b73:	48 85 c0             	test   %rax,%rax
  801b76:	0f 85 ae 00 00 00    	jne    801c2a <set_pgfault_handler+0xd0>
		//allocate space
		int result = sys_page_alloc(sys_getenvid(), (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  801b7c:	48 b8 ad 18 80 00 00 	movabs $0x8018ad,%rax
  801b83:	00 00 00 
  801b86:	ff d0                	callq  *%rax
  801b88:	ba 07 00 00 00       	mov    $0x7,%edx
  801b8d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801b92:	89 c7                	mov    %eax,%edi
  801b94:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801b9b:	00 00 00 
  801b9e:	ff d0                	callq  *%rax
  801ba0:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  801ba3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ba7:	79 2a                	jns    801bd3 <set_pgfault_handler+0x79>
			panic("sys_page_alloc for stack failed in setting page fault handler");
  801ba9:	48 ba f8 21 80 00 00 	movabs $0x8021f8,%rdx
  801bb0:	00 00 00 
  801bb3:	be 21 00 00 00       	mov    $0x21,%esi
  801bb8:	48 bf 36 22 80 00 00 	movabs $0x802236,%rdi
  801bbf:	00 00 00 
  801bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc7:	48 b9 26 02 80 00 00 	movabs $0x800226,%rcx
  801bce:	00 00 00 
  801bd1:	ff d1                	callq  *%rcx
		}

		//actual set upcall
		result = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801bd3:	48 b8 ad 18 80 00 00 	movabs $0x8018ad,%rax
  801bda:	00 00 00 
  801bdd:	ff d0                	callq  *%rax
  801bdf:	48 be 3e 1c 80 00 00 	movabs $0x801c3e,%rsi
  801be6:	00 00 00 
  801be9:	89 c7                	mov    %eax,%edi
  801beb:	48 b8 71 1a 80 00 00 	movabs $0x801a71,%rax
  801bf2:	00 00 00 
  801bf5:	ff d0                	callq  *%rax
  801bf7:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  801bfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bfe:	79 2a                	jns    801c2a <set_pgfault_handler+0xd0>
                        panic("setting upcall failed in setting page fault handler");
  801c00:	48 ba 48 22 80 00 00 	movabs $0x802248,%rdx
  801c07:	00 00 00 
  801c0a:	be 27 00 00 00       	mov    $0x27,%esi
  801c0f:	48 bf 36 22 80 00 00 	movabs $0x802236,%rdi
  801c16:	00 00 00 
  801c19:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1e:	48 b9 26 02 80 00 00 	movabs $0x800226,%rcx
  801c25:	00 00 00 
  801c28:	ff d1                	callq  *%rcx
                }
		//panic("set_pgfault_handler not implemented");
	}

	_pgfault_handler = handler;
  801c2a:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801c31:	00 00 00 
  801c34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c38:	48 89 10             	mov    %rdx,(%rax)

}
  801c3b:	90                   	nop
  801c3c:	c9                   	leaveq 
  801c3d:	c3                   	retq   

0000000000801c3e <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  801c3e:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  801c41:	48 a1 10 30 80 00 00 	movabs 0x803010,%rax
  801c48:	00 00 00 
call *%rax
  801c4b:	ff d0                	callq  *%rax
	//MAKE STACK CALCS for getting parameters
	//20 = size of stack
	//8 = size of word	

	//(20-3)*8=17*8=136
	movq 136(%rsp), %rax
  801c4d:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  801c54:	00 
	//(20-1)*8=152
	subq $8, 152(%rsp)
  801c55:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  801c5c:	00 08 
	movq 152(%rsp), %rbx
  801c5e:	48 8b 9c 24 98 00 00 	mov    0x98(%rsp),%rbx
  801c65:	00 
	movq %rax, (%rbx)
  801c66:	48 89 03             	mov    %rax,(%rbx)
	addq $16, %rsp
  801c69:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
	
    	POPA_
  801c6d:	4c 8b 3c 24          	mov    (%rsp),%r15
  801c71:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801c76:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801c7b:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801c80:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801c85:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801c8a:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801c8f:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801c94:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801c99:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801c9e:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801ca3:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801ca8:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801cad:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801cb2:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801cb7:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
	//https://www.felixcloutier.com/x86/POPF:POPFD:POPFQ.html
    	addq $8, %rsp
  801cbb:	48 83 c4 08          	add    $0x8,%rsp
    	popfq	
  801cbf:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    	popq %rsp
  801cc0:	5c                   	pop    %rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    	ret
  801cc1:	c3                   	retq   
