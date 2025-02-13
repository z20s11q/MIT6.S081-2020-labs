
user/_copy:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main()
{
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	0880                	addi	s0,sp,80
    char buf[64];

    while(1){
        //从console读取输入，通过system call的read函数实现
        int n = read(0, buf, sizeof(buf));
   8:	04000613          	li	a2,64
   c:	fb040593          	addi	a1,s0,-80
  10:	4501                	li	a0,0
  12:	00000097          	auipc	ra,0x0
  16:	2b6080e7          	jalr	694(ra) # 2c8 <read>
        //无输入结束程序
        if(n <= 0)
  1a:	00a05b63          	blez	a0,30 <main+0x30>
  1e:	862a                	mv	a2,a0
            break;
        //将console输入输出到控制台，通过system call的write函数实现
        write(1, buf, n);
  20:	fb040593          	addi	a1,s0,-80
  24:	4505                	li	a0,1
  26:	00000097          	auipc	ra,0x0
  2a:	2aa080e7          	jalr	682(ra) # 2d0 <write>
    while(1){
  2e:	bfe9                	j	8 <main+0x8>
    }

    exit(0);
  30:	4501                	li	a0,0
  32:	00000097          	auipc	ra,0x0
  36:	27e080e7          	jalr	638(ra) # 2b0 <exit>

000000000000003a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  3a:	1141                	addi	sp,sp,-16
  3c:	e422                	sd	s0,8(sp)
  3e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  40:	87aa                	mv	a5,a0
  42:	0585                	addi	a1,a1,1
  44:	0785                	addi	a5,a5,1
  46:	fff5c703          	lbu	a4,-1(a1)
  4a:	fee78fa3          	sb	a4,-1(a5)
  4e:	fb75                	bnez	a4,42 <strcpy+0x8>
    ;
  return os;
}
  50:	6422                	ld	s0,8(sp)
  52:	0141                	addi	sp,sp,16
  54:	8082                	ret

0000000000000056 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  56:	1141                	addi	sp,sp,-16
  58:	e422                	sd	s0,8(sp)
  5a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  5c:	00054783          	lbu	a5,0(a0)
  60:	cb91                	beqz	a5,74 <strcmp+0x1e>
  62:	0005c703          	lbu	a4,0(a1)
  66:	00f71763          	bne	a4,a5,74 <strcmp+0x1e>
    p++, q++;
  6a:	0505                	addi	a0,a0,1
  6c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  6e:	00054783          	lbu	a5,0(a0)
  72:	fbe5                	bnez	a5,62 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  74:	0005c503          	lbu	a0,0(a1)
}
  78:	40a7853b          	subw	a0,a5,a0
  7c:	6422                	ld	s0,8(sp)
  7e:	0141                	addi	sp,sp,16
  80:	8082                	ret

0000000000000082 <strlen>:

