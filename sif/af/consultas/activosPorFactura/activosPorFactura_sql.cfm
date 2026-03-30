<!---Se excluyeron los frames:
Activos_frameRevDevaluacion.cfm y Activos_frameTrasDepreciacion.cfm
Se cambio el orden de las listas --->
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cfset param = "key=1">

<cfif isdefined("form.Aplaca") and len(trim(form.Aplaca))>
	<cfset placa = #form.Aplaca#>
	<cfset param = param & "&placa=#form.Aplaca#">
</cfif>
<cfif isdefined("form.DEidentificacion") and len(trim(form.DEidentificacion))>
 	<cfset DEidentificacion = #form.DEidentificacion#>
	<cfset param = param & "&DEidentificacion=#form.DEidentificacion#">
</cfif>
<cfif isdefined("form.numSerie") and len(trim(form.numSerie))>
	<cfset numSerie = #form.numSerie#>
	<cfset param = param & "&numSerie=#form.numSerie#">
</cfif>
<cfif isdefined("form.factura") and len(trim(form.factura))>
	<cfset factura = #form.factura#>
	<cfset param = param & "&factura=#form.factura#">
</cfif>


	<cfquery name="buscarActivos" datasource="#session.dsn#">
		select 	a.*,c.Aplaca,c.Aserie,(case when c.Factura is null then x.EAcpdoc else c.Factura end) as Factura,
				g.DEnombre + ' ' + g.DEapellido1 + ' ' + g.DEapellido2 as responsable, a.Ecodigo
		from AFResponsables a
			inner join Activos c on c.Aid = a.Aid and c.Ecodigo = a.Ecodigo
			left join DSActivosAdq x on x.Ecodigo = c.Ecodigo and x.lin = c.Areflin
			left join DatosEmpleado g on g.DEid = a.DEid
		where a.Ecodigo =  #Session.Ecodigo#
		<cfif isdefined("placa") and len(trim(placa))>
		and c.Aplaca = '#placa#'
		</cfif>
		<cfif isdefined("DEidentificacion") and len(trim(DEidentificacion))>
		and g.DEidentificacion = '#DEidentificacion#'
		</cfif>
		<cfif isdefined("numSerie") and len(trim(numSerie))>
		and c.Aserie   = '#numSerie#'
		</cfif>
		<cfif isdefined("factura") and len(trim(factura))>
		and (c.Factura  = '#factura#' or x.EAcpdoc = '#factura#')
		</cfif>
		and getdate() between AFRfini and AFRffin
	</cfquery>

	<cfparam name="form.Aid" default=0>
	<cfset form.Aid = #buscarActivos.Aid#>

	<cf_templateheader title="Activos Encontrados">
	<cfoutput>#pNavegacion#</cfoutput>


<form name="form1">
	<input type="hidden" value="#placa#" name="placa" id="placa"/>
	<input type="hidden" value="#DEidentificacion#" name="DEidentificacion" id="DEidentificacion"/>
	<input type="hidden" value="#numSerie#" name="numSerie" id="numSerie"/>
	<input type="hidden" value="#factura#" name="factura" id="factura"/>

	<cfinvoke component='sif.Componentes.pListas'	method='pListaQuery' returnvariable='pListaRet'>
			<cfinvokeargument name='query' value='#buscarActivos#'>
			<cfinvokeargument name='desplegar' value='Aplaca, Aserie, responsable, factura'>
			<cfinvokeargument name='etiquetas' value='Placa, Numero de Serie, Responsable, Factura'>
			<cfinvokeargument name='formatos' value='S, S, S, S'>
			<cfinvokeargument name='align' value='left, left, left, left'>
			<cfinvokeargument name="showLink" value="true">
			<cfinvokeargument name="width" value="70%">
			<cfinvokeargument name="showEmptyListMsg" value="true">
			<cfinvokeargument name="incluyeForm" value="false">
			<cfinvokeargument name="formName" value="form1">
			<cfinvokeargument name="navegacion" value="#param#">
			<cfinvokeargument name="irA" value="reporteActivosPorFactura.cfm">
	</cfinvoke>

	<!--- Bot�n de regresar --->
	 <p>&nbsp;</p>
	 <div align=center>
	<a href="javascript:regresar();" tabindex="-1">
		<img src="/cfmx/sif/imagenes/back.gif"
		alt="Regresar"
		name="regresar"
		border="0" align="center">
		regresar
	</a>
	</div>

</form>


	<script language="javascript1.2" type="text/javascript">
		//funcion para regresar
		function regresar() {
			document.location="activosPorFactura.cfm";
		}
		//-->
	</script>
