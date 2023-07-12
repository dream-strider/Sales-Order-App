@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZI_VP_SALES_PROD'
@ObjectModel.semanticKey: [ 'PID' ]
define root view entity ZC_VP_SALES_PRODUCT
  provider contract transactional_query
  as projection on ZI_VP_SALES_PROD
{
  key PID,
  AvlQty,
  Price,
  Curr,
  LastChangedAt
  
}
