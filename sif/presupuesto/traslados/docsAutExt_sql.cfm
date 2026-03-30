<cfif isdefined ('form.Alta')>
	<cftransaction>
		<cfquery name="rsInsert" datasource="#session.dsn#">
			insert into CPDocumentoAE(
				Ecodigo, CPPid,
				CPDAEcodigo,
				CPDAEdescripcion,
				CPTAEid,
				CPDAEmontoCF,
				BMUsucodigo 
			)
			values(
				#session.Ecodigo# , #session.CPPid#,
				'#form.CPDAEcodigo#',
				'#form.CPDAEdescripcion#',
				#form.CPTAEid#,
				#replace(form.CPDAEmontoCF,",","","ALL")#,
				#session.Usucodigo#
			)
			<cf_dbidentity1 datasource="#session.DSN#" name="rsInsert">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" returnvariable="LvarCPDAEid">
	</cftransaction>
	<cflocation url="docsAutExt.cfm?CPDAEid=#LvarCPDAEid#">
<cfelseif isdefined ('form.Cambio')>
	<cfquery datasource="#session.dsn#">
		update CPDocumentoAE 
		set
			CPDAEcodigo='#form.CPDAEcodigo#',
			CPDAEdescripcion='#form.CPDAEdescripcion#',
			CPTAEid = #form.CPTAEid#,
			CPDAEmontoCF=#replace(form.CPDAEmontoCF,",","","ALL")#
		where CPDAEid=#form.CPDAEid#
		and Ecodigo=#session.Ecodigo# 
	</cfquery>
	<cflocation url="docsAutExt.cfm?CPDAEid=#form.CPDAEid#">
<cfelseif isdefined ('form.Baja')>	
	<cfquery datasource="#session.dsn#">	
		delete from CPDocumentoAE where CPDAEid=#form.CPDAEid#
	</cfquery>
	<cflocation url="docsAutExt.cfm">
<cfelseif isdefined ('form.Nuevo')>	
	<cflocation url="docsAutExt.cfm?Nuevo">
<cfelseif isdefined ('url.OP') AND url.OP EQ 20>
	<cflocation url="docsAutExt.cfm?OPD&CPDAEid=#url.ID#">
<cfelseif isdefined ('url.OP')>
	<!---
		CPDEestadoDAE
		0	En Proceso
		9	Aprobado sin confirmar
		10	Aprobado Confirmado
		11	Aprobado con NRP
		12	Aprobado y Aplicado
	--->
	<!--- OP = 3 no permite EnAprobacion		CPDEenAprobacion = 1 AND CPDEestadoDAE = 0 --->
	<!--- OP = 10 no permite EnPreaprobacion	CPDEenAprobacion = 1 AND CPDEestadoDAE <> 10 --->
	<cfif url.OP EQ 3>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select count(1) as cantidad
			  from CPDocumentoE
			where CPDAEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">
			  and Ecodigo = #session.Ecodigo# 
			  and CPDEenAprobacion = 1 AND CPDEestadoDAE = 0
		</cfquery>
		<cfif rsSQL.cantidad GT 0>
			<cfthrow message="No se puede cerrar mientras existan documentos en Proceso de Aprobación">
		</cfif>
	<cfelseif url.OP EQ 11>
		<cfinvoke	component= "sif.presupuesto.Componentes.PRES_Traslados"
					method = "AplicarAutorizacionExterna"
					CPDAEid = "#url.ID#"
		/>
	</cfif>
	<cfquery datasource="#session.dsn#">
		update CPDocumentoAE 
		   set	CPDAEestado=#url.op#
		where CPDAEid=#url.id#
	</cfquery>
<cfelseif isdefined ('url.OPD')>
	<cfif url.OPD EQ 1>			<!--- PASAR A OTRO DOCUMENTO --->
	<cfelseif url.OPD EQ 3>		<!--- RECHAZAR TRASLADO --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select CPDAEcodigo
			  from CPDocumentoAE 
			 where CPDAEid=#url.id#
		</cfquery>
		<cfinvoke	component= "sif.presupuesto.Componentes.PRES_Traslados"
					method = "RechazarTraslado"
					CPDEid = "#url.IDD#"
					CPDEmsgRechazo = "Rechazado desde Administración de Documento Autorización Externa #rsSQL.CPDAEcodigo#"
		/>
	<cfelse>
		<cfquery name="updDoc" datasource="#Session.DSN#">
			update CPDocumentoE
			   set CPDEenAprobacion = 1
				 , CPDEestadoDAE	= #url.OPD#
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDD#">
			  and CPDAEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">
			  and Ecodigo = #session.Ecodigo# 
			  and CPDEestadoDAE	= <cfif url.OPD EQ 9>10<cfelse>9</cfif>
		</cfquery>
	</cfif>
	<cflocation url="docsAutExt.cfm?OPD&CPDAEid=#url.ID#">
</cfif>

<cflocation url="docsAutExt.cfm">

