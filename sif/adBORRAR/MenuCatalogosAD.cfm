<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Cat&aacute;logos">
<cfquery name="rsParametros" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Pcodigo = 1
		and Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>
<table border="0" cellpadding="2" cellspacing="0" >

	<!--- Cuentas Contables --->
	<tr> 
		<td align="center" class="etiquetaProgreso"  ><a href="/cfmx/sif/cg/catalogos/CuentasMayor.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
		<td nowrap class="etiquetaProgreso" ><a href="/cfmx/sif/cg/catalogos/CuentasMayor.cfm">Cat&aacute;logo Contable</a></td>
	</tr>
	<!--- Tipos de Operacion Bancos--->
	<tr> 
		<td align="center" valign="middle"><a href="/cfmx/sif/mb/catalogos/TiposTransaccion.cfm?desde=AD"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
		<td nowrap class="etiquetaProgreso" ><a href="/cfmx/sif/mb/catalogos/TiposTransaccion.cfm?desde=AD">Tipos de Operaci&oacute;n Bancos</a></td>
	</tr>
	<!--- Tipos de Transaccion Cuentas por Pagar --->
	<tr> 
		<td align="center"><a href="/cfmx/sif/cp/catalogos/TipoTransacciones.cfm" ><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="/cfmx/sif/cp/catalogos/TipoTransacciones.cfm">Transacciones Cuentas por Pagar</a></td>
	</tr>
	<!--- Tipos de Transaccion Cuentas por Cobrar --->
	<tr> 
		<td align="center"><a href="/cfmx/sif/cc/catalogos/TipoTransacciones.cfm" ><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="/cfmx/sif/cc/catalogos/TipoTransacciones.cfm">Transacciones Cuentas por Cobrar</a></td>
	</tr>
	<!--- Origenes de Datos --->
	<tr> 
		<td align="center"><a href="/cfmx/sif/ad/catalogos/Origenes.cfm"><img src="../imagenes/16x16_flecha_right.gif" border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="/cfmx/sif/ad/catalogos/Origenes.cfm">Or&iacute;genes de M&oacute;dulos Externos</a></td>
	</tr>

	<!--- Conceptos Contables --->
	<tr> 
		<td align="center"><a href="/cfmx/sif/cg/catalogos/ConceptoContableE.cfm"><img src="../imagenes/16x16_flecha_right.gif" border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/ConceptoContableE.cfm">Conceptos Contables</a></td>
	</tr>

	<!--- Conceptos Contables por Origen --->
	<tr> 
		<td align="center"><a href="/cfmx/sif/cg/catalogos/ConceptoContable.cfm"><img src="../imagenes/16x16_flecha_right.gif" border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/ConceptoContable.cfm">Conceptos Contables por Origen</a></td>
	</tr>

	<!--- Socios de Negocios--->
	<tr> 
		<td align="center"><a href="catalogos/listaSocios.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="catalogos/listaSocios.cfm"><cfoutput>#Request.Translate('Socios','Socios de Negocios')#</cfoutput></a></td>
	</tr>
	<!--- Dirección del Socio de Negocios --->
	<tr> 
		<td align="center"><a href="catalogos/listaSocios_Direcciones.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="catalogos/listaSocios_Direcciones.cfm"><cfoutput>#Request.Translate('Socios_Direccion','Dirección del Socio de Negocios')#</cfoutput></a></td>
	</tr>

	<!--- Clasificacion de Socios de Negocios--->
	<tr> 
		<td align="center">
			<a href="/cfmx/sif/ad/catalogos/SNClasificaciones.cfm">
				<img src="../imagenes/16x16_flecha_right.gif" border="0">
			</a>
		</td>
		<td nowrap class="etiquetaProgreso">
			<a href="catalogos/SNClasificaciones.cfm">
				Clasificación de Socios de Negocio
			</a>
		</td>
	</tr>
	<!--- Mascara de Socios de Negocios--->
	<tr> 
		<td align="center">
			<a href="/cfmx/sif/ad/catalogos/SNMascara.cfm">
				<img src="../imagenes/16x16_flecha_right.gif" border="0">
			</a>
		</td>
		<td nowrap class="etiquetaProgreso">
			<a href="catalogos/SNMascara.cfm">
				Mascaras del Socio de Negocio
			</a>
		</td>
	</tr>


	<!--- Clasificacion de Socios de Negocios--->
	<tr> 
		<td align="center"><a href="/cfmx/sif/ad/catalogos/ClasificacionSocioNeg.cfm"><img src="../imagenes/16x16_flecha_right.gif" border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="catalogos/ClasificacionSocioNeg.cfm">Clasificación de Artículos y Servicios para Socios de Negocio</a></td>
	</tr>


	<!--- Impuestos --->
	<tr> 
		<td align="center"><a href="catalogos/Impuestos.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="catalogos/Impuestos.cfm"><cfoutput>#Request.Translate('Impuestos','Impuestos')#</cfoutput></a></td>
	</tr>

	<!--- Retenciones--->
	<tr> 
		<td align="center"><a href="catalogos/Retenciones.cfm" ><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="catalogos/Retenciones.cfm">Retenciones</a></td>
	</tr>
	
	<!--- Clasificacion de Conceptos --->
	<tr> 
		<td align="center"><a href="../ad/catalogos/CConceptos.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="../ad/catalogos/CConceptos.cfm">Clasificaci&oacute;n de Conceptos de Servicio</a></td>
	</tr>
	<!--- Matenimiento Catalogo Conceptos De Pagos a Terceros --->
	<tr> 
		<td align="center"><a href="../tesoreria/reportes/ConceptoPagosTerceros.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="../tesoreria/reportes/ConceptoPagosTerceros.cfm">Conceptos de Cobros Y Pagos Terceros</a></td>
	</tr>
	
	<!--- Conceptos de Facturacion --->
	<tr> 
		<td align="center"><a href="../ad/catalogos/Conceptos.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="../ad/catalogos/Conceptos.cfm">Conceptos de Servicio</a></td>
	</tr>
	<!--- Tipos de Eventos --->
	<tr> 
		<td align="center"><a href="catalogos/TiposEventos.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="catalogos/TiposEventos.cfm">Tipos de Eventos</a></td>
	</tr>
	<!--- Datos Variables --->
	<tr> 
		<td align="center"><a href="catalogos/DatosVariables.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="catalogos/DatosVariables.cfm">Datos Variables</a></td>
	</tr>
	<!--- Configuración de Datos Variables y Eventos --->
	<tr> 
		<td align="center"><a href="catalogos/DatosVariablesConfig.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
		<td nowrap class="etiquetaProgreso"><a href="catalogos/DatosVariablesConfig.cfm">Configuración de Datos Variables y Eventos</a></td>
	</tr>
