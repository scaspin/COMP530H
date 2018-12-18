
obj/user/softint:     file format elf64-x86-64


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
  80003c:	e8 16 00 00 00       	callq  800057 <libmain>
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
	asm volatile("int $14");	// page fault
  800052:	cd 0e                	int    $0xe
}
  800054:	90                   	nop
  800055:	c9                   	leaveq 
  800056:	c3                   	retq   

0000000000800057 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800057:	55                   	push   %rbp
  800058:	48 89 e5             	mov    %rsp,%rbp
  80005b:	48 83 ec 10          	sub    $0x10,%rsp
  80005f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800062:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  800066:	48 b8 58 02 80 00 00 	movabs $0x800258,%rax
  80006d:	00 00 00 
  800070:	ff d0                	callq  *%rax
  800072:	25 ff 03 00 00       	and    $0x3ff,%eax
  800077:	48 63 d0             	movslq %eax,%rdx
  80007a:	48 89 d0             	mov    %rdx,%rax
  80007d:	48 c1 e0 03          	shl    $0x3,%rax
  800081:	48 01 d0             	add    %rdx,%rax
  800084:	48 c1 e0 05          	shl    $0x5,%rax
  800088:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80008f:	00 00 00 
  800092:	48 01 c2             	add    %rax,%rdx
  800095:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80009c:	00 00 00 
  80009f:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000a6:	7e 14                	jle    8000bc <libmain+0x65>
		binaryname = argv[0];
  8000a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000ac:	48 8b 10             	mov    (%rax),%rdx
  8000af:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000b6:	00 00 00 
  8000b9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c3:	48 89 d6             	mov    %rdx,%rsi
  8000c6:	89 c7                	mov    %eax,%edi
  8000c8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000cf:	00 00 00 
  8000d2:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000d4:	48 b8 e3 00 80 00 00 	movabs $0x8000e3,%rax
  8000db:	00 00 00 
  8000de:	ff d0                	callq  *%rax
}
  8000e0:	90                   	nop
  8000e1:	c9                   	leaveq 
  8000e2:	c3                   	retq   

00000000008000e3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e3:	55                   	push   %rbp
  8000e4:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ec:	48 b8 12 02 80 00 00 	movabs $0x800212,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	callq  *%rax
}
  8000f8:	90                   	nop
  8000f9:	5d                   	pop    %rbp
  8000fa:	c3                   	retq   

00000000008000fb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000fb:	55                   	push   %rbp
  8000fc:	48 89 e5             	mov    %rsp,%rbp
  8000ff:	53                   	push   %rbx
  800100:	48 83 ec 48          	sub    $0x48,%rsp
  800104:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800107:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80010a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80010e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800112:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800116:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80011a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80011d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800121:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800125:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800129:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80012d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800131:	4c 89 c3             	mov    %r8,%rbx
  800134:	cd 30                	int    $0x30
  800136:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80013a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80013e:	74 3e                	je     80017e <syscall+0x83>
  800140:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800145:	7e 37                	jle    80017e <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800147:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80014b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80014e:	49 89 d0             	mov    %rdx,%r8
  800151:	89 c1                	mov    %eax,%ecx
  800153:	48 ba 4a 1a 80 00 00 	movabs $0x801a4a,%rdx
  80015a:	00 00 00 
  80015d:	be 23 00 00 00       	mov    $0x23,%esi
  800162:	48 bf 67 1a 80 00 00 	movabs $0x801a67,%rdi
  800169:	00 00 00 
  80016c:	b8 00 00 00 00       	mov    $0x0,%eax
  800171:	49 b9 05 05 80 00 00 	movabs $0x800505,%r9
  800178:	00 00 00 
  80017b:	41 ff d1             	callq  *%r9

	return ret;
  80017e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800182:	48 83 c4 48          	add    $0x48,%rsp
  800186:	5b                   	pop    %rbx
  800187:	5d                   	pop    %rbp
  800188:	c3                   	retq   

0000000000800189 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800189:	55                   	push   %rbp
  80018a:	48 89 e5             	mov    %rsp,%rbp
  80018d:	48 83 ec 10          	sub    $0x10,%rsp
  800191:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800195:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800199:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80019d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a1:	48 83 ec 08          	sub    $0x8,%rsp
  8001a5:	6a 00                	pushq  $0x0
  8001a7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001ad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001b3:	48 89 d1             	mov    %rdx,%rcx
  8001b6:	48 89 c2             	mov    %rax,%rdx
  8001b9:	be 00 00 00 00       	mov    $0x0,%esi
  8001be:	bf 00 00 00 00       	mov    $0x0,%edi
  8001c3:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	callq  *%rax
  8001cf:	48 83 c4 10          	add    $0x10,%rsp
}
  8001d3:	90                   	nop
  8001d4:	c9                   	leaveq 
  8001d5:	c3                   	retq   

00000000008001d6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001d6:	55                   	push   %rbp
  8001d7:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001da:	48 83 ec 08          	sub    $0x8,%rsp
  8001de:	6a 00                	pushq  $0x0
  8001e0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8001f6:	be 00 00 00 00       	mov    $0x0,%esi
  8001fb:	bf 01 00 00 00       	mov    $0x1,%edi
  800200:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  800207:	00 00 00 
  80020a:	ff d0                	callq  *%rax
  80020c:	48 83 c4 10          	add    $0x10,%rsp
}
  800210:	c9                   	leaveq 
  800211:	c3                   	retq   

0000000000800212 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800212:	55                   	push   %rbp
  800213:	48 89 e5             	mov    %rsp,%rbp
  800216:	48 83 ec 10          	sub    $0x10,%rsp
  80021a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80021d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800220:	48 98                	cltq   
  800222:	48 83 ec 08          	sub    $0x8,%rsp
  800226:	6a 00                	pushq  $0x0
  800228:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80022e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800234:	b9 00 00 00 00       	mov    $0x0,%ecx
  800239:	48 89 c2             	mov    %rax,%rdx
  80023c:	be 01 00 00 00       	mov    $0x1,%esi
  800241:	bf 03 00 00 00       	mov    $0x3,%edi
  800246:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
  800252:	48 83 c4 10          	add    $0x10,%rsp
}
  800256:	c9                   	leaveq 
  800257:	c3                   	retq   

0000000000800258 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800258:	55                   	push   %rbp
  800259:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80025c:	48 83 ec 08          	sub    $0x8,%rsp
  800260:	6a 00                	pushq  $0x0
  800262:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800268:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80026e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800273:	ba 00 00 00 00       	mov    $0x0,%edx
  800278:	be 00 00 00 00       	mov    $0x0,%esi
  80027d:	bf 02 00 00 00       	mov    $0x2,%edi
  800282:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
  80028e:	48 83 c4 10          	add    $0x10,%rsp
}
  800292:	c9                   	leaveq 
  800293:	c3                   	retq   

0000000000800294 <sys_yield>:

void
sys_yield(void)
{
  800294:	55                   	push   %rbp
  800295:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800298:	48 83 ec 08          	sub    $0x8,%rsp
  80029c:	6a 00                	pushq  $0x0
  80029e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002af:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b4:	be 00 00 00 00       	mov    $0x0,%esi
  8002b9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002be:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  8002c5:	00 00 00 
  8002c8:	ff d0                	callq  *%rax
  8002ca:	48 83 c4 10          	add    $0x10,%rsp
}
  8002ce:	90                   	nop
  8002cf:	c9                   	leaveq 
  8002d0:	c3                   	retq   

00000000008002d1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002d1:	55                   	push   %rbp
  8002d2:	48 89 e5             	mov    %rsp,%rbp
  8002d5:	48 83 ec 10          	sub    $0x10,%rsp
  8002d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002e0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002e6:	48 63 c8             	movslq %eax,%rcx
  8002e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002f0:	48 98                	cltq   
  8002f2:	48 83 ec 08          	sub    $0x8,%rsp
  8002f6:	6a 00                	pushq  $0x0
  8002f8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002fe:	49 89 c8             	mov    %rcx,%r8
  800301:	48 89 d1             	mov    %rdx,%rcx
  800304:	48 89 c2             	mov    %rax,%rdx
  800307:	be 01 00 00 00       	mov    $0x1,%esi
  80030c:	bf 04 00 00 00       	mov    $0x4,%edi
  800311:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  800318:	00 00 00 
  80031b:	ff d0                	callq  *%rax
  80031d:	48 83 c4 10          	add    $0x10,%rsp
}
  800321:	c9                   	leaveq 
  800322:	c3                   	retq   

