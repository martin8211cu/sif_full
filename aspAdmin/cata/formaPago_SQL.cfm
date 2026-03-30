<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_FPago" datasource="#session.DSN#">
			set nocount on

			<cfif isdefined("form.Alta")>
				insert FormaPago (FPnombre,FPtipo)
				values (
					 	<cfqueryparam value="#form.FPnombre#" 	cfsqltype="cf_sql_varchar">
					 , 	<cfqueryparam value="#form.FPtipo#" 	cfsqltype="cf_sql_char">)
			<cfelseif isdefined("form.Cambio")>
				update FormaPago
					set FPnombre = <cfqueryparam value="#form.FPnombre#" cfsqltype="cf_sql_varchar">
					, FPtipo = <cfqueryparam value="#form.FPtipo#" cfsqltype="cf_sql_char">
				where FPcodigo = <cfqueryparam value="#form.FPcodigo#" cfsqltype="cf_sql_char">
				  
				  <cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Baja")>
				delete FormaPagoDatos
				where FPcodigo= <cfqueryparam value="#form.FPcodigo#" cfsqltype="cf_sql_char">
		
				delete FormaPago
				where FPcodigo= <cfqueryparam value="#form.FPcodigo#" cfsqltype="cf_sql_char">
			</cfif>

			set nocount off				
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfoutput>
	<form action="formaPago.cfm" method="post" name="sql">
		<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<cfif modo eq 'CAMBIO'><input name="FPcodigo" type="hidden" value="#form.FPcodigo#"></cfif>
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
