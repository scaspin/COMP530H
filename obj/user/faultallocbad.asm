
obj/user/faultallocbad:     file format elf64-x86-64


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
  80003c:	e8 17 01 00 00       	callq  800158 <libmain>
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
  800061:	48 bf a0 1c 80 00 00 	movabs $0x801ca0,%rdi
  800068:	00 00 00 
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
  800070:	48 ba 36 04 80 00 00 	movabs $0x800436,%rdx
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
  80009b:	48 b8 fc 18 80 00 00 	movabs $0x8018fc,%rax
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
  8000bd:	48 ba b0 1c 80 00 00 	movabs $0x801cb0,%rdx
  8000c4:	00 00 00 
  8000c7:	be 0f 00 00 00       	mov    $0xf,%esi
  8000cc:	48 bf db 1c 80 00 00 	movabs $0x801cdb,%rdi
  8000d3:	00 00 00 
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	49 b9 fc 01 80 00 00 	movabs $0x8001fc,%r9
  8000e2:	00 00 00 
  8000e5:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	48 89 d1             	mov    %rdx,%rcx
  8000f3:	48 ba f0 1c 80 00 00 	movabs $0x801cf0,%rdx
  8000fa:	00 00 00 
  8000fd:	be 64 00 00 00       	mov    $0x64,%esi
  800102:	48 89 c7             	mov    %rax,%rdi
  800105:	b8 00 00 00 00       	mov    $0x0,%eax
  80010a:	49 b8 79 0e 80 00 00 	movabs $0x800e79,%r8
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
  800133:	48 b8 30 1b 80 00 00 	movabs $0x801b30,%rax
  80013a:	00 00 00 
  80013d:	ff d0                	callq  *%rax
	sys_cputs((char*)0xDEADBEEF, 4);
  80013f:	be 04 00 00 00       	mov    $0x4,%esi
  800144:	bf ef be ad de       	mov    $0xdeadbeef,%edi
  800149:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  800150:	00 00 00 
  800153:	ff d0                	callq  *%rax
}
  800155:	90                   	nop
  800156:	c9                   	leaveq 
  800157:	c3                   	retq   

0000000000800158 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800158:	55                   	push   %rbp
  800159:	48 89 e5             	mov    %rsp,%rbp
  80015c:	48 83 ec 10          	sub    $0x10,%rsp
  800160:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800163:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  800167:	48 b8 83 18 80 00 00 	movabs $0x801883,%rax
  80016e:	00 00 00 
  800171:	ff d0                	callq  *%rax
  800173:	25 ff 03 00 00       	and    $0x3ff,%eax
  800178:	48 63 d0             	movslq %eax,%rdx
  80017b:	48 89 d0             	mov    %rdx,%rax
  80017e:	48 c1 e0 03          	shl    $0x3,%rax
  800182:	48 01 d0             	add    %rdx,%rax
  800185:	48 c1 e0 05          	shl    $0x5,%rax
  800189:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800190:	00 00 00 
  800193:	48 01 c2             	add    %rax,%rdx
  800196:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80019d:	00 00 00 
  8001a0:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001a7:	7e 14                	jle    8001bd <libmain+0x65>
		binaryname = argv[0];
  8001a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ad:	48 8b 10             	mov    (%rax),%rdx
  8001b0:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8001b7:	00 00 00 
  8001ba:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001c4:	48 89 d6             	mov    %rdx,%rsi
  8001c7:	89 c7                	mov    %eax,%edi
  8001c9:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  8001d0:	00 00 00 
  8001d3:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001d5:	48 b8 e4 01 80 00 00 	movabs $0x8001e4,%rax
  8001dc:	00 00 00 
  8001df:	ff d0                	callq  *%rax
}
  8001e1:	90                   	nop
  8001e2:	c9                   	leaveq 
  8001e3:	c3                   	retq   

00000000008001e4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e4:	55                   	push   %rbp
  8001e5:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8001e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ed:	48 b8 3d 18 80 00 00 	movabs $0x80183d,%rax
  8001f4:	00 00 00 
  8001f7:	ff d0                	callq  *%rax
}
  8001f9:	90                   	nop
  8001fa:	5d                   	pop    %rbp
  8001fb:	c3                   	retq   

00000000008001fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001fc:	55                   	push   %rbp
  8001fd:	48 89 e5             	mov    %rsp,%rbp
  800200:	53                   	push   %rbx
  800201:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800208:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80020f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800215:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80021c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800223:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80022a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800231:	84 c0                	test   %al,%al
  800233:	74 23                	je     800258 <_panic+0x5c>
  800235:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80023c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800240:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800244:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800248:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80024c:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800250:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800254:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800258:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80025f:	00 00 00 
  800262:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800269:	00 00 00 
  80026c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800270:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800277:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80027e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800285:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80028c:	00 00 00 
  80028f:	48 8b 18             	mov    (%rax),%rbx
  800292:	48 b8 83 18 80 00 00 	movabs $0x801883,%rax
  800299:	00 00 00 
  80029c:	ff d0                	callq  *%rax
  80029e:	89 c6                	mov    %eax,%esi
  8002a0:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8002a6:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8002ad:	41 89 d0             	mov    %edx,%r8d
  8002b0:	48 89 c1             	mov    %rax,%rcx
  8002b3:	48 89 da             	mov    %rbx,%rdx
  8002b6:	48 bf 20 1d 80 00 00 	movabs $0x801d20,%rdi
  8002bd:	00 00 00 
  8002c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c5:	49 b9 36 04 80 00 00 	movabs $0x800436,%r9
  8002cc:	00 00 00 
  8002cf:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002d2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8002d9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8002e0:	48 89 d6             	mov    %rdx,%rsi
  8002e3:	48 89 c7             	mov    %rax,%rdi
  8002e6:	48 b8 8a 03 80 00 00 	movabs $0x80038a,%rax
  8002ed:	00 00 00 
  8002f0:	ff d0                	callq  *%rax
	cprintf("\n");
  8002f2:	48 bf 43 1d 80 00 00 	movabs $0x801d43,%rdi
  8002f9:	00 00 00 
  8002fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800301:	48 ba 36 04 80 00 00 	movabs $0x800436,%rdx
  800308:	00 00 00 
  80030b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80030d:	cc                   	int3   
  80030e:	eb fd                	jmp    80030d <_panic+0x111>

0000000000800310 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800310:	55                   	push   %rbp
  800311:	48 89 e5             	mov    %rsp,%rbp
  800314:	48 83 ec 10          	sub    $0x10,%rsp
  800318:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80031b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80031f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800323:	8b 00                	mov    (%rax),%eax
  800325:	8d 48 01             	lea    0x1(%rax),%ecx
  800328:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80032c:	89 0a                	mov    %ecx,(%rdx)
  80032e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800331:	89 d1                	mov    %edx,%ecx
  800333:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800337:	48 98                	cltq   
  800339:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80033d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800341:	8b 00                	mov    (%rax),%eax
  800343:	3d ff 00 00 00       	cmp    $0xff,%eax
  800348:	75 2c                	jne    800376 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80034a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80034e:	8b 00                	mov    (%rax),%eax
  800350:	48 98                	cltq   
  800352:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800356:	48 83 c2 08          	add    $0x8,%rdx
  80035a:	48 89 c6             	mov    %rax,%rsi
  80035d:	48 89 d7             	mov    %rdx,%rdi
  800360:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  800367:	00 00 00 
  80036a:	ff d0                	callq  *%rax
        b->idx = 0;
  80036c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800370:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800376:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80037a:	8b 40 04             	mov    0x4(%rax),%eax
  80037d:	8d 50 01             	lea    0x1(%rax),%edx
  800380:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800384:	89 50 04             	mov    %edx,0x4(%rax)
}
  800387:	90                   	nop
  800388:	c9                   	leaveq 
  800389:	c3                   	retq   

000000000080038a <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80038a:	55                   	push   %rbp
  80038b:	48 89 e5             	mov    %rsp,%rbp
  80038e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800395:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80039c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003a3:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003aa:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003b1:	48 8b 0a             	mov    (%rdx),%rcx
  8003b4:	48 89 08             	mov    %rcx,(%rax)
  8003b7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003bb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003bf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003c3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8003c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8003ce:	00 00 00 
    b.cnt = 0;
  8003d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8003d8:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8003db:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8003e2:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8003e9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8003f0:	48 89 c6             	mov    %rax,%rsi
  8003f3:	48 bf 10 03 80 00 00 	movabs $0x800310,%rdi
  8003fa:	00 00 00 
  8003fd:	48 b8 d4 07 80 00 00 	movabs $0x8007d4,%rax
  800404:	00 00 00 
  800407:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800409:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80040f:	48 98                	cltq   
  800411:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800418:	48 83 c2 08          	add    $0x8,%rdx
  80041c:	48 89 c6             	mov    %rax,%rsi
  80041f:	48 89 d7             	mov    %rdx,%rdi
  800422:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  800429:	00 00 00 
  80042c:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80042e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800434:	c9                   	leaveq 
  800435:	c3                   	retq   

0000000000800436 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800436:	55                   	push   %rbp
  800437:	48 89 e5             	mov    %rsp,%rbp
  80043a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800441:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800448:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80044f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800456:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80045d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800464:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80046b:	84 c0                	test   %al,%al
  80046d:	74 20                	je     80048f <cprintf+0x59>
  80046f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800473:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800477:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80047b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80047f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800483:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800487:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80048b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80048f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800496:	00 00 00 
  800499:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004a0:	00 00 00 
  8004a3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004a7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004ae:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004b5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8004bc:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004c3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004ca:	48 8b 0a             	mov    (%rdx),%rcx
  8004cd:	48 89 08             	mov    %rcx,(%rax)
  8004d0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004d4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004d8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004dc:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8004e0:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8004e7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004ee:	48 89 d6             	mov    %rdx,%rsi
  8004f1:	48 89 c7             	mov    %rax,%rdi
  8004f4:	48 b8 8a 03 80 00 00 	movabs $0x80038a,%rax
  8004fb:	00 00 00 
  8004fe:	ff d0                	callq  *%rax
  800500:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800506:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80050c:	c9                   	leaveq 
  80050d:	c3                   	retq   

