
obj/user/evilhello:     file format elf64-x86-64


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
  80003c:	e8 2f 00 00 00       	callq  800070 <libmain>
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
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0x800420000c, 100);
  800052:	be 64 00 00 00       	mov    $0x64,%esi
  800057:	48 bf 0c 00 20 04 80 	movabs $0x800420000c,%rdi
  80005e:	00 00 00 
  800061:	48 b8 a2 01 80 00 00 	movabs $0x8001a2,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
}
  80006d:	90                   	nop
  80006e:	c9                   	leaveq 
  80006f:	c3                   	retq   

0000000000800070 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800070:	55                   	push   %rbp
  800071:	48 89 e5             	mov    %rsp,%rbp
  800074:	48 83 ec 10          	sub    $0x10,%rsp
  800078:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80007b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  80007f:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  800086:	00 00 00 
  800089:	ff d0                	callq  *%rax
  80008b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800090:	48 63 d0             	movslq %eax,%rdx
  800093:	48 89 d0             	mov    %rdx,%rax
  800096:	48 c1 e0 03          	shl    $0x3,%rax
  80009a:	48 01 d0             	add    %rdx,%rax
  80009d:	48 c1 e0 05          	shl    $0x5,%rax
  8000a1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000a8:	00 00 00 
  8000ab:	48 01 c2             	add    %rax,%rdx
  8000ae:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000b5:	00 00 00 
  8000b8:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000bf:	7e 14                	jle    8000d5 <libmain+0x65>
		binaryname = argv[0];
  8000c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000c5:	48 8b 10             	mov    (%rax),%rdx
  8000c8:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000cf:	00 00 00 
  8000d2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000dc:	48 89 d6             	mov    %rdx,%rsi
  8000df:	89 c7                	mov    %eax,%edi
  8000e1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000e8:	00 00 00 
  8000eb:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000ed:	48 b8 fc 00 80 00 00 	movabs $0x8000fc,%rax
  8000f4:	00 00 00 
  8000f7:	ff d0                	callq  *%rax
}
  8000f9:	90                   	nop
  8000fa:	c9                   	leaveq 
  8000fb:	c3                   	retq   

00000000008000fc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fc:	55                   	push   %rbp
  8000fd:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800100:	bf 00 00 00 00       	mov    $0x0,%edi
  800105:	48 b8 2b 02 80 00 00 	movabs $0x80022b,%rax
  80010c:	00 00 00 
  80010f:	ff d0                	callq  *%rax
}
  800111:	90                   	nop
  800112:	5d                   	pop    %rbp
  800113:	c3                   	retq   

0000000000800114 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800114:	55                   	push   %rbp
  800115:	48 89 e5             	mov    %rsp,%rbp
  800118:	53                   	push   %rbx
  800119:	48 83 ec 48          	sub    $0x48,%rsp
  80011d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800120:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800123:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800127:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80012b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80012f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800133:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800136:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80013a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80013e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800142:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800146:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80014a:	4c 89 c3             	mov    %r8,%rbx
  80014d:	cd 30                	int    $0x30
  80014f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800153:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800157:	74 3e                	je     800197 <syscall+0x83>
  800159:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80015e:	7e 37                	jle    800197 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800160:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800164:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800167:	49 89 d0             	mov    %rdx,%r8
  80016a:	89 c1                	mov    %eax,%ecx
  80016c:	48 ba 6a 1a 80 00 00 	movabs $0x801a6a,%rdx
  800173:	00 00 00 
  800176:	be 23 00 00 00       	mov    $0x23,%esi
  80017b:	48 bf 87 1a 80 00 00 	movabs $0x801a87,%rdi
  800182:	00 00 00 
  800185:	b8 00 00 00 00       	mov    $0x0,%eax
  80018a:	49 b9 1e 05 80 00 00 	movabs $0x80051e,%r9
  800191:	00 00 00 
  800194:	41 ff d1             	callq  *%r9

	return ret;
  800197:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80019b:	48 83 c4 48          	add    $0x48,%rsp
  80019f:	5b                   	pop    %rbx
  8001a0:	5d                   	pop    %rbp
  8001a1:	c3                   	retq   

00000000008001a2 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001a2:	55                   	push   %rbp
  8001a3:	48 89 e5             	mov    %rsp,%rbp
  8001a6:	48 83 ec 10          	sub    $0x10,%rsp
  8001aa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ba:	48 83 ec 08          	sub    $0x8,%rsp
  8001be:	6a 00                	pushq  $0x0
  8001c0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001cc:	48 89 d1             	mov    %rdx,%rcx
  8001cf:	48 89 c2             	mov    %rax,%rdx
  8001d2:	be 00 00 00 00       	mov    $0x0,%esi
  8001d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001dc:	48 b8 14 01 80 00 00 	movabs $0x800114,%rax
  8001e3:	00 00 00 
  8001e6:	ff d0                	callq  *%rax
  8001e8:	48 83 c4 10          	add    $0x10,%rsp
}
  8001ec:	90                   	nop
  8001ed:	c9                   	leaveq 
  8001ee:	c3                   	retq   

00000000008001ef <sys_cgetc>:

int
sys_cgetc(void)
{
  8001ef:	55                   	push   %rbp
  8001f0:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001f3:	48 83 ec 08          	sub    $0x8,%rsp
  8001f7:	6a 00                	pushq  $0x0
  8001f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800205:	b9 00 00 00 00       	mov    $0x0,%ecx
  80020a:	ba 00 00 00 00       	mov    $0x0,%edx
  80020f:	be 00 00 00 00       	mov    $0x0,%esi
  800214:	bf 01 00 00 00       	mov    $0x1,%edi
  800219:	48 b8 14 01 80 00 00 	movabs $0x800114,%rax
  800220:	00 00 00 
  800223:	ff d0                	callq  *%rax
  800225:	48 83 c4 10          	add    $0x10,%rsp
}
  800229:	c9                   	leaveq 
  80022a:	c3                   	retq   

000000000080022b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80022b:	55                   	push   %rbp
  80022c:	48 89 e5             	mov    %rsp,%rbp
  80022f:	48 83 ec 10          	sub    $0x10,%rsp
  800233:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800236:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800239:	48 98                	cltq   
  80023b:	48 83 ec 08          	sub    $0x8,%rsp
  80023f:	6a 00                	pushq  $0x0
  800241:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800247:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80024d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800252:	48 89 c2             	mov    %rax,%rdx
  800255:	be 01 00 00 00       	mov    $0x1,%esi
  80025a:	bf 03 00 00 00       	mov    $0x3,%edi
  80025f:	48 b8 14 01 80 00 00 	movabs $0x800114,%rax
  800266:	00 00 00 
  800269:	ff d0                	callq  *%rax
  80026b:	48 83 c4 10          	add    $0x10,%rsp
}
  80026f:	c9                   	leaveq 
  800270:	c3                   	retq   

0000000000800271 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800271:	55                   	push   %rbp
  800272:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800275:	48 83 ec 08          	sub    $0x8,%rsp
  800279:	6a 00                	pushq  $0x0
  80027b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800281:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800287:	b9 00 00 00 00       	mov    $0x0,%ecx
  80028c:	ba 00 00 00 00       	mov    $0x0,%edx
  800291:	be 00 00 00 00       	mov    $0x0,%esi
  800296:	bf 02 00 00 00       	mov    $0x2,%edi
  80029b:	48 b8 14 01 80 00 00 	movabs $0x800114,%rax
  8002a2:	00 00 00 
  8002a5:	ff d0                	callq  *%rax
  8002a7:	48 83 c4 10          	add    $0x10,%rsp
}
  8002ab:	c9                   	leaveq 
  8002ac:	c3                   	retq   

00000000008002ad <sys_yield>:

void
sys_yield(void)
{
  8002ad:	55                   	push   %rbp
  8002ae:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002b1:	48 83 ec 08          	sub    $0x8,%rsp
  8002b5:	6a 00                	pushq  $0x0
  8002b7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002cd:	be 00 00 00 00       	mov    $0x0,%esi
  8002d2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002d7:	48 b8 14 01 80 00 00 	movabs $0x800114,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	callq  *%rax
  8002e3:	48 83 c4 10          	add    $0x10,%rsp
}
  8002e7:	90                   	nop
  8002e8:	c9                   	leaveq 
  8002e9:	c3                   	retq   

00000000008002ea <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002ea:	55                   	push   %rbp
  8002eb:	48 89 e5             	mov    %rsp,%rbp
  8002ee:	48 83 ec 10          	sub    $0x10,%rsp
  8002f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002f9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ff:	48 63 c8             	movslq %eax,%rcx
  800302:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800306:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800309:	48 98                	cltq   
  80030b:	48 83 ec 08          	sub    $0x8,%rsp
  80030f:	6a 00                	pushq  $0x0
  800311:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800317:	49 89 c8             	mov    %rcx,%r8
  80031a:	48 89 d1             	mov    %rdx,%rcx
  80031d:	48 89 c2             	mov    %rax,%rdx
  800320:	be 01 00 00 00       	mov    $0x1,%esi
  800325:	bf 04 00 00 00       	mov    $0x4,%edi
  80032a:	48 b8 14 01 80 00 00 	movabs $0x800114,%rax
  800331:	00 00 00 
  800334:	ff d0                	callq  *%rax
  800336:	48 83 c4 10          	add    $0x10,%rsp
}
  80033a:	c9                   	leaveq 
  80033b:	c3                   	retq   

