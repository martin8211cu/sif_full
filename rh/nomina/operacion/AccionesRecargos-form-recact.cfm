
<cfif isdefined('Form.DEid') and len(trim(Form.DEid))>
	<cfquery name="rsRecargoPlazas" datasource="#session.DSN#">
	/*Este es para sacar los detalles de la linea de tiempo de Recargo*/
	select a.LTRid, a.LTdesde as desde, a.LThasta as hasta, a.LTsalario as SalarioNominal, 
			((a.LTsalario/coalesce( convert(numeric(30,10),t.FactorDiasSalario) , (30.0) ))*30) as SalarioMensual, 
			((a.LTsalario/coalesce( convert(numeric(30,10),t.FactorDiasSalario) , (30.0) ))*360) as SalarioAnual, 
			((a.LTsalario/coalesce( convert(numeric(30,10),t.FactorDiasSalario) , (30.0) ))*1) as SalarioDiario, 
			p.RHPdescripcion, cf.CFdescripcion 
	from LineaTiempoR a 
		inner join TiposNomina t 
			on t.Ecodigo = a.Ecodigo 
			and t.Tcodigo = a.Tcodigo 
		inner join RHPlazas p 
			 on p.RHPid = a.RHPid 
			inner join CFuncional cf 
				on cf.CFid = p.CFid 
			inner join RHPuestos e 
				on e.RHPcodigo = p.RHPpuesto 
				and e.Ecodigo = p.Ecodigo 
		
	where a.DEid = #Form.DEid#
	order by LTdesde desc
	</cfquery>
	<!---<cfdump var="#rsRecargoPlazas#" label="rsRecargoPlazas">--->	
	
	
	<cfquery name="rsRecargoPlazas" datasource="#Session.DSN#">
		select c.CSid, 
			   c.CScodigo, 
			   c.CSdescripcion,
			   c.CSusatabla,
			   c.CSsalariobase,
			   b.DLTtabla, 
			   coalesce(b.DLTunidades, 0.00) as DLTunidades, 
			   case when d.RHMCcomportamiento = 1 then round(coalesce(b.DLTmonto, 0.00) * 100.0 / coalesce(b.DLTunidades, 1.00), 2)
					else round(coalesce(b.DLTmonto, 0.00)/coalesce(b.DLTunidades, 1.00), 2) 
			   end as DLTmontobase,
			   coalesce(b.DLTmonto, 0.00) as DLTmonto, 
			   coalesce(c.CIid, -1) as CIid,
			   coalesce(d.RHMCcomportamiento, 1) as RHMCcomportamiento,
			   coalesce(d.RHMCvalor, 1.00) as valor
			   ,e.RHPcodigo
			   ,e.RHPdescpuesto
			   ,cf.CFcodigo
			   ,cf.CFdescripcion
			   ,p.RHPdescripcion
		from 
			LineaTiempoR a	
			 inner join DLineaTiempoR b
			 	on a.LTRid =  b.LTRid
			 inner join ComponentesSalariales c
				on c.CSid = b.CSid
			 inner join RHPlazas p 
				 on p.RHPid = a.RHPid 
			 inner join CFuncional cf 
					on cf.CFid = p.CFid 
			 inner join RHPuestos e 
					on e.RHPcodigo = p.RHPpuesto 
					and e.Ecodigo = p.Ecodigo 
			 
			 left outer join RHMetodosCalculo d
				on d.Ecodigo = c.Ecodigo
				and d.CSid = c.CSid
				and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.rige#"> between d.RHMCfecharige and d.RHMCfechahasta
				and d.RHMCestadometodo = 1
		where 
			 a.DEid = #Form.DEid#
			<!---b.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.LTid#">--->
		order by c.CSorden, c.CScodigo, c.CSdescripcion
	</cfquery>
	
	<!---<cf_dump var="#rsRecargoPlazas#">--->
	
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
	  <tr>
		<td class="#Session.Preferences.Skin#_thcenter"><div align="center"><cf_translate key="LB_Situacion_Actual">Situaci&oacute;n Actual, Recargos</cf_translate></div></td>
	  </tr>
	  
	  <tr>
		<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;">
				  <tr>
					<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Plaza">Puesto</cf_translate></td>
					<td height="25" nowrap>#rsRecargoPlazas.RHPcodigo# -  #rsRecargoPlazas.RHPdescripcion#</td>
				  </tr>
				  <tr>
					<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Centro_Funcional">Centro Funcional</cf_translate></td>
					<td>#rsRecargoPlazas.CFcodigo#-#rsRecargoPlazas.CFdescripcion#</td>
				  </tr>
				  <tr>
					<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Puesto_RH">Plaza</cf_translate></td>
					<td height="25" nowrap>#rsRecargoPlazas.RHPdescpuesto#</td>
				  </tr>	
				 <tr>
					<td colspan="2" class="fileLabel" nowrap>&nbsp;</td>
				  </tr>
				 <tr>
					<td colspan="2" class="fileLabel" bgcolor="##EBEBEB" nowrap><cf_translate key="LB_CompoAsociados_RH">Plaza Componentes Asociados</cf_translate></td>
				  </tr>
				 <tr>
					<td colspan="2">
						<cfinvoke component="rh.Componentes.RH_CompSalarial" method="pComponentes" returnvariable="result">
							<cfinvokeargument name="query" value="#rsRecargoPlazas#">
							<cfinvokeargument name="totalComponentes" value="0.00">
							<cfinvokeargument name="permiteAgregar" value="false">
							<cfinvokeargument name="unidades" value="DLTunidades">
							<cfinvokeargument name="montobase" value="DLTmontobase">
							<cfinvokeargument name="montores" value="DLTmonto">
							<cfinvokeargument name="readonly" value="true">
							<cfinvokeargument name="incluyeHiddens" value="false">
						</cfinvoke>
					</td>
				  </tr>	
				 
				 
				  <!---<tr>
					<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Porcentaje_de_Plaza">Porcentaje de Plaza</cf_translate></td>
					<td height="25" nowrap><cfif rsRecargoPlazas.LTporcplaza NEQ "">#LSCurrencyFormat(rsRecargoPlazas.LTporcplaza,'none')# %<cfelse>0.00 %</cfif></td>
				  </tr>
				  <tr>
					<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Porcentaje_de_Salario_Fijo">Porcentaje de Salario Fijo</cf_translate></td>
					<td height="25" nowrap><cfif rsRecargoPlazas.LTporcsal NEQ "">#LSCurrencyFormat(rsRecargoPlazas.LTporcsal,'none')# %<cfelse>0.00 %</cfif></td>
				  </tr>--->
				 </table>
			</td>
		</tr>
		
		
	</table>
	</cfoutput>
