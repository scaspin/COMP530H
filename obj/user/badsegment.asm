
obj/user/badsegment:     file format elf64-x86-64


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
  80003c:	e8 1a 00 00 00       	callq  80005b <libmain>
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
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800052:	66 b8 28 00          	mov    $0x28,%ax
  800056:	8e d8                	mov    %eax,%ds
}
  800058:	90                   	nop
  800059:	c9                   	leaveq 
  80005a:	c3                   	retq   

000000000080005b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005b:	55                   	push   %rbp
  80005c:	48 89 e5             	mov    %rsp,%rbp
  80005f:	48 83 ec 10          	sub    $0x10,%rsp
  800063:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800066:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  80006a:	48 b8 5c 02 80 00 00 	movabs $0x80025c,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007b:	48 63 d0             	movslq %eax,%rdx
  80007e:	48 89 d0             	mov    %rdx,%rax
  800081:	48 c1 e0 03          	shl    $0x3,%rax
  800085:	48 01 d0             	add    %rdx,%rax
  800088:	48 c1 e0 05          	shl    $0x5,%rax
  80008c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800093:	00 00 00 
  800096:	48 01 c2             	add    %rax,%rdx
  800099:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000a0:	00 00 00 
  8000a3:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000aa:	7e 14                	jle    8000c0 <libmain+0x65>
		binaryname = argv[0];
  8000ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000b0:	48 8b 10             	mov    (%rax),%rdx
  8000b3:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000ba:	00 00 00 
  8000bd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c7:	48 89 d6             	mov    %rdx,%rsi
  8000ca:	89 c7                	mov    %eax,%edi
  8000cc:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000d3:	00 00 00 
  8000d6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000d8:	48 b8 e7 00 80 00 00 	movabs $0x8000e7,%rax
  8000df:	00 00 00 
  8000e2:	ff d0                	callq  *%rax
}
  8000e4:	90                   	nop
  8000e5:	c9                   	leaveq 
  8000e6:	c3                   	retq   

00000000008000e7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e7:	55                   	push   %rbp
  8000e8:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8000f0:	48 b8 16 02 80 00 00 	movabs $0x800216,%rax
  8000f7:	00 00 00 
  8000fa:	ff d0                	callq  *%rax
}
  8000fc:	90                   	nop
  8000fd:	5d                   	pop    %rbp
  8000fe:	c3                   	retq   

00000000008000ff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000ff:	55                   	push   %rbp
  800100:	48 89 e5             	mov    %rsp,%rbp
  800103:	53                   	push   %rbx
  800104:	48 83 ec 48          	sub    $0x48,%rsp
  800108:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80010b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80010e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800112:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800116:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80011a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80011e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800121:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800125:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800129:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80012d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800131:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800135:	4c 89 c3             	mov    %r8,%rbx
  800138:	cd 30                	int    $0x30
  80013a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80013e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800142:	74 3e                	je     800182 <syscall+0x83>
  800144:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800149:	7e 37                	jle    800182 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80014b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80014f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800152:	49 89 d0             	mov    %rdx,%r8
  800155:	89 c1                	mov    %eax,%ecx
  800157:	48 ba 4a 1a 80 00 00 	movabs $0x801a4a,%rdx
  80015e:	00 00 00 
  800161:	be 23 00 00 00       	mov    $0x23,%esi
  800166:	48 bf 67 1a 80 00 00 	movabs $0x801a67,%rdi
  80016d:	00 00 00 
  800170:	b8 00 00 00 00       	mov    $0x0,%eax
  800175:	49 b9 09 05 80 00 00 	movabs $0x800509,%r9
  80017c:	00 00 00 
  80017f:	41 ff d1             	callq  *%r9

	return ret;
  800182:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800186:	48 83 c4 48          	add    $0x48,%rsp
  80018a:	5b                   	pop    %rbx
  80018b:	5d                   	pop    %rbp
  80018c:	c3                   	retq   

000000000080018d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80018d:	55                   	push   %rbp
  80018e:	48 89 e5             	mov    %rsp,%rbp
  800191:	48 83 ec 10          	sub    $0x10,%rsp
  800195:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800199:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80019d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a5:	48 83 ec 08          	sub    $0x8,%rsp
  8001a9:	6a 00                	pushq  $0x0
  8001ab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001b7:	48 89 d1             	mov    %rdx,%rcx
  8001ba:	48 89 c2             	mov    %rax,%rdx
  8001bd:	be 00 00 00 00       	mov    $0x0,%esi
  8001c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8001c7:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  8001ce:	00 00 00 
  8001d1:	ff d0                	callq  *%rax
  8001d3:	48 83 c4 10          	add    $0x10,%rsp
}
  8001d7:	90                   	nop
  8001d8:	c9                   	leaveq 
  8001d9:	c3                   	retq   

00000000008001da <sys_cgetc>:

int
sys_cgetc(void)
{
  8001da:	55                   	push   %rbp
  8001db:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001de:	48 83 ec 08          	sub    $0x8,%rsp
  8001e2:	6a 00                	pushq  $0x0
  8001e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001fa:	be 00 00 00 00       	mov    $0x0,%esi
  8001ff:	bf 01 00 00 00       	mov    $0x1,%edi
  800204:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  80020b:	00 00 00 
  80020e:	ff d0                	callq  *%rax
  800210:	48 83 c4 10          	add    $0x10,%rsp
}
  800214:	c9                   	leaveq 
  800215:	c3                   	retq   

0000000000800216 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800216:	55                   	push   %rbp
  800217:	48 89 e5             	mov    %rsp,%rbp
  80021a:	48 83 ec 10          	sub    $0x10,%rsp
  80021e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800224:	48 98                	cltq   
  800226:	48 83 ec 08          	sub    $0x8,%rsp
  80022a:	6a 00                	pushq  $0x0
  80022c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800232:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800238:	b9 00 00 00 00       	mov    $0x0,%ecx
  80023d:	48 89 c2             	mov    %rax,%rdx
  800240:	be 01 00 00 00       	mov    $0x1,%esi
  800245:	bf 03 00 00 00       	mov    $0x3,%edi
  80024a:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  800251:	00 00 00 
  800254:	ff d0                	callq  *%rax
  800256:	48 83 c4 10          	add    $0x10,%rsp
}
  80025a:	c9                   	leaveq 
  80025b:	c3                   	retq   

000000000080025c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80025c:	55                   	push   %rbp
  80025d:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800260:	48 83 ec 08          	sub    $0x8,%rsp
  800264:	6a 00                	pushq  $0x0
  800266:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80026c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800272:	b9 00 00 00 00       	mov    $0x0,%ecx
  800277:	ba 00 00 00 00       	mov    $0x0,%edx
  80027c:	be 00 00 00 00       	mov    $0x0,%esi
  800281:	bf 02 00 00 00       	mov    $0x2,%edi
  800286:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  80028d:	00 00 00 
  800290:	ff d0                	callq  *%rax
  800292:	48 83 c4 10          	add    $0x10,%rsp
}
  800296:	c9                   	leaveq 
  800297:	c3                   	retq   

0000000000800298 <sys_yield>:

void
sys_yield(void)
{
  800298:	55                   	push   %rbp
  800299:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80029c:	48 83 ec 08          	sub    $0x8,%rsp
  8002a0:	6a 00                	pushq  $0x0
  8002a2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b8:	be 00 00 00 00       	mov    $0x0,%esi
  8002bd:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002c2:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  8002c9:	00 00 00 
  8002cc:	ff d0                	callq  *%rax
  8002ce:	48 83 c4 10          	add    $0x10,%rsp
}
  8002d2:	90                   	nop
  8002d3:	c9                   	leaveq 
  8002d4:	c3                   	retq   

00000000008002d5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002d5:	55                   	push   %rbp
  8002d6:	48 89 e5             	mov    %rsp,%rbp
  8002d9:	48 83 ec 10          	sub    $0x10,%rsp
  8002dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002e4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ea:	48 63 c8             	movslq %eax,%rcx
  8002ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002f4:	48 98                	cltq   
  8002f6:	48 83 ec 08          	sub    $0x8,%rsp
  8002fa:	6a 00                	pushq  $0x0
  8002fc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800302:	49 89 c8             	mov    %rcx,%r8
  800305:	48 89 d1             	mov    %rdx,%rcx
  800308:	48 89 c2             	mov    %rax,%rdx
  80030b:	be 01 00 00 00       	mov    $0x1,%esi
  800310:	bf 04 00 00 00       	mov    $0x4,%edi
  800315:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  80031c:	00 00 00 
  80031f:	ff d0                	callq  *%rax
  800321:	48 83 c4 10          	add    $0x10,%rsp
}
  800325:	c9                   	leaveq 
  800326:	c3                   	retq   

