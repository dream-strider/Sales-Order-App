@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZI_VP_SALES_CUSTOMER'
@ObjectModel.semanticKey: [ 'CustID' ]
define root view entity ZC_VP_SALES_CUSTOMER
  provider contract transactional_query
  as projection on ZI_VP_SALES_CUSTOMER
{
  key CustID,
  Name,
  Phone,
  Email,
  LastChangedAt,
  // Association
  _Header
  
}