0000000000800323 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800323:	55                   	push   %rbp
  800324:	48 89 e5             	mov    %rsp,%rbp
  800327:	48 83 ec 20          	sub    $0x20,%rsp
  80032b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80032e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800332:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800335:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800339:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80033d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800340:	48 63 c8             	movslq %eax,%rcx
  800343:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800347:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80034a:	48 63 f0             	movslq %eax,%rsi
  80034d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800351:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800354:	48 98                	cltq   
  800356:	48 83 ec 08          	sub    $0x8,%rsp
  80035a:	51                   	push   %rcx
  80035b:	49 89 f9             	mov    %rdi,%r9
  80035e:	49 89 f0             	mov    %rsi,%r8
  800361:	48 89 d1             	mov    %rdx,%rcx
  800364:	48 89 c2             	mov    %rax,%rdx
  800367:	be 01 00 00 00       	mov    $0x1,%esi
  80036c:	bf 05 00 00 00       	mov    $0x5,%edi
  800371:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  800378:	00 00 00 
  80037b:	ff d0                	callq  *%rax
  80037d:	48 83 c4 10          	add    $0x10,%rsp
}
  800381:	c9                   	leaveq 
  800382:	c3                   	retq   

0000000000800383 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800383:	55                   	push   %rbp
  800384:	48 89 e5             	mov    %rsp,%rbp
  800387:	48 83 ec 10          	sub    $0x10,%rsp
  80038b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80038e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800392:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800396:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800399:	48 98                	cltq   
  80039b:	48 83 ec 08          	sub    $0x8,%rsp
  80039f:	6a 00                	pushq  $0x0
  8003a1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003a7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003ad:	48 89 d1             	mov    %rdx,%rcx
  8003b0:	48 89 c2             	mov    %rax,%rdx
  8003b3:	be 01 00 00 00       	mov    $0x1,%esi
  8003b8:	bf 06 00 00 00       	mov    $0x6,%edi
  8003bd:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  8003c4:	00 00 00 
  8003c7:	ff d0                	callq  *%rax
  8003c9:	48 83 c4 10          	add    $0x10,%rsp
}
  8003cd:	c9                   	leaveq 
  8003ce:	c3                   	retq   

00000000008003cf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003cf:	55                   	push   %rbp
  8003d0:	48 89 e5             	mov    %rsp,%rbp
  8003d3:	48 83 ec 10          	sub    $0x10,%rsp
  8003d7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003da:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003e0:	48 63 d0             	movslq %eax,%rdx
  8003e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003e6:	48 98                	cltq   
  8003e8:	48 83 ec 08          	sub    $0x8,%rsp
  8003ec:	6a 00                	pushq  $0x0
  8003ee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003f4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003fa:	48 89 d1             	mov    %rdx,%rcx
  8003fd:	48 89 c2             	mov    %rax,%rdx
  800400:	be 01 00 00 00       	mov    $0x1,%esi
  800405:	bf 08 00 00 00       	mov    $0x8,%edi
  80040a:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  800411:	00 00 00 
  800414:	ff d0                	callq  *%rax
  800416:	48 83 c4 10          	add    $0x10,%rsp
}
  80041a:	c9                   	leaveq 
  80041b:	c3                   	retq   

000000000080041c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80041c:	55                   	push   %rbp
  80041d:	48 89 e5             	mov    %rsp,%rbp
  800420:	48 83 ec 10          	sub    $0x10,%rsp
  800424:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800427:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80042b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800432:	48 98                	cltq   
  800434:	48 83 ec 08          	sub    $0x8,%rsp
  800438:	6a 00                	pushq  $0x0
  80043a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800440:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800446:	48 89 d1             	mov    %rdx,%rcx
  800449:	48 89 c2             	mov    %rax,%rdx
  80044c:	be 01 00 00 00       	mov    $0x1,%esi
  800451:	bf 09 00 00 00       	mov    $0x9,%edi
  800456:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  80045d:	00 00 00 
  800460:	ff d0                	callq  *%rax
  800462:	48 83 c4 10          	add    $0x10,%rsp
}
  800466:	c9                   	leaveq 
  800467:	c3                   	retq   

0000000000800468 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800468:	55                   	push   %rbp
  800469:	48 89 e5             	mov    %rsp,%rbp
  80046c:	48 83 ec 20          	sub    $0x20,%rsp
  800470:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800473:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800477:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80047b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80047e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800481:	48 63 f0             	movslq %eax,%rsi
  800484:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800488:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80048b:	48 98                	cltq   
  80048d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800491:	48 83 ec 08          	sub    $0x8,%rsp
  800495:	6a 00                	pushq  $0x0
  800497:	49 89 f1             	mov    %rsi,%r9
  80049a:	49 89 c8             	mov    %rcx,%r8
  80049d:	48 89 d1             	mov    %rdx,%rcx
  8004a0:	48 89 c2             	mov    %rax,%rdx
  8004a3:	be 00 00 00 00       	mov    $0x0,%esi
  8004a8:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004ad:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  8004b4:	00 00 00 
  8004b7:	ff d0                	callq  *%rax
  8004b9:	48 83 c4 10          	add    $0x10,%rsp
}
  8004bd:	c9                   	leaveq 
  8004be:	c3                   	retq   

00000000008004bf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004bf:	55                   	push   %rbp
  8004c0:	48 89 e5             	mov    %rsp,%rbp
  8004c3:	48 83 ec 10          	sub    $0x10,%rsp
  8004c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004cf:	48 83 ec 08          	sub    $0x8,%rsp
  8004d3:	6a 00                	pushq  $0x0
  8004d5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004db:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004e6:	48 89 c2             	mov    %rax,%rdx
  8004e9:	be 01 00 00 00       	mov    $0x1,%esi
  8004ee:	bf 0c 00 00 00       	mov    $0xc,%edi
  8004f3:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  8004fa:	00 00 00 
  8004fd:	ff d0                	callq  *%rax
  8004ff:	48 83 c4 10          	add    $0x10,%rsp
}
  800503:	c9                   	leaveq 
  800504:	c3                   	retq   

0000000000800505 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800505:	55                   	push   %rbp
  800506:	48 89 e5             	mov    %rsp,%rbp
  800509:	53                   	push   %rbx
  80050a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800511:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800518:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80051e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800525:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80052c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800533:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80053a:	84 c0                	test   %al,%al
  80053c:	74 23                	je     800561 <_panic+0x5c>
  80053e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800545:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800549:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80054d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800551:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800555:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800559:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80055d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800561:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800568:	00 00 00 
  80056b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800572:	00 00 00 
  800575:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800579:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800580:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800587:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80058e:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800595:	00 00 00 
  800598:	48 8b 18             	mov    (%rax),%rbx
  80059b:	48 b8 58 02 80 00 00 	movabs $0x800258,%rax
  8005a2:	00 00 00 
  8005a5:	ff d0                	callq  *%rax
  8005a7:	89 c6                	mov    %eax,%esi
  8005a9:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8005af:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8005b6:	41 89 d0             	mov    %edx,%r8d
  8005b9:	48 89 c1             	mov    %rax,%rcx
  8005bc:	48 89 da             	mov    %rbx,%rdx
  8005bf:	48 bf 78 1a 80 00 00 	movabs $0x801a78,%rdi
  8005c6:	00 00 00 
  8005c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ce:	49 b9 3f 07 80 00 00 	movabs $0x80073f,%r9
  8005d5:	00 00 00 
  8005d8:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005db:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005e2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005e9:	48 89 d6             	mov    %rdx,%rsi
  8005ec:	48 89 c7             	mov    %rax,%rdi
  8005ef:	48 b8 93 06 80 00 00 	movabs $0x800693,%rax
  8005f6:	00 00 00 
  8005f9:	ff d0                	callq  *%rax
	cprintf("\n");
  8005fb:	48 bf 9b 1a 80 00 00 	movabs $0x801a9b,%rdi
  800602:	00 00 00 
  800605:	b8 00 00 00 00       	mov    $0x0,%eax
  80060a:	48 ba 3f 07 80 00 00 	movabs $0x80073f,%rdx
  800611:	00 00 00 
  800614:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800616:	cc                   	int3   
  800617:	eb fd                	jmp    800616 <_panic+0x111>

0000000000800619 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800619:	55                   	push   %rbp
  80061a:	48 89 e5             	mov    %rsp,%rbp
  80061d:	48 83 ec 10          	sub    $0x10,%rsp
  800621:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800624:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062c:	8b 00                	mov    (%rax),%eax
  80062e:	8d 48 01             	lea    0x1(%rax),%ecx
  800631:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800635:	89 0a                	mov    %ecx,(%rdx)
  800637:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80063a:	89 d1                	mov    %edx,%ecx
  80063c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800640:	48 98                	cltq   
  800642:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800646:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80064a:	8b 00                	mov    (%rax),%eax
  80064c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800651:	75 2c                	jne    80067f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800653:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800657:	8b 00                	mov    (%rax),%eax
  800659:	48 98                	cltq   
  80065b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80065f:	48 83 c2 08          	add    $0x8,%rdx
  800663:	48 89 c6             	mov    %rax,%rsi
  800666:	48 89 d7             	mov    %rdx,%rdi
  800669:	48 b8 89 01 80 00 00 	movabs $0x800189,%rax
  800670:	00 00 00 
  800673:	ff d0                	callq  *%rax
        b->idx = 0;
  800675:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800679:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80067f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800683:	8b 40 04             	mov    0x4(%rax),%eax
  800686:	8d 50 01             	lea    0x1(%rax),%edx
  800689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800690:	90                   	nop
  800691:	c9                   	leaveq 
  800692:	c3                   	retq   

