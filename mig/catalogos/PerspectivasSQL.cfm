<cfif isdefined ('form.Lista')>
	<cflocation url="Perspectivas.cfm">
</cfif>
<cfif isdefined ('form.Importar')>
	<cflocation url="PerspectivasImportador.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
<cfquery name="rsValida" datasource="#session.dsn#">
	select rtrim(MIGPercodigo) as MIGPercodigo
	from MIGPerspectiva
	where MIGPercodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.MIGPercodigo)#">
	and Ecodigo=#session.Ecodigo#
</cfquery>
	<cfif rsValida.recordCount eq 0>	
			<cftransaction>
				<cfinvoke component="mig.Componentes.Perspectivas" method="Alta" returnvariable="MIGPerid">
					<cfinvokeargument name="MIGPercodigo" 	value="#form.MIGPercodigo#"/>
					<cfinvokeargument name="MIGPerdescripcion" 	value="#form.MIGPerdescripcion#"/>
					<cfinvokeargument name="Dactiva" 		value="1"/>
					<cfinvokeargument name="CodFuente" 		value="1"/>
				</cfinvoke>	
			</cftransaction>
	<cfelse>
		<cfthrow type="toUser" message="El Código de #rsValida.MIGPercodigo# ya existe en Sistema.">
	</cfif>
</cfif>
<cfif isdefined ('form.CAMBIO')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Perspectivas" method="Cambio" >
			<cfinvokeargument name="MIGPerdescripcion" 	value="#form.MIGPerdescripcion#"/>
			<cfinvokeargument name="MIGPerid" 		value="#form.MIGPerid#"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.BAJA')>
	<cfquery name="rsValida" datasource="#session.dsn#">
		select a.MIGPerid,a.MIGPercodigo,b.MIGMcodigo
		from  MIGPerspectiva a
			inner join MIGMetricas b
				on a.MIGPerid=b.MIGPerid
		where a.MIGPerid=#form.MIGPerid#
		and a.Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfif rsValida.recordCount EQ 0>	
		<cftransaction>
			<cfinvoke component="mig.Componentes.Perspectivas" method="Baja" >
				<cfinvokeargument name="MIGPerid" 		value="#form.MIGPerid#"/>
			</cfinvoke>	
		</cftransaction>
	<cfelse>
		<cfthrow type="toUser" message="La Perspectiva #rsValida.MIGPercodigo# no puede ser eliminada ya que tiene asociaciones con Indicadores.">
	</cfif>
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="Perspectivas.cfm">
</cfif>
<cflocation url="Perspectivas.cfm">
