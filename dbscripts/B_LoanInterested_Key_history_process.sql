
IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_LoanInterested_Key_history_process')
BEGIN
/****** Object:  StoredProcedure [dbo].[B_LoanInterested_Key_history_process]    Script Date: 10/12/2014 8:39:08 AM ******/
DROP PROCEDURE [dbo].[B_LoanInterested_Key_history_process]
END
GO

/****** Object:  StoredProcedure [dbo].[B_LoanInterested_Key_history_process]    Script Date: 10/12/2014 8:39:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nghia Le
-- Create date: 4-Jan-2015
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[B_LoanInterested_Key_history_process]
(
	-- Add the parameters for the stored procedure here
	@MonthLoanRateNo bigint,
	@VND_InterestRate decimal(18,4),
	@USD_InterestRate decimal(18,4),
	@UserId int,
	@Type int

)
AS
BEGIN
	
	DECLARE @Action nvarchar(50)
	DECLARE @Old_VND_Interest decimal(18,4)
	DECLARE @Old_USD_Interest decimal(18,4)
	
	SET @Action = 'UNKNOWN'
	SELECT @Action =	CASE @Type
							WHEN 1 THEN ('AddNew')
							WHEN 2 THEN ('Modify')
							WHEN 3 THEN ('Delete')									
						END

	SELECT TOP 1 @Old_VND_Interest = [VND_InterestRate],@Old_USD_Interest= [USD_InterestRate] 
	FROM BLOANINTEREST_KEY WHERE MonthLoanRateNo = @MonthLoanRateNo

    INSERT INTO [dbo].[BLOANINTEREST_KEY_HISTORY]
           ([MonthLoanRateNo]
           ,[VND_InterestRate]
           ,[VND_InterestRate_New]
           ,[USD_InterestRate]
           ,[USD_InterestRate_New]
           ,[Actions]
           ,[CreatedDateTime]
           ,[CreatedBy])
     VALUES
           (@MonthLoanRateNo
           ,@Old_VND_Interest
           ,@VND_InterestRate
           ,@Old_USD_Interest
           ,@USD_InterestRate
           ,@Action
           ,GETDATE()
           ,@UserId)

	Select 1
	
END

GO

