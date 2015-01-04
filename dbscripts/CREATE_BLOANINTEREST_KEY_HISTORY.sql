/****** Object:  Table [dbo].[BLOANINTEREST_KEY_HISTORY]    Script Date: 1/4/2015 9:42:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[BLOANINTEREST_KEY_HISTORY](
	[Id] [int] IDENTITY(1,1)  NOT NULL,
	[MonthLoanRateNo] [bigint] NOT NULL,
	[VND_InterestRate] [decimal](18, 2) NULL,
	[VND_InterestRate_New] [decimal](18, 2) NULL,
	[USD_InterestRate] [decimal](18, 2) NULL,
	[USD_InterestRate_New] [decimal](18, 2) NULL,
	[Actions] nvarchar(50) null,
	[CreatedDateTime] datetime null,
	[CreatedBy] int null
 CONSTRAINT [PK_BLOANINTEREST_KEY_HISTORY] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[BLOANINTEREST_KEY_HISTORY] ADD  DEFAULT ((0)) FOR [MonthLoanRateNo]
GO


