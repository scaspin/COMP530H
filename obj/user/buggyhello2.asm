
obj/user/buggyhello2:     file format elf64-x86-64


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
  80003c:	e8 35 00 00 00       	callq  800076 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_cputs(hello, 1024*1024);
  800052:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	be 00 00 10 00       	mov    $0x100000,%esi
  800064:	48 89 c7             	mov    %rax,%rdi
  800067:	48 b8 a8 01 80 00 00 	movabs $0x8001a8,%rax
  80006e:	00 00 00 
  800071:	ff d0                	callq  *%rax
}
  800073:	90                   	nop
  800074:	c9                   	leaveq 
  800075:	c3                   	retq   

0000000000800076 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800076:	55                   	push   %rbp
  800077:	48 89 e5             	mov    %rsp,%rbp
  80007a:	48 83 ec 10          	sub    $0x10,%rsp
  80007e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800081:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  800085:	48 b8 77 02 80 00 00 	movabs $0x800277,%rax
  80008c:	00 00 00 
  80008f:	ff d0                	callq  *%rax
  800091:	25 ff 03 00 00       	and    $0x3ff,%eax
  800096:	48 63 d0             	movslq %eax,%rdx
  800099:	48 89 d0             	mov    %rdx,%rax
  80009c:	48 c1 e0 03          	shl    $0x3,%rax
  8000a0:	48 01 d0             	add    %rdx,%rax
  8000a3:	48 c1 e0 05          	shl    $0x5,%rax
  8000a7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000ae:	00 00 00 
  8000b1:	48 01 c2             	add    %rax,%rdx
  8000b4:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  8000bb:	00 00 00 
  8000be:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c5:	7e 14                	jle    8000db <libmain+0x65>
		binaryname = argv[0];
  8000c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000cb:	48 8b 10             	mov    (%rax),%rdx
  8000ce:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000d5:	00 00 00 
  8000d8:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000e2:	48 89 d6             	mov    %rdx,%rsi
  8000e5:	89 c7                	mov    %eax,%edi
  8000e7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000f3:	48 b8 02 01 80 00 00 	movabs $0x800102,%rax
  8000fa:	00 00 00 
  8000fd:	ff d0                	callq  *%rax
}
  8000ff:	90                   	nop
  800100:	c9                   	leaveq 
  800101:	c3                   	retq   

0000000000800102 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800102:	55                   	push   %rbp
  800103:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800106:	bf 00 00 00 00       	mov    $0x0,%edi
  80010b:	48 b8 31 02 80 00 00 	movabs $0x800231,%rax
  800112:	00 00 00 
  800115:	ff d0                	callq  *%rax
}
  800117:	90                   	nop
  800118:	5d                   	pop    %rbp
  800119:	c3                   	retq   

000000000080011a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80011a:	55                   	push   %rbp
  80011b:	48 89 e5             	mov    %rsp,%rbp
  80011e:	53                   	push   %rbx
  80011f:	48 83 ec 48          	sub    $0x48,%rsp
  800123:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800126:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800129:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80012d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800131:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800135:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800139:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80013c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800140:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800144:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800148:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80014c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800150:	4c 89 c3             	mov    %r8,%rbx
  800153:	cd 30                	int    $0x30
  800155:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800159:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80015d:	74 3e                	je     80019d <syscall+0x83>
  80015f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800164:	7e 37                	jle    80019d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800166:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80016a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80016d:	49 89 d0             	mov    %rdx,%r8
  800170:	89 c1                	mov    %eax,%ecx
  800172:	48 ba 78 1a 80 00 00 	movabs $0x801a78,%rdx
  800179:	00 00 00 
  80017c:	be 23 00 00 00       	mov    $0x23,%esi
  800181:	48 bf 95 1a 80 00 00 	movabs $0x801a95,%rdi
  800188:	00 00 00 
  80018b:	b8 00 00 00 00       	mov    $0x0,%eax
  800190:	49 b9 24 05 80 00 00 	movabs $0x800524,%r9
  800197:	00 00 00 
  80019a:	41 ff d1             	callq  *%r9

	return ret;
  80019d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001a1:	48 83 c4 48          	add    $0x48,%rsp
  8001a5:	5b                   	pop    %rbx
  8001a6:	5d                   	pop    %rbp
  8001a7:	c3                   	retq   

00000000008001a8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001a8:	55                   	push   %rbp
  8001a9:	48 89 e5             	mov    %rsp,%rbp
  8001ac:	48 83 ec 10          	sub    $0x10,%rsp
  8001b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c0:	48 83 ec 08          	sub    $0x8,%rsp
  8001c4:	6a 00                	pushq  $0x0
  8001c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001d2:	48 89 d1             	mov    %rdx,%rcx
  8001d5:	48 89 c2             	mov    %rax,%rdx
  8001d8:	be 00 00 00 00       	mov    $0x0,%esi
  8001dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e2:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax
  8001ee:	48 83 c4 10          	add    $0x10,%rsp
}
  8001f2:	90                   	nop
  8001f3:	c9                   	leaveq 
  8001f4:	c3                   	retq   

00000000008001f5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001f5:	55                   	push   %rbp
  8001f6:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001f9:	48 83 ec 08          	sub    $0x8,%rsp
  8001fd:	6a 00                	pushq  $0x0
  8001ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800205:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80020b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800210:	ba 00 00 00 00       	mov    $0x0,%edx
  800215:	be 00 00 00 00       	mov    $0x0,%esi
  80021a:	bf 01 00 00 00       	mov    $0x1,%edi
  80021f:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  800226:	00 00 00 
  800229:	ff d0                	callq  *%rax
  80022b:	48 83 c4 10          	add    $0x10,%rsp
}
  80022f:	c9                   	leaveq 
  800230:	c3                   	retq   

0000000000800231 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800231:	55                   	push   %rbp
  800232:	48 89 e5             	mov    %rsp,%rbp
  800235:	48 83 ec 10          	sub    $0x10,%rsp
  800239:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80023c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80023f:	48 98                	cltq   
  800241:	48 83 ec 08          	sub    $0x8,%rsp
  800245:	6a 00                	pushq  $0x0
  800247:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80024d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800253:	b9 00 00 00 00       	mov    $0x0,%ecx
  800258:	48 89 c2             	mov    %rax,%rdx
  80025b:	be 01 00 00 00       	mov    $0x1,%esi
  800260:	bf 03 00 00 00       	mov    $0x3,%edi
  800265:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  80026c:	00 00 00 
  80026f:	ff d0                	callq  *%rax
  800271:	48 83 c4 10          	add    $0x10,%rsp
}
  800275:	c9                   	leaveq 
  800276:	c3                   	retq   

0000000000800277 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800277:	55                   	push   %rbp
  800278:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80027b:	48 83 ec 08          	sub    $0x8,%rsp
  80027f:	6a 00                	pushq  $0x0
  800281:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800287:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80028d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800292:	ba 00 00 00 00       	mov    $0x0,%edx
  800297:	be 00 00 00 00       	mov    $0x0,%esi
  80029c:	bf 02 00 00 00       	mov    $0x2,%edi
  8002a1:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  8002a8:	00 00 00 
  8002ab:	ff d0                	callq  *%rax
  8002ad:	48 83 c4 10          	add    $0x10,%rsp
}
  8002b1:	c9                   	leaveq 
  8002b2:	c3                   	retq   

00000000008002b3 <sys_yield>:

void
sys_yield(void)
{
  8002b3:	55                   	push   %rbp
  8002b4:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002b7:	48 83 ec 08          	sub    $0x8,%rsp
  8002bb:	6a 00                	pushq  $0x0
  8002bd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d3:	be 00 00 00 00       	mov    $0x0,%esi
  8002d8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002dd:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  8002e4:	00 00 00 
  8002e7:	ff d0                	callq  *%rax
  8002e9:	48 83 c4 10          	add    $0x10,%rsp
}
  8002ed:	90                   	nop
  8002ee:	c9                   	leaveq 
  8002ef:	c3                   	retq   

00000000008002f0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002f0:	55                   	push   %rbp
  8002f1:	48 89 e5             	mov    %rsp,%rbp
  8002f4:	48 83 ec 10          	sub    $0x10,%rsp
  8002f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002ff:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800302:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800305:	48 63 c8             	movslq %eax,%rcx
  800308:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80030c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80030f:	48 98                	cltq   
  800311:	48 83 ec 08          	sub    $0x8,%rsp
  800315:	6a 00                	pushq  $0x0
  800317:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80031d:	49 89 c8             	mov    %rcx,%r8
  800320:	48 89 d1             	mov    %rdx,%rcx
  800323:	48 89 c2             	mov    %rax,%rdx
  800326:	be 01 00 00 00       	mov    $0x1,%esi
  80032b:	bf 04 00 00 00       	mov    $0x4,%edi
  800330:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  800337:	00 00 00 
  80033a:	ff d0                	callq  *%rax
  80033c:	48 83 c4 10          	add    $0x10,%rsp
}
  800340:	c9                   	leaveq 
  800341:	c3                   	retq   

