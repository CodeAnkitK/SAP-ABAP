REPORT zsd_rep_dis.
INFOTYPES: 0000,0001,0002.
TYPE-POOLS: slis,abap.
TABLES: proj, prps,kna1,vbrp,vbrk,konv,bkpf .
TYPES: BEGIN OF ty_final,
        month TYPE s003-spbup,
        vbeln TYPE vbeln,
        fkdat TYPE fkdat,
        budat TYPE budat,
        belnr TYPE belnr,
        gjahr TYPE gjahr,
        bukrs TYPE bukrs,
        pspnr TYPE ps_pspid,
        psptx TYPE ps_post1,
        posnr TYPE ps_psp_pnr,
        postx TYPE ps_post1,
        conmt TYPE netwr,
        dismt TYPE netwr,
        netwr TYPE netwr,
        kunnr TYPE kunnr,
        kunam TYPE name1,
        sownm TYPE tdline,
        usr01 TYPE usr01prps,
        usr02 TYPE usr02prps,
        usr03 TYPE usr03prps,
        waerk TYPE vbrk-waerk,
  dis TYPE konv-kwert ,   """" PENALTY DISCOUNT ADDED BY HIMANSHU
  disr TYPE konv-kbetr,     """" PENALTY DISCOUNT RATE ADDED BY HIMANSHU
  curr TYPE konv-waers ,"""""" currency key
       END OF ty_final.


DATA it_final TYPE STANDARD TABLE OF ty_final.
DATA wa_final TYPE ty_final.

DATA it_vbrk TYPE STANDARD TABLE OF vbrk WITH HEADER LINE.
DATA it_vbrp TYPE STANDARD TABLE OF vbrp WITH HEADER LINE.
DATA it_konv TYPE STANDARD TABLE OF konv WITH HEADER LINE.
DATA it_bkpf TYPE STANDARD TABLE OF bkpf WITH HEADER LINE .
DATA it_bseg TYPE STANDARD TABLE OF bseg WITH HEADER LINE.



DATA it_fieldcat TYPE slis_t_fieldcat_alv.
DATA it_exclude TYPE slis_t_extab.

DATA wa_exclude TYPE slis_extab.
DATA gd_layout TYPE slis_layout_alv.
DATA wa_fieldcat TYPE slis_fieldcat_alv.

DATA g_save TYPE c.
DATA g_exit TYPE c.
DATA g_variant LIKE disvariant.
DATA gx_variant LIKE disvariant.
DATA idx TYPE sy-tabix.

DATA p_posid TYPE ps_posid.
DATA p_posnr TYPE ps_posnr.
DATA col_pos TYPE i.
DATA gv_repid TYPE sy-repid.
RANGES ra_pspnr FOR prps-pspnr.

DATA txtid TYPE thead-tdid.
DATA txtnm TYPE thead-tdname.
DATA txtob TYPE thead-tdobject.
DATA tline TYPE STANDARD TABLE OF tline WITH HEADER LINE.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-000.
SELECT-OPTIONS so_fkdat FOR vbrk-fkdat.
SELECT-OPTIONS so_vbeln FOR vbrk-vbeln.
*SELECT-OPTIONS  so_budat  FOR bkpf-budat.
SELECT-OPTIONS so_posid FOR prps-posid.
SELECT-OPTIONS so_kunnr FOR vbrk-kunag.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-002.
PARAMETERS: p_vari LIKE disvariant-variant.
SELECTION-SCREEN END OF BLOCK b3.

AT SELECTION-SCREEN.
  PERFORM pai_of_selection_screen.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vari.
  PERFORM f4_help_variant.


INITIALIZATION.
  gv_repid = sy-repid.
  PERFORM initialize_variant.

START-OF-SELECTION.
  PERFORM get_ra_pspnr.
  PERFORM get_it_vbrk.
  PERFORM get_it_vbrp.
  PERFORM get_it_bseg.
  PERFORM get_it_konv.
  PERFORM get_it_final.

