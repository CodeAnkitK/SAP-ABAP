*&---------------------------------------------------------------------*
*& Report ZAV_MODULARIZATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAV_MODULARIZATION.
" R I C E F W

DEFINE sum_val.
  DATA sum TYPE i.
  sum = &1 + &2.  "$ is wrong we use &
  WRITE sum.
*  WRITE: &1.
END-OF-DEFINITION.

sum_val 2 3.

"Scope of variable
"Main Program
*BREAK-POINT.

*NETWEAVER 7.5 " New Syntax

"Macro Definition :  EXAMPLE TOMORROW
" CANNOT DEBUG THIS PROGRAM.
" It has very tight syntax.
" NEVER USE IT FOR More that 4-5 Lines.




*
*DATA a TYPE i VALUE 5.
*DATA b TYPE i VALUE 10.
*add_val: a b.


*DATA a TYPE i VALUE '1'.
*PERFORM display.
*Write: a.

"Passing Value to Sub routing
*PERFORM display USING 10. "Actual Parametr

*PERFORM display.
*PERFORM display.
*PERFORM display.

*Sub routine
*Reusable Snippet

"Updaing Value from Sub routing
DATA: p_num1 TYPE i.
PERFORM sum USING 3 2 CHANGING p_num1.
WRITE: p_num1.


*Actual Parameter are deifned and the actual values
DATA: lt_tab TYPE TABLE OF i.
PERFORM process TABLES lt_tab.
 cl_demo_output=>display( lt_tab ).

*BREAK-POINT.

" Reability
" Reusable
"Split the program into Multiple.
INCLUDE ZAV_DEMO_INCLUDE.