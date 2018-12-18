
obj/user/faultregs:     file format elf64-x86-64


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
  80003c:	e8 f8 09 00 00       	callq  800a39 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800053:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800057:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
  80005b:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
	int mismatch = 0;
  80005f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800066:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80006a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80006e:	48 89 d1             	mov    %rdx,%rcx
  800071:	48 89 c2             	mov    %rax,%rdx
  800074:	48 be 80 25 80 00 00 	movabs $0x802580,%rsi
  80007b:	00 00 00 
  80007e:	48 bf 81 25 80 00 00 	movabs $0x802581,%rdi
  800085:	00 00 00 
  800088:	b8 00 00 00 00       	mov    $0x0,%eax
  80008d:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  800094:	00 00 00 
  800097:	41 ff d0             	callq  *%r8
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_rdi);
  80009a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80009e:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000a6:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000aa:	48 89 d1             	mov    %rdx,%rcx
  8000ad:	48 89 c2             	mov    %rax,%rdx
  8000b0:	48 be 91 25 80 00 00 	movabs $0x802591,%rsi
  8000b7:	00 00 00 
  8000ba:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  8000c1:	00 00 00 
  8000c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c9:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  8000d0:	00 00 00 
  8000d3:	41 ff d0             	callq  *%r8
  8000d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000da:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8000e2:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000e6:	48 39 c2             	cmp    %rax,%rdx
  8000e9:	75 1d                	jne    800108 <check_regs+0xc5>
  8000eb:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800101:	00 00 00 
  800104:	ff d2                	callq  *%rdx
  800106:	eb 22                	jmp    80012a <check_regs+0xe7>
  800108:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  80010f:	00 00 00 
  800112:	b8 00 00 00 00       	mov    $0x0,%eax
  800117:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  80011e:	00 00 00 
  800121:	ff d2                	callq  *%rdx
  800123:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(esi, regs.reg_rsi);
  80012a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80012e:	48 8b 50 40          	mov    0x40(%rax),%rdx
  800132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800136:	48 8b 40 40          	mov    0x40(%rax),%rax
  80013a:	48 89 d1             	mov    %rdx,%rcx
  80013d:	48 89 c2             	mov    %rax,%rdx
  800140:	48 be b3 25 80 00 00 	movabs $0x8025b3,%rsi
  800147:	00 00 00 
  80014a:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  800151:	00 00 00 
  800154:	b8 00 00 00 00       	mov    $0x0,%eax
  800159:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  800160:	00 00 00 
  800163:	41 ff d0             	callq  *%r8
  800166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80016a:	48 8b 50 40          	mov    0x40(%rax),%rdx
  80016e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800172:	48 8b 40 40          	mov    0x40(%rax),%rax
  800176:	48 39 c2             	cmp    %rax,%rdx
  800179:	75 1d                	jne    800198 <check_regs+0x155>
  80017b:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  800182:	00 00 00 
  800185:	b8 00 00 00 00       	mov    $0x0,%eax
  80018a:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800191:	00 00 00 
  800194:	ff d2                	callq  *%rdx
  800196:	eb 22                	jmp    8001ba <check_regs+0x177>
  800198:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  80019f:	00 00 00 
  8001a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a7:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8001ae:	00 00 00 
  8001b1:	ff d2                	callq  *%rdx
  8001b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ebp, regs.reg_rbp);
  8001ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8001be:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001c6:	48 8b 40 50          	mov    0x50(%rax),%rax
  8001ca:	48 89 d1             	mov    %rdx,%rcx
  8001cd:	48 89 c2             	mov    %rax,%rdx
  8001d0:	48 be b7 25 80 00 00 	movabs $0x8025b7,%rsi
  8001d7:	00 00 00 
  8001da:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  8001f0:	00 00 00 
  8001f3:	41 ff d0             	callq  *%r8
  8001f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001fa:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800202:	48 8b 40 50          	mov    0x50(%rax),%rax
  800206:	48 39 c2             	cmp    %rax,%rdx
  800209:	75 1d                	jne    800228 <check_regs+0x1e5>
  80020b:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  800212:	00 00 00 
  800215:	b8 00 00 00 00       	mov    $0x0,%eax
  80021a:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800221:	00 00 00 
  800224:	ff d2                	callq  *%rdx
  800226:	eb 22                	jmp    80024a <check_regs+0x207>
  800228:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  80022f:	00 00 00 
  800232:	b8 00 00 00 00       	mov    $0x0,%eax
  800237:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  80023e:	00 00 00 
  800241:	ff d2                	callq  *%rdx
  800243:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ebx, regs.reg_rbx);
  80024a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80024e:	48 8b 50 68          	mov    0x68(%rax),%rdx
  800252:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800256:	48 8b 40 68          	mov    0x68(%rax),%rax
  80025a:	48 89 d1             	mov    %rdx,%rcx
  80025d:	48 89 c2             	mov    %rax,%rdx
  800260:	48 be bb 25 80 00 00 	movabs $0x8025bb,%rsi
  800267:	00 00 00 
  80026a:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  800280:	00 00 00 
  800283:	41 ff d0             	callq  *%r8
  800286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80028a:	48 8b 50 68          	mov    0x68(%rax),%rdx
  80028e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800292:	48 8b 40 68          	mov    0x68(%rax),%rax
  800296:	48 39 c2             	cmp    %rax,%rdx
  800299:	75 1d                	jne    8002b8 <check_regs+0x275>
  80029b:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  8002a2:	00 00 00 
  8002a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002aa:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8002b1:	00 00 00 
  8002b4:	ff d2                	callq  *%rdx
  8002b6:	eb 22                	jmp    8002da <check_regs+0x297>
  8002b8:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  8002bf:	00 00 00 
  8002c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c7:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8002ce:	00 00 00 
  8002d1:	ff d2                	callq  *%rdx
  8002d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(edx, regs.reg_rdx);
  8002da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002de:	48 8b 50 58          	mov    0x58(%rax),%rdx
  8002e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002e6:	48 8b 40 58          	mov    0x58(%rax),%rax
  8002ea:	48 89 d1             	mov    %rdx,%rcx
  8002ed:	48 89 c2             	mov    %rax,%rdx
  8002f0:	48 be bf 25 80 00 00 	movabs $0x8025bf,%rsi
  8002f7:	00 00 00 
  8002fa:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  800301:	00 00 00 
  800304:	b8 00 00 00 00       	mov    $0x0,%eax
  800309:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  800310:	00 00 00 
  800313:	41 ff d0             	callq  *%r8
  800316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80031a:	48 8b 50 58          	mov    0x58(%rax),%rdx
  80031e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800322:	48 8b 40 58          	mov    0x58(%rax),%rax
  800326:	48 39 c2             	cmp    %rax,%rdx
  800329:	75 1d                	jne    800348 <check_regs+0x305>
  80032b:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  800332:	00 00 00 
  800335:	b8 00 00 00 00       	mov    $0x0,%eax
  80033a:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800341:	00 00 00 
  800344:	ff d2                	callq  *%rdx
  800346:	eb 22                	jmp    80036a <check_regs+0x327>
  800348:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  80034f:	00 00 00 
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  80035e:	00 00 00 
  800361:	ff d2                	callq  *%rdx
  800363:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ecx, regs.reg_rcx);
  80036a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80036e:	48 8b 50 60          	mov    0x60(%rax),%rdx
  800372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800376:	48 8b 40 60          	mov    0x60(%rax),%rax
  80037a:	48 89 d1             	mov    %rdx,%rcx
  80037d:	48 89 c2             	mov    %rax,%rdx
  800380:	48 be c3 25 80 00 00 	movabs $0x8025c3,%rsi
  800387:	00 00 00 
  80038a:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  800391:	00 00 00 
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  8003a0:	00 00 00 
  8003a3:	41 ff d0             	callq  *%r8
  8003a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003aa:	48 8b 50 60          	mov    0x60(%rax),%rdx
  8003ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003b2:	48 8b 40 60          	mov    0x60(%rax),%rax
  8003b6:	48 39 c2             	cmp    %rax,%rdx
  8003b9:	75 1d                	jne    8003d8 <check_regs+0x395>
  8003bb:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  8003c2:	00 00 00 
  8003c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ca:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8003d1:	00 00 00 
  8003d4:	ff d2                	callq  *%rdx
  8003d6:	eb 22                	jmp    8003fa <check_regs+0x3b7>
  8003d8:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  8003df:	00 00 00 
  8003e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e7:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8003ee:	00 00 00 
  8003f1:	ff d2                	callq  *%rdx
  8003f3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eax, regs.reg_rax);
  8003fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003fe:	48 8b 50 70          	mov    0x70(%rax),%rdx
  800402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800406:	48 8b 40 70          	mov    0x70(%rax),%rax
  80040a:	48 89 d1             	mov    %rdx,%rcx
  80040d:	48 89 c2             	mov    %rax,%rdx
  800410:	48 be c7 25 80 00 00 	movabs $0x8025c7,%rsi
  800417:	00 00 00 
  80041a:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  800421:	00 00 00 
  800424:	b8 00 00 00 00       	mov    $0x0,%eax
  800429:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  800430:	00 00 00 
  800433:	41 ff d0             	callq  *%r8
  800436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043a:	48 8b 50 70          	mov    0x70(%rax),%rdx
  80043e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800442:	48 8b 40 70          	mov    0x70(%rax),%rax
  800446:	48 39 c2             	cmp    %rax,%rdx
  800449:	75 1d                	jne    800468 <check_regs+0x425>
  80044b:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  800452:	00 00 00 
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800461:	00 00 00 
  800464:	ff d2                	callq  *%rdx
  800466:	eb 22                	jmp    80048a <check_regs+0x447>
  800468:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  80046f:	00 00 00 
  800472:	b8 00 00 00 00       	mov    $0x0,%eax
  800477:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  80047e:	00 00 00 
  800481:	ff d2                	callq  *%rdx
  800483:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eip, eip);
  80048a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80048e:	48 8b 50 78          	mov    0x78(%rax),%rdx
  800492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800496:	48 8b 40 78          	mov    0x78(%rax),%rax
  80049a:	48 89 d1             	mov    %rdx,%rcx
  80049d:	48 89 c2             	mov    %rax,%rdx
  8004a0:	48 be cb 25 80 00 00 	movabs $0x8025cb,%rsi
  8004a7:	00 00 00 
  8004aa:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  8004b1:	00 00 00 
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  8004c0:	00 00 00 
  8004c3:	41 ff d0             	callq  *%r8
  8004c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ca:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8004ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004d2:	48 8b 40 78          	mov    0x78(%rax),%rax
  8004d6:	48 39 c2             	cmp    %rax,%rdx
  8004d9:	75 1d                	jne    8004f8 <check_regs+0x4b5>
  8004db:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  8004e2:	00 00 00 
  8004e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ea:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8004f1:	00 00 00 
  8004f4:	ff d2                	callq  *%rdx
  8004f6:	eb 22                	jmp    80051a <check_regs+0x4d7>
  8004f8:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  8004ff:	00 00 00 
  800502:	b8 00 00 00 00       	mov    $0x0,%eax
  800507:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  80050e:	00 00 00 
  800511:	ff d2                	callq  *%rdx
  800513:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eflags, eflags);
  80051a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80051e:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800529:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800530:	48 89 d1             	mov    %rdx,%rcx
  800533:	48 89 c2             	mov    %rax,%rdx
  800536:	48 be cf 25 80 00 00 	movabs $0x8025cf,%rsi
  80053d:	00 00 00 
  800540:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  800547:	00 00 00 
  80054a:	b8 00 00 00 00       	mov    $0x0,%eax
  80054f:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  800556:	00 00 00 
  800559:	41 ff d0             	callq  *%r8
  80055c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800560:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80056b:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800572:	48 39 c2             	cmp    %rax,%rdx
  800575:	75 1d                	jne    800594 <check_regs+0x551>
  800577:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  80057e:	00 00 00 
  800581:	b8 00 00 00 00       	mov    $0x0,%eax
  800586:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  80058d:	00 00 00 
  800590:	ff d2                	callq  *%rdx
  800592:	eb 22                	jmp    8005b6 <check_regs+0x573>
  800594:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  80059b:	00 00 00 
  80059e:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a3:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8005aa:	00 00 00 
  8005ad:	ff d2                	callq  *%rdx
  8005af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(esp, esp);
  8005b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ba:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8005c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c5:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  8005cc:	48 89 d1             	mov    %rdx,%rcx
  8005cf:	48 89 c2             	mov    %rax,%rdx
  8005d2:	48 be d6 25 80 00 00 	movabs $0x8025d6,%rsi
  8005d9:	00 00 00 
  8005dc:	48 bf 95 25 80 00 00 	movabs $0x802595,%rdi
  8005e3:	00 00 00 
  8005e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005eb:	49 b8 17 0d 80 00 00 	movabs $0x800d17,%r8
  8005f2:	00 00 00 
  8005f5:	41 ff d0             	callq  *%r8
  8005f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fc:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  800603:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800607:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  80060e:	48 39 c2             	cmp    %rax,%rdx
  800611:	75 1d                	jne    800630 <check_regs+0x5ed>
  800613:	48 bf a5 25 80 00 00 	movabs $0x8025a5,%rdi
  80061a:	00 00 00 
  80061d:	b8 00 00 00 00       	mov    $0x0,%eax
  800622:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800629:	00 00 00 
  80062c:	ff d2                	callq  *%rdx
  80062e:	eb 22                	jmp    800652 <check_regs+0x60f>
  800630:	48 bf a9 25 80 00 00 	movabs $0x8025a9,%rdi
  800637:	00 00 00 
  80063a:	b8 00 00 00 00       	mov    $0x0,%eax
  80063f:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800646:	00 00 00 
  800649:	ff d2                	callq  *%rdx
  80064b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

