<cfset params = "">
<cfif isdefined("url.modo") and len(trim(modo))>
	<cfif url.modo eq "BAJA">
		<cfif isdefined("url.Usucodigo") and len(trim("url.Usucodigo"))>
			<cfset form.Usucodigo = url.Usucodigo>
		</cfif>
	</cfif>
</cfif>

<cfif isDefined("form.btnAlta")>
	<cfif form.btnAlta eq "ALTA">
		<cfif isDefined("form.Usucodigo") and len(trim(#form.Usucodigo#))>
			
			<cfquery name="rsSelect" datasource="#session.DSN#">
				select count(1) as error
				from PCECatalogoUsr
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
			</cfquery>
			
			<cfif rsSelect.RecordCount NEQ 0 and rsSelect.error EQ 0>

				<cfquery name="rsUsu" datasource="#session.DSN#">				
					insert into PCECatalogoUsr (
											PCEcatid,
											Usucodigo,	
											Ecodigo,
											BMUsucodigo
											)
					values	( 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 							 							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">
							)
				</cfquery>
			
			<cfelse>
				<cf_errorCode	code = "50219" msg = "Ya existe el usuario que desea agregar.">
			</cfif>
			
		</cfif>
	</cfif>
	
<cfelseif isDefined("url.modo")>
	<cfif url.modo eq "BAJA">
		<cfif isdefined("Url.PCEcatid") and (not isdefined("Form.PCEcatid") or not len(trim(Form.PCEcatid)))>
			<cfset Form.PCEcatid = Url.PCEcatid>
		</cfif>	
		<cfquery name="rsUsu" datasource="#session.DSN#">
			delete from PCECatalogoUsr
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">		
		</cfquery>
	</cfif>
</cfif>

<cflocation url="UsuxCatalogo.cfm?PCEcatid=#Form.PCEcatid#">

