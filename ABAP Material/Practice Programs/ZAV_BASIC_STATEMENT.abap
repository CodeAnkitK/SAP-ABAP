*&---------------------------------------------------------------------*
*& Report ZAV_BASIC_STATEMENT
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Conceptual Questions
*&---------------------------------------------------------------------*
" BASIC Statement , conditional statement , String Functions
" Structure and internal tables
" Dictionaly objects
" Database Access Selection Screen
" Reports
" Mesagges
" Mpduclarization Technique - Function Module / Subroutine

" Module Pool
" File Handling
" Smartforms
" BDC & LSMW
" SAP Script
*&---------------------------------------------------------------------*
REPORT zav_basic_statement.

"Variable Declaration

"Conditional Statement
*PARAMETERS: p_var1 TYPE i,
*            p_var2 TYPE i.


*IF p_var1 GT 300.
*
*  WRITE: / 'Var1: High Value'.
*
*ELSE.
*
*  IF p_var2 GT 1000.
*
*    WRITE: / 'Var2: High Value'.
*
*  ELSE.
*
*    WRITE: / 'Overall Low Value'.
*  ENDIF.
*ENDIF.

"========================================================
*IF p_var1 GT 300.
*
*  WRITE: / 'Var1: High Value'.
*
*ELSEIF p_var2 GT 1000.
*
*  WRITE: / 'Var2: High Value'.
*
*ELSE.
*
*  WRITE: / 'Overall Low Value'.
*
*ENDIF.


"========================================================
*CASE
"========================================================

*PARAMETERS: pc_check AS CHECKBOX.
*
*CASE pc_check.
*
*  WHEN 'X'.
*    WRITE: / 'The box is checked'.
*  WHEN ' '.
*    WRITE: / 'The box is not checked'.
*
*ENDCASE.

"========================================================
*CHECKBOX
"========================================================

*PARAMETERS: pr_chk1 RADIOBUTTON GROUP rg1,
*            pr_chk2 RADIOBUTTON GROUP rg1,
*            pr_chk3 RADIOBUTTON GROUP rg1,
*            pr_chk4 RADIOBUTTON GROUP rg1,
*            pr_chk5 RADIOBUTTON GROUP rg1.
*
*IF pr_chk1 EQ 'X'.
*  WRITE: / 'Your rating is 1'.
*ELSEIF pr_chk2 EQ 'X'.
*  WRITE: / 'Your rating is 2'.
*ELSEIF pr_chk3 EQ 'X'.
*  WRITE: / 'Your rating is 3'.
*ELSEIF pr_chk4 EQ 'X'.
*  WRITE: / 'Your rating is 4'.
*ELSEIF pr_chk5 EQ 'X'.
*  WRITE: / 'Your rating is 5'.
*ENDIF.