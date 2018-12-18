
obj/user/pingpongs:     file format elf64-x86-64


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
  80003c:	e8 b6 01 00 00       	callq  8001f7 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	41 56                	push   %r14
  800049:	41 55                	push   %r13
  80004b:	41 54                	push   %r12
  80004d:	53                   	push   %rbx
  80004e:	48 83 ec 20          	sub    $0x20,%rsp
  800052:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800055:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	envid_t who;
	uint32_t i;

	i = 0;
  800059:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	if ((who = sfork()) != 0) {
  800060:	48 b8 52 21 80 00 00 	movabs $0x802152,%rax
  800067:	00 00 00 
  80006a:	ff d0                	callq  *%rax
  80006c:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80006f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800072:	85 c0                	test   %eax,%eax
  800074:	0f 84 87 00 00 00    	je     800101 <umain+0xbe>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  80007a:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  800081:	00 00 00 
  800084:	48 8b 18             	mov    (%rax),%rbx
  800087:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	48 89 da             	mov    %rbx,%rdx
  800096:	89 c6                	mov    %eax,%esi
  800098:	48 bf e0 25 80 00 00 	movabs $0x8025e0,%rdi
  80009f:	00 00 00 
  8000a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a7:	48 b9 c1 03 80 00 00 	movabs $0x8003c1,%rcx
  8000ae:	00 00 00 
  8000b1:	ff d1                	callq  *%rcx
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000b3:	8b 5d d8             	mov    -0x28(%rbp),%ebx
  8000b6:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  8000bd:	00 00 00 
  8000c0:	ff d0                	callq  *%rax
  8000c2:	89 da                	mov    %ebx,%edx
  8000c4:	89 c6                	mov    %eax,%esi
  8000c6:	48 bf fa 25 80 00 00 	movabs $0x8025fa,%rdi
  8000cd:	00 00 00 
  8000d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d5:	48 b9 c1 03 80 00 00 	movabs $0x8003c1,%rcx
  8000dc:	00 00 00 
  8000df:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  8000e1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8000e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ee:	be 00 00 00 00       	mov    $0x0,%esi
  8000f3:	89 c7                	mov    %eax,%edi
  8000f5:	48 b8 3b 22 80 00 00 	movabs $0x80223b,%rax
  8000fc:	00 00 00 
  8000ff:	ff d0                	callq  *%rax
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800101:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  800105:	ba 00 00 00 00       	mov    $0x0,%edx
  80010a:	be 00 00 00 00       	mov    $0x0,%esi
  80010f:	48 89 c7             	mov    %rax,%rdi
  800112:	48 b8 80 21 80 00 00 	movabs $0x802180,%rax
  800119:	00 00 00 
  80011c:	ff d0                	callq  *%rax
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80011e:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  800125:	00 00 00 
  800128:	48 8b 00             	mov    (%rax),%rax
  80012b:	44 8b b0 c8 00 00 00 	mov    0xc8(%rax),%r14d
  800132:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  800139:	00 00 00 
  80013c:	4c 8b 28             	mov    (%rax),%r13
  80013f:	44 8b 65 d8          	mov    -0x28(%rbp),%r12d
  800143:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80014a:	00 00 00 
  80014d:	8b 18                	mov    (%rax),%ebx
  80014f:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	45 89 f1             	mov    %r14d,%r9d
  80015e:	4d 89 e8             	mov    %r13,%r8
  800161:	44 89 e1             	mov    %r12d,%ecx
  800164:	89 da                	mov    %ebx,%edx
  800166:	89 c6                	mov    %eax,%esi
  800168:	48 bf 10 26 80 00 00 	movabs $0x802610,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	49 ba c1 03 80 00 00 	movabs $0x8003c1,%r10
  80017e:	00 00 00 
  800181:	41 ff d2             	callq  *%r10
		if (val == 10)
  800184:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80018b:	00 00 00 
  80018e:	8b 00                	mov    (%rax),%eax
  800190:	83 f8 0a             	cmp    $0xa,%eax
  800193:	74 51                	je     8001e6 <umain+0x1a3>
			return;
		++val;
  800195:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80019c:	00 00 00 
  80019f:	8b 00                	mov    (%rax),%eax
  8001a1:	8d 50 01             	lea    0x1(%rax),%edx
  8001a4:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8001ab:	00 00 00 
  8001ae:	89 10                	mov    %edx,(%rax)
		ipc_send(who, 0, 0, 0);
  8001b0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8001b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bd:	be 00 00 00 00       	mov    $0x0,%esi
  8001c2:	89 c7                	mov    %eax,%edi
  8001c4:	48 b8 3b 22 80 00 00 	movabs $0x80223b,%rax
  8001cb:	00 00 00 
  8001ce:	ff d0                	callq  *%rax
		if (val == 10)
  8001d0:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8001d7:	00 00 00 
  8001da:	8b 00                	mov    (%rax),%eax
  8001dc:	83 f8 0a             	cmp    $0xa,%eax
  8001df:	74 08                	je     8001e9 <umain+0x1a6>
			return;
	}
  8001e1:	e9 1b ff ff ff       	jmpq   800101 <umain+0xbe>

	while (1) {
		ipc_recv(&who, 0, 0);
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
		if (val == 10)
			return;
  8001e6:	90                   	nop
  8001e7:	eb 01                	jmp    8001ea <umain+0x1a7>
		++val;
		ipc_send(who, 0, 0, 0);
		if (val == 10)
			return;
  8001e9:	90                   	nop
	}

}
  8001ea:	48 83 c4 20          	add    $0x20,%rsp
  8001ee:	5b                   	pop    %rbx
  8001ef:	41 5c                	pop    %r12
  8001f1:	41 5d                	pop    %r13
  8001f3:	41 5e                	pop    %r14
  8001f5:	5d                   	pop    %rbp
  8001f6:	c3                   	retq   

00000000008001f7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f7:	55                   	push   %rbp
  8001f8:	48 89 e5             	mov    %rsp,%rbp
  8001fb:	48 83 ec 10          	sub    $0x10,%rsp
  8001ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800202:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  800206:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  80020d:	00 00 00 
  800210:	ff d0                	callq  *%rax
  800212:	25 ff 03 00 00       	and    $0x3ff,%eax
  800217:	48 63 d0             	movslq %eax,%rdx
  80021a:	48 89 d0             	mov    %rdx,%rax
  80021d:	48 c1 e0 03          	shl    $0x3,%rax
  800221:	48 01 d0             	add    %rdx,%rax
  800224:	48 c1 e0 05          	shl    $0x5,%rax
  800228:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80022f:	00 00 00 
  800232:	48 01 c2             	add    %rax,%rdx
  800235:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80023c:	00 00 00 
  80023f:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800242:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800246:	7e 14                	jle    80025c <libmain+0x65>
		binaryname = argv[0];
  800248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80024c:	48 8b 10             	mov    (%rax),%rdx
  80024f:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800256:	00 00 00 
  800259:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80025c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800260:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800263:	48 89 d6             	mov    %rdx,%rsi
  800266:	89 c7                	mov    %eax,%edi
  800268:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80026f:	00 00 00 
  800272:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800274:	48 b8 83 02 80 00 00 	movabs $0x800283,%rax
  80027b:	00 00 00 
  80027e:	ff d0                	callq  *%rax
}
  800280:	90                   	nop
  800281:	c9                   	leaveq 
  800282:	c3                   	retq   

0000000000800283 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800283:	55                   	push   %rbp
  800284:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800287:	bf 00 00 00 00       	mov    $0x0,%edi
  80028c:	48 b8 c8 17 80 00 00 	movabs $0x8017c8,%rax
  800293:	00 00 00 
  800296:	ff d0                	callq  *%rax
}
  800298:	90                   	nop
  800299:	5d                   	pop    %rbp
  80029a:	c3                   	retq   

000000000080029b <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80029b:	55                   	push   %rbp
  80029c:	48 89 e5             	mov    %rsp,%rbp
  80029f:	48 83 ec 10          	sub    $0x10,%rsp
  8002a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8002aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ae:	8b 00                	mov    (%rax),%eax
  8002b0:	8d 48 01             	lea    0x1(%rax),%ecx
  8002b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002b7:	89 0a                	mov    %ecx,(%rdx)
  8002b9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002bc:	89 d1                	mov    %edx,%ecx
  8002be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c2:	48 98                	cltq   
  8002c4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8002c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002cc:	8b 00                	mov    (%rax),%eax
  8002ce:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d3:	75 2c                	jne    800301 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d9:	8b 00                	mov    (%rax),%eax
  8002db:	48 98                	cltq   
  8002dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002e1:	48 83 c2 08          	add    $0x8,%rdx
  8002e5:	48 89 c6             	mov    %rax,%rsi
  8002e8:	48 89 d7             	mov    %rdx,%rdi
  8002eb:	48 b8 3f 17 80 00 00 	movabs $0x80173f,%rax
  8002f2:	00 00 00 
  8002f5:	ff d0                	callq  *%rax
        b->idx = 0;
  8002f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002fb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800301:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800305:	8b 40 04             	mov    0x4(%rax),%eax
  800308:	8d 50 01             	lea    0x1(%rax),%edx
  80030b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80030f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800312:	90                   	nop
  800313:	c9                   	leaveq 
  800314:	c3                   	retq   

0000000000800315 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800315:	55                   	push   %rbp
  800316:	48 89 e5             	mov    %rsp,%rbp
  800319:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800320:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800327:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80032e:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800335:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80033c:	48 8b 0a             	mov    (%rdx),%rcx
  80033f:	48 89 08             	mov    %rcx,(%rax)
  800342:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800346:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80034a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80034e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800352:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800359:	00 00 00 
    b.cnt = 0;
  80035c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800363:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800366:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80036d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800374:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80037b:	48 89 c6             	mov    %rax,%rsi
  80037e:	48 bf 9b 02 80 00 00 	movabs $0x80029b,%rdi
  800385:	00 00 00 
  800388:	48 b8 5f 07 80 00 00 	movabs $0x80075f,%rax
  80038f:	00 00 00 
  800392:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800394:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80039a:	48 98                	cltq   
  80039c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003a3:	48 83 c2 08          	add    $0x8,%rdx
  8003a7:	48 89 c6             	mov    %rax,%rsi
  8003aa:	48 89 d7             	mov    %rdx,%rdi
  8003ad:	48 b8 3f 17 80 00 00 	movabs $0x80173f,%rax
  8003b4:	00 00 00 
  8003b7:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8003b9:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003bf:	c9                   	leaveq 
  8003c0:	c3                   	retq   

00000000008003c1 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003c1:	55                   	push   %rbp
  8003c2:	48 89 e5             	mov    %rsp,%rbp
  8003c5:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003cc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8003d3:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003da:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003e1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003e8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003ef:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003f6:	84 c0                	test   %al,%al
  8003f8:	74 20                	je     80041a <cprintf+0x59>
  8003fa:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003fe:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800402:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800406:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80040a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80040e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800412:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800416:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80041a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800421:	00 00 00 
  800424:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80042b:	00 00 00 
  80042e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800432:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800439:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800440:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800447:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80044e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800455:	48 8b 0a             	mov    (%rdx),%rcx
  800458:	48 89 08             	mov    %rcx,(%rax)
  80045b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80045f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800463:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800467:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80046b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800472:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800479:	48 89 d6             	mov    %rdx,%rsi
  80047c:	48 89 c7             	mov    %rax,%rdi
  80047f:	48 b8 15 03 80 00 00 	movabs $0x800315,%rax
  800486:	00 00 00 
  800489:	ff d0                	callq  *%rax
  80048b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800491:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800497:	c9                   	leaveq 
  800498:	c3                   	retq   

0000000000800499 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800499:	55                   	push   %rbp
  80049a:	48 89 e5             	mov    %rsp,%rbp
  80049d:	48 83 ec 30          	sub    $0x30,%rsp
  8004a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004a9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004ad:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8004b0:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8004b4:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004b8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004bb:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8004bf:	77 54                	ja     800515 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004c1:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8004c4:	8d 78 ff             	lea    -0x1(%rax),%edi
  8004c7:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8004ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d3:	48 f7 f6             	div    %rsi
  8004d6:	49 89 c2             	mov    %rax,%r10
  8004d9:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8004dc:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8004df:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8004e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e7:	41 89 c9             	mov    %ecx,%r9d
  8004ea:	41 89 f8             	mov    %edi,%r8d
  8004ed:	89 d1                	mov    %edx,%ecx
  8004ef:	4c 89 d2             	mov    %r10,%rdx
  8004f2:	48 89 c7             	mov    %rax,%rdi
  8004f5:	48 b8 99 04 80 00 00 	movabs $0x800499,%rax
  8004fc:	00 00 00 
  8004ff:	ff d0                	callq  *%rax
  800501:	eb 1c                	jmp    80051f <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800503:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800507:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80050a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80050e:	48 89 ce             	mov    %rcx,%rsi
  800511:	89 d7                	mov    %edx,%edi
  800513:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800515:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800519:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80051d:	7f e4                	jg     800503 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80051f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800522:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800526:	ba 00 00 00 00       	mov    $0x0,%edx
  80052b:	48 f7 f1             	div    %rcx
  80052e:	48 b8 90 27 80 00 00 	movabs $0x802790,%rax
  800535:	00 00 00 
  800538:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80053c:	0f be d0             	movsbl %al,%edx
  80053f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800547:	48 89 ce             	mov    %rcx,%rsi
  80054a:	89 d7                	mov    %edx,%edi
  80054c:	ff d0                	callq  *%rax
}
  80054e:	90                   	nop
  80054f:	c9                   	leaveq 
  800550:	c3                   	retq   

