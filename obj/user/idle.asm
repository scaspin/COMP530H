
obj/user/idle:     file format elf64-x86-64


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
  80003c:	e8 36 00 00 00       	callq  800077 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	binaryname = "idle";
  800052:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800059:	00 00 00 
  80005c:	48 ba 60 1a 80 00 00 	movabs $0x801a60,%rdx
  800063:	00 00 00 
  800066:	48 89 10             	mov    %rdx,(%rax)
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800069:	48 b8 b4 02 80 00 00 	movabs $0x8002b4,%rax
  800070:	00 00 00 
  800073:	ff d0                	callq  *%rax
	}
  800075:	eb f2                	jmp    800069 <umain+0x26>

0000000000800077 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800077:	55                   	push   %rbp
  800078:	48 89 e5             	mov    %rsp,%rbp
  80007b:	48 83 ec 10          	sub    $0x10,%rsp
  80007f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800082:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  800086:	48 b8 78 02 80 00 00 	movabs $0x800278,%rax
  80008d:	00 00 00 
  800090:	ff d0                	callq  *%rax
  800092:	25 ff 03 00 00       	and    $0x3ff,%eax
  800097:	48 63 d0             	movslq %eax,%rdx
  80009a:	48 89 d0             	mov    %rdx,%rax
  80009d:	48 c1 e0 03          	shl    $0x3,%rax
  8000a1:	48 01 d0             	add    %rdx,%rax
  8000a4:	48 c1 e0 05          	shl    $0x5,%rax
  8000a8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000af:	00 00 00 
  8000b2:	48 01 c2             	add    %rax,%rdx
  8000b5:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000bc:	00 00 00 
  8000bf:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c6:	7e 14                	jle    8000dc <libmain+0x65>
		binaryname = argv[0];
  8000c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000cc:	48 8b 10             	mov    (%rax),%rdx
  8000cf:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000d6:	00 00 00 
  8000d9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000e3:	48 89 d6             	mov    %rdx,%rsi
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ef:	00 00 00 
  8000f2:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000f4:	48 b8 03 01 80 00 00 	movabs $0x800103,%rax
  8000fb:	00 00 00 
  8000fe:	ff d0                	callq  *%rax
}
  800100:	90                   	nop
  800101:	c9                   	leaveq 
  800102:	c3                   	retq   

0000000000800103 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800103:	55                   	push   %rbp
  800104:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800107:	bf 00 00 00 00       	mov    $0x0,%edi
  80010c:	48 b8 32 02 80 00 00 	movabs $0x800232,%rax
  800113:	00 00 00 
  800116:	ff d0                	callq  *%rax
}
  800118:	90                   	nop
  800119:	5d                   	pop    %rbp
  80011a:	c3                   	retq   

000000000080011b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80011b:	55                   	push   %rbp
  80011c:	48 89 e5             	mov    %rsp,%rbp
  80011f:	53                   	push   %rbx
  800120:	48 83 ec 48          	sub    $0x48,%rsp
  800124:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800127:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80012a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80012e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800132:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800136:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80013a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80013d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800141:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800145:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800149:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80014d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800151:	4c 89 c3             	mov    %r8,%rbx
  800154:	cd 30                	int    $0x30
  800156:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80015a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80015e:	74 3e                	je     80019e <syscall+0x83>
  800160:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800165:	7e 37                	jle    80019e <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800167:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80016b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80016e:	49 89 d0             	mov    %rdx,%r8
  800171:	89 c1                	mov    %eax,%ecx
  800173:	48 ba 6f 1a 80 00 00 	movabs $0x801a6f,%rdx
  80017a:	00 00 00 
  80017d:	be 23 00 00 00       	mov    $0x23,%esi
  800182:	48 bf 8c 1a 80 00 00 	movabs $0x801a8c,%rdi
  800189:	00 00 00 
  80018c:	b8 00 00 00 00       	mov    $0x0,%eax
  800191:	49 b9 25 05 80 00 00 	movabs $0x800525,%r9
  800198:	00 00 00 
  80019b:	41 ff d1             	callq  *%r9

	return ret;
  80019e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001a2:	48 83 c4 48          	add    $0x48,%rsp
  8001a6:	5b                   	pop    %rbx
  8001a7:	5d                   	pop    %rbp
  8001a8:	c3                   	retq   

00000000008001a9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001a9:	55                   	push   %rbp
  8001aa:	48 89 e5             	mov    %rsp,%rbp
  8001ad:	48 83 ec 10          	sub    $0x10,%rsp
  8001b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c1:	48 83 ec 08          	sub    $0x8,%rsp
  8001c5:	6a 00                	pushq  $0x0
  8001c7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001cd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001d3:	48 89 d1             	mov    %rdx,%rcx
  8001d6:	48 89 c2             	mov    %rax,%rdx
  8001d9:	be 00 00 00 00       	mov    $0x0,%esi
  8001de:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e3:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  8001ea:	00 00 00 
  8001ed:	ff d0                	callq  *%rax
  8001ef:	48 83 c4 10          	add    $0x10,%rsp
}
  8001f3:	90                   	nop
  8001f4:	c9                   	leaveq 
  8001f5:	c3                   	retq   

00000000008001f6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001f6:	55                   	push   %rbp
  8001f7:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001fa:	48 83 ec 08          	sub    $0x8,%rsp
  8001fe:	6a 00                	pushq  $0x0
  800200:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800206:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80020c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800211:	ba 00 00 00 00       	mov    $0x0,%edx
  800216:	be 00 00 00 00       	mov    $0x0,%esi
  80021b:	bf 01 00 00 00       	mov    $0x1,%edi
  800220:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  800227:	00 00 00 
  80022a:	ff d0                	callq  *%rax
  80022c:	48 83 c4 10          	add    $0x10,%rsp
}
  800230:	c9                   	leaveq 
  800231:	c3                   	retq   

0000000000800232 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800232:	55                   	push   %rbp
  800233:	48 89 e5             	mov    %rsp,%rbp
  800236:	48 83 ec 10          	sub    $0x10,%rsp
  80023a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80023d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800240:	48 98                	cltq   
  800242:	48 83 ec 08          	sub    $0x8,%rsp
  800246:	6a 00                	pushq  $0x0
  800248:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80024e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800254:	b9 00 00 00 00       	mov    $0x0,%ecx
  800259:	48 89 c2             	mov    %rax,%rdx
  80025c:	be 01 00 00 00       	mov    $0x1,%esi
  800261:	bf 03 00 00 00       	mov    $0x3,%edi
  800266:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  80026d:	00 00 00 
  800270:	ff d0                	callq  *%rax
  800272:	48 83 c4 10          	add    $0x10,%rsp
}
  800276:	c9                   	leaveq 
  800277:	c3                   	retq   

0000000000800278 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800278:	55                   	push   %rbp
  800279:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80027c:	48 83 ec 08          	sub    $0x8,%rsp
  800280:	6a 00                	pushq  $0x0
  800282:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800288:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80028e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800293:	ba 00 00 00 00       	mov    $0x0,%edx
  800298:	be 00 00 00 00       	mov    $0x0,%esi
  80029d:	bf 02 00 00 00       	mov    $0x2,%edi
  8002a2:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  8002a9:	00 00 00 
  8002ac:	ff d0                	callq  *%rax
  8002ae:	48 83 c4 10          	add    $0x10,%rsp
}
  8002b2:	c9                   	leaveq 
  8002b3:	c3                   	retq   

00000000008002b4 <sys_yield>:

void
sys_yield(void)
{
  8002b4:	55                   	push   %rbp
  8002b5:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002b8:	48 83 ec 08          	sub    $0x8,%rsp
  8002bc:	6a 00                	pushq  $0x0
  8002be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d4:	be 00 00 00 00       	mov    $0x0,%esi
  8002d9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002de:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  8002e5:	00 00 00 
  8002e8:	ff d0                	callq  *%rax
  8002ea:	48 83 c4 10          	add    $0x10,%rsp
}
  8002ee:	90                   	nop
  8002ef:	c9                   	leaveq 
  8002f0:	c3                   	retq   

00000000008002f1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002f1:	55                   	push   %rbp
  8002f2:	48 89 e5             	mov    %rsp,%rbp
  8002f5:	48 83 ec 10          	sub    $0x10,%rsp
  8002f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800300:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800303:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800306:	48 63 c8             	movslq %eax,%rcx
  800309:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80030d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800310:	48 98                	cltq   
  800312:	48 83 ec 08          	sub    $0x8,%rsp
  800316:	6a 00                	pushq  $0x0
  800318:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80031e:	49 89 c8             	mov    %rcx,%r8
  800321:	48 89 d1             	mov    %rdx,%rcx
  800324:	48 89 c2             	mov    %rax,%rdx
  800327:	be 01 00 00 00       	mov    $0x1,%esi
  80032c:	bf 04 00 00 00       	mov    $0x4,%edi
  800331:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  800338:	00 00 00 
  80033b:	ff d0                	callq  *%rax
  80033d:	48 83 c4 10          	add    $0x10,%rsp
}
  800341:	c9                   	leaveq 
  800342:	c3                   	retq   

