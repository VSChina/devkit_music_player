	.text
	.syntax unified
	.eabi_attribute	67, "2.09"	@ Tag_conformance
	.cpu	cortex-m4
	.eabi_attribute	6, 13	@ Tag_CPU_arch
	.eabi_attribute	7, 77	@ Tag_CPU_arch_profile
	.eabi_attribute	8, 0	@ Tag_ARM_ISA_use
	.eabi_attribute	9, 2	@ Tag_THUMB_ISA_use
	.fpu	fpv4-sp-d16
	.eabi_attribute	15, 1	@ Tag_ABI_PCS_RW_data
	.eabi_attribute	16, 1	@ Tag_ABI_PCS_RO_data
	.eabi_attribute	17, 2	@ Tag_ABI_PCS_GOT_use
	.eabi_attribute	20, 1	@ Tag_ABI_FP_denormal
	.eabi_attribute	21, 1	@ Tag_ABI_FP_exceptions
	.eabi_attribute	23, 3	@ Tag_ABI_FP_number_model
	.eabi_attribute	34, 1	@ Tag_CPU_unaligned_access
	.eabi_attribute	24, 1	@ Tag_ABI_align_needed
	.eabi_attribute	25, 1	@ Tag_ABI_align_preserved
	.eabi_attribute	27, 1	@ Tag_ABI_HardFP_use
	.eabi_attribute	36, 1	@ Tag_FP_HP_extension
	.eabi_attribute	38, 1	@ Tag_ABI_FP_16bit_format
	.eabi_attribute	14, 0	@ Tag_ABI_PCS_R9_use
	.file	"featurizer.opt.bc"
	.globl	mfcc_Filter
	.p2align	2
	.type	mfcc_Filter,%function
	.code	16                      @ @mfcc_Filter
	.thumb_func
mfcc_Filter:
	.fnstart
@ BB#0:                                 @ %entry
	.save	{r4, r5, r6, r7, r8, r9, r10, lr}
	push.w	{r4, r5, r6, r7, r8, r9, r10, lr}
	.pad	#3072
	sub.w	sp, sp, #3072
	ldr	r6, .LCPI0_1
	mov	r5, r1
	ldr	r1, .LCPI0_0
	mov	r8, r2
	mov.w	r2, #1024
.LPC0_2:
	add	r1, pc
.LPC0_1:
	add	r6, pc
	str	r0, [r1]
	mov	r0, r6
	mov	r1, r6
	bl	memmove
	mov	r0, r6
	mov	r1, r5
	mov.w	r2, #1024
	bl	memcpy
	ldr	r0, .LCPI0_2
	mov	r1, r6
	mov.w	r2, #1024
.LPC0_0:
	add	r0, pc
	bl	memcpy
	ldr	r1, .LCPI0_3
	ldr	r2, .LCPI0_4
	ldr	r3, .LCPI0_5
	movs	r0, #0
.LPC0_5:
	add	r1, pc
.LPC0_4:
	add	r2, pc
.LPC0_3:
	add	r3, pc
.LBB0_1:                                @ %loop.body.i9
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r7, r1, r0, lsl #2
	add.w	r6, r2, r0, lsl #2
	vldr	s2, [r7]
	vldr	s0, [r6]
	add.w	r7, r3, r0, lsl #2
	adds	r0, #1
	cmp.w	r0, #256
	vmul.f32	s0, s2, s0
	vstr	s0, [r7]
	blt	.LBB0_1
@ BB#2:                                 @ %_Node__BinaryOperationNode_float__in_256_256_out_256_Node_1109.exit
	ldr	r1, .LCPI0_6
	movs	r0, #0
	add.w	r5, sp, #1024
	movs	r2, #0
.LPC0_6:
	add	r1, pc