0000000000800551 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800551:	55                   	push   %rbp
  800552:	48 89 e5             	mov    %rsp,%rbp
  800555:	48 83 ec 20          	sub    $0x20,%rsp
  800559:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80055d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800560:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800564:	7e 4f                	jle    8005b5 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800566:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056a:	8b 00                	mov    (%rax),%eax
  80056c:	83 f8 30             	cmp    $0x30,%eax
  80056f:	73 24                	jae    800595 <getuint+0x44>
  800571:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800575:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057d:	8b 00                	mov    (%rax),%eax
  80057f:	89 c0                	mov    %eax,%eax
  800581:	48 01 d0             	add    %rdx,%rax
  800584:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800588:	8b 12                	mov    (%rdx),%edx
  80058a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80058d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800591:	89 0a                	mov    %ecx,(%rdx)
  800593:	eb 14                	jmp    8005a9 <getuint+0x58>
  800595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800599:	48 8b 40 08          	mov    0x8(%rax),%rax
  80059d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005a9:	48 8b 00             	mov    (%rax),%rax
  8005ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005b0:	e9 9d 00 00 00       	jmpq   800652 <getuint+0x101>
	else if (lflag)
  8005b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005b9:	74 4c                	je     800607 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8005bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bf:	8b 00                	mov    (%rax),%eax
  8005c1:	83 f8 30             	cmp    $0x30,%eax
  8005c4:	73 24                	jae    8005ea <getuint+0x99>
  8005c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ca:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d2:	8b 00                	mov    (%rax),%eax
  8005d4:	89 c0                	mov    %eax,%eax
  8005d6:	48 01 d0             	add    %rdx,%rax
  8005d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005dd:	8b 12                	mov    (%rdx),%edx
  8005df:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e6:	89 0a                	mov    %ecx,(%rdx)
  8005e8:	eb 14                	jmp    8005fe <getuint+0xad>
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005f2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005fe:	48 8b 00             	mov    (%rax),%rax
  800601:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800605:	eb 4b                	jmp    800652 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060b:	8b 00                	mov    (%rax),%eax
  80060d:	83 f8 30             	cmp    $0x30,%eax
  800610:	73 24                	jae    800636 <getuint+0xe5>
  800612:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800616:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80061a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061e:	8b 00                	mov    (%rax),%eax
  800620:	89 c0                	mov    %eax,%eax
  800622:	48 01 d0             	add    %rdx,%rax
  800625:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800629:	8b 12                	mov    (%rdx),%edx
  80062b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80062e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800632:	89 0a                	mov    %ecx,(%rdx)
  800634:	eb 14                	jmp    80064a <getuint+0xf9>
  800636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80063e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800642:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800646:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80064a:	8b 00                	mov    (%rax),%eax
  80064c:	89 c0                	mov    %eax,%eax
  80064e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800652:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800656:	c9                   	leaveq 
  800657:	c3                   	retq   

0000000000800658 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800658:	55                   	push   %rbp
  800659:	48 89 e5             	mov    %rsp,%rbp
  80065c:	48 83 ec 20          	sub    $0x20,%rsp
  800660:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800664:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800667:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80066b:	7e 4f                	jle    8006bc <getint+0x64>
		x=va_arg(*ap, long long);
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	8b 00                	mov    (%rax),%eax
  800673:	83 f8 30             	cmp    $0x30,%eax
  800676:	73 24                	jae    80069c <getint+0x44>
  800678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800680:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800684:	8b 00                	mov    (%rax),%eax
  800686:	89 c0                	mov    %eax,%eax
  800688:	48 01 d0             	add    %rdx,%rax
  80068b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068f:	8b 12                	mov    (%rdx),%edx
  800691:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800694:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800698:	89 0a                	mov    %ecx,(%rdx)
  80069a:	eb 14                	jmp    8006b0 <getint+0x58>
  80069c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006a4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ac:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006b0:	48 8b 00             	mov    (%rax),%rax
  8006b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006b7:	e9 9d 00 00 00       	jmpq   800759 <getint+0x101>
	else if (lflag)
  8006bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006c0:	74 4c                	je     80070e <getint+0xb6>
		x=va_arg(*ap, long);
  8006c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c6:	8b 00                	mov    (%rax),%eax
  8006c8:	83 f8 30             	cmp    $0x30,%eax
  8006cb:	73 24                	jae    8006f1 <getint+0x99>
  8006cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d9:	8b 00                	mov    (%rax),%eax
  8006db:	89 c0                	mov    %eax,%eax
  8006dd:	48 01 d0             	add    %rdx,%rax
  8006e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e4:	8b 12                	mov    (%rdx),%edx
  8006e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ed:	89 0a                	mov    %ecx,(%rdx)
  8006ef:	eb 14                	jmp    800705 <getint+0xad>
  8006f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006f9:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800701:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800705:	48 8b 00             	mov    (%rax),%rax
  800708:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80070c:	eb 4b                	jmp    800759 <getint+0x101>
	else
		x=va_arg(*ap, int);
  80070e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800712:	8b 00                	mov    (%rax),%eax
  800714:	83 f8 30             	cmp    $0x30,%eax
  800717:	73 24                	jae    80073d <getint+0xe5>
  800719:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800721:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800725:	8b 00                	mov    (%rax),%eax
  800727:	89 c0                	mov    %eax,%eax
  800729:	48 01 d0             	add    %rdx,%rax
  80072c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800730:	8b 12                	mov    (%rdx),%edx
  800732:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800735:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800739:	89 0a                	mov    %ecx,(%rdx)
  80073b:	eb 14                	jmp    800751 <getint+0xf9>
  80073d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800741:	48 8b 40 08          	mov    0x8(%rax),%rax
  800745:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800749:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800751:	8b 00                	mov    (%rax),%eax
  800753:	48 98                	cltq   
  800755:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800759:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80075d:	c9                   	leaveq 
  80075e:	c3                   	retq   

000000000080075f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075f:	55                   	push   %rbp
  800760:	48 89 e5             	mov    %rsp,%rbp
  800763:	41 54                	push   %r12
  800765:	53                   	push   %rbx
  800766:	48 83 ec 60          	sub    $0x60,%rsp
  80076a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80076e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800772:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800776:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80077a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80077e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800782:	48 8b 0a             	mov    (%rdx),%rcx
  800785:	48 89 08             	mov    %rcx,(%rax)
  800788:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80078c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800790:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800794:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800798:	eb 17                	jmp    8007b1 <vprintfmt+0x52>
			if (ch == '\0')
  80079a:	85 db                	test   %ebx,%ebx
  80079c:	0f 84 b9 04 00 00    	je     800c5b <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  8007a2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007a6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007aa:	48 89 d6             	mov    %rdx,%rsi
  8007ad:	89 df                	mov    %ebx,%edi
  8007af:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007b5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007b9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007bd:	0f b6 00             	movzbl (%rax),%eax
  8007c0:	0f b6 d8             	movzbl %al,%ebx
  8007c3:	83 fb 25             	cmp    $0x25,%ebx
  8007c6:	75 d2                	jne    80079a <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007c8:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007cc:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007e1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007e8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007ec:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007f0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007f4:	0f b6 00             	movzbl (%rax),%eax
  8007f7:	0f b6 d8             	movzbl %al,%ebx
  8007fa:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8007fd:	83 f8 55             	cmp    $0x55,%eax
  800800:	0f 87 22 04 00 00    	ja     800c28 <vprintfmt+0x4c9>
  800806:	89 c0                	mov    %eax,%eax
  800808:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80080f:	00 
  800810:	48 b8 b8 27 80 00 00 	movabs $0x8027b8,%rax
  800817:	00 00 00 
  80081a:	48 01 d0             	add    %rdx,%rax
  80081d:	48 8b 00             	mov    (%rax),%rax
  800820:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800822:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800826:	eb c0                	jmp    8007e8 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800828:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80082c:	eb ba                	jmp    8007e8 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80082e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800835:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800838:	89 d0                	mov    %edx,%eax
  80083a:	c1 e0 02             	shl    $0x2,%eax
  80083d:	01 d0                	add    %edx,%eax
  80083f:	01 c0                	add    %eax,%eax
  800841:	01 d8                	add    %ebx,%eax
  800843:	83 e8 30             	sub    $0x30,%eax
  800846:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800849:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80084d:	0f b6 00             	movzbl (%rax),%eax
  800850:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800853:	83 fb 2f             	cmp    $0x2f,%ebx
  800856:	7e 60                	jle    8008b8 <vprintfmt+0x159>
  800858:	83 fb 39             	cmp    $0x39,%ebx
  80085b:	7f 5b                	jg     8008b8 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80085d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800862:	eb d1                	jmp    800835 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800864:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800867:	83 f8 30             	cmp    $0x30,%eax
  80086a:	73 17                	jae    800883 <vprintfmt+0x124>
  80086c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800870:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800873:	89 d2                	mov    %edx,%edx
  800875:	48 01 d0             	add    %rdx,%rax
  800878:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80087b:	83 c2 08             	add    $0x8,%edx
  80087e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800881:	eb 0c                	jmp    80088f <vprintfmt+0x130>
  800883:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800887:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80088b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80088f:	8b 00                	mov    (%rax),%eax
  800891:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800894:	eb 23                	jmp    8008b9 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800896:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80089a:	0f 89 48 ff ff ff    	jns    8007e8 <vprintfmt+0x89>
				width = 0;
  8008a0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008a7:	e9 3c ff ff ff       	jmpq   8007e8 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8008ac:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008b3:	e9 30 ff ff ff       	jmpq   8007e8 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008b8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008b9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008bd:	0f 89 25 ff ff ff    	jns    8007e8 <vprintfmt+0x89>
				width = precision, precision = -1;
  8008c3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008c6:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008c9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008d0:	e9 13 ff ff ff       	jmpq   8007e8 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008d5:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008d9:	e9 0a ff ff ff       	jmpq   8007e8 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8008de:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e1:	83 f8 30             	cmp    $0x30,%eax
  8008e4:	73 17                	jae    8008fd <vprintfmt+0x19e>
  8008e6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8008ea:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008ed:	89 d2                	mov    %edx,%edx
  8008ef:	48 01 d0             	add    %rdx,%rax
  8008f2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008f5:	83 c2 08             	add    $0x8,%edx
  8008f8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008fb:	eb 0c                	jmp    800909 <vprintfmt+0x1aa>
  8008fd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800901:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800905:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800909:	8b 10                	mov    (%rax),%edx
  80090b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80090f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800913:	48 89 ce             	mov    %rcx,%rsi
  800916:	89 d7                	mov    %edx,%edi
  800918:	ff d0                	callq  *%rax
			break;
  80091a:	e9 37 03 00 00       	jmpq   800c56 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80091f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800922:	83 f8 30             	cmp    $0x30,%eax
  800925:	73 17                	jae    80093e <vprintfmt+0x1df>
  800927:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80092b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80092e:	89 d2                	mov    %edx,%edx
  800930:	48 01 d0             	add    %rdx,%rax
  800933:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800936:	83 c2 08             	add    $0x8,%edx
  800939:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80093c:	eb 0c                	jmp    80094a <vprintfmt+0x1eb>
  80093e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800942:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800946:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80094a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80094c:	85 db                	test   %ebx,%ebx
  80094e:	79 02                	jns    800952 <vprintfmt+0x1f3>
				err = -err;
  800950:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800952:	83 fb 15             	cmp    $0x15,%ebx
  800955:	7f 16                	jg     80096d <vprintfmt+0x20e>
  800957:	48 b8 e0 26 80 00 00 	movabs $0x8026e0,%rax
  80095e:	00 00 00 
  800961:	48 63 d3             	movslq %ebx,%rdx
  800964:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800968:	4d 85 e4             	test   %r12,%r12
  80096b:	75 2e                	jne    80099b <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  80096d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800971:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800975:	89 d9                	mov    %ebx,%ecx
  800977:	48 ba a1 27 80 00 00 	movabs $0x8027a1,%rdx
  80097e:	00 00 00 
  800981:	48 89 c7             	mov    %rax,%rdi
  800984:	b8 00 00 00 00       	mov    $0x0,%eax
  800989:	49 b8 65 0c 80 00 00 	movabs $0x800c65,%r8
  800990:	00 00 00 
  800993:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800996:	e9 bb 02 00 00       	jmpq   800c56 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80099b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80099f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a3:	4c 89 e1             	mov    %r12,%rcx
  8009a6:	48 ba aa 27 80 00 00 	movabs $0x8027aa,%rdx
  8009ad:	00 00 00 
  8009b0:	48 89 c7             	mov    %rax,%rdi
  8009b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b8:	49 b8 65 0c 80 00 00 	movabs $0x800c65,%r8
  8009bf:	00 00 00 
  8009c2:	41 ff d0             	callq  *%r8
			break;
  8009c5:	e9 8c 02 00 00       	jmpq   800c56 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009ca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cd:	83 f8 30             	cmp    $0x30,%eax
  8009d0:	73 17                	jae    8009e9 <vprintfmt+0x28a>
  8009d2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009d6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d9:	89 d2                	mov    %edx,%edx
  8009db:	48 01 d0             	add    %rdx,%rax
  8009de:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009e1:	83 c2 08             	add    $0x8,%edx
  8009e4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009e7:	eb 0c                	jmp    8009f5 <vprintfmt+0x296>
  8009e9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009ed:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009f1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009f5:	4c 8b 20             	mov    (%rax),%r12
  8009f8:	4d 85 e4             	test   %r12,%r12
  8009fb:	75 0a                	jne    800a07 <vprintfmt+0x2a8>
				p = "(null)";
  8009fd:	49 bc ad 27 80 00 00 	movabs $0x8027ad,%r12
  800a04:	00 00 00 
			if (width > 0 && padc != '-')
  800a07:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a0b:	7e 78                	jle    800a85 <vprintfmt+0x326>
  800a0d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a11:	74 72                	je     800a85 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a13:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a16:	48 98                	cltq   
  800a18:	48 89 c6             	mov    %rax,%rsi
  800a1b:	4c 89 e7             	mov    %r12,%rdi
  800a1e:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  800a25:	00 00 00 
  800a28:	ff d0                	callq  *%rax
  800a2a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a2d:	eb 17                	jmp    800a46 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800a2f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a33:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a3b:	48 89 ce             	mov    %rcx,%rsi
  800a3e:	89 d7                	mov    %edx,%edi
  800a40:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a42:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a46:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a4a:	7f e3                	jg     800a2f <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a4c:	eb 37                	jmp    800a85 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800a4e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a52:	74 1e                	je     800a72 <vprintfmt+0x313>
  800a54:	83 fb 1f             	cmp    $0x1f,%ebx
  800a57:	7e 05                	jle    800a5e <vprintfmt+0x2ff>
  800a59:	83 fb 7e             	cmp    $0x7e,%ebx
  800a5c:	7e 14                	jle    800a72 <vprintfmt+0x313>
					putch('?', putdat);
  800a5e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a66:	48 89 d6             	mov    %rdx,%rsi
  800a69:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a6e:	ff d0                	callq  *%rax
  800a70:	eb 0f                	jmp    800a81 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800a72:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a7a:	48 89 d6             	mov    %rdx,%rsi
  800a7d:	89 df                	mov    %ebx,%edi
  800a7f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a81:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a85:	4c 89 e0             	mov    %r12,%rax
  800a88:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a8c:	0f b6 00             	movzbl (%rax),%eax
  800a8f:	0f be d8             	movsbl %al,%ebx
  800a92:	85 db                	test   %ebx,%ebx
  800a94:	74 28                	je     800abe <vprintfmt+0x35f>
  800a96:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a9a:	78 b2                	js     800a4e <vprintfmt+0x2ef>
  800a9c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800aa0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800aa4:	79 a8                	jns    800a4e <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa6:	eb 16                	jmp    800abe <vprintfmt+0x35f>
				putch(' ', putdat);
  800aa8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab0:	48 89 d6             	mov    %rdx,%rsi
  800ab3:	bf 20 00 00 00       	mov    $0x20,%edi
  800ab8:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aba:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800abe:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ac2:	7f e4                	jg     800aa8 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800ac4:	e9 8d 01 00 00       	jmpq   800c56 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ac9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800acd:	be 03 00 00 00       	mov    $0x3,%esi
  800ad2:	48 89 c7             	mov    %rax,%rdi
  800ad5:	48 b8 58 06 80 00 00 	movabs $0x800658,%rax
  800adc:	00 00 00 
  800adf:	ff d0                	callq  *%rax
  800ae1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ae5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae9:	48 85 c0             	test   %rax,%rax
  800aec:	79 1d                	jns    800b0b <vprintfmt+0x3ac>
				putch('-', putdat);
  800aee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af6:	48 89 d6             	mov    %rdx,%rsi
  800af9:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800afe:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b04:	48 f7 d8             	neg    %rax
  800b07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b0b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b12:	e9 d2 00 00 00       	jmpq   800be9 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b17:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b1b:	be 03 00 00 00       	mov    $0x3,%esi
  800b20:	48 89 c7             	mov    %rax,%rdi
  800b23:	48 b8 51 05 80 00 00 	movabs $0x800551,%rax
  800b2a:	00 00 00 
  800b2d:	ff d0                	callq  *%rax
  800b2f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b33:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b3a:	e9 aa 00 00 00       	jmpq   800be9 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800b3f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b43:	be 03 00 00 00       	mov    $0x3,%esi
  800b48:	48 89 c7             	mov    %rax,%rdi
  800b4b:	48 b8 51 05 80 00 00 	movabs $0x800551,%rax
  800b52:	00 00 00 
  800b55:	ff d0                	callq  *%rax
  800b57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800b5b:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b62:	e9 82 00 00 00       	jmpq   800be9 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800b67:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6f:	48 89 d6             	mov    %rdx,%rsi
  800b72:	bf 30 00 00 00       	mov    $0x30,%edi
  800b77:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b79:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b81:	48 89 d6             	mov    %rdx,%rsi
  800b84:	bf 78 00 00 00       	mov    $0x78,%edi
  800b89:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b8b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8e:	83 f8 30             	cmp    $0x30,%eax
  800b91:	73 17                	jae    800baa <vprintfmt+0x44b>
  800b93:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b97:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b9a:	89 d2                	mov    %edx,%edx
  800b9c:	48 01 d0             	add    %rdx,%rax
  800b9f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ba2:	83 c2 08             	add    $0x8,%edx
  800ba5:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ba8:	eb 0c                	jmp    800bb6 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800baa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800bae:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800bb2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bb6:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bbd:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bc4:	eb 23                	jmp    800be9 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bc6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bca:	be 03 00 00 00       	mov    $0x3,%esi
  800bcf:	48 89 c7             	mov    %rax,%rdi
  800bd2:	48 b8 51 05 80 00 00 	movabs $0x800551,%rax
  800bd9:	00 00 00 
  800bdc:	ff d0                	callq  *%rax
  800bde:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800be2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be9:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800bee:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800bf1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800bf4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bf8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c00:	45 89 c1             	mov    %r8d,%r9d
  800c03:	41 89 f8             	mov    %edi,%r8d
  800c06:	48 89 c7             	mov    %rax,%rdi
  800c09:	48 b8 99 04 80 00 00 	movabs $0x800499,%rax
  800c10:	00 00 00 
  800c13:	ff d0                	callq  *%rax
			break;
  800c15:	eb 3f                	jmp    800c56 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c17:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1f:	48 89 d6             	mov    %rdx,%rsi
  800c22:	89 df                	mov    %ebx,%edi
  800c24:	ff d0                	callq  *%rax
			break;
  800c26:	eb 2e                	jmp    800c56 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c28:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c30:	48 89 d6             	mov    %rdx,%rsi
  800c33:	bf 25 00 00 00       	mov    $0x25,%edi
  800c38:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c3a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c3f:	eb 05                	jmp    800c46 <vprintfmt+0x4e7>
  800c41:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c46:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c4a:	48 83 e8 01          	sub    $0x1,%rax
  800c4e:	0f b6 00             	movzbl (%rax),%eax
  800c51:	3c 25                	cmp    $0x25,%al
  800c53:	75 ec                	jne    800c41 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800c55:	90                   	nop
		}
	}
  800c56:	e9 3d fb ff ff       	jmpq   800798 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c5b:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c5c:	48 83 c4 60          	add    $0x60,%rsp
  800c60:	5b                   	pop    %rbx
  800c61:	41 5c                	pop    %r12
  800c63:	5d                   	pop    %rbp
  800c64:	c3                   	retq   

