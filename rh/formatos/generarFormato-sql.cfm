<cfif isdefined("form.btnSolicitar")>
	<cftransaction>
		<cfif isdefined('form.radio1') and form.radio1 eq 1>
				<cfquery name="rsinsert" datasource="#session.dsn#">
					insert into CertificacionesEmpleado 
					(EFid, DEid, Ecodigo, CSEfrecoge, 
					BMfechaalta, BMUsucodigo, CSEatendida)
					values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">, 	
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.CSEfrecoge)#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					1)
					<cf_dbidentity1 datasource="#session.dsn#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.dsn#" name="rsinsert">
					<cfset Lvar_CSEid = rsinsert.identity>
		<cfelse>
				<cfquery name="rsinsert" datasource="#session.dsn#">
					insert into CertificacionesEmpleado 
					(EFid, DEid, Ecodigo, CSEfrecoge, 
					BMfechaalta, BMUsucodigo, CSEatendida,RHCid)
					select 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#">, 
					e.DEid,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.CSEfrecoge)#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					0,			
					#form.RHCid#
					from RHEmpleadoCurso e
					where RHCid=#form.RHCid#	
					and RHEMestado=10				
				</cfquery>
		</cfif>
	</cftransaction>

<cfelseif isdefined("form.chk")>
	<cfloop list="#form.chk#" delimiters=","  index="i">	
		<cfquery name="rsupdate" datasource="#session.dsn#">
			update CertificacionesEmpleado 
			set CSEatendida = 0
			where CSEid = #i#
		</cfquery>
		<cflocation url="generarFormato-result.cfm?CSEid=#form.chk#">
	</cfloop>
<cfelse>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ErrorAlProcesarUnaCertificacionNoSePudoObtenerElNoDeCertfSolicitadaProcesoCancelado"
	Default="Error al procesar una certificación. No se pudo obtener el No. de Certf. Solicitada. Proceso Cancelado!"
	returnvariable="MSG_ErrorAlProcesarUnaCertificacionNoSePudoObtenerElNoDeCertfSolicitadaProcesoCancelado"/>
	
	
	<cfthrow message="#MSG_ErrorAlProcesarUnaCertificacionNoSePudoObtenerElNoDeCertfSolicitadaProcesoCancelado#">
</cfif>


<cfif isdefined('form.radio1') and form.radio1 eq 1>
	<cflocation url="generarFormato-result.cfm?CSEid=#Lvar_CSEid#">
<cfelse>
	<cflocation url="generarFormato.cfm">
</cfif>