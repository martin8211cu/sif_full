<cfif not isdefined("Form.Nuevo")>			
	<cftry>
		<cfquery name="SNDistGasto" datasource="#Session.DSN#">
			set nocount on			
			<cfif isdefined("Form.Alta")>
				Insert 	SNGastosDistribucion(SNid,Ecodigo,DistGasto,markup)
						values	(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                        1,
                        <cfif isdefined("Form.txtMarkup") and len(Form.txtMarkup) gt 0><cfqueryparam cfsqltype="cf_sql_float" value="#numberformat(Form.txtMarkup,'9.00')#"><cfelse>0</cfif>						
						)
				Select 1
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Cambio")>
				Update 	SNGastosDistribucion
					set markup = <cfif isdefined("Form.txtMarkup") and len(Form.txtMarkup) gt 0><cfqueryparam cfsqltype="cf_sql_float" value="#numberformat(Form.txtMarkup,'9.00')#"><cfelse>0</cfif>
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				      and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNid#">
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete SNGastosDistribucion
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				     and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNid#">
				<cfset modo="BAJA">
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="SNDistGasto.cfm" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="SNid" type="hidden" value="<cfif isdefined("Form.SNid")><cfoutput>#Form.SNid#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>