
obj/user/faultwrite:     file format elf64-x86-64


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
  80003c:	e8 1f 00 00 00       	callq  800060 <libmain>
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
	*(unsigned*)0 = 0;
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
  800057:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  80005d:	90                   	nop
  80005e:	c9                   	leaveq 
  80005f:	c3                   	retq   

0000000000800060 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %rbp
  800061:	48 89 e5             	mov    %rsp,%rbp
  800064:	48 83 ec 10          	sub    $0x10,%rsp
  800068:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80006b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  80006f:	48 b8 61 02 80 00 00 	movabs $0x800261,%rax
  800076:	00 00 00 
  800079:	ff d0                	callq  *%rax
  80007b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800080:	48 63 d0             	movslq %eax,%rdx
  800083:	48 89 d0             	mov    %rdx,%rax
  800086:	48 c1 e0 03          	shl    $0x3,%rax
  80008a:	48 01 d0             	add    %rdx,%rax
  80008d:	48 c1 e0 05          	shl    $0x5,%rax
  800091:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800098:	00 00 00 
  80009b:	48 01 c2             	add    %rax,%rdx
  80009e:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000a5:	00 00 00 
  8000a8:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000af:	7e 14                	jle    8000c5 <libmain+0x65>
		binaryname = argv[0];
  8000b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000b5:	48 8b 10             	mov    (%rax),%rdx
  8000b8:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000bf:	00 00 00 
  8000c2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000cc:	48 89 d6             	mov    %rdx,%rsi
  8000cf:	89 c7                	mov    %eax,%edi
  8000d1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000d8:	00 00 00 
  8000db:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000dd:	48 b8 ec 00 80 00 00 	movabs $0x8000ec,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
}
  8000e9:	90                   	nop
  8000ea:	c9                   	leaveq 
  8000eb:	c3                   	retq   

00000000008000ec <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ec:	55                   	push   %rbp
  8000ed:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8000f5:	48 b8 1b 02 80 00 00 	movabs $0x80021b,%rax
  8000fc:	00 00 00 
  8000ff:	ff d0                	callq  *%rax
}
  800101:	90                   	nop
  800102:	5d                   	pop    %rbp
  800103:	c3                   	retq   

0000000000800104 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800104:	55                   	push   %rbp
  800105:	48 89 e5             	mov    %rsp,%rbp
  800108:	53                   	push   %rbx
  800109:	48 83 ec 48          	sub    $0x48,%rsp
  80010d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800110:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800113:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800117:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80011b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80011f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800123:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800126:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80012a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80012e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800132:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800136:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80013a:	4c 89 c3             	mov    %r8,%rbx
  80013d:	cd 30                	int    $0x30
  80013f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800143:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800147:	74 3e                	je     800187 <syscall+0x83>
  800149:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80014e:	7e 37                	jle    800187 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800150:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800154:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800157:	49 89 d0             	mov    %rdx,%r8
  80015a:	89 c1                	mov    %eax,%ecx
  80015c:	48 ba 4a 1a 80 00 00 	movabs $0x801a4a,%rdx
  800163:	00 00 00 
  800166:	be 23 00 00 00       	mov    $0x23,%esi
  80016b:	48 bf 67 1a 80 00 00 	movabs $0x801a67,%rdi
  800172:	00 00 00 
  800175:	b8 00 00 00 00       	mov    $0x0,%eax
  80017a:	49 b9 0e 05 80 00 00 	movabs $0x80050e,%r9
  800181:	00 00 00 
  800184:	41 ff d1             	callq  *%r9

	return ret;
  800187:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80018b:	48 83 c4 48          	add    $0x48,%rsp
  80018f:	5b                   	pop    %rbx
  800190:	5d                   	pop    %rbp
  800191:	c3                   	retq   

0000000000800192 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800192:	55                   	push   %rbp
  800193:	48 89 e5             	mov    %rsp,%rbp
  800196:	48 83 ec 10          	sub    $0x10,%rsp
  80019a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80019e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001aa:	48 83 ec 08          	sub    $0x8,%rsp
  8001ae:	6a 00                	pushq  $0x0
  8001b0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001bc:	48 89 d1             	mov    %rdx,%rcx
  8001bf:	48 89 c2             	mov    %rax,%rdx
  8001c2:	be 00 00 00 00       	mov    $0x0,%esi
  8001c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001cc:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  8001d3:	00 00 00 
  8001d6:	ff d0                	callq  *%rax
  8001d8:	48 83 c4 10          	add    $0x10,%rsp
}
  8001dc:	90                   	nop
  8001dd:	c9                   	leaveq 
  8001de:	c3                   	retq   

00000000008001df <sys_cgetc>:

int
sys_cgetc(void)
{
  8001df:	55                   	push   %rbp
  8001e0:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001e3:	48 83 ec 08          	sub    $0x8,%rsp
  8001e7:	6a 00                	pushq  $0x0
  8001e9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ff:	be 00 00 00 00       	mov    $0x0,%esi
  800204:	bf 01 00 00 00       	mov    $0x1,%edi
  800209:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  800210:	00 00 00 
  800213:	ff d0                	callq  *%rax
  800215:	48 83 c4 10          	add    $0x10,%rsp
}
  800219:	c9                   	leaveq 
  80021a:	c3                   	retq   

000000000080021b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80021b:	55                   	push   %rbp
  80021c:	48 89 e5             	mov    %rsp,%rbp
  80021f:	48 83 ec 10          	sub    $0x10,%rsp
  800223:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800226:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800229:	48 98                	cltq   
  80022b:	48 83 ec 08          	sub    $0x8,%rsp
  80022f:	6a 00                	pushq  $0x0
  800231:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800237:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80023d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800242:	48 89 c2             	mov    %rax,%rdx
  800245:	be 01 00 00 00       	mov    $0x1,%esi
  80024a:	bf 03 00 00 00       	mov    $0x3,%edi
  80024f:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  800256:	00 00 00 
  800259:	ff d0                	callq  *%rax
  80025b:	48 83 c4 10          	add    $0x10,%rsp
}
  80025f:	c9                   	leaveq 
  800260:	c3                   	retq   

0000000000800261 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800261:	55                   	push   %rbp
  800262:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800265:	48 83 ec 08          	sub    $0x8,%rsp
  800269:	6a 00                	pushq  $0x0
  80026b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800271:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800277:	b9 00 00 00 00       	mov    $0x0,%ecx
  80027c:	ba 00 00 00 00       	mov    $0x0,%edx
  800281:	be 00 00 00 00       	mov    $0x0,%esi
  800286:	bf 02 00 00 00       	mov    $0x2,%edi
  80028b:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  800292:	00 00 00 
  800295:	ff d0                	callq  *%rax
  800297:	48 83 c4 10          	add    $0x10,%rsp
}
  80029b:	c9                   	leaveq 
  80029c:	c3                   	retq   

000000000080029d <sys_yield>:

void
sys_yield(void)
{
  80029d:	55                   	push   %rbp
  80029e:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002a1:	48 83 ec 08          	sub    $0x8,%rsp
  8002a5:	6a 00                	pushq  $0x0
  8002a7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002ad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002bd:	be 00 00 00 00       	mov    $0x0,%esi
  8002c2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002c7:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  8002ce:	00 00 00 
  8002d1:	ff d0                	callq  *%rax
  8002d3:	48 83 c4 10          	add    $0x10,%rsp
}
  8002d7:	90                   	nop
  8002d8:	c9                   	leaveq 
  8002d9:	c3                   	retq   

00000000008002da <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002da:	55                   	push   %rbp
  8002db:	48 89 e5             	mov    %rsp,%rbp
  8002de:	48 83 ec 10          	sub    $0x10,%rsp
  8002e2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002e9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ef:	48 63 c8             	movslq %eax,%rcx
  8002f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002f9:	48 98                	cltq   
  8002fb:	48 83 ec 08          	sub    $0x8,%rsp
  8002ff:	6a 00                	pushq  $0x0
  800301:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800307:	49 89 c8             	mov    %rcx,%r8
  80030a:	48 89 d1             	mov    %rdx,%rcx
  80030d:	48 89 c2             	mov    %rax,%rdx
  800310:	be 01 00 00 00       	mov    $0x1,%esi
  800315:	bf 04 00 00 00       	mov    $0x4,%edi
  80031a:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  800321:	00 00 00 
  800324:	ff d0                	callq  *%rax
  800326:	48 83 c4 10          	add    $0x10,%rsp
}
  80032a:	c9                   	leaveq 
  80032b:	c3                   	retq   

