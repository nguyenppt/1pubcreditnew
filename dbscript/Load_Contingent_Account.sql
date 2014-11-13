USE [bisolutions_vvcb]
GO

/****** Object:  StoredProcedure [dbo].[Load_Contingent_Account]    Script Date: 13/11/2014 2:20:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Load_Contingent_Account](@ContigentAcct nvarchar(20))
AS
SELECT [CollateralInfoID]
      ,[ContingentEntryID],cui.[GBStreet]+', '+cui.[GBDist]+', '+cui.[TenTinhThanh]+', '+cui.[CountryName] as Address_cont
	  ,cui.[DocID] , convert(date, cui.DocIssueDate,103) as DocIssueDate
      ,coe.[CustomerID]
      ,[CustomerAddress]
      ,[DocIDTaxCode]
      ,[DateOfIssue]
      ,[TransactionCode]
      ,[TransactionName]
      ,coe.[Currency]
      ,[AccountNo]
      ,[AccountName]
      ,[Amount]
      ,[DealRate]
      ,[ValueDate] as ValueDateCont
      ,[Narrative]
      ,[DCTypeCode]
      ,[DCTypeName]
      ,[CollateralType_Code] from [dbo].[BCOLLATERALCONTINGENT_ENTRY] as coe JOIN [dbo].[BCUSTOMER_INFO] as cui on coe.[CustomerID] = cui.CustomerID
	   where @ContigentAcct= [CollateralInfoID]
GO


