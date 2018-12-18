
obj/user/sendpage:     file format elf64-x86-64


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
  80003c:	e8 67 02 00 00       	callq  8002a8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t who;

	if ((who = fork()) == 0) {
  800052:	48 b8 5c 1e 80 00 00 	movabs $0x801e5c,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800061:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800064:	85 c0                	test   %eax,%eax
  800066:	0f 85 09 01 00 00    	jne    800175 <umain+0x132>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  80006c:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800070:	ba 00 00 00 00       	mov    $0x0,%edx
  800075:	be 00 00 b0 00       	mov    $0xb00000,%esi
  80007a:	48 89 c7             	mov    %rax,%rdi
  80007d:	48 b8 31 22 80 00 00 	movabs $0x802231,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
		cprintf("%x got message : %s\n", who, TEMP_ADDR_CHILD);
  800089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008c:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  800091:	89 c6                	mov    %eax,%esi
  800093:	48 bf cc 26 80 00 00 	movabs $0x8026cc,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	48 b9 72 04 80 00 00 	movabs $0x800472,%rcx
  8000a9:	00 00 00 
  8000ac:	ff d1                	callq  *%rcx
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  8000ae:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8000b5:	00 00 00 
  8000b8:	48 8b 00             	mov    (%rax),%rax
  8000bb:	48 89 c7             	mov    %rax,%rdi
  8000be:	48 b8 96 0f 80 00 00 	movabs $0x800f96,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	48 63 d0             	movslq %eax,%rdx
  8000cd:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8000d4:	00 00 00 
  8000d7:	48 8b 00             	mov    (%rax),%rax
  8000da:	48 89 c6             	mov    %rax,%rsi
  8000dd:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  8000e2:	48 b8 b7 11 80 00 00 	movabs $0x8011b7,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	callq  *%rax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	75 1b                	jne    80010d <umain+0xca>
			cprintf("child received correct message\n");
  8000f2:	48 bf e8 26 80 00 00 	movabs $0x8026e8,%rdi
  8000f9:	00 00 00 
  8000fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800101:	48 ba 72 04 80 00 00 	movabs $0x800472,%rdx
  800108:	00 00 00 
  80010b:	ff d2                	callq  *%rdx

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str1) + 1);
  80010d:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800114:	00 00 00 
  800117:	48 8b 00             	mov    (%rax),%rax
  80011a:	48 89 c7             	mov    %rax,%rdi
  80011d:	48 b8 96 0f 80 00 00 	movabs $0x800f96,%rax
  800124:	00 00 00 
  800127:	ff d0                	callq  *%rax
  800129:	83 c0 01             	add    $0x1,%eax
  80012c:	48 63 d0             	movslq %eax,%rdx
  80012f:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  800136:	00 00 00 
  800139:	48 8b 00             	mov    (%rax),%rax
  80013c:	48 89 c6             	mov    %rax,%rsi
  80013f:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  800144:	48 b8 3e 14 80 00 00 	movabs $0x80143e,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800153:	b9 07 00 00 00       	mov    $0x7,%ecx
  800158:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  80015d:	be 00 00 00 00       	mov    $0x0,%esi
  800162:	89 c7                	mov    %eax,%edi
  800164:	48 b8 ec 22 80 00 00 	movabs $0x8022ec,%rax
  80016b:	00 00 00 
  80016e:	ff d0                	callq  *%rax
		return;
  800170:	e9 31 01 00 00       	jmpq   8002a6 <umain+0x263>
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800175:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  80017c:	00 00 00 
  80017f:	48 8b 00             	mov    (%rax),%rax
  800182:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800188:	ba 07 00 00 00       	mov    $0x7,%edx
  80018d:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800192:	89 c7                	mov    %eax,%edi
  800194:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  8001a0:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8001a7:	00 00 00 
  8001aa:	48 8b 00             	mov    (%rax),%rax
  8001ad:	48 89 c7             	mov    %rax,%rdi
  8001b0:	48 b8 96 0f 80 00 00 	movabs $0x800f96,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	callq  *%rax
  8001bc:	83 c0 01             	add    $0x1,%eax
  8001bf:	48 63 d0             	movslq %eax,%rdx
  8001c2:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8001c9:	00 00 00 
  8001cc:	48 8b 00             	mov    (%rax),%rax
  8001cf:	48 89 c6             	mov    %rax,%rsi
  8001d2:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  8001d7:	48 b8 3e 14 80 00 00 	movabs $0x80143e,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	callq  *%rax
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8001e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8001eb:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  8001f0:	be 00 00 00 00       	mov    $0x0,%esi
  8001f5:	89 c7                	mov    %eax,%edi
  8001f7:	48 b8 ec 22 80 00 00 	movabs $0x8022ec,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	callq  *%rax

	ipc_recv(&who, TEMP_ADDR, 0);
  800203:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800207:	ba 00 00 00 00       	mov    $0x0,%edx
  80020c:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800211:	48 89 c7             	mov    %rax,%rdi
  800214:	48 b8 31 22 80 00 00 	movabs $0x802231,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
	cprintf("%x got message : %s\n", who, TEMP_ADDR);
  800220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800223:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  800228:	89 c6                	mov    %eax,%esi
  80022a:	48 bf cc 26 80 00 00 	movabs $0x8026cc,%rdi
  800231:	00 00 00 
  800234:	b8 00 00 00 00       	mov    $0x0,%eax
  800239:	48 b9 72 04 80 00 00 	movabs $0x800472,%rcx
  800240:	00 00 00 
  800243:	ff d1                	callq  *%rcx
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  800245:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80024c:	00 00 00 
  80024f:	48 8b 00             	mov    (%rax),%rax
  800252:	48 89 c7             	mov    %rax,%rdi
  800255:	48 b8 96 0f 80 00 00 	movabs $0x800f96,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax
  800261:	48 63 d0             	movslq %eax,%rdx
  800264:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80026b:	00 00 00 
  80026e:	48 8b 00             	mov    (%rax),%rax
  800271:	48 89 c6             	mov    %rax,%rsi
  800274:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  800279:	48 b8 b7 11 80 00 00 	movabs $0x8011b7,%rax
  800280:	00 00 00 
  800283:	ff d0                	callq  *%rax
  800285:	85 c0                	test   %eax,%eax
  800287:	75 1c                	jne    8002a5 <umain+0x262>
		cprintf("parent received correct message\n");
  800289:	48 bf 08 27 80 00 00 	movabs $0x802708,%rdi
  800290:	00 00 00 
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	48 ba 72 04 80 00 00 	movabs $0x800472,%rdx
  80029f:	00 00 00 
  8002a2:	ff d2                	callq  *%rdx
	return;
  8002a4:	90                   	nop
  8002a5:	90                   	nop
}
  8002a6:	c9                   	leaveq 
  8002a7:	c3                   	retq   

00000000008002a8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	48 83 ec 10          	sub    $0x10,%rsp
  8002b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  8002b7:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
  8002c3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002c8:	48 63 d0             	movslq %eax,%rdx
  8002cb:	48 89 d0             	mov    %rdx,%rax
  8002ce:	48 c1 e0 03          	shl    $0x3,%rax
  8002d2:	48 01 d0             	add    %rdx,%rax
  8002d5:	48 c1 e0 05          	shl    $0x5,%rax
  8002d9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8002e0:	00 00 00 
  8002e3:	48 01 c2             	add    %rax,%rdx
  8002e6:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  8002ed:	00 00 00 
  8002f0:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002f7:	7e 14                	jle    80030d <libmain+0x65>
		binaryname = argv[0];
  8002f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002fd:	48 8b 10             	mov    (%rax),%rdx
  800300:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  800307:	00 00 00 
  80030a:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80030d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800311:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800314:	48 89 d6             	mov    %rdx,%rsi
  800317:	89 c7                	mov    %eax,%edi
  800319:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800320:	00 00 00 
  800323:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800325:	48 b8 34 03 80 00 00 	movabs $0x800334,%rax
  80032c:	00 00 00 
  80032f:	ff d0                	callq  *%rax
}
  800331:	90                   	nop
  800332:	c9                   	leaveq 
  800333:	c3                   	retq   

0000000000800334 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800334:	55                   	push   %rbp
  800335:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800338:	bf 00 00 00 00       	mov    $0x0,%edi
  80033d:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax
}
  800349:	90                   	nop
  80034a:	5d                   	pop    %rbp
  80034b:	c3                   	retq   

000000000080034c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80034c:	55                   	push   %rbp
  80034d:	48 89 e5             	mov    %rsp,%rbp
  800350:	48 83 ec 10          	sub    $0x10,%rsp
  800354:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800357:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80035b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80035f:	8b 00                	mov    (%rax),%eax
  800361:	8d 48 01             	lea    0x1(%rax),%ecx
  800364:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800368:	89 0a                	mov    %ecx,(%rdx)
  80036a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80036d:	89 d1                	mov    %edx,%ecx
  80036f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800373:	48 98                	cltq   
  800375:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80037d:	8b 00                	mov    (%rax),%eax
  80037f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800384:	75 2c                	jne    8003b2 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038a:	8b 00                	mov    (%rax),%eax
  80038c:	48 98                	cltq   
  80038e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800392:	48 83 c2 08          	add    $0x8,%rdx
  800396:	48 89 c6             	mov    %rax,%rsi
  800399:	48 89 d7             	mov    %rdx,%rdi
  80039c:	48 b8 f0 17 80 00 00 	movabs $0x8017f0,%rax
  8003a3:	00 00 00 
  8003a6:	ff d0                	callq  *%rax
        b->idx = 0;
  8003a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ac:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b6:	8b 40 04             	mov    0x4(%rax),%eax
  8003b9:	8d 50 01             	lea    0x1(%rax),%edx
  8003bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c0:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003c3:	90                   	nop
  8003c4:	c9                   	leaveq 
  8003c5:	c3                   	retq   

00000000008003c6 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003c6:	55                   	push   %rbp
  8003c7:	48 89 e5             	mov    %rsp,%rbp
  8003ca:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003d1:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003d8:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003df:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003e6:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003ed:	48 8b 0a             	mov    (%rdx),%rcx
  8003f0:	48 89 08             	mov    %rcx,(%rax)
  8003f3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003f7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003fb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003ff:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800403:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80040a:	00 00 00 
    b.cnt = 0;
  80040d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800414:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800417:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80041e:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800425:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80042c:	48 89 c6             	mov    %rax,%rsi
  80042f:	48 bf 4c 03 80 00 00 	movabs $0x80034c,%rdi
  800436:	00 00 00 
  800439:	48 b8 10 08 80 00 00 	movabs $0x800810,%rax
  800440:	00 00 00 
  800443:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800445:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80044b:	48 98                	cltq   
  80044d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800454:	48 83 c2 08          	add    $0x8,%rdx
  800458:	48 89 c6             	mov    %rax,%rsi
  80045b:	48 89 d7             	mov    %rdx,%rdi
  80045e:	48 b8 f0 17 80 00 00 	movabs $0x8017f0,%rax
  800465:	00 00 00 
  800468:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80046a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800470:	c9                   	leaveq 
  800471:	c3                   	retq   

0000000000800472 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800472:	55                   	push   %rbp
  800473:	48 89 e5             	mov    %rsp,%rbp
  800476:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80047d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800484:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80048b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800492:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800499:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004a0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004a7:	84 c0                	test   %al,%al
  8004a9:	74 20                	je     8004cb <cprintf+0x59>
  8004ab:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004af:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004b3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004b7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004bb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004bf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004c3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004c7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004cb:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004d2:	00 00 00 
  8004d5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004dc:	00 00 00 
  8004df:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004e3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004ea:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004f1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8004f8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004ff:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800506:	48 8b 0a             	mov    (%rdx),%rcx
  800509:	48 89 08             	mov    %rcx,(%rax)
  80050c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800510:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800514:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800518:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80051c:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800523:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80052a:	48 89 d6             	mov    %rdx,%rsi
  80052d:	48 89 c7             	mov    %rax,%rdi
  800530:	48 b8 c6 03 80 00 00 	movabs $0x8003c6,%rax
  800537:	00 00 00 
  80053a:	ff d0                	callq  *%rax
  80053c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800542:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800548:	c9                   	leaveq 
  800549:	c3                   	retq   

000000000080054a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80054a:	55                   	push   %rbp
  80054b:	48 89 e5             	mov    %rsp,%rbp
  80054e:	48 83 ec 30          	sub    $0x30,%rsp
  800552:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800556:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80055a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80055e:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800561:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800565:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800569:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80056c:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800570:	77 54                	ja     8005c6 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800572:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800575:	8d 78 ff             	lea    -0x1(%rax),%edi
  800578:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80057b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057f:	ba 00 00 00 00       	mov    $0x0,%edx
  800584:	48 f7 f6             	div    %rsi
  800587:	49 89 c2             	mov    %rax,%r10
  80058a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80058d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800590:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800598:	41 89 c9             	mov    %ecx,%r9d
  80059b:	41 89 f8             	mov    %edi,%r8d
  80059e:	89 d1                	mov    %edx,%ecx
  8005a0:	4c 89 d2             	mov    %r10,%rdx
  8005a3:	48 89 c7             	mov    %rax,%rdi
  8005a6:	48 b8 4a 05 80 00 00 	movabs $0x80054a,%rax
  8005ad:	00 00 00 
  8005b0:	ff d0                	callq  *%rax
  8005b2:	eb 1c                	jmp    8005d0 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005b4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8005b8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8005bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005bf:	48 89 ce             	mov    %rcx,%rsi
  8005c2:	89 d7                	mov    %edx,%edi
  8005c4:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005c6:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8005ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8005ce:	7f e4                	jg     8005b4 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005d0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8005d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005dc:	48 f7 f1             	div    %rcx
  8005df:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  8005e6:	00 00 00 
  8005e9:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8005ed:	0f be d0             	movsbl %al,%edx
  8005f0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8005f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005f8:	48 89 ce             	mov    %rcx,%rsi
  8005fb:	89 d7                	mov    %edx,%edi
  8005fd:	ff d0                	callq  *%rax
}
  8005ff:	90                   	nop
  800600:	c9                   	leaveq 
  800601:	c3                   	retq   