0000000000800327 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800327:	55                   	push   %rbp
  800328:	48 89 e5             	mov    %rsp,%rbp
  80032b:	48 83 ec 20          	sub    $0x20,%rsp
  80032f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800332:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800336:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800339:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80033d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800341:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800344:	48 63 c8             	movslq %eax,%rcx
  800347:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80034b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80034e:	48 63 f0             	movslq %eax,%rsi
  800351:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800355:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800358:	48 98                	cltq   
  80035a:	48 83 ec 08          	sub    $0x8,%rsp
  80035e:	51                   	push   %rcx
  80035f:	49 89 f9             	mov    %rdi,%r9
  800362:	49 89 f0             	mov    %rsi,%r8
  800365:	48 89 d1             	mov    %rdx,%rcx
  800368:	48 89 c2             	mov    %rax,%rdx
  80036b:	be 01 00 00 00       	mov    $0x1,%esi
  800370:	bf 05 00 00 00       	mov    $0x5,%edi
  800375:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  80037c:	00 00 00 
  80037f:	ff d0                	callq  *%rax
  800381:	48 83 c4 10          	add    $0x10,%rsp
}
  800385:	c9                   	leaveq 
  800386:	c3                   	retq   

0000000000800387 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800387:	55                   	push   %rbp
  800388:	48 89 e5             	mov    %rsp,%rbp
  80038b:	48 83 ec 10          	sub    $0x10,%rsp
  80038f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800392:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800396:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80039a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80039d:	48 98                	cltq   
  80039f:	48 83 ec 08          	sub    $0x8,%rsp
  8003a3:	6a 00                	pushq  $0x0
  8003a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003b1:	48 89 d1             	mov    %rdx,%rcx
  8003b4:	48 89 c2             	mov    %rax,%rdx
  8003b7:	be 01 00 00 00       	mov    $0x1,%esi
  8003bc:	bf 06 00 00 00       	mov    $0x6,%edi
  8003c1:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  8003c8:	00 00 00 
  8003cb:	ff d0                	callq  *%rax
  8003cd:	48 83 c4 10          	add    $0x10,%rsp
}
  8003d1:	c9                   	leaveq 
  8003d2:	c3                   	retq   

00000000008003d3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003d3:	55                   	push   %rbp
  8003d4:	48 89 e5             	mov    %rsp,%rbp
  8003d7:	48 83 ec 10          	sub    $0x10,%rsp
  8003db:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003de:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003e4:	48 63 d0             	movslq %eax,%rdx
  8003e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ea:	48 98                	cltq   
  8003ec:	48 83 ec 08          	sub    $0x8,%rsp
  8003f0:	6a 00                	pushq  $0x0
  8003f2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003fe:	48 89 d1             	mov    %rdx,%rcx
  800401:	48 89 c2             	mov    %rax,%rdx
  800404:	be 01 00 00 00       	mov    $0x1,%esi
  800409:	bf 08 00 00 00       	mov    $0x8,%edi
  80040e:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  800415:	00 00 00 
  800418:	ff d0                	callq  *%rax
  80041a:	48 83 c4 10          	add    $0x10,%rsp
}
  80041e:	c9                   	leaveq 
  80041f:	c3                   	retq   

0000000000800420 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800420:	55                   	push   %rbp
  800421:	48 89 e5             	mov    %rsp,%rbp
  800424:	48 83 ec 10          	sub    $0x10,%rsp
  800428:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80042b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80042f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800433:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800436:	48 98                	cltq   
  800438:	48 83 ec 08          	sub    $0x8,%rsp
  80043c:	6a 00                	pushq  $0x0
  80043e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800444:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80044a:	48 89 d1             	mov    %rdx,%rcx
  80044d:	48 89 c2             	mov    %rax,%rdx
  800450:	be 01 00 00 00       	mov    $0x1,%esi
  800455:	bf 09 00 00 00       	mov    $0x9,%edi
  80045a:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  800461:	00 00 00 
  800464:	ff d0                	callq  *%rax
  800466:	48 83 c4 10          	add    $0x10,%rsp
}
  80046a:	c9                   	leaveq 
  80046b:	c3                   	retq   

000000000080046c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80046c:	55                   	push   %rbp
  80046d:	48 89 e5             	mov    %rsp,%rbp
  800470:	48 83 ec 20          	sub    $0x20,%rsp
  800474:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800477:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80047b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80047f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800482:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800485:	48 63 f0             	movslq %eax,%rsi
  800488:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80048c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80048f:	48 98                	cltq   
  800491:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800495:	48 83 ec 08          	sub    $0x8,%rsp
  800499:	6a 00                	pushq  $0x0
  80049b:	49 89 f1             	mov    %rsi,%r9
  80049e:	49 89 c8             	mov    %rcx,%r8
  8004a1:	48 89 d1             	mov    %rdx,%rcx
  8004a4:	48 89 c2             	mov    %rax,%rdx
  8004a7:	be 00 00 00 00       	mov    $0x0,%esi
  8004ac:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004b1:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  8004b8:	00 00 00 
  8004bb:	ff d0                	callq  *%rax
  8004bd:	48 83 c4 10          	add    $0x10,%rsp
}
  8004c1:	c9                   	leaveq 
  8004c2:	c3                   	retq   

00000000008004c3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004c3:	55                   	push   %rbp
  8004c4:	48 89 e5             	mov    %rsp,%rbp
  8004c7:	48 83 ec 10          	sub    $0x10,%rsp
  8004cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004d3:	48 83 ec 08          	sub    $0x8,%rsp
  8004d7:	6a 00                	pushq  $0x0
  8004d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004ea:	48 89 c2             	mov    %rax,%rdx
  8004ed:	be 01 00 00 00       	mov    $0x1,%esi
  8004f2:	bf 0c 00 00 00       	mov    $0xc,%edi
  8004f7:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  8004fe:	00 00 00 
  800501:	ff d0                	callq  *%rax
  800503:	48 83 c4 10          	add    $0x10,%rsp
}
  800507:	c9                   	leaveq 
  800508:	c3                   	retq   

0000000000800509 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800509:	55                   	push   %rbp
  80050a:	48 89 e5             	mov    %rsp,%rbp
  80050d:	53                   	push   %rbx
  80050e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800515:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80051c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800522:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800529:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800530:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800537:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80053e:	84 c0                	test   %al,%al
  800540:	74 23                	je     800565 <_panic+0x5c>
  800542:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800549:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80054d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800551:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800555:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800559:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80055d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800561:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800565:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80056c:	00 00 00 
  80056f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800576:	00 00 00 
  800579:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80057d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800584:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80058b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800592:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800599:	00 00 00 
  80059c:	48 8b 18             	mov    (%rax),%rbx
  80059f:	48 b8 5c 02 80 00 00 	movabs $0x80025c,%rax
  8005a6:	00 00 00 
  8005a9:	ff d0                	callq  *%rax
  8005ab:	89 c6                	mov    %eax,%esi
  8005ad:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8005b3:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8005ba:	41 89 d0             	mov    %edx,%r8d
  8005bd:	48 89 c1             	mov    %rax,%rcx
  8005c0:	48 89 da             	mov    %rbx,%rdx
  8005c3:	48 bf 78 1a 80 00 00 	movabs $0x801a78,%rdi
  8005ca:	00 00 00 
  8005cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d2:	49 b9 43 07 80 00 00 	movabs $0x800743,%r9
  8005d9:	00 00 00 
  8005dc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005df:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005e6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005ed:	48 89 d6             	mov    %rdx,%rsi
  8005f0:	48 89 c7             	mov    %rax,%rdi
  8005f3:	48 b8 97 06 80 00 00 	movabs $0x800697,%rax
  8005fa:	00 00 00 
  8005fd:	ff d0                	callq  *%rax
	cprintf("\n");
  8005ff:	48 bf 9b 1a 80 00 00 	movabs $0x801a9b,%rdi
  800606:	00 00 00 
  800609:	b8 00 00 00 00       	mov    $0x0,%eax
  80060e:	48 ba 43 07 80 00 00 	movabs $0x800743,%rdx
  800615:	00 00 00 
  800618:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80061a:	cc                   	int3   
  80061b:	eb fd                	jmp    80061a <_panic+0x111>

000000000080061d <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80061d:	55                   	push   %rbp
  80061e:	48 89 e5             	mov    %rsp,%rbp
  800621:	48 83 ec 10          	sub    $0x10,%rsp
  800625:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800628:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80062c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800630:	8b 00                	mov    (%rax),%eax
  800632:	8d 48 01             	lea    0x1(%rax),%ecx
  800635:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800639:	89 0a                	mov    %ecx,(%rdx)
  80063b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80063e:	89 d1                	mov    %edx,%ecx
  800640:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800644:	48 98                	cltq   
  800646:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80064a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80064e:	8b 00                	mov    (%rax),%eax
  800650:	3d ff 00 00 00       	cmp    $0xff,%eax
  800655:	75 2c                	jne    800683 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800657:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80065b:	8b 00                	mov    (%rax),%eax
  80065d:	48 98                	cltq   
  80065f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800663:	48 83 c2 08          	add    $0x8,%rdx
  800667:	48 89 c6             	mov    %rax,%rsi
  80066a:	48 89 d7             	mov    %rdx,%rdi
  80066d:	48 b8 8d 01 80 00 00 	movabs $0x80018d,%rax
  800674:	00 00 00 
  800677:	ff d0                	callq  *%rax
        b->idx = 0;
  800679:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80067d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800683:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800687:	8b 40 04             	mov    0x4(%rax),%eax
  80068a:	8d 50 01             	lea    0x1(%rax),%edx
  80068d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800691:	89 50 04             	mov    %edx,0x4(%rax)
}
  800694:	90                   	nop
  800695:	c9                   	leaveq 
  800696:	c3                   	retq   

