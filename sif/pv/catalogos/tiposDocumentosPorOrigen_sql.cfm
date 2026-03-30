<cfif IsDefined("form.Cambio")>
		<cfquery name="update" datasource="#session.DSN#">
			update TDocumentosXOrigen	  
			set
			   	CCTcodigoAP = <cfqueryparam value="#form.CCTcodigoAP#" cfsqltype="cf_sql_char">,
				CCTcodigoCR = <cfqueryparam value="#form.CCTcodigoCR#" cfsqltype="cf_sql_char">,
				CCTcodigoFC = <cfqueryparam value="#form.CCTcodigoFC#" cfsqltype="cf_sql_char">,
				CCTcodigoDE = <cfqueryparam value="#form.CCTcodigoDE#" cfsqltype="cf_sql_char">,
				CCTcodigoRC = <cfqueryparam value="#form.CCTcodigoRC#" cfsqltype="cf_sql_char">
			where FAX01ORIGEN = <cfqueryparam  value="#Form.FAX01ORIGEN#" cfsqltype="cf_sql_char">
			  and Ecodigo     = <cfqueryparam  value="#session.Ecodigo#"  cfsqltype="cf_sql_integer">
		</cfquery> 

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
	   	 delete from TDocumentosXOrigen
	  	 where Ecodigo 		= <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	   	   and FAX01ORIGEN  = <cfqueryparam value="#Form.FAX01ORIGEN#" cfsqltype="cf_sql_char">
		   and Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into TDocumentosXOrigen( Ecodigo, FAX01ORIGEN, CCTcodigoAP,CCTcodigoDE, CCTcodigoFC, CCTcodigoCR, CCTcodigoRC)
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX01ORIGEN#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigoAP#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigoDE#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigoFC#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigoCR#" >,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigoRC#" >
				)
	</cfquery>			
</cfif>

<form action="tiposDocumentosPorOrigen.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="FAX01ORIGEN" type="hidden" value="#form.FAX01ORIGEN#"> 
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