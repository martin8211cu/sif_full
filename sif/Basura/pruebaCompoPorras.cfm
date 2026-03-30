<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Prueba de Componentes de Interfaz</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>

<form name="form1" method="post" action="SQLpruebaCompoPorras.cfm">
	  <p>&nbsp;</p>
	  <p>&nbsp;</p>
	  <p>&nbsp;</p>
	  <p>&nbsp;</p>
	<table width="79%"  border="0" align="center">
		<tr>
			<td colspan="3" align="center"><strong>PRUEBAS DE COMPONENTES DE PORRAS</strong></td>
		</tr>
		<tr>
			<td colspan="3" align="center">&nbsp;</td>
		</tr>	
		<tr>
			<td width="52%">&nbsp;</td>
			<td width="5%">&nbsp;</td>
			<td width="43%">&nbsp;</td>
		</tr>
		<tr>
			<td><strong>Articulos</strong></td>
			<td>&nbsp;</td>
			<td>
				<div align="center">
					<input name="btnArticulos" type="submit" id="btnArticulos" value="Articulos">
				</div>
			</td>
		</tr>
		<tr>
			<td><strong>Registro de Clasificaciones de Articulos </strong></td>
			<td>&nbsp;</td>
			<td>
				<div align="center">
					<input name="btnClasArticulos" type="submit" id="btnClasArticulos" value="Clasificacion Articulos">
				</div>
			</td>
		</tr>
		<tr>
			<td><strong>Registro de Categorias de Activos Fijos </strong></td>
			<td>&nbsp;</td>
			<td>
				<div align="center">
					<input name="btnCatActFijos" type="submit" id="btnCatActFijos" value="Cat Activos Fijos">
				</div>
			</td>
		</tr>
		<tr>
			<td><strong>Registro de Clases de Activos Fijos </strong></td>
			<td>&nbsp;</td>
			<td>
				<div align="center">
					<input name="btnClasActFijos" type="submit" id="btnClasActFijos" value="Clases Activos Fijos">
				</div>
			</td>
		</tr>
		<tr>
			<td><strong>Registro de Proveedores </strong></td>
			<td>&nbsp;</td>
			<td>
				<div align="center">
					<input name="btnProveedores" type="submit" id="btnProveedores" value="Clases Proveedores">
				</div>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>	
	</table>
</form>

  <!--- Prueba de los métodos del componente CM_InterfazSolicitudes 
<cfinvoke component="sif.Componentes.CM_InterfazSolicitudes" method="init" conexion="minisif" ecodigo="1" usucodigo="27"/>
<cfinvoke component="sif.Componentes.CM_InterfazSolicitudes" method="run" returnvariable="resultado"/>
<cfdump var="#resultado#"/>
--->
      

  <!--- PARA PROBAR CANCELACION DE SOLICITUDES 
<cfinvoke 
	component="sif.Componentes.CM_CancelaSolicitud"
	method="CM_getSolicitudesACancelar"
	Solicitante="48"
	Conexion="minisif"
	Ecodigo="1"
	returnvariable="solicitudes"/>
<cfdump var="#solicitudes#"/>
--->
</p>
</body>
</html>