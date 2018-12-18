
obj/user/stresssched:     file format elf64-x86-64


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
  80003c:	e8 72 01 00 00       	callq  8001b3 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800052:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// Fork several environments
	for (i = 0; i < 20; i++)
  800061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800068:	eb 14                	jmp    80007e <umain+0x3b>
		if (fork() == 0)
  80006a:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	85 c0                	test   %eax,%eax
  800078:	74 0c                	je     800086 <umain+0x43>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  80007a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80007e:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
  800082:	7e e6                	jle    80006a <umain+0x27>
  800084:	eb 01                	jmp    800087 <umain+0x44>
		if (fork() == 0)
			break;
  800086:	90                   	nop
	if (i == 20) {
  800087:	83 7d fc 14          	cmpl   $0x14,-0x4(%rbp)
  80008b:	75 13                	jne    8000a0 <umain+0x5d>
		sys_yield();
  80008d:	48 b8 1a 19 80 00 00 	movabs $0x80191a,%rax
  800094:	00 00 00 
  800097:	ff d0                	callq  *%rax
		return;
  800099:	e9 13 01 00 00       	jmpq   8001b1 <umain+0x16e>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");
  80009e:	f3 90                	pause  
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  8000a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000a3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8000af:	00 00 00 
  8000b2:	48 63 d0             	movslq %eax,%rdx
  8000b5:	48 89 d0             	mov    %rdx,%rax
  8000b8:	48 c1 e0 03          	shl    $0x3,%rax
  8000bc:	48 01 d0             	add    %rdx,%rax
  8000bf:	48 c1 e0 05          	shl    $0x5,%rax
  8000c3:	48 01 c8             	add    %rcx,%rax
  8000c6:	48 05 d4 00 00 00    	add    $0xd4,%rax
  8000cc:	8b 00                	mov    (%rax),%eax
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	75 cc                	jne    80009e <umain+0x5b>
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  8000d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000d9:	eb 41                	jmp    80011c <umain+0xd9>
		sys_yield();
  8000db:	48 b8 1a 19 80 00 00 	movabs $0x80191a,%rax
  8000e2:	00 00 00 
  8000e5:	ff d0                	callq  *%rax
		for (j = 0; j < 10000; j++)
  8000e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8000ee:	eb 1f                	jmp    80010f <umain+0xcc>
			counter++;
  8000f0:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8000f7:	00 00 00 
  8000fa:	8b 00                	mov    (%rax),%eax
  8000fc:	8d 50 01             	lea    0x1(%rax),%edx
  8000ff:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  800106:	00 00 00 
  800109:	89 10                	mov    %edx,(%rax)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
		for (j = 0; j < 10000; j++)
  80010b:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80010f:	81 7d f8 0f 27 00 00 	cmpl   $0x270f,-0x8(%rbp)
  800116:	7e d8                	jle    8000f0 <umain+0xad>
	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  800118:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80011c:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  800120:	7e b9                	jle    8000db <umain+0x98>
		sys_yield();
		for (j = 0; j < 10000; j++)
			counter++;
	}

	if (counter != 10*10000)
  800122:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  800129:	00 00 00 
  80012c:	8b 00                	mov    (%rax),%eax
  80012e:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  800133:	74 39                	je     80016e <umain+0x12b>
		panic("ran on two CPUs at once (counter is %d)", counter);
  800135:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80013c:	00 00 00 
  80013f:	8b 00                	mov    (%rax),%eax
  800141:	89 c1                	mov    %eax,%ecx
  800143:	48 ba c0 23 80 00 00 	movabs $0x8023c0,%rdx
  80014a:	00 00 00 
  80014d:	be 21 00 00 00       	mov    $0x21,%esi
  800152:	48 bf e8 23 80 00 00 	movabs $0x8023e8,%rdi
  800159:	00 00 00 
  80015c:	b8 00 00 00 00       	mov    $0x0,%eax
  800161:	49 b8 57 02 80 00 00 	movabs $0x800257,%r8
  800168:	00 00 00 
  80016b:	41 ff d0             	callq  *%r8

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  80016e:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  800175:	00 00 00 
  800178:	48 8b 00             	mov    (%rax),%rax
  80017b:	8b 90 dc 00 00 00    	mov    0xdc(%rax),%edx
  800181:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  800188:	00 00 00 
  80018b:	48 8b 00             	mov    (%rax),%rax
  80018e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800194:	89 c6                	mov    %eax,%esi
  800196:	48 bf fb 23 80 00 00 	movabs $0x8023fb,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	48 b9 91 04 80 00 00 	movabs $0x800491,%rcx
  8001ac:	00 00 00 
  8001af:	ff d1                	callq  *%rcx

}
  8001b1:	c9                   	leaveq 
  8001b2:	c3                   	retq   

00000000008001b3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001b3:	55                   	push   %rbp
  8001b4:	48 89 e5             	mov    %rsp,%rbp
  8001b7:	48 83 ec 10          	sub    $0x10,%rsp
  8001bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  8001c2:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  8001c9:	00 00 00 
  8001cc:	ff d0                	callq  *%rax
  8001ce:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d3:	48 63 d0             	movslq %eax,%rdx
  8001d6:	48 89 d0             	mov    %rdx,%rax
  8001d9:	48 c1 e0 03          	shl    $0x3,%rax
  8001dd:	48 01 d0             	add    %rdx,%rax
  8001e0:	48 c1 e0 05          	shl    $0x5,%rax
  8001e4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001eb:	00 00 00 
  8001ee:	48 01 c2             	add    %rax,%rdx
  8001f1:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  8001f8:	00 00 00 
  8001fb:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800202:	7e 14                	jle    800218 <libmain+0x65>
		binaryname = argv[0];
  800204:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800208:	48 8b 10             	mov    (%rax),%rdx
  80020b:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800212:	00 00 00 
  800215:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800218:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80021c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80021f:	48 89 d6             	mov    %rdx,%rsi
  800222:	89 c7                	mov    %eax,%edi
  800224:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80022b:	00 00 00 
  80022e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800230:	48 b8 3f 02 80 00 00 	movabs $0x80023f,%rax
  800237:	00 00 00 
  80023a:	ff d0                	callq  *%rax
}
  80023c:	90                   	nop
  80023d:	c9                   	leaveq 
  80023e:	c3                   	retq   

000000000080023f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80023f:	55                   	push   %rbp
  800240:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800243:	bf 00 00 00 00       	mov    $0x0,%edi
  800248:	48 b8 98 18 80 00 00 	movabs $0x801898,%rax
  80024f:	00 00 00 
  800252:	ff d0                	callq  *%rax
}
  800254:	90                   	nop
  800255:	5d                   	pop    %rbp
  800256:	c3                   	retq   

0000000000800257 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800257:	55                   	push   %rbp
  800258:	48 89 e5             	mov    %rsp,%rbp
  80025b:	53                   	push   %rbx
  80025c:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800263:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80026a:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800270:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800277:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80027e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800285:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80028c:	84 c0                	test   %al,%al
  80028e:	74 23                	je     8002b3 <_panic+0x5c>
  800290:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800297:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80029b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80029f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002a3:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002a7:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002ab:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002af:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002b3:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002ba:	00 00 00 
  8002bd:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002c4:	00 00 00 
  8002c7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002cb:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002d2:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002d9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002e0:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8002e7:	00 00 00 
  8002ea:	48 8b 18             	mov    (%rax),%rbx
  8002ed:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  8002f4:	00 00 00 
  8002f7:	ff d0                	callq  *%rax
  8002f9:	89 c6                	mov    %eax,%esi
  8002fb:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800301:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800308:	41 89 d0             	mov    %edx,%r8d
  80030b:	48 89 c1             	mov    %rax,%rcx
  80030e:	48 89 da             	mov    %rbx,%rdx
  800311:	48 bf 28 24 80 00 00 	movabs $0x802428,%rdi
  800318:	00 00 00 
  80031b:	b8 00 00 00 00       	mov    $0x0,%eax
  800320:	49 b9 91 04 80 00 00 	movabs $0x800491,%r9
  800327:	00 00 00 
  80032a:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80032d:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800334:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80033b:	48 89 d6             	mov    %rdx,%rsi
  80033e:	48 89 c7             	mov    %rax,%rdi
  800341:	48 b8 e5 03 80 00 00 	movabs $0x8003e5,%rax
  800348:	00 00 00 
  80034b:	ff d0                	callq  *%rax
	cprintf("\n");
  80034d:	48 bf 4b 24 80 00 00 	movabs $0x80244b,%rdi
  800354:	00 00 00 
  800357:	b8 00 00 00 00       	mov    $0x0,%eax
  80035c:	48 ba 91 04 80 00 00 	movabs $0x800491,%rdx
  800363:	00 00 00 
  800366:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800368:	cc                   	int3   
  800369:	eb fd                	jmp    800368 <_panic+0x111>

000000000080036b <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80036b:	55                   	push   %rbp
  80036c:	48 89 e5             	mov    %rsp,%rbp
  80036f:	48 83 ec 10          	sub    $0x10,%rsp
  800373:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800376:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80037a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80037e:	8b 00                	mov    (%rax),%eax
  800380:	8d 48 01             	lea    0x1(%rax),%ecx
  800383:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800387:	89 0a                	mov    %ecx,(%rdx)
  800389:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80038c:	89 d1                	mov    %edx,%ecx
  80038e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800392:	48 98                	cltq   
  800394:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800398:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80039c:	8b 00                	mov    (%rax),%eax
  80039e:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a3:	75 2c                	jne    8003d1 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a9:	8b 00                	mov    (%rax),%eax
  8003ab:	48 98                	cltq   
  8003ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b1:	48 83 c2 08          	add    $0x8,%rdx
  8003b5:	48 89 c6             	mov    %rax,%rsi
  8003b8:	48 89 d7             	mov    %rdx,%rdi
  8003bb:	48 b8 0f 18 80 00 00 	movabs $0x80180f,%rax
  8003c2:	00 00 00 
  8003c5:	ff d0                	callq  *%rax
        b->idx = 0;
  8003c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003cb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d5:	8b 40 04             	mov    0x4(%rax),%eax
  8003d8:	8d 50 01             	lea    0x1(%rax),%edx
  8003db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003df:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003e2:	90                   	nop
  8003e3:	c9                   	leaveq 
  8003e4:	c3                   	retq   

00000000008003e5 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003e5:	55                   	push   %rbp
  8003e6:	48 89 e5             	mov    %rsp,%rbp
  8003e9:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003f0:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003f7:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003fe:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800405:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80040c:	48 8b 0a             	mov    (%rdx),%rcx
  80040f:	48 89 08             	mov    %rcx,(%rax)
  800412:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800416:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80041a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80041e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800422:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800429:	00 00 00 
    b.cnt = 0;
  80042c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800433:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800436:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80043d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800444:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80044b:	48 89 c6             	mov    %rax,%rsi
  80044e:	48 bf 6b 03 80 00 00 	movabs $0x80036b,%rdi
  800455:	00 00 00 
  800458:	48 b8 2f 08 80 00 00 	movabs $0x80082f,%rax
  80045f:	00 00 00 
  800462:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800464:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80046a:	48 98                	cltq   
  80046c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800473:	48 83 c2 08          	add    $0x8,%rdx
  800477:	48 89 c6             	mov    %rax,%rsi
  80047a:	48 89 d7             	mov    %rdx,%rdi
  80047d:	48 b8 0f 18 80 00 00 	movabs $0x80180f,%rax
  800484:	00 00 00 
  800487:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800489:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80048f:	c9                   	leaveq 
  800490:	c3                   	retq   

0000000000800491 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800491:	55                   	push   %rbp
  800492:	48 89 e5             	mov    %rsp,%rbp
  800495:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80049c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8004a3:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004aa:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004b1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004b8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004bf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004c6:	84 c0                	test   %al,%al
  8004c8:	74 20                	je     8004ea <cprintf+0x59>
  8004ca:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004ce:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004d2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004d6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004da:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004de:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004e2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004e6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004ea:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004f1:	00 00 00 
  8004f4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004fb:	00 00 00 
  8004fe:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800502:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800509:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800510:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800517:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80051e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800525:	48 8b 0a             	mov    (%rdx),%rcx
  800528:	48 89 08             	mov    %rcx,(%rax)
  80052b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80052f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800533:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800537:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80053b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800542:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800549:	48 89 d6             	mov    %rdx,%rsi
  80054c:	48 89 c7             	mov    %rax,%rdi
  80054f:	48 b8 e5 03 80 00 00 	movabs $0x8003e5,%rax
  800556:	00 00 00 
  800559:	ff d0                	callq  *%rax
  80055b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800561:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800567:	c9                   	leaveq 
  800568:	c3                   	retq   