0000000000800602 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800602:	55                   	push   %rbp
  800603:	48 89 e5             	mov    %rsp,%rbp
  800606:	48 83 ec 20          	sub    $0x20,%rsp
  80060a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80060e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800611:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800615:	7e 4f                	jle    800666 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800617:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061b:	8b 00                	mov    (%rax),%eax
  80061d:	83 f8 30             	cmp    $0x30,%eax
  800620:	73 24                	jae    800646 <getuint+0x44>
  800622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800626:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80062a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062e:	8b 00                	mov    (%rax),%eax
  800630:	89 c0                	mov    %eax,%eax
  800632:	48 01 d0             	add    %rdx,%rax
  800635:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800639:	8b 12                	mov    (%rdx),%edx
  80063b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80063e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800642:	89 0a                	mov    %ecx,(%rdx)
  800644:	eb 14                	jmp    80065a <getuint+0x58>
  800646:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80064e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800652:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800656:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80065a:	48 8b 00             	mov    (%rax),%rax
  80065d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800661:	e9 9d 00 00 00       	jmpq   800703 <getuint+0x101>
	else if (lflag)
  800666:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80066a:	74 4c                	je     8006b8 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80066c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800670:	8b 00                	mov    (%rax),%eax
  800672:	83 f8 30             	cmp    $0x30,%eax
  800675:	73 24                	jae    80069b <getuint+0x99>
  800677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	8b 00                	mov    (%rax),%eax
  800685:	89 c0                	mov    %eax,%eax
  800687:	48 01 d0             	add    %rdx,%rax
  80068a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068e:	8b 12                	mov    (%rdx),%edx
  800690:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800693:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800697:	89 0a                	mov    %ecx,(%rdx)
  800699:	eb 14                	jmp    8006af <getuint+0xad>
  80069b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069f:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006a3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006af:	48 8b 00             	mov    (%rax),%rax
  8006b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006b6:	eb 4b                	jmp    800703 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8006b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bc:	8b 00                	mov    (%rax),%eax
  8006be:	83 f8 30             	cmp    $0x30,%eax
  8006c1:	73 24                	jae    8006e7 <getuint+0xe5>
  8006c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cf:	8b 00                	mov    (%rax),%eax
  8006d1:	89 c0                	mov    %eax,%eax
  8006d3:	48 01 d0             	add    %rdx,%rax
  8006d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006da:	8b 12                	mov    (%rdx),%edx
  8006dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e3:	89 0a                	mov    %ecx,(%rdx)
  8006e5:	eb 14                	jmp    8006fb <getuint+0xf9>
  8006e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006eb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006ef:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006fb:	8b 00                	mov    (%rax),%eax
  8006fd:	89 c0                	mov    %eax,%eax
  8006ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800703:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800707:	c9                   	leaveq 
  800708:	c3                   	retq   

0000000000800709 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800709:	55                   	push   %rbp
  80070a:	48 89 e5             	mov    %rsp,%rbp
  80070d:	48 83 ec 20          	sub    $0x20,%rsp
  800711:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800715:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800718:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80071c:	7e 4f                	jle    80076d <getint+0x64>
		x=va_arg(*ap, long long);
  80071e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800722:	8b 00                	mov    (%rax),%eax
  800724:	83 f8 30             	cmp    $0x30,%eax
  800727:	73 24                	jae    80074d <getint+0x44>
  800729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800731:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800735:	8b 00                	mov    (%rax),%eax
  800737:	89 c0                	mov    %eax,%eax
  800739:	48 01 d0             	add    %rdx,%rax
  80073c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800740:	8b 12                	mov    (%rdx),%edx
  800742:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800745:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800749:	89 0a                	mov    %ecx,(%rdx)
  80074b:	eb 14                	jmp    800761 <getint+0x58>
  80074d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800751:	48 8b 40 08          	mov    0x8(%rax),%rax
  800755:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800759:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800761:	48 8b 00             	mov    (%rax),%rax
  800764:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800768:	e9 9d 00 00 00       	jmpq   80080a <getint+0x101>
	else if (lflag)
  80076d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800771:	74 4c                	je     8007bf <getint+0xb6>
		x=va_arg(*ap, long);
  800773:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800777:	8b 00                	mov    (%rax),%eax
  800779:	83 f8 30             	cmp    $0x30,%eax
  80077c:	73 24                	jae    8007a2 <getint+0x99>
  80077e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800782:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078a:	8b 00                	mov    (%rax),%eax
  80078c:	89 c0                	mov    %eax,%eax
  80078e:	48 01 d0             	add    %rdx,%rax
  800791:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800795:	8b 12                	mov    (%rdx),%edx
  800797:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80079a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079e:	89 0a                	mov    %ecx,(%rdx)
  8007a0:	eb 14                	jmp    8007b6 <getint+0xad>
  8007a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007aa:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b6:	48 8b 00             	mov    (%rax),%rax
  8007b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007bd:	eb 4b                	jmp    80080a <getint+0x101>
	else
		x=va_arg(*ap, int);
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	8b 00                	mov    (%rax),%eax
  8007c5:	83 f8 30             	cmp    $0x30,%eax
  8007c8:	73 24                	jae    8007ee <getint+0xe5>
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d6:	8b 00                	mov    (%rax),%eax
  8007d8:	89 c0                	mov    %eax,%eax
  8007da:	48 01 d0             	add    %rdx,%rax
  8007dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e1:	8b 12                	mov    (%rdx),%edx
  8007e3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ea:	89 0a                	mov    %ecx,(%rdx)
  8007ec:	eb 14                	jmp    800802 <getint+0xf9>
  8007ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007f6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800802:	8b 00                	mov    (%rax),%eax
  800804:	48 98                	cltq   
  800806:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80080a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80080e:	c9                   	leaveq 
  80080f:	c3                   	retq   

0000000000800810 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800810:	55                   	push   %rbp
  800811:	48 89 e5             	mov    %rsp,%rbp
  800814:	41 54                	push   %r12
  800816:	53                   	push   %rbx
  800817:	48 83 ec 60          	sub    $0x60,%rsp
  80081b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80081f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800823:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800827:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80082b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80082f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800833:	48 8b 0a             	mov    (%rdx),%rcx
  800836:	48 89 08             	mov    %rcx,(%rax)
  800839:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80083d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800841:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800845:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800849:	eb 17                	jmp    800862 <vprintfmt+0x52>
			if (ch == '\0')
  80084b:	85 db                	test   %ebx,%ebx
  80084d:	0f 84 b9 04 00 00    	je     800d0c <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800853:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800857:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80085b:	48 89 d6             	mov    %rdx,%rsi
  80085e:	89 df                	mov    %ebx,%edi
  800860:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800862:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800866:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80086a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80086e:	0f b6 00             	movzbl (%rax),%eax
  800871:	0f b6 d8             	movzbl %al,%ebx
  800874:	83 fb 25             	cmp    $0x25,%ebx
  800877:	75 d2                	jne    80084b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800879:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80087d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800884:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80088b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800892:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800899:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80089d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008a5:	0f b6 00             	movzbl (%rax),%eax
  8008a8:	0f b6 d8             	movzbl %al,%ebx
  8008ab:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008ae:	83 f8 55             	cmp    $0x55,%eax
  8008b1:	0f 87 22 04 00 00    	ja     800cd9 <vprintfmt+0x4c9>
  8008b7:	89 c0                	mov    %eax,%eax
  8008b9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008c0:	00 
  8008c1:	48 b8 b8 28 80 00 00 	movabs $0x8028b8,%rax
  8008c8:	00 00 00 
  8008cb:	48 01 d0             	add    %rdx,%rax
  8008ce:	48 8b 00             	mov    (%rax),%rax
  8008d1:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008d3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008d7:	eb c0                	jmp    800899 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008d9:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008dd:	eb ba                	jmp    800899 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008df:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008e6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008e9:	89 d0                	mov    %edx,%eax
  8008eb:	c1 e0 02             	shl    $0x2,%eax
  8008ee:	01 d0                	add    %edx,%eax
  8008f0:	01 c0                	add    %eax,%eax
  8008f2:	01 d8                	add    %ebx,%eax
  8008f4:	83 e8 30             	sub    $0x30,%eax
  8008f7:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8008fa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008fe:	0f b6 00             	movzbl (%rax),%eax
  800901:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800904:	83 fb 2f             	cmp    $0x2f,%ebx
  800907:	7e 60                	jle    800969 <vprintfmt+0x159>
  800909:	83 fb 39             	cmp    $0x39,%ebx
  80090c:	7f 5b                	jg     800969 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800913:	eb d1                	jmp    8008e6 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800915:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800918:	83 f8 30             	cmp    $0x30,%eax
  80091b:	73 17                	jae    800934 <vprintfmt+0x124>
  80091d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800921:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800924:	89 d2                	mov    %edx,%edx
  800926:	48 01 d0             	add    %rdx,%rax
  800929:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80092c:	83 c2 08             	add    $0x8,%edx
  80092f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800932:	eb 0c                	jmp    800940 <vprintfmt+0x130>
  800934:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800938:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80093c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800940:	8b 00                	mov    (%rax),%eax
  800942:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800945:	eb 23                	jmp    80096a <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800947:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80094b:	0f 89 48 ff ff ff    	jns    800899 <vprintfmt+0x89>
				width = 0;
  800951:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800958:	e9 3c ff ff ff       	jmpq   800899 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80095d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800964:	e9 30 ff ff ff       	jmpq   800899 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800969:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80096a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80096e:	0f 89 25 ff ff ff    	jns    800899 <vprintfmt+0x89>
				width = precision, precision = -1;
  800974:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800977:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80097a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800981:	e9 13 ff ff ff       	jmpq   800899 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800986:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80098a:	e9 0a ff ff ff       	jmpq   800899 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80098f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800992:	83 f8 30             	cmp    $0x30,%eax
  800995:	73 17                	jae    8009ae <vprintfmt+0x19e>
  800997:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80099b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80099e:	89 d2                	mov    %edx,%edx
  8009a0:	48 01 d0             	add    %rdx,%rax
  8009a3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009a6:	83 c2 08             	add    $0x8,%edx
  8009a9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009ac:	eb 0c                	jmp    8009ba <vprintfmt+0x1aa>
  8009ae:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009b2:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009b6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ba:	8b 10                	mov    (%rax),%edx
  8009bc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009c0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c4:	48 89 ce             	mov    %rcx,%rsi
  8009c7:	89 d7                	mov    %edx,%edi
  8009c9:	ff d0                	callq  *%rax
			break;
  8009cb:	e9 37 03 00 00       	jmpq   800d07 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009d0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d3:	83 f8 30             	cmp    $0x30,%eax
  8009d6:	73 17                	jae    8009ef <vprintfmt+0x1df>
  8009d8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009dc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009df:	89 d2                	mov    %edx,%edx
  8009e1:	48 01 d0             	add    %rdx,%rax
  8009e4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009e7:	83 c2 08             	add    $0x8,%edx
  8009ea:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009ed:	eb 0c                	jmp    8009fb <vprintfmt+0x1eb>
  8009ef:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009f3:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009f7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009fb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8009fd:	85 db                	test   %ebx,%ebx
  8009ff:	79 02                	jns    800a03 <vprintfmt+0x1f3>
				err = -err;
  800a01:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a03:	83 fb 15             	cmp    $0x15,%ebx
  800a06:	7f 16                	jg     800a1e <vprintfmt+0x20e>
  800a08:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  800a0f:	00 00 00 
  800a12:	48 63 d3             	movslq %ebx,%rdx
  800a15:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a19:	4d 85 e4             	test   %r12,%r12
  800a1c:	75 2e                	jne    800a4c <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800a1e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a26:	89 d9                	mov    %ebx,%ecx
  800a28:	48 ba a1 28 80 00 00 	movabs $0x8028a1,%rdx
  800a2f:	00 00 00 
  800a32:	48 89 c7             	mov    %rax,%rdi
  800a35:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3a:	49 b8 16 0d 80 00 00 	movabs $0x800d16,%r8
  800a41:	00 00 00 
  800a44:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a47:	e9 bb 02 00 00       	jmpq   800d07 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a4c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a50:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a54:	4c 89 e1             	mov    %r12,%rcx
  800a57:	48 ba aa 28 80 00 00 	movabs $0x8028aa,%rdx
  800a5e:	00 00 00 
  800a61:	48 89 c7             	mov    %rax,%rdi
  800a64:	b8 00 00 00 00       	mov    $0x0,%eax
  800a69:	49 b8 16 0d 80 00 00 	movabs $0x800d16,%r8
  800a70:	00 00 00 
  800a73:	41 ff d0             	callq  *%r8
			break;
  800a76:	e9 8c 02 00 00       	jmpq   800d07 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7e:	83 f8 30             	cmp    $0x30,%eax
  800a81:	73 17                	jae    800a9a <vprintfmt+0x28a>
  800a83:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a87:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a8a:	89 d2                	mov    %edx,%edx
  800a8c:	48 01 d0             	add    %rdx,%rax
  800a8f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a92:	83 c2 08             	add    $0x8,%edx
  800a95:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a98:	eb 0c                	jmp    800aa6 <vprintfmt+0x296>
  800a9a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a9e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800aa2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aa6:	4c 8b 20             	mov    (%rax),%r12
  800aa9:	4d 85 e4             	test   %r12,%r12
  800aac:	75 0a                	jne    800ab8 <vprintfmt+0x2a8>
				p = "(null)";
  800aae:	49 bc ad 28 80 00 00 	movabs $0x8028ad,%r12
  800ab5:	00 00 00 
			if (width > 0 && padc != '-')
  800ab8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800abc:	7e 78                	jle    800b36 <vprintfmt+0x326>
  800abe:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ac2:	74 72                	je     800b36 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ac7:	48 98                	cltq   
  800ac9:	48 89 c6             	mov    %rax,%rsi
  800acc:	4c 89 e7             	mov    %r12,%rdi
  800acf:	48 b8 c4 0f 80 00 00 	movabs $0x800fc4,%rax
  800ad6:	00 00 00 
  800ad9:	ff d0                	callq  *%rax
  800adb:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ade:	eb 17                	jmp    800af7 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800ae0:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ae4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ae8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aec:	48 89 ce             	mov    %rcx,%rsi
  800aef:	89 d7                	mov    %edx,%edi
  800af1:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800af7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800afb:	7f e3                	jg     800ae0 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afd:	eb 37                	jmp    800b36 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800aff:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b03:	74 1e                	je     800b23 <vprintfmt+0x313>
  800b05:	83 fb 1f             	cmp    $0x1f,%ebx
  800b08:	7e 05                	jle    800b0f <vprintfmt+0x2ff>
  800b0a:	83 fb 7e             	cmp    $0x7e,%ebx
  800b0d:	7e 14                	jle    800b23 <vprintfmt+0x313>
					putch('?', putdat);
  800b0f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b17:	48 89 d6             	mov    %rdx,%rsi
  800b1a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b1f:	ff d0                	callq  *%rax
  800b21:	eb 0f                	jmp    800b32 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800b23:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2b:	48 89 d6             	mov    %rdx,%rsi
  800b2e:	89 df                	mov    %ebx,%edi
  800b30:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b32:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b36:	4c 89 e0             	mov    %r12,%rax
  800b39:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b3d:	0f b6 00             	movzbl (%rax),%eax
  800b40:	0f be d8             	movsbl %al,%ebx
  800b43:	85 db                	test   %ebx,%ebx
  800b45:	74 28                	je     800b6f <vprintfmt+0x35f>
  800b47:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b4b:	78 b2                	js     800aff <vprintfmt+0x2ef>
  800b4d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b51:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b55:	79 a8                	jns    800aff <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b57:	eb 16                	jmp    800b6f <vprintfmt+0x35f>
				putch(' ', putdat);
  800b59:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b61:	48 89 d6             	mov    %rdx,%rsi
  800b64:	bf 20 00 00 00       	mov    $0x20,%edi
  800b69:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b73:	7f e4                	jg     800b59 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800b75:	e9 8d 01 00 00       	jmpq   800d07 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b7a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b7e:	be 03 00 00 00       	mov    $0x3,%esi
  800b83:	48 89 c7             	mov    %rax,%rdi
  800b86:	48 b8 09 07 80 00 00 	movabs $0x800709,%rax
  800b8d:	00 00 00 
  800b90:	ff d0                	callq  *%rax
  800b92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9a:	48 85 c0             	test   %rax,%rax
  800b9d:	79 1d                	jns    800bbc <vprintfmt+0x3ac>
				putch('-', putdat);
  800b9f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba7:	48 89 d6             	mov    %rdx,%rsi
  800baa:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800baf:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb5:	48 f7 d8             	neg    %rax
  800bb8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bbc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bc3:	e9 d2 00 00 00       	jmpq   800c9a <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bc8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bcc:	be 03 00 00 00       	mov    $0x3,%esi
  800bd1:	48 89 c7             	mov    %rax,%rdi
  800bd4:	48 b8 02 06 80 00 00 	movabs $0x800602,%rax
  800bdb:	00 00 00 
  800bde:	ff d0                	callq  *%rax
  800be0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800be4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800beb:	e9 aa 00 00 00       	jmpq   800c9a <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800bf0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf4:	be 03 00 00 00       	mov    $0x3,%esi
  800bf9:	48 89 c7             	mov    %rax,%rdi
  800bfc:	48 b8 02 06 80 00 00 	movabs $0x800602,%rax
  800c03:	00 00 00 
  800c06:	ff d0                	callq  *%rax
  800c08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c0c:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c13:	e9 82 00 00 00       	jmpq   800c9a <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800c18:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c20:	48 89 d6             	mov    %rdx,%rsi
  800c23:	bf 30 00 00 00       	mov    $0x30,%edi
  800c28:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c32:	48 89 d6             	mov    %rdx,%rsi
  800c35:	bf 78 00 00 00       	mov    $0x78,%edi
  800c3a:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3f:	83 f8 30             	cmp    $0x30,%eax
  800c42:	73 17                	jae    800c5b <vprintfmt+0x44b>
  800c44:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c48:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c4b:	89 d2                	mov    %edx,%edx
  800c4d:	48 01 d0             	add    %rdx,%rax
  800c50:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c53:	83 c2 08             	add    $0x8,%edx
  800c56:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c59:	eb 0c                	jmp    800c67 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800c5b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c5f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c63:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c67:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c6a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c6e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c75:	eb 23                	jmp    800c9a <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c77:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c7b:	be 03 00 00 00       	mov    $0x3,%esi
  800c80:	48 89 c7             	mov    %rax,%rdi
  800c83:	48 b8 02 06 80 00 00 	movabs $0x800602,%rax
  800c8a:	00 00 00 
  800c8d:	ff d0                	callq  *%rax
  800c8f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c93:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c9a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c9f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ca2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ca5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ca9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb1:	45 89 c1             	mov    %r8d,%r9d
  800cb4:	41 89 f8             	mov    %edi,%r8d
  800cb7:	48 89 c7             	mov    %rax,%rdi
  800cba:	48 b8 4a 05 80 00 00 	movabs $0x80054a,%rax
  800cc1:	00 00 00 
  800cc4:	ff d0                	callq  *%rax
			break;
  800cc6:	eb 3f                	jmp    800d07 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cc8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ccc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd0:	48 89 d6             	mov    %rdx,%rsi
  800cd3:	89 df                	mov    %ebx,%edi
  800cd5:	ff d0                	callq  *%rax
			break;
  800cd7:	eb 2e                	jmp    800d07 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cd9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cdd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce1:	48 89 d6             	mov    %rdx,%rsi
  800ce4:	bf 25 00 00 00       	mov    $0x25,%edi
  800ce9:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ceb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800cf0:	eb 05                	jmp    800cf7 <vprintfmt+0x4e7>
  800cf2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800cf7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cfb:	48 83 e8 01          	sub    $0x1,%rax
  800cff:	0f b6 00             	movzbl (%rax),%eax
  800d02:	3c 25                	cmp    $0x25,%al
  800d04:	75 ec                	jne    800cf2 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800d06:	90                   	nop
		}
	}
  800d07:	e9 3d fb ff ff       	jmpq   800849 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d0c:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d0d:	48 83 c4 60          	add    $0x60,%rsp
  800d11:	5b                   	pop    %rbx
  800d12:	41 5c                	pop    %r12
  800d14:	5d                   	pop    %rbp
  800d15:	c3                   	retq   

