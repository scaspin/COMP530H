
obj/user/buggyhello:     file format elf64-x86-64


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
  80003c:	e8 2a 00 00 00       	callq  80006b <libmain>
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
	sys_cputs((char*)1, 1);
  800052:	be 01 00 00 00       	mov    $0x1,%esi
  800057:	bf 01 00 00 00       	mov    $0x1,%edi
  80005c:	48 b8 9d 01 80 00 00 	movabs $0x80019d,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
}
  800068:	90                   	nop
  800069:	c9                   	leaveq 
  80006a:	c3                   	retq   

000000000080006b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006b:	55                   	push   %rbp
  80006c:	48 89 e5             	mov    %rsp,%rbp
  80006f:	48 83 ec 10          	sub    $0x10,%rsp
  800073:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800076:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  80007a:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  800081:	00 00 00 
  800084:	ff d0                	callq  *%rax
  800086:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008b:	48 63 d0             	movslq %eax,%rdx
  80008e:	48 89 d0             	mov    %rdx,%rax
  800091:	48 c1 e0 03          	shl    $0x3,%rax
  800095:	48 01 d0             	add    %rdx,%rax
  800098:	48 c1 e0 05          	shl    $0x5,%rax
  80009c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000a3:	00 00 00 
  8000a6:	48 01 c2             	add    %rax,%rdx
  8000a9:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000b0:	00 00 00 
  8000b3:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000ba:	7e 14                	jle    8000d0 <libmain+0x65>
		binaryname = argv[0];
  8000bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000c0:	48 8b 10             	mov    (%rax),%rdx
  8000c3:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000ca:	00 00 00 
  8000cd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d7:	48 89 d6             	mov    %rdx,%rsi
  8000da:	89 c7                	mov    %eax,%edi
  8000dc:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000e3:	00 00 00 
  8000e6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000e8:	48 b8 f7 00 80 00 00 	movabs $0x8000f7,%rax
  8000ef:	00 00 00 
  8000f2:	ff d0                	callq  *%rax
}
  8000f4:	90                   	nop
  8000f5:	c9                   	leaveq 
  8000f6:	c3                   	retq   

00000000008000f7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f7:	55                   	push   %rbp
  8000f8:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000fb:	bf 00 00 00 00       	mov    $0x0,%edi
  800100:	48 b8 26 02 80 00 00 	movabs $0x800226,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax
}
  80010c:	90                   	nop
  80010d:	5d                   	pop    %rbp
  80010e:	c3                   	retq   

000000000080010f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80010f:	55                   	push   %rbp
  800110:	48 89 e5             	mov    %rsp,%rbp
  800113:	53                   	push   %rbx
  800114:	48 83 ec 48          	sub    $0x48,%rsp
  800118:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80011b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80011e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800122:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800126:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80012a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80012e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800131:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800135:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800139:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80013d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800141:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800145:	4c 89 c3             	mov    %r8,%rbx
  800148:	cd 30                	int    $0x30
  80014a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80014e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800152:	74 3e                	je     800192 <syscall+0x83>
  800154:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800159:	7e 37                	jle    800192 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80015b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80015f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800162:	49 89 d0             	mov    %rdx,%r8
  800165:	89 c1                	mov    %eax,%ecx
  800167:	48 ba 6a 1a 80 00 00 	movabs $0x801a6a,%rdx
  80016e:	00 00 00 
  800171:	be 23 00 00 00       	mov    $0x23,%esi
  800176:	48 bf 87 1a 80 00 00 	movabs $0x801a87,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	49 b9 19 05 80 00 00 	movabs $0x800519,%r9
  80018c:	00 00 00 
  80018f:	41 ff d1             	callq  *%r9

	return ret;
  800192:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800196:	48 83 c4 48          	add    $0x48,%rsp
  80019a:	5b                   	pop    %rbx
  80019b:	5d                   	pop    %rbp
  80019c:	c3                   	retq   

000000000080019d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80019d:	55                   	push   %rbp
  80019e:	48 89 e5             	mov    %rsp,%rbp
  8001a1:	48 83 ec 10          	sub    $0x10,%rsp
  8001a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b5:	48 83 ec 08          	sub    $0x8,%rsp
  8001b9:	6a 00                	pushq  $0x0
  8001bb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001c1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001c7:	48 89 d1             	mov    %rdx,%rcx
  8001ca:	48 89 c2             	mov    %rax,%rdx
  8001cd:	be 00 00 00 00       	mov    $0x0,%esi
  8001d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8001d7:	48 b8 0f 01 80 00 00 	movabs $0x80010f,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	callq  *%rax
  8001e3:	48 83 c4 10          	add    $0x10,%rsp
}
  8001e7:	90                   	nop
  8001e8:	c9                   	leaveq 
  8001e9:	c3                   	retq   

00000000008001ea <sys_cgetc>:

int
sys_cgetc(void)
{
  8001ea:	55                   	push   %rbp
  8001eb:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001ee:	48 83 ec 08          	sub    $0x8,%rsp
  8001f2:	6a 00                	pushq  $0x0
  8001f4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800200:	b9 00 00 00 00       	mov    $0x0,%ecx
  800205:	ba 00 00 00 00       	mov    $0x0,%edx
  80020a:	be 00 00 00 00       	mov    $0x0,%esi
  80020f:	bf 01 00 00 00       	mov    $0x1,%edi
  800214:	48 b8 0f 01 80 00 00 	movabs $0x80010f,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
  800220:	48 83 c4 10          	add    $0x10,%rsp
}
  800224:	c9                   	leaveq 
  800225:	c3                   	retq   

0000000000800226 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800226:	55                   	push   %rbp
  800227:	48 89 e5             	mov    %rsp,%rbp
  80022a:	48 83 ec 10          	sub    $0x10,%rsp
  80022e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800231:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800234:	48 98                	cltq   
  800236:	48 83 ec 08          	sub    $0x8,%rsp
  80023a:	6a 00                	pushq  $0x0
  80023c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800242:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800248:	b9 00 00 00 00       	mov    $0x0,%ecx
  80024d:	48 89 c2             	mov    %rax,%rdx
  800250:	be 01 00 00 00       	mov    $0x1,%esi
  800255:	bf 03 00 00 00       	mov    $0x3,%edi
  80025a:	48 b8 0f 01 80 00 00 	movabs $0x80010f,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
  800266:	48 83 c4 10          	add    $0x10,%rsp
}
  80026a:	c9                   	leaveq 
  80026b:	c3                   	retq   

000000000080026c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80026c:	55                   	push   %rbp
  80026d:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800270:	48 83 ec 08          	sub    $0x8,%rsp
  800274:	6a 00                	pushq  $0x0
  800276:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80027c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800282:	b9 00 00 00 00       	mov    $0x0,%ecx
  800287:	ba 00 00 00 00       	mov    $0x0,%edx
  80028c:	be 00 00 00 00       	mov    $0x0,%esi
  800291:	bf 02 00 00 00       	mov    $0x2,%edi
  800296:	48 b8 0f 01 80 00 00 	movabs $0x80010f,%rax
  80029d:	00 00 00 
  8002a0:	ff d0                	callq  *%rax
  8002a2:	48 83 c4 10          	add    $0x10,%rsp
}
  8002a6:	c9                   	leaveq 
  8002a7:	c3                   	retq   

00000000008002a8 <sys_yield>:

void
sys_yield(void)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002ac:	48 83 ec 08          	sub    $0x8,%rsp
  8002b0:	6a 00                	pushq  $0x0
  8002b2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c8:	be 00 00 00 00       	mov    $0x0,%esi
  8002cd:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002d2:	48 b8 0f 01 80 00 00 	movabs $0x80010f,%rax
  8002d9:	00 00 00 
  8002dc:	ff d0                	callq  *%rax
  8002de:	48 83 c4 10          	add    $0x10,%rsp
}
  8002e2:	90                   	nop
  8002e3:	c9                   	leaveq 
  8002e4:	c3                   	retq   

00000000008002e5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002e5:	55                   	push   %rbp
  8002e6:	48 89 e5             	mov    %rsp,%rbp
  8002e9:	48 83 ec 10          	sub    $0x10,%rsp
  8002ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002f4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002fa:	48 63 c8             	movslq %eax,%rcx
  8002fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800301:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800304:	48 98                	cltq   
  800306:	48 83 ec 08          	sub    $0x8,%rsp
  80030a:	6a 00                	pushq  $0x0
  80030c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800312:	49 89 c8             	mov    %rcx,%r8
  800315:	48 89 d1             	mov    %rdx,%rcx
  800318:	48 89 c2             	mov    %rax,%rdx
  80031b:	be 01 00 00 00       	mov    $0x1,%esi
  800320:	bf 04 00 00 00       	mov    $0x4,%edi
  800325:	48 b8 0f 01 80 00 00 	movabs $0x80010f,%rax
  80032c:	00 00 00 
  80032f:	ff d0                	callq  *%rax
  800331:	48 83 c4 10          	add    $0x10,%rsp
}
  800335:	c9                   	leaveq 
  800336:	c3                   	retq   

