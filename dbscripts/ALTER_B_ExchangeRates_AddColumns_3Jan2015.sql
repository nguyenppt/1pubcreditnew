SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TABLE B_ExchangeRates
ADD [Id] [int] IDENTITY(1,1)  NOT NULL ;

ALTER TABLE [B_ExchangeRates] 
ADD CONSTRAINT [PK_B_ExchangeRates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
);