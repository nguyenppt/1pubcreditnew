IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_Normal_Loan_Process_DisbursalRepaymentCheck')
BEGIN
/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_DisbursalRepaymentCheck]    Script Date: 10/12/2014 8:38:49 AM ******/
DROP PROCEDURE [dbo].[B_Normal_Loan_Process_DisbursalRepaymentCheck]
END
GO



/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Payment_For_A_Loan]    Script Date: 10/12/2014 8:38:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nghia Le
-- Create date: 10-Oct-2014
-- Description:	it is used to process for payment and interest amount of Loan Contract
-- =============================================
CREATE PROCEDURE [dbo].[B_Normal_Loan_Process_DisbursalRepaymentCheck]
(
	-- Add the parameters for the stored procedure here
	@ReferCode nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- get latest execute time record [dbo].[B_LOAN_PROCESS_PAYMENT]
	DECLARE @lastExecDate date
	DECLARE @customerID nvarchar(50)
	DECLARE @RepaymentPerios int

	SELECT @RepaymentPerios = RepaymentTimes FROM [BNEWNORMALLOAN] WHERE [Code] = @ReferCode


	SELECT TOP 1 @lastExecDate = p.Process_Date, @customerID = p.CustomerID FROM B_LOAN_PROCESS_PAYMENT p
	WHERE p.Code = @ReferCode AND [PeriodRepaid] = @RepaymentPerios
	ORDER BY p.Period DESC

	
END

GO


