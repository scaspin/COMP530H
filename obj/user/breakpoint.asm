
obj/user/breakpoint:     file format elf64-x86-64


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
  80003c:	e8 15 00 00 00       	callq  800056 <libmain>
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
	asm volatile("int $3");
  800052:	cc                   	int3   
}
  800053:	90                   	nop
  800054:	c9                   	leaveq 
  800055:	c3                   	retq   

0000000000800056 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800056:	55                   	push   %rbp
  800057:	48 89 e5             	mov    %rsp,%rbp
  80005a:	48 83 ec 10          	sub    $0x10,%rsp
  80005e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800061:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  800065:	48 b8 57 02 80 00 00 	movabs $0x800257,%rax
  80006c:	00 00 00 
  80006f:	ff d0                	callq  *%rax
  800071:	25 ff 03 00 00       	and    $0x3ff,%eax
  800076:	48 63 d0             	movslq %eax,%rdx
  800079:	48 89 d0             	mov    %rdx,%rax
  80007c:	48 c1 e0 03          	shl    $0x3,%rax
  800080:	48 01 d0             	add    %rdx,%rax
  800083:	48 c1 e0 05          	shl    $0x5,%rax
  800087:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80008e:	00 00 00 
  800091:	48 01 c2             	add    %rax,%rdx
  800094:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80009b:	00 00 00 
  80009e:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000a5:	7e 14                	jle    8000bb <libmain+0x65>
		binaryname = argv[0];
  8000a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000ab:	48 8b 10             	mov    (%rax),%rdx
  8000ae:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000b5:	00 00 00 
  8000b8:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c2:	48 89 d6             	mov    %rdx,%rsi
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ce:	00 00 00 
  8000d1:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000d3:	48 b8 e2 00 80 00 00 	movabs $0x8000e2,%rax
  8000da:	00 00 00 
  8000dd:	ff d0                	callq  *%rax
}
  8000df:	90                   	nop
  8000e0:	c9                   	leaveq 
  8000e1:	c3                   	retq   

00000000008000e2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e2:	55                   	push   %rbp
  8000e3:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8000eb:	48 b8 11 02 80 00 00 	movabs $0x800211,%rax
  8000f2:	00 00 00 
  8000f5:	ff d0                	callq  *%rax
}
  8000f7:	90                   	nop
  8000f8:	5d                   	pop    %rbp
  8000f9:	c3                   	retq   

00000000008000fa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000fa:	55                   	push   %rbp
  8000fb:	48 89 e5             	mov    %rsp,%rbp
  8000fe:	53                   	push   %rbx
  8000ff:	48 83 ec 48          	sub    $0x48,%rsp
  800103:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800106:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800109:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80010d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800111:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800115:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800119:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80011c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800120:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800124:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800128:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80012c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800130:	4c 89 c3             	mov    %r8,%rbx
  800133:	cd 30                	int    $0x30
  800135:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800139:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80013d:	74 3e                	je     80017d <syscall+0x83>
  80013f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800144:	7e 37                	jle    80017d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800146:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80014a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80014d:	49 89 d0             	mov    %rdx,%r8
  800150:	89 c1                	mov    %eax,%ecx
  800152:	48 ba 4a 1a 80 00 00 	movabs $0x801a4a,%rdx
  800159:	00 00 00 
  80015c:	be 23 00 00 00       	mov    $0x23,%esi
  800161:	48 bf 67 1a 80 00 00 	movabs $0x801a67,%rdi
  800168:	00 00 00 
  80016b:	b8 00 00 00 00       	mov    $0x0,%eax
  800170:	49 b9 04 05 80 00 00 	movabs $0x800504,%r9
  800177:	00 00 00 
  80017a:	41 ff d1             	callq  *%r9

	return ret;
  80017d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800181:	48 83 c4 48          	add    $0x48,%rsp
  800185:	5b                   	pop    %rbx
  800186:	5d                   	pop    %rbp
  800187:	c3                   	retq   

0000000000800188 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800188:	55                   	push   %rbp
  800189:	48 89 e5             	mov    %rsp,%rbp
  80018c:	48 83 ec 10          	sub    $0x10,%rsp
  800190:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800194:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800198:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80019c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a0:	48 83 ec 08          	sub    $0x8,%rsp
  8001a4:	6a 00                	pushq  $0x0
  8001a6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001b2:	48 89 d1             	mov    %rdx,%rcx
  8001b5:	48 89 c2             	mov    %rax,%rdx
  8001b8:	be 00 00 00 00       	mov    $0x0,%esi
  8001bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8001c2:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  8001c9:	00 00 00 
  8001cc:	ff d0                	callq  *%rax
  8001ce:	48 83 c4 10          	add    $0x10,%rsp
}
  8001d2:	90                   	nop
  8001d3:	c9                   	leaveq 
  8001d4:	c3                   	retq   

00000000008001d5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001d5:	55                   	push   %rbp
  8001d6:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001d9:	48 83 ec 08          	sub    $0x8,%rsp
  8001dd:	6a 00                	pushq  $0x0
  8001df:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8001f5:	be 00 00 00 00       	mov    $0x0,%esi
  8001fa:	bf 01 00 00 00       	mov    $0x1,%edi
  8001ff:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  800206:	00 00 00 
  800209:	ff d0                	callq  *%rax
  80020b:	48 83 c4 10          	add    $0x10,%rsp
}
  80020f:	c9                   	leaveq 
  800210:	c3                   	retq   

0000000000800211 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800211:	55                   	push   %rbp
  800212:	48 89 e5             	mov    %rsp,%rbp
  800215:	48 83 ec 10          	sub    $0x10,%rsp
  800219:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80021c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80021f:	48 98                	cltq   
  800221:	48 83 ec 08          	sub    $0x8,%rsp
  800225:	6a 00                	pushq  $0x0
  800227:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80022d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800233:	b9 00 00 00 00       	mov    $0x0,%ecx
  800238:	48 89 c2             	mov    %rax,%rdx
  80023b:	be 01 00 00 00       	mov    $0x1,%esi
  800240:	bf 03 00 00 00       	mov    $0x3,%edi
  800245:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  80024c:	00 00 00 
  80024f:	ff d0                	callq  *%rax
  800251:	48 83 c4 10          	add    $0x10,%rsp
}
  800255:	c9                   	leaveq 
  800256:	c3                   	retq   

0000000000800257 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800257:	55                   	push   %rbp
  800258:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80025b:	48 83 ec 08          	sub    $0x8,%rsp
  80025f:	6a 00                	pushq  $0x0
  800261:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800267:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80026d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800272:	ba 00 00 00 00       	mov    $0x0,%edx
  800277:	be 00 00 00 00       	mov    $0x0,%esi
  80027c:	bf 02 00 00 00       	mov    $0x2,%edi
  800281:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  800288:	00 00 00 
  80028b:	ff d0                	callq  *%rax
  80028d:	48 83 c4 10          	add    $0x10,%rsp
}
  800291:	c9                   	leaveq 
  800292:	c3                   	retq   

0000000000800293 <sys_yield>:

void
sys_yield(void)
{
  800293:	55                   	push   %rbp
  800294:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800297:	48 83 ec 08          	sub    $0x8,%rsp
  80029b:	6a 00                	pushq  $0x0
  80029d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b3:	be 00 00 00 00       	mov    $0x0,%esi
  8002b8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002bd:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  8002c4:	00 00 00 
  8002c7:	ff d0                	callq  *%rax
  8002c9:	48 83 c4 10          	add    $0x10,%rsp
}
  8002cd:	90                   	nop
  8002ce:	c9                   	leaveq 
  8002cf:	c3                   	retq   

00000000008002d0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002d0:	55                   	push   %rbp
  8002d1:	48 89 e5             	mov    %rsp,%rbp
  8002d4:	48 83 ec 10          	sub    $0x10,%rsp
  8002d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002df:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002e5:	48 63 c8             	movslq %eax,%rcx
  8002e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ef:	48 98                	cltq   
  8002f1:	48 83 ec 08          	sub    $0x8,%rsp
  8002f5:	6a 00                	pushq  $0x0
  8002f7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002fd:	49 89 c8             	mov    %rcx,%r8
  800300:	48 89 d1             	mov    %rdx,%rcx
  800303:	48 89 c2             	mov    %rax,%rdx
  800306:	be 01 00 00 00       	mov    $0x1,%esi
  80030b:	bf 04 00 00 00       	mov    $0x4,%edi
  800310:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  800317:	00 00 00 
  80031a:	ff d0                	callq  *%rax
  80031c:	48 83 c4 10          	add    $0x10,%rsp
}
  800320:	c9                   	leaveq 
  800321:	c3                   	retq   

