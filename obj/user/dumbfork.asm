
obj/user/dumbfork:     file format elf64-x86-64


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
  80003c:	e8 1e 03 00 00       	callq  80035f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

envid_t dumbfork(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t who;
	int i;

	// fork a child process
	who = dumbfork();
  800052:	48 b8 05 02 80 00 00 	movabs $0x800205,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800068:	eb 4f                	jmp    8000b9 <umain+0x76>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  80006a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80006e:	74 0c                	je     80007c <umain+0x39>
  800070:	48 b8 40 1d 80 00 00 	movabs $0x801d40,%rax
  800077:	00 00 00 
  80007a:	eb 0a                	jmp    800086 <umain+0x43>
  80007c:	48 b8 47 1d 80 00 00 	movabs $0x801d47,%rax
  800083:	00 00 00 
  800086:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800089:	48 89 c2             	mov    %rax,%rdx
  80008c:	89 ce                	mov    %ecx,%esi
  80008e:	48 bf 4d 1d 80 00 00 	movabs $0x801d4d,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 b9 3d 06 80 00 00 	movabs $0x80063d,%rcx
  8000a4:	00 00 00 
  8000a7:	ff d1                	callq  *%rcx
		sys_yield();
  8000a9:	48 b8 c6 1a 80 00 00 	movabs $0x801ac6,%rax
  8000b0:	00 00 00 
  8000b3:	ff d0                	callq  *%rax

	// fork a child process
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  8000b5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000b9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000bd:	74 07                	je     8000c6 <umain+0x83>
  8000bf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8000c4:	eb 05                	jmp    8000cb <umain+0x88>
  8000c6:	b8 14 00 00 00       	mov    $0x14,%eax
  8000cb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000ce:	7f 9a                	jg     80006a <umain+0x27>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
		sys_yield();
	}
}
  8000d0:	90                   	nop
  8000d1:	c9                   	leaveq 
  8000d2:	c3                   	retq   

00000000008000d3 <duppage>:

void
duppage(envid_t dstenv, void *addr)
{
  8000d3:	55                   	push   %rbp
  8000d4:	48 89 e5             	mov    %rsp,%rbp
  8000d7:	48 83 ec 20          	sub    $0x20,%rsp
  8000db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8000de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8000e2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8000e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e9:	ba 07 00 00 00       	mov    $0x7,%edx
  8000ee:	48 89 ce             	mov    %rcx,%rsi
  8000f1:	89 c7                	mov    %eax,%edi
  8000f3:	48 b8 03 1b 80 00 00 	movabs $0x801b03,%rax
  8000fa:	00 00 00 
  8000fd:	ff d0                	callq  *%rax
  8000ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800102:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800106:	79 30                	jns    800138 <duppage+0x65>
		panic("sys_page_alloc: %e", r);
  800108:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80010b:	89 c1                	mov    %eax,%ecx
  80010d:	48 ba 5f 1d 80 00 00 	movabs $0x801d5f,%rdx
  800114:	00 00 00 
  800117:	be 20 00 00 00       	mov    $0x20,%esi
  80011c:	48 bf 72 1d 80 00 00 	movabs $0x801d72,%rdi
  800123:	00 00 00 
  800126:	b8 00 00 00 00       	mov    $0x0,%eax
  80012b:	49 b8 03 04 80 00 00 	movabs $0x800403,%r8
  800132:	00 00 00 
  800135:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800138:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80013c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80013f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  800145:	b9 00 00 40 00       	mov    $0x400000,%ecx
  80014a:	ba 00 00 00 00       	mov    $0x0,%edx
  80014f:	89 c7                	mov    %eax,%edi
  800151:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  800158:	00 00 00 
  80015b:	ff d0                	callq  *%rax
  80015d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800160:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800164:	79 30                	jns    800196 <duppage+0xc3>
		panic("sys_page_map: %e", r);
  800166:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800169:	89 c1                	mov    %eax,%ecx
  80016b:	48 ba 82 1d 80 00 00 	movabs $0x801d82,%rdx
  800172:	00 00 00 
  800175:	be 22 00 00 00       	mov    $0x22,%esi
  80017a:	48 bf 72 1d 80 00 00 	movabs $0x801d72,%rdi
  800181:	00 00 00 
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	49 b8 03 04 80 00 00 	movabs $0x800403,%r8
  800190:	00 00 00 
  800193:	41 ff d0             	callq  *%r8
	memmove(UTEMP, addr, PGSIZE);
  800196:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80019a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80019f:	48 89 c6             	mov    %rax,%rsi
  8001a2:	bf 00 00 40 00       	mov    $0x400000,%edi
  8001a7:	48 b8 f2 14 80 00 00 	movabs $0x8014f2,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8001b3:	be 00 00 40 00       	mov    $0x400000,%esi
  8001b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001bd:	48 b8 b5 1b 80 00 00 	movabs $0x801bb5,%rax
  8001c4:	00 00 00 
  8001c7:	ff d0                	callq  *%rax
  8001c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d0:	79 30                	jns    800202 <duppage+0x12f>
		panic("sys_page_unmap: %e", r);
  8001d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d5:	89 c1                	mov    %eax,%ecx
  8001d7:	48 ba 93 1d 80 00 00 	movabs $0x801d93,%rdx
  8001de:	00 00 00 
  8001e1:	be 25 00 00 00       	mov    $0x25,%esi
  8001e6:	48 bf 72 1d 80 00 00 	movabs $0x801d72,%rdi
  8001ed:	00 00 00 
  8001f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f5:	49 b8 03 04 80 00 00 	movabs $0x800403,%r8
  8001fc:	00 00 00 
  8001ff:	41 ff d0             	callq  *%r8
}
  800202:	90                   	nop
  800203:	c9                   	leaveq 
  800204:	c3                   	retq   

0000000000800205 <dumbfork>:

envid_t
dumbfork(void)
{
  800205:	55                   	push   %rbp
  800206:	48 89 e5             	mov    %rsp,%rbp
  800209:	48 83 ec 20          	sub    $0x20,%rsp
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80020d:	b8 07 00 00 00       	mov    $0x7,%eax
  800212:	cd 30                	int    $0x30
  800214:	89 45 e8             	mov    %eax,-0x18(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  800217:	8b 45 e8             	mov    -0x18(%rbp),%eax
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
  80021a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (envid < 0)
  80021d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800221:	79 30                	jns    800253 <dumbfork+0x4e>
		panic("sys_exofork: %e", envid);
  800223:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800226:	89 c1                	mov    %eax,%ecx
  800228:	48 ba a6 1d 80 00 00 	movabs $0x801da6,%rdx
  80022f:	00 00 00 
  800232:	be 37 00 00 00       	mov    $0x37,%esi
  800237:	48 bf 72 1d 80 00 00 	movabs $0x801d72,%rdi
  80023e:	00 00 00 
  800241:	b8 00 00 00 00       	mov    $0x0,%eax
  800246:	49 b8 03 04 80 00 00 	movabs $0x800403,%r8
  80024d:	00 00 00 
  800250:	41 ff d0             	callq  *%r8
	if (envid == 0) {
  800253:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800257:	75 46                	jne    80029f <dumbfork+0x9a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  800259:	48 b8 8a 1a 80 00 00 	movabs $0x801a8a,%rax
  800260:	00 00 00 
  800263:	ff d0                	callq  *%rax
  800265:	25 ff 03 00 00       	and    $0x3ff,%eax
  80026a:	48 63 d0             	movslq %eax,%rdx
  80026d:	48 89 d0             	mov    %rdx,%rax
  800270:	48 c1 e0 03          	shl    $0x3,%rax
  800274:	48 01 d0             	add    %rdx,%rax
  800277:	48 c1 e0 05          	shl    $0x5,%rax
  80027b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800282:	00 00 00 
  800285:	48 01 c2             	add    %rax,%rdx
  800288:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80028f:	00 00 00 
  800292:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  800295:	b8 00 00 00 00       	mov    $0x0,%eax
  80029a:	e9 be 00 00 00       	jmpq   80035d <dumbfork+0x158>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80029f:	48 c7 45 e0 00 00 80 	movq   $0x800000,-0x20(%rbp)
  8002a6:	00 
  8002a7:	eb 26                	jmp    8002cf <dumbfork+0xca>
		duppage(envid, addr);
  8002a9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002b0:	48 89 d6             	mov    %rdx,%rsi
  8002b3:	89 c7                	mov    %eax,%edi
  8002b5:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  8002bc:	00 00 00 
  8002bf:	ff d0                	callq  *%rax
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8002c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002c5:	48 05 00 10 00 00    	add    $0x1000,%rax
  8002cb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8002cf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002d3:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  8002da:	00 00 00 
  8002dd:	48 39 c2             	cmp    %rax,%rdx
  8002e0:	72 c7                	jb     8002a9 <dumbfork+0xa4>
		duppage(envid, addr);

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  8002e2:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8002e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8002ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ee:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8002f4:	48 89 c2             	mov    %rax,%rdx
  8002f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002fa:	48 89 d6             	mov    %rdx,%rsi
  8002fd:	89 c7                	mov    %eax,%edi
  8002ff:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  800306:	00 00 00 
  800309:	ff d0                	callq  *%rax

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80030b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80030e:	be 02 00 00 00       	mov    $0x2,%esi
  800313:	89 c7                	mov    %eax,%edi
  800315:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  80031c:	00 00 00 
  80031f:	ff d0                	callq  *%rax
  800321:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800324:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800328:	79 30                	jns    80035a <dumbfork+0x155>
		panic("sys_env_set_status: %e", r);
  80032a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80032d:	89 c1                	mov    %eax,%ecx
  80032f:	48 ba b6 1d 80 00 00 	movabs $0x801db6,%rdx
  800336:	00 00 00 
  800339:	be 4c 00 00 00       	mov    $0x4c,%esi
  80033e:	48 bf 72 1d 80 00 00 	movabs $0x801d72,%rdi
  800345:	00 00 00 
  800348:	b8 00 00 00 00       	mov    $0x0,%eax
  80034d:	49 b8 03 04 80 00 00 	movabs $0x800403,%r8
  800354:	00 00 00 
  800357:	41 ff d0             	callq  *%r8

	return envid;
  80035a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80035d:	c9                   	leaveq 
  80035e:	c3                   	retq   

000000000080035f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80035f:	55                   	push   %rbp
  800360:	48 89 e5             	mov    %rsp,%rbp
  800363:	48 83 ec 10          	sub    $0x10,%rsp
  800367:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80036a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	
	thisenv=&envs[ENVX(sys_getenvid())]; 
  80036e:	48 b8 8a 1a 80 00 00 	movabs $0x801a8a,%rax
  800375:	00 00 00 
  800378:	ff d0                	callq  *%rax
  80037a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80037f:	48 63 d0             	movslq %eax,%rdx
  800382:	48 89 d0             	mov    %rdx,%rax
  800385:	48 c1 e0 03          	shl    $0x3,%rax
  800389:	48 01 d0             	add    %rdx,%rax
  80038c:	48 c1 e0 05          	shl    $0x5,%rax
  800390:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800397:	00 00 00 
  80039a:	48 01 c2             	add    %rax,%rdx
  80039d:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8003a4:	00 00 00 
  8003a7:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003ae:	7e 14                	jle    8003c4 <libmain+0x65>
		binaryname = argv[0];
  8003b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b4:	48 8b 10             	mov    (%rax),%rdx
  8003b7:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8003be:	00 00 00 
  8003c1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003cb:	48 89 d6             	mov    %rdx,%rsi
  8003ce:	89 c7                	mov    %eax,%edi
  8003d0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003dc:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  8003e3:	00 00 00 
  8003e6:	ff d0                	callq  *%rax
}
  8003e8:	90                   	nop
  8003e9:	c9                   	leaveq 
  8003ea:	c3                   	retq   

00000000008003eb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003eb:	55                   	push   %rbp
  8003ec:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8003ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8003f4:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  8003fb:	00 00 00 
  8003fe:	ff d0                	callq  *%rax
}
  800400:	90                   	nop
  800401:	5d                   	pop    %rbp
  800402:	c3                   	retq   

0000000000800403 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800403:	55                   	push   %rbp
  800404:	48 89 e5             	mov    %rsp,%rbp
  800407:	53                   	push   %rbx
  800408:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80040f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800416:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80041c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800423:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80042a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800431:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800438:	84 c0                	test   %al,%al
  80043a:	74 23                	je     80045f <_panic+0x5c>
  80043c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800443:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800447:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80044b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80044f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800453:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800457:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80045b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80045f:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800466:	00 00 00 
  800469:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800470:	00 00 00 
  800473:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800477:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80047e:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800485:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80048c:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800493:	00 00 00 
  800496:	48 8b 18             	mov    (%rax),%rbx
  800499:	48 b8 8a 1a 80 00 00 	movabs $0x801a8a,%rax
  8004a0:	00 00 00 
  8004a3:	ff d0                	callq  *%rax
  8004a5:	89 c6                	mov    %eax,%esi
  8004a7:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8004ad:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8004b4:	41 89 d0             	mov    %edx,%r8d
  8004b7:	48 89 c1             	mov    %rax,%rcx
  8004ba:	48 89 da             	mov    %rbx,%rdx
  8004bd:	48 bf d8 1d 80 00 00 	movabs $0x801dd8,%rdi
  8004c4:	00 00 00 
  8004c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004cc:	49 b9 3d 06 80 00 00 	movabs $0x80063d,%r9
  8004d3:	00 00 00 
  8004d6:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004d9:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004e0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004e7:	48 89 d6             	mov    %rdx,%rsi
  8004ea:	48 89 c7             	mov    %rax,%rdi
  8004ed:	48 b8 91 05 80 00 00 	movabs $0x800591,%rax
  8004f4:	00 00 00 
  8004f7:	ff d0                	callq  *%rax
	cprintf("\n");
  8004f9:	48 bf fb 1d 80 00 00 	movabs $0x801dfb,%rdi
  800500:	00 00 00 
  800503:	b8 00 00 00 00       	mov    $0x0,%eax
  800508:	48 ba 3d 06 80 00 00 	movabs $0x80063d,%rdx
  80050f:	00 00 00 
  800512:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800514:	cc                   	int3   
  800515:	eb fd                	jmp    800514 <_panic+0x111>

0000000000800517 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800517:	55                   	push   %rbp
  800518:	48 89 e5             	mov    %rsp,%rbp
  80051b:	48 83 ec 10          	sub    $0x10,%rsp
  80051f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800522:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800526:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80052a:	8b 00                	mov    (%rax),%eax
  80052c:	8d 48 01             	lea    0x1(%rax),%ecx
  80052f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800533:	89 0a                	mov    %ecx,(%rdx)
  800535:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800538:	89 d1                	mov    %edx,%ecx
  80053a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80053e:	48 98                	cltq   
  800540:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800544:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800548:	8b 00                	mov    (%rax),%eax
  80054a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80054f:	75 2c                	jne    80057d <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800555:	8b 00                	mov    (%rax),%eax
  800557:	48 98                	cltq   
  800559:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80055d:	48 83 c2 08          	add    $0x8,%rdx
  800561:	48 89 c6             	mov    %rax,%rsi
  800564:	48 89 d7             	mov    %rdx,%rdi
  800567:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  80056e:	00 00 00 
  800571:	ff d0                	callq  *%rax
        b->idx = 0;
  800573:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800577:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80057d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800581:	8b 40 04             	mov    0x4(%rax),%eax
  800584:	8d 50 01             	lea    0x1(%rax),%edx
  800587:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80058b:	89 50 04             	mov    %edx,0x4(%rax)
}
  80058e:	90                   	nop
  80058f:	c9                   	leaveq 
  800590:	c3                   	retq   

0000000000800591 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800591:	55                   	push   %rbp
  800592:	48 89 e5             	mov    %rsp,%rbp
  800595:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80059c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005a3:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005aa:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005b1:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005b8:	48 8b 0a             	mov    (%rdx),%rcx
  8005bb:	48 89 08             	mov    %rcx,(%rax)
  8005be:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005c2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005c6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005ca:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005ce:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005d5:	00 00 00 
    b.cnt = 0;
  8005d8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005df:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005e2:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005e9:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005f0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005f7:	48 89 c6             	mov    %rax,%rsi
  8005fa:	48 bf 17 05 80 00 00 	movabs $0x800517,%rdi
  800601:	00 00 00 
  800604:	48 b8 db 09 80 00 00 	movabs $0x8009db,%rax
  80060b:	00 00 00 
  80060e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800610:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800616:	48 98                	cltq   
  800618:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80061f:	48 83 c2 08          	add    $0x8,%rdx
  800623:	48 89 c6             	mov    %rax,%rsi
  800626:	48 89 d7             	mov    %rdx,%rdi
  800629:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  800630:	00 00 00 
  800633:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800635:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80063b:	c9                   	leaveq 
  80063c:	c3                   	retq   

000000000080063d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80063d:	55                   	push   %rbp
  80063e:	48 89 e5             	mov    %rsp,%rbp
  800641:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800648:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80064f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800656:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80065d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800664:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80066b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800672:	84 c0                	test   %al,%al
  800674:	74 20                	je     800696 <cprintf+0x59>
  800676:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80067a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80067e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800682:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800686:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80068a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80068e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800692:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800696:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80069d:	00 00 00 
  8006a0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006a7:	00 00 00 
  8006aa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006ae:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006b5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006bc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006c3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006ca:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006d1:	48 8b 0a             	mov    (%rdx),%rcx
  8006d4:	48 89 08             	mov    %rcx,(%rax)
  8006d7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006db:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006df:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006e7:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006ee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006f5:	48 89 d6             	mov    %rdx,%rsi
  8006f8:	48 89 c7             	mov    %rax,%rdi
  8006fb:	48 b8 91 05 80 00 00 	movabs $0x800591,%rax
  800702:	00 00 00 
  800705:	ff d0                	callq  *%rax
  800707:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80070d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800713:	c9                   	leaveq 
  800714:	c3                   	retq   

0000000000800715 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800715:	55                   	push   %rbp
  800716:	48 89 e5             	mov    %rsp,%rbp
  800719:	48 83 ec 30          	sub    $0x30,%rsp
  80071d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800721:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800725:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800729:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80072c:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800730:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800734:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800737:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80073b:	77 54                	ja     800791 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80073d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800740:	8d 78 ff             	lea    -0x1(%rax),%edi
  800743:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074a:	ba 00 00 00 00       	mov    $0x0,%edx
  80074f:	48 f7 f6             	div    %rsi
  800752:	49 89 c2             	mov    %rax,%r10
  800755:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800758:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80075b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80075f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800763:	41 89 c9             	mov    %ecx,%r9d
  800766:	41 89 f8             	mov    %edi,%r8d
  800769:	89 d1                	mov    %edx,%ecx
  80076b:	4c 89 d2             	mov    %r10,%rdx
  80076e:	48 89 c7             	mov    %rax,%rdi
  800771:	48 b8 15 07 80 00 00 	movabs $0x800715,%rax
  800778:	00 00 00 
  80077b:	ff d0                	callq  *%rax
  80077d:	eb 1c                	jmp    80079b <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80077f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800783:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800786:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80078a:	48 89 ce             	mov    %rcx,%rsi
  80078d:	89 d7                	mov    %edx,%edi
  80078f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800791:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800795:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800799:	7f e4                	jg     80077f <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80079b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80079e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a7:	48 f7 f1             	div    %rcx
  8007aa:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  8007b1:	00 00 00 
  8007b4:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8007b8:	0f be d0             	movsbl %al,%edx
  8007bb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8007bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007c3:	48 89 ce             	mov    %rcx,%rsi
  8007c6:	89 d7                	mov    %edx,%edi
  8007c8:	ff d0                	callq  *%rax
}
  8007ca:	90                   	nop
  8007cb:	c9                   	leaveq 
  8007cc:	c3                   	retq   

