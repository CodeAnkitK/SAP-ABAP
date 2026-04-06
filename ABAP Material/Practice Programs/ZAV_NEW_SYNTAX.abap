*&---------------------------------------------------------------------*
*& Report ZAV_NEW_SYNTAX
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zav_new_syntax.

SELECT *
  FROM scarr
  INTO TABLE @DATA(lt_scarr).

LOOP AT  lt_scarr INTO DATA(ls_scarr).
ENDLOOP.
"-----------------------------------------------------------------------------------------
"Old Style
READ TABLE lt_scarr INTO ls_scarr INDEX 1.
"New Syntax
DATA(ls_scarr1) =  lt_scarr[ 1 ].

"-----------------------------------------------------------------------------------------
"Old Style
DATA(lv_carrname) = ls_scarr-carrname.
"New Style
DATA(lv_carrid) =  lt_scarr[ 1 ]-carrid.

"-----------------------------------------------------------------------------------------
"Old Style
READ TABLE lt_scarr INTO ls_scarr INDEX 1.
IF SY-SUBRC = 0.
ENDIF.
"New Style
DATA(ls_scarr2) = VALUE #( lt_scarr[ 1 ] OPTIONAL ).

"-----------------------------------------------------------------------------------------
"Old Syntax
LOOP AT lt_scarr INTO ls_scarr WHERE CARRID = 'CO'.
ENDLOOP.
READ TABLE lt_scarr INTO ls_scarr WITH KEY CARRID = 'CO'.
"New Syntax
DATA(ls_flight_det) = lt_scarr[ CARRID = 'CO' ].
"-----------------------------------------------------------------------------------------
"Old Style
CONCATENATE ls_flight_det-carrid  ls_flight_det-carrname INTO DATA(lv_fld) SEPARATED BY '-'.
"New Style
lv_fld = |{ ls_flight_det-carrid }-{ ls_flight_det-carrname } |.
WRITE: lv_fld.

"New Style for Without Space
lv_fld = ls_flight_det-carrid &&  ls_flight_det-carrname.
WRITE: / lv_fld.
"-----------------------------------------------------------------------------------------

DATA wa_scarr TYPE scarr.

DATA(wa_scarr1) = VALUE scarr(                                 "SCarr = Structure NOT Workarea
                    CARRID = 'ZZ'
                    CARRNAME = 'INDIGO'
                    CURRCODE = 'IND'
                    URL = 'https://www.indigo.com'
                   ).

"-----------------------------------------------------------------------------------------
"Old Style
DATA: lt1_scarr TYPE TABLE OF scarr,
      ls1_scarr TYPE scarr.

ls1_scarr-carrid = 'AA'.
ls1_scarr-carrname = 'Air India'.
ls1_scarr-currcode = 'INR'.
APPEND ls1_scarr TO lt1_scarr.

ls1_scarr-carrid = 'BA'.
ls1_scarr-carrname = 'British Airways'.
ls1_scarr-currcode = 'GBP'.
APPEND ls1_scarr TO lt1_scarr.

"New Style

* Single row → APPEND VALUE #( ... )
* One row → APPEND VALUE scarr( ... ) TO lt_scarr
* Multiple rows → APPEND LINES OF VALUE #( ... )
* Multiple rows → APPEND LINES OF VALUE ty_t_scarr( ... ) TO lt_scarr
* Full table → DATA = VALUE #( ... )
* Append while preserving table → lt_scarr = VALUE ty_t_scarr( BASE lt_scarr ... )
* APPEND LINES OF expects a table
* VALUE must create an object of a known table type
* ty_t_scarr gives ABAP that exact table type


DATA: lt2_scarr TYPE TABLE OF scarr.

lt2_scarr = VALUE #(
  ( carrid = 'AA' carrname = 'Air India'        currcode = 'INR' )
  ( carrid = 'BA' carrname = 'British Airways'  currcode = 'GBP' )
  ( carrid = 'LH' carrname = 'Lufthansa'        currcode = 'EUR' )
).

TYPES ty_t_scarr TYPE STANDARD TABLE OF scarr WITH EMPTY KEY.
DATA lt3_scarr TYPE ty_t_scarr.


APPEND LINES OF VALUE ty_t_scarr(
  ( carrid = 'AA' carrname = 'Air India'       currcode = 'INR' )
  ( carrid = 'BA' carrname = 'British Airways' currcode = 'GBP' )
) TO lt3_scarr.

lt3_scarr = VALUE ty_t_scarr(
  BASE lt3_scarr
  ( carrid = 'AA' carrname = 'Air India'       currcode = 'INR' )
  ( carrid = 'BA' carrname = 'British Airways' currcode = 'GBP' )
).
"-----------------------------------------------------------------------------------------

"Old Synax
DATA: lt4_scarr TYPE TABLE OF scarr,
      lt_new   TYPE TABLE OF scarr,
      ls4_scarr TYPE scarr.

LOOP AT lt4_scarr INTO ls4_scarr.
  IF ls4_scarr-currcode = 'INR'.
    APPEND ls4_scarr TO lt_new.
  ENDIF.
ENDLOOP.

"New Synax
FREE lt_new.
lt_new = VALUE #(
 "Using ls5_scarr because this declares new variable and ls4_scarr is already declared
  FOR ls5_scarr IN lt4_scarr WHERE ( currcode = 'INR' )
  ( ls5_scarr )
).
"-----------------------------------------------------------------------------------------
FREE lt_new.
lt_new = VALUE #(
  FOR ls5_scarr IN lt_scarr
  ( carrid   = ls_scarr-carrid
    carrname = ls_scarr-carrname
    currcode = 'USD' )
).
"-----------------------------------------------------------------------------------------
" Creating a Table Value.

"Old Syntax
DATA: lt_num TYPE TABLE OF i.
DATA: ls_num TYPE i.
DATA i TYPE i VALUE 0.

DO 5 TIMES.
  ls_num = i + 1.
  APPEND ls_num to lt_num.
ENDDO.


"New Syntax
DATA lt_numbers TYPE TABLE OF i.
lt_numbers = VALUE #(
  FOR j = 1 UNTIL j > 5
  ( j )
).

"-----------------------------------------------------------------------------------------
BREAK-POINT.