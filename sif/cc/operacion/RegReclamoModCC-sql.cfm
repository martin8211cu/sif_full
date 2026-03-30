<cfif isdefined("form.Aplicar")>
	<cftransaction>
		<cfquery datasource="#session.DSN#">
			update HDocumentos
			set 
					  DEnumReclamo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEnumReclamo#">
					, DEordenCompra = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEordenCompra#">
				<cfif isdefined('Form.CDCcodigo') and len(trim(form.CDCcodigo)) GT 0>
					, CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
				<cfelse>
					, CDCcodigo = null
				</cfif>
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				<cfif isdefined("form.HDid") and len(form.HDid) GT 0>
					and HDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.HDid#">
				</cfif> 
				and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
				and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ddocumento#">
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		</cfquery>

		<cfquery datasource="#session.DSN#">
			update Documentos
			set DEnumReclamo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEnumReclamo#">,
				DEordenCompra = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEordenCompra#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
				and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ddocumento#">
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		</cfquery>

	</cftransaction>
</cfif>

<form action="RegReclamoModCC.cfm" method="post" name="sql">
	<input name="HDid" type="hidden" value="<cfoutput>#form.HDid#</cfoutput>">
	<input name="CCTcodigo" type="hidden" value="<cfoutput>#form.CCTcodigo#</cfoutput>">
	<input name="Ddocumento" type="hidden" value="<cfoutput>#form.Ddocumento#</cfoutput>">
	<input name="SNcodigo" type="hidden" value="<cfoutput>#form.SNcodigo#</cfoutput>">
	
	<cfoutput>
			<cfif isdefined("Form.CCTcodigoE1") and Len(Trim(Form.CCTcodigoE1))>
				<input type="hidden" name="CCTcodigoE1" value="#Form.CCTcodigoE1#" />
			</cfif>
			<cfif isdefined("Form.CCTcodigoE2") and Len(Trim(Form.CCTcodigoE2))>
				<input type="hidden" name="CCTcodigoE2" value="#Form.CCTcodigoE2#" />
			</cfif>
			<cfif isdefined("Form.Corte") and Len(Trim(Form.Corte))>
				<input type="hidden" name="Corte" value="#form.Corte#" />
			</cfif>
			<cfif isdefined("Form.Corte2") and Len(Trim(Form.Corte2))>
				<input type="hidden" name="Corte2" value="#form.Corte2#" />
			</cfif>
			<cfif isdefined("Form.Documento") and Len(Trim(Form.Documento))>
				<input type="hidden" name="Documento" value="#form.Documento#" />
			</cfif>

			<cfif isdefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo))>
				<input type="hidden" name="Mcodigo" value="#form.Mcodigo#" />
			</cfif>
			<cfif isdefined('form.Pagina')>
				<input name="Pagina" type="hidden" value="#form.Pagina#">
			</cfif>
	</cfoutput>	
	
	
	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>