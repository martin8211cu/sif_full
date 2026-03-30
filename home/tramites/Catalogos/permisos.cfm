<cfparam name="Attributes.tipo_objeto" type="string">
<cfparam name="Attributes.id_objeto" type="numeric">
<cfparam name="Attributes.items" type="string" default="">
<cfoutput>
<iframe src="permisos-form.cfm?tipo_objeto=#URLEncodedFormat(Attributes.tipo_objeto
	)#&id_objeto=#URLEncodedFormat(Attributes.id_objeto
	)#&items=#URLEncodedFormat(Attributes.items
	)#" width="100%" height="650" frameborder="0">
</iframe>
</cfoutput>