
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	00090913          	mv	s2,s2
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	376000ef          	jal	396 <read>
  24:	84aa                	mv	s1,a0
  26:	02a05363          	blez	a0,4c <cat+0x4c>
    if (write(1, buf, n) != n) {
  2a:	8626                	mv	a2,s1
  2c:	85ca                	mv	a1,s2
  2e:	4505                	li	a0,1
  30:	36e000ef          	jal	39e <write>
  34:	fe9502e3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  38:	00001597          	auipc	a1,0x1
  3c:	94858593          	addi	a1,a1,-1720 # 980 <malloc+0x106>
  40:	4509                	li	a0,2
  42:	75a000ef          	jal	79c <fprintf>
      exit(1);
  46:	4505                	li	a0,1
  48:	336000ef          	jal	37e <exit>
    }
  }
  if (n < 0) {
  4c:	00054963          	bltz	a0,5e <cat+0x5e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  50:	70a2                	ld	ra,40(sp)
  52:	7402                	ld	s0,32(sp)
  54:	64e2                	ld	s1,24(sp)
  56:	6942                	ld	s2,16(sp)
  58:	69a2                	ld	s3,8(sp)
  5a:	6145                	addi	sp,sp,48
  5c:	8082                	ret
    fprintf(2, "cat: read error\n");
  5e:	00001597          	auipc	a1,0x1
  62:	93a58593          	addi	a1,a1,-1734 # 998 <malloc+0x11e>
  66:	4509                	li	a0,2
  68:	734000ef          	jal	79c <fprintf>
    exit(1);
  6c:	4505                	li	a0,1
  6e:	310000ef          	jal	37e <exit>

0000000000000072 <main>:

int
main(int argc, char *argv[])
{
  72:	7179                	addi	sp,sp,-48
  74:	f406                	sd	ra,40(sp)
  76:	f022                	sd	s0,32(sp)
  78:	1800                	addi	s0,sp,48
  int fd, i;

  if (argc <= 1) {
  7a:	4785                	li	a5,1
  7c:	04a7d263          	bge	a5,a0,c0 <main+0x4e>
  80:	ec26                	sd	s1,24(sp)
  82:	e84a                	sd	s2,16(sp)
  84:	e44e                	sd	s3,8(sp)
  86:	00858913          	addi	s2,a1,8
  8a:	ffe5099b          	addiw	s3,a0,-2
  8e:	02099793          	slli	a5,s3,0x20
  92:	01d7d993          	srli	s3,a5,0x1d
  96:	05c1                	addi	a1,a1,16
  98:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for (i = 1; i < argc; i++) {
    if ((fd = open(argv[i], O_RDONLY)) < 0) {
  9a:	4581                	li	a1,0
  9c:	00093503          	ld	a0,0(s2) # 1010 <buf>
  a0:	31e000ef          	jal	3be <open>
  a4:	84aa                	mv	s1,a0
  a6:	02054663          	bltz	a0,d2 <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  aa:	f57ff0ef          	jal	0 <cat>
    close(fd);
  ae:	8526                	mv	a0,s1
  b0:	2f6000ef          	jal	3a6 <close>
  for (i = 1; i < argc; i++) {
  b4:	0921                	addi	s2,s2,8
  b6:	ff3912e3          	bne	s2,s3,9a <main+0x28>
  }
  exit(0);
  ba:	4501                	li	a0,0
  bc:	2c2000ef          	jal	37e <exit>
  c0:	ec26                	sd	s1,24(sp)
  c2:	e84a                	sd	s2,16(sp)
  c4:	e44e                	sd	s3,8(sp)
    cat(0);
  c6:	4501                	li	a0,0
  c8:	f39ff0ef          	jal	0 <cat>
    exit(0);
  cc:	4501                	li	a0,0
  ce:	2b0000ef          	jal	37e <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  d2:	00093603          	ld	a2,0(s2)
  d6:	00001597          	auipc	a1,0x1
  da:	8da58593          	addi	a1,a1,-1830 # 9b0 <malloc+0x136>
  de:	4509                	li	a0,2
  e0:	6bc000ef          	jal	79c <fprintf>
      exit(1);
  e4:	4505                	li	a0,1
  e6:	298000ef          	jal	37e <exit>

00000000000000ea <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e406                	sd	ra,8(sp)
  ee:	e022                	sd	s0,0(sp)
  f0:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  f2:	f81ff0ef          	jal	72 <main>
  exit(r);
  f6:	288000ef          	jal	37e <exit>

00000000000000fa <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e422                	sd	s0,8(sp)
  fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 100:	87aa                	mv	a5,a0
 102:	0585                	addi	a1,a1,1
 104:	0785                	addi	a5,a5,1
 106:	fff5c703          	lbu	a4,-1(a1)
 10a:	fee78fa3          	sb	a4,-1(a5)
 10e:	fb75                	bnez	a4,102 <strcpy+0x8>
    ;
  return os;
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret

0000000000000116 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 116:	1141                	addi	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 11c:	00054783          	lbu	a5,0(a0)
 120:	cb91                	beqz	a5,134 <strcmp+0x1e>
 122:	0005c703          	lbu	a4,0(a1)
 126:	00f71763          	bne	a4,a5,134 <strcmp+0x1e>
    p++, q++;
 12a:	0505                	addi	a0,a0,1
 12c:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	fbe5                	bnez	a5,122 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 134:	0005c503          	lbu	a0,0(a1)
}
 138:	40a7853b          	subw	a0,a5,a0
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strlen>:

uint
strlen(const char *s)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cf91                	beqz	a5,168 <strlen+0x26>
 14e:	0505                	addi	a0,a0,1
 150:	87aa                	mv	a5,a0
 152:	86be                	mv	a3,a5
 154:	0785                	addi	a5,a5,1
 156:	fff7c703          	lbu	a4,-1(a5)
 15a:	ff65                	bnez	a4,152 <strlen+0x10>
 15c:	40a6853b          	subw	a0,a3,a0
 160:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 162:	6422                	ld	s0,8(sp)
 164:	0141                	addi	sp,sp,16
 166:	8082                	ret
  for (n = 0; s[n]; n++)
 168:	4501                	li	a0,0
 16a:	bfe5                	j	162 <strlen+0x20>

000000000000016c <memset>:

void *
memset(void *dst, int c, uint n)
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e422                	sd	s0,8(sp)
 170:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 172:	ca19                	beqz	a2,188 <memset+0x1c>
 174:	87aa                	mv	a5,a0
 176:	1602                	slli	a2,a2,0x20
 178:	9201                	srli	a2,a2,0x20
 17a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 17e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 182:	0785                	addi	a5,a5,1
 184:	fee79de3          	bne	a5,a4,17e <memset+0x12>
  }
  return dst;
}
 188:	6422                	ld	s0,8(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret

000000000000018e <strchr>:

char *
strchr(const char *s, char c)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	addi	s0,sp,16
  for (; *s; s++)
 194:	00054783          	lbu	a5,0(a0)
 198:	cb99                	beqz	a5,1ae <strchr+0x20>
    if (*s == c)
 19a:	00f58763          	beq	a1,a5,1a8 <strchr+0x1a>
  for (; *s; s++)
 19e:	0505                	addi	a0,a0,1
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	fbfd                	bnez	a5,19a <strchr+0xc>
      return (char *)s;
  return 0;
 1a6:	4501                	li	a0,0
}
 1a8:	6422                	ld	s0,8(sp)
 1aa:	0141                	addi	sp,sp,16
 1ac:	8082                	ret
  return 0;
 1ae:	4501                	li	a0,0
 1b0:	bfe5                	j	1a8 <strchr+0x1a>

00000000000001b2 <gets>:

char *
gets(char *buf, int max)
{
 1b2:	711d                	addi	sp,sp,-96
 1b4:	ec86                	sd	ra,88(sp)
 1b6:	e8a2                	sd	s0,80(sp)
 1b8:	e4a6                	sd	s1,72(sp)
 1ba:	e0ca                	sd	s2,64(sp)
 1bc:	fc4e                	sd	s3,56(sp)
 1be:	f852                	sd	s4,48(sp)
 1c0:	f456                	sd	s5,40(sp)
 1c2:	f05a                	sd	s6,32(sp)
 1c4:	ec5e                	sd	s7,24(sp)
 1c6:	1080                	addi	s0,sp,96
 1c8:	8baa                	mv	s7,a0
 1ca:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1cc:	892a                	mv	s2,a0
 1ce:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 1d0:	4aa9                	li	s5,10
 1d2:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 1d4:	89a6                	mv	s3,s1
 1d6:	2485                	addiw	s1,s1,1
 1d8:	0344d663          	bge	s1,s4,204 <gets+0x52>
    cc = read(0, &c, 1);
 1dc:	4605                	li	a2,1
 1de:	faf40593          	addi	a1,s0,-81
 1e2:	4501                	li	a0,0
 1e4:	1b2000ef          	jal	396 <read>
    if (cc < 1)
 1e8:	00a05e63          	blez	a0,204 <gets+0x52>
    buf[i++] = c;
 1ec:	faf44783          	lbu	a5,-81(s0)
 1f0:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1f4:	01578763          	beq	a5,s5,202 <gets+0x50>
 1f8:	0905                	addi	s2,s2,1
 1fa:	fd679de3          	bne	a5,s6,1d4 <gets+0x22>
    buf[i++] = c;
 1fe:	89a6                	mv	s3,s1
 200:	a011                	j	204 <gets+0x52>
 202:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 204:	99de                	add	s3,s3,s7
 206:	00098023          	sb	zero,0(s3)
  return buf;
}
 20a:	855e                	mv	a0,s7
 20c:	60e6                	ld	ra,88(sp)
 20e:	6446                	ld	s0,80(sp)
 210:	64a6                	ld	s1,72(sp)
 212:	6906                	ld	s2,64(sp)
 214:	79e2                	ld	s3,56(sp)
 216:	7a42                	ld	s4,48(sp)
 218:	7aa2                	ld	s5,40(sp)
 21a:	7b02                	ld	s6,32(sp)
 21c:	6be2                	ld	s7,24(sp)
 21e:	6125                	addi	sp,sp,96
 220:	8082                	ret

0000000000000222 <stat>:

int
stat(const char *n, struct stat *st)
{
 222:	1101                	addi	sp,sp,-32
 224:	ec06                	sd	ra,24(sp)
 226:	e822                	sd	s0,16(sp)
 228:	e04a                	sd	s2,0(sp)
 22a:	1000                	addi	s0,sp,32
 22c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22e:	4581                	li	a1,0
 230:	18e000ef          	jal	3be <open>
  if (fd < 0)
 234:	02054263          	bltz	a0,258 <stat+0x36>
 238:	e426                	sd	s1,8(sp)
 23a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 23c:	85ca                	mv	a1,s2
 23e:	198000ef          	jal	3d6 <fstat>
 242:	892a                	mv	s2,a0
  close(fd);
 244:	8526                	mv	a0,s1
 246:	160000ef          	jal	3a6 <close>
  return r;
 24a:	64a2                	ld	s1,8(sp)
}
 24c:	854a                	mv	a0,s2
 24e:	60e2                	ld	ra,24(sp)
 250:	6442                	ld	s0,16(sp)
 252:	6902                	ld	s2,0(sp)
 254:	6105                	addi	sp,sp,32
 256:	8082                	ret
    return -1;
 258:	597d                	li	s2,-1
 25a:	bfcd                	j	24c <stat+0x2a>

000000000000025c <atoi>:

int
atoi(const char *s)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e422                	sd	s0,8(sp)
 260:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 262:	00054683          	lbu	a3,0(a0)
 266:	fd06879b          	addiw	a5,a3,-48
 26a:	0ff7f793          	zext.b	a5,a5
 26e:	4625                	li	a2,9
 270:	02f66863          	bltu	a2,a5,2a0 <atoi+0x44>
 274:	872a                	mv	a4,a0
  n = 0;
 276:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 278:	0705                	addi	a4,a4,1
 27a:	0025179b          	slliw	a5,a0,0x2
 27e:	9fa9                	addw	a5,a5,a0
 280:	0017979b          	slliw	a5,a5,0x1
 284:	9fb5                	addw	a5,a5,a3
 286:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 28a:	00074683          	lbu	a3,0(a4)
 28e:	fd06879b          	addiw	a5,a3,-48
 292:	0ff7f793          	zext.b	a5,a5
 296:	fef671e3          	bgeu	a2,a5,278 <atoi+0x1c>
  return n;
}
 29a:	6422                	ld	s0,8(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret
  n = 0;
 2a0:	4501                	li	a0,0
 2a2:	bfe5                	j	29a <atoi+0x3e>

00000000000002a4 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2aa:	02b57463          	bgeu	a0,a1,2d2 <memmove+0x2e>
    while (n-- > 0)
 2ae:	00c05f63          	blez	a2,2cc <memmove+0x28>
 2b2:	1602                	slli	a2,a2,0x20
 2b4:	9201                	srli	a2,a2,0x20
 2b6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ba:	872a                	mv	a4,a0
      *dst++ = *src++;
 2bc:	0585                	addi	a1,a1,1
 2be:	0705                	addi	a4,a4,1
 2c0:	fff5c683          	lbu	a3,-1(a1)
 2c4:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2c8:	fef71ae3          	bne	a4,a5,2bc <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
    dst += n;
 2d2:	00c50733          	add	a4,a0,a2
    src += n;
 2d6:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 2d8:	fec05ae3          	blez	a2,2cc <memmove+0x28>
 2dc:	fff6079b          	addiw	a5,a2,-1
 2e0:	1782                	slli	a5,a5,0x20
 2e2:	9381                	srli	a5,a5,0x20
 2e4:	fff7c793          	not	a5,a5
 2e8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ea:	15fd                	addi	a1,a1,-1
 2ec:	177d                	addi	a4,a4,-1
 2ee:	0005c683          	lbu	a3,0(a1)
 2f2:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2f6:	fee79ae3          	bne	a5,a4,2ea <memmove+0x46>
 2fa:	bfc9                	j	2cc <memmove+0x28>

00000000000002fc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e422                	sd	s0,8(sp)
 300:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 302:	ca05                	beqz	a2,332 <memcmp+0x36>
 304:	fff6069b          	addiw	a3,a2,-1
 308:	1682                	slli	a3,a3,0x20
 30a:	9281                	srli	a3,a3,0x20
 30c:	0685                	addi	a3,a3,1
 30e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 310:	00054783          	lbu	a5,0(a0)
 314:	0005c703          	lbu	a4,0(a1)
 318:	00e79863          	bne	a5,a4,328 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 31c:	0505                	addi	a0,a0,1
    p2++;
 31e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 320:	fed518e3          	bne	a0,a3,310 <memcmp+0x14>
  }
  return 0;
 324:	4501                	li	a0,0
 326:	a019                	j	32c <memcmp+0x30>
      return *p1 - *p2;
 328:	40e7853b          	subw	a0,a5,a4
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  return 0;
 332:	4501                	li	a0,0
 334:	bfe5                	j	32c <memcmp+0x30>

0000000000000336 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 33e:	f67ff0ef          	jal	2a4 <memmove>
}
 342:	60a2                	ld	ra,8(sp)
 344:	6402                	ld	s0,0(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret

000000000000034a <sbrk>:

char *
sbrk(int n)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e406                	sd	ra,8(sp)
 34e:	e022                	sd	s0,0(sp)
 350:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 352:	4585                	li	a1,1
 354:	0b2000ef          	jal	406 <sys_sbrk>
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <sbrklazy>:

char *
sbrklazy(int n)
{
 360:	1141                	addi	sp,sp,-16
 362:	e406                	sd	ra,8(sp)
 364:	e022                	sd	s0,0(sp)
 366:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 368:	4589                	li	a1,2
 36a:	09c000ef          	jal	406 <sys_sbrk>
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 376:	4885                	li	a7,1
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <exit>:
.global exit
exit:
 li a7, SYS_exit
 37e:	4889                	li	a7,2
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <wait>:
.global wait
wait:
 li a7, SYS_wait
 386:	488d                	li	a7,3
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38e:	4891                	li	a7,4
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <read>:
.global read
read:
 li a7, SYS_read
 396:	4895                	li	a7,5
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <write>:
.global write
write:
 li a7, SYS_write
 39e:	48c1                	li	a7,16
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <close>:
.global close
close:
 li a7, SYS_close
 3a6:	48d5                	li	a7,21
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ae:	4899                	li	a7,6
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b6:	489d                	li	a7,7
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <open>:
.global open
open:
 li a7, SYS_open
 3be:	48bd                	li	a7,15
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c6:	48c5                	li	a7,17
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ce:	48c9                	li	a7,18
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d6:	48a1                	li	a7,8
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <link>:
.global link
link:
 li a7, SYS_link
 3de:	48cd                	li	a7,19
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e6:	48d1                	li	a7,20
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ee:	48a5                	li	a7,9
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f6:	48a9                	li	a7,10
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fe:	48ad                	li	a7,11
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 406:	48b1                	li	a7,12
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <pause>:
.global pause
pause:
 li a7, SYS_pause
 40e:	48b5                	li	a7,13
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 416:	48b9                	li	a7,14
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <sync>:
.global sync
sync:
 li a7, SYS_sync
 41e:	48d9                	li	a7,22
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <getwaittime>:
.global getwaittime
getwaittime:
 li a7, SYS_getwaittime
 426:	48dd                	li	a7,23
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <setburst>:
.global setburst
setburst:
 li a7, SYS_setburst
 42e:	48e1                	li	a7,24
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <setburstpid>:
.global setburstpid
setburstpid:
 li a7, SYS_setburstpid
 436:	48e5                	li	a7,25
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 43e:	1101                	addi	sp,sp,-32
 440:	ec06                	sd	ra,24(sp)
 442:	e822                	sd	s0,16(sp)
 444:	1000                	addi	s0,sp,32
 446:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44a:	4605                	li	a2,1
 44c:	fef40593          	addi	a1,s0,-17
 450:	f4fff0ef          	jal	39e <write>
}
 454:	60e2                	ld	ra,24(sp)
 456:	6442                	ld	s0,16(sp)
 458:	6105                	addi	sp,sp,32
 45a:	8082                	ret

000000000000045c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 45c:	715d                	addi	sp,sp,-80
 45e:	e486                	sd	ra,72(sp)
 460:	e0a2                	sd	s0,64(sp)
 462:	f84a                	sd	s2,48(sp)
 464:	0880                	addi	s0,sp,80
 466:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 468:	c299                	beqz	a3,46e <printint+0x12>
 46a:	0805c363          	bltz	a1,4f0 <printint+0x94>
  neg = 0;
 46e:	4881                	li	a7,0
 470:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 474:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 476:	00000517          	auipc	a0,0x0
 47a:	55a50513          	addi	a0,a0,1370 # 9d0 <digits>
 47e:	883e                	mv	a6,a5
 480:	2785                	addiw	a5,a5,1
 482:	02c5f733          	remu	a4,a1,a2
 486:	972a                	add	a4,a4,a0
 488:	00074703          	lbu	a4,0(a4)
 48c:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 490:	872e                	mv	a4,a1
 492:	02c5d5b3          	divu	a1,a1,a2
 496:	0685                	addi	a3,a3,1
 498:	fec773e3          	bgeu	a4,a2,47e <printint+0x22>
  if (neg)
 49c:	00088b63          	beqz	a7,4b2 <printint+0x56>
    buf[i++] = '-';
 4a0:	fd078793          	addi	a5,a5,-48
 4a4:	97a2                	add	a5,a5,s0
 4a6:	02d00713          	li	a4,45
 4aa:	fee78423          	sb	a4,-24(a5)
 4ae:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 4b2:	02f05a63          	blez	a5,4e6 <printint+0x8a>
 4b6:	fc26                	sd	s1,56(sp)
 4b8:	f44e                	sd	s3,40(sp)
 4ba:	fb840713          	addi	a4,s0,-72
 4be:	00f704b3          	add	s1,a4,a5
 4c2:	fff70993          	addi	s3,a4,-1
 4c6:	99be                	add	s3,s3,a5
 4c8:	37fd                	addiw	a5,a5,-1
 4ca:	1782                	slli	a5,a5,0x20
 4cc:	9381                	srli	a5,a5,0x20
 4ce:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4d2:	fff4c583          	lbu	a1,-1(s1)
 4d6:	854a                	mv	a0,s2
 4d8:	f67ff0ef          	jal	43e <putc>
  while (--i >= 0)
 4dc:	14fd                	addi	s1,s1,-1
 4de:	ff349ae3          	bne	s1,s3,4d2 <printint+0x76>
 4e2:	74e2                	ld	s1,56(sp)
 4e4:	79a2                	ld	s3,40(sp)
}
 4e6:	60a6                	ld	ra,72(sp)
 4e8:	6406                	ld	s0,64(sp)
 4ea:	7942                	ld	s2,48(sp)
 4ec:	6161                	addi	sp,sp,80
 4ee:	8082                	ret
    x = -xx;
 4f0:	40b005b3          	neg	a1,a1
    neg = 1;
 4f4:	4885                	li	a7,1
    x = -xx;
 4f6:	bfad                	j	470 <printint+0x14>