0000000000800337 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800337:	55                   	push   %rbp
  800338:	48 89 e5             	mov    %rsp,%rbp
  80033b:	48 83 ec 20          	sub    $0x20,%rsp
  80033f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800342:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800346:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800349:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80034d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800351:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800354:	48 63 c8             	movslq %eax,%rcx
  800357:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80035b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80035e:	48 63 f0             	movslq %eax,%rsi
  800361:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800365:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800368:	48 98                	cltq   
  80036a:	48 83 ec 08          	sub    $0x8,%rsp
  80036e:	51                   	push   %rcx
  80036f:	49 89 f9             	mov    %rdi,%r9
  800372:	49 89 f0             	mov    %rsi,%r8
  800375:	48 89 d1             	mov    %rdx,%rcx
  800378:	48 89 c2             	mov    %rax,%rdx
  80037b:	be 01 00 00 00       	mov    $0x1,%esi
  800380:	bf 05 00 00 00       	mov    $0x5,%edi
  800385:	48 b8 0f 01 80 00 00 	movabs $0x80010f,%rax
  80038c:	00 00 00 
  80038f:	ff d0                	callq  *%rax
  800391:	48 83 c4 10          	add    $0x10,%rsp
}
  800395:	c9                   	leaveq 
  800396:	c3                   	retq   

0000000000800397 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800397:	55                   	push   %rbp
  800398:	48 89 e5             	mov    %rsp,%rbp
  80039b:	48 83 ec 10          	sub    $0x10,%rsp
  80039f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ad:	48 98                	cltq   
  8003af:	48 83 ec 08          	sub    $0x8,%rsp
  8003b3:	6a 00                	pushq  $0x0
  8003b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003c1:	48 89 d1             	mov    %rdx,%rcx
  8003c4:	48 89 c2             	mov    %rax,%rdx
  8003c7:	be 01 00 00 00       	mov    $0x1,%esi
  8003cc:	bf 06 00 00 00       	mov    $0x6,%edi
  8003d1:	48 b8 0f 01 80 00 00 	movabs $0x80010f,%rax
  8003d8:	00 00 00 
  8003db:	ff d0                	callq  *%rax
  8003dd:	48 83 c4 10          	add    $0x10,%rsp
}
  8003e1:	c9                   	leaveq 
  8003e2:	c3                   	retq   

00000000008003e3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003e3:	55                   	push   %rbp
  8003e4:	48 89 e5             	mov    %rsp,%rbp
  8003e7:	48 83 ec 10          	sub    $0x10,%rsp
  8003eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ee:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003f4:	48 63 d0             	movslq %eax,%rdx
  8003f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003fa:	48 98                	cltq   
  8003fc:	48 83 ec 08          	sub    $0x8,%rsp
  800400:	6a 00                	pushq  $0x0
  800402:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800408:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80040e:	48 89 d1             	mov    %rdx,%rcx
  800411:	48 89 c2             	mov    %rax,%rdx
  800414:	be 01 00 00 00       	mov    $0x1,%esi
  800419:	bf 08 00 00 00       	mov    $0x8,%edi
  80041e:	48 b8 0f 01 80 00 00 	movabs $0x80010f,%rax
  800425:	00 00 00 
  800428:	ff d0                	callq  *%rax
  80042a:	48 83 c4 10          	add    $0x10,%rsp
}
  80042e:	c9                   	leaveq 
  80042f:	c3                   	retq   

0000000000800430 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800430:	55                   	push   %rbp
  800431:	48 89 e5             	mov    %rsp,%rbp
  800434:	48 83 ec 10          	sub    $0x10,%rsp
  800438:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80043b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80043f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800443:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800446:	48 98                	cltq   
  800448:	48 83 ec 08          	sub    $0x8,%rsp
  80044c:	6a 00                	pushq  $0x0
  80044e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800454:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80045a:	48 89 d1             	mov    %rdx,%rcx
  80045d:	48 89 c2             	mov    %rax,%rdx
  800460:	be 01 00 00 00       	mov    $0x1,%esi
  800465:	bf 09 00 00 00       	mov    $0x9,%edi
  80046a:	48 b8 0f 01 80 00 00 	movabs $0x80010f,%rax
  800471:	00 00 00 
  800474:	ff d0                	callq  *%rax
  800476:	48 83 c4 10          	add    $0x10,%rsp
}
  80047a:	c9                   	leaveq 
  80047b:	c3                   	retq   

000000000080047c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80047c:	55                   	push   %rbp
  80047d:	48 89 e5             	mov    %rsp,%rbp
  800480:	48 83 ec 20          	sub    $0x20,%rsp
  800484:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800487:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80048b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80048f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800492:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800495:	48 63 f0             	movslq %eax,%rsi
  800498:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80049c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049f:	48 98                	cltq   
  8004a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004a5:	48 83 ec 08          	sub    $0x8,%rsp
  8004a9:	6a 00                	pushq  $0x0
  8004ab:	49 89 f1             	mov    %rsi,%r9
  8004ae:	49 89 c8             	mov    %rcx,%r8
  8004b1:	48 89 d1             	mov    %rdx,%rcx
  8004b4:	48 89 c2             	mov    %rax,%rdx
  8004b7:	be 00 00 00 00       	mov    $0x0,%esi
  8004bc:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004c1:	48 b8 0f 01 80 00 00 	movabs $0x80010f,%rax
  8004c8:	00 00 00 
  8004cb:	ff d0                	callq  *%rax
  8004cd:	48 83 c4 10          	add    $0x10,%rsp
}
  8004d1:	c9                   	leaveq 
  8004d2:	c3                   	retq   

00000000008004d3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004d3:	55                   	push   %rbp
  8004d4:	48 89 e5             	mov    %rsp,%rbp
  8004d7:	48 83 ec 10          	sub    $0x10,%rsp
  8004db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e3:	48 83 ec 08          	sub    $0x8,%rsp
  8004e7:	6a 00                	pushq  $0x0
  8004e9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004fa:	48 89 c2             	mov    %rax,%rdx
  8004fd:	be 01 00 00 00       	mov    $0x1,%esi
  800502:	bf 0c 00 00 00       	mov    $0xc,%edi
  800507:	48 b8 0f 01 80 00 00 	movabs $0x80010f,%rax
  80050e:	00 00 00 
  800511:	ff d0                	callq  *%rax
  800513:	48 83 c4 10          	add    $0x10,%rsp
}
  800517:	c9                   	leaveq 
  800518:	c3                   	retq   

0000000000800519 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800519:	55                   	push   %rbp
  80051a:	48 89 e5             	mov    %rsp,%rbp
  80051d:	53                   	push   %rbx
  80051e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800525:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80052c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800532:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800539:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800540:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800547:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80054e:	84 c0                	test   %al,%al
  800550:	74 23                	je     800575 <_panic+0x5c>
  800552:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800559:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80055d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800561:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800565:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800569:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80056d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800571:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800575:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80057c:	00 00 00 
  80057f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800586:	00 00 00 
  800589:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80058d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800594:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80059b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005a2:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8005a9:	00 00 00 
  8005ac:	48 8b 18             	mov    (%rax),%rbx
  8005af:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  8005b6:	00 00 00 
  8005b9:	ff d0                	callq  *%rax
  8005bb:	89 c6                	mov    %eax,%esi
  8005bd:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8005c3:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8005ca:	41 89 d0             	mov    %edx,%r8d
  8005cd:	48 89 c1             	mov    %rax,%rcx
  8005d0:	48 89 da             	mov    %rbx,%rdx
  8005d3:	48 bf 98 1a 80 00 00 	movabs $0x801a98,%rdi
  8005da:	00 00 00 
  8005dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e2:	49 b9 53 07 80 00 00 	movabs $0x800753,%r9
  8005e9:	00 00 00 
  8005ec:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005ef:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005f6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005fd:	48 89 d6             	mov    %rdx,%rsi
  800600:	48 89 c7             	mov    %rax,%rdi
  800603:	48 b8 a7 06 80 00 00 	movabs $0x8006a7,%rax
  80060a:	00 00 00 
  80060d:	ff d0                	callq  *%rax
	cprintf("\n");
  80060f:	48 bf bb 1a 80 00 00 	movabs $0x801abb,%rdi
  800616:	00 00 00 
  800619:	b8 00 00 00 00       	mov    $0x0,%eax
  80061e:	48 ba 53 07 80 00 00 	movabs $0x800753,%rdx
  800625:	00 00 00 
  800628:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80062a:	cc                   	int3   
  80062b:	eb fd                	jmp    80062a <_panic+0x111>

