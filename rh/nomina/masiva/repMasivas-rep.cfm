<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Semanal" default="Semanal"	returnvariable="LB_Semanal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Bisemanal" default="Bisemanal" returnvariable="LB_Bisemanal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Quincenal" default="Quincenal" returnvariable="LB_Quincenal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_No_Exite_Informacion_Asociada" default="No Existe Informaci&oacute;n Asociada" returnvariable="LB_No_Exite_Informacion_Asociada"/>

<cfif not isdefined('url.imprimir')>
	<cfset url.imprimir = ''>
</cfif>	

<cfquery name="rsAccion" datasource="#session.DSN#">
	select * from #TMPAccionesX#
</cfquery>

<cfif rsAccion.recordCount EQ 0>
	<cfthrow message="#LB_No_Exite_Informacion_Asociada#">
</cfif>

<!---rsAccion
<cf_dump var="#rsAccion#">--->

<cfif form.formato EQ 'html'>
<cfoutput query="rsAccion">
	
	<!--- Conceptos de Pago --->
	<cfquery name="rsConceptosPago" datasource="#Session.DSN#">
		select {fn concat({fn concat(rtrim(b.CIcodigo) , ' - ' )},  b.CIdescripcion )}  as Concepto, 
			a.DDCimporte as Importe, 
			a.DDCcant as Cantidad, 
			a.DDCres as Resultado
		from DDConceptosEmpleado a
		
			inner join CIncidentes b
			on a.CIid = b.CIid
			
			where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DLlinea#">
	</cfquery>
	
	<cfquery name="rsDetalleAccion" datasource="#Session.DSN#">
		select a.CSid,
			b.CScodigo, 
			a.DDLtabla, 
			b.CSdescripcion,
			a.DDLunidad, 
			a.DDLmontobase, 
			a.DDLmontores,
			coalesce(a.DDLunidadant,0.00) as UnidadAnterior, 
			coalesce(a.DDLmontobaseant,0.00) as MontoBaseAnterior, 
			coalesce(a.DDLmontoresant,0.00) as MontoResultadoAnterior,
			a.CIid
		
		from DDLaboralesEmpleado a
		
			inner join ComponentesSalariales b
			on a.CSid = b.CSid
			
			where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DLlinea#">
			
			order by b.CScodigo, b.CSdescripcion
	</cfquery>
	
	<cfif rsDetalleAccion.recordCount GT 0>
		<cfquery name="rsSumDetalleAccion" dbtype="query">
			select sum(DDLmontores) as Total, 
			sum(MontoResultadoAnterior) as TotalAnterior 
			from rsDetalleAccion
			where CIid is null
		</cfquery>
	</cfif>
			
	<cfquery name="rsMostrarSalarioNominal" datasource="#session.DSN#">
		select coalesce(Pvalor,'0') as  Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = 1040
	</cfquery>
	
	<table width="<cfif isdefined('url.imprimir')>650<cfelse>100%</cfif>" cellpadding="3" cellspacing="0" >
	<tr> 
		<td class="#Session.preferences.Skin#_thcenter" colspan="2"><cf_translate key="LB_Datos_Generales">DATOS GENERALES</cf_translate></td>
	</tr>
	<tr> 
		<td width="10%" align="center" valign="top" style="padding-left: 10px; padding-right: 10px;"> 
		<!-------------------------->
		<table border="1" cellspacing="0" cellpadding="0">
			<tr><td>
					<img src="../../nomina/consultas/jerarquia_cf/foto_responsable.cfm?s=#URLEncodedFormat(rsAccion.DEid)#" border="0" width="55" height="73">
			</td></tr>
		</table>
		<!-------------------------->
	  </td>
	  <td valign="top" nowrap> 
		  <table width="100%" border="0" cellpadding="5" cellspacing="0">
			<tr> 
			  <td class="fileLabel" width="10%" nowrap><cf_translate key="LB_Nombre_Completo">Nombre Completo</cf_translate>:</td>
			  <td><b><font size="3">#rsAccion.NombreCompleto#</font></b></td>
			</tr>
			<tr> 
			  <td class="fileLabel" width="10%" nowrap align="right" ><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate>:</td>
			  <td>#rsAccion.DEidentificacion#</td>
			</tr>
		  </table>
	  </td>
	</tr>
	</table>
	
	
	<table width="<cfif isdefined('url.imprimir')>650<cfelse>100%</cfif>" border="0" cellspacing="0" cellpadding="2" align="center">
		<tr>
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="TipoDeAccion">Tipo de Acci&oacute;n</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>> 
				#rsAccion.RHTid# - #rsAccion.DesTipoAccion#
			</td>
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="FechaAplicacion">Fecha Aplicaci&oacute;n</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				#LSDateFormat(rsAccion.DLfechaaplic,'dd/mm/yyyy')#
			</td>
		</tr>
		<tr> 
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="FechaVigencia">Fecha Vigencia</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				#LSDateFormat(rsAccion.DLfvigencia,'dd/mm/yyyy')#
			</td>
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="FechaVencimiento">Fecha Vencimiento</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				<cfif len(trim(rsAccion.DLffin)) >#LSDateFormat(rsAccion.DLffin,'dd/mm/yyyy')#<cfelse><cf_translate key="indefinido">INDEFINIDO</cf_translate></cfif>
			</td>
		</tr>
		<tr> 
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="Observaciones">Observaciones</cf_translate>:</td>
			<td colspan="3" <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				#rsAccion.DLobs#
			</td>
		</tr>	
		<tr>
			<td colspan="4">
			<table width="100%" border="0" cellspacing="0" cellpadding="2">
				<tr>
				<td width="50%" valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
					<tr>
						<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="SituacionAnterior">Situaci&oacute;n Anterior</cf_translate>
						</div></td>
					</tr>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Plaza">Plaza</cf_translate></td>
						<td height="25">#rsAccion.DesPlazaAnt#</td>
					</tr>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesOficinaAnt#</td>
					</tr>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Departamento">Departamento</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesDeparAnt#</td>
					</tr>
					<cfif usaEstructuraSalarial EQ 1>
							<cfif len(trim(rsAccion.Tcodigoant))>
								<cf_rhcategoriapuesto form="form1" query="#rsAccion#" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">							
							<cfelse>
								<cf_rhcategoriapuesto form="form1" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">
							</cfif>
					</cfif>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Puesto_RH">Puesto RH</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesPuestoAnt#</td>
					</tr>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Jornada">Jornada</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesJornadaAnt#</td>
					</tr>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="PorcentajeDePlaza">Porcentaje de Plaza</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cfif rsAccion.DLporcplazaant NEQ "">#LSCurrencyFormat(rsAccion.DLporcplazaant,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="PorcentajeDeSalarioFijo">Porcentaje de Salario Fijo</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cfif rsAccion.DLporcsalant NEQ "">#LSCurrencyFormat(rsAccion.DLporcsalant,'none')# %<cfelse>0.00 %</cfif></td>
					</tr>
	  
	
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="TipoDeNomina">Tipo de N&oacute;mina</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesTNominaAnt#</td>
					</tr>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="RegimenDeVacaciones">R&eacute;gimen de Vacaciones</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesRegVacAnt#</td>
					</tr>
				</table>
				
				</td>
				<td width="50%" valign="top">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
					  <tr>
						<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="SituacionActual">Situaci&oacute;n Actual</cf_translate></div></td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Plaza">Plaza</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesPlaza#</td>
						</tr>
							
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesOficina# </td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Departamento">Departamento</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesDepar#</td>
					  </tr>
						<cfif usaEstructuraSalarial EQ 1>
							<cf_rhcategoriapuesto form="form1" query="#rsAccion#" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">
						</cfif>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Puesto_RH">Puesto RH</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.RHPCodigo# - #rsAccion.DesPuesto# </td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Jornada">Jornada</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesJornada#</td>
						</tr>  	
					  <tr>	
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="PorcentajeDePlaza">Porcentaje de Plaza</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cfif rsAccion.DLporcplaza NEQ "">#LSCurrencyFormat(rsAccion.DLporcplaza,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="PorcentajeDeSalarioFijo">Porcentaje de Salario Fijo</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cfif rsAccion.DLporcsal NEQ "">#LSCurrencyFormat(rsAccion.DLporcsal,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
	
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="TipoDeNomina">Tipo de N&oacute;mina</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesTnomina#</td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="RegimenDeVacaciones">R&eacute;gimen de Vacaciones</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesRegVac# </td>
					  </tr>
				</table>
			
			  </tr>
			  
			  <tr <cfif rsAccion.RHTNoMuestraCS eq 1 >style="display:none"</cfif>>
				<td valign="top" > 
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
					  <cfif isdefined("rsDetalleAccion") and rsDetalleAccion.recordCount GT 0>
						  <tr >
							<td class="#Session.Preferences.Skin#_thcenter" colspan="4"><div align="center"><cf_translate key="ComponentesAnteriores">Componentes Anteriores</cf_translate></div></td>
						  </tr>
						  <tr>
							<td class="tituloListas" colspan="2" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="SalarioTotalAnterior">Salario Total Anterior</cf_translate>: </td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsSumDetalleAccion.TotalAnterior,'none')#</td>
						  </tr>
						  <cfif rsMostrarSalarioNominal.Pvalor eq 1>
								<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
									select 
										Ttipopago,
										case Ttipopago when 0 then '#LB_Semanal#'
										when 1 then '#LB_Bisemanal#'
										when 2 then '#LB_Quincenal#'
										else ''
										end as   descripcion
									from TiposNomina 
									where 
									Ecodigo 	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									and Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAccion.Tcodigoant#">
								</cfquery>	
	
								<cfif rsTiposNomina.Ttipopago neq 3 and rsSumDetalleAccion.recordCount GT 0>
									<cfinvoke component="rh.Componentes.RH_Funciones" 
										method="salarioTipoNomina"
										salario = "#rsSumDetalleAccion.TotalAnterior#"
										tcodigo = "#rsAccion.Tcodigoant#"
										returnvariable="var_salarioTipoNomina">
									  <tr>
										<td class="tituloListas" colspan="2" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="LB_Salario">Salario</cf_translate>&nbsp;#rsTiposNomina.descripcion#:</td>
										<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(var_salarioTipoNomina,',9.00')#</td>
									  </tr>
							  </cfif>
						  </cfif>
						</td>
						  <tr>
							<td class="tituloListas" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Componente">Componente</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Unidad">Unidades</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="MontoBase">Monto Base</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Monto">Monto</cf_translate></td>
						  </tr>
						  <cfloop query="rsDetalleAccion">
							  <cfif Len(Trim(rsDetalleAccion.CIid))>
								<cfset color = ' style="color: ##FF0000;"'>
							  <cfelse>
								<cfset color = ''>
							  </cfif>
							  <tr>
								<td height="25" class="fileLabel"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsDetalleAccion.CSdescripcion#</td>
								<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(rsDetalleAccion.UnidadAnterior,',9.00')#</td>
								<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(rsDetalleAccion.MontoBaseAnterior,',9.00')#</td>
								<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsDetalleAccion.MontoBaseAnterior,'none')#</td>
							  </tr>
						</cfloop>
					  </cfif>
					</table>
				</td>
				
				<td valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
					  <cfif isdefined("rsDetalleAccion") and rsDetalleAccion.recordCount GT 0>
						  <tr>
							<td class="#Session.Preferences.Skin#_thcenter" colspan="4"><div align="center"><cf_translate key="ComponentesActuales">Componentes Actuales</cf_translate></div></td>
						  </tr>
						  <tr>
							<td class="tituloListas" colspan="2" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="SalarioTotal">Salario Total</cf_translate>: </td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsSumDetalleAccion.Total,'none')#</td>
						  </tr>
							<cfif rsMostrarSalarioNominal.Pvalor eq 1>
									<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
										select 
											Ttipopago,
											case Ttipopago when 0 then '#LB_Semanal#'
											when 1 then '#LB_Bisemanal#'
											when 2 then '#LB_Quincenal#'
											else ''
											end as   descripcion
										from TiposNomina 
										where 
										Ecodigo 	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
										and Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAccion.Tcodigo#">
									</cfquery>		
									<cfif rsTiposNomina.Ttipopago neq 3 and rsSumDetalleAccion.recordCount GT 0>
										<cfinvoke component="rh.Componentes.RH_Funciones" 
											method="salarioTipoNomina"
											salario = "#rsSumDetalleAccion.Total#"
											tcodigo = "#rsAccion.Tcodigo#"
											returnvariable="var_salarioTipoNomina">
										  <tr>
											<td class="tituloListas" colspan="2" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="LB_Salario">Salario</cf_translate>&nbsp;#rsTiposNomina.descripcion#:</td>
											<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(var_salarioTipoNomina,',9.00')#</td>
										  </tr>
															  
								  </cfif>
							  </cfif>
						  <tr>
							<td class="tituloListas" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Componente">Componente</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Unidad">Unidades</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="MontoBase">Monto Base</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Monto">Monto</cf_translate></td>
						  </tr>
						  
						  <cfloop query="rsDetalleAccion">
						  <cfif Len(Trim(rsDetalleAccion.CIid))>
							<cfset color = ' style="color: ##FF0000;"'>
						  <cfelse>
							<cfset color = ''>
						  </cfif>
						  <tr>
							<td class="fileLabel" height="25"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsDetalleAccion.CSdescripcion#</td>						
							<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(rsDetalleAccion.DDLunidad,',9.00')#</td>
							<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(rsDetalleAccion.DDLmontobase,',9.00')#</td>
							<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>
								#LSCurrencyFormat(rsDetalleAccion.DDLmontores,'none')#
							</td>
						  </tr>
					  </cfloop>
					  </cfif>
					</table>
				</td>
			  </tr>
			</table>
			</td>
		  </tr>
		  <tr <cfif RHTNoMuestraCS eq 1 >style="display:none"</cfif>>
			<td colspan="4" align="center" style="color: ##FF0000 ">
				<cf_translate  key="MSG_LosComponentesQueAparecenEnColorRojoSePaganEnFormaIncidente">Los componentes que aparecen en color rojo se pagan en forma incidente.</cf_translate>
			</td>
		  </tr>
		  <cfif isdefined("rsConceptosPago") and rsConceptosPago.recordCount GT 0>
			  <tr>
				<td colspan="4">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
				  <tr>
					<td class="#Session.Preferences.Skin#_thcenter" colspan="4"><div align="center"><cf_translate key="ConceptosPago">Conceptos de Pago</cf_translate></div></td>
				  </tr>
				  <tr>
					<td class="tituloListas" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Concepto">Concepto</cf_translate></td>
					<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Importe">Importe</cf_translate></td>
					<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Cantidad">Cantidad</cf_translate></td>
					<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Resultado">Resultado</cf_translate></td>
				  </tr>
				  <cfloop query="rsConceptosPago">
					  <tr>
						<td <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsConceptosPago.Concepto#</td>
						<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsConceptosPago.Importe, 'none')#</td>
						<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsConceptosPago.Cantidad, 'none')#</td>
						<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsConceptosPago.Resultado, 'none')#</td>
					  </tr>
				  </cfloop>
				</table>
				</td>
			  </tr>
		  </cfif>
	
		  <cfif isdefined('url.imprimir')>
			   <cfquery name="rsFirmas" datasource="#Session.DSN#">
					select 
					RHFid,
					RHTid,
					RHFtipo,
					RHFautorizador,
					DEid,
					CFid
					from RHFirmasAccion
					where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHTid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					order by  RHFOrden
				</cfquery>	
				<cfif rsFirmas.recordCount GT 0>
					<tr> 
						<td colspan="4" align="center">
							<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
								<tr>
									<td  colspan="2" align="center">&nbsp;</td>		
								</tr>
								<tr>
									<td  colspan="2" align="center">&nbsp;</td>		
								</tr>
								<cfset Firma = "">
								<cfset contadorFirmas = 0>
								<cfloop query="rsFirmas">
									<cfswitch expression="#rsFirmas.RHFtipo#">
										<cfcase value="1">
											<cfif isdefined("rsFirmas.RHFautorizador") and len(trim(rsFirmas.RHFautorizador))>
												<cfset Firma = rsFirmas.RHFautorizador>	
											<cfelse>
												<cfset Firma = "">
											</cfif>	
										</cfcase>
										<cfcase value="2">
											<cfquery name="rsEmpleado" datasource="#Session.DSN#">
												select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
												from DatosEmpleado
												where DEid =  #rsFirmas.DEid#
											</cfquery>
											<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
												<cfset Firma = rsEmpleado.empleado>	
											<cfelse>
												<cfset Firma = "">
											</cfif>	
										</cfcase>
										<cfcase value="3">
											<cfquery name="rsEmpleado" datasource="#Session.DSN#">
												select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
												from DatosEmpleado
												where DEid =  #rsAccion.DEid#
											</cfquery>
											<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
												<cfset Firma = rsEmpleado.empleado>	
											<cfelse>
												<cfset Firma = "">
											</cfif>	
										</cfcase>
										<cfcase value="4">																					
											<cfquery name="rsEmpleado" datasource="#Session.DSN#">
												select 1 
												from LineaTiempo a, 
													 RHPlazas b, 
													 CFuncional c
												where a.DEid =  #rsAccion.DEid#
												and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.DLfvigencia#"> between LTdesde and LThasta
												and a.RHPid=b.RHPid
												and b.CFid=c.CFid
												and b.RHPid=c.RHPid
											</cfquery>
											
											<cfinvoke component="rh.Componentes.RH_Funciones" 
											method="DeterminaJefe"
											deid = "#rsAccion.DEid#"
											fecha = "#rsAccion.DLfvigencia#"
											returnvariable="ResponsableCF">										
											<cfif ResponsableCF.Jefe EQ rsAccion.DEid>
													<cfquery name="Jefedeljefe" datasource="#Session.DSN#">
														select CFidresp 
														from LineaTiempo a, 
															 RHPlazas b, 
															 CFuncional c
														where a.DEid =  #rsAccion.DEid#
														and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.DLfvigencia#"> between LTdesde and LThasta
														and a.RHPid=b.RHPid
														and b.CFid=c.CFid
													</cfquery>	
													<cfinvoke component="rh.Componentes.RH_Funciones" 
													method="DeterminaDEidResponsableCF"
													cfid = "#Jefedeljefe.CFidresp#"
													fecha = "#rsAccion.DLfvigencia#"
													returnvariable="ResponsableCF">	
											<cfelse>
													<cfinvoke component="rh.Componentes.RH_Funciones" 
													method="DeterminaDEidResponsableCF"
													cfid = "#rsAccion.CFid#"
													fecha = "#rsAccion.DLfvigencia#"
													returnvariable="ResponsableCF">												
											</cfif>												
											
											<cfquery name="rsEmpleado" datasource="#Session.DSN#">
												select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
												from DatosEmpleado
												where DEid =  #ResponsableCF#
											</cfquery>
											<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
												<cfset Firma = rsEmpleado.empleado>	
											<cfelse>
												<cfset Firma = "">
											</cfif>	
										</cfcase>
										<cfcase value="5">
											<cfinvoke component="rh.Componentes.RH_Funciones" 
											method="DeterminaDEidResponsableCF"
											cfid = "#rsFirmas.CFid#"
											fecha = "#rsAccion.DLfvigencia#"
											returnvariable="ResponsableCF">
											<cfquery name="rsEmpleado" datasource="#Session.DSN#">
												select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
												from DatosEmpleado
												where DEid =  #ResponsableCF#
											</cfquery>
											<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
												<cfset Firma = rsEmpleado.empleado>	
											<cfelse>
												<cfset Firma = "">
											</cfif>										
										</cfcase>
									</cfswitch>
									<cfif rsFirmas.recordCount eq 1>
										<cfif isdefined("Firma") and len(trim(Firma))>
											<tr>
												<td  width="35%" align="center">&nbsp;</td>
												<td  width="30%" align="center">
													<hr/>
												</td>
												<td width="35%" align="center">&nbsp;</td>
											</tr>
											
											<tr>
												<td  colspan="3" align="center">
													#Firma#
												</td>
											</tr>
										</cfif>
									<cfelse>
										<cfif isdefined("Firma") and len(trim(Firma))>
											<cfset contadorFirmas = contadorFirmas + 1>
											<cfif contadorFirmas mod 2 eq 1>
												<tr>
													<td width="50%" align="center">
														<table width="100%" border="0" cellspacing="0" cellpadding="2">
															<tr>
																<td  width="25%" align="center">&nbsp;</td>
																<td  width="50%" align="center"><hr/></td>
																<td  width="25%" align="center">&nbsp;</td>
															</tr>
															<tr>
																<td  colspan="3" align="center">
																	#Firma#
																</td>
															</tr>																
														</table>
													</td>
											<cfelse>
													<td width="50%" align="center">
														<table width="100%" border="0" cellspacing="0" cellpadding="2">
															<tr>
																<td  width="25%" align="center">&nbsp;</td>
																<td  width="50%" align="center"><hr/></td>

																<td  width="25%" align="center">&nbsp;</td>
															</tr>
															<tr>
																<td  colspan="3" align="center">
																	#Firma#
																</td>
															</tr>																
														</table>
													</td>														
												</tr>
												<tr>
													<td  colspan="2" align="center">&nbsp;</td>		
												</tr>
											</cfif>
										</cfif>
									</cfif>
							</cfloop>
						</table>
					</td>
				</tr>
			</cfif> 
		</cfif>