0000000000800697 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800697:	55                   	push   %rbp
  800698:	48 89 e5             	mov    %rsp,%rbp
  80069b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006a2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006a9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006b0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006b7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006be:	48 8b 0a             	mov    (%rdx),%rcx
  8006c1:	48 89 08             	mov    %rcx,(%rax)
  8006c4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006c8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006cc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006d0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006db:	00 00 00 
    b.cnt = 0;
  8006de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006e5:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006e8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006ef:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006f6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006fd:	48 89 c6             	mov    %rax,%rsi
  800700:	48 bf 1d 06 80 00 00 	movabs $0x80061d,%rdi
  800707:	00 00 00 
  80070a:	48 b8 e1 0a 80 00 00 	movabs $0x800ae1,%rax
  800711:	00 00 00 
  800714:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800716:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80071c:	48 98                	cltq   
  80071e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800725:	48 83 c2 08          	add    $0x8,%rdx
  800729:	48 89 c6             	mov    %rax,%rsi
  80072c:	48 89 d7             	mov    %rdx,%rdi
  80072f:	48 b8 8d 01 80 00 00 	movabs $0x80018d,%rax
  800736:	00 00 00 
  800739:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80073b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800741:	c9                   	leaveq 
  800742:	c3                   	retq   

0000000000800743 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800743:	55                   	push   %rbp
  800744:	48 89 e5             	mov    %rsp,%rbp
  800747:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80074e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800755:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80075c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800763:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80076a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800771:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800778:	84 c0                	test   %al,%al
  80077a:	74 20                	je     80079c <cprintf+0x59>
  80077c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800780:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800784:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800788:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80078c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800790:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800794:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800798:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80079c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007a3:	00 00 00 
  8007a6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007ad:	00 00 00 
  8007b0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007b4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007bb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007c2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007c9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007d0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007d7:	48 8b 0a             	mov    (%rdx),%rcx
  8007da:	48 89 08             	mov    %rcx,(%rax)
  8007dd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007e1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007e5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007e9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007ed:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007f4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007fb:	48 89 d6             	mov    %rdx,%rsi
  8007fe:	48 89 c7             	mov    %rax,%rdi
  800801:	48 b8 97 06 80 00 00 	movabs $0x800697,%rax
  800808:	00 00 00 
  80080b:	ff d0                	callq  *%rax
  80080d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800813:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800819:	c9                   	leaveq 
  80081a:	c3                   	retq   

000000000080081b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80081b:	55                   	push   %rbp
  80081c:	48 89 e5             	mov    %rsp,%rbp
  80081f:	48 83 ec 30          	sub    $0x30,%rsp
  800823:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800827:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80082b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80082f:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800832:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800836:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80083a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80083d:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800841:	77 54                	ja     800897 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800843:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800846:	8d 78 ff             	lea    -0x1(%rax),%edi
  800849:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80084c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800850:	ba 00 00 00 00       	mov    $0x0,%edx
  800855:	48 f7 f6             	div    %rsi
  800858:	49 89 c2             	mov    %rax,%r10
  80085b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80085e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800861:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800865:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800869:	41 89 c9             	mov    %ecx,%r9d
  80086c:	41 89 f8             	mov    %edi,%r8d
  80086f:	89 d1                	mov    %edx,%ecx
  800871:	4c 89 d2             	mov    %r10,%rdx
  800874:	48 89 c7             	mov    %rax,%rdi
  800877:	48 b8 1b 08 80 00 00 	movabs $0x80081b,%rax
  80087e:	00 00 00 
  800881:	ff d0                	callq  *%rax
  800883:	eb 1c                	jmp    8008a1 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800885:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800889:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80088c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800890:	48 89 ce             	mov    %rcx,%rsi
  800893:	89 d7                	mov    %edx,%edi
  800895:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800897:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80089b:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80089f:	7f e4                	jg     800885 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008a1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8008a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ad:	48 f7 f1             	div    %rcx
  8008b0:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  8008b7:	00 00 00 
  8008ba:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8008be:	0f be d0             	movsbl %al,%edx
  8008c1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8008c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008c9:	48 89 ce             	mov    %rcx,%rsi
  8008cc:	89 d7                	mov    %edx,%edi
  8008ce:	ff d0                	callq  *%rax
}
  8008d0:	90                   	nop
  8008d1:	c9                   	leaveq 
  8008d2:	c3                   	retq   

00000000008008d3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008d3:	55                   	push   %rbp
  8008d4:	48 89 e5             	mov    %rsp,%rbp
  8008d7:	48 83 ec 20          	sub    $0x20,%rsp
  8008db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008df:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008e2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008e6:	7e 4f                	jle    800937 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8008e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ec:	8b 00                	mov    (%rax),%eax
  8008ee:	83 f8 30             	cmp    $0x30,%eax
  8008f1:	73 24                	jae    800917 <getuint+0x44>
  8008f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ff:	8b 00                	mov    (%rax),%eax
  800901:	89 c0                	mov    %eax,%eax
  800903:	48 01 d0             	add    %rdx,%rax
  800906:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090a:	8b 12                	mov    (%rdx),%edx
  80090c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80090f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800913:	89 0a                	mov    %ecx,(%rdx)
  800915:	eb 14                	jmp    80092b <getuint+0x58>
  800917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80091f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800923:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800927:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80092b:	48 8b 00             	mov    (%rax),%rax
  80092e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800932:	e9 9d 00 00 00       	jmpq   8009d4 <getuint+0x101>
	else if (lflag)
  800937:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80093b:	74 4c                	je     800989 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80093d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800941:	8b 00                	mov    (%rax),%eax
  800943:	83 f8 30             	cmp    $0x30,%eax
  800946:	73 24                	jae    80096c <getuint+0x99>
  800948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800954:	8b 00                	mov    (%rax),%eax
  800956:	89 c0                	mov    %eax,%eax
  800958:	48 01 d0             	add    %rdx,%rax
  80095b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095f:	8b 12                	mov    (%rdx),%edx
  800961:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800964:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800968:	89 0a                	mov    %ecx,(%rdx)
  80096a:	eb 14                	jmp    800980 <getuint+0xad>
  80096c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800970:	48 8b 40 08          	mov    0x8(%rax),%rax
  800974:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800978:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800980:	48 8b 00             	mov    (%rax),%rax
  800983:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800987:	eb 4b                	jmp    8009d4 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800989:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098d:	8b 00                	mov    (%rax),%eax
  80098f:	83 f8 30             	cmp    $0x30,%eax
  800992:	73 24                	jae    8009b8 <getuint+0xe5>
  800994:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800998:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80099c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a0:	8b 00                	mov    (%rax),%eax
  8009a2:	89 c0                	mov    %eax,%eax
  8009a4:	48 01 d0             	add    %rdx,%rax
  8009a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ab:	8b 12                	mov    (%rdx),%edx
  8009ad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b4:	89 0a                	mov    %ecx,(%rdx)
  8009b6:	eb 14                	jmp    8009cc <getuint+0xf9>
  8009b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bc:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009c0:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009cc:	8b 00                	mov    (%rax),%eax
  8009ce:	89 c0                	mov    %eax,%eax
  8009d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009d8:	c9                   	leaveq 
  8009d9:	c3                   	retq   

