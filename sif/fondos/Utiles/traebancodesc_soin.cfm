<cfif isdefined("url.dato") and dato neq ""> 

	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		Select B01DES from B01ARC where B01COD = '#url.dato#'
	</cfquery>
	
	
	<cfif rs.recordcount gt 0> 
	
		<script>
		window.parent.document.<cfoutput>#url.form#.</cfoutput>nbancosoin.value="<cfoutput>#rs.B01DES#</cfoutput>";
		</script>
	
	<cfelse>
		<script>
		window.parent.document.<cfoutput>#url.form#.</cfoutput>nbancosoin.value="";
		alert("El banco no existe")
		</script>	
	</cfif>

</cfif>
