<cfquery name="rsFinanciamiento" datasource="#Session.DSN#">
	select 	a.CPPFid, CPPFcodigo, CPPFdescripcion,
			CPCano, CPCmes, CPNRPPFingresos, CPNRPPFconsumos
	  from CPNRPpryFinanciados a
	  	inner join CPproyectosFinanciados p
			on p.CPPFid = a.CPPFid
	  where a.Ecodigo = #session.ecodigo# 
		and a.CPNRPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPNRPnum#">
</cfquery>
<cfif rsFinanciamiento.recordcount GT 0>
	<tr>
		<td align="center">&nbsp;</td>
	</tr>
	<tr>
		<td align="center" style="padding-left: 10px; padding-right: 10px;">
			<cf_web_portlet_start titulo="Saldos Rechazados de Financiamiento Presupuestal">
				<div align="center">
					<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaQuery"
					 returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsFinanciamiento#"/>
						<cfinvokeargument name="desplegar" value="CPPFcodigo, CPPFdescripcion, CPCano, CPCmes, CPNRPPFingresos, CPNRPPFconsumos"/>
						<cfinvokeargument name="etiquetas" value="Proyecto, Descripcion, Ano, Mes, Total Ingresos<BR>Realizados, Total<BR>Consumos"/>
						<cfinvokeargument name="formatos" value="V,V,V,V,M,M"/>
						<cfinvokeargument name="align" value="left, left, center, center, right, right"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
						<cfinvokeargument name="MaxRows" value="20"/>
						<cfinvokeargument name="formName" value="listaNAPSreversion"/>
						<cfinvokeargument name="PageIndex" value="13"/>
						<cfinvokeargument name="showLink" value="false"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="lineaRoja" value="CPNRPPFingresos LT CPNRPPFconsumos"/>
					</cfinvoke>
				</div>
			<cf_web_portlet_end>
		</td>
	</tr>
	<tr>
		<td class="style1">&nbsp;&nbsp;&nbsp;(*) Proyectos que provocaron el Rechazo por falta de Financiamiento Presupuestal</td>
	</tr>
</cfif>