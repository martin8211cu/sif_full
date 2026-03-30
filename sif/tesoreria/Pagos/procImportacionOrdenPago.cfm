<cfset codigos = session.Usucodigo & Session.Ecodigo>
<cfset fechaS = dateFormat(now(),"yyyy-mm-dd")>
<cfset fechaR = replace(fechaS,"-","",'all')>
<cfset codigos &= fechaR & replace(LSTimeFormat(now(),'HH:mm:ss'),":","","all")>
<!--- INSERTAR EN MI TABLA --->

<cfset session.idTransaccion = codigos>
<cfset session.IdBitacora = 0>
<cfset session.HashB = "">
<cfif IsDefined('insert_bitacora')>
	<cfset session.IdBitacora = insert_bitacora.identity>
	<cfquery name="rsErrores" datasource="sifcontrol">
		select * from IErrores  e where e.IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.IdBitacora#">
	</cfquery>

	<cfquery name="eii" datasource="sifcontrol">
		select ib.IBid, ib.IBhash from IBitacora ib
		where ib.IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.IdBitacora#">
	</cfquery>
	<cfset session.HashB = eii.IBhash>

	<cfif rsErrores.RecordCount eq 0>
		<cfquery name="insert" datasource="#session.dsn#">
			insert into TESDatosOPImportador (NoOrdPago,FecGenManual,FecPago,Referencia,IdTransaccion)
			select distinct NoOrdPago,FecGenManual,FecPago,Referencia,#session.idTransaccion#
			from #table_name#
		</cfquery>
	</cfif>
</cfif>