;
; Erick Tran
; CPSC240-01
; ericktran@csu.fullerton.edu
; Braking Force Program
;
;********************************************************************************************
; Author Information:                                                                       *
; Name:         Erick Tran                                                                  *
; Email:        ericktran@csu.fullerton.edu                                                 *
; Institution:  California State University - Fullerton                                     *
; Course:       CPSC 240-01 Assembly Language                                               *
;                                                                                           *
;********************************************************************************************
; Copyright (C) 2021 Erick Tran                                                             *
; This program is free software: you can redistribute it and/or modify it under the terms   *
; of the GNU General Public License version 3 as published by the Free Software Foundation. *
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY  *
; without even the implied Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. *
; See the GNU General Public License for more details. A copy of the GNU General Public     *
; License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
;                                                                                           *
;********************************************************************************************
; This File                                                                                 *
;    Name:      braking.asm                                                      	            *
;    Purpose:   Computes the braking force required to make a complete stop of a moving object.
;               Also calculates cpu clock frequency and how long computation took.                                                   *
;	 Language:	(x86) Assembly																    			                       *
;	 Assemble:	nasm -f elf64 -l braking.lis -o braking.o braking.asm				                        *
;********************************************************************************************


;Declare the names of functions called in this file whose source code is not in this file.
extern printf
extern scanf
extern atof

global braking                       ; Make function callable by other linked files.

section .data

    new_line db "", 10, 0

		welcome db "Welcome to the Braking Program.", 10, 0

    frequency db "The frequency (GHz) of the processor in machine is %.2lf GHz", 10, 10, 0
    get_freq db "Please enter the cpu frequency (GHz): ", 0, 0

		mass db "Enter the mass of the moving vehicle (Kg): ", 0, 0
    velocity db "Enter the velocity of the vehicle (m/s): ", 0, 0
    distance db "Enter the distance (m) required for a complete stop: ", 0, 0

		braking_force db "The required braking force is %.8lf Newtons", 10, 10, 0

    computation db "The computation required %ld tics or %.4lf nanosecs", 10, 10, 0

		goodbye db "The area will be returned to the driver.", 10, 10, 0

   	stringFormat db "%s", 0
    floatFormat db "%lf", 0

    half_float dq 0.5

section .bss

section .text

braking:
; Back up all registers and set stack pointer to base pointer
    push rbp
    mov rbp, rsp
    push rdi
    push rsi
    push rdx
    push rcx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    push rbx
    pushf

    push qword 0               ; Extra push to create even number of pushes

;=================================FUNCTION BEGINS===========================================


    ; Print welcome message & prompt for sides
   	xor rax, rax
		mov rdi, stringFormat
		mov rsi, welcome
		call printf

    push qword 0 ;extra push

;-----------------------------------------------------
; Get clock frequency

    mov r14, 0x80000003 ; value passed to cpuid for processor
    xor r15, r15  ; loop control variable
    xor r11, r11  ; counter/flag for character collection

section_loop:
    xor r13, r13  ; zero loop contrl variable

    mov rax, r14  ; parameter for processor brand and info
    cpuid
    inc r14

    push rdx  ; 4th set
    push rcx  ; 3rd set
    push rbx  ; 2nd set
    push rax  ; 1st set

register_loop:
    xor r12, r12  ; loop control var for char loop
    pop rbx     ; new string of 4 chars

char_loop:
    mov rdx, rbx  ; move string of 4 to rdx
    and rdx, 0xFF
    shr rbx, 0x8

    cmp rdx, 64
    jne counter
    mov r11, 1

counter:
    cmp r11, 1
    jl body
    inc r11

body:
    cmp r11, 4
    jl loop_conditions
    cmp r11, 7
    jg loop_conditions

    shr r10, 0x8
    shl rdx, 0x18
    or r10, rdx

loop_conditions:
    inc r12
    cmp r12, 4
    jne char_loop

    inc r13
    cmp r13, 4
    jne register_loop

    inc r15
    cmp r15, 2
    jne section_loop