0000000000800c65 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c65:	55                   	push   %rbp
  800c66:	48 89 e5             	mov    %rsp,%rbp
  800c69:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c70:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c77:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c7e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800c85:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c8c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c93:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c9a:	84 c0                	test   %al,%al
  800c9c:	74 20                	je     800cbe <printfmt+0x59>
  800c9e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ca2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ca6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800caa:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cae:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cb2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cb6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800cba:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cbe:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cc5:	00 00 00 
  800cc8:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ccf:	00 00 00 
  800cd2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cd6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800cdd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ce4:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ceb:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800cf2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800cf9:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d00:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d07:	48 89 c7             	mov    %rax,%rdi
  800d0a:	48 b8 5f 07 80 00 00 	movabs $0x80075f,%rax
  800d11:	00 00 00 
  800d14:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d16:	90                   	nop
  800d17:	c9                   	leaveq 
  800d18:	c3                   	retq   

0000000000800d19 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d19:	55                   	push   %rbp
  800d1a:	48 89 e5             	mov    %rsp,%rbp
  800d1d:	48 83 ec 10          	sub    $0x10,%rsp
  800d21:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d24:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d2c:	8b 40 10             	mov    0x10(%rax),%eax
  800d2f:	8d 50 01             	lea    0x1(%rax),%edx
  800d32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d36:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d3d:	48 8b 10             	mov    (%rax),%rdx
  800d40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d44:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d48:	48 39 c2             	cmp    %rax,%rdx
  800d4b:	73 17                	jae    800d64 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d51:	48 8b 00             	mov    (%rax),%rax
  800d54:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d58:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d5c:	48 89 0a             	mov    %rcx,(%rdx)
  800d5f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d62:	88 10                	mov    %dl,(%rax)
}
  800d64:	90                   	nop
  800d65:	c9                   	leaveq 
  800d66:	c3                   	retq   

0000000000800d67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d67:	55                   	push   %rbp
  800d68:	48 89 e5             	mov    %rsp,%rbp
  800d6b:	48 83 ec 50          	sub    $0x50,%rsp
  800d6f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d73:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d76:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d7a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d7e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d82:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d86:	48 8b 0a             	mov    (%rdx),%rcx
  800d89:	48 89 08             	mov    %rcx,(%rax)
  800d8c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d90:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d94:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d98:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d9c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800da0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800da4:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800da7:	48 98                	cltq   
  800da9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800dad:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800db1:	48 01 d0             	add    %rdx,%rax
  800db4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800db8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800dbf:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800dc4:	74 06                	je     800dcc <vsnprintf+0x65>
  800dc6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800dca:	7f 07                	jg     800dd3 <vsnprintf+0x6c>
		return -E_INVAL;
  800dcc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dd1:	eb 2f                	jmp    800e02 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800dd3:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800dd7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ddb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ddf:	48 89 c6             	mov    %rax,%rsi
  800de2:	48 bf 19 0d 80 00 00 	movabs $0x800d19,%rdi
  800de9:	00 00 00 
  800dec:	48 b8 5f 07 80 00 00 	movabs $0x80075f,%rax
  800df3:	00 00 00 
  800df6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800df8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800dfc:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800dff:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e02:	c9                   	leaveq 
  800e03:	c3                   	retq   

0000000000800e04 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e04:	55                   	push   %rbp
  800e05:	48 89 e5             	mov    %rsp,%rbp
  800e08:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e0f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e16:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e1c:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800e23:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e2a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e31:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e38:	84 c0                	test   %al,%al
  800e3a:	74 20                	je     800e5c <snprintf+0x58>
  800e3c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e40:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e44:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e48:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e4c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e50:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e54:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e58:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e5c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e63:	00 00 00 
  800e66:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e6d:	00 00 00 
  800e70:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e74:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e7b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e82:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e89:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e90:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e97:	48 8b 0a             	mov    (%rdx),%rcx
  800e9a:	48 89 08             	mov    %rcx,(%rax)
  800e9d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ea1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ea5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ea9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ead:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800eb4:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ebb:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800ec1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ec8:	48 89 c7             	mov    %rax,%rdi
  800ecb:	48 b8 67 0d 80 00 00 	movabs $0x800d67,%rax
  800ed2:	00 00 00 
  800ed5:	ff d0                	callq  *%rax
  800ed7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800edd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ee3:	c9                   	leaveq 
  800ee4:	c3                   	retq   

0000000000800ee5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ee5:	55                   	push   %rbp
  800ee6:	48 89 e5             	mov    %rsp,%rbp
  800ee9:	48 83 ec 18          	sub    $0x18,%rsp
  800eed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ef1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ef8:	eb 09                	jmp    800f03 <strlen+0x1e>
		n++;
  800efa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800efe:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f07:	0f b6 00             	movzbl (%rax),%eax
  800f0a:	84 c0                	test   %al,%al
  800f0c:	75 ec                	jne    800efa <strlen+0x15>
		n++;
	return n;
  800f0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f11:	c9                   	leaveq 
  800f12:	c3                   	retq   

0000000000800f13 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f13:	55                   	push   %rbp
  800f14:	48 89 e5             	mov    %rsp,%rbp
  800f17:	48 83 ec 20          	sub    $0x20,%rsp
  800f1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f1f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f2a:	eb 0e                	jmp    800f3a <strnlen+0x27>
		n++;
  800f2c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f30:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f35:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f3a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f3f:	74 0b                	je     800f4c <strnlen+0x39>
  800f41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f45:	0f b6 00             	movzbl (%rax),%eax
  800f48:	84 c0                	test   %al,%al
  800f4a:	75 e0                	jne    800f2c <strnlen+0x19>
		n++;
	return n;
  800f4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f4f:	c9                   	leaveq 
  800f50:	c3                   	retq   

0000000000800f51 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f51:	55                   	push   %rbp
  800f52:	48 89 e5             	mov    %rsp,%rbp
  800f55:	48 83 ec 20          	sub    $0x20,%rsp
  800f59:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f5d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f65:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f69:	90                   	nop
  800f6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f72:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f76:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f7a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f7e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f82:	0f b6 12             	movzbl (%rdx),%edx
  800f85:	88 10                	mov    %dl,(%rax)
  800f87:	0f b6 00             	movzbl (%rax),%eax
  800f8a:	84 c0                	test   %al,%al
  800f8c:	75 dc                	jne    800f6a <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f92:	c9                   	leaveq 
  800f93:	c3                   	retq   

0000000000800f94 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f94:	55                   	push   %rbp
  800f95:	48 89 e5             	mov    %rsp,%rbp
  800f98:	48 83 ec 20          	sub    $0x20,%rsp
  800f9c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fa0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa8:	48 89 c7             	mov    %rax,%rdi
  800fab:	48 b8 e5 0e 80 00 00 	movabs $0x800ee5,%rax
  800fb2:	00 00 00 
  800fb5:	ff d0                	callq  *%rax
  800fb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fbd:	48 63 d0             	movslq %eax,%rdx
  800fc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc4:	48 01 c2             	add    %rax,%rdx
  800fc7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fcb:	48 89 c6             	mov    %rax,%rsi
  800fce:	48 89 d7             	mov    %rdx,%rdi
  800fd1:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  800fd8:	00 00 00 
  800fdb:	ff d0                	callq  *%rax
	return dst;
  800fdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800fe1:	c9                   	leaveq 
  800fe2:	c3                   	retq   

0000000000800fe3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fe3:	55                   	push   %rbp
  800fe4:	48 89 e5             	mov    %rsp,%rbp
  800fe7:	48 83 ec 28          	sub    $0x28,%rsp
  800feb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ff3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ff7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ffb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800fff:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801006:	00 
  801007:	eb 2a                	jmp    801033 <strncpy+0x50>
		*dst++ = *src;
  801009:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801011:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801015:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801019:	0f b6 12             	movzbl (%rdx),%edx
  80101c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80101e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801022:	0f b6 00             	movzbl (%rax),%eax
  801025:	84 c0                	test   %al,%al
  801027:	74 05                	je     80102e <strncpy+0x4b>
			src++;
  801029:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80102e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801033:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801037:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80103b:	72 cc                	jb     801009 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80103d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801041:	c9                   	leaveq 
  801042:	c3                   	retq   

