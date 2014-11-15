IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_Normal_Loan_Process_Payment_ClearUnusedSchedule')
BEGIN

DROP PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_ClearUnusedSchedule]
END
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Nghia Le
-- Create date: 10-Oct-2014
-- Description:	it is used to process for payment and interest amount of Loan Contract
-- =============================================
CREATE PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_ClearUnusedSchedule]
(
	@ReferCode nvarchar(50),
	@RepaymentPerios int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
END


		DELETE FROM [B_NORMALLOAN_PAYMENT_SCHEDULE] WHERE [Code] = @ReferCode AND [Status] IS NULL AND [PeriodRepaid] = @RepaymentPerios
		Select 1;
GO

