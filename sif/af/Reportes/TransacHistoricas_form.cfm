<!--- 
	Creado por Gustavo Fonseca H.
		Motivo: Nueva consulta para exportación a Excel del módulo de Activos Fijos.
		Fecha:16-5-2006.
 --->


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


<!--- descripcion de cfs--->
<cfset centroini = false >
<cfif isdefined("url.CFcodigoinicio") and len(trim(url.CFcodigoinicio))>
	<cfquery name="rsCentro1" datasource="#session.DSN#">
		select CFdescripcion
		from CFuncional
		where CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CFcodigoinicio#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset centroini = true >
</cfif>
<cfset centrofin = false >
<cfif isdefined("url.CFcodigofinal") and len(trim(url.CFcodigofinal))>
	<cfquery name="rsCentro2" datasource="#session.DSN#">
		select CFdescripcion
		from CFuncional
		where CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CFcodigofinal#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset centrofin = true >
</cfif>

<!--- descripcion de categorias --->
<cfif isdefined("url.codigodesde") and len(trim(url.codigodesde))>
	<cfquery name="rsCat1" datasource="#session.DSN#">
		select ACdescripcion
		from ACategoria
		where ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.codigodesde#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cfif isdefined("url.codigohasta") and len(trim(url.codigohasta))>
	<cfquery name="rsCat2" datasource="#session.DSN#">
		select ACdescripcion
		from ACategoria
		where ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.codigohasta#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<!--- Descripcion de Oficinas --->
<cfset doficina1=false>
<cfif isdefined("url.OficinaIni") and url.OficinaIni neq "">
	<cfset doficina1=true>
	<cfquery name="rsOfi1" datasource="#session.DSN#">
		select Odescripcion
		from Oficinas
		where Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.OficinaIni#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	
</cfif>

<cfset doficina2=false>
<cfif isdefined("url.OficinaFin") and url.OficinaFin neq "">
	<cfset doficina2=true>
	<cfquery name="rsOfi2" datasource="#session.DSN#">
		select Odescripcion
		from Oficinas
		where Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.OficinaFin#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>		
</cfif>


<cfif not isdefined("url.imprimir") >
	<cf_templateheader template="#session.sitio.template#">
</cfif>

<!--- Encabezado del reporte --->
<style type="text/css">
	.titulox {
		padding: 2px; 
		font-size:12px;
	}
</style> 