0000000000800569 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800569:	55                   	push   %rbp
  80056a:	48 89 e5             	mov    %rsp,%rbp
  80056d:	48 83 ec 30          	sub    $0x30,%rsp
  800571:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800575:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800579:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80057d:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800580:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800584:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800588:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80058b:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80058f:	77 54                	ja     8005e5 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800591:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800594:	8d 78 ff             	lea    -0x1(%rax),%edi
  800597:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80059a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059e:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a3:	48 f7 f6             	div    %rsi
  8005a6:	49 89 c2             	mov    %rax,%r10
  8005a9:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8005ac:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8005af:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8005b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005b7:	41 89 c9             	mov    %ecx,%r9d
  8005ba:	41 89 f8             	mov    %edi,%r8d
  8005bd:	89 d1                	mov    %edx,%ecx
  8005bf:	4c 89 d2             	mov    %r10,%rdx
  8005c2:	48 89 c7             	mov    %rax,%rdi
  8005c5:	48 b8 69 05 80 00 00 	movabs $0x800569,%rax
  8005cc:	00 00 00 
  8005cf:	ff d0                	callq  *%rax
  8005d1:	eb 1c                	jmp    8005ef <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005d3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8005d7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8005da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005de:	48 89 ce             	mov    %rcx,%rsi
  8005e1:	89 d7                	mov    %edx,%edi
  8005e3:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e5:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8005e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8005ed:	7f e4                	jg     8005d3 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ef:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8005f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fb:	48 f7 f1             	div    %rcx
  8005fe:	48 b8 b0 25 80 00 00 	movabs $0x8025b0,%rax
  800605:	00 00 00 
  800608:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80060c:	0f be d0             	movsbl %al,%edx
  80060f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800613:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800617:	48 89 ce             	mov    %rcx,%rsi
  80061a:	89 d7                	mov    %edx,%edi
  80061c:	ff d0                	callq  *%rax
}
  80061e:	90                   	nop
  80061f:	c9                   	leaveq 
  800620:	c3                   	retq   

0000000000800621 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800621:	55                   	push   %rbp
  800622:	48 89 e5             	mov    %rsp,%rbp
  800625:	48 83 ec 20          	sub    $0x20,%rsp
  800629:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80062d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800630:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800634:	7e 4f                	jle    800685 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063a:	8b 00                	mov    (%rax),%eax
  80063c:	83 f8 30             	cmp    $0x30,%eax
  80063f:	73 24                	jae    800665 <getuint+0x44>
  800641:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800645:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064d:	8b 00                	mov    (%rax),%eax
  80064f:	89 c0                	mov    %eax,%eax
  800651:	48 01 d0             	add    %rdx,%rax
  800654:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800658:	8b 12                	mov    (%rdx),%edx
  80065a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80065d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800661:	89 0a                	mov    %ecx,(%rdx)
  800663:	eb 14                	jmp    800679 <getuint+0x58>
  800665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800669:	48 8b 40 08          	mov    0x8(%rax),%rax
  80066d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800671:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800675:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800679:	48 8b 00             	mov    (%rax),%rax
  80067c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800680:	e9 9d 00 00 00       	jmpq   800722 <getuint+0x101>
	else if (lflag)
  800685:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800689:	74 4c                	je     8006d7 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80068b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068f:	8b 00                	mov    (%rax),%eax
  800691:	83 f8 30             	cmp    $0x30,%eax
  800694:	73 24                	jae    8006ba <getuint+0x99>
  800696:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a2:	8b 00                	mov    (%rax),%eax
  8006a4:	89 c0                	mov    %eax,%eax
  8006a6:	48 01 d0             	add    %rdx,%rax
  8006a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ad:	8b 12                	mov    (%rdx),%edx
  8006af:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b6:	89 0a                	mov    %ecx,(%rdx)
  8006b8:	eb 14                	jmp    8006ce <getuint+0xad>
  8006ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006be:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006c2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ca:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006ce:	48 8b 00             	mov    (%rax),%rax
  8006d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d5:	eb 4b                	jmp    800722 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8006d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006db:	8b 00                	mov    (%rax),%eax
  8006dd:	83 f8 30             	cmp    $0x30,%eax
  8006e0:	73 24                	jae    800706 <getuint+0xe5>
  8006e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ee:	8b 00                	mov    (%rax),%eax
  8006f0:	89 c0                	mov    %eax,%eax
  8006f2:	48 01 d0             	add    %rdx,%rax
  8006f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f9:	8b 12                	mov    (%rdx),%edx
  8006fb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800702:	89 0a                	mov    %ecx,(%rdx)
  800704:	eb 14                	jmp    80071a <getuint+0xf9>
  800706:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80070e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800712:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800716:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80071a:	8b 00                	mov    (%rax),%eax
  80071c:	89 c0                	mov    %eax,%eax
  80071e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800722:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800726:	c9                   	leaveq 
  800727:	c3                   	retq   

0000000000800728 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800728:	55                   	push   %rbp
  800729:	48 89 e5             	mov    %rsp,%rbp
  80072c:	48 83 ec 20          	sub    $0x20,%rsp
  800730:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800734:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800737:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80073b:	7e 4f                	jle    80078c <getint+0x64>
		x=va_arg(*ap, long long);
  80073d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800741:	8b 00                	mov    (%rax),%eax
  800743:	83 f8 30             	cmp    $0x30,%eax
  800746:	73 24                	jae    80076c <getint+0x44>
  800748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800750:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800754:	8b 00                	mov    (%rax),%eax
  800756:	89 c0                	mov    %eax,%eax
  800758:	48 01 d0             	add    %rdx,%rax
  80075b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075f:	8b 12                	mov    (%rdx),%edx
  800761:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800764:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800768:	89 0a                	mov    %ecx,(%rdx)
  80076a:	eb 14                	jmp    800780 <getint+0x58>
  80076c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800770:	48 8b 40 08          	mov    0x8(%rax),%rax
  800774:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800778:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800780:	48 8b 00             	mov    (%rax),%rax
  800783:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800787:	e9 9d 00 00 00       	jmpq   800829 <getint+0x101>
	else if (lflag)
  80078c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800790:	74 4c                	je     8007de <getint+0xb6>
		x=va_arg(*ap, long);
  800792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800796:	8b 00                	mov    (%rax),%eax
  800798:	83 f8 30             	cmp    $0x30,%eax
  80079b:	73 24                	jae    8007c1 <getint+0x99>
  80079d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a9:	8b 00                	mov    (%rax),%eax
  8007ab:	89 c0                	mov    %eax,%eax
  8007ad:	48 01 d0             	add    %rdx,%rax
  8007b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b4:	8b 12                	mov    (%rdx),%edx
  8007b6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bd:	89 0a                	mov    %ecx,(%rdx)
  8007bf:	eb 14                	jmp    8007d5 <getint+0xad>
  8007c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007c9:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d5:	48 8b 00             	mov    (%rax),%rax
  8007d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007dc:	eb 4b                	jmp    800829 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8007de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e2:	8b 00                	mov    (%rax),%eax
  8007e4:	83 f8 30             	cmp    $0x30,%eax
  8007e7:	73 24                	jae    80080d <getint+0xe5>
  8007e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ed:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f5:	8b 00                	mov    (%rax),%eax
  8007f7:	89 c0                	mov    %eax,%eax
  8007f9:	48 01 d0             	add    %rdx,%rax
  8007fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800800:	8b 12                	mov    (%rdx),%edx
  800802:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800805:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800809:	89 0a                	mov    %ecx,(%rdx)
  80080b:	eb 14                	jmp    800821 <getint+0xf9>
  80080d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800811:	48 8b 40 08          	mov    0x8(%rax),%rax
  800815:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800819:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800821:	8b 00                	mov    (%rax),%eax
  800823:	48 98                	cltq   
  800825:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800829:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80082d:	c9                   	leaveq 
  80082e:	c3                   	retq   

