
obj/user/testbss:     file format elf64-x86-64


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
  80003c:	e8 6e 01 00 00       	callq  8001af <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;

	cprintf("Making sure bss works right...\n");
  800052:	48 bf a0 1b 80 00 00 	movabs $0x801ba0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 8d 04 80 00 00 	movabs $0x80048d,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	for (i = 0; i < ARRAYSIZE; i++)
  80006d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800074:	eb 4b                	jmp    8000c1 <umain+0x7e>
		if (bigarray[i] != 0)
  800076:	48 b8 20 30 80 00 00 	movabs $0x803020,%rax
  80007d:	00 00 00 
  800080:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800083:	48 63 d2             	movslq %edx,%rdx
  800086:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  800089:	85 c0                	test   %eax,%eax
  80008b:	74 30                	je     8000bd <umain+0x7a>
			panic("bigarray[%d] isn't cleared!\n", i);
  80008d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800090:	89 c1                	mov    %eax,%ecx
  800092:	48 ba c0 1b 80 00 00 	movabs $0x801bc0,%rdx
  800099:	00 00 00 
  80009c:	be 11 00 00 00       	mov    $0x11,%esi
  8000a1:	48 bf dd 1b 80 00 00 	movabs $0x801bdd,%rdi
  8000a8:	00 00 00 
  8000ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b0:	49 b8 53 02 80 00 00 	movabs $0x800253,%r8
  8000b7:	00 00 00 
  8000ba:	41 ff d0             	callq  *%r8
umain(int argc, char **argv)
{
	int i;

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
  8000bd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000c1:	81 7d fc ff ff 0f 00 	cmpl   $0xfffff,-0x4(%rbp)
  8000c8:	7e ac                	jle    800076 <umain+0x33>
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  8000ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000d1:	eb 1a                	jmp    8000ed <umain+0xaa>
		bigarray[i] = i;
  8000d3:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8000d6:	48 b8 20 30 80 00 00 	movabs $0x803020,%rax
  8000dd:	00 00 00 
  8000e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8000e3:	48 63 d2             	movslq %edx,%rdx
  8000e6:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  8000e9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000ed:	81 7d fc ff ff 0f 00 	cmpl   $0xfffff,-0x4(%rbp)
  8000f4:	7e dd                	jle    8000d3 <umain+0x90>
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
  8000f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000fd:	eb 4e                	jmp    80014d <umain+0x10a>
		if (bigarray[i] != i)
  8000ff:	48 b8 20 30 80 00 00 	movabs $0x803020,%rax
  800106:	00 00 00 
  800109:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80010c:	48 63 d2             	movslq %edx,%rdx
  80010f:	8b 14 90             	mov    (%rax,%rdx,4),%edx
  800112:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800115:	39 c2                	cmp    %eax,%edx
  800117:	74 30                	je     800149 <umain+0x106>
			panic("bigarray[%d] didn't hold its value!\n", i);
  800119:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80011c:	89 c1                	mov    %eax,%ecx
  80011e:	48 ba f0 1b 80 00 00 	movabs $0x801bf0,%rdx
  800125:	00 00 00 
  800128:	be 16 00 00 00       	mov    $0x16,%esi
  80012d:	48 bf dd 1b 80 00 00 	movabs $0x801bdd,%rdi
  800134:	00 00 00 
  800137:	b8 00 00 00 00       	mov    $0x0,%eax
  80013c:	49 b8 53 02 80 00 00 	movabs $0x800253,%r8
  800143:	00 00 00 
  800146:	41 ff d0             	callq  *%r8
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
  800149:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80014d:	81 7d fc ff ff 0f 00 	cmpl   $0xfffff,-0x4(%rbp)
  800154:	7e a9                	jle    8000ff <umain+0xbc>
		if (bigarray[i] != i)
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  800156:	48 bf 18 1c 80 00 00 	movabs $0x801c18,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	48 ba 8d 04 80 00 00 	movabs $0x80048d,%rdx
  80016c:	00 00 00 
  80016f:	ff d2                	callq  *%rdx
	bigarray[ARRAYSIZE+1024] = 0;
  800171:	48 b8 20 30 80 00 00 	movabs $0x803020,%rax
  800178:	00 00 00 
  80017b:	c7 80 00 10 40 00 00 	movl   $0x0,0x401000(%rax)
  800182:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  800185:	48 ba 4b 1c 80 00 00 	movabs $0x801c4b,%rdx
  80018c:	00 00 00 
  80018f:	be 1a 00 00 00       	mov    $0x1a,%esi
  800194:	48 bf dd 1b 80 00 00 	movabs $0x801bdd,%rdi
  80019b:	00 00 00 
  80019e:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a3:	48 b9 53 02 80 00 00 	movabs $0x800253,%rcx
  8001aa:	00 00 00 
  8001ad:	ff d1                	callq  *%rcx

00000000008001af <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001af:	55                   	push   %rbp
  8001b0:	48 89 e5             	mov    %rsp,%rbp
  8001b3:	48 83 ec 10          	sub    $0x10,%rsp
  8001b7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  8001be:	48 b8 da 18 80 00 00 	movabs $0x8018da,%rax
  8001c5:	00 00 00 
  8001c8:	ff d0                	callq  *%rax
  8001ca:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001cf:	48 63 d0             	movslq %eax,%rdx
  8001d2:	48 89 d0             	mov    %rdx,%rax
  8001d5:	48 c1 e0 03          	shl    $0x3,%rax
  8001d9:	48 01 d0             	add    %rdx,%rax
  8001dc:	48 c1 e0 05          	shl    $0x5,%rax
  8001e0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001e7:	00 00 00 
  8001ea:	48 01 c2             	add    %rax,%rdx
  8001ed:	48 b8 20 30 c0 00 00 	movabs $0xc03020,%rax
  8001f4:	00 00 00 
  8001f7:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001fe:	7e 14                	jle    800214 <libmain+0x65>
		binaryname = argv[0];
  800200:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800204:	48 8b 10             	mov    (%rax),%rdx
  800207:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80020e:	00 00 00 
  800211:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800214:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800218:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80021b:	48 89 d6             	mov    %rdx,%rsi
  80021e:	89 c7                	mov    %eax,%edi
  800220:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800227:	00 00 00 
  80022a:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80022c:	48 b8 3b 02 80 00 00 	movabs $0x80023b,%rax
  800233:	00 00 00 
  800236:	ff d0                	callq  *%rax
}
  800238:	90                   	nop
  800239:	c9                   	leaveq 
  80023a:	c3                   	retq   

000000000080023b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80023b:	55                   	push   %rbp
  80023c:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80023f:	bf 00 00 00 00       	mov    $0x0,%edi
  800244:	48 b8 94 18 80 00 00 	movabs $0x801894,%rax
  80024b:	00 00 00 
  80024e:	ff d0                	callq  *%rax
}
  800250:	90                   	nop
  800251:	5d                   	pop    %rbp
  800252:	c3                   	retq   

0000000000800253 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800253:	55                   	push   %rbp
  800254:	48 89 e5             	mov    %rsp,%rbp
  800257:	53                   	push   %rbx
  800258:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80025f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800266:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80026c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800273:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80027a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800281:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800288:	84 c0                	test   %al,%al
  80028a:	74 23                	je     8002af <_panic+0x5c>
  80028c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800293:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800297:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80029b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80029f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002a3:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002a7:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002ab:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002af:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002b6:	00 00 00 
  8002b9:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002c0:	00 00 00 
  8002c3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002c7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002ce:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002d5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002dc:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8002e3:	00 00 00 
  8002e6:	48 8b 18             	mov    (%rax),%rbx
  8002e9:	48 b8 da 18 80 00 00 	movabs $0x8018da,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax
  8002f5:	89 c6                	mov    %eax,%esi
  8002f7:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8002fd:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800304:	41 89 d0             	mov    %edx,%r8d
  800307:	48 89 c1             	mov    %rax,%rcx
  80030a:	48 89 da             	mov    %rbx,%rdx
  80030d:	48 bf 70 1c 80 00 00 	movabs $0x801c70,%rdi
  800314:	00 00 00 
  800317:	b8 00 00 00 00       	mov    $0x0,%eax
  80031c:	49 b9 8d 04 80 00 00 	movabs $0x80048d,%r9
  800323:	00 00 00 
  800326:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800329:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800330:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800337:	48 89 d6             	mov    %rdx,%rsi
  80033a:	48 89 c7             	mov    %rax,%rdi
  80033d:	48 b8 e1 03 80 00 00 	movabs $0x8003e1,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax
	cprintf("\n");
  800349:	48 bf 93 1c 80 00 00 	movabs $0x801c93,%rdi
  800350:	00 00 00 
  800353:	b8 00 00 00 00       	mov    $0x0,%eax
  800358:	48 ba 8d 04 80 00 00 	movabs $0x80048d,%rdx
  80035f:	00 00 00 
  800362:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800364:	cc                   	int3   
  800365:	eb fd                	jmp    800364 <_panic+0x111>

