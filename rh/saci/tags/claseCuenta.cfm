
<cfparam	name="Attributes.id"			type="string"	default="">						<!--- Id de Actividad Economica --->
<cfparam 	name="Attributes.form" 			type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam	name="Attributes.sufijo"		type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.Ecodigo" 		type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 		type="string"	default="#Session.DSN#">		<!--- cache de conexion --->

<cfquery name="rsClaseCuentas" datasource="#Attributes.Conexion#">
	select a.CCclaseCuenta, a.CCnombre
	from ISBclaseCuenta a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
</cfquery>

<cfoutput>
	<select name="CCclaseCuenta#Attributes.sufijo#" tabindex="1">
	  <cfloop query="rsClaseCuentas"><option value="#rsClaseCuentas.CCclaseCuenta#"<cfif Len(Trim(Attributes.id)) and trim(rsClaseCuentas.CCclaseCuenta) eq trim(Attributes.id)> selected</cfif>>#rsClaseCuentas.CCnombre#</option></cfloop>
	</select>

	<script language="javascript" type="text/javascript">
		function CargarValoresClaseCuenta#Attributes.sufijo#(clase) {
			document.#Attributes.form#.CCclaseCuenta#Attributes.sufijo#.value = clase;
		}
	</script>
</cfoutput>
