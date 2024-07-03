*&---------------------------------------------------------------------*
*&  Include           ZSOD_REP_ALV_DISPLAY
*&---------------------------------------------------------------------*
FORM display_alv.
  PERFORM build_field_catalog.
ENDFORM.
FORM build_field_catalog.
  PERFORM build_layout.
  PERFORM build_fieldcat.
  PERFORM display_list.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_layout .
 REFRESH it_fieldcat.
 CLEAR: gw_fields,wa_fieldcat.

  ADD 1 TO col_pos.
  wa_fieldcat-col_pos       = col_pos.
  wa_fieldcat-fieldname     = 'ROLE_NAME'.
  wa_fieldcat-seltext_l     = 'Role Name'.
  wa_fieldcat-ref_fieldname = space.
  wa_fieldcat-ref_tabname   = space.
  wa_fieldcat-hotspot       = space.
  wa_fieldcat-no_out        = space.
  wa_fieldcat-icon          = space.
  wa_fieldcat-outputlen     = space.
  wa_fieldcat-emphasize     = space.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: gw_fields,wa_fieldcat.

  ADD 1 TO col_pos.
  wa_fieldcat-col_pos       = col_pos.
  wa_fieldcat-fieldname     = 'USER_NAME'.
  wa_fieldcat-seltext_l     = 'User Name'.
  wa_fieldcat-ref_fieldname = space.
  wa_fieldcat-ref_tabname   = space.
  wa_fieldcat-hotspot       = space.
  wa_fieldcat-no_out        = space.
  wa_fieldcat-icon          = space.
  wa_fieldcat-outputlen     = space.
  wa_fieldcat-emphasize     = space.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: gw_fields,wa_fieldcat.

  ADD 1 TO col_pos.
  wa_fieldcat-col_pos       = col_pos.
  wa_fieldcat-fieldname     = 'TCODE'.
  wa_fieldcat-seltext_l     = 'T-Code'.
  wa_fieldcat-ref_fieldname = space.
  wa_fieldcat-ref_tabname   = space.
  wa_fieldcat-hotspot       = space.
  wa_fieldcat-no_out        = space.
  wa_fieldcat-icon          = space.
  wa_fieldcat-outputlen     = space.
  wa_fieldcat-emphasize     = space.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: gw_fields,wa_fieldcat.

 LOOP AT gtf_fields INTO gw_fields.
  ADD 1 TO col_pos.
  wa_fieldcat-col_pos       = col_pos.
  wa_fieldcat-fieldname     = gw_fields-tabfield.
  IF gw_fields-display_text NE 'X'.
    wa_fieldcat-seltext_l     = space.
    wa_fieldcat-ref_fieldname = gw_fields-tabfield.
    wa_fieldcat-ref_tabname   = gw_fields-table.
  ELSE.
    wa_fieldcat-seltext_l     = gw_fields-desc.
    wa_fieldcat-ref_fieldname = space.
    wa_fieldcat-ref_tabname   = space.
  ENDIF.
  wa_fieldcat-hotspot       = space.
  wa_fieldcat-no_out        = space.
  wa_fieldcat-icon          = space.
  wa_fieldcat-outputlen     = space.
  wa_fieldcat-emphasize     = space.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR: gw_fields,wa_fieldcat.
 ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fieldcat .
  gd_layout-no_input          = 'X'.
  gd_layout-colwidth_optimize = 'X'.
  gd_layout-no_min_linesize   = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_list .

  IF <gfs_dyn_table> IS ASSIGNED
    AND <gfs_dyn_table> IS NOT INITIAL.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
         EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
      i_callback_program                = gv_repid
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
      is_layout                         = gd_layout
      it_fieldcat                       = it_fieldcat
      it_excluding                      = it_exclude
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
      it_filter                         = it_filter
*   IS_SEL_HIDE                       =
      i_default                         = 'X'
      i_save                            = 'A'
      is_variant                        = g_variant
*   it_events                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   is_reprep_id                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   I_HTML_HEIGHT_TOP                 =
*   I_HTML_HEIGHT_END                 =

* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
          TABLES
            t_outtab                         = <gfs_dyn_table>
         EXCEPTIONS
           program_error                     = 1
           OTHERS                            = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

    ENDIF.
  ELSE.
    MESSAGE 'Final Table empty, report will exit.' TYPE 'I'.
    EXIT.
  ENDIF.
ENDFORM.
