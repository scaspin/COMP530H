
obj/user/faultnostack:     file format elf64-x86-64


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
  80003c:	e8 3a 00 00 00       	callq  80007b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800052:	48 be 29 05 80 00 00 	movabs $0x800529,%rsi
  800059:	00 00 00 
  80005c:	bf 00 00 00 00       	mov    $0x0,%edi
  800061:	48 b8 40 04 80 00 00 	movabs $0x800440,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
	*(int*)0 = 0;
  80006d:	b8 00 00 00 00       	mov    $0x0,%eax
  800072:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  800078:	90                   	nop
  800079:	c9                   	leaveq 
  80007a:	c3                   	retq   

000000000080007b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007b:	55                   	push   %rbp
  80007c:	48 89 e5             	mov    %rsp,%rbp
  80007f:	48 83 ec 10          	sub    $0x10,%rsp
  800083:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800086:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  80008a:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  800091:	00 00 00 
  800094:	ff d0                	callq  *%rax
  800096:	25 ff 03 00 00       	and    $0x3ff,%eax
  80009b:	48 63 d0             	movslq %eax,%rdx
  80009e:	48 89 d0             	mov    %rdx,%rax
  8000a1:	48 c1 e0 03          	shl    $0x3,%rax
  8000a5:	48 01 d0             	add    %rdx,%rax
  8000a8:	48 c1 e0 05          	shl    $0x5,%rax
  8000ac:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000b3:	00 00 00 
  8000b6:	48 01 c2             	add    %rax,%rdx
  8000b9:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000c0:	00 00 00 
  8000c3:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000ca:	7e 14                	jle    8000e0 <libmain+0x65>
		binaryname = argv[0];
  8000cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000d0:	48 8b 10             	mov    (%rax),%rdx
  8000d3:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000da:	00 00 00 
  8000dd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000e7:	48 89 d6             	mov    %rdx,%rsi
  8000ea:	89 c7                	mov    %eax,%edi
  8000ec:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000f8:	48 b8 07 01 80 00 00 	movabs $0x800107,%rax
  8000ff:	00 00 00 
  800102:	ff d0                	callq  *%rax
}
  800104:	90                   	nop
  800105:	c9                   	leaveq 
  800106:	c3                   	retq   

0000000000800107 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800107:	55                   	push   %rbp
  800108:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80010b:	bf 00 00 00 00       	mov    $0x0,%edi
  800110:	48 b8 36 02 80 00 00 	movabs $0x800236,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
}
  80011c:	90                   	nop
  80011d:	5d                   	pop    %rbp
  80011e:	c3                   	retq   

000000000080011f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80011f:	55                   	push   %rbp
  800120:	48 89 e5             	mov    %rsp,%rbp
  800123:	53                   	push   %rbx
  800124:	48 83 ec 48          	sub    $0x48,%rsp
  800128:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80012b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80012e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800132:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800136:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80013a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80013e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800141:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800145:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800149:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80014d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800151:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800155:	4c 89 c3             	mov    %r8,%rbx
  800158:	cd 30                	int    $0x30
  80015a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80015e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800162:	74 3e                	je     8001a2 <syscall+0x83>
  800164:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800169:	7e 37                	jle    8001a2 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80016b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80016f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800172:	49 89 d0             	mov    %rdx,%r8
  800175:	89 c1                	mov    %eax,%ecx
  800177:	48 ba ca 1b 80 00 00 	movabs $0x801bca,%rdx
  80017e:	00 00 00 
  800181:	be 23 00 00 00       	mov    $0x23,%esi
  800186:	48 bf e7 1b 80 00 00 	movabs $0x801be7,%rdi
  80018d:	00 00 00 
  800190:	b8 00 00 00 00       	mov    $0x0,%eax
  800195:	49 b9 ad 05 80 00 00 	movabs $0x8005ad,%r9
  80019c:	00 00 00 
  80019f:	41 ff d1             	callq  *%r9

	return ret;
  8001a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001a6:	48 83 c4 48          	add    $0x48,%rsp
  8001aa:	5b                   	pop    %rbx
  8001ab:	5d                   	pop    %rbp
  8001ac:	c3                   	retq   

00000000008001ad <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001ad:	55                   	push   %rbp
  8001ae:	48 89 e5             	mov    %rsp,%rbp
  8001b1:	48 83 ec 10          	sub    $0x10,%rsp
  8001b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c5:	48 83 ec 08          	sub    $0x8,%rsp
  8001c9:	6a 00                	pushq  $0x0
  8001cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001d7:	48 89 d1             	mov    %rdx,%rcx
  8001da:	48 89 c2             	mov    %rax,%rdx
  8001dd:	be 00 00 00 00       	mov    $0x0,%esi
  8001e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e7:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8001ee:	00 00 00 
  8001f1:	ff d0                	callq  *%rax
  8001f3:	48 83 c4 10          	add    $0x10,%rsp
}
  8001f7:	90                   	nop
  8001f8:	c9                   	leaveq 
  8001f9:	c3                   	retq   

00000000008001fa <sys_cgetc>:

int
sys_cgetc(void)
{
  8001fa:	55                   	push   %rbp
  8001fb:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001fe:	48 83 ec 08          	sub    $0x8,%rsp
  800202:	6a 00                	pushq  $0x0
  800204:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80020a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800210:	b9 00 00 00 00       	mov    $0x0,%ecx
  800215:	ba 00 00 00 00       	mov    $0x0,%edx
  80021a:	be 00 00 00 00       	mov    $0x0,%esi
  80021f:	bf 01 00 00 00       	mov    $0x1,%edi
  800224:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  80022b:	00 00 00 
  80022e:	ff d0                	callq  *%rax
  800230:	48 83 c4 10          	add    $0x10,%rsp
}
  800234:	c9                   	leaveq 
  800235:	c3                   	retq   

0000000000800236 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800236:	55                   	push   %rbp
  800237:	48 89 e5             	mov    %rsp,%rbp
  80023a:	48 83 ec 10          	sub    $0x10,%rsp
  80023e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800241:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800244:	48 98                	cltq   
  800246:	48 83 ec 08          	sub    $0x8,%rsp
  80024a:	6a 00                	pushq  $0x0
  80024c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800252:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800258:	b9 00 00 00 00       	mov    $0x0,%ecx
  80025d:	48 89 c2             	mov    %rax,%rdx
  800260:	be 01 00 00 00       	mov    $0x1,%esi
  800265:	bf 03 00 00 00       	mov    $0x3,%edi
  80026a:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  800271:	00 00 00 
  800274:	ff d0                	callq  *%rax
  800276:	48 83 c4 10          	add    $0x10,%rsp
}
  80027a:	c9                   	leaveq 
  80027b:	c3                   	retq   

000000000080027c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80027c:	55                   	push   %rbp
  80027d:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800280:	48 83 ec 08          	sub    $0x8,%rsp
  800284:	6a 00                	pushq  $0x0
  800286:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80028c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800292:	b9 00 00 00 00       	mov    $0x0,%ecx
  800297:	ba 00 00 00 00       	mov    $0x0,%edx
  80029c:	be 00 00 00 00       	mov    $0x0,%esi
  8002a1:	bf 02 00 00 00       	mov    $0x2,%edi
  8002a6:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8002ad:	00 00 00 
  8002b0:	ff d0                	callq  *%rax
  8002b2:	48 83 c4 10          	add    $0x10,%rsp
}
  8002b6:	c9                   	leaveq 
  8002b7:	c3                   	retq   

00000000008002b8 <sys_yield>:

void
sys_yield(void)
{
  8002b8:	55                   	push   %rbp
  8002b9:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002bc:	48 83 ec 08          	sub    $0x8,%rsp
  8002c0:	6a 00                	pushq  $0x0
  8002c2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d8:	be 00 00 00 00       	mov    $0x0,%esi
  8002dd:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002e2:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8002e9:	00 00 00 
  8002ec:	ff d0                	callq  *%rax
  8002ee:	48 83 c4 10          	add    $0x10,%rsp
}
  8002f2:	90                   	nop
  8002f3:	c9                   	leaveq 
  8002f4:	c3                   	retq   

00000000008002f5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002f5:	55                   	push   %rbp
  8002f6:	48 89 e5             	mov    %rsp,%rbp
  8002f9:	48 83 ec 10          	sub    $0x10,%rsp
  8002fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800300:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800304:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800307:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80030a:	48 63 c8             	movslq %eax,%rcx
  80030d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800311:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800314:	48 98                	cltq   
  800316:	48 83 ec 08          	sub    $0x8,%rsp
  80031a:	6a 00                	pushq  $0x0
  80031c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800322:	49 89 c8             	mov    %rcx,%r8
  800325:	48 89 d1             	mov    %rdx,%rcx
  800328:	48 89 c2             	mov    %rax,%rdx
  80032b:	be 01 00 00 00       	mov    $0x1,%esi
  800330:	bf 04 00 00 00       	mov    $0x4,%edi
  800335:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	callq  *%rax
  800341:	48 83 c4 10          	add    $0x10,%rsp
}
  800345:	c9                   	leaveq 
  800346:	c3                   	retq   

0000000000800347 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800347:	55                   	push   %rbp
  800348:	48 89 e5             	mov    %rsp,%rbp
  80034b:	48 83 ec 20          	sub    $0x20,%rsp
  80034f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800352:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800356:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800359:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80035d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800361:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800364:	48 63 c8             	movslq %eax,%rcx
  800367:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80036b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80036e:	48 63 f0             	movslq %eax,%rsi
  800371:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800375:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800378:	48 98                	cltq   
  80037a:	48 83 ec 08          	sub    $0x8,%rsp
  80037e:	51                   	push   %rcx
  80037f:	49 89 f9             	mov    %rdi,%r9
  800382:	49 89 f0             	mov    %rsi,%r8
  800385:	48 89 d1             	mov    %rdx,%rcx
  800388:	48 89 c2             	mov    %rax,%rdx
  80038b:	be 01 00 00 00       	mov    $0x1,%esi
  800390:	bf 05 00 00 00       	mov    $0x5,%edi
  800395:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  80039c:	00 00 00 
  80039f:	ff d0                	callq  *%rax
  8003a1:	48 83 c4 10          	add    $0x10,%rsp
}
  8003a5:	c9                   	leaveq 
  8003a6:	c3                   	retq   

