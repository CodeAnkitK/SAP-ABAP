*&---------------------------------------------------------------------*
*& Report ZBRF_DEMO10_FS2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBRF_DEMO10_FS2.

TYPES: BEGIN OF ty_employee,
          id    TYPE i,
          name  TYPE string,
          age   TYPE i,
        END OF ty_employee.

DATA: lt_employees TYPE TABLE OF ty_employee,
      ls_employee  TYPE ty_employee.

lt_employees = VALUE #( ( id = 1 name = 'Alice' age = 30 )
                        ( id = 2 name = 'Bob' age = 25 )
                        ( id = 3 name = 'Charlie' age = 35 ) ).

FIELD-SYMBOLS: <fs_employee> TYPE ty_employee,
               <fs_component> TYPE any.
*               <fs_table> TYPE ANY TABLE.

*&-----------------------------------------------------------------------------------
*& Inside the loop, we use ASSIGN COMPONENT to dynamically assign the
*& AGE component of the structure <fs_employee> to the field symbol <fs_component>.
*&------------------------------------------------------------------------------------
LOOP AT lt_employees ASSIGNING <fs_employee>.
  ASSIGN COMPONENT 'AGE' OF STRUCTURE <fs_employee> TO <fs_component>.
  IF sy-subrc = 0.
    <fs_component> = <fs_component> + 1.
  ENDIF.
ENDLOOP.
*&-----------------------------------------------------------------------------------
*&------------------------------------------------------------------------------------

LOOP AT lt_employees INTO ls_employee.
  WRITE: / ls_employee-id, ls_employee-name, ls_employee-age.
ENDLOOP.
