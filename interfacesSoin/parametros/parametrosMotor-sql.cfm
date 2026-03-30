<cfquery name="rsCE" datasource="asp">
	select CEaliaslogin
	from CuentaEmpresarial
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
</cfquery>
<cfset Request.CEnombre = rsCE.CEAliaslogin>
<cfif isdefined("form.Activar") OR isdefined("form.Cambiar")>
	<cfquery datasource="sifinterfaces">
		update InterfazMotor
			set urlServidorMotor = '#form.urlServidorMotor#'
			  , spFinalTipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.spFinalTipo#">
			  , spFinal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.spFinal#">
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
	</cfquery>
	<cfset fnBitacora()>
</cfif>
<cfif isdefined("form.CambiarLog")>
	<cfset fnBitacora()>
<cfelseif isdefined("form.Activar")>
	<cftry>
		<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
		<cfset StructDelete(Application.interfazSoin,"CE_#session.CEcodigo#")>
		<cfset rsMotor = LobjColaProcesos.fnActivarMotor (session.CEcodigo, form.UrlServidorMotor, true)>
		<cfquery datasource="sifinterfaces">
			update InterfazMotor
				set Activo = 1, MsgError = null
				<cfif find('/localhost:0/',form.UrlServidorMotor) EQ 0>
					 , urlServidorMotor = '#rsMotor.urlServidorMotor#'
				</cfif>
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
		</cfquery>
		<cfset fnBitacora()>
		<cfif trim(form.spFinal) EQ "">
			<cfquery datasource="sifinterfaces">
				update Interfaz
					set spFinalTipo = 'N'
					  , spFinal 	= null
				  where spFinalTipo = 'D'
				<!--- where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#"> --->
			</cfquery>
		</cfif>
	<cfcatch>
		<cfquery datasource="sifinterfaces">
			update InterfazMotor
				set urlServidorMotor = '#trim(form.UrlServidorMotor)#'
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
		</cfquery>
	</cfcatch>
	</cftry>

<cfelseif isdefined("form.Inactivar")>
	<cfquery datasource="sifinterfaces">
		update InterfazMotor
			set Activo = 0
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
	</cfquery>
	<cfschedule action		= "delete"
				task		= "Tarea Asincrona Motor Interfaces CE=#session.CEcodigo#" 
	>
	<cfif isdefined("Application.interfazSoin.CE_#session.CEcodigo#")>
		<cfset structDelete(Application.interfazSoin,"CE_#session.CEcodigo#",false)>
	</cfif>
</cfif>

<cflocation url="parametrosMotor.cfm">

<cffunction name="fnBitacora">
	<cfparam name="form.Bitacora_S_AP" default="0">
	<cfparam name="form.Bitacora_S_FP" default="0">
	<cfparam name="form.Bitacora_S_DE" default="0">
	
	<cfparam name="form.Bitacora_D_AP" default="0">
	<cfparam name="form.Bitacora_D_FP" default="0">
	<cfparam name="form.Bitacora_D_DE" default="0">
	
	<cfparam name="form.Bitacora_A_IP" default="0">
	<cfparam name="form.Bitacora_A_AT" default="0">
	<cfparam name="form.Bitacora_A_AI" default="0">
	<cfparam name="form.Bitacora_A_AP" default="0">
	<cfparam name="form.Bitacora_A_FP" default="0">
	<cfparam name="form.Bitacora_A_DE" default="0">

	<cfquery datasource="sifinterfaces">
		update InterfazMotor
			set Bitacora_S_AP = #Bitacora_S_AP#
			  , Bitacora_S_FP = #Bitacora_S_FP#
			  , Bitacora_S_DE = #Bitacora_S_DE#
			
			  , Bitacora_D_AP = #Bitacora_D_AP#
			  , Bitacora_D_FP = #Bitacora_D_FP#
			  , Bitacora_D_DE = #Bitacora_D_DE#
			
			  , Bitacora_A_IP = #Bitacora_A_IP#
			  , Bitacora_A_AT = #Bitacora_A_AT#
			  , Bitacora_A_AI = #Bitacora_A_AI#
			  , Bitacora_A_AP = #Bitacora_A_AP#
			  , Bitacora_A_FP = #Bitacora_A_FP#
			  , Bitacora_A_DE = #Bitacora_A_DE#
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
	</cfquery>
	
</cffunction>