000000000080033c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80033c:	55                   	push   %rbp
  80033d:	48 89 e5             	mov    %rsp,%rbp
  800340:	48 83 ec 20          	sub    $0x20,%rsp
  800344:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800347:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80034b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80034e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800352:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800356:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800359:	48 63 c8             	movslq %eax,%rcx
  80035c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800360:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800363:	48 63 f0             	movslq %eax,%rsi
  800366:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80036a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80036d:	48 98                	cltq   
  80036f:	48 83 ec 08          	sub    $0x8,%rsp
  800373:	51                   	push   %rcx
  800374:	49 89 f9             	mov    %rdi,%r9
  800377:	49 89 f0             	mov    %rsi,%r8
  80037a:	48 89 d1             	mov    %rdx,%rcx
  80037d:	48 89 c2             	mov    %rax,%rdx
  800380:	be 01 00 00 00       	mov    $0x1,%esi
  800385:	bf 05 00 00 00       	mov    $0x5,%edi
  80038a:	48 b8 14 01 80 00 00 	movabs $0x800114,%rax
  800391:	00 00 00 
  800394:	ff d0                	callq  *%rax
  800396:	48 83 c4 10          	add    $0x10,%rsp
}
  80039a:	c9                   	leaveq 
  80039b:	c3                   	retq   

000000000080039c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80039c:	55                   	push   %rbp
  80039d:	48 89 e5             	mov    %rsp,%rbp
  8003a0:	48 83 ec 10          	sub    $0x10,%rsp
  8003a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003b2:	48 98                	cltq   
  8003b4:	48 83 ec 08          	sub    $0x8,%rsp
  8003b8:	6a 00                	pushq  $0x0
  8003ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003c6:	48 89 d1             	mov    %rdx,%rcx
  8003c9:	48 89 c2             	mov    %rax,%rdx
  8003cc:	be 01 00 00 00       	mov    $0x1,%esi
  8003d1:	bf 06 00 00 00       	mov    $0x6,%edi
  8003d6:	48 b8 14 01 80 00 00 	movabs $0x800114,%rax
  8003dd:	00 00 00 
  8003e0:	ff d0                	callq  *%rax
  8003e2:	48 83 c4 10          	add    $0x10,%rsp
}
  8003e6:	c9                   	leaveq 
  8003e7:	c3                   	retq   

00000000008003e8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003e8:	55                   	push   %rbp
  8003e9:	48 89 e5             	mov    %rsp,%rbp
  8003ec:	48 83 ec 10          	sub    $0x10,%rsp
  8003f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003f3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003f9:	48 63 d0             	movslq %eax,%rdx
  8003fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ff:	48 98                	cltq   
  800401:	48 83 ec 08          	sub    $0x8,%rsp
  800405:	6a 00                	pushq  $0x0
  800407:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80040d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800413:	48 89 d1             	mov    %rdx,%rcx
  800416:	48 89 c2             	mov    %rax,%rdx
  800419:	be 01 00 00 00       	mov    $0x1,%esi
  80041e:	bf 08 00 00 00       	mov    $0x8,%edi
  800423:	48 b8 14 01 80 00 00 	movabs $0x800114,%rax
  80042a:	00 00 00 
  80042d:	ff d0                	callq  *%rax
  80042f:	48 83 c4 10          	add    $0x10,%rsp
}
  800433:	c9                   	leaveq 
  800434:	c3                   	retq   

0000000000800435 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800435:	55                   	push   %rbp
  800436:	48 89 e5             	mov    %rsp,%rbp
  800439:	48 83 ec 10          	sub    $0x10,%rsp
  80043d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800440:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800444:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800448:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80044b:	48 98                	cltq   
  80044d:	48 83 ec 08          	sub    $0x8,%rsp
  800451:	6a 00                	pushq  $0x0
  800453:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800459:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80045f:	48 89 d1             	mov    %rdx,%rcx
  800462:	48 89 c2             	mov    %rax,%rdx
  800465:	be 01 00 00 00       	mov    $0x1,%esi
  80046a:	bf 09 00 00 00       	mov    $0x9,%edi
  80046f:	48 b8 14 01 80 00 00 	movabs $0x800114,%rax
  800476:	00 00 00 
  800479:	ff d0                	callq  *%rax
  80047b:	48 83 c4 10          	add    $0x10,%rsp
}
  80047f:	c9                   	leaveq 
  800480:	c3                   	retq   

0000000000800481 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800481:	55                   	push   %rbp
  800482:	48 89 e5             	mov    %rsp,%rbp
  800485:	48 83 ec 20          	sub    $0x20,%rsp
  800489:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80048c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800490:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800494:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800497:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80049a:	48 63 f0             	movslq %eax,%rsi
  80049d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004a4:	48 98                	cltq   
  8004a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004aa:	48 83 ec 08          	sub    $0x8,%rsp
  8004ae:	6a 00                	pushq  $0x0
  8004b0:	49 89 f1             	mov    %rsi,%r9
  8004b3:	49 89 c8             	mov    %rcx,%r8
  8004b6:	48 89 d1             	mov    %rdx,%rcx
  8004b9:	48 89 c2             	mov    %rax,%rdx
  8004bc:	be 00 00 00 00       	mov    $0x0,%esi
  8004c1:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004c6:	48 b8 14 01 80 00 00 	movabs $0x800114,%rax
  8004cd:	00 00 00 
  8004d0:	ff d0                	callq  *%rax
  8004d2:	48 83 c4 10          	add    $0x10,%rsp
}
  8004d6:	c9                   	leaveq 
  8004d7:	c3                   	retq   

00000000008004d8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004d8:	55                   	push   %rbp
  8004d9:	48 89 e5             	mov    %rsp,%rbp
  8004dc:	48 83 ec 10          	sub    $0x10,%rsp
  8004e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e8:	48 83 ec 08          	sub    $0x8,%rsp
  8004ec:	6a 00                	pushq  $0x0
  8004ee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004f4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004ff:	48 89 c2             	mov    %rax,%rdx
  800502:	be 01 00 00 00       	mov    $0x1,%esi
  800507:	bf 0c 00 00 00       	mov    $0xc,%edi
  80050c:	48 b8 14 01 80 00 00 	movabs $0x800114,%rax
  800513:	00 00 00 
  800516:	ff d0                	callq  *%rax
  800518:	48 83 c4 10          	add    $0x10,%rsp
}
  80051c:	c9                   	leaveq 
  80051d:	c3                   	retq   

000000000080051e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80051e:	55                   	push   %rbp
  80051f:	48 89 e5             	mov    %rsp,%rbp
  800522:	53                   	push   %rbx
  800523:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80052a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800531:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800537:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80053e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800545:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80054c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800553:	84 c0                	test   %al,%al
  800555:	74 23                	je     80057a <_panic+0x5c>
  800557:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80055e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800562:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800566:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80056a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80056e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800572:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800576:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80057a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800581:	00 00 00 
  800584:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80058b:	00 00 00 
  80058e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800592:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800599:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8005a0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005a7:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8005ae:	00 00 00 
  8005b1:	48 8b 18             	mov    (%rax),%rbx
  8005b4:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  8005bb:	00 00 00 
  8005be:	ff d0                	callq  *%rax
  8005c0:	89 c6                	mov    %eax,%esi
  8005c2:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8005c8:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8005cf:	41 89 d0             	mov    %edx,%r8d
  8005d2:	48 89 c1             	mov    %rax,%rcx
  8005d5:	48 89 da             	mov    %rbx,%rdx
  8005d8:	48 bf 98 1a 80 00 00 	movabs $0x801a98,%rdi
  8005df:	00 00 00 
  8005e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e7:	49 b9 58 07 80 00 00 	movabs $0x800758,%r9
  8005ee:	00 00 00 
  8005f1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005f4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005fb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800602:	48 89 d6             	mov    %rdx,%rsi
  800605:	48 89 c7             	mov    %rax,%rdi
  800608:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  80060f:	00 00 00 
  800612:	ff d0                	callq  *%rax
	cprintf("\n");
  800614:	48 bf bb 1a 80 00 00 	movabs $0x801abb,%rdi
  80061b:	00 00 00 
  80061e:	b8 00 00 00 00       	mov    $0x0,%eax
  800623:	48 ba 58 07 80 00 00 	movabs $0x800758,%rdx
  80062a:	00 00 00 
  80062d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80062f:	cc                   	int3   
  800630:	eb fd                	jmp    80062f <_panic+0x111>