00000000008007cd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007cd:	55                   	push   %rbp
  8007ce:	48 89 e5             	mov    %rsp,%rbp
  8007d1:	48 83 ec 20          	sub    $0x20,%rsp
  8007d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007d9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007dc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007e0:	7e 4f                	jle    800831 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8007e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e6:	8b 00                	mov    (%rax),%eax
  8007e8:	83 f8 30             	cmp    $0x30,%eax
  8007eb:	73 24                	jae    800811 <getuint+0x44>
  8007ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f9:	8b 00                	mov    (%rax),%eax
  8007fb:	89 c0                	mov    %eax,%eax
  8007fd:	48 01 d0             	add    %rdx,%rax
  800800:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800804:	8b 12                	mov    (%rdx),%edx
  800806:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800809:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080d:	89 0a                	mov    %ecx,(%rdx)
  80080f:	eb 14                	jmp    800825 <getuint+0x58>
  800811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800815:	48 8b 40 08          	mov    0x8(%rax),%rax
  800819:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80081d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800821:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800825:	48 8b 00             	mov    (%rax),%rax
  800828:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80082c:	e9 9d 00 00 00       	jmpq   8008ce <getuint+0x101>
	else if (lflag)
  800831:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800835:	74 4c                	je     800883 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083b:	8b 00                	mov    (%rax),%eax
  80083d:	83 f8 30             	cmp    $0x30,%eax
  800840:	73 24                	jae    800866 <getuint+0x99>
  800842:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800846:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80084a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084e:	8b 00                	mov    (%rax),%eax
  800850:	89 c0                	mov    %eax,%eax
  800852:	48 01 d0             	add    %rdx,%rax
  800855:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800859:	8b 12                	mov    (%rdx),%edx
  80085b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80085e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800862:	89 0a                	mov    %ecx,(%rdx)
  800864:	eb 14                	jmp    80087a <getuint+0xad>
  800866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80086e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800872:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800876:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80087a:	48 8b 00             	mov    (%rax),%rax
  80087d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800881:	eb 4b                	jmp    8008ce <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800883:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800887:	8b 00                	mov    (%rax),%eax
  800889:	83 f8 30             	cmp    $0x30,%eax
  80088c:	73 24                	jae    8008b2 <getuint+0xe5>
  80088e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800892:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800896:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089a:	8b 00                	mov    (%rax),%eax
  80089c:	89 c0                	mov    %eax,%eax
  80089e:	48 01 d0             	add    %rdx,%rax
  8008a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a5:	8b 12                	mov    (%rdx),%edx
  8008a7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ae:	89 0a                	mov    %ecx,(%rdx)
  8008b0:	eb 14                	jmp    8008c6 <getuint+0xf9>
  8008b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008ba:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008c6:	8b 00                	mov    (%rax),%eax
  8008c8:	89 c0                	mov    %eax,%eax
  8008ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008d2:	c9                   	leaveq 
  8008d3:	c3                   	retq   

00000000008008d4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008d4:	55                   	push   %rbp
  8008d5:	48 89 e5             	mov    %rsp,%rbp
  8008d8:	48 83 ec 20          	sub    $0x20,%rsp
  8008dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008e0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008e3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008e7:	7e 4f                	jle    800938 <getint+0x64>
		x=va_arg(*ap, long long);
  8008e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ed:	8b 00                	mov    (%rax),%eax
  8008ef:	83 f8 30             	cmp    $0x30,%eax
  8008f2:	73 24                	jae    800918 <getint+0x44>
  8008f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800900:	8b 00                	mov    (%rax),%eax
  800902:	89 c0                	mov    %eax,%eax
  800904:	48 01 d0             	add    %rdx,%rax
  800907:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090b:	8b 12                	mov    (%rdx),%edx
  80090d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800910:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800914:	89 0a                	mov    %ecx,(%rdx)
  800916:	eb 14                	jmp    80092c <getint+0x58>
  800918:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800920:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800924:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800928:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80092c:	48 8b 00             	mov    (%rax),%rax
  80092f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800933:	e9 9d 00 00 00       	jmpq   8009d5 <getint+0x101>
	else if (lflag)
  800938:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80093c:	74 4c                	je     80098a <getint+0xb6>
		x=va_arg(*ap, long);
  80093e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800942:	8b 00                	mov    (%rax),%eax
  800944:	83 f8 30             	cmp    $0x30,%eax
  800947:	73 24                	jae    80096d <getint+0x99>
  800949:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800955:	8b 00                	mov    (%rax),%eax
  800957:	89 c0                	mov    %eax,%eax
  800959:	48 01 d0             	add    %rdx,%rax
  80095c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800960:	8b 12                	mov    (%rdx),%edx
  800962:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800965:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800969:	89 0a                	mov    %ecx,(%rdx)
  80096b:	eb 14                	jmp    800981 <getint+0xad>
  80096d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800971:	48 8b 40 08          	mov    0x8(%rax),%rax
  800975:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800979:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800981:	48 8b 00             	mov    (%rax),%rax
  800984:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800988:	eb 4b                	jmp    8009d5 <getint+0x101>
	else
		x=va_arg(*ap, int);
  80098a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098e:	8b 00                	mov    (%rax),%eax
  800990:	83 f8 30             	cmp    $0x30,%eax
  800993:	73 24                	jae    8009b9 <getint+0xe5>
  800995:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800999:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80099d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a1:	8b 00                	mov    (%rax),%eax
  8009a3:	89 c0                	mov    %eax,%eax
  8009a5:	48 01 d0             	add    %rdx,%rax
  8009a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ac:	8b 12                	mov    (%rdx),%edx
  8009ae:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b5:	89 0a                	mov    %ecx,(%rdx)
  8009b7:	eb 14                	jmp    8009cd <getint+0xf9>
  8009b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bd:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009c1:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009cd:	8b 00                	mov    (%rax),%eax
  8009cf:	48 98                	cltq   
  8009d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009d9:	c9                   	leaveq 
  8009da:	c3                   	retq   

