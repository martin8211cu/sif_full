<!---Listado Inicial de los tipos de Solicitudes (Activos Fijos, conceptos de servicios, Articulos de Inventario y Obras en contrucción)--->
<cfif isdefined("url.CMTScodigo") and not isdefined("form.CMTScodigo") >
	<cfset form.CMTScodigo = url.CMTScodigo >
</cfif>
<cfif isdefined("url.CMTSdescripcion") and not isdefined("form.CMTSdescripcion") >
	<cfset form.CMTSdescripcion = url.CMTSdescripcion >
</cfif>
<cfif isdefined("url.LTipos") and not isdefined("form.LTipos") >
	<cfset form.LTipos = url.LTipos >
</cfif>
<cfset checked   = "<img border='0' src='/cfmx/sif/imagenes/checked.gif'>" >
<cfset unchecked = "<img border='0' src='/cfmx/sif/imagenes/unchecked.gif'>" >

<script language="javascript" type="text/javascript">
	function funcNuevo(){
		document.formlista.OPT.value = 1;
	}
</script>

<cfinclude template="CompraConfig-Paso0Filto.cfm">

<cfquery name="rsTiposSolicitud" datasource="#session.dsn#">
	select CMTScodigo, CMTSdescripcion, 1 as opt,  Mnombre, CMTSmontomax,'' as codigo, '' as descripcion, '' as tipo,
		case CMTStarticulo 	when 1 then '#checked#' else '#unchecked#' end as CMTStarticulo, 
		case CMTSservicio	when 1 then '#checked#' else '#unchecked#' end as CMTSservicio, 
		case CMTSactivofijo when 1 then '#checked#' else '#unchecked#' end as CMTSactivofijo,
		case CMTSobras 		when 1 then '#checked#' else '#unchecked#' end as CMTSobras
	from CMTiposSolicitud a
		inner join Monedas c 
		  on c.Ecodigo = a.Ecodigo
		 and c.Mcodigo = a.Mcodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	
	<cfif isdefined("form.CMTScodigo") and len(trim(form.CMTScodigo)) >
		and upper(CMTScodigo) like  upper('%#form.CMTScodigo#%')
	</cfif>
	<cfif isdefined("form.CMTSdescripcion") and len(trim(form.CMTSdescripcion)) >
		and upper(CMTSdescripcion) like upper('%#form.CMTSdescripcion#%')
	</cfif>	
	
	<cfif isdefined("form.LTipos") and len(trim(form.LTipos)) >		
		<cfif form.LTipos EQ 'Artículo'>
			and CMTStarticulo = 1
		<cfelseif form.LTipos EQ 'Servicio'>
			and CMTSservicio = 1
		<cfelseif form.LTipos EQ 'Activo'>
			and CMTSactivofijo = 1
		<cfelseif form.LTipos EQ 'Obras'>
			and CMTSobras = 1
		</cfif>
	</cfif>	
	
	order by CMTScodigo,CMTSdescripcion
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet"> 
	<cfinvokeargument name="query" 				value="#rsTiposSolicitud#"/> 
	<cfinvokeargument name="desplegar" 			value="CMTScodigo, CMTSdescripcion, CMTStarticulo, CMTSservicio, CMTSactivofijo, CMTSobras, Mnombre, CMTSmontomax"/> 
	<cfinvokeargument name="etiquetas" 			value="Código, Descripción, Artículos, Servicios, Activos Fijos,Obras Contrucción,Moneda, Monto Máximo"/> 
	<cfinvokeargument name="formatos" 			value="S,S,S,B,B,B,B,M"/> 
	<cfinvokeargument name="align" 				value="left,left,left,center,center,center,center,right"/> 
	<cfinvokeargument name="ajustar" 			value="N"/> 
	<cfinvokeargument name="checkboxes" 		value="N"/> 
	<cfinvokeargument name="irA" 				value="compraConfig.cfm"/> 
	<cfinvokeargument name="keys" 				value="CMTScodigo"/> 
	<cfinvokeargument name="botones" 			value="Nuevo"/> 
	<cfinvokeargument name="formname" 			value="formlista"/>
	<cfinvokeargument name="showEmptyListMsg" 	value="true"/> 
</cfinvoke> 