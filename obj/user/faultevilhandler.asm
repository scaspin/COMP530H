
obj/user/faultevilhandler:     file format elf64-x86-64


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
  80003c:	e8 50 00 00 00       	callq  800091 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800052:	ba 07 00 00 00       	mov    $0x7,%edx
  800057:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80005c:	bf 00 00 00 00       	mov    $0x0,%edi
  800061:	48 b8 0b 03 80 00 00 	movabs $0x80030b,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  80006d:	be 20 00 10 f0       	mov    $0xf0100020,%esi
  800072:	bf 00 00 00 00       	mov    $0x0,%edi
  800077:	48 b8 56 04 80 00 00 	movabs $0x800456,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
	*(int*)0 = 0;
  800083:	b8 00 00 00 00       	mov    $0x0,%eax
  800088:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  80008e:	90                   	nop
  80008f:	c9                   	leaveq 
  800090:	c3                   	retq   

0000000000800091 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800091:	55                   	push   %rbp
  800092:	48 89 e5             	mov    %rsp,%rbp
  800095:	48 83 ec 10          	sub    $0x10,%rsp
  800099:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80009c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  8000a0:	48 b8 92 02 80 00 00 	movabs $0x800292,%rax
  8000a7:	00 00 00 
  8000aa:	ff d0                	callq  *%rax
  8000ac:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b1:	48 63 d0             	movslq %eax,%rdx
  8000b4:	48 89 d0             	mov    %rdx,%rax
  8000b7:	48 c1 e0 03          	shl    $0x3,%rax
  8000bb:	48 01 d0             	add    %rdx,%rax
  8000be:	48 c1 e0 05          	shl    $0x5,%rax
  8000c2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000c9:	00 00 00 
  8000cc:	48 01 c2             	add    %rax,%rdx
  8000cf:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000d6:	00 00 00 
  8000d9:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000e0:	7e 14                	jle    8000f6 <libmain+0x65>
		binaryname = argv[0];
  8000e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000e6:	48 8b 10             	mov    (%rax),%rdx
  8000e9:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000f0:	00 00 00 
  8000f3:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000fd:	48 89 d6             	mov    %rdx,%rsi
  800100:	89 c7                	mov    %eax,%edi
  800102:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800109:	00 00 00 
  80010c:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80010e:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
}
  80011a:	90                   	nop
  80011b:	c9                   	leaveq 
  80011c:	c3                   	retq   

000000000080011d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80011d:	55                   	push   %rbp
  80011e:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800121:	bf 00 00 00 00       	mov    $0x0,%edi
  800126:	48 b8 4c 02 80 00 00 	movabs $0x80024c,%rax
  80012d:	00 00 00 
  800130:	ff d0                	callq  *%rax
}
  800132:	90                   	nop
  800133:	5d                   	pop    %rbp
  800134:	c3                   	retq   

0000000000800135 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800135:	55                   	push   %rbp
  800136:	48 89 e5             	mov    %rsp,%rbp
  800139:	53                   	push   %rbx
  80013a:	48 83 ec 48          	sub    $0x48,%rsp
  80013e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800141:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800144:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800148:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80014c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800150:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800154:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800157:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80015b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80015f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800163:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800167:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80016b:	4c 89 c3             	mov    %r8,%rbx
  80016e:	cd 30                	int    $0x30
  800170:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800174:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800178:	74 3e                	je     8001b8 <syscall+0x83>
  80017a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80017f:	7e 37                	jle    8001b8 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800181:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800185:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800188:	49 89 d0             	mov    %rdx,%r8
  80018b:	89 c1                	mov    %eax,%ecx
  80018d:	48 ba 8a 1a 80 00 00 	movabs $0x801a8a,%rdx
  800194:	00 00 00 
  800197:	be 23 00 00 00       	mov    $0x23,%esi
  80019c:	48 bf a7 1a 80 00 00 	movabs $0x801aa7,%rdi
  8001a3:	00 00 00 
  8001a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ab:	49 b9 3f 05 80 00 00 	movabs $0x80053f,%r9
  8001b2:	00 00 00 
  8001b5:	41 ff d1             	callq  *%r9

	return ret;
  8001b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001bc:	48 83 c4 48          	add    $0x48,%rsp
  8001c0:	5b                   	pop    %rbx
  8001c1:	5d                   	pop    %rbp
  8001c2:	c3                   	retq   

00000000008001c3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001c3:	55                   	push   %rbp
  8001c4:	48 89 e5             	mov    %rsp,%rbp
  8001c7:	48 83 ec 10          	sub    $0x10,%rsp
  8001cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001db:	48 83 ec 08          	sub    $0x8,%rsp
  8001df:	6a 00                	pushq  $0x0
  8001e1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ed:	48 89 d1             	mov    %rdx,%rcx
  8001f0:	48 89 c2             	mov    %rax,%rdx
  8001f3:	be 00 00 00 00       	mov    $0x0,%esi
  8001f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fd:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  800204:	00 00 00 
  800207:	ff d0                	callq  *%rax
  800209:	48 83 c4 10          	add    $0x10,%rsp
}
  80020d:	90                   	nop
  80020e:	c9                   	leaveq 
  80020f:	c3                   	retq   

0000000000800210 <sys_cgetc>:

int
sys_cgetc(void)
{
  800210:	55                   	push   %rbp
  800211:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800214:	48 83 ec 08          	sub    $0x8,%rsp
  800218:	6a 00                	pushq  $0x0
  80021a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800220:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800226:	b9 00 00 00 00       	mov    $0x0,%ecx
  80022b:	ba 00 00 00 00       	mov    $0x0,%edx
  800230:	be 00 00 00 00       	mov    $0x0,%esi
  800235:	bf 01 00 00 00       	mov    $0x1,%edi
  80023a:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  800241:	00 00 00 
  800244:	ff d0                	callq  *%rax
  800246:	48 83 c4 10          	add    $0x10,%rsp
}
  80024a:	c9                   	leaveq 
  80024b:	c3                   	retq   

000000000080024c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80024c:	55                   	push   %rbp
  80024d:	48 89 e5             	mov    %rsp,%rbp
  800250:	48 83 ec 10          	sub    $0x10,%rsp
  800254:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800257:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80025a:	48 98                	cltq   
  80025c:	48 83 ec 08          	sub    $0x8,%rsp
  800260:	6a 00                	pushq  $0x0
  800262:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800268:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80026e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800273:	48 89 c2             	mov    %rax,%rdx
  800276:	be 01 00 00 00       	mov    $0x1,%esi
  80027b:	bf 03 00 00 00       	mov    $0x3,%edi
  800280:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  800287:	00 00 00 
  80028a:	ff d0                	callq  *%rax
  80028c:	48 83 c4 10          	add    $0x10,%rsp
}
  800290:	c9                   	leaveq 
  800291:	c3                   	retq   

0000000000800292 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800292:	55                   	push   %rbp
  800293:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800296:	48 83 ec 08          	sub    $0x8,%rsp
  80029a:	6a 00                	pushq  $0x0
  80029c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b2:	be 00 00 00 00       	mov    $0x0,%esi
  8002b7:	bf 02 00 00 00       	mov    $0x2,%edi
  8002bc:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  8002c3:	00 00 00 
  8002c6:	ff d0                	callq  *%rax
  8002c8:	48 83 c4 10          	add    $0x10,%rsp
}
  8002cc:	c9                   	leaveq 
  8002cd:	c3                   	retq   

00000000008002ce <sys_yield>:

void
sys_yield(void)
{
  8002ce:	55                   	push   %rbp
  8002cf:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002d2:	48 83 ec 08          	sub    $0x8,%rsp
  8002d6:	6a 00                	pushq  $0x0
  8002d8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ee:	be 00 00 00 00       	mov    $0x0,%esi
  8002f3:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002f8:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  8002ff:	00 00 00 
  800302:	ff d0                	callq  *%rax
  800304:	48 83 c4 10          	add    $0x10,%rsp
}
  800308:	90                   	nop
  800309:	c9                   	leaveq 
  80030a:	c3                   	retq   

000000000080030b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80030b:	55                   	push   %rbp
  80030c:	48 89 e5             	mov    %rsp,%rbp
  80030f:	48 83 ec 10          	sub    $0x10,%rsp
  800313:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800316:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80031a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80031d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800320:	48 63 c8             	movslq %eax,%rcx
  800323:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032a:	48 98                	cltq   
  80032c:	48 83 ec 08          	sub    $0x8,%rsp
  800330:	6a 00                	pushq  $0x0
  800332:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800338:	49 89 c8             	mov    %rcx,%r8
  80033b:	48 89 d1             	mov    %rdx,%rcx
  80033e:	48 89 c2             	mov    %rax,%rdx
  800341:	be 01 00 00 00       	mov    $0x1,%esi
  800346:	bf 04 00 00 00       	mov    $0x4,%edi
  80034b:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  800352:	00 00 00 
  800355:	ff d0                	callq  *%rax
  800357:	48 83 c4 10          	add    $0x10,%rsp
}
  80035b:	c9                   	leaveq 
  80035c:	c3                   	retq   

