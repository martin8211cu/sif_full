<cfparam name="modo" default="CAMBIO">
<!---
<cfdump var="#Form#">
<cfdump var="#Session.DSN#">
--->

<cftry>	
	<cfquery name="abc_CiclosLectivos" datasource="#session.DSN#">
		<cfif isdefined("form.CAMBIO")>				
			update PeriodoTarifas set 
				PTmontoFijo=<cfqueryparam cfsqltype="cf_sql_float" value="#Form.PTmontoFijo#">
				<cfif isdefined('form.TTtipo') and form.TTtipo EQ 2>
					, PTmontoUnidad=<cfqueryparam cfsqltype="cf_sql_float" value="#Form.PTmontoUnidad#">
				</cfif>
			where PTcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PTcodigo#">
		</cfif>
	</cfquery>
	
	<cfcatch type="any">
		<cfinclude template="/educ/errorpages/BDerror.cfm">		
		<cfabort>
	</cfcatch>
</cftry>

<cfoutput>
<form action="PeriodoMatricula.cfm" method="post">
	<input type="hidden" name="modo" value="#modo#">
	<cfif isdefined("Form.nivel") and Len(Trim(Form.nivel)) NEQ 0>
		<cfif isdefined("Form.btnNuevo")>
			<input type="hidden" name="nivel" value="#Val(Form.nivel)+1#">
		<cfelse>
			<input type="hidden" name="nivel" value="#Form.nivel#">
		</cfif>
	</cfif>
	<cfif isdefined("Form.PEcodigo") and Len(Trim(Form.PEcodigo)) NEQ 0>
		<input type="hidden" name="PEcodigo" value="#Form.PEcodigo#">
	</cfif>
	<cfif isdefined("Form.PLcodigo") and Len(Trim(Form.PLcodigo)) NEQ 0>
		<input type="hidden" name="PLcodigo" value="#Form.PLcodigo#">
	</cfif>
	<cfif isdefined("Form.CILcodigo") and Len(Trim(Form.CILcodigo)) NEQ 0>
		<input type="hidden" name="CILcodigo" value="#Form.CILcodigo#">
	</cfif>
	<cfif isdefined("Form.CIEsemanas") and Len(Trim(Form.CIEsemanas)) NEQ 0>
		<input type="hidden" name="CIEsemanas" value="#Form.CIEsemanas#">
	</cfif>
	<cfif isdefined("Form.CILtipoCicloDuracion") and Len(Trim(Form.CILtipoCicloDuracion)) NEQ 0>
		<input type="hidden" name="CILtipoCicloDuracion" value="#Form.CILtipoCicloDuracion#">
	</cfif>
	<cfif isdefined("Form.PMsecuencia") and Len(Trim(Form.PMsecuencia)) NEQ 0>
		<input type="hidden" name="PMsecuencia" value="#Form.PMsecuencia#">
	</cfif>
	<input type="hidden" name="PTcodigo" value="#Form.PTcodigo#">
	
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