0000000000800322 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800322:	55                   	push   %rbp
  800323:	48 89 e5             	mov    %rsp,%rbp
  800326:	48 83 ec 20          	sub    $0x20,%rsp
  80032a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80032d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800331:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800334:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800338:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80033c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80033f:	48 63 c8             	movslq %eax,%rcx
  800342:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800346:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800349:	48 63 f0             	movslq %eax,%rsi
  80034c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800350:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800353:	48 98                	cltq   
  800355:	48 83 ec 08          	sub    $0x8,%rsp
  800359:	51                   	push   %rcx
  80035a:	49 89 f9             	mov    %rdi,%r9
  80035d:	49 89 f0             	mov    %rsi,%r8
  800360:	48 89 d1             	mov    %rdx,%rcx
  800363:	48 89 c2             	mov    %rax,%rdx
  800366:	be 01 00 00 00       	mov    $0x1,%esi
  80036b:	bf 05 00 00 00       	mov    $0x5,%edi
  800370:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  800377:	00 00 00 
  80037a:	ff d0                	callq  *%rax
  80037c:	48 83 c4 10          	add    $0x10,%rsp
}
  800380:	c9                   	leaveq 
  800381:	c3                   	retq   

0000000000800382 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800382:	55                   	push   %rbp
  800383:	48 89 e5             	mov    %rsp,%rbp
  800386:	48 83 ec 10          	sub    $0x10,%rsp
  80038a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80038d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800391:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800395:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800398:	48 98                	cltq   
  80039a:	48 83 ec 08          	sub    $0x8,%rsp
  80039e:	6a 00                	pushq  $0x0
  8003a0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003a6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003ac:	48 89 d1             	mov    %rdx,%rcx
  8003af:	48 89 c2             	mov    %rax,%rdx
  8003b2:	be 01 00 00 00       	mov    $0x1,%esi
  8003b7:	bf 06 00 00 00       	mov    $0x6,%edi
  8003bc:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  8003c3:	00 00 00 
  8003c6:	ff d0                	callq  *%rax
  8003c8:	48 83 c4 10          	add    $0x10,%rsp
}
  8003cc:	c9                   	leaveq 
  8003cd:	c3                   	retq   

00000000008003ce <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003ce:	55                   	push   %rbp
  8003cf:	48 89 e5             	mov    %rsp,%rbp
  8003d2:	48 83 ec 10          	sub    $0x10,%rsp
  8003d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003d9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003dc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003df:	48 63 d0             	movslq %eax,%rdx
  8003e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003e5:	48 98                	cltq   
  8003e7:	48 83 ec 08          	sub    $0x8,%rsp
  8003eb:	6a 00                	pushq  $0x0
  8003ed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003f9:	48 89 d1             	mov    %rdx,%rcx
  8003fc:	48 89 c2             	mov    %rax,%rdx
  8003ff:	be 01 00 00 00       	mov    $0x1,%esi
  800404:	bf 08 00 00 00       	mov    $0x8,%edi
  800409:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  800410:	00 00 00 
  800413:	ff d0                	callq  *%rax
  800415:	48 83 c4 10          	add    $0x10,%rsp
}
  800419:	c9                   	leaveq 
  80041a:	c3                   	retq   

000000000080041b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80041b:	55                   	push   %rbp
  80041c:	48 89 e5             	mov    %rsp,%rbp
  80041f:	48 83 ec 10          	sub    $0x10,%rsp
  800423:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800426:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80042a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800431:	48 98                	cltq   
  800433:	48 83 ec 08          	sub    $0x8,%rsp
  800437:	6a 00                	pushq  $0x0
  800439:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80043f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800445:	48 89 d1             	mov    %rdx,%rcx
  800448:	48 89 c2             	mov    %rax,%rdx
  80044b:	be 01 00 00 00       	mov    $0x1,%esi
  800450:	bf 09 00 00 00       	mov    $0x9,%edi
  800455:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  80045c:	00 00 00 
  80045f:	ff d0                	callq  *%rax
  800461:	48 83 c4 10          	add    $0x10,%rsp
}
  800465:	c9                   	leaveq 
  800466:	c3                   	retq   

0000000000800467 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800467:	55                   	push   %rbp
  800468:	48 89 e5             	mov    %rsp,%rbp
  80046b:	48 83 ec 20          	sub    $0x20,%rsp
  80046f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800472:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800476:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80047a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80047d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800480:	48 63 f0             	movslq %eax,%rsi
  800483:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800487:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80048a:	48 98                	cltq   
  80048c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800490:	48 83 ec 08          	sub    $0x8,%rsp
  800494:	6a 00                	pushq  $0x0
  800496:	49 89 f1             	mov    %rsi,%r9
  800499:	49 89 c8             	mov    %rcx,%r8
  80049c:	48 89 d1             	mov    %rdx,%rcx
  80049f:	48 89 c2             	mov    %rax,%rdx
  8004a2:	be 00 00 00 00       	mov    $0x0,%esi
  8004a7:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004ac:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  8004b3:	00 00 00 
  8004b6:	ff d0                	callq  *%rax
  8004b8:	48 83 c4 10          	add    $0x10,%rsp
}
  8004bc:	c9                   	leaveq 
  8004bd:	c3                   	retq   

00000000008004be <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004be:	55                   	push   %rbp
  8004bf:	48 89 e5             	mov    %rsp,%rbp
  8004c2:	48 83 ec 10          	sub    $0x10,%rsp
  8004c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ce:	48 83 ec 08          	sub    $0x8,%rsp
  8004d2:	6a 00                	pushq  $0x0
  8004d4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004da:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004e5:	48 89 c2             	mov    %rax,%rdx
  8004e8:	be 01 00 00 00       	mov    $0x1,%esi
  8004ed:	bf 0c 00 00 00       	mov    $0xc,%edi
  8004f2:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  8004f9:	00 00 00 
  8004fc:	ff d0                	callq  *%rax
  8004fe:	48 83 c4 10          	add    $0x10,%rsp
}
  800502:	c9                   	leaveq 
  800503:	c3                   	retq   

0000000000800504 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800504:	55                   	push   %rbp
  800505:	48 89 e5             	mov    %rsp,%rbp
  800508:	53                   	push   %rbx
  800509:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800510:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800517:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80051d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800524:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80052b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800532:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800539:	84 c0                	test   %al,%al
  80053b:	74 23                	je     800560 <_panic+0x5c>
  80053d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800544:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800548:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80054c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800550:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800554:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800558:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80055c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800560:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800567:	00 00 00 
  80056a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800571:	00 00 00 
  800574:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800578:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80057f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800586:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80058d:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800594:	00 00 00 
  800597:	48 8b 18             	mov    (%rax),%rbx
  80059a:	48 b8 57 02 80 00 00 	movabs $0x800257,%rax
  8005a1:	00 00 00 
  8005a4:	ff d0                	callq  *%rax
  8005a6:	89 c6                	mov    %eax,%esi
  8005a8:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8005ae:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8005b5:	41 89 d0             	mov    %edx,%r8d
  8005b8:	48 89 c1             	mov    %rax,%rcx
  8005bb:	48 89 da             	mov    %rbx,%rdx
  8005be:	48 bf 78 1a 80 00 00 	movabs $0x801a78,%rdi
  8005c5:	00 00 00 
  8005c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005cd:	49 b9 3e 07 80 00 00 	movabs $0x80073e,%r9
  8005d4:	00 00 00 
  8005d7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005da:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005e1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005e8:	48 89 d6             	mov    %rdx,%rsi
  8005eb:	48 89 c7             	mov    %rax,%rdi
  8005ee:	48 b8 92 06 80 00 00 	movabs $0x800692,%rax
  8005f5:	00 00 00 
  8005f8:	ff d0                	callq  *%rax
	cprintf("\n");
  8005fa:	48 bf 9b 1a 80 00 00 	movabs $0x801a9b,%rdi
  800601:	00 00 00 
  800604:	b8 00 00 00 00       	mov    $0x0,%eax
  800609:	48 ba 3e 07 80 00 00 	movabs $0x80073e,%rdx
  800610:	00 00 00 
  800613:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800615:	cc                   	int3   
  800616:	eb fd                	jmp    800615 <_panic+0x111>

0000000000800618 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800618:	55                   	push   %rbp
  800619:	48 89 e5             	mov    %rsp,%rbp
  80061c:	48 83 ec 10          	sub    $0x10,%rsp
  800620:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800623:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800627:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062b:	8b 00                	mov    (%rax),%eax
  80062d:	8d 48 01             	lea    0x1(%rax),%ecx
  800630:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800634:	89 0a                	mov    %ecx,(%rdx)
  800636:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800639:	89 d1                	mov    %edx,%ecx
  80063b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80063f:	48 98                	cltq   
  800641:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800645:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800649:	8b 00                	mov    (%rax),%eax
  80064b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800650:	75 2c                	jne    80067e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800652:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800656:	8b 00                	mov    (%rax),%eax
  800658:	48 98                	cltq   
  80065a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80065e:	48 83 c2 08          	add    $0x8,%rdx
  800662:	48 89 c6             	mov    %rax,%rsi
  800665:	48 89 d7             	mov    %rdx,%rdi
  800668:	48 b8 88 01 80 00 00 	movabs $0x800188,%rax
  80066f:	00 00 00 
  800672:	ff d0                	callq  *%rax
        b->idx = 0;
  800674:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800678:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80067e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800682:	8b 40 04             	mov    0x4(%rax),%eax
  800685:	8d 50 01             	lea    0x1(%rax),%edx
  800688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068c:	89 50 04             	mov    %edx,0x4(%rax)
}
  80068f:	90                   	nop
  800690:	c9                   	leaveq 
  800691:	c3                   	retq   