uint
strlen(const char *s)
{
  82:	1141                	addi	sp,sp,-16
  84:	e422                	sd	s0,8(sp)
  86:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cf91                	beqz	a5,a8 <strlen+0x26>
  8e:	0505                	addi	a0,a0,1
  90:	87aa                	mv	a5,a0
  92:	4685                	li	a3,1
  94:	9e89                	subw	a3,a3,a0
  96:	00f6853b          	addw	a0,a3,a5
  9a:	0785                	addi	a5,a5,1
  9c:	fff7c703          	lbu	a4,-1(a5)
  a0:	fb7d                	bnez	a4,96 <strlen+0x14>
    ;
  return n;
}
  a2:	6422                	ld	s0,8(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret
  for(n = 0; s[n]; n++)
  a8:	4501                	li	a0,0
  aa:	bfe5                	j	a2 <strlen+0x20>

00000000000000ac <memset>:

void*
memset(void *dst, int c, uint n)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e422                	sd	s0,8(sp)
  b0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b2:	ce09                	beqz	a2,cc <memset+0x20>
  b4:	87aa                	mv	a5,a0
  b6:	fff6071b          	addiw	a4,a2,-1
  ba:	1702                	slli	a4,a4,0x20
  bc:	9301                	srli	a4,a4,0x20
  be:	0705                	addi	a4,a4,1
  c0:	972a                	add	a4,a4,a0
    cdst[i] = c;
  c2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c6:	0785                	addi	a5,a5,1
  c8:	fee79de3          	bne	a5,a4,c2 <memset+0x16>
  }
  return dst;
}
  cc:	6422                	ld	s0,8(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strchr>:

char*
strchr(const char *s, char c)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	cb99                	beqz	a5,f2 <strchr+0x20>
    if(*s == c)
  de:	00f58763          	beq	a1,a5,ec <strchr+0x1a>
  for(; *s; s++)
  e2:	0505                	addi	a0,a0,1
  e4:	00054783          	lbu	a5,0(a0)
  e8:	fbfd                	bnez	a5,de <strchr+0xc>
      return (char*)s;
  return 0;
  ea:	4501                	li	a0,0
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret
  return 0;
  f2:	4501                	li	a0,0
  f4:	bfe5                	j	ec <strchr+0x1a>

00000000000000f6 <gets>:

char*
gets(char *buf, int max)
{
  f6:	711d                	addi	sp,sp,-96
  f8:	ec86                	sd	ra,88(sp)
  fa:	e8a2                	sd	s0,80(sp)
  fc:	e4a6                	sd	s1,72(sp)
  fe:	e0ca                	sd	s2,64(sp)
 100:	fc4e                	sd	s3,56(sp)
 102:	f852                	sd	s4,48(sp)
 104:	f456                	sd	s5,40(sp)
 106:	f05a                	sd	s6,32(sp)
 108:	ec5e                	sd	s7,24(sp)
 10a:	1080                	addi	s0,sp,96
 10c:	8baa                	mv	s7,a0
 10e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 110:	892a                	mv	s2,a0
 112:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 114:	4aa9                	li	s5,10
 116:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 118:	89a6                	mv	s3,s1
 11a:	2485                	addiw	s1,s1,1
 11c:	0344d863          	bge	s1,s4,14c <gets+0x56>
    cc = read(0, &c, 1);
 120:	4605                	li	a2,1
 122:	faf40593          	addi	a1,s0,-81
 126:	4501                	li	a0,0
 128:	00000097          	auipc	ra,0x0
 12c:	1a0080e7          	jalr	416(ra) # 2c8 <read>
    if(cc < 1)
 130:	00a05e63          	blez	a0,14c <gets+0x56>
    buf[i++] = c;
 134:	faf44783          	lbu	a5,-81(s0)
 138:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 13c:	01578763          	beq	a5,s5,14a <gets+0x54>
 140:	0905                	addi	s2,s2,1
 142:	fd679be3          	bne	a5,s6,118 <gets+0x22>
  for(i=0; i+1 < max; ){
 146:	89a6                	mv	s3,s1
 148:	a011                	j	14c <gets+0x56>
 14a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 14c:	99de                	add	s3,s3,s7
 14e:	00098023          	sb	zero,0(s3)
  return buf;
}
 152:	855e                	mv	a0,s7
 154:	60e6                	ld	ra,88(sp)
 156:	6446                	ld	s0,80(sp)
 158:	64a6                	ld	s1,72(sp)
 15a:	6906                	ld	s2,64(sp)
 15c:	79e2                	ld	s3,56(sp)
 15e:	7a42                	ld	s4,48(sp)
 160:	7aa2                	ld	s5,40(sp)
 162:	7b02                	ld	s6,32(sp)
 164:	6be2                	ld	s7,24(sp)
 166:	6125                	addi	sp,sp,96
 168:	8082                	ret

000000000000016a <stat>:

int
stat(const char *n, struct stat *st)
{
 16a:	1101                	addi	sp,sp,-32
 16c:	ec06                	sd	ra,24(sp)
 16e:	e822                	sd	s0,16(sp)
 170:	e426                	sd	s1,8(sp)
 172:	e04a                	sd	s2,0(sp)
 174:	1000                	addi	s0,sp,32
 176:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 178:	4581                	li	a1,0
 17a:	00000097          	auipc	ra,0x0
 17e:	176080e7          	jalr	374(ra) # 2f0 <open>
  if(fd < 0)
 182:	02054563          	bltz	a0,1ac <stat+0x42>
 186:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 188:	85ca                	mv	a1,s2
 18a:	00000097          	auipc	ra,0x0
 18e:	17e080e7          	jalr	382(ra) # 308 <fstat>
 192:	892a                	mv	s2,a0
  close(fd);
 194:	8526                	mv	a0,s1
 196:	00000097          	auipc	ra,0x0
 19a:	142080e7          	jalr	322(ra) # 2d8 <close>
  return r;
}
 19e:	854a                	mv	a0,s2
 1a0:	60e2                	ld	ra,24(sp)
 1a2:	6442                	ld	s0,16(sp)
 1a4:	64a2                	ld	s1,8(sp)
 1a6:	6902                	ld	s2,0(sp)
 1a8:	6105                	addi	sp,sp,32
 1aa:	8082                	ret
    return -1;
 1ac:	597d                	li	s2,-1
 1ae:	bfc5                	j	19e <stat+0x34>

00000000000001b0 <atoi>:

int
atoi(const char *s)
{
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b6:	00054603          	lbu	a2,0(a0)
 1ba:	fd06079b          	addiw	a5,a2,-48
 1be:	0ff7f793          	andi	a5,a5,255
 1c2:	4725                	li	a4,9
 1c4:	02f76963          	bltu	a4,a5,1f6 <atoi+0x46>
 1c8:	86aa                	mv	a3,a0
  n = 0;
 1ca:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1cc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1ce:	0685                	addi	a3,a3,1
 1d0:	0025179b          	slliw	a5,a0,0x2
 1d4:	9fa9                	addw	a5,a5,a0
 1d6:	0017979b          	slliw	a5,a5,0x1
 1da:	9fb1                	addw	a5,a5,a2
 1dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e0:	0006c603          	lbu	a2,0(a3)
 1e4:	fd06071b          	addiw	a4,a2,-48
 1e8:	0ff77713          	andi	a4,a4,255
 1ec:	fee5f1e3          	bgeu	a1,a4,1ce <atoi+0x1e>
  return n;
}
 1f0:	6422                	ld	s0,8(sp)
 1f2:	0141                	addi	sp,sp,16
 1f4:	8082                	ret
  n = 0;
 1f6:	4501                	li	a0,0
 1f8:	bfe5                	j	1f0 <atoi+0x40>

00000000000001fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e422                	sd	s0,8(sp)
 1fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 200:	02b57663          	bgeu	a0,a1,22c <memmove+0x32>
    while(n-- > 0)
 204:	02c05163          	blez	a2,226 <memmove+0x2c>
 208:	fff6079b          	addiw	a5,a2,-1
 20c:	1782                	slli	a5,a5,0x20
 20e:	9381                	srli	a5,a5,0x20
 210:	0785                	addi	a5,a5,1
 212:	97aa                	add	a5,a5,a0
  dst = vdst;
 214:	872a                	mv	a4,a0
      *dst++ = *src++;
 216:	0585                	addi	a1,a1,1
 218:	0705                	addi	a4,a4,1
 21a:	fff5c683          	lbu	a3,-1(a1)
 21e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 222:	fee79ae3          	bne	a5,a4,216 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
    dst += n;
 22c:	00c50733          	add	a4,a0,a2
    src += n;
 230:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 232:	fec05ae3          	blez	a2,226 <memmove+0x2c>
 236:	fff6079b          	addiw	a5,a2,-1
 23a:	1782                	slli	a5,a5,0x20
 23c:	9381                	srli	a5,a5,0x20
 23e:	fff7c793          	not	a5,a5
 242:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 244:	15fd                	addi	a1,a1,-1
 246:	177d                	addi	a4,a4,-1
 248:	0005c683          	lbu	a3,0(a1)
 24c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 250:	fee79ae3          	bne	a5,a4,244 <memmove+0x4a>
 254:	bfc9                	j	226 <memmove+0x2c>

0000000000000256 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25c:	ca05                	beqz	a2,28c <memcmp+0x36>
 25e:	fff6069b          	addiw	a3,a2,-1
 262:	1682                	slli	a3,a3,0x20
 264:	9281                	srli	a3,a3,0x20
 266:	0685                	addi	a3,a3,1
 268:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 26a:	00054783          	lbu	a5,0(a0)
 26e:	0005c703          	lbu	a4,0(a1)
 272:	00e79863          	bne	a5,a4,282 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 276:	0505                	addi	a0,a0,1
    p2++;
 278:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 27a:	fed518e3          	bne	a0,a3,26a <memcmp+0x14>
  }
  return 0;
 27e:	4501                	li	a0,0
 280:	a019                	j	286 <memcmp+0x30>
      return *p1 - *p2;
 282:	40e7853b          	subw	a0,a5,a4
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  return 0;
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <memcmp+0x30>

0000000000000290 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 298:	00000097          	auipc	ra,0x0
 29c:	f62080e7          	jalr	-158(ra) # 1fa <memmove>
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a8:	4885                	li	a7,1
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b0:	4889                	li	a7,2
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b8:	488d                	li	a7,3
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c0:	4891                	li	a7,4
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <read>:
.global read
read:
 li a7, SYS_read
 2c8:	4895                	li	a7,5
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <write>:
.global write
write:
 li a7, SYS_write
 2d0:	48c1                	li	a7,16
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <close>:
.global close
close:
 li a7, SYS_close
 2d8:	48d5                	li	a7,21
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e0:	4899                	li	a7,6
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e8:	489d                	li	a7,7
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <open>:
.global open
open:
 li a7, SYS_open
 2f0:	48bd                	li	a7,15
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f8:	48c5                	li	a7,17
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 300:	48c9                	li	a7,18
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 308:	48a1                	li	a7,8
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <link>:
.global link
link:
 li a7, SYS_link
 310:	48cd                	li	a7,19
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 318:	48d1                	li	a7,20
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 320:	48a5                	li	a7,9
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <dup>:
.global dup
dup:
 li a7, SYS_dup
 328:	48a9                	li	a7,10
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 330:	48ad                	li	a7,11
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 338:	48b1                	li	a7,12
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 340:	48b5                	li	a7,13
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 348:	48b9                	li	a7,14
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 350:	1101                	addi	sp,sp,-32
 352:	ec06                	sd	ra,24(sp)
 354:	e822                	sd	s0,16(sp)
 356:	1000                	addi	s0,sp,32
 358:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 35c:	4605                	li	a2,1
 35e:	fef40593          	addi	a1,s0,-17
 362:	00000097          	auipc	ra,0x0
 366:	f6e080e7          	jalr	-146(ra) # 2d0 <write>
}
 36a:	60e2                	ld	ra,24(sp)
 36c:	6442                	ld	s0,16(sp)
 36e:	6105                	addi	sp,sp,32
 370:	8082                	ret

