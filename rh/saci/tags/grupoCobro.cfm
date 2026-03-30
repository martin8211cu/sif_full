
<cfparam	name="Attributes.id"			type="string"	default="">						<!--- Id de Actividad Economica --->
<cfparam 	name="Attributes.form" 			type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam	name="Attributes.sufijo"		type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.Ecodigo" 		type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 		type="string"	default="#Session.DSN#">		<!--- cache de conexion --->

<cfquery name="rsGruposCobro" datasource="#Attributes.Conexion#">
	select a.GCcodigo, a.GCnombre
	from ISBgrupoCobro a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
</cfquery>

<cfoutput>
	<select name="GCcodigo#Attributes.sufijo#" tabindex="1">
	  <cfloop query="rsGruposCobro"><option value="#rsGruposCobro.GCcodigo#"<cfif Len(Trim(Attributes.id)) and trim(rsGruposCobro.GCcodigo) eq trim(Attributes.id)> selected</cfif>>#rsGruposCobro.GCnombre#</option></cfloop>
	</select>

	<script language="javascript" type="text/javascript">
		function CargarValoresGrupoCobro#Attributes.sufijo#(grupo) {
			document.#Attributes.form#.GCcodigo#Attributes.sufijo#.value = grupo;
		}
	</script>
</cfoutput>