000000000080062d <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80062d:	55                   	push   %rbp
  80062e:	48 89 e5             	mov    %rsp,%rbp
  800631:	48 83 ec 10          	sub    $0x10,%rsp
  800635:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800638:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80063c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800640:	8b 00                	mov    (%rax),%eax
  800642:	8d 48 01             	lea    0x1(%rax),%ecx
  800645:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800649:	89 0a                	mov    %ecx,(%rdx)
  80064b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80064e:	89 d1                	mov    %edx,%ecx
  800650:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800654:	48 98                	cltq   
  800656:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80065a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80065e:	8b 00                	mov    (%rax),%eax
  800660:	3d ff 00 00 00       	cmp    $0xff,%eax
  800665:	75 2c                	jne    800693 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800667:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80066b:	8b 00                	mov    (%rax),%eax
  80066d:	48 98                	cltq   
  80066f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800673:	48 83 c2 08          	add    $0x8,%rdx
  800677:	48 89 c6             	mov    %rax,%rsi
  80067a:	48 89 d7             	mov    %rdx,%rdi
  80067d:	48 b8 9d 01 80 00 00 	movabs $0x80019d,%rax
  800684:	00 00 00 
  800687:	ff d0                	callq  *%rax
        b->idx = 0;
  800689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800693:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800697:	8b 40 04             	mov    0x4(%rax),%eax
  80069a:	8d 50 01             	lea    0x1(%rax),%edx
  80069d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a1:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006a4:	90                   	nop
  8006a5:	c9                   	leaveq 
  8006a6:	c3                   	retq   

00000000008006a7 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8006a7:	55                   	push   %rbp
  8006a8:	48 89 e5             	mov    %rsp,%rbp
  8006ab:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006b2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006b9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006c0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006c7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006ce:	48 8b 0a             	mov    (%rdx),%rcx
  8006d1:	48 89 08             	mov    %rcx,(%rax)
  8006d4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006dc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006e4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006eb:	00 00 00 
    b.cnt = 0;
  8006ee:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006f5:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006f8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006ff:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800706:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80070d:	48 89 c6             	mov    %rax,%rsi
  800710:	48 bf 2d 06 80 00 00 	movabs $0x80062d,%rdi
  800717:	00 00 00 
  80071a:	48 b8 f1 0a 80 00 00 	movabs $0x800af1,%rax
  800721:	00 00 00 
  800724:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800726:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80072c:	48 98                	cltq   
  80072e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800735:	48 83 c2 08          	add    $0x8,%rdx
  800739:	48 89 c6             	mov    %rax,%rsi
  80073c:	48 89 d7             	mov    %rdx,%rdi
  80073f:	48 b8 9d 01 80 00 00 	movabs $0x80019d,%rax
  800746:	00 00 00 
  800749:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80074b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800751:	c9                   	leaveq 
  800752:	c3                   	retq   

0000000000800753 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800753:	55                   	push   %rbp
  800754:	48 89 e5             	mov    %rsp,%rbp
  800757:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80075e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800765:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80076c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800773:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80077a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800781:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800788:	84 c0                	test   %al,%al
  80078a:	74 20                	je     8007ac <cprintf+0x59>
  80078c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800790:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800794:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800798:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80079c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8007a0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007a4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007a8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007ac:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007b3:	00 00 00 
  8007b6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007bd:	00 00 00 
  8007c0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007c4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007cb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007d2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007d9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007e0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007e7:	48 8b 0a             	mov    (%rdx),%rcx
  8007ea:	48 89 08             	mov    %rcx,(%rax)
  8007ed:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007f1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007f5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007f9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007fd:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800804:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80080b:	48 89 d6             	mov    %rdx,%rsi
  80080e:	48 89 c7             	mov    %rax,%rdi
  800811:	48 b8 a7 06 80 00 00 	movabs $0x8006a7,%rax
  800818:	00 00 00 
  80081b:	ff d0                	callq  *%rax
  80081d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800823:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800829:	c9                   	leaveq 
  80082a:	c3                   	retq   

000000000080082b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80082b:	55                   	push   %rbp
  80082c:	48 89 e5             	mov    %rsp,%rbp
  80082f:	48 83 ec 30          	sub    $0x30,%rsp
  800833:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800837:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80083b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80083f:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800842:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800846:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80084a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80084d:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800851:	77 54                	ja     8008a7 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800853:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800856:	8d 78 ff             	lea    -0x1(%rax),%edi
  800859:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80085c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800860:	ba 00 00 00 00       	mov    $0x0,%edx
  800865:	48 f7 f6             	div    %rsi
  800868:	49 89 c2             	mov    %rax,%r10
  80086b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80086e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800871:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800875:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800879:	41 89 c9             	mov    %ecx,%r9d
  80087c:	41 89 f8             	mov    %edi,%r8d
  80087f:	89 d1                	mov    %edx,%ecx
  800881:	4c 89 d2             	mov    %r10,%rdx
  800884:	48 89 c7             	mov    %rax,%rdi
  800887:	48 b8 2b 08 80 00 00 	movabs $0x80082b,%rax
  80088e:	00 00 00 
  800891:	ff d0                	callq  *%rax
  800893:	eb 1c                	jmp    8008b1 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800895:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800899:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80089c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008a0:	48 89 ce             	mov    %rcx,%rsi
  8008a3:	89 d7                	mov    %edx,%edi
  8008a5:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a7:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8008ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8008af:	7f e4                	jg     800895 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008b1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8008b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bd:	48 f7 f1             	div    %rcx
  8008c0:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  8008c7:	00 00 00 
  8008ca:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8008ce:	0f be d0             	movsbl %al,%edx
  8008d1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8008d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008d9:	48 89 ce             	mov    %rcx,%rsi
  8008dc:	89 d7                	mov    %edx,%edi
  8008de:	ff d0                	callq  *%rax
}
  8008e0:	90                   	nop
  8008e1:	c9                   	leaveq 
  8008e2:	c3                   	retq   

00000000008008e3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008e3:	55                   	push   %rbp
  8008e4:	48 89 e5             	mov    %rsp,%rbp
  8008e7:	48 83 ec 20          	sub    $0x20,%rsp
  8008eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008ef:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008f2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008f6:	7e 4f                	jle    800947 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8008f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fc:	8b 00                	mov    (%rax),%eax
  8008fe:	83 f8 30             	cmp    $0x30,%eax
  800901:	73 24                	jae    800927 <getuint+0x44>
  800903:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800907:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80090b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090f:	8b 00                	mov    (%rax),%eax
  800911:	89 c0                	mov    %eax,%eax
  800913:	48 01 d0             	add    %rdx,%rax
  800916:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091a:	8b 12                	mov    (%rdx),%edx
  80091c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80091f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800923:	89 0a                	mov    %ecx,(%rdx)
  800925:	eb 14                	jmp    80093b <getuint+0x58>
  800927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80092f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800933:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800937:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80093b:	48 8b 00             	mov    (%rax),%rax
  80093e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800942:	e9 9d 00 00 00       	jmpq   8009e4 <getuint+0x101>
	else if (lflag)
  800947:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80094b:	74 4c                	je     800999 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80094d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800951:	8b 00                	mov    (%rax),%eax
  800953:	83 f8 30             	cmp    $0x30,%eax
  800956:	73 24                	jae    80097c <getuint+0x99>
  800958:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800960:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800964:	8b 00                	mov    (%rax),%eax
  800966:	89 c0                	mov    %eax,%eax
  800968:	48 01 d0             	add    %rdx,%rax
  80096b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096f:	8b 12                	mov    (%rdx),%edx
  800971:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800974:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800978:	89 0a                	mov    %ecx,(%rdx)
  80097a:	eb 14                	jmp    800990 <getuint+0xad>
  80097c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800980:	48 8b 40 08          	mov    0x8(%rax),%rax
  800984:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800988:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800990:	48 8b 00             	mov    (%rax),%rax
  800993:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800997:	eb 4b                	jmp    8009e4 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099d:	8b 00                	mov    (%rax),%eax
  80099f:	83 f8 30             	cmp    $0x30,%eax
  8009a2:	73 24                	jae    8009c8 <getuint+0xe5>
  8009a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b0:	8b 00                	mov    (%rax),%eax
  8009b2:	89 c0                	mov    %eax,%eax
  8009b4:	48 01 d0             	add    %rdx,%rax
  8009b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009bb:	8b 12                	mov    (%rdx),%edx
  8009bd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c4:	89 0a                	mov    %ecx,(%rdx)
  8009c6:	eb 14                	jmp    8009dc <getuint+0xf9>
  8009c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cc:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009d0:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009dc:	8b 00                	mov    (%rax),%eax
  8009de:	89 c0                	mov    %eax,%eax
  8009e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009e8:	c9                   	leaveq 
  8009e9:	c3                   	retq   

