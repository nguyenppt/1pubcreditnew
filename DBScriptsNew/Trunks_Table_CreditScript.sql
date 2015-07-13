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