00000000008009db <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009db:	55                   	push   %rbp
  8009dc:	48 89 e5             	mov    %rsp,%rbp
  8009df:	41 54                	push   %r12
  8009e1:	53                   	push   %rbx
  8009e2:	48 83 ec 60          	sub    $0x60,%rsp
  8009e6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009ea:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009ee:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009f2:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009f6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009fa:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009fe:	48 8b 0a             	mov    (%rdx),%rcx
  800a01:	48 89 08             	mov    %rcx,(%rax)
  800a04:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a08:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a0c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a10:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a14:	eb 17                	jmp    800a2d <vprintfmt+0x52>
			if (ch == '\0')
  800a16:	85 db                	test   %ebx,%ebx
  800a18:	0f 84 b9 04 00 00    	je     800ed7 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800a1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a26:	48 89 d6             	mov    %rdx,%rsi
  800a29:	89 df                	mov    %ebx,%edi
  800a2b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a2d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a31:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a35:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a39:	0f b6 00             	movzbl (%rax),%eax
  800a3c:	0f b6 d8             	movzbl %al,%ebx
  800a3f:	83 fb 25             	cmp    $0x25,%ebx
  800a42:	75 d2                	jne    800a16 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a44:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a48:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a4f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a56:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a5d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a64:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a68:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a6c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a70:	0f b6 00             	movzbl (%rax),%eax
  800a73:	0f b6 d8             	movzbl %al,%ebx
  800a76:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a79:	83 f8 55             	cmp    $0x55,%eax
  800a7c:	0f 87 22 04 00 00    	ja     800ea4 <vprintfmt+0x4c9>
  800a82:	89 c0                	mov    %eax,%eax
  800a84:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a8b:	00 
  800a8c:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  800a93:	00 00 00 
  800a96:	48 01 d0             	add    %rdx,%rax
  800a99:	48 8b 00             	mov    (%rax),%rax
  800a9c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a9e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800aa2:	eb c0                	jmp    800a64 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aa4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800aa8:	eb ba                	jmp    800a64 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aaa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ab1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ab4:	89 d0                	mov    %edx,%eax
  800ab6:	c1 e0 02             	shl    $0x2,%eax
  800ab9:	01 d0                	add    %edx,%eax
  800abb:	01 c0                	add    %eax,%eax
  800abd:	01 d8                	add    %ebx,%eax
  800abf:	83 e8 30             	sub    $0x30,%eax
  800ac2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ac5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ac9:	0f b6 00             	movzbl (%rax),%eax
  800acc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800acf:	83 fb 2f             	cmp    $0x2f,%ebx
  800ad2:	7e 60                	jle    800b34 <vprintfmt+0x159>
  800ad4:	83 fb 39             	cmp    $0x39,%ebx
  800ad7:	7f 5b                	jg     800b34 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ad9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ade:	eb d1                	jmp    800ab1 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800ae0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae3:	83 f8 30             	cmp    $0x30,%eax
  800ae6:	73 17                	jae    800aff <vprintfmt+0x124>
  800ae8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800aec:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aef:	89 d2                	mov    %edx,%edx
  800af1:	48 01 d0             	add    %rdx,%rax
  800af4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af7:	83 c2 08             	add    $0x8,%edx
  800afa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800afd:	eb 0c                	jmp    800b0b <vprintfmt+0x130>
  800aff:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b03:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b07:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b0b:	8b 00                	mov    (%rax),%eax
  800b0d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b10:	eb 23                	jmp    800b35 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800b12:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b16:	0f 89 48 ff ff ff    	jns    800a64 <vprintfmt+0x89>
				width = 0;
  800b1c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b23:	e9 3c ff ff ff       	jmpq   800a64 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b28:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b2f:	e9 30 ff ff ff       	jmpq   800a64 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b34:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b35:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b39:	0f 89 25 ff ff ff    	jns    800a64 <vprintfmt+0x89>
				width = precision, precision = -1;
  800b3f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b42:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b45:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b4c:	e9 13 ff ff ff       	jmpq   800a64 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b51:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b55:	e9 0a ff ff ff       	jmpq   800a64 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5d:	83 f8 30             	cmp    $0x30,%eax
  800b60:	73 17                	jae    800b79 <vprintfmt+0x19e>
  800b62:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b66:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b69:	89 d2                	mov    %edx,%edx
  800b6b:	48 01 d0             	add    %rdx,%rax
  800b6e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b71:	83 c2 08             	add    $0x8,%edx
  800b74:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b77:	eb 0c                	jmp    800b85 <vprintfmt+0x1aa>
  800b79:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b7d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b81:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b85:	8b 10                	mov    (%rax),%edx
  800b87:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8f:	48 89 ce             	mov    %rcx,%rsi
  800b92:	89 d7                	mov    %edx,%edi
  800b94:	ff d0                	callq  *%rax
			break;
  800b96:	e9 37 03 00 00       	jmpq   800ed2 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9e:	83 f8 30             	cmp    $0x30,%eax
  800ba1:	73 17                	jae    800bba <vprintfmt+0x1df>
  800ba3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ba7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800baa:	89 d2                	mov    %edx,%edx
  800bac:	48 01 d0             	add    %rdx,%rax
  800baf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bb2:	83 c2 08             	add    $0x8,%edx
  800bb5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bb8:	eb 0c                	jmp    800bc6 <vprintfmt+0x1eb>
  800bba:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800bbe:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800bc2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bc6:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bc8:	85 db                	test   %ebx,%ebx
  800bca:	79 02                	jns    800bce <vprintfmt+0x1f3>
				err = -err;
  800bcc:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bce:	83 fb 15             	cmp    $0x15,%ebx
  800bd1:	7f 16                	jg     800be9 <vprintfmt+0x20e>
  800bd3:	48 b8 a0 1e 80 00 00 	movabs $0x801ea0,%rax
  800bda:	00 00 00 
  800bdd:	48 63 d3             	movslq %ebx,%rdx
  800be0:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800be4:	4d 85 e4             	test   %r12,%r12
  800be7:	75 2e                	jne    800c17 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800be9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf1:	89 d9                	mov    %ebx,%ecx
  800bf3:	48 ba 61 1f 80 00 00 	movabs $0x801f61,%rdx
  800bfa:	00 00 00 
  800bfd:	48 89 c7             	mov    %rax,%rdi
  800c00:	b8 00 00 00 00       	mov    $0x0,%eax
  800c05:	49 b8 e1 0e 80 00 00 	movabs $0x800ee1,%r8
  800c0c:	00 00 00 
  800c0f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c12:	e9 bb 02 00 00       	jmpq   800ed2 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c17:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1f:	4c 89 e1             	mov    %r12,%rcx
  800c22:	48 ba 6a 1f 80 00 00 	movabs $0x801f6a,%rdx
  800c29:	00 00 00 
  800c2c:	48 89 c7             	mov    %rax,%rdi
  800c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c34:	49 b8 e1 0e 80 00 00 	movabs $0x800ee1,%r8
  800c3b:	00 00 00 
  800c3e:	41 ff d0             	callq  *%r8
			break;
  800c41:	e9 8c 02 00 00       	jmpq   800ed2 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c49:	83 f8 30             	cmp    $0x30,%eax
  800c4c:	73 17                	jae    800c65 <vprintfmt+0x28a>
  800c4e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c52:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c55:	89 d2                	mov    %edx,%edx
  800c57:	48 01 d0             	add    %rdx,%rax
  800c5a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c5d:	83 c2 08             	add    $0x8,%edx
  800c60:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c63:	eb 0c                	jmp    800c71 <vprintfmt+0x296>
  800c65:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c69:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c6d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c71:	4c 8b 20             	mov    (%rax),%r12
  800c74:	4d 85 e4             	test   %r12,%r12
  800c77:	75 0a                	jne    800c83 <vprintfmt+0x2a8>
				p = "(null)";
  800c79:	49 bc 6d 1f 80 00 00 	movabs $0x801f6d,%r12
  800c80:	00 00 00 
			if (width > 0 && padc != '-')
  800c83:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c87:	7e 78                	jle    800d01 <vprintfmt+0x326>
  800c89:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c8d:	74 72                	je     800d01 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c8f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c92:	48 98                	cltq   
  800c94:	48 89 c6             	mov    %rax,%rsi
  800c97:	4c 89 e7             	mov    %r12,%rdi
  800c9a:	48 b8 8f 11 80 00 00 	movabs $0x80118f,%rax
  800ca1:	00 00 00 
  800ca4:	ff d0                	callq  *%rax
  800ca6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ca9:	eb 17                	jmp    800cc2 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800cab:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800caf:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cb3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb7:	48 89 ce             	mov    %rcx,%rsi
  800cba:	89 d7                	mov    %edx,%edi
  800cbc:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cbe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cc2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cc6:	7f e3                	jg     800cab <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cc8:	eb 37                	jmp    800d01 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800cca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cce:	74 1e                	je     800cee <vprintfmt+0x313>
  800cd0:	83 fb 1f             	cmp    $0x1f,%ebx
  800cd3:	7e 05                	jle    800cda <vprintfmt+0x2ff>
  800cd5:	83 fb 7e             	cmp    $0x7e,%ebx
  800cd8:	7e 14                	jle    800cee <vprintfmt+0x313>
					putch('?', putdat);
  800cda:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cde:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce2:	48 89 d6             	mov    %rdx,%rsi
  800ce5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800cea:	ff d0                	callq  *%rax
  800cec:	eb 0f                	jmp    800cfd <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800cee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf6:	48 89 d6             	mov    %rdx,%rsi
  800cf9:	89 df                	mov    %ebx,%edi
  800cfb:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cfd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d01:	4c 89 e0             	mov    %r12,%rax
  800d04:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d08:	0f b6 00             	movzbl (%rax),%eax
  800d0b:	0f be d8             	movsbl %al,%ebx
  800d0e:	85 db                	test   %ebx,%ebx
  800d10:	74 28                	je     800d3a <vprintfmt+0x35f>
  800d12:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d16:	78 b2                	js     800cca <vprintfmt+0x2ef>
  800d18:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d1c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d20:	79 a8                	jns    800cca <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d22:	eb 16                	jmp    800d3a <vprintfmt+0x35f>
				putch(' ', putdat);
  800d24:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2c:	48 89 d6             	mov    %rdx,%rsi
  800d2f:	bf 20 00 00 00       	mov    $0x20,%edi
  800d34:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d36:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d3e:	7f e4                	jg     800d24 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800d40:	e9 8d 01 00 00       	jmpq   800ed2 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d45:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d49:	be 03 00 00 00       	mov    $0x3,%esi
  800d4e:	48 89 c7             	mov    %rax,%rdi
  800d51:	48 b8 d4 08 80 00 00 	movabs $0x8008d4,%rax
  800d58:	00 00 00 
  800d5b:	ff d0                	callq  *%rax
  800d5d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d65:	48 85 c0             	test   %rax,%rax
  800d68:	79 1d                	jns    800d87 <vprintfmt+0x3ac>
				putch('-', putdat);
  800d6a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d72:	48 89 d6             	mov    %rdx,%rsi
  800d75:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d7a:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d80:	48 f7 d8             	neg    %rax
  800d83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d87:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d8e:	e9 d2 00 00 00       	jmpq   800e65 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d93:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d97:	be 03 00 00 00       	mov    $0x3,%esi
  800d9c:	48 89 c7             	mov    %rax,%rdi
  800d9f:	48 b8 cd 07 80 00 00 	movabs $0x8007cd,%rax
  800da6:	00 00 00 
  800da9:	ff d0                	callq  *%rax
  800dab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800daf:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800db6:	e9 aa 00 00 00       	jmpq   800e65 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':
			num = getuint(&aq, 3);
  800dbb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dbf:	be 03 00 00 00       	mov    $0x3,%esi
  800dc4:	48 89 c7             	mov    %rax,%rdi
  800dc7:	48 b8 cd 07 80 00 00 	movabs $0x8007cd,%rax
  800dce:	00 00 00 
  800dd1:	ff d0                	callq  *%rax
  800dd3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800dd7:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800dde:	e9 82 00 00 00       	jmpq   800e65 <vprintfmt+0x48a>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  800de3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800deb:	48 89 d6             	mov    %rdx,%rsi
  800dee:	bf 30 00 00 00       	mov    $0x30,%edi
  800df3:	ff d0                	callq  *%rax
			putch('x', putdat);
  800df5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfd:	48 89 d6             	mov    %rdx,%rsi
  800e00:	bf 78 00 00 00       	mov    $0x78,%edi
  800e05:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e07:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e0a:	83 f8 30             	cmp    $0x30,%eax
  800e0d:	73 17                	jae    800e26 <vprintfmt+0x44b>
  800e0f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e13:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e16:	89 d2                	mov    %edx,%edx
  800e18:	48 01 d0             	add    %rdx,%rax
  800e1b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e1e:	83 c2 08             	add    $0x8,%edx
  800e21:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e24:	eb 0c                	jmp    800e32 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800e26:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e2a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e2e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e32:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e35:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e39:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e40:	eb 23                	jmp    800e65 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e42:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e46:	be 03 00 00 00       	mov    $0x3,%esi
  800e4b:	48 89 c7             	mov    %rax,%rdi
  800e4e:	48 b8 cd 07 80 00 00 	movabs $0x8007cd,%rax
  800e55:	00 00 00 
  800e58:	ff d0                	callq  *%rax
  800e5a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e5e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e65:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e6a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e6d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e70:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e74:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e7c:	45 89 c1             	mov    %r8d,%r9d
  800e7f:	41 89 f8             	mov    %edi,%r8d
  800e82:	48 89 c7             	mov    %rax,%rdi
  800e85:	48 b8 15 07 80 00 00 	movabs $0x800715,%rax
  800e8c:	00 00 00 
  800e8f:	ff d0                	callq  *%rax
			break;
  800e91:	eb 3f                	jmp    800ed2 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e93:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e9b:	48 89 d6             	mov    %rdx,%rsi
  800e9e:	89 df                	mov    %ebx,%edi
  800ea0:	ff d0                	callq  *%rax
			break;
  800ea2:	eb 2e                	jmp    800ed2 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ea4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eac:	48 89 d6             	mov    %rdx,%rsi
  800eaf:	bf 25 00 00 00       	mov    $0x25,%edi
  800eb4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eb6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ebb:	eb 05                	jmp    800ec2 <vprintfmt+0x4e7>
  800ebd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ec2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ec6:	48 83 e8 01          	sub    $0x1,%rax
  800eca:	0f b6 00             	movzbl (%rax),%eax
  800ecd:	3c 25                	cmp    $0x25,%al
  800ecf:	75 ec                	jne    800ebd <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800ed1:	90                   	nop
		}
	}
  800ed2:	e9 3d fb ff ff       	jmpq   800a14 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ed7:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ed8:	48 83 c4 60          	add    $0x60,%rsp
  800edc:	5b                   	pop    %rbx
  800edd:	41 5c                	pop    %r12
  800edf:	5d                   	pop    %rbp
  800ee0:	c3                   	retq   