0000000000800693 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800693:	55                   	push   %rbp
  800694:	48 89 e5             	mov    %rsp,%rbp
  800697:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80069e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006a5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006ac:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006b3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006ba:	48 8b 0a             	mov    (%rdx),%rcx
  8006bd:	48 89 08             	mov    %rcx,(%rax)
  8006c0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006c4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006c8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006cc:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006d7:	00 00 00 
    b.cnt = 0;
  8006da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006e1:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006e4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006eb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006f2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006f9:	48 89 c6             	mov    %rax,%rsi
  8006fc:	48 bf 19 06 80 00 00 	movabs $0x800619,%rdi
  800703:	00 00 00 
  800706:	48 b8 dd 0a 80 00 00 	movabs $0x800add,%rax
  80070d:	00 00 00 
  800710:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800712:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800718:	48 98                	cltq   
  80071a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800721:	48 83 c2 08          	add    $0x8,%rdx
  800725:	48 89 c6             	mov    %rax,%rsi
  800728:	48 89 d7             	mov    %rdx,%rdi
  80072b:	48 b8 89 01 80 00 00 	movabs $0x800189,%rax
  800732:	00 00 00 
  800735:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800737:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80073d:	c9                   	leaveq 
  80073e:	c3                   	retq   

000000000080073f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80073f:	55                   	push   %rbp
  800740:	48 89 e5             	mov    %rsp,%rbp
  800743:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80074a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800751:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800758:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80075f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800766:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80076d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800774:	84 c0                	test   %al,%al
  800776:	74 20                	je     800798 <cprintf+0x59>
  800778:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80077c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800780:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800784:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800788:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80078c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800790:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800794:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800798:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80079f:	00 00 00 
  8007a2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007a9:	00 00 00 
  8007ac:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007b0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007b7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007be:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007c5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007cc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007d3:	48 8b 0a             	mov    (%rdx),%rcx
  8007d6:	48 89 08             	mov    %rcx,(%rax)
  8007d9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007dd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007e1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007e5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007e9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007f0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007f7:	48 89 d6             	mov    %rdx,%rsi
  8007fa:	48 89 c7             	mov    %rax,%rdi
  8007fd:	48 b8 93 06 80 00 00 	movabs $0x800693,%rax
  800804:	00 00 00 
  800807:	ff d0                	callq  *%rax
  800809:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80080f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800815:	c9                   	leaveq 
  800816:	c3                   	retq   

0000000000800817 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800817:	55                   	push   %rbp
  800818:	48 89 e5             	mov    %rsp,%rbp
  80081b:	48 83 ec 30          	sub    $0x30,%rsp
  80081f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800823:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800827:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80082b:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80082e:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800832:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800836:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800839:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80083d:	77 54                	ja     800893 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80083f:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800842:	8d 78 ff             	lea    -0x1(%rax),%edi
  800845:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084c:	ba 00 00 00 00       	mov    $0x0,%edx
  800851:	48 f7 f6             	div    %rsi
  800854:	49 89 c2             	mov    %rax,%r10
  800857:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80085a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80085d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800861:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800865:	41 89 c9             	mov    %ecx,%r9d
  800868:	41 89 f8             	mov    %edi,%r8d
  80086b:	89 d1                	mov    %edx,%ecx
  80086d:	4c 89 d2             	mov    %r10,%rdx
  800870:	48 89 c7             	mov    %rax,%rdi
  800873:	48 b8 17 08 80 00 00 	movabs $0x800817,%rax
  80087a:	00 00 00 
  80087d:	ff d0                	callq  *%rax
  80087f:	eb 1c                	jmp    80089d <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800881:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800885:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800888:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80088c:	48 89 ce             	mov    %rcx,%rsi
  80088f:	89 d7                	mov    %edx,%edi
  800891:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800893:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800897:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80089b:	7f e4                	jg     800881 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80089d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a9:	48 f7 f1             	div    %rcx
  8008ac:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  8008b3:	00 00 00 
  8008b6:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8008ba:	0f be d0             	movsbl %al,%edx
  8008bd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8008c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008c5:	48 89 ce             	mov    %rcx,%rsi
  8008c8:	89 d7                	mov    %edx,%edi
  8008ca:	ff d0                	callq  *%rax
}
  8008cc:	90                   	nop
  8008cd:	c9                   	leaveq 
  8008ce:	c3                   	retq   

00000000008008cf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008cf:	55                   	push   %rbp
  8008d0:	48 89 e5             	mov    %rsp,%rbp
  8008d3:	48 83 ec 20          	sub    $0x20,%rsp
  8008d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008db:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008de:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008e2:	7e 4f                	jle    800933 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8008e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e8:	8b 00                	mov    (%rax),%eax
  8008ea:	83 f8 30             	cmp    $0x30,%eax
  8008ed:	73 24                	jae    800913 <getuint+0x44>
  8008ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fb:	8b 00                	mov    (%rax),%eax
  8008fd:	89 c0                	mov    %eax,%eax
  8008ff:	48 01 d0             	add    %rdx,%rax
  800902:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800906:	8b 12                	mov    (%rdx),%edx
  800908:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80090b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090f:	89 0a                	mov    %ecx,(%rdx)
  800911:	eb 14                	jmp    800927 <getuint+0x58>
  800913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800917:	48 8b 40 08          	mov    0x8(%rax),%rax
  80091b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80091f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800923:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800927:	48 8b 00             	mov    (%rax),%rax
  80092a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80092e:	e9 9d 00 00 00       	jmpq   8009d0 <getuint+0x101>
	else if (lflag)
  800933:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800937:	74 4c                	je     800985 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800939:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093d:	8b 00                	mov    (%rax),%eax
  80093f:	83 f8 30             	cmp    $0x30,%eax
  800942:	73 24                	jae    800968 <getuint+0x99>
  800944:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800948:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80094c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800950:	8b 00                	mov    (%rax),%eax
  800952:	89 c0                	mov    %eax,%eax
  800954:	48 01 d0             	add    %rdx,%rax
  800957:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095b:	8b 12                	mov    (%rdx),%edx
  80095d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800960:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800964:	89 0a                	mov    %ecx,(%rdx)
  800966:	eb 14                	jmp    80097c <getuint+0xad>
  800968:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800970:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800974:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800978:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80097c:	48 8b 00             	mov    (%rax),%rax
  80097f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800983:	eb 4b                	jmp    8009d0 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800985:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800989:	8b 00                	mov    (%rax),%eax
  80098b:	83 f8 30             	cmp    $0x30,%eax
  80098e:	73 24                	jae    8009b4 <getuint+0xe5>
  800990:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800994:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800998:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099c:	8b 00                	mov    (%rax),%eax
  80099e:	89 c0                	mov    %eax,%eax
  8009a0:	48 01 d0             	add    %rdx,%rax
  8009a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a7:	8b 12                	mov    (%rdx),%edx
  8009a9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b0:	89 0a                	mov    %ecx,(%rdx)
  8009b2:	eb 14                	jmp    8009c8 <getuint+0xf9>
  8009b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009bc:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009c8:	8b 00                	mov    (%rax),%eax
  8009ca:	89 c0                	mov    %eax,%eax
  8009cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009d4:	c9                   	leaveq 
  8009d5:	c3                   	retq   

00000000008009d6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009d6:	55                   	push   %rbp
  8009d7:	48 89 e5             	mov    %rsp,%rbp
  8009da:	48 83 ec 20          	sub    $0x20,%rsp
  8009de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009e2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009e5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009e9:	7e 4f                	jle    800a3a <getint+0x64>
		x=va_arg(*ap, long long);
  8009eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ef:	8b 00                	mov    (%rax),%eax
  8009f1:	83 f8 30             	cmp    $0x30,%eax
  8009f4:	73 24                	jae    800a1a <getint+0x44>
  8009f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009fa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a02:	8b 00                	mov    (%rax),%eax
  800a04:	89 c0                	mov    %eax,%eax
  800a06:	48 01 d0             	add    %rdx,%rax
  800a09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a0d:	8b 12                	mov    (%rdx),%edx
  800a0f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a16:	89 0a                	mov    %ecx,(%rdx)
  800a18:	eb 14                	jmp    800a2e <getint+0x58>
  800a1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a22:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a2e:	48 8b 00             	mov    (%rax),%rax
  800a31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a35:	e9 9d 00 00 00       	jmpq   800ad7 <getint+0x101>
	else if (lflag)
  800a3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a3e:	74 4c                	je     800a8c <getint+0xb6>
		x=va_arg(*ap, long);
  800a40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a44:	8b 00                	mov    (%rax),%eax
  800a46:	83 f8 30             	cmp    $0x30,%eax
  800a49:	73 24                	jae    800a6f <getint+0x99>
  800a4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a57:	8b 00                	mov    (%rax),%eax
  800a59:	89 c0                	mov    %eax,%eax
  800a5b:	48 01 d0             	add    %rdx,%rax
  800a5e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a62:	8b 12                	mov    (%rdx),%edx
  800a64:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6b:	89 0a                	mov    %ecx,(%rdx)
  800a6d:	eb 14                	jmp    800a83 <getint+0xad>
  800a6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a73:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a77:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a7b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a83:	48 8b 00             	mov    (%rax),%rax
  800a86:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a8a:	eb 4b                	jmp    800ad7 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800a8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a90:	8b 00                	mov    (%rax),%eax
  800a92:	83 f8 30             	cmp    $0x30,%eax
  800a95:	73 24                	jae    800abb <getint+0xe5>
  800a97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa3:	8b 00                	mov    (%rax),%eax
  800aa5:	89 c0                	mov    %eax,%eax
  800aa7:	48 01 d0             	add    %rdx,%rax
  800aaa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aae:	8b 12                	mov    (%rdx),%edx
  800ab0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ab3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab7:	89 0a                	mov    %ecx,(%rdx)
  800ab9:	eb 14                	jmp    800acf <getint+0xf9>
  800abb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abf:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ac3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ac7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800acb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800acf:	8b 00                	mov    (%rax),%eax
  800ad1:	48 98                	cltq   
  800ad3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ad7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800adb:	c9                   	leaveq 
  800adc:	c3                   	retq   

