
obj/user/primes:     file format elf64-x86-64


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
  80003c:	e8 8b 01 00 00       	callq  8001cc <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80004b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80004f:	ba 00 00 00 00       	mov    $0x0,%edx
  800054:	be 00 00 00 00       	mov    $0x0,%esi
  800059:	48 89 c7             	mov    %rax,%rdi
  80005c:	48 b8 69 22 80 00 00 	movabs $0x802269,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80006b:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  800072:	00 00 00 
  800075:	48 8b 00             	mov    (%rax),%rax
  800078:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
  80007e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800081:	89 c6                	mov    %eax,%esi
  800083:	48 bf a0 25 80 00 00 	movabs $0x8025a0,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	48 b9 aa 04 80 00 00 	movabs $0x8004aa,%rcx
  800099:	00 00 00 
  80009c:	ff d1                	callq  *%rcx

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80009e:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  8000a5:	00 00 00 
  8000a8:	ff d0                	callq  *%rax
  8000aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000ad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000b1:	79 30                	jns    8000e3 <primeproc+0xa0>
		panic("fork: %e", id);
  8000b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b6:	89 c1                	mov    %eax,%ecx
  8000b8:	48 ba ac 25 80 00 00 	movabs $0x8025ac,%rdx
  8000bf:	00 00 00 
  8000c2:	be 1a 00 00 00       	mov    $0x1a,%esi
  8000c7:	48 bf b5 25 80 00 00 	movabs $0x8025b5,%rdi
  8000ce:	00 00 00 
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	49 b8 70 02 80 00 00 	movabs $0x800270,%r8
  8000dd:	00 00 00 
  8000e0:	41 ff d0             	callq  *%r8
	if (id == 0)
  8000e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e7:	75 05                	jne    8000ee <primeproc+0xab>
		goto top;
  8000e9:	e9 5d ff ff ff       	jmpq   80004b <primeproc+0x8>

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000ee:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f7:	be 00 00 00 00       	mov    $0x0,%esi
  8000fc:	48 89 c7             	mov    %rax,%rdi
  8000ff:	48 b8 69 22 80 00 00 	movabs $0x802269,%rax
  800106:	00 00 00 
  800109:	ff d0                	callq  *%rax
  80010b:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (i % p)
  80010e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800111:	99                   	cltd   
  800112:	f7 7d fc             	idivl  -0x4(%rbp)
  800115:	89 d0                	mov    %edx,%eax
  800117:	85 c0                	test   %eax,%eax
  800119:	74 d3                	je     8000ee <primeproc+0xab>
			ipc_send(id, i, 0, 0);
  80011b:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80011e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800121:	b9 00 00 00 00       	mov    $0x0,%ecx
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	89 c7                	mov    %eax,%edi
  80012d:	48 b8 24 23 80 00 00 	movabs $0x802324,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
	}
  800139:	eb b3                	jmp    8000ee <primeproc+0xab>

000000000080013b <umain>:
}

void
umain(int argc, char **argv)
{
  80013b:	55                   	push   %rbp
  80013c:	48 89 e5             	mov    %rsp,%rbp
  80013f:	48 83 ec 20          	sub    $0x20,%rsp
  800143:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800146:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  80014a:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  800151:	00 00 00 
  800154:	ff d0                	callq  *%rax
  800156:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800159:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80015d:	79 30                	jns    80018f <umain+0x54>
		panic("fork: %e", id);
  80015f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800162:	89 c1                	mov    %eax,%ecx
  800164:	48 ba ac 25 80 00 00 	movabs $0x8025ac,%rdx
  80016b:	00 00 00 
  80016e:	be 2d 00 00 00       	mov    $0x2d,%esi
  800173:	48 bf b5 25 80 00 00 	movabs $0x8025b5,%rdi
  80017a:	00 00 00 
  80017d:	b8 00 00 00 00       	mov    $0x0,%eax
  800182:	49 b8 70 02 80 00 00 	movabs $0x800270,%r8
  800189:	00 00 00 
  80018c:	41 ff d0             	callq  *%r8
	if (id == 0)
  80018f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800193:	75 0c                	jne    8001a1 <umain+0x66>
		primeproc();
  800195:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80019c:	00 00 00 
  80019f:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i = 2; ; i++)
  8001a1:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001a8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8001b8:	89 c7                	mov    %eax,%edi
  8001ba:	48 b8 24 23 80 00 00 	movabs $0x802324,%rax
  8001c1:	00 00 00 
  8001c4:	ff d0                	callq  *%rax
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8001c6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001ca:	eb dc                	jmp    8001a8 <umain+0x6d>

00000000008001cc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001cc:	55                   	push   %rbp
  8001cd:	48 89 e5             	mov    %rsp,%rbp
  8001d0:	48 83 ec 10          	sub    $0x10,%rsp
  8001d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  8001db:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  8001e2:	00 00 00 
  8001e5:	ff d0                	callq  *%rax
  8001e7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ec:	48 63 d0             	movslq %eax,%rdx
  8001ef:	48 89 d0             	mov    %rdx,%rax
  8001f2:	48 c1 e0 03          	shl    $0x3,%rax
  8001f6:	48 01 d0             	add    %rdx,%rax
  8001f9:	48 c1 e0 05          	shl    $0x5,%rax
  8001fd:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800204:	00 00 00 
  800207:	48 01 c2             	add    %rax,%rdx
  80020a:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  800211:	00 00 00 
  800214:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800217:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021b:	7e 14                	jle    800231 <libmain+0x65>
		binaryname = argv[0];
  80021d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800221:	48 8b 10             	mov    (%rax),%rdx
  800224:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80022b:	00 00 00 
  80022e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800231:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800235:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800238:	48 89 d6             	mov    %rdx,%rsi
  80023b:	89 c7                	mov    %eax,%edi
  80023d:	48 b8 3b 01 80 00 00 	movabs $0x80013b,%rax
  800244:	00 00 00 
  800247:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800249:	48 b8 58 02 80 00 00 	movabs $0x800258,%rax
  800250:	00 00 00 
  800253:	ff d0                	callq  *%rax
}
  800255:	90                   	nop
  800256:	c9                   	leaveq 
  800257:	c3                   	retq   

0000000000800258 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800258:	55                   	push   %rbp
  800259:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80025c:	bf 00 00 00 00       	mov    $0x0,%edi
  800261:	48 b8 b1 18 80 00 00 	movabs $0x8018b1,%rax
  800268:	00 00 00 
  80026b:	ff d0                	callq  *%rax
}
  80026d:	90                   	nop
  80026e:	5d                   	pop    %rbp
  80026f:	c3                   	retq   

0000000000800270 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800270:	55                   	push   %rbp
  800271:	48 89 e5             	mov    %rsp,%rbp
  800274:	53                   	push   %rbx
  800275:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80027c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800283:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800289:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800290:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800297:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80029e:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002a5:	84 c0                	test   %al,%al
  8002a7:	74 23                	je     8002cc <_panic+0x5c>
  8002a9:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002b0:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002b4:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002b8:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002bc:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002c0:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002c4:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002c8:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002cc:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002d3:	00 00 00 
  8002d6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002dd:	00 00 00 
  8002e0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002e4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002eb:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002f2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002f9:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800300:	00 00 00 
  800303:	48 8b 18             	mov    (%rax),%rbx
  800306:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  80030d:	00 00 00 
  800310:	ff d0                	callq  *%rax
  800312:	89 c6                	mov    %eax,%esi
  800314:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  80031a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800321:	41 89 d0             	mov    %edx,%r8d
  800324:	48 89 c1             	mov    %rax,%rcx
  800327:	48 89 da             	mov    %rbx,%rdx
  80032a:	48 bf d0 25 80 00 00 	movabs $0x8025d0,%rdi
  800331:	00 00 00 
  800334:	b8 00 00 00 00       	mov    $0x0,%eax
  800339:	49 b9 aa 04 80 00 00 	movabs $0x8004aa,%r9
  800340:	00 00 00 
  800343:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800346:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80034d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800354:	48 89 d6             	mov    %rdx,%rsi
  800357:	48 89 c7             	mov    %rax,%rdi
  80035a:	48 b8 fe 03 80 00 00 	movabs $0x8003fe,%rax
  800361:	00 00 00 
  800364:	ff d0                	callq  *%rax
	cprintf("\n");
  800366:	48 bf f3 25 80 00 00 	movabs $0x8025f3,%rdi
  80036d:	00 00 00 
  800370:	b8 00 00 00 00       	mov    $0x0,%eax
  800375:	48 ba aa 04 80 00 00 	movabs $0x8004aa,%rdx
  80037c:	00 00 00 
  80037f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800381:	cc                   	int3   
  800382:	eb fd                	jmp    800381 <_panic+0x111>

0000000000800384 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800384:	55                   	push   %rbp
  800385:	48 89 e5             	mov    %rsp,%rbp
  800388:	48 83 ec 10          	sub    $0x10,%rsp
  80038c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80038f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800393:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800397:	8b 00                	mov    (%rax),%eax
  800399:	8d 48 01             	lea    0x1(%rax),%ecx
  80039c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a0:	89 0a                	mov    %ecx,(%rdx)
  8003a2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003a5:	89 d1                	mov    %edx,%ecx
  8003a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ab:	48 98                	cltq   
  8003ad:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b5:	8b 00                	mov    (%rax),%eax
  8003b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003bc:	75 2c                	jne    8003ea <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c2:	8b 00                	mov    (%rax),%eax
  8003c4:	48 98                	cltq   
  8003c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ca:	48 83 c2 08          	add    $0x8,%rdx
  8003ce:	48 89 c6             	mov    %rax,%rsi
  8003d1:	48 89 d7             	mov    %rdx,%rdi
  8003d4:	48 b8 28 18 80 00 00 	movabs $0x801828,%rax
  8003db:	00 00 00 
  8003de:	ff d0                	callq  *%rax
        b->idx = 0;
  8003e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ee:	8b 40 04             	mov    0x4(%rax),%eax
  8003f1:	8d 50 01             	lea    0x1(%rax),%edx
  8003f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f8:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003fb:	90                   	nop
  8003fc:	c9                   	leaveq 
  8003fd:	c3                   	retq   

00000000008003fe <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003fe:	55                   	push   %rbp
  8003ff:	48 89 e5             	mov    %rsp,%rbp
  800402:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800409:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800410:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800417:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80041e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800425:	48 8b 0a             	mov    (%rdx),%rcx
  800428:	48 89 08             	mov    %rcx,(%rax)
  80042b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80042f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800433:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800437:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80043b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800442:	00 00 00 
    b.cnt = 0;
  800445:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80044c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80044f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800456:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80045d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800464:	48 89 c6             	mov    %rax,%rsi
  800467:	48 bf 84 03 80 00 00 	movabs $0x800384,%rdi
  80046e:	00 00 00 
  800471:	48 b8 48 08 80 00 00 	movabs $0x800848,%rax
  800478:	00 00 00 
  80047b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80047d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800483:	48 98                	cltq   
  800485:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80048c:	48 83 c2 08          	add    $0x8,%rdx
  800490:	48 89 c6             	mov    %rax,%rsi
  800493:	48 89 d7             	mov    %rdx,%rdi
  800496:	48 b8 28 18 80 00 00 	movabs $0x801828,%rax
  80049d:	00 00 00 
  8004a0:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004a2:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004a8:	c9                   	leaveq 
  8004a9:	c3                   	retq   

00000000008004aa <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004aa:	55                   	push   %rbp
  8004ab:	48 89 e5             	mov    %rsp,%rbp
  8004ae:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004b5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8004bc:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004c3:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004ca:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004d1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004d8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004df:	84 c0                	test   %al,%al
  8004e1:	74 20                	je     800503 <cprintf+0x59>
  8004e3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004e7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004eb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004ef:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004f3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004f7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004fb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004ff:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800503:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80050a:	00 00 00 
  80050d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800514:	00 00 00 
  800517:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80051b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800522:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800529:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800530:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800537:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80053e:	48 8b 0a             	mov    (%rdx),%rcx
  800541:	48 89 08             	mov    %rcx,(%rax)
  800544:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800548:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80054c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800550:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800554:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80055b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800562:	48 89 d6             	mov    %rdx,%rsi
  800565:	48 89 c7             	mov    %rax,%rdi
  800568:	48 b8 fe 03 80 00 00 	movabs $0x8003fe,%rax
  80056f:	00 00 00 
  800572:	ff d0                	callq  *%rax
  800574:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80057a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800580:	c9                   	leaveq 
  800581:	c3                   	retq   

0000000000800582 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800582:	55                   	push   %rbp
  800583:	48 89 e5             	mov    %rsp,%rbp
  800586:	48 83 ec 30          	sub    $0x30,%rsp
  80058a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80058e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800592:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800596:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800599:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80059d:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005a4:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8005a8:	77 54                	ja     8005fe <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005aa:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8005ad:	8d 78 ff             	lea    -0x1(%rax),%edi
  8005b0:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8005b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bc:	48 f7 f6             	div    %rsi
  8005bf:	49 89 c2             	mov    %rax,%r10
  8005c2:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8005c5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8005c8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8005cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005d0:	41 89 c9             	mov    %ecx,%r9d
  8005d3:	41 89 f8             	mov    %edi,%r8d
  8005d6:	89 d1                	mov    %edx,%ecx
  8005d8:	4c 89 d2             	mov    %r10,%rdx
  8005db:	48 89 c7             	mov    %rax,%rdi
  8005de:	48 b8 82 05 80 00 00 	movabs $0x800582,%rax
  8005e5:	00 00 00 
  8005e8:	ff d0                	callq  *%rax
  8005ea:	eb 1c                	jmp    800608 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005ec:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8005f0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8005f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005f7:	48 89 ce             	mov    %rcx,%rsi
  8005fa:	89 d7                	mov    %edx,%edi
  8005fc:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fe:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800602:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800606:	7f e4                	jg     8005ec <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800608:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80060b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060f:	ba 00 00 00 00       	mov    $0x0,%edx
  800614:	48 f7 f1             	div    %rcx
  800617:	48 b8 50 27 80 00 00 	movabs $0x802750,%rax
  80061e:	00 00 00 
  800621:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800625:	0f be d0             	movsbl %al,%edx
  800628:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80062c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800630:	48 89 ce             	mov    %rcx,%rsi
  800633:	89 d7                	mov    %edx,%edi
  800635:	ff d0                	callq  *%rax
}
  800637:	90                   	nop
  800638:	c9                   	leaveq 
  800639:	c3                   	retq   