000000000080032c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80032c:	55                   	push   %rbp
  80032d:	48 89 e5             	mov    %rsp,%rbp
  800330:	48 83 ec 20          	sub    $0x20,%rsp
  800334:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800337:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80033b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80033e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800342:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800346:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800349:	48 63 c8             	movslq %eax,%rcx
  80034c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800350:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800353:	48 63 f0             	movslq %eax,%rsi
  800356:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80035a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80035d:	48 98                	cltq   
  80035f:	48 83 ec 08          	sub    $0x8,%rsp
  800363:	51                   	push   %rcx
  800364:	49 89 f9             	mov    %rdi,%r9
  800367:	49 89 f0             	mov    %rsi,%r8
  80036a:	48 89 d1             	mov    %rdx,%rcx
  80036d:	48 89 c2             	mov    %rax,%rdx
  800370:	be 01 00 00 00       	mov    $0x1,%esi
  800375:	bf 05 00 00 00       	mov    $0x5,%edi
  80037a:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  800381:	00 00 00 
  800384:	ff d0                	callq  *%rax
  800386:	48 83 c4 10          	add    $0x10,%rsp
}
  80038a:	c9                   	leaveq 
  80038b:	c3                   	retq   

000000000080038c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80038c:	55                   	push   %rbp
  80038d:	48 89 e5             	mov    %rsp,%rbp
  800390:	48 83 ec 10          	sub    $0x10,%rsp
  800394:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800397:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80039b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80039f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a2:	48 98                	cltq   
  8003a4:	48 83 ec 08          	sub    $0x8,%rsp
  8003a8:	6a 00                	pushq  $0x0
  8003aa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003b0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003b6:	48 89 d1             	mov    %rdx,%rcx
  8003b9:	48 89 c2             	mov    %rax,%rdx
  8003bc:	be 01 00 00 00       	mov    $0x1,%esi
  8003c1:	bf 06 00 00 00       	mov    $0x6,%edi
  8003c6:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  8003cd:	00 00 00 
  8003d0:	ff d0                	callq  *%rax
  8003d2:	48 83 c4 10          	add    $0x10,%rsp
}
  8003d6:	c9                   	leaveq 
  8003d7:	c3                   	retq   

00000000008003d8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003d8:	55                   	push   %rbp
  8003d9:	48 89 e5             	mov    %rsp,%rbp
  8003dc:	48 83 ec 10          	sub    $0x10,%rsp
  8003e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003e3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003e9:	48 63 d0             	movslq %eax,%rdx
  8003ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ef:	48 98                	cltq   
  8003f1:	48 83 ec 08          	sub    $0x8,%rsp
  8003f5:	6a 00                	pushq  $0x0
  8003f7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003fd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800403:	48 89 d1             	mov    %rdx,%rcx
  800406:	48 89 c2             	mov    %rax,%rdx
  800409:	be 01 00 00 00       	mov    $0x1,%esi
  80040e:	bf 08 00 00 00       	mov    $0x8,%edi
  800413:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  80041a:	00 00 00 
  80041d:	ff d0                	callq  *%rax
  80041f:	48 83 c4 10          	add    $0x10,%rsp
}
  800423:	c9                   	leaveq 
  800424:	c3                   	retq   

0000000000800425 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800425:	55                   	push   %rbp
  800426:	48 89 e5             	mov    %rsp,%rbp
  800429:	48 83 ec 10          	sub    $0x10,%rsp
  80042d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800430:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800434:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800438:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80043b:	48 98                	cltq   
  80043d:	48 83 ec 08          	sub    $0x8,%rsp
  800441:	6a 00                	pushq  $0x0
  800443:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800449:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80044f:	48 89 d1             	mov    %rdx,%rcx
  800452:	48 89 c2             	mov    %rax,%rdx
  800455:	be 01 00 00 00       	mov    $0x1,%esi
  80045a:	bf 09 00 00 00       	mov    $0x9,%edi
  80045f:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
  80046b:	48 83 c4 10          	add    $0x10,%rsp
}
  80046f:	c9                   	leaveq 
  800470:	c3                   	retq   

0000000000800471 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800471:	55                   	push   %rbp
  800472:	48 89 e5             	mov    %rsp,%rbp
  800475:	48 83 ec 20          	sub    $0x20,%rsp
  800479:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80047c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800480:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800484:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800487:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80048a:	48 63 f0             	movslq %eax,%rsi
  80048d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800491:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800494:	48 98                	cltq   
  800496:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80049a:	48 83 ec 08          	sub    $0x8,%rsp
  80049e:	6a 00                	pushq  $0x0
  8004a0:	49 89 f1             	mov    %rsi,%r9
  8004a3:	49 89 c8             	mov    %rcx,%r8
  8004a6:	48 89 d1             	mov    %rdx,%rcx
  8004a9:	48 89 c2             	mov    %rax,%rdx
  8004ac:	be 00 00 00 00       	mov    $0x0,%esi
  8004b1:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004b6:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  8004bd:	00 00 00 
  8004c0:	ff d0                	callq  *%rax
  8004c2:	48 83 c4 10          	add    $0x10,%rsp
}
  8004c6:	c9                   	leaveq 
  8004c7:	c3                   	retq   

00000000008004c8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004c8:	55                   	push   %rbp
  8004c9:	48 89 e5             	mov    %rsp,%rbp
  8004cc:	48 83 ec 10          	sub    $0x10,%rsp
  8004d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004d8:	48 83 ec 08          	sub    $0x8,%rsp
  8004dc:	6a 00                	pushq  $0x0
  8004de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004ef:	48 89 c2             	mov    %rax,%rdx
  8004f2:	be 01 00 00 00       	mov    $0x1,%esi
  8004f7:	bf 0c 00 00 00       	mov    $0xc,%edi
  8004fc:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  800503:	00 00 00 
  800506:	ff d0                	callq  *%rax
  800508:	48 83 c4 10          	add    $0x10,%rsp
}
  80050c:	c9                   	leaveq 
  80050d:	c3                   	retq   

000000000080050e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80050e:	55                   	push   %rbp
  80050f:	48 89 e5             	mov    %rsp,%rbp
  800512:	53                   	push   %rbx
  800513:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80051a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800521:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800527:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80052e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800535:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80053c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800543:	84 c0                	test   %al,%al
  800545:	74 23                	je     80056a <_panic+0x5c>
  800547:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80054e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800552:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800556:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80055a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80055e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800562:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800566:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80056a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800571:	00 00 00 
  800574:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80057b:	00 00 00 
  80057e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800582:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800589:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800590:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800597:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80059e:	00 00 00 
  8005a1:	48 8b 18             	mov    (%rax),%rbx
  8005a4:	48 b8 61 02 80 00 00 	movabs $0x800261,%rax
  8005ab:	00 00 00 
  8005ae:	ff d0                	callq  *%rax
  8005b0:	89 c6                	mov    %eax,%esi
  8005b2:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8005b8:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8005bf:	41 89 d0             	mov    %edx,%r8d
  8005c2:	48 89 c1             	mov    %rax,%rcx
  8005c5:	48 89 da             	mov    %rbx,%rdx
  8005c8:	48 bf 78 1a 80 00 00 	movabs $0x801a78,%rdi
  8005cf:	00 00 00 
  8005d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d7:	49 b9 48 07 80 00 00 	movabs $0x800748,%r9
  8005de:	00 00 00 
  8005e1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005e4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005eb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005f2:	48 89 d6             	mov    %rdx,%rsi
  8005f5:	48 89 c7             	mov    %rax,%rdi
  8005f8:	48 b8 9c 06 80 00 00 	movabs $0x80069c,%rax
  8005ff:	00 00 00 
  800602:	ff d0                	callq  *%rax
	cprintf("\n");
  800604:	48 bf 9b 1a 80 00 00 	movabs $0x801a9b,%rdi
  80060b:	00 00 00 
  80060e:	b8 00 00 00 00       	mov    $0x0,%eax
  800613:	48 ba 48 07 80 00 00 	movabs $0x800748,%rdx
  80061a:	00 00 00 
  80061d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80061f:	cc                   	int3   
  800620:	eb fd                	jmp    80061f <_panic+0x111>

0000000000800622 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800622:	55                   	push   %rbp
  800623:	48 89 e5             	mov    %rsp,%rbp
  800626:	48 83 ec 10          	sub    $0x10,%rsp
  80062a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80062d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800635:	8b 00                	mov    (%rax),%eax
  800637:	8d 48 01             	lea    0x1(%rax),%ecx
  80063a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80063e:	89 0a                	mov    %ecx,(%rdx)
  800640:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800643:	89 d1                	mov    %edx,%ecx
  800645:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800649:	48 98                	cltq   
  80064b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80064f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800653:	8b 00                	mov    (%rax),%eax
  800655:	3d ff 00 00 00       	cmp    $0xff,%eax
  80065a:	75 2c                	jne    800688 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80065c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800660:	8b 00                	mov    (%rax),%eax
  800662:	48 98                	cltq   
  800664:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800668:	48 83 c2 08          	add    $0x8,%rdx
  80066c:	48 89 c6             	mov    %rax,%rsi
  80066f:	48 89 d7             	mov    %rdx,%rdi
  800672:	48 b8 92 01 80 00 00 	movabs $0x800192,%rax
  800679:	00 00 00 
  80067c:	ff d0                	callq  *%rax
        b->idx = 0;
  80067e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800682:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068c:	8b 40 04             	mov    0x4(%rax),%eax
  80068f:	8d 50 01             	lea    0x1(%rax),%edx
  800692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800696:	89 50 04             	mov    %edx,0x4(%rax)
}
  800699:	90                   	nop
  80069a:	c9                   	leaveq 
  80069b:	c3                   	retq   

