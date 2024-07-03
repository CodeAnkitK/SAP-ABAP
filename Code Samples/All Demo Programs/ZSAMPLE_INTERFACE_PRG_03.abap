*&---------------------------------------------------------------------*
*& Report ZBTP_TEST06_10125
*&---------------------------------------------------------------------*
*& Interfaces
*&---------------------------------------------------------------------*
REPORT ZBTP_TEST06_10125.

INTERFACE if_printer.
  METHODS: print.
ENDINTERFACE.

CLASS cl_printer DEFINITION.
  PUBLIC SECTION.
    INTERFACES: if_printer.
ENDCLASS.

CLASS cl_printer IMPLEMENTATION.
  METHOD if_printer~print.
    "Print document content logic using display method
  ENDMETHOD.
ENDCLASS.
