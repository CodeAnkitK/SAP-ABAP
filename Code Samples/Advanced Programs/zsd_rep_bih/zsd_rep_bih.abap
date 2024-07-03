REPORT zsd_rep_bih.

TYPE-POOLS: slis,abap.
TABLES: vbap,vbak,vbfa,vbrk,vbrp,bkpf,bseg,bsid,bsad,prps,kna1,proj.

TYPES: BEGIN OF ty_final,
        vbelv TYPE vbelv,
        vbeln TYPE vbeln,
        bukrs TYPE bukrs,
        kunnr TYPE kunag,
        name1 TYPE name1_gp,
        parnr TYPE parnr,
        belnr TYPE belnr,
        fkdat TYPE fkdat,
        xblnr TYPE xblnr1,
        blart TYPE blart,
        waers TYPE waers,
        wrbtr TYPE wrbtr,
        dmbtr TYPE dmbtr,
        dmbe2 TYPE dmbe2,
        monat TYPE monat,
        budat TYPE budat,
        bldat TYPE bldat,
        sownm TYPE tdline,
        sowdi TYPE tdline,
        projm TYPE tdline,
        acman TYPE emnam,
        bstkd TYPE bstkd,
        pspnr TYPE ps_pspid,
        psptx TYPE ps_post1,
        posnr TYPE ps_psp_pnr,
        postx TYPE ps_post1,
        gjahr TYPE gjahr,
        gsber TYPE gsber,
        saknr TYPE saknr,
        umskz TYPE umskz,
        txt50 TYPE txt50,
       END OF ty_final.

TYPES: BEGIN OF ty_bseg,
          mandt TYPE  bseg-mandt,
          kunnr TYPE  bseg-kunnr,
          belnr TYPE  bseg-belnr,
          vbeln TYPE  bseg-vbeln,
          bukrs TYPE  bseg-bukrs,
          dmbtr TYPE  bseg-dmbtr,
          dmbe2 TYPE  bseg-dmbe2,
          gsber TYPE  bseg-gsber,
          gjahr TYPE  bseg-gjahr,
          umskz TYPE  bseg-umskz,
          wrbtr TYPE  bseg-wrbtr,
          saknr TYPE  bseg-saknr,
          buzei TYPE  bseg-buzei,
       END OF ty_bseg.


DATA it_final TYPE STANDARD TABLE OF ty_final.
DATA wa_final TYPE ty_final.


DATA: it_vbap TYPE STANDARD TABLE OF vbap WITH HEADER LINE,
      it_vbak TYPE STANDARD TABLE OF vbak WITH HEADER LINE,
      it_vbfa TYPE STANDARD TABLE OF vbfa WITH HEADER LINE,
      it_vbrk TYPE STANDARD TABLE OF vbrk WITH HEADER LINE,
      it_vbrp TYPE STANDARD TABLE OF vbrp WITH HEADER LINE,
      it_bkpf TYPE STANDARD TABLE OF bkpf WITH HEADER LINE,
      it_bseg TYPE STANDARD TABLE OF ty_bseg WITH HEADER LINE,
      it_bsid TYPE STANDARD TABLE OF bsid WITH HEADER LINE,
      it_bsad TYPE STANDARD TABLE OF bsad WITH HEADER LINE,
      it_skat TYPE STANDARD TABLE OF skat WITH HEADER LINE,
      it_prps TYPE STANDARD TABLE OF prps WITH HEADER LINE,

      wa_vbap TYPE vbap,
      wa_vbak TYPE vbak,
      wa_vbfa TYPE vbfa,
      wa_vbrk TYPE vbrk,
      wa_vbrp TYPE vbrp,
      wa_bkpf TYPE bkpf,
      wa_bsad TYPE bsad,
      wa_bsid TYPE bsid,
      wa_bseg TYPE ty_bseg,
      wa_skat TYPE skat,
      wa_prps TYPE prps.

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
RANGES ra_vbeln FOR vbak-vbeln.

DATA txtid TYPE thead-tdid.
DATA txtnm TYPE thead-tdname.
DATA txtob TYPE thead-tdobject.
DATA tline TYPE STANDARD TABLE OF tline WITH HEADER LINE.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-000.

