<cfif not isdefined("Form.btnNuevo")>
	<!--- procesa la imagen --->
	<cfif isdefined("form.btnAgregar") or isdefined("form.btnCambiar")>
		<cfif isdefined("form.logo") and Len(Trim(form.logo)) gt 0 >
			<cfinclude template="../../utiles/imagen.cfm">
		</cfif>
	</cfif>

	<cfif isdefined("Form.SScodigo") and Len(Trim(Form.SScodigo)) NEQ 0 and isdefined("Form.SMcodigo") and Len(Trim(Form.SMcodigo)) NEQ 0>
		<cfif isdefined("Form.btnEliminar")>
			<cfquery name="rs" datasource="asp">
				delete from ModulosCuentaE
				where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
				and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigo#">
			</cfquery>
			<cfquery name="rs" datasource="asp">
				delete from SModulos
				where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
				and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigo#">
			</cfquery>
		<cfelse>
			<cfquery name="rs" datasource="asp">
				update SModulos
				   set SMdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SMdescripcion#">,
				   	   SMhomeuri = 	<cfif len(trim(Form.SMhomeuri)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SMhomeuri#"><cfelse>null</cfif>,
					   SMmenu = <cfif isdefined("form.SMmenu")>1<cfelse>0</cfif>,
					   SMorden = <cfif len(trim(form.SMorden)) gt 0 ><cfqueryparam cfsqltype="cf_sql_integer" value="#form.SMorden#"><cfelse>null</cfif>,
					   <cfif isdefined("ts")>SMlogo = <cfqueryparam cfsqltype="cf_sql_blob" value="#tmp#">,</cfif>
					   SMhablada = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.SMhablada#">,
					   SGcodigo =  <cfif len(trim(form.SGcodigo)) gt 0>	LTRIM(RTRIM(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SGcodigo#">))
									<cfelse>null</cfif>
				where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
				and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigo#">
			</cfquery>
		</cfif>

	<cfelseif isdefined("Form.SScodigo_text") and Len(Trim(Form.SScodigo_text)) NEQ 0 and isdefined("Form.SMcodigo_text") and Len(Trim(Form.SMcodigo_text)) NEQ 0>
		<cfquery name="rs" datasource="asp">
			insert into SModulos (SScodigo, SMcodigo, SMdescripcion, SMhomeuri, SMmenu, SMorden, SMlogo, SMhablada, BMUsucodigo, BMfecha, SGcodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo_text#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigo_text#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SMdescripcion#">,
				<cfif len(trim(Form.SMhomeuri)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SMhomeuri#"><cfelse>null</cfif>,
				<cfif isdefined("form.SMmenu")>1<cfelse>0</cfif>,
				<cfif len(trim(form.SMorden)) gt 0 ><cfqueryparam cfsqltype="cf_sql_integer" value="#form.SMorden#"><cfelse>null</cfif>,
				<cfif isdefined("ts")><cfqueryparam cfsqltype="cf_sql_blob" value="#tmp#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.SMhablada#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfif len(trim(form.SGcodigo)) gt 0>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SGcodigo#">
				<cfelse>null</cfif>
			)
		</cfquery>
	</cfif>
</cfif>

<cfoutput>
	<form action="<cfif isdefined("form.btnProcesos")>procesos.cfm<cfelse>modulos.cfm</cfif>" method="post" name="sql">
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
		<cfif isdefined("Form.FSScodigo")>
			<input type="hidden" name="FSScodigo" value="#Form.FSScodigo#">
		</cfif>
		<cfif isdefined("Form.FSMcodigo")>
			<input type="hidden" name="FSMcodigo" value="#Form.FSMcodigo#">
		</cfif>
		<cfif isdefined("Form.FSMdescripcion")>
			<input type="hidden" name="FSMdescripcion" value="#Form.FSMdescripcion#">
		</cfif>

		<cfif isdefined("form.btnProcesos") and len(trim(form.btnProcesos)) gt 0>
			<input type="hidden" name="SScodigo" value="#form.SScodigo#">
			<input type="hidden" name="SMcodigo" value="#form.SMcodigo#">
			<cfif not isdefined("form.fSScodigo")><input type="hidden" name="FSScodigo" value="#Form.SScodigo#"></cfif>
			<cfif not isdefined("form.fSMcodigo")><input type="hidden" name="FSMcodigo" value="#Form.SMcodigo#"></cfif>
		</cfif>


	</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>