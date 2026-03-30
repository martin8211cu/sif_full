<cfoutput>
<table style="vertical-align:top" width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<!--- Línea No. 1 --->
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<!--- Línea No. 2 --->
	<tr>
		<td width="2%">&nbsp;</td>
		<td bgcolor="##FAFAFA" align="center">
			<hr size="0"><font size="2" color="##000000"><strong>#LB_ListaLiquidacionDividendos#</strong></font>
		</td>
		<td width="2%">&nbsp;</td>
	</tr>
	<!--- Línea No. 3 --->

	<tr>
		<td width="2%">&nbsp;</td>
		<td bgcolor="##FAFAFA" align="left">
			<hr size="0">
			<table style="vertical-align:top" width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
				<cfif isdefined("rsTipoFactorCalculo") and trim(rsTipoFactorCalculo.Pvalor) EQ 1>
					<tr>
						<td width="15%" nowrap="nowrap"><strong>#LB_DiasDelAnio#&nbsp;:&nbsp;</strong></td>
						<td>#rsDatos.ACDfactor#</td>
					</tr>
				<cfelse>				
					<tr>
						<td width="15%" nowrap="nowrap"><strong>#LB_SaldoTotalAhorros#&nbsp;:&nbsp;</strong></td>
						<td>#LSNumberFormat(rsDatos.ACDfactor,',9.00')#</td>
					</tr>
				</cfif>									
				<tr>
					<td width="15%" nowrap="nowrap"><strong>#LB_MontoDistribuir#&nbsp;:&nbsp;</strong></td>
					<td>#LSNumberFormat(rsDatos.ACDmonto,',9.00')#</td>
				</tr>
			</table>
			<hr size="0">
		</td>
		<td width="2%">&nbsp;</td>
	</tr>
	<!--- Línea No. 4 --->
	<tr>
		<td width="2%">&nbsp;</td>
		<td >
			<cfif isdefined("rsTipoFactorCalculo") and trim(rsTipoFactorCalculo.Pvalor) EQ 1>
				<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="ACDividendosAsociados a,ACAsociados b,DatosEmpleado c"/>
					<cfinvokeargument name="columnas" value="a.ACDAid,a.ACDid,c.DEidentificacion,{fn concat({fn concat({fn concat({fn concat(c.DEnombre,' ')},c.DEapellido1)},' ')},c.DEapellido2)} as nomEmpleado,a.ACDAfactor,a.ACDAmonto,'' as c"/>
					<cfinvokeargument name="filtrar_por" value="c.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(c.DEnombre,' ')},c.DEapellido1)},' ')},c.DEapellido2)}|a.ACDAfactor|a.ACDAmonto|' '"/>
					<cfinvokeargument name="filtrar_por_delimiters" value="|"/>
					<cfinvokeargument name="desplegar" value="DEidentificacion,nomEmpleado,ACDAfactor,ACDAmonto,c"/>
					<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_NombreSocio#,#LB_DiasLaborados#,#LB_MontoSocio#, "/>
					<cfinvokeargument name="formatos" value="V,V,I,M,U"/>						
					<cfinvokeargument name="align" value="left,left,right,right,left"/>	
					<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# and b.ACAid = a.ACAid and c.DEid = b.DEid"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="keys" value="ACDAid,ACDid"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
				</cfinvoke>
			<cfelse>
				<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="ACDividendosAsociados a,ACAsociados b,DatosEmpleado c"/>
					<cfinvokeargument name="columnas" value="a.ACDAid,a.ACDid,c.DEidentificacion,{fn concat({fn concat({fn concat({fn concat(c.DEnombre,' ')},c.DEapellido1)},' ')},c.DEapellido2)} as nomEmpleado,a.ACDAfactor,a.ACDAmonto,'' as c"/>
					<cfinvokeargument name="filtrar_por" value="c.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(c.DEnombre,' ')},c.DEapellido1)},' ')},c.DEapellido2)}|a.ACDAfactor|a.ACDAmonto|' '"/>
					<cfinvokeargument name="filtrar_por_delimiters" value="|"/>
					<cfinvokeargument name="desplegar" value="DEidentificacion,nomEmpleado,ACDAfactor,ACDAmonto,c"/>
					<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_NombreSocio#,#LB_TotalAhorros#,#LB_MontoSocio#, "/>
					<cfinvokeargument name="formatos" value="V,V,M,M,U"/>
					<cfinvokeargument name="align" value="left,left,right,right,left"/>	
					<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# and b.ACAid = a.ACAid and c.DEid = b.DEid"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="keys" value="ACDAid,ACDid"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
				</cfinvoke>
			
			</cfif>
		</td>
		<td width="2%">&nbsp;</td>
	</tr>
	<!--- Línea No. 5 --->	
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	
</table>
</cfoutput>