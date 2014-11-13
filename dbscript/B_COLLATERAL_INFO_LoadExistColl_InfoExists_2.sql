USE [bisolutions_vvcb]
GO

/****** Object:  StoredProcedure [dbo].[B_COLLATERAL_INFO_LoadExistColl_InfoExists_2]    Script Date: 13/11/2014 2:21:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[B_COLLATERAL_INFO_LoadExistColl_InfoExists_2](@CollateralInfoID nvarchar(20))
as BEGIN
SELECT [RightID],coi.[CollateralInfoID],[CollateralTypeCode],Rate
      ,[CollateralTypeName]
      ,[CollateralCode]
      ,[CollateralName]
      ,[ContingentAcctID]
      ,[ContingentAcctName]
      ,[Description]
      ,[Address]
      ,[CollateralStatusID]
      ,[CollateralStatusDesc]
      ,coi.[CustomerID]
      ,[CustomreIDName]
      ,[Note]
      ,[CompanyStorageID]
      ,[CompanyStorageDesc] ,  [ProductLimitID], GlobalLimitID2
      ,coi.[Currency]
      ,coi.[CountryCode]
      ,coi.[CountryName]
      ,[NominalValue]
      ,[MaxValue]
      ,[ProvisionValue]
      ,[ExecutionValue]
      ,[AllocatedAmt]
      ,coi.[ValueDate]
      ,[ExpiryDate]
      ,[ReviewDateFreq]
	  ,cui.[GBStreet]+', '+cui.[GBDist]+', '+cui.[TenTinhThanh]+', '+cui.[CountryName] as Address_cont
	  ,cui.[DocID] , convert(date, cui.DocIssueDate,103) as DocIssueDate
	  
	  FROM [dbo].[BCOLLATERAL_INFOMATION] as coi JOIN [dbo].[BCUSTOMER_INFO] as cui on coi.[CustomerID] = cui.CustomerID
	   WHERE coi.[CollateralInfoID]=@CollateralInfoID
	  END




GO


