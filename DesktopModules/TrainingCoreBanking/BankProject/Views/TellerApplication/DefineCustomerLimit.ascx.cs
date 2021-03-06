﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Telerik.Web.UI;
using BankProject.DataProvider;
using BankProject.DBRespository;

namespace BankProject.Views.TellerApplication
{
    public partial class DefineCustomerLimit : DotNetNuke.Entities.Modules.PortalModuleBase
    {
        public Boolean Enable_toAudit = false;
        public static Boolean is_New_edit_hanMucCha = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            FirstLoad();
            if ( Request.QueryString["MainLimitID"] != null)
            {
                LoadToolBar_AllFalse();
                BankProject.Controls.Commont.SetTatusFormControls(this.Controls, false);
                var GlobalLimitID = Request.QueryString["MainLimitID"].ToString();
                Load_MainLimit_DataToReview(GlobalLimitID);
            }
            else
            {
                LoadToolBar(true);
            }
        }
       
        
        protected void RadToolBar1_ButtonClick(object sender, RadToolBarEventArgs e)
        {
            string LimitID = tbLimitID.Text.Trim();
            var toolBarButton = e.Item as RadToolBarButton;
            var commandName = toolBarButton.CommandName;
            switch(commandName)
            {
                case "commit":
                if(LimitID.Length == 12)//kime tra khi nhap han muc cha
                {
                    string CustomerID = LimitID.Substring(0,7);
                    string HanMucCha = LimitID.Substring(8,4);
                    string MainID = LimitID.Substring(0,12); // lay Main ID k co STT
                    if(HanMucCha =="7000" || HanMucCha =="8000") // check han muc cha
                    {
                        if (rcbFandA.SelectedValue == "Variable") { ShowMsgBox("Fixed/Variable value must be “Fixed”"); return; }
                        // check Internal amount and Maximum Total
                        if ((tbIntLimitAmt.Text != "" ? Convert.ToDecimal(tbIntLimitAmt.Text.Replace(",", "")) : 0 )<( tbMaxTotal.Text != "" ? Convert.ToDecimal(tbMaxTotal.Text.Replace(",", "")) : 0))
                        { ShowMsgBox("Maximum Total Amount must be less than Internal Limit Amount, Please check again !"); return; }
                        //if (TriTT.B_CUSTOMER_LIMIT_Check_LimitMain_CustomerID_Exists(LimitID,CustomerID).Tables != null &&
                        //    TriTT.B_CUSTOMER_LIMIT_Check_LimitMain_CustomerID_Exists(LimitID, CustomerID).Tables[0].Rows.Count>0 )
                        //{ 
                        //    var ds = TriTT.B_CUSTOMER_LIMIT_Check_LimitMain_CustomerID_Exists(LimitID, CustomerID).Tables[0];
                        //    if (ds.Rows[0]["CommitmentType"].ToString() == "7000")
                        //    {
                        //        ShowMsgBox("You had already created a Revoling Global Limit. You can not create additional one.");
                        //        return;
                        //    }
                        //    else 
                        //    {
                        //        ShowMsgBox("You had already created a Non-Revolving Global Limit. You can not create additional one.");
                        //        return;
                        //    }
                        //}
                        if (TriTT.B_CUSTOMER_LIMIT_Check_CustomerID(CustomerID) != "Not_Exists")
                        { 
                            TriTT.B_CUSTOMER_LIMIT_Insert_Update(LimitID, CustomerID, HanMucCha, rcbCurrency.SelectedValue, rcbCountry.SelectedValue, rcbCountry.Text.Replace(rcbCountry.SelectedValue + " - ", "")
                                , RdpApprovedDate.SelectedDate, RdpOfferedUnit.SelectedDate, rdpExpiryDate.SelectedDate, RdpProposalDate.SelectedDate, RdpAvailableDate.SelectedDate
                                ,tbIntLimitAmt.Text!=""? Convert.ToDecimal(tbIntLimitAmt.Text.Replace(",", "")):0, tbAdvisedAmt.Text!=""? Convert.ToDecimal(tbAdvisedAmt.Text.Replace(",", "")):0,0 ,
                                tbNote.Text, rcbFandA.SelectedValue,tbMaxTotal.Text !=""?  Convert.ToDecimal(tbMaxTotal.Text.Replace(",", "")) : 0, UserInfo.Username.ToString()
                                , tbMaxSecured.Text != "" ? Convert.ToDecimal(tbMaxSecured.Text.Replace(",", "")) : 0, tbMaxUnsecured.Text != "" ? Convert.ToDecimal(tbMaxUnsecured.Text.Replace(",", "")) : 0);
                            Response.Redirect("Default.aspx?tabid=192");
                        }
                        else { ShowMsgBox("Customer ID is not exists, Please check again !"); return; }
                    }
                    else { ShowMsgBox("Revoling Limit ID or Non-Revoling Limit ID is Incorrect, '7000' for Revoling and '8000' for Non-Revolving, Please check again !"); return; }
                }
                break;
                case "search" :
                if (LimitID.Length == 12)
                {
                    Load_MainLimit_ForLimitDetail(LimitID);
                }
                else if (LimitID.Length == 15)
                {
                    Load_SubLimit_DataToReview(LimitID);
                }
                break;
                case "edit":
                     BankProject.Controls.Commont.SetTatusFormControls(this.Controls, true);
                    RadToolBar1.FindItemByValue("btCommitData").Enabled = true;
                    RadToolBar1.FindItemByValue("btEdit").Enabled = false;
                    switch (tbLimitID.Text.Length)
                    { 
                        case 12:
                            rcbCollateral.Enabled = rcbCollateralType.Enabled = rcbFandA.Enabled = false;
                            break;
                    }
                    if (is_New_edit_hanMucCha == true)
                    {
                        rcbFandA.SelectedIndex = 0;
                        rcbCollateral.Enabled = rcbCollateralType.Enabled = rcbFandA.Enabled = false;
                        is_New_edit_hanMucCha = false;
                    }
                break;
            }
        }
        protected void Load_MainLimit_DataToReview(String LimitID)
        {
            BankProject.Controls.Commont.SetEmptyFormControls(this.Controls);
            tbLimitID.Text = LimitID;
            DataSet ds = TriTT.B_CUSTOMER_LIMIT_Load_Customer_Limit(LimitID);
            if (ds.Tables != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                if (LimitID.Length == 15)
                {
                    tbLimitID.Text = ds.Tables[0].Rows[0]["MainLimitID"].ToString();
                    rcbFandA.SelectedIndex = 1;
                }
                rcbCurrency.SelectedValue = ds.Tables[0].Rows[0]["CurrencyCode"].ToString();
                rcbCountry.SelectedValue = ds.Tables[0].Rows[0]["CountryCode"].ToString();
                if (ds.Tables[0].Rows[0]["ApprovedDate"].ToString() != "")
                {
                    RdpApprovedDate.SelectedDate = DateTime.Parse(ds.Tables[0].Rows[0]["ApprovedDate"].ToString());
                }
                if (ds.Tables[0].Rows[0]["OfferedUntil"].ToString() != "")
                {
                    RdpOfferedUnit.SelectedDate = DateTime.Parse(ds.Tables[0].Rows[0]["OfferedUntil"].ToString());
                }
                if (ds.Tables[0].Rows[0]["ExpiryDate"].ToString() != "")
                {
                    rdpExpiryDate.SelectedDate = DateTime.Parse(ds.Tables[0].Rows[0]["ExpiryDate"].ToString());
                }
                if (ds.Tables[0].Rows[0]["ProposalDate"].ToString() != "")
                {
                    RdpProposalDate.SelectedDate = DateTime.Parse(ds.Tables[0].Rows[0]["ProposalDate"].ToString());
                }
                if (ds.Tables[0].Rows[0]["Availabledate"].ToString() != "")
                {
                    RdpAvailableDate.SelectedDate = DateTime.Parse(ds.Tables[0].Rows[0]["Availabledate"].ToString());
                }
                tbIntLimitAmt.Text = ds.Tables[0].Rows[0]["InternalLimitAmt"].ToString();
                tbAdvisedAmt.Text = ds.Tables[0].Rows[0]["AdvisedAmt"].ToString();
                tbOriginalLimit.Text = ds.Tables[0].Rows[0]["OriginalLimit"].ToString();
                tbNote.Text = ds.Tables[0].Rows[0]["Note"].ToString();
                rcbFandA.SelectedValue = ds.Tables[0].Rows[0]["Mode"].ToString();
                tbMaxTotal.Text = ds.Tables[0].Rows[0]["MaxTotal"].ToString();
                tbMaxSecured.Text = ds.Tables[0].Rows[0]["MaxUnSecured"].ToString();
                tbMaxUnsecured.Text = ds.Tables[0].Rows[0]["MaxSecured"].ToString();
            }
        }
        protected void Load_SubLimit_DataToReview(string SubLimitID)
        {
            BankProject.Controls.Commont.SetEmptyFormControls(this.Controls); //xoa du lieu truoc' do tren form, gan lai gia tri moi' cho Item
            string CustomerID = SubLimitID.Substring(0, 7);
            string HanMucCon = SubLimitID.Substring(8, 4);
            string STTSub = SubLimitID.Substring(13, 2);
            string KieuHanMuc = "";
            if (HanMucCon == "7700") {  KieuHanMuc = "7000"; }
            else if (HanMucCon == "8700") {  KieuHanMuc = "8000"; }
            Load_MainLimit_DataToReview(CustomerID + "." + KieuHanMuc);
            tbLimitID.Text = SubLimitID;

            if (TriTT.B_CUSTOMER_LIMIT_LoadCustomerName(SubLimitID.Substring(0, 7)) != null)  // lay customreID
            {
                lblCheckCustomerName.Text = "";
                lblCustomerName.Text = TriTT.B_CUSTOMER_LIMIT_LoadCustomerName(SubLimitID.Substring(0, 7)).ToString();
            }
            else { lblCheckCustomerName.Text = "Customer does not exist !"; }
            rcbCollateral.Enabled = rcbCollateralType.Enabled = rcbFandA.Enabled = true;// cho phep chinh sua khi tao han muc con
            rcbFandA.SelectedIndex = 1; // mac dinh gan la variable;
            rcbFandA.Enabled = false;
            DataSet ds1 = TriTT.B_CUSTOMER_LIMIT_SUB_Load_for_tab_ORTHER_DETAILS(SubLimitID);
            if (ds1.Tables != null && ds1.Tables.Count > 0 && ds1.Tables[0].Rows.Count > 0)
            {
                //= ds1.Tables[0].Rows[0]["SubLimitID"].ToString();
                rcbFandA.SelectedValue = "Variable"; // gan mac dinh khi chua tao han muc con 
                rcbFandA.SelectedValue = ds1.Tables[0].Rows[0]["Mode"].ToString();// gan lai gia tri Khi han muc con da duoc tao
                rcbCollateralType.SelectedValue = ds1.Tables[0].Rows[0]["CollateralTypeCode"].ToString();
                rcbCollateralType.Text = rcbCollateralType.SelectedValue+" - "+ ds1.Tables[0].Rows[0]["CollateralTypeName"].ToString();
                LoadCollateralCode(rcbCollateralType.SelectedValue);

                rcbCollateral.SelectedValue = ds1.Tables[0].Rows[0]["CollateralCode"].ToString();
                rcbCollateral.Text = rcbCollateral.SelectedValue + " - " + ds1.Tables[0].Rows[0]["CollateralName"].ToString();
                lblCollReqdAmt.Text = ds1.Tables[0].Rows[0]["CollReqdAmt"].ToString();
                lblColReqdPct.Text = ds1.Tables[0].Rows[0]["CollReqdPct"].ToString();
                lblUpToPeriod.Text = ds1.Tables[0].Rows[0]["UptoPeriod"].ToString();
                lblPeriodAmt.Text = ds1.Tables[0].Rows[0]["PeriodAmt"].ToString();
                lblPeriodPct.Text = ds1.Tables[0].Rows[0]["PeriodPct"].ToString();
                tbMaxSecured.Text = ds1.Tables[0].Rows[0]["MaxSecured"].ToString();
                tbMaxUnsecured.Text = ds1.Tables[0].Rows[0]["MaxUnSecured"].ToString();
                tbMaxTotal.Text = ds1.Tables[0].Rows[0]["MaxTotal"].ToString();
                lblOtherSecured.Text = ds1.Tables[0].Rows[0]["OtherSecured"].ToString();
                lblCollateralRight.Text = ds1.Tables[0].Rows[0]["CollateralRight"].ToString();
                lblCollateralAmt.Text = ds1.Tables[0].Rows[0]["AmtSecured"].ToString();
                //lblOnlineLimit.Text = ds1.Tables[0].Rows[0]["Onlinelimit"].ToString();
                //lblAvailableAmt.Text = ds1.Tables[0].Rows[0]["AvailableAmt"].ToString();
                //lblTotalOutstand.Text = ds1.Tables[0].Rows[0]["TotalOutstand"].ToString();

                getOrderDetait(SubLimitID);

                LoadToolBar_AllFalse();
                BankProject.Controls.Commont.SetTatusFormControls(this.Controls, false);
                Enable_toAudit = true; // flag cho phep audit thong tin , Acct exists trong DB roi

            }
        }

