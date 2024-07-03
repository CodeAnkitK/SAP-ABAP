*&---------------------------------------------------------------------*
*& Report ZBRF_JOINDEMO_10125
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbrf_joindemo_10125.
TABLES: sflight.

SELECT-OPTIONS: so_carr FOR sflight-carrid.
*PARAMETERS: p_carrid TYPE sflight-carrid.

SELECT f~carrid,
       f~connid,
       c~carrname,
       s~cityfrom,
       s~cityto
  FROM sflight AS f
  LEFT OUTER JOIN scarr AS c ON f~carrid = c~carrid
  INNER JOIN spfli AS s ON f~carrid = s~carrid
                       AND f~connid = s~connid
  INTO TABLE @DATA(it_output).



BREAK-POINT.
