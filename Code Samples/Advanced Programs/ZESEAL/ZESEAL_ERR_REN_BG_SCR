*&---------------------------------------------------------------------*
*& Include          ZESEAL_ERR_REN_BG_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-000.
  PARAMETERS: pr_err RADIOBUTTON GROUP rg1,
              pr_rnw RADIOBUTTON GROUP rg1,
              pr_sim RADIOBUTTON GROUP rg1.
SELECTION-SCREEN:END OF BLOCK b1.

SELECTION-SCREEN: BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-001.
  PARAMETERS:  pc_sim AS CHECKBOX.
SELECTION-SCREEN: END OF BLOCK b2.

SELECTION-SCREEN: BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-002.
  SELECT-OPTIONS: s_bp FOR zdc_eseal_log-gpart. "sOBLIGATORY.
  SELECT-OPTIONS: s_cokey FOR zdc_eseal_log-cokey. "OBLIGATORY.
  SELECT-OPTIONS: s_cotyp FOR zdc_eseal_log-cotyp. " OBLIGATORY.
  SELECT-OPTIONS: s_date  FOR zdc_eseal_log-entry_date.
  PARAMETERS: p_status TYPE zdc_eseal_log-status.
SELECTION-SCREEN: END OF BLOCK b3.

AT SELECTION-SCREEN.
  IF pc_sim EQ 'X'.
    IF s_bp IS INITIAL.
      MESSAGE TEXT-032 TYPE 'E'.
    ENDIF.

    IF s_cokey IS INITIAL.
      MESSAGE TEXT-033 TYPE 'E'.
    ENDIF.

    IF s_cotyp IS INITIAL.
      MESSAGE TEXT-034 TYPE 'E'.
    ENDIF.
  ENDIF.

  IF pr_sim EQ 'X'.
    IF  s_date IS INITIAL.
      MESSAGE TEXT-035 TYPE 'E'.
    ENDIF.
  ENDIF.