0000000000800692 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800692:	55                   	push   %rbp
  800693:	48 89 e5             	mov    %rsp,%rbp
  800696:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80069d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006a4:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006ab:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006b2:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006b9:	48 8b 0a             	mov    (%rdx),%rcx
  8006bc:	48 89 08             	mov    %rcx,(%rax)
  8006bf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006c3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006c7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006cb:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006cf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006d6:	00 00 00 
    b.cnt = 0;
  8006d9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006e0:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006e3:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006ea:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006f1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006f8:	48 89 c6             	mov    %rax,%rsi
  8006fb:	48 bf 18 06 80 00 00 	movabs $0x800618,%rdi
  800702:	00 00 00 
  800705:	48 b8 dc 0a 80 00 00 	movabs $0x800adc,%rax
  80070c:	00 00 00 
  80070f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800711:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800717:	48 98                	cltq   
  800719:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800720:	48 83 c2 08          	add    $0x8,%rdx
  800724:	48 89 c6             	mov    %rax,%rsi
  800727:	48 89 d7             	mov    %rdx,%rdi
  80072a:	48 b8 88 01 80 00 00 	movabs $0x800188,%rax
  800731:	00 00 00 
  800734:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800736:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80073c:	c9                   	leaveq 
  80073d:	c3                   	retq   

000000000080073e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80073e:	55                   	push   %rbp
  80073f:	48 89 e5             	mov    %rsp,%rbp
  800742:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800749:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800750:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800757:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80075e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800765:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80076c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800773:	84 c0                	test   %al,%al
  800775:	74 20                	je     800797 <cprintf+0x59>
  800777:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80077b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80077f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800783:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800787:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80078b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80078f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800793:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800797:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80079e:	00 00 00 
  8007a1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007a8:	00 00 00 
  8007ab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007af:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007b6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007bd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007c4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007cb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007d2:	48 8b 0a             	mov    (%rdx),%rcx
  8007d5:	48 89 08             	mov    %rcx,(%rax)
  8007d8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007dc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007e0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007e4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007e8:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007ef:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007f6:	48 89 d6             	mov    %rdx,%rsi
  8007f9:	48 89 c7             	mov    %rax,%rdi
  8007fc:	48 b8 92 06 80 00 00 	movabs $0x800692,%rax
  800803:	00 00 00 
  800806:	ff d0                	callq  *%rax
  800808:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80080e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800814:	c9                   	leaveq 
  800815:	c3                   	retq   

0000000000800816 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800816:	55                   	push   %rbp
  800817:	48 89 e5             	mov    %rsp,%rbp
  80081a:	48 83 ec 30          	sub    $0x30,%rsp
  80081e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800822:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800826:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80082a:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80082d:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800831:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800835:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800838:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80083c:	77 54                	ja     800892 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80083e:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800841:	8d 78 ff             	lea    -0x1(%rax),%edi
  800844:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800847:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084b:	ba 00 00 00 00       	mov    $0x0,%edx
  800850:	48 f7 f6             	div    %rsi
  800853:	49 89 c2             	mov    %rax,%r10
  800856:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800859:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80085c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800860:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800864:	41 89 c9             	mov    %ecx,%r9d
  800867:	41 89 f8             	mov    %edi,%r8d
  80086a:	89 d1                	mov    %edx,%ecx
  80086c:	4c 89 d2             	mov    %r10,%rdx
  80086f:	48 89 c7             	mov    %rax,%rdi
  800872:	48 b8 16 08 80 00 00 	movabs $0x800816,%rax
  800879:	00 00 00 
  80087c:	ff d0                	callq  *%rax
  80087e:	eb 1c                	jmp    80089c <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800880:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800884:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800887:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80088b:	48 89 ce             	mov    %rcx,%rsi
  80088e:	89 d7                	mov    %edx,%edi
  800890:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800892:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800896:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80089a:	7f e4                	jg     800880 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80089c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80089f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a8:	48 f7 f1             	div    %rcx
  8008ab:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  8008b2:	00 00 00 
  8008b5:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8008b9:	0f be d0             	movsbl %al,%edx
  8008bc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8008c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008c4:	48 89 ce             	mov    %rcx,%rsi
  8008c7:	89 d7                	mov    %edx,%edi
  8008c9:	ff d0                	callq  *%rax
}
  8008cb:	90                   	nop
  8008cc:	c9                   	leaveq 
  8008cd:	c3                   	retq   

00000000008008ce <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ce:	55                   	push   %rbp
  8008cf:	48 89 e5             	mov    %rsp,%rbp
  8008d2:	48 83 ec 20          	sub    $0x20,%rsp
  8008d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008da:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008dd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008e1:	7e 4f                	jle    800932 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8008e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e7:	8b 00                	mov    (%rax),%eax
  8008e9:	83 f8 30             	cmp    $0x30,%eax
  8008ec:	73 24                	jae    800912 <getuint+0x44>
  8008ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fa:	8b 00                	mov    (%rax),%eax
  8008fc:	89 c0                	mov    %eax,%eax
  8008fe:	48 01 d0             	add    %rdx,%rax
  800901:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800905:	8b 12                	mov    (%rdx),%edx
  800907:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80090a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090e:	89 0a                	mov    %ecx,(%rdx)
  800910:	eb 14                	jmp    800926 <getuint+0x58>
  800912:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800916:	48 8b 40 08          	mov    0x8(%rax),%rax
  80091a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80091e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800922:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800926:	48 8b 00             	mov    (%rax),%rax
  800929:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80092d:	e9 9d 00 00 00       	jmpq   8009cf <getuint+0x101>
	else if (lflag)
  800932:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800936:	74 4c                	je     800984 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800938:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093c:	8b 00                	mov    (%rax),%eax
  80093e:	83 f8 30             	cmp    $0x30,%eax
  800941:	73 24                	jae    800967 <getuint+0x99>
  800943:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800947:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80094b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094f:	8b 00                	mov    (%rax),%eax
  800951:	89 c0                	mov    %eax,%eax
  800953:	48 01 d0             	add    %rdx,%rax
  800956:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095a:	8b 12                	mov    (%rdx),%edx
  80095c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80095f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800963:	89 0a                	mov    %ecx,(%rdx)
  800965:	eb 14                	jmp    80097b <getuint+0xad>
  800967:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80096f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800973:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800977:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80097b:	48 8b 00             	mov    (%rax),%rax
  80097e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800982:	eb 4b                	jmp    8009cf <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800984:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800988:	8b 00                	mov    (%rax),%eax
  80098a:	83 f8 30             	cmp    $0x30,%eax
  80098d:	73 24                	jae    8009b3 <getuint+0xe5>
  80098f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800993:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099b:	8b 00                	mov    (%rax),%eax
  80099d:	89 c0                	mov    %eax,%eax
  80099f:	48 01 d0             	add    %rdx,%rax
  8009a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a6:	8b 12                	mov    (%rdx),%edx
  8009a8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009af:	89 0a                	mov    %ecx,(%rdx)
  8009b1:	eb 14                	jmp    8009c7 <getuint+0xf9>
  8009b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009bb:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009c7:	8b 00                	mov    (%rax),%eax
  8009c9:	89 c0                	mov    %eax,%eax
  8009cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009d3:	c9                   	leaveq 
  8009d4:	c3                   	retq   

00000000008009d5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009d5:	55                   	push   %rbp
  8009d6:	48 89 e5             	mov    %rsp,%rbp
  8009d9:	48 83 ec 20          	sub    $0x20,%rsp
  8009dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009e1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009e4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009e8:	7e 4f                	jle    800a39 <getint+0x64>
		x=va_arg(*ap, long long);
  8009ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ee:	8b 00                	mov    (%rax),%eax
  8009f0:	83 f8 30             	cmp    $0x30,%eax
  8009f3:	73 24                	jae    800a19 <getint+0x44>
  8009f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a01:	8b 00                	mov    (%rax),%eax
  800a03:	89 c0                	mov    %eax,%eax
  800a05:	48 01 d0             	add    %rdx,%rax
  800a08:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a0c:	8b 12                	mov    (%rdx),%edx
  800a0e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a15:	89 0a                	mov    %ecx,(%rdx)
  800a17:	eb 14                	jmp    800a2d <getint+0x58>
  800a19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a21:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a25:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a29:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a2d:	48 8b 00             	mov    (%rax),%rax
  800a30:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a34:	e9 9d 00 00 00       	jmpq   800ad6 <getint+0x101>
	else if (lflag)
  800a39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a3d:	74 4c                	je     800a8b <getint+0xb6>
		x=va_arg(*ap, long);
  800a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a43:	8b 00                	mov    (%rax),%eax
  800a45:	83 f8 30             	cmp    $0x30,%eax
  800a48:	73 24                	jae    800a6e <getint+0x99>
  800a4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a56:	8b 00                	mov    (%rax),%eax
  800a58:	89 c0                	mov    %eax,%eax
  800a5a:	48 01 d0             	add    %rdx,%rax
  800a5d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a61:	8b 12                	mov    (%rdx),%edx
  800a63:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a66:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6a:	89 0a                	mov    %ecx,(%rdx)
  800a6c:	eb 14                	jmp    800a82 <getint+0xad>
  800a6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a72:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a76:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a7a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a82:	48 8b 00             	mov    (%rax),%rax
  800a85:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a89:	eb 4b                	jmp    800ad6 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800a8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8f:	8b 00                	mov    (%rax),%eax
  800a91:	83 f8 30             	cmp    $0x30,%eax
  800a94:	73 24                	jae    800aba <getint+0xe5>
  800a96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa2:	8b 00                	mov    (%rax),%eax
  800aa4:	89 c0                	mov    %eax,%eax
  800aa6:	48 01 d0             	add    %rdx,%rax
  800aa9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aad:	8b 12                	mov    (%rdx),%edx
  800aaf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ab2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab6:	89 0a                	mov    %ecx,(%rdx)
  800ab8:	eb 14                	jmp    800ace <getint+0xf9>
  800aba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abe:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ac2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ac6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aca:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ace:	8b 00                	mov    (%rax),%eax
  800ad0:	48 98                	cltq   
  800ad2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ad6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ada:	c9                   	leaveq 
  800adb:	c3                   	retq   

