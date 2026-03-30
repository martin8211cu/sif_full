<cfquery datasource="#session.Fondos.dsn#" name="Validacion">
Select count(1) as cantidad
from CJX004 
where CJX04IND = 'S' 
  and CJX04UMK = '#session.usuario#'
  and CJX04REF2 is null
</cfquery>

<script>
	<cfif Validacion.cantidad gt 0>
		window.parent.document.form2.VTPrevia.value = <cfoutput>#Url.Previo#</cfoutput>;
		window.parent.document.form2.submit(); 
	<cfelse>
		alert('Debe Marcar al menos una liquidacion para poder asignar una referencia');
	</cfif>
</script>
