*&---------------------------------------------------------------------*
*& Include ZAV_DEMO_INCLUDE
*&---------------------------------------------------------------------*
FORM display
             USING p_num. "Formal Paremater
  DATA a TYPE i VALUE '2'.
  Write: / 'Hello World'.
  Write: a.
  Write: p_num.
ENDFORM.
FORM sum USING val_a
               val_b
         CHANGING val_c.

  val_c = val_a + val_b.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form process
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_TAB
*&---------------------------------------------------------------------*
"Formal Prameter is Dummy and tables the type of Actual Parameter.
FORM process  TABLES p_lt_tab.
  DO 10 TIMES.
    APPEND 100 TO  p_lt_tab .
  ENDDO.
ENDFORM.