*&---------------------------------------------------------------------*
*& Report ZBRP_TEST_PRO_10125
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbrp_test_pro_10125.

INCLUDE zbtp_test_top.
INCLUDE zbrp_test_include_scr.
INCLUDE zbtp_test_output.
INCLUDE zbtp_test_f01.

INITIALIZATION.

  p_curr = 'USD'.

START-OF-SELECTION.

*BREAK-POINT.
  PERFORM fetch_logic.

END-OF-SELECTION.
  PERFORM output.
