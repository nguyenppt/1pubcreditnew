
IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_Normal_Loan_Process_Payment_Balance_Acc_Overdue')
BEGIN
/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Payment_Balance_Acc_Overdue]    Script Date: 10/12/2014 8:39:08 AM ******/
DROP PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_Balance_Acc_Overdue]
END
GO

/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Payment_Balance_Acc_Overdue]    Script Date: 10/12/2014 8:39:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nghia Le
-- Create date: 10-Oct-2014
-- Description:	it is used to process for payment and interest amount of Loan Contract
-- =============================================
CREATE PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_Balance_Acc_Overdue]
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
	DECLARE @OverdueInterestAmount decimal(18,4)
	DECLARE @OverduePrincipleAmount decimal(18,4)
	DECLARE @PaidAmount decimal(18,4)
	DECLARE @PaidInterestAmount decimal(18,4)
	DECLARE @CurrentCusAmount decimal(18,4)
	DECLARE @Period int
	DECLARE @RepaymentPerios int

	DECLARE @RemainOver decimal(18,4)

	SELECT @PrinRepAcc = [PrinRepAccount] ,@IntRepAcc = [IntRepAccount] ,@ChrgRepAcc = [ChrgRepAccount], @RepaymentPerios = RepaymentTimes	FROM [BNEWNORMALLOAN] WHERE Code = @ReferCode

	SELECT TOP 1  @OverdueInterestAmount = ISNULL([OverdueInterestAmount],0), 
					@OverduePrincipleAmount = ISNULL([OverdueCapitalAmount],0), 
					@PaidAmount = ISNULL([PaidAmount],0),
					@PaidInterestAmount = ISNULL([PaidInterestAmount],0), 
					@Period = [Period]
	FROM [B_LOAN_PROCESS_PAYMENT] 
	WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios

	IF(@PrinRepAcc IS NOT NULL AND @OverduePrincipleAmount IS NOT NULL)
	BEGIN

		EXEC @RemainOver = [B_Normal_Loan_Process_Payment_Subtract_To_Account] @PrinRepAcc, @OverduePrincipleAmount
		UPDATE [BNEWNORMALLOAN] SET [Tot_P_Pay_Amt] = ISNULL([Tot_P_Pay_Amt],0) + (@OverduePrincipleAmount - @RemainOver) WHERE Code = @ReferCode
		UPDATE [B_LOAN_PROCESS_PAYMENT] SET	[OverdueCapitalAmount] = @RemainOver WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios
		UPDATE [B_NORMALLOAN_PAYMENT_SCHEDULE] SET [OverdueCapitalAmount] = @RemainOver WHERE Code = @ReferCode AND [Period] = @Period AND [PeriodRepaid] = @RepaymentPerios
			
	END

	IF(@IntRepAcc IS NOT NULL AND @OverdueInterestAmount IS NOT NULL)
	BEGIN
		EXEC @RemainOver = [B_Normal_Loan_Process_Payment_Subtract_To_Account] @IntRepAcc, @OverdueInterestAmount
		UPDATE [BNEWNORMALLOAN] SET [Tot_I_Pay_Amt] = ISNULL([Tot_I_Pay_Amt],0) + (@OverdueInterestAmount - @RemainOver) WHERE Code = @ReferCode
		UPDATE [B_LOAN_PROCESS_PAYMENT] SET	[OverdueInterestAmount] =  @RemainOver 	WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios
		UPDATE [B_NORMALLOAN_PAYMENT_SCHEDULE] SET [OverdueInterestAmount] = @RemainOver WHERE Code = @ReferCode AND [Period] = @Period AND [PeriodRepaid] = @RepaymentPerios
		
	END

	IF(@ChrgRepAcc IS NOT NULL AND @PaidAmount IS NOT NULL)
	BEGIN
		EXEC @RemainOver = [B_Normal_Loan_Process_Payment_Subtract_To_Account] @ChrgRepAcc, @PaidAmount
		UPDATE [BNEWNORMALLOAN] SET [Tot_P_Pastdue_Amt] = ISNULL([Tot_P_Pastdue_Amt],0) + (@PaidAmount - @RemainOver) WHERE Code = @ReferCode
		UPDATE [B_LOAN_PROCESS_PAYMENT] SET [PaidAmount] =  @RemainOver WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios
		UPDATE [B_NORMALLOAN_PAYMENT_SCHEDULE] SET 	[PaidAmount] = @RemainOver WHERE Code = @ReferCode AND [Period] = @Period AND [PeriodRepaid] = @RepaymentPerios
		
	END

	IF(@ChrgRepAcc IS NOT NULL AND @PaidInterestAmount IS NOT NULL)
	BEGIN
		EXEC @RemainOver = [B_Normal_Loan_Process_Payment_Subtract_To_Account] @ChrgRepAcc, @PaidInterestAmount
		UPDATE [BNEWNORMALLOAN] SET [Tot_I_Pastdue_Amt] = ISNULL([Tot_I_Pastdue_Amt],0) + (@PaidInterestAmount - @RemainOver) WHERE Code = @ReferCode
		UPDATE [B_LOAN_PROCESS_PAYMENT] SET [PaidInterestAmount] =  @RemainOver WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios
		UPDATE [B_NORMALLOAN_PAYMENT_SCHEDULE] SET [PaidInterestAmount] = @RemainOver WHERE Code = @ReferCode AND [Period] = @Period AND [PeriodRepaid] = @RepaymentPerios		
	END
	
END

GO