#undef CHECK


	if (!mismatch)
  800652:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800656:	75 24                	jne    80067c <check_regs+0x639>
		cprintf("Registers %s OK\n", testname);
  800658:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80065c:	48 89 c6             	mov    %rax,%rsi
  80065f:	48 bf da 25 80 00 00 	movabs $0x8025da,%rdi
  800666:	00 00 00 
  800669:	b8 00 00 00 00       	mov    $0x0,%eax
  80066e:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800675:	00 00 00 
  800678:	ff d2                	callq  *%rdx
	else
		cprintf("Registers %s MISMATCH\n", testname);
}
  80067a:	eb 22                	jmp    80069e <check_regs+0x65b>


	if (!mismatch)
		cprintf("Registers %s OK\n", testname);
	else
		cprintf("Registers %s MISMATCH\n", testname);
  80067c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800680:	48 89 c6             	mov    %rax,%rsi
  800683:	48 bf eb 25 80 00 00 	movabs $0x8025eb,%rdi
  80068a:	00 00 00 
  80068d:	b8 00 00 00 00       	mov    $0x0,%eax
  800692:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800699:	00 00 00 
  80069c:	ff d2                	callq  *%rdx
}
  80069e:	90                   	nop
  80069f:	c9                   	leaveq 
  8006a0:	c3                   	retq   

00000000008006a1 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8006a1:	55                   	push   %rbp
  8006a2:	48 89 e5             	mov    %rsp,%rbp
  8006a5:	48 83 ec 20          	sub    $0x20,%rsp
  8006a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (utf->utf_fault_va != (uint64_t)UTEMP)
  8006ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b1:	48 8b 00             	mov    (%rax),%rax
  8006b4:	48 3d 00 00 40 00    	cmp    $0x400000,%rax
  8006ba:	74 43                	je     8006ff <pgfault+0x5e>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  8006bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c0:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8006c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cb:	48 8b 00             	mov    (%rax),%rax
  8006ce:	49 89 d0             	mov    %rdx,%r8
  8006d1:	48 89 c1             	mov    %rax,%rcx
  8006d4:	48 ba 08 26 80 00 00 	movabs $0x802608,%rdx
  8006db:	00 00 00 
  8006de:	be 5f 00 00 00       	mov    $0x5f,%esi
  8006e3:	48 bf 39 26 80 00 00 	movabs $0x802639,%rdi
  8006ea:	00 00 00 
  8006ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f2:	49 b9 dd 0a 80 00 00 	movabs $0x800add,%r9
  8006f9:	00 00 00 
  8006fc:	41 ff d1             	callq  *%r9
		      utf->utf_fault_va, utf->utf_rip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8006ff:	48 b8 c0 40 80 00 00 	movabs $0x8040c0,%rax
  800706:	00 00 00 
  800709:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070d:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  800711:	48 89 08             	mov    %rcx,(%rax)
  800714:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
  800718:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80071c:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
  800720:	48 89 48 10          	mov    %rcx,0x10(%rax)
  800724:	48 8b 4a 28          	mov    0x28(%rdx),%rcx
  800728:	48 89 48 18          	mov    %rcx,0x18(%rax)
  80072c:	48 8b 4a 30          	mov    0x30(%rdx),%rcx
  800730:	48 89 48 20          	mov    %rcx,0x20(%rax)
  800734:	48 8b 4a 38          	mov    0x38(%rdx),%rcx
  800738:	48 89 48 28          	mov    %rcx,0x28(%rax)
  80073c:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
  800740:	48 89 48 30          	mov    %rcx,0x30(%rax)
  800744:	48 8b 4a 48          	mov    0x48(%rdx),%rcx
  800748:	48 89 48 38          	mov    %rcx,0x38(%rax)
  80074c:	48 8b 4a 50          	mov    0x50(%rdx),%rcx
  800750:	48 89 48 40          	mov    %rcx,0x40(%rax)
  800754:	48 8b 4a 58          	mov    0x58(%rdx),%rcx
  800758:	48 89 48 48          	mov    %rcx,0x48(%rax)
  80075c:	48 8b 4a 60          	mov    0x60(%rdx),%rcx
  800760:	48 89 48 50          	mov    %rcx,0x50(%rax)
  800764:	48 8b 4a 68          	mov    0x68(%rdx),%rcx
  800768:	48 89 48 58          	mov    %rcx,0x58(%rax)
  80076c:	48 8b 4a 70          	mov    0x70(%rdx),%rcx
  800770:	48 89 48 60          	mov    %rcx,0x60(%rax)
  800774:	48 8b 4a 78          	mov    0x78(%rdx),%rcx
  800778:	48 89 48 68          	mov    %rcx,0x68(%rax)
  80077c:	48 8b 92 80 00 00 00 	mov    0x80(%rdx),%rdx
  800783:	48 89 50 70          	mov    %rdx,0x70(%rax)
	during.eip = utf->utf_rip;
  800787:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078b:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  800792:	48 b8 c0 40 80 00 00 	movabs $0x8040c0,%rax
  800799:	00 00 00 
  80079c:	48 89 50 78          	mov    %rdx,0x78(%rax)
	during.eflags = utf->utf_eflags & 0xfff;
  8007a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a4:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
  8007ab:	25 ff 0f 00 00       	and    $0xfff,%eax
  8007b0:	48 89 c2             	mov    %rax,%rdx
  8007b3:	48 b8 c0 40 80 00 00 	movabs $0x8040c0,%rax
  8007ba:	00 00 00 
  8007bd:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
	during.esp = utf->utf_rsp;
  8007c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c8:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
  8007cf:	48 b8 c0 40 80 00 00 	movabs $0x8040c0,%rax
  8007d6:	00 00 00 
  8007d9:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  8007e0:	49 b8 4a 26 80 00 00 	movabs $0x80264a,%r8
  8007e7:	00 00 00 
  8007ea:	48 b9 58 26 80 00 00 	movabs $0x802658,%rcx
  8007f1:	00 00 00 
  8007f4:	48 ba c0 40 80 00 00 	movabs $0x8040c0,%rdx
  8007fb:	00 00 00 
  8007fe:	48 be 5f 26 80 00 00 	movabs $0x80265f,%rsi
  800805:	00 00 00 
  800808:	48 bf 20 40 80 00 00 	movabs $0x804020,%rdi
  80080f:	00 00 00 
  800812:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800819:	00 00 00 
  80081c:	ff d0                	callq  *%rax

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  80081e:	ba 07 00 00 00       	mov    $0x7,%edx
  800823:	be 00 00 40 00       	mov    $0x400000,%esi
  800828:	bf 00 00 00 00       	mov    $0x0,%edi
  80082d:	48 b8 dd 21 80 00 00 	movabs $0x8021dd,%rax
  800834:	00 00 00 
  800837:	ff d0                	callq  *%rax
  800839:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80083c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800840:	79 30                	jns    800872 <pgfault+0x1d1>
		panic("sys_page_alloc: %e", r);
  800842:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800845:	89 c1                	mov    %eax,%ecx
  800847:	48 ba 66 26 80 00 00 	movabs $0x802666,%rdx
  80084e:	00 00 00 
  800851:	be 6a 00 00 00       	mov    $0x6a,%esi
  800856:	48 bf 39 26 80 00 00 	movabs $0x802639,%rdi
  80085d:	00 00 00 
  800860:	b8 00 00 00 00       	mov    $0x0,%eax
  800865:	49 b8 dd 0a 80 00 00 	movabs $0x800add,%r8
  80086c:	00 00 00 
  80086f:	41 ff d0             	callq  *%r8
}
  800872:	90                   	nop
  800873:	c9                   	leaveq 
  800874:	c3                   	retq   

0000000000800875 <umain>:

void
umain(int argc, char **argv)
{
  800875:	55                   	push   %rbp
  800876:	48 89 e5             	mov    %rsp,%rbp
  800879:	48 83 ec 10          	sub    $0x10,%rsp
  80087d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800880:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(pgfault);
  800884:	48 bf a1 06 80 00 00 	movabs $0x8006a1,%rdi
  80088b:	00 00 00 
  80088e:	48 b8 11 24 80 00 00 	movabs $0x802411,%rax
  800895:	00 00 00 
  800898:	ff d0                	callq  *%rax

	__asm __volatile(
  80089a:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8008a1:	00 00 00 
  8008a4:	48 ba 60 41 80 00 00 	movabs $0x804160,%rdx
  8008ab:	00 00 00 
  8008ae:	50                   	push   %rax
  8008af:	52                   	push   %rdx
  8008b0:	50                   	push   %rax
  8008b1:	9c                   	pushfq 
  8008b2:	58                   	pop    %rax
  8008b3:	48 0d d4 08 00 00    	or     $0x8d4,%rax
  8008b9:	50                   	push   %rax
  8008ba:	9d                   	popfq  
  8008bb:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  8008c0:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8008c7:	48 8d 04 25 13 09 80 	lea    0x800913,%rax
  8008ce:	00 
  8008cf:	49 89 47 78          	mov    %rax,0x78(%r15)
  8008d3:	58                   	pop    %rax
  8008d4:	4d 89 77 08          	mov    %r14,0x8(%r15)
  8008d8:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  8008dc:	4d 89 67 18          	mov    %r12,0x18(%r15)
  8008e0:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  8008e4:	4d 89 57 28          	mov    %r10,0x28(%r15)
  8008e8:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  8008ec:	4d 89 47 38          	mov    %r8,0x38(%r15)
  8008f0:	49 89 77 40          	mov    %rsi,0x40(%r15)
  8008f4:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  8008f8:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  8008fc:	49 89 57 58          	mov    %rdx,0x58(%r15)
  800900:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800904:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800908:	49 89 47 70          	mov    %rax,0x70(%r15)
  80090c:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  800913:	c7 04 25 00 00 40 00 	movl   $0x2a,0x400000
  80091a:	2a 00 00 00 
  80091e:	4c 8b 3c 24          	mov    (%rsp),%r15
  800922:	4d 89 77 08          	mov    %r14,0x8(%r15)
  800926:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  80092a:	4d 89 67 18          	mov    %r12,0x18(%r15)
  80092e:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  800932:	4d 89 57 28          	mov    %r10,0x28(%r15)
  800936:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  80093a:	4d 89 47 38          	mov    %r8,0x38(%r15)
  80093e:	49 89 77 40          	mov    %rsi,0x40(%r15)
  800942:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  800946:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  80094a:	49 89 57 58          	mov    %rdx,0x58(%r15)
  80094e:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800952:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800956:	49 89 47 70          	mov    %rax,0x70(%r15)
  80095a:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  800961:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  800966:	4d 8b 77 08          	mov    0x8(%r15),%r14
  80096a:	4d 8b 6f 10          	mov    0x10(%r15),%r13
  80096e:	4d 8b 67 18          	mov    0x18(%r15),%r12
  800972:	4d 8b 5f 20          	mov    0x20(%r15),%r11
  800976:	4d 8b 57 28          	mov    0x28(%r15),%r10
  80097a:	4d 8b 4f 30          	mov    0x30(%r15),%r9
  80097e:	4d 8b 47 38          	mov    0x38(%r15),%r8
  800982:	49 8b 77 40          	mov    0x40(%r15),%rsi
  800986:	49 8b 7f 48          	mov    0x48(%r15),%rdi
  80098a:	49 8b 6f 50          	mov    0x50(%r15),%rbp
  80098e:	49 8b 57 58          	mov    0x58(%r15),%rdx
  800992:	49 8b 4f 60          	mov    0x60(%r15),%rcx
  800996:	49 8b 5f 68          	mov    0x68(%r15),%rbx
  80099a:	49 8b 47 70          	mov    0x70(%r15),%rax
  80099e:	49 8b a7 88 00 00 00 	mov    0x88(%r15),%rsp
  8009a5:	50                   	push   %rax
  8009a6:	9c                   	pushfq 
  8009a7:	58                   	pop    %rax
  8009a8:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  8009ad:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8009b4:	58                   	pop    %rax
		: : "r" (&before), "r" (&after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  8009b5:	b8 00 00 40 00       	mov    $0x400000,%eax
  8009ba:	8b 00                	mov    (%rax),%eax
  8009bc:	83 f8 2a             	cmp    $0x2a,%eax
  8009bf:	74 1b                	je     8009dc <umain+0x167>
		cprintf("EIP after page-fault MISMATCH\n");
  8009c1:	48 bf 80 26 80 00 00 	movabs $0x802680,%rdi
  8009c8:	00 00 00 
  8009cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d0:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  8009d7:	00 00 00 
  8009da:	ff d2                	callq  *%rdx
	after.eip = before.eip;
  8009dc:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8009e3:	00 00 00 
  8009e6:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8009ea:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  8009f1:	00 00 00 
  8009f4:	48 89 50 78          	mov    %rdx,0x78(%rax)

	check_regs(&before, "before", &after, "after", "after page-fault");
  8009f8:	49 b8 9f 26 80 00 00 	movabs $0x80269f,%r8
  8009ff:	00 00 00 
  800a02:	48 b9 b0 26 80 00 00 	movabs $0x8026b0,%rcx
  800a09:	00 00 00 
  800a0c:	48 ba 60 41 80 00 00 	movabs $0x804160,%rdx
  800a13:	00 00 00 
  800a16:	48 be 5f 26 80 00 00 	movabs $0x80265f,%rsi
  800a1d:	00 00 00 
  800a20:	48 bf 20 40 80 00 00 	movabs $0x804020,%rdi
  800a27:	00 00 00 
  800a2a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800a31:	00 00 00 
  800a34:	ff d0                	callq  *%rax
}
  800a36:	90                   	nop
  800a37:	c9                   	leaveq 
  800a38:	c3                   	retq   

0000000000800a39 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a39:	55                   	push   %rbp
  800a3a:	48 89 e5             	mov    %rsp,%rbp
  800a3d:	48 83 ec 10          	sub    $0x10,%rsp
  800a41:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a44:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  800a48:	48 b8 64 21 80 00 00 	movabs $0x802164,%rax
  800a4f:	00 00 00 
  800a52:	ff d0                	callq  *%rax
  800a54:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a59:	48 63 d0             	movslq %eax,%rdx
  800a5c:	48 89 d0             	mov    %rdx,%rax
  800a5f:	48 c1 e0 03          	shl    $0x3,%rax
  800a63:	48 01 d0             	add    %rdx,%rax
  800a66:	48 c1 e0 05          	shl    $0x5,%rax
  800a6a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800a71:	00 00 00 
  800a74:	48 01 c2             	add    %rax,%rdx
  800a77:	48 b8 f0 41 80 00 00 	movabs $0x8041f0,%rax
  800a7e:	00 00 00 
  800a81:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a88:	7e 14                	jle    800a9e <libmain+0x65>
		binaryname = argv[0];
  800a8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a8e:	48 8b 10             	mov    (%rax),%rdx
  800a91:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800a98:	00 00 00 
  800a9b:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800a9e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800aa5:	48 89 d6             	mov    %rdx,%rsi
  800aa8:	89 c7                	mov    %eax,%edi
  800aaa:	48 b8 75 08 80 00 00 	movabs $0x800875,%rax
  800ab1:	00 00 00 
  800ab4:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800ab6:	48 b8 c5 0a 80 00 00 	movabs $0x800ac5,%rax
  800abd:	00 00 00 
  800ac0:	ff d0                	callq  *%rax
}
  800ac2:	90                   	nop
  800ac3:	c9                   	leaveq 
  800ac4:	c3                   	retq   

0000000000800ac5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800ac5:	55                   	push   %rbp
  800ac6:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800ac9:	bf 00 00 00 00       	mov    $0x0,%edi
  800ace:	48 b8 1e 21 80 00 00 	movabs $0x80211e,%rax
  800ad5:	00 00 00 
  800ad8:	ff d0                	callq  *%rax
}
  800ada:	90                   	nop
  800adb:	5d                   	pop    %rbp
  800adc:	c3                   	retq   

