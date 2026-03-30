
<cfparam	name="Attributes.id"			type="string"	default="">						<!--- Id de Pais --->
<cfparam 	name="Attributes.form" 			type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.sufijo" 		type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.Ecodigo" 		type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 		type="string"	default="#Session.DSN#">		<!--- cache de conexion --->
<cfparam 	name="Attributes.readOnly" 		type="boolean"	default="false">				<!--- propiedad read Only para el tag, en este caso es obligatorio el id--->
<cfparam 	name="Attributes.funcion" 		type="string"	default="">						<!--- funcion en javascript para el evento onChange del combo --->

<cfif Attributes.readOnly >
	<cfif len(trim(Attributes.id))>
		<cfquery name="rsReadOnly" datasource="#Attributes.Conexion#">
			select a.Miso4217, a.Mnombre, a.Msimbolo, a.Miso4217
			from Monedas a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
				and Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.id#">
		</cfquery>
	</cfif>
	<cfoutput>
		<cfif isdefined("rsReadOnly") and Len(Trim(rsReadOnly.Mnombre))>
			#rsReadOnly.Mnombre#
		<cfelse>
			&lt;No Especificado&gt;
		</cfif>
	</cfoutput>
	
<cfelse>

	<cfquery name="rsMonedas" datasource="#Attributes.Conexion#">
		select a.Miso4217, a.Mnombre, a.Msimbolo, a.Miso4217
		from Monedas a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
	</cfquery>
	
	<cfoutput>
		<select name="Miso4217#Attributes.sufijo#" tabindex="1" <cfif isdefined('Attributes.funcion') and Attributes.funcion NEQ ''> onChange="javascript: #Attributes.funcion##Attributes.sufijo#(this);"</cfif>>
		  <cfloop query="rsMonedas"><option value="#rsMonedas.Miso4217#"<cfif Len(Trim(Attributes.id)) and trim(rsMonedas.Miso4217) eq trim(Attributes.id)> selected</cfif>>#rsMonedas.Mnombre#</option></cfloop>
		</select>
		
		<script language="javascript" type="text/javascript">
			function CargarValoresMonedas#Attributes.sufijo#(moneda) {
				document.#Attributes.form#.Miso4217#Attributes.sufijo#.value = moneda;
			}
		</script>
	</cfoutput>
</cfif>
