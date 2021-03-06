
/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Get_RemainLimitAmount]    Script Date: 1/21/2015 9:59:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nghia Le
-- Create date: 10-Oct-2014
-- Description:	it is used to process for payment and interest amount of Loan Contract
-- =============================================
CREATE PROCEDURE [dbo].[B_Normal_Loan_Get_RemainLimitAmount_Exclude_LoanID]
(
	-- Add the parameters for the stored procedure here
	@LimitReferenceCode nvarchar(50),
	@Code nvarchar(50)
)
AS
BEGIN
	DECLARE @CustID nvarchar(50)
	DECLARE @SubCommitType nvarchar(10)
	DECLARE @CommitType nvarchar(10)
	DECLARE @InternalLimitAmt decimal(18,4)
	DECLARE @TotalPaymentAmount decimal(18,4)
	DECLARE @LoanAmount decimal(18,4)
	DECLARE @LoanAmountAllow decimal(18,4)	

	SET @TotalPaymentAmount  = 0
	SET @LoanAmount  = 0
	SET @LoanAmountAllow  = 0
	SET @InternalLimitAmt = 0

	SELECT @CustID = [CustomerID], @SubCommitType = [SubCommitmentType], @InternalLimitAmt = ISNULL([InternalLimitAmt],0) FROM [BCUSTOMER_LIMIT_SUB] WHERE [SubLimitID] = @LimitReferenceCode

	IF(@SubCommitType >= 8000)
	BEGIN
		SET @CommitType = '8000'
	END
	ELSE
	BEGIN
		SET @CommitType = '7000'
	END

	--SELECT @InternalLimitAmt = ISNULL([InternalLimitAmt],0) FROM [BCUSTOMER_LIMIT_MAIN] WHERE [MainLimitID] = @CustID + '.' + @CommitType

	SELECT @LoanAmount = ISNULL(SUM(LoanAmount),0), @TotalPaymentAmount = ISNULL(SUM([Tot_P_Pay_Amt]),0) FROM [BNEWNORMALLOAN] WHERE [LimitReference] = @LimitReferenceCode AND Code <> @Code

	IF(@CommitType = '8000')
	BEGIN
		SET @LoanAmountAllow = @InternalLimitAmt - @LoanAmount
	END
	ELSE
	BEGIN
		SET @LoanAmountAllow = @InternalLimitAmt - (@LoanAmount - @TotalPaymentAmount)
	END

	Select @LoanAmountAllow

END
