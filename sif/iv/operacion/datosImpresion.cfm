<!--- 
	Creado por: Ana Villavicencio
	Fecha: 		13 de setiembre del 2005
	Motivo: 	Se creo para pedir datos necesarios para la impresion. Parametros del sistema exclusivos para Inventarios.
	
	Modificado: Rodolfo Jimenez Jara
	Fecha:		03 de Diciembre del 2005
	Motivo:		Se arreglaron varios errores, a saber : 
	Linea 85:	<cfquery name="#rsInsert#" -  rsInsert no debe de ir entre ##, 
	Línea 86:	insert into Parametros (Pcodigo,Mcodigo,Pdescripcion,Pvalor,BMUsucodigo) 
				faltaba Ecodigo y no llevaba el valor BMUsucodigo.
--->
	<cfset IdiomaM = ''>
	<cfset Firma = ''>
	<cfquery name="rsIdioma" datasource="#session.DSN#">
		select Pvalor
		from Parametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Pcodigo = 750
	</cfquery>
	
	<cfset hayIdioma = 0 >
	<cfif rsIdioma.RecordCount GT 0 >
		<cfset hayIdioma = 1 >
		<cfset IdiomaM = rsIdioma.Pvalor>
	</cfif>
	
	<cfquery name="rsFirma" datasource="#session.DSN#">
		select Pvalor
		from Parametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Pcodigo = 751
	</cfquery>
	
	<cfset hayfirma = 0 >
	<cfif rsFirma.RecordCount GT 0 >
		<cfset hayfirma = 1 >
		<cfset Firma = rsFirma.Pvalor>
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
		parent.opener.document.form1.fechaFact.value = "<cfoutput>#Form.fechaFact#</cfoutput>"
		parent.opener.document.form1.idioma.value = "<cfoutput>#Form.idioma#</cfoutput>"
		parent.opener.document.form1.firmaAutorizada.value = "<cfoutput>#Form.firmaAutorizada#</cfoutput>"
		</cfif>
		parent.opener.document.form1.submit();
		window.close();
	}
	function valida(f) {
		if (f.fechaFact.value == "") {
			alert("Debe indicar la fecha para la factura.");
			return false;
		}
		if (f.idioma.value == -1) {
			alert("Debe indicar el idioma para la leyenda del monto en letras.");
			return false;
		}
		if (f.firmaAutorizada.value == "") {
			alert("Debe indicar el nombre para la firma autorizada.");
			return false;
		}
	}
</script>

<cfif isdefined('form.btnAceptar')>
	<cfif isDefined("Form.hayIdioma") and Len(Trim(form.hayIdioma)) GT 0>
		<cfif Form.hayIdioma EQ "1">
			<cfquery name="rsUpdate" datasource="#session.DSN#">
				update Parametros
				   set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Idioma#">
				 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				   and Pcodigo = 750
			</cfquery>
		<cfelseif Form.hayIdioma EQ "0" and Len(Trim(Form.Idioma)) GT 0>
			<cfquery name="rsInsert" datasource="#session.DSN#">
				insert into Parametros (Ecodigo,Pcodigo,Mcodigo,Pdescripcion,Pvalor,BMUsucodigo)
				values(<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						750,
						<cfqueryparam cfsqltype="cf_sql_char" value="IV">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Idioma para Monto en Letras">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Idioma#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif isDefined("Form.hayfirma") and Len(Trim(form.hayfirma)) GT 0>
		<cfif Form.hayfirma EQ "1">
			<cfquery name="rsUpdate" datasource="#session.DSN#">
				update Parametros
				   set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.firmaautorizada#">
				 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				   and Pcodigo = 751
			</cfquery>
		<cfelseif Form.hayfirma EQ "0" and Len(Trim(Form.firmaautorizada)) GT 0>
			<cfquery name="rsInsert" datasource="#session.DSN#">
				insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor,BMUsucodigo)
				values(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						751,
						<cfqueryparam cfsqltype="cf_sql_char" value="IV">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Firma autorizada para Impresión de Facturas">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.firmaautorizada#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
			</cfquery>
		</cfif>
	</cfif>
	<script language="JavaScript" type="text/javascript">
		listo();
	</script>
</cfif>
<cfoutput><form name="form1" method="post" action="datosImpresion.cfm" onSubmit="return valida(this);">
	 <table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr><td class="subTitulo" colspan="2" bgcolor="##E4E4E4">Datos para la impresi&oacute;n</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td width="45%" align="right"><strong>Fecha de la Factura:&nbsp;</strong></td>
			<td width="55%"><cf_sifcalendario name="fechaFact" tabindex="1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>
		</tr>
		<tr>
			<td align="right" nowrap><strong>Idioma de Leyenda del Monto en Letras:&nbsp;</strong></td>
			<td>
				<select name="idioma">	  
					<cfif isdefined('rsIdioma') and  rsIdioma.RecordCount EQ 0>
						<option value="-1">----Seleccione un Idioma----</option>
					</cfif>
					<option value="0" <cfif trim(IdiomaM) eq '0'> selected </cfif> >Español</option>
					<option value="1" <cfif trim(IdiomaM) eq '1'> selected </cfif> >Ingl&eacute;s</option>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Firma Autorizada:&nbsp;</strong></td>
			<td>
				<input name="firmaAutorizada" id="firmaAutorizada" type="text" size="50" tabindex="1" value="#Firma#">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<input name="btnAceptar" type="submit" value="Aceptar">
				<input name="btnLimpiar" type="button" value="Limpiar" onClick="javascript: Limpia();">
				<input name="hayIdioma" type="hidden" value="#hayIdioma#">
				<input name="hayfirma" type="hidden" value="#hayfirma#"> 
			</td>
		</tr>
	</table>
</form></cfoutput>

</body>
</html>

<script type="text/javascript" language="javascript1.2">
	function Limpia(){
		document.form1.fechaFact.value = "";
		document.form1.idioma.value = -1;
		document.form1.firmaAutorizada.value = "";
	}
</script>
