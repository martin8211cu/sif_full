<!---  <cfdump var="#form#">
<cf_dump var="#URL#">
--->

<cfif isdefined ('form.Lista')>
	<cflocation url="MIGParametro.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.MIGParametro" method="Alta" returnvariable="MIGParid">
			<cfinvokeargument name="MIGParcodigo" 			value="#form.MIGParcodigo#"/>
			<cfinvokeargument name="MIGPardescripcion"	value="#form.MIGPardescripcion#"/>
			<cfinvokeargument name="MIGPartipo" 				value="#form.MIGPartipo#"/>
			<cfinvokeargument name="MIGParsubtipo" 			value="#form.MIGParsubtipo#"/>
			<cfinvokeargument name="MIGParactual" 			value="#form.MIGParactual#"/>
		</cfinvoke>
	</cftransaction>
	<cfset modo='CAMBIO'>
	<cflocation url="MIGParametro.cfm?MIGParid=#MIGParid#&Tab=1&modo=#modo#">
</cfif>
<cfif isdefined ('form.CAMBIO')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.MIGParametro" method="Cambio" >
			<cfinvokeargument name="MIGParid" 					value="#form.MIGParid#"/>
			<cfinvokeargument name="MIGPardescripcion"	value="#form.MIGPardescripcion#"/>
			<cfinvokeargument name="MIGPartipo" 				value="#form.MIGPartipo#"/>
			<cfinvokeargument name="MIGParsubtipo" 			value="#form.MIGParsubtipo#"/>
			<cfinvokeargument name="MIGParactual" 			value="#form.MIGParactual#"/>
			<cfif isdefined ('form.Dactiva') and ltrim(form.Dactiva) NEQ "">
					<cfinvokeargument name="Dactiva" 				value="#form.Dactiva#"/>
			<cfelse>
					<cfinvokeargument name="Dactiva" 				value="0"/>
			</cfif>
		</cfinvoke>
	</cftransaction>
	<cfset modo='CAMBIO'>
	<cflocation url="MIGParametro.cfm?MIGParid=#form.MIGParid#&Tab=1&modo=#modo#">
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.MIGParametro" method="Baja" >
			<cfinvokeargument name="MIGParid" 		value="#form.MIGParid#"/>
		</cfinvoke>
	</cftransaction>
	<cflocation url="MIGParametro.cfm">
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="MIGParametro.cfm?Nuevo">
</cfif>


<cfif isdefined('form.Pfechainicial') and trim(form.Pfechainicial) EQ "">
	<cfset form.Pfechainicial = LSDateFormat(Now(),'dd/mm/yyyy')>
</cfif>
<cfif isdefined('form.Pfechafinal') and trim(form.Pfechafinal) EQ "">
	<cfset form.Pfechafinal = LSDateFormat(Now(),'dd/mm/yyyy')>
</cfif>

<cfif isdefined ('form.NuevoDet')>
	<cfset modo='CAMBIO'>
	<cflocation url="MIGParametro.cfm?MIGParid=#form.MIGParid#&Tab=2&modo=#modo#">
</cfif>
<cfif isdefined ('form.AltaDet')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.MIGParametro" method="AltaDet" returnvariable="MIGPardetid">
			<cfinvokeargument name="MIGParid" 						value="#form.MIGParid#"/>
			<cfinvokeargument name="Pfechainicial" 				value="#form.Pfechainicial#"/>
			<cfinvokeargument name="Pfechafinal" 					value="#form.Pfechafinal#"/>
			<cfinvokeargument name="Valorcalificacion" 		value="#form.Valorcalificacion#"/>
			<cfinvokeargument name="Peso" 								value="#form.Peso#"/>
		</cfinvoke>
	</cftransaction>
	
			<!---  

			<cfdump var="#form#">
			<cf_dump var="#URL#">
		--->
	
	<cfset modo='CAMBIO'>
	<cflocation url="MIGParametro.cfm?MIGParid=#form.MIGParid#&Tab=2&modo=#modo#">
</cfif>
<cfif isdefined ('form.CambioDet')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.MIGParametro" method="CambioDet">
			<cfinvokeargument name="MIGPardetid" 				value="#form.MIGPardetid#"/>
			<cfinvokeargument name="MIGParid" 					value="#form.MIGParid#"/>
			<cfinvokeargument name="Pfechainicial" 			value="#form.Pfechainicial#"/>
			<cfinvokeargument name="Pfechafinal" 				value="#form.Pfechafinal#"/>
			<cfinvokeargument name="Valorcalificacion" 	value="#form.Valorcalificacion#"/>
			<cfinvokeargument name="Peso" 							value="#form.Peso#"/>
		</cfinvoke>
	</cftransaction>
	<cfset modo='CAMBIO'>
	<cfset mododet='CAMBIO'>
	<cflocation url="MIGParametro.cfm?MIGParid=#form.MIGParid#&Tab=2&modo=#modo#&MIGPardetid=#form.MIGPardetid#&mododet=#mododet#">
</cfif>
<cfif isdefined ('form.BajaDet')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.MIGParametro" method="BajaDet">
			<cfinvokeargument name="MIGPardetid" 			value="#form.MIGPardetid#"/>
		</cfinvoke>
 </cftransaction>
	<cfset modo='CAMBIO'>
	<cflocation url="MIGParametro.cfm?MIGParid=#form.MIGParid#&Tab=2&modo=#modo#">
</cfif>