0000000000800632 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800632:	55                   	push   %rbp
  800633:	48 89 e5             	mov    %rsp,%rbp
  800636:	48 83 ec 10          	sub    $0x10,%rsp
  80063a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80063d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800641:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800645:	8b 00                	mov    (%rax),%eax
  800647:	8d 48 01             	lea    0x1(%rax),%ecx
  80064a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80064e:	89 0a                	mov    %ecx,(%rdx)
  800650:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800653:	89 d1                	mov    %edx,%ecx
  800655:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800659:	48 98                	cltq   
  80065b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80065f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800663:	8b 00                	mov    (%rax),%eax
  800665:	3d ff 00 00 00       	cmp    $0xff,%eax
  80066a:	75 2c                	jne    800698 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80066c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800670:	8b 00                	mov    (%rax),%eax
  800672:	48 98                	cltq   
  800674:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800678:	48 83 c2 08          	add    $0x8,%rdx
  80067c:	48 89 c6             	mov    %rax,%rsi
  80067f:	48 89 d7             	mov    %rdx,%rdi
  800682:	48 b8 a2 01 80 00 00 	movabs $0x8001a2,%rax
  800689:	00 00 00 
  80068c:	ff d0                	callq  *%rax
        b->idx = 0;
  80068e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800692:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069c:	8b 40 04             	mov    0x4(%rax),%eax
  80069f:	8d 50 01             	lea    0x1(%rax),%edx
  8006a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006a9:	90                   	nop
  8006aa:	c9                   	leaveq 
  8006ab:	c3                   	retq   

00000000008006ac <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8006ac:	55                   	push   %rbp
  8006ad:	48 89 e5             	mov    %rsp,%rbp
  8006b0:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006b7:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006be:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006c5:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006cc:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006d3:	48 8b 0a             	mov    (%rdx),%rcx
  8006d6:	48 89 08             	mov    %rcx,(%rax)
  8006d9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006dd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006e9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006f0:	00 00 00 
    b.cnt = 0;
  8006f3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006fa:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006fd:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800704:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80070b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800712:	48 89 c6             	mov    %rax,%rsi
  800715:	48 bf 32 06 80 00 00 	movabs $0x800632,%rdi
  80071c:	00 00 00 
  80071f:	48 b8 f6 0a 80 00 00 	movabs $0x800af6,%rax
  800726:	00 00 00 
  800729:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80072b:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800731:	48 98                	cltq   
  800733:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80073a:	48 83 c2 08          	add    $0x8,%rdx
  80073e:	48 89 c6             	mov    %rax,%rsi
  800741:	48 89 d7             	mov    %rdx,%rdi
  800744:	48 b8 a2 01 80 00 00 	movabs $0x8001a2,%rax
  80074b:	00 00 00 
  80074e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800750:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800756:	c9                   	leaveq 
  800757:	c3                   	retq   

0000000000800758 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800758:	55                   	push   %rbp
  800759:	48 89 e5             	mov    %rsp,%rbp
  80075c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800763:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80076a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800771:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800778:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80077f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800786:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80078d:	84 c0                	test   %al,%al
  80078f:	74 20                	je     8007b1 <cprintf+0x59>
  800791:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800795:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800799:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80079d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8007a1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8007a5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007a9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007ad:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007b1:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007b8:	00 00 00 
  8007bb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007c2:	00 00 00 
  8007c5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007c9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007d0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007d7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007de:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007e5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007ec:	48 8b 0a             	mov    (%rdx),%rcx
  8007ef:	48 89 08             	mov    %rcx,(%rax)
  8007f2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007f6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007fa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007fe:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800802:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800809:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800810:	48 89 d6             	mov    %rdx,%rsi
  800813:	48 89 c7             	mov    %rax,%rdi
  800816:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  80081d:	00 00 00 
  800820:	ff d0                	callq  *%rax
  800822:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800828:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80082e:	c9                   	leaveq 
  80082f:	c3                   	retq   

0000000000800830 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800830:	55                   	push   %rbp
  800831:	48 89 e5             	mov    %rsp,%rbp
  800834:	48 83 ec 30          	sub    $0x30,%rsp
  800838:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80083c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800840:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800844:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800847:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80084b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80084f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800852:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800856:	77 54                	ja     8008ac <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800858:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80085b:	8d 78 ff             	lea    -0x1(%rax),%edi
  80085e:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800861:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800865:	ba 00 00 00 00       	mov    $0x0,%edx
  80086a:	48 f7 f6             	div    %rsi
  80086d:	49 89 c2             	mov    %rax,%r10
  800870:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800873:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800876:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80087a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80087e:	41 89 c9             	mov    %ecx,%r9d
  800881:	41 89 f8             	mov    %edi,%r8d
  800884:	89 d1                	mov    %edx,%ecx
  800886:	4c 89 d2             	mov    %r10,%rdx
  800889:	48 89 c7             	mov    %rax,%rdi
  80088c:	48 b8 30 08 80 00 00 	movabs $0x800830,%rax
  800893:	00 00 00 
  800896:	ff d0                	callq  *%rax
  800898:	eb 1c                	jmp    8008b6 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80089a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80089e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8008a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008a5:	48 89 ce             	mov    %rcx,%rsi
  8008a8:	89 d7                	mov    %edx,%edi
  8008aa:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008ac:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8008b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8008b4:	7f e4                	jg     80089a <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008b6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8008b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c2:	48 f7 f1             	div    %rcx
  8008c5:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  8008cc:	00 00 00 
  8008cf:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8008d3:	0f be d0             	movsbl %al,%edx
  8008d6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8008da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008de:	48 89 ce             	mov    %rcx,%rsi
  8008e1:	89 d7                	mov    %edx,%edi
  8008e3:	ff d0                	callq  *%rax
}
  8008e5:	90                   	nop
  8008e6:	c9                   	leaveq 
  8008e7:	c3                   	retq   

00000000008008e8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008e8:	55                   	push   %rbp
  8008e9:	48 89 e5             	mov    %rsp,%rbp
  8008ec:	48 83 ec 20          	sub    $0x20,%rsp
  8008f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008f4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008f7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008fb:	7e 4f                	jle    80094c <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8008fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800901:	8b 00                	mov    (%rax),%eax
  800903:	83 f8 30             	cmp    $0x30,%eax
  800906:	73 24                	jae    80092c <getuint+0x44>
  800908:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800910:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800914:	8b 00                	mov    (%rax),%eax
  800916:	89 c0                	mov    %eax,%eax
  800918:	48 01 d0             	add    %rdx,%rax
  80091b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091f:	8b 12                	mov    (%rdx),%edx
  800921:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800924:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800928:	89 0a                	mov    %ecx,(%rdx)
  80092a:	eb 14                	jmp    800940 <getuint+0x58>
  80092c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800930:	48 8b 40 08          	mov    0x8(%rax),%rax
  800934:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800938:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800940:	48 8b 00             	mov    (%rax),%rax
  800943:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800947:	e9 9d 00 00 00       	jmpq   8009e9 <getuint+0x101>
	else if (lflag)
  80094c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800950:	74 4c                	je     80099e <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800952:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800956:	8b 00                	mov    (%rax),%eax
  800958:	83 f8 30             	cmp    $0x30,%eax
  80095b:	73 24                	jae    800981 <getuint+0x99>
  80095d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800961:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800965:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800969:	8b 00                	mov    (%rax),%eax
  80096b:	89 c0                	mov    %eax,%eax
  80096d:	48 01 d0             	add    %rdx,%rax
  800970:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800974:	8b 12                	mov    (%rdx),%edx
  800976:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800979:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097d:	89 0a                	mov    %ecx,(%rdx)
  80097f:	eb 14                	jmp    800995 <getuint+0xad>
  800981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800985:	48 8b 40 08          	mov    0x8(%rax),%rax
  800989:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80098d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800991:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800995:	48 8b 00             	mov    (%rax),%rax
  800998:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80099c:	eb 4b                	jmp    8009e9 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  80099e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a2:	8b 00                	mov    (%rax),%eax
  8009a4:	83 f8 30             	cmp    $0x30,%eax
  8009a7:	73 24                	jae    8009cd <getuint+0xe5>
  8009a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ad:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b5:	8b 00                	mov    (%rax),%eax
  8009b7:	89 c0                	mov    %eax,%eax
  8009b9:	48 01 d0             	add    %rdx,%rax
  8009bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c0:	8b 12                	mov    (%rdx),%edx
  8009c2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c9:	89 0a                	mov    %ecx,(%rdx)
  8009cb:	eb 14                	jmp    8009e1 <getuint+0xf9>
  8009cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009d5:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009dd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e1:	8b 00                	mov    (%rax),%eax
  8009e3:	89 c0                	mov    %eax,%eax
  8009e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009ed:	c9                   	leaveq 
  8009ee:	c3                   	retq   