000000000080082f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80082f:	55                   	push   %rbp
  800830:	48 89 e5             	mov    %rsp,%rbp
  800833:	41 54                	push   %r12
  800835:	53                   	push   %rbx
  800836:	48 83 ec 60          	sub    $0x60,%rsp
  80083a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80083e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800842:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800846:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80084a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80084e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800852:	48 8b 0a             	mov    (%rdx),%rcx
  800855:	48 89 08             	mov    %rcx,(%rax)
  800858:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80085c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800860:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800864:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800868:	eb 17                	jmp    800881 <vprintfmt+0x52>
			if (ch == '\0')
  80086a:	85 db                	test   %ebx,%ebx
  80086c:	0f 84 b9 04 00 00    	je     800d2b <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800872:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800876:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80087a:	48 89 d6             	mov    %rdx,%rsi
  80087d:	89 df                	mov    %ebx,%edi
  80087f:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800881:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800885:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800889:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80088d:	0f b6 00             	movzbl (%rax),%eax
  800890:	0f b6 d8             	movzbl %al,%ebx
  800893:	83 fb 25             	cmp    $0x25,%ebx
  800896:	75 d2                	jne    80086a <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800898:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80089c:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008a3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008b1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008bc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008c0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008c4:	0f b6 00             	movzbl (%rax),%eax
  8008c7:	0f b6 d8             	movzbl %al,%ebx
  8008ca:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008cd:	83 f8 55             	cmp    $0x55,%eax
  8008d0:	0f 87 22 04 00 00    	ja     800cf8 <vprintfmt+0x4c9>
  8008d6:	89 c0                	mov    %eax,%eax
  8008d8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008df:	00 
  8008e0:	48 b8 d8 25 80 00 00 	movabs $0x8025d8,%rax
  8008e7:	00 00 00 
  8008ea:	48 01 d0             	add    %rdx,%rax
  8008ed:	48 8b 00             	mov    (%rax),%rax
  8008f0:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008f2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008f6:	eb c0                	jmp    8008b8 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008f8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008fc:	eb ba                	jmp    8008b8 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008fe:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800905:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800908:	89 d0                	mov    %edx,%eax
  80090a:	c1 e0 02             	shl    $0x2,%eax
  80090d:	01 d0                	add    %edx,%eax
  80090f:	01 c0                	add    %eax,%eax
  800911:	01 d8                	add    %ebx,%eax
  800913:	83 e8 30             	sub    $0x30,%eax
  800916:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800919:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80091d:	0f b6 00             	movzbl (%rax),%eax
  800920:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800923:	83 fb 2f             	cmp    $0x2f,%ebx
  800926:	7e 60                	jle    800988 <vprintfmt+0x159>
  800928:	83 fb 39             	cmp    $0x39,%ebx
  80092b:	7f 5b                	jg     800988 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80092d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800932:	eb d1                	jmp    800905 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800934:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800937:	83 f8 30             	cmp    $0x30,%eax
  80093a:	73 17                	jae    800953 <vprintfmt+0x124>
  80093c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800940:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800943:	89 d2                	mov    %edx,%edx
  800945:	48 01 d0             	add    %rdx,%rax
  800948:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80094b:	83 c2 08             	add    $0x8,%edx
  80094e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800951:	eb 0c                	jmp    80095f <vprintfmt+0x130>
  800953:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800957:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80095b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80095f:	8b 00                	mov    (%rax),%eax
  800961:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800964:	eb 23                	jmp    800989 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800966:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80096a:	0f 89 48 ff ff ff    	jns    8008b8 <vprintfmt+0x89>
				width = 0;
  800970:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800977:	e9 3c ff ff ff       	jmpq   8008b8 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80097c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800983:	e9 30 ff ff ff       	jmpq   8008b8 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800988:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800989:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80098d:	0f 89 25 ff ff ff    	jns    8008b8 <vprintfmt+0x89>
				width = precision, precision = -1;
  800993:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800996:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800999:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009a0:	e9 13 ff ff ff       	jmpq   8008b8 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009a5:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009a9:	e9 0a ff ff ff       	jmpq   8008b8 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009ae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b1:	83 f8 30             	cmp    $0x30,%eax
  8009b4:	73 17                	jae    8009cd <vprintfmt+0x19e>
  8009b6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009ba:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009bd:	89 d2                	mov    %edx,%edx
  8009bf:	48 01 d0             	add    %rdx,%rax
  8009c2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009c5:	83 c2 08             	add    $0x8,%edx
  8009c8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009cb:	eb 0c                	jmp    8009d9 <vprintfmt+0x1aa>
  8009cd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009d1:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009d5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009d9:	8b 10                	mov    (%rax),%edx
  8009db:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009df:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e3:	48 89 ce             	mov    %rcx,%rsi
  8009e6:	89 d7                	mov    %edx,%edi
  8009e8:	ff d0                	callq  *%rax
			break;
  8009ea:	e9 37 03 00 00       	jmpq   800d26 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f2:	83 f8 30             	cmp    $0x30,%eax
  8009f5:	73 17                	jae    800a0e <vprintfmt+0x1df>
  8009f7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009fb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009fe:	89 d2                	mov    %edx,%edx
  800a00:	48 01 d0             	add    %rdx,%rax
  800a03:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a06:	83 c2 08             	add    $0x8,%edx
  800a09:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a0c:	eb 0c                	jmp    800a1a <vprintfmt+0x1eb>
  800a0e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a12:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a16:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a1a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a1c:	85 db                	test   %ebx,%ebx
  800a1e:	79 02                	jns    800a22 <vprintfmt+0x1f3>
				err = -err;
  800a20:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a22:	83 fb 15             	cmp    $0x15,%ebx
  800a25:	7f 16                	jg     800a3d <vprintfmt+0x20e>
  800a27:	48 b8 00 25 80 00 00 	movabs $0x802500,%rax
  800a2e:	00 00 00 
  800a31:	48 63 d3             	movslq %ebx,%rdx
  800a34:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a38:	4d 85 e4             	test   %r12,%r12
  800a3b:	75 2e                	jne    800a6b <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800a3d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a41:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a45:	89 d9                	mov    %ebx,%ecx
  800a47:	48 ba c1 25 80 00 00 	movabs $0x8025c1,%rdx
  800a4e:	00 00 00 
  800a51:	48 89 c7             	mov    %rax,%rdi
  800a54:	b8 00 00 00 00       	mov    $0x0,%eax
  800a59:	49 b8 35 0d 80 00 00 	movabs $0x800d35,%r8
  800a60:	00 00 00 
  800a63:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a66:	e9 bb 02 00 00       	jmpq   800d26 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a6b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a73:	4c 89 e1             	mov    %r12,%rcx
  800a76:	48 ba ca 25 80 00 00 	movabs $0x8025ca,%rdx
  800a7d:	00 00 00 
  800a80:	48 89 c7             	mov    %rax,%rdi
  800a83:	b8 00 00 00 00       	mov    $0x0,%eax
  800a88:	49 b8 35 0d 80 00 00 	movabs $0x800d35,%r8
  800a8f:	00 00 00 
  800a92:	41 ff d0             	callq  *%r8
			break;
  800a95:	e9 8c 02 00 00       	jmpq   800d26 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9d:	83 f8 30             	cmp    $0x30,%eax
  800aa0:	73 17                	jae    800ab9 <vprintfmt+0x28a>
  800aa2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800aa6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aa9:	89 d2                	mov    %edx,%edx
  800aab:	48 01 d0             	add    %rdx,%rax
  800aae:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ab1:	83 c2 08             	add    $0x8,%edx
  800ab4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ab7:	eb 0c                	jmp    800ac5 <vprintfmt+0x296>
  800ab9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800abd:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ac1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ac5:	4c 8b 20             	mov    (%rax),%r12
  800ac8:	4d 85 e4             	test   %r12,%r12
  800acb:	75 0a                	jne    800ad7 <vprintfmt+0x2a8>
				p = "(null)";
  800acd:	49 bc cd 25 80 00 00 	movabs $0x8025cd,%r12
  800ad4:	00 00 00 
			if (width > 0 && padc != '-')
  800ad7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800adb:	7e 78                	jle    800b55 <vprintfmt+0x326>
  800add:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ae1:	74 72                	je     800b55 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ae6:	48 98                	cltq   
  800ae8:	48 89 c6             	mov    %rax,%rsi
  800aeb:	4c 89 e7             	mov    %r12,%rdi
  800aee:	48 b8 e3 0f 80 00 00 	movabs $0x800fe3,%rax
  800af5:	00 00 00 
  800af8:	ff d0                	callq  *%rax
  800afa:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800afd:	eb 17                	jmp    800b16 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800aff:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b03:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0b:	48 89 ce             	mov    %rcx,%rsi
  800b0e:	89 d7                	mov    %edx,%edi
  800b10:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b12:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b16:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b1a:	7f e3                	jg     800aff <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b1c:	eb 37                	jmp    800b55 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800b1e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b22:	74 1e                	je     800b42 <vprintfmt+0x313>
  800b24:	83 fb 1f             	cmp    $0x1f,%ebx
  800b27:	7e 05                	jle    800b2e <vprintfmt+0x2ff>
  800b29:	83 fb 7e             	cmp    $0x7e,%ebx
  800b2c:	7e 14                	jle    800b42 <vprintfmt+0x313>
					putch('?', putdat);
  800b2e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b36:	48 89 d6             	mov    %rdx,%rsi
  800b39:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b3e:	ff d0                	callq  *%rax
  800b40:	eb 0f                	jmp    800b51 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800b42:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4a:	48 89 d6             	mov    %rdx,%rsi
  800b4d:	89 df                	mov    %ebx,%edi
  800b4f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b51:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b55:	4c 89 e0             	mov    %r12,%rax
  800b58:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b5c:	0f b6 00             	movzbl (%rax),%eax
  800b5f:	0f be d8             	movsbl %al,%ebx
  800b62:	85 db                	test   %ebx,%ebx
  800b64:	74 28                	je     800b8e <vprintfmt+0x35f>
  800b66:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b6a:	78 b2                	js     800b1e <vprintfmt+0x2ef>
  800b6c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b70:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b74:	79 a8                	jns    800b1e <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b76:	eb 16                	jmp    800b8e <vprintfmt+0x35f>
				putch(' ', putdat);
  800b78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b80:	48 89 d6             	mov    %rdx,%rsi
  800b83:	bf 20 00 00 00       	mov    $0x20,%edi
  800b88:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b8a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b8e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b92:	7f e4                	jg     800b78 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800b94:	e9 8d 01 00 00       	jmpq   800d26 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b99:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b9d:	be 03 00 00 00       	mov    $0x3,%esi
  800ba2:	48 89 c7             	mov    %rax,%rdi
  800ba5:	48 b8 28 07 80 00 00 	movabs $0x800728,%rax
  800bac:	00 00 00 
  800baf:	ff d0                	callq  *%rax
  800bb1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb9:	48 85 c0             	test   %rax,%rax
  800bbc:	79 1d                	jns    800bdb <vprintfmt+0x3ac>
				putch('-', putdat);
  800bbe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc6:	48 89 d6             	mov    %rdx,%rsi
  800bc9:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bce:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd4:	48 f7 d8             	neg    %rax
  800bd7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bdb:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800be2:	e9 d2 00 00 00       	jmpq   800cb9 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800be7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800beb:	be 03 00 00 00       	mov    $0x3,%esi
  800bf0:	48 89 c7             	mov    %rax,%rdi
  800bf3:	48 b8 21 06 80 00 00 	movabs $0x800621,%rax
  800bfa:	00 00 00 
  800bfd:	ff d0                	callq  *%rax
  800bff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c03:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c0a:	e9 aa 00 00 00       	jmpq   800cb9 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800c0f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c13:	be 03 00 00 00       	mov    $0x3,%esi
  800c18:	48 89 c7             	mov    %rax,%rdi
  800c1b:	48 b8 21 06 80 00 00 	movabs $0x800621,%rax
  800c22:	00 00 00 
  800c25:	ff d0                	callq  *%rax
  800c27:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c2b:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c32:	e9 82 00 00 00       	jmpq   800cb9 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800c37:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3f:	48 89 d6             	mov    %rdx,%rsi
  800c42:	bf 30 00 00 00       	mov    $0x30,%edi
  800c47:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c51:	48 89 d6             	mov    %rdx,%rsi
  800c54:	bf 78 00 00 00       	mov    $0x78,%edi
  800c59:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c5b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c5e:	83 f8 30             	cmp    $0x30,%eax
  800c61:	73 17                	jae    800c7a <vprintfmt+0x44b>
  800c63:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c67:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c6a:	89 d2                	mov    %edx,%edx
  800c6c:	48 01 d0             	add    %rdx,%rax
  800c6f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c72:	83 c2 08             	add    $0x8,%edx
  800c75:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c78:	eb 0c                	jmp    800c86 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800c7a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c7e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c82:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c86:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c89:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c8d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c94:	eb 23                	jmp    800cb9 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c96:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c9a:	be 03 00 00 00       	mov    $0x3,%esi
  800c9f:	48 89 c7             	mov    %rax,%rdi
  800ca2:	48 b8 21 06 80 00 00 	movabs $0x800621,%rax
  800ca9:	00 00 00 
  800cac:	ff d0                	callq  *%rax
  800cae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cb2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cb9:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cbe:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cc1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cc4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cc8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ccc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd0:	45 89 c1             	mov    %r8d,%r9d
  800cd3:	41 89 f8             	mov    %edi,%r8d
  800cd6:	48 89 c7             	mov    %rax,%rdi
  800cd9:	48 b8 69 05 80 00 00 	movabs $0x800569,%rax
  800ce0:	00 00 00 
  800ce3:	ff d0                	callq  *%rax
			break;
  800ce5:	eb 3f                	jmp    800d26 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ce7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ceb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cef:	48 89 d6             	mov    %rdx,%rsi
  800cf2:	89 df                	mov    %ebx,%edi
  800cf4:	ff d0                	callq  *%rax
			break;
  800cf6:	eb 2e                	jmp    800d26 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cf8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d00:	48 89 d6             	mov    %rdx,%rsi
  800d03:	bf 25 00 00 00       	mov    $0x25,%edi
  800d08:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d0f:	eb 05                	jmp    800d16 <vprintfmt+0x4e7>
  800d11:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d16:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d1a:	48 83 e8 01          	sub    $0x1,%rax
  800d1e:	0f b6 00             	movzbl (%rax),%eax
  800d21:	3c 25                	cmp    $0x25,%al
  800d23:	75 ec                	jne    800d11 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800d25:	90                   	nop
		}
	}
  800d26:	e9 3d fb ff ff       	jmpq   800868 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d2b:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d2c:	48 83 c4 60          	add    $0x60,%rsp
  800d30:	5b                   	pop    %rbx
  800d31:	41 5c                	pop    %r12
  800d33:	5d                   	pop    %rbp
  800d34:	c3                   	retq   

0000000000800d35 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d35:	55                   	push   %rbp
  800d36:	48 89 e5             	mov    %rsp,%rbp
  800d39:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d40:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d47:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d4e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800d55:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d5c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d63:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d6a:	84 c0                	test   %al,%al
  800d6c:	74 20                	je     800d8e <printfmt+0x59>
  800d6e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d72:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d76:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d7a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d7e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d82:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d86:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d8a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d8e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d95:	00 00 00 
  800d98:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d9f:	00 00 00 
  800da2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800da6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dad:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800db4:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dbb:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dc2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dc9:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800dd0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800dd7:	48 89 c7             	mov    %rax,%rdi
  800dda:	48 b8 2f 08 80 00 00 	movabs $0x80082f,%rax
  800de1:	00 00 00 
  800de4:	ff d0                	callq  *%rax
	va_end(ap);
}
  800de6:	90                   	nop
  800de7:	c9                   	leaveq 
  800de8:	c3                   	retq   

0000000000800de9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800de9:	55                   	push   %rbp
  800dea:	48 89 e5             	mov    %rsp,%rbp
  800ded:	48 83 ec 10          	sub    $0x10,%rsp
  800df1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800df4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800df8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dfc:	8b 40 10             	mov    0x10(%rax),%eax
  800dff:	8d 50 01             	lea    0x1(%rax),%edx
  800e02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e06:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e0d:	48 8b 10             	mov    (%rax),%rdx
  800e10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e14:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e18:	48 39 c2             	cmp    %rax,%rdx
  800e1b:	73 17                	jae    800e34 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e21:	48 8b 00             	mov    (%rax),%rax
  800e24:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e28:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e2c:	48 89 0a             	mov    %rcx,(%rdx)
  800e2f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e32:	88 10                	mov    %dl,(%rax)
}
  800e34:	90                   	nop
  800e35:	c9                   	leaveq 
  800e36:	c3                   	retq   

0000000000800e37 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e37:	55                   	push   %rbp
  800e38:	48 89 e5             	mov    %rsp,%rbp
  800e3b:	48 83 ec 50          	sub    $0x50,%rsp
  800e3f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e43:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e46:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e4a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e4e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e52:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e56:	48 8b 0a             	mov    (%rdx),%rcx
  800e59:	48 89 08             	mov    %rcx,(%rax)
  800e5c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e60:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e64:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e68:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e6c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e70:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e74:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e77:	48 98                	cltq   
  800e79:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e7d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e81:	48 01 d0             	add    %rdx,%rax
  800e84:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e88:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e8f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e94:	74 06                	je     800e9c <vsnprintf+0x65>
  800e96:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e9a:	7f 07                	jg     800ea3 <vsnprintf+0x6c>
		return -E_INVAL;
  800e9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea1:	eb 2f                	jmp    800ed2 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ea3:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ea7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800eab:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800eaf:	48 89 c6             	mov    %rax,%rsi
  800eb2:	48 bf e9 0d 80 00 00 	movabs $0x800de9,%rdi
  800eb9:	00 00 00 
  800ebc:	48 b8 2f 08 80 00 00 	movabs $0x80082f,%rax
  800ec3:	00 00 00 
  800ec6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ec8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ecc:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ecf:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ed2:	c9                   	leaveq 
  800ed3:	c3                   	retq   

0000000000800ed4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ed4:	55                   	push   %rbp
  800ed5:	48 89 e5             	mov    %rsp,%rbp
  800ed8:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800edf:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ee6:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800eec:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800ef3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800efa:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f01:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f08:	84 c0                	test   %al,%al
  800f0a:	74 20                	je     800f2c <snprintf+0x58>
  800f0c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f10:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f14:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f18:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f1c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f20:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f24:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f28:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f2c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f33:	00 00 00 
  800f36:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f3d:	00 00 00 
  800f40:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f44:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f4b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f52:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f59:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f60:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f67:	48 8b 0a             	mov    (%rdx),%rcx
  800f6a:	48 89 08             	mov    %rcx,(%rax)
  800f6d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f71:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f75:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f79:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f7d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f84:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f8b:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f91:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f98:	48 89 c7             	mov    %rax,%rdi
  800f9b:	48 b8 37 0e 80 00 00 	movabs $0x800e37,%rax
  800fa2:	00 00 00 
  800fa5:	ff d0                	callq  *%rax
  800fa7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fad:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fb3:	c9                   	leaveq 
  800fb4:	c3                   	retq   

