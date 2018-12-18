
obj/user/faultwritekernel:     file format elf64-x86-64


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
  80003c:	e8 24 00 00 00       	callq  800065 <libmain>
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
	*(unsigned*)0x8004000000 = 0;
  800052:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  800059:	00 00 00 
  80005c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  800062:	90                   	nop
  800063:	c9                   	leaveq 
  800064:	c3                   	retq   

0000000000800065 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800065:	55                   	push   %rbp
  800066:	48 89 e5             	mov    %rsp,%rbp
  800069:	48 83 ec 10          	sub    $0x10,%rsp
  80006d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800070:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  800074:	48 b8 66 02 80 00 00 	movabs $0x800266,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	25 ff 03 00 00       	and    $0x3ff,%eax
  800085:	48 63 d0             	movslq %eax,%rdx
  800088:	48 89 d0             	mov    %rdx,%rax
  80008b:	48 c1 e0 03          	shl    $0x3,%rax
  80008f:	48 01 d0             	add    %rdx,%rax
  800092:	48 c1 e0 05          	shl    $0x5,%rax
  800096:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80009d:	00 00 00 
  8000a0:	48 01 c2             	add    %rax,%rdx
  8000a3:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000aa:	00 00 00 
  8000ad:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b4:	7e 14                	jle    8000ca <libmain+0x65>
		binaryname = argv[0];
  8000b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000ba:	48 8b 10             	mov    (%rax),%rdx
  8000bd:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000c4:	00 00 00 
  8000c7:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d1:	48 89 d6             	mov    %rdx,%rsi
  8000d4:	89 c7                	mov    %eax,%edi
  8000d6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000dd:	00 00 00 
  8000e0:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000e2:	48 b8 f1 00 80 00 00 	movabs $0x8000f1,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	callq  *%rax
}
  8000ee:	90                   	nop
  8000ef:	c9                   	leaveq 
  8000f0:	c3                   	retq   

00000000008000f1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f1:	55                   	push   %rbp
  8000f2:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8000fa:	48 b8 20 02 80 00 00 	movabs $0x800220,%rax
  800101:	00 00 00 
  800104:	ff d0                	callq  *%rax
}
  800106:	90                   	nop
  800107:	5d                   	pop    %rbp
  800108:	c3                   	retq   

0000000000800109 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800109:	55                   	push   %rbp
  80010a:	48 89 e5             	mov    %rsp,%rbp
  80010d:	53                   	push   %rbx
  80010e:	48 83 ec 48          	sub    $0x48,%rsp
  800112:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800115:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800118:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80011c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800120:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800124:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800128:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80012b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80012f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800133:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800137:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80013b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80013f:	4c 89 c3             	mov    %r8,%rbx
  800142:	cd 30                	int    $0x30
  800144:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800148:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80014c:	74 3e                	je     80018c <syscall+0x83>
  80014e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800153:	7e 37                	jle    80018c <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800155:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800159:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80015c:	49 89 d0             	mov    %rdx,%r8
  80015f:	89 c1                	mov    %eax,%ecx
  800161:	48 ba 4a 1a 80 00 00 	movabs $0x801a4a,%rdx
  800168:	00 00 00 
  80016b:	be 23 00 00 00       	mov    $0x23,%esi
  800170:	48 bf 67 1a 80 00 00 	movabs $0x801a67,%rdi
  800177:	00 00 00 
  80017a:	b8 00 00 00 00       	mov    $0x0,%eax
  80017f:	49 b9 13 05 80 00 00 	movabs $0x800513,%r9
  800186:	00 00 00 
  800189:	41 ff d1             	callq  *%r9

	return ret;
  80018c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800190:	48 83 c4 48          	add    $0x48,%rsp
  800194:	5b                   	pop    %rbx
  800195:	5d                   	pop    %rbp
  800196:	c3                   	retq   

0000000000800197 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800197:	55                   	push   %rbp
  800198:	48 89 e5             	mov    %rsp,%rbp
  80019b:	48 83 ec 10          	sub    $0x10,%rsp
  80019f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001af:	48 83 ec 08          	sub    $0x8,%rsp
  8001b3:	6a 00                	pushq  $0x0
  8001b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001c1:	48 89 d1             	mov    %rdx,%rcx
  8001c4:	48 89 c2             	mov    %rax,%rdx
  8001c7:	be 00 00 00 00       	mov    $0x0,%esi
  8001cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8001d1:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  8001d8:	00 00 00 
  8001db:	ff d0                	callq  *%rax
  8001dd:	48 83 c4 10          	add    $0x10,%rsp
}
  8001e1:	90                   	nop
  8001e2:	c9                   	leaveq 
  8001e3:	c3                   	retq   

00000000008001e4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001e4:	55                   	push   %rbp
  8001e5:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001e8:	48 83 ec 08          	sub    $0x8,%rsp
  8001ec:	6a 00                	pushq  $0x0
  8001ee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001f4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800204:	be 00 00 00 00       	mov    $0x0,%esi
  800209:	bf 01 00 00 00       	mov    $0x1,%edi
  80020e:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  800215:	00 00 00 
  800218:	ff d0                	callq  *%rax
  80021a:	48 83 c4 10          	add    $0x10,%rsp
}
  80021e:	c9                   	leaveq 
  80021f:	c3                   	retq   

0000000000800220 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800220:	55                   	push   %rbp
  800221:	48 89 e5             	mov    %rsp,%rbp
  800224:	48 83 ec 10          	sub    $0x10,%rsp
  800228:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80022b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80022e:	48 98                	cltq   
  800230:	48 83 ec 08          	sub    $0x8,%rsp
  800234:	6a 00                	pushq  $0x0
  800236:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80023c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800242:	b9 00 00 00 00       	mov    $0x0,%ecx
  800247:	48 89 c2             	mov    %rax,%rdx
  80024a:	be 01 00 00 00       	mov    $0x1,%esi
  80024f:	bf 03 00 00 00       	mov    $0x3,%edi
  800254:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  80025b:	00 00 00 
  80025e:	ff d0                	callq  *%rax
  800260:	48 83 c4 10          	add    $0x10,%rsp
}
  800264:	c9                   	leaveq 
  800265:	c3                   	retq   

0000000000800266 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800266:	55                   	push   %rbp
  800267:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80026a:	48 83 ec 08          	sub    $0x8,%rsp
  80026e:	6a 00                	pushq  $0x0
  800270:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800276:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80027c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800281:	ba 00 00 00 00       	mov    $0x0,%edx
  800286:	be 00 00 00 00       	mov    $0x0,%esi
  80028b:	bf 02 00 00 00       	mov    $0x2,%edi
  800290:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  800297:	00 00 00 
  80029a:	ff d0                	callq  *%rax
  80029c:	48 83 c4 10          	add    $0x10,%rsp
}
  8002a0:	c9                   	leaveq 
  8002a1:	c3                   	retq   

00000000008002a2 <sys_yield>:

void
sys_yield(void)
{
  8002a2:	55                   	push   %rbp
  8002a3:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002a6:	48 83 ec 08          	sub    $0x8,%rsp
  8002aa:	6a 00                	pushq  $0x0
  8002ac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c2:	be 00 00 00 00       	mov    $0x0,%esi
  8002c7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002cc:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  8002d3:	00 00 00 
  8002d6:	ff d0                	callq  *%rax
  8002d8:	48 83 c4 10          	add    $0x10,%rsp
}
  8002dc:	90                   	nop
  8002dd:	c9                   	leaveq 
  8002de:	c3                   	retq   

00000000008002df <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002df:	55                   	push   %rbp
  8002e0:	48 89 e5             	mov    %rsp,%rbp
  8002e3:	48 83 ec 10          	sub    $0x10,%rsp
  8002e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002ee:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002f4:	48 63 c8             	movslq %eax,%rcx
  8002f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002fe:	48 98                	cltq   
  800300:	48 83 ec 08          	sub    $0x8,%rsp
  800304:	6a 00                	pushq  $0x0
  800306:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80030c:	49 89 c8             	mov    %rcx,%r8
  80030f:	48 89 d1             	mov    %rdx,%rcx
  800312:	48 89 c2             	mov    %rax,%rdx
  800315:	be 01 00 00 00       	mov    $0x1,%esi
  80031a:	bf 04 00 00 00       	mov    $0x4,%edi
  80031f:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  800326:	00 00 00 
  800329:	ff d0                	callq  *%rax
  80032b:	48 83 c4 10          	add    $0x10,%rsp
}
  80032f:	c9                   	leaveq 
  800330:	c3                   	retq   