00000000008003a7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003a7:	55                   	push   %rbp
  8003a8:	48 89 e5             	mov    %rsp,%rbp
  8003ab:	48 83 ec 10          	sub    $0x10,%rsp
  8003af:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003bd:	48 98                	cltq   
  8003bf:	48 83 ec 08          	sub    $0x8,%rsp
  8003c3:	6a 00                	pushq  $0x0
  8003c5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003d1:	48 89 d1             	mov    %rdx,%rcx
  8003d4:	48 89 c2             	mov    %rax,%rdx
  8003d7:	be 01 00 00 00       	mov    $0x1,%esi
  8003dc:	bf 06 00 00 00       	mov    $0x6,%edi
  8003e1:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8003e8:	00 00 00 
  8003eb:	ff d0                	callq  *%rax
  8003ed:	48 83 c4 10          	add    $0x10,%rsp
}
  8003f1:	c9                   	leaveq 
  8003f2:	c3                   	retq   

00000000008003f3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003f3:	55                   	push   %rbp
  8003f4:	48 89 e5             	mov    %rsp,%rbp
  8003f7:	48 83 ec 10          	sub    $0x10,%rsp
  8003fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003fe:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800401:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800404:	48 63 d0             	movslq %eax,%rdx
  800407:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80040a:	48 98                	cltq   
  80040c:	48 83 ec 08          	sub    $0x8,%rsp
  800410:	6a 00                	pushq  $0x0
  800412:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800418:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80041e:	48 89 d1             	mov    %rdx,%rcx
  800421:	48 89 c2             	mov    %rax,%rdx
  800424:	be 01 00 00 00       	mov    $0x1,%esi
  800429:	bf 08 00 00 00       	mov    $0x8,%edi
  80042e:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  800435:	00 00 00 
  800438:	ff d0                	callq  *%rax
  80043a:	48 83 c4 10          	add    $0x10,%rsp
}
  80043e:	c9                   	leaveq 
  80043f:	c3                   	retq   

0000000000800440 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800440:	55                   	push   %rbp
  800441:	48 89 e5             	mov    %rsp,%rbp
  800444:	48 83 ec 10          	sub    $0x10,%rsp
  800448:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80044b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80044f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800456:	48 98                	cltq   
  800458:	48 83 ec 08          	sub    $0x8,%rsp
  80045c:	6a 00                	pushq  $0x0
  80045e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800464:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80046a:	48 89 d1             	mov    %rdx,%rcx
  80046d:	48 89 c2             	mov    %rax,%rdx
  800470:	be 01 00 00 00       	mov    $0x1,%esi
  800475:	bf 09 00 00 00       	mov    $0x9,%edi
  80047a:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
  800486:	48 83 c4 10          	add    $0x10,%rsp
}
  80048a:	c9                   	leaveq 
  80048b:	c3                   	retq   

000000000080048c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80048c:	55                   	push   %rbp
  80048d:	48 89 e5             	mov    %rsp,%rbp
  800490:	48 83 ec 20          	sub    $0x20,%rsp
  800494:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800497:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80049b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80049f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004a5:	48 63 f0             	movslq %eax,%rsi
  8004a8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004af:	48 98                	cltq   
  8004b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b5:	48 83 ec 08          	sub    $0x8,%rsp
  8004b9:	6a 00                	pushq  $0x0
  8004bb:	49 89 f1             	mov    %rsi,%r9
  8004be:	49 89 c8             	mov    %rcx,%r8
  8004c1:	48 89 d1             	mov    %rdx,%rcx
  8004c4:	48 89 c2             	mov    %rax,%rdx
  8004c7:	be 00 00 00 00       	mov    $0x0,%esi
  8004cc:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004d1:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8004d8:	00 00 00 
  8004db:	ff d0                	callq  *%rax
  8004dd:	48 83 c4 10          	add    $0x10,%rsp
}
  8004e1:	c9                   	leaveq 
  8004e2:	c3                   	retq   

00000000008004e3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004e3:	55                   	push   %rbp
  8004e4:	48 89 e5             	mov    %rsp,%rbp
  8004e7:	48 83 ec 10          	sub    $0x10,%rsp
  8004eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004f3:	48 83 ec 08          	sub    $0x8,%rsp
  8004f7:	6a 00                	pushq  $0x0
  8004f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800505:	b9 00 00 00 00       	mov    $0x0,%ecx
  80050a:	48 89 c2             	mov    %rax,%rdx
  80050d:	be 01 00 00 00       	mov    $0x1,%esi
  800512:	bf 0c 00 00 00       	mov    $0xc,%edi
  800517:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  80051e:	00 00 00 
  800521:	ff d0                	callq  *%rax
  800523:	48 83 c4 10          	add    $0x10,%rsp
}
  800527:	c9                   	leaveq 
  800528:	c3                   	retq   

0000000000800529 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  800529:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80052c:	48 a1 10 30 80 00 00 	movabs 0x803010,%rax
  800533:	00 00 00 
call *%rax
  800536:	ff d0                	callq  *%rax
	//MAKE STACK CALCS for getting parameters
	//20 = size of stack
	//8 = size of word	

	//(20-3)*8=17*8=136
	movq 136(%rsp), %rax
  800538:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  80053f:	00 
	//(20-1)*8=152
	subq $8, 152(%rsp)
  800540:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  800547:	00 08 
	movq 152(%rsp), %rbx
  800549:	48 8b 9c 24 98 00 00 	mov    0x98(%rsp),%rbx
  800550:	00 
	movq %rax, (%rbx)
  800551:	48 89 03             	mov    %rax,(%rbx)
	addq $16, %rsp
  800554:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
	
    	POPA_
  800558:	4c 8b 3c 24          	mov    (%rsp),%r15
  80055c:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  800561:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  800566:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80056b:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  800570:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  800575:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80057a:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80057f:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  800584:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  800589:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80058e:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  800593:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  800598:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80059d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8005a2:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
	//https://www.felixcloutier.com/x86/POPF:POPFD:POPFQ.html
    	addq $8, %rsp
  8005a6:	48 83 c4 08          	add    $0x8,%rsp
    	popfq	
  8005aa:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    	popq %rsp
  8005ab:	5c                   	pop    %rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    	ret
  8005ac:	c3                   	retq   

00000000008005ad <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005ad:	55                   	push   %rbp
  8005ae:	48 89 e5             	mov    %rsp,%rbp
  8005b1:	53                   	push   %rbx
  8005b2:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005b9:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005c0:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005c6:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8005cd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005d4:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005db:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005e2:	84 c0                	test   %al,%al
  8005e4:	74 23                	je     800609 <_panic+0x5c>
  8005e6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8005ed:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8005f1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8005f5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8005f9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8005fd:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800601:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800605:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800609:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800610:	00 00 00 
  800613:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80061a:	00 00 00 
  80061d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800621:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800628:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80062f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800636:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80063d:	00 00 00 
  800640:	48 8b 18             	mov    (%rax),%rbx
  800643:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  80064a:	00 00 00 
  80064d:	ff d0                	callq  *%rax
  80064f:	89 c6                	mov    %eax,%esi
  800651:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800657:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80065e:	41 89 d0             	mov    %edx,%r8d
  800661:	48 89 c1             	mov    %rax,%rcx
  800664:	48 89 da             	mov    %rbx,%rdx
  800667:	48 bf f8 1b 80 00 00 	movabs $0x801bf8,%rdi
  80066e:	00 00 00 
  800671:	b8 00 00 00 00       	mov    $0x0,%eax
  800676:	49 b9 e7 07 80 00 00 	movabs $0x8007e7,%r9
  80067d:	00 00 00 
  800680:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800683:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80068a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800691:	48 89 d6             	mov    %rdx,%rsi
  800694:	48 89 c7             	mov    %rax,%rdi
  800697:	48 b8 3b 07 80 00 00 	movabs $0x80073b,%rax
  80069e:	00 00 00 
  8006a1:	ff d0                	callq  *%rax
	cprintf("\n");
  8006a3:	48 bf 1b 1c 80 00 00 	movabs $0x801c1b,%rdi
  8006aa:	00 00 00 
  8006ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b2:	48 ba e7 07 80 00 00 	movabs $0x8007e7,%rdx
  8006b9:	00 00 00 
  8006bc:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006be:	cc                   	int3   
  8006bf:	eb fd                	jmp    8006be <_panic+0x111>

00000000008006c1 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8006c1:	55                   	push   %rbp
  8006c2:	48 89 e5             	mov    %rsp,%rbp
  8006c5:	48 83 ec 10          	sub    $0x10,%rsp
  8006c9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8006d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006d4:	8b 00                	mov    (%rax),%eax
  8006d6:	8d 48 01             	lea    0x1(%rax),%ecx
  8006d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006dd:	89 0a                	mov    %ecx,(%rdx)
  8006df:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8006e2:	89 d1                	mov    %edx,%ecx
  8006e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006e8:	48 98                	cltq   
  8006ea:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8006ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f2:	8b 00                	mov    (%rax),%eax
  8006f4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006f9:	75 2c                	jne    800727 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8006fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ff:	8b 00                	mov    (%rax),%eax
  800701:	48 98                	cltq   
  800703:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800707:	48 83 c2 08          	add    $0x8,%rdx
  80070b:	48 89 c6             	mov    %rax,%rsi
  80070e:	48 89 d7             	mov    %rdx,%rdi
  800711:	48 b8 ad 01 80 00 00 	movabs $0x8001ad,%rax
  800718:	00 00 00 
  80071b:	ff d0                	callq  *%rax
        b->idx = 0;
  80071d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800721:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800727:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80072b:	8b 40 04             	mov    0x4(%rax),%eax
  80072e:	8d 50 01             	lea    0x1(%rax),%edx
  800731:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800735:	89 50 04             	mov    %edx,0x4(%rax)
}
  800738:	90                   	nop
  800739:	c9                   	leaveq 
  80073a:	c3                   	retq   

