USE [bisolutions_vvcb]
GO

IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_Normal_Loan_CashRepayment_Subtract_To_Account')
BEGIN
/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_CashRepayment_Subtract_To_Account]    Script Date: 10/13/2014 9:47:58 PM ******/
DROP PROCEDURE [dbo].[B_Normal_Loan_CashRepayment_Subtract_To_Account]
END
GO

/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_CashRepayment_Subtract_To_Account]    Script Date: 10/13/2014 9:47:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Nghia Le
-- Create date: 10-Oct-2014
-- Description:	it is used to process for payment and interest amount of Loan Contract
-- =============================================
CREATE PROCEDURE [dbo].[B_Normal_Loan_CashRepayment_Subtract_To_Account]
(
	-- Add the parameters for the stored procedure here
	@AccountID nvarchar(50),
	@SubtractAmount decimal(18,4),
	@ReferCode nvarchar(50),
	@UserID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.	
	SET NOCOUNT ON;
	DECLARE @RemainAmount decimal(18,4)

	EXEC [B_Normal_Loan_transaction_history_process] @ReferCode, @UserID, @AccountID, @SubtractAmount,2 
	EXEC @RemainAmount = [B_Normal_Loan_Process_Payment_Subtract_To_Account] @AccountID, @SubtractAmount
	UPDATE [BNEWNORMALLOAN] SET  [LoanAmountRemain] = [LoanAmountRemain] - @SubtractAmount  WHERE Code = @ReferCode

	SELECT 1;

END


GO

