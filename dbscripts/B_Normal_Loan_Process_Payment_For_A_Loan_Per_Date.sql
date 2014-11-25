
IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_Normal_Loan_Process_Payment_For_A_Loan_Per_Date')
BEGIN
/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Payment_For_A_Loan_Per_Date]    Script Date: 10/12/2014 8:38:26 AM ******/
DROP PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_For_A_Loan_Per_Date]
END
GO



/****** Object:  StoredProcedure [dbo].[B_Normal_Loan_Process_Payment_For_A_Loan_Per_Date]    Script Date: 10/12/2014 8:38:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Nghia Le
-- Create date: 10-Oct-2014
-- Description:	it is used to process for payment and interest amount of Loan Contract
-- =============================================
CREATE PROCEDURE [dbo].[B_Normal_Loan_Process_Payment_For_A_Loan_Per_Date]
(
	-- Add the parameters for the stored procedure here
	@ReferCode nvarchar(50),
	@ProcessDate datetime 
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @DueDate date
	DECLARE @CurrentLoansAmount decimal(18,4)
	DECLARE @PrincipleAmount decimal(18,4)
	DECLARE @PrinOSAmount decimal(18,4)
	DECLARE @Interest numeric(18,5)
	DECLARE @InterestAmountPerDay decimal(18,4)
	DECLARE @InterestAmount decimal(18,4)
	DECLARE @Period int

	DECLARE @OverdueInterest decimal(18,4)
	DECLARE @OverduePrinciple decimal(18,4)
	DECLARE @PaidDueAmount decimal(18,4)
	DECLARE @PaidDueInterestAmount decimal(18,4)
	DECLARE @RepaymentPerios int


	SELECT @RepaymentPerios = RepaymentTimes FROM [BNEWNORMALLOAN] WHERE [Code] = @ReferCode

	SELECT TOP 1 @DueDate = [DueDate], 
				@PrincipleAmount = PrincipalAmount,  
				@PrinOSAmount = PrinOS, 
				@Interest = Interest, 
				@Period = Period, 
				@InterestAmount = [InterestAmount]
	FROM [B_NORMALLOAN_PAYMENT_SCHEDULE] 
	WHERE [DueDate] >= @ProcessDate AND Code = @ReferCode AND [PeriodRepaid] = @RepaymentPerios ORDER BY Period ASC

	EXEC @Interest = [B_Normal_Loan_Process_Payment_Get_Interested_Rate] @ReferCode, @Interest, @ProcessDate

	IF(@DueDate = @ProcessDate) --end of perios
	BEGIN
		--Select '@DueDate = @ProcessDate', @ReferCode, @ProcessDate, @Period
		IF(EXISTS (SELECT 1 FROM [B_LOAN_PROCESS_PAYMENT] WHERE Code = @ReferCode AND [Period] = @Period AND [PeriodRepaid] = @RepaymentPerios ))
		BEGIN
			--Select 'xu ly end of period', @ReferCode

			UPDATE [B_LOAN_PROCESS_PAYMENT] 
				SET 
					[InterestedAmount] = [InterestAmountCalc],
					[InterestAmountCalc] = 0,
					[AmountOfCapitalPaid] = @PrincipleAmount,
					[Process_Date] = @ProcessDate
			WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [Period] = @Period AND [PeriodRepaid] = @RepaymentPerios

			UPDATE [B_NORMALLOAN_PAYMENT_SCHEDULE]
				SET [InterestedAmount] = @InterestAmount,
					[AmountOfCapitalPaid] = @PrincipleAmount,
					[UpdatedDate] = @ProcessDate,
					[Status] = N'FINISH'
				WHERE Code = @ReferCode AND [Period] = @Period AND [PeriodRepaid] = @RepaymentPerios

			--Process balance to loan account
			EXEC [B_Normal_Loan_Process_Payment_Balance_Acc] @ReferCode

			SELECT @OverduePrinciple = [OverdueCapitalAmount], @OverdueInterest = [OverdueInterestAmount], @PaidDueAmount = [PaidAmount], @PaidDueInterestAmount = [PaidInterestAmount]
			FROM [B_LOAN_PROCESS_PAYMENT] WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [Period] = @Period AND [PeriodRepaid] = @RepaymentPerios

			--Balance to loan account in case of overdue	
			SELECT @OverduePrinciple = [OverdueCapitalAmount], @OverdueInterest = [OverdueInterestAmount], @PaidDueAmount = [PaidAmount]
			FROM [B_LOAN_PROCESS_PAYMENT] WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios

			EXEC [B_Normal_Loan_Process_Payment_Balance_Acc_Overdue] @ReferCode


			UPDATE [B_LOAN_PROCESS_PAYMENT] SET	[Active_Flag] = 0 WHERE [Code] = @ReferCode AND [PeriodRepaid] = @RepaymentPerios;

			IF(@PrinOSAmount >0)
			BEGIN	
				SET @CurrentLoansAmount = @PrinOSAmount;
				SET @InterestAmountPerDay = (@Interest/36000)*@CurrentLoansAmount	

				set @Period = @Period + 1					
				EXEC [B_Normal_Loan_Process_Payment_AddPaymentProcess] @ReferCode, @RepaymentPerios, @Period;				
			END
			
		END	
	END
	
	IF(EXISTS (SELECT 1 FROM [B_LOAN_PROCESS_PAYMENT] WHERE Code = @ReferCode AND [Period] = @Period AND [PeriodRepaid] = @RepaymentPerios AND ([Process_Date] IS NULL OR [Process_Date] < @ProcessDate)))
	BEGIN
					
		SET @CurrentLoansAmount = @PrincipleAmount + @PrinOSAmount;
		SET @InterestAmountPerDay = (@Interest/36000)*@CurrentLoansAmount
			
		UPDATE [B_LOAN_PROCESS_PAYMENT] 
			SET [InterestAmountCalc] = [InterestAmountCalc] + @InterestAmountPerDay,
				[AmountOfCapitalPaid] = @PrincipleAmount,
				[OutstandingLoanAmount] = @PrinOSAmount, 
				[Process_Date] = @ProcessDate,
				[Circle_Maturity_Date] = @DueDate,
				[PaidAmount] = [PaidAmount] + ([OverdueCapitalAmount] * (@Interest/36000) * 0.5),
				[PaidInterestAmount] = [PaidInterestAmount] + ([OverdueInterestAmount] * (@Interest/36000) * 0.5)
		WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios

		UPDATE [B_NORMALLOAN_PAYMENT_SCHEDULE]
			SET [Status] = N'PROCESSING'
			WHERE Code = @ReferCode AND [Period] = @Period AND [PeriodRepaid] = @RepaymentPerios
				 
		--Balance to loan account in case of overdue	
		SELECT @OverduePrinciple = [OverdueCapitalAmount], @OverdueInterest = [OverdueInterestAmount], @PaidDueAmount = [PaidAmount]
		FROM [B_LOAN_PROCESS_PAYMENT] WHERE Code = @ReferCode AND [Active_Flag] = 1 AND [PeriodRepaid] = @RepaymentPerios
		IF(@OverduePrinciple >0 OR @OverdueInterest > 0 OR @PaidDueAmount>0 OR @PaidDueInterestAmount>0)
		BEGIN
			EXEC [B_Normal_Loan_Process_Payment_Balance_Acc_Overdue] @ReferCode
		END

	END		
	

END


GO

