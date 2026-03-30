<cfparam name="FORM.RHEEID" type="numeric">
<cfparam name="FORM.CHK" type="string" default="">
<cfset LISTACHK = ListToArray(FORM.CHK)>
<cftry>
	<cfif isdefined("FORM.BTNELIMINAR") and FORM.BTNELIMINAR eq 1>
			<cfloop from="1" to="#ArrayLen(LISTACHK)#" index="i">
				<cfquery name="ABC_ELIM_MASIVO" datasource="#SESSION.DSN#">
					delete from RHDEvaluacionDes
					where RHDEvaluacionDes.RHEEid    =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#">
					and   RHDEvaluacionDes.DEid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LISTACHK[i]#">
					and exists (
						select 1 from RHListaEvalDes b, RHEEvaluacionDes a
							where a.RHEEid = RHDEvaluacionDes.RHEEid
							and a.Ecodigo = #SESSION.Ecodigo#
							and a.RHEEestado < 3
							and RHDEvaluacionDes.DEid = b.DEid
							and RHDEvaluacionDes.RHEEid = b.RHEEid
							and b.RHEEid = a.RHEEid)
				</cfquery>
				<cfquery name="ABC_ELIM_MASIVO" datasource="#SESSION.DSN#">
					delete from RHNotasEvalDes
					where RHNotasEvalDes.RHEEid    =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#">
					and   RHNotasEvalDes.DEid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LISTACHK[i]#">
					and exists (
						select 1 from RHListaEvalDes b, RHEEvaluacionDes a
							where a.RHEEid = RHNotasEvalDes.RHEEid
							and a.Ecodigo = #SESSION.Ecodigo#
							and a.RHEEestado < 3
							and RHNotasEvalDes.DEid = b.DEid
							and RHNotasEvalDes.RHEEid = b.RHEEid
							and b.RHEEid = a.RHEEid)
				</cfquery>
				<cfquery name="ABC_ELIM_MASIVO" datasource="#SESSION.DSN#">
					delete from RHEvaluadoresDes
					where RHEvaluadoresDes.RHEEid    =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#">
					and   RHEvaluadoresDes.DEid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LISTACHK[i]#">
					and exists (
						select 1 from RHListaEvalDes b, RHEEvaluacionDes a
							where a.RHEEid = RHEvaluadoresDes.RHEEid
							and a.Ecodigo = #SESSION.Ecodigo#
							and a.RHEEestado < 3
							and RHEvaluadoresDes.DEid = b.DEid
							and RHEvaluadoresDes.RHEEid = b.RHEEid
							and b.RHEEid = a.RHEEid)
				</cfquery>
				<cfquery name="ABC_ELIM_MASIVO" datasource="#SESSION.DSN#">
					delete from RHListaEvalDes
					where RHListaEvalDes.RHEEid    =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#">
					and   RHListaEvalDes.DEid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LISTACHK[i]#">
					and exists (
						select 1 from RHEEvaluacionDes a
							where a.RHEEid = RHListaEvalDes.RHEEid
							and a.Ecodigo = #SESSION.Ecodigo#
							and a.RHEEestado < 3)
				</cfquery>
				<cfquery name="ABC_update" datasource="#SESSION.DSN#">
					update PortalCuestionarioU 
					set PCUestado = 0,
						BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LISTACHK[i]#">
					and PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#"> 
				</cfquery>
			</cfloop>
	<cfelseif isdefined("FORM.BTNGENERAREMPL") and FORM.BTNGENERAREMPL eq 1>
		<!--- Dentro está contemplado esta ejecución especial del proceso de generación --->
		<cfinclude template="registro_criterios_empleados_sql.cfm">
	<cfelseif isdefined("FORM.BTNGENERAREMPLS") and FORM.BTNGENERAREMPLS eq 1>
		<cfset FORM.DEIDLIST = FORM.CHK>
		<!--- Dentro está contemplado esta ejecución especial del proceso de generación --->
		<cfinclude template="registro_criterios_empleados_sql.cfm">
	</cfif>
<cfcatch>
	<cfinclude template="../../../sif/errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>
<cflocation url="registro_evaluacion.cfm?RHEEid=#FORM.RHEEID#&SEL=3">