0000000000800343 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800343:	55                   	push   %rbp
  800344:	48 89 e5             	mov    %rsp,%rbp
  800347:	48 83 ec 20          	sub    $0x20,%rsp
  80034b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80034e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800352:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800355:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800359:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80035d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800360:	48 63 c8             	movslq %eax,%rcx
  800363:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800367:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80036a:	48 63 f0             	movslq %eax,%rsi
  80036d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800371:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800374:	48 98                	cltq   
  800376:	48 83 ec 08          	sub    $0x8,%rsp
  80037a:	51                   	push   %rcx
  80037b:	49 89 f9             	mov    %rdi,%r9
  80037e:	49 89 f0             	mov    %rsi,%r8
  800381:	48 89 d1             	mov    %rdx,%rcx
  800384:	48 89 c2             	mov    %rax,%rdx
  800387:	be 01 00 00 00       	mov    $0x1,%esi
  80038c:	bf 05 00 00 00       	mov    $0x5,%edi
  800391:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  800398:	00 00 00 
  80039b:	ff d0                	callq  *%rax
  80039d:	48 83 c4 10          	add    $0x10,%rsp
}
  8003a1:	c9                   	leaveq 
  8003a2:	c3                   	retq   

00000000008003a3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003a3:	55                   	push   %rbp
  8003a4:	48 89 e5             	mov    %rsp,%rbp
  8003a7:	48 83 ec 10          	sub    $0x10,%rsp
  8003ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003b9:	48 98                	cltq   
  8003bb:	48 83 ec 08          	sub    $0x8,%rsp
  8003bf:	6a 00                	pushq  $0x0
  8003c1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003cd:	48 89 d1             	mov    %rdx,%rcx
  8003d0:	48 89 c2             	mov    %rax,%rdx
  8003d3:	be 01 00 00 00       	mov    $0x1,%esi
  8003d8:	bf 06 00 00 00       	mov    $0x6,%edi
  8003dd:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  8003e4:	00 00 00 
  8003e7:	ff d0                	callq  *%rax
  8003e9:	48 83 c4 10          	add    $0x10,%rsp
}
  8003ed:	c9                   	leaveq 
  8003ee:	c3                   	retq   

00000000008003ef <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003ef:	55                   	push   %rbp
  8003f0:	48 89 e5             	mov    %rsp,%rbp
  8003f3:	48 83 ec 10          	sub    $0x10,%rsp
  8003f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003fa:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800400:	48 63 d0             	movslq %eax,%rdx
  800403:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800406:	48 98                	cltq   
  800408:	48 83 ec 08          	sub    $0x8,%rsp
  80040c:	6a 00                	pushq  $0x0
  80040e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800414:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80041a:	48 89 d1             	mov    %rdx,%rcx
  80041d:	48 89 c2             	mov    %rax,%rdx
  800420:	be 01 00 00 00       	mov    $0x1,%esi
  800425:	bf 08 00 00 00       	mov    $0x8,%edi
  80042a:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  800431:	00 00 00 
  800434:	ff d0                	callq  *%rax
  800436:	48 83 c4 10          	add    $0x10,%rsp
}
  80043a:	c9                   	leaveq 
  80043b:	c3                   	retq   

000000000080043c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80043c:	55                   	push   %rbp
  80043d:	48 89 e5             	mov    %rsp,%rbp
  800440:	48 83 ec 10          	sub    $0x10,%rsp
  800444:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800447:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80044b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80044f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800452:	48 98                	cltq   
  800454:	48 83 ec 08          	sub    $0x8,%rsp
  800458:	6a 00                	pushq  $0x0
  80045a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800460:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800466:	48 89 d1             	mov    %rdx,%rcx
  800469:	48 89 c2             	mov    %rax,%rdx
  80046c:	be 01 00 00 00       	mov    $0x1,%esi
  800471:	bf 09 00 00 00       	mov    $0x9,%edi
  800476:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  80047d:	00 00 00 
  800480:	ff d0                	callq  *%rax
  800482:	48 83 c4 10          	add    $0x10,%rsp
}
  800486:	c9                   	leaveq 
  800487:	c3                   	retq   

0000000000800488 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800488:	55                   	push   %rbp
  800489:	48 89 e5             	mov    %rsp,%rbp
  80048c:	48 83 ec 20          	sub    $0x20,%rsp
  800490:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800493:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800497:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80049b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80049e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004a1:	48 63 f0             	movslq %eax,%rsi
  8004a4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004ab:	48 98                	cltq   
  8004ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b1:	48 83 ec 08          	sub    $0x8,%rsp
  8004b5:	6a 00                	pushq  $0x0
  8004b7:	49 89 f1             	mov    %rsi,%r9
  8004ba:	49 89 c8             	mov    %rcx,%r8
  8004bd:	48 89 d1             	mov    %rdx,%rcx
  8004c0:	48 89 c2             	mov    %rax,%rdx
  8004c3:	be 00 00 00 00       	mov    $0x0,%esi
  8004c8:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004cd:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  8004d4:	00 00 00 
  8004d7:	ff d0                	callq  *%rax
  8004d9:	48 83 c4 10          	add    $0x10,%rsp
}
  8004dd:	c9                   	leaveq 
  8004de:	c3                   	retq   

00000000008004df <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004df:	55                   	push   %rbp
  8004e0:	48 89 e5             	mov    %rsp,%rbp
  8004e3:	48 83 ec 10          	sub    $0x10,%rsp
  8004e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ef:	48 83 ec 08          	sub    $0x8,%rsp
  8004f3:	6a 00                	pushq  $0x0
  8004f5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004fb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800501:	b9 00 00 00 00       	mov    $0x0,%ecx
  800506:	48 89 c2             	mov    %rax,%rdx
  800509:	be 01 00 00 00       	mov    $0x1,%esi
  80050e:	bf 0c 00 00 00       	mov    $0xc,%edi
  800513:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  80051a:	00 00 00 
  80051d:	ff d0                	callq  *%rax
  80051f:	48 83 c4 10          	add    $0x10,%rsp
}
  800523:	c9                   	leaveq 
  800524:	c3                   	retq   

0000000000800525 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800525:	55                   	push   %rbp
  800526:	48 89 e5             	mov    %rsp,%rbp
  800529:	53                   	push   %rbx
  80052a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800531:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800538:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80053e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800545:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80054c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800553:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80055a:	84 c0                	test   %al,%al
  80055c:	74 23                	je     800581 <_panic+0x5c>
  80055e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800565:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800569:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80056d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800571:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800575:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800579:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80057d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800581:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800588:	00 00 00 
  80058b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800592:	00 00 00 
  800595:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800599:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8005a0:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8005a7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005ae:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8005b5:	00 00 00 
  8005b8:	48 8b 18             	mov    (%rax),%rbx
  8005bb:	48 b8 78 02 80 00 00 	movabs $0x800278,%rax
  8005c2:	00 00 00 
  8005c5:	ff d0                	callq  *%rax
  8005c7:	89 c6                	mov    %eax,%esi
  8005c9:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8005cf:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8005d6:	41 89 d0             	mov    %edx,%r8d
  8005d9:	48 89 c1             	mov    %rax,%rcx
  8005dc:	48 89 da             	mov    %rbx,%rdx
  8005df:	48 bf a0 1a 80 00 00 	movabs $0x801aa0,%rdi
  8005e6:	00 00 00 
  8005e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ee:	49 b9 5f 07 80 00 00 	movabs $0x80075f,%r9
  8005f5:	00 00 00 
  8005f8:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005fb:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800602:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800609:	48 89 d6             	mov    %rdx,%rsi
  80060c:	48 89 c7             	mov    %rax,%rdi
  80060f:	48 b8 b3 06 80 00 00 	movabs $0x8006b3,%rax
  800616:	00 00 00 
  800619:	ff d0                	callq  *%rax
	cprintf("\n");
  80061b:	48 bf c3 1a 80 00 00 	movabs $0x801ac3,%rdi
  800622:	00 00 00 
  800625:	b8 00 00 00 00       	mov    $0x0,%eax
  80062a:	48 ba 5f 07 80 00 00 	movabs $0x80075f,%rdx
  800631:	00 00 00 
  800634:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800636:	cc                   	int3   
  800637:	eb fd                	jmp    800636 <_panic+0x111>

0000000000800639 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800639:	55                   	push   %rbp
  80063a:	48 89 e5             	mov    %rsp,%rbp
  80063d:	48 83 ec 10          	sub    $0x10,%rsp
  800641:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800644:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800648:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80064c:	8b 00                	mov    (%rax),%eax
  80064e:	8d 48 01             	lea    0x1(%rax),%ecx
  800651:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800655:	89 0a                	mov    %ecx,(%rdx)
  800657:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80065a:	89 d1                	mov    %edx,%ecx
  80065c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800660:	48 98                	cltq   
  800662:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800666:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80066a:	8b 00                	mov    (%rax),%eax
  80066c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800671:	75 2c                	jne    80069f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800673:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800677:	8b 00                	mov    (%rax),%eax
  800679:	48 98                	cltq   
  80067b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80067f:	48 83 c2 08          	add    $0x8,%rdx
  800683:	48 89 c6             	mov    %rax,%rsi
  800686:	48 89 d7             	mov    %rdx,%rdi
  800689:	48 b8 a9 01 80 00 00 	movabs $0x8001a9,%rax
  800690:	00 00 00 
  800693:	ff d0                	callq  *%rax
        b->idx = 0;
  800695:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800699:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80069f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a3:	8b 40 04             	mov    0x4(%rax),%eax
  8006a6:	8d 50 01             	lea    0x1(%rax),%edx
  8006a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ad:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006b0:	90                   	nop
  8006b1:	c9                   	leaveq 
  8006b2:	c3                   	retq   

