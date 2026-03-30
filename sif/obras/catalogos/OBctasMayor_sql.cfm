<cfif isdefined("form.btnAgregar")>
	<cfif NOT isdefined("form.OBCcontrolCuentas") AND NOT isdefined("form.OBCliquidacion")>
		<cf_errorCode	code = "50415" msg = "Una Cuenta Mayor debe tener Control de Cuentas o Liquidacion">
	</cfif>
	<cfquery datasource="#session.dsn#">
		insert into OBctasMayor
			(Ecodigo, Cmayor, OBCcontrolCuentas, OBCliquidacion)
		values(
			#session.Ecodigo#
			,<cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#" null="#form.Cmayor EQ ""#">
			,<cfif isdefined("form.OBCcontrolCuentas")>1<cfelse>0</cfif>
			,<cfif isdefined("form.OBCliquidacion")>1<cfelse>0</cfif>
		)
	</cfquery>
<cfelseif isdefined("url.btnBorrar")>
	<cfquery datasource="#session.dsn#">
		delete from OBctasMayor
		 where Ecodigo	= #session.Ecodigo#
		   and Cmayor	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#" null="#form.Cmayor EQ ""#">
	</cfquery>
<cfelseif isdefined("url.btnControlCtas")>
	<cfquery datasource="#session.dsn#">
		update OBctasMayor
		   set OBCcontrolCuentas = <cfif isdefined ('url.op') and url.op  EQ "add">1<cfelse>case when OBCliquidacion = 1 then 0 else 1 end</cfif>
		 where Ecodigo	= #session.Ecodigo#
		   and Cmayor	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#" null="#form.Cmayor EQ ""#">
	</cfquery>
<cfelseif isdefined("url.btnLiquidacion")>
	<cfquery datasource="#session.dsn#">
		update OBctasMayor
		   set OBCliquidacion = <cfif url.op EQ "add">1<cfelse>case when OBCcontrolCuentas = 1 then 0 else 1 end</cfif>
		 where Ecodigo	= #session.Ecodigo#
		   and Cmayor	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#" null="#form.Cmayor EQ ""#">
	</cfquery>
</cfif>

<cflocation url="OBctasMayor.cfm">

