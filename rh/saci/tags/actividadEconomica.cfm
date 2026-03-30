
<cfparam	name="Attributes.id"			type="string"	default="">						<!--- Id de Actividad Economica --->
<cfparam 	name="Attributes.form" 			type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam	name="Attributes.sufijo"		type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.Ecodigo" 		type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 		type="string"	default="#Session.DSN#">		<!--- cache de conexion --->

<cfquery name="rsActividades" datasource="#Attributes.Conexion#">
	select a.AEactividad, a.AEnombre
	from ISBactividadEconomica a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
</cfquery>

<cfoutput>
	<select name="AEactividad#Attributes.sufijo#" tabindex="1">
	  <cfloop query="rsActividades"><option value="#rsActividades.AEactividad#"<cfif Len(Trim(Attributes.id)) and trim(rsActividades.AEactividad) eq trim(Attributes.id)> selected</cfif>>#rsActividades.AEnombre#</option></cfloop>
	</select>

	<script language="javascript" type="text/javascript">
		function CargarValoresActividad#Attributes.sufijo#(actividad) {
			document.#Attributes.form#.AEactividad#Attributes.sufijo#.value = actividad;
		}
	</script>
</cfoutput>
