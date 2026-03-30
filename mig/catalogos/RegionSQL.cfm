<cfif isdefined ('form.ASDir')>

	<cftransaction>
		<cfinvoke component="mig.Componentes.Region" method="AgregaArea" >
			<cfinvokeargument name="MIGArid" 	value="#form.MIGArid#"/>
			<cfinvokeargument name="MIGRid" 		value="#form.MIGRid#"/>
		</cfinvoke>	
	</cftransaction>
	<cfset modo='CAMBIO'>
	<cflocation url="Region.cfm?MIGRid=#form.MIGRid#&modo=#modo#&Tab=2">
</cfif>

<cfif isdefined ('form.Lista')>
	<cflocation url="Region.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Region" method="Alta" returnvariable="MIGRid">
			<cfinvokeargument name="MIGRcodigo" 	value="#form.MIGRcodigo#"/>
			<cfinvokeargument name="MIGPaid" 	     value="#form.MIGPaid#"/>
			<cfinvokeargument name="MIGRdescripcion" 	value="#form.MIGRdescripcion#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="CodFuente" 		value="1"/>
		</cfinvoke>	
	</cftransaction>
	<cfif isdefined ('form.Region')>
		<cfoutput>
				<script language="JavaScript1.2">
					window.close();
					<!---var obj = window.parent.opener.document.getElementById('MIGSDid');--->
					window.parent.opener.document.f1.MIGRid.value=#MIGRid#;
				</script>
		</cfoutput>
			<cfabort>
	</cfif>
<cfset modo='CAMBIO'>
<cflocation url="Region.cfm?MIGRid=#MIGRid#&modo=#modo#&Tab=1">
</cfif>
<cfif isdefined ('form.CAMBIO')>

	<cftransaction>
		<cfinvoke component="mig.Componentes.Region" method="Cambio" >
			<cfinvokeargument name="MIGRdescripcion" 	value="#form.MIGRdescripcion#"/>
			<cfinvokeargument name="MIGPaid" 	     value="#form.MIGPaid#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="MIGRid" 		value="#form.MIGRid#"/>
		</cfinvoke>	
	</cftransaction>
<cfset modo='CAMBIO'>
<cflocation url="Region.cfm?MIGRid=#form.MIGRid#&modo=#modo#&Tab=1">
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Region" method="Baja" >
			<cfinvokeargument name="MIGRid" 		value="#form.MIGRid#"/>
		</cfinvoke>	
	</cftransaction>
<cflocation url="Region.cfm?Tab=1">
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="Region.cfm?Nuevo&Tab=1">
</cfif>
<cfif isdefined('form.MIGRid')>
<cfset modo='CAMBIO'>
	<cflocation url="Region.cfm?MIGRid=#form.MIGRid#&modo=#modo#&Tab=2">
</cfif>