0000000000000372 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 372:	7139                	addi	sp,sp,-64
 374:	fc06                	sd	ra,56(sp)
 376:	f822                	sd	s0,48(sp)
 378:	f426                	sd	s1,40(sp)
 37a:	f04a                	sd	s2,32(sp)
 37c:	ec4e                	sd	s3,24(sp)
 37e:	0080                	addi	s0,sp,64
 380:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 382:	c299                	beqz	a3,388 <printint+0x16>
 384:	0805c863          	bltz	a1,414 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 388:	2581                	sext.w	a1,a1
  neg = 0;
 38a:	4881                	li	a7,0
 38c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 390:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 392:	2601                	sext.w	a2,a2
 394:	00000517          	auipc	a0,0x0
 398:	44450513          	addi	a0,a0,1092 # 7d8 <digits>
 39c:	883a                	mv	a6,a4
 39e:	2705                	addiw	a4,a4,1
 3a0:	02c5f7bb          	remuw	a5,a1,a2
 3a4:	1782                	slli	a5,a5,0x20
 3a6:	9381                	srli	a5,a5,0x20
 3a8:	97aa                	add	a5,a5,a0
 3aa:	0007c783          	lbu	a5,0(a5)
 3ae:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3b2:	0005879b          	sext.w	a5,a1
 3b6:	02c5d5bb          	divuw	a1,a1,a2
 3ba:	0685                	addi	a3,a3,1
 3bc:	fec7f0e3          	bgeu	a5,a2,39c <printint+0x2a>
  if(neg)
 3c0:	00088b63          	beqz	a7,3d6 <printint+0x64>
    buf[i++] = '-';
 3c4:	fd040793          	addi	a5,s0,-48
 3c8:	973e                	add	a4,a4,a5
 3ca:	02d00793          	li	a5,45
 3ce:	fef70823          	sb	a5,-16(a4)
 3d2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3d6:	02e05863          	blez	a4,406 <printint+0x94>
 3da:	fc040793          	addi	a5,s0,-64
 3de:	00e78933          	add	s2,a5,a4
 3e2:	fff78993          	addi	s3,a5,-1
 3e6:	99ba                	add	s3,s3,a4
 3e8:	377d                	addiw	a4,a4,-1
 3ea:	1702                	slli	a4,a4,0x20
 3ec:	9301                	srli	a4,a4,0x20
 3ee:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3f2:	fff94583          	lbu	a1,-1(s2)
 3f6:	8526                	mv	a0,s1
 3f8:	00000097          	auipc	ra,0x0
 3fc:	f58080e7          	jalr	-168(ra) # 350 <putc>
  while(--i >= 0)
 400:	197d                	addi	s2,s2,-1
 402:	ff3918e3          	bne	s2,s3,3f2 <printint+0x80>
}
 406:	70e2                	ld	ra,56(sp)
 408:	7442                	ld	s0,48(sp)
 40a:	74a2                	ld	s1,40(sp)
 40c:	7902                	ld	s2,32(sp)
 40e:	69e2                	ld	s3,24(sp)
 410:	6121                	addi	sp,sp,64
 412:	8082                	ret
    x = -xx;
 414:	40b005bb          	negw	a1,a1
    neg = 1;
 418:	4885                	li	a7,1
    x = -xx;
 41a:	bf8d                	j	38c <printint+0x1a>

