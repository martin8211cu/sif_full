<script language="JavaScript" type="text/javascript">
function Asignar(CG12ID,DESCUENTA) {
	if (window.opener != null) {
		var obj = eval("window.opener.document.form1.CG13ID_<cfoutput>#url.NIVEL#</cfoutput>" )
		obj.value = CG12ID;
		window.opener.document.form1.DESCUENTA.value = DESCUENTA;
		window.close();
	}
}
</script>
<cftry>
<cfquery name="rs" datasource="#session.Fondos.dsn#">
	set nocount on	
	exec sp_Next_tipo @CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGM1IM)#">
	, @nivel  = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NIVEL#">
	<cfif len(trim(url.StringNivel)) gt 0>
		, @CGM1CD = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(url.StringNivel)#">
	<cfelse>
		, @CGM1CD =null
	</cfif> 	
	set nocount off	

</cfquery>
<cfcatch type="any">
	<script language="JavaScript">
	   var  mensaje = '<cfoutput>#cfcatch.Detail#</cfoutput>'
	   mensaje = mensaje.substring(40,300)
	   alert(mensaje)
	</script>
	<cfabort>
</cfcatch> 
</cftry>
<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.CG12ID") and Len(Trim(Form.CG12ID)) NEQ 0>
	<cfset cond = " and">
	<cfset filtro = filtro & cond & " upper(CG12ID) like '%" & #UCase(Form.CG12ID)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CG12ID=" & Form.CG12ID>
    

</cfif>

<cfif isdefined("Form.CG12DE") and Len(Trim(Form.CG12DE)) NEQ 0>
 	<cfset cond = " and">
	<cfset filtro = filtro & cond & " upper(CG12DE) like '%" & #UCase(Form.CG12DE)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CG12DE=" & Form.CG12DE>
	
</cfif>

<html>
<head>
<title>Cuentas Contables</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/cfmx/sif/V5/css/estilos.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfoutput>
	<form style="margin:0; " name="filtroEmpleado" method="post">
	
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Código</strong></td>
				<td> 
					<input name="CG12ID" type="text" id="CG12ID" size="10" maxlength="10" value="<cfif isdefined("Form.CG12ID")>#Form.CG12ID#</cfif>">
				</td>
				<td align="right"><strong>Descripción</strong></td>
				<td> 
					<input name="CG12DE" type="text" id="CG12DE" size="50" maxlength="100" value="<cfif isdefined("Form.CG12DE")>#Form.CG12DE#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
				</td>
			</tr>
		</table>
	</form>
</cfoutput>

<cfinvoke 
 component="sif.fondos.Componentes.pListas"
 method="pLista"

 returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="CGM012"/>
 	<cfinvokeargument name="columnas" value="CG12ID,CG12DE"/>
	<cfinvokeargument name="desplegar" value="CG12ID,CG12DE"/>
	<cfinvokeargument name="etiquetas" value="Código,Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="CG11ID = #rs.CG11ID#  #filtro#"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
	<cfinvokeargument name="formName" value="cuentas"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CG12ID,CG12DE"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#session.Fondos.dsn#"/>
</cfinvoke>
</body>
</html>
