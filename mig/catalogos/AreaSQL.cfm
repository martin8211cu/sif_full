<cfif isdefined ('form.ASDir')>

	<cftransaction>
		<cfinvoke component="mig.Componentes.Area" method="AgregaDistrito" >
			<cfinvokeargument name="MIGDiid" 	value="#form.MIGDiid#"/>
			<cfinvokeargument name="MIGArid" 		value="#form.MIGArid#"/>
		</cfinvoke>	
	</cftransaction>
	<cfset modo='CAMBIO'>
	<cflocation url="Area.cfm?MIGArid=#form.MIGArid#&modo=#modo#&Tab=2">
</cfif>

<cfif isdefined ('form.Lista')>
	<cflocation url="Area.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Area" method="Alta" returnvariable="MIGArid">
			<cfinvokeargument name="MIGArcodigo" 	value="#form.MIGArcodigo#"/>
			<cfinvokeargument name="MIGRid" 	     value="#form.MIGRid#"/>
			<cfinvokeargument name="MIGArdescripcion" 	value="#form.MIGArdescripcion#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="CodFuente" 		value="1"/>
		</cfinvoke>	
	</cftransaction>
	<cfif isdefined ('form.Area')>
		<cfoutput>
				<script language="JavaScript1.2">
					window.close();
					<!---var obj = window.parent.opener.document.getElementById('MIGSDid');--->
					window.parent.opener.document.f2.MIGArid.value=#MIGArid#;
				</script>
		</cfoutput>
			<cfabort>
	</cfif>
<cfset modo='CAMBIO'>
<cflocation url="Area.cfm?MIGArid=#MIGArid#&modo=#modo#&Tab=1">
</cfif>
<cfif isdefined ('form.CAMBIO')>

	<cftransaction>
		<cfinvoke component="mig.Componentes.Area" method="Cambio" >
			<cfinvokeargument name="MIGArdescripcion" 	value="#form.MIGArdescripcion#"/>
			<cfinvokeargument name="MIGRid" 	     value="#form.MIGRid#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="MIGArid" 		value="#form.MIGArid#"/>
		</cfinvoke>	
	</cftransaction>
<cfset modo='CAMBIO'>
<cflocation url="Area.cfm?MIGArid=#form.MIGArid#&modo=#modo#&Tab=1">
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Area" method="Baja" >
			<cfinvokeargument name="MIGArid" 		value="#form.MIGArid#"/>
		</cfinvoke>	
	</cftransaction>
<cflocation url="Area.cfm?Tab=1">
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="Area.cfm?Nuevo&Tab=1">
</cfif>
<cfif isdefined('form.MIGArid')>
<cfset modo='CAMBIO'>
	<cflocation url="Area.cfm?MIGArid=#form.MIGArid#&modo=#modo#&Tab=2">
</cfif>