0000000000800367 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800367:	55                   	push   %rbp
  800368:	48 89 e5             	mov    %rsp,%rbp
  80036b:	48 83 ec 10          	sub    $0x10,%rsp
  80036f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800372:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800376:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80037a:	8b 00                	mov    (%rax),%eax
  80037c:	8d 48 01             	lea    0x1(%rax),%ecx
  80037f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800383:	89 0a                	mov    %ecx,(%rdx)
  800385:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800388:	89 d1                	mov    %edx,%ecx
  80038a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80038e:	48 98                	cltq   
  800390:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800394:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800398:	8b 00                	mov    (%rax),%eax
  80039a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80039f:	75 2c                	jne    8003cd <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a5:	8b 00                	mov    (%rax),%eax
  8003a7:	48 98                	cltq   
  8003a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ad:	48 83 c2 08          	add    $0x8,%rdx
  8003b1:	48 89 c6             	mov    %rax,%rsi
  8003b4:	48 89 d7             	mov    %rdx,%rdi
  8003b7:	48 b8 0b 18 80 00 00 	movabs $0x80180b,%rax
  8003be:	00 00 00 
  8003c1:	ff d0                	callq  *%rax
        b->idx = 0;
  8003c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d1:	8b 40 04             	mov    0x4(%rax),%eax
  8003d4:	8d 50 01             	lea    0x1(%rax),%edx
  8003d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003db:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003de:	90                   	nop
  8003df:	c9                   	leaveq 
  8003e0:	c3                   	retq   

00000000008003e1 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003e1:	55                   	push   %rbp
  8003e2:	48 89 e5             	mov    %rsp,%rbp
  8003e5:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003ec:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003f3:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003fa:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800401:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800408:	48 8b 0a             	mov    (%rdx),%rcx
  80040b:	48 89 08             	mov    %rcx,(%rax)
  80040e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800412:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800416:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80041a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80041e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800425:	00 00 00 
    b.cnt = 0;
  800428:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80042f:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800432:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800439:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800440:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800447:	48 89 c6             	mov    %rax,%rsi
  80044a:	48 bf 67 03 80 00 00 	movabs $0x800367,%rdi
  800451:	00 00 00 
  800454:	48 b8 2b 08 80 00 00 	movabs $0x80082b,%rax
  80045b:	00 00 00 
  80045e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800460:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800466:	48 98                	cltq   
  800468:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80046f:	48 83 c2 08          	add    $0x8,%rdx
  800473:	48 89 c6             	mov    %rax,%rsi
  800476:	48 89 d7             	mov    %rdx,%rdi
  800479:	48 b8 0b 18 80 00 00 	movabs $0x80180b,%rax
  800480:	00 00 00 
  800483:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800485:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80048b:	c9                   	leaveq 
  80048c:	c3                   	retq   

000000000080048d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80048d:	55                   	push   %rbp
  80048e:	48 89 e5             	mov    %rsp,%rbp
  800491:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800498:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80049f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004a6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004ad:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004b4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004bb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004c2:	84 c0                	test   %al,%al
  8004c4:	74 20                	je     8004e6 <cprintf+0x59>
  8004c6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004ca:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004ce:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004d2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004d6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004da:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004de:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004e2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004e6:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004ed:	00 00 00 
  8004f0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004f7:	00 00 00 
  8004fa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004fe:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800505:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80050c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800513:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80051a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800521:	48 8b 0a             	mov    (%rdx),%rcx
  800524:	48 89 08             	mov    %rcx,(%rax)
  800527:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80052b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80052f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800533:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800537:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80053e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800545:	48 89 d6             	mov    %rdx,%rsi
  800548:	48 89 c7             	mov    %rax,%rdi
  80054b:	48 b8 e1 03 80 00 00 	movabs $0x8003e1,%rax
  800552:	00 00 00 
  800555:	ff d0                	callq  *%rax
  800557:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80055d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800563:	c9                   	leaveq 
  800564:	c3                   	retq   

0000000000800565 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800565:	55                   	push   %rbp
  800566:	48 89 e5             	mov    %rsp,%rbp
  800569:	48 83 ec 30          	sub    $0x30,%rsp
  80056d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800571:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800575:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800579:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80057c:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800580:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800584:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800587:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80058b:	77 54                	ja     8005e1 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80058d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800590:	8d 78 ff             	lea    -0x1(%rax),%edi
  800593:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800596:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059a:	ba 00 00 00 00       	mov    $0x0,%edx
  80059f:	48 f7 f6             	div    %rsi
  8005a2:	49 89 c2             	mov    %rax,%r10
  8005a5:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8005a8:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8005ab:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8005af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005b3:	41 89 c9             	mov    %ecx,%r9d
  8005b6:	41 89 f8             	mov    %edi,%r8d
  8005b9:	89 d1                	mov    %edx,%ecx
  8005bb:	4c 89 d2             	mov    %r10,%rdx
  8005be:	48 89 c7             	mov    %rax,%rdi
  8005c1:	48 b8 65 05 80 00 00 	movabs $0x800565,%rax
  8005c8:	00 00 00 
  8005cb:	ff d0                	callq  *%rax
  8005cd:	eb 1c                	jmp    8005eb <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005cf:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8005d3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8005d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005da:	48 89 ce             	mov    %rcx,%rsi
  8005dd:	89 d7                	mov    %edx,%edi
  8005df:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e1:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8005e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8005e9:	7f e4                	jg     8005cf <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005eb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8005ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f7:	48 f7 f1             	div    %rcx
  8005fa:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  800601:	00 00 00 
  800604:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800608:	0f be d0             	movsbl %al,%edx
  80060b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80060f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800613:	48 89 ce             	mov    %rcx,%rsi
  800616:	89 d7                	mov    %edx,%edi
  800618:	ff d0                	callq  *%rax
}
  80061a:	90                   	nop
  80061b:	c9                   	leaveq 
  80061c:	c3                   	retq   

000000000080061d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80061d:	55                   	push   %rbp
  80061e:	48 89 e5             	mov    %rsp,%rbp
  800621:	48 83 ec 20          	sub    $0x20,%rsp
  800625:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800629:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80062c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800630:	7e 4f                	jle    800681 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800632:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800636:	8b 00                	mov    (%rax),%eax
  800638:	83 f8 30             	cmp    $0x30,%eax
  80063b:	73 24                	jae    800661 <getuint+0x44>
  80063d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800641:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800645:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800649:	8b 00                	mov    (%rax),%eax
  80064b:	89 c0                	mov    %eax,%eax
  80064d:	48 01 d0             	add    %rdx,%rax
  800650:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800654:	8b 12                	mov    (%rdx),%edx
  800656:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800659:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065d:	89 0a                	mov    %ecx,(%rdx)
  80065f:	eb 14                	jmp    800675 <getuint+0x58>
  800661:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800665:	48 8b 40 08          	mov    0x8(%rax),%rax
  800669:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80066d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800671:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800675:	48 8b 00             	mov    (%rax),%rax
  800678:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80067c:	e9 9d 00 00 00       	jmpq   80071e <getuint+0x101>
	else if (lflag)
  800681:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800685:	74 4c                	je     8006d3 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068b:	8b 00                	mov    (%rax),%eax
  80068d:	83 f8 30             	cmp    $0x30,%eax
  800690:	73 24                	jae    8006b6 <getuint+0x99>
  800692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800696:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069e:	8b 00                	mov    (%rax),%eax
  8006a0:	89 c0                	mov    %eax,%eax
  8006a2:	48 01 d0             	add    %rdx,%rax
  8006a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a9:	8b 12                	mov    (%rdx),%edx
  8006ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b2:	89 0a                	mov    %ecx,(%rdx)
  8006b4:	eb 14                	jmp    8006ca <getuint+0xad>
  8006b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ba:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006be:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006ca:	48 8b 00             	mov    (%rax),%rax
  8006cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d1:	eb 4b                	jmp    80071e <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8006d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d7:	8b 00                	mov    (%rax),%eax
  8006d9:	83 f8 30             	cmp    $0x30,%eax
  8006dc:	73 24                	jae    800702 <getuint+0xe5>
  8006de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ea:	8b 00                	mov    (%rax),%eax
  8006ec:	89 c0                	mov    %eax,%eax
  8006ee:	48 01 d0             	add    %rdx,%rax
  8006f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f5:	8b 12                	mov    (%rdx),%edx
  8006f7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fe:	89 0a                	mov    %ecx,(%rdx)
  800700:	eb 14                	jmp    800716 <getuint+0xf9>
  800702:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800706:	48 8b 40 08          	mov    0x8(%rax),%rax
  80070a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80070e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800712:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800716:	8b 00                	mov    (%rax),%eax
  800718:	89 c0                	mov    %eax,%eax
  80071a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80071e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800722:	c9                   	leaveq 
  800723:	c3                   	retq   

