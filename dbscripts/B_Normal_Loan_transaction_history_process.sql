
IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_Normal_Loan_transaction_history_process')
BEGIN
/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_transaction_history_process]    Script Date: 10/12/2014 8:39:08 AM ******/
DROP PROCEDURE [dbo].[B_Normal_Loan_transaction_history_process]
END
GO

/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_transaction_history_process]    Script Date: 10/12/2014 8:39:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nghia Le
-- Create date: 10-Dec-2014
-- Description:	add transaction process
-- =============================================
CREATE PROCEDURE [dbo].[B_Normal_Loan_transaction_history_process]
(
	-- Add the parameters for the stored procedure here
	@ReferCode nvarchar(50),
	@UserId int,
	@AccountNo nvarchar(50),
	@TxnAmount decimal(18,4),
	@Type int

)
AS
BEGIN
	DECLARE @TxnType nvarchar(50)
	DECLARE @Balance decimal(18,4)
	DECLARE @NewBalance decimal(18,4)

	SET @TxnType = 'UNKNOWN'

	SELECT @TxnType =	CASE @Type
							WHEN 1 THEN ('LoanInput')
							WHEN 2 THEN ('CashRepayment')
							WHEN 3 THEN ('BatchProcess')
							WHEN 4 THEN ('PrincipleProcess')	
							WHEN 5 THEN ('InterestedProcess')
							WHEN 6 THEN ('PrinciplePastDueProcess')
							WHEN 7 THEN ('InterestedPastDueProcess')
							WHEN 8 THEN ('DisbursalProcess')						
						END

    IF(@AccountNo IS NOT NULL AND @AccountNo != '')
	BEGIN
	
		SELECT @Balance = [dbo].B_Normal_Loan_Process_Payment_GetCurrentAmount_Func(@AccountNo);

		IF(@Type = 1  or @Type = 8)
		BEGIN
			SET @TxnAmount = 0 + @TxnAmount
		END
		ELSE
		BEGIN
			SET @TxnAmount = 0 - @TxnAmount
		END
	
		SET @NewBalance = @Balance + @TxnAmount
	

		INSERT INTO [dbo].[B_LOAN_TRANSACTION_HISTORY]
			   ([TxnId]
			   ,[TxnType]
			   ,[TxnAmount]
			   ,[Balance]
			   ,[NewBalance]
			   ,[ProcessDate]
			   ,[ProcessUser]
			   ,[AccountNo])
	
		 VALUES
			   (@ReferCode
			   ,@TxnType
			   ,@TxnAmount
			   ,@Balance
			   ,@NewBalance
			   ,GETDATE()
			   ,@UserId
			   ,@AccountNo)

		END
	
END

GO