0000000000800fb5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fb5:	55                   	push   %rbp
  800fb6:	48 89 e5             	mov    %rsp,%rbp
  800fb9:	48 83 ec 18          	sub    $0x18,%rsp
  800fbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fc8:	eb 09                	jmp    800fd3 <strlen+0x1e>
		n++;
  800fca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fce:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd7:	0f b6 00             	movzbl (%rax),%eax
  800fda:	84 c0                	test   %al,%al
  800fdc:	75 ec                	jne    800fca <strlen+0x15>
		n++;
	return n;
  800fde:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fe1:	c9                   	leaveq 
  800fe2:	c3                   	retq   

0000000000800fe3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fe3:	55                   	push   %rbp
  800fe4:	48 89 e5             	mov    %rsp,%rbp
  800fe7:	48 83 ec 20          	sub    $0x20,%rsp
  800feb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ff3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ffa:	eb 0e                	jmp    80100a <strnlen+0x27>
		n++;
  800ffc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801000:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801005:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80100a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80100f:	74 0b                	je     80101c <strnlen+0x39>
  801011:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801015:	0f b6 00             	movzbl (%rax),%eax
  801018:	84 c0                	test   %al,%al
  80101a:	75 e0                	jne    800ffc <strnlen+0x19>
		n++;
	return n;
  80101c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80101f:	c9                   	leaveq 
  801020:	c3                   	retq   

0000000000801021 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801021:	55                   	push   %rbp
  801022:	48 89 e5             	mov    %rsp,%rbp
  801025:	48 83 ec 20          	sub    $0x20,%rsp
  801029:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80102d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801031:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801035:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801039:	90                   	nop
  80103a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801042:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801046:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80104a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80104e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801052:	0f b6 12             	movzbl (%rdx),%edx
  801055:	88 10                	mov    %dl,(%rax)
  801057:	0f b6 00             	movzbl (%rax),%eax
  80105a:	84 c0                	test   %al,%al
  80105c:	75 dc                	jne    80103a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80105e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801062:	c9                   	leaveq 
  801063:	c3                   	retq   

0000000000801064 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801064:	55                   	push   %rbp
  801065:	48 89 e5             	mov    %rsp,%rbp
  801068:	48 83 ec 20          	sub    $0x20,%rsp
  80106c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801070:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801078:	48 89 c7             	mov    %rax,%rdi
  80107b:	48 b8 b5 0f 80 00 00 	movabs $0x800fb5,%rax
  801082:	00 00 00 
  801085:	ff d0                	callq  *%rax
  801087:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80108a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80108d:	48 63 d0             	movslq %eax,%rdx
  801090:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801094:	48 01 c2             	add    %rax,%rdx
  801097:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80109b:	48 89 c6             	mov    %rax,%rsi
  80109e:	48 89 d7             	mov    %rdx,%rdi
  8010a1:	48 b8 21 10 80 00 00 	movabs $0x801021,%rax
  8010a8:	00 00 00 
  8010ab:	ff d0                	callq  *%rax
	return dst;
  8010ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010b1:	c9                   	leaveq 
  8010b2:	c3                   	retq   

00000000008010b3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010b3:	55                   	push   %rbp
  8010b4:	48 89 e5             	mov    %rsp,%rbp
  8010b7:	48 83 ec 28          	sub    $0x28,%rsp
  8010bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010cf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010d6:	00 
  8010d7:	eb 2a                	jmp    801103 <strncpy+0x50>
		*dst++ = *src;
  8010d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010e1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010e5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010e9:	0f b6 12             	movzbl (%rdx),%edx
  8010ec:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f2:	0f b6 00             	movzbl (%rax),%eax
  8010f5:	84 c0                	test   %al,%al
  8010f7:	74 05                	je     8010fe <strncpy+0x4b>
			src++;
  8010f9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801103:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801107:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80110b:	72 cc                	jb     8010d9 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80110d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801111:	c9                   	leaveq 
  801112:	c3                   	retq   

0000000000801113 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801113:	55                   	push   %rbp
  801114:	48 89 e5             	mov    %rsp,%rbp
  801117:	48 83 ec 28          	sub    $0x28,%rsp
  80111b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80111f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801123:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80112f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801134:	74 3d                	je     801173 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801136:	eb 1d                	jmp    801155 <strlcpy+0x42>
			*dst++ = *src++;
  801138:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801140:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801144:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801148:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80114c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801150:	0f b6 12             	movzbl (%rdx),%edx
  801153:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801155:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80115a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80115f:	74 0b                	je     80116c <strlcpy+0x59>
  801161:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801165:	0f b6 00             	movzbl (%rax),%eax
  801168:	84 c0                	test   %al,%al
  80116a:	75 cc                	jne    801138 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80116c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801170:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801173:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801177:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117b:	48 29 c2             	sub    %rax,%rdx
  80117e:	48 89 d0             	mov    %rdx,%rax
}
  801181:	c9                   	leaveq 
  801182:	c3                   	retq   

0000000000801183 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801183:	55                   	push   %rbp
  801184:	48 89 e5             	mov    %rsp,%rbp
  801187:	48 83 ec 10          	sub    $0x10,%rsp
  80118b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80118f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801193:	eb 0a                	jmp    80119f <strcmp+0x1c>
		p++, q++;
  801195:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80119a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80119f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a3:	0f b6 00             	movzbl (%rax),%eax
  8011a6:	84 c0                	test   %al,%al
  8011a8:	74 12                	je     8011bc <strcmp+0x39>
  8011aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ae:	0f b6 10             	movzbl (%rax),%edx
  8011b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b5:	0f b6 00             	movzbl (%rax),%eax
  8011b8:	38 c2                	cmp    %al,%dl
  8011ba:	74 d9                	je     801195 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c0:	0f b6 00             	movzbl (%rax),%eax
  8011c3:	0f b6 d0             	movzbl %al,%edx
  8011c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ca:	0f b6 00             	movzbl (%rax),%eax
  8011cd:	0f b6 c0             	movzbl %al,%eax
  8011d0:	29 c2                	sub    %eax,%edx
  8011d2:	89 d0                	mov    %edx,%eax
}
  8011d4:	c9                   	leaveq 
  8011d5:	c3                   	retq   

00000000008011d6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011d6:	55                   	push   %rbp
  8011d7:	48 89 e5             	mov    %rsp,%rbp
  8011da:	48 83 ec 18          	sub    $0x18,%rsp
  8011de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011ea:	eb 0f                	jmp    8011fb <strncmp+0x25>
		n--, p++, q++;
  8011ec:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011fb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801200:	74 1d                	je     80121f <strncmp+0x49>
  801202:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801206:	0f b6 00             	movzbl (%rax),%eax
  801209:	84 c0                	test   %al,%al
  80120b:	74 12                	je     80121f <strncmp+0x49>
  80120d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801211:	0f b6 10             	movzbl (%rax),%edx
  801214:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801218:	0f b6 00             	movzbl (%rax),%eax
  80121b:	38 c2                	cmp    %al,%dl
  80121d:	74 cd                	je     8011ec <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80121f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801224:	75 07                	jne    80122d <strncmp+0x57>
		return 0;
  801226:	b8 00 00 00 00       	mov    $0x0,%eax
  80122b:	eb 18                	jmp    801245 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80122d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801231:	0f b6 00             	movzbl (%rax),%eax
  801234:	0f b6 d0             	movzbl %al,%edx
  801237:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123b:	0f b6 00             	movzbl (%rax),%eax
  80123e:	0f b6 c0             	movzbl %al,%eax
  801241:	29 c2                	sub    %eax,%edx
  801243:	89 d0                	mov    %edx,%eax
}
  801245:	c9                   	leaveq 
  801246:	c3                   	retq   

0000000000801247 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801247:	55                   	push   %rbp
  801248:	48 89 e5             	mov    %rsp,%rbp
  80124b:	48 83 ec 10          	sub    $0x10,%rsp
  80124f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801253:	89 f0                	mov    %esi,%eax
  801255:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801258:	eb 17                	jmp    801271 <strchr+0x2a>
		if (*s == c)
  80125a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125e:	0f b6 00             	movzbl (%rax),%eax
  801261:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801264:	75 06                	jne    80126c <strchr+0x25>
			return (char *) s;
  801266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126a:	eb 15                	jmp    801281 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80126c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801275:	0f b6 00             	movzbl (%rax),%eax
  801278:	84 c0                	test   %al,%al
  80127a:	75 de                	jne    80125a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80127c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801281:	c9                   	leaveq 
  801282:	c3                   	retq   

0000000000801283 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801283:	55                   	push   %rbp
  801284:	48 89 e5             	mov    %rsp,%rbp
  801287:	48 83 ec 10          	sub    $0x10,%rsp
  80128b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80128f:	89 f0                	mov    %esi,%eax
  801291:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801294:	eb 11                	jmp    8012a7 <strfind+0x24>
		if (*s == c)
  801296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129a:	0f b6 00             	movzbl (%rax),%eax
  80129d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012a0:	74 12                	je     8012b4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ab:	0f b6 00             	movzbl (%rax),%eax
  8012ae:	84 c0                	test   %al,%al
  8012b0:	75 e4                	jne    801296 <strfind+0x13>
  8012b2:	eb 01                	jmp    8012b5 <strfind+0x32>
		if (*s == c)
			break;
  8012b4:	90                   	nop
	return (char *) s;
  8012b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012b9:	c9                   	leaveq 
  8012ba:	c3                   	retq   

00000000008012bb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012bb:	55                   	push   %rbp
  8012bc:	48 89 e5             	mov    %rsp,%rbp
  8012bf:	48 83 ec 18          	sub    $0x18,%rsp
  8012c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012ca:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012ce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012d3:	75 06                	jne    8012db <memset+0x20>
		return v;
  8012d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d9:	eb 69                	jmp    801344 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012df:	83 e0 03             	and    $0x3,%eax
  8012e2:	48 85 c0             	test   %rax,%rax
  8012e5:	75 48                	jne    80132f <memset+0x74>
  8012e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012eb:	83 e0 03             	and    $0x3,%eax
  8012ee:	48 85 c0             	test   %rax,%rax
  8012f1:	75 3c                	jne    80132f <memset+0x74>
		c &= 0xFF;
  8012f3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012fd:	c1 e0 18             	shl    $0x18,%eax
  801300:	89 c2                	mov    %eax,%edx
  801302:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801305:	c1 e0 10             	shl    $0x10,%eax
  801308:	09 c2                	or     %eax,%edx
  80130a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80130d:	c1 e0 08             	shl    $0x8,%eax
  801310:	09 d0                	or     %edx,%eax
  801312:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801315:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801319:	48 c1 e8 02          	shr    $0x2,%rax
  80131d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801320:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801324:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801327:	48 89 d7             	mov    %rdx,%rdi
  80132a:	fc                   	cld    
  80132b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80132d:	eb 11                	jmp    801340 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80132f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801333:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801336:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80133a:	48 89 d7             	mov    %rdx,%rdi
  80133d:	fc                   	cld    
  80133e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801344:	c9                   	leaveq 
  801345:	c3                   	retq   

0000000000801346 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801346:	55                   	push   %rbp
  801347:	48 89 e5             	mov    %rsp,%rbp
  80134a:	48 83 ec 28          	sub    $0x28,%rsp
  80134e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801352:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801356:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80135a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801366:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80136a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801372:	0f 83 88 00 00 00    	jae    801400 <memmove+0xba>
  801378:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80137c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801380:	48 01 d0             	add    %rdx,%rax
  801383:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801387:	76 77                	jbe    801400 <memmove+0xba>
		s += n;
  801389:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801391:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801395:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139d:	83 e0 03             	and    $0x3,%eax
  8013a0:	48 85 c0             	test   %rax,%rax
  8013a3:	75 3b                	jne    8013e0 <memmove+0x9a>
  8013a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a9:	83 e0 03             	and    $0x3,%eax
  8013ac:	48 85 c0             	test   %rax,%rax
  8013af:	75 2f                	jne    8013e0 <memmove+0x9a>
  8013b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b5:	83 e0 03             	and    $0x3,%eax
  8013b8:	48 85 c0             	test   %rax,%rax
  8013bb:	75 23                	jne    8013e0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c1:	48 83 e8 04          	sub    $0x4,%rax
  8013c5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c9:	48 83 ea 04          	sub    $0x4,%rdx
  8013cd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013d1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013d5:	48 89 c7             	mov    %rax,%rdi
  8013d8:	48 89 d6             	mov    %rdx,%rsi
  8013db:	fd                   	std    
  8013dc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013de:	eb 1d                	jmp    8013fd <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ec:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f4:	48 89 d7             	mov    %rdx,%rdi
  8013f7:	48 89 c1             	mov    %rax,%rcx
  8013fa:	fd                   	std    
  8013fb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013fd:	fc                   	cld    
  8013fe:	eb 57                	jmp    801457 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801400:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801404:	83 e0 03             	and    $0x3,%eax
  801407:	48 85 c0             	test   %rax,%rax
  80140a:	75 36                	jne    801442 <memmove+0xfc>
  80140c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801410:	83 e0 03             	and    $0x3,%eax
  801413:	48 85 c0             	test   %rax,%rax
  801416:	75 2a                	jne    801442 <memmove+0xfc>
  801418:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141c:	83 e0 03             	and    $0x3,%eax
  80141f:	48 85 c0             	test   %rax,%rax
  801422:	75 1e                	jne    801442 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801424:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801428:	48 c1 e8 02          	shr    $0x2,%rax
  80142c:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80142f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801433:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801437:	48 89 c7             	mov    %rax,%rdi
  80143a:	48 89 d6             	mov    %rdx,%rsi
  80143d:	fc                   	cld    
  80143e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801440:	eb 15                	jmp    801457 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801446:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80144a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80144e:	48 89 c7             	mov    %rax,%rdi
  801451:	48 89 d6             	mov    %rdx,%rsi
  801454:	fc                   	cld    
  801455:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801457:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80145b:	c9                   	leaveq 
  80145c:	c3                   	retq   