000000000080063a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80063a:	55                   	push   %rbp
  80063b:	48 89 e5             	mov    %rsp,%rbp
  80063e:	48 83 ec 20          	sub    $0x20,%rsp
  800642:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800646:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800649:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80064d:	7e 4f                	jle    80069e <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80064f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800653:	8b 00                	mov    (%rax),%eax
  800655:	83 f8 30             	cmp    $0x30,%eax
  800658:	73 24                	jae    80067e <getuint+0x44>
  80065a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800662:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800666:	8b 00                	mov    (%rax),%eax
  800668:	89 c0                	mov    %eax,%eax
  80066a:	48 01 d0             	add    %rdx,%rax
  80066d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800671:	8b 12                	mov    (%rdx),%edx
  800673:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800676:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067a:	89 0a                	mov    %ecx,(%rdx)
  80067c:	eb 14                	jmp    800692 <getuint+0x58>
  80067e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800682:	48 8b 40 08          	mov    0x8(%rax),%rax
  800686:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80068a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800692:	48 8b 00             	mov    (%rax),%rax
  800695:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800699:	e9 9d 00 00 00       	jmpq   80073b <getuint+0x101>
	else if (lflag)
  80069e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006a2:	74 4c                	je     8006f0 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8006a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a8:	8b 00                	mov    (%rax),%eax
  8006aa:	83 f8 30             	cmp    $0x30,%eax
  8006ad:	73 24                	jae    8006d3 <getuint+0x99>
  8006af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bb:	8b 00                	mov    (%rax),%eax
  8006bd:	89 c0                	mov    %eax,%eax
  8006bf:	48 01 d0             	add    %rdx,%rax
  8006c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c6:	8b 12                	mov    (%rdx),%edx
  8006c8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cf:	89 0a                	mov    %ecx,(%rdx)
  8006d1:	eb 14                	jmp    8006e7 <getuint+0xad>
  8006d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006db:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e7:	48 8b 00             	mov    (%rax),%rax
  8006ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ee:	eb 4b                	jmp    80073b <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8006f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f4:	8b 00                	mov    (%rax),%eax
  8006f6:	83 f8 30             	cmp    $0x30,%eax
  8006f9:	73 24                	jae    80071f <getuint+0xe5>
  8006fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ff:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800703:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800707:	8b 00                	mov    (%rax),%eax
  800709:	89 c0                	mov    %eax,%eax
  80070b:	48 01 d0             	add    %rdx,%rax
  80070e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800712:	8b 12                	mov    (%rdx),%edx
  800714:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800717:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071b:	89 0a                	mov    %ecx,(%rdx)
  80071d:	eb 14                	jmp    800733 <getuint+0xf9>
  80071f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800723:	48 8b 40 08          	mov    0x8(%rax),%rax
  800727:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80072b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800733:	8b 00                	mov    (%rax),%eax
  800735:	89 c0                	mov    %eax,%eax
  800737:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80073b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80073f:	c9                   	leaveq 
  800740:	c3                   	retq   

0000000000800741 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800741:	55                   	push   %rbp
  800742:	48 89 e5             	mov    %rsp,%rbp
  800745:	48 83 ec 20          	sub    $0x20,%rsp
  800749:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80074d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800750:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800754:	7e 4f                	jle    8007a5 <getint+0x64>
		x=va_arg(*ap, long long);
  800756:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075a:	8b 00                	mov    (%rax),%eax
  80075c:	83 f8 30             	cmp    $0x30,%eax
  80075f:	73 24                	jae    800785 <getint+0x44>
  800761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800765:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800769:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076d:	8b 00                	mov    (%rax),%eax
  80076f:	89 c0                	mov    %eax,%eax
  800771:	48 01 d0             	add    %rdx,%rax
  800774:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800778:	8b 12                	mov    (%rdx),%edx
  80077a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80077d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800781:	89 0a                	mov    %ecx,(%rdx)
  800783:	eb 14                	jmp    800799 <getint+0x58>
  800785:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800789:	48 8b 40 08          	mov    0x8(%rax),%rax
  80078d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800791:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800795:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800799:	48 8b 00             	mov    (%rax),%rax
  80079c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a0:	e9 9d 00 00 00       	jmpq   800842 <getint+0x101>
	else if (lflag)
  8007a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007a9:	74 4c                	je     8007f7 <getint+0xb6>
		x=va_arg(*ap, long);
  8007ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007af:	8b 00                	mov    (%rax),%eax
  8007b1:	83 f8 30             	cmp    $0x30,%eax
  8007b4:	73 24                	jae    8007da <getint+0x99>
  8007b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ba:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c2:	8b 00                	mov    (%rax),%eax
  8007c4:	89 c0                	mov    %eax,%eax
  8007c6:	48 01 d0             	add    %rdx,%rax
  8007c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cd:	8b 12                	mov    (%rdx),%edx
  8007cf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d6:	89 0a                	mov    %ecx,(%rdx)
  8007d8:	eb 14                	jmp    8007ee <getint+0xad>
  8007da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007de:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007e2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ee:	48 8b 00             	mov    (%rax),%rax
  8007f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007f5:	eb 4b                	jmp    800842 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8007f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fb:	8b 00                	mov    (%rax),%eax
  8007fd:	83 f8 30             	cmp    $0x30,%eax
  800800:	73 24                	jae    800826 <getint+0xe5>
  800802:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800806:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80080a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080e:	8b 00                	mov    (%rax),%eax
  800810:	89 c0                	mov    %eax,%eax
  800812:	48 01 d0             	add    %rdx,%rax
  800815:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800819:	8b 12                	mov    (%rdx),%edx
  80081b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80081e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800822:	89 0a                	mov    %ecx,(%rdx)
  800824:	eb 14                	jmp    80083a <getint+0xf9>
  800826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80082e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800832:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800836:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80083a:	8b 00                	mov    (%rax),%eax
  80083c:	48 98                	cltq   
  80083e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800842:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800846:	c9                   	leaveq 
  800847:	c3                   	retq   

0000000000800848 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800848:	55                   	push   %rbp
  800849:	48 89 e5             	mov    %rsp,%rbp
  80084c:	41 54                	push   %r12
  80084e:	53                   	push   %rbx
  80084f:	48 83 ec 60          	sub    $0x60,%rsp
  800853:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800857:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80085b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80085f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800863:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800867:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80086b:	48 8b 0a             	mov    (%rdx),%rcx
  80086e:	48 89 08             	mov    %rcx,(%rax)
  800871:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800875:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800879:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80087d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800881:	eb 17                	jmp    80089a <vprintfmt+0x52>
			if (ch == '\0')
  800883:	85 db                	test   %ebx,%ebx
  800885:	0f 84 b9 04 00 00    	je     800d44 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80088b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80088f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800893:	48 89 d6             	mov    %rdx,%rsi
  800896:	89 df                	mov    %ebx,%edi
  800898:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80089e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008a6:	0f b6 00             	movzbl (%rax),%eax
  8008a9:	0f b6 d8             	movzbl %al,%ebx
  8008ac:	83 fb 25             	cmp    $0x25,%ebx
  8008af:	75 d2                	jne    800883 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b1:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008b5:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008bc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008ca:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008d9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008dd:	0f b6 00             	movzbl (%rax),%eax
  8008e0:	0f b6 d8             	movzbl %al,%ebx
  8008e3:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008e6:	83 f8 55             	cmp    $0x55,%eax
  8008e9:	0f 87 22 04 00 00    	ja     800d11 <vprintfmt+0x4c9>
  8008ef:	89 c0                	mov    %eax,%eax
  8008f1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008f8:	00 
  8008f9:	48 b8 78 27 80 00 00 	movabs $0x802778,%rax
  800900:	00 00 00 
  800903:	48 01 d0             	add    %rdx,%rax
  800906:	48 8b 00             	mov    (%rax),%rax
  800909:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80090b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80090f:	eb c0                	jmp    8008d1 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800911:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800915:	eb ba                	jmp    8008d1 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800917:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80091e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800921:	89 d0                	mov    %edx,%eax
  800923:	c1 e0 02             	shl    $0x2,%eax
  800926:	01 d0                	add    %edx,%eax
  800928:	01 c0                	add    %eax,%eax
  80092a:	01 d8                	add    %ebx,%eax
  80092c:	83 e8 30             	sub    $0x30,%eax
  80092f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800932:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800936:	0f b6 00             	movzbl (%rax),%eax
  800939:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80093c:	83 fb 2f             	cmp    $0x2f,%ebx
  80093f:	7e 60                	jle    8009a1 <vprintfmt+0x159>
  800941:	83 fb 39             	cmp    $0x39,%ebx
  800944:	7f 5b                	jg     8009a1 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800946:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80094b:	eb d1                	jmp    80091e <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80094d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800950:	83 f8 30             	cmp    $0x30,%eax
  800953:	73 17                	jae    80096c <vprintfmt+0x124>
  800955:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800959:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80095c:	89 d2                	mov    %edx,%edx
  80095e:	48 01 d0             	add    %rdx,%rax
  800961:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800964:	83 c2 08             	add    $0x8,%edx
  800967:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80096a:	eb 0c                	jmp    800978 <vprintfmt+0x130>
  80096c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800970:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800974:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800978:	8b 00                	mov    (%rax),%eax
  80097a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80097d:	eb 23                	jmp    8009a2 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  80097f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800983:	0f 89 48 ff ff ff    	jns    8008d1 <vprintfmt+0x89>
				width = 0;
  800989:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800990:	e9 3c ff ff ff       	jmpq   8008d1 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800995:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80099c:	e9 30 ff ff ff       	jmpq   8008d1 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009a1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a6:	0f 89 25 ff ff ff    	jns    8008d1 <vprintfmt+0x89>
				width = precision, precision = -1;
  8009ac:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009af:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009b2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009b9:	e9 13 ff ff ff       	jmpq   8008d1 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009be:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009c2:	e9 0a ff ff ff       	jmpq   8008d1 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009c7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ca:	83 f8 30             	cmp    $0x30,%eax
  8009cd:	73 17                	jae    8009e6 <vprintfmt+0x19e>
  8009cf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009d3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d6:	89 d2                	mov    %edx,%edx
  8009d8:	48 01 d0             	add    %rdx,%rax
  8009db:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009de:	83 c2 08             	add    $0x8,%edx
  8009e1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009e4:	eb 0c                	jmp    8009f2 <vprintfmt+0x1aa>
  8009e6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009ea:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009ee:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009f2:	8b 10                	mov    (%rax),%edx
  8009f4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009fc:	48 89 ce             	mov    %rcx,%rsi
  8009ff:	89 d7                	mov    %edx,%edi
  800a01:	ff d0                	callq  *%rax
			break;
  800a03:	e9 37 03 00 00       	jmpq   800d3f <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0b:	83 f8 30             	cmp    $0x30,%eax
  800a0e:	73 17                	jae    800a27 <vprintfmt+0x1df>
  800a10:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a14:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a17:	89 d2                	mov    %edx,%edx
  800a19:	48 01 d0             	add    %rdx,%rax
  800a1c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a1f:	83 c2 08             	add    $0x8,%edx
  800a22:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a25:	eb 0c                	jmp    800a33 <vprintfmt+0x1eb>
  800a27:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a2b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a2f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a33:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a35:	85 db                	test   %ebx,%ebx
  800a37:	79 02                	jns    800a3b <vprintfmt+0x1f3>
				err = -err;
  800a39:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a3b:	83 fb 15             	cmp    $0x15,%ebx
  800a3e:	7f 16                	jg     800a56 <vprintfmt+0x20e>
  800a40:	48 b8 a0 26 80 00 00 	movabs $0x8026a0,%rax
  800a47:	00 00 00 
  800a4a:	48 63 d3             	movslq %ebx,%rdx
  800a4d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a51:	4d 85 e4             	test   %r12,%r12
  800a54:	75 2e                	jne    800a84 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800a56:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5e:	89 d9                	mov    %ebx,%ecx
  800a60:	48 ba 61 27 80 00 00 	movabs $0x802761,%rdx
  800a67:	00 00 00 
  800a6a:	48 89 c7             	mov    %rax,%rdi
  800a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a72:	49 b8 4e 0d 80 00 00 	movabs $0x800d4e,%r8
  800a79:	00 00 00 
  800a7c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a7f:	e9 bb 02 00 00       	jmpq   800d3f <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a84:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8c:	4c 89 e1             	mov    %r12,%rcx
  800a8f:	48 ba 6a 27 80 00 00 	movabs $0x80276a,%rdx
  800a96:	00 00 00 
  800a99:	48 89 c7             	mov    %rax,%rdi
  800a9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa1:	49 b8 4e 0d 80 00 00 	movabs $0x800d4e,%r8
  800aa8:	00 00 00 
  800aab:	41 ff d0             	callq  *%r8
			break;
  800aae:	e9 8c 02 00 00       	jmpq   800d3f <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ab3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab6:	83 f8 30             	cmp    $0x30,%eax
  800ab9:	73 17                	jae    800ad2 <vprintfmt+0x28a>
  800abb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800abf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac2:	89 d2                	mov    %edx,%edx
  800ac4:	48 01 d0             	add    %rdx,%rax
  800ac7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aca:	83 c2 08             	add    $0x8,%edx
  800acd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ad0:	eb 0c                	jmp    800ade <vprintfmt+0x296>
  800ad2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ad6:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ada:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ade:	4c 8b 20             	mov    (%rax),%r12
  800ae1:	4d 85 e4             	test   %r12,%r12
  800ae4:	75 0a                	jne    800af0 <vprintfmt+0x2a8>
				p = "(null)";
  800ae6:	49 bc 6d 27 80 00 00 	movabs $0x80276d,%r12
  800aed:	00 00 00 
			if (width > 0 && padc != '-')
  800af0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af4:	7e 78                	jle    800b6e <vprintfmt+0x326>
  800af6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800afa:	74 72                	je     800b6e <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800afc:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800aff:	48 98                	cltq   
  800b01:	48 89 c6             	mov    %rax,%rsi
  800b04:	4c 89 e7             	mov    %r12,%rdi
  800b07:	48 b8 fc 0f 80 00 00 	movabs $0x800ffc,%rax
  800b0e:	00 00 00 
  800b11:	ff d0                	callq  *%rax
  800b13:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b16:	eb 17                	jmp    800b2f <vprintfmt+0x2e7>
					putch(padc, putdat);
  800b18:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b1c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b20:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b24:	48 89 ce             	mov    %rcx,%rsi
  800b27:	89 d7                	mov    %edx,%edi
  800b29:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b33:	7f e3                	jg     800b18 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b35:	eb 37                	jmp    800b6e <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800b37:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b3b:	74 1e                	je     800b5b <vprintfmt+0x313>
  800b3d:	83 fb 1f             	cmp    $0x1f,%ebx
  800b40:	7e 05                	jle    800b47 <vprintfmt+0x2ff>
  800b42:	83 fb 7e             	cmp    $0x7e,%ebx
  800b45:	7e 14                	jle    800b5b <vprintfmt+0x313>
					putch('?', putdat);
  800b47:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4f:	48 89 d6             	mov    %rdx,%rsi
  800b52:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b57:	ff d0                	callq  *%rax
  800b59:	eb 0f                	jmp    800b6a <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800b5b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b63:	48 89 d6             	mov    %rdx,%rsi
  800b66:	89 df                	mov    %ebx,%edi
  800b68:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b6e:	4c 89 e0             	mov    %r12,%rax
  800b71:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b75:	0f b6 00             	movzbl (%rax),%eax
  800b78:	0f be d8             	movsbl %al,%ebx
  800b7b:	85 db                	test   %ebx,%ebx
  800b7d:	74 28                	je     800ba7 <vprintfmt+0x35f>
  800b7f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b83:	78 b2                	js     800b37 <vprintfmt+0x2ef>
  800b85:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b89:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b8d:	79 a8                	jns    800b37 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b8f:	eb 16                	jmp    800ba7 <vprintfmt+0x35f>
				putch(' ', putdat);
  800b91:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b99:	48 89 d6             	mov    %rdx,%rsi
  800b9c:	bf 20 00 00 00       	mov    $0x20,%edi
  800ba1:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ba7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bab:	7f e4                	jg     800b91 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800bad:	e9 8d 01 00 00       	jmpq   800d3f <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bb2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bb6:	be 03 00 00 00       	mov    $0x3,%esi
  800bbb:	48 89 c7             	mov    %rax,%rdi
  800bbe:	48 b8 41 07 80 00 00 	movabs $0x800741,%rax
  800bc5:	00 00 00 
  800bc8:	ff d0                	callq  *%rax
  800bca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd2:	48 85 c0             	test   %rax,%rax
  800bd5:	79 1d                	jns    800bf4 <vprintfmt+0x3ac>
				putch('-', putdat);
  800bd7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bdb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bdf:	48 89 d6             	mov    %rdx,%rsi
  800be2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800be7:	ff d0                	callq  *%rax
				num = -(long long) num;
  800be9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bed:	48 f7 d8             	neg    %rax
  800bf0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bf4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bfb:	e9 d2 00 00 00       	jmpq   800cd2 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c00:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c04:	be 03 00 00 00       	mov    $0x3,%esi
  800c09:	48 89 c7             	mov    %rax,%rdi
  800c0c:	48 b8 3a 06 80 00 00 	movabs $0x80063a,%rax
  800c13:	00 00 00 
  800c16:	ff d0                	callq  *%rax
  800c18:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c1c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c23:	e9 aa 00 00 00       	jmpq   800cd2 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800c28:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c2c:	be 03 00 00 00       	mov    $0x3,%esi
  800c31:	48 89 c7             	mov    %rax,%rdi
  800c34:	48 b8 3a 06 80 00 00 	movabs $0x80063a,%rax
  800c3b:	00 00 00 
  800c3e:	ff d0                	callq  *%rax
  800c40:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c44:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c4b:	e9 82 00 00 00       	jmpq   800cd2 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800c50:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c58:	48 89 d6             	mov    %rdx,%rsi
  800c5b:	bf 30 00 00 00       	mov    $0x30,%edi
  800c60:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c62:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6a:	48 89 d6             	mov    %rdx,%rsi
  800c6d:	bf 78 00 00 00       	mov    $0x78,%edi
  800c72:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c77:	83 f8 30             	cmp    $0x30,%eax
  800c7a:	73 17                	jae    800c93 <vprintfmt+0x44b>
  800c7c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c80:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c83:	89 d2                	mov    %edx,%edx
  800c85:	48 01 d0             	add    %rdx,%rax
  800c88:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8b:	83 c2 08             	add    $0x8,%edx
  800c8e:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c91:	eb 0c                	jmp    800c9f <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800c93:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c97:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c9b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c9f:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ca6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cad:	eb 23                	jmp    800cd2 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800caf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cb3:	be 03 00 00 00       	mov    $0x3,%esi
  800cb8:	48 89 c7             	mov    %rax,%rdi
  800cbb:	48 b8 3a 06 80 00 00 	movabs $0x80063a,%rax
  800cc2:	00 00 00 
  800cc5:	ff d0                	callq  *%rax
  800cc7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ccb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cd2:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cd7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cda:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cdd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ce1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ce5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce9:	45 89 c1             	mov    %r8d,%r9d
  800cec:	41 89 f8             	mov    %edi,%r8d
  800cef:	48 89 c7             	mov    %rax,%rdi
  800cf2:	48 b8 82 05 80 00 00 	movabs $0x800582,%rax
  800cf9:	00 00 00 
  800cfc:	ff d0                	callq  *%rax
			break;
  800cfe:	eb 3f                	jmp    800d3f <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d08:	48 89 d6             	mov    %rdx,%rsi
  800d0b:	89 df                	mov    %ebx,%edi
  800d0d:	ff d0                	callq  *%rax
			break;
  800d0f:	eb 2e                	jmp    800d3f <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d11:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d15:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d19:	48 89 d6             	mov    %rdx,%rsi
  800d1c:	bf 25 00 00 00       	mov    $0x25,%edi
  800d21:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d23:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d28:	eb 05                	jmp    800d2f <vprintfmt+0x4e7>
  800d2a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d2f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d33:	48 83 e8 01          	sub    $0x1,%rax
  800d37:	0f b6 00             	movzbl (%rax),%eax
  800d3a:	3c 25                	cmp    $0x25,%al
  800d3c:	75 ec                	jne    800d2a <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800d3e:	90                   	nop
		}
	}
  800d3f:	e9 3d fb ff ff       	jmpq   800881 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d44:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d45:	48 83 c4 60          	add    $0x60,%rsp
  800d49:	5b                   	pop    %rbx
  800d4a:	41 5c                	pop    %r12
  800d4c:	5d                   	pop    %rbp
  800d4d:	c3                   	retq   

