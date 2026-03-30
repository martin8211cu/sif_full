<cftransaction>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.CAMBIO")>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="COTipoRendicion"
						redirect="TiposDeRendicion.cfm"
						timestamp="#form.ts_rversion#"
						field1="COTRid" type1="numeric" value1="#form.COTRid#">
		<cfquery name="UpdSTipoRendicion" datasource="#session.DSN#">
			update COTipoRendicion
			set COTRCodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.COTRCodigo#">,				
				COTRDescripcion  = <cfqueryparam cfsqltype="cf_sql_char" value="#form.COTRDescripcion#">,				
				Ecodigo = #Session.Ecodigo#,				
				COTRGenDeposito =<cfif isdefined("form.COTRGenDeposito")>1<cfelse>0</cfif>, 				
				CcuentaGarantiaRecibida = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaGarantiaRecibida#" null="#Len(Form.CcuentaGarantiaRecibida) is 0#">,				
				CcuentaGarantiaPagar = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaGarantiaPagar#" <!---null="#Len(Form.CcuentaGarantiaPagar) is 0#"--->>,				
				CcuentaIngresoGarantia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaIngresoGarantia#" null="#Len(Form.CcuentaIngresoGarantia) is 0#">,				
				COTRmodificar = <cfif isdefined("form.COTRmodificar")>1<cfelse>0</cfif>, 				
                BMUsucodigo  = #session.Usucodigo#				
			where COTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COTRid#">
		</cfquery>		
	<cfset modo = "CAMBIO">
	
	</cfif>	
	
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsExiste" datasource="#Session.DSN#">
			select COTRCodigo 
			from COTipoRendicion  
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and COTRCodigo = <cfqueryparam value="#Form.COTRCodigo#" cfsqltype="cf_sql_char">
		</cfquery>
	
		<cfif rsExiste.RecordCount eq 0>
			<cfquery name="insertTipoRendicion" datasource="#Session.DSN#">
				insert into COTipoRendicion (COTRCodigo,COTRDescripcion,Ecodigo, COTRGenDeposito, CcuentaGarantiaRecibida, CcuentaGarantiaPagar,CcuentaIngresoGarantia,COTRmodificar,BMUsucodigo)
				values( <cfqueryparam cfsqltype="cf_sql_char" value="#form.COTRCodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.COTRDescripcion#">,
						#Session.Ecodigo#,
						<cfif isdefined("form.COTRGenDeposito") <!---and #form.COTRGenDeposito# EQ 'on'--->>1<cfelse>0</cfif>, 				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaGarantiaRecibida#" null="#Len(Form.CcuentaGarantiaRecibida) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaGarantiaPagar#" null="#Len(Form.CcuentaGarantiaPagar) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaIngresoGarantia#" null="#Len(Form.CcuentaIngresoGarantia) is 0#">,
                <cfif isdefined("form.COTRmodificar")>1<cfelse>0</cfif>, 				
                #session.Usucodigo# )
				
				
			</cfquery>							
		<cfelse>
			<cf_errorCode	code = "50019" msg = "El código del Regristro ya Existe.">
		</cfif>
	</cfif>
	
	
	<cfif isdefined("Form.Baja")>
		<cfquery name="Retenciones" datasource="#Session.DSN#">
			delete from COTipoRendicion
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and COTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COTRid#">
		</cfquery>		
	</cfif>
	
</cfif>
</cftransaction>


<form action="TiposDeRendicion.cfm" method="post" name="sql">
	<cfoutput>
		<input type="hidden" name="modo" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input type="hidden" name="COTRid"  value="<cfif isdefined("Form.COTRid")>#Form.COTRid#</cfif>">
	</cfoutput>
</form>


<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