0000000000800331 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800331:	55                   	push   %rbp
  800332:	48 89 e5             	mov    %rsp,%rbp
  800335:	48 83 ec 20          	sub    $0x20,%rsp
  800339:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80033c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800340:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800343:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800347:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80034b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80034e:	48 63 c8             	movslq %eax,%rcx
  800351:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800355:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800358:	48 63 f0             	movslq %eax,%rsi
  80035b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80035f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800362:	48 98                	cltq   
  800364:	48 83 ec 08          	sub    $0x8,%rsp
  800368:	51                   	push   %rcx
  800369:	49 89 f9             	mov    %rdi,%r9
  80036c:	49 89 f0             	mov    %rsi,%r8
  80036f:	48 89 d1             	mov    %rdx,%rcx
  800372:	48 89 c2             	mov    %rax,%rdx
  800375:	be 01 00 00 00       	mov    $0x1,%esi
  80037a:	bf 05 00 00 00       	mov    $0x5,%edi
  80037f:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  800386:	00 00 00 
  800389:	ff d0                	callq  *%rax
  80038b:	48 83 c4 10          	add    $0x10,%rsp
}
  80038f:	c9                   	leaveq 
  800390:	c3                   	retq   

0000000000800391 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800391:	55                   	push   %rbp
  800392:	48 89 e5             	mov    %rsp,%rbp
  800395:	48 83 ec 10          	sub    $0x10,%rsp
  800399:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80039c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a7:	48 98                	cltq   
  8003a9:	48 83 ec 08          	sub    $0x8,%rsp
  8003ad:	6a 00                	pushq  $0x0
  8003af:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003bb:	48 89 d1             	mov    %rdx,%rcx
  8003be:	48 89 c2             	mov    %rax,%rdx
  8003c1:	be 01 00 00 00       	mov    $0x1,%esi
  8003c6:	bf 06 00 00 00       	mov    $0x6,%edi
  8003cb:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  8003d2:	00 00 00 
  8003d5:	ff d0                	callq  *%rax
  8003d7:	48 83 c4 10          	add    $0x10,%rsp
}
  8003db:	c9                   	leaveq 
  8003dc:	c3                   	retq   

00000000008003dd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003dd:	55                   	push   %rbp
  8003de:	48 89 e5             	mov    %rsp,%rbp
  8003e1:	48 83 ec 10          	sub    $0x10,%rsp
  8003e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003e8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ee:	48 63 d0             	movslq %eax,%rdx
  8003f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003f4:	48 98                	cltq   
  8003f6:	48 83 ec 08          	sub    $0x8,%rsp
  8003fa:	6a 00                	pushq  $0x0
  8003fc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800402:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800408:	48 89 d1             	mov    %rdx,%rcx
  80040b:	48 89 c2             	mov    %rax,%rdx
  80040e:	be 01 00 00 00       	mov    $0x1,%esi
  800413:	bf 08 00 00 00       	mov    $0x8,%edi
  800418:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  80041f:	00 00 00 
  800422:	ff d0                	callq  *%rax
  800424:	48 83 c4 10          	add    $0x10,%rsp
}
  800428:	c9                   	leaveq 
  800429:	c3                   	retq   

000000000080042a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80042a:	55                   	push   %rbp
  80042b:	48 89 e5             	mov    %rsp,%rbp
  80042e:	48 83 ec 10          	sub    $0x10,%rsp
  800432:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800435:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800439:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80043d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800440:	48 98                	cltq   
  800442:	48 83 ec 08          	sub    $0x8,%rsp
  800446:	6a 00                	pushq  $0x0
  800448:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80044e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800454:	48 89 d1             	mov    %rdx,%rcx
  800457:	48 89 c2             	mov    %rax,%rdx
  80045a:	be 01 00 00 00       	mov    $0x1,%esi
  80045f:	bf 09 00 00 00       	mov    $0x9,%edi
  800464:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  80046b:	00 00 00 
  80046e:	ff d0                	callq  *%rax
  800470:	48 83 c4 10          	add    $0x10,%rsp
}
  800474:	c9                   	leaveq 
  800475:	c3                   	retq   

0000000000800476 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800476:	55                   	push   %rbp
  800477:	48 89 e5             	mov    %rsp,%rbp
  80047a:	48 83 ec 20          	sub    $0x20,%rsp
  80047e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800481:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800485:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800489:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80048c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80048f:	48 63 f0             	movslq %eax,%rsi
  800492:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800496:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800499:	48 98                	cltq   
  80049b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80049f:	48 83 ec 08          	sub    $0x8,%rsp
  8004a3:	6a 00                	pushq  $0x0
  8004a5:	49 89 f1             	mov    %rsi,%r9
  8004a8:	49 89 c8             	mov    %rcx,%r8
  8004ab:	48 89 d1             	mov    %rdx,%rcx
  8004ae:	48 89 c2             	mov    %rax,%rdx
  8004b1:	be 00 00 00 00       	mov    $0x0,%esi
  8004b6:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004bb:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  8004c2:	00 00 00 
  8004c5:	ff d0                	callq  *%rax
  8004c7:	48 83 c4 10          	add    $0x10,%rsp
}
  8004cb:	c9                   	leaveq 
  8004cc:	c3                   	retq   

00000000008004cd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004cd:	55                   	push   %rbp
  8004ce:	48 89 e5             	mov    %rsp,%rbp
  8004d1:	48 83 ec 10          	sub    $0x10,%rsp
  8004d5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004dd:	48 83 ec 08          	sub    $0x8,%rsp
  8004e1:	6a 00                	pushq  $0x0
  8004e3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004f4:	48 89 c2             	mov    %rax,%rdx
  8004f7:	be 01 00 00 00       	mov    $0x1,%esi
  8004fc:	bf 0c 00 00 00       	mov    $0xc,%edi
  800501:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  800508:	00 00 00 
  80050b:	ff d0                	callq  *%rax
  80050d:	48 83 c4 10          	add    $0x10,%rsp
}
  800511:	c9                   	leaveq 
  800512:	c3                   	retq   

0000000000800513 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800513:	55                   	push   %rbp
  800514:	48 89 e5             	mov    %rsp,%rbp
  800517:	53                   	push   %rbx
  800518:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80051f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800526:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80052c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800533:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80053a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800541:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800548:	84 c0                	test   %al,%al
  80054a:	74 23                	je     80056f <_panic+0x5c>
  80054c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800553:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800557:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80055b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80055f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800563:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800567:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80056b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80056f:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800576:	00 00 00 
  800579:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800580:	00 00 00 
  800583:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800587:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80058e:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800595:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80059c:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8005a3:	00 00 00 
  8005a6:	48 8b 18             	mov    (%rax),%rbx
  8005a9:	48 b8 66 02 80 00 00 	movabs $0x800266,%rax
  8005b0:	00 00 00 
  8005b3:	ff d0                	callq  *%rax
  8005b5:	89 c6                	mov    %eax,%esi
  8005b7:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8005bd:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8005c4:	41 89 d0             	mov    %edx,%r8d
  8005c7:	48 89 c1             	mov    %rax,%rcx
  8005ca:	48 89 da             	mov    %rbx,%rdx
  8005cd:	48 bf 78 1a 80 00 00 	movabs $0x801a78,%rdi
  8005d4:	00 00 00 
  8005d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005dc:	49 b9 4d 07 80 00 00 	movabs $0x80074d,%r9
  8005e3:	00 00 00 
  8005e6:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005e9:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005f0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005f7:	48 89 d6             	mov    %rdx,%rsi
  8005fa:	48 89 c7             	mov    %rax,%rdi
  8005fd:	48 b8 a1 06 80 00 00 	movabs $0x8006a1,%rax
  800604:	00 00 00 
  800607:	ff d0                	callq  *%rax
	cprintf("\n");
  800609:	48 bf 9b 1a 80 00 00 	movabs $0x801a9b,%rdi
  800610:	00 00 00 
  800613:	b8 00 00 00 00       	mov    $0x0,%eax
  800618:	48 ba 4d 07 80 00 00 	movabs $0x80074d,%rdx
  80061f:	00 00 00 
  800622:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800624:	cc                   	int3   
  800625:	eb fd                	jmp    800624 <_panic+0x111>

0000000000800627 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800627:	55                   	push   %rbp
  800628:	48 89 e5             	mov    %rsp,%rbp
  80062b:	48 83 ec 10          	sub    $0x10,%rsp
  80062f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800632:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800636:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80063a:	8b 00                	mov    (%rax),%eax
  80063c:	8d 48 01             	lea    0x1(%rax),%ecx
  80063f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800643:	89 0a                	mov    %ecx,(%rdx)
  800645:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800648:	89 d1                	mov    %edx,%ecx
  80064a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80064e:	48 98                	cltq   
  800650:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800654:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800658:	8b 00                	mov    (%rax),%eax
  80065a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80065f:	75 2c                	jne    80068d <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800661:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800665:	8b 00                	mov    (%rax),%eax
  800667:	48 98                	cltq   
  800669:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80066d:	48 83 c2 08          	add    $0x8,%rdx
  800671:	48 89 c6             	mov    %rax,%rsi
  800674:	48 89 d7             	mov    %rdx,%rdi
  800677:	48 b8 97 01 80 00 00 	movabs $0x800197,%rax
  80067e:	00 00 00 
  800681:	ff d0                	callq  *%rax
        b->idx = 0;
  800683:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800687:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80068d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800691:	8b 40 04             	mov    0x4(%rax),%eax
  800694:	8d 50 01             	lea    0x1(%rax),%edx
  800697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069b:	89 50 04             	mov    %edx,0x4(%rax)
}
  80069e:	90                   	nop
  80069f:	c9                   	leaveq 
  8006a0:	c3                   	retq   