000000000080050e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80050e:	55                   	push   %rbp
  80050f:	48 89 e5             	mov    %rsp,%rbp
  800512:	48 83 ec 30          	sub    $0x30,%rsp
  800516:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80051a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80051e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800522:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800525:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800529:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80052d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800530:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800534:	77 54                	ja     80058a <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800536:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800539:	8d 78 ff             	lea    -0x1(%rax),%edi
  80053c:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80053f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800543:	ba 00 00 00 00       	mov    $0x0,%edx
  800548:	48 f7 f6             	div    %rsi
  80054b:	49 89 c2             	mov    %rax,%r10
  80054e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800551:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800554:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800558:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80055c:	41 89 c9             	mov    %ecx,%r9d
  80055f:	41 89 f8             	mov    %edi,%r8d
  800562:	89 d1                	mov    %edx,%ecx
  800564:	4c 89 d2             	mov    %r10,%rdx
  800567:	48 89 c7             	mov    %rax,%rdi
  80056a:	48 b8 0e 05 80 00 00 	movabs $0x80050e,%rax
  800571:	00 00 00 
  800574:	ff d0                	callq  *%rax
  800576:	eb 1c                	jmp    800594 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800578:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80057c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80057f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800583:	48 89 ce             	mov    %rcx,%rsi
  800586:	89 d7                	mov    %edx,%edi
  800588:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80058a:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80058e:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800592:	7f e4                	jg     800578 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800594:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800597:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059b:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a0:	48 f7 f1             	div    %rcx
  8005a3:	48 b8 b0 1e 80 00 00 	movabs $0x801eb0,%rax
  8005aa:	00 00 00 
  8005ad:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8005b1:	0f be d0             	movsbl %al,%edx
  8005b4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8005b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005bc:	48 89 ce             	mov    %rcx,%rsi
  8005bf:	89 d7                	mov    %edx,%edi
  8005c1:	ff d0                	callq  *%rax
}
  8005c3:	90                   	nop
  8005c4:	c9                   	leaveq 
  8005c5:	c3                   	retq   

00000000008005c6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005c6:	55                   	push   %rbp
  8005c7:	48 89 e5             	mov    %rsp,%rbp
  8005ca:	48 83 ec 20          	sub    $0x20,%rsp
  8005ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005d2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8005d5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005d9:	7e 4f                	jle    80062a <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8005db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005df:	8b 00                	mov    (%rax),%eax
  8005e1:	83 f8 30             	cmp    $0x30,%eax
  8005e4:	73 24                	jae    80060a <getuint+0x44>
  8005e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ea:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f2:	8b 00                	mov    (%rax),%eax
  8005f4:	89 c0                	mov    %eax,%eax
  8005f6:	48 01 d0             	add    %rdx,%rax
  8005f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fd:	8b 12                	mov    (%rdx),%edx
  8005ff:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800602:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800606:	89 0a                	mov    %ecx,(%rdx)
  800608:	eb 14                	jmp    80061e <getuint+0x58>
  80060a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800612:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800616:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80061a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061e:	48 8b 00             	mov    (%rax),%rax
  800621:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800625:	e9 9d 00 00 00       	jmpq   8006c7 <getuint+0x101>
	else if (lflag)
  80062a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80062e:	74 4c                	je     80067c <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800634:	8b 00                	mov    (%rax),%eax
  800636:	83 f8 30             	cmp    $0x30,%eax
  800639:	73 24                	jae    80065f <getuint+0x99>
  80063b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	8b 00                	mov    (%rax),%eax
  800649:	89 c0                	mov    %eax,%eax
  80064b:	48 01 d0             	add    %rdx,%rax
  80064e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800652:	8b 12                	mov    (%rdx),%edx
  800654:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800657:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065b:	89 0a                	mov    %ecx,(%rdx)
  80065d:	eb 14                	jmp    800673 <getuint+0xad>
  80065f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800663:	48 8b 40 08          	mov    0x8(%rax),%rax
  800667:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80066b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800673:	48 8b 00             	mov    (%rax),%rax
  800676:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80067a:	eb 4b                	jmp    8006c7 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  80067c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800680:	8b 00                	mov    (%rax),%eax
  800682:	83 f8 30             	cmp    $0x30,%eax
  800685:	73 24                	jae    8006ab <getuint+0xe5>
  800687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80068f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800693:	8b 00                	mov    (%rax),%eax
  800695:	89 c0                	mov    %eax,%eax
  800697:	48 01 d0             	add    %rdx,%rax
  80069a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069e:	8b 12                	mov    (%rdx),%edx
  8006a0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a7:	89 0a                	mov    %ecx,(%rdx)
  8006a9:	eb 14                	jmp    8006bf <getuint+0xf9>
  8006ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006af:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006b3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006bf:	8b 00                	mov    (%rax),%eax
  8006c1:	89 c0                	mov    %eax,%eax
  8006c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006cb:	c9                   	leaveq 
  8006cc:	c3                   	retq   

00000000008006cd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006cd:	55                   	push   %rbp
  8006ce:	48 89 e5             	mov    %rsp,%rbp
  8006d1:	48 83 ec 20          	sub    $0x20,%rsp
  8006d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8006dc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006e0:	7e 4f                	jle    800731 <getint+0x64>
		x=va_arg(*ap, long long);
  8006e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e6:	8b 00                	mov    (%rax),%eax
  8006e8:	83 f8 30             	cmp    $0x30,%eax
  8006eb:	73 24                	jae    800711 <getint+0x44>
  8006ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f9:	8b 00                	mov    (%rax),%eax
  8006fb:	89 c0                	mov    %eax,%eax
  8006fd:	48 01 d0             	add    %rdx,%rax
  800700:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800704:	8b 12                	mov    (%rdx),%edx
  800706:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800709:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070d:	89 0a                	mov    %ecx,(%rdx)
  80070f:	eb 14                	jmp    800725 <getint+0x58>
  800711:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800715:	48 8b 40 08          	mov    0x8(%rax),%rax
  800719:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80071d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800721:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800725:	48 8b 00             	mov    (%rax),%rax
  800728:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80072c:	e9 9d 00 00 00       	jmpq   8007ce <getint+0x101>
	else if (lflag)
  800731:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800735:	74 4c                	je     800783 <getint+0xb6>
		x=va_arg(*ap, long);
  800737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073b:	8b 00                	mov    (%rax),%eax
  80073d:	83 f8 30             	cmp    $0x30,%eax
  800740:	73 24                	jae    800766 <getint+0x99>
  800742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800746:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80074a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074e:	8b 00                	mov    (%rax),%eax
  800750:	89 c0                	mov    %eax,%eax
  800752:	48 01 d0             	add    %rdx,%rax
  800755:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800759:	8b 12                	mov    (%rdx),%edx
  80075b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800762:	89 0a                	mov    %ecx,(%rdx)
  800764:	eb 14                	jmp    80077a <getint+0xad>
  800766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80076e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800772:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800776:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80077a:	48 8b 00             	mov    (%rax),%rax
  80077d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800781:	eb 4b                	jmp    8007ce <getint+0x101>
	else
		x=va_arg(*ap, int);
  800783:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800787:	8b 00                	mov    (%rax),%eax
  800789:	83 f8 30             	cmp    $0x30,%eax
  80078c:	73 24                	jae    8007b2 <getint+0xe5>
  80078e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800792:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079a:	8b 00                	mov    (%rax),%eax
  80079c:	89 c0                	mov    %eax,%eax
  80079e:	48 01 d0             	add    %rdx,%rax
  8007a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a5:	8b 12                	mov    (%rdx),%edx
  8007a7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ae:	89 0a                	mov    %ecx,(%rdx)
  8007b0:	eb 14                	jmp    8007c6 <getint+0xf9>
  8007b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007ba:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c6:	8b 00                	mov    (%rax),%eax
  8007c8:	48 98                	cltq   
  8007ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007d2:	c9                   	leaveq 
  8007d3:	c3                   	retq   

