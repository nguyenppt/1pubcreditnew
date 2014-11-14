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
	IF(@EndDateProcess IS NULL)
	BEGIN
		set @EndDateProcess = GETDATE();
	END
	Declare @ReferCode nvarchar(50);


	DECLARE LoanContractList_Cursor CURSOR FOR
		Select Code from BNEWNORMALLOAN where MaturityDate >= @EndDateProcess AND status = 'AUT'
		AND	Code in (select distinct Code from [B_NORMALLOAN_PAYMENT_SCHEDULE])
	
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

	Select 1;
END


GO