0000000000800add <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800add:	55                   	push   %rbp
  800ade:	48 89 e5             	mov    %rsp,%rbp
  800ae1:	41 54                	push   %r12
  800ae3:	53                   	push   %rbx
  800ae4:	48 83 ec 60          	sub    $0x60,%rsp
  800ae8:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800aec:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800af0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800af4:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800af8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800afc:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b00:	48 8b 0a             	mov    (%rdx),%rcx
  800b03:	48 89 08             	mov    %rcx,(%rax)
  800b06:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b0a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b0e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b12:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b16:	eb 17                	jmp    800b2f <vprintfmt+0x52>
			if (ch == '\0')
  800b18:	85 db                	test   %ebx,%ebx
  800b1a:	0f 84 b9 04 00 00    	je     800fd9 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800b20:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b28:	48 89 d6             	mov    %rdx,%rsi
  800b2b:	89 df                	mov    %ebx,%edi
  800b2d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b2f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b33:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b37:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b3b:	0f b6 00             	movzbl (%rax),%eax
  800b3e:	0f b6 d8             	movzbl %al,%ebx
  800b41:	83 fb 25             	cmp    $0x25,%ebx
  800b44:	75 d2                	jne    800b18 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b46:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b4a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b51:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b58:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b5f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b66:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b6a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b6e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b72:	0f b6 00             	movzbl (%rax),%eax
  800b75:	0f b6 d8             	movzbl %al,%ebx
  800b78:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b7b:	83 f8 55             	cmp    $0x55,%eax
  800b7e:	0f 87 22 04 00 00    	ja     800fa6 <vprintfmt+0x4c9>
  800b84:	89 c0                	mov    %eax,%eax
  800b86:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b8d:	00 
  800b8e:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  800b95:	00 00 00 
  800b98:	48 01 d0             	add    %rdx,%rax
  800b9b:	48 8b 00             	mov    (%rax),%rax
  800b9e:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ba0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ba4:	eb c0                	jmp    800b66 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ba6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800baa:	eb ba                	jmp    800b66 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bac:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bb3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bb6:	89 d0                	mov    %edx,%eax
  800bb8:	c1 e0 02             	shl    $0x2,%eax
  800bbb:	01 d0                	add    %edx,%eax
  800bbd:	01 c0                	add    %eax,%eax
  800bbf:	01 d8                	add    %ebx,%eax
  800bc1:	83 e8 30             	sub    $0x30,%eax
  800bc4:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bc7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bcb:	0f b6 00             	movzbl (%rax),%eax
  800bce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bd1:	83 fb 2f             	cmp    $0x2f,%ebx
  800bd4:	7e 60                	jle    800c36 <vprintfmt+0x159>
  800bd6:	83 fb 39             	cmp    $0x39,%ebx
  800bd9:	7f 5b                	jg     800c36 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bdb:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800be0:	eb d1                	jmp    800bb3 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800be2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be5:	83 f8 30             	cmp    $0x30,%eax
  800be8:	73 17                	jae    800c01 <vprintfmt+0x124>
  800bea:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800bee:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf1:	89 d2                	mov    %edx,%edx
  800bf3:	48 01 d0             	add    %rdx,%rax
  800bf6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf9:	83 c2 08             	add    $0x8,%edx
  800bfc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bff:	eb 0c                	jmp    800c0d <vprintfmt+0x130>
  800c01:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c05:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c09:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c0d:	8b 00                	mov    (%rax),%eax
  800c0f:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c12:	eb 23                	jmp    800c37 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800c14:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c18:	0f 89 48 ff ff ff    	jns    800b66 <vprintfmt+0x89>
				width = 0;
  800c1e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c25:	e9 3c ff ff ff       	jmpq   800b66 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c2a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c31:	e9 30 ff ff ff       	jmpq   800b66 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c36:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c37:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c3b:	0f 89 25 ff ff ff    	jns    800b66 <vprintfmt+0x89>
				width = precision, precision = -1;
  800c41:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c44:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c47:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c4e:	e9 13 ff ff ff       	jmpq   800b66 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c53:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c57:	e9 0a ff ff ff       	jmpq   800b66 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c5c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c5f:	83 f8 30             	cmp    $0x30,%eax
  800c62:	73 17                	jae    800c7b <vprintfmt+0x19e>
  800c64:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c68:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c6b:	89 d2                	mov    %edx,%edx
  800c6d:	48 01 d0             	add    %rdx,%rax
  800c70:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c73:	83 c2 08             	add    $0x8,%edx
  800c76:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c79:	eb 0c                	jmp    800c87 <vprintfmt+0x1aa>
  800c7b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c7f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c83:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c87:	8b 10                	mov    (%rax),%edx
  800c89:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c91:	48 89 ce             	mov    %rcx,%rsi
  800c94:	89 d7                	mov    %edx,%edi
  800c96:	ff d0                	callq  *%rax
			break;
  800c98:	e9 37 03 00 00       	jmpq   800fd4 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800c9d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca0:	83 f8 30             	cmp    $0x30,%eax
  800ca3:	73 17                	jae    800cbc <vprintfmt+0x1df>
  800ca5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ca9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cac:	89 d2                	mov    %edx,%edx
  800cae:	48 01 d0             	add    %rdx,%rax
  800cb1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb4:	83 c2 08             	add    $0x8,%edx
  800cb7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cba:	eb 0c                	jmp    800cc8 <vprintfmt+0x1eb>
  800cbc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cc0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cc4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc8:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cca:	85 db                	test   %ebx,%ebx
  800ccc:	79 02                	jns    800cd0 <vprintfmt+0x1f3>
				err = -err;
  800cce:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cd0:	83 fb 15             	cmp    $0x15,%ebx
  800cd3:	7f 16                	jg     800ceb <vprintfmt+0x20e>
  800cd5:	48 b8 40 1b 80 00 00 	movabs $0x801b40,%rax
  800cdc:	00 00 00 
  800cdf:	48 63 d3             	movslq %ebx,%rdx
  800ce2:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ce6:	4d 85 e4             	test   %r12,%r12
  800ce9:	75 2e                	jne    800d19 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800ceb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf3:	89 d9                	mov    %ebx,%ecx
  800cf5:	48 ba 01 1c 80 00 00 	movabs $0x801c01,%rdx
  800cfc:	00 00 00 
  800cff:	48 89 c7             	mov    %rax,%rdi
  800d02:	b8 00 00 00 00       	mov    $0x0,%eax
  800d07:	49 b8 e3 0f 80 00 00 	movabs $0x800fe3,%r8
  800d0e:	00 00 00 
  800d11:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d14:	e9 bb 02 00 00       	jmpq   800fd4 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d19:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d21:	4c 89 e1             	mov    %r12,%rcx
  800d24:	48 ba 0a 1c 80 00 00 	movabs $0x801c0a,%rdx
  800d2b:	00 00 00 
  800d2e:	48 89 c7             	mov    %rax,%rdi
  800d31:	b8 00 00 00 00       	mov    $0x0,%eax
  800d36:	49 b8 e3 0f 80 00 00 	movabs $0x800fe3,%r8
  800d3d:	00 00 00 
  800d40:	41 ff d0             	callq  *%r8
			break;
  800d43:	e9 8c 02 00 00       	jmpq   800fd4 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d4b:	83 f8 30             	cmp    $0x30,%eax
  800d4e:	73 17                	jae    800d67 <vprintfmt+0x28a>
  800d50:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d54:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d57:	89 d2                	mov    %edx,%edx
  800d59:	48 01 d0             	add    %rdx,%rax
  800d5c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d5f:	83 c2 08             	add    $0x8,%edx
  800d62:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d65:	eb 0c                	jmp    800d73 <vprintfmt+0x296>
  800d67:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d6b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d6f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d73:	4c 8b 20             	mov    (%rax),%r12
  800d76:	4d 85 e4             	test   %r12,%r12
  800d79:	75 0a                	jne    800d85 <vprintfmt+0x2a8>
				p = "(null)";
  800d7b:	49 bc 0d 1c 80 00 00 	movabs $0x801c0d,%r12
  800d82:	00 00 00 
			if (width > 0 && padc != '-')
  800d85:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d89:	7e 78                	jle    800e03 <vprintfmt+0x326>
  800d8b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d8f:	74 72                	je     800e03 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d91:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d94:	48 98                	cltq   
  800d96:	48 89 c6             	mov    %rax,%rsi
  800d99:	4c 89 e7             	mov    %r12,%rdi
  800d9c:	48 b8 91 12 80 00 00 	movabs $0x801291,%rax
  800da3:	00 00 00 
  800da6:	ff d0                	callq  *%rax
  800da8:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dab:	eb 17                	jmp    800dc4 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800dad:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800db1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800db5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db9:	48 89 ce             	mov    %rcx,%rsi
  800dbc:	89 d7                	mov    %edx,%edi
  800dbe:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dc4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dc8:	7f e3                	jg     800dad <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dca:	eb 37                	jmp    800e03 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800dcc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800dd0:	74 1e                	je     800df0 <vprintfmt+0x313>
  800dd2:	83 fb 1f             	cmp    $0x1f,%ebx
  800dd5:	7e 05                	jle    800ddc <vprintfmt+0x2ff>
  800dd7:	83 fb 7e             	cmp    $0x7e,%ebx
  800dda:	7e 14                	jle    800df0 <vprintfmt+0x313>
					putch('?', putdat);
  800ddc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de4:	48 89 d6             	mov    %rdx,%rsi
  800de7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800dec:	ff d0                	callq  *%rax
  800dee:	eb 0f                	jmp    800dff <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800df0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df8:	48 89 d6             	mov    %rdx,%rsi
  800dfb:	89 df                	mov    %ebx,%edi
  800dfd:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dff:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e03:	4c 89 e0             	mov    %r12,%rax
  800e06:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e0a:	0f b6 00             	movzbl (%rax),%eax
  800e0d:	0f be d8             	movsbl %al,%ebx
  800e10:	85 db                	test   %ebx,%ebx
  800e12:	74 28                	je     800e3c <vprintfmt+0x35f>
  800e14:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e18:	78 b2                	js     800dcc <vprintfmt+0x2ef>
  800e1a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e1e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e22:	79 a8                	jns    800dcc <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e24:	eb 16                	jmp    800e3c <vprintfmt+0x35f>
				putch(' ', putdat);
  800e26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2e:	48 89 d6             	mov    %rdx,%rsi
  800e31:	bf 20 00 00 00       	mov    $0x20,%edi
  800e36:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e38:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e3c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e40:	7f e4                	jg     800e26 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800e42:	e9 8d 01 00 00       	jmpq   800fd4 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e47:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e4b:	be 03 00 00 00       	mov    $0x3,%esi
  800e50:	48 89 c7             	mov    %rax,%rdi
  800e53:	48 b8 d6 09 80 00 00 	movabs $0x8009d6,%rax
  800e5a:	00 00 00 
  800e5d:	ff d0                	callq  *%rax
  800e5f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e67:	48 85 c0             	test   %rax,%rax
  800e6a:	79 1d                	jns    800e89 <vprintfmt+0x3ac>
				putch('-', putdat);
  800e6c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e70:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e74:	48 89 d6             	mov    %rdx,%rsi
  800e77:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e7c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e82:	48 f7 d8             	neg    %rax
  800e85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e89:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e90:	e9 d2 00 00 00       	jmpq   800f67 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e95:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e99:	be 03 00 00 00       	mov    $0x3,%esi
  800e9e:	48 89 c7             	mov    %rax,%rdi
  800ea1:	48 b8 cf 08 80 00 00 	movabs $0x8008cf,%rax
  800ea8:	00 00 00 
  800eab:	ff d0                	callq  *%rax
  800ead:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800eb1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800eb8:	e9 aa 00 00 00       	jmpq   800f67 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800ebd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ec1:	be 03 00 00 00       	mov    $0x3,%esi
  800ec6:	48 89 c7             	mov    %rax,%rdi
  800ec9:	48 b8 cf 08 80 00 00 	movabs $0x8008cf,%rax
  800ed0:	00 00 00 
  800ed3:	ff d0                	callq  *%rax
  800ed5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ed9:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ee0:	e9 82 00 00 00       	jmpq   800f67 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800ee5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eed:	48 89 d6             	mov    %rdx,%rsi
  800ef0:	bf 30 00 00 00       	mov    $0x30,%edi
  800ef5:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ef7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800efb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eff:	48 89 d6             	mov    %rdx,%rsi
  800f02:	bf 78 00 00 00       	mov    $0x78,%edi
  800f07:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f09:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f0c:	83 f8 30             	cmp    $0x30,%eax
  800f0f:	73 17                	jae    800f28 <vprintfmt+0x44b>
  800f11:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f15:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f18:	89 d2                	mov    %edx,%edx
  800f1a:	48 01 d0             	add    %rdx,%rax
  800f1d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f20:	83 c2 08             	add    $0x8,%edx
  800f23:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f26:	eb 0c                	jmp    800f34 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800f28:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800f2c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800f30:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f34:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f37:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f3b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f42:	eb 23                	jmp    800f67 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f44:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f48:	be 03 00 00 00       	mov    $0x3,%esi
  800f4d:	48 89 c7             	mov    %rax,%rdi
  800f50:	48 b8 cf 08 80 00 00 	movabs $0x8008cf,%rax
  800f57:	00 00 00 
  800f5a:	ff d0                	callq  *%rax
  800f5c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f60:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f67:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f6c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f6f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f72:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f76:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f7a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f7e:	45 89 c1             	mov    %r8d,%r9d
  800f81:	41 89 f8             	mov    %edi,%r8d
  800f84:	48 89 c7             	mov    %rax,%rdi
  800f87:	48 b8 17 08 80 00 00 	movabs $0x800817,%rax
  800f8e:	00 00 00 
  800f91:	ff d0                	callq  *%rax
			break;
  800f93:	eb 3f                	jmp    800fd4 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f95:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f9d:	48 89 d6             	mov    %rdx,%rsi
  800fa0:	89 df                	mov    %ebx,%edi
  800fa2:	ff d0                	callq  *%rax
			break;
  800fa4:	eb 2e                	jmp    800fd4 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fa6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800faa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fae:	48 89 d6             	mov    %rdx,%rsi
  800fb1:	bf 25 00 00 00       	mov    $0x25,%edi
  800fb6:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fb8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fbd:	eb 05                	jmp    800fc4 <vprintfmt+0x4e7>
  800fbf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fc4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fc8:	48 83 e8 01          	sub    $0x1,%rax
  800fcc:	0f b6 00             	movzbl (%rax),%eax
  800fcf:	3c 25                	cmp    $0x25,%al
  800fd1:	75 ec                	jne    800fbf <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800fd3:	90                   	nop
		}
	}
  800fd4:	e9 3d fb ff ff       	jmpq   800b16 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fd9:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800fda:	48 83 c4 60          	add    $0x60,%rsp
  800fde:	5b                   	pop    %rbx
  800fdf:	41 5c                	pop    %r12
  800fe1:	5d                   	pop    %rbp
  800fe2:	c3                   	retq   