000000000080073b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80073b:	55                   	push   %rbp
  80073c:	48 89 e5             	mov    %rsp,%rbp
  80073f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800746:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80074d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800754:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80075b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800762:	48 8b 0a             	mov    (%rdx),%rcx
  800765:	48 89 08             	mov    %rcx,(%rax)
  800768:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80076c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800770:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800774:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800778:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80077f:	00 00 00 
    b.cnt = 0;
  800782:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800789:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80078c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800793:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80079a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007a1:	48 89 c6             	mov    %rax,%rsi
  8007a4:	48 bf c1 06 80 00 00 	movabs $0x8006c1,%rdi
  8007ab:	00 00 00 
  8007ae:	48 b8 85 0b 80 00 00 	movabs $0x800b85,%rax
  8007b5:	00 00 00 
  8007b8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007ba:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007c0:	48 98                	cltq   
  8007c2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007c9:	48 83 c2 08          	add    $0x8,%rdx
  8007cd:	48 89 c6             	mov    %rax,%rsi
  8007d0:	48 89 d7             	mov    %rdx,%rdi
  8007d3:	48 b8 ad 01 80 00 00 	movabs $0x8001ad,%rax
  8007da:	00 00 00 
  8007dd:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8007df:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8007e5:	c9                   	leaveq 
  8007e6:	c3                   	retq   

00000000008007e7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8007e7:	55                   	push   %rbp
  8007e8:	48 89 e5             	mov    %rsp,%rbp
  8007eb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8007f2:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8007f9:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800800:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800807:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80080e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800815:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80081c:	84 c0                	test   %al,%al
  80081e:	74 20                	je     800840 <cprintf+0x59>
  800820:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800824:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800828:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80082c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800830:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800834:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800838:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80083c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800840:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800847:	00 00 00 
  80084a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800851:	00 00 00 
  800854:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800858:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80085f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800866:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80086d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800874:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80087b:	48 8b 0a             	mov    (%rdx),%rcx
  80087e:	48 89 08             	mov    %rcx,(%rax)
  800881:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800885:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800889:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80088d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800891:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800898:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80089f:	48 89 d6             	mov    %rdx,%rsi
  8008a2:	48 89 c7             	mov    %rax,%rdi
  8008a5:	48 b8 3b 07 80 00 00 	movabs $0x80073b,%rax
  8008ac:	00 00 00 
  8008af:	ff d0                	callq  *%rax
  8008b1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008b7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008bd:	c9                   	leaveq 
  8008be:	c3                   	retq   

00000000008008bf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008bf:	55                   	push   %rbp
  8008c0:	48 89 e5             	mov    %rsp,%rbp
  8008c3:	48 83 ec 30          	sub    $0x30,%rsp
  8008c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8008cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8008cf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008d3:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8008d6:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8008da:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008de:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8008e1:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8008e5:	77 54                	ja     80093b <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008e7:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8008ea:	8d 78 ff             	lea    -0x1(%rax),%edi
  8008ed:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8008f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f9:	48 f7 f6             	div    %rsi
  8008fc:	49 89 c2             	mov    %rax,%r10
  8008ff:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800902:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800905:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800909:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80090d:	41 89 c9             	mov    %ecx,%r9d
  800910:	41 89 f8             	mov    %edi,%r8d
  800913:	89 d1                	mov    %edx,%ecx
  800915:	4c 89 d2             	mov    %r10,%rdx
  800918:	48 89 c7             	mov    %rax,%rdi
  80091b:	48 b8 bf 08 80 00 00 	movabs $0x8008bf,%rax
  800922:	00 00 00 
  800925:	ff d0                	callq  *%rax
  800927:	eb 1c                	jmp    800945 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800929:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80092d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800930:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800934:	48 89 ce             	mov    %rcx,%rsi
  800937:	89 d7                	mov    %edx,%edi
  800939:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80093b:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80093f:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800943:	7f e4                	jg     800929 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800945:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094c:	ba 00 00 00 00       	mov    $0x0,%edx
  800951:	48 f7 f1             	div    %rcx
  800954:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  80095b:	00 00 00 
  80095e:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800962:	0f be d0             	movsbl %al,%edx
  800965:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800969:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80096d:	48 89 ce             	mov    %rcx,%rsi
  800970:	89 d7                	mov    %edx,%edi
  800972:	ff d0                	callq  *%rax
}
  800974:	90                   	nop
  800975:	c9                   	leaveq 
  800976:	c3                   	retq   

0000000000800977 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800977:	55                   	push   %rbp
  800978:	48 89 e5             	mov    %rsp,%rbp
  80097b:	48 83 ec 20          	sub    $0x20,%rsp
  80097f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800983:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800986:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80098a:	7e 4f                	jle    8009db <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80098c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800990:	8b 00                	mov    (%rax),%eax
  800992:	83 f8 30             	cmp    $0x30,%eax
  800995:	73 24                	jae    8009bb <getuint+0x44>
  800997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80099f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a3:	8b 00                	mov    (%rax),%eax
  8009a5:	89 c0                	mov    %eax,%eax
  8009a7:	48 01 d0             	add    %rdx,%rax
  8009aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ae:	8b 12                	mov    (%rdx),%edx
  8009b0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b7:	89 0a                	mov    %ecx,(%rdx)
  8009b9:	eb 14                	jmp    8009cf <getuint+0x58>
  8009bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bf:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009c3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009cf:	48 8b 00             	mov    (%rax),%rax
  8009d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009d6:	e9 9d 00 00 00       	jmpq   800a78 <getuint+0x101>
	else if (lflag)
  8009db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009df:	74 4c                	je     800a2d <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8009e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e5:	8b 00                	mov    (%rax),%eax
  8009e7:	83 f8 30             	cmp    $0x30,%eax
  8009ea:	73 24                	jae    800a10 <getuint+0x99>
  8009ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f8:	8b 00                	mov    (%rax),%eax
  8009fa:	89 c0                	mov    %eax,%eax
  8009fc:	48 01 d0             	add    %rdx,%rax
  8009ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a03:	8b 12                	mov    (%rdx),%edx
  800a05:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a08:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a0c:	89 0a                	mov    %ecx,(%rdx)
  800a0e:	eb 14                	jmp    800a24 <getuint+0xad>
  800a10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a14:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a18:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a1c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a20:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a24:	48 8b 00             	mov    (%rax),%rax
  800a27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a2b:	eb 4b                	jmp    800a78 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800a2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a31:	8b 00                	mov    (%rax),%eax
  800a33:	83 f8 30             	cmp    $0x30,%eax
  800a36:	73 24                	jae    800a5c <getuint+0xe5>
  800a38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a44:	8b 00                	mov    (%rax),%eax
  800a46:	89 c0                	mov    %eax,%eax
  800a48:	48 01 d0             	add    %rdx,%rax
  800a4b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4f:	8b 12                	mov    (%rdx),%edx
  800a51:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a58:	89 0a                	mov    %ecx,(%rdx)
  800a5a:	eb 14                	jmp    800a70 <getuint+0xf9>
  800a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a60:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a64:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a68:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a70:	8b 00                	mov    (%rax),%eax
  800a72:	89 c0                	mov    %eax,%eax
  800a74:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a7c:	c9                   	leaveq 
  800a7d:	c3                   	retq   

0000000000800a7e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a7e:	55                   	push   %rbp
  800a7f:	48 89 e5             	mov    %rsp,%rbp
  800a82:	48 83 ec 20          	sub    $0x20,%rsp
  800a86:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a8a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a8d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a91:	7e 4f                	jle    800ae2 <getint+0x64>
		x=va_arg(*ap, long long);
  800a93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a97:	8b 00                	mov    (%rax),%eax
  800a99:	83 f8 30             	cmp    $0x30,%eax
  800a9c:	73 24                	jae    800ac2 <getint+0x44>
  800a9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800aa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aaa:	8b 00                	mov    (%rax),%eax
  800aac:	89 c0                	mov    %eax,%eax
  800aae:	48 01 d0             	add    %rdx,%rax
  800ab1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab5:	8b 12                	mov    (%rdx),%edx
  800ab7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abe:	89 0a                	mov    %ecx,(%rdx)
  800ac0:	eb 14                	jmp    800ad6 <getint+0x58>
  800ac2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac6:	48 8b 40 08          	mov    0x8(%rax),%rax
  800aca:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ace:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ad6:	48 8b 00             	mov    (%rax),%rax
  800ad9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800add:	e9 9d 00 00 00       	jmpq   800b7f <getint+0x101>
	else if (lflag)
  800ae2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800ae6:	74 4c                	je     800b34 <getint+0xb6>
		x=va_arg(*ap, long);
  800ae8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aec:	8b 00                	mov    (%rax),%eax
  800aee:	83 f8 30             	cmp    $0x30,%eax
  800af1:	73 24                	jae    800b17 <getint+0x99>
  800af3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800afb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aff:	8b 00                	mov    (%rax),%eax
  800b01:	89 c0                	mov    %eax,%eax
  800b03:	48 01 d0             	add    %rdx,%rax
  800b06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b0a:	8b 12                	mov    (%rdx),%edx
  800b0c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b13:	89 0a                	mov    %ecx,(%rdx)
  800b15:	eb 14                	jmp    800b2b <getint+0xad>
  800b17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b1f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b23:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b27:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b2b:	48 8b 00             	mov    (%rax),%rax
  800b2e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b32:	eb 4b                	jmp    800b7f <getint+0x101>
	else
		x=va_arg(*ap, int);
  800b34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b38:	8b 00                	mov    (%rax),%eax
  800b3a:	83 f8 30             	cmp    $0x30,%eax
  800b3d:	73 24                	jae    800b63 <getint+0xe5>
  800b3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b43:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4b:	8b 00                	mov    (%rax),%eax
  800b4d:	89 c0                	mov    %eax,%eax
  800b4f:	48 01 d0             	add    %rdx,%rax
  800b52:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b56:	8b 12                	mov    (%rdx),%edx
  800b58:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b5b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5f:	89 0a                	mov    %ecx,(%rdx)
  800b61:	eb 14                	jmp    800b77 <getint+0xf9>
  800b63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b67:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b6b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b73:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b77:	8b 00                	mov    (%rax),%eax
  800b79:	48 98                	cltq   
  800b7b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b83:	c9                   	leaveq 
  800b84:	c3                   	retq   

