REPORT zsd_rep_inv_print.

TYPE-POOLS:slis , abap , icon.

TABLES: bkpf, bseg, bsad, bsid, vbrk, kna1 , icon , t685b.


CONSTANTS: back LIKE t77fc-fcode VALUE 'BACK',
           insert     LIKE back VALUE 'INSE',
           change     LIKE back VALUE 'AEND',
           delete     LIKE back VALUE 'DEL ',
           update     LIKE back VALUE 'UPD '.


DATA it_bkpf TYPE STANDARD TABLE OF bkpf.
DATA it_bseg TYPE STANDARD TABLE OF bseg.
DATA it_t685b TYPE STANDARD TABLE OF t685b.

DATA: BEGIN OF wa_vbrk ,
        vbeln LIKE  vbrk-vbeln, "Billing Document
        fkdat LIKE  vbrk-fkdat, "date
        gjahr LIKE  vbrk-gjahr, "Fiscal Year
        kunrg LIKE  vbrk-kunrg, "Payer
        kunag LIKE  vbrk-kunag, "Sold-to party
        bukrs LIKE  vbrk-bukrs, "Company Code
       END OF wa_vbrk.

*  DATA: BEGIN OF wa_bseg  ,
*           bukrs1  LIKE  bseg-bukrs, "Company Code
*           belnr    LIKE  bseg-belnr, "Accounting Document Number
*           gjahr1  LIKE  bseg-gjahr, "Fiscal Year
*           vbeln1  LIKE  bseg-vbeln, "Billing Document
*    kunnr LIKE bseg-kunnr ,
*          END OF wa_bseg.

DATA: BEGIN OF wa_bsid ,
         bukrs1  LIKE  bsid-bukrs, "Company Code
         kunnr LIKE bsid-kunnr ,
         gjahr1  LIKE  bsid-gjahr, "Fiscal Year
         belnr    LIKE  bsid-belnr, "Accounting Document Number
         budat LIKE bsid-budat ,
         blart TYPE blart,
         waers LIKE bsid-waers ,
         wrbtr LIKE bsid-wrbtr ,
         vbeln1  LIKE  bsid-vbeln, "Billing Document
         gsber  LIKE  bsid-gsber, "Business Area
        END OF wa_bsid.

DATA: BEGIN OF wa_kna1,
  kunnr1 LIKE kna1-kunnr ,
  name1 LIKE kna1-name1,
  ort01 LIKE kna1-ort01,
  END OF wa_kna1 .


DATA col_pos TYPE i.

DATA gd_layout TYPE slis_layout_alv.
DATA wa_exclude TYPE slis_extab.
DATA it_exclude TYPE slis_t_extab.
DATA g_variant LIKE disvariant.
DATA gx_variant LIKE disvariant.
DATA wa_bkpf TYPE bkpf.
DATA wa_bseg TYPE bseg.

*  **************************************************
DATA formname TYPE tdsfname.
DATA:lf_fm_name TYPE rs38l_fnam.
DATA gv_repid TYPE sy-repid.
DATA status TYPE gui_status.
DATA g_save TYPE c.
DATA g_exit TYPE c.

DATA: BEGIN OF wa_final ,
        icact(30) ,
        bukrs TYPE bkpf-bukrs,
        belnr TYPE bkpf-belnr,
        gjahr TYPE bkpf-gjahr,
        xblnr LIKE bkpf-xblnr,
        budat TYPE bkpf-budat,
        bldat TYPE bkpf-bldat,
        wrbtr TYPE bseg-wrbtr,
        waers TYPE bkpf-waers,
        usnam TYPE bkpf-usnam,
        bktxt TYPE bkpf-bktxt,
        kunnr TYPE bseg-kunnr,
        vbeln TYPE vbrk-vbeln,
        bschl TYPE bseg-bschl,
        dctyp(20),
       END OF wa_final.

