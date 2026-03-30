<cfset LvarReal=sqr(2)*10>
<cfset xx = 0>
<cfset LvarDSNs = arrayNew(2)>
	<cfset LvarDSNs[1][1] = "SYBASE"> 	<cfset LvarDSNs[1][2] = "asp">			<cfset LvarDSNs[1][3] = "">
	<cfset LvarDSNs[2][1] = "MS_SQL"> 	<cfset LvarDSNs[2][2] = "asp_MSSQL">	<cfset LvarDSNs[2][3] = "">
	<cfset LvarDSNs[2][1] = "ORACLE"> 	<cfset LvarDSNs[2][2] = "asp_oracle">	<cfset LvarDSNs[2][3] = "">
	<cfset LvarDSNs[3][1] = "DB2"> 		<cfset LvarDSNs[3][2] = "asp_db2">		<cfset LvarDSNs[3][3] = "">

<cfset LvarIni = getTickCount()>
<!---		
		<cf_dbtempcol name="S_BINARY" type="binary">
		<cf_dbtempcol name="S_BINARY_10" type="binary(10)">
		<cf_dbtempcol name="S_IMAGE" type="image">
		<cf_dbtempcol name="S_TEXT" type="text">
		<cf_dbtempcol name="S_VARBINARY" type="varbinary">
		<cf_dbtempcol name="S_VARBINARY_10" type="varbinary(10)">
--->
	<cfloop from="1" to="#arraylen(LvarDSNs)#" index="i">
		<cfquery name="rsSQL" datasource="#LvarDSNs[i][2]#" timeout="5"> 
			select 1 from dual
		</cfquery>
	</cfloop>
	<cfloop from="1" to="#arraylen(LvarDSNs)#" index="i">
dbtempINI<BR>
	<cf_dbtemp name="dtp15_#LvarDSNs[i][1]#" returnVariable="LvarTmp" datasource="#LvarDSNs[i][2]#" temp="false">
		<cf_dbtempcol name="S_BINARY" type="binary">
		<cf_dbtempcol name="S_BINARY_10" type="binary(10)">
		<cf_dbtempcol name="S_IMAGE" type="image">
		<cf_dbtempcol name="S_TEXT" type="text">
		<cf_dbtempcol name="S_VARBINARY" type="varbinary">
		<cf_dbtempcol name="S_VARBINARY_10" type="varbinary(10)">

		<cf_dbtempcol name="S_IDENTITY" type="numeric"  mandatory="yes" identity>

		<cf_dbtempcol name="S_BIT" type="bit" mandatory="yes">
		<cf_dbtempcol name="S_CHAR" type="char">
		<cf_dbtempcol name="S_CHAR_10" type="char(10)">
		<cf_dbtempcol name="S_DATE" type="date">
		<cf_dbtempcol name="S_DATETIME" type="datetime default getdate()#LvarDSNs[i][3]#">
		<cf_dbtempcol name="S_DEC" type="dec">
		<cf_dbtempcol name="S_DEC_10" type="dec(10)">
		<cf_dbtempcol name="S_DEC_10_2" type="dec(10,2)">
		<cf_dbtempcol name="S_DECIMAL" type="decimal">
		<cf_dbtempcol name="S_DECIMAL_10" type="decimal(10)">
		<cf_dbtempcol name="S_DECIMAL_10_2" type="decimal(10,2)">
		<cf_dbtempcol name="S_FLOAT" type="float">
		<cf_dbtempcol name="S_FLOAT_8" type="float(8)">
		<cf_dbtempcol name="S_FLOAT_7" type="float(7)">
		<cf_dbtempcol name="S_INT" type="int">
		<cf_dbtempcol name="S_INTEGER" type="integer">
		<cf_dbtempcol name="S_MONEY" type="money">
		<cf_dbtempcol name="S_NUMERIC" type="numeric">
		<cf_dbtempcol name="S_NUMERIC_10" type="numeric(10)">
		<cf_dbtempcol name="S_NUMERIC_10_2" type="numeric(10,2)">
		<cf_dbtempcol name="S_REAL" type="real">
		<cf_dbtempcol name="S_SMALLDATETIME" type="smalldatetime">
		<cf_dbtempcol name="S_SMALLINT" type="smallint">
		<cf_dbtempcol name="S_SMALLMONEY" type="smallmoney">
		<cf_dbtempcol name="S_TIMESTAMP" type="timestamp">
		<cf_dbtempcol name="S_TINYINT" type="tinyint">
		<cf_dbtempcol name="S_VARCHAR" type="varchar">
		<cf_dbtempcol name="S_VARCHAR_10" type="varchar(10)">
		<cf_dbtempkey cols="S_INT">
		<cf_dbtempkey cols="S_INTEGER">
	</cf_dbtemp>