00000000008009da <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009da:	55                   	push   %rbp
  8009db:	48 89 e5             	mov    %rsp,%rbp
  8009de:	48 83 ec 20          	sub    $0x20,%rsp
  8009e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009e6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009e9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009ed:	7e 4f                	jle    800a3e <getint+0x64>
		x=va_arg(*ap, long long);
  8009ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f3:	8b 00                	mov    (%rax),%eax
  8009f5:	83 f8 30             	cmp    $0x30,%eax
  8009f8:	73 24                	jae    800a1e <getint+0x44>
  8009fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009fe:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a06:	8b 00                	mov    (%rax),%eax
  800a08:	89 c0                	mov    %eax,%eax
  800a0a:	48 01 d0             	add    %rdx,%rax
  800a0d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a11:	8b 12                	mov    (%rdx),%edx
  800a13:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1a:	89 0a                	mov    %ecx,(%rdx)
  800a1c:	eb 14                	jmp    800a32 <getint+0x58>
  800a1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a22:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a26:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a2a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a32:	48 8b 00             	mov    (%rax),%rax
  800a35:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a39:	e9 9d 00 00 00       	jmpq   800adb <getint+0x101>
	else if (lflag)
  800a3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a42:	74 4c                	je     800a90 <getint+0xb6>
		x=va_arg(*ap, long);
  800a44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a48:	8b 00                	mov    (%rax),%eax
  800a4a:	83 f8 30             	cmp    $0x30,%eax
  800a4d:	73 24                	jae    800a73 <getint+0x99>
  800a4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a53:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5b:	8b 00                	mov    (%rax),%eax
  800a5d:	89 c0                	mov    %eax,%eax
  800a5f:	48 01 d0             	add    %rdx,%rax
  800a62:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a66:	8b 12                	mov    (%rdx),%edx
  800a68:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6f:	89 0a                	mov    %ecx,(%rdx)
  800a71:	eb 14                	jmp    800a87 <getint+0xad>
  800a73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a77:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a7b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a83:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a87:	48 8b 00             	mov    (%rax),%rax
  800a8a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a8e:	eb 4b                	jmp    800adb <getint+0x101>
	else
		x=va_arg(*ap, int);
  800a90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a94:	8b 00                	mov    (%rax),%eax
  800a96:	83 f8 30             	cmp    $0x30,%eax
  800a99:	73 24                	jae    800abf <getint+0xe5>
  800a9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800aa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa7:	8b 00                	mov    (%rax),%eax
  800aa9:	89 c0                	mov    %eax,%eax
  800aab:	48 01 d0             	add    %rdx,%rax
  800aae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab2:	8b 12                	mov    (%rdx),%edx
  800ab4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ab7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abb:	89 0a                	mov    %ecx,(%rdx)
  800abd:	eb 14                	jmp    800ad3 <getint+0xf9>
  800abf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac3:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ac7:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800acb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800acf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ad3:	8b 00                	mov    (%rax),%eax
  800ad5:	48 98                	cltq   
  800ad7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800adb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800adf:	c9                   	leaveq 
  800ae0:	c3                   	retq   

