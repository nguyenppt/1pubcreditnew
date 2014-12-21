USE [bisolutions_vvcb]
GO

IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_Normal_Loan_Account_GetCurrentAmount')
BEGIN
/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Account_GetCurrentAmount]    Script Date: 10/13/2014 9:47:58 PM ******/
DROP PROCEDURE [dbo].[B_Normal_Loan_Account_GetCurrentAmount]
END
GO

/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Account_GetCurrentAmount]    Script Date: 10/13/2014 9:47:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Nghia Le
-- Create date: 10-Oct-2014
-- Description:	Get current amount
-- =============================================
CREATE PROCEDURE [dbo].[B_Normal_Loan_Account_GetCurrentAmount]
(
	-- Add the parameters for the stored procedure here
	@AccountID nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.	
	SET NOCOUNT ON;
	DECLARE @CurrentCusAmount decimal(18,4)

	SELECT @CurrentCusAmount = [dbo].B_Normal_Loan_Process_Payment_GetCurrentAmount_Func(@AccountID);
	
	SELECT ISNULL(@CurrentCusAmount,0) AS [CurrentCusAmount]
	
END


GO

