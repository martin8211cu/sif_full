<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBmotivoBloqueo">

	<cffunction name="Cambio" output="false" returntype="void" access="remote">
	  <cfargument name="MBmotivo" type="string" required="Yes"  displayname="Motivo">
	  <cfargument name="MBdescripcion" type="string" required="Yes"  displayname="Descripción">
	  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">
	  <cfargument name="MBconCompromiso" type="boolean" required="no" default="0" displayname="conCompromiso">
	  <cfargument name="MBsinCompromiso" type="boolean" required="no" default="0" displayname="sinCompromiso">    
	  <cfargument name="MBautogestion" type="boolean" required="no" default="0" displayname="autogestion">	  
	  <cfargument name="MBdesbloqueable" type="boolean" required="no" default="0" displayname="Desbloqueable">
	  <cfargument name="MBagente" type="boolean" required="no" default="0" displayname="Utilizar en Procesos de Agentes (Habilitación/Inhabilitación">
	  <cfargument name="MBbloqueable" type="boolean" required="no" default="0" displayname="Bloqueable">	  
	  <cfargument name="ts_rversion" type="string" required="no"  displayname="ts_rversion">

		<cfif isdefined('Arguments.ts_rversion') and len(trim(Arguments.ts_rversion))>
			<cf_dbtimestamp datasource="#session.dsn#"
							table="ISBmotivoBloqueo"
							redirect="metadata.code.cfm"
							timestamp="#Arguments.ts_rversion#"
							field1="MBmotivo"
							type1="char"
							value1="#Arguments.MBmotivo#">
		</cfif>
					
		<cfquery datasource="#session.dsn#">
			update ISBmotivoBloqueo set 
				MBdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MBdescripcion#">
				, Habilitado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Habilitado#">
				, MBconCompromiso = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MBconCompromiso#">
				, MBsinCompromiso = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MBsinCompromiso#">
				, MBautogestion = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MBautogestion#">
				, MBdesbloqueable = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MBdesbloqueable#">
				, MBbloqueable = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MBbloqueable#">	
				, MBagente = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MBagente#">				
				, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where MBmotivo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MBmotivo#" null="#Len(Arguments.MBmotivo) Is 0#">
		</cfquery>
	</cffunction>
	
	<cffunction name="Baja" output="false" returntype="void" access="remote">
	  <cfargument name="MBmotivo" type="string" required="Yes"  displayname="Motivo">
	  
		<cfquery datasource="#session.dsn#">
			update ISBmotivoBloqueo
				set Habilitado=2
					, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where MBmotivo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MBmotivo#" null="#Len(Arguments.MBmotivo) Is 0#">
		</cfquery>
	</cffunction>
	
	<cffunction name="Alta" output="false" returntype="void" access="remote">
	  <cfargument name="MBmotivo" type="string" required="Yes"  displayname="Motivo">
	  <cfargument name="MBdescripcion" type="string" required="Yes"  displayname="Descripción">
	  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">
	  <cfargument name="MBconCompromiso" type="boolean" required="no" default="0" displayname="conCompromiso">
	  <cfargument name="MBsinCompromiso" type="boolean" required="no" default="0" displayname="sinCompromiso">    
	  <cfargument name="MBautogestion" type="boolean" required="no" default="0" displayname="autogestion">	
	  <cfargument name="MBdesbloqueable" type="boolean" required="no" default="0" displayname="Desbloqueable">	
	  <cfargument name="MBagente" type="boolean" required="no" default="0" displayname="Utilizar en Procesos de Agentes (Habilitación/Inhabilitación">
	  <cfargument name="MBbloqueable" type="boolean" required="no" default="0" displayname="Bloqueable">		  
	
		<cfquery datasource="#session.dsn#" name="rsBusca">
			Select count(1) as cant
			from ISBmotivoBloqueo
			where MBmotivo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MBmotivo#">
		</cfquery>
	
		<cfif isdefined('rsBusca') and rsBusca.cant GT 0>
			<cfthrow message="Error, el c&oacute;digo digitado ya existe, favor digitar uno diferente">
		<cfelse>
			<cfquery datasource="#session.dsn#">
				insert INTO ISBmotivoBloqueo 
					(MBmotivo, Ecodigo, MBdescripcion, Habilitado, MBconCompromiso, MBsinCompromiso, MBautogestion,
					 MBdesbloqueable, MBbloqueable, MBagente, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MBmotivo#">
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MBdescripcion#">
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Habilitado#">
					, <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MBconCompromiso#">
					, <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MBsinCompromiso#">
					, <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MBautogestion#">
					, <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MBdesbloqueable#">
					, <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MBbloqueable#">
					, <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MBagente#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
			</cfquery>
		</cfif>
	</cffunction>

</cfcomponent>

