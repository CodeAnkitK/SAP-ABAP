*&---------------------------------------------------------------------*
*& Include          ZBRF_DEMO_10125_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  Defining a global structure
*&---------------------------------------------------------------------*
TYPES: BEGIN OF gs_sflight,
         carrid    TYPE sflight-carrid,
         connid    TYPE sflight-connid,
         fldate    TYPE sflight-fldate,  "flight date
         price     TYPE sflight-price,
         currency  TYPE sflight-currency,
         planetype TYPE sflight-planetype,
       END OF gs_sflight.

*&---------------------------------------------------------------------*
*&  Defining a global variables
*&---------------------------------------------------------------------*
DATA: gt_itab TYPE TABLE OF gs_sflight, "internal table
      gw_wtab TYPE gs_sflight. "Work Area