0000000000800b85 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b85:	55                   	push   %rbp
  800b86:	48 89 e5             	mov    %rsp,%rbp
  800b89:	41 54                	push   %r12
  800b8b:	53                   	push   %rbx
  800b8c:	48 83 ec 60          	sub    $0x60,%rsp
  800b90:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b94:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b98:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b9c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ba0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ba4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ba8:	48 8b 0a             	mov    (%rdx),%rcx
  800bab:	48 89 08             	mov    %rcx,(%rax)
  800bae:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bb2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bb6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bba:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bbe:	eb 17                	jmp    800bd7 <vprintfmt+0x52>
			if (ch == '\0')
  800bc0:	85 db                	test   %ebx,%ebx
  800bc2:	0f 84 b9 04 00 00    	je     801081 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800bc8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bcc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd0:	48 89 d6             	mov    %rdx,%rsi
  800bd3:	89 df                	mov    %ebx,%edi
  800bd5:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bdb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800bdf:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800be3:	0f b6 00             	movzbl (%rax),%eax
  800be6:	0f b6 d8             	movzbl %al,%ebx
  800be9:	83 fb 25             	cmp    $0x25,%ebx
  800bec:	75 d2                	jne    800bc0 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bee:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800bf2:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800bf9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c00:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c07:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c0e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c12:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c16:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c1a:	0f b6 00             	movzbl (%rax),%eax
  800c1d:	0f b6 d8             	movzbl %al,%ebx
  800c20:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c23:	83 f8 55             	cmp    $0x55,%eax
  800c26:	0f 87 22 04 00 00    	ja     80104e <vprintfmt+0x4c9>
  800c2c:	89 c0                	mov    %eax,%eax
  800c2e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c35:	00 
  800c36:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  800c3d:	00 00 00 
  800c40:	48 01 d0             	add    %rdx,%rax
  800c43:	48 8b 00             	mov    (%rax),%rax
  800c46:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800c48:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c4c:	eb c0                	jmp    800c0e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c4e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c52:	eb ba                	jmp    800c0e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c54:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c5b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c5e:	89 d0                	mov    %edx,%eax
  800c60:	c1 e0 02             	shl    $0x2,%eax
  800c63:	01 d0                	add    %edx,%eax
  800c65:	01 c0                	add    %eax,%eax
  800c67:	01 d8                	add    %ebx,%eax
  800c69:	83 e8 30             	sub    $0x30,%eax
  800c6c:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c6f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c73:	0f b6 00             	movzbl (%rax),%eax
  800c76:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c79:	83 fb 2f             	cmp    $0x2f,%ebx
  800c7c:	7e 60                	jle    800cde <vprintfmt+0x159>
  800c7e:	83 fb 39             	cmp    $0x39,%ebx
  800c81:	7f 5b                	jg     800cde <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c83:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c88:	eb d1                	jmp    800c5b <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800c8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8d:	83 f8 30             	cmp    $0x30,%eax
  800c90:	73 17                	jae    800ca9 <vprintfmt+0x124>
  800c92:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c96:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c99:	89 d2                	mov    %edx,%edx
  800c9b:	48 01 d0             	add    %rdx,%rax
  800c9e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca1:	83 c2 08             	add    $0x8,%edx
  800ca4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ca7:	eb 0c                	jmp    800cb5 <vprintfmt+0x130>
  800ca9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cad:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cb1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cb5:	8b 00                	mov    (%rax),%eax
  800cb7:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800cba:	eb 23                	jmp    800cdf <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800cbc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cc0:	0f 89 48 ff ff ff    	jns    800c0e <vprintfmt+0x89>
				width = 0;
  800cc6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ccd:	e9 3c ff ff ff       	jmpq   800c0e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800cd2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800cd9:	e9 30 ff ff ff       	jmpq   800c0e <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cde:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cdf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce3:	0f 89 25 ff ff ff    	jns    800c0e <vprintfmt+0x89>
				width = precision, precision = -1;
  800ce9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cec:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800cef:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800cf6:	e9 13 ff ff ff       	jmpq   800c0e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cfb:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800cff:	e9 0a ff ff ff       	jmpq   800c0e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d04:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d07:	83 f8 30             	cmp    $0x30,%eax
  800d0a:	73 17                	jae    800d23 <vprintfmt+0x19e>
  800d0c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d10:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d13:	89 d2                	mov    %edx,%edx
  800d15:	48 01 d0             	add    %rdx,%rax
  800d18:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d1b:	83 c2 08             	add    $0x8,%edx
  800d1e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d21:	eb 0c                	jmp    800d2f <vprintfmt+0x1aa>
  800d23:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d27:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d2b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d2f:	8b 10                	mov    (%rax),%edx
  800d31:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d39:	48 89 ce             	mov    %rcx,%rsi
  800d3c:	89 d7                	mov    %edx,%edi
  800d3e:	ff d0                	callq  *%rax
			break;
  800d40:	e9 37 03 00 00       	jmpq   80107c <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800d45:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d48:	83 f8 30             	cmp    $0x30,%eax
  800d4b:	73 17                	jae    800d64 <vprintfmt+0x1df>
  800d4d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d51:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d54:	89 d2                	mov    %edx,%edx
  800d56:	48 01 d0             	add    %rdx,%rax
  800d59:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d5c:	83 c2 08             	add    $0x8,%edx
  800d5f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d62:	eb 0c                	jmp    800d70 <vprintfmt+0x1eb>
  800d64:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d68:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d6c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d70:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d72:	85 db                	test   %ebx,%ebx
  800d74:	79 02                	jns    800d78 <vprintfmt+0x1f3>
				err = -err;
  800d76:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d78:	83 fb 15             	cmp    $0x15,%ebx
  800d7b:	7f 16                	jg     800d93 <vprintfmt+0x20e>
  800d7d:	48 b8 c0 1c 80 00 00 	movabs $0x801cc0,%rax
  800d84:	00 00 00 
  800d87:	48 63 d3             	movslq %ebx,%rdx
  800d8a:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d8e:	4d 85 e4             	test   %r12,%r12
  800d91:	75 2e                	jne    800dc1 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800d93:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9b:	89 d9                	mov    %ebx,%ecx
  800d9d:	48 ba 81 1d 80 00 00 	movabs $0x801d81,%rdx
  800da4:	00 00 00 
  800da7:	48 89 c7             	mov    %rax,%rdi
  800daa:	b8 00 00 00 00       	mov    $0x0,%eax
  800daf:	49 b8 8b 10 80 00 00 	movabs $0x80108b,%r8
  800db6:	00 00 00 
  800db9:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dbc:	e9 bb 02 00 00       	jmpq   80107c <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dc1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dc5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc9:	4c 89 e1             	mov    %r12,%rcx
  800dcc:	48 ba 8a 1d 80 00 00 	movabs $0x801d8a,%rdx
  800dd3:	00 00 00 
  800dd6:	48 89 c7             	mov    %rax,%rdi
  800dd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dde:	49 b8 8b 10 80 00 00 	movabs $0x80108b,%r8
  800de5:	00 00 00 
  800de8:	41 ff d0             	callq  *%r8
			break;
  800deb:	e9 8c 02 00 00       	jmpq   80107c <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800df0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800df3:	83 f8 30             	cmp    $0x30,%eax
  800df6:	73 17                	jae    800e0f <vprintfmt+0x28a>
  800df8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dfc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dff:	89 d2                	mov    %edx,%edx
  800e01:	48 01 d0             	add    %rdx,%rax
  800e04:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e07:	83 c2 08             	add    $0x8,%edx
  800e0a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e0d:	eb 0c                	jmp    800e1b <vprintfmt+0x296>
  800e0f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e13:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e17:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e1b:	4c 8b 20             	mov    (%rax),%r12
  800e1e:	4d 85 e4             	test   %r12,%r12
  800e21:	75 0a                	jne    800e2d <vprintfmt+0x2a8>
				p = "(null)";
  800e23:	49 bc 8d 1d 80 00 00 	movabs $0x801d8d,%r12
  800e2a:	00 00 00 
			if (width > 0 && padc != '-')
  800e2d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e31:	7e 78                	jle    800eab <vprintfmt+0x326>
  800e33:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e37:	74 72                	je     800eab <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e39:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e3c:	48 98                	cltq   
  800e3e:	48 89 c6             	mov    %rax,%rsi
  800e41:	4c 89 e7             	mov    %r12,%rdi
  800e44:	48 b8 39 13 80 00 00 	movabs $0x801339,%rax
  800e4b:	00 00 00 
  800e4e:	ff d0                	callq  *%rax
  800e50:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e53:	eb 17                	jmp    800e6c <vprintfmt+0x2e7>
					putch(padc, putdat);
  800e55:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e59:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e61:	48 89 ce             	mov    %rcx,%rsi
  800e64:	89 d7                	mov    %edx,%edi
  800e66:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e68:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e6c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e70:	7f e3                	jg     800e55 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e72:	eb 37                	jmp    800eab <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800e74:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e78:	74 1e                	je     800e98 <vprintfmt+0x313>
  800e7a:	83 fb 1f             	cmp    $0x1f,%ebx
  800e7d:	7e 05                	jle    800e84 <vprintfmt+0x2ff>
  800e7f:	83 fb 7e             	cmp    $0x7e,%ebx
  800e82:	7e 14                	jle    800e98 <vprintfmt+0x313>
					putch('?', putdat);
  800e84:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e8c:	48 89 d6             	mov    %rdx,%rsi
  800e8f:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e94:	ff d0                	callq  *%rax
  800e96:	eb 0f                	jmp    800ea7 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800e98:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea0:	48 89 d6             	mov    %rdx,%rsi
  800ea3:	89 df                	mov    %ebx,%edi
  800ea5:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ea7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eab:	4c 89 e0             	mov    %r12,%rax
  800eae:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800eb2:	0f b6 00             	movzbl (%rax),%eax
  800eb5:	0f be d8             	movsbl %al,%ebx
  800eb8:	85 db                	test   %ebx,%ebx
  800eba:	74 28                	je     800ee4 <vprintfmt+0x35f>
  800ebc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ec0:	78 b2                	js     800e74 <vprintfmt+0x2ef>
  800ec2:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ec6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800eca:	79 a8                	jns    800e74 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ecc:	eb 16                	jmp    800ee4 <vprintfmt+0x35f>
				putch(' ', putdat);
  800ece:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed6:	48 89 d6             	mov    %rdx,%rsi
  800ed9:	bf 20 00 00 00       	mov    $0x20,%edi
  800ede:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ee0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ee4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ee8:	7f e4                	jg     800ece <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800eea:	e9 8d 01 00 00       	jmpq   80107c <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800eef:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ef3:	be 03 00 00 00       	mov    $0x3,%esi
  800ef8:	48 89 c7             	mov    %rax,%rdi
  800efb:	48 b8 7e 0a 80 00 00 	movabs $0x800a7e,%rax
  800f02:	00 00 00 
  800f05:	ff d0                	callq  *%rax
  800f07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0f:	48 85 c0             	test   %rax,%rax
  800f12:	79 1d                	jns    800f31 <vprintfmt+0x3ac>
				putch('-', putdat);
  800f14:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f1c:	48 89 d6             	mov    %rdx,%rsi
  800f1f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f24:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2a:	48 f7 d8             	neg    %rax
  800f2d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f31:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f38:	e9 d2 00 00 00       	jmpq   80100f <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f3d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f41:	be 03 00 00 00       	mov    $0x3,%esi
  800f46:	48 89 c7             	mov    %rax,%rdi
  800f49:	48 b8 77 09 80 00 00 	movabs $0x800977,%rax
  800f50:	00 00 00 
  800f53:	ff d0                	callq  *%rax
  800f55:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f59:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f60:	e9 aa 00 00 00       	jmpq   80100f <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800f65:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f69:	be 03 00 00 00       	mov    $0x3,%esi
  800f6e:	48 89 c7             	mov    %rax,%rdi
  800f71:	48 b8 77 09 80 00 00 	movabs $0x800977,%rax
  800f78:	00 00 00 
  800f7b:	ff d0                	callq  *%rax
  800f7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f81:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f88:	e9 82 00 00 00       	jmpq   80100f <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800f8d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f91:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f95:	48 89 d6             	mov    %rdx,%rsi
  800f98:	bf 30 00 00 00       	mov    $0x30,%edi
  800f9d:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f9f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fa3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fa7:	48 89 d6             	mov    %rdx,%rsi
  800faa:	bf 78 00 00 00       	mov    $0x78,%edi
  800faf:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800fb1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fb4:	83 f8 30             	cmp    $0x30,%eax
  800fb7:	73 17                	jae    800fd0 <vprintfmt+0x44b>
  800fb9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fbd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fc0:	89 d2                	mov    %edx,%edx
  800fc2:	48 01 d0             	add    %rdx,%rax
  800fc5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fc8:	83 c2 08             	add    $0x8,%edx
  800fcb:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fce:	eb 0c                	jmp    800fdc <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800fd0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800fd4:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800fd8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fdc:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fdf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800fe3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800fea:	eb 23                	jmp    80100f <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800fec:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ff0:	be 03 00 00 00       	mov    $0x3,%esi
  800ff5:	48 89 c7             	mov    %rax,%rdi
  800ff8:	48 b8 77 09 80 00 00 	movabs $0x800977,%rax
  800fff:	00 00 00 
  801002:	ff d0                	callq  *%rax
  801004:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801008:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80100f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801014:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801017:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80101a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80101e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801022:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801026:	45 89 c1             	mov    %r8d,%r9d
  801029:	41 89 f8             	mov    %edi,%r8d
  80102c:	48 89 c7             	mov    %rax,%rdi
  80102f:	48 b8 bf 08 80 00 00 	movabs $0x8008bf,%rax
  801036:	00 00 00 
  801039:	ff d0                	callq  *%rax
			break;
  80103b:	eb 3f                	jmp    80107c <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80103d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801041:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801045:	48 89 d6             	mov    %rdx,%rsi
  801048:	89 df                	mov    %ebx,%edi
  80104a:	ff d0                	callq  *%rax
			break;
  80104c:	eb 2e                	jmp    80107c <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80104e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801052:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801056:	48 89 d6             	mov    %rdx,%rsi
  801059:	bf 25 00 00 00       	mov    $0x25,%edi
  80105e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801060:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801065:	eb 05                	jmp    80106c <vprintfmt+0x4e7>
  801067:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80106c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801070:	48 83 e8 01          	sub    $0x1,%rax
  801074:	0f b6 00             	movzbl (%rax),%eax
  801077:	3c 25                	cmp    $0x25,%al
  801079:	75 ec                	jne    801067 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  80107b:	90                   	nop
		}
	}
  80107c:	e9 3d fb ff ff       	jmpq   800bbe <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801081:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801082:	48 83 c4 60          	add    $0x60,%rsp
  801086:	5b                   	pop    %rbx
  801087:	41 5c                	pop    %r12
  801089:	5d                   	pop    %rbp
  80108a:	c3                   	retq   

