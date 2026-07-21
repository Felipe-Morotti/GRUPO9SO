
user/_waittest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <burn_cpu>:

// Burns CPU for `loops` iterations. Simulates a CPU burst so processes
// actually have something to compete over.
void
burn_cpu(long loops)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec22                	sd	s0,24(sp)
   4:	1000                	addi	s0,sp,32
  volatile long i;
  volatile long x = 0;
   6:	fe043023          	sd	zero,-32(s0)
  for (i = 0; i < loops; i++) {
   a:	fe043423          	sd	zero,-24(s0)
   e:	fe843783          	ld	a5,-24(s0)
  12:	02a7d263          	bge	a5,a0,36 <burn_cpu+0x36>
    x = x + i;
  16:	fe043783          	ld	a5,-32(s0)
  1a:	fe843703          	ld	a4,-24(s0)
  1e:	97ba                	add	a5,a5,a4
  20:	fef43023          	sd	a5,-32(s0)
  for (i = 0; i < loops; i++) {
  24:	fe843783          	ld	a5,-24(s0)
  28:	0785                	addi	a5,a5,1
  2a:	fef43423          	sd	a5,-24(s0)
  2e:	fe843783          	ld	a5,-24(s0)
  32:	fea7c2e3          	blt	a5,a0,16 <burn_cpu+0x16>
  }
}
  36:	6462                	ld	s0,24(sp)
  38:	6105                	addi	sp,sp,32
  3a:	8082                	ret

000000000000003c <main>:

