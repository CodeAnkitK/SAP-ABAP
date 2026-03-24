*&---------------------------------------------------------------------*
*& Report ZAV_ABAPOJ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAV_ABAPOJ.

" Declarations Statements
" DATA, WRITE, CONSTANT, Parameters

*DATA variable1 TYPE c.  " Variable name "vraiable1" Length : 1 Type Charecter
*DATA variable2(10) TYPE c.  " Variable name "vraiable2" Length : 10 Type Charecter
*DATA variable3 TYPE i.  " Variable name "vraiable2" Type Integer
*DATA variable4 TYPE boolean. " Variable name "vraiable4"  Type Boolean Value True / False
*DATA variable5 TYPE boolean. " Variable name "vraiable4"  Type Boolean Value True / False

"Statement Chain:
DATA: variable1 TYPE c VALUE IS INITIAL,  " Variable name "vraiable1" Length : 1 Type Charecter
      variable2(10) TYPE c,  " Variable name "vraiable2" Length : 10 Type Charecter
      variable3 TYPE i,  " Variable name "vraiable2" Type Integer
      variable4 TYPE boolean, " Variable name "vraiable4"  Type Boolean Value True / False
      variable5 TYPE boolean. " Variable name "vraiable4"  Type Boolean Value True / False

PARAMETERS: var1 TYPE i OBLIGATORY.
PARAMETERS: var2 TYPE c.


"Constant:
CONSTANTS: indicator1 TYPE c VALUE 'A',
           indicator2 TYPE c VALUE 'B'.

variable1 = 'A'.
variable2 = 'Ankit'.
variable3 = 123456789. "and  '123456789'
variable4 = abap_true. "'X'
variable5 = abap_false. "' '

" Scope of Variable:
variable1 = 'B'.

*indicator2 = 'C'. Error because it is constant

*WRITE variable1.
*WRITE / |{ variable2 WIDTH = 40 ALIGN = LEFT }|.
*WRITE / variable3.
*WRITE / variable4.
*WRITE / variable5.

WRITE: variable1,
      / |{ variable2 WIDTH = 40 ALIGN = LEFT }|,
      / variable3,
      / variable4,
      / variable5,
      / |{ var1 WIDTH = 40 ALIGN = LEFT }|,
      / var2.