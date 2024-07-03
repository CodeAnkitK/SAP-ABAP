*&---------------------------------------------------------------------*
*& Include          ZBRF_DEMO5_10125_FUNC
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form GET_TEMPLATE_TO_INTERNAL_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_template_to_internal_table .
  REFRESH: t_upload.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     i_field_seperator    = 'X'
      i_line_header        = 'X'
      i_tab_raw_data       = it_raw
      i_filename           = p_file
    TABLES
      i_tab_converted_data = t_upload[]
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ARRANGE_TEMPLATE_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM arrange_template_data .
  FREE: w_upload.
  LOOP AT t_upload INTO w_upload.
*&---------------------------------------------------------------------*
*& Converting all the unicoding form XLS format to SAP format
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Converting external date type to internal date type
*&---------------------------------------------------------------------*
    CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'  "01-05-2024 | 20240501
      EXPORTING
        date_external            = w_upload-fldate
*       ACCEPT_INITIAL_DATE      =
      IMPORTING
        date_internal            = w_upload-fldate
      EXCEPTIONS
        date_external_is_invalid = 1
        OTHERS                   = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

*&---------------------------------------------------------------------*
*& Field: Carrid
*&---------------------------------------------------------------------*
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = w_upload-carrid
      IMPORTING
        output = w_upload-carrid.

*&---------------------------------------------------------------------*
*& Field: connid
*&---------------------------------------------------------------------*
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = w_upload-connid
      IMPORTING
        output = w_upload-connid.

*&---------------------------------------------------------------------*
*& Field: Currency
*&---------------------------------------------------------------------*
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = w_upload-currency
      IMPORTING
        output = w_upload-currency.

*&---------------------------------------------------------------------*
*& Field: planetype
*&---------------------------------------------------------------------*
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = w_upload-planetype
      IMPORTING
        output = w_upload-planetype.

    MODIFY TABLE t_upload FROM w_upload.
    FREE: w_upload.
  ENDLOOP.

ENDFORM.
