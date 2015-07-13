SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/***
---------------------------------------------------------------------------------
-- 24 June 2015 : Nghia : Add Insert Script for [B_CUSTOMER_LIMIT_SUB_Load_for_tab_ORTHER_DETAILS] table for Bug51	
Credit	Product Limit: Approved Date,Offered ,Until Date, Expiry Date, Proposal Date

---------------------------------------------------------------------------------
***/
IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_CUSTOMER_LIMIT_SUB_Load_for_tab_ORTHER_DETAILS')
BEGIN
DROP PROCEDURE [dbo].[B_CUSTOMER_LIMIT_SUB_Load_for_tab_ORTHER_DETAILS]
END
GO
CREATE PROCEDURE [dbo].[B_CUSTOMER_LIMIT_SUB_Load_for_tab_ORTHER_DETAILS](@SubLimitID nvarchar(20))
AS BEGIN
--declare @SubLimitID nvarchar(20)
--set @SubLimitID  = '1000019.7700.01'


SELECT [SubLimitID]
      ,sub.[CustomerID]
      ,[SubCommitmentType]
      ,[STTSub]
      ,[Mode]
      ,sub.[CollateralTypeCode]
      ,sub.[CollateralTypeName]
      ,sub.[CollateralCode]
      ,sub.[CollateralName]
      ,[CollReqdAmt]
      ,[CollReqdPct]
      ,[UptoPeriod]
      ,[PeriodAmt]
      ,[PeriodPct]
      , convert(nvarchar,convert(money,[MaxSecured]),1) as MaxSecured
      , convert(nvarchar,convert(money,[MaxUnSecured]),1) as MaxUnSecured
      , convert(nvarchar,convert(money,[MaxTotal]),1) as MaxTotal
	  , convert(nvarchar,convert(money,[InternalLimitAmt]),1) as InternalLimitAmt
      , convert(nvarchar,convert(money,[AdvisedAmt]),1) as AdvisedAmt
      ,[OtherSecured]
      ,[CollateralRight]
      ,[AmtSecured]
      ,[Onlinelimit]
      ,[AvailableAmt]
      ,[TotalOutstand]
	  ,sub.[OfferedUntil]
	  ,sub.[ApprovedDate]
	  ,sub.[ExpiryDate]
	  ,sub.[ProposalDate]
	  ,sub.[Availabledate]
      ,sub.[CreatedDate]
      ,sub.[ApprovedUser], convert(nvarchar, sum ( [NominalValue])) as AmtSecured, ProductID
  FROM [dbo].[BCUSTOMER_LIMIT_SUB] as sub LEFT JOIN [dbo].[BCOLLATERAL_INFOMATION] as inf ON sub.CustomerID = inf.CustomerID 
  where [SubLimitID]= @SubLimitID group by [SubLimitID]
      ,sub.[CustomerID]
      ,[SubCommitmentType]
      ,[STTSub]
      ,[Mode]
      ,sub.[CollateralTypeCode]
      ,sub.[CollateralTypeName]
      ,sub.[CollateralCode]
      ,sub.[CollateralName]
      ,[CollReqdAmt]
      ,[CollReqdPct]
      ,[UptoPeriod]
      ,[PeriodAmt]
      ,[PeriodPct]
      ,MaxSecured
      , MaxUnSecured
      ,  MaxTotal,[InternalLimitAmt]
      ,[AdvisedAmt]
      ,[OtherSecured]
      ,[CollateralRight]
      ,[AmtSecured]
      ,[Onlinelimit]
      ,[AvailableAmt]
      ,[TotalOutstand]
	  ,sub.[OfferedUntil]
	  ,sub.[ApprovedDate]
	  ,sub.[ExpiryDate]
	  ,sub.[ProposalDate]
	  ,sub.[Availabledate]
      ,sub.[CreatedDate]
      ,sub.[ApprovedUser] ,ProductID  order by [CreatedDate] desc
  END
GO

/***
---------------------------------------------------------------------------------
-- 24 June 2015 : Nghia : Add Insert Script for [B_CUSTOMER_LIMIT_SUB_Load_for_tab_ORTHER_DETAILS] table for Bug51	
Credit	Product Limit: Approved Date,Offered ,Until Date, Expiry Date, Proposal Date

---------------------------------------------------------------------------------
***/
IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_CUSTOMER_LIMIT_SUB_Insert_Update')
BEGIN
DROP PROCEDURE [dbo].[B_CUSTOMER_LIMIT_SUB_Insert_Update]
END
GO
CREATE PROCEDURE [dbo].[B_CUSTOMER_LIMIT_SUB_Insert_Update](@MainLimitID nvarchar(20),@SubLimitID nvarchar(20), @CustomerID nvarchar(20), @SubCommitmentType nvarchar(10), @STTSub nvarchar(5)
			, @Mode nvarchar(20), @CollateralTypeCode nvarchar(20), @CollateralTypeName nvarchar(200), @CollateralCode nvarchar(20), @CollateralName nvarchar(200)
			, @CollReqdAmt nvarchar(30), @CollReqdPct nvarchar(50), @UptoPeriod nvarchar(100), @PeriodAmt nvarchar(30), @PeriodPct nvarchar(30),@MaxSecured DECIMAL(18,2)
			,@MaxUnSecured DECIMAL(18,2), @MaxTotal DECIMAL(18,2), @OtherSecured nvarchar(30), @CollateralRight nvarchar(100), @AmtSecured nvarchar(30), @Onlinelimit nvarchar(100)
			,@AvailableAmt nvarchar(30), @TotalOutstand nvarchar(50), @ApprovedUser nvarchar(50), @MainComtType nvarchar(10), @InternalLimitAmt decimal(18,2), @AdvisedAmt decimal(18,2)
			,@ProductID nvarchar(10), @ProductName nvarchar(250), @ApprovedDate datetime, @OfferedUntil datetime, @ExpiryDate datetime, @ProposalDate datetime, @Availabledate datetime)