00000000008006b3 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8006b3:	55                   	push   %rbp
  8006b4:	48 89 e5             	mov    %rsp,%rbp
  8006b7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006be:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006c5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006cc:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006d3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006da:	48 8b 0a             	mov    (%rdx),%rcx
  8006dd:	48 89 08             	mov    %rcx,(%rax)
  8006e0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006e4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006ec:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006f0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006f7:	00 00 00 
    b.cnt = 0;
  8006fa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800701:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800704:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80070b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800712:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800719:	48 89 c6             	mov    %rax,%rsi
  80071c:	48 bf 39 06 80 00 00 	movabs $0x800639,%rdi
  800723:	00 00 00 
  800726:	48 b8 fd 0a 80 00 00 	movabs $0x800afd,%rax
  80072d:	00 00 00 
  800730:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800732:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800738:	48 98                	cltq   
  80073a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800741:	48 83 c2 08          	add    $0x8,%rdx
  800745:	48 89 c6             	mov    %rax,%rsi
  800748:	48 89 d7             	mov    %rdx,%rdi
  80074b:	48 b8 a9 01 80 00 00 	movabs $0x8001a9,%rax
  800752:	00 00 00 
  800755:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800757:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80075d:	c9                   	leaveq 
  80075e:	c3                   	retq   

000000000080075f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80075f:	55                   	push   %rbp
  800760:	48 89 e5             	mov    %rsp,%rbp
  800763:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80076a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800771:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800778:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80077f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800786:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80078d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800794:	84 c0                	test   %al,%al
  800796:	74 20                	je     8007b8 <cprintf+0x59>
  800798:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80079c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8007a0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8007a4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8007a8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8007ac:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007b0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007b4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007b8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007bf:	00 00 00 
  8007c2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007c9:	00 00 00 
  8007cc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007d0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007d7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007de:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007e5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007ec:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007f3:	48 8b 0a             	mov    (%rdx),%rcx
  8007f6:	48 89 08             	mov    %rcx,(%rax)
  8007f9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007fd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800801:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800805:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800809:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800810:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800817:	48 89 d6             	mov    %rdx,%rsi
  80081a:	48 89 c7             	mov    %rax,%rdi
  80081d:	48 b8 b3 06 80 00 00 	movabs $0x8006b3,%rax
  800824:	00 00 00 
  800827:	ff d0                	callq  *%rax
  800829:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80082f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800835:	c9                   	leaveq 
  800836:	c3                   	retq   

0000000000800837 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800837:	55                   	push   %rbp
  800838:	48 89 e5             	mov    %rsp,%rbp
  80083b:	48 83 ec 30          	sub    $0x30,%rsp
  80083f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800843:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800847:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80084b:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80084e:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800852:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800856:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800859:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80085d:	77 54                	ja     8008b3 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80085f:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800862:	8d 78 ff             	lea    -0x1(%rax),%edi
  800865:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800868:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086c:	ba 00 00 00 00       	mov    $0x0,%edx
  800871:	48 f7 f6             	div    %rsi
  800874:	49 89 c2             	mov    %rax,%r10
  800877:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80087a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80087d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800881:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800885:	41 89 c9             	mov    %ecx,%r9d
  800888:	41 89 f8             	mov    %edi,%r8d
  80088b:	89 d1                	mov    %edx,%ecx
  80088d:	4c 89 d2             	mov    %r10,%rdx
  800890:	48 89 c7             	mov    %rax,%rdi
  800893:	48 b8 37 08 80 00 00 	movabs $0x800837,%rax
  80089a:	00 00 00 
  80089d:	ff d0                	callq  *%rax
  80089f:	eb 1c                	jmp    8008bd <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008a1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8008a5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8008a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008ac:	48 89 ce             	mov    %rcx,%rsi
  8008af:	89 d7                	mov    %edx,%edi
  8008b1:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008b3:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8008b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8008bb:	7f e4                	jg     8008a1 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008bd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8008c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c9:	48 f7 f1             	div    %rcx
  8008cc:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  8008d3:	00 00 00 
  8008d6:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8008da:	0f be d0             	movsbl %al,%edx
  8008dd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8008e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008e5:	48 89 ce             	mov    %rcx,%rsi
  8008e8:	89 d7                	mov    %edx,%edi
  8008ea:	ff d0                	callq  *%rax
}
  8008ec:	90                   	nop
  8008ed:	c9                   	leaveq 
  8008ee:	c3                   	retq   

00000000008008ef <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ef:	55                   	push   %rbp
  8008f0:	48 89 e5             	mov    %rsp,%rbp
  8008f3:	48 83 ec 20          	sub    $0x20,%rsp
  8008f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008fb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008fe:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800902:	7e 4f                	jle    800953 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800904:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800908:	8b 00                	mov    (%rax),%eax
  80090a:	83 f8 30             	cmp    $0x30,%eax
  80090d:	73 24                	jae    800933 <getuint+0x44>
  80090f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800913:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091b:	8b 00                	mov    (%rax),%eax
  80091d:	89 c0                	mov    %eax,%eax
  80091f:	48 01 d0             	add    %rdx,%rax
  800922:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800926:	8b 12                	mov    (%rdx),%edx
  800928:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80092b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092f:	89 0a                	mov    %ecx,(%rdx)
  800931:	eb 14                	jmp    800947 <getuint+0x58>
  800933:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800937:	48 8b 40 08          	mov    0x8(%rax),%rax
  80093b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80093f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800943:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800947:	48 8b 00             	mov    (%rax),%rax
  80094a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80094e:	e9 9d 00 00 00       	jmpq   8009f0 <getuint+0x101>
	else if (lflag)
  800953:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800957:	74 4c                	je     8009a5 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800959:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095d:	8b 00                	mov    (%rax),%eax
  80095f:	83 f8 30             	cmp    $0x30,%eax
  800962:	73 24                	jae    800988 <getuint+0x99>
  800964:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800968:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80096c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800970:	8b 00                	mov    (%rax),%eax
  800972:	89 c0                	mov    %eax,%eax
  800974:	48 01 d0             	add    %rdx,%rax
  800977:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097b:	8b 12                	mov    (%rdx),%edx
  80097d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800980:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800984:	89 0a                	mov    %ecx,(%rdx)
  800986:	eb 14                	jmp    80099c <getuint+0xad>
  800988:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800990:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800994:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800998:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80099c:	48 8b 00             	mov    (%rax),%rax
  80099f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009a3:	eb 4b                	jmp    8009f0 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8009a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a9:	8b 00                	mov    (%rax),%eax
  8009ab:	83 f8 30             	cmp    $0x30,%eax
  8009ae:	73 24                	jae    8009d4 <getuint+0xe5>
  8009b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bc:	8b 00                	mov    (%rax),%eax
  8009be:	89 c0                	mov    %eax,%eax
  8009c0:	48 01 d0             	add    %rdx,%rax
  8009c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c7:	8b 12                	mov    (%rdx),%edx
  8009c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d0:	89 0a                	mov    %ecx,(%rdx)
  8009d2:	eb 14                	jmp    8009e8 <getuint+0xf9>
  8009d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009dc:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e8:	8b 00                	mov    (%rax),%eax
  8009ea:	89 c0                	mov    %eax,%eax
  8009ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009f4:	c9                   	leaveq 
  8009f5:	c3                   	retq   