00000000008006a1 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8006a1:	55                   	push   %rbp
  8006a2:	48 89 e5             	mov    %rsp,%rbp
  8006a5:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006ac:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006b3:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006ba:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006c1:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006c8:	48 8b 0a             	mov    (%rdx),%rcx
  8006cb:	48 89 08             	mov    %rcx,(%rax)
  8006ce:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006d6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006da:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006de:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006e5:	00 00 00 
    b.cnt = 0;
  8006e8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006ef:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006f2:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006f9:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800700:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800707:	48 89 c6             	mov    %rax,%rsi
  80070a:	48 bf 27 06 80 00 00 	movabs $0x800627,%rdi
  800711:	00 00 00 
  800714:	48 b8 eb 0a 80 00 00 	movabs $0x800aeb,%rax
  80071b:	00 00 00 
  80071e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800720:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800726:	48 98                	cltq   
  800728:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80072f:	48 83 c2 08          	add    $0x8,%rdx
  800733:	48 89 c6             	mov    %rax,%rsi
  800736:	48 89 d7             	mov    %rdx,%rdi
  800739:	48 b8 97 01 80 00 00 	movabs $0x800197,%rax
  800740:	00 00 00 
  800743:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800745:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80074b:	c9                   	leaveq 
  80074c:	c3                   	retq   

000000000080074d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80074d:	55                   	push   %rbp
  80074e:	48 89 e5             	mov    %rsp,%rbp
  800751:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800758:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80075f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800766:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80076d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800774:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80077b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800782:	84 c0                	test   %al,%al
  800784:	74 20                	je     8007a6 <cprintf+0x59>
  800786:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80078a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80078e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800792:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800796:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80079a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80079e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007a2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007a6:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007ad:	00 00 00 
  8007b0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007b7:	00 00 00 
  8007ba:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007be:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007c5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007cc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007d3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007da:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007e1:	48 8b 0a             	mov    (%rdx),%rcx
  8007e4:	48 89 08             	mov    %rcx,(%rax)
  8007e7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007eb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007ef:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007f3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007f7:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007fe:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800805:	48 89 d6             	mov    %rdx,%rsi
  800808:	48 89 c7             	mov    %rax,%rdi
  80080b:	48 b8 a1 06 80 00 00 	movabs $0x8006a1,%rax
  800812:	00 00 00 
  800815:	ff d0                	callq  *%rax
  800817:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80081d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800823:	c9                   	leaveq 
  800824:	c3                   	retq   

0000000000800825 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800825:	55                   	push   %rbp
  800826:	48 89 e5             	mov    %rsp,%rbp
  800829:	48 83 ec 30          	sub    $0x30,%rsp
  80082d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800831:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800835:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800839:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80083c:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800840:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800844:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800847:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80084b:	77 54                	ja     8008a1 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80084d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800850:	8d 78 ff             	lea    -0x1(%rax),%edi
  800853:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085a:	ba 00 00 00 00       	mov    $0x0,%edx
  80085f:	48 f7 f6             	div    %rsi
  800862:	49 89 c2             	mov    %rax,%r10
  800865:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800868:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80086b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80086f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800873:	41 89 c9             	mov    %ecx,%r9d
  800876:	41 89 f8             	mov    %edi,%r8d
  800879:	89 d1                	mov    %edx,%ecx
  80087b:	4c 89 d2             	mov    %r10,%rdx
  80087e:	48 89 c7             	mov    %rax,%rdi
  800881:	48 b8 25 08 80 00 00 	movabs $0x800825,%rax
  800888:	00 00 00 
  80088b:	ff d0                	callq  *%rax
  80088d:	eb 1c                	jmp    8008ab <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80088f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800893:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800896:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80089a:	48 89 ce             	mov    %rcx,%rsi
  80089d:	89 d7                	mov    %edx,%edi
  80089f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a1:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8008a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8008a9:	7f e4                	jg     80088f <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008ab:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8008ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b7:	48 f7 f1             	div    %rcx
  8008ba:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  8008c1:	00 00 00 
  8008c4:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8008c8:	0f be d0             	movsbl %al,%edx
  8008cb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8008cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008d3:	48 89 ce             	mov    %rcx,%rsi
  8008d6:	89 d7                	mov    %edx,%edi
  8008d8:	ff d0                	callq  *%rax
}
  8008da:	90                   	nop
  8008db:	c9                   	leaveq 
  8008dc:	c3                   	retq   

00000000008008dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008dd:	55                   	push   %rbp
  8008de:	48 89 e5             	mov    %rsp,%rbp
  8008e1:	48 83 ec 20          	sub    $0x20,%rsp
  8008e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008e9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008ec:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008f0:	7e 4f                	jle    800941 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8008f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f6:	8b 00                	mov    (%rax),%eax
  8008f8:	83 f8 30             	cmp    $0x30,%eax
  8008fb:	73 24                	jae    800921 <getuint+0x44>
  8008fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800901:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800905:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800909:	8b 00                	mov    (%rax),%eax
  80090b:	89 c0                	mov    %eax,%eax
  80090d:	48 01 d0             	add    %rdx,%rax
  800910:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800914:	8b 12                	mov    (%rdx),%edx
  800916:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800919:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091d:	89 0a                	mov    %ecx,(%rdx)
  80091f:	eb 14                	jmp    800935 <getuint+0x58>
  800921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800925:	48 8b 40 08          	mov    0x8(%rax),%rax
  800929:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80092d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800931:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800935:	48 8b 00             	mov    (%rax),%rax
  800938:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80093c:	e9 9d 00 00 00       	jmpq   8009de <getuint+0x101>
	else if (lflag)
  800941:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800945:	74 4c                	je     800993 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800947:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094b:	8b 00                	mov    (%rax),%eax
  80094d:	83 f8 30             	cmp    $0x30,%eax
  800950:	73 24                	jae    800976 <getuint+0x99>
  800952:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800956:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80095a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095e:	8b 00                	mov    (%rax),%eax
  800960:	89 c0                	mov    %eax,%eax
  800962:	48 01 d0             	add    %rdx,%rax
  800965:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800969:	8b 12                	mov    (%rdx),%edx
  80096b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80096e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800972:	89 0a                	mov    %ecx,(%rdx)
  800974:	eb 14                	jmp    80098a <getuint+0xad>
  800976:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80097e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800982:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800986:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80098a:	48 8b 00             	mov    (%rax),%rax
  80098d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800991:	eb 4b                	jmp    8009de <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800993:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800997:	8b 00                	mov    (%rax),%eax
  800999:	83 f8 30             	cmp    $0x30,%eax
  80099c:	73 24                	jae    8009c2 <getuint+0xe5>
  80099e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009aa:	8b 00                	mov    (%rax),%eax
  8009ac:	89 c0                	mov    %eax,%eax
  8009ae:	48 01 d0             	add    %rdx,%rax
  8009b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b5:	8b 12                	mov    (%rdx),%edx
  8009b7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009be:	89 0a                	mov    %ecx,(%rdx)
  8009c0:	eb 14                	jmp    8009d6 <getuint+0xf9>
  8009c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009ca:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009d6:	8b 00                	mov    (%rax),%eax
  8009d8:	89 c0                	mov    %eax,%eax
  8009da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009e2:	c9                   	leaveq 
  8009e3:	c3                   	retq   

