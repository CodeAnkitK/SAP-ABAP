*&---------------------------------------------------------------------*
*& Report ZESEAL_ERR_REN_BG
*&---------------------------------------------------------------------*
REPORT zeseal_err_ren_bg.


INCLUDE zeseal_err_ren_bg_top.
INCLUDE zeseal_err_ren_bg_scr.


START-OF-SELECTION.
***************************************
*********  Check error / renew
***************************************
  IF pr_err = 'X'.
    PERFORM process_error_log.
  ENDIF.

  IF pr_rnw = 'X'.
    PERFORM process_renew_log.
  ENDIF.

  IF pr_sim = 'X'.
    PERFORM display_log.
  ENDIF.


  INCLUDE zeseal_err_ren_bg_fcn.
  INCLUDE zeseal_err_ren_bg_alv.
