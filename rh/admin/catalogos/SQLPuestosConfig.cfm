<!--- <cfdump var="#PreserveSingleQuotes(Form.CRPepie)#">
<br/> ---> 
<cfset Form.CRPepie = Replace(Form.CRPepie, "<cfoutput>", "" ,"all")>
<cfset Form.CRPepie = Replace(Form.CRPepie, "</cfoutput>", "" ,"all")>
<!---<cf_dump var="#PreserveSingleQuotes(Form.CRPepie)#"> --->

<cfparam name="action" type="string" default="PuestosConfig.cfm">
<cfparam name="modo" type="string" default="CAMBIO">
<cfif isdefined("form.Cambio")>
	<cfquery name="RHConfRepPConsulta" datasource="#session.DSN#">
		select 1 from RHConfigReportePuestos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif isdefined("RHConfRepPConsulta") and RHConfRepPConsulta.RecordCount EQ 0>
		<cfquery name="RHConfRepPInsert" datasource="#session.DSN#">
			insert into RHConfigReportePuestos 
			(Ecodigo, CRPohabilidad, CRPoconocim, CRPomision, CRPoobj, CRPoespecif, CRPoencab, CRPoubicacion, 
			 BMusuario, BMfecha, CRPeini, CRPehabilidad, CRPeconocim, CRPemision, CRPeobjetivo, CRPeespecif, 
			 CRPeencab, CRPeubicacion, CRPihabilidad, CRPiconocimi, CRPimision, CRPiobj, CRPiespecif, CRPiencab, 
			 CRPiubicacion,CRPepie,CRPipie,CRPoHAY,CRPiHAY,CRPeHAY,CRPoPuntajes,CRPiPuntajes,CRPePuntajes)
			values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ohabilidad#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.oconocim#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.omision#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.oobj#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.oespecif#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.oencab#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.oubicacion#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
					<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.eini#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ehabilidad#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.econocim#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.emision#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.eobj#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.eespecif#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.eencab#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.eubicacion#">, 
					
					<cfif isdefined("form.ihabilidad")>1<cfelse>0</cfif>, 
					<cfif isdefined("form.iconocimi")>1<cfelse>0</cfif>, 
					<cfif isdefined("form.imision")>1<cfelse>0</cfif>, 
					<cfif isdefined("form.iobj")>1<cfelse>0</cfif>, 
					<cfif isdefined("form.iespecif")>1<cfelse>0</cfif>, 
					<cfif isdefined("form.iencab")>1<cfelse>0</cfif>,
					<cfif isdefined("form.iubicacion")>1<cfelse>0</cfif>, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(Form.CRPepie)#">, 
					<cfif isdefined("form.CRPipie")>1<cfelse>0</cfif>,
					<cfif isdefined("form.CRPoHAY") and len(trim(form.CRPoHAY))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CRPoHAY#">, 
					<cfelse>
						null,
					</cfif>	
					<cfif isdefined("form.CRPiHAY")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRPeHAY#">,
					<cfif isdefined("form.CRPoPuntajes") and len(trim(form.CRPoPuntajes))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CRPoPuntajes#">, 
					<cfelse>
						null,
					</cfif>	
					<cfif isdefined("form.CRPiPuntajes")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRPePuntajes#">
					)
		</cfquery>
	<cfelse>
		<cfquery name="RHConfRepPUpdate" datasource="#session.DSN#">
			update RHConfigReportePuestos 
			set CRPohabilidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ohabilidad#">, 
				CRPoconocim = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.oconocim#">, 
				CRPomision = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.omision#">, 
				CRPoobj = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.oobj#">, 
				CRPoespecif = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.oespecif#">, 
				CRPoencab = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.oencab#">, 
				CRPoubicacion = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.oubicacion#">, 
				BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
				BMusumod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
				CRPeini = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.eini#">, 
				CRPehabilidad = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ehabilidad#">, 
				CRPeconocim = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.econocim#">, 
				CRPemision = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.emision#">, 
				CRPeobjetivo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.eobj#">, 
				CRPeespecif = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.eespecif#">, 
				CRPeencab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.eencab#">,
				CRPeubicacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.eubicacion#">,
				CRPepie = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(Form.CRPepie)#">, 
				CRPihabilidad = <cfif isdefined("form.ihabilidad")>1<cfelse>0</cfif>, 
				CRPiconocimi = <cfif isdefined("form.iconocimi")>1<cfelse>0</cfif>, 
				CRPimision = <cfif isdefined("form.imision")>1<cfelse>0</cfif>, 
				CRPiobj = <cfif isdefined("form.iobj")>1<cfelse>0</cfif>, 
				CRPiespecif = <cfif isdefined("form.iespecif")>1<cfelse>0</cfif>, 
				CRPiencab = <cfif isdefined("form.iencab")>1<cfelse>0</cfif>,
				CRPiubicacion = <cfif isdefined("form.iubicacion")>1<cfelse>0</cfif>,
				CRPipie = <cfif isdefined("form.CRPipie")>1<cfelse>0</cfif>,				
				CRPoHAY = 	<cfif isdefined("form.CRPoHAY") and len(trim(form.CRPoHAY))>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CRPoHAY#">, 
							<cfelse>
								null,
							</cfif>
				CRPiHAY = <cfif isdefined("form.CRPiHAY")>1<cfelse>0</cfif>,
				CRPeHAY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRPeHAY#">,
				CRPoPuntajes = 	<cfif isdefined("form.CRPoPuntajes") and len(trim(form.CRPoPuntajes))>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CRPoPuntajes#">, 
							<cfelse>
								null,
							</cfif>
				CRPiPuntajes = <cfif isdefined("form.CRPiPuntajes")>1<cfelse>0</cfif>,
				CRPePuntajes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRPePuntajes#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
</cfif>

<cfset args = "">
<!--- Agrega un Argumento
	<cfset arg = "">
	<cfset args = iif(len(trim(args)) gt 0,DE('?'&arg),DE(args&'&'&arg)),DE('')>
--->
<cflocation url="#action##args#">