00000000008009ea <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009ea:	55                   	push   %rbp
  8009eb:	48 89 e5             	mov    %rsp,%rbp
  8009ee:	48 83 ec 20          	sub    $0x20,%rsp
  8009f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009f6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009f9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009fd:	7e 4f                	jle    800a4e <getint+0x64>
		x=va_arg(*ap, long long);
  8009ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a03:	8b 00                	mov    (%rax),%eax
  800a05:	83 f8 30             	cmp    $0x30,%eax
  800a08:	73 24                	jae    800a2e <getint+0x44>
  800a0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a16:	8b 00                	mov    (%rax),%eax
  800a18:	89 c0                	mov    %eax,%eax
  800a1a:	48 01 d0             	add    %rdx,%rax
  800a1d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a21:	8b 12                	mov    (%rdx),%edx
  800a23:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2a:	89 0a                	mov    %ecx,(%rdx)
  800a2c:	eb 14                	jmp    800a42 <getint+0x58>
  800a2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a32:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a36:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a42:	48 8b 00             	mov    (%rax),%rax
  800a45:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a49:	e9 9d 00 00 00       	jmpq   800aeb <getint+0x101>
	else if (lflag)
  800a4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a52:	74 4c                	je     800aa0 <getint+0xb6>
		x=va_arg(*ap, long);
  800a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a58:	8b 00                	mov    (%rax),%eax
  800a5a:	83 f8 30             	cmp    $0x30,%eax
  800a5d:	73 24                	jae    800a83 <getint+0x99>
  800a5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a63:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6b:	8b 00                	mov    (%rax),%eax
  800a6d:	89 c0                	mov    %eax,%eax
  800a6f:	48 01 d0             	add    %rdx,%rax
  800a72:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a76:	8b 12                	mov    (%rdx),%edx
  800a78:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a7b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7f:	89 0a                	mov    %ecx,(%rdx)
  800a81:	eb 14                	jmp    800a97 <getint+0xad>
  800a83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a87:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a8b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a93:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a97:	48 8b 00             	mov    (%rax),%rax
  800a9a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a9e:	eb 4b                	jmp    800aeb <getint+0x101>
	else
		x=va_arg(*ap, int);
  800aa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa4:	8b 00                	mov    (%rax),%eax
  800aa6:	83 f8 30             	cmp    $0x30,%eax
  800aa9:	73 24                	jae    800acf <getint+0xe5>
  800aab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aaf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ab3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab7:	8b 00                	mov    (%rax),%eax
  800ab9:	89 c0                	mov    %eax,%eax
  800abb:	48 01 d0             	add    %rdx,%rax
  800abe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac2:	8b 12                	mov    (%rdx),%edx
  800ac4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ac7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800acb:	89 0a                	mov    %ecx,(%rdx)
  800acd:	eb 14                	jmp    800ae3 <getint+0xf9>
  800acf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad3:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ad7:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800adb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800adf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ae3:	8b 00                	mov    (%rax),%eax
  800ae5:	48 98                	cltq   
  800ae7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800aef:	c9                   	leaveq 
  800af0:	c3                   	retq   