00000000008009ef <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009ef:	55                   	push   %rbp
  8009f0:	48 89 e5             	mov    %rsp,%rbp
  8009f3:	48 83 ec 20          	sub    $0x20,%rsp
  8009f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009fb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009fe:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a02:	7e 4f                	jle    800a53 <getint+0x64>
		x=va_arg(*ap, long long);
  800a04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a08:	8b 00                	mov    (%rax),%eax
  800a0a:	83 f8 30             	cmp    $0x30,%eax
  800a0d:	73 24                	jae    800a33 <getint+0x44>
  800a0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a13:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1b:	8b 00                	mov    (%rax),%eax
  800a1d:	89 c0                	mov    %eax,%eax
  800a1f:	48 01 d0             	add    %rdx,%rax
  800a22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a26:	8b 12                	mov    (%rdx),%edx
  800a28:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a2b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2f:	89 0a                	mov    %ecx,(%rdx)
  800a31:	eb 14                	jmp    800a47 <getint+0x58>
  800a33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a37:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a3b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a43:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a47:	48 8b 00             	mov    (%rax),%rax
  800a4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a4e:	e9 9d 00 00 00       	jmpq   800af0 <getint+0x101>
	else if (lflag)
  800a53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a57:	74 4c                	je     800aa5 <getint+0xb6>
		x=va_arg(*ap, long);
  800a59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5d:	8b 00                	mov    (%rax),%eax
  800a5f:	83 f8 30             	cmp    $0x30,%eax
  800a62:	73 24                	jae    800a88 <getint+0x99>
  800a64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a68:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a70:	8b 00                	mov    (%rax),%eax
  800a72:	89 c0                	mov    %eax,%eax
  800a74:	48 01 d0             	add    %rdx,%rax
  800a77:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7b:	8b 12                	mov    (%rdx),%edx
  800a7d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a84:	89 0a                	mov    %ecx,(%rdx)
  800a86:	eb 14                	jmp    800a9c <getint+0xad>
  800a88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a90:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a94:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a98:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a9c:	48 8b 00             	mov    (%rax),%rax
  800a9f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aa3:	eb 4b                	jmp    800af0 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800aa5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa9:	8b 00                	mov    (%rax),%eax
  800aab:	83 f8 30             	cmp    $0x30,%eax
  800aae:	73 24                	jae    800ad4 <getint+0xe5>
  800ab0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ab8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abc:	8b 00                	mov    (%rax),%eax
  800abe:	89 c0                	mov    %eax,%eax
  800ac0:	48 01 d0             	add    %rdx,%rax
  800ac3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac7:	8b 12                	mov    (%rdx),%edx
  800ac9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800acc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad0:	89 0a                	mov    %ecx,(%rdx)
  800ad2:	eb 14                	jmp    800ae8 <getint+0xf9>
  800ad4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad8:	48 8b 40 08          	mov    0x8(%rax),%rax
  800adc:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ae0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ae8:	8b 00                	mov    (%rax),%eax
  800aea:	48 98                	cltq   
  800aec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800af0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800af4:	c9                   	leaveq 
  800af5:	c3                   	retq   