000000000080108b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80108b:	55                   	push   %rbp
  80108c:	48 89 e5             	mov    %rsp,%rbp
  80108f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801096:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80109d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8010a4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  8010ab:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010b2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010b9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010c0:	84 c0                	test   %al,%al
  8010c2:	74 20                	je     8010e4 <printfmt+0x59>
  8010c4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010c8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010cc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010d0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010d4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010d8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010dc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010e0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8010e4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8010eb:	00 00 00 
  8010ee:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8010f5:	00 00 00 
  8010f8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010fc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801103:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80110a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801111:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801118:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80111f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801126:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80112d:	48 89 c7             	mov    %rax,%rdi
  801130:	48 b8 85 0b 80 00 00 	movabs $0x800b85,%rax
  801137:	00 00 00 
  80113a:	ff d0                	callq  *%rax
	va_end(ap);
}
  80113c:	90                   	nop
  80113d:	c9                   	leaveq 
  80113e:	c3                   	retq   

000000000080113f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80113f:	55                   	push   %rbp
  801140:	48 89 e5             	mov    %rsp,%rbp
  801143:	48 83 ec 10          	sub    $0x10,%rsp
  801147:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80114a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80114e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801152:	8b 40 10             	mov    0x10(%rax),%eax
  801155:	8d 50 01             	lea    0x1(%rax),%edx
  801158:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80115c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80115f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801163:	48 8b 10             	mov    (%rax),%rdx
  801166:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80116a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80116e:	48 39 c2             	cmp    %rax,%rdx
  801171:	73 17                	jae    80118a <sprintputch+0x4b>
		*b->buf++ = ch;
  801173:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801177:	48 8b 00             	mov    (%rax),%rax
  80117a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80117e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801182:	48 89 0a             	mov    %rcx,(%rdx)
  801185:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801188:	88 10                	mov    %dl,(%rax)
}
  80118a:	90                   	nop
  80118b:	c9                   	leaveq 
  80118c:	c3                   	retq   

000000000080118d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80118d:	55                   	push   %rbp
  80118e:	48 89 e5             	mov    %rsp,%rbp
  801191:	48 83 ec 50          	sub    $0x50,%rsp
  801195:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801199:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80119c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8011a0:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8011a4:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8011a8:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8011ac:	48 8b 0a             	mov    (%rdx),%rcx
  8011af:	48 89 08             	mov    %rcx,(%rax)
  8011b2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011b6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011ba:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011be:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011c2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011c6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8011ca:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8011cd:	48 98                	cltq   
  8011cf:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011d3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011d7:	48 01 d0             	add    %rdx,%rax
  8011da:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8011de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8011e5:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8011ea:	74 06                	je     8011f2 <vsnprintf+0x65>
  8011ec:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8011f0:	7f 07                	jg     8011f9 <vsnprintf+0x6c>
		return -E_INVAL;
  8011f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f7:	eb 2f                	jmp    801228 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8011f9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8011fd:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801201:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801205:	48 89 c6             	mov    %rax,%rsi
  801208:	48 bf 3f 11 80 00 00 	movabs $0x80113f,%rdi
  80120f:	00 00 00 
  801212:	48 b8 85 0b 80 00 00 	movabs $0x800b85,%rax
  801219:	00 00 00 
  80121c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80121e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801222:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801225:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801228:	c9                   	leaveq 
  801229:	c3                   	retq   

