<cfif IsDefined("reqReferencia")>
	<cfset reqRef=1>
<cfelse>
	<cfset reqRef=0>
</cfif>
<cfif IsDefined("ReqCotizacion")>
	<cfset ReqCot='S'>
<cfelse>
	<cfset ReqCot='N'>
</cfif>
<cfif IsDefined("form.Cambio")>
<cftransaction>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="FATiposAdelanto" 
			redirect="tiposAdelantos.cfm"
			timestamp="#form.ts_rversion_Ade#"
			field1="IdTipoAd,numeric,#form.IdTipoAd#">
	
		<cfquery name="update" datasource="#session.DSN#">
			update FATiposAdelanto	
			set	CodInterno = <cfqueryparam value="#form.CodInterno#" cfsqltype="cf_sql_char">,
				Descripcion = <cfqueryparam value="#Form.Descripcion#" cfsqltype="cf_sql_char">,
				BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">,
				ReqReferencia = #reqRef#,
				ReqCotizacion = '#ReqCot#',
				TipoTrans= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TipoTrans#" null="#len(trim(form.TipoTrans)) is 0#">
			where IdTipoAd = <cfqueryparam value="#Form.IdTipoAd#" cfsqltype="cf_sql_numeric">
		</cfquery> 
	</cftransaction>	
	
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
	   	 delete from FATiposAdelanto
	  	 where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	   	 and IdTipoAd = <cfqueryparam value="#Form.IdTipoAd#" cfsqltype="cf_sql_numeric">
	</cfquery>

<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into FATiposAdelanto( Ecodigo, CodInterno, Descripcion, BMUsucodigo, fechaalta, CFcuenta,ReqReferencia,ReqCotizacion, TipoTrans)
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.CodInterno#">,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#form.Descripcion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">,
				#reqRef#,
				'#ReqCot#',
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TipoTrans#" null="#len(trim(form.TipoTrans)) is 0#">)
	</cfquery>			
</cfif>

<form action="tiposAdelantos.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="IdTipoAd" type="hidden" value="#form.IdTipoAd#"> 
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