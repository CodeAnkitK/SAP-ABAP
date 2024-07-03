*&---------------------------------------------------------------------*
*& Include          ZFI_ROYALTY_REP_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_bukrs FOR acdoca-rbukrs OBLIGATORY.
  PARAMETERS: p_ryear TYPE acdoca-ryear  OBLIGATORY.
  SELECT-OPTIONS: s_matnr FOR acdoca-matnr  OBLIGATORY.
  SELECT-OPTIONS: s_racct FOR acdoca-racct  OBLIGATORY.
  PARAMETERS: p_poper TYPE acdoca-poper  OBLIGATORY.
  PARAMETERS: p_profit TYPE acdoca-wsl.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_sum RADIOBUTTON GROUP rg1 DEFAULT 'X',
              p_det RADIOBUTTON GROUP rg1.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  PARAMETERS: p_xyd RADIOBUTTON GROUP rg2 DEFAULT 'X',
              p_zev RADIOBUTTON GROUP rg2.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-004.
  PARAMETERS: p_loclfn LIKE ibipparms-path OBLIGATORY
                                 VISIBLE LENGTH 50
                                 DEFAULT 'C:\tmp\openitem.txt'.
SELECTION-SCREEN END OF BLOCK b4.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_loclfn.
* To provide F4 help for file name
  PERFORM read_file_name CHANGING p_loclfn.