0000000000800ae1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ae1:	55                   	push   %rbp
  800ae2:	48 89 e5             	mov    %rsp,%rbp
  800ae5:	41 54                	push   %r12
  800ae7:	53                   	push   %rbx
  800ae8:	48 83 ec 60          	sub    $0x60,%rsp
  800aec:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800af0:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800af4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800af8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800afc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b00:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b04:	48 8b 0a             	mov    (%rdx),%rcx
  800b07:	48 89 08             	mov    %rcx,(%rax)
  800b0a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b0e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b12:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b16:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b1a:	eb 17                	jmp    800b33 <vprintfmt+0x52>
			if (ch == '\0')
  800b1c:	85 db                	test   %ebx,%ebx
  800b1e:	0f 84 b9 04 00 00    	je     800fdd <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800b24:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2c:	48 89 d6             	mov    %rdx,%rsi
  800b2f:	89 df                	mov    %ebx,%edi
  800b31:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b33:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b37:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b3b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b3f:	0f b6 00             	movzbl (%rax),%eax
  800b42:	0f b6 d8             	movzbl %al,%ebx
  800b45:	83 fb 25             	cmp    $0x25,%ebx
  800b48:	75 d2                	jne    800b1c <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b4a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b4e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b55:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b5c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b63:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b6a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b6e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b72:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b76:	0f b6 00             	movzbl (%rax),%eax
  800b79:	0f b6 d8             	movzbl %al,%ebx
  800b7c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b7f:	83 f8 55             	cmp    $0x55,%eax
  800b82:	0f 87 22 04 00 00    	ja     800faa <vprintfmt+0x4c9>
  800b88:	89 c0                	mov    %eax,%eax
  800b8a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b91:	00 
  800b92:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  800b99:	00 00 00 
  800b9c:	48 01 d0             	add    %rdx,%rax
  800b9f:	48 8b 00             	mov    (%rax),%rax
  800ba2:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ba4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ba8:	eb c0                	jmp    800b6a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800baa:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bae:	eb ba                	jmp    800b6a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bb0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bb7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bba:	89 d0                	mov    %edx,%eax
  800bbc:	c1 e0 02             	shl    $0x2,%eax
  800bbf:	01 d0                	add    %edx,%eax
  800bc1:	01 c0                	add    %eax,%eax
  800bc3:	01 d8                	add    %ebx,%eax
  800bc5:	83 e8 30             	sub    $0x30,%eax
  800bc8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bcb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bcf:	0f b6 00             	movzbl (%rax),%eax
  800bd2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bd5:	83 fb 2f             	cmp    $0x2f,%ebx
  800bd8:	7e 60                	jle    800c3a <vprintfmt+0x159>
  800bda:	83 fb 39             	cmp    $0x39,%ebx
  800bdd:	7f 5b                	jg     800c3a <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bdf:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800be4:	eb d1                	jmp    800bb7 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800be6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be9:	83 f8 30             	cmp    $0x30,%eax
  800bec:	73 17                	jae    800c05 <vprintfmt+0x124>
  800bee:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800bf2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf5:	89 d2                	mov    %edx,%edx
  800bf7:	48 01 d0             	add    %rdx,%rax
  800bfa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bfd:	83 c2 08             	add    $0x8,%edx
  800c00:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c03:	eb 0c                	jmp    800c11 <vprintfmt+0x130>
  800c05:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c09:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c0d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c11:	8b 00                	mov    (%rax),%eax
  800c13:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c16:	eb 23                	jmp    800c3b <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800c18:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c1c:	0f 89 48 ff ff ff    	jns    800b6a <vprintfmt+0x89>
				width = 0;
  800c22:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c29:	e9 3c ff ff ff       	jmpq   800b6a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c2e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c35:	e9 30 ff ff ff       	jmpq   800b6a <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c3a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c3b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c3f:	0f 89 25 ff ff ff    	jns    800b6a <vprintfmt+0x89>
				width = precision, precision = -1;
  800c45:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c48:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c4b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c52:	e9 13 ff ff ff       	jmpq   800b6a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c57:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c5b:	e9 0a ff ff ff       	jmpq   800b6a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c60:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c63:	83 f8 30             	cmp    $0x30,%eax
  800c66:	73 17                	jae    800c7f <vprintfmt+0x19e>
  800c68:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c6c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c6f:	89 d2                	mov    %edx,%edx
  800c71:	48 01 d0             	add    %rdx,%rax
  800c74:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c77:	83 c2 08             	add    $0x8,%edx
  800c7a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c7d:	eb 0c                	jmp    800c8b <vprintfmt+0x1aa>
  800c7f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c83:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c87:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c8b:	8b 10                	mov    (%rax),%edx
  800c8d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c91:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c95:	48 89 ce             	mov    %rcx,%rsi
  800c98:	89 d7                	mov    %edx,%edi
  800c9a:	ff d0                	callq  *%rax
			break;
  800c9c:	e9 37 03 00 00       	jmpq   800fd8 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ca1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca4:	83 f8 30             	cmp    $0x30,%eax
  800ca7:	73 17                	jae    800cc0 <vprintfmt+0x1df>
  800ca9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb0:	89 d2                	mov    %edx,%edx
  800cb2:	48 01 d0             	add    %rdx,%rax
  800cb5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb8:	83 c2 08             	add    $0x8,%edx
  800cbb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cbe:	eb 0c                	jmp    800ccc <vprintfmt+0x1eb>
  800cc0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cc4:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cc8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ccc:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cce:	85 db                	test   %ebx,%ebx
  800cd0:	79 02                	jns    800cd4 <vprintfmt+0x1f3>
				err = -err;
  800cd2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cd4:	83 fb 15             	cmp    $0x15,%ebx
  800cd7:	7f 16                	jg     800cef <vprintfmt+0x20e>
  800cd9:	48 b8 40 1b 80 00 00 	movabs $0x801b40,%rax
  800ce0:	00 00 00 
  800ce3:	48 63 d3             	movslq %ebx,%rdx
  800ce6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cea:	4d 85 e4             	test   %r12,%r12
  800ced:	75 2e                	jne    800d1d <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800cef:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cf3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf7:	89 d9                	mov    %ebx,%ecx
  800cf9:	48 ba 01 1c 80 00 00 	movabs $0x801c01,%rdx
  800d00:	00 00 00 
  800d03:	48 89 c7             	mov    %rax,%rdi
  800d06:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0b:	49 b8 e7 0f 80 00 00 	movabs $0x800fe7,%r8
  800d12:	00 00 00 
  800d15:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d18:	e9 bb 02 00 00       	jmpq   800fd8 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d1d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d25:	4c 89 e1             	mov    %r12,%rcx
  800d28:	48 ba 0a 1c 80 00 00 	movabs $0x801c0a,%rdx
  800d2f:	00 00 00 
  800d32:	48 89 c7             	mov    %rax,%rdi
  800d35:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3a:	49 b8 e7 0f 80 00 00 	movabs $0x800fe7,%r8
  800d41:	00 00 00 
  800d44:	41 ff d0             	callq  *%r8
			break;
  800d47:	e9 8c 02 00 00       	jmpq   800fd8 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d4c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d4f:	83 f8 30             	cmp    $0x30,%eax
  800d52:	73 17                	jae    800d6b <vprintfmt+0x28a>
  800d54:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d58:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d5b:	89 d2                	mov    %edx,%edx
  800d5d:	48 01 d0             	add    %rdx,%rax
  800d60:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d63:	83 c2 08             	add    $0x8,%edx
  800d66:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d69:	eb 0c                	jmp    800d77 <vprintfmt+0x296>
  800d6b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d6f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d73:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d77:	4c 8b 20             	mov    (%rax),%r12
  800d7a:	4d 85 e4             	test   %r12,%r12
  800d7d:	75 0a                	jne    800d89 <vprintfmt+0x2a8>
				p = "(null)";
  800d7f:	49 bc 0d 1c 80 00 00 	movabs $0x801c0d,%r12
  800d86:	00 00 00 
			if (width > 0 && padc != '-')
  800d89:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d8d:	7e 78                	jle    800e07 <vprintfmt+0x326>
  800d8f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d93:	74 72                	je     800e07 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d95:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d98:	48 98                	cltq   
  800d9a:	48 89 c6             	mov    %rax,%rsi
  800d9d:	4c 89 e7             	mov    %r12,%rdi
  800da0:	48 b8 95 12 80 00 00 	movabs $0x801295,%rax
  800da7:	00 00 00 
  800daa:	ff d0                	callq  *%rax
  800dac:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800daf:	eb 17                	jmp    800dc8 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800db1:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800db5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800db9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dbd:	48 89 ce             	mov    %rcx,%rsi
  800dc0:	89 d7                	mov    %edx,%edi
  800dc2:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dc8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dcc:	7f e3                	jg     800db1 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dce:	eb 37                	jmp    800e07 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800dd0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800dd4:	74 1e                	je     800df4 <vprintfmt+0x313>
  800dd6:	83 fb 1f             	cmp    $0x1f,%ebx
  800dd9:	7e 05                	jle    800de0 <vprintfmt+0x2ff>
  800ddb:	83 fb 7e             	cmp    $0x7e,%ebx
  800dde:	7e 14                	jle    800df4 <vprintfmt+0x313>
					putch('?', putdat);
  800de0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de8:	48 89 d6             	mov    %rdx,%rsi
  800deb:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800df0:	ff d0                	callq  *%rax
  800df2:	eb 0f                	jmp    800e03 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800df4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfc:	48 89 d6             	mov    %rdx,%rsi
  800dff:	89 df                	mov    %ebx,%edi
  800e01:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e03:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e07:	4c 89 e0             	mov    %r12,%rax
  800e0a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e0e:	0f b6 00             	movzbl (%rax),%eax
  800e11:	0f be d8             	movsbl %al,%ebx
  800e14:	85 db                	test   %ebx,%ebx
  800e16:	74 28                	je     800e40 <vprintfmt+0x35f>
  800e18:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e1c:	78 b2                	js     800dd0 <vprintfmt+0x2ef>
  800e1e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e22:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e26:	79 a8                	jns    800dd0 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e28:	eb 16                	jmp    800e40 <vprintfmt+0x35f>
				putch(' ', putdat);
  800e2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e32:	48 89 d6             	mov    %rdx,%rsi
  800e35:	bf 20 00 00 00       	mov    $0x20,%edi
  800e3a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e3c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e40:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e44:	7f e4                	jg     800e2a <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800e46:	e9 8d 01 00 00       	jmpq   800fd8 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e4b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e4f:	be 03 00 00 00       	mov    $0x3,%esi
  800e54:	48 89 c7             	mov    %rax,%rdi
  800e57:	48 b8 da 09 80 00 00 	movabs $0x8009da,%rax
  800e5e:	00 00 00 
  800e61:	ff d0                	callq  *%rax
  800e63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6b:	48 85 c0             	test   %rax,%rax
  800e6e:	79 1d                	jns    800e8d <vprintfmt+0x3ac>
				putch('-', putdat);
  800e70:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e78:	48 89 d6             	mov    %rdx,%rsi
  800e7b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e80:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e86:	48 f7 d8             	neg    %rax
  800e89:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e8d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e94:	e9 d2 00 00 00       	jmpq   800f6b <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e99:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e9d:	be 03 00 00 00       	mov    $0x3,%esi
  800ea2:	48 89 c7             	mov    %rax,%rdi
  800ea5:	48 b8 d3 08 80 00 00 	movabs $0x8008d3,%rax
  800eac:	00 00 00 
  800eaf:	ff d0                	callq  *%rax
  800eb1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800eb5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ebc:	e9 aa 00 00 00       	jmpq   800f6b <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800ec1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ec5:	be 03 00 00 00       	mov    $0x3,%esi
  800eca:	48 89 c7             	mov    %rax,%rdi
  800ecd:	48 b8 d3 08 80 00 00 	movabs $0x8008d3,%rax
  800ed4:	00 00 00 
  800ed7:	ff d0                	callq  *%rax
  800ed9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800edd:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ee4:	e9 82 00 00 00       	jmpq   800f6b <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800ee9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef1:	48 89 d6             	mov    %rdx,%rsi
  800ef4:	bf 30 00 00 00       	mov    $0x30,%edi
  800ef9:	ff d0                	callq  *%rax
			putch('x', putdat);
  800efb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f03:	48 89 d6             	mov    %rdx,%rsi
  800f06:	bf 78 00 00 00       	mov    $0x78,%edi
  800f0b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f0d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f10:	83 f8 30             	cmp    $0x30,%eax
  800f13:	73 17                	jae    800f2c <vprintfmt+0x44b>
  800f15:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f19:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f1c:	89 d2                	mov    %edx,%edx
  800f1e:	48 01 d0             	add    %rdx,%rax
  800f21:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f24:	83 c2 08             	add    $0x8,%edx
  800f27:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f2a:	eb 0c                	jmp    800f38 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800f2c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800f30:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800f34:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f38:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f3b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f3f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f46:	eb 23                	jmp    800f6b <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f48:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f4c:	be 03 00 00 00       	mov    $0x3,%esi
  800f51:	48 89 c7             	mov    %rax,%rdi
  800f54:	48 b8 d3 08 80 00 00 	movabs $0x8008d3,%rax
  800f5b:	00 00 00 
  800f5e:	ff d0                	callq  *%rax
  800f60:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f64:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f6b:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f70:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f73:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f76:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f7a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f82:	45 89 c1             	mov    %r8d,%r9d
  800f85:	41 89 f8             	mov    %edi,%r8d
  800f88:	48 89 c7             	mov    %rax,%rdi
  800f8b:	48 b8 1b 08 80 00 00 	movabs $0x80081b,%rax
  800f92:	00 00 00 
  800f95:	ff d0                	callq  *%rax
			break;
  800f97:	eb 3f                	jmp    800fd8 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f99:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fa1:	48 89 d6             	mov    %rdx,%rsi
  800fa4:	89 df                	mov    %ebx,%edi
  800fa6:	ff d0                	callq  *%rax
			break;
  800fa8:	eb 2e                	jmp    800fd8 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800faa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fb2:	48 89 d6             	mov    %rdx,%rsi
  800fb5:	bf 25 00 00 00       	mov    $0x25,%edi
  800fba:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fbc:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fc1:	eb 05                	jmp    800fc8 <vprintfmt+0x4e7>
  800fc3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fc8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fcc:	48 83 e8 01          	sub    $0x1,%rax
  800fd0:	0f b6 00             	movzbl (%rax),%eax
  800fd3:	3c 25                	cmp    $0x25,%al
  800fd5:	75 ec                	jne    800fc3 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800fd7:	90                   	nop
		}
	}
  800fd8:	e9 3d fb ff ff       	jmpq   800b1a <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fdd:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800fde:	48 83 c4 60          	add    $0x60,%rsp
  800fe2:	5b                   	pop    %rbx
  800fe3:	41 5c                	pop    %r12
  800fe5:	5d                   	pop    %rbp
  800fe6:	c3                   	retq   

0000000000800fe7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fe7:	55                   	push   %rbp
  800fe8:	48 89 e5             	mov    %rsp,%rbp
  800feb:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ff2:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ff9:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801000:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  801007:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80100e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801015:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80101c:	84 c0                	test   %al,%al
  80101e:	74 20                	je     801040 <printfmt+0x59>
  801020:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801024:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801028:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80102c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801030:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801034:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801038:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80103c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801040:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801047:	00 00 00 
  80104a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801051:	00 00 00 
  801054:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801058:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80105f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801066:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80106d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801074:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80107b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801082:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801089:	48 89 c7             	mov    %rax,%rdi
  80108c:	48 b8 e1 0a 80 00 00 	movabs $0x800ae1,%rax
  801093:	00 00 00 
  801096:	ff d0                	callq  *%rax
	va_end(ap);
}
  801098:	90                   	nop
  801099:	c9                   	leaveq 
  80109a:	c3                   	retq   

