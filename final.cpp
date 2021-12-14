/*
Erick Tran
CPSC240-01
ericktran@csu.fullerton.edu
Braking Force Program
*/
/*
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
;    Name:    final.cpp
;	 Language:	C++
;	 Assemble:	g++ -c -m64 -Wall -fno-pie -no-pie -o final.o final.cpp -std=c++17 *
;********************************************************************************************
*/

#include <iostream>
#include <iomanip>

// Declaration of braking function in assembly.
extern "C" double braking();

// Definition of main function.
int main()
{
  std::cout << "Welcome to the Final Exam program by Erick Tran\n\n";

  double result = braking();

  std::cout << "The main program received " << std::fixed << std::setprecision(5) << result << " and will keep it.\n";
  std::cout << "Have a nice day.\n\n";
  return 0;
}
