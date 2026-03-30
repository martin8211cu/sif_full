<cfparam name="action" default="editarIndic.cfm">
<cfset tieneParam = 0>

<cfif isdefined("form.accion") and form.accion NEQ '*'>
	<cfif form.accion EQ 'delete' and isdefined("form.codIndic") and form.codIndic NEQ '*'>
		<cfquery datasource="asp">
			delete IndicadorUsuario
			where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			  and indicador=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codIndic#">
		</cfquery>
	<cfelseif form.accion EQ 'insert'>	
		<cfquery datasource="asp">
			insert into IndicadorUsuario (Usucodigo, indicador, posicion, BMfecha, BMUsucodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.indicador#">, 
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.posicion#">, 
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )	
		</cfquery>	
		
		<cfquery name="rsParam" datasource="asp">
			Select i.indicador, parametro
			from Indicador i
				left outer join IndicadorParam ip
					on ip.indicador=i.indicador
			where i.indicador=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.indicador#">
		</cfquery>
		<!--- Si el indicador tiene parametros ? --->
		<cfif isdefined('rsParam') and rsParam.recordCount GT 0>
			<cfset tieneParam = 1>
			<cfset action = "editarIndic-param.cfm">
		</cfif>
	<!--- Insercion de los parametros del indicador --->
	<cfelseif form.accion EQ 'insertParam' and isdefined('form.indicador') and form.indicador NEQ ''>	
		<cfset tieneParam = 1>
		<cfset action = "editarIndic-param.cfm">
	</cfif>
</cfif>

<cfoutput>
	<form action="#action#" method="post" name="sql">
		<cfif tieneParam EQ 1 and isdefined('form.indicador') and form.indicador NEQ ''>
			<input name="indicador" type="hidden" value="#form.indicador#">
		</cfif>
	</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