0000000000800fe3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fe3:	55                   	push   %rbp
  800fe4:	48 89 e5             	mov    %rsp,%rbp
  800fe7:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800fee:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ff5:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ffc:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  801003:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80100a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801011:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801018:	84 c0                	test   %al,%al
  80101a:	74 20                	je     80103c <printfmt+0x59>
  80101c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801020:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801024:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801028:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80102c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801030:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801034:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801038:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80103c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801043:	00 00 00 
  801046:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80104d:	00 00 00 
  801050:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801054:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80105b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801062:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801069:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801070:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801077:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80107e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801085:	48 89 c7             	mov    %rax,%rdi
  801088:	48 b8 dd 0a 80 00 00 	movabs $0x800add,%rax
  80108f:	00 00 00 
  801092:	ff d0                	callq  *%rax
	va_end(ap);
}
  801094:	90                   	nop
  801095:	c9                   	leaveq 
  801096:	c3                   	retq   

0000000000801097 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801097:	55                   	push   %rbp
  801098:	48 89 e5             	mov    %rsp,%rbp
  80109b:	48 83 ec 10          	sub    $0x10,%rsp
  80109f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010aa:	8b 40 10             	mov    0x10(%rax),%eax
  8010ad:	8d 50 01             	lea    0x1(%rax),%edx
  8010b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010bb:	48 8b 10             	mov    (%rax),%rdx
  8010be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010c6:	48 39 c2             	cmp    %rax,%rdx
  8010c9:	73 17                	jae    8010e2 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010cf:	48 8b 00             	mov    (%rax),%rax
  8010d2:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010da:	48 89 0a             	mov    %rcx,(%rdx)
  8010dd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010e0:	88 10                	mov    %dl,(%rax)
}
  8010e2:	90                   	nop
  8010e3:	c9                   	leaveq 
  8010e4:	c3                   	retq   

