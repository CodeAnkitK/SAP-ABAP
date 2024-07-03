*&---------------------------------------------------------------------*
*& Report ZESEAL_ERR_REN_BG
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          ZESEAL_ERR_REN_BG_TOP
*&---------------------------------------------------------------------*

TYPES: BEGIN OF ty_corr,
         request_id      TYPE zdc_eseal_log-request_id,
         cokey           TYPE zdc_eseal_log-cokey,
         cotyp           TYPE zdc_eseal_log-cotyp,
         gpart           TYPE zdc_eseal_log-gpart,
         vkont           TYPE zdc_eseal_log-vkont,
         vtref           TYPE zdc_eseal_log-vtref,
         add_gpart       TYPE zdc_eseal_log-add_gpart,
         entry_date      TYPE zdc_eseal_log-entry_date,
         changed_date    TYPE zdc_eseal_log-changed_date,
         entry_time      TYPE zdc_eseal_log-entry_time,
         changed_time    TYPE zdc_eseal_log-changed_time,
         date_sent       TYPE zdc_eseal_log-date_sent,
         time_sent       TYPE zdc_eseal_log-time_sent,
         date_received   TYPE zdc_eseal_log-date_received,
         time_received   TYPE zdc_eseal_log-time_received,
         status          TYPE zdc_eseal_log-status,
         status_desc     TYPE zdc_eseal_log-status_desc,
         error_desc      TYPE zdc_eseal_log-error_desc,
         cer_number      TYPE zdc_eseal_log-cer_number,
         version         TYPE zdc_eseal_log-version,
         new_cotyp       TYPE zdc_eseal_log-new_cotyp,
         new_cokey       TYPE zdc_eseal_log-new_cokey,
         seal_date       TYPE zdc_eseal_log-seal_date,
         seal_renew_date TYPE zdc_eseal_log-seal_renew_date,
         renewal_status  TYPE zdc_eseal_log-renewal_status,
         base64_s        TYPE zdc_eseal_log-base64_s,
         base64_r        TYPE zdc_eseal_log-base64_r,
         signature       TYPE zdc_eseal_log-signature,
       END OF ty_corr.

DATA: gs_log TYPE ty_corr.
DATA: gt_log TYPE STANDARD TABLE OF ty_corr.
DATA: gt_log_display TYPE STANDARD TABLE OF ty_corr.

***************************************
*********  ALV Grid Variables
***************************************
DATA: gs_layout    TYPE slis_layout_alv.
DATA: gt_fieldcat  TYPE slis_t_fieldcat_alv.

TABLES: zdc_eseal_log.
