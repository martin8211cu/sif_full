<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_LaRetencionYaHaSidoAsociada"
	Default="La retenci&oacute;n ya ha sido asociada"
	returnvariable="MSG_LaRetencionYaHaSidoAsociada"/>	
<cfparam name="modo" default="ALTA">
<cfif not isdefined('form.Nuevo')>
	<cfif isdefined('form.Alta')>
		<cfquery name="ConsultaDed" datasource="#session.DSN#">
			select 1
			from RHDeduccionesReb
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	   		  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
			  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">  
		</cfquery>
		<cfif ConsultaDed.RecordCount GT 0>
			<cf_throw message="#MSG_LaRetencionYaHaSidoAsociada#" errorcode="2010">
		</cfif>
		<cftransaction>
			<cfquery name="InsertRetencion" datasource="#session.DSN#">
				insert into RHDeduccionesReb(CIid,
											 TDid,
											 Ecodigo,
											 Descripcion,
											 SNcodigo,
											 Porcentaje,
											 BMfechaalta,
											 BMUsucodigo)	
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">,
		   			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">,
		   			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		   			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">,
		   			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">,
		   			<cfqueryparam cfsqltype="cf_sql_float" value="#form.Porcentaje#">,
		   			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
			</cfquery>
		</cftransaction>
		<cfset modo = 'CAMBIO'>
	<cfelseif isdefined('form.Cambio')>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="RHDeduccionesReb" 
			redirect="Retenciones.cfm"
			timestamp="#form.ts_rversion#"
			field1="CIid,numeric,#form.CIid#"
			field2="TDid,numeric,#form.TDid#">
		<cftransaction>
			<cfquery name="UpdateRetencion" datasource="#session.DSN#">
				update RHDeduccionesReb
				set Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">,
		   			SNcodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">,
		   			Porcentaje	= <cfqueryparam cfsqltype="cf_sql_float" value="#form.Porcentaje#">
		   		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   		  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
		   		  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
			</cfquery>
		</cftransaction>
		<cfset modo = 'CAMBIO'>
	<cfelseif isdefined('form.Baja')>
		<cfquery name="rsExisteDeduc" datasource="#session.DSN#">
			select count(1) as cantidad
			from DeduccionesEmpleado
	   		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	   		  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
	   		  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
		</cfquery>
		<cfif rsExisteDeduc.cantidad gt 0>
			<cfthrow message="No se puede eliminar la retención ya que esta esta siendo utilizada en el cálculo de nómina. Proceso Cancelado!!!">
		</cfif>
		<cfquery name="rsDeleteRetencion" datasource="#session.DSN#">
			delete from RHDeduccionesReb
	   		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	   		  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
	   		  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
		</cfquery>
		<cfset modo = 'ALTA'>
	</cfif>
</cfif>
<cflocation url="Retenciones.cfm?CIid=#form.CIid#">