000000000080069c <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80069c:	55                   	push   %rbp
  80069d:	48 89 e5             	mov    %rsp,%rbp
  8006a0:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006a7:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006ae:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006b5:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006bc:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006c3:	48 8b 0a             	mov    (%rdx),%rcx
  8006c6:	48 89 08             	mov    %rcx,(%rax)
  8006c9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006cd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006d1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006d5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006e0:	00 00 00 
    b.cnt = 0;
  8006e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006ea:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006ed:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006f4:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006fb:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800702:	48 89 c6             	mov    %rax,%rsi
  800705:	48 bf 22 06 80 00 00 	movabs $0x800622,%rdi
  80070c:	00 00 00 
  80070f:	48 b8 e6 0a 80 00 00 	movabs $0x800ae6,%rax
  800716:	00 00 00 
  800719:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80071b:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800721:	48 98                	cltq   
  800723:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80072a:	48 83 c2 08          	add    $0x8,%rdx
  80072e:	48 89 c6             	mov    %rax,%rsi
  800731:	48 89 d7             	mov    %rdx,%rdi
  800734:	48 b8 92 01 80 00 00 	movabs $0x800192,%rax
  80073b:	00 00 00 
  80073e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800740:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800746:	c9                   	leaveq 
  800747:	c3                   	retq   

0000000000800748 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800748:	55                   	push   %rbp
  800749:	48 89 e5             	mov    %rsp,%rbp
  80074c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800753:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80075a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800761:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800768:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80076f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800776:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80077d:	84 c0                	test   %al,%al
  80077f:	74 20                	je     8007a1 <cprintf+0x59>
  800781:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800785:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800789:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80078d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800791:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800795:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800799:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80079d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007a1:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007a8:	00 00 00 
  8007ab:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007b2:	00 00 00 
  8007b5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007b9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007c0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007c7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007ce:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007d5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007dc:	48 8b 0a             	mov    (%rdx),%rcx
  8007df:	48 89 08             	mov    %rcx,(%rax)
  8007e2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007e6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007ea:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007ee:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007f2:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007f9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800800:	48 89 d6             	mov    %rdx,%rsi
  800803:	48 89 c7             	mov    %rax,%rdi
  800806:	48 b8 9c 06 80 00 00 	movabs $0x80069c,%rax
  80080d:	00 00 00 
  800810:	ff d0                	callq  *%rax
  800812:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800818:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80081e:	c9                   	leaveq 
  80081f:	c3                   	retq   

0000000000800820 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800820:	55                   	push   %rbp
  800821:	48 89 e5             	mov    %rsp,%rbp
  800824:	48 83 ec 30          	sub    $0x30,%rsp
  800828:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80082c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800830:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800834:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800837:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80083b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80083f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800842:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800846:	77 54                	ja     80089c <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800848:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80084b:	8d 78 ff             	lea    -0x1(%rax),%edi
  80084e:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800855:	ba 00 00 00 00       	mov    $0x0,%edx
  80085a:	48 f7 f6             	div    %rsi
  80085d:	49 89 c2             	mov    %rax,%r10
  800860:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800863:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800866:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80086a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80086e:	41 89 c9             	mov    %ecx,%r9d
  800871:	41 89 f8             	mov    %edi,%r8d
  800874:	89 d1                	mov    %edx,%ecx
  800876:	4c 89 d2             	mov    %r10,%rdx
  800879:	48 89 c7             	mov    %rax,%rdi
  80087c:	48 b8 20 08 80 00 00 	movabs $0x800820,%rax
  800883:	00 00 00 
  800886:	ff d0                	callq  *%rax
  800888:	eb 1c                	jmp    8008a6 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80088a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80088e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800891:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800895:	48 89 ce             	mov    %rcx,%rsi
  800898:	89 d7                	mov    %edx,%edi
  80089a:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80089c:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8008a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8008a4:	7f e4                	jg     80088a <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008a6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8008a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b2:	48 f7 f1             	div    %rcx
  8008b5:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  8008bc:	00 00 00 
  8008bf:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8008c3:	0f be d0             	movsbl %al,%edx
  8008c6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8008ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008ce:	48 89 ce             	mov    %rcx,%rsi
  8008d1:	89 d7                	mov    %edx,%edi
  8008d3:	ff d0                	callq  *%rax
}
  8008d5:	90                   	nop
  8008d6:	c9                   	leaveq 
  8008d7:	c3                   	retq   

00000000008008d8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008d8:	55                   	push   %rbp
  8008d9:	48 89 e5             	mov    %rsp,%rbp
  8008dc:	48 83 ec 20          	sub    $0x20,%rsp
  8008e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008e4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008e7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008eb:	7e 4f                	jle    80093c <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8008ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f1:	8b 00                	mov    (%rax),%eax
  8008f3:	83 f8 30             	cmp    $0x30,%eax
  8008f6:	73 24                	jae    80091c <getuint+0x44>
  8008f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800900:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800904:	8b 00                	mov    (%rax),%eax
  800906:	89 c0                	mov    %eax,%eax
  800908:	48 01 d0             	add    %rdx,%rax
  80090b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090f:	8b 12                	mov    (%rdx),%edx
  800911:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800914:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800918:	89 0a                	mov    %ecx,(%rdx)
  80091a:	eb 14                	jmp    800930 <getuint+0x58>
  80091c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800920:	48 8b 40 08          	mov    0x8(%rax),%rax
  800924:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800928:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800930:	48 8b 00             	mov    (%rax),%rax
  800933:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800937:	e9 9d 00 00 00       	jmpq   8009d9 <getuint+0x101>
	else if (lflag)
  80093c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800940:	74 4c                	je     80098e <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800946:	8b 00                	mov    (%rax),%eax
  800948:	83 f8 30             	cmp    $0x30,%eax
  80094b:	73 24                	jae    800971 <getuint+0x99>
  80094d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800951:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800955:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800959:	8b 00                	mov    (%rax),%eax
  80095b:	89 c0                	mov    %eax,%eax
  80095d:	48 01 d0             	add    %rdx,%rax
  800960:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800964:	8b 12                	mov    (%rdx),%edx
  800966:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800969:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096d:	89 0a                	mov    %ecx,(%rdx)
  80096f:	eb 14                	jmp    800985 <getuint+0xad>
  800971:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800975:	48 8b 40 08          	mov    0x8(%rax),%rax
  800979:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80097d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800981:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800985:	48 8b 00             	mov    (%rax),%rax
  800988:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80098c:	eb 4b                	jmp    8009d9 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  80098e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800992:	8b 00                	mov    (%rax),%eax
  800994:	83 f8 30             	cmp    $0x30,%eax
  800997:	73 24                	jae    8009bd <getuint+0xe5>
  800999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a5:	8b 00                	mov    (%rax),%eax
  8009a7:	89 c0                	mov    %eax,%eax
  8009a9:	48 01 d0             	add    %rdx,%rax
  8009ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b0:	8b 12                	mov    (%rdx),%edx
  8009b2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b9:	89 0a                	mov    %ecx,(%rdx)
  8009bb:	eb 14                	jmp    8009d1 <getuint+0xf9>
  8009bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009c5:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009d1:	8b 00                	mov    (%rax),%eax
  8009d3:	89 c0                	mov    %eax,%eax
  8009d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009dd:	c9                   	leaveq 
  8009de:	c3                   	retq   

00000000008009df <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009df:	55                   	push   %rbp
  8009e0:	48 89 e5             	mov    %rsp,%rbp
  8009e3:	48 83 ec 20          	sub    $0x20,%rsp
  8009e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009eb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009ee:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009f2:	7e 4f                	jle    800a43 <getint+0x64>
		x=va_arg(*ap, long long);
  8009f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f8:	8b 00                	mov    (%rax),%eax
  8009fa:	83 f8 30             	cmp    $0x30,%eax
  8009fd:	73 24                	jae    800a23 <getint+0x44>
  8009ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a03:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0b:	8b 00                	mov    (%rax),%eax
  800a0d:	89 c0                	mov    %eax,%eax
  800a0f:	48 01 d0             	add    %rdx,%rax
  800a12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a16:	8b 12                	mov    (%rdx),%edx
  800a18:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a1b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1f:	89 0a                	mov    %ecx,(%rdx)
  800a21:	eb 14                	jmp    800a37 <getint+0x58>
  800a23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a27:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a2b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a33:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a37:	48 8b 00             	mov    (%rax),%rax
  800a3a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a3e:	e9 9d 00 00 00       	jmpq   800ae0 <getint+0x101>
	else if (lflag)
  800a43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a47:	74 4c                	je     800a95 <getint+0xb6>
		x=va_arg(*ap, long);
  800a49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4d:	8b 00                	mov    (%rax),%eax
  800a4f:	83 f8 30             	cmp    $0x30,%eax
  800a52:	73 24                	jae    800a78 <getint+0x99>
  800a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a58:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a60:	8b 00                	mov    (%rax),%eax
  800a62:	89 c0                	mov    %eax,%eax
  800a64:	48 01 d0             	add    %rdx,%rax
  800a67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6b:	8b 12                	mov    (%rdx),%edx
  800a6d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a70:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a74:	89 0a                	mov    %ecx,(%rdx)
  800a76:	eb 14                	jmp    800a8c <getint+0xad>
  800a78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a80:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a84:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a88:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a8c:	48 8b 00             	mov    (%rax),%rax
  800a8f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a93:	eb 4b                	jmp    800ae0 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800a95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a99:	8b 00                	mov    (%rax),%eax
  800a9b:	83 f8 30             	cmp    $0x30,%eax
  800a9e:	73 24                	jae    800ac4 <getint+0xe5>
  800aa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800aa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aac:	8b 00                	mov    (%rax),%eax
  800aae:	89 c0                	mov    %eax,%eax
  800ab0:	48 01 d0             	add    %rdx,%rax
  800ab3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab7:	8b 12                	mov    (%rdx),%edx
  800ab9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800abc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac0:	89 0a                	mov    %ecx,(%rdx)
  800ac2:	eb 14                	jmp    800ad8 <getint+0xf9>
  800ac4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac8:	48 8b 40 08          	mov    0x8(%rax),%rax
  800acc:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ad0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ad8:	8b 00                	mov    (%rax),%eax
  800ada:	48 98                	cltq   
  800adc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ae0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ae4:	c9                   	leaveq 
  800ae5:	c3                   	retq   