dbtempFIN<BR>
	<cfoutput>create #LvarTmp# : #getTickCount()-LvarIni#<BR></cfoutput><cfset LvarIni = getTickCount()>
<!---
	<cfquery name="rsSQL" datasource="#LvarDSNs[i][2]#">
		drop table #LvarTMP#
	</cfquery>
	<cfoutput>drop #LvarTMP# : #getTickCount()-LvarIni#<BR></cfoutput><cfset LvarIni = getTickCount()>
--->
	<cf_dbtemp name="dbf8_#LvarDSNs[i][1]#" returnVariable="LvarTmp" datasource="#LvarDSNs[i][2]#">
		<cf_dbtempcol name="DB" type="varchar(40)">
		<cf_dbtempcol name="Hilera" type="varchar(40)">
		<cf_dbtempcol name="Fecha" type="datetime">
		<cf_dbtempcol name="Fecha00" type="datetime">
		<cf_dbtempcol name="FechaDMY" type="varchar(20)">
		<cf_dbtempcol name="FechaYMD" type="varchar(20)">
		<cf_dbtempcol name="Flotante" type="float">
		<cf_dbtempcol name="FlotanteSTR" type="varchar(20)">
		<cf_dbtempcol name="Monto" type="money">
		<cf_dbtempcol name="MontoSTR" type="varchar(20)">
		<cf_dbtempcol name="Numeric"   type="numeric(18,2)">
		<cf_dbtempcol name="Numeric00" type="numeric(18,2)">
		<cf_dbtempcol name="Numeric12" type="numeric(18,2)">
		<cf_dbtempcol name="Numeric89" type="numeric(18,2)">
		<cf_dbtempcol name="Numero" type="integer">
		<cf_dbtempcol name="NumeroSTR" type="varchar(20)">
	</cf_dbtemp>
	<cfoutput>#LvarTMP# : #getTickCount()-LvarIni#<BR></cfoutput><cfset LvarIni = getTickCount()>
	<cfset LvarDSNs[i][3] = LvarTMP>
	<cfquery name="rsSQL" datasource="#LvarDSNs[i][2]#">
		insert into #LvarDSNs[i][3]# values (
			'#LvarDSNs[i][1]#', 
			'hola', 
			#createDatetime(2008,10,1,10,30,10)#, #createDatetime(2008,10,1,0,0,0)#, '01/02/2000 10:30:05', '2000-02-01 10:30:05', 
			#LvarReal*2#, '#LvarReal*2#',
			#round(LvarReal*100*100)/100#, '#round(LvarReal*100*100)/100#', 
			123456789012345.67, 1234, 1234.12, 1234.89,
			123, '123')
	</cfquery>
	<cfoutput>insert into #LvarTMP# : #getTickCount()-LvarIni#<BR></cfoutput><cfset LvarIni = getTickCount()>
</cfloop>