0000000000800724 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800724:	55                   	push   %rbp
  800725:	48 89 e5             	mov    %rsp,%rbp
  800728:	48 83 ec 20          	sub    $0x20,%rsp
  80072c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800730:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800733:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800737:	7e 4f                	jle    800788 <getint+0x64>
		x=va_arg(*ap, long long);
  800739:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073d:	8b 00                	mov    (%rax),%eax
  80073f:	83 f8 30             	cmp    $0x30,%eax
  800742:	73 24                	jae    800768 <getint+0x44>
  800744:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800748:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80074c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800750:	8b 00                	mov    (%rax),%eax
  800752:	89 c0                	mov    %eax,%eax
  800754:	48 01 d0             	add    %rdx,%rax
  800757:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075b:	8b 12                	mov    (%rdx),%edx
  80075d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800760:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800764:	89 0a                	mov    %ecx,(%rdx)
  800766:	eb 14                	jmp    80077c <getint+0x58>
  800768:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800770:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800774:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800778:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80077c:	48 8b 00             	mov    (%rax),%rax
  80077f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800783:	e9 9d 00 00 00       	jmpq   800825 <getint+0x101>
	else if (lflag)
  800788:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80078c:	74 4c                	je     8007da <getint+0xb6>
		x=va_arg(*ap, long);
  80078e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800792:	8b 00                	mov    (%rax),%eax
  800794:	83 f8 30             	cmp    $0x30,%eax
  800797:	73 24                	jae    8007bd <getint+0x99>
  800799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a5:	8b 00                	mov    (%rax),%eax
  8007a7:	89 c0                	mov    %eax,%eax
  8007a9:	48 01 d0             	add    %rdx,%rax
  8007ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b0:	8b 12                	mov    (%rdx),%edx
  8007b2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b9:	89 0a                	mov    %ecx,(%rdx)
  8007bb:	eb 14                	jmp    8007d1 <getint+0xad>
  8007bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007c5:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d1:	48 8b 00             	mov    (%rax),%rax
  8007d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007d8:	eb 4b                	jmp    800825 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8007da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007de:	8b 00                	mov    (%rax),%eax
  8007e0:	83 f8 30             	cmp    $0x30,%eax
  8007e3:	73 24                	jae    800809 <getint+0xe5>
  8007e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f1:	8b 00                	mov    (%rax),%eax
  8007f3:	89 c0                	mov    %eax,%eax
  8007f5:	48 01 d0             	add    %rdx,%rax
  8007f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fc:	8b 12                	mov    (%rdx),%edx
  8007fe:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800801:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800805:	89 0a                	mov    %ecx,(%rdx)
  800807:	eb 14                	jmp    80081d <getint+0xf9>
  800809:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800811:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800815:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800819:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80081d:	8b 00                	mov    (%rax),%eax
  80081f:	48 98                	cltq   
  800821:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800825:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800829:	c9                   	leaveq 
  80082a:	c3                   	retq   

000000000080082b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80082b:	55                   	push   %rbp
  80082c:	48 89 e5             	mov    %rsp,%rbp
  80082f:	41 54                	push   %r12
  800831:	53                   	push   %rbx
  800832:	48 83 ec 60          	sub    $0x60,%rsp
  800836:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80083a:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80083e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800842:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800846:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80084a:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80084e:	48 8b 0a             	mov    (%rdx),%rcx
  800851:	48 89 08             	mov    %rcx,(%rax)
  800854:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800858:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80085c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800860:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800864:	eb 17                	jmp    80087d <vprintfmt+0x52>
			if (ch == '\0')
  800866:	85 db                	test   %ebx,%ebx
  800868:	0f 84 b9 04 00 00    	je     800d27 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80086e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800872:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800876:	48 89 d6             	mov    %rdx,%rsi
  800879:	89 df                	mov    %ebx,%edi
  80087b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800881:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800885:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800889:	0f b6 00             	movzbl (%rax),%eax
  80088c:	0f b6 d8             	movzbl %al,%ebx
  80088f:	83 fb 25             	cmp    $0x25,%ebx
  800892:	75 d2                	jne    800866 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800894:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800898:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80089f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008a6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008ad:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008b8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008bc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008c0:	0f b6 00             	movzbl (%rax),%eax
  8008c3:	0f b6 d8             	movzbl %al,%ebx
  8008c6:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008c9:	83 f8 55             	cmp    $0x55,%eax
  8008cc:	0f 87 22 04 00 00    	ja     800cf4 <vprintfmt+0x4c9>
  8008d2:	89 c0                	mov    %eax,%eax
  8008d4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008db:	00 
  8008dc:	48 b8 18 1e 80 00 00 	movabs $0x801e18,%rax
  8008e3:	00 00 00 
  8008e6:	48 01 d0             	add    %rdx,%rax
  8008e9:	48 8b 00             	mov    (%rax),%rax
  8008ec:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008ee:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008f2:	eb c0                	jmp    8008b4 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008f4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008f8:	eb ba                	jmp    8008b4 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008fa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800901:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800904:	89 d0                	mov    %edx,%eax
  800906:	c1 e0 02             	shl    $0x2,%eax
  800909:	01 d0                	add    %edx,%eax
  80090b:	01 c0                	add    %eax,%eax
  80090d:	01 d8                	add    %ebx,%eax
  80090f:	83 e8 30             	sub    $0x30,%eax
  800912:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800915:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800919:	0f b6 00             	movzbl (%rax),%eax
  80091c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80091f:	83 fb 2f             	cmp    $0x2f,%ebx
  800922:	7e 60                	jle    800984 <vprintfmt+0x159>
  800924:	83 fb 39             	cmp    $0x39,%ebx
  800927:	7f 5b                	jg     800984 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800929:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80092e:	eb d1                	jmp    800901 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800930:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800933:	83 f8 30             	cmp    $0x30,%eax
  800936:	73 17                	jae    80094f <vprintfmt+0x124>
  800938:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80093c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80093f:	89 d2                	mov    %edx,%edx
  800941:	48 01 d0             	add    %rdx,%rax
  800944:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800947:	83 c2 08             	add    $0x8,%edx
  80094a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80094d:	eb 0c                	jmp    80095b <vprintfmt+0x130>
  80094f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800953:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800957:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80095b:	8b 00                	mov    (%rax),%eax
  80095d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800960:	eb 23                	jmp    800985 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800962:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800966:	0f 89 48 ff ff ff    	jns    8008b4 <vprintfmt+0x89>
				width = 0;
  80096c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800973:	e9 3c ff ff ff       	jmpq   8008b4 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800978:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80097f:	e9 30 ff ff ff       	jmpq   8008b4 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800984:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800985:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800989:	0f 89 25 ff ff ff    	jns    8008b4 <vprintfmt+0x89>
				width = precision, precision = -1;
  80098f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800992:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800995:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80099c:	e9 13 ff ff ff       	jmpq   8008b4 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009a1:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009a5:	e9 0a ff ff ff       	jmpq   8008b4 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ad:	83 f8 30             	cmp    $0x30,%eax
  8009b0:	73 17                	jae    8009c9 <vprintfmt+0x19e>
  8009b2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009b6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009b9:	89 d2                	mov    %edx,%edx
  8009bb:	48 01 d0             	add    %rdx,%rax
  8009be:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009c1:	83 c2 08             	add    $0x8,%edx
  8009c4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009c7:	eb 0c                	jmp    8009d5 <vprintfmt+0x1aa>
  8009c9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009cd:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009d1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009d5:	8b 10                	mov    (%rax),%edx
  8009d7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009db:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009df:	48 89 ce             	mov    %rcx,%rsi
  8009e2:	89 d7                	mov    %edx,%edi
  8009e4:	ff d0                	callq  *%rax
			break;
  8009e6:	e9 37 03 00 00       	jmpq   800d22 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009eb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ee:	83 f8 30             	cmp    $0x30,%eax
  8009f1:	73 17                	jae    800a0a <vprintfmt+0x1df>
  8009f3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009f7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009fa:	89 d2                	mov    %edx,%edx
  8009fc:	48 01 d0             	add    %rdx,%rax
  8009ff:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a02:	83 c2 08             	add    $0x8,%edx
  800a05:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a08:	eb 0c                	jmp    800a16 <vprintfmt+0x1eb>
  800a0a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a0e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a12:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a16:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a18:	85 db                	test   %ebx,%ebx
  800a1a:	79 02                	jns    800a1e <vprintfmt+0x1f3>
				err = -err;
  800a1c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a1e:	83 fb 15             	cmp    $0x15,%ebx
  800a21:	7f 16                	jg     800a39 <vprintfmt+0x20e>
  800a23:	48 b8 40 1d 80 00 00 	movabs $0x801d40,%rax
  800a2a:	00 00 00 
  800a2d:	48 63 d3             	movslq %ebx,%rdx
  800a30:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a34:	4d 85 e4             	test   %r12,%r12
  800a37:	75 2e                	jne    800a67 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800a39:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a41:	89 d9                	mov    %ebx,%ecx
  800a43:	48 ba 01 1e 80 00 00 	movabs $0x801e01,%rdx
  800a4a:	00 00 00 
  800a4d:	48 89 c7             	mov    %rax,%rdi
  800a50:	b8 00 00 00 00       	mov    $0x0,%eax
  800a55:	49 b8 31 0d 80 00 00 	movabs $0x800d31,%r8
  800a5c:	00 00 00 
  800a5f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a62:	e9 bb 02 00 00       	jmpq   800d22 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a67:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6f:	4c 89 e1             	mov    %r12,%rcx
  800a72:	48 ba 0a 1e 80 00 00 	movabs $0x801e0a,%rdx
  800a79:	00 00 00 
  800a7c:	48 89 c7             	mov    %rax,%rdi
  800a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a84:	49 b8 31 0d 80 00 00 	movabs $0x800d31,%r8
  800a8b:	00 00 00 
  800a8e:	41 ff d0             	callq  *%r8
			break;
  800a91:	e9 8c 02 00 00       	jmpq   800d22 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a99:	83 f8 30             	cmp    $0x30,%eax
  800a9c:	73 17                	jae    800ab5 <vprintfmt+0x28a>
  800a9e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800aa2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aa5:	89 d2                	mov    %edx,%edx
  800aa7:	48 01 d0             	add    %rdx,%rax
  800aaa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aad:	83 c2 08             	add    $0x8,%edx
  800ab0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ab3:	eb 0c                	jmp    800ac1 <vprintfmt+0x296>
  800ab5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ab9:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800abd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ac1:	4c 8b 20             	mov    (%rax),%r12
  800ac4:	4d 85 e4             	test   %r12,%r12
  800ac7:	75 0a                	jne    800ad3 <vprintfmt+0x2a8>
				p = "(null)";
  800ac9:	49 bc 0d 1e 80 00 00 	movabs $0x801e0d,%r12
  800ad0:	00 00 00 
			if (width > 0 && padc != '-')
  800ad3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ad7:	7e 78                	jle    800b51 <vprintfmt+0x326>
  800ad9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800add:	74 72                	je     800b51 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800adf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ae2:	48 98                	cltq   
  800ae4:	48 89 c6             	mov    %rax,%rsi
  800ae7:	4c 89 e7             	mov    %r12,%rdi
  800aea:	48 b8 df 0f 80 00 00 	movabs $0x800fdf,%rax
  800af1:	00 00 00 
  800af4:	ff d0                	callq  *%rax
  800af6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800af9:	eb 17                	jmp    800b12 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800afb:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800aff:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b03:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b07:	48 89 ce             	mov    %rcx,%rsi
  800b0a:	89 d7                	mov    %edx,%edi
  800b0c:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b12:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b16:	7f e3                	jg     800afb <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b18:	eb 37                	jmp    800b51 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800b1a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b1e:	74 1e                	je     800b3e <vprintfmt+0x313>
  800b20:	83 fb 1f             	cmp    $0x1f,%ebx
  800b23:	7e 05                	jle    800b2a <vprintfmt+0x2ff>
  800b25:	83 fb 7e             	cmp    $0x7e,%ebx
  800b28:	7e 14                	jle    800b3e <vprintfmt+0x313>
					putch('?', putdat);
  800b2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b32:	48 89 d6             	mov    %rdx,%rsi
  800b35:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b3a:	ff d0                	callq  *%rax
  800b3c:	eb 0f                	jmp    800b4d <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800b3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b46:	48 89 d6             	mov    %rdx,%rsi
  800b49:	89 df                	mov    %ebx,%edi
  800b4b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b51:	4c 89 e0             	mov    %r12,%rax
  800b54:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b58:	0f b6 00             	movzbl (%rax),%eax
  800b5b:	0f be d8             	movsbl %al,%ebx
  800b5e:	85 db                	test   %ebx,%ebx
  800b60:	74 28                	je     800b8a <vprintfmt+0x35f>
  800b62:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b66:	78 b2                	js     800b1a <vprintfmt+0x2ef>
  800b68:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b6c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b70:	79 a8                	jns    800b1a <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b72:	eb 16                	jmp    800b8a <vprintfmt+0x35f>
				putch(' ', putdat);
  800b74:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7c:	48 89 d6             	mov    %rdx,%rsi
  800b7f:	bf 20 00 00 00       	mov    $0x20,%edi
  800b84:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b86:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b8a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b8e:	7f e4                	jg     800b74 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800b90:	e9 8d 01 00 00       	jmpq   800d22 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b95:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b99:	be 03 00 00 00       	mov    $0x3,%esi
  800b9e:	48 89 c7             	mov    %rax,%rdi
  800ba1:	48 b8 24 07 80 00 00 	movabs $0x800724,%rax
  800ba8:	00 00 00 
  800bab:	ff d0                	callq  *%rax
  800bad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb5:	48 85 c0             	test   %rax,%rax
  800bb8:	79 1d                	jns    800bd7 <vprintfmt+0x3ac>
				putch('-', putdat);
  800bba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc2:	48 89 d6             	mov    %rdx,%rsi
  800bc5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bca:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd0:	48 f7 d8             	neg    %rax
  800bd3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bd7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bde:	e9 d2 00 00 00       	jmpq   800cb5 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800be3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800be7:	be 03 00 00 00       	mov    $0x3,%esi
  800bec:	48 89 c7             	mov    %rax,%rdi
  800bef:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  800bf6:	00 00 00 
  800bf9:	ff d0                	callq  *%rax
  800bfb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800bff:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c06:	e9 aa 00 00 00       	jmpq   800cb5 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800c0b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c0f:	be 03 00 00 00       	mov    $0x3,%esi
  800c14:	48 89 c7             	mov    %rax,%rdi
  800c17:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  800c1e:	00 00 00 
  800c21:	ff d0                	callq  *%rax
  800c23:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c27:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c2e:	e9 82 00 00 00       	jmpq   800cb5 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800c33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3b:	48 89 d6             	mov    %rdx,%rsi
  800c3e:	bf 30 00 00 00       	mov    $0x30,%edi
  800c43:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c45:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4d:	48 89 d6             	mov    %rdx,%rsi
  800c50:	bf 78 00 00 00       	mov    $0x78,%edi
  800c55:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c5a:	83 f8 30             	cmp    $0x30,%eax
  800c5d:	73 17                	jae    800c76 <vprintfmt+0x44b>
  800c5f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c63:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c66:	89 d2                	mov    %edx,%edx
  800c68:	48 01 d0             	add    %rdx,%rax
  800c6b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c6e:	83 c2 08             	add    $0x8,%edx
  800c71:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c74:	eb 0c                	jmp    800c82 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800c76:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c7a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c7e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c82:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c89:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c90:	eb 23                	jmp    800cb5 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c92:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c96:	be 03 00 00 00       	mov    $0x3,%esi
  800c9b:	48 89 c7             	mov    %rax,%rdi
  800c9e:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  800ca5:	00 00 00 
  800ca8:	ff d0                	callq  *%rax
  800caa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cae:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cb5:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cba:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cbd:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cc0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cc4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ccc:	45 89 c1             	mov    %r8d,%r9d
  800ccf:	41 89 f8             	mov    %edi,%r8d
  800cd2:	48 89 c7             	mov    %rax,%rdi
  800cd5:	48 b8 65 05 80 00 00 	movabs $0x800565,%rax
  800cdc:	00 00 00 
  800cdf:	ff d0                	callq  *%rax
			break;
  800ce1:	eb 3f                	jmp    800d22 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ce3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ceb:	48 89 d6             	mov    %rdx,%rsi
  800cee:	89 df                	mov    %ebx,%edi
  800cf0:	ff d0                	callq  *%rax
			break;
  800cf2:	eb 2e                	jmp    800d22 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cf4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfc:	48 89 d6             	mov    %rdx,%rsi
  800cff:	bf 25 00 00 00       	mov    $0x25,%edi
  800d04:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d06:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d0b:	eb 05                	jmp    800d12 <vprintfmt+0x4e7>
  800d0d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d12:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d16:	48 83 e8 01          	sub    $0x1,%rax
  800d1a:	0f b6 00             	movzbl (%rax),%eax
  800d1d:	3c 25                	cmp    $0x25,%al
  800d1f:	75 ec                	jne    800d0d <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800d21:	90                   	nop
		}
	}
  800d22:	e9 3d fb ff ff       	jmpq   800864 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d27:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d28:	48 83 c4 60          	add    $0x60,%rsp
  800d2c:	5b                   	pop    %rbx
  800d2d:	41 5c                	pop    %r12
  800d2f:	5d                   	pop    %rbp
  800d30:	c3                   	retq   