000000000080035d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80035d:	55                   	push   %rbp
  80035e:	48 89 e5             	mov    %rsp,%rbp
  800361:	48 83 ec 20          	sub    $0x20,%rsp
  800365:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800368:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80036c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80036f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800373:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800377:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80037a:	48 63 c8             	movslq %eax,%rcx
  80037d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800381:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800384:	48 63 f0             	movslq %eax,%rsi
  800387:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80038b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80038e:	48 98                	cltq   
  800390:	48 83 ec 08          	sub    $0x8,%rsp
  800394:	51                   	push   %rcx
  800395:	49 89 f9             	mov    %rdi,%r9
  800398:	49 89 f0             	mov    %rsi,%r8
  80039b:	48 89 d1             	mov    %rdx,%rcx
  80039e:	48 89 c2             	mov    %rax,%rdx
  8003a1:	be 01 00 00 00       	mov    $0x1,%esi
  8003a6:	bf 05 00 00 00       	mov    $0x5,%edi
  8003ab:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  8003b2:	00 00 00 
  8003b5:	ff d0                	callq  *%rax
  8003b7:	48 83 c4 10          	add    $0x10,%rsp
}
  8003bb:	c9                   	leaveq 
  8003bc:	c3                   	retq   

00000000008003bd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003bd:	55                   	push   %rbp
  8003be:	48 89 e5             	mov    %rsp,%rbp
  8003c1:	48 83 ec 10          	sub    $0x10,%rsp
  8003c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003d3:	48 98                	cltq   
  8003d5:	48 83 ec 08          	sub    $0x8,%rsp
  8003d9:	6a 00                	pushq  $0x0
  8003db:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003e1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003e7:	48 89 d1             	mov    %rdx,%rcx
  8003ea:	48 89 c2             	mov    %rax,%rdx
  8003ed:	be 01 00 00 00       	mov    $0x1,%esi
  8003f2:	bf 06 00 00 00       	mov    $0x6,%edi
  8003f7:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  8003fe:	00 00 00 
  800401:	ff d0                	callq  *%rax
  800403:	48 83 c4 10          	add    $0x10,%rsp
}
  800407:	c9                   	leaveq 
  800408:	c3                   	retq   

0000000000800409 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800409:	55                   	push   %rbp
  80040a:	48 89 e5             	mov    %rsp,%rbp
  80040d:	48 83 ec 10          	sub    $0x10,%rsp
  800411:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800414:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800417:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80041a:	48 63 d0             	movslq %eax,%rdx
  80041d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420:	48 98                	cltq   
  800422:	48 83 ec 08          	sub    $0x8,%rsp
  800426:	6a 00                	pushq  $0x0
  800428:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80042e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800434:	48 89 d1             	mov    %rdx,%rcx
  800437:	48 89 c2             	mov    %rax,%rdx
  80043a:	be 01 00 00 00       	mov    $0x1,%esi
  80043f:	bf 08 00 00 00       	mov    $0x8,%edi
  800444:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  80044b:	00 00 00 
  80044e:	ff d0                	callq  *%rax
  800450:	48 83 c4 10          	add    $0x10,%rsp
}
  800454:	c9                   	leaveq 
  800455:	c3                   	retq   

0000000000800456 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800456:	55                   	push   %rbp
  800457:	48 89 e5             	mov    %rsp,%rbp
  80045a:	48 83 ec 10          	sub    $0x10,%rsp
  80045e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800461:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800465:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800469:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80046c:	48 98                	cltq   
  80046e:	48 83 ec 08          	sub    $0x8,%rsp
  800472:	6a 00                	pushq  $0x0
  800474:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80047a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800480:	48 89 d1             	mov    %rdx,%rcx
  800483:	48 89 c2             	mov    %rax,%rdx
  800486:	be 01 00 00 00       	mov    $0x1,%esi
  80048b:	bf 09 00 00 00       	mov    $0x9,%edi
  800490:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  800497:	00 00 00 
  80049a:	ff d0                	callq  *%rax
  80049c:	48 83 c4 10          	add    $0x10,%rsp
}
  8004a0:	c9                   	leaveq 
  8004a1:	c3                   	retq   

00000000008004a2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004a2:	55                   	push   %rbp
  8004a3:	48 89 e5             	mov    %rsp,%rbp
  8004a6:	48 83 ec 20          	sub    $0x20,%rsp
  8004aa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004b1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004b5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004bb:	48 63 f0             	movslq %eax,%rsi
  8004be:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004c5:	48 98                	cltq   
  8004c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004cb:	48 83 ec 08          	sub    $0x8,%rsp
  8004cf:	6a 00                	pushq  $0x0
  8004d1:	49 89 f1             	mov    %rsi,%r9
  8004d4:	49 89 c8             	mov    %rcx,%r8
  8004d7:	48 89 d1             	mov    %rdx,%rcx
  8004da:	48 89 c2             	mov    %rax,%rdx
  8004dd:	be 00 00 00 00       	mov    $0x0,%esi
  8004e2:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004e7:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  8004ee:	00 00 00 
  8004f1:	ff d0                	callq  *%rax
  8004f3:	48 83 c4 10          	add    $0x10,%rsp
}
  8004f7:	c9                   	leaveq 
  8004f8:	c3                   	retq   

00000000008004f9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004f9:	55                   	push   %rbp
  8004fa:	48 89 e5             	mov    %rsp,%rbp
  8004fd:	48 83 ec 10          	sub    $0x10,%rsp
  800501:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800509:	48 83 ec 08          	sub    $0x8,%rsp
  80050d:	6a 00                	pushq  $0x0
  80050f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800515:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80051b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800520:	48 89 c2             	mov    %rax,%rdx
  800523:	be 01 00 00 00       	mov    $0x1,%esi
  800528:	bf 0c 00 00 00       	mov    $0xc,%edi
  80052d:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  800534:	00 00 00 
  800537:	ff d0                	callq  *%rax
  800539:	48 83 c4 10          	add    $0x10,%rsp
}
  80053d:	c9                   	leaveq 
  80053e:	c3                   	retq   

000000000080053f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80053f:	55                   	push   %rbp
  800540:	48 89 e5             	mov    %rsp,%rbp
  800543:	53                   	push   %rbx
  800544:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80054b:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800552:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800558:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80055f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800566:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80056d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800574:	84 c0                	test   %al,%al
  800576:	74 23                	je     80059b <_panic+0x5c>
  800578:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80057f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800583:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800587:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80058b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80058f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800593:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800597:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80059b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8005a2:	00 00 00 
  8005a5:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8005ac:	00 00 00 
  8005af:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005b3:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8005ba:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8005c1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005c8:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8005cf:	00 00 00 
  8005d2:	48 8b 18             	mov    (%rax),%rbx
  8005d5:	48 b8 92 02 80 00 00 	movabs $0x800292,%rax
  8005dc:	00 00 00 
  8005df:	ff d0                	callq  *%rax
  8005e1:	89 c6                	mov    %eax,%esi
  8005e3:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8005e9:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8005f0:	41 89 d0             	mov    %edx,%r8d
  8005f3:	48 89 c1             	mov    %rax,%rcx
  8005f6:	48 89 da             	mov    %rbx,%rdx
  8005f9:	48 bf b8 1a 80 00 00 	movabs $0x801ab8,%rdi
  800600:	00 00 00 
  800603:	b8 00 00 00 00       	mov    $0x0,%eax
  800608:	49 b9 79 07 80 00 00 	movabs $0x800779,%r9
  80060f:	00 00 00 
  800612:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800615:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80061c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800623:	48 89 d6             	mov    %rdx,%rsi
  800626:	48 89 c7             	mov    %rax,%rdi
  800629:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  800630:	00 00 00 
  800633:	ff d0                	callq  *%rax
	cprintf("\n");
  800635:	48 bf db 1a 80 00 00 	movabs $0x801adb,%rdi
  80063c:	00 00 00 
  80063f:	b8 00 00 00 00       	mov    $0x0,%eax
  800644:	48 ba 79 07 80 00 00 	movabs $0x800779,%rdx
  80064b:	00 00 00 
  80064e:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800650:	cc                   	int3   
  800651:	eb fd                	jmp    800650 <_panic+0x111>

0000000000800653 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800653:	55                   	push   %rbp
  800654:	48 89 e5             	mov    %rsp,%rbp
  800657:	48 83 ec 10          	sub    $0x10,%rsp
  80065b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80065e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800662:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800666:	8b 00                	mov    (%rax),%eax
  800668:	8d 48 01             	lea    0x1(%rax),%ecx
  80066b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80066f:	89 0a                	mov    %ecx,(%rdx)
  800671:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800674:	89 d1                	mov    %edx,%ecx
  800676:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80067a:	48 98                	cltq   
  80067c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800680:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800684:	8b 00                	mov    (%rax),%eax
  800686:	3d ff 00 00 00       	cmp    $0xff,%eax
  80068b:	75 2c                	jne    8006b9 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80068d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800691:	8b 00                	mov    (%rax),%eax
  800693:	48 98                	cltq   
  800695:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800699:	48 83 c2 08          	add    $0x8,%rdx
  80069d:	48 89 c6             	mov    %rax,%rsi
  8006a0:	48 89 d7             	mov    %rdx,%rdi
  8006a3:	48 b8 c3 01 80 00 00 	movabs $0x8001c3,%rax
  8006aa:	00 00 00 
  8006ad:	ff d0                	callq  *%rax
        b->idx = 0;
  8006af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8006b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006bd:	8b 40 04             	mov    0x4(%rax),%eax
  8006c0:	8d 50 01             	lea    0x1(%rax),%edx
  8006c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006c7:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006ca:	90                   	nop
  8006cb:	c9                   	leaveq 
  8006cc:	c3                   	retq   

