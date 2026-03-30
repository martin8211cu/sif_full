<cfif isdefined ('form.Lista')>
	<cflocation url="Estrategia.cfm">
</cfif>

<cfif isdefined ('form.Importar')>
	<cflocation url="EstrategiaImportar.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Estrategia" method="Alta" returnvariable="MIGEstid">
			<cfinvokeargument name="MIGEstcodigo" 	value="#form.MIGEstcodigo#"/>
			<cfinvokeargument name="MIGEstdescripcion" 	value="#form.MIGEstdescripcion#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="CodFuente" 		value="1"/>
		</cfinvoke>
	</cftransaction>
</cfif>
<cfif isdefined ('form.CAMBIO')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Estrategia" method="Cambio" >
			<cfinvokeargument name="MIGEstdescripcion" 	value="#form.MIGEstdescripcion#"/>
			<cfinvokeargument name="MIGEstid" 		value="#form.MIGEstid#"/>
		</cfinvoke>
	</cftransaction>
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Estrategia" method="Baja" >
			<cfinvokeargument name="MIGEstid" 		value="#form.MIGEstid#"/>
		</cfinvoke>
	</cftransaction>
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="Estrategia.cfm">
</cfif>
<cflocation url="Estrategia.cfm">
