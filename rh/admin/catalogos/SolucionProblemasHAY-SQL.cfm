<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Cambio")>
	
		<cfquery name="update" datasource="sifcontrol">
			update HYTSolucionProblemas
			set  HYTSrestrict = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.HYTSrestrict#">
			  where HYMRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.HYMRcodigo#">
		  	    and HYCPgrado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.HYCPgrado#">
		        and HYTSPporcentaje = <cfqueryparam cfsqltype="cf_sql_float" value="#form.HYTSPporcentaje#">
		</cfquery>
		<cfset modo="ALTA">
		
	</cfif>
</cfif>

<cfoutput>
<form action="SolucionProblemasHAY.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="HYMRcodigo" type="hidden" value="<cfif isdefined("data")>#data.HYMRcodigo#</cfif>">
	<input name="HYCPgrado" type="hidden" value="<cfif isdefined("data")>#data.HYCPgrado#</cfif>">
	<input name="HYTSPporcentaje" type="hidden" value="<cfif isdefined("data")>#data.HYTSPporcentaje#</cfif>">
	<cfif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
		<input name="PageNum" type="hidden" value="#Form.PageNum#">
	</cfif>
</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