00000000008006cd <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8006cd:	55                   	push   %rbp
  8006ce:	48 89 e5             	mov    %rsp,%rbp
  8006d1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006d8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006df:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006e6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006ed:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006f4:	48 8b 0a             	mov    (%rdx),%rcx
  8006f7:	48 89 08             	mov    %rcx,(%rax)
  8006fa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006fe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800702:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800706:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80070a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800711:	00 00 00 
    b.cnt = 0;
  800714:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80071b:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80071e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800725:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80072c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800733:	48 89 c6             	mov    %rax,%rsi
  800736:	48 bf 53 06 80 00 00 	movabs $0x800653,%rdi
  80073d:	00 00 00 
  800740:	48 b8 17 0b 80 00 00 	movabs $0x800b17,%rax
  800747:	00 00 00 
  80074a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80074c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800752:	48 98                	cltq   
  800754:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80075b:	48 83 c2 08          	add    $0x8,%rdx
  80075f:	48 89 c6             	mov    %rax,%rsi
  800762:	48 89 d7             	mov    %rdx,%rdi
  800765:	48 b8 c3 01 80 00 00 	movabs $0x8001c3,%rax
  80076c:	00 00 00 
  80076f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800771:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800777:	c9                   	leaveq 
  800778:	c3                   	retq   

0000000000800779 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800779:	55                   	push   %rbp
  80077a:	48 89 e5             	mov    %rsp,%rbp
  80077d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800784:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80078b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800792:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800799:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8007a0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8007a7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8007ae:	84 c0                	test   %al,%al
  8007b0:	74 20                	je     8007d2 <cprintf+0x59>
  8007b2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8007b6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8007ba:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8007be:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8007c2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8007c6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007ca:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007ce:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007d2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007d9:	00 00 00 
  8007dc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007e3:	00 00 00 
  8007e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007ea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007f1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007f8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007ff:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800806:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80080d:	48 8b 0a             	mov    (%rdx),%rcx
  800810:	48 89 08             	mov    %rcx,(%rax)
  800813:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800817:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80081b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80081f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800823:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80082a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800831:	48 89 d6             	mov    %rdx,%rsi
  800834:	48 89 c7             	mov    %rax,%rdi
  800837:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  80083e:	00 00 00 
  800841:	ff d0                	callq  *%rax
  800843:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800849:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80084f:	c9                   	leaveq 
  800850:	c3                   	retq   

0000000000800851 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800851:	55                   	push   %rbp
  800852:	48 89 e5             	mov    %rsp,%rbp
  800855:	48 83 ec 30          	sub    $0x30,%rsp
  800859:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80085d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800861:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800865:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800868:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80086c:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800870:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800873:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800877:	77 54                	ja     8008cd <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800879:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80087c:	8d 78 ff             	lea    -0x1(%rax),%edi
  80087f:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800886:	ba 00 00 00 00       	mov    $0x0,%edx
  80088b:	48 f7 f6             	div    %rsi
  80088e:	49 89 c2             	mov    %rax,%r10
  800891:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800894:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800897:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80089b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80089f:	41 89 c9             	mov    %ecx,%r9d
  8008a2:	41 89 f8             	mov    %edi,%r8d
  8008a5:	89 d1                	mov    %edx,%ecx
  8008a7:	4c 89 d2             	mov    %r10,%rdx
  8008aa:	48 89 c7             	mov    %rax,%rdi
  8008ad:	48 b8 51 08 80 00 00 	movabs $0x800851,%rax
  8008b4:	00 00 00 
  8008b7:	ff d0                	callq  *%rax
  8008b9:	eb 1c                	jmp    8008d7 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008bb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8008bf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8008c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008c6:	48 89 ce             	mov    %rcx,%rsi
  8008c9:	89 d7                	mov    %edx,%edi
  8008cb:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008cd:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8008d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8008d5:	7f e4                	jg     8008bb <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008d7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8008da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008de:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e3:	48 f7 f1             	div    %rcx
  8008e6:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  8008ed:	00 00 00 
  8008f0:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8008f4:	0f be d0             	movsbl %al,%edx
  8008f7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8008fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008ff:	48 89 ce             	mov    %rcx,%rsi
  800902:	89 d7                	mov    %edx,%edi
  800904:	ff d0                	callq  *%rax
}
  800906:	90                   	nop
  800907:	c9                   	leaveq 
  800908:	c3                   	retq   

0000000000800909 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800909:	55                   	push   %rbp
  80090a:	48 89 e5             	mov    %rsp,%rbp
  80090d:	48 83 ec 20          	sub    $0x20,%rsp
  800911:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800915:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800918:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80091c:	7e 4f                	jle    80096d <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80091e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800922:	8b 00                	mov    (%rax),%eax
  800924:	83 f8 30             	cmp    $0x30,%eax
  800927:	73 24                	jae    80094d <getuint+0x44>
  800929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800931:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800935:	8b 00                	mov    (%rax),%eax
  800937:	89 c0                	mov    %eax,%eax
  800939:	48 01 d0             	add    %rdx,%rax
  80093c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800940:	8b 12                	mov    (%rdx),%edx
  800942:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800945:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800949:	89 0a                	mov    %ecx,(%rdx)
  80094b:	eb 14                	jmp    800961 <getuint+0x58>
  80094d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800951:	48 8b 40 08          	mov    0x8(%rax),%rax
  800955:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800959:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800961:	48 8b 00             	mov    (%rax),%rax
  800964:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800968:	e9 9d 00 00 00       	jmpq   800a0a <getuint+0x101>
	else if (lflag)
  80096d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800971:	74 4c                	je     8009bf <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800973:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800977:	8b 00                	mov    (%rax),%eax
  800979:	83 f8 30             	cmp    $0x30,%eax
  80097c:	73 24                	jae    8009a2 <getuint+0x99>
  80097e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800982:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098a:	8b 00                	mov    (%rax),%eax
  80098c:	89 c0                	mov    %eax,%eax
  80098e:	48 01 d0             	add    %rdx,%rax
  800991:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800995:	8b 12                	mov    (%rdx),%edx
  800997:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80099a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099e:	89 0a                	mov    %ecx,(%rdx)
  8009a0:	eb 14                	jmp    8009b6 <getuint+0xad>
  8009a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009aa:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009b6:	48 8b 00             	mov    (%rax),%rax
  8009b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009bd:	eb 4b                	jmp    800a0a <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8009bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c3:	8b 00                	mov    (%rax),%eax
  8009c5:	83 f8 30             	cmp    $0x30,%eax
  8009c8:	73 24                	jae    8009ee <getuint+0xe5>
  8009ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ce:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d6:	8b 00                	mov    (%rax),%eax
  8009d8:	89 c0                	mov    %eax,%eax
  8009da:	48 01 d0             	add    %rdx,%rax
  8009dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e1:	8b 12                	mov    (%rdx),%edx
  8009e3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ea:	89 0a                	mov    %ecx,(%rdx)
  8009ec:	eb 14                	jmp    800a02 <getuint+0xf9>
  8009ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009f6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a02:	8b 00                	mov    (%rax),%eax
  800a04:	89 c0                	mov    %eax,%eax
  800a06:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a0e:	c9                   	leaveq 
  800a0f:	c3                   	retq   