0000000000800ae6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ae6:	55                   	push   %rbp
  800ae7:	48 89 e5             	mov    %rsp,%rbp
  800aea:	41 54                	push   %r12
  800aec:	53                   	push   %rbx
  800aed:	48 83 ec 60          	sub    $0x60,%rsp
  800af1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800af5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800af9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800afd:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b01:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b05:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b09:	48 8b 0a             	mov    (%rdx),%rcx
  800b0c:	48 89 08             	mov    %rcx,(%rax)
  800b0f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b13:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b17:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b1b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b1f:	eb 17                	jmp    800b38 <vprintfmt+0x52>
			if (ch == '\0')
  800b21:	85 db                	test   %ebx,%ebx
  800b23:	0f 84 b9 04 00 00    	je     800fe2 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800b29:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b2d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b31:	48 89 d6             	mov    %rdx,%rsi
  800b34:	89 df                	mov    %ebx,%edi
  800b36:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b38:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b3c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b40:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b44:	0f b6 00             	movzbl (%rax),%eax
  800b47:	0f b6 d8             	movzbl %al,%ebx
  800b4a:	83 fb 25             	cmp    $0x25,%ebx
  800b4d:	75 d2                	jne    800b21 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b4f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b53:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b5a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b61:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b68:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b6f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b73:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b77:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b7b:	0f b6 00             	movzbl (%rax),%eax
  800b7e:	0f b6 d8             	movzbl %al,%ebx
  800b81:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b84:	83 f8 55             	cmp    $0x55,%eax
  800b87:	0f 87 22 04 00 00    	ja     800faf <vprintfmt+0x4c9>
  800b8d:	89 c0                	mov    %eax,%eax
  800b8f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b96:	00 
  800b97:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  800b9e:	00 00 00 
  800ba1:	48 01 d0             	add    %rdx,%rax
  800ba4:	48 8b 00             	mov    (%rax),%rax
  800ba7:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ba9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bad:	eb c0                	jmp    800b6f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800baf:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bb3:	eb ba                	jmp    800b6f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bb5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bbc:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bbf:	89 d0                	mov    %edx,%eax
  800bc1:	c1 e0 02             	shl    $0x2,%eax
  800bc4:	01 d0                	add    %edx,%eax
  800bc6:	01 c0                	add    %eax,%eax
  800bc8:	01 d8                	add    %ebx,%eax
  800bca:	83 e8 30             	sub    $0x30,%eax
  800bcd:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bd0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bd4:	0f b6 00             	movzbl (%rax),%eax
  800bd7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bda:	83 fb 2f             	cmp    $0x2f,%ebx
  800bdd:	7e 60                	jle    800c3f <vprintfmt+0x159>
  800bdf:	83 fb 39             	cmp    $0x39,%ebx
  800be2:	7f 5b                	jg     800c3f <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800be9:	eb d1                	jmp    800bbc <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800beb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bee:	83 f8 30             	cmp    $0x30,%eax
  800bf1:	73 17                	jae    800c0a <vprintfmt+0x124>
  800bf3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800bf7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bfa:	89 d2                	mov    %edx,%edx
  800bfc:	48 01 d0             	add    %rdx,%rax
  800bff:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c02:	83 c2 08             	add    $0x8,%edx
  800c05:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c08:	eb 0c                	jmp    800c16 <vprintfmt+0x130>
  800c0a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c0e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c12:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c16:	8b 00                	mov    (%rax),%eax
  800c18:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c1b:	eb 23                	jmp    800c40 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800c1d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c21:	0f 89 48 ff ff ff    	jns    800b6f <vprintfmt+0x89>
				width = 0;
  800c27:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c2e:	e9 3c ff ff ff       	jmpq   800b6f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c33:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c3a:	e9 30 ff ff ff       	jmpq   800b6f <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c3f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c40:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c44:	0f 89 25 ff ff ff    	jns    800b6f <vprintfmt+0x89>
				width = precision, precision = -1;
  800c4a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c4d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c50:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c57:	e9 13 ff ff ff       	jmpq   800b6f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c5c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c60:	e9 0a ff ff ff       	jmpq   800b6f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c65:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c68:	83 f8 30             	cmp    $0x30,%eax
  800c6b:	73 17                	jae    800c84 <vprintfmt+0x19e>
  800c6d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c71:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c74:	89 d2                	mov    %edx,%edx
  800c76:	48 01 d0             	add    %rdx,%rax
  800c79:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c7c:	83 c2 08             	add    $0x8,%edx
  800c7f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c82:	eb 0c                	jmp    800c90 <vprintfmt+0x1aa>
  800c84:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c88:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c8c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c90:	8b 10                	mov    (%rax),%edx
  800c92:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9a:	48 89 ce             	mov    %rcx,%rsi
  800c9d:	89 d7                	mov    %edx,%edi
  800c9f:	ff d0                	callq  *%rax
			break;
  800ca1:	e9 37 03 00 00       	jmpq   800fdd <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ca6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca9:	83 f8 30             	cmp    $0x30,%eax
  800cac:	73 17                	jae    800cc5 <vprintfmt+0x1df>
  800cae:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cb2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb5:	89 d2                	mov    %edx,%edx
  800cb7:	48 01 d0             	add    %rdx,%rax
  800cba:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cbd:	83 c2 08             	add    $0x8,%edx
  800cc0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cc3:	eb 0c                	jmp    800cd1 <vprintfmt+0x1eb>
  800cc5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cc9:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ccd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cd1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cd3:	85 db                	test   %ebx,%ebx
  800cd5:	79 02                	jns    800cd9 <vprintfmt+0x1f3>
				err = -err;
  800cd7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cd9:	83 fb 15             	cmp    $0x15,%ebx
  800cdc:	7f 16                	jg     800cf4 <vprintfmt+0x20e>
  800cde:	48 b8 40 1b 80 00 00 	movabs $0x801b40,%rax
  800ce5:	00 00 00 
  800ce8:	48 63 d3             	movslq %ebx,%rdx
  800ceb:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cef:	4d 85 e4             	test   %r12,%r12
  800cf2:	75 2e                	jne    800d22 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800cf4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cf8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfc:	89 d9                	mov    %ebx,%ecx
  800cfe:	48 ba 01 1c 80 00 00 	movabs $0x801c01,%rdx
  800d05:	00 00 00 
  800d08:	48 89 c7             	mov    %rax,%rdi
  800d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d10:	49 b8 ec 0f 80 00 00 	movabs $0x800fec,%r8
  800d17:	00 00 00 
  800d1a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d1d:	e9 bb 02 00 00       	jmpq   800fdd <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d22:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2a:	4c 89 e1             	mov    %r12,%rcx
  800d2d:	48 ba 0a 1c 80 00 00 	movabs $0x801c0a,%rdx
  800d34:	00 00 00 
  800d37:	48 89 c7             	mov    %rax,%rdi
  800d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3f:	49 b8 ec 0f 80 00 00 	movabs $0x800fec,%r8
  800d46:	00 00 00 
  800d49:	41 ff d0             	callq  *%r8
			break;
  800d4c:	e9 8c 02 00 00       	jmpq   800fdd <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d51:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d54:	83 f8 30             	cmp    $0x30,%eax
  800d57:	73 17                	jae    800d70 <vprintfmt+0x28a>
  800d59:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d5d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d60:	89 d2                	mov    %edx,%edx
  800d62:	48 01 d0             	add    %rdx,%rax
  800d65:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d68:	83 c2 08             	add    $0x8,%edx
  800d6b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d6e:	eb 0c                	jmp    800d7c <vprintfmt+0x296>
  800d70:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d74:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d78:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d7c:	4c 8b 20             	mov    (%rax),%r12
  800d7f:	4d 85 e4             	test   %r12,%r12
  800d82:	75 0a                	jne    800d8e <vprintfmt+0x2a8>
				p = "(null)";
  800d84:	49 bc 0d 1c 80 00 00 	movabs $0x801c0d,%r12
  800d8b:	00 00 00 
			if (width > 0 && padc != '-')
  800d8e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d92:	7e 78                	jle    800e0c <vprintfmt+0x326>
  800d94:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d98:	74 72                	je     800e0c <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d9a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d9d:	48 98                	cltq   
  800d9f:	48 89 c6             	mov    %rax,%rsi
  800da2:	4c 89 e7             	mov    %r12,%rdi
  800da5:	48 b8 9a 12 80 00 00 	movabs $0x80129a,%rax
  800dac:	00 00 00 
  800daf:	ff d0                	callq  *%rax
  800db1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800db4:	eb 17                	jmp    800dcd <vprintfmt+0x2e7>
					putch(padc, putdat);
  800db6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800dba:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc2:	48 89 ce             	mov    %rcx,%rsi
  800dc5:	89 d7                	mov    %edx,%edi
  800dc7:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dcd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dd1:	7f e3                	jg     800db6 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dd3:	eb 37                	jmp    800e0c <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800dd5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800dd9:	74 1e                	je     800df9 <vprintfmt+0x313>
  800ddb:	83 fb 1f             	cmp    $0x1f,%ebx
  800dde:	7e 05                	jle    800de5 <vprintfmt+0x2ff>
  800de0:	83 fb 7e             	cmp    $0x7e,%ebx
  800de3:	7e 14                	jle    800df9 <vprintfmt+0x313>
					putch('?', putdat);
  800de5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ded:	48 89 d6             	mov    %rdx,%rsi
  800df0:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800df5:	ff d0                	callq  *%rax
  800df7:	eb 0f                	jmp    800e08 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800df9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dfd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e01:	48 89 d6             	mov    %rdx,%rsi
  800e04:	89 df                	mov    %ebx,%edi
  800e06:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e08:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e0c:	4c 89 e0             	mov    %r12,%rax
  800e0f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e13:	0f b6 00             	movzbl (%rax),%eax
  800e16:	0f be d8             	movsbl %al,%ebx
  800e19:	85 db                	test   %ebx,%ebx
  800e1b:	74 28                	je     800e45 <vprintfmt+0x35f>
  800e1d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e21:	78 b2                	js     800dd5 <vprintfmt+0x2ef>
  800e23:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e27:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e2b:	79 a8                	jns    800dd5 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e2d:	eb 16                	jmp    800e45 <vprintfmt+0x35f>
				putch(' ', putdat);
  800e2f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e33:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e37:	48 89 d6             	mov    %rdx,%rsi
  800e3a:	bf 20 00 00 00       	mov    $0x20,%edi
  800e3f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e41:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e45:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e49:	7f e4                	jg     800e2f <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800e4b:	e9 8d 01 00 00       	jmpq   800fdd <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e50:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e54:	be 03 00 00 00       	mov    $0x3,%esi
  800e59:	48 89 c7             	mov    %rax,%rdi
  800e5c:	48 b8 df 09 80 00 00 	movabs $0x8009df,%rax
  800e63:	00 00 00 
  800e66:	ff d0                	callq  *%rax
  800e68:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e70:	48 85 c0             	test   %rax,%rax
  800e73:	79 1d                	jns    800e92 <vprintfmt+0x3ac>
				putch('-', putdat);
  800e75:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e79:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e7d:	48 89 d6             	mov    %rdx,%rsi
  800e80:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e85:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	48 f7 d8             	neg    %rax
  800e8e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e92:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e99:	e9 d2 00 00 00       	jmpq   800f70 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e9e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ea2:	be 03 00 00 00       	mov    $0x3,%esi
  800ea7:	48 89 c7             	mov    %rax,%rdi
  800eaa:	48 b8 d8 08 80 00 00 	movabs $0x8008d8,%rax
  800eb1:	00 00 00 
  800eb4:	ff d0                	callq  *%rax
  800eb6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800eba:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ec1:	e9 aa 00 00 00       	jmpq   800f70 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800ec6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eca:	be 03 00 00 00       	mov    $0x3,%esi
  800ecf:	48 89 c7             	mov    %rax,%rdi
  800ed2:	48 b8 d8 08 80 00 00 	movabs $0x8008d8,%rax
  800ed9:	00 00 00 
  800edc:	ff d0                	callq  *%rax
  800ede:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ee2:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ee9:	e9 82 00 00 00       	jmpq   800f70 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800eee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef6:	48 89 d6             	mov    %rdx,%rsi
  800ef9:	bf 30 00 00 00       	mov    $0x30,%edi
  800efe:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f08:	48 89 d6             	mov    %rdx,%rsi
  800f0b:	bf 78 00 00 00       	mov    $0x78,%edi
  800f10:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f15:	83 f8 30             	cmp    $0x30,%eax
  800f18:	73 17                	jae    800f31 <vprintfmt+0x44b>
  800f1a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f1e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f21:	89 d2                	mov    %edx,%edx
  800f23:	48 01 d0             	add    %rdx,%rax
  800f26:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f29:	83 c2 08             	add    $0x8,%edx
  800f2c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f2f:	eb 0c                	jmp    800f3d <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800f31:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800f35:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800f39:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f3d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f40:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f44:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f4b:	eb 23                	jmp    800f70 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f4d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f51:	be 03 00 00 00       	mov    $0x3,%esi
  800f56:	48 89 c7             	mov    %rax,%rdi
  800f59:	48 b8 d8 08 80 00 00 	movabs $0x8008d8,%rax
  800f60:	00 00 00 
  800f63:	ff d0                	callq  *%rax
  800f65:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f69:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f70:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f75:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f78:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f7b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f7f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f87:	45 89 c1             	mov    %r8d,%r9d
  800f8a:	41 89 f8             	mov    %edi,%r8d
  800f8d:	48 89 c7             	mov    %rax,%rdi
  800f90:	48 b8 20 08 80 00 00 	movabs $0x800820,%rax
  800f97:	00 00 00 
  800f9a:	ff d0                	callq  *%rax
			break;
  800f9c:	eb 3f                	jmp    800fdd <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f9e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fa2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fa6:	48 89 d6             	mov    %rdx,%rsi
  800fa9:	89 df                	mov    %ebx,%edi
  800fab:	ff d0                	callq  *%rax
			break;
  800fad:	eb 2e                	jmp    800fdd <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800faf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fb3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fb7:	48 89 d6             	mov    %rdx,%rsi
  800fba:	bf 25 00 00 00       	mov    $0x25,%edi
  800fbf:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fc1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fc6:	eb 05                	jmp    800fcd <vprintfmt+0x4e7>
  800fc8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fcd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fd1:	48 83 e8 01          	sub    $0x1,%rax
  800fd5:	0f b6 00             	movzbl (%rax),%eax
  800fd8:	3c 25                	cmp    $0x25,%al
  800fda:	75 ec                	jne    800fc8 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800fdc:	90                   	nop
		}
	}
  800fdd:	e9 3d fb ff ff       	jmpq   800b1f <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fe2:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800fe3:	48 83 c4 60          	add    $0x60,%rsp
  800fe7:	5b                   	pop    %rbx
  800fe8:	41 5c                	pop    %r12
  800fea:	5d                   	pop    %rbp
  800feb:	c3                   	retq   