0000000000800342 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800342:	55                   	push   %rbp
  800343:	48 89 e5             	mov    %rsp,%rbp
  800346:	48 83 ec 20          	sub    $0x20,%rsp
  80034a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80034d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800351:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800354:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800358:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80035c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80035f:	48 63 c8             	movslq %eax,%rcx
  800362:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800366:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800369:	48 63 f0             	movslq %eax,%rsi
  80036c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800370:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800373:	48 98                	cltq   
  800375:	48 83 ec 08          	sub    $0x8,%rsp
  800379:	51                   	push   %rcx
  80037a:	49 89 f9             	mov    %rdi,%r9
  80037d:	49 89 f0             	mov    %rsi,%r8
  800380:	48 89 d1             	mov    %rdx,%rcx
  800383:	48 89 c2             	mov    %rax,%rdx
  800386:	be 01 00 00 00       	mov    $0x1,%esi
  80038b:	bf 05 00 00 00       	mov    $0x5,%edi
  800390:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  800397:	00 00 00 
  80039a:	ff d0                	callq  *%rax
  80039c:	48 83 c4 10          	add    $0x10,%rsp
}
  8003a0:	c9                   	leaveq 
  8003a1:	c3                   	retq   

00000000008003a2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003a2:	55                   	push   %rbp
  8003a3:	48 89 e5             	mov    %rsp,%rbp
  8003a6:	48 83 ec 10          	sub    $0x10,%rsp
  8003aa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003b8:	48 98                	cltq   
  8003ba:	48 83 ec 08          	sub    $0x8,%rsp
  8003be:	6a 00                	pushq  $0x0
  8003c0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003cc:	48 89 d1             	mov    %rdx,%rcx
  8003cf:	48 89 c2             	mov    %rax,%rdx
  8003d2:	be 01 00 00 00       	mov    $0x1,%esi
  8003d7:	bf 06 00 00 00       	mov    $0x6,%edi
  8003dc:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  8003e3:	00 00 00 
  8003e6:	ff d0                	callq  *%rax
  8003e8:	48 83 c4 10          	add    $0x10,%rsp
}
  8003ec:	c9                   	leaveq 
  8003ed:	c3                   	retq   

00000000008003ee <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003ee:	55                   	push   %rbp
  8003ef:	48 89 e5             	mov    %rsp,%rbp
  8003f2:	48 83 ec 10          	sub    $0x10,%rsp
  8003f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003f9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ff:	48 63 d0             	movslq %eax,%rdx
  800402:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800405:	48 98                	cltq   
  800407:	48 83 ec 08          	sub    $0x8,%rsp
  80040b:	6a 00                	pushq  $0x0
  80040d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800413:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800419:	48 89 d1             	mov    %rdx,%rcx
  80041c:	48 89 c2             	mov    %rax,%rdx
  80041f:	be 01 00 00 00       	mov    $0x1,%esi
  800424:	bf 08 00 00 00       	mov    $0x8,%edi
  800429:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  800430:	00 00 00 
  800433:	ff d0                	callq  *%rax
  800435:	48 83 c4 10          	add    $0x10,%rsp
}
  800439:	c9                   	leaveq 
  80043a:	c3                   	retq   

000000000080043b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80043b:	55                   	push   %rbp
  80043c:	48 89 e5             	mov    %rsp,%rbp
  80043f:	48 83 ec 10          	sub    $0x10,%rsp
  800443:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800446:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80044a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80044e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800451:	48 98                	cltq   
  800453:	48 83 ec 08          	sub    $0x8,%rsp
  800457:	6a 00                	pushq  $0x0
  800459:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80045f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800465:	48 89 d1             	mov    %rdx,%rcx
  800468:	48 89 c2             	mov    %rax,%rdx
  80046b:	be 01 00 00 00       	mov    $0x1,%esi
  800470:	bf 09 00 00 00       	mov    $0x9,%edi
  800475:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax
  800481:	48 83 c4 10          	add    $0x10,%rsp
}
  800485:	c9                   	leaveq 
  800486:	c3                   	retq   

0000000000800487 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800487:	55                   	push   %rbp
  800488:	48 89 e5             	mov    %rsp,%rbp
  80048b:	48 83 ec 20          	sub    $0x20,%rsp
  80048f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800492:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800496:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80049a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80049d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004a0:	48 63 f0             	movslq %eax,%rsi
  8004a3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004aa:	48 98                	cltq   
  8004ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b0:	48 83 ec 08          	sub    $0x8,%rsp
  8004b4:	6a 00                	pushq  $0x0
  8004b6:	49 89 f1             	mov    %rsi,%r9
  8004b9:	49 89 c8             	mov    %rcx,%r8
  8004bc:	48 89 d1             	mov    %rdx,%rcx
  8004bf:	48 89 c2             	mov    %rax,%rdx
  8004c2:	be 00 00 00 00       	mov    $0x0,%esi
  8004c7:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004cc:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  8004d3:	00 00 00 
  8004d6:	ff d0                	callq  *%rax
  8004d8:	48 83 c4 10          	add    $0x10,%rsp
}
  8004dc:	c9                   	leaveq 
  8004dd:	c3                   	retq   

00000000008004de <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004de:	55                   	push   %rbp
  8004df:	48 89 e5             	mov    %rsp,%rbp
  8004e2:	48 83 ec 10          	sub    $0x10,%rsp
  8004e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ee:	48 83 ec 08          	sub    $0x8,%rsp
  8004f2:	6a 00                	pushq  $0x0
  8004f4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800500:	b9 00 00 00 00       	mov    $0x0,%ecx
  800505:	48 89 c2             	mov    %rax,%rdx
  800508:	be 01 00 00 00       	mov    $0x1,%esi
  80050d:	bf 0c 00 00 00       	mov    $0xc,%edi
  800512:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  800519:	00 00 00 
  80051c:	ff d0                	callq  *%rax
  80051e:	48 83 c4 10          	add    $0x10,%rsp
}
  800522:	c9                   	leaveq 
  800523:	c3                   	retq   

0000000000800524 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800524:	55                   	push   %rbp
  800525:	48 89 e5             	mov    %rsp,%rbp
  800528:	53                   	push   %rbx
  800529:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800530:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800537:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80053d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800544:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80054b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800552:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800559:	84 c0                	test   %al,%al
  80055b:	74 23                	je     800580 <_panic+0x5c>
  80055d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800564:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800568:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80056c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800570:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800574:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800578:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80057c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800580:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800587:	00 00 00 
  80058a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800591:	00 00 00 
  800594:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800598:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80059f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8005a6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005ad:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8005b4:	00 00 00 
  8005b7:	48 8b 18             	mov    (%rax),%rbx
  8005ba:	48 b8 77 02 80 00 00 	movabs $0x800277,%rax
  8005c1:	00 00 00 
  8005c4:	ff d0                	callq  *%rax
  8005c6:	89 c6                	mov    %eax,%esi
  8005c8:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8005ce:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8005d5:	41 89 d0             	mov    %edx,%r8d
  8005d8:	48 89 c1             	mov    %rax,%rcx
  8005db:	48 89 da             	mov    %rbx,%rdx
  8005de:	48 bf a8 1a 80 00 00 	movabs $0x801aa8,%rdi
  8005e5:	00 00 00 
  8005e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ed:	49 b9 5e 07 80 00 00 	movabs $0x80075e,%r9
  8005f4:	00 00 00 
  8005f7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005fa:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800601:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800608:	48 89 d6             	mov    %rdx,%rsi
  80060b:	48 89 c7             	mov    %rax,%rdi
  80060e:	48 b8 b2 06 80 00 00 	movabs $0x8006b2,%rax
  800615:	00 00 00 
  800618:	ff d0                	callq  *%rax
	cprintf("\n");
  80061a:	48 bf cb 1a 80 00 00 	movabs $0x801acb,%rdi
  800621:	00 00 00 
  800624:	b8 00 00 00 00       	mov    $0x0,%eax
  800629:	48 ba 5e 07 80 00 00 	movabs $0x80075e,%rdx
  800630:	00 00 00 
  800633:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800635:	cc                   	int3   
  800636:	eb fd                	jmp    800635 <_panic+0x111>

0000000000800638 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800638:	55                   	push   %rbp
  800639:	48 89 e5             	mov    %rsp,%rbp
  80063c:	48 83 ec 10          	sub    $0x10,%rsp
  800640:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800643:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800647:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80064b:	8b 00                	mov    (%rax),%eax
  80064d:	8d 48 01             	lea    0x1(%rax),%ecx
  800650:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800654:	89 0a                	mov    %ecx,(%rdx)
  800656:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800659:	89 d1                	mov    %edx,%ecx
  80065b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80065f:	48 98                	cltq   
  800661:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800665:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800669:	8b 00                	mov    (%rax),%eax
  80066b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800670:	75 2c                	jne    80069e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800672:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800676:	8b 00                	mov    (%rax),%eax
  800678:	48 98                	cltq   
  80067a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80067e:	48 83 c2 08          	add    $0x8,%rdx
  800682:	48 89 c6             	mov    %rax,%rsi
  800685:	48 89 d7             	mov    %rdx,%rdi
  800688:	48 b8 a8 01 80 00 00 	movabs $0x8001a8,%rax
  80068f:	00 00 00 
  800692:	ff d0                	callq  *%rax
        b->idx = 0;
  800694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800698:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80069e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a2:	8b 40 04             	mov    0x4(%rax),%eax
  8006a5:	8d 50 01             	lea    0x1(%rax),%edx
  8006a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ac:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006af:	90                   	nop
  8006b0:	c9                   	leaveq 
  8006b1:	c3                   	retq   

