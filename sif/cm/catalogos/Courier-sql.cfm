<cfif not isdefined("form.btnNuevo")>
	<cftransaction>
		<cfif isdefined("Form.Alta")>
			<cfquery name="Courier_ABC" datasource="sifcontrol">
				insert into Courier (CRcodigo, CRdescripcion, Usucodigo, Curl
				<cfif not (isdefined("Form.courier") and Form.courier EQ "PSO")>
				,CEcodigo, Ecodigo, EcodigoSDC
				</cfif>
				)
				values (
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CRcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CRdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Curl#" null="#Len(Trim(Form.Curl)) EQ 0#">
					<cfif not (isdefined("Form.courier") and Form.courier EQ "PSO")>
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					,<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
					</cfif>
				)
				<cf_dbidentity1 datasource="sifcontrol">
			</cfquery>
			<cf_dbidentity2 datasource="sifcontrol" name="Courier_ABC">
		
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="Courier_ABC" datasource="sifcontrol">
				update Courier set 
					CRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CRcodigo#">,
					CRdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CRdescripcion#">,
					Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					Curl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Curl#" null="#Len(Trim(Form.Curl)) EQ 0#">
				where CRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRid#">
				<cfif not (isdefined("Form.courier") and Form.courier EQ "PSO")>
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
				</cfif>
			</cfquery>
		
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="Courier_ABC" datasource="sifcontrol">
				delete from Courier
				where CRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRid#">
				<cfif not (isdefined("Form.courier") and Form.courier EQ "PSO")>
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
				</cfif>
			</cfquery>		
		</cfif>
	</cftransaction>
</cfif>

<cfoutput>
<cfif not (isdefined("Form.courier") and Form.courier EQ "PSO")>
	<cfset accion = "Courier.cfm">
<cfelse>
	<cfset accion = "Courierpso.cfm">
</cfif>
<form action="#accion#" method="post" name="sql">
	<cfif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
		<input name="PageNum" type="hidden" value="#Form.PageNum#">
	</cfif>
	<cfif isdefined("Form.Cambio") and isdefined("Form.CRid") and Len(Trim(Form.CRid))>
		<input name="CRid" type="hidden" value="#Form.CRid#">
	<cfelseif isdefined("Courier_ABC.identity") and len(trim(Courier_ABC.identity))>
		<input name="CRid" type="hidden" value="#Courier_ABC.identity#">
	</cfif>
</form>
</cfoutput>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
