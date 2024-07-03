*&---------------------------------------------------------------------*
*& Include          ZBRF_DEMO6_10125_FUNC
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form READ_DATASET
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM read_dataset.
  SELECT
    carrid
    connid
    fldate
    price
    currency
    planetype
  FROM SFLIGHT
  INTO TABLE gt_view.

  IF sy-subrc EQ 0.
    SELECT f~carrid
       f~connid
       c~carrname
  FROM sflight AS f
  LEFT OUTER JOIN scarr AS c ON f~carrid = c~carrid
  INNER JOIN spfli AS s ON f~carrid = s~carrid
                       AND f~connid = s~connid
    INTO TABLE gt_join.

    IF sy-subrc <> 0.
      MESSAGE 'No Data Found !' TYPE 'E' DISPLAY LIKE 'I'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_DATASET
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM prepare_dataset.
  DATA: lw_view LIKE LINE OF gt_view.
  DATA: lw_join LIKE LINE OF gt_join.
  DATA: lw_output LIKE LINE OF gt_output.

  FREE: lw_view, lw_join, lw_output.
  LOOP AT gt_view INTO lw_view.
    READ TABLE gt_join INTO lw_join WITH KEY carrid = lw_view-carrid connid = lw_view-connid.
    IF sy-subrc <> 0 OR lw_join-carrname IS INITIAL.
      lw_output-status = '@0A@'.
    ELSE.
      lw_output-status = '@08@'.
    ENDIF.

    lw_output-carrid       = lw_view-carrid.
    lw_output-connid       = lw_view-connid.
    lw_output-fldate       = lw_view-fldate.
    lw_output-price        = lw_view-price.
    lw_output-currency     = lw_view-currency.
    lw_output-planetype    = lw_view-planetype.

    APPEND lw_output TO gt_output.
    FREE: lw_view, lw_join, lw_output.
  ENDLOOP.

ENDFORM.
