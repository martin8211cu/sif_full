
<cfparam	name="Attributes.id"			type="string"	default="">						<!--- Id de Pais --->
<cfparam 	name="Attributes.form" 			type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.sufijo" 		type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.Ecodigo" 		type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 		type="string"	default="#Session.DSN#">		<!--- cache de conexion --->
<cfparam 	name="Attributes.readOnly" 		type="boolean"	default="false">				<!--- solo de lectura, es obligatorio el id --->

<cfif Attributes.readOnly>
	<cfif len(trim(Attributes.id))>
		<cfquery name="rsReadOnly" datasource="#Attributes.Conexion#">
			select a.Ppais, a.Pnombre 
			from Pais a
			where a.Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.id#">
		</cfquery>
	</cfif>
	<cfoutput>
		<cfif isdefined("rsReadOnly") and Len(Trim(rsReadOnly.Ppais))>
			#rsReadOnly.Pnombre#
		<cfelse>
			&lt;No Especificado&gt;
		</cfif>
	</cfoutput>
	
<cfelse>
	<cfquery name="rsPaises" datasource="#Attributes.Conexion#">
		select a.Ppais, a.Pnombre 
		from Pais a
		order by a.Pnombre
	</cfquery>

	<cfoutput>
		<select name="Ppais#Attributes.sufijo#" tabindex="11">
		  <cfloop query="rsPaises"><option value="#rsPaises.Ppais#"<cfif Len(Trim(Attributes.id)) and trim(rsPaises.Ppais) eq trim(Attributes.id)> selected</cfif>>#rsPaises.Pnombre#</option></cfloop>
		</select>
		<script language="javascript" type="text/javascript">
			function CargarValoresPais#Attributes.sufijo#(pais) {
				document.#Attributes.form#.Ppais#Attributes.sufijo#.value = pais;
			}
		</script>
	</cfoutput>
</cfif>