0000000000800d16 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d16:	55                   	push   %rbp
  800d17:	48 89 e5             	mov    %rsp,%rbp
  800d1a:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d21:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d28:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d2f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800d36:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d3d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d44:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d4b:	84 c0                	test   %al,%al
  800d4d:	74 20                	je     800d6f <printfmt+0x59>
  800d4f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d53:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d57:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d5b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d5f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d63:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d67:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d6b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d6f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d76:	00 00 00 
  800d79:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d80:	00 00 00 
  800d83:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d87:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d8e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d95:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d9c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800da3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800daa:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800db1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800db8:	48 89 c7             	mov    %rax,%rdi
  800dbb:	48 b8 10 08 80 00 00 	movabs $0x800810,%rax
  800dc2:	00 00 00 
  800dc5:	ff d0                	callq  *%rax
	va_end(ap);
}
  800dc7:	90                   	nop
  800dc8:	c9                   	leaveq 
  800dc9:	c3                   	retq   

0000000000800dca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dca:	55                   	push   %rbp
  800dcb:	48 89 e5             	mov    %rsp,%rbp
  800dce:	48 83 ec 10          	sub    $0x10,%rsp
  800dd2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800dd5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800dd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ddd:	8b 40 10             	mov    0x10(%rax),%eax
  800de0:	8d 50 01             	lea    0x1(%rax),%edx
  800de3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800de7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800dea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dee:	48 8b 10             	mov    (%rax),%rdx
  800df1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df5:	48 8b 40 08          	mov    0x8(%rax),%rax
  800df9:	48 39 c2             	cmp    %rax,%rdx
  800dfc:	73 17                	jae    800e15 <sprintputch+0x4b>
		*b->buf++ = ch;
  800dfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e02:	48 8b 00             	mov    (%rax),%rax
  800e05:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e09:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e0d:	48 89 0a             	mov    %rcx,(%rdx)
  800e10:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e13:	88 10                	mov    %dl,(%rax)
}
  800e15:	90                   	nop
  800e16:	c9                   	leaveq 
  800e17:	c3                   	retq   

0000000000800e18 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e18:	55                   	push   %rbp
  800e19:	48 89 e5             	mov    %rsp,%rbp
  800e1c:	48 83 ec 50          	sub    $0x50,%rsp
  800e20:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e24:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e27:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e2b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e2f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e33:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e37:	48 8b 0a             	mov    (%rdx),%rcx
  800e3a:	48 89 08             	mov    %rcx,(%rax)
  800e3d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e41:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e45:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e49:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e4d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e51:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e55:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e58:	48 98                	cltq   
  800e5a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e5e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e62:	48 01 d0             	add    %rdx,%rax
  800e65:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e69:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e70:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e75:	74 06                	je     800e7d <vsnprintf+0x65>
  800e77:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e7b:	7f 07                	jg     800e84 <vsnprintf+0x6c>
		return -E_INVAL;
  800e7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e82:	eb 2f                	jmp    800eb3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e84:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e88:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e8c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e90:	48 89 c6             	mov    %rax,%rsi
  800e93:	48 bf ca 0d 80 00 00 	movabs $0x800dca,%rdi
  800e9a:	00 00 00 
  800e9d:	48 b8 10 08 80 00 00 	movabs $0x800810,%rax
  800ea4:	00 00 00 
  800ea7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ea9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ead:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800eb0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800eb3:	c9                   	leaveq 
  800eb4:	c3                   	retq   

0000000000800eb5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eb5:	55                   	push   %rbp
  800eb6:	48 89 e5             	mov    %rsp,%rbp
  800eb9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ec0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ec7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ecd:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800ed4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800edb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ee2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ee9:	84 c0                	test   %al,%al
  800eeb:	74 20                	je     800f0d <snprintf+0x58>
  800eed:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ef1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ef5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ef9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800efd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f01:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f05:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f09:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f0d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f14:	00 00 00 
  800f17:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f1e:	00 00 00 
  800f21:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f25:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f2c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f33:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f3a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f41:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f48:	48 8b 0a             	mov    (%rdx),%rcx
  800f4b:	48 89 08             	mov    %rcx,(%rax)
  800f4e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f52:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f56:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f5a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f5e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f65:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f6c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f72:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f79:	48 89 c7             	mov    %rax,%rdi
  800f7c:	48 b8 18 0e 80 00 00 	movabs $0x800e18,%rax
  800f83:	00 00 00 
  800f86:	ff d0                	callq  *%rax
  800f88:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f8e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f94:	c9                   	leaveq 
  800f95:	c3                   	retq   

0000000000800f96 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f96:	55                   	push   %rbp
  800f97:	48 89 e5             	mov    %rsp,%rbp
  800f9a:	48 83 ec 18          	sub    $0x18,%rsp
  800f9e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fa2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fa9:	eb 09                	jmp    800fb4 <strlen+0x1e>
		n++;
  800fab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800faf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb8:	0f b6 00             	movzbl (%rax),%eax
  800fbb:	84 c0                	test   %al,%al
  800fbd:	75 ec                	jne    800fab <strlen+0x15>
		n++;
	return n;
  800fbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fc2:	c9                   	leaveq 
  800fc3:	c3                   	retq   

0000000000800fc4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fc4:	55                   	push   %rbp
  800fc5:	48 89 e5             	mov    %rsp,%rbp
  800fc8:	48 83 ec 20          	sub    $0x20,%rsp
  800fcc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fd0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fdb:	eb 0e                	jmp    800feb <strnlen+0x27>
		n++;
  800fdd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fe1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fe6:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800feb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ff0:	74 0b                	je     800ffd <strnlen+0x39>
  800ff2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff6:	0f b6 00             	movzbl (%rax),%eax
  800ff9:	84 c0                	test   %al,%al
  800ffb:	75 e0                	jne    800fdd <strnlen+0x19>
		n++;
	return n;
  800ffd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801000:	c9                   	leaveq 
  801001:	c3                   	retq   

0000000000801002 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801002:	55                   	push   %rbp
  801003:	48 89 e5             	mov    %rsp,%rbp
  801006:	48 83 ec 20          	sub    $0x20,%rsp
  80100a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80100e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801016:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80101a:	90                   	nop
  80101b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801023:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801027:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80102b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80102f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801033:	0f b6 12             	movzbl (%rdx),%edx
  801036:	88 10                	mov    %dl,(%rax)
  801038:	0f b6 00             	movzbl (%rax),%eax
  80103b:	84 c0                	test   %al,%al
  80103d:	75 dc                	jne    80101b <strcpy+0x19>
		/* do nothing */;
	return ret;
  80103f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801043:	c9                   	leaveq 
  801044:	c3                   	retq   

0000000000801045 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801045:	55                   	push   %rbp
  801046:	48 89 e5             	mov    %rsp,%rbp
  801049:	48 83 ec 20          	sub    $0x20,%rsp
  80104d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801051:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801055:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801059:	48 89 c7             	mov    %rax,%rdi
  80105c:	48 b8 96 0f 80 00 00 	movabs $0x800f96,%rax
  801063:	00 00 00 
  801066:	ff d0                	callq  *%rax
  801068:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80106b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80106e:	48 63 d0             	movslq %eax,%rdx
  801071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801075:	48 01 c2             	add    %rax,%rdx
  801078:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80107c:	48 89 c6             	mov    %rax,%rsi
  80107f:	48 89 d7             	mov    %rdx,%rdi
  801082:	48 b8 02 10 80 00 00 	movabs $0x801002,%rax
  801089:	00 00 00 
  80108c:	ff d0                	callq  *%rax
	return dst;
  80108e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801092:	c9                   	leaveq 
  801093:	c3                   	retq   

0000000000801094 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801094:	55                   	push   %rbp
  801095:	48 89 e5             	mov    %rsp,%rbp
  801098:	48 83 ec 28          	sub    $0x28,%rsp
  80109c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010a4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010b0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010b7:	00 
  8010b8:	eb 2a                	jmp    8010e4 <strncpy+0x50>
		*dst++ = *src;
  8010ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010be:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010c2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010c6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010ca:	0f b6 12             	movzbl (%rdx),%edx
  8010cd:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010d3:	0f b6 00             	movzbl (%rax),%eax
  8010d6:	84 c0                	test   %al,%al
  8010d8:	74 05                	je     8010df <strncpy+0x4b>
			src++;
  8010da:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010df:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010ec:	72 cc                	jb     8010ba <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8010f2:	c9                   	leaveq 
  8010f3:	c3                   	retq   

