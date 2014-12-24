
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
CREATE FUNCTION [dbo].[B_Normal_Loan_Process_Payment_Get_Interested_Rate_Func]
(
	-- Add the parameters for the stored procedure here
	@ReferCode nvarchar(50),
	@CurrentInterest numeric(18,5),
	@ProcessDate datetime
)
RETURNS DECIMAL(18,4)
AS
BEGIN

	Declare @DrawdownDate datetime 
	Declare @RateType nvarchar(5)
	Declare @IntSpeed int
	Declare @DepositRate nvarchar(5)
	Declare @RepaymentTimes int
	Declare @Currentcy nvarchar(10)

	IF(@ProcessDate IS NULL)
	BEGIN
		RETURN @CurrentInterest;
	END

	SELECT @DrawdownDate = [Drawdown], @RateType = [RateType], @IntSpeed = ISNULL([IntSpread],0), 
		@DepositRate = [InterestKey], @RepaymentTimes = [RepaymentTimes],
		@Currentcy = [Currency]
	 FROM [BNEWNORMALLOAN] WHERE [Code] = @ReferCode

	IF(@RateType = '3' )
	BEGIN
		IF(@DrawdownDate IS NULL)
		BEGIN
			SELECT TOP 1 @DrawdownDate = ISNULL(DrawdownDate, DisbursalDate) FROM B_LOAN_DISBURSAL_SCHEDULE WHERE Code = @ReferCode ORDER BY DisbursalDate DESC
		END

		IF(@DrawdownDate IS NULL)
		BEGIN
			Return @CurrentInterest;
		END

		IF(EXISTS(SELECT 1 FROM BNewLoanControl WHERE PeriodRepaid = @RepaymentTimes AND Code = @ReferCode AND [Type] = 'AC' ))
		BEGIN
			SELECT TOP 1 @DepositRate = Freq FROM BNewLoanControl WHERE PeriodRepaid = @RepaymentTimes AND Code = @ReferCode AND [Type] = 'AC' 
		END

		IF(@DepositRate = '')
		BEGIN
			Return @CurrentInterest;
		END 

		Declare @ProcessDateNew datetime
		Set @ProcessDateNew = DateAdd(mm, CAST( @DepositRate AS int), @DrawdownDate)

		if(@ProcessDate<=@ProcessDateNew)
		BEGIN
			Return @CurrentInterest;
		END


		IF(EXISTS(SELECT 1 FROM BLOANINTEREST_KEY WHERE MonthLoanRateNo = @DepositRate) AND (@Currentcy = 'VND' OR @Currentcy = 'USD'))
		BEGIN
			declare @vndRate decimal(18,2)
			declare @usdRate decimal(18,2)

			select @vndRate = VND_InterestRate, @usdRate = USD_InterestRate  FROM BLOANINTEREST_KEY  WHERE MonthLoanRateNo = @DepositRate

			IF(@Currentcy = 'VND')
			BEGIN
				SET @CurrentInterest = @vndRate + @IntSpeed
			END
			ELSE IF (@Currentcy = 'USD')
			BEGIN
				SET @CurrentInterest = @usdRate + @IntSpeed
			END
			
			RETURN @CurrentInterest;
		END

	END	

	Return @CurrentInterest;
END
GO