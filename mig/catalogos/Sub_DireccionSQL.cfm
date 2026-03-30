<cfif isdefined ('form.ASDir')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Sub_Direccion" method="AgregarGerencia" >
			<cfinvokeargument name="MIGGid" 	value="#form.MIGGid#"/>
			<cfinvokeargument name="MIGSDid" 	value="#form.MIGSDid#"/>
			<cfinvokeargument name="MIGGcodigo" value="#form.MIGGcodigo#"/>
		</cfinvoke>	
	</cftransaction>
	<cfset modo='CAMBIO'>
	<cflocation url="Sub_Direccion.cfm?MIGSDid=#form.MIGSDid#&modo=#modo#&Tab=2">
</cfif>
<cfif isdefined ('form.Lista')>
	<cflocation url="Sub_Direccion.cfm">
</cfif>
<cfif isdefined ('form.ALTA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Sub_Direccion" method="Alta" returnvariable="MIGSDid">
			<cfinvokeargument name="MIGSDcodigo" 	value="#form.MIGSDcodigo#"/>
			<cfinvokeargument name="MIGSDdescripcion" 	value="#form.MIGSDdescripcion#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="MIGDid" 		value="#form.MIGDid#"/>
			<cfinvokeargument name="CodFuente" 		value="1"/>
		</cfinvoke>	
	</cftransaction>
	<cfif isdefined ('form.SubD')>
		<cfoutput>
				<script language="JavaScript1.2">
					window.close();
					window.parent.opener.document.NuevoForm.MIGSDid.value=#MIGSDid#;
				</script>
		</cfoutput>
			<cfabort>
	</cfif>
<cfset modo='CAMBIO'>
<cflocation url="Sub_Direccion.cfm?MIGSDid=#MIGSDid#&modo=#modo#&Tab=1">
</cfif>
<cfif isdefined ('form.CAMBIO')>

	<cftransaction>
		<cfinvoke component="mig.Componentes.Sub_Direccion" method="Cambio" >
			<cfinvokeargument name="MIGSDdescripcion" 	value="#form.MIGSDdescripcion#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="MIGSDid" 		value="#form.MIGSDid#"/>
			<cfinvokeargument name="MIGDid" 		value="#form.MIGDid#"/>
		</cfinvoke>	
	</cftransaction>
<cfset modo='CAMBIO'>
<cflocation url="Sub_Direccion.cfm?MIGSDid=#form.MIGSDid#&modo=#modo#&Tab=1">
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Sub_Direccion" method="Baja">
			<cfinvokeargument name="MIGSDid" 		value="#form.MIGSDid#"/>
		</cfinvoke>	
	</cftransaction>
<cflocation url="Sub_Direccion.cfm">
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="Sub_Direccion.cfm?Nuevo&Tab=1">
</cfif>
<cfif isdefined('form.MIGGid')>
	<cfset modo='CAMBIO'>
	<cflocation url="Sub_Direccion.cfm?MIGSDid=#form.MIGSDid#&modo=#modo#&Tab=2">
</cfif>