0000000000800af1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800af1:	55                   	push   %rbp
  800af2:	48 89 e5             	mov    %rsp,%rbp
  800af5:	41 54                	push   %r12
  800af7:	53                   	push   %rbx
  800af8:	48 83 ec 60          	sub    $0x60,%rsp
  800afc:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b00:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b04:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b08:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b0c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b10:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b14:	48 8b 0a             	mov    (%rdx),%rcx
  800b17:	48 89 08             	mov    %rcx,(%rax)
  800b1a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b1e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b22:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b26:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b2a:	eb 17                	jmp    800b43 <vprintfmt+0x52>
			if (ch == '\0')
  800b2c:	85 db                	test   %ebx,%ebx
  800b2e:	0f 84 b9 04 00 00    	je     800fed <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800b34:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3c:	48 89 d6             	mov    %rdx,%rsi
  800b3f:	89 df                	mov    %ebx,%edi
  800b41:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b43:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b47:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b4b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b4f:	0f b6 00             	movzbl (%rax),%eax
  800b52:	0f b6 d8             	movzbl %al,%ebx
  800b55:	83 fb 25             	cmp    $0x25,%ebx
  800b58:	75 d2                	jne    800b2c <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b5a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b5e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b65:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b6c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b73:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b7a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b7e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b82:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b86:	0f b6 00             	movzbl (%rax),%eax
  800b89:	0f b6 d8             	movzbl %al,%ebx
  800b8c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b8f:	83 f8 55             	cmp    $0x55,%eax
  800b92:	0f 87 22 04 00 00    	ja     800fba <vprintfmt+0x4c9>
  800b98:	89 c0                	mov    %eax,%eax
  800b9a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ba1:	00 
  800ba2:	48 b8 38 1c 80 00 00 	movabs $0x801c38,%rax
  800ba9:	00 00 00 
  800bac:	48 01 d0             	add    %rdx,%rax
  800baf:	48 8b 00             	mov    (%rax),%rax
  800bb2:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bb4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bb8:	eb c0                	jmp    800b7a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bba:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bbe:	eb ba                	jmp    800b7a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bc7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bca:	89 d0                	mov    %edx,%eax
  800bcc:	c1 e0 02             	shl    $0x2,%eax
  800bcf:	01 d0                	add    %edx,%eax
  800bd1:	01 c0                	add    %eax,%eax
  800bd3:	01 d8                	add    %ebx,%eax
  800bd5:	83 e8 30             	sub    $0x30,%eax
  800bd8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bdb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bdf:	0f b6 00             	movzbl (%rax),%eax
  800be2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800be5:	83 fb 2f             	cmp    $0x2f,%ebx
  800be8:	7e 60                	jle    800c4a <vprintfmt+0x159>
  800bea:	83 fb 39             	cmp    $0x39,%ebx
  800bed:	7f 5b                	jg     800c4a <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bef:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bf4:	eb d1                	jmp    800bc7 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800bf6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf9:	83 f8 30             	cmp    $0x30,%eax
  800bfc:	73 17                	jae    800c15 <vprintfmt+0x124>
  800bfe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c02:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c05:	89 d2                	mov    %edx,%edx
  800c07:	48 01 d0             	add    %rdx,%rax
  800c0a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c0d:	83 c2 08             	add    $0x8,%edx
  800c10:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c13:	eb 0c                	jmp    800c21 <vprintfmt+0x130>
  800c15:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c19:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c1d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c21:	8b 00                	mov    (%rax),%eax
  800c23:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c26:	eb 23                	jmp    800c4b <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800c28:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c2c:	0f 89 48 ff ff ff    	jns    800b7a <vprintfmt+0x89>
				width = 0;
  800c32:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c39:	e9 3c ff ff ff       	jmpq   800b7a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c3e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c45:	e9 30 ff ff ff       	jmpq   800b7a <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c4a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c4f:	0f 89 25 ff ff ff    	jns    800b7a <vprintfmt+0x89>
				width = precision, precision = -1;
  800c55:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c58:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c5b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c62:	e9 13 ff ff ff       	jmpq   800b7a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c67:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c6b:	e9 0a ff ff ff       	jmpq   800b7a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c70:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c73:	83 f8 30             	cmp    $0x30,%eax
  800c76:	73 17                	jae    800c8f <vprintfmt+0x19e>
  800c78:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c7c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c7f:	89 d2                	mov    %edx,%edx
  800c81:	48 01 d0             	add    %rdx,%rax
  800c84:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c87:	83 c2 08             	add    $0x8,%edx
  800c8a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c8d:	eb 0c                	jmp    800c9b <vprintfmt+0x1aa>
  800c8f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c93:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c97:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c9b:	8b 10                	mov    (%rax),%edx
  800c9d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ca1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca5:	48 89 ce             	mov    %rcx,%rsi
  800ca8:	89 d7                	mov    %edx,%edi
  800caa:	ff d0                	callq  *%rax
			break;
  800cac:	e9 37 03 00 00       	jmpq   800fe8 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cb1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb4:	83 f8 30             	cmp    $0x30,%eax
  800cb7:	73 17                	jae    800cd0 <vprintfmt+0x1df>
  800cb9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cbd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc0:	89 d2                	mov    %edx,%edx
  800cc2:	48 01 d0             	add    %rdx,%rax
  800cc5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc8:	83 c2 08             	add    $0x8,%edx
  800ccb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cce:	eb 0c                	jmp    800cdc <vprintfmt+0x1eb>
  800cd0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cd4:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cd8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cdc:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cde:	85 db                	test   %ebx,%ebx
  800ce0:	79 02                	jns    800ce4 <vprintfmt+0x1f3>
				err = -err;
  800ce2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ce4:	83 fb 15             	cmp    $0x15,%ebx
  800ce7:	7f 16                	jg     800cff <vprintfmt+0x20e>
  800ce9:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  800cf0:	00 00 00 
  800cf3:	48 63 d3             	movslq %ebx,%rdx
  800cf6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cfa:	4d 85 e4             	test   %r12,%r12
  800cfd:	75 2e                	jne    800d2d <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800cff:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d03:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d07:	89 d9                	mov    %ebx,%ecx
  800d09:	48 ba 21 1c 80 00 00 	movabs $0x801c21,%rdx
  800d10:	00 00 00 
  800d13:	48 89 c7             	mov    %rax,%rdi
  800d16:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1b:	49 b8 f7 0f 80 00 00 	movabs $0x800ff7,%r8
  800d22:	00 00 00 
  800d25:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d28:	e9 bb 02 00 00       	jmpq   800fe8 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d2d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d35:	4c 89 e1             	mov    %r12,%rcx
  800d38:	48 ba 2a 1c 80 00 00 	movabs $0x801c2a,%rdx
  800d3f:	00 00 00 
  800d42:	48 89 c7             	mov    %rax,%rdi
  800d45:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4a:	49 b8 f7 0f 80 00 00 	movabs $0x800ff7,%r8
  800d51:	00 00 00 
  800d54:	41 ff d0             	callq  *%r8
			break;
  800d57:	e9 8c 02 00 00       	jmpq   800fe8 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d5c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d5f:	83 f8 30             	cmp    $0x30,%eax
  800d62:	73 17                	jae    800d7b <vprintfmt+0x28a>
  800d64:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d68:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d6b:	89 d2                	mov    %edx,%edx
  800d6d:	48 01 d0             	add    %rdx,%rax
  800d70:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d73:	83 c2 08             	add    $0x8,%edx
  800d76:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d79:	eb 0c                	jmp    800d87 <vprintfmt+0x296>
  800d7b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d7f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d83:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d87:	4c 8b 20             	mov    (%rax),%r12
  800d8a:	4d 85 e4             	test   %r12,%r12
  800d8d:	75 0a                	jne    800d99 <vprintfmt+0x2a8>
				p = "(null)";
  800d8f:	49 bc 2d 1c 80 00 00 	movabs $0x801c2d,%r12
  800d96:	00 00 00 
			if (width > 0 && padc != '-')
  800d99:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d9d:	7e 78                	jle    800e17 <vprintfmt+0x326>
  800d9f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800da3:	74 72                	je     800e17 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800da5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800da8:	48 98                	cltq   
  800daa:	48 89 c6             	mov    %rax,%rsi
  800dad:	4c 89 e7             	mov    %r12,%rdi
  800db0:	48 b8 a5 12 80 00 00 	movabs $0x8012a5,%rax
  800db7:	00 00 00 
  800dba:	ff d0                	callq  *%rax
  800dbc:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dbf:	eb 17                	jmp    800dd8 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800dc1:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800dc5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dc9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dcd:	48 89 ce             	mov    %rcx,%rsi
  800dd0:	89 d7                	mov    %edx,%edi
  800dd2:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dd8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ddc:	7f e3                	jg     800dc1 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dde:	eb 37                	jmp    800e17 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800de0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800de4:	74 1e                	je     800e04 <vprintfmt+0x313>
  800de6:	83 fb 1f             	cmp    $0x1f,%ebx
  800de9:	7e 05                	jle    800df0 <vprintfmt+0x2ff>
  800deb:	83 fb 7e             	cmp    $0x7e,%ebx
  800dee:	7e 14                	jle    800e04 <vprintfmt+0x313>
					putch('?', putdat);
  800df0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df8:	48 89 d6             	mov    %rdx,%rsi
  800dfb:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e00:	ff d0                	callq  *%rax
  800e02:	eb 0f                	jmp    800e13 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800e04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0c:	48 89 d6             	mov    %rdx,%rsi
  800e0f:	89 df                	mov    %ebx,%edi
  800e11:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e13:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e17:	4c 89 e0             	mov    %r12,%rax
  800e1a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e1e:	0f b6 00             	movzbl (%rax),%eax
  800e21:	0f be d8             	movsbl %al,%ebx
  800e24:	85 db                	test   %ebx,%ebx
  800e26:	74 28                	je     800e50 <vprintfmt+0x35f>
  800e28:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e2c:	78 b2                	js     800de0 <vprintfmt+0x2ef>
  800e2e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e32:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e36:	79 a8                	jns    800de0 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e38:	eb 16                	jmp    800e50 <vprintfmt+0x35f>
				putch(' ', putdat);
  800e3a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e42:	48 89 d6             	mov    %rdx,%rsi
  800e45:	bf 20 00 00 00       	mov    $0x20,%edi
  800e4a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e4c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e50:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e54:	7f e4                	jg     800e3a <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800e56:	e9 8d 01 00 00       	jmpq   800fe8 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e5b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e5f:	be 03 00 00 00       	mov    $0x3,%esi
  800e64:	48 89 c7             	mov    %rax,%rdi
  800e67:	48 b8 ea 09 80 00 00 	movabs $0x8009ea,%rax
  800e6e:	00 00 00 
  800e71:	ff d0                	callq  *%rax
  800e73:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7b:	48 85 c0             	test   %rax,%rax
  800e7e:	79 1d                	jns    800e9d <vprintfmt+0x3ac>
				putch('-', putdat);
  800e80:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e84:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e88:	48 89 d6             	mov    %rdx,%rsi
  800e8b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e90:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e96:	48 f7 d8             	neg    %rax
  800e99:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e9d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ea4:	e9 d2 00 00 00       	jmpq   800f7b <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ea9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ead:	be 03 00 00 00       	mov    $0x3,%esi
  800eb2:	48 89 c7             	mov    %rax,%rdi
  800eb5:	48 b8 e3 08 80 00 00 	movabs $0x8008e3,%rax
  800ebc:	00 00 00 
  800ebf:	ff d0                	callq  *%rax
  800ec1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ec5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ecc:	e9 aa 00 00 00       	jmpq   800f7b <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800ed1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ed5:	be 03 00 00 00       	mov    $0x3,%esi
  800eda:	48 89 c7             	mov    %rax,%rdi
  800edd:	48 b8 e3 08 80 00 00 	movabs $0x8008e3,%rax
  800ee4:	00 00 00 
  800ee7:	ff d0                	callq  *%rax
  800ee9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800eed:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ef4:	e9 82 00 00 00       	jmpq   800f7b <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800ef9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800efd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f01:	48 89 d6             	mov    %rdx,%rsi
  800f04:	bf 30 00 00 00       	mov    $0x30,%edi
  800f09:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f0b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f13:	48 89 d6             	mov    %rdx,%rsi
  800f16:	bf 78 00 00 00       	mov    $0x78,%edi
  800f1b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f1d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f20:	83 f8 30             	cmp    $0x30,%eax
  800f23:	73 17                	jae    800f3c <vprintfmt+0x44b>
  800f25:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f29:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f2c:	89 d2                	mov    %edx,%edx
  800f2e:	48 01 d0             	add    %rdx,%rax
  800f31:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f34:	83 c2 08             	add    $0x8,%edx
  800f37:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f3a:	eb 0c                	jmp    800f48 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800f3c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800f40:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800f44:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f48:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f4b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f4f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f56:	eb 23                	jmp    800f7b <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f58:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f5c:	be 03 00 00 00       	mov    $0x3,%esi
  800f61:	48 89 c7             	mov    %rax,%rdi
  800f64:	48 b8 e3 08 80 00 00 	movabs $0x8008e3,%rax
  800f6b:	00 00 00 
  800f6e:	ff d0                	callq  *%rax
  800f70:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f74:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f7b:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f80:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f83:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f8a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f92:	45 89 c1             	mov    %r8d,%r9d
  800f95:	41 89 f8             	mov    %edi,%r8d
  800f98:	48 89 c7             	mov    %rax,%rdi
  800f9b:	48 b8 2b 08 80 00 00 	movabs $0x80082b,%rax
  800fa2:	00 00 00 
  800fa5:	ff d0                	callq  *%rax
			break;
  800fa7:	eb 3f                	jmp    800fe8 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fb1:	48 89 d6             	mov    %rdx,%rsi
  800fb4:	89 df                	mov    %ebx,%edi
  800fb6:	ff d0                	callq  *%rax
			break;
  800fb8:	eb 2e                	jmp    800fe8 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc2:	48 89 d6             	mov    %rdx,%rsi
  800fc5:	bf 25 00 00 00       	mov    $0x25,%edi
  800fca:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fcc:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fd1:	eb 05                	jmp    800fd8 <vprintfmt+0x4e7>
  800fd3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fd8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fdc:	48 83 e8 01          	sub    $0x1,%rax
  800fe0:	0f b6 00             	movzbl (%rax),%eax
  800fe3:	3c 25                	cmp    $0x25,%al
  800fe5:	75 ec                	jne    800fd3 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800fe7:	90                   	nop
		}
	}
  800fe8:	e9 3d fb ff ff       	jmpq   800b2a <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fed:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800fee:	48 83 c4 60          	add    $0x60,%rsp
  800ff2:	5b                   	pop    %rbx
  800ff3:	41 5c                	pop    %r12
  800ff5:	5d                   	pop    %rbp
  800ff6:	c3                   	retq   

0000000000800ff7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ff7:	55                   	push   %rbp
  800ff8:	48 89 e5             	mov    %rsp,%rbp
  800ffb:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801002:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801009:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801010:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  801017:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80101e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801025:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80102c:	84 c0                	test   %al,%al
  80102e:	74 20                	je     801050 <printfmt+0x59>
  801030:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801034:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801038:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80103c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801040:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801044:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801048:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80104c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801050:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801057:	00 00 00 
  80105a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801061:	00 00 00 
  801064:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801068:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80106f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801076:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80107d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801084:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80108b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801092:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801099:	48 89 c7             	mov    %rax,%rdi
  80109c:	48 b8 f1 0a 80 00 00 	movabs $0x800af1,%rax
  8010a3:	00 00 00 
  8010a6:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010a8:	90                   	nop
  8010a9:	c9                   	leaveq 
  8010aa:	c3                   	retq   