0000000000800af6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800af6:	55                   	push   %rbp
  800af7:	48 89 e5             	mov    %rsp,%rbp
  800afa:	41 54                	push   %r12
  800afc:	53                   	push   %rbx
  800afd:	48 83 ec 60          	sub    $0x60,%rsp
  800b01:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b05:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b09:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b0d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b11:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b15:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b19:	48 8b 0a             	mov    (%rdx),%rcx
  800b1c:	48 89 08             	mov    %rcx,(%rax)
  800b1f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b23:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b27:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b2b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b2f:	eb 17                	jmp    800b48 <vprintfmt+0x52>
			if (ch == '\0')
  800b31:	85 db                	test   %ebx,%ebx
  800b33:	0f 84 b9 04 00 00    	je     800ff2 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800b39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b41:	48 89 d6             	mov    %rdx,%rsi
  800b44:	89 df                	mov    %ebx,%edi
  800b46:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b48:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b4c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b50:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b54:	0f b6 00             	movzbl (%rax),%eax
  800b57:	0f b6 d8             	movzbl %al,%ebx
  800b5a:	83 fb 25             	cmp    $0x25,%ebx
  800b5d:	75 d2                	jne    800b31 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b5f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b63:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b6a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b71:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b78:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b7f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b83:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b87:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b8b:	0f b6 00             	movzbl (%rax),%eax
  800b8e:	0f b6 d8             	movzbl %al,%ebx
  800b91:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b94:	83 f8 55             	cmp    $0x55,%eax
  800b97:	0f 87 22 04 00 00    	ja     800fbf <vprintfmt+0x4c9>
  800b9d:	89 c0                	mov    %eax,%eax
  800b9f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ba6:	00 
  800ba7:	48 b8 38 1c 80 00 00 	movabs $0x801c38,%rax
  800bae:	00 00 00 
  800bb1:	48 01 d0             	add    %rdx,%rax
  800bb4:	48 8b 00             	mov    (%rax),%rax
  800bb7:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bb9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bbd:	eb c0                	jmp    800b7f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bbf:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bc3:	eb ba                	jmp    800b7f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bcc:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bcf:	89 d0                	mov    %edx,%eax
  800bd1:	c1 e0 02             	shl    $0x2,%eax
  800bd4:	01 d0                	add    %edx,%eax
  800bd6:	01 c0                	add    %eax,%eax
  800bd8:	01 d8                	add    %ebx,%eax
  800bda:	83 e8 30             	sub    $0x30,%eax
  800bdd:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800be0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800be4:	0f b6 00             	movzbl (%rax),%eax
  800be7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bea:	83 fb 2f             	cmp    $0x2f,%ebx
  800bed:	7e 60                	jle    800c4f <vprintfmt+0x159>
  800bef:	83 fb 39             	cmp    $0x39,%ebx
  800bf2:	7f 5b                	jg     800c4f <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bf9:	eb d1                	jmp    800bcc <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800bfb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bfe:	83 f8 30             	cmp    $0x30,%eax
  800c01:	73 17                	jae    800c1a <vprintfmt+0x124>
  800c03:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c07:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c0a:	89 d2                	mov    %edx,%edx
  800c0c:	48 01 d0             	add    %rdx,%rax
  800c0f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c12:	83 c2 08             	add    $0x8,%edx
  800c15:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c18:	eb 0c                	jmp    800c26 <vprintfmt+0x130>
  800c1a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c1e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c22:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c26:	8b 00                	mov    (%rax),%eax
  800c28:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c2b:	eb 23                	jmp    800c50 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800c2d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c31:	0f 89 48 ff ff ff    	jns    800b7f <vprintfmt+0x89>
				width = 0;
  800c37:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c3e:	e9 3c ff ff ff       	jmpq   800b7f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c43:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c4a:	e9 30 ff ff ff       	jmpq   800b7f <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c4f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c50:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c54:	0f 89 25 ff ff ff    	jns    800b7f <vprintfmt+0x89>
				width = precision, precision = -1;
  800c5a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c5d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c60:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c67:	e9 13 ff ff ff       	jmpq   800b7f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c6c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c70:	e9 0a ff ff ff       	jmpq   800b7f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c78:	83 f8 30             	cmp    $0x30,%eax
  800c7b:	73 17                	jae    800c94 <vprintfmt+0x19e>
  800c7d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c81:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c84:	89 d2                	mov    %edx,%edx
  800c86:	48 01 d0             	add    %rdx,%rax
  800c89:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8c:	83 c2 08             	add    $0x8,%edx
  800c8f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c92:	eb 0c                	jmp    800ca0 <vprintfmt+0x1aa>
  800c94:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c98:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c9c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ca0:	8b 10                	mov    (%rax),%edx
  800ca2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ca6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800caa:	48 89 ce             	mov    %rcx,%rsi
  800cad:	89 d7                	mov    %edx,%edi
  800caf:	ff d0                	callq  *%rax
			break;
  800cb1:	e9 37 03 00 00       	jmpq   800fed <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cb6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb9:	83 f8 30             	cmp    $0x30,%eax
  800cbc:	73 17                	jae    800cd5 <vprintfmt+0x1df>
  800cbe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cc2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc5:	89 d2                	mov    %edx,%edx
  800cc7:	48 01 d0             	add    %rdx,%rax
  800cca:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ccd:	83 c2 08             	add    $0x8,%edx
  800cd0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cd3:	eb 0c                	jmp    800ce1 <vprintfmt+0x1eb>
  800cd5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cd9:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cdd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ce1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ce3:	85 db                	test   %ebx,%ebx
  800ce5:	79 02                	jns    800ce9 <vprintfmt+0x1f3>
				err = -err;
  800ce7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ce9:	83 fb 15             	cmp    $0x15,%ebx
  800cec:	7f 16                	jg     800d04 <vprintfmt+0x20e>
  800cee:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  800cf5:	00 00 00 
  800cf8:	48 63 d3             	movslq %ebx,%rdx
  800cfb:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cff:	4d 85 e4             	test   %r12,%r12
  800d02:	75 2e                	jne    800d32 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800d04:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0c:	89 d9                	mov    %ebx,%ecx
  800d0e:	48 ba 21 1c 80 00 00 	movabs $0x801c21,%rdx
  800d15:	00 00 00 
  800d18:	48 89 c7             	mov    %rax,%rdi
  800d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d20:	49 b8 fc 0f 80 00 00 	movabs $0x800ffc,%r8
  800d27:	00 00 00 
  800d2a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d2d:	e9 bb 02 00 00       	jmpq   800fed <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d32:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3a:	4c 89 e1             	mov    %r12,%rcx
  800d3d:	48 ba 2a 1c 80 00 00 	movabs $0x801c2a,%rdx
  800d44:	00 00 00 
  800d47:	48 89 c7             	mov    %rax,%rdi
  800d4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4f:	49 b8 fc 0f 80 00 00 	movabs $0x800ffc,%r8
  800d56:	00 00 00 
  800d59:	41 ff d0             	callq  *%r8
			break;
  800d5c:	e9 8c 02 00 00       	jmpq   800fed <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d64:	83 f8 30             	cmp    $0x30,%eax
  800d67:	73 17                	jae    800d80 <vprintfmt+0x28a>
  800d69:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d6d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d70:	89 d2                	mov    %edx,%edx
  800d72:	48 01 d0             	add    %rdx,%rax
  800d75:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d78:	83 c2 08             	add    $0x8,%edx
  800d7b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d7e:	eb 0c                	jmp    800d8c <vprintfmt+0x296>
  800d80:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d84:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d88:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d8c:	4c 8b 20             	mov    (%rax),%r12
  800d8f:	4d 85 e4             	test   %r12,%r12
  800d92:	75 0a                	jne    800d9e <vprintfmt+0x2a8>
				p = "(null)";
  800d94:	49 bc 2d 1c 80 00 00 	movabs $0x801c2d,%r12
  800d9b:	00 00 00 
			if (width > 0 && padc != '-')
  800d9e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800da2:	7e 78                	jle    800e1c <vprintfmt+0x326>
  800da4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800da8:	74 72                	je     800e1c <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800daa:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dad:	48 98                	cltq   
  800daf:	48 89 c6             	mov    %rax,%rsi
  800db2:	4c 89 e7             	mov    %r12,%rdi
  800db5:	48 b8 aa 12 80 00 00 	movabs $0x8012aa,%rax
  800dbc:	00 00 00 
  800dbf:	ff d0                	callq  *%rax
  800dc1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dc4:	eb 17                	jmp    800ddd <vprintfmt+0x2e7>
					putch(padc, putdat);
  800dc6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800dca:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd2:	48 89 ce             	mov    %rcx,%rsi
  800dd5:	89 d7                	mov    %edx,%edi
  800dd7:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ddd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800de1:	7f e3                	jg     800dc6 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800de3:	eb 37                	jmp    800e1c <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800de5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800de9:	74 1e                	je     800e09 <vprintfmt+0x313>
  800deb:	83 fb 1f             	cmp    $0x1f,%ebx
  800dee:	7e 05                	jle    800df5 <vprintfmt+0x2ff>
  800df0:	83 fb 7e             	cmp    $0x7e,%ebx
  800df3:	7e 14                	jle    800e09 <vprintfmt+0x313>
					putch('?', putdat);
  800df5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfd:	48 89 d6             	mov    %rdx,%rsi
  800e00:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e05:	ff d0                	callq  *%rax
  800e07:	eb 0f                	jmp    800e18 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800e09:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e0d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e11:	48 89 d6             	mov    %rdx,%rsi
  800e14:	89 df                	mov    %ebx,%edi
  800e16:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e18:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e1c:	4c 89 e0             	mov    %r12,%rax
  800e1f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e23:	0f b6 00             	movzbl (%rax),%eax
  800e26:	0f be d8             	movsbl %al,%ebx
  800e29:	85 db                	test   %ebx,%ebx
  800e2b:	74 28                	je     800e55 <vprintfmt+0x35f>
  800e2d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e31:	78 b2                	js     800de5 <vprintfmt+0x2ef>
  800e33:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e37:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e3b:	79 a8                	jns    800de5 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e3d:	eb 16                	jmp    800e55 <vprintfmt+0x35f>
				putch(' ', putdat);
  800e3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e47:	48 89 d6             	mov    %rdx,%rsi
  800e4a:	bf 20 00 00 00       	mov    $0x20,%edi
  800e4f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e51:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e55:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e59:	7f e4                	jg     800e3f <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800e5b:	e9 8d 01 00 00       	jmpq   800fed <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e60:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e64:	be 03 00 00 00       	mov    $0x3,%esi
  800e69:	48 89 c7             	mov    %rax,%rdi
  800e6c:	48 b8 ef 09 80 00 00 	movabs $0x8009ef,%rax
  800e73:	00 00 00 
  800e76:	ff d0                	callq  *%rax
  800e78:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e80:	48 85 c0             	test   %rax,%rax
  800e83:	79 1d                	jns    800ea2 <vprintfmt+0x3ac>
				putch('-', putdat);
  800e85:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e8d:	48 89 d6             	mov    %rdx,%rsi
  800e90:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e95:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9b:	48 f7 d8             	neg    %rax
  800e9e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ea2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ea9:	e9 d2 00 00 00       	jmpq   800f80 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800eae:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eb2:	be 03 00 00 00       	mov    $0x3,%esi
  800eb7:	48 89 c7             	mov    %rax,%rdi
  800eba:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800ec1:	00 00 00 
  800ec4:	ff d0                	callq  *%rax
  800ec6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800eca:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ed1:	e9 aa 00 00 00       	jmpq   800f80 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800ed6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eda:	be 03 00 00 00       	mov    $0x3,%esi
  800edf:	48 89 c7             	mov    %rax,%rdi
  800ee2:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800ee9:	00 00 00 
  800eec:	ff d0                	callq  *%rax
  800eee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ef2:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ef9:	e9 82 00 00 00       	jmpq   800f80 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800efe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f06:	48 89 d6             	mov    %rdx,%rsi
  800f09:	bf 30 00 00 00       	mov    $0x30,%edi
  800f0e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f18:	48 89 d6             	mov    %rdx,%rsi
  800f1b:	bf 78 00 00 00       	mov    $0x78,%edi
  800f20:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f22:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f25:	83 f8 30             	cmp    $0x30,%eax
  800f28:	73 17                	jae    800f41 <vprintfmt+0x44b>
  800f2a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f2e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f31:	89 d2                	mov    %edx,%edx
  800f33:	48 01 d0             	add    %rdx,%rax
  800f36:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f39:	83 c2 08             	add    $0x8,%edx
  800f3c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f3f:	eb 0c                	jmp    800f4d <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800f41:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800f45:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800f49:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f4d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f50:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f54:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f5b:	eb 23                	jmp    800f80 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f5d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f61:	be 03 00 00 00       	mov    $0x3,%esi
  800f66:	48 89 c7             	mov    %rax,%rdi
  800f69:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800f70:	00 00 00 
  800f73:	ff d0                	callq  *%rax
  800f75:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f79:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f80:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f85:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f88:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f8b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f8f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f97:	45 89 c1             	mov    %r8d,%r9d
  800f9a:	41 89 f8             	mov    %edi,%r8d
  800f9d:	48 89 c7             	mov    %rax,%rdi
  800fa0:	48 b8 30 08 80 00 00 	movabs $0x800830,%rax
  800fa7:	00 00 00 
  800faa:	ff d0                	callq  *%rax
			break;
  800fac:	eb 3f                	jmp    800fed <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fb6:	48 89 d6             	mov    %rdx,%rsi
  800fb9:	89 df                	mov    %ebx,%edi
  800fbb:	ff d0                	callq  *%rax
			break;
  800fbd:	eb 2e                	jmp    800fed <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fbf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fc3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc7:	48 89 d6             	mov    %rdx,%rsi
  800fca:	bf 25 00 00 00       	mov    $0x25,%edi
  800fcf:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fd1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fd6:	eb 05                	jmp    800fdd <vprintfmt+0x4e7>
  800fd8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fdd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fe1:	48 83 e8 01          	sub    $0x1,%rax
  800fe5:	0f b6 00             	movzbl (%rax),%eax
  800fe8:	3c 25                	cmp    $0x25,%al
  800fea:	75 ec                	jne    800fd8 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800fec:	90                   	nop
		}
	}
  800fed:	e9 3d fb ff ff       	jmpq   800b2f <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ff2:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ff3:	48 83 c4 60          	add    $0x60,%rsp
  800ff7:	5b                   	pop    %rbx
  800ff8:	41 5c                	pop    %r12
  800ffa:	5d                   	pop    %rbp
  800ffb:	c3                   	retq   

0000000000800ffc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ffc:	55                   	push   %rbp
  800ffd:	48 89 e5             	mov    %rsp,%rbp
  801000:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801007:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80100e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801015:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  80101c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801023:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80102a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801031:	84 c0                	test   %al,%al
  801033:	74 20                	je     801055 <printfmt+0x59>
  801035:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801039:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80103d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801041:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801045:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801049:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80104d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801051:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801055:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80105c:	00 00 00 
  80105f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801066:	00 00 00 
  801069:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80106d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801074:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80107b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801082:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801089:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801090:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801097:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80109e:	48 89 c7             	mov    %rax,%rdi
  8010a1:	48 b8 f6 0a 80 00 00 	movabs $0x800af6,%rax
  8010a8:	00 00 00 
  8010ab:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010ad:	90                   	nop
  8010ae:	c9                   	leaveq 
  8010af:	c3                   	retq   