00000000008010f4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010f4:	55                   	push   %rbp
  8010f5:	48 89 e5             	mov    %rsp,%rbp
  8010f8:	48 83 ec 28          	sub    $0x28,%rsp
  8010fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801100:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801104:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801110:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801115:	74 3d                	je     801154 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801117:	eb 1d                	jmp    801136 <strlcpy+0x42>
			*dst++ = *src++;
  801119:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801121:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801125:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801129:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80112d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801131:	0f b6 12             	movzbl (%rdx),%edx
  801134:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801136:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80113b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801140:	74 0b                	je     80114d <strlcpy+0x59>
  801142:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801146:	0f b6 00             	movzbl (%rax),%eax
  801149:	84 c0                	test   %al,%al
  80114b:	75 cc                	jne    801119 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80114d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801151:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801154:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801158:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115c:	48 29 c2             	sub    %rax,%rdx
  80115f:	48 89 d0             	mov    %rdx,%rax
}
  801162:	c9                   	leaveq 
  801163:	c3                   	retq   

0000000000801164 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801164:	55                   	push   %rbp
  801165:	48 89 e5             	mov    %rsp,%rbp
  801168:	48 83 ec 10          	sub    $0x10,%rsp
  80116c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801170:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801174:	eb 0a                	jmp    801180 <strcmp+0x1c>
		p++, q++;
  801176:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80117b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801180:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801184:	0f b6 00             	movzbl (%rax),%eax
  801187:	84 c0                	test   %al,%al
  801189:	74 12                	je     80119d <strcmp+0x39>
  80118b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118f:	0f b6 10             	movzbl (%rax),%edx
  801192:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801196:	0f b6 00             	movzbl (%rax),%eax
  801199:	38 c2                	cmp    %al,%dl
  80119b:	74 d9                	je     801176 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80119d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a1:	0f b6 00             	movzbl (%rax),%eax
  8011a4:	0f b6 d0             	movzbl %al,%edx
  8011a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ab:	0f b6 00             	movzbl (%rax),%eax
  8011ae:	0f b6 c0             	movzbl %al,%eax
  8011b1:	29 c2                	sub    %eax,%edx
  8011b3:	89 d0                	mov    %edx,%eax
}
  8011b5:	c9                   	leaveq 
  8011b6:	c3                   	retq   

00000000008011b7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011b7:	55                   	push   %rbp
  8011b8:	48 89 e5             	mov    %rsp,%rbp
  8011bb:	48 83 ec 18          	sub    $0x18,%rsp
  8011bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011c7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011cb:	eb 0f                	jmp    8011dc <strncmp+0x25>
		n--, p++, q++;
  8011cd:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011d2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011dc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011e1:	74 1d                	je     801200 <strncmp+0x49>
  8011e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e7:	0f b6 00             	movzbl (%rax),%eax
  8011ea:	84 c0                	test   %al,%al
  8011ec:	74 12                	je     801200 <strncmp+0x49>
  8011ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f2:	0f b6 10             	movzbl (%rax),%edx
  8011f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f9:	0f b6 00             	movzbl (%rax),%eax
  8011fc:	38 c2                	cmp    %al,%dl
  8011fe:	74 cd                	je     8011cd <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801200:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801205:	75 07                	jne    80120e <strncmp+0x57>
		return 0;
  801207:	b8 00 00 00 00       	mov    $0x0,%eax
  80120c:	eb 18                	jmp    801226 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80120e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801212:	0f b6 00             	movzbl (%rax),%eax
  801215:	0f b6 d0             	movzbl %al,%edx
  801218:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121c:	0f b6 00             	movzbl (%rax),%eax
  80121f:	0f b6 c0             	movzbl %al,%eax
  801222:	29 c2                	sub    %eax,%edx
  801224:	89 d0                	mov    %edx,%eax
}
  801226:	c9                   	leaveq 
  801227:	c3                   	retq   

0000000000801228 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801228:	55                   	push   %rbp
  801229:	48 89 e5             	mov    %rsp,%rbp
  80122c:	48 83 ec 10          	sub    $0x10,%rsp
  801230:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801234:	89 f0                	mov    %esi,%eax
  801236:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801239:	eb 17                	jmp    801252 <strchr+0x2a>
		if (*s == c)
  80123b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123f:	0f b6 00             	movzbl (%rax),%eax
  801242:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801245:	75 06                	jne    80124d <strchr+0x25>
			return (char *) s;
  801247:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124b:	eb 15                	jmp    801262 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80124d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801252:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801256:	0f b6 00             	movzbl (%rax),%eax
  801259:	84 c0                	test   %al,%al
  80125b:	75 de                	jne    80123b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80125d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801262:	c9                   	leaveq 
  801263:	c3                   	retq   

0000000000801264 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801264:	55                   	push   %rbp
  801265:	48 89 e5             	mov    %rsp,%rbp
  801268:	48 83 ec 10          	sub    $0x10,%rsp
  80126c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801270:	89 f0                	mov    %esi,%eax
  801272:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801275:	eb 11                	jmp    801288 <strfind+0x24>
		if (*s == c)
  801277:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127b:	0f b6 00             	movzbl (%rax),%eax
  80127e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801281:	74 12                	je     801295 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801283:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801288:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128c:	0f b6 00             	movzbl (%rax),%eax
  80128f:	84 c0                	test   %al,%al
  801291:	75 e4                	jne    801277 <strfind+0x13>
  801293:	eb 01                	jmp    801296 <strfind+0x32>
		if (*s == c)
			break;
  801295:	90                   	nop
	return (char *) s;
  801296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80129a:	c9                   	leaveq 
  80129b:	c3                   	retq   

000000000080129c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80129c:	55                   	push   %rbp
  80129d:	48 89 e5             	mov    %rsp,%rbp
  8012a0:	48 83 ec 18          	sub    $0x18,%rsp
  8012a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a8:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012ab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012af:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012b4:	75 06                	jne    8012bc <memset+0x20>
		return v;
  8012b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ba:	eb 69                	jmp    801325 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c0:	83 e0 03             	and    $0x3,%eax
  8012c3:	48 85 c0             	test   %rax,%rax
  8012c6:	75 48                	jne    801310 <memset+0x74>
  8012c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cc:	83 e0 03             	and    $0x3,%eax
  8012cf:	48 85 c0             	test   %rax,%rax
  8012d2:	75 3c                	jne    801310 <memset+0x74>
		c &= 0xFF;
  8012d4:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012de:	c1 e0 18             	shl    $0x18,%eax
  8012e1:	89 c2                	mov    %eax,%edx
  8012e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012e6:	c1 e0 10             	shl    $0x10,%eax
  8012e9:	09 c2                	or     %eax,%edx
  8012eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012ee:	c1 e0 08             	shl    $0x8,%eax
  8012f1:	09 d0                	or     %edx,%eax
  8012f3:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8012f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fa:	48 c1 e8 02          	shr    $0x2,%rax
  8012fe:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801301:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801305:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801308:	48 89 d7             	mov    %rdx,%rdi
  80130b:	fc                   	cld    
  80130c:	f3 ab                	rep stos %eax,%es:(%rdi)
  80130e:	eb 11                	jmp    801321 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801310:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801314:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801317:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80131b:	48 89 d7             	mov    %rdx,%rdi
  80131e:	fc                   	cld    
  80131f:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801321:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801325:	c9                   	leaveq 
  801326:	c3                   	retq   

0000000000801327 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801327:	55                   	push   %rbp
  801328:	48 89 e5             	mov    %rsp,%rbp
  80132b:	48 83 ec 28          	sub    $0x28,%rsp
  80132f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801333:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801337:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80133b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80133f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801347:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80134b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801353:	0f 83 88 00 00 00    	jae    8013e1 <memmove+0xba>
  801359:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80135d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801361:	48 01 d0             	add    %rdx,%rax
  801364:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801368:	76 77                	jbe    8013e1 <memmove+0xba>
		s += n;
  80136a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80136e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801372:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801376:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80137a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137e:	83 e0 03             	and    $0x3,%eax
  801381:	48 85 c0             	test   %rax,%rax
  801384:	75 3b                	jne    8013c1 <memmove+0x9a>
  801386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138a:	83 e0 03             	and    $0x3,%eax
  80138d:	48 85 c0             	test   %rax,%rax
  801390:	75 2f                	jne    8013c1 <memmove+0x9a>
  801392:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801396:	83 e0 03             	and    $0x3,%eax
  801399:	48 85 c0             	test   %rax,%rax
  80139c:	75 23                	jne    8013c1 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80139e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a2:	48 83 e8 04          	sub    $0x4,%rax
  8013a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013aa:	48 83 ea 04          	sub    $0x4,%rdx
  8013ae:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013b2:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013b6:	48 89 c7             	mov    %rax,%rdi
  8013b9:	48 89 d6             	mov    %rdx,%rsi
  8013bc:	fd                   	std    
  8013bd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013bf:	eb 1d                	jmp    8013de <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cd:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d5:	48 89 d7             	mov    %rdx,%rdi
  8013d8:	48 89 c1             	mov    %rax,%rcx
  8013db:	fd                   	std    
  8013dc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013de:	fc                   	cld    
  8013df:	eb 57                	jmp    801438 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e5:	83 e0 03             	and    $0x3,%eax
  8013e8:	48 85 c0             	test   %rax,%rax
  8013eb:	75 36                	jne    801423 <memmove+0xfc>
  8013ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f1:	83 e0 03             	and    $0x3,%eax
  8013f4:	48 85 c0             	test   %rax,%rax
  8013f7:	75 2a                	jne    801423 <memmove+0xfc>
  8013f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fd:	83 e0 03             	and    $0x3,%eax
  801400:	48 85 c0             	test   %rax,%rax
  801403:	75 1e                	jne    801423 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801409:	48 c1 e8 02          	shr    $0x2,%rax
  80140d:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801410:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801414:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801418:	48 89 c7             	mov    %rax,%rdi
  80141b:	48 89 d6             	mov    %rdx,%rsi
  80141e:	fc                   	cld    
  80141f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801421:	eb 15                	jmp    801438 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801423:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801427:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80142b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80142f:	48 89 c7             	mov    %rax,%rdi
  801432:	48 89 d6             	mov    %rdx,%rsi
  801435:	fc                   	cld    
  801436:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801438:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80143c:	c9                   	leaveq 
  80143d:	c3                   	retq   

000000000080143e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80143e:	55                   	push   %rbp
  80143f:	48 89 e5             	mov    %rsp,%rbp
  801442:	48 83 ec 18          	sub    $0x18,%rsp
  801446:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80144a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80144e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801452:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801456:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80145a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145e:	48 89 ce             	mov    %rcx,%rsi
  801461:	48 89 c7             	mov    %rax,%rdi
  801464:	48 b8 27 13 80 00 00 	movabs $0x801327,%rax
  80146b:	00 00 00 
  80146e:	ff d0                	callq  *%rax
}
  801470:	c9                   	leaveq 
  801471:	c3                   	retq   

0000000000801472 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801472:	55                   	push   %rbp
  801473:	48 89 e5             	mov    %rsp,%rbp
  801476:	48 83 ec 28          	sub    $0x28,%rsp
  80147a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80147e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801482:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80148e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801492:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801496:	eb 36                	jmp    8014ce <memcmp+0x5c>
		if (*s1 != *s2)
  801498:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149c:	0f b6 10             	movzbl (%rax),%edx
  80149f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a3:	0f b6 00             	movzbl (%rax),%eax
  8014a6:	38 c2                	cmp    %al,%dl
  8014a8:	74 1a                	je     8014c4 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ae:	0f b6 00             	movzbl (%rax),%eax
  8014b1:	0f b6 d0             	movzbl %al,%edx
  8014b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b8:	0f b6 00             	movzbl (%rax),%eax
  8014bb:	0f b6 c0             	movzbl %al,%eax
  8014be:	29 c2                	sub    %eax,%edx
  8014c0:	89 d0                	mov    %edx,%eax
  8014c2:	eb 20                	jmp    8014e4 <memcmp+0x72>
		s1++, s2++;
  8014c4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014c9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014da:	48 85 c0             	test   %rax,%rax
  8014dd:	75 b9                	jne    801498 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e4:	c9                   	leaveq 
  8014e5:	c3                   	retq   

00000000008014e6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014e6:	55                   	push   %rbp
  8014e7:	48 89 e5             	mov    %rsp,%rbp
  8014ea:	48 83 ec 28          	sub    $0x28,%rsp
  8014ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014f2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8014f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8014f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801501:	48 01 d0             	add    %rdx,%rax
  801504:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801508:	eb 19                	jmp    801523 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  80150a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150e:	0f b6 00             	movzbl (%rax),%eax
  801511:	0f b6 d0             	movzbl %al,%edx
  801514:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801517:	0f b6 c0             	movzbl %al,%eax
  80151a:	39 c2                	cmp    %eax,%edx
  80151c:	74 11                	je     80152f <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80151e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801527:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80152b:	72 dd                	jb     80150a <memfind+0x24>
  80152d:	eb 01                	jmp    801530 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80152f:	90                   	nop
	return (void *) s;
  801530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801534:	c9                   	leaveq 
  801535:	c3                   	retq   

