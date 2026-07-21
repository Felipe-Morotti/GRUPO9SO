# Códigos gerados para implementação do trabalho de SO
---
* Kernel
* defs.h
void            update_time(void);

* proc.c
// Felipe
  p->ctime = ticks;     // Tick de criação
  p->rtime = 0;  // Ticks acumulados rodando (RUNNING)
  p->wtime = 0;  // Ticks acumulados em espera (RUNNABLE)
  p->burst = 0;  // Escalonador trata como desconhecido = 0

// Felipe
// Helper para os ticks
void
update_time(void)
{
 struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);

    if (p->state == RUNNING) p->rtime++;
    else if (p->state == RUNNABLE) p->wtime++;
    
    release(&p->lock);
  }
}

void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();

  c->proc = 0;
  for (;;) {
    intr_on();

    int found = 0;
    struct proc *chosen = 0;
    int best_remaining = 2147483647;

    for(p = proc; p < &proc[NPROC]; p++) {
      acquire(&p->lock);
      if(p->state == RUNNABLE) {
        int remaining;
        if (p->burst > 0)
          remaining = p->burst - p->rtime;
        else
          remaining = 2147483647;

        if (chosen == 0 || remaining < best_remaining) {
          best_remaining = remaining;
          chosen = p;
        }
      }
      release(&p->lock);
    }

    if (chosen != 0) {
      acquire(&chosen->lock);
      if (chosen->state == RUNNABLE) {
        chosen->state = RUNNING;
        c->proc = chosen;
        swtch(&c->context, &chosen->context);
        c->proc = 0;
        found = 1;
      }
      release(&chosen->lock);
    }

    if (found == 0) {
      intr_on();
      asm volatile("wfi");
    } 
  }
}

* proc.h
  // Felipe
  int ctime;    // Tick de criação
  int rtime;    // Ticks acumulados running
  int wtime;    // Ticks acumulados runnable
  int etime;    // Ticks para turnaround
  int burst;    // Ticks de CPU esperados, inicializado por setburst()

extern struct proc proc[NPROC];

* syscall.c
// Felipe
extern uint64 sys_getwaittime(void);
extern uint64 sys_setburst(void);
extern uint64 sys_setburstpid(void);

[SYS_getwaittime] sys_getwaittime, // Felipe
[SYS_setburst] sys_setburst,
[SYS_setburstpid] sys_setburstpid,

* syscall.h
// Felipe
#define SYS_getwaittime 23
#define SYS_setburst 24
#define SYS_setburstpid 25

* sysproc.c
// Felipe
uint64
sys_getwaittime(void)
{
  return myproc()->wtime;
}

uint64
sys_setburst(void)
{
  int n;
  argint(0, &n);          // lê o primeiro (0th) argumento em n
  if (n < 0)
    return -1;
  myproc()->burst = n;
  return 0;
}

uint64
sys_setburstpid(void)
{
  int pid, n;
  argint(0, &pid);
  argint(1, &n);
  if (n < 0)
    return -1;

  struct proc *p;
  int found = 0;
  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->pid == pid) {
      p->burst = n;
      found = 1;
    }
    release(&p->lock);
  }
  return found ? 0 : -1;
}

* trap.c
// Felipe
void
clockintr()
{
  if (cpuid() == 0) {
    acquire(&tickslock);
    ticks++;
    wakeup(&ticks);
    release(&tickslock);

    update_time(); // mudança principal
}

* User
* user.h
// Felipe
int getwaittime(void);
int setburst(int);
int setburstpid(int, int);

* usys.pl
entry("getwaittime");
entry("setburst");
entry("setburstpid");

* waittest.c
// user/waittest.c
//
// Test harness for getwaittime() and SRTF validation.
//   waittest solo                    -> baseline: one process, no contention
//   waittest <n>                     -> N children with equal, undeclared bursts (round-robin behavior)
//   waittest srtf <b1> <b2> ...      -> N children with different declared bursts (for SRTF comparison)

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

// Burns CPU for `loops` iterations. Simulates a CPU burst so processes
// actually have something to compete over.
void
burn_cpu(long loops)
{
  volatile long i;
  volatile long x = 0;
  for (i = 0; i < loops; i++) {
    x = x + i;
  }
}

int
main(int argc, char *argv[])
{
  if (argc < 2) {
    printf("usage: waittest solo | waittest <n_children> | waittest srtf <burst1> <burst2> ...\n");
    exit(1);
  }

  // --- Baseline mode: single process, no contention ---
  if (strcmp(argv[1], "solo") == 0) {
    int wt_before = getwaittime();
    burn_cpu(50000000);
    int wt_after = getwaittime();
    printf("[solo] wait time before=%d after=%d (expect ~0, since nothing else was runnable)\n",
           wt_before, wt_after);
    exit(0);
  }

  // --- SRTF mode: children declare different bursts via setburst() ---
  if (strcmp(argv[1], "srtf") == 0) {
    int n = argc - 2;
    if (n <= 0) {
      printf("usage: waittest srtf <burst1> <burst2> ...\n");
      exit(1);
    }

    printf("[parent] forking %d children with declared bursts...\n", n);

    for (int i = 0; i < n; i++) {
      int burst = atoi(argv[2 + i]);
      int pid = fork();
      if (pid < 0) {
        printf("fork failed\n");
        exit(1);
      }
      if (pid == 0) {
        burn_cpu((long)burst * 1000000L);
        int wt = getwaittime();
        printf("[child %d, pid %d, burst %d] wait time = %d ticks\n", i, getpid(), burst, wt);
        exit(0);
      } else {
        setburstpid(pid, burst);
      }
    }

    for (int i = 0; i < n; i++) {
      wait(0);
    }

    printf("[parent] all children done\n");
    exit(0);
  }

  // --- Plain contention mode: N children, equal undeclared bursts ---
  int n = atoi(argv[1]);
  if (n <= 0) {
    printf("n_children must be a positive integer\n");
    exit(1);
  }

  printf("[parent] forking %d children to create CPU contention...\n", n);

  for (int i = 0; i < n; i++) {
    int pid = fork();
    if (pid < 0) {
      printf("fork failed\n");
      exit(1);
    }
    if (pid == 0) {
      burn_cpu(50000000);
      int wt = getwaittime();
      printf("[child %d, pid %d] wait time = %d ticks\n", i, getpid(), wt);
      exit(0);
    }
  }

  for (int i = 0; i < n; i++) {
    wait(0);
  }

  printf("[parent] all children done\n");
  exit(0);
}

* Makefile
$U/_waittest\