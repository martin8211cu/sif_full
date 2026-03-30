<cfinvoke key="LB_Titulo" default="Eliminar Conversión de Moneda de Informe"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="eliminarDatosConversion.xml"/>
<cfinvoke key="BTN_Procesar" default="Procesar"	returnvariable="BTN_Procesar"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="/sif/generales.xml"/>


<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>

<cfinclude template="../consultas/Funciones.cfm">
<cfif not isdefined("url.periodo")>
	<cfset periodo_actual = "#get_val(30).Pvalor#">
<cfelse>
	<cfset periodo_actual = "#url.periodo#">
</cfif>
<cfset mes_actual = "#get_val(40).Pvalor#">
<cfset Periodo = "#periodo_actual#">
<cfquery name="p" datasource="#session.dsn#">
	select distinct Speriodo as v 
	from CGPeriodosProcesados 
	where Ecodigo = #Session.Ecodigo#
	order by 1	
</cfquery>


<cf_templateheader title="#LB_Titulo#">
    <cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Titulo#">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td width="50%">
						<table width="80%" align="center" cellpadding="2" cellspacing="0">
							<tr><td>
								<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Titulo#">
                                <cf_translate key=LB_Mensaje>
									Esta opci&oacute;n de sistema permite a un 
									usuario autorizado borrar los datos de conversi&oacute;n de
									moneda que se hayan procesado.  Esto, para permitir realizar el proceso de
									nuevo cuando la informaci&oacute;n de la contabilidad debe ser cambiada por
									asientos retroactivos.
                                    </cf_translate>
								<cf_web_portlet_end>
							</td></tr>
						</table>
					</td>
					<cfset ruta= "eliminarDatosConversion.cfm">
					<cfif isdefined('B15') and B15>
                        <cfset ruta= "eliminarDatosConversionB15.cfm">
                    </cfif>
					
					<td width="50%">
						<form name="form1" method="post" action="eliminarDatosConversion-sql.cfm" style="margin:0;" onsubmit="javascript: return confirmar()">
							<table width="100%" cellpadding="2" cellspacing="0">
								<tr>
									<td width="42%" align="right" nowrap="nowrap"><cf_translate key=LB_Periodo>Per&iacute;odo</cf_translate>:&nbsp;</td>
									<td>
									  <select name="Periodo" tabindex="1" 
                                        	onchange="document.location.href='<cfoutput>#ruta#</cfoutput>?Periodo='+this.value;">
                                            <cfoutput query="p">
                                                <option value="#p.v#" <cfif Periodo eq p.v>selected</cfif>>#p.v#</option>
                                            </cfoutput>
                                        </select> 
									</td>
								</tr>
								<tr>
									<td width="42%" align="right" nowrap="nowrap"><cf_translate key=LB_Mes>Mes</cf_translate>:&nbsp;</td>
									<td>
									    <cf_meses value=#mes_actual# >
									</td>
								</tr>
								<tr>
									<td colspan="2" align="center"><cfoutput><input type="submit" class="btnAplicar" name="Aplicar" value="#BTN_Procesar#"></cfoutput></td>
								</tr>
							</table>
                            <cfif isdefined('B15') and B15>
                            	<input name="B15" value="true" type="hidden" />
                            </cfif>
						</form>
				</td>
			</tr>
		</table>
			<table>
                <tr>
					<td>
						<p><cf_translate key=LB_MesesConvertidos>Hasta el momento se han convertido los meses</cf_translate>:</p>
                      	<cfquery datasource="#session.dsn#" name="resumen">
                            select i.Smes as Emes, e.Edescripcion as Empresa, count(1) as Registros
                            from SaldosContablesConvertidos i
                                join Empresas e
                                    on e.Ecodigo = i.Ecodigo
                            where i.Speriodo=#periodo_actual# and i.Ecodigo=#Session.Ecodigo#
							 <cfif isdefined('B15') and B15>
							  and B15 = 1
							 <cfelse>
							   and B15 = 0                   
							 </cfif>        
                            group by e.Edescripcion, i.Smes
                            order by e.Edescripcion, i.Smes
							
                      	</cfquery>
                              
                        <table cellspacing="0" cellpadding="4" style="border:1px solid black">
                            <tr class="engris"><td>&nbsp;</td><td colspan="12" align="center"><cf_translate key=LB_Mes>Mes</cf_translate></td></tr>
                            <tr class="engris"><td><cf_translate key=LB_Empresa>Empresa</cf_translate></td>
                            <cfloop from="1" to="12" index="mescol"><td><cfoutput>#mescol#</cfoutput></td></cfloop></tr>
                            
                            <cfoutput query ="resumen" group="Empresa" >
                                <tr >
                                    <td class="engris">#HTMLEditFormat(Empresa)#</td>
                                    <cfset mescol=0>
                                    <cfoutput>
                                    	<cfset mescol=mescol+1>
										<!--- Rellenar los meses faltantes --->
                                        <cfloop condition="mescol LT Emes">
											<cfset mescol=mescol+1>
                                            <td>&nbsp;</td>
                                        </cfloop>
                                        <td  title="#HTMLEditFormat(Registros)# registros">X</td>
                                    </cfoutput>
                                    <!--- Rellenar los meses faltantes --->
                                    <cfloop condition="mescol LT 12">
                                        <cfset mescol=mescol+1>
                                        <td>&nbsp;</td>
                                    </cfloop>
                                </tr>
							</cfoutput> 
                   		</table>
                    </td>
                </tr>
            </table>               
    <cf_web_portlet_end>
<cf_templatefooter>	
<script language="javascript" type="text/javascript">
	function confirmar()
	{
		return  confirm("¿Está seguro de que desea eliminar los datos de conversión seleccionados?");
	}
</script>