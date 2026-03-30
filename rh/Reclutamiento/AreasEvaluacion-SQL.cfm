	<cfparam name="modo" default="ALTA">
	
<!--- <cfdump var="#form#">
<cfabort> --->
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="insRHEAreasEvaluacion" datasource="#Session.DSN#">			
				insert into RHEAreasEvaluacion (Ecodigo, RHGcodigo, RHEAdescripcion, RHEAcodigo 
					, Usucodigo, RHEApeso )
        		values 
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHGcodigo#">)),
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEAdescripcion#">)), 
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEAcodigo#">)),
					 <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> ,
					 (<cfqueryparam  cfsqltype="cf_sql_money" value="#Form.RHEApeso#" scale="2"> )
				)
				<cf_dbidentity1>
			</cfquery>
            <cf_dbidentity2 name="insRHEAreasEvaluacion">
            <cf_translatedata name="set" tabla="RHEAreasEvaluacion" col="RHEAdescripcion" valor="#Form.RHEAdescripcion#" filtro=" RHEAid = #insRHEAreasEvaluacion.identity# ">
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Baja")>
			<cfquery name="delRHAreasEvalConcurso" datasource="#Session.DSN#">
				delete from RHAreasEvalConcurso
				where exists (
					select 1 from RHEAreasEvaluacion a
					where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and a.RHGcodigo = <cfqueryparam value="#Form.RHGcodigo#" cfsqltype="cf_sql_char">
					and a.RHEAid = <cfqueryparam value="#Form.RHEAid#" cfsqltype="cf_sql_numeric">
					and RHAreasEvalConcurso.RHEAid = a.RHEAid
				)
			</cfquery>
			<cfquery name="delRHDAreasEvaluacion" datasource="#Session.DSN#">
				delete from RHDAreasEvaluacion 
				from RHEAreasEvaluacion a, RHDAreasEvaluacion b
				where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and a.RHGcodigo = <cfqueryparam value="#Form.RHGcodigo#" cfsqltype="cf_sql_char">
				  and a.RHEAid = <cfqueryparam value="#Form.RHEAid#" cfsqltype="cf_sql_numeric">
				  and a.RHEAid = b.RHEAid
			</cfquery>
			
			<cfquery name="delRHEAreasEvaluacion" datasource="#Session.DSN#">
				delete from RHEAreasEvaluacion
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHGcodigo = <cfqueryparam value="#Form.RHGcodigo#" cfsqltype="cf_sql_char">
				  and RHEAid = <cfqueryparam value="#Form.RHEAid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			 <cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="updRHEAreasEvaluacion" datasource="#Session.DSN#">
				update RHEAreasEvaluacion set 
					RHEAcodigo 		= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHEAcodigo#">,
					RHEAdescripcion	=  rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEAdescripcion#">)), 
 					RHEApeso		= <cfqueryparam value="#Form.RHEApeso#" cfsqltype="cf_sql_money" scale="2">,
					RHGcodigo		= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHGcodigo#">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHEAid  = <cfqueryparam value="#Form.RHEAid#" cfsqltype="cf_sql_numeric">
				  
			</cfquery>
            <cf_translatedata name="set" tabla="RHEAreasEvaluacion" col="RHEAdescripcion" valor="#Form.RHEAdescripcion#" filtro=" RHEAid = #Form.RHEAid#">
			<cfset modo="CAMBIO">
		</cfif>
	
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="AreasEvaluacion.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif modo neq 'ALTA'>
		<input name="RHEAid" type="hidden" value="<cfif isdefined("Form.RHEAid")><cfoutput>#Form.RHEAid#</cfoutput></cfif>">
	</cfif>
	<input name="RHGcodigo" type="hidden" value="<cfif isdefined("Form.RHGcodigo")><cfoutput>#Form.RHGcodigo#</cfoutput></cfif>">
	<input name="RHEAcodigo" type="hidden" value="<cfif isdefined("Form.RHEAcodigo")><cfoutput>#Form.RHEAcodigo#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