0000000000800a10 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a10:	55                   	push   %rbp
  800a11:	48 89 e5             	mov    %rsp,%rbp
  800a14:	48 83 ec 20          	sub    $0x20,%rsp
  800a18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a1c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a1f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a23:	7e 4f                	jle    800a74 <getint+0x64>
		x=va_arg(*ap, long long);
  800a25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a29:	8b 00                	mov    (%rax),%eax
  800a2b:	83 f8 30             	cmp    $0x30,%eax
  800a2e:	73 24                	jae    800a54 <getint+0x44>
  800a30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a34:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3c:	8b 00                	mov    (%rax),%eax
  800a3e:	89 c0                	mov    %eax,%eax
  800a40:	48 01 d0             	add    %rdx,%rax
  800a43:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a47:	8b 12                	mov    (%rdx),%edx
  800a49:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a4c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a50:	89 0a                	mov    %ecx,(%rdx)
  800a52:	eb 14                	jmp    800a68 <getint+0x58>
  800a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a58:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a5c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a64:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a68:	48 8b 00             	mov    (%rax),%rax
  800a6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a6f:	e9 9d 00 00 00       	jmpq   800b11 <getint+0x101>
	else if (lflag)
  800a74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a78:	74 4c                	je     800ac6 <getint+0xb6>
		x=va_arg(*ap, long);
  800a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7e:	8b 00                	mov    (%rax),%eax
  800a80:	83 f8 30             	cmp    $0x30,%eax
  800a83:	73 24                	jae    800aa9 <getint+0x99>
  800a85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a89:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a91:	8b 00                	mov    (%rax),%eax
  800a93:	89 c0                	mov    %eax,%eax
  800a95:	48 01 d0             	add    %rdx,%rax
  800a98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9c:	8b 12                	mov    (%rdx),%edx
  800a9e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aa1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa5:	89 0a                	mov    %ecx,(%rdx)
  800aa7:	eb 14                	jmp    800abd <getint+0xad>
  800aa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aad:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ab1:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ab5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800abd:	48 8b 00             	mov    (%rax),%rax
  800ac0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ac4:	eb 4b                	jmp    800b11 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800ac6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aca:	8b 00                	mov    (%rax),%eax
  800acc:	83 f8 30             	cmp    $0x30,%eax
  800acf:	73 24                	jae    800af5 <getint+0xe5>
  800ad1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ad9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800add:	8b 00                	mov    (%rax),%eax
  800adf:	89 c0                	mov    %eax,%eax
  800ae1:	48 01 d0             	add    %rdx,%rax
  800ae4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae8:	8b 12                	mov    (%rdx),%edx
  800aea:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af1:	89 0a                	mov    %ecx,(%rdx)
  800af3:	eb 14                	jmp    800b09 <getint+0xf9>
  800af5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af9:	48 8b 40 08          	mov    0x8(%rax),%rax
  800afd:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b01:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b05:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b09:	8b 00                	mov    (%rax),%eax
  800b0b:	48 98                	cltq   
  800b0d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b15:	c9                   	leaveq 
  800b16:	c3                   	retq   

