<cfif isdefined("URL.PERIODO")>

	<cfset VPER = URL.PERIODO>
	<cfif VPER GTE 2006>
		<!--- APUNTA LAS CONEXIONES DE BASES DE DATOS A V6 --->
		<cfset session.dsn      		= "FONDOSWEB6">
		<cfset session.Conta.dsn 		= "FONDOSWEB6"> 
	<cfelse>
		<cfset session.dsn      		= "ContaWeb">
		<cfset session.Conta.dsn 		= "ContaWeb">
		<cfset session.dsn      		= "sifweb">
		<cfset session.Conta.dsn 		= "sifweb"> 
	</cfif>

</cfif>

<script language="JavaScript" type="text/javascript">
	function Asignar(cuenta,detalle) {
		<cfif url.origen EQ "R">		
			if (window.opener != null) {
	
				window.opener.document.form1.CGM1IM.value = cuenta;
				window.opener.document.form1.CGM1CD.value = detalle;
				if (window.opener.PintaCajas) {
					window.opener.PintaCajas(cuenta,detalle)
				}
			window.close();
			}
	<cfelse>
				window.parent.document.form1.CGM1IM.value = cuenta;
				window.parent.document.form1.CGM1CD.value = detalle;
				if (window.parent.PintaCajas) {
					window.parent.PintaCajas(cuenta,detalle)
				}
	</cfif>
	}
</script>
<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.CGM1IM") and Len(Trim(Form.CGM1IM)) NEQ 0>
	<cfset cond = " and ">
	<cfset filtro = filtro & cond & " upper(CGM1IM) like '%" & #UCase(Form.CGM1IM)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CGM1IM=" & Form.CGM1IM>
</cfif>
<html>
<head>
<title>Lista de Cuenta </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/cfmx/sif/Contaweb/css/estilos.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfoutput>
	<form style="margin:0; " name="filtrocuenta" method="post">
	
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="center" colspan="5"><strong>Catálogo de Cuentas Mayores </strong></td>
			</tr>			
			<tr>
				<td width="16%" align="left"><strong>Cuenta Mayor:</strong>&nbsp;</td>
				<td width="56%"> 
					<input name="CGM1IM" type="text" id="CGM1IM" size="4" maxlength="4" value="<cfif isdefined("Form.CGM1IM")>#Form.CGM1IM#</cfif>">
				</td>
				<td width="28%" align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
				</td>
			</tr>
		</table>
	</form>
</cfoutput>
<cfif url.origen EQ "R">
	<cfinvoke 
	 component="sif.fondos.Componentes.pListas"
	 method="pLista"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="CGM001"/>
		<cfinvokeargument name="columnas" value="CGM1IM,CGM1CD,CTADES"/>
		<cfinvokeargument name="desplegar" value="CGM1IM,CGM1CD,CTADES"/>
		<cfinvokeargument name="etiquetas" value="Mayor,Detalle,Descripción"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value=" 1=1 #filtro# order by CGM1IM,CGM1CD"/>
		<cfinvokeargument name="align" value="left,left,left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
		<cfinvokeargument name="formName" value="cuentas"/>
		<cfinvokeargument name="MaxRows" value="20"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="CGM1IM,CGM1CD"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="Conexion" value="#session.Conta.dsn#"/>
	</cfinvoke> 
<cfelse>
	<cfinvoke 
	 component="sif.fondos.Componentes.pListas"
	 method="pLista"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="CGM001"/>
		<cfinvokeargument name="columnas" value="CGM1IM,CGM1CD,CTADES"/>
		<cfinvokeargument name="desplegar" value="CGM1IM,CTADES"/>
		<cfinvokeargument name="etiquetas" value="Mayor,Descripción"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value=" 1=1 #filtro# and CGM1CD  is null  order by CGM1IM,CGM1CD"/>
		<cfinvokeargument name="align" value="left,left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value="cjcConlis.cfm"/>
		<cfinvokeargument name="formName" value="cuentas"/>
		<cfinvokeargument name="MaxRows" value="10"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="CGM1IM,CGM1CD"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="Conexion" value="#session.Conta.dsn#"/>
	</cfinvoke> 
</cfif>
</body>
</html>

