<cfquery name="validar" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="validarOrden" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200081 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="validarTest" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200082 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="validarMon" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200083 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsBalDif" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200084 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsValXmlProv" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200085 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<!--- Ruta del ws --->
<cfquery name="rsws" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200086 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<!---  Sello digital--->
<cfquery name="rssello" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200087 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<!--- crear las cuentas mapeadas en las empresas del grupo --->
<cfquery name="rsCctasGE" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200088 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<!--- Tomar valores del CFDI --->
<cfquery name="rsValores" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200089 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsTVCDFI" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200090 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfif #validar.RecordCount# eq 0>
	<cfquery datasource="#Session.DSN#">
		INSERT INTO Parametros(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor, BMUsucodigo)
		VALUES(#Session.Ecodigo#, 200080, 'CE', 'Nivel Catalogo Contable', '#form.nivel#', #session.Usucodigo#)
	</cfquery>
	<cfelse>
	<cfquery datasource="#Session.DSN#">
		UPDATE Parametros SET Pvalor = '#form.nivel#' WHERE Pcodigo = 200080 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
	</cfquery>
</cfif>

<cfif isdefined("Form.Orden")>
	<cfset orden = 'S'>
<cfelse>
	<cfset orden = 'N'>
</cfif>

<cfif #validarOrden.RecordCount# eq 0>
	<!---<cfif #orden# eq 'S'>--->
		<cfquery datasource="#Session.DSN#">
			INSERT INTO Parametros(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor, BMUsucodigo)
			VALUES(#Session.Ecodigo#, 200081, 'CE', 'Incluir cuentas de orden', '#orden#', #session.Usucodigo#)
		</cfquery>
	<!---</cfif>--->
<cfelse>
	<cfquery datasource="#Session.DSN#">
		UPDATE Parametros SET Pvalor = '#orden#' WHERE Pcodigo = 200081 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
	</cfquery>
</cfif>

<cfif isdefined("Form.valTES")>
	<cfset valTES = 'S'>
<cfelse>
	<cfset valTES = 'N'>
</cfif>

<cfif #validarTest.RecordCount# eq 0>
	<!---<cfif #orden# eq 'S'>--->
		<cfquery datasource="#Session.DSN#">
			INSERT INTO Parametros(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor, BMUsucodigo)
			VALUES(#Session.Ecodigo#, 200082, 'CE', 'No validar RFC Emisor en Tesoreria', '#valTES#', #session.Usucodigo#)
		</cfquery>
	<!---</cfif>--->
<cfelse>
	<cfquery datasource="#Session.DSN#">
		UPDATE Parametros SET Pvalor = '#valTES#' WHERE Pcodigo = 200082 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
	</cfquery>
</cfif>


<cfif isdefined("Form.valMON")>
	<cfset valMON = 'S'>
<cfelse>
	<cfset valMON = 'N'>
</cfif>

<cfif #validarMON.RecordCount# eq 0>
	<!---<cfif #orden# eq 'S'>--->
		<cfquery datasource="#Session.DSN#">
			INSERT INTO Parametros(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor, BMUsucodigo)
			VALUES(#Session.Ecodigo#, 200083, 'CE', 'No Registrar Moneda y Tipo de Cambio', '#valMON#', #session.Usucodigo#)
		</cfquery>
	<!---</cfif>--->
<cfelse>
	<cfquery datasource="#Session.DSN#">
		UPDATE Parametros SET Pvalor = '#valMON#' WHERE Pcodigo = 200083 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
	</cfquery>
</cfif>

<cfif isdefined("Form.balDif")>
	<cfset balDif = 'S'>
<cfelse>
	<cfset balDif = 'N'>
</cfif>

<cfif #rsBalDif.RecordCount# eq 0>
	<!---<cfif #orden# eq 'S'>--->
		<cfquery datasource="#Session.DSN#">
			INSERT INTO Parametros(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor, BMUsucodigo)
			VALUES(#Session.Ecodigo#, 200084, 'CE', 'Generar Balanzas Complementarias parciales', '#balDif#', #session.Usucodigo#)
		</cfquery>
	<!---</cfif>--->
<cfelse>
	<cfquery datasource="#Session.DSN#">
		UPDATE Parametros SET Pvalor = '#balDif#' WHERE Pcodigo = 200084 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
	</cfquery>
</cfif>

<!--- VALIDACION DE INSERT O UPDATE PARA VALIDACION DE XML PARA PROVEEDORES --->
<cfif isdefined("Form.valXmlProv")>
	<cfset valXmlProv = 'S'>
<cfelse>
	<cfset valXmlProv = 'N'>
</cfif>

<cfif #rsValXmlProv.RecordCount# eq 0>
	<!---<cfif #orden# eq 'S'>--->
		<cfquery datasource="#Session.DSN#">
			INSERT INTO Parametros(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor, BMUsucodigo)
			VALUES(#Session.Ecodigo#, 200085, 'CE', 'Validar XML proveedores', '#valXmlProv#', #session.Usucodigo#)
		</cfquery>
	<!---</cfif>--->
<cfelse>
	<cfquery datasource="#Session.DSN#">
		UPDATE Parametros SET Pvalor = '#valXmlProv#' WHERE Pcodigo = 200085 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
	</cfquery>
</cfif>

<!--- Insertamos o actulizamos urlws --->
<cfif #form.urlws# neq ''>
	<cfset vurlws = '#form.urlws#'>
<cfelse>
	<cfset vurlws = ''>
</cfif>

<cfif #rsws.RecordCount# eq 0>
	<cfquery datasource="#Session.DSN#">
		INSERT INTO Parametros(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor, BMUsucodigo)
		VALUES(#Session.Ecodigo#, 200086, 'CE', 'URL del web serivices', '#vurlws#', #session.Usucodigo#)
	</cfquery>
	<cfelse>
	<cfif #form.urlws# neq ''>
		<cfquery datasource="#Session.DSN#">
			UPDATE Parametros SET Pvalor = '#vurlws#' WHERE Pcodigo = 200086 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
		</cfquery>
	</cfif>
</cfif>

<!--- Validacion de insert o update para validar Sello Digital --->
<cfif isdefined("Form.balSello")>
	<cfset valSelloD = 'S'>
<cfelse>
	<cfset valSelloD = 'N'>
</cfif>

<cfif #rssello.RecordCount# eq 0>
		<cfquery datasource="#Session.DSN#">
			INSERT INTO Parametros(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor, BMUsucodigo)
			VALUES(#Session.Ecodigo#, 200087, 'CE', 'Incluir Sello Digital', '#valSelloD#', #session.Usucodigo#)
		</cfquery>
<cfelse>
	<cfquery datasource="#Session.DSN#">
		UPDATE Parametros SET Pvalor = '#valSelloD#' WHERE Pcodigo = 200087 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
	</cfquery>
</cfif>

<!--- crear las cuentas mapeadas en las empresas del grupo --->
<cfif isdefined("Form.ctasGE")>
	<cfset valCtasGE = 'S'>
<cfelse>
	<cfset valCtasGE = 'N'>
</cfif>

<cfif #rsCctasGE.RecordCount# eq 0>
	<!---<cfif #orden# eq 'S'>--->
		<cfquery datasource="#Session.DSN#">
			INSERT INTO Parametros(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor, BMUsucodigo)
			VALUES(#Session.Ecodigo#, 200088, 'CE', 'Crear las cuentas mapeadas en las empresas del grupo', '#valCtasGE#', #session.Usucodigo#)
		</cfquery>
	<!---</cfif>--->
<cfelse>
	<cfquery datasource="#Session.DSN#">
		UPDATE Parametros SET Pvalor = '#valCtasGE#' WHERE Pcodigo = 200088 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
	</cfquery>
</cfif>

<cfif isdefined("Form.valVal")>
	<cfset valVal = 'S'>
<cfelse>
	<cfset valVal = 'N'>
</cfif>

<cfif #rsValores.RecordCount# eq 0>
	<!---<cfif #orden# eq 'S'>--->
		<cfquery datasource="#Session.DSN#">
			INSERT INTO Parametros(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor, BMUsucodigo)
			VALUES(#Session.Ecodigo#, 200089, 'CE', 'Tomar valores del CFDI', '#valVal#', #session.Usucodigo#)
		</cfquery>
	<!---</cfif>--->
<cfelse>
	<cfquery datasource="#Session.DSN#">
		UPDATE Parametros SET Pvalor = '#valVal#' WHERE Pcodigo = 200089 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
	</cfquery>
</cfif>

<!--- Validacion de insert o update para validar Tolerancia validar CFDI --->
<cfif isdefined("Form.EDimpuesto")>
	<cfset valTVCDFI = #Form.EDimpuesto#>
<cfelse>
	<cfset valTVCDFI = '0.00'>
</cfif>
<cfif #rsTVCDFI.RecordCount# eq 0>
		<cfquery datasource="#Session.DSN#">
			INSERT INTO Parametros(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor, BMUsucodigo)
			VALUES(#Session.Ecodigo#, 200090, 'CE', 'Tolerancia en validacion del cfdi', '#lsparsenumber(valTVCDFI)#', #session.Usucodigo#)
		</cfquery>
<cfelse>
	<cfquery datasource="#Session.DSN#">
		UPDATE Parametros SET Pvalor = '#lsparsenumber(valTVCDFI)#' WHERE Pcodigo = 200090 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
	</cfquery>
</cfif>

<cfset LvarAction = 'ParametrosCE.cfm'>

<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
<cfoutput>
    <input type="hidden" name="nivel" value="#form.nivel#">
	<input type="hidden" name="rorden" value="#orden#">
	<input type="hidden" name="rorden" value="#orden#">
</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>