0000000000800add <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800add:	55                   	push   %rbp
  800ade:	48 89 e5             	mov    %rsp,%rbp
  800ae1:	53                   	push   %rbx
  800ae2:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800ae9:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800af0:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800af6:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800afd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800b04:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800b0b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800b12:	84 c0                	test   %al,%al
  800b14:	74 23                	je     800b39 <_panic+0x5c>
  800b16:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800b1d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800b21:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800b25:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800b29:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800b2d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800b31:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800b35:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b39:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800b40:	00 00 00 
  800b43:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800b4a:	00 00 00 
  800b4d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b51:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800b58:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800b5f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800b66:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800b6d:	00 00 00 
  800b70:	48 8b 18             	mov    (%rax),%rbx
  800b73:	48 b8 64 21 80 00 00 	movabs $0x802164,%rax
  800b7a:	00 00 00 
  800b7d:	ff d0                	callq  *%rax
  800b7f:	89 c6                	mov    %eax,%esi
  800b81:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800b87:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800b8e:	41 89 d0             	mov    %edx,%r8d
  800b91:	48 89 c1             	mov    %rax,%rcx
  800b94:	48 89 da             	mov    %rbx,%rdx
  800b97:	48 bf c0 26 80 00 00 	movabs $0x8026c0,%rdi
  800b9e:	00 00 00 
  800ba1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba6:	49 b9 17 0d 80 00 00 	movabs $0x800d17,%r9
  800bad:	00 00 00 
  800bb0:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800bb3:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800bba:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bc1:	48 89 d6             	mov    %rdx,%rsi
  800bc4:	48 89 c7             	mov    %rax,%rdi
  800bc7:	48 b8 6b 0c 80 00 00 	movabs $0x800c6b,%rax
  800bce:	00 00 00 
  800bd1:	ff d0                	callq  *%rax
	cprintf("\n");
  800bd3:	48 bf e3 26 80 00 00 	movabs $0x8026e3,%rdi
  800bda:	00 00 00 
  800bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800be2:	48 ba 17 0d 80 00 00 	movabs $0x800d17,%rdx
  800be9:	00 00 00 
  800bec:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800bee:	cc                   	int3   
  800bef:	eb fd                	jmp    800bee <_panic+0x111>

0000000000800bf1 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800bf1:	55                   	push   %rbp
  800bf2:	48 89 e5             	mov    %rsp,%rbp
  800bf5:	48 83 ec 10          	sub    $0x10,%rsp
  800bf9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bfc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800c00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c04:	8b 00                	mov    (%rax),%eax
  800c06:	8d 48 01             	lea    0x1(%rax),%ecx
  800c09:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c0d:	89 0a                	mov    %ecx,(%rdx)
  800c0f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c12:	89 d1                	mov    %edx,%ecx
  800c14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c18:	48 98                	cltq   
  800c1a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800c1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c22:	8b 00                	mov    (%rax),%eax
  800c24:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c29:	75 2c                	jne    800c57 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800c2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c2f:	8b 00                	mov    (%rax),%eax
  800c31:	48 98                	cltq   
  800c33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c37:	48 83 c2 08          	add    $0x8,%rdx
  800c3b:	48 89 c6             	mov    %rax,%rsi
  800c3e:	48 89 d7             	mov    %rdx,%rdi
  800c41:	48 b8 95 20 80 00 00 	movabs $0x802095,%rax
  800c48:	00 00 00 
  800c4b:	ff d0                	callq  *%rax
        b->idx = 0;
  800c4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c51:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800c57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c5b:	8b 40 04             	mov    0x4(%rax),%eax
  800c5e:	8d 50 01             	lea    0x1(%rax),%edx
  800c61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c65:	89 50 04             	mov    %edx,0x4(%rax)
}
  800c68:	90                   	nop
  800c69:	c9                   	leaveq 
  800c6a:	c3                   	retq   

0000000000800c6b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800c6b:	55                   	push   %rbp
  800c6c:	48 89 e5             	mov    %rsp,%rbp
  800c6f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800c76:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800c7d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800c84:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800c8b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800c92:	48 8b 0a             	mov    (%rdx),%rcx
  800c95:	48 89 08             	mov    %rcx,(%rax)
  800c98:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c9c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ca0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ca4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800ca8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800caf:	00 00 00 
    b.cnt = 0;
  800cb2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800cb9:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800cbc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800cc3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800cca:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800cd1:	48 89 c6             	mov    %rax,%rsi
  800cd4:	48 bf f1 0b 80 00 00 	movabs $0x800bf1,%rdi
  800cdb:	00 00 00 
  800cde:	48 b8 b5 10 80 00 00 	movabs $0x8010b5,%rax
  800ce5:	00 00 00 
  800ce8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800cea:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800cf0:	48 98                	cltq   
  800cf2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800cf9:	48 83 c2 08          	add    $0x8,%rdx
  800cfd:	48 89 c6             	mov    %rax,%rsi
  800d00:	48 89 d7             	mov    %rdx,%rdi
  800d03:	48 b8 95 20 80 00 00 	movabs $0x802095,%rax
  800d0a:	00 00 00 
  800d0d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800d0f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800d15:	c9                   	leaveq 
  800d16:	c3                   	retq   

0000000000800d17 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800d17:	55                   	push   %rbp
  800d18:	48 89 e5             	mov    %rsp,%rbp
  800d1b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800d22:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d29:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800d30:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800d37:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d3e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d45:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d4c:	84 c0                	test   %al,%al
  800d4e:	74 20                	je     800d70 <cprintf+0x59>
  800d50:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d54:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d58:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d5c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d60:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d64:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d68:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d6c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800d70:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800d77:	00 00 00 
  800d7a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d81:	00 00 00 
  800d84:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d88:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d8f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d96:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800d9d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800da4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dab:	48 8b 0a             	mov    (%rdx),%rcx
  800dae:	48 89 08             	mov    %rcx,(%rax)
  800db1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800db5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800db9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dbd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800dc1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800dc8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800dcf:	48 89 d6             	mov    %rdx,%rsi
  800dd2:	48 89 c7             	mov    %rax,%rdi
  800dd5:	48 b8 6b 0c 80 00 00 	movabs $0x800c6b,%rax
  800ddc:	00 00 00 
  800ddf:	ff d0                	callq  *%rax
  800de1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800de7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ded:	c9                   	leaveq 
  800dee:	c3                   	retq   

0000000000800def <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800def:	55                   	push   %rbp
  800df0:	48 89 e5             	mov    %rsp,%rbp
  800df3:	48 83 ec 30          	sub    $0x30,%rsp
  800df7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800dfb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800dff:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e03:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800e06:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800e0a:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e0e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800e11:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800e15:	77 54                	ja     800e6b <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e17:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800e1a:	8d 78 ff             	lea    -0x1(%rax),%edi
  800e1d:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800e20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e24:	ba 00 00 00 00       	mov    $0x0,%edx
  800e29:	48 f7 f6             	div    %rsi
  800e2c:	49 89 c2             	mov    %rax,%r10
  800e2f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800e32:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800e35:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800e39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e3d:	41 89 c9             	mov    %ecx,%r9d
  800e40:	41 89 f8             	mov    %edi,%r8d
  800e43:	89 d1                	mov    %edx,%ecx
  800e45:	4c 89 d2             	mov    %r10,%rdx
  800e48:	48 89 c7             	mov    %rax,%rdi
  800e4b:	48 b8 ef 0d 80 00 00 	movabs $0x800def,%rax
  800e52:	00 00 00 
  800e55:	ff d0                	callq  *%rax
  800e57:	eb 1c                	jmp    800e75 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e59:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800e5d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800e60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e64:	48 89 ce             	mov    %rcx,%rsi
  800e67:	89 d7                	mov    %edx,%edi
  800e69:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e6b:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800e6f:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800e73:	7f e4                	jg     800e59 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e75:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e81:	48 f7 f1             	div    %rcx
  800e84:	48 b8 50 28 80 00 00 	movabs $0x802850,%rax
  800e8b:	00 00 00 
  800e8e:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800e92:	0f be d0             	movsbl %al,%edx
  800e95:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800e99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e9d:	48 89 ce             	mov    %rcx,%rsi
  800ea0:	89 d7                	mov    %edx,%edi
  800ea2:	ff d0                	callq  *%rax
}
  800ea4:	90                   	nop
  800ea5:	c9                   	leaveq 
  800ea6:	c3                   	retq   

0000000000800ea7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ea7:	55                   	push   %rbp
  800ea8:	48 89 e5             	mov    %rsp,%rbp
  800eab:	48 83 ec 20          	sub    $0x20,%rsp
  800eaf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800eb6:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800eba:	7e 4f                	jle    800f0b <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800ebc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec0:	8b 00                	mov    (%rax),%eax
  800ec2:	83 f8 30             	cmp    $0x30,%eax
  800ec5:	73 24                	jae    800eeb <getuint+0x44>
  800ec7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ecb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ecf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed3:	8b 00                	mov    (%rax),%eax
  800ed5:	89 c0                	mov    %eax,%eax
  800ed7:	48 01 d0             	add    %rdx,%rax
  800eda:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ede:	8b 12                	mov    (%rdx),%edx
  800ee0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ee3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ee7:	89 0a                	mov    %ecx,(%rdx)
  800ee9:	eb 14                	jmp    800eff <getuint+0x58>
  800eeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eef:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ef3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ef7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800efb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800eff:	48 8b 00             	mov    (%rax),%rax
  800f02:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f06:	e9 9d 00 00 00       	jmpq   800fa8 <getuint+0x101>
	else if (lflag)
  800f0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f0f:	74 4c                	je     800f5d <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800f11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f15:	8b 00                	mov    (%rax),%eax
  800f17:	83 f8 30             	cmp    $0x30,%eax
  800f1a:	73 24                	jae    800f40 <getuint+0x99>
  800f1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f20:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f28:	8b 00                	mov    (%rax),%eax
  800f2a:	89 c0                	mov    %eax,%eax
  800f2c:	48 01 d0             	add    %rdx,%rax
  800f2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f33:	8b 12                	mov    (%rdx),%edx
  800f35:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f38:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f3c:	89 0a                	mov    %ecx,(%rdx)
  800f3e:	eb 14                	jmp    800f54 <getuint+0xad>
  800f40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f44:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f48:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800f4c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f50:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f54:	48 8b 00             	mov    (%rax),%rax
  800f57:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f5b:	eb 4b                	jmp    800fa8 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800f5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f61:	8b 00                	mov    (%rax),%eax
  800f63:	83 f8 30             	cmp    $0x30,%eax
  800f66:	73 24                	jae    800f8c <getuint+0xe5>
  800f68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f74:	8b 00                	mov    (%rax),%eax
  800f76:	89 c0                	mov    %eax,%eax
  800f78:	48 01 d0             	add    %rdx,%rax
  800f7b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f7f:	8b 12                	mov    (%rdx),%edx
  800f81:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f84:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f88:	89 0a                	mov    %ecx,(%rdx)
  800f8a:	eb 14                	jmp    800fa0 <getuint+0xf9>
  800f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f90:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f94:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800f98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f9c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fa0:	8b 00                	mov    (%rax),%eax
  800fa2:	89 c0                	mov    %eax,%eax
  800fa4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800fa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fac:	c9                   	leaveq 
  800fad:	c3                   	retq   