0000000000800d31 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d31:	55                   	push   %rbp
  800d32:	48 89 e5             	mov    %rsp,%rbp
  800d35:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d3c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d43:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d4a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800d51:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d58:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d5f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d66:	84 c0                	test   %al,%al
  800d68:	74 20                	je     800d8a <printfmt+0x59>
  800d6a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d6e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d72:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d76:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d7a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d7e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d82:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d86:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d8a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d91:	00 00 00 
  800d94:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d9b:	00 00 00 
  800d9e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800da2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800da9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800db0:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800db7:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dbe:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dc5:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800dcc:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800dd3:	48 89 c7             	mov    %rax,%rdi
  800dd6:	48 b8 2b 08 80 00 00 	movabs $0x80082b,%rax
  800ddd:	00 00 00 
  800de0:	ff d0                	callq  *%rax
	va_end(ap);
}
  800de2:	90                   	nop
  800de3:	c9                   	leaveq 
  800de4:	c3                   	retq   

0000000000800de5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800de5:	55                   	push   %rbp
  800de6:	48 89 e5             	mov    %rsp,%rbp
  800de9:	48 83 ec 10          	sub    $0x10,%rsp
  800ded:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800df0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800df4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df8:	8b 40 10             	mov    0x10(%rax),%eax
  800dfb:	8d 50 01             	lea    0x1(%rax),%edx
  800dfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e02:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e09:	48 8b 10             	mov    (%rax),%rdx
  800e0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e10:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e14:	48 39 c2             	cmp    %rax,%rdx
  800e17:	73 17                	jae    800e30 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e1d:	48 8b 00             	mov    (%rax),%rax
  800e20:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e28:	48 89 0a             	mov    %rcx,(%rdx)
  800e2b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e2e:	88 10                	mov    %dl,(%rax)
}
  800e30:	90                   	nop
  800e31:	c9                   	leaveq 
  800e32:	c3                   	retq   

0000000000800e33 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e33:	55                   	push   %rbp
  800e34:	48 89 e5             	mov    %rsp,%rbp
  800e37:	48 83 ec 50          	sub    $0x50,%rsp
  800e3b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e3f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e42:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e46:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e4a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e4e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e52:	48 8b 0a             	mov    (%rdx),%rcx
  800e55:	48 89 08             	mov    %rcx,(%rax)
  800e58:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e5c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e60:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e64:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e68:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e6c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e70:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e73:	48 98                	cltq   
  800e75:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e79:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e7d:	48 01 d0             	add    %rdx,%rax
  800e80:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e84:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e8b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e90:	74 06                	je     800e98 <vsnprintf+0x65>
  800e92:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e96:	7f 07                	jg     800e9f <vsnprintf+0x6c>
		return -E_INVAL;
  800e98:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e9d:	eb 2f                	jmp    800ece <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e9f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ea3:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ea7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800eab:	48 89 c6             	mov    %rax,%rsi
  800eae:	48 bf e5 0d 80 00 00 	movabs $0x800de5,%rdi
  800eb5:	00 00 00 
  800eb8:	48 b8 2b 08 80 00 00 	movabs $0x80082b,%rax
  800ebf:	00 00 00 
  800ec2:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ec4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ec8:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ecb:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ece:	c9                   	leaveq 
  800ecf:	c3                   	retq   