00000000008006b2 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8006b2:	55                   	push   %rbp
  8006b3:	48 89 e5             	mov    %rsp,%rbp
  8006b6:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006bd:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006c4:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006cb:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006d2:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006d9:	48 8b 0a             	mov    (%rdx),%rcx
  8006dc:	48 89 08             	mov    %rcx,(%rax)
  8006df:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006e3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006eb:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006f6:	00 00 00 
    b.cnt = 0;
  8006f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800700:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800703:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80070a:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800711:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800718:	48 89 c6             	mov    %rax,%rsi
  80071b:	48 bf 38 06 80 00 00 	movabs $0x800638,%rdi
  800722:	00 00 00 
  800725:	48 b8 fc 0a 80 00 00 	movabs $0x800afc,%rax
  80072c:	00 00 00 
  80072f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800731:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800737:	48 98                	cltq   
  800739:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800740:	48 83 c2 08          	add    $0x8,%rdx
  800744:	48 89 c6             	mov    %rax,%rsi
  800747:	48 89 d7             	mov    %rdx,%rdi
  80074a:	48 b8 a8 01 80 00 00 	movabs $0x8001a8,%rax
  800751:	00 00 00 
  800754:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800756:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80075c:	c9                   	leaveq 
  80075d:	c3                   	retq   

000000000080075e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80075e:	55                   	push   %rbp
  80075f:	48 89 e5             	mov    %rsp,%rbp
  800762:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800769:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800770:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800777:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80077e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800785:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80078c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800793:	84 c0                	test   %al,%al
  800795:	74 20                	je     8007b7 <cprintf+0x59>
  800797:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80079b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80079f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8007a3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8007a7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8007ab:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007af:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007b3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007b7:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007be:	00 00 00 
  8007c1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007c8:	00 00 00 
  8007cb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007cf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007d6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007dd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007e4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007eb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007f2:	48 8b 0a             	mov    (%rdx),%rcx
  8007f5:	48 89 08             	mov    %rcx,(%rax)
  8007f8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007fc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800800:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800804:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800808:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80080f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800816:	48 89 d6             	mov    %rdx,%rsi
  800819:	48 89 c7             	mov    %rax,%rdi
  80081c:	48 b8 b2 06 80 00 00 	movabs $0x8006b2,%rax
  800823:	00 00 00 
  800826:	ff d0                	callq  *%rax
  800828:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80082e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800834:	c9                   	leaveq 
  800835:	c3                   	retq   

0000000000800836 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800836:	55                   	push   %rbp
  800837:	48 89 e5             	mov    %rsp,%rbp
  80083a:	48 83 ec 30          	sub    $0x30,%rsp
  80083e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800842:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800846:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80084a:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80084d:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800851:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800855:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800858:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80085c:	77 54                	ja     8008b2 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80085e:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800861:	8d 78 ff             	lea    -0x1(%rax),%edi
  800864:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086b:	ba 00 00 00 00       	mov    $0x0,%edx
  800870:	48 f7 f6             	div    %rsi
  800873:	49 89 c2             	mov    %rax,%r10
  800876:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800879:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80087c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800880:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800884:	41 89 c9             	mov    %ecx,%r9d
  800887:	41 89 f8             	mov    %edi,%r8d
  80088a:	89 d1                	mov    %edx,%ecx
  80088c:	4c 89 d2             	mov    %r10,%rdx
  80088f:	48 89 c7             	mov    %rax,%rdi
  800892:	48 b8 36 08 80 00 00 	movabs $0x800836,%rax
  800899:	00 00 00 
  80089c:	ff d0                	callq  *%rax
  80089e:	eb 1c                	jmp    8008bc <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008a0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8008a4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8008a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008ab:	48 89 ce             	mov    %rcx,%rsi
  8008ae:	89 d7                	mov    %edx,%edi
  8008b0:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008b2:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8008b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8008ba:	7f e4                	jg     8008a0 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008bc:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8008bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c8:	48 f7 f1             	div    %rcx
  8008cb:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  8008d2:	00 00 00 
  8008d5:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8008d9:	0f be d0             	movsbl %al,%edx
  8008dc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8008e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008e4:	48 89 ce             	mov    %rcx,%rsi
  8008e7:	89 d7                	mov    %edx,%edi
  8008e9:	ff d0                	callq  *%rax
}
  8008eb:	90                   	nop
  8008ec:	c9                   	leaveq 
  8008ed:	c3                   	retq   

00000000008008ee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ee:	55                   	push   %rbp
  8008ef:	48 89 e5             	mov    %rsp,%rbp
  8008f2:	48 83 ec 20          	sub    $0x20,%rsp
  8008f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008fa:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800901:	7e 4f                	jle    800952 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800903:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800907:	8b 00                	mov    (%rax),%eax
  800909:	83 f8 30             	cmp    $0x30,%eax
  80090c:	73 24                	jae    800932 <getuint+0x44>
  80090e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800912:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800916:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091a:	8b 00                	mov    (%rax),%eax
  80091c:	89 c0                	mov    %eax,%eax
  80091e:	48 01 d0             	add    %rdx,%rax
  800921:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800925:	8b 12                	mov    (%rdx),%edx
  800927:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80092a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092e:	89 0a                	mov    %ecx,(%rdx)
  800930:	eb 14                	jmp    800946 <getuint+0x58>
  800932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800936:	48 8b 40 08          	mov    0x8(%rax),%rax
  80093a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80093e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800942:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800946:	48 8b 00             	mov    (%rax),%rax
  800949:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80094d:	e9 9d 00 00 00       	jmpq   8009ef <getuint+0x101>
	else if (lflag)
  800952:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800956:	74 4c                	je     8009a4 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800958:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095c:	8b 00                	mov    (%rax),%eax
  80095e:	83 f8 30             	cmp    $0x30,%eax
  800961:	73 24                	jae    800987 <getuint+0x99>
  800963:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800967:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80096b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096f:	8b 00                	mov    (%rax),%eax
  800971:	89 c0                	mov    %eax,%eax
  800973:	48 01 d0             	add    %rdx,%rax
  800976:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097a:	8b 12                	mov    (%rdx),%edx
  80097c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80097f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800983:	89 0a                	mov    %ecx,(%rdx)
  800985:	eb 14                	jmp    80099b <getuint+0xad>
  800987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80098f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800993:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800997:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80099b:	48 8b 00             	mov    (%rax),%rax
  80099e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009a2:	eb 4b                	jmp    8009ef <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8009a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a8:	8b 00                	mov    (%rax),%eax
  8009aa:	83 f8 30             	cmp    $0x30,%eax
  8009ad:	73 24                	jae    8009d3 <getuint+0xe5>
  8009af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bb:	8b 00                	mov    (%rax),%eax
  8009bd:	89 c0                	mov    %eax,%eax
  8009bf:	48 01 d0             	add    %rdx,%rax
  8009c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c6:	8b 12                	mov    (%rdx),%edx
  8009c8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cf:	89 0a                	mov    %ecx,(%rdx)
  8009d1:	eb 14                	jmp    8009e7 <getuint+0xf9>
  8009d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009db:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e7:	8b 00                	mov    (%rax),%eax
  8009e9:	89 c0                	mov    %eax,%eax
  8009eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009f3:	c9                   	leaveq 
  8009f4:	c3                   	retq   

