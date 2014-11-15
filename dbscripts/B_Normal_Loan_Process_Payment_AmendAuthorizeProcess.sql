IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_Normal_Loan_Process_Payment_AmendAuthorizeProcess')
BEGIN

DROP PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_AmendAuthorizeProcess]
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
CREATE PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_AmendAuthorizeProcess]
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


		UPDATE [B_NORMALLOAN_PAYMENT_SCHEDULE]
		SET [AmountOfCapitalPaid] = p.[AmountOfCapitalPaid]
			, [OutstandingLoanAmount] = p.[OutstandingLoanAmount]
			, [InterestedAmount] = p.[InterestedAmount]
			, [OverdueCapitalAmount] = p.[OverdueCapitalAmount]
			, [OverdueInterestAmount] = p.[OverdueInterestAmount]
			, [PaidAmount] = p.[PaidAmount]
			, [PaidInterestAmount] = p.[PaidInterestAmount]
			, [Status] = N'FINISH'
		FROM [B_LOAN_PROCESS_PAYMENT] p, [B_NORMALLOAN_PAYMENT_SCHEDULE] s
		WHERE s.[Code] = p.[Code] 
		AND s.[PeriodRepaid] = p.[PeriodRepaid]
		 AND s.[Period] = p.[Period]
		 AND p.[Code] = @ReferCode 
		 AND [Status] IS NOT NULL 
		 AND  p.[PeriodRepaid] =@RepaymentPerios

		 Select 1;
GO