0000000000800d4e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d4e:	55                   	push   %rbp
  800d4f:	48 89 e5             	mov    %rsp,%rbp
  800d52:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d59:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d60:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d67:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800d6e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d75:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d7c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d83:	84 c0                	test   %al,%al
  800d85:	74 20                	je     800da7 <printfmt+0x59>
  800d87:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d8b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d8f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d93:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d97:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d9b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d9f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800da3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800da7:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dae:	00 00 00 
  800db1:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800db8:	00 00 00 
  800dbb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dbf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dc6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dcd:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dd4:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ddb:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800de2:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800de9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800df0:	48 89 c7             	mov    %rax,%rdi
  800df3:	48 b8 48 08 80 00 00 	movabs $0x800848,%rax
  800dfa:	00 00 00 
  800dfd:	ff d0                	callq  *%rax
	va_end(ap);
}
  800dff:	90                   	nop
  800e00:	c9                   	leaveq 
  800e01:	c3                   	retq   

0000000000800e02 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e02:	55                   	push   %rbp
  800e03:	48 89 e5             	mov    %rsp,%rbp
  800e06:	48 83 ec 10          	sub    $0x10,%rsp
  800e0a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e15:	8b 40 10             	mov    0x10(%rax),%eax
  800e18:	8d 50 01             	lea    0x1(%rax),%edx
  800e1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e1f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e26:	48 8b 10             	mov    (%rax),%rdx
  800e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e31:	48 39 c2             	cmp    %rax,%rdx
  800e34:	73 17                	jae    800e4d <sprintputch+0x4b>
		*b->buf++ = ch;
  800e36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3a:	48 8b 00             	mov    (%rax),%rax
  800e3d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e45:	48 89 0a             	mov    %rcx,(%rdx)
  800e48:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e4b:	88 10                	mov    %dl,(%rax)
}
  800e4d:	90                   	nop
  800e4e:	c9                   	leaveq 
  800e4f:	c3                   	retq   

0000000000800e50 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e50:	55                   	push   %rbp
  800e51:	48 89 e5             	mov    %rsp,%rbp
  800e54:	48 83 ec 50          	sub    $0x50,%rsp
  800e58:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e5c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e5f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e63:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e67:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e6b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e6f:	48 8b 0a             	mov    (%rdx),%rcx
  800e72:	48 89 08             	mov    %rcx,(%rax)
  800e75:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e79:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e7d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e81:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e85:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e89:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e8d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e90:	48 98                	cltq   
  800e92:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e96:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e9a:	48 01 d0             	add    %rdx,%rax
  800e9d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ea1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ea8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ead:	74 06                	je     800eb5 <vsnprintf+0x65>
  800eaf:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800eb3:	7f 07                	jg     800ebc <vsnprintf+0x6c>
		return -E_INVAL;
  800eb5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eba:	eb 2f                	jmp    800eeb <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ebc:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ec0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ec4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ec8:	48 89 c6             	mov    %rax,%rsi
  800ecb:	48 bf 02 0e 80 00 00 	movabs $0x800e02,%rdi
  800ed2:	00 00 00 
  800ed5:	48 b8 48 08 80 00 00 	movabs $0x800848,%rax
  800edc:	00 00 00 
  800edf:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ee1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ee5:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ee8:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800eeb:	c9                   	leaveq 
  800eec:	c3                   	retq   

0000000000800eed <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eed:	55                   	push   %rbp
  800eee:	48 89 e5             	mov    %rsp,%rbp
  800ef1:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ef8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800eff:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f05:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800f0c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f13:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f1a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f21:	84 c0                	test   %al,%al
  800f23:	74 20                	je     800f45 <snprintf+0x58>
  800f25:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f29:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f2d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f31:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f35:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f39:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f3d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f41:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f45:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f4c:	00 00 00 
  800f4f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f56:	00 00 00 
  800f59:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f5d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f64:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f6b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f72:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f79:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f80:	48 8b 0a             	mov    (%rdx),%rcx
  800f83:	48 89 08             	mov    %rcx,(%rax)
  800f86:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f8a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f8e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f92:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f96:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f9d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fa4:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800faa:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fb1:	48 89 c7             	mov    %rax,%rdi
  800fb4:	48 b8 50 0e 80 00 00 	movabs $0x800e50,%rax
  800fbb:	00 00 00 
  800fbe:	ff d0                	callq  *%rax
  800fc0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fc6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fcc:	c9                   	leaveq 
  800fcd:	c3                   	retq   

0000000000800fce <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fce:	55                   	push   %rbp
  800fcf:	48 89 e5             	mov    %rsp,%rbp
  800fd2:	48 83 ec 18          	sub    $0x18,%rsp
  800fd6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fe1:	eb 09                	jmp    800fec <strlen+0x1e>
		n++;
  800fe3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff0:	0f b6 00             	movzbl (%rax),%eax
  800ff3:	84 c0                	test   %al,%al
  800ff5:	75 ec                	jne    800fe3 <strlen+0x15>
		n++;
	return n;
  800ff7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ffa:	c9                   	leaveq 
  800ffb:	c3                   	retq   

0000000000800ffc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ffc:	55                   	push   %rbp
  800ffd:	48 89 e5             	mov    %rsp,%rbp
  801000:	48 83 ec 20          	sub    $0x20,%rsp
  801004:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801008:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80100c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801013:	eb 0e                	jmp    801023 <strnlen+0x27>
		n++;
  801015:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801019:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80101e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801023:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801028:	74 0b                	je     801035 <strnlen+0x39>
  80102a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102e:	0f b6 00             	movzbl (%rax),%eax
  801031:	84 c0                	test   %al,%al
  801033:	75 e0                	jne    801015 <strnlen+0x19>
		n++;
	return n;
  801035:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801038:	c9                   	leaveq 
  801039:	c3                   	retq   

000000000080103a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80103a:	55                   	push   %rbp
  80103b:	48 89 e5             	mov    %rsp,%rbp
  80103e:	48 83 ec 20          	sub    $0x20,%rsp
  801042:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801046:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80104a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801052:	90                   	nop
  801053:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801057:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80105b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80105f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801063:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801067:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80106b:	0f b6 12             	movzbl (%rdx),%edx
  80106e:	88 10                	mov    %dl,(%rax)
  801070:	0f b6 00             	movzbl (%rax),%eax
  801073:	84 c0                	test   %al,%al
  801075:	75 dc                	jne    801053 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801077:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80107b:	c9                   	leaveq 
  80107c:	c3                   	retq   

