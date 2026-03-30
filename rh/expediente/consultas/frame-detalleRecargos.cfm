<cfquery name="rsDatosRec" datasource="#session.DSN#">
	select DLlinea,b.RHPcodigo as CodPlaza, b.RHPdescripcion as DescPlaza,DLporcplaza,DLfvigencia,DLffin,a.DEid,a.RHPid
    from DLaboralesEmpleadoRec a
    inner join RHPlazas b
    	on b.RHPid = a.RHPid
    inner join RHPuestos c
    	on c.RHPcodigo = b.RHPpuesto
    where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
</cfquery>

<cfif rsDatosRec.RecordCount>
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
		<tr><td colspan="4" class="#Session.Preferences.Skin#_thcenter"><div align="center"><cf_translate key="LB_Recargos">Recargos</cf_translate></div></td></tr>
		<cfloop query="rsDatosRec">
        	<tr>
            	<td>
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr bgcolor="##E4E4E4" height="20">
							<td class="fileLabel" nowrap width="5%" style="cursor:pointer">
								<img  id="menos#RHPid#" src="../../imagenes/menos.gif" style="cursor:pointer" onclick="javascript: document.getElementById('TR#RHPid#').style.display='none'; document.getElementById('mas#RHPid#').style.display=''; document.getElementById('menos#RHPid#').style.display='none'; "/>
								<img style ="display:none;cursor:pointer" id="mas#RHPid#" src="../../imagenes/mas.gif" onclick="javascript: document.getElementById('TR#RHPid#').style.display=''; document.getElementById('menos#RHPid#').style.display=''; document.getElementById('mas#RHPid#').style.display='none'; "/>
								<strong><cf_translate key="LB_Plaza_RHR">Plaza</cf_translate></strong>&nbsp;
							</td>
							<td align="left"  width="30%" >
                            	#rtrim(rsDatosRec.CodPlaza)#&nbsp;-&nbsp;#rsDatosRec.DescPlaza#</td>
							<td nowrap  width="15%">
                            	<strong><cf_translate key="LB_%Porcentaje_de_Plaza">% Plaza</cf_translate>:&nbsp;</strong>
								<cfif rsDatosRec.DLporcplaza NEQ "">#LSCurrencyFormat(rsDatosRec.DLporcplaza,'none')# <cfelse>0.00 </cfif>%
                            </td>
							<td align="left"  width="25%">
                            	<strong><cf_translate key="LB_FechaV">Fecha Vigencia</cf_translate>:</strong> #LSDateFormat(rsDatosRec.DLfvigencia,'dd/mm/yyyy')#</td>
							<td align="left" width="25%" >
                            	<strong><cf_translate key="LB_FechaV">Fecha Vencimiento</cf_translate>:</strong> #LSDateFormat(rsDatosRec.DLffin,'dd/mm/yyyy')#</td>
						</tr>
						<tr id="TR#RHPid#">
                        	<td colspan="5">
                            	<table width="100%" border="0" cellspacing="2" cellpadding="2">
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
                            
                                        from DDLaboralesEmpleadoRec a
                                        
                                        inner join ComponentesSalariales b
                                        on a.CSid = b.CSid
                            
                                        where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosRec.DLlinea#">
                                          and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosRec.DEid#">
                                          and a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosRec.RHPid#">
                                        order by b.CScodigo, b.CSdescripcion
                                    </cfquery>
                    
                                    <tr <cfif RHTNoMuestraCS eq 1 >style="display:none"</cfif>>
                                        <td valign="top" > 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
                                              <cfif isdefined("rsDetalleAccion") and rsDetalleAccion.recordCount GT 0>
                                                  <tr >
                                                    <td class="#Session.Preferences.Skin#_thcenter" colspan="4"><div align="center"><cf_translate key="ComponentesAnteriores">Componentes Anteriores</cf_translate></div></td>
                                                  </tr>
                                                  <tr>
                                                    <td class="tituloListas" colspan="2" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="SalarioTotalAnterior">Salario Total Anterior</cf_translate>: </td>
                                                    <td class="tituloListas" colspan="2" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsSumDetalleAccion.TotalAnterior,'none')#</td>
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
                                                            and Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAccion2.Tcodigoant#">
                                                        </cfquery>		
                                                        <cfif rsTiposNomina.Ttipopago neq 3>
                                                            <cfinvoke component="rh.Componentes.RH_Funciones" 
                                                                method="salarioTipoNomina"
                                                                salario = "#rsSumDetalleAccion.TotalAnterior#"
                                                                tcodigo = "#rsAccion2.Tcodigoant#"
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
                                                    <td class="tituloListas" colspan="2" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsSumDetalleAccion.Total,'none')#</td>
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
                                                            <cfif rsTiposNomina.Ttipopago neq 3>
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
					</table>

                </td>
            </tr>
		</cfloop>
		
	</table></cfoutput>
</cfif>

<script>
	<cfloop query="rsDatosRec">
	document.getElementById('TR<cfoutput>#RHPid#</cfoutput>').style.display='none';
	document.getElementById('menos<cfoutput>#RHPid#</cfoutput>').style.display='none'; 
	document.getElementById('mas<cfoutput>#RHPid#</cfoutput>').style.display=''; 
	</cfloop>
</script>