0000000000800b17 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b17:	55                   	push   %rbp
  800b18:	48 89 e5             	mov    %rsp,%rbp
  800b1b:	41 54                	push   %r12
  800b1d:	53                   	push   %rbx
  800b1e:	48 83 ec 60          	sub    $0x60,%rsp
  800b22:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b26:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b2a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b2e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b32:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b36:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b3a:	48 8b 0a             	mov    (%rdx),%rcx
  800b3d:	48 89 08             	mov    %rcx,(%rax)
  800b40:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b44:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b48:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b4c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b50:	eb 17                	jmp    800b69 <vprintfmt+0x52>
			if (ch == '\0')
  800b52:	85 db                	test   %ebx,%ebx
  800b54:	0f 84 b9 04 00 00    	je     801013 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800b5a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b62:	48 89 d6             	mov    %rdx,%rsi
  800b65:	89 df                	mov    %ebx,%edi
  800b67:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b69:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b6d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b71:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b75:	0f b6 00             	movzbl (%rax),%eax
  800b78:	0f b6 d8             	movzbl %al,%ebx
  800b7b:	83 fb 25             	cmp    $0x25,%ebx
  800b7e:	75 d2                	jne    800b52 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b80:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b84:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b8b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b92:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b99:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ba0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ba4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ba8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bac:	0f b6 00             	movzbl (%rax),%eax
  800baf:	0f b6 d8             	movzbl %al,%ebx
  800bb2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800bb5:	83 f8 55             	cmp    $0x55,%eax
  800bb8:	0f 87 22 04 00 00    	ja     800fe0 <vprintfmt+0x4c9>
  800bbe:	89 c0                	mov    %eax,%eax
  800bc0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bc7:	00 
  800bc8:	48 b8 58 1c 80 00 00 	movabs $0x801c58,%rax
  800bcf:	00 00 00 
  800bd2:	48 01 d0             	add    %rdx,%rax
  800bd5:	48 8b 00             	mov    (%rax),%rax
  800bd8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bda:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bde:	eb c0                	jmp    800ba0 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800be0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800be4:	eb ba                	jmp    800ba0 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bed:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bf0:	89 d0                	mov    %edx,%eax
  800bf2:	c1 e0 02             	shl    $0x2,%eax
  800bf5:	01 d0                	add    %edx,%eax
  800bf7:	01 c0                	add    %eax,%eax
  800bf9:	01 d8                	add    %ebx,%eax
  800bfb:	83 e8 30             	sub    $0x30,%eax
  800bfe:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c01:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c05:	0f b6 00             	movzbl (%rax),%eax
  800c08:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c0b:	83 fb 2f             	cmp    $0x2f,%ebx
  800c0e:	7e 60                	jle    800c70 <vprintfmt+0x159>
  800c10:	83 fb 39             	cmp    $0x39,%ebx
  800c13:	7f 5b                	jg     800c70 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c15:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c1a:	eb d1                	jmp    800bed <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800c1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c1f:	83 f8 30             	cmp    $0x30,%eax
  800c22:	73 17                	jae    800c3b <vprintfmt+0x124>
  800c24:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c28:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c2b:	89 d2                	mov    %edx,%edx
  800c2d:	48 01 d0             	add    %rdx,%rax
  800c30:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c33:	83 c2 08             	add    $0x8,%edx
  800c36:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c39:	eb 0c                	jmp    800c47 <vprintfmt+0x130>
  800c3b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c3f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c43:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c47:	8b 00                	mov    (%rax),%eax
  800c49:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c4c:	eb 23                	jmp    800c71 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800c4e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c52:	0f 89 48 ff ff ff    	jns    800ba0 <vprintfmt+0x89>
				width = 0;
  800c58:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c5f:	e9 3c ff ff ff       	jmpq   800ba0 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c64:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c6b:	e9 30 ff ff ff       	jmpq   800ba0 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c70:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c71:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c75:	0f 89 25 ff ff ff    	jns    800ba0 <vprintfmt+0x89>
				width = precision, precision = -1;
  800c7b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c7e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c81:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c88:	e9 13 ff ff ff       	jmpq   800ba0 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c8d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c91:	e9 0a ff ff ff       	jmpq   800ba0 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c99:	83 f8 30             	cmp    $0x30,%eax
  800c9c:	73 17                	jae    800cb5 <vprintfmt+0x19e>
  800c9e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ca2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca5:	89 d2                	mov    %edx,%edx
  800ca7:	48 01 d0             	add    %rdx,%rax
  800caa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cad:	83 c2 08             	add    $0x8,%edx
  800cb0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cb3:	eb 0c                	jmp    800cc1 <vprintfmt+0x1aa>
  800cb5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cb9:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cbd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc1:	8b 10                	mov    (%rax),%edx
  800cc3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cc7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ccb:	48 89 ce             	mov    %rcx,%rsi
  800cce:	89 d7                	mov    %edx,%edi
  800cd0:	ff d0                	callq  *%rax
			break;
  800cd2:	e9 37 03 00 00       	jmpq   80100e <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cd7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cda:	83 f8 30             	cmp    $0x30,%eax
  800cdd:	73 17                	jae    800cf6 <vprintfmt+0x1df>
  800cdf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ce3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ce6:	89 d2                	mov    %edx,%edx
  800ce8:	48 01 d0             	add    %rdx,%rax
  800ceb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cee:	83 c2 08             	add    $0x8,%edx
  800cf1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cf4:	eb 0c                	jmp    800d02 <vprintfmt+0x1eb>
  800cf6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cfa:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cfe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d02:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d04:	85 db                	test   %ebx,%ebx
  800d06:	79 02                	jns    800d0a <vprintfmt+0x1f3>
				err = -err;
  800d08:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d0a:	83 fb 15             	cmp    $0x15,%ebx
  800d0d:	7f 16                	jg     800d25 <vprintfmt+0x20e>
  800d0f:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  800d16:	00 00 00 
  800d19:	48 63 d3             	movslq %ebx,%rdx
  800d1c:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d20:	4d 85 e4             	test   %r12,%r12
  800d23:	75 2e                	jne    800d53 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800d25:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2d:	89 d9                	mov    %ebx,%ecx
  800d2f:	48 ba 41 1c 80 00 00 	movabs $0x801c41,%rdx
  800d36:	00 00 00 
  800d39:	48 89 c7             	mov    %rax,%rdi
  800d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d41:	49 b8 1d 10 80 00 00 	movabs $0x80101d,%r8
  800d48:	00 00 00 
  800d4b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d4e:	e9 bb 02 00 00       	jmpq   80100e <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d53:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5b:	4c 89 e1             	mov    %r12,%rcx
  800d5e:	48 ba 4a 1c 80 00 00 	movabs $0x801c4a,%rdx
  800d65:	00 00 00 
  800d68:	48 89 c7             	mov    %rax,%rdi
  800d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d70:	49 b8 1d 10 80 00 00 	movabs $0x80101d,%r8
  800d77:	00 00 00 
  800d7a:	41 ff d0             	callq  *%r8
			break;
  800d7d:	e9 8c 02 00 00       	jmpq   80100e <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d85:	83 f8 30             	cmp    $0x30,%eax
  800d88:	73 17                	jae    800da1 <vprintfmt+0x28a>
  800d8a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d8e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d91:	89 d2                	mov    %edx,%edx
  800d93:	48 01 d0             	add    %rdx,%rax
  800d96:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d99:	83 c2 08             	add    $0x8,%edx
  800d9c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d9f:	eb 0c                	jmp    800dad <vprintfmt+0x296>
  800da1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800da5:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800da9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dad:	4c 8b 20             	mov    (%rax),%r12
  800db0:	4d 85 e4             	test   %r12,%r12
  800db3:	75 0a                	jne    800dbf <vprintfmt+0x2a8>
				p = "(null)";
  800db5:	49 bc 4d 1c 80 00 00 	movabs $0x801c4d,%r12
  800dbc:	00 00 00 
			if (width > 0 && padc != '-')
  800dbf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dc3:	7e 78                	jle    800e3d <vprintfmt+0x326>
  800dc5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dc9:	74 72                	je     800e3d <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dcb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dce:	48 98                	cltq   
  800dd0:	48 89 c6             	mov    %rax,%rsi
  800dd3:	4c 89 e7             	mov    %r12,%rdi
  800dd6:	48 b8 cb 12 80 00 00 	movabs $0x8012cb,%rax
  800ddd:	00 00 00 
  800de0:	ff d0                	callq  *%rax
  800de2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800de5:	eb 17                	jmp    800dfe <vprintfmt+0x2e7>
					putch(padc, putdat);
  800de7:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800deb:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800def:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df3:	48 89 ce             	mov    %rcx,%rsi
  800df6:	89 d7                	mov    %edx,%edi
  800df8:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dfa:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dfe:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e02:	7f e3                	jg     800de7 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e04:	eb 37                	jmp    800e3d <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800e06:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e0a:	74 1e                	je     800e2a <vprintfmt+0x313>
  800e0c:	83 fb 1f             	cmp    $0x1f,%ebx
  800e0f:	7e 05                	jle    800e16 <vprintfmt+0x2ff>
  800e11:	83 fb 7e             	cmp    $0x7e,%ebx
  800e14:	7e 14                	jle    800e2a <vprintfmt+0x313>
					putch('?', putdat);
  800e16:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1e:	48 89 d6             	mov    %rdx,%rsi
  800e21:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e26:	ff d0                	callq  *%rax
  800e28:	eb 0f                	jmp    800e39 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800e2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e32:	48 89 d6             	mov    %rdx,%rsi
  800e35:	89 df                	mov    %ebx,%edi
  800e37:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e39:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e3d:	4c 89 e0             	mov    %r12,%rax
  800e40:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e44:	0f b6 00             	movzbl (%rax),%eax
  800e47:	0f be d8             	movsbl %al,%ebx
  800e4a:	85 db                	test   %ebx,%ebx
  800e4c:	74 28                	je     800e76 <vprintfmt+0x35f>
  800e4e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e52:	78 b2                	js     800e06 <vprintfmt+0x2ef>
  800e54:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e58:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e5c:	79 a8                	jns    800e06 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e5e:	eb 16                	jmp    800e76 <vprintfmt+0x35f>
				putch(' ', putdat);
  800e60:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e64:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e68:	48 89 d6             	mov    %rdx,%rsi
  800e6b:	bf 20 00 00 00       	mov    $0x20,%edi
  800e70:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e72:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e76:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e7a:	7f e4                	jg     800e60 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800e7c:	e9 8d 01 00 00       	jmpq   80100e <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e81:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e85:	be 03 00 00 00       	mov    $0x3,%esi
  800e8a:	48 89 c7             	mov    %rax,%rdi
  800e8d:	48 b8 10 0a 80 00 00 	movabs $0x800a10,%rax
  800e94:	00 00 00 
  800e97:	ff d0                	callq  *%rax
  800e99:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea1:	48 85 c0             	test   %rax,%rax
  800ea4:	79 1d                	jns    800ec3 <vprintfmt+0x3ac>
				putch('-', putdat);
  800ea6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eaa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eae:	48 89 d6             	mov    %rdx,%rsi
  800eb1:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800eb6:	ff d0                	callq  *%rax
				num = -(long long) num;
  800eb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebc:	48 f7 d8             	neg    %rax
  800ebf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ec3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800eca:	e9 d2 00 00 00       	jmpq   800fa1 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ecf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ed3:	be 03 00 00 00       	mov    $0x3,%esi
  800ed8:	48 89 c7             	mov    %rax,%rdi
  800edb:	48 b8 09 09 80 00 00 	movabs $0x800909,%rax
  800ee2:	00 00 00 
  800ee5:	ff d0                	callq  *%rax
  800ee7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800eeb:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ef2:	e9 aa 00 00 00       	jmpq   800fa1 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800ef7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800efb:	be 03 00 00 00       	mov    $0x3,%esi
  800f00:	48 89 c7             	mov    %rax,%rdi
  800f03:	48 b8 09 09 80 00 00 	movabs $0x800909,%rax
  800f0a:	00 00 00 
  800f0d:	ff d0                	callq  *%rax
  800f0f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f13:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f1a:	e9 82 00 00 00       	jmpq   800fa1 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800f1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f27:	48 89 d6             	mov    %rdx,%rsi
  800f2a:	bf 30 00 00 00       	mov    $0x30,%edi
  800f2f:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f31:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f39:	48 89 d6             	mov    %rdx,%rsi
  800f3c:	bf 78 00 00 00       	mov    $0x78,%edi
  800f41:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f46:	83 f8 30             	cmp    $0x30,%eax
  800f49:	73 17                	jae    800f62 <vprintfmt+0x44b>
  800f4b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f4f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f52:	89 d2                	mov    %edx,%edx
  800f54:	48 01 d0             	add    %rdx,%rax
  800f57:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f5a:	83 c2 08             	add    $0x8,%edx
  800f5d:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f60:	eb 0c                	jmp    800f6e <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800f62:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800f66:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800f6a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f6e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f71:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f75:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f7c:	eb 23                	jmp    800fa1 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f7e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f82:	be 03 00 00 00       	mov    $0x3,%esi
  800f87:	48 89 c7             	mov    %rax,%rdi
  800f8a:	48 b8 09 09 80 00 00 	movabs $0x800909,%rax
  800f91:	00 00 00 
  800f94:	ff d0                	callq  *%rax
  800f96:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f9a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fa1:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fa6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fa9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fb4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fb8:	45 89 c1             	mov    %r8d,%r9d
  800fbb:	41 89 f8             	mov    %edi,%r8d
  800fbe:	48 89 c7             	mov    %rax,%rdi
  800fc1:	48 b8 51 08 80 00 00 	movabs $0x800851,%rax
  800fc8:	00 00 00 
  800fcb:	ff d0                	callq  *%rax
			break;
  800fcd:	eb 3f                	jmp    80100e <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fcf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd7:	48 89 d6             	mov    %rdx,%rsi
  800fda:	89 df                	mov    %ebx,%edi
  800fdc:	ff d0                	callq  *%rax
			break;
  800fde:	eb 2e                	jmp    80100e <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fe0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe8:	48 89 d6             	mov    %rdx,%rsi
  800feb:	bf 25 00 00 00       	mov    $0x25,%edi
  800ff0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ff2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ff7:	eb 05                	jmp    800ffe <vprintfmt+0x4e7>
  800ff9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ffe:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801002:	48 83 e8 01          	sub    $0x1,%rax
  801006:	0f b6 00             	movzbl (%rax),%eax
  801009:	3c 25                	cmp    $0x25,%al
  80100b:	75 ec                	jne    800ff9 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  80100d:	90                   	nop
		}
	}
  80100e:	e9 3d fb ff ff       	jmpq   800b50 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801013:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801014:	48 83 c4 60          	add    $0x60,%rsp
  801018:	5b                   	pop    %rbx
  801019:	41 5c                	pop    %r12
  80101b:	5d                   	pop    %rbp
  80101c:	c3                   	retq   

000000000080101d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80101d:	55                   	push   %rbp
  80101e:	48 89 e5             	mov    %rsp,%rbp
  801021:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801028:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80102f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801036:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  80103d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801044:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80104b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801052:	84 c0                	test   %al,%al
  801054:	74 20                	je     801076 <printfmt+0x59>
  801056:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80105a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80105e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801062:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801066:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80106a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80106e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801072:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801076:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80107d:	00 00 00 
  801080:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801087:	00 00 00 
  80108a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80108e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801095:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80109c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010a3:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010aa:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010b1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010b8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010bf:	48 89 c7             	mov    %rax,%rdi
  8010c2:	48 b8 17 0b 80 00 00 	movabs $0x800b17,%rax
  8010c9:	00 00 00 
  8010cc:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010ce:	90                   	nop
  8010cf:	c9                   	leaveq 
  8010d0:	c3                   	retq   