0000000000801536 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801536:	55                   	push   %rbp
  801537:	48 89 e5             	mov    %rsp,%rbp
  80153a:	48 83 ec 38          	sub    $0x38,%rsp
  80153e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801542:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801546:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801549:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801550:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801557:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801558:	eb 05                	jmp    80155f <strtol+0x29>
		s++;
  80155a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80155f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801563:	0f b6 00             	movzbl (%rax),%eax
  801566:	3c 20                	cmp    $0x20,%al
  801568:	74 f0                	je     80155a <strtol+0x24>
  80156a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156e:	0f b6 00             	movzbl (%rax),%eax
  801571:	3c 09                	cmp    $0x9,%al
  801573:	74 e5                	je     80155a <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801579:	0f b6 00             	movzbl (%rax),%eax
  80157c:	3c 2b                	cmp    $0x2b,%al
  80157e:	75 07                	jne    801587 <strtol+0x51>
		s++;
  801580:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801585:	eb 17                	jmp    80159e <strtol+0x68>
	else if (*s == '-')
  801587:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158b:	0f b6 00             	movzbl (%rax),%eax
  80158e:	3c 2d                	cmp    $0x2d,%al
  801590:	75 0c                	jne    80159e <strtol+0x68>
		s++, neg = 1;
  801592:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801597:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80159e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015a2:	74 06                	je     8015aa <strtol+0x74>
  8015a4:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015a8:	75 28                	jne    8015d2 <strtol+0x9c>
  8015aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ae:	0f b6 00             	movzbl (%rax),%eax
  8015b1:	3c 30                	cmp    $0x30,%al
  8015b3:	75 1d                	jne    8015d2 <strtol+0x9c>
  8015b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b9:	48 83 c0 01          	add    $0x1,%rax
  8015bd:	0f b6 00             	movzbl (%rax),%eax
  8015c0:	3c 78                	cmp    $0x78,%al
  8015c2:	75 0e                	jne    8015d2 <strtol+0x9c>
		s += 2, base = 16;
  8015c4:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015c9:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015d0:	eb 2c                	jmp    8015fe <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015d2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015d6:	75 19                	jne    8015f1 <strtol+0xbb>
  8015d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dc:	0f b6 00             	movzbl (%rax),%eax
  8015df:	3c 30                	cmp    $0x30,%al
  8015e1:	75 0e                	jne    8015f1 <strtol+0xbb>
		s++, base = 8;
  8015e3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015e8:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8015ef:	eb 0d                	jmp    8015fe <strtol+0xc8>
	else if (base == 0)
  8015f1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015f5:	75 07                	jne    8015fe <strtol+0xc8>
		base = 10;
  8015f7:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801602:	0f b6 00             	movzbl (%rax),%eax
  801605:	3c 2f                	cmp    $0x2f,%al
  801607:	7e 1d                	jle    801626 <strtol+0xf0>
  801609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160d:	0f b6 00             	movzbl (%rax),%eax
  801610:	3c 39                	cmp    $0x39,%al
  801612:	7f 12                	jg     801626 <strtol+0xf0>
			dig = *s - '0';
  801614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801618:	0f b6 00             	movzbl (%rax),%eax
  80161b:	0f be c0             	movsbl %al,%eax
  80161e:	83 e8 30             	sub    $0x30,%eax
  801621:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801624:	eb 4e                	jmp    801674 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801626:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162a:	0f b6 00             	movzbl (%rax),%eax
  80162d:	3c 60                	cmp    $0x60,%al
  80162f:	7e 1d                	jle    80164e <strtol+0x118>
  801631:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801635:	0f b6 00             	movzbl (%rax),%eax
  801638:	3c 7a                	cmp    $0x7a,%al
  80163a:	7f 12                	jg     80164e <strtol+0x118>
			dig = *s - 'a' + 10;
  80163c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801640:	0f b6 00             	movzbl (%rax),%eax
  801643:	0f be c0             	movsbl %al,%eax
  801646:	83 e8 57             	sub    $0x57,%eax
  801649:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80164c:	eb 26                	jmp    801674 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80164e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801652:	0f b6 00             	movzbl (%rax),%eax
  801655:	3c 40                	cmp    $0x40,%al
  801657:	7e 47                	jle    8016a0 <strtol+0x16a>
  801659:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165d:	0f b6 00             	movzbl (%rax),%eax
  801660:	3c 5a                	cmp    $0x5a,%al
  801662:	7f 3c                	jg     8016a0 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801664:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801668:	0f b6 00             	movzbl (%rax),%eax
  80166b:	0f be c0             	movsbl %al,%eax
  80166e:	83 e8 37             	sub    $0x37,%eax
  801671:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801674:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801677:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80167a:	7d 23                	jge    80169f <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80167c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801681:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801684:	48 98                	cltq   
  801686:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80168b:	48 89 c2             	mov    %rax,%rdx
  80168e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801691:	48 98                	cltq   
  801693:	48 01 d0             	add    %rdx,%rax
  801696:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80169a:	e9 5f ff ff ff       	jmpq   8015fe <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80169f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016a0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016a5:	74 0b                	je     8016b2 <strtol+0x17c>
		*endptr = (char *) s;
  8016a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ab:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016af:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016b6:	74 09                	je     8016c1 <strtol+0x18b>
  8016b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016bc:	48 f7 d8             	neg    %rax
  8016bf:	eb 04                	jmp    8016c5 <strtol+0x18f>
  8016c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016c5:	c9                   	leaveq 
  8016c6:	c3                   	retq   

00000000008016c7 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016c7:	55                   	push   %rbp
  8016c8:	48 89 e5             	mov    %rsp,%rbp
  8016cb:	48 83 ec 30          	sub    $0x30,%rsp
  8016cf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016d3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016db:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016df:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016e3:	0f b6 00             	movzbl (%rax),%eax
  8016e6:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8016e9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8016ed:	75 06                	jne    8016f5 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8016ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f3:	eb 6b                	jmp    801760 <strstr+0x99>

	len = strlen(str);
  8016f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f9:	48 89 c7             	mov    %rax,%rdi
  8016fc:	48 b8 96 0f 80 00 00 	movabs $0x800f96,%rax
  801703:	00 00 00 
  801706:	ff d0                	callq  *%rax
  801708:	48 98                	cltq   
  80170a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80170e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801712:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801716:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80171a:	0f b6 00             	movzbl (%rax),%eax
  80171d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801720:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801724:	75 07                	jne    80172d <strstr+0x66>
				return (char *) 0;
  801726:	b8 00 00 00 00       	mov    $0x0,%eax
  80172b:	eb 33                	jmp    801760 <strstr+0x99>
		} while (sc != c);
  80172d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801731:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801734:	75 d8                	jne    80170e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801736:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80173a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80173e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801742:	48 89 ce             	mov    %rcx,%rsi
  801745:	48 89 c7             	mov    %rax,%rdi
  801748:	48 b8 b7 11 80 00 00 	movabs $0x8011b7,%rax
  80174f:	00 00 00 
  801752:	ff d0                	callq  *%rax
  801754:	85 c0                	test   %eax,%eax
  801756:	75 b6                	jne    80170e <strstr+0x47>

	return (char *) (in - 1);
  801758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175c:	48 83 e8 01          	sub    $0x1,%rax
}
  801760:	c9                   	leaveq 
  801761:	c3                   	retq   

0000000000801762 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801762:	55                   	push   %rbp
  801763:	48 89 e5             	mov    %rsp,%rbp
  801766:	53                   	push   %rbx
  801767:	48 83 ec 48          	sub    $0x48,%rsp
  80176b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80176e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801771:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801775:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801779:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80177d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801781:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801784:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801788:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80178c:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801790:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801794:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801798:	4c 89 c3             	mov    %r8,%rbx
  80179b:	cd 30                	int    $0x30
  80179d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017a1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017a5:	74 3e                	je     8017e5 <syscall+0x83>
  8017a7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017ac:	7e 37                	jle    8017e5 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017b2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017b5:	49 89 d0             	mov    %rdx,%r8
  8017b8:	89 c1                	mov    %eax,%ecx
  8017ba:	48 ba 68 2b 80 00 00 	movabs $0x802b68,%rdx
  8017c1:	00 00 00 
  8017c4:	be 23 00 00 00       	mov    $0x23,%esi
  8017c9:	48 bf 85 2b 80 00 00 	movabs $0x802b85,%rdi
  8017d0:	00 00 00 
  8017d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d8:	49 b9 ff 23 80 00 00 	movabs $0x8023ff,%r9
  8017df:	00 00 00 
  8017e2:	41 ff d1             	callq  *%r9

	return ret;
  8017e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017e9:	48 83 c4 48          	add    $0x48,%rsp
  8017ed:	5b                   	pop    %rbx
  8017ee:	5d                   	pop    %rbp
  8017ef:	c3                   	retq   

00000000008017f0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8017f0:	55                   	push   %rbp
  8017f1:	48 89 e5             	mov    %rsp,%rbp
  8017f4:	48 83 ec 10          	sub    $0x10,%rsp
  8017f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801800:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801804:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801808:	48 83 ec 08          	sub    $0x8,%rsp
  80180c:	6a 00                	pushq  $0x0
  80180e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801814:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80181a:	48 89 d1             	mov    %rdx,%rcx
  80181d:	48 89 c2             	mov    %rax,%rdx
  801820:	be 00 00 00 00       	mov    $0x0,%esi
  801825:	bf 00 00 00 00       	mov    $0x0,%edi
  80182a:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  801831:	00 00 00 
  801834:	ff d0                	callq  *%rax
  801836:	48 83 c4 10          	add    $0x10,%rsp
}
  80183a:	90                   	nop
  80183b:	c9                   	leaveq 
  80183c:	c3                   	retq   

000000000080183d <sys_cgetc>:

int
sys_cgetc(void)
{
  80183d:	55                   	push   %rbp
  80183e:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801841:	48 83 ec 08          	sub    $0x8,%rsp
  801845:	6a 00                	pushq  $0x0
  801847:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80184d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801853:	b9 00 00 00 00       	mov    $0x0,%ecx
  801858:	ba 00 00 00 00       	mov    $0x0,%edx
  80185d:	be 00 00 00 00       	mov    $0x0,%esi
  801862:	bf 01 00 00 00       	mov    $0x1,%edi
  801867:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  80186e:	00 00 00 
  801871:	ff d0                	callq  *%rax
  801873:	48 83 c4 10          	add    $0x10,%rsp
}
  801877:	c9                   	leaveq 
  801878:	c3                   	retq   

0000000000801879 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801879:	55                   	push   %rbp
  80187a:	48 89 e5             	mov    %rsp,%rbp
  80187d:	48 83 ec 10          	sub    $0x10,%rsp
  801881:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801884:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801887:	48 98                	cltq   
  801889:	48 83 ec 08          	sub    $0x8,%rsp
  80188d:	6a 00                	pushq  $0x0
  80188f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801895:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80189b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018a0:	48 89 c2             	mov    %rax,%rdx
  8018a3:	be 01 00 00 00       	mov    $0x1,%esi
  8018a8:	bf 03 00 00 00       	mov    $0x3,%edi
  8018ad:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  8018b4:	00 00 00 
  8018b7:	ff d0                	callq  *%rax
  8018b9:	48 83 c4 10          	add    $0x10,%rsp
}
  8018bd:	c9                   	leaveq 
  8018be:	c3                   	retq   

00000000008018bf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018bf:	55                   	push   %rbp
  8018c0:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018c3:	48 83 ec 08          	sub    $0x8,%rsp
  8018c7:	6a 00                	pushq  $0x0
  8018c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018da:	ba 00 00 00 00       	mov    $0x0,%edx
  8018df:	be 00 00 00 00       	mov    $0x0,%esi
  8018e4:	bf 02 00 00 00       	mov    $0x2,%edi
  8018e9:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  8018f0:	00 00 00 
  8018f3:	ff d0                	callq  *%rax
  8018f5:	48 83 c4 10          	add    $0x10,%rsp
}
  8018f9:	c9                   	leaveq 
  8018fa:	c3                   	retq   

00000000008018fb <sys_yield>:

void
sys_yield(void)
{
  8018fb:	55                   	push   %rbp
  8018fc:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8018ff:	48 83 ec 08          	sub    $0x8,%rsp
  801903:	6a 00                	pushq  $0x0
  801905:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80190b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801911:	b9 00 00 00 00       	mov    $0x0,%ecx
  801916:	ba 00 00 00 00       	mov    $0x0,%edx
  80191b:	be 00 00 00 00       	mov    $0x0,%esi
  801920:	bf 0a 00 00 00       	mov    $0xa,%edi
  801925:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  80192c:	00 00 00 
  80192f:	ff d0                	callq  *%rax
  801931:	48 83 c4 10          	add    $0x10,%rsp
}
  801935:	90                   	nop
  801936:	c9                   	leaveq 
  801937:	c3                   	retq   

0000000000801938 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801938:	55                   	push   %rbp
  801939:	48 89 e5             	mov    %rsp,%rbp
  80193c:	48 83 ec 10          	sub    $0x10,%rsp
  801940:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801943:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801947:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80194a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80194d:	48 63 c8             	movslq %eax,%rcx
  801950:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801954:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801957:	48 98                	cltq   
  801959:	48 83 ec 08          	sub    $0x8,%rsp
  80195d:	6a 00                	pushq  $0x0
  80195f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801965:	49 89 c8             	mov    %rcx,%r8
  801968:	48 89 d1             	mov    %rdx,%rcx
  80196b:	48 89 c2             	mov    %rax,%rdx
  80196e:	be 01 00 00 00       	mov    $0x1,%esi
  801973:	bf 04 00 00 00       	mov    $0x4,%edi
  801978:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  80197f:	00 00 00 
  801982:	ff d0                	callq  *%rax
  801984:	48 83 c4 10          	add    $0x10,%rsp
}
  801988:	c9                   	leaveq 
  801989:	c3                   	retq   

000000000080198a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80198a:	55                   	push   %rbp
  80198b:	48 89 e5             	mov    %rsp,%rbp
  80198e:	48 83 ec 20          	sub    $0x20,%rsp
  801992:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801995:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801999:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80199c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019a0:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019a4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019a7:	48 63 c8             	movslq %eax,%rcx
  8019aa:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019b1:	48 63 f0             	movslq %eax,%rsi
  8019b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019bb:	48 98                	cltq   
  8019bd:	48 83 ec 08          	sub    $0x8,%rsp
  8019c1:	51                   	push   %rcx
  8019c2:	49 89 f9             	mov    %rdi,%r9
  8019c5:	49 89 f0             	mov    %rsi,%r8
  8019c8:	48 89 d1             	mov    %rdx,%rcx
  8019cb:	48 89 c2             	mov    %rax,%rdx
  8019ce:	be 01 00 00 00       	mov    $0x1,%esi
  8019d3:	bf 05 00 00 00       	mov    $0x5,%edi
  8019d8:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  8019df:	00 00 00 
  8019e2:	ff d0                	callq  *%rax
  8019e4:	48 83 c4 10          	add    $0x10,%rsp
}
  8019e8:	c9                   	leaveq 
  8019e9:	c3                   	retq   

