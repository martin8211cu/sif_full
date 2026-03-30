<!--- 
	Creado por: Ana Villavicencio
	Fecha: 23 de setiembre del 2005
	Motivo: Se creo para pedir datos necesarios para la impresion del reporte. 
			Parametros del sistema exclusivos para Contabilidad General.
			Nuevo parametro 752 Firma autorizada para Pólizas
--->
	<cfset firmaAutoPoliza = ''>
	<cfquery name="rsAutoP" datasource="#session.DSN#">
		select Pvalor
		from Parametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Pcodigo = 752
	</cfquery>
	
	<cfset hayAutoP = 0 >
	<cfif rsAutoP.RecordCount GT 0 >
		<cfset hayAutoP = 1 >
		<cfset firmaAutoPoliza = rsAutoP.Pvalor>
	</cfif>

<html>
<head>
<title>Datos para Impresión de Facturas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
</head>
<body>

<script language="JavaScript" type="text/javascript">
	function listo() {
		<cfif isdefined('form.btnAceptar')>
		parent.opener.document.formfiltro.firmaAutorizada.value = "<cfoutput>#Form.firmaAutorizada#</cfoutput>"
		</cfif>
		parent.opener.document.formfiltro.submit();
		window.close();
	}
	function valida(f) {
		if (f.firmaAutorizada.value == "") {
			alert("Debe indicar el nombre para la firma autorizada.");
			return false;
		}
	}
</script>

<cfif isdefined('form.btnAceptar')>
	<cfif isDefined("Form.hayAutoP") and Len(Trim(form.hayAutoP)) GT 0>
		<cfif Form.hayAutoP EQ "1">
			<cfquery name="rsUpdate" datasource="#session.DSN#">
				update Parametros
				   set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.firmaautorizada#">
				 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				   and Pcodigo = 752
			</cfquery>
		<cfelseif Form.hayAutoP EQ "0" and Len(Trim(Form.firmaautorizada)) GT 0>
			<cfquery name="rsInsert" datasource="#session.DSN#">
				insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor,BMUsucodigo)
				values(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						752,
						<cfqueryparam cfsqltype="cf_sql_char" value="CG">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Firma autorizada para Pólizas">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.firmaAutorizada#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
			</cfquery>
		</cfif>
	</cfif>
	<script language="JavaScript" type="text/javascript">
		listo();
	</script>
</cfif>
<cfoutput><form name="form1" method="post" action="datosReporte.cfm" onSubmit="return valida(this);">
	 <table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr><td class="subTitulo" colspan="2" bgcolor="##E4E4E4">Datos para la Reporte</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="right"><strong>Firma Autorizada:&nbsp;</strong></td>
			<td>
				<input name="firmaAutorizada" id="firmaAutorizada" type="text" size="50" tabindex="1" value="#firmaAutoPoliza#">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<input name="btnAceptar" type="submit" value="Aceptar">
				<input name="btnLimpiar" type="button" value="Limpiar" onClick="javascript: Limpia();">
				<input name="btnCancelar" type="button" value="Cancelar" onClick="javascript: window.close();">
				<input name="hayAutoP" type="hidden" value="#hayAutoP#"> 
			</td>
		</tr>
	</table>
</form></cfoutput>

</body>
</html>

<script type="text/javascript" language="javascript1.2">
	function Limpia(){
		document.form1.firmaAutorizada.value = "";
	}
</script>
