
IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_Normal_Loan_Process_Credit_To_LoanAcc')
BEGIN
/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Credit_To_LoanAcc]    Script Date: 10/12/2014 8:39:08 AM ******/
DROP PROCEDURE [dbo].[B_Normal_Loan_Process_Credit_To_LoanAcc]
END
GO

/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Credit_To_LoanAcc]    Script Date: 10/12/2014 8:39:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nghia Le
-- Create date: 10-Oct-2014
-- Description:	Credit amount to acc for loan
-- =============================================
CREATE PROCEDURE [dbo].[B_Normal_Loan_Process_Credit_To_LoanAcc]
(
	-- Add the parameters for the stored procedure here
	@ReferCode nvarchar(50),
	@EndDateProcess datetime
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.	
	SET NOCOUNT ON;
	
	IF(@EndDateProcess IS NULL)
	BEGIN
		SET @EndDateProcess = GETDATE();
	END

	DECLARE @CreditAcc nvarchar(50);
	DECLARE @LoanAmount decimal(18,4);
	DECLARE @LoanAmountActual decimal(18,4);
	DECLARE @DrawdownDate datetime;


	SELECT  @CreditAcc = [CreditAccount], @LoanAmount = [LoanAmount], @LoanAmountActual =  ISNULL([LoanAmount_Actual],0),  @DrawdownDate = [Drawdown]
	FROM [BNEWNORMALLOAN] WHERE Code = @ReferCode
	IF(@LoanAmount > @LoanAmountActual)
	BEGIN

		If(@DrawdownDate IS NOT NULL)
		BEGIN
			IF(@CreditAcc IS NOT NULL AND @LoanAmount > @LoanAmountActual AND @DrawdownDate <= @EndDateProcess)
			BEGIN
	
				--Add history transaction Loan Input
				EXEC [B_Normal_Loan_transaction_history_process] @ReferCode, 1, @CreditAcc, @LoanAmount, 1
				EXEC [B_Normal_Loan_Process_Payment_Credit_To_Account] @CreditAcc, @LoanAmount

				UPDATE BNEWNORMALLOAN 
					SET [LoanAmount_Actual] = [LoanAmount],
					[LoanAmountRemain] = @LoanAmount
				 
				WHERE [Code] = @ReferCode

			
			END
		END
		ELSE -- disbursal case
		BEGIN
			SELECT TOP 1 @DrawdownDate = ISNULL([DrawdownDate], DisbursalDate), @LoanAmount = DisbursalAmount FROM [B_LOAN_DISBURSAL_SCHEDULE] 
			WHERE [Code] = @ReferCode AND [IsCreditToAcc] = 0 
				AND (
						([DrawdownDate] IS NOT NULL AND  [DrawdownDate] <= @EndDateProcess)
						OR
						([DrawdownDate] IS NULL AND  [DisbursalDate] <= @EndDateProcess)
					)			
		
		

			IF(@CreditAcc IS NOT NULL AND @EndDateProcess IS NOT NULL AND @DrawdownDate <= @EndDateProcess)
			BEGIN

				--Add history transaction Disbursal Process
				EXEC [B_Normal_Loan_transaction_history_process] @ReferCode, 1, @CreditAcc, @LoanAmount,8 
				EXEC [B_Normal_Loan_Process_Payment_Credit_To_Account] @CreditAcc, @LoanAmount

				UPDATE BNEWNORMALLOAN 
					SET [LoanAmount_Actual] =  ISNULL([LoanAmount_Actual],0) + @LoanAmount,
					[LoanAmountRemain] = [LoanAmountRemain] + @LoanAmount
				WHERE [Code] = @ReferCode

				UPDATE [B_LOAN_DISBURSAL_SCHEDULE] 
					SET [IsCreditToAcc] = 1 
				WHERE [Code] = @ReferCode 
					AND [IsCreditToAcc] = 0 
					AND (
						([DrawdownDate] IS NOT NULL AND  [DrawdownDate] <= @EndDateProcess)
						OR
						([DrawdownDate] IS NULL AND  [DisbursalDate] <= @EndDateProcess)
						)
			END
		END
	
	END
	
END

GO