00000000008009f5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009f5:	55                   	push   %rbp
  8009f6:	48 89 e5             	mov    %rsp,%rbp
  8009f9:	48 83 ec 20          	sub    $0x20,%rsp
  8009fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a01:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a04:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a08:	7e 4f                	jle    800a59 <getint+0x64>
		x=va_arg(*ap, long long);
  800a0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0e:	8b 00                	mov    (%rax),%eax
  800a10:	83 f8 30             	cmp    $0x30,%eax
  800a13:	73 24                	jae    800a39 <getint+0x44>
  800a15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a19:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a21:	8b 00                	mov    (%rax),%eax
  800a23:	89 c0                	mov    %eax,%eax
  800a25:	48 01 d0             	add    %rdx,%rax
  800a28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2c:	8b 12                	mov    (%rdx),%edx
  800a2e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a35:	89 0a                	mov    %ecx,(%rdx)
  800a37:	eb 14                	jmp    800a4d <getint+0x58>
  800a39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a41:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a45:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a49:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a4d:	48 8b 00             	mov    (%rax),%rax
  800a50:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a54:	e9 9d 00 00 00       	jmpq   800af6 <getint+0x101>
	else if (lflag)
  800a59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a5d:	74 4c                	je     800aab <getint+0xb6>
		x=va_arg(*ap, long);
  800a5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a63:	8b 00                	mov    (%rax),%eax
  800a65:	83 f8 30             	cmp    $0x30,%eax
  800a68:	73 24                	jae    800a8e <getint+0x99>
  800a6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a76:	8b 00                	mov    (%rax),%eax
  800a78:	89 c0                	mov    %eax,%eax
  800a7a:	48 01 d0             	add    %rdx,%rax
  800a7d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a81:	8b 12                	mov    (%rdx),%edx
  800a83:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8a:	89 0a                	mov    %ecx,(%rdx)
  800a8c:	eb 14                	jmp    800aa2 <getint+0xad>
  800a8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a92:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a96:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a9a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aa2:	48 8b 00             	mov    (%rax),%rax
  800aa5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aa9:	eb 4b                	jmp    800af6 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800aab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aaf:	8b 00                	mov    (%rax),%eax
  800ab1:	83 f8 30             	cmp    $0x30,%eax
  800ab4:	73 24                	jae    800ada <getint+0xe5>
  800ab6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aba:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800abe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac2:	8b 00                	mov    (%rax),%eax
  800ac4:	89 c0                	mov    %eax,%eax
  800ac6:	48 01 d0             	add    %rdx,%rax
  800ac9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800acd:	8b 12                	mov    (%rdx),%edx
  800acf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ad2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad6:	89 0a                	mov    %ecx,(%rdx)
  800ad8:	eb 14                	jmp    800aee <getint+0xf9>
  800ada:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ade:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ae2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ae6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aee:	8b 00                	mov    (%rax),%eax
  800af0:	48 98                	cltq   
  800af2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800af6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800afa:	c9                   	leaveq 
  800afb:	c3                   	retq   

