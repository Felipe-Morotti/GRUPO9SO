
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	1080                	addi	s0,sp,96
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
       e:	00008797          	auipc	a5,0x8
      12:	95278793          	addi	a5,a5,-1710 # 7960 <malloc+0x26b6>
      16:	638c                	ld	a1,0(a5)
      18:	6790                	ld	a2,8(a5)
      1a:	6b94                	ld	a3,16(a5)
      1c:	6f98                	ld	a4,24(a5)
      1e:	739c                	ld	a5,32(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	fcf43423          	sd	a5,-56(s0)
                    0xffffffffffffffff};

  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      34:	fa840493          	addi	s1,s0,-88
      38:	fd040993          	addi	s3,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      3c:	0004b903          	ld	s2,0(s1)
      40:	20100593          	li	a1,513
      44:	854a                	mv	a0,s2
      46:	5a9040ef          	jal	4dee <open>
    if (fd >= 0) {
      4a:	00055c63          	bgez	a0,62 <copyinstr1+0x62>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      4e:	04a1                	addi	s1,s1,8
      50:	ff3496e3          	bne	s1,s3,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      exit(1);
    }
  }
}
      54:	60e6                	ld	ra,88(sp)
      56:	6446                	ld	s0,80(sp)
      58:	64a6                	ld	s1,72(sp)
      5a:	6906                	ld	s2,64(sp)
      5c:	79e2                	ld	s3,56(sp)
      5e:	6125                	addi	sp,sp,96
      60:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      62:	862a                	mv	a2,a0
      64:	85ca                	mv	a1,s2
      66:	00005517          	auipc	a0,0x5
      6a:	34a50513          	addi	a0,a0,842 # 53b0 <malloc+0x106>
      6e:	188050ef          	jal	51f6 <printf>
      exit(1);
      72:	4505                	li	a0,1
      74:	53b040ef          	jal	4dae <exit>

0000000000000078 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for (i = 0; i < sizeof(uninit); i++) {
      78:	0000a797          	auipc	a5,0xa
      7c:	53078793          	addi	a5,a5,1328 # a5a8 <uninit>
      80:	0000d697          	auipc	a3,0xd
      84:	c3868693          	addi	a3,a3,-968 # ccb8 <buf>
    if (uninit[i] != '\0') {
      88:	0007c703          	lbu	a4,0(a5)
      8c:	e709                	bnez	a4,96 <bsstest+0x1e>
  for (i = 0; i < sizeof(uninit); i++) {
      8e:	0785                	addi	a5,a5,1
      90:	fed79ce3          	bne	a5,a3,88 <bsstest+0x10>
      94:	8082                	ret
{
      96:	1141                	addi	sp,sp,-16
      98:	e406                	sd	ra,8(sp)
      9a:	e022                	sd	s0,0(sp)
      9c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      9e:	85aa                	mv	a1,a0
      a0:	00005517          	auipc	a0,0x5
      a4:	33050513          	addi	a0,a0,816 # 53d0 <malloc+0x126>
      a8:	14e050ef          	jal	51f6 <printf>
      exit(1);
      ac:	4505                	li	a0,1
      ae:	501040ef          	jal	4dae <exit>

00000000000000b2 <opentest>:
{
      b2:	1101                	addi	sp,sp,-32
      b4:	ec06                	sd	ra,24(sp)
      b6:	e822                	sd	s0,16(sp)
      b8:	e426                	sd	s1,8(sp)
      ba:	1000                	addi	s0,sp,32
      bc:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      be:	4581                	li	a1,0
      c0:	00005517          	auipc	a0,0x5
      c4:	32850513          	addi	a0,a0,808 # 53e8 <malloc+0x13e>
      c8:	527040ef          	jal	4dee <open>
  if (fd < 0) {
      cc:	02054263          	bltz	a0,f0 <opentest+0x3e>
  close(fd);
      d0:	507040ef          	jal	4dd6 <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00005517          	auipc	a0,0x5
      da:	33250513          	addi	a0,a0,818 # 5408 <malloc+0x15e>
      de:	511040ef          	jal	4dee <open>
  if (fd >= 0) {
      e2:	02055163          	bgez	a0,104 <opentest+0x52>
}
      e6:	60e2                	ld	ra,24(sp)
      e8:	6442                	ld	s0,16(sp)
      ea:	64a2                	ld	s1,8(sp)
      ec:	6105                	addi	sp,sp,32
      ee:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f0:	85a6                	mv	a1,s1
      f2:	00005517          	auipc	a0,0x5
      f6:	2fe50513          	addi	a0,a0,766 # 53f0 <malloc+0x146>
      fa:	0fc050ef          	jal	51f6 <printf>
    exit(1);
      fe:	4505                	li	a0,1
     100:	4af040ef          	jal	4dae <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     104:	85a6                	mv	a1,s1
     106:	00005517          	auipc	a0,0x5
     10a:	31250513          	addi	a0,a0,786 # 5418 <malloc+0x16e>
     10e:	0e8050ef          	jal	51f6 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	49b040ef          	jal	4dae <exit>

0000000000000118 <truncate2>:
{
     118:	7179                	addi	sp,sp,-48
     11a:	f406                	sd	ra,40(sp)
     11c:	f022                	sd	s0,32(sp)
     11e:	ec26                	sd	s1,24(sp)
     120:	e84a                	sd	s2,16(sp)
     122:	e44e                	sd	s3,8(sp)
     124:	1800                	addi	s0,sp,48
     126:	89aa                	mv	s3,a0
  unlink("truncfile");
     128:	00005517          	auipc	a0,0x5
     12c:	31850513          	addi	a0,a0,792 # 5440 <malloc+0x196>
     130:	4cf040ef          	jal	4dfe <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     134:	60100593          	li	a1,1537
     138:	00005517          	auipc	a0,0x5
     13c:	30850513          	addi	a0,a0,776 # 5440 <malloc+0x196>
     140:	4af040ef          	jal	4dee <open>
     144:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     146:	4611                	li	a2,4
     148:	00005597          	auipc	a1,0x5
     14c:	30858593          	addi	a1,a1,776 # 5450 <malloc+0x1a6>
     150:	47f040ef          	jal	4dce <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     154:	40100593          	li	a1,1025
     158:	00005517          	auipc	a0,0x5
     15c:	2e850513          	addi	a0,a0,744 # 5440 <malloc+0x196>
     160:	48f040ef          	jal	4dee <open>
     164:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     166:	4605                	li	a2,1
     168:	00005597          	auipc	a1,0x5
     16c:	2f058593          	addi	a1,a1,752 # 5458 <malloc+0x1ae>
     170:	8526                	mv	a0,s1
     172:	45d040ef          	jal	4dce <write>
  if (n != -1) {
     176:	57fd                	li	a5,-1
     178:	02f51563          	bne	a0,a5,1a2 <truncate2+0x8a>
  unlink("truncfile");
     17c:	00005517          	auipc	a0,0x5
     180:	2c450513          	addi	a0,a0,708 # 5440 <malloc+0x196>
     184:	47b040ef          	jal	4dfe <unlink>
  close(fd1);
     188:	8526                	mv	a0,s1
     18a:	44d040ef          	jal	4dd6 <close>
  close(fd2);
     18e:	854a                	mv	a0,s2
     190:	447040ef          	jal	4dd6 <close>
}
     194:	70a2                	ld	ra,40(sp)
     196:	7402                	ld	s0,32(sp)
     198:	64e2                	ld	s1,24(sp)
     19a:	6942                	ld	s2,16(sp)
     19c:	69a2                	ld	s3,8(sp)
     19e:	6145                	addi	sp,sp,48
     1a0:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a2:	862a                	mv	a2,a0
     1a4:	85ce                	mv	a1,s3
     1a6:	00005517          	auipc	a0,0x5
     1aa:	2ba50513          	addi	a0,a0,698 # 5460 <malloc+0x1b6>
     1ae:	048050ef          	jal	51f6 <printf>
    exit(1);
     1b2:	4505                	li	a0,1
     1b4:	3fb040ef          	jal	4dae <exit>

00000000000001b8 <createtest>:
{
     1b8:	7179                	addi	sp,sp,-48
     1ba:	f406                	sd	ra,40(sp)
     1bc:	f022                	sd	s0,32(sp)
     1be:	ec26                	sd	s1,24(sp)
     1c0:	e84a                	sd	s2,16(sp)
     1c2:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1c4:	06100793          	li	a5,97
     1c8:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1cc:	fc040d23          	sb	zero,-38(s0)
     1d0:	03000493          	li	s1,48
  for (i = 0; i < N; i++) {
     1d4:	06400913          	li	s2,100
    name[1] = '0' + i;
     1d8:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE | O_RDWR);
     1dc:	20200593          	li	a1,514
     1e0:	fd840513          	addi	a0,s0,-40
     1e4:	40b040ef          	jal	4dee <open>
    close(fd);
     1e8:	3ef040ef          	jal	4dd6 <close>
  for (i = 0; i < N; i++) {
     1ec:	2485                	addiw	s1,s1,1
     1ee:	0ff4f493          	zext.b	s1,s1
     1f2:	ff2493e3          	bne	s1,s2,1d8 <createtest+0x20>
  name[0] = 'a';
     1f6:	06100793          	li	a5,97
     1fa:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1fe:	fc040d23          	sb	zero,-38(s0)
     202:	03000493          	li	s1,48
  for (i = 0; i < N; i++) {
     206:	06400913          	li	s2,100
    name[1] = '0' + i;
     20a:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     20e:	fd840513          	addi	a0,s0,-40
     212:	3ed040ef          	jal	4dfe <unlink>
  for (i = 0; i < N; i++) {
     216:	2485                	addiw	s1,s1,1
     218:	0ff4f493          	zext.b	s1,s1
     21c:	ff2497e3          	bne	s1,s2,20a <createtest+0x52>
}
     220:	70a2                	ld	ra,40(sp)
     222:	7402                	ld	s0,32(sp)
     224:	64e2                	ld	s1,24(sp)
     226:	6942                	ld	s2,16(sp)
     228:	6145                	addi	sp,sp,48
     22a:	8082                	ret

000000000000022c <bigwrite>:
{
     22c:	715d                	addi	sp,sp,-80
     22e:	e486                	sd	ra,72(sp)
     230:	e0a2                	sd	s0,64(sp)
     232:	fc26                	sd	s1,56(sp)
     234:	f84a                	sd	s2,48(sp)
     236:	f44e                	sd	s3,40(sp)
     238:	f052                	sd	s4,32(sp)
     23a:	ec56                	sd	s5,24(sp)
     23c:	e85a                	sd	s6,16(sp)
     23e:	e45e                	sd	s7,8(sp)
     240:	0880                	addi	s0,sp,80
     242:	8baa                	mv	s7,a0
  unlink("bigwrite");
     244:	00005517          	auipc	a0,0x5
     248:	24450513          	addi	a0,a0,580 # 5488 <malloc+0x1de>
     24c:	3b3040ef          	jal	4dfe <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     250:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     254:	00005a97          	auipc	s5,0x5
     258:	234a8a93          	addi	s5,s5,564 # 5488 <malloc+0x1de>
      int cc = write(fd, buf, sz);
     25c:	0000da17          	auipc	s4,0xd
     260:	a5ca0a13          	addi	s4,s4,-1444 # ccb8 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     264:	6b0d                	lui	s6,0x3
     266:	1c9b0b13          	addi	s6,s6,457 # 31c9 <dirfile+0x69>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200593          	li	a1,514
     26e:	8556                	mv	a0,s5
     270:	37f040ef          	jal	4dee <open>
     274:	892a                	mv	s2,a0
    if (fd < 0) {
     276:	04054563          	bltz	a0,2c0 <bigwrite+0x94>
      int cc = write(fd, buf, sz);
     27a:	8626                	mv	a2,s1
     27c:	85d2                	mv	a1,s4
     27e:	351040ef          	jal	4dce <write>
     282:	89aa                	mv	s3,a0
      if (cc != sz) {
     284:	04a49863          	bne	s1,a0,2d4 <bigwrite+0xa8>
      int cc = write(fd, buf, sz);
     288:	8626                	mv	a2,s1
     28a:	85d2                	mv	a1,s4
     28c:	854a                	mv	a0,s2
     28e:	341040ef          	jal	4dce <write>
      if (cc != sz) {
     292:	04951263          	bne	a0,s1,2d6 <bigwrite+0xaa>
    close(fd);
     296:	854a                	mv	a0,s2
     298:	33f040ef          	jal	4dd6 <close>
    unlink("bigwrite");
     29c:	8556                	mv	a0,s5
     29e:	361040ef          	jal	4dfe <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2a2:	1d74849b          	addiw	s1,s1,471
     2a6:	fd6492e3          	bne	s1,s6,26a <bigwrite+0x3e>
}
     2aa:	60a6                	ld	ra,72(sp)
     2ac:	6406                	ld	s0,64(sp)
     2ae:	74e2                	ld	s1,56(sp)
     2b0:	7942                	ld	s2,48(sp)
     2b2:	79a2                	ld	s3,40(sp)
     2b4:	7a02                	ld	s4,32(sp)
     2b6:	6ae2                	ld	s5,24(sp)
     2b8:	6b42                	ld	s6,16(sp)
     2ba:	6ba2                	ld	s7,8(sp)
     2bc:	6161                	addi	sp,sp,80
     2be:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2c0:	85de                	mv	a1,s7
     2c2:	00005517          	auipc	a0,0x5
     2c6:	1d650513          	addi	a0,a0,470 # 5498 <malloc+0x1ee>
     2ca:	72d040ef          	jal	51f6 <printf>
      exit(1);
     2ce:	4505                	li	a0,1
     2d0:	2df040ef          	jal	4dae <exit>
      if (cc != sz) {
     2d4:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2d6:	86aa                	mv	a3,a0
     2d8:	864e                	mv	a2,s3
     2da:	85de                	mv	a1,s7
     2dc:	00005517          	auipc	a0,0x5
     2e0:	1dc50513          	addi	a0,a0,476 # 54b8 <malloc+0x20e>
     2e4:	713040ef          	jal	51f6 <printf>
        exit(1);
     2e8:	4505                	li	a0,1
     2ea:	2c5040ef          	jal	4dae <exit>

00000000000002ee <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     2ee:	7179                	addi	sp,sp,-48
     2f0:	f406                	sd	ra,40(sp)
     2f2:	f022                	sd	s0,32(sp)
     2f4:	ec26                	sd	s1,24(sp)
     2f6:	e84a                	sd	s2,16(sp)
     2f8:	e44e                	sd	s3,8(sp)
     2fa:	e052                	sd	s4,0(sp)
     2fc:	1800                	addi	s0,sp,48
  int assumed_free = 600;

  unlink("junk");
     2fe:	00005517          	auipc	a0,0x5
     302:	1d250513          	addi	a0,a0,466 # 54d0 <malloc+0x226>
     306:	2f9040ef          	jal	4dfe <unlink>
     30a:	25800913          	li	s2,600
  for (int i = 0; i < assumed_free; i++) {
    int fd = open("junk", O_CREATE | O_WRONLY);
     30e:	00005997          	auipc	s3,0x5
     312:	1c298993          	addi	s3,s3,450 # 54d0 <malloc+0x226>
    if (fd < 0) {
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char *)0xffffffffffL, 1);
     316:	5a7d                	li	s4,-1
     318:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE | O_WRONLY);
     31c:	20100593          	li	a1,513
     320:	854e                	mv	a0,s3
     322:	2cd040ef          	jal	4dee <open>
     326:	84aa                	mv	s1,a0
    if (fd < 0) {
     328:	04054d63          	bltz	a0,382 <badwrite+0x94>
    write(fd, (char *)0xffffffffffL, 1);
     32c:	4605                	li	a2,1
     32e:	85d2                	mv	a1,s4
     330:	29f040ef          	jal	4dce <write>
    close(fd);
     334:	8526                	mv	a0,s1
     336:	2a1040ef          	jal	4dd6 <close>
    unlink("junk");
     33a:	854e                	mv	a0,s3
     33c:	2c3040ef          	jal	4dfe <unlink>
  for (int i = 0; i < assumed_free; i++) {
     340:	397d                	addiw	s2,s2,-1
     342:	fc091de3          	bnez	s2,31c <badwrite+0x2e>
  }

  int fd = open("junk", O_CREATE | O_WRONLY);
     346:	20100593          	li	a1,513
     34a:	00005517          	auipc	a0,0x5
     34e:	18650513          	addi	a0,a0,390 # 54d0 <malloc+0x226>
     352:	29d040ef          	jal	4dee <open>
     356:	84aa                	mv	s1,a0
  if (fd < 0) {
     358:	02054e63          	bltz	a0,394 <badwrite+0xa6>
    printf("open junk failed\n");
    exit(1);
  }
  if (write(fd, "x", 1) != 1) {
     35c:	4605                	li	a2,1
     35e:	00005597          	auipc	a1,0x5
     362:	0fa58593          	addi	a1,a1,250 # 5458 <malloc+0x1ae>
     366:	269040ef          	jal	4dce <write>
     36a:	4785                	li	a5,1
     36c:	02f50d63          	beq	a0,a5,3a6 <badwrite+0xb8>
    printf("write failed\n");
     370:	00005517          	auipc	a0,0x5
     374:	18050513          	addi	a0,a0,384 # 54f0 <malloc+0x246>
     378:	67f040ef          	jal	51f6 <printf>
    exit(1);
     37c:	4505                	li	a0,1
     37e:	231040ef          	jal	4dae <exit>
      printf("open junk failed\n");
     382:	00005517          	auipc	a0,0x5
     386:	15650513          	addi	a0,a0,342 # 54d8 <malloc+0x22e>
     38a:	66d040ef          	jal	51f6 <printf>
      exit(1);
     38e:	4505                	li	a0,1
     390:	21f040ef          	jal	4dae <exit>
    printf("open junk failed\n");
     394:	00005517          	auipc	a0,0x5
     398:	14450513          	addi	a0,a0,324 # 54d8 <malloc+0x22e>
     39c:	65b040ef          	jal	51f6 <printf>
    exit(1);
     3a0:	4505                	li	a0,1
     3a2:	20d040ef          	jal	4dae <exit>
  }
  close(fd);
     3a6:	8526                	mv	a0,s1
     3a8:	22f040ef          	jal	4dd6 <close>
  unlink("junk");
     3ac:	00005517          	auipc	a0,0x5
     3b0:	12450513          	addi	a0,a0,292 # 54d0 <malloc+0x226>
     3b4:	24b040ef          	jal	4dfe <unlink>

  exit(0);
     3b8:	4501                	li	a0,0
     3ba:	1f5040ef          	jal	4dae <exit>

00000000000003be <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3be:	715d                	addi	sp,sp,-80
     3c0:	e486                	sd	ra,72(sp)
     3c2:	e0a2                	sd	s0,64(sp)
     3c4:	fc26                	sd	s1,56(sp)
     3c6:	f84a                	sd	s2,48(sp)
     3c8:	f44e                	sd	s3,40(sp)
     3ca:	0880                	addi	s0,sp,80
  int nzz = 32 * 32;
  for (int i = 0; i < nzz; i++) {
     3cc:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3ce:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++) {
     3d2:	40000993          	li	s3,1024
    name[0] = 'z';
     3d6:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     3da:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     3de:	41f4d71b          	sraiw	a4,s1,0x1f
     3e2:	01b7571b          	srliw	a4,a4,0x1b
     3e6:	009707bb          	addw	a5,a4,s1
     3ea:	4057d69b          	sraiw	a3,a5,0x5
     3ee:	0306869b          	addiw	a3,a3,48
     3f2:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     3f6:	8bfd                	andi	a5,a5,31
     3f8:	9f99                	subw	a5,a5,a4
     3fa:	0307879b          	addiw	a5,a5,48
     3fe:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     402:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     406:	fb040513          	addi	a0,s0,-80
     40a:	1f5040ef          	jal	4dfe <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     40e:	60200593          	li	a1,1538
     412:	fb040513          	addi	a0,s0,-80
     416:	1d9040ef          	jal	4dee <open>
    if (fd < 0) {
     41a:	00054763          	bltz	a0,428 <outofinodes+0x6a>
      // failure is eventually expected.
      break;
    }
    close(fd);
     41e:	1b9040ef          	jal	4dd6 <close>
  for (int i = 0; i < nzz; i++) {
     422:	2485                	addiw	s1,s1,1
     424:	fb3499e3          	bne	s1,s3,3d6 <outofinodes+0x18>
     428:	4481                	li	s1,0
  }

  for (int i = 0; i < nzz; i++) {
    char name[32];
    name[0] = 'z';
     42a:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++) {
     42e:	40000993          	li	s3,1024
    name[0] = 'z';
     432:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     436:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     43a:	41f4d71b          	sraiw	a4,s1,0x1f
     43e:	01b7571b          	srliw	a4,a4,0x1b
     442:	009707bb          	addw	a5,a4,s1
     446:	4057d69b          	sraiw	a3,a5,0x5
     44a:	0306869b          	addiw	a3,a3,48
     44e:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     452:	8bfd                	andi	a5,a5,31
     454:	9f99                	subw	a5,a5,a4
     456:	0307879b          	addiw	a5,a5,48
     45a:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     45e:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     462:	fb040513          	addi	a0,s0,-80
     466:	199040ef          	jal	4dfe <unlink>
  for (int i = 0; i < nzz; i++) {
     46a:	2485                	addiw	s1,s1,1
     46c:	fd3493e3          	bne	s1,s3,432 <outofinodes+0x74>
  }
}
     470:	60a6                	ld	ra,72(sp)
     472:	6406                	ld	s0,64(sp)
     474:	74e2                	ld	s1,56(sp)
     476:	7942                	ld	s2,48(sp)
     478:	79a2                	ld	s3,40(sp)
     47a:	6161                	addi	sp,sp,80
     47c:	8082                	ret

000000000000047e <copyin>:
{
     47e:	7159                	addi	sp,sp,-112
     480:	f486                	sd	ra,104(sp)
     482:	f0a2                	sd	s0,96(sp)
     484:	eca6                	sd	s1,88(sp)
     486:	e8ca                	sd	s2,80(sp)
     488:	e4ce                	sd	s3,72(sp)
     48a:	e0d2                	sd	s4,64(sp)
     48c:	fc56                	sd	s5,56(sp)
     48e:	1880                	addi	s0,sp,112
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     490:	00007797          	auipc	a5,0x7
     494:	4d078793          	addi	a5,a5,1232 # 7960 <malloc+0x26b6>
     498:	638c                	ld	a1,0(a5)
     49a:	6790                	ld	a2,8(a5)
     49c:	6b94                	ld	a3,16(a5)
     49e:	6f98                	ld	a4,24(a5)
     4a0:	739c                	ld	a5,32(a5)
     4a2:	f8b43c23          	sd	a1,-104(s0)
     4a6:	fac43023          	sd	a2,-96(s0)
     4aa:	fad43423          	sd	a3,-88(s0)
     4ae:	fae43823          	sd	a4,-80(s0)
     4b2:	faf43c23          	sd	a5,-72(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     4b6:	f9840913          	addi	s2,s0,-104
     4ba:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     4be:	00005a17          	auipc	s4,0x5
     4c2:	042a0a13          	addi	s4,s4,66 # 5500 <malloc+0x256>
    uint64 addr = addrs[ai];
     4c6:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     4ca:	20100593          	li	a1,513
     4ce:	8552                	mv	a0,s4
     4d0:	11f040ef          	jal	4dee <open>
     4d4:	84aa                	mv	s1,a0
    if (fd < 0) {
     4d6:	06054763          	bltz	a0,544 <copyin+0xc6>
    int n = write(fd, (void *)addr, 8192);
     4da:	6609                	lui	a2,0x2
     4dc:	85ce                	mv	a1,s3
     4de:	0f1040ef          	jal	4dce <write>
    if (n >= 0) {
     4e2:	06055a63          	bgez	a0,556 <copyin+0xd8>
    close(fd);
     4e6:	8526                	mv	a0,s1
     4e8:	0ef040ef          	jal	4dd6 <close>
    unlink("copyin1");
     4ec:	8552                	mv	a0,s4
     4ee:	111040ef          	jal	4dfe <unlink>
    n = write(1, (char *)addr, 8192);
     4f2:	6609                	lui	a2,0x2
     4f4:	85ce                	mv	a1,s3
     4f6:	4505                	li	a0,1
     4f8:	0d7040ef          	jal	4dce <write>
    if (n > 0) {
     4fc:	06a04863          	bgtz	a0,56c <copyin+0xee>
    if (pipe(fds) < 0) {
     500:	f9040513          	addi	a0,s0,-112
     504:	0bb040ef          	jal	4dbe <pipe>
     508:	06054d63          	bltz	a0,582 <copyin+0x104>
    n = write(fds[1], (char *)addr, 8192);
     50c:	6609                	lui	a2,0x2
     50e:	85ce                	mv	a1,s3
     510:	f9442503          	lw	a0,-108(s0)
     514:	0bb040ef          	jal	4dce <write>
    if (n > 0) {
     518:	06a04e63          	bgtz	a0,594 <copyin+0x116>
    close(fds[0]);
     51c:	f9042503          	lw	a0,-112(s0)
     520:	0b7040ef          	jal	4dd6 <close>
    close(fds[1]);
     524:	f9442503          	lw	a0,-108(s0)
     528:	0af040ef          	jal	4dd6 <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     52c:	0921                	addi	s2,s2,8
     52e:	f9591ce3          	bne	s2,s5,4c6 <copyin+0x48>
}
     532:	70a6                	ld	ra,104(sp)
     534:	7406                	ld	s0,96(sp)
     536:	64e6                	ld	s1,88(sp)
     538:	6946                	ld	s2,80(sp)
     53a:	69a6                	ld	s3,72(sp)
     53c:	6a06                	ld	s4,64(sp)
     53e:	7ae2                	ld	s5,56(sp)
     540:	6165                	addi	sp,sp,112
     542:	8082                	ret
      printf("open(copyin1) failed\n");
     544:	00005517          	auipc	a0,0x5
     548:	fc450513          	addi	a0,a0,-60 # 5508 <malloc+0x25e>
     54c:	4ab040ef          	jal	51f6 <printf>
      exit(1);
     550:	4505                	li	a0,1
     552:	05d040ef          	jal	4dae <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void *)addr, n);
     556:	862a                	mv	a2,a0
     558:	85ce                	mv	a1,s3
     55a:	00005517          	auipc	a0,0x5
     55e:	fc650513          	addi	a0,a0,-58 # 5520 <malloc+0x276>
     562:	495040ef          	jal	51f6 <printf>
      exit(1);
     566:	4505                	li	a0,1
     568:	047040ef          	jal	4dae <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     56c:	862a                	mv	a2,a0
     56e:	85ce                	mv	a1,s3
     570:	00005517          	auipc	a0,0x5
     574:	fe050513          	addi	a0,a0,-32 # 5550 <malloc+0x2a6>
     578:	47f040ef          	jal	51f6 <printf>
      exit(1);
     57c:	4505                	li	a0,1
     57e:	031040ef          	jal	4dae <exit>
      printf("pipe() failed\n");
     582:	00005517          	auipc	a0,0x5
     586:	ffe50513          	addi	a0,a0,-2 # 5580 <malloc+0x2d6>
     58a:	46d040ef          	jal	51f6 <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	01f040ef          	jal	4dae <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     594:	862a                	mv	a2,a0
     596:	85ce                	mv	a1,s3
     598:	00005517          	auipc	a0,0x5
     59c:	ff850513          	addi	a0,a0,-8 # 5590 <malloc+0x2e6>
     5a0:	457040ef          	jal	51f6 <printf>
      exit(1);
     5a4:	4505                	li	a0,1
     5a6:	009040ef          	jal	4dae <exit>

00000000000005aa <copyout>:
{
     5aa:	7119                	addi	sp,sp,-128
     5ac:	fc86                	sd	ra,120(sp)
     5ae:	f8a2                	sd	s0,112(sp)
     5b0:	f4a6                	sd	s1,104(sp)
     5b2:	f0ca                	sd	s2,96(sp)
     5b4:	ecce                	sd	s3,88(sp)
     5b6:	e8d2                	sd	s4,80(sp)
     5b8:	e4d6                	sd	s5,72(sp)
     5ba:	e0da                	sd	s6,64(sp)
     5bc:	0100                	addi	s0,sp,128
  uint64 addrs[] = {0LL,          0x80000000LL, 0x3fffffe000,
     5be:	00007797          	auipc	a5,0x7
     5c2:	3a278793          	addi	a5,a5,930 # 7960 <malloc+0x26b6>
     5c6:	7788                	ld	a0,40(a5)
     5c8:	7b8c                	ld	a1,48(a5)
     5ca:	7f90                	ld	a2,56(a5)
     5cc:	63b4                	ld	a3,64(a5)
     5ce:	67b8                	ld	a4,72(a5)
     5d0:	6bbc                	ld	a5,80(a5)
     5d2:	f8a43823          	sd	a0,-112(s0)
     5d6:	f8b43c23          	sd	a1,-104(s0)
     5da:	fac43023          	sd	a2,-96(s0)
     5de:	fad43423          	sd	a3,-88(s0)
     5e2:	fae43823          	sd	a4,-80(s0)
     5e6:	faf43c23          	sd	a5,-72(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     5ea:	f9040913          	addi	s2,s0,-112
     5ee:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
     5f2:	00005a17          	auipc	s4,0x5
     5f6:	fcea0a13          	addi	s4,s4,-50 # 55c0 <malloc+0x316>
    n = write(fds[1], "x", 1);
     5fa:	00005a97          	auipc	s5,0x5
     5fe:	e5ea8a93          	addi	s5,s5,-418 # 5458 <malloc+0x1ae>
    uint64 addr = addrs[ai];
     602:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     606:	4581                	li	a1,0
     608:	8552                	mv	a0,s4
     60a:	7e4040ef          	jal	4dee <open>
     60e:	84aa                	mv	s1,a0
    if (fd < 0) {
     610:	06054763          	bltz	a0,67e <copyout+0xd4>
    int n = read(fd, (void *)addr, 8192);
     614:	6609                	lui	a2,0x2
     616:	85ce                	mv	a1,s3
     618:	7ae040ef          	jal	4dc6 <read>
    if (n > 0) {
     61c:	06a04a63          	bgtz	a0,690 <copyout+0xe6>
    close(fd);
     620:	8526                	mv	a0,s1
     622:	7b4040ef          	jal	4dd6 <close>
    if (pipe(fds) < 0) {
     626:	f8840513          	addi	a0,s0,-120
     62a:	794040ef          	jal	4dbe <pipe>
     62e:	06054c63          	bltz	a0,6a6 <copyout+0xfc>
    n = write(fds[1], "x", 1);
     632:	4605                	li	a2,1
     634:	85d6                	mv	a1,s5
     636:	f8c42503          	lw	a0,-116(s0)
     63a:	794040ef          	jal	4dce <write>
    if (n != 1) {
     63e:	4785                	li	a5,1
     640:	06f51c63          	bne	a0,a5,6b8 <copyout+0x10e>
    n = read(fds[0], (void *)addr, 8192);
     644:	6609                	lui	a2,0x2
     646:	85ce                	mv	a1,s3
     648:	f8842503          	lw	a0,-120(s0)
     64c:	77a040ef          	jal	4dc6 <read>
    if (n > 0) {
     650:	06a04d63          	bgtz	a0,6ca <copyout+0x120>
    close(fds[0]);
     654:	f8842503          	lw	a0,-120(s0)
     658:	77e040ef          	jal	4dd6 <close>
    close(fds[1]);
     65c:	f8c42503          	lw	a0,-116(s0)
     660:	776040ef          	jal	4dd6 <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     664:	0921                	addi	s2,s2,8
     666:	f9691ee3          	bne	s2,s6,602 <copyout+0x58>
}
     66a:	70e6                	ld	ra,120(sp)
     66c:	7446                	ld	s0,112(sp)
     66e:	74a6                	ld	s1,104(sp)
     670:	7906                	ld	s2,96(sp)
     672:	69e6                	ld	s3,88(sp)
     674:	6a46                	ld	s4,80(sp)
     676:	6aa6                	ld	s5,72(sp)
     678:	6b06                	ld	s6,64(sp)
     67a:	6109                	addi	sp,sp,128
     67c:	8082                	ret
      printf("open(README) failed\n");
     67e:	00005517          	auipc	a0,0x5
     682:	f4a50513          	addi	a0,a0,-182 # 55c8 <malloc+0x31e>
     686:	371040ef          	jal	51f6 <printf>
      exit(1);
     68a:	4505                	li	a0,1
     68c:	722040ef          	jal	4dae <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     690:	862a                	mv	a2,a0
     692:	85ce                	mv	a1,s3
     694:	00005517          	auipc	a0,0x5
     698:	f4c50513          	addi	a0,a0,-180 # 55e0 <malloc+0x336>
     69c:	35b040ef          	jal	51f6 <printf>
      exit(1);
     6a0:	4505                	li	a0,1
     6a2:	70c040ef          	jal	4dae <exit>
      printf("pipe() failed\n");
     6a6:	00005517          	auipc	a0,0x5
     6aa:	eda50513          	addi	a0,a0,-294 # 5580 <malloc+0x2d6>
     6ae:	349040ef          	jal	51f6 <printf>
      exit(1);
     6b2:	4505                	li	a0,1
     6b4:	6fa040ef          	jal	4dae <exit>
      printf("pipe write failed\n");
     6b8:	00005517          	auipc	a0,0x5
     6bc:	f5850513          	addi	a0,a0,-168 # 5610 <malloc+0x366>
     6c0:	337040ef          	jal	51f6 <printf>
      exit(1);
     6c4:	4505                	li	a0,1
     6c6:	6e8040ef          	jal	4dae <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     6ca:	862a                	mv	a2,a0
     6cc:	85ce                	mv	a1,s3
     6ce:	00005517          	auipc	a0,0x5
     6d2:	f5a50513          	addi	a0,a0,-166 # 5628 <malloc+0x37e>
     6d6:	321040ef          	jal	51f6 <printf>
      exit(1);
     6da:	4505                	li	a0,1
     6dc:	6d2040ef          	jal	4dae <exit>

00000000000006e0 <truncate1>:
{
     6e0:	711d                	addi	sp,sp,-96
     6e2:	ec86                	sd	ra,88(sp)
     6e4:	e8a2                	sd	s0,80(sp)
     6e6:	e4a6                	sd	s1,72(sp)
     6e8:	e0ca                	sd	s2,64(sp)
     6ea:	fc4e                	sd	s3,56(sp)
     6ec:	f852                	sd	s4,48(sp)
     6ee:	f456                	sd	s5,40(sp)
     6f0:	1080                	addi	s0,sp,96
     6f2:	8aaa                	mv	s5,a0
  unlink("truncfile");
     6f4:	00005517          	auipc	a0,0x5
     6f8:	d4c50513          	addi	a0,a0,-692 # 5440 <malloc+0x196>
     6fc:	702040ef          	jal	4dfe <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     700:	60100593          	li	a1,1537
     704:	00005517          	auipc	a0,0x5
     708:	d3c50513          	addi	a0,a0,-708 # 5440 <malloc+0x196>
     70c:	6e2040ef          	jal	4dee <open>
     710:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     712:	4611                	li	a2,4
     714:	00005597          	auipc	a1,0x5
     718:	d3c58593          	addi	a1,a1,-708 # 5450 <malloc+0x1a6>
     71c:	6b2040ef          	jal	4dce <write>
  close(fd1);
     720:	8526                	mv	a0,s1
     722:	6b4040ef          	jal	4dd6 <close>
  int fd2 = open("truncfile", O_RDONLY);
     726:	4581                	li	a1,0
     728:	00005517          	auipc	a0,0x5
     72c:	d1850513          	addi	a0,a0,-744 # 5440 <malloc+0x196>
     730:	6be040ef          	jal	4dee <open>
     734:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     736:	02000613          	li	a2,32
     73a:	fa040593          	addi	a1,s0,-96
     73e:	688040ef          	jal	4dc6 <read>
  if (n != 4) {
     742:	4791                	li	a5,4
     744:	0af51863          	bne	a0,a5,7f4 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     748:	40100593          	li	a1,1025
     74c:	00005517          	auipc	a0,0x5
     750:	cf450513          	addi	a0,a0,-780 # 5440 <malloc+0x196>
     754:	69a040ef          	jal	4dee <open>
     758:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     75a:	4581                	li	a1,0
     75c:	00005517          	auipc	a0,0x5
     760:	ce450513          	addi	a0,a0,-796 # 5440 <malloc+0x196>
     764:	68a040ef          	jal	4dee <open>
     768:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     76a:	02000613          	li	a2,32
     76e:	fa040593          	addi	a1,s0,-96
     772:	654040ef          	jal	4dc6 <read>
     776:	8a2a                	mv	s4,a0
  if (n != 0) {
     778:	e949                	bnez	a0,80a <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     77a:	02000613          	li	a2,32
     77e:	fa040593          	addi	a1,s0,-96
     782:	8526                	mv	a0,s1
     784:	642040ef          	jal	4dc6 <read>
     788:	8a2a                	mv	s4,a0
  if (n != 0) {
     78a:	e155                	bnez	a0,82e <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     78c:	4619                	li	a2,6
     78e:	00005597          	auipc	a1,0x5
     792:	f2a58593          	addi	a1,a1,-214 # 56b8 <malloc+0x40e>
     796:	854e                	mv	a0,s3
     798:	636040ef          	jal	4dce <write>
  n = read(fd3, buf, sizeof(buf));
     79c:	02000613          	li	a2,32
     7a0:	fa040593          	addi	a1,s0,-96
     7a4:	854a                	mv	a0,s2
     7a6:	620040ef          	jal	4dc6 <read>
  if (n != 6) {
     7aa:	4799                	li	a5,6
     7ac:	0af51363          	bne	a0,a5,852 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     7b0:	02000613          	li	a2,32
     7b4:	fa040593          	addi	a1,s0,-96
     7b8:	8526                	mv	a0,s1
     7ba:	60c040ef          	jal	4dc6 <read>
  if (n != 2) {
     7be:	4789                	li	a5,2
     7c0:	0af51463          	bne	a0,a5,868 <truncate1+0x188>
  unlink("truncfile");
     7c4:	00005517          	auipc	a0,0x5
     7c8:	c7c50513          	addi	a0,a0,-900 # 5440 <malloc+0x196>
     7cc:	632040ef          	jal	4dfe <unlink>
  close(fd1);
     7d0:	854e                	mv	a0,s3
     7d2:	604040ef          	jal	4dd6 <close>
  close(fd2);
     7d6:	8526                	mv	a0,s1
     7d8:	5fe040ef          	jal	4dd6 <close>
  close(fd3);
     7dc:	854a                	mv	a0,s2
     7de:	5f8040ef          	jal	4dd6 <close>
}
     7e2:	60e6                	ld	ra,88(sp)
     7e4:	6446                	ld	s0,80(sp)
     7e6:	64a6                	ld	s1,72(sp)
     7e8:	6906                	ld	s2,64(sp)
     7ea:	79e2                	ld	s3,56(sp)
     7ec:	7a42                	ld	s4,48(sp)
     7ee:	7aa2                	ld	s5,40(sp)
     7f0:	6125                	addi	sp,sp,96
     7f2:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     7f4:	862a                	mv	a2,a0
     7f6:	85d6                	mv	a1,s5
     7f8:	00005517          	auipc	a0,0x5
     7fc:	e6050513          	addi	a0,a0,-416 # 5658 <malloc+0x3ae>
     800:	1f7040ef          	jal	51f6 <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	5a8040ef          	jal	4dae <exit>
    printf("aaa fd3=%d\n", fd3);
     80a:	85ca                	mv	a1,s2
     80c:	00005517          	auipc	a0,0x5
     810:	e6c50513          	addi	a0,a0,-404 # 5678 <malloc+0x3ce>
     814:	1e3040ef          	jal	51f6 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     818:	8652                	mv	a2,s4
     81a:	85d6                	mv	a1,s5
     81c:	00005517          	auipc	a0,0x5
     820:	e6c50513          	addi	a0,a0,-404 # 5688 <malloc+0x3de>
     824:	1d3040ef          	jal	51f6 <printf>
    exit(1);
     828:	4505                	li	a0,1
     82a:	584040ef          	jal	4dae <exit>
    printf("bbb fd2=%d\n", fd2);
     82e:	85a6                	mv	a1,s1
     830:	00005517          	auipc	a0,0x5
     834:	e7850513          	addi	a0,a0,-392 # 56a8 <malloc+0x3fe>
     838:	1bf040ef          	jal	51f6 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     83c:	8652                	mv	a2,s4
     83e:	85d6                	mv	a1,s5
     840:	00005517          	auipc	a0,0x5
     844:	e4850513          	addi	a0,a0,-440 # 5688 <malloc+0x3de>
     848:	1af040ef          	jal	51f6 <printf>
    exit(1);
     84c:	4505                	li	a0,1
     84e:	560040ef          	jal	4dae <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     852:	862a                	mv	a2,a0
     854:	85d6                	mv	a1,s5
     856:	00005517          	auipc	a0,0x5
     85a:	e6a50513          	addi	a0,a0,-406 # 56c0 <malloc+0x416>
     85e:	199040ef          	jal	51f6 <printf>
    exit(1);
     862:	4505                	li	a0,1
     864:	54a040ef          	jal	4dae <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     868:	862a                	mv	a2,a0
     86a:	85d6                	mv	a1,s5
     86c:	00005517          	auipc	a0,0x5
     870:	e7450513          	addi	a0,a0,-396 # 56e0 <malloc+0x436>
     874:	183040ef          	jal	51f6 <printf>
    exit(1);
     878:	4505                	li	a0,1
     87a:	534040ef          	jal	4dae <exit>

000000000000087e <writetest>:
{
     87e:	7139                	addi	sp,sp,-64
     880:	fc06                	sd	ra,56(sp)
     882:	f822                	sd	s0,48(sp)
     884:	f426                	sd	s1,40(sp)
     886:	f04a                	sd	s2,32(sp)
     888:	ec4e                	sd	s3,24(sp)
     88a:	e852                	sd	s4,16(sp)
     88c:	e456                	sd	s5,8(sp)
     88e:	e05a                	sd	s6,0(sp)
     890:	0080                	addi	s0,sp,64
     892:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE | O_RDWR);
     894:	20200593          	li	a1,514
     898:	00005517          	auipc	a0,0x5
     89c:	e6850513          	addi	a0,a0,-408 # 5700 <malloc+0x456>
     8a0:	54e040ef          	jal	4dee <open>
  if (fd < 0) {
     8a4:	08054f63          	bltz	a0,942 <writetest+0xc4>
     8a8:	892a                	mv	s2,a0
     8aa:	4481                	li	s1,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     8ac:	00005997          	auipc	s3,0x5
     8b0:	e7c98993          	addi	s3,s3,-388 # 5728 <malloc+0x47e>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     8b4:	00005a97          	auipc	s5,0x5
     8b8:	eaca8a93          	addi	s5,s5,-340 # 5760 <malloc+0x4b6>
  for (i = 0; i < N; i++) {
     8bc:	06400a13          	li	s4,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     8c0:	4629                	li	a2,10
     8c2:	85ce                	mv	a1,s3
     8c4:	854a                	mv	a0,s2
     8c6:	508040ef          	jal	4dce <write>
     8ca:	47a9                	li	a5,10
     8cc:	08f51563          	bne	a0,a5,956 <writetest+0xd8>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     8d0:	4629                	li	a2,10
     8d2:	85d6                	mv	a1,s5
     8d4:	854a                	mv	a0,s2
     8d6:	4f8040ef          	jal	4dce <write>
     8da:	47a9                	li	a5,10
     8dc:	08f51863          	bne	a0,a5,96c <writetest+0xee>
  for (i = 0; i < N; i++) {
     8e0:	2485                	addiw	s1,s1,1
     8e2:	fd449fe3          	bne	s1,s4,8c0 <writetest+0x42>
  close(fd);
     8e6:	854a                	mv	a0,s2
     8e8:	4ee040ef          	jal	4dd6 <close>
  fd = open("small", O_RDONLY);
     8ec:	4581                	li	a1,0
     8ee:	00005517          	auipc	a0,0x5
     8f2:	e1250513          	addi	a0,a0,-494 # 5700 <malloc+0x456>
     8f6:	4f8040ef          	jal	4dee <open>
     8fa:	84aa                	mv	s1,a0
  if (fd < 0) {
     8fc:	08054363          	bltz	a0,982 <writetest+0x104>
  i = read(fd, buf, N * SZ * 2);
     900:	7d000613          	li	a2,2000
     904:	0000c597          	auipc	a1,0xc
     908:	3b458593          	addi	a1,a1,948 # ccb8 <buf>
     90c:	4ba040ef          	jal	4dc6 <read>
  if (i != N * SZ * 2) {
     910:	7d000793          	li	a5,2000
     914:	08f51163          	bne	a0,a5,996 <writetest+0x118>
  close(fd);
     918:	8526                	mv	a0,s1
     91a:	4bc040ef          	jal	4dd6 <close>
  if (unlink("small") < 0) {
     91e:	00005517          	auipc	a0,0x5
     922:	de250513          	addi	a0,a0,-542 # 5700 <malloc+0x456>
     926:	4d8040ef          	jal	4dfe <unlink>
     92a:	08054063          	bltz	a0,9aa <writetest+0x12c>
}
     92e:	70e2                	ld	ra,56(sp)
     930:	7442                	ld	s0,48(sp)
     932:	74a2                	ld	s1,40(sp)
     934:	7902                	ld	s2,32(sp)
     936:	69e2                	ld	s3,24(sp)
     938:	6a42                	ld	s4,16(sp)
     93a:	6aa2                	ld	s5,8(sp)
     93c:	6b02                	ld	s6,0(sp)
     93e:	6121                	addi	sp,sp,64
     940:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     942:	85da                	mv	a1,s6
     944:	00005517          	auipc	a0,0x5
     948:	dc450513          	addi	a0,a0,-572 # 5708 <malloc+0x45e>
     94c:	0ab040ef          	jal	51f6 <printf>
    exit(1);
     950:	4505                	li	a0,1
     952:	45c040ef          	jal	4dae <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     956:	8626                	mv	a2,s1
     958:	85da                	mv	a1,s6
     95a:	00005517          	auipc	a0,0x5
     95e:	dde50513          	addi	a0,a0,-546 # 5738 <malloc+0x48e>
     962:	095040ef          	jal	51f6 <printf>
      exit(1);
     966:	4505                	li	a0,1
     968:	446040ef          	jal	4dae <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     96c:	8626                	mv	a2,s1
     96e:	85da                	mv	a1,s6
     970:	00005517          	auipc	a0,0x5
     974:	e0050513          	addi	a0,a0,-512 # 5770 <malloc+0x4c6>
     978:	07f040ef          	jal	51f6 <printf>
      exit(1);
     97c:	4505                	li	a0,1
     97e:	430040ef          	jal	4dae <exit>
    printf("%s: error: open small failed!\n", s);
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	e1450513          	addi	a0,a0,-492 # 5798 <malloc+0x4ee>
     98c:	06b040ef          	jal	51f6 <printf>
    exit(1);
     990:	4505                	li	a0,1
     992:	41c040ef          	jal	4dae <exit>
    printf("%s: read failed\n", s);
     996:	85da                	mv	a1,s6
     998:	00005517          	auipc	a0,0x5
     99c:	e2050513          	addi	a0,a0,-480 # 57b8 <malloc+0x50e>
     9a0:	057040ef          	jal	51f6 <printf>
    exit(1);
     9a4:	4505                	li	a0,1
     9a6:	408040ef          	jal	4dae <exit>
    printf("%s: unlink small failed\n", s);
     9aa:	85da                	mv	a1,s6
     9ac:	00005517          	auipc	a0,0x5
     9b0:	e2450513          	addi	a0,a0,-476 # 57d0 <malloc+0x526>
     9b4:	043040ef          	jal	51f6 <printf>
    exit(1);
     9b8:	4505                	li	a0,1
     9ba:	3f4040ef          	jal	4dae <exit>

00000000000009be <writebig>:
{
     9be:	7139                	addi	sp,sp,-64
     9c0:	fc06                	sd	ra,56(sp)
     9c2:	f822                	sd	s0,48(sp)
     9c4:	f426                	sd	s1,40(sp)
     9c6:	f04a                	sd	s2,32(sp)
     9c8:	ec4e                	sd	s3,24(sp)
     9ca:	e852                	sd	s4,16(sp)
     9cc:	e456                	sd	s5,8(sp)
     9ce:	0080                	addi	s0,sp,64
     9d0:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE | O_RDWR);
     9d2:	20200593          	li	a1,514
     9d6:	00005517          	auipc	a0,0x5
     9da:	e1a50513          	addi	a0,a0,-486 # 57f0 <malloc+0x546>
     9de:	410040ef          	jal	4dee <open>
     9e2:	89aa                	mv	s3,a0
  for (i = 0; i < MAXFILE; i++) {
     9e4:	4481                	li	s1,0
    ((int *)buf)[0] = i;
     9e6:	0000c917          	auipc	s2,0xc
     9ea:	2d290913          	addi	s2,s2,722 # ccb8 <buf>
  for (i = 0; i < MAXFILE; i++) {
     9ee:	10c00a13          	li	s4,268
  if (fd < 0) {
     9f2:	06054463          	bltz	a0,a5a <writebig+0x9c>
    ((int *)buf)[0] = i;
     9f6:	00992023          	sw	s1,0(s2)
    if (write(fd, buf, BSIZE) != BSIZE) {
     9fa:	40000613          	li	a2,1024
     9fe:	85ca                	mv	a1,s2
     a00:	854e                	mv	a0,s3
     a02:	3cc040ef          	jal	4dce <write>
     a06:	40000793          	li	a5,1024
     a0a:	06f51263          	bne	a0,a5,a6e <writebig+0xb0>
  for (i = 0; i < MAXFILE; i++) {
     a0e:	2485                	addiw	s1,s1,1
     a10:	ff4493e3          	bne	s1,s4,9f6 <writebig+0x38>
  close(fd);
     a14:	854e                	mv	a0,s3
     a16:	3c0040ef          	jal	4dd6 <close>
  fd = open("big", O_RDONLY);
     a1a:	4581                	li	a1,0
     a1c:	00005517          	auipc	a0,0x5
     a20:	dd450513          	addi	a0,a0,-556 # 57f0 <malloc+0x546>
     a24:	3ca040ef          	jal	4dee <open>
     a28:	89aa                	mv	s3,a0
  n = 0;
     a2a:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a2c:	0000c917          	auipc	s2,0xc
     a30:	28c90913          	addi	s2,s2,652 # ccb8 <buf>
  if (fd < 0) {
     a34:	04054863          	bltz	a0,a84 <writebig+0xc6>
    i = read(fd, buf, BSIZE);
     a38:	40000613          	li	a2,1024
     a3c:	85ca                	mv	a1,s2
     a3e:	854e                	mv	a0,s3
     a40:	386040ef          	jal	4dc6 <read>
    if (i == 0) {
     a44:	c931                	beqz	a0,a98 <writebig+0xda>
    } else if (i != BSIZE) {
     a46:	40000793          	li	a5,1024
     a4a:	08f51a63          	bne	a0,a5,ade <writebig+0x120>
    if (((int *)buf)[0] != n) {
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0a969163          	bne	a3,s1,af4 <writebig+0x136>
    n++;
     a56:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	b7c5                	j	a38 <writebig+0x7a>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00005517          	auipc	a0,0x5
     a60:	d9c50513          	addi	a0,a0,-612 # 57f8 <malloc+0x54e>
     a64:	792040ef          	jal	51f6 <printf>
    exit(1);
     a68:	4505                	li	a0,1
     a6a:	344040ef          	jal	4dae <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     a6e:	8626                	mv	a2,s1
     a70:	85d6                	mv	a1,s5
     a72:	00005517          	auipc	a0,0x5
     a76:	da650513          	addi	a0,a0,-602 # 5818 <malloc+0x56e>
     a7a:	77c040ef          	jal	51f6 <printf>
      exit(1);
     a7e:	4505                	li	a0,1
     a80:	32e040ef          	jal	4dae <exit>
    printf("%s: error: open big failed!\n", s);
     a84:	85d6                	mv	a1,s5
     a86:	00005517          	auipc	a0,0x5
     a8a:	dba50513          	addi	a0,a0,-582 # 5840 <malloc+0x596>
     a8e:	768040ef          	jal	51f6 <printf>
    exit(1);
     a92:	4505                	li	a0,1
     a94:	31a040ef          	jal	4dae <exit>
      if (n != MAXFILE) {
     a98:	10c00793          	li	a5,268
     a9c:	02f49663          	bne	s1,a5,ac8 <writebig+0x10a>
  close(fd);
     aa0:	854e                	mv	a0,s3
     aa2:	334040ef          	jal	4dd6 <close>
  if (unlink("big") < 0) {
     aa6:	00005517          	auipc	a0,0x5
     aaa:	d4a50513          	addi	a0,a0,-694 # 57f0 <malloc+0x546>
     aae:	350040ef          	jal	4dfe <unlink>
     ab2:	04054c63          	bltz	a0,b0a <writebig+0x14c>
}
     ab6:	70e2                	ld	ra,56(sp)
     ab8:	7442                	ld	s0,48(sp)
     aba:	74a2                	ld	s1,40(sp)
     abc:	7902                	ld	s2,32(sp)
     abe:	69e2                	ld	s3,24(sp)
     ac0:	6a42                	ld	s4,16(sp)
     ac2:	6aa2                	ld	s5,8(sp)
     ac4:	6121                	addi	sp,sp,64
     ac6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ac8:	8626                	mv	a2,s1
     aca:	85d6                	mv	a1,s5
     acc:	00005517          	auipc	a0,0x5
     ad0:	d9450513          	addi	a0,a0,-620 # 5860 <malloc+0x5b6>
     ad4:	722040ef          	jal	51f6 <printf>
        exit(1);
     ad8:	4505                	li	a0,1
     ada:	2d4040ef          	jal	4dae <exit>
      printf("%s: read failed %d\n", s, i);
     ade:	862a                	mv	a2,a0
     ae0:	85d6                	mv	a1,s5
     ae2:	00005517          	auipc	a0,0x5
     ae6:	da650513          	addi	a0,a0,-602 # 5888 <malloc+0x5de>
     aea:	70c040ef          	jal	51f6 <printf>
      exit(1);
     aee:	4505                	li	a0,1
     af0:	2be040ef          	jal	4dae <exit>
      printf("%s: read content of block %d is %d\n", s, n, ((int *)buf)[0]);
     af4:	8626                	mv	a2,s1
     af6:	85d6                	mv	a1,s5
     af8:	00005517          	auipc	a0,0x5
     afc:	da850513          	addi	a0,a0,-600 # 58a0 <malloc+0x5f6>
     b00:	6f6040ef          	jal	51f6 <printf>
      exit(1);
     b04:	4505                	li	a0,1
     b06:	2a8040ef          	jal	4dae <exit>
    printf("%s: unlink big failed\n", s);
     b0a:	85d6                	mv	a1,s5
     b0c:	00005517          	auipc	a0,0x5
     b10:	dbc50513          	addi	a0,a0,-580 # 58c8 <malloc+0x61e>
     b14:	6e2040ef          	jal	51f6 <printf>
    exit(1);
     b18:	4505                	li	a0,1
     b1a:	294040ef          	jal	4dae <exit>

0000000000000b1e <unlinkread>:
{
     b1e:	7179                	addi	sp,sp,-48
     b20:	f406                	sd	ra,40(sp)
     b22:	f022                	sd	s0,32(sp)
     b24:	ec26                	sd	s1,24(sp)
     b26:	e84a                	sd	s2,16(sp)
     b28:	e44e                	sd	s3,8(sp)
     b2a:	1800                	addi	s0,sp,48
     b2c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b2e:	20200593          	li	a1,514
     b32:	00005517          	auipc	a0,0x5
     b36:	dae50513          	addi	a0,a0,-594 # 58e0 <malloc+0x636>
     b3a:	2b4040ef          	jal	4dee <open>
  if (fd < 0) {
     b3e:	0a054f63          	bltz	a0,bfc <unlinkread+0xde>
     b42:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b44:	4615                	li	a2,5
     b46:	00005597          	auipc	a1,0x5
     b4a:	dca58593          	addi	a1,a1,-566 # 5910 <malloc+0x666>
     b4e:	280040ef          	jal	4dce <write>
  close(fd);
     b52:	8526                	mv	a0,s1
     b54:	282040ef          	jal	4dd6 <close>
  fd = open("unlinkread", O_RDWR);
     b58:	4589                	li	a1,2
     b5a:	00005517          	auipc	a0,0x5
     b5e:	d8650513          	addi	a0,a0,-634 # 58e0 <malloc+0x636>
     b62:	28c040ef          	jal	4dee <open>
     b66:	84aa                	mv	s1,a0
  if (fd < 0) {
     b68:	0a054463          	bltz	a0,c10 <unlinkread+0xf2>
  if (unlink("unlinkread") != 0) {
     b6c:	00005517          	auipc	a0,0x5
     b70:	d7450513          	addi	a0,a0,-652 # 58e0 <malloc+0x636>
     b74:	28a040ef          	jal	4dfe <unlink>
     b78:	e555                	bnez	a0,c24 <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     b7a:	20200593          	li	a1,514
     b7e:	00005517          	auipc	a0,0x5
     b82:	d6250513          	addi	a0,a0,-670 # 58e0 <malloc+0x636>
     b86:	268040ef          	jal	4dee <open>
     b8a:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     b8c:	460d                	li	a2,3
     b8e:	00005597          	auipc	a1,0x5
     b92:	dca58593          	addi	a1,a1,-566 # 5958 <malloc+0x6ae>
     b96:	238040ef          	jal	4dce <write>
  close(fd1);
     b9a:	854a                	mv	a0,s2
     b9c:	23a040ef          	jal	4dd6 <close>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     ba0:	660d                	lui	a2,0x3
     ba2:	0000c597          	auipc	a1,0xc
     ba6:	11658593          	addi	a1,a1,278 # ccb8 <buf>
     baa:	8526                	mv	a0,s1
     bac:	21a040ef          	jal	4dc6 <read>
     bb0:	4795                	li	a5,5
     bb2:	08f51363          	bne	a0,a5,c38 <unlinkread+0x11a>
  if (buf[0] != 'h') {
     bb6:	0000c717          	auipc	a4,0xc
     bba:	10274703          	lbu	a4,258(a4) # ccb8 <buf>
     bbe:	06800793          	li	a5,104
     bc2:	08f71563          	bne	a4,a5,c4c <unlinkread+0x12e>
  if (write(fd, buf, 10) != 10) {
     bc6:	4629                	li	a2,10
     bc8:	0000c597          	auipc	a1,0xc
     bcc:	0f058593          	addi	a1,a1,240 # ccb8 <buf>
     bd0:	8526                	mv	a0,s1
     bd2:	1fc040ef          	jal	4dce <write>
     bd6:	47a9                	li	a5,10
     bd8:	08f51463          	bne	a0,a5,c60 <unlinkread+0x142>
  close(fd);
     bdc:	8526                	mv	a0,s1
     bde:	1f8040ef          	jal	4dd6 <close>
  unlink("unlinkread");
     be2:	00005517          	auipc	a0,0x5
     be6:	cfe50513          	addi	a0,a0,-770 # 58e0 <malloc+0x636>
     bea:	214040ef          	jal	4dfe <unlink>
}
     bee:	70a2                	ld	ra,40(sp)
     bf0:	7402                	ld	s0,32(sp)
     bf2:	64e2                	ld	s1,24(sp)
     bf4:	6942                	ld	s2,16(sp)
     bf6:	69a2                	ld	s3,8(sp)
     bf8:	6145                	addi	sp,sp,48
     bfa:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     bfc:	85ce                	mv	a1,s3
     bfe:	00005517          	auipc	a0,0x5
     c02:	cf250513          	addi	a0,a0,-782 # 58f0 <malloc+0x646>
     c06:	5f0040ef          	jal	51f6 <printf>
    exit(1);
     c0a:	4505                	li	a0,1
     c0c:	1a2040ef          	jal	4dae <exit>
    printf("%s: open unlinkread failed\n", s);
     c10:	85ce                	mv	a1,s3
     c12:	00005517          	auipc	a0,0x5
     c16:	d0650513          	addi	a0,a0,-762 # 5918 <malloc+0x66e>
     c1a:	5dc040ef          	jal	51f6 <printf>
    exit(1);
     c1e:	4505                	li	a0,1
     c20:	18e040ef          	jal	4dae <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c24:	85ce                	mv	a1,s3
     c26:	00005517          	auipc	a0,0x5
     c2a:	d1250513          	addi	a0,a0,-750 # 5938 <malloc+0x68e>
     c2e:	5c8040ef          	jal	51f6 <printf>
    exit(1);
     c32:	4505                	li	a0,1
     c34:	17a040ef          	jal	4dae <exit>
    printf("%s: unlinkread read failed", s);
     c38:	85ce                	mv	a1,s3
     c3a:	00005517          	auipc	a0,0x5
     c3e:	d2650513          	addi	a0,a0,-730 # 5960 <malloc+0x6b6>
     c42:	5b4040ef          	jal	51f6 <printf>
    exit(1);
     c46:	4505                	li	a0,1
     c48:	166040ef          	jal	4dae <exit>
    printf("%s: unlinkread wrong data\n", s);
     c4c:	85ce                	mv	a1,s3
     c4e:	00005517          	auipc	a0,0x5
     c52:	d3250513          	addi	a0,a0,-718 # 5980 <malloc+0x6d6>
     c56:	5a0040ef          	jal	51f6 <printf>
    exit(1);
     c5a:	4505                	li	a0,1
     c5c:	152040ef          	jal	4dae <exit>
    printf("%s: unlinkread write failed\n", s);
     c60:	85ce                	mv	a1,s3
     c62:	00005517          	auipc	a0,0x5
     c66:	d3e50513          	addi	a0,a0,-706 # 59a0 <malloc+0x6f6>
     c6a:	58c040ef          	jal	51f6 <printf>
    exit(1);
     c6e:	4505                	li	a0,1
     c70:	13e040ef          	jal	4dae <exit>

0000000000000c74 <linktest>:
{
     c74:	1101                	addi	sp,sp,-32
     c76:	ec06                	sd	ra,24(sp)
     c78:	e822                	sd	s0,16(sp)
     c7a:	e426                	sd	s1,8(sp)
     c7c:	e04a                	sd	s2,0(sp)
     c7e:	1000                	addi	s0,sp,32
     c80:	892a                	mv	s2,a0
  unlink("lf1");
     c82:	00005517          	auipc	a0,0x5
     c86:	d3e50513          	addi	a0,a0,-706 # 59c0 <malloc+0x716>
     c8a:	174040ef          	jal	4dfe <unlink>
  unlink("lf2");
     c8e:	00005517          	auipc	a0,0x5
     c92:	d3a50513          	addi	a0,a0,-710 # 59c8 <malloc+0x71e>
     c96:	168040ef          	jal	4dfe <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     c9a:	20200593          	li	a1,514
     c9e:	00005517          	auipc	a0,0x5
     ca2:	d2250513          	addi	a0,a0,-734 # 59c0 <malloc+0x716>
     ca6:	148040ef          	jal	4dee <open>
  if (fd < 0) {
     caa:	0c054f63          	bltz	a0,d88 <linktest+0x114>
     cae:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ) {
     cb0:	4615                	li	a2,5
     cb2:	00005597          	auipc	a1,0x5
     cb6:	c5e58593          	addi	a1,a1,-930 # 5910 <malloc+0x666>
     cba:	114040ef          	jal	4dce <write>
     cbe:	4795                	li	a5,5
     cc0:	0cf51e63          	bne	a0,a5,d9c <linktest+0x128>
  close(fd);
     cc4:	8526                	mv	a0,s1
     cc6:	110040ef          	jal	4dd6 <close>
  if (link("lf1", "lf2") < 0) {
     cca:	00005597          	auipc	a1,0x5
     cce:	cfe58593          	addi	a1,a1,-770 # 59c8 <malloc+0x71e>
     cd2:	00005517          	auipc	a0,0x5
     cd6:	cee50513          	addi	a0,a0,-786 # 59c0 <malloc+0x716>
     cda:	134040ef          	jal	4e0e <link>
     cde:	0c054963          	bltz	a0,db0 <linktest+0x13c>
  unlink("lf1");
     ce2:	00005517          	auipc	a0,0x5
     ce6:	cde50513          	addi	a0,a0,-802 # 59c0 <malloc+0x716>
     cea:	114040ef          	jal	4dfe <unlink>
  if (open("lf1", 0) >= 0) {
     cee:	4581                	li	a1,0
     cf0:	00005517          	auipc	a0,0x5
     cf4:	cd050513          	addi	a0,a0,-816 # 59c0 <malloc+0x716>
     cf8:	0f6040ef          	jal	4dee <open>
     cfc:	0c055463          	bgez	a0,dc4 <linktest+0x150>
  fd = open("lf2", 0);
     d00:	4581                	li	a1,0
     d02:	00005517          	auipc	a0,0x5
     d06:	cc650513          	addi	a0,a0,-826 # 59c8 <malloc+0x71e>
     d0a:	0e4040ef          	jal	4dee <open>
     d0e:	84aa                	mv	s1,a0
  if (fd < 0) {
     d10:	0c054463          	bltz	a0,dd8 <linktest+0x164>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     d14:	660d                	lui	a2,0x3
     d16:	0000c597          	auipc	a1,0xc
     d1a:	fa258593          	addi	a1,a1,-94 # ccb8 <buf>
     d1e:	0a8040ef          	jal	4dc6 <read>
     d22:	4795                	li	a5,5
     d24:	0cf51463          	bne	a0,a5,dec <linktest+0x178>
  close(fd);
     d28:	8526                	mv	a0,s1
     d2a:	0ac040ef          	jal	4dd6 <close>
  if (link("lf2", "lf2") >= 0) {
     d2e:	00005597          	auipc	a1,0x5
     d32:	c9a58593          	addi	a1,a1,-870 # 59c8 <malloc+0x71e>
     d36:	852e                	mv	a0,a1
     d38:	0d6040ef          	jal	4e0e <link>
     d3c:	0c055263          	bgez	a0,e00 <linktest+0x18c>
  unlink("lf2");
     d40:	00005517          	auipc	a0,0x5
     d44:	c8850513          	addi	a0,a0,-888 # 59c8 <malloc+0x71e>
     d48:	0b6040ef          	jal	4dfe <unlink>
  if (link("lf2", "lf1") >= 0) {
     d4c:	00005597          	auipc	a1,0x5
     d50:	c7458593          	addi	a1,a1,-908 # 59c0 <malloc+0x716>
     d54:	00005517          	auipc	a0,0x5
     d58:	c7450513          	addi	a0,a0,-908 # 59c8 <malloc+0x71e>
     d5c:	0b2040ef          	jal	4e0e <link>
     d60:	0a055a63          	bgez	a0,e14 <linktest+0x1a0>
  if (link(".", "lf1") >= 0) {
     d64:	00005597          	auipc	a1,0x5
     d68:	c5c58593          	addi	a1,a1,-932 # 59c0 <malloc+0x716>
     d6c:	00005517          	auipc	a0,0x5
     d70:	d6450513          	addi	a0,a0,-668 # 5ad0 <malloc+0x826>
     d74:	09a040ef          	jal	4e0e <link>
     d78:	0a055863          	bgez	a0,e28 <linktest+0x1b4>
}
     d7c:	60e2                	ld	ra,24(sp)
     d7e:	6442                	ld	s0,16(sp)
     d80:	64a2                	ld	s1,8(sp)
     d82:	6902                	ld	s2,0(sp)
     d84:	6105                	addi	sp,sp,32
     d86:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     d88:	85ca                	mv	a1,s2
     d8a:	00005517          	auipc	a0,0x5
     d8e:	c4650513          	addi	a0,a0,-954 # 59d0 <malloc+0x726>
     d92:	464040ef          	jal	51f6 <printf>
    exit(1);
     d96:	4505                	li	a0,1
     d98:	016040ef          	jal	4dae <exit>
    printf("%s: write lf1 failed\n", s);
     d9c:	85ca                	mv	a1,s2
     d9e:	00005517          	auipc	a0,0x5
     da2:	c4a50513          	addi	a0,a0,-950 # 59e8 <malloc+0x73e>
     da6:	450040ef          	jal	51f6 <printf>
    exit(1);
     daa:	4505                	li	a0,1
     dac:	002040ef          	jal	4dae <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     db0:	85ca                	mv	a1,s2
     db2:	00005517          	auipc	a0,0x5
     db6:	c4e50513          	addi	a0,a0,-946 # 5a00 <malloc+0x756>
     dba:	43c040ef          	jal	51f6 <printf>
    exit(1);
     dbe:	4505                	li	a0,1
     dc0:	7ef030ef          	jal	4dae <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     dc4:	85ca                	mv	a1,s2
     dc6:	00005517          	auipc	a0,0x5
     dca:	c5a50513          	addi	a0,a0,-934 # 5a20 <malloc+0x776>
     dce:	428040ef          	jal	51f6 <printf>
    exit(1);
     dd2:	4505                	li	a0,1
     dd4:	7db030ef          	jal	4dae <exit>
    printf("%s: open lf2 failed\n", s);
     dd8:	85ca                	mv	a1,s2
     dda:	00005517          	auipc	a0,0x5
     dde:	c7650513          	addi	a0,a0,-906 # 5a50 <malloc+0x7a6>
     de2:	414040ef          	jal	51f6 <printf>
    exit(1);
     de6:	4505                	li	a0,1
     de8:	7c7030ef          	jal	4dae <exit>
    printf("%s: read lf2 failed\n", s);
     dec:	85ca                	mv	a1,s2
     dee:	00005517          	auipc	a0,0x5
     df2:	c7a50513          	addi	a0,a0,-902 # 5a68 <malloc+0x7be>
     df6:	400040ef          	jal	51f6 <printf>
    exit(1);
     dfa:	4505                	li	a0,1
     dfc:	7b3030ef          	jal	4dae <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e00:	85ca                	mv	a1,s2
     e02:	00005517          	auipc	a0,0x5
     e06:	c7e50513          	addi	a0,a0,-898 # 5a80 <malloc+0x7d6>
     e0a:	3ec040ef          	jal	51f6 <printf>
    exit(1);
     e0e:	4505                	li	a0,1
     e10:	79f030ef          	jal	4dae <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e14:	85ca                	mv	a1,s2
     e16:	00005517          	auipc	a0,0x5
     e1a:	c9250513          	addi	a0,a0,-878 # 5aa8 <malloc+0x7fe>
     e1e:	3d8040ef          	jal	51f6 <printf>
    exit(1);
     e22:	4505                	li	a0,1
     e24:	78b030ef          	jal	4dae <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e28:	85ca                	mv	a1,s2
     e2a:	00005517          	auipc	a0,0x5
     e2e:	cae50513          	addi	a0,a0,-850 # 5ad8 <malloc+0x82e>
     e32:	3c4040ef          	jal	51f6 <printf>
    exit(1);
     e36:	4505                	li	a0,1
     e38:	777030ef          	jal	4dae <exit>

0000000000000e3c <validatetest>:
{
     e3c:	7139                	addi	sp,sp,-64
     e3e:	fc06                	sd	ra,56(sp)
     e40:	f822                	sd	s0,48(sp)
     e42:	f426                	sd	s1,40(sp)
     e44:	f04a                	sd	s2,32(sp)
     e46:	ec4e                	sd	s3,24(sp)
     e48:	e852                	sd	s4,16(sp)
     e4a:	e456                	sd	s5,8(sp)
     e4c:	e05a                	sd	s6,0(sp)
     e4e:	0080                	addi	s0,sp,64
     e50:	8b2a                	mv	s6,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     e52:	4481                	li	s1,0
    if (link("nosuchfile", (char *)p) != -1) {
     e54:	00005997          	auipc	s3,0x5
     e58:	ca498993          	addi	s3,s3,-860 # 5af8 <malloc+0x84e>
     e5c:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     e5e:	6a85                	lui	s5,0x1
     e60:	00114a37          	lui	s4,0x114
    if (link("nosuchfile", (char *)p) != -1) {
     e64:	85a6                	mv	a1,s1
     e66:	854e                	mv	a0,s3
     e68:	7a7030ef          	jal	4e0e <link>
     e6c:	01251f63          	bne	a0,s2,e8a <validatetest+0x4e>
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     e70:	94d6                	add	s1,s1,s5
     e72:	ff4499e3          	bne	s1,s4,e64 <validatetest+0x28>
}
     e76:	70e2                	ld	ra,56(sp)
     e78:	7442                	ld	s0,48(sp)
     e7a:	74a2                	ld	s1,40(sp)
     e7c:	7902                	ld	s2,32(sp)
     e7e:	69e2                	ld	s3,24(sp)
     e80:	6a42                	ld	s4,16(sp)
     e82:	6aa2                	ld	s5,8(sp)
     e84:	6b02                	ld	s6,0(sp)
     e86:	6121                	addi	sp,sp,64
     e88:	8082                	ret
      printf("%s: link should not succeed\n", s);
     e8a:	85da                	mv	a1,s6
     e8c:	00005517          	auipc	a0,0x5
     e90:	c7c50513          	addi	a0,a0,-900 # 5b08 <malloc+0x85e>
     e94:	362040ef          	jal	51f6 <printf>
      exit(1);
     e98:	4505                	li	a0,1
     e9a:	715030ef          	jal	4dae <exit>

0000000000000e9e <bigdir>:
{
     e9e:	715d                	addi	sp,sp,-80
     ea0:	e486                	sd	ra,72(sp)
     ea2:	e0a2                	sd	s0,64(sp)
     ea4:	fc26                	sd	s1,56(sp)
     ea6:	f84a                	sd	s2,48(sp)
     ea8:	f44e                	sd	s3,40(sp)
     eaa:	f052                	sd	s4,32(sp)
     eac:	ec56                	sd	s5,24(sp)
     eae:	e85a                	sd	s6,16(sp)
     eb0:	0880                	addi	s0,sp,80
     eb2:	89aa                	mv	s3,a0
  unlink("bd");
     eb4:	00005517          	auipc	a0,0x5
     eb8:	c7450513          	addi	a0,a0,-908 # 5b28 <malloc+0x87e>
     ebc:	743030ef          	jal	4dfe <unlink>
  fd = open("bd", O_CREATE);
     ec0:	20000593          	li	a1,512
     ec4:	00005517          	auipc	a0,0x5
     ec8:	c6450513          	addi	a0,a0,-924 # 5b28 <malloc+0x87e>
     ecc:	723030ef          	jal	4dee <open>
  if (fd < 0) {
     ed0:	0c054163          	bltz	a0,f92 <bigdir+0xf4>
  close(fd);
     ed4:	703030ef          	jal	4dd6 <close>
  for (i = 0; i < N; i++) {
     ed8:	4901                	li	s2,0
    name[0] = 'x';
     eda:	07800a93          	li	s5,120
    if (link("bd", name) != 0) {
     ede:	00005a17          	auipc	s4,0x5
     ee2:	c4aa0a13          	addi	s4,s4,-950 # 5b28 <malloc+0x87e>
  for (i = 0; i < N; i++) {
     ee6:	1f400b13          	li	s6,500
    name[0] = 'x';
     eea:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     eee:	41f9571b          	sraiw	a4,s2,0x1f
     ef2:	01a7571b          	srliw	a4,a4,0x1a
     ef6:	012707bb          	addw	a5,a4,s2
     efa:	4067d69b          	sraiw	a3,a5,0x6
     efe:	0306869b          	addiw	a3,a3,48
     f02:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f06:	03f7f793          	andi	a5,a5,63
     f0a:	9f99                	subw	a5,a5,a4
     f0c:	0307879b          	addiw	a5,a5,48
     f10:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f14:	fa0409a3          	sb	zero,-77(s0)
    if (link("bd", name) != 0) {
     f18:	fb040593          	addi	a1,s0,-80
     f1c:	8552                	mv	a0,s4
     f1e:	6f1030ef          	jal	4e0e <link>
     f22:	84aa                	mv	s1,a0
     f24:	e149                	bnez	a0,fa6 <bigdir+0x108>
  for (i = 0; i < N; i++) {
     f26:	2905                	addiw	s2,s2,1
     f28:	fd6911e3          	bne	s2,s6,eea <bigdir+0x4c>
  unlink("bd");
     f2c:	00005517          	auipc	a0,0x5
     f30:	bfc50513          	addi	a0,a0,-1028 # 5b28 <malloc+0x87e>
     f34:	6cb030ef          	jal	4dfe <unlink>
    name[0] = 'x';
     f38:	07800913          	li	s2,120
  for (i = 0; i < N; i++) {
     f3c:	1f400a13          	li	s4,500
    name[0] = 'x';
     f40:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
     f44:	41f4d71b          	sraiw	a4,s1,0x1f
     f48:	01a7571b          	srliw	a4,a4,0x1a
     f4c:	009707bb          	addw	a5,a4,s1
     f50:	4067d69b          	sraiw	a3,a5,0x6
     f54:	0306869b          	addiw	a3,a3,48
     f58:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f5c:	03f7f793          	andi	a5,a5,63
     f60:	9f99                	subw	a5,a5,a4
     f62:	0307879b          	addiw	a5,a5,48
     f66:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f6a:	fa0409a3          	sb	zero,-77(s0)
    if (unlink(name) != 0) {
     f6e:	fb040513          	addi	a0,s0,-80
     f72:	68d030ef          	jal	4dfe <unlink>
     f76:	e529                	bnez	a0,fc0 <bigdir+0x122>
  for (i = 0; i < N; i++) {
     f78:	2485                	addiw	s1,s1,1
     f7a:	fd4493e3          	bne	s1,s4,f40 <bigdir+0xa2>
}
     f7e:	60a6                	ld	ra,72(sp)
     f80:	6406                	ld	s0,64(sp)
     f82:	74e2                	ld	s1,56(sp)
     f84:	7942                	ld	s2,48(sp)
     f86:	79a2                	ld	s3,40(sp)
     f88:	7a02                	ld	s4,32(sp)
     f8a:	6ae2                	ld	s5,24(sp)
     f8c:	6b42                	ld	s6,16(sp)
     f8e:	6161                	addi	sp,sp,80
     f90:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     f92:	85ce                	mv	a1,s3
     f94:	00005517          	auipc	a0,0x5
     f98:	b9c50513          	addi	a0,a0,-1124 # 5b30 <malloc+0x886>
     f9c:	25a040ef          	jal	51f6 <printf>
    exit(1);
     fa0:	4505                	li	a0,1
     fa2:	60d030ef          	jal	4dae <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
     fa6:	fb040693          	addi	a3,s0,-80
     faa:	864a                	mv	a2,s2
     fac:	85ce                	mv	a1,s3
     fae:	00005517          	auipc	a0,0x5
     fb2:	ba250513          	addi	a0,a0,-1118 # 5b50 <malloc+0x8a6>
     fb6:	240040ef          	jal	51f6 <printf>
      exit(1);
     fba:	4505                	li	a0,1
     fbc:	5f3030ef          	jal	4dae <exit>
      printf("%s: bigdir unlink failed", s);
     fc0:	85ce                	mv	a1,s3
     fc2:	00005517          	auipc	a0,0x5
     fc6:	bb650513          	addi	a0,a0,-1098 # 5b78 <malloc+0x8ce>
     fca:	22c040ef          	jal	51f6 <printf>
      exit(1);
     fce:	4505                	li	a0,1
     fd0:	5df030ef          	jal	4dae <exit>

0000000000000fd4 <pgbug>:
{
     fd4:	7179                	addi	sp,sp,-48
     fd6:	f406                	sd	ra,40(sp)
     fd8:	f022                	sd	s0,32(sp)
     fda:	ec26                	sd	s1,24(sp)
     fdc:	1800                	addi	s0,sp,48
  argv[0] = 0;
     fde:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
     fe2:	00008497          	auipc	s1,0x8
     fe6:	01e48493          	addi	s1,s1,30 # 9000 <big>
     fea:	fd840593          	addi	a1,s0,-40
     fee:	6088                	ld	a0,0(s1)
     ff0:	5f7030ef          	jal	4de6 <exec>
  pipe(big);
     ff4:	6088                	ld	a0,0(s1)
     ff6:	5c9030ef          	jal	4dbe <pipe>
  exit(0);
     ffa:	4501                	li	a0,0
     ffc:	5b3030ef          	jal	4dae <exit>

0000000000001000 <badarg>:
{
    1000:	7139                	addi	sp,sp,-64
    1002:	fc06                	sd	ra,56(sp)
    1004:	f822                	sd	s0,48(sp)
    1006:	f426                	sd	s1,40(sp)
    1008:	f04a                	sd	s2,32(sp)
    100a:	ec4e                	sd	s3,24(sp)
    100c:	0080                	addi	s0,sp,64
    100e:	64b1                	lui	s1,0xc
    1010:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1da8>
    argv[0] = (char *)0xffffffff;
    1014:	597d                	li	s2,-1
    1016:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    101a:	00004997          	auipc	s3,0x4
    101e:	3ce98993          	addi	s3,s3,974 # 53e8 <malloc+0x13e>
    argv[0] = (char *)0xffffffff;
    1022:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1026:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    102a:	fc040593          	addi	a1,s0,-64
    102e:	854e                	mv	a0,s3
    1030:	5b7030ef          	jal	4de6 <exec>
  for (int i = 0; i < 50000; i++) {
    1034:	34fd                	addiw	s1,s1,-1
    1036:	f4f5                	bnez	s1,1022 <badarg+0x22>
  exit(0);
    1038:	4501                	li	a0,0
    103a:	575030ef          	jal	4dae <exit>

000000000000103e <copyinstr2>:
{
    103e:	7155                	addi	sp,sp,-208
    1040:	e586                	sd	ra,200(sp)
    1042:	e1a2                	sd	s0,192(sp)
    1044:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++)
    1046:	f6840793          	addi	a5,s0,-152
    104a:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    104e:	07800713          	li	a4,120
    1052:	00e78023          	sb	a4,0(a5)
  for (int i = 0; i < MAXPATH; i++)
    1056:	0785                	addi	a5,a5,1
    1058:	fed79de3          	bne	a5,a3,1052 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    105c:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1060:	f6840513          	addi	a0,s0,-152
    1064:	59b030ef          	jal	4dfe <unlink>
  if (ret != -1) {
    1068:	57fd                	li	a5,-1
    106a:	0cf51263          	bne	a0,a5,112e <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    106e:	20100593          	li	a1,513
    1072:	f6840513          	addi	a0,s0,-152
    1076:	579030ef          	jal	4dee <open>
  if (fd != -1) {
    107a:	57fd                	li	a5,-1
    107c:	0cf51563          	bne	a0,a5,1146 <copyinstr2+0x108>
  ret = link(b, b);
    1080:	f6840593          	addi	a1,s0,-152
    1084:	852e                	mv	a0,a1
    1086:	589030ef          	jal	4e0e <link>
  if (ret != -1) {
    108a:	57fd                	li	a5,-1
    108c:	0cf51963          	bne	a0,a5,115e <copyinstr2+0x120>
  char *args[] = {"xx", 0};
    1090:	00006797          	auipc	a5,0x6
    1094:	bd078793          	addi	a5,a5,-1072 # 6c60 <malloc+0x19b6>
    1098:	f4f43c23          	sd	a5,-168(s0)
    109c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    10a0:	f5840593          	addi	a1,s0,-168
    10a4:	f6840513          	addi	a0,s0,-152
    10a8:	53f030ef          	jal	4de6 <exec>
  if (ret != -1) {
    10ac:	57fd                	li	a5,-1
    10ae:	0cf51563          	bne	a0,a5,1178 <copyinstr2+0x13a>
  int pid = fork();
    10b2:	4f5030ef          	jal	4da6 <fork>
  if (pid < 0) {
    10b6:	0c054d63          	bltz	a0,1190 <copyinstr2+0x152>
  if (pid == 0) {
    10ba:	0e051863          	bnez	a0,11aa <copyinstr2+0x16c>
    10be:	00008797          	auipc	a5,0x8
    10c2:	4e278793          	addi	a5,a5,1250 # 95a0 <big.0>
    10c6:	00009697          	auipc	a3,0x9
    10ca:	4da68693          	addi	a3,a3,1242 # a5a0 <big.0+0x1000>
      big[i] = 'x';
    10ce:	07800713          	li	a4,120
    10d2:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++)
    10d6:	0785                	addi	a5,a5,1
    10d8:	fed79de3          	bne	a5,a3,10d2 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    10dc:	00009797          	auipc	a5,0x9
    10e0:	4c078223          	sb	zero,1220(a5) # a5a0 <big.0+0x1000>
    char *args2[] = {big, big, big, 0};
    10e4:	00007797          	auipc	a5,0x7
    10e8:	87c78793          	addi	a5,a5,-1924 # 7960 <malloc+0x26b6>
    10ec:	6fb0                	ld	a2,88(a5)
    10ee:	73b4                	ld	a3,96(a5)
    10f0:	77b8                	ld	a4,104(a5)
    10f2:	7bbc                	ld	a5,112(a5)
    10f4:	f2c43823          	sd	a2,-208(s0)
    10f8:	f2d43c23          	sd	a3,-200(s0)
    10fc:	f4e43023          	sd	a4,-192(s0)
    1100:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1104:	f3040593          	addi	a1,s0,-208
    1108:	00004517          	auipc	a0,0x4
    110c:	2e050513          	addi	a0,a0,736 # 53e8 <malloc+0x13e>
    1110:	4d7030ef          	jal	4de6 <exec>
    if (ret != -1) {
    1114:	57fd                	li	a5,-1
    1116:	08f50663          	beq	a0,a5,11a2 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    111a:	55fd                	li	a1,-1
    111c:	00005517          	auipc	a0,0x5
    1120:	b0450513          	addi	a0,a0,-1276 # 5c20 <malloc+0x976>
    1124:	0d2040ef          	jal	51f6 <printf>
      exit(1);
    1128:	4505                	li	a0,1
    112a:	485030ef          	jal	4dae <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    112e:	862a                	mv	a2,a0
    1130:	f6840593          	addi	a1,s0,-152
    1134:	00005517          	auipc	a0,0x5
    1138:	a6450513          	addi	a0,a0,-1436 # 5b98 <malloc+0x8ee>
    113c:	0ba040ef          	jal	51f6 <printf>
    exit(1);
    1140:	4505                	li	a0,1
    1142:	46d030ef          	jal	4dae <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1146:	862a                	mv	a2,a0
    1148:	f6840593          	addi	a1,s0,-152
    114c:	00005517          	auipc	a0,0x5
    1150:	a6c50513          	addi	a0,a0,-1428 # 5bb8 <malloc+0x90e>
    1154:	0a2040ef          	jal	51f6 <printf>
    exit(1);
    1158:	4505                	li	a0,1
    115a:	455030ef          	jal	4dae <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    115e:	86aa                	mv	a3,a0
    1160:	f6840613          	addi	a2,s0,-152
    1164:	85b2                	mv	a1,a2
    1166:	00005517          	auipc	a0,0x5
    116a:	a7250513          	addi	a0,a0,-1422 # 5bd8 <malloc+0x92e>
    116e:	088040ef          	jal	51f6 <printf>
    exit(1);
    1172:	4505                	li	a0,1
    1174:	43b030ef          	jal	4dae <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1178:	567d                	li	a2,-1
    117a:	f6840593          	addi	a1,s0,-152
    117e:	00005517          	auipc	a0,0x5
    1182:	a8250513          	addi	a0,a0,-1406 # 5c00 <malloc+0x956>
    1186:	070040ef          	jal	51f6 <printf>
    exit(1);
    118a:	4505                	li	a0,1
    118c:	423030ef          	jal	4dae <exit>
    printf("fork failed\n");
    1190:	00006517          	auipc	a0,0x6
    1194:	0c050513          	addi	a0,a0,192 # 7250 <malloc+0x1fa6>
    1198:	05e040ef          	jal	51f6 <printf>
    exit(1);
    119c:	4505                	li	a0,1
    119e:	411030ef          	jal	4dae <exit>
    exit(747); // OK
    11a2:	2eb00513          	li	a0,747
    11a6:	409030ef          	jal	4dae <exit>
  int st = 0;
    11aa:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    11ae:	f5440513          	addi	a0,s0,-172
    11b2:	405030ef          	jal	4db6 <wait>
  if (st != 747) {
    11b6:	f5442703          	lw	a4,-172(s0)
    11ba:	2eb00793          	li	a5,747
    11be:	00f71663          	bne	a4,a5,11ca <copyinstr2+0x18c>
}
    11c2:	60ae                	ld	ra,200(sp)
    11c4:	640e                	ld	s0,192(sp)
    11c6:	6169                	addi	sp,sp,208
    11c8:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    11ca:	00005517          	auipc	a0,0x5
    11ce:	a7e50513          	addi	a0,a0,-1410 # 5c48 <malloc+0x99e>
    11d2:	024040ef          	jal	51f6 <printf>
    exit(1);
    11d6:	4505                	li	a0,1
    11d8:	3d7030ef          	jal	4dae <exit>

00000000000011dc <truncate3>:
{
    11dc:	7159                	addi	sp,sp,-112
    11de:	f486                	sd	ra,104(sp)
    11e0:	f0a2                	sd	s0,96(sp)
    11e2:	e8ca                	sd	s2,80(sp)
    11e4:	1880                	addi	s0,sp,112
    11e6:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    11e8:	60100593          	li	a1,1537
    11ec:	00004517          	auipc	a0,0x4
    11f0:	25450513          	addi	a0,a0,596 # 5440 <malloc+0x196>
    11f4:	3fb030ef          	jal	4dee <open>
    11f8:	3df030ef          	jal	4dd6 <close>
  pid = fork();
    11fc:	3ab030ef          	jal	4da6 <fork>
  if (pid < 0) {
    1200:	06054663          	bltz	a0,126c <truncate3+0x90>
  if (pid == 0) {
    1204:	e55d                	bnez	a0,12b2 <truncate3+0xd6>
    1206:	eca6                	sd	s1,88(sp)
    1208:	e4ce                	sd	s3,72(sp)
    120a:	e0d2                	sd	s4,64(sp)
    120c:	fc56                	sd	s5,56(sp)
    120e:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1212:	00004a17          	auipc	s4,0x4
    1216:	22ea0a13          	addi	s4,s4,558 # 5440 <malloc+0x196>
      int n = write(fd, "1234567890", 10);
    121a:	00005a97          	auipc	s5,0x5
    121e:	a8ea8a93          	addi	s5,s5,-1394 # 5ca8 <malloc+0x9fe>
      int fd = open("truncfile", O_WRONLY);
    1222:	4585                	li	a1,1
    1224:	8552                	mv	a0,s4
    1226:	3c9030ef          	jal	4dee <open>
    122a:	84aa                	mv	s1,a0
      if (fd < 0) {
    122c:	04054e63          	bltz	a0,1288 <truncate3+0xac>
      int n = write(fd, "1234567890", 10);
    1230:	4629                	li	a2,10
    1232:	85d6                	mv	a1,s5
    1234:	39b030ef          	jal	4dce <write>
      if (n != 10) {
    1238:	47a9                	li	a5,10
    123a:	06f51163          	bne	a0,a5,129c <truncate3+0xc0>
      close(fd);
    123e:	8526                	mv	a0,s1
    1240:	397030ef          	jal	4dd6 <close>
      fd = open("truncfile", O_RDONLY);
    1244:	4581                	li	a1,0
    1246:	8552                	mv	a0,s4
    1248:	3a7030ef          	jal	4dee <open>
    124c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    124e:	02000613          	li	a2,32
    1252:	f9840593          	addi	a1,s0,-104
    1256:	371030ef          	jal	4dc6 <read>
      close(fd);
    125a:	8526                	mv	a0,s1
    125c:	37b030ef          	jal	4dd6 <close>
    for (int i = 0; i < 100; i++) {
    1260:	39fd                	addiw	s3,s3,-1
    1262:	fc0990e3          	bnez	s3,1222 <truncate3+0x46>
    exit(0);
    1266:	4501                	li	a0,0
    1268:	347030ef          	jal	4dae <exit>
    126c:	eca6                	sd	s1,88(sp)
    126e:	e4ce                	sd	s3,72(sp)
    1270:	e0d2                	sd	s4,64(sp)
    1272:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    1274:	85ca                	mv	a1,s2
    1276:	00005517          	auipc	a0,0x5
    127a:	a0250513          	addi	a0,a0,-1534 # 5c78 <malloc+0x9ce>
    127e:	779030ef          	jal	51f6 <printf>
    exit(1);
    1282:	4505                	li	a0,1
    1284:	32b030ef          	jal	4dae <exit>
        printf("%s: open failed\n", s);
    1288:	85ca                	mv	a1,s2
    128a:	00005517          	auipc	a0,0x5
    128e:	a0650513          	addi	a0,a0,-1530 # 5c90 <malloc+0x9e6>
    1292:	765030ef          	jal	51f6 <printf>
        exit(1);
    1296:	4505                	li	a0,1
    1298:	317030ef          	jal	4dae <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    129c:	862a                	mv	a2,a0
    129e:	85ca                	mv	a1,s2
    12a0:	00005517          	auipc	a0,0x5
    12a4:	a1850513          	addi	a0,a0,-1512 # 5cb8 <malloc+0xa0e>
    12a8:	74f030ef          	jal	51f6 <printf>
        exit(1);
    12ac:	4505                	li	a0,1
    12ae:	301030ef          	jal	4dae <exit>
    12b2:	eca6                	sd	s1,88(sp)
    12b4:	e4ce                	sd	s3,72(sp)
    12b6:	e0d2                	sd	s4,64(sp)
    12b8:	fc56                	sd	s5,56(sp)
    12ba:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    12be:	00004a17          	auipc	s4,0x4
    12c2:	182a0a13          	addi	s4,s4,386 # 5440 <malloc+0x196>
    int n = write(fd, "xxx", 3);
    12c6:	00005a97          	auipc	s5,0x5
    12ca:	a12a8a93          	addi	s5,s5,-1518 # 5cd8 <malloc+0xa2e>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    12ce:	60100593          	li	a1,1537
    12d2:	8552                	mv	a0,s4
    12d4:	31b030ef          	jal	4dee <open>
    12d8:	84aa                	mv	s1,a0
    if (fd < 0) {
    12da:	02054d63          	bltz	a0,1314 <truncate3+0x138>
    int n = write(fd, "xxx", 3);
    12de:	460d                	li	a2,3
    12e0:	85d6                	mv	a1,s5
    12e2:	2ed030ef          	jal	4dce <write>
    if (n != 3) {
    12e6:	478d                	li	a5,3
    12e8:	04f51063          	bne	a0,a5,1328 <truncate3+0x14c>
    close(fd);
    12ec:	8526                	mv	a0,s1
    12ee:	2e9030ef          	jal	4dd6 <close>
  for (int i = 0; i < 150; i++) {
    12f2:	39fd                	addiw	s3,s3,-1
    12f4:	fc099de3          	bnez	s3,12ce <truncate3+0xf2>
  wait(&xstatus);
    12f8:	fbc40513          	addi	a0,s0,-68
    12fc:	2bb030ef          	jal	4db6 <wait>
  unlink("truncfile");
    1300:	00004517          	auipc	a0,0x4
    1304:	14050513          	addi	a0,a0,320 # 5440 <malloc+0x196>
    1308:	2f7030ef          	jal	4dfe <unlink>
  exit(xstatus);
    130c:	fbc42503          	lw	a0,-68(s0)
    1310:	29f030ef          	jal	4dae <exit>
      printf("%s: open failed\n", s);
    1314:	85ca                	mv	a1,s2
    1316:	00005517          	auipc	a0,0x5
    131a:	97a50513          	addi	a0,a0,-1670 # 5c90 <malloc+0x9e6>
    131e:	6d9030ef          	jal	51f6 <printf>
      exit(1);
    1322:	4505                	li	a0,1
    1324:	28b030ef          	jal	4dae <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1328:	862a                	mv	a2,a0
    132a:	85ca                	mv	a1,s2
    132c:	00005517          	auipc	a0,0x5
    1330:	9b450513          	addi	a0,a0,-1612 # 5ce0 <malloc+0xa36>
    1334:	6c3030ef          	jal	51f6 <printf>
      exit(1);
    1338:	4505                	li	a0,1
    133a:	275030ef          	jal	4dae <exit>

000000000000133e <pipe1>:
{
    133e:	711d                	addi	sp,sp,-96
    1340:	ec86                	sd	ra,88(sp)
    1342:	e8a2                	sd	s0,80(sp)
    1344:	fc4e                	sd	s3,56(sp)
    1346:	1080                	addi	s0,sp,96
    1348:	89aa                	mv	s3,a0
  if (pipe(fds) != 0) {
    134a:	fa840513          	addi	a0,s0,-88
    134e:	271030ef          	jal	4dbe <pipe>
    1352:	e92d                	bnez	a0,13c4 <pipe1+0x86>
    1354:	e4a6                	sd	s1,72(sp)
    1356:	f852                	sd	s4,48(sp)
    1358:	84aa                	mv	s1,a0
  pid = fork();
    135a:	24d030ef          	jal	4da6 <fork>
    135e:	8a2a                	mv	s4,a0
  if (pid == 0) {
    1360:	c151                	beqz	a0,13e4 <pipe1+0xa6>
  } else if (pid > 0) {
    1362:	14a05e63          	blez	a0,14be <pipe1+0x180>
    1366:	e0ca                	sd	s2,64(sp)
    1368:	f456                	sd	s5,40(sp)
    close(fds[1]);
    136a:	fac42503          	lw	a0,-84(s0)
    136e:	269030ef          	jal	4dd6 <close>
    total = 0;
    1372:	8a26                	mv	s4,s1
    cc = 1;
    1374:	4905                	li	s2,1
    while ((n = read(fds[0], buf, cc)) > 0) {
    1376:	0000ca97          	auipc	s5,0xc
    137a:	942a8a93          	addi	s5,s5,-1726 # ccb8 <buf>
    137e:	864a                	mv	a2,s2
    1380:	85d6                	mv	a1,s5
    1382:	fa842503          	lw	a0,-88(s0)
    1386:	241030ef          	jal	4dc6 <read>
    138a:	0ea05a63          	blez	a0,147e <pipe1+0x140>
      for (i = 0; i < n; i++) {
    138e:	0000c717          	auipc	a4,0xc
    1392:	92a70713          	addi	a4,a4,-1750 # ccb8 <buf>
    1396:	00a4863b          	addw	a2,s1,a0
        if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    139a:	00074683          	lbu	a3,0(a4)
    139e:	0ff4f793          	zext.b	a5,s1
    13a2:	2485                	addiw	s1,s1,1
    13a4:	0af69d63          	bne	a3,a5,145e <pipe1+0x120>
      for (i = 0; i < n; i++) {
    13a8:	0705                	addi	a4,a4,1
    13aa:	fec498e3          	bne	s1,a2,139a <pipe1+0x5c>
      total += n;
    13ae:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    13b2:	0019179b          	slliw	a5,s2,0x1
    13b6:	0007891b          	sext.w	s2,a5
      if (cc > sizeof(buf))
    13ba:	670d                	lui	a4,0x3
    13bc:	fd2771e3          	bgeu	a4,s2,137e <pipe1+0x40>
        cc = sizeof(buf);
    13c0:	690d                	lui	s2,0x3
    13c2:	bf75                	j	137e <pipe1+0x40>
    13c4:	e4a6                	sd	s1,72(sp)
    13c6:	e0ca                	sd	s2,64(sp)
    13c8:	f852                	sd	s4,48(sp)
    13ca:	f456                	sd	s5,40(sp)
    13cc:	f05a                	sd	s6,32(sp)
    13ce:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    13d0:	85ce                	mv	a1,s3
    13d2:	00005517          	auipc	a0,0x5
    13d6:	92e50513          	addi	a0,a0,-1746 # 5d00 <malloc+0xa56>
    13da:	61d030ef          	jal	51f6 <printf>
    exit(1);
    13de:	4505                	li	a0,1
    13e0:	1cf030ef          	jal	4dae <exit>
    13e4:	e0ca                	sd	s2,64(sp)
    13e6:	f456                	sd	s5,40(sp)
    13e8:	f05a                	sd	s6,32(sp)
    13ea:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    13ec:	fa842503          	lw	a0,-88(s0)
    13f0:	1e7030ef          	jal	4dd6 <close>
    for (n = 0; n < N; n++) {
    13f4:	0000cb17          	auipc	s6,0xc
    13f8:	8c4b0b13          	addi	s6,s6,-1852 # ccb8 <buf>
    13fc:	416004bb          	negw	s1,s6
    1400:	0ff4f493          	zext.b	s1,s1
    1404:	409b0913          	addi	s2,s6,1033
      if (write(fds[1], buf, SZ) != SZ) {
    1408:	8bda                	mv	s7,s6
    for (n = 0; n < N; n++) {
    140a:	6a85                	lui	s5,0x1
    140c:	42da8a93          	addi	s5,s5,1069 # 142d <pipe1+0xef>
{
    1410:	87da                	mv	a5,s6
        buf[i] = seq++;
    1412:	0097873b          	addw	a4,a5,s1
    1416:	00e78023          	sb	a4,0(a5)
      for (i = 0; i < SZ; i++)
    141a:	0785                	addi	a5,a5,1
    141c:	ff279be3          	bne	a5,s2,1412 <pipe1+0xd4>
    1420:	409a0a1b          	addiw	s4,s4,1033
      if (write(fds[1], buf, SZ) != SZ) {
    1424:	40900613          	li	a2,1033
    1428:	85de                	mv	a1,s7
    142a:	fac42503          	lw	a0,-84(s0)
    142e:	1a1030ef          	jal	4dce <write>
    1432:	40900793          	li	a5,1033
    1436:	00f51a63          	bne	a0,a5,144a <pipe1+0x10c>
    for (n = 0; n < N; n++) {
    143a:	24a5                	addiw	s1,s1,9
    143c:	0ff4f493          	zext.b	s1,s1
    1440:	fd5a18e3          	bne	s4,s5,1410 <pipe1+0xd2>
    exit(0);
    1444:	4501                	li	a0,0
    1446:	169030ef          	jal	4dae <exit>
        printf("%s: pipe1 oops 1\n", s);
    144a:	85ce                	mv	a1,s3
    144c:	00005517          	auipc	a0,0x5
    1450:	8cc50513          	addi	a0,a0,-1844 # 5d18 <malloc+0xa6e>
    1454:	5a3030ef          	jal	51f6 <printf>
        exit(1);
    1458:	4505                	li	a0,1
    145a:	155030ef          	jal	4dae <exit>
          printf("%s: pipe1 oops 2\n", s);
    145e:	85ce                	mv	a1,s3
    1460:	00005517          	auipc	a0,0x5
    1464:	8d050513          	addi	a0,a0,-1840 # 5d30 <malloc+0xa86>
    1468:	58f030ef          	jal	51f6 <printf>
          return;
    146c:	64a6                	ld	s1,72(sp)
    146e:	6906                	ld	s2,64(sp)
    1470:	7a42                	ld	s4,48(sp)
    1472:	7aa2                	ld	s5,40(sp)
}
    1474:	60e6                	ld	ra,88(sp)
    1476:	6446                	ld	s0,80(sp)
    1478:	79e2                	ld	s3,56(sp)
    147a:	6125                	addi	sp,sp,96
    147c:	8082                	ret
    if (total != N * SZ) {
    147e:	6785                	lui	a5,0x1
    1480:	42d78793          	addi	a5,a5,1069 # 142d <pipe1+0xef>
    1484:	00fa0f63          	beq	s4,a5,14a2 <pipe1+0x164>
    1488:	f05a                	sd	s6,32(sp)
    148a:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    148c:	8652                	mv	a2,s4
    148e:	85ce                	mv	a1,s3
    1490:	00005517          	auipc	a0,0x5
    1494:	8b850513          	addi	a0,a0,-1864 # 5d48 <malloc+0xa9e>
    1498:	55f030ef          	jal	51f6 <printf>
      exit(1);
    149c:	4505                	li	a0,1
    149e:	111030ef          	jal	4dae <exit>
    14a2:	f05a                	sd	s6,32(sp)
    14a4:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    14a6:	fa842503          	lw	a0,-88(s0)
    14aa:	12d030ef          	jal	4dd6 <close>
    wait(&xstatus);
    14ae:	fa440513          	addi	a0,s0,-92
    14b2:	105030ef          	jal	4db6 <wait>
    exit(xstatus);
    14b6:	fa442503          	lw	a0,-92(s0)
    14ba:	0f5030ef          	jal	4dae <exit>
    14be:	e0ca                	sd	s2,64(sp)
    14c0:	f456                	sd	s5,40(sp)
    14c2:	f05a                	sd	s6,32(sp)
    14c4:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    14c6:	85ce                	mv	a1,s3
    14c8:	00005517          	auipc	a0,0x5
    14cc:	8a050513          	addi	a0,a0,-1888 # 5d68 <malloc+0xabe>
    14d0:	527030ef          	jal	51f6 <printf>
    exit(1);
    14d4:	4505                	li	a0,1
    14d6:	0d9030ef          	jal	4dae <exit>

00000000000014da <exitwait>:
{
    14da:	7139                	addi	sp,sp,-64
    14dc:	fc06                	sd	ra,56(sp)
    14de:	f822                	sd	s0,48(sp)
    14e0:	f426                	sd	s1,40(sp)
    14e2:	f04a                	sd	s2,32(sp)
    14e4:	ec4e                	sd	s3,24(sp)
    14e6:	e852                	sd	s4,16(sp)
    14e8:	0080                	addi	s0,sp,64
    14ea:	8a2a                	mv	s4,a0
  for (i = 0; i < 100; i++) {
    14ec:	4901                	li	s2,0
    14ee:	06400993          	li	s3,100
    pid = fork();
    14f2:	0b5030ef          	jal	4da6 <fork>
    14f6:	84aa                	mv	s1,a0
    if (pid < 0) {
    14f8:	02054863          	bltz	a0,1528 <exitwait+0x4e>
    if (pid) {
    14fc:	c525                	beqz	a0,1564 <exitwait+0x8a>
      if (wait(&xstate) != pid) {
    14fe:	fcc40513          	addi	a0,s0,-52
    1502:	0b5030ef          	jal	4db6 <wait>
    1506:	02951b63          	bne	a0,s1,153c <exitwait+0x62>
      if (i != xstate) {
    150a:	fcc42783          	lw	a5,-52(s0)
    150e:	05279163          	bne	a5,s2,1550 <exitwait+0x76>
  for (i = 0; i < 100; i++) {
    1512:	2905                	addiw	s2,s2,1 # 3001 <subdir+0x5b5>
    1514:	fd391fe3          	bne	s2,s3,14f2 <exitwait+0x18>
}
    1518:	70e2                	ld	ra,56(sp)
    151a:	7442                	ld	s0,48(sp)
    151c:	74a2                	ld	s1,40(sp)
    151e:	7902                	ld	s2,32(sp)
    1520:	69e2                	ld	s3,24(sp)
    1522:	6a42                	ld	s4,16(sp)
    1524:	6121                	addi	sp,sp,64
    1526:	8082                	ret
      printf("%s: fork failed\n", s);
    1528:	85d2                	mv	a1,s4
    152a:	00004517          	auipc	a0,0x4
    152e:	74e50513          	addi	a0,a0,1870 # 5c78 <malloc+0x9ce>
    1532:	4c5030ef          	jal	51f6 <printf>
      exit(1);
    1536:	4505                	li	a0,1
    1538:	077030ef          	jal	4dae <exit>
        printf("%s: wait wrong pid\n", s);
    153c:	85d2                	mv	a1,s4
    153e:	00005517          	auipc	a0,0x5
    1542:	84250513          	addi	a0,a0,-1982 # 5d80 <malloc+0xad6>
    1546:	4b1030ef          	jal	51f6 <printf>
        exit(1);
    154a:	4505                	li	a0,1
    154c:	063030ef          	jal	4dae <exit>
        printf("%s: wait wrong exit status\n", s);
    1550:	85d2                	mv	a1,s4
    1552:	00005517          	auipc	a0,0x5
    1556:	84650513          	addi	a0,a0,-1978 # 5d98 <malloc+0xaee>
    155a:	49d030ef          	jal	51f6 <printf>
        exit(1);
    155e:	4505                	li	a0,1
    1560:	04f030ef          	jal	4dae <exit>
      exit(i);
    1564:	854a                	mv	a0,s2
    1566:	049030ef          	jal	4dae <exit>

000000000000156a <twochildren>:
{
    156a:	1101                	addi	sp,sp,-32
    156c:	ec06                	sd	ra,24(sp)
    156e:	e822                	sd	s0,16(sp)
    1570:	e426                	sd	s1,8(sp)
    1572:	e04a                	sd	s2,0(sp)
    1574:	1000                	addi	s0,sp,32
    1576:	892a                	mv	s2,a0
    1578:	3e800493          	li	s1,1000
    int pid1 = fork();
    157c:	02b030ef          	jal	4da6 <fork>
    if (pid1 < 0) {
    1580:	02054663          	bltz	a0,15ac <twochildren+0x42>
    if (pid1 == 0) {
    1584:	cd15                	beqz	a0,15c0 <twochildren+0x56>
      int pid2 = fork();
    1586:	021030ef          	jal	4da6 <fork>
      if (pid2 < 0) {
    158a:	02054d63          	bltz	a0,15c4 <twochildren+0x5a>
      if (pid2 == 0) {
    158e:	c529                	beqz	a0,15d8 <twochildren+0x6e>
        wait(0);
    1590:	4501                	li	a0,0
    1592:	025030ef          	jal	4db6 <wait>
        wait(0);
    1596:	4501                	li	a0,0
    1598:	01f030ef          	jal	4db6 <wait>
  for (int i = 0; i < 1000; i++) {
    159c:	34fd                	addiw	s1,s1,-1
    159e:	fcf9                	bnez	s1,157c <twochildren+0x12>
}
    15a0:	60e2                	ld	ra,24(sp)
    15a2:	6442                	ld	s0,16(sp)
    15a4:	64a2                	ld	s1,8(sp)
    15a6:	6902                	ld	s2,0(sp)
    15a8:	6105                	addi	sp,sp,32
    15aa:	8082                	ret
      printf("%s: fork failed\n", s);
    15ac:	85ca                	mv	a1,s2
    15ae:	00004517          	auipc	a0,0x4
    15b2:	6ca50513          	addi	a0,a0,1738 # 5c78 <malloc+0x9ce>
    15b6:	441030ef          	jal	51f6 <printf>
      exit(1);
    15ba:	4505                	li	a0,1
    15bc:	7f2030ef          	jal	4dae <exit>
      exit(0);
    15c0:	7ee030ef          	jal	4dae <exit>
        printf("%s: fork failed\n", s);
    15c4:	85ca                	mv	a1,s2
    15c6:	00004517          	auipc	a0,0x4
    15ca:	6b250513          	addi	a0,a0,1714 # 5c78 <malloc+0x9ce>
    15ce:	429030ef          	jal	51f6 <printf>
        exit(1);
    15d2:	4505                	li	a0,1
    15d4:	7da030ef          	jal	4dae <exit>
        exit(0);
    15d8:	7d6030ef          	jal	4dae <exit>

00000000000015dc <forkfork>:
{
    15dc:	7179                	addi	sp,sp,-48
    15de:	f406                	sd	ra,40(sp)
    15e0:	f022                	sd	s0,32(sp)
    15e2:	ec26                	sd	s1,24(sp)
    15e4:	1800                	addi	s0,sp,48
    15e6:	84aa                	mv	s1,a0
    int pid = fork();
    15e8:	7be030ef          	jal	4da6 <fork>
    if (pid < 0) {
    15ec:	02054b63          	bltz	a0,1622 <forkfork+0x46>
    if (pid == 0) {
    15f0:	c139                	beqz	a0,1636 <forkfork+0x5a>
    int pid = fork();
    15f2:	7b4030ef          	jal	4da6 <fork>
    if (pid < 0) {
    15f6:	02054663          	bltz	a0,1622 <forkfork+0x46>
    if (pid == 0) {
    15fa:	cd15                	beqz	a0,1636 <forkfork+0x5a>
    wait(&xstatus);
    15fc:	fdc40513          	addi	a0,s0,-36
    1600:	7b6030ef          	jal	4db6 <wait>
    if (xstatus != 0) {
    1604:	fdc42783          	lw	a5,-36(s0)
    1608:	ebb9                	bnez	a5,165e <forkfork+0x82>
    wait(&xstatus);
    160a:	fdc40513          	addi	a0,s0,-36
    160e:	7a8030ef          	jal	4db6 <wait>
    if (xstatus != 0) {
    1612:	fdc42783          	lw	a5,-36(s0)
    1616:	e7a1                	bnez	a5,165e <forkfork+0x82>
}
    1618:	70a2                	ld	ra,40(sp)
    161a:	7402                	ld	s0,32(sp)
    161c:	64e2                	ld	s1,24(sp)
    161e:	6145                	addi	sp,sp,48
    1620:	8082                	ret
      printf("%s: fork failed", s);
    1622:	85a6                	mv	a1,s1
    1624:	00004517          	auipc	a0,0x4
    1628:	79450513          	addi	a0,a0,1940 # 5db8 <malloc+0xb0e>
    162c:	3cb030ef          	jal	51f6 <printf>
      exit(1);
    1630:	4505                	li	a0,1
    1632:	77c030ef          	jal	4dae <exit>
{
    1636:	0c800493          	li	s1,200
        int pid1 = fork();
    163a:	76c030ef          	jal	4da6 <fork>
        if (pid1 < 0) {
    163e:	00054b63          	bltz	a0,1654 <forkfork+0x78>
        if (pid1 == 0) {
    1642:	cd01                	beqz	a0,165a <forkfork+0x7e>
        wait(0);
    1644:	4501                	li	a0,0
    1646:	770030ef          	jal	4db6 <wait>
      for (int j = 0; j < 200; j++) {
    164a:	34fd                	addiw	s1,s1,-1
    164c:	f4fd                	bnez	s1,163a <forkfork+0x5e>
      exit(0);
    164e:	4501                	li	a0,0
    1650:	75e030ef          	jal	4dae <exit>
          exit(1);
    1654:	4505                	li	a0,1
    1656:	758030ef          	jal	4dae <exit>
          exit(0);
    165a:	754030ef          	jal	4dae <exit>
      printf("%s: fork in child failed", s);
    165e:	85a6                	mv	a1,s1
    1660:	00004517          	auipc	a0,0x4
    1664:	76850513          	addi	a0,a0,1896 # 5dc8 <malloc+0xb1e>
    1668:	38f030ef          	jal	51f6 <printf>
      exit(1);
    166c:	4505                	li	a0,1
    166e:	740030ef          	jal	4dae <exit>

0000000000001672 <reparent2>:
{
    1672:	1101                	addi	sp,sp,-32
    1674:	ec06                	sd	ra,24(sp)
    1676:	e822                	sd	s0,16(sp)
    1678:	e426                	sd	s1,8(sp)
    167a:	1000                	addi	s0,sp,32
    167c:	32000493          	li	s1,800
    int pid1 = fork();
    1680:	726030ef          	jal	4da6 <fork>
    if (pid1 < 0) {
    1684:	00054b63          	bltz	a0,169a <reparent2+0x28>
    if (pid1 == 0) {
    1688:	c115                	beqz	a0,16ac <reparent2+0x3a>
    wait(0);
    168a:	4501                	li	a0,0
    168c:	72a030ef          	jal	4db6 <wait>
  for (int i = 0; i < 800; i++) {
    1690:	34fd                	addiw	s1,s1,-1
    1692:	f4fd                	bnez	s1,1680 <reparent2+0xe>
  exit(0);
    1694:	4501                	li	a0,0
    1696:	718030ef          	jal	4dae <exit>
      printf("fork failed\n");
    169a:	00006517          	auipc	a0,0x6
    169e:	bb650513          	addi	a0,a0,-1098 # 7250 <malloc+0x1fa6>
    16a2:	355030ef          	jal	51f6 <printf>
      exit(1);
    16a6:	4505                	li	a0,1
    16a8:	706030ef          	jal	4dae <exit>
      fork();
    16ac:	6fa030ef          	jal	4da6 <fork>
      fork();
    16b0:	6f6030ef          	jal	4da6 <fork>
      exit(0);
    16b4:	4501                	li	a0,0
    16b6:	6f8030ef          	jal	4dae <exit>

00000000000016ba <createdelete>:
{
    16ba:	7175                	addi	sp,sp,-144
    16bc:	e506                	sd	ra,136(sp)
    16be:	e122                	sd	s0,128(sp)
    16c0:	fca6                	sd	s1,120(sp)
    16c2:	f8ca                	sd	s2,112(sp)
    16c4:	f4ce                	sd	s3,104(sp)
    16c6:	f0d2                	sd	s4,96(sp)
    16c8:	ecd6                	sd	s5,88(sp)
    16ca:	e8da                	sd	s6,80(sp)
    16cc:	e4de                	sd	s7,72(sp)
    16ce:	e0e2                	sd	s8,64(sp)
    16d0:	fc66                	sd	s9,56(sp)
    16d2:	0900                	addi	s0,sp,144
    16d4:	8caa                	mv	s9,a0
  for (pi = 0; pi < NCHILD; pi++) {
    16d6:	4901                	li	s2,0
    16d8:	4991                	li	s3,4
    pid = fork();
    16da:	6cc030ef          	jal	4da6 <fork>
    16de:	84aa                	mv	s1,a0
    if (pid < 0) {
    16e0:	02054d63          	bltz	a0,171a <createdelete+0x60>
    if (pid == 0) {
    16e4:	c529                	beqz	a0,172e <createdelete+0x74>
  for (pi = 0; pi < NCHILD; pi++) {
    16e6:	2905                	addiw	s2,s2,1
    16e8:	ff3919e3          	bne	s2,s3,16da <createdelete+0x20>
    16ec:	4491                	li	s1,4
    wait(&xstatus);
    16ee:	f7c40513          	addi	a0,s0,-132
    16f2:	6c4030ef          	jal	4db6 <wait>
    if (xstatus != 0)
    16f6:	f7c42903          	lw	s2,-132(s0)
    16fa:	0a091e63          	bnez	s2,17b6 <createdelete+0xfc>
  for (pi = 0; pi < NCHILD; pi++) {
    16fe:	34fd                	addiw	s1,s1,-1
    1700:	f4fd                	bnez	s1,16ee <createdelete+0x34>
  name[0] = name[1] = name[2] = 0;
    1702:	f8040123          	sb	zero,-126(s0)
    1706:	03000993          	li	s3,48
    170a:	5a7d                	li	s4,-1
    170c:	07000c13          	li	s8,112
      if ((i == 0 || i >= N / 2) && fd < 0) {
    1710:	4b25                	li	s6,9
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1712:	4ba1                	li	s7,8
    for (pi = 0; pi < NCHILD; pi++) {
    1714:	07400a93          	li	s5,116
    1718:	aa39                	j	1836 <createdelete+0x17c>
      printf("%s: fork failed\n", s);
    171a:	85e6                	mv	a1,s9
    171c:	00004517          	auipc	a0,0x4
    1720:	55c50513          	addi	a0,a0,1372 # 5c78 <malloc+0x9ce>
    1724:	2d3030ef          	jal	51f6 <printf>
      exit(1);
    1728:	4505                	li	a0,1
    172a:	684030ef          	jal	4dae <exit>
      name[0] = 'p' + pi;
    172e:	0709091b          	addiw	s2,s2,112
    1732:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1736:	f8040123          	sb	zero,-126(s0)
      for (i = 0; i < N; i++) {
    173a:	4951                	li	s2,20
    173c:	a831                	j	1758 <createdelete+0x9e>
          printf("%s: create failed\n", s);
    173e:	85e6                	mv	a1,s9
    1740:	00004517          	auipc	a0,0x4
    1744:	6a850513          	addi	a0,a0,1704 # 5de8 <malloc+0xb3e>
    1748:	2af030ef          	jal	51f6 <printf>
          exit(1);
    174c:	4505                	li	a0,1
    174e:	660030ef          	jal	4dae <exit>
      for (i = 0; i < N; i++) {
    1752:	2485                	addiw	s1,s1,1
    1754:	05248e63          	beq	s1,s2,17b0 <createdelete+0xf6>
        name[1] = '0' + i;
    1758:	0304879b          	addiw	a5,s1,48
    175c:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1760:	20200593          	li	a1,514
    1764:	f8040513          	addi	a0,s0,-128
    1768:	686030ef          	jal	4dee <open>
        if (fd < 0) {
    176c:	fc0549e3          	bltz	a0,173e <createdelete+0x84>
        close(fd);
    1770:	666030ef          	jal	4dd6 <close>
        if (i > 0 && (i % 2) == 0) {
    1774:	10905063          	blez	s1,1874 <createdelete+0x1ba>
    1778:	0014f793          	andi	a5,s1,1
    177c:	fbf9                	bnez	a5,1752 <createdelete+0x98>
          name[1] = '0' + (i / 2);
    177e:	01f4d79b          	srliw	a5,s1,0x1f
    1782:	9fa5                	addw	a5,a5,s1
    1784:	4017d79b          	sraiw	a5,a5,0x1
    1788:	0307879b          	addiw	a5,a5,48
    178c:	f8f400a3          	sb	a5,-127(s0)
          if (unlink(name) < 0) {
    1790:	f8040513          	addi	a0,s0,-128
    1794:	66a030ef          	jal	4dfe <unlink>
    1798:	fa055de3          	bgez	a0,1752 <createdelete+0x98>
            printf("%s: unlink failed\n", s);
    179c:	85e6                	mv	a1,s9
    179e:	00004517          	auipc	a0,0x4
    17a2:	66250513          	addi	a0,a0,1634 # 5e00 <malloc+0xb56>
    17a6:	251030ef          	jal	51f6 <printf>
            exit(1);
    17aa:	4505                	li	a0,1
    17ac:	602030ef          	jal	4dae <exit>
      exit(0);
    17b0:	4501                	li	a0,0
    17b2:	5fc030ef          	jal	4dae <exit>
      exit(1);
    17b6:	4505                	li	a0,1
    17b8:	5f6030ef          	jal	4dae <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    17bc:	f8040613          	addi	a2,s0,-128
    17c0:	85e6                	mv	a1,s9
    17c2:	00004517          	auipc	a0,0x4
    17c6:	65650513          	addi	a0,a0,1622 # 5e18 <malloc+0xb6e>
    17ca:	22d030ef          	jal	51f6 <printf>
        exit(1);
    17ce:	4505                	li	a0,1
    17d0:	5de030ef          	jal	4dae <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    17d4:	034bfb63          	bgeu	s7,s4,180a <createdelete+0x150>
      if (fd >= 0)
    17d8:	02055663          	bgez	a0,1804 <createdelete+0x14a>
    for (pi = 0; pi < NCHILD; pi++) {
    17dc:	2485                	addiw	s1,s1,1
    17de:	0ff4f493          	zext.b	s1,s1
    17e2:	05548263          	beq	s1,s5,1826 <createdelete+0x16c>
      name[0] = 'p' + pi;
    17e6:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    17ea:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    17ee:	4581                	li	a1,0
    17f0:	f8040513          	addi	a0,s0,-128
    17f4:	5fa030ef          	jal	4dee <open>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    17f8:	00090463          	beqz	s2,1800 <createdelete+0x146>
    17fc:	fd2b5ce3          	bge	s6,s2,17d4 <createdelete+0x11a>
    1800:	fa054ee3          	bltz	a0,17bc <createdelete+0x102>
        close(fd);
    1804:	5d2030ef          	jal	4dd6 <close>
    1808:	bfd1                	j	17dc <createdelete+0x122>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    180a:	fc0549e3          	bltz	a0,17dc <createdelete+0x122>
        printf("%s: oops createdelete %s did exist\n", s, name);
    180e:	f8040613          	addi	a2,s0,-128
    1812:	85e6                	mv	a1,s9
    1814:	00004517          	auipc	a0,0x4
    1818:	62c50513          	addi	a0,a0,1580 # 5e40 <malloc+0xb96>
    181c:	1db030ef          	jal	51f6 <printf>
        exit(1);
    1820:	4505                	li	a0,1
    1822:	58c030ef          	jal	4dae <exit>
  for (i = 0; i < N; i++) {
    1826:	2905                	addiw	s2,s2,1
    1828:	2a05                	addiw	s4,s4,1
    182a:	2985                	addiw	s3,s3,1
    182c:	0ff9f993          	zext.b	s3,s3
    1830:	47d1                	li	a5,20
    1832:	02f90863          	beq	s2,a5,1862 <createdelete+0x1a8>
    for (pi = 0; pi < NCHILD; pi++) {
    1836:	84e2                	mv	s1,s8
    1838:	b77d                	j	17e6 <createdelete+0x12c>
  for (i = 0; i < N; i++) {
    183a:	2905                	addiw	s2,s2,1
    183c:	0ff97913          	zext.b	s2,s2
    1840:	03490c63          	beq	s2,s4,1878 <createdelete+0x1be>
  name[0] = name[1] = name[2] = 0;
    1844:	84d6                	mv	s1,s5
      name[0] = 'p' + pi;
    1846:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    184a:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    184e:	f8040513          	addi	a0,s0,-128
    1852:	5ac030ef          	jal	4dfe <unlink>
    for (pi = 0; pi < NCHILD; pi++) {
    1856:	2485                	addiw	s1,s1,1
    1858:	0ff4f493          	zext.b	s1,s1
    185c:	ff3495e3          	bne	s1,s3,1846 <createdelete+0x18c>
    1860:	bfe9                	j	183a <createdelete+0x180>
    1862:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    1866:	07000a93          	li	s5,112
    for (pi = 0; pi < NCHILD; pi++) {
    186a:	07400993          	li	s3,116
  for (i = 0; i < N; i++) {
    186e:	04400a13          	li	s4,68
    1872:	bfc9                	j	1844 <createdelete+0x18a>
      for (i = 0; i < N; i++) {
    1874:	2485                	addiw	s1,s1,1
    1876:	b5cd                	j	1758 <createdelete+0x9e>
}
    1878:	60aa                	ld	ra,136(sp)
    187a:	640a                	ld	s0,128(sp)
    187c:	74e6                	ld	s1,120(sp)
    187e:	7946                	ld	s2,112(sp)
    1880:	79a6                	ld	s3,104(sp)
    1882:	7a06                	ld	s4,96(sp)
    1884:	6ae6                	ld	s5,88(sp)
    1886:	6b46                	ld	s6,80(sp)
    1888:	6ba6                	ld	s7,72(sp)
    188a:	6c06                	ld	s8,64(sp)
    188c:	7ce2                	ld	s9,56(sp)
    188e:	6149                	addi	sp,sp,144
    1890:	8082                	ret

0000000000001892 <linkunlink>:
{
    1892:	711d                	addi	sp,sp,-96
    1894:	ec86                	sd	ra,88(sp)
    1896:	e8a2                	sd	s0,80(sp)
    1898:	e4a6                	sd	s1,72(sp)
    189a:	e0ca                	sd	s2,64(sp)
    189c:	fc4e                	sd	s3,56(sp)
    189e:	f852                	sd	s4,48(sp)
    18a0:	f456                	sd	s5,40(sp)
    18a2:	f05a                	sd	s6,32(sp)
    18a4:	ec5e                	sd	s7,24(sp)
    18a6:	e862                	sd	s8,16(sp)
    18a8:	e466                	sd	s9,8(sp)
    18aa:	1080                	addi	s0,sp,96
    18ac:	84aa                	mv	s1,a0
  unlink("x");
    18ae:	00004517          	auipc	a0,0x4
    18b2:	baa50513          	addi	a0,a0,-1110 # 5458 <malloc+0x1ae>
    18b6:	548030ef          	jal	4dfe <unlink>
  pid = fork();
    18ba:	4ec030ef          	jal	4da6 <fork>
  if (pid < 0) {
    18be:	02054b63          	bltz	a0,18f4 <linkunlink+0x62>
    18c2:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    18c4:	06100913          	li	s2,97
    18c8:	c111                	beqz	a0,18cc <linkunlink+0x3a>
    18ca:	4905                	li	s2,1
    18cc:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    18d0:	41c65a37          	lui	s4,0x41c65
    18d4:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c551b5>
    18d8:	698d                	lui	s3,0x3
    18da:	0399899b          	addiw	s3,s3,57 # 3039 <subdir+0x5ed>
    if ((x % 3) == 0) {
    18de:	4a8d                	li	s5,3
    } else if ((x % 3) == 1) {
    18e0:	4b85                	li	s7,1
      unlink("x");
    18e2:	00004b17          	auipc	s6,0x4
    18e6:	b76b0b13          	addi	s6,s6,-1162 # 5458 <malloc+0x1ae>
      link("cat", "x");
    18ea:	00004c17          	auipc	s8,0x4
    18ee:	57ec0c13          	addi	s8,s8,1406 # 5e68 <malloc+0xbbe>
    18f2:	a025                	j	191a <linkunlink+0x88>
    printf("%s: fork failed\n", s);
    18f4:	85a6                	mv	a1,s1
    18f6:	00004517          	auipc	a0,0x4
    18fa:	38250513          	addi	a0,a0,898 # 5c78 <malloc+0x9ce>
    18fe:	0f9030ef          	jal	51f6 <printf>
    exit(1);
    1902:	4505                	li	a0,1
    1904:	4aa030ef          	jal	4dae <exit>
      close(open("x", O_RDWR | O_CREATE));
    1908:	20200593          	li	a1,514
    190c:	855a                	mv	a0,s6
    190e:	4e0030ef          	jal	4dee <open>
    1912:	4c4030ef          	jal	4dd6 <close>
  for (i = 0; i < 100; i++) {
    1916:	34fd                	addiw	s1,s1,-1
    1918:	c495                	beqz	s1,1944 <linkunlink+0xb2>
    x = x * 1103515245 + 12345;
    191a:	034907bb          	mulw	a5,s2,s4
    191e:	013787bb          	addw	a5,a5,s3
    1922:	0007891b          	sext.w	s2,a5
    if ((x % 3) == 0) {
    1926:	0357f7bb          	remuw	a5,a5,s5
    192a:	2781                	sext.w	a5,a5
    192c:	dff1                	beqz	a5,1908 <linkunlink+0x76>
    } else if ((x % 3) == 1) {
    192e:	01778663          	beq	a5,s7,193a <linkunlink+0xa8>
      unlink("x");
    1932:	855a                	mv	a0,s6
    1934:	4ca030ef          	jal	4dfe <unlink>
    1938:	bff9                	j	1916 <linkunlink+0x84>
      link("cat", "x");
    193a:	85da                	mv	a1,s6
    193c:	8562                	mv	a0,s8
    193e:	4d0030ef          	jal	4e0e <link>
    1942:	bfd1                	j	1916 <linkunlink+0x84>
  if (pid)
    1944:	020c8263          	beqz	s9,1968 <linkunlink+0xd6>
    wait(0);
    1948:	4501                	li	a0,0
    194a:	46c030ef          	jal	4db6 <wait>
}
    194e:	60e6                	ld	ra,88(sp)
    1950:	6446                	ld	s0,80(sp)
    1952:	64a6                	ld	s1,72(sp)
    1954:	6906                	ld	s2,64(sp)
    1956:	79e2                	ld	s3,56(sp)
    1958:	7a42                	ld	s4,48(sp)
    195a:	7aa2                	ld	s5,40(sp)
    195c:	7b02                	ld	s6,32(sp)
    195e:	6be2                	ld	s7,24(sp)
    1960:	6c42                	ld	s8,16(sp)
    1962:	6ca2                	ld	s9,8(sp)
    1964:	6125                	addi	sp,sp,96
    1966:	8082                	ret
    exit(0);
    1968:	4501                	li	a0,0
    196a:	444030ef          	jal	4dae <exit>

000000000000196e <forktest>:
{
    196e:	7179                	addi	sp,sp,-48
    1970:	f406                	sd	ra,40(sp)
    1972:	f022                	sd	s0,32(sp)
    1974:	ec26                	sd	s1,24(sp)
    1976:	e84a                	sd	s2,16(sp)
    1978:	e44e                	sd	s3,8(sp)
    197a:	1800                	addi	s0,sp,48
    197c:	89aa                	mv	s3,a0
  for (n = 0; n < N; n++) {
    197e:	4481                	li	s1,0
    1980:	3e800913          	li	s2,1000
    pid = fork();
    1984:	422030ef          	jal	4da6 <fork>
    if (pid < 0)
    1988:	06054063          	bltz	a0,19e8 <forktest+0x7a>
    if (pid == 0)
    198c:	cd11                	beqz	a0,19a8 <forktest+0x3a>
  for (n = 0; n < N; n++) {
    198e:	2485                	addiw	s1,s1,1
    1990:	ff249ae3          	bne	s1,s2,1984 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1994:	85ce                	mv	a1,s3
    1996:	00004517          	auipc	a0,0x4
    199a:	52250513          	addi	a0,a0,1314 # 5eb8 <malloc+0xc0e>
    199e:	059030ef          	jal	51f6 <printf>
    exit(1);
    19a2:	4505                	li	a0,1
    19a4:	40a030ef          	jal	4dae <exit>
      exit(0);
    19a8:	406030ef          	jal	4dae <exit>
    printf("%s: no fork at all!\n", s);
    19ac:	85ce                	mv	a1,s3
    19ae:	00004517          	auipc	a0,0x4
    19b2:	4c250513          	addi	a0,a0,1218 # 5e70 <malloc+0xbc6>
    19b6:	041030ef          	jal	51f6 <printf>
    exit(1);
    19ba:	4505                	li	a0,1
    19bc:	3f2030ef          	jal	4dae <exit>
      printf("%s: wait stopped early\n", s);
    19c0:	85ce                	mv	a1,s3
    19c2:	00004517          	auipc	a0,0x4
    19c6:	4c650513          	addi	a0,a0,1222 # 5e88 <malloc+0xbde>
    19ca:	02d030ef          	jal	51f6 <printf>
      exit(1);
    19ce:	4505                	li	a0,1
    19d0:	3de030ef          	jal	4dae <exit>
    printf("%s: wait got too many\n", s);
    19d4:	85ce                	mv	a1,s3
    19d6:	00004517          	auipc	a0,0x4
    19da:	4ca50513          	addi	a0,a0,1226 # 5ea0 <malloc+0xbf6>
    19de:	019030ef          	jal	51f6 <printf>
    exit(1);
    19e2:	4505                	li	a0,1
    19e4:	3ca030ef          	jal	4dae <exit>
  if (n == 0) {
    19e8:	d0f1                	beqz	s1,19ac <forktest+0x3e>
  for (; n > 0; n--) {
    19ea:	00905963          	blez	s1,19fc <forktest+0x8e>
    if (wait(0) < 0) {
    19ee:	4501                	li	a0,0
    19f0:	3c6030ef          	jal	4db6 <wait>
    19f4:	fc0546e3          	bltz	a0,19c0 <forktest+0x52>
  for (; n > 0; n--) {
    19f8:	34fd                	addiw	s1,s1,-1
    19fa:	f8f5                	bnez	s1,19ee <forktest+0x80>
  if (wait(0) != -1) {
    19fc:	4501                	li	a0,0
    19fe:	3b8030ef          	jal	4db6 <wait>
    1a02:	57fd                	li	a5,-1
    1a04:	fcf518e3          	bne	a0,a5,19d4 <forktest+0x66>
}
    1a08:	70a2                	ld	ra,40(sp)
    1a0a:	7402                	ld	s0,32(sp)
    1a0c:	64e2                	ld	s1,24(sp)
    1a0e:	6942                	ld	s2,16(sp)
    1a10:	69a2                	ld	s3,8(sp)
    1a12:	6145                	addi	sp,sp,48
    1a14:	8082                	ret

0000000000001a16 <kernmem>:
{
    1a16:	715d                	addi	sp,sp,-80
    1a18:	e486                	sd	ra,72(sp)
    1a1a:	e0a2                	sd	s0,64(sp)
    1a1c:	fc26                	sd	s1,56(sp)
    1a1e:	f84a                	sd	s2,48(sp)
    1a20:	f44e                	sd	s3,40(sp)
    1a22:	f052                	sd	s4,32(sp)
    1a24:	ec56                	sd	s5,24(sp)
    1a26:	0880                	addi	s0,sp,80
    1a28:	8aaa                	mv	s5,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1a2a:	4485                	li	s1,1
    1a2c:	04fe                	slli	s1,s1,0x1f
    if (xstatus != -1) // did kernel kill child?
    1a2e:	5a7d                	li	s4,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1a30:	69b1                	lui	s3,0xc
    1a32:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1da8>
    1a36:	1003d937          	lui	s2,0x1003d
    1a3a:	090e                	slli	s2,s2,0x3
    1a3c:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d7c8>
    pid = fork();
    1a40:	366030ef          	jal	4da6 <fork>
    if (pid < 0) {
    1a44:	02054763          	bltz	a0,1a72 <kernmem+0x5c>
    if (pid == 0) {
    1a48:	cd1d                	beqz	a0,1a86 <kernmem+0x70>
    wait(&xstatus);
    1a4a:	fbc40513          	addi	a0,s0,-68
    1a4e:	368030ef          	jal	4db6 <wait>
    if (xstatus != -1) // did kernel kill child?
    1a52:	fbc42783          	lw	a5,-68(s0)
    1a56:	05479563          	bne	a5,s4,1aa0 <kernmem+0x8a>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1a5a:	94ce                	add	s1,s1,s3
    1a5c:	ff2492e3          	bne	s1,s2,1a40 <kernmem+0x2a>
}
    1a60:	60a6                	ld	ra,72(sp)
    1a62:	6406                	ld	s0,64(sp)
    1a64:	74e2                	ld	s1,56(sp)
    1a66:	7942                	ld	s2,48(sp)
    1a68:	79a2                	ld	s3,40(sp)
    1a6a:	7a02                	ld	s4,32(sp)
    1a6c:	6ae2                	ld	s5,24(sp)
    1a6e:	6161                	addi	sp,sp,80
    1a70:	8082                	ret
      printf("%s: fork failed\n", s);
    1a72:	85d6                	mv	a1,s5
    1a74:	00004517          	auipc	a0,0x4
    1a78:	20450513          	addi	a0,a0,516 # 5c78 <malloc+0x9ce>
    1a7c:	77a030ef          	jal	51f6 <printf>
      exit(1);
    1a80:	4505                	li	a0,1
    1a82:	32c030ef          	jal	4dae <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1a86:	0004c683          	lbu	a3,0(s1)
    1a8a:	8626                	mv	a2,s1
    1a8c:	85d6                	mv	a1,s5
    1a8e:	00004517          	auipc	a0,0x4
    1a92:	45250513          	addi	a0,a0,1106 # 5ee0 <malloc+0xc36>
    1a96:	760030ef          	jal	51f6 <printf>
      exit(1);
    1a9a:	4505                	li	a0,1
    1a9c:	312030ef          	jal	4dae <exit>
      exit(1);
    1aa0:	4505                	li	a0,1
    1aa2:	30c030ef          	jal	4dae <exit>

0000000000001aa6 <MAXVAplus>:
{
    1aa6:	7179                	addi	sp,sp,-48
    1aa8:	f406                	sd	ra,40(sp)
    1aaa:	f022                	sd	s0,32(sp)
    1aac:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    1aae:	4785                	li	a5,1
    1ab0:	179a                	slli	a5,a5,0x26
    1ab2:	fcf43c23          	sd	a5,-40(s0)
  for (; a != 0; a <<= 1) {
    1ab6:	fd843783          	ld	a5,-40(s0)
    1aba:	cf85                	beqz	a5,1af2 <MAXVAplus+0x4c>
    1abc:	ec26                	sd	s1,24(sp)
    1abe:	e84a                	sd	s2,16(sp)
    1ac0:	892a                	mv	s2,a0
    if (xstatus != -1) // did kernel kill child?
    1ac2:	54fd                	li	s1,-1
    pid = fork();
    1ac4:	2e2030ef          	jal	4da6 <fork>
    if (pid < 0) {
    1ac8:	02054963          	bltz	a0,1afa <MAXVAplus+0x54>
    if (pid == 0) {
    1acc:	c129                	beqz	a0,1b0e <MAXVAplus+0x68>
    wait(&xstatus);
    1ace:	fd440513          	addi	a0,s0,-44
    1ad2:	2e4030ef          	jal	4db6 <wait>
    if (xstatus != -1) // did kernel kill child?
    1ad6:	fd442783          	lw	a5,-44(s0)
    1ada:	04979c63          	bne	a5,s1,1b32 <MAXVAplus+0x8c>
  for (; a != 0; a <<= 1) {
    1ade:	fd843783          	ld	a5,-40(s0)
    1ae2:	0786                	slli	a5,a5,0x1
    1ae4:	fcf43c23          	sd	a5,-40(s0)
    1ae8:	fd843783          	ld	a5,-40(s0)
    1aec:	ffe1                	bnez	a5,1ac4 <MAXVAplus+0x1e>
    1aee:	64e2                	ld	s1,24(sp)
    1af0:	6942                	ld	s2,16(sp)
}
    1af2:	70a2                	ld	ra,40(sp)
    1af4:	7402                	ld	s0,32(sp)
    1af6:	6145                	addi	sp,sp,48
    1af8:	8082                	ret
      printf("%s: fork failed\n", s);
    1afa:	85ca                	mv	a1,s2
    1afc:	00004517          	auipc	a0,0x4
    1b00:	17c50513          	addi	a0,a0,380 # 5c78 <malloc+0x9ce>
    1b04:	6f2030ef          	jal	51f6 <printf>
      exit(1);
    1b08:	4505                	li	a0,1
    1b0a:	2a4030ef          	jal	4dae <exit>
      *(char *)a = 99;
    1b0e:	fd843783          	ld	a5,-40(s0)
    1b12:	06300713          	li	a4,99
    1b16:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void *)a);
    1b1a:	fd843603          	ld	a2,-40(s0)
    1b1e:	85ca                	mv	a1,s2
    1b20:	00004517          	auipc	a0,0x4
    1b24:	3e050513          	addi	a0,a0,992 # 5f00 <malloc+0xc56>
    1b28:	6ce030ef          	jal	51f6 <printf>
      exit(1);
    1b2c:	4505                	li	a0,1
    1b2e:	280030ef          	jal	4dae <exit>
      exit(1);
    1b32:	4505                	li	a0,1
    1b34:	27a030ef          	jal	4dae <exit>

0000000000001b38 <stacktest>:
{
    1b38:	7179                	addi	sp,sp,-48
    1b3a:	f406                	sd	ra,40(sp)
    1b3c:	f022                	sd	s0,32(sp)
    1b3e:	ec26                	sd	s1,24(sp)
    1b40:	1800                	addi	s0,sp,48
    1b42:	84aa                	mv	s1,a0
  pid = fork();
    1b44:	262030ef          	jal	4da6 <fork>
  if (pid == 0) {
    1b48:	cd11                	beqz	a0,1b64 <stacktest+0x2c>
  } else if (pid < 0) {
    1b4a:	02054c63          	bltz	a0,1b82 <stacktest+0x4a>
  wait(&xstatus);
    1b4e:	fdc40513          	addi	a0,s0,-36
    1b52:	264030ef          	jal	4db6 <wait>
  if (xstatus == -1) // kernel killed child?
    1b56:	fdc42503          	lw	a0,-36(s0)
    1b5a:	57fd                	li	a5,-1
    1b5c:	02f50d63          	beq	a0,a5,1b96 <stacktest+0x5e>
    exit(xstatus);
    1b60:	24e030ef          	jal	4dae <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r"(x));
    1b64:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1b66:	77fd                	lui	a5,0xfffff
    1b68:	97ba                	add	a5,a5,a4
    1b6a:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef348>
    1b6e:	85a6                	mv	a1,s1
    1b70:	00004517          	auipc	a0,0x4
    1b74:	3a850513          	addi	a0,a0,936 # 5f18 <malloc+0xc6e>
    1b78:	67e030ef          	jal	51f6 <printf>
    exit(1);
    1b7c:	4505                	li	a0,1
    1b7e:	230030ef          	jal	4dae <exit>
    printf("%s: fork failed\n", s);
    1b82:	85a6                	mv	a1,s1
    1b84:	00004517          	auipc	a0,0x4
    1b88:	0f450513          	addi	a0,a0,244 # 5c78 <malloc+0x9ce>
    1b8c:	66a030ef          	jal	51f6 <printf>
    exit(1);
    1b90:	4505                	li	a0,1
    1b92:	21c030ef          	jal	4dae <exit>
    exit(0);
    1b96:	4501                	li	a0,0
    1b98:	216030ef          	jal	4dae <exit>

0000000000001b9c <nowrite>:
{
    1b9c:	7159                	addi	sp,sp,-112
    1b9e:	f486                	sd	ra,104(sp)
    1ba0:	f0a2                	sd	s0,96(sp)
    1ba2:	eca6                	sd	s1,88(sp)
    1ba4:	e8ca                	sd	s2,80(sp)
    1ba6:	e4ce                	sd	s3,72(sp)
    1ba8:	1880                	addi	s0,sp,112
    1baa:	89aa                	mv	s3,a0
  uint64 addrs[] = {0,
    1bac:	00006797          	auipc	a5,0x6
    1bb0:	db478793          	addi	a5,a5,-588 # 7960 <malloc+0x26b6>
    1bb4:	7788                	ld	a0,40(a5)
    1bb6:	7b8c                	ld	a1,48(a5)
    1bb8:	7f90                	ld	a2,56(a5)
    1bba:	63b4                	ld	a3,64(a5)
    1bbc:	67b8                	ld	a4,72(a5)
    1bbe:	6bbc                	ld	a5,80(a5)
    1bc0:	f8a43c23          	sd	a0,-104(s0)
    1bc4:	fab43023          	sd	a1,-96(s0)
    1bc8:	fac43423          	sd	a2,-88(s0)
    1bcc:	fad43823          	sd	a3,-80(s0)
    1bd0:	fae43c23          	sd	a4,-72(s0)
    1bd4:	fcf43023          	sd	a5,-64(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1bd8:	4481                	li	s1,0
    1bda:	4919                	li	s2,6
    pid = fork();
    1bdc:	1ca030ef          	jal	4da6 <fork>
    if (pid == 0) {
    1be0:	c105                	beqz	a0,1c00 <nowrite+0x64>
    } else if (pid < 0) {
    1be2:	04054263          	bltz	a0,1c26 <nowrite+0x8a>
    wait(&xstatus);
    1be6:	fcc40513          	addi	a0,s0,-52
    1bea:	1cc030ef          	jal	4db6 <wait>
    if (xstatus == 0) {
    1bee:	fcc42783          	lw	a5,-52(s0)
    1bf2:	c7a1                	beqz	a5,1c3a <nowrite+0x9e>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1bf4:	2485                	addiw	s1,s1,1
    1bf6:	ff2493e3          	bne	s1,s2,1bdc <nowrite+0x40>
  exit(0);
    1bfa:	4501                	li	a0,0
    1bfc:	1b2030ef          	jal	4dae <exit>
      volatile int *addr = (int *)addrs[ai];
    1c00:	048e                	slli	s1,s1,0x3
    1c02:	fd048793          	addi	a5,s1,-48
    1c06:	008784b3          	add	s1,a5,s0
    1c0a:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1c0e:	47a9                	li	a5,10
    1c10:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1c12:	85ce                	mv	a1,s3
    1c14:	00004517          	auipc	a0,0x4
    1c18:	32c50513          	addi	a0,a0,812 # 5f40 <malloc+0xc96>
    1c1c:	5da030ef          	jal	51f6 <printf>
      exit(0);
    1c20:	4501                	li	a0,0
    1c22:	18c030ef          	jal	4dae <exit>
      printf("%s: fork failed\n", s);
    1c26:	85ce                	mv	a1,s3
    1c28:	00004517          	auipc	a0,0x4
    1c2c:	05050513          	addi	a0,a0,80 # 5c78 <malloc+0x9ce>
    1c30:	5c6030ef          	jal	51f6 <printf>
      exit(1);
    1c34:	4505                	li	a0,1
    1c36:	178030ef          	jal	4dae <exit>
      exit(1);
    1c3a:	4505                	li	a0,1
    1c3c:	172030ef          	jal	4dae <exit>

0000000000001c40 <manywrites>:
{
    1c40:	711d                	addi	sp,sp,-96
    1c42:	ec86                	sd	ra,88(sp)
    1c44:	e8a2                	sd	s0,80(sp)
    1c46:	e4a6                	sd	s1,72(sp)
    1c48:	e0ca                	sd	s2,64(sp)
    1c4a:	fc4e                	sd	s3,56(sp)
    1c4c:	f456                	sd	s5,40(sp)
    1c4e:	1080                	addi	s0,sp,96
    1c50:	8aaa                	mv	s5,a0
  for (int ci = 0; ci < nchildren; ci++) {
    1c52:	4981                	li	s3,0
    1c54:	4911                	li	s2,4
    int pid = fork();
    1c56:	150030ef          	jal	4da6 <fork>
    1c5a:	84aa                	mv	s1,a0
    if (pid < 0) {
    1c5c:	02054963          	bltz	a0,1c8e <manywrites+0x4e>
    if (pid == 0) {
    1c60:	c139                	beqz	a0,1ca6 <manywrites+0x66>
  for (int ci = 0; ci < nchildren; ci++) {
    1c62:	2985                	addiw	s3,s3,1
    1c64:	ff2999e3          	bne	s3,s2,1c56 <manywrites+0x16>
    1c68:	f852                	sd	s4,48(sp)
    1c6a:	f05a                	sd	s6,32(sp)
    1c6c:	ec5e                	sd	s7,24(sp)
    1c6e:	4491                	li	s1,4
    int st = 0;
    1c70:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1c74:	fa840513          	addi	a0,s0,-88
    1c78:	13e030ef          	jal	4db6 <wait>
    if (st != 0)
    1c7c:	fa842503          	lw	a0,-88(s0)
    1c80:	0c051863          	bnez	a0,1d50 <manywrites+0x110>
  for (int ci = 0; ci < nchildren; ci++) {
    1c84:	34fd                	addiw	s1,s1,-1
    1c86:	f4ed                	bnez	s1,1c70 <manywrites+0x30>
  exit(0);
    1c88:	4501                	li	a0,0
    1c8a:	124030ef          	jal	4dae <exit>
    1c8e:	f852                	sd	s4,48(sp)
    1c90:	f05a                	sd	s6,32(sp)
    1c92:	ec5e                	sd	s7,24(sp)
      printf("fork failed\n");
    1c94:	00005517          	auipc	a0,0x5
    1c98:	5bc50513          	addi	a0,a0,1468 # 7250 <malloc+0x1fa6>
    1c9c:	55a030ef          	jal	51f6 <printf>
      exit(1);
    1ca0:	4505                	li	a0,1
    1ca2:	10c030ef          	jal	4dae <exit>
    1ca6:	f852                	sd	s4,48(sp)
    1ca8:	f05a                	sd	s6,32(sp)
    1caa:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    1cac:	06200793          	li	a5,98
    1cb0:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1cb4:	0619879b          	addiw	a5,s3,97
    1cb8:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1cbc:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1cc0:	fa840513          	addi	a0,s0,-88
    1cc4:	13a030ef          	jal	4dfe <unlink>
    1cc8:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1cca:	0000bb17          	auipc	s6,0xb
    1cce:	feeb0b13          	addi	s6,s6,-18 # ccb8 <buf>
        for (int i = 0; i < ci + 1; i++) {
    1cd2:	8a26                	mv	s4,s1
    1cd4:	0209c863          	bltz	s3,1d04 <manywrites+0xc4>
          int fd = open(name, O_CREATE | O_RDWR);
    1cd8:	20200593          	li	a1,514
    1cdc:	fa840513          	addi	a0,s0,-88
    1ce0:	10e030ef          	jal	4dee <open>
    1ce4:	892a                	mv	s2,a0
          if (fd < 0) {
    1ce6:	02054d63          	bltz	a0,1d20 <manywrites+0xe0>
          int cc = write(fd, buf, sz);
    1cea:	660d                	lui	a2,0x3
    1cec:	85da                	mv	a1,s6
    1cee:	0e0030ef          	jal	4dce <write>
          if (cc != sz) {
    1cf2:	678d                	lui	a5,0x3
    1cf4:	04f51263          	bne	a0,a5,1d38 <manywrites+0xf8>
          close(fd);
    1cf8:	854a                	mv	a0,s2
    1cfa:	0dc030ef          	jal	4dd6 <close>
        for (int i = 0; i < ci + 1; i++) {
    1cfe:	2a05                	addiw	s4,s4,1
    1d00:	fd49dce3          	bge	s3,s4,1cd8 <manywrites+0x98>
        unlink(name);
    1d04:	fa840513          	addi	a0,s0,-88
    1d08:	0f6030ef          	jal	4dfe <unlink>
      for (int iters = 0; iters < howmany; iters++) {
    1d0c:	3bfd                	addiw	s7,s7,-1
    1d0e:	fc0b92e3          	bnez	s7,1cd2 <manywrites+0x92>
      unlink(name);
    1d12:	fa840513          	addi	a0,s0,-88
    1d16:	0e8030ef          	jal	4dfe <unlink>
      exit(0);
    1d1a:	4501                	li	a0,0
    1d1c:	092030ef          	jal	4dae <exit>
            printf("%s: cannot create %s\n", s, name);
    1d20:	fa840613          	addi	a2,s0,-88
    1d24:	85d6                	mv	a1,s5
    1d26:	00004517          	auipc	a0,0x4
    1d2a:	23a50513          	addi	a0,a0,570 # 5f60 <malloc+0xcb6>
    1d2e:	4c8030ef          	jal	51f6 <printf>
            exit(1);
    1d32:	4505                	li	a0,1
    1d34:	07a030ef          	jal	4dae <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1d38:	86aa                	mv	a3,a0
    1d3a:	660d                	lui	a2,0x3
    1d3c:	85d6                	mv	a1,s5
    1d3e:	00003517          	auipc	a0,0x3
    1d42:	77a50513          	addi	a0,a0,1914 # 54b8 <malloc+0x20e>
    1d46:	4b0030ef          	jal	51f6 <printf>
            exit(1);
    1d4a:	4505                	li	a0,1
    1d4c:	062030ef          	jal	4dae <exit>
      exit(st);
    1d50:	05e030ef          	jal	4dae <exit>

0000000000001d54 <copyinstr3>:
{
    1d54:	7179                	addi	sp,sp,-48
    1d56:	f406                	sd	ra,40(sp)
    1d58:	f022                	sd	s0,32(sp)
    1d5a:	ec26                	sd	s1,24(sp)
    1d5c:	1800                	addi	s0,sp,48
  sbrk(8192);
    1d5e:	6509                	lui	a0,0x2
    1d60:	01a030ef          	jal	4d7a <sbrk>
  uint64 top = (uint64)sbrk(0);
    1d64:	4501                	li	a0,0
    1d66:	014030ef          	jal	4d7a <sbrk>
  if ((top % PGSIZE) != 0) {
    1d6a:	03451793          	slli	a5,a0,0x34
    1d6e:	e7bd                	bnez	a5,1ddc <copyinstr3+0x88>
  top = (uint64)sbrk(0);
    1d70:	4501                	li	a0,0
    1d72:	008030ef          	jal	4d7a <sbrk>
  if (top % PGSIZE) {
    1d76:	03451793          	slli	a5,a0,0x34
    1d7a:	ebad                	bnez	a5,1dec <copyinstr3+0x98>
  char *b = (char *)(top - 1);
    1d7c:	fff50493          	addi	s1,a0,-1 # 1fff <sbrkbasic+0xa1>
  *b = 'x';
    1d80:	07800793          	li	a5,120
    1d84:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1d88:	8526                	mv	a0,s1
    1d8a:	074030ef          	jal	4dfe <unlink>
  if (ret != -1) {
    1d8e:	57fd                	li	a5,-1
    1d90:	06f51763          	bne	a0,a5,1dfe <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1d94:	20100593          	li	a1,513
    1d98:	8526                	mv	a0,s1
    1d9a:	054030ef          	jal	4dee <open>
  if (fd != -1) {
    1d9e:	57fd                	li	a5,-1
    1da0:	06f51a63          	bne	a0,a5,1e14 <copyinstr3+0xc0>
  ret = link(b, b);
    1da4:	85a6                	mv	a1,s1
    1da6:	8526                	mv	a0,s1
    1da8:	066030ef          	jal	4e0e <link>
  if (ret != -1) {
    1dac:	57fd                	li	a5,-1
    1dae:	06f51e63          	bne	a0,a5,1e2a <copyinstr3+0xd6>
  char *args[] = {"xx", 0};
    1db2:	00005797          	auipc	a5,0x5
    1db6:	eae78793          	addi	a5,a5,-338 # 6c60 <malloc+0x19b6>
    1dba:	fcf43823          	sd	a5,-48(s0)
    1dbe:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1dc2:	fd040593          	addi	a1,s0,-48
    1dc6:	8526                	mv	a0,s1
    1dc8:	01e030ef          	jal	4de6 <exec>
  if (ret != -1) {
    1dcc:	57fd                	li	a5,-1
    1dce:	06f51a63          	bne	a0,a5,1e42 <copyinstr3+0xee>
}
    1dd2:	70a2                	ld	ra,40(sp)
    1dd4:	7402                	ld	s0,32(sp)
    1dd6:	64e2                	ld	s1,24(sp)
    1dd8:	6145                	addi	sp,sp,48
    1dda:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1ddc:	0347d513          	srli	a0,a5,0x34
    1de0:	6785                	lui	a5,0x1
    1de2:	40a7853b          	subw	a0,a5,a0
    1de6:	795020ef          	jal	4d7a <sbrk>
    1dea:	b759                	j	1d70 <copyinstr3+0x1c>
    printf("oops\n");
    1dec:	00004517          	auipc	a0,0x4
    1df0:	18c50513          	addi	a0,a0,396 # 5f78 <malloc+0xcce>
    1df4:	402030ef          	jal	51f6 <printf>
    exit(1);
    1df8:	4505                	li	a0,1
    1dfa:	7b5020ef          	jal	4dae <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1dfe:	862a                	mv	a2,a0
    1e00:	85a6                	mv	a1,s1
    1e02:	00004517          	auipc	a0,0x4
    1e06:	d9650513          	addi	a0,a0,-618 # 5b98 <malloc+0x8ee>
    1e0a:	3ec030ef          	jal	51f6 <printf>
    exit(1);
    1e0e:	4505                	li	a0,1
    1e10:	79f020ef          	jal	4dae <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1e14:	862a                	mv	a2,a0
    1e16:	85a6                	mv	a1,s1
    1e18:	00004517          	auipc	a0,0x4
    1e1c:	da050513          	addi	a0,a0,-608 # 5bb8 <malloc+0x90e>
    1e20:	3d6030ef          	jal	51f6 <printf>
    exit(1);
    1e24:	4505                	li	a0,1
    1e26:	789020ef          	jal	4dae <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1e2a:	86aa                	mv	a3,a0
    1e2c:	8626                	mv	a2,s1
    1e2e:	85a6                	mv	a1,s1
    1e30:	00004517          	auipc	a0,0x4
    1e34:	da850513          	addi	a0,a0,-600 # 5bd8 <malloc+0x92e>
    1e38:	3be030ef          	jal	51f6 <printf>
    exit(1);
    1e3c:	4505                	li	a0,1
    1e3e:	771020ef          	jal	4dae <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1e42:	567d                	li	a2,-1
    1e44:	85a6                	mv	a1,s1
    1e46:	00004517          	auipc	a0,0x4
    1e4a:	dba50513          	addi	a0,a0,-582 # 5c00 <malloc+0x956>
    1e4e:	3a8030ef          	jal	51f6 <printf>
    exit(1);
    1e52:	4505                	li	a0,1
    1e54:	75b020ef          	jal	4dae <exit>

0000000000001e58 <rwsbrk>:
{
    1e58:	1101                	addi	sp,sp,-32
    1e5a:	ec06                	sd	ra,24(sp)
    1e5c:	e822                	sd	s0,16(sp)
    1e5e:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    1e60:	6509                	lui	a0,0x2
    1e62:	719020ef          	jal	4d7a <sbrk>
  if (a == (uint64)SBRK_ERROR) {
    1e66:	57fd                	li	a5,-1
    1e68:	04f50a63          	beq	a0,a5,1ebc <rwsbrk+0x64>
    1e6c:	e426                	sd	s1,8(sp)
    1e6e:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    1e70:	7579                	lui	a0,0xffffe
    1e72:	709020ef          	jal	4d7a <sbrk>
    1e76:	57fd                	li	a5,-1
    1e78:	04f50d63          	beq	a0,a5,1ed2 <rwsbrk+0x7a>
    1e7c:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    1e7e:	20100593          	li	a1,513
    1e82:	00004517          	auipc	a0,0x4
    1e86:	13650513          	addi	a0,a0,310 # 5fb8 <malloc+0xd0e>
    1e8a:	765020ef          	jal	4dee <open>
    1e8e:	892a                	mv	s2,a0
  if (fd < 0) {
    1e90:	04054b63          	bltz	a0,1ee6 <rwsbrk+0x8e>
  n = write(fd, (void *)(a + PGSIZE), 1024);
    1e94:	6785                	lui	a5,0x1
    1e96:	94be                	add	s1,s1,a5
    1e98:	40000613          	li	a2,1024
    1e9c:	85a6                	mv	a1,s1
    1e9e:	731020ef          	jal	4dce <write>
    1ea2:	862a                	mv	a2,a0
  if (n >= 0) {
    1ea4:	04054a63          	bltz	a0,1ef8 <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void *)a + PGSIZE, n);
    1ea8:	85a6                	mv	a1,s1
    1eaa:	00004517          	auipc	a0,0x4
    1eae:	12e50513          	addi	a0,a0,302 # 5fd8 <malloc+0xd2e>
    1eb2:	344030ef          	jal	51f6 <printf>
    exit(1);
    1eb6:	4505                	li	a0,1
    1eb8:	6f7020ef          	jal	4dae <exit>
    1ebc:	e426                	sd	s1,8(sp)
    1ebe:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    1ec0:	00004517          	auipc	a0,0x4
    1ec4:	0c050513          	addi	a0,a0,192 # 5f80 <malloc+0xcd6>
    1ec8:	32e030ef          	jal	51f6 <printf>
    exit(1);
    1ecc:	4505                	li	a0,1
    1ece:	6e1020ef          	jal	4dae <exit>
    1ed2:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    1ed4:	00004517          	auipc	a0,0x4
    1ed8:	0c450513          	addi	a0,a0,196 # 5f98 <malloc+0xcee>
    1edc:	31a030ef          	jal	51f6 <printf>
    exit(1);
    1ee0:	4505                	li	a0,1
    1ee2:	6cd020ef          	jal	4dae <exit>
    printf("open(rwsbrk) failed\n");
    1ee6:	00004517          	auipc	a0,0x4
    1eea:	0da50513          	addi	a0,a0,218 # 5fc0 <malloc+0xd16>
    1eee:	308030ef          	jal	51f6 <printf>
    exit(1);
    1ef2:	4505                	li	a0,1
    1ef4:	6bb020ef          	jal	4dae <exit>
  close(fd);
    1ef8:	854a                	mv	a0,s2
    1efa:	6dd020ef          	jal	4dd6 <close>
  unlink("rwsbrk");
    1efe:	00004517          	auipc	a0,0x4
    1f02:	0ba50513          	addi	a0,a0,186 # 5fb8 <malloc+0xd0e>
    1f06:	6f9020ef          	jal	4dfe <unlink>
  fd = open("README", O_RDONLY);
    1f0a:	4581                	li	a1,0
    1f0c:	00003517          	auipc	a0,0x3
    1f10:	6b450513          	addi	a0,a0,1716 # 55c0 <malloc+0x316>
    1f14:	6db020ef          	jal	4dee <open>
    1f18:	892a                	mv	s2,a0
  if (fd < 0) {
    1f1a:	02054363          	bltz	a0,1f40 <rwsbrk+0xe8>
  n = read(fd, (void *)(a + PGSIZE), 10);
    1f1e:	4629                	li	a2,10
    1f20:	85a6                	mv	a1,s1
    1f22:	6a5020ef          	jal	4dc6 <read>
    1f26:	862a                	mv	a2,a0
  if (n >= 0) {
    1f28:	02054563          	bltz	a0,1f52 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void *)a + PGSIZE, n);
    1f2c:	85a6                	mv	a1,s1
    1f2e:	00004517          	auipc	a0,0x4
    1f32:	0da50513          	addi	a0,a0,218 # 6008 <malloc+0xd5e>
    1f36:	2c0030ef          	jal	51f6 <printf>
    exit(1);
    1f3a:	4505                	li	a0,1
    1f3c:	673020ef          	jal	4dae <exit>
    printf("open(README) failed\n");
    1f40:	00003517          	auipc	a0,0x3
    1f44:	68850513          	addi	a0,a0,1672 # 55c8 <malloc+0x31e>
    1f48:	2ae030ef          	jal	51f6 <printf>
    exit(1);
    1f4c:	4505                	li	a0,1
    1f4e:	661020ef          	jal	4dae <exit>
  close(fd);
    1f52:	854a                	mv	a0,s2
    1f54:	683020ef          	jal	4dd6 <close>
  exit(0);
    1f58:	4501                	li	a0,0
    1f5a:	655020ef          	jal	4dae <exit>

0000000000001f5e <sbrkbasic>:
{
    1f5e:	7139                	addi	sp,sp,-64
    1f60:	fc06                	sd	ra,56(sp)
    1f62:	f822                	sd	s0,48(sp)
    1f64:	ec4e                	sd	s3,24(sp)
    1f66:	0080                	addi	s0,sp,64
    1f68:	89aa                	mv	s3,a0
  pid = fork();
    1f6a:	63d020ef          	jal	4da6 <fork>
  if (pid < 0) {
    1f6e:	02054b63          	bltz	a0,1fa4 <sbrkbasic+0x46>
  if (pid == 0) {
    1f72:	e939                	bnez	a0,1fc8 <sbrkbasic+0x6a>
    a = sbrk(TOOMUCH);
    1f74:	40000537          	lui	a0,0x40000
    1f78:	603020ef          	jal	4d7a <sbrk>
    if (a == (char *)SBRK_ERROR) {
    1f7c:	57fd                	li	a5,-1
    1f7e:	02f50f63          	beq	a0,a5,1fbc <sbrkbasic+0x5e>
    1f82:	f426                	sd	s1,40(sp)
    1f84:	f04a                	sd	s2,32(sp)
    1f86:	e852                	sd	s4,16(sp)
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    1f88:	400007b7          	lui	a5,0x40000
    1f8c:	97aa                	add	a5,a5,a0
      *b = 99;
    1f8e:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    1f92:	6705                	lui	a4,0x1
      *b = 99;
    1f94:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0348>
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    1f98:	953a                	add	a0,a0,a4
    1f9a:	fef51de3          	bne	a0,a5,1f94 <sbrkbasic+0x36>
    exit(1);
    1f9e:	4505                	li	a0,1
    1fa0:	60f020ef          	jal	4dae <exit>
    1fa4:	f426                	sd	s1,40(sp)
    1fa6:	f04a                	sd	s2,32(sp)
    1fa8:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    1faa:	00004517          	auipc	a0,0x4
    1fae:	08650513          	addi	a0,a0,134 # 6030 <malloc+0xd86>
    1fb2:	244030ef          	jal	51f6 <printf>
    exit(1);
    1fb6:	4505                	li	a0,1
    1fb8:	5f7020ef          	jal	4dae <exit>
    1fbc:	f426                	sd	s1,40(sp)
    1fbe:	f04a                	sd	s2,32(sp)
    1fc0:	e852                	sd	s4,16(sp)
      exit(0);
    1fc2:	4501                	li	a0,0
    1fc4:	5eb020ef          	jal	4dae <exit>
  wait(&xstatus);
    1fc8:	fcc40513          	addi	a0,s0,-52
    1fcc:	5eb020ef          	jal	4db6 <wait>
  if (xstatus == 1) {
    1fd0:	fcc42703          	lw	a4,-52(s0)
    1fd4:	4785                	li	a5,1
    1fd6:	00f70e63          	beq	a4,a5,1ff2 <sbrkbasic+0x94>
    1fda:	f426                	sd	s1,40(sp)
    1fdc:	f04a                	sd	s2,32(sp)
    1fde:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    1fe0:	4501                	li	a0,0
    1fe2:	599020ef          	jal	4d7a <sbrk>
    1fe6:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++) {
    1fe8:	4901                	li	s2,0
    1fea:	6a05                	lui	s4,0x1
    1fec:	388a0a13          	addi	s4,s4,904 # 1388 <pipe1+0x4a>
    1ff0:	a839                	j	200e <sbrkbasic+0xb0>
    1ff2:	f426                	sd	s1,40(sp)
    1ff4:	f04a                	sd	s2,32(sp)
    1ff6:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    1ff8:	85ce                	mv	a1,s3
    1ffa:	00004517          	auipc	a0,0x4
    1ffe:	05650513          	addi	a0,a0,86 # 6050 <malloc+0xda6>
    2002:	1f4030ef          	jal	51f6 <printf>
    exit(1);
    2006:	4505                	li	a0,1
    2008:	5a7020ef          	jal	4dae <exit>
    200c:	84be                	mv	s1,a5
    b = sbrk(1);
    200e:	4505                	li	a0,1
    2010:	56b020ef          	jal	4d7a <sbrk>
    if (b != a) {
    2014:	04951263          	bne	a0,s1,2058 <sbrkbasic+0xfa>
    *b = 1;
    2018:	4785                	li	a5,1
    201a:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    201e:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++) {
    2022:	2905                	addiw	s2,s2,1
    2024:	ff4914e3          	bne	s2,s4,200c <sbrkbasic+0xae>
  pid = fork();
    2028:	57f020ef          	jal	4da6 <fork>
    202c:	892a                	mv	s2,a0
  if (pid < 0) {
    202e:	04054263          	bltz	a0,2072 <sbrkbasic+0x114>
  c = sbrk(1);
    2032:	4505                	li	a0,1
    2034:	547020ef          	jal	4d7a <sbrk>
  c = sbrk(1);
    2038:	4505                	li	a0,1
    203a:	541020ef          	jal	4d7a <sbrk>
  if (c != a + 1) {
    203e:	0489                	addi	s1,s1,2
    2040:	04a48363          	beq	s1,a0,2086 <sbrkbasic+0x128>
    printf("%s: sbrk test failed post-fork\n", s);
    2044:	85ce                	mv	a1,s3
    2046:	00004517          	auipc	a0,0x4
    204a:	06a50513          	addi	a0,a0,106 # 60b0 <malloc+0xe06>
    204e:	1a8030ef          	jal	51f6 <printf>
    exit(1);
    2052:	4505                	li	a0,1
    2054:	55b020ef          	jal	4dae <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    2058:	872a                	mv	a4,a0
    205a:	86a6                	mv	a3,s1
    205c:	864a                	mv	a2,s2
    205e:	85ce                	mv	a1,s3
    2060:	00004517          	auipc	a0,0x4
    2064:	01050513          	addi	a0,a0,16 # 6070 <malloc+0xdc6>
    2068:	18e030ef          	jal	51f6 <printf>
      exit(1);
    206c:	4505                	li	a0,1
    206e:	541020ef          	jal	4dae <exit>
    printf("%s: sbrk test fork failed\n", s);
    2072:	85ce                	mv	a1,s3
    2074:	00004517          	auipc	a0,0x4
    2078:	01c50513          	addi	a0,a0,28 # 6090 <malloc+0xde6>
    207c:	17a030ef          	jal	51f6 <printf>
    exit(1);
    2080:	4505                	li	a0,1
    2082:	52d020ef          	jal	4dae <exit>
  if (pid == 0)
    2086:	00091563          	bnez	s2,2090 <sbrkbasic+0x132>
    exit(0);
    208a:	4501                	li	a0,0
    208c:	523020ef          	jal	4dae <exit>
  wait(&xstatus);
    2090:	fcc40513          	addi	a0,s0,-52
    2094:	523020ef          	jal	4db6 <wait>
  exit(xstatus);
    2098:	fcc42503          	lw	a0,-52(s0)
    209c:	513020ef          	jal	4dae <exit>

00000000000020a0 <sbrkmuch>:
{
    20a0:	7179                	addi	sp,sp,-48
    20a2:	f406                	sd	ra,40(sp)
    20a4:	f022                	sd	s0,32(sp)
    20a6:	ec26                	sd	s1,24(sp)
    20a8:	e84a                	sd	s2,16(sp)
    20aa:	e44e                	sd	s3,8(sp)
    20ac:	e052                	sd	s4,0(sp)
    20ae:	1800                	addi	s0,sp,48
    20b0:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    20b2:	4501                	li	a0,0
    20b4:	4c7020ef          	jal	4d7a <sbrk>
    20b8:	892a                	mv	s2,a0
  a = sbrk(0);
    20ba:	4501                	li	a0,0
    20bc:	4bf020ef          	jal	4d7a <sbrk>
    20c0:	84aa                	mv	s1,a0
  p = sbrk(amt);
    20c2:	06400537          	lui	a0,0x6400
    20c6:	9d05                	subw	a0,a0,s1
    20c8:	4b3020ef          	jal	4d7a <sbrk>
  if (p != a) {
    20cc:	08a49763          	bne	s1,a0,215a <sbrkmuch+0xba>
  *lastaddr = 99;
    20d0:	064007b7          	lui	a5,0x6400
    20d4:	06300713          	li	a4,99
    20d8:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0347>
  a = sbrk(0);
    20dc:	4501                	li	a0,0
    20de:	49d020ef          	jal	4d7a <sbrk>
    20e2:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    20e4:	757d                	lui	a0,0xfffff
    20e6:	495020ef          	jal	4d7a <sbrk>
  if (c == (char *)SBRK_ERROR) {
    20ea:	57fd                	li	a5,-1
    20ec:	08f50163          	beq	a0,a5,216e <sbrkmuch+0xce>
  c = sbrk(0);
    20f0:	4501                	li	a0,0
    20f2:	489020ef          	jal	4d7a <sbrk>
  if (c != a - PGSIZE) {
    20f6:	77fd                	lui	a5,0xfffff
    20f8:	97a6                	add	a5,a5,s1
    20fa:	08f51463          	bne	a0,a5,2182 <sbrkmuch+0xe2>
  a = sbrk(0);
    20fe:	4501                	li	a0,0
    2100:	47b020ef          	jal	4d7a <sbrk>
    2104:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2106:	6505                	lui	a0,0x1
    2108:	473020ef          	jal	4d7a <sbrk>
    210c:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE) {
    210e:	08a49663          	bne	s1,a0,219a <sbrkmuch+0xfa>
    2112:	4501                	li	a0,0
    2114:	467020ef          	jal	4d7a <sbrk>
    2118:	6785                	lui	a5,0x1
    211a:	97a6                	add	a5,a5,s1
    211c:	06f51f63          	bne	a0,a5,219a <sbrkmuch+0xfa>
  if (*lastaddr == 99) {
    2120:	064007b7          	lui	a5,0x6400
    2124:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0347>
    2128:	06300793          	li	a5,99
    212c:	08f70363          	beq	a4,a5,21b2 <sbrkmuch+0x112>
  a = sbrk(0);
    2130:	4501                	li	a0,0
    2132:	449020ef          	jal	4d7a <sbrk>
    2136:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2138:	4501                	li	a0,0
    213a:	441020ef          	jal	4d7a <sbrk>
    213e:	40a9053b          	subw	a0,s2,a0
    2142:	439020ef          	jal	4d7a <sbrk>
  if (c != a) {
    2146:	08a49063          	bne	s1,a0,21c6 <sbrkmuch+0x126>
}
    214a:	70a2                	ld	ra,40(sp)
    214c:	7402                	ld	s0,32(sp)
    214e:	64e2                	ld	s1,24(sp)
    2150:	6942                	ld	s2,16(sp)
    2152:	69a2                	ld	s3,8(sp)
    2154:	6a02                	ld	s4,0(sp)
    2156:	6145                	addi	sp,sp,48
    2158:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n",
    215a:	85ce                	mv	a1,s3
    215c:	00004517          	auipc	a0,0x4
    2160:	f7450513          	addi	a0,a0,-140 # 60d0 <malloc+0xe26>
    2164:	092030ef          	jal	51f6 <printf>
    exit(1);
    2168:	4505                	li	a0,1
    216a:	445020ef          	jal	4dae <exit>
    printf("%s: sbrk could not deallocate\n", s);
    216e:	85ce                	mv	a1,s3
    2170:	00004517          	auipc	a0,0x4
    2174:	fa850513          	addi	a0,a0,-88 # 6118 <malloc+0xe6e>
    2178:	07e030ef          	jal	51f6 <printf>
    exit(1);
    217c:	4505                	li	a0,1
    217e:	431020ef          	jal	4dae <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a,
    2182:	86aa                	mv	a3,a0
    2184:	8626                	mv	a2,s1
    2186:	85ce                	mv	a1,s3
    2188:	00004517          	auipc	a0,0x4
    218c:	fb050513          	addi	a0,a0,-80 # 6138 <malloc+0xe8e>
    2190:	066030ef          	jal	51f6 <printf>
    exit(1);
    2194:	4505                	li	a0,1
    2196:	419020ef          	jal	4dae <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    219a:	86d2                	mv	a3,s4
    219c:	8626                	mv	a2,s1
    219e:	85ce                	mv	a1,s3
    21a0:	00004517          	auipc	a0,0x4
    21a4:	fd850513          	addi	a0,a0,-40 # 6178 <malloc+0xece>
    21a8:	04e030ef          	jal	51f6 <printf>
    exit(1);
    21ac:	4505                	li	a0,1
    21ae:	401020ef          	jal	4dae <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    21b2:	85ce                	mv	a1,s3
    21b4:	00004517          	auipc	a0,0x4
    21b8:	ff450513          	addi	a0,a0,-12 # 61a8 <malloc+0xefe>
    21bc:	03a030ef          	jal	51f6 <printf>
    exit(1);
    21c0:	4505                	li	a0,1
    21c2:	3ed020ef          	jal	4dae <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    21c6:	86aa                	mv	a3,a0
    21c8:	8626                	mv	a2,s1
    21ca:	85ce                	mv	a1,s3
    21cc:	00004517          	auipc	a0,0x4
    21d0:	01450513          	addi	a0,a0,20 # 61e0 <malloc+0xf36>
    21d4:	022030ef          	jal	51f6 <printf>
    exit(1);
    21d8:	4505                	li	a0,1
    21da:	3d5020ef          	jal	4dae <exit>

00000000000021de <sbrkarg>:
{
    21de:	7179                	addi	sp,sp,-48
    21e0:	f406                	sd	ra,40(sp)
    21e2:	f022                	sd	s0,32(sp)
    21e4:	ec26                	sd	s1,24(sp)
    21e6:	e84a                	sd	s2,16(sp)
    21e8:	e44e                	sd	s3,8(sp)
    21ea:	1800                	addi	s0,sp,48
    21ec:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    21ee:	6505                	lui	a0,0x1
    21f0:	38b020ef          	jal	4d7a <sbrk>
    21f4:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    21f6:	20100593          	li	a1,513
    21fa:	00004517          	auipc	a0,0x4
    21fe:	00e50513          	addi	a0,a0,14 # 6208 <malloc+0xf5e>
    2202:	3ed020ef          	jal	4dee <open>
    2206:	84aa                	mv	s1,a0
  unlink("sbrk");
    2208:	00004517          	auipc	a0,0x4
    220c:	00050513          	mv	a0,a0
    2210:	3ef020ef          	jal	4dfe <unlink>
  if (fd < 0) {
    2214:	0204c963          	bltz	s1,2246 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2218:	6605                	lui	a2,0x1
    221a:	85ca                	mv	a1,s2
    221c:	8526                	mv	a0,s1
    221e:	3b1020ef          	jal	4dce <write>
    2222:	02054c63          	bltz	a0,225a <sbrkarg+0x7c>
  close(fd);
    2226:	8526                	mv	a0,s1
    2228:	3af020ef          	jal	4dd6 <close>
  a = sbrk(PGSIZE);
    222c:	6505                	lui	a0,0x1
    222e:	34d020ef          	jal	4d7a <sbrk>
  if (pipe((int *)a) != 0) {
    2232:	38d020ef          	jal	4dbe <pipe>
    2236:	ed05                	bnez	a0,226e <sbrkarg+0x90>
}
    2238:	70a2                	ld	ra,40(sp)
    223a:	7402                	ld	s0,32(sp)
    223c:	64e2                	ld	s1,24(sp)
    223e:	6942                	ld	s2,16(sp)
    2240:	69a2                	ld	s3,8(sp)
    2242:	6145                	addi	sp,sp,48
    2244:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2246:	85ce                	mv	a1,s3
    2248:	00004517          	auipc	a0,0x4
    224c:	fc850513          	addi	a0,a0,-56 # 6210 <malloc+0xf66>
    2250:	7a7020ef          	jal	51f6 <printf>
    exit(1);
    2254:	4505                	li	a0,1
    2256:	359020ef          	jal	4dae <exit>
    printf("%s: write sbrk failed\n", s);
    225a:	85ce                	mv	a1,s3
    225c:	00004517          	auipc	a0,0x4
    2260:	fcc50513          	addi	a0,a0,-52 # 6228 <malloc+0xf7e>
    2264:	793020ef          	jal	51f6 <printf>
    exit(1);
    2268:	4505                	li	a0,1
    226a:	345020ef          	jal	4dae <exit>
    printf("%s: pipe() failed\n", s);
    226e:	85ce                	mv	a1,s3
    2270:	00004517          	auipc	a0,0x4
    2274:	a9050513          	addi	a0,a0,-1392 # 5d00 <malloc+0xa56>
    2278:	77f020ef          	jal	51f6 <printf>
    exit(1);
    227c:	4505                	li	a0,1
    227e:	331020ef          	jal	4dae <exit>

0000000000002282 <argptest>:
{
    2282:	1101                	addi	sp,sp,-32
    2284:	ec06                	sd	ra,24(sp)
    2286:	e822                	sd	s0,16(sp)
    2288:	e426                	sd	s1,8(sp)
    228a:	e04a                	sd	s2,0(sp)
    228c:	1000                	addi	s0,sp,32
    228e:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2290:	4581                	li	a1,0
    2292:	00004517          	auipc	a0,0x4
    2296:	fae50513          	addi	a0,a0,-82 # 6240 <malloc+0xf96>
    229a:	355020ef          	jal	4dee <open>
  if (fd < 0) {
    229e:	02054563          	bltz	a0,22c8 <argptest+0x46>
    22a2:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    22a4:	4501                	li	a0,0
    22a6:	2d5020ef          	jal	4d7a <sbrk>
    22aa:	567d                	li	a2,-1
    22ac:	fff50593          	addi	a1,a0,-1
    22b0:	8526                	mv	a0,s1
    22b2:	315020ef          	jal	4dc6 <read>
  close(fd);
    22b6:	8526                	mv	a0,s1
    22b8:	31f020ef          	jal	4dd6 <close>
}
    22bc:	60e2                	ld	ra,24(sp)
    22be:	6442                	ld	s0,16(sp)
    22c0:	64a2                	ld	s1,8(sp)
    22c2:	6902                	ld	s2,0(sp)
    22c4:	6105                	addi	sp,sp,32
    22c6:	8082                	ret
    printf("%s: open failed\n", s);
    22c8:	85ca                	mv	a1,s2
    22ca:	00004517          	auipc	a0,0x4
    22ce:	9c650513          	addi	a0,a0,-1594 # 5c90 <malloc+0x9e6>
    22d2:	725020ef          	jal	51f6 <printf>
    exit(1);
    22d6:	4505                	li	a0,1
    22d8:	2d7020ef          	jal	4dae <exit>

00000000000022dc <sbrkbugs>:
{
    22dc:	1141                	addi	sp,sp,-16
    22de:	e406                	sd	ra,8(sp)
    22e0:	e022                	sd	s0,0(sp)
    22e2:	0800                	addi	s0,sp,16
  int pid = fork();
    22e4:	2c3020ef          	jal	4da6 <fork>
  if (pid < 0) {
    22e8:	00054c63          	bltz	a0,2300 <sbrkbugs+0x24>
  if (pid == 0) {
    22ec:	e11d                	bnez	a0,2312 <sbrkbugs+0x36>
    int sz = (uint64)sbrk(0);
    22ee:	28d020ef          	jal	4d7a <sbrk>
    sbrk(-sz);
    22f2:	40a0053b          	negw	a0,a0
    22f6:	285020ef          	jal	4d7a <sbrk>
    exit(0);
    22fa:	4501                	li	a0,0
    22fc:	2b3020ef          	jal	4dae <exit>
    printf("fork failed\n");
    2300:	00005517          	auipc	a0,0x5
    2304:	f5050513          	addi	a0,a0,-176 # 7250 <malloc+0x1fa6>
    2308:	6ef020ef          	jal	51f6 <printf>
    exit(1);
    230c:	4505                	li	a0,1
    230e:	2a1020ef          	jal	4dae <exit>
  wait(0);
    2312:	4501                	li	a0,0
    2314:	2a3020ef          	jal	4db6 <wait>
  pid = fork();
    2318:	28f020ef          	jal	4da6 <fork>
  if (pid < 0) {
    231c:	00054f63          	bltz	a0,233a <sbrkbugs+0x5e>
  if (pid == 0) {
    2320:	e515                	bnez	a0,234c <sbrkbugs+0x70>
    int sz = (uint64)sbrk(0);
    2322:	259020ef          	jal	4d7a <sbrk>
    sbrk(-(sz - 3500));
    2326:	6785                	lui	a5,0x1
    2328:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x138>
    232c:	40a7853b          	subw	a0,a5,a0
    2330:	24b020ef          	jal	4d7a <sbrk>
    exit(0);
    2334:	4501                	li	a0,0
    2336:	279020ef          	jal	4dae <exit>
    printf("fork failed\n");
    233a:	00005517          	auipc	a0,0x5
    233e:	f1650513          	addi	a0,a0,-234 # 7250 <malloc+0x1fa6>
    2342:	6b5020ef          	jal	51f6 <printf>
    exit(1);
    2346:	4505                	li	a0,1
    2348:	267020ef          	jal	4dae <exit>
  wait(0);
    234c:	4501                	li	a0,0
    234e:	269020ef          	jal	4db6 <wait>
  pid = fork();
    2352:	255020ef          	jal	4da6 <fork>
  if (pid < 0) {
    2356:	02054263          	bltz	a0,237a <sbrkbugs+0x9e>
  if (pid == 0) {
    235a:	e90d                	bnez	a0,238c <sbrkbugs+0xb0>
    sbrk((10 * PGSIZE + 2048) - (uint64)sbrk(0));
    235c:	21f020ef          	jal	4d7a <sbrk>
    2360:	67ad                	lui	a5,0xb
    2362:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x258>
    2366:	40a7853b          	subw	a0,a5,a0
    236a:	211020ef          	jal	4d7a <sbrk>
    sbrk(-10);
    236e:	5559                	li	a0,-10
    2370:	20b020ef          	jal	4d7a <sbrk>
    exit(0);
    2374:	4501                	li	a0,0
    2376:	239020ef          	jal	4dae <exit>
    printf("fork failed\n");
    237a:	00005517          	auipc	a0,0x5
    237e:	ed650513          	addi	a0,a0,-298 # 7250 <malloc+0x1fa6>
    2382:	675020ef          	jal	51f6 <printf>
    exit(1);
    2386:	4505                	li	a0,1
    2388:	227020ef          	jal	4dae <exit>
  wait(0);
    238c:	4501                	li	a0,0
    238e:	229020ef          	jal	4db6 <wait>
  exit(0);
    2392:	4501                	li	a0,0
    2394:	21b020ef          	jal	4dae <exit>

0000000000002398 <sbrklast>:
{
    2398:	7179                	addi	sp,sp,-48
    239a:	f406                	sd	ra,40(sp)
    239c:	f022                	sd	s0,32(sp)
    239e:	ec26                	sd	s1,24(sp)
    23a0:	e84a                	sd	s2,16(sp)
    23a2:	e44e                	sd	s3,8(sp)
    23a4:	e052                	sd	s4,0(sp)
    23a6:	1800                	addi	s0,sp,48
  uint64 top = (uint64)sbrk(0);
    23a8:	4501                	li	a0,0
    23aa:	1d1020ef          	jal	4d7a <sbrk>
  if ((top % PGSIZE) != 0)
    23ae:	03451793          	slli	a5,a0,0x34
    23b2:	ebad                	bnez	a5,2424 <sbrklast+0x8c>
  sbrk(PGSIZE);
    23b4:	6505                	lui	a0,0x1
    23b6:	1c5020ef          	jal	4d7a <sbrk>
  sbrk(10);
    23ba:	4529                	li	a0,10
    23bc:	1bf020ef          	jal	4d7a <sbrk>
  sbrk(-20);
    23c0:	5531                	li	a0,-20
    23c2:	1b9020ef          	jal	4d7a <sbrk>
  top = (uint64)sbrk(0);
    23c6:	4501                	li	a0,0
    23c8:	1b3020ef          	jal	4d7a <sbrk>
    23cc:	84aa                	mv	s1,a0
  char *p = (char *)(top - 64);
    23ce:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x122>
  p[0] = 'x';
    23d2:	07800a13          	li	s4,120
    23d6:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    23da:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR | O_CREATE);
    23de:	20200593          	li	a1,514
    23e2:	854a                	mv	a0,s2
    23e4:	20b020ef          	jal	4dee <open>
    23e8:	89aa                	mv	s3,a0
  write(fd, p, 1);
    23ea:	4605                	li	a2,1
    23ec:	85ca                	mv	a1,s2
    23ee:	1e1020ef          	jal	4dce <write>
  close(fd);
    23f2:	854e                	mv	a0,s3
    23f4:	1e3020ef          	jal	4dd6 <close>
  fd = open(p, O_RDWR);
    23f8:	4589                	li	a1,2
    23fa:	854a                	mv	a0,s2
    23fc:	1f3020ef          	jal	4dee <open>
  p[0] = '\0';
    2400:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2404:	4605                	li	a2,1
    2406:	85ca                	mv	a1,s2
    2408:	1bf020ef          	jal	4dc6 <read>
  if (p[0] != 'x')
    240c:	fc04c783          	lbu	a5,-64(s1)
    2410:	03479263          	bne	a5,s4,2434 <sbrklast+0x9c>
}
    2414:	70a2                	ld	ra,40(sp)
    2416:	7402                	ld	s0,32(sp)
    2418:	64e2                	ld	s1,24(sp)
    241a:	6942                	ld	s2,16(sp)
    241c:	69a2                	ld	s3,8(sp)
    241e:	6a02                	ld	s4,0(sp)
    2420:	6145                	addi	sp,sp,48
    2422:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2424:	0347d513          	srli	a0,a5,0x34
    2428:	6785                	lui	a5,0x1
    242a:	40a7853b          	subw	a0,a5,a0
    242e:	14d020ef          	jal	4d7a <sbrk>
    2432:	b749                	j	23b4 <sbrklast+0x1c>
    exit(1);
    2434:	4505                	li	a0,1
    2436:	179020ef          	jal	4dae <exit>

000000000000243a <sbrk8000>:
{
    243a:	1141                	addi	sp,sp,-16
    243c:	e406                	sd	ra,8(sp)
    243e:	e022                	sd	s0,0(sp)
    2440:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2442:	80000537          	lui	a0,0x80000
    2446:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff034c>
    2448:	133020ef          	jal	4d7a <sbrk>
  volatile char *top = sbrk(0);
    244c:	4501                	li	a0,0
    244e:	12d020ef          	jal	4d7a <sbrk>
  *(top - 1) = *(top - 1) + 1;
    2452:	fff54783          	lbu	a5,-1(a0)
    2456:	2785                	addiw	a5,a5,1 # 1001 <badarg+0x1>
    2458:	0ff7f793          	zext.b	a5,a5
    245c:	fef50fa3          	sb	a5,-1(a0)
}
    2460:	60a2                	ld	ra,8(sp)
    2462:	6402                	ld	s0,0(sp)
    2464:	0141                	addi	sp,sp,16
    2466:	8082                	ret

0000000000002468 <execout>:
{
    2468:	715d                	addi	sp,sp,-80
    246a:	e486                	sd	ra,72(sp)
    246c:	e0a2                	sd	s0,64(sp)
    246e:	fc26                	sd	s1,56(sp)
    2470:	f84a                	sd	s2,48(sp)
    2472:	f44e                	sd	s3,40(sp)
    2474:	f052                	sd	s4,32(sp)
    2476:	0880                	addi	s0,sp,80
  for (int avail = 0; avail < 15; avail++) {
    2478:	4901                	li	s2,0
    247a:	49bd                	li	s3,15
    int pid = fork();
    247c:	12b020ef          	jal	4da6 <fork>
    2480:	84aa                	mv	s1,a0
    if (pid < 0) {
    2482:	00054c63          	bltz	a0,249a <execout+0x32>
    } else if (pid == 0) {
    2486:	c11d                	beqz	a0,24ac <execout+0x44>
      wait((int *)0);
    2488:	4501                	li	a0,0
    248a:	12d020ef          	jal	4db6 <wait>
  for (int avail = 0; avail < 15; avail++) {
    248e:	2905                	addiw	s2,s2,1
    2490:	ff3916e3          	bne	s2,s3,247c <execout+0x14>
  exit(0);
    2494:	4501                	li	a0,0
    2496:	119020ef          	jal	4dae <exit>
      printf("fork failed\n");
    249a:	00005517          	auipc	a0,0x5
    249e:	db650513          	addi	a0,a0,-586 # 7250 <malloc+0x1fa6>
    24a2:	555020ef          	jal	51f6 <printf>
      exit(1);
    24a6:	4505                	li	a0,1
    24a8:	107020ef          	jal	4dae <exit>
        if (a == SBRK_ERROR)
    24ac:	59fd                	li	s3,-1
        *(a + PGSIZE - 1) = 1;
    24ae:	4a05                	li	s4,1
        char *a = sbrk(PGSIZE);
    24b0:	6505                	lui	a0,0x1
    24b2:	0c9020ef          	jal	4d7a <sbrk>
        if (a == SBRK_ERROR)
    24b6:	01350763          	beq	a0,s3,24c4 <execout+0x5c>
        *(a + PGSIZE - 1) = 1;
    24ba:	6785                	lui	a5,0x1
    24bc:	953e                	add	a0,a0,a5
    24be:	ff450fa3          	sb	s4,-1(a0) # fff <pgbug+0x2b>
      while (1) {
    24c2:	b7fd                	j	24b0 <execout+0x48>
      for (int i = 0; i < avail; i++)
    24c4:	01205863          	blez	s2,24d4 <execout+0x6c>
        sbrk(-PGSIZE);
    24c8:	757d                	lui	a0,0xfffff
    24ca:	0b1020ef          	jal	4d7a <sbrk>
      for (int i = 0; i < avail; i++)
    24ce:	2485                	addiw	s1,s1,1
    24d0:	ff249ce3          	bne	s1,s2,24c8 <execout+0x60>
      close(1);
    24d4:	4505                	li	a0,1
    24d6:	101020ef          	jal	4dd6 <close>
      char *args[] = {"echo", "x", 0};
    24da:	00003517          	auipc	a0,0x3
    24de:	f0e50513          	addi	a0,a0,-242 # 53e8 <malloc+0x13e>
    24e2:	faa43c23          	sd	a0,-72(s0)
    24e6:	00003797          	auipc	a5,0x3
    24ea:	f7278793          	addi	a5,a5,-142 # 5458 <malloc+0x1ae>
    24ee:	fcf43023          	sd	a5,-64(s0)
    24f2:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    24f6:	fb840593          	addi	a1,s0,-72
    24fa:	0ed020ef          	jal	4de6 <exec>
      exit(0);
    24fe:	4501                	li	a0,0
    2500:	0af020ef          	jal	4dae <exit>

0000000000002504 <fourteen>:
{
    2504:	1101                	addi	sp,sp,-32
    2506:	ec06                	sd	ra,24(sp)
    2508:	e822                	sd	s0,16(sp)
    250a:	e426                	sd	s1,8(sp)
    250c:	1000                	addi	s0,sp,32
    250e:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0) {
    2510:	00004517          	auipc	a0,0x4
    2514:	f0850513          	addi	a0,a0,-248 # 6418 <malloc+0x116e>
    2518:	0ff020ef          	jal	4e16 <mkdir>
    251c:	e555                	bnez	a0,25c8 <fourteen+0xc4>
  if (mkdir("12345678901234/123456789012345") != 0) {
    251e:	00004517          	auipc	a0,0x4
    2522:	d5250513          	addi	a0,a0,-686 # 6270 <malloc+0xfc6>
    2526:	0f1020ef          	jal	4e16 <mkdir>
    252a:	e94d                	bnez	a0,25dc <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    252c:	20000593          	li	a1,512
    2530:	00004517          	auipc	a0,0x4
    2534:	d9850513          	addi	a0,a0,-616 # 62c8 <malloc+0x101e>
    2538:	0b7020ef          	jal	4dee <open>
  if (fd < 0) {
    253c:	0a054a63          	bltz	a0,25f0 <fourteen+0xec>
  close(fd);
    2540:	097020ef          	jal	4dd6 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2544:	4581                	li	a1,0
    2546:	00004517          	auipc	a0,0x4
    254a:	dfa50513          	addi	a0,a0,-518 # 6340 <malloc+0x1096>
    254e:	0a1020ef          	jal	4dee <open>
  if (fd < 0) {
    2552:	0a054963          	bltz	a0,2604 <fourteen+0x100>
  close(fd);
    2556:	081020ef          	jal	4dd6 <close>
  if (mkdir("12345678901234/12345678901234") == 0) {
    255a:	00004517          	auipc	a0,0x4
    255e:	e5650513          	addi	a0,a0,-426 # 63b0 <malloc+0x1106>
    2562:	0b5020ef          	jal	4e16 <mkdir>
    2566:	c94d                	beqz	a0,2618 <fourteen+0x114>
  if (mkdir("123456789012345/12345678901234") == 0) {
    2568:	00004517          	auipc	a0,0x4
    256c:	ea050513          	addi	a0,a0,-352 # 6408 <malloc+0x115e>
    2570:	0a7020ef          	jal	4e16 <mkdir>
    2574:	cd45                	beqz	a0,262c <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    2576:	00004517          	auipc	a0,0x4
    257a:	e9250513          	addi	a0,a0,-366 # 6408 <malloc+0x115e>
    257e:	081020ef          	jal	4dfe <unlink>
  unlink("12345678901234/12345678901234");
    2582:	00004517          	auipc	a0,0x4
    2586:	e2e50513          	addi	a0,a0,-466 # 63b0 <malloc+0x1106>
    258a:	075020ef          	jal	4dfe <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    258e:	00004517          	auipc	a0,0x4
    2592:	db250513          	addi	a0,a0,-590 # 6340 <malloc+0x1096>
    2596:	069020ef          	jal	4dfe <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    259a:	00004517          	auipc	a0,0x4
    259e:	d2e50513          	addi	a0,a0,-722 # 62c8 <malloc+0x101e>
    25a2:	05d020ef          	jal	4dfe <unlink>
  unlink("12345678901234/123456789012345");
    25a6:	00004517          	auipc	a0,0x4
    25aa:	cca50513          	addi	a0,a0,-822 # 6270 <malloc+0xfc6>
    25ae:	051020ef          	jal	4dfe <unlink>
  unlink("12345678901234");
    25b2:	00004517          	auipc	a0,0x4
    25b6:	e6650513          	addi	a0,a0,-410 # 6418 <malloc+0x116e>
    25ba:	045020ef          	jal	4dfe <unlink>
}
    25be:	60e2                	ld	ra,24(sp)
    25c0:	6442                	ld	s0,16(sp)
    25c2:	64a2                	ld	s1,8(sp)
    25c4:	6105                	addi	sp,sp,32
    25c6:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    25c8:	85a6                	mv	a1,s1
    25ca:	00004517          	auipc	a0,0x4
    25ce:	c7e50513          	addi	a0,a0,-898 # 6248 <malloc+0xf9e>
    25d2:	425020ef          	jal	51f6 <printf>
    exit(1);
    25d6:	4505                	li	a0,1
    25d8:	7d6020ef          	jal	4dae <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    25dc:	85a6                	mv	a1,s1
    25de:	00004517          	auipc	a0,0x4
    25e2:	cb250513          	addi	a0,a0,-846 # 6290 <malloc+0xfe6>
    25e6:	411020ef          	jal	51f6 <printf>
    exit(1);
    25ea:	4505                	li	a0,1
    25ec:	7c2020ef          	jal	4dae <exit>
    printf(
    25f0:	85a6                	mv	a1,s1
    25f2:	00004517          	auipc	a0,0x4
    25f6:	d0650513          	addi	a0,a0,-762 # 62f8 <malloc+0x104e>
    25fa:	3fd020ef          	jal	51f6 <printf>
    exit(1);
    25fe:	4505                	li	a0,1
    2600:	7ae020ef          	jal	4dae <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2604:	85a6                	mv	a1,s1
    2606:	00004517          	auipc	a0,0x4
    260a:	d6a50513          	addi	a0,a0,-662 # 6370 <malloc+0x10c6>
    260e:	3e9020ef          	jal	51f6 <printf>
    exit(1);
    2612:	4505                	li	a0,1
    2614:	79a020ef          	jal	4dae <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2618:	85a6                	mv	a1,s1
    261a:	00004517          	auipc	a0,0x4
    261e:	db650513          	addi	a0,a0,-586 # 63d0 <malloc+0x1126>
    2622:	3d5020ef          	jal	51f6 <printf>
    exit(1);
    2626:	4505                	li	a0,1
    2628:	786020ef          	jal	4dae <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    262c:	85a6                	mv	a1,s1
    262e:	00004517          	auipc	a0,0x4
    2632:	dfa50513          	addi	a0,a0,-518 # 6428 <malloc+0x117e>
    2636:	3c1020ef          	jal	51f6 <printf>
    exit(1);
    263a:	4505                	li	a0,1
    263c:	772020ef          	jal	4dae <exit>

0000000000002640 <diskfull>:
{
    2640:	b8010113          	addi	sp,sp,-1152
    2644:	46113c23          	sd	ra,1144(sp)
    2648:	46813823          	sd	s0,1136(sp)
    264c:	46913423          	sd	s1,1128(sp)
    2650:	47213023          	sd	s2,1120(sp)
    2654:	45313c23          	sd	s3,1112(sp)
    2658:	45413823          	sd	s4,1104(sp)
    265c:	45513423          	sd	s5,1096(sp)
    2660:	45613023          	sd	s6,1088(sp)
    2664:	43713c23          	sd	s7,1080(sp)
    2668:	43813823          	sd	s8,1072(sp)
    266c:	43913423          	sd	s9,1064(sp)
    2670:	48010413          	addi	s0,sp,1152
    2674:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    2676:	00004517          	auipc	a0,0x4
    267a:	dea50513          	addi	a0,a0,-534 # 6460 <malloc+0x11b6>
    267e:	780020ef          	jal	4dfe <unlink>
    2682:	03000993          	li	s3,48
    name[0] = 'b';
    2686:	06200b13          	li	s6,98
    name[1] = 'i';
    268a:	06900a93          	li	s5,105
    name[2] = 'g';
    268e:	06700a13          	li	s4,103
    2692:	10c00b93          	li	s7,268
  for (fi = 0; done == 0 && '0' + fi < 0177; fi++) {
    2696:	07f00c13          	li	s8,127
    269a:	aab9                	j	27f8 <diskfull+0x1b8>
      printf("%s: could not create file %s\n", s, name);
    269c:	b8040613          	addi	a2,s0,-1152
    26a0:	85e6                	mv	a1,s9
    26a2:	00004517          	auipc	a0,0x4
    26a6:	dce50513          	addi	a0,a0,-562 # 6470 <malloc+0x11c6>
    26aa:	34d020ef          	jal	51f6 <printf>
      break;
    26ae:	a039                	j	26bc <diskfull+0x7c>
        close(fd);
    26b0:	854a                	mv	a0,s2
    26b2:	724020ef          	jal	4dd6 <close>
    close(fd);
    26b6:	854a                	mv	a0,s2
    26b8:	71e020ef          	jal	4dd6 <close>
  for (int i = 0; i < nzz; i++) {
    26bc:	4481                	li	s1,0
    name[0] = 'z';
    26be:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++) {
    26c2:	08000993          	li	s3,128
    name[0] = 'z';
    26c6:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    26ca:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    26ce:	41f4d71b          	sraiw	a4,s1,0x1f
    26d2:	01b7571b          	srliw	a4,a4,0x1b
    26d6:	009707bb          	addw	a5,a4,s1
    26da:	4057d69b          	sraiw	a3,a5,0x5
    26de:	0306869b          	addiw	a3,a3,48
    26e2:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    26e6:	8bfd                	andi	a5,a5,31
    26e8:	9f99                	subw	a5,a5,a4
    26ea:	0307879b          	addiw	a5,a5,48
    26ee:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    26f2:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    26f6:	ba040513          	addi	a0,s0,-1120
    26fa:	704020ef          	jal	4dfe <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    26fe:	60200593          	li	a1,1538
    2702:	ba040513          	addi	a0,s0,-1120
    2706:	6e8020ef          	jal	4dee <open>
    if (fd < 0)
    270a:	00054763          	bltz	a0,2718 <diskfull+0xd8>
    close(fd);
    270e:	6c8020ef          	jal	4dd6 <close>
  for (int i = 0; i < nzz; i++) {
    2712:	2485                	addiw	s1,s1,1
    2714:	fb3499e3          	bne	s1,s3,26c6 <diskfull+0x86>
  if (mkdir("diskfulldir") == 0)
    2718:	00004517          	auipc	a0,0x4
    271c:	d4850513          	addi	a0,a0,-696 # 6460 <malloc+0x11b6>
    2720:	6f6020ef          	jal	4e16 <mkdir>
    2724:	12050063          	beqz	a0,2844 <diskfull+0x204>
  unlink("diskfulldir");
    2728:	00004517          	auipc	a0,0x4
    272c:	d3850513          	addi	a0,a0,-712 # 6460 <malloc+0x11b6>
    2730:	6ce020ef          	jal	4dfe <unlink>
  for (int i = 0; i < nzz; i++) {
    2734:	4481                	li	s1,0
    name[0] = 'z';
    2736:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++) {
    273a:	08000993          	li	s3,128
    name[0] = 'z';
    273e:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    2742:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    2746:	41f4d71b          	sraiw	a4,s1,0x1f
    274a:	01b7571b          	srliw	a4,a4,0x1b
    274e:	009707bb          	addw	a5,a4,s1
    2752:	4057d69b          	sraiw	a3,a5,0x5
    2756:	0306869b          	addiw	a3,a3,48
    275a:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    275e:	8bfd                	andi	a5,a5,31
    2760:	9f99                	subw	a5,a5,a4
    2762:	0307879b          	addiw	a5,a5,48
    2766:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    276a:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    276e:	ba040513          	addi	a0,s0,-1120
    2772:	68c020ef          	jal	4dfe <unlink>
  for (int i = 0; i < nzz; i++) {
    2776:	2485                	addiw	s1,s1,1
    2778:	fd3493e3          	bne	s1,s3,273e <diskfull+0xfe>
    277c:	03000493          	li	s1,48
    name[0] = 'b';
    2780:	06200a93          	li	s5,98
    name[1] = 'i';
    2784:	06900a13          	li	s4,105
    name[2] = 'g';
    2788:	06700993          	li	s3,103
  for (int i = 0; '0' + i < 0177; i++) {
    278c:	07f00913          	li	s2,127
    name[0] = 'b';
    2790:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    2794:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    2798:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    279c:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    27a0:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    27a4:	ba040513          	addi	a0,s0,-1120
    27a8:	656020ef          	jal	4dfe <unlink>
  for (int i = 0; '0' + i < 0177; i++) {
    27ac:	2485                	addiw	s1,s1,1
    27ae:	0ff4f493          	zext.b	s1,s1
    27b2:	fd249fe3          	bne	s1,s2,2790 <diskfull+0x150>
}
    27b6:	47813083          	ld	ra,1144(sp)
    27ba:	47013403          	ld	s0,1136(sp)
    27be:	46813483          	ld	s1,1128(sp)
    27c2:	46013903          	ld	s2,1120(sp)
    27c6:	45813983          	ld	s3,1112(sp)
    27ca:	45013a03          	ld	s4,1104(sp)
    27ce:	44813a83          	ld	s5,1096(sp)
    27d2:	44013b03          	ld	s6,1088(sp)
    27d6:	43813b83          	ld	s7,1080(sp)
    27da:	43013c03          	ld	s8,1072(sp)
    27de:	42813c83          	ld	s9,1064(sp)
    27e2:	48010113          	addi	sp,sp,1152
    27e6:	8082                	ret
    close(fd);
    27e8:	854a                	mv	a0,s2
    27ea:	5ec020ef          	jal	4dd6 <close>
  for (fi = 0; done == 0 && '0' + fi < 0177; fi++) {
    27ee:	2985                	addiw	s3,s3,1
    27f0:	0ff9f993          	zext.b	s3,s3
    27f4:	ed8984e3          	beq	s3,s8,26bc <diskfull+0x7c>
    name[0] = 'b';
    27f8:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    27fc:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    2800:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    2804:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    2808:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    280c:	b8040513          	addi	a0,s0,-1152
    2810:	5ee020ef          	jal	4dfe <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    2814:	60200593          	li	a1,1538
    2818:	b8040513          	addi	a0,s0,-1152
    281c:	5d2020ef          	jal	4dee <open>
    2820:	892a                	mv	s2,a0
    if (fd < 0) {
    2822:	e6054de3          	bltz	a0,269c <diskfull+0x5c>
    2826:	84de                	mv	s1,s7
      if (write(fd, buf, BSIZE) != BSIZE) {
    2828:	40000613          	li	a2,1024
    282c:	ba040593          	addi	a1,s0,-1120
    2830:	854a                	mv	a0,s2
    2832:	59c020ef          	jal	4dce <write>
    2836:	40000793          	li	a5,1024
    283a:	e6f51be3          	bne	a0,a5,26b0 <diskfull+0x70>
    for (int i = 0; i < MAXFILE; i++) {
    283e:	34fd                	addiw	s1,s1,-1
    2840:	f4e5                	bnez	s1,2828 <diskfull+0x1e8>
    2842:	b75d                	j	27e8 <diskfull+0x1a8>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2844:	85e6                	mv	a1,s9
    2846:	00004517          	auipc	a0,0x4
    284a:	c4a50513          	addi	a0,a0,-950 # 6490 <malloc+0x11e6>
    284e:	1a9020ef          	jal	51f6 <printf>
    2852:	bdd9                	j	2728 <diskfull+0xe8>

0000000000002854 <iputtest>:
{
    2854:	1101                	addi	sp,sp,-32
    2856:	ec06                	sd	ra,24(sp)
    2858:	e822                	sd	s0,16(sp)
    285a:	e426                	sd	s1,8(sp)
    285c:	1000                	addi	s0,sp,32
    285e:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0) {
    2860:	00004517          	auipc	a0,0x4
    2864:	c6050513          	addi	a0,a0,-928 # 64c0 <malloc+0x1216>
    2868:	5ae020ef          	jal	4e16 <mkdir>
    286c:	02054f63          	bltz	a0,28aa <iputtest+0x56>
  if (chdir("iputdir") < 0) {
    2870:	00004517          	auipc	a0,0x4
    2874:	c5050513          	addi	a0,a0,-944 # 64c0 <malloc+0x1216>
    2878:	5a6020ef          	jal	4e1e <chdir>
    287c:	04054163          	bltz	a0,28be <iputtest+0x6a>
  if (unlink("../iputdir") < 0) {
    2880:	00004517          	auipc	a0,0x4
    2884:	c8050513          	addi	a0,a0,-896 # 6500 <malloc+0x1256>
    2888:	576020ef          	jal	4dfe <unlink>
    288c:	04054363          	bltz	a0,28d2 <iputtest+0x7e>
  if (chdir("/") < 0) {
    2890:	00004517          	auipc	a0,0x4
    2894:	ca050513          	addi	a0,a0,-864 # 6530 <malloc+0x1286>
    2898:	586020ef          	jal	4e1e <chdir>
    289c:	04054563          	bltz	a0,28e6 <iputtest+0x92>
}
    28a0:	60e2                	ld	ra,24(sp)
    28a2:	6442                	ld	s0,16(sp)
    28a4:	64a2                	ld	s1,8(sp)
    28a6:	6105                	addi	sp,sp,32
    28a8:	8082                	ret
    printf("%s: mkdir failed\n", s);
    28aa:	85a6                	mv	a1,s1
    28ac:	00004517          	auipc	a0,0x4
    28b0:	c1c50513          	addi	a0,a0,-996 # 64c8 <malloc+0x121e>
    28b4:	143020ef          	jal	51f6 <printf>
    exit(1);
    28b8:	4505                	li	a0,1
    28ba:	4f4020ef          	jal	4dae <exit>
    printf("%s: chdir iputdir failed\n", s);
    28be:	85a6                	mv	a1,s1
    28c0:	00004517          	auipc	a0,0x4
    28c4:	c2050513          	addi	a0,a0,-992 # 64e0 <malloc+0x1236>
    28c8:	12f020ef          	jal	51f6 <printf>
    exit(1);
    28cc:	4505                	li	a0,1
    28ce:	4e0020ef          	jal	4dae <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    28d2:	85a6                	mv	a1,s1
    28d4:	00004517          	auipc	a0,0x4
    28d8:	c3c50513          	addi	a0,a0,-964 # 6510 <malloc+0x1266>
    28dc:	11b020ef          	jal	51f6 <printf>
    exit(1);
    28e0:	4505                	li	a0,1
    28e2:	4cc020ef          	jal	4dae <exit>
    printf("%s: chdir / failed\n", s);
    28e6:	85a6                	mv	a1,s1
    28e8:	00004517          	auipc	a0,0x4
    28ec:	c5050513          	addi	a0,a0,-944 # 6538 <malloc+0x128e>
    28f0:	107020ef          	jal	51f6 <printf>
    exit(1);
    28f4:	4505                	li	a0,1
    28f6:	4b8020ef          	jal	4dae <exit>

00000000000028fa <exitiputtest>:
{
    28fa:	7179                	addi	sp,sp,-48
    28fc:	f406                	sd	ra,40(sp)
    28fe:	f022                	sd	s0,32(sp)
    2900:	ec26                	sd	s1,24(sp)
    2902:	1800                	addi	s0,sp,48
    2904:	84aa                	mv	s1,a0
  pid = fork();
    2906:	4a0020ef          	jal	4da6 <fork>
  if (pid < 0) {
    290a:	02054e63          	bltz	a0,2946 <exitiputtest+0x4c>
  if (pid == 0) {
    290e:	e541                	bnez	a0,2996 <exitiputtest+0x9c>
    if (mkdir("iputdir") < 0) {
    2910:	00004517          	auipc	a0,0x4
    2914:	bb050513          	addi	a0,a0,-1104 # 64c0 <malloc+0x1216>
    2918:	4fe020ef          	jal	4e16 <mkdir>
    291c:	02054f63          	bltz	a0,295a <exitiputtest+0x60>
    if (chdir("iputdir") < 0) {
    2920:	00004517          	auipc	a0,0x4
    2924:	ba050513          	addi	a0,a0,-1120 # 64c0 <malloc+0x1216>
    2928:	4f6020ef          	jal	4e1e <chdir>
    292c:	04054163          	bltz	a0,296e <exitiputtest+0x74>
    if (unlink("../iputdir") < 0) {
    2930:	00004517          	auipc	a0,0x4
    2934:	bd050513          	addi	a0,a0,-1072 # 6500 <malloc+0x1256>
    2938:	4c6020ef          	jal	4dfe <unlink>
    293c:	04054363          	bltz	a0,2982 <exitiputtest+0x88>
    exit(0);
    2940:	4501                	li	a0,0
    2942:	46c020ef          	jal	4dae <exit>
    printf("%s: fork failed\n", s);
    2946:	85a6                	mv	a1,s1
    2948:	00003517          	auipc	a0,0x3
    294c:	33050513          	addi	a0,a0,816 # 5c78 <malloc+0x9ce>
    2950:	0a7020ef          	jal	51f6 <printf>
    exit(1);
    2954:	4505                	li	a0,1
    2956:	458020ef          	jal	4dae <exit>
      printf("%s: mkdir failed\n", s);
    295a:	85a6                	mv	a1,s1
    295c:	00004517          	auipc	a0,0x4
    2960:	b6c50513          	addi	a0,a0,-1172 # 64c8 <malloc+0x121e>
    2964:	093020ef          	jal	51f6 <printf>
      exit(1);
    2968:	4505                	li	a0,1
    296a:	444020ef          	jal	4dae <exit>
      printf("%s: child chdir failed\n", s);
    296e:	85a6                	mv	a1,s1
    2970:	00004517          	auipc	a0,0x4
    2974:	be050513          	addi	a0,a0,-1056 # 6550 <malloc+0x12a6>
    2978:	07f020ef          	jal	51f6 <printf>
      exit(1);
    297c:	4505                	li	a0,1
    297e:	430020ef          	jal	4dae <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2982:	85a6                	mv	a1,s1
    2984:	00004517          	auipc	a0,0x4
    2988:	b8c50513          	addi	a0,a0,-1140 # 6510 <malloc+0x1266>
    298c:	06b020ef          	jal	51f6 <printf>
      exit(1);
    2990:	4505                	li	a0,1
    2992:	41c020ef          	jal	4dae <exit>
  wait(&xstatus);
    2996:	fdc40513          	addi	a0,s0,-36
    299a:	41c020ef          	jal	4db6 <wait>
  exit(xstatus);
    299e:	fdc42503          	lw	a0,-36(s0)
    29a2:	40c020ef          	jal	4dae <exit>

00000000000029a6 <dirtest>:
{
    29a6:	1101                	addi	sp,sp,-32
    29a8:	ec06                	sd	ra,24(sp)
    29aa:	e822                	sd	s0,16(sp)
    29ac:	e426                	sd	s1,8(sp)
    29ae:	1000                	addi	s0,sp,32
    29b0:	84aa                	mv	s1,a0
  if (mkdir("dir0") < 0) {
    29b2:	00004517          	auipc	a0,0x4
    29b6:	bb650513          	addi	a0,a0,-1098 # 6568 <malloc+0x12be>
    29ba:	45c020ef          	jal	4e16 <mkdir>
    29be:	02054f63          	bltz	a0,29fc <dirtest+0x56>
  if (chdir("dir0") < 0) {
    29c2:	00004517          	auipc	a0,0x4
    29c6:	ba650513          	addi	a0,a0,-1114 # 6568 <malloc+0x12be>
    29ca:	454020ef          	jal	4e1e <chdir>
    29ce:	04054163          	bltz	a0,2a10 <dirtest+0x6a>
  if (chdir("..") < 0) {
    29d2:	00004517          	auipc	a0,0x4
    29d6:	bb650513          	addi	a0,a0,-1098 # 6588 <malloc+0x12de>
    29da:	444020ef          	jal	4e1e <chdir>
    29de:	04054363          	bltz	a0,2a24 <dirtest+0x7e>
  if (unlink("dir0") < 0) {
    29e2:	00004517          	auipc	a0,0x4
    29e6:	b8650513          	addi	a0,a0,-1146 # 6568 <malloc+0x12be>
    29ea:	414020ef          	jal	4dfe <unlink>
    29ee:	04054563          	bltz	a0,2a38 <dirtest+0x92>
}
    29f2:	60e2                	ld	ra,24(sp)
    29f4:	6442                	ld	s0,16(sp)
    29f6:	64a2                	ld	s1,8(sp)
    29f8:	6105                	addi	sp,sp,32
    29fa:	8082                	ret
    printf("%s: mkdir failed\n", s);
    29fc:	85a6                	mv	a1,s1
    29fe:	00004517          	auipc	a0,0x4
    2a02:	aca50513          	addi	a0,a0,-1334 # 64c8 <malloc+0x121e>
    2a06:	7f0020ef          	jal	51f6 <printf>
    exit(1);
    2a0a:	4505                	li	a0,1
    2a0c:	3a2020ef          	jal	4dae <exit>
    printf("%s: chdir dir0 failed\n", s);
    2a10:	85a6                	mv	a1,s1
    2a12:	00004517          	auipc	a0,0x4
    2a16:	b5e50513          	addi	a0,a0,-1186 # 6570 <malloc+0x12c6>
    2a1a:	7dc020ef          	jal	51f6 <printf>
    exit(1);
    2a1e:	4505                	li	a0,1
    2a20:	38e020ef          	jal	4dae <exit>
    printf("%s: chdir .. failed\n", s);
    2a24:	85a6                	mv	a1,s1
    2a26:	00004517          	auipc	a0,0x4
    2a2a:	b6a50513          	addi	a0,a0,-1174 # 6590 <malloc+0x12e6>
    2a2e:	7c8020ef          	jal	51f6 <printf>
    exit(1);
    2a32:	4505                	li	a0,1
    2a34:	37a020ef          	jal	4dae <exit>
    printf("%s: unlink dir0 failed\n", s);
    2a38:	85a6                	mv	a1,s1
    2a3a:	00004517          	auipc	a0,0x4
    2a3e:	b6e50513          	addi	a0,a0,-1170 # 65a8 <malloc+0x12fe>
    2a42:	7b4020ef          	jal	51f6 <printf>
    exit(1);
    2a46:	4505                	li	a0,1
    2a48:	366020ef          	jal	4dae <exit>

0000000000002a4c <subdir>:
{
    2a4c:	1101                	addi	sp,sp,-32
    2a4e:	ec06                	sd	ra,24(sp)
    2a50:	e822                	sd	s0,16(sp)
    2a52:	e426                	sd	s1,8(sp)
    2a54:	e04a                	sd	s2,0(sp)
    2a56:	1000                	addi	s0,sp,32
    2a58:	892a                	mv	s2,a0
  unlink("ff");
    2a5a:	00004517          	auipc	a0,0x4
    2a5e:	c9650513          	addi	a0,a0,-874 # 66f0 <malloc+0x1446>
    2a62:	39c020ef          	jal	4dfe <unlink>
  if (mkdir("dd") != 0) {
    2a66:	00004517          	auipc	a0,0x4
    2a6a:	b5a50513          	addi	a0,a0,-1190 # 65c0 <malloc+0x1316>
    2a6e:	3a8020ef          	jal	4e16 <mkdir>
    2a72:	2e051263          	bnez	a0,2d56 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2a76:	20200593          	li	a1,514
    2a7a:	00004517          	auipc	a0,0x4
    2a7e:	b6650513          	addi	a0,a0,-1178 # 65e0 <malloc+0x1336>
    2a82:	36c020ef          	jal	4dee <open>
    2a86:	84aa                	mv	s1,a0
  if (fd < 0) {
    2a88:	2e054163          	bltz	a0,2d6a <subdir+0x31e>
  write(fd, "ff", 2);
    2a8c:	4609                	li	a2,2
    2a8e:	00004597          	auipc	a1,0x4
    2a92:	c6258593          	addi	a1,a1,-926 # 66f0 <malloc+0x1446>
    2a96:	338020ef          	jal	4dce <write>
  close(fd);
    2a9a:	8526                	mv	a0,s1
    2a9c:	33a020ef          	jal	4dd6 <close>
  if (unlink("dd") >= 0) {
    2aa0:	00004517          	auipc	a0,0x4
    2aa4:	b2050513          	addi	a0,a0,-1248 # 65c0 <malloc+0x1316>
    2aa8:	356020ef          	jal	4dfe <unlink>
    2aac:	2c055963          	bgez	a0,2d7e <subdir+0x332>
  if (mkdir("/dd/dd") != 0) {
    2ab0:	00004517          	auipc	a0,0x4
    2ab4:	b8850513          	addi	a0,a0,-1144 # 6638 <malloc+0x138e>
    2ab8:	35e020ef          	jal	4e16 <mkdir>
    2abc:	2c051b63          	bnez	a0,2d92 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2ac0:	20200593          	li	a1,514
    2ac4:	00004517          	auipc	a0,0x4
    2ac8:	b9c50513          	addi	a0,a0,-1124 # 6660 <malloc+0x13b6>
    2acc:	322020ef          	jal	4dee <open>
    2ad0:	84aa                	mv	s1,a0
  if (fd < 0) {
    2ad2:	2c054a63          	bltz	a0,2da6 <subdir+0x35a>
  write(fd, "FF", 2);
    2ad6:	4609                	li	a2,2
    2ad8:	00004597          	auipc	a1,0x4
    2adc:	bb858593          	addi	a1,a1,-1096 # 6690 <malloc+0x13e6>
    2ae0:	2ee020ef          	jal	4dce <write>
  close(fd);
    2ae4:	8526                	mv	a0,s1
    2ae6:	2f0020ef          	jal	4dd6 <close>
  fd = open("dd/dd/../ff", 0);
    2aea:	4581                	li	a1,0
    2aec:	00004517          	auipc	a0,0x4
    2af0:	bac50513          	addi	a0,a0,-1108 # 6698 <malloc+0x13ee>
    2af4:	2fa020ef          	jal	4dee <open>
    2af8:	84aa                	mv	s1,a0
  if (fd < 0) {
    2afa:	2c054063          	bltz	a0,2dba <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2afe:	660d                	lui	a2,0x3
    2b00:	0000a597          	auipc	a1,0xa
    2b04:	1b858593          	addi	a1,a1,440 # ccb8 <buf>
    2b08:	2be020ef          	jal	4dc6 <read>
  if (cc != 2 || buf[0] != 'f') {
    2b0c:	4789                	li	a5,2
    2b0e:	2cf51063          	bne	a0,a5,2dce <subdir+0x382>
    2b12:	0000a717          	auipc	a4,0xa
    2b16:	1a674703          	lbu	a4,422(a4) # ccb8 <buf>
    2b1a:	06600793          	li	a5,102
    2b1e:	2af71863          	bne	a4,a5,2dce <subdir+0x382>
  close(fd);
    2b22:	8526                	mv	a0,s1
    2b24:	2b2020ef          	jal	4dd6 <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0) {
    2b28:	00004597          	auipc	a1,0x4
    2b2c:	bc058593          	addi	a1,a1,-1088 # 66e8 <malloc+0x143e>
    2b30:	00004517          	auipc	a0,0x4
    2b34:	b3050513          	addi	a0,a0,-1232 # 6660 <malloc+0x13b6>
    2b38:	2d6020ef          	jal	4e0e <link>
    2b3c:	2a051363          	bnez	a0,2de2 <subdir+0x396>
  if (unlink("dd/dd/ff") != 0) {
    2b40:	00004517          	auipc	a0,0x4
    2b44:	b2050513          	addi	a0,a0,-1248 # 6660 <malloc+0x13b6>
    2b48:	2b6020ef          	jal	4dfe <unlink>
    2b4c:	2a051563          	bnez	a0,2df6 <subdir+0x3aa>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2b50:	4581                	li	a1,0
    2b52:	00004517          	auipc	a0,0x4
    2b56:	b0e50513          	addi	a0,a0,-1266 # 6660 <malloc+0x13b6>
    2b5a:	294020ef          	jal	4dee <open>
    2b5e:	2a055663          	bgez	a0,2e0a <subdir+0x3be>
  if (chdir("dd") != 0) {
    2b62:	00004517          	auipc	a0,0x4
    2b66:	a5e50513          	addi	a0,a0,-1442 # 65c0 <malloc+0x1316>
    2b6a:	2b4020ef          	jal	4e1e <chdir>
    2b6e:	2a051863          	bnez	a0,2e1e <subdir+0x3d2>
  if (chdir("dd/../../dd") != 0) {
    2b72:	00004517          	auipc	a0,0x4
    2b76:	c0e50513          	addi	a0,a0,-1010 # 6780 <malloc+0x14d6>
    2b7a:	2a4020ef          	jal	4e1e <chdir>
    2b7e:	2a051a63          	bnez	a0,2e32 <subdir+0x3e6>
  if (chdir("dd/../../../dd") != 0) {
    2b82:	00004517          	auipc	a0,0x4
    2b86:	c2e50513          	addi	a0,a0,-978 # 67b0 <malloc+0x1506>
    2b8a:	294020ef          	jal	4e1e <chdir>
    2b8e:	2a051c63          	bnez	a0,2e46 <subdir+0x3fa>
  if (chdir("./..") != 0) {
    2b92:	00004517          	auipc	a0,0x4
    2b96:	c5650513          	addi	a0,a0,-938 # 67e8 <malloc+0x153e>
    2b9a:	284020ef          	jal	4e1e <chdir>
    2b9e:	2a051e63          	bnez	a0,2e5a <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2ba2:	4581                	li	a1,0
    2ba4:	00004517          	auipc	a0,0x4
    2ba8:	b4450513          	addi	a0,a0,-1212 # 66e8 <malloc+0x143e>
    2bac:	242020ef          	jal	4dee <open>
    2bb0:	84aa                	mv	s1,a0
  if (fd < 0) {
    2bb2:	2a054e63          	bltz	a0,2e6e <subdir+0x422>
  if (read(fd, buf, sizeof(buf)) != 2) {
    2bb6:	660d                	lui	a2,0x3
    2bb8:	0000a597          	auipc	a1,0xa
    2bbc:	10058593          	addi	a1,a1,256 # ccb8 <buf>
    2bc0:	206020ef          	jal	4dc6 <read>
    2bc4:	4789                	li	a5,2
    2bc6:	2af51e63          	bne	a0,a5,2e82 <subdir+0x436>
  close(fd);
    2bca:	8526                	mv	a0,s1
    2bcc:	20a020ef          	jal	4dd6 <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2bd0:	4581                	li	a1,0
    2bd2:	00004517          	auipc	a0,0x4
    2bd6:	a8e50513          	addi	a0,a0,-1394 # 6660 <malloc+0x13b6>
    2bda:	214020ef          	jal	4dee <open>
    2bde:	2a055c63          	bgez	a0,2e96 <subdir+0x44a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0) {
    2be2:	20200593          	li	a1,514
    2be6:	00004517          	auipc	a0,0x4
    2bea:	c9250513          	addi	a0,a0,-878 # 6878 <malloc+0x15ce>
    2bee:	200020ef          	jal	4dee <open>
    2bf2:	2a055c63          	bgez	a0,2eaa <subdir+0x45e>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0) {
    2bf6:	20200593          	li	a1,514
    2bfa:	00004517          	auipc	a0,0x4
    2bfe:	cae50513          	addi	a0,a0,-850 # 68a8 <malloc+0x15fe>
    2c02:	1ec020ef          	jal	4dee <open>
    2c06:	2a055c63          	bgez	a0,2ebe <subdir+0x472>
  if (open("dd", O_CREATE) >= 0) {
    2c0a:	20000593          	li	a1,512
    2c0e:	00004517          	auipc	a0,0x4
    2c12:	9b250513          	addi	a0,a0,-1614 # 65c0 <malloc+0x1316>
    2c16:	1d8020ef          	jal	4dee <open>
    2c1a:	2a055c63          	bgez	a0,2ed2 <subdir+0x486>
  if (open("dd", O_RDWR) >= 0) {
    2c1e:	4589                	li	a1,2
    2c20:	00004517          	auipc	a0,0x4
    2c24:	9a050513          	addi	a0,a0,-1632 # 65c0 <malloc+0x1316>
    2c28:	1c6020ef          	jal	4dee <open>
    2c2c:	2a055d63          	bgez	a0,2ee6 <subdir+0x49a>
  if (open("dd", O_WRONLY) >= 0) {
    2c30:	4585                	li	a1,1
    2c32:	00004517          	auipc	a0,0x4
    2c36:	98e50513          	addi	a0,a0,-1650 # 65c0 <malloc+0x1316>
    2c3a:	1b4020ef          	jal	4dee <open>
    2c3e:	2a055e63          	bgez	a0,2efa <subdir+0x4ae>
  if (link("dd/ff/ff", "dd/dd/xx") == 0) {
    2c42:	00004597          	auipc	a1,0x4
    2c46:	cf658593          	addi	a1,a1,-778 # 6938 <malloc+0x168e>
    2c4a:	00004517          	auipc	a0,0x4
    2c4e:	c2e50513          	addi	a0,a0,-978 # 6878 <malloc+0x15ce>
    2c52:	1bc020ef          	jal	4e0e <link>
    2c56:	2a050c63          	beqz	a0,2f0e <subdir+0x4c2>
  if (link("dd/xx/ff", "dd/dd/xx") == 0) {
    2c5a:	00004597          	auipc	a1,0x4
    2c5e:	cde58593          	addi	a1,a1,-802 # 6938 <malloc+0x168e>
    2c62:	00004517          	auipc	a0,0x4
    2c66:	c4650513          	addi	a0,a0,-954 # 68a8 <malloc+0x15fe>
    2c6a:	1a4020ef          	jal	4e0e <link>
    2c6e:	2a050a63          	beqz	a0,2f22 <subdir+0x4d6>
  if (link("dd/ff", "dd/dd/ffff") == 0) {
    2c72:	00004597          	auipc	a1,0x4
    2c76:	a7658593          	addi	a1,a1,-1418 # 66e8 <malloc+0x143e>
    2c7a:	00004517          	auipc	a0,0x4
    2c7e:	96650513          	addi	a0,a0,-1690 # 65e0 <malloc+0x1336>
    2c82:	18c020ef          	jal	4e0e <link>
    2c86:	2a050863          	beqz	a0,2f36 <subdir+0x4ea>
  if (mkdir("dd/ff/ff") == 0) {
    2c8a:	00004517          	auipc	a0,0x4
    2c8e:	bee50513          	addi	a0,a0,-1042 # 6878 <malloc+0x15ce>
    2c92:	184020ef          	jal	4e16 <mkdir>
    2c96:	2a050a63          	beqz	a0,2f4a <subdir+0x4fe>
  if (mkdir("dd/xx/ff") == 0) {
    2c9a:	00004517          	auipc	a0,0x4
    2c9e:	c0e50513          	addi	a0,a0,-1010 # 68a8 <malloc+0x15fe>
    2ca2:	174020ef          	jal	4e16 <mkdir>
    2ca6:	2a050c63          	beqz	a0,2f5e <subdir+0x512>
  if (mkdir("dd/dd/ffff") == 0) {
    2caa:	00004517          	auipc	a0,0x4
    2cae:	a3e50513          	addi	a0,a0,-1474 # 66e8 <malloc+0x143e>
    2cb2:	164020ef          	jal	4e16 <mkdir>
    2cb6:	2a050e63          	beqz	a0,2f72 <subdir+0x526>
  if (unlink("dd/xx/ff") == 0) {
    2cba:	00004517          	auipc	a0,0x4
    2cbe:	bee50513          	addi	a0,a0,-1042 # 68a8 <malloc+0x15fe>
    2cc2:	13c020ef          	jal	4dfe <unlink>
    2cc6:	2c050063          	beqz	a0,2f86 <subdir+0x53a>
  if (unlink("dd/ff/ff") == 0) {
    2cca:	00004517          	auipc	a0,0x4
    2cce:	bae50513          	addi	a0,a0,-1106 # 6878 <malloc+0x15ce>
    2cd2:	12c020ef          	jal	4dfe <unlink>
    2cd6:	2c050263          	beqz	a0,2f9a <subdir+0x54e>
  if (chdir("dd/ff") == 0) {
    2cda:	00004517          	auipc	a0,0x4
    2cde:	90650513          	addi	a0,a0,-1786 # 65e0 <malloc+0x1336>
    2ce2:	13c020ef          	jal	4e1e <chdir>
    2ce6:	2c050463          	beqz	a0,2fae <subdir+0x562>
  if (chdir("dd/xx") == 0) {
    2cea:	00004517          	auipc	a0,0x4
    2cee:	d9e50513          	addi	a0,a0,-610 # 6a88 <malloc+0x17de>
    2cf2:	12c020ef          	jal	4e1e <chdir>
    2cf6:	2c050663          	beqz	a0,2fc2 <subdir+0x576>
  if (unlink("dd/dd/ffff") != 0) {
    2cfa:	00004517          	auipc	a0,0x4
    2cfe:	9ee50513          	addi	a0,a0,-1554 # 66e8 <malloc+0x143e>
    2d02:	0fc020ef          	jal	4dfe <unlink>
    2d06:	2c051863          	bnez	a0,2fd6 <subdir+0x58a>
  if (unlink("dd/ff") != 0) {
    2d0a:	00004517          	auipc	a0,0x4
    2d0e:	8d650513          	addi	a0,a0,-1834 # 65e0 <malloc+0x1336>
    2d12:	0ec020ef          	jal	4dfe <unlink>
    2d16:	2c051a63          	bnez	a0,2fea <subdir+0x59e>
  if (unlink("dd") == 0) {
    2d1a:	00004517          	auipc	a0,0x4
    2d1e:	8a650513          	addi	a0,a0,-1882 # 65c0 <malloc+0x1316>
    2d22:	0dc020ef          	jal	4dfe <unlink>
    2d26:	2c050c63          	beqz	a0,2ffe <subdir+0x5b2>
  if (unlink("dd/dd") < 0) {
    2d2a:	00004517          	auipc	a0,0x4
    2d2e:	dce50513          	addi	a0,a0,-562 # 6af8 <malloc+0x184e>
    2d32:	0cc020ef          	jal	4dfe <unlink>
    2d36:	2c054e63          	bltz	a0,3012 <subdir+0x5c6>
  if (unlink("dd") < 0) {
    2d3a:	00004517          	auipc	a0,0x4
    2d3e:	88650513          	addi	a0,a0,-1914 # 65c0 <malloc+0x1316>
    2d42:	0bc020ef          	jal	4dfe <unlink>
    2d46:	2e054063          	bltz	a0,3026 <subdir+0x5da>
}
    2d4a:	60e2                	ld	ra,24(sp)
    2d4c:	6442                	ld	s0,16(sp)
    2d4e:	64a2                	ld	s1,8(sp)
    2d50:	6902                	ld	s2,0(sp)
    2d52:	6105                	addi	sp,sp,32
    2d54:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2d56:	85ca                	mv	a1,s2
    2d58:	00004517          	auipc	a0,0x4
    2d5c:	87050513          	addi	a0,a0,-1936 # 65c8 <malloc+0x131e>
    2d60:	496020ef          	jal	51f6 <printf>
    exit(1);
    2d64:	4505                	li	a0,1
    2d66:	048020ef          	jal	4dae <exit>
    printf("%s: create dd/ff failed\n", s);
    2d6a:	85ca                	mv	a1,s2
    2d6c:	00004517          	auipc	a0,0x4
    2d70:	87c50513          	addi	a0,a0,-1924 # 65e8 <malloc+0x133e>
    2d74:	482020ef          	jal	51f6 <printf>
    exit(1);
    2d78:	4505                	li	a0,1
    2d7a:	034020ef          	jal	4dae <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2d7e:	85ca                	mv	a1,s2
    2d80:	00004517          	auipc	a0,0x4
    2d84:	88850513          	addi	a0,a0,-1912 # 6608 <malloc+0x135e>
    2d88:	46e020ef          	jal	51f6 <printf>
    exit(1);
    2d8c:	4505                	li	a0,1
    2d8e:	020020ef          	jal	4dae <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2d92:	85ca                	mv	a1,s2
    2d94:	00004517          	auipc	a0,0x4
    2d98:	8ac50513          	addi	a0,a0,-1876 # 6640 <malloc+0x1396>
    2d9c:	45a020ef          	jal	51f6 <printf>
    exit(1);
    2da0:	4505                	li	a0,1
    2da2:	00c020ef          	jal	4dae <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2da6:	85ca                	mv	a1,s2
    2da8:	00004517          	auipc	a0,0x4
    2dac:	8c850513          	addi	a0,a0,-1848 # 6670 <malloc+0x13c6>
    2db0:	446020ef          	jal	51f6 <printf>
    exit(1);
    2db4:	4505                	li	a0,1
    2db6:	7f9010ef          	jal	4dae <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2dba:	85ca                	mv	a1,s2
    2dbc:	00004517          	auipc	a0,0x4
    2dc0:	8ec50513          	addi	a0,a0,-1812 # 66a8 <malloc+0x13fe>
    2dc4:	432020ef          	jal	51f6 <printf>
    exit(1);
    2dc8:	4505                	li	a0,1
    2dca:	7e5010ef          	jal	4dae <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2dce:	85ca                	mv	a1,s2
    2dd0:	00004517          	auipc	a0,0x4
    2dd4:	8f850513          	addi	a0,a0,-1800 # 66c8 <malloc+0x141e>
    2dd8:	41e020ef          	jal	51f6 <printf>
    exit(1);
    2ddc:	4505                	li	a0,1
    2dde:	7d1010ef          	jal	4dae <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2de2:	85ca                	mv	a1,s2
    2de4:	00004517          	auipc	a0,0x4
    2de8:	91450513          	addi	a0,a0,-1772 # 66f8 <malloc+0x144e>
    2dec:	40a020ef          	jal	51f6 <printf>
    exit(1);
    2df0:	4505                	li	a0,1
    2df2:	7bd010ef          	jal	4dae <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2df6:	85ca                	mv	a1,s2
    2df8:	00004517          	auipc	a0,0x4
    2dfc:	92850513          	addi	a0,a0,-1752 # 6720 <malloc+0x1476>
    2e00:	3f6020ef          	jal	51f6 <printf>
    exit(1);
    2e04:	4505                	li	a0,1
    2e06:	7a9010ef          	jal	4dae <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2e0a:	85ca                	mv	a1,s2
    2e0c:	00004517          	auipc	a0,0x4
    2e10:	93450513          	addi	a0,a0,-1740 # 6740 <malloc+0x1496>
    2e14:	3e2020ef          	jal	51f6 <printf>
    exit(1);
    2e18:	4505                	li	a0,1
    2e1a:	795010ef          	jal	4dae <exit>
    printf("%s: chdir dd failed\n", s);
    2e1e:	85ca                	mv	a1,s2
    2e20:	00004517          	auipc	a0,0x4
    2e24:	94850513          	addi	a0,a0,-1720 # 6768 <malloc+0x14be>
    2e28:	3ce020ef          	jal	51f6 <printf>
    exit(1);
    2e2c:	4505                	li	a0,1
    2e2e:	781010ef          	jal	4dae <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2e32:	85ca                	mv	a1,s2
    2e34:	00004517          	auipc	a0,0x4
    2e38:	95c50513          	addi	a0,a0,-1700 # 6790 <malloc+0x14e6>
    2e3c:	3ba020ef          	jal	51f6 <printf>
    exit(1);
    2e40:	4505                	li	a0,1
    2e42:	76d010ef          	jal	4dae <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2e46:	85ca                	mv	a1,s2
    2e48:	00004517          	auipc	a0,0x4
    2e4c:	97850513          	addi	a0,a0,-1672 # 67c0 <malloc+0x1516>
    2e50:	3a6020ef          	jal	51f6 <printf>
    exit(1);
    2e54:	4505                	li	a0,1
    2e56:	759010ef          	jal	4dae <exit>
    printf("%s: chdir ./.. failed\n", s);
    2e5a:	85ca                	mv	a1,s2
    2e5c:	00004517          	auipc	a0,0x4
    2e60:	99450513          	addi	a0,a0,-1644 # 67f0 <malloc+0x1546>
    2e64:	392020ef          	jal	51f6 <printf>
    exit(1);
    2e68:	4505                	li	a0,1
    2e6a:	745010ef          	jal	4dae <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2e6e:	85ca                	mv	a1,s2
    2e70:	00004517          	auipc	a0,0x4
    2e74:	99850513          	addi	a0,a0,-1640 # 6808 <malloc+0x155e>
    2e78:	37e020ef          	jal	51f6 <printf>
    exit(1);
    2e7c:	4505                	li	a0,1
    2e7e:	731010ef          	jal	4dae <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2e82:	85ca                	mv	a1,s2
    2e84:	00004517          	auipc	a0,0x4
    2e88:	9a450513          	addi	a0,a0,-1628 # 6828 <malloc+0x157e>
    2e8c:	36a020ef          	jal	51f6 <printf>
    exit(1);
    2e90:	4505                	li	a0,1
    2e92:	71d010ef          	jal	4dae <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2e96:	85ca                	mv	a1,s2
    2e98:	00004517          	auipc	a0,0x4
    2e9c:	9b050513          	addi	a0,a0,-1616 # 6848 <malloc+0x159e>
    2ea0:	356020ef          	jal	51f6 <printf>
    exit(1);
    2ea4:	4505                	li	a0,1
    2ea6:	709010ef          	jal	4dae <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2eaa:	85ca                	mv	a1,s2
    2eac:	00004517          	auipc	a0,0x4
    2eb0:	9dc50513          	addi	a0,a0,-1572 # 6888 <malloc+0x15de>
    2eb4:	342020ef          	jal	51f6 <printf>
    exit(1);
    2eb8:	4505                	li	a0,1
    2eba:	6f5010ef          	jal	4dae <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2ebe:	85ca                	mv	a1,s2
    2ec0:	00004517          	auipc	a0,0x4
    2ec4:	9f850513          	addi	a0,a0,-1544 # 68b8 <malloc+0x160e>
    2ec8:	32e020ef          	jal	51f6 <printf>
    exit(1);
    2ecc:	4505                	li	a0,1
    2ece:	6e1010ef          	jal	4dae <exit>
    printf("%s: create dd succeeded!\n", s);
    2ed2:	85ca                	mv	a1,s2
    2ed4:	00004517          	auipc	a0,0x4
    2ed8:	a0450513          	addi	a0,a0,-1532 # 68d8 <malloc+0x162e>
    2edc:	31a020ef          	jal	51f6 <printf>
    exit(1);
    2ee0:	4505                	li	a0,1
    2ee2:	6cd010ef          	jal	4dae <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    2ee6:	85ca                	mv	a1,s2
    2ee8:	00004517          	auipc	a0,0x4
    2eec:	a1050513          	addi	a0,a0,-1520 # 68f8 <malloc+0x164e>
    2ef0:	306020ef          	jal	51f6 <printf>
    exit(1);
    2ef4:	4505                	li	a0,1
    2ef6:	6b9010ef          	jal	4dae <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    2efa:	85ca                	mv	a1,s2
    2efc:	00004517          	auipc	a0,0x4
    2f00:	a1c50513          	addi	a0,a0,-1508 # 6918 <malloc+0x166e>
    2f04:	2f2020ef          	jal	51f6 <printf>
    exit(1);
    2f08:	4505                	li	a0,1
    2f0a:	6a5010ef          	jal	4dae <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    2f0e:	85ca                	mv	a1,s2
    2f10:	00004517          	auipc	a0,0x4
    2f14:	a3850513          	addi	a0,a0,-1480 # 6948 <malloc+0x169e>
    2f18:	2de020ef          	jal	51f6 <printf>
    exit(1);
    2f1c:	4505                	li	a0,1
    2f1e:	691010ef          	jal	4dae <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    2f22:	85ca                	mv	a1,s2
    2f24:	00004517          	auipc	a0,0x4
    2f28:	a4c50513          	addi	a0,a0,-1460 # 6970 <malloc+0x16c6>
    2f2c:	2ca020ef          	jal	51f6 <printf>
    exit(1);
    2f30:	4505                	li	a0,1
    2f32:	67d010ef          	jal	4dae <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    2f36:	85ca                	mv	a1,s2
    2f38:	00004517          	auipc	a0,0x4
    2f3c:	a6050513          	addi	a0,a0,-1440 # 6998 <malloc+0x16ee>
    2f40:	2b6020ef          	jal	51f6 <printf>
    exit(1);
    2f44:	4505                	li	a0,1
    2f46:	669010ef          	jal	4dae <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    2f4a:	85ca                	mv	a1,s2
    2f4c:	00004517          	auipc	a0,0x4
    2f50:	a7450513          	addi	a0,a0,-1420 # 69c0 <malloc+0x1716>
    2f54:	2a2020ef          	jal	51f6 <printf>
    exit(1);
    2f58:	4505                	li	a0,1
    2f5a:	655010ef          	jal	4dae <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    2f5e:	85ca                	mv	a1,s2
    2f60:	00004517          	auipc	a0,0x4
    2f64:	a8050513          	addi	a0,a0,-1408 # 69e0 <malloc+0x1736>
    2f68:	28e020ef          	jal	51f6 <printf>
    exit(1);
    2f6c:	4505                	li	a0,1
    2f6e:	641010ef          	jal	4dae <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    2f72:	85ca                	mv	a1,s2
    2f74:	00004517          	auipc	a0,0x4
    2f78:	a8c50513          	addi	a0,a0,-1396 # 6a00 <malloc+0x1756>
    2f7c:	27a020ef          	jal	51f6 <printf>
    exit(1);
    2f80:	4505                	li	a0,1
    2f82:	62d010ef          	jal	4dae <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    2f86:	85ca                	mv	a1,s2
    2f88:	00004517          	auipc	a0,0x4
    2f8c:	aa050513          	addi	a0,a0,-1376 # 6a28 <malloc+0x177e>
    2f90:	266020ef          	jal	51f6 <printf>
    exit(1);
    2f94:	4505                	li	a0,1
    2f96:	619010ef          	jal	4dae <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    2f9a:	85ca                	mv	a1,s2
    2f9c:	00004517          	auipc	a0,0x4
    2fa0:	aac50513          	addi	a0,a0,-1364 # 6a48 <malloc+0x179e>
    2fa4:	252020ef          	jal	51f6 <printf>
    exit(1);
    2fa8:	4505                	li	a0,1
    2faa:	605010ef          	jal	4dae <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    2fae:	85ca                	mv	a1,s2
    2fb0:	00004517          	auipc	a0,0x4
    2fb4:	ab850513          	addi	a0,a0,-1352 # 6a68 <malloc+0x17be>
    2fb8:	23e020ef          	jal	51f6 <printf>
    exit(1);
    2fbc:	4505                	li	a0,1
    2fbe:	5f1010ef          	jal	4dae <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    2fc2:	85ca                	mv	a1,s2
    2fc4:	00004517          	auipc	a0,0x4
    2fc8:	acc50513          	addi	a0,a0,-1332 # 6a90 <malloc+0x17e6>
    2fcc:	22a020ef          	jal	51f6 <printf>
    exit(1);
    2fd0:	4505                	li	a0,1
    2fd2:	5dd010ef          	jal	4dae <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2fd6:	85ca                	mv	a1,s2
    2fd8:	00003517          	auipc	a0,0x3
    2fdc:	74850513          	addi	a0,a0,1864 # 6720 <malloc+0x1476>
    2fe0:	216020ef          	jal	51f6 <printf>
    exit(1);
    2fe4:	4505                	li	a0,1
    2fe6:	5c9010ef          	jal	4dae <exit>
    printf("%s: unlink dd/ff failed\n", s);
    2fea:	85ca                	mv	a1,s2
    2fec:	00004517          	auipc	a0,0x4
    2ff0:	ac450513          	addi	a0,a0,-1340 # 6ab0 <malloc+0x1806>
    2ff4:	202020ef          	jal	51f6 <printf>
    exit(1);
    2ff8:	4505                	li	a0,1
    2ffa:	5b5010ef          	jal	4dae <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    2ffe:	85ca                	mv	a1,s2
    3000:	00004517          	auipc	a0,0x4
    3004:	ad050513          	addi	a0,a0,-1328 # 6ad0 <malloc+0x1826>
    3008:	1ee020ef          	jal	51f6 <printf>
    exit(1);
    300c:	4505                	li	a0,1
    300e:	5a1010ef          	jal	4dae <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3012:	85ca                	mv	a1,s2
    3014:	00004517          	auipc	a0,0x4
    3018:	aec50513          	addi	a0,a0,-1300 # 6b00 <malloc+0x1856>
    301c:	1da020ef          	jal	51f6 <printf>
    exit(1);
    3020:	4505                	li	a0,1
    3022:	58d010ef          	jal	4dae <exit>
    printf("%s: unlink dd failed\n", s);
    3026:	85ca                	mv	a1,s2
    3028:	00004517          	auipc	a0,0x4
    302c:	af850513          	addi	a0,a0,-1288 # 6b20 <malloc+0x1876>
    3030:	1c6020ef          	jal	51f6 <printf>
    exit(1);
    3034:	4505                	li	a0,1
    3036:	579010ef          	jal	4dae <exit>

000000000000303a <rmdot>:
{
    303a:	1101                	addi	sp,sp,-32
    303c:	ec06                	sd	ra,24(sp)
    303e:	e822                	sd	s0,16(sp)
    3040:	e426                	sd	s1,8(sp)
    3042:	1000                	addi	s0,sp,32
    3044:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0) {
    3046:	00004517          	auipc	a0,0x4
    304a:	af250513          	addi	a0,a0,-1294 # 6b38 <malloc+0x188e>
    304e:	5c9010ef          	jal	4e16 <mkdir>
    3052:	e53d                	bnez	a0,30c0 <rmdot+0x86>
  if (chdir("dots") != 0) {
    3054:	00004517          	auipc	a0,0x4
    3058:	ae450513          	addi	a0,a0,-1308 # 6b38 <malloc+0x188e>
    305c:	5c3010ef          	jal	4e1e <chdir>
    3060:	e935                	bnez	a0,30d4 <rmdot+0x9a>
  if (unlink(".") == 0) {
    3062:	00003517          	auipc	a0,0x3
    3066:	a6e50513          	addi	a0,a0,-1426 # 5ad0 <malloc+0x826>
    306a:	595010ef          	jal	4dfe <unlink>
    306e:	cd2d                	beqz	a0,30e8 <rmdot+0xae>
  if (unlink("..") == 0) {
    3070:	00003517          	auipc	a0,0x3
    3074:	51850513          	addi	a0,a0,1304 # 6588 <malloc+0x12de>
    3078:	587010ef          	jal	4dfe <unlink>
    307c:	c141                	beqz	a0,30fc <rmdot+0xc2>
  if (chdir("/") != 0) {
    307e:	00003517          	auipc	a0,0x3
    3082:	4b250513          	addi	a0,a0,1202 # 6530 <malloc+0x1286>
    3086:	599010ef          	jal	4e1e <chdir>
    308a:	e159                	bnez	a0,3110 <rmdot+0xd6>
  if (unlink("dots/.") == 0) {
    308c:	00004517          	auipc	a0,0x4
    3090:	b1450513          	addi	a0,a0,-1260 # 6ba0 <malloc+0x18f6>
    3094:	56b010ef          	jal	4dfe <unlink>
    3098:	c551                	beqz	a0,3124 <rmdot+0xea>
  if (unlink("dots/..") == 0) {
    309a:	00004517          	auipc	a0,0x4
    309e:	b2e50513          	addi	a0,a0,-1234 # 6bc8 <malloc+0x191e>
    30a2:	55d010ef          	jal	4dfe <unlink>
    30a6:	c949                	beqz	a0,3138 <rmdot+0xfe>
  if (unlink("dots") != 0) {
    30a8:	00004517          	auipc	a0,0x4
    30ac:	a9050513          	addi	a0,a0,-1392 # 6b38 <malloc+0x188e>
    30b0:	54f010ef          	jal	4dfe <unlink>
    30b4:	ed41                	bnez	a0,314c <rmdot+0x112>
}
    30b6:	60e2                	ld	ra,24(sp)
    30b8:	6442                	ld	s0,16(sp)
    30ba:	64a2                	ld	s1,8(sp)
    30bc:	6105                	addi	sp,sp,32
    30be:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    30c0:	85a6                	mv	a1,s1
    30c2:	00004517          	auipc	a0,0x4
    30c6:	a7e50513          	addi	a0,a0,-1410 # 6b40 <malloc+0x1896>
    30ca:	12c020ef          	jal	51f6 <printf>
    exit(1);
    30ce:	4505                	li	a0,1
    30d0:	4df010ef          	jal	4dae <exit>
    printf("%s: chdir dots failed\n", s);
    30d4:	85a6                	mv	a1,s1
    30d6:	00004517          	auipc	a0,0x4
    30da:	a8250513          	addi	a0,a0,-1406 # 6b58 <malloc+0x18ae>
    30de:	118020ef          	jal	51f6 <printf>
    exit(1);
    30e2:	4505                	li	a0,1
    30e4:	4cb010ef          	jal	4dae <exit>
    printf("%s: rm . worked!\n", s);
    30e8:	85a6                	mv	a1,s1
    30ea:	00004517          	auipc	a0,0x4
    30ee:	a8650513          	addi	a0,a0,-1402 # 6b70 <malloc+0x18c6>
    30f2:	104020ef          	jal	51f6 <printf>
    exit(1);
    30f6:	4505                	li	a0,1
    30f8:	4b7010ef          	jal	4dae <exit>
    printf("%s: rm .. worked!\n", s);
    30fc:	85a6                	mv	a1,s1
    30fe:	00004517          	auipc	a0,0x4
    3102:	a8a50513          	addi	a0,a0,-1398 # 6b88 <malloc+0x18de>
    3106:	0f0020ef          	jal	51f6 <printf>
    exit(1);
    310a:	4505                	li	a0,1
    310c:	4a3010ef          	jal	4dae <exit>
    printf("%s: chdir / failed\n", s);
    3110:	85a6                	mv	a1,s1
    3112:	00003517          	auipc	a0,0x3
    3116:	42650513          	addi	a0,a0,1062 # 6538 <malloc+0x128e>
    311a:	0dc020ef          	jal	51f6 <printf>
    exit(1);
    311e:	4505                	li	a0,1
    3120:	48f010ef          	jal	4dae <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3124:	85a6                	mv	a1,s1
    3126:	00004517          	auipc	a0,0x4
    312a:	a8250513          	addi	a0,a0,-1406 # 6ba8 <malloc+0x18fe>
    312e:	0c8020ef          	jal	51f6 <printf>
    exit(1);
    3132:	4505                	li	a0,1
    3134:	47b010ef          	jal	4dae <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3138:	85a6                	mv	a1,s1
    313a:	00004517          	auipc	a0,0x4
    313e:	a9650513          	addi	a0,a0,-1386 # 6bd0 <malloc+0x1926>
    3142:	0b4020ef          	jal	51f6 <printf>
    exit(1);
    3146:	4505                	li	a0,1
    3148:	467010ef          	jal	4dae <exit>
    printf("%s: unlink dots failed!\n", s);
    314c:	85a6                	mv	a1,s1
    314e:	00004517          	auipc	a0,0x4
    3152:	aa250513          	addi	a0,a0,-1374 # 6bf0 <malloc+0x1946>
    3156:	0a0020ef          	jal	51f6 <printf>
    exit(1);
    315a:	4505                	li	a0,1
    315c:	453010ef          	jal	4dae <exit>

0000000000003160 <dirfile>:
{
    3160:	1101                	addi	sp,sp,-32
    3162:	ec06                	sd	ra,24(sp)
    3164:	e822                	sd	s0,16(sp)
    3166:	e426                	sd	s1,8(sp)
    3168:	e04a                	sd	s2,0(sp)
    316a:	1000                	addi	s0,sp,32
    316c:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    316e:	20000593          	li	a1,512
    3172:	00004517          	auipc	a0,0x4
    3176:	a9e50513          	addi	a0,a0,-1378 # 6c10 <malloc+0x1966>
    317a:	475010ef          	jal	4dee <open>
  if (fd < 0) {
    317e:	0c054563          	bltz	a0,3248 <dirfile+0xe8>
  close(fd);
    3182:	455010ef          	jal	4dd6 <close>
  if (chdir("dirfile") == 0) {
    3186:	00004517          	auipc	a0,0x4
    318a:	a8a50513          	addi	a0,a0,-1398 # 6c10 <malloc+0x1966>
    318e:	491010ef          	jal	4e1e <chdir>
    3192:	c569                	beqz	a0,325c <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    3194:	4581                	li	a1,0
    3196:	00004517          	auipc	a0,0x4
    319a:	ac250513          	addi	a0,a0,-1342 # 6c58 <malloc+0x19ae>
    319e:	451010ef          	jal	4dee <open>
  if (fd >= 0) {
    31a2:	0c055763          	bgez	a0,3270 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    31a6:	20000593          	li	a1,512
    31aa:	00004517          	auipc	a0,0x4
    31ae:	aae50513          	addi	a0,a0,-1362 # 6c58 <malloc+0x19ae>
    31b2:	43d010ef          	jal	4dee <open>
  if (fd >= 0) {
    31b6:	0c055763          	bgez	a0,3284 <dirfile+0x124>
  if (mkdir("dirfile/xx") == 0) {
    31ba:	00004517          	auipc	a0,0x4
    31be:	a9e50513          	addi	a0,a0,-1378 # 6c58 <malloc+0x19ae>
    31c2:	455010ef          	jal	4e16 <mkdir>
    31c6:	0c050963          	beqz	a0,3298 <dirfile+0x138>
  if (unlink("dirfile/xx") == 0) {
    31ca:	00004517          	auipc	a0,0x4
    31ce:	a8e50513          	addi	a0,a0,-1394 # 6c58 <malloc+0x19ae>
    31d2:	42d010ef          	jal	4dfe <unlink>
    31d6:	0c050b63          	beqz	a0,32ac <dirfile+0x14c>
  if (link("README", "dirfile/xx") == 0) {
    31da:	00004597          	auipc	a1,0x4
    31de:	a7e58593          	addi	a1,a1,-1410 # 6c58 <malloc+0x19ae>
    31e2:	00002517          	auipc	a0,0x2
    31e6:	3de50513          	addi	a0,a0,990 # 55c0 <malloc+0x316>
    31ea:	425010ef          	jal	4e0e <link>
    31ee:	0c050963          	beqz	a0,32c0 <dirfile+0x160>
  if (unlink("dirfile") != 0) {
    31f2:	00004517          	auipc	a0,0x4
    31f6:	a1e50513          	addi	a0,a0,-1506 # 6c10 <malloc+0x1966>
    31fa:	405010ef          	jal	4dfe <unlink>
    31fe:	0c051b63          	bnez	a0,32d4 <dirfile+0x174>
  fd = open(".", O_RDWR);
    3202:	4589                	li	a1,2
    3204:	00003517          	auipc	a0,0x3
    3208:	8cc50513          	addi	a0,a0,-1844 # 5ad0 <malloc+0x826>
    320c:	3e3010ef          	jal	4dee <open>
  if (fd >= 0) {
    3210:	0c055c63          	bgez	a0,32e8 <dirfile+0x188>
  fd = open(".", 0);
    3214:	4581                	li	a1,0
    3216:	00003517          	auipc	a0,0x3
    321a:	8ba50513          	addi	a0,a0,-1862 # 5ad0 <malloc+0x826>
    321e:	3d1010ef          	jal	4dee <open>
    3222:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0) {
    3224:	4605                	li	a2,1
    3226:	00002597          	auipc	a1,0x2
    322a:	23258593          	addi	a1,a1,562 # 5458 <malloc+0x1ae>
    322e:	3a1010ef          	jal	4dce <write>
    3232:	0ca04563          	bgtz	a0,32fc <dirfile+0x19c>
  close(fd);
    3236:	8526                	mv	a0,s1
    3238:	39f010ef          	jal	4dd6 <close>
}
    323c:	60e2                	ld	ra,24(sp)
    323e:	6442                	ld	s0,16(sp)
    3240:	64a2                	ld	s1,8(sp)
    3242:	6902                	ld	s2,0(sp)
    3244:	6105                	addi	sp,sp,32
    3246:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3248:	85ca                	mv	a1,s2
    324a:	00004517          	auipc	a0,0x4
    324e:	9ce50513          	addi	a0,a0,-1586 # 6c18 <malloc+0x196e>
    3252:	7a5010ef          	jal	51f6 <printf>
    exit(1);
    3256:	4505                	li	a0,1
    3258:	357010ef          	jal	4dae <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    325c:	85ca                	mv	a1,s2
    325e:	00004517          	auipc	a0,0x4
    3262:	9da50513          	addi	a0,a0,-1574 # 6c38 <malloc+0x198e>
    3266:	791010ef          	jal	51f6 <printf>
    exit(1);
    326a:	4505                	li	a0,1
    326c:	343010ef          	jal	4dae <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3270:	85ca                	mv	a1,s2
    3272:	00004517          	auipc	a0,0x4
    3276:	9f650513          	addi	a0,a0,-1546 # 6c68 <malloc+0x19be>
    327a:	77d010ef          	jal	51f6 <printf>
    exit(1);
    327e:	4505                	li	a0,1
    3280:	32f010ef          	jal	4dae <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3284:	85ca                	mv	a1,s2
    3286:	00004517          	auipc	a0,0x4
    328a:	9e250513          	addi	a0,a0,-1566 # 6c68 <malloc+0x19be>
    328e:	769010ef          	jal	51f6 <printf>
    exit(1);
    3292:	4505                	li	a0,1
    3294:	31b010ef          	jal	4dae <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3298:	85ca                	mv	a1,s2
    329a:	00004517          	auipc	a0,0x4
    329e:	9f650513          	addi	a0,a0,-1546 # 6c90 <malloc+0x19e6>
    32a2:	755010ef          	jal	51f6 <printf>
    exit(1);
    32a6:	4505                	li	a0,1
    32a8:	307010ef          	jal	4dae <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    32ac:	85ca                	mv	a1,s2
    32ae:	00004517          	auipc	a0,0x4
    32b2:	a0a50513          	addi	a0,a0,-1526 # 6cb8 <malloc+0x1a0e>
    32b6:	741010ef          	jal	51f6 <printf>
    exit(1);
    32ba:	4505                	li	a0,1
    32bc:	2f3010ef          	jal	4dae <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    32c0:	85ca                	mv	a1,s2
    32c2:	00004517          	auipc	a0,0x4
    32c6:	a1e50513          	addi	a0,a0,-1506 # 6ce0 <malloc+0x1a36>
    32ca:	72d010ef          	jal	51f6 <printf>
    exit(1);
    32ce:	4505                	li	a0,1
    32d0:	2df010ef          	jal	4dae <exit>
    printf("%s: unlink dirfile failed!\n", s);
    32d4:	85ca                	mv	a1,s2
    32d6:	00004517          	auipc	a0,0x4
    32da:	a3250513          	addi	a0,a0,-1486 # 6d08 <malloc+0x1a5e>
    32de:	719010ef          	jal	51f6 <printf>
    exit(1);
    32e2:	4505                	li	a0,1
    32e4:	2cb010ef          	jal	4dae <exit>
    printf("%s: open . for writing succeeded!\n", s);
    32e8:	85ca                	mv	a1,s2
    32ea:	00004517          	auipc	a0,0x4
    32ee:	a3e50513          	addi	a0,a0,-1474 # 6d28 <malloc+0x1a7e>
    32f2:	705010ef          	jal	51f6 <printf>
    exit(1);
    32f6:	4505                	li	a0,1
    32f8:	2b7010ef          	jal	4dae <exit>
    printf("%s: write . succeeded!\n", s);
    32fc:	85ca                	mv	a1,s2
    32fe:	00004517          	auipc	a0,0x4
    3302:	a5250513          	addi	a0,a0,-1454 # 6d50 <malloc+0x1aa6>
    3306:	6f1010ef          	jal	51f6 <printf>
    exit(1);
    330a:	4505                	li	a0,1
    330c:	2a3010ef          	jal	4dae <exit>

0000000000003310 <iref>:
{
    3310:	7139                	addi	sp,sp,-64
    3312:	fc06                	sd	ra,56(sp)
    3314:	f822                	sd	s0,48(sp)
    3316:	f426                	sd	s1,40(sp)
    3318:	f04a                	sd	s2,32(sp)
    331a:	ec4e                	sd	s3,24(sp)
    331c:	e852                	sd	s4,16(sp)
    331e:	e456                	sd	s5,8(sp)
    3320:	e05a                	sd	s6,0(sp)
    3322:	0080                	addi	s0,sp,64
    3324:	8b2a                	mv	s6,a0
    3326:	03300913          	li	s2,51
    if (mkdir("irefd") != 0) {
    332a:	00004a17          	auipc	s4,0x4
    332e:	a3ea0a13          	addi	s4,s4,-1474 # 6d68 <malloc+0x1abe>
    mkdir("");
    3332:	00003497          	auipc	s1,0x3
    3336:	53e48493          	addi	s1,s1,1342 # 6870 <malloc+0x15c6>
    link("README", "");
    333a:	00002a97          	auipc	s5,0x2
    333e:	286a8a93          	addi	s5,s5,646 # 55c0 <malloc+0x316>
    fd = open("xx", O_CREATE);
    3342:	00004997          	auipc	s3,0x4
    3346:	91e98993          	addi	s3,s3,-1762 # 6c60 <malloc+0x19b6>
    334a:	a835                	j	3386 <iref+0x76>
      printf("%s: mkdir irefd failed\n", s);
    334c:	85da                	mv	a1,s6
    334e:	00004517          	auipc	a0,0x4
    3352:	a2250513          	addi	a0,a0,-1502 # 6d70 <malloc+0x1ac6>
    3356:	6a1010ef          	jal	51f6 <printf>
      exit(1);
    335a:	4505                	li	a0,1
    335c:	253010ef          	jal	4dae <exit>
      printf("%s: chdir irefd failed\n", s);
    3360:	85da                	mv	a1,s6
    3362:	00004517          	auipc	a0,0x4
    3366:	a2650513          	addi	a0,a0,-1498 # 6d88 <malloc+0x1ade>
    336a:	68d010ef          	jal	51f6 <printf>
      exit(1);
    336e:	4505                	li	a0,1
    3370:	23f010ef          	jal	4dae <exit>
      close(fd);
    3374:	263010ef          	jal	4dd6 <close>
    3378:	a82d                	j	33b2 <iref+0xa2>
    unlink("xx");
    337a:	854e                	mv	a0,s3
    337c:	283010ef          	jal	4dfe <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    3380:	397d                	addiw	s2,s2,-1
    3382:	04090263          	beqz	s2,33c6 <iref+0xb6>
    if (mkdir("irefd") != 0) {
    3386:	8552                	mv	a0,s4
    3388:	28f010ef          	jal	4e16 <mkdir>
    338c:	f161                	bnez	a0,334c <iref+0x3c>
    if (chdir("irefd") != 0) {
    338e:	8552                	mv	a0,s4
    3390:	28f010ef          	jal	4e1e <chdir>
    3394:	f571                	bnez	a0,3360 <iref+0x50>
    mkdir("");
    3396:	8526                	mv	a0,s1
    3398:	27f010ef          	jal	4e16 <mkdir>
    link("README", "");
    339c:	85a6                	mv	a1,s1
    339e:	8556                	mv	a0,s5
    33a0:	26f010ef          	jal	4e0e <link>
    fd = open("", O_CREATE);
    33a4:	20000593          	li	a1,512
    33a8:	8526                	mv	a0,s1
    33aa:	245010ef          	jal	4dee <open>
    if (fd >= 0)
    33ae:	fc0553e3          	bgez	a0,3374 <iref+0x64>
    fd = open("xx", O_CREATE);
    33b2:	20000593          	li	a1,512
    33b6:	854e                	mv	a0,s3
    33b8:	237010ef          	jal	4dee <open>
    if (fd >= 0)
    33bc:	fa054fe3          	bltz	a0,337a <iref+0x6a>
      close(fd);
    33c0:	217010ef          	jal	4dd6 <close>
    33c4:	bf5d                	j	337a <iref+0x6a>
    33c6:	03300493          	li	s1,51
    chdir("..");
    33ca:	00003997          	auipc	s3,0x3
    33ce:	1be98993          	addi	s3,s3,446 # 6588 <malloc+0x12de>
    unlink("irefd");
    33d2:	00004917          	auipc	s2,0x4
    33d6:	99690913          	addi	s2,s2,-1642 # 6d68 <malloc+0x1abe>
    chdir("..");
    33da:	854e                	mv	a0,s3
    33dc:	243010ef          	jal	4e1e <chdir>
    unlink("irefd");
    33e0:	854a                	mv	a0,s2
    33e2:	21d010ef          	jal	4dfe <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    33e6:	34fd                	addiw	s1,s1,-1
    33e8:	f8ed                	bnez	s1,33da <iref+0xca>
  chdir("/");
    33ea:	00003517          	auipc	a0,0x3
    33ee:	14650513          	addi	a0,a0,326 # 6530 <malloc+0x1286>
    33f2:	22d010ef          	jal	4e1e <chdir>
}
    33f6:	70e2                	ld	ra,56(sp)
    33f8:	7442                	ld	s0,48(sp)
    33fa:	74a2                	ld	s1,40(sp)
    33fc:	7902                	ld	s2,32(sp)
    33fe:	69e2                	ld	s3,24(sp)
    3400:	6a42                	ld	s4,16(sp)
    3402:	6aa2                	ld	s5,8(sp)
    3404:	6b02                	ld	s6,0(sp)
    3406:	6121                	addi	sp,sp,64
    3408:	8082                	ret

000000000000340a <openiputtest>:
{
    340a:	7179                	addi	sp,sp,-48
    340c:	f406                	sd	ra,40(sp)
    340e:	f022                	sd	s0,32(sp)
    3410:	ec26                	sd	s1,24(sp)
    3412:	1800                	addi	s0,sp,48
    3414:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0) {
    3416:	00004517          	auipc	a0,0x4
    341a:	98a50513          	addi	a0,a0,-1654 # 6da0 <malloc+0x1af6>
    341e:	1f9010ef          	jal	4e16 <mkdir>
    3422:	02054a63          	bltz	a0,3456 <openiputtest+0x4c>
  pid = fork();
    3426:	181010ef          	jal	4da6 <fork>
  if (pid < 0) {
    342a:	04054063          	bltz	a0,346a <openiputtest+0x60>
  if (pid == 0) {
    342e:	e939                	bnez	a0,3484 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    3430:	4589                	li	a1,2
    3432:	00004517          	auipc	a0,0x4
    3436:	96e50513          	addi	a0,a0,-1682 # 6da0 <malloc+0x1af6>
    343a:	1b5010ef          	jal	4dee <open>
    if (fd >= 0) {
    343e:	04054063          	bltz	a0,347e <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    3442:	85a6                	mv	a1,s1
    3444:	00004517          	auipc	a0,0x4
    3448:	97c50513          	addi	a0,a0,-1668 # 6dc0 <malloc+0x1b16>
    344c:	5ab010ef          	jal	51f6 <printf>
      exit(1);
    3450:	4505                	li	a0,1
    3452:	15d010ef          	jal	4dae <exit>
    printf("%s: mkdir oidir failed\n", s);
    3456:	85a6                	mv	a1,s1
    3458:	00004517          	auipc	a0,0x4
    345c:	95050513          	addi	a0,a0,-1712 # 6da8 <malloc+0x1afe>
    3460:	597010ef          	jal	51f6 <printf>
    exit(1);
    3464:	4505                	li	a0,1
    3466:	149010ef          	jal	4dae <exit>
    printf("%s: fork failed\n", s);
    346a:	85a6                	mv	a1,s1
    346c:	00003517          	auipc	a0,0x3
    3470:	80c50513          	addi	a0,a0,-2036 # 5c78 <malloc+0x9ce>
    3474:	583010ef          	jal	51f6 <printf>
    exit(1);
    3478:	4505                	li	a0,1
    347a:	135010ef          	jal	4dae <exit>
    exit(0);
    347e:	4501                	li	a0,0
    3480:	12f010ef          	jal	4dae <exit>
  pause(1);
    3484:	4505                	li	a0,1
    3486:	1b9010ef          	jal	4e3e <pause>
  if (unlink("oidir") != 0) {
    348a:	00004517          	auipc	a0,0x4
    348e:	91650513          	addi	a0,a0,-1770 # 6da0 <malloc+0x1af6>
    3492:	16d010ef          	jal	4dfe <unlink>
    3496:	c919                	beqz	a0,34ac <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    3498:	85a6                	mv	a1,s1
    349a:	00003517          	auipc	a0,0x3
    349e:	96650513          	addi	a0,a0,-1690 # 5e00 <malloc+0xb56>
    34a2:	555010ef          	jal	51f6 <printf>
    exit(1);
    34a6:	4505                	li	a0,1
    34a8:	107010ef          	jal	4dae <exit>
  wait(&xstatus);
    34ac:	fdc40513          	addi	a0,s0,-36
    34b0:	107010ef          	jal	4db6 <wait>
  exit(xstatus);
    34b4:	fdc42503          	lw	a0,-36(s0)
    34b8:	0f7010ef          	jal	4dae <exit>

00000000000034bc <forkforkfork>:
{
    34bc:	1101                	addi	sp,sp,-32
    34be:	ec06                	sd	ra,24(sp)
    34c0:	e822                	sd	s0,16(sp)
    34c2:	e426                	sd	s1,8(sp)
    34c4:	1000                	addi	s0,sp,32
    34c6:	84aa                	mv	s1,a0
  unlink("stopforking");
    34c8:	00004517          	auipc	a0,0x4
    34cc:	92050513          	addi	a0,a0,-1760 # 6de8 <malloc+0x1b3e>
    34d0:	12f010ef          	jal	4dfe <unlink>
  int pid = fork();
    34d4:	0d3010ef          	jal	4da6 <fork>
  if (pid < 0) {
    34d8:	02054b63          	bltz	a0,350e <forkforkfork+0x52>
  if (pid == 0) {
    34dc:	c139                	beqz	a0,3522 <forkforkfork+0x66>
  pause(20); // two seconds
    34de:	4551                	li	a0,20
    34e0:	15f010ef          	jal	4e3e <pause>
  close(open("stopforking", O_CREATE | O_RDWR));
    34e4:	20200593          	li	a1,514
    34e8:	00004517          	auipc	a0,0x4
    34ec:	90050513          	addi	a0,a0,-1792 # 6de8 <malloc+0x1b3e>
    34f0:	0ff010ef          	jal	4dee <open>
    34f4:	0e3010ef          	jal	4dd6 <close>
  wait(0);
    34f8:	4501                	li	a0,0
    34fa:	0bd010ef          	jal	4db6 <wait>
  pause(10); // one second
    34fe:	4529                	li	a0,10
    3500:	13f010ef          	jal	4e3e <pause>
}
    3504:	60e2                	ld	ra,24(sp)
    3506:	6442                	ld	s0,16(sp)
    3508:	64a2                	ld	s1,8(sp)
    350a:	6105                	addi	sp,sp,32
    350c:	8082                	ret
    printf("%s: fork failed", s);
    350e:	85a6                	mv	a1,s1
    3510:	00003517          	auipc	a0,0x3
    3514:	8a850513          	addi	a0,a0,-1880 # 5db8 <malloc+0xb0e>
    3518:	4df010ef          	jal	51f6 <printf>
    exit(1);
    351c:	4505                	li	a0,1
    351e:	091010ef          	jal	4dae <exit>
      int fd = open("stopforking", 0);
    3522:	00004497          	auipc	s1,0x4
    3526:	8c648493          	addi	s1,s1,-1850 # 6de8 <malloc+0x1b3e>
    352a:	4581                	li	a1,0
    352c:	8526                	mv	a0,s1
    352e:	0c1010ef          	jal	4dee <open>
      if (fd >= 0) {
    3532:	02055163          	bgez	a0,3554 <forkforkfork+0x98>
      if (fork() < 0) {
    3536:	071010ef          	jal	4da6 <fork>
    353a:	fe0558e3          	bgez	a0,352a <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE | O_RDWR));
    353e:	20200593          	li	a1,514
    3542:	00004517          	auipc	a0,0x4
    3546:	8a650513          	addi	a0,a0,-1882 # 6de8 <malloc+0x1b3e>
    354a:	0a5010ef          	jal	4dee <open>
    354e:	089010ef          	jal	4dd6 <close>
    3552:	bfe1                	j	352a <forkforkfork+0x6e>
        exit(0);
    3554:	4501                	li	a0,0
    3556:	059010ef          	jal	4dae <exit>

000000000000355a <exectest>:
{
    355a:	711d                	addi	sp,sp,-96
    355c:	ec86                	sd	ra,88(sp)
    355e:	e8a2                	sd	s0,80(sp)
    3560:	e0ca                	sd	s2,64(sp)
    3562:	1080                	addi	s0,sp,96
    3564:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    3566:	00002797          	auipc	a5,0x2
    356a:	e8278793          	addi	a5,a5,-382 # 53e8 <malloc+0x13e>
    356e:	faf43823          	sd	a5,-80(s0)
    3572:	00004797          	auipc	a5,0x4
    3576:	88678793          	addi	a5,a5,-1914 # 6df8 <malloc+0x1b4e>
    357a:	faf43c23          	sd	a5,-72(s0)
    357e:	fc043023          	sd	zero,-64(s0)
  unlink("echo-ok");
    3582:	00004517          	auipc	a0,0x4
    3586:	87e50513          	addi	a0,a0,-1922 # 6e00 <malloc+0x1b56>
    358a:	075010ef          	jal	4dfe <unlink>
  pid = fork();
    358e:	019010ef          	jal	4da6 <fork>
  if (pid < 0) {
    3592:	04054763          	bltz	a0,35e0 <exectest+0x86>
    3596:	e4a6                	sd	s1,72(sp)
    3598:	fc4e                	sd	s3,56(sp)
    359a:	84aa                	mv	s1,a0
  if (pid == 0) {
    359c:	ed49                	bnez	a0,3636 <exectest+0xdc>
    int errfd = dup(1);
    359e:	4505                	li	a0,1
    35a0:	087010ef          	jal	4e26 <dup>
    35a4:	89aa                	mv	s3,a0
    if (errfd < 0) {
    35a6:	04054963          	bltz	a0,35f8 <exectest+0x9e>
    close(1);
    35aa:	4505                	li	a0,1
    35ac:	02b010ef          	jal	4dd6 <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    35b0:	20100593          	li	a1,513
    35b4:	00004517          	auipc	a0,0x4
    35b8:	84c50513          	addi	a0,a0,-1972 # 6e00 <malloc+0x1b56>
    35bc:	033010ef          	jal	4dee <open>
    if (fd < 0) {
    35c0:	04054663          	bltz	a0,360c <exectest+0xb2>
    if (fd != 1) {
    35c4:	4785                	li	a5,1
    35c6:	04f50e63          	beq	a0,a5,3622 <exectest+0xc8>
      fprintf(errfd, "%s: wrong fd\n", s);
    35ca:	864a                	mv	a2,s2
    35cc:	00004597          	auipc	a1,0x4
    35d0:	84c58593          	addi	a1,a1,-1972 # 6e18 <malloc+0x1b6e>
    35d4:	854e                	mv	a0,s3
    35d6:	3f7010ef          	jal	51cc <fprintf>
      exit(1);
    35da:	4505                	li	a0,1
    35dc:	7d2010ef          	jal	4dae <exit>
    35e0:	e4a6                	sd	s1,72(sp)
    35e2:	fc4e                	sd	s3,56(sp)
    printf("%s: fork failed\n", s);
    35e4:	85ca                	mv	a1,s2
    35e6:	00002517          	auipc	a0,0x2
    35ea:	69250513          	addi	a0,a0,1682 # 5c78 <malloc+0x9ce>
    35ee:	409010ef          	jal	51f6 <printf>
    exit(1);
    35f2:	4505                	li	a0,1
    35f4:	7ba010ef          	jal	4dae <exit>
      printf("%s: dup failed\n", s);
    35f8:	85ca                	mv	a1,s2
    35fa:	00004517          	auipc	a0,0x4
    35fe:	80e50513          	addi	a0,a0,-2034 # 6e08 <malloc+0x1b5e>
    3602:	3f5010ef          	jal	51f6 <printf>
      exit(1);
    3606:	4505                	li	a0,1
    3608:	7a6010ef          	jal	4dae <exit>
      fprintf(errfd, "%s: create failed\n", s);
    360c:	864a                	mv	a2,s2
    360e:	00002597          	auipc	a1,0x2
    3612:	7da58593          	addi	a1,a1,2010 # 5de8 <malloc+0xb3e>
    3616:	854e                	mv	a0,s3
    3618:	3b5010ef          	jal	51cc <fprintf>
      exit(1);
    361c:	4505                	li	a0,1
    361e:	790010ef          	jal	4dae <exit>
    if (exec("echo", echoargv) < 0) {
    3622:	fb040593          	addi	a1,s0,-80
    3626:	00002517          	auipc	a0,0x2
    362a:	dc250513          	addi	a0,a0,-574 # 53e8 <malloc+0x13e>
    362e:	7b8010ef          	jal	4de6 <exec>
    3632:	02054563          	bltz	a0,365c <exectest+0x102>
  if (wait(&xstatus) != pid) {
    3636:	fcc40513          	addi	a0,s0,-52
    363a:	77c010ef          	jal	4db6 <wait>
    363e:	02951a63          	bne	a0,s1,3672 <exectest+0x118>
  if (xstatus != 0) {
    3642:	fcc42603          	lw	a2,-52(s0)
    3646:	ce15                	beqz	a2,3682 <exectest+0x128>
    printf("%s: nonzero wait status %d\n", s, xstatus);
    3648:	85ca                	mv	a1,s2
    364a:	00004517          	auipc	a0,0x4
    364e:	80e50513          	addi	a0,a0,-2034 # 6e58 <malloc+0x1bae>
    3652:	3a5010ef          	jal	51f6 <printf>
    exit(1);
    3656:	4505                	li	a0,1
    3658:	756010ef          	jal	4dae <exit>
      fprintf(errfd, "%s: exec echo failed\n", s);
    365c:	864a                	mv	a2,s2
    365e:	00003597          	auipc	a1,0x3
    3662:	7ca58593          	addi	a1,a1,1994 # 6e28 <malloc+0x1b7e>
    3666:	854e                	mv	a0,s3
    3668:	365010ef          	jal	51cc <fprintf>
      exit(1);
    366c:	4505                	li	a0,1
    366e:	740010ef          	jal	4dae <exit>
    printf("%s: wait failed!\n", s);
    3672:	85ca                	mv	a1,s2
    3674:	00003517          	auipc	a0,0x3
    3678:	7cc50513          	addi	a0,a0,1996 # 6e40 <malloc+0x1b96>
    367c:	37b010ef          	jal	51f6 <printf>
    3680:	b7c9                	j	3642 <exectest+0xe8>
  fd = open("echo-ok", O_RDONLY);
    3682:	4581                	li	a1,0
    3684:	00003517          	auipc	a0,0x3
    3688:	77c50513          	addi	a0,a0,1916 # 6e00 <malloc+0x1b56>
    368c:	762010ef          	jal	4dee <open>
  if (fd < 0) {
    3690:	02054463          	bltz	a0,36b8 <exectest+0x15e>
  if (read(fd, buf, 2) != 2) {
    3694:	4609                	li	a2,2
    3696:	fa840593          	addi	a1,s0,-88
    369a:	72c010ef          	jal	4dc6 <read>
    369e:	4789                	li	a5,2
    36a0:	02f50663          	beq	a0,a5,36cc <exectest+0x172>
    printf("%s: read failed\n", s);
    36a4:	85ca                	mv	a1,s2
    36a6:	00002517          	auipc	a0,0x2
    36aa:	11250513          	addi	a0,a0,274 # 57b8 <malloc+0x50e>
    36ae:	349010ef          	jal	51f6 <printf>
    exit(1);
    36b2:	4505                	li	a0,1
    36b4:	6fa010ef          	jal	4dae <exit>
    printf("%s: open failed\n", s);
    36b8:	85ca                	mv	a1,s2
    36ba:	00002517          	auipc	a0,0x2
    36be:	5d650513          	addi	a0,a0,1494 # 5c90 <malloc+0x9e6>
    36c2:	335010ef          	jal	51f6 <printf>
    exit(1);
    36c6:	4505                	li	a0,1
    36c8:	6e6010ef          	jal	4dae <exit>
  unlink("echo-ok");
    36cc:	00003517          	auipc	a0,0x3
    36d0:	73450513          	addi	a0,a0,1844 # 6e00 <malloc+0x1b56>
    36d4:	72a010ef          	jal	4dfe <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    36d8:	fa844703          	lbu	a4,-88(s0)
    36dc:	04f00793          	li	a5,79
    36e0:	00f71863          	bne	a4,a5,36f0 <exectest+0x196>
    36e4:	fa944703          	lbu	a4,-87(s0)
    36e8:	04b00793          	li	a5,75
    36ec:	00f70c63          	beq	a4,a5,3704 <exectest+0x1aa>
    printf("%s: wrong output\n", s);
    36f0:	85ca                	mv	a1,s2
    36f2:	00003517          	auipc	a0,0x3
    36f6:	78650513          	addi	a0,a0,1926 # 6e78 <malloc+0x1bce>
    36fa:	2fd010ef          	jal	51f6 <printf>
    exit(1);
    36fe:	4505                	li	a0,1
    3700:	6ae010ef          	jal	4dae <exit>
    exit(0);
    3704:	4501                	li	a0,0
    3706:	6a8010ef          	jal	4dae <exit>

000000000000370a <killstatus>:
{
    370a:	7139                	addi	sp,sp,-64
    370c:	fc06                	sd	ra,56(sp)
    370e:	f822                	sd	s0,48(sp)
    3710:	f426                	sd	s1,40(sp)
    3712:	f04a                	sd	s2,32(sp)
    3714:	ec4e                	sd	s3,24(sp)
    3716:	e852                	sd	s4,16(sp)
    3718:	0080                	addi	s0,sp,64
    371a:	8a2a                	mv	s4,a0
    371c:	06400913          	li	s2,100
    if (xst != -1) {
    3720:	59fd                	li	s3,-1
    int pid1 = fork();
    3722:	684010ef          	jal	4da6 <fork>
    3726:	84aa                	mv	s1,a0
    if (pid1 < 0) {
    3728:	02054763          	bltz	a0,3756 <killstatus+0x4c>
    if (pid1 == 0) {
    372c:	cd1d                	beqz	a0,376a <killstatus+0x60>
    pause(1);
    372e:	4505                	li	a0,1
    3730:	70e010ef          	jal	4e3e <pause>
    kill(pid1);
    3734:	8526                	mv	a0,s1
    3736:	6a8010ef          	jal	4dde <kill>
    wait(&xst);
    373a:	fcc40513          	addi	a0,s0,-52
    373e:	678010ef          	jal	4db6 <wait>
    if (xst != -1) {
    3742:	fcc42783          	lw	a5,-52(s0)
    3746:	03379563          	bne	a5,s3,3770 <killstatus+0x66>
  for (int i = 0; i < 100; i++) {
    374a:	397d                	addiw	s2,s2,-1
    374c:	fc091be3          	bnez	s2,3722 <killstatus+0x18>
  exit(0);
    3750:	4501                	li	a0,0
    3752:	65c010ef          	jal	4dae <exit>
      printf("%s: fork failed\n", s);
    3756:	85d2                	mv	a1,s4
    3758:	00002517          	auipc	a0,0x2
    375c:	52050513          	addi	a0,a0,1312 # 5c78 <malloc+0x9ce>
    3760:	297010ef          	jal	51f6 <printf>
      exit(1);
    3764:	4505                	li	a0,1
    3766:	648010ef          	jal	4dae <exit>
        getpid();
    376a:	6c4010ef          	jal	4e2e <getpid>
      while (1) {
    376e:	bff5                	j	376a <killstatus+0x60>
      printf("%s: status should be -1\n", s);
    3770:	85d2                	mv	a1,s4
    3772:	00003517          	auipc	a0,0x3
    3776:	71e50513          	addi	a0,a0,1822 # 6e90 <malloc+0x1be6>
    377a:	27d010ef          	jal	51f6 <printf>
      exit(1);
    377e:	4505                	li	a0,1
    3780:	62e010ef          	jal	4dae <exit>

0000000000003784 <preempt>:
{
    3784:	7139                	addi	sp,sp,-64
    3786:	fc06                	sd	ra,56(sp)
    3788:	f822                	sd	s0,48(sp)
    378a:	f426                	sd	s1,40(sp)
    378c:	f04a                	sd	s2,32(sp)
    378e:	ec4e                	sd	s3,24(sp)
    3790:	e852                	sd	s4,16(sp)
    3792:	0080                	addi	s0,sp,64
    3794:	892a                	mv	s2,a0
  pid1 = fork();
    3796:	610010ef          	jal	4da6 <fork>
  if (pid1 < 0) {
    379a:	00054563          	bltz	a0,37a4 <preempt+0x20>
    379e:	84aa                	mv	s1,a0
  if (pid1 == 0)
    37a0:	ed01                	bnez	a0,37b8 <preempt+0x34>
    for (;;)
    37a2:	a001                	j	37a2 <preempt+0x1e>
    printf("%s: fork failed", s);
    37a4:	85ca                	mv	a1,s2
    37a6:	00002517          	auipc	a0,0x2
    37aa:	61250513          	addi	a0,a0,1554 # 5db8 <malloc+0xb0e>
    37ae:	249010ef          	jal	51f6 <printf>
    exit(1);
    37b2:	4505                	li	a0,1
    37b4:	5fa010ef          	jal	4dae <exit>
  pid2 = fork();
    37b8:	5ee010ef          	jal	4da6 <fork>
    37bc:	89aa                	mv	s3,a0
  if (pid2 < 0) {
    37be:	00054463          	bltz	a0,37c6 <preempt+0x42>
  if (pid2 == 0)
    37c2:	ed01                	bnez	a0,37da <preempt+0x56>
    for (;;)
    37c4:	a001                	j	37c4 <preempt+0x40>
    printf("%s: fork failed\n", s);
    37c6:	85ca                	mv	a1,s2
    37c8:	00002517          	auipc	a0,0x2
    37cc:	4b050513          	addi	a0,a0,1200 # 5c78 <malloc+0x9ce>
    37d0:	227010ef          	jal	51f6 <printf>
    exit(1);
    37d4:	4505                	li	a0,1
    37d6:	5d8010ef          	jal	4dae <exit>
  pipe(pfds);
    37da:	fc840513          	addi	a0,s0,-56
    37de:	5e0010ef          	jal	4dbe <pipe>
  pid3 = fork();
    37e2:	5c4010ef          	jal	4da6 <fork>
    37e6:	8a2a                	mv	s4,a0
  if (pid3 < 0) {
    37e8:	02054863          	bltz	a0,3818 <preempt+0x94>
  if (pid3 == 0) {
    37ec:	e921                	bnez	a0,383c <preempt+0xb8>
    close(pfds[0]);
    37ee:	fc842503          	lw	a0,-56(s0)
    37f2:	5e4010ef          	jal	4dd6 <close>
    if (write(pfds[1], "x", 1) != 1)
    37f6:	4605                	li	a2,1
    37f8:	00002597          	auipc	a1,0x2
    37fc:	c6058593          	addi	a1,a1,-928 # 5458 <malloc+0x1ae>
    3800:	fcc42503          	lw	a0,-52(s0)
    3804:	5ca010ef          	jal	4dce <write>
    3808:	4785                	li	a5,1
    380a:	02f51163          	bne	a0,a5,382c <preempt+0xa8>
    close(pfds[1]);
    380e:	fcc42503          	lw	a0,-52(s0)
    3812:	5c4010ef          	jal	4dd6 <close>
    for (;;)
    3816:	a001                	j	3816 <preempt+0x92>
    printf("%s: fork failed\n", s);
    3818:	85ca                	mv	a1,s2
    381a:	00002517          	auipc	a0,0x2
    381e:	45e50513          	addi	a0,a0,1118 # 5c78 <malloc+0x9ce>
    3822:	1d5010ef          	jal	51f6 <printf>
    exit(1);
    3826:	4505                	li	a0,1
    3828:	586010ef          	jal	4dae <exit>
      printf("%s: preempt write error", s);
    382c:	85ca                	mv	a1,s2
    382e:	00003517          	auipc	a0,0x3
    3832:	68250513          	addi	a0,a0,1666 # 6eb0 <malloc+0x1c06>
    3836:	1c1010ef          	jal	51f6 <printf>
    383a:	bfd1                	j	380e <preempt+0x8a>
  close(pfds[1]);
    383c:	fcc42503          	lw	a0,-52(s0)
    3840:	596010ef          	jal	4dd6 <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1) {
    3844:	660d                	lui	a2,0x3
    3846:	00009597          	auipc	a1,0x9
    384a:	47258593          	addi	a1,a1,1138 # ccb8 <buf>
    384e:	fc842503          	lw	a0,-56(s0)
    3852:	574010ef          	jal	4dc6 <read>
    3856:	4785                	li	a5,1
    3858:	02f50163          	beq	a0,a5,387a <preempt+0xf6>
    printf("%s: preempt read error", s);
    385c:	85ca                	mv	a1,s2
    385e:	00003517          	auipc	a0,0x3
    3862:	66a50513          	addi	a0,a0,1642 # 6ec8 <malloc+0x1c1e>
    3866:	191010ef          	jal	51f6 <printf>
}
    386a:	70e2                	ld	ra,56(sp)
    386c:	7442                	ld	s0,48(sp)
    386e:	74a2                	ld	s1,40(sp)
    3870:	7902                	ld	s2,32(sp)
    3872:	69e2                	ld	s3,24(sp)
    3874:	6a42                	ld	s4,16(sp)
    3876:	6121                	addi	sp,sp,64
    3878:	8082                	ret
  close(pfds[0]);
    387a:	fc842503          	lw	a0,-56(s0)
    387e:	558010ef          	jal	4dd6 <close>
  printf("kill... ");
    3882:	00003517          	auipc	a0,0x3
    3886:	65e50513          	addi	a0,a0,1630 # 6ee0 <malloc+0x1c36>
    388a:	16d010ef          	jal	51f6 <printf>
  kill(pid1);
    388e:	8526                	mv	a0,s1
    3890:	54e010ef          	jal	4dde <kill>
  kill(pid2);
    3894:	854e                	mv	a0,s3
    3896:	548010ef          	jal	4dde <kill>
  kill(pid3);
    389a:	8552                	mv	a0,s4
    389c:	542010ef          	jal	4dde <kill>
  printf("wait... ");
    38a0:	00003517          	auipc	a0,0x3
    38a4:	65050513          	addi	a0,a0,1616 # 6ef0 <malloc+0x1c46>
    38a8:	14f010ef          	jal	51f6 <printf>
  wait(0);
    38ac:	4501                	li	a0,0
    38ae:	508010ef          	jal	4db6 <wait>
  wait(0);
    38b2:	4501                	li	a0,0
    38b4:	502010ef          	jal	4db6 <wait>
  wait(0);
    38b8:	4501                	li	a0,0
    38ba:	4fc010ef          	jal	4db6 <wait>
    38be:	b775                	j	386a <preempt+0xe6>

00000000000038c0 <reparent>:
{
    38c0:	7179                	addi	sp,sp,-48
    38c2:	f406                	sd	ra,40(sp)
    38c4:	f022                	sd	s0,32(sp)
    38c6:	ec26                	sd	s1,24(sp)
    38c8:	e84a                	sd	s2,16(sp)
    38ca:	e44e                	sd	s3,8(sp)
    38cc:	e052                	sd	s4,0(sp)
    38ce:	1800                	addi	s0,sp,48
    38d0:	89aa                	mv	s3,a0
  int master_pid = getpid();
    38d2:	55c010ef          	jal	4e2e <getpid>
    38d6:	8a2a                	mv	s4,a0
    38d8:	0c800913          	li	s2,200
    int pid = fork();
    38dc:	4ca010ef          	jal	4da6 <fork>
    38e0:	84aa                	mv	s1,a0
    if (pid < 0) {
    38e2:	00054e63          	bltz	a0,38fe <reparent+0x3e>
    if (pid) {
    38e6:	c121                	beqz	a0,3926 <reparent+0x66>
      if (wait(0) != pid) {
    38e8:	4501                	li	a0,0
    38ea:	4cc010ef          	jal	4db6 <wait>
    38ee:	02951263          	bne	a0,s1,3912 <reparent+0x52>
  for (int i = 0; i < 200; i++) {
    38f2:	397d                	addiw	s2,s2,-1
    38f4:	fe0914e3          	bnez	s2,38dc <reparent+0x1c>
  exit(0);
    38f8:	4501                	li	a0,0
    38fa:	4b4010ef          	jal	4dae <exit>
      printf("%s: fork failed\n", s);
    38fe:	85ce                	mv	a1,s3
    3900:	00002517          	auipc	a0,0x2
    3904:	37850513          	addi	a0,a0,888 # 5c78 <malloc+0x9ce>
    3908:	0ef010ef          	jal	51f6 <printf>
      exit(1);
    390c:	4505                	li	a0,1
    390e:	4a0010ef          	jal	4dae <exit>
        printf("%s: wait wrong pid\n", s);
    3912:	85ce                	mv	a1,s3
    3914:	00002517          	auipc	a0,0x2
    3918:	46c50513          	addi	a0,a0,1132 # 5d80 <malloc+0xad6>
    391c:	0db010ef          	jal	51f6 <printf>
        exit(1);
    3920:	4505                	li	a0,1
    3922:	48c010ef          	jal	4dae <exit>
      int pid2 = fork();
    3926:	480010ef          	jal	4da6 <fork>
      if (pid2 < 0) {
    392a:	00054563          	bltz	a0,3934 <reparent+0x74>
      exit(0);
    392e:	4501                	li	a0,0
    3930:	47e010ef          	jal	4dae <exit>
        kill(master_pid);
    3934:	8552                	mv	a0,s4
    3936:	4a8010ef          	jal	4dde <kill>
        exit(1);
    393a:	4505                	li	a0,1
    393c:	472010ef          	jal	4dae <exit>

0000000000003940 <sbrkfail>:
{
    3940:	7175                	addi	sp,sp,-144
    3942:	e506                	sd	ra,136(sp)
    3944:	e122                	sd	s0,128(sp)
    3946:	fca6                	sd	s1,120(sp)
    3948:	f8ca                	sd	s2,112(sp)
    394a:	f4ce                	sd	s3,104(sp)
    394c:	f0d2                	sd	s4,96(sp)
    394e:	ecd6                	sd	s5,88(sp)
    3950:	e8da                	sd	s6,80(sp)
    3952:	e4de                	sd	s7,72(sp)
    3954:	0900                	addi	s0,sp,144
    3956:	8b2a                	mv	s6,a0
  if (pipe(fds) != 0) {
    3958:	fa040513          	addi	a0,s0,-96
    395c:	462010ef          	jal	4dbe <pipe>
    3960:	e919                	bnez	a0,3976 <sbrkfail+0x36>
    3962:	8aaa                	mv	s5,a0
    3964:	f7040493          	addi	s1,s0,-144
    3968:	f9840993          	addi	s3,s0,-104
    396c:	8926                	mv	s2,s1
    if (pids[i] != -1) {
    396e:	5a7d                	li	s4,-1
      if (scratch == '0')
    3970:	03000b93          	li	s7,48
    3974:	a08d                	j	39d6 <sbrkfail+0x96>
    printf("%s: pipe() failed\n", s);
    3976:	85da                	mv	a1,s6
    3978:	00002517          	auipc	a0,0x2
    397c:	38850513          	addi	a0,a0,904 # 5d00 <malloc+0xa56>
    3980:	077010ef          	jal	51f6 <printf>
    exit(1);
    3984:	4505                	li	a0,1
    3986:	428010ef          	jal	4dae <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) == (char *)SBRK_ERROR)
    398a:	3f0010ef          	jal	4d7a <sbrk>
    398e:	064007b7          	lui	a5,0x6400
    3992:	40a7853b          	subw	a0,a5,a0
    3996:	3e4010ef          	jal	4d7a <sbrk>
    399a:	57fd                	li	a5,-1
    399c:	02f50063          	beq	a0,a5,39bc <sbrkfail+0x7c>
        write(fds[1], "1", 1);
    39a0:	4605                	li	a2,1
    39a2:	00004597          	auipc	a1,0x4
    39a6:	cd658593          	addi	a1,a1,-810 # 7678 <malloc+0x23ce>
    39aa:	fa442503          	lw	a0,-92(s0)
    39ae:	420010ef          	jal	4dce <write>
        pause(1000);
    39b2:	3e800513          	li	a0,1000
    39b6:	488010ef          	jal	4e3e <pause>
      for (;;)
    39ba:	bfe5                	j	39b2 <sbrkfail+0x72>
        write(fds[1], "0", 1);
    39bc:	4605                	li	a2,1
    39be:	00003597          	auipc	a1,0x3
    39c2:	54258593          	addi	a1,a1,1346 # 6f00 <malloc+0x1c56>
    39c6:	fa442503          	lw	a0,-92(s0)
    39ca:	404010ef          	jal	4dce <write>
    39ce:	b7d5                	j	39b2 <sbrkfail+0x72>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    39d0:	0911                	addi	s2,s2,4
    39d2:	03390663          	beq	s2,s3,39fe <sbrkfail+0xbe>
    if ((pids[i] = fork()) == 0) {
    39d6:	3d0010ef          	jal	4da6 <fork>
    39da:	00a92023          	sw	a0,0(s2)
    39de:	d555                	beqz	a0,398a <sbrkfail+0x4a>
    if (pids[i] != -1) {
    39e0:	ff4508e3          	beq	a0,s4,39d0 <sbrkfail+0x90>
      read(fds[0], &scratch, 1);
    39e4:	4605                	li	a2,1
    39e6:	f9f40593          	addi	a1,s0,-97
    39ea:	fa042503          	lw	a0,-96(s0)
    39ee:	3d8010ef          	jal	4dc6 <read>
      if (scratch == '0')
    39f2:	f9f44783          	lbu	a5,-97(s0)
    39f6:	fd779de3          	bne	a5,s7,39d0 <sbrkfail+0x90>
        failed = 1;
    39fa:	4a85                	li	s5,1
    39fc:	bfd1                	j	39d0 <sbrkfail+0x90>
  if (!failed) {
    39fe:	000a8863          	beqz	s5,3a0e <sbrkfail+0xce>
  c = sbrk(PGSIZE);
    3a02:	6505                	lui	a0,0x1
    3a04:	376010ef          	jal	4d7a <sbrk>
    3a08:	8a2a                	mv	s4,a0
    if (pids[i] == -1)
    3a0a:	597d                	li	s2,-1
    3a0c:	a821                	j	3a24 <sbrkfail+0xe4>
    printf("%s: no allocation failed; allocate more?\n", s);
    3a0e:	85da                	mv	a1,s6
    3a10:	00003517          	auipc	a0,0x3
    3a14:	4f850513          	addi	a0,a0,1272 # 6f08 <malloc+0x1c5e>
    3a18:	7de010ef          	jal	51f6 <printf>
    3a1c:	b7dd                	j	3a02 <sbrkfail+0xc2>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3a1e:	0491                	addi	s1,s1,4
    3a20:	01348b63          	beq	s1,s3,3a36 <sbrkfail+0xf6>
    if (pids[i] == -1)
    3a24:	4088                	lw	a0,0(s1)
    3a26:	ff250ce3          	beq	a0,s2,3a1e <sbrkfail+0xde>
    kill(pids[i]);
    3a2a:	3b4010ef          	jal	4dde <kill>
    wait(0);
    3a2e:	4501                	li	a0,0
    3a30:	386010ef          	jal	4db6 <wait>
    3a34:	b7ed                	j	3a1e <sbrkfail+0xde>
  if (c == (char *)SBRK_ERROR) {
    3a36:	57fd                	li	a5,-1
    3a38:	02fa0a63          	beq	s4,a5,3a6c <sbrkfail+0x12c>
  pid = fork();
    3a3c:	36a010ef          	jal	4da6 <fork>
  if (pid < 0) {
    3a40:	04054063          	bltz	a0,3a80 <sbrkfail+0x140>
  if (pid == 0) {
    3a44:	e939                	bnez	a0,3a9a <sbrkfail+0x15a>
    a = sbrk(10 * BIG);
    3a46:	3e800537          	lui	a0,0x3e800
    3a4a:	330010ef          	jal	4d7a <sbrk>
    if (a == (char *)SBRK_ERROR) {
    3a4e:	57fd                	li	a5,-1
    3a50:	04f50263          	beq	a0,a5,3a94 <sbrkfail+0x154>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10 * BIG);
    3a54:	3e800637          	lui	a2,0x3e800
    3a58:	85da                	mv	a1,s6
    3a5a:	00003517          	auipc	a0,0x3
    3a5e:	4fe50513          	addi	a0,a0,1278 # 6f58 <malloc+0x1cae>
    3a62:	794010ef          	jal	51f6 <printf>
    exit(1);
    3a66:	4505                	li	a0,1
    3a68:	346010ef          	jal	4dae <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3a6c:	85da                	mv	a1,s6
    3a6e:	00003517          	auipc	a0,0x3
    3a72:	4ca50513          	addi	a0,a0,1226 # 6f38 <malloc+0x1c8e>
    3a76:	780010ef          	jal	51f6 <printf>
    exit(1);
    3a7a:	4505                	li	a0,1
    3a7c:	332010ef          	jal	4dae <exit>
    printf("%s: fork failed\n", s);
    3a80:	85da                	mv	a1,s6
    3a82:	00002517          	auipc	a0,0x2
    3a86:	1f650513          	addi	a0,a0,502 # 5c78 <malloc+0x9ce>
    3a8a:	76c010ef          	jal	51f6 <printf>
    exit(1);
    3a8e:	4505                	li	a0,1
    3a90:	31e010ef          	jal	4dae <exit>
      exit(0);
    3a94:	4501                	li	a0,0
    3a96:	318010ef          	jal	4dae <exit>
  wait(&xstatus);
    3a9a:	fac40513          	addi	a0,s0,-84
    3a9e:	318010ef          	jal	4db6 <wait>
  if (xstatus != 0)
    3aa2:	fac42783          	lw	a5,-84(s0)
    3aa6:	ef81                	bnez	a5,3abe <sbrkfail+0x17e>
}
    3aa8:	60aa                	ld	ra,136(sp)
    3aaa:	640a                	ld	s0,128(sp)
    3aac:	74e6                	ld	s1,120(sp)
    3aae:	7946                	ld	s2,112(sp)
    3ab0:	79a6                	ld	s3,104(sp)
    3ab2:	7a06                	ld	s4,96(sp)
    3ab4:	6ae6                	ld	s5,88(sp)
    3ab6:	6b46                	ld	s6,80(sp)
    3ab8:	6ba6                	ld	s7,72(sp)
    3aba:	6149                	addi	sp,sp,144
    3abc:	8082                	ret
    exit(1);
    3abe:	4505                	li	a0,1
    3ac0:	2ee010ef          	jal	4dae <exit>

0000000000003ac4 <mem>:
{
    3ac4:	7139                	addi	sp,sp,-64
    3ac6:	fc06                	sd	ra,56(sp)
    3ac8:	f822                	sd	s0,48(sp)
    3aca:	f426                	sd	s1,40(sp)
    3acc:	f04a                	sd	s2,32(sp)
    3ace:	ec4e                	sd	s3,24(sp)
    3ad0:	0080                	addi	s0,sp,64
    3ad2:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0) {
    3ad4:	2d2010ef          	jal	4da6 <fork>
    m1 = 0;
    3ad8:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0) {
    3ada:	6909                	lui	s2,0x2
    3adc:	71190913          	addi	s2,s2,1809 # 2711 <diskfull+0xd1>
  if ((pid = fork()) == 0) {
    3ae0:	cd11                	beqz	a0,3afc <mem+0x38>
    wait(&xstatus);
    3ae2:	fcc40513          	addi	a0,s0,-52
    3ae6:	2d0010ef          	jal	4db6 <wait>
    if (xstatus == -1) {
    3aea:	fcc42503          	lw	a0,-52(s0)
    3aee:	57fd                	li	a5,-1
    3af0:	04f50363          	beq	a0,a5,3b36 <mem+0x72>
    exit(xstatus);
    3af4:	2ba010ef          	jal	4dae <exit>
      *(char **)m2 = m1;
    3af8:	e104                	sd	s1,0(a0)
      m1 = m2;
    3afa:	84aa                	mv	s1,a0
    while ((m2 = malloc(10001)) != 0) {
    3afc:	854a                	mv	a0,s2
    3afe:	7ac010ef          	jal	52aa <malloc>
    3b02:	f97d                	bnez	a0,3af8 <mem+0x34>
    while (m1) {
    3b04:	c491                	beqz	s1,3b10 <mem+0x4c>
      m2 = *(char **)m1;
    3b06:	8526                	mv	a0,s1
    3b08:	6084                	ld	s1,0(s1)
      free(m1);
    3b0a:	71e010ef          	jal	5228 <free>
    while (m1) {
    3b0e:	fce5                	bnez	s1,3b06 <mem+0x42>
    m1 = malloc(1024 * 20);
    3b10:	6515                	lui	a0,0x5
    3b12:	798010ef          	jal	52aa <malloc>
    if (m1 == 0) {
    3b16:	c511                	beqz	a0,3b22 <mem+0x5e>
    free(m1);
    3b18:	710010ef          	jal	5228 <free>
    exit(0);
    3b1c:	4501                	li	a0,0
    3b1e:	290010ef          	jal	4dae <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3b22:	85ce                	mv	a1,s3
    3b24:	00003517          	auipc	a0,0x3
    3b28:	46450513          	addi	a0,a0,1124 # 6f88 <malloc+0x1cde>
    3b2c:	6ca010ef          	jal	51f6 <printf>
      exit(1);
    3b30:	4505                	li	a0,1
    3b32:	27c010ef          	jal	4dae <exit>
      exit(0);
    3b36:	4501                	li	a0,0
    3b38:	276010ef          	jal	4dae <exit>

0000000000003b3c <sharedfd>:
{
    3b3c:	7159                	addi	sp,sp,-112
    3b3e:	f486                	sd	ra,104(sp)
    3b40:	f0a2                	sd	s0,96(sp)
    3b42:	e0d2                	sd	s4,64(sp)
    3b44:	1880                	addi	s0,sp,112
    3b46:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3b48:	00003517          	auipc	a0,0x3
    3b4c:	46050513          	addi	a0,a0,1120 # 6fa8 <malloc+0x1cfe>
    3b50:	2ae010ef          	jal	4dfe <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    3b54:	20200593          	li	a1,514
    3b58:	00003517          	auipc	a0,0x3
    3b5c:	45050513          	addi	a0,a0,1104 # 6fa8 <malloc+0x1cfe>
    3b60:	28e010ef          	jal	4dee <open>
  if (fd < 0) {
    3b64:	04054863          	bltz	a0,3bb4 <sharedfd+0x78>
    3b68:	eca6                	sd	s1,88(sp)
    3b6a:	e8ca                	sd	s2,80(sp)
    3b6c:	e4ce                	sd	s3,72(sp)
    3b6e:	fc56                	sd	s5,56(sp)
    3b70:	f85a                	sd	s6,48(sp)
    3b72:	f45e                	sd	s7,40(sp)
    3b74:	892a                	mv	s2,a0
  pid = fork();
    3b76:	230010ef          	jal	4da6 <fork>
    3b7a:	89aa                	mv	s3,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    3b7c:	07000593          	li	a1,112
    3b80:	e119                	bnez	a0,3b86 <sharedfd+0x4a>
    3b82:	06300593          	li	a1,99
    3b86:	4629                	li	a2,10
    3b88:	fa040513          	addi	a0,s0,-96
    3b8c:	010010ef          	jal	4b9c <memset>
    3b90:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
    3b94:	4629                	li	a2,10
    3b96:	fa040593          	addi	a1,s0,-96
    3b9a:	854a                	mv	a0,s2
    3b9c:	232010ef          	jal	4dce <write>
    3ba0:	47a9                	li	a5,10
    3ba2:	02f51963          	bne	a0,a5,3bd4 <sharedfd+0x98>
  for (i = 0; i < N; i++) {
    3ba6:	34fd                	addiw	s1,s1,-1
    3ba8:	f4f5                	bnez	s1,3b94 <sharedfd+0x58>
  if (pid == 0) {
    3baa:	02099f63          	bnez	s3,3be8 <sharedfd+0xac>
    exit(0);
    3bae:	4501                	li	a0,0
    3bb0:	1fe010ef          	jal	4dae <exit>
    3bb4:	eca6                	sd	s1,88(sp)
    3bb6:	e8ca                	sd	s2,80(sp)
    3bb8:	e4ce                	sd	s3,72(sp)
    3bba:	fc56                	sd	s5,56(sp)
    3bbc:	f85a                	sd	s6,48(sp)
    3bbe:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3bc0:	85d2                	mv	a1,s4
    3bc2:	00003517          	auipc	a0,0x3
    3bc6:	3f650513          	addi	a0,a0,1014 # 6fb8 <malloc+0x1d0e>
    3bca:	62c010ef          	jal	51f6 <printf>
    exit(1);
    3bce:	4505                	li	a0,1
    3bd0:	1de010ef          	jal	4dae <exit>
      printf("%s: write sharedfd failed\n", s);
    3bd4:	85d2                	mv	a1,s4
    3bd6:	00003517          	auipc	a0,0x3
    3bda:	40a50513          	addi	a0,a0,1034 # 6fe0 <malloc+0x1d36>
    3bde:	618010ef          	jal	51f6 <printf>
      exit(1);
    3be2:	4505                	li	a0,1
    3be4:	1ca010ef          	jal	4dae <exit>
    wait(&xstatus);
    3be8:	f9c40513          	addi	a0,s0,-100
    3bec:	1ca010ef          	jal	4db6 <wait>
    if (xstatus != 0)
    3bf0:	f9c42983          	lw	s3,-100(s0)
    3bf4:	00098563          	beqz	s3,3bfe <sharedfd+0xc2>
      exit(xstatus);
    3bf8:	854e                	mv	a0,s3
    3bfa:	1b4010ef          	jal	4dae <exit>
  close(fd);
    3bfe:	854a                	mv	a0,s2
    3c00:	1d6010ef          	jal	4dd6 <close>
  fd = open("sharedfd", 0);
    3c04:	4581                	li	a1,0
    3c06:	00003517          	auipc	a0,0x3
    3c0a:	3a250513          	addi	a0,a0,930 # 6fa8 <malloc+0x1cfe>
    3c0e:	1e0010ef          	jal	4dee <open>
    3c12:	8baa                	mv	s7,a0
  nc = np = 0;
    3c14:	8ace                	mv	s5,s3
  if (fd < 0) {
    3c16:	02054363          	bltz	a0,3c3c <sharedfd+0x100>
    3c1a:	faa40913          	addi	s2,s0,-86
      if (buf[i] == 'c')
    3c1e:	06300493          	li	s1,99
      if (buf[i] == 'p')
    3c22:	07000b13          	li	s6,112
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3c26:	4629                	li	a2,10
    3c28:	fa040593          	addi	a1,s0,-96
    3c2c:	855e                	mv	a0,s7
    3c2e:	198010ef          	jal	4dc6 <read>
    3c32:	02a05b63          	blez	a0,3c68 <sharedfd+0x12c>
    3c36:	fa040793          	addi	a5,s0,-96
    3c3a:	a839                	j	3c58 <sharedfd+0x11c>
    printf("%s: cannot open sharedfd for reading\n", s);
    3c3c:	85d2                	mv	a1,s4
    3c3e:	00003517          	auipc	a0,0x3
    3c42:	3c250513          	addi	a0,a0,962 # 7000 <malloc+0x1d56>
    3c46:	5b0010ef          	jal	51f6 <printf>
    exit(1);
    3c4a:	4505                	li	a0,1
    3c4c:	162010ef          	jal	4dae <exit>
        nc++;
    3c50:	2985                	addiw	s3,s3,1
    for (i = 0; i < sizeof(buf); i++) {
    3c52:	0785                	addi	a5,a5,1 # 6400001 <base+0x63f0349>
    3c54:	fd2789e3          	beq	a5,s2,3c26 <sharedfd+0xea>
      if (buf[i] == 'c')
    3c58:	0007c703          	lbu	a4,0(a5)
    3c5c:	fe970ae3          	beq	a4,s1,3c50 <sharedfd+0x114>
      if (buf[i] == 'p')
    3c60:	ff6719e3          	bne	a4,s6,3c52 <sharedfd+0x116>
        np++;
    3c64:	2a85                	addiw	s5,s5,1
    3c66:	b7f5                	j	3c52 <sharedfd+0x116>
  close(fd);
    3c68:	855e                	mv	a0,s7
    3c6a:	16c010ef          	jal	4dd6 <close>
  unlink("sharedfd");
    3c6e:	00003517          	auipc	a0,0x3
    3c72:	33a50513          	addi	a0,a0,826 # 6fa8 <malloc+0x1cfe>
    3c76:	188010ef          	jal	4dfe <unlink>
  if (nc == N * SZ && np == N * SZ) {
    3c7a:	6789                	lui	a5,0x2
    3c7c:	71078793          	addi	a5,a5,1808 # 2710 <diskfull+0xd0>
    3c80:	00f99763          	bne	s3,a5,3c8e <sharedfd+0x152>
    3c84:	6789                	lui	a5,0x2
    3c86:	71078793          	addi	a5,a5,1808 # 2710 <diskfull+0xd0>
    3c8a:	00fa8c63          	beq	s5,a5,3ca2 <sharedfd+0x166>
    printf("%s: nc/np test fails\n", s);
    3c8e:	85d2                	mv	a1,s4
    3c90:	00003517          	auipc	a0,0x3
    3c94:	39850513          	addi	a0,a0,920 # 7028 <malloc+0x1d7e>
    3c98:	55e010ef          	jal	51f6 <printf>
    exit(1);
    3c9c:	4505                	li	a0,1
    3c9e:	110010ef          	jal	4dae <exit>
    exit(0);
    3ca2:	4501                	li	a0,0
    3ca4:	10a010ef          	jal	4dae <exit>

0000000000003ca8 <fourfiles>:
{
    3ca8:	7135                	addi	sp,sp,-160
    3caa:	ed06                	sd	ra,152(sp)
    3cac:	e922                	sd	s0,144(sp)
    3cae:	e526                	sd	s1,136(sp)
    3cb0:	e14a                	sd	s2,128(sp)
    3cb2:	fcce                	sd	s3,120(sp)
    3cb4:	f8d2                	sd	s4,112(sp)
    3cb6:	f4d6                	sd	s5,104(sp)
    3cb8:	f0da                	sd	s6,96(sp)
    3cba:	ecde                	sd	s7,88(sp)
    3cbc:	e8e2                	sd	s8,80(sp)
    3cbe:	e4e6                	sd	s9,72(sp)
    3cc0:	e0ea                	sd	s10,64(sp)
    3cc2:	fc6e                	sd	s11,56(sp)
    3cc4:	1100                	addi	s0,sp,160
    3cc6:	8caa                	mv	s9,a0
  char *names[] = {"f0", "f1", "f2", "f3"};
    3cc8:	00003797          	auipc	a5,0x3
    3ccc:	37878793          	addi	a5,a5,888 # 7040 <malloc+0x1d96>
    3cd0:	f6f43823          	sd	a5,-144(s0)
    3cd4:	00003797          	auipc	a5,0x3
    3cd8:	37478793          	addi	a5,a5,884 # 7048 <malloc+0x1d9e>
    3cdc:	f6f43c23          	sd	a5,-136(s0)
    3ce0:	00003797          	auipc	a5,0x3
    3ce4:	37078793          	addi	a5,a5,880 # 7050 <malloc+0x1da6>
    3ce8:	f8f43023          	sd	a5,-128(s0)
    3cec:	00003797          	auipc	a5,0x3
    3cf0:	36c78793          	addi	a5,a5,876 # 7058 <malloc+0x1dae>
    3cf4:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++) {
    3cf8:	f7040b93          	addi	s7,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    3cfc:	895e                	mv	s2,s7
  for (pi = 0; pi < NCHILD; pi++) {
    3cfe:	4481                	li	s1,0
    3d00:	4a11                	li	s4,4
    fname = names[pi];
    3d02:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3d06:	854e                	mv	a0,s3
    3d08:	0f6010ef          	jal	4dfe <unlink>
    pid = fork();
    3d0c:	09a010ef          	jal	4da6 <fork>
    if (pid < 0) {
    3d10:	02054e63          	bltz	a0,3d4c <fourfiles+0xa4>
    if (pid == 0) {
    3d14:	c531                	beqz	a0,3d60 <fourfiles+0xb8>
  for (pi = 0; pi < NCHILD; pi++) {
    3d16:	2485                	addiw	s1,s1,1
    3d18:	0921                	addi	s2,s2,8
    3d1a:	ff4494e3          	bne	s1,s4,3d02 <fourfiles+0x5a>
    3d1e:	4491                	li	s1,4
    wait(&xstatus);
    3d20:	f6c40513          	addi	a0,s0,-148
    3d24:	092010ef          	jal	4db6 <wait>
    if (xstatus != 0)
    3d28:	f6c42a83          	lw	s5,-148(s0)
    3d2c:	0a0a9463          	bnez	s5,3dd4 <fourfiles+0x12c>
  for (pi = 0; pi < NCHILD; pi++) {
    3d30:	34fd                	addiw	s1,s1,-1
    3d32:	f4fd                	bnez	s1,3d20 <fourfiles+0x78>
    3d34:	03000b13          	li	s6,48
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3d38:	00009a17          	auipc	s4,0x9
    3d3c:	f80a0a13          	addi	s4,s4,-128 # ccb8 <buf>
    if (total != N * SZ) {
    3d40:	6d05                	lui	s10,0x1
    3d42:	770d0d13          	addi	s10,s10,1904 # 1770 <createdelete+0xb6>
  for (i = 0; i < NCHILD; i++) {
    3d46:	03400d93          	li	s11,52
    3d4a:	a0ed                	j	3e34 <fourfiles+0x18c>
      printf("%s: fork failed\n", s);
    3d4c:	85e6                	mv	a1,s9
    3d4e:	00002517          	auipc	a0,0x2
    3d52:	f2a50513          	addi	a0,a0,-214 # 5c78 <malloc+0x9ce>
    3d56:	4a0010ef          	jal	51f6 <printf>
      exit(1);
    3d5a:	4505                	li	a0,1
    3d5c:	052010ef          	jal	4dae <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3d60:	20200593          	li	a1,514
    3d64:	854e                	mv	a0,s3
    3d66:	088010ef          	jal	4dee <open>
    3d6a:	892a                	mv	s2,a0
      if (fd < 0) {
    3d6c:	04054163          	bltz	a0,3dae <fourfiles+0x106>
      memset(buf, '0' + pi, SZ);
    3d70:	1f400613          	li	a2,500
    3d74:	0304859b          	addiw	a1,s1,48
    3d78:	00009517          	auipc	a0,0x9
    3d7c:	f4050513          	addi	a0,a0,-192 # ccb8 <buf>
    3d80:	61d000ef          	jal	4b9c <memset>
    3d84:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ) {
    3d86:	00009997          	auipc	s3,0x9
    3d8a:	f3298993          	addi	s3,s3,-206 # ccb8 <buf>
    3d8e:	1f400613          	li	a2,500
    3d92:	85ce                	mv	a1,s3
    3d94:	854a                	mv	a0,s2
    3d96:	038010ef          	jal	4dce <write>
    3d9a:	85aa                	mv	a1,a0
    3d9c:	1f400793          	li	a5,500
    3da0:	02f51163          	bne	a0,a5,3dc2 <fourfiles+0x11a>
      for (i = 0; i < N; i++) {
    3da4:	34fd                	addiw	s1,s1,-1
    3da6:	f4e5                	bnez	s1,3d8e <fourfiles+0xe6>
      exit(0);
    3da8:	4501                	li	a0,0
    3daa:	004010ef          	jal	4dae <exit>
        printf("%s: create failed\n", s);
    3dae:	85e6                	mv	a1,s9
    3db0:	00002517          	auipc	a0,0x2
    3db4:	03850513          	addi	a0,a0,56 # 5de8 <malloc+0xb3e>
    3db8:	43e010ef          	jal	51f6 <printf>
        exit(1);
    3dbc:	4505                	li	a0,1
    3dbe:	7f1000ef          	jal	4dae <exit>
          printf("write failed %d\n", n);
    3dc2:	00003517          	auipc	a0,0x3
    3dc6:	29e50513          	addi	a0,a0,670 # 7060 <malloc+0x1db6>
    3dca:	42c010ef          	jal	51f6 <printf>
          exit(1);
    3dce:	4505                	li	a0,1
    3dd0:	7df000ef          	jal	4dae <exit>
      exit(xstatus);
    3dd4:	8556                	mv	a0,s5
    3dd6:	7d9000ef          	jal	4dae <exit>
          printf("%s: wrong char\n", s);
    3dda:	85e6                	mv	a1,s9
    3ddc:	00003517          	auipc	a0,0x3
    3de0:	29c50513          	addi	a0,a0,668 # 7078 <malloc+0x1dce>
    3de4:	412010ef          	jal	51f6 <printf>
          exit(1);
    3de8:	4505                	li	a0,1
    3dea:	7c5000ef          	jal	4dae <exit>
      total += n;
    3dee:	00a9093b          	addw	s2,s2,a0
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3df2:	660d                	lui	a2,0x3
    3df4:	85d2                	mv	a1,s4
    3df6:	854e                	mv	a0,s3
    3df8:	7cf000ef          	jal	4dc6 <read>
    3dfc:	02a05063          	blez	a0,3e1c <fourfiles+0x174>
    3e00:	00009797          	auipc	a5,0x9
    3e04:	eb878793          	addi	a5,a5,-328 # ccb8 <buf>
    3e08:	00f506b3          	add	a3,a0,a5
        if (buf[j] != '0' + i) {
    3e0c:	0007c703          	lbu	a4,0(a5)
    3e10:	fc9715e3          	bne	a4,s1,3dda <fourfiles+0x132>
      for (j = 0; j < n; j++) {
    3e14:	0785                	addi	a5,a5,1
    3e16:	fed79be3          	bne	a5,a3,3e0c <fourfiles+0x164>
    3e1a:	bfd1                	j	3dee <fourfiles+0x146>
    close(fd);
    3e1c:	854e                	mv	a0,s3
    3e1e:	7b9000ef          	jal	4dd6 <close>
    if (total != N * SZ) {
    3e22:	03a91463          	bne	s2,s10,3e4a <fourfiles+0x1a2>
    unlink(fname);
    3e26:	8562                	mv	a0,s8
    3e28:	7d7000ef          	jal	4dfe <unlink>
  for (i = 0; i < NCHILD; i++) {
    3e2c:	0ba1                	addi	s7,s7,8
    3e2e:	2b05                	addiw	s6,s6,1
    3e30:	03bb0763          	beq	s6,s11,3e5e <fourfiles+0x1b6>
    fname = names[i];
    3e34:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3e38:	4581                	li	a1,0
    3e3a:	8562                	mv	a0,s8
    3e3c:	7b3000ef          	jal	4dee <open>
    3e40:	89aa                	mv	s3,a0
    total = 0;
    3e42:	8956                	mv	s2,s5
        if (buf[j] != '0' + i) {
    3e44:	000b049b          	sext.w	s1,s6
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3e48:	b76d                	j	3df2 <fourfiles+0x14a>
      printf("wrong length %d\n", total);
    3e4a:	85ca                	mv	a1,s2
    3e4c:	00003517          	auipc	a0,0x3
    3e50:	23c50513          	addi	a0,a0,572 # 7088 <malloc+0x1dde>
    3e54:	3a2010ef          	jal	51f6 <printf>
      exit(1);
    3e58:	4505                	li	a0,1
    3e5a:	755000ef          	jal	4dae <exit>
}
    3e5e:	60ea                	ld	ra,152(sp)
    3e60:	644a                	ld	s0,144(sp)
    3e62:	64aa                	ld	s1,136(sp)
    3e64:	690a                	ld	s2,128(sp)
    3e66:	79e6                	ld	s3,120(sp)
    3e68:	7a46                	ld	s4,112(sp)
    3e6a:	7aa6                	ld	s5,104(sp)
    3e6c:	7b06                	ld	s6,96(sp)
    3e6e:	6be6                	ld	s7,88(sp)
    3e70:	6c46                	ld	s8,80(sp)
    3e72:	6ca6                	ld	s9,72(sp)
    3e74:	6d06                	ld	s10,64(sp)
    3e76:	7de2                	ld	s11,56(sp)
    3e78:	610d                	addi	sp,sp,160
    3e7a:	8082                	ret

0000000000003e7c <concreate>:
{
    3e7c:	7135                	addi	sp,sp,-160
    3e7e:	ed06                	sd	ra,152(sp)
    3e80:	e922                	sd	s0,144(sp)
    3e82:	e526                	sd	s1,136(sp)
    3e84:	e14a                	sd	s2,128(sp)
    3e86:	fcce                	sd	s3,120(sp)
    3e88:	f8d2                	sd	s4,112(sp)
    3e8a:	f4d6                	sd	s5,104(sp)
    3e8c:	f0da                	sd	s6,96(sp)
    3e8e:	ecde                	sd	s7,88(sp)
    3e90:	1100                	addi	s0,sp,160
    3e92:	89aa                	mv	s3,a0
  file[0] = 'C';
    3e94:	04300793          	li	a5,67
    3e98:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    3e9c:	fa040523          	sb	zero,-86(s0)
  for (i = 0; i < N; i++) {
    3ea0:	4901                	li	s2,0
    if (pid && (i % 3) == 1) {
    3ea2:	4b0d                	li	s6,3
    3ea4:	4a85                	li	s5,1
      link("C0", file);
    3ea6:	00003b97          	auipc	s7,0x3
    3eaa:	1fab8b93          	addi	s7,s7,506 # 70a0 <malloc+0x1df6>
  for (i = 0; i < N; i++) {
    3eae:	02800a13          	li	s4,40
    3eb2:	a41d                	j	40d8 <concreate+0x25c>
      link("C0", file);
    3eb4:	fa840593          	addi	a1,s0,-88
    3eb8:	855e                	mv	a0,s7
    3eba:	755000ef          	jal	4e0e <link>
    if (pid == 0) {
    3ebe:	a411                	j	40c2 <concreate+0x246>
    } else if (pid == 0 && (i % 5) == 1) {
    3ec0:	4795                	li	a5,5
    3ec2:	02f9693b          	remw	s2,s2,a5
    3ec6:	4785                	li	a5,1
    3ec8:	02f90563          	beq	s2,a5,3ef2 <concreate+0x76>
      fd = open(file, O_CREATE | O_RDWR);
    3ecc:	20200593          	li	a1,514
    3ed0:	fa840513          	addi	a0,s0,-88
    3ed4:	71b000ef          	jal	4dee <open>
      if (fd < 0) {
    3ed8:	1e055063          	bgez	a0,40b8 <concreate+0x23c>
        printf("concreate create %s failed\n", file);
    3edc:	fa840593          	addi	a1,s0,-88
    3ee0:	00003517          	auipc	a0,0x3
    3ee4:	1c850513          	addi	a0,a0,456 # 70a8 <malloc+0x1dfe>
    3ee8:	30e010ef          	jal	51f6 <printf>
        exit(1);
    3eec:	4505                	li	a0,1
    3eee:	6c1000ef          	jal	4dae <exit>
      link("C0", file);
    3ef2:	fa840593          	addi	a1,s0,-88
    3ef6:	00003517          	auipc	a0,0x3
    3efa:	1aa50513          	addi	a0,a0,426 # 70a0 <malloc+0x1df6>
    3efe:	711000ef          	jal	4e0e <link>
      exit(0);
    3f02:	4501                	li	a0,0
    3f04:	6ab000ef          	jal	4dae <exit>
        exit(1);
    3f08:	4505                	li	a0,1
    3f0a:	6a5000ef          	jal	4dae <exit>
  memset(fa, 0, sizeof(fa));
    3f0e:	02800613          	li	a2,40
    3f12:	4581                	li	a1,0
    3f14:	f8040513          	addi	a0,s0,-128
    3f18:	485000ef          	jal	4b9c <memset>
  fd = open(".", 0);
    3f1c:	4581                	li	a1,0
    3f1e:	00002517          	auipc	a0,0x2
    3f22:	bb250513          	addi	a0,a0,-1102 # 5ad0 <malloc+0x826>
    3f26:	6c9000ef          	jal	4dee <open>
    3f2a:	892a                	mv	s2,a0
  n = 0;
    3f2c:	8aa6                	mv	s5,s1
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    3f2e:	04300a13          	li	s4,67
      if (i < 0 || i >= sizeof(fa)) {
    3f32:	02700b13          	li	s6,39
      fa[i] = 1;
    3f36:	4b85                	li	s7,1
  while (read(fd, &de, sizeof(de)) > 0) {
    3f38:	4641                	li	a2,16
    3f3a:	f7040593          	addi	a1,s0,-144
    3f3e:	854a                	mv	a0,s2
    3f40:	687000ef          	jal	4dc6 <read>
    3f44:	06a05a63          	blez	a0,3fb8 <concreate+0x13c>
    if (de.inum == 0)
    3f48:	f7045783          	lhu	a5,-144(s0)
    3f4c:	d7f5                	beqz	a5,3f38 <concreate+0xbc>
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    3f4e:	f7244783          	lbu	a5,-142(s0)
    3f52:	ff4793e3          	bne	a5,s4,3f38 <concreate+0xbc>
    3f56:	f7444783          	lbu	a5,-140(s0)
    3f5a:	fff9                	bnez	a5,3f38 <concreate+0xbc>
      i = de.name[1] - '0';
    3f5c:	f7344783          	lbu	a5,-141(s0)
    3f60:	fd07879b          	addiw	a5,a5,-48
    3f64:	0007871b          	sext.w	a4,a5
      if (i < 0 || i >= sizeof(fa)) {
    3f68:	02eb6063          	bltu	s6,a4,3f88 <concreate+0x10c>
      if (fa[i]) {
    3f6c:	fb070793          	addi	a5,a4,-80
    3f70:	97a2                	add	a5,a5,s0
    3f72:	fd07c783          	lbu	a5,-48(a5)
    3f76:	e78d                	bnez	a5,3fa0 <concreate+0x124>
      fa[i] = 1;
    3f78:	fb070793          	addi	a5,a4,-80
    3f7c:	00878733          	add	a4,a5,s0
    3f80:	fd770823          	sb	s7,-48(a4)
      n++;
    3f84:	2a85                	addiw	s5,s5,1
    3f86:	bf4d                	j	3f38 <concreate+0xbc>
        printf("%s: concreate weird file %s\n", s, de.name);
    3f88:	f7240613          	addi	a2,s0,-142
    3f8c:	85ce                	mv	a1,s3
    3f8e:	00003517          	auipc	a0,0x3
    3f92:	13a50513          	addi	a0,a0,314 # 70c8 <malloc+0x1e1e>
    3f96:	260010ef          	jal	51f6 <printf>
        exit(1);
    3f9a:	4505                	li	a0,1
    3f9c:	613000ef          	jal	4dae <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3fa0:	f7240613          	addi	a2,s0,-142
    3fa4:	85ce                	mv	a1,s3
    3fa6:	00003517          	auipc	a0,0x3
    3faa:	14250513          	addi	a0,a0,322 # 70e8 <malloc+0x1e3e>
    3fae:	248010ef          	jal	51f6 <printf>
        exit(1);
    3fb2:	4505                	li	a0,1
    3fb4:	5fb000ef          	jal	4dae <exit>
  close(fd);
    3fb8:	854a                	mv	a0,s2
    3fba:	61d000ef          	jal	4dd6 <close>
  if (n != N) {
    3fbe:	02800793          	li	a5,40
    3fc2:	00fa9763          	bne	s5,a5,3fd0 <concreate+0x154>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    3fc6:	4a8d                	li	s5,3
    3fc8:	4b05                	li	s6,1
  for (i = 0; i < N; i++) {
    3fca:	02800a13          	li	s4,40
    3fce:	a079                	j	405c <concreate+0x1e0>
    printf("%s: concreate not enough files in directory listing\n", s);
    3fd0:	85ce                	mv	a1,s3
    3fd2:	00003517          	auipc	a0,0x3
    3fd6:	13e50513          	addi	a0,a0,318 # 7110 <malloc+0x1e66>
    3fda:	21c010ef          	jal	51f6 <printf>
    exit(1);
    3fde:	4505                	li	a0,1
    3fe0:	5cf000ef          	jal	4dae <exit>
      printf("%s: fork failed\n", s);
    3fe4:	85ce                	mv	a1,s3
    3fe6:	00002517          	auipc	a0,0x2
    3fea:	c9250513          	addi	a0,a0,-878 # 5c78 <malloc+0x9ce>
    3fee:	208010ef          	jal	51f6 <printf>
      exit(1);
    3ff2:	4505                	li	a0,1
    3ff4:	5bb000ef          	jal	4dae <exit>
      close(open(file, 0));
    3ff8:	4581                	li	a1,0
    3ffa:	fa840513          	addi	a0,s0,-88
    3ffe:	5f1000ef          	jal	4dee <open>
    4002:	5d5000ef          	jal	4dd6 <close>
      close(open(file, 0));
    4006:	4581                	li	a1,0
    4008:	fa840513          	addi	a0,s0,-88
    400c:	5e3000ef          	jal	4dee <open>
    4010:	5c7000ef          	jal	4dd6 <close>
      close(open(file, 0));
    4014:	4581                	li	a1,0
    4016:	fa840513          	addi	a0,s0,-88
    401a:	5d5000ef          	jal	4dee <open>
    401e:	5b9000ef          	jal	4dd6 <close>
      close(open(file, 0));
    4022:	4581                	li	a1,0
    4024:	fa840513          	addi	a0,s0,-88
    4028:	5c7000ef          	jal	4dee <open>
    402c:	5ab000ef          	jal	4dd6 <close>
      close(open(file, 0));
    4030:	4581                	li	a1,0
    4032:	fa840513          	addi	a0,s0,-88
    4036:	5b9000ef          	jal	4dee <open>
    403a:	59d000ef          	jal	4dd6 <close>
      close(open(file, 0));
    403e:	4581                	li	a1,0
    4040:	fa840513          	addi	a0,s0,-88
    4044:	5ab000ef          	jal	4dee <open>
    4048:	58f000ef          	jal	4dd6 <close>
    if (pid == 0)
    404c:	06090363          	beqz	s2,40b2 <concreate+0x236>
      wait(0);
    4050:	4501                	li	a0,0
    4052:	565000ef          	jal	4db6 <wait>
  for (i = 0; i < N; i++) {
    4056:	2485                	addiw	s1,s1,1
    4058:	0b448963          	beq	s1,s4,410a <concreate+0x28e>
    file[1] = '0' + i;
    405c:	0304879b          	addiw	a5,s1,48
    4060:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4064:	543000ef          	jal	4da6 <fork>
    4068:	892a                	mv	s2,a0
    if (pid < 0) {
    406a:	f6054de3          	bltz	a0,3fe4 <concreate+0x168>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    406e:	0354e73b          	remw	a4,s1,s5
    4072:	00a767b3          	or	a5,a4,a0
    4076:	2781                	sext.w	a5,a5
    4078:	d3c1                	beqz	a5,3ff8 <concreate+0x17c>
    407a:	01671363          	bne	a4,s6,4080 <concreate+0x204>
    407e:	fd2d                	bnez	a0,3ff8 <concreate+0x17c>
      unlink(file);
    4080:	fa840513          	addi	a0,s0,-88
    4084:	57b000ef          	jal	4dfe <unlink>
      unlink(file);
    4088:	fa840513          	addi	a0,s0,-88
    408c:	573000ef          	jal	4dfe <unlink>
      unlink(file);
    4090:	fa840513          	addi	a0,s0,-88
    4094:	56b000ef          	jal	4dfe <unlink>
      unlink(file);
    4098:	fa840513          	addi	a0,s0,-88
    409c:	563000ef          	jal	4dfe <unlink>
      unlink(file);
    40a0:	fa840513          	addi	a0,s0,-88
    40a4:	55b000ef          	jal	4dfe <unlink>
      unlink(file);
    40a8:	fa840513          	addi	a0,s0,-88
    40ac:	553000ef          	jal	4dfe <unlink>
    40b0:	bf71                	j	404c <concreate+0x1d0>
      exit(0);
    40b2:	4501                	li	a0,0
    40b4:	4fb000ef          	jal	4dae <exit>
      close(fd);
    40b8:	51f000ef          	jal	4dd6 <close>
    if (pid == 0) {
    40bc:	b599                	j	3f02 <concreate+0x86>
      close(fd);
    40be:	519000ef          	jal	4dd6 <close>
      wait(&xstatus);
    40c2:	f6c40513          	addi	a0,s0,-148
    40c6:	4f1000ef          	jal	4db6 <wait>
      if (xstatus != 0)
    40ca:	f6c42483          	lw	s1,-148(s0)
    40ce:	e2049de3          	bnez	s1,3f08 <concreate+0x8c>
  for (i = 0; i < N; i++) {
    40d2:	2905                	addiw	s2,s2,1
    40d4:	e3490de3          	beq	s2,s4,3f0e <concreate+0x92>
    file[1] = '0' + i;
    40d8:	0309079b          	addiw	a5,s2,48
    40dc:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    40e0:	fa840513          	addi	a0,s0,-88
    40e4:	51b000ef          	jal	4dfe <unlink>
    pid = fork();
    40e8:	4bf000ef          	jal	4da6 <fork>
    if (pid && (i % 3) == 1) {
    40ec:	dc050ae3          	beqz	a0,3ec0 <concreate+0x44>
    40f0:	036967bb          	remw	a5,s2,s6
    40f4:	dd5780e3          	beq	a5,s5,3eb4 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    40f8:	20200593          	li	a1,514
    40fc:	fa840513          	addi	a0,s0,-88
    4100:	4ef000ef          	jal	4dee <open>
      if (fd < 0) {
    4104:	fa055de3          	bgez	a0,40be <concreate+0x242>
    4108:	bbd1                	j	3edc <concreate+0x60>
}
    410a:	60ea                	ld	ra,152(sp)
    410c:	644a                	ld	s0,144(sp)
    410e:	64aa                	ld	s1,136(sp)
    4110:	690a                	ld	s2,128(sp)
    4112:	79e6                	ld	s3,120(sp)
    4114:	7a46                	ld	s4,112(sp)
    4116:	7aa6                	ld	s5,104(sp)
    4118:	7b06                	ld	s6,96(sp)
    411a:	6be6                	ld	s7,88(sp)
    411c:	610d                	addi	sp,sp,160
    411e:	8082                	ret

0000000000004120 <bigfile>:
{
    4120:	7139                	addi	sp,sp,-64
    4122:	fc06                	sd	ra,56(sp)
    4124:	f822                	sd	s0,48(sp)
    4126:	f426                	sd	s1,40(sp)
    4128:	f04a                	sd	s2,32(sp)
    412a:	ec4e                	sd	s3,24(sp)
    412c:	e852                	sd	s4,16(sp)
    412e:	e456                	sd	s5,8(sp)
    4130:	0080                	addi	s0,sp,64
    4132:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4134:	00003517          	auipc	a0,0x3
    4138:	01450513          	addi	a0,a0,20 # 7148 <malloc+0x1e9e>
    413c:	4c3000ef          	jal	4dfe <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4140:	20200593          	li	a1,514
    4144:	00003517          	auipc	a0,0x3
    4148:	00450513          	addi	a0,a0,4 # 7148 <malloc+0x1e9e>
    414c:	4a3000ef          	jal	4dee <open>
    4150:	89aa                	mv	s3,a0
  for (i = 0; i < N; i++) {
    4152:	4481                	li	s1,0
    memset(buf, i, SZ);
    4154:	00009917          	auipc	s2,0x9
    4158:	b6490913          	addi	s2,s2,-1180 # ccb8 <buf>
  for (i = 0; i < N; i++) {
    415c:	4a51                	li	s4,20
  if (fd < 0) {
    415e:	08054663          	bltz	a0,41ea <bigfile+0xca>
    memset(buf, i, SZ);
    4162:	25800613          	li	a2,600
    4166:	85a6                	mv	a1,s1
    4168:	854a                	mv	a0,s2
    416a:	233000ef          	jal	4b9c <memset>
    if (write(fd, buf, SZ) != SZ) {
    416e:	25800613          	li	a2,600
    4172:	85ca                	mv	a1,s2
    4174:	854e                	mv	a0,s3
    4176:	459000ef          	jal	4dce <write>
    417a:	25800793          	li	a5,600
    417e:	08f51063          	bne	a0,a5,41fe <bigfile+0xde>
  for (i = 0; i < N; i++) {
    4182:	2485                	addiw	s1,s1,1
    4184:	fd449fe3          	bne	s1,s4,4162 <bigfile+0x42>
  close(fd);
    4188:	854e                	mv	a0,s3
    418a:	44d000ef          	jal	4dd6 <close>
  fd = open("bigfile.dat", 0);
    418e:	4581                	li	a1,0
    4190:	00003517          	auipc	a0,0x3
    4194:	fb850513          	addi	a0,a0,-72 # 7148 <malloc+0x1e9e>
    4198:	457000ef          	jal	4dee <open>
    419c:	8a2a                	mv	s4,a0
  total = 0;
    419e:	4981                	li	s3,0
  for (i = 0;; i++) {
    41a0:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    41a2:	00009917          	auipc	s2,0x9
    41a6:	b1690913          	addi	s2,s2,-1258 # ccb8 <buf>
  if (fd < 0) {
    41aa:	06054463          	bltz	a0,4212 <bigfile+0xf2>
    cc = read(fd, buf, SZ / 2);
    41ae:	12c00613          	li	a2,300
    41b2:	85ca                	mv	a1,s2
    41b4:	8552                	mv	a0,s4
    41b6:	411000ef          	jal	4dc6 <read>
    if (cc < 0) {
    41ba:	06054663          	bltz	a0,4226 <bigfile+0x106>
    if (cc == 0)
    41be:	c155                	beqz	a0,4262 <bigfile+0x142>
    if (cc != SZ / 2) {
    41c0:	12c00793          	li	a5,300
    41c4:	06f51b63          	bne	a0,a5,423a <bigfile+0x11a>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2) {
    41c8:	01f4d79b          	srliw	a5,s1,0x1f
    41cc:	9fa5                	addw	a5,a5,s1
    41ce:	4017d79b          	sraiw	a5,a5,0x1
    41d2:	00094703          	lbu	a4,0(s2)
    41d6:	06f71c63          	bne	a4,a5,424e <bigfile+0x12e>
    41da:	12b94703          	lbu	a4,299(s2)
    41de:	06f71863          	bne	a4,a5,424e <bigfile+0x12e>
    total += cc;
    41e2:	12c9899b          	addiw	s3,s3,300
  for (i = 0;; i++) {
    41e6:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    41e8:	b7d9                	j	41ae <bigfile+0x8e>
    printf("%s: cannot create bigfile", s);
    41ea:	85d6                	mv	a1,s5
    41ec:	00003517          	auipc	a0,0x3
    41f0:	f6c50513          	addi	a0,a0,-148 # 7158 <malloc+0x1eae>
    41f4:	002010ef          	jal	51f6 <printf>
    exit(1);
    41f8:	4505                	li	a0,1
    41fa:	3b5000ef          	jal	4dae <exit>
      printf("%s: write bigfile failed\n", s);
    41fe:	85d6                	mv	a1,s5
    4200:	00003517          	auipc	a0,0x3
    4204:	f7850513          	addi	a0,a0,-136 # 7178 <malloc+0x1ece>
    4208:	7ef000ef          	jal	51f6 <printf>
      exit(1);
    420c:	4505                	li	a0,1
    420e:	3a1000ef          	jal	4dae <exit>
    printf("%s: cannot open bigfile\n", s);
    4212:	85d6                	mv	a1,s5
    4214:	00003517          	auipc	a0,0x3
    4218:	f8450513          	addi	a0,a0,-124 # 7198 <malloc+0x1eee>
    421c:	7db000ef          	jal	51f6 <printf>
    exit(1);
    4220:	4505                	li	a0,1
    4222:	38d000ef          	jal	4dae <exit>
      printf("%s: read bigfile failed\n", s);
    4226:	85d6                	mv	a1,s5
    4228:	00003517          	auipc	a0,0x3
    422c:	f9050513          	addi	a0,a0,-112 # 71b8 <malloc+0x1f0e>
    4230:	7c7000ef          	jal	51f6 <printf>
      exit(1);
    4234:	4505                	li	a0,1
    4236:	379000ef          	jal	4dae <exit>
      printf("%s: short read bigfile\n", s);
    423a:	85d6                	mv	a1,s5
    423c:	00003517          	auipc	a0,0x3
    4240:	f9c50513          	addi	a0,a0,-100 # 71d8 <malloc+0x1f2e>
    4244:	7b3000ef          	jal	51f6 <printf>
      exit(1);
    4248:	4505                	li	a0,1
    424a:	365000ef          	jal	4dae <exit>
      printf("%s: read bigfile wrong data\n", s);
    424e:	85d6                	mv	a1,s5
    4250:	00003517          	auipc	a0,0x3
    4254:	fa050513          	addi	a0,a0,-96 # 71f0 <malloc+0x1f46>
    4258:	79f000ef          	jal	51f6 <printf>
      exit(1);
    425c:	4505                	li	a0,1
    425e:	351000ef          	jal	4dae <exit>
  close(fd);
    4262:	8552                	mv	a0,s4
    4264:	373000ef          	jal	4dd6 <close>
  if (total != N * SZ) {
    4268:	678d                	lui	a5,0x3
    426a:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x494>
    426e:	02f99163          	bne	s3,a5,4290 <bigfile+0x170>
  unlink("bigfile.dat");
    4272:	00003517          	auipc	a0,0x3
    4276:	ed650513          	addi	a0,a0,-298 # 7148 <malloc+0x1e9e>
    427a:	385000ef          	jal	4dfe <unlink>
}
    427e:	70e2                	ld	ra,56(sp)
    4280:	7442                	ld	s0,48(sp)
    4282:	74a2                	ld	s1,40(sp)
    4284:	7902                	ld	s2,32(sp)
    4286:	69e2                	ld	s3,24(sp)
    4288:	6a42                	ld	s4,16(sp)
    428a:	6aa2                	ld	s5,8(sp)
    428c:	6121                	addi	sp,sp,64
    428e:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4290:	85d6                	mv	a1,s5
    4292:	00003517          	auipc	a0,0x3
    4296:	f7e50513          	addi	a0,a0,-130 # 7210 <malloc+0x1f66>
    429a:	75d000ef          	jal	51f6 <printf>
    exit(1);
    429e:	4505                	li	a0,1
    42a0:	30f000ef          	jal	4dae <exit>

00000000000042a4 <bigargtest>:
{
    42a4:	7121                	addi	sp,sp,-448
    42a6:	ff06                	sd	ra,440(sp)
    42a8:	fb22                	sd	s0,432(sp)
    42aa:	f726                	sd	s1,424(sp)
    42ac:	0380                	addi	s0,sp,448
    42ae:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    42b0:	00003517          	auipc	a0,0x3
    42b4:	f8050513          	addi	a0,a0,-128 # 7230 <malloc+0x1f86>
    42b8:	347000ef          	jal	4dfe <unlink>
  pid = fork();
    42bc:	2eb000ef          	jal	4da6 <fork>
  if (pid == 0) {
    42c0:	c915                	beqz	a0,42f4 <bigargtest+0x50>
  } else if (pid < 0) {
    42c2:	08054a63          	bltz	a0,4356 <bigargtest+0xb2>
  wait(&xstatus);
    42c6:	fdc40513          	addi	a0,s0,-36
    42ca:	2ed000ef          	jal	4db6 <wait>
  if (xstatus != 0)
    42ce:	fdc42503          	lw	a0,-36(s0)
    42d2:	ed41                	bnez	a0,436a <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    42d4:	4581                	li	a1,0
    42d6:	00003517          	auipc	a0,0x3
    42da:	f5a50513          	addi	a0,a0,-166 # 7230 <malloc+0x1f86>
    42de:	311000ef          	jal	4dee <open>
  if (fd < 0) {
    42e2:	08054663          	bltz	a0,436e <bigargtest+0xca>
  close(fd);
    42e6:	2f1000ef          	jal	4dd6 <close>
}
    42ea:	70fa                	ld	ra,440(sp)
    42ec:	745a                	ld	s0,432(sp)
    42ee:	74ba                	ld	s1,424(sp)
    42f0:	6139                	addi	sp,sp,448
    42f2:	8082                	ret
    memset(big, ' ', sizeof(big));
    42f4:	19000613          	li	a2,400
    42f8:	02000593          	li	a1,32
    42fc:	e4840513          	addi	a0,s0,-440
    4300:	09d000ef          	jal	4b9c <memset>
    big[sizeof(big) - 1] = '\0';
    4304:	fc040ba3          	sb	zero,-41(s0)
    for (i = 0; i < MAXARG - 1; i++)
    4308:	00005797          	auipc	a5,0x5
    430c:	19878793          	addi	a5,a5,408 # 94a0 <args.1>
    4310:	00005697          	auipc	a3,0x5
    4314:	28868693          	addi	a3,a3,648 # 9598 <args.1+0xf8>
      args[i] = big;
    4318:	e4840713          	addi	a4,s0,-440
    431c:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    431e:	07a1                	addi	a5,a5,8
    4320:	fed79ee3          	bne	a5,a3,431c <bigargtest+0x78>
    args[MAXARG - 1] = 0;
    4324:	00005597          	auipc	a1,0x5
    4328:	17c58593          	addi	a1,a1,380 # 94a0 <args.1>
    432c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    4330:	00001517          	auipc	a0,0x1
    4334:	0b850513          	addi	a0,a0,184 # 53e8 <malloc+0x13e>
    4338:	2af000ef          	jal	4de6 <exec>
    fd = open("bigarg-ok", O_CREATE);
    433c:	20000593          	li	a1,512
    4340:	00003517          	auipc	a0,0x3
    4344:	ef050513          	addi	a0,a0,-272 # 7230 <malloc+0x1f86>
    4348:	2a7000ef          	jal	4dee <open>
    close(fd);
    434c:	28b000ef          	jal	4dd6 <close>
    exit(0);
    4350:	4501                	li	a0,0
    4352:	25d000ef          	jal	4dae <exit>
    printf("%s: bigargtest: fork failed\n", s);
    4356:	85a6                	mv	a1,s1
    4358:	00003517          	auipc	a0,0x3
    435c:	ee850513          	addi	a0,a0,-280 # 7240 <malloc+0x1f96>
    4360:	697000ef          	jal	51f6 <printf>
    exit(1);
    4364:	4505                	li	a0,1
    4366:	249000ef          	jal	4dae <exit>
    exit(xstatus);
    436a:	245000ef          	jal	4dae <exit>
    printf("%s: bigarg test failed!\n", s);
    436e:	85a6                	mv	a1,s1
    4370:	00003517          	auipc	a0,0x3
    4374:	ef050513          	addi	a0,a0,-272 # 7260 <malloc+0x1fb6>
    4378:	67f000ef          	jal	51f6 <printf>
    exit(1);
    437c:	4505                	li	a0,1
    437e:	231000ef          	jal	4dae <exit>

0000000000004382 <lazy_alloc>:
{
    4382:	1141                	addi	sp,sp,-16
    4384:	e406                	sd	ra,8(sp)
    4386:	e022                	sd	s0,0(sp)
    4388:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    438a:	40000537          	lui	a0,0x40000
    438e:	203000ef          	jal	4d90 <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    4392:	57fd                	li	a5,-1
    4394:	02f50a63          	beq	a0,a5,43c8 <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4398:	6605                	lui	a2,0x1
    439a:	962a                	add	a2,a2,a0
    439c:	400017b7          	lui	a5,0x40001
    43a0:	00f50733          	add	a4,a0,a5
    43a4:	87b2                	mv	a5,a2
    43a6:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    43aa:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    43ac:	97b6                	add	a5,a5,a3
    43ae:	fee79ee3          	bne	a5,a4,43aa <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    43b2:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    43b6:	621c                	ld	a5,0(a2)
    43b8:	02c79163          	bne	a5,a2,43da <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    43bc:	9636                	add	a2,a2,a3
    43be:	fee61ce3          	bne	a2,a4,43b6 <lazy_alloc+0x34>
  exit(0);
    43c2:	4501                	li	a0,0
    43c4:	1eb000ef          	jal	4dae <exit>
    printf("sbrklazy() failed\n");
    43c8:	00003517          	auipc	a0,0x3
    43cc:	eb850513          	addi	a0,a0,-328 # 7280 <malloc+0x1fd6>
    43d0:	627000ef          	jal	51f6 <printf>
    exit(1);
    43d4:	4505                	li	a0,1
    43d6:	1d9000ef          	jal	4dae <exit>
      printf("failed to read value from memory\n");
    43da:	00003517          	auipc	a0,0x3
    43de:	ebe50513          	addi	a0,a0,-322 # 7298 <malloc+0x1fee>
    43e2:	615000ef          	jal	51f6 <printf>
      exit(1);
    43e6:	4505                	li	a0,1
    43e8:	1c7000ef          	jal	4dae <exit>

00000000000043ec <lazy_unmap>:
{
    43ec:	7139                	addi	sp,sp,-64
    43ee:	fc06                	sd	ra,56(sp)
    43f0:	f822                	sd	s0,48(sp)
    43f2:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    43f4:	40000537          	lui	a0,0x40000
    43f8:	199000ef          	jal	4d90 <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    43fc:	57fd                	li	a5,-1
    43fe:	04f50663          	beq	a0,a5,444a <lazy_unmap+0x5e>
    4402:	f426                	sd	s1,40(sp)
    4404:	f04a                	sd	s2,32(sp)
    4406:	ec4e                	sd	s3,24(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4408:	6905                	lui	s2,0x1
    440a:	992a                	add	s2,s2,a0
    440c:	400017b7          	lui	a5,0x40001
    4410:	00f504b3          	add	s1,a0,a5
    4414:	87ca                	mv	a5,s2
    4416:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    441a:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    441c:	97ba                	add	a5,a5,a4
    441e:	fe979ee3          	bne	a5,s1,441a <lazy_unmap+0x2e>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    4422:	010009b7          	lui	s3,0x1000
    pid = fork();
    4426:	181000ef          	jal	4da6 <fork>
    if (pid < 0) {
    442a:	02054c63          	bltz	a0,4462 <lazy_unmap+0x76>
    } else if (pid == 0) {
    442e:	c139                	beqz	a0,4474 <lazy_unmap+0x88>
      wait(&status);
    4430:	fcc40513          	addi	a0,s0,-52
    4434:	183000ef          	jal	4db6 <wait>
      if (status == 0) {
    4438:	fcc42783          	lw	a5,-52(s0)
    443c:	c7a9                	beqz	a5,4486 <lazy_unmap+0x9a>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    443e:	994e                	add	s2,s2,s3
    4440:	fe9913e3          	bne	s2,s1,4426 <lazy_unmap+0x3a>
  exit(0);
    4444:	4501                	li	a0,0
    4446:	169000ef          	jal	4dae <exit>
    444a:	f426                	sd	s1,40(sp)
    444c:	f04a                	sd	s2,32(sp)
    444e:	ec4e                	sd	s3,24(sp)
    printf("sbrklazy() failed\n");
    4450:	00003517          	auipc	a0,0x3
    4454:	e3050513          	addi	a0,a0,-464 # 7280 <malloc+0x1fd6>
    4458:	59f000ef          	jal	51f6 <printf>
    exit(1);
    445c:	4505                	li	a0,1
    445e:	151000ef          	jal	4dae <exit>
      printf("error forking\n");
    4462:	00003517          	auipc	a0,0x3
    4466:	e5e50513          	addi	a0,a0,-418 # 72c0 <malloc+0x2016>
    446a:	58d000ef          	jal	51f6 <printf>
      exit(1);
    446e:	4505                	li	a0,1
    4470:	13f000ef          	jal	4dae <exit>
      sbrklazy(-1L * REGION_SZ);
    4474:	c0000537          	lui	a0,0xc0000
    4478:	119000ef          	jal	4d90 <sbrklazy>
      *(char **)i = i;
    447c:	01293023          	sd	s2,0(s2) # 1000 <badarg>
      exit(0);
    4480:	4501                	li	a0,0
    4482:	12d000ef          	jal	4dae <exit>
        printf("memory not unmapped\n");
    4486:	00003517          	auipc	a0,0x3
    448a:	e4a50513          	addi	a0,a0,-438 # 72d0 <malloc+0x2026>
    448e:	569000ef          	jal	51f6 <printf>
        exit(1);
    4492:	4505                	li	a0,1
    4494:	11b000ef          	jal	4dae <exit>

0000000000004498 <lazy_copy>:
{
    4498:	7159                	addi	sp,sp,-112
    449a:	f486                	sd	ra,104(sp)
    449c:	f0a2                	sd	s0,96(sp)
    449e:	eca6                	sd	s1,88(sp)
    44a0:	e8ca                	sd	s2,80(sp)
    44a2:	e4ce                	sd	s3,72(sp)
    44a4:	e0d2                	sd	s4,64(sp)
    44a6:	fc56                	sd	s5,56(sp)
    44a8:	f85a                	sd	s6,48(sp)
    44aa:	1880                	addi	s0,sp,112
    char *p = sbrk(0);
    44ac:	4501                	li	a0,0
    44ae:	0cd000ef          	jal	4d7a <sbrk>
    44b2:	84aa                	mv	s1,a0
    sbrklazy(4 * PGSIZE);
    44b4:	6511                	lui	a0,0x4
    44b6:	0db000ef          	jal	4d90 <sbrklazy>
    open(p + 8192, 0);
    44ba:	4581                	li	a1,0
    44bc:	6509                	lui	a0,0x2
    44be:	9526                	add	a0,a0,s1
    44c0:	12f000ef          	jal	4dee <open>
    void *xx = sbrk(0);
    44c4:	4501                	li	a0,0
    44c6:	0b5000ef          	jal	4d7a <sbrk>
    44ca:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64)xx) + 1));
    44cc:	fff54513          	not	a0,a0
    44d0:	2501                	sext.w	a0,a0
    44d2:	0a9000ef          	jal	4d7a <sbrk>
    if (ret != xx) {
    44d6:	00a48c63          	beq	s1,a0,44ee <lazy_copy+0x56>
    44da:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    44dc:	00003517          	auipc	a0,0x3
    44e0:	e0c50513          	addi	a0,a0,-500 # 72e8 <malloc+0x203e>
    44e4:	513000ef          	jal	51f6 <printf>
      exit(1);
    44e8:	4505                	li	a0,1
    44ea:	0c5000ef          	jal	4dae <exit>
  unsigned long bad[] = {
    44ee:	00003797          	auipc	a5,0x3
    44f2:	47278793          	addi	a5,a5,1138 # 7960 <malloc+0x26b6>
    44f6:	7fa8                	ld	a0,120(a5)
    44f8:	63cc                	ld	a1,128(a5)
    44fa:	67d0                	ld	a2,136(a5)
    44fc:	6bd4                	ld	a3,144(a5)
    44fe:	6fd8                	ld	a4,152(a5)
    4500:	73dc                	ld	a5,160(a5)
    4502:	f8a43823          	sd	a0,-112(s0)
    4506:	f8b43c23          	sd	a1,-104(s0)
    450a:	fac43023          	sd	a2,-96(s0)
    450e:	fad43423          	sd	a3,-88(s0)
    4512:	fae43823          	sd	a4,-80(s0)
    4516:	faf43c23          	sd	a5,-72(s0)
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    451a:	f9040913          	addi	s2,s0,-112
    451e:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
    4522:	00001a17          	auipc	s4,0x1
    4526:	09ea0a13          	addi	s4,s4,158 # 55c0 <malloc+0x316>
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    452a:	00001a97          	auipc	s5,0x1
    452e:	fa6a8a93          	addi	s5,s5,-90 # 54d0 <malloc+0x226>
    int fd = open("README", 0);
    4532:	4581                	li	a1,0
    4534:	8552                	mv	a0,s4
    4536:	0b9000ef          	jal	4dee <open>
    453a:	84aa                	mv	s1,a0
    if (fd < 0) {
    453c:	04054663          	bltz	a0,4588 <lazy_copy+0xf0>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    4540:	00093983          	ld	s3,0(s2)
    4544:	20000613          	li	a2,512
    4548:	85ce                	mv	a1,s3
    454a:	07d000ef          	jal	4dc6 <read>
    454e:	04055663          	bgez	a0,459a <lazy_copy+0x102>
    close(fd);
    4552:	8526                	mv	a0,s1
    4554:	083000ef          	jal	4dd6 <close>
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    4558:	60200593          	li	a1,1538
    455c:	8556                	mv	a0,s5
    455e:	091000ef          	jal	4dee <open>
    4562:	84aa                	mv	s1,a0
    if (fd < 0) {
    4564:	04054463          	bltz	a0,45ac <lazy_copy+0x114>
    if (write(fd, (char *)bad[i], 512) >= 0) {
    4568:	20000613          	li	a2,512
    456c:	85ce                	mv	a1,s3
    456e:	061000ef          	jal	4dce <write>
    4572:	04055663          	bgez	a0,45be <lazy_copy+0x126>
    close(fd);
    4576:	8526                	mv	a0,s1
    4578:	05f000ef          	jal	4dd6 <close>
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    457c:	0921                	addi	s2,s2,8
    457e:	fb691ae3          	bne	s2,s6,4532 <lazy_copy+0x9a>
  exit(0);
    4582:	4501                	li	a0,0
    4584:	02b000ef          	jal	4dae <exit>
      printf("cannot open README\n");
    4588:	00003517          	auipc	a0,0x3
    458c:	d9050513          	addi	a0,a0,-624 # 7318 <malloc+0x206e>
    4590:	467000ef          	jal	51f6 <printf>
      exit(1);
    4594:	4505                	li	a0,1
    4596:	019000ef          	jal	4dae <exit>
      printf("read succeeded\n");
    459a:	00003517          	auipc	a0,0x3
    459e:	d9650513          	addi	a0,a0,-618 # 7330 <malloc+0x2086>
    45a2:	455000ef          	jal	51f6 <printf>
      exit(1);
    45a6:	4505                	li	a0,1
    45a8:	007000ef          	jal	4dae <exit>
      printf("cannot open junk\n");
    45ac:	00003517          	auipc	a0,0x3
    45b0:	d9450513          	addi	a0,a0,-620 # 7340 <malloc+0x2096>
    45b4:	443000ef          	jal	51f6 <printf>
      exit(1);
    45b8:	4505                	li	a0,1
    45ba:	7f4000ef          	jal	4dae <exit>
      printf("write succeeded\n");
    45be:	00003517          	auipc	a0,0x3
    45c2:	d9a50513          	addi	a0,a0,-614 # 7358 <malloc+0x20ae>
    45c6:	431000ef          	jal	51f6 <printf>
      exit(1);
    45ca:	4505                	li	a0,1
    45cc:	7e2000ef          	jal	4dae <exit>

00000000000045d0 <lazy_sbrk>:
{
    45d0:	1101                	addi	sp,sp,-32
    45d2:	ec06                	sd	ra,24(sp)
    45d4:	e822                	sd	s0,16(sp)
    45d6:	e426                	sd	s1,8(sp)
    45d8:	e04a                	sd	s2,0(sp)
    45da:	1000                	addi	s0,sp,32
  char *p = sbrk(0);
    45dc:	4501                	li	a0,0
    45de:	79c000ef          	jal	4d7a <sbrk>
    45e2:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    45e4:	0ff00793          	li	a5,255
    45e8:	07fa                	slli	a5,a5,0x1e
    45ea:	00f57d63          	bgeu	a0,a5,4604 <lazy_sbrk+0x34>
    45ee:	893e                	mv	s2,a5
    p = sbrklazy(1 << 30);
    45f0:	40000537          	lui	a0,0x40000
    45f4:	79c000ef          	jal	4d90 <sbrklazy>
    p = sbrklazy(0);
    45f8:	4501                	li	a0,0
    45fa:	796000ef          	jal	4d90 <sbrklazy>
    45fe:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    4600:	ff2568e3          	bltu	a0,s2,45f0 <lazy_sbrk+0x20>
  int n = TRAPFRAME - PGSIZE - (uint64)p;
    4604:	7975                	lui	s2,0xffffd
    4606:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    460a:	854a                	mv	a0,s2
    460c:	784000ef          	jal	4d90 <sbrklazy>
    4610:	862a                	mv	a2,a0
  if (p1 < 0 || p1 != p) {
    4612:	00950d63          	beq	a0,s1,462c <lazy_sbrk+0x5c>
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    4616:	86a6                	mv	a3,s1
    4618:	85ca                	mv	a1,s2
    461a:	00003517          	auipc	a0,0x3
    461e:	d5650513          	addi	a0,a0,-682 # 7370 <malloc+0x20c6>
    4622:	3d5000ef          	jal	51f6 <printf>
    exit(1);
    4626:	4505                	li	a0,1
    4628:	786000ef          	jal	4dae <exit>
  p = sbrk(PGSIZE);
    462c:	6505                	lui	a0,0x1
    462e:	74c000ef          	jal	4d7a <sbrk>
    4632:	862a                	mv	a2,a0
  if (p < 0 || (uint64)p != TRAPFRAME - PGSIZE) {
    4634:	040007b7          	lui	a5,0x4000
    4638:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff0345>
    463a:	07b2                	slli	a5,a5,0xc
    463c:	00f50c63          	beq	a0,a5,4654 <lazy_sbrk+0x84>
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    4640:	6585                	lui	a1,0x1
    4642:	00003517          	auipc	a0,0x3
    4646:	d5e50513          	addi	a0,a0,-674 # 73a0 <malloc+0x20f6>
    464a:	3ad000ef          	jal	51f6 <printf>
    exit(1);
    464e:	4505                	li	a0,1
    4650:	75e000ef          	jal	4dae <exit>
  p[0] = 1;
    4654:	040007b7          	lui	a5,0x4000
    4658:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff0345>
    465a:	07b2                	slli	a5,a5,0xc
    465c:	4705                	li	a4,1
    465e:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    4662:	0017c783          	lbu	a5,1(a5)
    4666:	cb91                	beqz	a5,467a <lazy_sbrk+0xaa>
    printf("sbrk() returned non-zero-filled memory\n");
    4668:	00003517          	auipc	a0,0x3
    466c:	d7050513          	addi	a0,a0,-656 # 73d8 <malloc+0x212e>
    4670:	387000ef          	jal	51f6 <printf>
    exit(1);
    4674:	4505                	li	a0,1
    4676:	738000ef          	jal	4dae <exit>
  p = sbrk(1);
    467a:	4505                	li	a0,1
    467c:	6fe000ef          	jal	4d7a <sbrk>
    4680:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4682:	57fd                	li	a5,-1
    4684:	00f50b63          	beq	a0,a5,469a <lazy_sbrk+0xca>
    printf("sbrk(1) returned %p, expected error\n", p);
    4688:	00003517          	auipc	a0,0x3
    468c:	d7850513          	addi	a0,a0,-648 # 7400 <malloc+0x2156>
    4690:	367000ef          	jal	51f6 <printf>
    exit(1);
    4694:	4505                	li	a0,1
    4696:	718000ef          	jal	4dae <exit>
  p = sbrklazy(1);
    469a:	4505                	li	a0,1
    469c:	6f4000ef          	jal	4d90 <sbrklazy>
    46a0:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    46a2:	57fd                	li	a5,-1
    46a4:	00f50b63          	beq	a0,a5,46ba <lazy_sbrk+0xea>
    printf("sbrklazy(1) returned %p, expected error\n", p);
    46a8:	00003517          	auipc	a0,0x3
    46ac:	d8050513          	addi	a0,a0,-640 # 7428 <malloc+0x217e>
    46b0:	347000ef          	jal	51f6 <printf>
    exit(1);
    46b4:	4505                	li	a0,1
    46b6:	6f8000ef          	jal	4dae <exit>
  exit(0);
    46ba:	4501                	li	a0,0
    46bc:	6f2000ef          	jal	4dae <exit>

00000000000046c0 <fsfull>:
{
    46c0:	7135                	addi	sp,sp,-160
    46c2:	ed06                	sd	ra,152(sp)
    46c4:	e922                	sd	s0,144(sp)
    46c6:	e526                	sd	s1,136(sp)
    46c8:	e14a                	sd	s2,128(sp)
    46ca:	fcce                	sd	s3,120(sp)
    46cc:	f8d2                	sd	s4,112(sp)
    46ce:	f4d6                	sd	s5,104(sp)
    46d0:	f0da                	sd	s6,96(sp)
    46d2:	ecde                	sd	s7,88(sp)
    46d4:	e8e2                	sd	s8,80(sp)
    46d6:	e4e6                	sd	s9,72(sp)
    46d8:	e0ea                	sd	s10,64(sp)
    46da:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    46dc:	00003517          	auipc	a0,0x3
    46e0:	d7c50513          	addi	a0,a0,-644 # 7458 <malloc+0x21ae>
    46e4:	313000ef          	jal	51f6 <printf>
  for (nfiles = 0;; nfiles++) {
    46e8:	4481                	li	s1,0
    name[0] = 'f';
    46ea:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    46ee:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    46f2:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    46f6:	4b29                	li	s6,10
    printf("writing %s\n", name);
    46f8:	00003c97          	auipc	s9,0x3
    46fc:	d70c8c93          	addi	s9,s9,-656 # 7468 <malloc+0x21be>
    name[0] = 'f';
    4700:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4704:	0384c7bb          	divw	a5,s1,s8
    4708:	0307879b          	addiw	a5,a5,48
    470c:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4710:	0384e7bb          	remw	a5,s1,s8
    4714:	0377c7bb          	divw	a5,a5,s7
    4718:	0307879b          	addiw	a5,a5,48
    471c:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4720:	0374e7bb          	remw	a5,s1,s7
    4724:	0367c7bb          	divw	a5,a5,s6
    4728:	0307879b          	addiw	a5,a5,48
    472c:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4730:	0364e7bb          	remw	a5,s1,s6
    4734:	0307879b          	addiw	a5,a5,48
    4738:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    473c:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    4740:	f6040593          	addi	a1,s0,-160
    4744:	8566                	mv	a0,s9
    4746:	2b1000ef          	jal	51f6 <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    474a:	20200593          	li	a1,514
    474e:	f6040513          	addi	a0,s0,-160
    4752:	69c000ef          	jal	4dee <open>
    4756:	892a                	mv	s2,a0
    if (fd < 0) {
    4758:	08055f63          	bgez	a0,47f6 <fsfull+0x136>
      printf("open %s failed\n", name);
    475c:	f6040593          	addi	a1,s0,-160
    4760:	00003517          	auipc	a0,0x3
    4764:	d1850513          	addi	a0,a0,-744 # 7478 <malloc+0x21ce>
    4768:	28f000ef          	jal	51f6 <printf>
  while (nfiles >= 0) {
    476c:	0604c163          	bltz	s1,47ce <fsfull+0x10e>
    name[0] = 'f';
    4770:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4774:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4778:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    477c:	4929                	li	s2,10
  while (nfiles >= 0) {
    477e:	5afd                	li	s5,-1
    name[0] = 'f';
    4780:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4784:	0344c7bb          	divw	a5,s1,s4
    4788:	0307879b          	addiw	a5,a5,48
    478c:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4790:	0344e7bb          	remw	a5,s1,s4
    4794:	0337c7bb          	divw	a5,a5,s3
    4798:	0307879b          	addiw	a5,a5,48
    479c:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    47a0:	0334e7bb          	remw	a5,s1,s3
    47a4:	0327c7bb          	divw	a5,a5,s2
    47a8:	0307879b          	addiw	a5,a5,48
    47ac:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    47b0:	0324e7bb          	remw	a5,s1,s2
    47b4:	0307879b          	addiw	a5,a5,48
    47b8:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    47bc:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    47c0:	f6040513          	addi	a0,s0,-160
    47c4:	63a000ef          	jal	4dfe <unlink>
    nfiles--;
    47c8:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0) {
    47ca:	fb549be3          	bne	s1,s5,4780 <fsfull+0xc0>
  printf("fsfull test finished\n");
    47ce:	00003517          	auipc	a0,0x3
    47d2:	cca50513          	addi	a0,a0,-822 # 7498 <malloc+0x21ee>
    47d6:	221000ef          	jal	51f6 <printf>
}
    47da:	60ea                	ld	ra,152(sp)
    47dc:	644a                	ld	s0,144(sp)
    47de:	64aa                	ld	s1,136(sp)
    47e0:	690a                	ld	s2,128(sp)
    47e2:	79e6                	ld	s3,120(sp)
    47e4:	7a46                	ld	s4,112(sp)
    47e6:	7aa6                	ld	s5,104(sp)
    47e8:	7b06                	ld	s6,96(sp)
    47ea:	6be6                	ld	s7,88(sp)
    47ec:	6c46                	ld	s8,80(sp)
    47ee:	6ca6                	ld	s9,72(sp)
    47f0:	6d06                	ld	s10,64(sp)
    47f2:	610d                	addi	sp,sp,160
    47f4:	8082                	ret
    int total = 0;
    47f6:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    47f8:	00008a97          	auipc	s5,0x8
    47fc:	4c0a8a93          	addi	s5,s5,1216 # ccb8 <buf>
      if (cc < BSIZE)
    4800:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    4804:	40000613          	li	a2,1024
    4808:	85d6                	mv	a1,s5
    480a:	854a                	mv	a0,s2
    480c:	5c2000ef          	jal	4dce <write>
      if (cc < BSIZE)
    4810:	00aa5563          	bge	s4,a0,481a <fsfull+0x15a>
      total += cc;
    4814:	00a989bb          	addw	s3,s3,a0
    while (1) {
    4818:	b7f5                	j	4804 <fsfull+0x144>
    printf("wrote %d bytes\n", total);
    481a:	85ce                	mv	a1,s3
    481c:	00003517          	auipc	a0,0x3
    4820:	c6c50513          	addi	a0,a0,-916 # 7488 <malloc+0x21de>
    4824:	1d3000ef          	jal	51f6 <printf>
    close(fd);
    4828:	854a                	mv	a0,s2
    482a:	5ac000ef          	jal	4dd6 <close>
    if (total == 0)
    482e:	f2098fe3          	beqz	s3,476c <fsfull+0xac>
  for (nfiles = 0;; nfiles++) {
    4832:	2485                	addiw	s1,s1,1
    4834:	b5f1                	j	4700 <fsfull+0x40>

0000000000004836 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s)
{
    4836:	7179                	addi	sp,sp,-48
    4838:	f406                	sd	ra,40(sp)
    483a:	f022                	sd	s0,32(sp)
    483c:	ec26                	sd	s1,24(sp)
    483e:	e84a                	sd	s2,16(sp)
    4840:	1800                	addi	s0,sp,48
    4842:	84aa                	mv	s1,a0
    4844:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4846:	00003517          	auipc	a0,0x3
    484a:	c6a50513          	addi	a0,a0,-918 # 74b0 <malloc+0x2206>
    484e:	1a9000ef          	jal	51f6 <printf>
  if ((pid = fork()) < 0) {
    4852:	554000ef          	jal	4da6 <fork>
    4856:	02054a63          	bltz	a0,488a <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0) {
    485a:	c129                	beqz	a0,489c <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    485c:	fdc40513          	addi	a0,s0,-36
    4860:	556000ef          	jal	4db6 <wait>
    if (xstatus != 0)
    4864:	fdc42783          	lw	a5,-36(s0)
    4868:	cf9d                	beqz	a5,48a6 <run+0x70>
      printf("FAILED\n");
    486a:	00003517          	auipc	a0,0x3
    486e:	c6e50513          	addi	a0,a0,-914 # 74d8 <malloc+0x222e>
    4872:	185000ef          	jal	51f6 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4876:	fdc42503          	lw	a0,-36(s0)
  }
}
    487a:	00153513          	seqz	a0,a0
    487e:	70a2                	ld	ra,40(sp)
    4880:	7402                	ld	s0,32(sp)
    4882:	64e2                	ld	s1,24(sp)
    4884:	6942                	ld	s2,16(sp)
    4886:	6145                	addi	sp,sp,48
    4888:	8082                	ret
    printf("runtest: fork error\n");
    488a:	00003517          	auipc	a0,0x3
    488e:	c3650513          	addi	a0,a0,-970 # 74c0 <malloc+0x2216>
    4892:	165000ef          	jal	51f6 <printf>
    exit(1);
    4896:	4505                	li	a0,1
    4898:	516000ef          	jal	4dae <exit>
    f(s);
    489c:	854a                	mv	a0,s2
    489e:	9482                	jalr	s1
    exit(0);
    48a0:	4501                	li	a0,0
    48a2:	50c000ef          	jal	4dae <exit>
      printf("OK\n");
    48a6:	00003517          	auipc	a0,0x3
    48aa:	c3a50513          	addi	a0,a0,-966 # 74e0 <malloc+0x2236>
    48ae:	149000ef          	jal	51f6 <printf>
    48b2:	b7d1                	j	4876 <run+0x40>

00000000000048b4 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous)
{
    48b4:	7139                	addi	sp,sp,-64
    48b6:	fc06                	sd	ra,56(sp)
    48b8:	f822                	sd	s0,48(sp)
    48ba:	f426                	sd	s1,40(sp)
    48bc:	ec4e                	sd	s3,24(sp)
    48be:	0080                	addi	s0,sp,64
    48c0:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    48c2:	6508                	ld	a0,8(a0)
    48c4:	cd39                	beqz	a0,4922 <runtests+0x6e>
    48c6:	f04a                	sd	s2,32(sp)
    48c8:	e852                	sd	s4,16(sp)
    48ca:	e456                	sd	s5,8(sp)
    48cc:	892e                	mv	s2,a1
    48ce:	8a32                	mv	s4,a2
  int ntests = 0;
    48d0:	4981                	li	s3,0
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if (!run(t->f, t->s)) {
        if (continuous != 2) {
    48d2:	4a89                	li	s5,2
    48d4:	a021                	j	48dc <runtests+0x28>
  for (struct test *t = tests; t->s != 0; t++) {
    48d6:	04c1                	addi	s1,s1,16
    48d8:	6488                	ld	a0,8(s1)
    48da:	c915                	beqz	a0,490e <runtests+0x5a>
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
    48dc:	00090663          	beqz	s2,48e8 <runtests+0x34>
    48e0:	85ca                	mv	a1,s2
    48e2:	264000ef          	jal	4b46 <strcmp>
    48e6:	f965                	bnez	a0,48d6 <runtests+0x22>
      ntests++;
    48e8:	2985                	addiw	s3,s3,1 # 1000001 <base+0xff0349>
      if (!run(t->f, t->s)) {
    48ea:	648c                	ld	a1,8(s1)
    48ec:	6088                	ld	a0,0(s1)
    48ee:	f49ff0ef          	jal	4836 <run>
    48f2:	f175                	bnez	a0,48d6 <runtests+0x22>
        if (continuous != 2) {
    48f4:	ff5a01e3          	beq	s4,s5,48d6 <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    48f8:	00003517          	auipc	a0,0x3
    48fc:	bf050513          	addi	a0,a0,-1040 # 74e8 <malloc+0x223e>
    4900:	0f7000ef          	jal	51f6 <printf>
          return -1;
    4904:	59fd                	li	s3,-1
    4906:	7902                	ld	s2,32(sp)
    4908:	6a42                	ld	s4,16(sp)
    490a:	6aa2                	ld	s5,8(sp)
    490c:	a021                	j	4914 <runtests+0x60>
    490e:	7902                	ld	s2,32(sp)
    4910:	6a42                	ld	s4,16(sp)
    4912:	6aa2                	ld	s5,8(sp)
        }
      }
    }
  }
  return ntests;
}
    4914:	854e                	mv	a0,s3
    4916:	70e2                	ld	ra,56(sp)
    4918:	7442                	ld	s0,48(sp)
    491a:	74a2                	ld	s1,40(sp)
    491c:	69e2                	ld	s3,24(sp)
    491e:	6121                	addi	sp,sp,64
    4920:	8082                	ret
  return ntests;
    4922:	4981                	li	s3,0
    4924:	bfc5                	j	4914 <runtests+0x60>

0000000000004926 <countfree>:

// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    4926:	7179                	addi	sp,sp,-48
    4928:	f406                	sd	ra,40(sp)
    492a:	f022                	sd	s0,32(sp)
    492c:	ec26                	sd	s1,24(sp)
    492e:	e84a                	sd	s2,16(sp)
    4930:	e44e                	sd	s3,8(sp)
    4932:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    4934:	4501                	li	a0,0
    4936:	444000ef          	jal	4d7a <sbrk>
    493a:	89aa                	mv	s3,a0
  int n = 0;
    493c:	4481                	li	s1,0
  while (1) {
    char *a = sbrk(PGSIZE);
    if (a == SBRK_ERROR) {
    493e:	597d                	li	s2,-1
    4940:	a011                	j	4944 <countfree+0x1e>
      break;
    }
    n += 1;
    4942:	2485                	addiw	s1,s1,1
    char *a = sbrk(PGSIZE);
    4944:	6505                	lui	a0,0x1
    4946:	434000ef          	jal	4d7a <sbrk>
    if (a == SBRK_ERROR) {
    494a:	ff251ce3          	bne	a0,s2,4942 <countfree+0x1c>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
    494e:	4501                	li	a0,0
    4950:	42a000ef          	jal	4d7a <sbrk>
    4954:	40a9853b          	subw	a0,s3,a0
    4958:	422000ef          	jal	4d7a <sbrk>
  return n;
}
    495c:	8526                	mv	a0,s1
    495e:	70a2                	ld	ra,40(sp)
    4960:	7402                	ld	s0,32(sp)
    4962:	64e2                	ld	s1,24(sp)
    4964:	6942                	ld	s2,16(sp)
    4966:	69a2                	ld	s3,8(sp)
    4968:	6145                	addi	sp,sp,48
    496a:	8082                	ret

000000000000496c <drivetests>:

int
drivetests(int quick, int continuous, char *justone)
{
    496c:	7159                	addi	sp,sp,-112
    496e:	f486                	sd	ra,104(sp)
    4970:	f0a2                	sd	s0,96(sp)
    4972:	eca6                	sd	s1,88(sp)
    4974:	e8ca                	sd	s2,80(sp)
    4976:	e4ce                	sd	s3,72(sp)
    4978:	e0d2                	sd	s4,64(sp)
    497a:	fc56                	sd	s5,56(sp)
    497c:	f85a                	sd	s6,48(sp)
    497e:	f45e                	sd	s7,40(sp)
    4980:	f062                	sd	s8,32(sp)
    4982:	ec66                	sd	s9,24(sp)
    4984:	e86a                	sd	s10,16(sp)
    4986:	e46e                	sd	s11,8(sp)
    4988:	1880                	addi	s0,sp,112
    498a:	8aaa                	mv	s5,a0
    498c:	89ae                	mv	s3,a1
    498e:	8a32                	mv	s4,a2
  do {
    printf("usertests starting\n");
    4990:	00003c17          	auipc	s8,0x3
    4994:	b70c0c13          	addi	s8,s8,-1168 # 7500 <malloc+0x2256>
    int free0 = countfree();
    int free1 = 0;
    int ntests = 0;
    int n;
    n = runtests(quicktests, justone, continuous);
    4998:	00004b97          	auipc	s7,0x4
    499c:	678b8b93          	addi	s7,s7,1656 # 9010 <quicktests>
    if (n < 0) {
      if (continuous != 2) {
    49a0:	4b09                	li	s6,2
      ntests += n;
    }
    if (!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      n = runtests(slowtests, justone, continuous);
    49a2:	00005c97          	auipc	s9,0x5
    49a6:	a7ec8c93          	addi	s9,s9,-1410 # 9420 <slowtests>
        printf("usertests slow tests starting\n");
    49aa:	00003d97          	auipc	s11,0x3
    49ae:	b6ed8d93          	addi	s11,s11,-1170 # 7518 <malloc+0x226e>
      } else {
        ntests += n;
      }
    }
    if ((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    49b2:	00003d17          	auipc	s10,0x3
    49b6:	b86d0d13          	addi	s10,s10,-1146 # 7538 <malloc+0x228e>
    49ba:	a025                	j	49e2 <drivetests+0x76>
      if (continuous != 2) {
    49bc:	09699063          	bne	s3,s6,4a3c <drivetests+0xd0>
    int ntests = 0;
    49c0:	4481                	li	s1,0
    49c2:	a835                	j	49fe <drivetests+0x92>
        printf("usertests slow tests starting\n");
    49c4:	856e                	mv	a0,s11
    49c6:	031000ef          	jal	51f6 <printf>
    49ca:	a835                	j	4a06 <drivetests+0x9a>
        if (continuous != 2) {
    49cc:	07699a63          	bne	s3,s6,4a40 <drivetests+0xd4>
    if ((free1 = countfree()) < free0) {
    49d0:	f57ff0ef          	jal	4926 <countfree>
    49d4:	05254263          	blt	a0,s2,4a18 <drivetests+0xac>
      if (continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    49d8:	000a0363          	beqz	s4,49de <drivetests+0x72>
    49dc:	c8a1                	beqz	s1,4a2c <drivetests+0xc0>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while (continuous);
    49de:	06098563          	beqz	s3,4a48 <drivetests+0xdc>
    printf("usertests starting\n");
    49e2:	8562                	mv	a0,s8
    49e4:	013000ef          	jal	51f6 <printf>
    int free0 = countfree();
    49e8:	f3fff0ef          	jal	4926 <countfree>
    49ec:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    49ee:	864e                	mv	a2,s3
    49f0:	85d2                	mv	a1,s4
    49f2:	855e                	mv	a0,s7
    49f4:	ec1ff0ef          	jal	48b4 <runtests>
    49f8:	84aa                	mv	s1,a0
    if (n < 0) {
    49fa:	fc0541e3          	bltz	a0,49bc <drivetests+0x50>
    if (!quick) {
    49fe:	fc0a99e3          	bnez	s5,49d0 <drivetests+0x64>
      if (justone == 0)
    4a02:	fc0a01e3          	beqz	s4,49c4 <drivetests+0x58>
      n = runtests(slowtests, justone, continuous);
    4a06:	864e                	mv	a2,s3
    4a08:	85d2                	mv	a1,s4
    4a0a:	8566                	mv	a0,s9
    4a0c:	ea9ff0ef          	jal	48b4 <runtests>
      if (n < 0) {
    4a10:	fa054ee3          	bltz	a0,49cc <drivetests+0x60>
        ntests += n;
    4a14:	9ca9                	addw	s1,s1,a0
    4a16:	bf6d                	j	49d0 <drivetests+0x64>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4a18:	864a                	mv	a2,s2
    4a1a:	85aa                	mv	a1,a0
    4a1c:	856a                	mv	a0,s10
    4a1e:	7d8000ef          	jal	51f6 <printf>
      if (continuous != 2) {
    4a22:	03699163          	bne	s3,s6,4a44 <drivetests+0xd8>
    if (justone != 0 && ntests == 0) {
    4a26:	fa0a1be3          	bnez	s4,49dc <drivetests+0x70>
    4a2a:	bf65                	j	49e2 <drivetests+0x76>
      printf("NO TESTS EXECUTED\n");
    4a2c:	00003517          	auipc	a0,0x3
    4a30:	b3c50513          	addi	a0,a0,-1220 # 7568 <malloc+0x22be>
    4a34:	7c2000ef          	jal	51f6 <printf>
      return 1;
    4a38:	4505                	li	a0,1
    4a3a:	a801                	j	4a4a <drivetests+0xde>
        return 1;
    4a3c:	4505                	li	a0,1
    4a3e:	a031                	j	4a4a <drivetests+0xde>
          return 1;
    4a40:	4505                	li	a0,1
    4a42:	a021                	j	4a4a <drivetests+0xde>
        return 1;
    4a44:	4505                	li	a0,1
    4a46:	a011                	j	4a4a <drivetests+0xde>
  return 0;
    4a48:	854e                	mv	a0,s3
}
    4a4a:	70a6                	ld	ra,104(sp)
    4a4c:	7406                	ld	s0,96(sp)
    4a4e:	64e6                	ld	s1,88(sp)
    4a50:	6946                	ld	s2,80(sp)
    4a52:	69a6                	ld	s3,72(sp)
    4a54:	6a06                	ld	s4,64(sp)
    4a56:	7ae2                	ld	s5,56(sp)
    4a58:	7b42                	ld	s6,48(sp)
    4a5a:	7ba2                	ld	s7,40(sp)
    4a5c:	7c02                	ld	s8,32(sp)
    4a5e:	6ce2                	ld	s9,24(sp)
    4a60:	6d42                	ld	s10,16(sp)
    4a62:	6da2                	ld	s11,8(sp)
    4a64:	6165                	addi	sp,sp,112
    4a66:	8082                	ret

0000000000004a68 <main>:

int
main(int argc, char *argv[])
{
    4a68:	1101                	addi	sp,sp,-32
    4a6a:	ec06                	sd	ra,24(sp)
    4a6c:	e822                	sd	s0,16(sp)
    4a6e:	e426                	sd	s1,8(sp)
    4a70:	e04a                	sd	s2,0(sp)
    4a72:	1000                	addi	s0,sp,32
    4a74:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    4a76:	4789                	li	a5,2
    4a78:	00f50e63          	beq	a0,a5,4a94 <main+0x2c>
    continuous = 1;
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    continuous = 2;
  } else if (argc == 2 && argv[1][0] != '-') {
    justone = argv[1];
  } else if (argc > 1) {
    4a7c:	4785                	li	a5,1
    4a7e:	06a7c663          	blt	a5,a0,4aea <main+0x82>
  char *justone = 0;
    4a82:	4601                	li	a2,0
  int quick = 0;
    4a84:	4501                	li	a0,0
  int continuous = 0;
    4a86:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    4a88:	ee5ff0ef          	jal	496c <drivetests>
    4a8c:	cd35                	beqz	a0,4b08 <main+0xa0>
    exit(1);
    4a8e:	4505                	li	a0,1
    4a90:	31e000ef          	jal	4dae <exit>
    4a94:	892e                	mv	s2,a1
  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    4a96:	00003597          	auipc	a1,0x3
    4a9a:	aea58593          	addi	a1,a1,-1302 # 7580 <malloc+0x22d6>
    4a9e:	00893503          	ld	a0,8(s2) # ffffffffffffd008 <base+0xfffffffffffed350>
    4aa2:	0a4000ef          	jal	4b46 <strcmp>
    4aa6:	85aa                	mv	a1,a0
    4aa8:	e501                	bnez	a0,4ab0 <main+0x48>
  char *justone = 0;
    4aaa:	4601                	li	a2,0
    quick = 1;
    4aac:	4505                	li	a0,1
    4aae:	bfe9                	j	4a88 <main+0x20>
  } else if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    4ab0:	00003597          	auipc	a1,0x3
    4ab4:	ad858593          	addi	a1,a1,-1320 # 7588 <malloc+0x22de>
    4ab8:	00893503          	ld	a0,8(s2)
    4abc:	08a000ef          	jal	4b46 <strcmp>
    4ac0:	cd15                	beqz	a0,4afc <main+0x94>
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    4ac2:	00003597          	auipc	a1,0x3
    4ac6:	b1658593          	addi	a1,a1,-1258 # 75d8 <malloc+0x232e>
    4aca:	00893503          	ld	a0,8(s2)
    4ace:	078000ef          	jal	4b46 <strcmp>
    4ad2:	c905                	beqz	a0,4b02 <main+0x9a>
  } else if (argc == 2 && argv[1][0] != '-') {
    4ad4:	00893603          	ld	a2,8(s2)
    4ad8:	00064703          	lbu	a4,0(a2) # 1000 <badarg>
    4adc:	02d00793          	li	a5,45
    4ae0:	00f70563          	beq	a4,a5,4aea <main+0x82>
  int quick = 0;
    4ae4:	4501                	li	a0,0
  int continuous = 0;
    4ae6:	4581                	li	a1,0
    4ae8:	b745                	j	4a88 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4aea:	00003517          	auipc	a0,0x3
    4aee:	aa650513          	addi	a0,a0,-1370 # 7590 <malloc+0x22e6>
    4af2:	704000ef          	jal	51f6 <printf>
    exit(1);
    4af6:	4505                	li	a0,1
    4af8:	2b6000ef          	jal	4dae <exit>
  char *justone = 0;
    4afc:	4601                	li	a2,0
    continuous = 1;
    4afe:	4585                	li	a1,1
    4b00:	b761                	j	4a88 <main+0x20>
    continuous = 2;
    4b02:	85a6                	mv	a1,s1
  char *justone = 0;
    4b04:	4601                	li	a2,0
    4b06:	b749                	j	4a88 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4b08:	00003517          	auipc	a0,0x3
    4b0c:	ab850513          	addi	a0,a0,-1352 # 75c0 <malloc+0x2316>
    4b10:	6e6000ef          	jal	51f6 <printf>
  exit(0);
    4b14:	4501                	li	a0,0
    4b16:	298000ef          	jal	4dae <exit>

0000000000004b1a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    4b1a:	1141                	addi	sp,sp,-16
    4b1c:	e406                	sd	ra,8(sp)
    4b1e:	e022                	sd	s0,0(sp)
    4b20:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    4b22:	f47ff0ef          	jal	4a68 <main>
  exit(r);
    4b26:	288000ef          	jal	4dae <exit>

0000000000004b2a <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
    4b2a:	1141                	addi	sp,sp,-16
    4b2c:	e422                	sd	s0,8(sp)
    4b2e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
    4b30:	87aa                	mv	a5,a0
    4b32:	0585                	addi	a1,a1,1
    4b34:	0785                	addi	a5,a5,1
    4b36:	fff5c703          	lbu	a4,-1(a1)
    4b3a:	fee78fa3          	sb	a4,-1(a5)
    4b3e:	fb75                	bnez	a4,4b32 <strcpy+0x8>
    ;
  return os;
}
    4b40:	6422                	ld	s0,8(sp)
    4b42:	0141                	addi	sp,sp,16
    4b44:	8082                	ret

0000000000004b46 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4b46:	1141                	addi	sp,sp,-16
    4b48:	e422                	sd	s0,8(sp)
    4b4a:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
    4b4c:	00054783          	lbu	a5,0(a0)
    4b50:	cb91                	beqz	a5,4b64 <strcmp+0x1e>
    4b52:	0005c703          	lbu	a4,0(a1)
    4b56:	00f71763          	bne	a4,a5,4b64 <strcmp+0x1e>
    p++, q++;
    4b5a:	0505                	addi	a0,a0,1
    4b5c:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
    4b5e:	00054783          	lbu	a5,0(a0)
    4b62:	fbe5                	bnez	a5,4b52 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    4b64:	0005c503          	lbu	a0,0(a1)
}
    4b68:	40a7853b          	subw	a0,a5,a0
    4b6c:	6422                	ld	s0,8(sp)
    4b6e:	0141                	addi	sp,sp,16
    4b70:	8082                	ret

0000000000004b72 <strlen>:

uint
strlen(const char *s)
{
    4b72:	1141                	addi	sp,sp,-16
    4b74:	e422                	sd	s0,8(sp)
    4b76:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    4b78:	00054783          	lbu	a5,0(a0)
    4b7c:	cf91                	beqz	a5,4b98 <strlen+0x26>
    4b7e:	0505                	addi	a0,a0,1
    4b80:	87aa                	mv	a5,a0
    4b82:	86be                	mv	a3,a5
    4b84:	0785                	addi	a5,a5,1
    4b86:	fff7c703          	lbu	a4,-1(a5)
    4b8a:	ff65                	bnez	a4,4b82 <strlen+0x10>
    4b8c:	40a6853b          	subw	a0,a3,a0
    4b90:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    4b92:	6422                	ld	s0,8(sp)
    4b94:	0141                	addi	sp,sp,16
    4b96:	8082                	ret
  for (n = 0; s[n]; n++)
    4b98:	4501                	li	a0,0
    4b9a:	bfe5                	j	4b92 <strlen+0x20>

0000000000004b9c <memset>:

void *
memset(void *dst, int c, uint n)
{
    4b9c:	1141                	addi	sp,sp,-16
    4b9e:	e422                	sd	s0,8(sp)
    4ba0:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    4ba2:	ca19                	beqz	a2,4bb8 <memset+0x1c>
    4ba4:	87aa                	mv	a5,a0
    4ba6:	1602                	slli	a2,a2,0x20
    4ba8:	9201                	srli	a2,a2,0x20
    4baa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4bae:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    4bb2:	0785                	addi	a5,a5,1
    4bb4:	fee79de3          	bne	a5,a4,4bae <memset+0x12>
  }
  return dst;
}
    4bb8:	6422                	ld	s0,8(sp)
    4bba:	0141                	addi	sp,sp,16
    4bbc:	8082                	ret

0000000000004bbe <strchr>:

char *
strchr(const char *s, char c)
{
    4bbe:	1141                	addi	sp,sp,-16
    4bc0:	e422                	sd	s0,8(sp)
    4bc2:	0800                	addi	s0,sp,16
  for (; *s; s++)
    4bc4:	00054783          	lbu	a5,0(a0)
    4bc8:	cb99                	beqz	a5,4bde <strchr+0x20>
    if (*s == c)
    4bca:	00f58763          	beq	a1,a5,4bd8 <strchr+0x1a>
  for (; *s; s++)
    4bce:	0505                	addi	a0,a0,1
    4bd0:	00054783          	lbu	a5,0(a0)
    4bd4:	fbfd                	bnez	a5,4bca <strchr+0xc>
      return (char *)s;
  return 0;
    4bd6:	4501                	li	a0,0
}
    4bd8:	6422                	ld	s0,8(sp)
    4bda:	0141                	addi	sp,sp,16
    4bdc:	8082                	ret
  return 0;
    4bde:	4501                	li	a0,0
    4be0:	bfe5                	j	4bd8 <strchr+0x1a>

0000000000004be2 <gets>:

char *
gets(char *buf, int max)
{
    4be2:	711d                	addi	sp,sp,-96
    4be4:	ec86                	sd	ra,88(sp)
    4be6:	e8a2                	sd	s0,80(sp)
    4be8:	e4a6                	sd	s1,72(sp)
    4bea:	e0ca                	sd	s2,64(sp)
    4bec:	fc4e                	sd	s3,56(sp)
    4bee:	f852                	sd	s4,48(sp)
    4bf0:	f456                	sd	s5,40(sp)
    4bf2:	f05a                	sd	s6,32(sp)
    4bf4:	ec5e                	sd	s7,24(sp)
    4bf6:	1080                	addi	s0,sp,96
    4bf8:	8baa                	mv	s7,a0
    4bfa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
    4bfc:	892a                	mv	s2,a0
    4bfe:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
    4c00:	4aa9                	li	s5,10
    4c02:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
    4c04:	89a6                	mv	s3,s1
    4c06:	2485                	addiw	s1,s1,1
    4c08:	0344d663          	bge	s1,s4,4c34 <gets+0x52>
    cc = read(0, &c, 1);
    4c0c:	4605                	li	a2,1
    4c0e:	faf40593          	addi	a1,s0,-81
    4c12:	4501                	li	a0,0
    4c14:	1b2000ef          	jal	4dc6 <read>
    if (cc < 1)
    4c18:	00a05e63          	blez	a0,4c34 <gets+0x52>
    buf[i++] = c;
    4c1c:	faf44783          	lbu	a5,-81(s0)
    4c20:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
    4c24:	01578763          	beq	a5,s5,4c32 <gets+0x50>
    4c28:	0905                	addi	s2,s2,1
    4c2a:	fd679de3          	bne	a5,s6,4c04 <gets+0x22>
    buf[i++] = c;
    4c2e:	89a6                	mv	s3,s1
    4c30:	a011                	j	4c34 <gets+0x52>
    4c32:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    4c34:	99de                	add	s3,s3,s7
    4c36:	00098023          	sb	zero,0(s3)
  return buf;
}
    4c3a:	855e                	mv	a0,s7
    4c3c:	60e6                	ld	ra,88(sp)
    4c3e:	6446                	ld	s0,80(sp)
    4c40:	64a6                	ld	s1,72(sp)
    4c42:	6906                	ld	s2,64(sp)
    4c44:	79e2                	ld	s3,56(sp)
    4c46:	7a42                	ld	s4,48(sp)
    4c48:	7aa2                	ld	s5,40(sp)
    4c4a:	7b02                	ld	s6,32(sp)
    4c4c:	6be2                	ld	s7,24(sp)
    4c4e:	6125                	addi	sp,sp,96
    4c50:	8082                	ret

0000000000004c52 <stat>:

int
stat(const char *n, struct stat *st)
{
    4c52:	1101                	addi	sp,sp,-32
    4c54:	ec06                	sd	ra,24(sp)
    4c56:	e822                	sd	s0,16(sp)
    4c58:	e04a                	sd	s2,0(sp)
    4c5a:	1000                	addi	s0,sp,32
    4c5c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4c5e:	4581                	li	a1,0
    4c60:	18e000ef          	jal	4dee <open>
  if (fd < 0)
    4c64:	02054263          	bltz	a0,4c88 <stat+0x36>
    4c68:	e426                	sd	s1,8(sp)
    4c6a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4c6c:	85ca                	mv	a1,s2
    4c6e:	198000ef          	jal	4e06 <fstat>
    4c72:	892a                	mv	s2,a0
  close(fd);
    4c74:	8526                	mv	a0,s1
    4c76:	160000ef          	jal	4dd6 <close>
  return r;
    4c7a:	64a2                	ld	s1,8(sp)
}
    4c7c:	854a                	mv	a0,s2
    4c7e:	60e2                	ld	ra,24(sp)
    4c80:	6442                	ld	s0,16(sp)
    4c82:	6902                	ld	s2,0(sp)
    4c84:	6105                	addi	sp,sp,32
    4c86:	8082                	ret
    return -1;
    4c88:	597d                	li	s2,-1
    4c8a:	bfcd                	j	4c7c <stat+0x2a>

0000000000004c8c <atoi>:

int
atoi(const char *s)
{
    4c8c:	1141                	addi	sp,sp,-16
    4c8e:	e422                	sd	s0,8(sp)
    4c90:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
    4c92:	00054683          	lbu	a3,0(a0)
    4c96:	fd06879b          	addiw	a5,a3,-48 # 3ffd0 <base+0x30318>
    4c9a:	0ff7f793          	zext.b	a5,a5
    4c9e:	4625                	li	a2,9
    4ca0:	02f66863          	bltu	a2,a5,4cd0 <atoi+0x44>
    4ca4:	872a                	mv	a4,a0
  n = 0;
    4ca6:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
    4ca8:	0705                	addi	a4,a4,1 # 1000001 <base+0xff0349>
    4caa:	0025179b          	slliw	a5,a0,0x2
    4cae:	9fa9                	addw	a5,a5,a0
    4cb0:	0017979b          	slliw	a5,a5,0x1
    4cb4:	9fb5                	addw	a5,a5,a3
    4cb6:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
    4cba:	00074683          	lbu	a3,0(a4)
    4cbe:	fd06879b          	addiw	a5,a3,-48
    4cc2:	0ff7f793          	zext.b	a5,a5
    4cc6:	fef671e3          	bgeu	a2,a5,4ca8 <atoi+0x1c>
  return n;
}
    4cca:	6422                	ld	s0,8(sp)
    4ccc:	0141                	addi	sp,sp,16
    4cce:	8082                	ret
  n = 0;
    4cd0:	4501                	li	a0,0
    4cd2:	bfe5                	j	4cca <atoi+0x3e>

0000000000004cd4 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
    4cd4:	1141                	addi	sp,sp,-16
    4cd6:	e422                	sd	s0,8(sp)
    4cd8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4cda:	02b57463          	bgeu	a0,a1,4d02 <memmove+0x2e>
    while (n-- > 0)
    4cde:	00c05f63          	blez	a2,4cfc <memmove+0x28>
    4ce2:	1602                	slli	a2,a2,0x20
    4ce4:	9201                	srli	a2,a2,0x20
    4ce6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4cea:	872a                	mv	a4,a0
      *dst++ = *src++;
    4cec:	0585                	addi	a1,a1,1
    4cee:	0705                	addi	a4,a4,1
    4cf0:	fff5c683          	lbu	a3,-1(a1)
    4cf4:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    4cf8:	fef71ae3          	bne	a4,a5,4cec <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4cfc:	6422                	ld	s0,8(sp)
    4cfe:	0141                	addi	sp,sp,16
    4d00:	8082                	ret
    dst += n;
    4d02:	00c50733          	add	a4,a0,a2
    src += n;
    4d06:	95b2                	add	a1,a1,a2
    while (n-- > 0)
    4d08:	fec05ae3          	blez	a2,4cfc <memmove+0x28>
    4d0c:	fff6079b          	addiw	a5,a2,-1
    4d10:	1782                	slli	a5,a5,0x20
    4d12:	9381                	srli	a5,a5,0x20
    4d14:	fff7c793          	not	a5,a5
    4d18:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4d1a:	15fd                	addi	a1,a1,-1
    4d1c:	177d                	addi	a4,a4,-1
    4d1e:	0005c683          	lbu	a3,0(a1)
    4d22:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
    4d26:	fee79ae3          	bne	a5,a4,4d1a <memmove+0x46>
    4d2a:	bfc9                	j	4cfc <memmove+0x28>

0000000000004d2c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4d2c:	1141                	addi	sp,sp,-16
    4d2e:	e422                	sd	s0,8(sp)
    4d30:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4d32:	ca05                	beqz	a2,4d62 <memcmp+0x36>
    4d34:	fff6069b          	addiw	a3,a2,-1
    4d38:	1682                	slli	a3,a3,0x20
    4d3a:	9281                	srli	a3,a3,0x20
    4d3c:	0685                	addi	a3,a3,1
    4d3e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    4d40:	00054783          	lbu	a5,0(a0)
    4d44:	0005c703          	lbu	a4,0(a1)
    4d48:	00e79863          	bne	a5,a4,4d58 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    4d4c:	0505                	addi	a0,a0,1
    p2++;
    4d4e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4d50:	fed518e3          	bne	a0,a3,4d40 <memcmp+0x14>
  }
  return 0;
    4d54:	4501                	li	a0,0
    4d56:	a019                	j	4d5c <memcmp+0x30>
      return *p1 - *p2;
    4d58:	40e7853b          	subw	a0,a5,a4
}
    4d5c:	6422                	ld	s0,8(sp)
    4d5e:	0141                	addi	sp,sp,16
    4d60:	8082                	ret
  return 0;
    4d62:	4501                	li	a0,0
    4d64:	bfe5                	j	4d5c <memcmp+0x30>

0000000000004d66 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4d66:	1141                	addi	sp,sp,-16
    4d68:	e406                	sd	ra,8(sp)
    4d6a:	e022                	sd	s0,0(sp)
    4d6c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4d6e:	f67ff0ef          	jal	4cd4 <memmove>
}
    4d72:	60a2                	ld	ra,8(sp)
    4d74:	6402                	ld	s0,0(sp)
    4d76:	0141                	addi	sp,sp,16
    4d78:	8082                	ret

0000000000004d7a <sbrk>:

char *
sbrk(int n)
{
    4d7a:	1141                	addi	sp,sp,-16
    4d7c:	e406                	sd	ra,8(sp)
    4d7e:	e022                	sd	s0,0(sp)
    4d80:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    4d82:	4585                	li	a1,1
    4d84:	0b2000ef          	jal	4e36 <sys_sbrk>
}
    4d88:	60a2                	ld	ra,8(sp)
    4d8a:	6402                	ld	s0,0(sp)
    4d8c:	0141                	addi	sp,sp,16
    4d8e:	8082                	ret

0000000000004d90 <sbrklazy>:

char *
sbrklazy(int n)
{
    4d90:	1141                	addi	sp,sp,-16
    4d92:	e406                	sd	ra,8(sp)
    4d94:	e022                	sd	s0,0(sp)
    4d96:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    4d98:	4589                	li	a1,2
    4d9a:	09c000ef          	jal	4e36 <sys_sbrk>
}
    4d9e:	60a2                	ld	ra,8(sp)
    4da0:	6402                	ld	s0,0(sp)
    4da2:	0141                	addi	sp,sp,16
    4da4:	8082                	ret

0000000000004da6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4da6:	4885                	li	a7,1
 ecall
    4da8:	00000073          	ecall
 ret
    4dac:	8082                	ret

0000000000004dae <exit>:
.global exit
exit:
 li a7, SYS_exit
    4dae:	4889                	li	a7,2
 ecall
    4db0:	00000073          	ecall
 ret
    4db4:	8082                	ret

0000000000004db6 <wait>:
.global wait
wait:
 li a7, SYS_wait
    4db6:	488d                	li	a7,3
 ecall
    4db8:	00000073          	ecall
 ret
    4dbc:	8082                	ret

0000000000004dbe <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4dbe:	4891                	li	a7,4
 ecall
    4dc0:	00000073          	ecall
 ret
    4dc4:	8082                	ret

0000000000004dc6 <read>:
.global read
read:
 li a7, SYS_read
    4dc6:	4895                	li	a7,5
 ecall
    4dc8:	00000073          	ecall
 ret
    4dcc:	8082                	ret

0000000000004dce <write>:
.global write
write:
 li a7, SYS_write
    4dce:	48c1                	li	a7,16
 ecall
    4dd0:	00000073          	ecall
 ret
    4dd4:	8082                	ret

0000000000004dd6 <close>:
.global close
close:
 li a7, SYS_close
    4dd6:	48d5                	li	a7,21
 ecall
    4dd8:	00000073          	ecall
 ret
    4ddc:	8082                	ret

0000000000004dde <kill>:
.global kill
kill:
 li a7, SYS_kill
    4dde:	4899                	li	a7,6
 ecall
    4de0:	00000073          	ecall
 ret
    4de4:	8082                	ret

0000000000004de6 <exec>:
.global exec
exec:
 li a7, SYS_exec
    4de6:	489d                	li	a7,7
 ecall
    4de8:	00000073          	ecall
 ret
    4dec:	8082                	ret

0000000000004dee <open>:
.global open
open:
 li a7, SYS_open
    4dee:	48bd                	li	a7,15
 ecall
    4df0:	00000073          	ecall
 ret
    4df4:	8082                	ret

0000000000004df6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4df6:	48c5                	li	a7,17
 ecall
    4df8:	00000073          	ecall
 ret
    4dfc:	8082                	ret

0000000000004dfe <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4dfe:	48c9                	li	a7,18
 ecall
    4e00:	00000073          	ecall
 ret
    4e04:	8082                	ret

0000000000004e06 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4e06:	48a1                	li	a7,8
 ecall
    4e08:	00000073          	ecall
 ret
    4e0c:	8082                	ret

0000000000004e0e <link>:
.global link
link:
 li a7, SYS_link
    4e0e:	48cd                	li	a7,19
 ecall
    4e10:	00000073          	ecall
 ret
    4e14:	8082                	ret

0000000000004e16 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4e16:	48d1                	li	a7,20
 ecall
    4e18:	00000073          	ecall
 ret
    4e1c:	8082                	ret

0000000000004e1e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4e1e:	48a5                	li	a7,9
 ecall
    4e20:	00000073          	ecall
 ret
    4e24:	8082                	ret

0000000000004e26 <dup>:
.global dup
dup:
 li a7, SYS_dup
    4e26:	48a9                	li	a7,10
 ecall
    4e28:	00000073          	ecall
 ret
    4e2c:	8082                	ret

0000000000004e2e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4e2e:	48ad                	li	a7,11
 ecall
    4e30:	00000073          	ecall
 ret
    4e34:	8082                	ret

0000000000004e36 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    4e36:	48b1                	li	a7,12
 ecall
    4e38:	00000073          	ecall
 ret
    4e3c:	8082                	ret

0000000000004e3e <pause>:
.global pause
pause:
 li a7, SYS_pause
    4e3e:	48b5                	li	a7,13
 ecall
    4e40:	00000073          	ecall
 ret
    4e44:	8082                	ret

0000000000004e46 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4e46:	48b9                	li	a7,14
 ecall
    4e48:	00000073          	ecall
 ret
    4e4c:	8082                	ret

0000000000004e4e <sync>:
.global sync
sync:
 li a7, SYS_sync
    4e4e:	48d9                	li	a7,22
 ecall
    4e50:	00000073          	ecall
 ret
    4e54:	8082                	ret

0000000000004e56 <getwaittime>:
.global getwaittime
getwaittime:
 li a7, SYS_getwaittime
    4e56:	48dd                	li	a7,23
 ecall
    4e58:	00000073          	ecall
 ret
    4e5c:	8082                	ret

0000000000004e5e <setburst>:
.global setburst
setburst:
 li a7, SYS_setburst
    4e5e:	48e1                	li	a7,24
 ecall
    4e60:	00000073          	ecall
 ret
    4e64:	8082                	ret

0000000000004e66 <setburstpid>:
.global setburstpid
setburstpid:
 li a7, SYS_setburstpid
    4e66:	48e5                	li	a7,25
 ecall
    4e68:	00000073          	ecall
 ret
    4e6c:	8082                	ret

0000000000004e6e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4e6e:	1101                	addi	sp,sp,-32
    4e70:	ec06                	sd	ra,24(sp)
    4e72:	e822                	sd	s0,16(sp)
    4e74:	1000                	addi	s0,sp,32
    4e76:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4e7a:	4605                	li	a2,1
    4e7c:	fef40593          	addi	a1,s0,-17
    4e80:	f4fff0ef          	jal	4dce <write>
}
    4e84:	60e2                	ld	ra,24(sp)
    4e86:	6442                	ld	s0,16(sp)
    4e88:	6105                	addi	sp,sp,32
    4e8a:	8082                	ret

0000000000004e8c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    4e8c:	715d                	addi	sp,sp,-80
    4e8e:	e486                	sd	ra,72(sp)
    4e90:	e0a2                	sd	s0,64(sp)
    4e92:	f84a                	sd	s2,48(sp)
    4e94:	0880                	addi	s0,sp,80
    4e96:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
    4e98:	c299                	beqz	a3,4e9e <printint+0x12>
    4e9a:	0805c363          	bltz	a1,4f20 <printint+0x94>
  neg = 0;
    4e9e:	4881                	li	a7,0
    4ea0:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    4ea4:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    4ea6:	00003517          	auipc	a0,0x3
    4eaa:	b6250513          	addi	a0,a0,-1182 # 7a08 <digits>
    4eae:	883e                	mv	a6,a5
    4eb0:	2785                	addiw	a5,a5,1
    4eb2:	02c5f733          	remu	a4,a1,a2
    4eb6:	972a                	add	a4,a4,a0
    4eb8:	00074703          	lbu	a4,0(a4)
    4ebc:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
    4ec0:	872e                	mv	a4,a1
    4ec2:	02c5d5b3          	divu	a1,a1,a2
    4ec6:	0685                	addi	a3,a3,1
    4ec8:	fec773e3          	bgeu	a4,a2,4eae <printint+0x22>
  if (neg)
    4ecc:	00088b63          	beqz	a7,4ee2 <printint+0x56>
    buf[i++] = '-';
    4ed0:	fd078793          	addi	a5,a5,-48
    4ed4:	97a2                	add	a5,a5,s0
    4ed6:	02d00713          	li	a4,45
    4eda:	fee78423          	sb	a4,-24(a5)
    4ede:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
    4ee2:	02f05a63          	blez	a5,4f16 <printint+0x8a>
    4ee6:	fc26                	sd	s1,56(sp)
    4ee8:	f44e                	sd	s3,40(sp)
    4eea:	fb840713          	addi	a4,s0,-72
    4eee:	00f704b3          	add	s1,a4,a5
    4ef2:	fff70993          	addi	s3,a4,-1
    4ef6:	99be                	add	s3,s3,a5
    4ef8:	37fd                	addiw	a5,a5,-1
    4efa:	1782                	slli	a5,a5,0x20
    4efc:	9381                	srli	a5,a5,0x20
    4efe:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
    4f02:	fff4c583          	lbu	a1,-1(s1)
    4f06:	854a                	mv	a0,s2
    4f08:	f67ff0ef          	jal	4e6e <putc>
  while (--i >= 0)
    4f0c:	14fd                	addi	s1,s1,-1
    4f0e:	ff349ae3          	bne	s1,s3,4f02 <printint+0x76>
    4f12:	74e2                	ld	s1,56(sp)
    4f14:	79a2                	ld	s3,40(sp)
}
    4f16:	60a6                	ld	ra,72(sp)
    4f18:	6406                	ld	s0,64(sp)
    4f1a:	7942                	ld	s2,48(sp)
    4f1c:	6161                	addi	sp,sp,80
    4f1e:	8082                	ret
    x = -xx;
    4f20:	40b005b3          	neg	a1,a1
    neg = 1;
    4f24:	4885                	li	a7,1
    x = -xx;
    4f26:	bfad                	j	4ea0 <printint+0x14>

0000000000004f28 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4f28:	711d                	addi	sp,sp,-96
    4f2a:	ec86                	sd	ra,88(sp)
    4f2c:	e8a2                	sd	s0,80(sp)
    4f2e:	e0ca                	sd	s2,64(sp)
    4f30:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
    4f32:	0005c903          	lbu	s2,0(a1)
    4f36:	28090663          	beqz	s2,51c2 <vprintf+0x29a>
    4f3a:	e4a6                	sd	s1,72(sp)
    4f3c:	fc4e                	sd	s3,56(sp)
    4f3e:	f852                	sd	s4,48(sp)
    4f40:	f456                	sd	s5,40(sp)
    4f42:	f05a                	sd	s6,32(sp)
    4f44:	ec5e                	sd	s7,24(sp)
    4f46:	e862                	sd	s8,16(sp)
    4f48:	e466                	sd	s9,8(sp)
    4f4a:	8b2a                	mv	s6,a0
    4f4c:	8a2e                	mv	s4,a1
    4f4e:	8bb2                	mv	s7,a2
  state = 0;
    4f50:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
    4f52:	4481                	li	s1,0
    4f54:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
    4f56:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
    4f5a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
    4f5e:	06c00c93          	li	s9,108
    4f62:	a005                	j	4f82 <vprintf+0x5a>
        putc(fd, c0);
    4f64:	85ca                	mv	a1,s2
    4f66:	855a                	mv	a0,s6
    4f68:	f07ff0ef          	jal	4e6e <putc>
    4f6c:	a019                	j	4f72 <vprintf+0x4a>
    } else if (state == '%') {
    4f6e:	03598263          	beq	s3,s5,4f92 <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
    4f72:	2485                	addiw	s1,s1,1
    4f74:	8726                	mv	a4,s1
    4f76:	009a07b3          	add	a5,s4,s1
    4f7a:	0007c903          	lbu	s2,0(a5)
    4f7e:	22090a63          	beqz	s2,51b2 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
    4f82:	0009079b          	sext.w	a5,s2
    if (state == 0) {
    4f86:	fe0994e3          	bnez	s3,4f6e <vprintf+0x46>
      if (c0 == '%') {
    4f8a:	fd579de3          	bne	a5,s5,4f64 <vprintf+0x3c>
        state = '%';
    4f8e:	89be                	mv	s3,a5
    4f90:	b7cd                	j	4f72 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
    4f92:	00ea06b3          	add	a3,s4,a4
    4f96:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4f9a:	8636                	mv	a2,a3
      if (c1)
    4f9c:	c681                	beqz	a3,4fa4 <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
    4f9e:	9752                	add	a4,a4,s4
    4fa0:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
    4fa4:	05878363          	beq	a5,s8,4fea <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
    4fa8:	05978d63          	beq	a5,s9,5002 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
    4fac:	07500713          	li	a4,117
    4fb0:	0ee78763          	beq	a5,a4,509e <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
    4fb4:	07800713          	li	a4,120
    4fb8:	12e78963          	beq	a5,a4,50ea <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
    4fbc:	07000713          	li	a4,112
    4fc0:	14e78e63          	beq	a5,a4,511c <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
    4fc4:	06300713          	li	a4,99
    4fc8:	18e78e63          	beq	a5,a4,5164 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
    4fcc:	07300713          	li	a4,115
    4fd0:	1ae78463          	beq	a5,a4,5178 <vprintf+0x250>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
    4fd4:	02500713          	li	a4,37
    4fd8:	04e79563          	bne	a5,a4,5022 <vprintf+0xfa>
        putc(fd, '%');
    4fdc:	02500593          	li	a1,37
    4fe0:	855a                	mv	a0,s6
    4fe2:	e8dff0ef          	jal	4e6e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    4fe6:	4981                	li	s3,0
    4fe8:	b769                	j	4f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    4fea:	008b8913          	addi	s2,s7,8
    4fee:	4685                	li	a3,1
    4ff0:	4629                	li	a2,10
    4ff2:	000ba583          	lw	a1,0(s7)
    4ff6:	855a                	mv	a0,s6
    4ff8:	e95ff0ef          	jal	4e8c <printint>
    4ffc:	8bca                	mv	s7,s2
      state = 0;
    4ffe:	4981                	li	s3,0
    5000:	bf8d                	j	4f72 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
    5002:	06400793          	li	a5,100
    5006:	02f68963          	beq	a3,a5,5038 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    500a:	06c00793          	li	a5,108
    500e:	04f68263          	beq	a3,a5,5052 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
    5012:	07500793          	li	a5,117
    5016:	0af68063          	beq	a3,a5,50b6 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
    501a:	07800793          	li	a5,120
    501e:	0ef68263          	beq	a3,a5,5102 <vprintf+0x1da>
        putc(fd, '%');
    5022:	02500593          	li	a1,37
    5026:	855a                	mv	a0,s6
    5028:	e47ff0ef          	jal	4e6e <putc>
        putc(fd, c0);
    502c:	85ca                	mv	a1,s2
    502e:	855a                	mv	a0,s6
    5030:	e3fff0ef          	jal	4e6e <putc>
      state = 0;
    5034:	4981                	li	s3,0
    5036:	bf35                	j	4f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5038:	008b8913          	addi	s2,s7,8
    503c:	4685                	li	a3,1
    503e:	4629                	li	a2,10
    5040:	000bb583          	ld	a1,0(s7)
    5044:	855a                	mv	a0,s6
    5046:	e47ff0ef          	jal	4e8c <printint>
        i += 1;
    504a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    504c:	8bca                	mv	s7,s2
      state = 0;
    504e:	4981                	li	s3,0
        i += 1;
    5050:	b70d                	j	4f72 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    5052:	06400793          	li	a5,100
    5056:	02f60763          	beq	a2,a5,5084 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    505a:	07500793          	li	a5,117
    505e:	06f60963          	beq	a2,a5,50d0 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    5062:	07800793          	li	a5,120
    5066:	faf61ee3          	bne	a2,a5,5022 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
    506a:	008b8913          	addi	s2,s7,8
    506e:	4681                	li	a3,0
    5070:	4641                	li	a2,16
    5072:	000bb583          	ld	a1,0(s7)
    5076:	855a                	mv	a0,s6
    5078:	e15ff0ef          	jal	4e8c <printint>
        i += 2;
    507c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    507e:	8bca                	mv	s7,s2
      state = 0;
    5080:	4981                	li	s3,0
        i += 2;
    5082:	bdc5                	j	4f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5084:	008b8913          	addi	s2,s7,8
    5088:	4685                	li	a3,1
    508a:	4629                	li	a2,10
    508c:	000bb583          	ld	a1,0(s7)
    5090:	855a                	mv	a0,s6
    5092:	dfbff0ef          	jal	4e8c <printint>
        i += 2;
    5096:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    5098:	8bca                	mv	s7,s2
      state = 0;
    509a:	4981                	li	s3,0
        i += 2;
    509c:	bdd9                	j	4f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
    509e:	008b8913          	addi	s2,s7,8
    50a2:	4681                	li	a3,0
    50a4:	4629                	li	a2,10
    50a6:	000be583          	lwu	a1,0(s7)
    50aa:	855a                	mv	a0,s6
    50ac:	de1ff0ef          	jal	4e8c <printint>
    50b0:	8bca                	mv	s7,s2
      state = 0;
    50b2:	4981                	li	s3,0
    50b4:	bd7d                	j	4f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    50b6:	008b8913          	addi	s2,s7,8
    50ba:	4681                	li	a3,0
    50bc:	4629                	li	a2,10
    50be:	000bb583          	ld	a1,0(s7)
    50c2:	855a                	mv	a0,s6
    50c4:	dc9ff0ef          	jal	4e8c <printint>
        i += 1;
    50c8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    50ca:	8bca                	mv	s7,s2
      state = 0;
    50cc:	4981                	li	s3,0
        i += 1;
    50ce:	b555                	j	4f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    50d0:	008b8913          	addi	s2,s7,8
    50d4:	4681                	li	a3,0
    50d6:	4629                	li	a2,10
    50d8:	000bb583          	ld	a1,0(s7)
    50dc:	855a                	mv	a0,s6
    50de:	dafff0ef          	jal	4e8c <printint>
        i += 2;
    50e2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    50e4:	8bca                	mv	s7,s2
      state = 0;
    50e6:	4981                	li	s3,0
        i += 2;
    50e8:	b569                	j	4f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
    50ea:	008b8913          	addi	s2,s7,8
    50ee:	4681                	li	a3,0
    50f0:	4641                	li	a2,16
    50f2:	000be583          	lwu	a1,0(s7)
    50f6:	855a                	mv	a0,s6
    50f8:	d95ff0ef          	jal	4e8c <printint>
    50fc:	8bca                	mv	s7,s2
      state = 0;
    50fe:	4981                	li	s3,0
    5100:	bd8d                	j	4f72 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5102:	008b8913          	addi	s2,s7,8
    5106:	4681                	li	a3,0
    5108:	4641                	li	a2,16
    510a:	000bb583          	ld	a1,0(s7)
    510e:	855a                	mv	a0,s6
    5110:	d7dff0ef          	jal	4e8c <printint>
        i += 1;
    5114:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    5116:	8bca                	mv	s7,s2
      state = 0;
    5118:	4981                	li	s3,0
        i += 1;
    511a:	bda1                	j	4f72 <vprintf+0x4a>
    511c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    511e:	008b8d13          	addi	s10,s7,8
    5122:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5126:	03000593          	li	a1,48
    512a:	855a                	mv	a0,s6
    512c:	d43ff0ef          	jal	4e6e <putc>
  putc(fd, 'x');
    5130:	07800593          	li	a1,120
    5134:	855a                	mv	a0,s6
    5136:	d39ff0ef          	jal	4e6e <putc>
    513a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    513c:	00003b97          	auipc	s7,0x3
    5140:	8ccb8b93          	addi	s7,s7,-1844 # 7a08 <digits>
    5144:	03c9d793          	srli	a5,s3,0x3c
    5148:	97de                	add	a5,a5,s7
    514a:	0007c583          	lbu	a1,0(a5)
    514e:	855a                	mv	a0,s6
    5150:	d1fff0ef          	jal	4e6e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5154:	0992                	slli	s3,s3,0x4
    5156:	397d                	addiw	s2,s2,-1
    5158:	fe0916e3          	bnez	s2,5144 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
    515c:	8bea                	mv	s7,s10
      state = 0;
    515e:	4981                	li	s3,0
    5160:	6d02                	ld	s10,0(sp)
    5162:	bd01                	j	4f72 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
    5164:	008b8913          	addi	s2,s7,8
    5168:	000bc583          	lbu	a1,0(s7)
    516c:	855a                	mv	a0,s6
    516e:	d01ff0ef          	jal	4e6e <putc>
    5172:	8bca                	mv	s7,s2
      state = 0;
    5174:	4981                	li	s3,0
    5176:	bbf5                	j	4f72 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
    5178:	008b8993          	addi	s3,s7,8
    517c:	000bb903          	ld	s2,0(s7)
    5180:	00090f63          	beqz	s2,519e <vprintf+0x276>
        for (; *s; s++)
    5184:	00094583          	lbu	a1,0(s2)
    5188:	c195                	beqz	a1,51ac <vprintf+0x284>
          putc(fd, *s);
    518a:	855a                	mv	a0,s6
    518c:	ce3ff0ef          	jal	4e6e <putc>
        for (; *s; s++)
    5190:	0905                	addi	s2,s2,1
    5192:	00094583          	lbu	a1,0(s2)
    5196:	f9f5                	bnez	a1,518a <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
    5198:	8bce                	mv	s7,s3
      state = 0;
    519a:	4981                	li	s3,0
    519c:	bbd9                	j	4f72 <vprintf+0x4a>
          s = "(null)";
    519e:	00002917          	auipc	s2,0x2
    51a2:	7ba90913          	addi	s2,s2,1978 # 7958 <malloc+0x26ae>
        for (; *s; s++)
    51a6:	02800593          	li	a1,40
    51aa:	b7c5                	j	518a <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
    51ac:	8bce                	mv	s7,s3
      state = 0;
    51ae:	4981                	li	s3,0
    51b0:	b3c9                	j	4f72 <vprintf+0x4a>
    51b2:	64a6                	ld	s1,72(sp)
    51b4:	79e2                	ld	s3,56(sp)
    51b6:	7a42                	ld	s4,48(sp)
    51b8:	7aa2                	ld	s5,40(sp)
    51ba:	7b02                	ld	s6,32(sp)
    51bc:	6be2                	ld	s7,24(sp)
    51be:	6c42                	ld	s8,16(sp)
    51c0:	6ca2                	ld	s9,8(sp)
    }
  }
}
    51c2:	60e6                	ld	ra,88(sp)
    51c4:	6446                	ld	s0,80(sp)
    51c6:	6906                	ld	s2,64(sp)
    51c8:	6125                	addi	sp,sp,96
    51ca:	8082                	ret

00000000000051cc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    51cc:	715d                	addi	sp,sp,-80
    51ce:	ec06                	sd	ra,24(sp)
    51d0:	e822                	sd	s0,16(sp)
    51d2:	1000                	addi	s0,sp,32
    51d4:	e010                	sd	a2,0(s0)
    51d6:	e414                	sd	a3,8(s0)
    51d8:	e818                	sd	a4,16(s0)
    51da:	ec1c                	sd	a5,24(s0)
    51dc:	03043023          	sd	a6,32(s0)
    51e0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    51e4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    51e8:	8622                	mv	a2,s0
    51ea:	d3fff0ef          	jal	4f28 <vprintf>
}
    51ee:	60e2                	ld	ra,24(sp)
    51f0:	6442                	ld	s0,16(sp)
    51f2:	6161                	addi	sp,sp,80
    51f4:	8082                	ret

00000000000051f6 <printf>:

void
printf(const char *fmt, ...)
{
    51f6:	711d                	addi	sp,sp,-96
    51f8:	ec06                	sd	ra,24(sp)
    51fa:	e822                	sd	s0,16(sp)
    51fc:	1000                	addi	s0,sp,32
    51fe:	e40c                	sd	a1,8(s0)
    5200:	e810                	sd	a2,16(s0)
    5202:	ec14                	sd	a3,24(s0)
    5204:	f018                	sd	a4,32(s0)
    5206:	f41c                	sd	a5,40(s0)
    5208:	03043823          	sd	a6,48(s0)
    520c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5210:	00840613          	addi	a2,s0,8
    5214:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5218:	85aa                	mv	a1,a0
    521a:	4505                	li	a0,1
    521c:	d0dff0ef          	jal	4f28 <vprintf>
}
    5220:	60e2                	ld	ra,24(sp)
    5222:	6442                	ld	s0,16(sp)
    5224:	6125                	addi	sp,sp,96
    5226:	8082                	ret

0000000000005228 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5228:	1141                	addi	sp,sp,-16
    522a:	e422                	sd	s0,8(sp)
    522c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    522e:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5232:	00004797          	auipc	a5,0x4
    5236:	25e7b783          	ld	a5,606(a5) # 9490 <freep>
    523a:	a02d                	j	5264 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
    523c:	4618                	lw	a4,8(a2)
    523e:	9f2d                	addw	a4,a4,a1
    5240:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5244:	6398                	ld	a4,0(a5)
    5246:	6310                	ld	a2,0(a4)
    5248:	a83d                	j	5286 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
    524a:	ff852703          	lw	a4,-8(a0)
    524e:	9f31                	addw	a4,a4,a2
    5250:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5252:	ff053683          	ld	a3,-16(a0)
    5256:	a091                	j	529a <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5258:	6398                	ld	a4,0(a5)
    525a:	00e7e463          	bltu	a5,a4,5262 <free+0x3a>
    525e:	00e6ea63          	bltu	a3,a4,5272 <free+0x4a>
{
    5262:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5264:	fed7fae3          	bgeu	a5,a3,5258 <free+0x30>
    5268:	6398                	ld	a4,0(a5)
    526a:	00e6e463          	bltu	a3,a4,5272 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    526e:	fee7eae3          	bltu	a5,a4,5262 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
    5272:	ff852583          	lw	a1,-8(a0)
    5276:	6390                	ld	a2,0(a5)
    5278:	02059813          	slli	a6,a1,0x20
    527c:	01c85713          	srli	a4,a6,0x1c
    5280:	9736                	add	a4,a4,a3
    5282:	fae60de3          	beq	a2,a4,523c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5286:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
    528a:	4790                	lw	a2,8(a5)
    528c:	02061593          	slli	a1,a2,0x20
    5290:	01c5d713          	srli	a4,a1,0x1c
    5294:	973e                	add	a4,a4,a5
    5296:	fae68ae3          	beq	a3,a4,524a <free+0x22>
    p->s.ptr = bp->s.ptr;
    529a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    529c:	00004717          	auipc	a4,0x4
    52a0:	1ef73a23          	sd	a5,500(a4) # 9490 <freep>
}
    52a4:	6422                	ld	s0,8(sp)
    52a6:	0141                	addi	sp,sp,16
    52a8:	8082                	ret

00000000000052aa <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
    52aa:	7139                	addi	sp,sp,-64
    52ac:	fc06                	sd	ra,56(sp)
    52ae:	f822                	sd	s0,48(sp)
    52b0:	f426                	sd	s1,40(sp)
    52b2:	ec4e                	sd	s3,24(sp)
    52b4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    52b6:	02051493          	slli	s1,a0,0x20
    52ba:	9081                	srli	s1,s1,0x20
    52bc:	04bd                	addi	s1,s1,15
    52be:	8091                	srli	s1,s1,0x4
    52c0:	0014899b          	addiw	s3,s1,1
    52c4:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
    52c6:	00004517          	auipc	a0,0x4
    52ca:	1ca53503          	ld	a0,458(a0) # 9490 <freep>
    52ce:	c915                	beqz	a0,5302 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    52d0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    52d2:	4798                	lw	a4,8(a5)
    52d4:	08977a63          	bgeu	a4,s1,5368 <malloc+0xbe>
    52d8:	f04a                	sd	s2,32(sp)
    52da:	e852                	sd	s4,16(sp)
    52dc:	e456                	sd	s5,8(sp)
    52de:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
    52e0:	8a4e                	mv	s4,s3
    52e2:	0009871b          	sext.w	a4,s3
    52e6:	6685                	lui	a3,0x1
    52e8:	00d77363          	bgeu	a4,a3,52ee <malloc+0x44>
    52ec:	6a05                	lui	s4,0x1
    52ee:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    52f2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    52f6:	00004917          	auipc	s2,0x4
    52fa:	19a90913          	addi	s2,s2,410 # 9490 <freep>
  if (p == SBRK_ERROR)
    52fe:	5afd                	li	s5,-1
    5300:	a081                	j	5340 <malloc+0x96>
    5302:	f04a                	sd	s2,32(sp)
    5304:	e852                	sd	s4,16(sp)
    5306:	e456                	sd	s5,8(sp)
    5308:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    530a:	0000b797          	auipc	a5,0xb
    530e:	9ae78793          	addi	a5,a5,-1618 # fcb8 <base>
    5312:	00004717          	auipc	a4,0x4
    5316:	16f73f23          	sd	a5,382(a4) # 9490 <freep>
    531a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    531c:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    5320:	b7c1                	j	52e0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    5322:	6398                	ld	a4,0(a5)
    5324:	e118                	sd	a4,0(a0)
    5326:	a8a9                	j	5380 <malloc+0xd6>
  hp->s.size = nu;
    5328:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    532c:	0541                	addi	a0,a0,16
    532e:	efbff0ef          	jal	5228 <free>
  return freep;
    5332:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
    5336:	c12d                	beqz	a0,5398 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5338:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    533a:	4798                	lw	a4,8(a5)
    533c:	02977263          	bgeu	a4,s1,5360 <malloc+0xb6>
    if (p == freep)
    5340:	00093703          	ld	a4,0(s2)
    5344:	853e                	mv	a0,a5
    5346:	fef719e3          	bne	a4,a5,5338 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    534a:	8552                	mv	a0,s4
    534c:	a2fff0ef          	jal	4d7a <sbrk>
  if (p == SBRK_ERROR)
    5350:	fd551ce3          	bne	a0,s5,5328 <malloc+0x7e>
        return 0;
    5354:	4501                	li	a0,0
    5356:	7902                	ld	s2,32(sp)
    5358:	6a42                	ld	s4,16(sp)
    535a:	6aa2                	ld	s5,8(sp)
    535c:	6b02                	ld	s6,0(sp)
    535e:	a03d                	j	538c <malloc+0xe2>
    5360:	7902                	ld	s2,32(sp)
    5362:	6a42                	ld	s4,16(sp)
    5364:	6aa2                	ld	s5,8(sp)
    5366:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    5368:	fae48de3          	beq	s1,a4,5322 <malloc+0x78>
        p->s.size -= nunits;
    536c:	4137073b          	subw	a4,a4,s3
    5370:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5372:	02071693          	slli	a3,a4,0x20
    5376:	01c6d713          	srli	a4,a3,0x1c
    537a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    537c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5380:	00004717          	auipc	a4,0x4
    5384:	10a73823          	sd	a0,272(a4) # 9490 <freep>
      return (void *)(p + 1);
    5388:	01078513          	addi	a0,a5,16
  }
}
    538c:	70e2                	ld	ra,56(sp)
    538e:	7442                	ld	s0,48(sp)
    5390:	74a2                	ld	s1,40(sp)
    5392:	69e2                	ld	s3,24(sp)
    5394:	6121                	addi	sp,sp,64
    5396:	8082                	ret
    5398:	7902                	ld	s2,32(sp)
    539a:	6a42                	ld	s4,16(sp)
    539c:	6aa2                	ld	s5,8(sp)
    539e:	6b02                	ld	s6,0(sp)
    53a0:	b7f5                	j	538c <malloc+0xe2>