000000000080145d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80145d:	55                   	push   %rbp
  80145e:	48 89 e5             	mov    %rsp,%rbp
  801461:	48 83 ec 18          	sub    $0x18,%rsp
  801465:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801469:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80146d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801471:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801475:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801479:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147d:	48 89 ce             	mov    %rcx,%rsi
  801480:	48 89 c7             	mov    %rax,%rdi
  801483:	48 b8 46 13 80 00 00 	movabs $0x801346,%rax
  80148a:	00 00 00 
  80148d:	ff d0                	callq  *%rax
}
  80148f:	c9                   	leaveq 
  801490:	c3                   	retq   

0000000000801491 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801491:	55                   	push   %rbp
  801492:	48 89 e5             	mov    %rsp,%rbp
  801495:	48 83 ec 28          	sub    $0x28,%rsp
  801499:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80149d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014b5:	eb 36                	jmp    8014ed <memcmp+0x5c>
		if (*s1 != *s2)
  8014b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bb:	0f b6 10             	movzbl (%rax),%edx
  8014be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c2:	0f b6 00             	movzbl (%rax),%eax
  8014c5:	38 c2                	cmp    %al,%dl
  8014c7:	74 1a                	je     8014e3 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cd:	0f b6 00             	movzbl (%rax),%eax
  8014d0:	0f b6 d0             	movzbl %al,%edx
  8014d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d7:	0f b6 00             	movzbl (%rax),%eax
  8014da:	0f b6 c0             	movzbl %al,%eax
  8014dd:	29 c2                	sub    %eax,%edx
  8014df:	89 d0                	mov    %edx,%eax
  8014e1:	eb 20                	jmp    801503 <memcmp+0x72>
		s1++, s2++;
  8014e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014f9:	48 85 c0             	test   %rax,%rax
  8014fc:	75 b9                	jne    8014b7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801503:	c9                   	leaveq 
  801504:	c3                   	retq   

0000000000801505 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801505:	55                   	push   %rbp
  801506:	48 89 e5             	mov    %rsp,%rbp
  801509:	48 83 ec 28          	sub    $0x28,%rsp
  80150d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801511:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801514:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801518:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80151c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801520:	48 01 d0             	add    %rdx,%rax
  801523:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801527:	eb 19                	jmp    801542 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801529:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152d:	0f b6 00             	movzbl (%rax),%eax
  801530:	0f b6 d0             	movzbl %al,%edx
  801533:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801536:	0f b6 c0             	movzbl %al,%eax
  801539:	39 c2                	cmp    %eax,%edx
  80153b:	74 11                	je     80154e <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80153d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801546:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80154a:	72 dd                	jb     801529 <memfind+0x24>
  80154c:	eb 01                	jmp    80154f <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80154e:	90                   	nop
	return (void *) s;
  80154f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801553:	c9                   	leaveq 
  801554:	c3                   	retq   

0000000000801555 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801555:	55                   	push   %rbp
  801556:	48 89 e5             	mov    %rsp,%rbp
  801559:	48 83 ec 38          	sub    $0x38,%rsp
  80155d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801561:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801565:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801568:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80156f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801576:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801577:	eb 05                	jmp    80157e <strtol+0x29>
		s++;
  801579:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80157e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801582:	0f b6 00             	movzbl (%rax),%eax
  801585:	3c 20                	cmp    $0x20,%al
  801587:	74 f0                	je     801579 <strtol+0x24>
  801589:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158d:	0f b6 00             	movzbl (%rax),%eax
  801590:	3c 09                	cmp    $0x9,%al
  801592:	74 e5                	je     801579 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801594:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801598:	0f b6 00             	movzbl (%rax),%eax
  80159b:	3c 2b                	cmp    $0x2b,%al
  80159d:	75 07                	jne    8015a6 <strtol+0x51>
		s++;
  80159f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015a4:	eb 17                	jmp    8015bd <strtol+0x68>
	else if (*s == '-')
  8015a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	3c 2d                	cmp    $0x2d,%al
  8015af:	75 0c                	jne    8015bd <strtol+0x68>
		s++, neg = 1;
  8015b1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015b6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015bd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015c1:	74 06                	je     8015c9 <strtol+0x74>
  8015c3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015c7:	75 28                	jne    8015f1 <strtol+0x9c>
  8015c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cd:	0f b6 00             	movzbl (%rax),%eax
  8015d0:	3c 30                	cmp    $0x30,%al
  8015d2:	75 1d                	jne    8015f1 <strtol+0x9c>
  8015d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d8:	48 83 c0 01          	add    $0x1,%rax
  8015dc:	0f b6 00             	movzbl (%rax),%eax
  8015df:	3c 78                	cmp    $0x78,%al
  8015e1:	75 0e                	jne    8015f1 <strtol+0x9c>
		s += 2, base = 16;
  8015e3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015e8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015ef:	eb 2c                	jmp    80161d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015f1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015f5:	75 19                	jne    801610 <strtol+0xbb>
  8015f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fb:	0f b6 00             	movzbl (%rax),%eax
  8015fe:	3c 30                	cmp    $0x30,%al
  801600:	75 0e                	jne    801610 <strtol+0xbb>
		s++, base = 8;
  801602:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801607:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80160e:	eb 0d                	jmp    80161d <strtol+0xc8>
	else if (base == 0)
  801610:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801614:	75 07                	jne    80161d <strtol+0xc8>
		base = 10;
  801616:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80161d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801621:	0f b6 00             	movzbl (%rax),%eax
  801624:	3c 2f                	cmp    $0x2f,%al
  801626:	7e 1d                	jle    801645 <strtol+0xf0>
  801628:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162c:	0f b6 00             	movzbl (%rax),%eax
  80162f:	3c 39                	cmp    $0x39,%al
  801631:	7f 12                	jg     801645 <strtol+0xf0>
			dig = *s - '0';
  801633:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801637:	0f b6 00             	movzbl (%rax),%eax
  80163a:	0f be c0             	movsbl %al,%eax
  80163d:	83 e8 30             	sub    $0x30,%eax
  801640:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801643:	eb 4e                	jmp    801693 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801649:	0f b6 00             	movzbl (%rax),%eax
  80164c:	3c 60                	cmp    $0x60,%al
  80164e:	7e 1d                	jle    80166d <strtol+0x118>
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	0f b6 00             	movzbl (%rax),%eax
  801657:	3c 7a                	cmp    $0x7a,%al
  801659:	7f 12                	jg     80166d <strtol+0x118>
			dig = *s - 'a' + 10;
  80165b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165f:	0f b6 00             	movzbl (%rax),%eax
  801662:	0f be c0             	movsbl %al,%eax
  801665:	83 e8 57             	sub    $0x57,%eax
  801668:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80166b:	eb 26                	jmp    801693 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80166d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801671:	0f b6 00             	movzbl (%rax),%eax
  801674:	3c 40                	cmp    $0x40,%al
  801676:	7e 47                	jle    8016bf <strtol+0x16a>
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	0f b6 00             	movzbl (%rax),%eax
  80167f:	3c 5a                	cmp    $0x5a,%al
  801681:	7f 3c                	jg     8016bf <strtol+0x16a>
			dig = *s - 'A' + 10;
  801683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801687:	0f b6 00             	movzbl (%rax),%eax
  80168a:	0f be c0             	movsbl %al,%eax
  80168d:	83 e8 37             	sub    $0x37,%eax
  801690:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801693:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801696:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801699:	7d 23                	jge    8016be <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80169b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016a0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016a3:	48 98                	cltq   
  8016a5:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016aa:	48 89 c2             	mov    %rax,%rdx
  8016ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016b0:	48 98                	cltq   
  8016b2:	48 01 d0             	add    %rdx,%rax
  8016b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016b9:	e9 5f ff ff ff       	jmpq   80161d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016be:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016bf:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016c4:	74 0b                	je     8016d1 <strtol+0x17c>
		*endptr = (char *) s;
  8016c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ca:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016ce:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016d5:	74 09                	je     8016e0 <strtol+0x18b>
  8016d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016db:	48 f7 d8             	neg    %rax
  8016de:	eb 04                	jmp    8016e4 <strtol+0x18f>
  8016e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016e4:	c9                   	leaveq 
  8016e5:	c3                   	retq   

00000000008016e6 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016e6:	55                   	push   %rbp
  8016e7:	48 89 e5             	mov    %rsp,%rbp
  8016ea:	48 83 ec 30          	sub    $0x30,%rsp
  8016ee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016f2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016fe:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801702:	0f b6 00             	movzbl (%rax),%eax
  801705:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801708:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80170c:	75 06                	jne    801714 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80170e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801712:	eb 6b                	jmp    80177f <strstr+0x99>

	len = strlen(str);
  801714:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801718:	48 89 c7             	mov    %rax,%rdi
  80171b:	48 b8 b5 0f 80 00 00 	movabs $0x800fb5,%rax
  801722:	00 00 00 
  801725:	ff d0                	callq  *%rax
  801727:	48 98                	cltq   
  801729:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80172d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801731:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801735:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801739:	0f b6 00             	movzbl (%rax),%eax
  80173c:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80173f:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801743:	75 07                	jne    80174c <strstr+0x66>
				return (char *) 0;
  801745:	b8 00 00 00 00       	mov    $0x0,%eax
  80174a:	eb 33                	jmp    80177f <strstr+0x99>
		} while (sc != c);
  80174c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801750:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801753:	75 d8                	jne    80172d <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801755:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801759:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80175d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801761:	48 89 ce             	mov    %rcx,%rsi
  801764:	48 89 c7             	mov    %rax,%rdi
  801767:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  80176e:	00 00 00 
  801771:	ff d0                	callq  *%rax
  801773:	85 c0                	test   %eax,%eax
  801775:	75 b6                	jne    80172d <strstr+0x47>

	return (char *) (in - 1);
  801777:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177b:	48 83 e8 01          	sub    $0x1,%rax
}
  80177f:	c9                   	leaveq 
  801780:	c3                   	retq   

0000000000801781 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801781:	55                   	push   %rbp
  801782:	48 89 e5             	mov    %rsp,%rbp
  801785:	53                   	push   %rbx
  801786:	48 83 ec 48          	sub    $0x48,%rsp
  80178a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80178d:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801790:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801794:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801798:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80179c:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017a0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017a3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017a7:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017ab:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017af:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017b3:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017b7:	4c 89 c3             	mov    %r8,%rbx
  8017ba:	cd 30                	int    $0x30
  8017bc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017c0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017c4:	74 3e                	je     801804 <syscall+0x83>
  8017c6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017cb:	7e 37                	jle    801804 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017d1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017d4:	49 89 d0             	mov    %rdx,%r8
  8017d7:	89 c1                	mov    %eax,%ecx
  8017d9:	48 ba 88 28 80 00 00 	movabs $0x802888,%rdx
  8017e0:	00 00 00 
  8017e3:	be 23 00 00 00       	mov    $0x23,%esi
  8017e8:	48 bf a5 28 80 00 00 	movabs $0x8028a5,%rdi
  8017ef:	00 00 00 
  8017f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f7:	49 b9 57 02 80 00 00 	movabs $0x800257,%r9
  8017fe:	00 00 00 
  801801:	41 ff d1             	callq  *%r9

	return ret;
  801804:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801808:	48 83 c4 48          	add    $0x48,%rsp
  80180c:	5b                   	pop    %rbx
  80180d:	5d                   	pop    %rbp
  80180e:	c3                   	retq   

000000000080180f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80180f:	55                   	push   %rbp
  801810:	48 89 e5             	mov    %rsp,%rbp
  801813:	48 83 ec 10          	sub    $0x10,%rsp
  801817:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80181b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80181f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801823:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801827:	48 83 ec 08          	sub    $0x8,%rsp
  80182b:	6a 00                	pushq  $0x0
  80182d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801833:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801839:	48 89 d1             	mov    %rdx,%rcx
  80183c:	48 89 c2             	mov    %rax,%rdx
  80183f:	be 00 00 00 00       	mov    $0x0,%esi
  801844:	bf 00 00 00 00       	mov    $0x0,%edi
  801849:	48 b8 81 17 80 00 00 	movabs $0x801781,%rax
  801850:	00 00 00 
  801853:	ff d0                	callq  *%rax
  801855:	48 83 c4 10          	add    $0x10,%rsp
}
  801859:	90                   	nop
  80185a:	c9                   	leaveq 
  80185b:	c3                   	retq   