END-OF-SELECTION.
  PERFORM display_alv_list.





*&---------------------------------------------------------------------*
*&      Form  GET_IT_FINAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_it_final .
  LOOP AT it_vbrk INTO vbrk.
    LOOP AT it_vbrp INTO vbrp WHERE vbeln = vbrk-vbeln.
      CLEAR:wa_final,kna1,prps,proj.
      SELECT SINGLE * FROM kna1 WHERE kunnr = vbrk-kunag.
      SELECT SINGLE * FROM prps WHERE pspnr = vbrp-ps_psp_pnr.
      SELECT SINGLE * FROM proj WHERE pspnr = prps-psphi.

      SELECT SINGLE budat
      INTO wa_final-budat
      FROM bkpf
      WHERE xblnr = vbrk-vbeln.

      PERFORM read_sow_name.

      wa_final-vbeln = vbrk-vbeln.
      wa_final-fkdat = vbrk-fkdat.
      wa_final-pspnr = proj-pspnr.
      wa_final-psptx = proj-post1.
      wa_final-posnr = vbrp-ps_psp_pnr.
      wa_final-postx = prps-post1.

      wa_final-usr01 = prps-usr01.
      wa_final-usr02 = prps-usr02.
      wa_final-usr03 = prps-usr03.

      wa_final-netwr = vbrp-netwr.

      READ TABLE it_konv INTO konv WITH KEY knumv =  vbrk-knumv
                                            kposn = vbrp-posnr
                                            kschl = 'ZDSF'.
      IF sy-subrc = 0.
        wa_final-dismt = konv-kwert.
      ENDIF.

*************      Added by himanshu on 08.11.2012 on satyapal request /_*******************
BREAK SAP-ABAP-1 .
      READ TABLE it_konv INTO konv WITH KEY knumv =  vbrk-knumv
                                         kposn = vbrp-posnr
                                         kschl = 'ZDIS'.
      IF sy-subrc = 0.
        wa_final-dis = konv-kwert.
        wa_final-disr = konv-kbetr.
        wa_final-curr = konv-waers.
      ENDIF.
************************************************************************************************





      wa_final-kunnr = vbrk-kunag.
      wa_final-kunam = kna1-name1.
      wa_final-waerk = vbrk-waerk.

      COLLECT wa_final INTO it_final.
    ENDLOOP.
  ENDLOOP.
ENDFORM. " GET_IT_FINAL





*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_alv_list .
  PERFORM build_layout.
  PERFORM build_fieldcat.
  PERFORM display_list.
ENDFORM. " DISPLAY_ALV_LIST


*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_layout .
  gd_layout-no_input          = 'X'.
  gd_layout-colwidth_optimize = 'X'.
  IF sy-uname <> 'SAP-FI' OR
     sy-uname <> 'SAP-HR' OR
     sy-uname <> 'SAP-MM' OR
     sy-uname <> 'SAP-PS' OR
     sy-uname <> 'SAP-SD' OR
     sy-uname <> 'SAP-ABAP' OR
     sy-uname <> 'SAP-ABAP-1'.
    wa_exclude-fcode = '&AVE'.
    APPEND wa_exclude TO it_exclude.
  ENDIF.
ENDFORM. " BUILD_LAYOUT

*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fieldcat .
  PERFORM insert_fieldcat USING:'VBELN'  space                 'X'   space 'VBRK'      'VBELN',
                                'FKDAT'  space                 space space 'VBRK'      'FKDAT',
                                'BUDAT'  space                 space space 'BKPF'      'BUDAT',
                                'PSPNR'  space                 space space 'PROJ'      'PSPNR',
                                'PSPTX' 'Project Description'  space space 'PRPS'      'POST1',
                                'POSNR'  space                 space space 'PRPS'      'PSPNR',
                                'POSTX' 'WBS Description'      space space 'PRPS'      'POST1',
                                'SOWNM' 'SOW Name'             space space  space       space,
                                'CONMT' 'Confirm Amt.'         space space  space       space,
                                'DISMT' 'Discount(ZDSF)'             space space  space       space,
                                'DIS' 'Penalty Discount(ZDIS)'             space space  space       space,
                                'CURR' 'Unit'             space space  space       space,
