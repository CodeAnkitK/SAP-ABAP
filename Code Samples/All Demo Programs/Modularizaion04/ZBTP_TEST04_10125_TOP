*&---------------------------------------------------------------------*
*& Include          ZBTP_TEST04_10125_TOP
*&---------------------------------------------------------------------*


TYPES: BEGIN OF gty_vbak, "SD
         vbeln TYPE vbak-vbeln,
         erdat TYPE erdat,
         audat TYPE audat,
         vbtyp TYPE vbtypl,
         ernam TYPE vbak-ernam,
         netwr TYPE vbak-netwr,
         waerk TYPE vbak-waerk,
       END OF gty_vbak.

TYPES: BEGIN OF gty_vbap,
         vbeln TYPE  vbeln_va,
         posnr TYPE  posnr_va,
         matnr TYPE  matnr,
         matwa TYPE  matwa,
         pmatn TYPE  pmatn,
         charg TYPE  charg_d,
         matkl TYPE  matkl,
         arktx TYPE  arktx,
         pstyv TYPE  pstyv,
         posar TYPE  posar,
       END OF gty_vbap.

TYPES: BEGIN OF gty_kfinal, "SD
         vbeln TYPE vbak-vbeln,
         netwr TYPE vbak-netwr,
       END OF gty_kfinal.

TYPES: BEGIN OF gty_pfinal,
         vbeln TYPE  vbeln_va,
         posnr TYPE  posnr_va,
         matnr TYPE  matnr,
         matwa TYPE  matwa,
         pmatn TYPE  pmatn,
         charg TYPE  charg_d,
         matkl TYPE  matkl,
         arktx TYPE  arktx,
         pstyv TYPE  pstyv,
         posar TYPE  posar,
         count TYPE i,
       END OF gty_pfinal.

TYPES: BEGIN OF gty_cpfinal,
         vbeln TYPE  vbeln_va,
         posnr TYPE  posnr_va,
         matnr TYPE  matnr,
         matwa TYPE  matwa,
         pmatn TYPE  pmatn,
         charg TYPE  charg_d,
         matkl TYPE  matkl,
         arktx TYPE  arktx,
         pstyv TYPE  pstyv,
         posar TYPE  posar,
         count TYPE i,
       END OF gty_cpfinal.

DATA: gt_vbak TYPE TABLE OF gty_vbak, "Internal Table
      gs_vbak TYPE gty_vbak.  "WA

DATA: gt_vbap TYPE STANDARD TABLE OF gty_vbap,
      gs_vbap TYPE gty_vbap.

DATA: gt_kfinal TYPE STANDARD TABLE OF gty_kfinal,
      gs_kfinal TYPE gty_kfinal.

DATA: gt_pfinal TYPE STANDARD TABLE OF gty_pfinal,
      gs_pfinal TYPE gty_pfinal.

DATA: gt_cpfinal TYPE STANDARD TABLE OF gty_cpfinal,
      gs_cpfinal TYPE gty_cpfinal.
