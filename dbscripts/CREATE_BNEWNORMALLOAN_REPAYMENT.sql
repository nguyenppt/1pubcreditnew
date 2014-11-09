SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[BNEWNORMALLOAN_REPAYMENT](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](20) NOT NULL,	
	[RepaymentTimes] [int] NOT NULL DEFAULT 0,
	[LoanAmount] [numeric](18, 4) NOT NULL DEFAULT 0,
	[ActivatedDate] [date] NULL,
	[EndDate] [date] NULL,	
 CONSTRAINT [PK_BNEWNORMALLOAN_REPAYMENT] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


INSERT INTO [BNEWNORMALLOAN_REPAYMENT] 
([Code], [RepaymentTimes], [LoanAmount], [ActivatedDate])
SELECT [Code], 0, [LoanAmount], [DrawdownDate] FROM [BNEWNORMALLOAN]
GO