0000000000800fae <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800fae:	55                   	push   %rbp
  800faf:	48 89 e5             	mov    %rsp,%rbp
  800fb2:	48 83 ec 20          	sub    $0x20,%rsp
  800fb6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fba:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800fbd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800fc1:	7e 4f                	jle    801012 <getint+0x64>
		x=va_arg(*ap, long long);
  800fc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc7:	8b 00                	mov    (%rax),%eax
  800fc9:	83 f8 30             	cmp    $0x30,%eax
  800fcc:	73 24                	jae    800ff2 <getint+0x44>
  800fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fda:	8b 00                	mov    (%rax),%eax
  800fdc:	89 c0                	mov    %eax,%eax
  800fde:	48 01 d0             	add    %rdx,%rax
  800fe1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fe5:	8b 12                	mov    (%rdx),%edx
  800fe7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800fea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fee:	89 0a                	mov    %ecx,(%rdx)
  800ff0:	eb 14                	jmp    801006 <getint+0x58>
  800ff2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff6:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ffa:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ffe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801002:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801006:	48 8b 00             	mov    (%rax),%rax
  801009:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80100d:	e9 9d 00 00 00       	jmpq   8010af <getint+0x101>
	else if (lflag)
  801012:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801016:	74 4c                	je     801064 <getint+0xb6>
		x=va_arg(*ap, long);
  801018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101c:	8b 00                	mov    (%rax),%eax
  80101e:	83 f8 30             	cmp    $0x30,%eax
  801021:	73 24                	jae    801047 <getint+0x99>
  801023:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801027:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80102b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102f:	8b 00                	mov    (%rax),%eax
  801031:	89 c0                	mov    %eax,%eax
  801033:	48 01 d0             	add    %rdx,%rax
  801036:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80103a:	8b 12                	mov    (%rdx),%edx
  80103c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80103f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801043:	89 0a                	mov    %ecx,(%rdx)
  801045:	eb 14                	jmp    80105b <getint+0xad>
  801047:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80104f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801053:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801057:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80105b:	48 8b 00             	mov    (%rax),%rax
  80105e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801062:	eb 4b                	jmp    8010af <getint+0x101>
	else
		x=va_arg(*ap, int);
  801064:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801068:	8b 00                	mov    (%rax),%eax
  80106a:	83 f8 30             	cmp    $0x30,%eax
  80106d:	73 24                	jae    801093 <getint+0xe5>
  80106f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801073:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801077:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107b:	8b 00                	mov    (%rax),%eax
  80107d:	89 c0                	mov    %eax,%eax
  80107f:	48 01 d0             	add    %rdx,%rax
  801082:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801086:	8b 12                	mov    (%rdx),%edx
  801088:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80108b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80108f:	89 0a                	mov    %ecx,(%rdx)
  801091:	eb 14                	jmp    8010a7 <getint+0xf9>
  801093:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801097:	48 8b 40 08          	mov    0x8(%rax),%rax
  80109b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80109f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010a7:	8b 00                	mov    (%rax),%eax
  8010a9:	48 98                	cltq   
  8010ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8010af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010b3:	c9                   	leaveq 
  8010b4:	c3                   	retq   

00000000008010b5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010b5:	55                   	push   %rbp
  8010b6:	48 89 e5             	mov    %rsp,%rbp
  8010b9:	41 54                	push   %r12
  8010bb:	53                   	push   %rbx
  8010bc:	48 83 ec 60          	sub    $0x60,%rsp
  8010c0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8010c4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8010c8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8010cc:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8010d0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010d4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8010d8:	48 8b 0a             	mov    (%rdx),%rcx
  8010db:	48 89 08             	mov    %rcx,(%rax)
  8010de:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010e2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010e6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010ea:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010ee:	eb 17                	jmp    801107 <vprintfmt+0x52>
			if (ch == '\0')
  8010f0:	85 db                	test   %ebx,%ebx
  8010f2:	0f 84 b9 04 00 00    	je     8015b1 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  8010f8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010fc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801100:	48 89 d6             	mov    %rdx,%rsi
  801103:	89 df                	mov    %ebx,%edi
  801105:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801107:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80110b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80110f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801113:	0f b6 00             	movzbl (%rax),%eax
  801116:	0f b6 d8             	movzbl %al,%ebx
  801119:	83 fb 25             	cmp    $0x25,%ebx
  80111c:	75 d2                	jne    8010f0 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80111e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801122:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801129:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801130:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801137:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80113e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801142:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801146:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80114a:	0f b6 00             	movzbl (%rax),%eax
  80114d:	0f b6 d8             	movzbl %al,%ebx
  801150:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801153:	83 f8 55             	cmp    $0x55,%eax
  801156:	0f 87 22 04 00 00    	ja     80157e <vprintfmt+0x4c9>
  80115c:	89 c0                	mov    %eax,%eax
  80115e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801165:	00 
  801166:	48 b8 78 28 80 00 00 	movabs $0x802878,%rax
  80116d:	00 00 00 
  801170:	48 01 d0             	add    %rdx,%rax
  801173:	48 8b 00             	mov    (%rax),%rax
  801176:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  801178:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80117c:	eb c0                	jmp    80113e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80117e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  801182:	eb ba                	jmp    80113e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801184:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80118b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80118e:	89 d0                	mov    %edx,%eax
  801190:	c1 e0 02             	shl    $0x2,%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	01 c0                	add    %eax,%eax
  801197:	01 d8                	add    %ebx,%eax
  801199:	83 e8 30             	sub    $0x30,%eax
  80119c:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80119f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011a3:	0f b6 00             	movzbl (%rax),%eax
  8011a6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011a9:	83 fb 2f             	cmp    $0x2f,%ebx
  8011ac:	7e 60                	jle    80120e <vprintfmt+0x159>
  8011ae:	83 fb 39             	cmp    $0x39,%ebx
  8011b1:	7f 5b                	jg     80120e <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011b3:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011b8:	eb d1                	jmp    80118b <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8011ba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011bd:	83 f8 30             	cmp    $0x30,%eax
  8011c0:	73 17                	jae    8011d9 <vprintfmt+0x124>
  8011c2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011c6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011c9:	89 d2                	mov    %edx,%edx
  8011cb:	48 01 d0             	add    %rdx,%rax
  8011ce:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011d1:	83 c2 08             	add    $0x8,%edx
  8011d4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8011d7:	eb 0c                	jmp    8011e5 <vprintfmt+0x130>
  8011d9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8011dd:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8011e1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011e5:	8b 00                	mov    (%rax),%eax
  8011e7:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8011ea:	eb 23                	jmp    80120f <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  8011ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011f0:	0f 89 48 ff ff ff    	jns    80113e <vprintfmt+0x89>
				width = 0;
  8011f6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8011fd:	e9 3c ff ff ff       	jmpq   80113e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801202:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801209:	e9 30 ff ff ff       	jmpq   80113e <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80120e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80120f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801213:	0f 89 25 ff ff ff    	jns    80113e <vprintfmt+0x89>
				width = precision, precision = -1;
  801219:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80121c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80121f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801226:	e9 13 ff ff ff       	jmpq   80113e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80122b:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80122f:	e9 0a ff ff ff       	jmpq   80113e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801234:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801237:	83 f8 30             	cmp    $0x30,%eax
  80123a:	73 17                	jae    801253 <vprintfmt+0x19e>
  80123c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801240:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801243:	89 d2                	mov    %edx,%edx
  801245:	48 01 d0             	add    %rdx,%rax
  801248:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80124b:	83 c2 08             	add    $0x8,%edx
  80124e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801251:	eb 0c                	jmp    80125f <vprintfmt+0x1aa>
  801253:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801257:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80125b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80125f:	8b 10                	mov    (%rax),%edx
  801261:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801265:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801269:	48 89 ce             	mov    %rcx,%rsi
  80126c:	89 d7                	mov    %edx,%edi
  80126e:	ff d0                	callq  *%rax
			break;
  801270:	e9 37 03 00 00       	jmpq   8015ac <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801275:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801278:	83 f8 30             	cmp    $0x30,%eax
  80127b:	73 17                	jae    801294 <vprintfmt+0x1df>
  80127d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801281:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801284:	89 d2                	mov    %edx,%edx
  801286:	48 01 d0             	add    %rdx,%rax
  801289:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80128c:	83 c2 08             	add    $0x8,%edx
  80128f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801292:	eb 0c                	jmp    8012a0 <vprintfmt+0x1eb>
  801294:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801298:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80129c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012a0:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8012a2:	85 db                	test   %ebx,%ebx
  8012a4:	79 02                	jns    8012a8 <vprintfmt+0x1f3>
				err = -err;
  8012a6:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8012a8:	83 fb 15             	cmp    $0x15,%ebx
  8012ab:	7f 16                	jg     8012c3 <vprintfmt+0x20e>
  8012ad:	48 b8 a0 27 80 00 00 	movabs $0x8027a0,%rax
  8012b4:	00 00 00 
  8012b7:	48 63 d3             	movslq %ebx,%rdx
  8012ba:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8012be:	4d 85 e4             	test   %r12,%r12
  8012c1:	75 2e                	jne    8012f1 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  8012c3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8012c7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012cb:	89 d9                	mov    %ebx,%ecx
  8012cd:	48 ba 61 28 80 00 00 	movabs $0x802861,%rdx
  8012d4:	00 00 00 
  8012d7:	48 89 c7             	mov    %rax,%rdi
  8012da:	b8 00 00 00 00       	mov    $0x0,%eax
  8012df:	49 b8 bb 15 80 00 00 	movabs $0x8015bb,%r8
  8012e6:	00 00 00 
  8012e9:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8012ec:	e9 bb 02 00 00       	jmpq   8015ac <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8012f1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8012f5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012f9:	4c 89 e1             	mov    %r12,%rcx
  8012fc:	48 ba 6a 28 80 00 00 	movabs $0x80286a,%rdx
  801303:	00 00 00 
  801306:	48 89 c7             	mov    %rax,%rdi
  801309:	b8 00 00 00 00       	mov    $0x0,%eax
  80130e:	49 b8 bb 15 80 00 00 	movabs $0x8015bb,%r8
  801315:	00 00 00 
  801318:	41 ff d0             	callq  *%r8
			break;
  80131b:	e9 8c 02 00 00       	jmpq   8015ac <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801320:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801323:	83 f8 30             	cmp    $0x30,%eax
  801326:	73 17                	jae    80133f <vprintfmt+0x28a>
  801328:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80132c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80132f:	89 d2                	mov    %edx,%edx
  801331:	48 01 d0             	add    %rdx,%rax
  801334:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801337:	83 c2 08             	add    $0x8,%edx
  80133a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80133d:	eb 0c                	jmp    80134b <vprintfmt+0x296>
  80133f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801343:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801347:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80134b:	4c 8b 20             	mov    (%rax),%r12
  80134e:	4d 85 e4             	test   %r12,%r12
  801351:	75 0a                	jne    80135d <vprintfmt+0x2a8>
				p = "(null)";
  801353:	49 bc 6d 28 80 00 00 	movabs $0x80286d,%r12
  80135a:	00 00 00 
			if (width > 0 && padc != '-')
  80135d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801361:	7e 78                	jle    8013db <vprintfmt+0x326>
  801363:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801367:	74 72                	je     8013db <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  801369:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80136c:	48 98                	cltq   
  80136e:	48 89 c6             	mov    %rax,%rsi
  801371:	4c 89 e7             	mov    %r12,%rdi
  801374:	48 b8 69 18 80 00 00 	movabs $0x801869,%rax
  80137b:	00 00 00 
  80137e:	ff d0                	callq  *%rax
  801380:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801383:	eb 17                	jmp    80139c <vprintfmt+0x2e7>
					putch(padc, putdat);
  801385:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801389:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80138d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801391:	48 89 ce             	mov    %rcx,%rsi
  801394:	89 d7                	mov    %edx,%edi
  801396:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801398:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80139c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013a0:	7f e3                	jg     801385 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013a2:	eb 37                	jmp    8013db <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  8013a4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8013a8:	74 1e                	je     8013c8 <vprintfmt+0x313>
  8013aa:	83 fb 1f             	cmp    $0x1f,%ebx
  8013ad:	7e 05                	jle    8013b4 <vprintfmt+0x2ff>
  8013af:	83 fb 7e             	cmp    $0x7e,%ebx
  8013b2:	7e 14                	jle    8013c8 <vprintfmt+0x313>
					putch('?', putdat);
  8013b4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013b8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013bc:	48 89 d6             	mov    %rdx,%rsi
  8013bf:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8013c4:	ff d0                	callq  *%rax
  8013c6:	eb 0f                	jmp    8013d7 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  8013c8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013cc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013d0:	48 89 d6             	mov    %rdx,%rsi
  8013d3:	89 df                	mov    %ebx,%edi
  8013d5:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013d7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8013db:	4c 89 e0             	mov    %r12,%rax
  8013de:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8013e2:	0f b6 00             	movzbl (%rax),%eax
  8013e5:	0f be d8             	movsbl %al,%ebx
  8013e8:	85 db                	test   %ebx,%ebx
  8013ea:	74 28                	je     801414 <vprintfmt+0x35f>
  8013ec:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8013f0:	78 b2                	js     8013a4 <vprintfmt+0x2ef>
  8013f2:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8013f6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8013fa:	79 a8                	jns    8013a4 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013fc:	eb 16                	jmp    801414 <vprintfmt+0x35f>
				putch(' ', putdat);
  8013fe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801402:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801406:	48 89 d6             	mov    %rdx,%rsi
  801409:	bf 20 00 00 00       	mov    $0x20,%edi
  80140e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801410:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801414:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801418:	7f e4                	jg     8013fe <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  80141a:	e9 8d 01 00 00       	jmpq   8015ac <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80141f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801423:	be 03 00 00 00       	mov    $0x3,%esi
  801428:	48 89 c7             	mov    %rax,%rdi
  80142b:	48 b8 ae 0f 80 00 00 	movabs $0x800fae,%rax
  801432:	00 00 00 
  801435:	ff d0                	callq  *%rax
  801437:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80143b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143f:	48 85 c0             	test   %rax,%rax
  801442:	79 1d                	jns    801461 <vprintfmt+0x3ac>
				putch('-', putdat);
  801444:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801448:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80144c:	48 89 d6             	mov    %rdx,%rsi
  80144f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801454:	ff d0                	callq  *%rax
				num = -(long long) num;
  801456:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80145a:	48 f7 d8             	neg    %rax
  80145d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801461:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801468:	e9 d2 00 00 00       	jmpq   80153f <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80146d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801471:	be 03 00 00 00       	mov    $0x3,%esi
  801476:	48 89 c7             	mov    %rax,%rdi
  801479:	48 b8 a7 0e 80 00 00 	movabs $0x800ea7,%rax
  801480:	00 00 00 
  801483:	ff d0                	callq  *%rax
  801485:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801489:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801490:	e9 aa 00 00 00       	jmpq   80153f <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  801495:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801499:	be 03 00 00 00       	mov    $0x3,%esi
  80149e:	48 89 c7             	mov    %rax,%rdi
  8014a1:	48 b8 a7 0e 80 00 00 	movabs $0x800ea7,%rax
  8014a8:	00 00 00 
  8014ab:	ff d0                	callq  *%rax
  8014ad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8014b1:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8014b8:	e9 82 00 00 00       	jmpq   80153f <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  8014bd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014c1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014c5:	48 89 d6             	mov    %rdx,%rsi
  8014c8:	bf 30 00 00 00       	mov    $0x30,%edi
  8014cd:	ff d0                	callq  *%rax
			putch('x', putdat);
  8014cf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014d3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014d7:	48 89 d6             	mov    %rdx,%rsi
  8014da:	bf 78 00 00 00       	mov    $0x78,%edi
  8014df:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8014e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014e4:	83 f8 30             	cmp    $0x30,%eax
  8014e7:	73 17                	jae    801500 <vprintfmt+0x44b>
  8014e9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8014ed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014f0:	89 d2                	mov    %edx,%edx
  8014f2:	48 01 d0             	add    %rdx,%rax
  8014f5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014f8:	83 c2 08             	add    $0x8,%edx
  8014fb:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8014fe:	eb 0c                	jmp    80150c <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  801500:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801504:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801508:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80150c:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80150f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801513:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80151a:	eb 23                	jmp    80153f <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80151c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801520:	be 03 00 00 00       	mov    $0x3,%esi
  801525:	48 89 c7             	mov    %rax,%rdi
  801528:	48 b8 a7 0e 80 00 00 	movabs $0x800ea7,%rax
  80152f:	00 00 00 
  801532:	ff d0                	callq  *%rax
  801534:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801538:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80153f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801544:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801547:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80154a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80154e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801552:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801556:	45 89 c1             	mov    %r8d,%r9d
  801559:	41 89 f8             	mov    %edi,%r8d
  80155c:	48 89 c7             	mov    %rax,%rdi
  80155f:	48 b8 ef 0d 80 00 00 	movabs $0x800def,%rax
  801566:	00 00 00 
  801569:	ff d0                	callq  *%rax
			break;
  80156b:	eb 3f                	jmp    8015ac <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80156d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801571:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801575:	48 89 d6             	mov    %rdx,%rsi
  801578:	89 df                	mov    %ebx,%edi
  80157a:	ff d0                	callq  *%rax
			break;
  80157c:	eb 2e                	jmp    8015ac <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80157e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801582:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801586:	48 89 d6             	mov    %rdx,%rsi
  801589:	bf 25 00 00 00       	mov    $0x25,%edi
  80158e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801590:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801595:	eb 05                	jmp    80159c <vprintfmt+0x4e7>
  801597:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80159c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8015a0:	48 83 e8 01          	sub    $0x1,%rax
  8015a4:	0f b6 00             	movzbl (%rax),%eax
  8015a7:	3c 25                	cmp    $0x25,%al
  8015a9:	75 ec                	jne    801597 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  8015ab:	90                   	nop
		}
	}
  8015ac:	e9 3d fb ff ff       	jmpq   8010ee <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8015b1:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8015b2:	48 83 c4 60          	add    $0x60,%rsp
  8015b6:	5b                   	pop    %rbx
  8015b7:	41 5c                	pop    %r12
  8015b9:	5d                   	pop    %rbp
  8015ba:	c3                   	retq   