SELECT-OPTIONS so_bukrs FOR bkpf-bukrs.
SELECT-OPTIONS so_fkdat FOR vbrk-fkdat .
SELECT-OPTIONS so_vbeln FOR vbrk-vbeln.
SELECT-OPTIONS so_kunnr FOR vbrk-kunag.
*SELECT-OPTIONS  so_posid  FOR prps-posid.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.

START-OF-SELECTION.

  PERFORM get_it_vbrk.
  PERFORM get_it_vbrp.
  PERFORM get_it_vbfa.
  PERFORM get_it_vbak.
*  PERFORM get_it_vbap.
  PERFORM get_it_bkpf.
  PERFORM get_it_bseg.
  PERFORM get_it_prps.
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
FORM get_it_final.
  REFRESH it_final.
  CLEAR:  wa_vbrk,wa_vbfa, wa_bkpf, wa_bseg,wa_vbrp.
  LOOP AT it_vbrk INTO wa_vbrk.
    wa_final-fkdat = wa_vbrk-fkdat.
    wa_final-kunnr = wa_vbrk-kunag.
    wa_final-bukrs = wa_vbrk-bukrs.
    wa_final-vbeln = wa_vbfa-vbeln.

    LOOP AT it_vbrp INTO wa_vbrp WHERE vbeln = wa_vbrk-vbeln.
      CLEAR:kna1,prps,proj.
      SELECT SINGLE * FROM kna1 WHERE kunnr = wa_vbrk-kunag.
      SELECT SINGLE * FROM prps WHERE pspnr = wa_vbrp-ps_psp_pnr.
      SELECT SINGLE * FROM proj WHERE pspnr = prps-psphi.

      wa_final-pspnr = proj-pspnr.
      wa_final-psptx = proj-post1.
      wa_final-posnr = vbrp-ps_psp_pnr.
      wa_final-postx = prps-post1.

      LOOP AT it_vbfa INTO wa_vbfa
                      WHERE vbeln = wa_vbrk-vbeln.
        wa_final-vbelv = wa_vbfa-vbelv.
        wa_final-waers = wa_vbfa-waers.

        LOOP AT it_bkpf INTO wa_bkpf
                        WHERE xblnr = wa_vbrk-vbeln.
          wa_final-xblnr = wa_bkpf-xblnr.
          wa_final-belnr = wa_bkpf-belnr.
          wa_final-monat = wa_bkpf-monat.
          wa_final-budat = wa_bkpf-budat.
          wa_final-bldat = wa_bkpf-bldat.
          wa_final-blart = wa_bkpf-blart.
          wa_final-gjahr = wa_bkpf-gjahr.

          LOOP AT it_bseg INTO wa_bseg
                          WHERE bukrs = wa_bkpf-bukrs
                            AND belnr = wa_bkpf-belnr
                            AND gjahr = wa_bkpf-gjahr.
            wa_final-gsber = wa_bseg-gsber.
            wa_final-dmbtr = wa_bseg-dmbtr.
            wa_final-wrbtr = wa_bseg-wrbtr.
            wa_final-dmbe2 = wa_bseg-dmbe2.
            wa_final-saknr = wa_bseg-saknr.
            wa_final-umskz = wa_bseg-umskz.
          ENDLOOP.
        ENDLOOP.
        SELECT name1
          FROM kna1
          INTO wa_final-name1
          WHERE kunnr = wa_vbrk-kunag.
        ENDSELECT.

        SELECT SINGLE bstkd
          FROM vbkd
          INTO wa_final-bstkd
          WHERE vbeln = wa_vbrk-vbeln
            AND   posnr = '000000'.

        PERFORM read_sow_name.
        PERFORM read_cus_cont.
        PERFORM read_prj_mngr.
        PERFORM read_acc_mngr.
        PERFORM get_it_skat.
        PERFORM get_it_prps.
        APPEND wa_final TO it_final.
        CLEAR wa_final.
      ENDLOOP.
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
    gd_layout-info_fieldname    = 'LINE_COLOR'.
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
  PERFORM insert_fieldcat USING:
                                'VBELN' 'Billing Doc'          space space 'VBRK'      'VBELN',
                                'VBELV' 'Sales Order'          space space 'VBRK'      'VBELN',
                                'BUKRS' 'Company code'         space space 'BSEG'      'BUKRS',
                                'KUNNR' 'Customer Code'        space space 'BSEG'      'KUNNR',
                                'NAME1' 'Customer name'        space space 'BSEG'      'NAME1',
                                'PERNR' 'Contact person'       space space  space      'PERNR',
                                'BELNR' 'Document  No'         space space 'BKPF'      'BELNR',
                                'GJAHR' 'Fiscal Year'          space space 'VBRK'      'BELNR',
                                'XBLNR' 'Inv.Ref. No'          space space 'BKPF'      'XBLNR',
                                'FKDAT' 'Invoice Date'         space space 'VBRK'      'FKDAT',
                                'BLART' 'Document Type'        space space 'BKPF'      'BLART',
                                'WAERS' 'Currency'             space space 'BKPF'      'WAERS',
                                'WRBTR' 'Invoice Amount(DC)'   space space 'BKPF'      'WRBRT',
                                'DMBTR' 'Invoice Amount(LC)'   space space 'BKPF'       'DMBTR',
                                'DMBE2' 'Invoice Amount(USD)'  space space 'BKPF'       'DMBE2',
                                'MONAT' 'Invoice Period'       space space 'BKPF'       'MONAT',
                                'BUDAT' 'Post.Date'            space space 'BKPF'      'BUDAT',
                                'BLDAT' 'Doc.Date'             space space 'BKPF'      'BLDAT',
                                'SOWNM' 'SOW Number'           space space  space     'SOWNM',
                                'SOWDI' 'SOW name'             space space  space      'SOWDI',
                                'BSTKD' 'PO No'                space space 'VBKD'      'BSTKD',
                                'ACMAN' 'Account Manager'      space space  space       space,
                                'PROJM' 'Project Manger'       space space  space       'USR03',
                                'GEOAR' 'Project Code'         space space 'PRPS'      'GEOAR',
                                'GSBER' 'Business Area'        space space  'BSEG'      'GSBER',
                                'SAKNR' 'G/L Account'          space space 'BSEG'      'SAKNR',
                                'UMSKZ' 'Special G/L ind.'     space space 'BSEG'      'UMSKZ',
                                'TXT50' 'Spl. GL Text'         space space 'SKAT'      'TXT50',
                                'PSPNR'  space                 space space 'PROJ'      'PSPNR',
                                'PSPTX' 'Project Description'  space space 'PRPS'      'POST1',
                                'POSNR'  space                 space space 'PRPS'      'PSPNR',
                                'POSTX' 'WBS Description'      space space 'PRPS'      'POST1'.
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
*&      Form  GET_IT_VBAK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_it_vbak .
  SELECT *
    FROM vbak
    INTO TABLE it_vbak
    FOR ALL ENTRIES IN it_vbfa
    WHERE vbeln = it_vbfa-vbelv
      AND kunnr IN so_kunnr
      AND bukrs_vf IN so_bukrs.
