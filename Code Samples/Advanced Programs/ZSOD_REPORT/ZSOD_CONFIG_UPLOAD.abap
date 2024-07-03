*&---------------------------------------------------------------------*
*& Report  ZSOD_CONFIG_UPLOAD
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zsod_config_upload.

TABLES: ztsodstr.

TYPE-POOLS: truxs.
***************************************
*********  UPLOAD Structure
***************************************
TYPES: BEGIN OF ty_ztsodstr,
          squence	TYPE ztsodstr-squence,
          tablename	TYPE ztsodstr-tablename,
          tablefield TYPE	ztsodstr-tablefield,
          tcode	TYPE ztsodstr-tcode,
          user_field TYPE	ztsodstr-user_field,
          tab_dt_field TYPE	ztsodstr-tab_dt_field,
          description	TYPE ztsodstr-description,
          display_text  TYPE ztsodstr-display_text,
       END OF ty_ztsodstr.

***************************************
*********  EXCEL Upload Variables
***************************************
DATA: it_datatab TYPE STANDARD TABLE OF ty_ztsodstr,
      wa_datatab TYPE ty_ztsodstr.

DATA: it_upload TYPE STANDARD TABLE OF ztsodstr,
      wa_upload TYPE ztsodstr.

DATA: it_raw TYPE truxs_t_text_data.
***************************************
*********  SELECTION SCREEN
***************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-000.
    PARAMETERS: p_file TYPE  rlgrap-filename.
SELECTION-SCREEN END OF BLOCK b1.

***************************************
*********  AT SELECTION SCREEN
***************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      field_name = 'P_FILE'
    IMPORTING
      file_name  = p_file.

START-OF-SELECTION.
    " Perform configuration from excel sheet.
    PERFORM configuration_upload.
    " Perform table operation
    PERFORM table_operation.
END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form CONFIGURATION_UPLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM configuration_upload.

REFRESH: it_datatab[].
CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR        =
      i_line_header            =  'X'
      i_tab_raw_data           =  it_raw       " WORK TABLE
      i_filename               =  p_file
    TABLES
      i_tab_converted_data     = it_datatab[]    "ACTUAL DATA
   EXCEPTIONS
      conversion_failed        = 1
      OTHERS                   = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form TABLE OPERATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM table_operation.
  IF it_datatab[] IS NOT INITIAL.
    REFRESH: it_upload[].
    CLEAR: wa_datatab, wa_upload.
    LOOP AT it_datatab INTO wa_datatab.
      wa_upload-mandt = sy-mandt.
      MOVE-CORRESPONDING wa_datatab TO wa_upload.
      APPEND wa_upload TO it_upload.
      CLEAR: wa_datatab, wa_upload.
    ENDLOOP.
     IF it_upload[] IS NOT INITIAL.
       DELETE FROM ztsodstr.
       MODIFY ztsodstr FROM TABLE it_upload.
        IF sy-subrc <> 0.
          MESSAGE 'ERROR Uploading File' TYPE 'I'.
          EXIT.
        ELSE.
          MESSAGE 'File Uploaded successfully!' TYPE 'S'.
        ENDIF.
     ELSE.
       MESSAGE 'ERROR Uploading File' TYPE 'I'.
       EXIT.
     ENDIF.
  ELSE.
    MESSAGE 'The file cannot be empty!' TYPE 'I'.
    EXIT.
  ENDIF.
ENDFORM.
