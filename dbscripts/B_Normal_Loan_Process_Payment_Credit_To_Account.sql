USE [bisolutions_vvcb]
GO

IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_Normal_Loan_Process_Payment_Credit_To_Account')
BEGIN
/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Payment_Credit_To_Account]    Script Date: 10/13/2014 9:47:58 PM ******/
DROP PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_Credit_To_Account]
END
GO

/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Payment_Credit_To_Account]    Script Date: 10/13/2014 9:47:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Nghia Le
-- Create date: 10-Oct-2014
-- Description:	it is used to process for payment and interest amount of Loan Contract
-- =============================================
CREATE PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_Credit_To_Account]
(
	-- Add the parameters for the stored procedure here
	@AccountID nvarchar(50),
	@CreditAmount decimal(18,4)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.	
	SET NOCOUNT ON;
	DECLARE @AccountType int
	DECLARE @CurrentCusAmount decimal(18,4)

	SELECT TOP 1 @AccountType = p.[type] FROM
		(SELECT 1 as [type] FROM [BOPENACCOUNT] WHERE [AccountCode] = @AccountID
		UNION
		SELECT 2 as [type] FROM [BLOANWORKINGACCOUNTS] WHERE [ID] = @AccountID) p
		
	IF(@AccountType IS NOT NULL)
	BEGIN
		IF(@AccountType = 1) --[[BOPENACCOUNT]]
		BEGIN
			
			UPDATE [BOPENACCOUNT] SET 
				[WorkingAmount] = ISNULL([WorkingAmount],0) + @CreditAmount,
				[ActualBallance] = ISNULL([ActualBallance],0) + @CreditAmount,
				[ClearedBallance] = ISNULL([ClearedBallance],0) + @CreditAmount
			WHERE [AccountCode] = @AccountID				
				
		END
		ELSE IF(@AccountType = 2) --[BLOANWORKINGACCOUNTS]
		BEGIN
			
			UPDATE [BLOANWORKINGACCOUNTS] SET 
				[WorkingAmount] = ISNULL([WorkingAmount],0) + @CreditAmount,
				[ActualBallance] = ISNULL([ActualBallance],0) + @CreditAmount,
				[ClearedBallance] = ISNULL([ClearedBallance],0) + @CreditAmount
			WHERE [ID] = @AccountID
				
		END		
	END 	
END
GO