</cfif>


<!---<cfdump var="#rsRecargoPlazas#" label="rsRecargoPlazas">--->

<!---
<cfsavecontent variable="listaAcciones">
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="cantRegistros">
		<cfinvokeargument name="tabla" value="DLaboralesEmpleado a, RHTipoAccion b, RHPlazas c"/>
		<cfinvokeargument name="columnas" value="  a.DLlinea, 
												   a.DLconsecutivo, 
												   a.DEid as DEid, 
												   a.RHTid as RHTid, 
												   a.Dcodigo, 
												   a.Ocodigo, 
												   a.RHPid as RHPid, 
												   a.RHPcodigo, 
												   a.Tcodigo, 
												   case when a.DLfvigencia is not null then a.DLfvigencia else '' end as Vigencia,
												   case when a.DLffin is not null then a.DLffin else '' end as Finalizacion,
												   a.DLsalario as DLsalario, 
												   a.DLobs, 
												   a.DLfechaaplic as FechaAplicacion,
												   {fn concat(b.RHTcodigo ,{fn concat(' - ',b.RHTdesc)})} as Accion,
												   b.RHTcomportam as Comportamiento,
												   c.RHPdescripcion,
												   b.RHTespecial
												   "/>
		<cfinvokeargument name="desplegar" value="FechaAplicacion, Accion, Comportamiento, Vigencia, Finalizacion, RHPdescripcion, DLsalario"/>
		<cfinvokeargument name="etiquetas" value="FechaAplicacion, Accion, Comportamiento, Vigencia, Finalizacion, RHPdescripcion, DLsalario"/>
		<cfinvokeargument name="formatos" value="V,V,V,V,V,V,M"/>
		<cfinvokeargument name="filtro" value="a.DEid = 4839
												and a.RHTid = b.RHTid
												and a.RHPid = c.RHPid
												and  b.RHTcomportam = 12
												order by a.DLfechaaplic desc, a.DLfvigencia, a.DLffin, a.DLconsecutivo"/>
		<cfinvokeargument name="align" value="center, left, left, center, center, left, right"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
		<cfinvokeargument name="MaxRows" value="10"/>
		<!---<cfinvokeargument name="navegacion" value="#navegacion#"/>--->
		<cfinvokeargument name="debug" value="N"/>
		 <cfinvokeargument name="PageIndex" value="2"/>
		
	</cfinvoke>
</cfsavecontent>

<cfoutput>
	#listaAcciones#
</cfoutput>--->