0000000000801043 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801043:	55                   	push   %rbp
  801044:	48 89 e5             	mov    %rsp,%rbp
  801047:	48 83 ec 28          	sub    $0x28,%rsp
  80104b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80104f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801053:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801057:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80105f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801064:	74 3d                	je     8010a3 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801066:	eb 1d                	jmp    801085 <strlcpy+0x42>
			*dst++ = *src++;
  801068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801070:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801074:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801078:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80107c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801080:	0f b6 12             	movzbl (%rdx),%edx
  801083:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801085:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80108a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80108f:	74 0b                	je     80109c <strlcpy+0x59>
  801091:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801095:	0f b6 00             	movzbl (%rax),%eax
  801098:	84 c0                	test   %al,%al
  80109a:	75 cc                	jne    801068 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80109c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a0:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ab:	48 29 c2             	sub    %rax,%rdx
  8010ae:	48 89 d0             	mov    %rdx,%rax
}
  8010b1:	c9                   	leaveq 
  8010b2:	c3                   	retq   

00000000008010b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010b3:	55                   	push   %rbp
  8010b4:	48 89 e5             	mov    %rsp,%rbp
  8010b7:	48 83 ec 10          	sub    $0x10,%rsp
  8010bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010c3:	eb 0a                	jmp    8010cf <strcmp+0x1c>
		p++, q++;
  8010c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010ca:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d3:	0f b6 00             	movzbl (%rax),%eax
  8010d6:	84 c0                	test   %al,%al
  8010d8:	74 12                	je     8010ec <strcmp+0x39>
  8010da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010de:	0f b6 10             	movzbl (%rax),%edx
  8010e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e5:	0f b6 00             	movzbl (%rax),%eax
  8010e8:	38 c2                	cmp    %al,%dl
  8010ea:	74 d9                	je     8010c5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f0:	0f b6 00             	movzbl (%rax),%eax
  8010f3:	0f b6 d0             	movzbl %al,%edx
  8010f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fa:	0f b6 00             	movzbl (%rax),%eax
  8010fd:	0f b6 c0             	movzbl %al,%eax
  801100:	29 c2                	sub    %eax,%edx
  801102:	89 d0                	mov    %edx,%eax
}
  801104:	c9                   	leaveq 
  801105:	c3                   	retq   

0000000000801106 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801106:	55                   	push   %rbp
  801107:	48 89 e5             	mov    %rsp,%rbp
  80110a:	48 83 ec 18          	sub    $0x18,%rsp
  80110e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801112:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801116:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80111a:	eb 0f                	jmp    80112b <strncmp+0x25>
		n--, p++, q++;
  80111c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801121:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801126:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80112b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801130:	74 1d                	je     80114f <strncmp+0x49>
  801132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801136:	0f b6 00             	movzbl (%rax),%eax
  801139:	84 c0                	test   %al,%al
  80113b:	74 12                	je     80114f <strncmp+0x49>
  80113d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801141:	0f b6 10             	movzbl (%rax),%edx
  801144:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801148:	0f b6 00             	movzbl (%rax),%eax
  80114b:	38 c2                	cmp    %al,%dl
  80114d:	74 cd                	je     80111c <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80114f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801154:	75 07                	jne    80115d <strncmp+0x57>
		return 0;
  801156:	b8 00 00 00 00       	mov    $0x0,%eax
  80115b:	eb 18                	jmp    801175 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80115d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801161:	0f b6 00             	movzbl (%rax),%eax
  801164:	0f b6 d0             	movzbl %al,%edx
  801167:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80116b:	0f b6 00             	movzbl (%rax),%eax
  80116e:	0f b6 c0             	movzbl %al,%eax
  801171:	29 c2                	sub    %eax,%edx
  801173:	89 d0                	mov    %edx,%eax
}
  801175:	c9                   	leaveq 
  801176:	c3                   	retq   

0000000000801177 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801177:	55                   	push   %rbp
  801178:	48 89 e5             	mov    %rsp,%rbp
  80117b:	48 83 ec 10          	sub    $0x10,%rsp
  80117f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801183:	89 f0                	mov    %esi,%eax
  801185:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801188:	eb 17                	jmp    8011a1 <strchr+0x2a>
		if (*s == c)
  80118a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118e:	0f b6 00             	movzbl (%rax),%eax
  801191:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801194:	75 06                	jne    80119c <strchr+0x25>
			return (char *) s;
  801196:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119a:	eb 15                	jmp    8011b1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80119c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a5:	0f b6 00             	movzbl (%rax),%eax
  8011a8:	84 c0                	test   %al,%al
  8011aa:	75 de                	jne    80118a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b1:	c9                   	leaveq 
  8011b2:	c3                   	retq   

00000000008011b3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011b3:	55                   	push   %rbp
  8011b4:	48 89 e5             	mov    %rsp,%rbp
  8011b7:	48 83 ec 10          	sub    $0x10,%rsp
  8011bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011bf:	89 f0                	mov    %esi,%eax
  8011c1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011c4:	eb 11                	jmp    8011d7 <strfind+0x24>
		if (*s == c)
  8011c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ca:	0f b6 00             	movzbl (%rax),%eax
  8011cd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011d0:	74 12                	je     8011e4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011d2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011db:	0f b6 00             	movzbl (%rax),%eax
  8011de:	84 c0                	test   %al,%al
  8011e0:	75 e4                	jne    8011c6 <strfind+0x13>
  8011e2:	eb 01                	jmp    8011e5 <strfind+0x32>
		if (*s == c)
			break;
  8011e4:	90                   	nop
	return (char *) s;
  8011e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011e9:	c9                   	leaveq 
  8011ea:	c3                   	retq   

00000000008011eb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8011eb:	55                   	push   %rbp
  8011ec:	48 89 e5             	mov    %rsp,%rbp
  8011ef:	48 83 ec 18          	sub    $0x18,%rsp
  8011f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011f7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8011fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8011fe:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801203:	75 06                	jne    80120b <memset+0x20>
		return v;
  801205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801209:	eb 69                	jmp    801274 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80120b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120f:	83 e0 03             	and    $0x3,%eax
  801212:	48 85 c0             	test   %rax,%rax
  801215:	75 48                	jne    80125f <memset+0x74>
  801217:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121b:	83 e0 03             	and    $0x3,%eax
  80121e:	48 85 c0             	test   %rax,%rax
  801221:	75 3c                	jne    80125f <memset+0x74>
		c &= 0xFF;
  801223:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80122a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80122d:	c1 e0 18             	shl    $0x18,%eax
  801230:	89 c2                	mov    %eax,%edx
  801232:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801235:	c1 e0 10             	shl    $0x10,%eax
  801238:	09 c2                	or     %eax,%edx
  80123a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80123d:	c1 e0 08             	shl    $0x8,%eax
  801240:	09 d0                	or     %edx,%eax
  801242:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801245:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801249:	48 c1 e8 02          	shr    $0x2,%rax
  80124d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801250:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801254:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801257:	48 89 d7             	mov    %rdx,%rdi
  80125a:	fc                   	cld    
  80125b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80125d:	eb 11                	jmp    801270 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80125f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801263:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801266:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80126a:	48 89 d7             	mov    %rdx,%rdi
  80126d:	fc                   	cld    
  80126e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801270:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801274:	c9                   	leaveq 
  801275:	c3                   	retq   

0000000000801276 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801276:	55                   	push   %rbp
  801277:	48 89 e5             	mov    %rsp,%rbp
  80127a:	48 83 ec 28          	sub    $0x28,%rsp
  80127e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801282:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801286:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80128a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80128e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801292:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801296:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80129a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012a2:	0f 83 88 00 00 00    	jae    801330 <memmove+0xba>
  8012a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b0:	48 01 d0             	add    %rdx,%rax
  8012b3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012b7:	76 77                	jbe    801330 <memmove+0xba>
		s += n;
  8012b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012bd:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cd:	83 e0 03             	and    $0x3,%eax
  8012d0:	48 85 c0             	test   %rax,%rax
  8012d3:	75 3b                	jne    801310 <memmove+0x9a>
  8012d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d9:	83 e0 03             	and    $0x3,%eax
  8012dc:	48 85 c0             	test   %rax,%rax
  8012df:	75 2f                	jne    801310 <memmove+0x9a>
  8012e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e5:	83 e0 03             	and    $0x3,%eax
  8012e8:	48 85 c0             	test   %rax,%rax
  8012eb:	75 23                	jne    801310 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f1:	48 83 e8 04          	sub    $0x4,%rax
  8012f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f9:	48 83 ea 04          	sub    $0x4,%rdx
  8012fd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801301:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801305:	48 89 c7             	mov    %rax,%rdi
  801308:	48 89 d6             	mov    %rdx,%rsi
  80130b:	fd                   	std    
  80130c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80130e:	eb 1d                	jmp    80132d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801310:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801314:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801320:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801324:	48 89 d7             	mov    %rdx,%rdi
  801327:	48 89 c1             	mov    %rax,%rcx
  80132a:	fd                   	std    
  80132b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80132d:	fc                   	cld    
  80132e:	eb 57                	jmp    801387 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801330:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801334:	83 e0 03             	and    $0x3,%eax
  801337:	48 85 c0             	test   %rax,%rax
  80133a:	75 36                	jne    801372 <memmove+0xfc>
  80133c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801340:	83 e0 03             	and    $0x3,%eax
  801343:	48 85 c0             	test   %rax,%rax
  801346:	75 2a                	jne    801372 <memmove+0xfc>
  801348:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80134c:	83 e0 03             	and    $0x3,%eax
  80134f:	48 85 c0             	test   %rax,%rax
  801352:	75 1e                	jne    801372 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801354:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801358:	48 c1 e8 02          	shr    $0x2,%rax
  80135c:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80135f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801363:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801367:	48 89 c7             	mov    %rax,%rdi
  80136a:	48 89 d6             	mov    %rdx,%rsi
  80136d:	fc                   	cld    
  80136e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801370:	eb 15                	jmp    801387 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801372:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801376:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80137a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80137e:	48 89 c7             	mov    %rax,%rdi
  801381:	48 89 d6             	mov    %rdx,%rsi
  801384:	fc                   	cld    
  801385:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801387:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80138b:	c9                   	leaveq 
  80138c:	c3                   	retq   

000000000080138d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80138d:	55                   	push   %rbp
  80138e:	48 89 e5             	mov    %rsp,%rbp
  801391:	48 83 ec 18          	sub    $0x18,%rsp
  801395:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801399:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80139d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013a5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ad:	48 89 ce             	mov    %rcx,%rsi
  8013b0:	48 89 c7             	mov    %rax,%rdi
  8013b3:	48 b8 76 12 80 00 00 	movabs $0x801276,%rax
  8013ba:	00 00 00 
  8013bd:	ff d0                	callq  *%rax
}
  8013bf:	c9                   	leaveq 
  8013c0:	c3                   	retq   

00000000008013c1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013c1:	55                   	push   %rbp
  8013c2:	48 89 e5             	mov    %rsp,%rbp
  8013c5:	48 83 ec 28          	sub    $0x28,%rsp
  8013c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8013d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8013dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8013e5:	eb 36                	jmp    80141d <memcmp+0x5c>
		if (*s1 != *s2)
  8013e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013eb:	0f b6 10             	movzbl (%rax),%edx
  8013ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f2:	0f b6 00             	movzbl (%rax),%eax
  8013f5:	38 c2                	cmp    %al,%dl
  8013f7:	74 1a                	je     801413 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8013f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fd:	0f b6 00             	movzbl (%rax),%eax
  801400:	0f b6 d0             	movzbl %al,%edx
  801403:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801407:	0f b6 00             	movzbl (%rax),%eax
  80140a:	0f b6 c0             	movzbl %al,%eax
  80140d:	29 c2                	sub    %eax,%edx
  80140f:	89 d0                	mov    %edx,%eax
  801411:	eb 20                	jmp    801433 <memcmp+0x72>
		s1++, s2++;
  801413:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801418:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80141d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801421:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801425:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801429:	48 85 c0             	test   %rax,%rax
  80142c:	75 b9                	jne    8013e7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80142e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801433:	c9                   	leaveq 
  801434:	c3                   	retq   

0000000000801435 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801435:	55                   	push   %rbp
  801436:	48 89 e5             	mov    %rsp,%rbp
  801439:	48 83 ec 28          	sub    $0x28,%rsp
  80143d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801441:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801444:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801448:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80144c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801450:	48 01 d0             	add    %rdx,%rax
  801453:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801457:	eb 19                	jmp    801472 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801459:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80145d:	0f b6 00             	movzbl (%rax),%eax
  801460:	0f b6 d0             	movzbl %al,%edx
  801463:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801466:	0f b6 c0             	movzbl %al,%eax
  801469:	39 c2                	cmp    %eax,%edx
  80146b:	74 11                	je     80147e <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80146d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801476:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80147a:	72 dd                	jb     801459 <memfind+0x24>
  80147c:	eb 01                	jmp    80147f <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80147e:	90                   	nop
	return (void *) s;
  80147f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801483:	c9                   	leaveq 
  801484:	c3                   	retq   

