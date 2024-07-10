*&---------------------------------------------------------------------*
*& Report ZABAP_ENHANCEMENTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZABAP_ENHANCEMENTS.
*&---------------------------------------------------------------------*
*& Enhancement Using Badi
*&---------------------------------------------------------------------*
* 01. Append Structure - Dictionary Enhancements
* 02. Create a Z (Sub) Screen Program using SE38.
* 03. Add the new structure to Z (sub) Screen.
* 04. Using SE24, go to CL_EXITHANDLER.
* 05. Click on 'GET_INSTANCE' Method. and put a break-point on
*     CALL METHOD cl_exithandler=>get_class_name_by_interface
*     Badi will come under the parameter : exit_name.
* 06. Copy the Badi name and go to SE18 and enter the Badi Name.

*&---------------------------------------------------------------------*
*& Enhancement Using CMOD
*&---------------------------------------------------------------------*
*01. Press F1. Get technical details. Copy Data element.
*02. Go to CMOD.
*03. Go to Text Enahncement => Keywords => Change
*04. Enter Data Element.

*&---------------------------------------------------------------------*
*& Implicit Enhancement - User Exit is Obsolete in 7.5
*&---------------------------------------------------------------------*
*01. Implicit enhancement points: These are basically points within ABAP code
*    where an enhancement point is implied, and in which case can be created.
*    Examples of implicit enhancement points are at the beginning and end of FORMu2019s,
*    at the end of a program, include or function module etc.

*&---------------------------------------------------------------------*
*& Business Transaction Event - BTE (Finance Module)
*&---------------------------------------------------------------------*
*01. Tcode - FIBF
*02. Find event by description and check the documentation.
