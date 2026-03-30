<tr>
	<td>
		<cf_web_portlet_start titulo="Detalle del NRP">
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="CPNRPDlinea, MesDescripcion, CuentaPresupuesto, Oficodigo, TipoControl, CalculoControl, TipoMovimiento, DisponibleAnterior, Signo, Monto, Pendientes, DisponibleNeto, Historia"/>
				<cfinvokeargument name="etiquetas" value="Lin., Mes, Cuenta<br>Presupuesto, Oficina, Tipo<br>Control, Cálculo<br>Control, Tipo<br>Movimiento,Disponible<br>Antes de<br>Rechazo,Signo<BR>Monto,Monto<BR>Rechazado, Rechazos<BR>Pendientes<BR>antes Rechazo, Disponible<br>Neto<BR>Rechazado, "/>
				<cfinvokeargument name="formatos" value="V,V,V,V,V,V,V,M,S,M,M,M,V"/>
				<cfinvokeargument name="lineaRoja" value="CPNRPDconExceso EQ 1"/>
				<cfinvokeargument name="align" value="right, center, left, left, center, center, center, right, center, right, right, right, center"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="formName" value="listaNRPS"/>
				<cfinvokeargument name="MaxRows" value="0"/>
				<cfinvokeargument name="PageIndex" value="10"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="debug" value="N"/>
			</cfinvoke>
		<cf_web_portlet_end>
	</td>
</tr>
<tr>
	<td class="style1">&nbsp;&nbsp;&nbsp;(*) Movimientos que provocaron el Rechazo Presupuestario</td>
</tr>