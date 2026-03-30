<cfquery name="rsEncabFact" datasource="#Session.Edu.DSN#">
	select EFconsecutivo, 
		   EFnumdoc, 
		   EFnombredoc, 
		   CEcontrato, 
		   CEcodigo, 
		   convert(varchar, EFfechadoc, 103) as EFfechadoc, 
		   EFfechavenc, 
		   EFfechapago, 
		   EFfechasis, 
		   EFporcdesc, 
		   EFmontodesc, 
		   convert(varchar, EFtotal, 1) as EFtotal, 
		   EFestado, 
		   EFobservacion
	from EFactura
	where EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#">
</cfquery>
<cfoutput query="rsEncabFact">
<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td colspan="4" class="tituloAlterno">Detalle de Factura</td>
  </tr>
  <tr>
    <td width="25%" align="right" style="padding-right: 10px"><b>No. Documento:</b></td>
    <td width="25%">#EFnumdoc#</td>
    <td width="25%" align="right" style="padding-right: 10px"><b>A nombre de:</b></td>
    <td width="25%">#EFnombredoc#</td>
  </tr>
  <tr>
    <td width="25%" align="right" style="padding-right: 10px"><b>Fecha del Documento:</b></td>
    <td width="25%">#EFfechadoc#</td>
    <td width="25%" align="right" style="padding-right: 10px"><b>No. Contrato:</b></td>
    <td width="25%">#CEcontrato#</td>
  </tr>
  <tr>
    <td width="25%" align="right" style="padding-right: 10px"><b>Fecha de Vencimiento:</b></td>
    <td width="25%">#EFfechadoc#</td>
    <td width="25%" align="right" style="padding-right: 10px"><b>Importe Total:</b></td>
    <td width="25%">#EFtotal#</td>
  </tr>
</table>
</cfoutput>
<cfinvoke 
 component="edu.Componentes.pListas"
 method="pListaEdu"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="DFactura a, Alumnos b, PersonaEducativo c"/>
	<cfinvokeargument name="columnas" value="convert(varchar, a.DFlinea) as DFlinea, a.Ecodigo, a.FCid, a.DFdescripcion, a.DFmonto, a.DFcantidad, convert(varchar, a.DFtotal, 1) as DFtotal, a.DFdesc, (c.Pnombre + ' ' + c.Papellido1 + ' ' + c.Papellido2) as Nombre"/>
	<cfinvokeargument name="desplegar" value="Nombre, DFdescripcion, DFtotal"/>
	<cfinvokeargument name="etiquetas" value="Estudiante, Concepto, Importe"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="a.EFid = #Form.EFid# 
	                                   and a.Ecodigo = b.Ecodigo 
									   and a.CEcodigo = b.CEcodigo 
									   and b.persona = c.persona"/>
	<cfinvokeargument name="align" value="left, left, right"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value=""/>
</cfinvoke>
<div align="center">
<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: location.href='/cfmx/edu/ced/facturacion/ConsultaFacturas.cfm';">
</div>
<br>