0000000000800fec <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fec:	55                   	push   %rbp
  800fed:	48 89 e5             	mov    %rsp,%rbp
  800ff0:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ff7:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ffe:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801005:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  80100c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801013:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80101a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801021:	84 c0                	test   %al,%al
  801023:	74 20                	je     801045 <printfmt+0x59>
  801025:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801029:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80102d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801031:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801035:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801039:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80103d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801041:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801045:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80104c:	00 00 00 
  80104f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801056:	00 00 00 
  801059:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80105d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801064:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80106b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801072:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801079:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801080:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801087:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80108e:	48 89 c7             	mov    %rax,%rdi
  801091:	48 b8 e6 0a 80 00 00 	movabs $0x800ae6,%rax
  801098:	00 00 00 
  80109b:	ff d0                	callq  *%rax
	va_end(ap);
}
  80109d:	90                   	nop
  80109e:	c9                   	leaveq 
  80109f:	c3                   	retq   

00000000008010a0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010a0:	55                   	push   %rbp
  8010a1:	48 89 e5             	mov    %rsp,%rbp
  8010a4:	48 83 ec 10          	sub    $0x10,%rsp
  8010a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b3:	8b 40 10             	mov    0x10(%rax),%eax
  8010b6:	8d 50 01             	lea    0x1(%rax),%edx
  8010b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010bd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c4:	48 8b 10             	mov    (%rax),%rdx
  8010c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010cb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010cf:	48 39 c2             	cmp    %rax,%rdx
  8010d2:	73 17                	jae    8010eb <sprintputch+0x4b>
		*b->buf++ = ch;
  8010d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d8:	48 8b 00             	mov    (%rax),%rax
  8010db:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010e3:	48 89 0a             	mov    %rcx,(%rdx)
  8010e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010e9:	88 10                	mov    %dl,(%rax)
}
  8010eb:	90                   	nop
  8010ec:	c9                   	leaveq 
  8010ed:	c3                   	retq   

