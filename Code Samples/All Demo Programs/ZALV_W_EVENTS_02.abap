*&---------------------------------------------------------------------*
*& Report ZBTP_TEST02_10125
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbtp_test02_10125.

TYPE-POOLS: slis.

TYPES: BEGIN OF ty_material,
         matnr TYPE matnr, "Material Number
         maktx TYPE maktx, "Material Description
       END OF ty_material.

DATA: gt_material TYPE TABLE OF ty_material,
      gs_material TYPE ty_material.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_matnr TYPE mara-matnr,
              p_limit TYPE i.
SELECTION-SCREEN: END OF BLOCK b1.

*AT SELECTION-SCREEN.
**  BREAK-POINT.

*INITIALIZATION.
AT SELECTION-SCREEN OUTPUT.
  p_matnr = '000000000000000011'.
  p_limit = 5.

START-OF-SELECTION.
*  DATA lv_matnr TYPE mara-matnr.
*  PERFORM fill_data USING p_matnr p_limit CHANGING lv_matnr.
  PERFORM fill_data.

END-OF-SELECTION.
  PERFORM display_alv.

*&---------------------------------------------------------------------*
*& Form fill_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
*FORM fill_data USING lv_matnr TYPE mara-matnr
*                     lv_limit TYPE i
*               CHANGING lvr_matnr TYPE mara-matnr.
*
**  Scope of variable : lv_matnr , lvr_matnr
*  lvr_matnr = '000000000000000012'.
*  BREAK-POINT.
*
*ENDFORM.
*&---------------------------------------------------------------------*
*& Form fill_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fill_data .
  gs_material-matnr = '10000001'.
  gs_material-maktx = 'Example Material 1'.
  APPEND gs_material TO gt_material.

  gs_material-matnr = '10000002'.
  gs_material-maktx = 'Example Material 2'.
  APPEND gs_material TO gt_material.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .
***********  Step 1.
  PERFORM build_fieldcatalog.
***********  Step 2.
  PERFORM call_alv_function.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form build_fieldcatalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_fieldcatalog .
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'MATNR'.
  gs_fieldcat-seltext_m = 'Material Number'.
  gs_fieldcat-hotspot = 'X'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'MAKTX'.
  gs_fieldcat-seltext_m = 'Material Description'.
  APPEND gs_fieldcat TO gt_fieldcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form call_alv_function
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM call_alv_function .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'USER_COMMAND'
      it_fieldcat             = gt_fieldcat
    TABLES
      t_outtab                = gt_material.
ENDFORM.
FORM user_command USING r_ucomm LIKE sy-ucomm
                       rs_selfield TYPE slis_selfield.
  CASE r_ucomm.
    WHEN '&IC1'.
      READ TABLE gt_material INTO gs_material INDEX rs_selfield-tabindex.
      IF sy-subrc = 0.
        MESSAGE i398(00) WITH 'Material' gs_material-matnr 'selected'.
*        Information.
*        MESSAGE 'Material selected' TYPE 'I'.
*        Error
*        MESSAGE 'Material selected' TYPE 'E' DISPLAY LIKE 'I'.
*        Success
*        MESSAGE 'Material selected' TYPE 'S'.
      ENDIF.
  ENDCASE.
  rs_selfield-refresh = abap_true.
ENDFORM.