00000000008010d1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010d1:	55                   	push   %rbp
  8010d2:	48 89 e5             	mov    %rsp,%rbp
  8010d5:	48 83 ec 10          	sub    $0x10,%rsp
  8010d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e4:	8b 40 10             	mov    0x10(%rax),%eax
  8010e7:	8d 50 01             	lea    0x1(%rax),%edx
  8010ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ee:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f5:	48 8b 10             	mov    (%rax),%rdx
  8010f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fc:	48 8b 40 08          	mov    0x8(%rax),%rax
  801100:	48 39 c2             	cmp    %rax,%rdx
  801103:	73 17                	jae    80111c <sprintputch+0x4b>
		*b->buf++ = ch;
  801105:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801109:	48 8b 00             	mov    (%rax),%rax
  80110c:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801110:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801114:	48 89 0a             	mov    %rcx,(%rdx)
  801117:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80111a:	88 10                	mov    %dl,(%rax)
}
  80111c:	90                   	nop
  80111d:	c9                   	leaveq 
  80111e:	c3                   	retq   

000000000080111f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80111f:	55                   	push   %rbp
  801120:	48 89 e5             	mov    %rsp,%rbp
  801123:	48 83 ec 50          	sub    $0x50,%rsp
  801127:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80112b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80112e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801132:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801136:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80113a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80113e:	48 8b 0a             	mov    (%rdx),%rcx
  801141:	48 89 08             	mov    %rcx,(%rax)
  801144:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801148:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80114c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801150:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801154:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801158:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80115c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80115f:	48 98                	cltq   
  801161:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801165:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801169:	48 01 d0             	add    %rdx,%rax
  80116c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801170:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801177:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80117c:	74 06                	je     801184 <vsnprintf+0x65>
  80117e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801182:	7f 07                	jg     80118b <vsnprintf+0x6c>
		return -E_INVAL;
  801184:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801189:	eb 2f                	jmp    8011ba <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80118b:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80118f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801193:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801197:	48 89 c6             	mov    %rax,%rsi
  80119a:	48 bf d1 10 80 00 00 	movabs $0x8010d1,%rdi
  8011a1:	00 00 00 
  8011a4:	48 b8 17 0b 80 00 00 	movabs $0x800b17,%rax
  8011ab:	00 00 00 
  8011ae:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011b4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011b7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011ba:	c9                   	leaveq 
  8011bb:	c3                   	retq   

00000000008011bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011bc:	55                   	push   %rbp
  8011bd:	48 89 e5             	mov    %rsp,%rbp
  8011c0:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011c7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011ce:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011d4:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8011db:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011e2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011e9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011f0:	84 c0                	test   %al,%al
  8011f2:	74 20                	je     801214 <snprintf+0x58>
  8011f4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011f8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011fc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801200:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801204:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801208:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80120c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801210:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801214:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80121b:	00 00 00 
  80121e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801225:	00 00 00 
  801228:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80122c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801233:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80123a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801241:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801248:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80124f:	48 8b 0a             	mov    (%rdx),%rcx
  801252:	48 89 08             	mov    %rcx,(%rax)
  801255:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801259:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80125d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801261:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801265:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80126c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801273:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801279:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801280:	48 89 c7             	mov    %rax,%rdi
  801283:	48 b8 1f 11 80 00 00 	movabs $0x80111f,%rax
  80128a:	00 00 00 
  80128d:	ff d0                	callq  *%rax
  80128f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801295:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80129b:	c9                   	leaveq 
  80129c:	c3                   	retq   

000000000080129d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80129d:	55                   	push   %rbp
  80129e:	48 89 e5             	mov    %rsp,%rbp
  8012a1:	48 83 ec 18          	sub    $0x18,%rsp
  8012a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012b0:	eb 09                	jmp    8012bb <strlen+0x1e>
		n++;
  8012b2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bf:	0f b6 00             	movzbl (%rax),%eax
  8012c2:	84 c0                	test   %al,%al
  8012c4:	75 ec                	jne    8012b2 <strlen+0x15>
		n++;
	return n;
  8012c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012c9:	c9                   	leaveq 
  8012ca:	c3                   	retq   

00000000008012cb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012cb:	55                   	push   %rbp
  8012cc:	48 89 e5             	mov    %rsp,%rbp
  8012cf:	48 83 ec 20          	sub    $0x20,%rsp
  8012d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012e2:	eb 0e                	jmp    8012f2 <strnlen+0x27>
		n++;
  8012e4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012ed:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012f2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012f7:	74 0b                	je     801304 <strnlen+0x39>
  8012f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fd:	0f b6 00             	movzbl (%rax),%eax
  801300:	84 c0                	test   %al,%al
  801302:	75 e0                	jne    8012e4 <strnlen+0x19>
		n++;
	return n;
  801304:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801307:	c9                   	leaveq 
  801308:	c3                   	retq   

0000000000801309 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801309:	55                   	push   %rbp
  80130a:	48 89 e5             	mov    %rsp,%rbp
  80130d:	48 83 ec 20          	sub    $0x20,%rsp
  801311:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801315:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801319:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801321:	90                   	nop
  801322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801326:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80132a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80132e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801332:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801336:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80133a:	0f b6 12             	movzbl (%rdx),%edx
  80133d:	88 10                	mov    %dl,(%rax)
  80133f:	0f b6 00             	movzbl (%rax),%eax
  801342:	84 c0                	test   %al,%al
  801344:	75 dc                	jne    801322 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801346:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80134a:	c9                   	leaveq 
  80134b:	c3                   	retq   

000000000080134c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80134c:	55                   	push   %rbp
  80134d:	48 89 e5             	mov    %rsp,%rbp
  801350:	48 83 ec 20          	sub    $0x20,%rsp
  801354:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801358:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80135c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801360:	48 89 c7             	mov    %rax,%rdi
  801363:	48 b8 9d 12 80 00 00 	movabs $0x80129d,%rax
  80136a:	00 00 00 
  80136d:	ff d0                	callq  *%rax
  80136f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801372:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801375:	48 63 d0             	movslq %eax,%rdx
  801378:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137c:	48 01 c2             	add    %rax,%rdx
  80137f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801383:	48 89 c6             	mov    %rax,%rsi
  801386:	48 89 d7             	mov    %rdx,%rdi
  801389:	48 b8 09 13 80 00 00 	movabs $0x801309,%rax
  801390:	00 00 00 
  801393:	ff d0                	callq  *%rax
	return dst;
  801395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801399:	c9                   	leaveq 
  80139a:	c3                   	retq   

000000000080139b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80139b:	55                   	push   %rbp
  80139c:	48 89 e5             	mov    %rsp,%rbp
  80139f:	48 83 ec 28          	sub    $0x28,%rsp
  8013a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013b7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013be:	00 
  8013bf:	eb 2a                	jmp    8013eb <strncpy+0x50>
		*dst++ = *src;
  8013c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013c9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013d1:	0f b6 12             	movzbl (%rdx),%edx
  8013d4:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013da:	0f b6 00             	movzbl (%rax),%eax
  8013dd:	84 c0                	test   %al,%al
  8013df:	74 05                	je     8013e6 <strncpy+0x4b>
			src++;
  8013e1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013e6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ef:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013f3:	72 cc                	jb     8013c1 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013f9:	c9                   	leaveq 
  8013fa:	c3                   	retq   

00000000008013fb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013fb:	55                   	push   %rbp
  8013fc:	48 89 e5             	mov    %rsp,%rbp
  8013ff:	48 83 ec 28          	sub    $0x28,%rsp
  801403:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801407:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80140b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80140f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801413:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801417:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80141c:	74 3d                	je     80145b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80141e:	eb 1d                	jmp    80143d <strlcpy+0x42>
			*dst++ = *src++;
  801420:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801424:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801428:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80142c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801430:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801434:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801438:	0f b6 12             	movzbl (%rdx),%edx
  80143b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80143d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801442:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801447:	74 0b                	je     801454 <strlcpy+0x59>
  801449:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80144d:	0f b6 00             	movzbl (%rax),%eax
  801450:	84 c0                	test   %al,%al
  801452:	75 cc                	jne    801420 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801454:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801458:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80145b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80145f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801463:	48 29 c2             	sub    %rax,%rdx
  801466:	48 89 d0             	mov    %rdx,%rax
}
  801469:	c9                   	leaveq 
  80146a:	c3                   	retq   

000000000080146b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80146b:	55                   	push   %rbp
  80146c:	48 89 e5             	mov    %rsp,%rbp
  80146f:	48 83 ec 10          	sub    $0x10,%rsp
  801473:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801477:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80147b:	eb 0a                	jmp    801487 <strcmp+0x1c>
		p++, q++;
  80147d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801482:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801487:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148b:	0f b6 00             	movzbl (%rax),%eax
  80148e:	84 c0                	test   %al,%al
  801490:	74 12                	je     8014a4 <strcmp+0x39>
  801492:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801496:	0f b6 10             	movzbl (%rax),%edx
  801499:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149d:	0f b6 00             	movzbl (%rax),%eax
  8014a0:	38 c2                	cmp    %al,%dl
  8014a2:	74 d9                	je     80147d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a8:	0f b6 00             	movzbl (%rax),%eax
  8014ab:	0f b6 d0             	movzbl %al,%edx
  8014ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b2:	0f b6 00             	movzbl (%rax),%eax
  8014b5:	0f b6 c0             	movzbl %al,%eax
  8014b8:	29 c2                	sub    %eax,%edx
  8014ba:	89 d0                	mov    %edx,%eax
}
  8014bc:	c9                   	leaveq 
  8014bd:	c3                   	retq   

