<cfif not isdefined("url.imprimir") >
	<cf_templateheader title="Movimientos por Centro Funcional" template="#session.sitio.template#">
</cfif>

<cfset params = "&IDtrans=#url.IDtrans#&periodoInicial=#url.periodoInicial#&periodoFinal=#url.periodoFinal#&mesInicial=#url.mesInicial#&mesFinal=#url.mesFinal#" >
<cfset params = params & "&ACdescripcionDesde=#url.ACdescripcionDesde#&ACdescripcionHasta=#url.ACdescripcionHasta#&codigodesde=#url.codigodesde#&codigohasta=#url.codigohasta#&AChasta=#url.AChasta#&ACinicio=#url.ACinicio#">
<cfset params = params & "&CFidInicio=#url.CFidInicio#&CFidFinal=#url.CFidFinal#&CFcodigoinicio=#url.CFcodigoinicio#&CFcodigofinal=#url.CFcodigofinal#&CFdescripcionInicio=#url.CFdescripcionInicio#&CFdescripcionFinal=#url.CFdescripcionFinal#">
<cfif url.IDtrans eq 5 and isdefined("url.AFRmotivo") >
	<cfset params = params & "&AFRmotivo=#url.AFRmotivo#" >
</cfif>


<cf_rhimprime datos="/sif/af/Reportes/Movimientos.cfm" paramsuri="#params#" regresar="/cfmx/sif/af/Reportes/Movimientos-filtro.cfm?1=1#params#">

<cfset categoriaini = true >
<cfif len(trim(url.codigodesde)) eq 0 >
	<cfquery name="categoria" datasource="#session.DSN#">
		select min(ACcodigo) as inicio
		from ACategoria 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset url.codigodesde = categoria.inicio >
	<cfset categoriaini = false >
</cfif>

<cfset categoriafin = true >
<cfif len(trim(url.codigohasta)) eq 0 >
	<cfquery name="categoria" datasource="#session.DSN#">
		select max(ACcodigo) as hasta
		from ACategoria 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset url.codigohasta = categoria.hasta >
	<cfset categoriafin = false >
</cfif>

<cfif url.codigodesde gt url.codigohasta>
	<cfset tmp = url.codigodesde >
	<cfset url.codigodesde = url.codigohasta >
	<cfset url.codigohasta = tmp >
</cfif>

<cfif url.CFcodigoinicio gt url.CFcodigofinal>
	<cfset tmp = url.CFcodigoinicio >
	<cfset url.CFcodigoinicio = url.CFcodigofinal >
	<cfset url.CFcodigofinal = tmp >
</cfif>

<!--- Encabezado del reporte --->
<style type="text/css">
	.titulox {
		padding: 2px; 
		font-size:12px;
	}
</style> 
<cfoutput>

<cfset mes = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre'>
<table width="100%" cellpadding="2" cellspacing="0">
	<cfif isdefined("url.imprimir")>
	<tr>
		<td align="right">
			<table width="10%" align="right" border="0" height="25px">
				<tr><td>Usuario:</td><td>#session.Usulogin#</td></tr>
				<tr><td>Fecha:</td><td>#LSDateFormat(now(), 'dd/mm/yyyy')#</td></tr>
			</table>
		</td>
	</tr>
	</cfif>
	
	<!--- descripcion de cfs--->
	<cfquery name="rsCentro1" datasource="#session.DSN#">
		select CFdescripcion
		from CFuncional
		where CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CFcodigoinicio#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="rsCentro2" datasource="#session.DSN#">
		select CFdescripcion
		from CFuncional
		where CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CFcodigofinal#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<!--- descripcion de categorias --->
	<cfquery name="rsCat1" datasource="#session.DSN#">
		select ACdescripcion
		from ACategoria
		where ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.codigodesde#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="rsCat2" datasource="#session.DSN#">
		select ACdescripcion
		from ACategoria
		where ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.codigohasta#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<tr><td align="center" ><span class="titulox"><strong><font size="2">#session.Enombre#</font></strong></span></td></tr>
	<tr><td align="center"><strong>Consulta de Movimientos de Activos</strong></td></tr>
	<tr><td align="center"><strong>Per&iacute;odo/Mes Inicial:</strong> #url.periodoInicial#/#ListGetAt(mes, url.mesInicial)# &nbsp;&nbsp;&nbsp;<strong>Per&iacute;odo/Mes Final:</strong> #url.periodoFinal#/#ListGetAt(mes, url.mesFinal)# </td></tr>	
	<tr><td align="center"><strong>Centro Funcional:</strong> #rsCentro1.CFdescripcion# <cfif url.CFcodigoinicio neq url.CFcodigofinal>hasta #rsCentro2.CFdescripcion#</cfif></td></tr>
	<tr><td align="center"><strong>Categor&iacute;a</strong> <cfif not categoriaini and not categoriafin  ><strong>:&nbsp;</strong>Todas<cfelseif categoriaini and not categoriafin > <strong>desde:</strong> #rsCat1.ACdescripcion#<cfelseif not categoriaini and categoriafin ><strong>hasta:</strong> #rsCat2.ACdescripcion#<cfelse><strong>:</strong>  #rsCat1.ACdescripcion# hasta #rsCat2.ACdescripcion#</cfif></td></tr>
	<tr><td align="center"><strong>Tipo:</strong>&nbsp;
	<cfif url.IDtrans eq 1 >Adquisiciones
	<cfelseif url.IDtrans eq 5 >Retiros&nbsp;&nbsp;&nbsp;
		<cfif isdefined("url.AFRmotivo") and len(trim(url.AFRmotivo)) >
			<cfquery name="rsMotivo" datasource="#session.DSN#">
				select AFRdescripcion
				from AFRetiroCuentas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and AFRmotivo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.AFRmotivo#">
			</cfquery>
		</cfif>	
		<strong>Motivo:&nbsp;</strong><cfif isdefined("rsMotivo.AFRdescripcion")>#rsMotivo.AFRdescripcion#<cfelse>Todos</cfif>
	<cfelse>Transferencia de Centro Funcional por Translado de Responsable</cfif></td></tr>	
</table>
</cfoutput>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<!--- Adquisicion --->
			<cfif url.IDtrans eq 1 >
				<cfinclude template="movAdquisicion.cfm">

			<!--- Retiro --->
			<cfelseif url.IDtrans eq 5 >
				<cfinclude template="movRetiro.cfm">

			<!--- Transferencia --->
			<cfelse>
				<cfinclude template="movTransferencia.cfm">

			</cfif>
		</td>
	</tr>
</table>

<cfif not isdefined("url.imprimir") >
	<cf_templatefooter template="#session.sitio.template#">
</cfif>