00000000008007d4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007d4:	55                   	push   %rbp
  8007d5:	48 89 e5             	mov    %rsp,%rbp
  8007d8:	41 54                	push   %r12
  8007da:	53                   	push   %rbx
  8007db:	48 83 ec 60          	sub    $0x60,%rsp
  8007df:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8007e3:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8007e7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007eb:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8007ef:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8007f3:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8007f7:	48 8b 0a             	mov    (%rdx),%rcx
  8007fa:	48 89 08             	mov    %rcx,(%rax)
  8007fd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800801:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800805:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800809:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80080d:	eb 17                	jmp    800826 <vprintfmt+0x52>
			if (ch == '\0')
  80080f:	85 db                	test   %ebx,%ebx
  800811:	0f 84 b9 04 00 00    	je     800cd0 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800817:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80081b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80081f:	48 89 d6             	mov    %rdx,%rsi
  800822:	89 df                	mov    %ebx,%edi
  800824:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800826:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80082a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80082e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800832:	0f b6 00             	movzbl (%rax),%eax
  800835:	0f b6 d8             	movzbl %al,%ebx
  800838:	83 fb 25             	cmp    $0x25,%ebx
  80083b:	75 d2                	jne    80080f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80083d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800841:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800848:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80084f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800856:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80085d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800861:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800865:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800869:	0f b6 00             	movzbl (%rax),%eax
  80086c:	0f b6 d8             	movzbl %al,%ebx
  80086f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800872:	83 f8 55             	cmp    $0x55,%eax
  800875:	0f 87 22 04 00 00    	ja     800c9d <vprintfmt+0x4c9>
  80087b:	89 c0                	mov    %eax,%eax
  80087d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800884:	00 
  800885:	48 b8 d8 1e 80 00 00 	movabs $0x801ed8,%rax
  80088c:	00 00 00 
  80088f:	48 01 d0             	add    %rdx,%rax
  800892:	48 8b 00             	mov    (%rax),%rax
  800895:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800897:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80089b:	eb c0                	jmp    80085d <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80089d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008a1:	eb ba                	jmp    80085d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008aa:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008ad:	89 d0                	mov    %edx,%eax
  8008af:	c1 e0 02             	shl    $0x2,%eax
  8008b2:	01 d0                	add    %edx,%eax
  8008b4:	01 c0                	add    %eax,%eax
  8008b6:	01 d8                	add    %ebx,%eax
  8008b8:	83 e8 30             	sub    $0x30,%eax
  8008bb:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8008be:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008c2:	0f b6 00             	movzbl (%rax),%eax
  8008c5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008c8:	83 fb 2f             	cmp    $0x2f,%ebx
  8008cb:	7e 60                	jle    80092d <vprintfmt+0x159>
  8008cd:	83 fb 39             	cmp    $0x39,%ebx
  8008d0:	7f 5b                	jg     80092d <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008d2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008d7:	eb d1                	jmp    8008aa <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8008d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008dc:	83 f8 30             	cmp    $0x30,%eax
  8008df:	73 17                	jae    8008f8 <vprintfmt+0x124>
  8008e1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8008e5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008e8:	89 d2                	mov    %edx,%edx
  8008ea:	48 01 d0             	add    %rdx,%rax
  8008ed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008f0:	83 c2 08             	add    $0x8,%edx
  8008f3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008f6:	eb 0c                	jmp    800904 <vprintfmt+0x130>
  8008f8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8008fc:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800900:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800904:	8b 00                	mov    (%rax),%eax
  800906:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800909:	eb 23                	jmp    80092e <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  80090b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80090f:	0f 89 48 ff ff ff    	jns    80085d <vprintfmt+0x89>
				width = 0;
  800915:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80091c:	e9 3c ff ff ff       	jmpq   80085d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800921:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800928:	e9 30 ff ff ff       	jmpq   80085d <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80092d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80092e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800932:	0f 89 25 ff ff ff    	jns    80085d <vprintfmt+0x89>
				width = precision, precision = -1;
  800938:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80093b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80093e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800945:	e9 13 ff ff ff       	jmpq   80085d <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80094a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80094e:	e9 0a ff ff ff       	jmpq   80085d <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800953:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800956:	83 f8 30             	cmp    $0x30,%eax
  800959:	73 17                	jae    800972 <vprintfmt+0x19e>
  80095b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80095f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800962:	89 d2                	mov    %edx,%edx
  800964:	48 01 d0             	add    %rdx,%rax
  800967:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80096a:	83 c2 08             	add    $0x8,%edx
  80096d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800970:	eb 0c                	jmp    80097e <vprintfmt+0x1aa>
  800972:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800976:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80097a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80097e:	8b 10                	mov    (%rax),%edx
  800980:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800984:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800988:	48 89 ce             	mov    %rcx,%rsi
  80098b:	89 d7                	mov    %edx,%edi
  80098d:	ff d0                	callq  *%rax
			break;
  80098f:	e9 37 03 00 00       	jmpq   800ccb <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800994:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800997:	83 f8 30             	cmp    $0x30,%eax
  80099a:	73 17                	jae    8009b3 <vprintfmt+0x1df>
  80099c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009a0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009a3:	89 d2                	mov    %edx,%edx
  8009a5:	48 01 d0             	add    %rdx,%rax
  8009a8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009ab:	83 c2 08             	add    $0x8,%edx
  8009ae:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009b1:	eb 0c                	jmp    8009bf <vprintfmt+0x1eb>
  8009b3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009b7:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009bb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009bf:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8009c1:	85 db                	test   %ebx,%ebx
  8009c3:	79 02                	jns    8009c7 <vprintfmt+0x1f3>
				err = -err;
  8009c5:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009c7:	83 fb 15             	cmp    $0x15,%ebx
  8009ca:	7f 16                	jg     8009e2 <vprintfmt+0x20e>
  8009cc:	48 b8 00 1e 80 00 00 	movabs $0x801e00,%rax
  8009d3:	00 00 00 
  8009d6:	48 63 d3             	movslq %ebx,%rdx
  8009d9:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8009dd:	4d 85 e4             	test   %r12,%r12
  8009e0:	75 2e                	jne    800a10 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  8009e2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009e6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ea:	89 d9                	mov    %ebx,%ecx
  8009ec:	48 ba c1 1e 80 00 00 	movabs $0x801ec1,%rdx
  8009f3:	00 00 00 
  8009f6:	48 89 c7             	mov    %rax,%rdi
  8009f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fe:	49 b8 da 0c 80 00 00 	movabs $0x800cda,%r8
  800a05:	00 00 00 
  800a08:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a0b:	e9 bb 02 00 00       	jmpq   800ccb <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a10:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a18:	4c 89 e1             	mov    %r12,%rcx
  800a1b:	48 ba ca 1e 80 00 00 	movabs $0x801eca,%rdx
  800a22:	00 00 00 
  800a25:	48 89 c7             	mov    %rax,%rdi
  800a28:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2d:	49 b8 da 0c 80 00 00 	movabs $0x800cda,%r8
  800a34:	00 00 00 
  800a37:	41 ff d0             	callq  *%r8
			break;
  800a3a:	e9 8c 02 00 00       	jmpq   800ccb <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a42:	83 f8 30             	cmp    $0x30,%eax
  800a45:	73 17                	jae    800a5e <vprintfmt+0x28a>
  800a47:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a4b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a4e:	89 d2                	mov    %edx,%edx
  800a50:	48 01 d0             	add    %rdx,%rax
  800a53:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a56:	83 c2 08             	add    $0x8,%edx
  800a59:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a5c:	eb 0c                	jmp    800a6a <vprintfmt+0x296>
  800a5e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a62:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a66:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a6a:	4c 8b 20             	mov    (%rax),%r12
  800a6d:	4d 85 e4             	test   %r12,%r12
  800a70:	75 0a                	jne    800a7c <vprintfmt+0x2a8>
				p = "(null)";
  800a72:	49 bc cd 1e 80 00 00 	movabs $0x801ecd,%r12
  800a79:	00 00 00 
			if (width > 0 && padc != '-')
  800a7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a80:	7e 78                	jle    800afa <vprintfmt+0x326>
  800a82:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a86:	74 72                	je     800afa <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a88:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a8b:	48 98                	cltq   
  800a8d:	48 89 c6             	mov    %rax,%rsi
  800a90:	4c 89 e7             	mov    %r12,%rdi
  800a93:	48 b8 88 0f 80 00 00 	movabs $0x800f88,%rax
  800a9a:	00 00 00 
  800a9d:	ff d0                	callq  *%rax
  800a9f:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800aa2:	eb 17                	jmp    800abb <vprintfmt+0x2e7>
					putch(padc, putdat);
  800aa4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800aa8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800aac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab0:	48 89 ce             	mov    %rcx,%rsi
  800ab3:	89 d7                	mov    %edx,%edi
  800ab5:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ab7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800abb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800abf:	7f e3                	jg     800aa4 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ac1:	eb 37                	jmp    800afa <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800ac3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ac7:	74 1e                	je     800ae7 <vprintfmt+0x313>
  800ac9:	83 fb 1f             	cmp    $0x1f,%ebx
  800acc:	7e 05                	jle    800ad3 <vprintfmt+0x2ff>
  800ace:	83 fb 7e             	cmp    $0x7e,%ebx
  800ad1:	7e 14                	jle    800ae7 <vprintfmt+0x313>
					putch('?', putdat);
  800ad3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800adb:	48 89 d6             	mov    %rdx,%rsi
  800ade:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ae3:	ff d0                	callq  *%rax
  800ae5:	eb 0f                	jmp    800af6 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800ae7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aeb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aef:	48 89 d6             	mov    %rdx,%rsi
  800af2:	89 df                	mov    %ebx,%edi
  800af4:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800af6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800afa:	4c 89 e0             	mov    %r12,%rax
  800afd:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b01:	0f b6 00             	movzbl (%rax),%eax
  800b04:	0f be d8             	movsbl %al,%ebx
  800b07:	85 db                	test   %ebx,%ebx
  800b09:	74 28                	je     800b33 <vprintfmt+0x35f>
  800b0b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b0f:	78 b2                	js     800ac3 <vprintfmt+0x2ef>
  800b11:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b15:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b19:	79 a8                	jns    800ac3 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b1b:	eb 16                	jmp    800b33 <vprintfmt+0x35f>
				putch(' ', putdat);
  800b1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b25:	48 89 d6             	mov    %rdx,%rsi
  800b28:	bf 20 00 00 00       	mov    $0x20,%edi
  800b2d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b2f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b33:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b37:	7f e4                	jg     800b1d <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800b39:	e9 8d 01 00 00       	jmpq   800ccb <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b3e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b42:	be 03 00 00 00       	mov    $0x3,%esi
  800b47:	48 89 c7             	mov    %rax,%rdi
  800b4a:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  800b51:	00 00 00 
  800b54:	ff d0                	callq  *%rax
  800b56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5e:	48 85 c0             	test   %rax,%rax
  800b61:	79 1d                	jns    800b80 <vprintfmt+0x3ac>
				putch('-', putdat);
  800b63:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6b:	48 89 d6             	mov    %rdx,%rsi
  800b6e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b73:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b79:	48 f7 d8             	neg    %rax
  800b7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b80:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b87:	e9 d2 00 00 00       	jmpq   800c5e <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b8c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b90:	be 03 00 00 00       	mov    $0x3,%esi
  800b95:	48 89 c7             	mov    %rax,%rdi
  800b98:	48 b8 c6 05 80 00 00 	movabs $0x8005c6,%rax
  800b9f:	00 00 00 
  800ba2:	ff d0                	callq  *%rax
  800ba4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ba8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800baf:	e9 aa 00 00 00       	jmpq   800c5e <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800bb4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bb8:	be 03 00 00 00       	mov    $0x3,%esi
  800bbd:	48 89 c7             	mov    %rax,%rdi
  800bc0:	48 b8 c6 05 80 00 00 	movabs $0x8005c6,%rax
  800bc7:	00 00 00 
  800bca:	ff d0                	callq  *%rax
  800bcc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800bd0:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800bd7:	e9 82 00 00 00       	jmpq   800c5e <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800bdc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be4:	48 89 d6             	mov    %rdx,%rsi
  800be7:	bf 30 00 00 00       	mov    $0x30,%edi
  800bec:	ff d0                	callq  *%rax
			putch('x', putdat);
  800bee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf6:	48 89 d6             	mov    %rdx,%rsi
  800bf9:	bf 78 00 00 00       	mov    $0x78,%edi
  800bfe:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c03:	83 f8 30             	cmp    $0x30,%eax
  800c06:	73 17                	jae    800c1f <vprintfmt+0x44b>
  800c08:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c0c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c0f:	89 d2                	mov    %edx,%edx
  800c11:	48 01 d0             	add    %rdx,%rax
  800c14:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c17:	83 c2 08             	add    $0x8,%edx
  800c1a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c1d:	eb 0c                	jmp    800c2b <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800c1f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c23:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c27:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c2b:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c32:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c39:	eb 23                	jmp    800c5e <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c3b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c3f:	be 03 00 00 00       	mov    $0x3,%esi
  800c44:	48 89 c7             	mov    %rax,%rdi
  800c47:	48 b8 c6 05 80 00 00 	movabs $0x8005c6,%rax
  800c4e:	00 00 00 
  800c51:	ff d0                	callq  *%rax
  800c53:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c57:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c5e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c63:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c66:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c69:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c6d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c75:	45 89 c1             	mov    %r8d,%r9d
  800c78:	41 89 f8             	mov    %edi,%r8d
  800c7b:	48 89 c7             	mov    %rax,%rdi
  800c7e:	48 b8 0e 05 80 00 00 	movabs $0x80050e,%rax
  800c85:	00 00 00 
  800c88:	ff d0                	callq  *%rax
			break;
  800c8a:	eb 3f                	jmp    800ccb <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c8c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c94:	48 89 d6             	mov    %rdx,%rsi
  800c97:	89 df                	mov    %ebx,%edi
  800c99:	ff d0                	callq  *%rax
			break;
  800c9b:	eb 2e                	jmp    800ccb <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c9d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca5:	48 89 d6             	mov    %rdx,%rsi
  800ca8:	bf 25 00 00 00       	mov    $0x25,%edi
  800cad:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800caf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800cb4:	eb 05                	jmp    800cbb <vprintfmt+0x4e7>
  800cb6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800cbb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cbf:	48 83 e8 01          	sub    $0x1,%rax
  800cc3:	0f b6 00             	movzbl (%rax),%eax
  800cc6:	3c 25                	cmp    $0x25,%al
  800cc8:	75 ec                	jne    800cb6 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800cca:	90                   	nop
		}
	}
  800ccb:	e9 3d fb ff ff       	jmpq   80080d <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cd0:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800cd1:	48 83 c4 60          	add    $0x60,%rsp
  800cd5:	5b                   	pop    %rbx
  800cd6:	41 5c                	pop    %r12
  800cd8:	5d                   	pop    %rbp
  800cd9:	c3                   	retq   

