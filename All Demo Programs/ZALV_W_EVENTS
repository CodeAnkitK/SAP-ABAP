*&---------------------------------------------------------------------*
*& Report ZBRF_DEMO11_ALV_HS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBRF_DEMO11_ALV_HS.

TYPES: BEGIN OF ty_material,
         matnr TYPE matnr,
         maktx TYPE maktx,
       END OF ty_material.

DATA: it_material TYPE TABLE OF ty_material,
      wa_material TYPE ty_material.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv.

* Fill example data
START-OF-SELECTION.
  PERFORM fill_data.
  PERFORM display_alv.

FORM fill_data.
  wa_material-matnr = '10000001'.
  wa_material-maktx = 'Example Material 1'.
  APPEND wa_material TO it_material.

  wa_material-matnr = '10000002'.
  wa_material-maktx = 'Example Material 2'.
  APPEND wa_material TO it_material.
ENDFORM.

FORM display_alv.
  PERFORM build_fieldcatalog.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_callback_user_command = 'USER_COMMAND'
      it_fieldcat = gt_fieldcat[]
    TABLES
      t_outtab = it_material.
ENDFORM.

FORM build_fieldcatalog.
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

FORM user_command USING r_ucomm LIKE sy-ucomm
                       rs_selfield TYPE slis_selfield.
  CASE r_ucomm.
    WHEN '&IC1'.
      READ TABLE it_material INTO wa_material INDEX rs_selfield-tabindex.
      IF sy-subrc = 0.
        MESSAGE s398(00) WITH 'Material' wa_material-matnr 'selected'.
      ENDIF.
  ENDCASE.
  rs_selfield-refresh = abap_true.
ENDFORM.