int
main(int argc, char *argv[])
{
  3c:	7139                	addi	sp,sp,-64
  3e:	fc06                	sd	ra,56(sp)
  40:	f822                	sd	s0,48(sp)
  42:	0080                	addi	s0,sp,64
  if (argc < 2) {
  44:	4785                	li	a5,1
  46:	04a7d863          	bge	a5,a0,96 <main+0x5a>
  4a:	f426                	sd	s1,40(sp)
  4c:	f04a                	sd	s2,32(sp)
  4e:	892a                	mv	s2,a0
  50:	84ae                	mv	s1,a1
    printf("usage: waittest solo | waittest <n_children> | waittest srtf <burst1> <burst2> ...\n");
    exit(1);
  }

  // --- Baseline mode: single process, no contention ---
  if (strcmp(argv[1], "solo") == 0) {
  52:	00001597          	auipc	a1,0x1
  56:	ad658593          	addi	a1,a1,-1322 # b28 <malloc+0x154>
  5a:	6488                	ld	a0,8(s1)
  5c:	214000ef          	jal	270 <strcmp>
  60:	e931                	bnez	a0,b4 <main+0x78>
  62:	ec4e                	sd	s3,24(sp)
  64:	e852                	sd	s4,16(sp)
  66:	e456                	sd	s5,8(sp)
  68:	e05a                	sd	s6,0(sp)
    int wt_before = getwaittime();
  6a:	516000ef          	jal	580 <getwaittime>
  6e:	84aa                	mv	s1,a0
    burn_cpu(50000000);
  70:	02faf537          	lui	a0,0x2faf
  74:	08050513          	addi	a0,a0,128 # 2faf080 <base+0x2fad070>
  78:	f89ff0ef          	jal	0 <burn_cpu>
    int wt_after = getwaittime();
  7c:	504000ef          	jal	580 <getwaittime>
  80:	862a                	mv	a2,a0
    printf("[solo] wait time before=%d after=%d (expect ~0, since nothing else was runnable)\n",
  82:	85a6                	mv	a1,s1
  84:	00001517          	auipc	a0,0x1
  88:	aac50513          	addi	a0,a0,-1364 # b30 <malloc+0x15c>
  8c:	095000ef          	jal	920 <printf>
           wt_before, wt_after);
    exit(0);
  90:	4501                	li	a0,0
  92:	446000ef          	jal	4d8 <exit>
  96:	f426                	sd	s1,40(sp)
  98:	f04a                	sd	s2,32(sp)
  9a:	ec4e                	sd	s3,24(sp)
  9c:	e852                	sd	s4,16(sp)
  9e:	e456                	sd	s5,8(sp)
  a0:	e05a                	sd	s6,0(sp)
    printf("usage: waittest solo | waittest <n_children> | waittest srtf <burst1> <burst2> ...\n");
  a2:	00001517          	auipc	a0,0x1
  a6:	a2e50513          	addi	a0,a0,-1490 # ad0 <malloc+0xfc>
  aa:	077000ef          	jal	920 <printf>
    exit(1);
  ae:	4505                	li	a0,1
  b0:	428000ef          	jal	4d8 <exit>
  b4:	ec4e                	sd	s3,24(sp)
  }

  // --- SRTF mode: children declare different bursts via setburst() ---
  if (strcmp(argv[1], "srtf") == 0) {
  b6:	00001597          	auipc	a1,0x1
  ba:	ad258593          	addi	a1,a1,-1326 # b88 <malloc+0x1b4>
  be:	6488                	ld	a0,8(s1)
  c0:	1b0000ef          	jal	270 <strcmp>
  c4:	89aa                	mv	s3,a0
  c6:	0c051063          	bnez	a0,186 <main+0x14a>
  ca:	e05a                	sd	s6,0(sp)
    int n = argc - 2;
  cc:	ffe90b1b          	addiw	s6,s2,-2
    if (n <= 0) {
  d0:	05605d63          	blez	s6,12a <main+0xee>
  d4:	e852                	sd	s4,16(sp)
  d6:	e456                	sd	s5,8(sp)
      printf("usage: waittest srtf <burst1> <burst2> ...\n");
      exit(1);
    }

    printf("[parent] forking %d children with declared bursts...\n", n);
  d8:	85da                	mv	a1,s6
  da:	00001517          	auipc	a0,0x1
  de:	ae650513          	addi	a0,a0,-1306 # bc0 <malloc+0x1ec>
  e2:	03f000ef          	jal	920 <printf>

    for (int i = 0; i < n; i++) {
  e6:	04c1                	addi	s1,s1,16
  e8:	3979                	addiw	s2,s2,-2
  ea:	8ace                	mv	s5,s3
      int burst = atoi(argv[2 + i]);
  ec:	6088                	ld	a0,0(s1)
  ee:	2c8000ef          	jal	3b6 <atoi>
  f2:	8a2a                	mv	s4,a0
      int pid = fork();
  f4:	3dc000ef          	jal	4d0 <fork>
      if (pid < 0) {
  f8:	04054463          	bltz	a0,140 <main+0x104>
        printf("fork failed\n");
        exit(1);
      }
      if (pid == 0) {
  fc:	c939                	beqz	a0,152 <main+0x116>
        burn_cpu((long)burst * 1000000L);
        int wt = getwaittime();
        printf("[child %d, pid %d, burst %d] wait time = %d ticks\n", i, getpid(), burst, wt);
        exit(0);
      } else {
        setburstpid(pid, burst);
  fe:	85d2                	mv	a1,s4
 100:	490000ef          	jal	590 <setburstpid>
    for (int i = 0; i < n; i++) {
 104:	2a85                	addiw	s5,s5,1
 106:	04a1                	addi	s1,s1,8
 108:	ff2a92e3          	bne	s5,s2,ec <main+0xb0>
      }
    }

    for (int i = 0; i < n; i++) {
      wait(0);
 10c:	4501                	li	a0,0
 10e:	3d2000ef          	jal	4e0 <wait>
    for (int i = 0; i < n; i++) {
 112:	2985                	addiw	s3,s3,1
 114:	ff69cce3          	blt	s3,s6,10c <main+0xd0>
    }

    printf("[parent] all children done\n");
 118:	00001517          	auipc	a0,0x1
 11c:	b2850513          	addi	a0,a0,-1240 # c40 <malloc+0x26c>
 120:	001000ef          	jal	920 <printf>
    exit(0);
 124:	4501                	li	a0,0
 126:	3b2000ef          	jal	4d8 <exit>
 12a:	e852                	sd	s4,16(sp)
 12c:	e456                	sd	s5,8(sp)
      printf("usage: waittest srtf <burst1> <burst2> ...\n");
 12e:	00001517          	auipc	a0,0x1
 132:	a6250513          	addi	a0,a0,-1438 # b90 <malloc+0x1bc>
 136:	7ea000ef          	jal	920 <printf>
      exit(1);
 13a:	4505                	li	a0,1
 13c:	39c000ef          	jal	4d8 <exit>
        printf("fork failed\n");
 140:	00001517          	auipc	a0,0x1
 144:	ab850513          	addi	a0,a0,-1352 # bf8 <malloc+0x224>
 148:	7d8000ef          	jal	920 <printf>
        exit(1);
 14c:	4505                	li	a0,1
 14e:	38a000ef          	jal	4d8 <exit>
        burn_cpu((long)burst * 1000000L);
 152:	000f4537          	lui	a0,0xf4
 156:	24050513          	addi	a0,a0,576 # f4240 <base+0xf2230>
 15a:	02aa0533          	mul	a0,s4,a0
 15e:	ea3ff0ef          	jal	0 <burn_cpu>
        int wt = getwaittime();
 162:	41e000ef          	jal	580 <getwaittime>
 166:	84aa                	mv	s1,a0
        printf("[child %d, pid %d, burst %d] wait time = %d ticks\n", i, getpid(), burst, wt);
 168:	3f0000ef          	jal	558 <getpid>
 16c:	862a                	mv	a2,a0
 16e:	8726                	mv	a4,s1
 170:	86d2                	mv	a3,s4
 172:	85d6                	mv	a1,s5
 174:	00001517          	auipc	a0,0x1
 178:	a9450513          	addi	a0,a0,-1388 # c08 <malloc+0x234>
 17c:	7a4000ef          	jal	920 <printf>
        exit(0);
 180:	4501                	li	a0,0
 182:	356000ef          	jal	4d8 <exit>
  }

  // --- Plain contention mode: N children, equal undeclared bursts ---
  int n = atoi(argv[1]);
 186:	6488                	ld	a0,8(s1)
 188:	22e000ef          	jal	3b6 <atoi>
 18c:	892a                	mv	s2,a0
  if (n <= 0) {
 18e:	00a05b63          	blez	a0,1a4 <main+0x168>
    printf("n_children must be a positive integer\n");
    exit(1);
  }

  printf("[parent] forking %d children to create CPU contention...\n", n);
 192:	85aa                	mv	a1,a0
 194:	00001517          	auipc	a0,0x1
 198:	af450513          	addi	a0,a0,-1292 # c88 <malloc+0x2b4>
 19c:	784000ef          	jal	920 <printf>

  for (int i = 0; i < n; i++) {
 1a0:	4481                	li	s1,0
 1a2:	a831                	j	1be <main+0x182>
 1a4:	e852                	sd	s4,16(sp)
 1a6:	e456                	sd	s5,8(sp)
 1a8:	e05a                	sd	s6,0(sp)
    printf("n_children must be a positive integer\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	ab650513          	addi	a0,a0,-1354 # c60 <malloc+0x28c>
 1b2:	76e000ef          	jal	920 <printf>
    exit(1);
 1b6:	4505                	li	a0,1
 1b8:	320000ef          	jal	4d8 <exit>
 1bc:	84be                	mv	s1,a5
    int pid = fork();
 1be:	312000ef          	jal	4d0 <fork>
    if (pid < 0) {
 1c2:	02054b63          	bltz	a0,1f8 <main+0x1bc>
      printf("fork failed\n");
      exit(1);
    }
    if (pid == 0) {
 1c6:	c529                	beqz	a0,210 <main+0x1d4>
  for (int i = 0; i < n; i++) {
 1c8:	0014879b          	addiw	a5,s1,1
 1cc:	fef918e3          	bne	s2,a5,1bc <main+0x180>
 1d0:	e852                	sd	s4,16(sp)
 1d2:	e456                	sd	s5,8(sp)
 1d4:	e05a                	sd	s6,0(sp)
      printf("[child %d, pid %d] wait time = %d ticks\n", i, getpid(), wt);
      exit(0);
    }
  }

  for (int i = 0; i < n; i++) {
 1d6:	4901                	li	s2,0
    wait(0);
 1d8:	4501                	li	a0,0
 1da:	306000ef          	jal	4e0 <wait>
  for (int i = 0; i < n; i++) {
 1de:	87ca                	mv	a5,s2
 1e0:	2905                	addiw	s2,s2,1
 1e2:	fef49be3          	bne	s1,a5,1d8 <main+0x19c>
  }

  printf("[parent] all children done\n");
 1e6:	00001517          	auipc	a0,0x1
 1ea:	a5a50513          	addi	a0,a0,-1446 # c40 <malloc+0x26c>
 1ee:	732000ef          	jal	920 <printf>
  exit(0);
 1f2:	4501                	li	a0,0
 1f4:	2e4000ef          	jal	4d8 <exit>
 1f8:	e852                	sd	s4,16(sp)
 1fa:	e456                	sd	s5,8(sp)
 1fc:	e05a                	sd	s6,0(sp)
      printf("fork failed\n");
 1fe:	00001517          	auipc	a0,0x1
 202:	9fa50513          	addi	a0,a0,-1542 # bf8 <malloc+0x224>
 206:	71a000ef          	jal	920 <printf>
      exit(1);
 20a:	4505                	li	a0,1
 20c:	2cc000ef          	jal	4d8 <exit>
 210:	e852                	sd	s4,16(sp)
 212:	e456                	sd	s5,8(sp)
 214:	e05a                	sd	s6,0(sp)
      burn_cpu(50000000);
 216:	02faf537          	lui	a0,0x2faf
 21a:	08050513          	addi	a0,a0,128 # 2faf080 <base+0x2fad070>
 21e:	de3ff0ef          	jal	0 <burn_cpu>
      int wt = getwaittime();
 222:	35e000ef          	jal	580 <getwaittime>
 226:	892a                	mv	s2,a0
      printf("[child %d, pid %d] wait time = %d ticks\n", i, getpid(), wt);
 228:	330000ef          	jal	558 <getpid>
 22c:	862a                	mv	a2,a0
 22e:	86ca                	mv	a3,s2
 230:	85a6                	mv	a1,s1
 232:	00001517          	auipc	a0,0x1
 236:	a9650513          	addi	a0,a0,-1386 # cc8 <malloc+0x2f4>
 23a:	6e6000ef          	jal	920 <printf>
      exit(0);
 23e:	4501                	li	a0,0
 240:	298000ef          	jal	4d8 <exit>

0000000000000244 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 24c:	df1ff0ef          	jal	3c <main>
  exit(r);
 250:	288000ef          	jal	4d8 <exit>

0000000000000254 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 254:	1141                	addi	sp,sp,-16
 256:	e422                	sd	s0,8(sp)
 258:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 25a:	87aa                	mv	a5,a0
 25c:	0585                	addi	a1,a1,1
 25e:	0785                	addi	a5,a5,1
 260:	fff5c703          	lbu	a4,-1(a1)
 264:	fee78fa3          	sb	a4,-1(a5)
 268:	fb75                	bnez	a4,25c <strcpy+0x8>
    ;
  return os;
}
 26a:	6422                	ld	s0,8(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret

0000000000000270 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 270:	1141                	addi	sp,sp,-16
 272:	e422                	sd	s0,8(sp)
 274:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 276:	00054783          	lbu	a5,0(a0)
 27a:	cb91                	beqz	a5,28e <strcmp+0x1e>
 27c:	0005c703          	lbu	a4,0(a1)
 280:	00f71763          	bne	a4,a5,28e <strcmp+0x1e>
    p++, q++;
 284:	0505                	addi	a0,a0,1
 286:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 288:	00054783          	lbu	a5,0(a0)
 28c:	fbe5                	bnez	a5,27c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 28e:	0005c503          	lbu	a0,0(a1)
}
 292:	40a7853b          	subw	a0,a5,a0
 296:	6422                	ld	s0,8(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret

000000000000029c <strlen>:

uint
strlen(const char *s)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e422                	sd	s0,8(sp)
 2a0:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	cf91                	beqz	a5,2c2 <strlen+0x26>
 2a8:	0505                	addi	a0,a0,1
 2aa:	87aa                	mv	a5,a0
 2ac:	86be                	mv	a3,a5
 2ae:	0785                	addi	a5,a5,1
 2b0:	fff7c703          	lbu	a4,-1(a5)
 2b4:	ff65                	bnez	a4,2ac <strlen+0x10>
 2b6:	40a6853b          	subw	a0,a3,a0
 2ba:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
  for (n = 0; s[n]; n++)
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <strlen+0x20>

00000000000002c6 <memset>:

void *
memset(void *dst, int c, uint n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e422                	sd	s0,8(sp)
 2ca:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 2cc:	ca19                	beqz	a2,2e2 <memset+0x1c>
 2ce:	87aa                	mv	a5,a0
 2d0:	1602                	slli	a2,a2,0x20
 2d2:	9201                	srli	a2,a2,0x20
 2d4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2d8:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 2dc:	0785                	addi	a5,a5,1
 2de:	fee79de3          	bne	a5,a4,2d8 <memset+0x12>
  }
  return dst;
}
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <strchr>:

char *
strchr(const char *s, char c)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e422                	sd	s0,8(sp)
 2ec:	0800                	addi	s0,sp,16
  for (; *s; s++)
 2ee:	00054783          	lbu	a5,0(a0)
 2f2:	cb99                	beqz	a5,308 <strchr+0x20>
    if (*s == c)
 2f4:	00f58763          	beq	a1,a5,302 <strchr+0x1a>
  for (; *s; s++)
 2f8:	0505                	addi	a0,a0,1
 2fa:	00054783          	lbu	a5,0(a0)
 2fe:	fbfd                	bnez	a5,2f4 <strchr+0xc>
      return (char *)s;
  return 0;
 300:	4501                	li	a0,0
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret
  return 0;
 308:	4501                	li	a0,0
 30a:	bfe5                	j	302 <strchr+0x1a>

000000000000030c <gets>:

char *
gets(char *buf, int max)
{
 30c:	711d                	addi	sp,sp,-96
 30e:	ec86                	sd	ra,88(sp)
 310:	e8a2                	sd	s0,80(sp)
 312:	e4a6                	sd	s1,72(sp)
 314:	e0ca                	sd	s2,64(sp)
 316:	fc4e                	sd	s3,56(sp)
 318:	f852                	sd	s4,48(sp)
 31a:	f456                	sd	s5,40(sp)
 31c:	f05a                	sd	s6,32(sp)
 31e:	ec5e                	sd	s7,24(sp)
 320:	1080                	addi	s0,sp,96
 322:	8baa                	mv	s7,a0
 324:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 326:	892a                	mv	s2,a0
 328:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 32a:	4aa9                	li	s5,10
 32c:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 32e:	89a6                	mv	s3,s1
 330:	2485                	addiw	s1,s1,1
 332:	0344d663          	bge	s1,s4,35e <gets+0x52>
    cc = read(0, &c, 1);
 336:	4605                	li	a2,1
 338:	faf40593          	addi	a1,s0,-81
 33c:	4501                	li	a0,0
 33e:	1b2000ef          	jal	4f0 <read>
    if (cc < 1)
 342:	00a05e63          	blez	a0,35e <gets+0x52>
    buf[i++] = c;
 346:	faf44783          	lbu	a5,-81(s0)
 34a:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 34e:	01578763          	beq	a5,s5,35c <gets+0x50>
 352:	0905                	addi	s2,s2,1
 354:	fd679de3          	bne	a5,s6,32e <gets+0x22>
    buf[i++] = c;
 358:	89a6                	mv	s3,s1
 35a:	a011                	j	35e <gets+0x52>
 35c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 35e:	99de                	add	s3,s3,s7
 360:	00098023          	sb	zero,0(s3)
  return buf;
}
 364:	855e                	mv	a0,s7
 366:	60e6                	ld	ra,88(sp)
 368:	6446                	ld	s0,80(sp)
 36a:	64a6                	ld	s1,72(sp)
 36c:	6906                	ld	s2,64(sp)
 36e:	79e2                	ld	s3,56(sp)
 370:	7a42                	ld	s4,48(sp)
 372:	7aa2                	ld	s5,40(sp)
 374:	7b02                	ld	s6,32(sp)
 376:	6be2                	ld	s7,24(sp)
 378:	6125                	addi	sp,sp,96
 37a:	8082                	ret

000000000000037c <stat>:

int
stat(const char *n, struct stat *st)
{
 37c:	1101                	addi	sp,sp,-32
 37e:	ec06                	sd	ra,24(sp)
 380:	e822                	sd	s0,16(sp)
 382:	e04a                	sd	s2,0(sp)
 384:	1000                	addi	s0,sp,32
 386:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 388:	4581                	li	a1,0
 38a:	18e000ef          	jal	518 <open>
  if (fd < 0)
 38e:	02054263          	bltz	a0,3b2 <stat+0x36>
 392:	e426                	sd	s1,8(sp)
 394:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 396:	85ca                	mv	a1,s2
 398:	198000ef          	jal	530 <fstat>
 39c:	892a                	mv	s2,a0
  close(fd);
 39e:	8526                	mv	a0,s1
 3a0:	160000ef          	jal	500 <close>
  return r;
 3a4:	64a2                	ld	s1,8(sp)
}
 3a6:	854a                	mv	a0,s2
 3a8:	60e2                	ld	ra,24(sp)
 3aa:	6442                	ld	s0,16(sp)
 3ac:	6902                	ld	s2,0(sp)
 3ae:	6105                	addi	sp,sp,32
 3b0:	8082                	ret
    return -1;
 3b2:	597d                	li	s2,-1
 3b4:	bfcd                	j	3a6 <stat+0x2a>

00000000000003b6 <atoi>:

int
atoi(const char *s)
{
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e422                	sd	s0,8(sp)
 3ba:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 3bc:	00054683          	lbu	a3,0(a0)
 3c0:	fd06879b          	addiw	a5,a3,-48
 3c4:	0ff7f793          	zext.b	a5,a5
 3c8:	4625                	li	a2,9
 3ca:	02f66863          	bltu	a2,a5,3fa <atoi+0x44>
 3ce:	872a                	mv	a4,a0
  n = 0;
 3d0:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 3d2:	0705                	addi	a4,a4,1
 3d4:	0025179b          	slliw	a5,a0,0x2
 3d8:	9fa9                	addw	a5,a5,a0
 3da:	0017979b          	slliw	a5,a5,0x1
 3de:	9fb5                	addw	a5,a5,a3
 3e0:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 3e4:	00074683          	lbu	a3,0(a4)
 3e8:	fd06879b          	addiw	a5,a3,-48
 3ec:	0ff7f793          	zext.b	a5,a5
 3f0:	fef671e3          	bgeu	a2,a5,3d2 <atoi+0x1c>
  return n;
}
 3f4:	6422                	ld	s0,8(sp)
 3f6:	0141                	addi	sp,sp,16
 3f8:	8082                	ret
  n = 0;
 3fa:	4501                	li	a0,0
 3fc:	bfe5                	j	3f4 <atoi+0x3e>

00000000000003fe <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 3fe:	1141                	addi	sp,sp,-16
 400:	e422                	sd	s0,8(sp)
 402:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 404:	02b57463          	bgeu	a0,a1,42c <memmove+0x2e>
    while (n-- > 0)
 408:	00c05f63          	blez	a2,426 <memmove+0x28>
 40c:	1602                	slli	a2,a2,0x20
 40e:	9201                	srli	a2,a2,0x20
 410:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 414:	872a                	mv	a4,a0
      *dst++ = *src++;
 416:	0585                	addi	a1,a1,1
 418:	0705                	addi	a4,a4,1
 41a:	fff5c683          	lbu	a3,-1(a1)
 41e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 422:	fef71ae3          	bne	a4,a5,416 <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 426:	6422                	ld	s0,8(sp)
 428:	0141                	addi	sp,sp,16
 42a:	8082                	ret
    dst += n;
 42c:	00c50733          	add	a4,a0,a2
    src += n;
 430:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 432:	fec05ae3          	blez	a2,426 <memmove+0x28>
 436:	fff6079b          	addiw	a5,a2,-1
 43a:	1782                	slli	a5,a5,0x20
 43c:	9381                	srli	a5,a5,0x20
 43e:	fff7c793          	not	a5,a5
 442:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 444:	15fd                	addi	a1,a1,-1
 446:	177d                	addi	a4,a4,-1
 448:	0005c683          	lbu	a3,0(a1)
 44c:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 450:	fee79ae3          	bne	a5,a4,444 <memmove+0x46>
 454:	bfc9                	j	426 <memmove+0x28>

0000000000000456 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 456:	1141                	addi	sp,sp,-16
 458:	e422                	sd	s0,8(sp)
 45a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 45c:	ca05                	beqz	a2,48c <memcmp+0x36>
 45e:	fff6069b          	addiw	a3,a2,-1
 462:	1682                	slli	a3,a3,0x20
 464:	9281                	srli	a3,a3,0x20
 466:	0685                	addi	a3,a3,1
 468:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 46a:	00054783          	lbu	a5,0(a0)
 46e:	0005c703          	lbu	a4,0(a1)
 472:	00e79863          	bne	a5,a4,482 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 476:	0505                	addi	a0,a0,1
    p2++;
 478:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 47a:	fed518e3          	bne	a0,a3,46a <memcmp+0x14>
  }
  return 0;
 47e:	4501                	li	a0,0
 480:	a019                	j	486 <memcmp+0x30>
      return *p1 - *p2;
 482:	40e7853b          	subw	a0,a5,a4
}
 486:	6422                	ld	s0,8(sp)
 488:	0141                	addi	sp,sp,16
 48a:	8082                	ret
  return 0;
 48c:	4501                	li	a0,0
 48e:	bfe5                	j	486 <memcmp+0x30>

0000000000000490 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 490:	1141                	addi	sp,sp,-16
 492:	e406                	sd	ra,8(sp)
 494:	e022                	sd	s0,0(sp)
 496:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 498:	f67ff0ef          	jal	3fe <memmove>
}
 49c:	60a2                	ld	ra,8(sp)
 49e:	6402                	ld	s0,0(sp)
 4a0:	0141                	addi	sp,sp,16
 4a2:	8082                	ret

00000000000004a4 <sbrk>:

char *
sbrk(int n)
{
 4a4:	1141                	addi	sp,sp,-16
 4a6:	e406                	sd	ra,8(sp)
 4a8:	e022                	sd	s0,0(sp)
 4aa:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4ac:	4585                	li	a1,1
 4ae:	0b2000ef          	jal	560 <sys_sbrk>
}
 4b2:	60a2                	ld	ra,8(sp)
 4b4:	6402                	ld	s0,0(sp)
 4b6:	0141                	addi	sp,sp,16
 4b8:	8082                	ret

00000000000004ba <sbrklazy>:

char *
sbrklazy(int n)
{
 4ba:	1141                	addi	sp,sp,-16
 4bc:	e406                	sd	ra,8(sp)
 4be:	e022                	sd	s0,0(sp)
 4c0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4c2:	4589                	li	a1,2
 4c4:	09c000ef          	jal	560 <sys_sbrk>
}
 4c8:	60a2                	ld	ra,8(sp)
 4ca:	6402                	ld	s0,0(sp)
 4cc:	0141                	addi	sp,sp,16
 4ce:	8082                	ret

00000000000004d0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4d0:	4885                	li	a7,1
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d8:	4889                	li	a7,2
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4e0:	488d                	li	a7,3
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e8:	4891                	li	a7,4
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <read>:
.global read
read:
 li a7, SYS_read
 4f0:	4895                	li	a7,5
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <write>:
.global write
write:
 li a7, SYS_write
 4f8:	48c1                	li	a7,16
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <close>:
.global close
close:
 li a7, SYS_close
 500:	48d5                	li	a7,21
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <kill>:
.global kill
kill:
 li a7, SYS_kill
 508:	4899                	li	a7,6
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <exec>:
.global exec
exec:
 li a7, SYS_exec
 510:	489d                	li	a7,7
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <open>:
.global open
open:
 li a7, SYS_open
 518:	48bd                	li	a7,15
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 520:	48c5                	li	a7,17
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 528:	48c9                	li	a7,18
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 530:	48a1                	li	a7,8
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <link>:
.global link
link:
 li a7, SYS_link
 538:	48cd                	li	a7,19
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 540:	48d1                	li	a7,20
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 548:	48a5                	li	a7,9
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <dup>:
.global dup
dup:
 li a7, SYS_dup
 550:	48a9                	li	a7,10
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 558:	48ad                	li	a7,11
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 560:	48b1                	li	a7,12
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <pause>:
.global pause
pause:
 li a7, SYS_pause
 568:	48b5                	li	a7,13
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 570:	48b9                	li	a7,14
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <sync>:
.global sync
sync:
 li a7, SYS_sync
 578:	48d9                	li	a7,22
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <getwaittime>:
.global getwaittime
getwaittime:
 li a7, SYS_getwaittime
 580:	48dd                	li	a7,23
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <setburst>:
.global setburst
setburst:
 li a7, SYS_setburst
 588:	48e1                	li	a7,24
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <setburstpid>:
.global setburstpid
setburstpid:
 li a7, SYS_setburstpid
 590:	48e5                	li	a7,25
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 598:	1101                	addi	sp,sp,-32
 59a:	ec06                	sd	ra,24(sp)
 59c:	e822                	sd	s0,16(sp)
 59e:	1000                	addi	s0,sp,32
 5a0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5a4:	4605                	li	a2,1
 5a6:	fef40593          	addi	a1,s0,-17
 5aa:	f4fff0ef          	jal	4f8 <write>
}
 5ae:	60e2                	ld	ra,24(sp)
 5b0:	6442                	ld	s0,16(sp)
 5b2:	6105                	addi	sp,sp,32
 5b4:	8082                	ret

00000000000005b6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5b6:	715d                	addi	sp,sp,-80
 5b8:	e486                	sd	ra,72(sp)
 5ba:	e0a2                	sd	s0,64(sp)
 5bc:	f84a                	sd	s2,48(sp)
 5be:	0880                	addi	s0,sp,80
 5c0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 5c2:	c299                	beqz	a3,5c8 <printint+0x12>
 5c4:	0805c363          	bltz	a1,64a <printint+0x94>
  neg = 0;
 5c8:	4881                	li	a7,0
 5ca:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5ce:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 5d0:	00000517          	auipc	a0,0x0
 5d4:	73050513          	addi	a0,a0,1840 # d00 <digits>
 5d8:	883e                	mv	a6,a5
 5da:	2785                	addiw	a5,a5,1
 5dc:	02c5f733          	remu	a4,a1,a2
 5e0:	972a                	add	a4,a4,a0
 5e2:	00074703          	lbu	a4,0(a4)
 5e6:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 5ea:	872e                	mv	a4,a1
 5ec:	02c5d5b3          	divu	a1,a1,a2
 5f0:	0685                	addi	a3,a3,1
 5f2:	fec773e3          	bgeu	a4,a2,5d8 <printint+0x22>
  if (neg)
 5f6:	00088b63          	beqz	a7,60c <printint+0x56>
    buf[i++] = '-';
 5fa:	fd078793          	addi	a5,a5,-48
 5fe:	97a2                	add	a5,a5,s0
 600:	02d00713          	li	a4,45
 604:	fee78423          	sb	a4,-24(a5)
 608:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 60c:	02f05a63          	blez	a5,640 <printint+0x8a>
 610:	fc26                	sd	s1,56(sp)
 612:	f44e                	sd	s3,40(sp)
 614:	fb840713          	addi	a4,s0,-72
 618:	00f704b3          	add	s1,a4,a5
 61c:	fff70993          	addi	s3,a4,-1
 620:	99be                	add	s3,s3,a5
 622:	37fd                	addiw	a5,a5,-1
 624:	1782                	slli	a5,a5,0x20
 626:	9381                	srli	a5,a5,0x20
 628:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 62c:	fff4c583          	lbu	a1,-1(s1)
 630:	854a                	mv	a0,s2
 632:	f67ff0ef          	jal	598 <putc>
  while (--i >= 0)
 636:	14fd                	addi	s1,s1,-1
 638:	ff349ae3          	bne	s1,s3,62c <printint+0x76>
 63c:	74e2                	ld	s1,56(sp)
 63e:	79a2                	ld	s3,40(sp)
}
 640:	60a6                	ld	ra,72(sp)
 642:	6406                	ld	s0,64(sp)
 644:	7942                	ld	s2,48(sp)
 646:	6161                	addi	sp,sp,80
 648:	8082                	ret
    x = -xx;
 64a:	40b005b3          	neg	a1,a1
    neg = 1;
 64e:	4885                	li	a7,1
    x = -xx;
 650:	bfad                	j	5ca <printint+0x14>