<table border="1" style=" font-family:Verdana; font-size:10px; border:solid 1px ##CCCCCC">
	<tr>
		<td>
			<strong>DBfunction</strong>
		</td>
	<cfloop from="1" to="#arraylen(LvarDSNs)#" index="i">
		<td>&nbsp;</td>
		<td>
			<strong><cfoutput>#LvarDSNs[i][2]#</cfoutput></strong>
		</td>
	</cfloop>
	</tr>

	<tr>
		<td>
			<strong>DATOS</strong>
		</td>
	<cfloop from="1" to="#arraylen(LvarDSNs)#" index="i">
		<cfquery name="rsSQL" datasource="#LvarDSNs[i][2]#">
			select * from #LvarDSNs[i][3]#
		</cfquery>
		<td>&nbsp;</td>
		<td nowrap="nowrap">
		<cfloop list="#rsSQL.columnList#" index="LvarCol">
			<cfoutput>
			<cfset LvarValor = rsSQL[LvarCol]>
			#LvarCol# = #LvarValor#<BR>	
			</cfoutput>
		</cfloop>
		</td>
	</cfloop>
	</tr>
<cfset LvarFunction1 = "">

<cfset x("length", "Hilera")>
<cfset x("length", "'Hilera'")>

<cfset LvarDBFun = "datediffTot">
<cfset LvarFecha1 = "09/11/1966">
<cfset LvarFechaFin = "'09/11/1966'">
<cfset LvarFechaIni = createODBCdate(now())>
<cfset x("to_date", "#LvarFechaFin#")>
<cfset x("to_date00", "#LvarFechaFin#")>
<cfset x("to_date", "#LvarFechaFin#")>
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,yyyy")>
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,yy")>
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,mm")>
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,wk")>
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,dd")>
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,hh")>
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,mi")>
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,ss")>
<cfoutput>hola</cfoutput>
<cfset LvarDBFun = "dateDiff">
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,yyyy")>
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,yy")>
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,mm")>
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,wk")>
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,dd")>
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,hh")>
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,mi")>
<cfset x("#LvarDBFun#", "#LvarFechaIni#,#LvarFechaFin#,ss")>
<cfabort>

<cfset x("concat", "Hilera,' ','abcd',' ','#LvarReal#'")>
<cfset x("concat", "Hilera+' '+'abcd'+' '+'#LvarReal#'", "", "+")>
<cfset x("concat", "Hilera||' '||'abcd'||' '||'#LvarReal#'","", "||")>


<cfset x("length", "Hilera")>
<cfset x("length", "'Hilera'")>

<cfset x("spart" , "Hilera,1,2")>
<cfset x("spart" , "'Hilera',1,2")>

<cfset x("sreplace", "Hilera,'o','a'")>
<cfset x("sreplace", "Hilera,Hilera,'a'")>
<cfset x("sreplace", "Hilera,'o',Hilera")>
<cfset x("sreplace", "Hilera,Hilera,Hilera")>
<cfset x("sreplace", "'Hilera','e','xx'")>

<cfset x("srepeat", "Hilera,2")>
<cfset x("srepeat", "'Hilera',2")>
<cfset x("srepeat", "'*',2")>
<cfset x("srepeat", "'* ',Numero")>

<cfset x("sfind", "Hilera,'a'")>
<cfset x("sfind", "Hilera,Hilera")>
<cfset x("sfind", "'Hilera','a'")>
<cfset x("sfind", "'Hilera',Hilera")>

<cfset x("sfind", "Hilera,'a',2")>
<cfset x("sfind", "Hilera,Hilera,2")>
<cfset x("sfind", "'Hilera','a',2")>
<cfset x("sfind", "'Hilera',Hilera,2")>

<cfset x("OP_concat", "", "")>

<cfset x("to_char", "'abcd'")>

