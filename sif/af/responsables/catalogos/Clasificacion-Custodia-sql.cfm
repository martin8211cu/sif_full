<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfset params = "">

<cfif isdefined("url.CRCCid") and len(trim(url.CRCCid))>
	<cfset form.CRCCid = url.CRCCid >
</cfif>
<cfif isdefined("url.tab") and len(trim(url.tab))>
	<cfset form.tab = url.tab >
</cfif>
<cfif isdefined("url.modoE") and len(trim(modoE))>
	<cfif url.modoE eq "BAJA">
		<cfif isdefined("url.ACid") and len(trim("url.ACid"))>
			<cfset form.ACid = url.ACid>
		</cfif>
		<cfif isdefined("url.ACcodigo") and len(trim("url.ACcodigo"))>
			<cfset form.ACcodigo = url.ACcodigo>
		</cfif>
	</cfif>
</cfif>

<cfif isDefined("form.modo") and not isDefined("url.modoE") >
	<cfif form.modo eq "ALTA">
		<cfif isDefined("form.ACcodigo") and len(trim(#form.ACcodigo#))>
			
			<cfquery name="rsSelect" datasource="#session.DSN#">
				select count(1) error
				 from CRAClasificacion
				 where ACid =    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#">
				 and ACcodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#">
				 and Ecodigo=  #session.Ecodigo#
			</cfquery>
			
			<cfif rsSelect.RecordCount NEQ 0  and rsSelect.error EQ 0>
				<cfquery name="rsCla" datasource="#session.DSN#">
					insert into CRAClasificacion (CRCCid,Ecodigo,ACid,ACcodigo,BMUsucodigo,CRACfalta)
					values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">,
							  #session.Ecodigo# ,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#">,
							 #session.Usucodigo#, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
							)
				</cfquery>
			
			<cfelse>
				<cf_errorCode	code = "50117" msg = "Ya existe la relación entre Categoría y Clase en algún Centro de Custodia.">
			</cfif>
			
		</cfif>
	</cfif>
		
<cfelseif isDefined("url.modoE")>
	<cfif url.modoE eq "BAJA">
		<cfquery name="rsCla" datasource="#session.DSN#">
			delete from CRAClasificacion
			where CRCCid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">
			  and Ecodigo   =  #session.Ecodigo# 
			  and ACid      = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#">
			  and ACcodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#">
		</cfquery>
	</cfif>
</cfif>
<cfset params="?CRCCid="&#form.CRCCid#>
<cfset params=params&"&tab="&#form.tab#>
<cflocation url="CentroCustodia.cfm#params#">

