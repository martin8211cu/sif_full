<!--- <cf_dump var="#Form#"> --->
<cfset params = "">
<cfif isdefined("Form.btnAgregar")>

		<cfquery name="rsCta1" datasource="#Session.DSN#">
			SELECT a.CGEPctaBalance,
				<cfif Form.TipoAplica EQ "1">
					b.Ccuenta Cuenta
				<cfelse>
					b.CPcuenta Cuenta
				</cfif>
				FROM CGEstrProgCtaM a
				<cfif Form.TipoAplica EQ "1">
				  inner join CContables b
					on a.CGEPCtaMayor = b.Cmayor
				<cfelse>
					inner join CPresupuesto b
					on a.CGEPCtaMayor = b.Cmayor
				</cfif>
			where a.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
			<cfif Form.TipoAplica EQ "1"> and b.Ccuenta <cfelse> and b.CPcuenta </cfif> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cuenta1#">
		</cfquery>

		<cfquery name="rsCta2" datasource="#Session.DSN#">
			SELECT a.CGEPctaBalance,
				<cfif Form.TipoAplica EQ "1">
					b.Ccuenta Cuenta
				<cfelse>
					b.CPcuenta Cuenta
				</cfif>
				FROM CGEstrProgCtaM a
				<cfif Form.TipoAplica EQ "1">
				  inner join CContables b
					on a.CGEPCtaMayor = b.Cmayor
				<cfelse>
					inner join CPresupuesto b
					on a.CGEPCtaMayor = b.Cmayor
				</cfif>
			where a.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
			<cfif Form.TipoAplica EQ "1"> and b.Ccuenta <cfelse> and b.CPcuenta </cfif> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cuenta2#">
		</cfquery>

		<cfif rsCta1.Cuenta EQ rsCta2.Cuenta>
			<cfthrow message="No puede seleccionar la misma cuenta para netear">
		<cfelseif rsCta1.CGEPctaBalance EQ rsCta2.CGEPctaBalance>
			<cfthrow message="No se pueden netear cuentas de la misma naturaleza">
		<cfelse>
			<cfquery name="Transacciones" datasource="#Session.DSN#">
				INSERT INTO CGEstrProgCtasNeteo
		           (ID_Estr,Cuenta1,Cuenta2,signo1,signo2,TipoAplica,BMUsucodigo)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCta1.Cuenta#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCta2.Cuenta#">,
	                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCta1.CGEPctaBalance#">,
	                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCta2.CGEPctaBalance#">,
	                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.TipoAplica#">,
	                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						)
			</cfquery>
		</cfif>
<cfelseif isdefined("Form.btnEliminar")>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
            delete from CGEstrProgCtasNeteo
            where ID_Neteo = <cfqueryparam value="#Form.ID_Neteo#" cfsqltype="cf_sql_integer">
			and ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
		</cfquery>
<cfelse>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("")) & "t_cuenta=" & Form.TipoAplica>
</cfif>



<cfif isdefined("form.ID_Grupo")>
	<cfset params=params&"&ID_Grupo="&form.ID_Grupo>
</cfif>
<cfif isdefined("form.ID_Estr")>
	<cfset params=params&"&fID_Estr="&form.ID_Estr>
</cfif>

<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("")) & "tab=2">

<cflocation url="ConfigEstrProg.cfm?#params#">