<!--- <cfdump var="#url#"> --->
<cfoutput>
	<cfset mes = 'Enero,Febrero,marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre'>
	<table width="100%" border="0" cellpadding="2" cellspacing="0">
		
		<cfset params = "&formatos=1
						&acinicio=#url.acinicio#
						&CFCODIGOINICIO=#url.CFCODIGOINICIO#
						&ACdescripciondesde=#url.ACdescripciondesde#
						&ACdescripcionhasta=#url.ACdescripcionhasta#
						&CFdescripcioninicio=#url.CFdescripcioninicio#
						&CFdescripcionfinal=#url.CFdescripcionfinal#
						&CFCODIGOfinal=#url.CFCODIGOfinal#
						&codigodesde=#url.codigodesde#
						&codigohasta=#url.codigohasta#
						&achasta=#url.achasta#
						&cfidinicio=#url.cfidinicio#
						&cfidfinal=#url.cfidfinal#
						&mesinicial=#url.mesinicial#
						&mesfinal=#url.mesfinal#
						&periodoinicial=#url.periodoinicial#
						&tiporep=#url.tiporep#
						&transachis=#url.transachis#
						&OficinaIni=#url.OficinaIni#
						&OficinaFin=#url.OficinaFin#">
		<tr>
			<td>&nbsp;</td>
			<td colspan="22" align="right">
				<cf_rhimprime datos="/sif/af/Reportes/TransacHistoricas_form.cfm" paramsuri="#params#">
				<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="22" align="right" class="noprint">
				<cfoutput>
					<a href="TransacHistoricas_filtro.cfm?1=1#params#">Regresar</a>
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td >&nbsp;</td>
			<td >&nbsp;</td>
			<td align="center" colspan="2"><span class="titulox"><strong><font size="2">#session.Enombre#</font></strong></span></td>
			<td >&nbsp;</td>
			<td >&nbsp;</td>
		</tr>
		<tr>
			<td >&nbsp;</td>
			<td >&nbsp;</td>
			<td align="center" colspan="2"><strong>Consulta de Transacciones Hitóricas</strong></td>
			<td >&nbsp;</td>
			<td >&nbsp;</td>		
		</tr>
		<tr>
			<td >&nbsp;</td>
			<td >&nbsp;</td>
			<td align="center" colspan="2">
				<strong>
				<cfswitch expression="#url.TransacHis#">
					<cfcase value="1">
						Adquisiciones <cfif isdefined("url.TipoRep") and url.TipoRep eq 1>(Resumido)<cfelseif isdefined("url.TipoRep") and url.TipoRep eq 2>(Detallado)</cfif>
					</cfcase>
					<cfcase value="2">
						Retiros <cfif isdefined("url.TipoRep") and url.TipoRep eq 1>(Resumido)<cfelseif isdefined("url.TipoRep") and url.TipoRep eq 2>(Detallado)</cfif>
					</cfcase>
					<cfcase value="3">
						Depreciación <cfif isdefined("url.TipoRep") and url.TipoRep eq 1>(Resumido)<cfelseif isdefined("url.TipoRep") and url.TipoRep eq 2>(Detallado)</cfif>
					</cfcase>
					<cfcase value="4">
						Depreciados Totalmente <cfif isdefined("url.TipoRep") and url.TipoRep eq 1>(Resumido)<cfelseif isdefined("url.TipoRep") and url.TipoRep eq 2>(Detallado)</cfif>
					</cfcase>
					<cfcase value="5">
						Mejoras <cfif isdefined("url.TipoRep") and url.TipoRep eq 1>(Resumido)<cfelseif isdefined("url.TipoRep") and url.TipoRep eq 2>(Detallado)</cfif>
					</cfcase>					
				</cfswitch>
				</strong>
			</td>
			<td >&nbsp;</td>
			<td >&nbsp;</td>		
		</tr>
		<tr><td align="center" colspan="7"><strong>Per&iacute;odo/Mes Inicial:</strong> #url.periodoInicial#/#ListGetAt(mes, url.mesInicial)# &nbsp;&nbsp;&nbsp;<strong>Mes Final:&nbsp;</strong>#ListGetAt(mes, url.mesFinal)# </td></tr>	
		<!---	
		<tr><td align="center" colspan="7"><strong>Centro Funcional:&nbsp;</strong>#rsCentro1.CFdescripcion# <cfif url.CFcodigoinicio neq url.CFcodigofinal> <strong>hasta</strong> #rsCentro2.CFdescripcion#</cfif></td></tr>
		--->
		<tr><td align="center" colspan="7"><strong>Centro Funcional:&nbsp;</strong> <cfif not centroini and not centrofin  ><strong>:&nbsp;</strong>Todos<cfelseif centroini and not centrofin > <strong>desde:</strong> #rsCentro1.CFdescripcion#<cfelseif not centroini and centrofin ><strong>hasta:</strong> #rsCentro2.CFdescripcion#<cfelse><strong>:</strong>  #rsCentro1.CFdescripcion# <strong>hasta</strong> #rsCentro2.CFdescripcion#</cfif></td></tr>		
		<tr><td align="center" colspan="7"><strong>Categor&iacute;a</strong> <cfif not categoriaini and not categoriafin  ><strong>:&nbsp;</strong>Todas<cfelseif categoriaini and not categoriafin > <strong>desde:</strong> #rsCat1.ACdescripcion#<cfelseif not categoriaini and categoriafin ><strong>hasta:</strong> #rsCat2.ACdescripcion#<cfelse><strong>:</strong>  #rsCat1.ACdescripcion# <strong>hasta</strong> #rsCat2.ACdescripcion#</cfif></td></tr>
		<tr><td align="center" colspan="7"><strong>Oficina</strong> <cfif not doficina1 and not doficina2  ><strong>:&nbsp;</strong>Todas<cfelseif doficina1 and not doficina2 > <strong>desde:</strong> #rsOfi1.Odescripcion#<cfelseif not doficina1 and doficina2 ><strong>hasta:</strong> #rsOfi2.Odescripcion#<cfelse><strong>:</strong>  #rsOfi1.Odescripcion# <strong>hasta</strong> #rsOfi2.Odescripcion#</cfif></td></tr>
	</table>
</cfoutput>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<!--- Transacciones Históricas --->
			<cfif isdefined("url.TipoRep") and url.TipoRep eq 1>
				<!--- Resumidos --->
				<cfswitch expression="#url.TransacHis#">
					<cfcase value="1">
						<cfinclude template="TransacHistoricasADQ_RESUMIDO_sql.cfm">		
					</cfcase>
					<cfcase value="2">
						<cfinclude template="TransacHistoricasRET_RESUMIDO_sql.cfm">
					</cfcase>
					<cfcase value="3">
						<cfinclude template="TransacHistoricasDEP_RESUMIDO_sql.cfm">
					</cfcase>
					<cfcase value="4">
						<cfinclude template="TransacHistoricasDEPT_RESUMIDO_sql.cfm">
					</cfcase>
					<cfcase value="5">
						<cfinclude template="TransacHistoricasMEJ_RESUMIDO_sql.cfm">
					</cfcase>					
				</cfswitch>

			<cfelseif isdefined("url.TipoRep") and url.TipoRep eq 2>
				<!--- Detallados --->
				<cfswitch expression="#url.TransacHis#">
					<cfcase value="1">
						<cfinclude template="TransacHistoricasADQ_sql.cfm">		
					</cfcase>
					<cfcase value="2">
						<cfinclude template="TransacHistoricasRET_sql.cfm">
					</cfcase>
					<cfcase value="3">
						<cfinclude template="TransacHistoricasDEP_sql.cfm">
					</cfcase>
					<cfcase value="4">
						<cfinclude template="TransacHistoricasDEPT_sql.cfm">
					</cfcase>
					<cfcase value="5">
						<cfinclude template="TransacHistoricasMEJ_sql.cfm">		
					</cfcase>					
				</cfswitch>
			</cfif>
		</td>
	</tr>
</table>