00000000008009f6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009f6:	55                   	push   %rbp
  8009f7:	48 89 e5             	mov    %rsp,%rbp
  8009fa:	48 83 ec 20          	sub    $0x20,%rsp
  8009fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a02:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a05:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a09:	7e 4f                	jle    800a5a <getint+0x64>
		x=va_arg(*ap, long long);
  800a0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0f:	8b 00                	mov    (%rax),%eax
  800a11:	83 f8 30             	cmp    $0x30,%eax
  800a14:	73 24                	jae    800a3a <getint+0x44>
  800a16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a22:	8b 00                	mov    (%rax),%eax
  800a24:	89 c0                	mov    %eax,%eax
  800a26:	48 01 d0             	add    %rdx,%rax
  800a29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2d:	8b 12                	mov    (%rdx),%edx
  800a2f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a32:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a36:	89 0a                	mov    %ecx,(%rdx)
  800a38:	eb 14                	jmp    800a4e <getint+0x58>
  800a3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a42:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a46:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a4e:	48 8b 00             	mov    (%rax),%rax
  800a51:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a55:	e9 9d 00 00 00       	jmpq   800af7 <getint+0x101>
	else if (lflag)
  800a5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a5e:	74 4c                	je     800aac <getint+0xb6>
		x=va_arg(*ap, long);
  800a60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a64:	8b 00                	mov    (%rax),%eax
  800a66:	83 f8 30             	cmp    $0x30,%eax
  800a69:	73 24                	jae    800a8f <getint+0x99>
  800a6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a77:	8b 00                	mov    (%rax),%eax
  800a79:	89 c0                	mov    %eax,%eax
  800a7b:	48 01 d0             	add    %rdx,%rax
  800a7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a82:	8b 12                	mov    (%rdx),%edx
  800a84:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a87:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8b:	89 0a                	mov    %ecx,(%rdx)
  800a8d:	eb 14                	jmp    800aa3 <getint+0xad>
  800a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a93:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a97:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a9b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aa3:	48 8b 00             	mov    (%rax),%rax
  800aa6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aaa:	eb 4b                	jmp    800af7 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800aac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab0:	8b 00                	mov    (%rax),%eax
  800ab2:	83 f8 30             	cmp    $0x30,%eax
  800ab5:	73 24                	jae    800adb <getint+0xe5>
  800ab7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800abf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac3:	8b 00                	mov    (%rax),%eax
  800ac5:	89 c0                	mov    %eax,%eax
  800ac7:	48 01 d0             	add    %rdx,%rax
  800aca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ace:	8b 12                	mov    (%rdx),%edx
  800ad0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ad3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad7:	89 0a                	mov    %ecx,(%rdx)
  800ad9:	eb 14                	jmp    800aef <getint+0xf9>
  800adb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adf:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ae3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ae7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aeb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aef:	8b 00                	mov    (%rax),%eax
  800af1:	48 98                	cltq   
  800af3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800af7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800afb:	c9                   	leaveq 
  800afc:	c3                   	retq   