"internal tables
DATA: it_vbrk LIKE STANDARD TABLE OF wa_vbrk WITH HEADER LINE,
*        it_bseg LIKE STANDARD TABLE OF wa_bseg WITH HEADER LINE,
      it_bsid LIKE STANDARD TABLE OF wa_bsid WITH HEADER LINE,
      it_kna1 LIKE STANDARD TABLE OF wa_kna1 WITH HEADER LINE,
      it_final_tmp LIKE STANDARD TABLE OF wa_final WITH HEADER LINE ,
      it_final LIKE STANDARD TABLE OF wa_final.

"variables for ALV grid.
DATA : wa_fieldcat TYPE slis_fieldcat_alv,
    it_fieldcat TYPE slis_t_fieldcat_alv,
    wa_layout TYPE slis_layout_alv,
*        WA_EVENT TYPE SLIS_ALV_EVENT,
*        IT_EVENT TYPE SLIS_T_EVENT,
    wa_selfeild TYPE slis_selfield,
    wa_listhead TYPE slis_listheader,
    it_listhead TYPE slis_t_listheader,
    wa_sort TYPE slis_sortinfo_alv,
    it_sort TYPE slis_t_sortinfo_alv.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: so_bukrs FOR bsid-bukrs OBLIGATORY,
                so_gjahr FOR bsid-gjahr OBLIGATORY,
                so_belnr FOR bsid-belnr OBLIGATORY,
                so_budat FOR bsid-budat,
                so_kunnr FOR bsid-kunnr.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETER: so_kschl LIKE t685b-kschl.
PARAMETER: for_m(10) TYPE c.
SELECTION-SCREEN END OF BLOCK b2.

INITIALIZATION.
  gv_repid = sy-repid .
  status = 'ZSTANDARD' .

START-OF-SELECTION.
  PERFORM get_data.

  IF it_final[] IS INITIAL .
    MESSAGE 'No Data Available' TYPE 'I' .
  ELSE.
    PERFORM display_alv_list.
  ENDIF .

END-OF-SELECTION.

*  &---------------------------------------------------------------------*
*  &      Form  GET_DATA
*  &---------------------------------------------------------------------*
*         text
*  ----------------------------------------------------------------------*
*    -->  p1        text
*    <--  p2        text
*  ----------------------------------------------------------------------*
FORM get_data .
  SELECT *
  FROM bkpf
  INTO TABLE it_bkpf
  WHERE belnr IN so_belnr
  AND   bukrs IN so_bukrs
  AND   gjahr IN so_gjahr
  AND   budat IN so_budat.

  CHECK it_bkpf IS NOT INITIAL.

  SELECT *
  FROM bseg
  INTO TABLE it_bseg
  FOR ALL ENTRIES IN it_bkpf
  WHERE belnr = it_bkpf-belnr
  AND   bukrs = it_bkpf-bukrs
  AND   gjahr = it_bkpf-gjahr
  AND   kunnr IN so_kunnr
  AND   bschl IN ('01','12','04')  .


  LOOP AT it_bkpf INTO bkpf.
    LOOP AT it_bseg INTO bseg WHERE belnr = bkpf-belnr
                                AND bukrs = bkpf-bukrs
                                AND gjahr = bkpf-gjahr.
      CLEAR wa_final.
      wa_final-icact(30) = icon_change.
      wa_final-bukrs = bkpf-bukrs.
      wa_final-belnr = bkpf-belnr.
      wa_final-gjahr = bkpf-gjahr.
      wa_final-xblnr = bkpf-xblnr.
      wa_final-budat = bkpf-budat.
      wa_final-bldat = bkpf-bldat.
      wa_final-waers = bkpf-waers.
      wa_final-usnam = bkpf-usnam.
      wa_final-bktxt = bkpf-bktxt.
      wa_final-kunnr = bseg-kunnr.
      wa_final-wrbtr = bseg-wrbtr.
      wa_final-bschl = bseg-bschl.

      SELECT SINGLE * FROM vbrk WHERE vbeln = bkpf-xblnr.
      IF sy-subrc = 0.
        wa_final-dctyp = 'Invoice'.
        wa_final-vbeln = vbrk-vbeln.
      ELSE.
        CASE bseg-bschl.
          WHEN '12'.
            wa_final-dctyp = 'Credit Note'.
          WHEN '01' OR '04'.
            wa_final-dctyp = 'Debit Note'.
        ENDCASE.
      ENDIF.

      APPEND wa_final TO it_final.
    ENDLOOP.
  ENDLOOP.