00000000008009e4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009e4:	55                   	push   %rbp
  8009e5:	48 89 e5             	mov    %rsp,%rbp
  8009e8:	48 83 ec 20          	sub    $0x20,%rsp
  8009ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009f0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009f3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009f7:	7e 4f                	jle    800a48 <getint+0x64>
		x=va_arg(*ap, long long);
  8009f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009fd:	8b 00                	mov    (%rax),%eax
  8009ff:	83 f8 30             	cmp    $0x30,%eax
  800a02:	73 24                	jae    800a28 <getint+0x44>
  800a04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a08:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a10:	8b 00                	mov    (%rax),%eax
  800a12:	89 c0                	mov    %eax,%eax
  800a14:	48 01 d0             	add    %rdx,%rax
  800a17:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1b:	8b 12                	mov    (%rdx),%edx
  800a1d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a24:	89 0a                	mov    %ecx,(%rdx)
  800a26:	eb 14                	jmp    800a3c <getint+0x58>
  800a28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a30:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a38:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a3c:	48 8b 00             	mov    (%rax),%rax
  800a3f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a43:	e9 9d 00 00 00       	jmpq   800ae5 <getint+0x101>
	else if (lflag)
  800a48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a4c:	74 4c                	je     800a9a <getint+0xb6>
		x=va_arg(*ap, long);
  800a4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a52:	8b 00                	mov    (%rax),%eax
  800a54:	83 f8 30             	cmp    $0x30,%eax
  800a57:	73 24                	jae    800a7d <getint+0x99>
  800a59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a65:	8b 00                	mov    (%rax),%eax
  800a67:	89 c0                	mov    %eax,%eax
  800a69:	48 01 d0             	add    %rdx,%rax
  800a6c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a70:	8b 12                	mov    (%rdx),%edx
  800a72:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a79:	89 0a                	mov    %ecx,(%rdx)
  800a7b:	eb 14                	jmp    800a91 <getint+0xad>
  800a7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a81:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a85:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a89:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a91:	48 8b 00             	mov    (%rax),%rax
  800a94:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a98:	eb 4b                	jmp    800ae5 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800a9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9e:	8b 00                	mov    (%rax),%eax
  800aa0:	83 f8 30             	cmp    $0x30,%eax
  800aa3:	73 24                	jae    800ac9 <getint+0xe5>
  800aa5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800aad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab1:	8b 00                	mov    (%rax),%eax
  800ab3:	89 c0                	mov    %eax,%eax
  800ab5:	48 01 d0             	add    %rdx,%rax
  800ab8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abc:	8b 12                	mov    (%rdx),%edx
  800abe:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ac1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac5:	89 0a                	mov    %ecx,(%rdx)
  800ac7:	eb 14                	jmp    800add <getint+0xf9>
  800ac9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acd:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ad1:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ad5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800add:	8b 00                	mov    (%rax),%eax
  800adf:	48 98                	cltq   
  800ae1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ae5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ae9:	c9                   	leaveq 
  800aea:	c3                   	retq   

