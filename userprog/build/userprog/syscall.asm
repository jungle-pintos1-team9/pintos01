
syscall.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <syscall_init>:
   0:	f3 0f 1e fa          	endbr64 
   4:	55                   	push   %rbp
   5:	48 89 e5             	mov    %rsp,%rbp
   8:	48 83 ec 50          	sub    $0x50,%rsp
   c:	c7 45 cc 81 00 00 c0 	movl   $0xc0000081,-0x34(%rbp)
  13:	48 b8 00 00 00 00 08 	movabs $0x13000800000000,%rax
  1a:	00 13 00 
  1d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  21:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  25:	89 45 bc             	mov    %eax,-0x44(%rbp)
  28:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  2c:	48 c1 e8 20          	shr    $0x20,%rax
  30:	89 45 b8             	mov    %eax,-0x48(%rbp)
  33:	8b 4d cc             	mov    -0x34(%rbp),%ecx
  36:	8b 55 b8             	mov    -0x48(%rbp),%edx
  39:	8b 45 bc             	mov    -0x44(%rbp),%eax
  3c:	0f 30                	wrmsr  
  3e:	90                   	nop
  3f:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
  46:	00 00 00 
  49:	c7 45 e4 82 00 00 c0 	movl   $0xc0000082,-0x1c(%rbp)
  50:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  58:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  5f:	48 c1 e8 20          	shr    $0x20,%rax
  63:	89 45 d0             	mov    %eax,-0x30(%rbp)
  66:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  69:	8b 55 d0             	mov    -0x30(%rbp),%edx
  6c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  6f:	0f 30                	wrmsr  
  71:	90                   	nop
  72:	c7 45 fc 84 00 00 c0 	movl   $0xc0000084,-0x4(%rbp)
  79:	48 c7 45 f0 00 77 04 	movq   $0x47700,-0x10(%rbp)
  80:	00 
  81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  85:	89 45 ec             	mov    %eax,-0x14(%rbp)
  88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8c:	48 c1 e8 20          	shr    $0x20,%rax
  90:	89 45 e8             	mov    %eax,-0x18(%rbp)
  93:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  96:	8b 55 e8             	mov    -0x18(%rbp),%edx
  99:	8b 45 ec             	mov    -0x14(%rbp),%eax
  9c:	0f 30                	wrmsr  
  9e:	90                   	nop
  9f:	90                   	nop
  a0:	c9                   	leave  
  a1:	c3                   	ret    