0000000000800cda <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cda:	55                   	push   %rbp
  800cdb:	48 89 e5             	mov    %rsp,%rbp
  800cde:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ce5:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800cec:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800cf3:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800cfa:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d01:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d08:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d0f:	84 c0                	test   %al,%al
  800d11:	74 20                	je     800d33 <printfmt+0x59>
  800d13:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d17:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d1b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d1f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d23:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d27:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d2b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d2f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d33:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d3a:	00 00 00 
  800d3d:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d44:	00 00 00 
  800d47:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d4b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d52:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d59:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d60:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d67:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d6e:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d75:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d7c:	48 89 c7             	mov    %rax,%rdi
  800d7f:	48 b8 d4 07 80 00 00 	movabs $0x8007d4,%rax
  800d86:	00 00 00 
  800d89:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d8b:	90                   	nop
  800d8c:	c9                   	leaveq 
  800d8d:	c3                   	retq   

0000000000800d8e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d8e:	55                   	push   %rbp
  800d8f:	48 89 e5             	mov    %rsp,%rbp
  800d92:	48 83 ec 10          	sub    $0x10,%rsp
  800d96:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d99:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800da1:	8b 40 10             	mov    0x10(%rax),%eax
  800da4:	8d 50 01             	lea    0x1(%rax),%edx
  800da7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dab:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800dae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800db2:	48 8b 10             	mov    (%rax),%rdx
  800db5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800db9:	48 8b 40 08          	mov    0x8(%rax),%rax
  800dbd:	48 39 c2             	cmp    %rax,%rdx
  800dc0:	73 17                	jae    800dd9 <sprintputch+0x4b>
		*b->buf++ = ch;
  800dc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dc6:	48 8b 00             	mov    (%rax),%rax
  800dc9:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800dcd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800dd1:	48 89 0a             	mov    %rcx,(%rdx)
  800dd4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800dd7:	88 10                	mov    %dl,(%rax)
}
  800dd9:	90                   	nop
  800dda:	c9                   	leaveq 
  800ddb:	c3                   	retq   

0000000000800ddc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ddc:	55                   	push   %rbp
  800ddd:	48 89 e5             	mov    %rsp,%rbp
  800de0:	48 83 ec 50          	sub    $0x50,%rsp
  800de4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800de8:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800deb:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800def:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800df3:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800df7:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800dfb:	48 8b 0a             	mov    (%rdx),%rcx
  800dfe:	48 89 08             	mov    %rcx,(%rax)
  800e01:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e05:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e09:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e0d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e11:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e15:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e19:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e1c:	48 98                	cltq   
  800e1e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e22:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e26:	48 01 d0             	add    %rdx,%rax
  800e29:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e2d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e34:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e39:	74 06                	je     800e41 <vsnprintf+0x65>
  800e3b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e3f:	7f 07                	jg     800e48 <vsnprintf+0x6c>
		return -E_INVAL;
  800e41:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e46:	eb 2f                	jmp    800e77 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e48:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e4c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e50:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e54:	48 89 c6             	mov    %rax,%rsi
  800e57:	48 bf 8e 0d 80 00 00 	movabs $0x800d8e,%rdi
  800e5e:	00 00 00 
  800e61:	48 b8 d4 07 80 00 00 	movabs $0x8007d4,%rax
  800e68:	00 00 00 
  800e6b:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e6d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e71:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e74:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e77:	c9                   	leaveq 
  800e78:	c3                   	retq   

0000000000800e79 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e79:	55                   	push   %rbp
  800e7a:	48 89 e5             	mov    %rsp,%rbp
  800e7d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e84:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e8b:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e91:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800e98:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e9f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ea6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ead:	84 c0                	test   %al,%al
  800eaf:	74 20                	je     800ed1 <snprintf+0x58>
  800eb1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800eb5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800eb9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ebd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ec1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ec5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ec9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ecd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ed1:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800ed8:	00 00 00 
  800edb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800ee2:	00 00 00 
  800ee5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ee9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ef0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ef7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800efe:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f05:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f0c:	48 8b 0a             	mov    (%rdx),%rcx
  800f0f:	48 89 08             	mov    %rcx,(%rax)
  800f12:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f16:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f1a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f1e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f22:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f29:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f30:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f36:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f3d:	48 89 c7             	mov    %rax,%rdi
  800f40:	48 b8 dc 0d 80 00 00 	movabs $0x800ddc,%rax
  800f47:	00 00 00 
  800f4a:	ff d0                	callq  *%rax
  800f4c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f52:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f58:	c9                   	leaveq 
  800f59:	c3                   	retq   

0000000000800f5a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f5a:	55                   	push   %rbp
  800f5b:	48 89 e5             	mov    %rsp,%rbp
  800f5e:	48 83 ec 18          	sub    $0x18,%rsp
  800f62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f6d:	eb 09                	jmp    800f78 <strlen+0x1e>
		n++;
  800f6f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f73:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7c:	0f b6 00             	movzbl (%rax),%eax
  800f7f:	84 c0                	test   %al,%al
  800f81:	75 ec                	jne    800f6f <strlen+0x15>
		n++;
	return n;
  800f83:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f86:	c9                   	leaveq 
  800f87:	c3                   	retq   

0000000000800f88 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f88:	55                   	push   %rbp
  800f89:	48 89 e5             	mov    %rsp,%rbp
  800f8c:	48 83 ec 20          	sub    $0x20,%rsp
  800f90:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f9f:	eb 0e                	jmp    800faf <strnlen+0x27>
		n++;
  800fa1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fa5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800faa:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800faf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800fb4:	74 0b                	je     800fc1 <strnlen+0x39>
  800fb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fba:	0f b6 00             	movzbl (%rax),%eax
  800fbd:	84 c0                	test   %al,%al
  800fbf:	75 e0                	jne    800fa1 <strnlen+0x19>
		n++;
	return n;
  800fc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fc4:	c9                   	leaveq 
  800fc5:	c3                   	retq   

0000000000800fc6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fc6:	55                   	push   %rbp
  800fc7:	48 89 e5             	mov    %rsp,%rbp
  800fca:	48 83 ec 20          	sub    $0x20,%rsp
  800fce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fd2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fda:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800fde:	90                   	nop
  800fdf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fe7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800feb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fef:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ff3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ff7:	0f b6 12             	movzbl (%rdx),%edx
  800ffa:	88 10                	mov    %dl,(%rax)
  800ffc:	0f b6 00             	movzbl (%rax),%eax
  800fff:	84 c0                	test   %al,%al
  801001:	75 dc                	jne    800fdf <strcpy+0x19>
		/* do nothing */;
	return ret;
  801003:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801007:	c9                   	leaveq 
  801008:	c3                   	retq   