000000000080122a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80122a:	55                   	push   %rbp
  80122b:	48 89 e5             	mov    %rsp,%rbp
  80122e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801235:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80123c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801242:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  801249:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801250:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801257:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80125e:	84 c0                	test   %al,%al
  801260:	74 20                	je     801282 <snprintf+0x58>
  801262:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801266:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80126a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80126e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801272:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801276:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80127a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80127e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801282:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801289:	00 00 00 
  80128c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801293:	00 00 00 
  801296:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80129a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8012a1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012a8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8012af:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8012b6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8012bd:	48 8b 0a             	mov    (%rdx),%rcx
  8012c0:	48 89 08             	mov    %rcx,(%rax)
  8012c3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8012c7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8012cb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8012cf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8012d3:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8012da:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8012e1:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8012e7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8012ee:	48 89 c7             	mov    %rax,%rdi
  8012f1:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  8012f8:	00 00 00 
  8012fb:	ff d0                	callq  *%rax
  8012fd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801303:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801309:	c9                   	leaveq 
  80130a:	c3                   	retq   

000000000080130b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80130b:	55                   	push   %rbp
  80130c:	48 89 e5             	mov    %rsp,%rbp
  80130f:	48 83 ec 18          	sub    $0x18,%rsp
  801313:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801317:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80131e:	eb 09                	jmp    801329 <strlen+0x1e>
		n++;
  801320:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801324:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132d:	0f b6 00             	movzbl (%rax),%eax
  801330:	84 c0                	test   %al,%al
  801332:	75 ec                	jne    801320 <strlen+0x15>
		n++;
	return n;
  801334:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801337:	c9                   	leaveq 
  801338:	c3                   	retq   

0000000000801339 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801339:	55                   	push   %rbp
  80133a:	48 89 e5             	mov    %rsp,%rbp
  80133d:	48 83 ec 20          	sub    $0x20,%rsp
  801341:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801345:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801349:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801350:	eb 0e                	jmp    801360 <strnlen+0x27>
		n++;
  801352:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801356:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80135b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801360:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801365:	74 0b                	je     801372 <strnlen+0x39>
  801367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136b:	0f b6 00             	movzbl (%rax),%eax
  80136e:	84 c0                	test   %al,%al
  801370:	75 e0                	jne    801352 <strnlen+0x19>
		n++;
	return n;
  801372:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801375:	c9                   	leaveq 
  801376:	c3                   	retq   

0000000000801377 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801377:	55                   	push   %rbp
  801378:	48 89 e5             	mov    %rsp,%rbp
  80137b:	48 83 ec 20          	sub    $0x20,%rsp
  80137f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801383:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801387:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80138f:	90                   	nop
  801390:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801394:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801398:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80139c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013a0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013a4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013a8:	0f b6 12             	movzbl (%rdx),%edx
  8013ab:	88 10                	mov    %dl,(%rax)
  8013ad:	0f b6 00             	movzbl (%rax),%eax
  8013b0:	84 c0                	test   %al,%al
  8013b2:	75 dc                	jne    801390 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8013b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013b8:	c9                   	leaveq 
  8013b9:	c3                   	retq   

00000000008013ba <strcat>:

char *
strcat(char *dst, const char *src)
{
  8013ba:	55                   	push   %rbp
  8013bb:	48 89 e5             	mov    %rsp,%rbp
  8013be:	48 83 ec 20          	sub    $0x20,%rsp
  8013c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8013ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ce:	48 89 c7             	mov    %rax,%rdi
  8013d1:	48 b8 0b 13 80 00 00 	movabs $0x80130b,%rax
  8013d8:	00 00 00 
  8013db:	ff d0                	callq  *%rax
  8013dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8013e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013e3:	48 63 d0             	movslq %eax,%rdx
  8013e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ea:	48 01 c2             	add    %rax,%rdx
  8013ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013f1:	48 89 c6             	mov    %rax,%rsi
  8013f4:	48 89 d7             	mov    %rdx,%rdi
  8013f7:	48 b8 77 13 80 00 00 	movabs $0x801377,%rax
  8013fe:	00 00 00 
  801401:	ff d0                	callq  *%rax
	return dst;
  801403:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801407:	c9                   	leaveq 
  801408:	c3                   	retq   

0000000000801409 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801409:	55                   	push   %rbp
  80140a:	48 89 e5             	mov    %rsp,%rbp
  80140d:	48 83 ec 28          	sub    $0x28,%rsp
  801411:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801415:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801419:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80141d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801421:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801425:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80142c:	00 
  80142d:	eb 2a                	jmp    801459 <strncpy+0x50>
		*dst++ = *src;
  80142f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801433:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801437:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80143b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80143f:	0f b6 12             	movzbl (%rdx),%edx
  801442:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801444:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801448:	0f b6 00             	movzbl (%rax),%eax
  80144b:	84 c0                	test   %al,%al
  80144d:	74 05                	je     801454 <strncpy+0x4b>
			src++;
  80144f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801454:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801459:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801461:	72 cc                	jb     80142f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801463:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801467:	c9                   	leaveq 
  801468:	c3                   	retq   

0000000000801469 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801469:	55                   	push   %rbp
  80146a:	48 89 e5             	mov    %rsp,%rbp
  80146d:	48 83 ec 28          	sub    $0x28,%rsp
  801471:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801475:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801479:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80147d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801481:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801485:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80148a:	74 3d                	je     8014c9 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80148c:	eb 1d                	jmp    8014ab <strlcpy+0x42>
			*dst++ = *src++;
  80148e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801492:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801496:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80149a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80149e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014a2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014a6:	0f b6 12             	movzbl (%rdx),%edx
  8014a9:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014ab:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8014b0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014b5:	74 0b                	je     8014c2 <strlcpy+0x59>
  8014b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014bb:	0f b6 00             	movzbl (%rax),%eax
  8014be:	84 c0                	test   %al,%al
  8014c0:	75 cc                	jne    80148e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8014c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c6:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8014c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d1:	48 29 c2             	sub    %rax,%rdx
  8014d4:	48 89 d0             	mov    %rdx,%rax
}
  8014d7:	c9                   	leaveq 
  8014d8:	c3                   	retq   

00000000008014d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014d9:	55                   	push   %rbp
  8014da:	48 89 e5             	mov    %rsp,%rbp
  8014dd:	48 83 ec 10          	sub    $0x10,%rsp
  8014e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8014e9:	eb 0a                	jmp    8014f5 <strcmp+0x1c>
		p++, q++;
  8014eb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014f0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f9:	0f b6 00             	movzbl (%rax),%eax
  8014fc:	84 c0                	test   %al,%al
  8014fe:	74 12                	je     801512 <strcmp+0x39>
  801500:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801504:	0f b6 10             	movzbl (%rax),%edx
  801507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150b:	0f b6 00             	movzbl (%rax),%eax
  80150e:	38 c2                	cmp    %al,%dl
  801510:	74 d9                	je     8014eb <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801516:	0f b6 00             	movzbl (%rax),%eax
  801519:	0f b6 d0             	movzbl %al,%edx
  80151c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801520:	0f b6 00             	movzbl (%rax),%eax
  801523:	0f b6 c0             	movzbl %al,%eax
  801526:	29 c2                	sub    %eax,%edx
  801528:	89 d0                	mov    %edx,%eax
}
  80152a:	c9                   	leaveq 
  80152b:	c3                   	retq   

000000000080152c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80152c:	55                   	push   %rbp
  80152d:	48 89 e5             	mov    %rsp,%rbp
  801530:	48 83 ec 18          	sub    $0x18,%rsp
  801534:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801538:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80153c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801540:	eb 0f                	jmp    801551 <strncmp+0x25>
		n--, p++, q++;
  801542:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801547:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80154c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801551:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801556:	74 1d                	je     801575 <strncmp+0x49>
  801558:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155c:	0f b6 00             	movzbl (%rax),%eax
  80155f:	84 c0                	test   %al,%al
  801561:	74 12                	je     801575 <strncmp+0x49>
  801563:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801567:	0f b6 10             	movzbl (%rax),%edx
  80156a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156e:	0f b6 00             	movzbl (%rax),%eax
  801571:	38 c2                	cmp    %al,%dl
  801573:	74 cd                	je     801542 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801575:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80157a:	75 07                	jne    801583 <strncmp+0x57>
		return 0;
  80157c:	b8 00 00 00 00       	mov    $0x0,%eax
  801581:	eb 18                	jmp    80159b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801583:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801587:	0f b6 00             	movzbl (%rax),%eax
  80158a:	0f b6 d0             	movzbl %al,%edx
  80158d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801591:	0f b6 00             	movzbl (%rax),%eax
  801594:	0f b6 c0             	movzbl %al,%eax
  801597:	29 c2                	sub    %eax,%edx
  801599:	89 d0                	mov    %edx,%eax
}
  80159b:	c9                   	leaveq 
  80159c:	c3                   	retq   

000000000080159d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80159d:	55                   	push   %rbp
  80159e:	48 89 e5             	mov    %rsp,%rbp
  8015a1:	48 83 ec 10          	sub    $0x10,%rsp
  8015a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015a9:	89 f0                	mov    %esi,%eax
  8015ab:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015ae:	eb 17                	jmp    8015c7 <strchr+0x2a>
		if (*s == c)
  8015b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b4:	0f b6 00             	movzbl (%rax),%eax
  8015b7:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015ba:	75 06                	jne    8015c2 <strchr+0x25>
			return (char *) s;
  8015bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c0:	eb 15                	jmp    8015d7 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cb:	0f b6 00             	movzbl (%rax),%eax
  8015ce:	84 c0                	test   %al,%al
  8015d0:	75 de                	jne    8015b0 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8015d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d7:	c9                   	leaveq 
  8015d8:	c3                   	retq   