00000000008010ab <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010ab:	55                   	push   %rbp
  8010ac:	48 89 e5             	mov    %rsp,%rbp
  8010af:	48 83 ec 10          	sub    $0x10,%rsp
  8010b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010be:	8b 40 10             	mov    0x10(%rax),%eax
  8010c1:	8d 50 01             	lea    0x1(%rax),%edx
  8010c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010cf:	48 8b 10             	mov    (%rax),%rdx
  8010d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010da:	48 39 c2             	cmp    %rax,%rdx
  8010dd:	73 17                	jae    8010f6 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e3:	48 8b 00             	mov    (%rax),%rax
  8010e6:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010ee:	48 89 0a             	mov    %rcx,(%rdx)
  8010f1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010f4:	88 10                	mov    %dl,(%rax)
}
  8010f6:	90                   	nop
  8010f7:	c9                   	leaveq 
  8010f8:	c3                   	retq   

00000000008010f9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010f9:	55                   	push   %rbp
  8010fa:	48 89 e5             	mov    %rsp,%rbp
  8010fd:	48 83 ec 50          	sub    $0x50,%rsp
  801101:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801105:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801108:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80110c:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801110:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801114:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801118:	48 8b 0a             	mov    (%rdx),%rcx
  80111b:	48 89 08             	mov    %rcx,(%rax)
  80111e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801122:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801126:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80112a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80112e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801132:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801136:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801139:	48 98                	cltq   
  80113b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80113f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801143:	48 01 d0             	add    %rdx,%rax
  801146:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80114a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801151:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801156:	74 06                	je     80115e <vsnprintf+0x65>
  801158:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80115c:	7f 07                	jg     801165 <vsnprintf+0x6c>
		return -E_INVAL;
  80115e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801163:	eb 2f                	jmp    801194 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801165:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801169:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80116d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801171:	48 89 c6             	mov    %rax,%rsi
  801174:	48 bf ab 10 80 00 00 	movabs $0x8010ab,%rdi
  80117b:	00 00 00 
  80117e:	48 b8 f1 0a 80 00 00 	movabs $0x800af1,%rax
  801185:	00 00 00 
  801188:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80118a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80118e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801191:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801194:	c9                   	leaveq 
  801195:	c3                   	retq   

0000000000801196 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801196:	55                   	push   %rbp
  801197:	48 89 e5             	mov    %rsp,%rbp
  80119a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011a1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011a8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011ae:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8011b5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011bc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011c3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011ca:	84 c0                	test   %al,%al
  8011cc:	74 20                	je     8011ee <snprintf+0x58>
  8011ce:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011d2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011d6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011da:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011de:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011e2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011e6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011ea:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011ee:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011f5:	00 00 00 
  8011f8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011ff:	00 00 00 
  801202:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801206:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80120d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801214:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80121b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801222:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801229:	48 8b 0a             	mov    (%rdx),%rcx
  80122c:	48 89 08             	mov    %rcx,(%rax)
  80122f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801233:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801237:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80123b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80123f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801246:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80124d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801253:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80125a:	48 89 c7             	mov    %rax,%rdi
  80125d:	48 b8 f9 10 80 00 00 	movabs $0x8010f9,%rax
  801264:	00 00 00 
  801267:	ff d0                	callq  *%rax
  801269:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80126f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801275:	c9                   	leaveq 
  801276:	c3                   	retq   

0000000000801277 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801277:	55                   	push   %rbp
  801278:	48 89 e5             	mov    %rsp,%rbp
  80127b:	48 83 ec 18          	sub    $0x18,%rsp
  80127f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801283:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80128a:	eb 09                	jmp    801295 <strlen+0x1e>
		n++;
  80128c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801290:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801295:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801299:	0f b6 00             	movzbl (%rax),%eax
  80129c:	84 c0                	test   %al,%al
  80129e:	75 ec                	jne    80128c <strlen+0x15>
		n++;
	return n;
  8012a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012a3:	c9                   	leaveq 
  8012a4:	c3                   	retq   

00000000008012a5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012a5:	55                   	push   %rbp
  8012a6:	48 89 e5             	mov    %rsp,%rbp
  8012a9:	48 83 ec 20          	sub    $0x20,%rsp
  8012ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012bc:	eb 0e                	jmp    8012cc <strnlen+0x27>
		n++;
  8012be:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012c2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012c7:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012cc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012d1:	74 0b                	je     8012de <strnlen+0x39>
  8012d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d7:	0f b6 00             	movzbl (%rax),%eax
  8012da:	84 c0                	test   %al,%al
  8012dc:	75 e0                	jne    8012be <strnlen+0x19>
		n++;
	return n;
  8012de:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012e1:	c9                   	leaveq 
  8012e2:	c3                   	retq   

00000000008012e3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012e3:	55                   	push   %rbp
  8012e4:	48 89 e5             	mov    %rsp,%rbp
  8012e7:	48 83 ec 20          	sub    $0x20,%rsp
  8012eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012fb:	90                   	nop
  8012fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801300:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801304:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801308:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80130c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801310:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801314:	0f b6 12             	movzbl (%rdx),%edx
  801317:	88 10                	mov    %dl,(%rax)
  801319:	0f b6 00             	movzbl (%rax),%eax
  80131c:	84 c0                	test   %al,%al
  80131e:	75 dc                	jne    8012fc <strcpy+0x19>
		/* do nothing */;
	return ret;
  801320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801324:	c9                   	leaveq 
  801325:	c3                   	retq   

0000000000801326 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801326:	55                   	push   %rbp
  801327:	48 89 e5             	mov    %rsp,%rbp
  80132a:	48 83 ec 20          	sub    $0x20,%rsp
  80132e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801332:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133a:	48 89 c7             	mov    %rax,%rdi
  80133d:	48 b8 77 12 80 00 00 	movabs $0x801277,%rax
  801344:	00 00 00 
  801347:	ff d0                	callq  *%rax
  801349:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80134c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80134f:	48 63 d0             	movslq %eax,%rdx
  801352:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801356:	48 01 c2             	add    %rax,%rdx
  801359:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135d:	48 89 c6             	mov    %rax,%rsi
  801360:	48 89 d7             	mov    %rdx,%rdi
  801363:	48 b8 e3 12 80 00 00 	movabs $0x8012e3,%rax
  80136a:	00 00 00 
  80136d:	ff d0                	callq  *%rax
	return dst;
  80136f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801373:	c9                   	leaveq 
  801374:	c3                   	retq   

0000000000801375 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801375:	55                   	push   %rbp
  801376:	48 89 e5             	mov    %rsp,%rbp
  801379:	48 83 ec 28          	sub    $0x28,%rsp
  80137d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801381:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801385:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801389:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801391:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801398:	00 
  801399:	eb 2a                	jmp    8013c5 <strncpy+0x50>
		*dst++ = *src;
  80139b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80139f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013a3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013a7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013ab:	0f b6 12             	movzbl (%rdx),%edx
  8013ae:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013b4:	0f b6 00             	movzbl (%rax),%eax
  8013b7:	84 c0                	test   %al,%al
  8013b9:	74 05                	je     8013c0 <strncpy+0x4b>
			src++;
  8013bb:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013cd:	72 cc                	jb     80139b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013d3:	c9                   	leaveq 
  8013d4:	c3                   	retq   

00000000008013d5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013d5:	55                   	push   %rbp
  8013d6:	48 89 e5             	mov    %rsp,%rbp
  8013d9:	48 83 ec 28          	sub    $0x28,%rsp
  8013dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013f1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013f6:	74 3d                	je     801435 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8013f8:	eb 1d                	jmp    801417 <strlcpy+0x42>
			*dst++ = *src++;
  8013fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fe:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801402:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801406:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80140a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80140e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801412:	0f b6 12             	movzbl (%rdx),%edx
  801415:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801417:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80141c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801421:	74 0b                	je     80142e <strlcpy+0x59>
  801423:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801427:	0f b6 00             	movzbl (%rax),%eax
  80142a:	84 c0                	test   %al,%al
  80142c:	75 cc                	jne    8013fa <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80142e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801432:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801435:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801439:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143d:	48 29 c2             	sub    %rax,%rdx
  801440:	48 89 d0             	mov    %rdx,%rax
}
  801443:	c9                   	leaveq 
  801444:	c3                   	retq   

0000000000801445 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801445:	55                   	push   %rbp
  801446:	48 89 e5             	mov    %rsp,%rbp
  801449:	48 83 ec 10          	sub    $0x10,%rsp
  80144d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801451:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801455:	eb 0a                	jmp    801461 <strcmp+0x1c>
		p++, q++;
  801457:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80145c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801461:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801465:	0f b6 00             	movzbl (%rax),%eax
  801468:	84 c0                	test   %al,%al
  80146a:	74 12                	je     80147e <strcmp+0x39>
  80146c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801470:	0f b6 10             	movzbl (%rax),%edx
  801473:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801477:	0f b6 00             	movzbl (%rax),%eax
  80147a:	38 c2                	cmp    %al,%dl
  80147c:	74 d9                	je     801457 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80147e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801482:	0f b6 00             	movzbl (%rax),%eax
  801485:	0f b6 d0             	movzbl %al,%edx
  801488:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148c:	0f b6 00             	movzbl (%rax),%eax
  80148f:	0f b6 c0             	movzbl %al,%eax
  801492:	29 c2                	sub    %eax,%edx
  801494:	89 d0                	mov    %edx,%eax
}
  801496:	c9                   	leaveq 
  801497:	c3                   	retq   