00000000008010ee <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010ee:	55                   	push   %rbp
  8010ef:	48 89 e5             	mov    %rsp,%rbp
  8010f2:	48 83 ec 50          	sub    $0x50,%rsp
  8010f6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010fa:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8010fd:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801101:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801105:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801109:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80110d:	48 8b 0a             	mov    (%rdx),%rcx
  801110:	48 89 08             	mov    %rcx,(%rax)
  801113:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801117:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80111b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80111f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801123:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801127:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80112b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80112e:	48 98                	cltq   
  801130:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801134:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801138:	48 01 d0             	add    %rdx,%rax
  80113b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80113f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801146:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80114b:	74 06                	je     801153 <vsnprintf+0x65>
  80114d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801151:	7f 07                	jg     80115a <vsnprintf+0x6c>
		return -E_INVAL;
  801153:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801158:	eb 2f                	jmp    801189 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80115a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80115e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801162:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801166:	48 89 c6             	mov    %rax,%rsi
  801169:	48 bf a0 10 80 00 00 	movabs $0x8010a0,%rdi
  801170:	00 00 00 
  801173:	48 b8 e6 0a 80 00 00 	movabs $0x800ae6,%rax
  80117a:	00 00 00 
  80117d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80117f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801183:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801186:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801189:	c9                   	leaveq 
  80118a:	c3                   	retq   

000000000080118b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80118b:	55                   	push   %rbp
  80118c:	48 89 e5             	mov    %rsp,%rbp
  80118f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801196:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80119d:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011a3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8011aa:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011b1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011b8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011bf:	84 c0                	test   %al,%al
  8011c1:	74 20                	je     8011e3 <snprintf+0x58>
  8011c3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011c7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011cb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011cf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011d3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011d7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011db:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011df:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011e3:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011ea:	00 00 00 
  8011ed:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011f4:	00 00 00 
  8011f7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011fb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801202:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801209:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801210:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801217:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80121e:	48 8b 0a             	mov    (%rdx),%rcx
  801221:	48 89 08             	mov    %rcx,(%rax)
  801224:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801228:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80122c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801230:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801234:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80123b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801242:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801248:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80124f:	48 89 c7             	mov    %rax,%rdi
  801252:	48 b8 ee 10 80 00 00 	movabs $0x8010ee,%rax
  801259:	00 00 00 
  80125c:	ff d0                	callq  *%rax
  80125e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801264:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80126a:	c9                   	leaveq 
  80126b:	c3                   	retq   

000000000080126c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80126c:	55                   	push   %rbp
  80126d:	48 89 e5             	mov    %rsp,%rbp
  801270:	48 83 ec 18          	sub    $0x18,%rsp
  801274:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801278:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80127f:	eb 09                	jmp    80128a <strlen+0x1e>
		n++;
  801281:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801285:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80128a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128e:	0f b6 00             	movzbl (%rax),%eax
  801291:	84 c0                	test   %al,%al
  801293:	75 ec                	jne    801281 <strlen+0x15>
		n++;
	return n;
  801295:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801298:	c9                   	leaveq 
  801299:	c3                   	retq   

000000000080129a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80129a:	55                   	push   %rbp
  80129b:	48 89 e5             	mov    %rsp,%rbp
  80129e:	48 83 ec 20          	sub    $0x20,%rsp
  8012a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012b1:	eb 0e                	jmp    8012c1 <strnlen+0x27>
		n++;
  8012b3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012b7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012bc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012c1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012c6:	74 0b                	je     8012d3 <strnlen+0x39>
  8012c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cc:	0f b6 00             	movzbl (%rax),%eax
  8012cf:	84 c0                	test   %al,%al
  8012d1:	75 e0                	jne    8012b3 <strnlen+0x19>
		n++;
	return n;
  8012d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012d6:	c9                   	leaveq 
  8012d7:	c3                   	retq   

00000000008012d8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012d8:	55                   	push   %rbp
  8012d9:	48 89 e5             	mov    %rsp,%rbp
  8012dc:	48 83 ec 20          	sub    $0x20,%rsp
  8012e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012f0:	90                   	nop
  8012f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012f9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012fd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801301:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801305:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801309:	0f b6 12             	movzbl (%rdx),%edx
  80130c:	88 10                	mov    %dl,(%rax)
  80130e:	0f b6 00             	movzbl (%rax),%eax
  801311:	84 c0                	test   %al,%al
  801313:	75 dc                	jne    8012f1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801315:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801319:	c9                   	leaveq 
  80131a:	c3                   	retq   

000000000080131b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80131b:	55                   	push   %rbp
  80131c:	48 89 e5             	mov    %rsp,%rbp
  80131f:	48 83 ec 20          	sub    $0x20,%rsp
  801323:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801327:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80132b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132f:	48 89 c7             	mov    %rax,%rdi
  801332:	48 b8 6c 12 80 00 00 	movabs $0x80126c,%rax
  801339:	00 00 00 
  80133c:	ff d0                	callq  *%rax
  80133e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801341:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801344:	48 63 d0             	movslq %eax,%rdx
  801347:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134b:	48 01 c2             	add    %rax,%rdx
  80134e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801352:	48 89 c6             	mov    %rax,%rsi
  801355:	48 89 d7             	mov    %rdx,%rdi
  801358:	48 b8 d8 12 80 00 00 	movabs $0x8012d8,%rax
  80135f:	00 00 00 
  801362:	ff d0                	callq  *%rax
	return dst;
  801364:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801368:	c9                   	leaveq 
  801369:	c3                   	retq   

000000000080136a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80136a:	55                   	push   %rbp
  80136b:	48 89 e5             	mov    %rsp,%rbp
  80136e:	48 83 ec 28          	sub    $0x28,%rsp
  801372:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801376:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80137a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80137e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801382:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801386:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80138d:	00 
  80138e:	eb 2a                	jmp    8013ba <strncpy+0x50>
		*dst++ = *src;
  801390:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801394:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801398:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80139c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013a0:	0f b6 12             	movzbl (%rdx),%edx
  8013a3:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013a9:	0f b6 00             	movzbl (%rax),%eax
  8013ac:	84 c0                	test   %al,%al
  8013ae:	74 05                	je     8013b5 <strncpy+0x4b>
			src++;
  8013b0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013be:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013c2:	72 cc                	jb     801390 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013c8:	c9                   	leaveq 
  8013c9:	c3                   	retq   

00000000008013ca <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013ca:	55                   	push   %rbp
  8013cb:	48 89 e5             	mov    %rsp,%rbp
  8013ce:	48 83 ec 28          	sub    $0x28,%rsp
  8013d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013e6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013eb:	74 3d                	je     80142a <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8013ed:	eb 1d                	jmp    80140c <strlcpy+0x42>
			*dst++ = *src++;
  8013ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013f7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013fb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013ff:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801403:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801407:	0f b6 12             	movzbl (%rdx),%edx
  80140a:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80140c:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801411:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801416:	74 0b                	je     801423 <strlcpy+0x59>
  801418:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80141c:	0f b6 00             	movzbl (%rax),%eax
  80141f:	84 c0                	test   %al,%al
  801421:	75 cc                	jne    8013ef <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801423:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801427:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80142a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80142e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801432:	48 29 c2             	sub    %rax,%rdx
  801435:	48 89 d0             	mov    %rdx,%rax
}
  801438:	c9                   	leaveq 
  801439:	c3                   	retq   

000000000080143a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80143a:	55                   	push   %rbp
  80143b:	48 89 e5             	mov    %rsp,%rbp
  80143e:	48 83 ec 10          	sub    $0x10,%rsp
  801442:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801446:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80144a:	eb 0a                	jmp    801456 <strcmp+0x1c>
		p++, q++;
  80144c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801451:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801456:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145a:	0f b6 00             	movzbl (%rax),%eax
  80145d:	84 c0                	test   %al,%al
  80145f:	74 12                	je     801473 <strcmp+0x39>
  801461:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801465:	0f b6 10             	movzbl (%rax),%edx
  801468:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146c:	0f b6 00             	movzbl (%rax),%eax
  80146f:	38 c2                	cmp    %al,%dl
  801471:	74 d9                	je     80144c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801473:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801477:	0f b6 00             	movzbl (%rax),%eax
  80147a:	0f b6 d0             	movzbl %al,%edx
  80147d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801481:	0f b6 00             	movzbl (%rax),%eax
  801484:	0f b6 c0             	movzbl %al,%eax
  801487:	29 c2                	sub    %eax,%edx
  801489:	89 d0                	mov    %edx,%eax
}
  80148b:	c9                   	leaveq 
  80148c:	c3                   	retq   

