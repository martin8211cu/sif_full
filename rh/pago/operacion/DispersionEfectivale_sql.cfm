<!--- OPARRALES 2018-08-29
	- Layut de dispersion EFECTIVALE
 --->
<cfquery name="rsCodCliente" datasource="#session.dsn#">
	select
		Pvalor
	from RHParametros
	where Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="14600703">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfif rsCodCliente.RecordCount eq 0 or (rsCodCliente.RecordCount gt 0 and Trim(rsCodCliente.Pvalor) eq '')>
	<cfthrow detail="El C&oacute;digo de Cliente para Despensas no se ha configurado." message="Par&aacute;metros RH: ">
</cfif>

<!--- OPARRALES 2018-01-11 CAMBIO PARA FULL --->
<!--- <cfset varNumCliente = rsCodCliente.Pvalor> --->
<cfset varNumCliente = '88951-1'>

<cfquery name="rsDatos" datasource="#session.dsn#">
	select
		de.DEdato2 DEidentificacion,
		hic.ICmontores
	from IncidenciasCalculo hic
	Inner Join CIncidentes ci
		on hic.CIid = ci.CIid
		and RTrim(LTrim(ci.CIcodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="2DE">
	Inner Join DatosEmpleado de
		on hic.DEid = de.DEid
		and LTrim(RTrim(de.DEdato1)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="0">
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
	AND LTRIM(RTRIM(de.DEdato1)) = '0'
</cfquery>

<cf_dbtemp name="salida" returnvariable="salida" >
	<cf_dbtempcol name="Columna1"	type="varchar(250)"		mandatory="no">
	<cf_dbtempcol name="Columna2"   type="varchar(250)"    	mandatory="no">
	<cf_dbtempcol name="Columna3"	type="varchar(250)"     mandatory="no">
	<cf_dbtempcol name="Columna4"   type="varchar(250)"    	mandatory="no">
	<cf_dbtempcol name="Columna5"	type="varchar(250)"     mandatory="no">
	<cf_dbtempcol name="Columna6"   type="varchar(250)"    	mandatory="no">
</cf_dbtemp>

<cfif rsDatos.RecordCount gt 0>

	<cfquery name="rsSum" dbtype="query">
		select sum(ICmontores) sumICmontores from rsDatos
	</cfquery>

	<!--- Insert Encabezados documentos. --->
	<cfquery datasource="#session.dsn#">
		insert into #salida#(Columna1,Columna2,Columna3,Columna4,Columna5,Columna6)
		values('XSUBTOTAL','#LSNumberFormat(rsSum.sumICmontores,"9.00")#','','','','')
	</cfquery>

	<cfquery datasource="#session.dsn#">
		insert into #salida#(Columna1,Columna2,Columna3,Columna4,Columna5,Columna6)
		values('XCLIENTE','XTIPOPEDIDO','XNUMERO','XIMPORTE','XCOLONIA','XPOSTAL')
	</cfquery>

	<cfloop query="rsDatos">
		<cfquery datasource="#session.dsn#">
			insert into #salida#(Columna1,Columna2,Columna3,Columna4,Columna5,Columna6)
			values('#varNumCliente#','DISPERSION','#DEidentificacion#','#LSNumberFormat(ICmontores,"9.00")#','','')
		</cfquery>
	</cfloop>

	<cfquery name="rsDtsDoc" datasource="#session.dsn#">
		select * from #salida#
	</cfquery>

	<cfset lvarNombre = "DispersionEfectivale-#form.CPDESCRIPCION#"&".xls">
	<cf_exportQueryToFile query="#rsDtsDoc#" filename="#lvarNombre#" jdbc="false" pintaEncabezadoQuery="false">
	<!---
	<cfquery name="rsSum" dbtype="query">
		select sum(ICmontores) as sumICmontores from rsDatos
	</cfquery>

	<cfset montoSum = LSNumberFormat(rsSum.sumICmontores,"9.00")>
	<cfset montoSumSinDot = Replace(montoSum,".","","all")>

	<cfset Encabezado = RepeatString("0",7-Len(Mid(varNumCliente,1,7))) & Mid(varNumCliente,1,7) >
	<cfset Encabezado &= "0000">
	<cfset Encabezado &= RepeatString("0",10-Len(montoSumSinDot)) & montoSumSinDot>
	<cfset Encabezado &= NL>

	<cfset TextoFile = Encabezado & TextoFile>

	<cfset fileName = "DispersionOMONEL-"&"#form.CPDESCRIPCION#"&".txt">
	<cfset filePath = "ram:///#fileName#">
	<cffile action="write" file="#filePath#" charset="utf-8" output="#TextoFile#" addnewline="false">
	<cfheader name="Content-Disposition" value="attachment; filename=#fileName#">
	<cfcontent type="text/plain" file="#filePath#" deletefile="yes">
	<cflocation url="DispersionOMONEL_form.cfm">
	 --->
<cfelse>
	<form name="form1" action="DispersionOMONEL_form.cfm" method="post" id="form1"></form>
	<script type="text/javascript" language="javascript">
		alert('No hay datos para exportar');
		document.form1.submit();
	</script>
</cfif>