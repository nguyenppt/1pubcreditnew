SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TABLE [B_LOAN_PROCESS_PAYMENT]
ADD [Interest] numeric(18,5) NOT NULL DEFAULT 0,
 [ProcessedDays] int NOT NULL DEFAULT 0,
 [InterestedAmountPerday] numeric(18,5) NOT NULL DEFAULT 0;

GO


UPDATE [B_LOAN_PROCESS_PAYMENT] SET [Interest] = s.[Interest]
FROM B_NORMALLOAN_PAYMENT_SCHEDULE s
WHERE s.Code = [B_LOAN_PROCESS_PAYMENT].Code
	AND s.Period = [B_LOAN_PROCESS_PAYMENT].Period
	AND s.PeriodRepaid = [B_LOAN_PROCESS_PAYMENT].PeriodRepaid;


