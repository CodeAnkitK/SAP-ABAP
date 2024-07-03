*&---------------------------------------------------------------------*
*& Include          ZFI_ROYALTY_REP_TOP
*&---------------------------------------------------------------------*

TABLES: acdoca, tcurr, bbseg, bbkpf.
TYPE-POOLS: slis.  " SLIS contains all the ALV data types

TYPES: BEGIN OF ty_acdoca,
         rldnr     TYPE fins_ledger, "General Ledger Account
         rbukrs    TYPE bukrs,       "Company Code
         gjahr     TYPE gjahr,       "Financial Year
         belnr     TYPE belnr_d,     "Document Number
         vkorg     TYPE vkorg,       "Sales Org
         vtweg     TYPE vtweg,       "Distribution Channel
         kmland_pa TYPE land1_gp,    "Customer Country
         werks     TYPE werks_d,     "Plant
         matnr     TYPE matnr,       "Product
         prctr     TYPE prctr,       "Profit Center
         msl       TYPE quan1_12,    "Quantity
         wsl       TYPE quan1_12,    "Amount
         rwcur     TYPE fins_currw,  "Transaction Currency
         poper     TYPE poper,       "Posting Period
       END OF ty_acdoca.

TYPES: BEGIN OF ty_xydalba,
         vkorg     TYPE vkorg,       "Sales Org
         vtweg     TYPE vtweg,       "Distribution Channel
         rbukrs    TYPE bukrs,       "Company Code
         kmland_pa TYPE land1_gp,    "Customer Country
         werks     TYPE werks_d,     "Plant
         matnr     TYPE matnr,       "Product
         prctr     TYPE prctr,       "Profit Center
         msl       TYPE quan1_12,    "Quantity
         wsl       TYPE quan1_12,    "Amount
         rwcur     TYPE fins_currw,  "Transaction Currency
         ex_type   TYPE char5,       "Exchange Rate Types
         ex_rate   TYPE quan1_12,    "USD Exchange Rate
         sale_amt  TYPE quan1_12,    "Sales Amount (USD)
         profit    TYPE acdoca-wsl,  "Profit
         prof_shar TYPE quan1_12,    "Profit Share (USD)
       END OF ty_xydalba.

TYPES: BEGIN OF ty_zevtera,
         vkorg     TYPE vkorg,       "Sales Org
         vtweg     TYPE vtweg,       "Distribution Channel
         rbukrs    TYPE bukrs,       "Company Code
         kmland_pa TYPE land1_gp,    "Customer Country
         werks     TYPE werks_d,     "Plant
         matnr     TYPE matnr,       "Product
         prctr     TYPE prctr,       "Profit Center
         msl       TYPE quan1_12,    "Quantity
         wsl       TYPE quan1_12,    "Amount
         rwcur     TYPE fins_currw,  "Transaction Currency
         ex_type   TYPE char5,       "Exchange Rate Types
         ex_rate   TYPE quan1_12,    "USD Exchange Rate
         sale_amt  TYPE quan1_12,    "Sales Amount (USD)
         profit    TYPE acdoca-wsl,  "Profit
         prof_shar TYPE quan1_12,    "Profit Share (USD)
       END OF ty_zevtera.


TYPES: BEGIN OF ty_download_temp,
*&---------------------------------------------------------------------*
*& Begin of Document Header
*&---------------------------------------------------------------------*
*----- Begin of Document Header ----------------------------------------
*      Begin of Key Field
         srno      TYPE i,
         "Unique No for Split Fi Document
         bukrs     LIKE bbkpf-bukrs,           "<Key> "Company Code
         blart     LIKE bbkpf-blart,           "<Key> "Document Type
         bldat     LIKE sy-datum,              "<Key>   "Document Date
         budat     LIKE sy-datum,              "<Key>   "Posting Date
*---Ver 0002 Start of changes on 10.05.2010
         monat     LIKE bbkpf-monat,            "Fiscal Period
*---Ver 0002 End of changes on 10.05.2010
         xblnr     LIKE bbkpf-xblnr,           "<Key>   "Refrance Document No
*      End of Key Fields

         buzei     LIKE bseg-buzei,           "Not Input Field
         waers     LIKE bbkpf-waers,          "Currency
         bktxt     LIKE bbkpf-bktxt,          "Header Text
         xref1_hd  LIKE bkpf-xref1_hd,
         xref2_hd  LIKE bkpf-xref2_hd,
*&---------------------------------------------------------------------*
*& End of Header
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Begin of Document Line Items
*&---------------------------------------------------------------------*
         newbs     LIKE bbseg-newbs,          "Posting Key
         newko     LIKE bbseg-newko,           "Sap Code (GL/Customer/Vendor)
         newum     LIKE bbseg-newum,           "Special Gl Indicator
         wrbtr(13),                        "Transaction Currency Amount
         dmbtr     TYPE bseg-dmbtr,             "Local Currency Amount
         dmbe2     LIKE bbseg-dmbe2,            "Amount in Second Local Currency
         dmbe3     LIKE bbseg-dmbe3,            "Amount in Third Local Currency
         hkont     LIKE bbseg-hkont,
         zfbdt     LIKE sy-datum,              "Baseline Date
         zterm     LIKE bbseg-zterm,           "Payment Term
         ebeln     LIKE bbseg-ebeln,           "PO number
         ebelp     LIKE bbseg-ebelp,           "PO item
         zlsch     LIKE bbseg-zlsch,           "Payment Methld
         zuonr     LIKE bbseg-zuonr,           "Assignment Number
         sgtxt     LIKE bbseg-sgtxt,           "Line item Text
