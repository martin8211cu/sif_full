<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>

<cfif isdefined("url.codigo") and len(trim(url.codigo))>
	<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
		select Tcodigo, Tdescripcion
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and upper(Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.codigo))#">
		order by Tcodigo
	</cfquery>

	<cfif rsTiposNomina.recordcount gt 0>
		<script language="JavaScript">
			<cfoutput>
				window.parent.document.#form.formulario#.Tcodigo#index#.value = '#trim(rsTiposNomina.Tcodigo)#';
				window.parent.document.#form.formulario#.Tdescripcion#index#.value = '#rsTiposNomina.Tdescripcion#';
			</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			<cfoutput>
				window.parent.document.#form.formulario#.Tcodigo#index#.value = ' ';
				window.parent.document.#form.formulario#.Tdescripcion#index#.value = ' ';
			</cfoutput>
		</script>
	</cfif>
</cfif>