@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED rap generated employee cds'

define root view entity ZI_VP_SALES_EMP
  as select from ztab_emp_02 as employee_view
{
  key emp_id as EmpID,
  name as Name,
  dob as Dob,
  des as Des,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.user.localInstanceLastChangedBy: true
  changed_by as ChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  local_last_changed_at as LocalLastChangedAt
  
}