00000000008015bb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8015bb:	55                   	push   %rbp
  8015bc:	48 89 e5             	mov    %rsp,%rbp
  8015bf:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8015c6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8015cd:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8015d4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  8015db:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8015e2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8015e9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8015f0:	84 c0                	test   %al,%al
  8015f2:	74 20                	je     801614 <printfmt+0x59>
  8015f4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8015f8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8015fc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801600:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801604:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801608:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80160c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801610:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801614:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80161b:	00 00 00 
  80161e:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801625:	00 00 00 
  801628:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80162c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801633:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80163a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801641:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801648:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80164f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801656:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80165d:	48 89 c7             	mov    %rax,%rdi
  801660:	48 b8 b5 10 80 00 00 	movabs $0x8010b5,%rax
  801667:	00 00 00 
  80166a:	ff d0                	callq  *%rax
	va_end(ap);
}
  80166c:	90                   	nop
  80166d:	c9                   	leaveq 
  80166e:	c3                   	retq   

000000000080166f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80166f:	55                   	push   %rbp
  801670:	48 89 e5             	mov    %rsp,%rbp
  801673:	48 83 ec 10          	sub    $0x10,%rsp
  801677:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80167a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80167e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801682:	8b 40 10             	mov    0x10(%rax),%eax
  801685:	8d 50 01             	lea    0x1(%rax),%edx
  801688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80168c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80168f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801693:	48 8b 10             	mov    (%rax),%rdx
  801696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80169e:	48 39 c2             	cmp    %rax,%rdx
  8016a1:	73 17                	jae    8016ba <sprintputch+0x4b>
		*b->buf++ = ch;
  8016a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a7:	48 8b 00             	mov    (%rax),%rax
  8016aa:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8016ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016b2:	48 89 0a             	mov    %rcx,(%rdx)
  8016b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8016b8:	88 10                	mov    %dl,(%rax)
}
  8016ba:	90                   	nop
  8016bb:	c9                   	leaveq 
  8016bc:	c3                   	retq   

00000000008016bd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016bd:	55                   	push   %rbp
  8016be:	48 89 e5             	mov    %rsp,%rbp
  8016c1:	48 83 ec 50          	sub    $0x50,%rsp
  8016c5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8016c9:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8016cc:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8016d0:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8016d4:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8016d8:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8016dc:	48 8b 0a             	mov    (%rdx),%rcx
  8016df:	48 89 08             	mov    %rcx,(%rax)
  8016e2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8016e6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8016ea:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8016ee:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8016f2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8016f6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8016fa:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8016fd:	48 98                	cltq   
  8016ff:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801703:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801707:	48 01 d0             	add    %rdx,%rax
  80170a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80170e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801715:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80171a:	74 06                	je     801722 <vsnprintf+0x65>
  80171c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801720:	7f 07                	jg     801729 <vsnprintf+0x6c>
		return -E_INVAL;
  801722:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801727:	eb 2f                	jmp    801758 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801729:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80172d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801731:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801735:	48 89 c6             	mov    %rax,%rsi
  801738:	48 bf 6f 16 80 00 00 	movabs $0x80166f,%rdi
  80173f:	00 00 00 
  801742:	48 b8 b5 10 80 00 00 	movabs $0x8010b5,%rax
  801749:	00 00 00 
  80174c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80174e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801752:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801755:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801758:	c9                   	leaveq 
  801759:	c3                   	retq   

000000000080175a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80175a:	55                   	push   %rbp
  80175b:	48 89 e5             	mov    %rsp,%rbp
  80175e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801765:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80176c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801772:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  801779:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801780:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801787:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80178e:	84 c0                	test   %al,%al
  801790:	74 20                	je     8017b2 <snprintf+0x58>
  801792:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801796:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80179a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80179e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8017a2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8017a6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8017aa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8017ae:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8017b2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8017b9:	00 00 00 
  8017bc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8017c3:	00 00 00 
  8017c6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8017ca:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8017d1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8017d8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8017df:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8017e6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8017ed:	48 8b 0a             	mov    (%rdx),%rcx
  8017f0:	48 89 08             	mov    %rcx,(%rax)
  8017f3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8017f7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8017fb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8017ff:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801803:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80180a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801811:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801817:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80181e:	48 89 c7             	mov    %rax,%rdi
  801821:	48 b8 bd 16 80 00 00 	movabs $0x8016bd,%rax
  801828:	00 00 00 
  80182b:	ff d0                	callq  *%rax
  80182d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801833:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801839:	c9                   	leaveq 
  80183a:	c3                   	retq   

000000000080183b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80183b:	55                   	push   %rbp
  80183c:	48 89 e5             	mov    %rsp,%rbp
  80183f:	48 83 ec 18          	sub    $0x18,%rsp
  801843:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801847:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80184e:	eb 09                	jmp    801859 <strlen+0x1e>
		n++;
  801850:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801854:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801859:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80185d:	0f b6 00             	movzbl (%rax),%eax
  801860:	84 c0                	test   %al,%al
  801862:	75 ec                	jne    801850 <strlen+0x15>
		n++;
	return n;
  801864:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801867:	c9                   	leaveq 
  801868:	c3                   	retq   

0000000000801869 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801869:	55                   	push   %rbp
  80186a:	48 89 e5             	mov    %rsp,%rbp
  80186d:	48 83 ec 20          	sub    $0x20,%rsp
  801871:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801875:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801879:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801880:	eb 0e                	jmp    801890 <strnlen+0x27>
		n++;
  801882:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801886:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80188b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801890:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801895:	74 0b                	je     8018a2 <strnlen+0x39>
  801897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80189b:	0f b6 00             	movzbl (%rax),%eax
  80189e:	84 c0                	test   %al,%al
  8018a0:	75 e0                	jne    801882 <strnlen+0x19>
		n++;
	return n;
  8018a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018a5:	c9                   	leaveq 
  8018a6:	c3                   	retq   

00000000008018a7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018a7:	55                   	push   %rbp
  8018a8:	48 89 e5             	mov    %rsp,%rbp
  8018ab:	48 83 ec 20          	sub    $0x20,%rsp
  8018af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8018b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8018bf:	90                   	nop
  8018c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018c4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018c8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018cc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8018d0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8018d4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8018d8:	0f b6 12             	movzbl (%rdx),%edx
  8018db:	88 10                	mov    %dl,(%rax)
  8018dd:	0f b6 00             	movzbl (%rax),%eax
  8018e0:	84 c0                	test   %al,%al
  8018e2:	75 dc                	jne    8018c0 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8018e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8018e8:	c9                   	leaveq 
  8018e9:	c3                   	retq   

00000000008018ea <strcat>:

