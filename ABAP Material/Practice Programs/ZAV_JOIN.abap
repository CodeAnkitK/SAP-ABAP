*&---------------------------------------------------------------------*
*& Report ZAV_VIEW_JOIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zav_view_join.
*MM01,02,03 - Materical
"MARA - Master Table
"MAKT - Description
"MARD - Storgae Location
*
*DATA: lt_data TYPE TABLE OF string,

"Loop is used in Program level processing.
"Select Loop in used in Table level fetching.

BREAK-POINT.
*
*INNER JOIN - Returns all the records only when the match exist in all the tables
*            - If data is missing in one table -> It is excluded.

*LEFT OUTER JOIN - Return all the records from Left Table
*                 - If no match in the right table -> Value becomes null

*RIGHT OUTER JOIN - Return all the records from Right Table
*                 - If no match in the left table -> Value becomes null

SELECT SINGLE a~matnr, b~maktx, c~pstat
FROM mara AS a
INNER JOIN makt AS b ON a~matnr = b~matnr
LEFT OUTER JOIN mard AS c ON a~matnr = c~matnr
INTO @DATA(lt_material1)
WHERE a~matnr = '000000000000000054'.

SELECT SINGLE a~matnr, b~maktx, c~pstat
FROM mara AS a
INNER JOIN makt AS b ON a~matnr = b~matnr
INNER JOIN mard AS c ON a~matnr = c~matnr
INTO @DATA(lt_material2)
WHERE a~matnr = '000000000000000037'.

*SELECT SINGLE a~matnr, b~maktx, c~pstat
*FROM mara AS a
*RIGHT JOIN makt AS b ON a~matnr = b~matnr
*LEFT JOIN mard AS c ON a~matnr = c~matnr
*INTO @DATA(lt_material3)
*WHERE a~matnr = '000000000000000054'.

BREAK-POINT.