0000000000800ed0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ed0:	55                   	push   %rbp
  800ed1:	48 89 e5             	mov    %rsp,%rbp
  800ed4:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800edb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ee2:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ee8:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800eef:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ef6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800efd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f04:	84 c0                	test   %al,%al
  800f06:	74 20                	je     800f28 <snprintf+0x58>
  800f08:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f0c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f10:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f14:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f18:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f1c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f20:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f24:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f28:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f2f:	00 00 00 
  800f32:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f39:	00 00 00 
  800f3c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f40:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f47:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f4e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f55:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f5c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f63:	48 8b 0a             	mov    (%rdx),%rcx
  800f66:	48 89 08             	mov    %rcx,(%rax)
  800f69:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f6d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f71:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f75:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f79:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f80:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f87:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f8d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f94:	48 89 c7             	mov    %rax,%rdi
  800f97:	48 b8 33 0e 80 00 00 	movabs $0x800e33,%rax
  800f9e:	00 00 00 
  800fa1:	ff d0                	callq  *%rax
  800fa3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fa9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800faf:	c9                   	leaveq 
  800fb0:	c3                   	retq   

0000000000800fb1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fb1:	55                   	push   %rbp
  800fb2:	48 89 e5             	mov    %rsp,%rbp
  800fb5:	48 83 ec 18          	sub    $0x18,%rsp
  800fb9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fc4:	eb 09                	jmp    800fcf <strlen+0x1e>
		n++;
  800fc6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fca:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd3:	0f b6 00             	movzbl (%rax),%eax
  800fd6:	84 c0                	test   %al,%al
  800fd8:	75 ec                	jne    800fc6 <strlen+0x15>
		n++;
	return n;
  800fda:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fdd:	c9                   	leaveq 
  800fde:	c3                   	retq   

0000000000800fdf <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fdf:	55                   	push   %rbp
  800fe0:	48 89 e5             	mov    %rsp,%rbp
  800fe3:	48 83 ec 20          	sub    $0x20,%rsp
  800fe7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800feb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ff6:	eb 0e                	jmp    801006 <strnlen+0x27>
		n++;
  800ff8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ffc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801001:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801006:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80100b:	74 0b                	je     801018 <strnlen+0x39>
  80100d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801011:	0f b6 00             	movzbl (%rax),%eax
  801014:	84 c0                	test   %al,%al
  801016:	75 e0                	jne    800ff8 <strnlen+0x19>
		n++;
	return n;
  801018:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80101b:	c9                   	leaveq 
  80101c:	c3                   	retq   

000000000080101d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80101d:	55                   	push   %rbp
  80101e:	48 89 e5             	mov    %rsp,%rbp
  801021:	48 83 ec 20          	sub    $0x20,%rsp
  801025:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801029:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80102d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801031:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801035:	90                   	nop
  801036:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80103e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801042:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801046:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80104a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80104e:	0f b6 12             	movzbl (%rdx),%edx
  801051:	88 10                	mov    %dl,(%rax)
  801053:	0f b6 00             	movzbl (%rax),%eax
  801056:	84 c0                	test   %al,%al
  801058:	75 dc                	jne    801036 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80105a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80105e:	c9                   	leaveq 
  80105f:	c3                   	retq   

0000000000801060 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801060:	55                   	push   %rbp
  801061:	48 89 e5             	mov    %rsp,%rbp
  801064:	48 83 ec 20          	sub    $0x20,%rsp
  801068:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80106c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801070:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801074:	48 89 c7             	mov    %rax,%rdi
  801077:	48 b8 b1 0f 80 00 00 	movabs $0x800fb1,%rax
  80107e:	00 00 00 
  801081:	ff d0                	callq  *%rax
  801083:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801086:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801089:	48 63 d0             	movslq %eax,%rdx
  80108c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801090:	48 01 c2             	add    %rax,%rdx
  801093:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801097:	48 89 c6             	mov    %rax,%rsi
  80109a:	48 89 d7             	mov    %rdx,%rdi
  80109d:	48 b8 1d 10 80 00 00 	movabs $0x80101d,%rax
  8010a4:	00 00 00 
  8010a7:	ff d0                	callq  *%rax
	return dst;
  8010a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010ad:	c9                   	leaveq 
  8010ae:	c3                   	retq   

00000000008010af <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010af:	55                   	push   %rbp
  8010b0:	48 89 e5             	mov    %rsp,%rbp
  8010b3:	48 83 ec 28          	sub    $0x28,%rsp
  8010b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010bf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010cb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010d2:	00 
  8010d3:	eb 2a                	jmp    8010ff <strncpy+0x50>
		*dst++ = *src;
  8010d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010dd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010e1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010e5:	0f b6 12             	movzbl (%rdx),%edx
  8010e8:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010ee:	0f b6 00             	movzbl (%rax),%eax
  8010f1:	84 c0                	test   %al,%al
  8010f3:	74 05                	je     8010fa <strncpy+0x4b>
			src++;
  8010f5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010fa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801103:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801107:	72 cc                	jb     8010d5 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801109:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80110d:	c9                   	leaveq 
  80110e:	c3                   	retq   

000000000080110f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80110f:	55                   	push   %rbp
  801110:	48 89 e5             	mov    %rsp,%rbp
  801113:	48 83 ec 28          	sub    $0x28,%rsp
  801117:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80111b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80111f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801123:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801127:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80112b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801130:	74 3d                	je     80116f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801132:	eb 1d                	jmp    801151 <strlcpy+0x42>
			*dst++ = *src++;
  801134:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801138:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80113c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801140:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801144:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801148:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80114c:	0f b6 12             	movzbl (%rdx),%edx
  80114f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801151:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801156:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80115b:	74 0b                	je     801168 <strlcpy+0x59>
  80115d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801161:	0f b6 00             	movzbl (%rax),%eax
  801164:	84 c0                	test   %al,%al
  801166:	75 cc                	jne    801134 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80116f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801173:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801177:	48 29 c2             	sub    %rax,%rdx
  80117a:	48 89 d0             	mov    %rdx,%rax
}
  80117d:	c9                   	leaveq 
  80117e:	c3                   	retq   

000000000080117f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80117f:	55                   	push   %rbp
  801180:	48 89 e5             	mov    %rsp,%rbp
  801183:	48 83 ec 10          	sub    $0x10,%rsp
  801187:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80118b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80118f:	eb 0a                	jmp    80119b <strcmp+0x1c>
		p++, q++;
  801191:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801196:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80119b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119f:	0f b6 00             	movzbl (%rax),%eax
  8011a2:	84 c0                	test   %al,%al
  8011a4:	74 12                	je     8011b8 <strcmp+0x39>
  8011a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011aa:	0f b6 10             	movzbl (%rax),%edx
  8011ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b1:	0f b6 00             	movzbl (%rax),%eax
  8011b4:	38 c2                	cmp    %al,%dl
  8011b6:	74 d9                	je     801191 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bc:	0f b6 00             	movzbl (%rax),%eax
  8011bf:	0f b6 d0             	movzbl %al,%edx
  8011c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c6:	0f b6 00             	movzbl (%rax),%eax
  8011c9:	0f b6 c0             	movzbl %al,%eax
  8011cc:	29 c2                	sub    %eax,%edx
  8011ce:	89 d0                	mov    %edx,%eax
}
  8011d0:	c9                   	leaveq 
  8011d1:	c3                   	retq   

00000000008011d2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011d2:	55                   	push   %rbp
  8011d3:	48 89 e5             	mov    %rsp,%rbp
  8011d6:	48 83 ec 18          	sub    $0x18,%rsp
  8011da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011e2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011e6:	eb 0f                	jmp    8011f7 <strncmp+0x25>
		n--, p++, q++;
  8011e8:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011f7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011fc:	74 1d                	je     80121b <strncmp+0x49>
  8011fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801202:	0f b6 00             	movzbl (%rax),%eax
  801205:	84 c0                	test   %al,%al
  801207:	74 12                	je     80121b <strncmp+0x49>
  801209:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120d:	0f b6 10             	movzbl (%rax),%edx
  801210:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801214:	0f b6 00             	movzbl (%rax),%eax
  801217:	38 c2                	cmp    %al,%dl
  801219:	74 cd                	je     8011e8 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80121b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801220:	75 07                	jne    801229 <strncmp+0x57>
		return 0;
  801222:	b8 00 00 00 00       	mov    $0x0,%eax
  801227:	eb 18                	jmp    801241 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801229:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122d:	0f b6 00             	movzbl (%rax),%eax
  801230:	0f b6 d0             	movzbl %al,%edx
  801233:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801237:	0f b6 00             	movzbl (%rax),%eax
  80123a:	0f b6 c0             	movzbl %al,%eax
  80123d:	29 c2                	sub    %eax,%edx
  80123f:	89 d0                	mov    %edx,%eax
}
  801241:	c9                   	leaveq 
  801242:	c3                   	retq   