000000000080148d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80148d:	55                   	push   %rbp
  80148e:	48 89 e5             	mov    %rsp,%rbp
  801491:	48 83 ec 18          	sub    $0x18,%rsp
  801495:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801499:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80149d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014a1:	eb 0f                	jmp    8014b2 <strncmp+0x25>
		n--, p++, q++;
  8014a3:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014a8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014ad:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014b2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014b7:	74 1d                	je     8014d6 <strncmp+0x49>
  8014b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bd:	0f b6 00             	movzbl (%rax),%eax
  8014c0:	84 c0                	test   %al,%al
  8014c2:	74 12                	je     8014d6 <strncmp+0x49>
  8014c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c8:	0f b6 10             	movzbl (%rax),%edx
  8014cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cf:	0f b6 00             	movzbl (%rax),%eax
  8014d2:	38 c2                	cmp    %al,%dl
  8014d4:	74 cd                	je     8014a3 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014d6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014db:	75 07                	jne    8014e4 <strncmp+0x57>
		return 0;
  8014dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e2:	eb 18                	jmp    8014fc <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e8:	0f b6 00             	movzbl (%rax),%eax
  8014eb:	0f b6 d0             	movzbl %al,%edx
  8014ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f2:	0f b6 00             	movzbl (%rax),%eax
  8014f5:	0f b6 c0             	movzbl %al,%eax
  8014f8:	29 c2                	sub    %eax,%edx
  8014fa:	89 d0                	mov    %edx,%eax
}
  8014fc:	c9                   	leaveq 
  8014fd:	c3                   	retq   

00000000008014fe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014fe:	55                   	push   %rbp
  8014ff:	48 89 e5             	mov    %rsp,%rbp
  801502:	48 83 ec 10          	sub    $0x10,%rsp
  801506:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80150a:	89 f0                	mov    %esi,%eax
  80150c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80150f:	eb 17                	jmp    801528 <strchr+0x2a>
		if (*s == c)
  801511:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801515:	0f b6 00             	movzbl (%rax),%eax
  801518:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80151b:	75 06                	jne    801523 <strchr+0x25>
			return (char *) s;
  80151d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801521:	eb 15                	jmp    801538 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801523:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801528:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152c:	0f b6 00             	movzbl (%rax),%eax
  80152f:	84 c0                	test   %al,%al
  801531:	75 de                	jne    801511 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801533:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801538:	c9                   	leaveq 
  801539:	c3                   	retq   

000000000080153a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80153a:	55                   	push   %rbp
  80153b:	48 89 e5             	mov    %rsp,%rbp
  80153e:	48 83 ec 10          	sub    $0x10,%rsp
  801542:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801546:	89 f0                	mov    %esi,%eax
  801548:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80154b:	eb 11                	jmp    80155e <strfind+0x24>
		if (*s == c)
  80154d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801551:	0f b6 00             	movzbl (%rax),%eax
  801554:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801557:	74 12                	je     80156b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801559:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80155e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801562:	0f b6 00             	movzbl (%rax),%eax
  801565:	84 c0                	test   %al,%al
  801567:	75 e4                	jne    80154d <strfind+0x13>
  801569:	eb 01                	jmp    80156c <strfind+0x32>
		if (*s == c)
			break;
  80156b:	90                   	nop
	return (char *) s;
  80156c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801570:	c9                   	leaveq 
  801571:	c3                   	retq   

0000000000801572 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801572:	55                   	push   %rbp
  801573:	48 89 e5             	mov    %rsp,%rbp
  801576:	48 83 ec 18          	sub    $0x18,%rsp
  80157a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80157e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801581:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801585:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80158a:	75 06                	jne    801592 <memset+0x20>
		return v;
  80158c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801590:	eb 69                	jmp    8015fb <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801592:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801596:	83 e0 03             	and    $0x3,%eax
  801599:	48 85 c0             	test   %rax,%rax
  80159c:	75 48                	jne    8015e6 <memset+0x74>
  80159e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a2:	83 e0 03             	and    $0x3,%eax
  8015a5:	48 85 c0             	test   %rax,%rax
  8015a8:	75 3c                	jne    8015e6 <memset+0x74>
		c &= 0xFF;
  8015aa:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015b4:	c1 e0 18             	shl    $0x18,%eax
  8015b7:	89 c2                	mov    %eax,%edx
  8015b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015bc:	c1 e0 10             	shl    $0x10,%eax
  8015bf:	09 c2                	or     %eax,%edx
  8015c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c4:	c1 e0 08             	shl    $0x8,%eax
  8015c7:	09 d0                	or     %edx,%eax
  8015c9:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d0:	48 c1 e8 02          	shr    $0x2,%rax
  8015d4:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015de:	48 89 d7             	mov    %rdx,%rdi
  8015e1:	fc                   	cld    
  8015e2:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015e4:	eb 11                	jmp    8015f7 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015e6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ed:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015f1:	48 89 d7             	mov    %rdx,%rdi
  8015f4:	fc                   	cld    
  8015f5:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8015f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015fb:	c9                   	leaveq 
  8015fc:	c3                   	retq   

00000000008015fd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015fd:	55                   	push   %rbp
  8015fe:	48 89 e5             	mov    %rsp,%rbp
  801601:	48 83 ec 28          	sub    $0x28,%rsp
  801605:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801609:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80160d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801611:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801615:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801621:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801625:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801629:	0f 83 88 00 00 00    	jae    8016b7 <memmove+0xba>
  80162f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801633:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801637:	48 01 d0             	add    %rdx,%rax
  80163a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80163e:	76 77                	jbe    8016b7 <memmove+0xba>
		s += n;
  801640:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801644:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801648:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801654:	83 e0 03             	and    $0x3,%eax
  801657:	48 85 c0             	test   %rax,%rax
  80165a:	75 3b                	jne    801697 <memmove+0x9a>
  80165c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801660:	83 e0 03             	and    $0x3,%eax
  801663:	48 85 c0             	test   %rax,%rax
  801666:	75 2f                	jne    801697 <memmove+0x9a>
  801668:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166c:	83 e0 03             	and    $0x3,%eax
  80166f:	48 85 c0             	test   %rax,%rax
  801672:	75 23                	jne    801697 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801674:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801678:	48 83 e8 04          	sub    $0x4,%rax
  80167c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801680:	48 83 ea 04          	sub    $0x4,%rdx
  801684:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801688:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80168c:	48 89 c7             	mov    %rax,%rdi
  80168f:	48 89 d6             	mov    %rdx,%rsi
  801692:	fd                   	std    
  801693:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801695:	eb 1d                	jmp    8016b4 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80169f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ab:	48 89 d7             	mov    %rdx,%rdi
  8016ae:	48 89 c1             	mov    %rax,%rcx
  8016b1:	fd                   	std    
  8016b2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016b4:	fc                   	cld    
  8016b5:	eb 57                	jmp    80170e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016bb:	83 e0 03             	and    $0x3,%eax
  8016be:	48 85 c0             	test   %rax,%rax
  8016c1:	75 36                	jne    8016f9 <memmove+0xfc>
  8016c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c7:	83 e0 03             	and    $0x3,%eax
  8016ca:	48 85 c0             	test   %rax,%rax
  8016cd:	75 2a                	jne    8016f9 <memmove+0xfc>
  8016cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d3:	83 e0 03             	and    $0x3,%eax
  8016d6:	48 85 c0             	test   %rax,%rax
  8016d9:	75 1e                	jne    8016f9 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016df:	48 c1 e8 02          	shr    $0x2,%rax
  8016e3:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016ee:	48 89 c7             	mov    %rax,%rdi
  8016f1:	48 89 d6             	mov    %rdx,%rsi
  8016f4:	fc                   	cld    
  8016f5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016f7:	eb 15                	jmp    80170e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801701:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801705:	48 89 c7             	mov    %rax,%rdi
  801708:	48 89 d6             	mov    %rdx,%rsi
  80170b:	fc                   	cld    
  80170c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80170e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801712:	c9                   	leaveq 
  801713:	c3                   	retq   

0000000000801714 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801714:	55                   	push   %rbp
  801715:	48 89 e5             	mov    %rsp,%rbp
  801718:	48 83 ec 18          	sub    $0x18,%rsp
  80171c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801720:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801724:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801728:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80172c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801730:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801734:	48 89 ce             	mov    %rcx,%rsi
  801737:	48 89 c7             	mov    %rax,%rdi
  80173a:	48 b8 fd 15 80 00 00 	movabs $0x8015fd,%rax
  801741:	00 00 00 
  801744:	ff d0                	callq  *%rax
}
  801746:	c9                   	leaveq 
  801747:	c3                   	retq   