00000000000000a2 <syscall_handler>:
  a2:	f3 0f 1e fa          	endbr64 
  a6:	55                   	push   %rbp
  a7:	48 89 e5             	mov    %rsp,%rbp
  aa:	48 83 ec 10          	sub    $0x10,%rsp
  ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  b6:	48 8b 80 b0 00 00 00 	mov    0xb0(%rax),%rax
  bd:	48 89 c7             	mov    %rax,%rdi
  c0:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
  c7:	00 00 00 
  ca:	ff d0                	call   *%rax
  cc:	83 f0 01             	xor    $0x1,%eax
  cf:	84 c0                	test   %al,%al
  d1:	74 0c                	je     df <syscall_handler+0x3d>
  d3:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
  da:	00 00 00 
  dd:	ff d0                	call   *%rax
  df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  e3:	48 8b 40 70          	mov    0x70(%rax),%rax
  e7:	48 83 f8 0d          	cmp    $0xd,%rax
  eb:	0f 87 01 01 00 00    	ja     1f2 <syscall_handler+0x150>
  f1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  f8:	00 
  f9:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 100:	00 00 00 
 103:	48 01 d0             	add    %rdx,%rax
 106:	48 8b 00             	mov    (%rax),%rax
 109:	3e ff e0             	notrack jmp *%rax
 10c:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 113:	00 00 00 
 116:	ff d0                	call   *%rax
 118:	e9 d5 00 00 00       	jmp    1f2 <syscall_handler+0x150>
 11d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 121:	48 8b 40 48          	mov    0x48(%rax),%rax
 125:	89 c7                	mov    %eax,%edi
 127:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 12e:	00 00 00 
 131:	ff d0                	call   *%rax
 133:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 137:	48 8b 40 40          	mov    0x40(%rax),%rax
 13b:	89 c2                	mov    %eax,%edx
 13d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 141:	48 8b 40 48          	mov    0x48(%rax),%rax
 145:	89 d6                	mov    %edx,%esi
 147:	48 89 c7             	mov    %rax,%rdi
 14a:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 151:	00 00 00 
 154:	ff d0                	call   *%rax
 156:	0f b6 d0             	movzbl %al,%edx
 159:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 15d:	48 89 50 70          	mov    %rdx,0x70(%rax)
 161:	e9 8c 00 00 00       	jmp    1f2 <syscall_handler+0x150>
 166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 16a:	48 8b 40 48          	mov    0x48(%rax),%rax
 16e:	48 89 c7             	mov    %rax,%rdi
 171:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 178:	00 00 00 
 17b:	ff d0                	call   *%rax
 17d:	0f b6 d0             	movzbl %al,%edx
 180:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 184:	48 89 50 70          	mov    %rdx,0x70(%rax)
 188:	eb 68                	jmp    1f2 <syscall_handler+0x150>
 18a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 18e:	48 8b 40 48          	mov    0x48(%rax),%rax
 192:	48 89 c7             	mov    %rax,%rdi
 195:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 19c:	00 00 00 
 19f:	ff d0                	call   *%rax
 1a1:	48 63 d0             	movslq %eax,%rdx
 1a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 1a8:	48 89 50 70          	mov    %rdx,0x70(%rax)
 1ac:	eb 44                	jmp    1f2 <syscall_handler+0x150>
 1ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 1b2:	48 8b 40 48          	mov    0x48(%rax),%rax
 1b6:	89 c7                	mov    %eax,%edi
 1b8:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 1bf:	00 00 00 
 1c2:	ff d0                	call   *%rax
 1c4:	eb 2c                	jmp    1f2 <syscall_handler+0x150>
 1c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 1ca:	48 8b 40 40          	mov    0x40(%rax),%rax
 1ce:	48 89 c6             	mov    %rax,%rsi
 1d1:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 1d8:	00 00 00 
 1db:	48 89 c7             	mov    %rax,%rdi
 1de:	b8 00 00 00 00       	mov    $0x0,%eax
 1e3:	48 ba 00 00 00 00 00 	movabs $0x0,%rdx
 1ea:	00 00 00 
 1ed:	ff d2                	call   *%rdx
 1ef:	eb 01                	jmp    1f2 <syscall_handler+0x150>
 1f1:	90                   	nop
 1f2:	90                   	nop
 1f3:	c9                   	leave  
 1f4:	c3                   	ret    

00000000000001f5 <halt>:
 1f5:	f3 0f 1e fa          	endbr64 
 1f9:	55                   	push   %rbp
 1fa:	48 89 e5             	mov    %rsp,%rbp
 1fd:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 204:	00 00 00 
 207:	ff d0                	call   *%rax

0000000000000209 <exit>:
 209:	f3 0f 1e fa          	endbr64 
 20d:	55                   	push   %rbp
 20e:	48 89 e5             	mov    %rsp,%rbp
 211:	48 83 ec 30          	sub    $0x30,%rsp
 215:	89 7d dc             	mov    %edi,-0x24(%rbp)
 218:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 21f:	00 00 00 
 222:	ff d0                	call   *%rax
 224:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
 228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
 22c:	48 83 c0 78          	add    $0x78,%rax
 230:	48 89 c7             	mov    %rax,%rdi
 233:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 23a:	00 00 00 
 23d:	ff d0                	call   *%rax
 23f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
 243:	eb 5c                	jmp    2a1 <exit+0x98>
 245:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 249:	48 83 c0 08          	add    $0x8,%rax
 24d:	48 83 e8 18          	sub    $0x18,%rax
 251:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
 255:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
 259:	48 8b 40 08          	mov    0x8(%rax),%rax
 25d:	48 89 c7             	mov    %rax,%rdi
 260:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 267:	00 00 00 
 26a:	ff d0                	call   *%rax
 26c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
 270:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
 277:	00 
 278:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
 27c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
 282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
 286:	48 89 c7             	mov    %rax,%rdi
 289:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 290:	00 00 00 
 293:	ff d0                	call   *%rax
 295:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 299:	48 8b 40 08          	mov    0x8(%rax),%rax
 29d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
 2a1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
 2a6:	75 9d                	jne    245 <exit+0x3c>
 2a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
 2ac:	8b 55 dc             	mov    -0x24(%rbp),%edx
 2af:	89 90 18 01 00 00    	mov    %edx,0x118(%rax)
 2b5:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 2bc:	00 00 00 
 2bf:	ff d0                	call   *%rax
 2c1:	48 89 c1             	mov    %rax,%rcx
 2c4:	8b 45 dc             	mov    -0x24(%rbp),%eax
 2c7:	89 c2                	mov    %eax,%edx
 2c9:	48 89 ce             	mov    %rcx,%rsi
 2cc:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 2d3:	00 00 00 
 2d6:	48 89 c7             	mov    %rax,%rdi
 2d9:	b8 00 00 00 00       	mov    $0x0,%eax
 2de:	48 b9 00 00 00 00 00 	movabs $0x0,%rcx
 2e5:	00 00 00 
 2e8:	ff d1                	call   *%rcx
 2ea:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 2f1:	00 00 00 
 2f4:	ff d0                	call   *%rax

