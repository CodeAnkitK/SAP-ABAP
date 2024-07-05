*&---------------------------------------------------------------------*
*& Report ZNEW_ABAP_SYNTAX_UNION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT znew_abap_syntax_union.

TABLES : bsid.
DATA : gt_bsid TYPE STANDARD TABLE OF bsid.
SELECT-OPTIONS : s_bukrs FOR bsid-bukrs,
 s_belnr FOR bsid-belnr,
 s_gjahr FOR bsid-gjahr OBLIGATORY DEFAULT sy-datum+0(4).

START-OF-SELECTION.
  SELECT bukrs belnr gjahr shkzg dmbtr FROM bsid INTO CORRESPONDING FIELDS OF TABLE gt_bsid
  WHERE bukrs IN s_bukrs
  AND belnr IN s_belnr
  AND gjahr IN s_gjahr.
  SELECT bukrs belnr gjahr shkzg dmbtr FROM bsad APPENDING CORRESPONDING FIELDS OF TABLE
 gt_bsid
  WHERE bukrs IN s_bukrs
  AND belnr IN s_belnr
  AND gjahr IN s_gjahr.


*******
  SELECT bukrs, belnr, gjahr, shkzg, dmbtr, "'OPEN' AS status,
  CASE shkzg WHEN 'H' THEN CAST( dmbtr  * -1 AS CURR( 23,2 ) ) ELSE dmbtr END AS amount
   FROM bsid
   WHERE bukrs IN @s_bukrs
   AND belnr IN @s_belnr
   AND gjahr IN @s_gjahr

*  UNION / UNION ALL
  UNION ALL

  SELECT bukrs, belnr, gjahr, shkzg, dmbtr, "'CLOSE' AS status,
  CASE shkzg WHEN 'H' THEN CAST( dmbtr  * -1 AS CURR( 23,2 ) ) ELSE dmbtr END AS amount
    FROM bsad
    WHERE bukrs IN @s_bukrs
    AND belnr IN @s_belnr
    AND gjahr IN @s_gjahr
    INTO TABLE @DATA(gt_fi_items).


  cl_demo_output=>display( gt_fi_items ).

END-OF-SELECTION.
