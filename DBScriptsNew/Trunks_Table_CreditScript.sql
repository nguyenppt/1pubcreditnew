SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------
-- 10 July 2015 : Nghia : Add approved, offer date .. for product limit Bug51	Credit	Product Limit: Approved Date,Offered ,Until Date, Expiry Date, Proposal Date

---------------------------------------------------------------------------------
print 'Alter [BCUSTOMER_LIMIT_SUB]'

ALTER TABLE BCUSTOMER_LIMIT_SUB
ADD	[ApprovedDate] [date] NULL;
GO

ALTER TABLE BCUSTOMER_LIMIT_SUB
ADD	[OfferedUntil] [date] NULL;
GO
ALTER TABLE BCUSTOMER_LIMIT_SUB
ADD	[ExpiryDate] [date] NULL;
GO
ALTER TABLE BCUSTOMER_LIMIT_SUB
ADD	[ProposalDate] [date] NULL;
GO
ALTER TABLE BCUSTOMER_LIMIT_SUB
ADD	[Availabledate] [date] NULL;
GO

---------------------------------------------------------------------------------
-- 10 July 2015 : Nghia : Add MaxUnSecured, MaxSecured for BCUSTOMER_LIMIT_MAIN Bug52	Credit	"Enquiry Global Limit
-- Hien thi gia tri cho 2 field Maximum Secured va Maximum UnSecured"
---------------------------------------------------------------------------------
print 'Alter [BCUSTOMER_LIMIT_MAIN]'

ALTER TABLE BCUSTOMER_LIMIT_MAIN
ADD	[MaxSecured] decimal(18,2) NULL;
GO

ALTER TABLE BCUSTOMER_LIMIT_MAIN
ADD	[MaxUnSecured] decimal(18,2) NULL;
GO

/**
 Add disable flag for [BCOLLATERAL]
*/
print 'Alter [BCOLLATERAL]'
ALTER TABLE BCOLLATERAL
ADD	[IsDisabled] bit ;
GO

Update BCOLLATERAL Set [IsDisabled] = 0;
Go
Update BCOLLATERAL Set [IsDisabled] = 1 WHERE CollateralTypeCode = 900;
Go

/*Add new currency*/
IF(NOT EXISTS(Select 1 from [BCURRENCY] Where Code = 'GOLD'))
BEGIN
Insert into [dbo].[BCURRENCY] (Code, [Description], Vietnamese, Pence) Values ('GOLD', 'Gold', N'Vàng', 'Cent')
END
GO

