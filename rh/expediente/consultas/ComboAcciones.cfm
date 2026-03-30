<cfsetting enablecfoutputonly="yes">
<cfif isdefined ('url.RHTcomportam') and #url.RHTcomportam# GT 0>
	<cfquery name="rsTipoAcc" datasource="#session.dsn#">
		select *
			from RHTipoAccion
		where Ecodigo=  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
		and RHTcomportam = #url.RHTcomportam#
	</cfquery>
<cfelse>
	<cfquery name="rsTipoAcc" datasource="#session.dsn#">
		select *
			from RHTipoAccion
		where Ecodigo=  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
	</cfquery>
	
</cfif>

<cfoutput>
	<select name="Concepto" id="concepto" >
		<cfloop query="rsTipoAcc">
			<option value="#RHTid#">#RHTdesc#</option>	
		</cfloop>
	</select>	
</cfoutput>