char *
strcat(char *dst, const char *src)
{
  8018ea:	55                   	push   %rbp
  8018eb:	48 89 e5             	mov    %rsp,%rbp
  8018ee:	48 83 ec 20          	sub    $0x20,%rsp
  8018f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8018fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018fe:	48 89 c7             	mov    %rax,%rdi
  801901:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  801908:	00 00 00 
  80190b:	ff d0                	callq  *%rax
  80190d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801910:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801913:	48 63 d0             	movslq %eax,%rdx
  801916:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80191a:	48 01 c2             	add    %rax,%rdx
  80191d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801921:	48 89 c6             	mov    %rax,%rsi
  801924:	48 89 d7             	mov    %rdx,%rdi
  801927:	48 b8 a7 18 80 00 00 	movabs $0x8018a7,%rax
  80192e:	00 00 00 
  801931:	ff d0                	callq  *%rax
	return dst;
  801933:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801937:	c9                   	leaveq 
  801938:	c3                   	retq   

0000000000801939 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801939:	55                   	push   %rbp
  80193a:	48 89 e5             	mov    %rsp,%rbp
  80193d:	48 83 ec 28          	sub    $0x28,%rsp
  801941:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801945:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801949:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80194d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801951:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801955:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80195c:	00 
  80195d:	eb 2a                	jmp    801989 <strncpy+0x50>
		*dst++ = *src;
  80195f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801963:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801967:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80196b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80196f:	0f b6 12             	movzbl (%rdx),%edx
  801972:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801974:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801978:	0f b6 00             	movzbl (%rax),%eax
  80197b:	84 c0                	test   %al,%al
  80197d:	74 05                	je     801984 <strncpy+0x4b>
			src++;
  80197f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801984:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801989:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80198d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801991:	72 cc                	jb     80195f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801993:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801997:	c9                   	leaveq 
  801998:	c3                   	retq   

0000000000801999 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801999:	55                   	push   %rbp
  80199a:	48 89 e5             	mov    %rsp,%rbp
  80199d:	48 83 ec 28          	sub    $0x28,%rsp
  8019a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8019ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8019b5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8019ba:	74 3d                	je     8019f9 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8019bc:	eb 1d                	jmp    8019db <strlcpy+0x42>
			*dst++ = *src++;
  8019be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019c2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019c6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019ca:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8019ce:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8019d2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8019d6:	0f b6 12             	movzbl (%rdx),%edx
  8019d9:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019db:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8019e0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8019e5:	74 0b                	je     8019f2 <strlcpy+0x59>
  8019e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019eb:	0f b6 00             	movzbl (%rax),%eax
  8019ee:	84 c0                	test   %al,%al
  8019f0:	75 cc                	jne    8019be <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8019f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019f6:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8019f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a01:	48 29 c2             	sub    %rax,%rdx
  801a04:	48 89 d0             	mov    %rdx,%rax
}
  801a07:	c9                   	leaveq 
  801a08:	c3                   	retq   

0000000000801a09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a09:	55                   	push   %rbp
  801a0a:	48 89 e5             	mov    %rsp,%rbp
  801a0d:	48 83 ec 10          	sub    $0x10,%rsp
  801a11:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a15:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801a19:	eb 0a                	jmp    801a25 <strcmp+0x1c>
		p++, q++;
  801a1b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a20:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a29:	0f b6 00             	movzbl (%rax),%eax
  801a2c:	84 c0                	test   %al,%al
  801a2e:	74 12                	je     801a42 <strcmp+0x39>
  801a30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a34:	0f b6 10             	movzbl (%rax),%edx
  801a37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a3b:	0f b6 00             	movzbl (%rax),%eax
  801a3e:	38 c2                	cmp    %al,%dl
  801a40:	74 d9                	je     801a1b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a46:	0f b6 00             	movzbl (%rax),%eax
  801a49:	0f b6 d0             	movzbl %al,%edx
  801a4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a50:	0f b6 00             	movzbl (%rax),%eax
  801a53:	0f b6 c0             	movzbl %al,%eax
  801a56:	29 c2                	sub    %eax,%edx
  801a58:	89 d0                	mov    %edx,%eax
}
  801a5a:	c9                   	leaveq 
  801a5b:	c3                   	retq   

0000000000801a5c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a5c:	55                   	push   %rbp
  801a5d:	48 89 e5             	mov    %rsp,%rbp
  801a60:	48 83 ec 18          	sub    $0x18,%rsp
  801a64:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a68:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a6c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801a70:	eb 0f                	jmp    801a81 <strncmp+0x25>
		n--, p++, q++;
  801a72:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801a77:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a7c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801a81:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a86:	74 1d                	je     801aa5 <strncmp+0x49>
  801a88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a8c:	0f b6 00             	movzbl (%rax),%eax
  801a8f:	84 c0                	test   %al,%al
  801a91:	74 12                	je     801aa5 <strncmp+0x49>
  801a93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a97:	0f b6 10             	movzbl (%rax),%edx
  801a9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a9e:	0f b6 00             	movzbl (%rax),%eax
  801aa1:	38 c2                	cmp    %al,%dl
  801aa3:	74 cd                	je     801a72 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801aa5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801aaa:	75 07                	jne    801ab3 <strncmp+0x57>
		return 0;
  801aac:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab1:	eb 18                	jmp    801acb <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801ab3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab7:	0f b6 00             	movzbl (%rax),%eax
  801aba:	0f b6 d0             	movzbl %al,%edx
  801abd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac1:	0f b6 00             	movzbl (%rax),%eax
  801ac4:	0f b6 c0             	movzbl %al,%eax
  801ac7:	29 c2                	sub    %eax,%edx
  801ac9:	89 d0                	mov    %edx,%eax
}
  801acb:	c9                   	leaveq 
  801acc:	c3                   	retq   

0000000000801acd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801acd:	55                   	push   %rbp
  801ace:	48 89 e5             	mov    %rsp,%rbp
  801ad1:	48 83 ec 10          	sub    $0x10,%rsp
  801ad5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ad9:	89 f0                	mov    %esi,%eax
  801adb:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801ade:	eb 17                	jmp    801af7 <strchr+0x2a>
		if (*s == c)
  801ae0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae4:	0f b6 00             	movzbl (%rax),%eax
  801ae7:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801aea:	75 06                	jne    801af2 <strchr+0x25>
			return (char *) s;
  801aec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af0:	eb 15                	jmp    801b07 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801af2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801af7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801afb:	0f b6 00             	movzbl (%rax),%eax
  801afe:	84 c0                	test   %al,%al
  801b00:	75 de                	jne    801ae0 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801b02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b07:	c9                   	leaveq 
  801b08:	c3                   	retq   

0000000000801b09 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b09:	55                   	push   %rbp
  801b0a:	48 89 e5             	mov    %rsp,%rbp
  801b0d:	48 83 ec 10          	sub    $0x10,%rsp
  801b11:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b15:	89 f0                	mov    %esi,%eax
  801b17:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b1a:	eb 11                	jmp    801b2d <strfind+0x24>
		if (*s == c)
  801b1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b20:	0f b6 00             	movzbl (%rax),%eax
  801b23:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b26:	74 12                	je     801b3a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b28:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b31:	0f b6 00             	movzbl (%rax),%eax
  801b34:	84 c0                	test   %al,%al
  801b36:	75 e4                	jne    801b1c <strfind+0x13>
  801b38:	eb 01                	jmp    801b3b <strfind+0x32>
		if (*s == c)
			break;
  801b3a:	90                   	nop
	return (char *) s;
  801b3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b3f:	c9                   	leaveq 
  801b40:	c3                   	retq   

0000000000801b41 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b41:	55                   	push   %rbp
  801b42:	48 89 e5             	mov    %rsp,%rbp
  801b45:	48 83 ec 18          	sub    $0x18,%rsp
  801b49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b4d:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801b50:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801b54:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b59:	75 06                	jne    801b61 <memset+0x20>
		return v;
  801b5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5f:	eb 69                	jmp    801bca <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801b61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b65:	83 e0 03             	and    $0x3,%eax
  801b68:	48 85 c0             	test   %rax,%rax
  801b6b:	75 48                	jne    801bb5 <memset+0x74>
  801b6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b71:	83 e0 03             	and    $0x3,%eax
  801b74:	48 85 c0             	test   %rax,%rax
  801b77:	75 3c                	jne    801bb5 <memset+0x74>
		c &= 0xFF;
  801b79:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801b80:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b83:	c1 e0 18             	shl    $0x18,%eax
  801b86:	89 c2                	mov    %eax,%edx
  801b88:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b8b:	c1 e0 10             	shl    $0x10,%eax
  801b8e:	09 c2                	or     %eax,%edx
  801b90:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b93:	c1 e0 08             	shl    $0x8,%eax
  801b96:	09 d0                	or     %edx,%eax
  801b98:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801b9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b9f:	48 c1 e8 02          	shr    $0x2,%rax
  801ba3:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801ba6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801baa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bad:	48 89 d7             	mov    %rdx,%rdi
  801bb0:	fc                   	cld    
  801bb1:	f3 ab                	rep stos %eax,%es:(%rdi)
  801bb3:	eb 11                	jmp    801bc6 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801bb5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bb9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bbc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bc0:	48 89 d7             	mov    %rdx,%rdi
  801bc3:	fc                   	cld    
  801bc4:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801bc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801bca:	c9                   	leaveq 
  801bcb:	c3                   	retq   

0000000000801bcc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801bcc:	55                   	push   %rbp
  801bcd:	48 89 e5             	mov    %rsp,%rbp
  801bd0:	48 83 ec 28          	sub    $0x28,%rsp
  801bd4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bd8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bdc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801be0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801be4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801be8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801bf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bf4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801bf8:	0f 83 88 00 00 00    	jae    801c86 <memmove+0xba>
  801bfe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c06:	48 01 d0             	add    %rdx,%rax
  801c09:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c0d:	76 77                	jbe    801c86 <memmove+0xba>
		s += n;
  801c0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c13:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801c17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c1b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801c1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c23:	83 e0 03             	and    $0x3,%eax
  801c26:	48 85 c0             	test   %rax,%rax
  801c29:	75 3b                	jne    801c66 <memmove+0x9a>
  801c2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c2f:	83 e0 03             	and    $0x3,%eax
  801c32:	48 85 c0             	test   %rax,%rax
  801c35:	75 2f                	jne    801c66 <memmove+0x9a>
  801c37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c3b:	83 e0 03             	and    $0x3,%eax
  801c3e:	48 85 c0             	test   %rax,%rax
  801c41:	75 23                	jne    801c66 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801c43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c47:	48 83 e8 04          	sub    $0x4,%rax
  801c4b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c4f:	48 83 ea 04          	sub    $0x4,%rdx
  801c53:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801c57:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801c5b:	48 89 c7             	mov    %rax,%rdi
  801c5e:	48 89 d6             	mov    %rdx,%rsi
  801c61:	fd                   	std    
  801c62:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801c64:	eb 1d                	jmp    801c83 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801c66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c6a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801c6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c72:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801c76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c7a:	48 89 d7             	mov    %rdx,%rdi
  801c7d:	48 89 c1             	mov    %rax,%rcx
  801c80:	fd                   	std    
  801c81:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801c83:	fc                   	cld    
  801c84:	eb 57                	jmp    801cdd <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801c86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c8a:	83 e0 03             	and    $0x3,%eax
  801c8d:	48 85 c0             	test   %rax,%rax
  801c90:	75 36                	jne    801cc8 <memmove+0xfc>
  801c92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c96:	83 e0 03             	and    $0x3,%eax
  801c99:	48 85 c0             	test   %rax,%rax
  801c9c:	75 2a                	jne    801cc8 <memmove+0xfc>
  801c9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca2:	83 e0 03             	and    $0x3,%eax
  801ca5:	48 85 c0             	test   %rax,%rax
  801ca8:	75 1e                	jne    801cc8 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801caa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cae:	48 c1 e8 02          	shr    $0x2,%rax
  801cb2:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801cb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cb9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cbd:	48 89 c7             	mov    %rax,%rdi
  801cc0:	48 89 d6             	mov    %rdx,%rsi
  801cc3:	fc                   	cld    
  801cc4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801cc6:	eb 15                	jmp    801cdd <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801cc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ccc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cd0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801cd4:	48 89 c7             	mov    %rax,%rdi
  801cd7:	48 89 d6             	mov    %rdx,%rsi
  801cda:	fc                   	cld    
  801cdb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801cdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ce1:	c9                   	leaveq 
  801ce2:	c3                   	retq   

0000000000801ce3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801ce3:	55                   	push   %rbp
  801ce4:	48 89 e5             	mov    %rsp,%rbp
  801ce7:	48 83 ec 18          	sub    $0x18,%rsp
  801ceb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cf3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801cf7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801cfb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801cff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d03:	48 89 ce             	mov    %rcx,%rsi
  801d06:	48 89 c7             	mov    %rax,%rdi
  801d09:	48 b8 cc 1b 80 00 00 	movabs $0x801bcc,%rax
  801d10:	00 00 00 
  801d13:	ff d0                	callq  *%rax
}
  801d15:	c9                   	leaveq 
  801d16:	c3                   	retq   