00000000000004f8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f8:	711d                	addi	sp,sp,-96
 4fa:	ec86                	sd	ra,88(sp)
 4fc:	e8a2                	sd	s0,80(sp)
 4fe:	e0ca                	sd	s2,64(sp)
 500:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 502:	0005c903          	lbu	s2,0(a1)
 506:	28090663          	beqz	s2,792 <vprintf+0x29a>
 50a:	e4a6                	sd	s1,72(sp)
 50c:	fc4e                	sd	s3,56(sp)
 50e:	f852                	sd	s4,48(sp)
 510:	f456                	sd	s5,40(sp)
 512:	f05a                	sd	s6,32(sp)
 514:	ec5e                	sd	s7,24(sp)
 516:	e862                	sd	s8,16(sp)
 518:	e466                	sd	s9,8(sp)
 51a:	8b2a                	mv	s6,a0
 51c:	8a2e                	mv	s4,a1
 51e:	8bb2                	mv	s7,a2
  state = 0;
 520:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 522:	4481                	li	s1,0
 524:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 526:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 52a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 52e:	06c00c93          	li	s9,108
 532:	a005                	j	552 <vprintf+0x5a>
        putc(fd, c0);
 534:	85ca                	mv	a1,s2
 536:	855a                	mv	a0,s6
 538:	f07ff0ef          	jal	43e <putc>
 53c:	a019                	j	542 <vprintf+0x4a>
    } else if (state == '%') {
 53e:	03598263          	beq	s3,s5,562 <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 542:	2485                	addiw	s1,s1,1
 544:	8726                	mv	a4,s1
 546:	009a07b3          	add	a5,s4,s1
 54a:	0007c903          	lbu	s2,0(a5)
 54e:	22090a63          	beqz	s2,782 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 552:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 556:	fe0994e3          	bnez	s3,53e <vprintf+0x46>
      if (c0 == '%') {
 55a:	fd579de3          	bne	a5,s5,534 <vprintf+0x3c>
        state = '%';
 55e:	89be                	mv	s3,a5
 560:	b7cd                	j	542 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 562:	00ea06b3          	add	a3,s4,a4
 566:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 56a:	8636                	mv	a2,a3
      if (c1)
 56c:	c681                	beqz	a3,574 <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 56e:	9752                	add	a4,a4,s4
 570:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 574:	05878363          	beq	a5,s8,5ba <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 578:	05978d63          	beq	a5,s9,5d2 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 57c:	07500713          	li	a4,117
 580:	0ee78763          	beq	a5,a4,66e <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 584:	07800713          	li	a4,120
 588:	12e78963          	beq	a5,a4,6ba <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 58c:	07000713          	li	a4,112
 590:	14e78e63          	beq	a5,a4,6ec <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 594:	06300713          	li	a4,99
 598:	18e78e63          	beq	a5,a4,734 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 59c:	07300713          	li	a4,115
 5a0:	1ae78463          	beq	a5,a4,748 <vprintf+0x250>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5a4:	02500713          	li	a4,37
 5a8:	04e79563          	bne	a5,a4,5f2 <vprintf+0xfa>
        putc(fd, '%');
 5ac:	02500593          	li	a1,37
 5b0:	855a                	mv	a0,s6
 5b2:	e8dff0ef          	jal	43e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	b769                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5ba:	008b8913          	addi	s2,s7,8
 5be:	4685                	li	a3,1
 5c0:	4629                	li	a2,10
 5c2:	000ba583          	lw	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	e95ff0ef          	jal	45c <printint>
 5cc:	8bca                	mv	s7,s2
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	bf8d                	j	542 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 5d2:	06400793          	li	a5,100
 5d6:	02f68963          	beq	a3,a5,608 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5da:	06c00793          	li	a5,108
 5de:	04f68263          	beq	a3,a5,622 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 5e2:	07500793          	li	a5,117
 5e6:	0af68063          	beq	a3,a5,686 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 5ea:	07800793          	li	a5,120
 5ee:	0ef68263          	beq	a3,a5,6d2 <vprintf+0x1da>
        putc(fd, '%');
 5f2:	02500593          	li	a1,37
 5f6:	855a                	mv	a0,s6
 5f8:	e47ff0ef          	jal	43e <putc>
        putc(fd, c0);
 5fc:	85ca                	mv	a1,s2
 5fe:	855a                	mv	a0,s6
 600:	e3fff0ef          	jal	43e <putc>
      state = 0;
 604:	4981                	li	s3,0
 606:	bf35                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 608:	008b8913          	addi	s2,s7,8
 60c:	4685                	li	a3,1
 60e:	4629                	li	a2,10
 610:	000bb583          	ld	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	e47ff0ef          	jal	45c <printint>
        i += 1;
 61a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 61c:	8bca                	mv	s7,s2
      state = 0;
 61e:	4981                	li	s3,0
        i += 1;
 620:	b70d                	j	542 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 622:	06400793          	li	a5,100
 626:	02f60763          	beq	a2,a5,654 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 62a:	07500793          	li	a5,117
 62e:	06f60963          	beq	a2,a5,6a0 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 632:	07800793          	li	a5,120
 636:	faf61ee3          	bne	a2,a5,5f2 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 63a:	008b8913          	addi	s2,s7,8
 63e:	4681                	li	a3,0
 640:	4641                	li	a2,16
 642:	000bb583          	ld	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	e15ff0ef          	jal	45c <printint>
        i += 2;
 64c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
        i += 2;
 652:	bdc5                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 654:	008b8913          	addi	s2,s7,8
 658:	4685                	li	a3,1
 65a:	4629                	li	a2,10
 65c:	000bb583          	ld	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	dfbff0ef          	jal	45c <printint>
        i += 2;
 666:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 668:	8bca                	mv	s7,s2
      state = 0;
 66a:	4981                	li	s3,0
        i += 2;
 66c:	bdd9                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 66e:	008b8913          	addi	s2,s7,8
 672:	4681                	li	a3,0
 674:	4629                	li	a2,10
 676:	000be583          	lwu	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	de1ff0ef          	jal	45c <printint>
 680:	8bca                	mv	s7,s2
      state = 0;
 682:	4981                	li	s3,0
 684:	bd7d                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 686:	008b8913          	addi	s2,s7,8
 68a:	4681                	li	a3,0
 68c:	4629                	li	a2,10
 68e:	000bb583          	ld	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	dc9ff0ef          	jal	45c <printint>
        i += 1;
 698:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 69a:	8bca                	mv	s7,s2
      state = 0;
 69c:	4981                	li	s3,0
        i += 1;
 69e:	b555                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a0:	008b8913          	addi	s2,s7,8
 6a4:	4681                	li	a3,0
 6a6:	4629                	li	a2,10
 6a8:	000bb583          	ld	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	dafff0ef          	jal	45c <printint>
        i += 2;
 6b2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b4:	8bca                	mv	s7,s2
      state = 0;
 6b6:	4981                	li	s3,0
        i += 2;
 6b8:	b569                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6ba:	008b8913          	addi	s2,s7,8
 6be:	4681                	li	a3,0
 6c0:	4641                	li	a2,16
 6c2:	000be583          	lwu	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	d95ff0ef          	jal	45c <printint>
 6cc:	8bca                	mv	s7,s2
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	bd8d                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d2:	008b8913          	addi	s2,s7,8
 6d6:	4681                	li	a3,0
 6d8:	4641                	li	a2,16
 6da:	000bb583          	ld	a1,0(s7)
 6de:	855a                	mv	a0,s6
 6e0:	d7dff0ef          	jal	45c <printint>
        i += 1;
 6e4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e6:	8bca                	mv	s7,s2
      state = 0;
 6e8:	4981                	li	s3,0
        i += 1;
 6ea:	bda1                	j	542 <vprintf+0x4a>
 6ec:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6ee:	008b8d13          	addi	s10,s7,8
 6f2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6f6:	03000593          	li	a1,48
 6fa:	855a                	mv	a0,s6
 6fc:	d43ff0ef          	jal	43e <putc>
  putc(fd, 'x');
 700:	07800593          	li	a1,120
 704:	855a                	mv	a0,s6
 706:	d39ff0ef          	jal	43e <putc>
 70a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70c:	00000b97          	auipc	s7,0x0
 710:	2c4b8b93          	addi	s7,s7,708 # 9d0 <digits>
 714:	03c9d793          	srli	a5,s3,0x3c
 718:	97de                	add	a5,a5,s7
 71a:	0007c583          	lbu	a1,0(a5)
 71e:	855a                	mv	a0,s6
 720:	d1fff0ef          	jal	43e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 724:	0992                	slli	s3,s3,0x4
 726:	397d                	addiw	s2,s2,-1
 728:	fe0916e3          	bnez	s2,714 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 72c:	8bea                	mv	s7,s10
      state = 0;
 72e:	4981                	li	s3,0
 730:	6d02                	ld	s10,0(sp)
 732:	bd01                	j	542 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 734:	008b8913          	addi	s2,s7,8
 738:	000bc583          	lbu	a1,0(s7)
 73c:	855a                	mv	a0,s6
 73e:	d01ff0ef          	jal	43e <putc>
 742:	8bca                	mv	s7,s2
      state = 0;
 744:	4981                	li	s3,0
 746:	bbf5                	j	542 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 748:	008b8993          	addi	s3,s7,8
 74c:	000bb903          	ld	s2,0(s7)
 750:	00090f63          	beqz	s2,76e <vprintf+0x276>
        for (; *s; s++)
 754:	00094583          	lbu	a1,0(s2)
 758:	c195                	beqz	a1,77c <vprintf+0x284>
          putc(fd, *s);
 75a:	855a                	mv	a0,s6
 75c:	ce3ff0ef          	jal	43e <putc>
        for (; *s; s++)
 760:	0905                	addi	s2,s2,1
 762:	00094583          	lbu	a1,0(s2)
 766:	f9f5                	bnez	a1,75a <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 768:	8bce                	mv	s7,s3
      state = 0;
 76a:	4981                	li	s3,0
 76c:	bbd9                	j	542 <vprintf+0x4a>
          s = "(null)";
 76e:	00000917          	auipc	s2,0x0
 772:	25a90913          	addi	s2,s2,602 # 9c8 <malloc+0x14e>
        for (; *s; s++)
 776:	02800593          	li	a1,40
 77a:	b7c5                	j	75a <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 77c:	8bce                	mv	s7,s3
      state = 0;
 77e:	4981                	li	s3,0
 780:	b3c9                	j	542 <vprintf+0x4a>
 782:	64a6                	ld	s1,72(sp)
 784:	79e2                	ld	s3,56(sp)
 786:	7a42                	ld	s4,48(sp)
 788:	7aa2                	ld	s5,40(sp)
 78a:	7b02                	ld	s6,32(sp)
 78c:	6be2                	ld	s7,24(sp)
 78e:	6c42                	ld	s8,16(sp)
 790:	6ca2                	ld	s9,8(sp)
    }
  }
}
 792:	60e6                	ld	ra,88(sp)
 794:	6446                	ld	s0,80(sp)
 796:	6906                	ld	s2,64(sp)
 798:	6125                	addi	sp,sp,96
 79a:	8082                	ret