ENDFORM. " GET_IT_VBAK
*&---------------------------------------------------------------------*
*&      Form  GET_IT_VBAP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_it_vbap .
*  SELECT *
*      FROM vbap
*      INTO TABLE it_vbap
*      FOR ALL ENTRIES IN it_vbak
*      WHERE vbeln = it_vbak-vbeln.
ENDFORM. " GET_IT_VBAP
*&---------------------------------------------------------------------*
*&      Form  GET_IT_VBFA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_it_vbfa .
  IF it_vbrk[] IS NOT INITIAL.
    SELECT *
          FROM vbfa
          INTO TABLE it_vbfa
          FOR ALL ENTRIES IN it_vbrk
          WHERE vbeln = it_vbrk-vbeln
            AND vbtyp_n = 'M'
            AND vbtyp_v = 'C'.
  ENDIF.
ENDFORM. " GET_IT_VBFA
*&---------------------------------------------------------------------*
*&      Form  GET_IT_VBRK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_it_vbrk .
  SELECT *
    FROM vbrk
    INTO TABLE it_vbrk
    WHERE vbeln IN so_vbeln
      AND fkdat IN so_fkdat.
ENDFORM. " GET_IT_VBRK
*&---------------------------------------------------------------------*
*&      Form  GET_IT_VBRP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_it_vbrp .
  IF it_vbrk[] IS NOT INITIAL.
  SELECT *
    FROM vbrp
    INTO TABLE it_vbrp
  FOR ALL ENTRIES IN it_vbrk
  WHERE vbeln = it_vbrk-vbeln.
  ENDIF.
