// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

/*
	Shai Caspin
	COMP530H Fall 2018 Porter Lab1H
*/


#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/kdebug.h>
#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/dwarf.h>
#include <kern/kdebug.h>
#include <kern/dwarf_api.h>
#include <kern/trap.h>

#define CMDBUF_SIZE	80	// enough for one VGA text line


struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Backtrace through the stack", mon_backtrace },
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	cprintf("Stack backtrace:\n");

	//gather initial rbp and rip
	uint64_t rbp = read_rbp();
	uint64_t rip;
	__asm __volatile("leaq (%%rip), %0" : "=r" (rip)::"cc","memory");

	//iterate until end
	while(rbp!=0){
		struct Ripdebuginfo ripdebug;
		struct Ripdebuginfo *info;
		info = &ripdebug;
		int returnInt = debuginfo_rip(rip,info);

		//print first line
		cprintf("  rbp %016llx  rip %016llx\n", rbp, rip);

		//make sure rip debug was successfull
		if (returnInt==0){
		
			//gather data for second line of print
			const char *rip_file = info->rip_file;
			int line = info->rip_line;
			const char *funct_name = info->rip_fn_name;
			uint64_t funct_add= (uint64_t)(info->rip_fn_addr);
			uint64_t funct_off = rip - funct_add ;
			int args = info->rip_fn_narg;

			//print second line
			cprintf("    %s:%d: %s+%016llx  args:%d", rip_file,line,funct_name,funct_off, args);

			//get data for arguments
			uint16_t regnum = ripdebug.reg_table.cfa_rule.dw_regnum;
                        uint64_t ptr;
			//determine where arguments should be read from
                        if (regnum==6){
                        	ptr = rbp+ripdebug.reg_table.cfa_rule.dw_offset;
                        }else if(regnum==7){
	                	ptr = read_rsp()+ripdebug.reg_table.cfa_rule.dw_offset;
                        }
				
			//print arguments from stack
			for (int i=1; i<=args; i++){
				uint64_t argument = ptr+ripdebug.offset_fn_arg[i-1];
				uint16_t *arg_ptr=(uint16_t *)argument;
				cprintf("  %016x", arg_ptr[0]);
			}
			cprintf("\n");
		}

		//get next values
		rip = ((uint64_t *)rbp)[1];
		rbp = ((uint64_t *)rbp)[0];
	}
	return 0;
}



/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	if (tf != NULL)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