000000000000079c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 79c:	715d                	addi	sp,sp,-80
 79e:	ec06                	sd	ra,24(sp)
 7a0:	e822                	sd	s0,16(sp)
 7a2:	1000                	addi	s0,sp,32
 7a4:	e010                	sd	a2,0(s0)
 7a6:	e414                	sd	a3,8(s0)
 7a8:	e818                	sd	a4,16(s0)
 7aa:	ec1c                	sd	a5,24(s0)
 7ac:	03043023          	sd	a6,32(s0)
 7b0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b8:	8622                	mv	a2,s0
 7ba:	d3fff0ef          	jal	4f8 <vprintf>
}
 7be:	60e2                	ld	ra,24(sp)
 7c0:	6442                	ld	s0,16(sp)
 7c2:	6161                	addi	sp,sp,80
 7c4:	8082                	ret

00000000000007c6 <printf>:

void
printf(const char *fmt, ...)
{
 7c6:	711d                	addi	sp,sp,-96
 7c8:	ec06                	sd	ra,24(sp)
 7ca:	e822                	sd	s0,16(sp)
 7cc:	1000                	addi	s0,sp,32
 7ce:	e40c                	sd	a1,8(s0)
 7d0:	e810                	sd	a2,16(s0)
 7d2:	ec14                	sd	a3,24(s0)
 7d4:	f018                	sd	a4,32(s0)
 7d6:	f41c                	sd	a5,40(s0)
 7d8:	03043823          	sd	a6,48(s0)
 7dc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e0:	00840613          	addi	a2,s0,8
 7e4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7e8:	85aa                	mv	a1,a0
 7ea:	4505                	li	a0,1
 7ec:	d0dff0ef          	jal	4f8 <vprintf>
}
 7f0:	60e2                	ld	ra,24(sp)
 7f2:	6442                	ld	s0,16(sp)
 7f4:	6125                	addi	sp,sp,96
 7f6:	8082                	ret

