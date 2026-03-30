<cfset menu2 = ArrayNew(1)><!--- Coleccion de Opciones --->

<cfif acceso_uri("/sif/iv/operacion/RecibeTransito.cfm")>
	<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
	<cfset opcion.uri = "/sif/iv/operacion/RecibeTransito.cfm">
	<cfset opcion.titulo = "Recepci&oacute;n de Productos en Tr&aacute;nsito">
	<cfset opcion.descripcion = "">
	<cfset ArrayAppend(menu2,opcion)>
</cfif>	

<cfif acceso_uri("/sif/iv/operacion/Transforma.cfm")>
	<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
	<cfset opcion.uri = "/sif/iv/operacion/Transforma.cfm">
	<cfset opcion.titulo = "Transformaci&oacute;n de Productos">
	<cfset opcion.descripcion = "Se procesa la informacion de los vol&uacute;menes de 
							producci&oacute;n y consumo reportados por el proveedor. El volumen reportado 
							por el proveedor debe ser equivalente al volumen comprado en el m&oacute;dulo 
							de cuentas por pagar y del m&oacute;dulo de Recepci&oacute;n de Inventario en 
							Tr&aacute;nsito. Antes de Generar el proceso de transformaci&oacute;n, las 
							diferencias de inventario deben ser conciliadas antes de concluir el proceso, 
							por lo cual el sistema no deber&iacute;a manejar diferencias.">
	<cfset ArrayAppend(menu2,opcion)>
</cfif>

<cfif acceso_uri("/sif/iv/operacion/impresionFacturas.cfm")>
	<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
	<cfset opcion.uri = "/sif/iv/operacion/impresionFacturas.cfm">
	<cfset opcion.titulo = "Impresi&oacute;n de Facturas">
	<cfset opcion.descripcion = "">
	<cfset ArrayAppend(menu2,opcion)>
</cfif>

<cfif acceso_uri("/sif/iv/operacion/reimprimeFactura.cfm")>
	<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
	<cfset opcion.uri = "/sif/iv/operacion/reimprimeFactura.cfm">
	<cfset opcion.titulo = "Reimpresi&oacute;n de Facturas">
	<cfset opcion.descripcion = "">
	<cfset ArrayAppend(menu2,opcion)>
</cfif>

<cfif ArrayLen(menu2) gt 0>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<cfloop from="1" to="#ArrayLen(menu2)#" index="i">
			<cfset opcion = StructNew()>
			<cfset opcion = menu2[i]>
			<cfoutput>
			<tr>
				<td width="1%" align="right" valign="middle" class="tituloSeccion"><a href="/cfmx#opcion.uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
				<td align="left" valign="middle" class="tituloSeccion"><a href="/cfmx#opcion.uri#">#opcion.titulo#</a></td>
			</tr>
			<tr>
				<td colspan="2">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="5%">&nbsp;</td>
								<td class="etiquetaProgreso">#opcion.descripcion#<br><br></td>
							</tr>
					</table>
				</td>
			</tr>
			</cfoutput>
		</cfloop>
	</table>
<cfelse>
	Usted No tiene acceso para realizar ninguna operaci&oacute;n en este M&oacute;dulo.
</cfif>

