<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="sihay" datasource="sifcontrol">
			select HYTHid as hay from HYTHabilidades  
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and HYTHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.HYTHid#">
		</cfquery>
		<cfif isdefined("sihay") and sihay.RecordCount GT 0>

		<cfelse>
			<cfquery name="insert" datasource="sifcontrol">
				insert into HYTHabilidades  (HYHEcodigo, HYHGcodigo, HYIHgrado, HYTHpuntos, HYTHrestrict)
					values (<cfqueryparam cfsqltype="cf_sql_char" value="#form.HYHEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.HYHGcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.HYTHpuntos#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.HYTHrestrict#">
					) 
			</cfquery>
		</cfif>
		<cfset modo = "ALTA">
	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="update" datasource="sifcontrol">
			update HYTHabilidades
			set  HYTHrestrict = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.HYTHrestrict#">
			where HYTHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.HYTHid#">
		</cfquery>
		<cfset modo="ALTA">
		
	</cfif>
</cfif>

<cfoutput>
<form action="HabilidadesHAY.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="HYTHid" type="hidden" value="<cfif isdefined("form.HYTHid") and modo neq 'ALTA'>#form.HYTHid#</cfif>">
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