00000000000007f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f8:	1141                	addi	sp,sp,-16
 7fa:	e422                	sd	s0,8(sp)
 7fc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7fe:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 802:	00000797          	auipc	a5,0x0
 806:	7fe7b783          	ld	a5,2046(a5) # 1000 <freep>
 80a:	a02d                	j	834 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 80c:	4618                	lw	a4,8(a2)
 80e:	9f2d                	addw	a4,a4,a1
 810:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 814:	6398                	ld	a4,0(a5)
 816:	6310                	ld	a2,0(a4)
 818:	a83d                	j	856 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 81a:	ff852703          	lw	a4,-8(a0)
 81e:	9f31                	addw	a4,a4,a2
 820:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 822:	ff053683          	ld	a3,-16(a0)
 826:	a091                	j	86a <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	6398                	ld	a4,0(a5)
 82a:	00e7e463          	bltu	a5,a4,832 <free+0x3a>
 82e:	00e6ea63          	bltu	a3,a4,842 <free+0x4a>
{
 832:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 834:	fed7fae3          	bgeu	a5,a3,828 <free+0x30>
 838:	6398                	ld	a4,0(a5)
 83a:	00e6e463          	bltu	a3,a4,842 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83e:	fee7eae3          	bltu	a5,a4,832 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 842:	ff852583          	lw	a1,-8(a0)
 846:	6390                	ld	a2,0(a5)
 848:	02059813          	slli	a6,a1,0x20
 84c:	01c85713          	srli	a4,a6,0x1c
 850:	9736                	add	a4,a4,a3
 852:	fae60de3          	beq	a2,a4,80c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 856:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 85a:	4790                	lw	a2,8(a5)
 85c:	02061593          	slli	a1,a2,0x20
 860:	01c5d713          	srli	a4,a1,0x1c
 864:	973e                	add	a4,a4,a5
 866:	fae68ae3          	beq	a3,a4,81a <free+0x22>
    p->s.ptr = bp->s.ptr;
 86a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 86c:	00000717          	auipc	a4,0x0
 870:	78f73a23          	sd	a5,1940(a4) # 1000 <freep>
}
 874:	6422                	ld	s0,8(sp)
 876:	0141                	addi	sp,sp,16
 878:	8082                	ret

