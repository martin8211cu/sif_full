<html>
<head>
<title>Copiar Formatos de Impresi&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<link href="sif.css" rel="stylesheet" type="text/css">
<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>

<cfquery name="rsFormatos" datasource="emperador">
	select FMT01COD
	from FMT001
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif isdefined("url.FMT01COD") and  len(trim(url.FMT01COD)) gt 0>
	<cfset form.FMT01COD = url.FMT01COD >
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function existe(obj, tipo){
	// RESULTADO
	// Valida que el codigo de formato digitado exista en la bd
	// tipo = 0 : se llama desde el evento onblur del texto
	// tipo = 1 : se llama desde la funcion que valida el submit del form
	
		valor = trim(obj.value)
		if ( valor != "" ){
			<cfoutput query="rsFormatos" >
				formato = '#rsFormatos.FMT01COD#'
				if ( trim(formato) == trim(valor)  ){
					if (tipo == 0){
						alert('Código de Formato ya existe');
						document.form1.dFMT01COD.value = "";
						document.form1.dFMT01COD.focus();
					}	
					return true
				}
			</cfoutput>
		}
		return false
	}

	function valida(){
		if ( trim(document.form1.dFMT01COD.value) == "" ){
			alert('Debe digitar el Código de Formato.');
			return false
		}
		
		if ( !existe(document.form1.dFMT01COD, 1) ){
			document.form1.FMT01COD.disabled = false;
			return true;
		}
		return false;
		
	}
	
	function cerrar(){
		window.close();
	}
	
</script>

<form name="form1" method="post" action="SQLCopiarFormatos.cfm" onSubmit="return valida();"> 
<table width="60%" cellpadding="0" cellspacing="0" align="center">

	<cfif isdefined("form.sqlFMT01COD") and len(trim(form.sqlFMT01COD)) gt 0 >
		<tr><td align="center" nowrap><font size="2">Se gener&oacute; el Formato de Impresi&oacute;n <b><cfoutput>#form.sqlFMT01COD#</cfoutput></b></font></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center" nowrap>
				<input type="button" name="btnCerrar" value="Cerrar" onClick="javascript:cerrar();">
			</td>
		</tr>
	<cfelse>
		<tr>
			<td align="right" nowrap>C&oacute;digo de Formato Fuente:&nbsp;</td>
			<td nowrap><input disabled name="FMT01COD" type="text" value="<cfoutput>#form.FMT01COD#</cfoutput>" size="13" maxlength="10"></td>
		</tr>
	
		<tr>
			<td align="right" nowrap>C&oacute;digo de Formato Destino:&nbsp;</td>
			<td nowrap><input name="dFMT01COD" type="text" value="" size="13" maxlength="10" onBlur="javascript:existe(this, 0);"></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<link href="estilos.css" rel="stylesheet" type="text/css">
			<td align="center" colspan="2" nowrap>
				<input type="submit" name="btnCopiar" value="Copiar">
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">				
			</td>
		</tr>
	</cfif>

</table>
</form>	

</body>
</html>

