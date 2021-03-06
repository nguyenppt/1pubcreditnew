SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TABLE BCASH_REPAYMENT
ADD [RepaidLoanFlag] INT   NOT NULL DEFAULT 0,
	[ID_KEY] [int] IDENTITY(1,1)  NOT NULL ;

ALTER TABLE [BCASH_REPAYMENT] 
ADD CONSTRAINT [PK_BCASH_REPAYMENT] PRIMARY KEY CLUSTERED 
(
	[ID_KEY] ASC
);