<cfset LvarFunciones = "to_char,to_number,to_integer,to_float,to_char_integer,to_char_float,to_char_currency">
<cfset x("to_number", "1.99")>
<cfset x("to_number", "-1.99")>
<cfset x("to_number", "1.99"	,"1")>
<cfset x("to_number", "-1.99"	,"1")>
<cfset x("to_number", "1.88"	,"1")>
<cfset x("to_number", "-1.88"	,"1")>
<cfset x("to_number", "1.99"	,"2")>
<cfset x("to_number", "-1.99"	,"2")>
<cfset x("to_number", "1.88"	,"2")>
<cfset x("to_number", "-1.88"	,"2")>
<cfset x("to_number", "1.99"	,"3")>
<cfset x("to_number", "-1.99"	,"3")>
<cfset x("to_number", "1.88"	,"3")>
<cfset x("to_number", "-1.88"	,"3")>
<cfset x("to_float", "1.99")>
<cfset x("to_float", "-1.99")>
<cfset x("to_float", "1.99" 	,"1")>
<cfset x("to_float", "-1.99"	,"1")>
<cfset x("to_float", "1.88" 	,"1")>
<cfset x("to_float", "-1.88"	,"1")>
<cfset x("to_float", "1.99" 	,"2")>
<cfset x("to_float", "-1.99"	,"2")>
<cfset x("to_float", "1.88" 	,"2")>
<cfset x("to_float", "-1.88"	,"2")>
<cfset x("to_float", "1.99" 	,"3")>
<cfset x("to_float", "-1.99"	,"3")>
<cfset x("to_float", "1.88" 	,"3")>
<cfset x("to_float", "-1.88"	,"3")>

<cfloop list="#LvarFunciones#" index="LvarFuncion">
	<cfset x(LvarFuncion, "0")>
	<cfset x(LvarFuncion, "1")>
	<cfset x(LvarFuncion, "-1")>
	<cfset x(LvarFuncion, "0.5")>
	<cfset x(LvarFuncion, "-0.5")>
	<cfset x(LvarFuncion, "9.87")>
	<cfset x(LvarFuncion, "-9.87")>
	<cfset x(LvarFuncion, "9")>
	<cfset x(LvarFuncion, "-9")>
	<cfset x(LvarFuncion, "24")>
	<cfset x(LvarFuncion, "-24")>
	<cfset x(LvarFuncion, "1234")>
	<cfset x(LvarFuncion, "-1234")>
	<cfset x(LvarFuncion, "1234.99")>
	<cfset x(LvarFuncion, "-1234.99")>
	<cfset x(LvarFuncion, "1000.123456789")>
	<cfset x(LvarFuncion, "-1000.123456789")>
	<cfset x(LvarFuncion, "#LvarReal#")>
	<cfset x(LvarFuncion, "#-LvarReal#")>
	<cfset x(LvarFuncion, "'#LvarReal#'")>
	<cfset x(LvarFuncion, "'-#LvarReal*1000#'")>
	<cfset x(LvarFuncion, "Flotante")>
	<cfset x(LvarFuncion, "FlotanteSTR")>
	<cfset x(LvarFuncion, "Monto")>
	<cfset x(LvarFuncion, "MontoSTR")>
	<cfset x(LvarFuncion, "Numeric")>
	<cfset x(LvarFuncion, "Numeric00")>
	<cfset x(LvarFuncion, "Numeric12")>
	<cfset x(LvarFuncion, "Numeric89")>
	<cfset x(LvarFuncion, "Numero")>
	<cfset x(LvarFuncion, "NumeroSTR")>
</cfloop>

<cfset x("to_date", "FechaDMY")>
<cfset x("to_date", "'01-02-2000 03:04:05'")>
<cfset x("to_date", "'01/02/2000 03:04:05'")>
<cfset x("to_date", "'01/02/2000'")>
<cfset x("to_date", "#createODBCdate(now())#")>
<cfset x("to_date", "#createODBCdatetime(now())#")>

<cfset x("to_datetime", "FechaDMY")>
<cfset x("to_datetime", "'01-02-2000 03:04:05'")>
<cfset x("to_datetime", "'01/02/2000 03:04:05'")>
<cfset x("to_datetime", "'01/02/2000'")>
<cfset x("to_datetime", "#createODBCdate(now())#")>
<cfset x("to_datetime", "#createODBCdatetime(now())#")>