0000000000800adc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800adc:	55                   	push   %rbp
  800add:	48 89 e5             	mov    %rsp,%rbp
  800ae0:	41 54                	push   %r12
  800ae2:	53                   	push   %rbx
  800ae3:	48 83 ec 60          	sub    $0x60,%rsp
  800ae7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800aeb:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800aef:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800af3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800af7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800afb:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800aff:	48 8b 0a             	mov    (%rdx),%rcx
  800b02:	48 89 08             	mov    %rcx,(%rax)
  800b05:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b09:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b0d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b11:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b15:	eb 17                	jmp    800b2e <vprintfmt+0x52>
			if (ch == '\0')
  800b17:	85 db                	test   %ebx,%ebx
  800b19:	0f 84 b9 04 00 00    	je     800fd8 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800b1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b27:	48 89 d6             	mov    %rdx,%rsi
  800b2a:	89 df                	mov    %ebx,%edi
  800b2c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b2e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b32:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b36:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b3a:	0f b6 00             	movzbl (%rax),%eax
  800b3d:	0f b6 d8             	movzbl %al,%ebx
  800b40:	83 fb 25             	cmp    $0x25,%ebx
  800b43:	75 d2                	jne    800b17 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b45:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b49:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b50:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b57:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b5e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b65:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b69:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b6d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b71:	0f b6 00             	movzbl (%rax),%eax
  800b74:	0f b6 d8             	movzbl %al,%ebx
  800b77:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b7a:	83 f8 55             	cmp    $0x55,%eax
  800b7d:	0f 87 22 04 00 00    	ja     800fa5 <vprintfmt+0x4c9>
  800b83:	89 c0                	mov    %eax,%eax
  800b85:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b8c:	00 
  800b8d:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  800b94:	00 00 00 
  800b97:	48 01 d0             	add    %rdx,%rax
  800b9a:	48 8b 00             	mov    (%rax),%rax
  800b9d:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800b9f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ba3:	eb c0                	jmp    800b65 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ba5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ba9:	eb ba                	jmp    800b65 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bab:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bb2:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bb5:	89 d0                	mov    %edx,%eax
  800bb7:	c1 e0 02             	shl    $0x2,%eax
  800bba:	01 d0                	add    %edx,%eax
  800bbc:	01 c0                	add    %eax,%eax
  800bbe:	01 d8                	add    %ebx,%eax
  800bc0:	83 e8 30             	sub    $0x30,%eax
  800bc3:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bc6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bca:	0f b6 00             	movzbl (%rax),%eax
  800bcd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bd0:	83 fb 2f             	cmp    $0x2f,%ebx
  800bd3:	7e 60                	jle    800c35 <vprintfmt+0x159>
  800bd5:	83 fb 39             	cmp    $0x39,%ebx
  800bd8:	7f 5b                	jg     800c35 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bda:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bdf:	eb d1                	jmp    800bb2 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800be1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be4:	83 f8 30             	cmp    $0x30,%eax
  800be7:	73 17                	jae    800c00 <vprintfmt+0x124>
  800be9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800bed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf0:	89 d2                	mov    %edx,%edx
  800bf2:	48 01 d0             	add    %rdx,%rax
  800bf5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf8:	83 c2 08             	add    $0x8,%edx
  800bfb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bfe:	eb 0c                	jmp    800c0c <vprintfmt+0x130>
  800c00:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c04:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c08:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c0c:	8b 00                	mov    (%rax),%eax
  800c0e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c11:	eb 23                	jmp    800c36 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800c13:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c17:	0f 89 48 ff ff ff    	jns    800b65 <vprintfmt+0x89>
				width = 0;
  800c1d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c24:	e9 3c ff ff ff       	jmpq   800b65 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c29:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c30:	e9 30 ff ff ff       	jmpq   800b65 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c35:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c36:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c3a:	0f 89 25 ff ff ff    	jns    800b65 <vprintfmt+0x89>
				width = precision, precision = -1;
  800c40:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c43:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c46:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c4d:	e9 13 ff ff ff       	jmpq   800b65 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c52:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c56:	e9 0a ff ff ff       	jmpq   800b65 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c5b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c5e:	83 f8 30             	cmp    $0x30,%eax
  800c61:	73 17                	jae    800c7a <vprintfmt+0x19e>
  800c63:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c67:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c6a:	89 d2                	mov    %edx,%edx
  800c6c:	48 01 d0             	add    %rdx,%rax
  800c6f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c72:	83 c2 08             	add    $0x8,%edx
  800c75:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c78:	eb 0c                	jmp    800c86 <vprintfmt+0x1aa>
  800c7a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c7e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c82:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c86:	8b 10                	mov    (%rax),%edx
  800c88:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c8c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c90:	48 89 ce             	mov    %rcx,%rsi
  800c93:	89 d7                	mov    %edx,%edi
  800c95:	ff d0                	callq  *%rax
			break;
  800c97:	e9 37 03 00 00       	jmpq   800fd3 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800c9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9f:	83 f8 30             	cmp    $0x30,%eax
  800ca2:	73 17                	jae    800cbb <vprintfmt+0x1df>
  800ca4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ca8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cab:	89 d2                	mov    %edx,%edx
  800cad:	48 01 d0             	add    %rdx,%rax
  800cb0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb3:	83 c2 08             	add    $0x8,%edx
  800cb6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cb9:	eb 0c                	jmp    800cc7 <vprintfmt+0x1eb>
  800cbb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cbf:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cc3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cc9:	85 db                	test   %ebx,%ebx
  800ccb:	79 02                	jns    800ccf <vprintfmt+0x1f3>
				err = -err;
  800ccd:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ccf:	83 fb 15             	cmp    $0x15,%ebx
  800cd2:	7f 16                	jg     800cea <vprintfmt+0x20e>
  800cd4:	48 b8 40 1b 80 00 00 	movabs $0x801b40,%rax
  800cdb:	00 00 00 
  800cde:	48 63 d3             	movslq %ebx,%rdx
  800ce1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ce5:	4d 85 e4             	test   %r12,%r12
  800ce8:	75 2e                	jne    800d18 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800cea:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf2:	89 d9                	mov    %ebx,%ecx
  800cf4:	48 ba 01 1c 80 00 00 	movabs $0x801c01,%rdx
  800cfb:	00 00 00 
  800cfe:	48 89 c7             	mov    %rax,%rdi
  800d01:	b8 00 00 00 00       	mov    $0x0,%eax
  800d06:	49 b8 e2 0f 80 00 00 	movabs $0x800fe2,%r8
  800d0d:	00 00 00 
  800d10:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d13:	e9 bb 02 00 00       	jmpq   800fd3 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d18:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d20:	4c 89 e1             	mov    %r12,%rcx
  800d23:	48 ba 0a 1c 80 00 00 	movabs $0x801c0a,%rdx
  800d2a:	00 00 00 
  800d2d:	48 89 c7             	mov    %rax,%rdi
  800d30:	b8 00 00 00 00       	mov    $0x0,%eax
  800d35:	49 b8 e2 0f 80 00 00 	movabs $0x800fe2,%r8
  800d3c:	00 00 00 
  800d3f:	41 ff d0             	callq  *%r8
			break;
  800d42:	e9 8c 02 00 00       	jmpq   800fd3 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d47:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d4a:	83 f8 30             	cmp    $0x30,%eax
  800d4d:	73 17                	jae    800d66 <vprintfmt+0x28a>
  800d4f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d53:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d56:	89 d2                	mov    %edx,%edx
  800d58:	48 01 d0             	add    %rdx,%rax
  800d5b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d5e:	83 c2 08             	add    $0x8,%edx
  800d61:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d64:	eb 0c                	jmp    800d72 <vprintfmt+0x296>
  800d66:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d6a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d6e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d72:	4c 8b 20             	mov    (%rax),%r12
  800d75:	4d 85 e4             	test   %r12,%r12
  800d78:	75 0a                	jne    800d84 <vprintfmt+0x2a8>
				p = "(null)";
  800d7a:	49 bc 0d 1c 80 00 00 	movabs $0x801c0d,%r12
  800d81:	00 00 00 
			if (width > 0 && padc != '-')
  800d84:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d88:	7e 78                	jle    800e02 <vprintfmt+0x326>
  800d8a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d8e:	74 72                	je     800e02 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d90:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d93:	48 98                	cltq   
  800d95:	48 89 c6             	mov    %rax,%rsi
  800d98:	4c 89 e7             	mov    %r12,%rdi
  800d9b:	48 b8 90 12 80 00 00 	movabs $0x801290,%rax
  800da2:	00 00 00 
  800da5:	ff d0                	callq  *%rax
  800da7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800daa:	eb 17                	jmp    800dc3 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800dac:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800db0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800db4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db8:	48 89 ce             	mov    %rcx,%rsi
  800dbb:	89 d7                	mov    %edx,%edi
  800dbd:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dbf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dc3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dc7:	7f e3                	jg     800dac <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dc9:	eb 37                	jmp    800e02 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800dcb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800dcf:	74 1e                	je     800def <vprintfmt+0x313>
  800dd1:	83 fb 1f             	cmp    $0x1f,%ebx
  800dd4:	7e 05                	jle    800ddb <vprintfmt+0x2ff>
  800dd6:	83 fb 7e             	cmp    $0x7e,%ebx
  800dd9:	7e 14                	jle    800def <vprintfmt+0x313>
					putch('?', putdat);
  800ddb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ddf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de3:	48 89 d6             	mov    %rdx,%rsi
  800de6:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800deb:	ff d0                	callq  *%rax
  800ded:	eb 0f                	jmp    800dfe <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800def:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df7:	48 89 d6             	mov    %rdx,%rsi
  800dfa:	89 df                	mov    %ebx,%edi
  800dfc:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dfe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e02:	4c 89 e0             	mov    %r12,%rax
  800e05:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e09:	0f b6 00             	movzbl (%rax),%eax
  800e0c:	0f be d8             	movsbl %al,%ebx
  800e0f:	85 db                	test   %ebx,%ebx
  800e11:	74 28                	je     800e3b <vprintfmt+0x35f>
  800e13:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e17:	78 b2                	js     800dcb <vprintfmt+0x2ef>
  800e19:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e1d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e21:	79 a8                	jns    800dcb <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e23:	eb 16                	jmp    800e3b <vprintfmt+0x35f>
				putch(' ', putdat);
  800e25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2d:	48 89 d6             	mov    %rdx,%rsi
  800e30:	bf 20 00 00 00       	mov    $0x20,%edi
  800e35:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e37:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e3b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e3f:	7f e4                	jg     800e25 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800e41:	e9 8d 01 00 00       	jmpq   800fd3 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e46:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e4a:	be 03 00 00 00       	mov    $0x3,%esi
  800e4f:	48 89 c7             	mov    %rax,%rdi
  800e52:	48 b8 d5 09 80 00 00 	movabs $0x8009d5,%rax
  800e59:	00 00 00 
  800e5c:	ff d0                	callq  *%rax
  800e5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e66:	48 85 c0             	test   %rax,%rax
  800e69:	79 1d                	jns    800e88 <vprintfmt+0x3ac>
				putch('-', putdat);
  800e6b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e73:	48 89 d6             	mov    %rdx,%rsi
  800e76:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e7b:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e81:	48 f7 d8             	neg    %rax
  800e84:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e88:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e8f:	e9 d2 00 00 00       	jmpq   800f66 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e94:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e98:	be 03 00 00 00       	mov    $0x3,%esi
  800e9d:	48 89 c7             	mov    %rax,%rdi
  800ea0:	48 b8 ce 08 80 00 00 	movabs $0x8008ce,%rax
  800ea7:	00 00 00 
  800eaa:	ff d0                	callq  *%rax
  800eac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800eb0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800eb7:	e9 aa 00 00 00       	jmpq   800f66 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800ebc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ec0:	be 03 00 00 00       	mov    $0x3,%esi
  800ec5:	48 89 c7             	mov    %rax,%rdi
  800ec8:	48 b8 ce 08 80 00 00 	movabs $0x8008ce,%rax
  800ecf:	00 00 00 
  800ed2:	ff d0                	callq  *%rax
  800ed4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ed8:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800edf:	e9 82 00 00 00       	jmpq   800f66 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800ee4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eec:	48 89 d6             	mov    %rdx,%rsi
  800eef:	bf 30 00 00 00       	mov    $0x30,%edi
  800ef4:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ef6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800efa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efe:	48 89 d6             	mov    %rdx,%rsi
  800f01:	bf 78 00 00 00       	mov    $0x78,%edi
  800f06:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f0b:	83 f8 30             	cmp    $0x30,%eax
  800f0e:	73 17                	jae    800f27 <vprintfmt+0x44b>
  800f10:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f14:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f17:	89 d2                	mov    %edx,%edx
  800f19:	48 01 d0             	add    %rdx,%rax
  800f1c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f1f:	83 c2 08             	add    $0x8,%edx
  800f22:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f25:	eb 0c                	jmp    800f33 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800f27:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800f2b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800f2f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f33:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f36:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f3a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f41:	eb 23                	jmp    800f66 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f43:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f47:	be 03 00 00 00       	mov    $0x3,%esi
  800f4c:	48 89 c7             	mov    %rax,%rdi
  800f4f:	48 b8 ce 08 80 00 00 	movabs $0x8008ce,%rax
  800f56:	00 00 00 
  800f59:	ff d0                	callq  *%rax
  800f5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f5f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f66:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f6b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f6e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f71:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f75:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f79:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f7d:	45 89 c1             	mov    %r8d,%r9d
  800f80:	41 89 f8             	mov    %edi,%r8d
  800f83:	48 89 c7             	mov    %rax,%rdi
  800f86:	48 b8 16 08 80 00 00 	movabs $0x800816,%rax
  800f8d:	00 00 00 
  800f90:	ff d0                	callq  *%rax
			break;
  800f92:	eb 3f                	jmp    800fd3 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f94:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f9c:	48 89 d6             	mov    %rdx,%rsi
  800f9f:	89 df                	mov    %ebx,%edi
  800fa1:	ff d0                	callq  *%rax
			break;
  800fa3:	eb 2e                	jmp    800fd3 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fa5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fa9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fad:	48 89 d6             	mov    %rdx,%rsi
  800fb0:	bf 25 00 00 00       	mov    $0x25,%edi
  800fb5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fb7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fbc:	eb 05                	jmp    800fc3 <vprintfmt+0x4e7>
  800fbe:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fc3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fc7:	48 83 e8 01          	sub    $0x1,%rax
  800fcb:	0f b6 00             	movzbl (%rax),%eax
  800fce:	3c 25                	cmp    $0x25,%al
  800fd0:	75 ec                	jne    800fbe <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800fd2:	90                   	nop
		}
	}
  800fd3:	e9 3d fb ff ff       	jmpq   800b15 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fd8:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800fd9:	48 83 c4 60          	add    $0x60,%rsp
  800fdd:	5b                   	pop    %rbx
  800fde:	41 5c                	pop    %r12
  800fe0:	5d                   	pop    %rbp
  800fe1:	c3                   	retq   