00000000000002f6 <create>:
 2f6:	f3 0f 1e fa          	endbr64 
 2fa:	55                   	push   %rbp
 2fb:	48 89 e5             	mov    %rsp,%rbp
 2fe:	48 83 ec 10          	sub    $0x10,%rsp
 302:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
 306:	89 75 f4             	mov    %esi,-0xc(%rbp)
 309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 30d:	48 89 c7             	mov    %rax,%rdi
 310:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 317:	00 00 00 
 31a:	ff d0                	call   *%rax
 31c:	84 c0                	test   %al,%al
 31e:	74 1a                	je     33a <create+0x44>
 320:	8b 55 f4             	mov    -0xc(%rbp),%edx
 323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 327:	89 d6                	mov    %edx,%esi
 329:	48 89 c7             	mov    %rax,%rdi
 32c:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 333:	00 00 00 
 336:	ff d0                	call   *%rax
 338:	eb 11                	jmp    34b <create+0x55>
 33a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 33f:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 346:	00 00 00 
 349:	ff d0                	call   *%rax
 34b:	c9                   	leave  
 34c:	c3                   	ret    

000000000000034d <remove>:
 34d:	f3 0f 1e fa          	endbr64 
 351:	55                   	push   %rbp
 352:	48 89 e5             	mov    %rsp,%rbp
 355:	48 83 ec 10          	sub    $0x10,%rsp
 359:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
 35d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
 362:	74 2c                	je     390 <remove+0x43>
 364:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 368:	48 89 c7             	mov    %rax,%rdi
 36b:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 372:	00 00 00 
 375:	ff d0                	call   *%rax
 377:	84 c0                	test   %al,%al
 379:	74 15                	je     390 <remove+0x43>
 37b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 37f:	48 89 c7             	mov    %rax,%rdi
 382:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 389:	00 00 00 
 38c:	ff d0                	call   *%rax
 38e:	eb 11                	jmp    3a1 <remove+0x54>
 390:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 395:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 39c:	00 00 00 
 39f:	ff d0                	call   *%rax
 3a1:	c9                   	leave  
 3a2:	c3                   	ret    

00000000000003a3 <open>:
 3a3:	f3 0f 1e fa          	endbr64 
 3a7:	55                   	push   %rbp
 3a8:	48 89 e5             	mov    %rsp,%rbp
 3ab:	48 83 ec 30          	sub    $0x30,%rsp
 3af:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
 3b3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
 3b8:	0f 84 f1 00 00 00    	je     4af <open+0x10c>
 3be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
 3c2:	48 89 c7             	mov    %rax,%rdi
 3c5:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 3cc:	00 00 00 
 3cf:	ff d0                	call   *%rax
 3d1:	84 c0                	test   %al,%al
 3d3:	0f 84 d6 00 00 00    	je     4af <open+0x10c>
 3d9:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 3e0:	00 00 00 
 3e3:	ff d0                	call   *%rax
 3e5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
 3e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
 3ed:	48 89 c7             	mov    %rax,%rdi
 3f0:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 3f7:	00 00 00 
 3fa:	ff d0                	call   *%rax
 3fc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
 400:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
 405:	0f 84 9d 00 00 00    	je     4a8 <open+0x105>
 40b:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
 412:	eb 04                	jmp    418 <open+0x75>
 414:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
 418:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
 41c:	8b 45 fc             	mov    -0x4(%rbp),%eax
 41f:	48 98                	cltq   
 421:	0f b6 84 02 98 00 00 	movzbl 0x98(%rdx,%rax,1),%eax
 428:	00 
 429:	83 f0 01             	xor    $0x1,%eax
 42c:	84 c0                	test   %al,%al
 42e:	74 06                	je     436 <open+0x93>
 430:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
 434:	7e de                	jle    414 <open+0x71>
 436:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%rbp)
 43d:	75 07                	jne    446 <open+0xa3>
 43f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 444:	eb 7a                	jmp    4c0 <open+0x11d>
 446:	bf 20 00 00 00       	mov    $0x20,%edi
 44b:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 452:	00 00 00 
 455:	ff d0                	call   *%rax
 457:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
 45b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
 45f:	8b 55 fc             	mov    -0x4(%rbp),%edx
 462:	89 10                	mov    %edx,(%rax)
 464:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
 468:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
 46c:	48 89 50 08          	mov    %rdx,0x8(%rax)
 470:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
 474:	8b 45 fc             	mov    -0x4(%rbp),%eax
 477:	48 98                	cltq   
 479:	c6 84 02 98 00 00 00 	movb   $0x0,0x98(%rdx,%rax,1)
 480:	00 
 481:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
 485:	48 8d 50 10          	lea    0x10(%rax),%rdx
 489:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
 48d:	48 83 c0 78          	add    $0x78,%rax
 491:	48 89 d6             	mov    %rdx,%rsi
 494:	48 89 c7             	mov    %rax,%rdi
 497:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 49e:	00 00 00 
 4a1:	ff d0                	call   *%rax
 4a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
 4a6:	eb 18                	jmp    4c0 <open+0x11d>
 4a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4ad:	eb 11                	jmp    4c0 <open+0x11d>
 4af:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 4b4:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 4bb:	00 00 00 
 4be:	ff d0                	call   *%rax
 4c0:	c9                   	leave  
 4c1:	c3                   	ret    