0000000000800ee1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ee1:	55                   	push   %rbp
  800ee2:	48 89 e5             	mov    %rsp,%rbp
  800ee5:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800eec:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ef3:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800efa:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800f01:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f08:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f0f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f16:	84 c0                	test   %al,%al
  800f18:	74 20                	je     800f3a <printfmt+0x59>
  800f1a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f1e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f22:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f26:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f2a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f2e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f32:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f36:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f3a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f41:	00 00 00 
  800f44:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f4b:	00 00 00 
  800f4e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f52:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f59:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f60:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f67:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f6e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f75:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f7c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f83:	48 89 c7             	mov    %rax,%rdi
  800f86:	48 b8 db 09 80 00 00 	movabs $0x8009db,%rax
  800f8d:	00 00 00 
  800f90:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f92:	90                   	nop
  800f93:	c9                   	leaveq 
  800f94:	c3                   	retq   

0000000000800f95 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f95:	55                   	push   %rbp
  800f96:	48 89 e5             	mov    %rsp,%rbp
  800f99:	48 83 ec 10          	sub    $0x10,%rsp
  800f9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fa0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa8:	8b 40 10             	mov    0x10(%rax),%eax
  800fab:	8d 50 01             	lea    0x1(%rax),%edx
  800fae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb9:	48 8b 10             	mov    (%rax),%rdx
  800fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc0:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fc4:	48 39 c2             	cmp    %rax,%rdx
  800fc7:	73 17                	jae    800fe0 <sprintputch+0x4b>
		*b->buf++ = ch;
  800fc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcd:	48 8b 00             	mov    (%rax),%rax
  800fd0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800fd4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fd8:	48 89 0a             	mov    %rcx,(%rdx)
  800fdb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fde:	88 10                	mov    %dl,(%rax)
}
  800fe0:	90                   	nop
  800fe1:	c9                   	leaveq 
  800fe2:	c3                   	retq   

0000000000800fe3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fe3:	55                   	push   %rbp
  800fe4:	48 89 e5             	mov    %rsp,%rbp
  800fe7:	48 83 ec 50          	sub    $0x50,%rsp
  800feb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800fef:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ff2:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ff6:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ffa:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ffe:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801002:	48 8b 0a             	mov    (%rdx),%rcx
  801005:	48 89 08             	mov    %rcx,(%rax)
  801008:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80100c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801010:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801014:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801018:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80101c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801020:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801023:	48 98                	cltq   
  801025:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801029:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80102d:	48 01 d0             	add    %rdx,%rax
  801030:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801034:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80103b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801040:	74 06                	je     801048 <vsnprintf+0x65>
  801042:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801046:	7f 07                	jg     80104f <vsnprintf+0x6c>
		return -E_INVAL;
  801048:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80104d:	eb 2f                	jmp    80107e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80104f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801053:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801057:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80105b:	48 89 c6             	mov    %rax,%rsi
  80105e:	48 bf 95 0f 80 00 00 	movabs $0x800f95,%rdi
  801065:	00 00 00 
  801068:	48 b8 db 09 80 00 00 	movabs $0x8009db,%rax
  80106f:	00 00 00 
  801072:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801074:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801078:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80107b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80107e:	c9                   	leaveq 
  80107f:	c3                   	retq   

0000000000801080 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801080:	55                   	push   %rbp
  801081:	48 89 e5             	mov    %rsp,%rbp
  801084:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80108b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801092:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801098:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  80109f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010a6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010ad:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010b4:	84 c0                	test   %al,%al
  8010b6:	74 20                	je     8010d8 <snprintf+0x58>
  8010b8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010bc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010c0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010c4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010c8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010cc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010d0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010d4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010d8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010df:	00 00 00 
  8010e2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010e9:	00 00 00 
  8010ec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010f0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010f7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010fe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801105:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80110c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801113:	48 8b 0a             	mov    (%rdx),%rcx
  801116:	48 89 08             	mov    %rcx,(%rax)
  801119:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80111d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801121:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801125:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801129:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801130:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801137:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80113d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801144:	48 89 c7             	mov    %rax,%rdi
  801147:	48 b8 e3 0f 80 00 00 	movabs $0x800fe3,%rax
  80114e:	00 00 00 
  801151:	ff d0                	callq  *%rax
  801153:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801159:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80115f:	c9                   	leaveq 
  801160:	c3                   	retq   

0000000000801161 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801161:	55                   	push   %rbp
  801162:	48 89 e5             	mov    %rsp,%rbp
  801165:	48 83 ec 18          	sub    $0x18,%rsp
  801169:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801174:	eb 09                	jmp    80117f <strlen+0x1e>
		n++;
  801176:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80117a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80117f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801183:	0f b6 00             	movzbl (%rax),%eax
  801186:	84 c0                	test   %al,%al
  801188:	75 ec                	jne    801176 <strlen+0x15>
		n++;
	return n;
  80118a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80118d:	c9                   	leaveq 
  80118e:	c3                   	retq   

000000000080118f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80118f:	55                   	push   %rbp
  801190:	48 89 e5             	mov    %rsp,%rbp
  801193:	48 83 ec 20          	sub    $0x20,%rsp
  801197:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80119b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80119f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011a6:	eb 0e                	jmp    8011b6 <strnlen+0x27>
		n++;
  8011a8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ac:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011b1:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011b6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011bb:	74 0b                	je     8011c8 <strnlen+0x39>
  8011bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c1:	0f b6 00             	movzbl (%rax),%eax
  8011c4:	84 c0                	test   %al,%al
  8011c6:	75 e0                	jne    8011a8 <strnlen+0x19>
		n++;
	return n;
  8011c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011cb:	c9                   	leaveq 
  8011cc:	c3                   	retq   

00000000008011cd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011cd:	55                   	push   %rbp
  8011ce:	48 89 e5             	mov    %rsp,%rbp
  8011d1:	48 83 ec 20          	sub    $0x20,%rsp
  8011d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011e5:	90                   	nop
  8011e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011f6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011fa:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011fe:	0f b6 12             	movzbl (%rdx),%edx
  801201:	88 10                	mov    %dl,(%rax)
  801203:	0f b6 00             	movzbl (%rax),%eax
  801206:	84 c0                	test   %al,%al
  801208:	75 dc                	jne    8011e6 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80120a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80120e:	c9                   	leaveq 
  80120f:	c3                   	retq   

0000000000801210 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801210:	55                   	push   %rbp
  801211:	48 89 e5             	mov    %rsp,%rbp
  801214:	48 83 ec 20          	sub    $0x20,%rsp
  801218:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801220:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801224:	48 89 c7             	mov    %rax,%rdi
  801227:	48 b8 61 11 80 00 00 	movabs $0x801161,%rax
  80122e:	00 00 00 
  801231:	ff d0                	callq  *%rax
  801233:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801236:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801239:	48 63 d0             	movslq %eax,%rdx
  80123c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801240:	48 01 c2             	add    %rax,%rdx
  801243:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801247:	48 89 c6             	mov    %rax,%rsi
  80124a:	48 89 d7             	mov    %rdx,%rdi
  80124d:	48 b8 cd 11 80 00 00 	movabs $0x8011cd,%rax
  801254:	00 00 00 
  801257:	ff d0                	callq  *%rax
	return dst;
  801259:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80125d:	c9                   	leaveq 
  80125e:	c3                   	retq   

000000000080125f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80125f:	55                   	push   %rbp
  801260:	48 89 e5             	mov    %rsp,%rbp
  801263:	48 83 ec 28          	sub    $0x28,%rsp
  801267:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80126b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80126f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801273:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801277:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80127b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801282:	00 
  801283:	eb 2a                	jmp    8012af <strncpy+0x50>
		*dst++ = *src;
  801285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801289:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80128d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801291:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801295:	0f b6 12             	movzbl (%rdx),%edx
  801298:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80129a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80129e:	0f b6 00             	movzbl (%rax),%eax
  8012a1:	84 c0                	test   %al,%al
  8012a3:	74 05                	je     8012aa <strncpy+0x4b>
			src++;
  8012a5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012b7:	72 cc                	jb     801285 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012bd:	c9                   	leaveq 
  8012be:	c3                   	retq   

00000000008012bf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012bf:	55                   	push   %rbp
  8012c0:	48 89 e5             	mov    %rsp,%rbp
  8012c3:	48 83 ec 28          	sub    $0x28,%rsp
  8012c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012db:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012e0:	74 3d                	je     80131f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012e2:	eb 1d                	jmp    801301 <strlcpy+0x42>
			*dst++ = *src++;
  8012e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012ec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012f0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012f4:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012f8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012fc:	0f b6 12             	movzbl (%rdx),%edx
  8012ff:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801301:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801306:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80130b:	74 0b                	je     801318 <strlcpy+0x59>
  80130d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801311:	0f b6 00             	movzbl (%rax),%eax
  801314:	84 c0                	test   %al,%al
  801316:	75 cc                	jne    8012e4 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801318:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80131f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801327:	48 29 c2             	sub    %rax,%rdx
  80132a:	48 89 d0             	mov    %rdx,%rax
}
  80132d:	c9                   	leaveq 
  80132e:	c3                   	retq   

000000000080132f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80132f:	55                   	push   %rbp
  801330:	48 89 e5             	mov    %rsp,%rbp
  801333:	48 83 ec 10          	sub    $0x10,%rsp
  801337:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80133b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80133f:	eb 0a                	jmp    80134b <strcmp+0x1c>
		p++, q++;
  801341:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801346:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80134b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134f:	0f b6 00             	movzbl (%rax),%eax
  801352:	84 c0                	test   %al,%al
  801354:	74 12                	je     801368 <strcmp+0x39>
  801356:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135a:	0f b6 10             	movzbl (%rax),%edx
  80135d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801361:	0f b6 00             	movzbl (%rax),%eax
  801364:	38 c2                	cmp    %al,%dl
  801366:	74 d9                	je     801341 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801368:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136c:	0f b6 00             	movzbl (%rax),%eax
  80136f:	0f b6 d0             	movzbl %al,%edx
  801372:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801376:	0f b6 00             	movzbl (%rax),%eax
  801379:	0f b6 c0             	movzbl %al,%eax
  80137c:	29 c2                	sub    %eax,%edx
  80137e:	89 d0                	mov    %edx,%eax
}
  801380:	c9                   	leaveq 
  801381:	c3                   	retq   