000000000080107d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80107d:	55                   	push   %rbp
  80107e:	48 89 e5             	mov    %rsp,%rbp
  801081:	48 83 ec 20          	sub    $0x20,%rsp
  801085:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801089:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80108d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801091:	48 89 c7             	mov    %rax,%rdi
  801094:	48 b8 ce 0f 80 00 00 	movabs $0x800fce,%rax
  80109b:	00 00 00 
  80109e:	ff d0                	callq  *%rax
  8010a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010a6:	48 63 d0             	movslq %eax,%rdx
  8010a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ad:	48 01 c2             	add    %rax,%rdx
  8010b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010b4:	48 89 c6             	mov    %rax,%rsi
  8010b7:	48 89 d7             	mov    %rdx,%rdi
  8010ba:	48 b8 3a 10 80 00 00 	movabs $0x80103a,%rax
  8010c1:	00 00 00 
  8010c4:	ff d0                	callq  *%rax
	return dst;
  8010c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010ca:	c9                   	leaveq 
  8010cb:	c3                   	retq   

00000000008010cc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010cc:	55                   	push   %rbp
  8010cd:	48 89 e5             	mov    %rsp,%rbp
  8010d0:	48 83 ec 28          	sub    $0x28,%rsp
  8010d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010e8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010ef:	00 
  8010f0:	eb 2a                	jmp    80111c <strncpy+0x50>
		*dst++ = *src;
  8010f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010fe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801102:	0f b6 12             	movzbl (%rdx),%edx
  801105:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801107:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80110b:	0f b6 00             	movzbl (%rax),%eax
  80110e:	84 c0                	test   %al,%al
  801110:	74 05                	je     801117 <strncpy+0x4b>
			src++;
  801112:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801117:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80111c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801120:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801124:	72 cc                	jb     8010f2 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801126:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80112a:	c9                   	leaveq 
  80112b:	c3                   	retq   

000000000080112c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80112c:	55                   	push   %rbp
  80112d:	48 89 e5             	mov    %rsp,%rbp
  801130:	48 83 ec 28          	sub    $0x28,%rsp
  801134:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801138:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80113c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801140:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801144:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801148:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80114d:	74 3d                	je     80118c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80114f:	eb 1d                	jmp    80116e <strlcpy+0x42>
			*dst++ = *src++;
  801151:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801155:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801159:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80115d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801161:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801165:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801169:	0f b6 12             	movzbl (%rdx),%edx
  80116c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80116e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801173:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801178:	74 0b                	je     801185 <strlcpy+0x59>
  80117a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80117e:	0f b6 00             	movzbl (%rax),%eax
  801181:	84 c0                	test   %al,%al
  801183:	75 cc                	jne    801151 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801189:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80118c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801190:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801194:	48 29 c2             	sub    %rax,%rdx
  801197:	48 89 d0             	mov    %rdx,%rax
}
  80119a:	c9                   	leaveq 
  80119b:	c3                   	retq   

000000000080119c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80119c:	55                   	push   %rbp
  80119d:	48 89 e5             	mov    %rsp,%rbp
  8011a0:	48 83 ec 10          	sub    $0x10,%rsp
  8011a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011ac:	eb 0a                	jmp    8011b8 <strcmp+0x1c>
		p++, q++;
  8011ae:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011b3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bc:	0f b6 00             	movzbl (%rax),%eax
  8011bf:	84 c0                	test   %al,%al
  8011c1:	74 12                	je     8011d5 <strcmp+0x39>
  8011c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c7:	0f b6 10             	movzbl (%rax),%edx
  8011ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ce:	0f b6 00             	movzbl (%rax),%eax
  8011d1:	38 c2                	cmp    %al,%dl
  8011d3:	74 d9                	je     8011ae <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d9:	0f b6 00             	movzbl (%rax),%eax
  8011dc:	0f b6 d0             	movzbl %al,%edx
  8011df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e3:	0f b6 00             	movzbl (%rax),%eax
  8011e6:	0f b6 c0             	movzbl %al,%eax
  8011e9:	29 c2                	sub    %eax,%edx
  8011eb:	89 d0                	mov    %edx,%eax
}
  8011ed:	c9                   	leaveq 
  8011ee:	c3                   	retq   

00000000008011ef <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011ef:	55                   	push   %rbp
  8011f0:	48 89 e5             	mov    %rsp,%rbp
  8011f3:	48 83 ec 18          	sub    $0x18,%rsp
  8011f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011ff:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801203:	eb 0f                	jmp    801214 <strncmp+0x25>
		n--, p++, q++;
  801205:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80120a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80120f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801214:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801219:	74 1d                	je     801238 <strncmp+0x49>
  80121b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121f:	0f b6 00             	movzbl (%rax),%eax
  801222:	84 c0                	test   %al,%al
  801224:	74 12                	je     801238 <strncmp+0x49>
  801226:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122a:	0f b6 10             	movzbl (%rax),%edx
  80122d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801231:	0f b6 00             	movzbl (%rax),%eax
  801234:	38 c2                	cmp    %al,%dl
  801236:	74 cd                	je     801205 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801238:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80123d:	75 07                	jne    801246 <strncmp+0x57>
		return 0;
  80123f:	b8 00 00 00 00       	mov    $0x0,%eax
  801244:	eb 18                	jmp    80125e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801246:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124a:	0f b6 00             	movzbl (%rax),%eax
  80124d:	0f b6 d0             	movzbl %al,%edx
  801250:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801254:	0f b6 00             	movzbl (%rax),%eax
  801257:	0f b6 c0             	movzbl %al,%eax
  80125a:	29 c2                	sub    %eax,%edx
  80125c:	89 d0                	mov    %edx,%eax
}
  80125e:	c9                   	leaveq 
  80125f:	c3                   	retq   

0000000000801260 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801260:	55                   	push   %rbp
  801261:	48 89 e5             	mov    %rsp,%rbp
  801264:	48 83 ec 10          	sub    $0x10,%rsp
  801268:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80126c:	89 f0                	mov    %esi,%eax
  80126e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801271:	eb 17                	jmp    80128a <strchr+0x2a>
		if (*s == c)
  801273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801277:	0f b6 00             	movzbl (%rax),%eax
  80127a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80127d:	75 06                	jne    801285 <strchr+0x25>
			return (char *) s;
  80127f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801283:	eb 15                	jmp    80129a <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801285:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80128a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128e:	0f b6 00             	movzbl (%rax),%eax
  801291:	84 c0                	test   %al,%al
  801293:	75 de                	jne    801273 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801295:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80129a:	c9                   	leaveq 
  80129b:	c3                   	retq   

000000000080129c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80129c:	55                   	push   %rbp
  80129d:	48 89 e5             	mov    %rsp,%rbp
  8012a0:	48 83 ec 10          	sub    $0x10,%rsp
  8012a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a8:	89 f0                	mov    %esi,%eax
  8012aa:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012ad:	eb 11                	jmp    8012c0 <strfind+0x24>
		if (*s == c)
  8012af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b3:	0f b6 00             	movzbl (%rax),%eax
  8012b6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012b9:	74 12                	je     8012cd <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012bb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c4:	0f b6 00             	movzbl (%rax),%eax
  8012c7:	84 c0                	test   %al,%al
  8012c9:	75 e4                	jne    8012af <strfind+0x13>
  8012cb:	eb 01                	jmp    8012ce <strfind+0x32>
		if (*s == c)
			break;
  8012cd:	90                   	nop
	return (char *) s;
  8012ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012d2:	c9                   	leaveq 
  8012d3:	c3                   	retq   

00000000008012d4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012d4:	55                   	push   %rbp
  8012d5:	48 89 e5             	mov    %rsp,%rbp
  8012d8:	48 83 ec 18          	sub    $0x18,%rsp
  8012dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e0:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012e3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012e7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ec:	75 06                	jne    8012f4 <memset+0x20>
		return v;
  8012ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f2:	eb 69                	jmp    80135d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f8:	83 e0 03             	and    $0x3,%eax
  8012fb:	48 85 c0             	test   %rax,%rax
  8012fe:	75 48                	jne    801348 <memset+0x74>
  801300:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801304:	83 e0 03             	and    $0x3,%eax
  801307:	48 85 c0             	test   %rax,%rax
  80130a:	75 3c                	jne    801348 <memset+0x74>
		c &= 0xFF;
  80130c:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801313:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801316:	c1 e0 18             	shl    $0x18,%eax
  801319:	89 c2                	mov    %eax,%edx
  80131b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80131e:	c1 e0 10             	shl    $0x10,%eax
  801321:	09 c2                	or     %eax,%edx
  801323:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801326:	c1 e0 08             	shl    $0x8,%eax
  801329:	09 d0                	or     %edx,%eax
  80132b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80132e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801332:	48 c1 e8 02          	shr    $0x2,%rax
  801336:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801339:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80133d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801340:	48 89 d7             	mov    %rdx,%rdi
  801343:	fc                   	cld    
  801344:	f3 ab                	rep stos %eax,%es:(%rdi)
  801346:	eb 11                	jmp    801359 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801348:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80134c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80134f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801353:	48 89 d7             	mov    %rdx,%rdi
  801356:	fc                   	cld    
  801357:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801359:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80135d:	c9                   	leaveq 
  80135e:	c3                   	retq   

000000000080135f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80135f:	55                   	push   %rbp
  801360:	48 89 e5             	mov    %rsp,%rbp
  801363:	48 83 ec 28          	sub    $0x28,%rsp
  801367:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80136b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80136f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801373:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801377:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80137b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801383:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801387:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80138b:	0f 83 88 00 00 00    	jae    801419 <memmove+0xba>
  801391:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801395:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801399:	48 01 d0             	add    %rdx,%rax
  80139c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013a0:	76 77                	jbe    801419 <memmove+0xba>
		s += n;
  8013a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a6:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ae:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b6:	83 e0 03             	and    $0x3,%eax
  8013b9:	48 85 c0             	test   %rax,%rax
  8013bc:	75 3b                	jne    8013f9 <memmove+0x9a>
  8013be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c2:	83 e0 03             	and    $0x3,%eax
  8013c5:	48 85 c0             	test   %rax,%rax
  8013c8:	75 2f                	jne    8013f9 <memmove+0x9a>
  8013ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ce:	83 e0 03             	and    $0x3,%eax
  8013d1:	48 85 c0             	test   %rax,%rax
  8013d4:	75 23                	jne    8013f9 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013da:	48 83 e8 04          	sub    $0x4,%rax
  8013de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e2:	48 83 ea 04          	sub    $0x4,%rdx
  8013e6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013ea:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013ee:	48 89 c7             	mov    %rax,%rdi
  8013f1:	48 89 d6             	mov    %rdx,%rsi
  8013f4:	fd                   	std    
  8013f5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013f7:	eb 1d                	jmp    801416 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801401:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801405:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801409:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140d:	48 89 d7             	mov    %rdx,%rdi
  801410:	48 89 c1             	mov    %rax,%rcx
  801413:	fd                   	std    
  801414:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801416:	fc                   	cld    
  801417:	eb 57                	jmp    801470 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801419:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141d:	83 e0 03             	and    $0x3,%eax
  801420:	48 85 c0             	test   %rax,%rax
  801423:	75 36                	jne    80145b <memmove+0xfc>
  801425:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801429:	83 e0 03             	and    $0x3,%eax
  80142c:	48 85 c0             	test   %rax,%rax
  80142f:	75 2a                	jne    80145b <memmove+0xfc>
  801431:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801435:	83 e0 03             	and    $0x3,%eax
  801438:	48 85 c0             	test   %rax,%rax
  80143b:	75 1e                	jne    80145b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80143d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801441:	48 c1 e8 02          	shr    $0x2,%rax
  801445:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801448:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801450:	48 89 c7             	mov    %rax,%rdi
  801453:	48 89 d6             	mov    %rdx,%rsi
  801456:	fc                   	cld    
  801457:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801459:	eb 15                	jmp    801470 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80145b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801463:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801467:	48 89 c7             	mov    %rax,%rdi
  80146a:	48 89 d6             	mov    %rdx,%rsi
  80146d:	fc                   	cld    
  80146e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801470:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801474:	c9                   	leaveq 
  801475:	c3                   	retq   

0000000000801476 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801476:	55                   	push   %rbp
  801477:	48 89 e5             	mov    %rsp,%rbp
  80147a:	48 83 ec 18          	sub    $0x18,%rsp
  80147e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801482:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801486:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80148a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80148e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801492:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801496:	48 89 ce             	mov    %rcx,%rsi
  801499:	48 89 c7             	mov    %rax,%rdi
  80149c:	48 b8 5f 13 80 00 00 	movabs $0x80135f,%rax
  8014a3:	00 00 00 
  8014a6:	ff d0                	callq  *%rax
}
  8014a8:	c9                   	leaveq 
  8014a9:	c3                   	retq   

00000000008014aa <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014aa:	55                   	push   %rbp
  8014ab:	48 89 e5             	mov    %rsp,%rbp
  8014ae:	48 83 ec 28          	sub    $0x28,%rsp
  8014b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014ce:	eb 36                	jmp    801506 <memcmp+0x5c>
		if (*s1 != *s2)
  8014d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d4:	0f b6 10             	movzbl (%rax),%edx
  8014d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014db:	0f b6 00             	movzbl (%rax),%eax
  8014de:	38 c2                	cmp    %al,%dl
  8014e0:	74 1a                	je     8014fc <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e6:	0f b6 00             	movzbl (%rax),%eax
  8014e9:	0f b6 d0             	movzbl %al,%edx
  8014ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f0:	0f b6 00             	movzbl (%rax),%eax
  8014f3:	0f b6 c0             	movzbl %al,%eax
  8014f6:	29 c2                	sub    %eax,%edx
  8014f8:	89 d0                	mov    %edx,%eax
  8014fa:	eb 20                	jmp    80151c <memcmp+0x72>
		s1++, s2++;
  8014fc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801501:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801506:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80150e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801512:	48 85 c0             	test   %rax,%rax
  801515:	75 b9                	jne    8014d0 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801517:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151c:	c9                   	leaveq 
  80151d:	c3                   	retq   

