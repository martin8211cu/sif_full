<cfsetting enablecfoutputonly="yes">
<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo") and len(trim(url.SNcodigo))>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>

<cfquery datasource="asp" name="modalidad_query">
	select modalidad
	from CatalogoEmpresa
	where Ecodigo = #session.EcodigoSDC#
	  and tabla = 'SNegocios'
</cfquery>

<cfset modalidad = StructNew()>

<cfif Len(modalidad_query.modalidad) And Len(session.EcodigoCorp)>
	<cfset modalidad.modalidad = modalidad_query.modalidad>
<cfelse>
	<cfset modalidad.modalidad = 0>
</cfif>

<!---
	modalidades
	0		No hay corporativo
	1		Alta/importa
	2		Alta corporativa/importa
	3		Alta/Alta corporativa/importa


--->

<!--- controla el botón de importar en la lista, y deshabilita la pantalla de SociosImportar.cfm --->
<cfset modalidad.importar  = 0 NEQ ListFind('1,2,3', modalidad.modalidad)>

<!--- controla el botón de nuevo en la lista y en el formulario principal --->
<cfset modalidad.nuevo     = true>
<cfset modalidad.altalocal = 0 NEQ ListFind('0,1,3', modalidad.modalidad)>
<cfset modalidad.altacorp  = 0 NEQ ListFind('2,3', modalidad.modalidad)>

<cfset modalidad.eliminar  = 0 NEQ ListFind('0,1,2,3', modalidad.modalidad)>
<cfset modalidad.replicar  = 0 NEQ ListFind('2,3', modalidad.modalidad)>

<cfset modalidad.nombre = ListGetAt('No aplica,Alta local,Alta corporativa,Alta local y corporativa',modalidad.modalidad+1)>

<cfset modalidad.readonly = false>

<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfquery name="rsModalidadSocios" datasource="#Session.DSN#" >
		select yo.SNidCorporativo, 
		 coalesce (yo.EcodigoInclusion, yo.Ecodigo) as EcodigoInclusion
		from SNegocios yo
		where yo.Ecodigo = #session.Ecodigo#
		  and yo.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#">
	</cfquery>
	
	<cfset modalidad.readonly = ( Len(rsModalidadSocios.SNidCorporativo) NEQ 0 ) AND 
								( rsModalidadSocios.EcodigoInclusion NEQ session.Ecodigo )>
</cfif>

<cfsetting enablecfoutputonly="no">