.LBB0_3:                                @ %loop.body.i6
                                        @ =>This Inner Loop Header: Depth=1
	ldr.w	r3, [r1, r2, lsl #2]
	str.w	r3, [r5, r2, lsl #3]
	add.w	r3, r5, r2, lsl #3
	adds	r2, #1
	str	r0, [r3, #4]
	cmp.w	r2, #256
	blt	.LBB0_3
@ BB#4:                                 @ %loop.body.i.preheader.i
	movs	r1, #0
	mov	r0, sp
	movs	r2, #0
.LBB0_5:                                @ %loop.body.i.i
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r3, r5, r1, lsl #3
	adds	r1, #2
	add.w	r7, r3, #8
	vldr	s0, [r3, #8]
	vldr	s2, [r7, #4]
	add.w	r7, r0, r2, lsl #3
	vstr	s0, [r7]
	vldr	s0, [r3]
	vstr	s2, [r7, #4]
	vldr	s2, [r3, #4]
	add.w	r3, r5, r2, lsl #3
	adds	r2, #1
	cmp	r2, #128
	vstr	s0, [r3]
	vstr	s2, [r3, #4]
	blt	.LBB0_5
@ BB#6:                                 @ %loop.body3.i.i.preheader
	movs	r1, #0
.LBB0_7:                                @ %loop.body3.i.i
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r3, r0, r1, lsl #3
	add.w	r2, r5, r1, lsl #3
	adds	r1, #1
	vldr	s0, [r3]
	vldr	s2, [r3, #4]
	add.w	r2, r2, #1024
	cmp	r1, #128
	vstr	s0, [r2]
	vstr	s2, [r2, #4]
	blt	.LBB0_7
@ BB#8:                                 @ %loop.after5.i.i
	mov	r7, sp
	mov	r0, r5
	mov	r1, r7
	bl	FFTC_float_128
	add.w	r6, r5, #1024
	mov	r1, r7
	mov	r0, r6
	bl	FFTC_float_128
	ldr	r1, .LCPI0_7
	movs	r0, #0
.LPC0_7:
	add	r1, pc
.LBB0_9:                                @ %loop.body8.i.i
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r2, r1, r0, lsl #3
	add.w	r3, r6, r0, lsl #3
	vldr	s0, [r3]
	vldr	s4, [r2]
	vldr	s6, [r2, #4]
	add.w	r2, r5, r0, lsl #3
	vldr	s2, [r3, #4]
	adds	r0, #1
	vldr	s8, [r2]
	vldr	s10, [r2, #4]
	cmp	r0, #128
	vmul.f32	s12, s4, s0
	vmul.f32	s4, s4, s2
	vmls.f32	s12, s6, s2
	vmla.f32	s4, s6, s0
	vadd.f32	s0, s8, s12
	vadd.f32	s2, s10, s4
	vsub.f32	s6, s8, s12
	vstr	s0, [r2]
	vsub.f32	s0, s10, s4
	vstr	s2, [r2, #4]
	vstr	s6, [r3]
	vstr	s0, [r3, #4]
	blt	.LBB0_9
@ BB#10:                                @ %loop.body3.i7.preheader
	ldr	r1, .LCPI0_8
	movs	r0, #0
.LPC0_8:
	add	r1, pc
.LBB0_11:                               @ %loop.body3.i7
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r2, r5, r0, lsl #3
	vldr	s2, [r2, #4]
	vldr	s0, [r2]
	add.w	r2, r1, r0, lsl #2
	adds	r0, #1
	cmp	r0, #128
	vmul.f32	s2, s2, s2
	vmla.f32	s2, s0, s0
	vsqrt.f32	s0, s2
	vstr	s0, [r2]
	blt	.LBB0_11
@ BB#12:                                @ %_Node__FFTNode_float__in_256_out_128.exit
	ldr.w	r12, .LCPI0_9
	ldr.w	lr, .LCPI0_11
	ldr.w	r9, .LCPI0_12
	ldr	r7, .LCPI0_13
	ldr	r6, .LCPI0_14
	ldr.w	r10, .LCPI0_15
	vldr	s0, .LCPI0_10
	movs	r0, #0
	vmov.f32	s2, #5.000000e-01
	vmov.f32	s4, #-5.000000e-01
.LPC0_9:
	add	r12, pc
.LPC0_10:
	add	lr, pc
.LPC0_11:
	add	r9, pc
.LPC0_12:
	add	r7, pc
.LPC0_13:
	add	r6, pc
.LPC0_14:
	add	r10, pc
.LBB0_13:                               @ %loop.body.i5
                                        @ =>This Loop Header: Depth=1
                                        @     Child Loop BB0_15 Depth 2
                                        @     Child Loop BB0_18 Depth 2
	ldr.w	r4, [r12, r0, lsl #2]
	ldr.w	r1, [lr, r0, lsl #2]
	ldr.w	r2, [r9, r0, lsl #2]
	vmov.f32	s6, s0
	cmp	r1, r2
	ble	.LBB0_16
@ BB#14:                                @ %loop.body3.lr.ph.i
                                        @   in Loop: Header=BB0_13 Depth=1
	subs	r5, r1, r2
	movs	r3, #0
	vmov	s6, r5
	vcvt.f32.s32	s8, s6
	vmov.f32	s6, s0
.LBB0_15:                               @ %loop.body3.i
                                        @   Parent Loop BB0_13 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	adds	r5, r2, r3
	vmov	s10, r3
	adds	r3, #1
	add.w	r5, r7, r5, lsl #2
	vcvt.f32.s32	s10, s10
	vldr	s12, [r5]
	vadd.f32	s10, s10, s2
	adds	r5, r2, r3
	vdiv.f32	s10, s10, s8
	cmp	r5, r1
	vmla.f32	s6, s12, s10
	blt	.LBB0_15
.LBB0_16:                               @ %loop.cond7.preheader.i
                                        @   in Loop: Header=BB0_13 Depth=1
	cmp	r4, r1
	ble	.LBB0_19
@ BB#17:                                @ %loop.body8.lr.ph.i
                                        @   in Loop: Header=BB0_13 Depth=1
	subs	r2, r4, r1
	vmov	s8, r2
	vcvt.f32.s32	s8, s8
.LBB0_18:                               @ %loop.body8.i
                                        @   Parent Loop BB0_13 Depth=1
                                        @ =>  This Inner Loop Header: Depth=2
	vmov	s10, r2
	add.w	r3, r6, r1, lsl #2
	adds	r1, #1
	subs	r2, #1
	vcvt.f32.s32	s10, s10
	vldr	s12, [r3]
	cmp	r4, r1
	vadd.f32	s10, s10, s4
	vdiv.f32	s10, s10, s8
	vmla.f32	s6, s12, s10
	bgt	.LBB0_18
.LBB0_19:                               @ %loop.after10.i
                                        @   in Loop: Header=BB0_13 Depth=1
	add.w	r1, r10, r0, lsl #2
	adds	r0, #1
	vstr	s6, [r1]
	cmp	r0, #40
	blt	.LBB0_13
@ BB#20:                                @ %loop.body.i4.preheader
	ldr	r1, .LCPI0_16
	ldr	r2, .LCPI0_17
	ldr	r3, .LCPI0_18
	movs	r0, #0
.LPC0_17:
	add	r1, pc
.LPC0_16:
	add	r2, pc
.LPC0_15:
	add	r3, pc
.LBB0_21:                               @ %loop.body.i4
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r7, r1, r0, lsl #2
	add.w	r6, r2, r0, lsl #2
	vldr	s2, [r7]
	vldr	s0, [r6]
	add.w	r7, r3, r0, lsl #2
	adds	r0, #1
	cmp	r0, #40
	vadd.f32	s0, s2, s0
	vstr	s0, [r7]
	blt	.LBB0_21
@ BB#22:                                @ %loop.body.i.preheader
	ldr	r5, .LCPI0_19
	ldr	r6, .LCPI0_20
	movs	r4, #0
.LPC0_19:
	add	r5, pc
.LPC0_18:
	add	r6, pc
.LBB0_23:                               @ %loop.body.i
                                        @ =>This Inner Loop Header: Depth=1
	ldr.w	r0, [r5, r4, lsl #2]
	bl	logf
	str.w	r0, [r6, r4, lsl #2]
	adds	r4, #1
	cmp	r4, #40
	blt	.LBB0_23
@ BB#24:                                @ %_Node__UnaryOperationNode_float__in_40_out_40_Node_1114.exit
	cmp.w	r8, #0
	itt	eq
	addeq.w	sp, sp, #3072
	popeq.w	{r4, r5, r6, r7, r8, r9, r10, pc}
	ldr	r1, .LCPI0_21
	mov	r0, r8
	movs	r2, #160
.LPC0_20:
	add	r1, pc
	add.w	sp, sp, #3072
	pop.w	{r4, r5, r6, r7, r8, r9, r10, lr}
	b	memcpy
	.p2align	2
@ BB#25:
.LCPI0_0:
	.long	mfcc_context-(.LPC0_2+4)
.LCPI0_1:
	.long	g_0-(.LPC0_1+4)
.LCPI0_2:
	.long	g_1-(.LPC0_0+4)
.LCPI0_3:
	.long	g_1-(.LPC0_5+4)
.LCPI0_4:
	.long	c_0-(.LPC0_4+4)
.LCPI0_5:
	.long	g_2-(.LPC0_3+4)
.LCPI0_6:
	.long	g_2-(.LPC0_6+4)
.LCPI0_7:
	.long	twiddles_128-(.LPC0_7+4)
.LCPI0_8:
	.long	g_3-(.LPC0_8+4)
.LCPI0_9:
	.long	filterEnd_Node_1111-(.LPC0_9+4)
.LCPI0_10:
	.long	0                       @ float 0
.LCPI0_11:
	.long	filterCenter_Node_1111-(.LPC0_10+4)
.LCPI0_12:
	.long	filterStart_Node_1111-(.LPC0_11+4)
.LCPI0_13:
	.long	g_3-(.LPC0_12+4)
.LCPI0_14:
	.long	g_3-(.LPC0_13+4)
.LCPI0_15:
	.long	g_4-(.LPC0_14+4)
.LCPI0_16:
	.long	g_4-(.LPC0_17+4)
.LCPI0_17:
	.long	c_1-(.LPC0_16+4)
.LCPI0_18:
	.long	g_5-(.LPC0_15+4)
.LCPI0_19:
	.long	g_5-(.LPC0_19+4)
.LCPI0_20:
	.long	g_6-(.LPC0_18+4)
.LCPI0_21:
	.long	g_6-(.LPC0_20+4)
.Lfunc_end0:
	.size	mfcc_Filter, .Lfunc_end0-mfcc_Filter
	.cantunwind
	.fnend

	.p2align	2
	.type	FFTC_float_128,%function
	.code	16                      @ @FFTC_float_128
	.thumb_func
FFTC_float_128:
	.fnstart
@ BB#0:                                 @ %entry
	.save	{r4, r5, r6, lr}
	push	{r4, r5, r6, lr}
	mov	r5, r1
	mov	r4, r0
	movs	r0, #0
	movs	r1, #0
.LBB1_1:                                @ %loop.body
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r2, r4, r0, lsl #3
	mov	r3, r2
	ldr	r6, [r3, #8]!
	ldr	r3, [r3, #4]
	str.w	r6, [r5, r1, lsl #3]
	add.w	r6, r5, r1, lsl #3
	str	r3, [r6, #4]
	ldr.w	r3, [r4, r0, lsl #3]
	ldr	r2, [r2, #4]
	adds	r0, #2
	str.w	r3, [r4, r1, lsl #3]
	add.w	r3, r4, r1, lsl #3
	adds	r1, #1
	str	r2, [r3, #4]
	cmp	r1, #64
	blt	.LBB1_1
@ BB#2:                                 @ %loop.body3.preheader
	movs	r0, #0
.LBB1_3:                                @ %loop.body3
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r1, r5, r0, lsl #3
	ldr.w	r2, [r5, r0, lsl #3]
	add.w	r3, r4, r0, lsl #3
	adds	r0, #1
	ldr	r1, [r1, #4]
	cmp	r0, #64
	str.w	r2, [r3, #512]
	str.w	r1, [r3, #516]
	blt	.LBB1_3
@ BB#4:                                 @ %loop.after5
	mov	r0, r4
	mov	r1, r5
	bl	FFTC_float_64
	add.w	r6, r4, #512
	mov	r1, r5
	mov	r0, r6
	bl	FFTC_float_64
	ldr.w	r12, .LCPI1_0
	movs	r0, #0
.LPC1_0:
	add	r12, pc
.LBB1_5:                                @ %loop.body8
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r3, r12, r0, lsl #3
	ldr.w	r2, [r6, r0, lsl #3]
	ldr.w	r1, [r4, r0, lsl #3]
	vldr	s0, [r3]
	vldr	s2, [r3, #4]
	add.w	r3, r6, r0, lsl #3
	ldr	r5, [r3, #4]
	vmov	s4, r2
	add.w	r2, r4, r0, lsl #3
	vmov	s10, r1
	vmul.f32	s8, s0, s4
	vmov	s6, r5
	ldr	r5, [r2, #4]
	vmul.f32	s0, s0, s6
	vmls.f32	s8, s2, s6
	vmla.f32	s0, s2, s4
	vmov	s12, r5
	vadd.f32	s6, s10, s8
	vmov	r1, s6
	vadd.f32	s2, s12, s0
	vsub.f32	s0, s12, s0
	str.w	r1, [r4, r0, lsl #3]
	vmov	r1, s2
	vsub.f32	s2, s10, s8
	str	r1, [r2, #4]
	vmov	r1, s2
	str.w	r1, [r6, r0, lsl #3]
	adds	r0, #1
	vmov	r1, s0
	str	r1, [r3, #4]
	cmp	r0, #64
	blt	.LBB1_5
@ BB#6:                                 @ %loop.after10
	pop	{r4, r5, r6, pc}
	.p2align	2
@ BB#7:
.LCPI1_0:
	.long	twiddles_64-(.LPC1_0+4)
.Lfunc_end1:
	.size	FFTC_float_128, .Lfunc_end1-FFTC_float_128
	.cantunwind
	.fnend

	.p2align	2
	.type	FFTC_float_64,%function
	.code	16                      @ @FFTC_float_64
	.thumb_func
FFTC_float_64:
	.fnstart
@ BB#0:                                 @ %entry
	.save	{r4, r5, r6, lr}
	push	{r4, r5, r6, lr}
	mov	r5, r1
	mov	r4, r0
	movs	r0, #0
	movs	r1, #0
.LBB2_1:                                @ %loop.body
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r2, r4, r0, lsl #3
	mov	r3, r2
	ldr	r6, [r3, #8]!
	ldr	r3, [r3, #4]
	str.w	r6, [r5, r1, lsl #3]
	add.w	r6, r5, r1, lsl #3
	str	r3, [r6, #4]
	ldr.w	r3, [r4, r0, lsl #3]
	ldr	r2, [r2, #4]
	adds	r0, #2
	str.w	r3, [r4, r1, lsl #3]
	add.w	r3, r4, r1, lsl #3
	adds	r1, #1
	str	r2, [r3, #4]
	cmp	r1, #32
	blt	.LBB2_1
@ BB#2:                                 @ %loop.body3.preheader
	movs	r0, #0
.LBB2_3:                                @ %loop.body3
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r1, r5, r0, lsl #3
	ldr.w	r2, [r5, r0, lsl #3]
	add.w	r3, r4, r0, lsl #3
	adds	r0, #1
	ldr	r1, [r1, #4]
	cmp	r0, #32
	str.w	r2, [r3, #256]
	str.w	r1, [r3, #260]
	blt	.LBB2_3
@ BB#4:                                 @ %loop.after5
	mov	r0, r4
	mov	r1, r5
	bl	FFTC_float_32
	add.w	r6, r4, #256
	mov	r1, r5
	mov	r0, r6
	bl	FFTC_float_32
	ldr.w	r12, .LCPI2_0
	movs	r0, #0
.LPC2_0:
	add	r12, pc
.LBB2_5:                                @ %loop.body8
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r3, r12, r0, lsl #3
	ldr.w	r2, [r6, r0, lsl #3]
	ldr.w	r1, [r4, r0, lsl #3]
	vldr	s0, [r3]
	vldr	s2, [r3, #4]
	add.w	r3, r6, r0, lsl #3
	ldr	r5, [r3, #4]
	vmov	s4, r2
	add.w	r2, r4, r0, lsl #3
	vmov	s10, r1
	vmul.f32	s8, s0, s4
	vmov	s6, r5
	ldr	r5, [r2, #4]
	vmul.f32	s0, s0, s6
	vmls.f32	s8, s2, s6
	vmla.f32	s0, s2, s4
	vmov	s12, r5
	vadd.f32	s6, s10, s8
	vmov	r1, s6
	vadd.f32	s2, s12, s0
	vsub.f32	s0, s12, s0
	str.w	r1, [r4, r0, lsl #3]
	vmov	r1, s2
	vsub.f32	s2, s10, s8
	str	r1, [r2, #4]
	vmov	r1, s2
	str.w	r1, [r6, r0, lsl #3]
	adds	r0, #1
	vmov	r1, s0
	str	r1, [r3, #4]
	cmp	r0, #32
	blt	.LBB2_5
@ BB#6:                                 @ %loop.after10
	pop	{r4, r5, r6, pc}
	.p2align	2
@ BB#7:
.LCPI2_0:
	.long	twiddles_32-(.LPC2_0+4)
.Lfunc_end2:
	.size	FFTC_float_64, .Lfunc_end2-FFTC_float_64
	.cantunwind
	.fnend

	.p2align	2
	.type	FFTC_float_32,%function
	.code	16                      @ @FFTC_float_32
	.thumb_func
FFTC_float_32:
	.fnstart
@ BB#0:                                 @ %entry
	.save	{r4, r5, r6, lr}
	push	{r4, r5, r6, lr}
	mov	r5, r1
	mov	r4, r0
	movs	r0, #0
	movs	r1, #0
.LBB3_1:                                @ %loop.body
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r2, r4, r0, lsl #3
	mov	r3, r2
	ldr	r6, [r3, #8]!
	ldr	r3, [r3, #4]
	str.w	r6, [r5, r1, lsl #3]
	add.w	r6, r5, r1, lsl #3
	str	r3, [r6, #4]
	ldr.w	r3, [r4, r0, lsl #3]
	ldr	r2, [r2, #4]
	adds	r0, #2
	str.w	r3, [r4, r1, lsl #3]
	add.w	r3, r4, r1, lsl #3
	adds	r1, #1
	str	r2, [r3, #4]
	cmp	r1, #16
	blt	.LBB3_1
@ BB#2:                                 @ %loop.body3.preheader
	movs	r0, #0
.LBB3_3:                                @ %loop.body3
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r1, r5, r0, lsl #3
	ldr.w	r2, [r5, r0, lsl #3]
	add.w	r3, r4, r0, lsl #3
	adds	r0, #1
	ldr	r1, [r1, #4]
	cmp	r0, #16
	str	r2, [r3, #128]!
	str	r1, [r3, #4]
	blt	.LBB3_3
@ BB#4:                                 @ %loop.after5
	mov	r0, r4
	mov	r1, r5
	bl	FFTC_float_16
	add.w	r6, r4, #128
	mov	r1, r5
	mov	r0, r6
	bl	FFTC_float_16
	ldr.w	r12, .LCPI3_0
	movs	r0, #0
.LPC3_0:
	add	r12, pc
.LBB3_5:                                @ %loop.body8
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r3, r12, r0, lsl #3
	ldr.w	r2, [r6, r0, lsl #3]
	ldr.w	r1, [r4, r0, lsl #3]
	vldr	s0, [r3]
	vldr	s2, [r3, #4]
	add.w	r3, r6, r0, lsl #3
	ldr	r5, [r3, #4]
	vmov	s4, r2
	add.w	r2, r4, r0, lsl #3
	vmov	s10, r1
	vmul.f32	s8, s0, s4
	vmov	s6, r5
	ldr	r5, [r2, #4]
	vmul.f32	s0, s0, s6
	vmls.f32	s8, s2, s6
	vmla.f32	s0, s2, s4
	vmov	s12, r5
	vadd.f32	s6, s10, s8
	vmov	r1, s6
	vadd.f32	s2, s12, s0
	vsub.f32	s0, s12, s0
	str.w	r1, [r4, r0, lsl #3]
	vmov	r1, s2
	vsub.f32	s2, s10, s8
	str	r1, [r2, #4]
	vmov	r1, s2
	str.w	r1, [r6, r0, lsl #3]
	adds	r0, #1
	vmov	r1, s0
	str	r1, [r3, #4]
	cmp	r0, #16
	blt	.LBB3_5
@ BB#6:                                 @ %loop.after10
	pop	{r4, r5, r6, pc}
	.p2align	2
@ BB#7:
.LCPI3_0:
	.long	twiddles_16-(.LPC3_0+4)
.Lfunc_end3:
	.size	FFTC_float_32, .Lfunc_end3-FFTC_float_32
	.cantunwind
	.fnend

	.p2align	2
	.type	FFTC_float_16,%function
	.code	16                      @ @FFTC_float_16
	.thumb_func
FFTC_float_16:
	.fnstart
@ BB#0:                                 @ %entry
	.save	{r4, r5, r6, lr}
	push	{r4, r5, r6, lr}
	mov	r4, r0
	mov	r6, r1
	ldr	r0, [r4, #8]
	ldr	r1, [r4, #12]
	mov	r5, r4
	str	r0, [r6]
	str	r1, [r6, #4]
	ldr	r0, [r4, #24]
	ldr	r1, [r4, #28]
	str	r0, [r6, #8]
	str	r1, [r6, #12]
	ldr	r0, [r4, #16]
	ldr	r1, [r4, #20]
	str	r0, [r4, #8]
	str	r1, [r4, #12]
	ldr	r0, [r4, #40]
	ldr	r1, [r4, #44]
	str	r0, [r6, #16]
	str	r1, [r6, #20]
	ldr	r0, [r4, #32]
	ldr	r1, [r4, #36]
	str	r0, [r4, #16]
	str	r1, [r4, #20]
	ldr	r0, [r4, #56]
	ldr	r1, [r4, #60]
	str	r0, [r6, #24]
	str	r1, [r6, #28]
	ldr	r0, [r4, #48]
	ldr	r1, [r4, #52]
	str	r0, [r4, #24]
	str	r1, [r4, #28]
	ldr	r0, [r4, #72]
	ldr	r1, [r4, #76]
	str	r0, [r6, #32]
	str	r1, [r6, #36]
	ldr	r0, [r4, #68]
	ldr	r1, [r5, #64]!
	str	r1, [r4, #32]
	str	r0, [r4, #36]
	ldr	r0, [r4, #88]
	ldr	r1, [r4, #92]
	str	r0, [r6, #40]
	str	r1, [r6, #44]
	ldr	r0, [r4, #80]
	ldr	r1, [r4, #84]
	str	r0, [r4, #40]
	str	r1, [r4, #44]
	ldr	r0, [r4, #104]
	ldr	r1, [r4, #108]
	str	r0, [r6, #48]
	str	r1, [r6, #52]
	ldr	r0, [r4, #96]
	ldr	r1, [r4, #100]
	str	r0, [r4, #48]
	str	r1, [r4, #52]
	ldr	r0, [r4, #120]
	ldr	r1, [r4, #124]
	str	r0, [r6, #56]
	str	r1, [r6, #60]
	ldr	r0, [r4, #112]
	ldr	r1, [r4, #116]
	str	r0, [r4, #56]
	str	r1, [r4, #60]
	ldr	r0, [r6]
	ldr	r1, [r6, #4]
	str	r0, [r5]
	str	r1, [r4, #68]
	ldr	r0, [r6, #8]
	ldr	r1, [r6, #12]
	str	r0, [r4, #72]
	str	r1, [r4, #76]
	ldr	r0, [r6, #16]
	ldr	r1, [r6, #20]
	str	r0, [r4, #80]
	str	r1, [r4, #84]
	ldr	r0, [r6, #24]
	ldr	r1, [r6, #28]
	str	r0, [r4, #88]
	str	r1, [r4, #92]
	ldr	r0, [r6, #32]
	ldr	r1, [r6, #36]
	str	r0, [r4, #96]
	str	r1, [r4, #100]
	ldr	r0, [r6, #40]
	ldr	r1, [r6, #44]
	str	r0, [r4, #104]
	str	r1, [r4, #108]
	ldr	r0, [r6, #48]
	ldr	r1, [r6, #52]
	str	r0, [r4, #112]
	str	r1, [r4, #116]
	ldr	r0, [r6, #56]
	ldr	r1, [r6, #60]
	str	r0, [r4, #120]
	str	r1, [r4, #124]
	mov	r0, r4
	mov	r1, r6
	bl	FFTC_float_8
	mov	r0, r5
	mov	r1, r6
	bl	FFTC_float_8
	ldr.w	r12, .LCPI4_0
	movs	r0, #0
.LPC4_0:
	add	r12, pc
.LBB4_1:                                @ %loop.body8
                                        @ =>This Inner Loop Header: Depth=1
	add.w	r3, r12, r0, lsl #3
	ldr.w	r2, [r5, r0, lsl #3]
	ldr.w	r1, [r4, r0, lsl #3]
	vldr	s0, [r3]
	vldr	s2, [r3, #4]
	add.w	r3, r5, r0, lsl #3
	ldr	r6, [r3, #4]
	vmov	s4, r2
	add.w	r2, r4, r0, lsl #3
	vmov	s10, r1
	vmul.f32	s8, s0, s4
	vmov	s6, r6
	ldr	r6, [r2, #4]
	vmul.f32	s0, s0, s6
	vmls.f32	s8, s2, s6
	vmla.f32	s0, s2, s4
	vmov	s12, r6
	vadd.f32	s6, s10, s8
	vmov	r1, s6
	vadd.f32	s2, s12, s0
	vsub.f32	s0, s12, s0
	str.w	r1, [r4, r0, lsl #3]
	vmov	r1, s2
	vsub.f32	s2, s10, s8
	str	r1, [r2, #4]
	vmov	r1, s2
	str.w	r1, [r5, r0, lsl #3]
	adds	r0, #1
	vmov	r1, s0
	str	r1, [r3, #4]
	cmp	r0, #8
	blt	.LBB4_1
@ BB#2:                                 @ %loop.after10
	pop	{r4, r5, r6, pc}
	.p2align	2
@ BB#3:
.LCPI4_0:
	.long	twiddles_8-(.LPC4_0+4)
.Lfunc_end4:
	.size	FFTC_float_16, .Lfunc_end4-FFTC_float_16
	.cantunwind
	.fnend

	.p2align	2
	.type	FFTC_float_8,%function
	.code	16                      @ @FFTC_float_8
	.thumb_func
FFTC_float_8:
	.fnstart
@ BB#0:                                 @ %entry
	.save	{r4, r5, r6, r7, lr}
	push	{r4, r5, r6, r7, lr}
	.pad	#4
	sub	sp, #4
	.vsave	{d8, d9, d10, d11, d12, d13, d14, d15}
	vpush	{d8, d9, d10, d11, d12, d13, d14, d15}
	ldr	r2, [r0, #8]
	ldr	r3, [r0, #12]
	vldr	s9, .LCPI5_0
	str	r2, [r1]
	str	r3, [r1, #4]
	ldr	r2, [r0, #24]
	ldr	r3, [r0, #28]
	str	r2, [r1, #8]
	str	r3, [r1, #12]
	ldr	r2, [r0, #16]
	ldr	r3, [r0, #20]
	str	r2, [r0, #8]
	str	r3, [r0, #12]
	ldr	r2, [r0, #40]
	ldr	r3, [r0, #44]
	str	r2, [r1, #16]
	str	r3, [r1, #20]
	ldr	r2, [r0, #32]
	ldr	r3, [r0, #36]
	str	r2, [r0, #16]
	str	r3, [r0, #20]
	ldr	r2, [r0, #56]
	ldr	r3, [r0, #60]
	str	r2, [r1, #24]
	str	r3, [r1, #28]
	ldr.w	lr, [r0, #48]
	ldr.w	r12, [r0, #52]
	str.w	lr, [r0, #24]
	str.w	r12, [r0, #28]
	vmov	s22, lr
	ldr	r2, [r1]
	ldr	r3, [r1, #4]
	str	r2, [r0, #32]
	str	r3, [r0, #36]
	vmov	s5, r3
	vmov	s15, r2
	ldr	r4, [r1, #8]
	ldr	r5, [r1, #12]
	str	r4, [r0, #40]
	str	r5, [r0, #44]
	vmov	s1, r5
	vmov	s11, r4
	ldr	r5, [r1, #16]
	ldr	r6, [r1, #20]
	str	r5, [r0, #48]
	str	r6, [r0, #52]
	vmov	s16, r5
	vmov	s7, r6
	ldr	r7, [r1, #24]
	ldr	r1, [r1, #28]
	ldr	r3, [r0, #8]
	ldr	r5, [r0, #20]
	vsub.f32	s2, s5, s7
	vsub.f32	s4, s15, s16
	ldr	r4, [r0, #12]
	ldr	r2, [r0]
	vadd.f32	s5, s5, s7
	vmov	s3, r1
	ldr	r1, [r0, #4]
	vmov	s13, r7
	vmov	s24, r3
	vmov	s18, r5
	ldr	r3, [r0, #16]
	vmov	s19, r4
	vmov	s23, r2
	vsub.f32	s0, s1, s3
	vsub.f32	s12, s11, s13
	vadd.f32	s1, s1, s3
	vadd.f32	s7, s11, s13
	vadd.f32	s3, s15, s16
	vsub.f32	s8, s9, s0
	vldr	s0, .LCPI5_1
	vadd.f32	s6, s2, s12
	vadd.f32	s13, s5, s1
	vadd.f32	s11, s3, s7
	vsub.f32	s1, s5, s1
	vsub.f32	s3, s3, s7
	vsub.f32	s2, s2, s12
	vadd.f32	s10, s4, s8
	vmov.f32	s16, s13
	vsub.f32	s4, s4, s8
	vmov	s20, r1
	vmla.f32	s16, s11, s9
	vmov	s21, r3
	vmls.f32	s11, s13, s9
	vmul.f32	s14, s6, s0
	vmul.f32	s26, s10, s0
	vsub.f32	s6, s20, s18
	vsub.f32	s10, s24, s22
	vadd.f32	s18, s20, s18
	vsub.f32	s25, s23, s21
	vadd.f32	s13, s22, s24
	vmul.f32	s2, s2, s0
	vadd.f32	s28, s10, s6
	vadd.f32	s30, s14, s26
	vsub.f32	s26, s26, s14
	vsub.f32	s6, s6, s10
	vadd.f32	s17, s30, s28
	vsub.f32	s5, s28, s30
	vmov	r1, s17
	vmov	s17, r12
	vadd.f32	s20, s17, s19
	vsub.f32	s14, s19, s17
	vadd.f32	s15, s20, s18
	vsub.f32	s14, s9, s14
	vadd.f32	s9, s23, s21
	vsub.f32	s17, s15, s16
	vadd.f32	s15, s16, s15
	vadd.f32	s27, s25, s14
	vadd.f32	s22, s13, s9
	vsub.f32	s7, s9, s13
	vmov.f32	s9, s1
	vmov	r6, s15
	vldr	s15, .LCPI5_2
	vsub.f32	s24, s22, s11
	vadd.f32	s29, s26, s27
	vadd.f32	s11, s11, s22
	vmov	r3, s17
	vmov	r5, s11
	vmov	r2, s29
	vmov	r7, s24
	vsub.f32	s11, s27, s26
	str	r5, [r0]
	str	r6, [r0, #4]
	str	r7, [r0, #32]
	str	r3, [r0, #36]
	str	r2, [r0, #8]
	str	r1, [r0, #12]
	vmov	r1, s11
	vsub.f32	s11, s18, s20
	str	r1, [r0, #40]
	vmov	r1, s5
	vnmls.f32	s9, s3, s15
	vmla.f32	s3, s1, s15
	str	r1, [r0, #44]
	vadd.f32	s5, s9, s7
	vadd.f32	s1, s3, s11
	vsub.f32	s12, s7, s9
	vsub.f32	s8, s11, s3
	vmov	r1, s5
	str	r1, [r0, #16]
	vmov	r1, s1
	vldr	s1, .LCPI5_3
	str	r1, [r0, #20]
	vmov	r1, s12
	vsub.f32	s12, s25, s14
	vmov.f32	s14, s2
	vnmls.f32	s2, s4, s0
	str	r1, [r0, #48]
	vmov	r1, s8
	vadd.f32	s0, s2, s6
	str	r1, [r0, #52]
	vnmls.f32	s14, s4, s1
	vadd.f32	s8, s14, s12
	vmov	r1, s8
	str	r1, [r0, #24]
	vmov	r1, s0
	vsub.f32	s0, s12, s14
	str	r1, [r0, #28]
	vmov	r1, s0
	vsub.f32	s0, s6, s2
	str	r1, [r0, #56]
	vmov	r1, s0
	str	r1, [r0, #60]
	vpop	{d8, d9, d10, d11, d12, d13, d14, d15}
	add	sp, #4
	pop	{r4, r5, r6, r7, pc}
	.p2align	2
@ BB#1:
.LCPI5_0:
	.long	0                       @ float 0
.LCPI5_1:
	.long	1060439283              @ float 0.707106769
.LCPI5_2:
	.long	3007036718              @ float -4.37113883E-8
.LCPI5_3:
	.long	3207922931              @ float -0.707106769
.Lfunc_end5:
	.size	FFTC_float_8, .Lfunc_end5-FFTC_float_8
	.cantunwind
	.fnend

	.globl	mfcc_Reset
	.p2align	1
	.type	mfcc_Reset,%function
	.code	16                      @ @mfcc_Reset
	.thumb_func
mfcc_Reset:
	.fnstart
@ BB#0:                                 @ %entry
	bx	lr
.Lfunc_end6:
	.size	mfcc_Reset, .Lfunc_end6-mfcc_Reset
	.cantunwind
	.fnend

	.globl	mfcc_GetInputSize
	.p2align	1
	.type	mfcc_GetInputSize,%function
	.code	16                      @ @mfcc_GetInputSize
	.thumb_func
mfcc_GetInputSize:
	.fnstart
@ BB#0:                                 @ %entry
	mov.w	r0, #256
	bx	lr
.Lfunc_end7:
	.size	mfcc_GetInputSize, .Lfunc_end7-mfcc_GetInputSize
	.cantunwind
	.fnend

	.globl	mfcc_GetOutputSize
	.p2align	1
	.type	mfcc_GetOutputSize,%function
	.code	16                      @ @mfcc_GetOutputSize
	.thumb_func
mfcc_GetOutputSize:
	.fnstart
@ BB#0:                                 @ %entry
	movs	r0, #40
	bx	lr
.Lfunc_end8:
	.size	mfcc_GetOutputSize, .Lfunc_end8-mfcc_GetOutputSize
	.cantunwind
	.fnend

	.globl	mfcc_GetNumNodes
	.p2align	1
	.type	mfcc_GetNumNodes,%function
	.code	16                      @ @mfcc_GetNumNodes
	.thumb_func
mfcc_GetNumNodes:
	.fnstart
@ BB#0:                                 @ %entry
	movs	r0, #10
	bx	lr
.Lfunc_end9:
	.size	mfcc_GetNumNodes, .Lfunc_end9-mfcc_GetNumNodes
	.cantunwind
	.fnend

	.globl	mfcc_GetInputShape
	.p2align	1
	.type	mfcc_GetInputShape,%function
	.code	16                      @ @mfcc_GetInputShape
	.thumb_func
mfcc_GetInputShape:
	.fnstart
@ BB#0:                                 @ %entry
	cmp	r0, #0
	itttt	ne
	movne	r0, #0
	strdne	r0, r0, [r1]
	strne	r0, [r1, #8]
	bxne	lr
	mov.w	r0, #256
	movs	r2, #1
	strd	r0, r2, [r1]
	str	r2, [r1, #8]
	bx	lr
.Lfunc_end10:
	.size	mfcc_GetInputShape, .Lfunc_end10-mfcc_GetInputShape
	.cantunwind
	.fnend

	.globl	mfcc_GetOutputShape
	.p2align	1
	.type	mfcc_GetOutputShape,%function
	.code	16                      @ @mfcc_GetOutputShape
	.thumb_func
mfcc_GetOutputShape:
	.fnstart
@ BB#0:                                 @ %entry
	cmp	r0, #0
	itttt	ne
	movne	r0, #0
	strdne	r0, r0, [r1]
	strne	r0, [r1, #8]
	bxne	lr
	movs	r0, #40
	movs	r2, #1
	strd	r0, r2, [r1]
	str	r2, [r1, #8]
	bx	lr
.Lfunc_end11:
	.size	mfcc_GetOutputShape, .Lfunc_end11-mfcc_GetOutputShape
	.cantunwind
	.fnend

	.type	mfcc_context,%object    @ @mfcc_context
	.local	mfcc_context
	.comm	mfcc_context,4,4
	.type	g_0,%object             @ @g_0
	.local	g_0
	.comm	g_0,1024,16
	.type	g_1,%object             @ @g_1
	.local	g_1
	.comm	g_1,1024,16
	.type	c_0,%object             @ @c_0
	.section	.rodata,"a",%progbits
	.p2align	4
c_0:
	.long	1034147594              @ float 0.0799999982
	.long	1034166335              @ float 0.0801396295
	.long	1034222547              @ float 0.0805584415
	.long	1034316196              @ float 0.081256181
	.long	1034447224              @ float 0.0822324156
	.long	1034615553              @ float 0.0834865644
	.long	1034821080              @ float 0.0850178599
	.long	1035063680              @ float 0.0868253708
	.long	1035343207              @ float 0.0889080092
	.long	1035659489              @ float 0.0912644937
	.long	1036012336              @ float 0.0938934088
	.long	1036401533              @ float 0.0967931523
	.long	1036826844              @ float 0.0999619662
	.long	1037288011              @ float 0.103397928
	.long	1037784753              @ float 0.107098944
	.long	1038316769              @ float 0.111062773
	.long	1038883737              @ float 0.115287013
	.long	1039485311              @ float 0.119769089
	.long	1040121127              @ float 0.124506287
	.long	1040489095              @ float 0.129495725
	.long	1040840656              @ float 0.134734392
	.long	1041208727              @ float 0.140219077
	.long	1041593087              @ float 0.145946488
	.long	1041993500              @ float 0.151913106
	.long	1042409725              @ float 0.158115342
	.long	1042841509              @ float 0.164549425
	.long	1043288589              @ float 0.171211436
	.long	1043750693              @ float 0.178097323
	.long	1044227543              @ float 0.185202941
	.long	1044718847              @ float 0.192523941
	.long	1045224308              @ float 0.200055897
	.long	1045743619              @ float 0.207794234
	.long	1046276464              @ float 0.215734243
	.long	1046822521              @ float 0.223871127
	.long	1047381457              @ float 0.232199922
	.long	1047952933              @ float 0.240715578
	.long	1048536603              @ float 0.249412939
	.long	1048854056              @ float 0.258286715
	.long	1049157549              @ float 0.267331511
	.long	1049466596              @ float 0.276541829
	.long	1049781011              @ float 0.285912126
	.long	1050100601              @ float 0.295436651
	.long	1050425173              @ float 0.30510965
	.long	1050754530              @ float 0.314925253
	.long	1051088472              @ float 0.324877501
	.long	1051426796              @ float 0.334960341
	.long	1051769298              @ float 0.345167696
	.long	1052115768              @ float 0.355493307
	.long	1052465996              @ float 0.365930915
	.long	1052819771              @ float 0.376474231
	.long	1053176876              @ float 0.38711679
	.long	1053537096              @ float 0.397852182
	.long	1053900212              @ float 0.408673882
	.long	1054266002              @ float 0.419575274
	.long	1054634246              @ float 0.4305498
	.long	1055004720              @ float 0.441590786
	.long	1055377198              @ float 0.452691495
	.long	1055751455              @ float 0.463845223
	.long	1056127263              @ float 0.475045174
	.long	1056504394              @ float 0.486284554
	.long	1056882620              @ float 0.497556567
	.long	1057113159              @ float 0.50885433
	.long	1057303021              @ float 0.520170987
	.long	1057493085              @ float 0.531499684
	.long	1057683236              @ float 0.542833567
	.long	1057873358              @ float 0.554165721
	.long	1058063336              @ float 0.565489292
	.long	1058253054              @ float 0.576797366
	.long	1058442397              @ float 0.588083088
	.long	1058631251              @ float 0.599339664
	.long	1058819500              @ float 0.610560179
	.long	1059007030              @ float 0.621737838
	.long	1059193728              @ float 0.632865906
	.long	1059379480              @ float 0.643937587
	.long	1059564173              @ float 0.654946148
	.long	1059747696              @ float 0.665884972
	.long	1059929936              @ float 0.676747322
	.long	1060110784              @ float 0.687526702
	.long	1060290129              @ float 0.698216497
	.long	1060467863              @ float 0.708810269
	.long	1060643877              @ float 0.719301521
	.long	1060818065              @ float 0.729683935
	.long	1060990320              @ float 0.739951133
	.long	1061160540              @ float 0.750097036
	.long	1061328619              @ float 0.760115325
	.long	1061494456              @ float 0.76999998
	.long	1061657951              @ float 0.779745042
	.long	1061819004              @ float 0.789344549
	.long	1061977517              @ float 0.79879266
	.long	1062133394              @ float 0.808083653
	.long	1062286541              @ float 0.817211925
	.long	1062436864              @ float 0.826171875
	.long	1062584273              @ float 0.834958136
	.long	1062728677              @ float 0.843565285
	.long	1062869989              @ float 0.851988136
	.long	1063008124              @ float 0.860221624
	.long	1063142997              @ float 0.868260681
	.long	1063274526              @ float 0.87610042
	.long	1063402633              @ float 0.883736193
	.long	1063527238              @ float 0.891163229
	.long	1063648266              @ float 0.89837706
	.long	1063765644              @ float 0.905373335
	.long	1063879301              @ float 0.912147819
	.long	1063989167              @ float 0.918696343
	.long	1064095176              @ float 0.925014972
	.long	1064197264              @ float 0.931099891
	.long	1064295368              @ float 0.936947345
	.long	1064389429              @ float 0.942553818
	.long	1064479390              @ float 0.947915911
	.long	1064565196              @ float 0.953030347
	.long	1064646795              @ float 0.957894027
	.long	1064724138              @ float 0.962504029
	.long	1064797177              @ float 0.966857492
	.long	1064865869              @ float 0.970951855
	.long	1064930171              @ float 0.974784553
	.long	1064990045              @ float 0.978353321
	.long	1065045454              @ float 0.981655955
	.long	1065096365              @ float 0.984690487
	.long	1065142746              @ float 0.98745501
	.long	1065184570              @ float 0.989947915
	.long	1065221811              @ float 0.992167651
	.long	1065254446              @ float 0.994112849
	.long	1065282456              @ float 0.995782375
	.long	1065305824              @ float 0.997175216
	.long	1065324535              @ float 0.998290479
	.long	1065338578              @ float 0.999127507
	.long	1065347945              @ float 0.999685823
	.long	1065352630              @ float 0.999965071
	.long	1065352630              @ float 0.999965071
	.long	1065347945              @ float 0.999685823
	.long	1065338578              @ float 0.999127507
	.long	1065324535              @ float 0.998290479
	.long	1065305824              @ float 0.997175216
	.long	1065282456              @ float 0.995782375
	.long	1065254446              @ float 0.994112849
	.long	1065221811              @ float 0.992167651
	.long	1065184570              @ float 0.989947915
	.long	1065142746              @ float 0.98745501
	.long	1065096365              @ float 0.984690487
	.long	1065045454              @ float 0.981655955
	.long	1064990045              @ float 0.978353321
	.long	1064930171              @ float 0.974784553
	.long	1064865869              @ float 0.970951855
	.long	1064797177              @ float 0.966857492
	.long	1064724138              @ float 0.962504029
	.long	1064646795              @ float 0.957894027
	.long	1064565196              @ float 0.953030347
	.long	1064479390              @ float 0.947915911
	.long	1064389429              @ float 0.942553818
	.long	1064295368              @ float 0.936947345
	.long	1064197264              @ float 0.931099891
	.long	1064095176              @ float 0.925014972
	.long	1063989167              @ float 0.918696343
	.long	1063879301              @ float 0.912147819
	.long	1063765644              @ float 0.905373335
	.long	1063648266              @ float 0.89837706
	.long	1063527238              @ float 0.891163229
	.long	1063402633              @ float 0.883736193
	.long	1063274526              @ float 0.87610042
	.long	1063142997              @ float 0.868260681
	.long	1063008124              @ float 0.860221624
	.long	1062869989              @ float 0.851988136
	.long	1062728677              @ float 0.843565285
	.long	1062584273              @ float 0.834958136
	.long	1062436864              @ float 0.826171875
	.long	1062286541              @ float 0.817211925
	.long	1062133394              @ float 0.808083653
	.long	1061977517              @ float 0.79879266
	.long	1061819004              @ float 0.789344549
	.long	1061657951              @ float 0.779745042
	.long	1061494456              @ float 0.76999998
	.long	1061328619              @ float 0.760115325
	.long	1061160540              @ float 0.750097036
	.long	1060990320              @ float 0.739951133
	.long	1060818065              @ float 0.729683935
	.long	1060643877              @ float 0.719301521
	.long	1060467863              @ float 0.708810269
	.long	1060290129              @ float 0.698216497
	.long	1060110784              @ float 0.687526702
	.long	1059929936              @ float 0.676747322
	.long	1059747696              @ float 0.665884972
	.long	1059564173              @ float 0.654946148
	.long	1059379480              @ float 0.643937587
	.long	1059193728              @ float 0.632865906
	.long	1059007030              @ float 0.621737838
	.long	1058819500              @ float 0.610560179
	.long	1058631251              @ float 0.599339664
	.long	1058442397              @ float 0.588083088
	.long	1058253054              @ float 0.576797366
	.long	1058063336              @ float 0.565489292
	.long	1057873358              @ float 0.554165721
	.long	1057683236              @ float 0.542833567
	.long	1057493085              @ float 0.531499684
	.long	1057303021              @ float 0.520170987
	.long	1057113159              @ float 0.50885433
	.long	1056882620              @ float 0.497556567
	.long	1056504394              @ float 0.486284554
	.long	1056127263              @ float 0.475045174
	.long	1055751455              @ float 0.463845223
	.long	1055377198              @ float 0.452691495
	.long	1055004720              @ float 0.441590786
	.long	1054634246              @ float 0.4305498
	.long	1054266002              @ float 0.419575274
	.long	1053900212              @ float 0.408673882
	.long	1053537096              @ float 0.397852182
	.long	1053176876              @ float 0.38711679
	.long	1052819771              @ float 0.376474231
	.long	1052465996              @ float 0.365930915
	.long	1052115768              @ float 0.355493307
	.long	1051769298              @ float 0.345167696
	.long	1051426796              @ float 0.334960341
	.long	1051088472              @ float 0.324877501
	.long	1050754530              @ float 0.314925253
	.long	1050425173              @ float 0.30510965
	.long	1050100601              @ float 0.295436651
	.long	1049781011              @ float 0.285912126
	.long	1049466596              @ float 0.276541829
	.long	1049157549              @ float 0.267331511
	.long	1048854056              @ float 0.258286715
	.long	1048536603              @ float 0.249412939
	.long	1047952933              @ float 0.240715578
	.long	1047381457              @ float 0.232199922
	.long	1046822521              @ float 0.223871127
	.long	1046276464              @ float 0.215734243
	.long	1045743619              @ float 0.207794234
	.long	1045224308              @ float 0.200055897
	.long	1044718847              @ float 0.192523941
	.long	1044227543              @ float 0.185202941
	.long	1043750693              @ float 0.178097323
	.long	1043288589              @ float 0.171211436
	.long	1042841509              @ float 0.164549425
	.long	1042409725              @ float 0.158115342
	.long	1041993500              @ float 0.151913106
	.long	1041593087              @ float 0.145946488
	.long	1041208727              @ float 0.140219077
	.long	1040840656              @ float 0.134734392
	.long	1040489095              @ float 0.129495725
	.long	1040121127              @ float 0.124506287
	.long	1039485311              @ float 0.119769089
	.long	1038883737              @ float 0.115287013
	.long	1038316769              @ float 0.111062773
	.long	1037784753              @ float 0.107098944
	.long	1037288011              @ float 0.103397928
	.long	1036826844              @ float 0.0999619662
	.long	1036401533              @ float 0.0967931523
	.long	1036012336              @ float 0.0938934088
	.long	1035659489              @ float 0.0912644937
	.long	1035343207              @ float 0.0889080092
	.long	1035063680              @ float 0.0868253708
	.long	1034821080              @ float 0.0850178599
	.long	1034615553              @ float 0.0834865644
	.long	1034447224              @ float 0.0822324156
	.long	1034316196              @ float 0.081256181
	.long	1034222547              @ float 0.0805584415
	.long	1034166335              @ float 0.0801396295
	.long	1034147594              @ float 0.0799999982
	.size	c_0, 1024

	.type	g_2,%object             @ @g_2
	.local	g_2
	.comm	g_2,1024,16
	.type	twiddles_8,%object      @ @twiddles_8
	.p2align	4
twiddles_8:
	.long	1065353216              @ float 1
	.long	0                       @ float 0
	.long	1064076126              @ float 0.923879504
	.long	1053028118              @ float 0.382683456
	.long	1060439283              @ float 0.707106769
	.long	1060439283              @ float 0.707106769
	.long	1053028117              @ float 0.382683426
	.long	1064076126              @ float 0.923879504
	.long	3007036718              @ float -4.37113883E-8
	.long	1065353216              @ float 1
	.long	3200511768              @ float -0.382683516
	.long	1064076126              @ float 0.923879504
	.long	3207922931              @ float -0.707106769
	.long	1060439283              @ float 0.707106769
	.long	3211559776              @ float -0.923879623
	.long	1053028112              @ float 0.382683277
	.size	twiddles_8, 64

	.type	twiddles_16,%object     @ @twiddles_16
	.p2align	4
twiddles_16:
	.long	1065353216              @ float 1
	.long	0                       @ float 0
	.long	1065030846              @ float 0.98078525
	.long	1044891074              @ float 0.195090324
	.long	1064076126              @ float 0.923879504
	.long	1053028118              @ float 0.382683456
	.long	1062525745              @ float 0.831469595
	.long	1057896922              @ float 0.555570245
	.long	1060439283              @ float 0.707106769
	.long	1060439283              @ float 0.707106769
	.long	1057896921              @ float 0.555570185
	.long	1062525746              @ float 0.831469655
	.long	1053028117              @ float 0.382683426
	.long	1064076126              @ float 0.923879504
	.long	1044891068              @ float 0.195090234
	.long	1065030847              @ float 0.98078531
	.long	3007036718              @ float -4.37113883E-8
	.long	1065353216              @ float 1
	.long	3192374722              @ float -0.195090324
	.long	1065030846              @ float 0.98078525
	.long	3200511768              @ float -0.382683516
	.long	1064076126              @ float 0.923879504
	.long	3205380572              @ float -0.555570364
	.long	1062525744              @ float 0.831469535
	.long	3207922931              @ float -0.707106769
	.long	1060439283              @ float 0.707106769
	.long	3210009394              @ float -0.831469655
	.long	1057896921              @ float 0.555570185
	.long	3211559776              @ float -0.923879623
	.long	1053028112              @ float 0.382683277
	.long	3212514495              @ float -0.98078531
	.long	1044891073              @ float 0.195090309
	.size	twiddles_16, 128

	.type	twiddles_32,%object     @ @twiddles_32
	.p2align	4
twiddles_32:
	.long	1065353216              @ float 1
	.long	0                       @ float 0
	.long	1065272429              @ float 0.995184719
	.long	1036565814              @ float 0.0980171412
	.long	1065030846              @ float 0.98078525
	.long	1044891074              @ float 0.195090324
	.long	1064630795              @ float 0.956940352
	.long	1049927729              @ float 0.290284663
	.long	1064076126              @ float 0.923879504
	.long	1053028118              @ float 0.382683456
	.long	1063372183              @ float 0.881921231
	.long	1056004842              @ float 0.471396744
	.long	1062525745              @ float 0.831469595
	.long	1057896922              @ float 0.555570245
	.long	1061544963              @ float 0.773010432
	.long	1059219354              @ float 0.634393334
	.long	1060439283              @ float 0.707106769
	.long	1060439283              @ float 0.707106769
	.long	1059219353              @ float 0.634393274
	.long	1061544963              @ float 0.773010432
	.long	1057896921              @ float 0.555570185
	.long	1062525746              @ float 0.831469655
	.long	1056004839              @ float 0.471396655
	.long	1063372184              @ float 0.881921291
	.long	1053028117              @ float 0.382683426
	.long	1064076126              @ float 0.923879504
	.long	1049927728              @ float 0.290284634
	.long	1064630795              @ float 0.956940352
	.long	1044891068              @ float 0.195090234
	.long	1065030847              @ float 0.98078531
	.long	1036565813              @ float 0.0980171337
	.long	1065272429              @ float 0.995184719
	.long	3007036718              @ float -4.37113883E-8
	.long	1065353216              @ float 1
	.long	3184049473              @ float -0.0980172231
	.long	1065272429              @ float 0.995184719
	.long	3192374722              @ float -0.195090324
	.long	1065030846              @ float 0.98078525
	.long	3197411379              @ float -0.290284723
	.long	1064630794              @ float 0.956940293
	.long	3200511768              @ float -0.382683516
	.long	1064076126              @ float 0.923879504
	.long	3203488493              @ float -0.471396834
	.long	1063372183              @ float 0.881921231
	.long	3205380572              @ float -0.555570364
	.long	1062525744              @ float 0.831469535
	.long	3206703001              @ float -0.634393274
	.long	1061544964              @ float 0.773010492
	.long	3207922931              @ float -0.707106769
	.long	1060439283              @ float 0.707106769
	.long	3209028612              @ float -0.773010492
	.long	1059219353              @ float 0.634393274
	.long	3210009394              @ float -0.831469655
	.long	1057896921              @ float 0.555570185
	.long	3210855833              @ float -0.88192135
	.long	1056004838              @ float 0.471396625
	.long	3211559776              @ float -0.923879623
	.long	1053028112              @ float 0.382683277
	.long	3212114443              @ float -0.956940352
	.long	1049927731              @ float 0.290284723
	.long	3212514495              @ float -0.98078531
	.long	1044891073              @ float 0.195090309
	.long	3212756077              @ float -0.995184719
	.long	1036565808              @ float 0.0980170965
	.size	twiddles_32, 256

	.type	twiddles_64,%object     @ @twiddles_64
	.p2align	4
twiddles_64:
	.long	1065353216              @ float 1
	.long	0                       @ float 0
	.long	1065333007              @ float 0.998795449
	.long	1028193072              @ float 0.0490676761
	.long	1065272429              @ float 0.995184719
	.long	1036565814              @ float 0.0980171412
	.long	1065171628              @ float 0.989176511
	.long	1041645699              @ float 0.146730468
	.long	1065030846              @ float 0.98078525
	.long	1044891074              @ float 0.195090324
	.long	1064850424              @ float 0.970031261
	.long	1048104909              @ float 0.242980197
	.long	1064630795              @ float 0.956940352
	.long	1049927729              @ float 0.290284663
	.long	1064372488              @ float 0.941544055
	.long	1051491540              @ float 0.336889863
	.long	1064076126              @ float 0.923879504
	.long	1053028118              @ float 0.382683456
	.long	1063742424              @ float 0.903989315
	.long	1054533760              @ float 0.427555084
	.long	1063372183              @ float 0.881921231
	.long	1056004842              @ float 0.471396744
	.long	1062966298              @ float 0.8577286
	.long	1057201213              @ float 0.514102757
	.long	1062525745              @ float 0.831469595
	.long	1057896922              @ float 0.555570245
	.long	1062051586              @ float 0.803207516
	.long	1058570176              @ float 0.59569931
	.long	1061544963              @ float 0.773010432
	.long	1059219354              @ float 0.634393334
	.long	1061007097              @ float 0.74095112
	.long	1059842890              @ float 0.671558976
	.long	1060439283              @ float 0.707106769
	.long	1060439283              @ float 0.707106769
	.long	1059842889              @ float 0.671558916
	.long	1061007098              @ float 0.74095118
	.long	1059219353              @ float 0.634393274
	.long	1061544963              @ float 0.773010432
	.long	1058570176              @ float 0.59569931
	.long	1062051586              @ float 0.803207516
	.long	1057896921              @ float 0.555570185
	.long	1062525746              @ float 0.831469655
	.long	1057201212              @ float 0.514102697
	.long	1062966299              @ float 0.85772866
	.long	1056004839              @ float 0.471396655
	.long	1063372184              @ float 0.881921291
	.long	1054533761              @ float 0.427555114
	.long	1063742424              @ float 0.903989315
	.long	1053028117              @ float 0.382683426
	.long	1064076126              @ float 0.923879504
	.long	1051491539              @ float 0.336889833
	.long	1064372488              @ float 0.941544055
	.long	1049927728              @ float 0.290284634
	.long	1064630795              @ float 0.956940352
	.long	1048104904              @ float 0.242980123
	.long	1064850424              @ float 0.970031261
	.long	1044891068              @ float 0.195090234
	.long	1065030847              @ float 0.98078531
	.long	1041645701              @ float 0.146730497
	.long	1065171628              @ float 0.989176511
	.long	1036565813              @ float 0.0980171337
	.long	1065272429              @ float 0.995184719
	.long	1028193065              @ float 0.04906765
	.long	1065333007              @ float 0.998795449
	.long	3007036718              @ float -4.37113883E-8
	.long	1065353216              @ float 1
	.long	3175676737              @ float -0.0490677394
	.long	1065333007              @ float 0.998795449
	.long	3184049473              @ float -0.0980172231
	.long	1065272429              @ float 0.995184719
	.long	3189129354              @ float -0.146730572
	.long	1065171628              @ float 0.989176511
	.long	3192374722              @ float -0.195090324
	.long	1065030846              @ float 0.98078525
	.long	3195588557              @ float -0.242980197
	.long	1064850424              @ float 0.970031261
	.long	3197411379              @ float -0.290284723
	.long	1064630794              @ float 0.956940293
	.long	3198975190              @ float -0.336889923
	.long	1064372488              @ float 0.941544055
	.long	3200511768              @ float -0.382683516
	.long	1064076126              @ float 0.923879504
	.long	3202017408              @ float -0.427555084
	.long	1063742424              @ float 0.903989315
	.long	3203488493              @ float -0.471396834
	.long	1063372183              @ float 0.881921231
	.long	3204684861              @ float -0.514102757
	.long	1062966298              @ float 0.8577286
	.long	3205380572              @ float -0.555570364
	.long	1062525744              @ float 0.831469535
	.long	3206053825              @ float -0.59569937
	.long	1062051586              @ float 0.803207516
	.long	3206703001              @ float -0.634393274
	.long	1061544964              @ float 0.773010492
	.long	3207326539              @ float -0.671559035
	.long	1061007096              @ float 0.740951061
	.long	3207922931              @ float -0.707106769
	.long	1060439283              @ float 0.707106769
	.long	3208490747              @ float -0.74095124
	.long	1059842888              @ float 0.671558856
	.long	3209028612              @ float -0.773010492
	.long	1059219353              @ float 0.634393274
	.long	3209535236              @ float -0.803207636
	.long	1058570173              @ float 0.595699131
	.long	3210009394              @ float -0.831469655
	.long	1057896921              @ float 0.555570185
	.long	3210449946              @ float -0.8577286
	.long	1057201213              @ float 0.514102757
	.long	3210855833              @ float -0.88192135
	.long	1056004838              @ float 0.471396625
	.long	3211226072              @ float -0.903989315
	.long	1054533759              @ float 0.427555054
	.long	3211559776              @ float -0.923879623
	.long	1053028112              @ float 0.382683277
	.long	3211856137              @ float -0.941544115
	.long	1051491538              @ float 0.336889803
	.long	3212114443              @ float -0.956940352
	.long	1049927731              @ float 0.290284723
	.long	3212334072              @ float -0.970031261
	.long	1048104901              @ float 0.242980078
	.long	3212514495              @ float -0.98078531
	.long	1044891073              @ float 0.195090309
	.long	3212655276              @ float -0.989176511
	.long	1041645690              @ float 0.146730334
	.long	3212756077              @ float -0.995184719
	.long	1036565808              @ float 0.0980170965
	.long	3212816655              @ float -0.998795449
	.long	1028193021              @ float 0.0490674861
	.size	twiddles_64, 512

	.type	twiddles_128,%object    @ @twiddles_128
	.p2align	4
twiddles_128:
	.long	1065353216              @ float 1
	.long	0                       @ float 0
	.long	1065348163              @ float 0.999698817
	.long	1019808432              @ float 0.024541229
	.long	1065333007              @ float 0.998795449
	.long	1028193072              @ float 0.0490676761
	.long	1065307757              @ float 0.997290432
	.long	1033283845              @ float 0.0735645667
	.long	1065272429              @ float 0.995184719
	.long	1036565814              @ float 0.0980171412
	.long	1065227044              @ float 0.992479562
	.long	1039839859              @ float 0.122410677
	.long	1065171628              @ float 0.989176511
	.long	1041645699              @ float 0.146730468
	.long	1065106216              @ float 0.985277652
	.long	1043271843              @ float 0.170961902
	.long	1065030846              @ float 0.98078525
	.long	1044891074              @ float 0.195090324
	.long	1064945565              @ float 0.975702106
	.long	1046502419              @ float 0.219101235
	.long	1064850424              @ float 0.970031261
	.long	1048104909              @ float 0.242980197
	.long	1064745479              @ float 0.963776051
	.long	1049136788              @ float 0.266712785
	.long	1064630795              @ float 0.956940352
	.long	1049927729              @ float 0.290284663
	.long	1064506439              @ float 0.949528157
	.long	1050712805              @ float 0.313681751
	.long	1064372488              @ float 0.941544055
	.long	1051491540              @ float 0.336889863
	.long	1064229022              @ float 0.932992815
	.long	1052263466              @ float 0.359895051
	.long	1064076126              @ float 0.923879504
	.long	1053028118              @ float 0.382683456
	.long	1063913894              @ float 0.914209723
	.long	1053785035              @ float 0.40524134
	.long	1063742424              @ float 0.903989315
	.long	1054533760              @ float 0.427555084
	.long	1063561817              @ float 0.893224298
	.long	1055273845              @ float 0.449611336
	.long	1063372183              @ float 0.881921231
	.long	1056004842              @ float 0.471396744
	.long	1063173637              @ float 0.870086967
	.long	1056726312              @ float 0.492898226
	.long	1062966298              @ float 0.8577286
	.long	1057201213              @ float 0.514102757
	.long	1062750291              @ float 0.844853579
	.long	1057551771              @ float 0.534997642
	.long	1062525745              @ float 0.831469595
	.long	1057896922              @ float 0.555570245
	.long	1062292797              @ float 0.817584812
	.long	1058236459              @ float 0.575808227
	.long	1062051586              @ float 0.803207516
	.long	1058570176              @ float 0.59569931
	.long	1061802258              @ float 0.788346409
	.long	1058897874              @ float 0.615231633
	.long	1061544963              @ float 0.773010432
	.long	1059219354              @ float 0.634393334
	.long	1061279856              @ float 0.757208824
	.long	1059534422              @ float 0.653172851
	.long	1061007097              @ float 0.74095112
	.long	1059842890              @ float 0.671558976
	.long	1060726850              @ float 0.724247098
	.long	1060144571              @ float 0.689540565
	.long	1060439283              @ float 0.707106769
	.long	1060439283              @ float 0.707106769
	.long	1060144570              @ float 0.689540505
	.long	1060726850              @ float 0.724247098
	.long	1059842889              @ float 0.671558916
	.long	1061007098              @ float 0.74095118
	.long	1059534421              @ float 0.653172791
	.long	1061279857              @ float 0.757208883
	.long	1059219353              @ float 0.634393274
	.long	1061544963              @ float 0.773010432
	.long	1058897873              @ float 0.615231573
	.long	1061802258              @ float 0.788346409
	.long	1058570176              @ float 0.59569931
	.long	1062051586              @ float 0.803207516
	.long	1058236458              @ float 0.575808167
	.long	1062292797              @ float 0.817584812
	.long	1057896921              @ float 0.555570185
	.long	1062525746              @ float 0.831469655
	.long	1057551771              @ float 0.534997642
	.long	1062750291              @ float 0.844853579
	.long	1057201212              @ float 0.514102697
	.long	1062966299              @ float 0.85772866
	.long	1056726311              @ float 0.492898196
	.long	1063173637              @ float 0.870086967
	.long	1056004839              @ float 0.471396655
	.long	1063372184              @ float 0.881921291
	.long	1055273844              @ float 0.449611306
	.long	1063561817              @ float 0.893224298
	.long	1054533761              @ float 0.427555114
	.long	1063742424              @ float 0.903989315
	.long	1053785033              @ float 0.405241281
	.long	1063913895              @ float 0.914209783
	.long	1053028117              @ float 0.382683426
	.long	1064076126              @ float 0.923879504
	.long	1052263463              @ float 0.359894961
	.long	1064229022              @ float 0.932992815
	.long	1051491539              @ float 0.336889833
	.long	1064372488              @ float 0.941544055
	.long	1050712802              @ float 0.313681662
	.long	1064506440              @ float 0.949528217
	.long	1049927728              @ float 0.290284634
	.long	1064630795              @ float 0.956940352
	.long	1049136787              @ float 0.266712755
	.long	1064745479              @ float 0.963776051
	.long	1048104904              @ float 0.242980123
	.long	1064850424              @ float 0.970031261
	.long	1046502418              @ float 0.21910122
	.long	1064945565              @ float 0.975702106
	.long	1044891068              @ float 0.195090234
	.long	1065030847              @ float 0.98078531
	.long	1043271840              @ float 0.170961857
	.long	1065106216              @ float 0.985277652
	.long	1041645701              @ float 0.146730497
	.long	1065171628              @ float 0.989176511
	.long	1039839852              @ float 0.122410625
	.long	1065227044              @ float 0.992479562
	.long	1036565813              @ float 0.0980171337
	.long	1065272429              @ float 0.995184719
	.long	1033283835              @ float 0.0735644922
	.long	1065307757              @ float 0.997290432
	.long	1028193065              @ float 0.04906765
	.long	1065333007              @ float 0.998795449
	.long	1019808382              @ float 0.0245411359
	.long	1065348163              @ float 0.999698817
	.long	3007036718              @ float -4.37113883E-8
	.long	1065353216              @ float 1
	.long	3167292077              @ float -0.0245412234
	.long	1065348163              @ float 0.999698817
	.long	3175676737              @ float -0.0490677394
	.long	1065333007              @ float 0.998795449
	.long	3180767494              @ float -0.0735645741
	.long	1065307757              @ float 0.997290432
	.long	3184049473              @ float -0.0980172231
	.long	1065272429              @ float 0.995184719
	.long	3187323511              @ float -0.122410707
	.long	1065227043              @ float 0.992479503
	.long	3189129354              @ float -0.146730572
	.long	1065171628              @ float 0.989176511
	.long	3190755494              @ float -0.170961946
	.long	1065106216              @ float 0.985277652
	.long	3192374722              @ float -0.195090324
	.long	1065030846              @ float 0.98078525
	.long	3193986072              @ float -0.21910131
	.long	1064945565              @ float 0.975702106
	.long	3195588557              @ float -0.242980197
	.long	1064850424              @ float 0.970031261
	.long	3196620438              @ float -0.266712844
	.long	1064745479              @ float 0.963776051
	.long	3197411379              @ float -0.290284723
	.long	1064630794              @ float 0.956940293
	.long	3198196452              @ float -0.313681722
	.long	1064506439              @ float 0.949528157
	.long	3198975190              @ float -0.336889923
	.long	1064372488              @ float 0.941544055
	.long	3199747114              @ float -0.359895051
	.long	1064229022              @ float 0.932992815
	.long	3200511768              @ float -0.382683516
	.long	1064076126              @ float 0.923879504
	.long	3201268683              @ float -0.40524134
	.long	1063913894              @ float 0.914209723
	.long	3202017408              @ float -0.427555084
	.long	1063742424              @ float 0.903989315
	.long	3202757494              @ float -0.449611366
	.long	1063561817              @ float 0.893224298
	.long	3203488493              @ float -0.471396834
	.long	1063372183              @ float 0.881921231
	.long	3204209958              @ float -0.492898166
	.long	1063173638              @ float 0.870087027
	.long	3204684861              @ float -0.514102757
	.long	1062966298              @ float 0.8577286
	.long	3205035420              @ float -0.534997702
	.long	1062750290              @ float 0.84485352
	.long	3205380572              @ float -0.555570364
	.long	1062525744              @ float 0.831469535
	.long	3205720106              @ float -0.575808167
	.long	1062292797              @ float 0.817584812
	.long	3206053825              @ float -0.59569937
	.long	1062051586              @ float 0.803207516
	.long	3206381523              @ float -0.615231692
	.long	1061802257              @ float 0.78834635
	.long	3206703001              @ float -0.634393274
	.long	1061544964              @ float 0.773010492
	.long	3207018070              @ float -0.653172851
	.long	1061279856              @ float 0.757208824
	.long	3207326539              @ float -0.671559035
	.long	1061007096              @ float 0.740951061
	.long	3207628221              @ float -0.689540684
	.long	1060726848              @ float 0.724246978
	.long	3207922931              @ float -0.707106769
	.long	1060439283              @ float 0.707106769
	.long	3208210499              @ float -0.724247157
	.long	1060144570              @ float 0.689540505
	.long	3208490747              @ float -0.74095124
	.long	1059842888              @ float 0.671558856
	.long	3208763504              @ float -0.757208824
	.long	1059534422              @ float 0.653172851
	.long	3209028612              @ float -0.773010492
	.long	1059219353              @ float 0.634393274
	.long	3209285907              @ float -0.788346469
	.long	1058897872              @ float 0.615231514
	.long	3209535236              @ float -0.803207636
	.long	1058570173              @ float 0.595699131
	.long	3209776445              @ float -0.817584812
	.long	1058236458              @ float 0.575808167
	.long	3210009394              @ float -0.831469655
	.long	1057896921              @ float 0.555570185
	.long	3210233940              @ float -0.84485364
	.long	1057551768              @ float 0.534997463
	.long	3210449946              @ float -0.8577286
	.long	1057201213              @ float 0.514102757
	.long	3210657286              @ float -0.870087027
	.long	1056726309              @ float 0.492898136
	.long	3210855833              @ float -0.88192135
	.long	1056004838              @ float 0.471396625
	.long	3211045465              @ float -0.893224298
	.long	1055273846              @ float 0.449611366
	.long	3211226072              @ float -0.903989315
	.long	1054533759              @ float 0.427555054
	.long	3211397543              @ float -0.914209783
	.long	1053785031              @ float 0.405241221
	.long	3211559776              @ float -0.923879623
	.long	1053028112              @ float 0.382683277
	.long	3211712670              @ float -0.932992815
	.long	1052263466              @ float 0.359895051
	.long	3211856137              @ float -0.941544115
	.long	1051491538              @ float 0.336889803
	.long	3211990088              @ float -0.949528217
	.long	1050712800              @ float 0.313681602
	.long	3212114443              @ float -0.956940352
	.long	1049927731              @ float 0.290284723
	.long	3212229127              @ float -0.963776051
	.long	1049136786              @ float 0.266712725
	.long	3212334072              @ float -0.970031261
	.long	1048104901              @ float 0.242980078
	.long	3212429214              @ float -0.975702166
	.long	1046502408              @ float 0.219101071
	.long	3212514495              @ float -0.98078531
	.long	1044891073              @ float 0.195090309
	.long	3212589864              @ float -0.985277652
	.long	1043271837              @ float 0.170961812
	.long	3212655276              @ float -0.989176511
	.long	1041645690              @ float 0.146730334
	.long	3212710691              @ float -0.992479503
	.long	1039839862              @ float 0.1224107
	.long	3212756077              @ float -0.995184719
	.long	1036565808              @ float 0.0980170965
	.long	3212791406              @ float -0.997290492
	.long	1033283829              @ float 0.0735644475
	.long	3212816655              @ float -0.998795449
	.long	1028193021              @ float 0.0490674861
	.long	3212831811              @ float -0.999698817
	.long	1019808422              @ float 0.0245412104
	.size	twiddles_128, 1024

	.type	g_3,%object             @ @g_3
	.local	g_3
	.comm	g_3,512,16
	.type	filterStart_Node_1111,%object @ @filterStart_Node_1111
	.p2align	4
filterStart_Node_1111:
	.long	0                       @ 0x0
	.long	0                       @ 0x0
	.long	1                       @ 0x1
	.long	1                       @ 0x1
	.long	2                       @ 0x2
	.long	2                       @ 0x2
	.long	3                       @ 0x3
	.long	4                       @ 0x4
	.long	5                       @ 0x5
	.long	5                       @ 0x5
	.long	6                       @ 0x6
	.long	7                       @ 0x7
	.long	8                       @ 0x8
	.long	9                       @ 0x9
	.long	10                      @ 0xa
	.long	11                      @ 0xb
	.long	12                      @ 0xc
	.long	13                      @ 0xd
	.long	14                      @ 0xe
	.long	15                      @ 0xf
	.long	17                      @ 0x11
	.long	18                      @ 0x12
	.long	20                      @ 0x14
	.long	21                      @ 0x15
	.long	23                      @ 0x17
	.long	24                      @ 0x18
	.long	26                      @ 0x1a
	.long	28                      @ 0x1c
	.long	30                      @ 0x1e
	.long	32                      @ 0x20
	.long	34                      @ 0x22
	.long	36                      @ 0x24
	.long	38                      @ 0x26
	.long	40                      @ 0x28
	.long	43                      @ 0x2b
	.long	46                      @ 0x2e
	.long	48                      @ 0x30
	.long	51                      @ 0x33
	.long	54                      @ 0x36
	.long	57                      @ 0x39
	.size	filterStart_Node_1111, 160

	.type	filterCenter_Node_1111,%object @ @filterCenter_Node_1111
	.p2align	4
filterCenter_Node_1111:
	.long	0                       @ 0x0
	.long	1                       @ 0x1
	.long	1                       @ 0x1
	.long	2                       @ 0x2
	.long	2                       @ 0x2
	.long	3                       @ 0x3
	.long	4                       @ 0x4
	.long	5                       @ 0x5
	.long	5                       @ 0x5
	.long	6                       @ 0x6
	.long	7                       @ 0x7
	.long	8                       @ 0x8
	.long	9                       @ 0x9
	.long	10                      @ 0xa
	.long	11                      @ 0xb
	.long	12                      @ 0xc
	.long	13                      @ 0xd
	.long	14                      @ 0xe
	.long	15                      @ 0xf
	.long	17                      @ 0x11
	.long	18                      @ 0x12
	.long	20                      @ 0x14
	.long	21                      @ 0x15
	.long	23                      @ 0x17
	.long	24                      @ 0x18
	.long	26                      @ 0x1a
	.long	28                      @ 0x1c
	.long	30                      @ 0x1e
	.long	32                      @ 0x20
	.long	34                      @ 0x22
	.long	36                      @ 0x24
	.long	38                      @ 0x26
	.long	40                      @ 0x28
	.long	43                      @ 0x2b
	.long	46                      @ 0x2e
	.long	48                      @ 0x30
	.long	51                      @ 0x33
	.long	54                      @ 0x36
	.long	57                      @ 0x39
	.long	61                      @ 0x3d
	.size	filterCenter_Node_1111, 160

	.type	filterEnd_Node_1111,%object @ @filterEnd_Node_1111
	.p2align	4
filterEnd_Node_1111:
	.long	1                       @ 0x1
	.long	1                       @ 0x1
	.long	2                       @ 0x2
	.long	2                       @ 0x2
	.long	3                       @ 0x3
	.long	4                       @ 0x4
	.long	5                       @ 0x5
	.long	5                       @ 0x5
	.long	6                       @ 0x6
	.long	7                       @ 0x7
	.long	8                       @ 0x8
	.long	9                       @ 0x9
	.long	10                      @ 0xa
	.long	11                      @ 0xb
	.long	12                      @ 0xc
	.long	13                      @ 0xd
	.long	14                      @ 0xe
	.long	15                      @ 0xf
	.long	17                      @ 0x11
	.long	18                      @ 0x12
	.long	20                      @ 0x14
	.long	21                      @ 0x15
	.long	23                      @ 0x17
	.long	24                      @ 0x18
	.long	26                      @ 0x1a
	.long	28                      @ 0x1c
	.long	30                      @ 0x1e
	.long	32                      @ 0x20
	.long	34                      @ 0x22
	.long	36                      @ 0x24
	.long	38                      @ 0x26
	.long	40                      @ 0x28
	.long	43                      @ 0x2b
	.long	46                      @ 0x2e
	.long	48                      @ 0x30
	.long	51                      @ 0x33
	.long	54                      @ 0x36
	.long	57                      @ 0x39
	.long	61                      @ 0x3d
	.long	64                      @ 0x40
	.size	filterEnd_Node_1111, 160

	.type	g_4,%object             @ @g_4
	.local	g_4
	.comm	g_4,160,16
	.type	c_1,%object             @ @c_1
	.p2align	4
c_1:
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.long	1065353216              @ float 1
	.size	c_1, 160

	.type	g_5,%object             @ @g_5
	.local	g_5
	.comm	g_5,160,16
	.type	g_6,%object             @ @g_6
	.local	g_6
	.comm	g_6,160,16

	.section	".note.GNU-stack","",%progbits
	.eabi_attribute	30, 2	@ Tag_ABI_optimization_goals