0000000000801485 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801485:	55                   	push   %rbp
  801486:	48 89 e5             	mov    %rsp,%rbp
  801489:	48 83 ec 38          	sub    $0x38,%rsp
  80148d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801491:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801495:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801498:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80149f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014a6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014a7:	eb 05                	jmp    8014ae <strtol+0x29>
		s++;
  8014a9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b2:	0f b6 00             	movzbl (%rax),%eax
  8014b5:	3c 20                	cmp    $0x20,%al
  8014b7:	74 f0                	je     8014a9 <strtol+0x24>
  8014b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014bd:	0f b6 00             	movzbl (%rax),%eax
  8014c0:	3c 09                	cmp    $0x9,%al
  8014c2:	74 e5                	je     8014a9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c8:	0f b6 00             	movzbl (%rax),%eax
  8014cb:	3c 2b                	cmp    $0x2b,%al
  8014cd:	75 07                	jne    8014d6 <strtol+0x51>
		s++;
  8014cf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014d4:	eb 17                	jmp    8014ed <strtol+0x68>
	else if (*s == '-')
  8014d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014da:	0f b6 00             	movzbl (%rax),%eax
  8014dd:	3c 2d                	cmp    $0x2d,%al
  8014df:	75 0c                	jne    8014ed <strtol+0x68>
		s++, neg = 1;
  8014e1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014ed:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014f1:	74 06                	je     8014f9 <strtol+0x74>
  8014f3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8014f7:	75 28                	jne    801521 <strtol+0x9c>
  8014f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fd:	0f b6 00             	movzbl (%rax),%eax
  801500:	3c 30                	cmp    $0x30,%al
  801502:	75 1d                	jne    801521 <strtol+0x9c>
  801504:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801508:	48 83 c0 01          	add    $0x1,%rax
  80150c:	0f b6 00             	movzbl (%rax),%eax
  80150f:	3c 78                	cmp    $0x78,%al
  801511:	75 0e                	jne    801521 <strtol+0x9c>
		s += 2, base = 16;
  801513:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801518:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80151f:	eb 2c                	jmp    80154d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801521:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801525:	75 19                	jne    801540 <strtol+0xbb>
  801527:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152b:	0f b6 00             	movzbl (%rax),%eax
  80152e:	3c 30                	cmp    $0x30,%al
  801530:	75 0e                	jne    801540 <strtol+0xbb>
		s++, base = 8;
  801532:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801537:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80153e:	eb 0d                	jmp    80154d <strtol+0xc8>
	else if (base == 0)
  801540:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801544:	75 07                	jne    80154d <strtol+0xc8>
		base = 10;
  801546:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80154d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801551:	0f b6 00             	movzbl (%rax),%eax
  801554:	3c 2f                	cmp    $0x2f,%al
  801556:	7e 1d                	jle    801575 <strtol+0xf0>
  801558:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155c:	0f b6 00             	movzbl (%rax),%eax
  80155f:	3c 39                	cmp    $0x39,%al
  801561:	7f 12                	jg     801575 <strtol+0xf0>
			dig = *s - '0';
  801563:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801567:	0f b6 00             	movzbl (%rax),%eax
  80156a:	0f be c0             	movsbl %al,%eax
  80156d:	83 e8 30             	sub    $0x30,%eax
  801570:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801573:	eb 4e                	jmp    8015c3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801579:	0f b6 00             	movzbl (%rax),%eax
  80157c:	3c 60                	cmp    $0x60,%al
  80157e:	7e 1d                	jle    80159d <strtol+0x118>
  801580:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801584:	0f b6 00             	movzbl (%rax),%eax
  801587:	3c 7a                	cmp    $0x7a,%al
  801589:	7f 12                	jg     80159d <strtol+0x118>
			dig = *s - 'a' + 10;
  80158b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158f:	0f b6 00             	movzbl (%rax),%eax
  801592:	0f be c0             	movsbl %al,%eax
  801595:	83 e8 57             	sub    $0x57,%eax
  801598:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80159b:	eb 26                	jmp    8015c3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80159d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a1:	0f b6 00             	movzbl (%rax),%eax
  8015a4:	3c 40                	cmp    $0x40,%al
  8015a6:	7e 47                	jle    8015ef <strtol+0x16a>
  8015a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ac:	0f b6 00             	movzbl (%rax),%eax
  8015af:	3c 5a                	cmp    $0x5a,%al
  8015b1:	7f 3c                	jg     8015ef <strtol+0x16a>
			dig = *s - 'A' + 10;
  8015b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b7:	0f b6 00             	movzbl (%rax),%eax
  8015ba:	0f be c0             	movsbl %al,%eax
  8015bd:	83 e8 37             	sub    $0x37,%eax
  8015c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015c6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015c9:	7d 23                	jge    8015ee <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8015cb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015d3:	48 98                	cltq   
  8015d5:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8015da:	48 89 c2             	mov    %rax,%rdx
  8015dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015e0:	48 98                	cltq   
  8015e2:	48 01 d0             	add    %rdx,%rax
  8015e5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8015e9:	e9 5f ff ff ff       	jmpq   80154d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015ee:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015ef:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8015f4:	74 0b                	je     801601 <strtol+0x17c>
		*endptr = (char *) s;
  8015f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015fa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015fe:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801601:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801605:	74 09                	je     801610 <strtol+0x18b>
  801607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160b:	48 f7 d8             	neg    %rax
  80160e:	eb 04                	jmp    801614 <strtol+0x18f>
  801610:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801614:	c9                   	leaveq 
  801615:	c3                   	retq   

0000000000801616 <strstr>:

char * strstr(const char *in, const char *str)
{
  801616:	55                   	push   %rbp
  801617:	48 89 e5             	mov    %rsp,%rbp
  80161a:	48 83 ec 30          	sub    $0x30,%rsp
  80161e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801622:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801626:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80162a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80162e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801632:	0f b6 00             	movzbl (%rax),%eax
  801635:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801638:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80163c:	75 06                	jne    801644 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80163e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801642:	eb 6b                	jmp    8016af <strstr+0x99>

	len = strlen(str);
  801644:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801648:	48 89 c7             	mov    %rax,%rdi
  80164b:	48 b8 e5 0e 80 00 00 	movabs $0x800ee5,%rax
  801652:	00 00 00 
  801655:	ff d0                	callq  *%rax
  801657:	48 98                	cltq   
  801659:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80165d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801661:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801665:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801669:	0f b6 00             	movzbl (%rax),%eax
  80166c:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80166f:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801673:	75 07                	jne    80167c <strstr+0x66>
				return (char *) 0;
  801675:	b8 00 00 00 00       	mov    $0x0,%eax
  80167a:	eb 33                	jmp    8016af <strstr+0x99>
		} while (sc != c);
  80167c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801680:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801683:	75 d8                	jne    80165d <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801685:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801689:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80168d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801691:	48 89 ce             	mov    %rcx,%rsi
  801694:	48 89 c7             	mov    %rax,%rdi
  801697:	48 b8 06 11 80 00 00 	movabs $0x801106,%rax
  80169e:	00 00 00 
  8016a1:	ff d0                	callq  *%rax
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	75 b6                	jne    80165d <strstr+0x47>

	return (char *) (in - 1);
  8016a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ab:	48 83 e8 01          	sub    $0x1,%rax
}
  8016af:	c9                   	leaveq 
  8016b0:	c3                   	retq   

00000000008016b1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016b1:	55                   	push   %rbp
  8016b2:	48 89 e5             	mov    %rsp,%rbp
  8016b5:	53                   	push   %rbx
  8016b6:	48 83 ec 48          	sub    $0x48,%rsp
  8016ba:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016bd:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016c0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016c4:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016c8:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016cc:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016d0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016d3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016d7:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8016db:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8016df:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8016e3:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8016e7:	4c 89 c3             	mov    %r8,%rbx
  8016ea:	cd 30                	int    $0x30
  8016ec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8016f0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8016f4:	74 3e                	je     801734 <syscall+0x83>
  8016f6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016fb:	7e 37                	jle    801734 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801701:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801704:	49 89 d0             	mov    %rdx,%r8
  801707:	89 c1                	mov    %eax,%ecx
  801709:	48 ba 68 2a 80 00 00 	movabs $0x802a68,%rdx
  801710:	00 00 00 
  801713:	be 23 00 00 00       	mov    $0x23,%esi
  801718:	48 bf 85 2a 80 00 00 	movabs $0x802a85,%rdi
  80171f:	00 00 00 
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
  801727:	49 b9 4e 23 80 00 00 	movabs $0x80234e,%r9
  80172e:	00 00 00 
  801731:	41 ff d1             	callq  *%r9

	return ret;
  801734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801738:	48 83 c4 48          	add    $0x48,%rsp
  80173c:	5b                   	pop    %rbx
  80173d:	5d                   	pop    %rbp
  80173e:	c3                   	retq   

000000000080173f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80173f:	55                   	push   %rbp
  801740:	48 89 e5             	mov    %rsp,%rbp
  801743:	48 83 ec 10          	sub    $0x10,%rsp
  801747:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80174b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80174f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801753:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801757:	48 83 ec 08          	sub    $0x8,%rsp
  80175b:	6a 00                	pushq  $0x0
  80175d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801763:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801769:	48 89 d1             	mov    %rdx,%rcx
  80176c:	48 89 c2             	mov    %rax,%rdx
  80176f:	be 00 00 00 00       	mov    $0x0,%esi
  801774:	bf 00 00 00 00       	mov    $0x0,%edi
  801779:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  801780:	00 00 00 
  801783:	ff d0                	callq  *%rax
  801785:	48 83 c4 10          	add    $0x10,%rsp
}
  801789:	90                   	nop
  80178a:	c9                   	leaveq 
  80178b:	c3                   	retq   

000000000080178c <sys_cgetc>:

int
sys_cgetc(void)
{
  80178c:	55                   	push   %rbp
  80178d:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801790:	48 83 ec 08          	sub    $0x8,%rsp
  801794:	6a 00                	pushq  $0x0
  801796:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80179c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ac:	be 00 00 00 00       	mov    $0x0,%esi
  8017b1:	bf 01 00 00 00       	mov    $0x1,%edi
  8017b6:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  8017bd:	00 00 00 
  8017c0:	ff d0                	callq  *%rax
  8017c2:	48 83 c4 10          	add    $0x10,%rsp
}
  8017c6:	c9                   	leaveq 
  8017c7:	c3                   	retq   

00000000008017c8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017c8:	55                   	push   %rbp
  8017c9:	48 89 e5             	mov    %rsp,%rbp
  8017cc:	48 83 ec 10          	sub    $0x10,%rsp
  8017d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017d6:	48 98                	cltq   
  8017d8:	48 83 ec 08          	sub    $0x8,%rsp
  8017dc:	6a 00                	pushq  $0x0
  8017de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017ef:	48 89 c2             	mov    %rax,%rdx
  8017f2:	be 01 00 00 00       	mov    $0x1,%esi
  8017f7:	bf 03 00 00 00       	mov    $0x3,%edi
  8017fc:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  801803:	00 00 00 
  801806:	ff d0                	callq  *%rax
  801808:	48 83 c4 10          	add    $0x10,%rsp
}
  80180c:	c9                   	leaveq 
  80180d:	c3                   	retq   

000000000080180e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80180e:	55                   	push   %rbp
  80180f:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801812:	48 83 ec 08          	sub    $0x8,%rsp
  801816:	6a 00                	pushq  $0x0
  801818:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80181e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801824:	b9 00 00 00 00       	mov    $0x0,%ecx
  801829:	ba 00 00 00 00       	mov    $0x0,%edx
  80182e:	be 00 00 00 00       	mov    $0x0,%esi
  801833:	bf 02 00 00 00       	mov    $0x2,%edi
  801838:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  80183f:	00 00 00 
  801842:	ff d0                	callq  *%rax
  801844:	48 83 c4 10          	add    $0x10,%rsp
}
  801848:	c9                   	leaveq 
  801849:	c3                   	retq   

000000000080184a <sys_yield>:

void
sys_yield(void)
{
  80184a:	55                   	push   %rbp
  80184b:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80184e:	48 83 ec 08          	sub    $0x8,%rsp
  801852:	6a 00                	pushq  $0x0
  801854:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80185a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801860:	b9 00 00 00 00       	mov    $0x0,%ecx
  801865:	ba 00 00 00 00       	mov    $0x0,%edx
  80186a:	be 00 00 00 00       	mov    $0x0,%esi
  80186f:	bf 0a 00 00 00       	mov    $0xa,%edi
  801874:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  80187b:	00 00 00 
  80187e:	ff d0                	callq  *%rax
  801880:	48 83 c4 10          	add    $0x10,%rsp
}
  801884:	90                   	nop
  801885:	c9                   	leaveq 
  801886:	c3                   	retq   

0000000000801887 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801887:	55                   	push   %rbp
  801888:	48 89 e5             	mov    %rsp,%rbp
  80188b:	48 83 ec 10          	sub    $0x10,%rsp
  80188f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801892:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801896:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801899:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80189c:	48 63 c8             	movslq %eax,%rcx
  80189f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a6:	48 98                	cltq   
  8018a8:	48 83 ec 08          	sub    $0x8,%rsp
  8018ac:	6a 00                	pushq  $0x0
  8018ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b4:	49 89 c8             	mov    %rcx,%r8
  8018b7:	48 89 d1             	mov    %rdx,%rcx
  8018ba:	48 89 c2             	mov    %rax,%rdx
  8018bd:	be 01 00 00 00       	mov    $0x1,%esi
  8018c2:	bf 04 00 00 00       	mov    $0x4,%edi
  8018c7:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  8018ce:	00 00 00 
  8018d1:	ff d0                	callq  *%rax
  8018d3:	48 83 c4 10          	add    $0x10,%rsp
}
  8018d7:	c9                   	leaveq 
  8018d8:	c3                   	retq   

00000000008018d9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018d9:	55                   	push   %rbp
  8018da:	48 89 e5             	mov    %rsp,%rbp
  8018dd:	48 83 ec 20          	sub    $0x20,%rsp
  8018e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018e8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8018eb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8018ef:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8018f3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018f6:	48 63 c8             	movslq %eax,%rcx
  8018f9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8018fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801900:	48 63 f0             	movslq %eax,%rsi
  801903:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801907:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190a:	48 98                	cltq   
  80190c:	48 83 ec 08          	sub    $0x8,%rsp
  801910:	51                   	push   %rcx
  801911:	49 89 f9             	mov    %rdi,%r9
  801914:	49 89 f0             	mov    %rsi,%r8
  801917:	48 89 d1             	mov    %rdx,%rcx
  80191a:	48 89 c2             	mov    %rax,%rdx
  80191d:	be 01 00 00 00       	mov    $0x1,%esi
  801922:	bf 05 00 00 00       	mov    $0x5,%edi
  801927:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  80192e:	00 00 00 
  801931:	ff d0                	callq  *%rax
  801933:	48 83 c4 10          	add    $0x10,%rsp
}
  801937:	c9                   	leaveq 
  801938:	c3                   	retq   

0000000000801939 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801939:	55                   	push   %rbp
  80193a:	48 89 e5             	mov    %rsp,%rbp
  80193d:	48 83 ec 10          	sub    $0x10,%rsp
  801941:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801944:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801948:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80194c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194f:	48 98                	cltq   
  801951:	48 83 ec 08          	sub    $0x8,%rsp
  801955:	6a 00                	pushq  $0x0
  801957:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80195d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801963:	48 89 d1             	mov    %rdx,%rcx
  801966:	48 89 c2             	mov    %rax,%rdx
  801969:	be 01 00 00 00       	mov    $0x1,%esi
  80196e:	bf 06 00 00 00       	mov    $0x6,%edi
  801973:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  80197a:	00 00 00 
  80197d:	ff d0                	callq  *%rax
  80197f:	48 83 c4 10          	add    $0x10,%rsp
}
  801983:	c9                   	leaveq 
  801984:	c3                   	retq   