0000000000801243 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801243:	55                   	push   %rbp
  801244:	48 89 e5             	mov    %rsp,%rbp
  801247:	48 83 ec 10          	sub    $0x10,%rsp
  80124b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80124f:	89 f0                	mov    %esi,%eax
  801251:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801254:	eb 17                	jmp    80126d <strchr+0x2a>
		if (*s == c)
  801256:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125a:	0f b6 00             	movzbl (%rax),%eax
  80125d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801260:	75 06                	jne    801268 <strchr+0x25>
			return (char *) s;
  801262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801266:	eb 15                	jmp    80127d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801268:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80126d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801271:	0f b6 00             	movzbl (%rax),%eax
  801274:	84 c0                	test   %al,%al
  801276:	75 de                	jne    801256 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801278:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127d:	c9                   	leaveq 
  80127e:	c3                   	retq   

000000000080127f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80127f:	55                   	push   %rbp
  801280:	48 89 e5             	mov    %rsp,%rbp
  801283:	48 83 ec 10          	sub    $0x10,%rsp
  801287:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80128b:	89 f0                	mov    %esi,%eax
  80128d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801290:	eb 11                	jmp    8012a3 <strfind+0x24>
		if (*s == c)
  801292:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801296:	0f b6 00             	movzbl (%rax),%eax
  801299:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80129c:	74 12                	je     8012b0 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80129e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a7:	0f b6 00             	movzbl (%rax),%eax
  8012aa:	84 c0                	test   %al,%al
  8012ac:	75 e4                	jne    801292 <strfind+0x13>
  8012ae:	eb 01                	jmp    8012b1 <strfind+0x32>
		if (*s == c)
			break;
  8012b0:	90                   	nop
	return (char *) s;
  8012b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012b5:	c9                   	leaveq 
  8012b6:	c3                   	retq   

00000000008012b7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012b7:	55                   	push   %rbp
  8012b8:	48 89 e5             	mov    %rsp,%rbp
  8012bb:	48 83 ec 18          	sub    $0x18,%rsp
  8012bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012c6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012ca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012cf:	75 06                	jne    8012d7 <memset+0x20>
		return v;
  8012d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d5:	eb 69                	jmp    801340 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012db:	83 e0 03             	and    $0x3,%eax
  8012de:	48 85 c0             	test   %rax,%rax
  8012e1:	75 48                	jne    80132b <memset+0x74>
  8012e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e7:	83 e0 03             	and    $0x3,%eax
  8012ea:	48 85 c0             	test   %rax,%rax
  8012ed:	75 3c                	jne    80132b <memset+0x74>
		c &= 0xFF;
  8012ef:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012f9:	c1 e0 18             	shl    $0x18,%eax
  8012fc:	89 c2                	mov    %eax,%edx
  8012fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801301:	c1 e0 10             	shl    $0x10,%eax
  801304:	09 c2                	or     %eax,%edx
  801306:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801309:	c1 e0 08             	shl    $0x8,%eax
  80130c:	09 d0                	or     %edx,%eax
  80130e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801315:	48 c1 e8 02          	shr    $0x2,%rax
  801319:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80131c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801320:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801323:	48 89 d7             	mov    %rdx,%rdi
  801326:	fc                   	cld    
  801327:	f3 ab                	rep stos %eax,%es:(%rdi)
  801329:	eb 11                	jmp    80133c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80132b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80132f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801332:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801336:	48 89 d7             	mov    %rdx,%rdi
  801339:	fc                   	cld    
  80133a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80133c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801340:	c9                   	leaveq 
  801341:	c3                   	retq   

0000000000801342 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801342:	55                   	push   %rbp
  801343:	48 89 e5             	mov    %rsp,%rbp
  801346:	48 83 ec 28          	sub    $0x28,%rsp
  80134a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80134e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801352:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801356:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80135e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801362:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801366:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80136e:	0f 83 88 00 00 00    	jae    8013fc <memmove+0xba>
  801374:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801378:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137c:	48 01 d0             	add    %rdx,%rax
  80137f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801383:	76 77                	jbe    8013fc <memmove+0xba>
		s += n;
  801385:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801389:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80138d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801391:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801395:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801399:	83 e0 03             	and    $0x3,%eax
  80139c:	48 85 c0             	test   %rax,%rax
  80139f:	75 3b                	jne    8013dc <memmove+0x9a>
  8013a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a5:	83 e0 03             	and    $0x3,%eax
  8013a8:	48 85 c0             	test   %rax,%rax
  8013ab:	75 2f                	jne    8013dc <memmove+0x9a>
  8013ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b1:	83 e0 03             	and    $0x3,%eax
  8013b4:	48 85 c0             	test   %rax,%rax
  8013b7:	75 23                	jne    8013dc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bd:	48 83 e8 04          	sub    $0x4,%rax
  8013c1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c5:	48 83 ea 04          	sub    $0x4,%rdx
  8013c9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013cd:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013d1:	48 89 c7             	mov    %rax,%rdi
  8013d4:	48 89 d6             	mov    %rdx,%rsi
  8013d7:	fd                   	std    
  8013d8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013da:	eb 1d                	jmp    8013f9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f0:	48 89 d7             	mov    %rdx,%rdi
  8013f3:	48 89 c1             	mov    %rax,%rcx
  8013f6:	fd                   	std    
  8013f7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013f9:	fc                   	cld    
  8013fa:	eb 57                	jmp    801453 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801400:	83 e0 03             	and    $0x3,%eax
  801403:	48 85 c0             	test   %rax,%rax
  801406:	75 36                	jne    80143e <memmove+0xfc>
  801408:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140c:	83 e0 03             	and    $0x3,%eax
  80140f:	48 85 c0             	test   %rax,%rax
  801412:	75 2a                	jne    80143e <memmove+0xfc>
  801414:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801418:	83 e0 03             	and    $0x3,%eax
  80141b:	48 85 c0             	test   %rax,%rax
  80141e:	75 1e                	jne    80143e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801420:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801424:	48 c1 e8 02          	shr    $0x2,%rax
  801428:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80142b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801433:	48 89 c7             	mov    %rax,%rdi
  801436:	48 89 d6             	mov    %rdx,%rsi
  801439:	fc                   	cld    
  80143a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80143c:	eb 15                	jmp    801453 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80143e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801442:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801446:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80144a:	48 89 c7             	mov    %rax,%rdi
  80144d:	48 89 d6             	mov    %rdx,%rsi
  801450:	fc                   	cld    
  801451:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801453:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801457:	c9                   	leaveq 
  801458:	c3                   	retq   

0000000000801459 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801459:	55                   	push   %rbp
  80145a:	48 89 e5             	mov    %rsp,%rbp
  80145d:	48 83 ec 18          	sub    $0x18,%rsp
  801461:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801465:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801469:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80146d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801471:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801475:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801479:	48 89 ce             	mov    %rcx,%rsi
  80147c:	48 89 c7             	mov    %rax,%rdi
  80147f:	48 b8 42 13 80 00 00 	movabs $0x801342,%rax
  801486:	00 00 00 
  801489:	ff d0                	callq  *%rax
}
  80148b:	c9                   	leaveq 
  80148c:	c3                   	retq   

000000000080148d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80148d:	55                   	push   %rbp
  80148e:	48 89 e5             	mov    %rsp,%rbp
  801491:	48 83 ec 28          	sub    $0x28,%rsp
  801495:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801499:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80149d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014b1:	eb 36                	jmp    8014e9 <memcmp+0x5c>
		if (*s1 != *s2)
  8014b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b7:	0f b6 10             	movzbl (%rax),%edx
  8014ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014be:	0f b6 00             	movzbl (%rax),%eax
  8014c1:	38 c2                	cmp    %al,%dl
  8014c3:	74 1a                	je     8014df <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c9:	0f b6 00             	movzbl (%rax),%eax
  8014cc:	0f b6 d0             	movzbl %al,%edx
  8014cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d3:	0f b6 00             	movzbl (%rax),%eax
  8014d6:	0f b6 c0             	movzbl %al,%eax
  8014d9:	29 c2                	sub    %eax,%edx
  8014db:	89 d0                	mov    %edx,%eax
  8014dd:	eb 20                	jmp    8014ff <memcmp+0x72>
		s1++, s2++;
  8014df:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ed:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014f5:	48 85 c0             	test   %rax,%rax
  8014f8:	75 b9                	jne    8014b3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ff:	c9                   	leaveq 
  801500:	c3                   	retq   

0000000000801501 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801501:	55                   	push   %rbp
  801502:	48 89 e5             	mov    %rsp,%rbp
  801505:	48 83 ec 28          	sub    $0x28,%rsp
  801509:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80150d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801510:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801514:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801518:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151c:	48 01 d0             	add    %rdx,%rax
  80151f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801523:	eb 19                	jmp    80153e <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801529:	0f b6 00             	movzbl (%rax),%eax
  80152c:	0f b6 d0             	movzbl %al,%edx
  80152f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801532:	0f b6 c0             	movzbl %al,%eax
  801535:	39 c2                	cmp    %eax,%edx
  801537:	74 11                	je     80154a <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801539:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80153e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801542:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801546:	72 dd                	jb     801525 <memfind+0x24>
  801548:	eb 01                	jmp    80154b <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80154a:	90                   	nop
	return (void *) s;
  80154b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80154f:	c9                   	leaveq 
  801550:	c3                   	retq   