0000000000801009 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801009:	55                   	push   %rbp
  80100a:	48 89 e5             	mov    %rsp,%rbp
  80100d:	48 83 ec 20          	sub    $0x20,%rsp
  801011:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801015:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801019:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101d:	48 89 c7             	mov    %rax,%rdi
  801020:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  801027:	00 00 00 
  80102a:	ff d0                	callq  *%rax
  80102c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80102f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801032:	48 63 d0             	movslq %eax,%rdx
  801035:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801039:	48 01 c2             	add    %rax,%rdx
  80103c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801040:	48 89 c6             	mov    %rax,%rsi
  801043:	48 89 d7             	mov    %rdx,%rdi
  801046:	48 b8 c6 0f 80 00 00 	movabs $0x800fc6,%rax
  80104d:	00 00 00 
  801050:	ff d0                	callq  *%rax
	return dst;
  801052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801056:	c9                   	leaveq 
  801057:	c3                   	retq   

0000000000801058 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801058:	55                   	push   %rbp
  801059:	48 89 e5             	mov    %rsp,%rbp
  80105c:	48 83 ec 28          	sub    $0x28,%rsp
  801060:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801064:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801068:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80106c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801070:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801074:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80107b:	00 
  80107c:	eb 2a                	jmp    8010a8 <strncpy+0x50>
		*dst++ = *src;
  80107e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801082:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801086:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80108a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80108e:	0f b6 12             	movzbl (%rdx),%edx
  801091:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801093:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801097:	0f b6 00             	movzbl (%rax),%eax
  80109a:	84 c0                	test   %al,%al
  80109c:	74 05                	je     8010a3 <strncpy+0x4b>
			src++;
  80109e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010a3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ac:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010b0:	72 cc                	jb     80107e <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8010b6:	c9                   	leaveq 
  8010b7:	c3                   	retq   

00000000008010b8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010b8:	55                   	push   %rbp
  8010b9:	48 89 e5             	mov    %rsp,%rbp
  8010bc:	48 83 ec 28          	sub    $0x28,%rsp
  8010c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010c8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8010cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8010d4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010d9:	74 3d                	je     801118 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8010db:	eb 1d                	jmp    8010fa <strlcpy+0x42>
			*dst++ = *src++;
  8010dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010e5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010e9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010ed:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010f1:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010f5:	0f b6 12             	movzbl (%rdx),%edx
  8010f8:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010fa:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010ff:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801104:	74 0b                	je     801111 <strlcpy+0x59>
  801106:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80110a:	0f b6 00             	movzbl (%rax),%eax
  80110d:	84 c0                	test   %al,%al
  80110f:	75 cc                	jne    8010dd <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801115:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801118:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80111c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801120:	48 29 c2             	sub    %rax,%rdx
  801123:	48 89 d0             	mov    %rdx,%rax
}
  801126:	c9                   	leaveq 
  801127:	c3                   	retq   

0000000000801128 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801128:	55                   	push   %rbp
  801129:	48 89 e5             	mov    %rsp,%rbp
  80112c:	48 83 ec 10          	sub    $0x10,%rsp
  801130:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801134:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801138:	eb 0a                	jmp    801144 <strcmp+0x1c>
		p++, q++;
  80113a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80113f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801144:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801148:	0f b6 00             	movzbl (%rax),%eax
  80114b:	84 c0                	test   %al,%al
  80114d:	74 12                	je     801161 <strcmp+0x39>
  80114f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801153:	0f b6 10             	movzbl (%rax),%edx
  801156:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80115a:	0f b6 00             	movzbl (%rax),%eax
  80115d:	38 c2                	cmp    %al,%dl
  80115f:	74 d9                	je     80113a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801161:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801165:	0f b6 00             	movzbl (%rax),%eax
  801168:	0f b6 d0             	movzbl %al,%edx
  80116b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80116f:	0f b6 00             	movzbl (%rax),%eax
  801172:	0f b6 c0             	movzbl %al,%eax
  801175:	29 c2                	sub    %eax,%edx
  801177:	89 d0                	mov    %edx,%eax
}
  801179:	c9                   	leaveq 
  80117a:	c3                   	retq   

000000000080117b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80117b:	55                   	push   %rbp
  80117c:	48 89 e5             	mov    %rsp,%rbp
  80117f:	48 83 ec 18          	sub    $0x18,%rsp
  801183:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801187:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80118b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80118f:	eb 0f                	jmp    8011a0 <strncmp+0x25>
		n--, p++, q++;
  801191:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801196:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80119b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011a0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011a5:	74 1d                	je     8011c4 <strncmp+0x49>
  8011a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ab:	0f b6 00             	movzbl (%rax),%eax
  8011ae:	84 c0                	test   %al,%al
  8011b0:	74 12                	je     8011c4 <strncmp+0x49>
  8011b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b6:	0f b6 10             	movzbl (%rax),%edx
  8011b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bd:	0f b6 00             	movzbl (%rax),%eax
  8011c0:	38 c2                	cmp    %al,%dl
  8011c2:	74 cd                	je     801191 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8011c4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011c9:	75 07                	jne    8011d2 <strncmp+0x57>
		return 0;
  8011cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d0:	eb 18                	jmp    8011ea <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d6:	0f b6 00             	movzbl (%rax),%eax
  8011d9:	0f b6 d0             	movzbl %al,%edx
  8011dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e0:	0f b6 00             	movzbl (%rax),%eax
  8011e3:	0f b6 c0             	movzbl %al,%eax
  8011e6:	29 c2                	sub    %eax,%edx
  8011e8:	89 d0                	mov    %edx,%eax
}
  8011ea:	c9                   	leaveq 
  8011eb:	c3                   	retq   

00000000008011ec <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011ec:	55                   	push   %rbp
  8011ed:	48 89 e5             	mov    %rsp,%rbp
  8011f0:	48 83 ec 10          	sub    $0x10,%rsp
  8011f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011f8:	89 f0                	mov    %esi,%eax
  8011fa:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011fd:	eb 17                	jmp    801216 <strchr+0x2a>
		if (*s == c)
  8011ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801203:	0f b6 00             	movzbl (%rax),%eax
  801206:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801209:	75 06                	jne    801211 <strchr+0x25>
			return (char *) s;
  80120b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120f:	eb 15                	jmp    801226 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801211:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801216:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121a:	0f b6 00             	movzbl (%rax),%eax
  80121d:	84 c0                	test   %al,%al
  80121f:	75 de                	jne    8011ff <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801221:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801226:	c9                   	leaveq 
  801227:	c3                   	retq   

0000000000801228 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801228:	55                   	push   %rbp
  801229:	48 89 e5             	mov    %rsp,%rbp
  80122c:	48 83 ec 10          	sub    $0x10,%rsp
  801230:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801234:	89 f0                	mov    %esi,%eax
  801236:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801239:	eb 11                	jmp    80124c <strfind+0x24>
		if (*s == c)
  80123b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123f:	0f b6 00             	movzbl (%rax),%eax
  801242:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801245:	74 12                	je     801259 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801247:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80124c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801250:	0f b6 00             	movzbl (%rax),%eax
  801253:	84 c0                	test   %al,%al
  801255:	75 e4                	jne    80123b <strfind+0x13>
  801257:	eb 01                	jmp    80125a <strfind+0x32>
		if (*s == c)
			break;
  801259:	90                   	nop
	return (char *) s;
  80125a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80125e:	c9                   	leaveq 
  80125f:	c3                   	retq   

0000000000801260 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801260:	55                   	push   %rbp
  801261:	48 89 e5             	mov    %rsp,%rbp
  801264:	48 83 ec 18          	sub    $0x18,%rsp
  801268:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80126c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80126f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801273:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801278:	75 06                	jne    801280 <memset+0x20>
		return v;
  80127a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127e:	eb 69                	jmp    8012e9 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801284:	83 e0 03             	and    $0x3,%eax
  801287:	48 85 c0             	test   %rax,%rax
  80128a:	75 48                	jne    8012d4 <memset+0x74>
  80128c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801290:	83 e0 03             	and    $0x3,%eax
  801293:	48 85 c0             	test   %rax,%rax
  801296:	75 3c                	jne    8012d4 <memset+0x74>
		c &= 0xFF;
  801298:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80129f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012a2:	c1 e0 18             	shl    $0x18,%eax
  8012a5:	89 c2                	mov    %eax,%edx
  8012a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012aa:	c1 e0 10             	shl    $0x10,%eax
  8012ad:	09 c2                	or     %eax,%edx
  8012af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012b2:	c1 e0 08             	shl    $0x8,%eax
  8012b5:	09 d0                	or     %edx,%eax
  8012b7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8012ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012be:	48 c1 e8 02          	shr    $0x2,%rax
  8012c2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8012c5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012cc:	48 89 d7             	mov    %rdx,%rdi
  8012cf:	fc                   	cld    
  8012d0:	f3 ab                	rep stos %eax,%es:(%rdi)
  8012d2:	eb 11                	jmp    8012e5 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8012d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012db:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8012df:	48 89 d7             	mov    %rdx,%rdi
  8012e2:	fc                   	cld    
  8012e3:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8012e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012e9:	c9                   	leaveq 
  8012ea:	c3                   	retq   

