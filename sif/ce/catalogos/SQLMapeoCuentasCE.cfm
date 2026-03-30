<cfparam name="modom" default="ALTA">
<cfquery name="nivel" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE'
</cfquery>

<!---cfif isdefined("form.Mayor_cuenta")>
	<cfquery name="cuenta" datasource="#Session.DSN#">
		SELECT Ccuenta FROM  CContables WHERE Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cmayor#">
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		INSERT INTO CEMapeoSAT(CCuentaSAT, CAgrupador, Ccuenta, Ecodigo, BMUsucodigo, FechaGeneracion)
		VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">, #cuenta.Ccuenta#, #Session.Ecodigo#, #session.Usucodigo#, SYSDATETIME())
	</cfquery>
	<cfset modom="ALTA">
</cfif>
<cfif isdefined("form.Mayor_subcuenta")>
	<cfquery name="cuentas" datasource="#Session.DSN#">
		SELECT Ccuenta FROM  CContables WHERE Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cmayor#">
	</cfquery>
	<cfloop query="cuentas">
		<cfquery datasource="#Session.DSN#">
			INSERT INTO CEMapeoSAT(CCuentaSAT, CAgrupador, Ccuenta, Ecodigo, BMUsucodigo, FechaGeneracion)
		    VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">, #cuentas.Ccuenta#, #Session.Ecodigo#, #session.Usucodigo#, SYSDATETIME())
		</cfquery>
	</cfloop>
	<cfset modom="ALTA">
</cfif--->
<cfif isdefined("Subcuenta_cuenta")>
	<cfquery name="subcuenta" datasource="#Session.DSN#">
		SELECT Ccuenta FROM  CContables
		WHERE Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#">
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		INSERT INTO CEMapeoSAT(CCuentaSAT, CAgrupador, Ccuenta, Ecodigo, BMUsucodigo, FechaGeneracion)
		VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">, #subcuenta.Ccuenta#, #Session.Ecodigo#, #session.Usucodigo#, SYSDATETIME())
	</cfquery>
	<cfset modom="ALTA">
</cfif>
<cfif isdefined("Subcuenta_subcuenta")>
	<cfif '#nivel.Pvalor#' neq '-1'>
		<cfquery name="subcuentas" datasource="#Session.DSN#">
		    SELECT cc.Ccuenta FROM  CContables cc
		    WHERE cc.Cformato LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#%">
		    AND (SELECT PCDCniv FROM PCDCatalogoCuenta WHERE Ccuentaniv = cc.Ccuenta GROUP BY PCDCniv) <= #nivel.Pvalor - 1#
		    and Ecodigo = #Session.Ecodigo#
	    </cfquery>
	    <cfelse>
	    <cfquery name="subcuentas" datasource="#Session.DSN#">
		    SELECT * FROM CContables
		    WHERE Cmovimiento = 'S'
		    AND Cformato LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#%">
		    and Ecodigo = #Session.Ecodigo#
		</cfquery>
	</cfif>

	<cfloop query="subcuentas">
		<cfquery datasource="#Session.DSN#">
		    INSERT INTO CEMapeoSAT(CCuentaSAT, CAgrupador, Ccuenta, Ecodigo, BMUsucodigo, FechaGeneracion)
		    VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">, #subcuentas.Ccuenta#, #Session.Ecodigo#, #session.Usucodigo#, SYSDATETIME())
	    </cfquery>
	</cfloop>
</cfif>
<!---cfif isdefined("Form.Cambio")>
	<cfif #Form.tipoME# eq 'cuenta'>
		<cfquery name="cambioCuenta" datasource="#Session.DSN#">
		    SELECT Ccuenta FROM  CContables WHERE Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#">
	    </cfquery>
		<cfquery datasource="#Session.DSN#">
			UPDATE CEMapeoSAT SET CCuentaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#"> , UsucodigoModifica= #session.Usucodigo# ,FechaModificacion= SYSDATETIME()  WHERE CAgrupador =	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#"> AND Ccuenta= #cambioCuenta.Ccuenta#
		</cfquery>
	</cfif>
	<cfif #Form.tipoME# eq 'subcuenta'>
		<cfquery name="cambioCuentas" datasource="#Session.DSN#">
		    SELECT Ccuenta FROM  CContables WHERE Cformato LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#%">
	    </cfquery>
	    <cfloop query="cambioCuentas">
		    <cfquery datasource="#Session.DSN#">
			    UPDATE CEMapeoSAT SET CCuentaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">, UsucodigoModifica= #session.Usucodigo# ,FechaModificacion= SYSDATETIME()  WHERE CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#"> AND Ccuenta= #cambioCuentas.Ccuenta#
		    </cfquery>
		</cfloop>
	</cfif>
	<cfset modom="CAMBIO">
</cfif--->
<cfif isdefined("Form.Eliminar")>
	<cfif #Form.tipoME# eq 'cuenta'>
		<cfquery name="borrarCuenta" datasource="#Session.DSN#">
		    SELECT Ccuenta FROM  CContables
		    WHERE Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#">
		    and Ecodigo = #Session.Ecodigo#
	    </cfquery>
	    <cfquery datasource="#Session.DSN#">
		    DELETE FROM CEMapeoSAT
		    WHERE CAgrupador= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">
		    AND Ccuenta= #borrarCuenta.Ccuenta#
		    and Ecodigo = #Session.Ecodigo#
		</cfquery>
	</cfif>
	<cfif #Form.tipoME# eq 'subcuenta'>
		<cfquery name="borrarCuentas" datasource="#Session.DSN#">
		    SELECT Ccuenta FROM  CContables
		    WHERE Cformato LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#%">
		    and Ecodigo = #Session.Ecodigo#
	    </cfquery>
	    <cfloop query="borrarCuentas">
		    <cfquery datasource="#Session.DSN#">
			    DELETE FROM CEMapeoSAT
			    WHERE CAgrupador= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">
			    AND Ccuenta= #borrarCuentas.Ccuenta#
			    and Ecodigo = #Session.Ecodigo#
		    </cfquery>
		</cfloop>
	</cfif>
	<cfset modom="ALTA">
</cfif>

	<cfset LvarAction = 'CatalogoCuentasSATCE.cfm'>

<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
<cfoutput>
    <input name="CAgrupador" type="hidden" value="#trim(form.CAgrupador)#">
	<input name="CCuentaSAT" type="hidden" value="#form.CCuentaSAT#">
    <input name="modo" type="hidden" value="CAMBIO">
	<input name="modom" type="hidden" value="#form.modom#">
	<cfif isdefined('Ccuenta')>
	    <input name="Ccuenta" type="hidden" value="#Ccuenta#">
	</cfif>
	<cfif modom neq 'ALTA'>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<cfif isdefined('Form.tipoME')>
		<cfif #Form.tipoME# eq 'cuenta'>
			<!---input name="Ccuenta" type="hidden" value="#cambioCuenta.Ccuenta#"--->
		</cfif>
		<cfif #Form.tipoME# eq 'subcuenta'>
			<!---input name="Ccuenta" type="hidden" value="#cambioCuentas.Ccuenta#"--->
		</cfif>
		</cfif>
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