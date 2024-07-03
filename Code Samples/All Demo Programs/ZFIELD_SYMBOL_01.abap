*&---------------------------------------------------------------------*
*& Report ZBRF_DEMO10_FS1
*&---------------------------------------------------------------------*
*& Field Symbol allow you to reference the memory address of a data object,
*& enabling you to read or modify the data without copying it. This is especially
*& useful for performance optimization in large datasets.
*&---------------------------------------------------------------------*
REPORT ZBRF_DEMO10_FS1.

TYPES: BEGIN OF ty_customer,
          name TYPE string,
          age  TYPE i,
        END OF ty_customer.

DATA: lt_customers TYPE TABLE OF ty_customer,
      lv_customer  TYPE ty_customer.

BREAK-POINT.

lt_customers = VALUE #( ( name = 'Alice' age = 30 )
                        ( name = 'Bob' age = 25 )
                        ( name = 'Charlie' age = 35 ) ).

*DATA: wa_customer TYPE ty_customer.
FIELD-SYMBOLS: <fs_customer> TYPE ty_customer.

LOOP AT lt_customers ASSIGNING <fs_customer>.
  <fs_customer>-age = <fs_customer>-age + 1.
ENDLOOP.

LOOP AT lt_customers INTO lv_customer.
  WRITE: / lv_customer-name, lv_customer-age.
ENDLOOP.
