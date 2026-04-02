*&---------------------------------------------------------------------*
*& Report ZAV_SELECT_QUERY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zav_select_query.

*Requirement Gathering: USER -> Buisnes Owner -> Non Technical
*Requairement Analysis: Senior, Team Lead -> Understand Technically
*Functional Specification: Buisness Requirement Document -> Non/Semi Technical -> Business approval
*Developer: Technical Analysis -> Technical Document -> Techincal Specification / TS.
*Development: Test Case
*Testing Phase: Quality Server | Ensure new developement and no existing functionality has been broken -> Impact Analysis
*Production: Post approval after quality testing.
*
*SAP Landscape
*
*Production -> Live Data | Never -> Business Use
*Quality    -> Old Data | Prodcution Replication -> Analysis | Test Case -> Create or pick existing
*Development -> Create | ABAP | Query


*Open SQL -> Works across all databases
*Native SQL -> Advanced. Direct DB specific


*MM01 - CREATE
*MM02 - EDIT
*MM03 - DISPLAY
*
*VA01 - CREATE
*VA02 - EDIT
*VA03 - DISPLAY
"-------------------------------------------------------------------
" Traditional Style
"-------------------------------------------------------------------
*DATA: lt_data TYPE STANDARD TABLE OF mara. " Internal Table
*DATA: wa_data TYPE mara. "Work Area
*
*SELECT SINGLE *
*  FROM mara
*  INTO wa_data
*  WHERE matnr = '000000000000000043'.

"-------------------------------------------------------------------
" New Style
"-------------------------------------------------------------------
*SELECT  *
*  FROM mara
*  INTO TABLE @DATA(it_data)
*   WHERE matnr = '000000000000000043'.
*
*SELECT SINGLE *  'UPTO $no Row
*  FROM mara
*  INTO @DATA(wa_data)
*   WHERE matnr = '000000000000000043'.

"-------------------------------------------------------------------
" SELECTION By Field
"-------------------------------------------------------------------

*SELECT
*  MATNR,
*  ERSDA,
*  CREATED_AT_TIME,
*  ERNAM,
*  LAEDA,
*  AENAM,
*  VPSTA,
*  PSTAT,
*  LVORM,
*  MTART,
*  MBRSH,
*  MATKL
*  FROM mara
*  INTO TABLE @DATA(it_data)
*   WHERE matnr = '000000000000000043'.

"-------------------------------------------------------------------
" SELECTION By Field
"-------------------------------------------------------------------
"Select Loop
SELECT *
  FROM mara
  INTO @DATA(wa_data)
  UP TO 1 ROWS
   WHERE matnr = '000000000000000043'.
ENDSELECT.

"-------------------------------------------------------------------
" INSERT, UPDATE, DELETE, Modify
"-------------------------------------------------------------------
*Refer to ZAV_INTERNAL_TABLES

DELETE
  FROM ztestdemo01
  WHERE employee_code = '0003'.

"-------------------------------------------------------------------
" Advanced Data Handeling - Cursor | Large DATA
"-------------------------------------------------------------------
DATA wa TYPE scarr.

*BREAK-POINT.

OPEN CURSOR WITH HOLD @DATA(dbcur) FOR
  SELECT *
         FROM scarr
         WHERE carrid = 'UB'.

DO.
  FETCH NEXT CURSOR @dbcur INTO @wa.

  "-------------------------------------------------------------------
  " SY-SUBRC
  " Success = 0
  " Fail    = 4.
  "-------------------------------------------------------------------

  IF sy-subrc <> 0.
    EXIT.
  ENDIF.
ENDDO.

CLOSE CURSOR @dbcur.


*BREAK-POINT.


" Optimization
*1. Ensure -> Avoid using *, Use Column names as musch as possible.
*2. SELECT ENDSELECT -> It should be avoided for Large Data set - 1, 5.
*3. Sy-Eubrc Check -> paired with every Query.


"-------------------------------------------------------------------
" One or more
" JOIN
" Two Table - Parallel Cursor  -> FOR ALL ENTRIES
"-------------------------------------------------------------------

*
*TYPES: BEGIN OF ty_mat_rep,
*         matnr TYPE matnr, "Type refer by Domain  "MARA
*         ernam TYPE mara-ernam, " Type reference by Table-Field "MARA
*         maktx TYPE maktx,  "MAKT
*       END OF ty_mat_rep.
*
*DATA: it_matr TYPE STANDARD TABLE OF  ty_mat_rep.
*DATA: wa_matr TYPE ty_mat_rep.
*
*SELECT matnr, ernam
*  FROM mara
*  INTO TABLE @DATA(it_mara)
*  WHERE matnr = '000000000000000048'.


*CARDINALITY
*1,1
*1,Many


BREAK-POINT.

TYPES: BEGIN OF ty_sd_rep,
         vbeln TYPE vbeln_va,
         posnr TYPE posnr_va,
         erdat TYPE erdat,
         ernam TYPE ernam,
         matnr TYPE matnr,
         matkl TYPE matkl,
       END OF ty_sd_rep.

DATA: it_sd TYPE STANDARD TABLE OF  ty_sd_rep.
DATA: wa_sd TYPE ty_sd_rep.

SELECT vbeln, erdat, ernam
  FROM vbak
  INTO TABLE @DATA(it_vbak)
  WHERE vbeln = '0000000087'.

IF sy-subrc EQ 0.
  SELECT vbeln, posnr, matnr, matkl
    FROM vbap
    INTO TABLE @DATA(it_vbap)
    FOR ALL ENTRIES IN @it_vbak
    WHERE vbeln = @it_vbak-vbeln.

  IF sy-subrc EQ 0.
    LOOP AT it_vbak INTO DATA(wa_vbak).
      LOOP AT it_vbap INTO DATA(wa_vbap) WHERE vbeln = wa_vbak-vbeln.
        wa_sd-vbeln = wa_vbak-vbeln.
        wa_sd-posnr = wa_vbap-posnr.
        wa_sd-ernam = wa_vbak-ernam.
        wa_sd-erdat = wa_vbak-erdat.
        wa_sd-matnr = wa_vbap-matnr.
        wa_sd-matkl = wa_vbap-matkl.
        APPEND wa_sd TO it_sd.
        CLEAR:wa_sd.
      ENDLOOP.
    ENDLOOP.
  ENDIF.
ELSE.
  WRITE: / 'No DATA Found!'.
ENDIF.

cl_demo_output=>display( it_sd ).