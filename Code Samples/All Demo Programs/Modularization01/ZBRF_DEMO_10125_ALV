*&---------------------------------------------------------------------*
*& Include          ZBRF_DEMO5_10125_ALV
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .
  PERFORM build_layout.
  PERFORM build_fieldcat.
  PERFORM display_list.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_layout .
  FREE wa_fieldcat.
  PERFORM insert_fieldcat USING: 'CARRID'  'Carrier ID',
                                 'FLDATE'  'Flight Date',
                                 'CONNID'  'Connection ID',
                                 'PRICE'   'Price',
                                 'PLANETYPE' 'Plane Type'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_fieldcat .
  gd_layout-no_input = 'X'.
  gd_layout-colwidth_optimize = 'X'.
  gd_layout-no_min_linesize = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_LIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_list .

  gv_repid = sy-repid.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = gv_repid
*     I_CALLBACK_PF_STATUS_SET = ' '
*     I_CALLBACK_USER_COMMAND = ' '
*     I_CALLBACK_TOP_OF_PAGE = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE = ' '
*     I_CALLBACK_HTML_END_OF_LIST = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
      is_layout          = gd_layout
      it_fieldcat        = it_fieldcat
      it_excluding       = it_exclude
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
      it_filter          = it_filter
*     IS_SEL_HIDE        =
      i_default          = 'X'
      i_save             = 'A'
      is_variant         = g_variant
*     it_events          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     is_reprep_id       =
*     I_SCREEN_START_COLUMN = 0
*     I_SCREEN_START_LINE = 0
*     I_SCREEN_END_COLUMN = 0
*     I_SCREEN_END_LINE  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     I_HTML_HEIGHT_TOP  =
*     I_HTML_HEIGHT_END  =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      t_outtab           = t_upload
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form INSERT_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM insert_fieldcat USING VALUE(p_fieldname)
                           VALUE(p_seltext_l).
  gv_col_pos = gv_col_pos + 1.
  wa_fieldcat-col_pos = gv_col_pos.
  wa_fieldcat-fieldname = p_fieldname.
  wa_fieldcat-seltext_l = p_seltext_l.
  APPEND wa_fieldcat TO it_fieldcat.
  FREE wa_fieldcat.
ENDFORM.
