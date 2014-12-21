
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

	Declare @ReferCode nvarchar(50);
	DECLARE @CreditAcc nvarchar(50);
	DECLARE @LoanAmount decimal(18,4);


	DECLARE LoanContractList_Cursor_Credit CURSOR FOR
		Select Code from BNEWNORMALLOAN where MaturityDate >= @EndDateProcess AND status = 'AUT'
		AND	Code in (select distinct Code from [B_NORMALLOAN_PAYMENT_SCHEDULE])
		AND [Drawdown] IS NOT NULL
		AND [LoanAmount] > ISNULL([LoanAmount_Actual], 0)
		AND [Drawdown] <= @EndDateProcess
	
	OPEN LoanContractList_Cursor_Credit;
	--loop all associate loan contract
	FETCH NEXT FROM LoanContractList_Cursor_Credit INTO @ReferCode 

    WHILE @@FETCH_STATUS = 0
	BEGIN
		-- process payment/interest from a loan contract
		SELECT  @CreditAcc = [CreditAccount], @LoanAmount = [LoanAmount]  FROM [BNEWNORMALLOAN] WHERE Code = @ReferCode
		IF(@CreditAcc IS NOT NULL)
		BEGIN
	
			--Add history transaction Loan Input
			EXEC [B_Normal_Loan_transaction_history_process] @ReferCode, 1, @CreditAcc, @LoanAmount, 1 
			EXEC [B_Normal_Loan_Process_Payment_Credit_To_Account] @CreditAcc, @LoanAmount

			UPDATE BNEWNORMALLOAN 
				SET [LoanAmount_Actual] = [LoanAmount] 
			WHERE [Code] = @ReferCode

			
		END

		FETCH NEXT FROM LoanContractList_Cursor_Credit INTO @ReferCode;
    END

	CLOSE LoanContractList_Cursor_Credit;
    DEALLOCATE LoanContractList_Cursor_Credit;

	
	--Process for disbursal

	DECLARE LoanContractList_Cursor_Credit_Disb CURSOR FOR
		Select Code from BNEWNORMALLOAN where MaturityDate >= @EndDateProcess AND status = 'AUT'
		AND	Code in (select distinct Code from [B_NORMALLOAN_PAYMENT_SCHEDULE])
		AND [Drawdown] IS NULL
		AND [LoanAmount] > ISNULL([LoanAmount_Actual], 0)
	
	OPEN LoanContractList_Cursor_Credit_Disb;
	--loop all associate loan contract
	FETCH NEXT FROM LoanContractList_Cursor_Credit_Disb INTO @ReferCode 

    WHILE @@FETCH_STATUS = 0
	BEGIN
		-- process payment/interest from a loan contract
		SELECT  @CreditAcc = [CreditAccount], @LoanAmount = SUM(ISNULL([DisbursalAmount], 0))
		FROM [BNEWNORMALLOAN] INNER JOIN [B_LOAN_DISBURSAL_SCHEDULE] ON [BNEWNORMALLOAN].[Code] = [B_LOAN_DISBURSAL_SCHEDULE].[Code]
		WHERE [BNEWNORMALLOAN].[Code] = @ReferCode 
			AND [IsCreditToAcc] = 0 
			AND (
					([DrawdownDate] IS NOT NULL AND  [DrawdownDate] <= @EndDateProcess)
					OR
					([DrawdownDate] IS NULL AND  [DisbursalDate] <= @EndDateProcess)
				)			
		GROUP BY [BNEWNORMALLOAN].[Code], [CreditAccount]

		IF(@CreditAcc IS NOT NULL)
		BEGIN


			--Add history transaction Disbursal Process
			EXEC [B_Normal_Loan_transaction_history_process] @ReferCode, 1, @CreditAcc, @LoanAmount,8 
			EXEC [B_Normal_Loan_Process_Payment_Credit_To_Account] @CreditAcc, @LoanAmount

			UPDATE BNEWNORMALLOAN 
				SET [LoanAmount_Actual] =  ISNULL([LoanAmount_Actual],0) + @LoanAmount
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
		FETCH NEXT FROM LoanContractList_Cursor_Credit_Disb INTO @ReferCode;
    END

	CLOSE LoanContractList_Cursor_Credit_Disb;
    DEALLOCATE LoanContractList_Cursor_Credit_Disb;


	
END

GO

