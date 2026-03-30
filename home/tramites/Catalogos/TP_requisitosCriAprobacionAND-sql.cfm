
<cfif isdefined('url.id_requisito') and not isdefined('form.id_requisito')>
	<cfparam name="form.id_requisito" default="#url.id_requisito#">
</cfif>
	
	<cfif #form.radio# EQ 1><!--- pone en uno el compo es_criterio_and en la tabla TPRequisito--->
		
		<cfquery  name="upTPRequisitos" datasource="#session.tramites.dsn#">
			update TPRequisito  set
			es_criterio_and 	=	 1
			where 	id_requisito = <cfqueryparam value="#form.id_requisito#" cfsqltype="cf_sql_numeric">
		</cfquery>
	
	<cfelse>
		
		<cfquery  name="upTPRequisitos" datasource="#session.tramites.dsn#">
			update TPRequisito  set
			es_criterio_and 	=	 0
			where 	id_requisito = <cfqueryparam value="#form.id_requisito#" cfsqltype="cf_sql_numeric">
		</cfquery>
		
	</cfif>
	


<cfset dir= "Tp_Requisitos.cfm?tab=8&id_requisito=#JSStringFormat(form.id_requisito)#">
 
<form action='<cfoutput>#dir#</cfoutput>' method="post" name="sql">
</form>	
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>
