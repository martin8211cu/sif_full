<cf_htmlReportsHeaders 
	irA="consultasPersona-filtro.cfm"
	FileName="consultasPersona_#session.Usucodigo#.xls"
	method="url"
	title="#LB_Titulo#">

<cf_dbtemp name="tbl_trabajo2" returnvariable="tbl_trabajo" >
	<cf_dbtempcol name="DEid" 				type="varchar(12)" 		mandatory="yes">
</cf_dbtemp>


<cfset lVarBuscar = ','>
<cf_dbfunction name="sFind"		args="referencia ^ '#PreserveSingleQuotes(lVarBuscar)#' " returnvariable="Inicio"  delimiters="^">
<cf_dbfunction name="length"	args="referencia" returnvariable="Fin">
<cf_dbfunction name="sPart"		args="referencia ^ #PreserveSingleQuotes(Inicio)# + 1 ^ #PreserveSingleQuotes(Fin)#" delimiters="^"   returnvariable="lVarSDEid" > 	
<!--- <cf_dbfunction name="to_char_integer"	args="#PreserveSingleQuotes(lVarSDEid)#" returnvariable="lVarDEid" delimiters="^"> --->



<cfquery datasource="#session.DSN#" name="xx">
	insert into #tbl_trabajo#(DEid)
	select 	 <cf_dbfunction name="sPart"		args="referencia ^ #PreserveSingleQuotes(Inicio)# + 1 ^ #PreserveSingleQuotes(Fin)#" delimiters="^">
	from ORGCita
	where origen like '%rh:%' 	
	and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	
	<cfif isdefined("url.desde") and len(trim(url.desde)) and isdefined("url.hasta") and len(trim(url.hasta))>
		and inicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.desde)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.hasta)#">
	<cfelseif isdefined("url.desde") and len(trim(url.desde))>
		and inicio >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.desde)#">
	<cfelseif isdefined("url.hasta") and len(trim(url.hasta))>
		and inicio <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.hasta)#">
	</cfif>
</cfquery>

 
<cfquery datasource="#session.DSN#" name="data">
	select b.DEidentificacion, b.DEapellido1, b.DEapellido2, b.DEnombre, count(1) as cantidad
	from #tbl_trabajo# a, DatosEmpleado b
	where <cf_dbfunction name="to_char" args="b.DEid">  = a.DEid
	 <cfif isdefined("url.DEid") and len(trim(url.DEid)) >
	 	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	 </cfif>

	group by b.DEidentificacion, b.DEapellido1, b.DEapellido2, b.DEnombre
	order by b.DEidentificacion, b.DEapellido1, b.DEapellido2, b.DEnombre
</cfquery>

<table width="95%" align="center" cellpadding="2" cellspacing="0">
	<cfif data.recordcount gt 0>
		<tr bgcolor="#EAEAEA">
			<td style="padding-left:10px;"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Identificacion">Identificaci&oacute;n</cf_translate></strong></td>
			<td nowrap="nowrap"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Nombre">Nombre</cf_translate></strong></td>
			<td align="center"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Cantidad">Cantidad</cf_translate></strong></td>
		</tr>

		<cfoutput query="data" >
			<tr>
				<td valign="top" style="padding-left:10px;">#data.DEidentificacion#</td>
				<td valign="top" nowrap="nowrap">#data.DEapellido1# #data.DEapellido2#, #data.DEnombre#</td>
				<td valign="top"  align="center">#data.cantidad#</td>
			</tr>
		</cfoutput>	
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="5" align="center">-<cf_translate xmlfile="/rh/generales.xml" key="MGS_FinDelReporte">Fin del reporte</cf_translate> -</td></tr>
	<cfelse>
		<tr><td colspan="5" align="center">---<cf_translate xmlfile="/rh/generales.xml" key="MSG_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ---</td></tr>		
	</cfif>
</table>