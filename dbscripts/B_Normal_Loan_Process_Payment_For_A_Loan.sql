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


	SELECT TOP 1 @lastExecDate = p.Process_Date, @customerID = p.CustomerID
	FROM B_LOAN_PROCESS_PAYMENT p
	WHERE p.Code = @ReferCode AND [PeriodRepaid] = @RepaymentPerios
	ORDER BY p.Period DESC
	IF (@lastExecDate IS NULL AND @customerID IS NULL)
	BEGIN
		----create new record to track payment process
		INSERT INTO [dbo].[B_LOAN_PROCESS_PAYMENT]
           ([Code],[Period] ,[CustomerID]
           ,[PrinRepAccount],[IntRepAccount],[ChrgRepAccount]
           ,[AmountOfCapitalPaid],[OutstandingLoanAmount] ,[InterestedAmount]
           ,[InterestAmountCalc] ,[OverdueCapitalAmount],[OverdueInterestAmount]
           ,[LoanAmount],[PaidAmount],[PaidInterestAmount]
           ,[Circle_Begin_Date],[Circle_Maturity_Date],[Active_Flag]
           ,[Process_Date],[CreateBy],[CreateDate],[PeriodRepaid])
		SELECT 
			nl.[Code],1,nl.[CustomerID]
           ,nl.[PrinRepAccount] ,nl.[IntRepAccount],nl.[ChrgRepAccount]
           ,0,0,0
           ,0,0,0
           ,nl.[LoanAmount] ,0 ,0
           ,(SELECT TOP 1 [Drawdown] FROM [B_NORMALLOAN_PAYMENT_SCHEDULE] WHERE [Code] = @ReferCode AND [Period] = 1) ,NULL , 1
           ,NULL, 1 , GETDATE(), @RepaymentPerios
		FROM [BNEWNORMALLOAN] nl
		WHERE nl.[Code] = @ReferCode;
		

		UPDATE [BNEWNORMALLOAN] SET [Tot_P_Pay_Amt] = 0, [Tot_I_Pay_Amt] = 0, [Tot_P_Pastdue_Amt] = 0, [Tot_I_Pastdue_Amt] = 0 WHERE [Code] = @ReferCode;

	END
	--ELSE
	--BEGIN
	--	--Select 'ton tai ne', @lastExecDate as lastDate, @customerID as customerID
	--END

	-- check if lastExecDate is null, the asign it to drawdown date
	IF(@lastExecDate IS NULL)
	BEGIN
		SELECT TOP 1 @lastExecDate = [Drawdown] FROM [B_NORMALLOAN_PAYMENT_SCHEDULE] WHERE [Code] = @ReferCode AND [Period] = 1 AND [PeriodRepaid] = @RepaymentPerios;
	END
	--Select 'ton tai ne2', @lastExecDate as lastDate, @customerID as customerID
	--Start process payment, only process if last execute date not empty
	IF(@lastExecDate IS NOT NULL)
	BEGIN
		SET @lastExecDate = DATEADD(day,1,@lastExecDate) -- go to next day
		WHILE (@lastExecDate <= @EndDate)
		BEGIN
			--Select 'ton tai ne3', @lastExecDate as lastDate, @customerID as customerID
			EXEC [dbo].[B_Normal_Loan_Process_Payment_For_A_Loan_Per_Date] @ReferCode, @lastExecDate;
			--Select 'B_Normal_Loan_Process_Payment_For_A_Loan_Per_Date: ' ,@ReferCode ,@lastExecDate
			SET @lastExecDate = DATEADD(day,1,@lastExecDate) -- go to next day
		END

	END
	
END

GO