0000000000801382 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801382:	55                   	push   %rbp
  801383:	48 89 e5             	mov    %rsp,%rbp
  801386:	48 83 ec 18          	sub    $0x18,%rsp
  80138a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80138e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801392:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801396:	eb 0f                	jmp    8013a7 <strncmp+0x25>
		n--, p++, q++;
  801398:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80139d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013a2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013a7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ac:	74 1d                	je     8013cb <strncmp+0x49>
  8013ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b2:	0f b6 00             	movzbl (%rax),%eax
  8013b5:	84 c0                	test   %al,%al
  8013b7:	74 12                	je     8013cb <strncmp+0x49>
  8013b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bd:	0f b6 10             	movzbl (%rax),%edx
  8013c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c4:	0f b6 00             	movzbl (%rax),%eax
  8013c7:	38 c2                	cmp    %al,%dl
  8013c9:	74 cd                	je     801398 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013cb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013d0:	75 07                	jne    8013d9 <strncmp+0x57>
		return 0;
  8013d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d7:	eb 18                	jmp    8013f1 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013dd:	0f b6 00             	movzbl (%rax),%eax
  8013e0:	0f b6 d0             	movzbl %al,%edx
  8013e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e7:	0f b6 00             	movzbl (%rax),%eax
  8013ea:	0f b6 c0             	movzbl %al,%eax
  8013ed:	29 c2                	sub    %eax,%edx
  8013ef:	89 d0                	mov    %edx,%eax
}
  8013f1:	c9                   	leaveq 
  8013f2:	c3                   	retq   

00000000008013f3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013f3:	55                   	push   %rbp
  8013f4:	48 89 e5             	mov    %rsp,%rbp
  8013f7:	48 83 ec 10          	sub    $0x10,%rsp
  8013fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ff:	89 f0                	mov    %esi,%eax
  801401:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801404:	eb 17                	jmp    80141d <strchr+0x2a>
		if (*s == c)
  801406:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140a:	0f b6 00             	movzbl (%rax),%eax
  80140d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801410:	75 06                	jne    801418 <strchr+0x25>
			return (char *) s;
  801412:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801416:	eb 15                	jmp    80142d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801418:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80141d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801421:	0f b6 00             	movzbl (%rax),%eax
  801424:	84 c0                	test   %al,%al
  801426:	75 de                	jne    801406 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801428:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80142d:	c9                   	leaveq 
  80142e:	c3                   	retq   

000000000080142f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80142f:	55                   	push   %rbp
  801430:	48 89 e5             	mov    %rsp,%rbp
  801433:	48 83 ec 10          	sub    $0x10,%rsp
  801437:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80143b:	89 f0                	mov    %esi,%eax
  80143d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801440:	eb 11                	jmp    801453 <strfind+0x24>
		if (*s == c)
  801442:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801446:	0f b6 00             	movzbl (%rax),%eax
  801449:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80144c:	74 12                	je     801460 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80144e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801453:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801457:	0f b6 00             	movzbl (%rax),%eax
  80145a:	84 c0                	test   %al,%al
  80145c:	75 e4                	jne    801442 <strfind+0x13>
  80145e:	eb 01                	jmp    801461 <strfind+0x32>
		if (*s == c)
			break;
  801460:	90                   	nop
	return (char *) s;
  801461:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801465:	c9                   	leaveq 
  801466:	c3                   	retq   

0000000000801467 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801467:	55                   	push   %rbp
  801468:	48 89 e5             	mov    %rsp,%rbp
  80146b:	48 83 ec 18          	sub    $0x18,%rsp
  80146f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801473:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801476:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80147a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80147f:	75 06                	jne    801487 <memset+0x20>
		return v;
  801481:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801485:	eb 69                	jmp    8014f0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801487:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148b:	83 e0 03             	and    $0x3,%eax
  80148e:	48 85 c0             	test   %rax,%rax
  801491:	75 48                	jne    8014db <memset+0x74>
  801493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801497:	83 e0 03             	and    $0x3,%eax
  80149a:	48 85 c0             	test   %rax,%rax
  80149d:	75 3c                	jne    8014db <memset+0x74>
		c &= 0xFF;
  80149f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014a9:	c1 e0 18             	shl    $0x18,%eax
  8014ac:	89 c2                	mov    %eax,%edx
  8014ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014b1:	c1 e0 10             	shl    $0x10,%eax
  8014b4:	09 c2                	or     %eax,%edx
  8014b6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014b9:	c1 e0 08             	shl    $0x8,%eax
  8014bc:	09 d0                	or     %edx,%eax
  8014be:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c5:	48 c1 e8 02          	shr    $0x2,%rax
  8014c9:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014d3:	48 89 d7             	mov    %rdx,%rdi
  8014d6:	fc                   	cld    
  8014d7:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014d9:	eb 11                	jmp    8014ec <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014e6:	48 89 d7             	mov    %rdx,%rdi
  8014e9:	fc                   	cld    
  8014ea:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014f0:	c9                   	leaveq 
  8014f1:	c3                   	retq   

00000000008014f2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014f2:	55                   	push   %rbp
  8014f3:	48 89 e5             	mov    %rsp,%rbp
  8014f6:	48 83 ec 28          	sub    $0x28,%rsp
  8014fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801502:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801506:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80150a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80150e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801512:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801516:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80151e:	0f 83 88 00 00 00    	jae    8015ac <memmove+0xba>
  801524:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801528:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152c:	48 01 d0             	add    %rdx,%rax
  80152f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801533:	76 77                	jbe    8015ac <memmove+0xba>
		s += n;
  801535:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801539:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80153d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801541:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801545:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801549:	83 e0 03             	and    $0x3,%eax
  80154c:	48 85 c0             	test   %rax,%rax
  80154f:	75 3b                	jne    80158c <memmove+0x9a>
  801551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801555:	83 e0 03             	and    $0x3,%eax
  801558:	48 85 c0             	test   %rax,%rax
  80155b:	75 2f                	jne    80158c <memmove+0x9a>
  80155d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801561:	83 e0 03             	and    $0x3,%eax
  801564:	48 85 c0             	test   %rax,%rax
  801567:	75 23                	jne    80158c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801569:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156d:	48 83 e8 04          	sub    $0x4,%rax
  801571:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801575:	48 83 ea 04          	sub    $0x4,%rdx
  801579:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80157d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801581:	48 89 c7             	mov    %rax,%rdi
  801584:	48 89 d6             	mov    %rdx,%rsi
  801587:	fd                   	std    
  801588:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80158a:	eb 1d                	jmp    8015a9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80158c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801590:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801598:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80159c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a0:	48 89 d7             	mov    %rdx,%rdi
  8015a3:	48 89 c1             	mov    %rax,%rcx
  8015a6:	fd                   	std    
  8015a7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015a9:	fc                   	cld    
  8015aa:	eb 57                	jmp    801603 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b0:	83 e0 03             	and    $0x3,%eax
  8015b3:	48 85 c0             	test   %rax,%rax
  8015b6:	75 36                	jne    8015ee <memmove+0xfc>
  8015b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015bc:	83 e0 03             	and    $0x3,%eax
  8015bf:	48 85 c0             	test   %rax,%rax
  8015c2:	75 2a                	jne    8015ee <memmove+0xfc>
  8015c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c8:	83 e0 03             	and    $0x3,%eax
  8015cb:	48 85 c0             	test   %rax,%rax
  8015ce:	75 1e                	jne    8015ee <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d4:	48 c1 e8 02          	shr    $0x2,%rax
  8015d8:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015e3:	48 89 c7             	mov    %rax,%rdi
  8015e6:	48 89 d6             	mov    %rdx,%rsi
  8015e9:	fc                   	cld    
  8015ea:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015ec:	eb 15                	jmp    801603 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015f6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015fa:	48 89 c7             	mov    %rax,%rdi
  8015fd:	48 89 d6             	mov    %rdx,%rsi
  801600:	fc                   	cld    
  801601:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801607:	c9                   	leaveq 
  801608:	c3                   	retq   

0000000000801609 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801609:	55                   	push   %rbp
  80160a:	48 89 e5             	mov    %rsp,%rbp
  80160d:	48 83 ec 18          	sub    $0x18,%rsp
  801611:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801615:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801619:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80161d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801621:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801625:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801629:	48 89 ce             	mov    %rcx,%rsi
  80162c:	48 89 c7             	mov    %rax,%rdi
  80162f:	48 b8 f2 14 80 00 00 	movabs $0x8014f2,%rax
  801636:	00 00 00 
  801639:	ff d0                	callq  *%rax
}
  80163b:	c9                   	leaveq 
  80163c:	c3                   	retq   

000000000080163d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80163d:	55                   	push   %rbp
  80163e:	48 89 e5             	mov    %rsp,%rbp
  801641:	48 83 ec 28          	sub    $0x28,%rsp
  801645:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801649:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80164d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801655:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801659:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80165d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801661:	eb 36                	jmp    801699 <memcmp+0x5c>
		if (*s1 != *s2)
  801663:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801667:	0f b6 10             	movzbl (%rax),%edx
  80166a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166e:	0f b6 00             	movzbl (%rax),%eax
  801671:	38 c2                	cmp    %al,%dl
  801673:	74 1a                	je     80168f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801675:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801679:	0f b6 00             	movzbl (%rax),%eax
  80167c:	0f b6 d0             	movzbl %al,%edx
  80167f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801683:	0f b6 00             	movzbl (%rax),%eax
  801686:	0f b6 c0             	movzbl %al,%eax
  801689:	29 c2                	sub    %eax,%edx
  80168b:	89 d0                	mov    %edx,%eax
  80168d:	eb 20                	jmp    8016af <memcmp+0x72>
		s1++, s2++;
  80168f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801694:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801699:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016a5:	48 85 c0             	test   %rax,%rax
  8016a8:	75 b9                	jne    801663 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016af:	c9                   	leaveq 
  8016b0:	c3                   	retq   

00000000008016b1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016b1:	55                   	push   %rbp
  8016b2:	48 89 e5             	mov    %rsp,%rbp
  8016b5:	48 83 ec 28          	sub    $0x28,%rsp
  8016b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016bd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cc:	48 01 d0             	add    %rdx,%rax
  8016cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016d3:	eb 19                	jmp    8016ee <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d9:	0f b6 00             	movzbl (%rax),%eax
  8016dc:	0f b6 d0             	movzbl %al,%edx
  8016df:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016e2:	0f b6 c0             	movzbl %al,%eax
  8016e5:	39 c2                	cmp    %eax,%edx
  8016e7:	74 11                	je     8016fa <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016e9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016f6:	72 dd                	jb     8016d5 <memfind+0x24>
  8016f8:	eb 01                	jmp    8016fb <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016fa:	90                   	nop
	return (void *) s;
  8016fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016ff:	c9                   	leaveq 
  801700:	c3                   	retq   