0000000000800aeb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800aeb:	55                   	push   %rbp
  800aec:	48 89 e5             	mov    %rsp,%rbp
  800aef:	41 54                	push   %r12
  800af1:	53                   	push   %rbx
  800af2:	48 83 ec 60          	sub    $0x60,%rsp
  800af6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800afa:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800afe:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b02:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b06:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b0a:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b0e:	48 8b 0a             	mov    (%rdx),%rcx
  800b11:	48 89 08             	mov    %rcx,(%rax)
  800b14:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b18:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b1c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b20:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b24:	eb 17                	jmp    800b3d <vprintfmt+0x52>
			if (ch == '\0')
  800b26:	85 db                	test   %ebx,%ebx
  800b28:	0f 84 b9 04 00 00    	je     800fe7 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800b2e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b36:	48 89 d6             	mov    %rdx,%rsi
  800b39:	89 df                	mov    %ebx,%edi
  800b3b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b3d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b41:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b45:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b49:	0f b6 00             	movzbl (%rax),%eax
  800b4c:	0f b6 d8             	movzbl %al,%ebx
  800b4f:	83 fb 25             	cmp    $0x25,%ebx
  800b52:	75 d2                	jne    800b26 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b54:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b58:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b5f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b66:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b6d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b74:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b78:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b7c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b80:	0f b6 00             	movzbl (%rax),%eax
  800b83:	0f b6 d8             	movzbl %al,%ebx
  800b86:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b89:	83 f8 55             	cmp    $0x55,%eax
  800b8c:	0f 87 22 04 00 00    	ja     800fb4 <vprintfmt+0x4c9>
  800b92:	89 c0                	mov    %eax,%eax
  800b94:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b9b:	00 
  800b9c:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  800ba3:	00 00 00 
  800ba6:	48 01 d0             	add    %rdx,%rax
  800ba9:	48 8b 00             	mov    (%rax),%rax
  800bac:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bae:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bb2:	eb c0                	jmp    800b74 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bb4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bb8:	eb ba                	jmp    800b74 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bba:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bc1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bc4:	89 d0                	mov    %edx,%eax
  800bc6:	c1 e0 02             	shl    $0x2,%eax
  800bc9:	01 d0                	add    %edx,%eax
  800bcb:	01 c0                	add    %eax,%eax
  800bcd:	01 d8                	add    %ebx,%eax
  800bcf:	83 e8 30             	sub    $0x30,%eax
  800bd2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bd5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bd9:	0f b6 00             	movzbl (%rax),%eax
  800bdc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bdf:	83 fb 2f             	cmp    $0x2f,%ebx
  800be2:	7e 60                	jle    800c44 <vprintfmt+0x159>
  800be4:	83 fb 39             	cmp    $0x39,%ebx
  800be7:	7f 5b                	jg     800c44 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bee:	eb d1                	jmp    800bc1 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800bf0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf3:	83 f8 30             	cmp    $0x30,%eax
  800bf6:	73 17                	jae    800c0f <vprintfmt+0x124>
  800bf8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800bfc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bff:	89 d2                	mov    %edx,%edx
  800c01:	48 01 d0             	add    %rdx,%rax
  800c04:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c07:	83 c2 08             	add    $0x8,%edx
  800c0a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c0d:	eb 0c                	jmp    800c1b <vprintfmt+0x130>
  800c0f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c13:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c17:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c1b:	8b 00                	mov    (%rax),%eax
  800c1d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c20:	eb 23                	jmp    800c45 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800c22:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c26:	0f 89 48 ff ff ff    	jns    800b74 <vprintfmt+0x89>
				width = 0;
  800c2c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c33:	e9 3c ff ff ff       	jmpq   800b74 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c38:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c3f:	e9 30 ff ff ff       	jmpq   800b74 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c44:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c45:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c49:	0f 89 25 ff ff ff    	jns    800b74 <vprintfmt+0x89>
				width = precision, precision = -1;
  800c4f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c52:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c55:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c5c:	e9 13 ff ff ff       	jmpq   800b74 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c61:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c65:	e9 0a ff ff ff       	jmpq   800b74 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c6a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6d:	83 f8 30             	cmp    $0x30,%eax
  800c70:	73 17                	jae    800c89 <vprintfmt+0x19e>
  800c72:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c76:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c79:	89 d2                	mov    %edx,%edx
  800c7b:	48 01 d0             	add    %rdx,%rax
  800c7e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c81:	83 c2 08             	add    $0x8,%edx
  800c84:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c87:	eb 0c                	jmp    800c95 <vprintfmt+0x1aa>
  800c89:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c8d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c91:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c95:	8b 10                	mov    (%rax),%edx
  800c97:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9f:	48 89 ce             	mov    %rcx,%rsi
  800ca2:	89 d7                	mov    %edx,%edi
  800ca4:	ff d0                	callq  *%rax
			break;
  800ca6:	e9 37 03 00 00       	jmpq   800fe2 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cae:	83 f8 30             	cmp    $0x30,%eax
  800cb1:	73 17                	jae    800cca <vprintfmt+0x1df>
  800cb3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cb7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cba:	89 d2                	mov    %edx,%edx
  800cbc:	48 01 d0             	add    %rdx,%rax
  800cbf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc2:	83 c2 08             	add    $0x8,%edx
  800cc5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cc8:	eb 0c                	jmp    800cd6 <vprintfmt+0x1eb>
  800cca:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cce:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cd2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cd6:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cd8:	85 db                	test   %ebx,%ebx
  800cda:	79 02                	jns    800cde <vprintfmt+0x1f3>
				err = -err;
  800cdc:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cde:	83 fb 15             	cmp    $0x15,%ebx
  800ce1:	7f 16                	jg     800cf9 <vprintfmt+0x20e>
  800ce3:	48 b8 40 1b 80 00 00 	movabs $0x801b40,%rax
  800cea:	00 00 00 
  800ced:	48 63 d3             	movslq %ebx,%rdx
  800cf0:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cf4:	4d 85 e4             	test   %r12,%r12
  800cf7:	75 2e                	jne    800d27 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800cf9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cfd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d01:	89 d9                	mov    %ebx,%ecx
  800d03:	48 ba 01 1c 80 00 00 	movabs $0x801c01,%rdx
  800d0a:	00 00 00 
  800d0d:	48 89 c7             	mov    %rax,%rdi
  800d10:	b8 00 00 00 00       	mov    $0x0,%eax
  800d15:	49 b8 f1 0f 80 00 00 	movabs $0x800ff1,%r8
  800d1c:	00 00 00 
  800d1f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d22:	e9 bb 02 00 00       	jmpq   800fe2 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d27:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2f:	4c 89 e1             	mov    %r12,%rcx
  800d32:	48 ba 0a 1c 80 00 00 	movabs $0x801c0a,%rdx
  800d39:	00 00 00 
  800d3c:	48 89 c7             	mov    %rax,%rdi
  800d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d44:	49 b8 f1 0f 80 00 00 	movabs $0x800ff1,%r8
  800d4b:	00 00 00 
  800d4e:	41 ff d0             	callq  *%r8
			break;
  800d51:	e9 8c 02 00 00       	jmpq   800fe2 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d59:	83 f8 30             	cmp    $0x30,%eax
  800d5c:	73 17                	jae    800d75 <vprintfmt+0x28a>
  800d5e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d62:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d65:	89 d2                	mov    %edx,%edx
  800d67:	48 01 d0             	add    %rdx,%rax
  800d6a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d6d:	83 c2 08             	add    $0x8,%edx
  800d70:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d73:	eb 0c                	jmp    800d81 <vprintfmt+0x296>
  800d75:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d79:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d7d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d81:	4c 8b 20             	mov    (%rax),%r12
  800d84:	4d 85 e4             	test   %r12,%r12
  800d87:	75 0a                	jne    800d93 <vprintfmt+0x2a8>
				p = "(null)";
  800d89:	49 bc 0d 1c 80 00 00 	movabs $0x801c0d,%r12
  800d90:	00 00 00 
			if (width > 0 && padc != '-')
  800d93:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d97:	7e 78                	jle    800e11 <vprintfmt+0x326>
  800d99:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d9d:	74 72                	je     800e11 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d9f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800da2:	48 98                	cltq   
  800da4:	48 89 c6             	mov    %rax,%rsi
  800da7:	4c 89 e7             	mov    %r12,%rdi
  800daa:	48 b8 9f 12 80 00 00 	movabs $0x80129f,%rax
  800db1:	00 00 00 
  800db4:	ff d0                	callq  *%rax
  800db6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800db9:	eb 17                	jmp    800dd2 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800dbb:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800dbf:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dc3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc7:	48 89 ce             	mov    %rcx,%rsi
  800dca:	89 d7                	mov    %edx,%edi
  800dcc:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dce:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dd2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dd6:	7f e3                	jg     800dbb <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dd8:	eb 37                	jmp    800e11 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800dda:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800dde:	74 1e                	je     800dfe <vprintfmt+0x313>
  800de0:	83 fb 1f             	cmp    $0x1f,%ebx
  800de3:	7e 05                	jle    800dea <vprintfmt+0x2ff>
  800de5:	83 fb 7e             	cmp    $0x7e,%ebx
  800de8:	7e 14                	jle    800dfe <vprintfmt+0x313>
					putch('?', putdat);
  800dea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df2:	48 89 d6             	mov    %rdx,%rsi
  800df5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800dfa:	ff d0                	callq  *%rax
  800dfc:	eb 0f                	jmp    800e0d <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800dfe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e06:	48 89 d6             	mov    %rdx,%rsi
  800e09:	89 df                	mov    %ebx,%edi
  800e0b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e0d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e11:	4c 89 e0             	mov    %r12,%rax
  800e14:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e18:	0f b6 00             	movzbl (%rax),%eax
  800e1b:	0f be d8             	movsbl %al,%ebx
  800e1e:	85 db                	test   %ebx,%ebx
  800e20:	74 28                	je     800e4a <vprintfmt+0x35f>
  800e22:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e26:	78 b2                	js     800dda <vprintfmt+0x2ef>
  800e28:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e2c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e30:	79 a8                	jns    800dda <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e32:	eb 16                	jmp    800e4a <vprintfmt+0x35f>
				putch(' ', putdat);
  800e34:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e3c:	48 89 d6             	mov    %rdx,%rsi
  800e3f:	bf 20 00 00 00       	mov    $0x20,%edi
  800e44:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e46:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e4a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e4e:	7f e4                	jg     800e34 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800e50:	e9 8d 01 00 00       	jmpq   800fe2 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e55:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e59:	be 03 00 00 00       	mov    $0x3,%esi
  800e5e:	48 89 c7             	mov    %rax,%rdi
  800e61:	48 b8 e4 09 80 00 00 	movabs $0x8009e4,%rax
  800e68:	00 00 00 
  800e6b:	ff d0                	callq  *%rax
  800e6d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e75:	48 85 c0             	test   %rax,%rax
  800e78:	79 1d                	jns    800e97 <vprintfmt+0x3ac>
				putch('-', putdat);
  800e7a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e82:	48 89 d6             	mov    %rdx,%rsi
  800e85:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e8a:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e90:	48 f7 d8             	neg    %rax
  800e93:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e97:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e9e:	e9 d2 00 00 00       	jmpq   800f75 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ea3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ea7:	be 03 00 00 00       	mov    $0x3,%esi
  800eac:	48 89 c7             	mov    %rax,%rdi
  800eaf:	48 b8 dd 08 80 00 00 	movabs $0x8008dd,%rax
  800eb6:	00 00 00 
  800eb9:	ff d0                	callq  *%rax
  800ebb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ebf:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ec6:	e9 aa 00 00 00       	jmpq   800f75 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800ecb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ecf:	be 03 00 00 00       	mov    $0x3,%esi
  800ed4:	48 89 c7             	mov    %rax,%rdi
  800ed7:	48 b8 dd 08 80 00 00 	movabs $0x8008dd,%rax
  800ede:	00 00 00 
  800ee1:	ff d0                	callq  *%rax
  800ee3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ee7:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800eee:	e9 82 00 00 00       	jmpq   800f75 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800ef3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efb:	48 89 d6             	mov    %rdx,%rsi
  800efe:	bf 30 00 00 00       	mov    $0x30,%edi
  800f03:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0d:	48 89 d6             	mov    %rdx,%rsi
  800f10:	bf 78 00 00 00       	mov    $0x78,%edi
  800f15:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f1a:	83 f8 30             	cmp    $0x30,%eax
  800f1d:	73 17                	jae    800f36 <vprintfmt+0x44b>
  800f1f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f23:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f26:	89 d2                	mov    %edx,%edx
  800f28:	48 01 d0             	add    %rdx,%rax
  800f2b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f2e:	83 c2 08             	add    $0x8,%edx
  800f31:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f34:	eb 0c                	jmp    800f42 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800f36:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800f3a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800f3e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f42:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f45:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f49:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f50:	eb 23                	jmp    800f75 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f52:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f56:	be 03 00 00 00       	mov    $0x3,%esi
  800f5b:	48 89 c7             	mov    %rax,%rdi
  800f5e:	48 b8 dd 08 80 00 00 	movabs $0x8008dd,%rax
  800f65:	00 00 00 
  800f68:	ff d0                	callq  *%rax
  800f6a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f6e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f75:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f7a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f7d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f84:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f8c:	45 89 c1             	mov    %r8d,%r9d
  800f8f:	41 89 f8             	mov    %edi,%r8d
  800f92:	48 89 c7             	mov    %rax,%rdi
  800f95:	48 b8 25 08 80 00 00 	movabs $0x800825,%rax
  800f9c:	00 00 00 
  800f9f:	ff d0                	callq  *%rax
			break;
  800fa1:	eb 3f                	jmp    800fe2 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fa7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fab:	48 89 d6             	mov    %rdx,%rsi
  800fae:	89 df                	mov    %ebx,%edi
  800fb0:	ff d0                	callq  *%rax
			break;
  800fb2:	eb 2e                	jmp    800fe2 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fb4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fb8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fbc:	48 89 d6             	mov    %rdx,%rsi
  800fbf:	bf 25 00 00 00       	mov    $0x25,%edi
  800fc4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fc6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fcb:	eb 05                	jmp    800fd2 <vprintfmt+0x4e7>
  800fcd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fd2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fd6:	48 83 e8 01          	sub    $0x1,%rax
  800fda:	0f b6 00             	movzbl (%rax),%eax
  800fdd:	3c 25                	cmp    $0x25,%al
  800fdf:	75 ec                	jne    800fcd <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800fe1:	90                   	nop
		}
	}
  800fe2:	e9 3d fb ff ff       	jmpq   800b24 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fe7:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800fe8:	48 83 c4 60          	add    $0x60,%rsp
  800fec:	5b                   	pop    %rbx
  800fed:	41 5c                	pop    %r12
  800fef:	5d                   	pop    %rbp
  800ff0:	c3                   	retq   

0000000000800ff1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ff1:	55                   	push   %rbp
  800ff2:	48 89 e5             	mov    %rsp,%rbp
  800ff5:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ffc:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801003:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80100a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  801011:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801018:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80101f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801026:	84 c0                	test   %al,%al
  801028:	74 20                	je     80104a <printfmt+0x59>
  80102a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80102e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801032:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801036:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80103a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80103e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801042:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801046:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80104a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801051:	00 00 00 
  801054:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80105b:	00 00 00 
  80105e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801062:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801069:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801070:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801077:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80107e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801085:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80108c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801093:	48 89 c7             	mov    %rax,%rdi
  801096:	48 b8 eb 0a 80 00 00 	movabs $0x800aeb,%rax
  80109d:	00 00 00 
  8010a0:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010a2:	90                   	nop
  8010a3:	c9                   	leaveq 
  8010a4:	c3                   	retq   

00000000008010a5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010a5:	55                   	push   %rbp
  8010a6:	48 89 e5             	mov    %rsp,%rbp
  8010a9:	48 83 ec 10          	sub    $0x10,%rsp
  8010ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b8:	8b 40 10             	mov    0x10(%rax),%eax
  8010bb:	8d 50 01             	lea    0x1(%rax),%edx
  8010be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c9:	48 8b 10             	mov    (%rax),%rdx
  8010cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010d4:	48 39 c2             	cmp    %rax,%rdx
  8010d7:	73 17                	jae    8010f0 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010dd:	48 8b 00             	mov    (%rax),%rax
  8010e0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010e8:	48 89 0a             	mov    %rcx,(%rdx)
  8010eb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010ee:	88 10                	mov    %dl,(%rax)
}
  8010f0:	90                   	nop
  8010f1:	c9                   	leaveq 
  8010f2:	c3                   	retq   

