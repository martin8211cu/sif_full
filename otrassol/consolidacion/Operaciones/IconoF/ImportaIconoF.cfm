<style type="text/css">
.engris { background-color:lightgray }
</style>
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor,Pdescripcion
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

	<cf_templateheader title="Importaci&oacute;n de IconoF">
    <script language="JavaScript1.2" type="text/javascript" src="../../../js/sinbotones.js"></script>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n de IconoF">
			<cfinclude template="../../../../sif/portlets/pNavegacionCG.cfm">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td width="50%" valign="top">
						<table width="100%" align="center" cellpadding="2" cellspacing="0">
							<tr><td>
								<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n de IconoF">
									Esta opci&oacute;n permite importar la información del IconoF para cada empresa para luego consolidar esta información en un único archivo consolidado.

					          <p>Hasta el momento se ha cargado la siguiente informaci&oacute;n:</p>
                              
                              <cfquery datasource="#session.dsn#" name="resumen">
                                select i.Mes, e.Edescripcion as Empresa, count(1) as Registros
                                from Cons_IconoF i
                                	join Empresas e
                                    	on e.Ecodigo = i.Ecodigo
                                where i.Periodo=2010
                                group by e.Edescripcion, i.Mes
                                order by e.Edescripcion, i.Mes desc
                              </cfquery>
                              
                              <table cellspacing="0" cellpadding="4" style="border:1px solid black">
                              	<tr class="engris"><td>&nbsp;</td><td colspan="12" align="center">Mes</td></tr>
                              	<tr class="engris"><td>Empresa</td>
                                <cfloop from="1" to="12" index="mescol"><td><cfoutput>#mescol#</cfoutput></td></cfloop></tr>
                                
                                <cfoutput query="resumen" group="Empresa">
                                    <tr >
                                    <td class="engris">#HTMLEditFormat(Empresa)#</td>
                                    <cfset mescol=0>
                                    <cfoutput>
                                    	<cfset mescol=mescol+1>
										<!--- Rellenar los meses faltantes --->
                                        <cfloop condition="mescol LT mes">
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
								    <cf_web_portlet_end>
                              

                              </td></tr>
						</table>
					</td>
					<td width="50%" valign="top">
                    <cfoutput>
						<form name="form1" method="post" enctype="multipart/form-data"
                        	 action="SQLImportaIconoF.cfm?show_process=1"
                             onsubmit="javascript:return form_onsubmit(this);" 
                             style="margin:0;" target="proceso_importador">                        
							<table width="100%" cellpadding="2" cellspacing="0">
                               <tr>
                                    <td align="right" nowrap><strong>Empresa por importar:&nbsp;</strong> </td>	
                                    <td>		
                                    	<cfset gpoElimina = ObtenerDato(1330)>
                                        <cfquery name="rsEmpresas" datasource="#session.DSN#">
                                            select Ecodigo, Edescripcion 
                                            from Empresas
                                            where Ecodigo in (Select Ecodigo from AnexoGEmpresaDet where GEid=#gpoElimina.Pvalor#) and
                                            	  Ecodigo <> #session.Ecodigo#
                                            order by Ecodigo
                                        </cfquery>			
                                        <select name="Empresa" id="Empresa" tabindex="1">
                                            <cfloop query="rsEmpresas">
                                                <option value="#rsEmpresas.Ecodigo#"> #rsEmpresas.Edescripcion# </option>
                                            </cfloop>
                                        </select>
                                    </td>	
                                </tr>                            
								<tr>
									<td width="42%" align="right" nowrap="nowrap">Per&iacute;odo:&nbsp;</td>
                                    <td>
										<cfset periodo_actual = ObtenerDato(30)>
                                        <select name="periodo" id=Periodo tabindex="2">
                                            <option value="#periodo_actual.Pvalor#" >#periodo_actual.Pvalor#</option>
                                            <cfloop step="-1" from="#periodo_actual.Pvalor-1#" to="#periodo_actual.Pvalor-3#" index="i"  >
                                                <option value="#i#" >#i#</option>
                                            </cfloop>
                                        </select>
                                    </td>
								<tr>
									<td width="42%" align="right" nowrap="nowrap">Mes:&nbsp;</td>
                 					<td><select name="mes" id=mes tabindex="3">
                                          <option value="1" >Enero</option>
                                          <option value="2" >Febrero</option>
                                          <option value="3" >Marzo</option>
                                          <option value="4" >Abril</option>
                                          <option value="5" >Mayo</option>
                                          <option value="6" >Junio</option>
                                          <option value="7" >Julio</option>
                                          <option value="8" >Agosto</option>
                                          <option value="9" >Setiembre</option>
                                          <option value="10" >Octubre</option>
                                          <option value="11" >Noviembre</option>
                                          <option value="12" >Diciembre</option>
                                        </select></td>
								</tr>
								<tr>
									<td width="42%" align="right" nowrap="nowrap">Archivo:&nbsp;</td>
                 					<td><input type="file" name="archivo"></td>
								</tr>
								<tr>
									<td colspan="2" align="center"><input type="submit" class="btnAplicar" name="Aplicar" value="Importar"></td>
								</tr>
							</table>
						</form>
                        
            </cfoutput>
			<cfset StructDelete(session, "load_status")>
                        
            <iframe align="middle" src="about:blank" id="status_importador" name="status_importador" frameborder="0" style="width:450px">
            </iframe>
            <iframe align="middle" src="about:blank" id="proceso_importador" name="proceso_importador" frameborder="0">
            </iframe>
                        
					</td>
				</tr>
			</table>
            
            <script type="text/ecmascript" defer="defer">
			function form_onsubmit(f) {
				if (f.archivo.value == "") {
					alert("Por favor seleccione un archivo de IonoF en formato Excel 2007 para su importación");
					return false;
				}
				f.Aplicar.disabled = true;
				document.getElementById("status_importador").src="SQLImportaIconoF.cfm?show_status=1";
				return true;
			}
			</script>
		<cf_web_portlet_end>
	<cf_templatefooter>	