        private void getOrderDetait(String SubLimitID)
        {
            decimal rateusd = 1;
            ExchangeRatesRepository exchangeFacade = new ExchangeRatesRepository();
            var exchangeRate = exchangeFacade.GetRate("USD").FirstOrDefault();
            if (exchangeRate != null)
            {
                rateusd = exchangeRate.Rate;
            }

            decimal amtVND = 0;
            decimal amtUSD = 0;
            DataSet ds3 = TriTT.B_CUSTOMER_LIMIT_SUB_Load_them_data_AvailableAmt(SubLimitID.Substring(0, 7), "VND", "AvailableAmt");
            if (ds3.Tables != null && ds3.Tables.Count > 0 && ds3.Tables[0].Rows.Count > 0)
            {

                decimal.TryParse(ds3.Tables[0].Rows[0]["Avaiable_Amt"].ToString(), out amtVND);
            }
            DataSet ds31 = TriTT.B_CUSTOMER_LIMIT_SUB_Load_them_data_AvailableAmt(SubLimitID.Substring(0, 7), "USD", "AvailableAmt");
            if (ds3.Tables != null && ds3.Tables.Count > 0 && ds3.Tables[0].Rows.Count > 0)
            {

                decimal.TryParse(ds31.Tables[0].Rows[0]["Avaiable_Amt"].ToString(), out amtUSD);
                amtUSD = amtUSD * rateusd;
            }
            lblAvailableAmt.Text = (amtUSD + amtVND).ToString("#,##.00");

            decimal outVND = 0;
            decimal outUSD = 0;
            DataSet ds4 = TriTT.B_CUSTOMER_LIMIT_SUB_Load_them_data_AvailableAmt(SubLimitID.Substring(0, 7), "VND", "OutstandingAmt");
            if (ds4.Tables != null && ds4.Tables.Count > 0 && ds4.Tables[0].Rows.Count > 0)
            {
                decimal.TryParse(ds4.Tables[0].Rows[0]["Outstanding_Loan_Amt"].ToString(), out outVND);
            }
            DataSet ds41 = TriTT.B_CUSTOMER_LIMIT_SUB_Load_them_data_AvailableAmt(SubLimitID.Substring(0, 7), "USD", "OutstandingAmt");
            if (ds4.Tables != null && ds4.Tables.Count > 0 && ds4.Tables[0].Rows.Count > 0)
            {
                decimal.TryParse(ds41.Tables[0].Rows[0]["Outstanding_Loan_Amt"].ToString(), out outUSD);
                outUSD = outUSD * rateusd;
            }

            lblTotalOutstand.Text = (outVND + outUSD).ToString("#,##.00");


            lblOnlineLimit.Text = TriTT.B_CUSTOMER_LIMIT_SUB_Load_them_data_TotalLimit(SubLimitID.Substring(0, 7));//load theo yeu cau cua nghiep vu 
            lblExchangeRate.Text = rateusd.ToString("#,###.##");
        }

