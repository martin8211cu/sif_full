<cfif isdefined ('form.Lista')>
	<cflocation url="Segmento.cfm">
</cfif>
<cfif isdefined ('form.Importar')>
	<cflocation url="SegmentoImportador.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
	<cfquery name="rsValida" datasource="#session.dsn#">
		select rtrim(MIGProSegcodigo) as MIGProSegcodigo
		from MIGProSegmentos
		where MIGProSegcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.MIGProSegcodigo)#">
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfif rsValida.recordCount eq 0>	
		<cftransaction>
			<cfinvoke component="mig.Componentes.Segmento" method="Alta" returnvariable="MIGProSegmentos">
				<cfinvokeargument name="MIGProSegcodigo" 	value="#form.MIGProSegcodigo#"/>
				<cfinvokeargument name="MIGProSegdescripcion" 	value="#form.MIGProSegdescripcion#"/>
				<cfinvokeargument name="Dactiva" 		value="1"/>
				<cfinvokeargument name="CodFuente" 		value="1"/>
			</cfinvoke>	
		</cftransaction>
	<cfelse>
		<cfthrow type="toUser" message="El Código #rsValida.MIGProSegcodigo# ya existe en Sistema.">
	</cfif>
</cfif>
<cfif isdefined ('form.CAMBIO')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Segmento" method="Cambio" >
			<cfinvokeargument name="MIGProSegdescripcion" 	value="#form.MIGProSegdescripcion#"/>
			<cfinvokeargument name="MIGProSegid" 		value="#form.MIGProSegid#"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.BAJA')>
	<cfquery name="rsValida" datasource="#session.dsn#">
		select 
				a.MIGProSegid,
				a.MIGProSegcodigo,
				b.MIGProcodigo as L1
		from  MIGProSegmentos a
			inner join MIGProductos b
				on a.MIGProSegid=b.MIGProSegid
		where a.MIGProSegid=#form.MIGProSegid#
		and a.Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfquery name="rsValida2" datasource="#session.dsn#">
		select 
				a.MIGProSegid,
				a.MIGProSegcodigo,
				c.MIGProcodigo as L2
		from  MIGProSegmentos a
			inner join MIGProductos c
				on a.MIGProSegid=c.MIGProSegid2
		where a.MIGProSegid=#form.MIGProSegid#
		and a.Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfquery name="rsValida3" datasource="#session.dsn#">
		select 
				a.MIGProSegid,
				a.MIGProSegcodigo,
				d.MIGProcodigo as L3
		from  MIGProSegmentos a
			inner join MIGProductos d
				on a.MIGProSegid=d.MIGProSegid3
		where a.MIGProSegid=#form.MIGProSegid#
		and a.Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfif rsValida.recordCount GT 0 or rsValida2.recordCount GT 0 or rsValida3.recordCount GT 0>	
		<cfthrow type="toUser" message="El segmento #rsValida.MIGProSegcodigo# no puede ser eliminado ya que tiene asociaciones con Productos">
	<cfelse>
		<cftransaction>
			<cfinvoke component="mig.Componentes.Segmento" method="Baja" >
				<cfinvokeargument name="MIGProSegid" 		value="#form.MIGProSegid#"/>
			</cfinvoke>	
		</cftransaction>
	</cfif>
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="Segmento.cfm">
</cfif>
<cflocation url="Segmento.cfm">