AS 
IF Exists (select SubLimitID from [BCUSTOMER_LIMIT_SUB] where SubLimitID= @SubLimitID)
BEGIN
UPDATE [dbo].[BCUSTOMER_LIMIT_SUB] SET MainLimitID=@MainLimitID,[SubLimitID]= @SubLimitID,[CustomerID] = @CustomerID ,[SubCommitmentType] =  @SubCommitmentType,[STTSub] = @STTSub ,[Mode] = @Mode ,
[CollateralTypeCode] = @CollateralTypeCode ,[CollateralTypeName] = @CollateralTypeName ,[CollateralCode] =  @CollateralCode
      ,[CollateralName] = @CollateralName ,[CollReqdAmt] = @CollReqdAmt ,[CollReqdPct] = @CollReqdPct ,[UptoPeriod] = @UptoPeriod ,[PeriodAmt] = @PeriodAmt ,[PeriodPct] = @PeriodPct
	   ,[MaxSecured] = @MaxSecured ,[MaxUnSecured] = @MaxUnSecured ,[MaxTotal] = @MaxTotal ,[OtherSecured] = @OtherSecured ,[CollateralRight] =  @CollateralRight
      ,[AmtSecured] = @AmtSecured ,[Onlinelimit] = @Onlinelimit ,[AvailableAmt] = @AvailableAmt ,[TotalOutstand] = @TotalOutstand ,[ApprovedUser] =  @ApprovedUser, [MainComtType]=@MainComtType,
	  [InternalLimitAmt] = @InternalLimitAmt, [AdvisedAmt]=@AdvisedAmt, ProductID = @ProductID, ProductName = @ProductName
	  ,[ApprovedDate] = @ApprovedDate, [OfferedUntil] = @OfferedUntil, [ExpiryDate] = @ExpiryDate, [ProposalDate] = @ProposalDate, [Availabledate] = @Availabledate
	  WHERE SubLimitID= @SubLimitID
END
ELSE 
BEGIN
INSERT INTO [dbo].[BCUSTOMER_LIMIT_SUB](MainLimitID,[SubLimitID],[CustomerID],[SubCommitmentType],[STTSub],[Mode],[CollateralTypeCode],[CollateralTypeName],[CollateralCode]
      ,[CollateralName],[CollReqdAmt],[CollReqdPct],[UptoPeriod],[PeriodAmt],[PeriodPct],[MaxSecured],[MaxUnSecured],[MaxTotal],[OtherSecured],[CollateralRight]
      ,[AmtSecured],[Onlinelimit],[AvailableAmt],[TotalOutstand],[CreatedDate],[ApprovedUser],[MainComtType],[InternalLimitAmt], [AdvisedAmt], ProductID, ProductName
	  , [ApprovedDate], [OfferedUntil], [ExpiryDate], [ProposalDate], [Availabledate])
	  VALUES
	  (@MainLimitID,@SubLimitID,@CustomerID ,@SubCommitmentType,@STTSub ,@Mode ,@CollateralTypeCode ,@CollateralTypeName ,@CollateralCode,@CollateralName ,@CollReqdAmt 
	  ,@CollReqdPct ,@UptoPeriod ,@PeriodAmt ,@PeriodPct,@MaxSecured ,@MaxUnSecured ,@MaxTotal ,@OtherSecured ,@CollateralRight
      ,@AmtSecured ,@Onlinelimit ,@AvailableAmt ,@TotalOutstand ,getdate(),@ApprovedUser, @MainComtType,@InternalLimitAmt, @AdvisedAmt, @ProductID, @ProductName
	  , @ApprovedDate, @OfferedUntil, @ExpiryDate, @ProposalDate, @Availabledate)
END
GO
/***
---------------------------------------------------------------------------------
-- 24 June 2015 : Nghia : modify store [B_CUSTOMER_LIMIT_SUB_Load_InternalLimitAmt] for Bug51	
Credit	Product Limit: Approved Date,Offered ,Until Date, Expiry Date, Proposal Date

---------------------------------------------------------------------------------
***/
IF EXISTS(SELECT * FROM sys.procedures WHERE NAME = 'B_CUSTOMER_LIMIT_SUB_Load_InternalLimitAmt')
BEGIN
DROP PROCEDURE [dbo].[B_CUSTOMER_LIMIT_SUB_Load_InternalLimitAmt]
END
GO
CREATE PROCEDURE [dbo].[B_CUSTOMER_LIMIT_SUB_Load_InternalLimitAmt](@GlobalLimitID nvarchar(30))
as
SELECT [InternalLimitAmt], [ApprovedDate], [OfferedUntil], [ExpiryDate], [ProposalDate], [Availabledate] FROM [dbo].[BCUSTOMER_LIMIT_MAIN] WHERE [MainLimitID] = @GlobalLimitID

GO