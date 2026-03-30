<cfparam name="modo" default="ALTA">
<cfquery name="nivel" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="valOrden" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200081 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rfc" datasource="#Session.DSN#">
	SELECT Eidentificacion FROM Empresa WHERE Ereferencia = #Session.Ecodigo#
</cfquery>
<cfif #Len(rfc.Eidentificacion)# gte 12 and #Len(rfc.Eidentificacion)# lte 13>
	<cfset Strfc = #rfc.Eidentificacion#>
	<cfelse>
	<cfset Strfc = ''>
</cfif>

<cfset res = REMatch("[A-ZÑ&]{3,4}[0-9]{2}[0-1][0-9][0-3][0-9][A-Z0-9]?[A-Z0-9]?[0-9A-Z]?", #Strfc#)>

<cfif #ArrayIsEmpty(res)# eq 'YES'>
	<cfset RFC = 'XAXX010101000'>
	<cfelse>
	<cfset RFC = '#rfc.Eidentificacion#'>
</cfif>

<cfquery name="totalC" datasource="#Session.DSN#">
	SELECT COUNT(CCuentaSAT) AS Cuentas FROM CEMapeoSAT WHERE Ecodigo = #Session.Ecodigo#  AND CAgrupador = '#form.CAgrupador#'
</cfquery>

<cfset LvarError = 0>
<cfset LvarPrepXML = 0> <!--- SML. 11/11/2014 Variable para saber si se preparo el XML del mapeo de Cuentas--->

<cfif #RFC# eq ''>
	<cfset LvarError = 1>
</cfif>

<cfquery name="rsGEid" datasource="#Session.DSN#">
	SELECT  GEid FROM CEMapeoGE
	where Id_Agrupador = #form.CAgrupador#
		And Ecodigo = #Session.Ecodigo#
</cfquery>


<cfinvoke component="sif.ce.Componentes.ValidacionMapeo" method="ValMapeoCtasContables" returnvariable="resError">
	<cfinvokeargument name="idAgrupador" value="#form.CAgrupador#">
    <cfinvokeargument name="Nivel"       value="#nivel.Pvalor#" >
    <cfinvokeargument name="Periodo"     value="#form.Periodo#">
    <cfinvokeargument name="Mes" 		 value="#form.Mes#">
	<cfinvokeargument name="GEid" 		 value="#rsGEid.GEid#">
</cfinvoke>
<cfif #resError# eq false>
	<cfset LvarError = 3>
</cfif>


<cfset lvarValorN = ''>
<cfset lvarValorS = ''>

<cfif #nivel.Pvalor# neq '-1'>
	<cfset lvarValorN = "AND (select PCDCniv from PCDCatalogoCuenta where Ccuentaniv = cco.Ccuenta GROUP BY PCDCniv ) <= #nivel.Pvalor -1#">
	<cfelse>
	<cfset lvarValorS = "and cco.Cmovimiento = 'S'">
</cfif>

<cfset LvarOrden = ''>
<cfif #valOrden.RecordCount# eq 0>
<cfset LvarOrden = "">
<cfelse>
	<cfif #valOrden.Pvalor# eq 'N'>
		<cfset LvarOrden = " INNER JOIN CtasMayor cm ON cco.Cmayor = cm.Cmayor AND cm.Ctipo <> 'O'   and cm.Ecodigo = cco.Ecodigo">
	</cfif>
</cfif>

<cfif #LvarError# eq 0>
	<cfquery name="existe" datasource="#Session.DSN#">
		SELECT * FROM CEXMLEncabezadoCuentas
		WHERE CAgrupador = '#form.CAgrupador#' AND Version = '#form.Version#'
		AND Mes = '#form.Mes#' 
		AND Anio = #form.Periodo# 
		AND Ecodigo =  #Session.Ecodigo#
		AND GEid = #rsGEid.GEid#
	</cfquery>
	<cfif #existe.RecordCount# eq 0>
		<cfquery datasource="#Session.DSN#">
		    INSERT INTO CEXMLEncabezadoCuentas (CAgrupador, Version ,Rfc, TotalCtas, Mes, Anio , Ecodigo , Status , BMUsucodigo, FechaGeneracion,GEid)
            VALUES ('#form.CAgrupador#', '#form.Version#', '#RFC#', #totalC.Cuentas#, '#form.Mes#', #form.Periodo#, #Session.Ecodigo#, 'Preparado',
			#session.Usucodigo#,SYSDATETIME(),#rsGEid.GEid#)
	    </cfquery>
	    <cfquery name="XMLEnc" datasource="#Session.DSN#">
		    SELECT Id_XMLEnc FROM CEXMLEncabezadoCuentas WHERE CAgrupador = '#form.CAgrupador#' AND Version = '#form.Version#'
		    	AND Mes = '#form.Mes#' AND Anio = #form.Periodo# AND Ecodigo =  #Session.Ecodigo#
		    	AND GEid = #rsGEid.GEid#
	    </cfquery>
	    <cfquery name="cuentas" datasource="#Session.DSN#">
		    INSERT INTO CEXMLDetalleCuentas(Id_XMLEnc, CodAgrup, NumCta, Descripcion,
		    	SubCtaDe,
		    	Nivel,
		    	Natur,
		    	Ecodigo, BMUsucodigo, FechaGeneracion
		    )
			SELECT distinct '#XMLEnc.Id_XMLEnc#', cem.CCuentaSAT, cco.Cformato, cco.Cdescripcion,
				subcuenta = (select Cformato from CContables where Ccuenta = cco.Cpadre) ,
	            PCDCniv = (select PCDCniv from PCDCatalogoCuenta where Ccuentaniv = cco.Ccuenta GROUP BY PCDCniv ),
            Natur = case cco.Cbalancenormal WHEN '-1' THEN 'A' WHEN '1' THEN 'D' END,
	            #Session.Ecodigo#, #session.Usucodigo#,SYSDATETIME()
            FROM CEMapeoSAT cem
            INNER JOIN CContables cco ON cem.Ccuenta = cco.Ccuenta AND cem.Ecodigo = #Session.Ecodigo# #PreserveSingleQuotes(lvarValorS)#
            #PreserveSingleQuotes(LvarOrden)#
            INNER JOIN (
				select distinct  Ccuenta
				from SaldosContables
				where Speriodo * 100 + Smes  <= #form.periodo * 100 + form.mes# and Ecodigo = #Session.Ecodigo#
			) Saldos on Saldos.Ccuenta=cem.Ccuenta
			#PreserveSingleQuotes(lvarValorN)#
            Where cem.CAgrupador = '#form.CAgrupador#'
			and not exists (select 1 from CEInactivas e where cem.Ccuenta = e.Ccuenta and cem.Ecodigo = e.Ecodigo)
			and not exists (select 1 from  (select distinct a.Ccuenta, a.Cformato, a.Cdescripcion, a.Ecodigo,a.Cmayor, b.PCDCniv, cm.Ctipo
					from CContables a
					inner join CtasMayor cm on a.Cmayor = cm.Cmayor and a.Ecodigo = cm.Ecodigo
					INNER JOIN PCDCatalogoCuenta b on a.Ccuenta = b.Ccuentaniv
					where b.PCDCniv = 0 and not exists (select 1 from CContables cc where a.Ccuenta = cc.Cpadre and a.Ecodigo = cc.Ecodigo)) cmns
				where cem.Ccuenta = cmns.Ccuenta)
			UNION ALL
			SELECT distinct '#XMLEnc.Id_XMLEnc#', cem.CCuentaSAT, cco.Cformato, cco.Cdescripcion,
			subcuenta = (select Cformato from CContables where Ccuenta = cco.Cpadre),
            PCDCniv = (select PCDCniv from PCDCatalogoCuenta where Ccuentaniv = cco.Ccuenta GROUP BY PCDCniv ),
            Natur = case cco.Cbalancenormal WHEN '-1' THEN 'A' WHEN '1' THEN 'D' END,
	        #Session.Ecodigo#, #session.Usucodigo#,SYSDATETIME()
            FROM CEMapeoSAT cem
            INNER JOIN CContables cco ON cem.Ccuenta = cco.Ccuenta AND cem.Ecodigo = #Session.Ecodigo#
			#PreserveSingleQuotes(lvarValorN)#
            #PreserveSingleQuotes(LvarOrden)#
            LEFT JOIN (
				select distinct  Ccuenta
				from SaldosContables
				where Speriodo * 100 + Smes  <= #form.periodo * 100 + form.mes# and Ecodigo = #Session.Ecodigo#
			) Saldos on Saldos.Ccuenta=cem.Ccuenta
			#PreserveSingleQuotes(lvarValorN)#
            Where cem.CAgrupador = '#form.CAgrupador#'
				and Saldos.Ccuenta is null
				and not exists (select 1 from CEInactivas e where cem.Ccuenta = e.Ccuenta and cem.Ecodigo = e.Ecodigo)
				and not exists (select 1 from  (select distinct a.Ccuenta, a.Cformato, a.Cdescripcion, a.Ecodigo,a.Cmayor, b.PCDCniv, cm.Ctipo
						from CContables a
						inner join CtasMayor cm on a.Cmayor = cm.Cmayor and a.Ecodigo = cm.Ecodigo
						INNER JOIN PCDCatalogoCuenta b on a.Ccuenta = b.Ccuentaniv
						where isnull(b.PCDCniv,0) = 0 and not exists (select 1 from CContables cc where a.Ccuenta = cc.Cpadre and a.Ecodigo = cc.Ecodigo)) cmns
					where cem.Ccuenta = cmns.Ccuenta)
		</cfquery>

        <cfset LvarPrepXML = 1> <!--- SML. 11/11/2014 Variable para saber si se preparo el XML del mapeo de Cuentas--->
	<cfelse>
	    <cfset LvarError = 2>
	</cfif>

</cfif>


<!---cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfif not isdefined("Form.Empresa")>

		<cfquery datasource="#Session.DSN#">
			INSERT INTO CECuentasSAT(CCuentaSAT, CAgrupador,NombreCuenta,Clasificacion,BMUsucodigo,FechaGeneracion)
            VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NombreCuenta#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clasificacion#">,#session.Usucodigo#,SYSDATETIME())
		</cfquery>

		<cfelse>
		<cfquery datasource="#Session.DSN#">
			INSERT INTO CECuentasSAT(CCuentaSAT, CAgrupador,NombreCuenta,Clasificacion,Ecodigo,BMUsucodigo,FechaGeneracion)
            VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NombreCuenta#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clasificacion#">,#Session.Ecodigo#,#session.Usucodigo#,SYSDATETIME())
		</cfquery>

		</cfif>
		<cfset modo="CAMBIO">

	<cfelseif isdefined("Form.Baja")>

	    <cfquery name="verifica" datasource="#session.DSN#">
			select * from CEMapeoSAT where CCuentaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSATUP#"> and CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">
		</cfquery>

		<cfif #verifica.RecordCount# eq 0>
			<cftransaction>
			<cfquery datasource="#session.DSN#">
				DELETE FROM CECuentasSAT WHERE CCuentaSAT= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSATUP#"> AND CAgrupador=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">
			</cfquery>
		</cftransaction>
		<cfelse>
		<cfset LvarError = 1>
		</cfif>

	  	<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<cfquery datasource="#session.DSN#">
			<cfif not isdefined("Form.Empresa")>
				UPDATE CECuentasSAT SET NombreCuenta=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NombreCuenta#"> ,Clasificacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clasificacion#"> ,Ecodigo=NULL , UsucodigoModifica=#session.Usucodigo# ,FechaModificacion=SYSDATETIME() WHERE CCuentaSAT= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSATUP#"> AND CAgrupador= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">
				<cfelse>
				UPDATE CECuentasSAT SET NombreCuenta=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NombreCuenta#"> ,Clasificacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clasificacion#"> ,Ecodigo=#Session.Ecodigo# , UsucodigoModifica=#session.Usucodigo# ,FechaModificacion=SYSDATETIME() WHERE CCuentaSAT= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSATUP#"> AND CAgrupador=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">

			</cfif>


		</cfquery>
	  	<cfset modo="CAMBIO">
	</cfif>
</cfif--->

	<cfset LvarAction = 'PrepararXMLCE.cfm'>


<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
	<cfoutput>
		<input type="hidden" name="CAgrupador"  id="CAgrupador" value="#form.CAgrupador#">
		<input type="hidden" name="Version"  id="Version" value="#form.Version#">
		<input type="hidden" name="Error" id="Error" value="#LvarError#">
		<input type="hidden" name="Periodo" id="Periodo" value="#form.Periodo#">
		<input type="hidden" name="Mes" id="Mes" value="#form.Mes#">
        <input type="hidden" name="PrepXML" id="PrepXML" value="#LvarPrepXML#"> <!--- SML. 11/11/2014 Variable para saber si se preparo el XML del mapeo de Cuentas--->
	</cfoutput>

<!---cfoutput>
    <input name="Error" type="hidden" value="#LvarError#">
	<cfif #LvarError# eq 1>
		<cfset modo="CAMBIO">
	</cfif>
	 <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
    <input name="CAgrupador" type="hidden" value="<cfif isdefined("Form.CAgrupador")>#Form.CAgrupador#</cfif>">

	<cfif modo neq 'ALTA'>
		<cfif isdefined('form.CCuentaSAT')>
			<input name="CCuentaSAT" type="hidden" value="#form.CCuentaSAT#">
			<cfelse>
		    <input name="CCuentaSAT" type="hidden" value="#form.CCuentaSATUP#">
		</cfif>

	</cfif>
</cfoutput--->
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>