00000000008014be <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014be:	55                   	push   %rbp
  8014bf:	48 89 e5             	mov    %rsp,%rbp
  8014c2:	48 83 ec 18          	sub    $0x18,%rsp
  8014c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014d2:	eb 0f                	jmp    8014e3 <strncmp+0x25>
		n--, p++, q++;
  8014d4:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014de:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014e3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014e8:	74 1d                	je     801507 <strncmp+0x49>
  8014ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ee:	0f b6 00             	movzbl (%rax),%eax
  8014f1:	84 c0                	test   %al,%al
  8014f3:	74 12                	je     801507 <strncmp+0x49>
  8014f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f9:	0f b6 10             	movzbl (%rax),%edx
  8014fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801500:	0f b6 00             	movzbl (%rax),%eax
  801503:	38 c2                	cmp    %al,%dl
  801505:	74 cd                	je     8014d4 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801507:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80150c:	75 07                	jne    801515 <strncmp+0x57>
		return 0;
  80150e:	b8 00 00 00 00       	mov    $0x0,%eax
  801513:	eb 18                	jmp    80152d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801515:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801519:	0f b6 00             	movzbl (%rax),%eax
  80151c:	0f b6 d0             	movzbl %al,%edx
  80151f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801523:	0f b6 00             	movzbl (%rax),%eax
  801526:	0f b6 c0             	movzbl %al,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
}
  80152d:	c9                   	leaveq 
  80152e:	c3                   	retq   

000000000080152f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80152f:	55                   	push   %rbp
  801530:	48 89 e5             	mov    %rsp,%rbp
  801533:	48 83 ec 10          	sub    $0x10,%rsp
  801537:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80153b:	89 f0                	mov    %esi,%eax
  80153d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801540:	eb 17                	jmp    801559 <strchr+0x2a>
		if (*s == c)
  801542:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801546:	0f b6 00             	movzbl (%rax),%eax
  801549:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80154c:	75 06                	jne    801554 <strchr+0x25>
			return (char *) s;
  80154e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801552:	eb 15                	jmp    801569 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801554:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801559:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155d:	0f b6 00             	movzbl (%rax),%eax
  801560:	84 c0                	test   %al,%al
  801562:	75 de                	jne    801542 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801564:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801569:	c9                   	leaveq 
  80156a:	c3                   	retq   

000000000080156b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80156b:	55                   	push   %rbp
  80156c:	48 89 e5             	mov    %rsp,%rbp
  80156f:	48 83 ec 10          	sub    $0x10,%rsp
  801573:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801577:	89 f0                	mov    %esi,%eax
  801579:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80157c:	eb 11                	jmp    80158f <strfind+0x24>
		if (*s == c)
  80157e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801582:	0f b6 00             	movzbl (%rax),%eax
  801585:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801588:	74 12                	je     80159c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80158a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80158f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801593:	0f b6 00             	movzbl (%rax),%eax
  801596:	84 c0                	test   %al,%al
  801598:	75 e4                	jne    80157e <strfind+0x13>
  80159a:	eb 01                	jmp    80159d <strfind+0x32>
		if (*s == c)
			break;
  80159c:	90                   	nop
	return (char *) s;
  80159d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015a1:	c9                   	leaveq 
  8015a2:	c3                   	retq   

00000000008015a3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8015a3:	55                   	push   %rbp
  8015a4:	48 89 e5             	mov    %rsp,%rbp
  8015a7:	48 83 ec 18          	sub    $0x18,%rsp
  8015ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015af:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015b2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015b6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015bb:	75 06                	jne    8015c3 <memset+0x20>
		return v;
  8015bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c1:	eb 69                	jmp    80162c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c7:	83 e0 03             	and    $0x3,%eax
  8015ca:	48 85 c0             	test   %rax,%rax
  8015cd:	75 48                	jne    801617 <memset+0x74>
  8015cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d3:	83 e0 03             	and    $0x3,%eax
  8015d6:	48 85 c0             	test   %rax,%rax
  8015d9:	75 3c                	jne    801617 <memset+0x74>
		c &= 0xFF;
  8015db:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e5:	c1 e0 18             	shl    $0x18,%eax
  8015e8:	89 c2                	mov    %eax,%edx
  8015ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ed:	c1 e0 10             	shl    $0x10,%eax
  8015f0:	09 c2                	or     %eax,%edx
  8015f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f5:	c1 e0 08             	shl    $0x8,%eax
  8015f8:	09 d0                	or     %edx,%eax
  8015fa:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801601:	48 c1 e8 02          	shr    $0x2,%rax
  801605:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801608:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80160c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80160f:	48 89 d7             	mov    %rdx,%rdi
  801612:	fc                   	cld    
  801613:	f3 ab                	rep stos %eax,%es:(%rdi)
  801615:	eb 11                	jmp    801628 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801617:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80161b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80161e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801622:	48 89 d7             	mov    %rdx,%rdi
  801625:	fc                   	cld    
  801626:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801628:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80162c:	c9                   	leaveq 
  80162d:	c3                   	retq   

000000000080162e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80162e:	55                   	push   %rbp
  80162f:	48 89 e5             	mov    %rsp,%rbp
  801632:	48 83 ec 28          	sub    $0x28,%rsp
  801636:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80163a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80163e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801642:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801646:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80164a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80164e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801652:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801656:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80165a:	0f 83 88 00 00 00    	jae    8016e8 <memmove+0xba>
  801660:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801664:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801668:	48 01 d0             	add    %rdx,%rax
  80166b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80166f:	76 77                	jbe    8016e8 <memmove+0xba>
		s += n;
  801671:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801675:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801679:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801681:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801685:	83 e0 03             	and    $0x3,%eax
  801688:	48 85 c0             	test   %rax,%rax
  80168b:	75 3b                	jne    8016c8 <memmove+0x9a>
  80168d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801691:	83 e0 03             	and    $0x3,%eax
  801694:	48 85 c0             	test   %rax,%rax
  801697:	75 2f                	jne    8016c8 <memmove+0x9a>
  801699:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169d:	83 e0 03             	and    $0x3,%eax
  8016a0:	48 85 c0             	test   %rax,%rax
  8016a3:	75 23                	jne    8016c8 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a9:	48 83 e8 04          	sub    $0x4,%rax
  8016ad:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b1:	48 83 ea 04          	sub    $0x4,%rdx
  8016b5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016b9:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016bd:	48 89 c7             	mov    %rax,%rdi
  8016c0:	48 89 d6             	mov    %rdx,%rsi
  8016c3:	fd                   	std    
  8016c4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016c6:	eb 1d                	jmp    8016e5 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d4:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016dc:	48 89 d7             	mov    %rdx,%rdi
  8016df:	48 89 c1             	mov    %rax,%rcx
  8016e2:	fd                   	std    
  8016e3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016e5:	fc                   	cld    
  8016e6:	eb 57                	jmp    80173f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ec:	83 e0 03             	and    $0x3,%eax
  8016ef:	48 85 c0             	test   %rax,%rax
  8016f2:	75 36                	jne    80172a <memmove+0xfc>
  8016f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f8:	83 e0 03             	and    $0x3,%eax
  8016fb:	48 85 c0             	test   %rax,%rax
  8016fe:	75 2a                	jne    80172a <memmove+0xfc>
  801700:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801704:	83 e0 03             	and    $0x3,%eax
  801707:	48 85 c0             	test   %rax,%rax
  80170a:	75 1e                	jne    80172a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80170c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801710:	48 c1 e8 02          	shr    $0x2,%rax
  801714:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801717:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80171f:	48 89 c7             	mov    %rax,%rdi
  801722:	48 89 d6             	mov    %rdx,%rsi
  801725:	fc                   	cld    
  801726:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801728:	eb 15                	jmp    80173f <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80172a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801732:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801736:	48 89 c7             	mov    %rax,%rdi
  801739:	48 89 d6             	mov    %rdx,%rsi
  80173c:	fc                   	cld    
  80173d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80173f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801743:	c9                   	leaveq 
  801744:	c3                   	retq   

0000000000801745 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801745:	55                   	push   %rbp
  801746:	48 89 e5             	mov    %rsp,%rbp
  801749:	48 83 ec 18          	sub    $0x18,%rsp
  80174d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801751:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801755:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801759:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80175d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801761:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801765:	48 89 ce             	mov    %rcx,%rsi
  801768:	48 89 c7             	mov    %rax,%rdi
  80176b:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  801772:	00 00 00 
  801775:	ff d0                	callq  *%rax
}
  801777:	c9                   	leaveq 
  801778:	c3                   	retq   