0000000000801551 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801551:	55                   	push   %rbp
  801552:	48 89 e5             	mov    %rsp,%rbp
  801555:	48 83 ec 38          	sub    $0x38,%rsp
  801559:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80155d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801561:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801564:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80156b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801572:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801573:	eb 05                	jmp    80157a <strtol+0x29>
		s++;
  801575:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80157a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157e:	0f b6 00             	movzbl (%rax),%eax
  801581:	3c 20                	cmp    $0x20,%al
  801583:	74 f0                	je     801575 <strtol+0x24>
  801585:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801589:	0f b6 00             	movzbl (%rax),%eax
  80158c:	3c 09                	cmp    $0x9,%al
  80158e:	74 e5                	je     801575 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801590:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801594:	0f b6 00             	movzbl (%rax),%eax
  801597:	3c 2b                	cmp    $0x2b,%al
  801599:	75 07                	jne    8015a2 <strtol+0x51>
		s++;
  80159b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015a0:	eb 17                	jmp    8015b9 <strtol+0x68>
	else if (*s == '-')
  8015a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a6:	0f b6 00             	movzbl (%rax),%eax
  8015a9:	3c 2d                	cmp    $0x2d,%al
  8015ab:	75 0c                	jne    8015b9 <strtol+0x68>
		s++, neg = 1;
  8015ad:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015b9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015bd:	74 06                	je     8015c5 <strtol+0x74>
  8015bf:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015c3:	75 28                	jne    8015ed <strtol+0x9c>
  8015c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c9:	0f b6 00             	movzbl (%rax),%eax
  8015cc:	3c 30                	cmp    $0x30,%al
  8015ce:	75 1d                	jne    8015ed <strtol+0x9c>
  8015d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d4:	48 83 c0 01          	add    $0x1,%rax
  8015d8:	0f b6 00             	movzbl (%rax),%eax
  8015db:	3c 78                	cmp    $0x78,%al
  8015dd:	75 0e                	jne    8015ed <strtol+0x9c>
		s += 2, base = 16;
  8015df:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015e4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015eb:	eb 2c                	jmp    801619 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015ed:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015f1:	75 19                	jne    80160c <strtol+0xbb>
  8015f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f7:	0f b6 00             	movzbl (%rax),%eax
  8015fa:	3c 30                	cmp    $0x30,%al
  8015fc:	75 0e                	jne    80160c <strtol+0xbb>
		s++, base = 8;
  8015fe:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801603:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80160a:	eb 0d                	jmp    801619 <strtol+0xc8>
	else if (base == 0)
  80160c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801610:	75 07                	jne    801619 <strtol+0xc8>
		base = 10;
  801612:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801619:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161d:	0f b6 00             	movzbl (%rax),%eax
  801620:	3c 2f                	cmp    $0x2f,%al
  801622:	7e 1d                	jle    801641 <strtol+0xf0>
  801624:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801628:	0f b6 00             	movzbl (%rax),%eax
  80162b:	3c 39                	cmp    $0x39,%al
  80162d:	7f 12                	jg     801641 <strtol+0xf0>
			dig = *s - '0';
  80162f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801633:	0f b6 00             	movzbl (%rax),%eax
  801636:	0f be c0             	movsbl %al,%eax
  801639:	83 e8 30             	sub    $0x30,%eax
  80163c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80163f:	eb 4e                	jmp    80168f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801641:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801645:	0f b6 00             	movzbl (%rax),%eax
  801648:	3c 60                	cmp    $0x60,%al
  80164a:	7e 1d                	jle    801669 <strtol+0x118>
  80164c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801650:	0f b6 00             	movzbl (%rax),%eax
  801653:	3c 7a                	cmp    $0x7a,%al
  801655:	7f 12                	jg     801669 <strtol+0x118>
			dig = *s - 'a' + 10;
  801657:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165b:	0f b6 00             	movzbl (%rax),%eax
  80165e:	0f be c0             	movsbl %al,%eax
  801661:	83 e8 57             	sub    $0x57,%eax
  801664:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801667:	eb 26                	jmp    80168f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801669:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166d:	0f b6 00             	movzbl (%rax),%eax
  801670:	3c 40                	cmp    $0x40,%al
  801672:	7e 47                	jle    8016bb <strtol+0x16a>
  801674:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801678:	0f b6 00             	movzbl (%rax),%eax
  80167b:	3c 5a                	cmp    $0x5a,%al
  80167d:	7f 3c                	jg     8016bb <strtol+0x16a>
			dig = *s - 'A' + 10;
  80167f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801683:	0f b6 00             	movzbl (%rax),%eax
  801686:	0f be c0             	movsbl %al,%eax
  801689:	83 e8 37             	sub    $0x37,%eax
  80168c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80168f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801692:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801695:	7d 23                	jge    8016ba <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801697:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80169c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80169f:	48 98                	cltq   
  8016a1:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016a6:	48 89 c2             	mov    %rax,%rdx
  8016a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016ac:	48 98                	cltq   
  8016ae:	48 01 d0             	add    %rdx,%rax
  8016b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016b5:	e9 5f ff ff ff       	jmpq   801619 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016ba:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016bb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016c0:	74 0b                	je     8016cd <strtol+0x17c>
		*endptr = (char *) s;
  8016c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016ca:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016d1:	74 09                	je     8016dc <strtol+0x18b>
  8016d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d7:	48 f7 d8             	neg    %rax
  8016da:	eb 04                	jmp    8016e0 <strtol+0x18f>
  8016dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016e0:	c9                   	leaveq 
  8016e1:	c3                   	retq   

00000000008016e2 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016e2:	55                   	push   %rbp
  8016e3:	48 89 e5             	mov    %rsp,%rbp
  8016e6:	48 83 ec 30          	sub    $0x30,%rsp
  8016ea:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016ee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016fa:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016fe:	0f b6 00             	movzbl (%rax),%eax
  801701:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801704:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801708:	75 06                	jne    801710 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80170a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170e:	eb 6b                	jmp    80177b <strstr+0x99>

	len = strlen(str);
  801710:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801714:	48 89 c7             	mov    %rax,%rdi
  801717:	48 b8 b1 0f 80 00 00 	movabs $0x800fb1,%rax
  80171e:	00 00 00 
  801721:	ff d0                	callq  *%rax
  801723:	48 98                	cltq   
  801725:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801729:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801731:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801735:	0f b6 00             	movzbl (%rax),%eax
  801738:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80173b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80173f:	75 07                	jne    801748 <strstr+0x66>
				return (char *) 0;
  801741:	b8 00 00 00 00       	mov    $0x0,%eax
  801746:	eb 33                	jmp    80177b <strstr+0x99>
		} while (sc != c);
  801748:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80174c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80174f:	75 d8                	jne    801729 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801751:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801755:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801759:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175d:	48 89 ce             	mov    %rcx,%rsi
  801760:	48 89 c7             	mov    %rax,%rdi
  801763:	48 b8 d2 11 80 00 00 	movabs $0x8011d2,%rax
  80176a:	00 00 00 
  80176d:	ff d0                	callq  *%rax
  80176f:	85 c0                	test   %eax,%eax
  801771:	75 b6                	jne    801729 <strstr+0x47>

	return (char *) (in - 1);
  801773:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801777:	48 83 e8 01          	sub    $0x1,%rax
}
  80177b:	c9                   	leaveq 
  80177c:	c3                   	retq   

000000000080177d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80177d:	55                   	push   %rbp
  80177e:	48 89 e5             	mov    %rsp,%rbp
  801781:	53                   	push   %rbx
  801782:	48 83 ec 48          	sub    $0x48,%rsp
  801786:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801789:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80178c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801790:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801794:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801798:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80179c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80179f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017a3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017a7:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017ab:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017af:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017b3:	4c 89 c3             	mov    %r8,%rbx
  8017b6:	cd 30                	int    $0x30
  8017b8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017bc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017c0:	74 3e                	je     801800 <syscall+0x83>
  8017c2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017c7:	7e 37                	jle    801800 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017cd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017d0:	49 89 d0             	mov    %rdx,%r8
  8017d3:	89 c1                	mov    %eax,%ecx
  8017d5:	48 ba c8 20 80 00 00 	movabs $0x8020c8,%rdx
  8017dc:	00 00 00 
  8017df:	be 23 00 00 00       	mov    $0x23,%esi
  8017e4:	48 bf e5 20 80 00 00 	movabs $0x8020e5,%rdi
  8017eb:	00 00 00 
  8017ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f3:	49 b9 53 02 80 00 00 	movabs $0x800253,%r9
  8017fa:	00 00 00 
  8017fd:	41 ff d1             	callq  *%r9

	return ret;
  801800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801804:	48 83 c4 48          	add    $0x48,%rsp
  801808:	5b                   	pop    %rbx
  801809:	5d                   	pop    %rbp
  80180a:	c3                   	retq   

000000000080180b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80180b:	55                   	push   %rbp
  80180c:	48 89 e5             	mov    %rsp,%rbp
  80180f:	48 83 ec 10          	sub    $0x10,%rsp
  801813:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801817:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80181b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80181f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801823:	48 83 ec 08          	sub    $0x8,%rsp
  801827:	6a 00                	pushq  $0x0
  801829:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801835:	48 89 d1             	mov    %rdx,%rcx
  801838:	48 89 c2             	mov    %rax,%rdx
  80183b:	be 00 00 00 00       	mov    $0x0,%esi
  801840:	bf 00 00 00 00       	mov    $0x0,%edi
  801845:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  80184c:	00 00 00 
  80184f:	ff d0                	callq  *%rax
  801851:	48 83 c4 10          	add    $0x10,%rsp
}
  801855:	90                   	nop
  801856:	c9                   	leaveq 
  801857:	c3                   	retq   

0000000000801858 <sys_cgetc>:

int
sys_cgetc(void)
{
  801858:	55                   	push   %rbp
  801859:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80185c:	48 83 ec 08          	sub    $0x8,%rsp
  801860:	6a 00                	pushq  $0x0
  801862:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801868:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80186e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801873:	ba 00 00 00 00       	mov    $0x0,%edx
  801878:	be 00 00 00 00       	mov    $0x0,%esi
  80187d:	bf 01 00 00 00       	mov    $0x1,%edi
  801882:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  801889:	00 00 00 
  80188c:	ff d0                	callq  *%rax
  80188e:	48 83 c4 10          	add    $0x10,%rsp
}
  801892:	c9                   	leaveq 
  801893:	c3                   	retq   

