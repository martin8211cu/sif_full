<table width="100%" border="0" cellspacing="0">
  <tr>
    <td width="5%">&nbsp;</td>
    <td>&nbsp;</td>
    <td width="5%">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td class="fileLabel"><b>Seleccione un Almacén:</b></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		<cfquery name="rs" datasource="#session.dsn#">
			select a.Aid, a.Bdescripcion, a.Bdireccion
			from Almacen a
				inner join AResponsables ar
				on ar.Aid = a.Aid
				and ar.Usucodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				and ar.Ulocalizacion = '00'
			where a.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rs#"/>
				<cfinvokeargument name="desplegar" value="Bdescripcion, Bdireccion"/>
				<cfinvokeargument name="etiquetas" value="Descripción, Dirección"/>
				<cfinvokeargument name="formatos" value="S, S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="irA" value="vales_responsale.cfm"/>
			</cfinvoke>
	</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>