0000000000800afc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800afc:	55                   	push   %rbp
  800afd:	48 89 e5             	mov    %rsp,%rbp
  800b00:	41 54                	push   %r12
  800b02:	53                   	push   %rbx
  800b03:	48 83 ec 60          	sub    $0x60,%rsp
  800b07:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b0b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b0f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b13:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b17:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b1b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b1f:	48 8b 0a             	mov    (%rdx),%rcx
  800b22:	48 89 08             	mov    %rcx,(%rax)
  800b25:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b29:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b2d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b31:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b35:	eb 17                	jmp    800b4e <vprintfmt+0x52>
			if (ch == '\0')
  800b37:	85 db                	test   %ebx,%ebx
  800b39:	0f 84 b9 04 00 00    	je     800ff8 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800b3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b47:	48 89 d6             	mov    %rdx,%rsi
  800b4a:	89 df                	mov    %ebx,%edi
  800b4c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b4e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b52:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b56:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b5a:	0f b6 00             	movzbl (%rax),%eax
  800b5d:	0f b6 d8             	movzbl %al,%ebx
  800b60:	83 fb 25             	cmp    $0x25,%ebx
  800b63:	75 d2                	jne    800b37 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b65:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b69:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b70:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b77:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b7e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b85:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b89:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b8d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b91:	0f b6 00             	movzbl (%rax),%eax
  800b94:	0f b6 d8             	movzbl %al,%ebx
  800b97:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b9a:	83 f8 55             	cmp    $0x55,%eax
  800b9d:	0f 87 22 04 00 00    	ja     800fc5 <vprintfmt+0x4c9>
  800ba3:	89 c0                	mov    %eax,%eax
  800ba5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bac:	00 
  800bad:	48 b8 58 1c 80 00 00 	movabs $0x801c58,%rax
  800bb4:	00 00 00 
  800bb7:	48 01 d0             	add    %rdx,%rax
  800bba:	48 8b 00             	mov    (%rax),%rax
  800bbd:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bbf:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bc3:	eb c0                	jmp    800b85 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bc5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bc9:	eb ba                	jmp    800b85 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bcb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bd2:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bd5:	89 d0                	mov    %edx,%eax
  800bd7:	c1 e0 02             	shl    $0x2,%eax
  800bda:	01 d0                	add    %edx,%eax
  800bdc:	01 c0                	add    %eax,%eax
  800bde:	01 d8                	add    %ebx,%eax
  800be0:	83 e8 30             	sub    $0x30,%eax
  800be3:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800be6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bea:	0f b6 00             	movzbl (%rax),%eax
  800bed:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bf0:	83 fb 2f             	cmp    $0x2f,%ebx
  800bf3:	7e 60                	jle    800c55 <vprintfmt+0x159>
  800bf5:	83 fb 39             	cmp    $0x39,%ebx
  800bf8:	7f 5b                	jg     800c55 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bfa:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bff:	eb d1                	jmp    800bd2 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800c01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c04:	83 f8 30             	cmp    $0x30,%eax
  800c07:	73 17                	jae    800c20 <vprintfmt+0x124>
  800c09:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c0d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c10:	89 d2                	mov    %edx,%edx
  800c12:	48 01 d0             	add    %rdx,%rax
  800c15:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c18:	83 c2 08             	add    $0x8,%edx
  800c1b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c1e:	eb 0c                	jmp    800c2c <vprintfmt+0x130>
  800c20:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c24:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c28:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c2c:	8b 00                	mov    (%rax),%eax
  800c2e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c31:	eb 23                	jmp    800c56 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800c33:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c37:	0f 89 48 ff ff ff    	jns    800b85 <vprintfmt+0x89>
				width = 0;
  800c3d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c44:	e9 3c ff ff ff       	jmpq   800b85 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c49:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c50:	e9 30 ff ff ff       	jmpq   800b85 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c55:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c56:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c5a:	0f 89 25 ff ff ff    	jns    800b85 <vprintfmt+0x89>
				width = precision, precision = -1;
  800c60:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c63:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c66:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c6d:	e9 13 ff ff ff       	jmpq   800b85 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c72:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c76:	e9 0a ff ff ff       	jmpq   800b85 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7e:	83 f8 30             	cmp    $0x30,%eax
  800c81:	73 17                	jae    800c9a <vprintfmt+0x19e>
  800c83:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c87:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8a:	89 d2                	mov    %edx,%edx
  800c8c:	48 01 d0             	add    %rdx,%rax
  800c8f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c92:	83 c2 08             	add    $0x8,%edx
  800c95:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c98:	eb 0c                	jmp    800ca6 <vprintfmt+0x1aa>
  800c9a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c9e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ca2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ca6:	8b 10                	mov    (%rax),%edx
  800ca8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb0:	48 89 ce             	mov    %rcx,%rsi
  800cb3:	89 d7                	mov    %edx,%edi
  800cb5:	ff d0                	callq  *%rax
			break;
  800cb7:	e9 37 03 00 00       	jmpq   800ff3 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cbc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cbf:	83 f8 30             	cmp    $0x30,%eax
  800cc2:	73 17                	jae    800cdb <vprintfmt+0x1df>
  800cc4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cc8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ccb:	89 d2                	mov    %edx,%edx
  800ccd:	48 01 d0             	add    %rdx,%rax
  800cd0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cd3:	83 c2 08             	add    $0x8,%edx
  800cd6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cd9:	eb 0c                	jmp    800ce7 <vprintfmt+0x1eb>
  800cdb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cdf:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ce3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ce7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ce9:	85 db                	test   %ebx,%ebx
  800ceb:	79 02                	jns    800cef <vprintfmt+0x1f3>
				err = -err;
  800ced:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cef:	83 fb 15             	cmp    $0x15,%ebx
  800cf2:	7f 16                	jg     800d0a <vprintfmt+0x20e>
  800cf4:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  800cfb:	00 00 00 
  800cfe:	48 63 d3             	movslq %ebx,%rdx
  800d01:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d05:	4d 85 e4             	test   %r12,%r12
  800d08:	75 2e                	jne    800d38 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800d0a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d12:	89 d9                	mov    %ebx,%ecx
  800d14:	48 ba 41 1c 80 00 00 	movabs $0x801c41,%rdx
  800d1b:	00 00 00 
  800d1e:	48 89 c7             	mov    %rax,%rdi
  800d21:	b8 00 00 00 00       	mov    $0x0,%eax
  800d26:	49 b8 02 10 80 00 00 	movabs $0x801002,%r8
  800d2d:	00 00 00 
  800d30:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d33:	e9 bb 02 00 00       	jmpq   800ff3 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d38:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d40:	4c 89 e1             	mov    %r12,%rcx
  800d43:	48 ba 4a 1c 80 00 00 	movabs $0x801c4a,%rdx
  800d4a:	00 00 00 
  800d4d:	48 89 c7             	mov    %rax,%rdi
  800d50:	b8 00 00 00 00       	mov    $0x0,%eax
  800d55:	49 b8 02 10 80 00 00 	movabs $0x801002,%r8
  800d5c:	00 00 00 
  800d5f:	41 ff d0             	callq  *%r8
			break;
  800d62:	e9 8c 02 00 00       	jmpq   800ff3 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d67:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d6a:	83 f8 30             	cmp    $0x30,%eax
  800d6d:	73 17                	jae    800d86 <vprintfmt+0x28a>
  800d6f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d73:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d76:	89 d2                	mov    %edx,%edx
  800d78:	48 01 d0             	add    %rdx,%rax
  800d7b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d7e:	83 c2 08             	add    $0x8,%edx
  800d81:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d84:	eb 0c                	jmp    800d92 <vprintfmt+0x296>
  800d86:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d8a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d8e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d92:	4c 8b 20             	mov    (%rax),%r12
  800d95:	4d 85 e4             	test   %r12,%r12
  800d98:	75 0a                	jne    800da4 <vprintfmt+0x2a8>
				p = "(null)";
  800d9a:	49 bc 4d 1c 80 00 00 	movabs $0x801c4d,%r12
  800da1:	00 00 00 
			if (width > 0 && padc != '-')
  800da4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800da8:	7e 78                	jle    800e22 <vprintfmt+0x326>
  800daa:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dae:	74 72                	je     800e22 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800db0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800db3:	48 98                	cltq   
  800db5:	48 89 c6             	mov    %rax,%rsi
  800db8:	4c 89 e7             	mov    %r12,%rdi
  800dbb:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  800dc2:	00 00 00 
  800dc5:	ff d0                	callq  *%rax
  800dc7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dca:	eb 17                	jmp    800de3 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800dcc:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800dd0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dd4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd8:	48 89 ce             	mov    %rcx,%rsi
  800ddb:	89 d7                	mov    %edx,%edi
  800ddd:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ddf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800de3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800de7:	7f e3                	jg     800dcc <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800de9:	eb 37                	jmp    800e22 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800deb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800def:	74 1e                	je     800e0f <vprintfmt+0x313>
  800df1:	83 fb 1f             	cmp    $0x1f,%ebx
  800df4:	7e 05                	jle    800dfb <vprintfmt+0x2ff>
  800df6:	83 fb 7e             	cmp    $0x7e,%ebx
  800df9:	7e 14                	jle    800e0f <vprintfmt+0x313>
					putch('?', putdat);
  800dfb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e03:	48 89 d6             	mov    %rdx,%rsi
  800e06:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e0b:	ff d0                	callq  *%rax
  800e0d:	eb 0f                	jmp    800e1e <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800e0f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e17:	48 89 d6             	mov    %rdx,%rsi
  800e1a:	89 df                	mov    %ebx,%edi
  800e1c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e1e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e22:	4c 89 e0             	mov    %r12,%rax
  800e25:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e29:	0f b6 00             	movzbl (%rax),%eax
  800e2c:	0f be d8             	movsbl %al,%ebx
  800e2f:	85 db                	test   %ebx,%ebx
  800e31:	74 28                	je     800e5b <vprintfmt+0x35f>
  800e33:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e37:	78 b2                	js     800deb <vprintfmt+0x2ef>
  800e39:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e3d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e41:	79 a8                	jns    800deb <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e43:	eb 16                	jmp    800e5b <vprintfmt+0x35f>
				putch(' ', putdat);
  800e45:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e4d:	48 89 d6             	mov    %rdx,%rsi
  800e50:	bf 20 00 00 00       	mov    $0x20,%edi
  800e55:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e57:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e5f:	7f e4                	jg     800e45 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800e61:	e9 8d 01 00 00       	jmpq   800ff3 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e66:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e6a:	be 03 00 00 00       	mov    $0x3,%esi
  800e6f:	48 89 c7             	mov    %rax,%rdi
  800e72:	48 b8 f5 09 80 00 00 	movabs $0x8009f5,%rax
  800e79:	00 00 00 
  800e7c:	ff d0                	callq  *%rax
  800e7e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e86:	48 85 c0             	test   %rax,%rax
  800e89:	79 1d                	jns    800ea8 <vprintfmt+0x3ac>
				putch('-', putdat);
  800e8b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e8f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e93:	48 89 d6             	mov    %rdx,%rsi
  800e96:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e9b:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea1:	48 f7 d8             	neg    %rax
  800ea4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ea8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800eaf:	e9 d2 00 00 00       	jmpq   800f86 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800eb4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eb8:	be 03 00 00 00       	mov    $0x3,%esi
  800ebd:	48 89 c7             	mov    %rax,%rdi
  800ec0:	48 b8 ee 08 80 00 00 	movabs $0x8008ee,%rax
  800ec7:	00 00 00 
  800eca:	ff d0                	callq  *%rax
  800ecc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ed0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ed7:	e9 aa 00 00 00       	jmpq   800f86 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800edc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ee0:	be 03 00 00 00       	mov    $0x3,%esi
  800ee5:	48 89 c7             	mov    %rax,%rdi
  800ee8:	48 b8 ee 08 80 00 00 	movabs $0x8008ee,%rax
  800eef:	00 00 00 
  800ef2:	ff d0                	callq  *%rax
  800ef4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ef8:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800eff:	e9 82 00 00 00       	jmpq   800f86 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800f04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0c:	48 89 d6             	mov    %rdx,%rsi
  800f0f:	bf 30 00 00 00       	mov    $0x30,%edi
  800f14:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f16:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f1e:	48 89 d6             	mov    %rdx,%rsi
  800f21:	bf 78 00 00 00       	mov    $0x78,%edi
  800f26:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f28:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f2b:	83 f8 30             	cmp    $0x30,%eax
  800f2e:	73 17                	jae    800f47 <vprintfmt+0x44b>
  800f30:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f34:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f37:	89 d2                	mov    %edx,%edx
  800f39:	48 01 d0             	add    %rdx,%rax
  800f3c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f3f:	83 c2 08             	add    $0x8,%edx
  800f42:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f45:	eb 0c                	jmp    800f53 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800f47:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800f4b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800f4f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f53:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f5a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f61:	eb 23                	jmp    800f86 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f63:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f67:	be 03 00 00 00       	mov    $0x3,%esi
  800f6c:	48 89 c7             	mov    %rax,%rdi
  800f6f:	48 b8 ee 08 80 00 00 	movabs $0x8008ee,%rax
  800f76:	00 00 00 
  800f79:	ff d0                	callq  *%rax
  800f7b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f7f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f86:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f8b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f8e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f91:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f95:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f9d:	45 89 c1             	mov    %r8d,%r9d
  800fa0:	41 89 f8             	mov    %edi,%r8d
  800fa3:	48 89 c7             	mov    %rax,%rdi
  800fa6:	48 b8 36 08 80 00 00 	movabs $0x800836,%rax
  800fad:	00 00 00 
  800fb0:	ff d0                	callq  *%rax
			break;
  800fb2:	eb 3f                	jmp    800ff3 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fb4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fb8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fbc:	48 89 d6             	mov    %rdx,%rsi
  800fbf:	89 df                	mov    %ebx,%edi
  800fc1:	ff d0                	callq  *%rax
			break;
  800fc3:	eb 2e                	jmp    800ff3 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fc5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fc9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fcd:	48 89 d6             	mov    %rdx,%rsi
  800fd0:	bf 25 00 00 00       	mov    $0x25,%edi
  800fd5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fd7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fdc:	eb 05                	jmp    800fe3 <vprintfmt+0x4e7>
  800fde:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fe3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fe7:	48 83 e8 01          	sub    $0x1,%rax
  800feb:	0f b6 00             	movzbl (%rax),%eax
  800fee:	3c 25                	cmp    $0x25,%al
  800ff0:	75 ec                	jne    800fde <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800ff2:	90                   	nop
		}
	}
  800ff3:	e9 3d fb ff ff       	jmpq   800b35 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ff8:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ff9:	48 83 c4 60          	add    $0x60,%rsp
  800ffd:	5b                   	pop    %rbx
  800ffe:	41 5c                	pop    %r12
  801000:	5d                   	pop    %rbp
  801001:	c3                   	retq   

0000000000801002 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801002:	55                   	push   %rbp
  801003:	48 89 e5             	mov    %rsp,%rbp
  801006:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80100d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801014:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80101b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  801022:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801029:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801030:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801037:	84 c0                	test   %al,%al
  801039:	74 20                	je     80105b <printfmt+0x59>
  80103b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80103f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801043:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801047:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80104b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80104f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801053:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801057:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80105b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801062:	00 00 00 
  801065:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80106c:	00 00 00 
  80106f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801073:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80107a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801081:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801088:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80108f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801096:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80109d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010a4:	48 89 c7             	mov    %rax,%rdi
  8010a7:	48 b8 fc 0a 80 00 00 	movabs $0x800afc,%rax
  8010ae:	00 00 00 
  8010b1:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010b3:	90                   	nop
  8010b4:	c9                   	leaveq 
  8010b5:	c3                   	retq   

00000000008010b6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010b6:	55                   	push   %rbp
  8010b7:	48 89 e5             	mov    %rsp,%rbp
  8010ba:	48 83 ec 10          	sub    $0x10,%rsp
  8010be:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c9:	8b 40 10             	mov    0x10(%rax),%eax
  8010cc:	8d 50 01             	lea    0x1(%rax),%edx
  8010cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010da:	48 8b 10             	mov    (%rax),%rdx
  8010dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010e5:	48 39 c2             	cmp    %rax,%rdx
  8010e8:	73 17                	jae    801101 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ee:	48 8b 00             	mov    (%rax),%rax
  8010f1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010f9:	48 89 0a             	mov    %rcx,(%rdx)
  8010fc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010ff:	88 10                	mov    %dl,(%rax)
}
  801101:	90                   	nop
  801102:	c9                   	leaveq 
  801103:	c3                   	retq   