0000000000801701 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801701:	55                   	push   %rbp
  801702:	48 89 e5             	mov    %rsp,%rbp
  801705:	48 83 ec 38          	sub    $0x38,%rsp
  801709:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80170d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801711:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801714:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80171b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801722:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801723:	eb 05                	jmp    80172a <strtol+0x29>
		s++;
  801725:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80172a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172e:	0f b6 00             	movzbl (%rax),%eax
  801731:	3c 20                	cmp    $0x20,%al
  801733:	74 f0                	je     801725 <strtol+0x24>
  801735:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801739:	0f b6 00             	movzbl (%rax),%eax
  80173c:	3c 09                	cmp    $0x9,%al
  80173e:	74 e5                	je     801725 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801740:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801744:	0f b6 00             	movzbl (%rax),%eax
  801747:	3c 2b                	cmp    $0x2b,%al
  801749:	75 07                	jne    801752 <strtol+0x51>
		s++;
  80174b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801750:	eb 17                	jmp    801769 <strtol+0x68>
	else if (*s == '-')
  801752:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801756:	0f b6 00             	movzbl (%rax),%eax
  801759:	3c 2d                	cmp    $0x2d,%al
  80175b:	75 0c                	jne    801769 <strtol+0x68>
		s++, neg = 1;
  80175d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801762:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801769:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80176d:	74 06                	je     801775 <strtol+0x74>
  80176f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801773:	75 28                	jne    80179d <strtol+0x9c>
  801775:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801779:	0f b6 00             	movzbl (%rax),%eax
  80177c:	3c 30                	cmp    $0x30,%al
  80177e:	75 1d                	jne    80179d <strtol+0x9c>
  801780:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801784:	48 83 c0 01          	add    $0x1,%rax
  801788:	0f b6 00             	movzbl (%rax),%eax
  80178b:	3c 78                	cmp    $0x78,%al
  80178d:	75 0e                	jne    80179d <strtol+0x9c>
		s += 2, base = 16;
  80178f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801794:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80179b:	eb 2c                	jmp    8017c9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80179d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017a1:	75 19                	jne    8017bc <strtol+0xbb>
  8017a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a7:	0f b6 00             	movzbl (%rax),%eax
  8017aa:	3c 30                	cmp    $0x30,%al
  8017ac:	75 0e                	jne    8017bc <strtol+0xbb>
		s++, base = 8;
  8017ae:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017b3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017ba:	eb 0d                	jmp    8017c9 <strtol+0xc8>
	else if (base == 0)
  8017bc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017c0:	75 07                	jne    8017c9 <strtol+0xc8>
		base = 10;
  8017c2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cd:	0f b6 00             	movzbl (%rax),%eax
  8017d0:	3c 2f                	cmp    $0x2f,%al
  8017d2:	7e 1d                	jle    8017f1 <strtol+0xf0>
  8017d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d8:	0f b6 00             	movzbl (%rax),%eax
  8017db:	3c 39                	cmp    $0x39,%al
  8017dd:	7f 12                	jg     8017f1 <strtol+0xf0>
			dig = *s - '0';
  8017df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e3:	0f b6 00             	movzbl (%rax),%eax
  8017e6:	0f be c0             	movsbl %al,%eax
  8017e9:	83 e8 30             	sub    $0x30,%eax
  8017ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017ef:	eb 4e                	jmp    80183f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f5:	0f b6 00             	movzbl (%rax),%eax
  8017f8:	3c 60                	cmp    $0x60,%al
  8017fa:	7e 1d                	jle    801819 <strtol+0x118>
  8017fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801800:	0f b6 00             	movzbl (%rax),%eax
  801803:	3c 7a                	cmp    $0x7a,%al
  801805:	7f 12                	jg     801819 <strtol+0x118>
			dig = *s - 'a' + 10;
  801807:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180b:	0f b6 00             	movzbl (%rax),%eax
  80180e:	0f be c0             	movsbl %al,%eax
  801811:	83 e8 57             	sub    $0x57,%eax
  801814:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801817:	eb 26                	jmp    80183f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801819:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181d:	0f b6 00             	movzbl (%rax),%eax
  801820:	3c 40                	cmp    $0x40,%al
  801822:	7e 47                	jle    80186b <strtol+0x16a>
  801824:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801828:	0f b6 00             	movzbl (%rax),%eax
  80182b:	3c 5a                	cmp    $0x5a,%al
  80182d:	7f 3c                	jg     80186b <strtol+0x16a>
			dig = *s - 'A' + 10;
  80182f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801833:	0f b6 00             	movzbl (%rax),%eax
  801836:	0f be c0             	movsbl %al,%eax
  801839:	83 e8 37             	sub    $0x37,%eax
  80183c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80183f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801842:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801845:	7d 23                	jge    80186a <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801847:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80184c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80184f:	48 98                	cltq   
  801851:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801856:	48 89 c2             	mov    %rax,%rdx
  801859:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80185c:	48 98                	cltq   
  80185e:	48 01 d0             	add    %rdx,%rax
  801861:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801865:	e9 5f ff ff ff       	jmpq   8017c9 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80186a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80186b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801870:	74 0b                	je     80187d <strtol+0x17c>
		*endptr = (char *) s;
  801872:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801876:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80187a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80187d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801881:	74 09                	je     80188c <strtol+0x18b>
  801883:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801887:	48 f7 d8             	neg    %rax
  80188a:	eb 04                	jmp    801890 <strtol+0x18f>
  80188c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801890:	c9                   	leaveq 
  801891:	c3                   	retq   

0000000000801892 <strstr>:

char * strstr(const char *in, const char *str)
{
  801892:	55                   	push   %rbp
  801893:	48 89 e5             	mov    %rsp,%rbp
  801896:	48 83 ec 30          	sub    $0x30,%rsp
  80189a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80189e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018a6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018aa:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018ae:	0f b6 00             	movzbl (%rax),%eax
  8018b1:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018b4:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018b8:	75 06                	jne    8018c0 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018be:	eb 6b                	jmp    80192b <strstr+0x99>

	len = strlen(str);
  8018c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018c4:	48 89 c7             	mov    %rax,%rdi
  8018c7:	48 b8 61 11 80 00 00 	movabs $0x801161,%rax
  8018ce:	00 00 00 
  8018d1:	ff d0                	callq  *%rax
  8018d3:	48 98                	cltq   
  8018d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018e5:	0f b6 00             	movzbl (%rax),%eax
  8018e8:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8018eb:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018ef:	75 07                	jne    8018f8 <strstr+0x66>
				return (char *) 0;
  8018f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f6:	eb 33                	jmp    80192b <strstr+0x99>
		} while (sc != c);
  8018f8:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018fc:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018ff:	75 d8                	jne    8018d9 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801901:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801905:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801909:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190d:	48 89 ce             	mov    %rcx,%rsi
  801910:	48 89 c7             	mov    %rax,%rdi
  801913:	48 b8 82 13 80 00 00 	movabs $0x801382,%rax
  80191a:	00 00 00 
  80191d:	ff d0                	callq  *%rax
  80191f:	85 c0                	test   %eax,%eax
  801921:	75 b6                	jne    8018d9 <strstr+0x47>

	return (char *) (in - 1);
  801923:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801927:	48 83 e8 01          	sub    $0x1,%rax
}
  80192b:	c9                   	leaveq 
  80192c:	c3                   	retq   

000000000080192d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80192d:	55                   	push   %rbp
  80192e:	48 89 e5             	mov    %rsp,%rbp
  801931:	53                   	push   %rbx
  801932:	48 83 ec 48          	sub    $0x48,%rsp
  801936:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801939:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80193c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801940:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801944:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801948:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80194c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80194f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801953:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801957:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80195b:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80195f:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801963:	4c 89 c3             	mov    %r8,%rbx
  801966:	cd 30                	int    $0x30
  801968:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80196c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801970:	74 3e                	je     8019b0 <syscall+0x83>
  801972:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801977:	7e 37                	jle    8019b0 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801979:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80197d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801980:	49 89 d0             	mov    %rdx,%r8
  801983:	89 c1                	mov    %eax,%ecx
  801985:	48 ba 28 22 80 00 00 	movabs $0x802228,%rdx
  80198c:	00 00 00 
  80198f:	be 23 00 00 00       	mov    $0x23,%esi
  801994:	48 bf 45 22 80 00 00 	movabs $0x802245,%rdi
  80199b:	00 00 00 
  80199e:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a3:	49 b9 03 04 80 00 00 	movabs $0x800403,%r9
  8019aa:	00 00 00 
  8019ad:	41 ff d1             	callq  *%r9

	return ret;
  8019b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019b4:	48 83 c4 48          	add    $0x48,%rsp
  8019b8:	5b                   	pop    %rbx
  8019b9:	5d                   	pop    %rbp
  8019ba:	c3                   	retq   

00000000008019bb <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019bb:	55                   	push   %rbp
  8019bc:	48 89 e5             	mov    %rsp,%rbp
  8019bf:	48 83 ec 10          	sub    $0x10,%rsp
  8019c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d3:	48 83 ec 08          	sub    $0x8,%rsp
  8019d7:	6a 00                	pushq  $0x0
  8019d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e5:	48 89 d1             	mov    %rdx,%rcx
  8019e8:	48 89 c2             	mov    %rax,%rdx
  8019eb:	be 00 00 00 00       	mov    $0x0,%esi
  8019f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8019f5:	48 b8 2d 19 80 00 00 	movabs $0x80192d,%rax
  8019fc:	00 00 00 
  8019ff:	ff d0                	callq  *%rax
  801a01:	48 83 c4 10          	add    $0x10,%rsp
}
  801a05:	90                   	nop
  801a06:	c9                   	leaveq 
  801a07:	c3                   	retq   

0000000000801a08 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a08:	55                   	push   %rbp
  801a09:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a0c:	48 83 ec 08          	sub    $0x8,%rsp
  801a10:	6a 00                	pushq  $0x0
  801a12:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a23:	ba 00 00 00 00       	mov    $0x0,%edx
  801a28:	be 00 00 00 00       	mov    $0x0,%esi
  801a2d:	bf 01 00 00 00       	mov    $0x1,%edi
  801a32:	48 b8 2d 19 80 00 00 	movabs $0x80192d,%rax
  801a39:	00 00 00 
  801a3c:	ff d0                	callq  *%rax
  801a3e:	48 83 c4 10          	add    $0x10,%rsp
}
  801a42:	c9                   	leaveq 
  801a43:	c3                   	retq   