0000000000801d17 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d17:	55                   	push   %rbp
  801d18:	48 89 e5             	mov    %rsp,%rbp
  801d1b:	48 83 ec 28          	sub    $0x28,%rsp
  801d1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d23:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d27:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801d2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d2f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801d33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d37:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801d3b:	eb 36                	jmp    801d73 <memcmp+0x5c>
		if (*s1 != *s2)
  801d3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d41:	0f b6 10             	movzbl (%rax),%edx
  801d44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d48:	0f b6 00             	movzbl (%rax),%eax
  801d4b:	38 c2                	cmp    %al,%dl
  801d4d:	74 1a                	je     801d69 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801d4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d53:	0f b6 00             	movzbl (%rax),%eax
  801d56:	0f b6 d0             	movzbl %al,%edx
  801d59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d5d:	0f b6 00             	movzbl (%rax),%eax
  801d60:	0f b6 c0             	movzbl %al,%eax
  801d63:	29 c2                	sub    %eax,%edx
  801d65:	89 d0                	mov    %edx,%eax
  801d67:	eb 20                	jmp    801d89 <memcmp+0x72>
		s1++, s2++;
  801d69:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d6e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801d73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d77:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801d7b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801d7f:	48 85 c0             	test   %rax,%rax
  801d82:	75 b9                	jne    801d3d <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801d84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d89:	c9                   	leaveq 
  801d8a:	c3                   	retq   

0000000000801d8b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801d8b:	55                   	push   %rbp
  801d8c:	48 89 e5             	mov    %rsp,%rbp
  801d8f:	48 83 ec 28          	sub    $0x28,%rsp
  801d93:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d97:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801d9a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801d9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801da2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801da6:	48 01 d0             	add    %rdx,%rax
  801da9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801dad:	eb 19                	jmp    801dc8 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801daf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db3:	0f b6 00             	movzbl (%rax),%eax
  801db6:	0f b6 d0             	movzbl %al,%edx
  801db9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dbc:	0f b6 c0             	movzbl %al,%eax
  801dbf:	39 c2                	cmp    %eax,%edx
  801dc1:	74 11                	je     801dd4 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801dc3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801dc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dcc:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801dd0:	72 dd                	jb     801daf <memfind+0x24>
  801dd2:	eb 01                	jmp    801dd5 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801dd4:	90                   	nop
	return (void *) s;
  801dd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801dd9:	c9                   	leaveq 
  801dda:	c3                   	retq   

0000000000801ddb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ddb:	55                   	push   %rbp
  801ddc:	48 89 e5             	mov    %rsp,%rbp
  801ddf:	48 83 ec 38          	sub    $0x38,%rsp
  801de3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801de7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801deb:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801dee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801df5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801dfc:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801dfd:	eb 05                	jmp    801e04 <strtol+0x29>
		s++;
  801dff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e08:	0f b6 00             	movzbl (%rax),%eax
  801e0b:	3c 20                	cmp    $0x20,%al
  801e0d:	74 f0                	je     801dff <strtol+0x24>
  801e0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e13:	0f b6 00             	movzbl (%rax),%eax
  801e16:	3c 09                	cmp    $0x9,%al
  801e18:	74 e5                	je     801dff <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e1e:	0f b6 00             	movzbl (%rax),%eax
  801e21:	3c 2b                	cmp    $0x2b,%al
  801e23:	75 07                	jne    801e2c <strtol+0x51>
		s++;
  801e25:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e2a:	eb 17                	jmp    801e43 <strtol+0x68>
	else if (*s == '-')
  801e2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e30:	0f b6 00             	movzbl (%rax),%eax
  801e33:	3c 2d                	cmp    $0x2d,%al
  801e35:	75 0c                	jne    801e43 <strtol+0x68>
		s++, neg = 1;
  801e37:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e3c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e43:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e47:	74 06                	je     801e4f <strtol+0x74>
  801e49:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801e4d:	75 28                	jne    801e77 <strtol+0x9c>
  801e4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e53:	0f b6 00             	movzbl (%rax),%eax
  801e56:	3c 30                	cmp    $0x30,%al
  801e58:	75 1d                	jne    801e77 <strtol+0x9c>
  801e5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5e:	48 83 c0 01          	add    $0x1,%rax
  801e62:	0f b6 00             	movzbl (%rax),%eax
  801e65:	3c 78                	cmp    $0x78,%al
  801e67:	75 0e                	jne    801e77 <strtol+0x9c>
		s += 2, base = 16;
  801e69:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801e6e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801e75:	eb 2c                	jmp    801ea3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801e77:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e7b:	75 19                	jne    801e96 <strtol+0xbb>
  801e7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e81:	0f b6 00             	movzbl (%rax),%eax
  801e84:	3c 30                	cmp    $0x30,%al
  801e86:	75 0e                	jne    801e96 <strtol+0xbb>
		s++, base = 8;
  801e88:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e8d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801e94:	eb 0d                	jmp    801ea3 <strtol+0xc8>
	else if (base == 0)
  801e96:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e9a:	75 07                	jne    801ea3 <strtol+0xc8>
		base = 10;
  801e9c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ea3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea7:	0f b6 00             	movzbl (%rax),%eax
  801eaa:	3c 2f                	cmp    $0x2f,%al
  801eac:	7e 1d                	jle    801ecb <strtol+0xf0>
  801eae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb2:	0f b6 00             	movzbl (%rax),%eax
  801eb5:	3c 39                	cmp    $0x39,%al
  801eb7:	7f 12                	jg     801ecb <strtol+0xf0>
			dig = *s - '0';
  801eb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ebd:	0f b6 00             	movzbl (%rax),%eax
  801ec0:	0f be c0             	movsbl %al,%eax
  801ec3:	83 e8 30             	sub    $0x30,%eax
  801ec6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ec9:	eb 4e                	jmp    801f19 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801ecb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ecf:	0f b6 00             	movzbl (%rax),%eax
  801ed2:	3c 60                	cmp    $0x60,%al
  801ed4:	7e 1d                	jle    801ef3 <strtol+0x118>
  801ed6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eda:	0f b6 00             	movzbl (%rax),%eax
  801edd:	3c 7a                	cmp    $0x7a,%al
  801edf:	7f 12                	jg     801ef3 <strtol+0x118>
			dig = *s - 'a' + 10;
  801ee1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee5:	0f b6 00             	movzbl (%rax),%eax
  801ee8:	0f be c0             	movsbl %al,%eax
  801eeb:	83 e8 57             	sub    $0x57,%eax
  801eee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ef1:	eb 26                	jmp    801f19 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801ef3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef7:	0f b6 00             	movzbl (%rax),%eax
  801efa:	3c 40                	cmp    $0x40,%al
  801efc:	7e 47                	jle    801f45 <strtol+0x16a>
  801efe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f02:	0f b6 00             	movzbl (%rax),%eax
  801f05:	3c 5a                	cmp    $0x5a,%al
  801f07:	7f 3c                	jg     801f45 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801f09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f0d:	0f b6 00             	movzbl (%rax),%eax
  801f10:	0f be c0             	movsbl %al,%eax
  801f13:	83 e8 37             	sub    $0x37,%eax
  801f16:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801f19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f1c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801f1f:	7d 23                	jge    801f44 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801f21:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f26:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f29:	48 98                	cltq   
  801f2b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801f30:	48 89 c2             	mov    %rax,%rdx
  801f33:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f36:	48 98                	cltq   
  801f38:	48 01 d0             	add    %rdx,%rax
  801f3b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801f3f:	e9 5f ff ff ff       	jmpq   801ea3 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801f44:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801f45:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801f4a:	74 0b                	je     801f57 <strtol+0x17c>
		*endptr = (char *) s;
  801f4c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f50:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f54:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801f57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f5b:	74 09                	je     801f66 <strtol+0x18b>
  801f5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f61:	48 f7 d8             	neg    %rax
  801f64:	eb 04                	jmp    801f6a <strtol+0x18f>
  801f66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801f6a:	c9                   	leaveq 
  801f6b:	c3                   	retq   

0000000000801f6c <strstr>:

char * strstr(const char *in, const char *str)
{
  801f6c:	55                   	push   %rbp
  801f6d:	48 89 e5             	mov    %rsp,%rbp
  801f70:	48 83 ec 30          	sub    $0x30,%rsp
  801f74:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f78:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801f7c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f80:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801f84:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801f88:	0f b6 00             	movzbl (%rax),%eax
  801f8b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801f8e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801f92:	75 06                	jne    801f9a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801f94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f98:	eb 6b                	jmp    802005 <strstr+0x99>

	len = strlen(str);
  801f9a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f9e:	48 89 c7             	mov    %rax,%rdi
  801fa1:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  801fa8:	00 00 00 
  801fab:	ff d0                	callq  *%rax
  801fad:	48 98                	cltq   
  801faf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801fb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fbb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801fbf:	0f b6 00             	movzbl (%rax),%eax
  801fc2:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801fc5:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801fc9:	75 07                	jne    801fd2 <strstr+0x66>
				return (char *) 0;
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd0:	eb 33                	jmp    802005 <strstr+0x99>
		} while (sc != c);
  801fd2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801fd6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801fd9:	75 d8                	jne    801fb3 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801fdb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fdf:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801fe3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe7:	48 89 ce             	mov    %rcx,%rsi
  801fea:	48 89 c7             	mov    %rax,%rdi
  801fed:	48 b8 5c 1a 80 00 00 	movabs $0x801a5c,%rax
  801ff4:	00 00 00 
  801ff7:	ff d0                	callq  *%rax
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	75 b6                	jne    801fb3 <strstr+0x47>

	return (char *) (in - 1);
  801ffd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802001:	48 83 e8 01          	sub    $0x1,%rax
}
  802005:	c9                   	leaveq 
  802006:	c3                   	retq   

0000000000802007 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802007:	55                   	push   %rbp
  802008:	48 89 e5             	mov    %rsp,%rbp
  80200b:	53                   	push   %rbx
  80200c:	48 83 ec 48          	sub    $0x48,%rsp
  802010:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802013:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802016:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80201a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80201e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802022:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802026:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802029:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80202d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802031:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802035:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802039:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80203d:	4c 89 c3             	mov    %r8,%rbx
  802040:	cd 30                	int    $0x30
  802042:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802046:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80204a:	74 3e                	je     80208a <syscall+0x83>
  80204c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802051:	7e 37                	jle    80208a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802053:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802057:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80205a:	49 89 d0             	mov    %rdx,%r8
  80205d:	89 c1                	mov    %eax,%ecx
  80205f:	48 ba 28 2b 80 00 00 	movabs $0x802b28,%rdx
  802066:	00 00 00 
  802069:	be 23 00 00 00       	mov    $0x23,%esi
  80206e:	48 bf 45 2b 80 00 00 	movabs $0x802b45,%rdi
  802075:	00 00 00 
  802078:	b8 00 00 00 00       	mov    $0x0,%eax
  80207d:	49 b9 dd 0a 80 00 00 	movabs $0x800add,%r9
  802084:	00 00 00 
  802087:	41 ff d1             	callq  *%r9

	return ret;
  80208a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80208e:	48 83 c4 48          	add    $0x48,%rsp
  802092:	5b                   	pop    %rbx
  802093:	5d                   	pop    %rbp
  802094:	c3                   	retq   

0000000000802095 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802095:	55                   	push   %rbp
  802096:	48 89 e5             	mov    %rsp,%rbp
  802099:	48 83 ec 10          	sub    $0x10,%rsp
  80209d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8020a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020ad:	48 83 ec 08          	sub    $0x8,%rsp
  8020b1:	6a 00                	pushq  $0x0
  8020b3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020b9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020bf:	48 89 d1             	mov    %rdx,%rcx
  8020c2:	48 89 c2             	mov    %rax,%rdx
  8020c5:	be 00 00 00 00       	mov    $0x0,%esi
  8020ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8020cf:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  8020d6:	00 00 00 
  8020d9:	ff d0                	callq  *%rax
  8020db:	48 83 c4 10          	add    $0x10,%rsp
}
  8020df:	90                   	nop
  8020e0:	c9                   	leaveq 
  8020e1:	c3                   	retq   

00000000008020e2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8020e2:	55                   	push   %rbp
  8020e3:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8020e6:	48 83 ec 08          	sub    $0x8,%rsp
  8020ea:	6a 00                	pushq  $0x0
  8020ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802102:	be 00 00 00 00       	mov    $0x0,%esi
  802107:	bf 01 00 00 00       	mov    $0x1,%edi
  80210c:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  802113:	00 00 00 
  802116:	ff d0                	callq  *%rax
  802118:	48 83 c4 10          	add    $0x10,%rsp
}
  80211c:	c9                   	leaveq 
  80211d:	c3                   	retq   

000000000080211e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80211e:	55                   	push   %rbp
  80211f:	48 89 e5             	mov    %rsp,%rbp
  802122:	48 83 ec 10          	sub    $0x10,%rsp
  802126:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802129:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80212c:	48 98                	cltq   
  80212e:	48 83 ec 08          	sub    $0x8,%rsp
  802132:	6a 00                	pushq  $0x0
  802134:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80213a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802140:	b9 00 00 00 00       	mov    $0x0,%ecx
  802145:	48 89 c2             	mov    %rax,%rdx
  802148:	be 01 00 00 00       	mov    $0x1,%esi
  80214d:	bf 03 00 00 00       	mov    $0x3,%edi
  802152:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  802159:	00 00 00 
  80215c:	ff d0                	callq  *%rax
  80215e:	48 83 c4 10          	add    $0x10,%rsp
}
  802162:	c9                   	leaveq 
  802163:	c3                   	retq   