ENDFORM. " GET_DATA
*  &---------------------------------------------------------------------*
*  &      Form  FIELDCAT
*  &---------------------------------------------------------------------*
*         text
*  ----------------------------------------------------------------------*
*    -->  p1        text
*    <--  p2        text
*  ----------------------------------------------------------------------*
FORM build_fieldcat .

  REFRESH it_fieldcat .
  PERFORM fill_field_catalog USING :

      'ICACT'  space   space  space  'X'   space space 'Action' ,
      'DCTYP'  space   space  space  space space space 'Billing Type',
*      'KSCHL' 'DNAST'  'KSCHL' space  space space space space ,
      'BUKRS' 'BKPF'  'BUKRS' space  space space space space ,
      'BELNR' 'BKPF'  'BELNR'  'X'    space space space space ,
      'GJAHR' 'BKPF'  'GJAHR' space  space space space space ,
      'BUDAT' 'BKPF'  'BUDAT' space  space space space space ,
      'BLDAT' 'BKPF'  'BLDAT' space  space space space space ,
      'XBLNR' 'BKPF'  'XBLNR' space  space space space space ,
      'WRBTR' 'BSEG'  'WRBTR' space  space space space space ,
      'WAERS' 'BKPF'  'WAERS' space  space space space space ,
      'VBELN' 'VBRK'  'VBELN'  'X'    space space space space ,
      'KUNNR' 'BSEG'  'KUNNR' space  space space space space .
ENDFORM. " FIELDCAT

*  &---------------------------------------------------------------------*
*  &      Form  FILL_FIELD_CATALOG
*  &----------------------------------------------------------------------*
*  &-->P_0355   text*-->P_0356   text*-->P_0357   text*->P_0358   text*-->
*  &P_SPACE  text*-->P_SPACE  text*-->P_SPACE  text
*  &----------------------------------------------------------------------*
FORM fill_field_catalog USING value(p_field)
                               value(p_rtab)
                               value(p_rfield)
                               value(p_hotp)
                               value(p_icon)
                               value(p_no_out)
                               value(p_edit)
                               value(p_ftext).

  ADD 1 TO col_pos .
  wa_fieldcat-col_pos       = col_pos.
  wa_fieldcat-fieldname     = p_field.
  wa_fieldcat-ref_fieldname = p_rfield.
  wa_fieldcat-ref_tabname   = p_rtab.
  wa_fieldcat-seltext_m     = p_ftext.
  wa_fieldcat-hotspot       = p_hotp.
  wa_fieldcat-no_out        = p_no_out.
  wa_fieldcat-icon          = p_icon.
  wa_fieldcat-edit         = p_edit.
  APPEND wa_fieldcat TO it_fieldcat.
ENDFORM. " FILL_FIELD_CATALOG
*  &---------------------------------------------------------------------*
*  &      Form  DISPLAY_DATA
*  &---------------------------------------------------------------------*
*         text
*  ----------------------------------------------------------------------*
*    -->  p1        text
*    <--  p2        text
*  ----------------------------------------------------------------------*
FORM display_list .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
*       I_INTERFACE_CHECK                 = ' '
*       I_BYPASSING_BUFFER                = ' '
*       I_BUFFER_ACTIVE                   = ' '
     i_callback_program                = sy-cprog
     i_callback_pf_status_set          = 'SET_PF_STATUS'
     i_callback_user_command           = 'USER_COMMAND'
     i_callback_top_of_page            = 'LIST'
