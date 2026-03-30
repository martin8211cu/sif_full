 <cfset Action = "VisualizaAlerta.cfm">

<cfif isdefined("url.RHAAid") and len(trim(url.RHAAid))>
	
	<cfquery name="UpdRHAlertaAcciones" datasource="#Session.DSN#">
		update RHAlertaAcciones
		set recibido   =  1
			where RHAAid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHAAid#">	
	</cfquery>
	
	
<cfelseif isdefined("url.btnAceptarAll")>
	<cfquery name="UpdRHAlertaAcciones" datasource="#Session.DSN#">
		update RHAlertaAcciones
		set recibido   =  1
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

		<cfif isdefined("url.RHTid") and len(trim(url.RHTid)) and url.RHTid NEQ -1>
			and RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHTid#">  
		</cfif>
		<cfif isdefined("url.DEid") and len(trim(url.DEid))>
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">  
		</cfif>
		<cfif isdefined("url.fechaH") and len(trim(Url.fechaH))>
			and falerta <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("d",1,LSParseDateTime(url.fechaH))#">
		</cfif>
	</cfquery>
<cfelse>
	<cfthrow message="Error: No se pudo aplicar la Acci&oacute;n">
</cfif>
<cfset params="">
<cfif isdefined("Url.RHTid") and not isdefined("form.RHTid")>
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "RHTid=" & Url.RHTid>	
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("form.DEid")>
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "DEid=" & Url.DEid>
</cfif>
<cfif isdefined("Url.fechaH") and not isdefined("form.fechaH")>
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "fechaH=" & Url.fechaH>
</cfif>
<cfif isdefined("Url.formato") and not isdefined("form.formato")>
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "formato=" &  Url.formato>
<cfelse >
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "formato=flashpaper">
</cfif>

<cfif isdefined("params") and len(trim(params))>
	<cfif isdefined("url.btnAceptarAll")>
		<cfset actionUrl = 'VisualizaAlerta.cfm?' & params >
	<cfelse>
		<cfset actionUrl = 'VisualizaAlerta-reporte2.cfm?' & params >
	</cfif>
	
<cfelse >
	<cfif isdefined("url.btnAceptarAll")>
		<cfset actionUrl = 'VisualizaAlerta.cfm'>
	<cfelse>
		<cfset actionUrl = 'VisualizaAlerta-reporte2.cfm'>
	</cfif>
</cfif>


<cflocation url="#actionUrl#"> 
<form action="<cfoutput>#Action#</cfoutput>" method="post" name="form1">
	<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
		<input name="DEid" type="hidden" value="#url.DEid#">
	</cfif>
	<cfif isdefined("url.RHTid") and not isdefined("form.RHTid")>
		<input name="RHTid" type="hidden" value="#url.RHTid#">
	</cfif>
	<cfif isdefined("url.fechaH") and not isdefined("form.fechaH")>
		<input name="fechaH" type="hidden" value="#url.fechaH#">
	</cfif>
	<cfif isdefined("url.formato") and not isdefined("form.formato")>
		<input name="formato" type="hidden" value="#url.formato#">
	</cfif>
</form>

<script language="JavaScript1.2" type="text/javascript">
	document.form1.submit();
</script>