0000000000801104 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801104:	55                   	push   %rbp
  801105:	48 89 e5             	mov    %rsp,%rbp
  801108:	48 83 ec 50          	sub    $0x50,%rsp
  80110c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801110:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801113:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801117:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80111b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80111f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801123:	48 8b 0a             	mov    (%rdx),%rcx
  801126:	48 89 08             	mov    %rcx,(%rax)
  801129:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80112d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801131:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801135:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801139:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80113d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801141:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801144:	48 98                	cltq   
  801146:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80114a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80114e:	48 01 d0             	add    %rdx,%rax
  801151:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801155:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80115c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801161:	74 06                	je     801169 <vsnprintf+0x65>
  801163:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801167:	7f 07                	jg     801170 <vsnprintf+0x6c>
		return -E_INVAL;
  801169:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116e:	eb 2f                	jmp    80119f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801170:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801174:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801178:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80117c:	48 89 c6             	mov    %rax,%rsi
  80117f:	48 bf b6 10 80 00 00 	movabs $0x8010b6,%rdi
  801186:	00 00 00 
  801189:	48 b8 fc 0a 80 00 00 	movabs $0x800afc,%rax
  801190:	00 00 00 
  801193:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801195:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801199:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80119c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80119f:	c9                   	leaveq 
  8011a0:	c3                   	retq   

00000000008011a1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011a1:	55                   	push   %rbp
  8011a2:	48 89 e5             	mov    %rsp,%rbp
  8011a5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011ac:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011b3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011b9:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8011c0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011c7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011ce:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011d5:	84 c0                	test   %al,%al
  8011d7:	74 20                	je     8011f9 <snprintf+0x58>
  8011d9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011dd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011e1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011e5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011e9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011ed:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011f1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011f5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011f9:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801200:	00 00 00 
  801203:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80120a:	00 00 00 
  80120d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801211:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801218:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80121f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801226:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80122d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801234:	48 8b 0a             	mov    (%rdx),%rcx
  801237:	48 89 08             	mov    %rcx,(%rax)
  80123a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80123e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801242:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801246:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80124a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801251:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801258:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80125e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801265:	48 89 c7             	mov    %rax,%rdi
  801268:	48 b8 04 11 80 00 00 	movabs $0x801104,%rax
  80126f:	00 00 00 
  801272:	ff d0                	callq  *%rax
  801274:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80127a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801280:	c9                   	leaveq 
  801281:	c3                   	retq   

0000000000801282 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801282:	55                   	push   %rbp
  801283:	48 89 e5             	mov    %rsp,%rbp
  801286:	48 83 ec 18          	sub    $0x18,%rsp
  80128a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80128e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801295:	eb 09                	jmp    8012a0 <strlen+0x1e>
		n++;
  801297:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80129b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a4:	0f b6 00             	movzbl (%rax),%eax
  8012a7:	84 c0                	test   %al,%al
  8012a9:	75 ec                	jne    801297 <strlen+0x15>
		n++;
	return n;
  8012ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012ae:	c9                   	leaveq 
  8012af:	c3                   	retq   

00000000008012b0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012b0:	55                   	push   %rbp
  8012b1:	48 89 e5             	mov    %rsp,%rbp
  8012b4:	48 83 ec 20          	sub    $0x20,%rsp
  8012b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012c7:	eb 0e                	jmp    8012d7 <strnlen+0x27>
		n++;
  8012c9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012cd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012d2:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012d7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012dc:	74 0b                	je     8012e9 <strnlen+0x39>
  8012de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e2:	0f b6 00             	movzbl (%rax),%eax
  8012e5:	84 c0                	test   %al,%al
  8012e7:	75 e0                	jne    8012c9 <strnlen+0x19>
		n++;
	return n;
  8012e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012ec:	c9                   	leaveq 
  8012ed:	c3                   	retq   

00000000008012ee <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012ee:	55                   	push   %rbp
  8012ef:	48 89 e5             	mov    %rsp,%rbp
  8012f2:	48 83 ec 20          	sub    $0x20,%rsp
  8012f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801302:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801306:	90                   	nop
  801307:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80130f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801313:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801317:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80131b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80131f:	0f b6 12             	movzbl (%rdx),%edx
  801322:	88 10                	mov    %dl,(%rax)
  801324:	0f b6 00             	movzbl (%rax),%eax
  801327:	84 c0                	test   %al,%al
  801329:	75 dc                	jne    801307 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80132b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80132f:	c9                   	leaveq 
  801330:	c3                   	retq   

0000000000801331 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801331:	55                   	push   %rbp
  801332:	48 89 e5             	mov    %rsp,%rbp
  801335:	48 83 ec 20          	sub    $0x20,%rsp
  801339:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80133d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801341:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801345:	48 89 c7             	mov    %rax,%rdi
  801348:	48 b8 82 12 80 00 00 	movabs $0x801282,%rax
  80134f:	00 00 00 
  801352:	ff d0                	callq  *%rax
  801354:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801357:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80135a:	48 63 d0             	movslq %eax,%rdx
  80135d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801361:	48 01 c2             	add    %rax,%rdx
  801364:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801368:	48 89 c6             	mov    %rax,%rsi
  80136b:	48 89 d7             	mov    %rdx,%rdi
  80136e:	48 b8 ee 12 80 00 00 	movabs $0x8012ee,%rax
  801375:	00 00 00 
  801378:	ff d0                	callq  *%rax
	return dst;
  80137a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80137e:	c9                   	leaveq 
  80137f:	c3                   	retq   

0000000000801380 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801380:	55                   	push   %rbp
  801381:	48 89 e5             	mov    %rsp,%rbp
  801384:	48 83 ec 28          	sub    $0x28,%rsp
  801388:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80138c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801390:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801394:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801398:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80139c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013a3:	00 
  8013a4:	eb 2a                	jmp    8013d0 <strncpy+0x50>
		*dst++ = *src;
  8013a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013aa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013ae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013b2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013b6:	0f b6 12             	movzbl (%rdx),%edx
  8013b9:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013bf:	0f b6 00             	movzbl (%rax),%eax
  8013c2:	84 c0                	test   %al,%al
  8013c4:	74 05                	je     8013cb <strncpy+0x4b>
			src++;
  8013c6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013cb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013d8:	72 cc                	jb     8013a6 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013de:	c9                   	leaveq 
  8013df:	c3                   	retq   

00000000008013e0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013e0:	55                   	push   %rbp
  8013e1:	48 89 e5             	mov    %rsp,%rbp
  8013e4:	48 83 ec 28          	sub    $0x28,%rsp
  8013e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013fc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801401:	74 3d                	je     801440 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801403:	eb 1d                	jmp    801422 <strlcpy+0x42>
			*dst++ = *src++;
  801405:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801409:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80140d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801411:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801415:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801419:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80141d:	0f b6 12             	movzbl (%rdx),%edx
  801420:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801422:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801427:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80142c:	74 0b                	je     801439 <strlcpy+0x59>
  80142e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801432:	0f b6 00             	movzbl (%rax),%eax
  801435:	84 c0                	test   %al,%al
  801437:	75 cc                	jne    801405 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801439:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801440:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801444:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801448:	48 29 c2             	sub    %rax,%rdx
  80144b:	48 89 d0             	mov    %rdx,%rax
}
  80144e:	c9                   	leaveq 
  80144f:	c3                   	retq   

0000000000801450 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801450:	55                   	push   %rbp
  801451:	48 89 e5             	mov    %rsp,%rbp
  801454:	48 83 ec 10          	sub    $0x10,%rsp
  801458:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80145c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801460:	eb 0a                	jmp    80146c <strcmp+0x1c>
		p++, q++;
  801462:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801467:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80146c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801470:	0f b6 00             	movzbl (%rax),%eax
  801473:	84 c0                	test   %al,%al
  801475:	74 12                	je     801489 <strcmp+0x39>
  801477:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147b:	0f b6 10             	movzbl (%rax),%edx
  80147e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801482:	0f b6 00             	movzbl (%rax),%eax
  801485:	38 c2                	cmp    %al,%dl
  801487:	74 d9                	je     801462 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801489:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148d:	0f b6 00             	movzbl (%rax),%eax
  801490:	0f b6 d0             	movzbl %al,%edx
  801493:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801497:	0f b6 00             	movzbl (%rax),%eax
  80149a:	0f b6 c0             	movzbl %al,%eax
  80149d:	29 c2                	sub    %eax,%edx
  80149f:	89 d0                	mov    %edx,%eax
}
  8014a1:	c9                   	leaveq 
  8014a2:	c3                   	retq   