0000000000800afd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800afd:	55                   	push   %rbp
  800afe:	48 89 e5             	mov    %rsp,%rbp
  800b01:	41 54                	push   %r12
  800b03:	53                   	push   %rbx
  800b04:	48 83 ec 60          	sub    $0x60,%rsp
  800b08:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b0c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b10:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b14:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b18:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b1c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b20:	48 8b 0a             	mov    (%rdx),%rcx
  800b23:	48 89 08             	mov    %rcx,(%rax)
  800b26:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b2a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b2e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b32:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b36:	eb 17                	jmp    800b4f <vprintfmt+0x52>
			if (ch == '\0')
  800b38:	85 db                	test   %ebx,%ebx
  800b3a:	0f 84 b9 04 00 00    	je     800ff9 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800b40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b48:	48 89 d6             	mov    %rdx,%rsi
  800b4b:	89 df                	mov    %ebx,%edi
  800b4d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b4f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b53:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b57:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b5b:	0f b6 00             	movzbl (%rax),%eax
  800b5e:	0f b6 d8             	movzbl %al,%ebx
  800b61:	83 fb 25             	cmp    $0x25,%ebx
  800b64:	75 d2                	jne    800b38 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b66:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b6a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b71:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b78:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b7f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b86:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b8a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b8e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b92:	0f b6 00             	movzbl (%rax),%eax
  800b95:	0f b6 d8             	movzbl %al,%ebx
  800b98:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b9b:	83 f8 55             	cmp    $0x55,%eax
  800b9e:	0f 87 22 04 00 00    	ja     800fc6 <vprintfmt+0x4c9>
  800ba4:	89 c0                	mov    %eax,%eax
  800ba6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bad:	00 
  800bae:	48 b8 58 1c 80 00 00 	movabs $0x801c58,%rax
  800bb5:	00 00 00 
  800bb8:	48 01 d0             	add    %rdx,%rax
  800bbb:	48 8b 00             	mov    (%rax),%rax
  800bbe:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bc0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bc4:	eb c0                	jmp    800b86 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bc6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bca:	eb ba                	jmp    800b86 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bcc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bd3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bd6:	89 d0                	mov    %edx,%eax
  800bd8:	c1 e0 02             	shl    $0x2,%eax
  800bdb:	01 d0                	add    %edx,%eax
  800bdd:	01 c0                	add    %eax,%eax
  800bdf:	01 d8                	add    %ebx,%eax
  800be1:	83 e8 30             	sub    $0x30,%eax
  800be4:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800be7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800beb:	0f b6 00             	movzbl (%rax),%eax
  800bee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bf1:	83 fb 2f             	cmp    $0x2f,%ebx
  800bf4:	7e 60                	jle    800c56 <vprintfmt+0x159>
  800bf6:	83 fb 39             	cmp    $0x39,%ebx
  800bf9:	7f 5b                	jg     800c56 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bfb:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c00:	eb d1                	jmp    800bd3 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800c02:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c05:	83 f8 30             	cmp    $0x30,%eax
  800c08:	73 17                	jae    800c21 <vprintfmt+0x124>
  800c0a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c0e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c11:	89 d2                	mov    %edx,%edx
  800c13:	48 01 d0             	add    %rdx,%rax
  800c16:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c19:	83 c2 08             	add    $0x8,%edx
  800c1c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c1f:	eb 0c                	jmp    800c2d <vprintfmt+0x130>
  800c21:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c25:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c29:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c2d:	8b 00                	mov    (%rax),%eax
  800c2f:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c32:	eb 23                	jmp    800c57 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800c34:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c38:	0f 89 48 ff ff ff    	jns    800b86 <vprintfmt+0x89>
				width = 0;
  800c3e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c45:	e9 3c ff ff ff       	jmpq   800b86 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c4a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c51:	e9 30 ff ff ff       	jmpq   800b86 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c56:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c57:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c5b:	0f 89 25 ff ff ff    	jns    800b86 <vprintfmt+0x89>
				width = precision, precision = -1;
  800c61:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c64:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c67:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c6e:	e9 13 ff ff ff       	jmpq   800b86 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c73:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c77:	e9 0a ff ff ff       	jmpq   800b86 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7f:	83 f8 30             	cmp    $0x30,%eax
  800c82:	73 17                	jae    800c9b <vprintfmt+0x19e>
  800c84:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c88:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8b:	89 d2                	mov    %edx,%edx
  800c8d:	48 01 d0             	add    %rdx,%rax
  800c90:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c93:	83 c2 08             	add    $0x8,%edx
  800c96:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c99:	eb 0c                	jmp    800ca7 <vprintfmt+0x1aa>
  800c9b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c9f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ca3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ca7:	8b 10                	mov    (%rax),%edx
  800ca9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb1:	48 89 ce             	mov    %rcx,%rsi
  800cb4:	89 d7                	mov    %edx,%edi
  800cb6:	ff d0                	callq  *%rax
			break;
  800cb8:	e9 37 03 00 00       	jmpq   800ff4 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc0:	83 f8 30             	cmp    $0x30,%eax
  800cc3:	73 17                	jae    800cdc <vprintfmt+0x1df>
  800cc5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cc9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ccc:	89 d2                	mov    %edx,%edx
  800cce:	48 01 d0             	add    %rdx,%rax
  800cd1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cd4:	83 c2 08             	add    $0x8,%edx
  800cd7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cda:	eb 0c                	jmp    800ce8 <vprintfmt+0x1eb>
  800cdc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ce0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ce4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ce8:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cea:	85 db                	test   %ebx,%ebx
  800cec:	79 02                	jns    800cf0 <vprintfmt+0x1f3>
				err = -err;
  800cee:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cf0:	83 fb 15             	cmp    $0x15,%ebx
  800cf3:	7f 16                	jg     800d0b <vprintfmt+0x20e>
  800cf5:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  800cfc:	00 00 00 
  800cff:	48 63 d3             	movslq %ebx,%rdx
  800d02:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d06:	4d 85 e4             	test   %r12,%r12
  800d09:	75 2e                	jne    800d39 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800d0b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d13:	89 d9                	mov    %ebx,%ecx
  800d15:	48 ba 41 1c 80 00 00 	movabs $0x801c41,%rdx
  800d1c:	00 00 00 
  800d1f:	48 89 c7             	mov    %rax,%rdi
  800d22:	b8 00 00 00 00       	mov    $0x0,%eax
  800d27:	49 b8 03 10 80 00 00 	movabs $0x801003,%r8
  800d2e:	00 00 00 
  800d31:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d34:	e9 bb 02 00 00       	jmpq   800ff4 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d39:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d41:	4c 89 e1             	mov    %r12,%rcx
  800d44:	48 ba 4a 1c 80 00 00 	movabs $0x801c4a,%rdx
  800d4b:	00 00 00 
  800d4e:	48 89 c7             	mov    %rax,%rdi
  800d51:	b8 00 00 00 00       	mov    $0x0,%eax
  800d56:	49 b8 03 10 80 00 00 	movabs $0x801003,%r8
  800d5d:	00 00 00 
  800d60:	41 ff d0             	callq  *%r8
			break;
  800d63:	e9 8c 02 00 00       	jmpq   800ff4 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d68:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d6b:	83 f8 30             	cmp    $0x30,%eax
  800d6e:	73 17                	jae    800d87 <vprintfmt+0x28a>
  800d70:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d74:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d77:	89 d2                	mov    %edx,%edx
  800d79:	48 01 d0             	add    %rdx,%rax
  800d7c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d7f:	83 c2 08             	add    $0x8,%edx
  800d82:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d85:	eb 0c                	jmp    800d93 <vprintfmt+0x296>
  800d87:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d8b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d8f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d93:	4c 8b 20             	mov    (%rax),%r12
  800d96:	4d 85 e4             	test   %r12,%r12
  800d99:	75 0a                	jne    800da5 <vprintfmt+0x2a8>
				p = "(null)";
  800d9b:	49 bc 4d 1c 80 00 00 	movabs $0x801c4d,%r12
  800da2:	00 00 00 
			if (width > 0 && padc != '-')
  800da5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800da9:	7e 78                	jle    800e23 <vprintfmt+0x326>
  800dab:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800daf:	74 72                	je     800e23 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800db1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800db4:	48 98                	cltq   
  800db6:	48 89 c6             	mov    %rax,%rsi
  800db9:	4c 89 e7             	mov    %r12,%rdi
  800dbc:	48 b8 b1 12 80 00 00 	movabs $0x8012b1,%rax
  800dc3:	00 00 00 
  800dc6:	ff d0                	callq  *%rax
  800dc8:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dcb:	eb 17                	jmp    800de4 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800dcd:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800dd1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dd5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd9:	48 89 ce             	mov    %rcx,%rsi
  800ddc:	89 d7                	mov    %edx,%edi
  800dde:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800de0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800de4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800de8:	7f e3                	jg     800dcd <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dea:	eb 37                	jmp    800e23 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800dec:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800df0:	74 1e                	je     800e10 <vprintfmt+0x313>
  800df2:	83 fb 1f             	cmp    $0x1f,%ebx
  800df5:	7e 05                	jle    800dfc <vprintfmt+0x2ff>
  800df7:	83 fb 7e             	cmp    $0x7e,%ebx
  800dfa:	7e 14                	jle    800e10 <vprintfmt+0x313>
					putch('?', putdat);
  800dfc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e04:	48 89 d6             	mov    %rdx,%rsi
  800e07:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e0c:	ff d0                	callq  *%rax
  800e0e:	eb 0f                	jmp    800e1f <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800e10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e18:	48 89 d6             	mov    %rdx,%rsi
  800e1b:	89 df                	mov    %ebx,%edi
  800e1d:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e1f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e23:	4c 89 e0             	mov    %r12,%rax
  800e26:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e2a:	0f b6 00             	movzbl (%rax),%eax
  800e2d:	0f be d8             	movsbl %al,%ebx
  800e30:	85 db                	test   %ebx,%ebx
  800e32:	74 28                	je     800e5c <vprintfmt+0x35f>
  800e34:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e38:	78 b2                	js     800dec <vprintfmt+0x2ef>
  800e3a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e3e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e42:	79 a8                	jns    800dec <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e44:	eb 16                	jmp    800e5c <vprintfmt+0x35f>
				putch(' ', putdat);
  800e46:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e4a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e4e:	48 89 d6             	mov    %rdx,%rsi
  800e51:	bf 20 00 00 00       	mov    $0x20,%edi
  800e56:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e58:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e5c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e60:	7f e4                	jg     800e46 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800e62:	e9 8d 01 00 00       	jmpq   800ff4 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e67:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e6b:	be 03 00 00 00       	mov    $0x3,%esi
  800e70:	48 89 c7             	mov    %rax,%rdi
  800e73:	48 b8 f6 09 80 00 00 	movabs $0x8009f6,%rax
  800e7a:	00 00 00 
  800e7d:	ff d0                	callq  *%rax
  800e7f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e87:	48 85 c0             	test   %rax,%rax
  800e8a:	79 1d                	jns    800ea9 <vprintfmt+0x3ac>
				putch('-', putdat);
  800e8c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e94:	48 89 d6             	mov    %rdx,%rsi
  800e97:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e9c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea2:	48 f7 d8             	neg    %rax
  800ea5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ea9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800eb0:	e9 d2 00 00 00       	jmpq   800f87 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800eb5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eb9:	be 03 00 00 00       	mov    $0x3,%esi
  800ebe:	48 89 c7             	mov    %rax,%rdi
  800ec1:	48 b8 ef 08 80 00 00 	movabs $0x8008ef,%rax
  800ec8:	00 00 00 
  800ecb:	ff d0                	callq  *%rax
  800ecd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ed1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ed8:	e9 aa 00 00 00       	jmpq   800f87 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800edd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ee1:	be 03 00 00 00       	mov    $0x3,%esi
  800ee6:	48 89 c7             	mov    %rax,%rdi
  800ee9:	48 b8 ef 08 80 00 00 	movabs $0x8008ef,%rax
  800ef0:	00 00 00 
  800ef3:	ff d0                	callq  *%rax
  800ef5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ef9:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f00:	e9 82 00 00 00       	jmpq   800f87 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800f05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0d:	48 89 d6             	mov    %rdx,%rsi
  800f10:	bf 30 00 00 00       	mov    $0x30,%edi
  800f15:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f17:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f1f:	48 89 d6             	mov    %rdx,%rsi
  800f22:	bf 78 00 00 00       	mov    $0x78,%edi
  800f27:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f2c:	83 f8 30             	cmp    $0x30,%eax
  800f2f:	73 17                	jae    800f48 <vprintfmt+0x44b>
  800f31:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f35:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f38:	89 d2                	mov    %edx,%edx
  800f3a:	48 01 d0             	add    %rdx,%rax
  800f3d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f40:	83 c2 08             	add    $0x8,%edx
  800f43:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f46:	eb 0c                	jmp    800f54 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800f48:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800f4c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800f50:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f54:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f5b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f62:	eb 23                	jmp    800f87 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f64:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f68:	be 03 00 00 00       	mov    $0x3,%esi
  800f6d:	48 89 c7             	mov    %rax,%rdi
  800f70:	48 b8 ef 08 80 00 00 	movabs $0x8008ef,%rax
  800f77:	00 00 00 
  800f7a:	ff d0                	callq  *%rax
  800f7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f80:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f87:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f8c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f8f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f92:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f96:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f9e:	45 89 c1             	mov    %r8d,%r9d
  800fa1:	41 89 f8             	mov    %edi,%r8d
  800fa4:	48 89 c7             	mov    %rax,%rdi
  800fa7:	48 b8 37 08 80 00 00 	movabs $0x800837,%rax
  800fae:	00 00 00 
  800fb1:	ff d0                	callq  *%rax
			break;
  800fb3:	eb 3f                	jmp    800ff4 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fb5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fbd:	48 89 d6             	mov    %rdx,%rsi
  800fc0:	89 df                	mov    %ebx,%edi
  800fc2:	ff d0                	callq  *%rax
			break;
  800fc4:	eb 2e                	jmp    800ff4 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fc6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fce:	48 89 d6             	mov    %rdx,%rsi
  800fd1:	bf 25 00 00 00       	mov    $0x25,%edi
  800fd6:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fd8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fdd:	eb 05                	jmp    800fe4 <vprintfmt+0x4e7>
  800fdf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fe4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fe8:	48 83 e8 01          	sub    $0x1,%rax
  800fec:	0f b6 00             	movzbl (%rax),%eax
  800fef:	3c 25                	cmp    $0x25,%al
  800ff1:	75 ec                	jne    800fdf <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800ff3:	90                   	nop
		}
	}
  800ff4:	e9 3d fb ff ff       	jmpq   800b36 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ff9:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ffa:	48 83 c4 60          	add    $0x60,%rsp
  800ffe:	5b                   	pop    %rbx
  800fff:	41 5c                	pop    %r12
  801001:	5d                   	pop    %rbp
  801002:	c3                   	retq   

0000000000801003 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801003:	55                   	push   %rbp
  801004:	48 89 e5             	mov    %rsp,%rbp
  801007:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80100e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801015:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80101c:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  801023:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80102a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801031:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801038:	84 c0                	test   %al,%al
  80103a:	74 20                	je     80105c <printfmt+0x59>
  80103c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801040:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801044:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801048:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80104c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801050:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801054:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801058:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80105c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801063:	00 00 00 
  801066:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80106d:	00 00 00 
  801070:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801074:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80107b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801082:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801089:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801090:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801097:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80109e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010a5:	48 89 c7             	mov    %rax,%rdi
  8010a8:	48 b8 fd 0a 80 00 00 	movabs $0x800afd,%rax
  8010af:	00 00 00 
  8010b2:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010b4:	90                   	nop
  8010b5:	c9                   	leaveq 
  8010b6:	c3                   	retq   