00000000008010e5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010e5:	55                   	push   %rbp
  8010e6:	48 89 e5             	mov    %rsp,%rbp
  8010e9:	48 83 ec 50          	sub    $0x50,%rsp
  8010ed:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010f1:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8010f4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8010f8:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8010fc:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801100:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801104:	48 8b 0a             	mov    (%rdx),%rcx
  801107:	48 89 08             	mov    %rcx,(%rax)
  80110a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80110e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801112:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801116:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80111a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80111e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801122:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801125:	48 98                	cltq   
  801127:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80112b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80112f:	48 01 d0             	add    %rdx,%rax
  801132:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801136:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80113d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801142:	74 06                	je     80114a <vsnprintf+0x65>
  801144:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801148:	7f 07                	jg     801151 <vsnprintf+0x6c>
		return -E_INVAL;
  80114a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80114f:	eb 2f                	jmp    801180 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801151:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801155:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801159:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80115d:	48 89 c6             	mov    %rax,%rsi
  801160:	48 bf 97 10 80 00 00 	movabs $0x801097,%rdi
  801167:	00 00 00 
  80116a:	48 b8 dd 0a 80 00 00 	movabs $0x800add,%rax
  801171:	00 00 00 
  801174:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801176:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80117a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80117d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801180:	c9                   	leaveq 
  801181:	c3                   	retq   

0000000000801182 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801182:	55                   	push   %rbp
  801183:	48 89 e5             	mov    %rsp,%rbp
  801186:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80118d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801194:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80119a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8011a1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011a8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011af:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011b6:	84 c0                	test   %al,%al
  8011b8:	74 20                	je     8011da <snprintf+0x58>
  8011ba:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011be:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011c2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011c6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011ca:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011ce:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011d2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011d6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011da:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011e1:	00 00 00 
  8011e4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011eb:	00 00 00 
  8011ee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011f2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8011f9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801200:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801207:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80120e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801215:	48 8b 0a             	mov    (%rdx),%rcx
  801218:	48 89 08             	mov    %rcx,(%rax)
  80121b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80121f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801223:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801227:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80122b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801232:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801239:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80123f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801246:	48 89 c7             	mov    %rax,%rdi
  801249:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  801250:	00 00 00 
  801253:	ff d0                	callq  *%rax
  801255:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80125b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801261:	c9                   	leaveq 
  801262:	c3                   	retq   

0000000000801263 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801263:	55                   	push   %rbp
  801264:	48 89 e5             	mov    %rsp,%rbp
  801267:	48 83 ec 18          	sub    $0x18,%rsp
  80126b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80126f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801276:	eb 09                	jmp    801281 <strlen+0x1e>
		n++;
  801278:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80127c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801281:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801285:	0f b6 00             	movzbl (%rax),%eax
  801288:	84 c0                	test   %al,%al
  80128a:	75 ec                	jne    801278 <strlen+0x15>
		n++;
	return n;
  80128c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80128f:	c9                   	leaveq 
  801290:	c3                   	retq   

0000000000801291 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801291:	55                   	push   %rbp
  801292:	48 89 e5             	mov    %rsp,%rbp
  801295:	48 83 ec 20          	sub    $0x20,%rsp
  801299:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80129d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012a8:	eb 0e                	jmp    8012b8 <strnlen+0x27>
		n++;
  8012aa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ae:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012b3:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012b8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012bd:	74 0b                	je     8012ca <strnlen+0x39>
  8012bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c3:	0f b6 00             	movzbl (%rax),%eax
  8012c6:	84 c0                	test   %al,%al
  8012c8:	75 e0                	jne    8012aa <strnlen+0x19>
		n++;
	return n;
  8012ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012cd:	c9                   	leaveq 
  8012ce:	c3                   	retq   

00000000008012cf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012cf:	55                   	push   %rbp
  8012d0:	48 89 e5             	mov    %rsp,%rbp
  8012d3:	48 83 ec 20          	sub    $0x20,%rsp
  8012d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012e7:	90                   	nop
  8012e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ec:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012f0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012f4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012f8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012fc:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801300:	0f b6 12             	movzbl (%rdx),%edx
  801303:	88 10                	mov    %dl,(%rax)
  801305:	0f b6 00             	movzbl (%rax),%eax
  801308:	84 c0                	test   %al,%al
  80130a:	75 dc                	jne    8012e8 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80130c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801310:	c9                   	leaveq 
  801311:	c3                   	retq   

0000000000801312 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801312:	55                   	push   %rbp
  801313:	48 89 e5             	mov    %rsp,%rbp
  801316:	48 83 ec 20          	sub    $0x20,%rsp
  80131a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80131e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801326:	48 89 c7             	mov    %rax,%rdi
  801329:	48 b8 63 12 80 00 00 	movabs $0x801263,%rax
  801330:	00 00 00 
  801333:	ff d0                	callq  *%rax
  801335:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801338:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80133b:	48 63 d0             	movslq %eax,%rdx
  80133e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801342:	48 01 c2             	add    %rax,%rdx
  801345:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801349:	48 89 c6             	mov    %rax,%rsi
  80134c:	48 89 d7             	mov    %rdx,%rdi
  80134f:	48 b8 cf 12 80 00 00 	movabs $0x8012cf,%rax
  801356:	00 00 00 
  801359:	ff d0                	callq  *%rax
	return dst;
  80135b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80135f:	c9                   	leaveq 
  801360:	c3                   	retq   

0000000000801361 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801361:	55                   	push   %rbp
  801362:	48 89 e5             	mov    %rsp,%rbp
  801365:	48 83 ec 28          	sub    $0x28,%rsp
  801369:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80136d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801371:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801375:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801379:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80137d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801384:	00 
  801385:	eb 2a                	jmp    8013b1 <strncpy+0x50>
		*dst++ = *src;
  801387:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80138f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801393:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801397:	0f b6 12             	movzbl (%rdx),%edx
  80139a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80139c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013a0:	0f b6 00             	movzbl (%rax),%eax
  8013a3:	84 c0                	test   %al,%al
  8013a5:	74 05                	je     8013ac <strncpy+0x4b>
			src++;
  8013a7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013b9:	72 cc                	jb     801387 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013bf:	c9                   	leaveq 
  8013c0:	c3                   	retq   

00000000008013c1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013c1:	55                   	push   %rbp
  8013c2:	48 89 e5             	mov    %rsp,%rbp
  8013c5:	48 83 ec 28          	sub    $0x28,%rsp
  8013c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013dd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013e2:	74 3d                	je     801421 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8013e4:	eb 1d                	jmp    801403 <strlcpy+0x42>
			*dst++ = *src++;
  8013e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013f6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013fa:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013fe:	0f b6 12             	movzbl (%rdx),%edx
  801401:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801403:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801408:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80140d:	74 0b                	je     80141a <strlcpy+0x59>
  80140f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801413:	0f b6 00             	movzbl (%rax),%eax
  801416:	84 c0                	test   %al,%al
  801418:	75 cc                	jne    8013e6 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80141a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80141e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801421:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801429:	48 29 c2             	sub    %rax,%rdx
  80142c:	48 89 d0             	mov    %rdx,%rax
}
  80142f:	c9                   	leaveq 
  801430:	c3                   	retq   

0000000000801431 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801431:	55                   	push   %rbp
  801432:	48 89 e5             	mov    %rsp,%rbp
  801435:	48 83 ec 10          	sub    $0x10,%rsp
  801439:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80143d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801441:	eb 0a                	jmp    80144d <strcmp+0x1c>
		p++, q++;
  801443:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801448:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80144d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801451:	0f b6 00             	movzbl (%rax),%eax
  801454:	84 c0                	test   %al,%al
  801456:	74 12                	je     80146a <strcmp+0x39>
  801458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145c:	0f b6 10             	movzbl (%rax),%edx
  80145f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801463:	0f b6 00             	movzbl (%rax),%eax
  801466:	38 c2                	cmp    %al,%dl
  801468:	74 d9                	je     801443 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80146a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146e:	0f b6 00             	movzbl (%rax),%eax
  801471:	0f b6 d0             	movzbl %al,%edx
  801474:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801478:	0f b6 00             	movzbl (%rax),%eax
  80147b:	0f b6 c0             	movzbl %al,%eax
  80147e:	29 c2                	sub    %eax,%edx
  801480:	89 d0                	mov    %edx,%eax
}
  801482:	c9                   	leaveq 
  801483:	c3                   	retq   