000000000080185c <sys_cgetc>:

int
sys_cgetc(void)
{
  80185c:	55                   	push   %rbp
  80185d:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801860:	48 83 ec 08          	sub    $0x8,%rsp
  801864:	6a 00                	pushq  $0x0
  801866:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80186c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801872:	b9 00 00 00 00       	mov    $0x0,%ecx
  801877:	ba 00 00 00 00       	mov    $0x0,%edx
  80187c:	be 00 00 00 00       	mov    $0x0,%esi
  801881:	bf 01 00 00 00       	mov    $0x1,%edi
  801886:	48 b8 81 17 80 00 00 	movabs $0x801781,%rax
  80188d:	00 00 00 
  801890:	ff d0                	callq  *%rax
  801892:	48 83 c4 10          	add    $0x10,%rsp
}
  801896:	c9                   	leaveq 
  801897:	c3                   	retq   

0000000000801898 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801898:	55                   	push   %rbp
  801899:	48 89 e5             	mov    %rsp,%rbp
  80189c:	48 83 ec 10          	sub    $0x10,%rsp
  8018a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a6:	48 98                	cltq   
  8018a8:	48 83 ec 08          	sub    $0x8,%rsp
  8018ac:	6a 00                	pushq  $0x0
  8018ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018bf:	48 89 c2             	mov    %rax,%rdx
  8018c2:	be 01 00 00 00       	mov    $0x1,%esi
  8018c7:	bf 03 00 00 00       	mov    $0x3,%edi
  8018cc:	48 b8 81 17 80 00 00 	movabs $0x801781,%rax
  8018d3:	00 00 00 
  8018d6:	ff d0                	callq  *%rax
  8018d8:	48 83 c4 10          	add    $0x10,%rsp
}
  8018dc:	c9                   	leaveq 
  8018dd:	c3                   	retq   

00000000008018de <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018de:	55                   	push   %rbp
  8018df:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018e2:	48 83 ec 08          	sub    $0x8,%rsp
  8018e6:	6a 00                	pushq  $0x0
  8018e8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fe:	be 00 00 00 00       	mov    $0x0,%esi
  801903:	bf 02 00 00 00       	mov    $0x2,%edi
  801908:	48 b8 81 17 80 00 00 	movabs $0x801781,%rax
  80190f:	00 00 00 
  801912:	ff d0                	callq  *%rax
  801914:	48 83 c4 10          	add    $0x10,%rsp
}
  801918:	c9                   	leaveq 
  801919:	c3                   	retq   

000000000080191a <sys_yield>:

void
sys_yield(void)
{
  80191a:	55                   	push   %rbp
  80191b:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80191e:	48 83 ec 08          	sub    $0x8,%rsp
  801922:	6a 00                	pushq  $0x0
  801924:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801930:	b9 00 00 00 00       	mov    $0x0,%ecx
  801935:	ba 00 00 00 00       	mov    $0x0,%edx
  80193a:	be 00 00 00 00       	mov    $0x0,%esi
  80193f:	bf 0a 00 00 00       	mov    $0xa,%edi
  801944:	48 b8 81 17 80 00 00 	movabs $0x801781,%rax
  80194b:	00 00 00 
  80194e:	ff d0                	callq  *%rax
  801950:	48 83 c4 10          	add    $0x10,%rsp
}
  801954:	90                   	nop
  801955:	c9                   	leaveq 
  801956:	c3                   	retq   

0000000000801957 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801957:	55                   	push   %rbp
  801958:	48 89 e5             	mov    %rsp,%rbp
  80195b:	48 83 ec 10          	sub    $0x10,%rsp
  80195f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801962:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801966:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801969:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80196c:	48 63 c8             	movslq %eax,%rcx
  80196f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801973:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801976:	48 98                	cltq   
  801978:	48 83 ec 08          	sub    $0x8,%rsp
  80197c:	6a 00                	pushq  $0x0
  80197e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801984:	49 89 c8             	mov    %rcx,%r8
  801987:	48 89 d1             	mov    %rdx,%rcx
  80198a:	48 89 c2             	mov    %rax,%rdx
  80198d:	be 01 00 00 00       	mov    $0x1,%esi
  801992:	bf 04 00 00 00       	mov    $0x4,%edi
  801997:	48 b8 81 17 80 00 00 	movabs $0x801781,%rax
  80199e:	00 00 00 
  8019a1:	ff d0                	callq  *%rax
  8019a3:	48 83 c4 10          	add    $0x10,%rsp
}
  8019a7:	c9                   	leaveq 
  8019a8:	c3                   	retq   

00000000008019a9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019a9:	55                   	push   %rbp
  8019aa:	48 89 e5             	mov    %rsp,%rbp
  8019ad:	48 83 ec 20          	sub    $0x20,%rsp
  8019b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019b8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019bb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019bf:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019c3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019c6:	48 63 c8             	movslq %eax,%rcx
  8019c9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019d0:	48 63 f0             	movslq %eax,%rsi
  8019d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019da:	48 98                	cltq   
  8019dc:	48 83 ec 08          	sub    $0x8,%rsp
  8019e0:	51                   	push   %rcx
  8019e1:	49 89 f9             	mov    %rdi,%r9
  8019e4:	49 89 f0             	mov    %rsi,%r8
  8019e7:	48 89 d1             	mov    %rdx,%rcx
  8019ea:	48 89 c2             	mov    %rax,%rdx
  8019ed:	be 01 00 00 00       	mov    $0x1,%esi
  8019f2:	bf 05 00 00 00       	mov    $0x5,%edi
  8019f7:	48 b8 81 17 80 00 00 	movabs $0x801781,%rax
  8019fe:	00 00 00 
  801a01:	ff d0                	callq  *%rax
  801a03:	48 83 c4 10          	add    $0x10,%rsp
}
  801a07:	c9                   	leaveq 
  801a08:	c3                   	retq   

0000000000801a09 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a09:	55                   	push   %rbp
  801a0a:	48 89 e5             	mov    %rsp,%rbp
  801a0d:	48 83 ec 10          	sub    $0x10,%rsp
  801a11:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a1f:	48 98                	cltq   
  801a21:	48 83 ec 08          	sub    $0x8,%rsp
  801a25:	6a 00                	pushq  $0x0
  801a27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a2d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a33:	48 89 d1             	mov    %rdx,%rcx
  801a36:	48 89 c2             	mov    %rax,%rdx
  801a39:	be 01 00 00 00       	mov    $0x1,%esi
  801a3e:	bf 06 00 00 00       	mov    $0x6,%edi
  801a43:	48 b8 81 17 80 00 00 	movabs $0x801781,%rax
  801a4a:	00 00 00 
  801a4d:	ff d0                	callq  *%rax
  801a4f:	48 83 c4 10          	add    $0x10,%rsp
}
  801a53:	c9                   	leaveq 
  801a54:	c3                   	retq   

0000000000801a55 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a55:	55                   	push   %rbp
  801a56:	48 89 e5             	mov    %rsp,%rbp
  801a59:	48 83 ec 10          	sub    $0x10,%rsp
  801a5d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a60:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a66:	48 63 d0             	movslq %eax,%rdx
  801a69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6c:	48 98                	cltq   
  801a6e:	48 83 ec 08          	sub    $0x8,%rsp
  801a72:	6a 00                	pushq  $0x0
  801a74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a80:	48 89 d1             	mov    %rdx,%rcx
  801a83:	48 89 c2             	mov    %rax,%rdx
  801a86:	be 01 00 00 00       	mov    $0x1,%esi
  801a8b:	bf 08 00 00 00       	mov    $0x8,%edi
  801a90:	48 b8 81 17 80 00 00 	movabs $0x801781,%rax
  801a97:	00 00 00 
  801a9a:	ff d0                	callq  *%rax
  801a9c:	48 83 c4 10          	add    $0x10,%rsp
}
  801aa0:	c9                   	leaveq 
  801aa1:	c3                   	retq   

0000000000801aa2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801aa2:	55                   	push   %rbp
  801aa3:	48 89 e5             	mov    %rsp,%rbp
  801aa6:	48 83 ec 10          	sub    $0x10,%rsp
  801aaa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ab1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab8:	48 98                	cltq   
  801aba:	48 83 ec 08          	sub    $0x8,%rsp
  801abe:	6a 00                	pushq  $0x0
  801ac0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801acc:	48 89 d1             	mov    %rdx,%rcx
  801acf:	48 89 c2             	mov    %rax,%rdx
  801ad2:	be 01 00 00 00       	mov    $0x1,%esi
  801ad7:	bf 09 00 00 00       	mov    $0x9,%edi
  801adc:	48 b8 81 17 80 00 00 	movabs $0x801781,%rax
  801ae3:	00 00 00 
  801ae6:	ff d0                	callq  *%rax
  801ae8:	48 83 c4 10          	add    $0x10,%rsp
}
  801aec:	c9                   	leaveq 
  801aed:	c3                   	retq   

0000000000801aee <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801aee:	55                   	push   %rbp
  801aef:	48 89 e5             	mov    %rsp,%rbp
  801af2:	48 83 ec 20          	sub    $0x20,%rsp
  801af6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801afd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b01:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b04:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b07:	48 63 f0             	movslq %eax,%rsi
  801b0a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b11:	48 98                	cltq   
  801b13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b17:	48 83 ec 08          	sub    $0x8,%rsp
  801b1b:	6a 00                	pushq  $0x0
  801b1d:	49 89 f1             	mov    %rsi,%r9
  801b20:	49 89 c8             	mov    %rcx,%r8
  801b23:	48 89 d1             	mov    %rdx,%rcx
  801b26:	48 89 c2             	mov    %rax,%rdx
  801b29:	be 00 00 00 00       	mov    $0x0,%esi
  801b2e:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b33:	48 b8 81 17 80 00 00 	movabs $0x801781,%rax
  801b3a:	00 00 00 
  801b3d:	ff d0                	callq  *%rax
  801b3f:	48 83 c4 10          	add    $0x10,%rsp
}
  801b43:	c9                   	leaveq 
  801b44:	c3                   	retq   

0000000000801b45 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b45:	55                   	push   %rbp
  801b46:	48 89 e5             	mov    %rsp,%rbp
  801b49:	48 83 ec 10          	sub    $0x10,%rsp
  801b4d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b55:	48 83 ec 08          	sub    $0x8,%rsp
  801b59:	6a 00                	pushq  $0x0
  801b5b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b67:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b6c:	48 89 c2             	mov    %rax,%rdx
  801b6f:	be 01 00 00 00       	mov    $0x1,%esi
  801b74:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b79:	48 b8 81 17 80 00 00 	movabs $0x801781,%rax
  801b80:	00 00 00 
  801b83:	ff d0                	callq  *%rax
  801b85:	48 83 c4 10          	add    $0x10,%rsp
}
  801b89:	c9                   	leaveq 
  801b8a:	c3                   	retq   