000000000000041c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 41c:	7119                	addi	sp,sp,-128
 41e:	fc86                	sd	ra,120(sp)
 420:	f8a2                	sd	s0,112(sp)
 422:	f4a6                	sd	s1,104(sp)
 424:	f0ca                	sd	s2,96(sp)
 426:	ecce                	sd	s3,88(sp)
 428:	e8d2                	sd	s4,80(sp)
 42a:	e4d6                	sd	s5,72(sp)
 42c:	e0da                	sd	s6,64(sp)
 42e:	fc5e                	sd	s7,56(sp)
 430:	f862                	sd	s8,48(sp)
 432:	f466                	sd	s9,40(sp)
 434:	f06a                	sd	s10,32(sp)
 436:	ec6e                	sd	s11,24(sp)
 438:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 43a:	0005c903          	lbu	s2,0(a1)
 43e:	18090f63          	beqz	s2,5dc <vprintf+0x1c0>
 442:	8aaa                	mv	s5,a0
 444:	8b32                	mv	s6,a2
 446:	00158493          	addi	s1,a1,1
  state = 0;
 44a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 44c:	02500a13          	li	s4,37
      if(c == 'd'){
 450:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 454:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 458:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 45c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 460:	00000b97          	auipc	s7,0x0
 464:	378b8b93          	addi	s7,s7,888 # 7d8 <digits>
 468:	a839                	j	486 <vprintf+0x6a>
        putc(fd, c);
 46a:	85ca                	mv	a1,s2
 46c:	8556                	mv	a0,s5
 46e:	00000097          	auipc	ra,0x0
 472:	ee2080e7          	jalr	-286(ra) # 350 <putc>
 476:	a019                	j	47c <vprintf+0x60>
    } else if(state == '%'){
 478:	01498f63          	beq	s3,s4,496 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 47c:	0485                	addi	s1,s1,1
 47e:	fff4c903          	lbu	s2,-1(s1)
 482:	14090d63          	beqz	s2,5dc <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 486:	0009079b          	sext.w	a5,s2
    if(state == 0){
 48a:	fe0997e3          	bnez	s3,478 <vprintf+0x5c>
      if(c == '%'){
 48e:	fd479ee3          	bne	a5,s4,46a <vprintf+0x4e>
        state = '%';
 492:	89be                	mv	s3,a5
 494:	b7e5                	j	47c <vprintf+0x60>
      if(c == 'd'){
 496:	05878063          	beq	a5,s8,4d6 <vprintf+0xba>
      } else if(c == 'l') {
 49a:	05978c63          	beq	a5,s9,4f2 <vprintf+0xd6>
      } else if(c == 'x') {
 49e:	07a78863          	beq	a5,s10,50e <vprintf+0xf2>
      } else if(c == 'p') {
 4a2:	09b78463          	beq	a5,s11,52a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4a6:	07300713          	li	a4,115
 4aa:	0ce78663          	beq	a5,a4,576 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ae:	06300713          	li	a4,99
 4b2:	0ee78e63          	beq	a5,a4,5ae <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4b6:	11478863          	beq	a5,s4,5c6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4ba:	85d2                	mv	a1,s4
 4bc:	8556                	mv	a0,s5
 4be:	00000097          	auipc	ra,0x0
 4c2:	e92080e7          	jalr	-366(ra) # 350 <putc>
        putc(fd, c);
 4c6:	85ca                	mv	a1,s2
 4c8:	8556                	mv	a0,s5
 4ca:	00000097          	auipc	ra,0x0
 4ce:	e86080e7          	jalr	-378(ra) # 350 <putc>
      }
      state = 0;
 4d2:	4981                	li	s3,0
 4d4:	b765                	j	47c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4d6:	008b0913          	addi	s2,s6,8
 4da:	4685                	li	a3,1
 4dc:	4629                	li	a2,10
 4de:	000b2583          	lw	a1,0(s6)
 4e2:	8556                	mv	a0,s5
 4e4:	00000097          	auipc	ra,0x0
 4e8:	e8e080e7          	jalr	-370(ra) # 372 <printint>
 4ec:	8b4a                	mv	s6,s2
      state = 0;
 4ee:	4981                	li	s3,0
 4f0:	b771                	j	47c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4f2:	008b0913          	addi	s2,s6,8
 4f6:	4681                	li	a3,0
 4f8:	4629                	li	a2,10
 4fa:	000b2583          	lw	a1,0(s6)
 4fe:	8556                	mv	a0,s5
 500:	00000097          	auipc	ra,0x0
 504:	e72080e7          	jalr	-398(ra) # 372 <printint>
 508:	8b4a                	mv	s6,s2
      state = 0;
 50a:	4981                	li	s3,0
 50c:	bf85                	j	47c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 50e:	008b0913          	addi	s2,s6,8
 512:	4681                	li	a3,0
 514:	4641                	li	a2,16
 516:	000b2583          	lw	a1,0(s6)
 51a:	8556                	mv	a0,s5
 51c:	00000097          	auipc	ra,0x0
 520:	e56080e7          	jalr	-426(ra) # 372 <printint>
 524:	8b4a                	mv	s6,s2
      state = 0;
 526:	4981                	li	s3,0
 528:	bf91                	j	47c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 52a:	008b0793          	addi	a5,s6,8
 52e:	f8f43423          	sd	a5,-120(s0)
 532:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 536:	03000593          	li	a1,48
 53a:	8556                	mv	a0,s5
 53c:	00000097          	auipc	ra,0x0
 540:	e14080e7          	jalr	-492(ra) # 350 <putc>
  putc(fd, 'x');
 544:	85ea                	mv	a1,s10
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	e08080e7          	jalr	-504(ra) # 350 <putc>
 550:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 552:	03c9d793          	srli	a5,s3,0x3c
 556:	97de                	add	a5,a5,s7
 558:	0007c583          	lbu	a1,0(a5)
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	df2080e7          	jalr	-526(ra) # 350 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 566:	0992                	slli	s3,s3,0x4
 568:	397d                	addiw	s2,s2,-1
 56a:	fe0914e3          	bnez	s2,552 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 56e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 572:	4981                	li	s3,0
 574:	b721                	j	47c <vprintf+0x60>
        s = va_arg(ap, char*);
 576:	008b0993          	addi	s3,s6,8
 57a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 57e:	02090163          	beqz	s2,5a0 <vprintf+0x184>
        while(*s != 0){
 582:	00094583          	lbu	a1,0(s2)
 586:	c9a1                	beqz	a1,5d6 <vprintf+0x1ba>
          putc(fd, *s);
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	dc6080e7          	jalr	-570(ra) # 350 <putc>
          s++;
 592:	0905                	addi	s2,s2,1
        while(*s != 0){
 594:	00094583          	lbu	a1,0(s2)
 598:	f9e5                	bnez	a1,588 <vprintf+0x16c>
        s = va_arg(ap, char*);
 59a:	8b4e                	mv	s6,s3
      state = 0;
 59c:	4981                	li	s3,0
 59e:	bdf9                	j	47c <vprintf+0x60>
          s = "(null)";
 5a0:	00000917          	auipc	s2,0x0
 5a4:	23090913          	addi	s2,s2,560 # 7d0 <malloc+0xea>
        while(*s != 0){
 5a8:	02800593          	li	a1,40
 5ac:	bff1                	j	588 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5ae:	008b0913          	addi	s2,s6,8
 5b2:	000b4583          	lbu	a1,0(s6)
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	d98080e7          	jalr	-616(ra) # 350 <putc>
 5c0:	8b4a                	mv	s6,s2
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	bd65                	j	47c <vprintf+0x60>
        putc(fd, c);
 5c6:	85d2                	mv	a1,s4
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	d86080e7          	jalr	-634(ra) # 350 <putc>
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b565                	j	47c <vprintf+0x60>
        s = va_arg(ap, char*);
 5d6:	8b4e                	mv	s6,s3
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	b54d                	j	47c <vprintf+0x60>
    }
  }
}
 5dc:	70e6                	ld	ra,120(sp)
 5de:	7446                	ld	s0,112(sp)
 5e0:	74a6                	ld	s1,104(sp)
 5e2:	7906                	ld	s2,96(sp)
 5e4:	69e6                	ld	s3,88(sp)
 5e6:	6a46                	ld	s4,80(sp)
 5e8:	6aa6                	ld	s5,72(sp)
 5ea:	6b06                	ld	s6,64(sp)
 5ec:	7be2                	ld	s7,56(sp)
 5ee:	7c42                	ld	s8,48(sp)
 5f0:	7ca2                	ld	s9,40(sp)
 5f2:	7d02                	ld	s10,32(sp)
 5f4:	6de2                	ld	s11,24(sp)
 5f6:	6109                	addi	sp,sp,128
 5f8:	8082                	ret

00000000000005fa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5fa:	715d                	addi	sp,sp,-80
 5fc:	ec06                	sd	ra,24(sp)
 5fe:	e822                	sd	s0,16(sp)
 600:	1000                	addi	s0,sp,32
 602:	e010                	sd	a2,0(s0)
 604:	e414                	sd	a3,8(s0)
 606:	e818                	sd	a4,16(s0)
 608:	ec1c                	sd	a5,24(s0)
 60a:	03043023          	sd	a6,32(s0)
 60e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 612:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 616:	8622                	mv	a2,s0
 618:	00000097          	auipc	ra,0x0
 61c:	e04080e7          	jalr	-508(ra) # 41c <vprintf>
}
 620:	60e2                	ld	ra,24(sp)
 622:	6442                	ld	s0,16(sp)
 624:	6161                	addi	sp,sp,80
 626:	8082                	ret

0000000000000628 <printf>:

void
printf(const char *fmt, ...)
{
 628:	711d                	addi	sp,sp,-96
 62a:	ec06                	sd	ra,24(sp)
 62c:	e822                	sd	s0,16(sp)
 62e:	1000                	addi	s0,sp,32
 630:	e40c                	sd	a1,8(s0)
 632:	e810                	sd	a2,16(s0)
 634:	ec14                	sd	a3,24(s0)
 636:	f018                	sd	a4,32(s0)
 638:	f41c                	sd	a5,40(s0)
 63a:	03043823          	sd	a6,48(s0)
 63e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 642:	00840613          	addi	a2,s0,8
 646:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 64a:	85aa                	mv	a1,a0
 64c:	4505                	li	a0,1
 64e:	00000097          	auipc	ra,0x0
 652:	dce080e7          	jalr	-562(ra) # 41c <vprintf>
}
 656:	60e2                	ld	ra,24(sp)
 658:	6442                	ld	s0,16(sp)
 65a:	6125                	addi	sp,sp,96
 65c:	8082                	ret

000000000000065e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 65e:	1141                	addi	sp,sp,-16
 660:	e422                	sd	s0,8(sp)
 662:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 664:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 668:	00000797          	auipc	a5,0x0
 66c:	1887b783          	ld	a5,392(a5) # 7f0 <freep>
 670:	a805                	j	6a0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 672:	4618                	lw	a4,8(a2)
 674:	9db9                	addw	a1,a1,a4
 676:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 67a:	6398                	ld	a4,0(a5)
 67c:	6318                	ld	a4,0(a4)
 67e:	fee53823          	sd	a4,-16(a0)
 682:	a091                	j	6c6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 684:	ff852703          	lw	a4,-8(a0)
 688:	9e39                	addw	a2,a2,a4
 68a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 68c:	ff053703          	ld	a4,-16(a0)
 690:	e398                	sd	a4,0(a5)
 692:	a099                	j	6d8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 694:	6398                	ld	a4,0(a5)
 696:	00e7e463          	bltu	a5,a4,69e <free+0x40>
 69a:	00e6ea63          	bltu	a3,a4,6ae <free+0x50>
{
 69e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a0:	fed7fae3          	bgeu	a5,a3,694 <free+0x36>
 6a4:	6398                	ld	a4,0(a5)
 6a6:	00e6e463          	bltu	a3,a4,6ae <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6aa:	fee7eae3          	bltu	a5,a4,69e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6ae:	ff852583          	lw	a1,-8(a0)
 6b2:	6390                	ld	a2,0(a5)
 6b4:	02059713          	slli	a4,a1,0x20
 6b8:	9301                	srli	a4,a4,0x20
 6ba:	0712                	slli	a4,a4,0x4
 6bc:	9736                	add	a4,a4,a3
 6be:	fae60ae3          	beq	a2,a4,672 <free+0x14>
    bp->s.ptr = p->s.ptr;
 6c2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6c6:	4790                	lw	a2,8(a5)
 6c8:	02061713          	slli	a4,a2,0x20
 6cc:	9301                	srli	a4,a4,0x20
 6ce:	0712                	slli	a4,a4,0x4
 6d0:	973e                	add	a4,a4,a5
 6d2:	fae689e3          	beq	a3,a4,684 <free+0x26>
  } else
    p->s.ptr = bp;
 6d6:	e394                	sd	a3,0(a5)
  freep = p;
 6d8:	00000717          	auipc	a4,0x0
 6dc:	10f73c23          	sd	a5,280(a4) # 7f0 <freep>
}
 6e0:	6422                	ld	s0,8(sp)
 6e2:	0141                	addi	sp,sp,16
 6e4:	8082                	ret

00000000000006e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e6:	7139                	addi	sp,sp,-64
 6e8:	fc06                	sd	ra,56(sp)
 6ea:	f822                	sd	s0,48(sp)
 6ec:	f426                	sd	s1,40(sp)
 6ee:	f04a                	sd	s2,32(sp)
 6f0:	ec4e                	sd	s3,24(sp)
 6f2:	e852                	sd	s4,16(sp)
 6f4:	e456                	sd	s5,8(sp)
 6f6:	e05a                	sd	s6,0(sp)
 6f8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6fa:	02051493          	slli	s1,a0,0x20
 6fe:	9081                	srli	s1,s1,0x20
 700:	04bd                	addi	s1,s1,15
 702:	8091                	srli	s1,s1,0x4
 704:	0014899b          	addiw	s3,s1,1
 708:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 70a:	00000517          	auipc	a0,0x0
 70e:	0e653503          	ld	a0,230(a0) # 7f0 <freep>
 712:	c515                	beqz	a0,73e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 714:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 716:	4798                	lw	a4,8(a5)
 718:	02977f63          	bgeu	a4,s1,756 <malloc+0x70>
 71c:	8a4e                	mv	s4,s3
 71e:	0009871b          	sext.w	a4,s3
 722:	6685                	lui	a3,0x1
 724:	00d77363          	bgeu	a4,a3,72a <malloc+0x44>
 728:	6a05                	lui	s4,0x1
 72a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 72e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 732:	00000917          	auipc	s2,0x0
 736:	0be90913          	addi	s2,s2,190 # 7f0 <freep>
  if(p == (char*)-1)
 73a:	5afd                	li	s5,-1
 73c:	a88d                	j	7ae <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 73e:	00000797          	auipc	a5,0x0
 742:	0ba78793          	addi	a5,a5,186 # 7f8 <base>
 746:	00000717          	auipc	a4,0x0
 74a:	0af73523          	sd	a5,170(a4) # 7f0 <freep>
 74e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 750:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 754:	b7e1                	j	71c <malloc+0x36>
      if(p->s.size == nunits)
 756:	02e48b63          	beq	s1,a4,78c <malloc+0xa6>
        p->s.size -= nunits;
 75a:	4137073b          	subw	a4,a4,s3
 75e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 760:	1702                	slli	a4,a4,0x20
 762:	9301                	srli	a4,a4,0x20
 764:	0712                	slli	a4,a4,0x4
 766:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 768:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 76c:	00000717          	auipc	a4,0x0
 770:	08a73223          	sd	a0,132(a4) # 7f0 <freep>
      return (void*)(p + 1);
 774:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 778:	70e2                	ld	ra,56(sp)
 77a:	7442                	ld	s0,48(sp)
 77c:	74a2                	ld	s1,40(sp)
 77e:	7902                	ld	s2,32(sp)
 780:	69e2                	ld	s3,24(sp)
 782:	6a42                	ld	s4,16(sp)
 784:	6aa2                	ld	s5,8(sp)
 786:	6b02                	ld	s6,0(sp)
 788:	6121                	addi	sp,sp,64
 78a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 78c:	6398                	ld	a4,0(a5)
 78e:	e118                	sd	a4,0(a0)
 790:	bff1                	j	76c <malloc+0x86>
  hp->s.size = nu;
 792:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 796:	0541                	addi	a0,a0,16
 798:	00000097          	auipc	ra,0x0
 79c:	ec6080e7          	jalr	-314(ra) # 65e <free>
  return freep;
 7a0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7a4:	d971                	beqz	a0,778 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a8:	4798                	lw	a4,8(a5)
 7aa:	fa9776e3          	bgeu	a4,s1,756 <malloc+0x70>
    if(p == freep)
 7ae:	00093703          	ld	a4,0(s2)
 7b2:	853e                	mv	a0,a5
 7b4:	fef719e3          	bne	a4,a5,7a6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7b8:	8552                	mv	a0,s4
 7ba:	00000097          	auipc	ra,0x0
 7be:	b7e080e7          	jalr	-1154(ra) # 338 <sbrk>
  if(p == (char*)-1)
 7c2:	fd5518e3          	bne	a0,s5,792 <malloc+0xac>
        return 0;
 7c6:	4501                	li	a0,0
 7c8:	bf45                	j	778 <malloc+0x92>
