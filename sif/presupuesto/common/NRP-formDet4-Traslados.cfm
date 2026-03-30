<cfquery name="rsTrasladoCta" datasource="#Session.DSN#">
	select	a.CPNRPnum, a.CPNRPTsecuencia, 
			o.Oficodigo,
			b.CPformato as CuentaPresupuesto,
			CPNRPTmonto,
			4 as tab
	from 	CPNRPtrasladoOri a
				left join CPresupuesto b
					 on b.CPcuenta = a.CPcuenta
					and b.Ecodigo  = a.Ecodigo
				left join Oficinas o
					 on o.Ecodigo = a.Ecodigo
					and o.Ocodigo = a.Ocodigo
	where	a.Ecodigo = #Session.Ecodigo# 
	  and 	a.CPNRPnum = #Form.CPNRPnum#
	  order by a.CPNRPTsecuencia
</cfquery>
<tr>
	<td align="center" valign="top" style="padding-left: 10px; padding-right: 10px;">
		<cfif LvarExcesoConTraslado>
			<cfset LvarTipoAutorizado = "Traslado">
		<cfelse>									
			<cfthrow message="Si exceso no debe dar mantenimiento a Traslados">
		</cfif>
		<cf_web_portlet_start titulo="Origenes del Traslado a Autorizar">
		<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsTrasladoCta#"/>
				<cfinvokeargument name="desplegar" value="CPNRPTsecuencia, CuentaPresupuesto, Oficodigo, CPNRPTmonto"/>
				<cfinvokeargument name="etiquetas" value="Prioridad, Cuenta<br>Presupuesto, Oficina, Monto Máximo<BR>Origen Autorizado"/>
				<cfinvokeargument name="formatos" value="V,V,V,M,M,M,M"/>
				<cfinvokeargument name="align" value="center, left, left, right,right, right, right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="formName" value="listaOris"/>
				<cfinvokeargument name="MaxRows" value="0"/>
				<cfinvokeargument name="PageIndex" value="10"/>
				<cfinvokeargument name="showLink" value="#isdefined("LvarTrasladosNRP") AND rsExceso.total GT 0 AND rsFinanciamiento.recordCount EQ 0 AND rsNRPmeses.recordcount EQ 1#"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="debug" value="N"/>
		</cfinvoke>
		<cf_web_portlet_end>
		<table width="100%">
			<tr>
				<td align="right" width="90%">
					<cfoutput>
					Total Origen Autorizado:&nbsp;
					</cfoutput>
				</td>
				<td align="right" width="10%">
					<cfoutput><strong>#numberFormat(rsTrasladoOri.total,",0.00")#</strong></cfoutput>
				</td>
			</tr>
			<tr>
				<td align="right" width="90%">
					<cfoutput>
					Total Destino Autorizado:&nbsp;
					</cfoutput>
				</td>
				<td align="right" width="10%">
					<cfoutput><strong>#numberFormat(rsExceso.total,",0.00")#</strong></cfoutput>
				</td>
			</tr>
			<tr <cfif rsTrasladoOri.total NEQ rsExceso.total> style="color:#FF0000; font-weight:bolder;"</cfif>>
				<td align="right" width="90%">
					<cfoutput>
					<cfif rsTrasladoOri.total-rsExceso.total EQ 0>
					<strong>El Traslado está Completo:</strong>&nbsp;
					<cfelseif rsTrasladoOri.total-rsExceso.total LT 0>
					Origen Faltante: 
					<cfelse>
					Origen Sobrante: 
					</cfif>
					</cfoutput>
				</td>
				<td align="right" width="10%" nowrap="nowrap">
					<cfoutput><strong>#numberFormat(rsTrasladoOri.total-rsExceso.total,",0.00")#</strong></cfoutput>
				</td>
			</tr>
		</table>
	</td>
	<cfif isdefined("LvarTrasladosNRP") AND rsExceso.total GT 0 AND rsFinanciamiento.recordCount EQ 0 AND rsNRPmeses.recordcount EQ 1>
		<td>&nbsp;</td>
		<td valign="top" width="50">
			<cfinclude template="NRP-formDet4-Traslados_form.cfm">
		</td>
	</cfif>
</tr>