0000000000801a44 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a44:	55                   	push   %rbp
  801a45:	48 89 e5             	mov    %rsp,%rbp
  801a48:	48 83 ec 10          	sub    $0x10,%rsp
  801a4c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a52:	48 98                	cltq   
  801a54:	48 83 ec 08          	sub    $0x8,%rsp
  801a58:	6a 00                	pushq  $0x0
  801a5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6b:	48 89 c2             	mov    %rax,%rdx
  801a6e:	be 01 00 00 00       	mov    $0x1,%esi
  801a73:	bf 03 00 00 00       	mov    $0x3,%edi
  801a78:	48 b8 2d 19 80 00 00 	movabs $0x80192d,%rax
  801a7f:	00 00 00 
  801a82:	ff d0                	callq  *%rax
  801a84:	48 83 c4 10          	add    $0x10,%rsp
}
  801a88:	c9                   	leaveq 
  801a89:	c3                   	retq   

0000000000801a8a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a8a:	55                   	push   %rbp
  801a8b:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a8e:	48 83 ec 08          	sub    $0x8,%rsp
  801a92:	6a 00                	pushq  $0x0
  801a94:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aaa:	be 00 00 00 00       	mov    $0x0,%esi
  801aaf:	bf 02 00 00 00       	mov    $0x2,%edi
  801ab4:	48 b8 2d 19 80 00 00 	movabs $0x80192d,%rax
  801abb:	00 00 00 
  801abe:	ff d0                	callq  *%rax
  801ac0:	48 83 c4 10          	add    $0x10,%rsp
}
  801ac4:	c9                   	leaveq 
  801ac5:	c3                   	retq   

0000000000801ac6 <sys_yield>:

void
sys_yield(void)
{
  801ac6:	55                   	push   %rbp
  801ac7:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801aca:	48 83 ec 08          	sub    $0x8,%rsp
  801ace:	6a 00                	pushq  $0x0
  801ad0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801adc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae6:	be 00 00 00 00       	mov    $0x0,%esi
  801aeb:	bf 0a 00 00 00       	mov    $0xa,%edi
  801af0:	48 b8 2d 19 80 00 00 	movabs $0x80192d,%rax
  801af7:	00 00 00 
  801afa:	ff d0                	callq  *%rax
  801afc:	48 83 c4 10          	add    $0x10,%rsp
}
  801b00:	90                   	nop
  801b01:	c9                   	leaveq 
  801b02:	c3                   	retq   

0000000000801b03 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b03:	55                   	push   %rbp
  801b04:	48 89 e5             	mov    %rsp,%rbp
  801b07:	48 83 ec 10          	sub    $0x10,%rsp
  801b0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b12:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b15:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b18:	48 63 c8             	movslq %eax,%rcx
  801b1b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b22:	48 98                	cltq   
  801b24:	48 83 ec 08          	sub    $0x8,%rsp
  801b28:	6a 00                	pushq  $0x0
  801b2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b30:	49 89 c8             	mov    %rcx,%r8
  801b33:	48 89 d1             	mov    %rdx,%rcx
  801b36:	48 89 c2             	mov    %rax,%rdx
  801b39:	be 01 00 00 00       	mov    $0x1,%esi
  801b3e:	bf 04 00 00 00       	mov    $0x4,%edi
  801b43:	48 b8 2d 19 80 00 00 	movabs $0x80192d,%rax
  801b4a:	00 00 00 
  801b4d:	ff d0                	callq  *%rax
  801b4f:	48 83 c4 10          	add    $0x10,%rsp
}
  801b53:	c9                   	leaveq 
  801b54:	c3                   	retq   

0000000000801b55 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b55:	55                   	push   %rbp
  801b56:	48 89 e5             	mov    %rsp,%rbp
  801b59:	48 83 ec 20          	sub    $0x20,%rsp
  801b5d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b60:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b64:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b67:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b6b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b6f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b72:	48 63 c8             	movslq %eax,%rcx
  801b75:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b79:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b7c:	48 63 f0             	movslq %eax,%rsi
  801b7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b86:	48 98                	cltq   
  801b88:	48 83 ec 08          	sub    $0x8,%rsp
  801b8c:	51                   	push   %rcx
  801b8d:	49 89 f9             	mov    %rdi,%r9
  801b90:	49 89 f0             	mov    %rsi,%r8
  801b93:	48 89 d1             	mov    %rdx,%rcx
  801b96:	48 89 c2             	mov    %rax,%rdx
  801b99:	be 01 00 00 00       	mov    $0x1,%esi
  801b9e:	bf 05 00 00 00       	mov    $0x5,%edi
  801ba3:	48 b8 2d 19 80 00 00 	movabs $0x80192d,%rax
  801baa:	00 00 00 
  801bad:	ff d0                	callq  *%rax
  801baf:	48 83 c4 10          	add    $0x10,%rsp
}
  801bb3:	c9                   	leaveq 
  801bb4:	c3                   	retq   

0000000000801bb5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bb5:	55                   	push   %rbp
  801bb6:	48 89 e5             	mov    %rsp,%rbp
  801bb9:	48 83 ec 10          	sub    $0x10,%rsp
  801bbd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bc0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bc4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bcb:	48 98                	cltq   
  801bcd:	48 83 ec 08          	sub    $0x8,%rsp
  801bd1:	6a 00                	pushq  $0x0
  801bd3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bdf:	48 89 d1             	mov    %rdx,%rcx
  801be2:	48 89 c2             	mov    %rax,%rdx
  801be5:	be 01 00 00 00       	mov    $0x1,%esi
  801bea:	bf 06 00 00 00       	mov    $0x6,%edi
  801bef:	48 b8 2d 19 80 00 00 	movabs $0x80192d,%rax
  801bf6:	00 00 00 
  801bf9:	ff d0                	callq  *%rax
  801bfb:	48 83 c4 10          	add    $0x10,%rsp
}
  801bff:	c9                   	leaveq 
  801c00:	c3                   	retq   

0000000000801c01 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c01:	55                   	push   %rbp
  801c02:	48 89 e5             	mov    %rsp,%rbp
  801c05:	48 83 ec 10          	sub    $0x10,%rsp
  801c09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c0c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c12:	48 63 d0             	movslq %eax,%rdx
  801c15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c18:	48 98                	cltq   
  801c1a:	48 83 ec 08          	sub    $0x8,%rsp
  801c1e:	6a 00                	pushq  $0x0
  801c20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2c:	48 89 d1             	mov    %rdx,%rcx
  801c2f:	48 89 c2             	mov    %rax,%rdx
  801c32:	be 01 00 00 00       	mov    $0x1,%esi
  801c37:	bf 08 00 00 00       	mov    $0x8,%edi
  801c3c:	48 b8 2d 19 80 00 00 	movabs $0x80192d,%rax
  801c43:	00 00 00 
  801c46:	ff d0                	callq  *%rax
  801c48:	48 83 c4 10          	add    $0x10,%rsp
}
  801c4c:	c9                   	leaveq 
  801c4d:	c3                   	retq   

0000000000801c4e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c4e:	55                   	push   %rbp
  801c4f:	48 89 e5             	mov    %rsp,%rbp
  801c52:	48 83 ec 10          	sub    $0x10,%rsp
  801c56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c64:	48 98                	cltq   
  801c66:	48 83 ec 08          	sub    $0x8,%rsp
  801c6a:	6a 00                	pushq  $0x0
  801c6c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c72:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c78:	48 89 d1             	mov    %rdx,%rcx
  801c7b:	48 89 c2             	mov    %rax,%rdx
  801c7e:	be 01 00 00 00       	mov    $0x1,%esi
  801c83:	bf 09 00 00 00       	mov    $0x9,%edi
  801c88:	48 b8 2d 19 80 00 00 	movabs $0x80192d,%rax
  801c8f:	00 00 00 
  801c92:	ff d0                	callq  *%rax
  801c94:	48 83 c4 10          	add    $0x10,%rsp
}
  801c98:	c9                   	leaveq 
  801c99:	c3                   	retq   

0000000000801c9a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c9a:	55                   	push   %rbp
  801c9b:	48 89 e5             	mov    %rsp,%rbp
  801c9e:	48 83 ec 20          	sub    $0x20,%rsp
  801ca2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ca5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ca9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801cad:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801cb0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cb3:	48 63 f0             	movslq %eax,%rsi
  801cb6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cbd:	48 98                	cltq   
  801cbf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cc3:	48 83 ec 08          	sub    $0x8,%rsp
  801cc7:	6a 00                	pushq  $0x0
  801cc9:	49 89 f1             	mov    %rsi,%r9
  801ccc:	49 89 c8             	mov    %rcx,%r8
  801ccf:	48 89 d1             	mov    %rdx,%rcx
  801cd2:	48 89 c2             	mov    %rax,%rdx
  801cd5:	be 00 00 00 00       	mov    $0x0,%esi
  801cda:	bf 0b 00 00 00       	mov    $0xb,%edi
  801cdf:	48 b8 2d 19 80 00 00 	movabs $0x80192d,%rax
  801ce6:	00 00 00 
  801ce9:	ff d0                	callq  *%rax
  801ceb:	48 83 c4 10          	add    $0x10,%rsp
}
  801cef:	c9                   	leaveq 
  801cf0:	c3                   	retq   

0000000000801cf1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801cf1:	55                   	push   %rbp
  801cf2:	48 89 e5             	mov    %rsp,%rbp
  801cf5:	48 83 ec 10          	sub    $0x10,%rsp
  801cf9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801cfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d01:	48 83 ec 08          	sub    $0x8,%rsp
  801d05:	6a 00                	pushq  $0x0
  801d07:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d0d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d13:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d18:	48 89 c2             	mov    %rax,%rdx
  801d1b:	be 01 00 00 00       	mov    $0x1,%esi
  801d20:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d25:	48 b8 2d 19 80 00 00 	movabs $0x80192d,%rax
  801d2c:	00 00 00 
  801d2f:	ff d0                	callq  *%rax
  801d31:	48 83 c4 10          	add    $0x10,%rsp
}
  801d35:	c9                   	leaveq 
  801d36:	c3                   	retq   