00000000000004c2 <close>:
 4c2:	f3 0f 1e fa          	endbr64 
 4c6:	55                   	push   %rbp
 4c7:	48 89 e5             	mov    %rsp,%rbp
 4ca:	48 83 ec 20          	sub    $0x20,%rsp
 4ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
 4d1:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 4d8:	00 00 00 
 4db:	ff d0                	call   *%rax
 4dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
 4e1:	90                   	nop
 4e2:	c9                   	leave  
 4e3:	c3                   	ret    

00000000000004e4 <check_address>:
 4e4:	f3 0f 1e fa          	endbr64 
 4e8:	55                   	push   %rbp
 4e9:	48 89 e5             	mov    %rsp,%rbp
 4ec:	48 83 ec 10          	sub    $0x10,%rsp
 4f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
 4f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 4f8:	48 ba ff ff ff 03 80 	movabs $0x8003ffffff,%rdx
 4ff:	00 00 00 
 502:	48 39 d0             	cmp    %rdx,%rax
 505:	77 2e                	ja     535 <check_address+0x51>
 507:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 50e:	00 00 00 
 511:	ff d0                	call   *%rax
 513:	48 8b 80 20 01 00 00 	mov    0x120(%rax),%rax
 51a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
 51e:	48 89 d6             	mov    %rdx,%rsi
 521:	48 89 c7             	mov    %rax,%rdi
 524:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
 52b:	00 00 00 
 52e:	ff d0                	call   *%rax
 530:	48 85 c0             	test   %rax,%rax
 533:	75 07                	jne    53c <check_address+0x58>
 535:	b8 00 00 00 00       	mov    $0x0,%eax
 53a:	eb 05                	jmp    541 <check_address+0x5d>
 53c:	b8 01 00 00 00       	mov    $0x1,%eax
 541:	c9                   	leave  
 542:	c3                   	ret    

0000000000000543 <get_argument>:
 543:	f3 0f 1e fa          	endbr64 
 547:	55                   	push   %rbp
 548:	48 89 e5             	mov    %rsp,%rbp
 54b:	48 83 ec 28          	sub    $0x28,%rsp
 54f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
 553:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
 557:	89 55 dc             	mov    %edx,-0x24(%rbp)
 55a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
 55e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
 562:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
 569:	eb 31                	jmp    59c <get_argument+0x59>
 56b:	8b 45 fc             	mov    -0x4(%rbp),%eax
 56e:	48 98                	cltq   
 570:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
 577:	00 
 578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
 57c:	48 01 d0             	add    %rdx,%rax
 57f:	8b 55 fc             	mov    -0x4(%rbp),%edx
 582:	48 63 d2             	movslq %edx,%rdx
 585:	48 8d 0c 95 00 00 00 	lea    0x0(,%rdx,4),%rcx
 58c:	00 
 58d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
 591:	48 01 ca             	add    %rcx,%rdx
 594:	8b 00                	mov    (%rax),%eax
 596:	89 02                	mov    %eax,(%rdx)
 598:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
 59c:	8b 45 fc             	mov    -0x4(%rbp),%eax
 59f:	3b 45 dc             	cmp    -0x24(%rbp),%eax
 5a2:	7c c7                	jl     56b <get_argument+0x28>
 5a4:	90                   	nop
 5a5:	90                   	nop
 5a6:	c9                   	leave  
 5a7:	c3                   	ret    
