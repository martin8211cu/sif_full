<cfif isdefined("url.dato") and dato neq ""> 

	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		Select nombre_banco from arquitectura..EBA01C where id_banco = #url.dato#
		
	</cfquery>
	
	
	<cfif rs.recordcount gt 0> 
	
		<script>
		window.parent.document.<cfoutput>#url.form#.</cfoutput>nbancoarq.value="<cfoutput>#rs.nombre_banco#</cfoutput>";
		</script>
	
	<cfelse>
		<script>
			window.parent.document.<cfoutput>#url.form#.</cfoutput>nbancoarq.value="";
			alert("El banco no existe")		
		</script>
	</cfif>

</cfif>
