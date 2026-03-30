
<cfset modoEducacion = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into RHEducacionEmpleado(DEid, RHOid, Ecodigo, RHIAid, GAcodigo, RHEotrains, RHEtitulo,RHOTid, RHEfechaini, RHEfechafin, 
            	RHEsinterminar, BMUsucodigo, BMfecha,RHECapNoFormal,RHEestado,RHOEid,RHEobservacion )
			values(	<cfif isdefined("form.DEid") and len(trim(form.DEid))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfif isdefined("form.RHIAid") and len(trim(form.RHIAid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#"><cfelse>null</cfif>,
					<cfif isdefined("form.GAcodigo") and len(trim(form.GAcodigo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAcodigo#"><cfelse>null</cfif>,
					<cfif isdefined("form.RHIAid") and not(len(trim(form.RHIAid))) and isdefined("form.RHEotrains") and len(trim(form.RHEotrains))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEotrains#">
					<cfelse>
						null
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(form.RHOTDescripcion,1,60)#">,
					<cfif isdefined("form.RHOTid") and len(trim(form.RHOTid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOTid#"><cfelse>null</cfif>,

					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoIni,form.mesIni,01)#">,
					<cfif isdefined("form.anoFin") and len(trim(form.anoFin)) and isdefined("form.mesFin") and len(trim(form.mesFin)) >
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoFin,form.mesFin,01)#">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoIni,form.mesIni,01)#">
					</cfif>,
					<cfif isdefined("form.RHEsinterminar")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfif isdefined("form.RHECapNoFormal") and len(trim(form.RHECapNoFormal))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.RHECapNoFormal#"><cfelse>null</cfif>,
					<cfif isdefined('Lvar_EducAuto')>0<cfelse>1</cfif>,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOEid#" null="#not isdefined('form.RHOEid') or not len(trim(form.RHOEid))#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEobservacion#">
					)			
		</cfquery>
		<cfset modoEducacion="ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from RHEducacionEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHEElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEElinea#">
			  	<cfif isdefined("form.DEid") and len(trim(form.DEid))>
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
					and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
				</cfif>	
		</cfquery>  
		<cfset modoEducacion="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="RHEducacionEmpleado"
			 			redirect="educacion.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="RHEElinea" 
						type2="numeric" 
						value2="#form.RHEElinea#">

		<cfquery name="update" datasource="#Session.DSN#">
			update RHEducacionEmpleado
			set RHEtitulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOTDescripcion#">,
				RHOTid    =	<cfif isdefined("form.RHOTid") and len(trim(form.RHOTid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOTid#"><cfelse>null</cfif>,

				RHIAid = <cfif isdefined("form.RHIAid") and len(trim(form.RHIAid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#"><cfelse>null</cfif>,
				GAcodigo = 	<cfif isdefined("form.GAcodigo") and len(trim(form.GAcodigo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAcodigo#"><cfelse>null</cfif>,
				RHEotrains = <cfif isdefined("form.RHIAid") and not(len(trim(form.RHIAid))) and isdefined("form.RHEotrains") and len(trim(form.RHEotrains))>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEotrains#">
							<cfelse>
								null
							</cfif>,
				RHEfechaini = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoIni,form.mesIni,01)#">,
<!---LJIMENEZ--->
				RHEfechafin = <cfif isdefined("form.anofin") and len(trim(form.anofin))>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.anoFin,form.mesFin,01)#">
							<cfelse>
								null
							</cfif>,
				RHEsinterminar = <cfif isdefined("form.RHEsinterminar")>1<cfelse>0</cfif>,
				RHECapNoFormal = <cfif isdefined("form.RHECapNoFormal") and len(trim(form.RHECapNoFormal))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.RHECapNoFormal#"><cfelse>null</cfif>,
				RHOEid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOEid#" null="#not isdefined('form.RHOEid') or not len(trim(form.RHOEid))#">,
				RHEobservacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEobservacion#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
			  and RHEElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEElinea#" >
			  	<cfif isdefined("form.DEid") and len(trim(form.DEid))>
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
					and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
				</cfif>	
		</cfquery> 
		<cfset modoEducacion="CAMBIO">
	</cfif>
</cfif>

<cfoutput>

<!---<cfif isdefined("form.DEid") and len(trim(form.DEid))>expediente.cfm<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>OferenteExterno.cfm</cfif>---->
<form action="<cfif isdefined("form.DEid") and len(trim(form.DEid))><cfif isdefined('Lvar_EducAuto')>../../autogestion/autogestion.cfm<cfelse>expediente.cfm</cfif><cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>../../Reclutamiento/catalogos/OferenteExterno.cfm</cfif>" method="post" name="sqlEducacion">
	<input name="DEid" type="hidden" value="<cfif isdefined("form.DEid") and len(trim(form.DEid))>#form.DEid#</cfif>">
	<input name="RHOid" type="hidden" value="<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>#form.RHOid#</cfif>">
	<cfif isdefined('Lvar_EducAuto')>
		<input type="hidden" name="tab" value="6">
	<cfelse>
		<input type="hidden" name="tab" value="4">
	</cfif>
	<input name="o" type="hidden" value="3">			
	<input name="sel" type="hidden" value="1">
	<cfif isdefined("form.Cambio")>
		<input name="RHEElinea" type="hidden" value="#form.RHEElinea#">
	</cfif>
</form>
</cfoutput>	

<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>