0000000000801484 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801484:	55                   	push   %rbp
  801485:	48 89 e5             	mov    %rsp,%rbp
  801488:	48 83 ec 18          	sub    $0x18,%rsp
  80148c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801490:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801494:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801498:	eb 0f                	jmp    8014a9 <strncmp+0x25>
		n--, p++, q++;
  80149a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80149f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014a4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014ae:	74 1d                	je     8014cd <strncmp+0x49>
  8014b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b4:	0f b6 00             	movzbl (%rax),%eax
  8014b7:	84 c0                	test   %al,%al
  8014b9:	74 12                	je     8014cd <strncmp+0x49>
  8014bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bf:	0f b6 10             	movzbl (%rax),%edx
  8014c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c6:	0f b6 00             	movzbl (%rax),%eax
  8014c9:	38 c2                	cmp    %al,%dl
  8014cb:	74 cd                	je     80149a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014d2:	75 07                	jne    8014db <strncmp+0x57>
		return 0;
  8014d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d9:	eb 18                	jmp    8014f3 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014df:	0f b6 00             	movzbl (%rax),%eax
  8014e2:	0f b6 d0             	movzbl %al,%edx
  8014e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e9:	0f b6 00             	movzbl (%rax),%eax
  8014ec:	0f b6 c0             	movzbl %al,%eax
  8014ef:	29 c2                	sub    %eax,%edx
  8014f1:	89 d0                	mov    %edx,%eax
}
  8014f3:	c9                   	leaveq 
  8014f4:	c3                   	retq   

00000000008014f5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014f5:	55                   	push   %rbp
  8014f6:	48 89 e5             	mov    %rsp,%rbp
  8014f9:	48 83 ec 10          	sub    $0x10,%rsp
  8014fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801501:	89 f0                	mov    %esi,%eax
  801503:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801506:	eb 17                	jmp    80151f <strchr+0x2a>
		if (*s == c)
  801508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150c:	0f b6 00             	movzbl (%rax),%eax
  80150f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801512:	75 06                	jne    80151a <strchr+0x25>
			return (char *) s;
  801514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801518:	eb 15                	jmp    80152f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80151a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80151f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801523:	0f b6 00             	movzbl (%rax),%eax
  801526:	84 c0                	test   %al,%al
  801528:	75 de                	jne    801508 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80152a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152f:	c9                   	leaveq 
  801530:	c3                   	retq   

0000000000801531 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801531:	55                   	push   %rbp
  801532:	48 89 e5             	mov    %rsp,%rbp
  801535:	48 83 ec 10          	sub    $0x10,%rsp
  801539:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80153d:	89 f0                	mov    %esi,%eax
  80153f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801542:	eb 11                	jmp    801555 <strfind+0x24>
		if (*s == c)
  801544:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801548:	0f b6 00             	movzbl (%rax),%eax
  80154b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80154e:	74 12                	je     801562 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801550:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801555:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801559:	0f b6 00             	movzbl (%rax),%eax
  80155c:	84 c0                	test   %al,%al
  80155e:	75 e4                	jne    801544 <strfind+0x13>
  801560:	eb 01                	jmp    801563 <strfind+0x32>
		if (*s == c)
			break;
  801562:	90                   	nop
	return (char *) s;
  801563:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801567:	c9                   	leaveq 
  801568:	c3                   	retq   

0000000000801569 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801569:	55                   	push   %rbp
  80156a:	48 89 e5             	mov    %rsp,%rbp
  80156d:	48 83 ec 18          	sub    $0x18,%rsp
  801571:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801575:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801578:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80157c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801581:	75 06                	jne    801589 <memset+0x20>
		return v;
  801583:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801587:	eb 69                	jmp    8015f2 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158d:	83 e0 03             	and    $0x3,%eax
  801590:	48 85 c0             	test   %rax,%rax
  801593:	75 48                	jne    8015dd <memset+0x74>
  801595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801599:	83 e0 03             	and    $0x3,%eax
  80159c:	48 85 c0             	test   %rax,%rax
  80159f:	75 3c                	jne    8015dd <memset+0x74>
		c &= 0xFF;
  8015a1:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ab:	c1 e0 18             	shl    $0x18,%eax
  8015ae:	89 c2                	mov    %eax,%edx
  8015b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015b3:	c1 e0 10             	shl    $0x10,%eax
  8015b6:	09 c2                	or     %eax,%edx
  8015b8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015bb:	c1 e0 08             	shl    $0x8,%eax
  8015be:	09 d0                	or     %edx,%eax
  8015c0:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c7:	48 c1 e8 02          	shr    $0x2,%rax
  8015cb:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015ce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015d5:	48 89 d7             	mov    %rdx,%rdi
  8015d8:	fc                   	cld    
  8015d9:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015db:	eb 11                	jmp    8015ee <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015dd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015e8:	48 89 d7             	mov    %rdx,%rdi
  8015eb:	fc                   	cld    
  8015ec:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8015ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015f2:	c9                   	leaveq 
  8015f3:	c3                   	retq   

00000000008015f4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015f4:	55                   	push   %rbp
  8015f5:	48 89 e5             	mov    %rsp,%rbp
  8015f8:	48 83 ec 28          	sub    $0x28,%rsp
  8015fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801600:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801604:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801608:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80160c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801610:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801614:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801618:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801620:	0f 83 88 00 00 00    	jae    8016ae <memmove+0xba>
  801626:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80162a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162e:	48 01 d0             	add    %rdx,%rax
  801631:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801635:	76 77                	jbe    8016ae <memmove+0xba>
		s += n;
  801637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80163f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801643:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801647:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164b:	83 e0 03             	and    $0x3,%eax
  80164e:	48 85 c0             	test   %rax,%rax
  801651:	75 3b                	jne    80168e <memmove+0x9a>
  801653:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801657:	83 e0 03             	and    $0x3,%eax
  80165a:	48 85 c0             	test   %rax,%rax
  80165d:	75 2f                	jne    80168e <memmove+0x9a>
  80165f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801663:	83 e0 03             	and    $0x3,%eax
  801666:	48 85 c0             	test   %rax,%rax
  801669:	75 23                	jne    80168e <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80166b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166f:	48 83 e8 04          	sub    $0x4,%rax
  801673:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801677:	48 83 ea 04          	sub    $0x4,%rdx
  80167b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80167f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801683:	48 89 c7             	mov    %rax,%rdi
  801686:	48 89 d6             	mov    %rdx,%rsi
  801689:	fd                   	std    
  80168a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80168c:	eb 1d                	jmp    8016ab <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80168e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801692:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801696:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169a:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80169e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a2:	48 89 d7             	mov    %rdx,%rdi
  8016a5:	48 89 c1             	mov    %rax,%rcx
  8016a8:	fd                   	std    
  8016a9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016ab:	fc                   	cld    
  8016ac:	eb 57                	jmp    801705 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b2:	83 e0 03             	and    $0x3,%eax
  8016b5:	48 85 c0             	test   %rax,%rax
  8016b8:	75 36                	jne    8016f0 <memmove+0xfc>
  8016ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016be:	83 e0 03             	and    $0x3,%eax
  8016c1:	48 85 c0             	test   %rax,%rax
  8016c4:	75 2a                	jne    8016f0 <memmove+0xfc>
  8016c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ca:	83 e0 03             	and    $0x3,%eax
  8016cd:	48 85 c0             	test   %rax,%rax
  8016d0:	75 1e                	jne    8016f0 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d6:	48 c1 e8 02          	shr    $0x2,%rax
  8016da:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016e5:	48 89 c7             	mov    %rax,%rdi
  8016e8:	48 89 d6             	mov    %rdx,%rsi
  8016eb:	fc                   	cld    
  8016ec:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016ee:	eb 15                	jmp    801705 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016f8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016fc:	48 89 c7             	mov    %rax,%rdi
  8016ff:	48 89 d6             	mov    %rdx,%rsi
  801702:	fc                   	cld    
  801703:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801709:	c9                   	leaveq 
  80170a:	c3                   	retq   

000000000080170b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80170b:	55                   	push   %rbp
  80170c:	48 89 e5             	mov    %rsp,%rbp
  80170f:	48 83 ec 18          	sub    $0x18,%rsp
  801713:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801717:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80171b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80171f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801723:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801727:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80172b:	48 89 ce             	mov    %rcx,%rsi
  80172e:	48 89 c7             	mov    %rax,%rdi
  801731:	48 b8 f4 15 80 00 00 	movabs $0x8015f4,%rax
  801738:	00 00 00 
  80173b:	ff d0                	callq  *%rax
}
  80173d:	c9                   	leaveq 
  80173e:	c3                   	retq   

