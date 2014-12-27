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
	@Perios int,
	@ProcessDate date

)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;		
		DECLARE @Interest numeric(18,5)
		DECLARE @CurrentLoansAmount numeric(18,5)
		DECLARE @InterestAmountPerDay numeric(18,5)
		DECLARE @RateType nvarchar(2)
		DECLARE @LoansAmount numeric(18,5)
		DECLARE @DrawdownDate datetime

		SELECT @LoansAmount = LoanAmount, @RateType = RateType, @CurrentLoansAmount = LoanAmountRemain, @DrawdownDate = [Drawdown] FROM BNEWNORMALLOAN WHERE Code = @ReferCode

		IF(@Perios = 1)
		BEGIN
			IF(@DrawdownDate IS NOT NULL)
			BEGIN
				SET @CurrentLoansAmount = @LoansAmount
			END
			ELSE
			BEGIN
				SELECT TOP 1 @CurrentLoansAmount = DisbursalAmount FROM B_LOAN_DISBURSAL_SCHEDULE WHERE Code = @ReferCode ORDER BY DisbursalDate ASC
			END
		END


		SELECT TOP 1 @Interest = Interest
		FROM [B_NORMALLOAN_PAYMENT_SCHEDULE] 
		WHERE  Code = @ReferCode AND [PeriodRepaid] = @RepaymentPerios AND Period = @Perios ORDER BY Period ASC

		SET @Interest = ISNULL([dbo].[B_Normal_Loan_Process_Payment_Get_Interested_Rate_Func]( @ReferCode, @Interest, @ProcessDate),@Interest);

		IF(@RateType = '2')
		BEGIN
			SET @CurrentLoansAmount = @LoansAmount
		END

		--Select @ReferCode, @RepaymentPerios, @Perios, @ProcessDate

		SET @InterestAmountPerDay = @CurrentLoansAmount * (@Interest/36000) 

		----create new record to track payment process
		INSERT INTO [dbo].[B_LOAN_PROCESS_PAYMENT]
           ([Code],[Period] ,[CustomerID]
           ,[PrinRepAccount],[IntRepAccount],[ChrgRepAccount]
           ,[AmountOfCapitalPaid],[OutstandingLoanAmount] ,[InterestedAmount]
           ,[InterestAmountCalc] ,[OverdueCapitalAmount],[OverdueInterestAmount]
           ,[LoanAmount],[PaidAmount],[PaidInterestAmount]
           ,[Circle_Begin_Date],[Circle_Maturity_Date],[Active_Flag]
           ,[Process_Date],[CreateBy],[CreateDate],[PeriodRepaid], [Interest], [InterestedAmountPerday])
		SELECT 
			nl.[Code],@Perios,nl.[CustomerID]
           ,nl.[PrinRepAccount] ,nl.[IntRepAccount],nl.[ChrgRepAccount]
           ,0,0,0
           ,0,0,0
           ,(SELECT TOP 1 [LoanAmount] FROM [BNEWNORMALLOAN_REPAYMENT] WHERE [Code] = @ReferCode AND [RepaymentTimes] = @RepaymentPerios) ,0 ,0
           ,(SELECT TOP 1 [Drawdown] FROM [B_NORMALLOAN_PAYMENT_SCHEDULE] WHERE [Code] = @ReferCode AND [Period] = @Perios) ,NULL , 1
           ,NULL, 1 , GETDATE(), @RepaymentPerios, ISNULL(@Interest,0), ISNULL(@InterestAmountPerDay,0)
		FROM [BNEWNORMALLOAN] nl 
		WHERE nl.[Code] = @ReferCode;

END
GO

