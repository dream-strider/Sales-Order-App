CLASS LHC_CUSTOMER DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Customer
        RESULT result,
      valPhone FOR VALIDATE ON SAVE
            IMPORTING keys FOR Customer~valPhone,
      valEmail FOR VALIDATE ON SAVE
            IMPORTING keys FOR Customer~valEmail.
ENDCLASS.

CLASS LHC_CUSTOMER IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD valPhone.

  "Reading Data from cds
  READ ENTITIES OF zi_vp_sales_customer IN LOCAL MODE
  ENTITY Customer FIELDS ( CustID )
  WITH CORRESPONDING #( keys )
  RESULT DATA(lt_phone).

  LOOP AT lt_phone INTO DATA(ls_phone).

  IF  STRLEN( ls_phone-Phone ) ne 10.
   " Creating the error msg in case validation fails
  DATA(lv_message) =  me->new_message(
                     id       = 'ZCM_CUS_02'
                     number   = 006
                     severity = ms-error
                     v1       = ls_phone-Phone

                   ).
   " To Display Error Pop up msg
  DATA ls_record LIKE LINE OF reported-customer.
  ls_record-%msg = lv_message.
  APPEND ls_record TO reported-customer.

  DATA ls_fail LIKE LINE OF failed-customer.
  APPEND ls_fail TO failed-customer.

  ENDIF.

  ENDLOOP.

  ENDMETHOD.

  METHOD valEmail.

 " DATA: lv_pattern TYPE string,
  "      match TYPE Flag.
  DATA: lv_tabix TYPE sy-tabix.

  " Regular Expression For an Email
 " lv_pattern = '\w+(\.\w+)*@(\w+\.)+(\w{2,4})'.

   "Reading Data from cds
  READ ENTITIES OF zi_vp_sales_customer IN LOCAL MODE
  ENTITY Customer FIELDS ( CustID )
  WITH CORRESPONDING #( keys )
  RESULT DATA(lt_email).

  LOOP AT lt_email INTO DATA(ls_email).

  FIND  ALL OCCURRENCES OF REGEX '[a-zA-Z]+[0-9]*(\.\w+)*@(\w+\.)+(\w{2,4})' IN ls_email-Email MATCH COUNT lv_tabix.

  IF lv_tabix ne 1.

    " Creating the error msg in case validation fails
  DATA(lv_message) =  me->new_message(
                     id       = 'ZCM_CUS_02'
                     number   = 007
                     severity = ms-error
                     v1       = ls_email-Email

                   ).
   " To Display Error Pop up msg
  DATA ls_record LIKE LINE OF reported-customer.
  ls_record-%msg = lv_message.
  APPEND ls_record TO reported-customer.

  DATA ls_fail LIKE LINE OF failed-customer.
  APPEND ls_fail TO failed-customer.


  ENDIF.

  ENDLOOP.

  ENDMETHOD.

ENDCLASS.
