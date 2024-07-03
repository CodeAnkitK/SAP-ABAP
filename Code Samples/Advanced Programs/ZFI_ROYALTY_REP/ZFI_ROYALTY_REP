*&---------------------------------------------------------------------*
*& Report ZFI_ROYALTY_REP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfi_royalty_rep.

**Data Definition
INCLUDE zfi_royalty_rep_top.
**Program Screen
INCLUDE zfi_royalty_rep_scr.
**Program subroutines
INCLUDE zfi_royalty_rep_sub.
**Program form
INCLUDE zfi_royalty_rep_form.

INITIALIZATION.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM set_download_data.
END-OF-SELECTION.
  PERFORM display.