00000000008014a3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014a3:	55                   	push   %rbp
  8014a4:	48 89 e5             	mov    %rsp,%rbp
  8014a7:	48 83 ec 18          	sub    $0x18,%rsp
  8014ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014b7:	eb 0f                	jmp    8014c8 <strncmp+0x25>
		n--, p++, q++;
  8014b9:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014be:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014c3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014c8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014cd:	74 1d                	je     8014ec <strncmp+0x49>
  8014cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d3:	0f b6 00             	movzbl (%rax),%eax
  8014d6:	84 c0                	test   %al,%al
  8014d8:	74 12                	je     8014ec <strncmp+0x49>
  8014da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014de:	0f b6 10             	movzbl (%rax),%edx
  8014e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e5:	0f b6 00             	movzbl (%rax),%eax
  8014e8:	38 c2                	cmp    %al,%dl
  8014ea:	74 cd                	je     8014b9 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014ec:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014f1:	75 07                	jne    8014fa <strncmp+0x57>
		return 0;
  8014f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f8:	eb 18                	jmp    801512 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fe:	0f b6 00             	movzbl (%rax),%eax
  801501:	0f b6 d0             	movzbl %al,%edx
  801504:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801508:	0f b6 00             	movzbl (%rax),%eax
  80150b:	0f b6 c0             	movzbl %al,%eax
  80150e:	29 c2                	sub    %eax,%edx
  801510:	89 d0                	mov    %edx,%eax
}
  801512:	c9                   	leaveq 
  801513:	c3                   	retq   

0000000000801514 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801514:	55                   	push   %rbp
  801515:	48 89 e5             	mov    %rsp,%rbp
  801518:	48 83 ec 10          	sub    $0x10,%rsp
  80151c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801520:	89 f0                	mov    %esi,%eax
  801522:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801525:	eb 17                	jmp    80153e <strchr+0x2a>
		if (*s == c)
  801527:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152b:	0f b6 00             	movzbl (%rax),%eax
  80152e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801531:	75 06                	jne    801539 <strchr+0x25>
			return (char *) s;
  801533:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801537:	eb 15                	jmp    80154e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801539:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80153e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801542:	0f b6 00             	movzbl (%rax),%eax
  801545:	84 c0                	test   %al,%al
  801547:	75 de                	jne    801527 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801549:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154e:	c9                   	leaveq 
  80154f:	c3                   	retq   

0000000000801550 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801550:	55                   	push   %rbp
  801551:	48 89 e5             	mov    %rsp,%rbp
  801554:	48 83 ec 10          	sub    $0x10,%rsp
  801558:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80155c:	89 f0                	mov    %esi,%eax
  80155e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801561:	eb 11                	jmp    801574 <strfind+0x24>
		if (*s == c)
  801563:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801567:	0f b6 00             	movzbl (%rax),%eax
  80156a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80156d:	74 12                	je     801581 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80156f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801574:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801578:	0f b6 00             	movzbl (%rax),%eax
  80157b:	84 c0                	test   %al,%al
  80157d:	75 e4                	jne    801563 <strfind+0x13>
  80157f:	eb 01                	jmp    801582 <strfind+0x32>
		if (*s == c)
			break;
  801581:	90                   	nop
	return (char *) s;
  801582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801586:	c9                   	leaveq 
  801587:	c3                   	retq   

0000000000801588 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801588:	55                   	push   %rbp
  801589:	48 89 e5             	mov    %rsp,%rbp
  80158c:	48 83 ec 18          	sub    $0x18,%rsp
  801590:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801594:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801597:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80159b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015a0:	75 06                	jne    8015a8 <memset+0x20>
		return v;
  8015a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a6:	eb 69                	jmp    801611 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ac:	83 e0 03             	and    $0x3,%eax
  8015af:	48 85 c0             	test   %rax,%rax
  8015b2:	75 48                	jne    8015fc <memset+0x74>
  8015b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b8:	83 e0 03             	and    $0x3,%eax
  8015bb:	48 85 c0             	test   %rax,%rax
  8015be:	75 3c                	jne    8015fc <memset+0x74>
		c &= 0xFF;
  8015c0:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015c7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ca:	c1 e0 18             	shl    $0x18,%eax
  8015cd:	89 c2                	mov    %eax,%edx
  8015cf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015d2:	c1 e0 10             	shl    $0x10,%eax
  8015d5:	09 c2                	or     %eax,%edx
  8015d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015da:	c1 e0 08             	shl    $0x8,%eax
  8015dd:	09 d0                	or     %edx,%eax
  8015df:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e6:	48 c1 e8 02          	shr    $0x2,%rax
  8015ea:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f4:	48 89 d7             	mov    %rdx,%rdi
  8015f7:	fc                   	cld    
  8015f8:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015fa:	eb 11                	jmp    80160d <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801600:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801603:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801607:	48 89 d7             	mov    %rdx,%rdi
  80160a:	fc                   	cld    
  80160b:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80160d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801611:	c9                   	leaveq 
  801612:	c3                   	retq   

0000000000801613 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801613:	55                   	push   %rbp
  801614:	48 89 e5             	mov    %rsp,%rbp
  801617:	48 83 ec 28          	sub    $0x28,%rsp
  80161b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80161f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801623:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801627:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80162b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80162f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801633:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801637:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80163b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80163f:	0f 83 88 00 00 00    	jae    8016cd <memmove+0xba>
  801645:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801649:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164d:	48 01 d0             	add    %rdx,%rax
  801650:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801654:	76 77                	jbe    8016cd <memmove+0xba>
		s += n;
  801656:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80165e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801662:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801666:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166a:	83 e0 03             	and    $0x3,%eax
  80166d:	48 85 c0             	test   %rax,%rax
  801670:	75 3b                	jne    8016ad <memmove+0x9a>
  801672:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801676:	83 e0 03             	and    $0x3,%eax
  801679:	48 85 c0             	test   %rax,%rax
  80167c:	75 2f                	jne    8016ad <memmove+0x9a>
  80167e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801682:	83 e0 03             	and    $0x3,%eax
  801685:	48 85 c0             	test   %rax,%rax
  801688:	75 23                	jne    8016ad <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80168a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80168e:	48 83 e8 04          	sub    $0x4,%rax
  801692:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801696:	48 83 ea 04          	sub    $0x4,%rdx
  80169a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80169e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016a2:	48 89 c7             	mov    %rax,%rdi
  8016a5:	48 89 d6             	mov    %rdx,%rsi
  8016a8:	fd                   	std    
  8016a9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016ab:	eb 1d                	jmp    8016ca <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b9:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c1:	48 89 d7             	mov    %rdx,%rdi
  8016c4:	48 89 c1             	mov    %rax,%rcx
  8016c7:	fd                   	std    
  8016c8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016ca:	fc                   	cld    
  8016cb:	eb 57                	jmp    801724 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d1:	83 e0 03             	and    $0x3,%eax
  8016d4:	48 85 c0             	test   %rax,%rax
  8016d7:	75 36                	jne    80170f <memmove+0xfc>
  8016d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016dd:	83 e0 03             	and    $0x3,%eax
  8016e0:	48 85 c0             	test   %rax,%rax
  8016e3:	75 2a                	jne    80170f <memmove+0xfc>
  8016e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e9:	83 e0 03             	and    $0x3,%eax
  8016ec:	48 85 c0             	test   %rax,%rax
  8016ef:	75 1e                	jne    80170f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f5:	48 c1 e8 02          	shr    $0x2,%rax
  8016f9:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801700:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801704:	48 89 c7             	mov    %rax,%rdi
  801707:	48 89 d6             	mov    %rdx,%rsi
  80170a:	fc                   	cld    
  80170b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80170d:	eb 15                	jmp    801724 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80170f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801713:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801717:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80171b:	48 89 c7             	mov    %rax,%rdi
  80171e:	48 89 d6             	mov    %rdx,%rsi
  801721:	fc                   	cld    
  801722:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801724:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801728:	c9                   	leaveq 
  801729:	c3                   	retq   

000000000080172a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80172a:	55                   	push   %rbp
  80172b:	48 89 e5             	mov    %rsp,%rbp
  80172e:	48 83 ec 18          	sub    $0x18,%rsp
  801732:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801736:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80173a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80173e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801742:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801746:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80174a:	48 89 ce             	mov    %rcx,%rsi
  80174d:	48 89 c7             	mov    %rax,%rdi
  801750:	48 b8 13 16 80 00 00 	movabs $0x801613,%rax
  801757:	00 00 00 
  80175a:	ff d0                	callq  *%rax
}
  80175c:	c9                   	leaveq 
  80175d:	c3                   	retq   