00000000008010b7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010b7:	55                   	push   %rbp
  8010b8:	48 89 e5             	mov    %rsp,%rbp
  8010bb:	48 83 ec 10          	sub    $0x10,%rsp
  8010bf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ca:	8b 40 10             	mov    0x10(%rax),%eax
  8010cd:	8d 50 01             	lea    0x1(%rax),%edx
  8010d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010db:	48 8b 10             	mov    (%rax),%rdx
  8010de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010e6:	48 39 c2             	cmp    %rax,%rdx
  8010e9:	73 17                	jae    801102 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ef:	48 8b 00             	mov    (%rax),%rax
  8010f2:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010fa:	48 89 0a             	mov    %rcx,(%rdx)
  8010fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801100:	88 10                	mov    %dl,(%rax)
}
  801102:	90                   	nop
  801103:	c9                   	leaveq 
  801104:	c3                   	retq   

0000000000801105 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801105:	55                   	push   %rbp
  801106:	48 89 e5             	mov    %rsp,%rbp
  801109:	48 83 ec 50          	sub    $0x50,%rsp
  80110d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801111:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801114:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801118:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80111c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801120:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801124:	48 8b 0a             	mov    (%rdx),%rcx
  801127:	48 89 08             	mov    %rcx,(%rax)
  80112a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80112e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801132:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801136:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80113a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80113e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801142:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801145:	48 98                	cltq   
  801147:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80114b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80114f:	48 01 d0             	add    %rdx,%rax
  801152:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801156:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80115d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801162:	74 06                	je     80116a <vsnprintf+0x65>
  801164:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801168:	7f 07                	jg     801171 <vsnprintf+0x6c>
		return -E_INVAL;
  80116a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116f:	eb 2f                	jmp    8011a0 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801171:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801175:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801179:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80117d:	48 89 c6             	mov    %rax,%rsi
  801180:	48 bf b7 10 80 00 00 	movabs $0x8010b7,%rdi
  801187:	00 00 00 
  80118a:	48 b8 fd 0a 80 00 00 	movabs $0x800afd,%rax
  801191:	00 00 00 
  801194:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801196:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80119a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80119d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011a0:	c9                   	leaveq 
  8011a1:	c3                   	retq   

00000000008011a2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011a2:	55                   	push   %rbp
  8011a3:	48 89 e5             	mov    %rsp,%rbp
  8011a6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011ad:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011b4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011ba:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8011c1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011c8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011cf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011d6:	84 c0                	test   %al,%al
  8011d8:	74 20                	je     8011fa <snprintf+0x58>
  8011da:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011de:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011e2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011e6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011ea:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011ee:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011f2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011f6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011fa:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801201:	00 00 00 
  801204:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80120b:	00 00 00 
  80120e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801212:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801219:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801220:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801227:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80122e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801235:	48 8b 0a             	mov    (%rdx),%rcx
  801238:	48 89 08             	mov    %rcx,(%rax)
  80123b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80123f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801243:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801247:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80124b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801252:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801259:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80125f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801266:	48 89 c7             	mov    %rax,%rdi
  801269:	48 b8 05 11 80 00 00 	movabs $0x801105,%rax
  801270:	00 00 00 
  801273:	ff d0                	callq  *%rax
  801275:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80127b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801281:	c9                   	leaveq 
  801282:	c3                   	retq   

0000000000801283 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801283:	55                   	push   %rbp
  801284:	48 89 e5             	mov    %rsp,%rbp
  801287:	48 83 ec 18          	sub    $0x18,%rsp
  80128b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80128f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801296:	eb 09                	jmp    8012a1 <strlen+0x1e>
		n++;
  801298:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80129c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a5:	0f b6 00             	movzbl (%rax),%eax
  8012a8:	84 c0                	test   %al,%al
  8012aa:	75 ec                	jne    801298 <strlen+0x15>
		n++;
	return n;
  8012ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012af:	c9                   	leaveq 
  8012b0:	c3                   	retq   

00000000008012b1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012b1:	55                   	push   %rbp
  8012b2:	48 89 e5             	mov    %rsp,%rbp
  8012b5:	48 83 ec 20          	sub    $0x20,%rsp
  8012b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012c8:	eb 0e                	jmp    8012d8 <strnlen+0x27>
		n++;
  8012ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ce:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012d3:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012d8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012dd:	74 0b                	je     8012ea <strnlen+0x39>
  8012df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e3:	0f b6 00             	movzbl (%rax),%eax
  8012e6:	84 c0                	test   %al,%al
  8012e8:	75 e0                	jne    8012ca <strnlen+0x19>
		n++;
	return n;
  8012ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012ed:	c9                   	leaveq 
  8012ee:	c3                   	retq   

00000000008012ef <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012ef:	55                   	push   %rbp
  8012f0:	48 89 e5             	mov    %rsp,%rbp
  8012f3:	48 83 ec 20          	sub    $0x20,%rsp
  8012f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801303:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801307:	90                   	nop
  801308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801310:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801314:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801318:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80131c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801320:	0f b6 12             	movzbl (%rdx),%edx
  801323:	88 10                	mov    %dl,(%rax)
  801325:	0f b6 00             	movzbl (%rax),%eax
  801328:	84 c0                	test   %al,%al
  80132a:	75 dc                	jne    801308 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80132c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801330:	c9                   	leaveq 
  801331:	c3                   	retq   

0000000000801332 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801332:	55                   	push   %rbp
  801333:	48 89 e5             	mov    %rsp,%rbp
  801336:	48 83 ec 20          	sub    $0x20,%rsp
  80133a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80133e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801346:	48 89 c7             	mov    %rax,%rdi
  801349:	48 b8 83 12 80 00 00 	movabs $0x801283,%rax
  801350:	00 00 00 
  801353:	ff d0                	callq  *%rax
  801355:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801358:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80135b:	48 63 d0             	movslq %eax,%rdx
  80135e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801362:	48 01 c2             	add    %rax,%rdx
  801365:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801369:	48 89 c6             	mov    %rax,%rsi
  80136c:	48 89 d7             	mov    %rdx,%rdi
  80136f:	48 b8 ef 12 80 00 00 	movabs $0x8012ef,%rax
  801376:	00 00 00 
  801379:	ff d0                	callq  *%rax
	return dst;
  80137b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80137f:	c9                   	leaveq 
  801380:	c3                   	retq   

0000000000801381 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801381:	55                   	push   %rbp
  801382:	48 89 e5             	mov    %rsp,%rbp
  801385:	48 83 ec 28          	sub    $0x28,%rsp
  801389:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80138d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801391:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801399:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80139d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013a4:	00 
  8013a5:	eb 2a                	jmp    8013d1 <strncpy+0x50>
		*dst++ = *src;
  8013a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ab:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013af:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013b3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013b7:	0f b6 12             	movzbl (%rdx),%edx
  8013ba:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013c0:	0f b6 00             	movzbl (%rax),%eax
  8013c3:	84 c0                	test   %al,%al
  8013c5:	74 05                	je     8013cc <strncpy+0x4b>
			src++;
  8013c7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013d9:	72 cc                	jb     8013a7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013df:	c9                   	leaveq 
  8013e0:	c3                   	retq   

00000000008013e1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013e1:	55                   	push   %rbp
  8013e2:	48 89 e5             	mov    %rsp,%rbp
  8013e5:	48 83 ec 28          	sub    $0x28,%rsp
  8013e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013fd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801402:	74 3d                	je     801441 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801404:	eb 1d                	jmp    801423 <strlcpy+0x42>
			*dst++ = *src++;
  801406:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80140e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801412:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801416:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80141a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80141e:	0f b6 12             	movzbl (%rdx),%edx
  801421:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801423:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801428:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80142d:	74 0b                	je     80143a <strlcpy+0x59>
  80142f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801433:	0f b6 00             	movzbl (%rax),%eax
  801436:	84 c0                	test   %al,%al
  801438:	75 cc                	jne    801406 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80143a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801441:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801445:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801449:	48 29 c2             	sub    %rax,%rdx
  80144c:	48 89 d0             	mov    %rdx,%rax
}
  80144f:	c9                   	leaveq 
  801450:	c3                   	retq   

0000000000801451 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801451:	55                   	push   %rbp
  801452:	48 89 e5             	mov    %rsp,%rbp
  801455:	48 83 ec 10          	sub    $0x10,%rsp
  801459:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80145d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801461:	eb 0a                	jmp    80146d <strcmp+0x1c>
		p++, q++;
  801463:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801468:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80146d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801471:	0f b6 00             	movzbl (%rax),%eax
  801474:	84 c0                	test   %al,%al
  801476:	74 12                	je     80148a <strcmp+0x39>
  801478:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147c:	0f b6 10             	movzbl (%rax),%edx
  80147f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801483:	0f b6 00             	movzbl (%rax),%eax
  801486:	38 c2                	cmp    %al,%dl
  801488:	74 d9                	je     801463 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80148a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148e:	0f b6 00             	movzbl (%rax),%eax
  801491:	0f b6 d0             	movzbl %al,%edx
  801494:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801498:	0f b6 00             	movzbl (%rax),%eax
  80149b:	0f b6 c0             	movzbl %al,%eax
  80149e:	29 c2                	sub    %eax,%edx
  8014a0:	89 d0                	mov    %edx,%eax
}
  8014a2:	c9                   	leaveq 
  8014a3:	c3                   	retq   

