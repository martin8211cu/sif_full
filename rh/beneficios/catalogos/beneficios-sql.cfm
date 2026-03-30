<cfparam name="action" default="beneficios.cfm">

<cfif not isdefined("form.btnNuevo")>
	<cftransaction>

		<cfif isdefined("form.Alta")>
		
			<cfquery name="rsInsert" datasource="#session.DSN#">
				insert into RHBeneficios (Ecodigo, Bcodigo, Bdescripcion, Bmontostd, Bporcemp, Bperiodicidad, Mcodigo, Bobs, Brequierereg, Btercero, SNcodigo, BMUsucodigo, fechaalta)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Bcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Bdescripcion#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.Bmontostd#">, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.Bporcemp#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Bperiodicidad#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Mcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Bobs#" null="#Len(Trim(Form.Bobs)) EQ 0#">, 
					<cfif isdefined("Form.Brequierereg")>1<cfelse>0</cfif>, 
					<cfif isdefined("Form.Btercero")>1<cfelse>0</cfif>, 
					<cfif isdefined("Form.Btercero") and isdefined("Form.SNcodigo") and Len(Trim(Form.SNcodigo))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">, 
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
				table="RHBeneficios"
				redirect="beneficios.cfm"
				timestamp="#form.ts_rversion#"
				field1="Bid" 
				type1="numeric" 
				value1="#form.Bid#">

			<cfquery name="rsUpdate" datasource="#session.DSN#">
				update RHBeneficios set
					Bcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Bcodigo#">, 
					Bdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Bdescripcion#">, 
					Bmontostd = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.Bmontostd#">, 
					Bporcemp = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.Bporcemp#">, 
					Bperiodicidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Bperiodicidad#">, 
					Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Mcodigo#">, 
					Bobs = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Bobs#">, 
					Brequierereg = <cfif isdefined("Form.Brequierereg")>1<cfelse>0</cfif>, 
					Btercero = <cfif isdefined("Form.Btercero")>1<cfelse>0</cfif>, 
					<cfif isdefined("Form.Btercero") and isdefined("Form.SNcodigo") and Len(Trim(Form.SNcodigo))>
						SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
					<cfelse>
						SNcodigo = null
					</cfif>
				where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
			</cfquery>  

		<cfelseif isdefined("form.Baja")>

			<cfquery name="rsDelete" datasource="#session.DSN#">
				delete from RHBeneficios
				where Bid =  <cfqueryparam value="#form.Bid#" cfsqltype="cf_sql_numeric">
			</cfquery>

		</cfif>

	</cftransaction>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")>#Form.PageNum#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