0000000000802164 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802164:	55                   	push   %rbp
  802165:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802168:	48 83 ec 08          	sub    $0x8,%rsp
  80216c:	6a 00                	pushq  $0x0
  80216e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802174:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80217a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80217f:	ba 00 00 00 00       	mov    $0x0,%edx
  802184:	be 00 00 00 00       	mov    $0x0,%esi
  802189:	bf 02 00 00 00       	mov    $0x2,%edi
  80218e:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  802195:	00 00 00 
  802198:	ff d0                	callq  *%rax
  80219a:	48 83 c4 10          	add    $0x10,%rsp
}
  80219e:	c9                   	leaveq 
  80219f:	c3                   	retq   

00000000008021a0 <sys_yield>:

void
sys_yield(void)
{
  8021a0:	55                   	push   %rbp
  8021a1:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8021a4:	48 83 ec 08          	sub    $0x8,%rsp
  8021a8:	6a 00                	pushq  $0x0
  8021aa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021b0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c0:	be 00 00 00 00       	mov    $0x0,%esi
  8021c5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8021ca:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  8021d1:	00 00 00 
  8021d4:	ff d0                	callq  *%rax
  8021d6:	48 83 c4 10          	add    $0x10,%rsp
}
  8021da:	90                   	nop
  8021db:	c9                   	leaveq 
  8021dc:	c3                   	retq   

00000000008021dd <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8021dd:	55                   	push   %rbp
  8021de:	48 89 e5             	mov    %rsp,%rbp
  8021e1:	48 83 ec 10          	sub    $0x10,%rsp
  8021e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021ec:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8021ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021f2:	48 63 c8             	movslq %eax,%rcx
  8021f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021fc:	48 98                	cltq   
  8021fe:	48 83 ec 08          	sub    $0x8,%rsp
  802202:	6a 00                	pushq  $0x0
  802204:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80220a:	49 89 c8             	mov    %rcx,%r8
  80220d:	48 89 d1             	mov    %rdx,%rcx
  802210:	48 89 c2             	mov    %rax,%rdx
  802213:	be 01 00 00 00       	mov    $0x1,%esi
  802218:	bf 04 00 00 00       	mov    $0x4,%edi
  80221d:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  802224:	00 00 00 
  802227:	ff d0                	callq  *%rax
  802229:	48 83 c4 10          	add    $0x10,%rsp
}
  80222d:	c9                   	leaveq 
  80222e:	c3                   	retq   

000000000080222f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80222f:	55                   	push   %rbp
  802230:	48 89 e5             	mov    %rsp,%rbp
  802233:	48 83 ec 20          	sub    $0x20,%rsp
  802237:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80223a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80223e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802241:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802245:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802249:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80224c:	48 63 c8             	movslq %eax,%rcx
  80224f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802253:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802256:	48 63 f0             	movslq %eax,%rsi
  802259:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80225d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802260:	48 98                	cltq   
  802262:	48 83 ec 08          	sub    $0x8,%rsp
  802266:	51                   	push   %rcx
  802267:	49 89 f9             	mov    %rdi,%r9
  80226a:	49 89 f0             	mov    %rsi,%r8
  80226d:	48 89 d1             	mov    %rdx,%rcx
  802270:	48 89 c2             	mov    %rax,%rdx
  802273:	be 01 00 00 00       	mov    $0x1,%esi
  802278:	bf 05 00 00 00       	mov    $0x5,%edi
  80227d:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  802284:	00 00 00 
  802287:	ff d0                	callq  *%rax
  802289:	48 83 c4 10          	add    $0x10,%rsp
}
  80228d:	c9                   	leaveq 
  80228e:	c3                   	retq   

000000000080228f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80228f:	55                   	push   %rbp
  802290:	48 89 e5             	mov    %rsp,%rbp
  802293:	48 83 ec 10          	sub    $0x10,%rsp
  802297:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80229a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80229e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a5:	48 98                	cltq   
  8022a7:	48 83 ec 08          	sub    $0x8,%rsp
  8022ab:	6a 00                	pushq  $0x0
  8022ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022b9:	48 89 d1             	mov    %rdx,%rcx
  8022bc:	48 89 c2             	mov    %rax,%rdx
  8022bf:	be 01 00 00 00       	mov    $0x1,%esi
  8022c4:	bf 06 00 00 00       	mov    $0x6,%edi
  8022c9:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  8022d0:	00 00 00 
  8022d3:	ff d0                	callq  *%rax
  8022d5:	48 83 c4 10          	add    $0x10,%rsp
}
  8022d9:	c9                   	leaveq 
  8022da:	c3                   	retq   

00000000008022db <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8022db:	55                   	push   %rbp
  8022dc:	48 89 e5             	mov    %rsp,%rbp
  8022df:	48 83 ec 10          	sub    $0x10,%rsp
  8022e3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022e6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8022e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022ec:	48 63 d0             	movslq %eax,%rdx
  8022ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f2:	48 98                	cltq   
  8022f4:	48 83 ec 08          	sub    $0x8,%rsp
  8022f8:	6a 00                	pushq  $0x0
  8022fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802300:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802306:	48 89 d1             	mov    %rdx,%rcx
  802309:	48 89 c2             	mov    %rax,%rdx
  80230c:	be 01 00 00 00       	mov    $0x1,%esi
  802311:	bf 08 00 00 00       	mov    $0x8,%edi
  802316:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  80231d:	00 00 00 
  802320:	ff d0                	callq  *%rax
  802322:	48 83 c4 10          	add    $0x10,%rsp
}
  802326:	c9                   	leaveq 
  802327:	c3                   	retq   

0000000000802328 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802328:	55                   	push   %rbp
  802329:	48 89 e5             	mov    %rsp,%rbp
  80232c:	48 83 ec 10          	sub    $0x10,%rsp
  802330:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802333:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802337:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80233b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233e:	48 98                	cltq   
  802340:	48 83 ec 08          	sub    $0x8,%rsp
  802344:	6a 00                	pushq  $0x0
  802346:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80234c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802352:	48 89 d1             	mov    %rdx,%rcx
  802355:	48 89 c2             	mov    %rax,%rdx
  802358:	be 01 00 00 00       	mov    $0x1,%esi
  80235d:	bf 09 00 00 00       	mov    $0x9,%edi
  802362:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  802369:	00 00 00 
  80236c:	ff d0                	callq  *%rax
  80236e:	48 83 c4 10          	add    $0x10,%rsp
}
  802372:	c9                   	leaveq 
  802373:	c3                   	retq   

0000000000802374 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802374:	55                   	push   %rbp
  802375:	48 89 e5             	mov    %rsp,%rbp
  802378:	48 83 ec 20          	sub    $0x20,%rsp
  80237c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80237f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802383:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802387:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80238a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80238d:	48 63 f0             	movslq %eax,%rsi
  802390:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802394:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802397:	48 98                	cltq   
  802399:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80239d:	48 83 ec 08          	sub    $0x8,%rsp
  8023a1:	6a 00                	pushq  $0x0
  8023a3:	49 89 f1             	mov    %rsi,%r9
  8023a6:	49 89 c8             	mov    %rcx,%r8
  8023a9:	48 89 d1             	mov    %rdx,%rcx
  8023ac:	48 89 c2             	mov    %rax,%rdx
  8023af:	be 00 00 00 00       	mov    $0x0,%esi
  8023b4:	bf 0b 00 00 00       	mov    $0xb,%edi
  8023b9:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  8023c0:	00 00 00 
  8023c3:	ff d0                	callq  *%rax
  8023c5:	48 83 c4 10          	add    $0x10,%rsp
}
  8023c9:	c9                   	leaveq 
  8023ca:	c3                   	retq   

00000000008023cb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8023cb:	55                   	push   %rbp
  8023cc:	48 89 e5             	mov    %rsp,%rbp
  8023cf:	48 83 ec 10          	sub    $0x10,%rsp
  8023d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8023d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023db:	48 83 ec 08          	sub    $0x8,%rsp
  8023df:	6a 00                	pushq  $0x0
  8023e1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023f2:	48 89 c2             	mov    %rax,%rdx
  8023f5:	be 01 00 00 00       	mov    $0x1,%esi
  8023fa:	bf 0c 00 00 00       	mov    $0xc,%edi
  8023ff:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  802406:	00 00 00 
  802409:	ff d0                	callq  *%rax
  80240b:	48 83 c4 10          	add    $0x10,%rsp
}
  80240f:	c9                   	leaveq 
  802410:	c3                   	retq   

0000000000802411 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802411:	55                   	push   %rbp
  802412:	48 89 e5             	mov    %rsp,%rbp
  802415:	48 83 ec 20          	sub    $0x20,%rsp
  802419:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler==0) {
  80241d:	48 b8 f8 41 80 00 00 	movabs $0x8041f8,%rax
  802424:	00 00 00 
  802427:	48 8b 00             	mov    (%rax),%rax
  80242a:	48 85 c0             	test   %rax,%rax
  80242d:	0f 85 ae 00 00 00    	jne    8024e1 <set_pgfault_handler+0xd0>
		//allocate space
		int result = sys_page_alloc(sys_getenvid(), (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  802433:	48 b8 64 21 80 00 00 	movabs $0x802164,%rax
  80243a:	00 00 00 
  80243d:	ff d0                	callq  *%rax
  80243f:	ba 07 00 00 00       	mov    $0x7,%edx
  802444:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802449:	89 c7                	mov    %eax,%edi
  80244b:	48 b8 dd 21 80 00 00 	movabs $0x8021dd,%rax
  802452:	00 00 00 
  802455:	ff d0                	callq  *%rax
  802457:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  80245a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245e:	79 2a                	jns    80248a <set_pgfault_handler+0x79>
			panic("sys_page_alloc for stack failed in setting page fault handler");
  802460:	48 ba 58 2b 80 00 00 	movabs $0x802b58,%rdx
  802467:	00 00 00 
  80246a:	be 21 00 00 00       	mov    $0x21,%esi
  80246f:	48 bf 96 2b 80 00 00 	movabs $0x802b96,%rdi
  802476:	00 00 00 
  802479:	b8 00 00 00 00       	mov    $0x0,%eax
  80247e:	48 b9 dd 0a 80 00 00 	movabs $0x800add,%rcx
  802485:	00 00 00 
  802488:	ff d1                	callq  *%rcx
		}

		//actual set upcall
		result = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  80248a:	48 b8 64 21 80 00 00 	movabs $0x802164,%rax
  802491:	00 00 00 
  802494:	ff d0                	callq  *%rax
  802496:	48 be f5 24 80 00 00 	movabs $0x8024f5,%rsi
  80249d:	00 00 00 
  8024a0:	89 c7                	mov    %eax,%edi
  8024a2:	48 b8 28 23 80 00 00 	movabs $0x802328,%rax
  8024a9:	00 00 00 
  8024ac:	ff d0                	callq  *%rax
  8024ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  8024b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b5:	79 2a                	jns    8024e1 <set_pgfault_handler+0xd0>
                        panic("setting upcall failed in setting page fault handler");
  8024b7:	48 ba a8 2b 80 00 00 	movabs $0x802ba8,%rdx
  8024be:	00 00 00 
  8024c1:	be 27 00 00 00       	mov    $0x27,%esi
  8024c6:	48 bf 96 2b 80 00 00 	movabs $0x802b96,%rdi
  8024cd:	00 00 00 
  8024d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d5:	48 b9 dd 0a 80 00 00 	movabs $0x800add,%rcx
  8024dc:	00 00 00 
  8024df:	ff d1                	callq  *%rcx
                }
		//panic("set_pgfault_handler not implemented");
	}

	_pgfault_handler = handler;
  8024e1:	48 b8 f8 41 80 00 00 	movabs $0x8041f8,%rax
  8024e8:	00 00 00 
  8024eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024ef:	48 89 10             	mov    %rdx,(%rax)

}
  8024f2:	90                   	nop
  8024f3:	c9                   	leaveq 
  8024f4:	c3                   	retq   

00000000008024f5 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8024f5:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8024f8:	48 a1 f8 41 80 00 00 	movabs 0x8041f8,%rax
  8024ff:	00 00 00 
call *%rax
  802502:	ff d0                	callq  *%rax
	//MAKE STACK CALCS for getting parameters
	//20 = size of stack
	//8 = size of word	

	//(20-3)*8=17*8=136
	movq 136(%rsp), %rax
  802504:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  80250b:	00 
	//(20-1)*8=152
	subq $8, 152(%rsp)
  80250c:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  802513:	00 08 
	movq 152(%rsp), %rbx
  802515:	48 8b 9c 24 98 00 00 	mov    0x98(%rsp),%rbx
  80251c:	00 
	movq %rax, (%rbx)
  80251d:	48 89 03             	mov    %rax,(%rbx)
	addq $16, %rsp
  802520:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
	
    	POPA_
  802524:	4c 8b 3c 24          	mov    (%rsp),%r15
  802528:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80252d:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802532:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802537:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80253c:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802541:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802546:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80254b:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802550:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802555:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80255a:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80255f:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802564:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802569:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80256e:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
	//https://www.felixcloutier.com/x86/POPF:POPFD:POPFQ.html
    	addq $8, %rsp
  802572:	48 83 c4 08          	add    $0x8,%rsp
    	popfq	
  802576:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    	popq %rsp
  802577:	5c                   	pop    %rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    	ret
  802578:	c3                   	retq   
