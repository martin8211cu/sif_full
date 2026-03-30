<cfif isdefined("url.form_name") and len(trim(url.form_name))
		and isdefined("url.TJlogin") 
		and Len(Trim(url.TJlogin))
		and isdefined("url.conexion") 
		and Len(Trim(url.conexion))>
		
	<cfquery datasource="#url.conexion#" name="rsDatosPrepago">
		Select TJid
			, TJprecio
			, AGid
			, TJestado
		from ISBprepago
		where TJlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.TJlogin#">
	</cfquery>
	
	<cfoutput>	
		<cfif rsDatosPrepago.recordcount EQ 1>
			<script language="JavaScript">
				<cfif rsDatosPrepago.AGid EQ session.saci.agente.id>
					<cfif rsDatosPrepago.TJestado EQ 0>
						window.parent.document.#url.form_name#.TJprecio.value="#rsDatosPrepago.TJprecio#";
						window.parent.document.#url.form_name#.TJid.value="#rsDatosPrepago.TJid#";										
					<cfelse>
						alert("Error, la tarjeta no posee el estado de 'Generada', \npor esa razón no se permite su venta.\n  Por favor digite una diferente.");
						window.parent.document.#url.form_name#.TJlogin.value="";
						window.parent.document.#url.form_name#.TJprecio.value="";
						window.parent.document.#url.form_name#.TJid.value="";								
					</cfif>	
				<cfelse>
					alert('Error, usted no esta autorizado a vender el prepago digitado. \nPor favor digite uno diferente');
					window.parent.document.#url.form_name#.TJlogin.value="";
					window.parent.document.#url.form_name#.TJprecio.value="";
					window.parent.document.#url.form_name#.TJid.value="";					
				</cfif>			
			</script>
		<cfelse>
			<script language="JavaScript">
				window.parent.document.#url.form_name#.TJlogin.value="";
				window.parent.document.#url.form_name#.TJprecio.value="";
				window.parent.document.#url.form_name#.TJid.value="";									
			</script>	
		</cfif>
	</cfoutput>
</cfif>	

