<cfset LvarIrAlistECP="listaEstadosCuentaEnProceso.cfm">
<cfif isdefined("LvarTCEConciliaApply")>
 	<cfset LvarIrAlistECP="listaEstadosCuentaProcesoTCE.cfm">
</cfif>


	<!---
	<CFSTOREDPROC procedure="dbo.MB_ConciliacionBancaria" datasource="#Session.DSN#" returncode="yes">
		<cfprocresult name="rsConc">
		<cfprocparam cfsqltype="cf_sql_integer" dbvarname="@Ecodigo" value="#Session.Ecodigo#" type="in">
		<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@ECid" type="in" value="#Form.ECid#" >
		<cfprocparam cfsqltype="cf_sql_char" dbvarname="@Preconciliar" value="N" type="in">
		<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@usuario" value="#Session.usuario#" type="in">  
		<cfprocparam cfsqltype="cf_sql_char" dbvarname="@debug" value="N" type="in">  
	</CFSTOREDPROC>
	<cfset statusCode = CFSTOREDPROC.StatusCode>
	<cfif statusCode EQ -1>
		<cf_errorCode	code = "50411" msg = "No se pudo realizar la Conciliación! Proceso Cancelado!">
	</cfif>	
	--->

	<cftry>
		<cfinvoke 
			component="sif.Componentes.MB_ConciliacionBancaria"
			method="ConciliacionBancaria"
			returnvariable="LvarResult">
			<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
			<cfinvokeargument name="ECid" value="#Form.ECid#"/>
			<cfinvokeargument name="preconciliar" value="false"/>
			<cfinvokeargument name="debug" value="false"/>
			<cfinvokeargument name="usuario" value="#Session.Usuario#"/>
			<cfinvokeargument name="conexion" value="#Session.DSN#"/>
		</cfinvoke> 	

		<cfcatch type="any">
			<!--- <cf_dump var="#cfcatch#"> --->
			<!--- <cfif isdefined("cfcatch.Message")>
                <cfset Mensaje="#cfcatch.Message#">
            <cfelse>
                <cfset Mensaje="">
            </cfif>

 --->
			<cfif isdefined("cfcatch.Message")>
                <cfset Mensaje="#cfcatch.Message#">
            <cfelse>
                <cfset Mensaje="">
            </cfif>
            <cfif isdefined("cfcatch.Detail")>
                <cfset Detalle="#cfcatch.Detail#">
            <cfelse>
                <cfset Detalle="">
            </cfif>
            <cfif isdefined("cfcatch.sql")>
                <cfset SQL="#cfcatch.sql#">
            <cfelse>
                <cfset SQL="">
            </cfif>
            <cfif isdefined("cfcatch.where")>
                <cfset PARAM="#cfcatch.where#">
            <cfelse>
                <cfset PARAM="">
            </cfif>
            <cfif isdefined("cfcatch.StackTrace")>
                <cfset PILA="#cfcatch.StackTrace#">
            <cfelse>
                <cfset PILA="">
            </cfif>
			<cfthrow message=" Problema al Aplicar la Conciliacion-Apply-Lin-62 : #Mensaje#.  #Detalle#  #SQL#  #PARAM#">
		</cfcatch>
	</cftry>
<cftry>
	<!--- JARR  Se valida el numero de Registros del EC vs los movimientos de Bancos --->
	<cfquery name="valMovEC_CDL_CDB" datasource="#Session.DSN#">
	select 
		case when (
			(
				SELECT 
				 count(*) as ECmov
				from DCuentaBancaria edc
				where ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
				and Ecodigo =#Session.Ecodigo# 
			)=
			(
				SELECT count(*) as CDBmov
				from CDBancos
				where CDBconciliado like 'S'
				and Ecodigo =#Session.Ecodigo# 
				and ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
			)
		)
		then 
			 1	
		else 0
		end as balED
	</cfquery>

	<!--- JARR Si los mov del Estado de Cuenta estan todos conciliados se pasa al estatus S si no queda pendiente--->
	<!--- 
			EChistorico = 'S' Conciliado
			EChistorico = 'N' NO Conciliado
			EChistorico = 'P' Pendiente faltan movimientos por conciliar
	 --->
	<cfif isdefined("valMovEC_CDL_CDB.balED") and valMovEC_CDL_CDB.balED EQ	 1>
		<cfquery name="updEstado" datasource="#Session.DSN#">
			update ECuentaBancaria set EChistorico = 'S' 
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		</cfquery>
	<cfelse>
		<cfquery name="updEstado" datasource="#Session.DSN#">
			update ECuentaBancaria set EChistorico = 'P' 
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		</cfquery>
	</cfif>
	<cfcatch type="any">
		<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('ERROR! No se pudo realizar la Conciliación! Proceso Cancelado!')#" addtoken="no">	 
	</cfcatch>
</cftry> 
												
<cflocation addtoken="no" url="#LvarIrAlistECP#">


