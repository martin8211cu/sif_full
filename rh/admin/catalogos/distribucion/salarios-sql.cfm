<cfparam name="modo" default="ALTA">
<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.btnAplicar")>
			<cfquery name="insRHOEnfasis" datasource="#Session.DSN#">			
				delete from DistEmpCompSal
				where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				and Ecodigo = 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">					
			</cfquery>
			
			<cfif isdefined("form.RHCGIDLIST") and len(trim(form.RHCGIDLIST))>
				<cfset arreglo = listtoarray(form.RHCGIDLIST)>	
				<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
					<cfset arreglo2 = listtoarray(arreglo[i],'|')>	
					<cfquery name="insDistEmpCompSal" datasource="#Session.DSN#">			
						insert into DistEmpCompSal (DEid,CFid,DECSporcentaje,Ecodigo,BMfecha,BMUsucodigo)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo2[1]#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#arreglo2[2]#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">					
						)	 
					</cfquery>
				</cfloop>
			</cfif>		
		</cfif>
	</cfif>
</cftransaction>

<form action="distribucion.cfm" method="post" name="sql">
	<input name="O" type="hidden" value="1">
	<input name="SEL" type="hidden" value="1">
	<input type="hidden" name="DEid"   			id="DEid"    value="<cfoutput>#form.DEid#</cfoutput>">
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>