0000000000801b8b <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801b8b:	55                   	push   %rbp
  801b8c:	48 89 e5             	mov    %rsp,%rbp
  801b8f:	53                   	push   %rbx
  801b90:	48 83 ec 38          	sub    $0x38,%rsp
  801b94:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = ROUNDDOWN((void *) utf->utf_fault_va, PGSIZE);
  801b98:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b9c:	48 8b 00             	mov    (%rax),%rax
  801b9f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801ba3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801bad:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801bb1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801bb5:	48 8b 40 08          	mov    0x8(%rax),%rax
  801bb9:	89 45 dc             	mov    %eax,-0x24(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//err is not a writing error & permissions are not PTE_COW
	if (!((uvpt[(uint64_t)addr/PGSIZE] & PTE_COW) && (err & FEC_WR))){
  801bbc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bc0:	48 c1 e8 0c          	shr    $0xc,%rax
  801bc4:	48 89 c2             	mov    %rax,%rdx
  801bc7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bce:	01 00 00 
  801bd1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bd5:	25 00 08 00 00       	and    $0x800,%eax
  801bda:	48 85 c0             	test   %rax,%rax
  801bdd:	74 0a                	je     801be9 <pgfault+0x5e>
  801bdf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801be2:	83 e0 02             	and    $0x2,%eax
  801be5:	85 c0                	test   %eax,%eax
  801be7:	75 2a                	jne    801c13 <pgfault+0x88>
		panic("not proper page fault");	
  801be9:	48 ba b8 28 80 00 00 	movabs $0x8028b8,%rdx
  801bf0:	00 00 00 
  801bf3:	be 1e 00 00 00       	mov    $0x1e,%esi
  801bf8:	48 bf ce 28 80 00 00 	movabs $0x8028ce,%rdi
  801bff:	00 00 00 
  801c02:	b8 00 00 00 00       	mov    $0x0,%eax
  801c07:	48 b9 57 02 80 00 00 	movabs $0x800257,%rcx
  801c0e:	00 00 00 
  801c11:	ff d1                	callq  *%rcx
	// LAB 4: Your code here.
	
	int result;

	//allocate new page & map it
	result = sys_page_alloc(sys_getenvid(), PFTEMP, PTE_P|PTE_U|PTE_W);
  801c13:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  801c1a:	00 00 00 
  801c1d:	ff d0                	callq  *%rax
  801c1f:	ba 07 00 00 00       	mov    $0x7,%edx
  801c24:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c29:	89 c7                	mov    %eax,%edi
  801c2b:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  801c32:	00 00 00 
  801c35:	ff d0                	callq  *%rax
  801c37:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801c3a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c3e:	79 2a                	jns    801c6a <pgfault+0xdf>
		panic("page allocation failed in copy-on-write faulting page");
  801c40:	48 ba e0 28 80 00 00 	movabs $0x8028e0,%rdx
  801c47:	00 00 00 
  801c4a:	be 2f 00 00 00       	mov    $0x2f,%esi
  801c4f:	48 bf ce 28 80 00 00 	movabs $0x8028ce,%rdi
  801c56:	00 00 00 
  801c59:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5e:	48 b9 57 02 80 00 00 	movabs $0x800257,%rcx
  801c65:	00 00 00 
  801c68:	ff d1                	callq  *%rcx
	}
	
	//copy page
	memcpy(PFTEMP, addr, PGSIZE);
  801c6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c6e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c73:	48 89 c6             	mov    %rax,%rsi
  801c76:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801c7b:	48 b8 5d 14 80 00 00 	movabs $0x80145d,%rax
  801c82:	00 00 00 
  801c85:	ff d0                	callq  *%rax
	
	//map new page into original page's space
	result = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_W|PTE_U|PTE_P);
  801c87:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  801c8e:	00 00 00 
  801c91:	ff d0                	callq  *%rax
  801c93:	89 c3                	mov    %eax,%ebx
  801c95:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  801c9c:	00 00 00 
  801c9f:	ff d0                	callq  *%rax
  801ca1:	89 c7                	mov    %eax,%edi
  801ca3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ca7:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801cad:	48 89 c1             	mov    %rax,%rcx
  801cb0:	89 da                	mov    %ebx,%edx
  801cb2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cb7:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  801cbe:	00 00 00 
  801cc1:	ff d0                	callq  *%rax
  801cc3:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801cc6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801cca:	79 2a                	jns    801cf6 <pgfault+0x16b>
                panic("page mapping failed in copy-on-write faulting page");
  801ccc:	48 ba 18 29 80 00 00 	movabs $0x802918,%rdx
  801cd3:	00 00 00 
  801cd6:	be 38 00 00 00       	mov    $0x38,%esi
  801cdb:	48 bf ce 28 80 00 00 	movabs $0x8028ce,%rdi
  801ce2:	00 00 00 
  801ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cea:	48 b9 57 02 80 00 00 	movabs $0x800257,%rcx
  801cf1:	00 00 00 
  801cf4:	ff d1                	callq  *%rcx
        }

	//delete temporary location
	result = sys_page_unmap(sys_getenvid(), PFTEMP);
  801cf6:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  801cfd:	00 00 00 
  801d00:	ff d0                	callq  *%rax
  801d02:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d07:	89 c7                	mov    %eax,%edi
  801d09:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801d10:	00 00 00 
  801d13:	ff d0                	callq  *%rax
  801d15:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801d18:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801d1c:	79 2a                	jns    801d48 <pgfault+0x1bd>
                panic("temporary page unmapping failed in copy-on-write faulting page");
  801d1e:	48 ba 50 29 80 00 00 	movabs $0x802950,%rdx
  801d25:	00 00 00 
  801d28:	be 3e 00 00 00       	mov    $0x3e,%esi
  801d2d:	48 bf ce 28 80 00 00 	movabs $0x8028ce,%rdi
  801d34:	00 00 00 
  801d37:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3c:	48 b9 57 02 80 00 00 	movabs $0x800257,%rcx
  801d43:	00 00 00 
  801d46:	ff d1                	callq  *%rcx
        }	

	//panic("pgfault not implemented");

}
  801d48:	90                   	nop
  801d49:	48 83 c4 38          	add    $0x38,%rsp
  801d4d:	5b                   	pop    %rbx
  801d4e:	5d                   	pop    %rbp
  801d4f:	c3                   	retq   

0000000000801d50 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d50:	55                   	push   %rbp
  801d51:	48 89 e5             	mov    %rsp,%rbp
  801d54:	53                   	push   %rbx
  801d55:	48 83 ec 28          	sub    $0x28,%rsp
  801d59:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801d5c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uint64_t)pn*PGSIZE);	
  801d5f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801d62:	48 c1 e0 0c          	shl    $0xc,%rax
  801d66:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result;

	//COW or writable
	if ((uvpt[pn]&PTE_COW) || (uvpt[pn]&PTE_W)){
  801d6a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d71:	01 00 00 
  801d74:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801d77:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d7b:	25 00 08 00 00       	and    $0x800,%eax
  801d80:	48 85 c0             	test   %rax,%rax
  801d83:	75 1d                	jne    801da2 <duppage+0x52>
  801d85:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d8c:	01 00 00 
  801d8f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801d92:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d96:	83 e0 02             	and    $0x2,%eax
  801d99:	48 85 c0             	test   %rax,%rax
  801d9c:	0f 84 8f 00 00 00    	je     801e31 <duppage+0xe1>
		//map to child
		result = sys_page_map(sys_getenvid(), addr, envid, addr, PTE_COW|PTE_U|PTE_P);
  801da2:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  801da9:	00 00 00 
  801dac:	ff d0                	callq  *%rax
  801dae:	89 c7                	mov    %eax,%edi
  801db0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801db4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801db7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dbb:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801dc1:	48 89 c6             	mov    %rax,%rsi
  801dc4:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  801dcb:	00 00 00 
  801dce:	ff d0                	callq  *%rax
  801dd0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (result<0){
  801dd3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801dd7:	79 0a                	jns    801de3 <duppage+0x93>
			return -1;
  801dd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801dde:	e9 91 00 00 00       	jmpq   801e74 <duppage+0x124>
		}

		//remap page with proper permissions COW
		result = sys_page_map(sys_getenvid(), addr, sys_getenvid(), addr, PTE_COW|PTE_U|PTE_P);
  801de3:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  801dea:	00 00 00 
  801ded:	ff d0                	callq  *%rax
  801def:	89 c3                	mov    %eax,%ebx
  801df1:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  801df8:	00 00 00 
  801dfb:	ff d0                	callq  *%rax
  801dfd:	89 c7                	mov    %eax,%edi
  801dff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e07:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801e0d:	48 89 d1             	mov    %rdx,%rcx
  801e10:	89 da                	mov    %ebx,%edx
  801e12:	48 89 c6             	mov    %rax,%rsi
  801e15:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  801e1c:	00 00 00 
  801e1f:	ff d0                	callq  *%rax
  801e21:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (result<0){
  801e24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801e28:	79 45                	jns    801e6f <duppage+0x11f>
                        return -1;
  801e2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801e2f:	eb 43                	jmp    801e74 <duppage+0x124>
                } 	
	//not proper permissions
	}else{
		result=sys_page_map(sys_getenvid(), addr, envid, addr, PTE_P|PTE_U);
  801e31:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  801e38:	00 00 00 
  801e3b:	ff d0                	callq  *%rax
  801e3d:	89 c7                	mov    %eax,%edi
  801e3f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e43:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801e46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e4a:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  801e50:	48 89 c6             	mov    %rax,%rsi
  801e53:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  801e5a:	00 00 00 
  801e5d:	ff d0                	callq  *%rax
  801e5f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (result<0){
  801e62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801e66:	79 07                	jns    801e6f <duppage+0x11f>
			return -1;
  801e68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801e6d:	eb 05                	jmp    801e74 <duppage+0x124>
		}
	}

	//panic("duppage not implemented");
	return 0;
  801e6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e74:	48 83 c4 28          	add    $0x28,%rsp
  801e78:	5b                   	pop    %rbx
  801e79:	5d                   	pop    %rbp
  801e7a:	c3                   	retq   

