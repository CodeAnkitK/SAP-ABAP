*&---------------------------------------------------------------------*
*& Report ZBRF_DEMO10_FS3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbrf_demo10_fs3.

TYPES:BEGIN OF ty_employee,
        id       TYPE i,
        emp_name TYPE string,
        age      TYPE i,
      END OF ty_employee.

DATA: it_employee TYPE TABLE OF ty_employee,
      iw_employee TYPE ty_employee.

it_employee = VALUE #( ( id = 1 emp_name = 'DEEPSHIKHA' age = 26 )
                       ( id = 2 emp_name = 'BOB'  age = '25' )
                       ( id = 3 emp_name = 'SMITH' age = '26' ) ).

FIELD-SYMBOLS:<fs_employee>  TYPE ty_employee,
              <fs_component> TYPE any.

DATA: lo_data TYPE REF TO DATA.

LOOP AT it_employee INTO iw_employee.
  IF sy-subrc = 0.
    iw_employee-age = iw_employee-age + 1.
    MODIFY TABLE it_employee FROM iw_employee TRANSPORTING age.
  ENDIF.
ENDLOOP.

LOOP AT it_employee INTO iw_employee.
  WRITE: / iw_employee-id, iw_employee-emp_name, iw_employee-age.
ENDLOOP.

LOOP AT it_employee ASSIGNING <fs_employee>.
  ASSIGN COMPONENT 'AGE' OF STRUCTURE <fs_employee> TO <fs_component>.
*  ASSIGN  <fs_employee> TO <fs_component>.

  CREATE DATA lo_data TYPE i.
  IF sy-subrc = 0.
    <fs_component> = <fs_component> + 1.
  ENDIF.
ENDLOOP.

LOOP AT it_employee INTO iw_employee.
  WRITE: / iw_employee-id, iw_employee-emp_name, iw_employee-age.
ENDLOOP.