00000000008012eb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012eb:	55                   	push   %rbp
  8012ec:	48 89 e5             	mov    %rsp,%rbp
  8012ef:	48 83 ec 28          	sub    $0x28,%rsp
  8012f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801303:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801307:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80130f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801313:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801317:	0f 83 88 00 00 00    	jae    8013a5 <memmove+0xba>
  80131d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801321:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801325:	48 01 d0             	add    %rdx,%rax
  801328:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80132c:	76 77                	jbe    8013a5 <memmove+0xba>
		s += n;
  80132e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801332:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801336:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80133a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80133e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801342:	83 e0 03             	and    $0x3,%eax
  801345:	48 85 c0             	test   %rax,%rax
  801348:	75 3b                	jne    801385 <memmove+0x9a>
  80134a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134e:	83 e0 03             	and    $0x3,%eax
  801351:	48 85 c0             	test   %rax,%rax
  801354:	75 2f                	jne    801385 <memmove+0x9a>
  801356:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135a:	83 e0 03             	and    $0x3,%eax
  80135d:	48 85 c0             	test   %rax,%rax
  801360:	75 23                	jne    801385 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801362:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801366:	48 83 e8 04          	sub    $0x4,%rax
  80136a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80136e:	48 83 ea 04          	sub    $0x4,%rdx
  801372:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801376:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80137a:	48 89 c7             	mov    %rax,%rdi
  80137d:	48 89 d6             	mov    %rdx,%rsi
  801380:	fd                   	std    
  801381:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801383:	eb 1d                	jmp    8013a2 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801385:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801389:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80138d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801391:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801395:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801399:	48 89 d7             	mov    %rdx,%rdi
  80139c:	48 89 c1             	mov    %rax,%rcx
  80139f:	fd                   	std    
  8013a0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013a2:	fc                   	cld    
  8013a3:	eb 57                	jmp    8013fc <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a9:	83 e0 03             	and    $0x3,%eax
  8013ac:	48 85 c0             	test   %rax,%rax
  8013af:	75 36                	jne    8013e7 <memmove+0xfc>
  8013b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b5:	83 e0 03             	and    $0x3,%eax
  8013b8:	48 85 c0             	test   %rax,%rax
  8013bb:	75 2a                	jne    8013e7 <memmove+0xfc>
  8013bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c1:	83 e0 03             	and    $0x3,%eax
  8013c4:	48 85 c0             	test   %rax,%rax
  8013c7:	75 1e                	jne    8013e7 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8013c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cd:	48 c1 e8 02          	shr    $0x2,%rax
  8013d1:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8013d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013dc:	48 89 c7             	mov    %rax,%rdi
  8013df:	48 89 d6             	mov    %rdx,%rsi
  8013e2:	fc                   	cld    
  8013e3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013e5:	eb 15                	jmp    8013fc <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ef:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013f3:	48 89 c7             	mov    %rax,%rdi
  8013f6:	48 89 d6             	mov    %rdx,%rsi
  8013f9:	fc                   	cld    
  8013fa:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801400:	c9                   	leaveq 
  801401:	c3                   	retq   

0000000000801402 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801402:	55                   	push   %rbp
  801403:	48 89 e5             	mov    %rsp,%rbp
  801406:	48 83 ec 18          	sub    $0x18,%rsp
  80140a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80140e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801412:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801416:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80141a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80141e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801422:	48 89 ce             	mov    %rcx,%rsi
  801425:	48 89 c7             	mov    %rax,%rdi
  801428:	48 b8 eb 12 80 00 00 	movabs $0x8012eb,%rax
  80142f:	00 00 00 
  801432:	ff d0                	callq  *%rax
}
  801434:	c9                   	leaveq 
  801435:	c3                   	retq   

0000000000801436 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801436:	55                   	push   %rbp
  801437:	48 89 e5             	mov    %rsp,%rbp
  80143a:	48 83 ec 28          	sub    $0x28,%rsp
  80143e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801442:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801446:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80144a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801452:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801456:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80145a:	eb 36                	jmp    801492 <memcmp+0x5c>
		if (*s1 != *s2)
  80145c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801460:	0f b6 10             	movzbl (%rax),%edx
  801463:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801467:	0f b6 00             	movzbl (%rax),%eax
  80146a:	38 c2                	cmp    %al,%dl
  80146c:	74 1a                	je     801488 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80146e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801472:	0f b6 00             	movzbl (%rax),%eax
  801475:	0f b6 d0             	movzbl %al,%edx
  801478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147c:	0f b6 00             	movzbl (%rax),%eax
  80147f:	0f b6 c0             	movzbl %al,%eax
  801482:	29 c2                	sub    %eax,%edx
  801484:	89 d0                	mov    %edx,%eax
  801486:	eb 20                	jmp    8014a8 <memcmp+0x72>
		s1++, s2++;
  801488:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80148d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801492:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801496:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80149a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80149e:	48 85 c0             	test   %rax,%rax
  8014a1:	75 b9                	jne    80145c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a8:	c9                   	leaveq 
  8014a9:	c3                   	retq   

00000000008014aa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014aa:	55                   	push   %rbp
  8014ab:	48 89 e5             	mov    %rsp,%rbp
  8014ae:	48 83 ec 28          	sub    $0x28,%rsp
  8014b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8014b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8014bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c5:	48 01 d0             	add    %rdx,%rax
  8014c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8014cc:	eb 19                	jmp    8014e7 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d2:	0f b6 00             	movzbl (%rax),%eax
  8014d5:	0f b6 d0             	movzbl %al,%edx
  8014d8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8014db:	0f b6 c0             	movzbl %al,%eax
  8014de:	39 c2                	cmp    %eax,%edx
  8014e0:	74 11                	je     8014f3 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014e2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014eb:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014ef:	72 dd                	jb     8014ce <memfind+0x24>
  8014f1:	eb 01                	jmp    8014f4 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014f3:	90                   	nop
	return (void *) s;
  8014f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014f8:	c9                   	leaveq 
  8014f9:	c3                   	retq   

00000000008014fa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014fa:	55                   	push   %rbp
  8014fb:	48 89 e5             	mov    %rsp,%rbp
  8014fe:	48 83 ec 38          	sub    $0x38,%rsp
  801502:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801506:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80150a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80150d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801514:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80151b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80151c:	eb 05                	jmp    801523 <strtol+0x29>
		s++;
  80151e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801523:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801527:	0f b6 00             	movzbl (%rax),%eax
  80152a:	3c 20                	cmp    $0x20,%al
  80152c:	74 f0                	je     80151e <strtol+0x24>
  80152e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801532:	0f b6 00             	movzbl (%rax),%eax
  801535:	3c 09                	cmp    $0x9,%al
  801537:	74 e5                	je     80151e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801539:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153d:	0f b6 00             	movzbl (%rax),%eax
  801540:	3c 2b                	cmp    $0x2b,%al
  801542:	75 07                	jne    80154b <strtol+0x51>
		s++;
  801544:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801549:	eb 17                	jmp    801562 <strtol+0x68>
	else if (*s == '-')
  80154b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154f:	0f b6 00             	movzbl (%rax),%eax
  801552:	3c 2d                	cmp    $0x2d,%al
  801554:	75 0c                	jne    801562 <strtol+0x68>
		s++, neg = 1;
  801556:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80155b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801562:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801566:	74 06                	je     80156e <strtol+0x74>
  801568:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80156c:	75 28                	jne    801596 <strtol+0x9c>
  80156e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801572:	0f b6 00             	movzbl (%rax),%eax
  801575:	3c 30                	cmp    $0x30,%al
  801577:	75 1d                	jne    801596 <strtol+0x9c>
  801579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157d:	48 83 c0 01          	add    $0x1,%rax
  801581:	0f b6 00             	movzbl (%rax),%eax
  801584:	3c 78                	cmp    $0x78,%al
  801586:	75 0e                	jne    801596 <strtol+0x9c>
		s += 2, base = 16;
  801588:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80158d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801594:	eb 2c                	jmp    8015c2 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801596:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80159a:	75 19                	jne    8015b5 <strtol+0xbb>
  80159c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a0:	0f b6 00             	movzbl (%rax),%eax
  8015a3:	3c 30                	cmp    $0x30,%al
  8015a5:	75 0e                	jne    8015b5 <strtol+0xbb>
		s++, base = 8;
  8015a7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015ac:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8015b3:	eb 0d                	jmp    8015c2 <strtol+0xc8>
	else if (base == 0)
  8015b5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015b9:	75 07                	jne    8015c2 <strtol+0xc8>
		base = 10;
  8015bb:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c6:	0f b6 00             	movzbl (%rax),%eax
  8015c9:	3c 2f                	cmp    $0x2f,%al
  8015cb:	7e 1d                	jle    8015ea <strtol+0xf0>
  8015cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d1:	0f b6 00             	movzbl (%rax),%eax
  8015d4:	3c 39                	cmp    $0x39,%al
  8015d6:	7f 12                	jg     8015ea <strtol+0xf0>
			dig = *s - '0';
  8015d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dc:	0f b6 00             	movzbl (%rax),%eax
  8015df:	0f be c0             	movsbl %al,%eax
  8015e2:	83 e8 30             	sub    $0x30,%eax
  8015e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015e8:	eb 4e                	jmp    801638 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8015ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ee:	0f b6 00             	movzbl (%rax),%eax
  8015f1:	3c 60                	cmp    $0x60,%al
  8015f3:	7e 1d                	jle    801612 <strtol+0x118>
  8015f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f9:	0f b6 00             	movzbl (%rax),%eax
  8015fc:	3c 7a                	cmp    $0x7a,%al
  8015fe:	7f 12                	jg     801612 <strtol+0x118>
			dig = *s - 'a' + 10;
  801600:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801604:	0f b6 00             	movzbl (%rax),%eax
  801607:	0f be c0             	movsbl %al,%eax
  80160a:	83 e8 57             	sub    $0x57,%eax
  80160d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801610:	eb 26                	jmp    801638 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801612:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801616:	0f b6 00             	movzbl (%rax),%eax
  801619:	3c 40                	cmp    $0x40,%al
  80161b:	7e 47                	jle    801664 <strtol+0x16a>
  80161d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801621:	0f b6 00             	movzbl (%rax),%eax
  801624:	3c 5a                	cmp    $0x5a,%al
  801626:	7f 3c                	jg     801664 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801628:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162c:	0f b6 00             	movzbl (%rax),%eax
  80162f:	0f be c0             	movsbl %al,%eax
  801632:	83 e8 37             	sub    $0x37,%eax
  801635:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801638:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80163b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80163e:	7d 23                	jge    801663 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801640:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801645:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801648:	48 98                	cltq   
  80164a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80164f:	48 89 c2             	mov    %rax,%rdx
  801652:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801655:	48 98                	cltq   
  801657:	48 01 d0             	add    %rdx,%rax
  80165a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80165e:	e9 5f ff ff ff       	jmpq   8015c2 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801663:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801664:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801669:	74 0b                	je     801676 <strtol+0x17c>
		*endptr = (char *) s;
  80166b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80166f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801673:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801676:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80167a:	74 09                	je     801685 <strtol+0x18b>
  80167c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801680:	48 f7 d8             	neg    %rax
  801683:	eb 04                	jmp    801689 <strtol+0x18f>
  801685:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801689:	c9                   	leaveq 
  80168a:	c3                   	retq   

