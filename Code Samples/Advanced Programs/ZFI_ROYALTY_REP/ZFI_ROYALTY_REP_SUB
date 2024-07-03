*&---------------------------------------------------------------------*
*& Include          ZFI_ROYALTY_REP_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  PERFORM get_exchange_rate USING p_poper CHANGING ex_rate.
  SELECT rldnr
       rbukrs
       gjahr
       belnr
       vkorg
       vtweg
       kmland_pa
       werks
       matnr
       prctr
       msl
       wsl
       rwcur
       poper
  FROM acdoca
  INTO TABLE gt_acdoca
  WHERE rbukrs IN s_bukrs
    AND poper  EQ p_poper
    AND ryear  EQ p_ryear
    AND matnr  IN s_matnr
    AND racct  IN s_racct
    AND rldnr  EQ gc_0l.

  IF p_xyd EQ 'X'.
    PERFORM get_data_xyd.
  ELSEIF p_zev EQ 'X'.
    PERFORM get_data_zev.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display .
  PERFORM alv_fcat.
  PERFORM alv_options.
  IF p_xyd EQ 'X'.
    PERFORM alv USING gt_xydalba.
  ELSEIF p_zev EQ 'X'.
    PERFORM alv USING gt_zevtera.
  ENDIF.
ENDFORM.
FORM build_catalog USING VALUE(fieldname)
                         VALUE(ref_tabname)
                         VALUE(ref_fieldname)
                         VALUE(seltext_m).
  col = col + 1.
  gwa_fieldcatalog-col_pos        = col.
  gwa_fieldcatalog-fieldname      = fieldname.
  gwa_fieldcatalog-ref_tabname    = ref_tabname.
  gwa_fieldcatalog-ref_fieldname  = ref_fieldname.
  gwa_fieldcatalog-seltext_m      = seltext_m.

  APPEND gwa_fieldcatalog TO gt_fieldcatalog.
  CLEAR gwa_fieldcatalog.
ENDFORM.
FORM alv_options.
  is_layout-colwidth_optimize = 'X'.
  gv_repid = sy-repid.
ENDFORM.
FORM alv USING table TYPE STANDARD TABLE.
*  PF-Status: SAPLSALV - Standard
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = gv_repid
      i_callback_pf_status_set = gc_pf_status
      i_callback_user_command  = gc_ucommand
      is_layout                = is_layout
      it_fieldcat              = gt_fieldcatalog
    TABLES
      t_outtab                 = table
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
* RAISE program_error.
  ENDIF.
ENDFORM.
FORM get_exchange_rate USING gv_postings CHANGING ex_rate.
  DATA: lgt_tcurr TYPE STANDARD TABLE OF tcurr.
  DATA: lgw_tcurr TYPE tcurr.
  DATA: lvs_date(10) TYPE c.
  DATA: lve_date(10) TYPE c.
  DATA: g_sp(02) TYPE c VALUE '00'.
  DATA: g_ep(02) TYPE c VALUE '00'.
  DATA: count TYPE n VALUE 0.

  IF p_poper BETWEEN gc_qb1 AND gc_qe1.
    g_sp = gc_qb1.
*    g_ep = gc_qe1.
  ENDIF.
  IF p_poper BETWEEN gc_qb2 AND gc_qe2.
    g_sp = gc_qb2.
*    g_ep = gc_qe2.
  ENDIF.
  IF p_poper BETWEEN gc_qb3 AND gc_qe3.
    g_sp = gc_qb3.
*    g_ep = gc_qe3.
  ENDIF.
  IF p_poper BETWEEN gc_qb4 AND gc_qe4.
    g_sp = gc_qb4.
