<cfparam name="form.listados" default="">
<cfparam name="form.chk" default="">
<!--- Linea inicial y final --->
<cfset inicio 	 = ListGetAt(form.listados,1,',')>
<cfset final 	 = ListGetAt(form.listados,2,',')>
<!--- Datos para trabajar--->
<cfset PCEMid   = ListGetAt(inicio,1,'|')>
<cfset PCNidI 	 = ListGetAt(inicio,2,'|')>
<cfset PCNidF 	 = ListGetAt(final,2,'|')>
<cfset LvarTipo = #form.LvarTipo#>

<cftransaction>
	<cfquery name="rsInserta" datasource="#session.dsn#">
		 update FPConfNivelCuenta 
		set PCFActivo =  0
		where Ecodigo = #session.Ecodigo#
		and PCEMid = #PCEMid#
		and PCNid between #PCNidI# and #PCNidF#
		and PCTipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTipo#">
	</cfquery>
	
	<cfif isdefined("form.btnAceptar")>
		<cfloop delimiters="," list="#form.chk#" index="i">
			<cfset nivel 	= ListGetAt(i,2,'|')>
			<cfset linea 	= ListGetAt(i,3,'|')>
			<cfquery name="rsVerificaDato" datasource="#session.dsn#">
				select count(1) as cantidad from FPConfNivelCuenta
					where Ecodigo = #session.Ecodigo#
					and PCEMid = #PCEMid# 
					and PCNid = #nivel#
					and PCTipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTipo#">
					and PCLinea = #linea#
			</cfquery>
			
			<cfif rsVerificaDato.cantidad gt 0> 
				<cfquery name="rsInserta" datasource="#session.dsn#">
					update FPConfNivelCuenta 
					set PCFActivo  =  1
					where PCEMid 	= #PCEMid#
					and Ecodigo 	= #session.Ecodigo#
					and PCNid 		= #nivel#
					and PCTipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTipo#">
				</cfquery>
			<cfelse>
				<cfquery name="insertNivelCuenta" datasource="#session.dsn#">
					insert into FPConfNivelCuenta 
						(	
							Ecodigo,
							PCLinea,
							Ctipo,
							PCTipo,
							PCEMid,
							PCNid,
							PCFActivo,
							BMUsucodigo,
							BMfecha
						)
						values
						(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#linea#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Ctipo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTipo#">,
							#PCEMid#,
							#nivel#,
							1,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>	
</cftransaction>
<cflocation url="ConfiguracionNivelCuenta.cfm?PCEMid=#PCEMid#&Ctipo=#Ctipo#&PAGENUM1=#FORM.PAGENUM1#&LvarTipo=#LvarTipo#" addtoken="no">
