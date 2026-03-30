<cf_templateheader title="Mantenimiento de Caches">
	<cf_web_portlet_start titulo="Mantenimiento de Caches">
		<cfinclude template="frame-header.cfm">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr><td colspan="2"><cfinclude template="/home/menu/pNavegacion.cfm"></td></tr>
		  <tr>
		    <td valign="top" align="center">&nbsp;</td>
		    <td valign="top" align="center">&nbsp;</td>
	      </tr>
		  <tr>
			<td width="50%" valign="top" align="left">
				<cfinvoke
				 component="commons.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="CachesRep a"/>
					<cfinvokeargument name="columnas" value="a.CidR, a.Ccache, a.CDataSource,
															(case a.Cexclusivo when 1 then '<img src=''/cfmx/asp/imagenes/checked.gif'' border=''0''>' else '<img src=''/cfmx/asp/imagenes/unchecked.gif'' border=''0''>' end) as Exclusivo,
															(case a.Cexclusivo when 1 then (select b.CEnombre from CuentaEmpresarial b where a.CEcodigo = b.CEcodigo) else '' end) as Cuenta
															"/>
					<cfinvokeargument name="desplegar" value="Ccache, CDataSource "/>
					<cfinvokeargument name="etiquetas" value="Cache, DataSource "/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="1=1 order by Ccache"/>
					<cfinvokeargument name="align" value="left, left, center, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="cachesRep.cfm"/>
					<cfinvokeargument name="maxRows" value="20"/>
					<cfinvokeargument name="keys" value="CidR"/>
					<cfinvokeargument name="conexion" value="asp"/>
				</cfinvoke>
			</td>
			<td valign="top" align="center">
				 <cfinclude template="cachesRep-form.cfm">
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