00000000008010b0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010b0:	55                   	push   %rbp
  8010b1:	48 89 e5             	mov    %rsp,%rbp
  8010b4:	48 83 ec 10          	sub    $0x10,%rsp
  8010b8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c3:	8b 40 10             	mov    0x10(%rax),%eax
  8010c6:	8d 50 01             	lea    0x1(%rax),%edx
  8010c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010cd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d4:	48 8b 10             	mov    (%rax),%rdx
  8010d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010db:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010df:	48 39 c2             	cmp    %rax,%rdx
  8010e2:	73 17                	jae    8010fb <sprintputch+0x4b>
		*b->buf++ = ch;
  8010e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e8:	48 8b 00             	mov    (%rax),%rax
  8010eb:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010f3:	48 89 0a             	mov    %rcx,(%rdx)
  8010f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010f9:	88 10                	mov    %dl,(%rax)
}
  8010fb:	90                   	nop
  8010fc:	c9                   	leaveq 
  8010fd:	c3                   	retq   

00000000008010fe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010fe:	55                   	push   %rbp
  8010ff:	48 89 e5             	mov    %rsp,%rbp
  801102:	48 83 ec 50          	sub    $0x50,%rsp
  801106:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80110a:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80110d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801111:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801115:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801119:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80111d:	48 8b 0a             	mov    (%rdx),%rcx
  801120:	48 89 08             	mov    %rcx,(%rax)
  801123:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801127:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80112b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80112f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801133:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801137:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80113b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80113e:	48 98                	cltq   
  801140:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801144:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801148:	48 01 d0             	add    %rdx,%rax
  80114b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80114f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801156:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80115b:	74 06                	je     801163 <vsnprintf+0x65>
  80115d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801161:	7f 07                	jg     80116a <vsnprintf+0x6c>
		return -E_INVAL;
  801163:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801168:	eb 2f                	jmp    801199 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80116a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80116e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801172:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801176:	48 89 c6             	mov    %rax,%rsi
  801179:	48 bf b0 10 80 00 00 	movabs $0x8010b0,%rdi
  801180:	00 00 00 
  801183:	48 b8 f6 0a 80 00 00 	movabs $0x800af6,%rax
  80118a:	00 00 00 
  80118d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80118f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801193:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801196:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801199:	c9                   	leaveq 
  80119a:	c3                   	retq   

000000000080119b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80119b:	55                   	push   %rbp
  80119c:	48 89 e5             	mov    %rsp,%rbp
  80119f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011a6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011ad:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011b3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8011ba:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011c1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011c8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011cf:	84 c0                	test   %al,%al
  8011d1:	74 20                	je     8011f3 <snprintf+0x58>
  8011d3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011d7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011db:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011df:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011e3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011e7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011eb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011ef:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011f3:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011fa:	00 00 00 
  8011fd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801204:	00 00 00 
  801207:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80120b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801212:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801219:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801220:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801227:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80122e:	48 8b 0a             	mov    (%rdx),%rcx
  801231:	48 89 08             	mov    %rcx,(%rax)
  801234:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801238:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80123c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801240:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801244:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80124b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801252:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801258:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80125f:	48 89 c7             	mov    %rax,%rdi
  801262:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  801269:	00 00 00 
  80126c:	ff d0                	callq  *%rax
  80126e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801274:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80127a:	c9                   	leaveq 
  80127b:	c3                   	retq   

000000000080127c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80127c:	55                   	push   %rbp
  80127d:	48 89 e5             	mov    %rsp,%rbp
  801280:	48 83 ec 18          	sub    $0x18,%rsp
  801284:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801288:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80128f:	eb 09                	jmp    80129a <strlen+0x1e>
		n++;
  801291:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801295:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80129a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129e:	0f b6 00             	movzbl (%rax),%eax
  8012a1:	84 c0                	test   %al,%al
  8012a3:	75 ec                	jne    801291 <strlen+0x15>
		n++;
	return n;
  8012a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012a8:	c9                   	leaveq 
  8012a9:	c3                   	retq   

00000000008012aa <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012aa:	55                   	push   %rbp
  8012ab:	48 89 e5             	mov    %rsp,%rbp
  8012ae:	48 83 ec 20          	sub    $0x20,%rsp
  8012b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012c1:	eb 0e                	jmp    8012d1 <strnlen+0x27>
		n++;
  8012c3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012c7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012cc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012d1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012d6:	74 0b                	je     8012e3 <strnlen+0x39>
  8012d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012dc:	0f b6 00             	movzbl (%rax),%eax
  8012df:	84 c0                	test   %al,%al
  8012e1:	75 e0                	jne    8012c3 <strnlen+0x19>
		n++;
	return n;
  8012e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012e6:	c9                   	leaveq 
  8012e7:	c3                   	retq   

00000000008012e8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012e8:	55                   	push   %rbp
  8012e9:	48 89 e5             	mov    %rsp,%rbp
  8012ec:	48 83 ec 20          	sub    $0x20,%rsp
  8012f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801300:	90                   	nop
  801301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801305:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801309:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80130d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801311:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801315:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801319:	0f b6 12             	movzbl (%rdx),%edx
  80131c:	88 10                	mov    %dl,(%rax)
  80131e:	0f b6 00             	movzbl (%rax),%eax
  801321:	84 c0                	test   %al,%al
  801323:	75 dc                	jne    801301 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801325:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801329:	c9                   	leaveq 
  80132a:	c3                   	retq   

000000000080132b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80132b:	55                   	push   %rbp
  80132c:	48 89 e5             	mov    %rsp,%rbp
  80132f:	48 83 ec 20          	sub    $0x20,%rsp
  801333:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801337:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80133b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133f:	48 89 c7             	mov    %rax,%rdi
  801342:	48 b8 7c 12 80 00 00 	movabs $0x80127c,%rax
  801349:	00 00 00 
  80134c:	ff d0                	callq  *%rax
  80134e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801351:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801354:	48 63 d0             	movslq %eax,%rdx
  801357:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135b:	48 01 c2             	add    %rax,%rdx
  80135e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801362:	48 89 c6             	mov    %rax,%rsi
  801365:	48 89 d7             	mov    %rdx,%rdi
  801368:	48 b8 e8 12 80 00 00 	movabs $0x8012e8,%rax
  80136f:	00 00 00 
  801372:	ff d0                	callq  *%rax
	return dst;
  801374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801378:	c9                   	leaveq 
  801379:	c3                   	retq   

000000000080137a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80137a:	55                   	push   %rbp
  80137b:	48 89 e5             	mov    %rsp,%rbp
  80137e:	48 83 ec 28          	sub    $0x28,%rsp
  801382:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801386:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80138a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80138e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801392:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801396:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80139d:	00 
  80139e:	eb 2a                	jmp    8013ca <strncpy+0x50>
		*dst++ = *src;
  8013a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013ac:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013b0:	0f b6 12             	movzbl (%rdx),%edx
  8013b3:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013b9:	0f b6 00             	movzbl (%rax),%eax
  8013bc:	84 c0                	test   %al,%al
  8013be:	74 05                	je     8013c5 <strncpy+0x4b>
			src++;
  8013c0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ce:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013d2:	72 cc                	jb     8013a0 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013d8:	c9                   	leaveq 
  8013d9:	c3                   	retq   

00000000008013da <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013da:	55                   	push   %rbp
  8013db:	48 89 e5             	mov    %rsp,%rbp
  8013de:	48 83 ec 28          	sub    $0x28,%rsp
  8013e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013f6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013fb:	74 3d                	je     80143a <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8013fd:	eb 1d                	jmp    80141c <strlcpy+0x42>
			*dst++ = *src++;
  8013ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801403:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801407:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80140b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80140f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801413:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801417:	0f b6 12             	movzbl (%rdx),%edx
  80141a:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80141c:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801421:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801426:	74 0b                	je     801433 <strlcpy+0x59>
  801428:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80142c:	0f b6 00             	movzbl (%rax),%eax
  80142f:	84 c0                	test   %al,%al
  801431:	75 cc                	jne    8013ff <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801433:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801437:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80143a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80143e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801442:	48 29 c2             	sub    %rax,%rdx
  801445:	48 89 d0             	mov    %rdx,%rax
}
  801448:	c9                   	leaveq 
  801449:	c3                   	retq   

000000000080144a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80144a:	55                   	push   %rbp
  80144b:	48 89 e5             	mov    %rsp,%rbp
  80144e:	48 83 ec 10          	sub    $0x10,%rsp
  801452:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801456:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80145a:	eb 0a                	jmp    801466 <strcmp+0x1c>
		p++, q++;
  80145c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801461:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146a:	0f b6 00             	movzbl (%rax),%eax
  80146d:	84 c0                	test   %al,%al
  80146f:	74 12                	je     801483 <strcmp+0x39>
  801471:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801475:	0f b6 10             	movzbl (%rax),%edx
  801478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147c:	0f b6 00             	movzbl (%rax),%eax
  80147f:	38 c2                	cmp    %al,%dl
  801481:	74 d9                	je     80145c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801483:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801487:	0f b6 00             	movzbl (%rax),%eax
  80148a:	0f b6 d0             	movzbl %al,%edx
  80148d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801491:	0f b6 00             	movzbl (%rax),%eax
  801494:	0f b6 c0             	movzbl %al,%eax
  801497:	29 c2                	sub    %eax,%edx
  801499:	89 d0                	mov    %edx,%eax
}
  80149b:	c9                   	leaveq 
  80149c:	c3                   	retq   