000000000000087a <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 87a:	7139                	addi	sp,sp,-64
 87c:	fc06                	sd	ra,56(sp)
 87e:	f822                	sd	s0,48(sp)
 880:	f426                	sd	s1,40(sp)
 882:	ec4e                	sd	s3,24(sp)
 884:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 886:	02051493          	slli	s1,a0,0x20
 88a:	9081                	srli	s1,s1,0x20
 88c:	04bd                	addi	s1,s1,15
 88e:	8091                	srli	s1,s1,0x4
 890:	0014899b          	addiw	s3,s1,1
 894:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 896:	00000517          	auipc	a0,0x0
 89a:	76a53503          	ld	a0,1898(a0) # 1000 <freep>
 89e:	c915                	beqz	a0,8d2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8a0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8a2:	4798                	lw	a4,8(a5)
 8a4:	08977a63          	bgeu	a4,s1,938 <malloc+0xbe>
 8a8:	f04a                	sd	s2,32(sp)
 8aa:	e852                	sd	s4,16(sp)
 8ac:	e456                	sd	s5,8(sp)
 8ae:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8b0:	8a4e                	mv	s4,s3
 8b2:	0009871b          	sext.w	a4,s3
 8b6:	6685                	lui	a3,0x1
 8b8:	00d77363          	bgeu	a4,a3,8be <malloc+0x44>
 8bc:	6a05                	lui	s4,0x1
 8be:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8c6:	00000917          	auipc	s2,0x0
 8ca:	73a90913          	addi	s2,s2,1850 # 1000 <freep>
  if (p == SBRK_ERROR)
 8ce:	5afd                	li	s5,-1
 8d0:	a081                	j	910 <malloc+0x96>
 8d2:	f04a                	sd	s2,32(sp)
 8d4:	e852                	sd	s4,16(sp)
 8d6:	e456                	sd	s5,8(sp)
 8d8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8da:	00001797          	auipc	a5,0x1
 8de:	93678793          	addi	a5,a5,-1738 # 1210 <base>
 8e2:	00000717          	auipc	a4,0x0
 8e6:	70f73f23          	sd	a5,1822(a4) # 1000 <freep>
 8ea:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ec:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8f0:	b7c1                	j	8b0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8f2:	6398                	ld	a4,0(a5)
 8f4:	e118                	sd	a4,0(a0)
 8f6:	a8a9                	j	950 <malloc+0xd6>
  hp->s.size = nu;
 8f8:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8fc:	0541                	addi	a0,a0,16
 8fe:	efbff0ef          	jal	7f8 <free>
  return freep;
 902:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 906:	c12d                	beqz	a0,968 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 908:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 90a:	4798                	lw	a4,8(a5)
 90c:	02977263          	bgeu	a4,s1,930 <malloc+0xb6>
    if (p == freep)
 910:	00093703          	ld	a4,0(s2)
 914:	853e                	mv	a0,a5
 916:	fef719e3          	bne	a4,a5,908 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 91a:	8552                	mv	a0,s4
 91c:	a2fff0ef          	jal	34a <sbrk>
  if (p == SBRK_ERROR)
 920:	fd551ce3          	bne	a0,s5,8f8 <malloc+0x7e>
        return 0;
 924:	4501                	li	a0,0
 926:	7902                	ld	s2,32(sp)
 928:	6a42                	ld	s4,16(sp)
 92a:	6aa2                	ld	s5,8(sp)
 92c:	6b02                	ld	s6,0(sp)
 92e:	a03d                	j	95c <malloc+0xe2>
 930:	7902                	ld	s2,32(sp)
 932:	6a42                	ld	s4,16(sp)
 934:	6aa2                	ld	s5,8(sp)
 936:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 938:	fae48de3          	beq	s1,a4,8f2 <malloc+0x78>
        p->s.size -= nunits;
 93c:	4137073b          	subw	a4,a4,s3
 940:	c798                	sw	a4,8(a5)
        p += p->s.size;
 942:	02071693          	slli	a3,a4,0x20
 946:	01c6d713          	srli	a4,a3,0x1c
 94a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 94c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 950:	00000717          	auipc	a4,0x0
 954:	6aa73823          	sd	a0,1712(a4) # 1000 <freep>
      return (void *)(p + 1);
 958:	01078513          	addi	a0,a5,16
  }
}
 95c:	70e2                	ld	ra,56(sp)
 95e:	7442                	ld	s0,48(sp)
 960:	74a2                	ld	s1,40(sp)
 962:	69e2                	ld	s3,24(sp)
 964:	6121                	addi	sp,sp,64
 966:	8082                	ret
 968:	7902                	ld	s2,32(sp)
 96a:	6a42                	ld	s4,16(sp)
 96c:	6aa2                	ld	s5,8(sp)
 96e:	6b02                	ld	s6,0(sp)
 970:	b7f5                	j	95c <malloc+0xe2>
