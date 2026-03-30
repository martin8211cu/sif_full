<cf_templateheader title="Par&acute;metros del Formato">	
	<script type="text/javascript" language="javascript1.2" src="../../js/utilesMonto.js"></script>
	
		<cfif isdefined("url.FMT01COD") and not isdefined("form.FMT01COD")>
			<cfset form.FMT01COD = url.FMT01COD >
		</cfif>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					  <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Par&aacute;metros por Formato'>
						  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
								  <td colspan="3">
									  <cfinclude template="../../portlets/pNavegacion.cfm">
								  </td>
							  </tr>
					
							  <tr> 
								  <td valign="top" width="50%"> 
									<cfinvoke 
									 component="sif.Componentes.pListas"
									 method="pListaRH"
									 returnvariable="pListaRet">
										<cfinvokeargument name="tabla" value="FMT010"/>
										<cfinvokeargument name="columnas" value="FMT01COD, FMT10LIN, FMT10PAR, case FMT10TIP when 0 then 'Texto' when 1 then 'Numérico' when 2 then 'Fecha' end as FMT10TIP, FMT10LON, FMT10DEF"/>
										<cfinvokeargument name="desplegar" value="FMT10PAR, FMT10TIP, FMT10LON"/>
										<cfinvokeargument name="etiquetas" value="Nombre, Tipo, Longitud"/>
										<cfinvokeargument name="formatos" value="V, V, V"/>
										<cfinvokeargument name="filtro" value="FMT01COD='#form.FMT01COD#' order by 4, 3" />
										<cfinvokeargument name="align" value="left, left, center"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="Nuevo" value=""/>
										<cfinvokeargument name="irA" value="FMTParametros.cfm"/>
									</cfinvoke>
								  </td>
								  <td valign="top" width="50%">
									<cfinclude template="formFMTParametros.cfm">
								  </td>
							  </tr>
						  </table>
					  <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>