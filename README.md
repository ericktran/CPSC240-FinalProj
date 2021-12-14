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