0000000000801748 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801748:	55                   	push   %rbp
  801749:	48 89 e5             	mov    %rsp,%rbp
  80174c:	48 83 ec 28          	sub    $0x28,%rsp
  801750:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801754:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801758:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80175c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801760:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801764:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801768:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80176c:	eb 36                	jmp    8017a4 <memcmp+0x5c>
		if (*s1 != *s2)
  80176e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801772:	0f b6 10             	movzbl (%rax),%edx
  801775:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801779:	0f b6 00             	movzbl (%rax),%eax
  80177c:	38 c2                	cmp    %al,%dl
  80177e:	74 1a                	je     80179a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801780:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801784:	0f b6 00             	movzbl (%rax),%eax
  801787:	0f b6 d0             	movzbl %al,%edx
  80178a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80178e:	0f b6 00             	movzbl (%rax),%eax
  801791:	0f b6 c0             	movzbl %al,%eax
  801794:	29 c2                	sub    %eax,%edx
  801796:	89 d0                	mov    %edx,%eax
  801798:	eb 20                	jmp    8017ba <memcmp+0x72>
		s1++, s2++;
  80179a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80179f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017b0:	48 85 c0             	test   %rax,%rax
  8017b3:	75 b9                	jne    80176e <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ba:	c9                   	leaveq 
  8017bb:	c3                   	retq   

00000000008017bc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017bc:	55                   	push   %rbp
  8017bd:	48 89 e5             	mov    %rsp,%rbp
  8017c0:	48 83 ec 28          	sub    $0x28,%rsp
  8017c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017c8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d7:	48 01 d0             	add    %rdx,%rax
  8017da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017de:	eb 19                	jmp    8017f9 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e4:	0f b6 00             	movzbl (%rax),%eax
  8017e7:	0f b6 d0             	movzbl %al,%edx
  8017ea:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017ed:	0f b6 c0             	movzbl %al,%eax
  8017f0:	39 c2                	cmp    %eax,%edx
  8017f2:	74 11                	je     801805 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017f4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017fd:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801801:	72 dd                	jb     8017e0 <memfind+0x24>
  801803:	eb 01                	jmp    801806 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801805:	90                   	nop
	return (void *) s;
  801806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80180a:	c9                   	leaveq 
  80180b:	c3                   	retq   

000000000080180c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80180c:	55                   	push   %rbp
  80180d:	48 89 e5             	mov    %rsp,%rbp
  801810:	48 83 ec 38          	sub    $0x38,%rsp
  801814:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801818:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80181c:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80181f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801826:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80182d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80182e:	eb 05                	jmp    801835 <strtol+0x29>
		s++;
  801830:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801835:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801839:	0f b6 00             	movzbl (%rax),%eax
  80183c:	3c 20                	cmp    $0x20,%al
  80183e:	74 f0                	je     801830 <strtol+0x24>
  801840:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801844:	0f b6 00             	movzbl (%rax),%eax
  801847:	3c 09                	cmp    $0x9,%al
  801849:	74 e5                	je     801830 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80184b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184f:	0f b6 00             	movzbl (%rax),%eax
  801852:	3c 2b                	cmp    $0x2b,%al
  801854:	75 07                	jne    80185d <strtol+0x51>
		s++;
  801856:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80185b:	eb 17                	jmp    801874 <strtol+0x68>
	else if (*s == '-')
  80185d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801861:	0f b6 00             	movzbl (%rax),%eax
  801864:	3c 2d                	cmp    $0x2d,%al
  801866:	75 0c                	jne    801874 <strtol+0x68>
		s++, neg = 1;
  801868:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80186d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801874:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801878:	74 06                	je     801880 <strtol+0x74>
  80187a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80187e:	75 28                	jne    8018a8 <strtol+0x9c>
  801880:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801884:	0f b6 00             	movzbl (%rax),%eax
  801887:	3c 30                	cmp    $0x30,%al
  801889:	75 1d                	jne    8018a8 <strtol+0x9c>
  80188b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188f:	48 83 c0 01          	add    $0x1,%rax
  801893:	0f b6 00             	movzbl (%rax),%eax
  801896:	3c 78                	cmp    $0x78,%al
  801898:	75 0e                	jne    8018a8 <strtol+0x9c>
		s += 2, base = 16;
  80189a:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80189f:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018a6:	eb 2c                	jmp    8018d4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018a8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018ac:	75 19                	jne    8018c7 <strtol+0xbb>
  8018ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b2:	0f b6 00             	movzbl (%rax),%eax
  8018b5:	3c 30                	cmp    $0x30,%al
  8018b7:	75 0e                	jne    8018c7 <strtol+0xbb>
		s++, base = 8;
  8018b9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018be:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018c5:	eb 0d                	jmp    8018d4 <strtol+0xc8>
	else if (base == 0)
  8018c7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018cb:	75 07                	jne    8018d4 <strtol+0xc8>
		base = 10;
  8018cd:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d8:	0f b6 00             	movzbl (%rax),%eax
  8018db:	3c 2f                	cmp    $0x2f,%al
  8018dd:	7e 1d                	jle    8018fc <strtol+0xf0>
  8018df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e3:	0f b6 00             	movzbl (%rax),%eax
  8018e6:	3c 39                	cmp    $0x39,%al
  8018e8:	7f 12                	jg     8018fc <strtol+0xf0>
			dig = *s - '0';
  8018ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ee:	0f b6 00             	movzbl (%rax),%eax
  8018f1:	0f be c0             	movsbl %al,%eax
  8018f4:	83 e8 30             	sub    $0x30,%eax
  8018f7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018fa:	eb 4e                	jmp    80194a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8018fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801900:	0f b6 00             	movzbl (%rax),%eax
  801903:	3c 60                	cmp    $0x60,%al
  801905:	7e 1d                	jle    801924 <strtol+0x118>
  801907:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190b:	0f b6 00             	movzbl (%rax),%eax
  80190e:	3c 7a                	cmp    $0x7a,%al
  801910:	7f 12                	jg     801924 <strtol+0x118>
			dig = *s - 'a' + 10;
  801912:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801916:	0f b6 00             	movzbl (%rax),%eax
  801919:	0f be c0             	movsbl %al,%eax
  80191c:	83 e8 57             	sub    $0x57,%eax
  80191f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801922:	eb 26                	jmp    80194a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801924:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801928:	0f b6 00             	movzbl (%rax),%eax
  80192b:	3c 40                	cmp    $0x40,%al
  80192d:	7e 47                	jle    801976 <strtol+0x16a>
  80192f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801933:	0f b6 00             	movzbl (%rax),%eax
  801936:	3c 5a                	cmp    $0x5a,%al
  801938:	7f 3c                	jg     801976 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80193a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193e:	0f b6 00             	movzbl (%rax),%eax
  801941:	0f be c0             	movsbl %al,%eax
  801944:	83 e8 37             	sub    $0x37,%eax
  801947:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80194a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80194d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801950:	7d 23                	jge    801975 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801952:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801957:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80195a:	48 98                	cltq   
  80195c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801961:	48 89 c2             	mov    %rax,%rdx
  801964:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801967:	48 98                	cltq   
  801969:	48 01 d0             	add    %rdx,%rax
  80196c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801970:	e9 5f ff ff ff       	jmpq   8018d4 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801975:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801976:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80197b:	74 0b                	je     801988 <strtol+0x17c>
		*endptr = (char *) s;
  80197d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801981:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801985:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801988:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80198c:	74 09                	je     801997 <strtol+0x18b>
  80198e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801992:	48 f7 d8             	neg    %rax
  801995:	eb 04                	jmp    80199b <strtol+0x18f>
  801997:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80199b:	c9                   	leaveq 
  80199c:	c3                   	retq   

000000000080199d <strstr>:

char * strstr(const char *in, const char *str)
{
  80199d:	55                   	push   %rbp
  80199e:	48 89 e5             	mov    %rsp,%rbp
  8019a1:	48 83 ec 30          	sub    $0x30,%rsp
  8019a5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019b1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019b5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019b9:	0f b6 00             	movzbl (%rax),%eax
  8019bc:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019bf:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019c3:	75 06                	jne    8019cb <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c9:	eb 6b                	jmp    801a36 <strstr+0x99>

	len = strlen(str);
  8019cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019cf:	48 89 c7             	mov    %rax,%rdi
  8019d2:	48 b8 6c 12 80 00 00 	movabs $0x80126c,%rax
  8019d9:	00 00 00 
  8019dc:	ff d0                	callq  *%rax
  8019de:	48 98                	cltq   
  8019e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019f0:	0f b6 00             	movzbl (%rax),%eax
  8019f3:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8019f6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019fa:	75 07                	jne    801a03 <strstr+0x66>
				return (char *) 0;
  8019fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801a01:	eb 33                	jmp    801a36 <strstr+0x99>
		} while (sc != c);
  801a03:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a07:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a0a:	75 d8                	jne    8019e4 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a0c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a10:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a18:	48 89 ce             	mov    %rcx,%rsi
  801a1b:	48 89 c7             	mov    %rax,%rdi
  801a1e:	48 b8 8d 14 80 00 00 	movabs $0x80148d,%rax
  801a25:	00 00 00 
  801a28:	ff d0                	callq  *%rax
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	75 b6                	jne    8019e4 <strstr+0x47>

	return (char *) (in - 1);
  801a2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a32:	48 83 e8 01          	sub    $0x1,%rax
}
  801a36:	c9                   	leaveq 
  801a37:	c3                   	retq   
