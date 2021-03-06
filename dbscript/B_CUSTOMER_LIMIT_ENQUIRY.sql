
/****** Object:  StoredProcedure [dbo].[B_CUSTOMER_LIMIT_ENQUIRY]    Script Date: 07/11/2014 6:38:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[B_CUSTOMER_LIMIT_ENQUIRY](@LimitType nvarchar(30),@MaHanMucCha nvarchar(10), @MaHanMucCon nvarchar(10), @CustomerName nvarchar(150), @CustomerID nvarchar(20)
			,@CollateralType nvarchar(20) , @CollateralCode nvarchar(20), @Currency nvarchar(5), @FromIntLimitAmt decimal(24,3), @ToIntLimitAmt decimal(24,3))
AS
IF @LimitType='Product'
BEGIN
select LimitMain.[MainLimitID] as MainLimitID, BCustomer.[GBFullName] as CustomerName, LimitSub.SubLimitID as SubLimitID, LimitSub.CustomerID as CustomerID, 
CONVERT(nvarchar, CONVERT(money, LimitMain.[InternalLimitAmt]), 1)  as InternalLimitAmt, CONVERT(nvarchar, CONVERT(money, LimitSub.[MaxTotal] ), 1)as MaxTotal,
	LimitMain.CurrencyCode as Currency, LimitSub.[CollateralName] as CollateralName , LimitSub.ProductName as  Product --substring(isnull(LimitSub.ProductName,''),7,len(isnull(LimitSub.ProductName,''))-6) as Product

 from [dbo].[BCUSTOMER_LIMIT_MAIN] as LimitMain join [dbo].[BCUSTOMER_INFO] as BCustomer on LimitMain.CustomerID = BCustomer.CustomerID
	JOIN [BCUSTOMER_LIMIT_SUB] AS LimitSub on LimitMain.[CustomerID] = LimitSub.CustomerID and LimitMain.[CommitmentType]=LimitSub.[MainComtTYpe]

WHERE ( @MaHanMucCha IS NULL or @MaHanMucCha='' or LimitSub.[MainComtTYpe]  LIKE N'%'+@MaHanMucCha+'%' ) AND
	  ( @MaHanMucCon IS NULL or @MaHanMucCon='' or LimitSub.[SubCommitmentType] LIKE N'%'+@MaHanMucCon+'%') AND
	  (@CustomerName IS NULL OR @CustomerName ='' OR BCustomer.[GBFullName] LIKE N'%'+@CustomerName+'%') AND
	  (@CustomerID IS NULL OR @CustomerID ='' OR LimitSub.CustomerID LIKE N'%'+@CustomerID+'%' OR LimitMain.CustomerID LIKE N'%'+@CustomerID+'%') AND
	  (@CollateralType IS NULL OR @CollateralType ='' OR LimitSub.[CollateralTypeCode] LIKE N'%'+@CollateralType+'%') AND
	  (@CollateralCode IS NULL OR @CollateralCode ='' OR LimitSub.[CollateralCode] LIKE N'%'+@CollateralCode+'%') AND
	  (@Currency IS NULL OR @Currency ='' OR LimitMain.[CurrencyCode] LIKE N'%'+@Currency+'%') AND
	  (@FromIntLimitAmt =0  or @FromIntLimitAmt<= convert(decimal(24,3),LimitMain.[InternalLimitAmt] )) AND
	  (@ToIntLimitAmt = 0 or @ToIntLimitAmt>= convert(decimal(24,3),LimitMain.[InternalLimitAmt] ))
END ELSE IF @LimitType='Global'
BEGIN
	SELECT [MainLimitID], '' as SubLimitID, ' ' as Product, cus.[GBFullName] as  CustomerName , CurrencyCode as Currency,
	CONVERT(nvarchar, CONVERT(money, main.[InternalLimitAmt]), 1) InternalLimitAmt, CONVERT(nvarchar, CONVERT(money, main.MaxTotal), 1) as MaxTotal
	FROM [dbo].[BCUSTOMER_LIMIT_MAIN] as main JOIN [dbo].[BCUSTOMER_INFO] as cus on cus.CustomerID = main.CustomerID
	WHERE 
	  ( @MaHanMucCha IS NULL or @MaHanMucCha='' or main.[CommitmentType]  LIKE N'%'+@MaHanMucCha+'%' ) AND
	  (@CustomerName IS NULL OR @CustomerName ='' OR cus.[GBFullName] LIKE N'%'+@CustomerName+'%') AND
	  (@CustomerID IS NULL OR @CustomerID ='' OR main.CustomerID LIKE N'%'+@CustomerID+'%') AND	  
	  (@Currency IS NULL OR @Currency ='' OR main.[CurrencyCode] LIKE N'%'+@Currency+'%') AND
	  (@FromIntLimitAmt =0  or @FromIntLimitAmt<= convert(decimal(24,3),main.[InternalLimitAmt] )) AND
	  (@ToIntLimitAmt = 0 or @ToIntLimitAmt>= convert(decimal(24,3),main.[InternalLimitAmt] ))
END



