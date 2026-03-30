<cfsetting enablecfoutputonly="yes">

<cftry>

<cfquery name="rsForm" datasource="#session.DSN#">
	update RHPuestos
	set FRval = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.escalaFR#">,
	    FLval = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.escalaFL#">,
	    BRval = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.escalaBR#">,
		BLval = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.escalaBL#">,
	    
		FRtol = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.toleraFR#">,
		FLtol = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.toleraFL#">,
	    BRtol = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.toleraBR#">,
	    BLtol = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.toleraBL#">,
		
		extravertido = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.esExtrov Is 1#">,
		introvertido = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.esIntrov Is 1#">,
		balanceado = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.esBalance Is 1#">,
		ubicacionMuneco = <cfqueryparam cfsqltype="cf_sql_char" value="#form.meneco#" null="#Len(Trim(form.meneco)) Is 0#">
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.RHPcodigo#">
</cfquery>

	<cfoutput>ok=1</cfoutput>	
<cfcatch type="any">
	<cfoutput>ok=0&errormsg=# URLEncodedFormat(cfcatch.Message & ' ' & cfcatch.Detail) #</cfoutput>
	<cflog file="benzinger" text="#cfcatch.Message & ' ' & cfcatch.Detail#">
	<cfset errargs = "">
	<cfloop collection="#form#" item="fld">
		<cfset errargs = ListAppend(errargs,fld & '=' & form[fld] )>
	</cfloop>
	<cflog file="benzinger" text="args: #errargs#">
	<cflog file="benzinger" text=" ">
</cfcatch>
</cftry>