000000000080149d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80149d:	55                   	push   %rbp
  80149e:	48 89 e5             	mov    %rsp,%rbp
  8014a1:	48 83 ec 18          	sub    $0x18,%rsp
  8014a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014ad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014b1:	eb 0f                	jmp    8014c2 <strncmp+0x25>
		n--, p++, q++;
  8014b3:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014b8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014bd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014c2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014c7:	74 1d                	je     8014e6 <strncmp+0x49>
  8014c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cd:	0f b6 00             	movzbl (%rax),%eax
  8014d0:	84 c0                	test   %al,%al
  8014d2:	74 12                	je     8014e6 <strncmp+0x49>
  8014d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d8:	0f b6 10             	movzbl (%rax),%edx
  8014db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014df:	0f b6 00             	movzbl (%rax),%eax
  8014e2:	38 c2                	cmp    %al,%dl
  8014e4:	74 cd                	je     8014b3 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014e6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014eb:	75 07                	jne    8014f4 <strncmp+0x57>
		return 0;
  8014ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f2:	eb 18                	jmp    80150c <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f8:	0f b6 00             	movzbl (%rax),%eax
  8014fb:	0f b6 d0             	movzbl %al,%edx
  8014fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801502:	0f b6 00             	movzbl (%rax),%eax
  801505:	0f b6 c0             	movzbl %al,%eax
  801508:	29 c2                	sub    %eax,%edx
  80150a:	89 d0                	mov    %edx,%eax
}
  80150c:	c9                   	leaveq 
  80150d:	c3                   	retq   

000000000080150e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80150e:	55                   	push   %rbp
  80150f:	48 89 e5             	mov    %rsp,%rbp
  801512:	48 83 ec 10          	sub    $0x10,%rsp
  801516:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80151a:	89 f0                	mov    %esi,%eax
  80151c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80151f:	eb 17                	jmp    801538 <strchr+0x2a>
		if (*s == c)
  801521:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801525:	0f b6 00             	movzbl (%rax),%eax
  801528:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80152b:	75 06                	jne    801533 <strchr+0x25>
			return (char *) s;
  80152d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801531:	eb 15                	jmp    801548 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801533:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801538:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153c:	0f b6 00             	movzbl (%rax),%eax
  80153f:	84 c0                	test   %al,%al
  801541:	75 de                	jne    801521 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801543:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801548:	c9                   	leaveq 
  801549:	c3                   	retq   

000000000080154a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80154a:	55                   	push   %rbp
  80154b:	48 89 e5             	mov    %rsp,%rbp
  80154e:	48 83 ec 10          	sub    $0x10,%rsp
  801552:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801556:	89 f0                	mov    %esi,%eax
  801558:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80155b:	eb 11                	jmp    80156e <strfind+0x24>
		if (*s == c)
  80155d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801561:	0f b6 00             	movzbl (%rax),%eax
  801564:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801567:	74 12                	je     80157b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801569:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80156e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801572:	0f b6 00             	movzbl (%rax),%eax
  801575:	84 c0                	test   %al,%al
  801577:	75 e4                	jne    80155d <strfind+0x13>
  801579:	eb 01                	jmp    80157c <strfind+0x32>
		if (*s == c)
			break;
  80157b:	90                   	nop
	return (char *) s;
  80157c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801580:	c9                   	leaveq 
  801581:	c3                   	retq   

0000000000801582 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801582:	55                   	push   %rbp
  801583:	48 89 e5             	mov    %rsp,%rbp
  801586:	48 83 ec 18          	sub    $0x18,%rsp
  80158a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80158e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801591:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801595:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80159a:	75 06                	jne    8015a2 <memset+0x20>
		return v;
  80159c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a0:	eb 69                	jmp    80160b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a6:	83 e0 03             	and    $0x3,%eax
  8015a9:	48 85 c0             	test   %rax,%rax
  8015ac:	75 48                	jne    8015f6 <memset+0x74>
  8015ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b2:	83 e0 03             	and    $0x3,%eax
  8015b5:	48 85 c0             	test   %rax,%rax
  8015b8:	75 3c                	jne    8015f6 <memset+0x74>
		c &= 0xFF;
  8015ba:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c4:	c1 e0 18             	shl    $0x18,%eax
  8015c7:	89 c2                	mov    %eax,%edx
  8015c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015cc:	c1 e0 10             	shl    $0x10,%eax
  8015cf:	09 c2                	or     %eax,%edx
  8015d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015d4:	c1 e0 08             	shl    $0x8,%eax
  8015d7:	09 d0                	or     %edx,%eax
  8015d9:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e0:	48 c1 e8 02          	shr    $0x2,%rax
  8015e4:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015e7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ee:	48 89 d7             	mov    %rdx,%rdi
  8015f1:	fc                   	cld    
  8015f2:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015f4:	eb 11                	jmp    801607 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015fd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801601:	48 89 d7             	mov    %rdx,%rdi
  801604:	fc                   	cld    
  801605:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801607:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80160b:	c9                   	leaveq 
  80160c:	c3                   	retq   

000000000080160d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80160d:	55                   	push   %rbp
  80160e:	48 89 e5             	mov    %rsp,%rbp
  801611:	48 83 ec 28          	sub    $0x28,%rsp
  801615:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801619:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80161d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801621:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801625:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801629:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80162d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801631:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801635:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801639:	0f 83 88 00 00 00    	jae    8016c7 <memmove+0xba>
  80163f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801643:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801647:	48 01 d0             	add    %rdx,%rax
  80164a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80164e:	76 77                	jbe    8016c7 <memmove+0xba>
		s += n;
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801660:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801664:	83 e0 03             	and    $0x3,%eax
  801667:	48 85 c0             	test   %rax,%rax
  80166a:	75 3b                	jne    8016a7 <memmove+0x9a>
  80166c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801670:	83 e0 03             	and    $0x3,%eax
  801673:	48 85 c0             	test   %rax,%rax
  801676:	75 2f                	jne    8016a7 <memmove+0x9a>
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	83 e0 03             	and    $0x3,%eax
  80167f:	48 85 c0             	test   %rax,%rax
  801682:	75 23                	jne    8016a7 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801684:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801688:	48 83 e8 04          	sub    $0x4,%rax
  80168c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801690:	48 83 ea 04          	sub    $0x4,%rdx
  801694:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801698:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80169c:	48 89 c7             	mov    %rax,%rdi
  80169f:	48 89 d6             	mov    %rdx,%rsi
  8016a2:	fd                   	std    
  8016a3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016a5:	eb 1d                	jmp    8016c4 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ab:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bb:	48 89 d7             	mov    %rdx,%rdi
  8016be:	48 89 c1             	mov    %rax,%rcx
  8016c1:	fd                   	std    
  8016c2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016c4:	fc                   	cld    
  8016c5:	eb 57                	jmp    80171e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cb:	83 e0 03             	and    $0x3,%eax
  8016ce:	48 85 c0             	test   %rax,%rax
  8016d1:	75 36                	jne    801709 <memmove+0xfc>
  8016d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d7:	83 e0 03             	and    $0x3,%eax
  8016da:	48 85 c0             	test   %rax,%rax
  8016dd:	75 2a                	jne    801709 <memmove+0xfc>
  8016df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e3:	83 e0 03             	and    $0x3,%eax
  8016e6:	48 85 c0             	test   %rax,%rax
  8016e9:	75 1e                	jne    801709 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ef:	48 c1 e8 02          	shr    $0x2,%rax
  8016f3:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016fa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016fe:	48 89 c7             	mov    %rax,%rdi
  801701:	48 89 d6             	mov    %rdx,%rsi
  801704:	fc                   	cld    
  801705:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801707:	eb 15                	jmp    80171e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801709:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801711:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801715:	48 89 c7             	mov    %rax,%rdi
  801718:	48 89 d6             	mov    %rdx,%rsi
  80171b:	fc                   	cld    
  80171c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80171e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801722:	c9                   	leaveq 
  801723:	c3                   	retq   

0000000000801724 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801724:	55                   	push   %rbp
  801725:	48 89 e5             	mov    %rsp,%rbp
  801728:	48 83 ec 18          	sub    $0x18,%rsp
  80172c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801730:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801734:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801738:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80173c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801740:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801744:	48 89 ce             	mov    %rcx,%rsi
  801747:	48 89 c7             	mov    %rax,%rdi
  80174a:	48 b8 0d 16 80 00 00 	movabs $0x80160d,%rax
  801751:	00 00 00 
  801754:	ff d0                	callq  *%rax
}
  801756:	c9                   	leaveq 
  801757:	c3                   	retq   