<cfset x("to_datechar", "Fecha")>
<cfset x("to_datechar", "'01-02-2000 03:04:05'")>
<cfset x("to_datechar", "'01/02/2000 03:04:05'")>
<cfset x("to_datechar", "'01/02/2000'")>
<cfset x("to_datechar", "#createODBCdate(now())#")>
<cfset x("to_datechar", "#createODBCdatetime(now())#")>

<cfset x("to_sdate", "Fecha")>
<cfset x("to_sdate", "'01-02-2000 03:04:05'")>
<cfset x("to_sdate", "'01/02/2000 03:04:05'")>
<cfset x("to_sdate", "'01/02/2000'")>
<cfset x("to_sdate", "#createODBCdate(now())#")>
<cfset x("to_sdate", "#createODBCdatetime(now())#")>

<cfset x("to_sdateDMY", "Fecha")>
<cfset x("to_sdateDMY", "'01-02-2000 03:04:05'")>
<cfset x("to_sdateDMY", "'01/02/2000 03:04:05'")>
<cfset x("to_sdateDMY", "'01/02/2000'")>
<cfset x("to_sdateDMY", "#createODBCdate(now())#")>
<cfset x("to_sdateDMY", "#createODBCdatetime(now())#")>

<cfset x("to_chartime", "Fecha")>
<cfset x("to_chartime", "'01-02-2000 03:04:05'")>
<cfset x("to_chartime", "'01/02/2000 03:04:05'")>
<cfset x("to_chartime", "'01/02/2000'")>
<cfset x("to_chartime", "#createODBCdate(now())#")>
<cfset x("to_chartime", "#createODBCdatetime(now())#")>

<cfset x("dateadd", "Numero, Fecha")>
<cfset x("dateadd", "1, '01/02/2000 03:04:05'")>
<cfset x("dateadd", "1, '01/02/2000'")>
<cfset x("dateadd", "1, Fecha")>
<cfset x("dateadd", "Numero, '01/02/2000 03:04:05'")>
<cfset x("dateadd", "Numero, '01/02/2000'")>

<cfset x("dateaddstring", "1, 01/02/2000 13:04:05")>
<cfset x("dateaddstring", "1, 01/02/2000")>

<cfset x("dateadd", "1,'01-02-2000 03:04:05',SS")>

<cfset x("dateaddx", "SS,1,'01-02-2000 03:04:05'")>
<cfset x("dateaddx", "SS,1,'01/02/2000 03:04:05'")>
<cfset x("dateaddx", "SS, Numero, Fecha")>
<cfset x("dateaddx", "SS, 0, Fecha")>
<cfset x("dateaddx", "YYYY, 1, Fecha")>
<cfset x("dateaddx", "YY, 1, Fecha")>
<cfset x("dateaddx", "MM, 1, Fecha")>
<cfset x("dateaddx", "WK, 1, Fecha")>
<cfset x("dateaddx", "DD, 1, Fecha")>
<cfset x("dateaddx", "HH, 1, Fecha")>
<cfset x("dateaddx", "MI, 1, Fecha")>
<cfset x("dateaddx", "SS, 1, Fecha")>
<cfset x("dateaddx", "MS, 1, Fecha")>

<cfset x("dateaddm", "Numero, Fecha")>
<cfset x("dateaddm", "0, Fecha")>
<cfset x("dateaddm", "1, Fecha")>

<cfset x("timeadd", "Numero, Fecha")>
<cfset x("timeadd", "Numero, '01/02/2000 03:04:05'")>
<cfset x("timeadd", "Numero, '01/02/2000'")>
<cfset x("timeadd", "2, Fecha")>
<cfset x("timeadd", "2, '01/02/2000 03:04:05'")>

<cfset LvarFF   = CreateDate(2005,6,7)>

