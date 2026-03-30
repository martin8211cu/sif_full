<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>

<!--- Valida que tengan registros duplicados  --->
<cfquery name="rsCheck1" datasource="#session.DSN#">
	select distinct upper(ltrim(rtrim(CEDULA))) as CEDULA
	from #table_name# 
</cfquery>
<cfquery name="rsCheck1D" datasource="#session.DSN#">
	select  upper(ltrim(rtrim(CEDULA))) as CEDULA
	from #table_name# 
</cfquery>

<cfif rsCheck1D.RecordCount NEQ rsCheck1.RecordCount>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		values('Existen cédulas repetidas en el archivo de importación',1)
	</cfquery>
</cfif>

<!--- Valida el codigo electoral sean validos  --->
<cfquery name="INS_Error" datasource="#session.DSN#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select distinct 'El código electoral :' + convert(varchar,x.CODELEC) + ' no existe' ,2
	from #table_name# x
	where  x.CODELEC not in (
		select a.TLCDcodigo
		from TLCDistritoE  a)
</cfquery>

<cfquery name="err" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by Mensaje,ErrorNum
</cfquery>
<cfif (err.recordcount) EQ 0>
	<cfquery name="rsdelete" datasource="#session.DSN#">
         delete TLCPadronE where exists (select 1 from  #table_name# 
         where TLCPadronE.TLCPcedula = #table_name#.CEDULA)
    </cfquery>
    
    <cfquery name="rsinsert" datasource="#session.DSN#">
		insert into TLCPadronE (
			TLCPcedula,
			TLCDcodigo,
			TLCPsexo,
			TLCPfechaCaduc,
			TLCPjunta,
			TLCPnombre,
			TLCPapellido1,
			TLCPapellido2)
		select 	
			CEDULA,
			CODELEC,
			SEXO,
			FECHACADUC,
			JUNTA,
			NOMBRE,
			APELLIDO1,
			APELLIDO2
		from  #table_name#
	</cfquery>
</cfif>

