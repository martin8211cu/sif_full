<cfparam name="nombre" type="string">
<cfquery name="rst" datasource="minisif">
	select TOP 1
		Ecodigo, 
		Mnombre, 
		Msimbolo
	from Monedas
	Where Mnombre = '#nombre#'
</cfquery>

<script>
	if (<cfoutput>#rst.recordCount#</cfoutput> > 0) {
		parent.document.miForm.miTexto.value = '<cfoutput>#rst.Mnombre#</cfoutput>'
		parent.document.miForm.miTexto2.value = '<cfoutput>#rst.Ecodigo#</cfoutput>'
		parent.document.miForm.miTexto3.value = '<cfoutput>#rst.Msimbolo#</cfoutput>'				
	}
</script>