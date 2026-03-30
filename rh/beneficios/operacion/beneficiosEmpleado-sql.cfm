<cfparam name="action" default="beneficiosEmpleado.cfm">

<cfif not isdefined("form.btnNuevo")>
	<cftransaction>

		<cfif isdefined("form.Alta")>
		
			<cfquery name="rsInsert" datasource="#session.DSN#">
				insert into RHBeneficiosEmpleado (Ecodigo, DEid, Bid, Mcodigo, BEfdesde, BEfhasta, BEmonto, BEporcemp, SNcodigo, BEactivo, fechainactiva, BMUsucodigo, fechaalta)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.BEfdesde)#">, 
					<cfif Len(Trim(Form.BEfhasta))>
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.BEfhasta)#">, 
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.BEmonto#">, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.BEporcemp#">, 
					<cfif isdefined("Form.SNcodigo") and Len(Trim(Form.SNcodigo))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">, 
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("Form.BEactivo")>0<cfelse>1</cfif>, 
					<cfif isdefined("Form.BEactivo") and isdefined("Form.fechainactiva") and Len(Trim(Form.fechainactiva))>
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.fechainactiva)#">, 
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
			</cfquery>

		<cfelseif isdefined("form.Cambio")>
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="RHBeneficiosEmpleado"
				redirect="beneficiosEmpleado.cfm"
				timestamp="#form.ts_rversion#"
				field1="BElinea" 
				type1="numeric" 
				value1="#form.BElinea#">

			<cfquery name="rsUpdate" datasource="#session.DSN#">
				update RHBeneficiosEmpleado set
					Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">, 
					BEfdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.BEfdesde)#">, 
					<cfif Len(Trim(Form.BEfhasta))>
						BEfhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.BEfhasta)#">, 
					<cfelse>
						BEfhasta = null,
					</cfif>
					BEmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.BEmonto#">, 
					BEporcemp = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.BEporcemp#">, 
					<cfif isdefined("Form.SNcodigo") and Len(Trim(Form.SNcodigo))>
						SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">, 
					<cfelse>
						SNcodigo = null,
					</cfif>
					<cfif isdefined("Form.BEactivo")>BEactivo = 0<cfelse>BEactivo = 1</cfif>, 
					<cfif isdefined("Form.BEactivo") and isdefined("Form.fechainactiva") and Len(Trim(Form.fechainactiva))>
						fechainactiva = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.fechainactiva)#">, 
					<cfelse>
						fechainactiva = null,
					</cfif>
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					fechaalta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where BElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BElinea#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfquery>  

		<cfelseif isdefined("form.Baja")>

			<cfquery name="rsDelete" datasource="#session.DSN#">
				delete from RHBeneficiosEmpleado
				where BElinea = <cfqueryparam value="#form.BElinea#" cfsqltype="cf_sql_numeric">
			</cfquery>

		</cfif>

	</cftransaction>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="PageNum2" type="hidden" value="<cfif isdefined("Form.PageNum2")>#Form.PageNum2#</cfif>">
	<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
		<input type="hidden" name="DEid" value="#Form.DEid#">
	</cfif>
</form>
</cfoutput>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
