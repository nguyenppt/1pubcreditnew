
IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_Normal_Loan_GetRemainLoanAmount')
BEGIN

DROP PROCEDURE [dbo].[B_Normal_Loan_GetRemainLoanAmount]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Nghia Le
-- Create date: 10-Nov-2014
-- Description:	it is used to get remain loan amount
-- =============================================
CREATE PROCEDURE [dbo].[B_Normal_Loan_GetRemainLoanAmount]
(
	-- Add the parameters for the stored procedure here
	@ReferCode nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @LoanAmount decimal(18,4)
	DECLARE @PaymentAmount decimal(18,4)
	
	SELECT @LoanAmount = ISNULL([LoanAmount],0), @PaymentAmount = ISNULL([Tot_P_Pay_Amt],0) FROM BNEWNORMALLOAN WHERE [Code] = @ReferCode

	SELECT (@LoanAmount - @PaymentAmount) AS [RemainLoanAmount]

END


GO