000000000080175e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80175e:	55                   	push   %rbp
  80175f:	48 89 e5             	mov    %rsp,%rbp
  801762:	48 83 ec 28          	sub    $0x28,%rsp
  801766:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80176a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80176e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801776:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80177a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80177e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801782:	eb 36                	jmp    8017ba <memcmp+0x5c>
		if (*s1 != *s2)
  801784:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801788:	0f b6 10             	movzbl (%rax),%edx
  80178b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80178f:	0f b6 00             	movzbl (%rax),%eax
  801792:	38 c2                	cmp    %al,%dl
  801794:	74 1a                	je     8017b0 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801796:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80179a:	0f b6 00             	movzbl (%rax),%eax
  80179d:	0f b6 d0             	movzbl %al,%edx
  8017a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a4:	0f b6 00             	movzbl (%rax),%eax
  8017a7:	0f b6 c0             	movzbl %al,%eax
  8017aa:	29 c2                	sub    %eax,%edx
  8017ac:	89 d0                	mov    %edx,%eax
  8017ae:	eb 20                	jmp    8017d0 <memcmp+0x72>
		s1++, s2++;
  8017b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017b5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017be:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017c6:	48 85 c0             	test   %rax,%rax
  8017c9:	75 b9                	jne    801784 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d0:	c9                   	leaveq 
  8017d1:	c3                   	retq   

00000000008017d2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017d2:	55                   	push   %rbp
  8017d3:	48 89 e5             	mov    %rsp,%rbp
  8017d6:	48 83 ec 28          	sub    $0x28,%rsp
  8017da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017de:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ed:	48 01 d0             	add    %rdx,%rax
  8017f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017f4:	eb 19                	jmp    80180f <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017fa:	0f b6 00             	movzbl (%rax),%eax
  8017fd:	0f b6 d0             	movzbl %al,%edx
  801800:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801803:	0f b6 c0             	movzbl %al,%eax
  801806:	39 c2                	cmp    %eax,%edx
  801808:	74 11                	je     80181b <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80180a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80180f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801813:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801817:	72 dd                	jb     8017f6 <memfind+0x24>
  801819:	eb 01                	jmp    80181c <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80181b:	90                   	nop
	return (void *) s;
  80181c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801820:	c9                   	leaveq 
  801821:	c3                   	retq   

0000000000801822 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801822:	55                   	push   %rbp
  801823:	48 89 e5             	mov    %rsp,%rbp
  801826:	48 83 ec 38          	sub    $0x38,%rsp
  80182a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80182e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801832:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801835:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80183c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801843:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801844:	eb 05                	jmp    80184b <strtol+0x29>
		s++;
  801846:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80184b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184f:	0f b6 00             	movzbl (%rax),%eax
  801852:	3c 20                	cmp    $0x20,%al
  801854:	74 f0                	je     801846 <strtol+0x24>
  801856:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185a:	0f b6 00             	movzbl (%rax),%eax
  80185d:	3c 09                	cmp    $0x9,%al
  80185f:	74 e5                	je     801846 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801861:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801865:	0f b6 00             	movzbl (%rax),%eax
  801868:	3c 2b                	cmp    $0x2b,%al
  80186a:	75 07                	jne    801873 <strtol+0x51>
		s++;
  80186c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801871:	eb 17                	jmp    80188a <strtol+0x68>
	else if (*s == '-')
  801873:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801877:	0f b6 00             	movzbl (%rax),%eax
  80187a:	3c 2d                	cmp    $0x2d,%al
  80187c:	75 0c                	jne    80188a <strtol+0x68>
		s++, neg = 1;
  80187e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801883:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80188a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80188e:	74 06                	je     801896 <strtol+0x74>
  801890:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801894:	75 28                	jne    8018be <strtol+0x9c>
  801896:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189a:	0f b6 00             	movzbl (%rax),%eax
  80189d:	3c 30                	cmp    $0x30,%al
  80189f:	75 1d                	jne    8018be <strtol+0x9c>
  8018a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a5:	48 83 c0 01          	add    $0x1,%rax
  8018a9:	0f b6 00             	movzbl (%rax),%eax
  8018ac:	3c 78                	cmp    $0x78,%al
  8018ae:	75 0e                	jne    8018be <strtol+0x9c>
		s += 2, base = 16;
  8018b0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018b5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018bc:	eb 2c                	jmp    8018ea <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018be:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018c2:	75 19                	jne    8018dd <strtol+0xbb>
  8018c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c8:	0f b6 00             	movzbl (%rax),%eax
  8018cb:	3c 30                	cmp    $0x30,%al
  8018cd:	75 0e                	jne    8018dd <strtol+0xbb>
		s++, base = 8;
  8018cf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018d4:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018db:	eb 0d                	jmp    8018ea <strtol+0xc8>
	else if (base == 0)
  8018dd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018e1:	75 07                	jne    8018ea <strtol+0xc8>
		base = 10;
  8018e3:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ee:	0f b6 00             	movzbl (%rax),%eax
  8018f1:	3c 2f                	cmp    $0x2f,%al
  8018f3:	7e 1d                	jle    801912 <strtol+0xf0>
  8018f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f9:	0f b6 00             	movzbl (%rax),%eax
  8018fc:	3c 39                	cmp    $0x39,%al
  8018fe:	7f 12                	jg     801912 <strtol+0xf0>
			dig = *s - '0';
  801900:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801904:	0f b6 00             	movzbl (%rax),%eax
  801907:	0f be c0             	movsbl %al,%eax
  80190a:	83 e8 30             	sub    $0x30,%eax
  80190d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801910:	eb 4e                	jmp    801960 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801912:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801916:	0f b6 00             	movzbl (%rax),%eax
  801919:	3c 60                	cmp    $0x60,%al
  80191b:	7e 1d                	jle    80193a <strtol+0x118>
  80191d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801921:	0f b6 00             	movzbl (%rax),%eax
  801924:	3c 7a                	cmp    $0x7a,%al
  801926:	7f 12                	jg     80193a <strtol+0x118>
			dig = *s - 'a' + 10;
  801928:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192c:	0f b6 00             	movzbl (%rax),%eax
  80192f:	0f be c0             	movsbl %al,%eax
  801932:	83 e8 57             	sub    $0x57,%eax
  801935:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801938:	eb 26                	jmp    801960 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80193a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193e:	0f b6 00             	movzbl (%rax),%eax
  801941:	3c 40                	cmp    $0x40,%al
  801943:	7e 47                	jle    80198c <strtol+0x16a>
  801945:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801949:	0f b6 00             	movzbl (%rax),%eax
  80194c:	3c 5a                	cmp    $0x5a,%al
  80194e:	7f 3c                	jg     80198c <strtol+0x16a>
			dig = *s - 'A' + 10;
  801950:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801954:	0f b6 00             	movzbl (%rax),%eax
  801957:	0f be c0             	movsbl %al,%eax
  80195a:	83 e8 37             	sub    $0x37,%eax
  80195d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801960:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801963:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801966:	7d 23                	jge    80198b <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801968:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80196d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801970:	48 98                	cltq   
  801972:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801977:	48 89 c2             	mov    %rax,%rdx
  80197a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80197d:	48 98                	cltq   
  80197f:	48 01 d0             	add    %rdx,%rax
  801982:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801986:	e9 5f ff ff ff       	jmpq   8018ea <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80198b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80198c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801991:	74 0b                	je     80199e <strtol+0x17c>
		*endptr = (char *) s;
  801993:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801997:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80199b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80199e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019a2:	74 09                	je     8019ad <strtol+0x18b>
  8019a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a8:	48 f7 d8             	neg    %rax
  8019ab:	eb 04                	jmp    8019b1 <strtol+0x18f>
  8019ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019b1:	c9                   	leaveq 
  8019b2:	c3                   	retq   

00000000008019b3 <strstr>:

char * strstr(const char *in, const char *str)
{
  8019b3:	55                   	push   %rbp
  8019b4:	48 89 e5             	mov    %rsp,%rbp
  8019b7:	48 83 ec 30          	sub    $0x30,%rsp
  8019bb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019bf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019c7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019cb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019cf:	0f b6 00             	movzbl (%rax),%eax
  8019d2:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019d5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019d9:	75 06                	jne    8019e1 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019df:	eb 6b                	jmp    801a4c <strstr+0x99>

	len = strlen(str);
  8019e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019e5:	48 89 c7             	mov    %rax,%rdi
  8019e8:	48 b8 82 12 80 00 00 	movabs $0x801282,%rax
  8019ef:	00 00 00 
  8019f2:	ff d0                	callq  *%rax
  8019f4:	48 98                	cltq   
  8019f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fe:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a02:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a06:	0f b6 00             	movzbl (%rax),%eax
  801a09:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a0c:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a10:	75 07                	jne    801a19 <strstr+0x66>
				return (char *) 0;
  801a12:	b8 00 00 00 00       	mov    $0x0,%eax
  801a17:	eb 33                	jmp    801a4c <strstr+0x99>
		} while (sc != c);
  801a19:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a1d:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a20:	75 d8                	jne    8019fa <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a26:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2e:	48 89 ce             	mov    %rcx,%rsi
  801a31:	48 89 c7             	mov    %rax,%rdi
  801a34:	48 b8 a3 14 80 00 00 	movabs $0x8014a3,%rax
  801a3b:	00 00 00 
  801a3e:	ff d0                	callq  *%rax
  801a40:	85 c0                	test   %eax,%eax
  801a42:	75 b6                	jne    8019fa <strstr+0x47>

	return (char *) (in - 1);
  801a44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a48:	48 83 e8 01          	sub    $0x1,%rax
}
  801a4c:	c9                   	leaveq 
  801a4d:	c3                   	retq   