00000000008010f3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010f3:	55                   	push   %rbp
  8010f4:	48 89 e5             	mov    %rsp,%rbp
  8010f7:	48 83 ec 50          	sub    $0x50,%rsp
  8010fb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010ff:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801102:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801106:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80110a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80110e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801112:	48 8b 0a             	mov    (%rdx),%rcx
  801115:	48 89 08             	mov    %rcx,(%rax)
  801118:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80111c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801120:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801124:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801128:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80112c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801130:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801133:	48 98                	cltq   
  801135:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801139:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80113d:	48 01 d0             	add    %rdx,%rax
  801140:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801144:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80114b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801150:	74 06                	je     801158 <vsnprintf+0x65>
  801152:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801156:	7f 07                	jg     80115f <vsnprintf+0x6c>
		return -E_INVAL;
  801158:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115d:	eb 2f                	jmp    80118e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80115f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801163:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801167:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80116b:	48 89 c6             	mov    %rax,%rsi
  80116e:	48 bf a5 10 80 00 00 	movabs $0x8010a5,%rdi
  801175:	00 00 00 
  801178:	48 b8 eb 0a 80 00 00 	movabs $0x800aeb,%rax
  80117f:	00 00 00 
  801182:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801184:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801188:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80118b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80118e:	c9                   	leaveq 
  80118f:	c3                   	retq   

0000000000801190 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801190:	55                   	push   %rbp
  801191:	48 89 e5             	mov    %rsp,%rbp
  801194:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80119b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011a2:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011a8:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8011af:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011b6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011bd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011c4:	84 c0                	test   %al,%al
  8011c6:	74 20                	je     8011e8 <snprintf+0x58>
  8011c8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011cc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011d0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011d4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011d8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011dc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011e0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011e4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011e8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011ef:	00 00 00 
  8011f2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011f9:	00 00 00 
  8011fc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801200:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801207:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80120e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801215:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80121c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801223:	48 8b 0a             	mov    (%rdx),%rcx
  801226:	48 89 08             	mov    %rcx,(%rax)
  801229:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80122d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801231:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801235:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801239:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801240:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801247:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80124d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801254:	48 89 c7             	mov    %rax,%rdi
  801257:	48 b8 f3 10 80 00 00 	movabs $0x8010f3,%rax
  80125e:	00 00 00 
  801261:	ff d0                	callq  *%rax
  801263:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801269:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80126f:	c9                   	leaveq 
  801270:	c3                   	retq   

0000000000801271 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801271:	55                   	push   %rbp
  801272:	48 89 e5             	mov    %rsp,%rbp
  801275:	48 83 ec 18          	sub    $0x18,%rsp
  801279:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80127d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801284:	eb 09                	jmp    80128f <strlen+0x1e>
		n++;
  801286:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80128a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80128f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801293:	0f b6 00             	movzbl (%rax),%eax
  801296:	84 c0                	test   %al,%al
  801298:	75 ec                	jne    801286 <strlen+0x15>
		n++;
	return n;
  80129a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80129d:	c9                   	leaveq 
  80129e:	c3                   	retq   

000000000080129f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80129f:	55                   	push   %rbp
  8012a0:	48 89 e5             	mov    %rsp,%rbp
  8012a3:	48 83 ec 20          	sub    $0x20,%rsp
  8012a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012b6:	eb 0e                	jmp    8012c6 <strnlen+0x27>
		n++;
  8012b8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012bc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012c1:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012c6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012cb:	74 0b                	je     8012d8 <strnlen+0x39>
  8012cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d1:	0f b6 00             	movzbl (%rax),%eax
  8012d4:	84 c0                	test   %al,%al
  8012d6:	75 e0                	jne    8012b8 <strnlen+0x19>
		n++;
	return n;
  8012d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012db:	c9                   	leaveq 
  8012dc:	c3                   	retq   

00000000008012dd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012dd:	55                   	push   %rbp
  8012de:	48 89 e5             	mov    %rsp,%rbp
  8012e1:	48 83 ec 20          	sub    $0x20,%rsp
  8012e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012f5:	90                   	nop
  8012f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012fe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801302:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801306:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80130a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80130e:	0f b6 12             	movzbl (%rdx),%edx
  801311:	88 10                	mov    %dl,(%rax)
  801313:	0f b6 00             	movzbl (%rax),%eax
  801316:	84 c0                	test   %al,%al
  801318:	75 dc                	jne    8012f6 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80131a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80131e:	c9                   	leaveq 
  80131f:	c3                   	retq   

0000000000801320 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801320:	55                   	push   %rbp
  801321:	48 89 e5             	mov    %rsp,%rbp
  801324:	48 83 ec 20          	sub    $0x20,%rsp
  801328:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80132c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801330:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801334:	48 89 c7             	mov    %rax,%rdi
  801337:	48 b8 71 12 80 00 00 	movabs $0x801271,%rax
  80133e:	00 00 00 
  801341:	ff d0                	callq  *%rax
  801343:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801346:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801349:	48 63 d0             	movslq %eax,%rdx
  80134c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801350:	48 01 c2             	add    %rax,%rdx
  801353:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801357:	48 89 c6             	mov    %rax,%rsi
  80135a:	48 89 d7             	mov    %rdx,%rdi
  80135d:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  801364:	00 00 00 
  801367:	ff d0                	callq  *%rax
	return dst;
  801369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80136d:	c9                   	leaveq 
  80136e:	c3                   	retq   

000000000080136f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80136f:	55                   	push   %rbp
  801370:	48 89 e5             	mov    %rsp,%rbp
  801373:	48 83 ec 28          	sub    $0x28,%rsp
  801377:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80137b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80137f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801383:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801387:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80138b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801392:	00 
  801393:	eb 2a                	jmp    8013bf <strncpy+0x50>
		*dst++ = *src;
  801395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801399:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80139d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013a1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013a5:	0f b6 12             	movzbl (%rdx),%edx
  8013a8:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ae:	0f b6 00             	movzbl (%rax),%eax
  8013b1:	84 c0                	test   %al,%al
  8013b3:	74 05                	je     8013ba <strncpy+0x4b>
			src++;
  8013b5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013c7:	72 cc                	jb     801395 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013cd:	c9                   	leaveq 
  8013ce:	c3                   	retq   

00000000008013cf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013cf:	55                   	push   %rbp
  8013d0:	48 89 e5             	mov    %rsp,%rbp
  8013d3:	48 83 ec 28          	sub    $0x28,%rsp
  8013d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013eb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013f0:	74 3d                	je     80142f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8013f2:	eb 1d                	jmp    801411 <strlcpy+0x42>
			*dst++ = *src++;
  8013f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801400:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801404:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801408:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80140c:	0f b6 12             	movzbl (%rdx),%edx
  80140f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801411:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801416:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80141b:	74 0b                	je     801428 <strlcpy+0x59>
  80141d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801421:	0f b6 00             	movzbl (%rax),%eax
  801424:	84 c0                	test   %al,%al
  801426:	75 cc                	jne    8013f4 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801428:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80142f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801433:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801437:	48 29 c2             	sub    %rax,%rdx
  80143a:	48 89 d0             	mov    %rdx,%rax
}
  80143d:	c9                   	leaveq 
  80143e:	c3                   	retq   

000000000080143f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80143f:	55                   	push   %rbp
  801440:	48 89 e5             	mov    %rsp,%rbp
  801443:	48 83 ec 10          	sub    $0x10,%rsp
  801447:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80144b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80144f:	eb 0a                	jmp    80145b <strcmp+0x1c>
		p++, q++;
  801451:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801456:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80145b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145f:	0f b6 00             	movzbl (%rax),%eax
  801462:	84 c0                	test   %al,%al
  801464:	74 12                	je     801478 <strcmp+0x39>
  801466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146a:	0f b6 10             	movzbl (%rax),%edx
  80146d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801471:	0f b6 00             	movzbl (%rax),%eax
  801474:	38 c2                	cmp    %al,%dl
  801476:	74 d9                	je     801451 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801478:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147c:	0f b6 00             	movzbl (%rax),%eax
  80147f:	0f b6 d0             	movzbl %al,%edx
  801482:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801486:	0f b6 00             	movzbl (%rax),%eax
  801489:	0f b6 c0             	movzbl %al,%eax
  80148c:	29 c2                	sub    %eax,%edx
  80148e:	89 d0                	mov    %edx,%eax
}
  801490:	c9                   	leaveq 
  801491:	c3                   	retq   

