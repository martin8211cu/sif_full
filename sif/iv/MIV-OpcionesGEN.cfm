<cfset menu1 = ArrayNew(1)><!--- Coleccion de Opciones --->

<cfif acceso_uri("/sif/iv/operacion/Requisiciones-lista.cfm")>
	<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
	<cfset opcion.uri = "/sif/iv/operacion/Requisiciones-lista.cfm">
	<cfset opcion.titulo = "Registro de Requisiciones de Inventario">
	<cfset opcion.descripcion = "Las requisiciones de inventario tienen como funcionalidad extraer 
							los art&iacute;culos del inventario para uso de estos internamente en la empresa. Al
							igual que el resto de los movimientos, es necesario capturar informaci&oacute;n del 
							encabezado de la requisici&oacute;n y posteriormente los detalles de esta.">
	<cfset ArrayAppend(menu1,opcion)>
</cfif>	

<cfif acceso_uri("/sif/iv/operacion/Ajustes-lista.cfm")>
	<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
	<cfset opcion.uri = "/sif/iv/operacion/Ajustes-lista.cfm">
	<cfset opcion.titulo = "Registro de Ajustes de Inventario">
	<cfset opcion.descripcion = "El ajuste de inventario es el proceso mediante el cual se modifica 
							las existencias de uno o m&uacute;ltiples art&iacute;culos de inventario, este proceso 
							realiza funciones muy similares que el inventario f&iacute;sico. El 
							inventario f&iacute;sico sustituye las existencias del inventario, en tanto que el ajuste 
							suma o resta a las existencias actuales las cantidades indicadas por el usuario.">
	<cfset ArrayAppend(menu1,opcion)>
</cfif>

<cfif acceso_uri("/sif/iv/operacion/listaMovInterAlmacen.cfm")>
	<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
	<cfset opcion.uri = "/sif/iv/operacion/listaMovInterAlmacen.cfm">
	<cfset opcion.titulo = "Registro de Movimientos InterAlmac&eacute;n">
	<cfset opcion.descripcion = "EL movimiento interalmac&eacute;n es el proceso mediante el cual 
							se registra el traslado de uno o m&uacute;ltiples art&iacute;culos de inventario de 
							un almac&eacute;n a otro, modificando as&iacute; las existencias de los art&iacute;culos 
							trasladados en ambos almacenes seg&uacute;n corresponde. El sistema permitir&aacute; la 
							captura del almac&eacute;n origen y destino, as&iacute; como el documento y la fecha 
							probatorios de la transacci&oacute;n. Una vez capturados estos datos se procede a 
							capturar los art&iacute;culos trasladados.">
	<cfset ArrayAppend(menu1,opcion)>
</cfif> 

<cfif acceso_uri("/sif/iv/operacion/gas/capturaSalidas.cfm")>
	<cfset opcion = StructNew()><!--- Uri, Titulo, Descripcion --->
	<cfset opcion.uri = "/sif/iv/operacion/gas/capturaSalidas.cfm">
	<cfset opcion.titulo = "Captura de Salidas">
	<cfset opcion.descripcion = "Control del inventario de combustibles, lubricantes, aditivos y otros para 
							las estaciones de servicio">
	<cfset ArrayAppend(menu1,opcion)>
</cfif>



<cfif ArrayLen(menu1) gt 0>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<cfloop from="1" to="#ArrayLen(menu1)#" index="i">
			<cfset opcion = StructNew()>
			<cfset opcion = menu1[i]>
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

