<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<!----
<cfelseif isdefined("Url.opcion") and Len(Trim(Url.opcion)) and not isdefined("Form.opcion")>
	<cfset form.opcion = Url.opcion>
</cfif>
----->
<cfif isdefined("url.codigo") and len(trim(url.codigo))>
	<cfquery name="rs" datasource="#session.DSN#">
		select SNcodigo, SNnumero, SNnombre
		from SNegocios
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and upper(SNnumero) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.codigo))#">
		<cfif isdefined("url.tipo") and len(trim(url.tipo))>
			<cfif url.tipo neq 'A'>
				and SNtiposocio in ('A', '#url.tipo#')
			<cfelse>
				and SNtiposocio = 'A'
			</cfif>
		</cfif> 
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			<cfoutput>
				window.parent.document.#form.formulario#.SNcodigo#index#.value = '#rs.SNcodigo#';
				window.parent.document.#form.formulario#.SNnumero#index#.value = '#trim(rs.SNnumero)#';
				window.parent.document.#form.formulario#.SNnombre#index#.value = '#rs.SNnombre#';
				if(window.parent.document.#form.formulario#.opcion.value == 1){
					var opcion = 1
				}
				else{var opcion = 0}
				//if(window.parent.document.#form.formulario#.opcion.value == 1){
					window.parent.document.#form.formulario#.action = 'compraProceso.cfm?btnNuevo=btnNuevo&SNcodigo='+'#rs.SNcodigo#'+'&opcion='+opcion;	
					window.parent.document.#form.formulario#.submit();
				//}	
			</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			<cfoutput>
				window.parent.document.#form.formulario#.SNcodigo#index#.value = ' ';
				window.parent.document.#form.formulario#.SNnumero#index#.value = ' ';
				window.parent.document.#form.formulario#.SNnombre#index#.value = ' ';
				if(window.parent.document.#form.formulario#.opcion.value == 1){
					window.parent.document.#form.formulario#.action = 'compraProceso.cfm?modo=CAMBIO&SNcodigo='+'#rs.SNcodigo#';	
					window.parent.document.#form.formulario#.submit();
				}	
			</cfoutput>
		</script>
	</cfif>
</cfif>