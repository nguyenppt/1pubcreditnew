IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_Normal_Loan_Process_Payment_AddPaymentProcess')
BEGIN
/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Payment]    Script Date: 10/12/2014 8:39:41 AM ******/
DROP PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_AddPaymentProcess]
END
GO

/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Payment]    Script Date: 10/12/2014 8:39:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Nghia Le
-- Create date: 10-Oct-2014
-- Description:	it is used to process for payment and interest amount of Loan Contract
-- =============================================
CREATE PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_AddPaymentProcess]
(
	@ReferCode nvarchar(50),
	@RepaymentPerios int,
	@Perios int

)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
END

		----create new record to track payment process
		INSERT INTO [dbo].[B_LOAN_PROCESS_PAYMENT]
           ([Code],[Period] ,[CustomerID]
           ,[PrinRepAccount],[IntRepAccount],[ChrgRepAccount]
           ,[AmountOfCapitalPaid],[OutstandingLoanAmount] ,[InterestedAmount]
           ,[InterestAmountCalc] ,[OverdueCapitalAmount],[OverdueInterestAmount]
           ,[LoanAmount],[PaidAmount],[PaidInterestAmount]
           ,[Circle_Begin_Date],[Circle_Maturity_Date],[Active_Flag]
           ,[Process_Date],[CreateBy],[CreateDate],[PeriodRepaid])
		SELECT 
			nl.[Code],@Perios,nl.[CustomerID]
           ,nl.[PrinRepAccount] ,nl.[IntRepAccount],nl.[ChrgRepAccount]
           ,0,0,0
           ,0,0,0
           ,(SELECT TOP 1 [LoanAmount] FROM [BNEWNORMALLOAN_REPAYMENT] WHERE [Code] = @ReferCode AND [RepaymentTimes] = @RepaymentPerios) ,0 ,0
           ,(SELECT TOP 1 [Drawdown] FROM [B_NORMALLOAN_PAYMENT_SCHEDULE] WHERE [Code] = @ReferCode AND [Period] = @Perios) ,NULL , 1
           ,NULL, 1 , GETDATE(), @RepaymentPerios
		FROM [BNEWNORMALLOAN] nl 
		WHERE nl.[Code] = @ReferCode;

GO