0000000000000652 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 652:	711d                	addi	sp,sp,-96
 654:	ec86                	sd	ra,88(sp)
 656:	e8a2                	sd	s0,80(sp)
 658:	e0ca                	sd	s2,64(sp)
 65a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 65c:	0005c903          	lbu	s2,0(a1)
 660:	28090663          	beqz	s2,8ec <vprintf+0x29a>
 664:	e4a6                	sd	s1,72(sp)
 666:	fc4e                	sd	s3,56(sp)
 668:	f852                	sd	s4,48(sp)
 66a:	f456                	sd	s5,40(sp)
 66c:	f05a                	sd	s6,32(sp)
 66e:	ec5e                	sd	s7,24(sp)
 670:	e862                	sd	s8,16(sp)
 672:	e466                	sd	s9,8(sp)
 674:	8b2a                	mv	s6,a0
 676:	8a2e                	mv	s4,a1
 678:	8bb2                	mv	s7,a2
  state = 0;
 67a:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 67c:	4481                	li	s1,0
 67e:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 680:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 684:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 688:	06c00c93          	li	s9,108
 68c:	a005                	j	6ac <vprintf+0x5a>
        putc(fd, c0);
 68e:	85ca                	mv	a1,s2
 690:	855a                	mv	a0,s6
 692:	f07ff0ef          	jal	598 <putc>
 696:	a019                	j	69c <vprintf+0x4a>
    } else if (state == '%') {
 698:	03598263          	beq	s3,s5,6bc <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 69c:	2485                	addiw	s1,s1,1
 69e:	8726                	mv	a4,s1
 6a0:	009a07b3          	add	a5,s4,s1
 6a4:	0007c903          	lbu	s2,0(a5)
 6a8:	22090a63          	beqz	s2,8dc <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 6ac:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 6b0:	fe0994e3          	bnez	s3,698 <vprintf+0x46>
      if (c0 == '%') {
 6b4:	fd579de3          	bne	a5,s5,68e <vprintf+0x3c>
        state = '%';
 6b8:	89be                	mv	s3,a5
 6ba:	b7cd                	j	69c <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 6bc:	00ea06b3          	add	a3,s4,a4
 6c0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6c4:	8636                	mv	a2,a3
      if (c1)
 6c6:	c681                	beqz	a3,6ce <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 6c8:	9752                	add	a4,a4,s4
 6ca:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 6ce:	05878363          	beq	a5,s8,714 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 6d2:	05978d63          	beq	a5,s9,72c <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 6d6:	07500713          	li	a4,117
 6da:	0ee78763          	beq	a5,a4,7c8 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 6de:	07800713          	li	a4,120
 6e2:	12e78963          	beq	a5,a4,814 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 6e6:	07000713          	li	a4,112
 6ea:	14e78e63          	beq	a5,a4,846 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 6ee:	06300713          	li	a4,99
 6f2:	18e78e63          	beq	a5,a4,88e <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 6f6:	07300713          	li	a4,115
 6fa:	1ae78463          	beq	a5,a4,8a2 <vprintf+0x250>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 6fe:	02500713          	li	a4,37
 702:	04e79563          	bne	a5,a4,74c <vprintf+0xfa>
        putc(fd, '%');
 706:	02500593          	li	a1,37
 70a:	855a                	mv	a0,s6
 70c:	e8dff0ef          	jal	598 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 710:	4981                	li	s3,0
 712:	b769                	j	69c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 714:	008b8913          	addi	s2,s7,8
 718:	4685                	li	a3,1
 71a:	4629                	li	a2,10
 71c:	000ba583          	lw	a1,0(s7)
 720:	855a                	mv	a0,s6
 722:	e95ff0ef          	jal	5b6 <printint>
 726:	8bca                	mv	s7,s2
      state = 0;
 728:	4981                	li	s3,0
 72a:	bf8d                	j	69c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 72c:	06400793          	li	a5,100
 730:	02f68963          	beq	a3,a5,762 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 734:	06c00793          	li	a5,108
 738:	04f68263          	beq	a3,a5,77c <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 73c:	07500793          	li	a5,117
 740:	0af68063          	beq	a3,a5,7e0 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 744:	07800793          	li	a5,120
 748:	0ef68263          	beq	a3,a5,82c <vprintf+0x1da>
        putc(fd, '%');
 74c:	02500593          	li	a1,37
 750:	855a                	mv	a0,s6
 752:	e47ff0ef          	jal	598 <putc>
        putc(fd, c0);
 756:	85ca                	mv	a1,s2
 758:	855a                	mv	a0,s6
 75a:	e3fff0ef          	jal	598 <putc>
      state = 0;
 75e:	4981                	li	s3,0
 760:	bf35                	j	69c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 762:	008b8913          	addi	s2,s7,8
 766:	4685                	li	a3,1
 768:	4629                	li	a2,10
 76a:	000bb583          	ld	a1,0(s7)
 76e:	855a                	mv	a0,s6
 770:	e47ff0ef          	jal	5b6 <printint>
        i += 1;
 774:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 776:	8bca                	mv	s7,s2
      state = 0;
 778:	4981                	li	s3,0
        i += 1;
 77a:	b70d                	j	69c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 77c:	06400793          	li	a5,100
 780:	02f60763          	beq	a2,a5,7ae <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 784:	07500793          	li	a5,117
 788:	06f60963          	beq	a2,a5,7fa <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 78c:	07800793          	li	a5,120
 790:	faf61ee3          	bne	a2,a5,74c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 794:	008b8913          	addi	s2,s7,8
 798:	4681                	li	a3,0
 79a:	4641                	li	a2,16
 79c:	000bb583          	ld	a1,0(s7)
 7a0:	855a                	mv	a0,s6
 7a2:	e15ff0ef          	jal	5b6 <printint>
        i += 2;
 7a6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a8:	8bca                	mv	s7,s2
      state = 0;
 7aa:	4981                	li	s3,0
        i += 2;
 7ac:	bdc5                	j	69c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ae:	008b8913          	addi	s2,s7,8
 7b2:	4685                	li	a3,1
 7b4:	4629                	li	a2,10
 7b6:	000bb583          	ld	a1,0(s7)
 7ba:	855a                	mv	a0,s6
 7bc:	dfbff0ef          	jal	5b6 <printint>
        i += 2;
 7c0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c2:	8bca                	mv	s7,s2
      state = 0;
 7c4:	4981                	li	s3,0
        i += 2;
 7c6:	bdd9                	j	69c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7c8:	008b8913          	addi	s2,s7,8
 7cc:	4681                	li	a3,0
 7ce:	4629                	li	a2,10
 7d0:	000be583          	lwu	a1,0(s7)
 7d4:	855a                	mv	a0,s6
 7d6:	de1ff0ef          	jal	5b6 <printint>
 7da:	8bca                	mv	s7,s2
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	bd7d                	j	69c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e0:	008b8913          	addi	s2,s7,8
 7e4:	4681                	li	a3,0
 7e6:	4629                	li	a2,10
 7e8:	000bb583          	ld	a1,0(s7)
 7ec:	855a                	mv	a0,s6
 7ee:	dc9ff0ef          	jal	5b6 <printint>
        i += 1;
 7f2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f4:	8bca                	mv	s7,s2
      state = 0;
 7f6:	4981                	li	s3,0
        i += 1;
 7f8:	b555                	j	69c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7fa:	008b8913          	addi	s2,s7,8
 7fe:	4681                	li	a3,0
 800:	4629                	li	a2,10
 802:	000bb583          	ld	a1,0(s7)
 806:	855a                	mv	a0,s6
 808:	dafff0ef          	jal	5b6 <printint>
        i += 2;
 80c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 80e:	8bca                	mv	s7,s2
      state = 0;
 810:	4981                	li	s3,0
        i += 2;
 812:	b569                	j	69c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 814:	008b8913          	addi	s2,s7,8
 818:	4681                	li	a3,0
 81a:	4641                	li	a2,16
 81c:	000be583          	lwu	a1,0(s7)
 820:	855a                	mv	a0,s6
 822:	d95ff0ef          	jal	5b6 <printint>
 826:	8bca                	mv	s7,s2
      state = 0;
 828:	4981                	li	s3,0
 82a:	bd8d                	j	69c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 82c:	008b8913          	addi	s2,s7,8
 830:	4681                	li	a3,0
 832:	4641                	li	a2,16
 834:	000bb583          	ld	a1,0(s7)
 838:	855a                	mv	a0,s6
 83a:	d7dff0ef          	jal	5b6 <printint>
        i += 1;
 83e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 840:	8bca                	mv	s7,s2
      state = 0;
 842:	4981                	li	s3,0
        i += 1;
 844:	bda1                	j	69c <vprintf+0x4a>
 846:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 848:	008b8d13          	addi	s10,s7,8
 84c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 850:	03000593          	li	a1,48
 854:	855a                	mv	a0,s6
 856:	d43ff0ef          	jal	598 <putc>
  putc(fd, 'x');
 85a:	07800593          	li	a1,120
 85e:	855a                	mv	a0,s6
 860:	d39ff0ef          	jal	598 <putc>
 864:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 866:	00000b97          	auipc	s7,0x0
 86a:	49ab8b93          	addi	s7,s7,1178 # d00 <digits>
 86e:	03c9d793          	srli	a5,s3,0x3c
 872:	97de                	add	a5,a5,s7
 874:	0007c583          	lbu	a1,0(a5)
 878:	855a                	mv	a0,s6
 87a:	d1fff0ef          	jal	598 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 87e:	0992                	slli	s3,s3,0x4
 880:	397d                	addiw	s2,s2,-1
 882:	fe0916e3          	bnez	s2,86e <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 886:	8bea                	mv	s7,s10
      state = 0;
 888:	4981                	li	s3,0
 88a:	6d02                	ld	s10,0(sp)
 88c:	bd01                	j	69c <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 88e:	008b8913          	addi	s2,s7,8
 892:	000bc583          	lbu	a1,0(s7)
 896:	855a                	mv	a0,s6
 898:	d01ff0ef          	jal	598 <putc>
 89c:	8bca                	mv	s7,s2
      state = 0;
 89e:	4981                	li	s3,0
 8a0:	bbf5                	j	69c <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 8a2:	008b8993          	addi	s3,s7,8
 8a6:	000bb903          	ld	s2,0(s7)
 8aa:	00090f63          	beqz	s2,8c8 <vprintf+0x276>
        for (; *s; s++)
 8ae:	00094583          	lbu	a1,0(s2)
 8b2:	c195                	beqz	a1,8d6 <vprintf+0x284>
          putc(fd, *s);
 8b4:	855a                	mv	a0,s6
 8b6:	ce3ff0ef          	jal	598 <putc>
        for (; *s; s++)
 8ba:	0905                	addi	s2,s2,1
 8bc:	00094583          	lbu	a1,0(s2)
 8c0:	f9f5                	bnez	a1,8b4 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 8c2:	8bce                	mv	s7,s3
      state = 0;
 8c4:	4981                	li	s3,0
 8c6:	bbd9                	j	69c <vprintf+0x4a>
          s = "(null)";
 8c8:	00000917          	auipc	s2,0x0
 8cc:	43090913          	addi	s2,s2,1072 # cf8 <malloc+0x324>
        for (; *s; s++)
 8d0:	02800593          	li	a1,40
 8d4:	b7c5                	j	8b4 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 8d6:	8bce                	mv	s7,s3
      state = 0;
 8d8:	4981                	li	s3,0
 8da:	b3c9                	j	69c <vprintf+0x4a>
 8dc:	64a6                	ld	s1,72(sp)
 8de:	79e2                	ld	s3,56(sp)
 8e0:	7a42                	ld	s4,48(sp)
 8e2:	7aa2                	ld	s5,40(sp)
 8e4:	7b02                	ld	s6,32(sp)
 8e6:	6be2                	ld	s7,24(sp)
 8e8:	6c42                	ld	s8,16(sp)
 8ea:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8ec:	60e6                	ld	ra,88(sp)
 8ee:	6446                	ld	s0,80(sp)
 8f0:	6906                	ld	s2,64(sp)
 8f2:	6125                	addi	sp,sp,96
 8f4:	8082                	ret

00000000000008f6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8f6:	715d                	addi	sp,sp,-80
 8f8:	ec06                	sd	ra,24(sp)
 8fa:	e822                	sd	s0,16(sp)
 8fc:	1000                	addi	s0,sp,32
 8fe:	e010                	sd	a2,0(s0)
 900:	e414                	sd	a3,8(s0)
 902:	e818                	sd	a4,16(s0)
 904:	ec1c                	sd	a5,24(s0)
 906:	03043023          	sd	a6,32(s0)
 90a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 90e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 912:	8622                	mv	a2,s0
 914:	d3fff0ef          	jal	652 <vprintf>
}
 918:	60e2                	ld	ra,24(sp)
 91a:	6442                	ld	s0,16(sp)
 91c:	6161                	addi	sp,sp,80
 91e:	8082                	ret

0000000000000920 <printf>:

void
printf(const char *fmt, ...)
{
 920:	711d                	addi	sp,sp,-96
 922:	ec06                	sd	ra,24(sp)
 924:	e822                	sd	s0,16(sp)
 926:	1000                	addi	s0,sp,32
 928:	e40c                	sd	a1,8(s0)
 92a:	e810                	sd	a2,16(s0)
 92c:	ec14                	sd	a3,24(s0)
 92e:	f018                	sd	a4,32(s0)
 930:	f41c                	sd	a5,40(s0)
 932:	03043823          	sd	a6,48(s0)
 936:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 93a:	00840613          	addi	a2,s0,8
 93e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 942:	85aa                	mv	a1,a0
 944:	4505                	li	a0,1
 946:	d0dff0ef          	jal	652 <vprintf>
}
 94a:	60e2                	ld	ra,24(sp)
 94c:	6442                	ld	s0,16(sp)
 94e:	6125                	addi	sp,sp,96
 950:	8082                	ret

0000000000000952 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 952:	1141                	addi	sp,sp,-16
 954:	e422                	sd	s0,8(sp)
 956:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 958:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95c:	00001797          	auipc	a5,0x1
 960:	6a47b783          	ld	a5,1700(a5) # 2000 <freep>
 964:	a02d                	j	98e <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 966:	4618                	lw	a4,8(a2)
 968:	9f2d                	addw	a4,a4,a1
 96a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 96e:	6398                	ld	a4,0(a5)
 970:	6310                	ld	a2,0(a4)
 972:	a83d                	j	9b0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 974:	ff852703          	lw	a4,-8(a0)
 978:	9f31                	addw	a4,a4,a2
 97a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 97c:	ff053683          	ld	a3,-16(a0)
 980:	a091                	j	9c4 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 982:	6398                	ld	a4,0(a5)
 984:	00e7e463          	bltu	a5,a4,98c <free+0x3a>
 988:	00e6ea63          	bltu	a3,a4,99c <free+0x4a>
{
 98c:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 98e:	fed7fae3          	bgeu	a5,a3,982 <free+0x30>
 992:	6398                	ld	a4,0(a5)
 994:	00e6e463          	bltu	a3,a4,99c <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 998:	fee7eae3          	bltu	a5,a4,98c <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 99c:	ff852583          	lw	a1,-8(a0)
 9a0:	6390                	ld	a2,0(a5)
 9a2:	02059813          	slli	a6,a1,0x20
 9a6:	01c85713          	srli	a4,a6,0x1c
 9aa:	9736                	add	a4,a4,a3
 9ac:	fae60de3          	beq	a2,a4,966 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9b0:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 9b4:	4790                	lw	a2,8(a5)
 9b6:	02061593          	slli	a1,a2,0x20
 9ba:	01c5d713          	srli	a4,a1,0x1c
 9be:	973e                	add	a4,a4,a5
 9c0:	fae68ae3          	beq	a3,a4,974 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9c4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9c6:	00001717          	auipc	a4,0x1
 9ca:	62f73d23          	sd	a5,1594(a4) # 2000 <freep>
}
 9ce:	6422                	ld	s0,8(sp)
 9d0:	0141                	addi	sp,sp,16
 9d2:	8082                	ret

00000000000009d4 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 9d4:	7139                	addi	sp,sp,-64
 9d6:	fc06                	sd	ra,56(sp)
 9d8:	f822                	sd	s0,48(sp)
 9da:	f426                	sd	s1,40(sp)
 9dc:	ec4e                	sd	s3,24(sp)
 9de:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 9e0:	02051493          	slli	s1,a0,0x20
 9e4:	9081                	srli	s1,s1,0x20
 9e6:	04bd                	addi	s1,s1,15
 9e8:	8091                	srli	s1,s1,0x4
 9ea:	0014899b          	addiw	s3,s1,1
 9ee:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 9f0:	00001517          	auipc	a0,0x1
 9f4:	61053503          	ld	a0,1552(a0) # 2000 <freep>
 9f8:	c915                	beqz	a0,a2c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9fa:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9fc:	4798                	lw	a4,8(a5)
 9fe:	08977a63          	bgeu	a4,s1,a92 <malloc+0xbe>
 a02:	f04a                	sd	s2,32(sp)
 a04:	e852                	sd	s4,16(sp)
 a06:	e456                	sd	s5,8(sp)
 a08:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 a0a:	8a4e                	mv	s4,s3
 a0c:	0009871b          	sext.w	a4,s3
 a10:	6685                	lui	a3,0x1
 a12:	00d77363          	bgeu	a4,a3,a18 <malloc+0x44>
 a16:	6a05                	lui	s4,0x1
 a18:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a1c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 a20:	00001917          	auipc	s2,0x1
 a24:	5e090913          	addi	s2,s2,1504 # 2000 <freep>
  if (p == SBRK_ERROR)
 a28:	5afd                	li	s5,-1
 a2a:	a081                	j	a6a <malloc+0x96>
 a2c:	f04a                	sd	s2,32(sp)
 a2e:	e852                	sd	s4,16(sp)
 a30:	e456                	sd	s5,8(sp)
 a32:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a34:	00001797          	auipc	a5,0x1
 a38:	5dc78793          	addi	a5,a5,1500 # 2010 <base>
 a3c:	00001717          	auipc	a4,0x1
 a40:	5cf73223          	sd	a5,1476(a4) # 2000 <freep>
 a44:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a46:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 a4a:	b7c1                	j	a0a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a4c:	6398                	ld	a4,0(a5)
 a4e:	e118                	sd	a4,0(a0)
 a50:	a8a9                	j	aaa <malloc+0xd6>
  hp->s.size = nu;
 a52:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 a56:	0541                	addi	a0,a0,16
 a58:	efbff0ef          	jal	952 <free>
  return freep;
 a5c:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 a60:	c12d                	beqz	a0,ac2 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a62:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a64:	4798                	lw	a4,8(a5)
 a66:	02977263          	bgeu	a4,s1,a8a <malloc+0xb6>
    if (p == freep)
 a6a:	00093703          	ld	a4,0(s2)
 a6e:	853e                	mv	a0,a5
 a70:	fef719e3          	bne	a4,a5,a62 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a74:	8552                	mv	a0,s4
 a76:	a2fff0ef          	jal	4a4 <sbrk>
  if (p == SBRK_ERROR)
 a7a:	fd551ce3          	bne	a0,s5,a52 <malloc+0x7e>
        return 0;
 a7e:	4501                	li	a0,0
 a80:	7902                	ld	s2,32(sp)
 a82:	6a42                	ld	s4,16(sp)
 a84:	6aa2                	ld	s5,8(sp)
 a86:	6b02                	ld	s6,0(sp)
 a88:	a03d                	j	ab6 <malloc+0xe2>
 a8a:	7902                	ld	s2,32(sp)
 a8c:	6a42                	ld	s4,16(sp)
 a8e:	6aa2                	ld	s5,8(sp)
 a90:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 a92:	fae48de3          	beq	s1,a4,a4c <malloc+0x78>
        p->s.size -= nunits;
 a96:	4137073b          	subw	a4,a4,s3
 a9a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a9c:	02071693          	slli	a3,a4,0x20
 aa0:	01c6d713          	srli	a4,a3,0x1c
 aa4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aa6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aaa:	00001717          	auipc	a4,0x1
 aae:	54a73b23          	sd	a0,1366(a4) # 2000 <freep>
      return (void *)(p + 1);
 ab2:	01078513          	addi	a0,a5,16
  }
}
 ab6:	70e2                	ld	ra,56(sp)
 ab8:	7442                	ld	s0,48(sp)
 aba:	74a2                	ld	s1,40(sp)
 abc:	69e2                	ld	s3,24(sp)
 abe:	6121                	addi	sp,sp,64
 ac0:	8082                	ret
 ac2:	7902                	ld	s2,32(sp)
 ac4:	6a42                	ld	s4,16(sp)
 ac6:	6aa2                	ld	s5,8(sp)
 ac8:	6b02                	ld	s6,0(sp)
 aca:	b7f5                	j	ab6 <malloc+0xe2>