0000000000801985 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801985:	55                   	push   %rbp
  801986:	48 89 e5             	mov    %rsp,%rbp
  801989:	48 83 ec 10          	sub    $0x10,%rsp
  80198d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801990:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801993:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801996:	48 63 d0             	movslq %eax,%rdx
  801999:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80199c:	48 98                	cltq   
  80199e:	48 83 ec 08          	sub    $0x8,%rsp
  8019a2:	6a 00                	pushq  $0x0
  8019a4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019aa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b0:	48 89 d1             	mov    %rdx,%rcx
  8019b3:	48 89 c2             	mov    %rax,%rdx
  8019b6:	be 01 00 00 00       	mov    $0x1,%esi
  8019bb:	bf 08 00 00 00       	mov    $0x8,%edi
  8019c0:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  8019c7:	00 00 00 
  8019ca:	ff d0                	callq  *%rax
  8019cc:	48 83 c4 10          	add    $0x10,%rsp
}
  8019d0:	c9                   	leaveq 
  8019d1:	c3                   	retq   

00000000008019d2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019d2:	55                   	push   %rbp
  8019d3:	48 89 e5             	mov    %rsp,%rbp
  8019d6:	48 83 ec 10          	sub    $0x10,%rsp
  8019da:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8019e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e8:	48 98                	cltq   
  8019ea:	48 83 ec 08          	sub    $0x8,%rsp
  8019ee:	6a 00                	pushq  $0x0
  8019f0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019f6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019fc:	48 89 d1             	mov    %rdx,%rcx
  8019ff:	48 89 c2             	mov    %rax,%rdx
  801a02:	be 01 00 00 00       	mov    $0x1,%esi
  801a07:	bf 09 00 00 00       	mov    $0x9,%edi
  801a0c:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  801a13:	00 00 00 
  801a16:	ff d0                	callq  *%rax
  801a18:	48 83 c4 10          	add    $0x10,%rsp
}
  801a1c:	c9                   	leaveq 
  801a1d:	c3                   	retq   

0000000000801a1e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a1e:	55                   	push   %rbp
  801a1f:	48 89 e5             	mov    %rsp,%rbp
  801a22:	48 83 ec 20          	sub    $0x20,%rsp
  801a26:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a29:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a2d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a31:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a34:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a37:	48 63 f0             	movslq %eax,%rsi
  801a3a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a41:	48 98                	cltq   
  801a43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a47:	48 83 ec 08          	sub    $0x8,%rsp
  801a4b:	6a 00                	pushq  $0x0
  801a4d:	49 89 f1             	mov    %rsi,%r9
  801a50:	49 89 c8             	mov    %rcx,%r8
  801a53:	48 89 d1             	mov    %rdx,%rcx
  801a56:	48 89 c2             	mov    %rax,%rdx
  801a59:	be 00 00 00 00       	mov    $0x0,%esi
  801a5e:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a63:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  801a6a:	00 00 00 
  801a6d:	ff d0                	callq  *%rax
  801a6f:	48 83 c4 10          	add    $0x10,%rsp
}
  801a73:	c9                   	leaveq 
  801a74:	c3                   	retq   

0000000000801a75 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a75:	55                   	push   %rbp
  801a76:	48 89 e5             	mov    %rsp,%rbp
  801a79:	48 83 ec 10          	sub    $0x10,%rsp
  801a7d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a85:	48 83 ec 08          	sub    $0x8,%rsp
  801a89:	6a 00                	pushq  $0x0
  801a8b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a91:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a97:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9c:	48 89 c2             	mov    %rax,%rdx
  801a9f:	be 01 00 00 00       	mov    $0x1,%esi
  801aa4:	bf 0c 00 00 00       	mov    $0xc,%edi
  801aa9:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  801ab0:	00 00 00 
  801ab3:	ff d0                	callq  *%rax
  801ab5:	48 83 c4 10          	add    $0x10,%rsp
}
  801ab9:	c9                   	leaveq 
  801aba:	c3                   	retq   

0000000000801abb <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801abb:	55                   	push   %rbp
  801abc:	48 89 e5             	mov    %rsp,%rbp
  801abf:	53                   	push   %rbx
  801ac0:	48 83 ec 38          	sub    $0x38,%rsp
  801ac4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = ROUNDDOWN((void *) utf->utf_fault_va, PGSIZE);
  801ac8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801acc:	48 8b 00             	mov    (%rax),%rax
  801acf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801ad3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ad7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801add:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801ae1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801ae5:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ae9:	89 45 dc             	mov    %eax,-0x24(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//err is not a writing error & permissions are not PTE_COW
	if (!((uvpt[(uint64_t)addr/PGSIZE] & PTE_COW) && (err & FEC_WR))){
  801aec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801af0:	48 c1 e8 0c          	shr    $0xc,%rax
  801af4:	48 89 c2             	mov    %rax,%rdx
  801af7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801afe:	01 00 00 
  801b01:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b05:	25 00 08 00 00       	and    $0x800,%eax
  801b0a:	48 85 c0             	test   %rax,%rax
  801b0d:	74 0a                	je     801b19 <pgfault+0x5e>
  801b0f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b12:	83 e0 02             	and    $0x2,%eax
  801b15:	85 c0                	test   %eax,%eax
  801b17:	75 2a                	jne    801b43 <pgfault+0x88>
		panic("not proper page fault");	
  801b19:	48 ba 98 2a 80 00 00 	movabs $0x802a98,%rdx
  801b20:	00 00 00 
  801b23:	be 1e 00 00 00       	mov    $0x1e,%esi
  801b28:	48 bf ae 2a 80 00 00 	movabs $0x802aae,%rdi
  801b2f:	00 00 00 
  801b32:	b8 00 00 00 00       	mov    $0x0,%eax
  801b37:	48 b9 4e 23 80 00 00 	movabs $0x80234e,%rcx
  801b3e:	00 00 00 
  801b41:	ff d1                	callq  *%rcx
	// LAB 4: Your code here.
	
	int result;

	//allocate new page & map it
	result = sys_page_alloc(sys_getenvid(), PFTEMP, PTE_P|PTE_U|PTE_W);
  801b43:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  801b4a:	00 00 00 
  801b4d:	ff d0                	callq  *%rax
  801b4f:	ba 07 00 00 00       	mov    $0x7,%edx
  801b54:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b59:	89 c7                	mov    %eax,%edi
  801b5b:	48 b8 87 18 80 00 00 	movabs $0x801887,%rax
  801b62:	00 00 00 
  801b65:	ff d0                	callq  *%rax
  801b67:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801b6a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b6e:	79 2a                	jns    801b9a <pgfault+0xdf>
		panic("page allocation failed in copy-on-write faulting page");
  801b70:	48 ba c0 2a 80 00 00 	movabs $0x802ac0,%rdx
  801b77:	00 00 00 
  801b7a:	be 2f 00 00 00       	mov    $0x2f,%esi
  801b7f:	48 bf ae 2a 80 00 00 	movabs $0x802aae,%rdi
  801b86:	00 00 00 
  801b89:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8e:	48 b9 4e 23 80 00 00 	movabs $0x80234e,%rcx
  801b95:	00 00 00 
  801b98:	ff d1                	callq  *%rcx
	}
	
	//copy page
	memcpy(PFTEMP, addr, PGSIZE);
  801b9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b9e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ba3:	48 89 c6             	mov    %rax,%rsi
  801ba6:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801bab:	48 b8 8d 13 80 00 00 	movabs $0x80138d,%rax
  801bb2:	00 00 00 
  801bb5:	ff d0                	callq  *%rax
	
	//map new page into original page's space
	result = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_W|PTE_U|PTE_P);
  801bb7:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  801bbe:	00 00 00 
  801bc1:	ff d0                	callq  *%rax
  801bc3:	89 c3                	mov    %eax,%ebx
  801bc5:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  801bcc:	00 00 00 
  801bcf:	ff d0                	callq  *%rax
  801bd1:	89 c7                	mov    %eax,%edi
  801bd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bd7:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801bdd:	48 89 c1             	mov    %rax,%rcx
  801be0:	89 da                	mov    %ebx,%edx
  801be2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801be7:	48 b8 d9 18 80 00 00 	movabs $0x8018d9,%rax
  801bee:	00 00 00 
  801bf1:	ff d0                	callq  *%rax
  801bf3:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801bf6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bfa:	79 2a                	jns    801c26 <pgfault+0x16b>
                panic("page mapping failed in copy-on-write faulting page");
  801bfc:	48 ba f8 2a 80 00 00 	movabs $0x802af8,%rdx
  801c03:	00 00 00 
  801c06:	be 38 00 00 00       	mov    $0x38,%esi
  801c0b:	48 bf ae 2a 80 00 00 	movabs $0x802aae,%rdi
  801c12:	00 00 00 
  801c15:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1a:	48 b9 4e 23 80 00 00 	movabs $0x80234e,%rcx
  801c21:	00 00 00 
  801c24:	ff d1                	callq  *%rcx
        }

	//delete temporary location
	result = sys_page_unmap(sys_getenvid(), PFTEMP);
  801c26:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  801c2d:	00 00 00 
  801c30:	ff d0                	callq  *%rax
  801c32:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c37:	89 c7                	mov    %eax,%edi
  801c39:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801c40:	00 00 00 
  801c43:	ff d0                	callq  *%rax
  801c45:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801c48:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c4c:	79 2a                	jns    801c78 <pgfault+0x1bd>
                panic("temporary page unmapping failed in copy-on-write faulting page");
  801c4e:	48 ba 30 2b 80 00 00 	movabs $0x802b30,%rdx
  801c55:	00 00 00 
  801c58:	be 3e 00 00 00       	mov    $0x3e,%esi
  801c5d:	48 bf ae 2a 80 00 00 	movabs $0x802aae,%rdi
  801c64:	00 00 00 
  801c67:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6c:	48 b9 4e 23 80 00 00 	movabs $0x80234e,%rcx
  801c73:	00 00 00 
  801c76:	ff d1                	callq  *%rcx
        }	

	//panic("pgfault not implemented");

}
  801c78:	90                   	nop
  801c79:	48 83 c4 38          	add    $0x38,%rsp
  801c7d:	5b                   	pop    %rbx
  801c7e:	5d                   	pop    %rbp
  801c7f:	c3                   	retq   

0000000000801c80 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801c80:	55                   	push   %rbp
  801c81:	48 89 e5             	mov    %rsp,%rbp
  801c84:	53                   	push   %rbx
  801c85:	48 83 ec 28          	sub    $0x28,%rsp
  801c89:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801c8c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uint64_t)pn*PGSIZE);	
  801c8f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801c92:	48 c1 e0 0c          	shl    $0xc,%rax
  801c96:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result;

	//COW or writable
	if ((uvpt[pn]&PTE_COW) || (uvpt[pn]&PTE_W)){
  801c9a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ca1:	01 00 00 
  801ca4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801ca7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cab:	25 00 08 00 00       	and    $0x800,%eax
  801cb0:	48 85 c0             	test   %rax,%rax
  801cb3:	75 1d                	jne    801cd2 <duppage+0x52>
  801cb5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cbc:	01 00 00 
  801cbf:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801cc2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cc6:	83 e0 02             	and    $0x2,%eax
  801cc9:	48 85 c0             	test   %rax,%rax
  801ccc:	0f 84 8f 00 00 00    	je     801d61 <duppage+0xe1>
		//map to child
		result = sys_page_map(sys_getenvid(), addr, envid, addr, PTE_COW|PTE_U|PTE_P);
  801cd2:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  801cd9:	00 00 00 
  801cdc:	ff d0                	callq  *%rax
  801cde:	89 c7                	mov    %eax,%edi
  801ce0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ce4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801ce7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ceb:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801cf1:	48 89 c6             	mov    %rax,%rsi
  801cf4:	48 b8 d9 18 80 00 00 	movabs $0x8018d9,%rax
  801cfb:	00 00 00 
  801cfe:	ff d0                	callq  *%rax
  801d00:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (result<0){
  801d03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801d07:	79 0a                	jns    801d13 <duppage+0x93>
			return -1;
  801d09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801d0e:	e9 91 00 00 00       	jmpq   801da4 <duppage+0x124>
		}

		//remap page with proper permissions COW
		result = sys_page_map(sys_getenvid(), addr, sys_getenvid(), addr, PTE_COW|PTE_U|PTE_P);
  801d13:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  801d1a:	00 00 00 
  801d1d:	ff d0                	callq  *%rax
  801d1f:	89 c3                	mov    %eax,%ebx
  801d21:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  801d28:	00 00 00 
  801d2b:	ff d0                	callq  *%rax
  801d2d:	89 c7                	mov    %eax,%edi
  801d2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d37:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801d3d:	48 89 d1             	mov    %rdx,%rcx
  801d40:	89 da                	mov    %ebx,%edx
  801d42:	48 89 c6             	mov    %rax,%rsi
  801d45:	48 b8 d9 18 80 00 00 	movabs $0x8018d9,%rax
  801d4c:	00 00 00 
  801d4f:	ff d0                	callq  *%rax
  801d51:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (result<0){
  801d54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801d58:	79 45                	jns    801d9f <duppage+0x11f>
                        return -1;
  801d5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801d5f:	eb 43                	jmp    801da4 <duppage+0x124>
                } 	
	//not proper permissions
	}else{
		result=sys_page_map(sys_getenvid(), addr, envid, addr, PTE_P|PTE_U);
  801d61:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  801d68:	00 00 00 
  801d6b:	ff d0                	callq  *%rax
  801d6d:	89 c7                	mov    %eax,%edi
  801d6f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d73:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801d76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d7a:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  801d80:	48 89 c6             	mov    %rax,%rsi
  801d83:	48 b8 d9 18 80 00 00 	movabs $0x8018d9,%rax
  801d8a:	00 00 00 
  801d8d:	ff d0                	callq  *%rax
  801d8f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (result<0){
  801d92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801d96:	79 07                	jns    801d9f <duppage+0x11f>
			return -1;
  801d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801d9d:	eb 05                	jmp    801da4 <duppage+0x124>
		}
	}

	//panic("duppage not implemented");
	return 0;
  801d9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da4:	48 83 c4 28          	add    $0x28,%rsp
  801da8:	5b                   	pop    %rbx
  801da9:	5d                   	pop    %rbp
  801daa:	c3                   	retq   