000000000080109b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80109b:	55                   	push   %rbp
  80109c:	48 89 e5             	mov    %rsp,%rbp
  80109f:	48 83 ec 10          	sub    $0x10,%rsp
  8010a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ae:	8b 40 10             	mov    0x10(%rax),%eax
  8010b1:	8d 50 01             	lea    0x1(%rax),%edx
  8010b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010bf:	48 8b 10             	mov    (%rax),%rdx
  8010c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010ca:	48 39 c2             	cmp    %rax,%rdx
  8010cd:	73 17                	jae    8010e6 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d3:	48 8b 00             	mov    (%rax),%rax
  8010d6:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010de:	48 89 0a             	mov    %rcx,(%rdx)
  8010e1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010e4:	88 10                	mov    %dl,(%rax)
}
  8010e6:	90                   	nop
  8010e7:	c9                   	leaveq 
  8010e8:	c3                   	retq   

00000000008010e9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010e9:	55                   	push   %rbp
  8010ea:	48 89 e5             	mov    %rsp,%rbp
  8010ed:	48 83 ec 50          	sub    $0x50,%rsp
  8010f1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010f5:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8010f8:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8010fc:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801100:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801104:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801108:	48 8b 0a             	mov    (%rdx),%rcx
  80110b:	48 89 08             	mov    %rcx,(%rax)
  80110e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801112:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801116:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80111a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80111e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801122:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801126:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801129:	48 98                	cltq   
  80112b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80112f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801133:	48 01 d0             	add    %rdx,%rax
  801136:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80113a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801141:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801146:	74 06                	je     80114e <vsnprintf+0x65>
  801148:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80114c:	7f 07                	jg     801155 <vsnprintf+0x6c>
		return -E_INVAL;
  80114e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801153:	eb 2f                	jmp    801184 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801155:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801159:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80115d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801161:	48 89 c6             	mov    %rax,%rsi
  801164:	48 bf 9b 10 80 00 00 	movabs $0x80109b,%rdi
  80116b:	00 00 00 
  80116e:	48 b8 e1 0a 80 00 00 	movabs $0x800ae1,%rax
  801175:	00 00 00 
  801178:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80117a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80117e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801181:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801184:	c9                   	leaveq 
  801185:	c3                   	retq   

0000000000801186 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801186:	55                   	push   %rbp
  801187:	48 89 e5             	mov    %rsp,%rbp
  80118a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801191:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801198:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80119e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8011a5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011ac:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011b3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011ba:	84 c0                	test   %al,%al
  8011bc:	74 20                	je     8011de <snprintf+0x58>
  8011be:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011c2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011c6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011ca:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011ce:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011d2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011d6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011da:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011de:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011e5:	00 00 00 
  8011e8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011ef:	00 00 00 
  8011f2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011f6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8011fd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801204:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80120b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801212:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801219:	48 8b 0a             	mov    (%rdx),%rcx
  80121c:	48 89 08             	mov    %rcx,(%rax)
  80121f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801223:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801227:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80122b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80122f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801236:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80123d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801243:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80124a:	48 89 c7             	mov    %rax,%rdi
  80124d:	48 b8 e9 10 80 00 00 	movabs $0x8010e9,%rax
  801254:	00 00 00 
  801257:	ff d0                	callq  *%rax
  801259:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80125f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801265:	c9                   	leaveq 
  801266:	c3                   	retq   

0000000000801267 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801267:	55                   	push   %rbp
  801268:	48 89 e5             	mov    %rsp,%rbp
  80126b:	48 83 ec 18          	sub    $0x18,%rsp
  80126f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801273:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80127a:	eb 09                	jmp    801285 <strlen+0x1e>
		n++;
  80127c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801280:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801289:	0f b6 00             	movzbl (%rax),%eax
  80128c:	84 c0                	test   %al,%al
  80128e:	75 ec                	jne    80127c <strlen+0x15>
		n++;
	return n;
  801290:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801293:	c9                   	leaveq 
  801294:	c3                   	retq   

0000000000801295 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801295:	55                   	push   %rbp
  801296:	48 89 e5             	mov    %rsp,%rbp
  801299:	48 83 ec 20          	sub    $0x20,%rsp
  80129d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012ac:	eb 0e                	jmp    8012bc <strnlen+0x27>
		n++;
  8012ae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012b2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012b7:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012bc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012c1:	74 0b                	je     8012ce <strnlen+0x39>
  8012c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c7:	0f b6 00             	movzbl (%rax),%eax
  8012ca:	84 c0                	test   %al,%al
  8012cc:	75 e0                	jne    8012ae <strnlen+0x19>
		n++;
	return n;
  8012ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012d1:	c9                   	leaveq 
  8012d2:	c3                   	retq   

00000000008012d3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012d3:	55                   	push   %rbp
  8012d4:	48 89 e5             	mov    %rsp,%rbp
  8012d7:	48 83 ec 20          	sub    $0x20,%rsp
  8012db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012eb:	90                   	nop
  8012ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012f8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012fc:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801300:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801304:	0f b6 12             	movzbl (%rdx),%edx
  801307:	88 10                	mov    %dl,(%rax)
  801309:	0f b6 00             	movzbl (%rax),%eax
  80130c:	84 c0                	test   %al,%al
  80130e:	75 dc                	jne    8012ec <strcpy+0x19>
		/* do nothing */;
	return ret;
  801310:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801314:	c9                   	leaveq 
  801315:	c3                   	retq   

0000000000801316 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801316:	55                   	push   %rbp
  801317:	48 89 e5             	mov    %rsp,%rbp
  80131a:	48 83 ec 20          	sub    $0x20,%rsp
  80131e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801322:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801326:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132a:	48 89 c7             	mov    %rax,%rdi
  80132d:	48 b8 67 12 80 00 00 	movabs $0x801267,%rax
  801334:	00 00 00 
  801337:	ff d0                	callq  *%rax
  801339:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80133c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80133f:	48 63 d0             	movslq %eax,%rdx
  801342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801346:	48 01 c2             	add    %rax,%rdx
  801349:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80134d:	48 89 c6             	mov    %rax,%rsi
  801350:	48 89 d7             	mov    %rdx,%rdi
  801353:	48 b8 d3 12 80 00 00 	movabs $0x8012d3,%rax
  80135a:	00 00 00 
  80135d:	ff d0                	callq  *%rax
	return dst;
  80135f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801363:	c9                   	leaveq 
  801364:	c3                   	retq   

0000000000801365 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801365:	55                   	push   %rbp
  801366:	48 89 e5             	mov    %rsp,%rbp
  801369:	48 83 ec 28          	sub    $0x28,%rsp
  80136d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801371:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801375:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801379:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801381:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801388:	00 
  801389:	eb 2a                	jmp    8013b5 <strncpy+0x50>
		*dst++ = *src;
  80138b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801393:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801397:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80139b:	0f b6 12             	movzbl (%rdx),%edx
  80139e:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013a4:	0f b6 00             	movzbl (%rax),%eax
  8013a7:	84 c0                	test   %al,%al
  8013a9:	74 05                	je     8013b0 <strncpy+0x4b>
			src++;
  8013ab:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013bd:	72 cc                	jb     80138b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013c3:	c9                   	leaveq 
  8013c4:	c3                   	retq   

00000000008013c5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013c5:	55                   	push   %rbp
  8013c6:	48 89 e5             	mov    %rsp,%rbp
  8013c9:	48 83 ec 28          	sub    $0x28,%rsp
  8013cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013e1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013e6:	74 3d                	je     801425 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8013e8:	eb 1d                	jmp    801407 <strlcpy+0x42>
			*dst++ = *src++;
  8013ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013f2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013f6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013fa:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013fe:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801402:	0f b6 12             	movzbl (%rdx),%edx
  801405:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801407:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80140c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801411:	74 0b                	je     80141e <strlcpy+0x59>
  801413:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801417:	0f b6 00             	movzbl (%rax),%eax
  80141a:	84 c0                	test   %al,%al
  80141c:	75 cc                	jne    8013ea <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80141e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801422:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801425:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801429:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142d:	48 29 c2             	sub    %rax,%rdx
  801430:	48 89 d0             	mov    %rdx,%rax
}
  801433:	c9                   	leaveq 
  801434:	c3                   	retq   

0000000000801435 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801435:	55                   	push   %rbp
  801436:	48 89 e5             	mov    %rsp,%rbp
  801439:	48 83 ec 10          	sub    $0x10,%rsp
  80143d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801441:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801445:	eb 0a                	jmp    801451 <strcmp+0x1c>
		p++, q++;
  801447:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80144c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801451:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801455:	0f b6 00             	movzbl (%rax),%eax
  801458:	84 c0                	test   %al,%al
  80145a:	74 12                	je     80146e <strcmp+0x39>
  80145c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801460:	0f b6 10             	movzbl (%rax),%edx
  801463:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801467:	0f b6 00             	movzbl (%rax),%eax
  80146a:	38 c2                	cmp    %al,%dl
  80146c:	74 d9                	je     801447 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80146e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801472:	0f b6 00             	movzbl (%rax),%eax
  801475:	0f b6 d0             	movzbl %al,%edx
  801478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147c:	0f b6 00             	movzbl (%rax),%eax
  80147f:	0f b6 c0             	movzbl %al,%eax
  801482:	29 c2                	sub    %eax,%edx
  801484:	89 d0                	mov    %edx,%eax
}
  801486:	c9                   	leaveq 
  801487:	c3                   	retq   