</cfoutput>
</cfif>

<!---SOLO TEXTO--->

<cfif form.formato EQ 'txt'>
<cfset Hilera = ''>

<cfinvoke  Key="LB_AccionesdePersonal" Default="Acciones de Personal" returnvariable="LB_AccionesdePersonal" component="sif.Componentes.Translate" method="Translate"/>											
<cfinvoke  Key="LB_ConsecutivoAccion" Default="Consecutivo Acción" returnvariable="LB_ConsecutivoAccion" component="sif.Componentes.Translate" method="Translate"/>											

<cfinvoke  Key="LB_NombreCompleto" Default="Nombre Completo" returnvariable="LB_NombreCompleto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Identificacion" Default="Identificación" returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke  Key="LB_Tipodeaccion" 	Default="Tipo de Acción" returnvariable="LB_Tipodeaccion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_FechaAplicacion" Default="Fecha Aplicación" returnvariable="LB_FechaAplicacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_FechaVigencia" 	Default="Fecha Vigencia" returnvariable="LB_FechaVigencia" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_FechaVencimiento"Default="Fecha Vencimiento" returnvariable="LB_FechaVencimiento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Obsevaciones" 	Default="Observaciones" returnvariable="LB_Obsevaciones" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke  Key="LB_SituacionAnterior" 	Default="Situación Anterior" returnvariable="LB_SituacionAnterior" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_SituacionActual" 	Default="Situación Actual" returnvariable="LB_SituacionActual" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke  Key="LB_Plaza" 		Default="Plaza" 		returnvariable="LB_Plaza" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Oficina" 	Default="Oficina" 		returnvariable="LB_Oficina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Departamento"Default="Departamento" 	returnvariable="LB_Departamento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_PuestoRH" 	Default="Puesto RH" 	returnvariable="LB_PuestoRH" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke  Key="LB_Jornada" 			Default="Jornada" 				returnvariable="LB_Jornada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_PorcentajePlaza" 	Default="Porcentaje Plaza" 	returnvariable="LB_PorcentajePlaza" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_PorcentajeSalFijo" 	Default="Porcentaje Salario Fijo" returnvariable="LB_PorcentajeSalFijo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_TipoNomina" 			Default="Tipo Nomina" 			returnvariable="LB_TipoNomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_RegVacaciones" 		Default="Regimen de Vacaciones" returnvariable="LB_RegVacaciones" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke  Key="LB_ComponentesAnteriores" 		Default="Componentes Anteriores" returnvariable="LB_ComponentesAnteriores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_ComponentesActuales" 		Default="Componentes Actuales" returnvariable="LB_ComponentesActuales" component="sif.Componentes.Translate" method="Translate"/>