00000000008014a4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014a4:	55                   	push   %rbp
  8014a5:	48 89 e5             	mov    %rsp,%rbp
  8014a8:	48 83 ec 18          	sub    $0x18,%rsp
  8014ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014b4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014b8:	eb 0f                	jmp    8014c9 <strncmp+0x25>
		n--, p++, q++;
  8014ba:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014c4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014c9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014ce:	74 1d                	je     8014ed <strncmp+0x49>
  8014d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d4:	0f b6 00             	movzbl (%rax),%eax
  8014d7:	84 c0                	test   %al,%al
  8014d9:	74 12                	je     8014ed <strncmp+0x49>
  8014db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014df:	0f b6 10             	movzbl (%rax),%edx
  8014e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e6:	0f b6 00             	movzbl (%rax),%eax
  8014e9:	38 c2                	cmp    %al,%dl
  8014eb:	74 cd                	je     8014ba <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014ed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014f2:	75 07                	jne    8014fb <strncmp+0x57>
		return 0;
  8014f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f9:	eb 18                	jmp    801513 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ff:	0f b6 00             	movzbl (%rax),%eax
  801502:	0f b6 d0             	movzbl %al,%edx
  801505:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801509:	0f b6 00             	movzbl (%rax),%eax
  80150c:	0f b6 c0             	movzbl %al,%eax
  80150f:	29 c2                	sub    %eax,%edx
  801511:	89 d0                	mov    %edx,%eax
}
  801513:	c9                   	leaveq 
  801514:	c3                   	retq   

0000000000801515 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801515:	55                   	push   %rbp
  801516:	48 89 e5             	mov    %rsp,%rbp
  801519:	48 83 ec 10          	sub    $0x10,%rsp
  80151d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801521:	89 f0                	mov    %esi,%eax
  801523:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801526:	eb 17                	jmp    80153f <strchr+0x2a>
		if (*s == c)
  801528:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152c:	0f b6 00             	movzbl (%rax),%eax
  80152f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801532:	75 06                	jne    80153a <strchr+0x25>
			return (char *) s;
  801534:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801538:	eb 15                	jmp    80154f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80153a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80153f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801543:	0f b6 00             	movzbl (%rax),%eax
  801546:	84 c0                	test   %al,%al
  801548:	75 de                	jne    801528 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154f:	c9                   	leaveq 
  801550:	c3                   	retq   

0000000000801551 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801551:	55                   	push   %rbp
  801552:	48 89 e5             	mov    %rsp,%rbp
  801555:	48 83 ec 10          	sub    $0x10,%rsp
  801559:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80155d:	89 f0                	mov    %esi,%eax
  80155f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801562:	eb 11                	jmp    801575 <strfind+0x24>
		if (*s == c)
  801564:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801568:	0f b6 00             	movzbl (%rax),%eax
  80156b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80156e:	74 12                	je     801582 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801570:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801575:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801579:	0f b6 00             	movzbl (%rax),%eax
  80157c:	84 c0                	test   %al,%al
  80157e:	75 e4                	jne    801564 <strfind+0x13>
  801580:	eb 01                	jmp    801583 <strfind+0x32>
		if (*s == c)
			break;
  801582:	90                   	nop
	return (char *) s;
  801583:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801587:	c9                   	leaveq 
  801588:	c3                   	retq   

0000000000801589 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801589:	55                   	push   %rbp
  80158a:	48 89 e5             	mov    %rsp,%rbp
  80158d:	48 83 ec 18          	sub    $0x18,%rsp
  801591:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801595:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801598:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80159c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015a1:	75 06                	jne    8015a9 <memset+0x20>
		return v;
  8015a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a7:	eb 69                	jmp    801612 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ad:	83 e0 03             	and    $0x3,%eax
  8015b0:	48 85 c0             	test   %rax,%rax
  8015b3:	75 48                	jne    8015fd <memset+0x74>
  8015b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b9:	83 e0 03             	and    $0x3,%eax
  8015bc:	48 85 c0             	test   %rax,%rax
  8015bf:	75 3c                	jne    8015fd <memset+0x74>
		c &= 0xFF;
  8015c1:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015cb:	c1 e0 18             	shl    $0x18,%eax
  8015ce:	89 c2                	mov    %eax,%edx
  8015d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015d3:	c1 e0 10             	shl    $0x10,%eax
  8015d6:	09 c2                	or     %eax,%edx
  8015d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015db:	c1 e0 08             	shl    $0x8,%eax
  8015de:	09 d0                	or     %edx,%eax
  8015e0:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e7:	48 c1 e8 02          	shr    $0x2,%rax
  8015eb:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f5:	48 89 d7             	mov    %rdx,%rdi
  8015f8:	fc                   	cld    
  8015f9:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015fb:	eb 11                	jmp    80160e <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801601:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801604:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801608:	48 89 d7             	mov    %rdx,%rdi
  80160b:	fc                   	cld    
  80160c:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80160e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801612:	c9                   	leaveq 
  801613:	c3                   	retq   

0000000000801614 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801614:	55                   	push   %rbp
  801615:	48 89 e5             	mov    %rsp,%rbp
  801618:	48 83 ec 28          	sub    $0x28,%rsp
  80161c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801620:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801624:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801628:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80162c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801634:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801638:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80163c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801640:	0f 83 88 00 00 00    	jae    8016ce <memmove+0xba>
  801646:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80164a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164e:	48 01 d0             	add    %rdx,%rax
  801651:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801655:	76 77                	jbe    8016ce <memmove+0xba>
		s += n;
  801657:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80165f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801663:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801667:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166b:	83 e0 03             	and    $0x3,%eax
  80166e:	48 85 c0             	test   %rax,%rax
  801671:	75 3b                	jne    8016ae <memmove+0x9a>
  801673:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801677:	83 e0 03             	and    $0x3,%eax
  80167a:	48 85 c0             	test   %rax,%rax
  80167d:	75 2f                	jne    8016ae <memmove+0x9a>
  80167f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801683:	83 e0 03             	and    $0x3,%eax
  801686:	48 85 c0             	test   %rax,%rax
  801689:	75 23                	jne    8016ae <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80168b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80168f:	48 83 e8 04          	sub    $0x4,%rax
  801693:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801697:	48 83 ea 04          	sub    $0x4,%rdx
  80169b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80169f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016a3:	48 89 c7             	mov    %rax,%rdi
  8016a6:	48 89 d6             	mov    %rdx,%rsi
  8016a9:	fd                   	std    
  8016aa:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016ac:	eb 1d                	jmp    8016cb <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ba:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c2:	48 89 d7             	mov    %rdx,%rdi
  8016c5:	48 89 c1             	mov    %rax,%rcx
  8016c8:	fd                   	std    
  8016c9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016cb:	fc                   	cld    
  8016cc:	eb 57                	jmp    801725 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d2:	83 e0 03             	and    $0x3,%eax
  8016d5:	48 85 c0             	test   %rax,%rax
  8016d8:	75 36                	jne    801710 <memmove+0xfc>
  8016da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016de:	83 e0 03             	and    $0x3,%eax
  8016e1:	48 85 c0             	test   %rax,%rax
  8016e4:	75 2a                	jne    801710 <memmove+0xfc>
  8016e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ea:	83 e0 03             	and    $0x3,%eax
  8016ed:	48 85 c0             	test   %rax,%rax
  8016f0:	75 1e                	jne    801710 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f6:	48 c1 e8 02          	shr    $0x2,%rax
  8016fa:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801701:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801705:	48 89 c7             	mov    %rax,%rdi
  801708:	48 89 d6             	mov    %rdx,%rsi
  80170b:	fc                   	cld    
  80170c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80170e:	eb 15                	jmp    801725 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801714:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801718:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80171c:	48 89 c7             	mov    %rax,%rdi
  80171f:	48 89 d6             	mov    %rdx,%rsi
  801722:	fc                   	cld    
  801723:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801725:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801729:	c9                   	leaveq 
  80172a:	c3                   	retq   

000000000080172b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80172b:	55                   	push   %rbp
  80172c:	48 89 e5             	mov    %rsp,%rbp
  80172f:	48 83 ec 18          	sub    $0x18,%rsp
  801733:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801737:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80173b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80173f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801743:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801747:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80174b:	48 89 ce             	mov    %rcx,%rsi
  80174e:	48 89 c7             	mov    %rax,%rdi
  801751:	48 b8 14 16 80 00 00 	movabs $0x801614,%rax
  801758:	00 00 00 
  80175b:	ff d0                	callq  *%rax
}
  80175d:	c9                   	leaveq 
  80175e:	c3                   	retq   