0000000000801488 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801488:	55                   	push   %rbp
  801489:	48 89 e5             	mov    %rsp,%rbp
  80148c:	48 83 ec 18          	sub    $0x18,%rsp
  801490:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801494:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801498:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80149c:	eb 0f                	jmp    8014ad <strncmp+0x25>
		n--, p++, q++;
  80149e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014a3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014a8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014ad:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014b2:	74 1d                	je     8014d1 <strncmp+0x49>
  8014b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b8:	0f b6 00             	movzbl (%rax),%eax
  8014bb:	84 c0                	test   %al,%al
  8014bd:	74 12                	je     8014d1 <strncmp+0x49>
  8014bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c3:	0f b6 10             	movzbl (%rax),%edx
  8014c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ca:	0f b6 00             	movzbl (%rax),%eax
  8014cd:	38 c2                	cmp    %al,%dl
  8014cf:	74 cd                	je     80149e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014d1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014d6:	75 07                	jne    8014df <strncmp+0x57>
		return 0;
  8014d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014dd:	eb 18                	jmp    8014f7 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e3:	0f b6 00             	movzbl (%rax),%eax
  8014e6:	0f b6 d0             	movzbl %al,%edx
  8014e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ed:	0f b6 00             	movzbl (%rax),%eax
  8014f0:	0f b6 c0             	movzbl %al,%eax
  8014f3:	29 c2                	sub    %eax,%edx
  8014f5:	89 d0                	mov    %edx,%eax
}
  8014f7:	c9                   	leaveq 
  8014f8:	c3                   	retq   

00000000008014f9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014f9:	55                   	push   %rbp
  8014fa:	48 89 e5             	mov    %rsp,%rbp
  8014fd:	48 83 ec 10          	sub    $0x10,%rsp
  801501:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801505:	89 f0                	mov    %esi,%eax
  801507:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80150a:	eb 17                	jmp    801523 <strchr+0x2a>
		if (*s == c)
  80150c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801510:	0f b6 00             	movzbl (%rax),%eax
  801513:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801516:	75 06                	jne    80151e <strchr+0x25>
			return (char *) s;
  801518:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151c:	eb 15                	jmp    801533 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80151e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801523:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801527:	0f b6 00             	movzbl (%rax),%eax
  80152a:	84 c0                	test   %al,%al
  80152c:	75 de                	jne    80150c <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80152e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801533:	c9                   	leaveq 
  801534:	c3                   	retq   

0000000000801535 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801535:	55                   	push   %rbp
  801536:	48 89 e5             	mov    %rsp,%rbp
  801539:	48 83 ec 10          	sub    $0x10,%rsp
  80153d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801541:	89 f0                	mov    %esi,%eax
  801543:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801546:	eb 11                	jmp    801559 <strfind+0x24>
		if (*s == c)
  801548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154c:	0f b6 00             	movzbl (%rax),%eax
  80154f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801552:	74 12                	je     801566 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801554:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801559:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155d:	0f b6 00             	movzbl (%rax),%eax
  801560:	84 c0                	test   %al,%al
  801562:	75 e4                	jne    801548 <strfind+0x13>
  801564:	eb 01                	jmp    801567 <strfind+0x32>
		if (*s == c)
			break;
  801566:	90                   	nop
	return (char *) s;
  801567:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80156b:	c9                   	leaveq 
  80156c:	c3                   	retq   

000000000080156d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80156d:	55                   	push   %rbp
  80156e:	48 89 e5             	mov    %rsp,%rbp
  801571:	48 83 ec 18          	sub    $0x18,%rsp
  801575:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801579:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80157c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801580:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801585:	75 06                	jne    80158d <memset+0x20>
		return v;
  801587:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158b:	eb 69                	jmp    8015f6 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80158d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801591:	83 e0 03             	and    $0x3,%eax
  801594:	48 85 c0             	test   %rax,%rax
  801597:	75 48                	jne    8015e1 <memset+0x74>
  801599:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80159d:	83 e0 03             	and    $0x3,%eax
  8015a0:	48 85 c0             	test   %rax,%rax
  8015a3:	75 3c                	jne    8015e1 <memset+0x74>
		c &= 0xFF;
  8015a5:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015af:	c1 e0 18             	shl    $0x18,%eax
  8015b2:	89 c2                	mov    %eax,%edx
  8015b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015b7:	c1 e0 10             	shl    $0x10,%eax
  8015ba:	09 c2                	or     %eax,%edx
  8015bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015bf:	c1 e0 08             	shl    $0x8,%eax
  8015c2:	09 d0                	or     %edx,%eax
  8015c4:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015cb:	48 c1 e8 02          	shr    $0x2,%rax
  8015cf:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015d9:	48 89 d7             	mov    %rdx,%rdi
  8015dc:	fc                   	cld    
  8015dd:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015df:	eb 11                	jmp    8015f2 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015ec:	48 89 d7             	mov    %rdx,%rdi
  8015ef:	fc                   	cld    
  8015f0:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8015f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015f6:	c9                   	leaveq 
  8015f7:	c3                   	retq   

00000000008015f8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015f8:	55                   	push   %rbp
  8015f9:	48 89 e5             	mov    %rsp,%rbp
  8015fc:	48 83 ec 28          	sub    $0x28,%rsp
  801600:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801604:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801608:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80160c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801610:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801618:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80161c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801620:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801624:	0f 83 88 00 00 00    	jae    8016b2 <memmove+0xba>
  80162a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80162e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801632:	48 01 d0             	add    %rdx,%rax
  801635:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801639:	76 77                	jbe    8016b2 <memmove+0xba>
		s += n;
  80163b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801643:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801647:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80164b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164f:	83 e0 03             	and    $0x3,%eax
  801652:	48 85 c0             	test   %rax,%rax
  801655:	75 3b                	jne    801692 <memmove+0x9a>
  801657:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80165b:	83 e0 03             	and    $0x3,%eax
  80165e:	48 85 c0             	test   %rax,%rax
  801661:	75 2f                	jne    801692 <memmove+0x9a>
  801663:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801667:	83 e0 03             	and    $0x3,%eax
  80166a:	48 85 c0             	test   %rax,%rax
  80166d:	75 23                	jne    801692 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80166f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801673:	48 83 e8 04          	sub    $0x4,%rax
  801677:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80167b:	48 83 ea 04          	sub    $0x4,%rdx
  80167f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801683:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801687:	48 89 c7             	mov    %rax,%rdi
  80168a:	48 89 d6             	mov    %rdx,%rsi
  80168d:	fd                   	std    
  80168e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801690:	eb 1d                	jmp    8016af <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801696:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80169a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a6:	48 89 d7             	mov    %rdx,%rdi
  8016a9:	48 89 c1             	mov    %rax,%rcx
  8016ac:	fd                   	std    
  8016ad:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016af:	fc                   	cld    
  8016b0:	eb 57                	jmp    801709 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b6:	83 e0 03             	and    $0x3,%eax
  8016b9:	48 85 c0             	test   %rax,%rax
  8016bc:	75 36                	jne    8016f4 <memmove+0xfc>
  8016be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c2:	83 e0 03             	and    $0x3,%eax
  8016c5:	48 85 c0             	test   %rax,%rax
  8016c8:	75 2a                	jne    8016f4 <memmove+0xfc>
  8016ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ce:	83 e0 03             	and    $0x3,%eax
  8016d1:	48 85 c0             	test   %rax,%rax
  8016d4:	75 1e                	jne    8016f4 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016da:	48 c1 e8 02          	shr    $0x2,%rax
  8016de:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016e9:	48 89 c7             	mov    %rax,%rdi
  8016ec:	48 89 d6             	mov    %rdx,%rsi
  8016ef:	fc                   	cld    
  8016f0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016f2:	eb 15                	jmp    801709 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016fc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801700:	48 89 c7             	mov    %rax,%rdi
  801703:	48 89 d6             	mov    %rdx,%rsi
  801706:	fc                   	cld    
  801707:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80170d:	c9                   	leaveq 
  80170e:	c3                   	retq   

000000000080170f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80170f:	55                   	push   %rbp
  801710:	48 89 e5             	mov    %rsp,%rbp
  801713:	48 83 ec 18          	sub    $0x18,%rsp
  801717:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80171b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80171f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801723:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801727:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80172b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80172f:	48 89 ce             	mov    %rcx,%rsi
  801732:	48 89 c7             	mov    %rax,%rdi
  801735:	48 b8 f8 15 80 00 00 	movabs $0x8015f8,%rax
  80173c:	00 00 00 
  80173f:	ff d0                	callq  *%rax
}
  801741:	c9                   	leaveq 
  801742:	c3                   	retq   

