*&---------------------------------------------------------------------*
*& Include          ZBTP_TEST04_10125_PROC
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form fetch_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fetch_data .
IF  p_vbeln IS NOT INITIAL.
  SELECT vbeln
      erdat
      audat
      vbtyp
      ernam
      netwr
      waerk
  FROM vbak
  INTO CORRESPONDING FIELDS OF TABLE gt_vbak
  WHERE vbeln = p_vbeln.
ELSE.
  SELECT vbeln
        erdat
        audat
        vbtyp
        ernam
        netwr
        waerk
    FROM vbak
    INTO CORRESPONDING FIELDS OF TABLE gt_vbak
    WHERE ernam = 'BPINST'.
ENDIF.

IF  sy-subrc = 0.
  SELECT vbeln
          posnr
          matnr
          matwa
          pmatn
          charg
          matkl
          arktx
          pstyv
          posar
   FROM vbap
   INTO CORRESPONDING FIELDS OF TABLE gt_vbap
    FOR ALL ENTRIES IN gt_vbak
    WHERE vbeln = gt_vbak-vbeln.


  IF sy-subrc EQ 0.
    FREE: gs_vbak, gs_vbap, gs_pfinal, gs_kfinal.

    LOOP AT gt_vbak INTO gs_vbak.
      READ TABLE gt_vbap INTO gs_vbap WITH KEY vbeln = gs_vbak-vbeln.
      CHECK sy-subrc EQ 0.
      MOVE-CORRESPONDING gs_vbap TO gs_pfinal.
      MOVE-CORRESPONDING gs_vbak TO gs_kfinal.
      gs_pfinal-count = gs_pfinal-count + 1.
      APPEND gs_pfinal TO gt_pfinal.
      COLLECT gs_kfinal INTO gt_kfinal.
      LOOP AT gt_vbap INTO gs_vbap WHERE vbeln = gs_vbak-vbeln.
      ENDLOOP.
      FREE: gs_vbak, gs_vbap, gs_pfinal, gs_kfinal.
    ENDLOOP.

    REFRESH: gt_vbap, gt_vbak.
  ENDIF.

  gt_cpfinal = gt_pfinal.
  BREAK-POINT.

  SORT gt_cpfinal ASCENDING BY VBELN.
  SORT gt_pfinal DESCENDING BY VBELN.
ENDIF.
ENDFORM.