000000000080151e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80151e:	55                   	push   %rbp
  80151f:	48 89 e5             	mov    %rsp,%rbp
  801522:	48 83 ec 28          	sub    $0x28,%rsp
  801526:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80152a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80152d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801531:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801535:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801539:	48 01 d0             	add    %rdx,%rax
  80153c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801540:	eb 19                	jmp    80155b <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801546:	0f b6 00             	movzbl (%rax),%eax
  801549:	0f b6 d0             	movzbl %al,%edx
  80154c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80154f:	0f b6 c0             	movzbl %al,%eax
  801552:	39 c2                	cmp    %eax,%edx
  801554:	74 11                	je     801567 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801556:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80155b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801563:	72 dd                	jb     801542 <memfind+0x24>
  801565:	eb 01                	jmp    801568 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801567:	90                   	nop
	return (void *) s;
  801568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80156c:	c9                   	leaveq 
  80156d:	c3                   	retq   

000000000080156e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80156e:	55                   	push   %rbp
  80156f:	48 89 e5             	mov    %rsp,%rbp
  801572:	48 83 ec 38          	sub    $0x38,%rsp
  801576:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80157a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80157e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801581:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801588:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80158f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801590:	eb 05                	jmp    801597 <strtol+0x29>
		s++;
  801592:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801597:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159b:	0f b6 00             	movzbl (%rax),%eax
  80159e:	3c 20                	cmp    $0x20,%al
  8015a0:	74 f0                	je     801592 <strtol+0x24>
  8015a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a6:	0f b6 00             	movzbl (%rax),%eax
  8015a9:	3c 09                	cmp    $0x9,%al
  8015ab:	74 e5                	je     801592 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b1:	0f b6 00             	movzbl (%rax),%eax
  8015b4:	3c 2b                	cmp    $0x2b,%al
  8015b6:	75 07                	jne    8015bf <strtol+0x51>
		s++;
  8015b8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015bd:	eb 17                	jmp    8015d6 <strtol+0x68>
	else if (*s == '-')
  8015bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c3:	0f b6 00             	movzbl (%rax),%eax
  8015c6:	3c 2d                	cmp    $0x2d,%al
  8015c8:	75 0c                	jne    8015d6 <strtol+0x68>
		s++, neg = 1;
  8015ca:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015d6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015da:	74 06                	je     8015e2 <strtol+0x74>
  8015dc:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015e0:	75 28                	jne    80160a <strtol+0x9c>
  8015e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e6:	0f b6 00             	movzbl (%rax),%eax
  8015e9:	3c 30                	cmp    $0x30,%al
  8015eb:	75 1d                	jne    80160a <strtol+0x9c>
  8015ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f1:	48 83 c0 01          	add    $0x1,%rax
  8015f5:	0f b6 00             	movzbl (%rax),%eax
  8015f8:	3c 78                	cmp    $0x78,%al
  8015fa:	75 0e                	jne    80160a <strtol+0x9c>
		s += 2, base = 16;
  8015fc:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801601:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801608:	eb 2c                	jmp    801636 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80160a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80160e:	75 19                	jne    801629 <strtol+0xbb>
  801610:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801614:	0f b6 00             	movzbl (%rax),%eax
  801617:	3c 30                	cmp    $0x30,%al
  801619:	75 0e                	jne    801629 <strtol+0xbb>
		s++, base = 8;
  80161b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801620:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801627:	eb 0d                	jmp    801636 <strtol+0xc8>
	else if (base == 0)
  801629:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80162d:	75 07                	jne    801636 <strtol+0xc8>
		base = 10;
  80162f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801636:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163a:	0f b6 00             	movzbl (%rax),%eax
  80163d:	3c 2f                	cmp    $0x2f,%al
  80163f:	7e 1d                	jle    80165e <strtol+0xf0>
  801641:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801645:	0f b6 00             	movzbl (%rax),%eax
  801648:	3c 39                	cmp    $0x39,%al
  80164a:	7f 12                	jg     80165e <strtol+0xf0>
			dig = *s - '0';
  80164c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801650:	0f b6 00             	movzbl (%rax),%eax
  801653:	0f be c0             	movsbl %al,%eax
  801656:	83 e8 30             	sub    $0x30,%eax
  801659:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80165c:	eb 4e                	jmp    8016ac <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80165e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801662:	0f b6 00             	movzbl (%rax),%eax
  801665:	3c 60                	cmp    $0x60,%al
  801667:	7e 1d                	jle    801686 <strtol+0x118>
  801669:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166d:	0f b6 00             	movzbl (%rax),%eax
  801670:	3c 7a                	cmp    $0x7a,%al
  801672:	7f 12                	jg     801686 <strtol+0x118>
			dig = *s - 'a' + 10;
  801674:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801678:	0f b6 00             	movzbl (%rax),%eax
  80167b:	0f be c0             	movsbl %al,%eax
  80167e:	83 e8 57             	sub    $0x57,%eax
  801681:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801684:	eb 26                	jmp    8016ac <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801686:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168a:	0f b6 00             	movzbl (%rax),%eax
  80168d:	3c 40                	cmp    $0x40,%al
  80168f:	7e 47                	jle    8016d8 <strtol+0x16a>
  801691:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801695:	0f b6 00             	movzbl (%rax),%eax
  801698:	3c 5a                	cmp    $0x5a,%al
  80169a:	7f 3c                	jg     8016d8 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80169c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a0:	0f b6 00             	movzbl (%rax),%eax
  8016a3:	0f be c0             	movsbl %al,%eax
  8016a6:	83 e8 37             	sub    $0x37,%eax
  8016a9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016af:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016b2:	7d 23                	jge    8016d7 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8016b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016b9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016bc:	48 98                	cltq   
  8016be:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016c3:	48 89 c2             	mov    %rax,%rdx
  8016c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016c9:	48 98                	cltq   
  8016cb:	48 01 d0             	add    %rdx,%rax
  8016ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016d2:	e9 5f ff ff ff       	jmpq   801636 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016d7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016d8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016dd:	74 0b                	je     8016ea <strtol+0x17c>
		*endptr = (char *) s;
  8016df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016e3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016e7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016ee:	74 09                	je     8016f9 <strtol+0x18b>
  8016f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f4:	48 f7 d8             	neg    %rax
  8016f7:	eb 04                	jmp    8016fd <strtol+0x18f>
  8016f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016fd:	c9                   	leaveq 
  8016fe:	c3                   	retq   

00000000008016ff <strstr>:

char * strstr(const char *in, const char *str)
{
  8016ff:	55                   	push   %rbp
  801700:	48 89 e5             	mov    %rsp,%rbp
  801703:	48 83 ec 30          	sub    $0x30,%rsp
  801707:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80170b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80170f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801713:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801717:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80171b:	0f b6 00             	movzbl (%rax),%eax
  80171e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801721:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801725:	75 06                	jne    80172d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801727:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172b:	eb 6b                	jmp    801798 <strstr+0x99>

	len = strlen(str);
  80172d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801731:	48 89 c7             	mov    %rax,%rdi
  801734:	48 b8 ce 0f 80 00 00 	movabs $0x800fce,%rax
  80173b:	00 00 00 
  80173e:	ff d0                	callq  *%rax
  801740:	48 98                	cltq   
  801742:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80174e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801752:	0f b6 00             	movzbl (%rax),%eax
  801755:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801758:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80175c:	75 07                	jne    801765 <strstr+0x66>
				return (char *) 0;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
  801763:	eb 33                	jmp    801798 <strstr+0x99>
		} while (sc != c);
  801765:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801769:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80176c:	75 d8                	jne    801746 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80176e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801772:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177a:	48 89 ce             	mov    %rcx,%rsi
  80177d:	48 89 c7             	mov    %rax,%rdi
  801780:	48 b8 ef 11 80 00 00 	movabs $0x8011ef,%rax
  801787:	00 00 00 
  80178a:	ff d0                	callq  *%rax
  80178c:	85 c0                	test   %eax,%eax
  80178e:	75 b6                	jne    801746 <strstr+0x47>

	return (char *) (in - 1);
  801790:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801794:	48 83 e8 01          	sub    $0x1,%rax
}
  801798:	c9                   	leaveq 
  801799:	c3                   	retq   

000000000080179a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80179a:	55                   	push   %rbp
  80179b:	48 89 e5             	mov    %rsp,%rbp
  80179e:	53                   	push   %rbx
  80179f:	48 83 ec 48          	sub    $0x48,%rsp
  8017a3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017a6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017a9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017ad:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017b1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017b5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017b9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017bc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017c0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017c4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017c8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017cc:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017d0:	4c 89 c3             	mov    %r8,%rbx
  8017d3:	cd 30                	int    $0x30
  8017d5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017d9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017dd:	74 3e                	je     80181d <syscall+0x83>
  8017df:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017e4:	7e 37                	jle    80181d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017ed:	49 89 d0             	mov    %rdx,%r8
  8017f0:	89 c1                	mov    %eax,%ecx
  8017f2:	48 ba 28 2a 80 00 00 	movabs $0x802a28,%rdx
  8017f9:	00 00 00 
  8017fc:	be 23 00 00 00       	mov    $0x23,%esi
  801801:	48 bf 45 2a 80 00 00 	movabs $0x802a45,%rdi
  801808:	00 00 00 
  80180b:	b8 00 00 00 00       	mov    $0x0,%eax
  801810:	49 b9 70 02 80 00 00 	movabs $0x800270,%r9
  801817:	00 00 00 
  80181a:	41 ff d1             	callq  *%r9

	return ret;
  80181d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801821:	48 83 c4 48          	add    $0x48,%rsp
  801825:	5b                   	pop    %rbx
  801826:	5d                   	pop    %rbp
  801827:	c3                   	retq   

0000000000801828 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801828:	55                   	push   %rbp
  801829:	48 89 e5             	mov    %rsp,%rbp
  80182c:	48 83 ec 10          	sub    $0x10,%rsp
  801830:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801834:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801838:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80183c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801840:	48 83 ec 08          	sub    $0x8,%rsp
  801844:	6a 00                	pushq  $0x0
  801846:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80184c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801852:	48 89 d1             	mov    %rdx,%rcx
  801855:	48 89 c2             	mov    %rax,%rdx
  801858:	be 00 00 00 00       	mov    $0x0,%esi
  80185d:	bf 00 00 00 00       	mov    $0x0,%edi
  801862:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801869:	00 00 00 
  80186c:	ff d0                	callq  *%rax
  80186e:	48 83 c4 10          	add    $0x10,%rsp
}
  801872:	90                   	nop
  801873:	c9                   	leaveq 
  801874:	c3                   	retq   

0000000000801875 <sys_cgetc>:

int
sys_cgetc(void)
{
  801875:	55                   	push   %rbp
  801876:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801879:	48 83 ec 08          	sub    $0x8,%rsp
  80187d:	6a 00                	pushq  $0x0
  80187f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801885:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80188b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801890:	ba 00 00 00 00       	mov    $0x0,%edx
  801895:	be 00 00 00 00       	mov    $0x0,%esi
  80189a:	bf 01 00 00 00       	mov    $0x1,%edi
  80189f:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  8018a6:	00 00 00 
  8018a9:	ff d0                	callq  *%rax
  8018ab:	48 83 c4 10          	add    $0x10,%rsp
}
  8018af:	c9                   	leaveq 
  8018b0:	c3                   	retq   

00000000008018b1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018b1:	55                   	push   %rbp
  8018b2:	48 89 e5             	mov    %rsp,%rbp
  8018b5:	48 83 ec 10          	sub    $0x10,%rsp
  8018b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018bf:	48 98                	cltq   
  8018c1:	48 83 ec 08          	sub    $0x8,%rsp
  8018c5:	6a 00                	pushq  $0x0
  8018c7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018cd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018d8:	48 89 c2             	mov    %rax,%rdx
  8018db:	be 01 00 00 00       	mov    $0x1,%esi
  8018e0:	bf 03 00 00 00       	mov    $0x3,%edi
  8018e5:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  8018ec:	00 00 00 
  8018ef:	ff d0                	callq  *%rax
  8018f1:	48 83 c4 10          	add    $0x10,%rsp
}
  8018f5:	c9                   	leaveq 
  8018f6:	c3                   	retq   

00000000008018f7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018f7:	55                   	push   %rbp
  8018f8:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018fb:	48 83 ec 08          	sub    $0x8,%rsp
  8018ff:	6a 00                	pushq  $0x0
  801901:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801907:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801912:	ba 00 00 00 00       	mov    $0x0,%edx
  801917:	be 00 00 00 00       	mov    $0x0,%esi
  80191c:	bf 02 00 00 00       	mov    $0x2,%edi
  801921:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801928:	00 00 00 
  80192b:	ff d0                	callq  *%rax
  80192d:	48 83 c4 10          	add    $0x10,%rsp
}
  801931:	c9                   	leaveq 
  801932:	c3                   	retq   

0000000000801933 <sys_yield>:

void
sys_yield(void)
{
  801933:	55                   	push   %rbp
  801934:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801937:	48 83 ec 08          	sub    $0x8,%rsp
  80193b:	6a 00                	pushq  $0x0
  80193d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801943:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801949:	b9 00 00 00 00       	mov    $0x0,%ecx
  80194e:	ba 00 00 00 00       	mov    $0x0,%edx
  801953:	be 00 00 00 00       	mov    $0x0,%esi
  801958:	bf 0a 00 00 00       	mov    $0xa,%edi
  80195d:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801964:	00 00 00 
  801967:	ff d0                	callq  *%rax
  801969:	48 83 c4 10          	add    $0x10,%rsp
}
  80196d:	90                   	nop
  80196e:	c9                   	leaveq 
  80196f:	c3                   	retq   

0000000000801970 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801970:	55                   	push   %rbp
  801971:	48 89 e5             	mov    %rsp,%rbp
  801974:	48 83 ec 10          	sub    $0x10,%rsp
  801978:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80197b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80197f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801982:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801985:	48 63 c8             	movslq %eax,%rcx
  801988:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80198c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80198f:	48 98                	cltq   
  801991:	48 83 ec 08          	sub    $0x8,%rsp
  801995:	6a 00                	pushq  $0x0
  801997:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199d:	49 89 c8             	mov    %rcx,%r8
  8019a0:	48 89 d1             	mov    %rdx,%rcx
  8019a3:	48 89 c2             	mov    %rax,%rdx
  8019a6:	be 01 00 00 00       	mov    $0x1,%esi
  8019ab:	bf 04 00 00 00       	mov    $0x4,%edi
  8019b0:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  8019b7:	00 00 00 
  8019ba:	ff d0                	callq  *%rax
  8019bc:	48 83 c4 10          	add    $0x10,%rsp
}
  8019c0:	c9                   	leaveq 
  8019c1:	c3                   	retq   

