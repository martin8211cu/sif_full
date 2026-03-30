<cfinvoke component="cmMisFunciones" method="tmp_MostrarTabla" returnvariable="rs" />

<script language="javascript1.1" type="text/javascript">
	
	function Asignar(ced,nom) {
		if (window.opener != null) {
			window.opener.document.fForm.txtCedula.value = ced;
			window.opener.document.fForm.txtNombre.value = nom;
		}
		window.close();
	}
</script>

<cfset select = " cedula,nombre,nacionalidad,(nombre + ' ' + apellidos) as nombrefull ">
<cfset from = " ##miTabla ">
<cfset where = " 1=1 ">

<cfif isDefined("FORM.txtCedula") and len(trim(FORM.txtCedula))>
	<cfset where = where & " and cedula = '#FORM.txtCedula#'">
</cfif>
<cfif isDefined("FORM.txtNombre") and len(trim(FORM.txtNombre))>
	<cfset where = where & " and upper(nombre) like upper('%#FORM.txtNombre#%')">
</cfif>
<cfif isDefined("FORM.txtNacionalidad") and len(trim(FORM.txtNacionalidad))>
	<cfset where = where & " and upper(nacionalidad) = upper('#FORM.txtNacionalidad#')">
</cfif>

<form name="fClientes" method="post" action="ConlisMisClientes.cfm" style="margin:0;">
	<table width="600" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
		<tr bgcolor="#CCCCCC" bordercolor="#000000">
			<td align="left">C&eacute;dula:</td>
			<td align="left"><input name="txtCedula" type="text" size="5" onFocus="this.select()"
				value="<cfif isDefined("FORM.txtCedula")><cfoutput>#FORM.txtCedula#</cfoutput></cfif>"></td>
			<td align="left">Nombre:</td>
			<td align="left"><input name="txtNombre" type="text" size="20" onFocus="this.select()"
				value="<cfif isDefined("FORM.txtNombre")><cfoutput>#FORM.txtNombre#</cfoutput></cfif>"></td>
			<td align="left">Nacionalidad:</td>			
			<td align="left"><input name="txtNacionalidad" type="text" size="3"  onFocus="this.select()"
				value="<cfif isDefined("FORM.txtNacionalidad")><cfoutput>#FORM.txtNacionalidad#</cfoutput></cfif>"></td>
			<td align="left"><input name="btnFiltrar" type="submit" 
				value="Filtrar"></td>
		</tr>
		<tr><td></td></tr>
	</table>
	
	<table width="600" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
		<tr>
			<td>
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaRH" 
				 returnvariable="pListaRet"
					tabla="#from#"
					columnas="#select#"
					desplegar="cedula,nombrefull,nacionalidad"
					etiquetas="Cedula,Nombre,Nacionalidad"
					formatos="S,S,S"
					filtro="#where#"
					align="left,left,left"
					ajustar="True"
					irA="ConlisMisClientes.cfm"
					formName="fClientes"
					MaxRows="8"
					funcion="Asignar"
					fparams="cedula,nombre"
					debug="N"
					showEmptyListMsg="true"
					conexion="minisif" />
			</td>
		</tr>
	</table>
</form>

<script language="javascript1.2" type="text/javascript">
	document.fClientes.txtCedula.focus();
</script>