00000000008015d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015d9:	55                   	push   %rbp
  8015da:	48 89 e5             	mov    %rsp,%rbp
  8015dd:	48 83 ec 10          	sub    $0x10,%rsp
  8015e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015e5:	89 f0                	mov    %esi,%eax
  8015e7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015ea:	eb 11                	jmp    8015fd <strfind+0x24>
		if (*s == c)
  8015ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f0:	0f b6 00             	movzbl (%rax),%eax
  8015f3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015f6:	74 12                	je     80160a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015f8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801601:	0f b6 00             	movzbl (%rax),%eax
  801604:	84 c0                	test   %al,%al
  801606:	75 e4                	jne    8015ec <strfind+0x13>
  801608:	eb 01                	jmp    80160b <strfind+0x32>
		if (*s == c)
			break;
  80160a:	90                   	nop
	return (char *) s;
  80160b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80160f:	c9                   	leaveq 
  801610:	c3                   	retq   

0000000000801611 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801611:	55                   	push   %rbp
  801612:	48 89 e5             	mov    %rsp,%rbp
  801615:	48 83 ec 18          	sub    $0x18,%rsp
  801619:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80161d:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801620:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801624:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801629:	75 06                	jne    801631 <memset+0x20>
		return v;
  80162b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162f:	eb 69                	jmp    80169a <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801631:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801635:	83 e0 03             	and    $0x3,%eax
  801638:	48 85 c0             	test   %rax,%rax
  80163b:	75 48                	jne    801685 <memset+0x74>
  80163d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801641:	83 e0 03             	and    $0x3,%eax
  801644:	48 85 c0             	test   %rax,%rax
  801647:	75 3c                	jne    801685 <memset+0x74>
		c &= 0xFF;
  801649:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801650:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801653:	c1 e0 18             	shl    $0x18,%eax
  801656:	89 c2                	mov    %eax,%edx
  801658:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80165b:	c1 e0 10             	shl    $0x10,%eax
  80165e:	09 c2                	or     %eax,%edx
  801660:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801663:	c1 e0 08             	shl    $0x8,%eax
  801666:	09 d0                	or     %edx,%eax
  801668:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80166b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80166f:	48 c1 e8 02          	shr    $0x2,%rax
  801673:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801676:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80167a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80167d:	48 89 d7             	mov    %rdx,%rdi
  801680:	fc                   	cld    
  801681:	f3 ab                	rep stos %eax,%es:(%rdi)
  801683:	eb 11                	jmp    801696 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801685:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801689:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80168c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801690:	48 89 d7             	mov    %rdx,%rdi
  801693:	fc                   	cld    
  801694:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801696:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80169a:	c9                   	leaveq 
  80169b:	c3                   	retq   

000000000080169c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80169c:	55                   	push   %rbp
  80169d:	48 89 e5             	mov    %rsp,%rbp
  8016a0:	48 83 ec 28          	sub    $0x28,%rsp
  8016a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8016b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8016b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8016c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016c8:	0f 83 88 00 00 00    	jae    801756 <memmove+0xba>
  8016ce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d6:	48 01 d0             	add    %rdx,%rax
  8016d9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016dd:	76 77                	jbe    801756 <memmove+0xba>
		s += n;
  8016df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e3:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8016e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016eb:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f3:	83 e0 03             	and    $0x3,%eax
  8016f6:	48 85 c0             	test   %rax,%rax
  8016f9:	75 3b                	jne    801736 <memmove+0x9a>
  8016fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ff:	83 e0 03             	and    $0x3,%eax
  801702:	48 85 c0             	test   %rax,%rax
  801705:	75 2f                	jne    801736 <memmove+0x9a>
  801707:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170b:	83 e0 03             	and    $0x3,%eax
  80170e:	48 85 c0             	test   %rax,%rax
  801711:	75 23                	jne    801736 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801713:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801717:	48 83 e8 04          	sub    $0x4,%rax
  80171b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80171f:	48 83 ea 04          	sub    $0x4,%rdx
  801723:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801727:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80172b:	48 89 c7             	mov    %rax,%rdi
  80172e:	48 89 d6             	mov    %rdx,%rsi
  801731:	fd                   	std    
  801732:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801734:	eb 1d                	jmp    801753 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801736:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80173a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80173e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801742:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174a:	48 89 d7             	mov    %rdx,%rdi
  80174d:	48 89 c1             	mov    %rax,%rcx
  801750:	fd                   	std    
  801751:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801753:	fc                   	cld    
  801754:	eb 57                	jmp    8017ad <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801756:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80175a:	83 e0 03             	and    $0x3,%eax
  80175d:	48 85 c0             	test   %rax,%rax
  801760:	75 36                	jne    801798 <memmove+0xfc>
  801762:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801766:	83 e0 03             	and    $0x3,%eax
  801769:	48 85 c0             	test   %rax,%rax
  80176c:	75 2a                	jne    801798 <memmove+0xfc>
  80176e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801772:	83 e0 03             	and    $0x3,%eax
  801775:	48 85 c0             	test   %rax,%rax
  801778:	75 1e                	jne    801798 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80177a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177e:	48 c1 e8 02          	shr    $0x2,%rax
  801782:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801785:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801789:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80178d:	48 89 c7             	mov    %rax,%rdi
  801790:	48 89 d6             	mov    %rdx,%rsi
  801793:	fc                   	cld    
  801794:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801796:	eb 15                	jmp    8017ad <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801798:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017a0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017a4:	48 89 c7             	mov    %rax,%rdi
  8017a7:	48 89 d6             	mov    %rdx,%rsi
  8017aa:	fc                   	cld    
  8017ab:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8017ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017b1:	c9                   	leaveq 
  8017b2:	c3                   	retq   

00000000008017b3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8017b3:	55                   	push   %rbp
  8017b4:	48 89 e5             	mov    %rsp,%rbp
  8017b7:	48 83 ec 18          	sub    $0x18,%rsp
  8017bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017c3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8017c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017cb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8017cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017d3:	48 89 ce             	mov    %rcx,%rsi
  8017d6:	48 89 c7             	mov    %rax,%rdi
  8017d9:	48 b8 9c 16 80 00 00 	movabs $0x80169c,%rax
  8017e0:	00 00 00 
  8017e3:	ff d0                	callq  *%rax
}
  8017e5:	c9                   	leaveq 
  8017e6:	c3                   	retq   

00000000008017e7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8017e7:	55                   	push   %rbp
  8017e8:	48 89 e5             	mov    %rsp,%rbp
  8017eb:	48 83 ec 28          	sub    $0x28,%rsp
  8017ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017f7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8017fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801803:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801807:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80180b:	eb 36                	jmp    801843 <memcmp+0x5c>
		if (*s1 != *s2)
  80180d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801811:	0f b6 10             	movzbl (%rax),%edx
  801814:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801818:	0f b6 00             	movzbl (%rax),%eax
  80181b:	38 c2                	cmp    %al,%dl
  80181d:	74 1a                	je     801839 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80181f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801823:	0f b6 00             	movzbl (%rax),%eax
  801826:	0f b6 d0             	movzbl %al,%edx
  801829:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80182d:	0f b6 00             	movzbl (%rax),%eax
  801830:	0f b6 c0             	movzbl %al,%eax
  801833:	29 c2                	sub    %eax,%edx
  801835:	89 d0                	mov    %edx,%eax
  801837:	eb 20                	jmp    801859 <memcmp+0x72>
		s1++, s2++;
  801839:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80183e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801843:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801847:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80184b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80184f:	48 85 c0             	test   %rax,%rax
  801852:	75 b9                	jne    80180d <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801854:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801859:	c9                   	leaveq 
  80185a:	c3                   	retq   

000000000080185b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80185b:	55                   	push   %rbp
  80185c:	48 89 e5             	mov    %rsp,%rbp
  80185f:	48 83 ec 28          	sub    $0x28,%rsp
  801863:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801867:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80186a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80186e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801872:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801876:	48 01 d0             	add    %rdx,%rax
  801879:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80187d:	eb 19                	jmp    801898 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  80187f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801883:	0f b6 00             	movzbl (%rax),%eax
  801886:	0f b6 d0             	movzbl %al,%edx
  801889:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80188c:	0f b6 c0             	movzbl %al,%eax
  80188f:	39 c2                	cmp    %eax,%edx
  801891:	74 11                	je     8018a4 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801893:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80189c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8018a0:	72 dd                	jb     80187f <memfind+0x24>
  8018a2:	eb 01                	jmp    8018a5 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018a4:	90                   	nop
	return (void *) s;
  8018a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018a9:	c9                   	leaveq 
  8018aa:	c3                   	retq   