<cfset x("datediff", "Fecha, #LvarFF#")>
<cfset x("datediff", "Fecha, Fecha")>
<cfset x("datediff", "Fecha, NOW")>
<cfset x("datediff", "'01/02/2000 13:04:10', '02/02/2000 03:04:05'")>
<cfset x("datediff", "'01/02/2000 03:04:05', '02/02/2000 13:04:10'")>
<cfset x("datediff", "'01/02/2000', '01/03/2000'")>
<cfset x("datediff", "'01/02/2000 13:04:10', Fecha")>
<cfset x("datediff", "Fecha, '02/02/2000 03:04:05'")>
<cfset x("datediff", "'01/02/2000', '02/02/2000 03:04:05'")>
<cfset x("datediff", "Fecha, #createODBCdate(now())#")>
<cfset x("datediff", "Fecha, #createODBCdatetime(now())#")>

<cfset x("timediff", "Fecha, Fecha")>
<cfset x("timediff", "'01/02/2000 13:04:10', '01/02/2000 03:04:11'")>
<cfset x("timediff", "'01/02/2000 13:04:10', Fecha")>
<cfset x("timediff", "'01/02/2000', Fecha")>
<cfset x("timediff", "Fecha, '01/02/2000 03:04:11'")>

<cfset x("datediffstring", "01/02/2000 03:04:10, 02/02/2000 03:04:05")>
<cfset x("datediffstring", "02/02/2000 03:04:10, 01/02/2000 03:04:05")>

<cfset x("datediff", "'01/02/2001 13:04:10', '02/02/2000 03:04:05',yyyy")>
<cfset x("datediff", "'01/02/2001 13:04:10', '02/02/2000 03:04:05',yy")>
<cfset x("datediff", "'01/02/2001 13:04:10', '02/02/2000 03:04:05',mm")>
<cfset x("datediff", "'01/02/2001 13:04:10', '02/02/2000 03:04:05',wk")>
<cfset x("datediff", "'01/02/2001 13:04:10', '02/02/2000 03:04:05',dd")>
<cfset x("datediff", "'01/02/2001 13:04:10', '02/02/2000 03:04:05',hh")>
<cfset x("datediff", "'01/02/2001 13:04:10', '02/02/2000 03:04:05',mi")>
<cfset x("datediff", "'01/02/2001 13:04:10', '02/02/2000 03:04:05',ss")>

<cfset x("datediffTot", "'01/02/2001 13:04:10', '01/02/2004 13:04:10',yyyy")>
<cfset x("datediffTot", "'01/02/2001 13:04:10', '01/02/2004 13:04:10',yy")>
<cfset x("datediffTot", "'01/02/2001 13:04:10', '01/02/2004 13:04:10',mm")>
<cfset x("datediffTot", "'01/02/2001 13:04:10', '01/02/2004 13:04:10',wk")>
<cfset x("datediffTot", "'01/02/2001 13:04:10', '01/02/2004 13:04:10',dd")>
<cfset x("datediffTot", "'01/02/2001 13:04:10', '01/02/2004 13:04:10',hh")>
<cfset x("datediffTot", "'01/02/2001 13:04:10', '01/02/2004 13:04:10',mi")>
<cfset x("datediffTot", "'01/02/2001 13:04:10', '01/02/2004 13:04:10',ss")>

<cfset x("date_format", "'01/01/2000 13:04:10',WK")>
<cfset x("date_format", "'01/01/2000',WK")>
<cfset x("date_format", "'02/01/2000',WK")>
<cfset x("date_format", "'03/01/2000',WK")>
<cfset x("date_format", "'04/01/2000',WK")>
<cfset x("date_format", "'05/01/2000',WK")>
<cfset x("date_format", "'06/01/2000',WK")>
<cfset x("date_format", "'07/01/2000',WK")>
<cfset x("date_format", "'08/01/2000',WK")>
<cfset x("date_format", "'01/02/2000 13:04:10',WK")>
<cfset x("date_format", "'01/02/2000',WK")>
<cfset x("date_format", "'02/02/2000',WK")>
<cfset x("date_format", "'03/02/2000',WK")>
<cfset x("date_format", "'04/02/2000',WK")>
<cfset x("date_format", "'05/02/2000',WK")>
<cfset x("date_format", "'06/02/2000',WK")>
<cfset x("date_format", "'07/02/2000',WK")>
<cfset x("date_format", "'08/02/2000',WK")>

