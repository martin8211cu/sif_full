<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td width="50%">&nbsp;</td>
	<td width="50%">&nbsp;</td>
  </tr>
  <tr>
	<td width="50%" nowrap valign="top">
		<cfinvoke 
		 component="educ.componentes.pListas"
		 method="pListaEdu"
		 returnvariable="pListaEduRet">
			<cfinvokeargument name="desplegar" value="FADdescripcion, FADmonto"/>
			<cfinvokeargument name="etiquetas" value="Detalle, Monto"/>
			<cfinvokeargument name="formatos" value="T,M"/>
			<cfinvokeargument name="filtro" value=" 
					fd.FACcodigo=#form.FACcodigo#
					and Ecodigo=#session.Ecodigo#
					and fd.FACcodigo=f.FACcodigo
				order by FADdescripcion"/>
			<cfinvokeargument name="align" value="left,right"/>
			<cfinvokeargument name="ajustar" value="N,N"/>
			<cfinvokeargument name="irA" value="facturas.cfm"/>
			<cfinvokeargument name="formName" value="formListaDetFact"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>				
			<cfinvokeargument name="tabla" value="FacturaEduDetalle fd
					, FacturaEdu f"/>
			<cfinvokeargument name="columnas" value="
				codApersona = #form.codApersona#
				, convert(varchar,fd.FACcodigo) as FACcodigo
				, convert(varchar,FADsecuencia) as FADsecuencia
				, FADdescripcion
				, FADmonto"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="keys" value="FADsecuencia"/>
		</cfinvoke>	
	</td>
	<td width="50%" nowrap valign="top">
		<cfinclude template="factura_Det.cfm"> 
	</td>
  </tr>
</table>