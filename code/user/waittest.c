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