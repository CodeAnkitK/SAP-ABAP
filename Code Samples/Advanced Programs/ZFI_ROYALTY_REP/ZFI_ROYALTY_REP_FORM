*&---------------------------------------------------------------------*
*& Include          ZFI_ROYALTY_REP_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data_xyd
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data_xyd.
  CLEAR:gw_xydalba, gw_acdoca.
  SORT gt_acdoca BY poper.
  LOOP AT gt_acdoca INTO gw_acdoca.
    MOVE-CORRESPONDING gw_acdoca TO gw_xydalba.
*     ex_type   "Exchange Rate Types
    gw_xydalba-ex_type = gc_avg.
*     ex_rate   "USD Exchange Rate
    gw_xydalba-ex_rate = ex_rate.
*     sale_amt  "Sales Amount (USD)
    gw_xydalba-sale_amt = gw_acdoca-wsl * ex_rate.
*     profit    "Profit
    gw_xydalba-profit = p_profit.
*     prof_shar "Profit Share (USD)
    gw_xydalba-prof_shar =  gw_xydalba-sale_amt * p_profit.
    APPEND gw_xydalba TO gt_xydalba.
    CLEAR:gw_xydalba, gw_acdoca.
  ENDLOOP.
  PERFORM set_download_data_xydalba.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data_zev
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data_zev.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM alv_fcat .
  IF p_xyd EQ 'X'.
    IF p_sum EQ 'X'.

      PERFORM build_catalog USING:
             'VKORG'     'ACDOCA' 'VKORG'     'Sales Org',
             'RBUKRS'    'ACDOCA' 'RBUKRS'    'Company Code',
             'KMLAND_PA' 'ACDOCA' 'KMLAND_PA' 'Customer Country',
             'MSL'       'ACDOCA' 'MSL'       'Quantity',
             'WSL'       'ACDOCA' 'WSL'       'Sales Amount',
             'RWCUR'     'ACDOCA' 'RWCUR'     'Sales Currency',
             'EX_TYPE'   space space          'Exchange Rate Types',
             'EX_RATE'   space space          'USD Exchange Rate',
             'SALE_AMT'  space space          'Sales Amount(USD)',
             'PROFIT'    space space          'Profit Percent',
             'PROF_SHAR' space space          'Profit Share(USD)'.

    ELSEIF p_det EQ 'X'.

      PERFORM build_catalog USING:
             'VKORG'     'ACDOCA' 'VKORG'     'Sales Org',
             'VTWEG'     'ACDOCA' 'VTWEG'     'Distribution Channel',
             'RBUKRS'    'ACDOCA' 'RBUKRS'    'Company Code',
             'KMLAND_PA' 'ACDOCA' 'KMLAND_PA' 'Customer Country',
             'WERKS'     'ACDOCA' 'WERKS'     'Plant',
             'MATNR'     'ACDOCA' 'MATNR'     'Product',
             'PRCTR'     'ACDOCA' 'PRCTR'     'Profit Center',
             'MSL'       'ACDOCA' 'MSL'       'Quantity',
             'WSL'       'ACDOCA' 'WSL'       'Sales Amount',
             'RWCUR'     'ACDOCA' 'RWCUR'     'Sales Currency',
             'EX_TYPE'   space space          'Exchange Rate Types',
             'EX_RATE'   space space          'USD Exchange Rate',
             'SALE_AMT'  space space          'Sales Amount(USD)',
             'PROFIT'    space space          'Profit Percent',
             'PROF_SHAR' space space          'Profit Share(USD)'.

    ENDIF.
  ELSEIF p_zev EQ 'X'.
    IF p_sum EQ 'X'.

      PERFORM build_catalog USING:
             'VKORG'     'ACDOCA' 'VKORG'     'Sales Org',
             'VTWEG'     'ACDOCA' 'VTWEG'     'Distribution Channel',
             'RBUKRS'    'ACDOCA' 'RBUKRS'    'Company Code',
             'KMLAND_PA' 'ACDOCA' 'KMLAND_PA' 'Customer Country',
             'WERKS'     'ACDOCA' 'WERKS'     'Plant',
             'MATNR'     'ACDOCA' 'MATNR'     'Product',
             'PRCTR'     'ACDOCA' 'PRCTR'     'Profit Center',
             'MSL'       'ACDOCA' 'MSL'       'Quantity',
             'WSL'       'ACDOCA' 'WSL'       'Sales Amount',
             'RWCUR'     'ACDOCA' 'RWCUR'     'Sales Currency',
             'EX_TYPE'   space space          'Exchange Rate Types',
             'PROFIT'    space space          'Profit Percent'.

    ELSEIF p_det EQ 'X'.

      PERFORM build_catalog USING:
             'VKORG'     'ACDOCA' 'VKORG'     'Sales Org',
             'VTWEG'     'ACDOCA' 'VTWEG'     'Distribution Channel',
             'RBUKRS'    'ACDOCA' 'RBUKRS'    'Company Code',
             'KMLAND_PA' 'ACDOCA' 'KMLAND_PA' 'Customer Country',
             'WERKS'     'ACDOCA' 'WERKS'     'Plant',
             'MATNR'     'ACDOCA' 'MATNR'     'Product',
             'PRCTR'     'ACDOCA' 'PRCTR'     'Profit Center',
             'MSL'       'ACDOCA' 'MSL'       'Quantity',
             'WSL'       'ACDOCA' 'WSL'       'Sales Amount',
             'RWCUR'     'ACDOCA' 'RWCUR'     'Sales Currency',
             'EX_TYPE'   space space          'Exchange Rate Types',
             'PROFIT'    space space          'Profit Percent'.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_download_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_XYDALBA