00000000008018ab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018ab:	55                   	push   %rbp
  8018ac:	48 89 e5             	mov    %rsp,%rbp
  8018af:	48 83 ec 38          	sub    $0x38,%rsp
  8018b3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018b7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018bb:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8018be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8018c5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8018cc:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018cd:	eb 05                	jmp    8018d4 <strtol+0x29>
		s++;
  8018cf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d8:	0f b6 00             	movzbl (%rax),%eax
  8018db:	3c 20                	cmp    $0x20,%al
  8018dd:	74 f0                	je     8018cf <strtol+0x24>
  8018df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e3:	0f b6 00             	movzbl (%rax),%eax
  8018e6:	3c 09                	cmp    $0x9,%al
  8018e8:	74 e5                	je     8018cf <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ee:	0f b6 00             	movzbl (%rax),%eax
  8018f1:	3c 2b                	cmp    $0x2b,%al
  8018f3:	75 07                	jne    8018fc <strtol+0x51>
		s++;
  8018f5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018fa:	eb 17                	jmp    801913 <strtol+0x68>
	else if (*s == '-')
  8018fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801900:	0f b6 00             	movzbl (%rax),%eax
  801903:	3c 2d                	cmp    $0x2d,%al
  801905:	75 0c                	jne    801913 <strtol+0x68>
		s++, neg = 1;
  801907:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80190c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801913:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801917:	74 06                	je     80191f <strtol+0x74>
  801919:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80191d:	75 28                	jne    801947 <strtol+0x9c>
  80191f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801923:	0f b6 00             	movzbl (%rax),%eax
  801926:	3c 30                	cmp    $0x30,%al
  801928:	75 1d                	jne    801947 <strtol+0x9c>
  80192a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192e:	48 83 c0 01          	add    $0x1,%rax
  801932:	0f b6 00             	movzbl (%rax),%eax
  801935:	3c 78                	cmp    $0x78,%al
  801937:	75 0e                	jne    801947 <strtol+0x9c>
		s += 2, base = 16;
  801939:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80193e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801945:	eb 2c                	jmp    801973 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801947:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80194b:	75 19                	jne    801966 <strtol+0xbb>
  80194d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801951:	0f b6 00             	movzbl (%rax),%eax
  801954:	3c 30                	cmp    $0x30,%al
  801956:	75 0e                	jne    801966 <strtol+0xbb>
		s++, base = 8;
  801958:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80195d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801964:	eb 0d                	jmp    801973 <strtol+0xc8>
	else if (base == 0)
  801966:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80196a:	75 07                	jne    801973 <strtol+0xc8>
		base = 10;
  80196c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801973:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801977:	0f b6 00             	movzbl (%rax),%eax
  80197a:	3c 2f                	cmp    $0x2f,%al
  80197c:	7e 1d                	jle    80199b <strtol+0xf0>
  80197e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801982:	0f b6 00             	movzbl (%rax),%eax
  801985:	3c 39                	cmp    $0x39,%al
  801987:	7f 12                	jg     80199b <strtol+0xf0>
			dig = *s - '0';
  801989:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80198d:	0f b6 00             	movzbl (%rax),%eax
  801990:	0f be c0             	movsbl %al,%eax
  801993:	83 e8 30             	sub    $0x30,%eax
  801996:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801999:	eb 4e                	jmp    8019e9 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80199b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199f:	0f b6 00             	movzbl (%rax),%eax
  8019a2:	3c 60                	cmp    $0x60,%al
  8019a4:	7e 1d                	jle    8019c3 <strtol+0x118>
  8019a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019aa:	0f b6 00             	movzbl (%rax),%eax
  8019ad:	3c 7a                	cmp    $0x7a,%al
  8019af:	7f 12                	jg     8019c3 <strtol+0x118>
			dig = *s - 'a' + 10;
  8019b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b5:	0f b6 00             	movzbl (%rax),%eax
  8019b8:	0f be c0             	movsbl %al,%eax
  8019bb:	83 e8 57             	sub    $0x57,%eax
  8019be:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019c1:	eb 26                	jmp    8019e9 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8019c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c7:	0f b6 00             	movzbl (%rax),%eax
  8019ca:	3c 40                	cmp    $0x40,%al
  8019cc:	7e 47                	jle    801a15 <strtol+0x16a>
  8019ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d2:	0f b6 00             	movzbl (%rax),%eax
  8019d5:	3c 5a                	cmp    $0x5a,%al
  8019d7:	7f 3c                	jg     801a15 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8019d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019dd:	0f b6 00             	movzbl (%rax),%eax
  8019e0:	0f be c0             	movsbl %al,%eax
  8019e3:	83 e8 37             	sub    $0x37,%eax
  8019e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8019e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019ec:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8019ef:	7d 23                	jge    801a14 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8019f1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019f6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8019f9:	48 98                	cltq   
  8019fb:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a00:	48 89 c2             	mov    %rax,%rdx
  801a03:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a06:	48 98                	cltq   
  801a08:	48 01 d0             	add    %rdx,%rax
  801a0b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a0f:	e9 5f ff ff ff       	jmpq   801973 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a14:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a15:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a1a:	74 0b                	je     801a27 <strtol+0x17c>
		*endptr = (char *) s;
  801a1c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a20:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a24:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a2b:	74 09                	je     801a36 <strtol+0x18b>
  801a2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a31:	48 f7 d8             	neg    %rax
  801a34:	eb 04                	jmp    801a3a <strtol+0x18f>
  801a36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a3a:	c9                   	leaveq 
  801a3b:	c3                   	retq   

0000000000801a3c <strstr>:

char * strstr(const char *in, const char *str)
{
  801a3c:	55                   	push   %rbp
  801a3d:	48 89 e5             	mov    %rsp,%rbp
  801a40:	48 83 ec 30          	sub    $0x30,%rsp
  801a44:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a48:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801a4c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a50:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a54:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a58:	0f b6 00             	movzbl (%rax),%eax
  801a5b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801a5e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801a62:	75 06                	jne    801a6a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801a64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a68:	eb 6b                	jmp    801ad5 <strstr+0x99>

	len = strlen(str);
  801a6a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a6e:	48 89 c7             	mov    %rax,%rdi
  801a71:	48 b8 0b 13 80 00 00 	movabs $0x80130b,%rax
  801a78:	00 00 00 
  801a7b:	ff d0                	callq  *%rax
  801a7d:	48 98                	cltq   
  801a7f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801a83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a87:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a8b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a8f:	0f b6 00             	movzbl (%rax),%eax
  801a92:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a95:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a99:	75 07                	jne    801aa2 <strstr+0x66>
				return (char *) 0;
  801a9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa0:	eb 33                	jmp    801ad5 <strstr+0x99>
		} while (sc != c);
  801aa2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801aa6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801aa9:	75 d8                	jne    801a83 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801aab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aaf:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801ab3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab7:	48 89 ce             	mov    %rcx,%rsi
  801aba:	48 89 c7             	mov    %rax,%rdi
  801abd:	48 b8 2c 15 80 00 00 	movabs $0x80152c,%rax
  801ac4:	00 00 00 
  801ac7:	ff d0                	callq  *%rax
  801ac9:	85 c0                	test   %eax,%eax
  801acb:	75 b6                	jne    801a83 <strstr+0x47>

	return (char *) (in - 1);
  801acd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad1:	48 83 e8 01          	sub    $0x1,%rax
}
  801ad5:	c9                   	leaveq 
  801ad6:	c3                   	retq   

0000000000801ad7 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801ad7:	55                   	push   %rbp
  801ad8:	48 89 e5             	mov    %rsp,%rbp
  801adb:	48 83 ec 20          	sub    $0x20,%rsp
  801adf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler==0) {
  801ae3:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801aea:	00 00 00 
  801aed:	48 8b 00             	mov    (%rax),%rax
  801af0:	48 85 c0             	test   %rax,%rax
  801af3:	0f 85 ae 00 00 00    	jne    801ba7 <set_pgfault_handler+0xd0>
		//allocate space
		int result = sys_page_alloc(sys_getenvid(), (void*)(UXSTACKTOP-PGSIZE), PTE_W|PTE_U|PTE_P);
  801af9:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  801b00:	00 00 00 
  801b03:	ff d0                	callq  *%rax
  801b05:	ba 07 00 00 00       	mov    $0x7,%edx
  801b0a:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801b0f:	89 c7                	mov    %eax,%edi
  801b11:	48 b8 f5 02 80 00 00 	movabs $0x8002f5,%rax
  801b18:	00 00 00 
  801b1b:	ff d0                	callq  *%rax
  801b1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  801b20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b24:	79 2a                	jns    801b50 <set_pgfault_handler+0x79>
			panic("sys_page_alloc for stack failed in setting page fault handler");
  801b26:	48 ba 48 20 80 00 00 	movabs $0x802048,%rdx
  801b2d:	00 00 00 
  801b30:	be 21 00 00 00       	mov    $0x21,%esi
  801b35:	48 bf 86 20 80 00 00 	movabs $0x802086,%rdi
  801b3c:	00 00 00 
  801b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b44:	48 b9 ad 05 80 00 00 	movabs $0x8005ad,%rcx
  801b4b:	00 00 00 
  801b4e:	ff d1                	callq  *%rcx
		}

		//actual set upcall
		result = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801b50:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  801b57:	00 00 00 
  801b5a:	ff d0                	callq  *%rax
  801b5c:	48 be 29 05 80 00 00 	movabs $0x800529,%rsi
  801b63:	00 00 00 
  801b66:	89 c7                	mov    %eax,%edi
  801b68:	48 b8 40 04 80 00 00 	movabs $0x800440,%rax
  801b6f:	00 00 00 
  801b72:	ff d0                	callq  *%rax
  801b74:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result <0){
  801b77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b7b:	79 2a                	jns    801ba7 <set_pgfault_handler+0xd0>
                        panic("setting upcall failed in setting page fault handler");
  801b7d:	48 ba 98 20 80 00 00 	movabs $0x802098,%rdx
  801b84:	00 00 00 
  801b87:	be 27 00 00 00       	mov    $0x27,%esi
  801b8c:	48 bf 86 20 80 00 00 	movabs $0x802086,%rdi
  801b93:	00 00 00 
  801b96:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9b:	48 b9 ad 05 80 00 00 	movabs $0x8005ad,%rcx
  801ba2:	00 00 00 
  801ba5:	ff d1                	callq  *%rcx
                }
		//panic("set_pgfault_handler not implemented");
	}

	_pgfault_handler = handler;
  801ba7:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801bae:	00 00 00 
  801bb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bb5:	48 89 10             	mov    %rdx,(%rax)

}
  801bb8:	90                   	nop
  801bb9:	c9                   	leaveq 
  801bba:	c3                   	retq   
