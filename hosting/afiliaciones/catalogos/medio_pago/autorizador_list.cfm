
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
  <td valign="top">&nbsp;</td>
</tr>
<tr> 
  <td valign="top" class="tituloListas">
  Autorizadores seleccionados para su empresa </td>
</tr>
<tr>
  <td valign="top">
	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		 returnvariable="pLista">
	  <cfinvokeargument name="tabla" value="AutorizadorEmpresa ae, ComercioAfiliado c, Autorizador a"/>
	  <cfinvokeargument name="columnas" value="1 as ex,convert(varchar,ae.autorizador) as autorizador, convert(varchar,ae.comercio) as comercio, c.moneda, a.nombre_autorizador, ae.prioridad"/>
	  <cfinvokeargument name="desplegar" value="nombre_autorizador,moneda,prioridad"/>
	  <cfinvokeargument name="etiquetas" value="Nombre autorizador,Moneda,Prioridad"/>
	  <cfinvokeargument name="formatos" value=""/>
	  <cfinvokeargument name="filtro" value="ae.Ecodigosdc = #session.EcodigoSDC# and ae.autorizador=c.autorizador and ae.comercio=c.comercio and c.autorizador=a.autorizador order by ae.prioridad, a.nombre_autorizador, c.moneda"/>
	  <cfinvokeargument name="align" value="left,left,right"/>
	  <cfinvokeargument name="ajustar" value="N,N,N"/>
	  <cfinvokeargument name="checkboxes" value="N"/>
	  <cfinvokeargument name="irA" value="autorizador.cfm"/>
	  <cfinvokeargument name="conexion" value="aspsecure"/>
	  <cfinvokeargument name="formName" value="YY"/>
	  <cfinvokeargument name="MaxRows"  value="0"/>
	</cfinvoke></td>
</tr>
<tr>
  <td valign="top">&nbsp;</td>
</tr>
<tr> 
  <td valign="top" class="tituloListas">
    Autorizadores disponibles </td>
</tr>
<tr>
  <td valign="top">
	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		 returnvariable="pLista">
	  <cfinvokeargument name="tabla" value="ComercioAfiliado c, Autorizador a"/>
	  <cfinvokeargument name="columnas" value="0 as ex,convert(varchar,c.autorizador) as autorizador, convert(varchar,c.comercio) as comercio, c.moneda, a.nombre_autorizador"/>
	  <cfinvokeargument name="desplegar" value="nombre_autorizador,moneda"/>
	  <cfinvokeargument name="etiquetas" value="Nombre autorizador,Moneda"/>
	  <cfinvokeargument name="formatos" value=""/>
	  <cfinvokeargument name="filtro" value="not exists (select * from AutorizadorEmpresa ae where ae.Ecodigosdc = #session.EcodigoSDC#  and ae.autorizador=c.autorizador and ae.comercio=c.comercio ) and c.autorizador=a.autorizador order by a.nombre_autorizador, c.moneda"/>
	  <cfinvokeargument name="align" value="left,right"/>
	  <cfinvokeargument name="ajustar" value="N,N"/>
	  <cfinvokeargument name="checkboxes" value="N"/>
	  <cfinvokeargument name="irA" value="autorizador.cfm"/>
	  <cfinvokeargument name="conexion" value="aspsecure"/>
	  <cfinvokeargument name="formName" value="ZZ"/>
	  <cfinvokeargument name="MaxRows"  value="0"/>
	</cfinvoke></td>
</tr>
</table>
