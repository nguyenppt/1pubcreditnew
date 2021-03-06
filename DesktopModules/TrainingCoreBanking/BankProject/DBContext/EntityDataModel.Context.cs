﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Objects;
    using System.Data.Objects.DataClasses;
    using System.Linq;
    
    public partial class VietVictoryCoreBankingEntities : DbContext
    {
        public VietVictoryCoreBankingEntities()
            : base("name=VietVictoryCoreBankingEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public DbSet<B_AccountForBuyingTC> B_AccountForBuyingTC { get; set; }
        public DbSet<B_CashWithrawalForBuyingTC> B_CashWithrawalForBuyingTC { get; set; }
        public DbSet<B_CustomerSignature> B_CustomerSignature { get; set; }
        public DbSet<B_DEBUG> B_DEBUG { get; set; }
        public DbSet<B_ExchangeRates> B_ExchangeRates { get; set; }
        public DbSet<B_ImportLCPayment> B_ImportLCPayment { get; set; }
        public DbSet<B_ImportLCPaymentCharge> B_ImportLCPaymentCharge { get; set; }
        public DbSet<B_SellTravellersCheque> B_SellTravellersCheque { get; set; }
        public DbSet<BACCOUNTOFFICER> BACCOUNTOFFICERs { get; set; }
        public DbSet<BACCOUNT> BACCOUNTS { get; set; }
        public DbSet<BADVISINGANDNEGOTIATION> BADVISINGANDNEGOTIATIONs { get; set; }
        public DbSet<BADVISINGANDNEGOTIATION_CHARGES> BADVISINGANDNEGOTIATION_CHARGES { get; set; }
        public DbSet<BBANK_BRANCH> BBANK_BRANCH { get; set; }
        public DbSet<BBANKCODE> BBANKCODEs { get; set; }
        public DbSet<BBANKING> BBANKINGs { get; set; }
        public DbSet<BBANKSWIFTCODE> BBANKSWIFTCODEs { get; set; }
        public DbSet<BBENEFICIARYBANK> BBENEFICIARYBANKs { get; set; }
        public DbSet<BCASHDEPOSIT> BCASHDEPOSITs { get; set; }
        public DbSet<BCASHWITHRAWAL> BCASHWITHRAWALs { get; set; }
        public DbSet<BCATEGORY> BCATEGORies { get; set; }
        public DbSet<BCHARGECODE> BCHARGECODEs { get; set; }
        public DbSet<BCHEQUEISSUE> BCHEQUEISSUEs { get; set; }
        public DbSet<BCHEQUESTATU> BCHEQUESTATUS { get; set; }
        public DbSet<BCHEQUETYPE> BCHEQUETYPEs { get; set; }
        public DbSet<BCOLLATERAL> BCOLLATERALs { get; set; }
        public DbSet<BCOLLATERAL_INFOMATION> BCOLLATERAL_INFOMATION { get; set; }
        public DbSet<BCOLLATERAL_STATUS> BCOLLATERAL_STATUS { get; set; }
        public DbSet<BCOLLATERALCONTINGENT_ENTRY> BCOLLATERALCONTINGENT_ENTRY { get; set; }
        public DbSet<BCOLLATERALRIGHT> BCOLLATERALRIGHTs { get; set; }
        public DbSet<BCOLLECTCHARGESBYCASH> BCOLLECTCHARGESBYCASHes { get; set; }
        public DbSet<BCOLLECTCHARGESFROMACCOUNT> BCOLLECTCHARGESFROMACCOUNTs { get; set; }
        public DbSet<BCOMMITMENT_CONTRACT> BCOMMITMENT_CONTRACT { get; set; }
        public DbSet<BCOMMODITY> BCOMMODITies { get; set; }
        public DbSet<BCONFIG> BCONFIGs { get; set; }
        public DbSet<BCONTINGENTACCOUNT> BCONTINGENTACCOUNTS { get; set; }
        public DbSet<B_COUNTRY> B_COUNTRY { get; set; }
        public DbSet<BCRFROMACCOUNT> BCRFROMACCOUNTs { get; set; }
        public DbSet<BCURRENCY> BCURRENCies { get; set; }
        public DbSet<BCUSTOMER_INFO> BCUSTOMER_INFO { get; set; }
        public DbSet<BCUSTOMER_LIMIT_MAIN> BCUSTOMER_LIMIT_MAIN { get; set; }
        public DbSet<BCUSTOMER_LIMIT_SUB> BCUSTOMER_LIMIT_SUB { get; set; }
        public DbSet<BCUSTOMER> BCUSTOMERS { get; set; }
        public DbSet<BDEPOSITACCT> BDEPOSITACCTS { get; set; }
        public DbSet<BDOCUMETARYCOLLECTION> BDOCUMETARYCOLLECTIONs { get; set; }
        public DbSet<BDOCUMETARYCOLLECTIONCHARGE> BDOCUMETARYCOLLECTIONCHARGES { get; set; }
        public DbSet<BDOCUMETARYCOLLECTIONMT410> BDOCUMETARYCOLLECTIONMT410 { get; set; }
        public DbSet<BDRAWTYPE> BDRAWTYPEs { get; set; }
        public DbSet<BDRFROMACCOUNT> BDRFROMACCOUNTs { get; set; }
        public DbSet<BDYNAMICCONTROL> BDYNAMICCONTROLS { get; set; }
        public DbSet<BDYNAMICDATA> BDYNAMICDATAs { get; set; }
        public DbSet<BENCOM> BENCOMs { get; set; }
        public DbSet<BENQUIRYCHECK> BENQUIRYCHECKs { get; set; }
        public DbSet<BEXPORT_DOCUMETARYCOLLECTION> BEXPORT_DOCUMETARYCOLLECTION { get; set; }
        public DbSet<BEXPORT_LC_ADV_NEGO> BEXPORT_LC_ADV_NEGO { get; set; }
        public DbSet<BFOREIGNEXCHANGE> BFOREIGNEXCHANGEs { get; set; }
        public DbSet<BFREETEXTMESSAGE> BFREETEXTMESSAGEs { get; set; }
        public DbSet<BIMPORT_DOCUMENTPROCESSING> BIMPORT_DOCUMENTPROCESSING { get; set; }
        public DbSet<BIMPORT_DOCUMENTPROCESSING_CHARGE> BIMPORT_DOCUMENTPROCESSING_CHARGE { get; set; }
        public DbSet<BIMPORT_DOCUMENTPROCESSING_MT734> BIMPORT_DOCUMENTPROCESSING_MT734 { get; set; }
        public DbSet<BIMPORT_NORMAILLC> BIMPORT_NORMAILLC { get; set; }
        public DbSet<BIMPORT_NORMAILLC_CHARGE> BIMPORT_NORMAILLC_CHARGE { get; set; }
        public DbSet<BIMPORT_NORMAILLC_MT700> BIMPORT_NORMAILLC_MT700 { get; set; }
        public DbSet<BIMPORT_NORMAILLC_MT707> BIMPORT_NORMAILLC_MT707 { get; set; }
        public DbSet<BIMPORT_NORMAILLC_MT740> BIMPORT_NORMAILLC_MT740 { get; set; }
        public DbSet<BINCOMINGCOLLECTIONPAYMENT> BINCOMINGCOLLECTIONPAYMENTs { get; set; }
        public DbSet<BINCOMINGCOLLECTIONPAYMENTCHARGE> BINCOMINGCOLLECTIONPAYMENTCHARGES { get; set; }
        public DbSet<BINCOMINGCOLLECTIONPAYMENTMT202> BINCOMINGCOLLECTIONPAYMENTMT202 { get; set; }
        public DbSet<BINCOMINGCOLLECTIONPAYMENTMT400> BINCOMINGCOLLECTIONPAYMENTMT400 { get; set; }
        public DbSet<BINDUSTRY> BINDUSTRies { get; set; }
        public DbSet<BINTEREST_RATE> BINTEREST_RATE { get; set; }
        public DbSet<BINTEREST_TERM> BINTEREST_TERM { get; set; }
        public DbSet<BINTERNALBANKACCOUNT> BINTERNALBANKACCOUNTs { get; set; }
        public DbSet<BINTERNALBANKPAYMENTACCOUNT> BINTERNALBANKPAYMENTACCOUNTs { get; set; }
        public DbSet<BLCTYPE> BLCTYPES { get; set; }
        public DbSet<BLDACCOUNT> BLDACCOUNTs { get; set; }
        public DbSet<BLOANGROUP> BLOANGROUPs { get; set; }
        public DbSet<BLOANPURPOSE> BLOANPURPOSEs { get; set; }
        public DbSet<BLOANWORKINGACCOUNT> BLOANWORKINGACCOUNTS { get; set; }
        public DbSet<BMACODE> BMACODEs { get; set; }
        public DbSet<BMENUTOP> BMENUTOPs { get; set; }
        public DbSet<BNewLoanControl> BNewLoanControls { get; set; }
        public DbSet<BOPENACCOUNT> BOPENACCOUNTs { get; set; }
        public DbSet<BOPENACCOUNT_COPY> BOPENACCOUNT_COPY { get; set; }
        public DbSet<BOPENACCOUNT_INTEREST> BOPENACCOUNT_INTEREST { get; set; }
        public DbSet<BOUTGOINGCOLLECTIONPAYMENT> BOUTGOINGCOLLECTIONPAYMENTs { get; set; }
        public DbSet<BOUTGOINGCOLLECTIONPAYMENTCHARGE> BOUTGOINGCOLLECTIONPAYMENTCHARGES { get; set; }
        public DbSet<BOUTGOINGCOLLECTIONPAYMENTMT910> BOUTGOINGCOLLECTIONPAYMENTMT910 { get; set; }
        public DbSet<BOVERSEASTRANSFER> BOVERSEASTRANSFERs { get; set; }
        public DbSet<BOVERSEASTRANSFERCHARGECOMMISSION> BOVERSEASTRANSFERCHARGECOMMISSIONs { get; set; }
        public DbSet<BOVERSEASTRANSFERMT103> BOVERSEASTRANSFERMT103 { get; set; }
        public DbSet<BPaymentFrequenceControl> BPaymentFrequenceControls { get; set; }
        public DbSet<BPAYMENTMETHOD> BPAYMENTMETHODs { get; set; }
        public DbSet<BPLACCOUNT> BPLACCOUNTs { get; set; }
        public DbSet<BPRODUCTLINE> BPRODUCTLINEs { get; set; }
        public DbSet<BPRODUCTTYPE> BPRODUCTTYPEs { get; set; }
        public DbSet<BPROVINCE> BPROVINCEs { get; set; }
        public DbSet<BRELATIONCODE> BRELATIONCODEs { get; set; }
        public DbSet<BRESTRICT_TXN> BRESTRICT_TXN { get; set; }
        public DbSet<BRPODCATEGORY> BRPODCATEGORies { get; set; }
        public DbSet<BSalaryPaymentFrequency> BSalaryPaymentFrequencies { get; set; }
        public DbSet<BSalaryPaymentFrequencyDetail> BSalaryPaymentFrequencyDetails { get; set; }
        public DbSet<BSalaryPaymentFrequencyTerm> BSalaryPaymentFrequencyTerms { get; set; }
        public DbSet<BSalaryPaymentMethod> BSalaryPaymentMethods { get; set; }
        public DbSet<BSAVING_ACC_ARREAR> BSAVING_ACC_ARREAR { get; set; }
        public DbSet<BSAVING_ACC_DISCOUNTED> BSAVING_ACC_DISCOUNTED { get; set; }
        public DbSet<BSAVING_ACC_INTEREST> BSAVING_ACC_INTEREST { get; set; }
        public DbSet<BSAVING_ACC_PERIODIC> BSAVING_ACC_PERIODIC { get; set; }
        public DbSet<BSECTOR> BSECTORs { get; set; }
        public DbSet<BSWIFTCODE> BSWIFTCODEs { get; set; }
        public DbSet<BTRANSFERWITHDRAWAL> BTRANSFERWITHDRAWALs { get; set; }
        public DbSet<PROVISIONTRANSFER_DC> PROVISIONTRANSFER_DC { get; set; }
        public DbSet<Sochu> Sochus { get; set; }
        public DbSet<sysdiagram> sysdiagrams { get; set; }
        public DbSet<BLOANINTEREST_KEY> BLOANINTEREST_KEY { get; set; }
        public DbSet<BNEWNORMALLOAN> BNEWNORMALLOANs { get; set; }
        public DbSet<B_LOAN_CREDIT_SCORING> B_LOAN_CREDIT_SCORING { get; set; }
        public DbSet<B_NORMALLOAN_PAYMENT_SCHEDULE> B_NORMALLOAN_PAYMENT_SCHEDULE { get; set; }
    
        public virtual ObjectResult<string> B_BMACODE_GetNewID(string maCode, string refix, string flat)
        {
            var maCodeParameter = maCode != null ?
                new ObjectParameter("MaCode", maCode) :
                new ObjectParameter("MaCode", typeof(string));
    
            var refixParameter = refix != null ?
                new ObjectParameter("Refix", refix) :
                new ObjectParameter("Refix", typeof(string));
    
            var flatParameter = flat != null ?
                new ObjectParameter("Flat", flat) :
                new ObjectParameter("Flat", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("B_BMACODE_GetNewID", maCodeParameter, refixParameter, flatParameter);
        }
    
        public virtual ObjectResult<B_BRPODCATEGORY_GetAll_IdOver200_Result> B_BRPODCATEGORY_GetAll_IdOver200()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<B_BRPODCATEGORY_GetAll_IdOver200_Result>("B_BRPODCATEGORY_GetAll_IdOver200");
        }
    
        public virtual ObjectResult<BOPENACCOUNT_LOANACCOUNT_GetByCode_Result> BOPENACCOUNT_LOANACCOUNT_GetByCode(string customerID, string currency)
        {
            var customerIDParameter = customerID != null ?
                new ObjectParameter("CustomerID", customerID) :
                new ObjectParameter("CustomerID", typeof(string));
    
            var currencyParameter = currency != null ?
                new ObjectParameter("Currency", currency) :
                new ObjectParameter("Currency", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<BOPENACCOUNT_LOANACCOUNT_GetByCode_Result>("BOPENACCOUNT_LOANACCOUNT_GetByCode", customerIDParameter, currencyParameter);
        }
    
        public virtual ObjectResult<BOPENACCOUNT_INTEREST_GetByCode_Result> BOPENACCOUNT_INTEREST_GetByCode(Nullable<int> accountCode)
        {
            var accountCodeParameter = accountCode.HasValue ?
                new ObjectParameter("AccountCode", accountCode) :
                new ObjectParameter("AccountCode", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<BOPENACCOUNT_INTEREST_GetByCode_Result>("BOPENACCOUNT_INTEREST_GetByCode", accountCodeParameter);
        }
    
        public virtual ObjectResult<BOPENACCOUNT_INTEREST_GetById_Result> BOPENACCOUNT_INTEREST_GetById(Nullable<int> accountid)
        {
            var accountidParameter = accountid.HasValue ?
                new ObjectParameter("Accountid", accountid) :
                new ObjectParameter("Accountid", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<BOPENACCOUNT_INTEREST_GetById_Result>("BOPENACCOUNT_INTEREST_GetById", accountidParameter);
        }
    
        public virtual ObjectResult<BOPENACCOUNT_INTERNAL_GetByCode_Result> BOPENACCOUNT_INTERNAL_GetByCode(string accountType, string customerID, string currency, string differCode)
        {
            var accountTypeParameter = accountType != null ?
                new ObjectParameter("AccountType", accountType) :
                new ObjectParameter("AccountType", typeof(string));
    
            var customerIDParameter = customerID != null ?
                new ObjectParameter("CustomerID", customerID) :
                new ObjectParameter("CustomerID", typeof(string));
    
            var currencyParameter = currency != null ?
                new ObjectParameter("Currency", currency) :
                new ObjectParameter("Currency", typeof(string));
    
            var differCodeParameter = differCode != null ?
                new ObjectParameter("DifferCode", differCode) :
                new ObjectParameter("DifferCode", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<BOPENACCOUNT_INTERNAL_GetByCode_Result>("BOPENACCOUNT_INTERNAL_GetByCode", accountTypeParameter, customerIDParameter, currencyParameter, differCodeParameter);
        }
    
        public virtual ObjectResult<Nullable<int>> B_Normal_Loan_Process_Payment(Nullable<System.DateTime> endDateProcess)
        {
            var endDateProcessParameter = endDateProcess.HasValue ?
                new ObjectParameter("EndDateProcess", endDateProcess) :
                new ObjectParameter("EndDateProcess", typeof(System.DateTime));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<Nullable<int>>("B_Normal_Loan_Process_Payment", endDateProcessParameter);
        }
    
        public virtual ObjectResult<Nullable<decimal>> B_Normal_Loan_Get_RemainLimitAmount(string limitReferenceCode)
        {
            var limitReferenceCodeParameter = limitReferenceCode != null ?
                new ObjectParameter("LimitReferenceCode", limitReferenceCode) :
                new ObjectParameter("LimitReferenceCode", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<Nullable<decimal>>("B_Normal_Loan_Get_RemainLimitAmount", limitReferenceCodeParameter);
        }
    
        public virtual ObjectResult<Nullable<System.DateTime>> B_Normal_Loan_Get_OfferedUntilDate(string limitReferenceCode)
        {
            var limitReferenceCodeParameter = limitReferenceCode != null ?
                new ObjectParameter("LimitReferenceCode", limitReferenceCode) :
                new ObjectParameter("LimitReferenceCode", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<Nullable<System.DateTime>>("B_Normal_Loan_Get_OfferedUntilDate", limitReferenceCodeParameter);
        }
    
        public virtual ObjectResult<B_Normal_Loan_Get_Productline_Info_Result> B_Normal_Loan_Get_Productline_Info(string limitReferenceCode)
        {
            var limitReferenceCodeParameter = limitReferenceCode != null ?
                new ObjectParameter("LimitReferenceCode", limitReferenceCode) :
                new ObjectParameter("LimitReferenceCode", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<B_Normal_Loan_Get_Productline_Info_Result>("B_Normal_Loan_Get_Productline_Info", limitReferenceCodeParameter);
        }
    }
}
