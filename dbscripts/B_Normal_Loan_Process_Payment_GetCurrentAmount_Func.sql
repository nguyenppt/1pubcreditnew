-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nghia Le
-- Create date: 10-Oct-2014
-- Description:	Get current amount
-- =============================================
CREATE FUNCTION [dbo].[B_Normal_Loan_Process_Payment_GetCurrentAmount_Func]
(
	@AccountID nvarchar(50)
)
RETURNS DECIMAL(18,4)
AS
BEGIN
	DECLARE @AccountType int
	DECLARE @CurrentCusAmount decimal(18,4)
	
	SET @CurrentCusAmount = 0.0;
	IF(@AccountID IS NOT NULL AND @AccountID != '' )
	BEGIN
		SELECT TOP 1 @AccountType = p.[type] FROM
			(SELECT 1 as [type] FROM [BOPENACCOUNT] WHERE [AccountCode] = @AccountID
			UNION
			SELECT 2 as [type] FROM [BLOANWORKINGACCOUNTS] WHERE [ID] = @AccountID) p
		
		IF(@AccountType IS NOT NULL)
		BEGIN
			IF(@AccountType = 1) --[[BOPENACCOUNT]]
			BEGIN
				SELECT @CurrentCusAmount = ISNULL([WorkingAmount],0) FROM [BOPENACCOUNT] WHERE [AccountCode] = @AccountID
			
			END
			ELSE IF(@AccountType = 2) --[BLOANWORKINGACCOUNTS]
			BEGIN
				SELECT @CurrentCusAmount = ISNULL([WorkingAmount],0) FROM [BLOANWORKINGACCOUNTS] WHERE [ID] = @AccountID
			END
		
		END 	
	END
	ELSE
	BEGIN
		SET @CurrentCusAmount = 0.0
	END
	-- Return the result of the function
	RETURN @CurrentCusAmount

END
GO