*                                'DISR' 'Penalty Dis. Rate'             space space  space       space,
                                'NETWR'  space                 space space 'VBRP'      'NETWR',
                                'WAERK'  space                 space space 'VBRK'      'WAERK',
                                'KUNNR'  space                 space space 'KNA1'      'KUNNR',
                                'KUNAM' 'Customer Name'        space space  space       space,
                                'USR01'  space                 space space 'PRPS'      'USR01',
                                'USR02'  space                 space space 'PRPS'      'USR02',
                                'USR03'  space                 space space 'PRPS'      'USR03',
                                'GEOAR'  space                 space space 'PRPS'      'GEOAR',
                                'SERLN'  space                 space space 'PRPS'      'SERLN'.
ENDFORM. " BUILD_FIELDCAT

*&---------------------------------------------------------------------*
*&      Form  insert_fieldcat
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->VALUE(P_FIELD)  text
*      -->VALUE(P_FNAME)  text
*      -->P_HOTP          text
*      -->P_NO_OUT        text
*----------------------------------------------------------------------*
FORM insert_fieldcat USING value(p_field)
                               value(p_fname)
                               p_hotp
                               p_no_out
                               p_rtab
                               p_rfield.
  ADD 1 TO col_pos.
  wa_fieldcat-col_pos     = col_pos.
  wa_fieldcat-fieldname   = p_field.
  wa_fieldcat-seltext_m   = p_fname.
  wa_fieldcat-hotspot     = p_hotp.
  wa_fieldcat-no_out      = p_no_out.
  wa_fieldcat-ref_fieldname = p_rfield.
  wa_fieldcat-ref_tabname   = p_rtab.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR  wa_fieldcat.

ENDFORM. " INSERT_FIELDCAT


*&---------------------------------------------------------------------*
*&      Form  DISPLAY_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_list .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
    i_callback_program                = gv_repid
*   I_CALLBACK_PF_STATUS_SET          = ' '
    i_callback_user_command           = 'USER_COMMAND'
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
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
    i_default                         = 'X'
    i_save                            = 'A'
    is_variant                       = g_variant
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab                        = it_final
   EXCEPTIONS
     program_error                    = 1
     OTHERS                           = 2
            .
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM. " DISPLAY_LIST

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
  ELSE.
    IF g_exit = space.
      p_vari = gx_variant-variant.
    ENDIF.
  ENDIF.
ENDFORM. " F4_HELP_VARIANT

*&---------------------------------------------------------------------*
*&      Form  pai_of_selection_screen
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM pai_of_selection_screen .
  IF NOT p_vari IS INITIAL.
    MOVE g_variant TO gx_variant.
    MOVE p_vari TO gx_variant-variant.
    CALL FUNCTION 'REUSE_ALV_VARIANT_EXISTENCE'
      EXPORTING
        i_save     = g_save
      CHANGING
        cs_variant = gx_variant.
    g_variant = gx_variant.
  ELSE.
    PERFORM initialize_variant.
  ENDIF.
ENDFORM. " PAI_OF_SELECTION_SCREEN

*&---------------------------------------------------------------------*
*&      Form  initialize_variant
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM initialize_variant .
  g_save = 'A'.
  gv_repid =  sy-repid.
  CLEAR g_variant.
  g_variant-report = gv_repid.
  gx_variant = g_variant.
  CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'
    EXPORTING
      i_save     = g_save
    CHANGING
      cs_variant = gx_variant
    EXCEPTIONS
      not_found  = 2.
  IF sy-subrc = 0.
    p_vari = gx_variant-variant.
  ENDIF.
