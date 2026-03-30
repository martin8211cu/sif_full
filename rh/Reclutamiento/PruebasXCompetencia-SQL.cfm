	<cfparam name="modo" default="ALTA">

<!---SQL Pruebas --->
<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
		<cftry>
			<cfif isdefined("Form.Cambio")>
				 <!--- Borra todas las competencias según filtro y las vuelve a insertar --->
				<cfquery name="delRHPruebasCompetencia" datasource="#session.DSN#">
						delete from RHPruebasCompetencia
						where RHPCtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Tipo#">
						  and id 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Oid#">
					      and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>			
				<cfif isdefined("form.RHCGidList") and len(trim(form.RHCGidList)) gt 0> 
					<cfset arrayKeys = ListToArray(form.RHCGidList)>
					<cfloop from="1" to="#ArrayLen(arrayKeys)#" index="i">
						<cfquery name="rsRHPruebasCompetenciaInsert" datasource="#session.DSN#">
							insert into RHPruebasCompetencia
							(id, Ecodigo, RHPcodigopr, RHPCtipo)
							values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Oid#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#arrayKeys[i]#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#Tipo#">)
						</cfquery>
					</cfloop>
				</cfif>
				<cfset modo="CAMBIO">
			</cfif>
			<cfcatch type="database">
			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	</cfif>
</cftransaction>

<form action="PruebasXCompetencia.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif modo neq 'ALTA'>
		<input name="codigo" type="hidden" value="<cfif isdefined("Form.codigo")><cfoutput>#Form.codigo#</cfoutput></cfif>">
	</cfif>
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>