</table>
</cf_web_portlet>

<br />
<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Consultas">
	<table border="0" cellpadding="2" cellspacing="0" >
		<!--- Cuentas Contables --->
		<cfif acceso_uri("/sif/ad/consultas/usuariosPermisos-filtro.cfm")>
			<tr> 
				<td align="center" class="etiquetaProgreso"  ><a href="/cfmx/sif/ad/consultas/usuariosPermisos-filtro.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
				<td nowrap class="etiquetaProgreso" ><a href="/cfmx/sif/ad/consultas/usuariosPermisos-filtro.cfm">Permisos por usuario</a></td>
			</tr>
		</cfif>
		<!--- Tipos de Operacion Bancos--->
		<cfif acceso_uri("/sif/ad/consultas/permisosUsuario-filtro.cfm")>
		<tr> 
			<td align="center" valign="middle"><a href="/cfmx/sif/ad/consultas/permisosUsuario-filtro.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
			<td nowrap class="etiquetaProgreso" ><a href="/cfmx/sif/ad/consultas/permisosUsuario-filtro.cfm">Usuarios por permiso</a></td>
		</tr>
		</cfif>
		<!--- Tipos de Operacion Bancos--->
		<tr> 
			<td align="center" valign="middle"><a href="/cfmx/sif/ad/consultas/SociosXClasificacion_form.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
			<td nowrap class="etiquetaProgreso" ><a href="/cfmx/sif/ad/consultas/SociosXClasificacion_form.cfm">Socios por Clasificación</a></td>
		</tr>
		<tr> 
			<td align="center" valign="middle"><a href="/cfmx/sif/ad/consultas/CFReporte.cfm"><img src="../imagenes/16x16_flecha_right.gif"  border="0"></a></td>
			<td nowrap class="etiquetaProgreso" ><a href="/cfmx/sif/ad/consultas/CFReporte.cfm">Reporte Centro Funcional</a></td>
		</tr>
	</table>
</cf_web_portlet>



