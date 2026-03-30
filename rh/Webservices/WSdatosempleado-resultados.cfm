<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<!---- =================================================================================================================== ---->
<!---- ==============================  EJECUCIÓN DE MANERA NORMAL (Sin Oracle Service Bus) =============================== ---->
<!---- =================================================================================================================== ---->
<cfinvoke webservice="http://localhost:8300/cfmx/WS/WSdatosempleado.cfc?wsdl" method="wsDatosEmpleado" returnvariable="rsDatosEmpleado" >
    <cfinvokeargument name="Ident" value=""/>	<!----0-0000-0007---->
	<cfinvokeargument name="TipoIdent" value=""/>
</cfinvoke>
<!-----<cfdump var="#rsDatosEmpleado#">---->
<!---- =================================================================================================================== ---->
<!---- ====================================  EJECUCIÓN EN EL ORACLE SERVICE BUS ========================================== ---->
<!---- =================================================================================================================== ---->
<!----
<cfinvoke webservice="http://10.7.7.204:7001/datosempleado?WSDL" method="WSdatosempleado" returnvariable="X">
    <cfinvokeargument name="Ident" value="0-0000-0007"/>	
	<cfinvokeargument name="TipoIdent" value="C"/>
</cfinvoke>
---->
<!---- =================================================================================================================== ---->
<!---- =============================  PINTADO DE DATOS DEVUELTOS POR EL WEBSERVICE ======================================= ---->
<!---- =================================================================================================================== ---->
<style>
	.marco{ border-bottom:1px solid black; border-left:1px solid black;}
	.marcoetiqueta{ border-bottom:1px solid black;background-color:#F1F1F1;}
</style>

<cf_templatecss>
<cf_templateheader title="Recursos Humanos">
	<cf_web_portlet_start titulo="Resultado Consumo de Webservice - Datos Empleado">
		<table width="100%" cellpadding="1" cellspacing="0" border="0" align="center">
			<tr><td>&nbsp;</td></tr>
			<tr valign="bottom">
				<td class="marcoetiqueta" ><b>NOMBRE</b></td>
				<td class="marcoetiqueta" ><b>1er<br /> APELLIDO</b></td>
				<td class="marcoetiqueta" ><b>2do<br /> APELLIDO</b></td>
				<td class="marcoetiqueta" ><b>IDENTIFICACION</b></td>
				<td class="marcoetiqueta" ><b>DIRECCION</b></td>
				<td class="marcoetiqueta" ><b>TELEFONO</b></td>
				<td class="marcoetiqueta" ><b>TELEFONO<br /> ALTERNO</b></td>
				<td class="marcoetiqueta" ><b>CORREO<br /> ELECTRONICO</b></td>
				<td class="marcoetiqueta" ><b>FECHA <br /> NACIMIENTO</b></td>
				<td class="marcoetiqueta" ><b>CUENTA</b></td>
				<td class="marcoetiqueta" ><b>No.<br /> TARJETA</b></td>
			</tr>
			<cfif ArrayLen(rsDatosEmpleado) NEQ 0>
				<cfloop index="i" from="1" to="#ArrayLen(rsDatosEmpleado)#">
					<cfoutput>
						<tr valign="top">
							<td>
								#rsDatosEmpleado[i].Nombre#
							</td>
							<td>
								#rsDatosEmpleado[i].Apellido1#
							</td>
							<td>
								#rsDatosEmpleado[i].Apellido2#
							</td>
							<td>
								#rsDatosEmpleado[i].Identificacion#
							</td>
							<td>
								#rsDatosEmpleado[i].Direccion#
							</td>
							<td>
								#rsDatosEmpleado[i].Telefono1#
							</td>
							<td>
								#rsDatosEmpleado[i].Telefono2#
							</td>
							<td>
								#rsDatosEmpleado[i].Email#
							</td>
							<td>
								#DateFormat(rsDatosEmpleado[i].FechaNacimiento,'dd/mm/yyyy')#
							</td>
							<td>
								#rsDatosEmpleado[i].Cuenta#
							</td>
							<td>
								#rsDatosEmpleado[i].NoTarjeta#
							</td>
						</tr>
					</cfoutput>     
				</cfloop>
			<cfelse>
				<tr><td colspan="11" align="center">--- No se encontraron registros ---</td></tr>
			</cfif>
			<tr><td>&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
