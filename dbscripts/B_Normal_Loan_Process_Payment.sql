IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_Normal_Loan_Process_Payment')
BEGIN
/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Payment]    Script Date: 10/12/2014 8:39:41 AM ******/
DROP PROCEDURE [dbo].[B_Normal_Loan_Process_Payment]
END
GO

/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Payment]    Script Date: 10/12/2014 8:39:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Nghia Le
-- Create date: 10-Oct-2014
-- Description:	it is used to process for payment and interest amount of Loan Contract
-- =============================================
CREATE PROCEDURE [dbo].[B_Normal_Loan_Process_Payment]
(
	-- Add the parameters for the stored procedure here
	@EndDateProcess datetime 
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @BatchName nvarchar(30)
	Declare @BatchNameFlagRun nvarchar(30)
	Declare @BatchNameFlagDone nvarchar(30)
	Declare @CurrentProcessId int

	SET @BatchName = 'BATCH_LOAN_PAYMENT'
	SET @BatchNameFlagRun = 'Running'
	SET @BatchNameFlagDone = 'Completed'



	IF(NOT EXISTS(SELECT 1 FROM [B_CheckBatchRunning] WHERE [BatchName] = @BatchName))
	BEGIN
		INSERT INTO [B_CheckBatchRunning] ([BatchName],[NoOfRuns])  VALUES (@BatchName, 0)
	END
	
	IF(NOT EXISTS(SELECT 1 FROM [B_CheckBatchRunning] WHERE [BatchName] = @BatchName AND [RunningFlag] = @BatchNameFlagRun))
	BEGIN

		UPDATE [B_CheckBatchRunning] SET [RunningFlag] = @BatchNameFlagRun, [UpdatedDate] = GETDATE(), [NoOfRuns] = [NoOfRuns]+1  WHERE [BatchName] = @BatchName
		
		INSERT INTO [B_BATCH_MAINTENANCE] ([BatchName] ,[StartDate] ,[NoOfRuns] ,[Status])
		     VALUES
           (@BatchName, GETDATE()
           ,(Select [NoOfRuns] From [B_CheckBatchRunning] where [BatchName] = @BatchName)
           ,@BatchNameFlagRun)

		Select @CurrentProcessId = @@IDENTITY


	
		IF(@EndDateProcess IS NULL)
		BEGIN
			set @EndDateProcess = GETDATE();
		END
		Declare @ReferCode nvarchar(50);

	
		DECLARE LoanContractList_Cursor CURSOR FOR
			Select Code from BNEWNORMALLOAN where ISNULL(LoanAmountRemain,0) > 0 AND status = 'AUT'
			--AND	Code in (select distinct Code from [B_NORMALLOAN_PAYMENT_SCHEDULE])
	
		OPEN LoanContractList_Cursor;
		--loop all associate loan contract
		FETCH NEXT FROM LoanContractList_Cursor INTO @ReferCode 

		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- process payment/interest from a loan contract

			EXEC [B_Normal_Loan_Process_Payment_For_A_Loan] @ReferCode, @EndDateProcess


			FETCH NEXT FROM LoanContractList_Cursor INTO @ReferCode;
		END

		CLOSE LoanContractList_Cursor;
		DEALLOCATE LoanContractList_Cursor;

		UPDATE [B_BATCH_MAINTENANCE] SET [Status] = @BatchNameFlagDone, [EndDate] = GETDATE() WHERE [BatchName] = @BatchName AND [ID] = @CurrentProcessId
		UPDATE [B_CheckBatchRunning] SET [RunningFlag] = @BatchNameFlagDone, [UpdatedDate] = GETDATE() WHERE [BatchName] = @BatchName 

	END


	Select 1;
END


GO

