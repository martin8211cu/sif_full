<cfparam name="modo" default="ALTA">
			
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="insConcursos" datasource="#Session.DSN#">			
				insert into RHGruposAreasEval (Ecodigo, RHGcodigo, RHGdescripcion, RHGfecha,  Usucodigo)
        		values 
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHGcodigo#">)),
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHGdescripcion#">)), 
					 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
					 <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric"> 
				)
			</cfquery>
			<cf_translatedata name="set" tabla="RHGruposAreasEval" col="RHGdescripcion" valor="#Form.RHGdescripcion#" filtro="  Ecodigo = #session.Ecodigo#  and  rtrim(ltrim(RHGcodigo))='#trim(Form.RHGcodigo)#'">
		<cfset modo="CAMBIO">

		<cfelseif isdefined("Form.Baja")>
			<cfquery name="delRHAreasEvalConcurso" datasource="#Session.DSN#">
				delete from RHAreasEvalConcurso
				where exists (
					select 1 from RHEAreasEvaluacion a
					where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and a.RHGcodigo = <cfqueryparam value="#Form.RHGcodigo#" cfsqltype="cf_sql_char">
					  and RHAreasEvalConcurso.RHEAid = a.RHEAid
				)
			</cfquery>
					 
		<!---	<cfquery name="delRHDAreasEvaluacion" datasource="#Session.DSN#">
				<!--- 
				delete from RHDAreasEvaluacion 
				from RHEAreasEvaluacion a, RHDAreasEvaluacion b
				where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and a.RHGcodigo = <cfqueryparam value="#Form.RHGcodigo#" cfsqltype="cf_sql_char">
				  and a.RHEAid = b.RHEAid
				--->
				
				
				delete 
				from RHEAreasEvaluacion a
				where ((a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">) 
				    and (a.RHGcodigo = <cfqueryparam value="#Form.RHGcodigo#" cfsqltype="cf_sql_char">) 
				    and ((select count(*) from  RHDAreasEvaluacion b where b.RHEAid = a.RHEAid) = 0))
			</cfquery>--->
			
			<cfquery name="delRHDAreasEvaluacion" datasource="#Session.DSN#">
				delete from RHEAreasEvaluacion 
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHGcodigo = <cfqueryparam value="#Form.RHGcodigo#" cfsqltype="cf_sql_char">
			</cfquery>
				  
			<cfquery name="delRHGruposAreasEval" datasource="#Session.DSN#">
				delete from RHGruposAreasEval
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHGcodigo = <cfqueryparam value="#Form.RHGcodigo#" cfsqltype="cf_sql_char">
			</cfquery>
			 <cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp
				 datasource="#session.dsn#"
				 table="RHGruposAreasEval"
				 redirect="GruposAreasEval.cfm"
				 timestamp="#form.ts_rversion#"
				 field1="Ecodigo" type1="numeric" value1="#session.Ecodigo#"
 				 field2="RHGcodigo" type2="char" value2="#Form.RHGcodigo#">

			<cfquery name="updRHGruposAreasEval" datasource="#Session.DSN#">
				update RHGruposAreasEval set 
					RHGdescripcion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHGdescripcion#">, 
					RHGfecha		= <cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">
				where Ecodigo   = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHGcodigo = <cfqueryparam value="#Form.RHGcodigo#" cfsqltype="cf_sql_char">
			</cfquery>
			<cf_translatedata name="set" tabla="RHGruposAreasEval" col="RHGdescripcion" valor="#Form.RHGdescripcion#" filtro=" Ecodigo = #session.Ecodigo# and  rtrim(ltrim(RHGcodigo))='#trim(Form.RHGcodigo)#'">
			<cfset modo="CAMBIO">
		</cfif>
	
	<cfcatch type="database">
		<cfif listFindNoCase("547,2292",cfcatch.NativeErrorCode)><!--- error de sybase, oracle---->
			<cf_errorcode code="50581" msg="No se puede eliminar porque tiene datos asociados">
		<cfelseif listFindNoCase("2601,2627",cfcatch.NativeErrorCode)>
			<cf_errorcode code="50019" msg="El código del registro ya existe">
		<cfelse>
			<cfinclude template="/sif/errorPages/BDerror.cfm">
		</cfif>
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="GruposAreasEval.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	
	<input name="RHGcodigo" type="hidden" value="<cfif isdefined("Form.RHGcodigo")><cfoutput>#Form.RHGcodigo#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