00000000008019c2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019c2:	55                   	push   %rbp
  8019c3:	48 89 e5             	mov    %rsp,%rbp
  8019c6:	48 83 ec 20          	sub    $0x20,%rsp
  8019ca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019d1:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019d4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019d8:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019dc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019df:	48 63 c8             	movslq %eax,%rcx
  8019e2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019e9:	48 63 f0             	movslq %eax,%rsi
  8019ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f3:	48 98                	cltq   
  8019f5:	48 83 ec 08          	sub    $0x8,%rsp
  8019f9:	51                   	push   %rcx
  8019fa:	49 89 f9             	mov    %rdi,%r9
  8019fd:	49 89 f0             	mov    %rsi,%r8
  801a00:	48 89 d1             	mov    %rdx,%rcx
  801a03:	48 89 c2             	mov    %rax,%rdx
  801a06:	be 01 00 00 00       	mov    $0x1,%esi
  801a0b:	bf 05 00 00 00       	mov    $0x5,%edi
  801a10:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801a17:	00 00 00 
  801a1a:	ff d0                	callq  *%rax
  801a1c:	48 83 c4 10          	add    $0x10,%rsp
}
  801a20:	c9                   	leaveq 
  801a21:	c3                   	retq   

0000000000801a22 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a22:	55                   	push   %rbp
  801a23:	48 89 e5             	mov    %rsp,%rbp
  801a26:	48 83 ec 10          	sub    $0x10,%rsp
  801a2a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a2d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a38:	48 98                	cltq   
  801a3a:	48 83 ec 08          	sub    $0x8,%rsp
  801a3e:	6a 00                	pushq  $0x0
  801a40:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a46:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4c:	48 89 d1             	mov    %rdx,%rcx
  801a4f:	48 89 c2             	mov    %rax,%rdx
  801a52:	be 01 00 00 00       	mov    $0x1,%esi
  801a57:	bf 06 00 00 00       	mov    $0x6,%edi
  801a5c:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801a63:	00 00 00 
  801a66:	ff d0                	callq  *%rax
  801a68:	48 83 c4 10          	add    $0x10,%rsp
}
  801a6c:	c9                   	leaveq 
  801a6d:	c3                   	retq   

0000000000801a6e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a6e:	55                   	push   %rbp
  801a6f:	48 89 e5             	mov    %rsp,%rbp
  801a72:	48 83 ec 10          	sub    $0x10,%rsp
  801a76:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a79:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a7f:	48 63 d0             	movslq %eax,%rdx
  801a82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a85:	48 98                	cltq   
  801a87:	48 83 ec 08          	sub    $0x8,%rsp
  801a8b:	6a 00                	pushq  $0x0
  801a8d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a93:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a99:	48 89 d1             	mov    %rdx,%rcx
  801a9c:	48 89 c2             	mov    %rax,%rdx
  801a9f:	be 01 00 00 00       	mov    $0x1,%esi
  801aa4:	bf 08 00 00 00       	mov    $0x8,%edi
  801aa9:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801ab0:	00 00 00 
  801ab3:	ff d0                	callq  *%rax
  801ab5:	48 83 c4 10          	add    $0x10,%rsp
}
  801ab9:	c9                   	leaveq 
  801aba:	c3                   	retq   

0000000000801abb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801abb:	55                   	push   %rbp
  801abc:	48 89 e5             	mov    %rsp,%rbp
  801abf:	48 83 ec 10          	sub    $0x10,%rsp
  801ac3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801aca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ace:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad1:	48 98                	cltq   
  801ad3:	48 83 ec 08          	sub    $0x8,%rsp
  801ad7:	6a 00                	pushq  $0x0
  801ad9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801adf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae5:	48 89 d1             	mov    %rdx,%rcx
  801ae8:	48 89 c2             	mov    %rax,%rdx
  801aeb:	be 01 00 00 00       	mov    $0x1,%esi
  801af0:	bf 09 00 00 00       	mov    $0x9,%edi
  801af5:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801afc:	00 00 00 
  801aff:	ff d0                	callq  *%rax
  801b01:	48 83 c4 10          	add    $0x10,%rsp
}
  801b05:	c9                   	leaveq 
  801b06:	c3                   	retq   

0000000000801b07 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b07:	55                   	push   %rbp
  801b08:	48 89 e5             	mov    %rsp,%rbp
  801b0b:	48 83 ec 20          	sub    $0x20,%rsp
  801b0f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b12:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b16:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b1a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b1d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b20:	48 63 f0             	movslq %eax,%rsi
  801b23:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2a:	48 98                	cltq   
  801b2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b30:	48 83 ec 08          	sub    $0x8,%rsp
  801b34:	6a 00                	pushq  $0x0
  801b36:	49 89 f1             	mov    %rsi,%r9
  801b39:	49 89 c8             	mov    %rcx,%r8
  801b3c:	48 89 d1             	mov    %rdx,%rcx
  801b3f:	48 89 c2             	mov    %rax,%rdx
  801b42:	be 00 00 00 00       	mov    $0x0,%esi
  801b47:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b4c:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801b53:	00 00 00 
  801b56:	ff d0                	callq  *%rax
  801b58:	48 83 c4 10          	add    $0x10,%rsp
}
  801b5c:	c9                   	leaveq 
  801b5d:	c3                   	retq   

0000000000801b5e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b5e:	55                   	push   %rbp
  801b5f:	48 89 e5             	mov    %rsp,%rbp
  801b62:	48 83 ec 10          	sub    $0x10,%rsp
  801b66:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b6e:	48 83 ec 08          	sub    $0x8,%rsp
  801b72:	6a 00                	pushq  $0x0
  801b74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b80:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b85:	48 89 c2             	mov    %rax,%rdx
  801b88:	be 01 00 00 00       	mov    $0x1,%esi
  801b8d:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b92:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801b99:	00 00 00 
  801b9c:	ff d0                	callq  *%rax
  801b9e:	48 83 c4 10          	add    $0x10,%rsp
}
  801ba2:	c9                   	leaveq 
  801ba3:	c3                   	retq   

0000000000801ba4 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801ba4:	55                   	push   %rbp
  801ba5:	48 89 e5             	mov    %rsp,%rbp
  801ba8:	53                   	push   %rbx
  801ba9:	48 83 ec 38          	sub    $0x38,%rsp
  801bad:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = ROUNDDOWN((void *) utf->utf_fault_va, PGSIZE);
  801bb1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801bb5:	48 8b 00             	mov    (%rax),%rax
  801bb8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801bbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801bc6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801bca:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801bce:	48 8b 40 08          	mov    0x8(%rax),%rax
  801bd2:	89 45 dc             	mov    %eax,-0x24(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//err is not a writing error & permissions are not PTE_COW
	if (!((uvpt[(uint64_t)addr/PGSIZE] & PTE_COW) && (err & FEC_WR))){
  801bd5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bd9:	48 c1 e8 0c          	shr    $0xc,%rax
  801bdd:	48 89 c2             	mov    %rax,%rdx
  801be0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801be7:	01 00 00 
  801bea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bee:	25 00 08 00 00       	and    $0x800,%eax
  801bf3:	48 85 c0             	test   %rax,%rax
  801bf6:	74 0a                	je     801c02 <pgfault+0x5e>
  801bf8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bfb:	83 e0 02             	and    $0x2,%eax
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	75 2a                	jne    801c2c <pgfault+0x88>
		panic("not proper page fault");	
  801c02:	48 ba 58 2a 80 00 00 	movabs $0x802a58,%rdx
  801c09:	00 00 00 
  801c0c:	be 1e 00 00 00       	mov    $0x1e,%esi
  801c11:	48 bf 6e 2a 80 00 00 	movabs $0x802a6e,%rdi
  801c18:	00 00 00 
  801c1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c20:	48 b9 70 02 80 00 00 	movabs $0x800270,%rcx
  801c27:	00 00 00 
  801c2a:	ff d1                	callq  *%rcx
	// LAB 4: Your code here.
	
	int result;

	//allocate new page & map it
	result = sys_page_alloc(sys_getenvid(), PFTEMP, PTE_P|PTE_U|PTE_W);
  801c2c:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  801c33:	00 00 00 
  801c36:	ff d0                	callq  *%rax
  801c38:	ba 07 00 00 00       	mov    $0x7,%edx
  801c3d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c42:	89 c7                	mov    %eax,%edi
  801c44:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  801c4b:	00 00 00 
  801c4e:	ff d0                	callq  *%rax
  801c50:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801c53:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c57:	79 2a                	jns    801c83 <pgfault+0xdf>
		panic("page allocation failed in copy-on-write faulting page");
  801c59:	48 ba 80 2a 80 00 00 	movabs $0x802a80,%rdx
  801c60:	00 00 00 
  801c63:	be 2f 00 00 00       	mov    $0x2f,%esi
  801c68:	48 bf 6e 2a 80 00 00 	movabs $0x802a6e,%rdi
  801c6f:	00 00 00 
  801c72:	b8 00 00 00 00       	mov    $0x0,%eax
  801c77:	48 b9 70 02 80 00 00 	movabs $0x800270,%rcx
  801c7e:	00 00 00 
  801c81:	ff d1                	callq  *%rcx
	}
	
	//copy page
	memcpy(PFTEMP, addr, PGSIZE);
  801c83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c87:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c8c:	48 89 c6             	mov    %rax,%rsi
  801c8f:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801c94:	48 b8 76 14 80 00 00 	movabs $0x801476,%rax
  801c9b:	00 00 00 
  801c9e:	ff d0                	callq  *%rax
	
	//map new page into original page's space
	result = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_W|PTE_U|PTE_P);
  801ca0:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  801ca7:	00 00 00 
  801caa:	ff d0                	callq  *%rax
  801cac:	89 c3                	mov    %eax,%ebx
  801cae:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  801cb5:	00 00 00 
  801cb8:	ff d0                	callq  *%rax
  801cba:	89 c7                	mov    %eax,%edi
  801cbc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cc0:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801cc6:	48 89 c1             	mov    %rax,%rcx
  801cc9:	89 da                	mov    %ebx,%edx
  801ccb:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cd0:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  801cd7:	00 00 00 
  801cda:	ff d0                	callq  *%rax
  801cdc:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801cdf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801ce3:	79 2a                	jns    801d0f <pgfault+0x16b>
                panic("page mapping failed in copy-on-write faulting page");
  801ce5:	48 ba b8 2a 80 00 00 	movabs $0x802ab8,%rdx
  801cec:	00 00 00 
  801cef:	be 38 00 00 00       	mov    $0x38,%esi
  801cf4:	48 bf 6e 2a 80 00 00 	movabs $0x802a6e,%rdi
  801cfb:	00 00 00 
  801cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801d03:	48 b9 70 02 80 00 00 	movabs $0x800270,%rcx
  801d0a:	00 00 00 
  801d0d:	ff d1                	callq  *%rcx
        }

	//delete temporary location
	result = sys_page_unmap(sys_getenvid(), PFTEMP);
  801d0f:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  801d16:	00 00 00 
  801d19:	ff d0                	callq  *%rax
  801d1b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d20:	89 c7                	mov    %eax,%edi
  801d22:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  801d29:	00 00 00 
  801d2c:	ff d0                	callq  *%rax
  801d2e:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801d31:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801d35:	79 2a                	jns    801d61 <pgfault+0x1bd>
                panic("temporary page unmapping failed in copy-on-write faulting page");
  801d37:	48 ba f0 2a 80 00 00 	movabs $0x802af0,%rdx
  801d3e:	00 00 00 
  801d41:	be 3e 00 00 00       	mov    $0x3e,%esi
  801d46:	48 bf 6e 2a 80 00 00 	movabs $0x802a6e,%rdi
  801d4d:	00 00 00 
  801d50:	b8 00 00 00 00       	mov    $0x0,%eax
  801d55:	48 b9 70 02 80 00 00 	movabs $0x800270,%rcx
  801d5c:	00 00 00 
  801d5f:	ff d1                	callq  *%rcx
        }	

	//panic("pgfault not implemented");

}
  801d61:	90                   	nop
  801d62:	48 83 c4 38          	add    $0x38,%rsp
  801d66:	5b                   	pop    %rbx
  801d67:	5d                   	pop    %rbp
  801d68:	c3                   	retq   

