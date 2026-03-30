<cfif isdefined ('form.ASDir')>

	<cftransaction>
		<cfinvoke component="mig.Componentes.Direccion" method="AgregaSub_Direccion" >
			<cfinvokeargument name="MIGSDid" 	value="#form.MIGSDid#"/>
			<cfinvokeargument name="MIGDid" 		value="#form.MIGDid#"/>
			<cfinvokeargument name="MIGSDcodigo" 		value="#form.MIGSDcodigo#"/>
		</cfinvoke>	
	</cftransaction>
	<cfset modo='CAMBIO'>
	<cflocation url="MIGDireccion.cfm?MIGDid=#form.MIGDid#&modo=#modo#&Tab=2">
</cfif>

<cfif isdefined ('form.Lista')>
	<cflocation url="MIGDireccion.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
	<cfquery name="rsValida" datasource="#session.dsn#">
		select rtrim(MIGDcodigo) as MIGDcodigo
		from MIGDireccion
		where MIGDcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.MIGDcodigo)#">
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfif rsValida.recordCount EQ 0>
		<cftransaction>
			<cfinvoke component="mig.Componentes.Direccion" method="Alta" returnvariable="MIGDid">
				<cfinvokeargument name="MIGDcodigo" 	value="#form.MIGDcodigo#"/>
				<cfinvokeargument name="MIGDnombre" 	value="#form.MIGDnombre#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="CodFuente" 		value="1"/>
			</cfinvoke>	
		</cftransaction>
	<cfelse>
		<cfthrow type="toUser" message="El Código de Dirección #rsValida.MIGDcodigo# ya existe en Sistema.">
	</cfif>

<cfset modo='CAMBIO'>
<cflocation url="MIGDireccion.cfm?MIGDid=#MIGDid#&modo=#modo#&Tab=1">
</cfif>
<cfif isdefined ('form.CAMBIO')>

	<cftransaction>
		<cfinvoke component="mig.Componentes.Direccion" method="Cambio" >
			<cfinvokeargument name="MIGDnombre" 	value="#form.MIGDnombre#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="MIGDid" 		value="#form.MIGDid#"/>
		</cfinvoke>	
	</cftransaction>
<cfset modo='CAMBIO'>
<cflocation url="MIGDireccion.cfm?MIGDid=#form.MIGDid#&modo=#modo#&Tab=1">
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Direccion" method="Baja" >
			<cfinvokeargument name="MIGDid" 		value="#form.MIGDid#"/>
		</cfinvoke>	
	</cftransaction>
<cflocation url="MIGDireccion.cfm?Tab=1">
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="MIGDireccion.cfm?Nuevo&Tab=1">
</cfif>
<cfif isdefined ('form.MIGSDid') >
	<cfset modo='CAMBIO'>
	<cflocation url="MIGDireccion.cfm?MIGDid=#form.MIGDid#&modo=#modo#&Tab=2">
</cfif>