0000000000801758 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801758:	55                   	push   %rbp
  801759:	48 89 e5             	mov    %rsp,%rbp
  80175c:	48 83 ec 28          	sub    $0x28,%rsp
  801760:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801764:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801768:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80176c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801770:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801774:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801778:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80177c:	eb 36                	jmp    8017b4 <memcmp+0x5c>
		if (*s1 != *s2)
  80177e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801782:	0f b6 10             	movzbl (%rax),%edx
  801785:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801789:	0f b6 00             	movzbl (%rax),%eax
  80178c:	38 c2                	cmp    %al,%dl
  80178e:	74 1a                	je     8017aa <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801790:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801794:	0f b6 00             	movzbl (%rax),%eax
  801797:	0f b6 d0             	movzbl %al,%edx
  80179a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179e:	0f b6 00             	movzbl (%rax),%eax
  8017a1:	0f b6 c0             	movzbl %al,%eax
  8017a4:	29 c2                	sub    %eax,%edx
  8017a6:	89 d0                	mov    %edx,%eax
  8017a8:	eb 20                	jmp    8017ca <memcmp+0x72>
		s1++, s2++;
  8017aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017af:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017c0:	48 85 c0             	test   %rax,%rax
  8017c3:	75 b9                	jne    80177e <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ca:	c9                   	leaveq 
  8017cb:	c3                   	retq   

00000000008017cc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017cc:	55                   	push   %rbp
  8017cd:	48 89 e5             	mov    %rsp,%rbp
  8017d0:	48 83 ec 28          	sub    $0x28,%rsp
  8017d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017d8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e7:	48 01 d0             	add    %rdx,%rax
  8017ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017ee:	eb 19                	jmp    801809 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f4:	0f b6 00             	movzbl (%rax),%eax
  8017f7:	0f b6 d0             	movzbl %al,%edx
  8017fa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017fd:	0f b6 c0             	movzbl %al,%eax
  801800:	39 c2                	cmp    %eax,%edx
  801802:	74 11                	je     801815 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801804:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801809:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80180d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801811:	72 dd                	jb     8017f0 <memfind+0x24>
  801813:	eb 01                	jmp    801816 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801815:	90                   	nop
	return (void *) s;
  801816:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80181a:	c9                   	leaveq 
  80181b:	c3                   	retq   

000000000080181c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80181c:	55                   	push   %rbp
  80181d:	48 89 e5             	mov    %rsp,%rbp
  801820:	48 83 ec 38          	sub    $0x38,%rsp
  801824:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801828:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80182c:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80182f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801836:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80183d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80183e:	eb 05                	jmp    801845 <strtol+0x29>
		s++;
  801840:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801845:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801849:	0f b6 00             	movzbl (%rax),%eax
  80184c:	3c 20                	cmp    $0x20,%al
  80184e:	74 f0                	je     801840 <strtol+0x24>
  801850:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801854:	0f b6 00             	movzbl (%rax),%eax
  801857:	3c 09                	cmp    $0x9,%al
  801859:	74 e5                	je     801840 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80185b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185f:	0f b6 00             	movzbl (%rax),%eax
  801862:	3c 2b                	cmp    $0x2b,%al
  801864:	75 07                	jne    80186d <strtol+0x51>
		s++;
  801866:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80186b:	eb 17                	jmp    801884 <strtol+0x68>
	else if (*s == '-')
  80186d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801871:	0f b6 00             	movzbl (%rax),%eax
  801874:	3c 2d                	cmp    $0x2d,%al
  801876:	75 0c                	jne    801884 <strtol+0x68>
		s++, neg = 1;
  801878:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80187d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801884:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801888:	74 06                	je     801890 <strtol+0x74>
  80188a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80188e:	75 28                	jne    8018b8 <strtol+0x9c>
  801890:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801894:	0f b6 00             	movzbl (%rax),%eax
  801897:	3c 30                	cmp    $0x30,%al
  801899:	75 1d                	jne    8018b8 <strtol+0x9c>
  80189b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189f:	48 83 c0 01          	add    $0x1,%rax
  8018a3:	0f b6 00             	movzbl (%rax),%eax
  8018a6:	3c 78                	cmp    $0x78,%al
  8018a8:	75 0e                	jne    8018b8 <strtol+0x9c>
		s += 2, base = 16;
  8018aa:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018af:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018b6:	eb 2c                	jmp    8018e4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018b8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018bc:	75 19                	jne    8018d7 <strtol+0xbb>
  8018be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c2:	0f b6 00             	movzbl (%rax),%eax
  8018c5:	3c 30                	cmp    $0x30,%al
  8018c7:	75 0e                	jne    8018d7 <strtol+0xbb>
		s++, base = 8;
  8018c9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018ce:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018d5:	eb 0d                	jmp    8018e4 <strtol+0xc8>
	else if (base == 0)
  8018d7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018db:	75 07                	jne    8018e4 <strtol+0xc8>
		base = 10;
  8018dd:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e8:	0f b6 00             	movzbl (%rax),%eax
  8018eb:	3c 2f                	cmp    $0x2f,%al
  8018ed:	7e 1d                	jle    80190c <strtol+0xf0>
  8018ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f3:	0f b6 00             	movzbl (%rax),%eax
  8018f6:	3c 39                	cmp    $0x39,%al
  8018f8:	7f 12                	jg     80190c <strtol+0xf0>
			dig = *s - '0';
  8018fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fe:	0f b6 00             	movzbl (%rax),%eax
  801901:	0f be c0             	movsbl %al,%eax
  801904:	83 e8 30             	sub    $0x30,%eax
  801907:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80190a:	eb 4e                	jmp    80195a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80190c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801910:	0f b6 00             	movzbl (%rax),%eax
  801913:	3c 60                	cmp    $0x60,%al
  801915:	7e 1d                	jle    801934 <strtol+0x118>
  801917:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191b:	0f b6 00             	movzbl (%rax),%eax
  80191e:	3c 7a                	cmp    $0x7a,%al
  801920:	7f 12                	jg     801934 <strtol+0x118>
			dig = *s - 'a' + 10;
  801922:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801926:	0f b6 00             	movzbl (%rax),%eax
  801929:	0f be c0             	movsbl %al,%eax
  80192c:	83 e8 57             	sub    $0x57,%eax
  80192f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801932:	eb 26                	jmp    80195a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801934:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801938:	0f b6 00             	movzbl (%rax),%eax
  80193b:	3c 40                	cmp    $0x40,%al
  80193d:	7e 47                	jle    801986 <strtol+0x16a>
  80193f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801943:	0f b6 00             	movzbl (%rax),%eax
  801946:	3c 5a                	cmp    $0x5a,%al
  801948:	7f 3c                	jg     801986 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80194a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194e:	0f b6 00             	movzbl (%rax),%eax
  801951:	0f be c0             	movsbl %al,%eax
  801954:	83 e8 37             	sub    $0x37,%eax
  801957:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80195a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80195d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801960:	7d 23                	jge    801985 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801962:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801967:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80196a:	48 98                	cltq   
  80196c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801971:	48 89 c2             	mov    %rax,%rdx
  801974:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801977:	48 98                	cltq   
  801979:	48 01 d0             	add    %rdx,%rax
  80197c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801980:	e9 5f ff ff ff       	jmpq   8018e4 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801985:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801986:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80198b:	74 0b                	je     801998 <strtol+0x17c>
		*endptr = (char *) s;
  80198d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801991:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801995:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801998:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80199c:	74 09                	je     8019a7 <strtol+0x18b>
  80199e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a2:	48 f7 d8             	neg    %rax
  8019a5:	eb 04                	jmp    8019ab <strtol+0x18f>
  8019a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019ab:	c9                   	leaveq 
  8019ac:	c3                   	retq   

00000000008019ad <strstr>:

char * strstr(const char *in, const char *str)
{
  8019ad:	55                   	push   %rbp
  8019ae:	48 89 e5             	mov    %rsp,%rbp
  8019b1:	48 83 ec 30          	sub    $0x30,%rsp
  8019b5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019b9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019c1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019c5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019c9:	0f b6 00             	movzbl (%rax),%eax
  8019cc:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019cf:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019d3:	75 06                	jne    8019db <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d9:	eb 6b                	jmp    801a46 <strstr+0x99>

	len = strlen(str);
  8019db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019df:	48 89 c7             	mov    %rax,%rdi
  8019e2:	48 b8 7c 12 80 00 00 	movabs $0x80127c,%rax
  8019e9:	00 00 00 
  8019ec:	ff d0                	callq  *%rax
  8019ee:	48 98                	cltq   
  8019f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a00:	0f b6 00             	movzbl (%rax),%eax
  801a03:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a06:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a0a:	75 07                	jne    801a13 <strstr+0x66>
				return (char *) 0;
  801a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a11:	eb 33                	jmp    801a46 <strstr+0x99>
		} while (sc != c);
  801a13:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a17:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a1a:	75 d8                	jne    8019f4 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a1c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a20:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a28:	48 89 ce             	mov    %rcx,%rsi
  801a2b:	48 89 c7             	mov    %rax,%rdi
  801a2e:	48 b8 9d 14 80 00 00 	movabs $0x80149d,%rax
  801a35:	00 00 00 
  801a38:	ff d0                	callq  *%rax
  801a3a:	85 c0                	test   %eax,%eax
  801a3c:	75 b6                	jne    8019f4 <strstr+0x47>

	return (char *) (in - 1);
  801a3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a42:	48 83 e8 01          	sub    $0x1,%rax
}
  801a46:	c9                   	leaveq 
  801a47:	c3                   	retq   
