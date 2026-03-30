<cfparam name="modo" default="ALTA">
<cfif not isdefined("form.Nuevo")>
	<cftry>	
		<cfquery name="abc_CiclosLectivos" datasource="#session.DSN#">
			set nocount on
			declare @id numeric, @Inicio datetime, @Final datetime 
			
			<cfif isdefined("form.CAMBIO") >
				update PeriodoEvaluacion	set 
					PEnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PEnombre#">, 
					PEcorto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PEcorto#">, 
					PEinicio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.PEinicio,'YYYYMMDD')#">,
					PEfinal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.PEfinal,'YYYYMMDD')#">
				where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				  and PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PLcodigo#">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)			  
	
				<cfset modo = "CAMBIO">
			</cfif>
			set nocount off
		</cfquery>
		<cfcatch type="any">
			<cfinclude template="/educ/errorpages/BDerror.cfm">		
			<cfabort>
		</cfcatch>
	</cftry>
	
</cfif>

<cfoutput>
<form action="PeriodoLectivo.cfm" method="post">
	<input type="hidden" name="modo" value="#modo#">
	<cfif isdefined("Form.nivel") and Len(Trim(Form.nivel)) NEQ 0>
		<cfif isdefined("Form.btnNuevo")>
			<input type="hidden" name="nivel" value="#Val(Form.nivel)+1#">
		<cfelse>
			<input type="hidden" name="nivel" value="#Form.nivel#">
		</cfif>
	</cfif>
	
	<cfif isdefined("Form.PLcodigo") and Len(Trim(Form.PLcodigo)) NEQ 0>
		<input type="hidden" name="PLcodigo" value="#Form.PLcodigo#">
	</cfif>
	<cfif isdefined("Form.PEcodigo") and Len(Trim(Form.PEcodigo)) NEQ 0>
		<input type="hidden" name="PEcodigo" value="#Form.PEcodigo#">
	</cfif>
	<cfif isdefined("Form.CILcodigo") and Len(Trim(Form.CILcodigo)) NEQ 0>
		<input type="hidden" name="CILcodigo" value="#Form.CILcodigo#">
	</cfif>
	<cfif isdefined("Form.CIEsemanas") and Len(Trim(Form.CIEsemanas)) NEQ 0>
		<input type="hidden" name="CIEsemanas" value="#Form.CIEsemanas#">
	</cfif>
	
	<input name="Pagina" type="hidden" value="<cfif isdefined("form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

