<html>
<head>
<title>Lista de Modulos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../css/sif.css" rel="stylesheet" type="text/css">

<cfif isdefined("Url.PAcodigo") and not isdefined("Form.PAcodigo")>
	<cfparam name="Form.PAcodigo" default="#Url.PAcodigo#">
</cfif>
	<cfset filtro="activo = 1">
<cfif isdefined('form.PAcodigo') and form.PAcodigo NEQ ''>
	<cfset filtro = filtro & " and modulo not in (
			select modulo	
			from PaqueteModulo
			where PAcodigo=#form.PAcodigo#)">
<cfelse>

</cfif>
<cfset navegacion="">
<script language="JavaScript" type="text/javascript">
function Asignar(modulo) 
{
		window.opener.agregarModulo(modulo);
		window.close();
}
</script>
</head>
<body>
<cfinvoke 
 component="sif.Componentes.pListas"
 method="pLista"
 returnvariable="pListaMarcasMod">
	<cfinvokeargument name="tabla" value="Modulo"/>
	<cfinvokeargument name="columnas" value="
		sistema,
		modulo,
		nombre
	"/>
	<cfinvokeargument name="desplegar" value="modulo,nombre"/>
	<cfinvokeargument name="etiquetas" value="Módulo,Nombre"/>
	<cfinvokeargument name="cortes" value="sistema"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="
				#filtro# 
			order by sistema,modulo"/>
	<cfinvokeargument name="align" value="left,left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="modulo_conlis.cfm"/>
	<cfinvokeargument name="formName" value="listaModulos"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="modulo"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#session.DSN#"/>
	<cfinvokeargument name="debug" value="N"/>		
</cfinvoke>
</body>
</html>