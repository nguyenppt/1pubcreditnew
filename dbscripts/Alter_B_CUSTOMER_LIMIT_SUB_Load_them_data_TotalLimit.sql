USE [bisolutions_vvcb]
GO

/****** Object:  StoredProcedure [dbo].[B_CUSTOMER_LIMIT_SUB_Load_them_data_TotalLimit]    Script Date: 12/5/2014 11:18:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[B_CUSTOMER_LIMIT_SUB_Load_them_data_TotalLimit](@CustomerID nvarchar(20))
as

Declare @USD_RATE decimal(18,4)
Declare @VND_Amount money
Declare @USD_Amount money
Declare @VND_Total_Amount money

Select @USD_RATE = [Rate]  FROM [B_ExchangeRates] WHERE [Currency] = 'USD'


select @VND_Amount = convert(money,sum([InternalLimitAmt])) from [dbo].[BCUSTOMER_LIMIT_MAIN] 
	where CustomerID = @CustomerID and [CurrencyCode]='VND'
	group by CustomerID

select @USD_Amount = convert(money,sum([InternalLimitAmt])) from [dbo].[BCUSTOMER_LIMIT_MAIN] 
	where CustomerID = @CustomerID and [CurrencyCode]='USD'
	group by CustomerID

SET @VND_Total_Amount = (@VND_Amount + (@USD_Amount * @USD_RATE))

SELECT convert(nvarchar,@VND_Total_Amount,1)  AS TotalInternalLimitAmt

GO


