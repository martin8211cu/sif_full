<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_LaClaseQueDeseaDefinirYaExiste" Default="La clase que se desea definir ya existe." returnvariable="MSG_LaClaseQueDeseaDefinirYaExiste" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfset params = '?RHCAid=#form.RHCAid#&CSid=#form.CSid#&PAGENUM=#form.PAGENUM#&PAGENUMPADRE=#form.PAGENUMPADRE#'>
<cfif isdefined('form.Alta')>
	<cftransaction>
		<!--- AGREGA UNA NUEVA REGLA --->
		<cfquery name="insertRegla" datasource="#session.DSN#">
			insert into EReglaComponente(Ecodigo,CSid,ERCclase,BMUsucodigo,BMfechaAlta)
			values(<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ERCclase#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
			<cf_dbidentity1 datasource="#Session.DSN#">
		</cfquery>
		<cf_dbidentity2 name="insertRegla" datasource="#Session.DSN#">
	</cftransaction>
	<cfset params = params& "&ERCid=#insertRegla.identity#">
<cfelseif isdefined('form.Cambio')>
	<!--- MODIFICA EL ENCABEZADO DE LA REGLA --->
	<cf_dbtimestamp
		datasource="#session.DSN#"
		table="EReglaComponente"
		redirect="formReglasComponentes.cfm"
		timestamp="#form.ts_rversion#"
		field1="ERCid" type1="numeric" value1="#Form.ERCid#">
	<cfquery name="Verif" datasource="#session.DSN#">
		select count(1) as Clases
		from EReglaComponente
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ERCid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERCid#">
		  and ERCclase =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ERCclase#">
	</cfquery>
	<cfif Verif.RecordCount GT 0 and Verif.Clases EQ 0>
		<cftransaction>
			<cfquery name="updateRegla" datasource="#session.DSN#">
				update EReglaComponente
				set ERCclase 	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ERCclase#">,
					BMUsucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMfechaModif = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and ERCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERCid#">
			</cfquery>
		</cftransaction>
	<cfelse>
		<cf_throw message="#MSG_LaClaseQueDeseaDefinirYaExiste#" errorcode="2170">
	</cfif>
	<cfset params = params& "&ERCid=#form.ERCid#">
<cfelseif isdefined('form.Baja')>
	<cftransaction>
		<!--- BORRA LA REGLA --->
		<!--- BORRA DETALLE DE  LA REGLA --->
		<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
			<cfinvokeargument  name="nombreTabla" value="DReglaComponente">		
			<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
			<cfinvokeargument name="condicion" value="ERCid = #form.ERCid#">
			<cfinvokeargument name="necesitaTransaccion" value="false">
		</cfinvoke>
		<cfquery name="deleteDetalla" datasource="#session.DSN#">
			delete from DReglaComponente
			where ERCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERCid#">
		</cfquery>
		<!--- BORRA ENCABEZADO --->
		<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
			<cfinvokeargument  name="nombreTabla" value="EReglaComponente">		
			<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
			<cfinvokeargument name="condicion" value="Ecodigo = #session.Ecodigo# and ERCid = #form.ERCid#">
			<cfinvokeargument name="necesitaTransaccion" value="false">
		</cfinvoke>
		<cfquery name="deleteRegla" datasource="#session.DSN#">
			delete from EReglaComponente
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and ERCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERCid#">
		</cfquery>
	</cftransaction>
<cfelseif isdefined('form.AgregaD')>
	<cftransaction>
		<!--- AGREGA UN NUEVO DETALLE A LA REGLA DEL COMPONENTE --->
		<cfquery name="insertDetalle" datasource="#session.DSN#">
			insert into DReglaComponente(ERCid,DRCdetalle,DRCvalor,DRCmetodo,BMUsucodigo,BMfechaAlta)
			values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERCid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DRCdetalle#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#form.DRCvalor#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.DRCmetodo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		</cfquery>
	</cftransaction>
	<cfset params = params& "&ERCid=#form.ERCid#">	
<cfelseif isdefined('form.botonSel') and form.botonSel EQ 'EliminarD'>
	<!--- ELIMINAR DETALLE DE LA REGLA --->
	<cftransaction>
		<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
			<cfinvokeargument  name="nombreTabla" value="DReglaComponente">		
			<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
			<cfinvokeargument name="condicion" value="ERCid = #form.ERCid# and DRCid = #form.DRCid#">
			<cfinvokeargument name="necesitaTransaccion" value="false">
		</cfinvoke>
		<cfquery name="deleteDetalle" datasource="#session.DSN#">
			delete from DReglaComponente
			where ERCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERCid#">
			  and DRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DRCid#">
		</cfquery>
	</cftransaction>
	<cfset params = params& "&ERCid=#form.ERCid#">
</cfif>

<cflocation url="ReglasComponentes.cfm#params#">