0000000000801498 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801498:	55                   	push   %rbp
  801499:	48 89 e5             	mov    %rsp,%rbp
  80149c:	48 83 ec 18          	sub    $0x18,%rsp
  8014a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014ac:	eb 0f                	jmp    8014bd <strncmp+0x25>
		n--, p++, q++;
  8014ae:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014b3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014bd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014c2:	74 1d                	je     8014e1 <strncmp+0x49>
  8014c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c8:	0f b6 00             	movzbl (%rax),%eax
  8014cb:	84 c0                	test   %al,%al
  8014cd:	74 12                	je     8014e1 <strncmp+0x49>
  8014cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d3:	0f b6 10             	movzbl (%rax),%edx
  8014d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014da:	0f b6 00             	movzbl (%rax),%eax
  8014dd:	38 c2                	cmp    %al,%dl
  8014df:	74 cd                	je     8014ae <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014e1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014e6:	75 07                	jne    8014ef <strncmp+0x57>
		return 0;
  8014e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ed:	eb 18                	jmp    801507 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f3:	0f b6 00             	movzbl (%rax),%eax
  8014f6:	0f b6 d0             	movzbl %al,%edx
  8014f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fd:	0f b6 00             	movzbl (%rax),%eax
  801500:	0f b6 c0             	movzbl %al,%eax
  801503:	29 c2                	sub    %eax,%edx
  801505:	89 d0                	mov    %edx,%eax
}
  801507:	c9                   	leaveq 
  801508:	c3                   	retq   

0000000000801509 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801509:	55                   	push   %rbp
  80150a:	48 89 e5             	mov    %rsp,%rbp
  80150d:	48 83 ec 10          	sub    $0x10,%rsp
  801511:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801515:	89 f0                	mov    %esi,%eax
  801517:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80151a:	eb 17                	jmp    801533 <strchr+0x2a>
		if (*s == c)
  80151c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801520:	0f b6 00             	movzbl (%rax),%eax
  801523:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801526:	75 06                	jne    80152e <strchr+0x25>
			return (char *) s;
  801528:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152c:	eb 15                	jmp    801543 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80152e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801533:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801537:	0f b6 00             	movzbl (%rax),%eax
  80153a:	84 c0                	test   %al,%al
  80153c:	75 de                	jne    80151c <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80153e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801543:	c9                   	leaveq 
  801544:	c3                   	retq   

0000000000801545 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801545:	55                   	push   %rbp
  801546:	48 89 e5             	mov    %rsp,%rbp
  801549:	48 83 ec 10          	sub    $0x10,%rsp
  80154d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801551:	89 f0                	mov    %esi,%eax
  801553:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801556:	eb 11                	jmp    801569 <strfind+0x24>
		if (*s == c)
  801558:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155c:	0f b6 00             	movzbl (%rax),%eax
  80155f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801562:	74 12                	je     801576 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801564:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801569:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156d:	0f b6 00             	movzbl (%rax),%eax
  801570:	84 c0                	test   %al,%al
  801572:	75 e4                	jne    801558 <strfind+0x13>
  801574:	eb 01                	jmp    801577 <strfind+0x32>
		if (*s == c)
			break;
  801576:	90                   	nop
	return (char *) s;
  801577:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80157b:	c9                   	leaveq 
  80157c:	c3                   	retq   

000000000080157d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80157d:	55                   	push   %rbp
  80157e:	48 89 e5             	mov    %rsp,%rbp
  801581:	48 83 ec 18          	sub    $0x18,%rsp
  801585:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801589:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80158c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801590:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801595:	75 06                	jne    80159d <memset+0x20>
		return v;
  801597:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159b:	eb 69                	jmp    801606 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80159d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a1:	83 e0 03             	and    $0x3,%eax
  8015a4:	48 85 c0             	test   %rax,%rax
  8015a7:	75 48                	jne    8015f1 <memset+0x74>
  8015a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ad:	83 e0 03             	and    $0x3,%eax
  8015b0:	48 85 c0             	test   %rax,%rax
  8015b3:	75 3c                	jne    8015f1 <memset+0x74>
		c &= 0xFF;
  8015b5:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015bf:	c1 e0 18             	shl    $0x18,%eax
  8015c2:	89 c2                	mov    %eax,%edx
  8015c4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c7:	c1 e0 10             	shl    $0x10,%eax
  8015ca:	09 c2                	or     %eax,%edx
  8015cc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015cf:	c1 e0 08             	shl    $0x8,%eax
  8015d2:	09 d0                	or     %edx,%eax
  8015d4:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015db:	48 c1 e8 02          	shr    $0x2,%rax
  8015df:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e9:	48 89 d7             	mov    %rdx,%rdi
  8015ec:	fc                   	cld    
  8015ed:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015ef:	eb 11                	jmp    801602 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015f1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015f5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015fc:	48 89 d7             	mov    %rdx,%rdi
  8015ff:	fc                   	cld    
  801600:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801602:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801606:	c9                   	leaveq 
  801607:	c3                   	retq   

0000000000801608 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801608:	55                   	push   %rbp
  801609:	48 89 e5             	mov    %rsp,%rbp
  80160c:	48 83 ec 28          	sub    $0x28,%rsp
  801610:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801614:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801618:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80161c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801620:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801628:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80162c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801630:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801634:	0f 83 88 00 00 00    	jae    8016c2 <memmove+0xba>
  80163a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80163e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801642:	48 01 d0             	add    %rdx,%rax
  801645:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801649:	76 77                	jbe    8016c2 <memmove+0xba>
		s += n;
  80164b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801653:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801657:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80165b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165f:	83 e0 03             	and    $0x3,%eax
  801662:	48 85 c0             	test   %rax,%rax
  801665:	75 3b                	jne    8016a2 <memmove+0x9a>
  801667:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166b:	83 e0 03             	and    $0x3,%eax
  80166e:	48 85 c0             	test   %rax,%rax
  801671:	75 2f                	jne    8016a2 <memmove+0x9a>
  801673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801677:	83 e0 03             	and    $0x3,%eax
  80167a:	48 85 c0             	test   %rax,%rax
  80167d:	75 23                	jne    8016a2 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80167f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801683:	48 83 e8 04          	sub    $0x4,%rax
  801687:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80168b:	48 83 ea 04          	sub    $0x4,%rdx
  80168f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801693:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801697:	48 89 c7             	mov    %rax,%rdi
  80169a:	48 89 d6             	mov    %rdx,%rsi
  80169d:	fd                   	std    
  80169e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016a0:	eb 1d                	jmp    8016bf <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ae:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b6:	48 89 d7             	mov    %rdx,%rdi
  8016b9:	48 89 c1             	mov    %rax,%rcx
  8016bc:	fd                   	std    
  8016bd:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016bf:	fc                   	cld    
  8016c0:	eb 57                	jmp    801719 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c6:	83 e0 03             	and    $0x3,%eax
  8016c9:	48 85 c0             	test   %rax,%rax
  8016cc:	75 36                	jne    801704 <memmove+0xfc>
  8016ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d2:	83 e0 03             	and    $0x3,%eax
  8016d5:	48 85 c0             	test   %rax,%rax
  8016d8:	75 2a                	jne    801704 <memmove+0xfc>
  8016da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016de:	83 e0 03             	and    $0x3,%eax
  8016e1:	48 85 c0             	test   %rax,%rax
  8016e4:	75 1e                	jne    801704 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ea:	48 c1 e8 02          	shr    $0x2,%rax
  8016ee:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016f9:	48 89 c7             	mov    %rax,%rdi
  8016fc:	48 89 d6             	mov    %rdx,%rsi
  8016ff:	fc                   	cld    
  801700:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801702:	eb 15                	jmp    801719 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801704:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801708:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80170c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801710:	48 89 c7             	mov    %rax,%rdi
  801713:	48 89 d6             	mov    %rdx,%rsi
  801716:	fc                   	cld    
  801717:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801719:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80171d:	c9                   	leaveq 
  80171e:	c3                   	retq   

000000000080171f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80171f:	55                   	push   %rbp
  801720:	48 89 e5             	mov    %rsp,%rbp
  801723:	48 83 ec 18          	sub    $0x18,%rsp
  801727:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80172b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80172f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801733:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801737:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80173b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80173f:	48 89 ce             	mov    %rcx,%rsi
  801742:	48 89 c7             	mov    %rax,%rdi
  801745:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  80174c:	00 00 00 
  80174f:	ff d0                	callq  *%rax
}
  801751:	c9                   	leaveq 
  801752:	c3                   	retq   

