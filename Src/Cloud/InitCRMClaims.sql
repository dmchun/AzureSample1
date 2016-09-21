﻿DECLARE @CurrentMigration [nvarchar](max)

IF object_id('[dbo].[__MigrationHistory]') IS NOT NULL
    SELECT @CurrentMigration =
        (SELECT TOP (1) 
        [Project1].[MigrationId] AS [MigrationId]
        FROM ( SELECT 
        [Extent1].[MigrationId] AS [MigrationId]
        FROM [dbo].[__MigrationHistory] AS [Extent1]
        WHERE [Extent1].[ContextKey] = N'ContosoInsurance.Common.Data.Migrations.CRMClaimsConfiguration'
        )  AS [Project1]
        ORDER BY [Project1].[MigrationId] DESC)

IF @CurrentMigration IS NULL
    SET @CurrentMigration = '0'

IF @CurrentMigration < '201609200110007_AutomaticMigration'
BEGIN
    CREATE TABLE [dbo].[ClaimImages] (
        [Id] [int] NOT NULL IDENTITY,
        [ClaimId] [int] NOT NULL,
        [ImageUrl] [nvarchar](max),
        CONSTRAINT [PK_dbo.ClaimImages] PRIMARY KEY ([Id])
    )
    CREATE TABLE [dbo].[Claims] (
        [Id] [int] NOT NULL IDENTITY,
        [VehicleId] [int] NOT NULL,
        [OtherPartyId] [int] NOT NULL,
        [DateTime] [datetime] NOT NULL,
        [DueDate] [datetime] NOT NULL,
        [Coordinates] [geography],
        [CorrelationId] [uniqueidentifier] NOT NULL,
        [Status] [int] NOT NULL,
        [Type] [nvarchar](max),
        [DamageAssessment] [int],
        [Description] [nvarchar](max),
        CONSTRAINT [PK_dbo.Claims] PRIMARY KEY ([Id])
    )
    CREATE TABLE [dbo].[OtherParties] (
        [Id] [int] NOT NULL IDENTITY,
        [FirstName] [nvarchar](max),
        [LastName] [nvarchar](max),
        [Street] [nvarchar](max),
        [City] [nvarchar](max),
        [State] [nvarchar](max),
        [Zip] [nvarchar](max),
        [DOB] [date],
        [MobilePhone] [nvarchar](max),
        [PolicyId] [nvarchar](max),
        [PolicyStart] [date],
        [PolicyEnd] [date],
        [DriversLicenseNumber] [nvarchar](max),
        [LicensePlate] [nvarchar](max),
        [VIN] [nvarchar](max),
        [LicensePlateImageUrl] [nvarchar](max),
        [InsuranceCardImageUrl] [nvarchar](max),
        [DriversLicenseImageUrl] [nvarchar](max),
        CONSTRAINT [PK_dbo.OtherParties] PRIMARY KEY ([Id])
    )
    CREATE TABLE [dbo].[CustomerVehicles] (
        [Id] [int] NOT NULL IDENTITY,
        [CustomerId] [int] NOT NULL,
        [LicensePlate] [nvarchar](max),
        [VIN] [nvarchar](max),
        [ImageURL] [nvarchar](max),
        CONSTRAINT [PK_dbo.CustomerVehicles] PRIMARY KEY ([Id])
    )
    CREATE TABLE [dbo].[Customers] (
        [Id] [int] NOT NULL IDENTITY,
        [UserId] [nvarchar](max),
        [FirstName] [nvarchar](max),
        [LastName] [nvarchar](max),
        [Street] [nvarchar](max),
        [City] [nvarchar](max),
        [State] [nvarchar](max),
        [Zip] [nvarchar](max),
        [Email] [nvarchar](max),
        [MobilePhone] [nvarchar](max),
        [DriversLicenseNumber] [nvarchar](max),
        [DOB] [date] NOT NULL,
        [PolicyId] [nvarchar](max),
        [PolicyStart] [date] NOT NULL,
        [PolicyEnd] [date] NOT NULL,
        CONSTRAINT [PK_dbo.Customers] PRIMARY KEY ([Id])
    )
    CREATE INDEX [IX_ClaimId] ON [dbo].[ClaimImages]([ClaimId])
    CREATE INDEX [IX_VehicleId] ON [dbo].[Claims]([VehicleId])
    CREATE INDEX [IX_OtherPartyId] ON [dbo].[Claims]([OtherPartyId])
    CREATE INDEX [IX_CustomerId] ON [dbo].[CustomerVehicles]([CustomerId])
    ALTER TABLE [dbo].[ClaimImages] ADD CONSTRAINT [FK_dbo.ClaimImages_dbo.Claims_ClaimId] FOREIGN KEY ([ClaimId]) REFERENCES [dbo].[Claims] ([Id]) ON DELETE CASCADE
    ALTER TABLE [dbo].[Claims] ADD CONSTRAINT [FK_dbo.Claims_dbo.OtherParties_OtherPartyId] FOREIGN KEY ([OtherPartyId]) REFERENCES [dbo].[OtherParties] ([Id]) ON DELETE CASCADE
    ALTER TABLE [dbo].[Claims] ADD CONSTRAINT [FK_dbo.Claims_dbo.CustomerVehicles_VehicleId] FOREIGN KEY ([VehicleId]) REFERENCES [dbo].[CustomerVehicles] ([Id]) ON DELETE CASCADE
    ALTER TABLE [dbo].[CustomerVehicles] ADD CONSTRAINT [FK_dbo.CustomerVehicles_dbo.Customers_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customers] ([Id]) ON DELETE CASCADE
    CREATE TABLE [dbo].[__MigrationHistory] (
        [MigrationId] [nvarchar](150) NOT NULL,
        [ContextKey] [nvarchar](300) NOT NULL,
        [Model] [varbinary](max) NOT NULL,
        [ProductVersion] [nvarchar](32) NOT NULL,
        CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY ([MigrationId], [ContextKey])
    )
    INSERT [dbo].[__MigrationHistory]([MigrationId], [ContextKey], [Model], [ProductVersion])
    VALUES (N'201609200110007_AutomaticMigration', N'ContosoInsurance.Common.Data.Migrations.CRMClaimsConfiguration',  0x1F8B0800000000000400ED5DDD6EEBB811BE2FD0771074D51667E32467B1D80D9C5D649DE4C068FE102707456F0E688971D84A9457A48204459FAC17FB48FB0A25F5CB3F499465294E90BB98223F0E6786C32139C3FCF1BFDFA7BF3C8781F3046382227CEC1EECEDBB0EC45EE423BC3A7613FAF0DD8FEE2F3FFFF94FD3333F7C76BE16F53EF37AAC2526C7EE23A5EBA3C984788F3004642F445E1C91E881EE795138017E3439DCDFFF69727030810CC265588E33BD4D3045214C7FB09FB3087B704D13105C463E0C485ECEBE2C5254E70A8490AC81078F5D569732FC3926490C58B3BD59148611DE3B0514ECCD6E2F5DE7244080D1B580C183EB008C230A28A3FAE89EC0058D23BC5AAC590108EE5ED690D57B000181F9688EAAEAB603DB3FE4039B540D0B282F21340A3B021E7CCE3935519B6FC46FB7E424E3E519E3397DE1A34EF9C958190014CE43B062C357BB3B9A0531AFDACEF0BD0AE6935353F953A93A4CC3F67E38D8FF61EFF38FFBDFFFC41A24014D62788C614263107C726E926580BCBFC397BBE8DF101FE32408C451B071B06F52012BBA89A3358CE9CB2D7CC8C736F75D6722B79BA80DCB66429B6CCC734C3F1FBACE15EB1C2C03582A89C09F058D62F8056218030AFD1B40298C31C780299BB5DE95BE32A6B576D80C9232FD3E0E0A14A6DE6CDEBACE2578BE8078451F8F5DF6A7EB9CA367E8172539F23D466C9AB346344EF48EAEC0135AA50335D1ED3AB73048BF9247B4CEA65AA606DF529208EB328EC2DB28285AE4E5DFEE40BC8294D11B193E2EA224F6145AA6934A6DDB95B9BF1E7FA8B0B50A7F858FC80B605F25BEA68F30BE01ACA02F129324BC63CB4A8152FDEE0A9440DEB637CE2C8A62B692B2E6A4C0FA02A3550CD68FED06228AE37C92557CF99220BF33150B26EEA424A09AAB457947380EB37D83A389929B84134220212153479D7ABD460B22245E8CD6D9523A9AB92CCCE1A6F6B23089467B5918535B62AA99D64090584925AAFA56439850A12B71B93569A0ACACA192957FA8A1A9F86A22C87A7511B9D26389A9603ED619EB75E61CC584F23F07B73A1760A48E18308474F06E662977071F8BB0540ED6CB3FD17AF845E7FA577DC96F6E72192D51006F1E233C3C0B6E2236DB052769E08E985C63DA951F59D333EC776D781A237E0A71813C8809BC4AC2258C879FEF596F37C1181AFC757E35EA8086DB1CAA6B41B182CD40EC8FD6ABAC3003756BBFFB4C7D0218973E4A9F7DA88CF5E129D81FAAE49CEBBB917C7776219B1EB717631E14E5B2303BF4F9C7C239973740EA47FDD448ABD1EFE8A824750BB3F663BA5A4FD77B224ED5C194FF63FFF0B17F1865FF70160234BCE333E696E355BC72E336ACE30ABE1B7BA58D88366E9EDA90DA8ED56A8E20BB2DC3DAF95AED426DB70C27A17A7F531C49CFC9790056D5E56CDF5B9D0C77A8A599698C0FE3E0856998B874CA12BA847CF214362F598688AD964CD25F4190B0927D4DA4528393844627EB751C3D096D0EDADBDCC27F414FECE7B0B9CD25C00908B49E3EDBB4D2FAFA5E57844CE46D6AA09FED6F5B21D41E7647352E114621086C1583074CC4E9026AA7140BC80C3AAC5307B388189B220FA57C16A554DC5DC8BD31F3E5345D6428D738CC24333EA235E31CB3119C7CD5AFBDC6A73080143A275E16463103C403BE6E0319EDBE152DE57642A1250F859009FA9BD60F73B0190B310F21614A4398F011A6BA378EB087D620686086D2C6D287E7232DD1D52FA7700D3177BF1BC66DD36D199EA0F75D76A170BF8D2DD389A04736EA25DCB9348BD5742DD5A266BA541B400DFA22DE070DA8C03D544DA77F3475D3E561D3B51C07F03A7AA7F943B53A52EF1C099A579E2B8C63E3EACF4D749ACA83CA61AC5D1D7BC6D0C13A3658D93DE104F1154D5F219D6613A5DD7BF7367AEA5DB9BDE2EC8AD95346309ACD536461D3AF103F3582AA659B30EEE5B216A53B98124F4E97BC1C3E5383637D4F60EE5B937C47ACAA10C75D40AA0595B27D5CB5F333F8599A2E1A806A315A9B97CB093212222EE06D84C89A6F24499D1C96904D581A882058854B65149150C51465A46A598BAF5E525D094353D416175B852808554D803C36EB718B52AC1B7B9D1B69E7486EC20383EB28C0C88AD99F11FA198E8113CD8E8DA56B23F2A252E02676D47A2406A88AFE2D29473919EB34C3B8CA5AACB39BE884BAB26E8701C5D95A69D6CB6FD349963A91174C27353916D34BB05E23BC12722EF2126791275C7CB7E89E7B106618138F1852104A6ACB9E681433BBA07CE567393E4C6F6FF8E1CD12F0839F991FEAD59445ACC6F616BDE9EB942EBCC226176DF8DF455CAE753A84C10BC8F1CED970F9B1533A726834927A6387A7C38000C4862BBB59142421AEF767EA5B973B7D11A276FBDF4045198121D15296EA48D389C20DCD09D2E4A0398EB268ED053F84CC3715F7589216FC4D11A4C10DADC79237EB225CF336BE1EB1BAEB10D1EAC2C71A918AE87D09A828EC3033C4E87D6976881FBAE04911FD32A2F4C91EB3B83011C18A327B942CA45FC4C84ABA484F3DB197A5D81CABDF882CC6ED4BA0E2879DB12E9277B7551B53EFC75A189AA6C6C3581B21EA4204118AEDB1AAB80A11AA2AED325FB2C00979BE64651D66721A17214D6043B84B331D9A85CA8BEC31D2900611212DE830B3F83DBB34A378817D7B291041C4913ED8E35577F6225855DA1529BF94D7C1F20F5DF1D28B791D2D2DEEC0756348852406638D0EB3458A5E94668CF4A583E7C04314259F81176C4691D94F34D7E8E07D9A639025F365AEB2A9E4CC9DD4D5D999F549DB6C6ED70F56CEC136F088DB1006DA0509E7FE925D6FB80FA847DBBD19580500EBBB335EBA73FA399062F6D0C8B154B1888A15118AB20FF7EBFDB85F79B4A8889017BD9E0B36BC73D2D7E97C5F4EE2A046563B1C56AB94BD9787C4CA61F0343F98B579954739A9CDAAB80E63D213F2F929EDE2855018662679F15B300B507A125054B804183D4042B3E039F770FFE05079CA67779ED59910E20786836DF3DB3AB2C446C8DC409CAFADB9195DDFB2901FAC49FBD02E8BE7D887CFC7EE7FD23647CEFC1FDFF2669F9CEB9809F9C8D977FEDBFB991BFC0462EF11C47F09C1F35F45B43E097CFA49EC9B1595F6308BADB0CA86BDC4657AD0C59602B16D2F22D4B7607CF69B6EE12D988D710C6FC1ACAAB7609A74D88465781B26C1E8B704A254691E105F957BBD13934AACC7D3301D26A9497AE6E75F14A2ACA0F4775F86B01FB5C1AA6FD588685973BD04AA66C6F50293B3DF7A4189196E3D69128C442F242153ADDF1CAAD2A8FC94B66ECD0D6966BDC85133B2B60026655D6D32462DE16A1390A61CB97E73C69085DE0B50C834DF1A613D7C3383496B7A49A2DF64687C2D621087B2E920F3CDAE0AFA0B0BD61B81B2652FBF6E672785FAC4C2903AF54E9449CEFFEFC5FD0F6FE58D7B2B52EE7C2FA46D3B2E83ADEF0D0EDA4639EE437B549BE5B05BA0D4D9BF3E79A7AF9B699A67388C9E603A5ABE4B5D7CEB9BCD24153309C6CFF3ECACBC5B529AC698B26134E7FDE682EE42EE6799F3F06A299F63A678D68799BCDDCCCECD05F92E2CD226A21DCD2CED44C6A69613A30AAE2E1FB3251D33BBB1650EDB3262D2CE9CB5A69C3D6347F5E99AB5F0EDC8E222DC98C869EAA331DDAE25D5D326D3D338AEB68CAEBA7E1BD3419B7AD2BB183C5B54CF8333CC0AB35F6C4E78D28CD26B2785EA7AA7C6D2B70EB89D49BB94F2694C4B6C1EA479C2184339B725DF6DE4756E4EF69665DC2183530FC6618B8BF08FB4D8C246D0AA82E0FF560B434F5A56CA3A73FC10150B9C425151453D578114B0CD3C3861A6F40178947DF62021E9B37AF96B5267E112FA737C9DD07542F9ED6DB80CA449C257C9A6FED3345599E6E9757A774BB631044626E2E711D7F8D70405D54365E78633891A08BEFCE647A05C96941F85AE5E4AA42B2DE0AE0E28675FE935DCC170CD0FB5C9355E8027B8096DF7045EC015F05E8A98AA7A907641C86C9F9E22B08A4148728CAA3DFBC974D80F9F7FFE3F37DE0EE74F6E0000 , N'6.1.3-40302')
END
