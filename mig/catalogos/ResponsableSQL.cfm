<!---<cfdump var="#form#">
<cf_dump var="#URL#">--->
<cfif isdefined ('form.NuevoDet')>
	<cfset modo='CAMBIO'>
	<cflocation url="Responsable.cfm?MIGReid=#form.MIGReid#&Tab=2&modo=#modo#">
</cfif>
<cfif isdefined ('form.AltaDet')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Responsable" method="AltaDet" returnvariable="MIGRDeptoid">
			<cfinvokeargument name="Dcodigo" 				value="#form.Dcodigo#"/>
			<cfinvokeargument name="MIGReid" 				value="#form.MIGReid#"/>
			<cfinvokeargument name="MIGRespDeptotipo" 		value="#form.MIGRespDeptotipo#"/>
		<cfif isdefined ('form.MIGRDeptoNivel') and form.MIGRDeptoNivel NEQ "">
			<cfinvokeargument name="MIGRDeptoNivel" 		value="#form.MIGRDeptoNivel#"/>
		<cfelse>
			<cfinvokeargument name="MIGRDeptoNivel" 		value="P"/>
		</cfif>
			<cfinvokeargument name="MIGResptipo" 			value="#form.MIGResptipo#"/>			
			<cfinvokeargument name="CodFuente" 				value="1"/>
		</cfinvoke>	
	</cftransaction>
	<cfset modo='CAMBIO'>
	<cflocation url="Responsable.cfm?MIGReid=#form.MIGReid#&Tab=2&modo=#modo#">
</cfif>
<cfif isdefined ('form.CambioDet')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Responsable" method="CambioDet">
			<cfinvokeargument name="MIGRDeptoid" 			value="#form.MIGRDeptoid#"/>
			<cfinvokeargument name="Dcodigo" 				value="#form.Dcodigo#"/>
			<cfinvokeargument name="MIGReid" 				value="#form.MIGReid#"/>
			<cfinvokeargument name="MIGRespDeptotipo" 		value="#form.MIGRespDeptotipo#"/>
		<cfif isdefined ('form.MIGRDeptoNivel') and form.MIGRDeptoNivel NEQ "">
			<cfinvokeargument name="MIGRDeptoNivel" 		value="#form.MIGRDeptoNivel#"/>
		</cfif>
			<cfinvokeargument name="MIGResptipo" 			value="#form.MIGResptipo#"/>			
		</cfinvoke>	
	</cftransaction>
	<cfset modo='CAMBIO'>
	<cfset mododet='CAMBIO'>
	<cflocation url="Responsable.cfm?MIGReid=#form.MIGReid#&Tab=2&modo=#modo#&MIGRDeptoid=#form.MIGRDeptoid#&mododet=#mododet#">
</cfif>
<cfif isdefined ('form.BajaDet')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Responsable" method="BajaDet">
			<cfinvokeargument name="MIGRDeptoid" 			value="#form.MIGRDeptoid#"/>
		</cfinvoke>	
	</cftransaction>
	<cfset modo='CAMBIO'>
	<cflocation url="Responsable.cfm?MIGReid=#form.MIGReid#&Tab=2&modo=#modo#">
</cfif>


<cfif isdefined ('form.Lista')>
	<cflocation url="Responsable.cfm">
</cfif>
<cfif isdefined('form.Importar')>
	<cflocation url="ResponsableImportador.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Responsable" method="Alta" returnvariable="MIGReid">
			<cfinvokeargument name="MIGRcodigo" 	value="#form.MIGRcodigo#"/>
			<cfinvokeargument name="MIGRenombre" 	value="#form.MIGRenombre#"/>
			<cfinvokeargument name="Dactivas" 		value="1"/>
			<cfinvokeargument name="CodFuente" 		value="1"/>
		<cfif isdefined ('form.MIGRecorreo') and trim(form.MIGRecorreo) NEQ "">
			<cfinvokeargument name="MIGRecorreo" 	value="#form.MIGRecorreo#"/>
		<cfelse>
			<cfinvokeargument name="MIGRecorreo" 	value=""/>
		</cfif>
		<cfif isdefined ('form.MIGRecorreoadicional') and trim(form.MIGRecorreoadicional) NEQ "">
			<cfinvokeargument name="MIGRecorreoadicional" 	value="#form.MIGRecorreoadicional#"/>
		<cfelse>
			<cfinvokeargument name="MIGRecorreoadicional" 	value=""/>
		</cfif>
		</cfinvoke>	
	</cftransaction>
	<cfset modo='CAMBIO'>
	<cflocation url="Responsable.cfm?MIGReid=#MIGReid#&Tab=1&modo=#modo#">
</cfif>
<cfif isdefined ('form.CAMBIO')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Responsable" method="Cambio" >
			<cfinvokeargument name="MIGRenombre" 	value="#form.MIGRenombre#"/>
			<cfinvokeargument name="MIGReid" 		value="#form.MIGReid#"/>
		<cfif isdefined ('form.MIGRecorreo') and trim(form.MIGRecorreo) NEQ "">
			<cfinvokeargument name="MIGRecorreo" 	value="#form.MIGRecorreo#"/>
		<cfelse>
			<cfinvokeargument name="MIGRecorreo" 	value=""/>
		</cfif>
		<cfif isdefined ('form.MIGRecorreoadicional') and trim(form.MIGRecorreoadicional) NEQ "">
			<cfinvokeargument name="MIGRecorreoadicional" 	value="#form.MIGRecorreoadicional#"/>
		<cfelse>
			<cfinvokeargument name="MIGRecorreoadicional" 	value=""/>
		</cfif>
		</cfinvoke>	
	</cftransaction>
	<cfset modo='CAMBIO'>
	<cflocation url="Responsable.cfm?MIGReid=#form.MIGReid#&Tab=1&modo=#modo#">
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Responsable" method="Baja" >
			<cfinvokeargument name="MIGReid" 		value="#form.MIGReid#"/>
		</cfinvoke>	
	</cftransaction>
	<cflocation url="Responsable.cfm">
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="Responsable.cfm?Nuevo">
</cfif>