0000000000800fe2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fe2:	55                   	push   %rbp
  800fe3:	48 89 e5             	mov    %rsp,%rbp
  800fe6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800fed:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ff4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ffb:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  801002:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801009:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801010:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801017:	84 c0                	test   %al,%al
  801019:	74 20                	je     80103b <printfmt+0x59>
  80101b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80101f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801023:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801027:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80102b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80102f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801033:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801037:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80103b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801042:	00 00 00 
  801045:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80104c:	00 00 00 
  80104f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801053:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80105a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801061:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801068:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80106f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801076:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80107d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801084:	48 89 c7             	mov    %rax,%rdi
  801087:	48 b8 dc 0a 80 00 00 	movabs $0x800adc,%rax
  80108e:	00 00 00 
  801091:	ff d0                	callq  *%rax
	va_end(ap);
}
  801093:	90                   	nop
  801094:	c9                   	leaveq 
  801095:	c3                   	retq   

0000000000801096 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801096:	55                   	push   %rbp
  801097:	48 89 e5             	mov    %rsp,%rbp
  80109a:	48 83 ec 10          	sub    $0x10,%rsp
  80109e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a9:	8b 40 10             	mov    0x10(%rax),%eax
  8010ac:	8d 50 01             	lea    0x1(%rax),%edx
  8010af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ba:	48 8b 10             	mov    (%rax),%rdx
  8010bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010c5:	48 39 c2             	cmp    %rax,%rdx
  8010c8:	73 17                	jae    8010e1 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ce:	48 8b 00             	mov    (%rax),%rax
  8010d1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010d9:	48 89 0a             	mov    %rcx,(%rdx)
  8010dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010df:	88 10                	mov    %dl,(%rax)
}
  8010e1:	90                   	nop
  8010e2:	c9                   	leaveq 
  8010e3:	c3                   	retq   

