delete MarcasAPH
GO
DECLARE @Vdate varchar(100);
--DECLARE @instr varchar(150);

--'H:\Adam14_12_11_4_0.txt'

--SET @Vdate = 'H:\Adam'+DATEPART(dd,GETDATE()) +'_'+DATEPART(mm,GETDATE())+'_'+DATEPART(yy,GETDATE())


SET @Vdate = 'C:\inetpub\ftproot\marcador\' + 
substring('00'+convert(varchar,DATEPART(dd,GETDATE())),3,2) +'_' +
convert(varchar,DATEPART(mm,GETDATE()))+'_' +
--substring('00'+convert(varchar,DATEPART(mm,GETDATE())),2,2)+'_' +
substring(convert(varchar,DATEPART(yy,GETDATE())),3,2)


--select @Vdate
--SET @instr = 'BULK insert MarcasAPH from '+'''' + @Vdate + '_9_30.txt' +''''+
--' WITH
--(FIELDTERMINATOR = ' + ''''+' '+'''' + ', ' + --separa campos
--'ROWTERMINATOR = ' + ''''+'\n'+'''' + ')'
--SELECT @instr
--select @Vdate = 'MarcasAPH'
--exec('select COUNT(1) from'+ @Vdate)

exec('BULK insert MarcasAPH from '+ '''' + @Vdate + '_4_0.txt' +''''+
' WITH
(FIELDTERMINATOR = ' + ''''+' '+'''' + ', ' + --separa campos
'ROWTERMINATOR = ' + ''''+'\n'+'''' + ')'
)
GO
DECLARE @Vdate varchar(100);
SET @Vdate = 'C:\inetpub\ftproot\marcador\' + 
substring('00'+convert(varchar,DATEPART(dd,GETDATE())),3,2) +'_' +
convert(varchar,DATEPART(mm,GETDATE()))+'_' +
--substring('00'+convert(varchar,DATEPART(mm,GETDATE())),2,2)+'_' +
substring(convert(varchar,DATEPART(yy,GETDATE())),3,2)


exec('BULK insert MarcasAPH from '+ '''' + @Vdate + '_9_30.txt' +''''+
' WITH
(FIELDTERMINATOR = ' + ''''+' '+'''' + ', ' + --separa campos
'ROWTERMINATOR = ' + ''''+'\n'+'''' + ')'
)
GO
DECLARE @Vdate varchar(100);
SET @Vdate = 'C:\inetpub\ftproot\marcador\' +
substring('00'+convert(varchar,DATEPART(dd,GETDATE())),3,2) +'_' +
convert(varchar,DATEPART(mm,GETDATE()))+'_' +
--substring('00'+convert(varchar,DATEPART(mm,GETDATE())),2,2)+'_' +
substring(convert(varchar,DATEPART(yy,GETDATE())),3,2)

exec('BULK insert MarcasAPH from '+ '''' + @Vdate + '_10_0.txt' +''''+
' WITH
(FIELDTERMINATOR = ' + ''''+' '+'''' + ', ' + --separa campos
'ROWTERMINATOR = ' + ''''+'\n'+'''' + ')'
)
GO