ENDFORM. " GET_IT_VBRP
*&---------------------------------------------------------------------*
*&      Form  get_it_bsad
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_it_bseg .
  CHECK  it_bkpf[] IS NOT INITIAL.
  SELECT *
    FROM bseg
    INTO CORRESPONDING FIELDS OF TABLE it_bseg
    FOR ALL ENTRIES IN it_bkpf
    WHERE belnr = it_bkpf-belnr
      AND bukrs = it_bkpf-bukrs
      AND gjahr = it_bkpf-gjahr
      AND kunnr IN so_kunnr
      AND buzei = '1'.
ENDFORM. " GET_IT_BSEG

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

  txtid = '0001'.
  txtnm = wa_vbfa-vbeln.
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


  CLEAR:txtid,txtnm,txtob,tline.
  REFRESH tline.

  txtid = '0002'.
  txtnm = wa_vbfa-vbelv .
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
  wa_final-sowdi = tline-tdline.
ENDFORM. " READ_SOW_NAME
*&---------------------------------------------------------------------*
*&      Form  GET_IT_PRPS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_it_prps .

ENDFORM. " GET_IT_PRPS
*&---------------------------------------------------------------------*
*&      Form  READ_CUS_CONT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_cus_cont .

  SELECT parnr
    FROM vbpa
    INTO wa_final-parnr
    WHERE vbeln = wa_vbfa-vbeln
      AND parvw = 'ZC'.
  ENDSELECT.

ENDFORM. " READ_CUS_CONT
*&---------------------------------------------------------------------*
*&      Form  READ_PRJ_MNGR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_prj_mngr .

  CLEAR:txtid,txtnm,txtob,tline.
  REFRESH tline.

  txtid = '0006'.
  txtnm = wa_vbfa-vbelv .
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
  wa_final-projm = tline-tdline.

ENDFORM. " READ_PRJ_MNGR
*&---------------------------------------------------------------------*
*&      Form  GET_IT_SKAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_it_skat .

  SELECT txt50
    FROM skat
    INTO wa_final-txt50
    WHERE saknr = wa_bseg-saknr.
  ENDSELECT.

ENDFORM. " GET_IT_SKAT
*&---------------------------------------------------------------------*
*&      Form  READ_ACC_MNGR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_acc_mngr .

  DATA: p_pernr LIKE prelp-pernr.
  DATA: p_name TYPE emnam.


  SELECT SINGLE pernr
  FROM vbpa
    INTO p_pernr
  WHERE vbeln = wa_vbfa-vbelv
  AND parvw = 'ZA'.

  PERFORM read_er USING p_pernr
                      CHANGING wa_final-acman.


ENDFORM. " READ_ACC_MNGR

*&---------------------------------------------------------------------*
*&      Form  read_er
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PERNR    text
*      -->P_NAME     text
*----------------------------------------------------------------------*
FORM read_er USING p_pernr CHANGING p_name.
  INFOTYPES: 0002.
  REFRESH p0002.
  CLEAR p0002.
  CALL FUNCTION 'HR_READ_INFOTYPE'
    EXPORTING
      pernr           = p_pernr
      infty           = '0002'
      begda           = sy-datum
    TABLES
      infty_tab       = p0002
    EXCEPTIONS
      infty_not_found = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  CONCATENATE p0002-vorna p0002-nachn INTO p_name SEPARATED BY space.

ENDFORM. "read_er
*&---------------------------------------------------------------------*
*&      Form  GET_IT_BKPF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_it_bkpf .
  LOOP AT it_vbfa INTO wa_vbfa.
    SELECT *
     FROM bkpf
       INTO TABLE it_bkpf
       WHERE xblnr IN so_vbeln
            AND blart = 'RV'.
  ENDLOOP.
ENDFORM. " GET_IT_BKPF