00000000008010e4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010e4:	55                   	push   %rbp
  8010e5:	48 89 e5             	mov    %rsp,%rbp
  8010e8:	48 83 ec 50          	sub    $0x50,%rsp
  8010ec:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010f0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8010f3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8010f7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8010fb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8010ff:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801103:	48 8b 0a             	mov    (%rdx),%rcx
  801106:	48 89 08             	mov    %rcx,(%rax)
  801109:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80110d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801111:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801115:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801119:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80111d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801121:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801124:	48 98                	cltq   
  801126:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80112a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80112e:	48 01 d0             	add    %rdx,%rax
  801131:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801135:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80113c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801141:	74 06                	je     801149 <vsnprintf+0x65>
  801143:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801147:	7f 07                	jg     801150 <vsnprintf+0x6c>
		return -E_INVAL;
  801149:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80114e:	eb 2f                	jmp    80117f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801150:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801154:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801158:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80115c:	48 89 c6             	mov    %rax,%rsi
  80115f:	48 bf 96 10 80 00 00 	movabs $0x801096,%rdi
  801166:	00 00 00 
  801169:	48 b8 dc 0a 80 00 00 	movabs $0x800adc,%rax
  801170:	00 00 00 
  801173:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801175:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801179:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80117c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80117f:	c9                   	leaveq 
  801180:	c3                   	retq   

0000000000801181 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801181:	55                   	push   %rbp
  801182:	48 89 e5             	mov    %rsp,%rbp
  801185:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80118c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801193:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801199:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8011a0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011a7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011ae:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011b5:	84 c0                	test   %al,%al
  8011b7:	74 20                	je     8011d9 <snprintf+0x58>
  8011b9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011bd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011c1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011c5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011c9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011cd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011d1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011d5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011d9:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011e0:	00 00 00 
  8011e3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011ea:	00 00 00 
  8011ed:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011f1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8011f8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011ff:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801206:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80120d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801214:	48 8b 0a             	mov    (%rdx),%rcx
  801217:	48 89 08             	mov    %rcx,(%rax)
  80121a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80121e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801222:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801226:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80122a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801231:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801238:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80123e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801245:	48 89 c7             	mov    %rax,%rdi
  801248:	48 b8 e4 10 80 00 00 	movabs $0x8010e4,%rax
  80124f:	00 00 00 
  801252:	ff d0                	callq  *%rax
  801254:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80125a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801260:	c9                   	leaveq 
  801261:	c3                   	retq   

0000000000801262 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801262:	55                   	push   %rbp
  801263:	48 89 e5             	mov    %rsp,%rbp
  801266:	48 83 ec 18          	sub    $0x18,%rsp
  80126a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80126e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801275:	eb 09                	jmp    801280 <strlen+0x1e>
		n++;
  801277:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80127b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801280:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801284:	0f b6 00             	movzbl (%rax),%eax
  801287:	84 c0                	test   %al,%al
  801289:	75 ec                	jne    801277 <strlen+0x15>
		n++;
	return n;
  80128b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80128e:	c9                   	leaveq 
  80128f:	c3                   	retq   

0000000000801290 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801290:	55                   	push   %rbp
  801291:	48 89 e5             	mov    %rsp,%rbp
  801294:	48 83 ec 20          	sub    $0x20,%rsp
  801298:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80129c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012a7:	eb 0e                	jmp    8012b7 <strnlen+0x27>
		n++;
  8012a9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ad:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012b2:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012b7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012bc:	74 0b                	je     8012c9 <strnlen+0x39>
  8012be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c2:	0f b6 00             	movzbl (%rax),%eax
  8012c5:	84 c0                	test   %al,%al
  8012c7:	75 e0                	jne    8012a9 <strnlen+0x19>
		n++;
	return n;
  8012c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012cc:	c9                   	leaveq 
  8012cd:	c3                   	retq   

00000000008012ce <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012ce:	55                   	push   %rbp
  8012cf:	48 89 e5             	mov    %rsp,%rbp
  8012d2:	48 83 ec 20          	sub    $0x20,%rsp
  8012d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012e6:	90                   	nop
  8012e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012eb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012ef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012f3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012f7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012fb:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012ff:	0f b6 12             	movzbl (%rdx),%edx
  801302:	88 10                	mov    %dl,(%rax)
  801304:	0f b6 00             	movzbl (%rax),%eax
  801307:	84 c0                	test   %al,%al
  801309:	75 dc                	jne    8012e7 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80130b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80130f:	c9                   	leaveq 
  801310:	c3                   	retq   

0000000000801311 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801311:	55                   	push   %rbp
  801312:	48 89 e5             	mov    %rsp,%rbp
  801315:	48 83 ec 20          	sub    $0x20,%rsp
  801319:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80131d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801321:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801325:	48 89 c7             	mov    %rax,%rdi
  801328:	48 b8 62 12 80 00 00 	movabs $0x801262,%rax
  80132f:	00 00 00 
  801332:	ff d0                	callq  *%rax
  801334:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801337:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80133a:	48 63 d0             	movslq %eax,%rdx
  80133d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801341:	48 01 c2             	add    %rax,%rdx
  801344:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801348:	48 89 c6             	mov    %rax,%rsi
  80134b:	48 89 d7             	mov    %rdx,%rdi
  80134e:	48 b8 ce 12 80 00 00 	movabs $0x8012ce,%rax
  801355:	00 00 00 
  801358:	ff d0                	callq  *%rax
	return dst;
  80135a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80135e:	c9                   	leaveq 
  80135f:	c3                   	retq   

0000000000801360 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801360:	55                   	push   %rbp
  801361:	48 89 e5             	mov    %rsp,%rbp
  801364:	48 83 ec 28          	sub    $0x28,%rsp
  801368:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80136c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801370:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801378:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80137c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801383:	00 
  801384:	eb 2a                	jmp    8013b0 <strncpy+0x50>
		*dst++ = *src;
  801386:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80138e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801392:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801396:	0f b6 12             	movzbl (%rdx),%edx
  801399:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80139b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80139f:	0f b6 00             	movzbl (%rax),%eax
  8013a2:	84 c0                	test   %al,%al
  8013a4:	74 05                	je     8013ab <strncpy+0x4b>
			src++;
  8013a6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013b8:	72 cc                	jb     801386 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013be:	c9                   	leaveq 
  8013bf:	c3                   	retq   

00000000008013c0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013c0:	55                   	push   %rbp
  8013c1:	48 89 e5             	mov    %rsp,%rbp
  8013c4:	48 83 ec 28          	sub    $0x28,%rsp
  8013c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013dc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013e1:	74 3d                	je     801420 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8013e3:	eb 1d                	jmp    801402 <strlcpy+0x42>
			*dst++ = *src++;
  8013e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013ed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013f1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013f5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013f9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013fd:	0f b6 12             	movzbl (%rdx),%edx
  801400:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801402:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801407:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80140c:	74 0b                	je     801419 <strlcpy+0x59>
  80140e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801412:	0f b6 00             	movzbl (%rax),%eax
  801415:	84 c0                	test   %al,%al
  801417:	75 cc                	jne    8013e5 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801419:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80141d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801420:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801424:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801428:	48 29 c2             	sub    %rax,%rdx
  80142b:	48 89 d0             	mov    %rdx,%rax
}
  80142e:	c9                   	leaveq 
  80142f:	c3                   	retq   

0000000000801430 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801430:	55                   	push   %rbp
  801431:	48 89 e5             	mov    %rsp,%rbp
  801434:	48 83 ec 10          	sub    $0x10,%rsp
  801438:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80143c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801440:	eb 0a                	jmp    80144c <strcmp+0x1c>
		p++, q++;
  801442:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801447:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80144c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801450:	0f b6 00             	movzbl (%rax),%eax
  801453:	84 c0                	test   %al,%al
  801455:	74 12                	je     801469 <strcmp+0x39>
  801457:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145b:	0f b6 10             	movzbl (%rax),%edx
  80145e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801462:	0f b6 00             	movzbl (%rax),%eax
  801465:	38 c2                	cmp    %al,%dl
  801467:	74 d9                	je     801442 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801469:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146d:	0f b6 00             	movzbl (%rax),%eax
  801470:	0f b6 d0             	movzbl %al,%edx
  801473:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801477:	0f b6 00             	movzbl (%rax),%eax
  80147a:	0f b6 c0             	movzbl %al,%eax
  80147d:	29 c2                	sub    %eax,%edx
  80147f:	89 d0                	mov    %edx,%eax
}
  801481:	c9                   	leaveq 
  801482:	c3                   	retq   

