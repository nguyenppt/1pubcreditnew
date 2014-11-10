
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
	DECLARE @InterestAmount decimal(18,4)
	DECLARE @PrincipleAmount decimal(18,4)
	DECLARE @CurrentCusAmount decimal(18,4)
	DECLARE @Period int
	DECLARE @RepaymentPerios int

	DECLARE @RemainOver decimal(18,4)

	SELECT @PrinRepAcc = [PrinRepAccount] ,@IntRepAcc = [IntRepAccount] ,@ChrgRepAcc = [ChrgRepAccount], @RepaymentPerios = RepaymentTimes
	FROM [BNEWNORMALLOAN] WHERE Code = @ReferCode

	SELECT TOP 1  @PrincipleAmount = [AmountOfCapitalPaid], @InterestAmount = [InterestedAmount], @Period = [Period]
	FROM [B_LOAN_PROCESS_PAYMENT] 
	WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios

	IF(@PrinRepAcc IS NOT NULL AND @PrincipleAmount IS NOT NULL)
	BEGIN

		EXEC @RemainOver = [B_Normal_Loan_Process_Payment_Subtract_To_Account] @PrinRepAcc, @PrincipleAmount
		UPDATE [BNEWNORMALLOAN] SET [Tot_P_Pay_Amt] = [Tot_P_Pay_Amt] + (@PrincipleAmount - @RemainOver) WHERE Code = @ReferCode

		IF(@RemainOver>0)
		BEGIN
			UPDATE [B_LOAN_PROCESS_PAYMENT] SET
				[OverdueCapitalAmount] = [OverdueCapitalAmount] + @RemainOver
			WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios

			UPDATE [B_NORMALLOAN_PAYMENT_SCHEDULE] SET
				[OverdueCapitalAmount] = (select [OverdueCapitalAmount] from [B_LOAN_PROCESS_PAYMENT] where Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios)
			WHERE Code = @ReferCode AND [Period] = @Period AND [PeriodRepaid] = @RepaymentPerios
		END		
	END

	IF(@IntRepAcc IS NOT NULL AND @InterestAmount IS NOT NULL)
	BEGIN
		EXEC @RemainOver = [B_Normal_Loan_Process_Payment_Subtract_To_Account] @IntRepAcc, @InterestAmount
		UPDATE [BNEWNORMALLOAN] SET [Tot_I_Pay_Amt] = [Tot_I_Pay_Amt] + (@InterestAmount - @RemainOver) WHERE Code = @ReferCode
		IF(@RemainOver>0)
		BEGIN
			UPDATE [B_LOAN_PROCESS_PAYMENT] SET
				[OverdueInterestAmount] = [OverdueInterestAmount] + @RemainOver
			WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios

			UPDATE [B_NORMALLOAN_PAYMENT_SCHEDULE] SET
				[OverdueInterestAmount] = (select [OverdueInterestAmount] from [B_LOAN_PROCESS_PAYMENT] where Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios)
			WHERE Code = @ReferCode AND [Period] = @Period AND [PeriodRepaid] = @RepaymentPerios
		END	
	END
	
END


GO

