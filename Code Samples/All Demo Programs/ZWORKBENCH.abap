*&---------------------------------------------------------------------*
*& Report ZBTP_TEST01_10125
*&---------------------------------------------------------------------*
*& DEMO Program for : ABAP Workbench & Language Elements
*&---------------------------------------------------------------------*
REPORT zbtp_test01_10125.

* Declaration Components
*TYPES : Structure
*DATA  : Variable
*CONSTANTS : Constants

**************************************************************
** DECLARATIONS
**************************************************************

**************************************************************
** Custom Global Structure
**************************************************************
TYPES: BEGIN OF ty_vbak,
*         vbeln TYPE  vbeln_va,
         vbeln TYPE  vbak-vbeln, "directly refering to table-fieldname.
         erdat TYPE  erdat,  "refering to data element.
         erzet TYPE  erzet,
         ernam TYPE  ernam,
         angdt TYPE  angdt_v,
         bnddt TYPE  bnddt,
         audat TYPE  audat,
         vbtyp TYPE  vbtypl,
         trvog TYPE  trvog,
         auart TYPE  auart,
       END OF ty_vbak.

TYPES: BEGIN OF ty_vbap,
         vbeln TYPE  vbeln_va,
         posnr TYPE  posnr_va,
         matnr TYPE  matnr,
         matwa TYPE  matwa,
         pmatn TYPE  pmatn,
         charg TYPE  charg_d,
         matkl TYPE  matkl,
         arktx TYPE  arktx,
         pstyv TYPE  pstyv,
         posar TYPE  posar,
       END OF ty_vbap.

**************************************************************
** Internal Tables
**************************************************************
DATA: gt_vbak TYPE STANDARD TABLE OF ty_vbak.
DATA: gt_vbap TYPE STANDARD TABLE OF ty_vbap.

DATA: gt_vbak1 TYPE STANDARD TABLE OF vbak.
**************************************************************
** Work Area
**************************************************************
DATA: gs_vbak TYPE ty_vbak. "refering to the structure
DATA: gs_vbap TYPE ty_vbap.

DATA gs_vbap2 LIKE LINE OF gt_vbak1.

DATA: gs_vbak1 TYPE vbak.  "direct refering to the table.
**************************************************************
** Variables
**************************************************************
DATA: lv_data TYPE d.

*DATA lv_char TYPE c LENGTH 8.
*DATA: lv_char(8).
DATA: lv_char(8) TYPE c.
DATA: lv_char2(2) TYPE c.

DATA: lv_char3(8) TYPE c,
      lv_char4(8) TYPE c,
      lv_char5(8) TYPE c,
      lv_char6(8) TYPE c.

DATA: lv_char7 LIKE lv_char3.

lv_char = 'SAP DEMO'.
MOVE: lv_char TO lv_char2.
lv_char2 = lv_char.

CONSTANTS:  lc_num2 TYPE i VALUE 10.
DATA: lv_num TYPE i VALUE 1.

DO 10 TIMES.
*  lv_num = lv_num + 1.
*  WRITE: lv_num.

*  lc_num2 = lc_num2 + 1.
*  WRITE lc_num2.
ENDDO.

*DATA lv_length TYPE i.
*i = STRLEN(lv_char).

* IF
* CASE

* EQ | NE | <>
*IF lv_char2 EQ 'AA'.
*IF lv_char2 = 'AA' OR ( lv_char3 IS INITIAL AND lv_char4 IS INITIAL ).

IF NOT lv_char2 = 'AA' AND ( lv_char3 IS INITIAL OR lv_char4 IS INITIAL ).
  WRITE: 'True'.
ELSEIF lv_char2 = 'AA' OR ( lv_char3 IS INITIAL AND lv_char4 IS INITIAL ).
  WRITE: 'SOMETHING'.
ELSE.
  IF lv_char2 IS NOT INITIAL.
    WRITE: 'FALSE'.
  ENDIF.
ENDIF.

CASE lv_char2.
  WHEN 'SAP DEMO'.
    WRITE: 'YES'.
  WHEN 'AA'.
    WRITE 'NO'.
  WHEN OTHERS.
    WRITE 'ALL LOGIC FAILED'.
ENDCASE.

* SYSTEM FIELDS

DATA lv_mandt TYPE sy-mandt.
lv_mandt = sy-mandt.

* LOOP Consturcts
DO 10 TIMES.
ENDDO.

DO.
  IF lv_char2 NE 'AA'.
    EXIT.
  ENDIF.
ENDDO.

WHILE lv_num = 2.
ENDWHILE.

SELECT *
FROM vbrk
INTO @DATA(vbrk). "Structure/WA
BREAK-POINT.

  DATA i TYPE i VALUE 1.
  DATA TEST TYPE i.

  CLEAR TEST.

  IF i = 0.
    EXIT.
  ELSE.
    CONTINUE.
  ENDIF.

  TEST = 2.

ENDSELECT.

*LOOP
*
*ENDLOOP.

BREAK-POINT.
