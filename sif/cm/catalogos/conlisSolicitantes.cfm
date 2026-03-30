<cfif isdefined("url.CMSid") and not isdefined("form.CMSid")>
	<cfset form.CMSid= url.CMSid >
</cfif>

<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar(id,name){
	if (window.opener != null) {
		window.opener.document.form1.CMSid.value   = id;
		window.opener.document.form1.CMSnombre.value = name;
		window.close();
	}
}
</script>

<cfif isdefined("Url.CMSnombre") and not isdefined("Form.CMSnombre")>
	<cfparam name="Form.CMSnombre" default="#Url.CMSnombre#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.CMSnombre") and Len(Trim(Form.CMSnombre)) NEQ 0>
	<cfset filtro = filtro & " and upper(CMSnombre) like '%" & #UCase(Form.fCMSnombre)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CMSnombre=" & Form.CMSnombre>
</cfif>

<html>
<head>
<title>Lista de Solicitantes de Compra</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form style="margin:0;" name="filtroEmpleado" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td width="1%" align="right"><strong>Nombre</strong></td>
		<td> 
			<input name="CMSnombre" type="text" id="name" size="30" maxlength="30" value="<cfif isdefined("Form.CMSnombre")>#Form.CMSnombre#</cfif>" onfocus="javascript:this.select();" >
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="CMSolicitantes a"/>
	<cfinvokeargument name="columnas" value="a.CMSid, a.CMSnombre"/>
	<cfinvokeargument name="desplegar" value="CMSnombre"/>
	<cfinvokeargument name="etiquetas" value="Solicitante"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="a.Ecodigo=#session.Ecodigo# order by CMSnombre"/>
	<cfinvokeargument name="align" value="left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisSolicitantes.cfm"/>
	<cfinvokeargument name="formName" value="filtro"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CMSid,CMSnombre"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>
</body>
</html>