0000000000801d69 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d69:	55                   	push   %rbp
  801d6a:	48 89 e5             	mov    %rsp,%rbp
  801d6d:	53                   	push   %rbx
  801d6e:	48 83 ec 28          	sub    $0x28,%rsp
  801d72:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801d75:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uint64_t)pn*PGSIZE);	
  801d78:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801d7b:	48 c1 e0 0c          	shl    $0xc,%rax
  801d7f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result;

	//COW or writable
	if ((uvpt[pn]&PTE_COW) || (uvpt[pn]&PTE_W)){
  801d83:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d8a:	01 00 00 
  801d8d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801d90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d94:	25 00 08 00 00       	and    $0x800,%eax
  801d99:	48 85 c0             	test   %rax,%rax
  801d9c:	75 1d                	jne    801dbb <duppage+0x52>
  801d9e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801da5:	01 00 00 
  801da8:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801dab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801daf:	83 e0 02             	and    $0x2,%eax
  801db2:	48 85 c0             	test   %rax,%rax
  801db5:	0f 84 8f 00 00 00    	je     801e4a <duppage+0xe1>
		//map to child
		result = sys_page_map(sys_getenvid(), addr, envid, addr, PTE_COW|PTE_U|PTE_P);
  801dbb:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  801dc2:	00 00 00 
  801dc5:	ff d0                	callq  *%rax
  801dc7:	89 c7                	mov    %eax,%edi
  801dc9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801dcd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801dd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd4:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801dda:	48 89 c6             	mov    %rax,%rsi
  801ddd:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  801de4:	00 00 00 
  801de7:	ff d0                	callq  *%rax
  801de9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (result<0){
  801dec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801df0:	79 0a                	jns    801dfc <duppage+0x93>
			return -1;
  801df2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801df7:	e9 91 00 00 00       	jmpq   801e8d <duppage+0x124>
		}

		//remap page with proper permissions COW
		result = sys_page_map(sys_getenvid(), addr, sys_getenvid(), addr, PTE_COW|PTE_U|PTE_P);
  801dfc:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  801e03:	00 00 00 
  801e06:	ff d0                	callq  *%rax
  801e08:	89 c3                	mov    %eax,%ebx
  801e0a:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  801e11:	00 00 00 
  801e14:	ff d0                	callq  *%rax
  801e16:	89 c7                	mov    %eax,%edi
  801e18:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e20:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801e26:	48 89 d1             	mov    %rdx,%rcx
  801e29:	89 da                	mov    %ebx,%edx
  801e2b:	48 89 c6             	mov    %rax,%rsi
  801e2e:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  801e35:	00 00 00 
  801e38:	ff d0                	callq  *%rax
  801e3a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (result<0){
  801e3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801e41:	79 45                	jns    801e88 <duppage+0x11f>
                        return -1;
  801e43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801e48:	eb 43                	jmp    801e8d <duppage+0x124>
                } 	
	//not proper permissions
	}else{
		result=sys_page_map(sys_getenvid(), addr, envid, addr, PTE_P|PTE_U);
  801e4a:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  801e51:	00 00 00 
  801e54:	ff d0                	callq  *%rax
  801e56:	89 c7                	mov    %eax,%edi
  801e58:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e5c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801e5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e63:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  801e69:	48 89 c6             	mov    %rax,%rsi
  801e6c:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  801e73:	00 00 00 
  801e76:	ff d0                	callq  *%rax
  801e78:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (result<0){
  801e7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801e7f:	79 07                	jns    801e88 <duppage+0x11f>
			return -1;
  801e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801e86:	eb 05                	jmp    801e8d <duppage+0x124>
		}
	}

	//panic("duppage not implemented");
	return 0;
  801e88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8d:	48 83 c4 28          	add    $0x28,%rsp
  801e91:	5b                   	pop    %rbx
  801e92:	5d                   	pop    %rbp
  801e93:	c3                   	retq   

0000000000801e94 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801e94:	55                   	push   %rbp
  801e95:	48 89 e5             	mov    %rsp,%rbp
  801e98:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	//LOOKED AT DUMBFORK FOR HELP :)	


	//step 1 
	set_pgfault_handler(pgfault);
  801e9c:	48 bf a4 1b 80 00 00 	movabs $0x801ba4,%rdi
  801ea3:	00 00 00 
  801ea6:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  801ead:	00 00 00 
  801eb0:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801eb2:	b8 07 00 00 00       	mov    $0x7,%eax
  801eb7:	cd 30                	int    $0x30
  801eb9:	89 45 e8             	mov    %eax,-0x18(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801ebc:	8b 45 e8             	mov    -0x18(%rbp),%eax
	
	//step 2
	envid_t child = sys_exofork();
  801ebf:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (child==0){
  801ec2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ec6:	75 46                	jne    801f0e <fork+0x7a>
		//fix env in child
		thisenv = &envs[ENVX(sys_getenvid())];
  801ec8:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  801ecf:	00 00 00 
  801ed2:	ff d0                	callq  *%rax
  801ed4:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ed9:	48 63 d0             	movslq %eax,%rdx
  801edc:	48 89 d0             	mov    %rdx,%rax
  801edf:	48 c1 e0 03          	shl    $0x3,%rax
  801ee3:	48 01 d0             	add    %rdx,%rax
  801ee6:	48 c1 e0 05          	shl    $0x5,%rax
  801eea:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801ef1:	00 00 00 
  801ef4:	48 01 c2             	add    %rax,%rdx
  801ef7:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  801efe:	00 00 00 
  801f01:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801f04:	b8 00 00 00 00       	mov    $0x0,%eax
  801f09:	e9 2b 03 00 00       	jmpq   802239 <fork+0x3a5>
	}
	if(child<0){
  801f0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f12:	79 0a                	jns    801f1e <fork+0x8a>
		return -1; //exofork failed
  801f14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801f19:	e9 1b 03 00 00       	jmpq   802239 <fork+0x3a5>

//For each writable or copy-on-write page in its address space below UTOP, the parent calls duppage, which should map the page copy-on-write into the address space of the child and then remap the page copy-on-write in its own address space. duppage sets both PTEs so that the page is not writeable, and to contain PTE_COW in the "avail" field to distinguish copy-on-write pages from genuine read-only pages.

	uintptr_t addr;
	extern unsigned char end[];
	for (addr = (uintptr_t)UTEXT; addr < (uintptr_t)end; addr += PGSIZE){//taken from dumbfork
  801f1e:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  801f25:	00 
  801f26:	e9 ec 00 00 00       	jmpq   802017 <fork+0x183>
		
		//check if page is copy on write
		int perms = (uvpml4e[VPML4E(addr)] & PTE_P);
  801f2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f2f:	48 c1 e8 27          	shr    $0x27,%rax
  801f33:	48 89 c2             	mov    %rax,%rdx
  801f36:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f3d:	01 00 00 
  801f40:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f44:	83 e0 01             	and    $0x1,%eax
  801f47:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpde[VPDPE(addr)] & PTE_P);
  801f4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f4e:	74 28                	je     801f78 <fork+0xe4>
  801f50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f54:	48 c1 e8 1e          	shr    $0x1e,%rax
  801f58:	48 89 c2             	mov    %rax,%rdx
  801f5b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801f62:	01 00 00 
  801f65:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f69:	83 e0 01             	and    $0x1,%eax
  801f6c:	48 85 c0             	test   %rax,%rax
  801f6f:	74 07                	je     801f78 <fork+0xe4>
  801f71:	b8 01 00 00 00       	mov    $0x1,%eax
  801f76:	eb 05                	jmp    801f7d <fork+0xe9>
  801f78:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpd[VPD(addr)] & PTE_P);		
  801f80:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f84:	74 28                	je     801fae <fork+0x11a>
  801f86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f8a:	48 c1 e8 15          	shr    $0x15,%rax
  801f8e:	48 89 c2             	mov    %rax,%rdx
  801f91:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f98:	01 00 00 
  801f9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f9f:	83 e0 01             	and    $0x1,%eax
  801fa2:	48 85 c0             	test   %rax,%rax
  801fa5:	74 07                	je     801fae <fork+0x11a>
  801fa7:	b8 01 00 00 00       	mov    $0x1,%eax
  801fac:	eb 05                	jmp    801fb3 <fork+0x11f>
  801fae:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb3:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpt[PGNUM(addr)] & (PTE_P | PTE_U));
  801fb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801fba:	74 28                	je     801fe4 <fork+0x150>
  801fbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc0:	48 c1 e8 0c          	shr    $0xc,%rax
  801fc4:	48 89 c2             	mov    %rax,%rdx
  801fc7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fce:	01 00 00 
  801fd1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd5:	83 e0 05             	and    $0x5,%eax
  801fd8:	48 85 c0             	test   %rax,%rax
  801fdb:	74 07                	je     801fe4 <fork+0x150>
  801fdd:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe2:	eb 05                	jmp    801fe9 <fork+0x155>
  801fe4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe9:	89 45 f0             	mov    %eax,-0x10(%rbp)

		if (perms){
  801fec:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801ff0:	74 1d                	je     80200f <fork+0x17b>
			duppage(child, PGNUM(addr));
  801ff2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ff6:	48 c1 e8 0c          	shr    $0xc,%rax
  801ffa:	89 c2                	mov    %eax,%edx
  801ffc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fff:	89 d6                	mov    %edx,%esi
  802001:	89 c7                	mov    %eax,%edi
  802003:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  80200a:	00 00 00 
  80200d:	ff d0                	callq  *%rax

//For each writable or copy-on-write page in its address space below UTOP, the parent calls duppage, which should map the page copy-on-write into the address space of the child and then remap the page copy-on-write in its own address space. duppage sets both PTEs so that the page is not writeable, and to contain PTE_COW in the "avail" field to distinguish copy-on-write pages from genuine read-only pages.

	uintptr_t addr;
	extern unsigned char end[];
	for (addr = (uintptr_t)UTEXT; addr < (uintptr_t)end; addr += PGSIZE){//taken from dumbfork
  80200f:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  802016:	00 
  802017:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  80201e:	00 00 00 
  802021:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802025:	0f 82 00 ff ff ff    	jb     801f2b <fork+0x97>
//The exception stack is not remapped this way, however. Instead you need to allocate a fresh page in the child for the exception stack. Since the page fault handler will be doing the actual copying and the page fault handler runs on the exception stack, the exception stack cannot be made copy-on-write: who would copy it?

	int result;

        //allocate new page & map it
        result = sys_page_alloc(sys_getenvid(), PFTEMP, PTE_P|PTE_U|PTE_W);
  80202b:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  802032:	00 00 00 
  802035:	ff d0                	callq  *%rax
  802037:	ba 07 00 00 00       	mov    $0x7,%edx
  80203c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802041:	89 c7                	mov    %eax,%edi
  802043:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  80204a:	00 00 00 
  80204d:	ff d0                	callq  *%rax
  80204f:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  802052:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802056:	79 2a                	jns    802082 <fork+0x1ee>
                panic("page allocation failed in fork");
  802058:	48 ba 30 2b 80 00 00 	movabs $0x802b30,%rdx
  80205f:	00 00 00 
  802062:	be b0 00 00 00       	mov    $0xb0,%esi
  802067:	48 bf 6e 2a 80 00 00 	movabs $0x802a6e,%rdi
  80206e:	00 00 00 
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
  802076:	48 b9 70 02 80 00 00 	movabs $0x800270,%rcx
  80207d:	00 00 00 
  802080:	ff d1                	callq  *%rcx
        }

        //copy page
        memcpy(PFTEMP, (void *)(USTACKTOP-PGSIZE), PGSIZE);
  802082:	ba 00 10 00 00       	mov    $0x1000,%edx
  802087:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80208c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802091:	48 b8 76 14 80 00 00 	movabs $0x801476,%rax
  802098:	00 00 00 
  80209b:	ff d0                	callq  *%rax

        //map new page into original page's space
        result = sys_page_map(sys_getenvid(), PFTEMP, child,(void *)(USTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  80209d:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  8020a4:	00 00 00 
  8020a7:	ff d0                	callq  *%rax
  8020a9:	89 c7                	mov    %eax,%edi
  8020ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020ae:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8020b4:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8020b9:	89 c2                	mov    %eax,%edx
  8020bb:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020c0:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  8020c7:	00 00 00 
  8020ca:	ff d0                	callq  *%rax
  8020cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  8020cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020d3:	79 2a                	jns    8020ff <fork+0x26b>
                panic("page mapping failed in fork");
  8020d5:	48 ba 4f 2b 80 00 00 	movabs $0x802b4f,%rdx
  8020dc:	00 00 00 
  8020df:	be b9 00 00 00       	mov    $0xb9,%esi
  8020e4:	48 bf 6e 2a 80 00 00 	movabs $0x802a6e,%rdi
  8020eb:	00 00 00 
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f3:	48 b9 70 02 80 00 00 	movabs $0x800270,%rcx
  8020fa:	00 00 00 
  8020fd:	ff d1                	callq  *%rcx
        }

        //delete temporary location
        result = sys_page_unmap(sys_getenvid(), PFTEMP);
  8020ff:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  802106:	00 00 00 
  802109:	ff d0                	callq  *%rax
  80210b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802110:	89 c7                	mov    %eax,%edi
  802112:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  802119:	00 00 00 
  80211c:	ff d0                	callq  *%rax
  80211e:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  802121:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802125:	79 2a                	jns    802151 <fork+0x2bd>
                panic("temporary page unmapping failed in copy-on-write faulting page");
  802127:	48 ba f0 2a 80 00 00 	movabs $0x802af0,%rdx
  80212e:	00 00 00 
  802131:	be bf 00 00 00       	mov    $0xbf,%esi
  802136:	48 bf 6e 2a 80 00 00 	movabs $0x802a6e,%rdi
  80213d:	00 00 00 
  802140:	b8 00 00 00 00       	mov    $0x0,%eax
  802145:	48 b9 70 02 80 00 00 	movabs $0x800270,%rcx
  80214c:	00 00 00 
  80214f:	ff d1                	callq  *%rcx
        }
// STEP 4
//The parent sets the user page fault entrypoint for the child to look like its own.

	result=sys_page_alloc(child, (void*)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W);
  802151:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802154:	ba 07 00 00 00       	mov    $0x7,%edx
  802159:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80215e:	89 c7                	mov    %eax,%edi
  802160:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  802167:	00 00 00 
  80216a:	ff d0                	callq  *%rax
  80216c:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  80216f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802173:	79 2a                	jns    80219f <fork+0x30b>
		panic("page alloc of table failed in fork");
  802175:	48 ba 70 2b 80 00 00 	movabs $0x802b70,%rdx
  80217c:	00 00 00 
  80217f:	be c6 00 00 00       	mov    $0xc6,%esi
  802184:	48 bf 6e 2a 80 00 00 	movabs $0x802a6e,%rdi
  80218b:	00 00 00 
  80218e:	b8 00 00 00 00       	mov    $0x0,%eax
  802193:	48 b9 70 02 80 00 00 	movabs $0x800270,%rcx
  80219a:	00 00 00 
  80219d:	ff d1                	callq  *%rcx
	}

	extern void _pgfault_upcall();
	result = sys_env_set_pgfault_upcall(child, _pgfault_upcall);
  80219f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021a2:	48 be 1b 25 80 00 00 	movabs $0x80251b,%rsi
  8021a9:	00 00 00 
  8021ac:	89 c7                	mov    %eax,%edi
  8021ae:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  8021b5:	00 00 00 
  8021b8:	ff d0                	callq  *%rax
  8021ba:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  8021bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021c1:	79 2a                	jns    8021ed <fork+0x359>
		panic("setting upcall failed in fork"); 
  8021c3:	48 ba 93 2b 80 00 00 	movabs $0x802b93,%rdx
  8021ca:	00 00 00 
  8021cd:	be cc 00 00 00       	mov    $0xcc,%esi
  8021d2:	48 bf 6e 2a 80 00 00 	movabs $0x802a6e,%rdi
  8021d9:	00 00 00 
  8021dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e1:	48 b9 70 02 80 00 00 	movabs $0x800270,%rcx
  8021e8:	00 00 00 
  8021eb:	ff d1                	callq  *%rcx
	}
