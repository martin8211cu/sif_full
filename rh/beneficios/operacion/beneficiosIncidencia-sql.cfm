<cfparam name="action" default="beneficiosIncidencia.cfm">

<cfif not isdefined("form.btnNuevo")>

	<cftransaction>
		<cfif isdefined("form.Alta")>

			<!--- Validar que la línea corresponde al empleado --->
			<cfquery name="rsValidar" datasource="#Session.DSN#">
				select 1
				from RHBeneficiosEmpleado a
				where a.BElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BElinea#">
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfquery>
			<cfif rsValidar.recordCount EQ 0>
				<cfthrow message="El Beneficio no corresponde al empleado seleccionado">
			</cfif>
		
			<cfquery name="rsInsert" datasource="#session.DSN#">
				insert into HIBeneficios (Ecodigo, BElinea, Mcodigo, HIBfecha, HIBmonto, HIBcant, HIBporcemp, SNcodigo, BMUsucodigo, fechaalta)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BElinea#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Mcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.HIBfecha)#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.HIBmonto#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.HIBcant#">, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.HIBporcemp#">, 
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
				datasource="#session.DSN#"
				table="HIBeneficios"
				redirect="beneficiosIncidencia.cfm"
				timestamp="#form.ts_rversion#"
				field1="HIBlinea" 
				type1="numeric" 
				value1="#form.HIBlinea#">

			<cfquery name="rsUpdate" datasource="#session.DSN#">
				update HIBeneficios set
					Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Mcodigo#">, 
					HIBfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.HIBfecha)#">, 
					HIBmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.HIBmonto#">, 
					HIBcant = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.HIBcant#">, 
					HIBporcemp = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.HIBporcemp#">, 
					<cfif isdefined("Form.Btercero") and isdefined("Form.SNcodigo") and Len(Trim(Form.SNcodigo))>
						SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
					<cfelse>
						SNcodigo = null
					</cfif>
				where HIBlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.HIBlinea#">
			</cfquery>  

		<cfelseif isdefined("form.Baja")>

			<cfquery name="rsDelete" datasource="#session.DSN#">
				delete from HIBeneficios
				where HIBlinea = <cfqueryparam value="#form.HIBlinea#" cfsqltype="cf_sql_numeric">
			</cfquery>

		</cfif>

	</cftransaction>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")>#Form.PageNum#</cfif>">
	<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
		<input name="DEid" type="hidden" value="<cfif isdefined("Form.DEid")>#Form.DEid#</cfif>">
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
