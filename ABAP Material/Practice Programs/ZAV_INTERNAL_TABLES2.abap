"Operations on Internal Table & Access 
"RICEFW - Object  

DATA: it_vbak TYPE STANDARD TABLE OF vbak. 
DATA: wa_vbak TYPE vbak. 

DATA: it_vbak1 TYPE STANDARD TABLE OF vbak. 
DATA: wa_vbak1 TYPE vbak. 

Select *
FROM VBAK
INTO TABLE it_vbak
UPTO 10 ROW. 

CLEAR wa_vbak1. 
LOOP it_vbak into wa_vbak. 
   wa_vbak-vblen = wa_vbak1-vblen.
   "MOVE-CORRESPONDING wa_vbak TO wa_vbak1. 
   APPEND wa_vbak1 TO it_vbak1.
   CLEAR wa_vbak1. 
ENDLOOP. 

MODIFY it_vbak FROM sy-datum TRANSPORTING CREATE_DATE WHERE CREATE_DATE < sy-datum. 

"SORT it_vbak DESCENDING/ASCENDING BY VBELN.
SORT it_vbak ASCENDING BY VBELN.

"DELETE it_vbak INDEX 1. 

"READ TABLE it_vbak INTO wa_vbak WITH KEY VBLEN = 3. 
READ TABLE it_vbak INTO wa_vbak INDEX 1. 
wa_vbak-CREATE_DATE = sy-datum. "Current Date 
"MODIFY it_vbak FROM wa_vbak INDEX 1. 


"CLEAR   "Clear Work area 
"REFRESH "Remove all rows
"FREE    "Release Memory 

"FIELD-SYMBOL
"MODIFY
"APPEND
"COLLECT 

"DATA: BEGIN of ls, 
"	num TYPE I,  
"      END of ls. 
"10 
"20 
"30 
"COLLECT lx INTO lt_data. 
"60