*       I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*       I_CALLBACK_HTML_END_OF_LIST       = ' '
*       I_STRUCTURE_NAME                  =
*       I_BACKGROUND_ID                   = ' '
*       I_GRID_TITLE                      =
*       I_GRID_SETTINGS                   =
     is_layout                         = wa_layout
     it_fieldcat                       = it_fieldcat
*       IT_EXCLUDING                      =
*       it_special_groups                 =
       it_sort                           = it_sort
*       IT_FILTER                         =
*       IS_SEL_HIDE                       =
       i_default                         = 'X'
       i_save                            = 'X'
       is_variant                        = g_variant
*       IT_EVENTS                         =
*       IT_EVENT_EXIT                     =
*       IS_PRINT                          =
*       IS_REPREP_ID                      =
*       I_SCREEN_START_COLUMN             = 0
*       I_SCREEN_START_LINE               = 0
*       I_SCREEN_END_COLUMN               = 0
*       I_SCREEN_END_LINE                 = 0
*       I_HTML_HEIGHT_TOP                 = 0
*       I_HTML_HEIGHT_END                 = 0
*       IT_ALV_GRAPHICS                   =
*       IT_HYPERLINK                      =
*       IT_ADD_FIELDCAT                   =
*       IT_EXCEPT_QINFO                   =
*       IR_SALV_FULLSCREEN_ADAPTER        =
*     IMPORTING
*       E_EXIT_CAUSED_BY_CALLER           =
*       ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab                          = it_final
*     EXCEPTIONS
*       PROGRAM_ERROR                     = 1
*       OTHERS                            = 2
            .
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*           WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM. " DISPLAY_DATA

*&---------------------------------------------------------------------*
*&      Form  set_pf_status
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->RT_EXTAB   text
*----------------------------------------------------------------------*
FORM set_pf_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS status EXCLUDING rt_extab.
ENDFORM. "set_pf_status

*  &---------------------------------------------------------------------*
*  &      Form  list
*  &---------------------------------------------------------------------*
*         text
*  ----------------------------------------------------------------------*
FORM list .

  DATA : date1(12),
         date2(12).

  wa_listhead-typ = 'H'.
  wa_listhead-info = 'Invoice Register'.
  APPEND wa_listhead TO it_listhead.
  CLEAR wa_listhead.

  wa_listhead-typ = 'S'.

  WRITE so_budat-low USING EDIT MASK '__/__/____' TO date1.
  WRITE so_budat-high USING EDIT MASK '__/__/____' TO date2.
  wa_listhead-key = 'Posting Date '.
  CONCATENATE ':' date1 'to' date2 INTO wa_listhead-info SEPARATED BY space.
  APPEND wa_listhead TO it_listhead.
  CLEAR wa_listhead.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_listhead
      i_logo             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .
  CLEAR it_listhead.
ENDFORM. " LIST




*  &---------------------------------------------------------------------*
*  &      Form  EVENT
*  &---------------------------------------------------------------------*
*         text
*  ----------------------------------------------------------------------*
*    -->  p1        text
*    <--  p2        text
*  ----------------------------------------------------------------------*