00000000008019ea <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019ea:	55                   	push   %rbp
  8019eb:	48 89 e5             	mov    %rsp,%rbp
  8019ee:	48 83 ec 10          	sub    $0x10,%rsp
  8019f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8019f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a00:	48 98                	cltq   
  801a02:	48 83 ec 08          	sub    $0x8,%rsp
  801a06:	6a 00                	pushq  $0x0
  801a08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a14:	48 89 d1             	mov    %rdx,%rcx
  801a17:	48 89 c2             	mov    %rax,%rdx
  801a1a:	be 01 00 00 00       	mov    $0x1,%esi
  801a1f:	bf 06 00 00 00       	mov    $0x6,%edi
  801a24:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  801a2b:	00 00 00 
  801a2e:	ff d0                	callq  *%rax
  801a30:	48 83 c4 10          	add    $0x10,%rsp
}
  801a34:	c9                   	leaveq 
  801a35:	c3                   	retq   

0000000000801a36 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a36:	55                   	push   %rbp
  801a37:	48 89 e5             	mov    %rsp,%rbp
  801a3a:	48 83 ec 10          	sub    $0x10,%rsp
  801a3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a41:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a47:	48 63 d0             	movslq %eax,%rdx
  801a4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4d:	48 98                	cltq   
  801a4f:	48 83 ec 08          	sub    $0x8,%rsp
  801a53:	6a 00                	pushq  $0x0
  801a55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a61:	48 89 d1             	mov    %rdx,%rcx
  801a64:	48 89 c2             	mov    %rax,%rdx
  801a67:	be 01 00 00 00       	mov    $0x1,%esi
  801a6c:	bf 08 00 00 00       	mov    $0x8,%edi
  801a71:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  801a78:	00 00 00 
  801a7b:	ff d0                	callq  *%rax
  801a7d:	48 83 c4 10          	add    $0x10,%rsp
}
  801a81:	c9                   	leaveq 
  801a82:	c3                   	retq   

0000000000801a83 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a83:	55                   	push   %rbp
  801a84:	48 89 e5             	mov    %rsp,%rbp
  801a87:	48 83 ec 10          	sub    $0x10,%rsp
  801a8b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a8e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a99:	48 98                	cltq   
  801a9b:	48 83 ec 08          	sub    $0x8,%rsp
  801a9f:	6a 00                	pushq  $0x0
  801aa1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aad:	48 89 d1             	mov    %rdx,%rcx
  801ab0:	48 89 c2             	mov    %rax,%rdx
  801ab3:	be 01 00 00 00       	mov    $0x1,%esi
  801ab8:	bf 09 00 00 00       	mov    $0x9,%edi
  801abd:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  801ac4:	00 00 00 
  801ac7:	ff d0                	callq  *%rax
  801ac9:	48 83 c4 10          	add    $0x10,%rsp
}
  801acd:	c9                   	leaveq 
  801ace:	c3                   	retq   

0000000000801acf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801acf:	55                   	push   %rbp
  801ad0:	48 89 e5             	mov    %rsp,%rbp
  801ad3:	48 83 ec 20          	sub    $0x20,%rsp
  801ad7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ada:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ade:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ae2:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ae5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ae8:	48 63 f0             	movslq %eax,%rsi
  801aeb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801aef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af2:	48 98                	cltq   
  801af4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af8:	48 83 ec 08          	sub    $0x8,%rsp
  801afc:	6a 00                	pushq  $0x0
  801afe:	49 89 f1             	mov    %rsi,%r9
  801b01:	49 89 c8             	mov    %rcx,%r8
  801b04:	48 89 d1             	mov    %rdx,%rcx
  801b07:	48 89 c2             	mov    %rax,%rdx
  801b0a:	be 00 00 00 00       	mov    $0x0,%esi
  801b0f:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b14:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  801b1b:	00 00 00 
  801b1e:	ff d0                	callq  *%rax
  801b20:	48 83 c4 10          	add    $0x10,%rsp
}
  801b24:	c9                   	leaveq 
  801b25:	c3                   	retq   

0000000000801b26 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b26:	55                   	push   %rbp
  801b27:	48 89 e5             	mov    %rsp,%rbp
  801b2a:	48 83 ec 10          	sub    $0x10,%rsp
  801b2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b36:	48 83 ec 08          	sub    $0x8,%rsp
  801b3a:	6a 00                	pushq  $0x0
  801b3c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b42:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b48:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b4d:	48 89 c2             	mov    %rax,%rdx
  801b50:	be 01 00 00 00       	mov    $0x1,%esi
  801b55:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b5a:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  801b61:	00 00 00 
  801b64:	ff d0                	callq  *%rax
  801b66:	48 83 c4 10          	add    $0x10,%rsp
}
  801b6a:	c9                   	leaveq 
  801b6b:	c3                   	retq   

0000000000801b6c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801b6c:	55                   	push   %rbp
  801b6d:	48 89 e5             	mov    %rsp,%rbp
  801b70:	53                   	push   %rbx
  801b71:	48 83 ec 38          	sub    $0x38,%rsp
  801b75:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = ROUNDDOWN((void *) utf->utf_fault_va, PGSIZE);
  801b79:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b7d:	48 8b 00             	mov    (%rax),%rax
  801b80:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801b84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b88:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801b8e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801b92:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b96:	48 8b 40 08          	mov    0x8(%rax),%rax
  801b9a:	89 45 dc             	mov    %eax,-0x24(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//err is not a writing error & permissions are not PTE_COW
	if (!((uvpt[(uint64_t)addr/PGSIZE] & PTE_COW) && (err & FEC_WR))){
  801b9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ba1:	48 c1 e8 0c          	shr    $0xc,%rax
  801ba5:	48 89 c2             	mov    %rax,%rdx
  801ba8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801baf:	01 00 00 
  801bb2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bb6:	25 00 08 00 00       	and    $0x800,%eax
  801bbb:	48 85 c0             	test   %rax,%rax
  801bbe:	74 0a                	je     801bca <pgfault+0x5e>
  801bc0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bc3:	83 e0 02             	and    $0x2,%eax
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	75 2a                	jne    801bf4 <pgfault+0x88>
		panic("not proper page fault");	
  801bca:	48 ba 98 2b 80 00 00 	movabs $0x802b98,%rdx
  801bd1:	00 00 00 
  801bd4:	be 1e 00 00 00       	mov    $0x1e,%esi
  801bd9:	48 bf ae 2b 80 00 00 	movabs $0x802bae,%rdi
  801be0:	00 00 00 
  801be3:	b8 00 00 00 00       	mov    $0x0,%eax
  801be8:	48 b9 ff 23 80 00 00 	movabs $0x8023ff,%rcx
  801bef:	00 00 00 
  801bf2:	ff d1                	callq  *%rcx
	// LAB 4: Your code here.
	
	int result;

	//allocate new page & map it
	result = sys_page_alloc(sys_getenvid(), PFTEMP, PTE_P|PTE_U|PTE_W);
  801bf4:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  801bfb:	00 00 00 
  801bfe:	ff d0                	callq  *%rax
  801c00:	ba 07 00 00 00       	mov    $0x7,%edx
  801c05:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c0a:	89 c7                	mov    %eax,%edi
  801c0c:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  801c13:	00 00 00 
  801c16:	ff d0                	callq  *%rax
  801c18:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801c1b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c1f:	79 2a                	jns    801c4b <pgfault+0xdf>
		panic("page allocation failed in copy-on-write faulting page");
  801c21:	48 ba c0 2b 80 00 00 	movabs $0x802bc0,%rdx
  801c28:	00 00 00 
  801c2b:	be 2f 00 00 00       	mov    $0x2f,%esi
  801c30:	48 bf ae 2b 80 00 00 	movabs $0x802bae,%rdi
  801c37:	00 00 00 
  801c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3f:	48 b9 ff 23 80 00 00 	movabs $0x8023ff,%rcx
  801c46:	00 00 00 
  801c49:	ff d1                	callq  *%rcx
	}
	
	//copy page
	memcpy(PFTEMP, addr, PGSIZE);
  801c4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c4f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c54:	48 89 c6             	mov    %rax,%rsi
  801c57:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801c5c:	48 b8 3e 14 80 00 00 	movabs $0x80143e,%rax
  801c63:	00 00 00 
  801c66:	ff d0                	callq  *%rax
	
	//map new page into original page's space
	result = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_W|PTE_U|PTE_P);
  801c68:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  801c6f:	00 00 00 
  801c72:	ff d0                	callq  *%rax
  801c74:	89 c3                	mov    %eax,%ebx
  801c76:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  801c7d:	00 00 00 
  801c80:	ff d0                	callq  *%rax
  801c82:	89 c7                	mov    %eax,%edi
  801c84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c88:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801c8e:	48 89 c1             	mov    %rax,%rcx
  801c91:	89 da                	mov    %ebx,%edx
  801c93:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c98:	48 b8 8a 19 80 00 00 	movabs $0x80198a,%rax
  801c9f:	00 00 00 
  801ca2:	ff d0                	callq  *%rax
  801ca4:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801ca7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801cab:	79 2a                	jns    801cd7 <pgfault+0x16b>
                panic("page mapping failed in copy-on-write faulting page");
  801cad:	48 ba f8 2b 80 00 00 	movabs $0x802bf8,%rdx
  801cb4:	00 00 00 
  801cb7:	be 38 00 00 00       	mov    $0x38,%esi
  801cbc:	48 bf ae 2b 80 00 00 	movabs $0x802bae,%rdi
  801cc3:	00 00 00 
  801cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccb:	48 b9 ff 23 80 00 00 	movabs $0x8023ff,%rcx
  801cd2:	00 00 00 
  801cd5:	ff d1                	callq  *%rcx
        }

	//delete temporary location
	result = sys_page_unmap(sys_getenvid(), PFTEMP);
  801cd7:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  801cde:	00 00 00 
  801ce1:	ff d0                	callq  *%rax
  801ce3:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ce8:	89 c7                	mov    %eax,%edi
  801cea:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801cf1:	00 00 00 
  801cf4:	ff d0                	callq  *%rax
  801cf6:	89 45 d8             	mov    %eax,-0x28(%rbp)
	if (result<0){
  801cf9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801cfd:	79 2a                	jns    801d29 <pgfault+0x1bd>
                panic("temporary page unmapping failed in copy-on-write faulting page");
  801cff:	48 ba 30 2c 80 00 00 	movabs $0x802c30,%rdx
  801d06:	00 00 00 
  801d09:	be 3e 00 00 00       	mov    $0x3e,%esi
  801d0e:	48 bf ae 2b 80 00 00 	movabs $0x802bae,%rdi
  801d15:	00 00 00 
  801d18:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1d:	48 b9 ff 23 80 00 00 	movabs $0x8023ff,%rcx
  801d24:	00 00 00 
  801d27:	ff d1                	callq  *%rcx
        }	

	//panic("pgfault not implemented");

}
  801d29:	90                   	nop
  801d2a:	48 83 c4 38          	add    $0x38,%rsp
  801d2e:	5b                   	pop    %rbx
  801d2f:	5d                   	pop    %rbp
  801d30:	c3                   	retq   

0000000000801d31 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d31:	55                   	push   %rbp
  801d32:	48 89 e5             	mov    %rsp,%rbp
  801d35:	53                   	push   %rbx
  801d36:	48 83 ec 28          	sub    $0x28,%rsp
  801d3a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801d3d:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uint64_t)pn*PGSIZE);	
  801d40:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801d43:	48 c1 e0 0c          	shl    $0xc,%rax
  801d47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result;

	//COW or writable
	if ((uvpt[pn]&PTE_COW) || (uvpt[pn]&PTE_W)){
  801d4b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d52:	01 00 00 
  801d55:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801d58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d5c:	25 00 08 00 00       	and    $0x800,%eax
  801d61:	48 85 c0             	test   %rax,%rax
  801d64:	75 1d                	jne    801d83 <duppage+0x52>
  801d66:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d6d:	01 00 00 
  801d70:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801d73:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d77:	83 e0 02             	and    $0x2,%eax
  801d7a:	48 85 c0             	test   %rax,%rax
  801d7d:	0f 84 8f 00 00 00    	je     801e12 <duppage+0xe1>
		//map to child
		result = sys_page_map(sys_getenvid(), addr, envid, addr, PTE_COW|PTE_U|PTE_P);
  801d83:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  801d8a:	00 00 00 
  801d8d:	ff d0                	callq  *%rax
  801d8f:	89 c7                	mov    %eax,%edi
  801d91:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d95:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801d98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d9c:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801da2:	48 89 c6             	mov    %rax,%rsi
  801da5:	48 b8 8a 19 80 00 00 	movabs $0x80198a,%rax
  801dac:	00 00 00 
  801daf:	ff d0                	callq  *%rax
  801db1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (result<0){
  801db4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801db8:	79 0a                	jns    801dc4 <duppage+0x93>
			return -1;
  801dba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801dbf:	e9 91 00 00 00       	jmpq   801e55 <duppage+0x124>
		}

		//remap page with proper permissions COW
		result = sys_page_map(sys_getenvid(), addr, sys_getenvid(), addr, PTE_COW|PTE_U|PTE_P);
  801dc4:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  801dcb:	00 00 00 
  801dce:	ff d0                	callq  *%rax
  801dd0:	89 c3                	mov    %eax,%ebx
  801dd2:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  801dd9:	00 00 00 
  801ddc:	ff d0                	callq  *%rax
  801dde:	89 c7                	mov    %eax,%edi
  801de0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801de4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de8:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801dee:	48 89 d1             	mov    %rdx,%rcx
  801df1:	89 da                	mov    %ebx,%edx
  801df3:	48 89 c6             	mov    %rax,%rsi
  801df6:	48 b8 8a 19 80 00 00 	movabs $0x80198a,%rax
  801dfd:	00 00 00 
  801e00:	ff d0                	callq  *%rax
  801e02:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (result<0){
  801e05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801e09:	79 45                	jns    801e50 <duppage+0x11f>
                        return -1;
  801e0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801e10:	eb 43                	jmp    801e55 <duppage+0x124>
                } 	
	//not proper permissions
	}else{
		result=sys_page_map(sys_getenvid(), addr, envid, addr, PTE_P|PTE_U);
  801e12:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  801e19:	00 00 00 
  801e1c:	ff d0                	callq  *%rax
  801e1e:	89 c7                	mov    %eax,%edi
  801e20:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e24:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801e27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e2b:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  801e31:	48 89 c6             	mov    %rax,%rsi
  801e34:	48 b8 8a 19 80 00 00 	movabs $0x80198a,%rax
  801e3b:	00 00 00 
  801e3e:	ff d0                	callq  *%rax
  801e40:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (result<0){
  801e43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801e47:	79 07                	jns    801e50 <duppage+0x11f>
			return -1;
  801e49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801e4e:	eb 05                	jmp    801e55 <duppage+0x124>
		}
	}

	//panic("duppage not implemented");
	return 0;
  801e50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e55:	48 83 c4 28          	add    $0x28,%rsp
  801e59:	5b                   	pop    %rbx
  801e5a:	5d                   	pop    %rbp
  801e5b:	c3                   	retq   

