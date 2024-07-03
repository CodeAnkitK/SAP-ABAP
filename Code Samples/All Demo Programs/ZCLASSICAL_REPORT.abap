*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Report ZRDS_CLASSICAL_REPORT
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& This is an example of a Classical report.
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
REPORT zbrf_clarep_10125.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Structure Declarations
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
TYPES : BEGIN OF ty_sflight,
          carrid    TYPE s_carr_id,
          connid    TYPE s_conn_id,
          fldate    TYPE s_date,
          price     TYPE s_price,
          planetype TYPE s_planetye,
          seatsmax  TYPE s_seatsmax,
          seatsocc  TYPE s_seatsocc,
        END OF ty_sflight.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Internal Table
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
DATA: it_sflight        TYPE TABLE OF ty_sflight,
      it_sflight_upload TYPE TABLE OF sflight,
      wa_sflight        TYPE ty_sflight.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Selection Screen
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
"to SELECT download option
PARAMETERS : p_dload AS CHECKBOX USER-COMMAND flag,
             "to select upload option
             p_uload AS CHECKBOX USER-COMMAND flag.
SELECTION-SCREEN END OF BLOCK b1.
SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS : p_carrid TYPE s_carr_id MODIF ID m1,
             p_file   TYPE rlgrap-filename MODIF ID M1.
SELECTION-SCREEN END OF BLOCK b2.
SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
PARAMETERS : p_ufile TYPE rlgrap-filename MODIF ID M2.
SELECTION-SCREEN END OF BLOCK b3.


INITIALIZATION.
  p_dload = 'X'.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& At Selection Screen
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
AT SELECTION-SCREEN OUTPUT.
"if download option is not selected, HIDE the download screen
  LOOP AT SCREEN.
    IF p_dload NE 'X' AND screen-group1 = 'M1'.
      screen-active = '0'.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

 "if upload option is not selected,HIDE the upload screen
  LOOP AT SCREEN.
    IF p_uload NE 'X' AND screen-group1 = 'M2'.
      screen-active = '0'.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& At Selection Screen - On Value Request
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM file_value_help.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_ufile.
  PERFORM file_value_upload_help.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& At Selection Screen
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
AT SELECTION-SCREEN.
  PERFORM validation. "validation on screen

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Start of Selection
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
START-OF-SELECTION.
  PERFORM get_flight_details.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& End of Selection
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
END-OF-SELECTION.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Perform:
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
  PERFORM display_details.

  IF p_dload = 'X'.
    PERFORM download_flight_data.
  ENDIF.
  IF p_uload = 'X'.
    PERFORM upload_flight_data.
  ENDIF.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Form : Validation
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
FORM validation.
  IF p_dload = 'X' AND p_uload = 'X'.
    MESSAGE 'please SELECT only one option' TYPE 'e'.
  ENDIF.
ENDFORM.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Form : get flight details
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
FORM get_flight_details.
  SELECT carrid
  connid
  fldate
  price
  planetype
  seatsmax
  seatsocc
  FROM sflight
  INTO TABLE it_sflight
  WHERE carrid = p_carrid.
ENDFORM.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Form : desplay details
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
FORM display_details.
  IF it_sflight IS NOT INITIAL.
    LOOP AT it_sflight INTO wa_sflight.
      WRITE: / wa_sflight-carrid, wa_sflight-connid, wa_sflight-fldate, wa_sflight-price, wa_sflight-planetype, wa_sflight-seatsmax, wa_sflight-seatsocc.
    ENDLOOP.
  ENDIF.
ENDFORM.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Form : download flight data
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
FORM download_flight_data.
  DATA : lv_file TYPE string .
  lv_file = p_file .
  CALL FUNCTION 'gui_download'
    EXPORTING
      filename              = lv_file
*     FILETYPE              = 'ASC'
*     APPEND                = ' '
      write_field_separator = 'x'
    TABLES
      data_tab              = it_sflight.
  IF sy-subrc = 0.
    MESSAGE 'download is successful' TYPE 'i'.
  ENDIF.
ENDFORM.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Form : upload flight data
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
FORM upload_flight_data.
  DATA : p_local TYPE string.
  p_local = p_ufile.
  CALL FUNCTION 'gui_upload'
    EXPORTING
      filename            = p_local
      filetype            = 'asc'
      has_field_separator = 'x'
    TABLES
      data_tab            = it_sflight_upload
    EXCEPTIONS
      bad_data_format     = 8.
  IF sy-subrc = 0.
    MESSAGE 'uploaded successfully' TYPE 'i'.
  ENDIF.
ENDFORM.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Form : file value help
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
FORM file_value_help.
  CALL FUNCTION 'f4_filename'
    EXPORTING
      field_name = 'p_file'
    IMPORTING
      file_name  = p_file.
ENDFORM.

*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
*& Form : file value upload help
*& — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — -*
FORM file_value_upload_help.
  CALL FUNCTION 'f4_filename'
    EXPORTING
      field_name = 'p_ufile'
    IMPORTING
      file_name  = p_ufile.
ENDFORM.
