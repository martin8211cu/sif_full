<cfquery name="rsTPTipoIdent" datasource="tramites">
	select min(id_tipoident) as id_tipoident
	from TPTipoIdent
</cfquery>
<cfif rsTPTipoIdent.recordcount eq 0>
	<cfthrow message="Error en Conlis de Personas. Se requiere definir el tipo de identificación para ver la lista de Personas. Proceso Cancelado!">
</cfif>
<cfif isdefined("form.id_tipoident") and len(trim(form.id_tipoident)) and not isdefined("url.id_tipoident") or (isdefined("url.id_tipoident") and len(trim(url.id_tipoident)) eq 0)><cfset url.id_tipoident = form.id_tipoident></cfif>
<cfif isdefined("form.indice") and len(trim(form.indice)) and (not isdefined("url.index") or (isdefined("url.index") and len(trim(url.index)) eq 0))><cfset url.index = form.indice></cfif>
<cfif isdefined("form.form") and len(trim(form.form)) and not isdefined("url.form") or (isdefined("url.form") and len(trim(url.form)) eq 0)><cfset url.form = form.form></cfif>
<cfif isdefined("form.filtro_identificacion_persona") and len(trim(form.filtro_identificacion_persona)) and not isdefined("url.filtro_identificacion_persona") or (isdefined("url.filtro_identificacion_persona") and len(trim(url.filtro_identificacion_persona)) eq 0)><cfset url.filtro_identificacion_persona = form.filtro_identificacion_persona></cfif>
<cfif isdefined("form.filtro_nombre") and len(trim(form.filtro_nombre)) and not isdefined("url.filtro_nombre") or (isdefined("url.filtro_nombre") and len(trim(url.filtro_nombre)) eq 0)><cfset url.filtro_nombre = form.filtro_nombre></cfif>
<cfif isdefined("form.filtro_apellido1") and len(trim(form.filtro_apellido1)) and not isdefined("url.filtro_apellido1") or (isdefined("url.filtro_apellido1") and len(trim(url.filtro_apellido1)) eq 0)><cfset url.filtro_apellido1 = form.filtro_apellido1></cfif>
<cfif isdefined("form.filtro_apellido2") and len(trim(form.filtro_apellido2)) and not isdefined("url.filtro_apellido2") or (isdefined("url.filtro_apellido2") and len(trim(url.filtro_apellido2)) eq 0)><cfset url.filtro_apellido2 = form.filtro_apellido2></cfif>
<cfparam name="url.id_tipoident" default="#rsTPTipoIdent.id_tipoident#" type="numeric">
<cfparam name="url.index" default="" type="string">
<cfparam name="url.form" default="form1" type="string">
<cfset navegacion = "&id_tipoident=#url.id_tipoident#&index=#url.index#&form=#url.form#">
<cfoutput>
<script language="javascript" type="text/javascript">
	function asignar(identificacion_persona, nombre, apellido1, apellido2, id_persona){ 
		window.opener.document.#url.form#.identificacion_persona#url.index#.value = identificacion_persona;
		window.opener.document.#url.form#.nombre_persona#url.index#.value = apellido1 + ' ' + apellido2 + ' ' + nombre;
		window.opener.document.#url.form#.id_persona#url.index#.value = id_persona;
		window.close();
	 }
	 function funcFiltrar(){
	 	document.lista.ID_TIPOIDENT.value="#url.id_tipoident#";
		document.lista.INDICE.value="#url.index#";
		document.lista.FORM.value="#url.form#";
	 }
</script>
</cfoutput>
<cfquery name="rsLista0" datasource="tramites" maxrows="100">
	<cf_dbrowcount1 rows="100" datasource="tramites">
	select   identificacion_persona,
			 nombre , 
			 apellido1, 
			 apellido2,	
			 id_persona,
			 '' as id_tipoident,
			 '' as indice,
			 '' as form
	from     TPPersona
	where id_tipoident = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id_tipoident#">
	<cf_dbrowcount2 rows="100" datasource="tramites">
	<cfif isdefined("form.filtro_identificacion_persona") and len(trim(form.filtro_identificacion_persona))>
		  <cfset navegacion = navegacion & "&filtro_identificacion_persona="&form.filtro_identificacion_persona>
		  and identificacion_persona like '#UCase(trim(form.filtro_identificacion_persona))#%'
	</cfif>
	<cfif isdefined("form.filtro_nombre") and len(trim(form.filtro_nombre))>
		  <cfset navegacion = navegacion & "&filtro_nombre="&form.filtro_nombre>
		  and nombre like '#UCase(trim(form.filtro_nombre))#%'
	</cfif>
	<cfif isdefined("form.filtro_apellido1") and len(trim(form.filtro_apellido1))>
		<cfset navegacion = navegacion & "&filtro_apellido1="&form.filtro_apellido1>
		and apellido1 = '#UCase(trim(form.filtro_apellido1))#'
	</cfif>
	<cfif isdefined("form.filtro_apellido2") and len(trim(form.filtro_apellido2))>
		<cfset navegacion = navegacion & "&filtro_apellido2="&form.filtro_apellido2>
		and apellido2 = '#UCase(trim(form.filtro_apellido2))#'
	</cfif>
</cfquery>
<cfquery name="rsLista" dbtype="query">
	select * from rsLista0
	order by identificacion_persona
</cfquery>
<cfinvoke 
	component="sif.Componentes.pListas"
	method="pListaQuery"
	returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsLista#"/>
		<cfinvokeargument name="desplegar" value="identificacion_persona,nombre,apellido1,apellido2"/>
		<cfinvokeargument name="etiquetas" value="Identificaci&oacute;n,Nombre,Apellidos, "/>
		<cfinvokeargument name="formatos" value="S,S,S,S"/>
		<cfinvokeargument name="align" value="left,left,left,left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="keys" value="id_persona"/>
		<cfinvokeargument name="funcion" value="asignar"/>
		<cfinvokeargument name="fparams" value="identificacion_persona, nombre, apellido1, apellido2, id_persona"/>
		<cfinvokeargument name="irA" value="persona-conlis.cfm"/>
		<cfinvokeargument name="mostrar_filtro" value="true"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>