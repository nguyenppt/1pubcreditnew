
IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_ExchangeRate_history_process')
BEGIN
/****** Object:  StoredProcedure [dbo].[B_ExchangeRate_history_process]    Script Date: 10/12/2014 8:39:08 AM ******/
DROP PROCEDURE [dbo].[B_ExchangeRate_history_process]
END
GO

/****** Object:  StoredProcedure [dbo].[B_ExchangeRate_history_process]    Script Date: 10/12/2014 8:39:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nghia Le
-- Create date: 4-Jan-2015
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[B_ExchangeRate_history_process]
(
	-- Add the parameters for the stored procedure here
	@Currency nvarchar(3),
	@Rate decimal(18,4),
	@UserId int,
	@Type int

)
AS
BEGIN
	
	DECLARE @Action nvarchar(50)
	DECLARE @OldRate decimal(18,4)
	
	SET @Action = 'UNKNOWN'
	SELECT @Action =	CASE @Type
							WHEN 1 THEN ('AddNew')
							WHEN 2 THEN ('Modify')
							WHEN 3 THEN ('Delete')									
						END

	SELECT TOP 1 @OldRate = [Rate] FROM B_ExchangeRates WHERE Currency = @Currency

    INSERT INTO [dbo].[B_ExchangeRates_History]
           ([Currency]
           ,[Rate]
           ,[Rate_New]
           ,[Actions]
           ,[CreatedDateTime]
           ,[CreatedBy])
     VALUES
           (@Currency
           ,@OldRate
           ,@Rate
           ,@Action
           ,GETDATE()
           ,@UserId)

	Select 1
	
END

GO