        protected void btSearch_Click1(object sender, EventArgs e)
        {
            string LimitID = tbLimitID.Text;
            if (LimitID.Length == 12)
            {
                Load_MainLimit_ForLimitDetail(LimitID);
            }
            else if (LimitID.Length == 15)
            {
                Load_SubLimit_DataToReview(LimitID);
            }
        } 
        protected void ShowMsgBox(string contents, int width = 420, int hiegth = 150)
        {
            string radalertscript =
                "<script language='javascript'>function f(){radalert('" + contents + "', " + width + ", '" + hiegth +
                "', 'Warning'); Sys.Application.remove_load(f);}; Sys.Application.add_load(f);</script>";
            Page.ClientScript.RegisterStartupScript(this.GetType(), "radalert", radalertscript);
        }
        protected void Load_MainLimit_ForLimitDetail(String LimitID)
        {
            //if (TriTT.B_CUSTOMER_LIMIT_LoadCustomerName(LimitID.Substring(0, 7)) != null)
            //{
            //    lblCheckCustomerName.Text = ""; 
            //    lblCustomerName.Text = TriTT.B_CUSTOMER_LIMIT_LoadCustomerName(LimitID.Substring(0, 7)).ToString();
            //}
            //else { lblCheckCustomerName.Text = "Customer does not exist !"; }
            DataSet ds = TriTT.B_CUSTOMER_LIMIT_Load_Customer_Limit(LimitID);
            if (ds.Tables != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0) // truong hop hanmuc cha da co o DB
            {
                tbLimitID.Text = LimitID;
               
                BankProject.Controls.Commont.SetTatusFormControls(this.Controls, false);
                LoadToolBar_AllFalse();
                rcbCurrency.SelectedValue = ds.Tables[0].Rows[0]["CurrencyCode"].ToString();
                rcbCountry.SelectedValue = ds.Tables[0].Rows[0]["CountryCode"].ToString();
                if (ds.Tables[0].Rows[0]["ApprovedDate"].ToString() != "")
                {
                    RdpApprovedDate.SelectedDate = DateTime.Parse(ds.Tables[0].Rows[0]["ApprovedDate"].ToString());
                }
                if (ds.Tables[0].Rows[0]["OfferedUntil"].ToString() != "")
                {
                    RdpOfferedUnit.SelectedDate = DateTime.Parse(ds.Tables[0].Rows[0]["OfferedUntil"].ToString());
                }
                if (ds.Tables[0].Rows[0]["ExpiryDate"].ToString() != "")
                {
                    rdpExpiryDate.SelectedDate = DateTime.Parse(ds.Tables[0].Rows[0]["ExpiryDate"].ToString());
                }
                if (ds.Tables[0].Rows[0]["ProposalDate"].ToString() != "")
                {
                    RdpProposalDate.SelectedDate = DateTime.Parse(ds.Tables[0].Rows[0]["ProposalDate"].ToString());
                }
                if (ds.Tables[0].Rows[0]["Availabledate"].ToString() != "")
                {
                    RdpAvailableDate.SelectedDate = DateTime.Parse(ds.Tables[0].Rows[0]["Availabledate"].ToString());
                }
                tbIntLimitAmt.Text = ds.Tables[0].Rows[0]["InternalLimitAmt"].ToString();
                tbAdvisedAmt.Text = ds.Tables[0].Rows[0]["AdvisedAmt"].ToString();
                tbOriginalLimit.Text = ds.Tables[0].Rows[0]["OriginalLimit"].ToString();
                tbNote.Text = ds.Tables[0].Rows[0]["Note"].ToString();
                rcbFandA.SelectedValue = ds.Tables[0].Rows[0]["Mode"].ToString();
                tbMaxTotal.Text = ds.Tables[0].Rows[0]["MaxTotal"].ToString();
                //Add 16 July 2015 for bug 52  Hien thi gia tri cho 2 field Maximum Secured va Maximum UnSecured
                tbMaxSecured.Text = ds.Tables[0].Rows[0]["MaxSecured"].ToString();
                tbMaxUnsecured.Text = ds.Tables[0].Rows[0]["MaxUnSecured"].ToString();
                is_New_edit_hanMucCha = true;// cho phep enable form va disable collateral type
            }
            else // han muc cha chua co o DB, tao moi, khong disable form
            {
                //BankProject.Controls.Commont.SetEmptyFormControls(this.Controls);
                rcbCurrency.SelectedValue = ""; rcbCountry.SelectedValue = "";
                RdpApprovedDate.SelectedDate = DateTime.Now;
                RdpOfferedUnit.SelectedDate = DateTime.Now;
                RdpAvailableDate.SelectedDate = DateTime.Now;
                RdpProposalDate.SelectedDate = DateTime.Now; rdpExpiryDate.SelectedDate = null; tbIntLimitAmt.Text = ""; tbAdvisedAmt.Text = "";
                tbNote.Text = ""; tbMaxSecured.Text = ""; tbMaxUnsecured.Text = ""; tbMaxTotal.Text = "";
                BankProject.Controls.Commont.SetTatusFormControls(this.Controls, true);
                FirstLoad();// refesh lai page, tranh luu lai du lieu cu cua lan`search truoc' do
                rcbFandA.SelectedIndex = 0;
                //tbLimitID.Text = LimitID;
                //LoadCustomerName(tbCustomerID.Text);
                //if (TriTT.B_CUSTOMER_LIMIT_LoadCustomerName(LimitID.Substring(0, 7)) != null)
                //{
                //    lblCheckCustomerName.Text = ""; 
                //    lblCustomerName.Text = TriTT.B_CUSTOMER_LIMIT_LoadCustomerName(LimitID.Substring(0, 7)).ToString();
                //}
                //else { lblCheckCustomerName.Text = "Customer does not exist !"; }
                rcbCollateral.Enabled= rcbCollateralType.Enabled= rcbFandA.Enabled = false;

            }
        }
        protected void rcbCollateralType_ONSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            LoadCollateralCode(rcbCollateralType.SelectedValue);
        }
        protected void rcbGlobalLimit_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            if (tbCustomerID.Text != "" && rcbGlobalLimit.SelectedValue != "" && tbCustomerName.Text != "Customer ID does not exist.")
            {
                tbLimitID.Text = tbCustomerID.Text + "." + rcbGlobalLimit.SelectedValue;
                if (rcbGlobalLimit.SelectedValue != "" && tbCustomerID.Text != "")
                    Load_MainLimit_ForLimitDetail(tbLimitID.Text.Trim());
            }
        }
        protected void tbCustomerID_TextChanged(object sender, EventArgs e)
        {
            LoadCustomerName(tbCustomerID.Text);
            if (tbCustomerID.Text != "" && rcbGlobalLimit.SelectedValue != "" && tbCustomerName.Text != "Customer ID does not exist.")
            {
                tbLimitID.Text = tbCustomerID.Text + "." + rcbGlobalLimit.SelectedValue;
                Load_MainLimit_ForLimitDetail(tbLimitID.Text.Trim());
            }
        }
        protected void LoadCustomerName(string CustomerID)
        {
            DataSet ds = TriTT_Credit.Load_Customer_Info_From_BCUSTOMER_INFO(CustomerID);
            tbCustomerName.Text = "";
            if (ds.Tables != null && ds.Tables[0].Rows.Count > 0 && ds.Tables.Count > 0)
            {
                DataRow dr = ds.Tables[0].Rows[0];
                tbCustomerName.Text = dr["GBFullName"].ToString();
            }
            else
            {
                tbCustomerName.Text = "Customer ID does not exist.";
            }
        }
        #region Properties
        protected void FirstLoad()
        {
            LoadCountries();
            LoadCurrencies();
            rcbCurrency.SelectedValue = "";
            rcbCurrency.Focus();
            LoadCollateralType();
            RdpApprovedDate.SelectedDate = DateTime.Now;
            RdpOfferedUnit.SelectedDate = DateTime.Now;
            RdpAvailableDate.SelectedDate = DateTime.Now;
            RdpProposalDate.SelectedDate = DateTime.Now;
        }
        protected void LoadCountries()
        {
            rcbCountry.DataSource = DataProvider.TriTT.B_BCOUNTRY_GetAll();
            rcbCountry.DataTextField = "TenTA";
            rcbCountry.DataValueField = "MaQuocGia";
            rcbCountry.DataBind();
        }
        protected void LoadCurrencies()
        {
            rcbCurrency.Items.Clear();
            DataSet ds = TriTT.B_LoadCurrency("USD", "VND");
            if (ds.Tables != null && ds.Tables[0].Rows.Count > 0)
            {
                DataRow dr = ds.Tables[0].NewRow();
                dr["Code"] = "";
                dr["Code"] = "";
                ds.Tables[0].Rows.InsertAt(dr, 0);
            }
            rcbCurrency.DataSource = ds;
            rcbCurrency.DataValueField = "Code";
            rcbCurrency.DataTextField = "Code";
            rcbCurrency.DataBind();
        }
        //private void LoadCustomerID()
        //{
        //    rcbCustomerID.DataSource = DataProvider.TriTT.B_OPEN_LOANWORK_ACCT_Get_ALLCustomerID();
        //    rcbCustomerID.DataTextField = "CustomerHasName";
        //    rcbCustomerID.DataValueField = "CustomerID";
        //    rcbCustomerID.DataBind();
        //}
        private void LoadToolBar(bool isauthorize)
        {
            RadToolBar1.FindItemByValue("btCommitData").Enabled = isauthorize;
            RadToolBar1.FindItemByValue("btPreview").Enabled = false;
            RadToolBar1.FindItemByValue("btAuthorize").Enabled = false;
            RadToolBar1.FindItemByValue("btReverse").Enabled = false;
            RadToolBar1.FindItemByValue("btSearch").Enabled = true;
            RadToolBar1.FindItemByValue("btPrint").Enabled = false;
            RadToolBar1.FindItemByValue("btEdit").Enabled = true;
        }
        protected void LoadToolBar_AllFalse()
        {
            RadToolBar1.FindItemByValue("btCommitData").Enabled = false;
            RadToolBar1.FindItemByValue("btPreview").Enabled = false;
            RadToolBar1.FindItemByValue("btAuthorize").Enabled = false;
            RadToolBar1.FindItemByValue("btReverse").Enabled = false;
            RadToolBar1.FindItemByValue("btSearch").Enabled = false;
            RadToolBar1.FindItemByValue("btPrint").Enabled = false;
            RadToolBar1.FindItemByValue("btEdit").Enabled = true;
        }
        protected void LoadCollateralType()
        {
            rcbCollateralType.DataSource = TriTT.B_CUSTOMER_LIMIT_Load_CollateralType();
            rcbCollateralType.DataValueField = "CollateralTypeCode";
            rcbCollateralType.DataTextField = "CollateralTypeHasName";
            rcbCollateralType.DataBind();
        }
        protected void LoadCollateralCode(string CollateralTypeCode)
        {
            rcbCollateral.Items.Clear();
            rcbCollateral.Text = "";
            DataSet ds = TriTT.B_CUSTOMER_LIMIT_Load_CollateralCode(CollateralTypeCode);
            if (ds.Tables != null & ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                DataRow dr = ds.Tables[0].NewRow();
                dr["CollateralCode"] = "";
                dr["CollateralHasName"] = "";
                ds.Tables[0].Rows.InsertAt(dr, 0);
            }
            rcbCollateral.DataSource = ds;
            rcbCollateral.DataValueField = "CollateralCode";
            rcbCollateral.DataTextField = "CollateralHasName";
            rcbCollateral.DataBind();
        }
        
        #endregion
       
    }
}