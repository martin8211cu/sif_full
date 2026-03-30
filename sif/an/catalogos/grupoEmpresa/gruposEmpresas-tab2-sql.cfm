<!--- <cfif IsDefined("form.Cambio")> --->
 <cftransaction>
		<cfquery datasource="#session.dsn#" name="idquery">
			delete from AnexoGEmpresaDet
			where GEid = <cfqueryparam value="#Form.GEid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfif IsDefined("form.EmpresasCB")>
			<cfloop list="#form.EmpresasCB#" index="i">	
				<cfquery datasource="#session.dsn#" name="idquery">
					insert into AnexoGEmpresaDet( GEid, Ecodigo,BMfecha,BMUsucodigo)
					values(	
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GEid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value = "#i#">,
						<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>	

<!--- redirecciona al form en el tab 2--->
<cfset path = "gruposEmpresas-tabs.cfm?tab=2">
<form action="<cfoutput>#path#</cfoutput>" method="post" name="sql">
	<cfoutput>
		<input name="GEid" type="hidden" value="#form.GEid#"> 
		
		<cfif isdefined('form.Codigo_F') and len(trim(form.Codigo_F))>
			<input type="hidden" name="Codigo_F" value="#form.Codigo_F#">	
		</cfif>
		<cfif isdefined('form.Descripcion_F') and len(trim(form.Descripcion_F))>
			<input type="hidden" name="Descripcion_F" value="#form.Descripcion_F#">	
		</cfif>
		
	</cfoutput>
</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>