0000000000801894 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801894:	55                   	push   %rbp
  801895:	48 89 e5             	mov    %rsp,%rbp
  801898:	48 83 ec 10          	sub    $0x10,%rsp
  80189c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80189f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a2:	48 98                	cltq   
  8018a4:	48 83 ec 08          	sub    $0x8,%rsp
  8018a8:	6a 00                	pushq  $0x0
  8018aa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018bb:	48 89 c2             	mov    %rax,%rdx
  8018be:	be 01 00 00 00       	mov    $0x1,%esi
  8018c3:	bf 03 00 00 00       	mov    $0x3,%edi
  8018c8:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  8018cf:	00 00 00 
  8018d2:	ff d0                	callq  *%rax
  8018d4:	48 83 c4 10          	add    $0x10,%rsp
}
  8018d8:	c9                   	leaveq 
  8018d9:	c3                   	retq   

00000000008018da <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018da:	55                   	push   %rbp
  8018db:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018de:	48 83 ec 08          	sub    $0x8,%rsp
  8018e2:	6a 00                	pushq  $0x0
  8018e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fa:	be 00 00 00 00       	mov    $0x0,%esi
  8018ff:	bf 02 00 00 00       	mov    $0x2,%edi
  801904:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  80190b:	00 00 00 
  80190e:	ff d0                	callq  *%rax
  801910:	48 83 c4 10          	add    $0x10,%rsp
}
  801914:	c9                   	leaveq 
  801915:	c3                   	retq   

0000000000801916 <sys_yield>:

void
sys_yield(void)
{
  801916:	55                   	push   %rbp
  801917:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80191a:	48 83 ec 08          	sub    $0x8,%rsp
  80191e:	6a 00                	pushq  $0x0
  801920:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801926:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801931:	ba 00 00 00 00       	mov    $0x0,%edx
  801936:	be 00 00 00 00       	mov    $0x0,%esi
  80193b:	bf 0a 00 00 00       	mov    $0xa,%edi
  801940:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  801947:	00 00 00 
  80194a:	ff d0                	callq  *%rax
  80194c:	48 83 c4 10          	add    $0x10,%rsp
}
  801950:	90                   	nop
  801951:	c9                   	leaveq 
  801952:	c3                   	retq   

0000000000801953 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801953:	55                   	push   %rbp
  801954:	48 89 e5             	mov    %rsp,%rbp
  801957:	48 83 ec 10          	sub    $0x10,%rsp
  80195b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80195e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801962:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801965:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801968:	48 63 c8             	movslq %eax,%rcx
  80196b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801972:	48 98                	cltq   
  801974:	48 83 ec 08          	sub    $0x8,%rsp
  801978:	6a 00                	pushq  $0x0
  80197a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801980:	49 89 c8             	mov    %rcx,%r8
  801983:	48 89 d1             	mov    %rdx,%rcx
  801986:	48 89 c2             	mov    %rax,%rdx
  801989:	be 01 00 00 00       	mov    $0x1,%esi
  80198e:	bf 04 00 00 00       	mov    $0x4,%edi
  801993:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  80199a:	00 00 00 
  80199d:	ff d0                	callq  *%rax
  80199f:	48 83 c4 10          	add    $0x10,%rsp
}
  8019a3:	c9                   	leaveq 
  8019a4:	c3                   	retq   

00000000008019a5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019a5:	55                   	push   %rbp
  8019a6:	48 89 e5             	mov    %rsp,%rbp
  8019a9:	48 83 ec 20          	sub    $0x20,%rsp
  8019ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019b4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019b7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019bb:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019bf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019c2:	48 63 c8             	movslq %eax,%rcx
  8019c5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019cc:	48 63 f0             	movslq %eax,%rsi
  8019cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d6:	48 98                	cltq   
  8019d8:	48 83 ec 08          	sub    $0x8,%rsp
  8019dc:	51                   	push   %rcx
  8019dd:	49 89 f9             	mov    %rdi,%r9
  8019e0:	49 89 f0             	mov    %rsi,%r8
  8019e3:	48 89 d1             	mov    %rdx,%rcx
  8019e6:	48 89 c2             	mov    %rax,%rdx
  8019e9:	be 01 00 00 00       	mov    $0x1,%esi
  8019ee:	bf 05 00 00 00       	mov    $0x5,%edi
  8019f3:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  8019fa:	00 00 00 
  8019fd:	ff d0                	callq  *%rax
  8019ff:	48 83 c4 10          	add    $0x10,%rsp
}
  801a03:	c9                   	leaveq 
  801a04:	c3                   	retq   

0000000000801a05 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a05:	55                   	push   %rbp
  801a06:	48 89 e5             	mov    %rsp,%rbp
  801a09:	48 83 ec 10          	sub    $0x10,%rsp
  801a0d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a10:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a1b:	48 98                	cltq   
  801a1d:	48 83 ec 08          	sub    $0x8,%rsp
  801a21:	6a 00                	pushq  $0x0
  801a23:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a29:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2f:	48 89 d1             	mov    %rdx,%rcx
  801a32:	48 89 c2             	mov    %rax,%rdx
  801a35:	be 01 00 00 00       	mov    $0x1,%esi
  801a3a:	bf 06 00 00 00       	mov    $0x6,%edi
  801a3f:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  801a46:	00 00 00 
  801a49:	ff d0                	callq  *%rax
  801a4b:	48 83 c4 10          	add    $0x10,%rsp
}
  801a4f:	c9                   	leaveq 
  801a50:	c3                   	retq   

0000000000801a51 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a51:	55                   	push   %rbp
  801a52:	48 89 e5             	mov    %rsp,%rbp
  801a55:	48 83 ec 10          	sub    $0x10,%rsp
  801a59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a5c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a62:	48 63 d0             	movslq %eax,%rdx
  801a65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a68:	48 98                	cltq   
  801a6a:	48 83 ec 08          	sub    $0x8,%rsp
  801a6e:	6a 00                	pushq  $0x0
  801a70:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a76:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a7c:	48 89 d1             	mov    %rdx,%rcx
  801a7f:	48 89 c2             	mov    %rax,%rdx
  801a82:	be 01 00 00 00       	mov    $0x1,%esi
  801a87:	bf 08 00 00 00       	mov    $0x8,%edi
  801a8c:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  801a93:	00 00 00 
  801a96:	ff d0                	callq  *%rax
  801a98:	48 83 c4 10          	add    $0x10,%rsp
}
  801a9c:	c9                   	leaveq 
  801a9d:	c3                   	retq   

0000000000801a9e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a9e:	55                   	push   %rbp
  801a9f:	48 89 e5             	mov    %rsp,%rbp
  801aa2:	48 83 ec 10          	sub    $0x10,%rsp
  801aa6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aa9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801aad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab4:	48 98                	cltq   
  801ab6:	48 83 ec 08          	sub    $0x8,%rsp
  801aba:	6a 00                	pushq  $0x0
  801abc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac8:	48 89 d1             	mov    %rdx,%rcx
  801acb:	48 89 c2             	mov    %rax,%rdx
  801ace:	be 01 00 00 00       	mov    $0x1,%esi
  801ad3:	bf 09 00 00 00       	mov    $0x9,%edi
  801ad8:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  801adf:	00 00 00 
  801ae2:	ff d0                	callq  *%rax
  801ae4:	48 83 c4 10          	add    $0x10,%rsp
}
  801ae8:	c9                   	leaveq 
  801ae9:	c3                   	retq   

0000000000801aea <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801aea:	55                   	push   %rbp
  801aeb:	48 89 e5             	mov    %rsp,%rbp
  801aee:	48 83 ec 20          	sub    $0x20,%rsp
  801af2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801af9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801afd:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b00:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b03:	48 63 f0             	movslq %eax,%rsi
  801b06:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b0d:	48 98                	cltq   
  801b0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b13:	48 83 ec 08          	sub    $0x8,%rsp
  801b17:	6a 00                	pushq  $0x0
  801b19:	49 89 f1             	mov    %rsi,%r9
  801b1c:	49 89 c8             	mov    %rcx,%r8
  801b1f:	48 89 d1             	mov    %rdx,%rcx
  801b22:	48 89 c2             	mov    %rax,%rdx
  801b25:	be 00 00 00 00       	mov    $0x0,%esi
  801b2a:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b2f:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  801b36:	00 00 00 
  801b39:	ff d0                	callq  *%rax
  801b3b:	48 83 c4 10          	add    $0x10,%rsp
}
  801b3f:	c9                   	leaveq 
  801b40:	c3                   	retq   

0000000000801b41 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b41:	55                   	push   %rbp
  801b42:	48 89 e5             	mov    %rsp,%rbp
  801b45:	48 83 ec 10          	sub    $0x10,%rsp
  801b49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b51:	48 83 ec 08          	sub    $0x8,%rsp
  801b55:	6a 00                	pushq  $0x0
  801b57:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b5d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b63:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b68:	48 89 c2             	mov    %rax,%rdx
  801b6b:	be 01 00 00 00       	mov    $0x1,%esi
  801b70:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b75:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  801b7c:	00 00 00 
  801b7f:	ff d0                	callq  *%rax
  801b81:	48 83 c4 10          	add    $0x10,%rsp
}
  801b85:	c9                   	leaveq 
  801b86:	c3                   	retq   
