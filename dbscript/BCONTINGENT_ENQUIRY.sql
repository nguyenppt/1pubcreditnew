
/****** Object:  StoredProcedure [dbo].[BCONTINGENT_ENQUIRY]    Script Date: 13/11/2014 2:21:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[BCONTINGENT_ENQUIRY](@ContingentID nvarchar(20), @RefID nvarchar(30), @CustomerName nvarchar(250), @CustomerID nvarchar(50), @Currency nvarchar(5),
@FromAmount decimal, @ToAmount decimal, @LegalID nvarchar(50))
AS
SELECT [CollateralInfoID]
      ,[ContingentEntryID]
      ,e.[CustomerID]
      ,[CustomerAddress]
      ,[DocIDTaxCode]
      ,[DateOfIssue]
      ,[TransactionCode]
      ,[TransactionName]
      ,e.[Currency]
      ,[AccountNo]
      ,[AccountName]
      ,[Amount]
      ,[DCTypeCode]
      ,[DCTypeName]
      ,[CollateralType_Code] , GBFULLNAME
	  from [dbo].[BCOLLATERALCONTINGENT_ENTRY]  AS E JOIN [dbo].[BCUSTOMER_INFO] AS I ON E.CustomerID = I.CustomerID
	  WHERE (@ContingentID IS NULL OR @ContingentID = '' OR [CollateralInfoID] LIKE N'%'+@ContingentID+'%') AND
	  (@RefID IS NULL OR @RefID = '' OR [ContingentEntryID] LIKE N'%'+@RefID+'%') AND
	  (@CustomerName IS NULL OR @CustomerName = '' OR I.GBFULLNAME LIKE N'%'+@CustomerName+'%') AND
	  (@CustomerID IS NULL OR @CustomerID = '' OR e.[CustomerID] LIKE N'%'+@CustomerID+'%') AND
	  (@Currency IS NULL OR @Currency = '' OR e.[Currency] LIKE N'%'+@Currency+'%') AND
	  (@LegalID IS NULL OR @LegalID = '' OR [DocIDTaxCode] LIKE N'%'+@LegalID+'%') AND
	  (@FromAmount IS NULL OR @FromAmount = 0 OR [Amount] > @FromAmount) AND
	  (@ToAmount IS NULL OR @ToAmount = 0 OR [Amount] < @ToAmount) 

GO