0000000000801779 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801779:	55                   	push   %rbp
  80177a:	48 89 e5             	mov    %rsp,%rbp
  80177d:	48 83 ec 28          	sub    $0x28,%rsp
  801781:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801785:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801789:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80178d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801791:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801795:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801799:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80179d:	eb 36                	jmp    8017d5 <memcmp+0x5c>
		if (*s1 != *s2)
  80179f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a3:	0f b6 10             	movzbl (%rax),%edx
  8017a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017aa:	0f b6 00             	movzbl (%rax),%eax
  8017ad:	38 c2                	cmp    %al,%dl
  8017af:	74 1a                	je     8017cb <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8017b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b5:	0f b6 00             	movzbl (%rax),%eax
  8017b8:	0f b6 d0             	movzbl %al,%edx
  8017bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017bf:	0f b6 00             	movzbl (%rax),%eax
  8017c2:	0f b6 c0             	movzbl %al,%eax
  8017c5:	29 c2                	sub    %eax,%edx
  8017c7:	89 d0                	mov    %edx,%eax
  8017c9:	eb 20                	jmp    8017eb <memcmp+0x72>
		s1++, s2++;
  8017cb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017d0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017e1:	48 85 c0             	test   %rax,%rax
  8017e4:	75 b9                	jne    80179f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017eb:	c9                   	leaveq 
  8017ec:	c3                   	retq   

00000000008017ed <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017ed:	55                   	push   %rbp
  8017ee:	48 89 e5             	mov    %rsp,%rbp
  8017f1:	48 83 ec 28          	sub    $0x28,%rsp
  8017f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017f9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801800:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801804:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801808:	48 01 d0             	add    %rdx,%rax
  80180b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80180f:	eb 19                	jmp    80182a <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801815:	0f b6 00             	movzbl (%rax),%eax
  801818:	0f b6 d0             	movzbl %al,%edx
  80181b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80181e:	0f b6 c0             	movzbl %al,%eax
  801821:	39 c2                	cmp    %eax,%edx
  801823:	74 11                	je     801836 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801825:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80182a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80182e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801832:	72 dd                	jb     801811 <memfind+0x24>
  801834:	eb 01                	jmp    801837 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801836:	90                   	nop
	return (void *) s;
  801837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80183b:	c9                   	leaveq 
  80183c:	c3                   	retq   

000000000080183d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80183d:	55                   	push   %rbp
  80183e:	48 89 e5             	mov    %rsp,%rbp
  801841:	48 83 ec 38          	sub    $0x38,%rsp
  801845:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801849:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80184d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801850:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801857:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80185e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80185f:	eb 05                	jmp    801866 <strtol+0x29>
		s++;
  801861:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801866:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186a:	0f b6 00             	movzbl (%rax),%eax
  80186d:	3c 20                	cmp    $0x20,%al
  80186f:	74 f0                	je     801861 <strtol+0x24>
  801871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801875:	0f b6 00             	movzbl (%rax),%eax
  801878:	3c 09                	cmp    $0x9,%al
  80187a:	74 e5                	je     801861 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80187c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801880:	0f b6 00             	movzbl (%rax),%eax
  801883:	3c 2b                	cmp    $0x2b,%al
  801885:	75 07                	jne    80188e <strtol+0x51>
		s++;
  801887:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80188c:	eb 17                	jmp    8018a5 <strtol+0x68>
	else if (*s == '-')
  80188e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801892:	0f b6 00             	movzbl (%rax),%eax
  801895:	3c 2d                	cmp    $0x2d,%al
  801897:	75 0c                	jne    8018a5 <strtol+0x68>
		s++, neg = 1;
  801899:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80189e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018a9:	74 06                	je     8018b1 <strtol+0x74>
  8018ab:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8018af:	75 28                	jne    8018d9 <strtol+0x9c>
  8018b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b5:	0f b6 00             	movzbl (%rax),%eax
  8018b8:	3c 30                	cmp    $0x30,%al
  8018ba:	75 1d                	jne    8018d9 <strtol+0x9c>
  8018bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c0:	48 83 c0 01          	add    $0x1,%rax
  8018c4:	0f b6 00             	movzbl (%rax),%eax
  8018c7:	3c 78                	cmp    $0x78,%al
  8018c9:	75 0e                	jne    8018d9 <strtol+0x9c>
		s += 2, base = 16;
  8018cb:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018d0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018d7:	eb 2c                	jmp    801905 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018dd:	75 19                	jne    8018f8 <strtol+0xbb>
  8018df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e3:	0f b6 00             	movzbl (%rax),%eax
  8018e6:	3c 30                	cmp    $0x30,%al
  8018e8:	75 0e                	jne    8018f8 <strtol+0xbb>
		s++, base = 8;
  8018ea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018ef:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018f6:	eb 0d                	jmp    801905 <strtol+0xc8>
	else if (base == 0)
  8018f8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018fc:	75 07                	jne    801905 <strtol+0xc8>
		base = 10;
  8018fe:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801909:	0f b6 00             	movzbl (%rax),%eax
  80190c:	3c 2f                	cmp    $0x2f,%al
  80190e:	7e 1d                	jle    80192d <strtol+0xf0>
  801910:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801914:	0f b6 00             	movzbl (%rax),%eax
  801917:	3c 39                	cmp    $0x39,%al
  801919:	7f 12                	jg     80192d <strtol+0xf0>
			dig = *s - '0';
  80191b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191f:	0f b6 00             	movzbl (%rax),%eax
  801922:	0f be c0             	movsbl %al,%eax
  801925:	83 e8 30             	sub    $0x30,%eax
  801928:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80192b:	eb 4e                	jmp    80197b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80192d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801931:	0f b6 00             	movzbl (%rax),%eax
  801934:	3c 60                	cmp    $0x60,%al
  801936:	7e 1d                	jle    801955 <strtol+0x118>
  801938:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193c:	0f b6 00             	movzbl (%rax),%eax
  80193f:	3c 7a                	cmp    $0x7a,%al
  801941:	7f 12                	jg     801955 <strtol+0x118>
			dig = *s - 'a' + 10;
  801943:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801947:	0f b6 00             	movzbl (%rax),%eax
  80194a:	0f be c0             	movsbl %al,%eax
  80194d:	83 e8 57             	sub    $0x57,%eax
  801950:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801953:	eb 26                	jmp    80197b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801955:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801959:	0f b6 00             	movzbl (%rax),%eax
  80195c:	3c 40                	cmp    $0x40,%al
  80195e:	7e 47                	jle    8019a7 <strtol+0x16a>
  801960:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801964:	0f b6 00             	movzbl (%rax),%eax
  801967:	3c 5a                	cmp    $0x5a,%al
  801969:	7f 3c                	jg     8019a7 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80196b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196f:	0f b6 00             	movzbl (%rax),%eax
  801972:	0f be c0             	movsbl %al,%eax
  801975:	83 e8 37             	sub    $0x37,%eax
  801978:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80197b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80197e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801981:	7d 23                	jge    8019a6 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801983:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801988:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80198b:	48 98                	cltq   
  80198d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801992:	48 89 c2             	mov    %rax,%rdx
  801995:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801998:	48 98                	cltq   
  80199a:	48 01 d0             	add    %rdx,%rax
  80199d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8019a1:	e9 5f ff ff ff       	jmpq   801905 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019a6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8019a7:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8019ac:	74 0b                	je     8019b9 <strtol+0x17c>
		*endptr = (char *) s;
  8019ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019b2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019b6:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019bd:	74 09                	je     8019c8 <strtol+0x18b>
  8019bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019c3:	48 f7 d8             	neg    %rax
  8019c6:	eb 04                	jmp    8019cc <strtol+0x18f>
  8019c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019cc:	c9                   	leaveq 
  8019cd:	c3                   	retq   

00000000008019ce <strstr>:

char * strstr(const char *in, const char *str)
{
  8019ce:	55                   	push   %rbp
  8019cf:	48 89 e5             	mov    %rsp,%rbp
  8019d2:	48 83 ec 30          	sub    $0x30,%rsp
  8019d6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019da:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019e2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019e6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019ea:	0f b6 00             	movzbl (%rax),%eax
  8019ed:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019f0:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019f4:	75 06                	jne    8019fc <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fa:	eb 6b                	jmp    801a67 <strstr+0x99>

	len = strlen(str);
  8019fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a00:	48 89 c7             	mov    %rax,%rdi
  801a03:	48 b8 9d 12 80 00 00 	movabs $0x80129d,%rax
  801a0a:	00 00 00 
  801a0d:	ff d0                	callq  *%rax
  801a0f:	48 98                	cltq   
  801a11:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801a15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a19:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a1d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a21:	0f b6 00             	movzbl (%rax),%eax
  801a24:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a27:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a2b:	75 07                	jne    801a34 <strstr+0x66>
				return (char *) 0;
  801a2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a32:	eb 33                	jmp    801a67 <strstr+0x99>
		} while (sc != c);
  801a34:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a38:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a3b:	75 d8                	jne    801a15 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a41:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a49:	48 89 ce             	mov    %rcx,%rsi
  801a4c:	48 89 c7             	mov    %rax,%rdi
  801a4f:	48 b8 be 14 80 00 00 	movabs $0x8014be,%rax
  801a56:	00 00 00 
  801a59:	ff d0                	callq  *%rax
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	75 b6                	jne    801a15 <strstr+0x47>

	return (char *) (in - 1);
  801a5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a63:	48 83 e8 01          	sub    $0x1,%rax
}
  801a67:	c9                   	leaveq 
  801a68:	c3                   	retq   