FORM user_command USING p_ucomm TYPE sy-ucomm
                          rs_selfield TYPE slis_selfield .

  CASE p_ucomm .
    WHEN '&IC1'.    """" when clicked on particular button
      CASE rs_selfield-fieldname.
        WHEN 'VBELN'.
          READ TABLE it_final INTO wa_final INDEX rs_selfield-tabindex.
          SET PARAMETER ID 'VF' FIELD  wa_final-vbeln.
          CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
        WHEN 'BELNR'.
          READ TABLE it_final INTO wa_final INDEX rs_selfield-tabindex.
          SET PARAMETER ID 'BLN' FIELD  wa_final-belnr.
          SET PARAMETER ID 'BUK' FIELD  wa_final-bukrs.
          SET PARAMETER ID 'GJR' FIELD  wa_final-gjahr.
          CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
        WHEN 'ICACT'.
          READ TABLE it_final INTO wa_final INDEX   rs_selfield-tabindex.
          IF wa_final-icact = icon_change.
            wa_final-icact = icon_system_undo.
          ELSE.
            wa_final-icact = icon_system_undo.
            wa_final-icact = icon_change.
          ENDIF.
          MODIFY it_final FROM wa_final INDEX rs_selfield-tabindex.
          PERFORM display_alv_list.
      ENDCASE.
    WHEN 'ASAL'.   """" when select all button is trigger
      REFRESH it_final_tmp .
      it_final_tmp[] = it_final[].

      LOOP AT it_final INTO wa_final.
        IF wa_final-icact = icon_change.
          wa_final-icact = icon_system_undo.
        ENDIF.
        MODIFY it_final FROM wa_final INDEX sy-tabix.
      ENDLOOP.
      PERFORM display_alv_list.

    WHEN 'DSAL'.   """" when select all button is trigger
      REFRESH it_final_tmp .
      it_final_tmp[] = it_final[].

      LOOP AT it_final INTO wa_final.
        IF wa_final-icact = icon_system_undo.
          wa_final-icact = icon_change.
        ENDIF.
        MODIFY it_final FROM wa_final INDEX sy-tabix.
      ENDLOOP.
      PERFORM display_alv_list.
*********************,Take print of invoice ************* Created by Ankit Kumar
    WHEN '&PR' .   "
      CASE so_kschl.
        WHEN 'RD00'.
          formname = 'ZSD_INV_TNM'.
          PERFORM call_form_inv.
        WHEN 'RD01'.
          formname = 'ZSD_INV_FXD'.
          PERFORM call_form_inv.
        WHEN 'RD02'.
          formname = 'ZSD_INV_UKF'.
          PERFORM call_form_inv.
        WHEN 'RD03'.
          formname = 'ZSD_INV_TM2'.
          PERFORM call_form_inv.
        WHEN 'RD04'.
          formname = 'ZSD_INV_DCR'.
          PERFORM call_form_inv.
      ENDCASE.

  ENDCASE .
ENDFORM. "user_command
*  &---------------------------------------------------------------------*
*  &      Form  DISPLAY_ALV_LIST
*  &---------------------------------------------------------------------*
*         text
*  ----------------------------------------------------------------------*
*    -->  p1        text
*    <--  p2        text
*  ----------------------------------------------------------------------*
FORM display_alv_list .


  PERFORM build_layout.
  PERFORM build_fieldcat.
  PERFORM display_list.



ENDFORM. " DISPLAY_ALV_LIST
*  &---------------------------------------------------------------------*
*  &      Form  BUILD_LAYOUT
*  &---------------------------------------------------------------------*
*         text
*  ----------------------------------------------------------------------*
*    -->  p1        text
*    <--  p2        text
*  ----------------------------------------------------------------------*
FORM build_layout .


  gd_layout-no_input          = 'X'.
  gd_layout-colwidth_optimize = 'X'.
  IF sy-uname = 'SAP-FI' OR
     sy-uname = 'SAP-HR' OR
     sy-uname = 'SAP-MM' OR
     sy-uname = 'SAP-PS' OR
     sy-uname = 'SAP-SD' OR
     sy-uname = 'SAP-ABAP-1'.
    sy-uname = 'HRUSR02'.
    sy-uname = 'SAP-ABAP'.
  ELSE.
    wa_exclude-fcode = '&AVE'.
    APPEND wa_exclude TO it_exclude.
  ENDIF.




ENDFORM. " BUILD_LAYOUT

*&---------------------------------------------------------------------*
*&      Form  f4_help_variant
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f4_help_variant .
  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant = g_variant
      i_save     = g_save
    IMPORTING
      e_exit     = g_exit
      es_variant = gx_variant
    EXCEPTIONS
      not_found  = 2.

  IF sy-subrc = 2.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM. " F4_HELP_VARIANT

*&---------------------------------------------------------------------*
*&      Form  pai_of_selection_screen
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM pai_of_selection_screen .
  MOVE g_variant TO gx_variant.
  CALL FUNCTION 'REUSE_ALV_VARIANT_EXISTENCE'
    EXPORTING
      i_save     = g_save
    CHANGING
      cs_variant = gx_variant.
  g_variant = gx_variant.
ENDFORM. " PAI_OF_SELECTION_SCREEN

*&---------------------------------------------------------------------*
*&      Form  CALL_FORM_DCR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM call_form_dcr .
  break igt-ankit.
  DATA bseg_tab1 TYPE STANDARD TABLE OF bseg.
  DATA bseg_tab TYPE STANDARD TABLE OF bseg.
  CLEAR:bkpf.

  SELECT SINGLE *
  FROM bkpf
  WHERE belnr = wa_final-belnr
  AND   bukrs = wa_final-bukrs
  AND   gjahr = wa_final-gjahr.

  SELECT *
  INTO TABLE bseg_tab1
  FROM bseg
  WHERE belnr = wa_final-belnr
  AND   bukrs = wa_final-bukrs
  AND   gjahr = wa_final-gjahr.

  CLEAR bseg.
  READ TABLE bseg_tab1 INTO bseg WITH KEY koart = 'D'.
  IF sy-subrc = 0.
    APPEND bseg TO bseg_tab.
  ENDIF.

  CLEAR bseg.

  LOOP AT bseg_tab1 INTO bseg WHERE hkont = '0010540540' OR   hkont = '0010540560'.
    APPEND bseg TO bseg_tab.
  ENDLOOP.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = formname
*     variant            = ' '
*     direct_call        = ' '
    IMPORTING
      fm_name            = lf_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  CALL FUNCTION lf_fm_name
    EXPORTING
*   ARCHIVE_INDEX              =
*   ARCHIVE_INDEX_TAB          =
*   ARCHIVE_PARAMETERS         =
*   CONTROL_PARAMETERS         =
*   MAIL_APPL_OBJ              =
*   MAIL_RECIPIENT             =
*   MAIL_SENDER                =
*   OUTPUT_OPTIONS             =
*   USER_SETTINGS              = 'X'
      wa_bkpf                    = bkpf
* IMPORTING
*   DOCUMENT_OUTPUT_INFO       =
*   JOB_OUTPUT_INFO            =
*   JOB_OUTPUT_OPTIONS         =
    TABLES
      it_bseg                    = bseg_tab
* EXCEPTIONS
*   FORMATTING_ERROR           = 1
*   INTERNAL_ERROR             = 2
*   SEND_ERROR                 = 3
*   USER_CANCELED              = 4
*   OTHERS                     = 5
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM. " CALL_FORM_DCR


*&---------------------------------------------------------------------*
*&      Form  CALL_FORM_INV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM call_form_inv .
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = formname
*     variant            = ' '
*     direct_call        = ' '
    IMPORTING
      fm_name            = lf_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  CALL FUNCTION lf_fm_name      ":""'/1BCDWB/SF00000027'
         EXPORTING
*   ARCHIVE_INDEX              =
*   ARCHIVE_INDEX_TAB          =
*   ARCHIVE_PARAMETERS         =
*   CONTROL_PARAMETERS         =
*   MAIL_APPL_OBJ              =
*   MAIL_RECIPIENT             =
*   MAIL_SENDER                =
*   OUTPUT_OPTIONS             =
*   USER_SETTINGS              = 'X'
           l_vbeln                    = wa_final-vbeln
           l_for_m                    = for_m
* IMPORTING
*   DOCUMENT_OUTPUT_INFO       =
*   JOB_OUTPUT_INFO            =
*   JOB_OUTPUT_OPTIONS         =
* EXCEPTIONS
*   FORMATTING_ERROR           = 1
*   INTERNAL_ERROR             = 2
*   SEND_ERROR                 = 3
*   USER_CANCELED              = 4
*   OTHERS                     = 5
                 .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM. " CALL_FORM_INV