ENDFORM. " INITIALIZE_VARIANT

*&---------------------------------------------------------------------*
*&      Form  GET_IT_VBAK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_it_vbrk .
  SELECT * FROM vbrk
  INTO TABLE it_vbrk
  WHERE erdat IN so_fkdat
  AND   vbeln IN so_vbeln
  AND   kunag IN so_kunnr.






ENDFORM. " GET_IT_VBAK


*&---------------------------------------------------------------------*
*&      Form  GET_IT_VBAP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_it_vbrp .
  IF it_vbrk[] IS NOT INITIAL.
    SELECT * FROM vbrp
    INTO TABLE it_vbrp
    FOR ALL ENTRIES IN it_vbrk
    WHERE ps_psp_pnr IN ra_pspnr
    AND   vbeln = it_vbrk-vbeln.
  ENDIF.
ENDFORM. " GET_IT_VBAP


*&---------------------------------------------------------------------*
*&      Form  READ_SOW_NAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_sow_name .
  CLEAR:txtid,txtnm,txtob,tline.
  REFRESH tline.

  txtid = '0002'.
  txtnm = vbrk-vbeln.
  txtob = 'VBBK'.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = txtid
      language                = sy-langu
      name                    = txtnm
      object                  = txtob
    TABLES
      lines                   = tline
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  READ TABLE tline INDEX 1.
  wa_final-sownm = tline-tdline.

ENDFORM. " READ_SOW_NAME


*&---------------------------------------------------------------------*
*&      Form  GET_IT_KONV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_it_konv .
  SELECT *
  FROM konv
  INTO TABLE it_konv
  FOR ALL ENTRIES IN it_vbrk
  WHERE knumv = it_vbrk-knumv.
ENDFORM. " GET_IT_KONV


*&---------------------------------------------------------------------*
*&      Form  GET_RA_PSPNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_ra_pspnr .
  IF NOT so_posid IS INITIAL.
    SELECT * FROM prps WHERE posid IN so_posid.
      ra_pspnr-sign = 'I'.
      ra_pspnr-option = 'EQ'.
      ra_pspnr-low = prps-pspnr.
      APPEND ra_pspnr.
      CLEAR ra_pspnr.
    ENDSELECT.
  ENDIF.
ENDFORM. " GET_RA_PSPNR


*&---------------------------------------------------------------------*
*&      Form  GET_IT_BSEG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_it_bseg .

*  REFRESH it_bkpf.
*  SELECT *
*  INTO TABLE it_bkpf
*  FROM bkpf
*  WHERE xblnr IN so_vbeln
*  AND   budat IN so_budat.
*
*  CHECK  it_bkpf[] IS NOT INITIAL.
*
*  SELECT *
*  INTO TABLE it_bseg
*  FROM bseg
*  FOR ALL ENTRIES IN it_bkpf
*  WHERE belnr = it_bkpf-belnr
*  AND   gjahr = it_bkpf-gjahr
*  AND   bukrs = it_bkpf-bukrs
*  AND   kunnr IN so_kunnr
*  AND   projk IN so_posid.
ENDFORM. " GET_IT_BSEG


*&---------------------------------------------------------------------*
*&      Form  user_command
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_UCOMM       text
*      -->RS_SELFIELED  text
*----------------------------------------------------------------------*
FORM user_command USING p_ucomm TYPE sy-ucomm
                        rs_selfield TYPE slis_selfield.
  CASE p_ucomm.
    WHEN '&IC1'.
      IF rs_selfield-sel_tab_field = '1-VBELN'.
        READ TABLE it_final INTO wa_final INDEX rs_selfield-tabindex.
        IF sy-subrc = 0.
          SET PARAMETER ID 'VF' FIELD wa_final-vbeln.
          CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
        ENDIF.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.
ENDFORM. "user_command
