<cfparam name="modoD" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_TipoIdentif" datasource="#session.DSN#">
			set nocount on
			
			<cfif isdefined("form.Alta")>
				insert FormaPagoDatos (FPcodigo,FPDnombre,FPDtipoDato,FPDlongitud,FPDdecimales,FPDobligatorio,FPDorden)
				values (
					  	<cfqueryparam value="#form.FPcodigo#" 		cfsqltype="cf_sql_numeric">
					 ,	<cfqueryparam value="#form.FPDnombre#" 		cfsqltype="cf_sql_varchar">
					 , 	<cfqueryparam value="#form.FPDtipoDato#" 	cfsqltype="cf_sql_char">
					 , 	<cfqueryparam value="#form.FPDlongitud#" 	cfsqltype="cf_sql_integer">
					 , 	<cfif isdefined('form.FPDdecimales') and form.FPDdecimales NEQ ''><cfqueryparam value="#form.FPDdecimales#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>
					 , 	<cfif isdefined('form.FPDobligatorio')>
					 		1
						<cfelse>
							0
						</cfif>
					 , 	<cfqueryparam value="#form.FPDorden#" 	cfsqltype="cf_sql_smallint">						
					 )
			<cfelseif isdefined("form.Cambio")>
				update FormaPagoDatos
					set FPDnombre = <cfqueryparam value="#form.FPDnombre#" cfsqltype="cf_sql_varchar">
					, FPDtipoDato = <cfqueryparam value="#form.FPDtipoDato#" cfsqltype="cf_sql_char">
					, FPDlongitud = <cfqueryparam value="#form.FPDlongitud#" cfsqltype="cf_sql_integer">
						<cfif isdefined('form.FPDdecimales')>
					 		, FPDdecimales = <cfqueryparam value="#form.FPDdecimales#" cfsqltype="cf_sql_integer">
						<cfelse>
							, FPDdecimales = null
						</cfif>
						<cfif isdefined('form.FPDobligatorio')>
					 		, FPDobligatorio = 1
						<cfelse>
							, FPDobligatorio = 0
						</cfif>											
					, FPDorden = <cfqueryparam value="#form.FPDorden#" cfsqltype="cf_sql_smallint">
				where FPcodigo = <cfqueryparam value="#form.FPcodigo#" cfsqltype="cf_sql_numeric">
					and FPDcodigo = <cfqueryparam value="#form.FPDcodigo#" cfsqltype="cf_sql_numeric">
				  
				  <cfset modoD = 'CAMBIO'>
			<cfelseif isdefined("form.Baja")>
				delete FormaPagoDatos
				where FPcodigo = <cfqueryparam value="#form.FPcodigo#" cfsqltype="cf_sql_numeric">
					and FPDcodigo = <cfqueryparam value="#form.FPDcodigo#" cfsqltype="cf_sql_numeric">
			</cfif>

			set nocount off				
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfoutput>
	<form action="formaPago.cfm" method="post" name="sql">
		<input name="modo"   type="hidden" value="CAMBIO">
		<input name="modoD"   type="hidden" value="<cfif isdefined("modoD")>#modoD#</cfif>">	
		<input name="FPcodigo" type="hidden" value="#form.FPcodigo#">
		<cfif modoD eq 'CAMBIO'><input name="FPDcodigo" type="hidden" value="#form.FPDcodigo#"></cfif>	
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
