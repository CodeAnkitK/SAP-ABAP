*&---------------------------------------------------------------------*
*& Report ZBTP_TEST05_10125
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbtp_test05_10125.

DATA: demo_string(10) VALUE 'Hello',
      demo_text(10) VALUE 'World ',
      demo_output(20),
      length TYPE i.

DATA: lv_vbeln TYPE vbak-vbeln VALUE '00000004'.

CONSTANTS: c_value(20) VALUE 'change'.
CONSTANTS: c_search VALUE 'r'.

BREAK-POINT.

length = STRLEN( demo_string ).

length = STRLEN( demo_text ).

CONDENSE demo_text.

length = STRLEN( demo_text ).

CONCATENATE demo_string demo_text INTO demo_output.

CONCATENATE demo_string demo_text INTO demo_output SEPARATED BY space.

CONDENSE demo_output NO-GAPS.
length = STRLEN( demo_output ).

CONCATENATE 'addMeToo' demo_string demo_text INTO demo_output SEPARATED BY '_'.

SPLIT demo_output AT '_' INTO DATA(field1) DATA(field2) DATA(field3).

REPLACE ALL OCCURRENCES OF '_' IN demo_output WITH '@'.

*c_value = 'NEW CHANGE'.

DATA: year(4), month(2), day(2).

year  = sy-datum+0(4).
month = sy-datum+4(2).
day   = sy-datum+6(2).

SEARCH demo_string FOR c_search.
SEARCH demo_text FOR c_search.

SHIFT lv_vbeln LEFT DELETING LEADING '0'.
SHIFT lv_vbeln RIGHT DELETING TRAILING space.

BREAK-POINT.
