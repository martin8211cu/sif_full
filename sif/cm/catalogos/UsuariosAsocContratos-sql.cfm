<!--- Creado por: Rebeca Corrales Alfaro --->
<!--- Fecha: 22 de Julio, 2005           --->
<!--- Modificado por:                    --->
<!--- Fecha: 							 --->
<cfif isdefined ("form.Agregar") and isdefined ("form.Usucodigo") and len(trim(form.Usucodigo))>
	<cfquery name="insert" datasource="#session.DSN#">
		insert into CMContratoNotifica (ECid, Ecodigo, Usucodigo, BMUsucodigo, fechaalta )
			values( 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
	</cfquery>
<cfelseif isdefined ("form.CMClinea") and len(trim(form.CMClinea))>
	<cfquery name="delete" datasource="#session.DSN#">
		delete from CMContratoNotifica
		where CMClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMClinea#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>		
</cfif>
<form action="UsuariosAsocContratos.cfm" method="post" name="sql">
	<cfoutput>
	<cfif isdefined ("form.ECid")>
		<input name="ECid" type="hidden" value="#form.ECid#"> 
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