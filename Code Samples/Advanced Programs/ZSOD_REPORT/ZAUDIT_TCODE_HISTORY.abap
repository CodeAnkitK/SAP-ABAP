*&---------------------------------------------------------------------*
*& Report  ZAUDIT_TCODE_HISTORY
*&
*&---------------------------------------------------------------------*
*& Purpose: Dynamic SOD report to view the document creation and change via transactions
*& based on the roles assigned to a set of users.
*& The report is associated with structures and tables of TVARVC and ZTSODSTR.
*& VA01
*& FB75
*& VK11
*& VL01N
*& VF01
*& VF11
*& VL10
*& VL10A
*& VL10C
*& VL10H
*& VL10I
*& ME51N
*&---------------------------------------------------------------------*
REPORT ZAUDIT_TCODE_HISTORY.

** SOD Report Declarations
INCLUDE ZAUDIT_TCODE_HISTORY_TOP.
** Selection Screen
INCLUDE ZSOD_REP_SELECTION_SCREEN.
** SOD Report Selection Screen
INCLUDE ZSOD_REP_PROCESS.
** ALV Display
INCLUDE ZSOD_REP_ALV_DISPLAY.
** SOD Report Subroutines
INCLUDE ZSOD_SUB_ROUTINES.
