<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td width="47%" valign="top">
		<cfinvoke 
		 component="educ.componentes.pListas"
		 method="pListaEdu"
		 returnvariable="pListaEduRet">
			<cfinvokeargument name="tabla" value="
					FacturaEduFormaPago ffp
					, FacturaEdu fe"/>
			<cfinvokeargument name="columnas" value="
				codApersona=#form.codApersona#
				, ffp.FACcodigo
				, FAPsecuencia
				, case FAPtipo
					when 1 then 'Efectivo'
					when 2 then 'Tarjeta'
					when 3 then 'Cheque'
				end FAPtipo
				, FAPorigen
				, FAPmonto"/>			 
			<cfinvokeargument name="filtro" value=" 
					ffp.FACcodigo=#form.FACcodigo#
					and ffp.Ecodigo=#session.Ecodigo#
					and ffp.FACcodigo=fe.FACcodigo
					and ffp.Ecodigo=fe.Ecodigo
				order by FAPorigen"/>					
			<cfinvokeargument name="desplegar" value="FAPorigen, FAPtipo, FAPmonto"/>
			<cfinvokeargument name="etiquetas" value="Origen, Tipo, Monto"/>
			<cfinvokeargument name="formatos" value="T,T,M"/>
			<cfinvokeargument name="align" value="left,left,right"/>
			<cfinvokeargument name="ajustar" value="N,N,N"/>
			<cfinvokeargument name="irA" value="facturas.cfm"/>
			<cfinvokeargument name="formName" value="formListaFactFormaPago"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>				
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="keys" value="FACcodigo,FAPsecuencia"/>
		</cfinvoke>		
	</td>
	<td width="1%">&nbsp;</td>
	<td width="52%" valign="top">
		<cfinclude template="facturaFormaPago_form.cfm">
	</td>	
  </tr>
</table>