<cfset x("date_format", "Fecha,YYYY/MM-DD HH:MI:SS DW Q YY DY")>
<cfset x("date_format", "Fecha,YYYY/MM-DD HH:MI:SS WK DW QQ Q YY DY")>
<cfset x("date_format", "Fecha,DD/MM/YYYY")>
<cfset x("date_format", "Fecha,DD-MM-YYYY")>
<cfset x("date_format", "Fecha,YYYYMMDD")>
<cfset x("date_format", "Fecha,HH:MM:SS")>

<cfset x("date_part", "YYYY, Fecha")>
<cfset x("date_part", "YY, Fecha")>
<cfset x("date_part", "MM, Fecha")>
<cfset x("date_part", "DY, Fecha")>
<cfset x("date_part", "DD, Fecha")>
<cfset x("date_part", "HH, Fecha")>
<cfset x("date_part", "MI, Fecha")>
<cfset x("date_part", "SS, Fecha")>
<cfset x("date_part", "WK, Fecha")>
<cfset x("date_part", "DW, Fecha")>
<cfset x("date_part", "QQ, Fecha")>
<cfset x("date_part", "Q, Fecha")>
<cfset x("date_part", "WK,'01/01/2000'")>
<cfset x("date_part", "WK,'01/01/2000 13:02:03'")>
<cfset x("date_part", "WK,'01/02/2000'")>
<cfset x("date_part", "WK,'01/02/2000 13:02:03'")>

<cfset x("today", "")>
<cfset x("now", "")>

<cfset x("mod", "2001,4")>
<cfset x("mod", "2002,4")>
<cfset x("mod", "2003,4")>
<cfset x("mod", "2004,4")>

<cfset x("findoneof","Hilera,1234")>
<cfset x("findoneof","Hilera,12a34")>
<cfset x("findoneof","NumeroSTR,1234")>

</table>
<cfoutput>#xx#</cfoutput>

