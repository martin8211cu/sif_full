<html>
<head>
<title>Lista de Paquetes</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../css/sif.css" rel="stylesheet" type="text/css">

<cfif isdefined("Url.cliente_empresarial") and not isdefined("Form.cliente_empresarial")>
	<cfparam name="Form.cliente_empresarial" default="#Url.cliente_empresarial#">
</cfif>
<cfif isdefined("Url.COcodigo") and not isdefined("Form.COcodigo")>
	<cfparam name="Form.COcodigo" default="#Url.COcodigo#">
</cfif>

<cfif isdefined('form.cliente_empresarial') and form.cliente_empresarial NEQ '' and isdefined('form.COcodigo') and form.COcodigo NEQ ''>
	<cfset filtro = " and PAcodigo not in (
			Select ccp.PAcodigo
			from ClienteContratoPaquetes ccp
				, ClienteContrato cc
				, Paquete p
			where cliente_empresarial=#form.cliente_empresarial#
				and ccp.COcodigo=#form.COcodigo#
				and ccp.COcodigo=cc.COcodigo
				and ccp.PAcodigo=p.PAcodigo)">
</cfif>

<cfset navegacion="">
<script language="JavaScript" type="text/javascript">
	function Asignar(Paquet){
			window.opener.agregarPaquete(Paquet);
			window.close();
	}
</script>

</head>
<body>

<link rel="stylesheet" type="text/css" href="../css/sif.css">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="tituloMantenimiento">Paquetes no asociados al contrato</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pLista"
 returnvariable="pListaPaquetes">
	<cfinvokeargument name="tabla" value="Paquete"/>
	<cfinvokeargument name="columnas" value="
		convert(varchar,PAcodigo) as PAcodigo
		, PAdescripcion
	"/>
	<cfinvokeargument name="desplegar" value="PAdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Paquete"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value=" 1=1
				#filtro# 
			order by PAdescripcion"/>
	<cfinvokeargument name="align" value="left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="paquete_conlis.cfm"/>
	<cfinvokeargument name="formName" value="listaPaquetes"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="PAcodigo"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#session.DSN#"/>
	<cfinvokeargument name="debug" value="N"/>		
</cfinvoke>
</body>
</html>