*&---------------------------------------------------------------------*
FORM set_download_data_xydalba.
  REFRESH: gt_download_temp.
  CLEAR: gw_acdoca, gw_download_temp.

  LOOP AT gt_acdoca INTO gw_acdoca.
    gw_download_temp-srno = gc_un.
    gw_download_temp-bukrs  =  gw_acdoca-rbukrs.
    gw_download_temp-waers  =  gw_acdoca-rwcur.
    gw_download_temp-wrbtr  =  gw_acdoca-msl.
    gw_download_temp-rke_artnr  =  gw_acdoca-matnr.
    gw_download_temp-rke_vkorg  =  gw_acdoca-vkorg.
    gw_download_temp-rke_vtweg  =  gw_acdoca-vtweg.
    gw_download_temp-matnr  =  gw_acdoca-matnr.
    gw_download_temp-menge  =  gw_acdoca-wsl.

    PERFORM get_last_day_of_month CHANGING gw_download_temp-bldat
                                           gw_download_temp-budat.

** BKPF
    SELECT SINGLE bktxt
      FROM bkpf
      INTO gw_download_temp-bktxt
      WHERE bukrs = gw_acdoca-rbukrs
        AND belnr = gw_acdoca-belnr
        AND gjahr = gw_acdoca-gjahr.


** BSEG
    SELECT SINGLE bschl
                  dmbtr
                  zuonr
                  sgtxt
                  prctr
                  meins
                  altkt
      FROM bseg
      INTO (gw_download_temp-newbs,
            gw_download_temp-dmbtr,
            gw_download_temp-zuonr,
            gw_download_temp-sgtxt,
            gw_download_temp-prctr,
            gw_download_temp-meins,
            gw_download_temp-newum)
      WHERE bukrs = gw_acdoca-rbukrs
        AND belnr = gw_acdoca-belnr
        AND gjahr = gw_acdoca-gjahr.


    IF gw_download_temp-dmbtr LT 0.
      gw_download_temp-newko = '50'.
    ELSE.
      gw_download_temp-newko = '40'.
    ENDIF.

    APPEND gw_download_temp TO gt_download_temp.
    CLEAR: gw_acdoca, gw_download_temp.
  ENDLOOP.
ENDFORM.