*    g_ep = gc_qe4.
  ENDIF.

  g_ep = gv_postings+1(2).

  CLEAR count.
  DO 3 TIMES.
    count = count + 1.
    CONCATENATE: p_ryear g_ep '01'  INTO gex_date.
    PERFORM get_exchange_data USING gex_date CHANGING gw_exchange_data.
    ex_rate = ex_rate + gw_exchange_data-exch_rate.
    g_ep = g_ep - 1.
    IF g_ep LT 10.
      CONCATENATE '0' g_ep INTO g_ep.
    ENDIF.
    IF g_ep LT g_sp.
      EXIT.
    ENDIF.
  ENDDO.
  IF ex_rate GT 0.
    ex_rate = ex_rate / count.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  read_file_name
*&---------------------------------------------------------------------*
FORM read_file_name CHANGING p_filename.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = 100
      text       = 'Posting Branch JVs...'.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
    IMPORTING
      file_name     = p_filename.
ENDFORM.                    " read_file_name
*&---------------------------------------------------------------------*
*& Form get_exchange_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> DATA
*&      <-- GT_EXCHANGE_DATA
*&---------------------------------------------------------------------*
FORM get_exchange_data  USING    p_date
                        CHANGING p_gt_exchange_data.
  DATA: lv_date TYPE bapi1093_2-trans_date.
  DATA: lv_rate_type TYPE bapi1093_1-rate_type.
  DATA: lv_from_curr TYPE  bapi1093_1-from_curr.
  DATA: lv_to_currncy TYPE bapi1093_1-to_currncy.
  CLEAR p_gt_exchange_data.
  IF p_date IS NOT INITIAL.
    MOVE p_date TO lv_date.
    MOVE gc_avg TO lv_rate_type.
    MOVE gc_eur TO lv_from_curr.
    MOVE gc_usd TO lv_to_currncy.
    CALL FUNCTION 'BAPI_EXCHANGERATE_GETDETAIL'
      EXPORTING
        rate_type  = lv_rate_type
        from_curr  = lv_from_curr
        to_currncy = lv_to_currncy
        date       = lv_date
      IMPORTING
        exch_rate  = p_gt_exchange_data
        return     = p_gt_return.
  ENDIF.
ENDFORM.
*----------------------------------------------------------*
*       FORM HANDLE_USER_COMMAND                                 *
*----------------------------------------------------------*
*       --> R_UCOMM                                        *
*       --> RS_SELFIELD                                    *
*----------------------------------------------------------*
FORM handle_user_command USING r_ucomm LIKE sy-ucomm
                  rs_selfield TYPE slis_selfield.
** Check function code
  CASE r_ucomm.
    WHEN '&DWN'.
      PERFORM download_report.
  ENDCASE.
ENDFORM.
*---------------------------------------------------------------------*
*       FORM PFSTATUS                                            *
*---------------------------------------------------------------------*
*Form for settings the pf status to the alv
FORM zstandard USING ut_extab TYPE slis_t_extab.
  SET PF-STATUS 'ZSTANDARD'.
ENDFORM.
FORM download_report.
  wf_file = p_loclfn.
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = wf_file
      filetype                = 'ASC'
      write_field_separator   = 'X'
    TABLES
      data_tab                = gt_download_temp
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.
  IF sy-subrc <> 0.
    MESSAGE TEXT-005 TYPE 'E'.
  ELSE.
    MESSAGE TEXT-006 TYPE 'S'.
  ENDIF.
ENDFORM.                               " PF_STATUS_SET
*&---------------------------------------------------------------------*
*& Form get_last_day_of_month
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_last_day_of_month CHANGING bldat TYPE bseg-h_bldat
                                    budat TYPE bseg-h_budat.
  DATA: lv_date             TYPE sy-datum,
        ev_month_begin_date TYPE  d,
        ev_month_end_date   TYPE  d.

  CONCATENATE: p_ryear p_poper+1(2) '01'  INTO lv_date.

  CALL FUNCTION 'HR_JP_MONTH_BEGIN_END_DATE'
    EXPORTING
      iv_date             = lv_date
    IMPORTING
      ev_month_begin_date = ev_month_begin_date
      ev_month_end_date   = ev_month_end_date.

  MOVE ev_month_end_date TO bldat.
  MOVE ev_month_end_date TO budat.

ENDFORM.