// STEP 5
//The child is now ready to run, so the parent marks it runnable.

	result = sys_env_set_status(child, ENV_RUNNABLE);
  8021ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021f0:	be 02 00 00 00       	mov    $0x2,%esi
  8021f5:	89 c7                	mov    %eax,%edi
  8021f7:	48 b8 6e 1a 80 00 00 	movabs $0x801a6e,%rax
  8021fe:	00 00 00 
  802201:	ff d0                	callq  *%rax
  802203:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  802206:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80220a:	79 2a                	jns    802236 <fork+0x3a2>
		panic("changing statys is fork failed");
  80220c:	48 ba b8 2b 80 00 00 	movabs $0x802bb8,%rdx
  802213:	00 00 00 
  802216:	be d3 00 00 00       	mov    $0xd3,%esi
  80221b:	48 bf 6e 2a 80 00 00 	movabs $0x802a6e,%rdi
  802222:	00 00 00 
  802225:	b8 00 00 00 00       	mov    $0x0,%eax
  80222a:	48 b9 70 02 80 00 00 	movabs $0x800270,%rcx
  802231:	00 00 00 
  802234:	ff d1                	callq  *%rcx
	}
	
	return child;
  802236:	8b 45 f4             	mov    -0xc(%rbp),%eax

}
  802239:	c9                   	leaveq 
  80223a:	c3                   	retq   

000000000080223b <sfork>:

// Challenge!
int
sfork(void)
{
  80223b:	55                   	push   %rbp
  80223c:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80223f:	48 ba d7 2b 80 00 00 	movabs $0x802bd7,%rdx
  802246:	00 00 00 
  802249:	be de 00 00 00       	mov    $0xde,%esi
  80224e:	48 bf 6e 2a 80 00 00 	movabs $0x802a6e,%rdi
  802255:	00 00 00 
  802258:	b8 00 00 00 00       	mov    $0x0,%eax
  80225d:	48 b9 70 02 80 00 00 	movabs $0x800270,%rcx
  802264:	00 00 00 
  802267:	ff d1                	callq  *%rcx

0000000000802269 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802269:	55                   	push   %rbp
  80226a:	48 89 e5             	mov    %rsp,%rbp
  80226d:	48 83 ec 30          	sub    $0x30,%rsp
  802271:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802275:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802279:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	//cprintf("lib ipc_recv\n");
	// LAB 4: Your code here.
	if (pg==NULL){
  80227d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802282:	75 08                	jne    80228c <ipc_recv+0x23>
		pg = (void *) -1;	
  802284:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  80228b:	ff 
	}
	
	int result = sys_ipc_recv(pg);
  80228c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802290:	48 89 c7             	mov    %rax,%rdi
  802293:	48 b8 5e 1b 80 00 00 	movabs $0x801b5e,%rax
  80229a:	00 00 00 
  80229d:	ff d0                	callq  *%rax
  80229f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (result<0){
  8022a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a6:	79 27                	jns    8022cf <ipc_recv+0x66>
		if (from_env_store){
  8022a8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8022ad:	74 0a                	je     8022b9 <ipc_recv+0x50>
			*from_env_store=0;
  8022af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if (perm_store){
  8022b9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022be:	74 0a                	je     8022ca <ipc_recv+0x61>
			*perm_store = 0;
  8022c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022c4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		return result;
  8022ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022cd:	eb 53                	jmp    802322 <ipc_recv+0xb9>
	}	
	if (from_env_store){
  8022cf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8022d4:	74 19                	je     8022ef <ipc_recv+0x86>
	 	*from_env_store = thisenv->env_ipc_from;
  8022d6:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8022dd:	00 00 00 
  8022e0:	48 8b 00             	mov    (%rax),%rax
  8022e3:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8022e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ed:	89 10                	mov    %edx,(%rax)
        }
        if (perm_store){
  8022ef:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022f4:	74 19                	je     80230f <ipc_recv+0xa6>
               	*perm_store = thisenv->env_ipc_perm;
  8022f6:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8022fd:	00 00 00 
  802300:	48 8b 00             	mov    (%rax),%rax
  802303:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802309:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80230d:	89 10                	mov    %edx,(%rax)
        }
	//panic("ipc_recv not implemented");
	return thisenv->env_ipc_value;
  80230f:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  802316:	00 00 00 
  802319:	48 8b 00             	mov    (%rax),%rax
  80231c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  802322:	c9                   	leaveq 
  802323:	c3                   	retq   

0000000000802324 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802324:	55                   	push   %rbp
  802325:	48 89 e5             	mov    %rsp,%rbp
  802328:	48 83 ec 30          	sub    $0x30,%rsp
  80232c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80232f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802332:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802336:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	//cprintf("lib ipc_send\n");
	// LAB 4: Your code here.
	if (pg==NULL){
  802339:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80233e:	75 4c                	jne    80238c <ipc_send+0x68>
		pg = (void *)-1;
  802340:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  802347:	ff 
	}
	int result;
	while((result=sys_ipc_try_send(to_env, val, pg, perm))){
  802348:	eb 42                	jmp    80238c <ipc_send+0x68>
		if (result==0){
  80234a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80234e:	74 62                	je     8023b2 <ipc_send+0x8e>
			break;
		}
		if (result!=-E_IPC_NOT_RECV){
  802350:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802354:	74 2a                	je     802380 <ipc_send+0x5c>
			panic("syscall returned improper error");
  802356:	48 ba f0 2b 80 00 00 	movabs $0x802bf0,%rdx
  80235d:	00 00 00 
  802360:	be 49 00 00 00       	mov    $0x49,%esi
  802365:	48 bf 10 2c 80 00 00 	movabs $0x802c10,%rdi
  80236c:	00 00 00 
  80236f:	b8 00 00 00 00       	mov    $0x0,%eax
  802374:	48 b9 70 02 80 00 00 	movabs $0x800270,%rcx
  80237b:	00 00 00 
  80237e:	ff d1                	callq  *%rcx
		}
		sys_yield();
  802380:	48 b8 33 19 80 00 00 	movabs $0x801933,%rax
  802387:	00 00 00 
  80238a:	ff d0                	callq  *%rax
	// LAB 4: Your code here.
	if (pg==NULL){
		pg = (void *)-1;
	}
	int result;
	while((result=sys_ipc_try_send(to_env, val, pg, perm))){
  80238c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80238f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802392:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802396:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802399:	89 c7                	mov    %eax,%edi
  80239b:	48 b8 07 1b 80 00 00 	movabs $0x801b07,%rax
  8023a2:	00 00 00 
  8023a5:	ff d0                	callq  *%rax
  8023a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ae:	75 9a                	jne    80234a <ipc_send+0x26>
			panic("syscall returned improper error");
		}
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  8023b0:	eb 01                	jmp    8023b3 <ipc_send+0x8f>
		pg = (void *)-1;
	}
	int result;
	while((result=sys_ipc_try_send(to_env, val, pg, perm))){
		if (result==0){
			break;
  8023b2:	90                   	nop
			panic("syscall returned improper error");
		}
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  8023b3:	90                   	nop
  8023b4:	c9                   	leaveq 
  8023b5:	c3                   	retq   

00000000008023b6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023b6:	55                   	push   %rbp
  8023b7:	48 89 e5             	mov    %rsp,%rbp
  8023ba:	48 83 ec 18          	sub    $0x18,%rsp
  8023be:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8023c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023c8:	eb 5d                	jmp    802427 <ipc_find_env+0x71>
		if (envs[i].env_type == type)
  8023ca:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8023d1:	00 00 00 
  8023d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d7:	48 63 d0             	movslq %eax,%rdx
  8023da:	48 89 d0             	mov    %rdx,%rax
  8023dd:	48 c1 e0 03          	shl    $0x3,%rax
  8023e1:	48 01 d0             	add    %rdx,%rax
  8023e4:	48 c1 e0 05          	shl    $0x5,%rax
  8023e8:	48 01 c8             	add    %rcx,%rax
  8023eb:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8023f1:	8b 00                	mov    (%rax),%eax
  8023f3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8023f6:	75 2b                	jne    802423 <ipc_find_env+0x6d>
			return envs[i].env_id;
  8023f8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8023ff:	00 00 00 
  802402:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802405:	48 63 d0             	movslq %eax,%rdx
  802408:	48 89 d0             	mov    %rdx,%rax
  80240b:	48 c1 e0 03          	shl    $0x3,%rax
  80240f:	48 01 d0             	add    %rdx,%rax
  802412:	48 c1 e0 05          	shl    $0x5,%rax
  802416:	48 01 c8             	add    %rcx,%rax
  802419:	48 05 c8 00 00 00    	add    $0xc8,%rax
  80241f:	8b 00                	mov    (%rax),%eax
  802421:	eb 12                	jmp    802435 <ipc_find_env+0x7f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802423:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802427:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80242e:	7e 9a                	jle    8023ca <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802430:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802435:	c9                   	leaveq 
  802436:	c3                   	retq   

0000000000802437 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802437:	55                   	push   %rbp
  802438:	48 89 e5             	mov    %rsp,%rbp
  80243b:	48 83 ec 20          	sub    $0x20,%rsp
  80243f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler==0) {
  802443:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80244a:	00 00 00 
  80244d:	48 8b 00             	mov    (%rax),%rax
  802450:	48 85 c0             	test   %rax,%rax
  802453:	0f 85 ae 00 00 00    	jne    802507 <set_pgfault_handler+0xd0>
		//allocate space
		int result = sys_page_alloc(sys_getenvid(), (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  802459:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  802460:	00 00 00 
  802463:	ff d0                	callq  *%rax
  802465:	ba 07 00 00 00       	mov    $0x7,%edx
  80246a:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80246f:	89 c7                	mov    %eax,%edi
  802471:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  802478:	00 00 00 
  80247b:	ff d0                	callq  *%rax
  80247d:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  802480:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802484:	79 2a                	jns    8024b0 <set_pgfault_handler+0x79>
			panic("sys_page_alloc for stack failed in setting page fault handler");
  802486:	48 ba 20 2c 80 00 00 	movabs $0x802c20,%rdx
  80248d:	00 00 00 
  802490:	be 21 00 00 00       	mov    $0x21,%esi
  802495:	48 bf 5e 2c 80 00 00 	movabs $0x802c5e,%rdi
  80249c:	00 00 00 
  80249f:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a4:	48 b9 70 02 80 00 00 	movabs $0x800270,%rcx
  8024ab:	00 00 00 
  8024ae:	ff d1                	callq  *%rcx
		}

		//actual set upcall
		result = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8024b0:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  8024b7:	00 00 00 
  8024ba:	ff d0                	callq  *%rax
  8024bc:	48 be 1b 25 80 00 00 	movabs $0x80251b,%rsi
  8024c3:	00 00 00 
  8024c6:	89 c7                	mov    %eax,%edi
  8024c8:	48 b8 bb 1a 80 00 00 	movabs $0x801abb,%rax
  8024cf:	00 00 00 
  8024d2:	ff d0                	callq  *%rax
  8024d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  8024d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024db:	79 2a                	jns    802507 <set_pgfault_handler+0xd0>
                        panic("setting upcall failed in setting page fault handler");
  8024dd:	48 ba 70 2c 80 00 00 	movabs $0x802c70,%rdx
  8024e4:	00 00 00 
  8024e7:	be 27 00 00 00       	mov    $0x27,%esi
  8024ec:	48 bf 5e 2c 80 00 00 	movabs $0x802c5e,%rdi
  8024f3:	00 00 00 
  8024f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fb:	48 b9 70 02 80 00 00 	movabs $0x800270,%rcx
  802502:	00 00 00 
  802505:	ff d1                	callq  *%rcx
                }
		//panic("set_pgfault_handler not implemented");
	}

	_pgfault_handler = handler;
  802507:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80250e:	00 00 00 
  802511:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802515:	48 89 10             	mov    %rdx,(%rax)

}
  802518:	90                   	nop
  802519:	c9                   	leaveq 
  80251a:	c3                   	retq   

000000000080251b <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80251b:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80251e:	48 a1 10 40 80 00 00 	movabs 0x804010,%rax
  802525:	00 00 00 
call *%rax
  802528:	ff d0                	callq  *%rax
	//MAKE STACK CALCS for getting parameters
	//20 = size of stack
	//8 = size of word	

	//(20-3)*8=17*8=136
	movq 136(%rsp), %rax
  80252a:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  802531:	00 
	//(20-1)*8=152
	subq $8, 152(%rsp)
  802532:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  802539:	00 08 
	movq 152(%rsp), %rbx
  80253b:	48 8b 9c 24 98 00 00 	mov    0x98(%rsp),%rbx
  802542:	00 
	movq %rax, (%rbx)
  802543:	48 89 03             	mov    %rax,(%rbx)
	addq $16, %rsp
  802546:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
	
    	POPA_
  80254a:	4c 8b 3c 24          	mov    (%rsp),%r15
  80254e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802553:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802558:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80255d:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802562:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802567:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80256c:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802571:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802576:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80257b:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802580:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802585:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80258a:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80258f:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802594:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
	//https://www.felixcloutier.com/x86/POPF:POPFD:POPFQ.html
    	addq $8, %rsp
  802598:	48 83 c4 08          	add    $0x8,%rsp
    	popfq	
  80259c:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    	popq %rsp
  80259d:	5c                   	pop    %rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    	ret
  80259e:	c3                   	retq   
