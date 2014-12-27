
IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_Normal_Loan_Process_Payment_Balance_Acc')
BEGIN
/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Payment_Balance_Acc]    Script Date: 10/12/2014 8:39:26 AM ******/
DROP PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_Balance_Acc]
END
GO


/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Payment_Balance_Acc]    Script Date: 10/12/2014 8:39:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Nghia Le
-- Create date: 10-Oct-2014
-- Description:	it is used to process for payment and interest amount of Loan Contract
-- =============================================
CREATE PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_Balance_Acc]
(
	-- Add the parameters for the stored procedure here
	@ReferCode nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.	
	SET NOCOUNT ON;
	DECLARE @PrinRepAcc nvarchar(50)
	DECLARE @IntRepAcc nvarchar(50)
	DECLARE @ChrgRepAcc nvarchar(50)
	DECLARE @CreditAcc nvarchar(50)
	DECLARE @InterestAmount decimal(18,4)
	DECLARE @PrincipleAmount decimal(18,4)
	DECLARE @CurrentCusAmount decimal(18,4)
	DECLARE @Period int
	DECLARE @RepaymentPerios int

	DECLARE @RemainOver decimal(18,4)

	SELECT @PrinRepAcc = [PrinRepAccount] ,
		@IntRepAcc = [IntRepAccount] ,
		@ChrgRepAcc = [ChrgRepAccount], 
		@CreditAcc = [CreditAccount],
		@RepaymentPerios = RepaymentTimes
	FROM [BNEWNORMALLOAN] WHERE Code = @ReferCode

	IF(@IntRepAcc IS NULL OR @IntRepAcc = '')
	BEGIN
		SET @IntRepAcc = @CreditAcc
	END 

	IF(@PrinRepAcc IS NULL OR @PrinRepAcc = '')
	BEGIN
		SET @PrinRepAcc = @CreditAcc
	END 

	IF(@ChrgRepAcc IS NULL OR @ChrgRepAcc = '')
	BEGIN
		SET @ChrgRepAcc = @CreditAcc
	END 


	SELECT TOP 1  @PrincipleAmount = ISNULL([AmountOfCapitalPaid],0), 
				@InterestAmount = ISNULL([InterestedAmount],0), @Period = [Period]
	FROM [B_LOAN_PROCESS_PAYMENT] 
	WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios



	IF(@PrinRepAcc IS NOT NULL AND @PrincipleAmount > 0)
	BEGIN

		EXEC [B_Normal_Loan_transaction_history_process] @ReferCode, 1, @PrinRepAcc, @PrincipleAmount, 4
		EXEC @RemainOver = [B_Normal_Loan_Process_Payment_Subtract_To_Account] @PrinRepAcc, @PrincipleAmount
		UPDATE [BNEWNORMALLOAN] SET [Tot_P_Pay_Amt] = ISNULL([Tot_P_Pay_Amt],0) + (@PrincipleAmount - @RemainOver), [LoanAmountRemain] = [LoanAmountRemain] - (@PrincipleAmount - @RemainOver)  WHERE Code = @ReferCode

		IF(@RemainOver>0)
		BEGIN
			UPDATE [B_LOAN_PROCESS_PAYMENT] SET [OverdueCapitalAmount] = ISNULL([OverdueCapitalAmount],0) + @RemainOver WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios

			UPDATE [B_NORMALLOAN_PAYMENT_SCHEDULE] SET
				[OverdueCapitalAmount] = (select [OverdueCapitalAmount] from [B_LOAN_PROCESS_PAYMENT] where Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios)
			WHERE Code = @ReferCode AND [Period] = @Period AND [PeriodRepaid] = @RepaymentPerios
		END		
	END

	IF(@IntRepAcc IS NOT NULL AND @InterestAmount >0)
	BEGIN
		EXEC [B_Normal_Loan_transaction_history_process] @ReferCode, 1, @IntRepAcc, @InterestAmount, 5
		EXEC @RemainOver = [B_Normal_Loan_Process_Payment_Subtract_To_Account] @IntRepAcc, @InterestAmount
		UPDATE [BNEWNORMALLOAN] SET [Tot_I_Pay_Amt] = ISNULL([Tot_I_Pay_Amt],0) + (@InterestAmount - @RemainOver) WHERE Code = @ReferCode

		IF(@RemainOver>0)
		BEGIN
			UPDATE [B_LOAN_PROCESS_PAYMENT] SET	[OverdueInterestAmount] = ISNULL([OverdueInterestAmount],0) + @RemainOver
				WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios

			UPDATE [B_NORMALLOAN_PAYMENT_SCHEDULE] SET
				[OverdueInterestAmount] = (select [OverdueInterestAmount] from [B_LOAN_PROCESS_PAYMENT] where Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios)
				WHERE Code = @ReferCode AND [Period] = @Period AND [PeriodRepaid] = @RepaymentPerios
		END	
	END
	
END


GO