0000000000801483 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801483:	55                   	push   %rbp
  801484:	48 89 e5             	mov    %rsp,%rbp
  801487:	48 83 ec 18          	sub    $0x18,%rsp
  80148b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80148f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801493:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801497:	eb 0f                	jmp    8014a8 <strncmp+0x25>
		n--, p++, q++;
  801499:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80149e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014a3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014a8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014ad:	74 1d                	je     8014cc <strncmp+0x49>
  8014af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b3:	0f b6 00             	movzbl (%rax),%eax
  8014b6:	84 c0                	test   %al,%al
  8014b8:	74 12                	je     8014cc <strncmp+0x49>
  8014ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014be:	0f b6 10             	movzbl (%rax),%edx
  8014c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c5:	0f b6 00             	movzbl (%rax),%eax
  8014c8:	38 c2                	cmp    %al,%dl
  8014ca:	74 cd                	je     801499 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014cc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014d1:	75 07                	jne    8014da <strncmp+0x57>
		return 0;
  8014d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d8:	eb 18                	jmp    8014f2 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014de:	0f b6 00             	movzbl (%rax),%eax
  8014e1:	0f b6 d0             	movzbl %al,%edx
  8014e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e8:	0f b6 00             	movzbl (%rax),%eax
  8014eb:	0f b6 c0             	movzbl %al,%eax
  8014ee:	29 c2                	sub    %eax,%edx
  8014f0:	89 d0                	mov    %edx,%eax
}
  8014f2:	c9                   	leaveq 
  8014f3:	c3                   	retq   

00000000008014f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014f4:	55                   	push   %rbp
  8014f5:	48 89 e5             	mov    %rsp,%rbp
  8014f8:	48 83 ec 10          	sub    $0x10,%rsp
  8014fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801500:	89 f0                	mov    %esi,%eax
  801502:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801505:	eb 17                	jmp    80151e <strchr+0x2a>
		if (*s == c)
  801507:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150b:	0f b6 00             	movzbl (%rax),%eax
  80150e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801511:	75 06                	jne    801519 <strchr+0x25>
			return (char *) s;
  801513:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801517:	eb 15                	jmp    80152e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801519:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80151e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801522:	0f b6 00             	movzbl (%rax),%eax
  801525:	84 c0                	test   %al,%al
  801527:	75 de                	jne    801507 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801529:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152e:	c9                   	leaveq 
  80152f:	c3                   	retq   

0000000000801530 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801530:	55                   	push   %rbp
  801531:	48 89 e5             	mov    %rsp,%rbp
  801534:	48 83 ec 10          	sub    $0x10,%rsp
  801538:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80153c:	89 f0                	mov    %esi,%eax
  80153e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801541:	eb 11                	jmp    801554 <strfind+0x24>
		if (*s == c)
  801543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801547:	0f b6 00             	movzbl (%rax),%eax
  80154a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80154d:	74 12                	je     801561 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80154f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801554:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801558:	0f b6 00             	movzbl (%rax),%eax
  80155b:	84 c0                	test   %al,%al
  80155d:	75 e4                	jne    801543 <strfind+0x13>
  80155f:	eb 01                	jmp    801562 <strfind+0x32>
		if (*s == c)
			break;
  801561:	90                   	nop
	return (char *) s;
  801562:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801566:	c9                   	leaveq 
  801567:	c3                   	retq   

0000000000801568 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801568:	55                   	push   %rbp
  801569:	48 89 e5             	mov    %rsp,%rbp
  80156c:	48 83 ec 18          	sub    $0x18,%rsp
  801570:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801574:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801577:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80157b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801580:	75 06                	jne    801588 <memset+0x20>
		return v;
  801582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801586:	eb 69                	jmp    8015f1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801588:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158c:	83 e0 03             	and    $0x3,%eax
  80158f:	48 85 c0             	test   %rax,%rax
  801592:	75 48                	jne    8015dc <memset+0x74>
  801594:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801598:	83 e0 03             	and    $0x3,%eax
  80159b:	48 85 c0             	test   %rax,%rax
  80159e:	75 3c                	jne    8015dc <memset+0x74>
		c &= 0xFF;
  8015a0:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015aa:	c1 e0 18             	shl    $0x18,%eax
  8015ad:	89 c2                	mov    %eax,%edx
  8015af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015b2:	c1 e0 10             	shl    $0x10,%eax
  8015b5:	09 c2                	or     %eax,%edx
  8015b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ba:	c1 e0 08             	shl    $0x8,%eax
  8015bd:	09 d0                	or     %edx,%eax
  8015bf:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c6:	48 c1 e8 02          	shr    $0x2,%rax
  8015ca:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015d4:	48 89 d7             	mov    %rdx,%rdi
  8015d7:	fc                   	cld    
  8015d8:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015da:	eb 11                	jmp    8015ed <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015e7:	48 89 d7             	mov    %rdx,%rdi
  8015ea:	fc                   	cld    
  8015eb:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8015ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015f1:	c9                   	leaveq 
  8015f2:	c3                   	retq   

00000000008015f3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015f3:	55                   	push   %rbp
  8015f4:	48 89 e5             	mov    %rsp,%rbp
  8015f7:	48 83 ec 28          	sub    $0x28,%rsp
  8015fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801603:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801607:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80160b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80160f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801613:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801617:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80161f:	0f 83 88 00 00 00    	jae    8016ad <memmove+0xba>
  801625:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801629:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162d:	48 01 d0             	add    %rdx,%rax
  801630:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801634:	76 77                	jbe    8016ad <memmove+0xba>
		s += n;
  801636:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80163e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801642:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801646:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164a:	83 e0 03             	and    $0x3,%eax
  80164d:	48 85 c0             	test   %rax,%rax
  801650:	75 3b                	jne    80168d <memmove+0x9a>
  801652:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801656:	83 e0 03             	and    $0x3,%eax
  801659:	48 85 c0             	test   %rax,%rax
  80165c:	75 2f                	jne    80168d <memmove+0x9a>
  80165e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801662:	83 e0 03             	and    $0x3,%eax
  801665:	48 85 c0             	test   %rax,%rax
  801668:	75 23                	jne    80168d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80166a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166e:	48 83 e8 04          	sub    $0x4,%rax
  801672:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801676:	48 83 ea 04          	sub    $0x4,%rdx
  80167a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80167e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801682:	48 89 c7             	mov    %rax,%rdi
  801685:	48 89 d6             	mov    %rdx,%rsi
  801688:	fd                   	std    
  801689:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80168b:	eb 1d                	jmp    8016aa <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80168d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801691:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801695:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801699:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80169d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a1:	48 89 d7             	mov    %rdx,%rdi
  8016a4:	48 89 c1             	mov    %rax,%rcx
  8016a7:	fd                   	std    
  8016a8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016aa:	fc                   	cld    
  8016ab:	eb 57                	jmp    801704 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b1:	83 e0 03             	and    $0x3,%eax
  8016b4:	48 85 c0             	test   %rax,%rax
  8016b7:	75 36                	jne    8016ef <memmove+0xfc>
  8016b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016bd:	83 e0 03             	and    $0x3,%eax
  8016c0:	48 85 c0             	test   %rax,%rax
  8016c3:	75 2a                	jne    8016ef <memmove+0xfc>
  8016c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c9:	83 e0 03             	and    $0x3,%eax
  8016cc:	48 85 c0             	test   %rax,%rax
  8016cf:	75 1e                	jne    8016ef <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d5:	48 c1 e8 02          	shr    $0x2,%rax
  8016d9:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016e4:	48 89 c7             	mov    %rax,%rdi
  8016e7:	48 89 d6             	mov    %rdx,%rsi
  8016ea:	fc                   	cld    
  8016eb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016ed:	eb 15                	jmp    801704 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016f7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016fb:	48 89 c7             	mov    %rax,%rdi
  8016fe:	48 89 d6             	mov    %rdx,%rsi
  801701:	fc                   	cld    
  801702:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801708:	c9                   	leaveq 
  801709:	c3                   	retq   

000000000080170a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80170a:	55                   	push   %rbp
  80170b:	48 89 e5             	mov    %rsp,%rbp
  80170e:	48 83 ec 18          	sub    $0x18,%rsp
  801712:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801716:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80171a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80171e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801722:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801726:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80172a:	48 89 ce             	mov    %rcx,%rsi
  80172d:	48 89 c7             	mov    %rax,%rdi
  801730:	48 b8 f3 15 80 00 00 	movabs $0x8015f3,%rax
  801737:	00 00 00 
  80173a:	ff d0                	callq  *%rax
}
  80173c:	c9                   	leaveq 
  80173d:	c3                   	retq   