0000000000801492 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801492:	55                   	push   %rbp
  801493:	48 89 e5             	mov    %rsp,%rbp
  801496:	48 83 ec 18          	sub    $0x18,%rsp
  80149a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80149e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014a2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014a6:	eb 0f                	jmp    8014b7 <strncmp+0x25>
		n--, p++, q++;
  8014a8:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014bc:	74 1d                	je     8014db <strncmp+0x49>
  8014be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c2:	0f b6 00             	movzbl (%rax),%eax
  8014c5:	84 c0                	test   %al,%al
  8014c7:	74 12                	je     8014db <strncmp+0x49>
  8014c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cd:	0f b6 10             	movzbl (%rax),%edx
  8014d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d4:	0f b6 00             	movzbl (%rax),%eax
  8014d7:	38 c2                	cmp    %al,%dl
  8014d9:	74 cd                	je     8014a8 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014e0:	75 07                	jne    8014e9 <strncmp+0x57>
		return 0;
  8014e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e7:	eb 18                	jmp    801501 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ed:	0f b6 00             	movzbl (%rax),%eax
  8014f0:	0f b6 d0             	movzbl %al,%edx
  8014f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f7:	0f b6 00             	movzbl (%rax),%eax
  8014fa:	0f b6 c0             	movzbl %al,%eax
  8014fd:	29 c2                	sub    %eax,%edx
  8014ff:	89 d0                	mov    %edx,%eax
}
  801501:	c9                   	leaveq 
  801502:	c3                   	retq   

0000000000801503 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801503:	55                   	push   %rbp
  801504:	48 89 e5             	mov    %rsp,%rbp
  801507:	48 83 ec 10          	sub    $0x10,%rsp
  80150b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80150f:	89 f0                	mov    %esi,%eax
  801511:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801514:	eb 17                	jmp    80152d <strchr+0x2a>
		if (*s == c)
  801516:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151a:	0f b6 00             	movzbl (%rax),%eax
  80151d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801520:	75 06                	jne    801528 <strchr+0x25>
			return (char *) s;
  801522:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801526:	eb 15                	jmp    80153d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801528:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80152d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801531:	0f b6 00             	movzbl (%rax),%eax
  801534:	84 c0                	test   %al,%al
  801536:	75 de                	jne    801516 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801538:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153d:	c9                   	leaveq 
  80153e:	c3                   	retq   

000000000080153f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80153f:	55                   	push   %rbp
  801540:	48 89 e5             	mov    %rsp,%rbp
  801543:	48 83 ec 10          	sub    $0x10,%rsp
  801547:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80154b:	89 f0                	mov    %esi,%eax
  80154d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801550:	eb 11                	jmp    801563 <strfind+0x24>
		if (*s == c)
  801552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801556:	0f b6 00             	movzbl (%rax),%eax
  801559:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80155c:	74 12                	je     801570 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80155e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801563:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801567:	0f b6 00             	movzbl (%rax),%eax
  80156a:	84 c0                	test   %al,%al
  80156c:	75 e4                	jne    801552 <strfind+0x13>
  80156e:	eb 01                	jmp    801571 <strfind+0x32>
		if (*s == c)
			break;
  801570:	90                   	nop
	return (char *) s;
  801571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801575:	c9                   	leaveq 
  801576:	c3                   	retq   

0000000000801577 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801577:	55                   	push   %rbp
  801578:	48 89 e5             	mov    %rsp,%rbp
  80157b:	48 83 ec 18          	sub    $0x18,%rsp
  80157f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801583:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801586:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80158a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80158f:	75 06                	jne    801597 <memset+0x20>
		return v;
  801591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801595:	eb 69                	jmp    801600 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801597:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159b:	83 e0 03             	and    $0x3,%eax
  80159e:	48 85 c0             	test   %rax,%rax
  8015a1:	75 48                	jne    8015eb <memset+0x74>
  8015a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a7:	83 e0 03             	and    $0x3,%eax
  8015aa:	48 85 c0             	test   %rax,%rax
  8015ad:	75 3c                	jne    8015eb <memset+0x74>
		c &= 0xFF;
  8015af:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015b6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015b9:	c1 e0 18             	shl    $0x18,%eax
  8015bc:	89 c2                	mov    %eax,%edx
  8015be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c1:	c1 e0 10             	shl    $0x10,%eax
  8015c4:	09 c2                	or     %eax,%edx
  8015c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c9:	c1 e0 08             	shl    $0x8,%eax
  8015cc:	09 d0                	or     %edx,%eax
  8015ce:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d5:	48 c1 e8 02          	shr    $0x2,%rax
  8015d9:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e3:	48 89 d7             	mov    %rdx,%rdi
  8015e6:	fc                   	cld    
  8015e7:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015e9:	eb 11                	jmp    8015fc <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015f6:	48 89 d7             	mov    %rdx,%rdi
  8015f9:	fc                   	cld    
  8015fa:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8015fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801600:	c9                   	leaveq 
  801601:	c3                   	retq   

0000000000801602 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801602:	55                   	push   %rbp
  801603:	48 89 e5             	mov    %rsp,%rbp
  801606:	48 83 ec 28          	sub    $0x28,%rsp
  80160a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80160e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801612:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801616:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80161a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80161e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801622:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801626:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80162e:	0f 83 88 00 00 00    	jae    8016bc <memmove+0xba>
  801634:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801638:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163c:	48 01 d0             	add    %rdx,%rax
  80163f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801643:	76 77                	jbe    8016bc <memmove+0xba>
		s += n;
  801645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801649:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80164d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801651:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801655:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801659:	83 e0 03             	and    $0x3,%eax
  80165c:	48 85 c0             	test   %rax,%rax
  80165f:	75 3b                	jne    80169c <memmove+0x9a>
  801661:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801665:	83 e0 03             	and    $0x3,%eax
  801668:	48 85 c0             	test   %rax,%rax
  80166b:	75 2f                	jne    80169c <memmove+0x9a>
  80166d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801671:	83 e0 03             	and    $0x3,%eax
  801674:	48 85 c0             	test   %rax,%rax
  801677:	75 23                	jne    80169c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801679:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167d:	48 83 e8 04          	sub    $0x4,%rax
  801681:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801685:	48 83 ea 04          	sub    $0x4,%rdx
  801689:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80168d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801691:	48 89 c7             	mov    %rax,%rdi
  801694:	48 89 d6             	mov    %rdx,%rsi
  801697:	fd                   	std    
  801698:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80169a:	eb 1d                	jmp    8016b9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80169c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b0:	48 89 d7             	mov    %rdx,%rdi
  8016b3:	48 89 c1             	mov    %rax,%rcx
  8016b6:	fd                   	std    
  8016b7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016b9:	fc                   	cld    
  8016ba:	eb 57                	jmp    801713 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c0:	83 e0 03             	and    $0x3,%eax
  8016c3:	48 85 c0             	test   %rax,%rax
  8016c6:	75 36                	jne    8016fe <memmove+0xfc>
  8016c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cc:	83 e0 03             	and    $0x3,%eax
  8016cf:	48 85 c0             	test   %rax,%rax
  8016d2:	75 2a                	jne    8016fe <memmove+0xfc>
  8016d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d8:	83 e0 03             	and    $0x3,%eax
  8016db:	48 85 c0             	test   %rax,%rax
  8016de:	75 1e                	jne    8016fe <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e4:	48 c1 e8 02          	shr    $0x2,%rax
  8016e8:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016f3:	48 89 c7             	mov    %rax,%rdi
  8016f6:	48 89 d6             	mov    %rdx,%rsi
  8016f9:	fc                   	cld    
  8016fa:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016fc:	eb 15                	jmp    801713 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801702:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801706:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80170a:	48 89 c7             	mov    %rax,%rdi
  80170d:	48 89 d6             	mov    %rdx,%rsi
  801710:	fc                   	cld    
  801711:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801717:	c9                   	leaveq 
  801718:	c3                   	retq   

0000000000801719 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801719:	55                   	push   %rbp
  80171a:	48 89 e5             	mov    %rsp,%rbp
  80171d:	48 83 ec 18          	sub    $0x18,%rsp
  801721:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801725:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801729:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80172d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801731:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801735:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801739:	48 89 ce             	mov    %rcx,%rsi
  80173c:	48 89 c7             	mov    %rax,%rdi
  80173f:	48 b8 02 16 80 00 00 	movabs $0x801602,%rax
  801746:	00 00 00 
  801749:	ff d0                	callq  *%rax
}
  80174b:	c9                   	leaveq 
  80174c:	c3                   	retq   