000000000080168b <strstr>:

char * strstr(const char *in, const char *str)
{
  80168b:	55                   	push   %rbp
  80168c:	48 89 e5             	mov    %rsp,%rbp
  80168f:	48 83 ec 30          	sub    $0x30,%rsp
  801693:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801697:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80169b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80169f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016a3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016a7:	0f b6 00             	movzbl (%rax),%eax
  8016aa:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8016ad:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8016b1:	75 06                	jne    8016b9 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8016b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b7:	eb 6b                	jmp    801724 <strstr+0x99>

	len = strlen(str);
  8016b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016bd:	48 89 c7             	mov    %rax,%rdi
  8016c0:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  8016c7:	00 00 00 
  8016ca:	ff d0                	callq  *%rax
  8016cc:	48 98                	cltq   
  8016ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8016d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016de:	0f b6 00             	movzbl (%rax),%eax
  8016e1:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8016e4:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8016e8:	75 07                	jne    8016f1 <strstr+0x66>
				return (char *) 0;
  8016ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ef:	eb 33                	jmp    801724 <strstr+0x99>
		} while (sc != c);
  8016f1:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016f5:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016f8:	75 d8                	jne    8016d2 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8016fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016fe:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801702:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801706:	48 89 ce             	mov    %rcx,%rsi
  801709:	48 89 c7             	mov    %rax,%rdi
  80170c:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  801713:	00 00 00 
  801716:	ff d0                	callq  *%rax
  801718:	85 c0                	test   %eax,%eax
  80171a:	75 b6                	jne    8016d2 <strstr+0x47>

	return (char *) (in - 1);
  80171c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801720:	48 83 e8 01          	sub    $0x1,%rax
}
  801724:	c9                   	leaveq 
  801725:	c3                   	retq   

0000000000801726 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801726:	55                   	push   %rbp
  801727:	48 89 e5             	mov    %rsp,%rbp
  80172a:	53                   	push   %rbx
  80172b:	48 83 ec 48          	sub    $0x48,%rsp
  80172f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801732:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801735:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801739:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80173d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801741:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801745:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801748:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80174c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801750:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801754:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801758:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80175c:	4c 89 c3             	mov    %r8,%rbx
  80175f:	cd 30                	int    $0x30
  801761:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801765:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801769:	74 3e                	je     8017a9 <syscall+0x83>
  80176b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801770:	7e 37                	jle    8017a9 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801772:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801776:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801779:	49 89 d0             	mov    %rdx,%r8
  80177c:	89 c1                	mov    %eax,%ecx
  80177e:	48 ba 88 21 80 00 00 	movabs $0x802188,%rdx
  801785:	00 00 00 
  801788:	be 23 00 00 00       	mov    $0x23,%esi
  80178d:	48 bf a5 21 80 00 00 	movabs $0x8021a5,%rdi
  801794:	00 00 00 
  801797:	b8 00 00 00 00       	mov    $0x0,%eax
  80179c:	49 b9 fc 01 80 00 00 	movabs $0x8001fc,%r9
  8017a3:	00 00 00 
  8017a6:	41 ff d1             	callq  *%r9

	return ret;
  8017a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017ad:	48 83 c4 48          	add    $0x48,%rsp
  8017b1:	5b                   	pop    %rbx
  8017b2:	5d                   	pop    %rbp
  8017b3:	c3                   	retq   

00000000008017b4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8017b4:	55                   	push   %rbp
  8017b5:	48 89 e5             	mov    %rsp,%rbp
  8017b8:	48 83 ec 10          	sub    $0x10,%rsp
  8017bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8017c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017cc:	48 83 ec 08          	sub    $0x8,%rsp
  8017d0:	6a 00                	pushq  $0x0
  8017d2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017de:	48 89 d1             	mov    %rdx,%rcx
  8017e1:	48 89 c2             	mov    %rax,%rdx
  8017e4:	be 00 00 00 00       	mov    $0x0,%esi
  8017e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8017ee:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  8017f5:	00 00 00 
  8017f8:	ff d0                	callq  *%rax
  8017fa:	48 83 c4 10          	add    $0x10,%rsp
}
  8017fe:	90                   	nop
  8017ff:	c9                   	leaveq 
  801800:	c3                   	retq   

0000000000801801 <sys_cgetc>:

int
sys_cgetc(void)
{
  801801:	55                   	push   %rbp
  801802:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801805:	48 83 ec 08          	sub    $0x8,%rsp
  801809:	6a 00                	pushq  $0x0
  80180b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801811:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801817:	b9 00 00 00 00       	mov    $0x0,%ecx
  80181c:	ba 00 00 00 00       	mov    $0x0,%edx
  801821:	be 00 00 00 00       	mov    $0x0,%esi
  801826:	bf 01 00 00 00       	mov    $0x1,%edi
  80182b:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  801832:	00 00 00 
  801835:	ff d0                	callq  *%rax
  801837:	48 83 c4 10          	add    $0x10,%rsp
}
  80183b:	c9                   	leaveq 
  80183c:	c3                   	retq   

000000000080183d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80183d:	55                   	push   %rbp
  80183e:	48 89 e5             	mov    %rsp,%rbp
  801841:	48 83 ec 10          	sub    $0x10,%rsp
  801845:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801848:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80184b:	48 98                	cltq   
  80184d:	48 83 ec 08          	sub    $0x8,%rsp
  801851:	6a 00                	pushq  $0x0
  801853:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801859:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80185f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801864:	48 89 c2             	mov    %rax,%rdx
  801867:	be 01 00 00 00       	mov    $0x1,%esi
  80186c:	bf 03 00 00 00       	mov    $0x3,%edi
  801871:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  801878:	00 00 00 
  80187b:	ff d0                	callq  *%rax
  80187d:	48 83 c4 10          	add    $0x10,%rsp
}
  801881:	c9                   	leaveq 
  801882:	c3                   	retq   

0000000000801883 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801883:	55                   	push   %rbp
  801884:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801887:	48 83 ec 08          	sub    $0x8,%rsp
  80188b:	6a 00                	pushq  $0x0
  80188d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801893:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801899:	b9 00 00 00 00       	mov    $0x0,%ecx
  80189e:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a3:	be 00 00 00 00       	mov    $0x0,%esi
  8018a8:	bf 02 00 00 00       	mov    $0x2,%edi
  8018ad:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  8018b4:	00 00 00 
  8018b7:	ff d0                	callq  *%rax
  8018b9:	48 83 c4 10          	add    $0x10,%rsp
}
  8018bd:	c9                   	leaveq 
  8018be:	c3                   	retq   

00000000008018bf <sys_yield>:

void
sys_yield(void)
{
  8018bf:	55                   	push   %rbp
  8018c0:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8018c3:	48 83 ec 08          	sub    $0x8,%rsp
  8018c7:	6a 00                	pushq  $0x0
  8018c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018da:	ba 00 00 00 00       	mov    $0x0,%edx
  8018df:	be 00 00 00 00       	mov    $0x0,%esi
  8018e4:	bf 0a 00 00 00       	mov    $0xa,%edi
  8018e9:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  8018f0:	00 00 00 
  8018f3:	ff d0                	callq  *%rax
  8018f5:	48 83 c4 10          	add    $0x10,%rsp
}
  8018f9:	90                   	nop
  8018fa:	c9                   	leaveq 
  8018fb:	c3                   	retq   

00000000008018fc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018fc:	55                   	push   %rbp
  8018fd:	48 89 e5             	mov    %rsp,%rbp
  801900:	48 83 ec 10          	sub    $0x10,%rsp
  801904:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801907:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80190b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80190e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801911:	48 63 c8             	movslq %eax,%rcx
  801914:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801918:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80191b:	48 98                	cltq   
  80191d:	48 83 ec 08          	sub    $0x8,%rsp
  801921:	6a 00                	pushq  $0x0
  801923:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801929:	49 89 c8             	mov    %rcx,%r8
  80192c:	48 89 d1             	mov    %rdx,%rcx
  80192f:	48 89 c2             	mov    %rax,%rdx
  801932:	be 01 00 00 00       	mov    $0x1,%esi
  801937:	bf 04 00 00 00       	mov    $0x4,%edi
  80193c:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  801943:	00 00 00 
  801946:	ff d0                	callq  *%rax
  801948:	48 83 c4 10          	add    $0x10,%rsp
}
  80194c:	c9                   	leaveq 
  80194d:	c3                   	retq   

000000000080194e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80194e:	55                   	push   %rbp
  80194f:	48 89 e5             	mov    %rsp,%rbp
  801952:	48 83 ec 20          	sub    $0x20,%rsp
  801956:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801959:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80195d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801960:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801964:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801968:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80196b:	48 63 c8             	movslq %eax,%rcx
  80196e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801972:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801975:	48 63 f0             	movslq %eax,%rsi
  801978:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80197c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197f:	48 98                	cltq   
  801981:	48 83 ec 08          	sub    $0x8,%rsp
  801985:	51                   	push   %rcx
  801986:	49 89 f9             	mov    %rdi,%r9
  801989:	49 89 f0             	mov    %rsi,%r8
  80198c:	48 89 d1             	mov    %rdx,%rcx
  80198f:	48 89 c2             	mov    %rax,%rdx
  801992:	be 01 00 00 00       	mov    $0x1,%esi
  801997:	bf 05 00 00 00       	mov    $0x5,%edi
  80199c:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  8019a3:	00 00 00 
  8019a6:	ff d0                	callq  *%rax
  8019a8:	48 83 c4 10          	add    $0x10,%rsp
}
  8019ac:	c9                   	leaveq 
  8019ad:	c3                   	retq   

