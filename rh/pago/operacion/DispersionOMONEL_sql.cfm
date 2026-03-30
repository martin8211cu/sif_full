<!--- OPARRALES 2018-08-29
	- Layut de dispersion OMONEL
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
<cfset varNumCliente = rsCodCliente.Pvalor>

<cfquery name="rsDatos" datasource="#session.dsn#">
	select
		de.DEidentificacion,
		de.DEdato2,
		hic.ICmontores
	from IncidenciasCalculo hic
	Inner Join CIncidentes ci
		on hic.CIid = ci.CIid
		and RTrim(LTrim(ci.CIcodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="2DE">
	Inner Join DatosEmpleado de
		on hic.DEid = de.DEid
		and LTrim(RTrim(de.DEdato1)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="1">
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
</cfquery>

<cfif rsDatos.RecordCount gt 0>

	<cfquery name="rsErrores" dbtype="query">
		select * from rsDatos
		where DEdato2 = ''
	</cfquery>

	<cfset mensajeError = "">
	<cfloop query="rsErrores">
		<cfset errorEmpleado = "El empleado #DEidentificacion# no tiene configurado un numero de tarjeta">
		<cfif mensajeError neq "">
			<cfset mensajeError &= "<br />">
		</cfif>
		<cfset mensajeError &= errorEmpleado>
	</cfloop>

	<cfif mensajeError neq "">
		<cfthrow detail="#mensajeError#" message="Datos Empleado">
	</cfif>

	<cfset NL = Chr(13)&Chr(10)>
	<cfset TextoFile = "">
	<cfloop query="rsDatos">
		<cfset linea = "">
		<cfset linea &= RepeatString(" ",16-Len(Mid(Trim(DEdato2),1,16))) & Mid(Trim(DEdato2),1,16)>
		<cfset montoEmpl = LSNumberFormat(ICmontores,'9.00')>
		<cfset montoSinDot = Replace(montoEmpl,".","","all")>
		<cfset linea &= RepeatString("0",10-Len(montoSindot)) & montoSindot>

		<cfif TextoFile neq ''>
			<cfset TextoFile &= NL>
		</cfif>
		<cfset TextoFile &= linea>
	</cfloop>

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
<cfelse>
	<form name="form1" action="DispersionOMONEL_form.cfm" method="post" id="form1"></form>
	<script type="text/javascript" language="javascript">
		alert('No hay datos para exportar');
		document.form1.submit();
	</script>
</cfif>