0000000000801e5c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801e5c:	55                   	push   %rbp
  801e5d:	48 89 e5             	mov    %rsp,%rbp
  801e60:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	//LOOKED AT DUMBFORK FOR HELP :)	


	//step 1 
	set_pgfault_handler(pgfault);
  801e64:	48 bf 6c 1b 80 00 00 	movabs $0x801b6c,%rdi
  801e6b:	00 00 00 
  801e6e:	48 b8 13 25 80 00 00 	movabs $0x802513,%rax
  801e75:	00 00 00 
  801e78:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801e7a:	b8 07 00 00 00       	mov    $0x7,%eax
  801e7f:	cd 30                	int    $0x30
  801e81:	89 45 e8             	mov    %eax,-0x18(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801e84:	8b 45 e8             	mov    -0x18(%rbp),%eax
	
	//step 2
	envid_t child = sys_exofork();
  801e87:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (child==0){
  801e8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e8e:	75 46                	jne    801ed6 <fork+0x7a>
		//fix env in child
		thisenv = &envs[ENVX(sys_getenvid())];
  801e90:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  801e97:	00 00 00 
  801e9a:	ff d0                	callq  *%rax
  801e9c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ea1:	48 63 d0             	movslq %eax,%rdx
  801ea4:	48 89 d0             	mov    %rdx,%rax
  801ea7:	48 c1 e0 03          	shl    $0x3,%rax
  801eab:	48 01 d0             	add    %rdx,%rax
  801eae:	48 c1 e0 05          	shl    $0x5,%rax
  801eb2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801eb9:	00 00 00 
  801ebc:	48 01 c2             	add    %rax,%rdx
  801ebf:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  801ec6:	00 00 00 
  801ec9:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801ecc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed1:	e9 2b 03 00 00       	jmpq   802201 <fork+0x3a5>
	}
	if(child<0){
  801ed6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801eda:	79 0a                	jns    801ee6 <fork+0x8a>
		return -1; //exofork failed
  801edc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801ee1:	e9 1b 03 00 00       	jmpq   802201 <fork+0x3a5>

//For each writable or copy-on-write page in its address space below UTOP, the parent calls duppage, which should map the page copy-on-write into the address space of the child and then remap the page copy-on-write in its own address space. duppage sets both PTEs so that the page is not writeable, and to contain PTE_COW in the "avail" field to distinguish copy-on-write pages from genuine read-only pages.

	uintptr_t addr;
	extern unsigned char end[];
	for (addr = (uintptr_t)UTEXT; addr < (uintptr_t)end; addr += PGSIZE){//taken from dumbfork
  801ee6:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  801eed:	00 
  801eee:	e9 ec 00 00 00       	jmpq   801fdf <fork+0x183>
		
		//check if page is copy on write
		int perms = (uvpml4e[VPML4E(addr)] & PTE_P);
  801ef3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef7:	48 c1 e8 27          	shr    $0x27,%rax
  801efb:	48 89 c2             	mov    %rax,%rdx
  801efe:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f05:	01 00 00 
  801f08:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f0c:	83 e0 01             	and    $0x1,%eax
  801f0f:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpde[VPDPE(addr)] & PTE_P);
  801f12:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f16:	74 28                	je     801f40 <fork+0xe4>
  801f18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1c:	48 c1 e8 1e          	shr    $0x1e,%rax
  801f20:	48 89 c2             	mov    %rax,%rdx
  801f23:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801f2a:	01 00 00 
  801f2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f31:	83 e0 01             	and    $0x1,%eax
  801f34:	48 85 c0             	test   %rax,%rax
  801f37:	74 07                	je     801f40 <fork+0xe4>
  801f39:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3e:	eb 05                	jmp    801f45 <fork+0xe9>
  801f40:	b8 00 00 00 00       	mov    $0x0,%eax
  801f45:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpd[VPD(addr)] & PTE_P);		
  801f48:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f4c:	74 28                	je     801f76 <fork+0x11a>
  801f4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f52:	48 c1 e8 15          	shr    $0x15,%rax
  801f56:	48 89 c2             	mov    %rax,%rdx
  801f59:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f60:	01 00 00 
  801f63:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f67:	83 e0 01             	and    $0x1,%eax
  801f6a:	48 85 c0             	test   %rax,%rax
  801f6d:	74 07                	je     801f76 <fork+0x11a>
  801f6f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f74:	eb 05                	jmp    801f7b <fork+0x11f>
  801f76:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		perms = perms && (uvpt[PGNUM(addr)] & (PTE_P | PTE_U));
  801f7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f82:	74 28                	je     801fac <fork+0x150>
  801f84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f88:	48 c1 e8 0c          	shr    $0xc,%rax
  801f8c:	48 89 c2             	mov    %rax,%rdx
  801f8f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f96:	01 00 00 
  801f99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f9d:	83 e0 05             	and    $0x5,%eax
  801fa0:	48 85 c0             	test   %rax,%rax
  801fa3:	74 07                	je     801fac <fork+0x150>
  801fa5:	b8 01 00 00 00       	mov    $0x1,%eax
  801faa:	eb 05                	jmp    801fb1 <fork+0x155>
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb1:	89 45 f0             	mov    %eax,-0x10(%rbp)

		if (perms){
  801fb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801fb8:	74 1d                	je     801fd7 <fork+0x17b>
			duppage(child, PGNUM(addr));
  801fba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fbe:	48 c1 e8 0c          	shr    $0xc,%rax
  801fc2:	89 c2                	mov    %eax,%edx
  801fc4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fc7:	89 d6                	mov    %edx,%esi
  801fc9:	89 c7                	mov    %eax,%edi
  801fcb:	48 b8 31 1d 80 00 00 	movabs $0x801d31,%rax
  801fd2:	00 00 00 
  801fd5:	ff d0                	callq  *%rax

//For each writable or copy-on-write page in its address space below UTOP, the parent calls duppage, which should map the page copy-on-write into the address space of the child and then remap the page copy-on-write in its own address space. duppage sets both PTEs so that the page is not writeable, and to contain PTE_COW in the "avail" field to distinguish copy-on-write pages from genuine read-only pages.

	uintptr_t addr;
	extern unsigned char end[];
	for (addr = (uintptr_t)UTEXT; addr < (uintptr_t)end; addr += PGSIZE){//taken from dumbfork
  801fd7:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  801fde:	00 
  801fdf:	48 b8 28 40 80 00 00 	movabs $0x804028,%rax
  801fe6:	00 00 00 
  801fe9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  801fed:	0f 82 00 ff ff ff    	jb     801ef3 <fork+0x97>
//The exception stack is not remapped this way, however. Instead you need to allocate a fresh page in the child for the exception stack. Since the page fault handler will be doing the actual copying and the page fault handler runs on the exception stack, the exception stack cannot be made copy-on-write: who would copy it?

	int result;

        //allocate new page & map it
        result = sys_page_alloc(sys_getenvid(), PFTEMP, PTE_P|PTE_U|PTE_W);
  801ff3:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  801ffa:	00 00 00 
  801ffd:	ff d0                	callq  *%rax
  801fff:	ba 07 00 00 00       	mov    $0x7,%edx
  802004:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802009:	89 c7                	mov    %eax,%edi
  80200b:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  802012:	00 00 00 
  802015:	ff d0                	callq  *%rax
  802017:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  80201a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80201e:	79 2a                	jns    80204a <fork+0x1ee>
                panic("page allocation failed in fork");
  802020:	48 ba 70 2c 80 00 00 	movabs $0x802c70,%rdx
  802027:	00 00 00 
  80202a:	be b0 00 00 00       	mov    $0xb0,%esi
  80202f:	48 bf ae 2b 80 00 00 	movabs $0x802bae,%rdi
  802036:	00 00 00 
  802039:	b8 00 00 00 00       	mov    $0x0,%eax
  80203e:	48 b9 ff 23 80 00 00 	movabs $0x8023ff,%rcx
  802045:	00 00 00 
  802048:	ff d1                	callq  *%rcx
        }

        //copy page
        memcpy(PFTEMP, (void *)(USTACKTOP-PGSIZE), PGSIZE);
  80204a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80204f:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802054:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802059:	48 b8 3e 14 80 00 00 	movabs $0x80143e,%rax
  802060:	00 00 00 
  802063:	ff d0                	callq  *%rax

        //map new page into original page's space
        result = sys_page_map(sys_getenvid(), PFTEMP, child,(void *)(USTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  802065:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  80206c:	00 00 00 
  80206f:	ff d0                	callq  *%rax
  802071:	89 c7                	mov    %eax,%edi
  802073:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802076:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80207c:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  802081:	89 c2                	mov    %eax,%edx
  802083:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802088:	48 b8 8a 19 80 00 00 	movabs $0x80198a,%rax
  80208f:	00 00 00 
  802092:	ff d0                	callq  *%rax
  802094:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  802097:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80209b:	79 2a                	jns    8020c7 <fork+0x26b>
                panic("page mapping failed in fork");
  80209d:	48 ba 8f 2c 80 00 00 	movabs $0x802c8f,%rdx
  8020a4:	00 00 00 
  8020a7:	be b9 00 00 00       	mov    $0xb9,%esi
  8020ac:	48 bf ae 2b 80 00 00 	movabs $0x802bae,%rdi
  8020b3:	00 00 00 
  8020b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bb:	48 b9 ff 23 80 00 00 	movabs $0x8023ff,%rcx
  8020c2:	00 00 00 
  8020c5:	ff d1                	callq  *%rcx
        }

        //delete temporary location
        result = sys_page_unmap(sys_getenvid(), PFTEMP);
  8020c7:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  8020ce:	00 00 00 
  8020d1:	ff d0                	callq  *%rax
  8020d3:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020d8:	89 c7                	mov    %eax,%edi
  8020da:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  8020e1:	00 00 00 
  8020e4:	ff d0                	callq  *%rax
  8020e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (result<0){
  8020e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020ed:	79 2a                	jns    802119 <fork+0x2bd>
                panic("temporary page unmapping failed in copy-on-write faulting page");
  8020ef:	48 ba 30 2c 80 00 00 	movabs $0x802c30,%rdx
  8020f6:	00 00 00 
  8020f9:	be bf 00 00 00       	mov    $0xbf,%esi
  8020fe:	48 bf ae 2b 80 00 00 	movabs $0x802bae,%rdi
  802105:	00 00 00 
  802108:	b8 00 00 00 00       	mov    $0x0,%eax
  80210d:	48 b9 ff 23 80 00 00 	movabs $0x8023ff,%rcx
  802114:	00 00 00 
  802117:	ff d1                	callq  *%rcx
        }
// STEP 4
//The parent sets the user page fault entrypoint for the child to look like its own.

	result=sys_page_alloc(child, (void*)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W);
  802119:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80211c:	ba 07 00 00 00       	mov    $0x7,%edx
  802121:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802126:	89 c7                	mov    %eax,%edi
  802128:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  80212f:	00 00 00 
  802132:	ff d0                	callq  *%rax
  802134:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  802137:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80213b:	79 2a                	jns    802167 <fork+0x30b>
		panic("page alloc of table failed in fork");
  80213d:	48 ba b0 2c 80 00 00 	movabs $0x802cb0,%rdx
  802144:	00 00 00 
  802147:	be c6 00 00 00       	mov    $0xc6,%esi
  80214c:	48 bf ae 2b 80 00 00 	movabs $0x802bae,%rdi
  802153:	00 00 00 
  802156:	b8 00 00 00 00       	mov    $0x0,%eax
  80215b:	48 b9 ff 23 80 00 00 	movabs $0x8023ff,%rcx
  802162:	00 00 00 
  802165:	ff d1                	callq  *%rcx
	}

	extern void _pgfault_upcall();
	result = sys_env_set_pgfault_upcall(child, _pgfault_upcall);
  802167:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80216a:	48 be f7 25 80 00 00 	movabs $0x8025f7,%rsi
  802171:	00 00 00 
  802174:	89 c7                	mov    %eax,%edi
  802176:	48 b8 83 1a 80 00 00 	movabs $0x801a83,%rax
  80217d:	00 00 00 
  802180:	ff d0                	callq  *%rax
  802182:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  802185:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802189:	79 2a                	jns    8021b5 <fork+0x359>
		panic("setting upcall failed in fork"); 
  80218b:	48 ba d3 2c 80 00 00 	movabs $0x802cd3,%rdx
  802192:	00 00 00 
  802195:	be cc 00 00 00       	mov    $0xcc,%esi
  80219a:	48 bf ae 2b 80 00 00 	movabs $0x802bae,%rdi
  8021a1:	00 00 00 
  8021a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a9:	48 b9 ff 23 80 00 00 	movabs $0x8023ff,%rcx
  8021b0:	00 00 00 
  8021b3:	ff d1                	callq  *%rcx
	}
// STEP 5
//The child is now ready to run, so the parent marks it runnable.

	result = sys_env_set_status(child, ENV_RUNNABLE);
  8021b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021b8:	be 02 00 00 00       	mov    $0x2,%esi
  8021bd:	89 c7                	mov    %eax,%edi
  8021bf:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  8021c6:	00 00 00 
  8021c9:	ff d0                	callq  *%rax
  8021cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
	if (result<0){
  8021ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021d2:	79 2a                	jns    8021fe <fork+0x3a2>
		panic("changing statys is fork failed");
  8021d4:	48 ba f8 2c 80 00 00 	movabs $0x802cf8,%rdx
  8021db:	00 00 00 
  8021de:	be d3 00 00 00       	mov    $0xd3,%esi
  8021e3:	48 bf ae 2b 80 00 00 	movabs $0x802bae,%rdi
  8021ea:	00 00 00 
  8021ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f2:	48 b9 ff 23 80 00 00 	movabs $0x8023ff,%rcx
  8021f9:	00 00 00 
  8021fc:	ff d1                	callq  *%rcx
	}
	
	return child;
  8021fe:	8b 45 f4             	mov    -0xc(%rbp),%eax

}
  802201:	c9                   	leaveq 
  802202:	c3                   	retq   

