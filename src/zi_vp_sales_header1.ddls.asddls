@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Sales Header'
define root view entity ZI_VP_SALES_HEADER1
  as select from ztab_sheader as sales_header
//  left outer join ZI_VP_SALES_CUSTOMER on sales_header.cust_id = ZI_VP_SALES_CUSTOMER.CustID
//  left outer join ZI_VP_SALES_EMP on sales_header.emp_id = ZI_VP_SALES_EMP.EmpID
  composition [0..*] of ZI_VP_SALES_ITEM1 as _Item
 
  association[0..1] to ZI_VP_SALES_CUSTOMER   as _Customer on $projection.CustID = _Customer.CustID
  association[0..1] to ZI_VP_SALES_EMP as _Employee on $projection.EmpID = _Employee.EmpID
{
  key sales_header.sales_id as SalesID,
  sales_header.cust_id as CustID,
  sales_header.emp_id as EmpID,
  sales_header.descrip as Descrip,
  @Semantics.systemDateTime.createdAt: true
  sales_header.created_at as CreatedAt,
  @Semantics.user.createdBy: true
  sales_header.created_by as CreatedBy,
  @Semantics.user.localInstanceLastChangedBy: true
  sales_header.changed_by as ChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
 sales_header.last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  sales_header.local_last_changed_at as LocalLastChangedAt,
  
  
  _Item,
  //Join  for customer Fields
//  ZI_VP_SALES_CUSTOMER.Name as Name,
//  ZI_VP_SALES_CUSTOMER.Email as Email,
//  ZI_VP_SALES_CUSTOMER.Phone as Phone,
  
  //Join for Employee Fields
 //  ZI_VP_SALES_EMP.Name as EmpName,
 //  ZI_VP_SALES_EMP.Dob as Dob,
 //  ZI_VP_SALES_EMP.Des,
  
  // Association
  _Customer,
  _Employee
  
}