<cfinvoke  Key="LB_SalarioTotalAnterior"Default="Salario Total Anterior" returnvariable="LB_SalarioTotalAnterior" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_SalarioTotalActual" 	Default="Salario Total Actual" returnvariable="LB_SalarioTotalActual" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Salario" 			Default="Salario" 		returnvariable="LB_Salario" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke  Key="LB_Componente"	Default="Componentes" 	returnvariable="LB_Componente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Unidades" 	Default="Unidades" 		returnvariable="LB_Unidades" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_MontoBase" 	Default="Monto Base"	returnvariable="LB_MontoBase" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Monto" 		Default="Monto" 		returnvariable="LB_Monto" component="sif.Componentes.Translate" method="Translate"/>


<cfinvoke  Key="LB_ComponentesDePago" 	Default="Componentes de Pago" 	returnvariable="LB_ComponentesDePago" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke  Key="LB_Concepto" 	Default="Concepto" 	returnvariable="LB_Concepto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Importe" 	Default="Importe" 	returnvariable="LB_Importe" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Cantidad" 	Default="Cantidad" 	returnvariable="LB_Cantidad" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Resultado" 	Default="Resultado"	returnvariable="LB_Resultado" component="sif.Componentes.Translate" method="Translate"/>

	
<cfoutput query="rsAccion">
	
	<!--- Conceptos de Pago --->
	<cfquery name="rsConceptosPago" datasource="#Session.DSN#">
		select {fn concat({fn concat(rtrim(b.CIcodigo) , ' - ' )},  b.CIdescripcion )}  as Concepto, 
			a.DDCimporte as Importe, 
			a.DDCcant as Cantidad, 
			a.DDCres as Resultado
		from DDConceptosEmpleado a
		
			inner join CIncidentes b
			on a.CIid = b.CIid
			
			where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DLlinea#">
	</cfquery>
	
	<cfquery name="rsDetalleAccion" datasource="#Session.DSN#">
		select a.CSid,
			b.CScodigo, 
			a.DDLtabla, 
			b.CSdescripcion,
			a.DDLunidad, 
			a.DDLmontobase, 
			a.DDLmontores,
			coalesce(a.DDLunidadant,0.00) as UnidadAnterior, 
			coalesce(a.DDLmontobaseant,0.00) as MontoBaseAnterior, 
			coalesce(a.DDLmontoresant,0.00) as MontoResultadoAnterior,
			a.CIid
		
		from DDLaboralesEmpleado a
		
			inner join ComponentesSalariales b
			on a.CSid = b.CSid
			
			where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DLlinea#">
			
			order by b.CScodigo, b.CSdescripcion
	</cfquery>
	
	<cfif rsDetalleAccion.recordCount GT 0>
		<cfquery name="rsSumDetalleAccion" dbtype="query">
			select sum(DDLmontores) as Total, 
			sum(MontoResultadoAnterior) as TotalAnterior 
			from rsDetalleAccion
			where CIid is null
		</cfquery>
	</cfif>
			
	<cfquery name="rsMostrarSalarioNominal" datasource="#session.DSN#">
		select coalesce(Pvalor,'0') as  Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = 1040
	</cfquery>
	
	
	<!---Encabezado---->
	<cfif rsAccion.CurrentRow EQ 1>
		<cfset hilera = hilera & '#chr(27)##chr(67)##chr(33)#'>
	</cfif>
	<cfset hilera = hilera & '#trim(session.Enombre)#'& IIf(len(trim(session.Enombre)) LT 93, DE(RepeatString(' ', 93-(len(trim(session.Enombre))))), DE(''))>		
	<cfset hilera = hilera & '#LSDateFormat(now(),'dd-mm-yyyy')# #LSTimeFormat(Now(),'hh:mm:ss')#'>		
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	<cfset hilera = hilera & '#trim(LB_AccionesdePersonal)#'& IIf(len(trim(LB_AccionesdePersonal)) LT 84, DE(RepeatString(' ', 84-(len(trim(LB_AccionesdePersonal))))), DE(''))>

	<cfset hilera = hilera & '#trim(LB_ConsecutivoAccion)#'& IIf(len(trim(LB_ConsecutivoAccion)) LT 20, DE(RepeatString(' ', 20-(len(trim(LB_ConsecutivoAccion))))), DE(''))&': '>
	<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(rsAccion.DLlinea,'999999999'))) LT 9, DE(RepeatString(' ', 9-(len(trim(LSNumberFormat(rsAccion.DLlinea,'999999999')))))), DE('')) & '#trim(LSNumberFormat(rsAccion.DLlinea,'999999999'))# '>
	
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	
	<!---Nombre Empleado---->
	<cfif len(trim(LB_NombreCompleto)) GTE 16>
		<cfset hilera = hilera & '#trim(Mid(LB_NombreCompleto,1,16))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_NombreCompleto)#' & IIf(len(trim(LB_NombreCompleto)) LT 16, DE(RepeatString(' ', 16-(len(trim(LB_NombreCompleto))))), DE('')) & ': '>
	</cfif>
	
	<cfif len(trim(rsAccion.NombreCompleto)) GTE 42>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.NombreCompleto,1,42))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.NombreCompleto)#' & IIf(len(trim(rsAccion.NombreCompleto)) LT 42, DE(RepeatString(' ', 42-(len(trim(rsAccion.NombreCompleto))))), DE(''))>
	</cfif>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	
	<cfif len(trim(LB_Identificacion)) GTE 16>
		<cfset hilera = hilera & '#trim(Mid(LB_Identificacion,1,16))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Identificacion)#' & IIf(len(trim(LB_Identificacion)) LT 16, DE(RepeatString(' ', 16-(len(trim(LB_Identificacion))))), DE('')) & ': '>
	</cfif>
	
	<cfif len(trim(rsAccion.DEidentificacion)) GTE 42>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DEidentificacion,1,42))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DEidentificacion)#' & IIf(len(trim(rsAccion.DEidentificacion)) LT 42, DE(RepeatString(' ', 42-(len(trim(rsAccion.DEidentificacion))))), DE(''))>
	</cfif>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	<!---Accion Encabezado---->
	<!---Tipo de Accion--->
	<cfif len(trim(LB_Tipodeaccion)) GTE 16>
		<cfset hilera = hilera & '#trim(Mid(LB_Tipodeaccion,1,16))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Tipodeaccion)#' & IIf(len(trim(LB_Tipodeaccion)) LT 16, DE(RepeatString(' ', 16-(len(trim(LB_Tipodeaccion))))), DE('')) & ': '>
	</cfif>

	<cfif len(trim(rsAccion.RHTid & ' - '& rsAccion.DesTipoAccion)) GTE 68>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.RHTid & ' - '& rsAccion.DesTipoAccion,1,53))# '>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.RHTid & ' - '& rsAccion.DesTipoAccion)#' & IIf(len(trim(rsAccion.RHTid & ' - '& rsAccion.DesTipoAccion)) LT 68, DE(RepeatString(' ', 68-(len(trim(rsAccion.RHTid & ' - '& rsAccion.DesTipoAccion))))), DE(''))>
	</cfif>
	<!---Fecha de Aplcacion--->
	<cfif len(trim(LB_FechaAplicacion)) GTE 17>
		<cfset hilera = hilera & '#trim(Mid(LB_FechaAplicacion,1,17))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_FechaAplicacion)#' & IIf(len(trim(LB_FechaAplicacion)) LT 17, DE(RepeatString(' ', 17-(len(trim(LB_FechaAplicacion))))), DE('')) & ': '>
	</cfif>
	<cfset hilera = hilera & '#LSDateFormat(rsAccion.DLfechaaplic,'dd/mm/yyyy')#'>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	<!---Fecha de Vigencia--->
	<cfif len(trim(LB_FechaVigencia)) GTE 16>
		<cfset hilera = hilera & '#trim(Mid(LB_FechaVigencia,1,16))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_FechaVigencia)#' & IIf(len(trim(LB_FechaVigencia)) LT 16, DE(RepeatString(' ', 16-(len(trim(LB_FechaVigencia))))), DE('')) & ': '>
	</cfif>
	<cfif len(trim(#LSDateFormat(rsAccion.DLfechaaplic,'dd/mm/yyyy')#)) GTE 68>
		<cfset hilera = hilera & '#LSDateFormat(rsAccion.DLfvigencia,'dd/mm/yyyy')#'>
	<cfelse>
		<cfset hilera = hilera & '#LSDateFormat(rsAccion.DLfvigencia,'dd/mm/yyyy')#' & IIf(len(trim(#LSDateFormat(rsAccion.DLfvigencia,'dd/mm/yyyy')#)) LT 68, DE(RepeatString(' ', 68-(len(trim(#LSDateFormat(rsAccion.DLfvigencia,'dd/mm/yyyy')#))))), DE(''))>
	</cfif>
	<!---Fecha de Vencimiento--->
	<cfif len(trim(LB_FechaVencimiento)) GTE 17>
		<cfset hilera = hilera & '#trim(Mid(LB_FechaVencimiento,1,17))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_FechaVencimiento)#' & IIf(len(trim(LB_FechaVencimiento)) LT 17, DE(RepeatString(' ', 17-(len(trim(LB_FechaVencimiento))))), DE('')) & ': '>
	</cfif>
	
	<cfif len(trim(#LSDateFormat(rsAccion.DLfechaaplic,'dd/mm/yyyy')#)) GTE 58>
		<cfset hilera = hilera & '#LSDateFormat(rsAccion.DLfvigencia,'dd/mm/yyyy')#'>
	<cfelse>
		<cfif len(trim(rsAccion.DLffin)) >
			<cfset fechafin = '#LSDateFormat(rsAccion.DLffin,'dd/mm/yyyy')#'>
		<cfelse>
			<cfset fechafin = 'INDEFINIDO'>
		</cfif>
		<cfset hilera = hilera & '#fechafin#' & IIf(len(trim(fechafin)) LT 58, DE(RepeatString(' ', 58-(len(trim(fechafin & ' - '& fechafin))))), DE(''))>
	</cfif>
	
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	<!---Observacion--->
	<cfif len(trim(LB_Obsevaciones)) GTE 16>
		<cfset hilera = hilera & '#trim(Mid(LB_Obsevaciones,1,16))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Obsevaciones)#' & IIf(len(trim(LB_Obsevaciones)) LT 16, DE(RepeatString(' ', 16-(len(trim(LB_Obsevaciones))))), DE('')) & ': '>
	</cfif>
	
	<cfif len(trim(rsAccion.DLobs)) GTE 80>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DLobs,1,80))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DLobs)#' & IIf(len(trim(rsAccion.DLobs)) LT 80, DE(RepeatString(' ', 80-(len(trim(rsAccion.DLobs))))), DE(''))>
	</cfif>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	<cfset hilera = hilera & RepeatString('-', 115)>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	
	<!---Situacion Anterior y Situacion Actual--->
	<cfset hilera = hilera & '           '>
	<cfset hilera = hilera & '#trim(LB_SituacionAnterior)#'>
	<cfset hilera = hilera & RepeatString(' ', 39)>
	<cfset hilera = hilera & '#trim(LB_SituacionActual)#'>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	<cfset hilera = hilera & RepeatString('-', 115)>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	
	<!---Plaza--->
	<cfif len(trim(LB_Plaza)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_Plaza,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Plaza)#' & IIf(len(trim(LB_Plaza)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_Plaza))))), DE('')) & ': '>
	</cfif>

	<cfif len(trim(rsAccion.DesPlazaAnt)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DesPlazaAnt,1,35))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DesPlazaAnt)#' & IIf(len(trim(rsAccion.DesPlazaAnt)) LT 37, DE(RepeatString(' ', 37-(len(trim(rsAccion.DesPlazaAnt))))), DE(''))>
	</cfif>
	
	<cfif len(trim(LB_Plaza)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_Plaza,1,16))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Plaza)#' & IIf(len(trim(LB_Plaza)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_Plaza))))), DE('')) & ': '>
	</cfif>

	<cfif len(trim(rsAccion.DesPlazaAnt)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DesPlaza,1,30))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DesPlaza)#' & IIf(len(trim(rsAccion.DesPlaza)) LT 35, DE(RepeatString(' ', 35-(len(trim(rsAccion.DesPlaza))))), DE(''))>
	</cfif>

	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	

	<!---Oficina--->
	<cfif len(trim(LB_Oficina)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_Oficina,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Oficina)#' & IIf(len(trim(LB_Plaza)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_Oficina))))), DE('')) & ': '>
	</cfif>

	<cfif len(trim(rsAccion.DesOficinaAnt)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DesOficinaAnt,1,30))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DesOficinaAnt)#' & IIf(len(trim(rsAccion.DesOficinaAnt)) LT 37, DE(RepeatString(' ', 37-(len(trim(rsAccion.DesOficinaAnt))))), DE(''))>
	</cfif>
	
	
	<cfif len(trim(LB_Oficina)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_Oficina,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Oficina)#' & IIf(len(trim(LB_Plaza)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_Oficina))))), DE('')) & ': '>
	</cfif>

	<cfif len(trim(rsAccion.DesOficinaAnt)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DesOficina,1,30))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DesOficina)#' & IIf(len(trim(rsAccion.DesOficina)) LT 35, DE(RepeatString(' ', 35-(len(trim(rsAccion.DesOficina))))), DE(''))>
	</cfif>

	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	<!---Departamento--->
	<cfif len(trim(LB_Departamento)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_Departamento,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Departamento)#' & IIf(len(trim(LB_Plaza)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_Departamento))))), DE('')) & ': '>
	</cfif>

	<cfif len(trim(rsAccion.DesOficinaAnt)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DesDeparAnt,1,30))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DesDeparAnt)#' & IIf(len(trim(rsAccion.DesDeparAnt)) LT 37, DE(RepeatString(' ', 37-(len(trim(rsAccion.DesDeparAnt))))), DE(''))>
	</cfif>
	
	
	<cfif len(trim(LB_Departamento)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_Departamento,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Departamento)#' & IIf(len(trim(LB_Plaza)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_Departamento))))), DE('')) & ': '>
	</cfif>

	<cfif len(trim(rsAccion.DesOficina)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DesDepar,1,30))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DesDepar)#' & IIf(len(trim(rsAccion.DesDepar)) LT 35, DE(RepeatString(' ', 35-(len(trim(rsAccion.DesDepar))))), DE(''))>
	</cfif>

	<!---usaEstructuraSalarial
	
	ljimenez pendiente de revizar la parte de estructura salarial....
	
	--->
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	<!---Puesto RH--->
	<cfif len(trim(LB_PuestoRH)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_PuestoRH,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_PuestoRH)#' & IIf(len(trim(LB_PuestoRH)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_PuestoRH))))), DE('')) & ': '>
	</cfif>

	<cfif len(trim(rsAccion.DesPuestoAnt)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DesPuestoAnt,1,30))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DesPuestoAnt)#' & IIf(len(trim(rsAccion.DesPuestoAnt)) LT 37, DE(RepeatString(' ', 37-(len(trim(rsAccion.DesPuestoAnt))))), DE(''))>
	</cfif>
	
	
	<cfif len(trim(LB_PuestoRH)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_PuestoRH,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_PuestoRH)#' & IIf(len(trim(LB_PuestoRH)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_PuestoRH))))), DE('')) & ': '>
	</cfif>

	<cfif len(trim(rsAccion.DesPuesto)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DesPuesto,1,30))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DesPuesto)#' & IIf(len(trim(rsAccion.DesPuesto)) LT 35, DE(RepeatString(' ', 35-(len(trim(rsAccion.DesPuesto))))), DE(''))>
	</cfif>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	

	<!---Jornada--->

	<cfif len(trim(LB_Jornada)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_Jornada,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Jornada)#' & IIf(len(trim(LB_Jornada)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_Jornada))))), DE('')) & ': '>
	</cfif>

	<cfif len(trim(rsAccion.DesJornadaAnt)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DesJornadaAnt,1,30))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DesJornadaAnt)#' & IIf(len(trim(rsAccion.DesJornadaAnt)) LT 37, DE(RepeatString(' ', 37-(len(trim(rsAccion.DesJornadaAnt))))), DE(''))>
	</cfif>
	
	<cfif len(trim(LB_Jornada)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_Jornada,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Jornada)#' & IIf(len(trim(LB_Jornada)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_Jornada))))), DE('')) & ': '>
	</cfif>

	<cfif len(trim(rsAccion.DesJornada)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DesJornada,1,30))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DesJornada)#' & IIf(len(trim(rsAccion.DesJornada)) LT 35, DE(RepeatString(' ', 35-(len(trim(rsAccion.DesJornada))))), DE(''))>
	</cfif>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	
	<!---Porcentaje de Plaza--->

	<cfif len(trim(LB_PorcentajePlaza)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_PorcentajePlaza,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_PorcentajePlaza)#' & IIf(len(trim(LB_PorcentajePlaza)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_PorcentajePlaza))))), DE('')) & ': '>
	</cfif>

	<cfif rsAccion.DLporcplazaant NEQ "">
		<cfset PorPlazaant = '#LSCurrencyFormat(rsAccion.DLporcplazaant,'none')# %'>
	<cfelse>
		<cfset PorPlazaant = '0.00 %'>
	</cfif>

	<cfif len(trim(PorPlazaant)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.PorPlazaant,1,30))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(PorPlazaant)#' & IIf(len(trim(PorPlazaant)) LT 37, DE(RepeatString(' ', 37-(len(trim(PorPlazaant))))), DE(''))>
	</cfif>
	
	
	<cfif len(trim(LB_PorcentajePlaza)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_PorcentajePlaza,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_PorcentajePlaza)#' & IIf(len(trim(LB_PorcentajePlaza)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_PorcentajePlaza))))), DE('')) & ': '>
	</cfif>
	
	<cfif rsAccion.DLporcplaza NEQ "">
		<cfset PorPlaza = '#LSCurrencyFormat(rsAccion.DLporcplaza,'none')# %'>
	<cfelse>
		<cfset PorPlaza = '0.00 %'>
	</cfif>
	
	<cfif len(trim(PorPlaza)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(PorPlaza,1,30))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(PorPlaza)#' & IIf(len(trim(PorPlaza)) LT 30, DE(RepeatString(' ', 30-(len(trim(PorPlaza))))), DE(''))>
	</cfif>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	

	<!---Porcentaje de Salario Fijo--->

	<cfif len(trim(LB_PorcentajeSalFijo)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_PorcentajeSalFijo,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_PorcentajeSalFijo)#' & IIf(len(trim(LB_PorcentajeSalFijo)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_PorcentajeSalFijo))))), DE('')) & ': '>
	</cfif>

	<cfif rsAccion.DLporcsalant NEQ "">
		<cfset PorSalant = '#LSCurrencyFormat(rsAccion.DLporcsalant,'none')# %'>
	<cfelse>
		<cfset PorSalant = '0.00 %'>
	</cfif>

	<cfif len(trim(PorSalant)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(PorSalant,1,30))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(PorSalant)#' & IIf(len(trim(PorSalant)) LT 37, DE(RepeatString(' ', 37-(len(trim(PorSalant))))), DE(''))>
	</cfif>
	
	<cfif len(trim(LB_PorcentajeSalFijo)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_PorcentajeSalFijo,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_PorcentajeSalFijo)#' & IIf(len(trim(LB_PorcentajeSalFijo)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_PorcentajeSalFijo))))), DE('')) & ': '>
	</cfif>
	
	<cfif rsAccion.DLporcsal NEQ "">
		<cfset PorSal = '#LSCurrencyFormat(rsAccion.DLporcsal,'none')# %'>
	<cfelse>
		<cfset PorSal = '0.00 %'>
	</cfif>
	
	<cfif len(trim(PorSal)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(PorSal,1,30))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(PorSal)#' & IIf(len(trim(PorSal)) LT 30, DE(RepeatString(' ', 30-(len(trim(PorSal))))), DE(''))>
	</cfif>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	<!---Tipo de Nomina--->

	<cfif len(trim(LB_TipoNomina)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_TipoNomina,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_TipoNomina)#' & IIf(len(trim(LB_TipoNomina)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_TipoNomina))))), DE('')) & ': '>
	</cfif>

	<cfif len(trim(rsAccion.DesTNominaAnt)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DesTNominaAnt,1,35))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DesTNominaAnt)#' & IIf(len(trim(rsAccion.DesTNominaAnt)) LT 37, DE(RepeatString(' ', 37-(len(trim(rsAccion.DesTNominaAnt))))), DE(''))>
	</cfif>
	
	<cfif len(trim(LB_TipoNomina)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_TipoNomina,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_TipoNomina)#' & IIf(len(trim(LB_TipoNomina)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_TipoNomina))))), DE('')) & ': '>
	</cfif>
	
	<cfif len(trim(rsAccion.DesTNomina)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DesTNomina,1,35))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DesTNomina)#' & IIf(len(trim(rsAccion.DesTNomina)) LT 35, DE(RepeatString(' ', 35-(len(trim(rsAccion.DesTNomina))))), DE(''))>
	</cfif>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	<!---Regimen de Vacaciones--->
	<cfif len(trim(LB_RegVacaciones)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_RegVacaciones,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_RegVacaciones)#' & IIf(len(trim(LB_RegVacaciones)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_RegVacaciones))))), DE('')) & ': '>
	</cfif>

	<cfif len(trim(rsAccion.DesRegVacAnt)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DesRegVacAnt,1,35))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DesRegVacAnt)#' & IIf(len(trim(rsAccion.DesRegVacAnt)) LT 37, DE(RepeatString(' ', 37-(len(trim(rsAccion.DesRegVacAnt))))), DE(''))>
	</cfif>
	
	<cfif len(trim(LB_RegVacaciones)) GTE 18>
		<cfset hilera = hilera & '#trim(Mid(LB_RegVacaciones,1,18))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_RegVacaciones)#' & IIf(len(trim(LB_RegVacaciones)) LT 18, DE(RepeatString(' ', 18-(len(trim(LB_RegVacaciones))))), DE('')) & ': '>
	</cfif>
	
	<cfif len(trim(rsAccion.DesRegVac)) GTE 35>
		<cfset hilera = hilera & '#trim(Mid(rsAccion.DesRegVac,1,35))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsAccion.DesRegVac)#' & IIf(len(trim(rsAccion.DesRegVac)) LT 35, DE(RepeatString(' ', 35-(len(trim(rsAccion.DesRegVac))))), DE(''))>
	</cfif>

	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	<cfset hilera = hilera & RepeatString('-', 115)>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	
		
	<!---Situacion Anterior y Situacion Actual--->
	<cfset hilera = hilera & RepeatString(' ',15)>
	<cfset hilera = hilera & '#trim(LB_ComponentesAnteriores)#'>
	<cfset hilera = hilera & RepeatString(' ',32)>
	<cfset hilera = hilera & '#trim(LB_ComponentesActuales)#'>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	<cfset hilera = hilera & RepeatString('-', 115)>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	
	<cfif isdefined("rsDetalleAccion") and rsDetalleAccion.recordCount GT 0>
		<!---Salario Total--->
		<cfif len(trim(LB_SalarioTotalAnterior)) GTE 25>
			<cfset hilera = hilera & '#trim(Mid(LB_SalarioTotalAnterior,1,25))#: '>
		<cfelse>
			<cfset hilera = hilera & '#trim(LB_SalarioTotalAnterior)#' & IIf(len(trim(LB_SalarioTotalAnterior)) LT 25, DE(RepeatString(' ', 25-(len(trim(LB_SalarioTotalAnterior))))), DE('')) & ': '>
		</cfif>
		<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(rsSumDetalleAccion.TotalAnterior,'999,999,999.99'))) LT 14, DE(RepeatString(' ', 14-(len(trim(LSNumberFormat(rsSumDetalleAccion.TotalAnterior,'999,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(rsSumDetalleAccion.TotalAnterior,'999,999,999.99'))# '>
		<cfif len(trim(LB_SalarioTotalActual)) GTE 18>
			<cfset hilera = hilera & RepeatString(' ',26) &'#trim(Mid(LB_SalarioTotalActual,1,25))#: '>
		<cfelse>
			<cfset hilera = hilera & RepeatString(' ',26) &'#trim(LB_SalarioTotalActual)#' & IIf(len(trim(LB_SalarioTotalActual)) LT 25, DE(RepeatString(' ', 25-(len(trim(LB_SalarioTotalActual))))), DE('')) & ': '>
		</cfif>

		<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(rsSumDetalleAccion.Total,'999,999,999,999,999.99'))) LT 14, DE(RepeatString(' ', 14-(len(trim(LSNumberFormat(rsSumDetalleAccion.Total,'999,999,999,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(rsSumDetalleAccion.Total,'999,999,999,999,999.99'))# '>
		
		<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
		
		<cfif rsMostrarSalarioNominal.Pvalor eq 1>
			<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
				select 
					Ttipopago,
					case Ttipopago when 0 then '#LB_Semanal#'
					when 1 then '#LB_Bisemanal#'
					when 2 then '#LB_Quincenal#'
					else ''
					end as   descripcion
				from TiposNomina 
				where 
					Ecodigo 	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAccion.Tcodigoant#">
			</cfquery>	
	
			<cfif rsTiposNomina.Ttipopago neq 3 and rsSumDetalleAccion.recordCount GT 0>
				<cfinvoke component="rh.Componentes.RH_Funciones" 
					method="salarioTipoNomina"
					salario = "#rsSumDetalleAccion.TotalAnterior#"
					tcodigo = "#rsAccion.Tcodigoant#"
					returnvariable="var_salarioTipoNomina">
					
					<cfif len(trim(LB_Salario & ' ' & rsTiposNomina.descripcion)) GTE 24>
						<cfset hilera = hilera & '#trim(Mid(LB_Salario & ' ' & rsTiposNomina.descripcion,1,24))#:'>
					<cfelse>
						<cfset hilera = hilera & '#trim(LB_Salario & ' ' &  rsTiposNomina.descripcion)#' & IIf(len(trim(LB_Salario & ' ' &  rsTiposNomina.descripcion)) LT 25, DE(RepeatString(' ', 25-(len(trim(LB_Salario & ' ' &  rsTiposNomina.descripcion))))), DE('')) & ': '>
					</cfif>
					<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(var_salarioTipoNomina,'999,999,999,999,999.99'))) LT 14, DE(RepeatString(' ', 14-(len(trim(LSNumberFormat(var_salarioTipoNomina,'999,999,999,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(var_salarioTipoNomina,'999,999,999,999,999.99'))# '>
			</cfif>
		</cfif>
		
		<cfif rsMostrarSalarioNominal.Pvalor eq 1>
			<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
				select 
					Ttipopago,
					case Ttipopago when 0 then '#LB_Semanal#'
					when 1 then '#LB_Bisemanal#'
					when 2 then '#LB_Quincenal#'
					else ''
					end as   descripcion
				from TiposNomina 
				where 
				Ecodigo 	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAccion.Tcodigo#">
			</cfquery>		
			<cfif rsTiposNomina.Ttipopago neq 3 and rsSumDetalleAccion.recordCount GT 0>
				<cfinvoke component="rh.Componentes.RH_Funciones" 
					method="salarioTipoNomina"
					salario = "#rsSumDetalleAccion.Total#"
					tcodigo = "#rsAccion.Tcodigo#"
					returnvariable="var_salarioTipoNomina">
					
					<cfif len(trim(LB_Salario & ' ' & rsTiposNomina.descripcion)) GTE 20>
						<cfset hilera = hilera & RepeatString(' ',26) &'#trim(Mid(LB_Salario & ' ' & rsTiposNomina.descripcion,1,20))#:'>
					<cfelse>
						<cfset hilera = hilera & RepeatString(' ',26) &'#trim(LB_Salario & ' ' &  rsTiposNomina.descripcion)#' & IIf(len(trim(LB_Salario & ' ' &  rsTiposNomina.descripcion)) LT 20, DE(RepeatString(' ', 20-(len(trim(LB_Salario & ' ' &  rsTiposNomina.descripcion))))), DE('')) & ': '>
					</cfif>
				<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(var_salarioTipoNomina,'999,999,999,999,999.99'))) LT 14, DE(RepeatString(' ', 14-(len(trim(LSNumberFormat(var_salarioTipoNomina,'999,999,999,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(var_salarioTipoNomina,'999,999,999,999,999.99'))# '>
		  </cfif>
	  </cfif>
		
		<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
		<cfset hilera = hilera & '#trim(LB_Componente)#'&'          '&'#trim(LB_Unidades)#' & '   '& '#trim(LB_MontoBase)#' & '        '& '#trim(LB_Monto)#'>
		<cfset hilera = hilera & '   '>
		<cfset hilera = hilera & '#trim(LB_Componente)#'&'          '&'#trim(LB_Unidades)#' & '   '& '#trim(LB_MontoBase)#' & '        '& '#trim(LB_Monto)#'>
		<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
		
		<cfloop query="rsDetalleAccion">
<!---		LB_Salario--->
			<cfif len(trim(rsDetalleAccion.CSdescripcion)) GTE 18>
				<cfset hilera = hilera & '#trim(Mid(rsDetalleAccion.CSdescripcion,1,18))#: '>
			<cfelse>
				<cfset hilera = hilera & '#trim(rsDetalleAccion.CSdescripcion)#' & IIf(len(trim(rsDetalleAccion.CSdescripcion)) LT 18, DE(RepeatString(' ', 18-(len(trim(rsDetalleAccion.CSdescripcion))))), DE('')) & ': '>
			</cfif>
			
			<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(rsDetalleAccion.UnidadAnterior,'99,999.99')))    LT 9, DE(RepeatString(' ', 9-(len(trim(LSNumberFormat(rsDetalleAccion.UnidadAnterior,'99,999.99')))))),    DE('')) & '#trim(LSNumberFormat(rsDetalleAccion.UnidadAnterior,'99,999.99'))# '>
			<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(rsDetalleAccion.MontoBaseAnterior,'99,999,999.99'))) LT 12, DE(RepeatString(' ', 12-(len(trim(LSNumberFormat(rsDetalleAccion.MontoBaseAnterior,'99,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(rsDetalleAccion.MontoBaseAnterior,'99,999,999.99'))# '>
			<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(rsDetalleAccion.MontoBaseAnterior,'99,999,999.99'))) LT 12, DE(RepeatString(' ', 12-(len(trim(LSNumberFormat(rsDetalleAccion.MontoBaseAnterior,'99,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(rsDetalleAccion.MontoBaseAnterior,'99,999,999.99'))# '>
<!---		LB_Salario--->			
			<cfif len(trim(rsDetalleAccion.CSdescripcion)) GTE 18>
				<cfset hilera = hilera & '  #trim(Mid(rsDetalleAccion.CSdescripcion,1,18))#: '>
			<cfelse>
				<cfset hilera = hilera & '  #trim(rsDetalleAccion.CSdescripcion)#' & IIf(len(trim(rsDetalleAccion.CSdescripcion)) LT 18, DE(RepeatString(' ', 18-(len(trim(rsDetalleAccion.CSdescripcion))))), DE('')) & ': '>
			</cfif>

			<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(rsDetalleAccion.DDLunidad,'99,999.99')))    LT 9, DE(RepeatString(' ', 9-(len(trim(LSNumberFormat(rsDetalleAccion.DDLunidad,'99,999.99')))))),    DE('')) & '#trim(LSNumberFormat(rsDetalleAccion.DDLunidad,'99,999.99'))# '>
			<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(rsDetalleAccion.DDLmontobase,'99,999,999.99'))) LT 12, DE(RepeatString(' ', 12-(len(trim(LSNumberFormat(rsDetalleAccion.DDLmontobase,'99,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(rsDetalleAccion.DDLmontobase,'99,999,999.99'))# '>
			<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(rsDetalleAccion.DDLmontores,'99,999,999.99'))) LT 12, DE(RepeatString(' ', 12-(len(trim(LSNumberFormat(rsDetalleAccion.DDLmontores,'99,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(rsDetalleAccion.DDLmontores,'99,999,999.99'))# '>
			
			<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
		</cfloop>
	</cfif>
	
	<cfif isdefined("rsConceptosPago") and rsConceptosPago.recordCount GT 0>
		<cfset hilera = hilera & RepeatString('-', 115)>
		<cfset hilera = hilera & '#chr(13)##chr(10)#'>				
		<cfset hilera = hilera & RepeatString(' ', 45)>
		<cfset hilera = hilera & '#LB_ComponentesDePago#'>
		<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
		<cfset hilera = hilera & RepeatString('-', 115)>
		<cfset hilera = hilera & '#chr(13)##chr(10)#'>
		<cfset hilera = hilera & '#trim(LB_Concepto)#'&RepeatString(' ', 60)&'#trim(LB_Importe)#' & '       '& '#trim(LB_Cantidad)#' & '      '& '#trim(LB_Resultado)#'>
		<cfset hilera = hilera & '#chr(13)##chr(10)#'>
		<cfset hilera = hilera & RepeatString('-', 115)>
		<cfset hilera = hilera & '#chr(13)##chr(10)#'>
		
		<cfloop query="rsConceptosPago">
			<cfif len(trim(rsConceptosPago.Concepto)) GTE 50>
				<cfset hilera = hilera & '#trim(Mid(rsDetalleAccion.CSdescripcion,1,50))#'>
			<cfelse>
				<cfset hilera = hilera & '#trim(rsConceptosPago.Concepto)#' & IIf(len(trim(rsConceptosPago.Concepto)) LT 60, DE(RepeatString(' ', 60-(len(trim(rsConceptosPago.Concepto))))), DE(''))&':'>
			</cfif>
			<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(rsConceptosPago.Importe,'99,999,999.99')))   LT 14, DE(RepeatString(' ', 14-(len(trim(LSNumberFormat(rsConceptosPago.Importe,  '99,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(rsConceptosPago.Importe,'99,999,999.99'))# '>
			<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(rsConceptosPago.Cantidad,'99,999,999.99')))  LT 14, DE(RepeatString(' ', 14-(len(trim(LSNumberFormat(rsConceptosPago.Cantidad, '99,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(rsConceptosPago.Cantidad,'99,999,999.99'))# '>
			<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(rsConceptosPago.Resultado,'99,999,999.99'))) LT 14, DE(RepeatString(' ', 14-(len(trim(LSNumberFormat(rsConceptosPago.Resultado,'99,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(rsConceptosPago.Resultado,'99,999,999.99'))# '>
			<cfset hilera = hilera & '#chr(13)##chr(10)#'>
		  </cfloop>
	</cfif>
	<cfset hilera = hilera & RepeatString('-', 115)>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	
	
<!---   Se comenta esta seccion que es dondes se pintan las firmas para las acciones de personal
	<cfquery name="rsFirmas" datasource="#Session.DSN#">
		select 
		RHFid,
		RHTid,
		RHFtipo,
		RHFautorizador,
		DEid,
		CFid
		from RHFirmasAccion
		where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHTid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		order by  RHFOrden
	</cfquery>	
	<cfif rsFirmas.recordCount GT 0>
		<cfset Firma = "">
		<cfset contadorFirmas = 0>
		
		<cfloop query="rsFirmas">
		<!---<cfloop from="1" to ="3" index="i">--->		
			<cfswitch expression="#rsFirmas.RHFtipo#">
				<cfcase value="1">
					<cfif isdefined("rsFirmas.RHFautorizador") and len(trim(rsFirmas.RHFautorizador))>
						<cfset Firma = rsFirmas.RHFautorizador>	
					<cfelse>
						<cfset Firma = "">
					</cfif>	
				</cfcase>
				<cfcase value="2">
					<cfquery name="rsEmpleado" datasource="#Session.DSN#">
						select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
						from DatosEmpleado
						where DEid =  #rsFirmas.DEid#
					</cfquery>
					<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
						<cfset Firma = rsEmpleado.empleado>	
					<cfelse>
						<cfset Firma = "">
					</cfif>	
				</cfcase>
				<cfcase value="3">
					<cfquery name="rsEmpleado" datasource="#Session.DSN#">
						select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
						from DatosEmpleado
						where DEid =  #rsAccion.DEid#
					</cfquery>
					<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
						<cfset Firma = rsEmpleado.empleado>	
					<cfelse>
						<cfset Firma = "">
					</cfif>	
				</cfcase>
				<cfcase value="4">																					
					<cfquery name="rsEmpleado" datasource="#Session.DSN#">
						select 1 
						from LineaTiempo a, 
							 RHPlazas b, 
							 CFuncional c
						where a.DEid =  #rsAccion.DEid#
						and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.DLfvigencia#"> between LTdesde and LThasta
						and a.RHPid=b.RHPid
						and b.CFid=c.CFid
						and b.RHPid=c.RHPid
					</cfquery>
					
					<cfinvoke component="rh.Componentes.RH_Funciones" 
					method="DeterminaJefe"
					deid = "#rsAccion.DEid#"
					fecha = "#rsAccion.DLfvigencia#"
					returnvariable="ResponsableCF">										
					<cfif ResponsableCF.Jefe EQ rsAccion.DEid>
							<cfquery name="Jefedeljefe" datasource="#Session.DSN#">
								select CFidresp 
								from LineaTiempo a, 
									 RHPlazas b, 
									 CFuncional c
								where a.DEid =  #rsAccion.DEid#
								and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.DLfvigencia#"> between LTdesde and LThasta
								and a.RHPid=b.RHPid
								and b.CFid=c.CFid
							</cfquery>	
							<cfinvoke component="rh.Componentes.RH_Funciones" 
							method="DeterminaDEidResponsableCF"
							cfid = "#Jefedeljefe.CFidresp#"
							fecha = "#rsAccion.DLfvigencia#"
							returnvariable="ResponsableCF">	
					<cfelse>
							<cfinvoke component="rh.Componentes.RH_Funciones" 
							method="DeterminaDEidResponsableCF"
							cfid = "#rsAccion.CFid#"
							fecha = "#rsAccion.DLfvigencia#"
							returnvariable="ResponsableCF">												
					</cfif>												
					
					<cfquery name="rsEmpleado" datasource="#Session.DSN#">
						select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
						from DatosEmpleado
						where DEid =  #ResponsableCF#
					</cfquery>
					<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
						<cfset Firma = rsEmpleado.empleado>	
					<cfelse>
						<cfset Firma = "">
					</cfif>	
				</cfcase>
				<cfcase value="5">
					<cfinvoke component="rh.Componentes.RH_Funciones" 
					method="DeterminaDEidResponsableCF"
					cfid = "#rsFirmas.CFid#"
					fecha = "#rsAccion.DLfvigencia#"
					returnvariable="ResponsableCF">
					<cfquery name="rsEmpleado" datasource="#Session.DSN#">
						select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
						from DatosEmpleado
						where DEid =  #ResponsableCF#
					</cfquery>
					<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
						<cfset Firma = rsEmpleado.empleado>	
					<cfelse>
						<cfset Firma = "">
					</cfif>										
				</cfcase>
			</cfswitch>
			
			
			 
			<!---<cfset a = 2>
			<cfif a eq 1>--->
			
			<cfif rsFirmas.recordCount eq 1>
				<cfif isdefined("Firma") and len(trim(Firma))>
					<cfset hilera = hilera & '#chr(13)##chr(10)#'>
					<cfset hilera = hilera & '#chr(13)##chr(10)#'>
					<cfset hilera = hilera & RepeatString(' ', 38)>
					<cfset hilera = hilera & RepeatString('-', 35)>
					<cfset hilera = hilera & '#chr(13)##chr(10)#'>
					<cfset hilera = hilera & IIf(len(trim(Firma)) LT 68, DE(RepeatString(' ', 68-(len(trim(Firma))))), DE(''))&'#Firma#' >
				
				</cfif>
			<cfelse>
				<cfif isdefined("Firma") and len(trim(Firma))>
					<cfset contadorFirmas = contadorFirmas + 1>
					<cfif rsFirmas.recordCount  eq contadorFirmas>
					<!---<cfif 3 eq contadorFirmas>--->
					
						<cfset hilera = hilera & '#chr(13)##chr(10)#'>
						<cfset hilera = hilera & '#chr(13)##chr(10)#'>
						<cfset hilera = hilera & '#chr(13)##chr(10)#'>
						<cfset hilera = hilera & '#chr(13)##chr(10)#'>
						<cfset hilera = hilera & RepeatString('-', 35)>
						<cfset hilera = hilera & '#chr(13)##chr(10)#'>
						<cfset hilera = hilera & IIf(len(trim(Firma)) LT 30, DE(RepeatString(' ', 30-(len(trim(Firma))))), DE(''))&'#Firma#' >
					<cfelse>
						<cfif contadorFirmas mod 2 eq 1>
							<cfset hilera = hilera & '#chr(13)##chr(10)#'>
							<cfset hilera = hilera & '#chr(13)##chr(10)#'>
							<cfset hilera = hilera & RepeatString('-', 35)>
							<cfset hilera = hilera & RepeatString(' ', 30)>
							<cfset hilera = hilera & RepeatString('-', 35)>	
							<cfset hilera = hilera & '#chr(13)##chr(10)#'>
							<cfset hilera = hilera & IIf(len(trim(Firma)) LT 30, DE(RepeatString(' ', 30-(len(trim(Firma))))), DE(''))&'#Firma#' >	
						<cfelse>
							<cfset hilera = hilera & IIf(len(trim(Firma)) LT 65, DE(RepeatString(' ', 65-(len(trim(Firma))))), DE(''))&'#Firma#' >					
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
	</cfif> --->
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	
	<cfset hilera = hilera & '#chr(27)##chr(12)#'>	

	</cfoutput>	
	<!---
	<cfset hilera = hilera & RepeatString(' ', 115)><!---Linea en blanco---->
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	---->
	
	<!----======== Guarda la linea en el archivo txt ========---->
	<cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'BOLETA')>	
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">
	<cfheader name="Content-Disposition" value="attachment;filename=AccionesPersonal.txt">
	<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
	<!---<cf_dump var="fin de la prueba">--->
</cfif>

<!---
FORMATO PDR Y FlashPaper
--->
<cfif ((isdefined('form.formato')) and (form.formato EQ 'PDF' or form.formato EQ 'FlashPaper'))>
<cfdocument format="#form.formato#" 
			marginleft="2" 
			marginright="2" 
			marginbottom="3"
			margintop="1" 
			unit="cm" 
            pagetype="letter" >


<cfoutput query="rsAccion">
	<!--- Conceptos de Pago --->
	<cfquery name="rsConceptosPago" datasource="#Session.DSN#">
		select {fn concat({fn concat(rtrim(b.CIcodigo) , ' - ' )},  b.CIdescripcion )}  as Concepto, 
			a.DDCimporte as Importe, 
			a.DDCcant as Cantidad, 
			a.DDCres as Resultado
		from DDConceptosEmpleado a
		
			inner join CIncidentes b
			on a.CIid = b.CIid
			
			where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DLlinea#">
	</cfquery>
	
	<cfquery name="rsDetalleAccion" datasource="#Session.DSN#">
		select a.CSid,
			b.CScodigo, 
			a.DDLtabla, 
			b.CSdescripcion,
			a.DDLunidad, 
			a.DDLmontobase, 
			a.DDLmontores,
			coalesce(a.DDLunidadant,0.00) as UnidadAnterior, 
			coalesce(a.DDLmontobaseant,0.00) as MontoBaseAnterior, 
			coalesce(a.DDLmontoresant,0.00) as MontoResultadoAnterior,
			a.CIid
		
		from DDLaboralesEmpleado a
		
			inner join ComponentesSalariales b
			on a.CSid = b.CSid
			
			where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DLlinea#">
			
			order by b.CScodigo, b.CSdescripcion
	</cfquery>
	
	<cfif rsDetalleAccion.recordCount GT 0>
		<cfquery name="rsSumDetalleAccion" dbtype="query">
			select sum(DDLmontores) as Total, 
			sum(MontoResultadoAnterior) as TotalAnterior 
			from rsDetalleAccion
			where CIid is null
		</cfquery>
	</cfif>
			
	<cfquery name="rsMostrarSalarioNominal" datasource="#session.DSN#">
		select coalesce(Pvalor,'0') as  Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = 1040
	</cfquery>

	<table width="<cfif isdefined('url.imprimir')>650<cfelse>100%</cfif>" cellpadding="3" cellspacing="0" >
	<tr> 
		<td class="#Session.preferences.Skin#_thcenter" colspan="2"><cf_translate key="LB_Datos_Generales">DATOS GENERALES</cf_translate></td>
	</tr>
	<tr> 
		<td width="10%" align="center" valign="top" style="padding-left: 10px; padding-right: 10px;"> 
		<!--------------------------
		<table border="1" cellspacing="0" cellpadding="0">
			<tr><td>
					<img src="../../nomina/consultas/jerarquia_cf/foto_responsable.cfm?s=#URLEncodedFormat(rsAccion.DEid)#" border="0" width="55" height="73">
			</td></tr>
		</table>
		<-------------------------->
	  </td>
	  <td valign="top" nowrap> 
		  <table width="100%" border="0" cellpadding="5" cellspacing="0">
			<tr> 
			  <td class="fileLabel" width="10%" nowrap><cf_translate key="LB_Nombre_Completo">Nombre Completo</cf_translate>:</td>
			  <td><b><font size="3">#rsAccion.NombreCompleto#</font></b></td>
			</tr>
			<tr> 
			  <td class="fileLabel" width="10%" nowrap align="right" ><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate>:</td>
			  <td align="left">#rsAccion.DEidentificacion#</td>
			  <td align="right"><cf_translate key="LB_ConsecutivoAccion">Consecutivo Acci&oacute;n</cf_translate>:</td>
			  <td align="left">#rsAccion.DLlinea#</td>
			</tr>
		  </table>
	  </td>
	</tr>
	</table>
	
	<table width="<cfif isdefined('url.imprimir')>650<cfelse>100%</cfif>" border="0" cellspacing="0" cellpadding="2" align="center">
		<tr>
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="TipoDeAccion">Tipo de Acci&oacute;n</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>> 
				#rsAccion.RHTid# - #rsAccion.DesTipoAccion#
			</td>
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="FechaAplicacion">Fecha Aplicaci&oacute;n</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				#LSDateFormat(rsAccion.DLfechaaplic,'dd/mm/yyyy')#
			</td>
		</tr>
		<tr> 
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="FechaVigencia">Fecha Vigencia</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				#LSDateFormat(rsAccion.DLfvigencia,'dd/mm/yyyy')#
			</td>
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="FechaVencimiento">Fecha Vencimiento</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				<cfif len(trim(rsAccion.DLffin)) >#LSDateFormat(rsAccion.DLffin,'dd/mm/yyyy')#<cfelse><cf_translate key="indefinido">INDEFINIDO</cf_translate></cfif>
			</td>
		</tr>
		<tr> 
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="Observaciones">Observaciones</cf_translate>:</td>
			<td colspan="3" <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				#rsAccion.DLobs#
			</td>
		</tr>	
		<tr>
			<td colspan="4">
			<table width="100%" border="0" cellspacing="0" cellpadding="2">
				<tr>
				<td width="50%" valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
					<tr>
						<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="SituacionAnterior">Situaci&oacute;n Anterior</cf_translate>
						</div></td>
					</tr>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Plaza">Plaza</cf_translate></td>
						<td height="25">#rsAccion.DesPlazaAnt#</td>
					</tr>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesOficinaAnt#</td>
					</tr>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Departamento">Departamento</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesDeparAnt#</td>
					</tr>
					 
					<cfif usaEstructuraSalarial EQ 1>
							<cfif len(trim(rsAccion.Tcodigoant))>
								<cf_rhcategoriapuesto form="form1" query="#rsAccion#" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">							
							<cfelse>
								<cf_rhcategoriapuesto form="form1" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">
							</cfif>
					</cfif>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Puesto_RH">Puesto RH</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesPuestoAnt#</td>
					</tr>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Jornada">Jornada</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesJornadaAnt#</td>
					</tr>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="PorcentajeDePlaza">Porcentaje de Plaza</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cfif rsAccion.DLporcplazaant NEQ "">#LSCurrencyFormat(rsAccion.DLporcplazaant,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="PorcentajeDeSalarioFijo">Porcentaje de Salario Fijo</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cfif rsAccion.DLporcsalant NEQ "">#LSCurrencyFormat(rsAccion.DLporcsalant,'none')# %<cfelse>0.00 %</cfif></td>
					</tr>
	  
	
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="TipoDeNomina">Tipo de N&oacute;mina</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesTNominaAnt#</td>
					</tr>
					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="RegimenDeVacaciones">R&eacute;gimen de Vacaciones</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesRegVacAnt#</td>
					</tr>
				</table>
				
				</td>
				<td width="50%" valign="top">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
					  <tr>
						<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="SituacionActual">Situaci&oacute;n Actual</cf_translate></div></td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Plaza">Plaza</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesPlaza#</td>
						</tr>
							
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesOficina# </td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Departamento">Departamento</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesDepar#</td>
					  </tr>
						<cfif usaEstructuraSalarial EQ 1>
							<cf_rhcategoriapuesto form="form1" query="#rsAccion#" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">
						</cfif>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Puesto_RH">Puesto RH</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.RHPCodigo# - #rsAccion.DesPuesto# </td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Jornada">Jornada</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesJornada#</td>
						</tr>  	
					  <tr>	
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="PorcentajeDePlaza">Porcentaje de Plaza</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cfif rsAccion.DLporcplaza NEQ "">#LSCurrencyFormat(rsAccion.DLporcplaza,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="PorcentajeDeSalarioFijo">Porcentaje de Salario Fijo</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cfif rsAccion.DLporcsal NEQ "">#LSCurrencyFormat(rsAccion.DLporcsal,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
	
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="TipoDeNomina">Tipo de N&oacute;mina</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesTnomina#</td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="RegimenDeVacaciones">R&eacute;gimen de Vacaciones</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.DesRegVac# </td>
					  </tr>
				</table>
			
			  </tr>
			  <tr <cfif rsAccion.RHTNoMuestraCS eq 1 >style="display:none"</cfif>>
				<td valign="top" > 
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
					  <cfif isdefined("rsDetalleAccion") and rsDetalleAccion.recordCount GT 0>
						  <tr >
							<td class="#Session.Preferences.Skin#_thcenter" colspan="4"><div align="center"><cf_translate key="ComponentesAnteriores">Componentes Anteriores</cf_translate></div></td>
						  </tr>
						  <tr>
							<td class="tituloListas" colspan="2" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="SalarioTotalAnterior">Salario Total Anterior</cf_translate>: </td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsSumDetalleAccion.TotalAnterior,'none')#</td>
						  </tr>
						  <cfif rsMostrarSalarioNominal.Pvalor eq 1>
								<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
									select 
										Ttipopago,
										case Ttipopago when 0 then '#LB_Semanal#'
										when 1 then '#LB_Bisemanal#'
										when 2 then '#LB_Quincenal#'
										else ''
										end as   descripcion
									from TiposNomina 
									where 
									Ecodigo 	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									and Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAccion.Tcodigoant#">
								</cfquery>	
	
								<cfif rsTiposNomina.Ttipopago neq 3 and rsSumDetalleAccion.recordCount GT 0>
									<cfinvoke component="rh.Componentes.RH_Funciones" 
										method="salarioTipoNomina"
										salario = "#rsSumDetalleAccion.TotalAnterior#"
										tcodigo = "#rsAccion.Tcodigoant#"
										returnvariable="var_salarioTipoNomina">
									  <tr>
										<td class="tituloListas" colspan="2" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="LB_Salario">Salario</cf_translate>&nbsp;#rsTiposNomina.descripcion#:</td>
										<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(var_salarioTipoNomina,',9.00')#</td>
									  </tr>
							  </cfif>
						  </cfif>
						</td>
						  <tr>
							<td class="tituloListas" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Componente">Componente</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Unidad">Unidades</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="MontoBase">Monto Base</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Monto">Monto</cf_translate></td>
						  </tr>
						  <cfloop query="rsDetalleAccion">
							  <cfif Len(Trim(rsDetalleAccion.CIid))>
								<cfset color = ' style="color: ##FF0000;"'>
							  <cfelse>
								<cfset color = ''>
							  </cfif>
							  <tr>
								<td height="25" class="fileLabel"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsDetalleAccion.CSdescripcion#</td>
								<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(rsDetalleAccion.UnidadAnterior,',9.00')#</td>
								<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(rsDetalleAccion.MontoBaseAnterior,',9.00')#</td>
								<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsDetalleAccion.MontoBaseAnterior,'none')#</td>
							  </tr>
						</cfloop>
					  </cfif>
					</table>
				</td>
				
				<td valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
					  <cfif isdefined("rsDetalleAccion") and rsDetalleAccion.recordCount GT 0>
						  <tr>
							<td class="#Session.Preferences.Skin#_thcenter" colspan="4"><div align="center"><cf_translate key="ComponentesActuales">Componentes Actuales</cf_translate></div></td>
						  </tr>
						  <tr>
							<td class="tituloListas" colspan="2" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="SalarioTotal">Salario Total</cf_translate>: </td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsSumDetalleAccion.Total,'none')#</td>
						  </tr>
							<cfif rsMostrarSalarioNominal.Pvalor eq 1>
									<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
										select 
											Ttipopago,
											case Ttipopago when 0 then '#LB_Semanal#'
											when 1 then '#LB_Bisemanal#'
											when 2 then '#LB_Quincenal#'
											else ''
											end as   descripcion
										from TiposNomina 
										where 
										Ecodigo 	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
										and Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAccion.Tcodigo#">
									</cfquery>		
									<cfif rsTiposNomina.Ttipopago neq 3 and rsSumDetalleAccion.recordCount GT 0>
										<cfinvoke component="rh.Componentes.RH_Funciones" 
											method="salarioTipoNomina"
											salario = "#rsSumDetalleAccion.Total#"
											tcodigo = "#rsAccion.Tcodigo#"
											returnvariable="var_salarioTipoNomina">
										  <tr>
											<td class="tituloListas" colspan="2" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="LB_Salario">Salario</cf_translate>&nbsp;#rsTiposNomina.descripcion#:</td>
											<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(var_salarioTipoNomina,',9.00')#</td>
										  </tr>
															  
								  </cfif>
							  </cfif>
						  <tr>
							<td class="tituloListas" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Componente">Componente</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Unidad">Unidades</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="MontoBase">Monto Base</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Monto">Monto</cf_translate></td>
						  </tr>
						  
						  <cfloop query="rsDetalleAccion">
						  <cfif Len(Trim(rsDetalleAccion.CIid))>
							<cfset color = ' style="color: ##FF0000;"'>
						  <cfelse>
							<cfset color = ''>
						  </cfif>
						  <tr>
							<td class="fileLabel" height="25"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsDetalleAccion.CSdescripcion#</td>						
							<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(rsDetalleAccion.DDLunidad,',9.00')#</td>
							<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(rsDetalleAccion.DDLmontobase,',9.00')#</td>
							<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>
								#LSCurrencyFormat(rsDetalleAccion.DDLmontores,'none')#
							</td>
						  </tr>
					  </cfloop>
					  </cfif>
					</table>
				</td>
			  </tr>
			</table>
			</td>
		  </tr>
		  <tr <cfif RHTNoMuestraCS eq 1 >style="display:none"</cfif>>
			<td colspan="4" align="center" style="color: ##FF0000 ">
				<cf_translate  key="MSG_LosComponentesQueAparecenEnColorRojoSePaganEnFormaIncidente">Los componentes que aparecen en color rojo se pagan en forma incidente.</cf_translate>
			</td>
		  </tr>
		  <cfif isdefined("rsConceptosPago") and rsConceptosPago.recordCount GT 0>
			  <tr>
				<td colspan="4">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
				  <tr>
					<td class="#Session.Preferences.Skin#_thcenter" colspan="4"><div align="center"><cf_translate key="ConceptosPago">Conceptos de Pago</cf_translate></div></td>
				  </tr>
				  <tr>
					<td class="tituloListas" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Concepto">Concepto</cf_translate></td>
					<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Importe">Importe</cf_translate></td>
					<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Cantidad">Cantidad</cf_translate></td>
					<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Resultado">Resultado</cf_translate></td>
				  </tr>
				  <cfloop query="rsConceptosPago">
					  <tr>
						<td <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsConceptosPago.Concepto#</td>
						<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsConceptosPago.Importe, 'none')#</td>
						<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsConceptosPago.Cantidad, 'none')#</td>
						<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsConceptosPago.Resultado, 'none')#</td>
					  </tr>
				  </cfloop>
				</table>
				</td>
			  </tr>
		  </cfif>
	
<!---	Se comenta es seccion que pinta las firmas de las acciones de personal
		<cfif isdefined('url.imprimir')>
			   <cfquery name="rsFirmas" datasource="#Session.DSN#">
					select 
					RHFid,
					RHTid,
					RHFtipo,
					RHFautorizador,
					DEid,
					CFid
					from RHFirmasAccion
					where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHTid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					order by  RHFOrden
				</cfquery>
				<cfif rsFirmas.recordCount GT 0>
					<tr> 
						<td colspan="4" align="center">
							<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
								<tr>
									<td  colspan="2" align="center">&nbsp;</td>		
								</tr>
								<tr>
									<td  colspan="2" align="center">&nbsp;</td>		
								</tr>
								<cfset Firma = "">
								<cfset contadorFirmas = 0>
								<cfloop query="rsFirmas">
									<cfswitch expression="#rsFirmas.RHFtipo#">
										<cfcase value="1">
											<cfif isdefined("rsFirmas.RHFautorizador") and len(trim(rsFirmas.RHFautorizador))>
												<cfset Firma = rsFirmas.RHFautorizador>	
											<cfelse>
												<cfset Firma = "">
											</cfif>	
										</cfcase>
										<cfcase value="2">
											<cfquery name="rsEmpleado" datasource="#Session.DSN#">
												select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
												from DatosEmpleado
												where DEid =  #rsFirmas.DEid#
											</cfquery>
											<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
												<cfset Firma = rsEmpleado.empleado>	
											<cfelse>
												<cfset Firma = "">
											</cfif>	
										</cfcase>
										<cfcase value="3">
											<cfquery name="rsEmpleado" datasource="#Session.DSN#">
												select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
												from DatosEmpleado
												where DEid =  #rsAccion.DEid#
											</cfquery>
											<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
												<cfset Firma = rsEmpleado.empleado>	
											<cfelse>
												<cfset Firma = "">
											</cfif>	
										</cfcase>
										<cfcase value="4">																					
											<cfquery name="rsEmpleado" datasource="#Session.DSN#">
												select 1 
												from LineaTiempo a, 
													 RHPlazas b, 
													 CFuncional c
												where a.DEid =  #rsAccion.DEid#
												and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.DLfvigencia#"> between LTdesde and LThasta
												and a.RHPid=b.RHPid
												and b.CFid=c.CFid
												and b.RHPid=c.RHPid
											</cfquery>
											
											<cfinvoke component="rh.Componentes.RH_Funciones" 
											method="DeterminaJefe"
											deid = "#rsAccion.DEid#"
											fecha = "#rsAccion.DLfvigencia#"
											returnvariable="ResponsableCF">										
											<cfif ResponsableCF.Jefe EQ rsAccion.DEid>
													<cfquery name="Jefedeljefe" datasource="#Session.DSN#">
														select CFidresp 
														from LineaTiempo a, 
															 RHPlazas b, 
															 CFuncional c
														where a.DEid =  #rsAccion.DEid#
														and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.DLfvigencia#"> between LTdesde and LThasta
														and a.RHPid=b.RHPid
														and b.CFid=c.CFid
													</cfquery>	
													<cfinvoke component="rh.Componentes.RH_Funciones" 
													method="DeterminaDEidResponsableCF"
													cfid = "#Jefedeljefe.CFidresp#"
													fecha = "#rsAccion.DLfvigencia#"
													returnvariable="ResponsableCF">	
											<cfelse>
													<cfinvoke component="rh.Componentes.RH_Funciones" 
													method="DeterminaDEidResponsableCF"
													cfid = "#rsAccion.CFid#"
													fecha = "#rsAccion.DLfvigencia#"
													returnvariable="ResponsableCF">												
											</cfif>												
											
											<cfquery name="rsEmpleado" datasource="#Session.DSN#">
												select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
												from DatosEmpleado
												where DEid =  #ResponsableCF#
											</cfquery>
											<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
												<cfset Firma = rsEmpleado.empleado>	
											<cfelse>
												<cfset Firma = "">
											</cfif>	
										</cfcase>
										<cfcase value="5">
											<cfinvoke component="rh.Componentes.RH_Funciones" 
											method="DeterminaDEidResponsableCF"
											cfid = "#rsFirmas.CFid#"
											fecha = "#rsAccion.DLfvigencia#"
											returnvariable="ResponsableCF">
											<cfquery name="rsEmpleado" datasource="#Session.DSN#">
												select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
												from DatosEmpleado
												where DEid =  #ResponsableCF#
											</cfquery>
											<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
												<cfset Firma = rsEmpleado.empleado>	
											<cfelse>
												<cfset Firma = "">
											</cfif>										
										</cfcase>
									</cfswitch>
									<cfif rsFirmas.recordCount eq 1>
										<cfif isdefined("Firma") and len(trim(Firma))>
											<tr>
												<td  width="35%" align="center">&nbsp;</td>
												<td  width="30%" align="center">
													<hr/>
												</td>
												<td width="35%" align="center">&nbsp;</td>
											</tr>
											
											<tr>
												<td  colspan="3" align="center">
													#Firma#
												</td>
											</tr>
										</cfif>
									<cfelse>
										<cfif isdefined("Firma") and len(trim(Firma))>
											<cfset contadorFirmas = contadorFirmas + 1>
											<cfif contadorFirmas mod 2 eq 1>
												<tr>
													<td width="50%" align="center">
														<table width="100%" border="0" cellspacing="0" cellpadding="2">
															<tr>
																<td  width="25%" align="center">&nbsp;</td>
																<td  width="50%" align="center"><hr/></td>
																<td  width="25%" align="center">&nbsp;</td>
															</tr>
															<tr>
																<td  colspan="3" align="center">
																	#Firma#
																</td>
															</tr>																
														</table>
													</td>
											<cfelse>
													<td width="50%" align="center">
														<table width="100%" border="0" cellspacing="0" cellpadding="2">
															<tr>
																<td  width="25%" align="center">&nbsp;</td>
																<td  width="50%" align="center"><hr/></td>
																<td  width="25%" align="center">&nbsp;</td>
															</tr>
															<tr>
																<td  colspan="3" align="center">
																	#Firma#
																</td>
															</tr>																
														</table>
													</td>														
												</tr>
												<tr>
													<td  colspan="2" align="center">&nbsp;</td>		
												</tr>
											</cfif>
										</cfif>
									</cfif>
								</cfloop>
							</table>
							<cfdocumentitem type = "pagebreak"/>
						</td>
					</tr>
				<cfelse>
					<tr><td colspan="4" align="center">
						<cfdocumentitem type = "pagebreak"/>
					</td></tr>
				</cfif> 
		</cfif>
--->		
		<tr><td colspan="4" align="center">
			<cfdocumentitem type = "pagebreak"/>
		</td></tr>
	</cfoutput>
</cfdocument>
</cfif>