000000000080173e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80173e:	55                   	push   %rbp
  80173f:	48 89 e5             	mov    %rsp,%rbp
  801742:	48 83 ec 28          	sub    $0x28,%rsp
  801746:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80174a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80174e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801752:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801756:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80175a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80175e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801762:	eb 36                	jmp    80179a <memcmp+0x5c>
		if (*s1 != *s2)
  801764:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801768:	0f b6 10             	movzbl (%rax),%edx
  80176b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80176f:	0f b6 00             	movzbl (%rax),%eax
  801772:	38 c2                	cmp    %al,%dl
  801774:	74 1a                	je     801790 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801776:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177a:	0f b6 00             	movzbl (%rax),%eax
  80177d:	0f b6 d0             	movzbl %al,%edx
  801780:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801784:	0f b6 00             	movzbl (%rax),%eax
  801787:	0f b6 c0             	movzbl %al,%eax
  80178a:	29 c2                	sub    %eax,%edx
  80178c:	89 d0                	mov    %edx,%eax
  80178e:	eb 20                	jmp    8017b0 <memcmp+0x72>
		s1++, s2++;
  801790:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801795:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80179a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017a2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017a6:	48 85 c0             	test   %rax,%rax
  8017a9:	75 b9                	jne    801764 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b0:	c9                   	leaveq 
  8017b1:	c3                   	retq   

00000000008017b2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017b2:	55                   	push   %rbp
  8017b3:	48 89 e5             	mov    %rsp,%rbp
  8017b6:	48 83 ec 28          	sub    $0x28,%rsp
  8017ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017be:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cd:	48 01 d0             	add    %rdx,%rax
  8017d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017d4:	eb 19                	jmp    8017ef <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017da:	0f b6 00             	movzbl (%rax),%eax
  8017dd:	0f b6 d0             	movzbl %al,%edx
  8017e0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017e3:	0f b6 c0             	movzbl %al,%eax
  8017e6:	39 c2                	cmp    %eax,%edx
  8017e8:	74 11                	je     8017fb <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017ea:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8017f7:	72 dd                	jb     8017d6 <memfind+0x24>
  8017f9:	eb 01                	jmp    8017fc <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8017fb:	90                   	nop
	return (void *) s;
  8017fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801800:	c9                   	leaveq 
  801801:	c3                   	retq   

0000000000801802 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801802:	55                   	push   %rbp
  801803:	48 89 e5             	mov    %rsp,%rbp
  801806:	48 83 ec 38          	sub    $0x38,%rsp
  80180a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80180e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801812:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801815:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80181c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801823:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801824:	eb 05                	jmp    80182b <strtol+0x29>
		s++;
  801826:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80182b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182f:	0f b6 00             	movzbl (%rax),%eax
  801832:	3c 20                	cmp    $0x20,%al
  801834:	74 f0                	je     801826 <strtol+0x24>
  801836:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183a:	0f b6 00             	movzbl (%rax),%eax
  80183d:	3c 09                	cmp    $0x9,%al
  80183f:	74 e5                	je     801826 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801841:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801845:	0f b6 00             	movzbl (%rax),%eax
  801848:	3c 2b                	cmp    $0x2b,%al
  80184a:	75 07                	jne    801853 <strtol+0x51>
		s++;
  80184c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801851:	eb 17                	jmp    80186a <strtol+0x68>
	else if (*s == '-')
  801853:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801857:	0f b6 00             	movzbl (%rax),%eax
  80185a:	3c 2d                	cmp    $0x2d,%al
  80185c:	75 0c                	jne    80186a <strtol+0x68>
		s++, neg = 1;
  80185e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801863:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80186a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80186e:	74 06                	je     801876 <strtol+0x74>
  801870:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801874:	75 28                	jne    80189e <strtol+0x9c>
  801876:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187a:	0f b6 00             	movzbl (%rax),%eax
  80187d:	3c 30                	cmp    $0x30,%al
  80187f:	75 1d                	jne    80189e <strtol+0x9c>
  801881:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801885:	48 83 c0 01          	add    $0x1,%rax
  801889:	0f b6 00             	movzbl (%rax),%eax
  80188c:	3c 78                	cmp    $0x78,%al
  80188e:	75 0e                	jne    80189e <strtol+0x9c>
		s += 2, base = 16;
  801890:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801895:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80189c:	eb 2c                	jmp    8018ca <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80189e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018a2:	75 19                	jne    8018bd <strtol+0xbb>
  8018a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a8:	0f b6 00             	movzbl (%rax),%eax
  8018ab:	3c 30                	cmp    $0x30,%al
  8018ad:	75 0e                	jne    8018bd <strtol+0xbb>
		s++, base = 8;
  8018af:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018b4:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018bb:	eb 0d                	jmp    8018ca <strtol+0xc8>
	else if (base == 0)
  8018bd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018c1:	75 07                	jne    8018ca <strtol+0xc8>
		base = 10;
  8018c3:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ce:	0f b6 00             	movzbl (%rax),%eax
  8018d1:	3c 2f                	cmp    $0x2f,%al
  8018d3:	7e 1d                	jle    8018f2 <strtol+0xf0>
  8018d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d9:	0f b6 00             	movzbl (%rax),%eax
  8018dc:	3c 39                	cmp    $0x39,%al
  8018de:	7f 12                	jg     8018f2 <strtol+0xf0>
			dig = *s - '0';
  8018e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e4:	0f b6 00             	movzbl (%rax),%eax
  8018e7:	0f be c0             	movsbl %al,%eax
  8018ea:	83 e8 30             	sub    $0x30,%eax
  8018ed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018f0:	eb 4e                	jmp    801940 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8018f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f6:	0f b6 00             	movzbl (%rax),%eax
  8018f9:	3c 60                	cmp    $0x60,%al
  8018fb:	7e 1d                	jle    80191a <strtol+0x118>
  8018fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801901:	0f b6 00             	movzbl (%rax),%eax
  801904:	3c 7a                	cmp    $0x7a,%al
  801906:	7f 12                	jg     80191a <strtol+0x118>
			dig = *s - 'a' + 10;
  801908:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190c:	0f b6 00             	movzbl (%rax),%eax
  80190f:	0f be c0             	movsbl %al,%eax
  801912:	83 e8 57             	sub    $0x57,%eax
  801915:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801918:	eb 26                	jmp    801940 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80191a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191e:	0f b6 00             	movzbl (%rax),%eax
  801921:	3c 40                	cmp    $0x40,%al
  801923:	7e 47                	jle    80196c <strtol+0x16a>
  801925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801929:	0f b6 00             	movzbl (%rax),%eax
  80192c:	3c 5a                	cmp    $0x5a,%al
  80192e:	7f 3c                	jg     80196c <strtol+0x16a>
			dig = *s - 'A' + 10;
  801930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801934:	0f b6 00             	movzbl (%rax),%eax
  801937:	0f be c0             	movsbl %al,%eax
  80193a:	83 e8 37             	sub    $0x37,%eax
  80193d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801940:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801943:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801946:	7d 23                	jge    80196b <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801948:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80194d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801950:	48 98                	cltq   
  801952:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801957:	48 89 c2             	mov    %rax,%rdx
  80195a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80195d:	48 98                	cltq   
  80195f:	48 01 d0             	add    %rdx,%rax
  801962:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801966:	e9 5f ff ff ff       	jmpq   8018ca <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80196b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80196c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801971:	74 0b                	je     80197e <strtol+0x17c>
		*endptr = (char *) s;
  801973:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801977:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80197b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80197e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801982:	74 09                	je     80198d <strtol+0x18b>
  801984:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801988:	48 f7 d8             	neg    %rax
  80198b:	eb 04                	jmp    801991 <strtol+0x18f>
  80198d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801991:	c9                   	leaveq 
  801992:	c3                   	retq   

0000000000801993 <strstr>:

char * strstr(const char *in, const char *str)
{
  801993:	55                   	push   %rbp
  801994:	48 89 e5             	mov    %rsp,%rbp
  801997:	48 83 ec 30          	sub    $0x30,%rsp
  80199b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80199f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019ab:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019af:	0f b6 00             	movzbl (%rax),%eax
  8019b2:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019b5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019b9:	75 06                	jne    8019c1 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019bf:	eb 6b                	jmp    801a2c <strstr+0x99>

	len = strlen(str);
  8019c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019c5:	48 89 c7             	mov    %rax,%rdi
  8019c8:	48 b8 62 12 80 00 00 	movabs $0x801262,%rax
  8019cf:	00 00 00 
  8019d2:	ff d0                	callq  *%rax
  8019d4:	48 98                	cltq   
  8019d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019de:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019e6:	0f b6 00             	movzbl (%rax),%eax
  8019e9:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8019ec:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019f0:	75 07                	jne    8019f9 <strstr+0x66>
				return (char *) 0;
  8019f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f7:	eb 33                	jmp    801a2c <strstr+0x99>
		} while (sc != c);
  8019f9:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8019fd:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a00:	75 d8                	jne    8019da <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a02:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a06:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0e:	48 89 ce             	mov    %rcx,%rsi
  801a11:	48 89 c7             	mov    %rax,%rdi
  801a14:	48 b8 83 14 80 00 00 	movabs $0x801483,%rax
  801a1b:	00 00 00 
  801a1e:	ff d0                	callq  *%rax
  801a20:	85 c0                	test   %eax,%eax
  801a22:	75 b6                	jne    8019da <strstr+0x47>

	return (char *) (in - 1);
  801a24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a28:	48 83 e8 01          	sub    $0x1,%rax
}
  801a2c:	c9                   	leaveq 
  801a2d:	c3                   	retq   
