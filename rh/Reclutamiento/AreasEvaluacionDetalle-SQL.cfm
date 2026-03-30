	<cfparam name="modo" default="ALTA">


<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")> 
			<cfquery name="insRHDAreasEvaluacion" datasource="#Session.DSN#">			
				insert INTO RHDAreasEvaluacion (RHEAid, Ecodigo, RHDAdescripcion, RHDAnotamin , RHDAobs, RHDAfecha, Usucodigo)
        		values 
				   (<cfqueryparam  cfsqltype="cf_sql_numeric" value="#form.RHEAid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHDAdescripcion#">)), 
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDAnotamin#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHDAobs#">,
 					 <cfqueryparam value="#LSParseDateTime(Form.fFechaA)#" cfsqltype="cf_sql_timestamp">,
					 <cfqueryparam  cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">)
				   <cf_dbidentity1>
			</cfquery>
			<cf_dbidentity2 name="insRHDAreasEvaluacion">
			<cf_translatedata name="set" tabla="RHDAreasEvaluacion" col="RHDAdescripcion" valor="#Form.RHDAdescripcion#" filtro="RHDAlinea=#insRHDAreasEvaluacion.identity#">
			<cf_translatedata name="set" tabla="RHDAreasEvaluacion" col="RHDAobs" valor="#Form.RHDAobs#" filtro="RHDAlinea=#insRHDAreasEvaluacion.identity#">
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="delRHDAreasEvaluacion" datasource="#Session.DSN#">
				delete from RHDAreasEvaluacion
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHEAid = <cfqueryparam value="#Form.RHEAid#" cfsqltype="cf_sql_numeric">
				  and RHDAlinea = <cfqueryparam value="#Form.RHDAlinea#" cfsqltype="cf_sql_numeric">
			</cfquery>
			 <cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="updRHDAreasEvaluacion" datasource="#Session.DSN#">
				update RHDAreasEvaluacion set 
					RHDAdescripcion	=  rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHDAdescripcion#">)), 
 					RHDAnotamin		= <cfqueryparam value="#Form.RHDAnotamin#" cfsqltype="cf_sql_money" scale="4">,
					RHDAobs		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHDAobs#">,
					RHDAfecha   = <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fFechaA)#">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHEAid = <cfqueryparam value="#Form.RHEAid#" cfsqltype="cf_sql_numeric">
				  and RHDAlinea = <cfqueryparam value="#Form.RHDAlinea#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cf_translatedata name="set" tabla="RHDAreasEvaluacion" col="RHDAdescripcion" valor="#Form.RHDAdescripcion#" filtro="RHDAlinea=#Form.RHDAlinea#">
			<cf_translatedata name="set" tabla="RHDAreasEvaluacion" col="RHDAobs" valor="#Form.RHDAobs#" filtro="RHDAlinea=#Form.RHDAlinea#">
			
			<cfset modo="CAMBIO">
		</cfif>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="AreasEvaluacionDetalle.cfm" method="post" name="sql">
	<input name="modo"       type="hidden"  value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="RHEAid"     type="hidden"  value="<cfif isdefined("Form.RHEAid")><cfoutput>#Form.RHEAid#</cfoutput></cfif>">
	<input name="RHGcodigo"  type="hidden"  value="<cfif isdefined("Form.RHGcodigo")><cfoutput>#Form.RHGcodigo#</cfoutput></cfif>">
	<input name="RHEAcodigo" type="hidden"  value="<cfif isdefined("Form.RHEAcodigo")><cfoutput>#Form.RHEAcodigo#</cfoutput></cfif>">
	<input name="RHDAlinea"  type="hidden"  value="<cfif isdefined("Form.RHDAlinea")><cfoutput>#Form.RHDAlinea#</cfoutput></cfif>">
	<input name="usucodigo"  type="hidden"  id="usucodigo"  value="<cfif isdefined("form.usucodigo")><cfoutput>#form.usucodigo#</cfoutput></cfif>">
    <input name="Pagina"     type="hidden"  value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