0000000000802203 <sfork>:

// Challenge!
int
sfork(void)
{
  802203:	55                   	push   %rbp
  802204:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802207:	48 ba 17 2d 80 00 00 	movabs $0x802d17,%rdx
  80220e:	00 00 00 
  802211:	be de 00 00 00       	mov    $0xde,%esi
  802216:	48 bf ae 2b 80 00 00 	movabs $0x802bae,%rdi
  80221d:	00 00 00 
  802220:	b8 00 00 00 00       	mov    $0x0,%eax
  802225:	48 b9 ff 23 80 00 00 	movabs $0x8023ff,%rcx
  80222c:	00 00 00 
  80222f:	ff d1                	callq  *%rcx

0000000000802231 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802231:	55                   	push   %rbp
  802232:	48 89 e5             	mov    %rsp,%rbp
  802235:	48 83 ec 30          	sub    $0x30,%rsp
  802239:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80223d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802241:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	//cprintf("lib ipc_recv\n");
	// LAB 4: Your code here.
	if (pg==NULL){
  802245:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80224a:	75 08                	jne    802254 <ipc_recv+0x23>
		pg = (void *) -1;	
  80224c:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  802253:	ff 
	}
	
	int result = sys_ipc_recv(pg);
  802254:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802258:	48 89 c7             	mov    %rax,%rdi
  80225b:	48 b8 26 1b 80 00 00 	movabs $0x801b26,%rax
  802262:	00 00 00 
  802265:	ff d0                	callq  *%rax
  802267:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (result<0){
  80226a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80226e:	79 27                	jns    802297 <ipc_recv+0x66>
		if (from_env_store){
  802270:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802275:	74 0a                	je     802281 <ipc_recv+0x50>
			*from_env_store=0;
  802277:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if (perm_store){
  802281:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802286:	74 0a                	je     802292 <ipc_recv+0x61>
			*perm_store = 0;
  802288:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80228c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		return result;
  802292:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802295:	eb 53                	jmp    8022ea <ipc_recv+0xb9>
	}	
	if (from_env_store){
  802297:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80229c:	74 19                	je     8022b7 <ipc_recv+0x86>
	 	*from_env_store = thisenv->env_ipc_from;
  80229e:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  8022a5:	00 00 00 
  8022a8:	48 8b 00             	mov    (%rax),%rax
  8022ab:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8022b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b5:	89 10                	mov    %edx,(%rax)
        }
        if (perm_store){
  8022b7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022bc:	74 19                	je     8022d7 <ipc_recv+0xa6>
               	*perm_store = thisenv->env_ipc_perm;
  8022be:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  8022c5:	00 00 00 
  8022c8:	48 8b 00             	mov    (%rax),%rax
  8022cb:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8022d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022d5:	89 10                	mov    %edx,(%rax)
        }
	//panic("ipc_recv not implemented");
	return thisenv->env_ipc_value;
  8022d7:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  8022de:	00 00 00 
  8022e1:	48 8b 00             	mov    (%rax),%rax
  8022e4:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  8022ea:	c9                   	leaveq 
  8022eb:	c3                   	retq   

00000000008022ec <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022ec:	55                   	push   %rbp
  8022ed:	48 89 e5             	mov    %rsp,%rbp
  8022f0:	48 83 ec 30          	sub    $0x30,%rsp
  8022f4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022f7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8022fa:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8022fe:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	//cprintf("lib ipc_send\n");
	// LAB 4: Your code here.
	if (pg==NULL){
  802301:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802306:	75 4c                	jne    802354 <ipc_send+0x68>
		pg = (void *)-1;
  802308:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  80230f:	ff 
	}
	int result;
	while((result=sys_ipc_try_send(to_env, val, pg, perm))){
  802310:	eb 42                	jmp    802354 <ipc_send+0x68>
		if (result==0){
  802312:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802316:	74 62                	je     80237a <ipc_send+0x8e>
			break;
		}
		if (result!=-E_IPC_NOT_RECV){
  802318:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80231c:	74 2a                	je     802348 <ipc_send+0x5c>
			panic("syscall returned improper error");
  80231e:	48 ba 30 2d 80 00 00 	movabs $0x802d30,%rdx
  802325:	00 00 00 
  802328:	be 49 00 00 00       	mov    $0x49,%esi
  80232d:	48 bf 50 2d 80 00 00 	movabs $0x802d50,%rdi
  802334:	00 00 00 
  802337:	b8 00 00 00 00       	mov    $0x0,%eax
  80233c:	48 b9 ff 23 80 00 00 	movabs $0x8023ff,%rcx
  802343:	00 00 00 
  802346:	ff d1                	callq  *%rcx
		}
		sys_yield();
  802348:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  80234f:	00 00 00 
  802352:	ff d0                	callq  *%rax
	// LAB 4: Your code here.
	if (pg==NULL){
		pg = (void *)-1;
	}
	int result;
	while((result=sys_ipc_try_send(to_env, val, pg, perm))){
  802354:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802357:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80235a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80235e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802361:	89 c7                	mov    %eax,%edi
  802363:	48 b8 cf 1a 80 00 00 	movabs $0x801acf,%rax
  80236a:	00 00 00 
  80236d:	ff d0                	callq  *%rax
  80236f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802372:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802376:	75 9a                	jne    802312 <ipc_send+0x26>
			panic("syscall returned improper error");
		}
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  802378:	eb 01                	jmp    80237b <ipc_send+0x8f>
		pg = (void *)-1;
	}
	int result;
	while((result=sys_ipc_try_send(to_env, val, pg, perm))){
		if (result==0){
			break;
  80237a:	90                   	nop
			panic("syscall returned improper error");
		}
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80237b:	90                   	nop
  80237c:	c9                   	leaveq 
  80237d:	c3                   	retq   

000000000080237e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80237e:	55                   	push   %rbp
  80237f:	48 89 e5             	mov    %rsp,%rbp
  802382:	48 83 ec 18          	sub    $0x18,%rsp
  802386:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802389:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802390:	eb 5d                	jmp    8023ef <ipc_find_env+0x71>
		if (envs[i].env_type == type)
  802392:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802399:	00 00 00 
  80239c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80239f:	48 63 d0             	movslq %eax,%rdx
  8023a2:	48 89 d0             	mov    %rdx,%rax
  8023a5:	48 c1 e0 03          	shl    $0x3,%rax
  8023a9:	48 01 d0             	add    %rdx,%rax
  8023ac:	48 c1 e0 05          	shl    $0x5,%rax
  8023b0:	48 01 c8             	add    %rcx,%rax
  8023b3:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8023b9:	8b 00                	mov    (%rax),%eax
  8023bb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8023be:	75 2b                	jne    8023eb <ipc_find_env+0x6d>
			return envs[i].env_id;
  8023c0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8023c7:	00 00 00 
  8023ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023cd:	48 63 d0             	movslq %eax,%rdx
  8023d0:	48 89 d0             	mov    %rdx,%rax
  8023d3:	48 c1 e0 03          	shl    $0x3,%rax
  8023d7:	48 01 d0             	add    %rdx,%rax
  8023da:	48 c1 e0 05          	shl    $0x5,%rax
  8023de:	48 01 c8             	add    %rcx,%rax
  8023e1:	48 05 c8 00 00 00    	add    $0xc8,%rax
  8023e7:	8b 00                	mov    (%rax),%eax
  8023e9:	eb 12                	jmp    8023fd <ipc_find_env+0x7f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8023eb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023ef:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8023f6:	7e 9a                	jle    802392 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023fd:	c9                   	leaveq 
  8023fe:	c3                   	retq   

00000000008023ff <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8023ff:	55                   	push   %rbp
  802400:	48 89 e5             	mov    %rsp,%rbp
  802403:	53                   	push   %rbx
  802404:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80240b:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802412:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802418:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80241f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802426:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80242d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802434:	84 c0                	test   %al,%al
  802436:	74 23                	je     80245b <_panic+0x5c>
  802438:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80243f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802443:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802447:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80244b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80244f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802453:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802457:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80245b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802462:	00 00 00 
  802465:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80246c:	00 00 00 
  80246f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802473:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80247a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802481:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802488:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80248f:	00 00 00 
  802492:	48 8b 18             	mov    (%rax),%rbx
  802495:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  80249c:	00 00 00 
  80249f:	ff d0                	callq  *%rax
  8024a1:	89 c6                	mov    %eax,%esi
  8024a3:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8024a9:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8024b0:	41 89 d0             	mov    %edx,%r8d
  8024b3:	48 89 c1             	mov    %rax,%rcx
  8024b6:	48 89 da             	mov    %rbx,%rdx
  8024b9:	48 bf 60 2d 80 00 00 	movabs $0x802d60,%rdi
  8024c0:	00 00 00 
  8024c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c8:	49 b9 72 04 80 00 00 	movabs $0x800472,%r9
  8024cf:	00 00 00 
  8024d2:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8024d5:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8024dc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8024e3:	48 89 d6             	mov    %rdx,%rsi
  8024e6:	48 89 c7             	mov    %rax,%rdi
  8024e9:	48 b8 c6 03 80 00 00 	movabs $0x8003c6,%rax
  8024f0:	00 00 00 
  8024f3:	ff d0                	callq  *%rax
	cprintf("\n");
  8024f5:	48 bf 83 2d 80 00 00 	movabs $0x802d83,%rdi
  8024fc:	00 00 00 
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802504:	48 ba 72 04 80 00 00 	movabs $0x800472,%rdx
  80250b:	00 00 00 
  80250e:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802510:	cc                   	int3   
  802511:	eb fd                	jmp    802510 <_panic+0x111>

0000000000802513 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802513:	55                   	push   %rbp
  802514:	48 89 e5             	mov    %rsp,%rbp
  802517:	48 83 ec 20          	sub    $0x20,%rsp
  80251b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler==0) {
  80251f:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  802526:	00 00 00 
  802529:	48 8b 00             	mov    (%rax),%rax
  80252c:	48 85 c0             	test   %rax,%rax
  80252f:	0f 85 ae 00 00 00    	jne    8025e3 <set_pgfault_handler+0xd0>
		//allocate space
		int result = sys_page_alloc(sys_getenvid(), (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  802535:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  80253c:	00 00 00 
  80253f:	ff d0                	callq  *%rax
  802541:	ba 07 00 00 00       	mov    $0x7,%edx
  802546:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80254b:	89 c7                	mov    %eax,%edi
  80254d:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  802554:	00 00 00 
  802557:	ff d0                	callq  *%rax
  802559:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  80255c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802560:	79 2a                	jns    80258c <set_pgfault_handler+0x79>
			panic("sys_page_alloc for stack failed in setting page fault handler");
  802562:	48 ba 88 2d 80 00 00 	movabs $0x802d88,%rdx
  802569:	00 00 00 
  80256c:	be 21 00 00 00       	mov    $0x21,%esi
  802571:	48 bf c6 2d 80 00 00 	movabs $0x802dc6,%rdi
  802578:	00 00 00 
  80257b:	b8 00 00 00 00       	mov    $0x0,%eax
  802580:	48 b9 ff 23 80 00 00 	movabs $0x8023ff,%rcx
  802587:	00 00 00 
  80258a:	ff d1                	callq  *%rcx
		}

		//actual set upcall
		result = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  80258c:	48 b8 bf 18 80 00 00 	movabs $0x8018bf,%rax
  802593:	00 00 00 
  802596:	ff d0                	callq  *%rax
  802598:	48 be f7 25 80 00 00 	movabs $0x8025f7,%rsi
  80259f:	00 00 00 
  8025a2:	89 c7                	mov    %eax,%edi
  8025a4:	48 b8 83 1a 80 00 00 	movabs $0x801a83,%rax
  8025ab:	00 00 00 
  8025ae:	ff d0                	callq  *%rax
  8025b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  8025b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b7:	79 2a                	jns    8025e3 <set_pgfault_handler+0xd0>
                        panic("setting upcall failed in setting page fault handler");
  8025b9:	48 ba d8 2d 80 00 00 	movabs $0x802dd8,%rdx
  8025c0:	00 00 00 
  8025c3:	be 27 00 00 00       	mov    $0x27,%esi
  8025c8:	48 bf c6 2d 80 00 00 	movabs $0x802dc6,%rdi
  8025cf:	00 00 00 
  8025d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d7:	48 b9 ff 23 80 00 00 	movabs $0x8023ff,%rcx
  8025de:	00 00 00 
  8025e1:	ff d1                	callq  *%rcx
                }
		//panic("set_pgfault_handler not implemented");
	}

	_pgfault_handler = handler;
  8025e3:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8025ea:	00 00 00 
  8025ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025f1:	48 89 10             	mov    %rdx,(%rax)

}
  8025f4:	90                   	nop
  8025f5:	c9                   	leaveq 
  8025f6:	c3                   	retq   

00000000008025f7 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8025f7:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8025fa:	48 a1 20 40 80 00 00 	movabs 0x804020,%rax
  802601:	00 00 00 
call *%rax
  802604:	ff d0                	callq  *%rax
	//MAKE STACK CALCS for getting parameters
	//20 = size of stack
	//8 = size of word	

	//(20-3)*8=17*8=136
	movq 136(%rsp), %rax
  802606:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  80260d:	00 
	//(20-1)*8=152
	subq $8, 152(%rsp)
  80260e:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  802615:	00 08 
	movq 152(%rsp), %rbx
  802617:	48 8b 9c 24 98 00 00 	mov    0x98(%rsp),%rbx
  80261e:	00 
	movq %rax, (%rbx)
  80261f:	48 89 03             	mov    %rax,(%rbx)
	addq $16, %rsp
  802622:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
	
    	POPA_
  802626:	4c 8b 3c 24          	mov    (%rsp),%r15
  80262a:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80262f:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802634:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802639:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80263e:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802643:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802648:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80264d:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802652:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802657:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80265c:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802661:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802666:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80266b:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802670:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
	//https://www.felixcloutier.com/x86/POPF:POPFD:POPFQ.html
    	addq $8, %rsp
  802674:	48 83 c4 08          	add    $0x8,%rsp
    	popfq	
  802678:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    	popq %rsp
  802679:	5c                   	pop    %rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    	ret
  80267a:	c3                   	retq   
