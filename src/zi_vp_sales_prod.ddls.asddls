@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Product'
define root view entity ZI_VP_SALES_PROD
  as select from ztab_prod_02 as zproduct
{
  key pid as PID,
  avl_qty as AvlQty,
  @Semantics.amount.currencyCode: 'Curr'
  price as Price,
  curr as Curr,
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
