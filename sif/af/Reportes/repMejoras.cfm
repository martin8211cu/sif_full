<!--- cuando viene descargar aquí mismo se hace la descarga, está abajo --->
<cfif not isdefined('form.btnDescargar')>
	<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
	<cfif isdefined("Url.btnFiltrar") and not isdefined("Form.btnFiltrar")>
		<cfparam name="Form.btnFiltrar" default="#Url.btnFiltrar#">
	</cfif>
	<cfif isdefined("url.AGTPid") and not isdefined("form.AGTPid")>
		<cfset form.AGTPid = url.AGTPid>
	</cfif>					
	<cfif isdefined("url.FAplaca") and not isdefined("form.FAplaca")>
		<cfset form.FAplaca = url.FAplaca>
	</cfif>
	<cfif isdefined("url.FCategoria") and not isdefined("form.FCategoria")>
		<cfset form.FCategoria = url.FCategoria>
	</cfif>
	<cfif isdefined("url.FClase") and not isdefined("form.FClase")>
		<cfset form.FClase = url.FClase>
	</cfif>															
	<cfif isdefined("url.FCentroF") and not isdefined("form.FCentroF")>
		<cfset form.FCentroF = url.FCentroF>
	</cfif>	
	<cfif not isdefined("form.AGTPid") or  (isdefined('url.AGTPid') and len(trim(url.AGTPid)) eq  0)>
		<cf_templateheader title="#nav__SPdescripcion#">
				<cfinclude template="/sif/portlets/pNavegacion.cfm">
				<cfoutput>#pNavegacion#</cfoutput>
			<cf_web_portlet_start titulo="#nav__SPdescripcion#">
					<!--- si se viene por aquí pinta lista de encabezados --->
					<!--- Pasa variables del url al form --->
					<!--- Prepara filtro de lista de encabezados --->
					<cfset filtro = "">
					<cfset navegacion = "">	
					<cfif isdefined("Form.btnFiltrar") and Len(Trim(Form.btnFiltrar)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "btnFiltrar=" & Form.btnFiltrar>
					</cfif>
					<cfinclude template="agtProceso_filtroGrupos.cfm">
					<cfif isdefined("Form.btnFiltrar") and Len(Trim(Form.btnFiltrar)) NEQ 0>
						<cfinclude template="repMejoras-lista.cfm">
					</cfif>
				<cf_web_portlet_end>
			<cf_templatefooter>
	<cfelse>
		<table width="100%" border="0">
		  <tr>
			<td width="5%">&nbsp;</td>
			<td>&nbsp;</td>
			<td width="5%">&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td>
					<!--- si se viene por aquí pinta reporte --->
					<cfset param = "">
					<cfset filtro = "">
					<cfset navegacion = "">						
					<!--- <cfinclude template="../operacion/agtProceso_filtroTransac.cfm"> --->
					<cfif isdefined("form.AGTPid") and Len(Trim(form.AGTPid))>
						<cfset param = param & "&AGTPid=#form.AGTPid#">
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "AGTPid=" & Form.AGTPid>
					</cfif>
					<cfif isdefined("form.FAplaca") and Len(Trim(form.FAplaca))>
						<cfset param = param & "&FAplaca=#form.FAplaca#">
					</cfif>
					<cfif isdefined("form.FCategoria") and Len(Trim(form.FCategoria))>
						<cfset param = param & "&FCategoria=#form.FCategoria#">
					</cfif>
					<cfif isdefined("form.FClase") and Len(Trim(form.FClase))>
						<cfset param = param & "&FClase=#form.FClase#">
					</cfif>
					<cfif isdefined("form.FCentroF") and Len(Trim(form.FCentroF))>
						<cfset param = param & "&FCentroF=#form.FCentroF#">
					</cfif>				
					<!--- <cf_rhimprime datos="/sif/af/Reportes/repMejoras-form.cfm" paramsuri="#param#" regresar="/cfmx/sif/af/Reportes/repMejoras.cfm"> --->
					
					<cfinclude template="repMejoras-form.cfm">
			</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
		</table>
	</cfif>
<cfelse>
	<cfset AGTPid = form.chk>
	<cfparam name="AGTPid">
	<cfquery name="rsAGTPestado" datasource="#session.dsn#">
		select AGTPestadp from AGTProceso where AGTPid = #AGTPid#
	</cfquery>
	<cfsavecontent variable="rsMejoras">
		<cfoutput>
			select 
				(select {fn concat({fn concat(cf.CFcodigo,' - ')},cf.CFdescripcion)} from CFuncional cf where cf.CFid = ta.CFid) as CFuncional,	
				(select {fn concat({fn concat(cat.ACcodigodesc,' - ')},cat.ACdescripcion)} from ACategoria cat where cat.Ecodigo = act.Ecodigo and cat.ACcodigo = act.ACcodigo) as Categoria,
				(select {fn concat({fn concat(clas.ACcodigodesc,' - ')},clas.ACdescripcion)} from AClasificacion clas where clas.Ecodigo = act.Ecodigo and clas.ACcodigo = act.ACcodigo and clas.ACid = act.ACid) as Clase,
				(select {fn concat({fn concat(ofi.Oficodigo,' - ')},ofi.Odescripcion)} from CFuncional cf inner join Oficinas ofi on ofi.Ecodigo = cf.Ecodigo and ofi.Ocodigo = cf.Ocodigo where cf.CFid = ta.CFid) as Oficina,	
				(select {fn concat({fn concat(dto.Deptocodigo,' - ')},dto.Ddescripcion)} from CFuncional cf inner join Departamentos dto on dto.Ecodigo = cf.Ecodigo and dto.Dcodigo = cf.Dcodigo where cf.CFid = ta.CFid) as Departamento,
				ta.TAperiodo as Periodo, 
				ta.TAmes as Mes,
				act.Aplaca as Placa, 
				act.Adescripcion as Activo, 
				act.Aserie as Serie,
				ta.TAvaladq as Adquisicion, 
				ta.TAvalmej as Mejoras, 
				ta.TAvalrev as Revaluacion, 
				ta.TAdepacumadq as DepAcumAdquisicion, 
				ta.TAdepacummej as DepAcumMejoras, 
				ta.TAdepacumrev as DepAcumRevaluacion, 
				ta.TAvaladq + ta.TAvalmej + ta.TAvalrev -
				ta.TAdepacumadq - ta.TAdepacummej - ta.TAdepacumrev as ValorLibrosAnterior,
				ta.TAmontolocmej as Mejora, 
				ta.TAvutil as VidaUtil,
				ta.TAvaladq + ta.TAvalmej + ta.TAmontolocmej + ta.TAvalrev -
				ta.TAdepacumadq - ta.TAdepacummej - ta.TAdepacumrev as ValorLibrosDespues
			from <cfif rsAGTPestado.AGTPestadp eq 4>TransaccionesActivos<cfelse>ADTProceso</cfif> ta 
				inner join Activos act
				on act.Ecodigo = ta.Ecodigo
				and act.Aid = ta.Aid
			where ta.AGTPid = #AGTPid#
			order by 1,2,3,8,9	
		</cfoutput>
	</cfsavecontent>
	<cftry>
		<cfflush interval="16000">
		<cf_jdbcquery_open name="data" datasource="#session.DSN#">
			<cfoutput>#rsMejoras#</cfoutput>
		</cf_jdbcquery_open>
		<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="Mejora_#session.Usucodigo##LSDateFormat(Now(),'ddmmyyyy')##LSTimeFormat(Now(),'hh:mm:ss')#.txt" jdbc="true">
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
	</cftry>
	<cf_jdbcquery_close>
</cfif>

