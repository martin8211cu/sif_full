<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 04 de julio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Reimpresión de cheques
----------->
<cfif isdefined('url.TESCFLid') and LEN(url.TESCFLid) GT 0>
	<cfset form.TESCFLid = url.TESCFLid>
</cfif>
<cfif isdefined('url.btnNuevo')>
	<cfset form.btnNuevo = url.btnNuevo>
</cfif>

<cf_templateheader title="Reimpresi&oacute;n de Cheques">
	<cf_navegacion name="TESOPid">
	<cfset navegacion = "">
	<cfset tipoCheque = '= 1'>
	<cfset form.reimpresion = 1>
	<cfset reimpresion = 1>
	<cfset titulo = 'Reimpresi&oacute;n de Cheques'>
	<cfset modo = 'ALTA'>
	<cfif isdefined("form.TESCFDnumFormulario") and LEN(form.TESCFDnumFormulario) 
		or isdefined('form.TESCFLid') and LEN(form.TESCFLid) GT 0
		or isdefined('form.btnNuevo')>
		<cfinclude template="impresionCheques_form.cfm">
	<cfelse>
		<cfif not isdefined("session.Tesoreria.TESid")>
			<cfinclude template="../../Solicitudes/TESid_Ecodigo.cfm">
		</cfif>
		<!--- VERIFICA Q NO HAYAN LOTES DE REIMPRESION EN PROCESO QUE NO SEAN DEL DIA PARA ELIMINARLOS --->
		<cfquery name="rsLotes" datasource="#session.DSN#">
			select TESCFLid, TESCFLestado, CBid, TESMPcodigo, TESCFTnumInicial
			  from TEScontrolFormulariosL
			 where TESid = #session.Tesoreria.TESid#
			   and TESCFLtipo = 'R'
			   and TESCFLestado <= 2
			   and <cf_dbfunction name="date_format" args="TESCFLfecha,YYYYMMDD"> <> '#DateFormat(now(),"YYYYMMDD")#'
		</cfquery>
		<cftransaction>
		<cfloop query="rsLotes">
			<cfset LvarLotesBorrados = true>
			<!--- Libera el bloque de formularios --->
			<cfif rsLotes.TESCFLestado NEQ "0">
				<cfquery datasource="#session.dsn#">
					update TEScontrolFormulariosT
					   set TESCFTimprimiendo = 0
					 where TESid			= #session.Tesoreria.TESid#
					   and CBid				= #rsLotes.CBid#
					   and TESMPcodigo		= '#rsLotes.TESMPcodigo#'
					   and TESCFTnumInicial	= #rsLotes.TESCFTnumInicial#
				</cfquery>
			</cfif>

			<!--- Se desligan del lote los cheques originales --->
			<cfquery datasource="#session.dsn#">
				update TEScontrolFormulariosD
				   set TESCFLidReimpresion = null
				 where TESCFLidReimpresion	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotes.TESCFLid#">
				   and TESid	= #session.Tesoreria.TESid#
			</cfquery>
	
			<!--- Se separan del lote los formularios anulados (para que permanezcan) --->
			<cfquery datasource="#session.dsn#">
				update TEScontrolFormulariosD
				   set TESCFLid	= NULL
				 where TESid			= #session.Tesoreria.TESid#
				   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotes.TESCFLid#">
				   and TESCFDestado		= 3
			</cfquery>
	
			<!--- Se borran los documentos no impresos del lote --->
			<cfquery datasource="#session.dsn#">
				delete from TEScontrolFormulariosD
				 where TESid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				   and TESCFLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotes.TESCFLid#">
				   and TESCFDestado	= 0
			</cfquery>
	
			<!--- Se borra el lote --->
			<cfquery datasource="#session.dsn#">
				delete from TEScontrolFormulariosL
				 where TESid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				   and TESCFLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLotes.TESCFLid#">
			</cfquery>
		</cfloop>
		</cftransaction>

		<cfif isdefined("LvarLotesBorrados")>
			<script language="javascript">
				alert ("Se eliminaron Lotes de Reimpresion de Cheques que quedaron pendientes de otro dia\n\n  - (No se permite Reimprimir Cheques emitidos otro día)\n  - (Debe Anular y Emitir nuevos Cheques para las Órdenes de Pago correspondientes a los formularios anulados)");
			</script>
		</cfif>

		<!--- VERIFICA Q NO HAYAN LOTES DE REIMPRESION EN PROCESO --->
		<cfquery name="rsConsultaL" datasource="#session.DSN#">
			select 1
			from TEScontrolFormulariosL
			where TESid = #session.Tesoreria.TESid#
			  and TESCFLtipo = 'R'
			  and TESCFLestado <= 2
		</cfquery>
		<cfif isdefined('rsConsultaL') and rsConsultaL.RecordCount GT 0>
			<cfinclude template="reimpresionCheques_lotes.cfm">
		<cfelse>
			<cfoutput>
			<cfset irA_filtro = 'reimpresionCheques.cfm'>
			<cfset irA = 'impresionCheques_sql.cfm?Reimpresion=1'>
			<cfinclude template="listaCheques.cfm">
			</cfoutput>
		</cfif>
	</cfif>
<cf_templatefooter>