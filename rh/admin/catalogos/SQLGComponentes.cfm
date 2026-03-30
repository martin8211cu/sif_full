<!---
	Fecha de Creación: 21 de Abril del 2004
	Creado por: Dorian Abarca Gómez

	SQL de Tabla "Agrupamiento de Componentes"

			+RHComponentesAgrupados
				(
				RHCAcodigo char(5)
				RHCAdescripcion varchar(80)

				RHCAid numeric identity
				Ecodigo
				ts_rversion
				)
--->
<!--- Parámetros Requeridos --->
<cfif isdefined("Form.Cambio") or isdefined("Form.Baja")>
	<cfparam name="Form.RHCAid" type="numeric">
</cfif>
<cfparam name="Form.RHCAcodigo" type="string">
<cfparam name="Form.RHCAdescripcion" type="string">
<!--- Parámetros Locales --->
<cfparam name="DEBUG" type="boolean" default="false">

<cfinvoke key="LB_Existen_componentes_asociados_a_este_grupo_de_componentes_salariales." default="Existen componentes asociados a este grupo de componentes salariales. " returnvariable="LB_ErrorCompS" component="sif.Componentes.Translate" method="Translate"/>
<!--- Parámetros que realizan una Acción, cuando viene alguno de estos parámetros se realiza una acción exclusiva
	en el orden en que se encuentre, es decir, si viene uno los otros, no se toma en cuenta.
	Parámetros que realizan una Acción:
		Alta	: Alta de un Registro.
		Cambio	: Cambio de un Registro.
		Baja	: Baja de un Registro.
 --->
<!--- Consulta que realiza las Acciones --->
<cftransaction>
	<cfif isdefined("Form.Alta")>
		<cfquery name="ABC_RHCAInsert" datasource="#Session.DSN#">
			insert into RHComponentesAgrupados
			(RHCAcodigo,RHCAdescripcion,RHCAorden,RHCAmComponenteExclu,Ecodigo,RHCAmExcluyeSB)
			values(
			<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHCAcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCAdescripcion#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCAorden#">,
			<cfif isdefined("Form.RHCAmComponenteExclu")>1<cfelse>0</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.RHCAmExcluyeSB')#">)
			<cf_dbidentity1 datasource="asp">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="ABC_RHCAInsert">
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="RHComponentesAgrupados"
			redirect="formGComponentes.cfm"
			timestamp="#form.ts_rversion#"
			field1="RHCAid" type1="numeric" value1="#Form.RHCAid#">

		<cfquery name="ABC_RHCAUpdate" datasource="#Session.DSN#">
			update RHComponentesAgrupados
			set RHCAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHCAcodigo#">,
				RHCAdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCAdescripcion#">,
				RHCAorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCAorden#">,
				RHCAmComponenteExclu = <cfif isdefined("Form.RHCAmComponenteExclu")>1<cfelse>0</cfif>,
				RHCAmExcluyeSB = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.RHCAmExcluyeSB')#">
			where RHCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCAid#">
		</cfquery>
	<cfelseif isdefined("Form.Baja")>
		<cftry>

			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
						<cfinvokeargument  name="nombreTabla" value="RHComponentesAgrupados">
						<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
						<cfinvokeargument name="condicion" value="RHCAid = #Form.RHCAid#">
						<cfinvokeargument name="necesitaTransaccion" value="false">
			</cfinvoke>

			<cfquery name="ABC_RHCADelete" datasource="#Session.DSN#">
				delete from RHComponentesAgrupados
				where RHCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCAid#">
			</cfquery>
			<cfcatch type="any">
				<cf_throw message="#LB_ErrorCompS#" errorcode="68">
			 </cfcatch>
		</cftry>
	</cfif>
</cftransaction>
<!--- Consulta para debuguear --->
<cfif DEBUG>
	<cfif not isdefined("ABC_RHCA")>
		No se realizó ninguna acción.
	<cfelse>
		<cfquery name="rs" datasource="#Session.DSN#">
			select *
			from RHComponentesAgrupados
			where RHCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ABC_RHCA.RHCAid#">
		</cfquery>
	</cfif>
	<cfabort>
</cfif>
<!--- Envia a la pantalla --->
<cfif isdefined("Form.Cambio")>
	<cflocation url="GComponentes.cfm?RHCAid=#Form.RHCAid#&PAGENUM=#Form.PAGENUM#">
<cfelse>
	<cflocation url="GComponentes.cfm">
</cfif>