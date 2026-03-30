<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Cambio")>
	
		<cfquery name="update" datasource="sifcontrol">
			update HYTASolucionProblemas
			set  HYTASrestrict = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.HYTASrestrict#">
			where HYTAptshab = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.HYTAptshab#">
		  and HYTAporcentaje = <cfqueryparam cfsqltype="cf_sql_float" value="#form.HYTAporcentaje#">
		</cfquery>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfoutput>
<form action="AuxSolucionProblemasHAY.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="HYTASrestrict" type="hidden" value="<cfif isdefined("data")>#data.HYTASrestrict#</cfif>">
	<input name="HYTAptshab" type="hidden" value="<cfif isdefined("data")>#data.HYTAptshab#</cfif>">
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
