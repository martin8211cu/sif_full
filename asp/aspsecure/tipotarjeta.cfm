<cf_templateheader title="Mantenimiento de Tipos de Tarjeta">
<cfparam name="url.tc_tipo" default="">
<cfparam name="form.tc_tipo" default="#url.tc_tipo#">

<cfquery datasource="aspsecure" name="data">
	select tc_tipo, nombre_tipo_tarjeta, mascara
	from TipoTarjeta
	where tc_tipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tc_tipo#" null="#len(form.tc_tipo) is 0#">
</cfquery>

	<cfinclude template="/home/menu/pNavegacion.cfm">

	<cf_web_portlet_start titulo="Mantenimiento de Tipos de Tarjeta">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td valign="top" align="center">&nbsp;</td>
		    <td width="6%" align="center" valign="top">&nbsp;</td>
		    <td width="47%" align="center" valign="top">&nbsp;</td>
	      </tr>
		  <tr>
			<td width="47%" valign="top" align="left">
				<cfinvoke 
				 component="commons.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="TipoTarjeta a"/>
					<cfinvokeargument name="columnas" value="a.tc_tipo, a.nombre_tipo_tarjeta"/>
					<cfinvokeargument name="desplegar" value="tc_tipo, nombre_tipo_tarjeta"/>
					<cfinvokeargument name="etiquetas" value="Codigo,Tipo de tarjeta"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="1=1 order by tc_tipo"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="tipotarjeta.cfm"/>
					<cfinvokeargument name="maxRows" value="20"/>
					<cfinvokeargument name="keys" value="tc_tipo"/>
					<cfinvokeargument name="conexion" value="aspsecure"/>
					<cfinvokeargument name="showEmptyListMsg" value="#true#"/>
				</cfinvoke>
			</td>
			<td valign="top" align="center">&nbsp;</td>
			<td valign="top" align="center"> 
<cfoutput>
<form action="tipotarjeta-sql.cfm" method="post" name="form1">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2" valign="top" class="subTitulo">Datos del Tipo de tarjeta </td>
    </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top" class="tituloListas">C&oacute;digo</td>
  </tr>
  <tr>
    <td width="14%" valign="top">&nbsp;</td>
    <td width="86%" valign="top">
	<input type="text" size="40" name="tc_tipo" id="tc_tipo" value="#HTMLEditFormat(Trim(data.tc_tipo))#" onFocus="this.select()"></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top" class="tituloListas">Nombre</td>
  </tr>
  <tr>
    <td width="14%" valign="top">&nbsp;</td>
    <td width="86%" valign="top">
	<input type="text" size="40" name="nombre_tipo_tarjeta" id="nombre_tipo_tarjeta" value="#HTMLEditFormat(Trim(data.nombre_tipo_tarjeta))#" onFocus="this.select()"></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top" class="tituloListas">M&aacute;scara</td>
  </tr>
  <tr>
    <td width="14%" valign="top">&nbsp;</td>
    <td width="86%" valign="top">
	<input type="text" size="40" name="mascara" id="mascara" value="#HTMLEditFormat(Trim(data.mascara))#" onFocus="this.select()"></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" align="center" valign="top"><cfif len(form.tc_tipo)>
      <input name="cambio" type="submit" id="cambio" value="Guardar">
      <input name="baja" type="submit" id="baja" value="Eliminar" onClick="return confirm('Desea eliminar el registro')">
      <input name="nuevo" type="button" id="nuevo" value="Nuevo" onClick="location.href='tipotarjeta.cfm'"> 
      <cfelse>
	  <input name="alta" type="submit" id="alta" value="Agregar">
		</cfif></td>
    </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
</table>

		</form></cfoutput>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
