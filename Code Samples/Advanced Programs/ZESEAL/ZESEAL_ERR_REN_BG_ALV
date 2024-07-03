*&---------------------------------------------------------------------*
*& Include          ZDR39001_ESEAL_ERR_REN_BG_ALV
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*    MODULE    : TRM
*---------------------------------------------------------------------*
*    Program   : Updates Tables (   )    Downloads data (  )
*                Outputs List   (X)
*
*    Objective                 : CR390 - eSeal ceritificate
*    Functional Specifications :
*    Technical Spec No         : eCTS_TS_Interface
*    Functional Consultant     : Farheen Toraub
*    Date Created              : 29.11.2023
*    Abap Consultant           : Ankit Kumar
*    Project                   : FTA
*    Project Name              : FTA TRM Implementation
*    Company                   : Invenio Business Solutions
*---------------------------------------------------------------------*
*    External Dependencies                                            *
*---------------------------------------------------------------------*
*  UAE EPASS returning the PDF with sealed Data.                                                                   *
*---------------------------------------------------------------------*
*    Amendment History
*---------------------------------------------------------------------*
* Who        Change ID    Reason                                      *
* ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                     *
* XXXXXXXXX  AADDMMYYYY Where XXXX = Developers Name................. *
*            AA- Developers Initial ................................. *
*            ........................................................ *
*            ........................................................ *
*---------------------------------------------------------------------*
*& This is background program to reprocess the Errors and renewals.
*& Diplay the logs.
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form build_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_layout .
  FREE gt_fieldcat.
  PERFORM insert_fieldcat USING:
*************************************************************************************************************************************
* Inbound Field Catalogue
*************************************************************************************************************************************
 'REQUEST_ID'     TEXT-004                                        'ZDC_ESEAL_LOG' 'REQUEST_ID'  space space space space space,
 'COKEY'          TEXT-005                                     'ZDC_ESEAL_LOG' 'COKEY' space space space space space,
 'COTYP'         TEXT-006                                     'ZDC_ESEAL_LOG' 'COTYP' space space space space space,
 'GPART'          TEXT-007                              'ZDC_ESEAL_LOG' 'GPART' space space space space space,
 'VKONT'          TEXT-008                               'ZDC_ESEAL_LOG' 'VKONT' space space space space space,
 'VTREF'          TEXT-009                                              'ZDC_ESEAL_LOG' 'VTREF' space space space space space,
 'ADD_GPART'      TEXT-010                                      'ZDC_ESEAL_LOG' 'ADD_GPART' space space space space space,
 'ENTRY_DATE'     TEXT-011                                            'ZDC_ESEAL_LOG'  'ENTRY_DATE'  space space space space space,
 'CHANGED_DATE'   TEXT-012                                          'ZDC_ESEAL_LOG' 'CHANGED_DATE'  space space space space space,
 'ENTRY_TIME'     TEXT-013                                            'ZDC_ESEAL_LOG' 'ENTRY_TIME'  space space space space space,
 'CHANGED_TIME'   TEXT-014                                          'ZDC_ESEAL_LOG' 'CHANGED_TIME'  space space space space space,
 'DATE_SENT'      TEXT-015                                             'ZDC_ESEAL_LOG' 'DATE_SENT' space space space space space,
 'TIME_SENT'      TEXT-016                                             'ZDC_ESEAL_LOG' 'TIME_SENT' space space space space space,
 'DATE_RECEIVED'  TEXT-017                                         'ZDC_ESEAL_LOG' 'DATE_RECEIVED' space space space space space,
 'TIME_RECEIVED'  TEXT-018                                         'ZDC_ESEAL_LOG' 'TIME_RECEIVED' space space space space space,
 'STATUS'         TEXT-019                                         'ZDC_ESEAL_LOG' 'STATUS'  space space space space space,
 'STATUS_DESC'    TEXT-020                                    'ZDC_ESEAL_LOG' 'STATUS_DESC' space space space space space,
 'ERROR_DESC'     TEXT-021                                     'ZDC_ESEAL_LOG' 'ERROR_DESC'  space space space space space,
 'CER_NUMBER'     TEXT-022                                    'ZDC_ESEAL_LOG' 'CER_NUMBER'  space space space space space,
 'VERSION'        TEXT-023                                       'ZDC_ESEAL_LOG' 'VERSION' space space space space space,
 'NEW_COTYP'      TEXT-024                               'ZDC_ESEAL_LOG' 'NEW_COTYP' space space space space space,
 'NEW_COKEY'      TEXT-025                                'ZDC_ESEAL_LOG' 'NEW_COKEY' space space space space space,
 'SEAL_DATE'      TEXT-026                                              'ZDC_ESEAL_LOG' 'SEAL_DATE' space space space space space,
 'SEAL_RENEW_DATE'   TEXT-027                                'ZDC_ESEAL_LOG' 'SEAL_RENEW_DATE' space space space space space,
 'RENEWAL_STATUS'    TEXT-028                                     'ZDC_ESEAL_LOG' 'RENEWAL_STATUS'  space space space space space,
 'BASE64_S'          TEXT-029                                        'ZDC_ESEAL_LOG' 'BASE64_S'  space space space space space,
 'BASE64_R'         TEXT-030                                   'ZDC_ESEAL_LOG' 'BASE64_R'  space space space space space,
 'SIGNATURE'         TEXT-031                                           'ZDC_ESEAL_LOG' 'SIGNATURE'   space space space space space.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form build_fieldcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_fieldcat .
  gs_layout-no_input          = 'X'.
  gs_layout-colwidth_optimize = 'X'.
  gs_layout-no_min_linesize   = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_list
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_list .

  DATA: ls_variant TYPE disvariant.
  DATA: lv_repid   TYPE  sy-repid.
  DATA: lt_exclude TYPE slis_t_extab.
  DATA: lt_filter  TYPE  slis_t_filter_alv.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = lv_repid
      is_layout          = gs_layout
      it_fieldcat        = gt_fieldcat
      it_excluding       = lt_exclude
      it_filter          = lt_filter
      i_default          = 'X'
      i_save             = 'A'
      is_variant         = ls_variant
    TABLES
      t_outtab           = gt_log_display
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INSERT_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0468   text
*      -->P_SPACE  text
*      -->P_0470   text
*      -->P_0471   text
*      -->P_SPACE  text
*      -->P_SPACE  text
*      -->P_SPACE  text
*      -->P_12     text
*      -->P_SPACE  text
*----------------------------------------------------------------------*
FORM insert_fieldcat  USING    VALUE(p_field)
                               VALUE(p_fname)
                               p_rtab
                               p_rfield
                               p_hotp
                               p_no_out
                               p_icon
                               p_oplen
                               p_emphasize.

  DATA: lv_col_pos TYPE i.
  DATA: ls_fieldcat  TYPE slis_fieldcat_alv.

  lv_col_pos = lv_col_pos + 1.
  ls_fieldcat-col_pos       = lv_col_pos.
  ls_fieldcat-fieldname     = p_field.
  ls_fieldcat-seltext_l     = p_fname.
  ls_fieldcat-ref_fieldname = p_rfield.
  ls_fieldcat-ref_tabname   = p_rtab.
  ls_fieldcat-hotspot       = p_hotp.
  ls_fieldcat-no_out        = p_no_out.
  ls_fieldcat-icon          = p_icon.
  ls_fieldcat-outputlen     = p_oplen.
  ls_fieldcat-emphasize     = p_emphasize.
  APPEND ls_fieldcat TO gt_fieldcat.
  CLEAR  ls_fieldcat.
ENDFORM.