000000000080174d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80174d:	55                   	push   %rbp
  80174e:	48 89 e5             	mov    %rsp,%rbp
  801751:	48 83 ec 28          	sub    $0x28,%rsp
  801755:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801759:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80175d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801765:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801769:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80176d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801771:	eb 36                	jmp    8017a9 <memcmp+0x5c>
		if (*s1 != *s2)
  801773:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801777:	0f b6 10             	movzbl (%rax),%edx
  80177a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177e:	0f b6 00             	movzbl (%rax),%eax
  801781:	38 c2                	cmp    %al,%dl
  801783:	74 1a                	je     80179f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801785:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801789:	0f b6 00             	movzbl (%rax),%eax
  80178c:	0f b6 d0             	movzbl %al,%edx
  80178f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801793:	0f b6 00             	movzbl (%rax),%eax
  801796:	0f b6 c0             	movzbl %al,%eax
  801799:	29 c2                	sub    %eax,%edx
  80179b:	89 d0                	mov    %edx,%eax
  80179d:	eb 20                	jmp    8017bf <memcmp+0x72>
		s1++, s2++;
  80179f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017a4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ad:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017b5:	48 85 c0             	test   %rax,%rax
  8017b8:	75 b9                	jne    801773 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bf:	c9                   	leaveq 
  8017c0:	c3                   	retq   

00000000008017c1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017c1:	55                   	push   %rbp
  8017c2:	48 89 e5             	mov    %rsp,%rbp
  8017c5:	48 83 ec 28          	sub    $0x28,%rsp
  8017c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017cd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017dc:	48 01 d0             	add    %rdx,%rax
  8017df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017e3:	eb 19                	jmp    8017fe <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e9:	0f b6 00             	movzbl (%rax),%eax
  8017ec:	0f b6 d0             	movzbl %al,%edx
  8017ef:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017f2:	0f b6 c0             	movzbl %al,%eax
  8017f5:	39 c2                	cmp    %eax,%edx
  8017f7:	74 11                	je     80180a <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017f9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801802:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801806:	72 dd                	jb     8017e5 <memfind+0x24>
  801808:	eb 01                	jmp    80180b <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80180a:	90                   	nop
	return (void *) s;
  80180b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80180f:	c9                   	leaveq 
  801810:	c3                   	retq   

0000000000801811 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801811:	55                   	push   %rbp
  801812:	48 89 e5             	mov    %rsp,%rbp
  801815:	48 83 ec 38          	sub    $0x38,%rsp
  801819:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80181d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801821:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801824:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80182b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801832:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801833:	eb 05                	jmp    80183a <strtol+0x29>
		s++;
  801835:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80183a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183e:	0f b6 00             	movzbl (%rax),%eax
  801841:	3c 20                	cmp    $0x20,%al
  801843:	74 f0                	je     801835 <strtol+0x24>
  801845:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801849:	0f b6 00             	movzbl (%rax),%eax
  80184c:	3c 09                	cmp    $0x9,%al
  80184e:	74 e5                	je     801835 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801850:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801854:	0f b6 00             	movzbl (%rax),%eax
  801857:	3c 2b                	cmp    $0x2b,%al
  801859:	75 07                	jne    801862 <strtol+0x51>
		s++;
  80185b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801860:	eb 17                	jmp    801879 <strtol+0x68>
	else if (*s == '-')
  801862:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801866:	0f b6 00             	movzbl (%rax),%eax
  801869:	3c 2d                	cmp    $0x2d,%al
  80186b:	75 0c                	jne    801879 <strtol+0x68>
		s++, neg = 1;
  80186d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801872:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801879:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80187d:	74 06                	je     801885 <strtol+0x74>
  80187f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801883:	75 28                	jne    8018ad <strtol+0x9c>
  801885:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801889:	0f b6 00             	movzbl (%rax),%eax
  80188c:	3c 30                	cmp    $0x30,%al
  80188e:	75 1d                	jne    8018ad <strtol+0x9c>
  801890:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801894:	48 83 c0 01          	add    $0x1,%rax
  801898:	0f b6 00             	movzbl (%rax),%eax
  80189b:	3c 78                	cmp    $0x78,%al
  80189d:	75 0e                	jne    8018ad <strtol+0x9c>
		s += 2, base = 16;
  80189f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018a4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018ab:	eb 2c                	jmp    8018d9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018b1:	75 19                	jne    8018cc <strtol+0xbb>
  8018b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b7:	0f b6 00             	movzbl (%rax),%eax
  8018ba:	3c 30                	cmp    $0x30,%al
  8018bc:	75 0e                	jne    8018cc <strtol+0xbb>
		s++, base = 8;
  8018be:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018c3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018ca:	eb 0d                	jmp    8018d9 <strtol+0xc8>
	else if (base == 0)
  8018cc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018d0:	75 07                	jne    8018d9 <strtol+0xc8>
		base = 10;
  8018d2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018dd:	0f b6 00             	movzbl (%rax),%eax
  8018e0:	3c 2f                	cmp    $0x2f,%al
  8018e2:	7e 1d                	jle    801901 <strtol+0xf0>
  8018e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e8:	0f b6 00             	movzbl (%rax),%eax
  8018eb:	3c 39                	cmp    $0x39,%al
  8018ed:	7f 12                	jg     801901 <strtol+0xf0>
			dig = *s - '0';
  8018ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f3:	0f b6 00             	movzbl (%rax),%eax
  8018f6:	0f be c0             	movsbl %al,%eax
  8018f9:	83 e8 30             	sub    $0x30,%eax
  8018fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018ff:	eb 4e                	jmp    80194f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801901:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801905:	0f b6 00             	movzbl (%rax),%eax
  801908:	3c 60                	cmp    $0x60,%al
  80190a:	7e 1d                	jle    801929 <strtol+0x118>
  80190c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801910:	0f b6 00             	movzbl (%rax),%eax
  801913:	3c 7a                	cmp    $0x7a,%al
  801915:	7f 12                	jg     801929 <strtol+0x118>
			dig = *s - 'a' + 10;
  801917:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191b:	0f b6 00             	movzbl (%rax),%eax
  80191e:	0f be c0             	movsbl %al,%eax
  801921:	83 e8 57             	sub    $0x57,%eax
  801924:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801927:	eb 26                	jmp    80194f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801929:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192d:	0f b6 00             	movzbl (%rax),%eax
  801930:	3c 40                	cmp    $0x40,%al
  801932:	7e 47                	jle    80197b <strtol+0x16a>
  801934:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801938:	0f b6 00             	movzbl (%rax),%eax
  80193b:	3c 5a                	cmp    $0x5a,%al
  80193d:	7f 3c                	jg     80197b <strtol+0x16a>
			dig = *s - 'A' + 10;
  80193f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801943:	0f b6 00             	movzbl (%rax),%eax
  801946:	0f be c0             	movsbl %al,%eax
  801949:	83 e8 37             	sub    $0x37,%eax
  80194c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80194f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801952:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801955:	7d 23                	jge    80197a <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801957:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80195c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80195f:	48 98                	cltq   
  801961:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801966:	48 89 c2             	mov    %rax,%rdx
  801969:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80196c:	48 98                	cltq   
  80196e:	48 01 d0             	add    %rdx,%rax
  801971:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801975:	e9 5f ff ff ff       	jmpq   8018d9 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80197a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80197b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801980:	74 0b                	je     80198d <strtol+0x17c>
		*endptr = (char *) s;
  801982:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801986:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80198a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80198d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801991:	74 09                	je     80199c <strtol+0x18b>
  801993:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801997:	48 f7 d8             	neg    %rax
  80199a:	eb 04                	jmp    8019a0 <strtol+0x18f>
  80199c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019a0:	c9                   	leaveq 
  8019a1:	c3                   	retq   

00000000008019a2 <strstr>:

char * strstr(const char *in, const char *str)
{
  8019a2:	55                   	push   %rbp
  8019a3:	48 89 e5             	mov    %rsp,%rbp
  8019a6:	48 83 ec 30          	sub    $0x30,%rsp
  8019aa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019ae:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019b6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019ba:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019be:	0f b6 00             	movzbl (%rax),%eax
  8019c1:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019c4:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019c8:	75 06                	jne    8019d0 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ce:	eb 6b                	jmp    801a3b <strstr+0x99>

	len = strlen(str);
  8019d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019d4:	48 89 c7             	mov    %rax,%rdi
  8019d7:	48 b8 71 12 80 00 00 	movabs $0x801271,%rax
  8019de:	00 00 00 
  8019e1:	ff d0                	callq  *%rax
  8019e3:	48 98                	cltq   
  8019e5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019f5:	0f b6 00             	movzbl (%rax),%eax
  8019f8:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8019fb:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019ff:	75 07                	jne    801a08 <strstr+0x66>
				return (char *) 0;
  801a01:	b8 00 00 00 00       	mov    $0x0,%eax
  801a06:	eb 33                	jmp    801a3b <strstr+0x99>
		} while (sc != c);
  801a08:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a0c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a0f:	75 d8                	jne    8019e9 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a15:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1d:	48 89 ce             	mov    %rcx,%rsi
  801a20:	48 89 c7             	mov    %rax,%rdi
  801a23:	48 b8 92 14 80 00 00 	movabs $0x801492,%rax
  801a2a:	00 00 00 
  801a2d:	ff d0                	callq  *%rax
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	75 b6                	jne    8019e9 <strstr+0x47>

	return (char *) (in - 1);
  801a33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a37:	48 83 e8 01          	sub    $0x1,%rax
}
  801a3b:	c9                   	leaveq 
  801a3c:	c3                   	retq   