loops_done:
    push r10
    xor rax, rax
    mov rdi, rsp
    call atof
    pop r10
    movsd xmm12, xmm0   ; Frequency stored in xmm12

    ; Print clock speed
   	mov rax, 1
		mov rdi, frequency
		call printf

    ; AMD error checking - if clock speed 0.00, manual input later
    xor r15, r15

    movq r10, xmm12
    cmp r10, 0
    jne valid_freq

    mov r15, 1  ; Bool val is true if clock speed invalid

valid_freq:
;-----------------------------------------------------
; Get input values of mass , velocity, and distance
; Mass (xmm13)

   	xor rax, rax
		mov rdi, stringFormat
		mov rsi, mass
		call printf

    xor rax, rax
    mov rdi, stringFormat
    mov rsi, rsp
    call scanf

    mov rdi, rsp
    mov rax, 1
    call atof
    movsd xmm13, xmm0

; Velocity (xmm14)

   	xor rax, rax
		mov rdi, stringFormat
		mov rsi, velocity
		call printf

    xor rax, rax
    mov rdi, stringFormat
    mov rsi, rsp
    call scanf

    mov rdi, rsp
    mov rax, 1
    call atof
    movsd xmm14, xmm0

; Distance (xmm15)

   	xor rax, rax
		mov rdi, stringFormat
		mov rsi, distance
		call printf

    xor rax, rax
    mov rdi, stringFormat
    mov rsi, rsp
    call scanf

    mov rdi, rsp
    mov rax, 1
    call atof
    movsd xmm15, xmm0

;-----------------------------------------------------
; Get clock time
    xor rax, rax
    xor rdx, rdx

    rdtsc

    shl rdx, 32
    add rax, rdx
    mov r12, rax

; Calculate braking force
  ; Store 0.5 as a constant
    movsd xmm11, qword [half_float] ; move 0.5 into xmm11
    mulsd xmm11, xmm13  ; mass * 0.5
    mulsd xmm14, xmm14  ; square velocity
    mulsd xmm11, xmm14  ; result * velocity^2
    divsd xmm11, xmm15  ; result / distance
    movsd xmm13, xmm11
    ; final braking force stored in xmm13

; Get clock time again
    xor rax, rax
    xor rdx, rdx

    rdtsc

    shl rdx, 32
    add rax, rdx
    mov r13, rax

; Calculate change in clock time
    cvtsi2sd xmm14, r12 ; initial clock
    cvtsi2sd xmm15, r13 ; final clock
    subsd xmm15, xmm14  ; calculate difference

    cvtsd2si r12, xmm15 ; store difference as long int for printing

;-----------------------------------------------------
; Print braking force
    mov rax, 1
    mov rdi, braking_force
    movsd xmm0, xmm13
    call printf

;-----------------------------------------------------
; Calculate nanosecs elapsed with CPU clock speed
; If clock speed was 0.00, prompt user for manual input
    cmp r12, 0
    je calc_nanosecs

; Prompt user for CPU frequency

    xor rax, rax
		mov rdi, stringFormat
		mov rsi, get_freq
		call printf

    xor rax, rax
    mov rdi, stringFormat
    mov rsi, rsp
    call scanf

    mov rdi, rsp
    mov rax, 1
    call atof
    movsd xmm12, xmm0

calc_nanosecs:
    divsd xmm15, xmm12  ; divide tics by nanosecs

; Print computed time

    mov rax, 1
    mov rdi, computation
    mov rsi, r12
    movsd xmm0, xmm15
    call printf

; Move nanosecs to xmm0 for return value
    movsd xmm0, xmm15

end_of_function:
;===============================END OF AREA FUNCTION========================================


		pop rax	; extra pop
    pop rax                     ; Remove extra push of -1 from stack.

    ; Restores all registers to their original state.
    popf
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rbp

    ret
