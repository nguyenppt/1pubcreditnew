//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace BankProject.DBContext
{
    using System;
    using System.Collections.Generic;
    
    public partial class B_SellTravellersCheque
    {
        public string TTNo { get; set; }
        public string CustomerName { get; set; }
        public string CustomerAddress { get; set; }
        public string CustomerPassportNo { get; set; }
        public string CustomerPassportDateOfIssue { get; set; }
        public string CustomerPassportPlaceOfIssue { get; set; }
        public string CustomerPhoneNo { get; set; }
        public string TellerID { get; set; }
        public string TCCurrency { get; set; }
        public string DebitAccount { get; set; }
        public decimal TCAmount { get; set; }
        public string DrCurrency { get; set; }
        public string CrAccount { get; set; }
        public Nullable<decimal> AmountDebited { get; set; }
        public Nullable<decimal> ExchangeRate { get; set; }
        public string Narrative { get; set; }
        public string Status { get; set; }
        public string UserCreate { get; set; }
        public System.DateTime DateTimeCreate { get; set; }
        public string UserApprove { get; set; }
        public Nullable<System.DateTime> DateTimeApprove { get; set; }
    }
}
