*&---------------------------------------------------------------------*
*& Include          ZBTP_TEST_TOP
*&---------------------------------------------------------------------*

*********************************************************************
* local Structures of SFLIGHT Table.
*********************************************************************

TABLES: sflight.

TYPES: BEGIN OF ty_sflight.

TYPES: mandt     TYPE mandt,
       carrid    TYPE s_carr_id,
       connid    TYPE  s_conn_id,
       fldate    TYPE  s_date,
       price     TYPE  s_price,
       currency  TYPE  s_currcode,
       planetype TYPE  s_planetye,
       seatsmax  TYPE  s_seatsmax.
*INCLUDE TYPE <structure>
TYPES:  END OF ty_sflight.

TYPES: BEGIN OF ty_flight_data,
         carrname TYPE scarr-carrname,
         connid   TYPE spfli-connid,
         fldate   TYPE sflight-fldate,
         cityfrom TYPE spfli-cityfrom,
         cityto   TYPE spfli-cityto,
       END OF ty_flight_data.

TYPES: BEGIN OF ty_scarr.
         INCLUDE STRUCTURE scarr.
         TYPES: price     TYPE  s_price,
         planetype TYPE s_planetye,
         seatsmax  TYPE	s_seatsmax,
       END OF ty_scarr.

*********************************************************************
* local Table & Work Area of local structure
*********************************************************************
DATA: gt_sflight TYPE STANDARD TABLE OF ty_sflight WITH DEFAULT KEY,
      gw_sflight TYPE ty_sflight.

DATA: gt_scarr TYPE STANDARD TABLE OF ty_scarr,
      gw_scarr LIKE LINE OF gt_scarr.



*********************************************************************
* local Table & Work Area of SFLIGHT Table
*********************************************************************
*data: gt_sflight type standard table of sflight.
*data: gw_sflight type sflight.