*      Begin of One Time Account

         name1     LIKE bbseg-name1,           "Name1 If One time
         ort01     LIKE bbseg-ort01,           "City If One time
         pstlz     LIKE bbseg-pstlz,           "Postal Code
         land1     LIKE bbseg-land1,           "Country Code
         aufnr     LIKE bbseg-aufnr,           "Internal Order No
         prctr     LIKE bbseg-prctr,           "Profit Center
         kostl     LIKE bbseg-kostl,           "Cost Center
         vbund     LIKE bbseg-vbund,           "Company ID of Trading Partner
         xref1     LIKE bbseg-xref1,           "Refrance No 1
         xref2     LIKE bbseg-xref2,           "Refrance No 2
         xref3     LIKE bbseg-xref3,           "Refrance No 3
         kidno     LIKE bbseg-kidno,
         okont     LIKE bbseg-hkont,           "Offsetting Account
         secco     LIKE bbseg-secco,           "Section No
         gsber     LIKE bbseg-gsber,           "Business Area
         qsskz     LIKE bbseg-qsskz,           "Withholding Tax Code
         qsshb     LIKE bbseg-qsshb,           "Withholding Tax Base Amount
         bupla     LIKE bbseg-bupla,           "Business Place
         valut     LIKE bbseg-valut,           "Valuation Date
         pernr     LIKE bbseg-pernr,           "Personal Number
         bvtyp     LIKE bbseg-bvtyp,           "
         uzawe     LIKE bbseg-uzawe,           "Payment Method Supplyament
         projk     LIKE bbseg-projk,           "WBS Element Number
         nplnr     LIKE bbseg-nplnr,           "Network Number for Account
         "Assignment
         vornr     LIKE bbseg-vornr,           "Operation/Activity Number
         zlspr     LIKE bbseg-zlspr,           "Payment Block
*----- End of Line Items -----------------------------------------------
         bewar     LIKE bbseg-bewar,           "Transaction Type
         mwskz     LIKE bbseg-mwskz,
         xmwst     LIKE bkpf-xmwst,
         newbw     LIKE bbseg-newbw,
         kkber     LIKE bbseg-kkber,
         vbel2     LIKE bbseg-vbel2,
         posn2     LIKE bbseg-posn2,
*      RKE_ARTNR  like bbseg-RKE_ARTNR,
*      RKE_BUKRS  like bbseg-RKE_BUKRS,
         rke_kndnr LIKE bbseg-rke_kndnr,
         rke_artnr LIKE bbseg-rke_artnr,
         rke_vkorg LIKE bbseg-rke_vkorg,
         rke_vtweg LIKE bbseg-rke_vtweg,
         rke_kunwe LIKE bbseg-rke_kunwe,
         rke_werks LIKE bbseg-rke_werks,
*      RKE_KAUFN  like bbseg-RKE_KAUFN,
         rke_zzsem LIKE bbseg-rke_zzsem,
         matnr     LIKE bbseg-matnr,
         menge     LIKE bbseg-menge,
         meins     LIKE bbseg-meins,
       END OF ty_download_temp.

**********Internal Table
DATA: gt_acdoca TYPE STANDARD TABLE OF ty_acdoca.
DATA: gt_xydalba TYPE STANDARD TABLE OF ty_xydalba.
DATA: gt_zevtera TYPE STANDARD TABLE OF ty_zevtera.
DATA: gt_download_temp TYPE STANDARD TABLE OF ty_download_temp.
DATA : gt_bbkpf TYPE STANDARD TABLE OF bbkpf,
       gt_bbseg TYPE STANDARD TABLE OF bbseg.

**********Work Area
DATA: gw_acdoca TYPE ty_acdoca.
DATA: gw_xydalba TYPE ty_xydalba.
DATA: gw_zevtera TYPE ty_zevtera.
DATA: gw_download_temp TYPE ty_download_temp.
DATA: gw_exchange_data TYPE  bapi1093_0.
DATA : gw_bbkpf TYPE bbkpf,
       gw_bbseg TYPE bbseg.

*--------------------------------------------
* ALV Variables
*--------------------------------------------
DATA: gt_fieldcatalog  TYPE slis_t_fieldcat_alv,
      gwa_fieldcatalog TYPE slis_fieldcat_alv,
      gv_repid         LIKE sy-repid.
DATA: is_layout TYPE slis_layout_alv.
DATA: g_repid LIKE sy-repid.
DATA: gv_posting TYPE acdoca-poper.

*--------------------------------------------
* Variables
*--------------------------------------------
DATA  col TYPE i VALUE 0.
DATA: wf_file TYPE string.
DATA: ex_rate TYPE quan1_12.
DATA: gex_date TYPE sy-datum.
DATA: p_gt_return TYPE  bapiret1.

*--------------------------------------------
* CONSTANTS
*--------------------------------------------
CONSTANTS: gc_qb1(02)   TYPE c VALUE '01',
           gc_qe1(02)   TYPE c VALUE '03',
           gc_qb2(02)   TYPE c VALUE '04',
           gc_qe2(02)   TYPE c VALUE '06',
           gc_qb3(02)   TYPE c VALUE '07',
           gc_qe3(02)   TYPE c VALUE '09',
           gc_qb4(02)   TYPE c VALUE '10',
           gc_qe4(02)   TYPE c VALUE '12',
           gc_0l        TYPE char2 VALUE '0L',
           gc_avg       TYPE char5 VALUE 'AVG',
           gc_eur       TYPE char5 VALUE 'EUR',
           gc_usd       TYPE char5 VALUE 'USD',
           gc_pf_status TYPE slis_formname VALUE 'ZSTANDARD',
           gc_ucommand  TYPE slis_formname VALUE  'HANDLE_USER_COMMAND'.
