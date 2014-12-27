IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_Normal_Loan_Process_Payment_For_A_Loan')
BEGIN
/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Payment_For_A_Loan]    Script Date: 10/12/2014 8:38:49 AM ******/
DROP PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_For_A_Loan]
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
CREATE PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_For_A_Loan]
(
	-- Add the parameters for the stored procedure here
	@ReferCode nvarchar(50),
	@EndDate datetime 
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

	

	-- check if lastExecDate is null, the asign it to drawdown date
	IF(@lastExecDate IS NULL)
	BEGIN

		UPDATE [BNEWNORMALLOAN] SET [LoanAmount_Actual] = 0 WHERE [Code] = @ReferCode
		SELECT TOP 1 @lastExecDate = [Drawdown] FROM [B_NORMALLOAN_PAYMENT_SCHEDULE] WHERE [Code] = @ReferCode AND [Period] = 1 AND [PeriodRepaid] = @RepaymentPerios;

		IF(@lastExecDate IS NOT NULL)
		BEGIN
			SET @lastExecDate = DATEADD(day,-1,@lastExecDate)
			EXEC [B_Normal_Loan_Process_Payment_AddPaymentProcess] @ReferCode, @RepaymentPerios, 1, @lastExecDate;
		END

		
	END
	--Select 'ton tai ne2', @lastExecDate as lastDate, @customerID as customerID
	--Start process payment, only process if last execute date not empty
	IF(@lastExecDate IS NOT NULL)
	BEGIN
		WHILE (@lastExecDate < @EndDate)
		BEGIN
			SET @lastExecDate = DATEADD(day,1,@lastExecDate) -- go to next day
			--Select 'ton tai ne3', @lastExecDate as lastDate, @customerID as customerID
			--Credit to Acc
			Exec [B_Normal_Loan_Process_Credit_To_LoanAcc] @ReferCode, @lastExecDate;
			EXEC [dbo].[B_Normal_Loan_Process_Payment_For_A_Loan_Per_Date] @ReferCode, @lastExecDate;
			--Select 'B_Normal_Loan_Process_Payment_For_A_Loan_Per_Date: ' ,@ReferCode ,@lastExecDate			
		END
	END
	
END

GO