000000000080173f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80173f:	55                   	push   %rbp
  801740:	48 89 e5             	mov    %rsp,%rbp
  801743:	48 83 ec 28          	sub    $0x28,%rsp
  801747:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80174b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80174f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801753:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801757:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80175b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80175f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801763:	eb 36                	jmp    80179b <memcmp+0x5c>
		if (*s1 != *s2)
  801765:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801769:	0f b6 10             	movzbl (%rax),%edx
  80176c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801770:	0f b6 00             	movzbl (%rax),%eax
  801773:	38 c2                	cmp    %al,%dl
  801775:	74 1a                	je     801791 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801777:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177b:	0f b6 00             	movzbl (%rax),%eax
  80177e:	0f b6 d0             	movzbl %al,%edx
  801781:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801785:	0f b6 00             	movzbl (%rax),%eax
  801788:	0f b6 c0             	movzbl %al,%eax
  80178b:	29 c2                	sub    %eax,%edx
  80178d:	89 d0                	mov    %edx,%eax
  80178f:	eb 20                	jmp    8017b1 <memcmp+0x72>
		s1++, s2++;
  801791:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801796:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80179b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017a7:	48 85 c0             	test   %rax,%rax
  8017aa:	75 b9                	jne    801765 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b1:	c9                   	leaveq 
  8017b2:	c3                   	retq   

00000000008017b3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017b3:	55                   	push   %rbp
  8017b4:	48 89 e5             	mov    %rsp,%rbp
  8017b7:	48 83 ec 28          	sub    $0x28,%rsp
  8017bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017bf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ce:	48 01 d0             	add    %rdx,%rax
  8017d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017d5:	eb 19                	jmp    8017f0 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017db:	0f b6 00             	movzbl (%rax),%eax
  8017de:	0f b6 d0             	movzbl %al,%edx
  8017e1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017e4:	0f b6 c0             	movzbl %al,%eax
  8017e7:	39 c2                	cmp    %eax,%edx
  8017e9:	74 11                	je     8017fc <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017eb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f4:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8017f8:	72 dd                	jb     8017d7 <memfind+0x24>
  8017fa:	eb 01                	jmp    8017fd <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8017fc:	90                   	nop
	return (void *) s;
  8017fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801801:	c9                   	leaveq 
  801802:	c3                   	retq   

0000000000801803 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801803:	55                   	push   %rbp
  801804:	48 89 e5             	mov    %rsp,%rbp
  801807:	48 83 ec 38          	sub    $0x38,%rsp
  80180b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80180f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801813:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801816:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80181d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801824:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801825:	eb 05                	jmp    80182c <strtol+0x29>
		s++;
  801827:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80182c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801830:	0f b6 00             	movzbl (%rax),%eax
  801833:	3c 20                	cmp    $0x20,%al
  801835:	74 f0                	je     801827 <strtol+0x24>
  801837:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183b:	0f b6 00             	movzbl (%rax),%eax
  80183e:	3c 09                	cmp    $0x9,%al
  801840:	74 e5                	je     801827 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801842:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801846:	0f b6 00             	movzbl (%rax),%eax
  801849:	3c 2b                	cmp    $0x2b,%al
  80184b:	75 07                	jne    801854 <strtol+0x51>
		s++;
  80184d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801852:	eb 17                	jmp    80186b <strtol+0x68>
	else if (*s == '-')
  801854:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801858:	0f b6 00             	movzbl (%rax),%eax
  80185b:	3c 2d                	cmp    $0x2d,%al
  80185d:	75 0c                	jne    80186b <strtol+0x68>
		s++, neg = 1;
  80185f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801864:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80186b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80186f:	74 06                	je     801877 <strtol+0x74>
  801871:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801875:	75 28                	jne    80189f <strtol+0x9c>
  801877:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187b:	0f b6 00             	movzbl (%rax),%eax
  80187e:	3c 30                	cmp    $0x30,%al
  801880:	75 1d                	jne    80189f <strtol+0x9c>
  801882:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801886:	48 83 c0 01          	add    $0x1,%rax
  80188a:	0f b6 00             	movzbl (%rax),%eax
  80188d:	3c 78                	cmp    $0x78,%al
  80188f:	75 0e                	jne    80189f <strtol+0x9c>
		s += 2, base = 16;
  801891:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801896:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80189d:	eb 2c                	jmp    8018cb <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80189f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018a3:	75 19                	jne    8018be <strtol+0xbb>
  8018a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a9:	0f b6 00             	movzbl (%rax),%eax
  8018ac:	3c 30                	cmp    $0x30,%al
  8018ae:	75 0e                	jne    8018be <strtol+0xbb>
		s++, base = 8;
  8018b0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018b5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018bc:	eb 0d                	jmp    8018cb <strtol+0xc8>
	else if (base == 0)
  8018be:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018c2:	75 07                	jne    8018cb <strtol+0xc8>
		base = 10;
  8018c4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018cf:	0f b6 00             	movzbl (%rax),%eax
  8018d2:	3c 2f                	cmp    $0x2f,%al
  8018d4:	7e 1d                	jle    8018f3 <strtol+0xf0>
  8018d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018da:	0f b6 00             	movzbl (%rax),%eax
  8018dd:	3c 39                	cmp    $0x39,%al
  8018df:	7f 12                	jg     8018f3 <strtol+0xf0>
			dig = *s - '0';
  8018e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e5:	0f b6 00             	movzbl (%rax),%eax
  8018e8:	0f be c0             	movsbl %al,%eax
  8018eb:	83 e8 30             	sub    $0x30,%eax
  8018ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018f1:	eb 4e                	jmp    801941 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8018f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f7:	0f b6 00             	movzbl (%rax),%eax
  8018fa:	3c 60                	cmp    $0x60,%al
  8018fc:	7e 1d                	jle    80191b <strtol+0x118>
  8018fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801902:	0f b6 00             	movzbl (%rax),%eax
  801905:	3c 7a                	cmp    $0x7a,%al
  801907:	7f 12                	jg     80191b <strtol+0x118>
			dig = *s - 'a' + 10;
  801909:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190d:	0f b6 00             	movzbl (%rax),%eax
  801910:	0f be c0             	movsbl %al,%eax
  801913:	83 e8 57             	sub    $0x57,%eax
  801916:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801919:	eb 26                	jmp    801941 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80191b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191f:	0f b6 00             	movzbl (%rax),%eax
  801922:	3c 40                	cmp    $0x40,%al
  801924:	7e 47                	jle    80196d <strtol+0x16a>
  801926:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192a:	0f b6 00             	movzbl (%rax),%eax
  80192d:	3c 5a                	cmp    $0x5a,%al
  80192f:	7f 3c                	jg     80196d <strtol+0x16a>
			dig = *s - 'A' + 10;
  801931:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801935:	0f b6 00             	movzbl (%rax),%eax
  801938:	0f be c0             	movsbl %al,%eax
  80193b:	83 e8 37             	sub    $0x37,%eax
  80193e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801941:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801944:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801947:	7d 23                	jge    80196c <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801949:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80194e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801951:	48 98                	cltq   
  801953:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801958:	48 89 c2             	mov    %rax,%rdx
  80195b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80195e:	48 98                	cltq   
  801960:	48 01 d0             	add    %rdx,%rax
  801963:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801967:	e9 5f ff ff ff       	jmpq   8018cb <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80196c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80196d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801972:	74 0b                	je     80197f <strtol+0x17c>
		*endptr = (char *) s;
  801974:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801978:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80197c:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80197f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801983:	74 09                	je     80198e <strtol+0x18b>
  801985:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801989:	48 f7 d8             	neg    %rax
  80198c:	eb 04                	jmp    801992 <strtol+0x18f>
  80198e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801992:	c9                   	leaveq 
  801993:	c3                   	retq   

0000000000801994 <strstr>:

char * strstr(const char *in, const char *str)
{
  801994:	55                   	push   %rbp
  801995:	48 89 e5             	mov    %rsp,%rbp
  801998:	48 83 ec 30          	sub    $0x30,%rsp
  80199c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019a0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019a8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019ac:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019b0:	0f b6 00             	movzbl (%rax),%eax
  8019b3:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019b6:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019ba:	75 06                	jne    8019c2 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c0:	eb 6b                	jmp    801a2d <strstr+0x99>

	len = strlen(str);
  8019c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019c6:	48 89 c7             	mov    %rax,%rdi
  8019c9:	48 b8 63 12 80 00 00 	movabs $0x801263,%rax
  8019d0:	00 00 00 
  8019d3:	ff d0                	callq  *%rax
  8019d5:	48 98                	cltq   
  8019d7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019df:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019e7:	0f b6 00             	movzbl (%rax),%eax
  8019ea:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8019ed:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019f1:	75 07                	jne    8019fa <strstr+0x66>
				return (char *) 0;
  8019f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f8:	eb 33                	jmp    801a2d <strstr+0x99>
		} while (sc != c);
  8019fa:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8019fe:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a01:	75 d8                	jne    8019db <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a07:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0f:	48 89 ce             	mov    %rcx,%rsi
  801a12:	48 89 c7             	mov    %rax,%rdi
  801a15:	48 b8 84 14 80 00 00 	movabs $0x801484,%rax
  801a1c:	00 00 00 
  801a1f:	ff d0                	callq  *%rax
  801a21:	85 c0                	test   %eax,%eax
  801a23:	75 b6                	jne    8019db <strstr+0x47>

	return (char *) (in - 1);
  801a25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a29:	48 83 e8 01          	sub    $0x1,%rax
}
  801a2d:	c9                   	leaveq 
  801a2e:	c3                   	retq   