00000000008019ae <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019ae:	55                   	push   %rbp
  8019af:	48 89 e5             	mov    %rsp,%rbp
  8019b2:	48 83 ec 10          	sub    $0x10,%rsp
  8019b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8019bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c4:	48 98                	cltq   
  8019c6:	48 83 ec 08          	sub    $0x8,%rsp
  8019ca:	6a 00                	pushq  $0x0
  8019cc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d8:	48 89 d1             	mov    %rdx,%rcx
  8019db:	48 89 c2             	mov    %rax,%rdx
  8019de:	be 01 00 00 00       	mov    $0x1,%esi
  8019e3:	bf 06 00 00 00       	mov    $0x6,%edi
  8019e8:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  8019ef:	00 00 00 
  8019f2:	ff d0                	callq  *%rax
  8019f4:	48 83 c4 10          	add    $0x10,%rsp
}
  8019f8:	c9                   	leaveq 
  8019f9:	c3                   	retq   

00000000008019fa <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019fa:	55                   	push   %rbp
  8019fb:	48 89 e5             	mov    %rsp,%rbp
  8019fe:	48 83 ec 10          	sub    $0x10,%rsp
  801a02:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a05:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a08:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a0b:	48 63 d0             	movslq %eax,%rdx
  801a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a11:	48 98                	cltq   
  801a13:	48 83 ec 08          	sub    $0x8,%rsp
  801a17:	6a 00                	pushq  $0x0
  801a19:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a25:	48 89 d1             	mov    %rdx,%rcx
  801a28:	48 89 c2             	mov    %rax,%rdx
  801a2b:	be 01 00 00 00       	mov    $0x1,%esi
  801a30:	bf 08 00 00 00       	mov    $0x8,%edi
  801a35:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  801a3c:	00 00 00 
  801a3f:	ff d0                	callq  *%rax
  801a41:	48 83 c4 10          	add    $0x10,%rsp
}
  801a45:	c9                   	leaveq 
  801a46:	c3                   	retq   

0000000000801a47 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a47:	55                   	push   %rbp
  801a48:	48 89 e5             	mov    %rsp,%rbp
  801a4b:	48 83 ec 10          	sub    $0x10,%rsp
  801a4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5d:	48 98                	cltq   
  801a5f:	48 83 ec 08          	sub    $0x8,%rsp
  801a63:	6a 00                	pushq  $0x0
  801a65:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a71:	48 89 d1             	mov    %rdx,%rcx
  801a74:	48 89 c2             	mov    %rax,%rdx
  801a77:	be 01 00 00 00       	mov    $0x1,%esi
  801a7c:	bf 09 00 00 00       	mov    $0x9,%edi
  801a81:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  801a88:	00 00 00 
  801a8b:	ff d0                	callq  *%rax
  801a8d:	48 83 c4 10          	add    $0x10,%rsp
}
  801a91:	c9                   	leaveq 
  801a92:	c3                   	retq   

0000000000801a93 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a93:	55                   	push   %rbp
  801a94:	48 89 e5             	mov    %rsp,%rbp
  801a97:	48 83 ec 20          	sub    $0x20,%rsp
  801a9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aa2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801aa6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801aa9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aac:	48 63 f0             	movslq %eax,%rsi
  801aaf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ab3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab6:	48 98                	cltq   
  801ab8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801abc:	48 83 ec 08          	sub    $0x8,%rsp
  801ac0:	6a 00                	pushq  $0x0
  801ac2:	49 89 f1             	mov    %rsi,%r9
  801ac5:	49 89 c8             	mov    %rcx,%r8
  801ac8:	48 89 d1             	mov    %rdx,%rcx
  801acb:	48 89 c2             	mov    %rax,%rdx
  801ace:	be 00 00 00 00       	mov    $0x0,%esi
  801ad3:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ad8:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  801adf:	00 00 00 
  801ae2:	ff d0                	callq  *%rax
  801ae4:	48 83 c4 10          	add    $0x10,%rsp
}
  801ae8:	c9                   	leaveq 
  801ae9:	c3                   	retq   

0000000000801aea <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801aea:	55                   	push   %rbp
  801aeb:	48 89 e5             	mov    %rsp,%rbp
  801aee:	48 83 ec 10          	sub    $0x10,%rsp
  801af2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801af6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801afa:	48 83 ec 08          	sub    $0x8,%rsp
  801afe:	6a 00                	pushq  $0x0
  801b00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b11:	48 89 c2             	mov    %rax,%rdx
  801b14:	be 01 00 00 00       	mov    $0x1,%esi
  801b19:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b1e:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  801b25:	00 00 00 
  801b28:	ff d0                	callq  *%rax
  801b2a:	48 83 c4 10          	add    $0x10,%rsp
}
  801b2e:	c9                   	leaveq 
  801b2f:	c3                   	retq   

0000000000801b30 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801b30:	55                   	push   %rbp
  801b31:	48 89 e5             	mov    %rsp,%rbp
  801b34:	48 83 ec 20          	sub    $0x20,%rsp
  801b38:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler==0) {
  801b3c:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801b43:	00 00 00 
  801b46:	48 8b 00             	mov    (%rax),%rax
  801b49:	48 85 c0             	test   %rax,%rax
  801b4c:	0f 85 ae 00 00 00    	jne    801c00 <set_pgfault_handler+0xd0>
		//allocate space
		int result = sys_page_alloc(sys_getenvid(), (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  801b52:	48 b8 83 18 80 00 00 	movabs $0x801883,%rax
  801b59:	00 00 00 
  801b5c:	ff d0                	callq  *%rax
  801b5e:	ba 07 00 00 00       	mov    $0x7,%edx
  801b63:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801b68:	89 c7                	mov    %eax,%edi
  801b6a:	48 b8 fc 18 80 00 00 	movabs $0x8018fc,%rax
  801b71:	00 00 00 
  801b74:	ff d0                	callq  *%rax
  801b76:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  801b79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b7d:	79 2a                	jns    801ba9 <set_pgfault_handler+0x79>
			panic("sys_page_alloc for stack failed in setting page fault handler");
  801b7f:	48 ba b8 21 80 00 00 	movabs $0x8021b8,%rdx
  801b86:	00 00 00 
  801b89:	be 21 00 00 00       	mov    $0x21,%esi
  801b8e:	48 bf f6 21 80 00 00 	movabs $0x8021f6,%rdi
  801b95:	00 00 00 
  801b98:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9d:	48 b9 fc 01 80 00 00 	movabs $0x8001fc,%rcx
  801ba4:	00 00 00 
  801ba7:	ff d1                	callq  *%rcx
		}

		//actual set upcall
		result = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801ba9:	48 b8 83 18 80 00 00 	movabs $0x801883,%rax
  801bb0:	00 00 00 
  801bb3:	ff d0                	callq  *%rax
  801bb5:	48 be 14 1c 80 00 00 	movabs $0x801c14,%rsi
  801bbc:	00 00 00 
  801bbf:	89 c7                	mov    %eax,%edi
  801bc1:	48 b8 47 1a 80 00 00 	movabs $0x801a47,%rax
  801bc8:	00 00 00 
  801bcb:	ff d0                	callq  *%rax
  801bcd:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  801bd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bd4:	79 2a                	jns    801c00 <set_pgfault_handler+0xd0>
                        panic("setting upcall failed in setting page fault handler");
  801bd6:	48 ba 08 22 80 00 00 	movabs $0x802208,%rdx
  801bdd:	00 00 00 
  801be0:	be 27 00 00 00       	mov    $0x27,%esi
  801be5:	48 bf f6 21 80 00 00 	movabs $0x8021f6,%rdi
  801bec:	00 00 00 
  801bef:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf4:	48 b9 fc 01 80 00 00 	movabs $0x8001fc,%rcx
  801bfb:	00 00 00 
  801bfe:	ff d1                	callq  *%rcx
                }
		//panic("set_pgfault_handler not implemented");
	}

	_pgfault_handler = handler;
  801c00:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801c07:	00 00 00 
  801c0a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c0e:	48 89 10             	mov    %rdx,(%rax)

}
  801c11:	90                   	nop
  801c12:	c9                   	leaveq 
  801c13:	c3                   	retq   

0000000000801c14 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  801c14:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  801c17:	48 a1 10 30 80 00 00 	movabs 0x803010,%rax
  801c1e:	00 00 00 
call *%rax
  801c21:	ff d0                	callq  *%rax
	//MAKE STACK CALCS for getting parameters
	//20 = size of stack
	//8 = size of word	

	//(20-3)*8=17*8=136
	movq 136(%rsp), %rax
  801c23:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  801c2a:	00 
	//(20-1)*8=152
	subq $8, 152(%rsp)
  801c2b:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  801c32:	00 08 
	movq 152(%rsp), %rbx
  801c34:	48 8b 9c 24 98 00 00 	mov    0x98(%rsp),%rbx
  801c3b:	00 
	movq %rax, (%rbx)
  801c3c:	48 89 03             	mov    %rax,(%rbx)
	addq $16, %rsp
  801c3f:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
	
    	POPA_
  801c43:	4c 8b 3c 24          	mov    (%rsp),%r15
  801c47:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801c4c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801c51:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801c56:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801c5b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801c60:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801c65:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801c6a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801c6f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801c74:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801c79:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801c7e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801c83:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801c88:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801c8d:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
	//https://www.felixcloutier.com/x86/POPF:POPFD:POPFQ.html
    	addq $8, %rsp
  801c91:	48 83 c4 08          	add    $0x8,%rsp
    	popfq	
  801c95:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    	popq %rsp
  801c96:	5c                   	pop    %rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    	ret
  801c97:	c3                   	retq   
