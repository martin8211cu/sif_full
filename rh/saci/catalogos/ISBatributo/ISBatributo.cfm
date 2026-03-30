
<!--- QUERY PARA EL COMBOBOX DEL FILTRO DE LA LISTA  --->
<cfquery name="rsTipoAtr" datasource="#session.DSN#">
	select '' as value, '-- todos --' as description, '0' as ord
	union
	select 'N' as value, 'Numerico' as description, '1' as ord
	union
	select 'T' as value, 'Text' as description, '1' as ord
	union
	select 'F' as value, 'Fecha' as description, '1' as ord
	union
	select 'V' as value, 'Valores' as description, '1' as ord
	order by 3,2
</cfquery>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">

		<table cellspacing="0" cellpadding="0" border="0" width="100%">
			<tr valign="top"><td width="55%">
				<!---<!--- Pagina--->
				<cfif isdefined("url.PageNum") and len(trim(url.PageNum))>
					<cfset url.Pagina = url.PageNum>
				</cfif>
				<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
					<cfset url.Pagina = url.PageNum_Lista>
					<cfset url.Aid = 0><!--- resetea la llave--->
				</cfif>
				<!--- Filtros--->
				<!--- <cfif isdefined("url.Filtro_Aetiq") and len(trim(url.Filtro_Aetiq))>
					<cfset form.Filtro_Aetiq = url.Filtro_Aetiq>
				</cfif>
				<cfif isdefined("url.Filtro_Adesc") and len(trim(url.Filtro_Adesc))>
					<cfset form.Filtro_Adesc = url.Filtro_Adesc>
				</cfif>
				<cfif isdefined("url.Filtro_AtipoDato") and len(trim(url.Filtro_AtipoDato))>
					<cfset form.Filtro_AtipoDato = url.Filtro_AtipoDato>
				</cfif>--->
				<!--- valores por defecto de la pagina y de los filtros--->
				<!---<cfparam name="form.Pagina" default="1">					
				<cfparam name="form.Filtro_Aetiq" default="">
				<cfparam name="form.Filtro_Adesc" default="">
				<cfparam name="form.Filtro_AtipoDato" default="">--->
				<!--- valores por defecto de la pagina y de los filtros cuando vienen de la lista al hacer clic en algun registro--->
				<cfparam name="url.Pagina" default="1">					
				<cfparam name="url.Filtro_Aetiq" default="">
				<cfparam name="url.Filtro_Adesc" default="">
				<cfparam name="url.Filtro_AtipoDato" default="">
				
				<cfdump var="#form#">
				<cfdump var="#url#">--->
				
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pLista"
					returnvariable="pListaPlanEvalDet">
					<cfinvokeargument name="tabla" value="ISBatributo">
					<cfinvokeargument name="columnas" value="Aid,Aetiq,substring(Adesc,1,20)||'...'as Adesc,(case AtipoDato when 'N' then 'Numérico' when 'T' then 'Texto' when 'F' then 'Fecha' when 'V' then 'Valores' else 'No definido' end) as TipoAtr,Aorden">
					<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# order by Aetiq">
					<cfinvokeargument name="desplegar" value="Aetiq,Adesc,TipoAtr">
					<cfinvokeargument name="etiquetas" value="Etiqueta,Descripcion,Tipo">
					<cfinvokeargument name="formatos" value="S,S,S">
					<cfinvokeargument name="align" value="left,left,left">
					<cfinvokeargument name="ira" value="ISBatributo.cfm">
					<cfinvokeargument name="form" value="lista">
					<cfinvokeargument name="form_method" value="get">
					<cfinvokeargument name="keys" value="Aid">
					<cfinvokeargument name="mostrar_filtro" value="yes">
					<cfinvokeargument name="filtrar_automatico" value="yes">
					<cfinvokeargument name="filtrar_por" value="Aetiq,Adesc,AtipoDato">
					<cfinvokeargument name="rstipoAtr" value="#rsTipoAtr#">
					<cfinvokeargument name="navegacion" value="">
					<cfinvokeargument name="maxRows" value="18">
					<cfinvokeargument name="showEmptyListMsg" value="true">
					<cfinvokeargument name="EmptyListMsg" value="--- No existen atributos ---">
				</cfinvoke>
							</td>
			<td  valign="top">
				<cfinclude template="ISBatributo-form.cfm">
			</td></tr>
		</table>

	<cf_web_portlet_end>
<cf_templatefooter>