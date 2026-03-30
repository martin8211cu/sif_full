<cfif isdefined ('form.ASDir')>

	<cftransaction>
		<cfinvoke component="mig.Componentes.Pais" method="AgregaRegion" >
			<cfinvokeargument name="MIGRid" 	value="#form.MIGRid#"/>
			<cfinvokeargument name="MIGPaid" 		value="#form.MIGPaid#"/>
			<cfinvokeargument name="MIGRcodigo" 		value="#form.MIGRcodigo#"/>
		</cfinvoke>	
	</cftransaction>
	<cfset modo='CAMBIO'>
	<cflocation url="Pais.cfm?MIGPaid=#form.MIGPaid#&modo=#modo#&Tab=2">
</cfif>

<cfif isdefined ('form.Lista')>
	<cflocation url="Pais.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Pais" method="Alta" returnvariable="MIGPaid">
			<cfinvokeargument name="MIGPacodigo" 	value="#form.MIGPacodigo#"/>
			<cfinvokeargument name="MIGPadescripcion" 	value="#form.MIGPadescripcion#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="CodFuente" 		value="1"/>
		</cfinvoke>	
	</cftransaction>
<cfset modo='CAMBIO'>
<cflocation url="Pais.cfm?MIGPaid=#MIGPaid#&modo=#modo#&Tab=1">
</cfif>
<cfif isdefined ('form.CAMBIO')>

	<cftransaction>
		<cfinvoke component="mig.Componentes.Pais" method="Cambio" >
			<cfinvokeargument name="MIGPadescripcion" 	value="#form.MIGPadescripcion#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="MIGPaid" 		value="#form.MIGPaid#"/>
		</cfinvoke>	
	</cftransaction>
<cfset modo='CAMBIO'>
<cflocation url="Pais.cfm?MIGPaid=#form.MIGPaid#&modo=#modo#&Tab=1">
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Pais" method="Baja" >
			<cfinvokeargument name="MIGPaid" 		value="#form.MIGPaid#"/>
		</cfinvoke>	
	</cftransaction>
<cflocation url="Pais.cfm?Tab=1">
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="Pais.cfm?Nuevo&Tab=1">
</cfif>
<cfif isdefined('form.MIGPaid')>
<cfset modo='CAMBIO'>
	<cflocation url="Pais.cfm?MIGPaid=#form.MIGPaid#&modo=#modo#&Tab=2">
</cfif>