000000000080175f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80175f:	55                   	push   %rbp
  801760:	48 89 e5             	mov    %rsp,%rbp
  801763:	48 83 ec 28          	sub    $0x28,%rsp
  801767:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80176b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80176f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801773:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801777:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80177b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80177f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801783:	eb 36                	jmp    8017bb <memcmp+0x5c>
		if (*s1 != *s2)
  801785:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801789:	0f b6 10             	movzbl (%rax),%edx
  80178c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801790:	0f b6 00             	movzbl (%rax),%eax
  801793:	38 c2                	cmp    %al,%dl
  801795:	74 1a                	je     8017b1 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801797:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80179b:	0f b6 00             	movzbl (%rax),%eax
  80179e:	0f b6 d0             	movzbl %al,%edx
  8017a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a5:	0f b6 00             	movzbl (%rax),%eax
  8017a8:	0f b6 c0             	movzbl %al,%eax
  8017ab:	29 c2                	sub    %eax,%edx
  8017ad:	89 d0                	mov    %edx,%eax
  8017af:	eb 20                	jmp    8017d1 <memcmp+0x72>
		s1++, s2++;
  8017b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017b6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bf:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017c7:	48 85 c0             	test   %rax,%rax
  8017ca:	75 b9                	jne    801785 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d1:	c9                   	leaveq 
  8017d2:	c3                   	retq   

00000000008017d3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017d3:	55                   	push   %rbp
  8017d4:	48 89 e5             	mov    %rsp,%rbp
  8017d7:	48 83 ec 28          	sub    $0x28,%rsp
  8017db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017df:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ee:	48 01 d0             	add    %rdx,%rax
  8017f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017f5:	eb 19                	jmp    801810 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017fb:	0f b6 00             	movzbl (%rax),%eax
  8017fe:	0f b6 d0             	movzbl %al,%edx
  801801:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801804:	0f b6 c0             	movzbl %al,%eax
  801807:	39 c2                	cmp    %eax,%edx
  801809:	74 11                	je     80181c <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80180b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801814:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801818:	72 dd                	jb     8017f7 <memfind+0x24>
  80181a:	eb 01                	jmp    80181d <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80181c:	90                   	nop
	return (void *) s;
  80181d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801821:	c9                   	leaveq 
  801822:	c3                   	retq   

0000000000801823 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801823:	55                   	push   %rbp
  801824:	48 89 e5             	mov    %rsp,%rbp
  801827:	48 83 ec 38          	sub    $0x38,%rsp
  80182b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80182f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801833:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801836:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80183d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801844:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801845:	eb 05                	jmp    80184c <strtol+0x29>
		s++;
  801847:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80184c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801850:	0f b6 00             	movzbl (%rax),%eax
  801853:	3c 20                	cmp    $0x20,%al
  801855:	74 f0                	je     801847 <strtol+0x24>
  801857:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185b:	0f b6 00             	movzbl (%rax),%eax
  80185e:	3c 09                	cmp    $0x9,%al
  801860:	74 e5                	je     801847 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801862:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801866:	0f b6 00             	movzbl (%rax),%eax
  801869:	3c 2b                	cmp    $0x2b,%al
  80186b:	75 07                	jne    801874 <strtol+0x51>
		s++;
  80186d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801872:	eb 17                	jmp    80188b <strtol+0x68>
	else if (*s == '-')
  801874:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801878:	0f b6 00             	movzbl (%rax),%eax
  80187b:	3c 2d                	cmp    $0x2d,%al
  80187d:	75 0c                	jne    80188b <strtol+0x68>
		s++, neg = 1;
  80187f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801884:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80188b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80188f:	74 06                	je     801897 <strtol+0x74>
  801891:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801895:	75 28                	jne    8018bf <strtol+0x9c>
  801897:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189b:	0f b6 00             	movzbl (%rax),%eax
  80189e:	3c 30                	cmp    $0x30,%al
  8018a0:	75 1d                	jne    8018bf <strtol+0x9c>
  8018a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a6:	48 83 c0 01          	add    $0x1,%rax
  8018aa:	0f b6 00             	movzbl (%rax),%eax
  8018ad:	3c 78                	cmp    $0x78,%al
  8018af:	75 0e                	jne    8018bf <strtol+0x9c>
		s += 2, base = 16;
  8018b1:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018b6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018bd:	eb 2c                	jmp    8018eb <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018bf:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018c3:	75 19                	jne    8018de <strtol+0xbb>
  8018c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c9:	0f b6 00             	movzbl (%rax),%eax
  8018cc:	3c 30                	cmp    $0x30,%al
  8018ce:	75 0e                	jne    8018de <strtol+0xbb>
		s++, base = 8;
  8018d0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018d5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018dc:	eb 0d                	jmp    8018eb <strtol+0xc8>
	else if (base == 0)
  8018de:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018e2:	75 07                	jne    8018eb <strtol+0xc8>
		base = 10;
  8018e4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ef:	0f b6 00             	movzbl (%rax),%eax
  8018f2:	3c 2f                	cmp    $0x2f,%al
  8018f4:	7e 1d                	jle    801913 <strtol+0xf0>
  8018f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fa:	0f b6 00             	movzbl (%rax),%eax
  8018fd:	3c 39                	cmp    $0x39,%al
  8018ff:	7f 12                	jg     801913 <strtol+0xf0>
			dig = *s - '0';
  801901:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801905:	0f b6 00             	movzbl (%rax),%eax
  801908:	0f be c0             	movsbl %al,%eax
  80190b:	83 e8 30             	sub    $0x30,%eax
  80190e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801911:	eb 4e                	jmp    801961 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801913:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801917:	0f b6 00             	movzbl (%rax),%eax
  80191a:	3c 60                	cmp    $0x60,%al
  80191c:	7e 1d                	jle    80193b <strtol+0x118>
  80191e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801922:	0f b6 00             	movzbl (%rax),%eax
  801925:	3c 7a                	cmp    $0x7a,%al
  801927:	7f 12                	jg     80193b <strtol+0x118>
			dig = *s - 'a' + 10;
  801929:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192d:	0f b6 00             	movzbl (%rax),%eax
  801930:	0f be c0             	movsbl %al,%eax
  801933:	83 e8 57             	sub    $0x57,%eax
  801936:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801939:	eb 26                	jmp    801961 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80193b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193f:	0f b6 00             	movzbl (%rax),%eax
  801942:	3c 40                	cmp    $0x40,%al
  801944:	7e 47                	jle    80198d <strtol+0x16a>
  801946:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194a:	0f b6 00             	movzbl (%rax),%eax
  80194d:	3c 5a                	cmp    $0x5a,%al
  80194f:	7f 3c                	jg     80198d <strtol+0x16a>
			dig = *s - 'A' + 10;
  801951:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801955:	0f b6 00             	movzbl (%rax),%eax
  801958:	0f be c0             	movsbl %al,%eax
  80195b:	83 e8 37             	sub    $0x37,%eax
  80195e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801961:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801964:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801967:	7d 23                	jge    80198c <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801969:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80196e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801971:	48 98                	cltq   
  801973:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801978:	48 89 c2             	mov    %rax,%rdx
  80197b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80197e:	48 98                	cltq   
  801980:	48 01 d0             	add    %rdx,%rax
  801983:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801987:	e9 5f ff ff ff       	jmpq   8018eb <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80198c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80198d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801992:	74 0b                	je     80199f <strtol+0x17c>
		*endptr = (char *) s;
  801994:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801998:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80199c:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80199f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019a3:	74 09                	je     8019ae <strtol+0x18b>
  8019a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a9:	48 f7 d8             	neg    %rax
  8019ac:	eb 04                	jmp    8019b2 <strtol+0x18f>
  8019ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019b2:	c9                   	leaveq 
  8019b3:	c3                   	retq   

00000000008019b4 <strstr>:

char * strstr(const char *in, const char *str)
{
  8019b4:	55                   	push   %rbp
  8019b5:	48 89 e5             	mov    %rsp,%rbp
  8019b8:	48 83 ec 30          	sub    $0x30,%rsp
  8019bc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019c0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019c8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019cc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019d0:	0f b6 00             	movzbl (%rax),%eax
  8019d3:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019d6:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019da:	75 06                	jne    8019e2 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e0:	eb 6b                	jmp    801a4d <strstr+0x99>

	len = strlen(str);
  8019e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019e6:	48 89 c7             	mov    %rax,%rdi
  8019e9:	48 b8 83 12 80 00 00 	movabs $0x801283,%rax
  8019f0:	00 00 00 
  8019f3:	ff d0                	callq  *%rax
  8019f5:	48 98                	cltq   
  8019f7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ff:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a03:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a07:	0f b6 00             	movzbl (%rax),%eax
  801a0a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a0d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a11:	75 07                	jne    801a1a <strstr+0x66>
				return (char *) 0;
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
  801a18:	eb 33                	jmp    801a4d <strstr+0x99>
		} while (sc != c);
  801a1a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a1e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a21:	75 d8                	jne    8019fb <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a23:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a27:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2f:	48 89 ce             	mov    %rcx,%rsi
  801a32:	48 89 c7             	mov    %rax,%rdi
  801a35:	48 b8 a4 14 80 00 00 	movabs $0x8014a4,%rax
  801a3c:	00 00 00 
  801a3f:	ff d0                	callq  *%rax
  801a41:	85 c0                	test   %eax,%eax
  801a43:	75 b6                	jne    8019fb <strstr+0x47>

	return (char *) (in - 1);
  801a45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a49:	48 83 e8 01          	sub    $0x1,%rax
}
  801a4d:	c9                   	leaveq 
  801a4e:	c3                   	retq   
