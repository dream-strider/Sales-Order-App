@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED VP Sales - Customer'

define root view entity ZI_VP_SALES_CUSTOMER
  as select from ztab_cust_02 as Customer
  
  association [0..*] to ZI_VP_SALES_HEADER1 as _Header on $projection.CustID = _Header.CustID
{
  key cust_id as CustID,
  name as Name,
  phone as Phone,
  email as Email,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.user.localInstanceLastChangedBy: true
  changed_by as ChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  
  //Association
  _Header
}