0000000000801753 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801753:	55                   	push   %rbp
  801754:	48 89 e5             	mov    %rsp,%rbp
  801757:	48 83 ec 28          	sub    $0x28,%rsp
  80175b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80175f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801763:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80176b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80176f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801773:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801777:	eb 36                	jmp    8017af <memcmp+0x5c>
		if (*s1 != *s2)
  801779:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177d:	0f b6 10             	movzbl (%rax),%edx
  801780:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801784:	0f b6 00             	movzbl (%rax),%eax
  801787:	38 c2                	cmp    %al,%dl
  801789:	74 1a                	je     8017a5 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80178b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80178f:	0f b6 00             	movzbl (%rax),%eax
  801792:	0f b6 d0             	movzbl %al,%edx
  801795:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801799:	0f b6 00             	movzbl (%rax),%eax
  80179c:	0f b6 c0             	movzbl %al,%eax
  80179f:	29 c2                	sub    %eax,%edx
  8017a1:	89 d0                	mov    %edx,%eax
  8017a3:	eb 20                	jmp    8017c5 <memcmp+0x72>
		s1++, s2++;
  8017a5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017aa:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017bb:	48 85 c0             	test   %rax,%rax
  8017be:	75 b9                	jne    801779 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c5:	c9                   	leaveq 
  8017c6:	c3                   	retq   

00000000008017c7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017c7:	55                   	push   %rbp
  8017c8:	48 89 e5             	mov    %rsp,%rbp
  8017cb:	48 83 ec 28          	sub    $0x28,%rsp
  8017cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017d3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e2:	48 01 d0             	add    %rdx,%rax
  8017e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017e9:	eb 19                	jmp    801804 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ef:	0f b6 00             	movzbl (%rax),%eax
  8017f2:	0f b6 d0             	movzbl %al,%edx
  8017f5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017f8:	0f b6 c0             	movzbl %al,%eax
  8017fb:	39 c2                	cmp    %eax,%edx
  8017fd:	74 11                	je     801810 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017ff:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801804:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801808:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80180c:	72 dd                	jb     8017eb <memfind+0x24>
  80180e:	eb 01                	jmp    801811 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801810:	90                   	nop
	return (void *) s;
  801811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801815:	c9                   	leaveq 
  801816:	c3                   	retq   

0000000000801817 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801817:	55                   	push   %rbp
  801818:	48 89 e5             	mov    %rsp,%rbp
  80181b:	48 83 ec 38          	sub    $0x38,%rsp
  80181f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801823:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801827:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80182a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801831:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801838:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801839:	eb 05                	jmp    801840 <strtol+0x29>
		s++;
  80183b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801840:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801844:	0f b6 00             	movzbl (%rax),%eax
  801847:	3c 20                	cmp    $0x20,%al
  801849:	74 f0                	je     80183b <strtol+0x24>
  80184b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184f:	0f b6 00             	movzbl (%rax),%eax
  801852:	3c 09                	cmp    $0x9,%al
  801854:	74 e5                	je     80183b <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801856:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185a:	0f b6 00             	movzbl (%rax),%eax
  80185d:	3c 2b                	cmp    $0x2b,%al
  80185f:	75 07                	jne    801868 <strtol+0x51>
		s++;
  801861:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801866:	eb 17                	jmp    80187f <strtol+0x68>
	else if (*s == '-')
  801868:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186c:	0f b6 00             	movzbl (%rax),%eax
  80186f:	3c 2d                	cmp    $0x2d,%al
  801871:	75 0c                	jne    80187f <strtol+0x68>
		s++, neg = 1;
  801873:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801878:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80187f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801883:	74 06                	je     80188b <strtol+0x74>
  801885:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801889:	75 28                	jne    8018b3 <strtol+0x9c>
  80188b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188f:	0f b6 00             	movzbl (%rax),%eax
  801892:	3c 30                	cmp    $0x30,%al
  801894:	75 1d                	jne    8018b3 <strtol+0x9c>
  801896:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189a:	48 83 c0 01          	add    $0x1,%rax
  80189e:	0f b6 00             	movzbl (%rax),%eax
  8018a1:	3c 78                	cmp    $0x78,%al
  8018a3:	75 0e                	jne    8018b3 <strtol+0x9c>
		s += 2, base = 16;
  8018a5:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018aa:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018b1:	eb 2c                	jmp    8018df <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018b3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018b7:	75 19                	jne    8018d2 <strtol+0xbb>
  8018b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bd:	0f b6 00             	movzbl (%rax),%eax
  8018c0:	3c 30                	cmp    $0x30,%al
  8018c2:	75 0e                	jne    8018d2 <strtol+0xbb>
		s++, base = 8;
  8018c4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018c9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018d0:	eb 0d                	jmp    8018df <strtol+0xc8>
	else if (base == 0)
  8018d2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018d6:	75 07                	jne    8018df <strtol+0xc8>
		base = 10;
  8018d8:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e3:	0f b6 00             	movzbl (%rax),%eax
  8018e6:	3c 2f                	cmp    $0x2f,%al
  8018e8:	7e 1d                	jle    801907 <strtol+0xf0>
  8018ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ee:	0f b6 00             	movzbl (%rax),%eax
  8018f1:	3c 39                	cmp    $0x39,%al
  8018f3:	7f 12                	jg     801907 <strtol+0xf0>
			dig = *s - '0';
  8018f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f9:	0f b6 00             	movzbl (%rax),%eax
  8018fc:	0f be c0             	movsbl %al,%eax
  8018ff:	83 e8 30             	sub    $0x30,%eax
  801902:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801905:	eb 4e                	jmp    801955 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801907:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190b:	0f b6 00             	movzbl (%rax),%eax
  80190e:	3c 60                	cmp    $0x60,%al
  801910:	7e 1d                	jle    80192f <strtol+0x118>
  801912:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801916:	0f b6 00             	movzbl (%rax),%eax
  801919:	3c 7a                	cmp    $0x7a,%al
  80191b:	7f 12                	jg     80192f <strtol+0x118>
			dig = *s - 'a' + 10;
  80191d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801921:	0f b6 00             	movzbl (%rax),%eax
  801924:	0f be c0             	movsbl %al,%eax
  801927:	83 e8 57             	sub    $0x57,%eax
  80192a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80192d:	eb 26                	jmp    801955 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80192f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801933:	0f b6 00             	movzbl (%rax),%eax
  801936:	3c 40                	cmp    $0x40,%al
  801938:	7e 47                	jle    801981 <strtol+0x16a>
  80193a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193e:	0f b6 00             	movzbl (%rax),%eax
  801941:	3c 5a                	cmp    $0x5a,%al
  801943:	7f 3c                	jg     801981 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801945:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801949:	0f b6 00             	movzbl (%rax),%eax
  80194c:	0f be c0             	movsbl %al,%eax
  80194f:	83 e8 37             	sub    $0x37,%eax
  801952:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801955:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801958:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80195b:	7d 23                	jge    801980 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80195d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801962:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801965:	48 98                	cltq   
  801967:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80196c:	48 89 c2             	mov    %rax,%rdx
  80196f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801972:	48 98                	cltq   
  801974:	48 01 d0             	add    %rdx,%rax
  801977:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80197b:	e9 5f ff ff ff       	jmpq   8018df <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801980:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801981:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801986:	74 0b                	je     801993 <strtol+0x17c>
		*endptr = (char *) s;
  801988:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80198c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801990:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801993:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801997:	74 09                	je     8019a2 <strtol+0x18b>
  801999:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80199d:	48 f7 d8             	neg    %rax
  8019a0:	eb 04                	jmp    8019a6 <strtol+0x18f>
  8019a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019a6:	c9                   	leaveq 
  8019a7:	c3                   	retq   

00000000008019a8 <strstr>:

char * strstr(const char *in, const char *str)
{
  8019a8:	55                   	push   %rbp
  8019a9:	48 89 e5             	mov    %rsp,%rbp
  8019ac:	48 83 ec 30          	sub    $0x30,%rsp
  8019b0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019b4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019bc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019c0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019c4:	0f b6 00             	movzbl (%rax),%eax
  8019c7:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019ca:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019ce:	75 06                	jne    8019d6 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d4:	eb 6b                	jmp    801a41 <strstr+0x99>

	len = strlen(str);
  8019d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019da:	48 89 c7             	mov    %rax,%rdi
  8019dd:	48 b8 77 12 80 00 00 	movabs $0x801277,%rax
  8019e4:	00 00 00 
  8019e7:	ff d0                	callq  *%rax
  8019e9:	48 98                	cltq   
  8019eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019f7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019fb:	0f b6 00             	movzbl (%rax),%eax
  8019fe:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a01:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a05:	75 07                	jne    801a0e <strstr+0x66>
				return (char *) 0;
  801a07:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0c:	eb 33                	jmp    801a41 <strstr+0x99>
		} while (sc != c);
  801a0e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a12:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a15:	75 d8                	jne    8019ef <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a17:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a1b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a23:	48 89 ce             	mov    %rcx,%rsi
  801a26:	48 89 c7             	mov    %rax,%rdi
  801a29:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  801a30:	00 00 00 
  801a33:	ff d0                	callq  *%rax
  801a35:	85 c0                	test   %eax,%eax
  801a37:	75 b6                	jne    8019ef <strstr+0x47>

	return (char *) (in - 1);
  801a39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3d:	48 83 e8 01          	sub    $0x1,%rax
}
  801a41:	c9                   	leaveq 
  801a42:	c3                   	retq   