0000000000801e7b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801e7b:	55                   	push   %rbp
  801e7c:	48 89 e5             	mov    %rsp,%rbp
  801e7f:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	//LOOKED AT DUMBFORK FOR HELP :)	


	//step 1 
	set_pgfault_handler(pgfault);
  801e83:	48 bf 8b 1b 80 00 00 	movabs $0x801b8b,%rdi
  801e8a:	00 00 00 
  801e8d:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  801e94:	00 00 00 
  801e97:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801e99:	b8 07 00 00 00       	mov    $0x7,%eax
  801e9e:	cd 30                	int    $0x30
  801ea0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801ea3:	8b 45 e8             	mov    -0x18(%rbp),%eax
	
	//step 2
	envid_t child = sys_exofork();
  801ea6:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (child==0){
  801ea9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ead:	75 46                	jne    801ef5 <fork+0x7a>
		//fix env in child
		thisenv = &envs[ENVX(sys_getenvid())];
  801eaf:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  801eb6:	00 00 00 
  801eb9:	ff d0                	callq  *%rax
  801ebb:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ec0:	48 63 d0             	movslq %eax,%rdx
  801ec3:	48 89 d0             	mov    %rdx,%rax
  801ec6:	48 c1 e0 03          	shl    $0x3,%rax
  801eca:	48 01 d0             	add    %rdx,%rax
  801ecd:	48 c1 e0 05          	shl    $0x5,%rax
  801ed1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801ed8:	00 00 00 
  801edb:	48 01 c2             	add    %rax,%rdx
  801ede:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  801ee5:	00 00 00 
  801ee8:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801eeb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef0:	e9 2b 03 00 00       	jmpq   802220 <fork+0x3a5>
	}
	if(child<0){
  801ef5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ef9:	79 0a                	jns    801f05 <fork+0x8a>
		return -1; //exofork failed
  801efb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801f00:	e9 1b 03 00 00       	jmpq   802220 <fork+0x3a5>

//For each writable or copy-on-write page in its address space below UTOP, the parent calls duppage, which should map the page copy-on-write into the address space of the child and then remap the page copy-on-write in its own address space. duppage sets both PTEs so that the page is not writeable, and to contain PTE_COW in the "avail" field to distinguish copy-on-write pages from genuine read-only pages.

	uintptr_t addr;
	extern unsigned char end[];
	for (addr = (uintptr_t)UTEXT; addr < (uintptr_t)end; addr += PGSIZE){//taken from dumbfork
  801f05:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  801f0c:	00 
  801f0d:	e9 ec 00 00 00       	jmpq   801ffe <fork+0x183>
		
		//check if page is copy on write
		int perms = (uvpml4e[VPML4E(addr)] & PTE_P);
  801f12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f16:	48 c1 e8 27          	shr    $0x27,%rax
  801f1a:	48 89 c2             	mov    %rax,%rdx
  801f1d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f24:	01 00 00 
  801f27:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f2b:	83 e0 01             	and    $0x1,%eax
  801f2e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpde[VPDPE(addr)] & PTE_P);
  801f31:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f35:	74 28                	je     801f5f <fork+0xe4>
  801f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f3b:	48 c1 e8 1e          	shr    $0x1e,%rax
  801f3f:	48 89 c2             	mov    %rax,%rdx
  801f42:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801f49:	01 00 00 
  801f4c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f50:	83 e0 01             	and    $0x1,%eax
  801f53:	48 85 c0             	test   %rax,%rax
  801f56:	74 07                	je     801f5f <fork+0xe4>
  801f58:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5d:	eb 05                	jmp    801f64 <fork+0xe9>
  801f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f64:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpd[VPD(addr)] & PTE_P);		
  801f67:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f6b:	74 28                	je     801f95 <fork+0x11a>
  801f6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f71:	48 c1 e8 15          	shr    $0x15,%rax
  801f75:	48 89 c2             	mov    %rax,%rdx
  801f78:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f7f:	01 00 00 
  801f82:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f86:	83 e0 01             	and    $0x1,%eax
  801f89:	48 85 c0             	test   %rax,%rax
  801f8c:	74 07                	je     801f95 <fork+0x11a>
  801f8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f93:	eb 05                	jmp    801f9a <fork+0x11f>
  801f95:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9a:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpt[PGNUM(addr)] & (PTE_P | PTE_U));
  801f9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801fa1:	74 28                	je     801fcb <fork+0x150>
  801fa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa7:	48 c1 e8 0c          	shr    $0xc,%rax
  801fab:	48 89 c2             	mov    %rax,%rdx
  801fae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fb5:	01 00 00 
  801fb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fbc:	83 e0 05             	and    $0x5,%eax
  801fbf:	48 85 c0             	test   %rax,%rax
  801fc2:	74 07                	je     801fcb <fork+0x150>
  801fc4:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc9:	eb 05                	jmp    801fd0 <fork+0x155>
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd0:	89 45 f0             	mov    %eax,-0x10(%rbp)

		if (perms){
  801fd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801fd7:	74 1d                	je     801ff6 <fork+0x17b>
			duppage(child, PGNUM(addr));
  801fd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fdd:	48 c1 e8 0c          	shr    $0xc,%rax
  801fe1:	89 c2                	mov    %eax,%edx
  801fe3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fe6:	89 d6                	mov    %edx,%esi
  801fe8:	89 c7                	mov    %eax,%edi
  801fea:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  801ff1:	00 00 00 
  801ff4:	ff d0                	callq  *%rax

//For each writable or copy-on-write page in its address space below UTOP, the parent calls duppage, which should map the page copy-on-write into the address space of the child and then remap the page copy-on-write in its own address space. duppage sets both PTEs so that the page is not writeable, and to contain PTE_COW in the "avail" field to distinguish copy-on-write pages from genuine read-only pages.

	uintptr_t addr;
	extern unsigned char end[];
	for (addr = (uintptr_t)UTEXT; addr < (uintptr_t)end; addr += PGSIZE){//taken from dumbfork
  801ff6:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  801ffd:	00 
  801ffe:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  802005:	00 00 00 
  802008:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80200c:	0f 82 00 ff ff ff    	jb     801f12 <fork+0x97>
//The exception stack is not remapped this way, however. Instead you need to allocate a fresh page in the child for the exception stack. Since the page fault handler will be doing the actual copying and the page fault handler runs on the exception stack, the exception stack cannot be made copy-on-write: who would copy it?

	int result;

        //allocate new page & map it
        result = sys_page_alloc(sys_getenvid(), PFTEMP, PTE_P|PTE_U|PTE_W);
  802012:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  802019:	00 00 00 
  80201c:	ff d0                	callq  *%rax
  80201e:	ba 07 00 00 00       	mov    $0x7,%edx
  802023:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802028:	89 c7                	mov    %eax,%edi
  80202a:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  802031:	00 00 00 
  802034:	ff d0                	callq  *%rax
  802036:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  802039:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80203d:	79 2a                	jns    802069 <fork+0x1ee>
                panic("page allocation failed in fork");
  80203f:	48 ba 90 29 80 00 00 	movabs $0x802990,%rdx
  802046:	00 00 00 
  802049:	be b0 00 00 00       	mov    $0xb0,%esi
  80204e:	48 bf ce 28 80 00 00 	movabs $0x8028ce,%rdi
  802055:	00 00 00 
  802058:	b8 00 00 00 00       	mov    $0x0,%eax
  80205d:	48 b9 57 02 80 00 00 	movabs $0x800257,%rcx
  802064:	00 00 00 
  802067:	ff d1                	callq  *%rcx
        }

        //copy page
        memcpy(PFTEMP, (void *)(USTACKTOP-PGSIZE), PGSIZE);
  802069:	ba 00 10 00 00       	mov    $0x1000,%edx
  80206e:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802073:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802078:	48 b8 5d 14 80 00 00 	movabs $0x80145d,%rax
  80207f:	00 00 00 
  802082:	ff d0                	callq  *%rax

        //map new page into original page's space
        result = sys_page_map(sys_getenvid(), PFTEMP, child,(void *)(USTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  802084:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  80208b:	00 00 00 
  80208e:	ff d0                	callq  *%rax
  802090:	89 c7                	mov    %eax,%edi
  802092:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802095:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80209b:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8020a0:	89 c2                	mov    %eax,%edx
  8020a2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020a7:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  8020ae:	00 00 00 
  8020b1:	ff d0                	callq  *%rax
  8020b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  8020b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020ba:	79 2a                	jns    8020e6 <fork+0x26b>
                panic("page mapping failed in fork");
  8020bc:	48 ba af 29 80 00 00 	movabs $0x8029af,%rdx
  8020c3:	00 00 00 
  8020c6:	be b9 00 00 00       	mov    $0xb9,%esi
  8020cb:	48 bf ce 28 80 00 00 	movabs $0x8028ce,%rdi
  8020d2:	00 00 00 
  8020d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020da:	48 b9 57 02 80 00 00 	movabs $0x800257,%rcx
  8020e1:	00 00 00 
  8020e4:	ff d1                	callq  *%rcx
        }

        //delete temporary location
        result = sys_page_unmap(sys_getenvid(), PFTEMP);
  8020e6:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  8020ed:	00 00 00 
  8020f0:	ff d0                	callq  *%rax
  8020f2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020f7:	89 c7                	mov    %eax,%edi
  8020f9:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  802100:	00 00 00 
  802103:	ff d0                	callq  *%rax
  802105:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  802108:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80210c:	79 2a                	jns    802138 <fork+0x2bd>
                panic("temporary page unmapping failed in copy-on-write faulting page");
  80210e:	48 ba 50 29 80 00 00 	movabs $0x802950,%rdx
  802115:	00 00 00 
  802118:	be bf 00 00 00       	mov    $0xbf,%esi
  80211d:	48 bf ce 28 80 00 00 	movabs $0x8028ce,%rdi
  802124:	00 00 00 
  802127:	b8 00 00 00 00       	mov    $0x0,%eax
  80212c:	48 b9 57 02 80 00 00 	movabs $0x800257,%rcx
  802133:	00 00 00 
  802136:	ff d1                	callq  *%rcx
        }
// STEP 4
//The parent sets the user page fault entrypoint for the child to look like its own.

	result=sys_page_alloc(child, (void*)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W);
  802138:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80213b:	ba 07 00 00 00       	mov    $0x7,%edx
  802140:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802145:	89 c7                	mov    %eax,%edi
  802147:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  80214e:	00 00 00 
  802151:	ff d0                	callq  *%rax
  802153:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  802156:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80215a:	79 2a                	jns    802186 <fork+0x30b>
		panic("page alloc of table failed in fork");
  80215c:	48 ba d0 29 80 00 00 	movabs $0x8029d0,%rdx
  802163:	00 00 00 
  802166:	be c6 00 00 00       	mov    $0xc6,%esi
  80216b:	48 bf ce 28 80 00 00 	movabs $0x8028ce,%rdi
  802172:	00 00 00 
  802175:	b8 00 00 00 00       	mov    $0x0,%eax
  80217a:	48 b9 57 02 80 00 00 	movabs $0x800257,%rcx
  802181:	00 00 00 
  802184:	ff d1                	callq  *%rcx
	}

	extern void _pgfault_upcall();
	result = sys_env_set_pgfault_upcall(child, _pgfault_upcall);
  802186:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802189:	48 be 34 23 80 00 00 	movabs $0x802334,%rsi
  802190:	00 00 00 
  802193:	89 c7                	mov    %eax,%edi
  802195:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  80219c:	00 00 00 
  80219f:	ff d0                	callq  *%rax
  8021a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  8021a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021a8:	79 2a                	jns    8021d4 <fork+0x359>
		panic("setting upcall failed in fork"); 
  8021aa:	48 ba f3 29 80 00 00 	movabs $0x8029f3,%rdx
  8021b1:	00 00 00 
  8021b4:	be cc 00 00 00       	mov    $0xcc,%esi
  8021b9:	48 bf ce 28 80 00 00 	movabs $0x8028ce,%rdi
  8021c0:	00 00 00 
  8021c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c8:	48 b9 57 02 80 00 00 	movabs $0x800257,%rcx
  8021cf:	00 00 00 
  8021d2:	ff d1                	callq  *%rcx
	}
// STEP 5
//The child is now ready to run, so the parent marks it runnable.

	result = sys_env_set_status(child, ENV_RUNNABLE);
  8021d4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021d7:	be 02 00 00 00       	mov    $0x2,%esi
  8021dc:	89 c7                	mov    %eax,%edi
  8021de:	48 b8 55 1a 80 00 00 	movabs $0x801a55,%rax
  8021e5:	00 00 00 
  8021e8:	ff d0                	callq  *%rax
  8021ea:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  8021ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021f1:	79 2a                	jns    80221d <fork+0x3a2>
		panic("changing statys is fork failed");
  8021f3:	48 ba 18 2a 80 00 00 	movabs $0x802a18,%rdx
  8021fa:	00 00 00 
  8021fd:	be d3 00 00 00       	mov    $0xd3,%esi
  802202:	48 bf ce 28 80 00 00 	movabs $0x8028ce,%rdi
  802209:	00 00 00 
  80220c:	b8 00 00 00 00       	mov    $0x0,%eax
  802211:	48 b9 57 02 80 00 00 	movabs $0x800257,%rcx
  802218:	00 00 00 
  80221b:	ff d1                	callq  *%rcx
	}
	
	return child;
  80221d:	8b 45 f4             	mov    -0xc(%rbp),%eax

}
  802220:	c9                   	leaveq 
  802221:	c3                   	retq   

0000000000802222 <sfork>:

// Challenge!
int
sfork(void)
{
  802222:	55                   	push   %rbp
  802223:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802226:	48 ba 37 2a 80 00 00 	movabs $0x802a37,%rdx
  80222d:	00 00 00 
  802230:	be de 00 00 00       	mov    $0xde,%esi
  802235:	48 bf ce 28 80 00 00 	movabs $0x8028ce,%rdi
  80223c:	00 00 00 
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
  802244:	48 b9 57 02 80 00 00 	movabs $0x800257,%rcx
  80224b:	00 00 00 
  80224e:	ff d1                	callq  *%rcx

0000000000802250 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802250:	55                   	push   %rbp
  802251:	48 89 e5             	mov    %rsp,%rbp
  802254:	48 83 ec 20          	sub    $0x20,%rsp
  802258:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler==0) {
  80225c:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  802263:	00 00 00 
  802266:	48 8b 00             	mov    (%rax),%rax
  802269:	48 85 c0             	test   %rax,%rax
  80226c:	0f 85 ae 00 00 00    	jne    802320 <set_pgfault_handler+0xd0>
		//allocate space
		int result = sys_page_alloc(sys_getenvid(), (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  802272:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  802279:	00 00 00 
  80227c:	ff d0                	callq  *%rax
  80227e:	ba 07 00 00 00       	mov    $0x7,%edx
  802283:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802288:	89 c7                	mov    %eax,%edi
  80228a:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  802291:	00 00 00 
  802294:	ff d0                	callq  *%rax
  802296:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  802299:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80229d:	79 2a                	jns    8022c9 <set_pgfault_handler+0x79>
			panic("sys_page_alloc for stack failed in setting page fault handler");
  80229f:	48 ba 50 2a 80 00 00 	movabs $0x802a50,%rdx
  8022a6:	00 00 00 
  8022a9:	be 21 00 00 00       	mov    $0x21,%esi
  8022ae:	48 bf 8e 2a 80 00 00 	movabs $0x802a8e,%rdi
  8022b5:	00 00 00 
  8022b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bd:	48 b9 57 02 80 00 00 	movabs $0x800257,%rcx
  8022c4:	00 00 00 
  8022c7:	ff d1                	callq  *%rcx
		}

		//actual set upcall
		result = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8022c9:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  8022d0:	00 00 00 
  8022d3:	ff d0                	callq  *%rax
  8022d5:	48 be 34 23 80 00 00 	movabs $0x802334,%rsi
  8022dc:	00 00 00 
  8022df:	89 c7                	mov    %eax,%edi
  8022e1:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  8022e8:	00 00 00 
  8022eb:	ff d0                	callq  *%rax
  8022ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  8022f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f4:	79 2a                	jns    802320 <set_pgfault_handler+0xd0>
                        panic("setting upcall failed in setting page fault handler");
  8022f6:	48 ba a0 2a 80 00 00 	movabs $0x802aa0,%rdx
  8022fd:	00 00 00 
  802300:	be 27 00 00 00       	mov    $0x27,%esi
  802305:	48 bf 8e 2a 80 00 00 	movabs $0x802a8e,%rdi
  80230c:	00 00 00 
  80230f:	b8 00 00 00 00       	mov    $0x0,%eax
  802314:	48 b9 57 02 80 00 00 	movabs $0x800257,%rcx
  80231b:	00 00 00 
  80231e:	ff d1                	callq  *%rcx
                }
		//panic("set_pgfault_handler not implemented");
	}

	_pgfault_handler = handler;
  802320:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  802327:	00 00 00 
  80232a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80232e:	48 89 10             	mov    %rdx,(%rax)

}
  802331:	90                   	nop
  802332:	c9                   	leaveq 
  802333:	c3                   	retq   

0000000000802334 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  802334:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  802337:	48 a1 18 40 80 00 00 	movabs 0x804018,%rax
  80233e:	00 00 00 
call *%rax
  802341:	ff d0                	callq  *%rax
	//MAKE STACK CALCS for getting parameters
	//20 = size of stack
	//8 = size of word	

	//(20-3)*8=17*8=136
	movq 136(%rsp), %rax
  802343:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  80234a:	00 
	//(20-1)*8=152
	subq $8, 152(%rsp)
  80234b:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  802352:	00 08 
	movq 152(%rsp), %rbx
  802354:	48 8b 9c 24 98 00 00 	mov    0x98(%rsp),%rbx
  80235b:	00 
	movq %rax, (%rbx)
  80235c:	48 89 03             	mov    %rax,(%rbx)
	addq $16, %rsp
  80235f:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
	
    	POPA_
  802363:	4c 8b 3c 24          	mov    (%rsp),%r15
  802367:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80236c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802371:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802376:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80237b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802380:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802385:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80238a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80238f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802394:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802399:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80239e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8023a3:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8023a8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8023ad:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
	//https://www.felixcloutier.com/x86/POPF:POPFD:POPFQ.html
    	addq $8, %rsp
  8023b1:	48 83 c4 08          	add    $0x8,%rsp
    	popfq	
  8023b5:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    	popq %rsp
  8023b6:	5c                   	pop    %rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    	ret
  8023b7:	c3                   	retq   
