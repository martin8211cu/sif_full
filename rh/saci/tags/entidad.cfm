
<cfparam	name="Attributes.id"			type="string"	default="">						<!--- Id de Pais --->
<cfparam 	name="Attributes.form" 			type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.sufijo" 		type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.Ecodigo" 		type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 		type="string"	default="#Session.DSN#">		<!--- cache de conexion --->
<cfparam 	name="Attributes.readOnly" 		type="boolean"	default="false">				<!--- propiedad read Only para el tag, en este caso es obligatorio el id--->
<cfparam 	name="Attributes.IFCCOD" 		type="boolean"	default="false">		<!--- IFCCOD --->
<cfparam 	name="Attributes.INSCOD" 		type="boolean"	default="false">		<!--- INSCOD --->

<cfif Attributes.readOnly >
	
	<cfif len(trim(Attributes.id))>
		<cfquery name="rsReadOnly" datasource="#Attributes.Conexion#">
			select rtrim(a.EFid) as EFid, a.EFnombre
			from ISBentidadFinanciera a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
			and a.Habilitado = 1
			and a.EFid = <cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.id#">
			order by a.EFnombre, a.EFid
		</cfquery>
	</cfif>
	<cfoutput>
		<cfif isdefined("rsReadOnly") and Len(Trim(rsReadOnly.EFid))>
			#rsReadOnly.EFnombre#
		<cfelse>
			&lt;No Especificado&gt;
		</cfif>
	</cfoutput>
<cfelse>
	<cfquery name="rsEntidades" datasource="#Attributes.Conexion#">
		select rtrim(a.EFid) as EFid, a.EFnombre
		from ISBentidadFinanciera a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
		and a.Habilitado = 1
		<cfif Attributes.IFCCOD>
			and a.IFCCOD is not null
		</cfif>
		<cfif Attributes.INSCOD>
			and a.INSCOD is not null
		</cfif>
		order by a.EFnombre, a.EFid
	</cfquery>
	
	<cfoutput>
		<select name="EFid#Attributes.sufijo#" tabindex="1">
		  <cfloop query="rsEntidades"><option value="#rsEntidades.EFid#"<cfif Len(Trim(Attributes.id)) and trim(rsEntidades.EFid) eq trim(Attributes.id)> selected</cfif>>#rsEntidades.EFnombre#</option></cfloop>
		</select>
		
		<script language="javascript" type="text/javascript">
			function CargarValoresEntidad#Attributes.sufijo#(entidad) {
				document.#Attributes.form#.EFid#Attributes.sufijo#.value = entidad;
			}
		</script>
	</cfoutput>
</cfif>