<cffunction name="x" output="yes">
	<cfargument name="name" type="string">
	<cfargument name="args" type="string" default="">
	<cfargument name="dec" type="string" default="">
	<cfargument name="del" type="string" default=",">

	<cfoutput>    
	<cfif LvarFunction1 NEQ Arguments.name>
		<cfset LvarFunction1 = Arguments.name>
	    <tr>
			<td><strong>Función: #LvarFunction1#</strong>
        		<cfif Arguments.Name EQ "findoneof"> (solo como condición en where, on o when)</cfif>
        	</td>
			<td colspan="#arraylen(LvarDSNs)*2#" align="center"><strong>#LvarFunction1#</strong>
        	</td>
		</tr>
    </cfif>
    <tr><td nowrap>
    &LTcf_dbfunction name="#Arguments.Name#"<BR>args="#Arguments.Args#"<cfif Arguments.Del NEQ ","> delimiters="#Arguments.del#"</cfif><cfif Arguments.Dec NEQ ""> dec="#Arguments.dec#"</cfif>&GT
			<BR>
			<cfif lcase(Arguments.Name) EQ "datediffTot">
				<cfif left(listGetAt(Arguments.Args,1),1) EQ "'">
					<cfset LvarFechaIni=lsParseDateTime(mid(listGetAt(Arguments.Args,1),2,len(listGetAt(Arguments.Args,1))-2))>
				</cfif>
				<cfif left(listGetAt(Arguments.Args,2),1) EQ "'">
					<cfset LvarFechaFin=lsParseDateTime(mid(listGetAt(Arguments.Args,2),2,len(listGetAt(Arguments.Args,2))-2))>
				</cfif>
				<cfset LvarPartD = lcase(listGetAt(Arguments.Args,3))>
				<cfif LvarPartD EQ "yy">
					<cfset LvarPartD = "yyyy">
				<cfelseif LvarPartD EQ "qq">
					<cfset LvarPartD = "q">
				<cfelseif LvarPartD EQ "mm">
					<cfset LvarPartD = "m">
				<cfelseif LvarPartD EQ "wk">
					<cfset LvarPartD = "ww">
				<cfelseif LvarPartD EQ "dd">
					<cfset LvarPartD = "d">
				<cfelseif LvarPartD EQ "hh">
					<cfset LvarPartD = "h">
				<cfelseif LvarPartD EQ "mi">
					<cfset LvarPartD = "n">
				<cfelseif LvarPartD EQ "ss">
					<cfset LvarPartD = "s">
				</cfif>				
				#datediff(LvarPartD,LvarFechaIni,LvarFechaFin)#
			</cfif>

	<cfset LvarNow1 = "NOW">
	<cfloop from="1" to="#arraylen(LvarDSNs)#" index="i">
		<cfset xx ++>
		<cfif find(LvarNow1,Arguments.args)>
			<cftry>
				<cf_dbfunction name="now" args="" datasource="#LvarDSNs[i][2]#" returnvariable="LvarNow">
				<cfset Arguments.args = replace(Arguments.args,LvarNow1,LvarNow,"ALL")>
				<cfset LvarNow1 = LvarNow>
			<cfcatch type="any">
				<font color="##FF0000">ERROR: #cfcatch.Message#  #cfcatch.Detail#</font>
			</cfcatch>
			</cftry>
		</cfif>
		</td><td>=</td><td>
		<cftry>
			<cf_dbfunction name="#Arguments.Name#" args="#Arguments.Args#" dec="#Arguments.Dec#" datasource="#LvarDSNs[i][2]#" returnvariable="LvarDBfunction" delimiters="#Arguments.del#">
			#HTMLEditFormat(LvarDBfunction)#
		<cfcatch type="any">
			<font color="##FF0000">ERROR: #cfcatch.Message#  #cfcatch.Detail#</font>
		</cfcatch>
		</cftry>
		<cftry>
			<cfset LvarDBfunction = replace(LvarDBfunction,"FLOORX","")>
			<BR>=<BR>
			<cfquery name="rsSQL" datasource="#LvarDSNs[i][2]#">
				<cfif Arguments.Name EQ "findoneof">
				select case when <cf_dbfunction name="#Arguments.Name#" args="#Arguments.Args#" datasource="#LvarDSNs[i][2]#" delimiters="#Arguments.del#"> then 'OK'
							else 'NO TA' end as X
				<cfelseif Arguments.Name EQ "OP_concat">
				select 'HO' <cf_dbfunction name="#Arguments.Name#" datasource="#LvarDSNs[i][2]#"> 'LA' as X
				<cfelse>
				select #preserveSingleQuotes(LvarDBfunction)# as X
				</cfif>
				  from #LvarDSNs[i][3]#
			</cfquery>
			<cfif i EQ 1>
				<cfset LvarValor = rsSQL.X>
				<cfset LvarValorSTR = rsSQL.X & "*">
				#rsSQL.X#
			<cfelseif LvarValor EQ rsSQL.X>
				#rsSQL.X#
				<cfif LvarValorSTR NEQ rsSQL.X & "*">
					<font color="##FF0000"><strong>(***)</strong></font>
				</cfif>
			<cfelse>
				<font color="##FF0000"><strong>#rsSQL.X#</strong></font>
			</cfif>
		<cfcatch type="any">
			<font color="##FF0000">ERROR: #cfcatch.Message#  #cfcatch.Detail#</font>
		</cfcatch>
		</cftry>
	</td></cfloop>
    </tr>
	</cfoutput>    
</cffunction>