0000000000801743 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801743:	55                   	push   %rbp
  801744:	48 89 e5             	mov    %rsp,%rbp
  801747:	48 83 ec 28          	sub    $0x28,%rsp
  80174b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80174f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801753:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80175b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80175f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801763:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801767:	eb 36                	jmp    80179f <memcmp+0x5c>
		if (*s1 != *s2)
  801769:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80176d:	0f b6 10             	movzbl (%rax),%edx
  801770:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801774:	0f b6 00             	movzbl (%rax),%eax
  801777:	38 c2                	cmp    %al,%dl
  801779:	74 1a                	je     801795 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80177b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177f:	0f b6 00             	movzbl (%rax),%eax
  801782:	0f b6 d0             	movzbl %al,%edx
  801785:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801789:	0f b6 00             	movzbl (%rax),%eax
  80178c:	0f b6 c0             	movzbl %al,%eax
  80178f:	29 c2                	sub    %eax,%edx
  801791:	89 d0                	mov    %edx,%eax
  801793:	eb 20                	jmp    8017b5 <memcmp+0x72>
		s1++, s2++;
  801795:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80179a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80179f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017a7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017ab:	48 85 c0             	test   %rax,%rax
  8017ae:	75 b9                	jne    801769 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b5:	c9                   	leaveq 
  8017b6:	c3                   	retq   

00000000008017b7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017b7:	55                   	push   %rbp
  8017b8:	48 89 e5             	mov    %rsp,%rbp
  8017bb:	48 83 ec 28          	sub    $0x28,%rsp
  8017bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017c3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017c6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d2:	48 01 d0             	add    %rdx,%rax
  8017d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017d9:	eb 19                	jmp    8017f4 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017df:	0f b6 00             	movzbl (%rax),%eax
  8017e2:	0f b6 d0             	movzbl %al,%edx
  8017e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017e8:	0f b6 c0             	movzbl %al,%eax
  8017eb:	39 c2                	cmp    %eax,%edx
  8017ed:	74 11                	je     801800 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017ef:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f8:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8017fc:	72 dd                	jb     8017db <memfind+0x24>
  8017fe:	eb 01                	jmp    801801 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801800:	90                   	nop
	return (void *) s;
  801801:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801805:	c9                   	leaveq 
  801806:	c3                   	retq   

0000000000801807 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801807:	55                   	push   %rbp
  801808:	48 89 e5             	mov    %rsp,%rbp
  80180b:	48 83 ec 38          	sub    $0x38,%rsp
  80180f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801813:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801817:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80181a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801821:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801828:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801829:	eb 05                	jmp    801830 <strtol+0x29>
		s++;
  80182b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801830:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801834:	0f b6 00             	movzbl (%rax),%eax
  801837:	3c 20                	cmp    $0x20,%al
  801839:	74 f0                	je     80182b <strtol+0x24>
  80183b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183f:	0f b6 00             	movzbl (%rax),%eax
  801842:	3c 09                	cmp    $0x9,%al
  801844:	74 e5                	je     80182b <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801846:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184a:	0f b6 00             	movzbl (%rax),%eax
  80184d:	3c 2b                	cmp    $0x2b,%al
  80184f:	75 07                	jne    801858 <strtol+0x51>
		s++;
  801851:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801856:	eb 17                	jmp    80186f <strtol+0x68>
	else if (*s == '-')
  801858:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185c:	0f b6 00             	movzbl (%rax),%eax
  80185f:	3c 2d                	cmp    $0x2d,%al
  801861:	75 0c                	jne    80186f <strtol+0x68>
		s++, neg = 1;
  801863:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801868:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80186f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801873:	74 06                	je     80187b <strtol+0x74>
  801875:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801879:	75 28                	jne    8018a3 <strtol+0x9c>
  80187b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187f:	0f b6 00             	movzbl (%rax),%eax
  801882:	3c 30                	cmp    $0x30,%al
  801884:	75 1d                	jne    8018a3 <strtol+0x9c>
  801886:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188a:	48 83 c0 01          	add    $0x1,%rax
  80188e:	0f b6 00             	movzbl (%rax),%eax
  801891:	3c 78                	cmp    $0x78,%al
  801893:	75 0e                	jne    8018a3 <strtol+0x9c>
		s += 2, base = 16;
  801895:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80189a:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018a1:	eb 2c                	jmp    8018cf <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018a7:	75 19                	jne    8018c2 <strtol+0xbb>
  8018a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ad:	0f b6 00             	movzbl (%rax),%eax
  8018b0:	3c 30                	cmp    $0x30,%al
  8018b2:	75 0e                	jne    8018c2 <strtol+0xbb>
		s++, base = 8;
  8018b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018b9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018c0:	eb 0d                	jmp    8018cf <strtol+0xc8>
	else if (base == 0)
  8018c2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018c6:	75 07                	jne    8018cf <strtol+0xc8>
		base = 10;
  8018c8:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d3:	0f b6 00             	movzbl (%rax),%eax
  8018d6:	3c 2f                	cmp    $0x2f,%al
  8018d8:	7e 1d                	jle    8018f7 <strtol+0xf0>
  8018da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018de:	0f b6 00             	movzbl (%rax),%eax
  8018e1:	3c 39                	cmp    $0x39,%al
  8018e3:	7f 12                	jg     8018f7 <strtol+0xf0>
			dig = *s - '0';
  8018e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e9:	0f b6 00             	movzbl (%rax),%eax
  8018ec:	0f be c0             	movsbl %al,%eax
  8018ef:	83 e8 30             	sub    $0x30,%eax
  8018f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018f5:	eb 4e                	jmp    801945 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8018f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fb:	0f b6 00             	movzbl (%rax),%eax
  8018fe:	3c 60                	cmp    $0x60,%al
  801900:	7e 1d                	jle    80191f <strtol+0x118>
  801902:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801906:	0f b6 00             	movzbl (%rax),%eax
  801909:	3c 7a                	cmp    $0x7a,%al
  80190b:	7f 12                	jg     80191f <strtol+0x118>
			dig = *s - 'a' + 10;
  80190d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801911:	0f b6 00             	movzbl (%rax),%eax
  801914:	0f be c0             	movsbl %al,%eax
  801917:	83 e8 57             	sub    $0x57,%eax
  80191a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80191d:	eb 26                	jmp    801945 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80191f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801923:	0f b6 00             	movzbl (%rax),%eax
  801926:	3c 40                	cmp    $0x40,%al
  801928:	7e 47                	jle    801971 <strtol+0x16a>
  80192a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192e:	0f b6 00             	movzbl (%rax),%eax
  801931:	3c 5a                	cmp    $0x5a,%al
  801933:	7f 3c                	jg     801971 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801935:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801939:	0f b6 00             	movzbl (%rax),%eax
  80193c:	0f be c0             	movsbl %al,%eax
  80193f:	83 e8 37             	sub    $0x37,%eax
  801942:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801945:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801948:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80194b:	7d 23                	jge    801970 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80194d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801952:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801955:	48 98                	cltq   
  801957:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80195c:	48 89 c2             	mov    %rax,%rdx
  80195f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801962:	48 98                	cltq   
  801964:	48 01 d0             	add    %rdx,%rax
  801967:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80196b:	e9 5f ff ff ff       	jmpq   8018cf <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801970:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801971:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801976:	74 0b                	je     801983 <strtol+0x17c>
		*endptr = (char *) s;
  801978:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80197c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801980:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801983:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801987:	74 09                	je     801992 <strtol+0x18b>
  801989:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80198d:	48 f7 d8             	neg    %rax
  801990:	eb 04                	jmp    801996 <strtol+0x18f>
  801992:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801996:	c9                   	leaveq 
  801997:	c3                   	retq   

0000000000801998 <strstr>:

char * strstr(const char *in, const char *str)
{
  801998:	55                   	push   %rbp
  801999:	48 89 e5             	mov    %rsp,%rbp
  80199c:	48 83 ec 30          	sub    $0x30,%rsp
  8019a0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019a4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019ac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019b0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019b4:	0f b6 00             	movzbl (%rax),%eax
  8019b7:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019ba:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019be:	75 06                	jne    8019c6 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c4:	eb 6b                	jmp    801a31 <strstr+0x99>

	len = strlen(str);
  8019c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019ca:	48 89 c7             	mov    %rax,%rdi
  8019cd:	48 b8 67 12 80 00 00 	movabs $0x801267,%rax
  8019d4:	00 00 00 
  8019d7:	ff d0                	callq  *%rax
  8019d9:	48 98                	cltq   
  8019db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019eb:	0f b6 00             	movzbl (%rax),%eax
  8019ee:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8019f1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019f5:	75 07                	jne    8019fe <strstr+0x66>
				return (char *) 0;
  8019f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fc:	eb 33                	jmp    801a31 <strstr+0x99>
		} while (sc != c);
  8019fe:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a02:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a05:	75 d8                	jne    8019df <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a13:	48 89 ce             	mov    %rcx,%rsi
  801a16:	48 89 c7             	mov    %rax,%rdi
  801a19:	48 b8 88 14 80 00 00 	movabs $0x801488,%rax
  801a20:	00 00 00 
  801a23:	ff d0                	callq  *%rax
  801a25:	85 c0                	test   %eax,%eax
  801a27:	75 b6                	jne    8019df <strstr+0x47>

	return (char *) (in - 1);
  801a29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2d:	48 83 e8 01          	sub    $0x1,%rax
}
  801a31:	c9                   	leaveq 
  801a32:	c3                   	retq   
