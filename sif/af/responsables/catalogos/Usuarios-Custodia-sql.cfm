<!---  --->
<cfset params = "">
<cfif isdefined("url.CRCCid") and not isdefined("form.CRCCid")>
	<cfset form.CRCCid = url.CRCCid >
</cfif>
<cfif isdefined("url.tab") and not isdefined("form.tab")>
	<cfset form.tab = url.tab >
</cfif>
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
				from CRCCUsuarios
				where CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CRCCid#">
					and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">
			</cfquery>
			
			<cfif rsSelect.RecordCount NEQ 0 and rsSelect.error EQ 0>
			
				<cfquery name="rsUsu" datasource="#session.DSN#">
					insert into CRCCUsuarios (CRCCid,Usucodigo,BMUsucodigo,CRCCfalta)
					values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#CRCCid#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
							)
				</cfquery>
			
			<cfelse>
				<cf_errorCode	code = "50122" msg = "Ya existe usuario que desea agregar al Centro de Custodia.">
			</cfif>
			
		</cfif>
	</cfif>
	
<cfelseif isDefined("url.modo")>
	<cfif url.modo eq "BAJA">
		<cfquery name="rsUsu" datasource="#session.DSN#">
			delete from CRCCUsuarios
			where CRCCid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">
			  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
		</cfquery>
	</cfif>
</cfif>

<cfset params="?CRCCid="&#form.CRCCid#>
<cfset params=params&"&tab="&#form.tab#>

<cflocation url="CentroCustodia.cfm#params#">

