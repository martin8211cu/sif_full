<cfoutput>
<cfif isDefined('form.id_vista')>
<iframe width="950" height="1500" src="vistaDetalle_form2.cfm?id_vista=#URLEncodedFormat(form.id_vista)#" 
	frameborder="0">
</iframe>
</cfif>
</cfoutput>