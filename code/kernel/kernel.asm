
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	25813103          	ld	sp,600(sp) # 8000a258 <_GLOBAL_OFFSET_TABLE_+0x8>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	03e000ef          	jal	80000054 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    80000022:	30a027f3          	csrr	a5,0x30a
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63));
    80000026:	577d                	li	a4,-1
    80000028:	177e                	slli	a4,a4,0x3f
    8000002a:	8fd9                	or	a5,a5,a4

static inline void
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    8000002c:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r"(x));
    80000030:	306027f3          	csrr	a5,mcounteren

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000034:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r"(x));
    80000038:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r"(x));
    8000003c:	c01027f3          	rdtime	a5

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80000040:	000f4737          	lui	a4,0xf4
    80000044:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000048:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000004a:	14d79073          	csrw	stimecmp,a5
}
    8000004e:	6422                	ld	s0,8(sp)
    80000050:	0141                	addi	sp,sp,16
    80000052:	8082                	ret

0000000080000054 <start>:
{
    80000054:	1141                	addi	sp,sp,-16
    80000056:	e406                	sd	ra,8(sp)
    80000058:	e022                	sd	s0,0(sp)
    8000005a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    8000005c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000060:	7779                	lui	a4,0xffffe
    80000062:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdac57>
    80000066:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000068:	6705                	lui	a4,0x1
    8000006a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000006e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80000074:	00001797          	auipc	a5,0x1
    80000078:	d8c78793          	addi	a5,a5,-628 # 80000e00 <main>
    8000007c:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80000080:	4781                	li	a5,0
    80000082:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    80000086:	67c1                	lui	a5,0x10
    80000088:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000008a:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    8000008e:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80000092:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80000096:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r"(x));
    8000009a:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    8000009e:	57fd                	li	a5,-1
    800000a0:	83a9                	srli	a5,a5,0xa
    800000a2:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000a6:	47bd                	li	a5,15
    800000a8:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000ac:	f71ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800000b0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000b4:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r"(x));
    800000b6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000b8:	30200073          	mret
}
    800000bc:	60a2                	ld	ra,8(sp)
    800000be:	6402                	ld	s0,0(sp)
    800000c0:	0141                	addi	sp,sp,16
    800000c2:	8082                	ret

00000000800000c4 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000c4:	7119                	addi	sp,sp,-128
    800000c6:	fc86                	sd	ra,120(sp)
    800000c8:	f8a2                	sd	s0,112(sp)
    800000ca:	f4a6                	sd	s1,104(sp)
    800000cc:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while (i < n) {
    800000ce:	06c05a63          	blez	a2,80000142 <consolewrite+0x7e>
    800000d2:	f0ca                	sd	s2,96(sp)
    800000d4:	ecce                	sd	s3,88(sp)
    800000d6:	e8d2                	sd	s4,80(sp)
    800000d8:	e4d6                	sd	s5,72(sp)
    800000da:	e0da                	sd	s6,64(sp)
    800000dc:	fc5e                	sd	s7,56(sp)
    800000de:	f862                	sd	s8,48(sp)
    800000e0:	f466                	sd	s9,40(sp)
    800000e2:	8aaa                	mv	s5,a0
    800000e4:	8b2e                	mv	s6,a1
    800000e6:	8a32                	mv	s4,a2
  int i = 0;
    800000e8:	4481                	li	s1,0
    int nn = sizeof(buf);
    if (nn > n - i)
    800000ea:	02000c13          	li	s8,32
    800000ee:	02000c93          	li	s9,32
      nn = n - i;
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    800000f2:	5bfd                	li	s7,-1
    800000f4:	a035                	j	80000120 <consolewrite+0x5c>
    if (nn > n - i)
    800000f6:	0009099b          	sext.w	s3,s2
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    800000fa:	86ce                	mv	a3,s3
    800000fc:	01648633          	add	a2,s1,s6
    80000100:	85d6                	mv	a1,s5
    80000102:	f8040513          	addi	a0,s0,-128
    80000106:	1f6020ef          	jal	800022fc <either_copyin>
    8000010a:	03750e63          	beq	a0,s7,80000146 <consolewrite+0x82>
      break;
    uartwrite(buf, nn);
    8000010e:	85ce                	mv	a1,s3
    80000110:	f8040513          	addi	a0,s0,-128
    80000114:	778000ef          	jal	8000088c <uartwrite>
    i += nn;
    80000118:	009904bb          	addw	s1,s2,s1
  while (i < n) {
    8000011c:	0144da63          	bge	s1,s4,80000130 <consolewrite+0x6c>
    if (nn > n - i)
    80000120:	409a093b          	subw	s2,s4,s1
    80000124:	0009079b          	sext.w	a5,s2
    80000128:	fcfc57e3          	bge	s8,a5,800000f6 <consolewrite+0x32>
    8000012c:	8966                	mv	s2,s9
    8000012e:	b7e1                	j	800000f6 <consolewrite+0x32>
    80000130:	7906                	ld	s2,96(sp)
    80000132:	69e6                	ld	s3,88(sp)
    80000134:	6a46                	ld	s4,80(sp)
    80000136:	6aa6                	ld	s5,72(sp)
    80000138:	6b06                	ld	s6,64(sp)
    8000013a:	7be2                	ld	s7,56(sp)
    8000013c:	7c42                	ld	s8,48(sp)
    8000013e:	7ca2                	ld	s9,40(sp)
    80000140:	a819                	j	80000156 <consolewrite+0x92>
  int i = 0;
    80000142:	4481                	li	s1,0
    80000144:	a809                	j	80000156 <consolewrite+0x92>
    80000146:	7906                	ld	s2,96(sp)
    80000148:	69e6                	ld	s3,88(sp)
    8000014a:	6a46                	ld	s4,80(sp)
    8000014c:	6aa6                	ld	s5,72(sp)
    8000014e:	6b06                	ld	s6,64(sp)
    80000150:	7be2                	ld	s7,56(sp)
    80000152:	7c42                	ld	s8,48(sp)
    80000154:	7ca2                	ld	s9,40(sp)
  }

  return i;
}
    80000156:	8526                	mv	a0,s1
    80000158:	70e6                	ld	ra,120(sp)
    8000015a:	7446                	ld	s0,112(sp)
    8000015c:	74a6                	ld	s1,104(sp)
    8000015e:	6109                	addi	sp,sp,128
    80000160:	8082                	ret

0000000080000162 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000162:	711d                	addi	sp,sp,-96
    80000164:	ec86                	sd	ra,88(sp)
    80000166:	e8a2                	sd	s0,80(sp)
    80000168:	e4a6                	sd	s1,72(sp)
    8000016a:	e0ca                	sd	s2,64(sp)
    8000016c:	fc4e                	sd	s3,56(sp)
    8000016e:	f852                	sd	s4,48(sp)
    80000170:	f456                	sd	s5,40(sp)
    80000172:	f05a                	sd	s6,32(sp)
    80000174:	1080                	addi	s0,sp,96
    80000176:	8aaa                	mv	s5,a0
    80000178:	8a2e                	mv	s4,a1
    8000017a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000017c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000180:	00012517          	auipc	a0,0x12
    80000184:	12050513          	addi	a0,a0,288 # 800122a0 <cons>
    80000188:	21b000ef          	jal	80000ba2 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    8000018c:	00012497          	auipc	s1,0x12
    80000190:	11448493          	addi	s1,s1,276 # 800122a0 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000194:	00012917          	auipc	s2,0x12
    80000198:	1a490913          	addi	s2,s2,420 # 80012338 <cons+0x98>
  while (n > 0) {
    8000019c:	0b305d63          	blez	s3,80000256 <consoleread+0xf4>
    while (cons.r == cons.w) {
    800001a0:	0984a783          	lw	a5,152(s1)
    800001a4:	09c4a703          	lw	a4,156(s1)
    800001a8:	0af71263          	bne	a4,a5,8000024c <consoleread+0xea>
      if (killed(myproc())) {
    800001ac:	6e6010ef          	jal	80001892 <myproc>
    800001b0:	7df010ef          	jal	8000218e <killed>
    800001b4:	e12d                	bnez	a0,80000216 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    800001b6:	85a6                	mv	a1,s1
    800001b8:	854a                	mv	a0,s2
    800001ba:	59d010ef          	jal	80001f56 <sleep>
    while (cons.r == cons.w) {
    800001be:	0984a783          	lw	a5,152(s1)
    800001c2:	09c4a703          	lw	a4,156(s1)
    800001c6:	fef703e3          	beq	a4,a5,800001ac <consoleread+0x4a>
    800001ca:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001cc:	00012717          	auipc	a4,0x12
    800001d0:	0d470713          	addi	a4,a4,212 # 800122a0 <cons>
    800001d4:	0017869b          	addiw	a3,a5,1
    800001d8:	08d72c23          	sw	a3,152(a4)
    800001dc:	07f7f693          	andi	a3,a5,127
    800001e0:	9736                	add	a4,a4,a3
    800001e2:	01874703          	lbu	a4,24(a4)
    800001e6:	00070b9b          	sext.w	s7,a4

    if (c == C('D')) { // end-of-file
    800001ea:	4691                	li	a3,4
    800001ec:	04db8663          	beq	s7,a3,80000238 <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001f0:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001f4:	4685                	li	a3,1
    800001f6:	faf40613          	addi	a2,s0,-81
    800001fa:	85d2                	mv	a1,s4
    800001fc:	8556                	mv	a0,s5
    800001fe:	0b4020ef          	jal	800022b2 <either_copyout>
    80000202:	57fd                	li	a5,-1
    80000204:	04f50863          	beq	a0,a5,80000254 <consoleread+0xf2>
      break;

    dst++;
    80000208:	0a05                	addi	s4,s4,1
    --n;
    8000020a:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    8000020c:	47a9                	li	a5,10
    8000020e:	04fb8d63          	beq	s7,a5,80000268 <consoleread+0x106>
    80000212:	6be2                	ld	s7,24(sp)
    80000214:	b761                	j	8000019c <consoleread+0x3a>
        release(&cons.lock);
    80000216:	00012517          	auipc	a0,0x12
    8000021a:	08a50513          	addi	a0,a0,138 # 800122a0 <cons>
    8000021e:	211000ef          	jal	80000c2e <release>
        return -1;
    80000222:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000224:	60e6                	ld	ra,88(sp)
    80000226:	6446                	ld	s0,80(sp)
    80000228:	64a6                	ld	s1,72(sp)
    8000022a:	6906                	ld	s2,64(sp)
    8000022c:	79e2                	ld	s3,56(sp)
    8000022e:	7a42                	ld	s4,48(sp)
    80000230:	7aa2                	ld	s5,40(sp)
    80000232:	7b02                	ld	s6,32(sp)
    80000234:	6125                	addi	sp,sp,96
    80000236:	8082                	ret
      if (n < target) {
    80000238:	0009871b          	sext.w	a4,s3
    8000023c:	01677a63          	bgeu	a4,s6,80000250 <consoleread+0xee>
        cons.r--;
    80000240:	00012717          	auipc	a4,0x12
    80000244:	0ef72c23          	sw	a5,248(a4) # 80012338 <cons+0x98>
    80000248:	6be2                	ld	s7,24(sp)
    8000024a:	a031                	j	80000256 <consoleread+0xf4>
    8000024c:	ec5e                	sd	s7,24(sp)
    8000024e:	bfbd                	j	800001cc <consoleread+0x6a>
    80000250:	6be2                	ld	s7,24(sp)
    80000252:	a011                	j	80000256 <consoleread+0xf4>
    80000254:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000256:	00012517          	auipc	a0,0x12
    8000025a:	04a50513          	addi	a0,a0,74 # 800122a0 <cons>
    8000025e:	1d1000ef          	jal	80000c2e <release>
  return target - n;
    80000262:	413b053b          	subw	a0,s6,s3
    80000266:	bf7d                	j	80000224 <consoleread+0xc2>
    80000268:	6be2                	ld	s7,24(sp)
    8000026a:	b7f5                	j	80000256 <consoleread+0xf4>

000000008000026c <consputc>:
{
    8000026c:	1141                	addi	sp,sp,-16
    8000026e:	e406                	sd	ra,8(sp)
    80000270:	e022                	sd	s0,0(sp)
    80000272:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80000274:	10000793          	li	a5,256
    80000278:	00f50863          	beq	a0,a5,80000288 <consputc+0x1c>
    uartputc_sync(c);
    8000027c:	6a4000ef          	jal	80000920 <uartputc_sync>
}
    80000280:	60a2                	ld	ra,8(sp)
    80000282:	6402                	ld	s0,0(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    uartputc_sync('\b');
    80000288:	4521                	li	a0,8
    8000028a:	696000ef          	jal	80000920 <uartputc_sync>
    uartputc_sync(' ');
    8000028e:	02000513          	li	a0,32
    80000292:	68e000ef          	jal	80000920 <uartputc_sync>
    uartputc_sync('\b');
    80000296:	4521                	li	a0,8
    80000298:	688000ef          	jal	80000920 <uartputc_sync>
    8000029c:	b7d5                	j	80000280 <consputc+0x14>

000000008000029e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000029e:	1101                	addi	sp,sp,-32
    800002a0:	ec06                	sd	ra,24(sp)
    800002a2:	e822                	sd	s0,16(sp)
    800002a4:	e426                	sd	s1,8(sp)
    800002a6:	1000                	addi	s0,sp,32
    800002a8:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002aa:	00012517          	auipc	a0,0x12
    800002ae:	ff650513          	addi	a0,a0,-10 # 800122a0 <cons>
    800002b2:	0f1000ef          	jal	80000ba2 <acquire>

  switch (c) {
    800002b6:	47d5                	li	a5,21
    800002b8:	08f48f63          	beq	s1,a5,80000356 <consoleintr+0xb8>
    800002bc:	0297c563          	blt	a5,s1,800002e6 <consoleintr+0x48>
    800002c0:	47a1                	li	a5,8
    800002c2:	0ef48463          	beq	s1,a5,800003aa <consoleintr+0x10c>
    800002c6:	47c1                	li	a5,16
    800002c8:	10f49563          	bne	s1,a5,800003d2 <consoleintr+0x134>
  case C('P'): // Print process list.
    procdump();
    800002cc:	07a020ef          	jal	80002346 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002d0:	00012517          	auipc	a0,0x12
    800002d4:	fd050513          	addi	a0,a0,-48 # 800122a0 <cons>
    800002d8:	157000ef          	jal	80000c2e <release>
}
    800002dc:	60e2                	ld	ra,24(sp)
    800002de:	6442                	ld	s0,16(sp)
    800002e0:	64a2                	ld	s1,8(sp)
    800002e2:	6105                	addi	sp,sp,32
    800002e4:	8082                	ret
  switch (c) {
    800002e6:	07f00793          	li	a5,127
    800002ea:	0cf48063          	beq	s1,a5,800003aa <consoleintr+0x10c>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800002ee:	00012717          	auipc	a4,0x12
    800002f2:	fb270713          	addi	a4,a4,-78 # 800122a0 <cons>
    800002f6:	0a072783          	lw	a5,160(a4)
    800002fa:	09872703          	lw	a4,152(a4)
    800002fe:	9f99                	subw	a5,a5,a4
    80000300:	07f00713          	li	a4,127
    80000304:	fcf766e3          	bltu	a4,a5,800002d0 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000308:	47b5                	li	a5,13
    8000030a:	0cf48763          	beq	s1,a5,800003d8 <consoleintr+0x13a>
      consputc(c);
    8000030e:	8526                	mv	a0,s1
    80000310:	f5dff0ef          	jal	8000026c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000314:	00012797          	auipc	a5,0x12
    80000318:	f8c78793          	addi	a5,a5,-116 # 800122a0 <cons>
    8000031c:	0a07a683          	lw	a3,160(a5)
    80000320:	0016871b          	addiw	a4,a3,1
    80000324:	0007061b          	sext.w	a2,a4
    80000328:	0ae7a023          	sw	a4,160(a5)
    8000032c:	07f6f693          	andi	a3,a3,127
    80000330:	97b6                	add	a5,a5,a3
    80000332:	00978c23          	sb	s1,24(a5)
      if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80000336:	47a9                	li	a5,10
    80000338:	0cf48563          	beq	s1,a5,80000402 <consoleintr+0x164>
    8000033c:	4791                	li	a5,4
    8000033e:	0cf48263          	beq	s1,a5,80000402 <consoleintr+0x164>
    80000342:	00012797          	auipc	a5,0x12
    80000346:	ff67a783          	lw	a5,-10(a5) # 80012338 <cons+0x98>
    8000034a:	9f1d                	subw	a4,a4,a5
    8000034c:	08000793          	li	a5,128
    80000350:	f8f710e3          	bne	a4,a5,800002d0 <consoleintr+0x32>
    80000354:	a07d                	j	80000402 <consoleintr+0x164>
    80000356:	e04a                	sd	s2,0(sp)
    while (cons.e != cons.w &&
    80000358:	00012717          	auipc	a4,0x12
    8000035c:	f4870713          	addi	a4,a4,-184 # 800122a0 <cons>
    80000360:	0a072783          	lw	a5,160(a4)
    80000364:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000368:	00012497          	auipc	s1,0x12
    8000036c:	f3848493          	addi	s1,s1,-200 # 800122a0 <cons>
    while (cons.e != cons.w &&
    80000370:	4929                	li	s2,10
    80000372:	02f70863          	beq	a4,a5,800003a2 <consoleintr+0x104>
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000376:	37fd                	addiw	a5,a5,-1
    80000378:	07f7f713          	andi	a4,a5,127
    8000037c:	9726                	add	a4,a4,s1
    while (cons.e != cons.w &&
    8000037e:	01874703          	lbu	a4,24(a4)
    80000382:	03270263          	beq	a4,s2,800003a6 <consoleintr+0x108>
      cons.e--;
    80000386:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000038a:	10000513          	li	a0,256
    8000038e:	edfff0ef          	jal	8000026c <consputc>
    while (cons.e != cons.w &&
    80000392:	0a04a783          	lw	a5,160(s1)
    80000396:	09c4a703          	lw	a4,156(s1)
    8000039a:	fcf71ee3          	bne	a4,a5,80000376 <consoleintr+0xd8>
    8000039e:	6902                	ld	s2,0(sp)
    800003a0:	bf05                	j	800002d0 <consoleintr+0x32>
    800003a2:	6902                	ld	s2,0(sp)
    800003a4:	b735                	j	800002d0 <consoleintr+0x32>
    800003a6:	6902                	ld	s2,0(sp)
    800003a8:	b725                	j	800002d0 <consoleintr+0x32>
    if (cons.e != cons.w) {
    800003aa:	00012717          	auipc	a4,0x12
    800003ae:	ef670713          	addi	a4,a4,-266 # 800122a0 <cons>
    800003b2:	0a072783          	lw	a5,160(a4)
    800003b6:	09c72703          	lw	a4,156(a4)
    800003ba:	f0f70be3          	beq	a4,a5,800002d0 <consoleintr+0x32>
      cons.e--;
    800003be:	37fd                	addiw	a5,a5,-1
    800003c0:	00012717          	auipc	a4,0x12
    800003c4:	f8f72023          	sw	a5,-128(a4) # 80012340 <cons+0xa0>
      consputc(BACKSPACE);
    800003c8:	10000513          	li	a0,256
    800003cc:	ea1ff0ef          	jal	8000026c <consputc>
    800003d0:	b701                	j	800002d0 <consoleintr+0x32>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800003d2:	ee048fe3          	beqz	s1,800002d0 <consoleintr+0x32>
    800003d6:	bf21                	j	800002ee <consoleintr+0x50>
      consputc(c);
    800003d8:	4529                	li	a0,10
    800003da:	e93ff0ef          	jal	8000026c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003de:	00012797          	auipc	a5,0x12
    800003e2:	ec278793          	addi	a5,a5,-318 # 800122a0 <cons>
    800003e6:	0a07a703          	lw	a4,160(a5)
    800003ea:	0017069b          	addiw	a3,a4,1
    800003ee:	0006861b          	sext.w	a2,a3
    800003f2:	0ad7a023          	sw	a3,160(a5)
    800003f6:	07f77713          	andi	a4,a4,127
    800003fa:	97ba                	add	a5,a5,a4
    800003fc:	4729                	li	a4,10
    800003fe:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000402:	00012797          	auipc	a5,0x12
    80000406:	f2c7ad23          	sw	a2,-198(a5) # 8001233c <cons+0x9c>
        wakeup(&cons.r);
    8000040a:	00012517          	auipc	a0,0x12
    8000040e:	f2e50513          	addi	a0,a0,-210 # 80012338 <cons+0x98>
    80000412:	391010ef          	jal	80001fa2 <wakeup>
    80000416:	bd6d                	j	800002d0 <consoleintr+0x32>

0000000080000418 <consoleinit>:

void
consoleinit(void)
{
    80000418:	1141                	addi	sp,sp,-16
    8000041a:	e406                	sd	ra,8(sp)
    8000041c:	e022                	sd	s0,0(sp)
    8000041e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000420:	00007597          	auipc	a1,0x7
    80000424:	be058593          	addi	a1,a1,-1056 # 80007000 <etext>
    80000428:	00012517          	auipc	a0,0x12
    8000042c:	e7850513          	addi	a0,a0,-392 # 800122a0 <cons>
    80000430:	6fc000ef          	jal	80000b2c <initlock>

  uartinit();
    80000434:	400000ef          	jal	80000834 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000438:	00022797          	auipc	a5,0x22
    8000043c:	5d878793          	addi	a5,a5,1496 # 80022a10 <devsw>
    80000440:	00000717          	auipc	a4,0x0
    80000444:	d2270713          	addi	a4,a4,-734 # 80000162 <consoleread>
    80000448:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000044a:	00000717          	auipc	a4,0x0
    8000044e:	c7a70713          	addi	a4,a4,-902 # 800000c4 <consolewrite>
    80000452:	ef98                	sd	a4,24(a5)
}
    80000454:	60a2                	ld	ra,8(sp)
    80000456:	6402                	ld	s0,0(sp)
    80000458:	0141                	addi	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000045c:	7139                	addi	sp,sp,-64
    8000045e:	fc06                	sd	ra,56(sp)
    80000460:	f822                	sd	s0,48(sp)
    80000462:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if (sign && (sign = (xx < 0)))
    80000464:	c219                	beqz	a2,8000046a <printint+0xe>
    80000466:	08054063          	bltz	a0,800004e6 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000046a:	4881                	li	a7,0
    8000046c:	fc840693          	addi	a3,s0,-56

  i = 0;
    80000470:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000472:	00007617          	auipc	a2,0x7
    80000476:	29e60613          	addi	a2,a2,670 # 80007710 <digits>
    8000047a:	883e                	mv	a6,a5
    8000047c:	2785                	addiw	a5,a5,1
    8000047e:	02b57733          	remu	a4,a0,a1
    80000482:	9732                	add	a4,a4,a2
    80000484:	00074703          	lbu	a4,0(a4)
    80000488:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
    8000048c:	872a                	mv	a4,a0
    8000048e:	02b55533          	divu	a0,a0,a1
    80000492:	0685                	addi	a3,a3,1
    80000494:	feb773e3          	bgeu	a4,a1,8000047a <printint+0x1e>

  if (sign)
    80000498:	00088a63          	beqz	a7,800004ac <printint+0x50>
    buf[i++] = '-';
    8000049c:	1781                	addi	a5,a5,-32
    8000049e:	97a2                	add	a5,a5,s0
    800004a0:	02d00713          	li	a4,45
    800004a4:	fee78423          	sb	a4,-24(a5)
    800004a8:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
    800004ac:	02f05963          	blez	a5,800004de <printint+0x82>
    800004b0:	f426                	sd	s1,40(sp)
    800004b2:	f04a                	sd	s2,32(sp)
    800004b4:	fc840713          	addi	a4,s0,-56
    800004b8:	00f704b3          	add	s1,a4,a5
    800004bc:	fff70913          	addi	s2,a4,-1
    800004c0:	993e                	add	s2,s2,a5
    800004c2:	37fd                	addiw	a5,a5,-1
    800004c4:	1782                	slli	a5,a5,0x20
    800004c6:	9381                	srli	a5,a5,0x20
    800004c8:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004cc:	fff4c503          	lbu	a0,-1(s1)
    800004d0:	d9dff0ef          	jal	8000026c <consputc>
  while (--i >= 0)
    800004d4:	14fd                	addi	s1,s1,-1
    800004d6:	ff249be3          	bne	s1,s2,800004cc <printint+0x70>
    800004da:	74a2                	ld	s1,40(sp)
    800004dc:	7902                	ld	s2,32(sp)
}
    800004de:	70e2                	ld	ra,56(sp)
    800004e0:	7442                	ld	s0,48(sp)
    800004e2:	6121                	addi	sp,sp,64
    800004e4:	8082                	ret
    x = -xx;
    800004e6:	40a00533          	neg	a0,a0
  if (sign && (sign = (xx < 0)))
    800004ea:	4885                	li	a7,1
    x = -xx;
    800004ec:	b741                	j	8000046c <printint+0x10>

00000000800004ee <printk>:
}

// Print to the console.
int
printk(char *fmt, ...)
{
    800004ee:	7131                	addi	sp,sp,-192
    800004f0:	fc86                	sd	ra,120(sp)
    800004f2:	f8a2                	sd	s0,112(sp)
    800004f4:	e8d2                	sd	s4,80(sp)
    800004f6:	0100                	addi	s0,sp,128
    800004f8:	8a2a                	mv	s4,a0
    800004fa:	e40c                	sd	a1,8(s0)
    800004fc:	e810                	sd	a2,16(s0)
    800004fe:	ec14                	sd	a3,24(s0)
    80000500:	f018                	sd	a4,32(s0)
    80000502:	f41c                	sd	a5,40(s0)
    80000504:	03043823          	sd	a6,48(s0)
    80000508:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if (panicking == 0)
    8000050c:	0000a797          	auipc	a5,0xa
    80000510:	d687a783          	lw	a5,-664(a5) # 8000a274 <panicking>
    80000514:	c3a1                	beqz	a5,80000554 <printk+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000516:	00840793          	addi	a5,s0,8
    8000051a:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    8000051e:	000a4503          	lbu	a0,0(s4)
    80000522:	28050763          	beqz	a0,800007b0 <printk+0x2c2>
    80000526:	f4a6                	sd	s1,104(sp)
    80000528:	f0ca                	sd	s2,96(sp)
    8000052a:	ecce                	sd	s3,88(sp)
    8000052c:	e4d6                	sd	s5,72(sp)
    8000052e:	e0da                	sd	s6,64(sp)
    80000530:	f862                	sd	s8,48(sp)
    80000532:	f466                	sd	s9,40(sp)
    80000534:	f06a                	sd	s10,32(sp)
    80000536:	ec6e                	sd	s11,24(sp)
    80000538:	4981                	li	s3,0
    if (cx != '%') {
    8000053a:	02500a93          	li	s5,37
    c1 = c2 = 0;
    if (c0)
      c1 = fmt[i + 1] & 0xff;
    if (c1)
      c2 = fmt[i + 2] & 0xff;
    if (c0 == 'd') {
    8000053e:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if (c0 == 'l' && c1 == 'd') {
    80000542:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if (c0 == 'u') {
    80000546:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if (c0 == 'x') {
    8000054a:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if (c0 == 'p') {
    8000054e:	07000d93          	li	s11,112
    80000552:	a01d                	j	80000578 <printk+0x8a>
    acquire(&pr.lock);
    80000554:	00012517          	auipc	a0,0x12
    80000558:	df450513          	addi	a0,a0,-524 # 80012348 <pr>
    8000055c:	646000ef          	jal	80000ba2 <acquire>
    80000560:	bf5d                	j	80000516 <printk+0x28>
      consputc(cx);
    80000562:	d0bff0ef          	jal	8000026c <consputc>
      continue;
    80000566:	84ce                	mv	s1,s3
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000568:	0014899b          	addiw	s3,s1,1
    8000056c:	013a07b3          	add	a5,s4,s3
    80000570:	0007c503          	lbu	a0,0(a5)
    80000574:	20050b63          	beqz	a0,8000078a <printk+0x29c>
    if (cx != '%') {
    80000578:	ff5515e3          	bne	a0,s5,80000562 <printk+0x74>
    i++;
    8000057c:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i + 0] & 0xff;
    80000580:	009a07b3          	add	a5,s4,s1
    80000584:	0007c903          	lbu	s2,0(a5)
    if (c0)
    80000588:	20090b63          	beqz	s2,8000079e <printk+0x2b0>
      c1 = fmt[i + 1] & 0xff;
    8000058c:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000590:	86be                	mv	a3,a5
    if (c1)
    80000592:	c789                	beqz	a5,8000059c <printk+0xae>
      c2 = fmt[i + 2] & 0xff;
    80000594:	009a0733          	add	a4,s4,s1
    80000598:	00274683          	lbu	a3,2(a4)
    if (c0 == 'd') {
    8000059c:	03690963          	beq	s2,s6,800005ce <printk+0xe0>
    } else if (c0 == 'l' && c1 == 'd') {
    800005a0:	05890363          	beq	s2,s8,800005e6 <printk+0xf8>
    } else if (c0 == 'u') {
    800005a4:	0d990663          	beq	s2,s9,80000670 <printk+0x182>
    } else if (c0 == 'x') {
    800005a8:	11a90d63          	beq	s2,s10,800006c2 <printk+0x1d4>
    } else if (c0 == 'p') {
    800005ac:	15b90663          	beq	s2,s11,800006f8 <printk+0x20a>
      printptr(va_arg(ap, uint64));
    } else if (c0 == 'c') {
    800005b0:	06300793          	li	a5,99
    800005b4:	18f90563          	beq	s2,a5,8000073e <printk+0x250>
      consputc(va_arg(ap, uint));
    } else if (c0 == 's') {
    800005b8:	07300793          	li	a5,115
    800005bc:	18f90b63          	beq	s2,a5,80000752 <printk+0x264>
      if ((s = va_arg(ap, char *)) == 0)
        s = "(null)";
      for (; *s; s++)
        consputc(*s);
    } else if (c0 == '%') {
    800005c0:	03591b63          	bne	s2,s5,800005f6 <printk+0x108>
      consputc('%');
    800005c4:	02500513          	li	a0,37
    800005c8:	ca5ff0ef          	jal	8000026c <consputc>
    800005cc:	bf71                	j	80000568 <printk+0x7a>
      printint(va_arg(ap, int), 10, 1);
    800005ce:	f8843783          	ld	a5,-120(s0)
    800005d2:	00878713          	addi	a4,a5,8
    800005d6:	f8e43423          	sd	a4,-120(s0)
    800005da:	4605                	li	a2,1
    800005dc:	45a9                	li	a1,10
    800005de:	4388                	lw	a0,0(a5)
    800005e0:	e7dff0ef          	jal	8000045c <printint>
    800005e4:	b751                	j	80000568 <printk+0x7a>
    } else if (c0 == 'l' && c1 == 'd') {
    800005e6:	01678f63          	beq	a5,s6,80000604 <printk+0x116>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800005ea:	03878b63          	beq	a5,s8,80000620 <printk+0x132>
    } else if (c0 == 'l' && c1 == 'u') {
    800005ee:	09978e63          	beq	a5,s9,8000068a <printk+0x19c>
    } else if (c0 == 'l' && c1 == 'x') {
    800005f2:	0fa78563          	beq	a5,s10,800006dc <printk+0x1ee>
    } else if (c0 == 0) {
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005f6:	8556                	mv	a0,s5
    800005f8:	c75ff0ef          	jal	8000026c <consputc>
      consputc(c0);
    800005fc:	854a                	mv	a0,s2
    800005fe:	c6fff0ef          	jal	8000026c <consputc>
    80000602:	b79d                	j	80000568 <printk+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80000604:	f8843783          	ld	a5,-120(s0)
    80000608:	00878713          	addi	a4,a5,8
    8000060c:	f8e43423          	sd	a4,-120(s0)
    80000610:	4605                	li	a2,1
    80000612:	45a9                	li	a1,10
    80000614:	6388                	ld	a0,0(a5)
    80000616:	e47ff0ef          	jal	8000045c <printint>
      i += 1;
    8000061a:	0029849b          	addiw	s1,s3,2
    8000061e:	b7a9                	j	80000568 <printk+0x7a>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    80000620:	06400793          	li	a5,100
    80000624:	02f68863          	beq	a3,a5,80000654 <printk+0x166>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    80000628:	07500793          	li	a5,117
    8000062c:	06f68d63          	beq	a3,a5,800006a6 <printk+0x1b8>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    80000630:	07800793          	li	a5,120
    80000634:	fcf691e3          	bne	a3,a5,800005f6 <printk+0x108>
      printint(va_arg(ap, uint64), 16, 0);
    80000638:	f8843783          	ld	a5,-120(s0)
    8000063c:	00878713          	addi	a4,a5,8
    80000640:	f8e43423          	sd	a4,-120(s0)
    80000644:	4601                	li	a2,0
    80000646:	45c1                	li	a1,16
    80000648:	6388                	ld	a0,0(a5)
    8000064a:	e13ff0ef          	jal	8000045c <printint>
      i += 2;
    8000064e:	0039849b          	addiw	s1,s3,3
    80000652:	bf19                	j	80000568 <printk+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80000654:	f8843783          	ld	a5,-120(s0)
    80000658:	00878713          	addi	a4,a5,8
    8000065c:	f8e43423          	sd	a4,-120(s0)
    80000660:	4605                	li	a2,1
    80000662:	45a9                	li	a1,10
    80000664:	6388                	ld	a0,0(a5)
    80000666:	df7ff0ef          	jal	8000045c <printint>
      i += 2;
    8000066a:	0039849b          	addiw	s1,s3,3
    8000066e:	bded                	j	80000568 <printk+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    80000670:	f8843783          	ld	a5,-120(s0)
    80000674:	00878713          	addi	a4,a5,8
    80000678:	f8e43423          	sd	a4,-120(s0)
    8000067c:	4601                	li	a2,0
    8000067e:	45a9                	li	a1,10
    80000680:	0007e503          	lwu	a0,0(a5)
    80000684:	dd9ff0ef          	jal	8000045c <printint>
    80000688:	b5c5                	j	80000568 <printk+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    8000068a:	f8843783          	ld	a5,-120(s0)
    8000068e:	00878713          	addi	a4,a5,8
    80000692:	f8e43423          	sd	a4,-120(s0)
    80000696:	4601                	li	a2,0
    80000698:	45a9                	li	a1,10
    8000069a:	6388                	ld	a0,0(a5)
    8000069c:	dc1ff0ef          	jal	8000045c <printint>
      i += 1;
    800006a0:	0029849b          	addiw	s1,s3,2
    800006a4:	b5d1                	j	80000568 <printk+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800006a6:	f8843783          	ld	a5,-120(s0)
    800006aa:	00878713          	addi	a4,a5,8
    800006ae:	f8e43423          	sd	a4,-120(s0)
    800006b2:	4601                	li	a2,0
    800006b4:	45a9                	li	a1,10
    800006b6:	6388                	ld	a0,0(a5)
    800006b8:	da5ff0ef          	jal	8000045c <printint>
      i += 2;
    800006bc:	0039849b          	addiw	s1,s3,3
    800006c0:	b565                	j	80000568 <printk+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    800006c2:	f8843783          	ld	a5,-120(s0)
    800006c6:	00878713          	addi	a4,a5,8
    800006ca:	f8e43423          	sd	a4,-120(s0)
    800006ce:	4601                	li	a2,0
    800006d0:	45c1                	li	a1,16
    800006d2:	0007e503          	lwu	a0,0(a5)
    800006d6:	d87ff0ef          	jal	8000045c <printint>
    800006da:	b579                	j	80000568 <printk+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    800006dc:	f8843783          	ld	a5,-120(s0)
    800006e0:	00878713          	addi	a4,a5,8
    800006e4:	f8e43423          	sd	a4,-120(s0)
    800006e8:	4601                	li	a2,0
    800006ea:	45c1                	li	a1,16
    800006ec:	6388                	ld	a0,0(a5)
    800006ee:	d6fff0ef          	jal	8000045c <printint>
      i += 1;
    800006f2:	0029849b          	addiw	s1,s3,2
    800006f6:	bd8d                	j	80000568 <printk+0x7a>
    800006f8:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    800006fa:	f8843783          	ld	a5,-120(s0)
    800006fe:	00878713          	addi	a4,a5,8
    80000702:	f8e43423          	sd	a4,-120(s0)
    80000706:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000070a:	03000513          	li	a0,48
    8000070e:	b5fff0ef          	jal	8000026c <consputc>
  consputc('x');
    80000712:	07800513          	li	a0,120
    80000716:	b57ff0ef          	jal	8000026c <consputc>
    8000071a:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000071c:	00007b97          	auipc	s7,0x7
    80000720:	ff4b8b93          	addi	s7,s7,-12 # 80007710 <digits>
    80000724:	03c9d793          	srli	a5,s3,0x3c
    80000728:	97de                	add	a5,a5,s7
    8000072a:	0007c503          	lbu	a0,0(a5)
    8000072e:	b3fff0ef          	jal	8000026c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000732:	0992                	slli	s3,s3,0x4
    80000734:	397d                	addiw	s2,s2,-1
    80000736:	fe0917e3          	bnez	s2,80000724 <printk+0x236>
    8000073a:	7be2                	ld	s7,56(sp)
    8000073c:	b535                	j	80000568 <printk+0x7a>
      consputc(va_arg(ap, uint));
    8000073e:	f8843783          	ld	a5,-120(s0)
    80000742:	00878713          	addi	a4,a5,8
    80000746:	f8e43423          	sd	a4,-120(s0)
    8000074a:	4388                	lw	a0,0(a5)
    8000074c:	b21ff0ef          	jal	8000026c <consputc>
    80000750:	bd21                	j	80000568 <printk+0x7a>
      if ((s = va_arg(ap, char *)) == 0)
    80000752:	f8843783          	ld	a5,-120(s0)
    80000756:	00878713          	addi	a4,a5,8
    8000075a:	f8e43423          	sd	a4,-120(s0)
    8000075e:	0007b903          	ld	s2,0(a5)
    80000762:	00090d63          	beqz	s2,8000077c <printk+0x28e>
      for (; *s; s++)
    80000766:	00094503          	lbu	a0,0(s2)
    8000076a:	de050fe3          	beqz	a0,80000568 <printk+0x7a>
        consputc(*s);
    8000076e:	affff0ef          	jal	8000026c <consputc>
      for (; *s; s++)
    80000772:	0905                	addi	s2,s2,1
    80000774:	00094503          	lbu	a0,0(s2)
    80000778:	f97d                	bnez	a0,8000076e <printk+0x280>
    8000077a:	b3fd                	j	80000568 <printk+0x7a>
        s = "(null)";
    8000077c:	00007917          	auipc	s2,0x7
    80000780:	88c90913          	addi	s2,s2,-1908 # 80007008 <etext+0x8>
      for (; *s; s++)
    80000784:	02800513          	li	a0,40
    80000788:	b7dd                	j	8000076e <printk+0x280>
    8000078a:	74a6                	ld	s1,104(sp)
    8000078c:	7906                	ld	s2,96(sp)
    8000078e:	69e6                	ld	s3,88(sp)
    80000790:	6aa6                	ld	s5,72(sp)
    80000792:	6b06                	ld	s6,64(sp)
    80000794:	7c42                	ld	s8,48(sp)
    80000796:	7ca2                	ld	s9,40(sp)
    80000798:	7d02                	ld	s10,32(sp)
    8000079a:	6de2                	ld	s11,24(sp)
    8000079c:	a811                	j	800007b0 <printk+0x2c2>
    8000079e:	74a6                	ld	s1,104(sp)
    800007a0:	7906                	ld	s2,96(sp)
    800007a2:	69e6                	ld	s3,88(sp)
    800007a4:	6aa6                	ld	s5,72(sp)
    800007a6:	6b06                	ld	s6,64(sp)
    800007a8:	7c42                	ld	s8,48(sp)
    800007aa:	7ca2                	ld	s9,40(sp)
    800007ac:	7d02                	ld	s10,32(sp)
    800007ae:	6de2                	ld	s11,24(sp)
    }
  }
  va_end(ap);

  if (panicking == 0)
    800007b0:	0000a797          	auipc	a5,0xa
    800007b4:	ac47a783          	lw	a5,-1340(a5) # 8000a274 <panicking>
    800007b8:	c799                	beqz	a5,800007c6 <printk+0x2d8>
    release(&pr.lock);

  return 0;
}
    800007ba:	4501                	li	a0,0
    800007bc:	70e6                	ld	ra,120(sp)
    800007be:	7446                	ld	s0,112(sp)
    800007c0:	6a46                	ld	s4,80(sp)
    800007c2:	6129                	addi	sp,sp,192
    800007c4:	8082                	ret
    release(&pr.lock);
    800007c6:	00012517          	auipc	a0,0x12
    800007ca:	b8250513          	addi	a0,a0,-1150 # 80012348 <pr>
    800007ce:	460000ef          	jal	80000c2e <release>
  return 0;
    800007d2:	b7e5                	j	800007ba <printk+0x2cc>

00000000800007d4 <panic>:

void
panic(char *s)
{
    800007d4:	1101                	addi	sp,sp,-32
    800007d6:	ec06                	sd	ra,24(sp)
    800007d8:	e822                	sd	s0,16(sp)
    800007da:	e426                	sd	s1,8(sp)
    800007dc:	e04a                	sd	s2,0(sp)
    800007de:	1000                	addi	s0,sp,32
    800007e0:	84aa                	mv	s1,a0
  panicking = 1;
    800007e2:	4905                	li	s2,1
    800007e4:	0000a797          	auipc	a5,0xa
    800007e8:	a927a823          	sw	s2,-1392(a5) # 8000a274 <panicking>
  printk("panic: ");
    800007ec:	00007517          	auipc	a0,0x7
    800007f0:	82c50513          	addi	a0,a0,-2004 # 80007018 <etext+0x18>
    800007f4:	cfbff0ef          	jal	800004ee <printk>
  printk("%s\n", s);
    800007f8:	85a6                	mv	a1,s1
    800007fa:	00007517          	auipc	a0,0x7
    800007fe:	82650513          	addi	a0,a0,-2010 # 80007020 <etext+0x20>
    80000802:	cedff0ef          	jal	800004ee <printk>
  panicked = 1; // freeze uart output from other CPUs
    80000806:	0000a797          	auipc	a5,0xa
    8000080a:	a727a523          	sw	s2,-1430(a5) # 8000a270 <panicked>
  for (;;)
    8000080e:	a001                	j	8000080e <panic+0x3a>

0000000080000810 <printkinit>:
    ;
}

void
printkinit(void)
{
    80000810:	1141                	addi	sp,sp,-16
    80000812:	e406                	sd	ra,8(sp)
    80000814:	e022                	sd	s0,0(sp)
    80000816:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000818:	00007597          	auipc	a1,0x7
    8000081c:	81058593          	addi	a1,a1,-2032 # 80007028 <etext+0x28>
    80000820:	00012517          	auipc	a0,0x12
    80000824:	b2850513          	addi	a0,a0,-1240 # 80012348 <pr>
    80000828:	304000ef          	jal	80000b2c <initlock>
}
    8000082c:	60a2                	ld	ra,8(sp)
    8000082e:	6402                	ld	s0,0(sp)
    80000830:	0141                	addi	sp,sp,16
    80000832:	8082                	ret

0000000080000834 <uartinit>:
extern volatile int panicking; // from printk.c
extern volatile int panicked;  // from printk.c

void
uartinit(void)
{
    80000834:	1141                	addi	sp,sp,-16
    80000836:	e406                	sd	ra,8(sp)
    80000838:	e022                	sd	s0,0(sp)
    8000083a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000083c:	100007b7          	lui	a5,0x10000
    80000840:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000844:	10000737          	lui	a4,0x10000
    80000848:	f8000693          	li	a3,-128
    8000084c:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000850:	468d                	li	a3,3
    80000852:	10000637          	lui	a2,0x10000
    80000856:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000085a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000085e:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000862:	10000737          	lui	a4,0x10000
    80000866:	461d                	li	a2,7
    80000868:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000086c:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    80000870:	00006597          	auipc	a1,0x6
    80000874:	7c058593          	addi	a1,a1,1984 # 80007030 <etext+0x30>
    80000878:	00012517          	auipc	a0,0x12
    8000087c:	ae850513          	addi	a0,a0,-1304 # 80012360 <tx_lock>
    80000880:	2ac000ef          	jal	80000b2c <initlock>
}
    80000884:	60a2                	ld	ra,8(sp)
    80000886:	6402                	ld	s0,0(sp)
    80000888:	0141                	addi	sp,sp,16
    8000088a:	8082                	ret

000000008000088c <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    8000088c:	715d                	addi	sp,sp,-80
    8000088e:	e486                	sd	ra,72(sp)
    80000890:	e0a2                	sd	s0,64(sp)
    80000892:	fc26                	sd	s1,56(sp)
    80000894:	ec56                	sd	s5,24(sp)
    80000896:	0880                	addi	s0,sp,80
    80000898:	8aaa                	mv	s5,a0
    8000089a:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    8000089c:	00012517          	auipc	a0,0x12
    800008a0:	ac450513          	addi	a0,a0,-1340 # 80012360 <tx_lock>
    800008a4:	2fe000ef          	jal	80000ba2 <acquire>

  int i = 0;
  while (i < n) {
    800008a8:	06905063          	blez	s1,80000908 <uartwrite+0x7c>
    800008ac:	f84a                	sd	s2,48(sp)
    800008ae:	f44e                	sd	s3,40(sp)
    800008b0:	f052                	sd	s4,32(sp)
    800008b2:	e85a                	sd	s6,16(sp)
    800008b4:	e45e                	sd	s7,8(sp)
    800008b6:	8a56                	mv	s4,s5
    800008b8:	9aa6                	add	s5,s5,s1
    while (tx_busy != 0) {
    800008ba:	0000a497          	auipc	s1,0xa
    800008be:	9c248493          	addi	s1,s1,-1598 # 8000a27c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    800008c2:	00012997          	auipc	s3,0x12
    800008c6:	a9e98993          	addi	s3,s3,-1378 # 80012360 <tx_lock>
    800008ca:	0000a917          	auipc	s2,0xa
    800008ce:	9ae90913          	addi	s2,s2,-1618 # 8000a278 <tx_chan>
    }

    WriteReg(THR, buf[i]);
    800008d2:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    800008d6:	4b05                	li	s6,1
    800008d8:	a005                	j	800008f8 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    800008da:	85ce                	mv	a1,s3
    800008dc:	854a                	mv	a0,s2
    800008de:	678010ef          	jal	80001f56 <sleep>
    while (tx_busy != 0) {
    800008e2:	409c                	lw	a5,0(s1)
    800008e4:	fbfd                	bnez	a5,800008da <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    800008e6:	000a4783          	lbu	a5,0(s4)
    800008ea:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    800008ee:	0164a023          	sw	s6,0(s1)
  while (i < n) {
    800008f2:	0a05                	addi	s4,s4,1
    800008f4:	015a0563          	beq	s4,s5,800008fe <uartwrite+0x72>
    while (tx_busy != 0) {
    800008f8:	409c                	lw	a5,0(s1)
    800008fa:	f3e5                	bnez	a5,800008da <uartwrite+0x4e>
    800008fc:	b7ed                	j	800008e6 <uartwrite+0x5a>
    800008fe:	7942                	ld	s2,48(sp)
    80000900:	79a2                	ld	s3,40(sp)
    80000902:	7a02                	ld	s4,32(sp)
    80000904:	6b42                	ld	s6,16(sp)
    80000906:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80000908:	00012517          	auipc	a0,0x12
    8000090c:	a5850513          	addi	a0,a0,-1448 # 80012360 <tx_lock>
    80000910:	31e000ef          	jal	80000c2e <release>
}
    80000914:	60a6                	ld	ra,72(sp)
    80000916:	6406                	ld	s0,64(sp)
    80000918:	74e2                	ld	s1,56(sp)
    8000091a:	6ae2                	ld	s5,24(sp)
    8000091c:	6161                	addi	sp,sp,80
    8000091e:	8082                	ret

0000000080000920 <uartputc_sync>:
// interrupts, for use by kernel printk() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000920:	1101                	addi	sp,sp,-32
    80000922:	ec06                	sd	ra,24(sp)
    80000924:	e822                	sd	s0,16(sp)
    80000926:	e426                	sd	s1,8(sp)
    80000928:	1000                	addi	s0,sp,32
    8000092a:	84aa                	mv	s1,a0
  if (panicking == 0)
    8000092c:	0000a797          	auipc	a5,0xa
    80000930:	9487a783          	lw	a5,-1720(a5) # 8000a274 <panicking>
    80000934:	cf95                	beqz	a5,80000970 <uartputc_sync+0x50>
    push_off();

  if (panicked) {
    80000936:	0000a797          	auipc	a5,0xa
    8000093a:	93a7a783          	lw	a5,-1734(a5) # 8000a270 <panicked>
    8000093e:	ef85                	bnez	a5,80000976 <uartputc_sync+0x56>
    for (;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000940:	10000737          	lui	a4,0x10000
    80000944:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000946:	00074783          	lbu	a5,0(a4)
    8000094a:	0207f793          	andi	a5,a5,32
    8000094e:	dfe5                	beqz	a5,80000946 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80000950:	0ff4f513          	zext.b	a0,s1
    80000954:	100007b7          	lui	a5,0x10000
    80000958:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if (panicking == 0)
    8000095c:	0000a797          	auipc	a5,0xa
    80000960:	9187a783          	lw	a5,-1768(a5) # 8000a274 <panicking>
    80000964:	cb91                	beqz	a5,80000978 <uartputc_sync+0x58>
    pop_off();
}
    80000966:	60e2                	ld	ra,24(sp)
    80000968:	6442                	ld	s0,16(sp)
    8000096a:	64a2                	ld	s1,8(sp)
    8000096c:	6105                	addi	sp,sp,32
    8000096e:	8082                	ret
    push_off();
    80000970:	1fc000ef          	jal	80000b6c <push_off>
    80000974:	b7c9                	j	80000936 <uartputc_sync+0x16>
    for (;;)
    80000976:	a001                	j	80000976 <uartputc_sync+0x56>
    pop_off();
    80000978:	26a000ef          	jal	80000be2 <pop_off>
}
    8000097c:	b7ed                	j	80000966 <uartputc_sync+0x46>

000000008000097e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000097e:	1101                	addi	sp,sp,-32
    80000980:	ec06                	sd	ra,24(sp)
    80000982:	e822                	sd	s0,16(sp)
    80000984:	e426                	sd	s1,8(sp)
    80000986:	e04a                	sd	s2,0(sp)
    80000988:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    8000098a:	100007b7          	lui	a5,0x10000
    8000098e:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000990:	0007c783          	lbu	a5,0(a5)

  acquire(&tx_lock);
    80000994:	00012517          	auipc	a0,0x12
    80000998:	9cc50513          	addi	a0,a0,-1588 # 80012360 <tx_lock>
    8000099c:	206000ef          	jal	80000ba2 <acquire>
  if (ReadReg(LSR) & LSR_TX_IDLE) {
    800009a0:	100007b7          	lui	a5,0x10000
    800009a4:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009a6:	0007c783          	lbu	a5,0(a5)
    800009aa:	0207f793          	andi	a5,a5,32
    800009ae:	e78d                	bnez	a5,800009d8 <uartintr+0x5a>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    800009b0:	00012517          	auipc	a0,0x12
    800009b4:	9b050513          	addi	a0,a0,-1616 # 80012360 <tx_lock>
    800009b8:	276000ef          	jal	80000c2e <release>
  if (ReadReg(LSR) & LSR_RX_READY) {
    800009bc:	100004b7          	lui	s1,0x10000
    800009c0:	0495                	addi	s1,s1,5 # 10000005 <_entry-0x6ffffffb>
    return ReadReg(RHR);
    800009c2:	10000937          	lui	s2,0x10000
  if (ReadReg(LSR) & LSR_RX_READY) {
    800009c6:	0004c783          	lbu	a5,0(s1)
    800009ca:	8b85                	andi	a5,a5,1
    800009cc:	c38d                	beqz	a5,800009ee <uartintr+0x70>
    return ReadReg(RHR);
    800009ce:	00094503          	lbu	a0,0(s2) # 10000000 <_entry-0x70000000>
  // read and process incoming characters, if any.
  while (1) {
    int c = uartgetc();
    if (c == -1)
      break;
    consoleintr(c);
    800009d2:	8cdff0ef          	jal	8000029e <consoleintr>
  while (1) {
    800009d6:	bfc5                	j	800009c6 <uartintr+0x48>
    tx_busy = 0;
    800009d8:	0000a797          	auipc	a5,0xa
    800009dc:	8a07a223          	sw	zero,-1884(a5) # 8000a27c <tx_busy>
    wakeup(&tx_chan);
    800009e0:	0000a517          	auipc	a0,0xa
    800009e4:	89850513          	addi	a0,a0,-1896 # 8000a278 <tx_chan>
    800009e8:	5ba010ef          	jal	80001fa2 <wakeup>
    800009ec:	b7d1                	j	800009b0 <uartintr+0x32>
  }
}
    800009ee:	60e2                	ld	ra,24(sp)
    800009f0:	6442                	ld	s0,16(sp)
    800009f2:	64a2                	ld	s1,8(sp)
    800009f4:	6902                	ld	s2,0(sp)
    800009f6:	6105                	addi	sp,sp,32
    800009f8:	8082                	ret

00000000800009fa <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009fa:	1101                	addi	sp,sp,-32
    800009fc:	ec06                	sd	ra,24(sp)
    800009fe:	e822                	sd	s0,16(sp)
    80000a00:	e426                	sd	s1,8(sp)
    80000a02:	e04a                	sd	s2,0(sp)
    80000a04:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a06:	03451793          	slli	a5,a0,0x34
    80000a0a:	e7a9                	bnez	a5,80000a54 <kfree+0x5a>
    80000a0c:	84aa                	mv	s1,a0
    80000a0e:	00023797          	auipc	a5,0x23
    80000a12:	19a78793          	addi	a5,a5,410 # 80023ba8 <end>
    80000a16:	02f56f63          	bltu	a0,a5,80000a54 <kfree+0x5a>
    80000a1a:	47c5                	li	a5,17
    80000a1c:	07ee                	slli	a5,a5,0x1b
    80000a1e:	02f57b63          	bgeu	a0,a5,80000a54 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a22:	6605                	lui	a2,0x1
    80000a24:	4585                	li	a1,1
    80000a26:	240000ef          	jal	80000c66 <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000a2a:	00012917          	auipc	s2,0x12
    80000a2e:	94e90913          	addi	s2,s2,-1714 # 80012378 <kmem>
    80000a32:	854a                	mv	a0,s2
    80000a34:	16e000ef          	jal	80000ba2 <acquire>
  r->next = kmem.freelist;
    80000a38:	01893783          	ld	a5,24(s2)
    80000a3c:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a3e:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a42:	854a                	mv	a0,s2
    80000a44:	1ea000ef          	jal	80000c2e <release>
}
    80000a48:	60e2                	ld	ra,24(sp)
    80000a4a:	6442                	ld	s0,16(sp)
    80000a4c:	64a2                	ld	s1,8(sp)
    80000a4e:	6902                	ld	s2,0(sp)
    80000a50:	6105                	addi	sp,sp,32
    80000a52:	8082                	ret
    panic("kfree");
    80000a54:	00006517          	auipc	a0,0x6
    80000a58:	5e450513          	addi	a0,a0,1508 # 80007038 <etext+0x38>
    80000a5c:	d79ff0ef          	jal	800007d4 <panic>

0000000080000a60 <freerange>:
{
    80000a60:	7179                	addi	sp,sp,-48
    80000a62:	f406                	sd	ra,40(sp)
    80000a64:	f022                	sd	s0,32(sp)
    80000a66:	ec26                	sd	s1,24(sp)
    80000a68:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000a6a:	6785                	lui	a5,0x1
    80000a6c:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a70:	00e504b3          	add	s1,a0,a4
    80000a74:	777d                	lui	a4,0xfffff
    80000a76:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000a78:	94be                	add	s1,s1,a5
    80000a7a:	0295e263          	bltu	a1,s1,80000a9e <freerange+0x3e>
    80000a7e:	e84a                	sd	s2,16(sp)
    80000a80:	e44e                	sd	s3,8(sp)
    80000a82:	e052                	sd	s4,0(sp)
    80000a84:	892e                	mv	s2,a1
    kfree(p);
    80000a86:	7a7d                	lui	s4,0xfffff
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000a88:	6985                	lui	s3,0x1
    kfree(p);
    80000a8a:	01448533          	add	a0,s1,s4
    80000a8e:	f6dff0ef          	jal	800009fa <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000a92:	94ce                	add	s1,s1,s3
    80000a94:	fe997be3          	bgeu	s2,s1,80000a8a <freerange+0x2a>
    80000a98:	6942                	ld	s2,16(sp)
    80000a9a:	69a2                	ld	s3,8(sp)
    80000a9c:	6a02                	ld	s4,0(sp)
}
    80000a9e:	70a2                	ld	ra,40(sp)
    80000aa0:	7402                	ld	s0,32(sp)
    80000aa2:	64e2                	ld	s1,24(sp)
    80000aa4:	6145                	addi	sp,sp,48
    80000aa6:	8082                	ret

0000000080000aa8 <kinit>:
{
    80000aa8:	1141                	addi	sp,sp,-16
    80000aaa:	e406                	sd	ra,8(sp)
    80000aac:	e022                	sd	s0,0(sp)
    80000aae:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ab0:	00006597          	auipc	a1,0x6
    80000ab4:	59058593          	addi	a1,a1,1424 # 80007040 <etext+0x40>
    80000ab8:	00012517          	auipc	a0,0x12
    80000abc:	8c050513          	addi	a0,a0,-1856 # 80012378 <kmem>
    80000ac0:	06c000ef          	jal	80000b2c <initlock>
  freerange(end, (void *)PHYSTOP);
    80000ac4:	45c5                	li	a1,17
    80000ac6:	05ee                	slli	a1,a1,0x1b
    80000ac8:	00023517          	auipc	a0,0x23
    80000acc:	0e050513          	addi	a0,a0,224 # 80023ba8 <end>
    80000ad0:	f91ff0ef          	jal	80000a60 <freerange>
}
    80000ad4:	60a2                	ld	ra,8(sp)
    80000ad6:	6402                	ld	s0,0(sp)
    80000ad8:	0141                	addi	sp,sp,16
    80000ada:	8082                	ret

0000000080000adc <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000adc:	1101                	addi	sp,sp,-32
    80000ade:	ec06                	sd	ra,24(sp)
    80000ae0:	e822                	sd	s0,16(sp)
    80000ae2:	e426                	sd	s1,8(sp)
    80000ae4:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000ae6:	00012497          	auipc	s1,0x12
    80000aea:	89248493          	addi	s1,s1,-1902 # 80012378 <kmem>
    80000aee:	8526                	mv	a0,s1
    80000af0:	0b2000ef          	jal	80000ba2 <acquire>
  r = kmem.freelist;
    80000af4:	6c84                	ld	s1,24(s1)
  if (r)
    80000af6:	c485                	beqz	s1,80000b1e <kalloc+0x42>
    kmem.freelist = r->next;
    80000af8:	609c                	ld	a5,0(s1)
    80000afa:	00012517          	auipc	a0,0x12
    80000afe:	87e50513          	addi	a0,a0,-1922 # 80012378 <kmem>
    80000b02:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b04:	12a000ef          	jal	80000c2e <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000b08:	6605                	lui	a2,0x1
    80000b0a:	4595                	li	a1,5
    80000b0c:	8526                	mv	a0,s1
    80000b0e:	158000ef          	jal	80000c66 <memset>
  return (void *)r;
}
    80000b12:	8526                	mv	a0,s1
    80000b14:	60e2                	ld	ra,24(sp)
    80000b16:	6442                	ld	s0,16(sp)
    80000b18:	64a2                	ld	s1,8(sp)
    80000b1a:	6105                	addi	sp,sp,32
    80000b1c:	8082                	ret
  release(&kmem.lock);
    80000b1e:	00012517          	auipc	a0,0x12
    80000b22:	85a50513          	addi	a0,a0,-1958 # 80012378 <kmem>
    80000b26:	108000ef          	jal	80000c2e <release>
  if (r)
    80000b2a:	b7e5                	j	80000b12 <kalloc+0x36>

0000000080000b2c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b2c:	1141                	addi	sp,sp,-16
    80000b2e:	e422                	sd	s0,8(sp)
    80000b30:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b32:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b34:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b38:	00053823          	sd	zero,16(a0)
}
    80000b3c:	6422                	ld	s0,8(sp)
    80000b3e:	0141                	addi	sp,sp,16
    80000b40:	8082                	ret

0000000080000b42 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b42:	411c                	lw	a5,0(a0)
    80000b44:	e399                	bnez	a5,80000b4a <holding+0x8>
    80000b46:	4501                	li	a0,0
  return r;
}
    80000b48:	8082                	ret
{
    80000b4a:	1101                	addi	sp,sp,-32
    80000b4c:	ec06                	sd	ra,24(sp)
    80000b4e:	e822                	sd	s0,16(sp)
    80000b50:	e426                	sd	s1,8(sp)
    80000b52:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b54:	6904                	ld	s1,16(a0)
    80000b56:	521000ef          	jal	80001876 <mycpu>
    80000b5a:	40a48533          	sub	a0,s1,a0
    80000b5e:	00153513          	seqz	a0,a0
}
    80000b62:	60e2                	ld	ra,24(sp)
    80000b64:	6442                	ld	s0,16(sp)
    80000b66:	64a2                	ld	s1,8(sp)
    80000b68:	6105                	addi	sp,sp,32
    80000b6a:	8082                	ret

0000000080000b6c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b6c:	1101                	addi	sp,sp,-32
    80000b6e:	ec06                	sd	ra,24(sp)
    80000b70:	e822                	sd	s0,16(sp)
    80000b72:	e426                	sd	s1,8(sp)
    80000b74:	1000                	addi	s0,sp,32
  __asm__ __volatile__("csrrc %0, sstatus, %1" :
    80000b76:	100174f3          	csrrci	s1,sstatus,2
  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  uint64 flags = rc_sstatus(SSTATUS_SIE);
  int old = !!(flags & SSTATUS_SIE);

  if (mycpu()->noff == 0)
    80000b7a:	4fd000ef          	jal	80001876 <mycpu>
    80000b7e:	5d3c                	lw	a5,120(a0)
    80000b80:	cb99                	beqz	a5,80000b96 <push_off+0x2a>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b82:	4f5000ef          	jal	80001876 <mycpu>
    80000b86:	5d3c                	lw	a5,120(a0)
    80000b88:	2785                	addiw	a5,a5,1
    80000b8a:	dd3c                	sw	a5,120(a0)
}
    80000b8c:	60e2                	ld	ra,24(sp)
    80000b8e:	6442                	ld	s0,16(sp)
    80000b90:	64a2                	ld	s1,8(sp)
    80000b92:	6105                	addi	sp,sp,32
    80000b94:	8082                	ret
    mycpu()->intena = old;
    80000b96:	4e1000ef          	jal	80001876 <mycpu>
  int old = !!(flags & SSTATUS_SIE);
    80000b9a:	8085                	srli	s1,s1,0x1
    80000b9c:	8885                	andi	s1,s1,1
    mycpu()->intena = old;
    80000b9e:	dd64                	sw	s1,124(a0)
    80000ba0:	b7cd                	j	80000b82 <push_off+0x16>

0000000080000ba2 <acquire>:
{
    80000ba2:	1101                	addi	sp,sp,-32
    80000ba4:	ec06                	sd	ra,24(sp)
    80000ba6:	e822                	sd	s0,16(sp)
    80000ba8:	e426                	sd	s1,8(sp)
    80000baa:	1000                	addi	s0,sp,32
    80000bac:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bae:	fbfff0ef          	jal	80000b6c <push_off>
  if (holding(lk))
    80000bb2:	8526                	mv	a0,s1
    80000bb4:	f8fff0ef          	jal	80000b42 <holding>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000bb8:	4705                	li	a4,1
  if (holding(lk))
    80000bba:	ed11                	bnez	a0,80000bd6 <acquire+0x34>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000bbc:	87ba                	mv	a5,a4
    80000bbe:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bc2:	2781                	sext.w	a5,a5
    80000bc4:	ffe5                	bnez	a5,80000bbc <acquire+0x1a>
  lk->cpu = mycpu();
    80000bc6:	4b1000ef          	jal	80001876 <mycpu>
    80000bca:	e888                	sd	a0,16(s1)
}
    80000bcc:	60e2                	ld	ra,24(sp)
    80000bce:	6442                	ld	s0,16(sp)
    80000bd0:	64a2                	ld	s1,8(sp)
    80000bd2:	6105                	addi	sp,sp,32
    80000bd4:	8082                	ret
    panic("acquire");
    80000bd6:	00006517          	auipc	a0,0x6
    80000bda:	47250513          	addi	a0,a0,1138 # 80007048 <etext+0x48>
    80000bde:	bf7ff0ef          	jal	800007d4 <panic>

0000000080000be2 <pop_off>:

void
pop_off(void)
{
    80000be2:	1141                	addi	sp,sp,-16
    80000be4:	e406                	sd	ra,8(sp)
    80000be6:	e022                	sd	s0,0(sp)
    80000be8:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000bea:	48d000ef          	jal	80001876 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000bee:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000bf2:	8b89                	andi	a5,a5,2
  if (intr_get())
    80000bf4:	e38d                	bnez	a5,80000c16 <pop_off+0x34>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    80000bf6:	5d3c                	lw	a5,120(a0)
    80000bf8:	02f05563          	blez	a5,80000c22 <pop_off+0x40>
    panic("pop_off");
  c->noff -= 1;
    80000bfc:	37fd                	addiw	a5,a5,-1
    80000bfe:	0007871b          	sext.w	a4,a5
    80000c02:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    80000c04:	e709                	bnez	a4,80000c0e <pop_off+0x2c>
    80000c06:	5d7c                	lw	a5,124(a0)
    80000c08:	c399                	beqz	a5,80000c0e <pop_off+0x2c>
  __asm__ __volatile__("csrs sstatus, %0" ::
    80000c0a:	10016073          	csrsi	sstatus,2
    intr_on();
}
    80000c0e:	60a2                	ld	ra,8(sp)
    80000c10:	6402                	ld	s0,0(sp)
    80000c12:	0141                	addi	sp,sp,16
    80000c14:	8082                	ret
    panic("pop_off - interruptible");
    80000c16:	00006517          	auipc	a0,0x6
    80000c1a:	43a50513          	addi	a0,a0,1082 # 80007050 <etext+0x50>
    80000c1e:	bb7ff0ef          	jal	800007d4 <panic>
    panic("pop_off");
    80000c22:	00006517          	auipc	a0,0x6
    80000c26:	44650513          	addi	a0,a0,1094 # 80007068 <etext+0x68>
    80000c2a:	babff0ef          	jal	800007d4 <panic>

0000000080000c2e <release>:
{
    80000c2e:	1101                	addi	sp,sp,-32
    80000c30:	ec06                	sd	ra,24(sp)
    80000c32:	e822                	sd	s0,16(sp)
    80000c34:	e426                	sd	s1,8(sp)
    80000c36:	1000                	addi	s0,sp,32
    80000c38:	84aa                	mv	s1,a0
  if (!holding(lk))
    80000c3a:	f09ff0ef          	jal	80000b42 <holding>
    80000c3e:	cd11                	beqz	a0,80000c5a <release+0x2c>
  lk->cpu = 0;
    80000c40:	0004b823          	sd	zero,16(s1)
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);
    80000c44:	0310000f          	fence	rw,w
    80000c48:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000c4c:	f97ff0ef          	jal	80000be2 <pop_off>
}
    80000c50:	60e2                	ld	ra,24(sp)
    80000c52:	6442                	ld	s0,16(sp)
    80000c54:	64a2                	ld	s1,8(sp)
    80000c56:	6105                	addi	sp,sp,32
    80000c58:	8082                	ret
    panic("release");
    80000c5a:	00006517          	auipc	a0,0x6
    80000c5e:	41650513          	addi	a0,a0,1046 # 80007070 <etext+0x70>
    80000c62:	b73ff0ef          	jal	800007d4 <panic>

0000000080000c66 <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    80000c66:	1141                	addi	sp,sp,-16
    80000c68:	e422                	sd	s0,8(sp)
    80000c6a:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000c6c:	ca19                	beqz	a2,80000c82 <memset+0x1c>
    80000c6e:	87aa                	mv	a5,a0
    80000c70:	1602                	slli	a2,a2,0x20
    80000c72:	9201                	srli	a2,a2,0x20
    80000c74:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000c78:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000c7c:	0785                	addi	a5,a5,1
    80000c7e:	fee79de3          	bne	a5,a4,80000c78 <memset+0x12>
  }
  return dst;
}
    80000c82:	6422                	ld	s0,8(sp)
    80000c84:	0141                	addi	sp,sp,16
    80000c86:	8082                	ret

0000000080000c88 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000c88:	1141                	addi	sp,sp,-16
    80000c8a:	e422                	sd	s0,8(sp)
    80000c8c:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000c8e:	ca05                	beqz	a2,80000cbe <memcmp+0x36>
    80000c90:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000c94:	1682                	slli	a3,a3,0x20
    80000c96:	9281                	srli	a3,a3,0x20
    80000c98:	0685                	addi	a3,a3,1
    80000c9a:	96aa                	add	a3,a3,a0
    if (*s1 != *s2)
    80000c9c:	00054783          	lbu	a5,0(a0)
    80000ca0:	0005c703          	lbu	a4,0(a1)
    80000ca4:	00e79863          	bne	a5,a4,80000cb4 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000ca8:	0505                	addi	a0,a0,1
    80000caa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000cac:	fed518e3          	bne	a0,a3,80000c9c <memcmp+0x14>
  }

  return 0;
    80000cb0:	4501                	li	a0,0
    80000cb2:	a019                	j	80000cb8 <memcmp+0x30>
      return *s1 - *s2;
    80000cb4:	40e7853b          	subw	a0,a5,a4
}
    80000cb8:	6422                	ld	s0,8(sp)
    80000cba:	0141                	addi	sp,sp,16
    80000cbc:	8082                	ret
  return 0;
    80000cbe:	4501                	li	a0,0
    80000cc0:	bfe5                	j	80000cb8 <memcmp+0x30>

0000000080000cc2 <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    80000cc2:	1141                	addi	sp,sp,-16
    80000cc4:	e422                	sd	s0,8(sp)
    80000cc6:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    80000cc8:	c205                	beqz	a2,80000ce8 <memmove+0x26>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000cca:	02a5e263          	bltu	a1,a0,80000cee <memmove+0x2c>
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  } else
    while (n-- > 0)
    80000cce:	1602                	slli	a2,a2,0x20
    80000cd0:	9201                	srli	a2,a2,0x20
    80000cd2:	00c587b3          	add	a5,a1,a2
{
    80000cd6:	872a                	mv	a4,a0
      *d++ = *s++;
    80000cd8:	0585                	addi	a1,a1,1
    80000cda:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb459>
    80000cdc:	fff5c683          	lbu	a3,-1(a1)
    80000ce0:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    80000ce4:	feb79ae3          	bne	a5,a1,80000cd8 <memmove+0x16>

  return dst;
}
    80000ce8:	6422                	ld	s0,8(sp)
    80000cea:	0141                	addi	sp,sp,16
    80000cec:	8082                	ret
  if (s < d && s + n > d) {
    80000cee:	02061693          	slli	a3,a2,0x20
    80000cf2:	9281                	srli	a3,a3,0x20
    80000cf4:	00d58733          	add	a4,a1,a3
    80000cf8:	fce57be3          	bgeu	a0,a4,80000cce <memmove+0xc>
    d += n;
    80000cfc:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    80000cfe:	fff6079b          	addiw	a5,a2,-1
    80000d02:	1782                	slli	a5,a5,0x20
    80000d04:	9381                	srli	a5,a5,0x20
    80000d06:	fff7c793          	not	a5,a5
    80000d0a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d0c:	177d                	addi	a4,a4,-1
    80000d0e:	16fd                	addi	a3,a3,-1
    80000d10:	00074603          	lbu	a2,0(a4)
    80000d14:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000d18:	fef71ae3          	bne	a4,a5,80000d0c <memmove+0x4a>
    80000d1c:	b7f1                	j	80000ce8 <memmove+0x26>

0000000080000d1e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    80000d1e:	1141                	addi	sp,sp,-16
    80000d20:	e406                	sd	ra,8(sp)
    80000d22:	e022                	sd	s0,0(sp)
    80000d24:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d26:	f9dff0ef          	jal	80000cc2 <memmove>
}
    80000d2a:	60a2                	ld	ra,8(sp)
    80000d2c:	6402                	ld	s0,0(sp)
    80000d2e:	0141                	addi	sp,sp,16
    80000d30:	8082                	ret

0000000080000d32 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d32:	1141                	addi	sp,sp,-16
    80000d34:	e422                	sd	s0,8(sp)
    80000d36:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    80000d38:	ce11                	beqz	a2,80000d54 <strncmp+0x22>
    80000d3a:	00054783          	lbu	a5,0(a0)
    80000d3e:	cf89                	beqz	a5,80000d58 <strncmp+0x26>
    80000d40:	0005c703          	lbu	a4,0(a1)
    80000d44:	00f71a63          	bne	a4,a5,80000d58 <strncmp+0x26>
    n--, p++, q++;
    80000d48:	367d                	addiw	a2,a2,-1
    80000d4a:	0505                	addi	a0,a0,1
    80000d4c:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000d4e:	f675                	bnez	a2,80000d3a <strncmp+0x8>
  if (n == 0)
    return 0;
    80000d50:	4501                	li	a0,0
    80000d52:	a801                	j	80000d62 <strncmp+0x30>
    80000d54:	4501                	li	a0,0
    80000d56:	a031                	j	80000d62 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000d58:	00054503          	lbu	a0,0(a0)
    80000d5c:	0005c783          	lbu	a5,0(a1)
    80000d60:	9d1d                	subw	a0,a0,a5
}
    80000d62:	6422                	ld	s0,8(sp)
    80000d64:	0141                	addi	sp,sp,16
    80000d66:	8082                	ret

0000000080000d68 <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    80000d68:	1141                	addi	sp,sp,-16
    80000d6a:	e422                	sd	s0,8(sp)
    80000d6c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000d6e:	87aa                	mv	a5,a0
    80000d70:	86b2                	mv	a3,a2
    80000d72:	367d                	addiw	a2,a2,-1
    80000d74:	02d05563          	blez	a3,80000d9e <strncpy+0x36>
    80000d78:	0785                	addi	a5,a5,1
    80000d7a:	0005c703          	lbu	a4,0(a1)
    80000d7e:	fee78fa3          	sb	a4,-1(a5)
    80000d82:	0585                	addi	a1,a1,1
    80000d84:	f775                	bnez	a4,80000d70 <strncpy+0x8>
    ;
  while (n-- > 0)
    80000d86:	873e                	mv	a4,a5
    80000d88:	9fb5                	addw	a5,a5,a3
    80000d8a:	37fd                	addiw	a5,a5,-1
    80000d8c:	00c05963          	blez	a2,80000d9e <strncpy+0x36>
    *s++ = 0;
    80000d90:	0705                	addi	a4,a4,1
    80000d92:	fe070fa3          	sb	zero,-1(a4)
  while (n-- > 0)
    80000d96:	40e786bb          	subw	a3,a5,a4
    80000d9a:	fed04be3          	bgtz	a3,80000d90 <strncpy+0x28>
  return os;
}
    80000d9e:	6422                	ld	s0,8(sp)
    80000da0:	0141                	addi	sp,sp,16
    80000da2:	8082                	ret

0000000080000da4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    80000da4:	1141                	addi	sp,sp,-16
    80000da6:	e422                	sd	s0,8(sp)
    80000da8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    80000daa:	02c05363          	blez	a2,80000dd0 <safestrcpy+0x2c>
    80000dae:	fff6069b          	addiw	a3,a2,-1
    80000db2:	1682                	slli	a3,a3,0x20
    80000db4:	9281                	srli	a3,a3,0x20
    80000db6:	96ae                	add	a3,a3,a1
    80000db8:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    80000dba:	00d58963          	beq	a1,a3,80000dcc <safestrcpy+0x28>
    80000dbe:	0585                	addi	a1,a1,1
    80000dc0:	0785                	addi	a5,a5,1
    80000dc2:	fff5c703          	lbu	a4,-1(a1)
    80000dc6:	fee78fa3          	sb	a4,-1(a5)
    80000dca:	fb65                	bnez	a4,80000dba <safestrcpy+0x16>
    ;
  *s = 0;
    80000dcc:	00078023          	sb	zero,0(a5)
  return os;
}
    80000dd0:	6422                	ld	s0,8(sp)
    80000dd2:	0141                	addi	sp,sp,16
    80000dd4:	8082                	ret

0000000080000dd6 <strlen>:

int
strlen(const char *s)
{
    80000dd6:	1141                	addi	sp,sp,-16
    80000dd8:	e422                	sd	s0,8(sp)
    80000dda:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80000ddc:	00054783          	lbu	a5,0(a0)
    80000de0:	cf91                	beqz	a5,80000dfc <strlen+0x26>
    80000de2:	0505                	addi	a0,a0,1
    80000de4:	87aa                	mv	a5,a0
    80000de6:	86be                	mv	a3,a5
    80000de8:	0785                	addi	a5,a5,1
    80000dea:	fff7c703          	lbu	a4,-1(a5)
    80000dee:	ff65                	bnez	a4,80000de6 <strlen+0x10>
    80000df0:	40a6853b          	subw	a0,a3,a0
    80000df4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000df6:	6422                	ld	s0,8(sp)
    80000df8:	0141                	addi	sp,sp,16
    80000dfa:	8082                	ret
  for (n = 0; s[n]; n++)
    80000dfc:	4501                	li	a0,0
    80000dfe:	bfe5                	j	80000df6 <strlen+0x20>

0000000080000e00 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e00:	1141                	addi	sp,sp,-16
    80000e02:	e406                	sd	ra,8(sp)
    80000e04:	e022                	sd	s0,0(sp)
    80000e06:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000e08:	25f000ef          	jal	80001866 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    started = 1;
  } else {
    while (started == 0)
    80000e0c:	00009717          	auipc	a4,0x9
    80000e10:	47470713          	addi	a4,a4,1140 # 8000a280 <started>
  if (cpuid() == 0) {
    80000e14:	c51d                	beqz	a0,80000e42 <main+0x42>
    while (started == 0)
    80000e16:	431c                	lw	a5,0(a4)
    80000e18:	2781                	sext.w	a5,a5
    80000e1a:	dff5                	beqz	a5,80000e16 <main+0x16>
      ;
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80000e1c:	0330000f          	fence	rw,rw
    printk("hart %d starting\n", cpuid());
    80000e20:	247000ef          	jal	80001866 <cpuid>
    80000e24:	85aa                	mv	a1,a0
    80000e26:	00006517          	auipc	a0,0x6
    80000e2a:	27250513          	addi	a0,a0,626 # 80007098 <etext+0x98>
    80000e2e:	ec0ff0ef          	jal	800004ee <printk>
    kvminithart();  // turn on paging
    80000e32:	080000ef          	jal	80000eb2 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000e36:	642010ef          	jal	80002478 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80000e3a:	73e040ef          	jal	80005578 <plicinithart>
  }

  scheduler();
    80000e3e:	749000ef          	jal	80001d86 <scheduler>
    consoleinit();
    80000e42:	dd6ff0ef          	jal	80000418 <consoleinit>
    printkinit();
    80000e46:	9cbff0ef          	jal	80000810 <printkinit>
    printk("\n");
    80000e4a:	00006517          	auipc	a0,0x6
    80000e4e:	22e50513          	addi	a0,a0,558 # 80007078 <etext+0x78>
    80000e52:	e9cff0ef          	jal	800004ee <printk>
    printk("xv6 kernel is booting\n");
    80000e56:	00006517          	auipc	a0,0x6
    80000e5a:	22a50513          	addi	a0,a0,554 # 80007080 <etext+0x80>
    80000e5e:	e90ff0ef          	jal	800004ee <printk>
    printk("\n");
    80000e62:	00006517          	auipc	a0,0x6
    80000e66:	21650513          	addi	a0,a0,534 # 80007078 <etext+0x78>
    80000e6a:	e84ff0ef          	jal	800004ee <printk>
    kinit();            // physical page allocator
    80000e6e:	c3bff0ef          	jal	80000aa8 <kinit>
    kvminit();          // create kernel page table
    80000e72:	2ca000ef          	jal	8000113c <kvminit>
    kvminithart();      // turn on paging
    80000e76:	03c000ef          	jal	80000eb2 <kvminithart>
    procinit();         // process table
    80000e7a:	137000ef          	jal	800017b0 <procinit>
    trapinit();         // trap vectors
    80000e7e:	5d6010ef          	jal	80002454 <trapinit>
    trapinithart();     // install kernel trap vector
    80000e82:	5f6010ef          	jal	80002478 <trapinithart>
    plicinit();         // set up interrupt controller
    80000e86:	6d8040ef          	jal	8000555e <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    80000e8a:	6ee040ef          	jal	80005578 <plicinithart>
    binit();            // buffer cache
    80000e8e:	545010ef          	jal	80002bd2 <binit>
    iinit();            // inode table
    80000e92:	2ca020ef          	jal	8000315c <iinit>
    fileinit();         // file table
    80000e96:	224030ef          	jal	800040ba <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000e9a:	7ce040ef          	jal	80005668 <virtio_disk_init>
    userinit();         // first user process
    80000e9e:	53d000ef          	jal	80001bda <userinit>
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80000ea2:	0330000f          	fence	rw,rw
    started = 1;
    80000ea6:	4785                	li	a5,1
    80000ea8:	00009717          	auipc	a4,0x9
    80000eac:	3cf72c23          	sw	a5,984(a4) # 8000a280 <started>
    80000eb0:	b779                	j	80000e3e <main+0x3e>

0000000080000eb2 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000eb2:	1141                	addi	sp,sp,-16
    80000eb4:	e422                	sd	s0,8(sp)
    80000eb6:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000eb8:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000ebc:	00009797          	auipc	a5,0x9
    80000ec0:	3cc7b783          	ld	a5,972(a5) # 8000a288 <kernel_pagetable>
    80000ec4:	83b1                	srli	a5,a5,0xc
    80000ec6:	577d                	li	a4,-1
    80000ec8:	177e                	slli	a4,a4,0x3f
    80000eca:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000ecc:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000ed0:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000ed4:	6422                	ld	s0,8(sp)
    80000ed6:	0141                	addi	sp,sp,16
    80000ed8:	8082                	ret

0000000080000eda <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000eda:	7139                	addi	sp,sp,-64
    80000edc:	fc06                	sd	ra,56(sp)
    80000ede:	f822                	sd	s0,48(sp)
    80000ee0:	f426                	sd	s1,40(sp)
    80000ee2:	f04a                	sd	s2,32(sp)
    80000ee4:	ec4e                	sd	s3,24(sp)
    80000ee6:	e852                	sd	s4,16(sp)
    80000ee8:	e456                	sd	s5,8(sp)
    80000eea:	e05a                	sd	s6,0(sp)
    80000eec:	0080                	addi	s0,sp,64
    80000eee:	84aa                	mv	s1,a0
    80000ef0:	89ae                	mv	s3,a1
    80000ef2:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    80000ef4:	57fd                	li	a5,-1
    80000ef6:	83e9                	srli	a5,a5,0x1a
    80000ef8:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    80000efa:	4b31                	li	s6,12
  if (va >= MAXVA)
    80000efc:	02b7fc63          	bgeu	a5,a1,80000f34 <walk+0x5a>
    panic("walk");
    80000f00:	00006517          	auipc	a0,0x6
    80000f04:	1b050513          	addi	a0,a0,432 # 800070b0 <etext+0xb0>
    80000f08:	8cdff0ef          	jal	800007d4 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000f0c:	060a8263          	beqz	s5,80000f70 <walk+0x96>
    80000f10:	bcdff0ef          	jal	80000adc <kalloc>
    80000f14:	84aa                	mv	s1,a0
    80000f16:	c139                	beqz	a0,80000f5c <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f18:	6605                	lui	a2,0x1
    80000f1a:	4581                	li	a1,0
    80000f1c:	d4bff0ef          	jal	80000c66 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f20:	00c4d793          	srli	a5,s1,0xc
    80000f24:	07aa                	slli	a5,a5,0xa
    80000f26:	0017e793          	ori	a5,a5,1
    80000f2a:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    80000f2e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb44f>
    80000f30:	036a0063          	beq	s4,s6,80000f50 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f34:	0149d933          	srl	s2,s3,s4
    80000f38:	1ff97913          	andi	s2,s2,511
    80000f3c:	090e                	slli	s2,s2,0x3
    80000f3e:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000f40:	00093483          	ld	s1,0(s2)
    80000f44:	0014f793          	andi	a5,s1,1
    80000f48:	d3f1                	beqz	a5,80000f0c <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f4a:	80a9                	srli	s1,s1,0xa
    80000f4c:	04b2                	slli	s1,s1,0xc
    80000f4e:	b7c5                	j	80000f2e <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000f50:	00c9d513          	srli	a0,s3,0xc
    80000f54:	1ff57513          	andi	a0,a0,511
    80000f58:	050e                	slli	a0,a0,0x3
    80000f5a:	9526                	add	a0,a0,s1
}
    80000f5c:	70e2                	ld	ra,56(sp)
    80000f5e:	7442                	ld	s0,48(sp)
    80000f60:	74a2                	ld	s1,40(sp)
    80000f62:	7902                	ld	s2,32(sp)
    80000f64:	69e2                	ld	s3,24(sp)
    80000f66:	6a42                	ld	s4,16(sp)
    80000f68:	6aa2                	ld	s5,8(sp)
    80000f6a:	6b02                	ld	s6,0(sp)
    80000f6c:	6121                	addi	sp,sp,64
    80000f6e:	8082                	ret
        return 0;
    80000f70:	4501                	li	a0,0
    80000f72:	b7ed                	j	80000f5c <walk+0x82>

0000000080000f74 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80000f74:	57fd                	li	a5,-1
    80000f76:	83e9                	srli	a5,a5,0x1a
    80000f78:	00b7f463          	bgeu	a5,a1,80000f80 <walkaddr+0xc>
    return 0;
    80000f7c:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000f7e:	8082                	ret
{
    80000f80:	1141                	addi	sp,sp,-16
    80000f82:	e406                	sd	ra,8(sp)
    80000f84:	e022                	sd	s0,0(sp)
    80000f86:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000f88:	4601                	li	a2,0
    80000f8a:	f51ff0ef          	jal	80000eda <walk>
  if (pte == 0)
    80000f8e:	c105                	beqz	a0,80000fae <walkaddr+0x3a>
  if ((*pte & PTE_V) == 0)
    80000f90:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80000f92:	0117f693          	andi	a3,a5,17
    80000f96:	4745                	li	a4,17
    return 0;
    80000f98:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    80000f9a:	00e68663          	beq	a3,a4,80000fa6 <walkaddr+0x32>
}
    80000f9e:	60a2                	ld	ra,8(sp)
    80000fa0:	6402                	ld	s0,0(sp)
    80000fa2:	0141                	addi	sp,sp,16
    80000fa4:	8082                	ret
  pa = PTE2PA(*pte);
    80000fa6:	83a9                	srli	a5,a5,0xa
    80000fa8:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000fac:	bfcd                	j	80000f9e <walkaddr+0x2a>
    return 0;
    80000fae:	4501                	li	a0,0
    80000fb0:	b7fd                	j	80000f9e <walkaddr+0x2a>

0000000080000fb2 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000fb2:	715d                	addi	sp,sp,-80
    80000fb4:	e486                	sd	ra,72(sp)
    80000fb6:	e0a2                	sd	s0,64(sp)
    80000fb8:	fc26                	sd	s1,56(sp)
    80000fba:	f84a                	sd	s2,48(sp)
    80000fbc:	f44e                	sd	s3,40(sp)
    80000fbe:	f052                	sd	s4,32(sp)
    80000fc0:	ec56                	sd	s5,24(sp)
    80000fc2:	e85a                	sd	s6,16(sp)
    80000fc4:	e45e                	sd	s7,8(sp)
    80000fc6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80000fc8:	03459793          	slli	a5,a1,0x34
    80000fcc:	e7a9                	bnez	a5,80001016 <mappages+0x64>
    80000fce:	8aaa                	mv	s5,a0
    80000fd0:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    80000fd2:	03461793          	slli	a5,a2,0x34
    80000fd6:	e7b1                	bnez	a5,80001022 <mappages+0x70>
    panic("mappages: size not aligned");

  if (size == 0)
    80000fd8:	ca39                	beqz	a2,8000102e <mappages+0x7c>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    80000fda:	77fd                	lui	a5,0xfffff
    80000fdc:	963e                	add	a2,a2,a5
    80000fde:	00b609b3          	add	s3,a2,a1
  a = va;
    80000fe2:	892e                	mv	s2,a1
    80000fe4:	40b68a33          	sub	s4,a3,a1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80000fe8:	6b85                	lui	s7,0x1
    80000fea:	014904b3          	add	s1,s2,s4
    if ((pte = walk(pagetable, a, 1)) == 0)
    80000fee:	4605                	li	a2,1
    80000ff0:	85ca                	mv	a1,s2
    80000ff2:	8556                	mv	a0,s5
    80000ff4:	ee7ff0ef          	jal	80000eda <walk>
    80000ff8:	c539                	beqz	a0,80001046 <mappages+0x94>
    if (*pte & PTE_V)
    80000ffa:	611c                	ld	a5,0(a0)
    80000ffc:	8b85                	andi	a5,a5,1
    80000ffe:	ef95                	bnez	a5,8000103a <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001000:	80b1                	srli	s1,s1,0xc
    80001002:	04aa                	slli	s1,s1,0xa
    80001004:	0164e4b3          	or	s1,s1,s6
    80001008:	0014e493          	ori	s1,s1,1
    8000100c:	e104                	sd	s1,0(a0)
    if (a == last)
    8000100e:	05390863          	beq	s2,s3,8000105e <mappages+0xac>
    a += PGSIZE;
    80001012:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001014:	bfd9                	j	80000fea <mappages+0x38>
    panic("mappages: va not aligned");
    80001016:	00006517          	auipc	a0,0x6
    8000101a:	0a250513          	addi	a0,a0,162 # 800070b8 <etext+0xb8>
    8000101e:	fb6ff0ef          	jal	800007d4 <panic>
    panic("mappages: size not aligned");
    80001022:	00006517          	auipc	a0,0x6
    80001026:	0b650513          	addi	a0,a0,182 # 800070d8 <etext+0xd8>
    8000102a:	faaff0ef          	jal	800007d4 <panic>
    panic("mappages: size");
    8000102e:	00006517          	auipc	a0,0x6
    80001032:	0ca50513          	addi	a0,a0,202 # 800070f8 <etext+0xf8>
    80001036:	f9eff0ef          	jal	800007d4 <panic>
      panic("mappages: remap");
    8000103a:	00006517          	auipc	a0,0x6
    8000103e:	0ce50513          	addi	a0,a0,206 # 80007108 <etext+0x108>
    80001042:	f92ff0ef          	jal	800007d4 <panic>
      return -1;
    80001046:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001048:	60a6                	ld	ra,72(sp)
    8000104a:	6406                	ld	s0,64(sp)
    8000104c:	74e2                	ld	s1,56(sp)
    8000104e:	7942                	ld	s2,48(sp)
    80001050:	79a2                	ld	s3,40(sp)
    80001052:	7a02                	ld	s4,32(sp)
    80001054:	6ae2                	ld	s5,24(sp)
    80001056:	6b42                	ld	s6,16(sp)
    80001058:	6ba2                	ld	s7,8(sp)
    8000105a:	6161                	addi	sp,sp,80
    8000105c:	8082                	ret
  return 0;
    8000105e:	4501                	li	a0,0
    80001060:	b7e5                	j	80001048 <mappages+0x96>

0000000080001062 <kvmmap>:
{
    80001062:	1141                	addi	sp,sp,-16
    80001064:	e406                	sd	ra,8(sp)
    80001066:	e022                	sd	s0,0(sp)
    80001068:	0800                	addi	s0,sp,16
    8000106a:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000106c:	86b2                	mv	a3,a2
    8000106e:	863e                	mv	a2,a5
    80001070:	f43ff0ef          	jal	80000fb2 <mappages>
    80001074:	e509                	bnez	a0,8000107e <kvmmap+0x1c>
}
    80001076:	60a2                	ld	ra,8(sp)
    80001078:	6402                	ld	s0,0(sp)
    8000107a:	0141                	addi	sp,sp,16
    8000107c:	8082                	ret
    panic("kvmmap");
    8000107e:	00006517          	auipc	a0,0x6
    80001082:	09a50513          	addi	a0,a0,154 # 80007118 <etext+0x118>
    80001086:	f4eff0ef          	jal	800007d4 <panic>

000000008000108a <kvmmake>:
{
    8000108a:	1101                	addi	sp,sp,-32
    8000108c:	ec06                	sd	ra,24(sp)
    8000108e:	e822                	sd	s0,16(sp)
    80001090:	e426                	sd	s1,8(sp)
    80001092:	e04a                	sd	s2,0(sp)
    80001094:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80001096:	a47ff0ef          	jal	80000adc <kalloc>
    8000109a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000109c:	6605                	lui	a2,0x1
    8000109e:	4581                	li	a1,0
    800010a0:	bc7ff0ef          	jal	80000c66 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800010a4:	4719                	li	a4,6
    800010a6:	6685                	lui	a3,0x1
    800010a8:	10000637          	lui	a2,0x10000
    800010ac:	100005b7          	lui	a1,0x10000
    800010b0:	8526                	mv	a0,s1
    800010b2:	fb1ff0ef          	jal	80001062 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800010b6:	4719                	li	a4,6
    800010b8:	6685                	lui	a3,0x1
    800010ba:	10001637          	lui	a2,0x10001
    800010be:	100015b7          	lui	a1,0x10001
    800010c2:	8526                	mv	a0,s1
    800010c4:	f9fff0ef          	jal	80001062 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800010c8:	4719                	li	a4,6
    800010ca:	040006b7          	lui	a3,0x4000
    800010ce:	0c000637          	lui	a2,0xc000
    800010d2:	0c0005b7          	lui	a1,0xc000
    800010d6:	8526                	mv	a0,s1
    800010d8:	f8bff0ef          	jal	80001062 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    800010dc:	00006917          	auipc	s2,0x6
    800010e0:	f2490913          	addi	s2,s2,-220 # 80007000 <etext>
    800010e4:	4729                	li	a4,10
    800010e6:	80006697          	auipc	a3,0x80006
    800010ea:	f1a68693          	addi	a3,a3,-230 # 7000 <_entry-0x7fff9000>
    800010ee:	4605                	li	a2,1
    800010f0:	067e                	slli	a2,a2,0x1f
    800010f2:	85b2                	mv	a1,a2
    800010f4:	8526                	mv	a0,s1
    800010f6:	f6dff0ef          	jal	80001062 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    800010fa:	46c5                	li	a3,17
    800010fc:	06ee                	slli	a3,a3,0x1b
    800010fe:	4719                	li	a4,6
    80001100:	412686b3          	sub	a3,a3,s2
    80001104:	864a                	mv	a2,s2
    80001106:	85ca                	mv	a1,s2
    80001108:	8526                	mv	a0,s1
    8000110a:	f59ff0ef          	jal	80001062 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000110e:	4729                	li	a4,10
    80001110:	6685                	lui	a3,0x1
    80001112:	00005617          	auipc	a2,0x5
    80001116:	eee60613          	addi	a2,a2,-274 # 80006000 <_trampoline>
    8000111a:	040005b7          	lui	a1,0x4000
    8000111e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001120:	05b2                	slli	a1,a1,0xc
    80001122:	8526                	mv	a0,s1
    80001124:	f3fff0ef          	jal	80001062 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001128:	8526                	mv	a0,s1
    8000112a:	5ee000ef          	jal	80001718 <proc_mapstacks>
}
    8000112e:	8526                	mv	a0,s1
    80001130:	60e2                	ld	ra,24(sp)
    80001132:	6442                	ld	s0,16(sp)
    80001134:	64a2                	ld	s1,8(sp)
    80001136:	6902                	ld	s2,0(sp)
    80001138:	6105                	addi	sp,sp,32
    8000113a:	8082                	ret

000000008000113c <kvminit>:
{
    8000113c:	1141                	addi	sp,sp,-16
    8000113e:	e406                	sd	ra,8(sp)
    80001140:	e022                	sd	s0,0(sp)
    80001142:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001144:	f47ff0ef          	jal	8000108a <kvmmake>
    80001148:	00009797          	auipc	a5,0x9
    8000114c:	14a7b023          	sd	a0,320(a5) # 8000a288 <kernel_pagetable>
}
    80001150:	60a2                	ld	ra,8(sp)
    80001152:	6402                	ld	s0,0(sp)
    80001154:	0141                	addi	sp,sp,16
    80001156:	8082                	ret

0000000080001158 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001158:	1101                	addi	sp,sp,-32
    8000115a:	ec06                	sd	ra,24(sp)
    8000115c:	e822                	sd	s0,16(sp)
    8000115e:	e426                	sd	s1,8(sp)
    80001160:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    80001162:	97bff0ef          	jal	80000adc <kalloc>
    80001166:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001168:	c509                	beqz	a0,80001172 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000116a:	6605                	lui	a2,0x1
    8000116c:	4581                	li	a1,0
    8000116e:	af9ff0ef          	jal	80000c66 <memset>
  return pagetable;
}
    80001172:	8526                	mv	a0,s1
    80001174:	60e2                	ld	ra,24(sp)
    80001176:	6442                	ld	s0,16(sp)
    80001178:	64a2                	ld	s1,8(sp)
    8000117a:	6105                	addi	sp,sp,32
    8000117c:	8082                	ret

000000008000117e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000117e:	7139                	addi	sp,sp,-64
    80001180:	fc06                	sd	ra,56(sp)
    80001182:	f822                	sd	s0,48(sp)
    80001184:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80001186:	03459793          	slli	a5,a1,0x34
    8000118a:	e38d                	bnez	a5,800011ac <uvmunmap+0x2e>
    8000118c:	f04a                	sd	s2,32(sp)
    8000118e:	ec4e                	sd	s3,24(sp)
    80001190:	e852                	sd	s4,16(sp)
    80001192:	e456                	sd	s5,8(sp)
    80001194:	e05a                	sd	s6,0(sp)
    80001196:	8a2a                	mv	s4,a0
    80001198:	892e                	mv	s2,a1
    8000119a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000119c:	0632                	slli	a2,a2,0xc
    8000119e:	00b609b3          	add	s3,a2,a1
    800011a2:	6b05                	lui	s6,0x1
    800011a4:	0535f963          	bgeu	a1,s3,800011f6 <uvmunmap+0x78>
    800011a8:	f426                	sd	s1,40(sp)
    800011aa:	a015                	j	800011ce <uvmunmap+0x50>
    800011ac:	f426                	sd	s1,40(sp)
    800011ae:	f04a                	sd	s2,32(sp)
    800011b0:	ec4e                	sd	s3,24(sp)
    800011b2:	e852                	sd	s4,16(sp)
    800011b4:	e456                	sd	s5,8(sp)
    800011b6:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    800011b8:	00006517          	auipc	a0,0x6
    800011bc:	f6850513          	addi	a0,a0,-152 # 80007120 <etext+0x120>
    800011c0:	e14ff0ef          	jal	800007d4 <panic>
      continue;
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    800011c4:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800011c8:	995a                	add	s2,s2,s6
    800011ca:	03397563          	bgeu	s2,s3,800011f4 <uvmunmap+0x76>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800011ce:	4601                	li	a2,0
    800011d0:	85ca                	mv	a1,s2
    800011d2:	8552                	mv	a0,s4
    800011d4:	d07ff0ef          	jal	80000eda <walk>
    800011d8:	84aa                	mv	s1,a0
    800011da:	d57d                	beqz	a0,800011c8 <uvmunmap+0x4a>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    800011dc:	611c                	ld	a5,0(a0)
    800011de:	0017f713          	andi	a4,a5,1
    800011e2:	d37d                	beqz	a4,800011c8 <uvmunmap+0x4a>
    if (do_free) {
    800011e4:	fe0a80e3          	beqz	s5,800011c4 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    800011e8:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    800011ea:	00c79513          	slli	a0,a5,0xc
    800011ee:	80dff0ef          	jal	800009fa <kfree>
    800011f2:	bfc9                	j	800011c4 <uvmunmap+0x46>
    800011f4:	74a2                	ld	s1,40(sp)
    800011f6:	7902                	ld	s2,32(sp)
    800011f8:	69e2                	ld	s3,24(sp)
    800011fa:	6a42                	ld	s4,16(sp)
    800011fc:	6aa2                	ld	s5,8(sp)
    800011fe:	6b02                	ld	s6,0(sp)
  }
}
    80001200:	70e2                	ld	ra,56(sp)
    80001202:	7442                	ld	s0,48(sp)
    80001204:	6121                	addi	sp,sp,64
    80001206:	8082                	ret

0000000080001208 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001208:	1101                	addi	sp,sp,-32
    8000120a:	ec06                	sd	ra,24(sp)
    8000120c:	e822                	sd	s0,16(sp)
    8000120e:	e426                	sd	s1,8(sp)
    80001210:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80001212:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    80001214:	00b67d63          	bgeu	a2,a1,8000122e <uvmdealloc+0x26>
    80001218:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    8000121a:	6785                	lui	a5,0x1
    8000121c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000121e:	00f60733          	add	a4,a2,a5
    80001222:	76fd                	lui	a3,0xfffff
    80001224:	8f75                	and	a4,a4,a3
    80001226:	97ae                	add	a5,a5,a1
    80001228:	8ff5                	and	a5,a5,a3
    8000122a:	00f76863          	bltu	a4,a5,8000123a <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000122e:	8526                	mv	a0,s1
    80001230:	60e2                	ld	ra,24(sp)
    80001232:	6442                	ld	s0,16(sp)
    80001234:	64a2                	ld	s1,8(sp)
    80001236:	6105                	addi	sp,sp,32
    80001238:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000123a:	8f99                	sub	a5,a5,a4
    8000123c:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000123e:	4685                	li	a3,1
    80001240:	0007861b          	sext.w	a2,a5
    80001244:	85ba                	mv	a1,a4
    80001246:	f39ff0ef          	jal	8000117e <uvmunmap>
    8000124a:	b7d5                	j	8000122e <uvmdealloc+0x26>

000000008000124c <uvmalloc>:
  if (newsz < oldsz)
    8000124c:	08b66f63          	bltu	a2,a1,800012ea <uvmalloc+0x9e>
{
    80001250:	7139                	addi	sp,sp,-64
    80001252:	fc06                	sd	ra,56(sp)
    80001254:	f822                	sd	s0,48(sp)
    80001256:	ec4e                	sd	s3,24(sp)
    80001258:	e852                	sd	s4,16(sp)
    8000125a:	e456                	sd	s5,8(sp)
    8000125c:	0080                	addi	s0,sp,64
    8000125e:	8aaa                	mv	s5,a0
    80001260:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001262:	6785                	lui	a5,0x1
    80001264:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001266:	95be                	add	a1,a1,a5
    80001268:	77fd                	lui	a5,0xfffff
    8000126a:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    8000126e:	08c9f063          	bgeu	s3,a2,800012ee <uvmalloc+0xa2>
    80001272:	f426                	sd	s1,40(sp)
    80001274:	f04a                	sd	s2,32(sp)
    80001276:	e05a                	sd	s6,0(sp)
    80001278:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    8000127a:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000127e:	85fff0ef          	jal	80000adc <kalloc>
    80001282:	84aa                	mv	s1,a0
    if (mem == 0) {
    80001284:	c515                	beqz	a0,800012b0 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001286:	6605                	lui	a2,0x1
    80001288:	4581                	li	a1,0
    8000128a:	9ddff0ef          	jal	80000c66 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    8000128e:	875a                	mv	a4,s6
    80001290:	86a6                	mv	a3,s1
    80001292:	6605                	lui	a2,0x1
    80001294:	85ca                	mv	a1,s2
    80001296:	8556                	mv	a0,s5
    80001298:	d1bff0ef          	jal	80000fb2 <mappages>
    8000129c:	e915                	bnez	a0,800012d0 <uvmalloc+0x84>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    8000129e:	6785                	lui	a5,0x1
    800012a0:	993e                	add	s2,s2,a5
    800012a2:	fd496ee3          	bltu	s2,s4,8000127e <uvmalloc+0x32>
  return newsz;
    800012a6:	8552                	mv	a0,s4
    800012a8:	74a2                	ld	s1,40(sp)
    800012aa:	7902                	ld	s2,32(sp)
    800012ac:	6b02                	ld	s6,0(sp)
    800012ae:	a811                	j	800012c2 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800012b0:	864e                	mv	a2,s3
    800012b2:	85ca                	mv	a1,s2
    800012b4:	8556                	mv	a0,s5
    800012b6:	f53ff0ef          	jal	80001208 <uvmdealloc>
      return 0;
    800012ba:	4501                	li	a0,0
    800012bc:	74a2                	ld	s1,40(sp)
    800012be:	7902                	ld	s2,32(sp)
    800012c0:	6b02                	ld	s6,0(sp)
}
    800012c2:	70e2                	ld	ra,56(sp)
    800012c4:	7442                	ld	s0,48(sp)
    800012c6:	69e2                	ld	s3,24(sp)
    800012c8:	6a42                	ld	s4,16(sp)
    800012ca:	6aa2                	ld	s5,8(sp)
    800012cc:	6121                	addi	sp,sp,64
    800012ce:	8082                	ret
      kfree(mem);
    800012d0:	8526                	mv	a0,s1
    800012d2:	f28ff0ef          	jal	800009fa <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800012d6:	864e                	mv	a2,s3
    800012d8:	85ca                	mv	a1,s2
    800012da:	8556                	mv	a0,s5
    800012dc:	f2dff0ef          	jal	80001208 <uvmdealloc>
      return 0;
    800012e0:	4501                	li	a0,0
    800012e2:	74a2                	ld	s1,40(sp)
    800012e4:	7902                	ld	s2,32(sp)
    800012e6:	6b02                	ld	s6,0(sp)
    800012e8:	bfe9                	j	800012c2 <uvmalloc+0x76>
    return oldsz;
    800012ea:	852e                	mv	a0,a1
}
    800012ec:	8082                	ret
  return newsz;
    800012ee:	8532                	mv	a0,a2
    800012f0:	bfc9                	j	800012c2 <uvmalloc+0x76>

00000000800012f2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800012f2:	7179                	addi	sp,sp,-48
    800012f4:	f406                	sd	ra,40(sp)
    800012f6:	f022                	sd	s0,32(sp)
    800012f8:	ec26                	sd	s1,24(sp)
    800012fa:	e84a                	sd	s2,16(sp)
    800012fc:	e44e                	sd	s3,8(sp)
    800012fe:	e052                	sd	s4,0(sp)
    80001300:	1800                	addi	s0,sp,48
    80001302:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80001304:	84aa                	mv	s1,a0
    80001306:	6905                	lui	s2,0x1
    80001308:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8000130a:	4985                	li	s3,1
    8000130c:	a819                	j	80001322 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000130e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001310:	00c79513          	slli	a0,a5,0xc
    80001314:	fdfff0ef          	jal	800012f2 <freewalk>
      pagetable[i] = 0;
    80001318:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    8000131c:	04a1                	addi	s1,s1,8
    8000131e:	01248f63          	beq	s1,s2,8000133c <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001322:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001324:	00f7f713          	andi	a4,a5,15
    80001328:	ff3703e3          	beq	a4,s3,8000130e <freewalk+0x1c>
    } else if (pte & PTE_V) {
    8000132c:	8b85                	andi	a5,a5,1
    8000132e:	d7fd                	beqz	a5,8000131c <freewalk+0x2a>
      panic("freewalk: leaf");
    80001330:	00006517          	auipc	a0,0x6
    80001334:	e0850513          	addi	a0,a0,-504 # 80007138 <etext+0x138>
    80001338:	c9cff0ef          	jal	800007d4 <panic>
    }
  }
  kfree((void *)pagetable);
    8000133c:	8552                	mv	a0,s4
    8000133e:	ebcff0ef          	jal	800009fa <kfree>
}
    80001342:	70a2                	ld	ra,40(sp)
    80001344:	7402                	ld	s0,32(sp)
    80001346:	64e2                	ld	s1,24(sp)
    80001348:	6942                	ld	s2,16(sp)
    8000134a:	69a2                	ld	s3,8(sp)
    8000134c:	6a02                	ld	s4,0(sp)
    8000134e:	6145                	addi	sp,sp,48
    80001350:	8082                	ret

0000000080001352 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001352:	1101                	addi	sp,sp,-32
    80001354:	ec06                	sd	ra,24(sp)
    80001356:	e822                	sd	s0,16(sp)
    80001358:	e426                	sd	s1,8(sp)
    8000135a:	1000                	addi	s0,sp,32
    8000135c:	84aa                	mv	s1,a0
  if (sz > 0)
    8000135e:	e989                	bnez	a1,80001370 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80001360:	8526                	mv	a0,s1
    80001362:	f91ff0ef          	jal	800012f2 <freewalk>
}
    80001366:	60e2                	ld	ra,24(sp)
    80001368:	6442                	ld	s0,16(sp)
    8000136a:	64a2                	ld	s1,8(sp)
    8000136c:	6105                	addi	sp,sp,32
    8000136e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80001370:	6785                	lui	a5,0x1
    80001372:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001374:	95be                	add	a1,a1,a5
    80001376:	4685                	li	a3,1
    80001378:	00c5d613          	srli	a2,a1,0xc
    8000137c:	4581                	li	a1,0
    8000137e:	e01ff0ef          	jal	8000117e <uvmunmap>
    80001382:	bff9                	j	80001360 <uvmfree+0xe>

0000000080001384 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    80001384:	ce49                	beqz	a2,8000141e <uvmcopy+0x9a>
{
    80001386:	715d                	addi	sp,sp,-80
    80001388:	e486                	sd	ra,72(sp)
    8000138a:	e0a2                	sd	s0,64(sp)
    8000138c:	fc26                	sd	s1,56(sp)
    8000138e:	f84a                	sd	s2,48(sp)
    80001390:	f44e                	sd	s3,40(sp)
    80001392:	f052                	sd	s4,32(sp)
    80001394:	ec56                	sd	s5,24(sp)
    80001396:	e85a                	sd	s6,16(sp)
    80001398:	e45e                	sd	s7,8(sp)
    8000139a:	0880                	addi	s0,sp,80
    8000139c:	8aaa                	mv	s5,a0
    8000139e:	8b2e                	mv	s6,a1
    800013a0:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE) {
    800013a2:	4481                	li	s1,0
    800013a4:	a029                	j	800013ae <uvmcopy+0x2a>
    800013a6:	6785                	lui	a5,0x1
    800013a8:	94be                	add	s1,s1,a5
    800013aa:	0544fe63          	bgeu	s1,s4,80001406 <uvmcopy+0x82>
    if ((pte = walk(old, i, 0)) == 0)
    800013ae:	4601                	li	a2,0
    800013b0:	85a6                	mv	a1,s1
    800013b2:	8556                	mv	a0,s5
    800013b4:	b27ff0ef          	jal	80000eda <walk>
    800013b8:	d57d                	beqz	a0,800013a6 <uvmcopy+0x22>
      continue; // page table entry hasn't been allocated
    if ((*pte & PTE_V) == 0)
    800013ba:	6118                	ld	a4,0(a0)
    800013bc:	00177793          	andi	a5,a4,1
    800013c0:	d3fd                	beqz	a5,800013a6 <uvmcopy+0x22>
      continue; // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    800013c2:	00a75593          	srli	a1,a4,0xa
    800013c6:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800013ca:	3ff77913          	andi	s2,a4,1023
    if ((mem = kalloc()) == 0)
    800013ce:	f0eff0ef          	jal	80000adc <kalloc>
    800013d2:	89aa                	mv	s3,a0
    800013d4:	c105                	beqz	a0,800013f4 <uvmcopy+0x70>
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    800013d6:	6605                	lui	a2,0x1
    800013d8:	85de                	mv	a1,s7
    800013da:	8e9ff0ef          	jal	80000cc2 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    800013de:	874a                	mv	a4,s2
    800013e0:	86ce                	mv	a3,s3
    800013e2:	6605                	lui	a2,0x1
    800013e4:	85a6                	mv	a1,s1
    800013e6:	855a                	mv	a0,s6
    800013e8:	bcbff0ef          	jal	80000fb2 <mappages>
    800013ec:	dd4d                	beqz	a0,800013a6 <uvmcopy+0x22>
      kfree(mem);
    800013ee:	854e                	mv	a0,s3
    800013f0:	e0aff0ef          	jal	800009fa <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800013f4:	4685                	li	a3,1
    800013f6:	00c4d613          	srli	a2,s1,0xc
    800013fa:	4581                	li	a1,0
    800013fc:	855a                	mv	a0,s6
    800013fe:	d81ff0ef          	jal	8000117e <uvmunmap>
  return -1;
    80001402:	557d                	li	a0,-1
    80001404:	a011                	j	80001408 <uvmcopy+0x84>
  return 0;
    80001406:	4501                	li	a0,0
}
    80001408:	60a6                	ld	ra,72(sp)
    8000140a:	6406                	ld	s0,64(sp)
    8000140c:	74e2                	ld	s1,56(sp)
    8000140e:	7942                	ld	s2,48(sp)
    80001410:	79a2                	ld	s3,40(sp)
    80001412:	7a02                	ld	s4,32(sp)
    80001414:	6ae2                	ld	s5,24(sp)
    80001416:	6b42                	ld	s6,16(sp)
    80001418:	6ba2                	ld	s7,8(sp)
    8000141a:	6161                	addi	sp,sp,80
    8000141c:	8082                	ret
  return 0;
    8000141e:	4501                	li	a0,0
}
    80001420:	8082                	ret

0000000080001422 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001422:	1141                	addi	sp,sp,-16
    80001424:	e406                	sd	ra,8(sp)
    80001426:	e022                	sd	s0,0(sp)
    80001428:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    8000142a:	4601                	li	a2,0
    8000142c:	aafff0ef          	jal	80000eda <walk>
  if (pte == 0)
    80001430:	c901                	beqz	a0,80001440 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001432:	611c                	ld	a5,0(a0)
    80001434:	9bbd                	andi	a5,a5,-17
    80001436:	e11c                	sd	a5,0(a0)
}
    80001438:	60a2                	ld	ra,8(sp)
    8000143a:	6402                	ld	s0,0(sp)
    8000143c:	0141                	addi	sp,sp,16
    8000143e:	8082                	ret
    panic("uvmclear");
    80001440:	00006517          	auipc	a0,0x6
    80001444:	d0850513          	addi	a0,a0,-760 # 80007148 <etext+0x148>
    80001448:	b8cff0ef          	jal	800007d4 <panic>

000000008000144c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    8000144c:	c6dd                	beqz	a3,800014fa <copyinstr+0xae>
{
    8000144e:	715d                	addi	sp,sp,-80
    80001450:	e486                	sd	ra,72(sp)
    80001452:	e0a2                	sd	s0,64(sp)
    80001454:	fc26                	sd	s1,56(sp)
    80001456:	f84a                	sd	s2,48(sp)
    80001458:	f44e                	sd	s3,40(sp)
    8000145a:	f052                	sd	s4,32(sp)
    8000145c:	ec56                	sd	s5,24(sp)
    8000145e:	e85a                	sd	s6,16(sp)
    80001460:	e45e                	sd	s7,8(sp)
    80001462:	0880                	addi	s0,sp,80
    80001464:	8a2a                	mv	s4,a0
    80001466:	8b2e                	mv	s6,a1
    80001468:	8bb2                	mv	s7,a2
    8000146a:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    8000146c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000146e:	6985                	lui	s3,0x1
    80001470:	a825                	j	800014a8 <copyinstr+0x5c>
      n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80001472:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001476:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80001478:	37fd                	addiw	a5,a5,-1
    8000147a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000147e:	60a6                	ld	ra,72(sp)
    80001480:	6406                	ld	s0,64(sp)
    80001482:	74e2                	ld	s1,56(sp)
    80001484:	7942                	ld	s2,48(sp)
    80001486:	79a2                	ld	s3,40(sp)
    80001488:	7a02                	ld	s4,32(sp)
    8000148a:	6ae2                	ld	s5,24(sp)
    8000148c:	6b42                	ld	s6,16(sp)
    8000148e:	6ba2                	ld	s7,8(sp)
    80001490:	6161                	addi	sp,sp,80
    80001492:	8082                	ret
    80001494:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80001498:	9742                	add	a4,a4,a6
      --max;
    8000149a:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    8000149e:	01348bb3          	add	s7,s1,s3
  while (got_null == 0 && max > 0) {
    800014a2:	04e58463          	beq	a1,a4,800014ea <copyinstr+0x9e>
{
    800014a6:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    800014a8:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800014ac:	85a6                	mv	a1,s1
    800014ae:	8552                	mv	a0,s4
    800014b0:	ac5ff0ef          	jal	80000f74 <walkaddr>
    if (pa0 == 0)
    800014b4:	cd0d                	beqz	a0,800014ee <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800014b6:	417486b3          	sub	a3,s1,s7
    800014ba:	96ce                	add	a3,a3,s3
    if (n > max)
    800014bc:	00d97363          	bgeu	s2,a3,800014c2 <copyinstr+0x76>
    800014c0:	86ca                	mv	a3,s2
    char *p = (char *)(pa0 + (srcva - va0));
    800014c2:	955e                	add	a0,a0,s7
    800014c4:	8d05                	sub	a0,a0,s1
    while (n > 0) {
    800014c6:	c695                	beqz	a3,800014f2 <copyinstr+0xa6>
    800014c8:	87da                	mv	a5,s6
    800014ca:	885a                	mv	a6,s6
      if (*p == '\0') {
    800014cc:	41650633          	sub	a2,a0,s6
    while (n > 0) {
    800014d0:	96da                	add	a3,a3,s6
    800014d2:	85be                	mv	a1,a5
      if (*p == '\0') {
    800014d4:	00f60733          	add	a4,a2,a5
    800014d8:	00074703          	lbu	a4,0(a4)
    800014dc:	db59                	beqz	a4,80001472 <copyinstr+0x26>
        *dst = *p;
    800014de:	00e78023          	sb	a4,0(a5)
      dst++;
    800014e2:	0785                	addi	a5,a5,1
    while (n > 0) {
    800014e4:	fed797e3          	bne	a5,a3,800014d2 <copyinstr+0x86>
    800014e8:	b775                	j	80001494 <copyinstr+0x48>
    800014ea:	4781                	li	a5,0
    800014ec:	b771                	j	80001478 <copyinstr+0x2c>
      return -1;
    800014ee:	557d                	li	a0,-1
    800014f0:	b779                	j	8000147e <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    800014f2:	6b85                	lui	s7,0x1
    800014f4:	9ba6                	add	s7,s7,s1
    800014f6:	87da                	mv	a5,s6
    800014f8:	b77d                	j	800014a6 <copyinstr+0x5a>
  int got_null = 0;
    800014fa:	4781                	li	a5,0
  if (got_null) {
    800014fc:	37fd                	addiw	a5,a5,-1
    800014fe:	0007851b          	sext.w	a0,a5
}
    80001502:	8082                	ret

0000000080001504 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001504:	1141                	addi	sp,sp,-16
    80001506:	e406                	sd	ra,8(sp)
    80001508:	e022                	sd	s0,0(sp)
    8000150a:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    8000150c:	4601                	li	a2,0
    8000150e:	9cdff0ef          	jal	80000eda <walk>
  if (pte == 0) {
    80001512:	c519                	beqz	a0,80001520 <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V) {
    80001514:	6108                	ld	a0,0(a0)
    80001516:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80001518:	60a2                	ld	ra,8(sp)
    8000151a:	6402                	ld	s0,0(sp)
    8000151c:	0141                	addi	sp,sp,16
    8000151e:	8082                	ret
    return 0;
    80001520:	4501                	li	a0,0
    80001522:	bfdd                	j	80001518 <ismapped+0x14>

0000000080001524 <vmfault>:
{
    80001524:	7179                	addi	sp,sp,-48
    80001526:	f406                	sd	ra,40(sp)
    80001528:	f022                	sd	s0,32(sp)
    8000152a:	ec26                	sd	s1,24(sp)
    8000152c:	e44e                	sd	s3,8(sp)
    8000152e:	1800                	addi	s0,sp,48
    80001530:	89aa                	mv	s3,a0
    80001532:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    80001534:	35e000ef          	jal	80001892 <myproc>
  if (va >= p->sz)
    80001538:	653c                	ld	a5,72(a0)
    8000153a:	00f4ea63          	bltu	s1,a5,8000154e <vmfault+0x2a>
    return 0;
    8000153e:	4981                	li	s3,0
}
    80001540:	854e                	mv	a0,s3
    80001542:	70a2                	ld	ra,40(sp)
    80001544:	7402                	ld	s0,32(sp)
    80001546:	64e2                	ld	s1,24(sp)
    80001548:	69a2                	ld	s3,8(sp)
    8000154a:	6145                	addi	sp,sp,48
    8000154c:	8082                	ret
    8000154e:	e84a                	sd	s2,16(sp)
    80001550:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    80001552:	77fd                	lui	a5,0xfffff
    80001554:	8cfd                	and	s1,s1,a5
  if (ismapped(pagetable, va)) {
    80001556:	85a6                	mv	a1,s1
    80001558:	854e                	mv	a0,s3
    8000155a:	fabff0ef          	jal	80001504 <ismapped>
    return 0;
    8000155e:	4981                	li	s3,0
  if (ismapped(pagetable, va)) {
    80001560:	c119                	beqz	a0,80001566 <vmfault+0x42>
    80001562:	6942                	ld	s2,16(sp)
    80001564:	bff1                	j	80001540 <vmfault+0x1c>
    80001566:	e052                	sd	s4,0(sp)
  mem = (uint64)kalloc();
    80001568:	d74ff0ef          	jal	80000adc <kalloc>
    8000156c:	8a2a                	mv	s4,a0
  if (mem == 0)
    8000156e:	c90d                	beqz	a0,800015a0 <vmfault+0x7c>
  mem = (uint64)kalloc();
    80001570:	89aa                	mv	s3,a0
  memset((void *)mem, 0, PGSIZE);
    80001572:	6605                	lui	a2,0x1
    80001574:	4581                	li	a1,0
    80001576:	ef0ff0ef          	jal	80000c66 <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    8000157a:	4759                	li	a4,22
    8000157c:	86d2                	mv	a3,s4
    8000157e:	6605                	lui	a2,0x1
    80001580:	85a6                	mv	a1,s1
    80001582:	05093503          	ld	a0,80(s2)
    80001586:	a2dff0ef          	jal	80000fb2 <mappages>
    8000158a:	e501                	bnez	a0,80001592 <vmfault+0x6e>
    8000158c:	6942                	ld	s2,16(sp)
    8000158e:	6a02                	ld	s4,0(sp)
    80001590:	bf45                	j	80001540 <vmfault+0x1c>
    kfree((void *)mem);
    80001592:	8552                	mv	a0,s4
    80001594:	c66ff0ef          	jal	800009fa <kfree>
    return 0;
    80001598:	4981                	li	s3,0
    8000159a:	6942                	ld	s2,16(sp)
    8000159c:	6a02                	ld	s4,0(sp)
    8000159e:	b74d                	j	80001540 <vmfault+0x1c>
    800015a0:	6942                	ld	s2,16(sp)
    800015a2:	6a02                	ld	s4,0(sp)
    800015a4:	bf71                	j	80001540 <vmfault+0x1c>

00000000800015a6 <copyout>:
  while (len > 0) {
    800015a6:	c2cd                	beqz	a3,80001648 <copyout+0xa2>
{
    800015a8:	711d                	addi	sp,sp,-96
    800015aa:	ec86                	sd	ra,88(sp)
    800015ac:	e8a2                	sd	s0,80(sp)
    800015ae:	e4a6                	sd	s1,72(sp)
    800015b0:	f852                	sd	s4,48(sp)
    800015b2:	f05a                	sd	s6,32(sp)
    800015b4:	ec5e                	sd	s7,24(sp)
    800015b6:	e862                	sd	s8,16(sp)
    800015b8:	1080                	addi	s0,sp,96
    800015ba:	8c2a                	mv	s8,a0
    800015bc:	8b2e                	mv	s6,a1
    800015be:	8bb2                	mv	s7,a2
    800015c0:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    800015c2:	74fd                	lui	s1,0xfffff
    800015c4:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    800015c6:	57fd                	li	a5,-1
    800015c8:	83e9                	srli	a5,a5,0x1a
    800015ca:	0897e163          	bltu	a5,s1,8000164c <copyout+0xa6>
    800015ce:	e0ca                	sd	s2,64(sp)
    800015d0:	fc4e                	sd	s3,56(sp)
    800015d2:	f456                	sd	s5,40(sp)
    800015d4:	e466                	sd	s9,8(sp)
    800015d6:	e06a                	sd	s10,0(sp)
    800015d8:	6d05                	lui	s10,0x1
    800015da:	8cbe                	mv	s9,a5
    800015dc:	a015                	j	80001600 <copyout+0x5a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015de:	409b0533          	sub	a0,s6,s1
    800015e2:	0009861b          	sext.w	a2,s3
    800015e6:	85de                	mv	a1,s7
    800015e8:	954a                	add	a0,a0,s2
    800015ea:	ed8ff0ef          	jal	80000cc2 <memmove>
    len -= n;
    800015ee:	413a0a33          	sub	s4,s4,s3
    src += n;
    800015f2:	9bce                	add	s7,s7,s3
  while (len > 0) {
    800015f4:	040a0363          	beqz	s4,8000163a <copyout+0x94>
    if (va0 >= MAXVA)
    800015f8:	055cec63          	bltu	s9,s5,80001650 <copyout+0xaa>
    800015fc:	84d6                	mv	s1,s5
    800015fe:	8b56                	mv	s6,s5
    pa0 = walkaddr(pagetable, va0);
    80001600:	85a6                	mv	a1,s1
    80001602:	8562                	mv	a0,s8
    80001604:	971ff0ef          	jal	80000f74 <walkaddr>
    80001608:	892a                	mv	s2,a0
    if (pa0 == 0) {
    8000160a:	e901                	bnez	a0,8000161a <copyout+0x74>
      if ((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    8000160c:	4601                	li	a2,0
    8000160e:	85a6                	mv	a1,s1
    80001610:	8562                	mv	a0,s8
    80001612:	f13ff0ef          	jal	80001524 <vmfault>
    80001616:	892a                	mv	s2,a0
    80001618:	c139                	beqz	a0,8000165e <copyout+0xb8>
    pte = walk(pagetable, va0, 0);
    8000161a:	4601                	li	a2,0
    8000161c:	85a6                	mv	a1,s1
    8000161e:	8562                	mv	a0,s8
    80001620:	8bbff0ef          	jal	80000eda <walk>
    if ((*pte & PTE_W) == 0)
    80001624:	611c                	ld	a5,0(a0)
    80001626:	8b91                	andi	a5,a5,4
    80001628:	c3b1                	beqz	a5,8000166c <copyout+0xc6>
    n = PGSIZE - (dstva - va0);
    8000162a:	01a48ab3          	add	s5,s1,s10
    8000162e:	416a89b3          	sub	s3,s5,s6
    if (n > len)
    80001632:	fb3a76e3          	bgeu	s4,s3,800015de <copyout+0x38>
    80001636:	89d2                	mv	s3,s4
    80001638:	b75d                	j	800015de <copyout+0x38>
  return 0;
    8000163a:	4501                	li	a0,0
    8000163c:	6906                	ld	s2,64(sp)
    8000163e:	79e2                	ld	s3,56(sp)
    80001640:	7aa2                	ld	s5,40(sp)
    80001642:	6ca2                	ld	s9,8(sp)
    80001644:	6d02                	ld	s10,0(sp)
    80001646:	a80d                	j	80001678 <copyout+0xd2>
    80001648:	4501                	li	a0,0
}
    8000164a:	8082                	ret
      return -1;
    8000164c:	557d                	li	a0,-1
    8000164e:	a02d                	j	80001678 <copyout+0xd2>
    80001650:	557d                	li	a0,-1
    80001652:	6906                	ld	s2,64(sp)
    80001654:	79e2                	ld	s3,56(sp)
    80001656:	7aa2                	ld	s5,40(sp)
    80001658:	6ca2                	ld	s9,8(sp)
    8000165a:	6d02                	ld	s10,0(sp)
    8000165c:	a831                	j	80001678 <copyout+0xd2>
        return -1;
    8000165e:	557d                	li	a0,-1
    80001660:	6906                	ld	s2,64(sp)
    80001662:	79e2                	ld	s3,56(sp)
    80001664:	7aa2                	ld	s5,40(sp)
    80001666:	6ca2                	ld	s9,8(sp)
    80001668:	6d02                	ld	s10,0(sp)
    8000166a:	a039                	j	80001678 <copyout+0xd2>
      return -1;
    8000166c:	557d                	li	a0,-1
    8000166e:	6906                	ld	s2,64(sp)
    80001670:	79e2                	ld	s3,56(sp)
    80001672:	7aa2                	ld	s5,40(sp)
    80001674:	6ca2                	ld	s9,8(sp)
    80001676:	6d02                	ld	s10,0(sp)
}
    80001678:	60e6                	ld	ra,88(sp)
    8000167a:	6446                	ld	s0,80(sp)
    8000167c:	64a6                	ld	s1,72(sp)
    8000167e:	7a42                	ld	s4,48(sp)
    80001680:	7b02                	ld	s6,32(sp)
    80001682:	6be2                	ld	s7,24(sp)
    80001684:	6c42                	ld	s8,16(sp)
    80001686:	6125                	addi	sp,sp,96
    80001688:	8082                	ret

000000008000168a <copyin>:
  while (len > 0) {
    8000168a:	c6c9                	beqz	a3,80001714 <copyin+0x8a>
{
    8000168c:	715d                	addi	sp,sp,-80
    8000168e:	e486                	sd	ra,72(sp)
    80001690:	e0a2                	sd	s0,64(sp)
    80001692:	fc26                	sd	s1,56(sp)
    80001694:	f84a                	sd	s2,48(sp)
    80001696:	f44e                	sd	s3,40(sp)
    80001698:	f052                	sd	s4,32(sp)
    8000169a:	ec56                	sd	s5,24(sp)
    8000169c:	e85a                	sd	s6,16(sp)
    8000169e:	e45e                	sd	s7,8(sp)
    800016a0:	e062                	sd	s8,0(sp)
    800016a2:	0880                	addi	s0,sp,80
    800016a4:	8baa                	mv	s7,a0
    800016a6:	8aae                	mv	s5,a1
    800016a8:	8932                	mv	s2,a2
    800016aa:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    800016ac:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    800016ae:	6b05                	lui	s6,0x1
    800016b0:	a035                	j	800016dc <copyin+0x52>
    800016b2:	412984b3          	sub	s1,s3,s2
    800016b6:	94da                	add	s1,s1,s6
    if (n > len)
    800016b8:	009a7363          	bgeu	s4,s1,800016be <copyin+0x34>
    800016bc:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800016be:	413905b3          	sub	a1,s2,s3
    800016c2:	0004861b          	sext.w	a2,s1
    800016c6:	95aa                	add	a1,a1,a0
    800016c8:	8556                	mv	a0,s5
    800016ca:	df8ff0ef          	jal	80000cc2 <memmove>
    len -= n;
    800016ce:	409a0a33          	sub	s4,s4,s1
    dst += n;
    800016d2:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    800016d4:	01698933          	add	s2,s3,s6
  while (len > 0) {
    800016d8:	020a0163          	beqz	s4,800016fa <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    800016dc:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    800016e0:	85ce                	mv	a1,s3
    800016e2:	855e                	mv	a0,s7
    800016e4:	891ff0ef          	jal	80000f74 <walkaddr>
    if (pa0 == 0) {
    800016e8:	f569                	bnez	a0,800016b2 <copyin+0x28>
      if ((pa0 = vmfault(pagetable, va0, 1)) == 0) {
    800016ea:	4605                	li	a2,1
    800016ec:	85ce                	mv	a1,s3
    800016ee:	855e                	mv	a0,s7
    800016f0:	e35ff0ef          	jal	80001524 <vmfault>
    800016f4:	fd5d                	bnez	a0,800016b2 <copyin+0x28>
        return -1;
    800016f6:	557d                	li	a0,-1
    800016f8:	a011                	j	800016fc <copyin+0x72>
  return 0;
    800016fa:	4501                	li	a0,0
}
    800016fc:	60a6                	ld	ra,72(sp)
    800016fe:	6406                	ld	s0,64(sp)
    80001700:	74e2                	ld	s1,56(sp)
    80001702:	7942                	ld	s2,48(sp)
    80001704:	79a2                	ld	s3,40(sp)
    80001706:	7a02                	ld	s4,32(sp)
    80001708:	6ae2                	ld	s5,24(sp)
    8000170a:	6b42                	ld	s6,16(sp)
    8000170c:	6ba2                	ld	s7,8(sp)
    8000170e:	6c02                	ld	s8,0(sp)
    80001710:	6161                	addi	sp,sp,80
    80001712:	8082                	ret
  return 0;
    80001714:	4501                	li	a0,0
}
    80001716:	8082                	ret

0000000080001718 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001718:	7139                	addi	sp,sp,-64
    8000171a:	fc06                	sd	ra,56(sp)
    8000171c:	f822                	sd	s0,48(sp)
    8000171e:	f426                	sd	s1,40(sp)
    80001720:	f04a                	sd	s2,32(sp)
    80001722:	ec4e                	sd	s3,24(sp)
    80001724:	e852                	sd	s4,16(sp)
    80001726:	e456                	sd	s5,8(sp)
    80001728:	e05a                	sd	s6,0(sp)
    8000172a:	0080                	addi	s0,sp,64
    8000172c:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    8000172e:	00011497          	auipc	s1,0x11
    80001732:	09a48493          	addi	s1,s1,154 # 800127c8 <proc>
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001736:	8b26                	mv	s6,s1
    80001738:	faaab937          	lui	s2,0xfaaab
    8000173c:	aab90913          	addi	s2,s2,-1365 # fffffffffaaaaaab <end+0xffffffff7aa86f03>
    80001740:	0932                	slli	s2,s2,0xc
    80001742:	aab90913          	addi	s2,s2,-1365
    80001746:	0932                	slli	s2,s2,0xc
    80001748:	aab90913          	addi	s2,s2,-1365
    8000174c:	0932                	slli	s2,s2,0xc
    8000174e:	aab90913          	addi	s2,s2,-1365
    80001752:	040009b7          	lui	s3,0x4000
    80001756:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001758:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    8000175a:	00017a97          	auipc	s5,0x17
    8000175e:	06ea8a93          	addi	s5,s5,110 # 800187c8 <tickslock>
    char *pa = kalloc();
    80001762:	b7aff0ef          	jal	80000adc <kalloc>
    80001766:	862a                	mv	a2,a0
    if (pa == 0)
    80001768:	cd15                	beqz	a0,800017a4 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int)(p - proc));
    8000176a:	416485b3          	sub	a1,s1,s6
    8000176e:	859d                	srai	a1,a1,0x7
    80001770:	032585b3          	mul	a1,a1,s2
    80001774:	2585                	addiw	a1,a1,1
    80001776:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000177a:	4719                	li	a4,6
    8000177c:	6685                	lui	a3,0x1
    8000177e:	40b985b3          	sub	a1,s3,a1
    80001782:	8552                	mv	a0,s4
    80001784:	8dfff0ef          	jal	80001062 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001788:	18048493          	addi	s1,s1,384
    8000178c:	fd549be3          	bne	s1,s5,80001762 <proc_mapstacks+0x4a>
  }
}
    80001790:	70e2                	ld	ra,56(sp)
    80001792:	7442                	ld	s0,48(sp)
    80001794:	74a2                	ld	s1,40(sp)
    80001796:	7902                	ld	s2,32(sp)
    80001798:	69e2                	ld	s3,24(sp)
    8000179a:	6a42                	ld	s4,16(sp)
    8000179c:	6aa2                	ld	s5,8(sp)
    8000179e:	6b02                	ld	s6,0(sp)
    800017a0:	6121                	addi	sp,sp,64
    800017a2:	8082                	ret
      panic("kalloc");
    800017a4:	00006517          	auipc	a0,0x6
    800017a8:	9b450513          	addi	a0,a0,-1612 # 80007158 <etext+0x158>
    800017ac:	828ff0ef          	jal	800007d4 <panic>

00000000800017b0 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800017b0:	7139                	addi	sp,sp,-64
    800017b2:	fc06                	sd	ra,56(sp)
    800017b4:	f822                	sd	s0,48(sp)
    800017b6:	f426                	sd	s1,40(sp)
    800017b8:	f04a                	sd	s2,32(sp)
    800017ba:	ec4e                	sd	s3,24(sp)
    800017bc:	e852                	sd	s4,16(sp)
    800017be:	e456                	sd	s5,8(sp)
    800017c0:	e05a                	sd	s6,0(sp)
    800017c2:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    800017c4:	00006597          	auipc	a1,0x6
    800017c8:	99c58593          	addi	a1,a1,-1636 # 80007160 <etext+0x160>
    800017cc:	00011517          	auipc	a0,0x11
    800017d0:	bcc50513          	addi	a0,a0,-1076 # 80012398 <pid_lock>
    800017d4:	b58ff0ef          	jal	80000b2c <initlock>
  initlock(&wait_lock, "wait_lock");
    800017d8:	00006597          	auipc	a1,0x6
    800017dc:	99058593          	addi	a1,a1,-1648 # 80007168 <etext+0x168>
    800017e0:	00011517          	auipc	a0,0x11
    800017e4:	bd050513          	addi	a0,a0,-1072 # 800123b0 <wait_lock>
    800017e8:	b44ff0ef          	jal	80000b2c <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    800017ec:	00011497          	auipc	s1,0x11
    800017f0:	fdc48493          	addi	s1,s1,-36 # 800127c8 <proc>
    initlock(&p->lock, "proc");
    800017f4:	00006b17          	auipc	s6,0x6
    800017f8:	984b0b13          	addi	s6,s6,-1660 # 80007178 <etext+0x178>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    800017fc:	8aa6                	mv	s5,s1
    800017fe:	faaab937          	lui	s2,0xfaaab
    80001802:	aab90913          	addi	s2,s2,-1365 # fffffffffaaaaaab <end+0xffffffff7aa86f03>
    80001806:	0932                	slli	s2,s2,0xc
    80001808:	aab90913          	addi	s2,s2,-1365
    8000180c:	0932                	slli	s2,s2,0xc
    8000180e:	aab90913          	addi	s2,s2,-1365
    80001812:	0932                	slli	s2,s2,0xc
    80001814:	aab90913          	addi	s2,s2,-1365
    80001818:	040009b7          	lui	s3,0x4000
    8000181c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000181e:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001820:	00017a17          	auipc	s4,0x17
    80001824:	fa8a0a13          	addi	s4,s4,-88 # 800187c8 <tickslock>
    initlock(&p->lock, "proc");
    80001828:	85da                	mv	a1,s6
    8000182a:	8526                	mv	a0,s1
    8000182c:	b00ff0ef          	jal	80000b2c <initlock>
    p->state = UNUSED;
    80001830:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001834:	415487b3          	sub	a5,s1,s5
    80001838:	879d                	srai	a5,a5,0x7
    8000183a:	032787b3          	mul	a5,a5,s2
    8000183e:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffdb459>
    80001840:	00d7979b          	slliw	a5,a5,0xd
    80001844:	40f987b3          	sub	a5,s3,a5
    80001848:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    8000184a:	18048493          	addi	s1,s1,384
    8000184e:	fd449de3          	bne	s1,s4,80001828 <procinit+0x78>
  }
}
    80001852:	70e2                	ld	ra,56(sp)
    80001854:	7442                	ld	s0,48(sp)
    80001856:	74a2                	ld	s1,40(sp)
    80001858:	7902                	ld	s2,32(sp)
    8000185a:	69e2                	ld	s3,24(sp)
    8000185c:	6a42                	ld	s4,16(sp)
    8000185e:	6aa2                	ld	s5,8(sp)
    80001860:	6b02                	ld	s6,0(sp)
    80001862:	6121                	addi	sp,sp,64
    80001864:	8082                	ret

0000000080001866 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001866:	1141                	addi	sp,sp,-16
    80001868:	e422                	sd	s0,8(sp)
    8000186a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    8000186c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000186e:	2501                	sext.w	a0,a0
    80001870:	6422                	ld	s0,8(sp)
    80001872:	0141                	addi	sp,sp,16
    80001874:	8082                	ret

0000000080001876 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001876:	1141                	addi	sp,sp,-16
    80001878:	e422                	sd	s0,8(sp)
    8000187a:	0800                	addi	s0,sp,16
    8000187c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000187e:	2781                	sext.w	a5,a5
    80001880:	079e                	slli	a5,a5,0x7
  return c;
}
    80001882:	00011517          	auipc	a0,0x11
    80001886:	b4650513          	addi	a0,a0,-1210 # 800123c8 <cpus>
    8000188a:	953e                	add	a0,a0,a5
    8000188c:	6422                	ld	s0,8(sp)
    8000188e:	0141                	addi	sp,sp,16
    80001890:	8082                	ret

0000000080001892 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001892:	1101                	addi	sp,sp,-32
    80001894:	ec06                	sd	ra,24(sp)
    80001896:	e822                	sd	s0,16(sp)
    80001898:	e426                	sd	s1,8(sp)
    8000189a:	1000                	addi	s0,sp,32
  push_off();
    8000189c:	ad0ff0ef          	jal	80000b6c <push_off>
    800018a0:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018a2:	2781                	sext.w	a5,a5
    800018a4:	079e                	slli	a5,a5,0x7
    800018a6:	00011717          	auipc	a4,0x11
    800018aa:	af270713          	addi	a4,a4,-1294 # 80012398 <pid_lock>
    800018ae:	97ba                	add	a5,a5,a4
    800018b0:	7b84                	ld	s1,48(a5)
  pop_off();
    800018b2:	b30ff0ef          	jal	80000be2 <pop_off>
  return p;
}
    800018b6:	8526                	mv	a0,s1
    800018b8:	60e2                	ld	ra,24(sp)
    800018ba:	6442                	ld	s0,16(sp)
    800018bc:	64a2                	ld	s1,8(sp)
    800018be:	6105                	addi	sp,sp,32
    800018c0:	8082                	ret

00000000800018c2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800018c2:	7179                	addi	sp,sp,-48
    800018c4:	f406                	sd	ra,40(sp)
    800018c6:	f022                	sd	s0,32(sp)
    800018c8:	ec26                	sd	s1,24(sp)
    800018ca:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    800018cc:	fc7ff0ef          	jal	80001892 <myproc>
    800018d0:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    800018d2:	b5cff0ef          	jal	80000c2e <release>

  if (first) {
    800018d6:	00009797          	auipc	a5,0x9
    800018da:	96a7a783          	lw	a5,-1686(a5) # 8000a240 <first.1>
    800018de:	cf8d                	beqz	a5,80001918 <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    800018e0:	4505                	li	a0,1
    800018e2:	537010ef          	jal	80003618 <fsinit>

    first = 0;
    800018e6:	00009797          	auipc	a5,0x9
    800018ea:	9407ad23          	sw	zero,-1702(a5) # 8000a240 <first.1>
    // ensure other cores see first=0.
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    800018ee:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    800018f2:	00006517          	auipc	a0,0x6
    800018f6:	88e50513          	addi	a0,a0,-1906 # 80007180 <etext+0x180>
    800018fa:	fca43823          	sd	a0,-48(s0)
    800018fe:	fc043c23          	sd	zero,-40(s0)
    80001902:	fd040593          	addi	a1,s0,-48
    80001906:	685020ef          	jal	8000478a <kexec>
    8000190a:	6cbc                	ld	a5,88(s1)
    8000190c:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    8000190e:	6cbc                	ld	a5,88(s1)
    80001910:	7bb8                	ld	a4,112(a5)
    80001912:	57fd                	li	a5,-1
    80001914:	02f70d63          	beq	a4,a5,8000194e <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001918:	379000ef          	jal	80002490 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    8000191c:	68a8                	ld	a0,80(s1)
    8000191e:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001920:	04000737          	lui	a4,0x4000
    80001924:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001926:	0732                	slli	a4,a4,0xc
    80001928:	00004797          	auipc	a5,0x4
    8000192c:	77478793          	addi	a5,a5,1908 # 8000609c <userret>
    80001930:	00004697          	auipc	a3,0x4
    80001934:	6d068693          	addi	a3,a3,1744 # 80006000 <_trampoline>
    80001938:	8f95                	sub	a5,a5,a3
    8000193a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000193c:	577d                	li	a4,-1
    8000193e:	177e                	slli	a4,a4,0x3f
    80001940:	8d59                	or	a0,a0,a4
    80001942:	9782                	jalr	a5
}
    80001944:	70a2                	ld	ra,40(sp)
    80001946:	7402                	ld	s0,32(sp)
    80001948:	64e2                	ld	s1,24(sp)
    8000194a:	6145                	addi	sp,sp,48
    8000194c:	8082                	ret
      panic("exec");
    8000194e:	00006517          	auipc	a0,0x6
    80001952:	83a50513          	addi	a0,a0,-1990 # 80007188 <etext+0x188>
    80001956:	e7ffe0ef          	jal	800007d4 <panic>

000000008000195a <allocpid>:
{
    8000195a:	1101                	addi	sp,sp,-32
    8000195c:	ec06                	sd	ra,24(sp)
    8000195e:	e822                	sd	s0,16(sp)
    80001960:	e426                	sd	s1,8(sp)
    80001962:	e04a                	sd	s2,0(sp)
    80001964:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001966:	00011917          	auipc	s2,0x11
    8000196a:	a3290913          	addi	s2,s2,-1486 # 80012398 <pid_lock>
    8000196e:	854a                	mv	a0,s2
    80001970:	a32ff0ef          	jal	80000ba2 <acquire>
  pid = nextpid;
    80001974:	00009797          	auipc	a5,0x9
    80001978:	8d078793          	addi	a5,a5,-1840 # 8000a244 <nextpid>
    8000197c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000197e:	0014871b          	addiw	a4,s1,1
    80001982:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001984:	854a                	mv	a0,s2
    80001986:	aa8ff0ef          	jal	80000c2e <release>
}
    8000198a:	8526                	mv	a0,s1
    8000198c:	60e2                	ld	ra,24(sp)
    8000198e:	6442                	ld	s0,16(sp)
    80001990:	64a2                	ld	s1,8(sp)
    80001992:	6902                	ld	s2,0(sp)
    80001994:	6105                	addi	sp,sp,32
    80001996:	8082                	ret

0000000080001998 <update_time>:
{
    80001998:	7179                	addi	sp,sp,-48
    8000199a:	f406                	sd	ra,40(sp)
    8000199c:	f022                	sd	s0,32(sp)
    8000199e:	ec26                	sd	s1,24(sp)
    800019a0:	e84a                	sd	s2,16(sp)
    800019a2:	e44e                	sd	s3,8(sp)
    800019a4:	e052                	sd	s4,0(sp)
    800019a6:	1800                	addi	s0,sp,48
  for (p = proc; p < &proc[NPROC]; p++) {
    800019a8:	00011497          	auipc	s1,0x11
    800019ac:	e2048493          	addi	s1,s1,-480 # 800127c8 <proc>
    if (p->state == RUNNING) p->rtime++;
    800019b0:	4991                	li	s3,4
    else if (p->state == RUNNABLE) p->wtime++;
    800019b2:	4a0d                	li	s4,3
  for (p = proc; p < &proc[NPROC]; p++) {
    800019b4:	00017917          	auipc	s2,0x17
    800019b8:	e1490913          	addi	s2,s2,-492 # 800187c8 <tickslock>
    800019bc:	a829                	j	800019d6 <update_time+0x3e>
    if (p->state == RUNNING) p->rtime++;
    800019be:	16c4a783          	lw	a5,364(s1)
    800019c2:	2785                	addiw	a5,a5,1
    800019c4:	16f4a623          	sw	a5,364(s1)
    release(&p->lock);
    800019c8:	8526                	mv	a0,s1
    800019ca:	a64ff0ef          	jal	80000c2e <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800019ce:	18048493          	addi	s1,s1,384
    800019d2:	03248063          	beq	s1,s2,800019f2 <update_time+0x5a>
    acquire(&p->lock);
    800019d6:	8526                	mv	a0,s1
    800019d8:	9caff0ef          	jal	80000ba2 <acquire>
    if (p->state == RUNNING) p->rtime++;
    800019dc:	4c9c                	lw	a5,24(s1)
    800019de:	ff3780e3          	beq	a5,s3,800019be <update_time+0x26>
    else if (p->state == RUNNABLE) p->wtime++;
    800019e2:	ff4793e3          	bne	a5,s4,800019c8 <update_time+0x30>
    800019e6:	1704a783          	lw	a5,368(s1)
    800019ea:	2785                	addiw	a5,a5,1
    800019ec:	16f4a823          	sw	a5,368(s1)
    800019f0:	bfe1                	j	800019c8 <update_time+0x30>
}
    800019f2:	70a2                	ld	ra,40(sp)
    800019f4:	7402                	ld	s0,32(sp)
    800019f6:	64e2                	ld	s1,24(sp)
    800019f8:	6942                	ld	s2,16(sp)
    800019fa:	69a2                	ld	s3,8(sp)
    800019fc:	6a02                	ld	s4,0(sp)
    800019fe:	6145                	addi	sp,sp,48
    80001a00:	8082                	ret

0000000080001a02 <proc_pagetable>:
{
    80001a02:	1101                	addi	sp,sp,-32
    80001a04:	ec06                	sd	ra,24(sp)
    80001a06:	e822                	sd	s0,16(sp)
    80001a08:	e426                	sd	s1,8(sp)
    80001a0a:	e04a                	sd	s2,0(sp)
    80001a0c:	1000                	addi	s0,sp,32
    80001a0e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a10:	f48ff0ef          	jal	80001158 <uvmcreate>
    80001a14:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001a16:	cd05                	beqz	a0,80001a4e <proc_pagetable+0x4c>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001a18:	4729                	li	a4,10
    80001a1a:	00004697          	auipc	a3,0x4
    80001a1e:	5e668693          	addi	a3,a3,1510 # 80006000 <_trampoline>
    80001a22:	6605                	lui	a2,0x1
    80001a24:	040005b7          	lui	a1,0x4000
    80001a28:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a2a:	05b2                	slli	a1,a1,0xc
    80001a2c:	d86ff0ef          	jal	80000fb2 <mappages>
    80001a30:	02054663          	bltz	a0,80001a5c <proc_pagetable+0x5a>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001a34:	4719                	li	a4,6
    80001a36:	05893683          	ld	a3,88(s2)
    80001a3a:	6605                	lui	a2,0x1
    80001a3c:	020005b7          	lui	a1,0x2000
    80001a40:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a42:	05b6                	slli	a1,a1,0xd
    80001a44:	8526                	mv	a0,s1
    80001a46:	d6cff0ef          	jal	80000fb2 <mappages>
    80001a4a:	00054f63          	bltz	a0,80001a68 <proc_pagetable+0x66>
}
    80001a4e:	8526                	mv	a0,s1
    80001a50:	60e2                	ld	ra,24(sp)
    80001a52:	6442                	ld	s0,16(sp)
    80001a54:	64a2                	ld	s1,8(sp)
    80001a56:	6902                	ld	s2,0(sp)
    80001a58:	6105                	addi	sp,sp,32
    80001a5a:	8082                	ret
    uvmfree(pagetable, 0);
    80001a5c:	4581                	li	a1,0
    80001a5e:	8526                	mv	a0,s1
    80001a60:	8f3ff0ef          	jal	80001352 <uvmfree>
    return 0;
    80001a64:	4481                	li	s1,0
    80001a66:	b7e5                	j	80001a4e <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a68:	4681                	li	a3,0
    80001a6a:	4605                	li	a2,1
    80001a6c:	040005b7          	lui	a1,0x4000
    80001a70:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a72:	05b2                	slli	a1,a1,0xc
    80001a74:	8526                	mv	a0,s1
    80001a76:	f08ff0ef          	jal	8000117e <uvmunmap>
    uvmfree(pagetable, 0);
    80001a7a:	4581                	li	a1,0
    80001a7c:	8526                	mv	a0,s1
    80001a7e:	8d5ff0ef          	jal	80001352 <uvmfree>
    return 0;
    80001a82:	4481                	li	s1,0
    80001a84:	b7e9                	j	80001a4e <proc_pagetable+0x4c>

0000000080001a86 <proc_freepagetable>:
{
    80001a86:	1101                	addi	sp,sp,-32
    80001a88:	ec06                	sd	ra,24(sp)
    80001a8a:	e822                	sd	s0,16(sp)
    80001a8c:	e426                	sd	s1,8(sp)
    80001a8e:	e04a                	sd	s2,0(sp)
    80001a90:	1000                	addi	s0,sp,32
    80001a92:	84aa                	mv	s1,a0
    80001a94:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a96:	4681                	li	a3,0
    80001a98:	4605                	li	a2,1
    80001a9a:	040005b7          	lui	a1,0x4000
    80001a9e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001aa0:	05b2                	slli	a1,a1,0xc
    80001aa2:	edcff0ef          	jal	8000117e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001aa6:	4681                	li	a3,0
    80001aa8:	4605                	li	a2,1
    80001aaa:	020005b7          	lui	a1,0x2000
    80001aae:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ab0:	05b6                	slli	a1,a1,0xd
    80001ab2:	8526                	mv	a0,s1
    80001ab4:	ecaff0ef          	jal	8000117e <uvmunmap>
  uvmfree(pagetable, sz);
    80001ab8:	85ca                	mv	a1,s2
    80001aba:	8526                	mv	a0,s1
    80001abc:	897ff0ef          	jal	80001352 <uvmfree>
}
    80001ac0:	60e2                	ld	ra,24(sp)
    80001ac2:	6442                	ld	s0,16(sp)
    80001ac4:	64a2                	ld	s1,8(sp)
    80001ac6:	6902                	ld	s2,0(sp)
    80001ac8:	6105                	addi	sp,sp,32
    80001aca:	8082                	ret

0000000080001acc <freeproc>:
{
    80001acc:	1101                	addi	sp,sp,-32
    80001ace:	ec06                	sd	ra,24(sp)
    80001ad0:	e822                	sd	s0,16(sp)
    80001ad2:	e426                	sd	s1,8(sp)
    80001ad4:	1000                	addi	s0,sp,32
    80001ad6:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001ad8:	6d28                	ld	a0,88(a0)
    80001ada:	c119                	beqz	a0,80001ae0 <freeproc+0x14>
    kfree((void *)p->trapframe);
    80001adc:	f1ffe0ef          	jal	800009fa <kfree>
  p->trapframe = 0;
    80001ae0:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001ae4:	68a8                	ld	a0,80(s1)
    80001ae6:	c501                	beqz	a0,80001aee <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001ae8:	64ac                	ld	a1,72(s1)
    80001aea:	f9dff0ef          	jal	80001a86 <proc_freepagetable>
  p->pagetable = 0;
    80001aee:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001af2:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001af6:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001afa:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001afe:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b02:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b06:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b0a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b0e:	0004ac23          	sw	zero,24(s1)
}
    80001b12:	60e2                	ld	ra,24(sp)
    80001b14:	6442                	ld	s0,16(sp)
    80001b16:	64a2                	ld	s1,8(sp)
    80001b18:	6105                	addi	sp,sp,32
    80001b1a:	8082                	ret

0000000080001b1c <allocproc>:
{
    80001b1c:	1101                	addi	sp,sp,-32
    80001b1e:	ec06                	sd	ra,24(sp)
    80001b20:	e822                	sd	s0,16(sp)
    80001b22:	e426                	sd	s1,8(sp)
    80001b24:	e04a                	sd	s2,0(sp)
    80001b26:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b28:	00011497          	auipc	s1,0x11
    80001b2c:	ca048493          	addi	s1,s1,-864 # 800127c8 <proc>
    80001b30:	00017917          	auipc	s2,0x17
    80001b34:	c9890913          	addi	s2,s2,-872 # 800187c8 <tickslock>
    acquire(&p->lock);
    80001b38:	8526                	mv	a0,s1
    80001b3a:	868ff0ef          	jal	80000ba2 <acquire>
    if (p->state == UNUSED) {
    80001b3e:	4c9c                	lw	a5,24(s1)
    80001b40:	cb91                	beqz	a5,80001b54 <allocproc+0x38>
      release(&p->lock);
    80001b42:	8526                	mv	a0,s1
    80001b44:	8eaff0ef          	jal	80000c2e <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b48:	18048493          	addi	s1,s1,384
    80001b4c:	ff2496e3          	bne	s1,s2,80001b38 <allocproc+0x1c>
  return 0;
    80001b50:	4481                	li	s1,0
    80001b52:	a8a9                	j	80001bac <allocproc+0x90>
  p->pid = allocpid();
    80001b54:	e07ff0ef          	jal	8000195a <allocpid>
    80001b58:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b5a:	4785                	li	a5,1
    80001b5c:	cc9c                	sw	a5,24(s1)
  p->ctime = ticks;     // Tick de criação
    80001b5e:	00008797          	auipc	a5,0x8
    80001b62:	73a7a783          	lw	a5,1850(a5) # 8000a298 <ticks>
    80001b66:	16f4a423          	sw	a5,360(s1)
  p->rtime = 0;  // Ticks acumulados rodando (RUNNING)
    80001b6a:	1604a623          	sw	zero,364(s1)
  p->wtime = 0;  // Ticks acumulados em espera (RUNNABLE)
    80001b6e:	1604a823          	sw	zero,368(s1)
  p->burst = 0;  // Escalonador trata como desconhecido = 0
    80001b72:	1604ac23          	sw	zero,376(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001b76:	f67fe0ef          	jal	80000adc <kalloc>
    80001b7a:	892a                	mv	s2,a0
    80001b7c:	eca8                	sd	a0,88(s1)
    80001b7e:	cd15                	beqz	a0,80001bba <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001b80:	8526                	mv	a0,s1
    80001b82:	e81ff0ef          	jal	80001a02 <proc_pagetable>
    80001b86:	892a                	mv	s2,a0
    80001b88:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    80001b8a:	c121                	beqz	a0,80001bca <allocproc+0xae>
  memset(&p->context, 0, sizeof(p->context));
    80001b8c:	07000613          	li	a2,112
    80001b90:	4581                	li	a1,0
    80001b92:	06048513          	addi	a0,s1,96
    80001b96:	8d0ff0ef          	jal	80000c66 <memset>
  p->context.ra = (uint64)forkret;
    80001b9a:	00000797          	auipc	a5,0x0
    80001b9e:	d2878793          	addi	a5,a5,-728 # 800018c2 <forkret>
    80001ba2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001ba4:	60bc                	ld	a5,64(s1)
    80001ba6:	6705                	lui	a4,0x1
    80001ba8:	97ba                	add	a5,a5,a4
    80001baa:	f4bc                	sd	a5,104(s1)
}
    80001bac:	8526                	mv	a0,s1
    80001bae:	60e2                	ld	ra,24(sp)
    80001bb0:	6442                	ld	s0,16(sp)
    80001bb2:	64a2                	ld	s1,8(sp)
    80001bb4:	6902                	ld	s2,0(sp)
    80001bb6:	6105                	addi	sp,sp,32
    80001bb8:	8082                	ret
    freeproc(p);
    80001bba:	8526                	mv	a0,s1
    80001bbc:	f11ff0ef          	jal	80001acc <freeproc>
    release(&p->lock);
    80001bc0:	8526                	mv	a0,s1
    80001bc2:	86cff0ef          	jal	80000c2e <release>
    return 0;
    80001bc6:	84ca                	mv	s1,s2
    80001bc8:	b7d5                	j	80001bac <allocproc+0x90>
    freeproc(p);
    80001bca:	8526                	mv	a0,s1
    80001bcc:	f01ff0ef          	jal	80001acc <freeproc>
    release(&p->lock);
    80001bd0:	8526                	mv	a0,s1
    80001bd2:	85cff0ef          	jal	80000c2e <release>
    return 0;
    80001bd6:	84ca                	mv	s1,s2
    80001bd8:	bfd1                	j	80001bac <allocproc+0x90>

0000000080001bda <userinit>:
{
    80001bda:	1101                	addi	sp,sp,-32
    80001bdc:	ec06                	sd	ra,24(sp)
    80001bde:	e822                	sd	s0,16(sp)
    80001be0:	e426                	sd	s1,8(sp)
    80001be2:	1000                	addi	s0,sp,32
  p = allocproc();
    80001be4:	f39ff0ef          	jal	80001b1c <allocproc>
    80001be8:	84aa                	mv	s1,a0
  initproc = p;
    80001bea:	00008797          	auipc	a5,0x8
    80001bee:	6aa7b323          	sd	a0,1702(a5) # 8000a290 <initproc>
  p->cwd = namei("/");
    80001bf2:	00005517          	auipc	a0,0x5
    80001bf6:	59e50513          	addi	a0,a0,1438 # 80007190 <etext+0x190>
    80001bfa:	741010ef          	jal	80003b3a <namei>
    80001bfe:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001c02:	478d                	li	a5,3
    80001c04:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c06:	8526                	mv	a0,s1
    80001c08:	826ff0ef          	jal	80000c2e <release>
}
    80001c0c:	60e2                	ld	ra,24(sp)
    80001c0e:	6442                	ld	s0,16(sp)
    80001c10:	64a2                	ld	s1,8(sp)
    80001c12:	6105                	addi	sp,sp,32
    80001c14:	8082                	ret

0000000080001c16 <growproc>:
{
    80001c16:	1101                	addi	sp,sp,-32
    80001c18:	ec06                	sd	ra,24(sp)
    80001c1a:	e822                	sd	s0,16(sp)
    80001c1c:	e426                	sd	s1,8(sp)
    80001c1e:	e04a                	sd	s2,0(sp)
    80001c20:	1000                	addi	s0,sp,32
    80001c22:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c24:	c6fff0ef          	jal	80001892 <myproc>
    80001c28:	892a                	mv	s2,a0
  sz = p->sz;
    80001c2a:	652c                	ld	a1,72(a0)
  if (n > 0) {
    80001c2c:	02905963          	blez	s1,80001c5e <growproc+0x48>
    if (sz + n > TRAPFRAME) {
    80001c30:	00b48633          	add	a2,s1,a1
    80001c34:	020007b7          	lui	a5,0x2000
    80001c38:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c3a:	07b6                	slli	a5,a5,0xd
    80001c3c:	02c7ea63          	bltu	a5,a2,80001c70 <growproc+0x5a>
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c40:	4691                	li	a3,4
    80001c42:	6928                	ld	a0,80(a0)
    80001c44:	e08ff0ef          	jal	8000124c <uvmalloc>
    80001c48:	85aa                	mv	a1,a0
    80001c4a:	c50d                	beqz	a0,80001c74 <growproc+0x5e>
  p->sz = sz;
    80001c4c:	04b93423          	sd	a1,72(s2)
  return 0;
    80001c50:	4501                	li	a0,0
}
    80001c52:	60e2                	ld	ra,24(sp)
    80001c54:	6442                	ld	s0,16(sp)
    80001c56:	64a2                	ld	s1,8(sp)
    80001c58:	6902                	ld	s2,0(sp)
    80001c5a:	6105                	addi	sp,sp,32
    80001c5c:	8082                	ret
  } else if (n < 0) {
    80001c5e:	fe04d7e3          	bgez	s1,80001c4c <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c62:	00b48633          	add	a2,s1,a1
    80001c66:	6928                	ld	a0,80(a0)
    80001c68:	da0ff0ef          	jal	80001208 <uvmdealloc>
    80001c6c:	85aa                	mv	a1,a0
    80001c6e:	bff9                	j	80001c4c <growproc+0x36>
      return -1;
    80001c70:	557d                	li	a0,-1
    80001c72:	b7c5                	j	80001c52 <growproc+0x3c>
      return -1;
    80001c74:	557d                	li	a0,-1
    80001c76:	bff1                	j	80001c52 <growproc+0x3c>

0000000080001c78 <kfork>:
{
    80001c78:	7139                	addi	sp,sp,-64
    80001c7a:	fc06                	sd	ra,56(sp)
    80001c7c:	f822                	sd	s0,48(sp)
    80001c7e:	f04a                	sd	s2,32(sp)
    80001c80:	e456                	sd	s5,8(sp)
    80001c82:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c84:	c0fff0ef          	jal	80001892 <myproc>
    80001c88:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001c8a:	e93ff0ef          	jal	80001b1c <allocproc>
    80001c8e:	0e050a63          	beqz	a0,80001d82 <kfork+0x10a>
    80001c92:	e852                	sd	s4,16(sp)
    80001c94:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001c96:	048ab603          	ld	a2,72(s5)
    80001c9a:	692c                	ld	a1,80(a0)
    80001c9c:	050ab503          	ld	a0,80(s5)
    80001ca0:	ee4ff0ef          	jal	80001384 <uvmcopy>
    80001ca4:	04054a63          	bltz	a0,80001cf8 <kfork+0x80>
    80001ca8:	f426                	sd	s1,40(sp)
    80001caa:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001cac:	048ab783          	ld	a5,72(s5)
    80001cb0:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001cb4:	058ab683          	ld	a3,88(s5)
    80001cb8:	87b6                	mv	a5,a3
    80001cba:	058a3703          	ld	a4,88(s4)
    80001cbe:	12068693          	addi	a3,a3,288
    80001cc2:	0007b803          	ld	a6,0(a5)
    80001cc6:	6788                	ld	a0,8(a5)
    80001cc8:	6b8c                	ld	a1,16(a5)
    80001cca:	6f90                	ld	a2,24(a5)
    80001ccc:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001cd0:	e708                	sd	a0,8(a4)
    80001cd2:	eb0c                	sd	a1,16(a4)
    80001cd4:	ef10                	sd	a2,24(a4)
    80001cd6:	02078793          	addi	a5,a5,32
    80001cda:	02070713          	addi	a4,a4,32
    80001cde:	fed792e3          	bne	a5,a3,80001cc2 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001ce2:	058a3783          	ld	a5,88(s4)
    80001ce6:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001cea:	0d0a8493          	addi	s1,s5,208
    80001cee:	0d0a0913          	addi	s2,s4,208
    80001cf2:	150a8993          	addi	s3,s5,336
    80001cf6:	a831                	j	80001d12 <kfork+0x9a>
    freeproc(np);
    80001cf8:	8552                	mv	a0,s4
    80001cfa:	dd3ff0ef          	jal	80001acc <freeproc>
    release(&np->lock);
    80001cfe:	8552                	mv	a0,s4
    80001d00:	f2ffe0ef          	jal	80000c2e <release>
    return -1;
    80001d04:	597d                	li	s2,-1
    80001d06:	6a42                	ld	s4,16(sp)
    80001d08:	a0b5                	j	80001d74 <kfork+0xfc>
  for (i = 0; i < NOFILE; i++)
    80001d0a:	04a1                	addi	s1,s1,8
    80001d0c:	0921                	addi	s2,s2,8
    80001d0e:	01348963          	beq	s1,s3,80001d20 <kfork+0xa8>
    if (p->ofile[i])
    80001d12:	6088                	ld	a0,0(s1)
    80001d14:	d97d                	beqz	a0,80001d0a <kfork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d16:	426020ef          	jal	8000413c <filedup>
    80001d1a:	00a93023          	sd	a0,0(s2)
    80001d1e:	b7f5                	j	80001d0a <kfork+0x92>
  np->cwd = idup(p->cwd);
    80001d20:	150ab503          	ld	a0,336(s5)
    80001d24:	5ca010ef          	jal	800032ee <idup>
    80001d28:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d2c:	4641                	li	a2,16
    80001d2e:	158a8593          	addi	a1,s5,344
    80001d32:	158a0513          	addi	a0,s4,344
    80001d36:	86eff0ef          	jal	80000da4 <safestrcpy>
  pid = np->pid;
    80001d3a:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001d3e:	8552                	mv	a0,s4
    80001d40:	eeffe0ef          	jal	80000c2e <release>
  acquire(&wait_lock);
    80001d44:	00010497          	auipc	s1,0x10
    80001d48:	66c48493          	addi	s1,s1,1644 # 800123b0 <wait_lock>
    80001d4c:	8526                	mv	a0,s1
    80001d4e:	e55fe0ef          	jal	80000ba2 <acquire>
  np->parent = p;
    80001d52:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001d56:	8526                	mv	a0,s1
    80001d58:	ed7fe0ef          	jal	80000c2e <release>
  acquire(&np->lock);
    80001d5c:	8552                	mv	a0,s4
    80001d5e:	e45fe0ef          	jal	80000ba2 <acquire>
  np->state = RUNNABLE;
    80001d62:	478d                	li	a5,3
    80001d64:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d68:	8552                	mv	a0,s4
    80001d6a:	ec5fe0ef          	jal	80000c2e <release>
  return pid;
    80001d6e:	74a2                	ld	s1,40(sp)
    80001d70:	69e2                	ld	s3,24(sp)
    80001d72:	6a42                	ld	s4,16(sp)
}
    80001d74:	854a                	mv	a0,s2
    80001d76:	70e2                	ld	ra,56(sp)
    80001d78:	7442                	ld	s0,48(sp)
    80001d7a:	7902                	ld	s2,32(sp)
    80001d7c:	6aa2                	ld	s5,8(sp)
    80001d7e:	6121                	addi	sp,sp,64
    80001d80:	8082                	ret
    return -1;
    80001d82:	597d                	li	s2,-1
    80001d84:	bfc5                	j	80001d74 <kfork+0xfc>

0000000080001d86 <scheduler>:
{
    80001d86:	711d                	addi	sp,sp,-96
    80001d88:	ec86                	sd	ra,88(sp)
    80001d8a:	e8a2                	sd	s0,80(sp)
    80001d8c:	e4a6                	sd	s1,72(sp)
    80001d8e:	e0ca                	sd	s2,64(sp)
    80001d90:	fc4e                	sd	s3,56(sp)
    80001d92:	f852                	sd	s4,48(sp)
    80001d94:	f456                	sd	s5,40(sp)
    80001d96:	f05a                	sd	s6,32(sp)
    80001d98:	ec5e                	sd	s7,24(sp)
    80001d9a:	e862                	sd	s8,16(sp)
    80001d9c:	e466                	sd	s9,8(sp)
    80001d9e:	1080                	addi	s0,sp,96
    80001da0:	8792                	mv	a5,tp
  int id = r_tp();
    80001da2:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001da4:	00779c93          	slli	s9,a5,0x7
    80001da8:	00010717          	auipc	a4,0x10
    80001dac:	5f070713          	addi	a4,a4,1520 # 80012398 <pid_lock>
    80001db0:	9766                	add	a4,a4,s9
    80001db2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &chosen->context);
    80001db6:	00010717          	auipc	a4,0x10
    80001dba:	61a70713          	addi	a4,a4,1562 # 800123d0 <cpus+0x8>
    80001dbe:	9cba                	add	s9,s9,a4
    int best_remaining = 2147483647;
    80001dc0:	80000b37          	lui	s6,0x80000
    80001dc4:	fffb4b13          	not	s6,s6
    struct proc *chosen = 0;
    80001dc8:	4b81                	li	s7,0
      if(p->state == RUNNABLE) {
    80001dca:	490d                	li	s2,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dcc:	00017997          	auipc	s3,0x17
    80001dd0:	9fc98993          	addi	s3,s3,-1540 # 800187c8 <tickslock>
        c->proc = chosen;
    80001dd4:	079e                	slli	a5,a5,0x7
    80001dd6:	00010c17          	auipc	s8,0x10
    80001dda:	5c2c0c13          	addi	s8,s8,1474 # 80012398 <pid_lock>
    80001dde:	9c3e                	add	s8,s8,a5
    80001de0:	a00d                	j	80001e02 <scheduler+0x7c>
    if (chosen != 0) {
    80001de2:	000a0c63          	beqz	s4,80001dfa <scheduler+0x74>
      acquire(&chosen->lock);
    80001de6:	8552                	mv	a0,s4
    80001de8:	dbbfe0ef          	jal	80000ba2 <acquire>
      if (chosen->state == RUNNABLE) {
    80001dec:	018a2783          	lw	a5,24(s4)
    80001df0:	03278263          	beq	a5,s2,80001e14 <scheduler+0x8e>
      release(&chosen->lock);
    80001df4:	8552                	mv	a0,s4
    80001df6:	e39fe0ef          	jal	80000c2e <release>
  __asm__ __volatile__("csrs sstatus, %0" ::
    80001dfa:	10016073          	csrsi	sstatus,2
      asm volatile("wfi");
    80001dfe:	10500073          	wfi
    80001e02:	10016073          	csrsi	sstatus,2
    int best_remaining = 2147483647;
    80001e06:	8ada                	mv	s5,s6
    struct proc *chosen = 0;
    80001e08:	8a5e                	mv	s4,s7
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e0a:	00011497          	auipc	s1,0x11
    80001e0e:	9be48493          	addi	s1,s1,-1602 # 800127c8 <proc>
    80001e12:	a82d                	j	80001e4c <scheduler+0xc6>
        chosen->state = RUNNING;
    80001e14:	4791                	li	a5,4
    80001e16:	00fa2c23          	sw	a5,24(s4)
        c->proc = chosen;
    80001e1a:	034c3823          	sd	s4,48(s8)
        swtch(&c->context, &chosen->context);
    80001e1e:	060a0593          	addi	a1,s4,96
    80001e22:	8566                	mv	a0,s9
    80001e24:	5c6000ef          	jal	800023ea <swtch>
        c->proc = 0;
    80001e28:	020c3823          	sd	zero,48(s8)
      release(&chosen->lock);
    80001e2c:	8552                	mv	a0,s4
    80001e2e:	e01fe0ef          	jal	80000c2e <release>
    if (found == 0) {
    80001e32:	bfc1                	j	80001e02 <scheduler+0x7c>
        if (chosen == 0 || remaining < best_remaining) {
    80001e34:	000a1563          	bnez	s4,80001e3e <scheduler+0xb8>
          remaining = 2147483647;
    80001e38:	87da                	mv	a5,s6
          best_remaining = remaining;
    80001e3a:	8abe                	mv	s5,a5
          chosen = p;
    80001e3c:	8a26                	mv	s4,s1
      release(&p->lock);
    80001e3e:	8526                	mv	a0,s1
    80001e40:	deffe0ef          	jal	80000c2e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e44:	18048493          	addi	s1,s1,384
    80001e48:	f9348de3          	beq	s1,s3,80001de2 <scheduler+0x5c>
      acquire(&p->lock);
    80001e4c:	8526                	mv	a0,s1
    80001e4e:	d55fe0ef          	jal	80000ba2 <acquire>
      if(p->state == RUNNABLE) {
    80001e52:	4c9c                	lw	a5,24(s1)
    80001e54:	ff2795e3          	bne	a5,s2,80001e3e <scheduler+0xb8>
        if (p->burst > 0)
    80001e58:	1784a783          	lw	a5,376(s1)
    80001e5c:	fcf05ce3          	blez	a5,80001e34 <scheduler+0xae>
          remaining = p->burst - p->rtime;
    80001e60:	16c4a703          	lw	a4,364(s1)
    80001e64:	9f99                	subw	a5,a5,a4
        if (chosen == 0 || remaining < best_remaining) {
    80001e66:	fc0a0ae3          	beqz	s4,80001e3a <scheduler+0xb4>
    80001e6a:	fd57c8e3          	blt	a5,s5,80001e3a <scheduler+0xb4>
    80001e6e:	bfc1                	j	80001e3e <scheduler+0xb8>

0000000080001e70 <sched>:
{
    80001e70:	7179                	addi	sp,sp,-48
    80001e72:	f406                	sd	ra,40(sp)
    80001e74:	f022                	sd	s0,32(sp)
    80001e76:	ec26                	sd	s1,24(sp)
    80001e78:	e84a                	sd	s2,16(sp)
    80001e7a:	e44e                	sd	s3,8(sp)
    80001e7c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e7e:	a15ff0ef          	jal	80001892 <myproc>
    80001e82:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001e84:	cbffe0ef          	jal	80000b42 <holding>
    80001e88:	c92d                	beqz	a0,80001efa <sched+0x8a>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e8a:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001e8c:	2781                	sext.w	a5,a5
    80001e8e:	079e                	slli	a5,a5,0x7
    80001e90:	00010717          	auipc	a4,0x10
    80001e94:	50870713          	addi	a4,a4,1288 # 80012398 <pid_lock>
    80001e98:	97ba                	add	a5,a5,a4
    80001e9a:	0a87a703          	lw	a4,168(a5)
    80001e9e:	4785                	li	a5,1
    80001ea0:	06f71363          	bne	a4,a5,80001f06 <sched+0x96>
  if (p->state == RUNNING)
    80001ea4:	4c98                	lw	a4,24(s1)
    80001ea6:	4791                	li	a5,4
    80001ea8:	06f70563          	beq	a4,a5,80001f12 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001eac:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001eb0:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001eb2:	e7b5                	bnez	a5,80001f1e <sched+0xae>
  asm volatile("mv %0, tp" : "=r"(x));
    80001eb4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001eb6:	00010917          	auipc	s2,0x10
    80001eba:	4e290913          	addi	s2,s2,1250 # 80012398 <pid_lock>
    80001ebe:	2781                	sext.w	a5,a5
    80001ec0:	079e                	slli	a5,a5,0x7
    80001ec2:	97ca                	add	a5,a5,s2
    80001ec4:	0ac7a983          	lw	s3,172(a5)
    80001ec8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001eca:	2781                	sext.w	a5,a5
    80001ecc:	079e                	slli	a5,a5,0x7
    80001ece:	00010597          	auipc	a1,0x10
    80001ed2:	50258593          	addi	a1,a1,1282 # 800123d0 <cpus+0x8>
    80001ed6:	95be                	add	a1,a1,a5
    80001ed8:	06048513          	addi	a0,s1,96
    80001edc:	50e000ef          	jal	800023ea <swtch>
    80001ee0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001ee2:	2781                	sext.w	a5,a5
    80001ee4:	079e                	slli	a5,a5,0x7
    80001ee6:	993e                	add	s2,s2,a5
    80001ee8:	0b392623          	sw	s3,172(s2)
}
    80001eec:	70a2                	ld	ra,40(sp)
    80001eee:	7402                	ld	s0,32(sp)
    80001ef0:	64e2                	ld	s1,24(sp)
    80001ef2:	6942                	ld	s2,16(sp)
    80001ef4:	69a2                	ld	s3,8(sp)
    80001ef6:	6145                	addi	sp,sp,48
    80001ef8:	8082                	ret
    panic("sched p->lock");
    80001efa:	00005517          	auipc	a0,0x5
    80001efe:	29e50513          	addi	a0,a0,670 # 80007198 <etext+0x198>
    80001f02:	8d3fe0ef          	jal	800007d4 <panic>
    panic("sched locks");
    80001f06:	00005517          	auipc	a0,0x5
    80001f0a:	2a250513          	addi	a0,a0,674 # 800071a8 <etext+0x1a8>
    80001f0e:	8c7fe0ef          	jal	800007d4 <panic>
    panic("sched RUNNING");
    80001f12:	00005517          	auipc	a0,0x5
    80001f16:	2a650513          	addi	a0,a0,678 # 800071b8 <etext+0x1b8>
    80001f1a:	8bbfe0ef          	jal	800007d4 <panic>
    panic("sched interruptible");
    80001f1e:	00005517          	auipc	a0,0x5
    80001f22:	2aa50513          	addi	a0,a0,682 # 800071c8 <etext+0x1c8>
    80001f26:	8affe0ef          	jal	800007d4 <panic>

0000000080001f2a <yield>:
{
    80001f2a:	1101                	addi	sp,sp,-32
    80001f2c:	ec06                	sd	ra,24(sp)
    80001f2e:	e822                	sd	s0,16(sp)
    80001f30:	e426                	sd	s1,8(sp)
    80001f32:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f34:	95fff0ef          	jal	80001892 <myproc>
    80001f38:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001f3a:	c69fe0ef          	jal	80000ba2 <acquire>
  p->state = RUNNABLE;
    80001f3e:	478d                	li	a5,3
    80001f40:	cc9c                	sw	a5,24(s1)
  sched();
    80001f42:	f2fff0ef          	jal	80001e70 <sched>
  release(&p->lock);
    80001f46:	8526                	mv	a0,s1
    80001f48:	ce7fe0ef          	jal	80000c2e <release>
}
    80001f4c:	60e2                	ld	ra,24(sp)
    80001f4e:	6442                	ld	s0,16(sp)
    80001f50:	64a2                	ld	s1,8(sp)
    80001f52:	6105                	addi	sp,sp,32
    80001f54:	8082                	ret

0000000080001f56 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001f56:	7179                	addi	sp,sp,-48
    80001f58:	f406                	sd	ra,40(sp)
    80001f5a:	f022                	sd	s0,32(sp)
    80001f5c:	ec26                	sd	s1,24(sp)
    80001f5e:	e84a                	sd	s2,16(sp)
    80001f60:	e44e                	sd	s3,8(sp)
    80001f62:	1800                	addi	s0,sp,48
    80001f64:	89aa                	mv	s3,a0
    80001f66:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f68:	92bff0ef          	jal	80001892 <myproc>
    80001f6c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); //DOC: sleeplock1
    80001f6e:	c35fe0ef          	jal	80000ba2 <acquire>
  release(lk);
    80001f72:	854a                	mv	a0,s2
    80001f74:	cbbfe0ef          	jal	80000c2e <release>

  // Go to sleep.
  p->chan = chan;
    80001f78:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001f7c:	4789                	li	a5,2
    80001f7e:	cc9c                	sw	a5,24(s1)

  sched();
    80001f80:	ef1ff0ef          	jal	80001e70 <sched>

  // Tidy up.
  p->chan = 0;
    80001f84:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f88:	8526                	mv	a0,s1
    80001f8a:	ca5fe0ef          	jal	80000c2e <release>
  acquire(lk);
    80001f8e:	854a                	mv	a0,s2
    80001f90:	c13fe0ef          	jal	80000ba2 <acquire>
}
    80001f94:	70a2                	ld	ra,40(sp)
    80001f96:	7402                	ld	s0,32(sp)
    80001f98:	64e2                	ld	s1,24(sp)
    80001f9a:	6942                	ld	s2,16(sp)
    80001f9c:	69a2                	ld	s3,8(sp)
    80001f9e:	6145                	addi	sp,sp,48
    80001fa0:	8082                	ret

0000000080001fa2 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001fa2:	7139                	addi	sp,sp,-64
    80001fa4:	fc06                	sd	ra,56(sp)
    80001fa6:	f822                	sd	s0,48(sp)
    80001fa8:	f426                	sd	s1,40(sp)
    80001faa:	f04a                	sd	s2,32(sp)
    80001fac:	ec4e                	sd	s3,24(sp)
    80001fae:	e852                	sd	s4,16(sp)
    80001fb0:	e456                	sd	s5,8(sp)
    80001fb2:	0080                	addi	s0,sp,64
    80001fb4:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001fb6:	00011497          	auipc	s1,0x11
    80001fba:	81248493          	addi	s1,s1,-2030 # 800127c8 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    80001fbe:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001fc0:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001fc2:	00017917          	auipc	s2,0x17
    80001fc6:	80690913          	addi	s2,s2,-2042 # 800187c8 <tickslock>
    80001fca:	a801                	j	80001fda <wakeup+0x38>
      }
      release(&p->lock);
    80001fcc:	8526                	mv	a0,s1
    80001fce:	c61fe0ef          	jal	80000c2e <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001fd2:	18048493          	addi	s1,s1,384
    80001fd6:	03248263          	beq	s1,s2,80001ffa <wakeup+0x58>
    if (p != myproc()) {
    80001fda:	8b9ff0ef          	jal	80001892 <myproc>
    80001fde:	fea48ae3          	beq	s1,a0,80001fd2 <wakeup+0x30>
      acquire(&p->lock);
    80001fe2:	8526                	mv	a0,s1
    80001fe4:	bbffe0ef          	jal	80000ba2 <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    80001fe8:	4c9c                	lw	a5,24(s1)
    80001fea:	ff3791e3          	bne	a5,s3,80001fcc <wakeup+0x2a>
    80001fee:	709c                	ld	a5,32(s1)
    80001ff0:	fd479ee3          	bne	a5,s4,80001fcc <wakeup+0x2a>
        p->state = RUNNABLE;
    80001ff4:	0154ac23          	sw	s5,24(s1)
    80001ff8:	bfd1                	j	80001fcc <wakeup+0x2a>
    }
  }
}
    80001ffa:	70e2                	ld	ra,56(sp)
    80001ffc:	7442                	ld	s0,48(sp)
    80001ffe:	74a2                	ld	s1,40(sp)
    80002000:	7902                	ld	s2,32(sp)
    80002002:	69e2                	ld	s3,24(sp)
    80002004:	6a42                	ld	s4,16(sp)
    80002006:	6aa2                	ld	s5,8(sp)
    80002008:	6121                	addi	sp,sp,64
    8000200a:	8082                	ret

000000008000200c <reparent>:
{
    8000200c:	7179                	addi	sp,sp,-48
    8000200e:	f406                	sd	ra,40(sp)
    80002010:	f022                	sd	s0,32(sp)
    80002012:	ec26                	sd	s1,24(sp)
    80002014:	e84a                	sd	s2,16(sp)
    80002016:	e44e                	sd	s3,8(sp)
    80002018:	e052                	sd	s4,0(sp)
    8000201a:	1800                	addi	s0,sp,48
    8000201c:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000201e:	00010497          	auipc	s1,0x10
    80002022:	7aa48493          	addi	s1,s1,1962 # 800127c8 <proc>
      pp->parent = initproc;
    80002026:	00008a17          	auipc	s4,0x8
    8000202a:	26aa0a13          	addi	s4,s4,618 # 8000a290 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000202e:	00016997          	auipc	s3,0x16
    80002032:	79a98993          	addi	s3,s3,1946 # 800187c8 <tickslock>
    80002036:	a029                	j	80002040 <reparent+0x34>
    80002038:	18048493          	addi	s1,s1,384
    8000203c:	01348b63          	beq	s1,s3,80002052 <reparent+0x46>
    if (pp->parent == p) {
    80002040:	7c9c                	ld	a5,56(s1)
    80002042:	ff279be3          	bne	a5,s2,80002038 <reparent+0x2c>
      pp->parent = initproc;
    80002046:	000a3503          	ld	a0,0(s4)
    8000204a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000204c:	f57ff0ef          	jal	80001fa2 <wakeup>
    80002050:	b7e5                	j	80002038 <reparent+0x2c>
}
    80002052:	70a2                	ld	ra,40(sp)
    80002054:	7402                	ld	s0,32(sp)
    80002056:	64e2                	ld	s1,24(sp)
    80002058:	6942                	ld	s2,16(sp)
    8000205a:	69a2                	ld	s3,8(sp)
    8000205c:	6a02                	ld	s4,0(sp)
    8000205e:	6145                	addi	sp,sp,48
    80002060:	8082                	ret

0000000080002062 <kexit>:
{
    80002062:	7179                	addi	sp,sp,-48
    80002064:	f406                	sd	ra,40(sp)
    80002066:	f022                	sd	s0,32(sp)
    80002068:	ec26                	sd	s1,24(sp)
    8000206a:	e84a                	sd	s2,16(sp)
    8000206c:	e44e                	sd	s3,8(sp)
    8000206e:	e052                	sd	s4,0(sp)
    80002070:	1800                	addi	s0,sp,48
    80002072:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002074:	81fff0ef          	jal	80001892 <myproc>
    80002078:	89aa                	mv	s3,a0
  if (p == initproc)
    8000207a:	00008797          	auipc	a5,0x8
    8000207e:	2167b783          	ld	a5,534(a5) # 8000a290 <initproc>
    80002082:	0d050493          	addi	s1,a0,208
    80002086:	15050913          	addi	s2,a0,336
    8000208a:	00a79f63          	bne	a5,a0,800020a8 <kexit+0x46>
    panic("init exiting");
    8000208e:	00005517          	auipc	a0,0x5
    80002092:	15250513          	addi	a0,a0,338 # 800071e0 <etext+0x1e0>
    80002096:	f3efe0ef          	jal	800007d4 <panic>
      fileclose(f);
    8000209a:	0e8020ef          	jal	80004182 <fileclose>
      p->ofile[fd] = 0;
    8000209e:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    800020a2:	04a1                	addi	s1,s1,8
    800020a4:	01248563          	beq	s1,s2,800020ae <kexit+0x4c>
    if (p->ofile[fd]) {
    800020a8:	6088                	ld	a0,0(s1)
    800020aa:	f965                	bnez	a0,8000209a <kexit+0x38>
    800020ac:	bfdd                	j	800020a2 <kexit+0x40>
  begin_op();
    800020ae:	461010ef          	jal	80003d0e <begin_op>
  iput(p->cwd);
    800020b2:	1509b503          	ld	a0,336(s3)
    800020b6:	3f0010ef          	jal	800034a6 <iput>
  end_op();
    800020ba:	4bf010ef          	jal	80003d78 <end_op>
  p->cwd = 0;
    800020be:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800020c2:	00010497          	auipc	s1,0x10
    800020c6:	2ee48493          	addi	s1,s1,750 # 800123b0 <wait_lock>
    800020ca:	8526                	mv	a0,s1
    800020cc:	ad7fe0ef          	jal	80000ba2 <acquire>
  reparent(p);
    800020d0:	854e                	mv	a0,s3
    800020d2:	f3bff0ef          	jal	8000200c <reparent>
  wakeup(p->parent);
    800020d6:	0389b503          	ld	a0,56(s3)
    800020da:	ec9ff0ef          	jal	80001fa2 <wakeup>
  acquire(&p->lock);
    800020de:	854e                	mv	a0,s3
    800020e0:	ac3fe0ef          	jal	80000ba2 <acquire>
  p->xstate = status;
    800020e4:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800020e8:	4795                	li	a5,5
    800020ea:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800020ee:	8526                	mv	a0,s1
    800020f0:	b3ffe0ef          	jal	80000c2e <release>
  sched();
    800020f4:	d7dff0ef          	jal	80001e70 <sched>
  panic("zombie exit");
    800020f8:	00005517          	auipc	a0,0x5
    800020fc:	0f850513          	addi	a0,a0,248 # 800071f0 <etext+0x1f0>
    80002100:	ed4fe0ef          	jal	800007d4 <panic>

0000000080002104 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80002104:	7179                	addi	sp,sp,-48
    80002106:	f406                	sd	ra,40(sp)
    80002108:	f022                	sd	s0,32(sp)
    8000210a:	ec26                	sd	s1,24(sp)
    8000210c:	e84a                	sd	s2,16(sp)
    8000210e:	e44e                	sd	s3,8(sp)
    80002110:	1800                	addi	s0,sp,48
    80002112:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80002114:	00010497          	auipc	s1,0x10
    80002118:	6b448493          	addi	s1,s1,1716 # 800127c8 <proc>
    8000211c:	00016997          	auipc	s3,0x16
    80002120:	6ac98993          	addi	s3,s3,1708 # 800187c8 <tickslock>
    acquire(&p->lock);
    80002124:	8526                	mv	a0,s1
    80002126:	a7dfe0ef          	jal	80000ba2 <acquire>
    if (p->pid == pid) {
    8000212a:	589c                	lw	a5,48(s1)
    8000212c:	01278b63          	beq	a5,s2,80002142 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002130:	8526                	mv	a0,s1
    80002132:	afdfe0ef          	jal	80000c2e <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002136:	18048493          	addi	s1,s1,384
    8000213a:	ff3495e3          	bne	s1,s3,80002124 <kkill+0x20>
  }
  return -1;
    8000213e:	557d                	li	a0,-1
    80002140:	a819                	j	80002156 <kkill+0x52>
      p->killed = 1;
    80002142:	4785                	li	a5,1
    80002144:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80002146:	4c98                	lw	a4,24(s1)
    80002148:	4789                	li	a5,2
    8000214a:	00f70d63          	beq	a4,a5,80002164 <kkill+0x60>
      release(&p->lock);
    8000214e:	8526                	mv	a0,s1
    80002150:	adffe0ef          	jal	80000c2e <release>
      return 0;
    80002154:	4501                	li	a0,0
}
    80002156:	70a2                	ld	ra,40(sp)
    80002158:	7402                	ld	s0,32(sp)
    8000215a:	64e2                	ld	s1,24(sp)
    8000215c:	6942                	ld	s2,16(sp)
    8000215e:	69a2                	ld	s3,8(sp)
    80002160:	6145                	addi	sp,sp,48
    80002162:	8082                	ret
        p->state = RUNNABLE;
    80002164:	478d                	li	a5,3
    80002166:	cc9c                	sw	a5,24(s1)
    80002168:	b7dd                	j	8000214e <kkill+0x4a>

000000008000216a <setkilled>:

void
setkilled(struct proc *p)
{
    8000216a:	1101                	addi	sp,sp,-32
    8000216c:	ec06                	sd	ra,24(sp)
    8000216e:	e822                	sd	s0,16(sp)
    80002170:	e426                	sd	s1,8(sp)
    80002172:	1000                	addi	s0,sp,32
    80002174:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002176:	a2dfe0ef          	jal	80000ba2 <acquire>
  p->killed = 1;
    8000217a:	4785                	li	a5,1
    8000217c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000217e:	8526                	mv	a0,s1
    80002180:	aaffe0ef          	jal	80000c2e <release>
}
    80002184:	60e2                	ld	ra,24(sp)
    80002186:	6442                	ld	s0,16(sp)
    80002188:	64a2                	ld	s1,8(sp)
    8000218a:	6105                	addi	sp,sp,32
    8000218c:	8082                	ret

000000008000218e <killed>:

int
killed(struct proc *p)
{
    8000218e:	1101                	addi	sp,sp,-32
    80002190:	ec06                	sd	ra,24(sp)
    80002192:	e822                	sd	s0,16(sp)
    80002194:	e426                	sd	s1,8(sp)
    80002196:	e04a                	sd	s2,0(sp)
    80002198:	1000                	addi	s0,sp,32
    8000219a:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    8000219c:	a07fe0ef          	jal	80000ba2 <acquire>
  k = p->killed;
    800021a0:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800021a4:	8526                	mv	a0,s1
    800021a6:	a89fe0ef          	jal	80000c2e <release>
  return k;
}
    800021aa:	854a                	mv	a0,s2
    800021ac:	60e2                	ld	ra,24(sp)
    800021ae:	6442                	ld	s0,16(sp)
    800021b0:	64a2                	ld	s1,8(sp)
    800021b2:	6902                	ld	s2,0(sp)
    800021b4:	6105                	addi	sp,sp,32
    800021b6:	8082                	ret

00000000800021b8 <kwait>:
{
    800021b8:	715d                	addi	sp,sp,-80
    800021ba:	e486                	sd	ra,72(sp)
    800021bc:	e0a2                	sd	s0,64(sp)
    800021be:	fc26                	sd	s1,56(sp)
    800021c0:	f84a                	sd	s2,48(sp)
    800021c2:	f44e                	sd	s3,40(sp)
    800021c4:	f052                	sd	s4,32(sp)
    800021c6:	ec56                	sd	s5,24(sp)
    800021c8:	e85a                	sd	s6,16(sp)
    800021ca:	e45e                	sd	s7,8(sp)
    800021cc:	e062                	sd	s8,0(sp)
    800021ce:	0880                	addi	s0,sp,80
    800021d0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800021d2:	ec0ff0ef          	jal	80001892 <myproc>
    800021d6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800021d8:	00010517          	auipc	a0,0x10
    800021dc:	1d850513          	addi	a0,a0,472 # 800123b0 <wait_lock>
    800021e0:	9c3fe0ef          	jal	80000ba2 <acquire>
    havekids = 0;
    800021e4:	4b81                	li	s7,0
        if (pp->state == ZOMBIE) {
    800021e6:	4a15                	li	s4,5
        havekids = 1;
    800021e8:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800021ea:	00016997          	auipc	s3,0x16
    800021ee:	5de98993          	addi	s3,s3,1502 # 800187c8 <tickslock>
    sleep(p, &wait_lock); //DOC: wait-sleep
    800021f2:	00010c17          	auipc	s8,0x10
    800021f6:	1bec0c13          	addi	s8,s8,446 # 800123b0 <wait_lock>
    800021fa:	a871                	j	80002296 <kwait+0xde>
          pid = pp->pid;
    800021fc:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002200:	000b0c63          	beqz	s6,80002218 <kwait+0x60>
    80002204:	4691                	li	a3,4
    80002206:	02c48613          	addi	a2,s1,44
    8000220a:	85da                	mv	a1,s6
    8000220c:	05093503          	ld	a0,80(s2)
    80002210:	b96ff0ef          	jal	800015a6 <copyout>
    80002214:	02054b63          	bltz	a0,8000224a <kwait+0x92>
          freeproc(pp);
    80002218:	8526                	mv	a0,s1
    8000221a:	8b3ff0ef          	jal	80001acc <freeproc>
          release(&pp->lock);
    8000221e:	8526                	mv	a0,s1
    80002220:	a0ffe0ef          	jal	80000c2e <release>
          release(&wait_lock);
    80002224:	00010517          	auipc	a0,0x10
    80002228:	18c50513          	addi	a0,a0,396 # 800123b0 <wait_lock>
    8000222c:	a03fe0ef          	jal	80000c2e <release>
}
    80002230:	854e                	mv	a0,s3
    80002232:	60a6                	ld	ra,72(sp)
    80002234:	6406                	ld	s0,64(sp)
    80002236:	74e2                	ld	s1,56(sp)
    80002238:	7942                	ld	s2,48(sp)
    8000223a:	79a2                	ld	s3,40(sp)
    8000223c:	7a02                	ld	s4,32(sp)
    8000223e:	6ae2                	ld	s5,24(sp)
    80002240:	6b42                	ld	s6,16(sp)
    80002242:	6ba2                	ld	s7,8(sp)
    80002244:	6c02                	ld	s8,0(sp)
    80002246:	6161                	addi	sp,sp,80
    80002248:	8082                	ret
            release(&pp->lock);
    8000224a:	8526                	mv	a0,s1
    8000224c:	9e3fe0ef          	jal	80000c2e <release>
            release(&wait_lock);
    80002250:	00010517          	auipc	a0,0x10
    80002254:	16050513          	addi	a0,a0,352 # 800123b0 <wait_lock>
    80002258:	9d7fe0ef          	jal	80000c2e <release>
            return -1;
    8000225c:	59fd                	li	s3,-1
    8000225e:	bfc9                	j	80002230 <kwait+0x78>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002260:	18048493          	addi	s1,s1,384
    80002264:	03348063          	beq	s1,s3,80002284 <kwait+0xcc>
      if (pp->parent == p) {
    80002268:	7c9c                	ld	a5,56(s1)
    8000226a:	ff279be3          	bne	a5,s2,80002260 <kwait+0xa8>
        acquire(&pp->lock);
    8000226e:	8526                	mv	a0,s1
    80002270:	933fe0ef          	jal	80000ba2 <acquire>
        if (pp->state == ZOMBIE) {
    80002274:	4c9c                	lw	a5,24(s1)
    80002276:	f94783e3          	beq	a5,s4,800021fc <kwait+0x44>
        release(&pp->lock);
    8000227a:	8526                	mv	a0,s1
    8000227c:	9b3fe0ef          	jal	80000c2e <release>
        havekids = 1;
    80002280:	8756                	mv	a4,s5
    80002282:	bff9                	j	80002260 <kwait+0xa8>
    if (!havekids || killed(p)) {
    80002284:	cf19                	beqz	a4,800022a2 <kwait+0xea>
    80002286:	854a                	mv	a0,s2
    80002288:	f07ff0ef          	jal	8000218e <killed>
    8000228c:	e919                	bnez	a0,800022a2 <kwait+0xea>
    sleep(p, &wait_lock); //DOC: wait-sleep
    8000228e:	85e2                	mv	a1,s8
    80002290:	854a                	mv	a0,s2
    80002292:	cc5ff0ef          	jal	80001f56 <sleep>
    havekids = 0;
    80002296:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002298:	00010497          	auipc	s1,0x10
    8000229c:	53048493          	addi	s1,s1,1328 # 800127c8 <proc>
    800022a0:	b7e1                	j	80002268 <kwait+0xb0>
      release(&wait_lock);
    800022a2:	00010517          	auipc	a0,0x10
    800022a6:	10e50513          	addi	a0,a0,270 # 800123b0 <wait_lock>
    800022aa:	985fe0ef          	jal	80000c2e <release>
      return -1;
    800022ae:	59fd                	li	s3,-1
    800022b0:	b741                	j	80002230 <kwait+0x78>

00000000800022b2 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800022b2:	7179                	addi	sp,sp,-48
    800022b4:	f406                	sd	ra,40(sp)
    800022b6:	f022                	sd	s0,32(sp)
    800022b8:	ec26                	sd	s1,24(sp)
    800022ba:	e84a                	sd	s2,16(sp)
    800022bc:	e44e                	sd	s3,8(sp)
    800022be:	e052                	sd	s4,0(sp)
    800022c0:	1800                	addi	s0,sp,48
    800022c2:	84aa                	mv	s1,a0
    800022c4:	892e                	mv	s2,a1
    800022c6:	89b2                	mv	s3,a2
    800022c8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800022ca:	dc8ff0ef          	jal	80001892 <myproc>
  if (user_dst) {
    800022ce:	cc99                	beqz	s1,800022ec <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800022d0:	86d2                	mv	a3,s4
    800022d2:	864e                	mv	a2,s3
    800022d4:	85ca                	mv	a1,s2
    800022d6:	6928                	ld	a0,80(a0)
    800022d8:	aceff0ef          	jal	800015a6 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800022dc:	70a2                	ld	ra,40(sp)
    800022de:	7402                	ld	s0,32(sp)
    800022e0:	64e2                	ld	s1,24(sp)
    800022e2:	6942                	ld	s2,16(sp)
    800022e4:	69a2                	ld	s3,8(sp)
    800022e6:	6a02                	ld	s4,0(sp)
    800022e8:	6145                	addi	sp,sp,48
    800022ea:	8082                	ret
    memmove((char *)dst, src, len);
    800022ec:	000a061b          	sext.w	a2,s4
    800022f0:	85ce                	mv	a1,s3
    800022f2:	854a                	mv	a0,s2
    800022f4:	9cffe0ef          	jal	80000cc2 <memmove>
    return 0;
    800022f8:	8526                	mv	a0,s1
    800022fa:	b7cd                	j	800022dc <either_copyout+0x2a>

00000000800022fc <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022fc:	7179                	addi	sp,sp,-48
    800022fe:	f406                	sd	ra,40(sp)
    80002300:	f022                	sd	s0,32(sp)
    80002302:	ec26                	sd	s1,24(sp)
    80002304:	e84a                	sd	s2,16(sp)
    80002306:	e44e                	sd	s3,8(sp)
    80002308:	e052                	sd	s4,0(sp)
    8000230a:	1800                	addi	s0,sp,48
    8000230c:	892a                	mv	s2,a0
    8000230e:	84ae                	mv	s1,a1
    80002310:	89b2                	mv	s3,a2
    80002312:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002314:	d7eff0ef          	jal	80001892 <myproc>
  if (user_src) {
    80002318:	cc99                	beqz	s1,80002336 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000231a:	86d2                	mv	a3,s4
    8000231c:	864e                	mv	a2,s3
    8000231e:	85ca                	mv	a1,s2
    80002320:	6928                	ld	a0,80(a0)
    80002322:	b68ff0ef          	jal	8000168a <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002326:	70a2                	ld	ra,40(sp)
    80002328:	7402                	ld	s0,32(sp)
    8000232a:	64e2                	ld	s1,24(sp)
    8000232c:	6942                	ld	s2,16(sp)
    8000232e:	69a2                	ld	s3,8(sp)
    80002330:	6a02                	ld	s4,0(sp)
    80002332:	6145                	addi	sp,sp,48
    80002334:	8082                	ret
    memmove(dst, (char *)src, len);
    80002336:	000a061b          	sext.w	a2,s4
    8000233a:	85ce                	mv	a1,s3
    8000233c:	854a                	mv	a0,s2
    8000233e:	985fe0ef          	jal	80000cc2 <memmove>
    return 0;
    80002342:	8526                	mv	a0,s1
    80002344:	b7cd                	j	80002326 <either_copyin+0x2a>

0000000080002346 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002346:	715d                	addi	sp,sp,-80
    80002348:	e486                	sd	ra,72(sp)
    8000234a:	e0a2                	sd	s0,64(sp)
    8000234c:	fc26                	sd	s1,56(sp)
    8000234e:	f84a                	sd	s2,48(sp)
    80002350:	f44e                	sd	s3,40(sp)
    80002352:	f052                	sd	s4,32(sp)
    80002354:	ec56                	sd	s5,24(sp)
    80002356:	e85a                	sd	s6,16(sp)
    80002358:	e45e                	sd	s7,8(sp)
    8000235a:	0880                	addi	s0,sp,80
    // clang-format on
  };
  struct proc *p;
  char *state;

  printk("\n");
    8000235c:	00005517          	auipc	a0,0x5
    80002360:	d1c50513          	addi	a0,a0,-740 # 80007078 <etext+0x78>
    80002364:	98afe0ef          	jal	800004ee <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002368:	00010497          	auipc	s1,0x10
    8000236c:	5b848493          	addi	s1,s1,1464 # 80012920 <proc+0x158>
    80002370:	00016917          	auipc	s2,0x16
    80002374:	5b090913          	addi	s2,s2,1456 # 80018920 <bcache+0x140>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002378:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000237a:	00005997          	auipc	s3,0x5
    8000237e:	e8698993          	addi	s3,s3,-378 # 80007200 <etext+0x200>
    printk("%d %s %s", p->pid, state, p->name);
    80002382:	00005a97          	auipc	s5,0x5
    80002386:	e86a8a93          	addi	s5,s5,-378 # 80007208 <etext+0x208>
    printk("\n");
    8000238a:	00005a17          	auipc	s4,0x5
    8000238e:	ceea0a13          	addi	s4,s4,-786 # 80007078 <etext+0x78>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002392:	00005b97          	auipc	s7,0x5
    80002396:	396b8b93          	addi	s7,s7,918 # 80007728 <states.0>
    8000239a:	a829                	j	800023b4 <procdump+0x6e>
    printk("%d %s %s", p->pid, state, p->name);
    8000239c:	ed86a583          	lw	a1,-296(a3)
    800023a0:	8556                	mv	a0,s5
    800023a2:	94cfe0ef          	jal	800004ee <printk>
    printk("\n");
    800023a6:	8552                	mv	a0,s4
    800023a8:	946fe0ef          	jal	800004ee <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    800023ac:	18048493          	addi	s1,s1,384
    800023b0:	03248263          	beq	s1,s2,800023d4 <procdump+0x8e>
    if (p->state == UNUSED)
    800023b4:	86a6                	mv	a3,s1
    800023b6:	ec04a783          	lw	a5,-320(s1)
    800023ba:	dbed                	beqz	a5,800023ac <procdump+0x66>
      state = "???";
    800023bc:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023be:	fcfb6fe3          	bltu	s6,a5,8000239c <procdump+0x56>
    800023c2:	02079713          	slli	a4,a5,0x20
    800023c6:	01d75793          	srli	a5,a4,0x1d
    800023ca:	97de                	add	a5,a5,s7
    800023cc:	6390                	ld	a2,0(a5)
    800023ce:	f679                	bnez	a2,8000239c <procdump+0x56>
      state = "???";
    800023d0:	864e                	mv	a2,s3
    800023d2:	b7e9                	j	8000239c <procdump+0x56>
  }
}
    800023d4:	60a6                	ld	ra,72(sp)
    800023d6:	6406                	ld	s0,64(sp)
    800023d8:	74e2                	ld	s1,56(sp)
    800023da:	7942                	ld	s2,48(sp)
    800023dc:	79a2                	ld	s3,40(sp)
    800023de:	7a02                	ld	s4,32(sp)
    800023e0:	6ae2                	ld	s5,24(sp)
    800023e2:	6b42                	ld	s6,16(sp)
    800023e4:	6ba2                	ld	s7,8(sp)
    800023e6:	6161                	addi	sp,sp,80
    800023e8:	8082                	ret

00000000800023ea <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800023ea:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800023ee:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800023f2:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800023f4:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800023f6:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800023fa:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800023fe:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80002402:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80002406:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    8000240a:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    8000240e:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002412:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002416:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    8000241a:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    8000241e:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002422:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002426:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002428:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8000242a:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    8000242e:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002432:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002436:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000243a:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    8000243e:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002442:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002446:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000244a:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8000244e:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002452:	8082                	ret

0000000080002454 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002454:	1141                	addi	sp,sp,-16
    80002456:	e406                	sd	ra,8(sp)
    80002458:	e022                	sd	s0,0(sp)
    8000245a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000245c:	00005597          	auipc	a1,0x5
    80002460:	dec58593          	addi	a1,a1,-532 # 80007248 <etext+0x248>
    80002464:	00016517          	auipc	a0,0x16
    80002468:	36450513          	addi	a0,a0,868 # 800187c8 <tickslock>
    8000246c:	ec0fe0ef          	jal	80000b2c <initlock>
}
    80002470:	60a2                	ld	ra,8(sp)
    80002472:	6402                	ld	s0,0(sp)
    80002474:	0141                	addi	sp,sp,16
    80002476:	8082                	ret

0000000080002478 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002478:	1141                	addi	sp,sp,-16
    8000247a:	e422                	sd	s0,8(sp)
    8000247c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    8000247e:	00003797          	auipc	a5,0x3
    80002482:	08278793          	addi	a5,a5,130 # 80005500 <kernelvec>
    80002486:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000248a:	6422                	ld	s0,8(sp)
    8000248c:	0141                	addi	sp,sp,16
    8000248e:	8082                	ret

0000000080002490 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002490:	1141                	addi	sp,sp,-16
    80002492:	e406                	sd	ra,8(sp)
    80002494:	e022                	sd	s0,0(sp)
    80002496:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002498:	bfaff0ef          	jal	80001892 <myproc>
  __asm__ __volatile__("csrc sstatus, %0" ::
    8000249c:	10017073          	csrci	sstatus,2
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800024a0:	04000737          	lui	a4,0x4000
    800024a4:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800024a6:	0732                	slli	a4,a4,0xc
    800024a8:	00004797          	auipc	a5,0x4
    800024ac:	b5878793          	addi	a5,a5,-1192 # 80006000 <_trampoline>
    800024b0:	00004697          	auipc	a3,0x4
    800024b4:	b5068693          	addi	a3,a3,-1200 # 80006000 <_trampoline>
    800024b8:	8f95                	sub	a5,a5,a3
    800024ba:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    800024bc:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800024c0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    800024c2:	18002773          	csrr	a4,satp
    800024c6:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800024c8:	6d38                	ld	a4,88(a0)
    800024ca:	613c                	ld	a5,64(a0)
    800024cc:	6685                	lui	a3,0x1
    800024ce:	97b6                	add	a5,a5,a3
    800024d0:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800024d2:	6d3c                	ld	a5,88(a0)
    800024d4:	00000717          	auipc	a4,0x0
    800024d8:	0fc70713          	addi	a4,a4,252 # 800025d0 <usertrap>
    800024dc:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    800024de:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    800024e0:	8712                	mv	a4,tp
    800024e2:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800024e4:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024e8:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024ec:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800024f0:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800024f4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    800024f6:	6f9c                	ld	a5,24(a5)
    800024f8:	14179073          	csrw	sepc,a5
}
    800024fc:	60a2                	ld	ra,8(sp)
    800024fe:	6402                	ld	s0,0(sp)
    80002500:	0141                	addi	sp,sp,16
    80002502:	8082                	ret

0000000080002504 <clockintr>:
}
// Felipe

void
clockintr()
{
    80002504:	1101                	addi	sp,sp,-32
    80002506:	ec06                	sd	ra,24(sp)
    80002508:	e822                	sd	s0,16(sp)
    8000250a:	1000                	addi	s0,sp,32
  if (cpuid() == 0) {
    8000250c:	b5aff0ef          	jal	80001866 <cpuid>
    80002510:	cd11                	beqz	a0,8000252c <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    80002512:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002516:	000f4737          	lui	a4,0xf4
    8000251a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000251e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    80002520:	14d79073          	csrw	stimecmp,a5
}
    80002524:	60e2                	ld	ra,24(sp)
    80002526:	6442                	ld	s0,16(sp)
    80002528:	6105                	addi	sp,sp,32
    8000252a:	8082                	ret
    8000252c:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000252e:	00016497          	auipc	s1,0x16
    80002532:	29a48493          	addi	s1,s1,666 # 800187c8 <tickslock>
    80002536:	8526                	mv	a0,s1
    80002538:	e6afe0ef          	jal	80000ba2 <acquire>
    ticks++;
    8000253c:	00008517          	auipc	a0,0x8
    80002540:	d5c50513          	addi	a0,a0,-676 # 8000a298 <ticks>
    80002544:	411c                	lw	a5,0(a0)
    80002546:	2785                	addiw	a5,a5,1
    80002548:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000254a:	a59ff0ef          	jal	80001fa2 <wakeup>
    release(&tickslock);
    8000254e:	8526                	mv	a0,s1
    80002550:	edefe0ef          	jal	80000c2e <release>
    update_time();
    80002554:	c44ff0ef          	jal	80001998 <update_time>
    80002558:	64a2                	ld	s1,8(sp)
    8000255a:	bf65                	j	80002512 <clockintr+0xe>

000000008000255c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000255c:	1101                	addi	sp,sp,-32
    8000255e:	ec06                	sd	ra,24(sp)
    80002560:	e822                	sd	s0,16(sp)
    80002562:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80002564:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if (scause == 0x8000000000000009L) {
    80002568:	57fd                	li	a5,-1
    8000256a:	17fe                	slli	a5,a5,0x3f
    8000256c:	07a5                	addi	a5,a5,9
    8000256e:	00f70c63          	beq	a4,a5,80002586 <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    80002572:	57fd                	li	a5,-1
    80002574:	17fe                	slli	a5,a5,0x3f
    80002576:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002578:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    8000257a:	04f70763          	beq	a4,a5,800025c8 <devintr+0x6c>
  }
}
    8000257e:	60e2                	ld	ra,24(sp)
    80002580:	6442                	ld	s0,16(sp)
    80002582:	6105                	addi	sp,sp,32
    80002584:	8082                	ret
    80002586:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002588:	024030ef          	jal	800055ac <plic_claim>
    8000258c:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    8000258e:	47a9                	li	a5,10
    80002590:	00f50963          	beq	a0,a5,800025a2 <devintr+0x46>
    } else if (irq == VIRTIO0_IRQ) {
    80002594:	4785                	li	a5,1
    80002596:	00f50963          	beq	a0,a5,800025a8 <devintr+0x4c>
    return 1;
    8000259a:	4505                	li	a0,1
    } else if (irq) {
    8000259c:	e889                	bnez	s1,800025ae <devintr+0x52>
    8000259e:	64a2                	ld	s1,8(sp)
    800025a0:	bff9                	j	8000257e <devintr+0x22>
      uartintr();
    800025a2:	bdcfe0ef          	jal	8000097e <uartintr>
    if (irq)
    800025a6:	a819                	j	800025bc <devintr+0x60>
      virtio_disk_intr();
    800025a8:	4ca030ef          	jal	80005a72 <virtio_disk_intr>
    if (irq)
    800025ac:	a801                	j	800025bc <devintr+0x60>
      printk("unexpected interrupt irq=%d\n", irq);
    800025ae:	85a6                	mv	a1,s1
    800025b0:	00005517          	auipc	a0,0x5
    800025b4:	ca050513          	addi	a0,a0,-864 # 80007250 <etext+0x250>
    800025b8:	f37fd0ef          	jal	800004ee <printk>
      plic_complete(irq);
    800025bc:	8526                	mv	a0,s1
    800025be:	00e030ef          	jal	800055cc <plic_complete>
    return 1;
    800025c2:	4505                	li	a0,1
    800025c4:	64a2                	ld	s1,8(sp)
    800025c6:	bf65                	j	8000257e <devintr+0x22>
    clockintr();
    800025c8:	f3dff0ef          	jal	80002504 <clockintr>
    return 2;
    800025cc:	4509                	li	a0,2
    800025ce:	bf45                	j	8000257e <devintr+0x22>

00000000800025d0 <usertrap>:
{
    800025d0:	1101                	addi	sp,sp,-32
    800025d2:	ec06                	sd	ra,24(sp)
    800025d4:	e822                	sd	s0,16(sp)
    800025d6:	e426                	sd	s1,8(sp)
    800025d8:	e04a                	sd	s2,0(sp)
    800025da:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800025dc:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    800025e0:	1007f793          	andi	a5,a5,256
    800025e4:	eba5                	bnez	a5,80002654 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r"(x));
    800025e6:	00003797          	auipc	a5,0x3
    800025ea:	f1a78793          	addi	a5,a5,-230 # 80005500 <kernelvec>
    800025ee:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800025f2:	aa0ff0ef          	jal	80001892 <myproc>
    800025f6:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800025f8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    800025fa:	14102773          	csrr	a4,sepc
    800025fe:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80002600:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80002604:	47a1                	li	a5,8
    80002606:	04f70d63          	beq	a4,a5,80002660 <usertrap+0x90>
  } else if ((which_dev = devintr()) != 0) {
    8000260a:	f53ff0ef          	jal	8000255c <devintr>
    8000260e:	892a                	mv	s2,a0
    80002610:	e545                	bnez	a0,800026b8 <usertrap+0xe8>
    80002612:	14202773          	csrr	a4,scause
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    80002616:	47bd                	li	a5,15
    80002618:	08f70463          	beq	a4,a5,800026a0 <usertrap+0xd0>
    8000261c:	14202773          	csrr	a4,scause
    80002620:	47b5                	li	a5,13
    80002622:	06f70f63          	beq	a4,a5,800026a0 <usertrap+0xd0>
    80002626:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000262a:	5890                	lw	a2,48(s1)
    8000262c:	00005517          	auipc	a0,0x5
    80002630:	c6450513          	addi	a0,a0,-924 # 80007290 <etext+0x290>
    80002634:	ebbfd0ef          	jal	800004ee <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002638:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    8000263c:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002640:	00005517          	auipc	a0,0x5
    80002644:	c8050513          	addi	a0,a0,-896 # 800072c0 <etext+0x2c0>
    80002648:	ea7fd0ef          	jal	800004ee <printk>
    setkilled(p);
    8000264c:	8526                	mv	a0,s1
    8000264e:	b1dff0ef          	jal	8000216a <setkilled>
    80002652:	a015                	j	80002676 <usertrap+0xa6>
    panic("usertrap: not from user mode");
    80002654:	00005517          	auipc	a0,0x5
    80002658:	c1c50513          	addi	a0,a0,-996 # 80007270 <etext+0x270>
    8000265c:	978fe0ef          	jal	800007d4 <panic>
    if (killed(p))
    80002660:	b2fff0ef          	jal	8000218e <killed>
    80002664:	e915                	bnez	a0,80002698 <usertrap+0xc8>
    p->trapframe->epc += 4;
    80002666:	6cb8                	ld	a4,88(s1)
    80002668:	6f1c                	ld	a5,24(a4)
    8000266a:	0791                	addi	a5,a5,4
    8000266c:	ef1c                	sd	a5,24(a4)
  __asm__ __volatile__("csrs sstatus, %0" ::
    8000266e:	10016073          	csrsi	sstatus,2
    syscall();
    80002672:	246000ef          	jal	800028b8 <syscall>
  if (killed(p))
    80002676:	8526                	mv	a0,s1
    80002678:	b17ff0ef          	jal	8000218e <killed>
    8000267c:	e139                	bnez	a0,800026c2 <usertrap+0xf2>
  prepare_return();
    8000267e:	e13ff0ef          	jal	80002490 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002682:	68a8                	ld	a0,80(s1)
    80002684:	8131                	srli	a0,a0,0xc
    80002686:	57fd                	li	a5,-1
    80002688:	17fe                	slli	a5,a5,0x3f
    8000268a:	8d5d                	or	a0,a0,a5
}
    8000268c:	60e2                	ld	ra,24(sp)
    8000268e:	6442                	ld	s0,16(sp)
    80002690:	64a2                	ld	s1,8(sp)
    80002692:	6902                	ld	s2,0(sp)
    80002694:	6105                	addi	sp,sp,32
    80002696:	8082                	ret
      kexit(-1);
    80002698:	557d                	li	a0,-1
    8000269a:	9c9ff0ef          	jal	80002062 <kexit>
    8000269e:	b7e1                	j	80002666 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r"(x));
    800026a0:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    800026a4:	14202673          	csrr	a2,scause
             vmfault(p->pagetable, r_stval(), (r_scause() == 13) ? 1 : 0) !=
    800026a8:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    800026aa:	00163613          	seqz	a2,a2
    800026ae:	68a8                	ld	a0,80(s1)
    800026b0:	e75fe0ef          	jal	80001524 <vmfault>
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    800026b4:	f169                	bnez	a0,80002676 <usertrap+0xa6>
    800026b6:	bf85                	j	80002626 <usertrap+0x56>
  if (killed(p))
    800026b8:	8526                	mv	a0,s1
    800026ba:	ad5ff0ef          	jal	8000218e <killed>
    800026be:	c511                	beqz	a0,800026ca <usertrap+0xfa>
    800026c0:	a011                	j	800026c4 <usertrap+0xf4>
    800026c2:	4901                	li	s2,0
    kexit(-1);
    800026c4:	557d                	li	a0,-1
    800026c6:	99dff0ef          	jal	80002062 <kexit>
  if (which_dev == 2)
    800026ca:	4789                	li	a5,2
    800026cc:	faf919e3          	bne	s2,a5,8000267e <usertrap+0xae>
    yield();
    800026d0:	85bff0ef          	jal	80001f2a <yield>
    800026d4:	b76d                	j	8000267e <usertrap+0xae>

00000000800026d6 <kerneltrap>:
{
    800026d6:	7179                	addi	sp,sp,-48
    800026d8:	f406                	sd	ra,40(sp)
    800026da:	f022                	sd	s0,32(sp)
    800026dc:	ec26                	sd	s1,24(sp)
    800026de:	e84a                	sd	s2,16(sp)
    800026e0:	e44e                	sd	s3,8(sp)
    800026e2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    800026e4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800026e8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    800026ec:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    800026f0:	1004f793          	andi	a5,s1,256
    800026f4:	c795                	beqz	a5,80002720 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800026f6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026fa:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    800026fc:	eb85                	bnez	a5,8000272c <kerneltrap+0x56>
  if ((which_dev = devintr()) == 0) {
    800026fe:	e5fff0ef          	jal	8000255c <devintr>
    80002702:	c91d                	beqz	a0,80002738 <kerneltrap+0x62>
  if (which_dev == 2 && myproc() != 0)
    80002704:	4789                	li	a5,2
    80002706:	04f50a63          	beq	a0,a5,8000275a <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r"(x));
    8000270a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000270e:	10049073          	csrw	sstatus,s1
}
    80002712:	70a2                	ld	ra,40(sp)
    80002714:	7402                	ld	s0,32(sp)
    80002716:	64e2                	ld	s1,24(sp)
    80002718:	6942                	ld	s2,16(sp)
    8000271a:	69a2                	ld	s3,8(sp)
    8000271c:	6145                	addi	sp,sp,48
    8000271e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002720:	00005517          	auipc	a0,0x5
    80002724:	bc850513          	addi	a0,a0,-1080 # 800072e8 <etext+0x2e8>
    80002728:	8acfe0ef          	jal	800007d4 <panic>
    panic("kerneltrap: interrupts enabled");
    8000272c:	00005517          	auipc	a0,0x5
    80002730:	be450513          	addi	a0,a0,-1052 # 80007310 <etext+0x310>
    80002734:	8a0fe0ef          	jal	800007d4 <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002738:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    8000273c:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    80002740:	85ce                	mv	a1,s3
    80002742:	00005517          	auipc	a0,0x5
    80002746:	bee50513          	addi	a0,a0,-1042 # 80007330 <etext+0x330>
    8000274a:	da5fd0ef          	jal	800004ee <printk>
    panic("kerneltrap");
    8000274e:	00005517          	auipc	a0,0x5
    80002752:	c0a50513          	addi	a0,a0,-1014 # 80007358 <etext+0x358>
    80002756:	87efe0ef          	jal	800007d4 <panic>
  if (which_dev == 2 && myproc() != 0)
    8000275a:	938ff0ef          	jal	80001892 <myproc>
    8000275e:	d555                	beqz	a0,8000270a <kerneltrap+0x34>
    yield();
    80002760:	fcaff0ef          	jal	80001f2a <yield>
    80002764:	b75d                	j	8000270a <kerneltrap+0x34>

0000000080002766 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002766:	1101                	addi	sp,sp,-32
    80002768:	ec06                	sd	ra,24(sp)
    8000276a:	e822                	sd	s0,16(sp)
    8000276c:	e426                	sd	s1,8(sp)
    8000276e:	1000                	addi	s0,sp,32
    80002770:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002772:	920ff0ef          	jal	80001892 <myproc>
  switch (n) {
    80002776:	4795                	li	a5,5
    80002778:	0497e163          	bltu	a5,s1,800027ba <argraw+0x54>
    8000277c:	048a                	slli	s1,s1,0x2
    8000277e:	00005717          	auipc	a4,0x5
    80002782:	fda70713          	addi	a4,a4,-38 # 80007758 <states.0+0x30>
    80002786:	94ba                	add	s1,s1,a4
    80002788:	409c                	lw	a5,0(s1)
    8000278a:	97ba                	add	a5,a5,a4
    8000278c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000278e:	6d3c                	ld	a5,88(a0)
    80002790:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002792:	60e2                	ld	ra,24(sp)
    80002794:	6442                	ld	s0,16(sp)
    80002796:	64a2                	ld	s1,8(sp)
    80002798:	6105                	addi	sp,sp,32
    8000279a:	8082                	ret
    return p->trapframe->a1;
    8000279c:	6d3c                	ld	a5,88(a0)
    8000279e:	7fa8                	ld	a0,120(a5)
    800027a0:	bfcd                	j	80002792 <argraw+0x2c>
    return p->trapframe->a2;
    800027a2:	6d3c                	ld	a5,88(a0)
    800027a4:	63c8                	ld	a0,128(a5)
    800027a6:	b7f5                	j	80002792 <argraw+0x2c>
    return p->trapframe->a3;
    800027a8:	6d3c                	ld	a5,88(a0)
    800027aa:	67c8                	ld	a0,136(a5)
    800027ac:	b7dd                	j	80002792 <argraw+0x2c>
    return p->trapframe->a4;
    800027ae:	6d3c                	ld	a5,88(a0)
    800027b0:	6bc8                	ld	a0,144(a5)
    800027b2:	b7c5                	j	80002792 <argraw+0x2c>
    return p->trapframe->a5;
    800027b4:	6d3c                	ld	a5,88(a0)
    800027b6:	6fc8                	ld	a0,152(a5)
    800027b8:	bfe9                	j	80002792 <argraw+0x2c>
  panic("argraw");
    800027ba:	00005517          	auipc	a0,0x5
    800027be:	bae50513          	addi	a0,a0,-1106 # 80007368 <etext+0x368>
    800027c2:	812fe0ef          	jal	800007d4 <panic>

00000000800027c6 <fetchaddr>:
{
    800027c6:	1101                	addi	sp,sp,-32
    800027c8:	ec06                	sd	ra,24(sp)
    800027ca:	e822                	sd	s0,16(sp)
    800027cc:	e426                	sd	s1,8(sp)
    800027ce:	e04a                	sd	s2,0(sp)
    800027d0:	1000                	addi	s0,sp,32
    800027d2:	84aa                	mv	s1,a0
    800027d4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027d6:	8bcff0ef          	jal	80001892 <myproc>
  if (addr >= p->sz ||
    800027da:	653c                	ld	a5,72(a0)
    800027dc:	02f4f663          	bgeu	s1,a5,80002808 <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800027e0:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    800027e4:	02e7e463          	bltu	a5,a4,8000280c <fetchaddr+0x46>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800027e8:	46a1                	li	a3,8
    800027ea:	8626                	mv	a2,s1
    800027ec:	85ca                	mv	a1,s2
    800027ee:	6928                	ld	a0,80(a0)
    800027f0:	e9bfe0ef          	jal	8000168a <copyin>
    800027f4:	00a03533          	snez	a0,a0
    800027f8:	40a00533          	neg	a0,a0
}
    800027fc:	60e2                	ld	ra,24(sp)
    800027fe:	6442                	ld	s0,16(sp)
    80002800:	64a2                	ld	s1,8(sp)
    80002802:	6902                	ld	s2,0(sp)
    80002804:	6105                	addi	sp,sp,32
    80002806:	8082                	ret
    return -1;
    80002808:	557d                	li	a0,-1
    8000280a:	bfcd                	j	800027fc <fetchaddr+0x36>
    8000280c:	557d                	li	a0,-1
    8000280e:	b7fd                	j	800027fc <fetchaddr+0x36>

0000000080002810 <fetchstr>:
{
    80002810:	7179                	addi	sp,sp,-48
    80002812:	f406                	sd	ra,40(sp)
    80002814:	f022                	sd	s0,32(sp)
    80002816:	ec26                	sd	s1,24(sp)
    80002818:	e84a                	sd	s2,16(sp)
    8000281a:	e44e                	sd	s3,8(sp)
    8000281c:	1800                	addi	s0,sp,48
    8000281e:	892a                	mv	s2,a0
    80002820:	84ae                	mv	s1,a1
    80002822:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002824:	86eff0ef          	jal	80001892 <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002828:	86ce                	mv	a3,s3
    8000282a:	864a                	mv	a2,s2
    8000282c:	85a6                	mv	a1,s1
    8000282e:	6928                	ld	a0,80(a0)
    80002830:	c1dfe0ef          	jal	8000144c <copyinstr>
    80002834:	00054c63          	bltz	a0,8000284c <fetchstr+0x3c>
  return strlen(buf);
    80002838:	8526                	mv	a0,s1
    8000283a:	d9cfe0ef          	jal	80000dd6 <strlen>
}
    8000283e:	70a2                	ld	ra,40(sp)
    80002840:	7402                	ld	s0,32(sp)
    80002842:	64e2                	ld	s1,24(sp)
    80002844:	6942                	ld	s2,16(sp)
    80002846:	69a2                	ld	s3,8(sp)
    80002848:	6145                	addi	sp,sp,48
    8000284a:	8082                	ret
    return -1;
    8000284c:	557d                	li	a0,-1
    8000284e:	bfc5                	j	8000283e <fetchstr+0x2e>

0000000080002850 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002850:	1101                	addi	sp,sp,-32
    80002852:	ec06                	sd	ra,24(sp)
    80002854:	e822                	sd	s0,16(sp)
    80002856:	e426                	sd	s1,8(sp)
    80002858:	1000                	addi	s0,sp,32
    8000285a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000285c:	f0bff0ef          	jal	80002766 <argraw>
    80002860:	c088                	sw	a0,0(s1)
}
    80002862:	60e2                	ld	ra,24(sp)
    80002864:	6442                	ld	s0,16(sp)
    80002866:	64a2                	ld	s1,8(sp)
    80002868:	6105                	addi	sp,sp,32
    8000286a:	8082                	ret

000000008000286c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000286c:	1101                	addi	sp,sp,-32
    8000286e:	ec06                	sd	ra,24(sp)
    80002870:	e822                	sd	s0,16(sp)
    80002872:	e426                	sd	s1,8(sp)
    80002874:	1000                	addi	s0,sp,32
    80002876:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002878:	eefff0ef          	jal	80002766 <argraw>
    8000287c:	e088                	sd	a0,0(s1)
}
    8000287e:	60e2                	ld	ra,24(sp)
    80002880:	6442                	ld	s0,16(sp)
    80002882:	64a2                	ld	s1,8(sp)
    80002884:	6105                	addi	sp,sp,32
    80002886:	8082                	ret

0000000080002888 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002888:	7179                	addi	sp,sp,-48
    8000288a:	f406                	sd	ra,40(sp)
    8000288c:	f022                	sd	s0,32(sp)
    8000288e:	ec26                	sd	s1,24(sp)
    80002890:	e84a                	sd	s2,16(sp)
    80002892:	1800                	addi	s0,sp,48
    80002894:	84ae                	mv	s1,a1
    80002896:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002898:	fd840593          	addi	a1,s0,-40
    8000289c:	fd1ff0ef          	jal	8000286c <argaddr>
  return fetchstr(addr, buf, max);
    800028a0:	864a                	mv	a2,s2
    800028a2:	85a6                	mv	a1,s1
    800028a4:	fd843503          	ld	a0,-40(s0)
    800028a8:	f69ff0ef          	jal	80002810 <fetchstr>
}
    800028ac:	70a2                	ld	ra,40(sp)
    800028ae:	7402                	ld	s0,32(sp)
    800028b0:	64e2                	ld	s1,24(sp)
    800028b2:	6942                	ld	s2,16(sp)
    800028b4:	6145                	addi	sp,sp,48
    800028b6:	8082                	ret

00000000800028b8 <syscall>:
  // clang-format on
};

void
syscall(void)
{
    800028b8:	1101                	addi	sp,sp,-32
    800028ba:	ec06                	sd	ra,24(sp)
    800028bc:	e822                	sd	s0,16(sp)
    800028be:	e426                	sd	s1,8(sp)
    800028c0:	e04a                	sd	s2,0(sp)
    800028c2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800028c4:	fcffe0ef          	jal	80001892 <myproc>
    800028c8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800028ca:	05853903          	ld	s2,88(a0)
    800028ce:	0a893783          	ld	a5,168(s2)
    800028d2:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800028d6:	37fd                	addiw	a5,a5,-1
    800028d8:	4761                	li	a4,24
    800028da:	00f76f63          	bltu	a4,a5,800028f8 <syscall+0x40>
    800028de:	00369713          	slli	a4,a3,0x3
    800028e2:	00005797          	auipc	a5,0x5
    800028e6:	e8e78793          	addi	a5,a5,-370 # 80007770 <syscalls>
    800028ea:	97ba                	add	a5,a5,a4
    800028ec:	639c                	ld	a5,0(a5)
    800028ee:	c789                	beqz	a5,800028f8 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800028f0:	9782                	jalr	a5
    800028f2:	06a93823          	sd	a0,112(s2)
    800028f6:	a829                	j	80002910 <syscall+0x58>
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800028f8:	15848613          	addi	a2,s1,344
    800028fc:	588c                	lw	a1,48(s1)
    800028fe:	00005517          	auipc	a0,0x5
    80002902:	a7250513          	addi	a0,a0,-1422 # 80007370 <etext+0x370>
    80002906:	be9fd0ef          	jal	800004ee <printk>
    p->trapframe->a0 = -1;
    8000290a:	6cbc                	ld	a5,88(s1)
    8000290c:	577d                	li	a4,-1
    8000290e:	fbb8                	sd	a4,112(a5)
  }
}
    80002910:	60e2                	ld	ra,24(sp)
    80002912:	6442                	ld	s0,16(sp)
    80002914:	64a2                	ld	s1,8(sp)
    80002916:	6902                	ld	s2,0(sp)
    80002918:	6105                	addi	sp,sp,32
    8000291a:	8082                	ret

000000008000291c <sys_getwaittime>:
#include "vm.h"

// Felipe
uint64
sys_getwaittime(void)
{
    8000291c:	1141                	addi	sp,sp,-16
    8000291e:	e406                	sd	ra,8(sp)
    80002920:	e022                	sd	s0,0(sp)
    80002922:	0800                	addi	s0,sp,16
  return myproc()->wtime;
    80002924:	f6ffe0ef          	jal	80001892 <myproc>
}
    80002928:	17052503          	lw	a0,368(a0)
    8000292c:	60a2                	ld	ra,8(sp)
    8000292e:	6402                	ld	s0,0(sp)
    80002930:	0141                	addi	sp,sp,16
    80002932:	8082                	ret

0000000080002934 <sys_setburst>:

uint64
sys_setburst(void)
{
    80002934:	1101                	addi	sp,sp,-32
    80002936:	ec06                	sd	ra,24(sp)
    80002938:	e822                	sd	s0,16(sp)
    8000293a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);          // lê o primeiro (0th) argumento em n
    8000293c:	fec40593          	addi	a1,s0,-20
    80002940:	4501                	li	a0,0
    80002942:	f0fff0ef          	jal	80002850 <argint>
  if (n < 0)
    80002946:	fec42783          	lw	a5,-20(s0)
    return -1;
    8000294a:	557d                	li	a0,-1
  if (n < 0)
    8000294c:	0007c963          	bltz	a5,8000295e <sys_setburst+0x2a>
  myproc()->burst = n;
    80002950:	f43fe0ef          	jal	80001892 <myproc>
    80002954:	fec42783          	lw	a5,-20(s0)
    80002958:	16f52c23          	sw	a5,376(a0)
  return 0;
    8000295c:	4501                	li	a0,0
}
    8000295e:	60e2                	ld	ra,24(sp)
    80002960:	6442                	ld	s0,16(sp)
    80002962:	6105                	addi	sp,sp,32
    80002964:	8082                	ret

0000000080002966 <sys_setburstpid>:

uint64
sys_setburstpid(void)
{
    80002966:	7139                	addi	sp,sp,-64
    80002968:	fc06                	sd	ra,56(sp)
    8000296a:	f822                	sd	s0,48(sp)
    8000296c:	0080                	addi	s0,sp,64
  int pid, n;
  argint(0, &pid);
    8000296e:	fcc40593          	addi	a1,s0,-52
    80002972:	4501                	li	a0,0
    80002974:	eddff0ef          	jal	80002850 <argint>
  argint(1, &n);
    80002978:	fc840593          	addi	a1,s0,-56
    8000297c:	4505                	li	a0,1
    8000297e:	ed3ff0ef          	jal	80002850 <argint>
  if (n < 0)
    80002982:	fc842783          	lw	a5,-56(s0)
    80002986:	0607c063          	bltz	a5,800029e6 <sys_setburstpid+0x80>
    8000298a:	f426                	sd	s1,40(sp)
    8000298c:	f04a                	sd	s2,32(sp)
    8000298e:	ec4e                	sd	s3,24(sp)
    80002990:	e852                	sd	s4,16(sp)
    return -1;

  struct proc *p;
  int found = 0;
    80002992:	4981                	li	s3,0
  for (p = proc; p < &proc[NPROC]; p++) {
    80002994:	00010497          	auipc	s1,0x10
    80002998:	e3448493          	addi	s1,s1,-460 # 800127c8 <proc>
    acquire(&p->lock);
    if (p->pid == pid) {
      p->burst = n;
      found = 1;
    8000299c:	4a05                	li	s4,1
  for (p = proc; p < &proc[NPROC]; p++) {
    8000299e:	00016917          	auipc	s2,0x16
    800029a2:	e2a90913          	addi	s2,s2,-470 # 800187c8 <tickslock>
    800029a6:	a801                	j	800029b6 <sys_setburstpid+0x50>
    }
    release(&p->lock);
    800029a8:	8526                	mv	a0,s1
    800029aa:	a84fe0ef          	jal	80000c2e <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800029ae:	18048493          	addi	s1,s1,384
    800029b2:	03248063          	beq	s1,s2,800029d2 <sys_setburstpid+0x6c>
    acquire(&p->lock);
    800029b6:	8526                	mv	a0,s1
    800029b8:	9eafe0ef          	jal	80000ba2 <acquire>
    if (p->pid == pid) {
    800029bc:	5898                	lw	a4,48(s1)
    800029be:	fcc42783          	lw	a5,-52(s0)
    800029c2:	fef713e3          	bne	a4,a5,800029a8 <sys_setburstpid+0x42>
      p->burst = n;
    800029c6:	fc842783          	lw	a5,-56(s0)
    800029ca:	16f4ac23          	sw	a5,376(s1)
      found = 1;
    800029ce:	89d2                	mv	s3,s4
    800029d0:	bfe1                	j	800029a8 <sys_setburstpid+0x42>
  }
  return found ? 0 : -1;
    800029d2:	fff98513          	addi	a0,s3,-1
    800029d6:	74a2                	ld	s1,40(sp)
    800029d8:	7902                	ld	s2,32(sp)
    800029da:	69e2                	ld	s3,24(sp)
    800029dc:	6a42                	ld	s4,16(sp)
}
    800029de:	70e2                	ld	ra,56(sp)
    800029e0:	7442                	ld	s0,48(sp)
    800029e2:	6121                	addi	sp,sp,64
    800029e4:	8082                	ret
    return -1;
    800029e6:	557d                	li	a0,-1
    800029e8:	bfdd                	j	800029de <sys_setburstpid+0x78>

00000000800029ea <sys_exit>:

uint64
sys_exit(void)
{
    800029ea:	1101                	addi	sp,sp,-32
    800029ec:	ec06                	sd	ra,24(sp)
    800029ee:	e822                	sd	s0,16(sp)
    800029f0:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800029f2:	fec40593          	addi	a1,s0,-20
    800029f6:	4501                	li	a0,0
    800029f8:	e59ff0ef          	jal	80002850 <argint>
  kexit(n);
    800029fc:	fec42503          	lw	a0,-20(s0)
    80002a00:	e62ff0ef          	jal	80002062 <kexit>
  return 0; // not reached
}
    80002a04:	4501                	li	a0,0
    80002a06:	60e2                	ld	ra,24(sp)
    80002a08:	6442                	ld	s0,16(sp)
    80002a0a:	6105                	addi	sp,sp,32
    80002a0c:	8082                	ret

0000000080002a0e <sys_getpid>:

uint64
sys_getpid(void)
{
    80002a0e:	1141                	addi	sp,sp,-16
    80002a10:	e406                	sd	ra,8(sp)
    80002a12:	e022                	sd	s0,0(sp)
    80002a14:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002a16:	e7dfe0ef          	jal	80001892 <myproc>
}
    80002a1a:	5908                	lw	a0,48(a0)
    80002a1c:	60a2                	ld	ra,8(sp)
    80002a1e:	6402                	ld	s0,0(sp)
    80002a20:	0141                	addi	sp,sp,16
    80002a22:	8082                	ret

0000000080002a24 <sys_fork>:

uint64
sys_fork(void)
{
    80002a24:	1141                	addi	sp,sp,-16
    80002a26:	e406                	sd	ra,8(sp)
    80002a28:	e022                	sd	s0,0(sp)
    80002a2a:	0800                	addi	s0,sp,16
  return kfork();
    80002a2c:	a4cff0ef          	jal	80001c78 <kfork>
}
    80002a30:	60a2                	ld	ra,8(sp)
    80002a32:	6402                	ld	s0,0(sp)
    80002a34:	0141                	addi	sp,sp,16
    80002a36:	8082                	ret

0000000080002a38 <sys_wait>:

uint64
sys_wait(void)
{
    80002a38:	1101                	addi	sp,sp,-32
    80002a3a:	ec06                	sd	ra,24(sp)
    80002a3c:	e822                	sd	s0,16(sp)
    80002a3e:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002a40:	fe840593          	addi	a1,s0,-24
    80002a44:	4501                	li	a0,0
    80002a46:	e27ff0ef          	jal	8000286c <argaddr>
  return kwait(p);
    80002a4a:	fe843503          	ld	a0,-24(s0)
    80002a4e:	f6aff0ef          	jal	800021b8 <kwait>
}
    80002a52:	60e2                	ld	ra,24(sp)
    80002a54:	6442                	ld	s0,16(sp)
    80002a56:	6105                	addi	sp,sp,32
    80002a58:	8082                	ret

0000000080002a5a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002a5a:	7179                	addi	sp,sp,-48
    80002a5c:	f406                	sd	ra,40(sp)
    80002a5e:	f022                	sd	s0,32(sp)
    80002a60:	ec26                	sd	s1,24(sp)
    80002a62:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002a64:	fd840593          	addi	a1,s0,-40
    80002a68:	4501                	li	a0,0
    80002a6a:	de7ff0ef          	jal	80002850 <argint>
  argint(1, &t);
    80002a6e:	fdc40593          	addi	a1,s0,-36
    80002a72:	4505                	li	a0,1
    80002a74:	dddff0ef          	jal	80002850 <argint>
  addr = myproc()->sz;
    80002a78:	e1bfe0ef          	jal	80001892 <myproc>
    80002a7c:	6524                	ld	s1,72(a0)

  if (t == SBRK_EAGER || n < 0) {
    80002a7e:	fdc42703          	lw	a4,-36(s0)
    80002a82:	4785                	li	a5,1
    80002a84:	02f70763          	beq	a4,a5,80002ab2 <sys_sbrk+0x58>
    80002a88:	fd842783          	lw	a5,-40(s0)
    80002a8c:	0207c363          	bltz	a5,80002ab2 <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    80002a90:	97a6                	add	a5,a5,s1
    80002a92:	0297ee63          	bltu	a5,s1,80002ace <sys_sbrk+0x74>
      return -1;
    if (addr + n > TRAPFRAME)
    80002a96:	02000737          	lui	a4,0x2000
    80002a9a:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    80002a9c:	0736                	slli	a4,a4,0xd
    80002a9e:	02f76a63          	bltu	a4,a5,80002ad2 <sys_sbrk+0x78>
      return -1;
    myproc()->sz += n;
    80002aa2:	df1fe0ef          	jal	80001892 <myproc>
    80002aa6:	fd842703          	lw	a4,-40(s0)
    80002aaa:	653c                	ld	a5,72(a0)
    80002aac:	97ba                	add	a5,a5,a4
    80002aae:	e53c                	sd	a5,72(a0)
    80002ab0:	a039                	j	80002abe <sys_sbrk+0x64>
    if (growproc(n) < 0) {
    80002ab2:	fd842503          	lw	a0,-40(s0)
    80002ab6:	960ff0ef          	jal	80001c16 <growproc>
    80002aba:	00054863          	bltz	a0,80002aca <sys_sbrk+0x70>
  }
  return addr;
}
    80002abe:	8526                	mv	a0,s1
    80002ac0:	70a2                	ld	ra,40(sp)
    80002ac2:	7402                	ld	s0,32(sp)
    80002ac4:	64e2                	ld	s1,24(sp)
    80002ac6:	6145                	addi	sp,sp,48
    80002ac8:	8082                	ret
      return -1;
    80002aca:	54fd                	li	s1,-1
    80002acc:	bfcd                	j	80002abe <sys_sbrk+0x64>
      return -1;
    80002ace:	54fd                	li	s1,-1
    80002ad0:	b7fd                	j	80002abe <sys_sbrk+0x64>
      return -1;
    80002ad2:	54fd                	li	s1,-1
    80002ad4:	b7ed                	j	80002abe <sys_sbrk+0x64>

0000000080002ad6 <sys_pause>:

uint64
sys_pause(void)
{
    80002ad6:	7139                	addi	sp,sp,-64
    80002ad8:	fc06                	sd	ra,56(sp)
    80002ada:	f822                	sd	s0,48(sp)
    80002adc:	f04a                	sd	s2,32(sp)
    80002ade:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002ae0:	fcc40593          	addi	a1,s0,-52
    80002ae4:	4501                	li	a0,0
    80002ae6:	d6bff0ef          	jal	80002850 <argint>
  if (n < 0)
    80002aea:	fcc42783          	lw	a5,-52(s0)
    80002aee:	0607c763          	bltz	a5,80002b5c <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80002af2:	00016517          	auipc	a0,0x16
    80002af6:	cd650513          	addi	a0,a0,-810 # 800187c8 <tickslock>
    80002afa:	8a8fe0ef          	jal	80000ba2 <acquire>
  ticks0 = ticks;
    80002afe:	00007917          	auipc	s2,0x7
    80002b02:	79a92903          	lw	s2,1946(s2) # 8000a298 <ticks>
  while (ticks - ticks0 < n) {
    80002b06:	fcc42783          	lw	a5,-52(s0)
    80002b0a:	cf8d                	beqz	a5,80002b44 <sys_pause+0x6e>
    80002b0c:	f426                	sd	s1,40(sp)
    80002b0e:	ec4e                	sd	s3,24(sp)
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002b10:	00016997          	auipc	s3,0x16
    80002b14:	cb898993          	addi	s3,s3,-840 # 800187c8 <tickslock>
    80002b18:	00007497          	auipc	s1,0x7
    80002b1c:	78048493          	addi	s1,s1,1920 # 8000a298 <ticks>
    if (killed(myproc())) {
    80002b20:	d73fe0ef          	jal	80001892 <myproc>
    80002b24:	e6aff0ef          	jal	8000218e <killed>
    80002b28:	ed0d                	bnez	a0,80002b62 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002b2a:	85ce                	mv	a1,s3
    80002b2c:	8526                	mv	a0,s1
    80002b2e:	c28ff0ef          	jal	80001f56 <sleep>
  while (ticks - ticks0 < n) {
    80002b32:	409c                	lw	a5,0(s1)
    80002b34:	412787bb          	subw	a5,a5,s2
    80002b38:	fcc42703          	lw	a4,-52(s0)
    80002b3c:	fee7e2e3          	bltu	a5,a4,80002b20 <sys_pause+0x4a>
    80002b40:	74a2                	ld	s1,40(sp)
    80002b42:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002b44:	00016517          	auipc	a0,0x16
    80002b48:	c8450513          	addi	a0,a0,-892 # 800187c8 <tickslock>
    80002b4c:	8e2fe0ef          	jal	80000c2e <release>
  return 0;
    80002b50:	4501                	li	a0,0
}
    80002b52:	70e2                	ld	ra,56(sp)
    80002b54:	7442                	ld	s0,48(sp)
    80002b56:	7902                	ld	s2,32(sp)
    80002b58:	6121                	addi	sp,sp,64
    80002b5a:	8082                	ret
    n = 0;
    80002b5c:	fc042623          	sw	zero,-52(s0)
    80002b60:	bf49                	j	80002af2 <sys_pause+0x1c>
      release(&tickslock);
    80002b62:	00016517          	auipc	a0,0x16
    80002b66:	c6650513          	addi	a0,a0,-922 # 800187c8 <tickslock>
    80002b6a:	8c4fe0ef          	jal	80000c2e <release>
      return -1;
    80002b6e:	557d                	li	a0,-1
    80002b70:	74a2                	ld	s1,40(sp)
    80002b72:	69e2                	ld	s3,24(sp)
    80002b74:	bff9                	j	80002b52 <sys_pause+0x7c>

0000000080002b76 <sys_kill>:

uint64
sys_kill(void)
{
    80002b76:	1101                	addi	sp,sp,-32
    80002b78:	ec06                	sd	ra,24(sp)
    80002b7a:	e822                	sd	s0,16(sp)
    80002b7c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002b7e:	fec40593          	addi	a1,s0,-20
    80002b82:	4501                	li	a0,0
    80002b84:	ccdff0ef          	jal	80002850 <argint>
  return kkill(pid);
    80002b88:	fec42503          	lw	a0,-20(s0)
    80002b8c:	d78ff0ef          	jal	80002104 <kkill>
}
    80002b90:	60e2                	ld	ra,24(sp)
    80002b92:	6442                	ld	s0,16(sp)
    80002b94:	6105                	addi	sp,sp,32
    80002b96:	8082                	ret

0000000080002b98 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002b98:	1101                	addi	sp,sp,-32
    80002b9a:	ec06                	sd	ra,24(sp)
    80002b9c:	e822                	sd	s0,16(sp)
    80002b9e:	e426                	sd	s1,8(sp)
    80002ba0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002ba2:	00016517          	auipc	a0,0x16
    80002ba6:	c2650513          	addi	a0,a0,-986 # 800187c8 <tickslock>
    80002baa:	ff9fd0ef          	jal	80000ba2 <acquire>
  xticks = ticks;
    80002bae:	00007497          	auipc	s1,0x7
    80002bb2:	6ea4a483          	lw	s1,1770(s1) # 8000a298 <ticks>
  release(&tickslock);
    80002bb6:	00016517          	auipc	a0,0x16
    80002bba:	c1250513          	addi	a0,a0,-1006 # 800187c8 <tickslock>
    80002bbe:	870fe0ef          	jal	80000c2e <release>
  return xticks;
}
    80002bc2:	02049513          	slli	a0,s1,0x20
    80002bc6:	9101                	srli	a0,a0,0x20
    80002bc8:	60e2                	ld	ra,24(sp)
    80002bca:	6442                	ld	s0,16(sp)
    80002bcc:	64a2                	ld	s1,8(sp)
    80002bce:	6105                	addi	sp,sp,32
    80002bd0:	8082                	ret

0000000080002bd2 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002bd2:	7179                	addi	sp,sp,-48
    80002bd4:	f406                	sd	ra,40(sp)
    80002bd6:	f022                	sd	s0,32(sp)
    80002bd8:	ec26                	sd	s1,24(sp)
    80002bda:	e84a                	sd	s2,16(sp)
    80002bdc:	e44e                	sd	s3,8(sp)
    80002bde:	e052                	sd	s4,0(sp)
    80002be0:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002be2:	00004597          	auipc	a1,0x4
    80002be6:	7ae58593          	addi	a1,a1,1966 # 80007390 <etext+0x390>
    80002bea:	00016517          	auipc	a0,0x16
    80002bee:	bf650513          	addi	a0,a0,-1034 # 800187e0 <bcache>
    80002bf2:	f3bfd0ef          	jal	80000b2c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002bf6:	0001e797          	auipc	a5,0x1e
    80002bfa:	bea78793          	addi	a5,a5,-1046 # 800207e0 <bcache+0x8000>
    80002bfe:	0001e717          	auipc	a4,0x1e
    80002c02:	e4a70713          	addi	a4,a4,-438 # 80020a48 <bcache+0x8268>
    80002c06:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002c0a:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002c0e:	00016497          	auipc	s1,0x16
    80002c12:	bea48493          	addi	s1,s1,-1046 # 800187f8 <bcache+0x18>
    b->next = bcache.head.next;
    80002c16:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002c18:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002c1a:	00004a17          	auipc	s4,0x4
    80002c1e:	77ea0a13          	addi	s4,s4,1918 # 80007398 <etext+0x398>
    b->next = bcache.head.next;
    80002c22:	2b893783          	ld	a5,696(s2)
    80002c26:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002c28:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002c2c:	85d2                	mv	a1,s4
    80002c2e:	01048513          	addi	a0,s1,16
    80002c32:	38a010ef          	jal	80003fbc <initsleeplock>
    bcache.head.next->prev = b;
    80002c36:	2b893783          	ld	a5,696(s2)
    80002c3a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002c3c:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002c40:	45848493          	addi	s1,s1,1112
    80002c44:	fd349fe3          	bne	s1,s3,80002c22 <binit+0x50>
  }
}
    80002c48:	70a2                	ld	ra,40(sp)
    80002c4a:	7402                	ld	s0,32(sp)
    80002c4c:	64e2                	ld	s1,24(sp)
    80002c4e:	6942                	ld	s2,16(sp)
    80002c50:	69a2                	ld	s3,8(sp)
    80002c52:	6a02                	ld	s4,0(sp)
    80002c54:	6145                	addi	sp,sp,48
    80002c56:	8082                	ret

0000000080002c58 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    80002c58:	7179                	addi	sp,sp,-48
    80002c5a:	f406                	sd	ra,40(sp)
    80002c5c:	f022                	sd	s0,32(sp)
    80002c5e:	ec26                	sd	s1,24(sp)
    80002c60:	e84a                	sd	s2,16(sp)
    80002c62:	e44e                	sd	s3,8(sp)
    80002c64:	1800                	addi	s0,sp,48
    80002c66:	892a                	mv	s2,a0
    80002c68:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002c6a:	00016517          	auipc	a0,0x16
    80002c6e:	b7650513          	addi	a0,a0,-1162 # 800187e0 <bcache>
    80002c72:	f31fd0ef          	jal	80000ba2 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002c76:	0001e497          	auipc	s1,0x1e
    80002c7a:	e224b483          	ld	s1,-478(s1) # 80020a98 <bcache+0x82b8>
    80002c7e:	0001e797          	auipc	a5,0x1e
    80002c82:	dca78793          	addi	a5,a5,-566 # 80020a48 <bcache+0x8268>
    80002c86:	02f48b63          	beq	s1,a5,80002cbc <bread+0x64>
    80002c8a:	873e                	mv	a4,a5
    80002c8c:	a021                	j	80002c94 <bread+0x3c>
    80002c8e:	68a4                	ld	s1,80(s1)
    80002c90:	02e48663          	beq	s1,a4,80002cbc <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    80002c94:	449c                	lw	a5,8(s1)
    80002c96:	ff279ce3          	bne	a5,s2,80002c8e <bread+0x36>
    80002c9a:	44dc                	lw	a5,12(s1)
    80002c9c:	ff3799e3          	bne	a5,s3,80002c8e <bread+0x36>
      b->refcnt++;
    80002ca0:	40bc                	lw	a5,64(s1)
    80002ca2:	2785                	addiw	a5,a5,1
    80002ca4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ca6:	00016517          	auipc	a0,0x16
    80002caa:	b3a50513          	addi	a0,a0,-1222 # 800187e0 <bcache>
    80002cae:	f81fd0ef          	jal	80000c2e <release>
      acquiresleep(&b->lock);
    80002cb2:	01048513          	addi	a0,s1,16
    80002cb6:	33c010ef          	jal	80003ff2 <acquiresleep>
      return b;
    80002cba:	a889                	j	80002d0c <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002cbc:	0001e497          	auipc	s1,0x1e
    80002cc0:	dd44b483          	ld	s1,-556(s1) # 80020a90 <bcache+0x82b0>
    80002cc4:	0001e797          	auipc	a5,0x1e
    80002cc8:	d8478793          	addi	a5,a5,-636 # 80020a48 <bcache+0x8268>
    80002ccc:	00f48863          	beq	s1,a5,80002cdc <bread+0x84>
    80002cd0:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002cd2:	40bc                	lw	a5,64(s1)
    80002cd4:	cb91                	beqz	a5,80002ce8 <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002cd6:	64a4                	ld	s1,72(s1)
    80002cd8:	fee49de3          	bne	s1,a4,80002cd2 <bread+0x7a>
  panic("bget: no buffers");
    80002cdc:	00004517          	auipc	a0,0x4
    80002ce0:	6c450513          	addi	a0,a0,1732 # 800073a0 <etext+0x3a0>
    80002ce4:	af1fd0ef          	jal	800007d4 <panic>
      b->dev = dev;
    80002ce8:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002cec:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002cf0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002cf4:	4785                	li	a5,1
    80002cf6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002cf8:	00016517          	auipc	a0,0x16
    80002cfc:	ae850513          	addi	a0,a0,-1304 # 800187e0 <bcache>
    80002d00:	f2ffd0ef          	jal	80000c2e <release>
      acquiresleep(&b->lock);
    80002d04:	01048513          	addi	a0,s1,16
    80002d08:	2ea010ef          	jal	80003ff2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002d0c:	409c                	lw	a5,0(s1)
    80002d0e:	cb89                	beqz	a5,80002d20 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002d10:	8526                	mv	a0,s1
    80002d12:	70a2                	ld	ra,40(sp)
    80002d14:	7402                	ld	s0,32(sp)
    80002d16:	64e2                	ld	s1,24(sp)
    80002d18:	6942                	ld	s2,16(sp)
    80002d1a:	69a2                	ld	s3,8(sp)
    80002d1c:	6145                	addi	sp,sp,48
    80002d1e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002d20:	4581                	li	a1,0
    80002d22:	8526                	mv	a0,s1
    80002d24:	33d020ef          	jal	80005860 <virtio_disk_rw>
    b->valid = 1;
    80002d28:	4785                	li	a5,1
    80002d2a:	c09c                	sw	a5,0(s1)
  return b;
    80002d2c:	b7d5                	j	80002d10 <bread+0xb8>

0000000080002d2e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002d2e:	1101                	addi	sp,sp,-32
    80002d30:	ec06                	sd	ra,24(sp)
    80002d32:	e822                	sd	s0,16(sp)
    80002d34:	e426                	sd	s1,8(sp)
    80002d36:	1000                	addi	s0,sp,32
    80002d38:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002d3a:	0541                	addi	a0,a0,16
    80002d3c:	334010ef          	jal	80004070 <holdingsleep>
    80002d40:	c911                	beqz	a0,80002d54 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002d42:	4585                	li	a1,1
    80002d44:	8526                	mv	a0,s1
    80002d46:	31b020ef          	jal	80005860 <virtio_disk_rw>
}
    80002d4a:	60e2                	ld	ra,24(sp)
    80002d4c:	6442                	ld	s0,16(sp)
    80002d4e:	64a2                	ld	s1,8(sp)
    80002d50:	6105                	addi	sp,sp,32
    80002d52:	8082                	ret
    panic("bwrite");
    80002d54:	00004517          	auipc	a0,0x4
    80002d58:	66450513          	addi	a0,a0,1636 # 800073b8 <etext+0x3b8>
    80002d5c:	a79fd0ef          	jal	800007d4 <panic>

0000000080002d60 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002d60:	1101                	addi	sp,sp,-32
    80002d62:	ec06                	sd	ra,24(sp)
    80002d64:	e822                	sd	s0,16(sp)
    80002d66:	e426                	sd	s1,8(sp)
    80002d68:	e04a                	sd	s2,0(sp)
    80002d6a:	1000                	addi	s0,sp,32
    80002d6c:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002d6e:	01050913          	addi	s2,a0,16
    80002d72:	854a                	mv	a0,s2
    80002d74:	2fc010ef          	jal	80004070 <holdingsleep>
    80002d78:	c135                	beqz	a0,80002ddc <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002d7a:	854a                	mv	a0,s2
    80002d7c:	2bc010ef          	jal	80004038 <releasesleep>

  acquire(&bcache.lock);
    80002d80:	00016517          	auipc	a0,0x16
    80002d84:	a6050513          	addi	a0,a0,-1440 # 800187e0 <bcache>
    80002d88:	e1bfd0ef          	jal	80000ba2 <acquire>
  b->refcnt--;
    80002d8c:	40bc                	lw	a5,64(s1)
    80002d8e:	37fd                	addiw	a5,a5,-1
    80002d90:	0007871b          	sext.w	a4,a5
    80002d94:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002d96:	e71d                	bnez	a4,80002dc4 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002d98:	68b8                	ld	a4,80(s1)
    80002d9a:	64bc                	ld	a5,72(s1)
    80002d9c:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002d9e:	68b8                	ld	a4,80(s1)
    80002da0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002da2:	0001e797          	auipc	a5,0x1e
    80002da6:	a3e78793          	addi	a5,a5,-1474 # 800207e0 <bcache+0x8000>
    80002daa:	2b87b703          	ld	a4,696(a5)
    80002dae:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002db0:	0001e717          	auipc	a4,0x1e
    80002db4:	c9870713          	addi	a4,a4,-872 # 80020a48 <bcache+0x8268>
    80002db8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002dba:	2b87b703          	ld	a4,696(a5)
    80002dbe:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002dc0:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002dc4:	00016517          	auipc	a0,0x16
    80002dc8:	a1c50513          	addi	a0,a0,-1508 # 800187e0 <bcache>
    80002dcc:	e63fd0ef          	jal	80000c2e <release>
}
    80002dd0:	60e2                	ld	ra,24(sp)
    80002dd2:	6442                	ld	s0,16(sp)
    80002dd4:	64a2                	ld	s1,8(sp)
    80002dd6:	6902                	ld	s2,0(sp)
    80002dd8:	6105                	addi	sp,sp,32
    80002dda:	8082                	ret
    panic("brelse");
    80002ddc:	00004517          	auipc	a0,0x4
    80002de0:	5e450513          	addi	a0,a0,1508 # 800073c0 <etext+0x3c0>
    80002de4:	9f1fd0ef          	jal	800007d4 <panic>

0000000080002de8 <bpin>:

void
bpin(struct buf *b)
{
    80002de8:	1101                	addi	sp,sp,-32
    80002dea:	ec06                	sd	ra,24(sp)
    80002dec:	e822                	sd	s0,16(sp)
    80002dee:	e426                	sd	s1,8(sp)
    80002df0:	1000                	addi	s0,sp,32
    80002df2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002df4:	00016517          	auipc	a0,0x16
    80002df8:	9ec50513          	addi	a0,a0,-1556 # 800187e0 <bcache>
    80002dfc:	da7fd0ef          	jal	80000ba2 <acquire>
  b->refcnt++;
    80002e00:	40bc                	lw	a5,64(s1)
    80002e02:	2785                	addiw	a5,a5,1
    80002e04:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e06:	00016517          	auipc	a0,0x16
    80002e0a:	9da50513          	addi	a0,a0,-1574 # 800187e0 <bcache>
    80002e0e:	e21fd0ef          	jal	80000c2e <release>
}
    80002e12:	60e2                	ld	ra,24(sp)
    80002e14:	6442                	ld	s0,16(sp)
    80002e16:	64a2                	ld	s1,8(sp)
    80002e18:	6105                	addi	sp,sp,32
    80002e1a:	8082                	ret

0000000080002e1c <bunpin>:

void
bunpin(struct buf *b)
{
    80002e1c:	1101                	addi	sp,sp,-32
    80002e1e:	ec06                	sd	ra,24(sp)
    80002e20:	e822                	sd	s0,16(sp)
    80002e22:	e426                	sd	s1,8(sp)
    80002e24:	1000                	addi	s0,sp,32
    80002e26:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e28:	00016517          	auipc	a0,0x16
    80002e2c:	9b850513          	addi	a0,a0,-1608 # 800187e0 <bcache>
    80002e30:	d73fd0ef          	jal	80000ba2 <acquire>
  b->refcnt--;
    80002e34:	40bc                	lw	a5,64(s1)
    80002e36:	37fd                	addiw	a5,a5,-1
    80002e38:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e3a:	00016517          	auipc	a0,0x16
    80002e3e:	9a650513          	addi	a0,a0,-1626 # 800187e0 <bcache>
    80002e42:	dedfd0ef          	jal	80000c2e <release>
}
    80002e46:	60e2                	ld	ra,24(sp)
    80002e48:	6442                	ld	s0,16(sp)
    80002e4a:	64a2                	ld	s1,8(sp)
    80002e4c:	6105                	addi	sp,sp,32
    80002e4e:	8082                	ret

0000000080002e50 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002e50:	1101                	addi	sp,sp,-32
    80002e52:	ec06                	sd	ra,24(sp)
    80002e54:	e822                	sd	s0,16(sp)
    80002e56:	e426                	sd	s1,8(sp)
    80002e58:	e04a                	sd	s2,0(sp)
    80002e5a:	1000                	addi	s0,sp,32
    80002e5c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002e5e:	00d5d59b          	srliw	a1,a1,0xd
    80002e62:	0001e797          	auipc	a5,0x1e
    80002e66:	05a7a783          	lw	a5,90(a5) # 80020ebc <sb+0x1c>
    80002e6a:	9dbd                	addw	a1,a1,a5
    80002e6c:	dedff0ef          	jal	80002c58 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002e70:	0074f713          	andi	a4,s1,7
    80002e74:	4785                	li	a5,1
    80002e76:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0)
    80002e7a:	14ce                	slli	s1,s1,0x33
    80002e7c:	90d9                	srli	s1,s1,0x36
    80002e7e:	00950733          	add	a4,a0,s1
    80002e82:	05874703          	lbu	a4,88(a4)
    80002e86:	00e7f6b3          	and	a3,a5,a4
    80002e8a:	c29d                	beqz	a3,80002eb0 <bfree+0x60>
    80002e8c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    80002e8e:	94aa                	add	s1,s1,a0
    80002e90:	fff7c793          	not	a5,a5
    80002e94:	8f7d                	and	a4,a4,a5
    80002e96:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002e9a:	7ff000ef          	jal	80003e98 <log_write>
  brelse(bp);
    80002e9e:	854a                	mv	a0,s2
    80002ea0:	ec1ff0ef          	jal	80002d60 <brelse>
}
    80002ea4:	60e2                	ld	ra,24(sp)
    80002ea6:	6442                	ld	s0,16(sp)
    80002ea8:	64a2                	ld	s1,8(sp)
    80002eaa:	6902                	ld	s2,0(sp)
    80002eac:	6105                	addi	sp,sp,32
    80002eae:	8082                	ret
    panic("freeing free block");
    80002eb0:	00004517          	auipc	a0,0x4
    80002eb4:	51850513          	addi	a0,a0,1304 # 800073c8 <etext+0x3c8>
    80002eb8:	91dfd0ef          	jal	800007d4 <panic>

0000000080002ebc <balloc>:
{
    80002ebc:	711d                	addi	sp,sp,-96
    80002ebe:	ec86                	sd	ra,88(sp)
    80002ec0:	e8a2                	sd	s0,80(sp)
    80002ec2:	e4a6                	sd	s1,72(sp)
    80002ec4:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB) {
    80002ec6:	0001e797          	auipc	a5,0x1e
    80002eca:	fde7a783          	lw	a5,-34(a5) # 80020ea4 <sb+0x4>
    80002ece:	0e078f63          	beqz	a5,80002fcc <balloc+0x110>
    80002ed2:	e0ca                	sd	s2,64(sp)
    80002ed4:	fc4e                	sd	s3,56(sp)
    80002ed6:	f852                	sd	s4,48(sp)
    80002ed8:	f456                	sd	s5,40(sp)
    80002eda:	f05a                	sd	s6,32(sp)
    80002edc:	ec5e                	sd	s7,24(sp)
    80002ede:	e862                	sd	s8,16(sp)
    80002ee0:	e466                	sd	s9,8(sp)
    80002ee2:	8baa                	mv	s7,a0
    80002ee4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002ee6:	0001eb17          	auipc	s6,0x1e
    80002eea:	fbab0b13          	addi	s6,s6,-70 # 80020ea0 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002eee:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002ef0:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002ef2:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80002ef4:	6c89                	lui	s9,0x2
    80002ef6:	a0b5                	j	80002f62 <balloc+0xa6>
        bp->data[bi / 8] |= m;           // Mark block in use.
    80002ef8:	97ca                	add	a5,a5,s2
    80002efa:	8e55                	or	a2,a2,a3
    80002efc:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002f00:	854a                	mv	a0,s2
    80002f02:	797000ef          	jal	80003e98 <log_write>
        brelse(bp);
    80002f06:	854a                	mv	a0,s2
    80002f08:	e59ff0ef          	jal	80002d60 <brelse>
  bp = bread(dev, bno);
    80002f0c:	85a6                	mv	a1,s1
    80002f0e:	855e                	mv	a0,s7
    80002f10:	d49ff0ef          	jal	80002c58 <bread>
    80002f14:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002f16:	40000613          	li	a2,1024
    80002f1a:	4581                	li	a1,0
    80002f1c:	05850513          	addi	a0,a0,88
    80002f20:	d47fd0ef          	jal	80000c66 <memset>
  log_write(bp);
    80002f24:	854a                	mv	a0,s2
    80002f26:	773000ef          	jal	80003e98 <log_write>
  brelse(bp);
    80002f2a:	854a                	mv	a0,s2
    80002f2c:	e35ff0ef          	jal	80002d60 <brelse>
}
    80002f30:	6906                	ld	s2,64(sp)
    80002f32:	79e2                	ld	s3,56(sp)
    80002f34:	7a42                	ld	s4,48(sp)
    80002f36:	7aa2                	ld	s5,40(sp)
    80002f38:	7b02                	ld	s6,32(sp)
    80002f3a:	6be2                	ld	s7,24(sp)
    80002f3c:	6c42                	ld	s8,16(sp)
    80002f3e:	6ca2                	ld	s9,8(sp)
}
    80002f40:	8526                	mv	a0,s1
    80002f42:	60e6                	ld	ra,88(sp)
    80002f44:	6446                	ld	s0,80(sp)
    80002f46:	64a6                	ld	s1,72(sp)
    80002f48:	6125                	addi	sp,sp,96
    80002f4a:	8082                	ret
    brelse(bp);
    80002f4c:	854a                	mv	a0,s2
    80002f4e:	e13ff0ef          	jal	80002d60 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80002f52:	015c87bb          	addw	a5,s9,s5
    80002f56:	00078a9b          	sext.w	s5,a5
    80002f5a:	004b2703          	lw	a4,4(s6)
    80002f5e:	04eaff63          	bgeu	s5,a4,80002fbc <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002f62:	41fad79b          	sraiw	a5,s5,0x1f
    80002f66:	0137d79b          	srliw	a5,a5,0x13
    80002f6a:	015787bb          	addw	a5,a5,s5
    80002f6e:	40d7d79b          	sraiw	a5,a5,0xd
    80002f72:	01cb2583          	lw	a1,28(s6)
    80002f76:	9dbd                	addw	a1,a1,a5
    80002f78:	855e                	mv	a0,s7
    80002f7a:	cdfff0ef          	jal	80002c58 <bread>
    80002f7e:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002f80:	004b2503          	lw	a0,4(s6)
    80002f84:	000a849b          	sext.w	s1,s5
    80002f88:	8762                	mv	a4,s8
    80002f8a:	fca4f1e3          	bgeu	s1,a0,80002f4c <balloc+0x90>
      m = 1 << (bi % 8);
    80002f8e:	00777693          	andi	a3,a4,7
    80002f92:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    80002f96:	41f7579b          	sraiw	a5,a4,0x1f
    80002f9a:	01d7d79b          	srliw	a5,a5,0x1d
    80002f9e:	9fb9                	addw	a5,a5,a4
    80002fa0:	4037d79b          	sraiw	a5,a5,0x3
    80002fa4:	00f90633          	add	a2,s2,a5
    80002fa8:	05864603          	lbu	a2,88(a2)
    80002fac:	00c6f5b3          	and	a1,a3,a2
    80002fb0:	d5a1                	beqz	a1,80002ef8 <balloc+0x3c>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002fb2:	2705                	addiw	a4,a4,1
    80002fb4:	2485                	addiw	s1,s1,1
    80002fb6:	fd471ae3          	bne	a4,s4,80002f8a <balloc+0xce>
    80002fba:	bf49                	j	80002f4c <balloc+0x90>
    80002fbc:	6906                	ld	s2,64(sp)
    80002fbe:	79e2                	ld	s3,56(sp)
    80002fc0:	7a42                	ld	s4,48(sp)
    80002fc2:	7aa2                	ld	s5,40(sp)
    80002fc4:	7b02                	ld	s6,32(sp)
    80002fc6:	6be2                	ld	s7,24(sp)
    80002fc8:	6c42                	ld	s8,16(sp)
    80002fca:	6ca2                	ld	s9,8(sp)
  printk("balloc: out of blocks\n");
    80002fcc:	00004517          	auipc	a0,0x4
    80002fd0:	41450513          	addi	a0,a0,1044 # 800073e0 <etext+0x3e0>
    80002fd4:	d1afd0ef          	jal	800004ee <printk>
  return 0;
    80002fd8:	4481                	li	s1,0
    80002fda:	b79d                	j	80002f40 <balloc+0x84>

0000000080002fdc <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002fdc:	7179                	addi	sp,sp,-48
    80002fde:	f406                	sd	ra,40(sp)
    80002fe0:	f022                	sd	s0,32(sp)
    80002fe2:	ec26                	sd	s1,24(sp)
    80002fe4:	e84a                	sd	s2,16(sp)
    80002fe6:	e44e                	sd	s3,8(sp)
    80002fe8:	1800                	addi	s0,sp,48
    80002fea:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80002fec:	47ad                	li	a5,11
    80002fee:	02b7e663          	bltu	a5,a1,8000301a <bmap+0x3e>
    if ((addr = ip->addrs[bn]) == 0) {
    80002ff2:	02059793          	slli	a5,a1,0x20
    80002ff6:	01e7d593          	srli	a1,a5,0x1e
    80002ffa:	00b504b3          	add	s1,a0,a1
    80002ffe:	0504a903          	lw	s2,80(s1)
    80003002:	06091a63          	bnez	s2,80003076 <bmap+0x9a>
      addr = balloc(ip->dev);
    80003006:	4108                	lw	a0,0(a0)
    80003008:	eb5ff0ef          	jal	80002ebc <balloc>
    8000300c:	0005091b          	sext.w	s2,a0
      if (addr == 0)
    80003010:	06090363          	beqz	s2,80003076 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80003014:	0524a823          	sw	s2,80(s1)
    80003018:	a8b9                	j	80003076 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000301a:	ff45849b          	addiw	s1,a1,-12
    8000301e:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT) {
    80003022:	0ff00793          	li	a5,255
    80003026:	06e7ee63          	bltu	a5,a4,800030a2 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    8000302a:	08052903          	lw	s2,128(a0)
    8000302e:	00091d63          	bnez	s2,80003048 <bmap+0x6c>
      addr = balloc(ip->dev);
    80003032:	4108                	lw	a0,0(a0)
    80003034:	e89ff0ef          	jal	80002ebc <balloc>
    80003038:	0005091b          	sext.w	s2,a0
      if (addr == 0)
    8000303c:	02090d63          	beqz	s2,80003076 <bmap+0x9a>
    80003040:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003042:	0929a023          	sw	s2,128(s3)
    80003046:	a011                	j	8000304a <bmap+0x6e>
    80003048:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000304a:	85ca                	mv	a1,s2
    8000304c:	0009a503          	lw	a0,0(s3)
    80003050:	c09ff0ef          	jal	80002c58 <bread>
    80003054:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80003056:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    8000305a:	02049713          	slli	a4,s1,0x20
    8000305e:	01e75593          	srli	a1,a4,0x1e
    80003062:	00b784b3          	add	s1,a5,a1
    80003066:	0004a903          	lw	s2,0(s1)
    8000306a:	00090e63          	beqz	s2,80003086 <bmap+0xaa>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000306e:	8552                	mv	a0,s4
    80003070:	cf1ff0ef          	jal	80002d60 <brelse>
    return addr;
    80003074:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003076:	854a                	mv	a0,s2
    80003078:	70a2                	ld	ra,40(sp)
    8000307a:	7402                	ld	s0,32(sp)
    8000307c:	64e2                	ld	s1,24(sp)
    8000307e:	6942                	ld	s2,16(sp)
    80003080:	69a2                	ld	s3,8(sp)
    80003082:	6145                	addi	sp,sp,48
    80003084:	8082                	ret
      addr = balloc(ip->dev);
    80003086:	0009a503          	lw	a0,0(s3)
    8000308a:	e33ff0ef          	jal	80002ebc <balloc>
    8000308e:	0005091b          	sext.w	s2,a0
      if (addr) {
    80003092:	fc090ee3          	beqz	s2,8000306e <bmap+0x92>
        a[bn] = addr;
    80003096:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000309a:	8552                	mv	a0,s4
    8000309c:	5fd000ef          	jal	80003e98 <log_write>
    800030a0:	b7f9                	j	8000306e <bmap+0x92>
    800030a2:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800030a4:	00004517          	auipc	a0,0x4
    800030a8:	35450513          	addi	a0,a0,852 # 800073f8 <etext+0x3f8>
    800030ac:	f28fd0ef          	jal	800007d4 <panic>

00000000800030b0 <iget>:
{
    800030b0:	7179                	addi	sp,sp,-48
    800030b2:	f406                	sd	ra,40(sp)
    800030b4:	f022                	sd	s0,32(sp)
    800030b6:	ec26                	sd	s1,24(sp)
    800030b8:	e84a                	sd	s2,16(sp)
    800030ba:	e44e                	sd	s3,8(sp)
    800030bc:	e052                	sd	s4,0(sp)
    800030be:	1800                	addi	s0,sp,48
    800030c0:	89aa                	mv	s3,a0
    800030c2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800030c4:	0001e517          	auipc	a0,0x1e
    800030c8:	dfc50513          	addi	a0,a0,-516 # 80020ec0 <itable>
    800030cc:	ad7fd0ef          	jal	80000ba2 <acquire>
  empty = 0;
    800030d0:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    800030d2:	0001e497          	auipc	s1,0x1e
    800030d6:	e0648493          	addi	s1,s1,-506 # 80020ed8 <itable+0x18>
    800030da:	00020697          	auipc	a3,0x20
    800030de:	88e68693          	addi	a3,a3,-1906 # 80022968 <log>
    800030e2:	a039                	j	800030f0 <iget+0x40>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    800030e4:	02090963          	beqz	s2,80003116 <iget+0x66>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    800030e8:	08848493          	addi	s1,s1,136
    800030ec:	02d48863          	beq	s1,a3,8000311c <iget+0x6c>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    800030f0:	449c                	lw	a5,8(s1)
    800030f2:	fef059e3          	blez	a5,800030e4 <iget+0x34>
    800030f6:	4098                	lw	a4,0(s1)
    800030f8:	ff3716e3          	bne	a4,s3,800030e4 <iget+0x34>
    800030fc:	40d8                	lw	a4,4(s1)
    800030fe:	ff4713e3          	bne	a4,s4,800030e4 <iget+0x34>
      ip->ref++;
    80003102:	2785                	addiw	a5,a5,1
    80003104:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003106:	0001e517          	auipc	a0,0x1e
    8000310a:	dba50513          	addi	a0,a0,-582 # 80020ec0 <itable>
    8000310e:	b21fd0ef          	jal	80000c2e <release>
      return ip;
    80003112:	8926                	mv	s2,s1
    80003114:	a02d                	j	8000313e <iget+0x8e>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80003116:	fbe9                	bnez	a5,800030e8 <iget+0x38>
      empty = ip;
    80003118:	8926                	mv	s2,s1
    8000311a:	b7f9                	j	800030e8 <iget+0x38>
  if (empty == 0)
    8000311c:	02090a63          	beqz	s2,80003150 <iget+0xa0>
  ip->dev = dev;
    80003120:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003124:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003128:	4785                	li	a5,1
    8000312a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000312e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003132:	0001e517          	auipc	a0,0x1e
    80003136:	d8e50513          	addi	a0,a0,-626 # 80020ec0 <itable>
    8000313a:	af5fd0ef          	jal	80000c2e <release>
}
    8000313e:	854a                	mv	a0,s2
    80003140:	70a2                	ld	ra,40(sp)
    80003142:	7402                	ld	s0,32(sp)
    80003144:	64e2                	ld	s1,24(sp)
    80003146:	6942                	ld	s2,16(sp)
    80003148:	69a2                	ld	s3,8(sp)
    8000314a:	6a02                	ld	s4,0(sp)
    8000314c:	6145                	addi	sp,sp,48
    8000314e:	8082                	ret
    panic("iget: no inodes");
    80003150:	00004517          	auipc	a0,0x4
    80003154:	2c050513          	addi	a0,a0,704 # 80007410 <etext+0x410>
    80003158:	e7cfd0ef          	jal	800007d4 <panic>

000000008000315c <iinit>:
{
    8000315c:	7179                	addi	sp,sp,-48
    8000315e:	f406                	sd	ra,40(sp)
    80003160:	f022                	sd	s0,32(sp)
    80003162:	ec26                	sd	s1,24(sp)
    80003164:	e84a                	sd	s2,16(sp)
    80003166:	e44e                	sd	s3,8(sp)
    80003168:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000316a:	00004597          	auipc	a1,0x4
    8000316e:	2b658593          	addi	a1,a1,694 # 80007420 <etext+0x420>
    80003172:	0001e517          	auipc	a0,0x1e
    80003176:	d4e50513          	addi	a0,a0,-690 # 80020ec0 <itable>
    8000317a:	9b3fd0ef          	jal	80000b2c <initlock>
  for (i = 0; i < NINODE; i++) {
    8000317e:	0001e497          	auipc	s1,0x1e
    80003182:	d6a48493          	addi	s1,s1,-662 # 80020ee8 <itable+0x28>
    80003186:	0001f997          	auipc	s3,0x1f
    8000318a:	7f298993          	addi	s3,s3,2034 # 80022978 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000318e:	00004917          	auipc	s2,0x4
    80003192:	29a90913          	addi	s2,s2,666 # 80007428 <etext+0x428>
    80003196:	85ca                	mv	a1,s2
    80003198:	8526                	mv	a0,s1
    8000319a:	623000ef          	jal	80003fbc <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    8000319e:	08848493          	addi	s1,s1,136
    800031a2:	ff349ae3          	bne	s1,s3,80003196 <iinit+0x3a>
}
    800031a6:	70a2                	ld	ra,40(sp)
    800031a8:	7402                	ld	s0,32(sp)
    800031aa:	64e2                	ld	s1,24(sp)
    800031ac:	6942                	ld	s2,16(sp)
    800031ae:	69a2                	ld	s3,8(sp)
    800031b0:	6145                	addi	sp,sp,48
    800031b2:	8082                	ret

00000000800031b4 <ialloc>:
{
    800031b4:	7139                	addi	sp,sp,-64
    800031b6:	fc06                	sd	ra,56(sp)
    800031b8:	f822                	sd	s0,48(sp)
    800031ba:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    800031bc:	0001e717          	auipc	a4,0x1e
    800031c0:	cf072703          	lw	a4,-784(a4) # 80020eac <sb+0xc>
    800031c4:	4785                	li	a5,1
    800031c6:	06e7f063          	bgeu	a5,a4,80003226 <ialloc+0x72>
    800031ca:	f426                	sd	s1,40(sp)
    800031cc:	f04a                	sd	s2,32(sp)
    800031ce:	ec4e                	sd	s3,24(sp)
    800031d0:	e852                	sd	s4,16(sp)
    800031d2:	e456                	sd	s5,8(sp)
    800031d4:	e05a                	sd	s6,0(sp)
    800031d6:	8aaa                	mv	s5,a0
    800031d8:	8b2e                	mv	s6,a1
    800031da:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800031dc:	0001ea17          	auipc	s4,0x1e
    800031e0:	cc4a0a13          	addi	s4,s4,-828 # 80020ea0 <sb>
    800031e4:	00495593          	srli	a1,s2,0x4
    800031e8:	018a2783          	lw	a5,24(s4)
    800031ec:	9dbd                	addw	a1,a1,a5
    800031ee:	8556                	mv	a0,s5
    800031f0:	a69ff0ef          	jal	80002c58 <bread>
    800031f4:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    800031f6:	05850993          	addi	s3,a0,88
    800031fa:	00f97793          	andi	a5,s2,15
    800031fe:	079a                	slli	a5,a5,0x6
    80003200:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    80003202:	00099783          	lh	a5,0(s3)
    80003206:	cb9d                	beqz	a5,8000323c <ialloc+0x88>
    brelse(bp);
    80003208:	b59ff0ef          	jal	80002d60 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    8000320c:	0905                	addi	s2,s2,1
    8000320e:	00ca2703          	lw	a4,12(s4)
    80003212:	0009079b          	sext.w	a5,s2
    80003216:	fce7e7e3          	bltu	a5,a4,800031e4 <ialloc+0x30>
    8000321a:	74a2                	ld	s1,40(sp)
    8000321c:	7902                	ld	s2,32(sp)
    8000321e:	69e2                	ld	s3,24(sp)
    80003220:	6a42                	ld	s4,16(sp)
    80003222:	6aa2                	ld	s5,8(sp)
    80003224:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    80003226:	00004517          	auipc	a0,0x4
    8000322a:	20a50513          	addi	a0,a0,522 # 80007430 <etext+0x430>
    8000322e:	ac0fd0ef          	jal	800004ee <printk>
  return 0;
    80003232:	4501                	li	a0,0
}
    80003234:	70e2                	ld	ra,56(sp)
    80003236:	7442                	ld	s0,48(sp)
    80003238:	6121                	addi	sp,sp,64
    8000323a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000323c:	04000613          	li	a2,64
    80003240:	4581                	li	a1,0
    80003242:	854e                	mv	a0,s3
    80003244:	a23fd0ef          	jal	80000c66 <memset>
      dip->type = type;
    80003248:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    8000324c:	8526                	mv	a0,s1
    8000324e:	44b000ef          	jal	80003e98 <log_write>
      brelse(bp);
    80003252:	8526                	mv	a0,s1
    80003254:	b0dff0ef          	jal	80002d60 <brelse>
      return iget(dev, inum);
    80003258:	0009059b          	sext.w	a1,s2
    8000325c:	8556                	mv	a0,s5
    8000325e:	e53ff0ef          	jal	800030b0 <iget>
    80003262:	74a2                	ld	s1,40(sp)
    80003264:	7902                	ld	s2,32(sp)
    80003266:	69e2                	ld	s3,24(sp)
    80003268:	6a42                	ld	s4,16(sp)
    8000326a:	6aa2                	ld	s5,8(sp)
    8000326c:	6b02                	ld	s6,0(sp)
    8000326e:	b7d9                	j	80003234 <ialloc+0x80>

0000000080003270 <iupdate>:
{
    80003270:	1101                	addi	sp,sp,-32
    80003272:	ec06                	sd	ra,24(sp)
    80003274:	e822                	sd	s0,16(sp)
    80003276:	e426                	sd	s1,8(sp)
    80003278:	e04a                	sd	s2,0(sp)
    8000327a:	1000                	addi	s0,sp,32
    8000327c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000327e:	415c                	lw	a5,4(a0)
    80003280:	0047d79b          	srliw	a5,a5,0x4
    80003284:	0001e597          	auipc	a1,0x1e
    80003288:	c345a583          	lw	a1,-972(a1) # 80020eb8 <sb+0x18>
    8000328c:	9dbd                	addw	a1,a1,a5
    8000328e:	4108                	lw	a0,0(a0)
    80003290:	9c9ff0ef          	jal	80002c58 <bread>
    80003294:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003296:	05850793          	addi	a5,a0,88
    8000329a:	40d8                	lw	a4,4(s1)
    8000329c:	8b3d                	andi	a4,a4,15
    8000329e:	071a                	slli	a4,a4,0x6
    800032a0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800032a2:	04449703          	lh	a4,68(s1)
    800032a6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800032aa:	04649703          	lh	a4,70(s1)
    800032ae:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800032b2:	04849703          	lh	a4,72(s1)
    800032b6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800032ba:	04a49703          	lh	a4,74(s1)
    800032be:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800032c2:	44f8                	lw	a4,76(s1)
    800032c4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800032c6:	03400613          	li	a2,52
    800032ca:	05048593          	addi	a1,s1,80
    800032ce:	00c78513          	addi	a0,a5,12
    800032d2:	9f1fd0ef          	jal	80000cc2 <memmove>
  log_write(bp);
    800032d6:	854a                	mv	a0,s2
    800032d8:	3c1000ef          	jal	80003e98 <log_write>
  brelse(bp);
    800032dc:	854a                	mv	a0,s2
    800032de:	a83ff0ef          	jal	80002d60 <brelse>
}
    800032e2:	60e2                	ld	ra,24(sp)
    800032e4:	6442                	ld	s0,16(sp)
    800032e6:	64a2                	ld	s1,8(sp)
    800032e8:	6902                	ld	s2,0(sp)
    800032ea:	6105                	addi	sp,sp,32
    800032ec:	8082                	ret

00000000800032ee <idup>:
{
    800032ee:	1101                	addi	sp,sp,-32
    800032f0:	ec06                	sd	ra,24(sp)
    800032f2:	e822                	sd	s0,16(sp)
    800032f4:	e426                	sd	s1,8(sp)
    800032f6:	1000                	addi	s0,sp,32
    800032f8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800032fa:	0001e517          	auipc	a0,0x1e
    800032fe:	bc650513          	addi	a0,a0,-1082 # 80020ec0 <itable>
    80003302:	8a1fd0ef          	jal	80000ba2 <acquire>
  ip->ref++;
    80003306:	449c                	lw	a5,8(s1)
    80003308:	2785                	addiw	a5,a5,1
    8000330a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000330c:	0001e517          	auipc	a0,0x1e
    80003310:	bb450513          	addi	a0,a0,-1100 # 80020ec0 <itable>
    80003314:	91bfd0ef          	jal	80000c2e <release>
}
    80003318:	8526                	mv	a0,s1
    8000331a:	60e2                	ld	ra,24(sp)
    8000331c:	6442                	ld	s0,16(sp)
    8000331e:	64a2                	ld	s1,8(sp)
    80003320:	6105                	addi	sp,sp,32
    80003322:	8082                	ret

0000000080003324 <ilock>:
{
    80003324:	1101                	addi	sp,sp,-32
    80003326:	ec06                	sd	ra,24(sp)
    80003328:	e822                	sd	s0,16(sp)
    8000332a:	e426                	sd	s1,8(sp)
    8000332c:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    8000332e:	cd19                	beqz	a0,8000334c <ilock+0x28>
    80003330:	84aa                	mv	s1,a0
    80003332:	451c                	lw	a5,8(a0)
    80003334:	00f05c63          	blez	a5,8000334c <ilock+0x28>
  acquiresleep(&ip->lock);
    80003338:	0541                	addi	a0,a0,16
    8000333a:	4b9000ef          	jal	80003ff2 <acquiresleep>
  if (ip->valid == 0) {
    8000333e:	40bc                	lw	a5,64(s1)
    80003340:	cf89                	beqz	a5,8000335a <ilock+0x36>
}
    80003342:	60e2                	ld	ra,24(sp)
    80003344:	6442                	ld	s0,16(sp)
    80003346:	64a2                	ld	s1,8(sp)
    80003348:	6105                	addi	sp,sp,32
    8000334a:	8082                	ret
    8000334c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000334e:	00004517          	auipc	a0,0x4
    80003352:	0fa50513          	addi	a0,a0,250 # 80007448 <etext+0x448>
    80003356:	c7efd0ef          	jal	800007d4 <panic>
    8000335a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000335c:	40dc                	lw	a5,4(s1)
    8000335e:	0047d79b          	srliw	a5,a5,0x4
    80003362:	0001e597          	auipc	a1,0x1e
    80003366:	b565a583          	lw	a1,-1194(a1) # 80020eb8 <sb+0x18>
    8000336a:	9dbd                	addw	a1,a1,a5
    8000336c:	4088                	lw	a0,0(s1)
    8000336e:	8ebff0ef          	jal	80002c58 <bread>
    80003372:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003374:	05850593          	addi	a1,a0,88
    80003378:	40dc                	lw	a5,4(s1)
    8000337a:	8bbd                	andi	a5,a5,15
    8000337c:	079a                	slli	a5,a5,0x6
    8000337e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003380:	00059783          	lh	a5,0(a1)
    80003384:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003388:	00259783          	lh	a5,2(a1)
    8000338c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003390:	00459783          	lh	a5,4(a1)
    80003394:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003398:	00659783          	lh	a5,6(a1)
    8000339c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800033a0:	459c                	lw	a5,8(a1)
    800033a2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800033a4:	03400613          	li	a2,52
    800033a8:	05b1                	addi	a1,a1,12
    800033aa:	05048513          	addi	a0,s1,80
    800033ae:	915fd0ef          	jal	80000cc2 <memmove>
    brelse(bp);
    800033b2:	854a                	mv	a0,s2
    800033b4:	9adff0ef          	jal	80002d60 <brelse>
    ip->valid = 1;
    800033b8:	4785                	li	a5,1
    800033ba:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    800033bc:	04449783          	lh	a5,68(s1)
    800033c0:	c399                	beqz	a5,800033c6 <ilock+0xa2>
    800033c2:	6902                	ld	s2,0(sp)
    800033c4:	bfbd                	j	80003342 <ilock+0x1e>
      panic("ilock: no type");
    800033c6:	00004517          	auipc	a0,0x4
    800033ca:	08a50513          	addi	a0,a0,138 # 80007450 <etext+0x450>
    800033ce:	c06fd0ef          	jal	800007d4 <panic>

00000000800033d2 <iunlock>:
{
    800033d2:	1101                	addi	sp,sp,-32
    800033d4:	ec06                	sd	ra,24(sp)
    800033d6:	e822                	sd	s0,16(sp)
    800033d8:	e426                	sd	s1,8(sp)
    800033da:	e04a                	sd	s2,0(sp)
    800033dc:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800033de:	c505                	beqz	a0,80003406 <iunlock+0x34>
    800033e0:	84aa                	mv	s1,a0
    800033e2:	01050913          	addi	s2,a0,16
    800033e6:	854a                	mv	a0,s2
    800033e8:	489000ef          	jal	80004070 <holdingsleep>
    800033ec:	cd09                	beqz	a0,80003406 <iunlock+0x34>
    800033ee:	449c                	lw	a5,8(s1)
    800033f0:	00f05b63          	blez	a5,80003406 <iunlock+0x34>
  releasesleep(&ip->lock);
    800033f4:	854a                	mv	a0,s2
    800033f6:	443000ef          	jal	80004038 <releasesleep>
}
    800033fa:	60e2                	ld	ra,24(sp)
    800033fc:	6442                	ld	s0,16(sp)
    800033fe:	64a2                	ld	s1,8(sp)
    80003400:	6902                	ld	s2,0(sp)
    80003402:	6105                	addi	sp,sp,32
    80003404:	8082                	ret
    panic("iunlock");
    80003406:	00004517          	auipc	a0,0x4
    8000340a:	05a50513          	addi	a0,a0,90 # 80007460 <etext+0x460>
    8000340e:	bc6fd0ef          	jal	800007d4 <panic>

0000000080003412 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003412:	7179                	addi	sp,sp,-48
    80003414:	f406                	sd	ra,40(sp)
    80003416:	f022                	sd	s0,32(sp)
    80003418:	ec26                	sd	s1,24(sp)
    8000341a:	e84a                	sd	s2,16(sp)
    8000341c:	e44e                	sd	s3,8(sp)
    8000341e:	1800                	addi	s0,sp,48
    80003420:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80003422:	05050493          	addi	s1,a0,80
    80003426:	08050913          	addi	s2,a0,128
    8000342a:	a021                	j	80003432 <itrunc+0x20>
    8000342c:	0491                	addi	s1,s1,4
    8000342e:	01248b63          	beq	s1,s2,80003444 <itrunc+0x32>
    if (ip->addrs[i]) {
    80003432:	408c                	lw	a1,0(s1)
    80003434:	dde5                	beqz	a1,8000342c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003436:	0009a503          	lw	a0,0(s3)
    8000343a:	a17ff0ef          	jal	80002e50 <bfree>
      ip->addrs[i] = 0;
    8000343e:	0004a023          	sw	zero,0(s1)
    80003442:	b7ed                	j	8000342c <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80003444:	0809a583          	lw	a1,128(s3)
    80003448:	ed89                	bnez	a1,80003462 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000344a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000344e:	854e                	mv	a0,s3
    80003450:	e21ff0ef          	jal	80003270 <iupdate>
}
    80003454:	70a2                	ld	ra,40(sp)
    80003456:	7402                	ld	s0,32(sp)
    80003458:	64e2                	ld	s1,24(sp)
    8000345a:	6942                	ld	s2,16(sp)
    8000345c:	69a2                	ld	s3,8(sp)
    8000345e:	6145                	addi	sp,sp,48
    80003460:	8082                	ret
    80003462:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003464:	0009a503          	lw	a0,0(s3)
    80003468:	ff0ff0ef          	jal	80002c58 <bread>
    8000346c:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    8000346e:	05850493          	addi	s1,a0,88
    80003472:	45850913          	addi	s2,a0,1112
    80003476:	a021                	j	8000347e <itrunc+0x6c>
    80003478:	0491                	addi	s1,s1,4
    8000347a:	01248963          	beq	s1,s2,8000348c <itrunc+0x7a>
      if (a[j])
    8000347e:	408c                	lw	a1,0(s1)
    80003480:	dde5                	beqz	a1,80003478 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003482:	0009a503          	lw	a0,0(s3)
    80003486:	9cbff0ef          	jal	80002e50 <bfree>
    8000348a:	b7fd                	j	80003478 <itrunc+0x66>
    brelse(bp);
    8000348c:	8552                	mv	a0,s4
    8000348e:	8d3ff0ef          	jal	80002d60 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003492:	0809a583          	lw	a1,128(s3)
    80003496:	0009a503          	lw	a0,0(s3)
    8000349a:	9b7ff0ef          	jal	80002e50 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000349e:	0809a023          	sw	zero,128(s3)
    800034a2:	6a02                	ld	s4,0(sp)
    800034a4:	b75d                	j	8000344a <itrunc+0x38>

00000000800034a6 <iput>:
{
    800034a6:	1101                	addi	sp,sp,-32
    800034a8:	ec06                	sd	ra,24(sp)
    800034aa:	e822                	sd	s0,16(sp)
    800034ac:	e426                	sd	s1,8(sp)
    800034ae:	1000                	addi	s0,sp,32
    800034b0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800034b2:	0001e517          	auipc	a0,0x1e
    800034b6:	a0e50513          	addi	a0,a0,-1522 # 80020ec0 <itable>
    800034ba:	ee8fd0ef          	jal	80000ba2 <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    800034be:	4498                	lw	a4,8(s1)
    800034c0:	4785                	li	a5,1
    800034c2:	02f70063          	beq	a4,a5,800034e2 <iput+0x3c>
  ip->ref--;
    800034c6:	449c                	lw	a5,8(s1)
    800034c8:	37fd                	addiw	a5,a5,-1
    800034ca:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800034cc:	0001e517          	auipc	a0,0x1e
    800034d0:	9f450513          	addi	a0,a0,-1548 # 80020ec0 <itable>
    800034d4:	f5afd0ef          	jal	80000c2e <release>
}
    800034d8:	60e2                	ld	ra,24(sp)
    800034da:	6442                	ld	s0,16(sp)
    800034dc:	64a2                	ld	s1,8(sp)
    800034de:	6105                	addi	sp,sp,32
    800034e0:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    800034e2:	40bc                	lw	a5,64(s1)
    800034e4:	d3ed                	beqz	a5,800034c6 <iput+0x20>
    800034e6:	04a49783          	lh	a5,74(s1)
    800034ea:	fff1                	bnez	a5,800034c6 <iput+0x20>
    800034ec:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800034ee:	01048913          	addi	s2,s1,16
    800034f2:	854a                	mv	a0,s2
    800034f4:	2ff000ef          	jal	80003ff2 <acquiresleep>
    release(&itable.lock);
    800034f8:	0001e517          	auipc	a0,0x1e
    800034fc:	9c850513          	addi	a0,a0,-1592 # 80020ec0 <itable>
    80003500:	f2efd0ef          	jal	80000c2e <release>
    itrunc(ip);
    80003504:	8526                	mv	a0,s1
    80003506:	f0dff0ef          	jal	80003412 <itrunc>
    ip->type = 0;
    8000350a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000350e:	8526                	mv	a0,s1
    80003510:	d61ff0ef          	jal	80003270 <iupdate>
    ip->valid = 0;
    80003514:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003518:	854a                	mv	a0,s2
    8000351a:	31f000ef          	jal	80004038 <releasesleep>
    acquire(&itable.lock);
    8000351e:	0001e517          	auipc	a0,0x1e
    80003522:	9a250513          	addi	a0,a0,-1630 # 80020ec0 <itable>
    80003526:	e7cfd0ef          	jal	80000ba2 <acquire>
    8000352a:	6902                	ld	s2,0(sp)
    8000352c:	bf69                	j	800034c6 <iput+0x20>

000000008000352e <iunlockput>:
{
    8000352e:	1101                	addi	sp,sp,-32
    80003530:	ec06                	sd	ra,24(sp)
    80003532:	e822                	sd	s0,16(sp)
    80003534:	e426                	sd	s1,8(sp)
    80003536:	1000                	addi	s0,sp,32
    80003538:	84aa                	mv	s1,a0
  iunlock(ip);
    8000353a:	e99ff0ef          	jal	800033d2 <iunlock>
  iput(ip);
    8000353e:	8526                	mv	a0,s1
    80003540:	f67ff0ef          	jal	800034a6 <iput>
}
    80003544:	60e2                	ld	ra,24(sp)
    80003546:	6442                	ld	s0,16(sp)
    80003548:	64a2                	ld	s1,8(sp)
    8000354a:	6105                	addi	sp,sp,32
    8000354c:	8082                	ret

000000008000354e <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000354e:	0001e717          	auipc	a4,0x1e
    80003552:	95e72703          	lw	a4,-1698(a4) # 80020eac <sb+0xc>
    80003556:	4785                	li	a5,1
    80003558:	0ae7ff63          	bgeu	a5,a4,80003616 <ireclaim+0xc8>
{
    8000355c:	7139                	addi	sp,sp,-64
    8000355e:	fc06                	sd	ra,56(sp)
    80003560:	f822                	sd	s0,48(sp)
    80003562:	f426                	sd	s1,40(sp)
    80003564:	f04a                	sd	s2,32(sp)
    80003566:	ec4e                	sd	s3,24(sp)
    80003568:	e852                	sd	s4,16(sp)
    8000356a:	e456                	sd	s5,8(sp)
    8000356c:	e05a                	sd	s6,0(sp)
    8000356e:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003570:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003572:	00050a1b          	sext.w	s4,a0
    80003576:	0001ea97          	auipc	s5,0x1e
    8000357a:	92aa8a93          	addi	s5,s5,-1750 # 80020ea0 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    8000357e:	00004b17          	auipc	s6,0x4
    80003582:	eeab0b13          	addi	s6,s6,-278 # 80007468 <etext+0x468>
    80003586:	a099                	j	800035cc <ireclaim+0x7e>
    80003588:	85ce                	mv	a1,s3
    8000358a:	855a                	mv	a0,s6
    8000358c:	f63fc0ef          	jal	800004ee <printk>
      ip = iget(dev, inum);
    80003590:	85ce                	mv	a1,s3
    80003592:	8552                	mv	a0,s4
    80003594:	b1dff0ef          	jal	800030b0 <iget>
    80003598:	89aa                	mv	s3,a0
    brelse(bp);
    8000359a:	854a                	mv	a0,s2
    8000359c:	fc4ff0ef          	jal	80002d60 <brelse>
    if (ip) {
    800035a0:	00098f63          	beqz	s3,800035be <ireclaim+0x70>
      begin_op();
    800035a4:	76a000ef          	jal	80003d0e <begin_op>
      ilock(ip);
    800035a8:	854e                	mv	a0,s3
    800035aa:	d7bff0ef          	jal	80003324 <ilock>
      iunlock(ip);
    800035ae:	854e                	mv	a0,s3
    800035b0:	e23ff0ef          	jal	800033d2 <iunlock>
      iput(ip);
    800035b4:	854e                	mv	a0,s3
    800035b6:	ef1ff0ef          	jal	800034a6 <iput>
      end_op();
    800035ba:	7be000ef          	jal	80003d78 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800035be:	0485                	addi	s1,s1,1
    800035c0:	00caa703          	lw	a4,12(s5)
    800035c4:	0004879b          	sext.w	a5,s1
    800035c8:	02e7fd63          	bgeu	a5,a4,80003602 <ireclaim+0xb4>
    800035cc:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800035d0:	0044d593          	srli	a1,s1,0x4
    800035d4:	018aa783          	lw	a5,24(s5)
    800035d8:	9dbd                	addw	a1,a1,a5
    800035da:	8552                	mv	a0,s4
    800035dc:	e7cff0ef          	jal	80002c58 <bread>
    800035e0:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800035e2:	05850793          	addi	a5,a0,88
    800035e6:	00f9f713          	andi	a4,s3,15
    800035ea:	071a                	slli	a4,a4,0x6
    800035ec:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    800035ee:	00079703          	lh	a4,0(a5)
    800035f2:	c701                	beqz	a4,800035fa <ireclaim+0xac>
    800035f4:	00679783          	lh	a5,6(a5)
    800035f8:	dbc1                	beqz	a5,80003588 <ireclaim+0x3a>
    brelse(bp);
    800035fa:	854a                	mv	a0,s2
    800035fc:	f64ff0ef          	jal	80002d60 <brelse>
    if (ip) {
    80003600:	bf7d                	j	800035be <ireclaim+0x70>
}
    80003602:	70e2                	ld	ra,56(sp)
    80003604:	7442                	ld	s0,48(sp)
    80003606:	74a2                	ld	s1,40(sp)
    80003608:	7902                	ld	s2,32(sp)
    8000360a:	69e2                	ld	s3,24(sp)
    8000360c:	6a42                	ld	s4,16(sp)
    8000360e:	6aa2                	ld	s5,8(sp)
    80003610:	6b02                	ld	s6,0(sp)
    80003612:	6121                	addi	sp,sp,64
    80003614:	8082                	ret
    80003616:	8082                	ret

0000000080003618 <fsinit>:
{
    80003618:	7179                	addi	sp,sp,-48
    8000361a:	f406                	sd	ra,40(sp)
    8000361c:	f022                	sd	s0,32(sp)
    8000361e:	ec26                	sd	s1,24(sp)
    80003620:	e84a                	sd	s2,16(sp)
    80003622:	e44e                	sd	s3,8(sp)
    80003624:	1800                	addi	s0,sp,48
    80003626:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    80003628:	4585                	li	a1,1
    8000362a:	e2eff0ef          	jal	80002c58 <bread>
    8000362e:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003630:	0001e997          	auipc	s3,0x1e
    80003634:	87098993          	addi	s3,s3,-1936 # 80020ea0 <sb>
    80003638:	02000613          	li	a2,32
    8000363c:	05850593          	addi	a1,a0,88
    80003640:	854e                	mv	a0,s3
    80003642:	e80fd0ef          	jal	80000cc2 <memmove>
  brelse(bp);
    80003646:	854a                	mv	a0,s2
    80003648:	f18ff0ef          	jal	80002d60 <brelse>
  if (sb.magic != FSMAGIC)
    8000364c:	0009a703          	lw	a4,0(s3)
    80003650:	102037b7          	lui	a5,0x10203
    80003654:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003658:	02f71363          	bne	a4,a5,8000367e <fsinit+0x66>
  initlog(dev, &sb);
    8000365c:	0001e597          	auipc	a1,0x1e
    80003660:	84458593          	addi	a1,a1,-1980 # 80020ea0 <sb>
    80003664:	8526                	mv	a0,s1
    80003666:	62a000ef          	jal	80003c90 <initlog>
  ireclaim(dev);
    8000366a:	8526                	mv	a0,s1
    8000366c:	ee3ff0ef          	jal	8000354e <ireclaim>
}
    80003670:	70a2                	ld	ra,40(sp)
    80003672:	7402                	ld	s0,32(sp)
    80003674:	64e2                	ld	s1,24(sp)
    80003676:	6942                	ld	s2,16(sp)
    80003678:	69a2                	ld	s3,8(sp)
    8000367a:	6145                	addi	sp,sp,48
    8000367c:	8082                	ret
    panic("invalid file system");
    8000367e:	00004517          	auipc	a0,0x4
    80003682:	e0a50513          	addi	a0,a0,-502 # 80007488 <etext+0x488>
    80003686:	94efd0ef          	jal	800007d4 <panic>

000000008000368a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000368a:	1141                	addi	sp,sp,-16
    8000368c:	e422                	sd	s0,8(sp)
    8000368e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003690:	411c                	lw	a5,0(a0)
    80003692:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003694:	415c                	lw	a5,4(a0)
    80003696:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003698:	04451783          	lh	a5,68(a0)
    8000369c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800036a0:	04a51783          	lh	a5,74(a0)
    800036a4:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800036a8:	04c56783          	lwu	a5,76(a0)
    800036ac:	e99c                	sd	a5,16(a1)
}
    800036ae:	6422                	ld	s0,8(sp)
    800036b0:	0141                	addi	sp,sp,16
    800036b2:	8082                	ret

00000000800036b4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    800036b4:	457c                	lw	a5,76(a0)
    800036b6:	0ed7eb63          	bltu	a5,a3,800037ac <readi+0xf8>
{
    800036ba:	7159                	addi	sp,sp,-112
    800036bc:	f486                	sd	ra,104(sp)
    800036be:	f0a2                	sd	s0,96(sp)
    800036c0:	eca6                	sd	s1,88(sp)
    800036c2:	e0d2                	sd	s4,64(sp)
    800036c4:	fc56                	sd	s5,56(sp)
    800036c6:	f85a                	sd	s6,48(sp)
    800036c8:	f45e                	sd	s7,40(sp)
    800036ca:	1880                	addi	s0,sp,112
    800036cc:	8b2a                	mv	s6,a0
    800036ce:	8bae                	mv	s7,a1
    800036d0:	8a32                	mv	s4,a2
    800036d2:	84b6                	mv	s1,a3
    800036d4:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    800036d6:	9f35                	addw	a4,a4,a3
    return 0;
    800036d8:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    800036da:	0cd76063          	bltu	a4,a3,8000379a <readi+0xe6>
    800036de:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    800036e0:	00e7f463          	bgeu	a5,a4,800036e8 <readi+0x34>
    n = ip->size - off;
    800036e4:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800036e8:	080a8f63          	beqz	s5,80003786 <readi+0xd2>
    800036ec:	e8ca                	sd	s2,80(sp)
    800036ee:	f062                	sd	s8,32(sp)
    800036f0:	ec66                	sd	s9,24(sp)
    800036f2:	e86a                	sd	s10,16(sp)
    800036f4:	e46e                	sd	s11,8(sp)
    800036f6:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    800036f8:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800036fc:	5c7d                	li	s8,-1
    800036fe:	a80d                	j	80003730 <readi+0x7c>
    80003700:	020d1d93          	slli	s11,s10,0x20
    80003704:	020ddd93          	srli	s11,s11,0x20
    80003708:	05890613          	addi	a2,s2,88
    8000370c:	86ee                	mv	a3,s11
    8000370e:	963a                	add	a2,a2,a4
    80003710:	85d2                	mv	a1,s4
    80003712:	855e                	mv	a0,s7
    80003714:	b9ffe0ef          	jal	800022b2 <either_copyout>
    80003718:	05850763          	beq	a0,s8,80003766 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000371c:	854a                	mv	a0,s2
    8000371e:	e42ff0ef          	jal	80002d60 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003722:	013d09bb          	addw	s3,s10,s3
    80003726:	009d04bb          	addw	s1,s10,s1
    8000372a:	9a6e                	add	s4,s4,s11
    8000372c:	0559f763          	bgeu	s3,s5,8000377a <readi+0xc6>
    uint addr = bmap(ip, off / BSIZE);
    80003730:	00a4d59b          	srliw	a1,s1,0xa
    80003734:	855a                	mv	a0,s6
    80003736:	8a7ff0ef          	jal	80002fdc <bmap>
    8000373a:	0005059b          	sext.w	a1,a0
    if (addr == 0)
    8000373e:	c5b1                	beqz	a1,8000378a <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003740:	000b2503          	lw	a0,0(s6)
    80003744:	d14ff0ef          	jal	80002c58 <bread>
    80003748:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    8000374a:	3ff4f713          	andi	a4,s1,1023
    8000374e:	40ec87bb          	subw	a5,s9,a4
    80003752:	413a86bb          	subw	a3,s5,s3
    80003756:	8d3e                	mv	s10,a5
    80003758:	2781                	sext.w	a5,a5
    8000375a:	0006861b          	sext.w	a2,a3
    8000375e:	faf671e3          	bgeu	a2,a5,80003700 <readi+0x4c>
    80003762:	8d36                	mv	s10,a3
    80003764:	bf71                	j	80003700 <readi+0x4c>
      brelse(bp);
    80003766:	854a                	mv	a0,s2
    80003768:	df8ff0ef          	jal	80002d60 <brelse>
      tot = -1;
    8000376c:	59fd                	li	s3,-1
      break;
    8000376e:	6946                	ld	s2,80(sp)
    80003770:	7c02                	ld	s8,32(sp)
    80003772:	6ce2                	ld	s9,24(sp)
    80003774:	6d42                	ld	s10,16(sp)
    80003776:	6da2                	ld	s11,8(sp)
    80003778:	a831                	j	80003794 <readi+0xe0>
    8000377a:	6946                	ld	s2,80(sp)
    8000377c:	7c02                	ld	s8,32(sp)
    8000377e:	6ce2                	ld	s9,24(sp)
    80003780:	6d42                	ld	s10,16(sp)
    80003782:	6da2                	ld	s11,8(sp)
    80003784:	a801                	j	80003794 <readi+0xe0>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003786:	89d6                	mv	s3,s5
    80003788:	a031                	j	80003794 <readi+0xe0>
    8000378a:	6946                	ld	s2,80(sp)
    8000378c:	7c02                	ld	s8,32(sp)
    8000378e:	6ce2                	ld	s9,24(sp)
    80003790:	6d42                	ld	s10,16(sp)
    80003792:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003794:	0009851b          	sext.w	a0,s3
    80003798:	69a6                	ld	s3,72(sp)
}
    8000379a:	70a6                	ld	ra,104(sp)
    8000379c:	7406                	ld	s0,96(sp)
    8000379e:	64e6                	ld	s1,88(sp)
    800037a0:	6a06                	ld	s4,64(sp)
    800037a2:	7ae2                	ld	s5,56(sp)
    800037a4:	7b42                	ld	s6,48(sp)
    800037a6:	7ba2                	ld	s7,40(sp)
    800037a8:	6165                	addi	sp,sp,112
    800037aa:	8082                	ret
    return 0;
    800037ac:	4501                	li	a0,0
}
    800037ae:	8082                	ret

00000000800037b0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    800037b0:	457c                	lw	a5,76(a0)
    800037b2:	10d7e063          	bltu	a5,a3,800038b2 <writei+0x102>
{
    800037b6:	7159                	addi	sp,sp,-112
    800037b8:	f486                	sd	ra,104(sp)
    800037ba:	f0a2                	sd	s0,96(sp)
    800037bc:	e8ca                	sd	s2,80(sp)
    800037be:	e0d2                	sd	s4,64(sp)
    800037c0:	fc56                	sd	s5,56(sp)
    800037c2:	f85a                	sd	s6,48(sp)
    800037c4:	f45e                	sd	s7,40(sp)
    800037c6:	1880                	addi	s0,sp,112
    800037c8:	8aaa                	mv	s5,a0
    800037ca:	8bae                	mv	s7,a1
    800037cc:	8a32                	mv	s4,a2
    800037ce:	8936                	mv	s2,a3
    800037d0:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    800037d2:	00e687bb          	addw	a5,a3,a4
    800037d6:	0ed7e063          	bltu	a5,a3,800038b6 <writei+0x106>
    return -1;
  if (off + n > MAXFILE * BSIZE)
    800037da:	00043737          	lui	a4,0x43
    800037de:	0cf76e63          	bltu	a4,a5,800038ba <writei+0x10a>
    800037e2:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800037e4:	0a0b0f63          	beqz	s6,800038a2 <writei+0xf2>
    800037e8:	eca6                	sd	s1,88(sp)
    800037ea:	f062                	sd	s8,32(sp)
    800037ec:	ec66                	sd	s9,24(sp)
    800037ee:	e86a                	sd	s10,16(sp)
    800037f0:	e46e                	sd	s11,8(sp)
    800037f2:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    800037f4:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800037f8:	5c7d                	li	s8,-1
    800037fa:	a825                	j	80003832 <writei+0x82>
    800037fc:	020d1d93          	slli	s11,s10,0x20
    80003800:	020ddd93          	srli	s11,s11,0x20
    80003804:	05848513          	addi	a0,s1,88
    80003808:	86ee                	mv	a3,s11
    8000380a:	8652                	mv	a2,s4
    8000380c:	85de                	mv	a1,s7
    8000380e:	953a                	add	a0,a0,a4
    80003810:	aedfe0ef          	jal	800022fc <either_copyin>
    80003814:	05850a63          	beq	a0,s8,80003868 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003818:	8526                	mv	a0,s1
    8000381a:	67e000ef          	jal	80003e98 <log_write>
    brelse(bp);
    8000381e:	8526                	mv	a0,s1
    80003820:	d40ff0ef          	jal	80002d60 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003824:	013d09bb          	addw	s3,s10,s3
    80003828:	012d093b          	addw	s2,s10,s2
    8000382c:	9a6e                	add	s4,s4,s11
    8000382e:	0569f063          	bgeu	s3,s6,8000386e <writei+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    80003832:	00a9559b          	srliw	a1,s2,0xa
    80003836:	8556                	mv	a0,s5
    80003838:	fa4ff0ef          	jal	80002fdc <bmap>
    8000383c:	0005059b          	sext.w	a1,a0
    if (addr == 0)
    80003840:	c59d                	beqz	a1,8000386e <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003842:	000aa503          	lw	a0,0(s5)
    80003846:	c12ff0ef          	jal	80002c58 <bread>
    8000384a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    8000384c:	3ff97713          	andi	a4,s2,1023
    80003850:	40ec87bb          	subw	a5,s9,a4
    80003854:	413b06bb          	subw	a3,s6,s3
    80003858:	8d3e                	mv	s10,a5
    8000385a:	2781                	sext.w	a5,a5
    8000385c:	0006861b          	sext.w	a2,a3
    80003860:	f8f67ee3          	bgeu	a2,a5,800037fc <writei+0x4c>
    80003864:	8d36                	mv	s10,a3
    80003866:	bf59                	j	800037fc <writei+0x4c>
      brelse(bp);
    80003868:	8526                	mv	a0,s1
    8000386a:	cf6ff0ef          	jal	80002d60 <brelse>
  }

  if (off > ip->size)
    8000386e:	04caa783          	lw	a5,76(s5)
    80003872:	0327fa63          	bgeu	a5,s2,800038a6 <writei+0xf6>
    ip->size = off;
    80003876:	052aa623          	sw	s2,76(s5)
    8000387a:	64e6                	ld	s1,88(sp)
    8000387c:	7c02                	ld	s8,32(sp)
    8000387e:	6ce2                	ld	s9,24(sp)
    80003880:	6d42                	ld	s10,16(sp)
    80003882:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003884:	8556                	mv	a0,s5
    80003886:	9ebff0ef          	jal	80003270 <iupdate>

  return tot;
    8000388a:	0009851b          	sext.w	a0,s3
    8000388e:	69a6                	ld	s3,72(sp)
}
    80003890:	70a6                	ld	ra,104(sp)
    80003892:	7406                	ld	s0,96(sp)
    80003894:	6946                	ld	s2,80(sp)
    80003896:	6a06                	ld	s4,64(sp)
    80003898:	7ae2                	ld	s5,56(sp)
    8000389a:	7b42                	ld	s6,48(sp)
    8000389c:	7ba2                	ld	s7,40(sp)
    8000389e:	6165                	addi	sp,sp,112
    800038a0:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800038a2:	89da                	mv	s3,s6
    800038a4:	b7c5                	j	80003884 <writei+0xd4>
    800038a6:	64e6                	ld	s1,88(sp)
    800038a8:	7c02                	ld	s8,32(sp)
    800038aa:	6ce2                	ld	s9,24(sp)
    800038ac:	6d42                	ld	s10,16(sp)
    800038ae:	6da2                	ld	s11,8(sp)
    800038b0:	bfd1                	j	80003884 <writei+0xd4>
    return -1;
    800038b2:	557d                	li	a0,-1
}
    800038b4:	8082                	ret
    return -1;
    800038b6:	557d                	li	a0,-1
    800038b8:	bfe1                	j	80003890 <writei+0xe0>
    return -1;
    800038ba:	557d                	li	a0,-1
    800038bc:	bfd1                	j	80003890 <writei+0xe0>

00000000800038be <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800038be:	1141                	addi	sp,sp,-16
    800038c0:	e406                	sd	ra,8(sp)
    800038c2:	e022                	sd	s0,0(sp)
    800038c4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800038c6:	4639                	li	a2,14
    800038c8:	c6afd0ef          	jal	80000d32 <strncmp>
}
    800038cc:	60a2                	ld	ra,8(sp)
    800038ce:	6402                	ld	s0,0(sp)
    800038d0:	0141                	addi	sp,sp,16
    800038d2:	8082                	ret

00000000800038d4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800038d4:	7139                	addi	sp,sp,-64
    800038d6:	fc06                	sd	ra,56(sp)
    800038d8:	f822                	sd	s0,48(sp)
    800038da:	f426                	sd	s1,40(sp)
    800038dc:	f04a                	sd	s2,32(sp)
    800038de:	ec4e                	sd	s3,24(sp)
    800038e0:	e852                	sd	s4,16(sp)
    800038e2:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    800038e4:	04451703          	lh	a4,68(a0)
    800038e8:	4785                	li	a5,1
    800038ea:	00f71a63          	bne	a4,a5,800038fe <dirlookup+0x2a>
    800038ee:	892a                	mv	s2,a0
    800038f0:	89ae                	mv	s3,a1
    800038f2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    800038f4:	457c                	lw	a5,76(a0)
    800038f6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800038f8:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800038fa:	e39d                	bnez	a5,80003920 <dirlookup+0x4c>
    800038fc:	a095                	j	80003960 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    800038fe:	00004517          	auipc	a0,0x4
    80003902:	ba250513          	addi	a0,a0,-1118 # 800074a0 <etext+0x4a0>
    80003906:	ecffc0ef          	jal	800007d4 <panic>
      panic("dirlookup read");
    8000390a:	00004517          	auipc	a0,0x4
    8000390e:	bae50513          	addi	a0,a0,-1106 # 800074b8 <etext+0x4b8>
    80003912:	ec3fc0ef          	jal	800007d4 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003916:	24c1                	addiw	s1,s1,16
    80003918:	04c92783          	lw	a5,76(s2)
    8000391c:	04f4f163          	bgeu	s1,a5,8000395e <dirlookup+0x8a>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003920:	4741                	li	a4,16
    80003922:	86a6                	mv	a3,s1
    80003924:	fc040613          	addi	a2,s0,-64
    80003928:	4581                	li	a1,0
    8000392a:	854a                	mv	a0,s2
    8000392c:	d89ff0ef          	jal	800036b4 <readi>
    80003930:	47c1                	li	a5,16
    80003932:	fcf51ce3          	bne	a0,a5,8000390a <dirlookup+0x36>
    if (de.inum == 0)
    80003936:	fc045783          	lhu	a5,-64(s0)
    8000393a:	dff1                	beqz	a5,80003916 <dirlookup+0x42>
    if (namecmp(name, de.name) == 0) {
    8000393c:	fc240593          	addi	a1,s0,-62
    80003940:	854e                	mv	a0,s3
    80003942:	f7dff0ef          	jal	800038be <namecmp>
    80003946:	f961                	bnez	a0,80003916 <dirlookup+0x42>
      if (poff)
    80003948:	000a0463          	beqz	s4,80003950 <dirlookup+0x7c>
        *poff = off;
    8000394c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003950:	fc045583          	lhu	a1,-64(s0)
    80003954:	00092503          	lw	a0,0(s2)
    80003958:	f58ff0ef          	jal	800030b0 <iget>
    8000395c:	a011                	j	80003960 <dirlookup+0x8c>
  return 0;
    8000395e:	4501                	li	a0,0
}
    80003960:	70e2                	ld	ra,56(sp)
    80003962:	7442                	ld	s0,48(sp)
    80003964:	74a2                	ld	s1,40(sp)
    80003966:	7902                	ld	s2,32(sp)
    80003968:	69e2                	ld	s3,24(sp)
    8000396a:	6a42                	ld	s4,16(sp)
    8000396c:	6121                	addi	sp,sp,64
    8000396e:	8082                	ret

0000000080003970 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    80003970:	711d                	addi	sp,sp,-96
    80003972:	ec86                	sd	ra,88(sp)
    80003974:	e8a2                	sd	s0,80(sp)
    80003976:	e4a6                	sd	s1,72(sp)
    80003978:	e0ca                	sd	s2,64(sp)
    8000397a:	fc4e                	sd	s3,56(sp)
    8000397c:	f852                	sd	s4,48(sp)
    8000397e:	f456                	sd	s5,40(sp)
    80003980:	f05a                	sd	s6,32(sp)
    80003982:	ec5e                	sd	s7,24(sp)
    80003984:	e862                	sd	s8,16(sp)
    80003986:	e466                	sd	s9,8(sp)
    80003988:	1080                	addi	s0,sp,96
    8000398a:	84aa                	mv	s1,a0
    8000398c:	8b2e                	mv	s6,a1
    8000398e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80003990:	00054703          	lbu	a4,0(a0)
    80003994:	02f00793          	li	a5,47
    80003998:	00f70e63          	beq	a4,a5,800039b4 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000399c:	ef7fd0ef          	jal	80001892 <myproc>
    800039a0:	15053503          	ld	a0,336(a0)
    800039a4:	94bff0ef          	jal	800032ee <idup>
    800039a8:	8a2a                	mv	s4,a0
  while (*path == '/')
    800039aa:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    800039ae:	4c35                	li	s8,13

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    800039b0:	4b85                	li	s7,1
    800039b2:	a871                	j	80003a4e <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    800039b4:	4585                	li	a1,1
    800039b6:	4505                	li	a0,1
    800039b8:	ef8ff0ef          	jal	800030b0 <iget>
    800039bc:	8a2a                	mv	s4,a0
    800039be:	b7f5                	j	800039aa <namex+0x3a>
      iunlockput(ip);
    800039c0:	8552                	mv	a0,s4
    800039c2:	b6dff0ef          	jal	8000352e <iunlockput>
      return 0;
    800039c6:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    800039c8:	8552                	mv	a0,s4
    800039ca:	60e6                	ld	ra,88(sp)
    800039cc:	6446                	ld	s0,80(sp)
    800039ce:	64a6                	ld	s1,72(sp)
    800039d0:	6906                	ld	s2,64(sp)
    800039d2:	79e2                	ld	s3,56(sp)
    800039d4:	7a42                	ld	s4,48(sp)
    800039d6:	7aa2                	ld	s5,40(sp)
    800039d8:	7b02                	ld	s6,32(sp)
    800039da:	6be2                	ld	s7,24(sp)
    800039dc:	6c42                	ld	s8,16(sp)
    800039de:	6ca2                	ld	s9,8(sp)
    800039e0:	6125                	addi	sp,sp,96
    800039e2:	8082                	ret
      iunlock(ip);
    800039e4:	8552                	mv	a0,s4
    800039e6:	9edff0ef          	jal	800033d2 <iunlock>
      return ip;
    800039ea:	bff9                	j	800039c8 <namex+0x58>
      iunlockput(ip);
    800039ec:	8552                	mv	a0,s4
    800039ee:	b41ff0ef          	jal	8000352e <iunlockput>
      return 0;
    800039f2:	8a4e                	mv	s4,s3
    800039f4:	bfd1                	j	800039c8 <namex+0x58>
  len = path - s;
    800039f6:	40998633          	sub	a2,s3,s1
    800039fa:	00060c9b          	sext.w	s9,a2
  if (len >= DIRSIZ)
    800039fe:	099c5063          	bge	s8,s9,80003a7e <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003a02:	4639                	li	a2,14
    80003a04:	85a6                	mv	a1,s1
    80003a06:	8556                	mv	a0,s5
    80003a08:	abafd0ef          	jal	80000cc2 <memmove>
    80003a0c:	84ce                	mv	s1,s3
  while (*path == '/')
    80003a0e:	0004c783          	lbu	a5,0(s1)
    80003a12:	01279763          	bne	a5,s2,80003a20 <namex+0xb0>
    path++;
    80003a16:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003a18:	0004c783          	lbu	a5,0(s1)
    80003a1c:	ff278de3          	beq	a5,s2,80003a16 <namex+0xa6>
    ilock(ip);
    80003a20:	8552                	mv	a0,s4
    80003a22:	903ff0ef          	jal	80003324 <ilock>
    if (ip->type != T_DIR) {
    80003a26:	044a1783          	lh	a5,68(s4)
    80003a2a:	f9779be3          	bne	a5,s7,800039c0 <namex+0x50>
    if (nameiparent && *path == '\0') {
    80003a2e:	000b0563          	beqz	s6,80003a38 <namex+0xc8>
    80003a32:	0004c783          	lbu	a5,0(s1)
    80003a36:	d7dd                	beqz	a5,800039e4 <namex+0x74>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80003a38:	4601                	li	a2,0
    80003a3a:	85d6                	mv	a1,s5
    80003a3c:	8552                	mv	a0,s4
    80003a3e:	e97ff0ef          	jal	800038d4 <dirlookup>
    80003a42:	89aa                	mv	s3,a0
    80003a44:	d545                	beqz	a0,800039ec <namex+0x7c>
    iunlockput(ip);
    80003a46:	8552                	mv	a0,s4
    80003a48:	ae7ff0ef          	jal	8000352e <iunlockput>
    ip = next;
    80003a4c:	8a4e                	mv	s4,s3
  while (*path == '/')
    80003a4e:	0004c783          	lbu	a5,0(s1)
    80003a52:	01279763          	bne	a5,s2,80003a60 <namex+0xf0>
    path++;
    80003a56:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003a58:	0004c783          	lbu	a5,0(s1)
    80003a5c:	ff278de3          	beq	a5,s2,80003a56 <namex+0xe6>
  if (*path == 0)
    80003a60:	cb8d                	beqz	a5,80003a92 <namex+0x122>
  while (*path != '/' && *path != 0)
    80003a62:	0004c783          	lbu	a5,0(s1)
    80003a66:	89a6                	mv	s3,s1
  len = path - s;
    80003a68:	4c81                	li	s9,0
    80003a6a:	4601                	li	a2,0
  while (*path != '/' && *path != 0)
    80003a6c:	01278963          	beq	a5,s2,80003a7e <namex+0x10e>
    80003a70:	d3d9                	beqz	a5,800039f6 <namex+0x86>
    path++;
    80003a72:	0985                	addi	s3,s3,1
  while (*path != '/' && *path != 0)
    80003a74:	0009c783          	lbu	a5,0(s3)
    80003a78:	ff279ce3          	bne	a5,s2,80003a70 <namex+0x100>
    80003a7c:	bfad                	j	800039f6 <namex+0x86>
    memmove(name, s, len);
    80003a7e:	2601                	sext.w	a2,a2
    80003a80:	85a6                	mv	a1,s1
    80003a82:	8556                	mv	a0,s5
    80003a84:	a3efd0ef          	jal	80000cc2 <memmove>
    name[len] = 0;
    80003a88:	9cd6                	add	s9,s9,s5
    80003a8a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003a8e:	84ce                	mv	s1,s3
    80003a90:	bfbd                	j	80003a0e <namex+0x9e>
  if (nameiparent) {
    80003a92:	f20b0be3          	beqz	s6,800039c8 <namex+0x58>
    iput(ip);
    80003a96:	8552                	mv	a0,s4
    80003a98:	a0fff0ef          	jal	800034a6 <iput>
    return 0;
    80003a9c:	4a01                	li	s4,0
    80003a9e:	b72d                	j	800039c8 <namex+0x58>

0000000080003aa0 <dirlink>:
{
    80003aa0:	7139                	addi	sp,sp,-64
    80003aa2:	fc06                	sd	ra,56(sp)
    80003aa4:	f822                	sd	s0,48(sp)
    80003aa6:	f04a                	sd	s2,32(sp)
    80003aa8:	ec4e                	sd	s3,24(sp)
    80003aaa:	e852                	sd	s4,16(sp)
    80003aac:	0080                	addi	s0,sp,64
    80003aae:	892a                	mv	s2,a0
    80003ab0:	8a2e                	mv	s4,a1
    80003ab2:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003ab4:	4601                	li	a2,0
    80003ab6:	e1fff0ef          	jal	800038d4 <dirlookup>
    80003aba:	e535                	bnez	a0,80003b26 <dirlink+0x86>
    80003abc:	f426                	sd	s1,40(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003abe:	04c92483          	lw	s1,76(s2)
    80003ac2:	c48d                	beqz	s1,80003aec <dirlink+0x4c>
    80003ac4:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ac6:	4741                	li	a4,16
    80003ac8:	86a6                	mv	a3,s1
    80003aca:	fc040613          	addi	a2,s0,-64
    80003ace:	4581                	li	a1,0
    80003ad0:	854a                	mv	a0,s2
    80003ad2:	be3ff0ef          	jal	800036b4 <readi>
    80003ad6:	47c1                	li	a5,16
    80003ad8:	04f51b63          	bne	a0,a5,80003b2e <dirlink+0x8e>
    if (de.inum == 0)
    80003adc:	fc045783          	lhu	a5,-64(s0)
    80003ae0:	c791                	beqz	a5,80003aec <dirlink+0x4c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003ae2:	24c1                	addiw	s1,s1,16
    80003ae4:	04c92783          	lw	a5,76(s2)
    80003ae8:	fcf4efe3          	bltu	s1,a5,80003ac6 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003aec:	4639                	li	a2,14
    80003aee:	85d2                	mv	a1,s4
    80003af0:	fc240513          	addi	a0,s0,-62
    80003af4:	a74fd0ef          	jal	80000d68 <strncpy>
  de.inum = inum;
    80003af8:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003afc:	4741                	li	a4,16
    80003afe:	86a6                	mv	a3,s1
    80003b00:	fc040613          	addi	a2,s0,-64
    80003b04:	4581                	li	a1,0
    80003b06:	854a                	mv	a0,s2
    80003b08:	ca9ff0ef          	jal	800037b0 <writei>
    80003b0c:	1541                	addi	a0,a0,-16
    80003b0e:	00a03533          	snez	a0,a0
    80003b12:	40a00533          	neg	a0,a0
    80003b16:	74a2                	ld	s1,40(sp)
}
    80003b18:	70e2                	ld	ra,56(sp)
    80003b1a:	7442                	ld	s0,48(sp)
    80003b1c:	7902                	ld	s2,32(sp)
    80003b1e:	69e2                	ld	s3,24(sp)
    80003b20:	6a42                	ld	s4,16(sp)
    80003b22:	6121                	addi	sp,sp,64
    80003b24:	8082                	ret
    iput(ip);
    80003b26:	981ff0ef          	jal	800034a6 <iput>
    return -1;
    80003b2a:	557d                	li	a0,-1
    80003b2c:	b7f5                	j	80003b18 <dirlink+0x78>
      panic("dirlink read");
    80003b2e:	00004517          	auipc	a0,0x4
    80003b32:	99a50513          	addi	a0,a0,-1638 # 800074c8 <etext+0x4c8>
    80003b36:	c9ffc0ef          	jal	800007d4 <panic>

0000000080003b3a <namei>:

struct inode *
namei(char *path)
{
    80003b3a:	1101                	addi	sp,sp,-32
    80003b3c:	ec06                	sd	ra,24(sp)
    80003b3e:	e822                	sd	s0,16(sp)
    80003b40:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003b42:	fe040613          	addi	a2,s0,-32
    80003b46:	4581                	li	a1,0
    80003b48:	e29ff0ef          	jal	80003970 <namex>
}
    80003b4c:	60e2                	ld	ra,24(sp)
    80003b4e:	6442                	ld	s0,16(sp)
    80003b50:	6105                	addi	sp,sp,32
    80003b52:	8082                	ret

0000000080003b54 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80003b54:	1141                	addi	sp,sp,-16
    80003b56:	e406                	sd	ra,8(sp)
    80003b58:	e022                	sd	s0,0(sp)
    80003b5a:	0800                	addi	s0,sp,16
    80003b5c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003b5e:	4585                	li	a1,1
    80003b60:	e11ff0ef          	jal	80003970 <namex>
}
    80003b64:	60a2                	ld	ra,8(sp)
    80003b66:	6402                	ld	s0,0(sp)
    80003b68:	0141                	addi	sp,sp,16
    80003b6a:	8082                	ret

0000000080003b6c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003b6c:	1101                	addi	sp,sp,-32
    80003b6e:	ec06                	sd	ra,24(sp)
    80003b70:	e822                	sd	s0,16(sp)
    80003b72:	e426                	sd	s1,8(sp)
    80003b74:	e04a                	sd	s2,0(sp)
    80003b76:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003b78:	0001f917          	auipc	s2,0x1f
    80003b7c:	df090913          	addi	s2,s2,-528 # 80022968 <log>
    80003b80:	01892583          	lw	a1,24(s2)
    80003b84:	02492503          	lw	a0,36(s2)
    80003b88:	8d0ff0ef          	jal	80002c58 <bread>
    80003b8c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003b8e:	02c92603          	lw	a2,44(s2)
    80003b92:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003b94:	00c05f63          	blez	a2,80003bb2 <write_head+0x46>
    80003b98:	0001f717          	auipc	a4,0x1f
    80003b9c:	e0070713          	addi	a4,a4,-512 # 80022998 <log+0x30>
    80003ba0:	87aa                	mv	a5,a0
    80003ba2:	060a                	slli	a2,a2,0x2
    80003ba4:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003ba6:	4314                	lw	a3,0(a4)
    80003ba8:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003baa:	0711                	addi	a4,a4,4
    80003bac:	0791                	addi	a5,a5,4
    80003bae:	fec79ce3          	bne	a5,a2,80003ba6 <write_head+0x3a>
  }
  bwrite(buf);
    80003bb2:	8526                	mv	a0,s1
    80003bb4:	97aff0ef          	jal	80002d2e <bwrite>
  brelse(buf);
    80003bb8:	8526                	mv	a0,s1
    80003bba:	9a6ff0ef          	jal	80002d60 <brelse>
}
    80003bbe:	60e2                	ld	ra,24(sp)
    80003bc0:	6442                	ld	s0,16(sp)
    80003bc2:	64a2                	ld	s1,8(sp)
    80003bc4:	6902                	ld	s2,0(sp)
    80003bc6:	6105                	addi	sp,sp,32
    80003bc8:	8082                	ret

0000000080003bca <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bca:	0001f797          	auipc	a5,0x1f
    80003bce:	dca7a783          	lw	a5,-566(a5) # 80022994 <log+0x2c>
    80003bd2:	0af05e63          	blez	a5,80003c8e <install_trans+0xc4>
{
    80003bd6:	715d                	addi	sp,sp,-80
    80003bd8:	e486                	sd	ra,72(sp)
    80003bda:	e0a2                	sd	s0,64(sp)
    80003bdc:	fc26                	sd	s1,56(sp)
    80003bde:	f84a                	sd	s2,48(sp)
    80003be0:	f44e                	sd	s3,40(sp)
    80003be2:	f052                	sd	s4,32(sp)
    80003be4:	ec56                	sd	s5,24(sp)
    80003be6:	e85a                	sd	s6,16(sp)
    80003be8:	e45e                	sd	s7,8(sp)
    80003bea:	0880                	addi	s0,sp,80
    80003bec:	8b2a                	mv	s6,a0
    80003bee:	0001fa97          	auipc	s5,0x1f
    80003bf2:	daaa8a93          	addi	s5,s5,-598 # 80022998 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bf6:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003bf8:	00004b97          	auipc	s7,0x4
    80003bfc:	8e0b8b93          	addi	s7,s7,-1824 # 800074d8 <etext+0x4d8>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003c00:	0001fa17          	auipc	s4,0x1f
    80003c04:	d68a0a13          	addi	s4,s4,-664 # 80022968 <log>
    80003c08:	a025                	j	80003c30 <install_trans+0x66>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003c0a:	000aa603          	lw	a2,0(s5)
    80003c0e:	85ce                	mv	a1,s3
    80003c10:	855e                	mv	a0,s7
    80003c12:	8ddfc0ef          	jal	800004ee <printk>
    80003c16:	a839                	j	80003c34 <install_trans+0x6a>
    brelse(lbuf);
    80003c18:	854a                	mv	a0,s2
    80003c1a:	946ff0ef          	jal	80002d60 <brelse>
    brelse(dbuf);
    80003c1e:	8526                	mv	a0,s1
    80003c20:	940ff0ef          	jal	80002d60 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c24:	2985                	addiw	s3,s3,1
    80003c26:	0a91                	addi	s5,s5,4
    80003c28:	02ca2783          	lw	a5,44(s4)
    80003c2c:	04f9d663          	bge	s3,a5,80003c78 <install_trans+0xae>
    if (recovering) {
    80003c30:	fc0b1de3          	bnez	s6,80003c0a <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003c34:	018a2583          	lw	a1,24(s4)
    80003c38:	013585bb          	addw	a1,a1,s3
    80003c3c:	2585                	addiw	a1,a1,1
    80003c3e:	024a2503          	lw	a0,36(s4)
    80003c42:	816ff0ef          	jal	80002c58 <bread>
    80003c46:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80003c48:	000aa583          	lw	a1,0(s5)
    80003c4c:	024a2503          	lw	a0,36(s4)
    80003c50:	808ff0ef          	jal	80002c58 <bread>
    80003c54:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003c56:	40000613          	li	a2,1024
    80003c5a:	05890593          	addi	a1,s2,88
    80003c5e:	05850513          	addi	a0,a0,88
    80003c62:	860fd0ef          	jal	80000cc2 <memmove>
    bwrite(dbuf);                           // write dst to disk
    80003c66:	8526                	mv	a0,s1
    80003c68:	8c6ff0ef          	jal	80002d2e <bwrite>
    if (recovering == 0)
    80003c6c:	fa0b16e3          	bnez	s6,80003c18 <install_trans+0x4e>
      bunpin(dbuf);
    80003c70:	8526                	mv	a0,s1
    80003c72:	9aaff0ef          	jal	80002e1c <bunpin>
    80003c76:	b74d                	j	80003c18 <install_trans+0x4e>
}
    80003c78:	60a6                	ld	ra,72(sp)
    80003c7a:	6406                	ld	s0,64(sp)
    80003c7c:	74e2                	ld	s1,56(sp)
    80003c7e:	7942                	ld	s2,48(sp)
    80003c80:	79a2                	ld	s3,40(sp)
    80003c82:	7a02                	ld	s4,32(sp)
    80003c84:	6ae2                	ld	s5,24(sp)
    80003c86:	6b42                	ld	s6,16(sp)
    80003c88:	6ba2                	ld	s7,8(sp)
    80003c8a:	6161                	addi	sp,sp,80
    80003c8c:	8082                	ret
    80003c8e:	8082                	ret

0000000080003c90 <initlog>:
{
    80003c90:	7179                	addi	sp,sp,-48
    80003c92:	f406                	sd	ra,40(sp)
    80003c94:	f022                	sd	s0,32(sp)
    80003c96:	ec26                	sd	s1,24(sp)
    80003c98:	e84a                	sd	s2,16(sp)
    80003c9a:	e44e                	sd	s3,8(sp)
    80003c9c:	1800                	addi	s0,sp,48
    80003c9e:	892a                	mv	s2,a0
    80003ca0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003ca2:	0001f497          	auipc	s1,0x1f
    80003ca6:	cc648493          	addi	s1,s1,-826 # 80022968 <log>
    80003caa:	00004597          	auipc	a1,0x4
    80003cae:	84e58593          	addi	a1,a1,-1970 # 800074f8 <etext+0x4f8>
    80003cb2:	8526                	mv	a0,s1
    80003cb4:	e79fc0ef          	jal	80000b2c <initlock>
  log.start = sb->logstart;
    80003cb8:	0149a583          	lw	a1,20(s3)
    80003cbc:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80003cbe:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003cc2:	854a                	mv	a0,s2
    80003cc4:	f95fe0ef          	jal	80002c58 <bread>
  log.lh.n = lh->n;
    80003cc8:	4d30                	lw	a2,88(a0)
    80003cca:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003ccc:	00c05f63          	blez	a2,80003cea <initlog+0x5a>
    80003cd0:	87aa                	mv	a5,a0
    80003cd2:	0001f717          	auipc	a4,0x1f
    80003cd6:	cc670713          	addi	a4,a4,-826 # 80022998 <log+0x30>
    80003cda:	060a                	slli	a2,a2,0x2
    80003cdc:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003cde:	4ff4                	lw	a3,92(a5)
    80003ce0:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003ce2:	0791                	addi	a5,a5,4
    80003ce4:	0711                	addi	a4,a4,4
    80003ce6:	fec79ce3          	bne	a5,a2,80003cde <initlog+0x4e>
  brelse(buf);
    80003cea:	876ff0ef          	jal	80002d60 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003cee:	4505                	li	a0,1
    80003cf0:	edbff0ef          	jal	80003bca <install_trans>
  log.lh.n = 0;
    80003cf4:	0001f797          	auipc	a5,0x1f
    80003cf8:	ca07a023          	sw	zero,-864(a5) # 80022994 <log+0x2c>
  write_head(); // clear the log
    80003cfc:	e71ff0ef          	jal	80003b6c <write_head>
}
    80003d00:	70a2                	ld	ra,40(sp)
    80003d02:	7402                	ld	s0,32(sp)
    80003d04:	64e2                	ld	s1,24(sp)
    80003d06:	6942                	ld	s2,16(sp)
    80003d08:	69a2                	ld	s3,8(sp)
    80003d0a:	6145                	addi	sp,sp,48
    80003d0c:	8082                	ret

0000000080003d0e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003d0e:	1101                	addi	sp,sp,-32
    80003d10:	ec06                	sd	ra,24(sp)
    80003d12:	e822                	sd	s0,16(sp)
    80003d14:	e426                	sd	s1,8(sp)
    80003d16:	e04a                	sd	s2,0(sp)
    80003d18:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003d1a:	0001f517          	auipc	a0,0x1f
    80003d1e:	c4e50513          	addi	a0,a0,-946 # 80022968 <log>
    80003d22:	e81fc0ef          	jal	80000ba2 <acquire>
  while (1) {
    if (log.committing) {
    80003d26:	0001f497          	auipc	s1,0x1f
    80003d2a:	c4248493          	addi	s1,s1,-958 # 80022968 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003d2e:	4979                	li	s2,30
    80003d30:	a029                	j	80003d3a <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003d32:	85a6                	mv	a1,s1
    80003d34:	8526                	mv	a0,s1
    80003d36:	a20fe0ef          	jal	80001f56 <sleep>
    if (log.committing) {
    80003d3a:	509c                	lw	a5,32(s1)
    80003d3c:	fbfd                	bnez	a5,80003d32 <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003d3e:	4cd8                	lw	a4,28(s1)
    80003d40:	2705                	addiw	a4,a4,1
    80003d42:	0027179b          	slliw	a5,a4,0x2
    80003d46:	9fb9                	addw	a5,a5,a4
    80003d48:	0017979b          	slliw	a5,a5,0x1
    80003d4c:	54d4                	lw	a3,44(s1)
    80003d4e:	9fb5                	addw	a5,a5,a3
    80003d50:	00f95763          	bge	s2,a5,80003d5e <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003d54:	85a6                	mv	a1,s1
    80003d56:	8526                	mv	a0,s1
    80003d58:	9fefe0ef          	jal	80001f56 <sleep>
    80003d5c:	bff9                	j	80003d3a <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003d5e:	0001f517          	auipc	a0,0x1f
    80003d62:	c0a50513          	addi	a0,a0,-1014 # 80022968 <log>
    80003d66:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    80003d68:	ec7fc0ef          	jal	80000c2e <release>
      break;
    }
  }
}
    80003d6c:	60e2                	ld	ra,24(sp)
    80003d6e:	6442                	ld	s0,16(sp)
    80003d70:	64a2                	ld	s1,8(sp)
    80003d72:	6902                	ld	s2,0(sp)
    80003d74:	6105                	addi	sp,sp,32
    80003d76:	8082                	ret

0000000080003d78 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003d78:	7139                	addi	sp,sp,-64
    80003d7a:	fc06                	sd	ra,56(sp)
    80003d7c:	f822                	sd	s0,48(sp)
    80003d7e:	f426                	sd	s1,40(sp)
    80003d80:	f04a                	sd	s2,32(sp)
    80003d82:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003d84:	0001f497          	auipc	s1,0x1f
    80003d88:	be448493          	addi	s1,s1,-1052 # 80022968 <log>
    80003d8c:	8526                	mv	a0,s1
    80003d8e:	e15fc0ef          	jal	80000ba2 <acquire>
  log.outstanding -= 1;
    80003d92:	4cdc                	lw	a5,28(s1)
    80003d94:	37fd                	addiw	a5,a5,-1
    80003d96:	0007891b          	sext.w	s2,a5
    80003d9a:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    80003d9c:	509c                	lw	a5,32(s1)
    80003d9e:	e3b1                	bnez	a5,80003de2 <end_op+0x6a>
    panic("log.committing");
  if (log.outstanding == 0) {
    80003da0:	04091a63          	bnez	s2,80003df4 <end_op+0x7c>
    do_commit = 1;
    log.committing = 1;
    80003da4:	0001f497          	auipc	s1,0x1f
    80003da8:	bc448493          	addi	s1,s1,-1084 # 80022968 <log>
    80003dac:	4785                	li	a5,1
    80003dae:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003db0:	8526                	mv	a0,s1
    80003db2:	e7dfc0ef          	jal	80000c2e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003db6:	54dc                	lw	a5,44(s1)
    80003db8:	04f04e63          	bgtz	a5,80003e14 <end_op+0x9c>
    acquire(&log.lock);
    80003dbc:	0001f497          	auipc	s1,0x1f
    80003dc0:	bac48493          	addi	s1,s1,-1108 # 80022968 <log>
    80003dc4:	8526                	mv	a0,s1
    80003dc6:	dddfc0ef          	jal	80000ba2 <acquire>
    log.committing = 0;
    80003dca:	0204a023          	sw	zero,32(s1)
    log.ncommit += 1;
    80003dce:	549c                	lw	a5,40(s1)
    80003dd0:	2785                	addiw	a5,a5,1
    80003dd2:	d49c                	sw	a5,40(s1)
    wakeup(&log);
    80003dd4:	8526                	mv	a0,s1
    80003dd6:	9ccfe0ef          	jal	80001fa2 <wakeup>
    release(&log.lock);
    80003dda:	8526                	mv	a0,s1
    80003ddc:	e53fc0ef          	jal	80000c2e <release>
}
    80003de0:	a025                	j	80003e08 <end_op+0x90>
    80003de2:	ec4e                	sd	s3,24(sp)
    80003de4:	e852                	sd	s4,16(sp)
    80003de6:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003de8:	00003517          	auipc	a0,0x3
    80003dec:	71850513          	addi	a0,a0,1816 # 80007500 <etext+0x500>
    80003df0:	9e5fc0ef          	jal	800007d4 <panic>
    wakeup(&log);
    80003df4:	0001f497          	auipc	s1,0x1f
    80003df8:	b7448493          	addi	s1,s1,-1164 # 80022968 <log>
    80003dfc:	8526                	mv	a0,s1
    80003dfe:	9a4fe0ef          	jal	80001fa2 <wakeup>
  release(&log.lock);
    80003e02:	8526                	mv	a0,s1
    80003e04:	e2bfc0ef          	jal	80000c2e <release>
}
    80003e08:	70e2                	ld	ra,56(sp)
    80003e0a:	7442                	ld	s0,48(sp)
    80003e0c:	74a2                	ld	s1,40(sp)
    80003e0e:	7902                	ld	s2,32(sp)
    80003e10:	6121                	addi	sp,sp,64
    80003e12:	8082                	ret
    80003e14:	ec4e                	sd	s3,24(sp)
    80003e16:	e852                	sd	s4,16(sp)
    80003e18:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e1a:	0001fa97          	auipc	s5,0x1f
    80003e1e:	b7ea8a93          	addi	s5,s5,-1154 # 80022998 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80003e22:	0001fa17          	auipc	s4,0x1f
    80003e26:	b46a0a13          	addi	s4,s4,-1210 # 80022968 <log>
    80003e2a:	018a2583          	lw	a1,24(s4)
    80003e2e:	012585bb          	addw	a1,a1,s2
    80003e32:	2585                	addiw	a1,a1,1
    80003e34:	024a2503          	lw	a0,36(s4)
    80003e38:	e21fe0ef          	jal	80002c58 <bread>
    80003e3c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003e3e:	000aa583          	lw	a1,0(s5)
    80003e42:	024a2503          	lw	a0,36(s4)
    80003e46:	e13fe0ef          	jal	80002c58 <bread>
    80003e4a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003e4c:	40000613          	li	a2,1024
    80003e50:	05850593          	addi	a1,a0,88
    80003e54:	05848513          	addi	a0,s1,88
    80003e58:	e6bfc0ef          	jal	80000cc2 <memmove>
    bwrite(to); // write the log
    80003e5c:	8526                	mv	a0,s1
    80003e5e:	ed1fe0ef          	jal	80002d2e <bwrite>
    brelse(from);
    80003e62:	854e                	mv	a0,s3
    80003e64:	efdfe0ef          	jal	80002d60 <brelse>
    brelse(to);
    80003e68:	8526                	mv	a0,s1
    80003e6a:	ef7fe0ef          	jal	80002d60 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e6e:	2905                	addiw	s2,s2,1
    80003e70:	0a91                	addi	s5,s5,4
    80003e72:	02ca2783          	lw	a5,44(s4)
    80003e76:	faf94ae3          	blt	s2,a5,80003e2a <end_op+0xb2>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    80003e7a:	cf3ff0ef          	jal	80003b6c <write_head>
    install_trans(0); // Now install writes to home locations
    80003e7e:	4501                	li	a0,0
    80003e80:	d4bff0ef          	jal	80003bca <install_trans>
    log.lh.n = 0;
    80003e84:	0001f797          	auipc	a5,0x1f
    80003e88:	b007a823          	sw	zero,-1264(a5) # 80022994 <log+0x2c>
    write_head(); // Erase the transaction from the log
    80003e8c:	ce1ff0ef          	jal	80003b6c <write_head>
    80003e90:	69e2                	ld	s3,24(sp)
    80003e92:	6a42                	ld	s4,16(sp)
    80003e94:	6aa2                	ld	s5,8(sp)
    80003e96:	b71d                	j	80003dbc <end_op+0x44>

0000000080003e98 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003e98:	1101                	addi	sp,sp,-32
    80003e9a:	ec06                	sd	ra,24(sp)
    80003e9c:	e822                	sd	s0,16(sp)
    80003e9e:	e426                	sd	s1,8(sp)
    80003ea0:	e04a                	sd	s2,0(sp)
    80003ea2:	1000                	addi	s0,sp,32
    80003ea4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003ea6:	0001f917          	auipc	s2,0x1f
    80003eaa:	ac290913          	addi	s2,s2,-1342 # 80022968 <log>
    80003eae:	854a                	mv	a0,s2
    80003eb0:	cf3fc0ef          	jal	80000ba2 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003eb4:	02c92603          	lw	a2,44(s2)
    80003eb8:	47f5                	li	a5,29
    80003eba:	04c7cc63          	blt	a5,a2,80003f12 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003ebe:	0001f797          	auipc	a5,0x1f
    80003ec2:	ac67a783          	lw	a5,-1338(a5) # 80022984 <log+0x1c>
    80003ec6:	04f05c63          	blez	a5,80003f1e <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003eca:	4781                	li	a5,0
    80003ecc:	04c05f63          	blez	a2,80003f2a <log_write+0x92>
    if (log.lh.block[i] == b->blockno) // log absorption
    80003ed0:	44cc                	lw	a1,12(s1)
    80003ed2:	0001f717          	auipc	a4,0x1f
    80003ed6:	ac670713          	addi	a4,a4,-1338 # 80022998 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003eda:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    80003edc:	4314                	lw	a3,0(a4)
    80003ede:	04b68663          	beq	a3,a1,80003f2a <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003ee2:	2785                	addiw	a5,a5,1
    80003ee4:	0711                	addi	a4,a4,4
    80003ee6:	fef61be3          	bne	a2,a5,80003edc <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003eea:	0621                	addi	a2,a2,8
    80003eec:	060a                	slli	a2,a2,0x2
    80003eee:	0001f797          	auipc	a5,0x1f
    80003ef2:	a7a78793          	addi	a5,a5,-1414 # 80022968 <log>
    80003ef6:	97b2                	add	a5,a5,a2
    80003ef8:	44d8                	lw	a4,12(s1)
    80003efa:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    80003efc:	8526                	mv	a0,s1
    80003efe:	eebfe0ef          	jal	80002de8 <bpin>
    log.lh.n++;
    80003f02:	0001f717          	auipc	a4,0x1f
    80003f06:	a6670713          	addi	a4,a4,-1434 # 80022968 <log>
    80003f0a:	575c                	lw	a5,44(a4)
    80003f0c:	2785                	addiw	a5,a5,1
    80003f0e:	d75c                	sw	a5,44(a4)
    80003f10:	a80d                	j	80003f42 <log_write+0xaa>
    panic("too big a transaction");
    80003f12:	00003517          	auipc	a0,0x3
    80003f16:	5fe50513          	addi	a0,a0,1534 # 80007510 <etext+0x510>
    80003f1a:	8bbfc0ef          	jal	800007d4 <panic>
    panic("log_write outside of trans");
    80003f1e:	00003517          	auipc	a0,0x3
    80003f22:	60a50513          	addi	a0,a0,1546 # 80007528 <etext+0x528>
    80003f26:	8affc0ef          	jal	800007d4 <panic>
  log.lh.block[i] = b->blockno;
    80003f2a:	00878693          	addi	a3,a5,8
    80003f2e:	068a                	slli	a3,a3,0x2
    80003f30:	0001f717          	auipc	a4,0x1f
    80003f34:	a3870713          	addi	a4,a4,-1480 # 80022968 <log>
    80003f38:	9736                	add	a4,a4,a3
    80003f3a:	44d4                	lw	a3,12(s1)
    80003f3c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    80003f3e:	faf60fe3          	beq	a2,a5,80003efc <log_write+0x64>
  }
  release(&log.lock);
    80003f42:	0001f517          	auipc	a0,0x1f
    80003f46:	a2650513          	addi	a0,a0,-1498 # 80022968 <log>
    80003f4a:	ce5fc0ef          	jal	80000c2e <release>
}
    80003f4e:	60e2                	ld	ra,24(sp)
    80003f50:	6442                	ld	s0,16(sp)
    80003f52:	64a2                	ld	s1,8(sp)
    80003f54:	6902                	ld	s2,0(sp)
    80003f56:	6105                	addi	sp,sp,32
    80003f58:	8082                	ret

0000000080003f5a <sys_sync>:

uint64
sys_sync(void)
{
    80003f5a:	1101                	addi	sp,sp,-32
    80003f5c:	ec06                	sd	ra,24(sp)
    80003f5e:	e822                	sd	s0,16(sp)
    80003f60:	e426                	sd	s1,8(sp)
    80003f62:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003f64:	0001f497          	auipc	s1,0x1f
    80003f68:	a0448493          	addi	s1,s1,-1532 # 80022968 <log>
    80003f6c:	8526                	mv	a0,s1
    80003f6e:	c35fc0ef          	jal	80000ba2 <acquire>
  if (log.committing || log.outstanding > 0) {
    80003f72:	509c                	lw	a5,32(s1)
    80003f74:	e799                	bnez	a5,80003f82 <sys_sync+0x28>
    80003f76:	0001f797          	auipc	a5,0x1f
    80003f7a:	a0e7a783          	lw	a5,-1522(a5) # 80022984 <log+0x1c>
    80003f7e:	02f05363          	blez	a5,80003fa4 <sys_sync+0x4a>
    80003f82:	e04a                	sd	s2,0(sp)
    int n = log.ncommit + 1;
    80003f84:	0001f917          	auipc	s2,0x1f
    80003f88:	a0c92903          	lw	s2,-1524(s2) # 80022990 <log+0x28>
    while (log.ncommit < n) {
      sleep(&log, &log.lock);
    80003f8c:	0001f497          	auipc	s1,0x1f
    80003f90:	9dc48493          	addi	s1,s1,-1572 # 80022968 <log>
    80003f94:	85a6                	mv	a1,s1
    80003f96:	8526                	mv	a0,s1
    80003f98:	fbffd0ef          	jal	80001f56 <sleep>
    while (log.ncommit < n) {
    80003f9c:	549c                	lw	a5,40(s1)
    80003f9e:	fef95be3          	bge	s2,a5,80003f94 <sys_sync+0x3a>
    80003fa2:	6902                	ld	s2,0(sp)
    }
  }
  release(&log.lock);
    80003fa4:	0001f517          	auipc	a0,0x1f
    80003fa8:	9c450513          	addi	a0,a0,-1596 # 80022968 <log>
    80003fac:	c83fc0ef          	jal	80000c2e <release>
  return 0;
}
    80003fb0:	4501                	li	a0,0
    80003fb2:	60e2                	ld	ra,24(sp)
    80003fb4:	6442                	ld	s0,16(sp)
    80003fb6:	64a2                	ld	s1,8(sp)
    80003fb8:	6105                	addi	sp,sp,32
    80003fba:	8082                	ret

0000000080003fbc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003fbc:	1101                	addi	sp,sp,-32
    80003fbe:	ec06                	sd	ra,24(sp)
    80003fc0:	e822                	sd	s0,16(sp)
    80003fc2:	e426                	sd	s1,8(sp)
    80003fc4:	e04a                	sd	s2,0(sp)
    80003fc6:	1000                	addi	s0,sp,32
    80003fc8:	84aa                	mv	s1,a0
    80003fca:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003fcc:	00003597          	auipc	a1,0x3
    80003fd0:	57c58593          	addi	a1,a1,1404 # 80007548 <etext+0x548>
    80003fd4:	0521                	addi	a0,a0,8
    80003fd6:	b57fc0ef          	jal	80000b2c <initlock>
  lk->name = name;
    80003fda:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003fde:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003fe2:	0204a423          	sw	zero,40(s1)
}
    80003fe6:	60e2                	ld	ra,24(sp)
    80003fe8:	6442                	ld	s0,16(sp)
    80003fea:	64a2                	ld	s1,8(sp)
    80003fec:	6902                	ld	s2,0(sp)
    80003fee:	6105                	addi	sp,sp,32
    80003ff0:	8082                	ret

0000000080003ff2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003ff2:	1101                	addi	sp,sp,-32
    80003ff4:	ec06                	sd	ra,24(sp)
    80003ff6:	e822                	sd	s0,16(sp)
    80003ff8:	e426                	sd	s1,8(sp)
    80003ffa:	e04a                	sd	s2,0(sp)
    80003ffc:	1000                	addi	s0,sp,32
    80003ffe:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004000:	00850913          	addi	s2,a0,8
    80004004:	854a                	mv	a0,s2
    80004006:	b9dfc0ef          	jal	80000ba2 <acquire>
  while (lk->locked) {
    8000400a:	409c                	lw	a5,0(s1)
    8000400c:	c799                	beqz	a5,8000401a <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000400e:	85ca                	mv	a1,s2
    80004010:	8526                	mv	a0,s1
    80004012:	f45fd0ef          	jal	80001f56 <sleep>
  while (lk->locked) {
    80004016:	409c                	lw	a5,0(s1)
    80004018:	fbfd                	bnez	a5,8000400e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000401a:	4785                	li	a5,1
    8000401c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000401e:	875fd0ef          	jal	80001892 <myproc>
    80004022:	591c                	lw	a5,48(a0)
    80004024:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004026:	854a                	mv	a0,s2
    80004028:	c07fc0ef          	jal	80000c2e <release>
}
    8000402c:	60e2                	ld	ra,24(sp)
    8000402e:	6442                	ld	s0,16(sp)
    80004030:	64a2                	ld	s1,8(sp)
    80004032:	6902                	ld	s2,0(sp)
    80004034:	6105                	addi	sp,sp,32
    80004036:	8082                	ret

0000000080004038 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004038:	1101                	addi	sp,sp,-32
    8000403a:	ec06                	sd	ra,24(sp)
    8000403c:	e822                	sd	s0,16(sp)
    8000403e:	e426                	sd	s1,8(sp)
    80004040:	e04a                	sd	s2,0(sp)
    80004042:	1000                	addi	s0,sp,32
    80004044:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004046:	00850913          	addi	s2,a0,8
    8000404a:	854a                	mv	a0,s2
    8000404c:	b57fc0ef          	jal	80000ba2 <acquire>
  lk->locked = 0;
    80004050:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004054:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004058:	8526                	mv	a0,s1
    8000405a:	f49fd0ef          	jal	80001fa2 <wakeup>
  release(&lk->lk);
    8000405e:	854a                	mv	a0,s2
    80004060:	bcffc0ef          	jal	80000c2e <release>
}
    80004064:	60e2                	ld	ra,24(sp)
    80004066:	6442                	ld	s0,16(sp)
    80004068:	64a2                	ld	s1,8(sp)
    8000406a:	6902                	ld	s2,0(sp)
    8000406c:	6105                	addi	sp,sp,32
    8000406e:	8082                	ret

0000000080004070 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004070:	7179                	addi	sp,sp,-48
    80004072:	f406                	sd	ra,40(sp)
    80004074:	f022                	sd	s0,32(sp)
    80004076:	ec26                	sd	s1,24(sp)
    80004078:	e84a                	sd	s2,16(sp)
    8000407a:	1800                	addi	s0,sp,48
    8000407c:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    8000407e:	00850913          	addi	s2,a0,8
    80004082:	854a                	mv	a0,s2
    80004084:	b1ffc0ef          	jal	80000ba2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004088:	409c                	lw	a5,0(s1)
    8000408a:	ef81                	bnez	a5,800040a2 <holdingsleep+0x32>
    8000408c:	4481                	li	s1,0
  release(&lk->lk);
    8000408e:	854a                	mv	a0,s2
    80004090:	b9ffc0ef          	jal	80000c2e <release>
  return r;
}
    80004094:	8526                	mv	a0,s1
    80004096:	70a2                	ld	ra,40(sp)
    80004098:	7402                	ld	s0,32(sp)
    8000409a:	64e2                	ld	s1,24(sp)
    8000409c:	6942                	ld	s2,16(sp)
    8000409e:	6145                	addi	sp,sp,48
    800040a0:	8082                	ret
    800040a2:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800040a4:	0284a983          	lw	s3,40(s1)
    800040a8:	feafd0ef          	jal	80001892 <myproc>
    800040ac:	5904                	lw	s1,48(a0)
    800040ae:	413484b3          	sub	s1,s1,s3
    800040b2:	0014b493          	seqz	s1,s1
    800040b6:	69a2                	ld	s3,8(sp)
    800040b8:	bfd9                	j	8000408e <holdingsleep+0x1e>

00000000800040ba <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800040ba:	1141                	addi	sp,sp,-16
    800040bc:	e406                	sd	ra,8(sp)
    800040be:	e022                	sd	s0,0(sp)
    800040c0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800040c2:	00003597          	auipc	a1,0x3
    800040c6:	49658593          	addi	a1,a1,1174 # 80007558 <etext+0x558>
    800040ca:	0001f517          	auipc	a0,0x1f
    800040ce:	9e650513          	addi	a0,a0,-1562 # 80022ab0 <ftable>
    800040d2:	a5bfc0ef          	jal	80000b2c <initlock>
}
    800040d6:	60a2                	ld	ra,8(sp)
    800040d8:	6402                	ld	s0,0(sp)
    800040da:	0141                	addi	sp,sp,16
    800040dc:	8082                	ret

00000000800040de <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    800040de:	1101                	addi	sp,sp,-32
    800040e0:	ec06                	sd	ra,24(sp)
    800040e2:	e822                	sd	s0,16(sp)
    800040e4:	e426                	sd	s1,8(sp)
    800040e6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800040e8:	0001f517          	auipc	a0,0x1f
    800040ec:	9c850513          	addi	a0,a0,-1592 # 80022ab0 <ftable>
    800040f0:	ab3fc0ef          	jal	80000ba2 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800040f4:	0001f497          	auipc	s1,0x1f
    800040f8:	9d448493          	addi	s1,s1,-1580 # 80022ac8 <ftable+0x18>
    800040fc:	00020717          	auipc	a4,0x20
    80004100:	96c70713          	addi	a4,a4,-1684 # 80023a68 <disk>
    if (f->ref == 0) {
    80004104:	40dc                	lw	a5,4(s1)
    80004106:	cf89                	beqz	a5,80004120 <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80004108:	02848493          	addi	s1,s1,40
    8000410c:	fee49ce3          	bne	s1,a4,80004104 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004110:	0001f517          	auipc	a0,0x1f
    80004114:	9a050513          	addi	a0,a0,-1632 # 80022ab0 <ftable>
    80004118:	b17fc0ef          	jal	80000c2e <release>
  return 0;
    8000411c:	4481                	li	s1,0
    8000411e:	a809                	j	80004130 <filealloc+0x52>
      f->ref = 1;
    80004120:	4785                	li	a5,1
    80004122:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004124:	0001f517          	auipc	a0,0x1f
    80004128:	98c50513          	addi	a0,a0,-1652 # 80022ab0 <ftable>
    8000412c:	b03fc0ef          	jal	80000c2e <release>
}
    80004130:	8526                	mv	a0,s1
    80004132:	60e2                	ld	ra,24(sp)
    80004134:	6442                	ld	s0,16(sp)
    80004136:	64a2                	ld	s1,8(sp)
    80004138:	6105                	addi	sp,sp,32
    8000413a:	8082                	ret

000000008000413c <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    8000413c:	1101                	addi	sp,sp,-32
    8000413e:	ec06                	sd	ra,24(sp)
    80004140:	e822                	sd	s0,16(sp)
    80004142:	e426                	sd	s1,8(sp)
    80004144:	1000                	addi	s0,sp,32
    80004146:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004148:	0001f517          	auipc	a0,0x1f
    8000414c:	96850513          	addi	a0,a0,-1688 # 80022ab0 <ftable>
    80004150:	a53fc0ef          	jal	80000ba2 <acquire>
  if (f->ref < 1)
    80004154:	40dc                	lw	a5,4(s1)
    80004156:	02f05063          	blez	a5,80004176 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000415a:	2785                	addiw	a5,a5,1
    8000415c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000415e:	0001f517          	auipc	a0,0x1f
    80004162:	95250513          	addi	a0,a0,-1710 # 80022ab0 <ftable>
    80004166:	ac9fc0ef          	jal	80000c2e <release>
  return f;
}
    8000416a:	8526                	mv	a0,s1
    8000416c:	60e2                	ld	ra,24(sp)
    8000416e:	6442                	ld	s0,16(sp)
    80004170:	64a2                	ld	s1,8(sp)
    80004172:	6105                	addi	sp,sp,32
    80004174:	8082                	ret
    panic("filedup");
    80004176:	00003517          	auipc	a0,0x3
    8000417a:	3ea50513          	addi	a0,a0,1002 # 80007560 <etext+0x560>
    8000417e:	e56fc0ef          	jal	800007d4 <panic>

0000000080004182 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004182:	7139                	addi	sp,sp,-64
    80004184:	fc06                	sd	ra,56(sp)
    80004186:	f822                	sd	s0,48(sp)
    80004188:	f426                	sd	s1,40(sp)
    8000418a:	0080                	addi	s0,sp,64
    8000418c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000418e:	0001f517          	auipc	a0,0x1f
    80004192:	92250513          	addi	a0,a0,-1758 # 80022ab0 <ftable>
    80004196:	a0dfc0ef          	jal	80000ba2 <acquire>
  if (f->ref < 1)
    8000419a:	40dc                	lw	a5,4(s1)
    8000419c:	04f05a63          	blez	a5,800041f0 <fileclose+0x6e>
    panic("fileclose");
  if (--f->ref > 0) {
    800041a0:	37fd                	addiw	a5,a5,-1
    800041a2:	0007871b          	sext.w	a4,a5
    800041a6:	c0dc                	sw	a5,4(s1)
    800041a8:	04e04e63          	bgtz	a4,80004204 <fileclose+0x82>
    800041ac:	f04a                	sd	s2,32(sp)
    800041ae:	ec4e                	sd	s3,24(sp)
    800041b0:	e852                	sd	s4,16(sp)
    800041b2:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800041b4:	0004a903          	lw	s2,0(s1)
    800041b8:	0094ca83          	lbu	s5,9(s1)
    800041bc:	0104ba03          	ld	s4,16(s1)
    800041c0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800041c4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800041c8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800041cc:	0001f517          	auipc	a0,0x1f
    800041d0:	8e450513          	addi	a0,a0,-1820 # 80022ab0 <ftable>
    800041d4:	a5bfc0ef          	jal	80000c2e <release>

  if (ff.type == FD_PIPE) {
    800041d8:	4785                	li	a5,1
    800041da:	04f90063          	beq	s2,a5,8000421a <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    800041de:	3979                	addiw	s2,s2,-2
    800041e0:	4785                	li	a5,1
    800041e2:	0527f563          	bgeu	a5,s2,8000422c <fileclose+0xaa>
    800041e6:	7902                	ld	s2,32(sp)
    800041e8:	69e2                	ld	s3,24(sp)
    800041ea:	6a42                	ld	s4,16(sp)
    800041ec:	6aa2                	ld	s5,8(sp)
    800041ee:	a00d                	j	80004210 <fileclose+0x8e>
    800041f0:	f04a                	sd	s2,32(sp)
    800041f2:	ec4e                	sd	s3,24(sp)
    800041f4:	e852                	sd	s4,16(sp)
    800041f6:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800041f8:	00003517          	auipc	a0,0x3
    800041fc:	37050513          	addi	a0,a0,880 # 80007568 <etext+0x568>
    80004200:	dd4fc0ef          	jal	800007d4 <panic>
    release(&ftable.lock);
    80004204:	0001f517          	auipc	a0,0x1f
    80004208:	8ac50513          	addi	a0,a0,-1876 # 80022ab0 <ftable>
    8000420c:	a23fc0ef          	jal	80000c2e <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004210:	70e2                	ld	ra,56(sp)
    80004212:	7442                	ld	s0,48(sp)
    80004214:	74a2                	ld	s1,40(sp)
    80004216:	6121                	addi	sp,sp,64
    80004218:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000421a:	85d6                	mv	a1,s5
    8000421c:	8552                	mv	a0,s4
    8000421e:	336000ef          	jal	80004554 <pipeclose>
    80004222:	7902                	ld	s2,32(sp)
    80004224:	69e2                	ld	s3,24(sp)
    80004226:	6a42                	ld	s4,16(sp)
    80004228:	6aa2                	ld	s5,8(sp)
    8000422a:	b7dd                	j	80004210 <fileclose+0x8e>
    begin_op();
    8000422c:	ae3ff0ef          	jal	80003d0e <begin_op>
    iput(ff.ip);
    80004230:	854e                	mv	a0,s3
    80004232:	a74ff0ef          	jal	800034a6 <iput>
    end_op();
    80004236:	b43ff0ef          	jal	80003d78 <end_op>
    8000423a:	7902                	ld	s2,32(sp)
    8000423c:	69e2                	ld	s3,24(sp)
    8000423e:	6a42                	ld	s4,16(sp)
    80004240:	6aa2                	ld	s5,8(sp)
    80004242:	b7f9                	j	80004210 <fileclose+0x8e>

0000000080004244 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004244:	715d                	addi	sp,sp,-80
    80004246:	e486                	sd	ra,72(sp)
    80004248:	e0a2                	sd	s0,64(sp)
    8000424a:	fc26                	sd	s1,56(sp)
    8000424c:	f44e                	sd	s3,40(sp)
    8000424e:	0880                	addi	s0,sp,80
    80004250:	84aa                	mv	s1,a0
    80004252:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004254:	e3efd0ef          	jal	80001892 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80004258:	409c                	lw	a5,0(s1)
    8000425a:	37f9                	addiw	a5,a5,-2
    8000425c:	4705                	li	a4,1
    8000425e:	04f76063          	bltu	a4,a5,8000429e <filestat+0x5a>
    80004262:	f84a                	sd	s2,48(sp)
    80004264:	892a                	mv	s2,a0
    ilock(f->ip);
    80004266:	6c88                	ld	a0,24(s1)
    80004268:	8bcff0ef          	jal	80003324 <ilock>
    stati(f->ip, &st);
    8000426c:	fb840593          	addi	a1,s0,-72
    80004270:	6c88                	ld	a0,24(s1)
    80004272:	c18ff0ef          	jal	8000368a <stati>
    iunlock(f->ip);
    80004276:	6c88                	ld	a0,24(s1)
    80004278:	95aff0ef          	jal	800033d2 <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000427c:	46e1                	li	a3,24
    8000427e:	fb840613          	addi	a2,s0,-72
    80004282:	85ce                	mv	a1,s3
    80004284:	05093503          	ld	a0,80(s2)
    80004288:	b1efd0ef          	jal	800015a6 <copyout>
    8000428c:	41f5551b          	sraiw	a0,a0,0x1f
    80004290:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004292:	60a6                	ld	ra,72(sp)
    80004294:	6406                	ld	s0,64(sp)
    80004296:	74e2                	ld	s1,56(sp)
    80004298:	79a2                	ld	s3,40(sp)
    8000429a:	6161                	addi	sp,sp,80
    8000429c:	8082                	ret
  return -1;
    8000429e:	557d                	li	a0,-1
    800042a0:	bfcd                	j	80004292 <filestat+0x4e>

00000000800042a2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800042a2:	7179                	addi	sp,sp,-48
    800042a4:	f406                	sd	ra,40(sp)
    800042a6:	f022                	sd	s0,32(sp)
    800042a8:	e84a                	sd	s2,16(sp)
    800042aa:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0)
    800042ac:	00854783          	lbu	a5,8(a0)
    800042b0:	cfd1                	beqz	a5,8000434c <fileread+0xaa>
    800042b2:	ec26                	sd	s1,24(sp)
    800042b4:	e44e                	sd	s3,8(sp)
    800042b6:	84aa                	mv	s1,a0
    800042b8:	89ae                	mv	s3,a1
    800042ba:	8932                	mv	s2,a2
    return -1;

  if (f->type == FD_PIPE) {
    800042bc:	411c                	lw	a5,0(a0)
    800042be:	4705                	li	a4,1
    800042c0:	04e78363          	beq	a5,a4,80004306 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    800042c4:	470d                	li	a4,3
    800042c6:	04e78763          	beq	a5,a4,80004314 <fileread+0x72>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    800042ca:	4709                	li	a4,2
    800042cc:	06e79a63          	bne	a5,a4,80004340 <fileread+0x9e>
    ilock(f->ip);
    800042d0:	6d08                	ld	a0,24(a0)
    800042d2:	852ff0ef          	jal	80003324 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800042d6:	874a                	mv	a4,s2
    800042d8:	5094                	lw	a3,32(s1)
    800042da:	864e                	mv	a2,s3
    800042dc:	4585                	li	a1,1
    800042de:	6c88                	ld	a0,24(s1)
    800042e0:	bd4ff0ef          	jal	800036b4 <readi>
    800042e4:	892a                	mv	s2,a0
    800042e6:	00a05563          	blez	a0,800042f0 <fileread+0x4e>
      f->off += r;
    800042ea:	509c                	lw	a5,32(s1)
    800042ec:	9fa9                	addw	a5,a5,a0
    800042ee:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800042f0:	6c88                	ld	a0,24(s1)
    800042f2:	8e0ff0ef          	jal	800033d2 <iunlock>
    800042f6:	64e2                	ld	s1,24(sp)
    800042f8:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800042fa:	854a                	mv	a0,s2
    800042fc:	70a2                	ld	ra,40(sp)
    800042fe:	7402                	ld	s0,32(sp)
    80004300:	6942                	ld	s2,16(sp)
    80004302:	6145                	addi	sp,sp,48
    80004304:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004306:	6908                	ld	a0,16(a0)
    80004308:	388000ef          	jal	80004690 <piperead>
    8000430c:	892a                	mv	s2,a0
    8000430e:	64e2                	ld	s1,24(sp)
    80004310:	69a2                	ld	s3,8(sp)
    80004312:	b7e5                	j	800042fa <fileread+0x58>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004314:	02451783          	lh	a5,36(a0)
    80004318:	03079693          	slli	a3,a5,0x30
    8000431c:	92c1                	srli	a3,a3,0x30
    8000431e:	4725                	li	a4,9
    80004320:	02d76863          	bltu	a4,a3,80004350 <fileread+0xae>
    80004324:	0792                	slli	a5,a5,0x4
    80004326:	0001e717          	auipc	a4,0x1e
    8000432a:	6ea70713          	addi	a4,a4,1770 # 80022a10 <devsw>
    8000432e:	97ba                	add	a5,a5,a4
    80004330:	639c                	ld	a5,0(a5)
    80004332:	c39d                	beqz	a5,80004358 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004334:	4505                	li	a0,1
    80004336:	9782                	jalr	a5
    80004338:	892a                	mv	s2,a0
    8000433a:	64e2                	ld	s1,24(sp)
    8000433c:	69a2                	ld	s3,8(sp)
    8000433e:	bf75                	j	800042fa <fileread+0x58>
    panic("fileread");
    80004340:	00003517          	auipc	a0,0x3
    80004344:	23850513          	addi	a0,a0,568 # 80007578 <etext+0x578>
    80004348:	c8cfc0ef          	jal	800007d4 <panic>
    return -1;
    8000434c:	597d                	li	s2,-1
    8000434e:	b775                	j	800042fa <fileread+0x58>
      return -1;
    80004350:	597d                	li	s2,-1
    80004352:	64e2                	ld	s1,24(sp)
    80004354:	69a2                	ld	s3,8(sp)
    80004356:	b755                	j	800042fa <fileread+0x58>
    80004358:	597d                	li	s2,-1
    8000435a:	64e2                	ld	s1,24(sp)
    8000435c:	69a2                	ld	s3,8(sp)
    8000435e:	bf71                	j	800042fa <fileread+0x58>

0000000080004360 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0)
    80004360:	00954783          	lbu	a5,9(a0)
    80004364:	10078b63          	beqz	a5,8000447a <filewrite+0x11a>
{
    80004368:	715d                	addi	sp,sp,-80
    8000436a:	e486                	sd	ra,72(sp)
    8000436c:	e0a2                	sd	s0,64(sp)
    8000436e:	f84a                	sd	s2,48(sp)
    80004370:	f052                	sd	s4,32(sp)
    80004372:	e85a                	sd	s6,16(sp)
    80004374:	0880                	addi	s0,sp,80
    80004376:	892a                	mv	s2,a0
    80004378:	8b2e                	mv	s6,a1
    8000437a:	8a32                	mv	s4,a2
    return -1;

  if (f->type == FD_PIPE) {
    8000437c:	411c                	lw	a5,0(a0)
    8000437e:	4705                	li	a4,1
    80004380:	02e78763          	beq	a5,a4,800043ae <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80004384:	470d                	li	a4,3
    80004386:	02e78863          	beq	a5,a4,800043b6 <filewrite+0x56>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    8000438a:	4709                	li	a4,2
    8000438c:	0ce79c63          	bne	a5,a4,80004464 <filewrite+0x104>
    80004390:	f44e                	sd	s3,40(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80004392:	0ac05863          	blez	a2,80004442 <filewrite+0xe2>
    80004396:	fc26                	sd	s1,56(sp)
    80004398:	ec56                	sd	s5,24(sp)
    8000439a:	e45e                	sd	s7,8(sp)
    8000439c:	e062                	sd	s8,0(sp)
    int i = 0;
    8000439e:	4981                	li	s3,0
      int n1 = n - i;
      if (n1 > max)
    800043a0:	6b85                	lui	s7,0x1
    800043a2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800043a6:	6c05                	lui	s8,0x1
    800043a8:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800043ac:	a8b5                	j	80004428 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800043ae:	6908                	ld	a0,16(a0)
    800043b0:	1fc000ef          	jal	800045ac <pipewrite>
    800043b4:	a04d                	j	80004456 <filewrite+0xf6>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800043b6:	02451783          	lh	a5,36(a0)
    800043ba:	03079693          	slli	a3,a5,0x30
    800043be:	92c1                	srli	a3,a3,0x30
    800043c0:	4725                	li	a4,9
    800043c2:	0ad76e63          	bltu	a4,a3,8000447e <filewrite+0x11e>
    800043c6:	0792                	slli	a5,a5,0x4
    800043c8:	0001e717          	auipc	a4,0x1e
    800043cc:	64870713          	addi	a4,a4,1608 # 80022a10 <devsw>
    800043d0:	97ba                	add	a5,a5,a4
    800043d2:	679c                	ld	a5,8(a5)
    800043d4:	c7dd                	beqz	a5,80004482 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800043d6:	4505                	li	a0,1
    800043d8:	9782                	jalr	a5
    800043da:	a8b5                	j	80004456 <filewrite+0xf6>
      if (n1 > max)
    800043dc:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800043e0:	92fff0ef          	jal	80003d0e <begin_op>
      ilock(f->ip);
    800043e4:	01893503          	ld	a0,24(s2)
    800043e8:	f3dfe0ef          	jal	80003324 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800043ec:	8756                	mv	a4,s5
    800043ee:	02092683          	lw	a3,32(s2)
    800043f2:	01698633          	add	a2,s3,s6
    800043f6:	4585                	li	a1,1
    800043f8:	01893503          	ld	a0,24(s2)
    800043fc:	bb4ff0ef          	jal	800037b0 <writei>
    80004400:	84aa                	mv	s1,a0
    80004402:	00a05763          	blez	a0,80004410 <filewrite+0xb0>
        f->off += r;
    80004406:	02092783          	lw	a5,32(s2)
    8000440a:	9fa9                	addw	a5,a5,a0
    8000440c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004410:	01893503          	ld	a0,24(s2)
    80004414:	fbffe0ef          	jal	800033d2 <iunlock>
      end_op();
    80004418:	961ff0ef          	jal	80003d78 <end_op>

      if (r != n1) {
    8000441c:	029a9563          	bne	s5,s1,80004446 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004420:	013489bb          	addw	s3,s1,s3
    while (i < n) {
    80004424:	0149da63          	bge	s3,s4,80004438 <filewrite+0xd8>
      int n1 = n - i;
    80004428:	413a04bb          	subw	s1,s4,s3
      if (n1 > max)
    8000442c:	0004879b          	sext.w	a5,s1
    80004430:	fafbd6e3          	bge	s7,a5,800043dc <filewrite+0x7c>
    80004434:	84e2                	mv	s1,s8
    80004436:	b75d                	j	800043dc <filewrite+0x7c>
    80004438:	74e2                	ld	s1,56(sp)
    8000443a:	6ae2                	ld	s5,24(sp)
    8000443c:	6ba2                	ld	s7,8(sp)
    8000443e:	6c02                	ld	s8,0(sp)
    80004440:	a039                	j	8000444e <filewrite+0xee>
    int i = 0;
    80004442:	4981                	li	s3,0
    80004444:	a029                	j	8000444e <filewrite+0xee>
    80004446:	74e2                	ld	s1,56(sp)
    80004448:	6ae2                	ld	s5,24(sp)
    8000444a:	6ba2                	ld	s7,8(sp)
    8000444c:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000444e:	033a1c63          	bne	s4,s3,80004486 <filewrite+0x126>
    80004452:	8552                	mv	a0,s4
    80004454:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004456:	60a6                	ld	ra,72(sp)
    80004458:	6406                	ld	s0,64(sp)
    8000445a:	7942                	ld	s2,48(sp)
    8000445c:	7a02                	ld	s4,32(sp)
    8000445e:	6b42                	ld	s6,16(sp)
    80004460:	6161                	addi	sp,sp,80
    80004462:	8082                	ret
    80004464:	fc26                	sd	s1,56(sp)
    80004466:	f44e                	sd	s3,40(sp)
    80004468:	ec56                	sd	s5,24(sp)
    8000446a:	e45e                	sd	s7,8(sp)
    8000446c:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000446e:	00003517          	auipc	a0,0x3
    80004472:	11a50513          	addi	a0,a0,282 # 80007588 <etext+0x588>
    80004476:	b5efc0ef          	jal	800007d4 <panic>
    return -1;
    8000447a:	557d                	li	a0,-1
}
    8000447c:	8082                	ret
      return -1;
    8000447e:	557d                	li	a0,-1
    80004480:	bfd9                	j	80004456 <filewrite+0xf6>
    80004482:	557d                	li	a0,-1
    80004484:	bfc9                	j	80004456 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80004486:	557d                	li	a0,-1
    80004488:	79a2                	ld	s3,40(sp)
    8000448a:	b7f1                	j	80004456 <filewrite+0xf6>

000000008000448c <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000448c:	7179                	addi	sp,sp,-48
    8000448e:	f406                	sd	ra,40(sp)
    80004490:	f022                	sd	s0,32(sp)
    80004492:	ec26                	sd	s1,24(sp)
    80004494:	e052                	sd	s4,0(sp)
    80004496:	1800                	addi	s0,sp,48
    80004498:	84aa                	mv	s1,a0
    8000449a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000449c:	0005b023          	sd	zero,0(a1)
    800044a0:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800044a4:	c3bff0ef          	jal	800040de <filealloc>
    800044a8:	e088                	sd	a0,0(s1)
    800044aa:	c549                	beqz	a0,80004534 <pipealloc+0xa8>
    800044ac:	c33ff0ef          	jal	800040de <filealloc>
    800044b0:	00aa3023          	sd	a0,0(s4)
    800044b4:	cd25                	beqz	a0,8000452c <pipealloc+0xa0>
    800044b6:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    800044b8:	e24fc0ef          	jal	80000adc <kalloc>
    800044bc:	892a                	mv	s2,a0
    800044be:	c12d                	beqz	a0,80004520 <pipealloc+0x94>
    800044c0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800044c2:	4985                	li	s3,1
    800044c4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800044c8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800044cc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800044d0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800044d4:	00003597          	auipc	a1,0x3
    800044d8:	0c458593          	addi	a1,a1,196 # 80007598 <etext+0x598>
    800044dc:	e50fc0ef          	jal	80000b2c <initlock>
  (*f0)->type = FD_PIPE;
    800044e0:	609c                	ld	a5,0(s1)
    800044e2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800044e6:	609c                	ld	a5,0(s1)
    800044e8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800044ec:	609c                	ld	a5,0(s1)
    800044ee:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800044f2:	609c                	ld	a5,0(s1)
    800044f4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800044f8:	000a3783          	ld	a5,0(s4)
    800044fc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004500:	000a3783          	ld	a5,0(s4)
    80004504:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004508:	000a3783          	ld	a5,0(s4)
    8000450c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004510:	000a3783          	ld	a5,0(s4)
    80004514:	0127b823          	sd	s2,16(a5)
  return 0;
    80004518:	4501                	li	a0,0
    8000451a:	6942                	ld	s2,16(sp)
    8000451c:	69a2                	ld	s3,8(sp)
    8000451e:	a01d                	j	80004544 <pipealloc+0xb8>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    80004520:	6088                	ld	a0,0(s1)
    80004522:	c119                	beqz	a0,80004528 <pipealloc+0x9c>
    80004524:	6942                	ld	s2,16(sp)
    80004526:	a029                	j	80004530 <pipealloc+0xa4>
    80004528:	6942                	ld	s2,16(sp)
    8000452a:	a029                	j	80004534 <pipealloc+0xa8>
    8000452c:	6088                	ld	a0,0(s1)
    8000452e:	c10d                	beqz	a0,80004550 <pipealloc+0xc4>
    fileclose(*f0);
    80004530:	c53ff0ef          	jal	80004182 <fileclose>
  if (*f1)
    80004534:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004538:	557d                	li	a0,-1
  if (*f1)
    8000453a:	c789                	beqz	a5,80004544 <pipealloc+0xb8>
    fileclose(*f1);
    8000453c:	853e                	mv	a0,a5
    8000453e:	c45ff0ef          	jal	80004182 <fileclose>
  return -1;
    80004542:	557d                	li	a0,-1
}
    80004544:	70a2                	ld	ra,40(sp)
    80004546:	7402                	ld	s0,32(sp)
    80004548:	64e2                	ld	s1,24(sp)
    8000454a:	6a02                	ld	s4,0(sp)
    8000454c:	6145                	addi	sp,sp,48
    8000454e:	8082                	ret
  return -1;
    80004550:	557d                	li	a0,-1
    80004552:	bfcd                	j	80004544 <pipealloc+0xb8>

0000000080004554 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004554:	1101                	addi	sp,sp,-32
    80004556:	ec06                	sd	ra,24(sp)
    80004558:	e822                	sd	s0,16(sp)
    8000455a:	e426                	sd	s1,8(sp)
    8000455c:	e04a                	sd	s2,0(sp)
    8000455e:	1000                	addi	s0,sp,32
    80004560:	84aa                	mv	s1,a0
    80004562:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004564:	e3efc0ef          	jal	80000ba2 <acquire>
  if (writable) {
    80004568:	02090763          	beqz	s2,80004596 <pipeclose+0x42>
    pi->writeopen = 0;
    8000456c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004570:	21848513          	addi	a0,s1,536
    80004574:	a2ffd0ef          	jal	80001fa2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80004578:	2204b783          	ld	a5,544(s1)
    8000457c:	e785                	bnez	a5,800045a4 <pipeclose+0x50>
    release(&pi->lock);
    8000457e:	8526                	mv	a0,s1
    80004580:	eaefc0ef          	jal	80000c2e <release>
    kfree((char *)pi);
    80004584:	8526                	mv	a0,s1
    80004586:	c74fc0ef          	jal	800009fa <kfree>
  } else
    release(&pi->lock);
}
    8000458a:	60e2                	ld	ra,24(sp)
    8000458c:	6442                	ld	s0,16(sp)
    8000458e:	64a2                	ld	s1,8(sp)
    80004590:	6902                	ld	s2,0(sp)
    80004592:	6105                	addi	sp,sp,32
    80004594:	8082                	ret
    pi->readopen = 0;
    80004596:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000459a:	21c48513          	addi	a0,s1,540
    8000459e:	a05fd0ef          	jal	80001fa2 <wakeup>
    800045a2:	bfd9                	j	80004578 <pipeclose+0x24>
    release(&pi->lock);
    800045a4:	8526                	mv	a0,s1
    800045a6:	e88fc0ef          	jal	80000c2e <release>
}
    800045aa:	b7c5                	j	8000458a <pipeclose+0x36>

00000000800045ac <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800045ac:	711d                	addi	sp,sp,-96
    800045ae:	ec86                	sd	ra,88(sp)
    800045b0:	e8a2                	sd	s0,80(sp)
    800045b2:	e4a6                	sd	s1,72(sp)
    800045b4:	e0ca                	sd	s2,64(sp)
    800045b6:	fc4e                	sd	s3,56(sp)
    800045b8:	f852                	sd	s4,48(sp)
    800045ba:	f456                	sd	s5,40(sp)
    800045bc:	1080                	addi	s0,sp,96
    800045be:	84aa                	mv	s1,a0
    800045c0:	8aae                	mv	s5,a1
    800045c2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800045c4:	acefd0ef          	jal	80001892 <myproc>
    800045c8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800045ca:	8526                	mv	a0,s1
    800045cc:	dd6fc0ef          	jal	80000ba2 <acquire>
  while (i < n) {
    800045d0:	0b405a63          	blez	s4,80004684 <pipewrite+0xd8>
    800045d4:	f05a                	sd	s6,32(sp)
    800045d6:	ec5e                	sd	s7,24(sp)
    800045d8:	e862                	sd	s8,16(sp)
  int i = 0;
    800045da:	4901                	li	s2,0
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800045dc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800045de:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800045e2:	21c48b93          	addi	s7,s1,540
    800045e6:	a81d                	j	8000461c <pipewrite+0x70>
      release(&pi->lock);
    800045e8:	8526                	mv	a0,s1
    800045ea:	e44fc0ef          	jal	80000c2e <release>
      return -1;
    800045ee:	597d                	li	s2,-1
    800045f0:	7b02                	ld	s6,32(sp)
    800045f2:	6be2                	ld	s7,24(sp)
    800045f4:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800045f6:	854a                	mv	a0,s2
    800045f8:	60e6                	ld	ra,88(sp)
    800045fa:	6446                	ld	s0,80(sp)
    800045fc:	64a6                	ld	s1,72(sp)
    800045fe:	6906                	ld	s2,64(sp)
    80004600:	79e2                	ld	s3,56(sp)
    80004602:	7a42                	ld	s4,48(sp)
    80004604:	7aa2                	ld	s5,40(sp)
    80004606:	6125                	addi	sp,sp,96
    80004608:	8082                	ret
      wakeup(&pi->nread);
    8000460a:	8562                	mv	a0,s8
    8000460c:	997fd0ef          	jal	80001fa2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004610:	85a6                	mv	a1,s1
    80004612:	855e                	mv	a0,s7
    80004614:	943fd0ef          	jal	80001f56 <sleep>
  while (i < n) {
    80004618:	05495b63          	bge	s2,s4,8000466e <pipewrite+0xc2>
    if (pi->readopen == 0 || killed(pr)) {
    8000461c:	2204a783          	lw	a5,544(s1)
    80004620:	d7e1                	beqz	a5,800045e8 <pipewrite+0x3c>
    80004622:	854e                	mv	a0,s3
    80004624:	b6bfd0ef          	jal	8000218e <killed>
    80004628:	f161                	bnez	a0,800045e8 <pipewrite+0x3c>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    8000462a:	2184a783          	lw	a5,536(s1)
    8000462e:	21c4a703          	lw	a4,540(s1)
    80004632:	2007879b          	addiw	a5,a5,512
    80004636:	fcf70ae3          	beq	a4,a5,8000460a <pipewrite+0x5e>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000463a:	4685                	li	a3,1
    8000463c:	01590633          	add	a2,s2,s5
    80004640:	faf40593          	addi	a1,s0,-81
    80004644:	0509b503          	ld	a0,80(s3)
    80004648:	842fd0ef          	jal	8000168a <copyin>
    8000464c:	03650e63          	beq	a0,s6,80004688 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004650:	21c4a783          	lw	a5,540(s1)
    80004654:	0017871b          	addiw	a4,a5,1
    80004658:	20e4ae23          	sw	a4,540(s1)
    8000465c:	1ff7f793          	andi	a5,a5,511
    80004660:	97a6                	add	a5,a5,s1
    80004662:	faf44703          	lbu	a4,-81(s0)
    80004666:	00e78c23          	sb	a4,24(a5)
      i++;
    8000466a:	2905                	addiw	s2,s2,1
    8000466c:	b775                	j	80004618 <pipewrite+0x6c>
    8000466e:	7b02                	ld	s6,32(sp)
    80004670:	6be2                	ld	s7,24(sp)
    80004672:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004674:	21848513          	addi	a0,s1,536
    80004678:	92bfd0ef          	jal	80001fa2 <wakeup>
  release(&pi->lock);
    8000467c:	8526                	mv	a0,s1
    8000467e:	db0fc0ef          	jal	80000c2e <release>
  return i;
    80004682:	bf95                	j	800045f6 <pipewrite+0x4a>
  int i = 0;
    80004684:	4901                	li	s2,0
    80004686:	b7fd                	j	80004674 <pipewrite+0xc8>
    80004688:	7b02                	ld	s6,32(sp)
    8000468a:	6be2                	ld	s7,24(sp)
    8000468c:	6c42                	ld	s8,16(sp)
    8000468e:	b7dd                	j	80004674 <pipewrite+0xc8>

0000000080004690 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004690:	715d                	addi	sp,sp,-80
    80004692:	e486                	sd	ra,72(sp)
    80004694:	e0a2                	sd	s0,64(sp)
    80004696:	fc26                	sd	s1,56(sp)
    80004698:	f84a                	sd	s2,48(sp)
    8000469a:	f44e                	sd	s3,40(sp)
    8000469c:	f052                	sd	s4,32(sp)
    8000469e:	ec56                	sd	s5,24(sp)
    800046a0:	0880                	addi	s0,sp,80
    800046a2:	84aa                	mv	s1,a0
    800046a4:	892e                	mv	s2,a1
    800046a6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800046a8:	9eafd0ef          	jal	80001892 <myproc>
    800046ac:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800046ae:	8526                	mv	a0,s1
    800046b0:	cf2fc0ef          	jal	80000ba2 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800046b4:	2184a703          	lw	a4,536(s1)
    800046b8:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800046bc:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800046c0:	02f71563          	bne	a4,a5,800046ea <piperead+0x5a>
    800046c4:	2244a783          	lw	a5,548(s1)
    800046c8:	cb85                	beqz	a5,800046f8 <piperead+0x68>
    if (killed(pr)) {
    800046ca:	8552                	mv	a0,s4
    800046cc:	ac3fd0ef          	jal	8000218e <killed>
    800046d0:	ed19                	bnez	a0,800046ee <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800046d2:	85a6                	mv	a1,s1
    800046d4:	854e                	mv	a0,s3
    800046d6:	881fd0ef          	jal	80001f56 <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800046da:	2184a703          	lw	a4,536(s1)
    800046de:	21c4a783          	lw	a5,540(s1)
    800046e2:	fef701e3          	beq	a4,a5,800046c4 <piperead+0x34>
    800046e6:	e85a                	sd	s6,16(sp)
    800046e8:	a809                	j	800046fa <piperead+0x6a>
    800046ea:	e85a                	sd	s6,16(sp)
    800046ec:	a039                	j	800046fa <piperead+0x6a>
      release(&pi->lock);
    800046ee:	8526                	mv	a0,s1
    800046f0:	d3efc0ef          	jal	80000c2e <release>
      return -1;
    800046f4:	59fd                	li	s3,-1
    800046f6:	a8b9                	j	80004754 <piperead+0xc4>
    800046f8:	e85a                	sd	s6,16(sp)
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    800046fa:	4981                	li	s3,0
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    800046fc:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    800046fe:	05505363          	blez	s5,80004744 <piperead+0xb4>
    if (pi->nread == pi->nwrite)
    80004702:	2184a783          	lw	a5,536(s1)
    80004706:	21c4a703          	lw	a4,540(s1)
    8000470a:	02f70d63          	beq	a4,a5,80004744 <piperead+0xb4>
    ch = pi->data[pi->nread % PIPESIZE];
    8000470e:	1ff7f793          	andi	a5,a5,511
    80004712:	97a6                	add	a5,a5,s1
    80004714:	0187c783          	lbu	a5,24(a5)
    80004718:	faf40fa3          	sb	a5,-65(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    8000471c:	4685                	li	a3,1
    8000471e:	fbf40613          	addi	a2,s0,-65
    80004722:	85ca                	mv	a1,s2
    80004724:	050a3503          	ld	a0,80(s4)
    80004728:	e7ffc0ef          	jal	800015a6 <copyout>
    8000472c:	03650e63          	beq	a0,s6,80004768 <piperead+0xd8>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80004730:	2184a783          	lw	a5,536(s1)
    80004734:	2785                	addiw	a5,a5,1
    80004736:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    8000473a:	2985                	addiw	s3,s3,1
    8000473c:	0905                	addi	s2,s2,1
    8000473e:	fd3a92e3          	bne	s5,s3,80004702 <piperead+0x72>
    80004742:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    80004744:	21c48513          	addi	a0,s1,540
    80004748:	85bfd0ef          	jal	80001fa2 <wakeup>
  release(&pi->lock);
    8000474c:	8526                	mv	a0,s1
    8000474e:	ce0fc0ef          	jal	80000c2e <release>
    80004752:	6b42                	ld	s6,16(sp)
  return i;
}
    80004754:	854e                	mv	a0,s3
    80004756:	60a6                	ld	ra,72(sp)
    80004758:	6406                	ld	s0,64(sp)
    8000475a:	74e2                	ld	s1,56(sp)
    8000475c:	7942                	ld	s2,48(sp)
    8000475e:	79a2                	ld	s3,40(sp)
    80004760:	7a02                	ld	s4,32(sp)
    80004762:	6ae2                	ld	s5,24(sp)
    80004764:	6161                	addi	sp,sp,80
    80004766:	8082                	ret
      if (i == 0)
    80004768:	fc099ee3          	bnez	s3,80004744 <piperead+0xb4>
        i = -1;
    8000476c:	89aa                	mv	s3,a0
    8000476e:	bfd9                	j	80004744 <piperead+0xb4>

0000000080004770 <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    80004770:	1141                	addi	sp,sp,-16
    80004772:	e422                	sd	s0,8(sp)
    80004774:	0800                	addi	s0,sp,16
    80004776:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    80004778:	8905                	andi	a0,a0,1
    8000477a:	050e                	slli	a0,a0,0x3
    perm = PTE_X;
  if (flags & 0x2)
    8000477c:	8b89                	andi	a5,a5,2
    8000477e:	c399                	beqz	a5,80004784 <flags2perm+0x14>
    perm |= PTE_W;
    80004780:	00456513          	ori	a0,a0,4
  return perm;
}
    80004784:	6422                	ld	s0,8(sp)
    80004786:	0141                	addi	sp,sp,16
    80004788:	8082                	ret

000000008000478a <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    8000478a:	df010113          	addi	sp,sp,-528
    8000478e:	20113423          	sd	ra,520(sp)
    80004792:	20813023          	sd	s0,512(sp)
    80004796:	ffa6                	sd	s1,504(sp)
    80004798:	fbca                	sd	s2,496(sp)
    8000479a:	0c00                	addi	s0,sp,528
    8000479c:	892a                	mv	s2,a0
    8000479e:	dea43c23          	sd	a0,-520(s0)
    800047a2:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800047a6:	8ecfd0ef          	jal	80001892 <myproc>
    800047aa:	84aa                	mv	s1,a0

  begin_op();
    800047ac:	d62ff0ef          	jal	80003d0e <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    800047b0:	854a                	mv	a0,s2
    800047b2:	b88ff0ef          	jal	80003b3a <namei>
    800047b6:	c931                	beqz	a0,8000480a <kexec+0x80>
    800047b8:	f3d2                	sd	s4,480(sp)
    800047ba:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800047bc:	b69fe0ef          	jal	80003324 <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800047c0:	04000713          	li	a4,64
    800047c4:	4681                	li	a3,0
    800047c6:	e5040613          	addi	a2,s0,-432
    800047ca:	4581                	li	a1,0
    800047cc:	8552                	mv	a0,s4
    800047ce:	ee7fe0ef          	jal	800036b4 <readi>
    800047d2:	04000793          	li	a5,64
    800047d6:	00f51a63          	bne	a0,a5,800047ea <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    800047da:	e5042703          	lw	a4,-432(s0)
    800047de:	464c47b7          	lui	a5,0x464c4
    800047e2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800047e6:	02f70663          	beq	a4,a5,80004812 <kexec+0x88>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    800047ea:	8552                	mv	a0,s4
    800047ec:	d43fe0ef          	jal	8000352e <iunlockput>
    end_op();
    800047f0:	d88ff0ef          	jal	80003d78 <end_op>
  }
  return -1;
    800047f4:	557d                	li	a0,-1
    800047f6:	7a1e                	ld	s4,480(sp)
}
    800047f8:	20813083          	ld	ra,520(sp)
    800047fc:	20013403          	ld	s0,512(sp)
    80004800:	74fe                	ld	s1,504(sp)
    80004802:	795e                	ld	s2,496(sp)
    80004804:	21010113          	addi	sp,sp,528
    80004808:	8082                	ret
    end_op();
    8000480a:	d6eff0ef          	jal	80003d78 <end_op>
    return -1;
    8000480e:	557d                	li	a0,-1
    80004810:	b7e5                	j	800047f8 <kexec+0x6e>
    80004812:	ebda                	sd	s6,464(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    80004814:	8526                	mv	a0,s1
    80004816:	9ecfd0ef          	jal	80001a02 <proc_pagetable>
    8000481a:	8b2a                	mv	s6,a0
    8000481c:	2c050b63          	beqz	a0,80004af2 <kexec+0x368>
    80004820:	f7ce                	sd	s3,488(sp)
    80004822:	efd6                	sd	s5,472(sp)
    80004824:	e7de                	sd	s7,456(sp)
    80004826:	e3e2                	sd	s8,448(sp)
    80004828:	ff66                	sd	s9,440(sp)
    8000482a:	fb6a                	sd	s10,432(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000482c:	e7042d03          	lw	s10,-400(s0)
    80004830:	e8845783          	lhu	a5,-376(s0)
    80004834:	12078963          	beqz	a5,80004966 <kexec+0x1dc>
    80004838:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000483a:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000483c:	4d81                	li	s11,0
    if (ph.vaddr % PGSIZE != 0)
    8000483e:	6c85                	lui	s9,0x1
    80004840:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004844:	def43823          	sd	a5,-528(s0)

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    80004848:	6a85                	lui	s5,0x1
    8000484a:	a085                	j	800048aa <kexec+0x120>
      panic("loadseg: address should exist");
    8000484c:	00003517          	auipc	a0,0x3
    80004850:	d5450513          	addi	a0,a0,-684 # 800075a0 <etext+0x5a0>
    80004854:	f81fb0ef          	jal	800007d4 <panic>
    if (sz - i < PGSIZE)
    80004858:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    8000485a:	8726                	mv	a4,s1
    8000485c:	012c06bb          	addw	a3,s8,s2
    80004860:	4581                	li	a1,0
    80004862:	8552                	mv	a0,s4
    80004864:	e51fe0ef          	jal	800036b4 <readi>
    80004868:	2501                	sext.w	a0,a0
    8000486a:	24a49a63          	bne	s1,a0,80004abe <kexec+0x334>
  for (i = 0; i < sz; i += PGSIZE) {
    8000486e:	012a893b          	addw	s2,s5,s2
    80004872:	03397363          	bgeu	s2,s3,80004898 <kexec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004876:	02091593          	slli	a1,s2,0x20
    8000487a:	9181                	srli	a1,a1,0x20
    8000487c:	95de                	add	a1,a1,s7
    8000487e:	855a                	mv	a0,s6
    80004880:	ef4fc0ef          	jal	80000f74 <walkaddr>
    80004884:	862a                	mv	a2,a0
    if (pa == 0)
    80004886:	d179                	beqz	a0,8000484c <kexec+0xc2>
    if (sz - i < PGSIZE)
    80004888:	412984bb          	subw	s1,s3,s2
    8000488c:	0004879b          	sext.w	a5,s1
    80004890:	fcfcf4e3          	bgeu	s9,a5,80004858 <kexec+0xce>
    80004894:	84d6                	mv	s1,s5
    80004896:	b7c9                	j	80004858 <kexec+0xce>
    sz = sz1;
    80004898:	e0843903          	ld	s2,-504(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000489c:	2d85                	addiw	s11,s11,1
    8000489e:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800048a2:	e8845783          	lhu	a5,-376(s0)
    800048a6:	08fdd063          	bge	s11,a5,80004926 <kexec+0x19c>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800048aa:	2d01                	sext.w	s10,s10
    800048ac:	03800713          	li	a4,56
    800048b0:	86ea                	mv	a3,s10
    800048b2:	e1840613          	addi	a2,s0,-488
    800048b6:	4581                	li	a1,0
    800048b8:	8552                	mv	a0,s4
    800048ba:	dfbfe0ef          	jal	800036b4 <readi>
    800048be:	03800793          	li	a5,56
    800048c2:	1cf51663          	bne	a0,a5,80004a8e <kexec+0x304>
    if (ph.type != ELF_PROG_LOAD)
    800048c6:	e1842783          	lw	a5,-488(s0)
    800048ca:	4705                	li	a4,1
    800048cc:	fce798e3          	bne	a5,a4,8000489c <kexec+0x112>
    if (ph.memsz < ph.filesz)
    800048d0:	e4043483          	ld	s1,-448(s0)
    800048d4:	e3843783          	ld	a5,-456(s0)
    800048d8:	1af4ef63          	bltu	s1,a5,80004a96 <kexec+0x30c>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    800048dc:	e2843783          	ld	a5,-472(s0)
    800048e0:	94be                	add	s1,s1,a5
    800048e2:	1af4ee63          	bltu	s1,a5,80004a9e <kexec+0x314>
    if (ph.vaddr % PGSIZE != 0)
    800048e6:	df043703          	ld	a4,-528(s0)
    800048ea:	8ff9                	and	a5,a5,a4
    800048ec:	1a079d63          	bnez	a5,80004aa6 <kexec+0x31c>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    800048f0:	e1c42503          	lw	a0,-484(s0)
    800048f4:	e7dff0ef          	jal	80004770 <flags2perm>
    800048f8:	86aa                	mv	a3,a0
    800048fa:	8626                	mv	a2,s1
    800048fc:	85ca                	mv	a1,s2
    800048fe:	855a                	mv	a0,s6
    80004900:	94dfc0ef          	jal	8000124c <uvmalloc>
    80004904:	e0a43423          	sd	a0,-504(s0)
    80004908:	1a050363          	beqz	a0,80004aae <kexec+0x324>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000490c:	e2843b83          	ld	s7,-472(s0)
    80004910:	e2042c03          	lw	s8,-480(s0)
    80004914:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004918:	00098463          	beqz	s3,80004920 <kexec+0x196>
    8000491c:	4901                	li	s2,0
    8000491e:	bfa1                	j	80004876 <kexec+0xec>
    sz = sz1;
    80004920:	e0843903          	ld	s2,-504(s0)
    80004924:	bfa5                	j	8000489c <kexec+0x112>
    80004926:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004928:	8552                	mv	a0,s4
    8000492a:	c05fe0ef          	jal	8000352e <iunlockput>
  end_op();
    8000492e:	c4aff0ef          	jal	80003d78 <end_op>
  p = myproc();
    80004932:	f61fc0ef          	jal	80001892 <myproc>
    80004936:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004938:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000493c:	6985                	lui	s3,0x1
    8000493e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004940:	99ca                	add	s3,s3,s2
    80004942:	77fd                	lui	a5,0xfffff
    80004944:	00f9f9b3          	and	s3,s3,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    80004948:	4691                	li	a3,4
    8000494a:	6609                	lui	a2,0x2
    8000494c:	964e                	add	a2,a2,s3
    8000494e:	85ce                	mv	a1,s3
    80004950:	855a                	mv	a0,s6
    80004952:	8fbfc0ef          	jal	8000124c <uvmalloc>
    80004956:	892a                	mv	s2,a0
    80004958:	e0a43423          	sd	a0,-504(s0)
    8000495c:	e519                	bnez	a0,8000496a <kexec+0x1e0>
  if (pagetable)
    8000495e:	e1343423          	sd	s3,-504(s0)
    80004962:	4a01                	li	s4,0
    80004964:	aab1                	j	80004ac0 <kexec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004966:	4901                	li	s2,0
    80004968:	b7c1                	j	80004928 <kexec+0x19e>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    8000496a:	75f9                	lui	a1,0xffffe
    8000496c:	95aa                	add	a1,a1,a0
    8000496e:	855a                	mv	a0,s6
    80004970:	ab3fc0ef          	jal	80001422 <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    80004974:	7bfd                	lui	s7,0xfffff
    80004976:	9bca                	add	s7,s7,s2
  for (argc = 0; argv[argc]; argc++) {
    80004978:	e0043783          	ld	a5,-512(s0)
    8000497c:	6388                	ld	a0,0(a5)
    8000497e:	cd39                	beqz	a0,800049dc <kexec+0x252>
    80004980:	e9040993          	addi	s3,s0,-368
    80004984:	f9040c13          	addi	s8,s0,-112
    80004988:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000498a:	c4cfc0ef          	jal	80000dd6 <strlen>
    8000498e:	0015079b          	addiw	a5,a0,1
    80004992:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004996:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase)
    8000499a:	11796e63          	bltu	s2,s7,80004ab6 <kexec+0x32c>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000499e:	e0043d03          	ld	s10,-512(s0)
    800049a2:	000d3a03          	ld	s4,0(s10)
    800049a6:	8552                	mv	a0,s4
    800049a8:	c2efc0ef          	jal	80000dd6 <strlen>
    800049ac:	0015069b          	addiw	a3,a0,1
    800049b0:	8652                	mv	a2,s4
    800049b2:	85ca                	mv	a1,s2
    800049b4:	855a                	mv	a0,s6
    800049b6:	bf1fc0ef          	jal	800015a6 <copyout>
    800049ba:	10054063          	bltz	a0,80004aba <kexec+0x330>
    ustack[argc] = sp;
    800049be:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    800049c2:	0485                	addi	s1,s1,1
    800049c4:	008d0793          	addi	a5,s10,8
    800049c8:	e0f43023          	sd	a5,-512(s0)
    800049cc:	008d3503          	ld	a0,8(s10)
    800049d0:	c909                	beqz	a0,800049e2 <kexec+0x258>
    if (argc >= MAXARG)
    800049d2:	09a1                	addi	s3,s3,8
    800049d4:	fb899be3          	bne	s3,s8,8000498a <kexec+0x200>
  ip = 0;
    800049d8:	4a01                	li	s4,0
    800049da:	a0dd                	j	80004ac0 <kexec+0x336>
  sp = sz;
    800049dc:	e0843903          	ld	s2,-504(s0)
  for (argc = 0; argv[argc]; argc++) {
    800049e0:	4481                	li	s1,0
  ustack[argc] = 0;
    800049e2:	00349793          	slli	a5,s1,0x3
    800049e6:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb3e8>
    800049ea:	97a2                	add	a5,a5,s0
    800049ec:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    800049f0:	00148693          	addi	a3,s1,1
    800049f4:	068e                	slli	a3,a3,0x3
    800049f6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800049fa:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800049fe:	e0843983          	ld	s3,-504(s0)
  if (sp < stackbase)
    80004a02:	f5796ee3          	bltu	s2,s7,8000495e <kexec+0x1d4>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    80004a06:	e9040613          	addi	a2,s0,-368
    80004a0a:	85ca                	mv	a1,s2
    80004a0c:	855a                	mv	a0,s6
    80004a0e:	b99fc0ef          	jal	800015a6 <copyout>
    80004a12:	0e054263          	bltz	a0,80004af6 <kexec+0x36c>
  p->trapframe->a1 = sp;
    80004a16:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004a1a:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80004a1e:	df843783          	ld	a5,-520(s0)
    80004a22:	0007c703          	lbu	a4,0(a5)
    80004a26:	cf11                	beqz	a4,80004a42 <kexec+0x2b8>
    80004a28:	0785                	addi	a5,a5,1
    if (*s == '/')
    80004a2a:	02f00693          	li	a3,47
    80004a2e:	a039                	j	80004a3c <kexec+0x2b2>
      last = s + 1;
    80004a30:	def43c23          	sd	a5,-520(s0)
  for (last = s = path; *s; s++)
    80004a34:	0785                	addi	a5,a5,1
    80004a36:	fff7c703          	lbu	a4,-1(a5)
    80004a3a:	c701                	beqz	a4,80004a42 <kexec+0x2b8>
    if (*s == '/')
    80004a3c:	fed71ce3          	bne	a4,a3,80004a34 <kexec+0x2aa>
    80004a40:	bfc5                	j	80004a30 <kexec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004a42:	4641                	li	a2,16
    80004a44:	df843583          	ld	a1,-520(s0)
    80004a48:	158a8513          	addi	a0,s5,344
    80004a4c:	b58fc0ef          	jal	80000da4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004a50:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004a54:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004a58:	e0843783          	ld	a5,-504(s0)
    80004a5c:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    80004a60:	058ab783          	ld	a5,88(s5)
    80004a64:	e6843703          	ld	a4,-408(s0)
    80004a68:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80004a6a:	058ab783          	ld	a5,88(s5)
    80004a6e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004a72:	85e6                	mv	a1,s9
    80004a74:	812fd0ef          	jal	80001a86 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004a78:	0004851b          	sext.w	a0,s1
    80004a7c:	79be                	ld	s3,488(sp)
    80004a7e:	7a1e                	ld	s4,480(sp)
    80004a80:	6afe                	ld	s5,472(sp)
    80004a82:	6b5e                	ld	s6,464(sp)
    80004a84:	6bbe                	ld	s7,456(sp)
    80004a86:	6c1e                	ld	s8,448(sp)
    80004a88:	7cfa                	ld	s9,440(sp)
    80004a8a:	7d5a                	ld	s10,432(sp)
    80004a8c:	b3b5                	j	800047f8 <kexec+0x6e>
    80004a8e:	e1243423          	sd	s2,-504(s0)
    80004a92:	7dba                	ld	s11,424(sp)
    80004a94:	a035                	j	80004ac0 <kexec+0x336>
    80004a96:	e1243423          	sd	s2,-504(s0)
    80004a9a:	7dba                	ld	s11,424(sp)
    80004a9c:	a015                	j	80004ac0 <kexec+0x336>
    80004a9e:	e1243423          	sd	s2,-504(s0)
    80004aa2:	7dba                	ld	s11,424(sp)
    80004aa4:	a831                	j	80004ac0 <kexec+0x336>
    80004aa6:	e1243423          	sd	s2,-504(s0)
    80004aaa:	7dba                	ld	s11,424(sp)
    80004aac:	a811                	j	80004ac0 <kexec+0x336>
    80004aae:	e1243423          	sd	s2,-504(s0)
    80004ab2:	7dba                	ld	s11,424(sp)
    80004ab4:	a031                	j	80004ac0 <kexec+0x336>
  ip = 0;
    80004ab6:	4a01                	li	s4,0
    80004ab8:	a021                	j	80004ac0 <kexec+0x336>
    80004aba:	4a01                	li	s4,0
  if (pagetable)
    80004abc:	a011                	j	80004ac0 <kexec+0x336>
    80004abe:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004ac0:	e0843583          	ld	a1,-504(s0)
    80004ac4:	855a                	mv	a0,s6
    80004ac6:	fc1fc0ef          	jal	80001a86 <proc_freepagetable>
  return -1;
    80004aca:	557d                	li	a0,-1
  if (ip) {
    80004acc:	000a1b63          	bnez	s4,80004ae2 <kexec+0x358>
    80004ad0:	79be                	ld	s3,488(sp)
    80004ad2:	7a1e                	ld	s4,480(sp)
    80004ad4:	6afe                	ld	s5,472(sp)
    80004ad6:	6b5e                	ld	s6,464(sp)
    80004ad8:	6bbe                	ld	s7,456(sp)
    80004ada:	6c1e                	ld	s8,448(sp)
    80004adc:	7cfa                	ld	s9,440(sp)
    80004ade:	7d5a                	ld	s10,432(sp)
    80004ae0:	bb21                	j	800047f8 <kexec+0x6e>
    80004ae2:	79be                	ld	s3,488(sp)
    80004ae4:	6afe                	ld	s5,472(sp)
    80004ae6:	6b5e                	ld	s6,464(sp)
    80004ae8:	6bbe                	ld	s7,456(sp)
    80004aea:	6c1e                	ld	s8,448(sp)
    80004aec:	7cfa                	ld	s9,440(sp)
    80004aee:	7d5a                	ld	s10,432(sp)
    80004af0:	b9ed                	j	800047ea <kexec+0x60>
    80004af2:	6b5e                	ld	s6,464(sp)
    80004af4:	b9dd                	j	800047ea <kexec+0x60>
  sz = sz1;
    80004af6:	e0843983          	ld	s3,-504(s0)
    80004afa:	b595                	j	8000495e <kexec+0x1d4>

0000000080004afc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004afc:	7179                	addi	sp,sp,-48
    80004afe:	f406                	sd	ra,40(sp)
    80004b00:	f022                	sd	s0,32(sp)
    80004b02:	ec26                	sd	s1,24(sp)
    80004b04:	e84a                	sd	s2,16(sp)
    80004b06:	1800                	addi	s0,sp,48
    80004b08:	892e                	mv	s2,a1
    80004b0a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004b0c:	fdc40593          	addi	a1,s0,-36
    80004b10:	d41fd0ef          	jal	80002850 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004b14:	fdc42703          	lw	a4,-36(s0)
    80004b18:	47bd                	li	a5,15
    80004b1a:	02e7e963          	bltu	a5,a4,80004b4c <argfd+0x50>
    80004b1e:	d75fc0ef          	jal	80001892 <myproc>
    80004b22:	fdc42703          	lw	a4,-36(s0)
    80004b26:	01a70793          	addi	a5,a4,26
    80004b2a:	078e                	slli	a5,a5,0x3
    80004b2c:	953e                	add	a0,a0,a5
    80004b2e:	611c                	ld	a5,0(a0)
    80004b30:	c385                	beqz	a5,80004b50 <argfd+0x54>
    return -1;
  if (pfd)
    80004b32:	00090463          	beqz	s2,80004b3a <argfd+0x3e>
    *pfd = fd;
    80004b36:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80004b3a:	4501                	li	a0,0
  if (pf)
    80004b3c:	c091                	beqz	s1,80004b40 <argfd+0x44>
    *pf = f;
    80004b3e:	e09c                	sd	a5,0(s1)
}
    80004b40:	70a2                	ld	ra,40(sp)
    80004b42:	7402                	ld	s0,32(sp)
    80004b44:	64e2                	ld	s1,24(sp)
    80004b46:	6942                	ld	s2,16(sp)
    80004b48:	6145                	addi	sp,sp,48
    80004b4a:	8082                	ret
    return -1;
    80004b4c:	557d                	li	a0,-1
    80004b4e:	bfcd                	j	80004b40 <argfd+0x44>
    80004b50:	557d                	li	a0,-1
    80004b52:	b7fd                	j	80004b40 <argfd+0x44>

0000000080004b54 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004b54:	1101                	addi	sp,sp,-32
    80004b56:	ec06                	sd	ra,24(sp)
    80004b58:	e822                	sd	s0,16(sp)
    80004b5a:	e426                	sd	s1,8(sp)
    80004b5c:	1000                	addi	s0,sp,32
    80004b5e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004b60:	d33fc0ef          	jal	80001892 <myproc>
    80004b64:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004b66:	0d050793          	addi	a5,a0,208
    80004b6a:	4501                	li	a0,0
    80004b6c:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80004b6e:	6398                	ld	a4,0(a5)
    80004b70:	cb19                	beqz	a4,80004b86 <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    80004b72:	2505                	addiw	a0,a0,1
    80004b74:	07a1                	addi	a5,a5,8
    80004b76:	fed51ce3          	bne	a0,a3,80004b6e <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004b7a:	557d                	li	a0,-1
}
    80004b7c:	60e2                	ld	ra,24(sp)
    80004b7e:	6442                	ld	s0,16(sp)
    80004b80:	64a2                	ld	s1,8(sp)
    80004b82:	6105                	addi	sp,sp,32
    80004b84:	8082                	ret
      p->ofile[fd] = f;
    80004b86:	01a50793          	addi	a5,a0,26
    80004b8a:	078e                	slli	a5,a5,0x3
    80004b8c:	963e                	add	a2,a2,a5
    80004b8e:	e204                	sd	s1,0(a2)
      return fd;
    80004b90:	b7f5                	j	80004b7c <fdalloc+0x28>

0000000080004b92 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004b92:	715d                	addi	sp,sp,-80
    80004b94:	e486                	sd	ra,72(sp)
    80004b96:	e0a2                	sd	s0,64(sp)
    80004b98:	fc26                	sd	s1,56(sp)
    80004b9a:	f84a                	sd	s2,48(sp)
    80004b9c:	f44e                	sd	s3,40(sp)
    80004b9e:	ec56                	sd	s5,24(sp)
    80004ba0:	e85a                	sd	s6,16(sp)
    80004ba2:	0880                	addi	s0,sp,80
    80004ba4:	8b2e                	mv	s6,a1
    80004ba6:	89b2                	mv	s3,a2
    80004ba8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004baa:	fb040593          	addi	a1,s0,-80
    80004bae:	fa7fe0ef          	jal	80003b54 <nameiparent>
    80004bb2:	84aa                	mv	s1,a0
    80004bb4:	10050a63          	beqz	a0,80004cc8 <create+0x136>
    return 0;

  ilock(dp);
    80004bb8:	f6cfe0ef          	jal	80003324 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004bbc:	4601                	li	a2,0
    80004bbe:	fb040593          	addi	a1,s0,-80
    80004bc2:	8526                	mv	a0,s1
    80004bc4:	d11fe0ef          	jal	800038d4 <dirlookup>
    80004bc8:	8aaa                	mv	s5,a0
    80004bca:	c129                	beqz	a0,80004c0c <create+0x7a>
    iunlockput(dp);
    80004bcc:	8526                	mv	a0,s1
    80004bce:	961fe0ef          	jal	8000352e <iunlockput>
    ilock(ip);
    80004bd2:	8556                	mv	a0,s5
    80004bd4:	f50fe0ef          	jal	80003324 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004bd8:	4789                	li	a5,2
    80004bda:	02fb1463          	bne	s6,a5,80004c02 <create+0x70>
    80004bde:	044ad783          	lhu	a5,68(s5)
    80004be2:	37f9                	addiw	a5,a5,-2
    80004be4:	17c2                	slli	a5,a5,0x30
    80004be6:	93c1                	srli	a5,a5,0x30
    80004be8:	4705                	li	a4,1
    80004bea:	00f76c63          	bltu	a4,a5,80004c02 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004bee:	8556                	mv	a0,s5
    80004bf0:	60a6                	ld	ra,72(sp)
    80004bf2:	6406                	ld	s0,64(sp)
    80004bf4:	74e2                	ld	s1,56(sp)
    80004bf6:	7942                	ld	s2,48(sp)
    80004bf8:	79a2                	ld	s3,40(sp)
    80004bfa:	6ae2                	ld	s5,24(sp)
    80004bfc:	6b42                	ld	s6,16(sp)
    80004bfe:	6161                	addi	sp,sp,80
    80004c00:	8082                	ret
    iunlockput(ip);
    80004c02:	8556                	mv	a0,s5
    80004c04:	92bfe0ef          	jal	8000352e <iunlockput>
    return 0;
    80004c08:	4a81                	li	s5,0
    80004c0a:	b7d5                	j	80004bee <create+0x5c>
    80004c0c:	f052                	sd	s4,32(sp)
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004c0e:	85da                	mv	a1,s6
    80004c10:	4088                	lw	a0,0(s1)
    80004c12:	da2fe0ef          	jal	800031b4 <ialloc>
    80004c16:	8a2a                	mv	s4,a0
    80004c18:	cd15                	beqz	a0,80004c54 <create+0xc2>
  ilock(ip);
    80004c1a:	f0afe0ef          	jal	80003324 <ilock>
  ip->major = major;
    80004c1e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004c22:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004c26:	4905                	li	s2,1
    80004c28:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004c2c:	8552                	mv	a0,s4
    80004c2e:	e42fe0ef          	jal	80003270 <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    80004c32:	032b0763          	beq	s6,s2,80004c60 <create+0xce>
  if (dirlink(dp, name, ip->inum) < 0)
    80004c36:	004a2603          	lw	a2,4(s4)
    80004c3a:	fb040593          	addi	a1,s0,-80
    80004c3e:	8526                	mv	a0,s1
    80004c40:	e61fe0ef          	jal	80003aa0 <dirlink>
    80004c44:	06054563          	bltz	a0,80004cae <create+0x11c>
  iunlockput(dp);
    80004c48:	8526                	mv	a0,s1
    80004c4a:	8e5fe0ef          	jal	8000352e <iunlockput>
  return ip;
    80004c4e:	8ad2                	mv	s5,s4
    80004c50:	7a02                	ld	s4,32(sp)
    80004c52:	bf71                	j	80004bee <create+0x5c>
    iunlockput(dp);
    80004c54:	8526                	mv	a0,s1
    80004c56:	8d9fe0ef          	jal	8000352e <iunlockput>
    return 0;
    80004c5a:	8ad2                	mv	s5,s4
    80004c5c:	7a02                	ld	s4,32(sp)
    80004c5e:	bf41                	j	80004bee <create+0x5c>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004c60:	004a2603          	lw	a2,4(s4)
    80004c64:	00003597          	auipc	a1,0x3
    80004c68:	95c58593          	addi	a1,a1,-1700 # 800075c0 <etext+0x5c0>
    80004c6c:	8552                	mv	a0,s4
    80004c6e:	e33fe0ef          	jal	80003aa0 <dirlink>
    80004c72:	02054e63          	bltz	a0,80004cae <create+0x11c>
    80004c76:	40d0                	lw	a2,4(s1)
    80004c78:	00003597          	auipc	a1,0x3
    80004c7c:	95058593          	addi	a1,a1,-1712 # 800075c8 <etext+0x5c8>
    80004c80:	8552                	mv	a0,s4
    80004c82:	e1ffe0ef          	jal	80003aa0 <dirlink>
    80004c86:	02054463          	bltz	a0,80004cae <create+0x11c>
  if (dirlink(dp, name, ip->inum) < 0)
    80004c8a:	004a2603          	lw	a2,4(s4)
    80004c8e:	fb040593          	addi	a1,s0,-80
    80004c92:	8526                	mv	a0,s1
    80004c94:	e0dfe0ef          	jal	80003aa0 <dirlink>
    80004c98:	00054b63          	bltz	a0,80004cae <create+0x11c>
    dp->nlink++; // for ".."
    80004c9c:	04a4d783          	lhu	a5,74(s1)
    80004ca0:	2785                	addiw	a5,a5,1
    80004ca2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ca6:	8526                	mv	a0,s1
    80004ca8:	dc8fe0ef          	jal	80003270 <iupdate>
    80004cac:	bf71                	j	80004c48 <create+0xb6>
  ip->nlink = 0;
    80004cae:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004cb2:	8552                	mv	a0,s4
    80004cb4:	dbcfe0ef          	jal	80003270 <iupdate>
  iunlockput(ip);
    80004cb8:	8552                	mv	a0,s4
    80004cba:	875fe0ef          	jal	8000352e <iunlockput>
  iunlockput(dp);
    80004cbe:	8526                	mv	a0,s1
    80004cc0:	86ffe0ef          	jal	8000352e <iunlockput>
  return 0;
    80004cc4:	7a02                	ld	s4,32(sp)
    80004cc6:	b725                	j	80004bee <create+0x5c>
    return 0;
    80004cc8:	8aaa                	mv	s5,a0
    80004cca:	b715                	j	80004bee <create+0x5c>

0000000080004ccc <sys_dup>:
{
    80004ccc:	7179                	addi	sp,sp,-48
    80004cce:	f406                	sd	ra,40(sp)
    80004cd0:	f022                	sd	s0,32(sp)
    80004cd2:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80004cd4:	fd840613          	addi	a2,s0,-40
    80004cd8:	4581                	li	a1,0
    80004cda:	4501                	li	a0,0
    80004cdc:	e21ff0ef          	jal	80004afc <argfd>
    return -1;
    80004ce0:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80004ce2:	02054363          	bltz	a0,80004d08 <sys_dup+0x3c>
    80004ce6:	ec26                	sd	s1,24(sp)
    80004ce8:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    80004cea:	fd843903          	ld	s2,-40(s0)
    80004cee:	854a                	mv	a0,s2
    80004cf0:	e65ff0ef          	jal	80004b54 <fdalloc>
    80004cf4:	84aa                	mv	s1,a0
    return -1;
    80004cf6:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    80004cf8:	00054d63          	bltz	a0,80004d12 <sys_dup+0x46>
  filedup(f);
    80004cfc:	854a                	mv	a0,s2
    80004cfe:	c3eff0ef          	jal	8000413c <filedup>
  return fd;
    80004d02:	87a6                	mv	a5,s1
    80004d04:	64e2                	ld	s1,24(sp)
    80004d06:	6942                	ld	s2,16(sp)
}
    80004d08:	853e                	mv	a0,a5
    80004d0a:	70a2                	ld	ra,40(sp)
    80004d0c:	7402                	ld	s0,32(sp)
    80004d0e:	6145                	addi	sp,sp,48
    80004d10:	8082                	ret
    80004d12:	64e2                	ld	s1,24(sp)
    80004d14:	6942                	ld	s2,16(sp)
    80004d16:	bfcd                	j	80004d08 <sys_dup+0x3c>

0000000080004d18 <sys_read>:
{
    80004d18:	7179                	addi	sp,sp,-48
    80004d1a:	f406                	sd	ra,40(sp)
    80004d1c:	f022                	sd	s0,32(sp)
    80004d1e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004d20:	fd840593          	addi	a1,s0,-40
    80004d24:	4505                	li	a0,1
    80004d26:	b47fd0ef          	jal	8000286c <argaddr>
  argint(2, &n);
    80004d2a:	fe440593          	addi	a1,s0,-28
    80004d2e:	4509                	li	a0,2
    80004d30:	b21fd0ef          	jal	80002850 <argint>
  if (argfd(0, 0, &f) < 0)
    80004d34:	fe840613          	addi	a2,s0,-24
    80004d38:	4581                	li	a1,0
    80004d3a:	4501                	li	a0,0
    80004d3c:	dc1ff0ef          	jal	80004afc <argfd>
    80004d40:	87aa                	mv	a5,a0
    return -1;
    80004d42:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004d44:	0007ca63          	bltz	a5,80004d58 <sys_read+0x40>
  return fileread(f, p, n);
    80004d48:	fe442603          	lw	a2,-28(s0)
    80004d4c:	fd843583          	ld	a1,-40(s0)
    80004d50:	fe843503          	ld	a0,-24(s0)
    80004d54:	d4eff0ef          	jal	800042a2 <fileread>
}
    80004d58:	70a2                	ld	ra,40(sp)
    80004d5a:	7402                	ld	s0,32(sp)
    80004d5c:	6145                	addi	sp,sp,48
    80004d5e:	8082                	ret

0000000080004d60 <sys_write>:
{
    80004d60:	7179                	addi	sp,sp,-48
    80004d62:	f406                	sd	ra,40(sp)
    80004d64:	f022                	sd	s0,32(sp)
    80004d66:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004d68:	fd840593          	addi	a1,s0,-40
    80004d6c:	4505                	li	a0,1
    80004d6e:	afffd0ef          	jal	8000286c <argaddr>
  argint(2, &n);
    80004d72:	fe440593          	addi	a1,s0,-28
    80004d76:	4509                	li	a0,2
    80004d78:	ad9fd0ef          	jal	80002850 <argint>
  if (argfd(0, 0, &f) < 0)
    80004d7c:	fe840613          	addi	a2,s0,-24
    80004d80:	4581                	li	a1,0
    80004d82:	4501                	li	a0,0
    80004d84:	d79ff0ef          	jal	80004afc <argfd>
    80004d88:	87aa                	mv	a5,a0
    return -1;
    80004d8a:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004d8c:	0007ca63          	bltz	a5,80004da0 <sys_write+0x40>
  return filewrite(f, p, n);
    80004d90:	fe442603          	lw	a2,-28(s0)
    80004d94:	fd843583          	ld	a1,-40(s0)
    80004d98:	fe843503          	ld	a0,-24(s0)
    80004d9c:	dc4ff0ef          	jal	80004360 <filewrite>
}
    80004da0:	70a2                	ld	ra,40(sp)
    80004da2:	7402                	ld	s0,32(sp)
    80004da4:	6145                	addi	sp,sp,48
    80004da6:	8082                	ret

0000000080004da8 <sys_close>:
{
    80004da8:	1101                	addi	sp,sp,-32
    80004daa:	ec06                	sd	ra,24(sp)
    80004dac:	e822                	sd	s0,16(sp)
    80004dae:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80004db0:	fe040613          	addi	a2,s0,-32
    80004db4:	fec40593          	addi	a1,s0,-20
    80004db8:	4501                	li	a0,0
    80004dba:	d43ff0ef          	jal	80004afc <argfd>
    return -1;
    80004dbe:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80004dc0:	02054063          	bltz	a0,80004de0 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004dc4:	acffc0ef          	jal	80001892 <myproc>
    80004dc8:	fec42783          	lw	a5,-20(s0)
    80004dcc:	07e9                	addi	a5,a5,26
    80004dce:	078e                	slli	a5,a5,0x3
    80004dd0:	953e                	add	a0,a0,a5
    80004dd2:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004dd6:	fe043503          	ld	a0,-32(s0)
    80004dda:	ba8ff0ef          	jal	80004182 <fileclose>
  return 0;
    80004dde:	4781                	li	a5,0
}
    80004de0:	853e                	mv	a0,a5
    80004de2:	60e2                	ld	ra,24(sp)
    80004de4:	6442                	ld	s0,16(sp)
    80004de6:	6105                	addi	sp,sp,32
    80004de8:	8082                	ret

0000000080004dea <sys_fstat>:
{
    80004dea:	1101                	addi	sp,sp,-32
    80004dec:	ec06                	sd	ra,24(sp)
    80004dee:	e822                	sd	s0,16(sp)
    80004df0:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004df2:	fe040593          	addi	a1,s0,-32
    80004df6:	4505                	li	a0,1
    80004df8:	a75fd0ef          	jal	8000286c <argaddr>
  if (argfd(0, 0, &f) < 0)
    80004dfc:	fe840613          	addi	a2,s0,-24
    80004e00:	4581                	li	a1,0
    80004e02:	4501                	li	a0,0
    80004e04:	cf9ff0ef          	jal	80004afc <argfd>
    80004e08:	87aa                	mv	a5,a0
    return -1;
    80004e0a:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004e0c:	0007c863          	bltz	a5,80004e1c <sys_fstat+0x32>
  return filestat(f, st);
    80004e10:	fe043583          	ld	a1,-32(s0)
    80004e14:	fe843503          	ld	a0,-24(s0)
    80004e18:	c2cff0ef          	jal	80004244 <filestat>
}
    80004e1c:	60e2                	ld	ra,24(sp)
    80004e1e:	6442                	ld	s0,16(sp)
    80004e20:	6105                	addi	sp,sp,32
    80004e22:	8082                	ret

0000000080004e24 <sys_link>:
{
    80004e24:	7169                	addi	sp,sp,-304
    80004e26:	f606                	sd	ra,296(sp)
    80004e28:	f222                	sd	s0,288(sp)
    80004e2a:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e2c:	08000613          	li	a2,128
    80004e30:	ed040593          	addi	a1,s0,-304
    80004e34:	4501                	li	a0,0
    80004e36:	a53fd0ef          	jal	80002888 <argstr>
    return -1;
    80004e3a:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e3c:	0c054e63          	bltz	a0,80004f18 <sys_link+0xf4>
    80004e40:	08000613          	li	a2,128
    80004e44:	f5040593          	addi	a1,s0,-176
    80004e48:	4505                	li	a0,1
    80004e4a:	a3ffd0ef          	jal	80002888 <argstr>
    return -1;
    80004e4e:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e50:	0c054463          	bltz	a0,80004f18 <sys_link+0xf4>
    80004e54:	ee26                	sd	s1,280(sp)
  begin_op();
    80004e56:	eb9fe0ef          	jal	80003d0e <begin_op>
  if ((ip = namei(old)) == 0) {
    80004e5a:	ed040513          	addi	a0,s0,-304
    80004e5e:	cddfe0ef          	jal	80003b3a <namei>
    80004e62:	84aa                	mv	s1,a0
    80004e64:	c53d                	beqz	a0,80004ed2 <sys_link+0xae>
  ilock(ip);
    80004e66:	cbefe0ef          	jal	80003324 <ilock>
  if (ip->type == T_DIR) {
    80004e6a:	04449703          	lh	a4,68(s1)
    80004e6e:	4785                	li	a5,1
    80004e70:	06f70663          	beq	a4,a5,80004edc <sys_link+0xb8>
    80004e74:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004e76:	04a4d783          	lhu	a5,74(s1)
    80004e7a:	2785                	addiw	a5,a5,1
    80004e7c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004e80:	8526                	mv	a0,s1
    80004e82:	beefe0ef          	jal	80003270 <iupdate>
  iunlock(ip);
    80004e86:	8526                	mv	a0,s1
    80004e88:	d4afe0ef          	jal	800033d2 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80004e8c:	fd040593          	addi	a1,s0,-48
    80004e90:	f5040513          	addi	a0,s0,-176
    80004e94:	cc1fe0ef          	jal	80003b54 <nameiparent>
    80004e98:	892a                	mv	s2,a0
    80004e9a:	cd21                	beqz	a0,80004ef2 <sys_link+0xce>
  ilock(dp);
    80004e9c:	c88fe0ef          	jal	80003324 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004ea0:	00092703          	lw	a4,0(s2)
    80004ea4:	409c                	lw	a5,0(s1)
    80004ea6:	04f71363          	bne	a4,a5,80004eec <sys_link+0xc8>
    80004eaa:	40d0                	lw	a2,4(s1)
    80004eac:	fd040593          	addi	a1,s0,-48
    80004eb0:	854a                	mv	a0,s2
    80004eb2:	beffe0ef          	jal	80003aa0 <dirlink>
    80004eb6:	02054b63          	bltz	a0,80004eec <sys_link+0xc8>
  iunlockput(dp);
    80004eba:	854a                	mv	a0,s2
    80004ebc:	e72fe0ef          	jal	8000352e <iunlockput>
  iput(ip);
    80004ec0:	8526                	mv	a0,s1
    80004ec2:	de4fe0ef          	jal	800034a6 <iput>
  end_op();
    80004ec6:	eb3fe0ef          	jal	80003d78 <end_op>
  return 0;
    80004eca:	4781                	li	a5,0
    80004ecc:	64f2                	ld	s1,280(sp)
    80004ece:	6952                	ld	s2,272(sp)
    80004ed0:	a0a1                	j	80004f18 <sys_link+0xf4>
    end_op();
    80004ed2:	ea7fe0ef          	jal	80003d78 <end_op>
    return -1;
    80004ed6:	57fd                	li	a5,-1
    80004ed8:	64f2                	ld	s1,280(sp)
    80004eda:	a83d                	j	80004f18 <sys_link+0xf4>
    iunlockput(ip);
    80004edc:	8526                	mv	a0,s1
    80004ede:	e50fe0ef          	jal	8000352e <iunlockput>
    end_op();
    80004ee2:	e97fe0ef          	jal	80003d78 <end_op>
    return -1;
    80004ee6:	57fd                	li	a5,-1
    80004ee8:	64f2                	ld	s1,280(sp)
    80004eea:	a03d                	j	80004f18 <sys_link+0xf4>
    iunlockput(dp);
    80004eec:	854a                	mv	a0,s2
    80004eee:	e40fe0ef          	jal	8000352e <iunlockput>
  ilock(ip);
    80004ef2:	8526                	mv	a0,s1
    80004ef4:	c30fe0ef          	jal	80003324 <ilock>
  ip->nlink--;
    80004ef8:	04a4d783          	lhu	a5,74(s1)
    80004efc:	37fd                	addiw	a5,a5,-1
    80004efe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f02:	8526                	mv	a0,s1
    80004f04:	b6cfe0ef          	jal	80003270 <iupdate>
  iunlockput(ip);
    80004f08:	8526                	mv	a0,s1
    80004f0a:	e24fe0ef          	jal	8000352e <iunlockput>
  end_op();
    80004f0e:	e6bfe0ef          	jal	80003d78 <end_op>
  return -1;
    80004f12:	57fd                	li	a5,-1
    80004f14:	64f2                	ld	s1,280(sp)
    80004f16:	6952                	ld	s2,272(sp)
}
    80004f18:	853e                	mv	a0,a5
    80004f1a:	70b2                	ld	ra,296(sp)
    80004f1c:	7412                	ld	s0,288(sp)
    80004f1e:	6155                	addi	sp,sp,304
    80004f20:	8082                	ret

0000000080004f22 <sys_unlink>:
{
    80004f22:	7151                	addi	sp,sp,-240
    80004f24:	f586                	sd	ra,232(sp)
    80004f26:	f1a2                	sd	s0,224(sp)
    80004f28:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80004f2a:	08000613          	li	a2,128
    80004f2e:	f3040593          	addi	a1,s0,-208
    80004f32:	4501                	li	a0,0
    80004f34:	955fd0ef          	jal	80002888 <argstr>
    80004f38:	16054063          	bltz	a0,80005098 <sys_unlink+0x176>
    80004f3c:	eda6                	sd	s1,216(sp)
  begin_op();
    80004f3e:	dd1fe0ef          	jal	80003d0e <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004f42:	fb040593          	addi	a1,s0,-80
    80004f46:	f3040513          	addi	a0,s0,-208
    80004f4a:	c0bfe0ef          	jal	80003b54 <nameiparent>
    80004f4e:	84aa                	mv	s1,a0
    80004f50:	c945                	beqz	a0,80005000 <sys_unlink+0xde>
  ilock(dp);
    80004f52:	bd2fe0ef          	jal	80003324 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004f56:	00002597          	auipc	a1,0x2
    80004f5a:	66a58593          	addi	a1,a1,1642 # 800075c0 <etext+0x5c0>
    80004f5e:	fb040513          	addi	a0,s0,-80
    80004f62:	95dfe0ef          	jal	800038be <namecmp>
    80004f66:	10050e63          	beqz	a0,80005082 <sys_unlink+0x160>
    80004f6a:	00002597          	auipc	a1,0x2
    80004f6e:	65e58593          	addi	a1,a1,1630 # 800075c8 <etext+0x5c8>
    80004f72:	fb040513          	addi	a0,s0,-80
    80004f76:	949fe0ef          	jal	800038be <namecmp>
    80004f7a:	10050463          	beqz	a0,80005082 <sys_unlink+0x160>
    80004f7e:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80004f80:	f2c40613          	addi	a2,s0,-212
    80004f84:	fb040593          	addi	a1,s0,-80
    80004f88:	8526                	mv	a0,s1
    80004f8a:	94bfe0ef          	jal	800038d4 <dirlookup>
    80004f8e:	892a                	mv	s2,a0
    80004f90:	0e050863          	beqz	a0,80005080 <sys_unlink+0x15e>
  ilock(ip);
    80004f94:	b90fe0ef          	jal	80003324 <ilock>
  if (ip->nlink < 1)
    80004f98:	04a91783          	lh	a5,74(s2)
    80004f9c:	06f05763          	blez	a5,8000500a <sys_unlink+0xe8>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80004fa0:	04491703          	lh	a4,68(s2)
    80004fa4:	4785                	li	a5,1
    80004fa6:	06f70963          	beq	a4,a5,80005018 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004faa:	4641                	li	a2,16
    80004fac:	4581                	li	a1,0
    80004fae:	fc040513          	addi	a0,s0,-64
    80004fb2:	cb5fb0ef          	jal	80000c66 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004fb6:	4741                	li	a4,16
    80004fb8:	f2c42683          	lw	a3,-212(s0)
    80004fbc:	fc040613          	addi	a2,s0,-64
    80004fc0:	4581                	li	a1,0
    80004fc2:	8526                	mv	a0,s1
    80004fc4:	fecfe0ef          	jal	800037b0 <writei>
    80004fc8:	47c1                	li	a5,16
    80004fca:	08f51b63          	bne	a0,a5,80005060 <sys_unlink+0x13e>
  if (ip->type == T_DIR) {
    80004fce:	04491703          	lh	a4,68(s2)
    80004fd2:	4785                	li	a5,1
    80004fd4:	08f70d63          	beq	a4,a5,8000506e <sys_unlink+0x14c>
  iunlockput(dp);
    80004fd8:	8526                	mv	a0,s1
    80004fda:	d54fe0ef          	jal	8000352e <iunlockput>
  ip->nlink--;
    80004fde:	04a95783          	lhu	a5,74(s2)
    80004fe2:	37fd                	addiw	a5,a5,-1
    80004fe4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004fe8:	854a                	mv	a0,s2
    80004fea:	a86fe0ef          	jal	80003270 <iupdate>
  iunlockput(ip);
    80004fee:	854a                	mv	a0,s2
    80004ff0:	d3efe0ef          	jal	8000352e <iunlockput>
  end_op();
    80004ff4:	d85fe0ef          	jal	80003d78 <end_op>
  return 0;
    80004ff8:	4501                	li	a0,0
    80004ffa:	64ee                	ld	s1,216(sp)
    80004ffc:	694e                	ld	s2,208(sp)
    80004ffe:	a849                	j	80005090 <sys_unlink+0x16e>
    end_op();
    80005000:	d79fe0ef          	jal	80003d78 <end_op>
    return -1;
    80005004:	557d                	li	a0,-1
    80005006:	64ee                	ld	s1,216(sp)
    80005008:	a061                	j	80005090 <sys_unlink+0x16e>
    8000500a:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    8000500c:	00002517          	auipc	a0,0x2
    80005010:	5c450513          	addi	a0,a0,1476 # 800075d0 <etext+0x5d0>
    80005014:	fc0fb0ef          	jal	800007d4 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005018:	04c92703          	lw	a4,76(s2)
    8000501c:	02000793          	li	a5,32
    80005020:	f8e7f5e3          	bgeu	a5,a4,80004faa <sys_unlink+0x88>
    80005024:	e5ce                	sd	s3,200(sp)
    80005026:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000502a:	4741                	li	a4,16
    8000502c:	86ce                	mv	a3,s3
    8000502e:	f1840613          	addi	a2,s0,-232
    80005032:	4581                	li	a1,0
    80005034:	854a                	mv	a0,s2
    80005036:	e7efe0ef          	jal	800036b4 <readi>
    8000503a:	47c1                	li	a5,16
    8000503c:	00f51c63          	bne	a0,a5,80005054 <sys_unlink+0x132>
    if (de.inum != 0)
    80005040:	f1845783          	lhu	a5,-232(s0)
    80005044:	efa1                	bnez	a5,8000509c <sys_unlink+0x17a>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005046:	29c1                	addiw	s3,s3,16
    80005048:	04c92783          	lw	a5,76(s2)
    8000504c:	fcf9efe3          	bltu	s3,a5,8000502a <sys_unlink+0x108>
    80005050:	69ae                	ld	s3,200(sp)
    80005052:	bfa1                	j	80004faa <sys_unlink+0x88>
      panic("isdirempty: readi");
    80005054:	00002517          	auipc	a0,0x2
    80005058:	59450513          	addi	a0,a0,1428 # 800075e8 <etext+0x5e8>
    8000505c:	f78fb0ef          	jal	800007d4 <panic>
    80005060:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005062:	00002517          	auipc	a0,0x2
    80005066:	59e50513          	addi	a0,a0,1438 # 80007600 <etext+0x600>
    8000506a:	f6afb0ef          	jal	800007d4 <panic>
    dp->nlink--;
    8000506e:	04a4d783          	lhu	a5,74(s1)
    80005072:	37fd                	addiw	a5,a5,-1
    80005074:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005078:	8526                	mv	a0,s1
    8000507a:	9f6fe0ef          	jal	80003270 <iupdate>
    8000507e:	bfa9                	j	80004fd8 <sys_unlink+0xb6>
    80005080:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005082:	8526                	mv	a0,s1
    80005084:	caafe0ef          	jal	8000352e <iunlockput>
  end_op();
    80005088:	cf1fe0ef          	jal	80003d78 <end_op>
  return -1;
    8000508c:	557d                	li	a0,-1
    8000508e:	64ee                	ld	s1,216(sp)
}
    80005090:	70ae                	ld	ra,232(sp)
    80005092:	740e                	ld	s0,224(sp)
    80005094:	616d                	addi	sp,sp,240
    80005096:	8082                	ret
    return -1;
    80005098:	557d                	li	a0,-1
    8000509a:	bfdd                	j	80005090 <sys_unlink+0x16e>
    iunlockput(ip);
    8000509c:	854a                	mv	a0,s2
    8000509e:	c90fe0ef          	jal	8000352e <iunlockput>
    goto bad;
    800050a2:	694e                	ld	s2,208(sp)
    800050a4:	69ae                	ld	s3,200(sp)
    800050a6:	bff1                	j	80005082 <sys_unlink+0x160>

00000000800050a8 <sys_open>:

uint64
sys_open(void)
{
    800050a8:	7131                	addi	sp,sp,-192
    800050aa:	fd06                	sd	ra,184(sp)
    800050ac:	f922                	sd	s0,176(sp)
    800050ae:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800050b0:	f4c40593          	addi	a1,s0,-180
    800050b4:	4505                	li	a0,1
    800050b6:	f9afd0ef          	jal	80002850 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    800050ba:	08000613          	li	a2,128
    800050be:	f5040593          	addi	a1,s0,-176
    800050c2:	4501                	li	a0,0
    800050c4:	fc4fd0ef          	jal	80002888 <argstr>
    800050c8:	87aa                	mv	a5,a0
    return -1;
    800050ca:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    800050cc:	0a07c263          	bltz	a5,80005170 <sys_open+0xc8>
    800050d0:	f526                	sd	s1,168(sp)

  begin_op();
    800050d2:	c3dfe0ef          	jal	80003d0e <begin_op>

  if (omode & O_CREATE) {
    800050d6:	f4c42783          	lw	a5,-180(s0)
    800050da:	2007f793          	andi	a5,a5,512
    800050de:	c3d5                	beqz	a5,80005182 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800050e0:	4681                	li	a3,0
    800050e2:	4601                	li	a2,0
    800050e4:	4589                	li	a1,2
    800050e6:	f5040513          	addi	a0,s0,-176
    800050ea:	aa9ff0ef          	jal	80004b92 <create>
    800050ee:	84aa                	mv	s1,a0
    if (ip == 0) {
    800050f0:	c541                	beqz	a0,80005178 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    800050f2:	04449703          	lh	a4,68(s1)
    800050f6:	478d                	li	a5,3
    800050f8:	00f71763          	bne	a4,a5,80005106 <sys_open+0x5e>
    800050fc:	0464d703          	lhu	a4,70(s1)
    80005100:	47a5                	li	a5,9
    80005102:	0ae7ed63          	bltu	a5,a4,800051bc <sys_open+0x114>
    80005106:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80005108:	fd7fe0ef          	jal	800040de <filealloc>
    8000510c:	892a                	mv	s2,a0
    8000510e:	c179                	beqz	a0,800051d4 <sys_open+0x12c>
    80005110:	ed4e                	sd	s3,152(sp)
    80005112:	a43ff0ef          	jal	80004b54 <fdalloc>
    80005116:	89aa                	mv	s3,a0
    80005118:	0a054a63          	bltz	a0,800051cc <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    8000511c:	04449703          	lh	a4,68(s1)
    80005120:	478d                	li	a5,3
    80005122:	0cf70263          	beq	a4,a5,800051e6 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005126:	4789                	li	a5,2
    80005128:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000512c:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005130:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005134:	f4c42783          	lw	a5,-180(s0)
    80005138:	0017c713          	xori	a4,a5,1
    8000513c:	8b05                	andi	a4,a4,1
    8000513e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005142:	0037f713          	andi	a4,a5,3
    80005146:	00e03733          	snez	a4,a4
    8000514a:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    8000514e:	4007f793          	andi	a5,a5,1024
    80005152:	c791                	beqz	a5,8000515e <sys_open+0xb6>
    80005154:	04449703          	lh	a4,68(s1)
    80005158:	4789                	li	a5,2
    8000515a:	08f70d63          	beq	a4,a5,800051f4 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    8000515e:	8526                	mv	a0,s1
    80005160:	a72fe0ef          	jal	800033d2 <iunlock>
  end_op();
    80005164:	c15fe0ef          	jal	80003d78 <end_op>

  return fd;
    80005168:	854e                	mv	a0,s3
    8000516a:	74aa                	ld	s1,168(sp)
    8000516c:	790a                	ld	s2,160(sp)
    8000516e:	69ea                	ld	s3,152(sp)
}
    80005170:	70ea                	ld	ra,184(sp)
    80005172:	744a                	ld	s0,176(sp)
    80005174:	6129                	addi	sp,sp,192
    80005176:	8082                	ret
      end_op();
    80005178:	c01fe0ef          	jal	80003d78 <end_op>
      return -1;
    8000517c:	557d                	li	a0,-1
    8000517e:	74aa                	ld	s1,168(sp)
    80005180:	bfc5                	j	80005170 <sys_open+0xc8>
    if ((ip = namei(path)) == 0) {
    80005182:	f5040513          	addi	a0,s0,-176
    80005186:	9b5fe0ef          	jal	80003b3a <namei>
    8000518a:	84aa                	mv	s1,a0
    8000518c:	c11d                	beqz	a0,800051b2 <sys_open+0x10a>
    ilock(ip);
    8000518e:	996fe0ef          	jal	80003324 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80005192:	04449703          	lh	a4,68(s1)
    80005196:	4785                	li	a5,1
    80005198:	f4f71de3          	bne	a4,a5,800050f2 <sys_open+0x4a>
    8000519c:	f4c42783          	lw	a5,-180(s0)
    800051a0:	d3bd                	beqz	a5,80005106 <sys_open+0x5e>
      iunlockput(ip);
    800051a2:	8526                	mv	a0,s1
    800051a4:	b8afe0ef          	jal	8000352e <iunlockput>
      end_op();
    800051a8:	bd1fe0ef          	jal	80003d78 <end_op>
      return -1;
    800051ac:	557d                	li	a0,-1
    800051ae:	74aa                	ld	s1,168(sp)
    800051b0:	b7c1                	j	80005170 <sys_open+0xc8>
      end_op();
    800051b2:	bc7fe0ef          	jal	80003d78 <end_op>
      return -1;
    800051b6:	557d                	li	a0,-1
    800051b8:	74aa                	ld	s1,168(sp)
    800051ba:	bf5d                	j	80005170 <sys_open+0xc8>
    iunlockput(ip);
    800051bc:	8526                	mv	a0,s1
    800051be:	b70fe0ef          	jal	8000352e <iunlockput>
    end_op();
    800051c2:	bb7fe0ef          	jal	80003d78 <end_op>
    return -1;
    800051c6:	557d                	li	a0,-1
    800051c8:	74aa                	ld	s1,168(sp)
    800051ca:	b75d                	j	80005170 <sys_open+0xc8>
      fileclose(f);
    800051cc:	854a                	mv	a0,s2
    800051ce:	fb5fe0ef          	jal	80004182 <fileclose>
    800051d2:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800051d4:	8526                	mv	a0,s1
    800051d6:	b58fe0ef          	jal	8000352e <iunlockput>
    end_op();
    800051da:	b9ffe0ef          	jal	80003d78 <end_op>
    return -1;
    800051de:	557d                	li	a0,-1
    800051e0:	74aa                	ld	s1,168(sp)
    800051e2:	790a                	ld	s2,160(sp)
    800051e4:	b771                	j	80005170 <sys_open+0xc8>
    f->type = FD_DEVICE;
    800051e6:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800051ea:	04649783          	lh	a5,70(s1)
    800051ee:	02f91223          	sh	a5,36(s2)
    800051f2:	bf3d                	j	80005130 <sys_open+0x88>
    itrunc(ip);
    800051f4:	8526                	mv	a0,s1
    800051f6:	a1cfe0ef          	jal	80003412 <itrunc>
    800051fa:	b795                	j	8000515e <sys_open+0xb6>

00000000800051fc <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800051fc:	7175                	addi	sp,sp,-144
    800051fe:	e506                	sd	ra,136(sp)
    80005200:	e122                	sd	s0,128(sp)
    80005202:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005204:	b0bfe0ef          	jal	80003d0e <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80005208:	08000613          	li	a2,128
    8000520c:	f7040593          	addi	a1,s0,-144
    80005210:	4501                	li	a0,0
    80005212:	e76fd0ef          	jal	80002888 <argstr>
    80005216:	02054363          	bltz	a0,8000523c <sys_mkdir+0x40>
    8000521a:	4681                	li	a3,0
    8000521c:	4601                	li	a2,0
    8000521e:	4585                	li	a1,1
    80005220:	f7040513          	addi	a0,s0,-144
    80005224:	96fff0ef          	jal	80004b92 <create>
    80005228:	c911                	beqz	a0,8000523c <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000522a:	b04fe0ef          	jal	8000352e <iunlockput>
  end_op();
    8000522e:	b4bfe0ef          	jal	80003d78 <end_op>
  return 0;
    80005232:	4501                	li	a0,0
}
    80005234:	60aa                	ld	ra,136(sp)
    80005236:	640a                	ld	s0,128(sp)
    80005238:	6149                	addi	sp,sp,144
    8000523a:	8082                	ret
    end_op();
    8000523c:	b3dfe0ef          	jal	80003d78 <end_op>
    return -1;
    80005240:	557d                	li	a0,-1
    80005242:	bfcd                	j	80005234 <sys_mkdir+0x38>

0000000080005244 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005244:	7135                	addi	sp,sp,-160
    80005246:	ed06                	sd	ra,152(sp)
    80005248:	e922                	sd	s0,144(sp)
    8000524a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000524c:	ac3fe0ef          	jal	80003d0e <begin_op>
  argint(1, &major);
    80005250:	f6c40593          	addi	a1,s0,-148
    80005254:	4505                	li	a0,1
    80005256:	dfafd0ef          	jal	80002850 <argint>
  argint(2, &minor);
    8000525a:	f6840593          	addi	a1,s0,-152
    8000525e:	4509                	li	a0,2
    80005260:	df0fd0ef          	jal	80002850 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005264:	08000613          	li	a2,128
    80005268:	f7040593          	addi	a1,s0,-144
    8000526c:	4501                	li	a0,0
    8000526e:	e1afd0ef          	jal	80002888 <argstr>
    80005272:	02054563          	bltz	a0,8000529c <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80005276:	f6841683          	lh	a3,-152(s0)
    8000527a:	f6c41603          	lh	a2,-148(s0)
    8000527e:	458d                	li	a1,3
    80005280:	f7040513          	addi	a0,s0,-144
    80005284:	90fff0ef          	jal	80004b92 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005288:	c911                	beqz	a0,8000529c <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000528a:	aa4fe0ef          	jal	8000352e <iunlockput>
  end_op();
    8000528e:	aebfe0ef          	jal	80003d78 <end_op>
  return 0;
    80005292:	4501                	li	a0,0
}
    80005294:	60ea                	ld	ra,152(sp)
    80005296:	644a                	ld	s0,144(sp)
    80005298:	610d                	addi	sp,sp,160
    8000529a:	8082                	ret
    end_op();
    8000529c:	addfe0ef          	jal	80003d78 <end_op>
    return -1;
    800052a0:	557d                	li	a0,-1
    800052a2:	bfcd                	j	80005294 <sys_mknod+0x50>

00000000800052a4 <sys_chdir>:

uint64
sys_chdir(void)
{
    800052a4:	7135                	addi	sp,sp,-160
    800052a6:	ed06                	sd	ra,152(sp)
    800052a8:	e922                	sd	s0,144(sp)
    800052aa:	e14a                	sd	s2,128(sp)
    800052ac:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800052ae:	de4fc0ef          	jal	80001892 <myproc>
    800052b2:	892a                	mv	s2,a0

  begin_op();
    800052b4:	a5bfe0ef          	jal	80003d0e <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    800052b8:	08000613          	li	a2,128
    800052bc:	f6040593          	addi	a1,s0,-160
    800052c0:	4501                	li	a0,0
    800052c2:	dc6fd0ef          	jal	80002888 <argstr>
    800052c6:	04054363          	bltz	a0,8000530c <sys_chdir+0x68>
    800052ca:	e526                	sd	s1,136(sp)
    800052cc:	f6040513          	addi	a0,s0,-160
    800052d0:	86bfe0ef          	jal	80003b3a <namei>
    800052d4:	84aa                	mv	s1,a0
    800052d6:	c915                	beqz	a0,8000530a <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800052d8:	84cfe0ef          	jal	80003324 <ilock>
  if (ip->type != T_DIR) {
    800052dc:	04449703          	lh	a4,68(s1)
    800052e0:	4785                	li	a5,1
    800052e2:	02f71963          	bne	a4,a5,80005314 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800052e6:	8526                	mv	a0,s1
    800052e8:	8eafe0ef          	jal	800033d2 <iunlock>
  iput(p->cwd);
    800052ec:	15093503          	ld	a0,336(s2)
    800052f0:	9b6fe0ef          	jal	800034a6 <iput>
  end_op();
    800052f4:	a85fe0ef          	jal	80003d78 <end_op>
  p->cwd = ip;
    800052f8:	14993823          	sd	s1,336(s2)
  return 0;
    800052fc:	4501                	li	a0,0
    800052fe:	64aa                	ld	s1,136(sp)
}
    80005300:	60ea                	ld	ra,152(sp)
    80005302:	644a                	ld	s0,144(sp)
    80005304:	690a                	ld	s2,128(sp)
    80005306:	610d                	addi	sp,sp,160
    80005308:	8082                	ret
    8000530a:	64aa                	ld	s1,136(sp)
    end_op();
    8000530c:	a6dfe0ef          	jal	80003d78 <end_op>
    return -1;
    80005310:	557d                	li	a0,-1
    80005312:	b7fd                	j	80005300 <sys_chdir+0x5c>
    iunlockput(ip);
    80005314:	8526                	mv	a0,s1
    80005316:	a18fe0ef          	jal	8000352e <iunlockput>
    end_op();
    8000531a:	a5ffe0ef          	jal	80003d78 <end_op>
    return -1;
    8000531e:	557d                	li	a0,-1
    80005320:	64aa                	ld	s1,136(sp)
    80005322:	bff9                	j	80005300 <sys_chdir+0x5c>

0000000080005324 <sys_exec>:

uint64
sys_exec(void)
{
    80005324:	7121                	addi	sp,sp,-448
    80005326:	ff06                	sd	ra,440(sp)
    80005328:	fb22                	sd	s0,432(sp)
    8000532a:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000532c:	e4840593          	addi	a1,s0,-440
    80005330:	4505                	li	a0,1
    80005332:	d3afd0ef          	jal	8000286c <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    80005336:	08000613          	li	a2,128
    8000533a:	f5040593          	addi	a1,s0,-176
    8000533e:	4501                	li	a0,0
    80005340:	d48fd0ef          	jal	80002888 <argstr>
    80005344:	87aa                	mv	a5,a0
    return -1;
    80005346:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    80005348:	0c07c463          	bltz	a5,80005410 <sys_exec+0xec>
    8000534c:	f726                	sd	s1,424(sp)
    8000534e:	f34a                	sd	s2,416(sp)
    80005350:	ef4e                	sd	s3,408(sp)
    80005352:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005354:	10000613          	li	a2,256
    80005358:	4581                	li	a1,0
    8000535a:	e5040513          	addi	a0,s0,-432
    8000535e:	909fb0ef          	jal	80000c66 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80005362:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005366:	89a6                	mv	s3,s1
    80005368:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    8000536a:	02000a13          	li	s4,32
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    8000536e:	00391513          	slli	a0,s2,0x3
    80005372:	e4040593          	addi	a1,s0,-448
    80005376:	e4843783          	ld	a5,-440(s0)
    8000537a:	953e                	add	a0,a0,a5
    8000537c:	c4afd0ef          	jal	800027c6 <fetchaddr>
    80005380:	02054663          	bltz	a0,800053ac <sys_exec+0x88>
      goto bad;
    }
    if (uarg == 0) {
    80005384:	e4043783          	ld	a5,-448(s0)
    80005388:	c3a9                	beqz	a5,800053ca <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000538a:	f52fb0ef          	jal	80000adc <kalloc>
    8000538e:	85aa                	mv	a1,a0
    80005390:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80005394:	cd01                	beqz	a0,800053ac <sys_exec+0x88>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005396:	6605                	lui	a2,0x1
    80005398:	e4043503          	ld	a0,-448(s0)
    8000539c:	c74fd0ef          	jal	80002810 <fetchstr>
    800053a0:	00054663          	bltz	a0,800053ac <sys_exec+0x88>
    if (i >= NELEM(argv)) {
    800053a4:	0905                	addi	s2,s2,1
    800053a6:	09a1                	addi	s3,s3,8
    800053a8:	fd4913e3          	bne	s2,s4,8000536e <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053ac:	f5040913          	addi	s2,s0,-176
    800053b0:	6088                	ld	a0,0(s1)
    800053b2:	c931                	beqz	a0,80005406 <sys_exec+0xe2>
    kfree(argv[i]);
    800053b4:	e46fb0ef          	jal	800009fa <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053b8:	04a1                	addi	s1,s1,8
    800053ba:	ff249be3          	bne	s1,s2,800053b0 <sys_exec+0x8c>
  return -1;
    800053be:	557d                	li	a0,-1
    800053c0:	74ba                	ld	s1,424(sp)
    800053c2:	791a                	ld	s2,416(sp)
    800053c4:	69fa                	ld	s3,408(sp)
    800053c6:	6a5a                	ld	s4,400(sp)
    800053c8:	a0a1                	j	80005410 <sys_exec+0xec>
      argv[i] = 0;
    800053ca:	0009079b          	sext.w	a5,s2
    800053ce:	078e                	slli	a5,a5,0x3
    800053d0:	fd078793          	addi	a5,a5,-48
    800053d4:	97a2                	add	a5,a5,s0
    800053d6:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    800053da:	e5040593          	addi	a1,s0,-432
    800053de:	f5040513          	addi	a0,s0,-176
    800053e2:	ba8ff0ef          	jal	8000478a <kexec>
    800053e6:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053e8:	f5040993          	addi	s3,s0,-176
    800053ec:	6088                	ld	a0,0(s1)
    800053ee:	c511                	beqz	a0,800053fa <sys_exec+0xd6>
    kfree(argv[i]);
    800053f0:	e0afb0ef          	jal	800009fa <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053f4:	04a1                	addi	s1,s1,8
    800053f6:	ff349be3          	bne	s1,s3,800053ec <sys_exec+0xc8>
  return ret;
    800053fa:	854a                	mv	a0,s2
    800053fc:	74ba                	ld	s1,424(sp)
    800053fe:	791a                	ld	s2,416(sp)
    80005400:	69fa                	ld	s3,408(sp)
    80005402:	6a5a                	ld	s4,400(sp)
    80005404:	a031                	j	80005410 <sys_exec+0xec>
  return -1;
    80005406:	557d                	li	a0,-1
    80005408:	74ba                	ld	s1,424(sp)
    8000540a:	791a                	ld	s2,416(sp)
    8000540c:	69fa                	ld	s3,408(sp)
    8000540e:	6a5a                	ld	s4,400(sp)
}
    80005410:	70fa                	ld	ra,440(sp)
    80005412:	745a                	ld	s0,432(sp)
    80005414:	6139                	addi	sp,sp,448
    80005416:	8082                	ret

0000000080005418 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005418:	7139                	addi	sp,sp,-64
    8000541a:	fc06                	sd	ra,56(sp)
    8000541c:	f822                	sd	s0,48(sp)
    8000541e:	f426                	sd	s1,40(sp)
    80005420:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005422:	c70fc0ef          	jal	80001892 <myproc>
    80005426:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005428:	fd840593          	addi	a1,s0,-40
    8000542c:	4501                	li	a0,0
    8000542e:	c3efd0ef          	jal	8000286c <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    80005432:	fc840593          	addi	a1,s0,-56
    80005436:	fd040513          	addi	a0,s0,-48
    8000543a:	852ff0ef          	jal	8000448c <pipealloc>
    return -1;
    8000543e:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80005440:	0a054463          	bltz	a0,800054e8 <sys_pipe+0xd0>
  fd0 = -1;
    80005444:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80005448:	fd043503          	ld	a0,-48(s0)
    8000544c:	f08ff0ef          	jal	80004b54 <fdalloc>
    80005450:	fca42223          	sw	a0,-60(s0)
    80005454:	08054163          	bltz	a0,800054d6 <sys_pipe+0xbe>
    80005458:	fc843503          	ld	a0,-56(s0)
    8000545c:	ef8ff0ef          	jal	80004b54 <fdalloc>
    80005460:	fca42023          	sw	a0,-64(s0)
    80005464:	06054063          	bltz	a0,800054c4 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005468:	4691                	li	a3,4
    8000546a:	fc440613          	addi	a2,s0,-60
    8000546e:	fd843583          	ld	a1,-40(s0)
    80005472:	68a8                	ld	a0,80(s1)
    80005474:	932fc0ef          	jal	800015a6 <copyout>
    80005478:	00054e63          	bltz	a0,80005494 <sys_pipe+0x7c>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    8000547c:	4691                	li	a3,4
    8000547e:	fc040613          	addi	a2,s0,-64
    80005482:	fd843583          	ld	a1,-40(s0)
    80005486:	0591                	addi	a1,a1,4
    80005488:	68a8                	ld	a0,80(s1)
    8000548a:	91cfc0ef          	jal	800015a6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000548e:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005490:	04055c63          	bgez	a0,800054e8 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005494:	fc442783          	lw	a5,-60(s0)
    80005498:	07e9                	addi	a5,a5,26
    8000549a:	078e                	slli	a5,a5,0x3
    8000549c:	97a6                	add	a5,a5,s1
    8000549e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800054a2:	fc042783          	lw	a5,-64(s0)
    800054a6:	07e9                	addi	a5,a5,26
    800054a8:	078e                	slli	a5,a5,0x3
    800054aa:	94be                	add	s1,s1,a5
    800054ac:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800054b0:	fd043503          	ld	a0,-48(s0)
    800054b4:	ccffe0ef          	jal	80004182 <fileclose>
    fileclose(wf);
    800054b8:	fc843503          	ld	a0,-56(s0)
    800054bc:	cc7fe0ef          	jal	80004182 <fileclose>
    return -1;
    800054c0:	57fd                	li	a5,-1
    800054c2:	a01d                	j	800054e8 <sys_pipe+0xd0>
    if (fd0 >= 0)
    800054c4:	fc442783          	lw	a5,-60(s0)
    800054c8:	0007c763          	bltz	a5,800054d6 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800054cc:	07e9                	addi	a5,a5,26
    800054ce:	078e                	slli	a5,a5,0x3
    800054d0:	97a6                	add	a5,a5,s1
    800054d2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800054d6:	fd043503          	ld	a0,-48(s0)
    800054da:	ca9fe0ef          	jal	80004182 <fileclose>
    fileclose(wf);
    800054de:	fc843503          	ld	a0,-56(s0)
    800054e2:	ca1fe0ef          	jal	80004182 <fileclose>
    return -1;
    800054e6:	57fd                	li	a5,-1
}
    800054e8:	853e                	mv	a0,a5
    800054ea:	70e2                	ld	ra,56(sp)
    800054ec:	7442                	ld	s0,48(sp)
    800054ee:	74a2                	ld	s1,40(sp)
    800054f0:	6121                	addi	sp,sp,64
    800054f2:	8082                	ret
	...

0000000080005500 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005500:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005502:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005504:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    80005506:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005508:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000550a:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000550c:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    8000550e:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005510:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005512:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005514:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005516:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005518:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000551a:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000551c:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    8000551e:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005520:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005522:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005524:	9b2fd0ef          	jal	800026d6 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80005528:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000552a:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000552c:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    8000552e:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005530:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005532:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005534:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005536:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80005538:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000553a:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000553c:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    8000553e:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005540:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005542:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005544:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005546:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80005548:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000554a:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000554c:	10200073          	sret
	...

000000008000555e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000555e:	1141                	addi	sp,sp,-16
    80005560:	e422                	sd	s0,8(sp)
    80005562:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    80005564:	0c0007b7          	lui	a5,0xc000
    80005568:	4705                	li	a4,1
    8000556a:	d798                	sw	a4,40(a5)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    8000556c:	0c0007b7          	lui	a5,0xc000
    80005570:	c3d8                	sw	a4,4(a5)
}
    80005572:	6422                	ld	s0,8(sp)
    80005574:	0141                	addi	sp,sp,16
    80005576:	8082                	ret

0000000080005578 <plicinithart>:

void
plicinithart(void)
{
    80005578:	1141                	addi	sp,sp,-16
    8000557a:	e406                	sd	ra,8(sp)
    8000557c:	e022                	sd	s0,0(sp)
    8000557e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005580:	ae6fc0ef          	jal	80001866 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005584:	0085171b          	slliw	a4,a0,0x8
    80005588:	0c0027b7          	lui	a5,0xc002
    8000558c:	97ba                	add	a5,a5,a4
    8000558e:	40200713          	li	a4,1026
    80005592:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    80005596:	00d5151b          	slliw	a0,a0,0xd
    8000559a:	0c2017b7          	lui	a5,0xc201
    8000559e:	97aa                	add	a5,a5,a0
    800055a0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800055a4:	60a2                	ld	ra,8(sp)
    800055a6:	6402                	ld	s0,0(sp)
    800055a8:	0141                	addi	sp,sp,16
    800055aa:	8082                	ret

00000000800055ac <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800055ac:	1141                	addi	sp,sp,-16
    800055ae:	e406                	sd	ra,8(sp)
    800055b0:	e022                	sd	s0,0(sp)
    800055b2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800055b4:	ab2fc0ef          	jal	80001866 <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    800055b8:	00d5151b          	slliw	a0,a0,0xd
    800055bc:	0c2017b7          	lui	a5,0xc201
    800055c0:	97aa                	add	a5,a5,a0
  return irq;
}
    800055c2:	43c8                	lw	a0,4(a5)
    800055c4:	60a2                	ld	ra,8(sp)
    800055c6:	6402                	ld	s0,0(sp)
    800055c8:	0141                	addi	sp,sp,16
    800055ca:	8082                	ret

00000000800055cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800055cc:	1101                	addi	sp,sp,-32
    800055ce:	ec06                	sd	ra,24(sp)
    800055d0:	e822                	sd	s0,16(sp)
    800055d2:	e426                	sd	s1,8(sp)
    800055d4:	1000                	addi	s0,sp,32
    800055d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800055d8:	a8efc0ef          	jal	80001866 <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    800055dc:	00d5151b          	slliw	a0,a0,0xd
    800055e0:	0c2017b7          	lui	a5,0xc201
    800055e4:	97aa                	add	a5,a5,a0
    800055e6:	c3c4                	sw	s1,4(a5)
}
    800055e8:	60e2                	ld	ra,24(sp)
    800055ea:	6442                	ld	s0,16(sp)
    800055ec:	64a2                	ld	s1,8(sp)
    800055ee:	6105                	addi	sp,sp,32
    800055f0:	8082                	ret

00000000800055f2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800055f2:	1141                	addi	sp,sp,-16
    800055f4:	e406                	sd	ra,8(sp)
    800055f6:	e022                	sd	s0,0(sp)
    800055f8:	0800                	addi	s0,sp,16
  if (i >= NUM)
    800055fa:	479d                	li	a5,7
    800055fc:	04a7ca63          	blt	a5,a0,80005650 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    80005600:	0001e797          	auipc	a5,0x1e
    80005604:	46878793          	addi	a5,a5,1128 # 80023a68 <disk>
    80005608:	97aa                	add	a5,a5,a0
    8000560a:	0187c783          	lbu	a5,24(a5)
    8000560e:	e7b9                	bnez	a5,8000565c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005610:	00451693          	slli	a3,a0,0x4
    80005614:	0001e797          	auipc	a5,0x1e
    80005618:	45478793          	addi	a5,a5,1108 # 80023a68 <disk>
    8000561c:	6398                	ld	a4,0(a5)
    8000561e:	9736                	add	a4,a4,a3
    80005620:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005624:	6398                	ld	a4,0(a5)
    80005626:	9736                	add	a4,a4,a3
    80005628:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000562c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005630:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005634:	97aa                	add	a5,a5,a0
    80005636:	4705                	li	a4,1
    80005638:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000563c:	0001e517          	auipc	a0,0x1e
    80005640:	44450513          	addi	a0,a0,1092 # 80023a80 <disk+0x18>
    80005644:	95ffc0ef          	jal	80001fa2 <wakeup>
}
    80005648:	60a2                	ld	ra,8(sp)
    8000564a:	6402                	ld	s0,0(sp)
    8000564c:	0141                	addi	sp,sp,16
    8000564e:	8082                	ret
    panic("free_desc 1");
    80005650:	00002517          	auipc	a0,0x2
    80005654:	fc050513          	addi	a0,a0,-64 # 80007610 <etext+0x610>
    80005658:	97cfb0ef          	jal	800007d4 <panic>
    panic("free_desc 2");
    8000565c:	00002517          	auipc	a0,0x2
    80005660:	fc450513          	addi	a0,a0,-60 # 80007620 <etext+0x620>
    80005664:	970fb0ef          	jal	800007d4 <panic>

0000000080005668 <virtio_disk_init>:
{
    80005668:	1101                	addi	sp,sp,-32
    8000566a:	ec06                	sd	ra,24(sp)
    8000566c:	e822                	sd	s0,16(sp)
    8000566e:	e426                	sd	s1,8(sp)
    80005670:	e04a                	sd	s2,0(sp)
    80005672:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005674:	00002597          	auipc	a1,0x2
    80005678:	fbc58593          	addi	a1,a1,-68 # 80007630 <etext+0x630>
    8000567c:	0001e517          	auipc	a0,0x1e
    80005680:	51450513          	addi	a0,a0,1300 # 80023b90 <disk+0x128>
    80005684:	ca8fb0ef          	jal	80000b2c <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005688:	100017b7          	lui	a5,0x10001
    8000568c:	4398                	lw	a4,0(a5)
    8000568e:	2701                	sext.w	a4,a4
    80005690:	747277b7          	lui	a5,0x74727
    80005694:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005698:	18f71063          	bne	a4,a5,80005818 <virtio_disk_init+0x1b0>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000569c:	100017b7          	lui	a5,0x10001
    800056a0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800056a2:	439c                	lw	a5,0(a5)
    800056a4:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800056a6:	4709                	li	a4,2
    800056a8:	16e79863          	bne	a5,a4,80005818 <virtio_disk_init+0x1b0>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056ac:	100017b7          	lui	a5,0x10001
    800056b0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800056b2:	439c                	lw	a5,0(a5)
    800056b4:	2781                	sext.w	a5,a5
    800056b6:	16e79163          	bne	a5,a4,80005818 <virtio_disk_init+0x1b0>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    800056ba:	100017b7          	lui	a5,0x10001
    800056be:	47d8                	lw	a4,12(a5)
    800056c0:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056c2:	554d47b7          	lui	a5,0x554d4
    800056c6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800056ca:	14f71763          	bne	a4,a5,80005818 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800056ce:	100017b7          	lui	a5,0x10001
    800056d2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800056d6:	4705                	li	a4,1
    800056d8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056da:	470d                	li	a4,3
    800056dc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800056de:	10001737          	lui	a4,0x10001
    800056e2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800056e4:	c7ffe737          	lui	a4,0xc7ffe
    800056e8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdabb7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800056ec:	8ef9                	and	a3,a3,a4
    800056ee:	10001737          	lui	a4,0x10001
    800056f2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056f4:	472d                	li	a4,11
    800056f6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056f8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800056fc:	439c                	lw	a5,0(a5)
    800056fe:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005702:	8ba1                	andi	a5,a5,8
    80005704:	12078063          	beqz	a5,80005824 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005708:	100017b7          	lui	a5,0x10001
    8000570c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    80005710:	100017b7          	lui	a5,0x10001
    80005714:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005718:	439c                	lw	a5,0(a5)
    8000571a:	2781                	sext.w	a5,a5
    8000571c:	10079a63          	bnez	a5,80005830 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005720:	100017b7          	lui	a5,0x10001
    80005724:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005728:	439c                	lw	a5,0(a5)
    8000572a:	2781                	sext.w	a5,a5
  if (max == 0)
    8000572c:	10078863          	beqz	a5,8000583c <virtio_disk_init+0x1d4>
  if (max < NUM)
    80005730:	471d                	li	a4,7
    80005732:	10f77b63          	bgeu	a4,a5,80005848 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005736:	ba6fb0ef          	jal	80000adc <kalloc>
    8000573a:	0001e497          	auipc	s1,0x1e
    8000573e:	32e48493          	addi	s1,s1,814 # 80023a68 <disk>
    80005742:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005744:	b98fb0ef          	jal	80000adc <kalloc>
    80005748:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000574a:	b92fb0ef          	jal	80000adc <kalloc>
    8000574e:	87aa                	mv	a5,a0
    80005750:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    80005752:	6088                	ld	a0,0(s1)
    80005754:	10050063          	beqz	a0,80005854 <virtio_disk_init+0x1ec>
    80005758:	0001e717          	auipc	a4,0x1e
    8000575c:	31873703          	ld	a4,792(a4) # 80023a70 <disk+0x8>
    80005760:	0e070a63          	beqz	a4,80005854 <virtio_disk_init+0x1ec>
    80005764:	0e078863          	beqz	a5,80005854 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005768:	6605                	lui	a2,0x1
    8000576a:	4581                	li	a1,0
    8000576c:	cfafb0ef          	jal	80000c66 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005770:	0001e497          	auipc	s1,0x1e
    80005774:	2f848493          	addi	s1,s1,760 # 80023a68 <disk>
    80005778:	6605                	lui	a2,0x1
    8000577a:	4581                	li	a1,0
    8000577c:	6488                	ld	a0,8(s1)
    8000577e:	ce8fb0ef          	jal	80000c66 <memset>
  memset(disk.used, 0, PGSIZE);
    80005782:	6605                	lui	a2,0x1
    80005784:	4581                	li	a1,0
    80005786:	6888                	ld	a0,16(s1)
    80005788:	cdefb0ef          	jal	80000c66 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000578c:	100017b7          	lui	a5,0x10001
    80005790:	4721                	li	a4,8
    80005792:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005794:	4098                	lw	a4,0(s1)
    80005796:	100017b7          	lui	a5,0x10001
    8000579a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000579e:	40d8                	lw	a4,4(s1)
    800057a0:	100017b7          	lui	a5,0x10001
    800057a4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800057a8:	649c                	ld	a5,8(s1)
    800057aa:	0007869b          	sext.w	a3,a5
    800057ae:	10001737          	lui	a4,0x10001
    800057b2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800057b6:	9781                	srai	a5,a5,0x20
    800057b8:	10001737          	lui	a4,0x10001
    800057bc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800057c0:	689c                	ld	a5,16(s1)
    800057c2:	0007869b          	sext.w	a3,a5
    800057c6:	10001737          	lui	a4,0x10001
    800057ca:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800057ce:	9781                	srai	a5,a5,0x20
    800057d0:	10001737          	lui	a4,0x10001
    800057d4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800057d8:	10001737          	lui	a4,0x10001
    800057dc:	4785                	li	a5,1
    800057de:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800057e0:	00f48c23          	sb	a5,24(s1)
    800057e4:	00f48ca3          	sb	a5,25(s1)
    800057e8:	00f48d23          	sb	a5,26(s1)
    800057ec:	00f48da3          	sb	a5,27(s1)
    800057f0:	00f48e23          	sb	a5,28(s1)
    800057f4:	00f48ea3          	sb	a5,29(s1)
    800057f8:	00f48f23          	sb	a5,30(s1)
    800057fc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005800:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005804:	100017b7          	lui	a5,0x10001
    80005808:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000580c:	60e2                	ld	ra,24(sp)
    8000580e:	6442                	ld	s0,16(sp)
    80005810:	64a2                	ld	s1,8(sp)
    80005812:	6902                	ld	s2,0(sp)
    80005814:	6105                	addi	sp,sp,32
    80005816:	8082                	ret
    panic("could not find virtio disk");
    80005818:	00002517          	auipc	a0,0x2
    8000581c:	e2850513          	addi	a0,a0,-472 # 80007640 <etext+0x640>
    80005820:	fb5fa0ef          	jal	800007d4 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005824:	00002517          	auipc	a0,0x2
    80005828:	e3c50513          	addi	a0,a0,-452 # 80007660 <etext+0x660>
    8000582c:	fa9fa0ef          	jal	800007d4 <panic>
    panic("virtio disk should not be ready");
    80005830:	00002517          	auipc	a0,0x2
    80005834:	e5050513          	addi	a0,a0,-432 # 80007680 <etext+0x680>
    80005838:	f9dfa0ef          	jal	800007d4 <panic>
    panic("virtio disk has no queue 0");
    8000583c:	00002517          	auipc	a0,0x2
    80005840:	e6450513          	addi	a0,a0,-412 # 800076a0 <etext+0x6a0>
    80005844:	f91fa0ef          	jal	800007d4 <panic>
    panic("virtio disk max queue too short");
    80005848:	00002517          	auipc	a0,0x2
    8000584c:	e7850513          	addi	a0,a0,-392 # 800076c0 <etext+0x6c0>
    80005850:	f85fa0ef          	jal	800007d4 <panic>
    panic("virtio disk kalloc");
    80005854:	00002517          	auipc	a0,0x2
    80005858:	e8c50513          	addi	a0,a0,-372 # 800076e0 <etext+0x6e0>
    8000585c:	f79fa0ef          	jal	800007d4 <panic>

0000000080005860 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005860:	7159                	addi	sp,sp,-112
    80005862:	f486                	sd	ra,104(sp)
    80005864:	f0a2                	sd	s0,96(sp)
    80005866:	eca6                	sd	s1,88(sp)
    80005868:	e8ca                	sd	s2,80(sp)
    8000586a:	e4ce                	sd	s3,72(sp)
    8000586c:	e0d2                	sd	s4,64(sp)
    8000586e:	fc56                	sd	s5,56(sp)
    80005870:	f85a                	sd	s6,48(sp)
    80005872:	f45e                	sd	s7,40(sp)
    80005874:	f062                	sd	s8,32(sp)
    80005876:	ec66                	sd	s9,24(sp)
    80005878:	1880                	addi	s0,sp,112
    8000587a:	8a2a                	mv	s4,a0
    8000587c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000587e:	00c52c83          	lw	s9,12(a0)
    80005882:	001c9c9b          	slliw	s9,s9,0x1
    80005886:	1c82                	slli	s9,s9,0x20
    80005888:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000588c:	0001e517          	auipc	a0,0x1e
    80005890:	30450513          	addi	a0,a0,772 # 80023b90 <disk+0x128>
    80005894:	b0efb0ef          	jal	80000ba2 <acquire>
  for (int i = 0; i < 3; i++) {
    80005898:	4981                	li	s3,0
  for (int i = 0; i < NUM; i++) {
    8000589a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000589c:	0001eb17          	auipc	s6,0x1e
    800058a0:	1ccb0b13          	addi	s6,s6,460 # 80023a68 <disk>
  for (int i = 0; i < 3; i++) {
    800058a4:	4a8d                	li	s5,3
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800058a6:	0001ec17          	auipc	s8,0x1e
    800058aa:	2eac0c13          	addi	s8,s8,746 # 80023b90 <disk+0x128>
    800058ae:	a8b9                	j	8000590c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    800058b0:	00fb0733          	add	a4,s6,a5
    800058b4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800058b8:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    800058ba:	0207c563          	bltz	a5,800058e4 <virtio_disk_rw+0x84>
  for (int i = 0; i < 3; i++) {
    800058be:	2905                	addiw	s2,s2,1
    800058c0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800058c2:	05590963          	beq	s2,s5,80005914 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    800058c6:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    800058c8:	0001e717          	auipc	a4,0x1e
    800058cc:	1a070713          	addi	a4,a4,416 # 80023a68 <disk>
    800058d0:	87ce                	mv	a5,s3
    if (disk.free[i]) {
    800058d2:	01874683          	lbu	a3,24(a4)
    800058d6:	fee9                	bnez	a3,800058b0 <virtio_disk_rw+0x50>
  for (int i = 0; i < NUM; i++) {
    800058d8:	2785                	addiw	a5,a5,1
    800058da:	0705                	addi	a4,a4,1
    800058dc:	fe979be3          	bne	a5,s1,800058d2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800058e0:	57fd                	li	a5,-1
    800058e2:	c19c                	sw	a5,0(a1)
      for (int j = 0; j < i; j++)
    800058e4:	01205d63          	blez	s2,800058fe <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800058e8:	f9042503          	lw	a0,-112(s0)
    800058ec:	d07ff0ef          	jal	800055f2 <free_desc>
      for (int j = 0; j < i; j++)
    800058f0:	4785                	li	a5,1
    800058f2:	0127d663          	bge	a5,s2,800058fe <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800058f6:	f9442503          	lw	a0,-108(s0)
    800058fa:	cf9ff0ef          	jal	800055f2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800058fe:	85e2                	mv	a1,s8
    80005900:	0001e517          	auipc	a0,0x1e
    80005904:	18050513          	addi	a0,a0,384 # 80023a80 <disk+0x18>
    80005908:	e4efc0ef          	jal	80001f56 <sleep>
  for (int i = 0; i < 3; i++) {
    8000590c:	f9040613          	addi	a2,s0,-112
    80005910:	894e                	mv	s2,s3
    80005912:	bf55                	j	800058c6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005914:	f9042503          	lw	a0,-112(s0)
    80005918:	00451693          	slli	a3,a0,0x4

  if (write)
    8000591c:	0001e797          	auipc	a5,0x1e
    80005920:	14c78793          	addi	a5,a5,332 # 80023a68 <disk>
    80005924:	00a50713          	addi	a4,a0,10
    80005928:	0712                	slli	a4,a4,0x4
    8000592a:	973e                	add	a4,a4,a5
    8000592c:	01703633          	snez	a2,s7
    80005930:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005932:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005936:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    8000593a:	6398                	ld	a4,0(a5)
    8000593c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000593e:	0a868613          	addi	a2,a3,168
    80005942:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80005944:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005946:	6390                	ld	a2,0(a5)
    80005948:	00d605b3          	add	a1,a2,a3
    8000594c:	4741                	li	a4,16
    8000594e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005950:	4805                	li	a6,1
    80005952:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005956:	f9442703          	lw	a4,-108(s0)
    8000595a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64)b->data;
    8000595e:	0712                	slli	a4,a4,0x4
    80005960:	963a                	add	a2,a2,a4
    80005962:	058a0593          	addi	a1,s4,88
    80005966:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005968:	0007b883          	ld	a7,0(a5)
    8000596c:	9746                	add	a4,a4,a7
    8000596e:	40000613          	li	a2,1024
    80005972:	c710                	sw	a2,8(a4)
  if (write)
    80005974:	001bb613          	seqz	a2,s7
    80005978:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000597c:	00166613          	ori	a2,a2,1
    80005980:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005984:	f9842583          	lw	a1,-104(s0)
    80005988:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000598c:	00250613          	addi	a2,a0,2
    80005990:	0612                	slli	a2,a2,0x4
    80005992:	963e                	add	a2,a2,a5
    80005994:	577d                	li	a4,-1
    80005996:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    8000599a:	0592                	slli	a1,a1,0x4
    8000599c:	98ae                	add	a7,a7,a1
    8000599e:	03068713          	addi	a4,a3,48
    800059a2:	973e                	add	a4,a4,a5
    800059a4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800059a8:	6398                	ld	a4,0(a5)
    800059aa:	972e                	add	a4,a4,a1
    800059ac:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800059b0:	4689                	li	a3,2
    800059b2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800059b6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800059ba:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    800059be:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800059c2:	6794                	ld	a3,8(a5)
    800059c4:	0026d703          	lhu	a4,2(a3)
    800059c8:	8b1d                	andi	a4,a4,7
    800059ca:	0706                	slli	a4,a4,0x1
    800059cc:	96ba                	add	a3,a3,a4
    800059ce:	00a69223          	sh	a0,4(a3)

  __atomic_thread_fence(__ATOMIC_SEQ_CST);
    800059d2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800059d6:	6798                	ld	a4,8(a5)
    800059d8:	00275783          	lhu	a5,2(a4)
    800059dc:	2785                	addiw	a5,a5,1
    800059de:	00f71123          	sh	a5,2(a4)

  __atomic_thread_fence(__ATOMIC_SEQ_CST);
    800059e2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800059e6:	100017b7          	lui	a5,0x10001
    800059ea:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    800059ee:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800059f2:	0001e917          	auipc	s2,0x1e
    800059f6:	19e90913          	addi	s2,s2,414 # 80023b90 <disk+0x128>
  while (b->disk == 1) {
    800059fa:	4485                	li	s1,1
    800059fc:	01079a63          	bne	a5,a6,80005a10 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005a00:	85ca                	mv	a1,s2
    80005a02:	8552                	mv	a0,s4
    80005a04:	d52fc0ef          	jal	80001f56 <sleep>
  while (b->disk == 1) {
    80005a08:	004a2783          	lw	a5,4(s4)
    80005a0c:	fe978ae3          	beq	a5,s1,80005a00 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005a10:	f9042903          	lw	s2,-112(s0)
    80005a14:	00290713          	addi	a4,s2,2
    80005a18:	0712                	slli	a4,a4,0x4
    80005a1a:	0001e797          	auipc	a5,0x1e
    80005a1e:	04e78793          	addi	a5,a5,78 # 80023a68 <disk>
    80005a22:	97ba                	add	a5,a5,a4
    80005a24:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005a28:	0001e997          	auipc	s3,0x1e
    80005a2c:	04098993          	addi	s3,s3,64 # 80023a68 <disk>
    80005a30:	00491713          	slli	a4,s2,0x4
    80005a34:	0009b783          	ld	a5,0(s3)
    80005a38:	97ba                	add	a5,a5,a4
    80005a3a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005a3e:	854a                	mv	a0,s2
    80005a40:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005a44:	bafff0ef          	jal	800055f2 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80005a48:	8885                	andi	s1,s1,1
    80005a4a:	f0fd                	bnez	s1,80005a30 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005a4c:	0001e517          	auipc	a0,0x1e
    80005a50:	14450513          	addi	a0,a0,324 # 80023b90 <disk+0x128>
    80005a54:	9dafb0ef          	jal	80000c2e <release>
}
    80005a58:	70a6                	ld	ra,104(sp)
    80005a5a:	7406                	ld	s0,96(sp)
    80005a5c:	64e6                	ld	s1,88(sp)
    80005a5e:	6946                	ld	s2,80(sp)
    80005a60:	69a6                	ld	s3,72(sp)
    80005a62:	6a06                	ld	s4,64(sp)
    80005a64:	7ae2                	ld	s5,56(sp)
    80005a66:	7b42                	ld	s6,48(sp)
    80005a68:	7ba2                	ld	s7,40(sp)
    80005a6a:	7c02                	ld	s8,32(sp)
    80005a6c:	6ce2                	ld	s9,24(sp)
    80005a6e:	6165                	addi	sp,sp,112
    80005a70:	8082                	ret

0000000080005a72 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a72:	1101                	addi	sp,sp,-32
    80005a74:	ec06                	sd	ra,24(sp)
    80005a76:	e822                	sd	s0,16(sp)
    80005a78:	e426                	sd	s1,8(sp)
    80005a7a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a7c:	0001e497          	auipc	s1,0x1e
    80005a80:	fec48493          	addi	s1,s1,-20 # 80023a68 <disk>
    80005a84:	0001e517          	auipc	a0,0x1e
    80005a88:	10c50513          	addi	a0,a0,268 # 80023b90 <disk+0x128>
    80005a8c:	916fb0ef          	jal	80000ba2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a90:	100017b7          	lui	a5,0x10001
    80005a94:	53b8                	lw	a4,96(a5)
    80005a96:	8b0d                	andi	a4,a4,3
    80005a98:	100017b7          	lui	a5,0x10001
    80005a9c:	d3f8                	sw	a4,100(a5)

  __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80005a9e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005aa2:	689c                	ld	a5,16(s1)
    80005aa4:	0204d703          	lhu	a4,32(s1)
    80005aa8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005aac:	04f70663          	beq	a4,a5,80005af8 <virtio_disk_intr+0x86>
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80005ab0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005ab4:	6898                	ld	a4,16(s1)
    80005ab6:	0204d783          	lhu	a5,32(s1)
    80005aba:	8b9d                	andi	a5,a5,7
    80005abc:	078e                	slli	a5,a5,0x3
    80005abe:	97ba                	add	a5,a5,a4
    80005ac0:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    80005ac2:	00278713          	addi	a4,a5,2
    80005ac6:	0712                	slli	a4,a4,0x4
    80005ac8:	9726                	add	a4,a4,s1
    80005aca:	01074703          	lbu	a4,16(a4)
    80005ace:	e321                	bnez	a4,80005b0e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005ad0:	0789                	addi	a5,a5,2
    80005ad2:	0792                	slli	a5,a5,0x4
    80005ad4:	97a6                	add	a5,a5,s1
    80005ad6:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    80005ad8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005adc:	cc6fc0ef          	jal	80001fa2 <wakeup>

    disk.used_idx += 1;
    80005ae0:	0204d783          	lhu	a5,32(s1)
    80005ae4:	2785                	addiw	a5,a5,1
    80005ae6:	17c2                	slli	a5,a5,0x30
    80005ae8:	93c1                	srli	a5,a5,0x30
    80005aea:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005aee:	6898                	ld	a4,16(s1)
    80005af0:	00275703          	lhu	a4,2(a4)
    80005af4:	faf71ee3          	bne	a4,a5,80005ab0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005af8:	0001e517          	auipc	a0,0x1e
    80005afc:	09850513          	addi	a0,a0,152 # 80023b90 <disk+0x128>
    80005b00:	92efb0ef          	jal	80000c2e <release>
}
    80005b04:	60e2                	ld	ra,24(sp)
    80005b06:	6442                	ld	s0,16(sp)
    80005b08:	64a2                	ld	s1,8(sp)
    80005b0a:	6105                	addi	sp,sp,32
    80005b0c:	8082                	ret
      panic("virtio_disk_intr status");
    80005b0e:	00002517          	auipc	a0,0x2
    80005b12:	bea50513          	addi	a0,a0,-1046 # 800076f8 <etext+0x6f8>
    80005b16:	cbffa0ef          	jal	800007d4 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