0000000000801dab <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801dab:	55                   	push   %rbp
  801dac:	48 89 e5             	mov    %rsp,%rbp
  801daf:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	//LOOKED AT DUMBFORK FOR HELP :)	


	//step 1 
	set_pgfault_handler(pgfault);
  801db3:	48 bf bb 1a 80 00 00 	movabs $0x801abb,%rdi
  801dba:	00 00 00 
  801dbd:	48 b8 62 24 80 00 00 	movabs $0x802462,%rax
  801dc4:	00 00 00 
  801dc7:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801dc9:	b8 07 00 00 00       	mov    $0x7,%eax
  801dce:	cd 30                	int    $0x30
  801dd0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801dd3:	8b 45 e8             	mov    -0x18(%rbp),%eax
	
	//step 2
	envid_t child = sys_exofork();
  801dd6:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (child==0){
  801dd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ddd:	75 46                	jne    801e25 <fork+0x7a>
		//fix env in child
		thisenv = &envs[ENVX(sys_getenvid())];
  801ddf:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  801de6:	00 00 00 
  801de9:	ff d0                	callq  *%rax
  801deb:	25 ff 03 00 00       	and    $0x3ff,%eax
  801df0:	48 63 d0             	movslq %eax,%rdx
  801df3:	48 89 d0             	mov    %rdx,%rax
  801df6:	48 c1 e0 03          	shl    $0x3,%rax
  801dfa:	48 01 d0             	add    %rdx,%rax
  801dfd:	48 c1 e0 05          	shl    $0x5,%rax
  801e01:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801e08:	00 00 00 
  801e0b:	48 01 c2             	add    %rax,%rdx
  801e0e:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  801e15:	00 00 00 
  801e18:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e20:	e9 2b 03 00 00       	jmpq   802150 <fork+0x3a5>
	}
	if(child<0){
  801e25:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e29:	79 0a                	jns    801e35 <fork+0x8a>
		return -1; //exofork failed
  801e2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801e30:	e9 1b 03 00 00       	jmpq   802150 <fork+0x3a5>

//For each writable or copy-on-write page in its address space below UTOP, the parent calls duppage, which should map the page copy-on-write into the address space of the child and then remap the page copy-on-write in its own address space. duppage sets both PTEs so that the page is not writeable, and to contain PTE_COW in the "avail" field to distinguish copy-on-write pages from genuine read-only pages.

	uintptr_t addr;
	extern unsigned char end[];
	for (addr = (uintptr_t)UTEXT; addr < (uintptr_t)end; addr += PGSIZE){//taken from dumbfork
  801e35:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  801e3c:	00 
  801e3d:	e9 ec 00 00 00       	jmpq   801f2e <fork+0x183>
		
		//check if page is copy on write
		int perms = (uvpml4e[VPML4E(addr)] & PTE_P);
  801e42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e46:	48 c1 e8 27          	shr    $0x27,%rax
  801e4a:	48 89 c2             	mov    %rax,%rdx
  801e4d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801e54:	01 00 00 
  801e57:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e5b:	83 e0 01             	and    $0x1,%eax
  801e5e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpde[VPDPE(addr)] & PTE_P);
  801e61:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801e65:	74 28                	je     801e8f <fork+0xe4>
  801e67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e6b:	48 c1 e8 1e          	shr    $0x1e,%rax
  801e6f:	48 89 c2             	mov    %rax,%rdx
  801e72:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801e79:	01 00 00 
  801e7c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e80:	83 e0 01             	and    $0x1,%eax
  801e83:	48 85 c0             	test   %rax,%rax
  801e86:	74 07                	je     801e8f <fork+0xe4>
  801e88:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8d:	eb 05                	jmp    801e94 <fork+0xe9>
  801e8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e94:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpd[VPD(addr)] & PTE_P);		
  801e97:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801e9b:	74 28                	je     801ec5 <fork+0x11a>
  801e9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea1:	48 c1 e8 15          	shr    $0x15,%rax
  801ea5:	48 89 c2             	mov    %rax,%rdx
  801ea8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801eaf:	01 00 00 
  801eb2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eb6:	83 e0 01             	and    $0x1,%eax
  801eb9:	48 85 c0             	test   %rax,%rax
  801ebc:	74 07                	je     801ec5 <fork+0x11a>
  801ebe:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec3:	eb 05                	jmp    801eca <fork+0x11f>
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eca:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpt[PGNUM(addr)] & (PTE_P | PTE_U));
  801ecd:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801ed1:	74 28                	je     801efb <fork+0x150>
  801ed3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed7:	48 c1 e8 0c          	shr    $0xc,%rax
  801edb:	48 89 c2             	mov    %rax,%rdx
  801ede:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ee5:	01 00 00 
  801ee8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eec:	83 e0 05             	and    $0x5,%eax
  801eef:	48 85 c0             	test   %rax,%rax
  801ef2:	74 07                	je     801efb <fork+0x150>
  801ef4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef9:	eb 05                	jmp    801f00 <fork+0x155>
  801efb:	b8 00 00 00 00       	mov    $0x0,%eax
  801f00:	89 45 f0             	mov    %eax,-0x10(%rbp)

		if (perms){
  801f03:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f07:	74 1d                	je     801f26 <fork+0x17b>
			duppage(child, PGNUM(addr));
  801f09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f0d:	48 c1 e8 0c          	shr    $0xc,%rax
  801f11:	89 c2                	mov    %eax,%edx
  801f13:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f16:	89 d6                	mov    %edx,%esi
  801f18:	89 c7                	mov    %eax,%edi
  801f1a:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  801f21:	00 00 00 
  801f24:	ff d0                	callq  *%rax

//For each writable or copy-on-write page in its address space below UTOP, the parent calls duppage, which should map the page copy-on-write into the address space of the child and then remap the page copy-on-write in its own address space. duppage sets both PTEs so that the page is not writeable, and to contain PTE_COW in the "avail" field to distinguish copy-on-write pages from genuine read-only pages.

	uintptr_t addr;
	extern unsigned char end[];
	for (addr = (uintptr_t)UTEXT; addr < (uintptr_t)end; addr += PGSIZE){//taken from dumbfork
  801f26:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  801f2d:	00 
  801f2e:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801f35:	00 00 00 
  801f38:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  801f3c:	0f 82 00 ff ff ff    	jb     801e42 <fork+0x97>
//The exception stack is not remapped this way, however. Instead you need to allocate a fresh page in the child for the exception stack. Since the page fault handler will be doing the actual copying and the page fault handler runs on the exception stack, the exception stack cannot be made copy-on-write: who would copy it?

	int result;

        //allocate new page & map it
        result = sys_page_alloc(sys_getenvid(), PFTEMP, PTE_P|PTE_U|PTE_W);
  801f42:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  801f49:	00 00 00 
  801f4c:	ff d0                	callq  *%rax
  801f4e:	ba 07 00 00 00       	mov    $0x7,%edx
  801f53:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f58:	89 c7                	mov    %eax,%edi
  801f5a:	48 b8 87 18 80 00 00 	movabs $0x801887,%rax
  801f61:	00 00 00 
  801f64:	ff d0                	callq  *%rax
  801f66:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  801f69:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f6d:	79 2a                	jns    801f99 <fork+0x1ee>
                panic("page allocation failed in fork");
  801f6f:	48 ba 70 2b 80 00 00 	movabs $0x802b70,%rdx
  801f76:	00 00 00 
  801f79:	be b0 00 00 00       	mov    $0xb0,%esi
  801f7e:	48 bf ae 2a 80 00 00 	movabs $0x802aae,%rdi
  801f85:	00 00 00 
  801f88:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8d:	48 b9 4e 23 80 00 00 	movabs $0x80234e,%rcx
  801f94:	00 00 00 
  801f97:	ff d1                	callq  *%rcx
        }

        //copy page
        memcpy(PFTEMP, (void *)(USTACKTOP-PGSIZE), PGSIZE);
  801f99:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f9e:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801fa3:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801fa8:	48 b8 8d 13 80 00 00 	movabs $0x80138d,%rax
  801faf:	00 00 00 
  801fb2:	ff d0                	callq  *%rax

        //map new page into original page's space
        result = sys_page_map(sys_getenvid(), PFTEMP, child,(void *)(USTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  801fb4:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  801fbb:	00 00 00 
  801fbe:	ff d0                	callq  *%rax
  801fc0:	89 c7                	mov    %eax,%edi
  801fc2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fc5:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801fcb:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  801fd0:	89 c2                	mov    %eax,%edx
  801fd2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fd7:	48 b8 d9 18 80 00 00 	movabs $0x8018d9,%rax
  801fde:	00 00 00 
  801fe1:	ff d0                	callq  *%rax
  801fe3:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  801fe6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fea:	79 2a                	jns    802016 <fork+0x26b>
                panic("page mapping failed in fork");
  801fec:	48 ba 8f 2b 80 00 00 	movabs $0x802b8f,%rdx
  801ff3:	00 00 00 
  801ff6:	be b9 00 00 00       	mov    $0xb9,%esi
  801ffb:	48 bf ae 2a 80 00 00 	movabs $0x802aae,%rdi
  802002:	00 00 00 
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
  80200a:	48 b9 4e 23 80 00 00 	movabs $0x80234e,%rcx
  802011:	00 00 00 
  802014:	ff d1                	callq  *%rcx
        }

        //delete temporary location
        result = sys_page_unmap(sys_getenvid(), PFTEMP);
  802016:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  80201d:	00 00 00 
  802020:	ff d0                	callq  *%rax
  802022:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802027:	89 c7                	mov    %eax,%edi
  802029:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  802030:	00 00 00 
  802033:	ff d0                	callq  *%rax
  802035:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  802038:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80203c:	79 2a                	jns    802068 <fork+0x2bd>
                panic("temporary page unmapping failed in copy-on-write faulting page");
  80203e:	48 ba 30 2b 80 00 00 	movabs $0x802b30,%rdx
  802045:	00 00 00 
  802048:	be bf 00 00 00       	mov    $0xbf,%esi
  80204d:	48 bf ae 2a 80 00 00 	movabs $0x802aae,%rdi
  802054:	00 00 00 
  802057:	b8 00 00 00 00       	mov    $0x0,%eax
  80205c:	48 b9 4e 23 80 00 00 	movabs $0x80234e,%rcx
  802063:	00 00 00 
  802066:	ff d1                	callq  *%rcx
        }
// STEP 4
//The parent sets the user page fault entrypoint for the child to look like its own.

	result=sys_page_alloc(child, (void*)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W);
  802068:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80206b:	ba 07 00 00 00       	mov    $0x7,%edx
  802070:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802075:	89 c7                	mov    %eax,%edi
  802077:	48 b8 87 18 80 00 00 	movabs $0x801887,%rax
  80207e:	00 00 00 
  802081:	ff d0                	callq  *%rax
  802083:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  802086:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80208a:	79 2a                	jns    8020b6 <fork+0x30b>
		panic("page alloc of table failed in fork");
  80208c:	48 ba b0 2b 80 00 00 	movabs $0x802bb0,%rdx
  802093:	00 00 00 
  802096:	be c6 00 00 00       	mov    $0xc6,%esi
  80209b:	48 bf ae 2a 80 00 00 	movabs $0x802aae,%rdi
  8020a2:	00 00 00 
  8020a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020aa:	48 b9 4e 23 80 00 00 	movabs $0x80234e,%rcx
  8020b1:	00 00 00 
  8020b4:	ff d1                	callq  *%rcx
	}

	extern void _pgfault_upcall();
	result = sys_env_set_pgfault_upcall(child, _pgfault_upcall);
  8020b6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020b9:	48 be 46 25 80 00 00 	movabs $0x802546,%rsi
  8020c0:	00 00 00 
  8020c3:	89 c7                	mov    %eax,%edi
  8020c5:	48 b8 d2 19 80 00 00 	movabs $0x8019d2,%rax
  8020cc:	00 00 00 
  8020cf:	ff d0                	callq  *%rax
  8020d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  8020d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020d8:	79 2a                	jns    802104 <fork+0x359>
		panic("setting upcall failed in fork"); 
  8020da:	48 ba d3 2b 80 00 00 	movabs $0x802bd3,%rdx
  8020e1:	00 00 00 
  8020e4:	be cc 00 00 00       	mov    $0xcc,%esi
  8020e9:	48 bf ae 2a 80 00 00 	movabs $0x802aae,%rdi
  8020f0:	00 00 00 
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f8:	48 b9 4e 23 80 00 00 	movabs $0x80234e,%rcx
  8020ff:	00 00 00 
  802102:	ff d1                	callq  *%rcx
	}
// STEP 5
//The child is now ready to run, so the parent marks it runnable.

	result = sys_env_set_status(child, ENV_RUNNABLE);
  802104:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802107:	be 02 00 00 00       	mov    $0x2,%esi
  80210c:	89 c7                	mov    %eax,%edi
  80210e:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  802115:	00 00 00 
  802118:	ff d0                	callq  *%rax
  80211a:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  80211d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802121:	79 2a                	jns    80214d <fork+0x3a2>
		panic("changing statys is fork failed");
  802123:	48 ba f8 2b 80 00 00 	movabs $0x802bf8,%rdx
  80212a:	00 00 00 
  80212d:	be d3 00 00 00       	mov    $0xd3,%esi
  802132:	48 bf ae 2a 80 00 00 	movabs $0x802aae,%rdi
  802139:	00 00 00 
  80213c:	b8 00 00 00 00       	mov    $0x0,%eax
  802141:	48 b9 4e 23 80 00 00 	movabs $0x80234e,%rcx
  802148:	00 00 00 
  80214b:	ff d1                	callq  *%rcx
	}
	
	return child;
  80214d:	8b 45 f4             	mov    -0xc(%rbp),%eax

}
  802150:	c9                   	leaveq 
  802151:	c3                   	retq   

0000000000802152 <sfork>:

// Challenge!
int
sfork(void)
{
  802152:	55                   	push   %rbp
  802153:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802156:	48 ba 17 2c 80 00 00 	movabs $0x802c17,%rdx
  80215d:	00 00 00 
  802160:	be de 00 00 00       	mov    $0xde,%esi
  802165:	48 bf ae 2a 80 00 00 	movabs $0x802aae,%rdi
  80216c:	00 00 00 
  80216f:	b8 00 00 00 00       	mov    $0x0,%eax
  802174:	48 b9 4e 23 80 00 00 	movabs $0x80234e,%rcx
  80217b:	00 00 00 
  80217e:	ff d1                	callq  *%rcx

0000000000802180 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802180:	55                   	push   %rbp
  802181:	48 89 e5             	mov    %rsp,%rbp
  802184:	48 83 ec 30          	sub    $0x30,%rsp
  802188:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80218c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802190:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	//cprintf("lib ipc_recv\n");
	// LAB 4: Your code here.
	if (pg==NULL){
  802194:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802199:	75 08                	jne    8021a3 <ipc_recv+0x23>
		pg = (void *) -1;	
  80219b:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8021a2:	ff 
	}
	
	int result = sys_ipc_recv(pg);
  8021a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021a7:	48 89 c7             	mov    %rax,%rdi
  8021aa:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  8021b1:	00 00 00 
  8021b4:	ff d0                	callq  *%rax
  8021b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (result<0){
  8021b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021bd:	79 27                	jns    8021e6 <ipc_recv+0x66>
		if (from_env_store){
  8021bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8021c4:	74 0a                	je     8021d0 <ipc_recv+0x50>
			*from_env_store=0;
  8021c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ca:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if (perm_store){
  8021d0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8021d5:	74 0a                	je     8021e1 <ipc_recv+0x61>
			*perm_store = 0;
  8021d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021db:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		return result;
  8021e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021e4:	eb 53                	jmp    802239 <ipc_recv+0xb9>
	}	
	if (from_env_store){
  8021e6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8021eb:	74 19                	je     802206 <ipc_recv+0x86>
	 	*from_env_store = thisenv->env_ipc_from;
  8021ed:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  8021f4:	00 00 00 
  8021f7:	48 8b 00             	mov    (%rax),%rax
  8021fa:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802200:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802204:	89 10                	mov    %edx,(%rax)
        }
        if (perm_store){
  802206:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80220b:	74 19                	je     802226 <ipc_recv+0xa6>
               	*perm_store = thisenv->env_ipc_perm;
  80220d:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  802214:	00 00 00 
  802217:	48 8b 00             	mov    (%rax),%rax
  80221a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802220:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802224:	89 10                	mov    %edx,(%rax)
        }
	//panic("ipc_recv not implemented");
	return thisenv->env_ipc_value;
  802226:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80222d:	00 00 00 
  802230:	48 8b 00             	mov    (%rax),%rax
  802233:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  802239:	c9                   	leaveq 
  80223a:	c3                   	retq   

000000000080223b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80223b:	55                   	push   %rbp
  80223c:	48 89 e5             	mov    %rsp,%rbp
  80223f:	48 83 ec 30          	sub    $0x30,%rsp
  802243:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802246:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802249:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80224d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	//cprintf("lib ipc_send\n");
	// LAB 4: Your code here.
	if (pg==NULL){
  802250:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802255:	75 4c                	jne    8022a3 <ipc_send+0x68>
		pg = (void *)-1;
  802257:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  80225e:	ff 
	}
	int result;
	while((result=sys_ipc_try_send(to_env, val, pg, perm))){
  80225f:	eb 42                	jmp    8022a3 <ipc_send+0x68>
		if (result==0){
  802261:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802265:	74 62                	je     8022c9 <ipc_send+0x8e>
			break;
		}
		if (result!=-E_IPC_NOT_RECV){
  802267:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80226b:	74 2a                	je     802297 <ipc_send+0x5c>
			panic("syscall returned improper error");
  80226d:	48 ba 30 2c 80 00 00 	movabs $0x802c30,%rdx
  802274:	00 00 00 
  802277:	be 49 00 00 00       	mov    $0x49,%esi
  80227c:	48 bf 50 2c 80 00 00 	movabs $0x802c50,%rdi
  802283:	00 00 00 
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
  80228b:	48 b9 4e 23 80 00 00 	movabs $0x80234e,%rcx
  802292:	00 00 00 
  802295:	ff d1                	callq  *%rcx
		}
		sys_yield();
  802297:	48 b8 4a 18 80 00 00 	movabs $0x80184a,%rax
  80229e:	00 00 00 
  8022a1:	ff d0                	callq  *%rax
	// LAB 4: Your code here.
	if (pg==NULL){
		pg = (void *)-1;
	}
	int result;
	while((result=sys_ipc_try_send(to_env, val, pg, perm))){
  8022a3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8022a6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8022a9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022b0:	89 c7                	mov    %eax,%edi
  8022b2:	48 b8 1e 1a 80 00 00 	movabs $0x801a1e,%rax
  8022b9:	00 00 00 
  8022bc:	ff d0                	callq  *%rax
  8022be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c5:	75 9a                	jne    802261 <ipc_send+0x26>
			panic("syscall returned improper error");
		}
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  8022c7:	eb 01                	jmp    8022ca <ipc_send+0x8f>
		pg = (void *)-1;
	}
	int result;
	while((result=sys_ipc_try_send(to_env, val, pg, perm))){
		if (result==0){
			break;
  8022c9:	90                   	nop
			panic("syscall returned improper error");
		}
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  8022ca:	90                   	nop
  8022cb:	c9                   	leaveq 
  8022cc:	c3                   	retq   

00000000008022cd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022cd:	55                   	push   %rbp
  8022ce:	48 89 e5             	mov    %rsp,%rbp
  8022d1:	48 83 ec 18          	sub    $0x18,%rsp
  8022d5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8022d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022df:	eb 5d                	jmp    80233e <ipc_find_env+0x71>
		if (envs[i].env_type == type)
  8022e1:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8022e8:	00 00 00 
  8022eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ee:	48 63 d0             	movslq %eax,%rdx
  8022f1:	48 89 d0             	mov    %rdx,%rax
  8022f4:	48 c1 e0 03          	shl    $0x3,%rax
  8022f8:	48 01 d0             	add    %rdx,%rax
  8022fb:	48 c1 e0 05          	shl    $0x5,%rax
  8022ff:	48 01 c8             	add    %rcx,%rax
  802302:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802308:	8b 00                	mov    (%rax),%eax
  80230a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80230d:	75 2b                	jne    80233a <ipc_find_env+0x6d>
			return envs[i].env_id;
  80230f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802316:	00 00 00 
  802319:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80231c:	48 63 d0             	movslq %eax,%rdx
  80231f:	48 89 d0             	mov    %rdx,%rax
  802322:	48 c1 e0 03          	shl    $0x3,%rax
  802326:	48 01 d0             	add    %rdx,%rax
  802329:	48 c1 e0 05          	shl    $0x5,%rax
  80232d:	48 01 c8             	add    %rcx,%rax
  802330:	48 05 c8 00 00 00    	add    $0xc8,%rax
  802336:	8b 00                	mov    (%rax),%eax
  802338:	eb 12                	jmp    80234c <ipc_find_env+0x7f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80233a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80233e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802345:	7e 9a                	jle    8022e1 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802347:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80234c:	c9                   	leaveq 
  80234d:	c3                   	retq   

000000000080234e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80234e:	55                   	push   %rbp
  80234f:	48 89 e5             	mov    %rsp,%rbp
  802352:	53                   	push   %rbx
  802353:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80235a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802361:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802367:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80236e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802375:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80237c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802383:	84 c0                	test   %al,%al
  802385:	74 23                	je     8023aa <_panic+0x5c>
  802387:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80238e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802392:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802396:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80239a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80239e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8023a2:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8023a6:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8023aa:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8023b1:	00 00 00 
  8023b4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8023bb:	00 00 00 
  8023be:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8023c2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8023c9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8023d0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8023d7:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8023de:	00 00 00 
  8023e1:	48 8b 18             	mov    (%rax),%rbx
  8023e4:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  8023eb:	00 00 00 
  8023ee:	ff d0                	callq  *%rax
  8023f0:	89 c6                	mov    %eax,%esi
  8023f2:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8023f8:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8023ff:	41 89 d0             	mov    %edx,%r8d
  802402:	48 89 c1             	mov    %rax,%rcx
  802405:	48 89 da             	mov    %rbx,%rdx
  802408:	48 bf 60 2c 80 00 00 	movabs $0x802c60,%rdi
  80240f:	00 00 00 
  802412:	b8 00 00 00 00       	mov    $0x0,%eax
  802417:	49 b9 c1 03 80 00 00 	movabs $0x8003c1,%r9
  80241e:	00 00 00 
  802421:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802424:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80242b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802432:	48 89 d6             	mov    %rdx,%rsi
  802435:	48 89 c7             	mov    %rax,%rdi
  802438:	48 b8 15 03 80 00 00 	movabs $0x800315,%rax
  80243f:	00 00 00 
  802442:	ff d0                	callq  *%rax
	cprintf("\n");
  802444:	48 bf 83 2c 80 00 00 	movabs $0x802c83,%rdi
  80244b:	00 00 00 
  80244e:	b8 00 00 00 00       	mov    $0x0,%eax
  802453:	48 ba c1 03 80 00 00 	movabs $0x8003c1,%rdx
  80245a:	00 00 00 
  80245d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80245f:	cc                   	int3   
  802460:	eb fd                	jmp    80245f <_panic+0x111>

0000000000802462 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802462:	55                   	push   %rbp
  802463:	48 89 e5             	mov    %rsp,%rbp
  802466:	48 83 ec 20          	sub    $0x20,%rsp
  80246a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler==0) {
  80246e:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  802475:	00 00 00 
  802478:	48 8b 00             	mov    (%rax),%rax
  80247b:	48 85 c0             	test   %rax,%rax
  80247e:	0f 85 ae 00 00 00    	jne    802532 <set_pgfault_handler+0xd0>
		//allocate space
		int result = sys_page_alloc(sys_getenvid(), (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  802484:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  80248b:	00 00 00 
  80248e:	ff d0                	callq  *%rax
  802490:	ba 07 00 00 00       	mov    $0x7,%edx
  802495:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80249a:	89 c7                	mov    %eax,%edi
  80249c:	48 b8 87 18 80 00 00 	movabs $0x801887,%rax
  8024a3:	00 00 00 
  8024a6:	ff d0                	callq  *%rax
  8024a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  8024ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024af:	79 2a                	jns    8024db <set_pgfault_handler+0x79>
			panic("sys_page_alloc for stack failed in setting page fault handler");
  8024b1:	48 ba 88 2c 80 00 00 	movabs $0x802c88,%rdx
  8024b8:	00 00 00 
  8024bb:	be 21 00 00 00       	mov    $0x21,%esi
  8024c0:	48 bf c6 2c 80 00 00 	movabs $0x802cc6,%rdi
  8024c7:	00 00 00 
  8024ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cf:	48 b9 4e 23 80 00 00 	movabs $0x80234e,%rcx
  8024d6:	00 00 00 
  8024d9:	ff d1                	callq  *%rcx
		}

		//actual set upcall
		result = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8024db:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  8024e2:	00 00 00 
  8024e5:	ff d0                	callq  *%rax
  8024e7:	48 be 46 25 80 00 00 	movabs $0x802546,%rsi
  8024ee:	00 00 00 
  8024f1:	89 c7                	mov    %eax,%edi
  8024f3:	48 b8 d2 19 80 00 00 	movabs $0x8019d2,%rax
  8024fa:	00 00 00 
  8024fd:	ff d0                	callq  *%rax
  8024ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  802502:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802506:	79 2a                	jns    802532 <set_pgfault_handler+0xd0>
                        panic("setting upcall failed in setting page fault handler");
  802508:	48 ba d8 2c 80 00 00 	movabs $0x802cd8,%rdx
  80250f:	00 00 00 
  802512:	be 27 00 00 00       	mov    $0x27,%esi
  802517:	48 bf c6 2c 80 00 00 	movabs $0x802cc6,%rdi
  80251e:	00 00 00 
  802521:	b8 00 00 00 00       	mov    $0x0,%eax
  802526:	48 b9 4e 23 80 00 00 	movabs $0x80234e,%rcx
  80252d:	00 00 00 
  802530:	ff d1                	callq  *%rcx
                }
		//panic("set_pgfault_handler not implemented");
	}

	_pgfault_handler = handler;
  802532:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  802539:	00 00 00 
  80253c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802540:	48 89 10             	mov    %rdx,(%rax)

}
  802543:	90                   	nop
  802544:	c9                   	leaveq 
  802545:	c3                   	retq   

0000000000802546 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  802546:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  802549:	48 a1 18 40 80 00 00 	movabs 0x804018,%rax
  802550:	00 00 00 
call *%rax
  802553:	ff d0                	callq  *%rax
	//MAKE STACK CALCS for getting parameters
	//20 = size of stack
	//8 = size of word	

	//(20-3)*8=17*8=136
	movq 136(%rsp), %rax
  802555:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  80255c:	00 
	//(20-1)*8=152
	subq $8, 152(%rsp)
  80255d:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  802564:	00 08 
	movq 152(%rsp), %rbx
  802566:	48 8b 9c 24 98 00 00 	mov    0x98(%rsp),%rbx
  80256d:	00 
	movq %rax, (%rbx)
  80256e:	48 89 03             	mov    %rax,(%rbx)
	addq $16, %rsp
  802571:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
	
    	POPA_
  802575:	4c 8b 3c 24          	mov    (%rsp),%r15
  802579:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80257e:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802583:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802588:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80258d:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802592:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802597:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80259c:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8025a1:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8025a6:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8025ab:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8025b0:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8025b5:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8025ba:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8025bf:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
	//https://www.felixcloutier.com/x86/POPF:POPFD:POPFQ.html
    	addq $8, %rsp
  8025c3:	48 83 c4 08          	add    $0x8,%rsp
    	popfq	
  8025c7:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    	popq %rsp
  8025c8:	5c                   	pop    %rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    	ret
  8025c9:	c3                   	retq   
