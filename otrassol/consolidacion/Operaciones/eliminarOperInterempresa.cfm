<!--- Modificado por ABG 29-Marzo-2011
Se mejora la barra de Eliminaciones procesadas --->
<style type="text/css">
.engris { background-color:#036; color:#FFF; font-weight:bold}
</style>

<cfparam name= "url.errorCta" default=''>
<cfif isdefined('url.Cuenta') and not isdefined('form.Cuenta')>
	<cfset form.Cuenta= url.Cuenta>
</cfif>

<cffunction name="ObtenerDato" returntype="query">
    <cfargument name="pecodigo" type="numeric" required="true">	
	<cfargument name="pcodigo"  type="numeric" required="true">
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor,Pdescripcion
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pecodigo#">
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cfset gpoElimina = ObtenerDato(#session.Ecodigo#,1330)>
<cfquery name="rsEmpresas" datasource="#session.DSN#">
	select Ecodigo, Edescripcion 
	from Empresas
	where Ecodigo in (Select Ecodigo from AnexoGEmpresaDet where GEid=#gpoElimina.Pvalor#) and
		  Ecodigo <> #session.Ecodigo#
	order by Ecodigo
</cfquery>			
<cfif isdefined('url.Empresa') >
	<cfset EmpresaCons = url.Empresa>
<cfelse>
	<cfset EmpresaCons = #rsEmpresas.Ecodigo#>
</cfif>
<cfset periodo_actual = ObtenerDato(#EmpresaCons#,30)>
<cfif isdefined("url.Periodo")>
	<cfset PeriodoSel = url.Periodo>
<cfelse>
	<cfset PeriodoSel = periodo_actual.Pvalor>
</cfif>
<cfset mes_contable = ObtenerDato(#EmpresaCons#,40)>

	<cf_templateheader title="Eliminaci&oacute;n de operaciones Interempresas">
    <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
    
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Eliminaci&oacute;n de operaciones Interempresas">
			<cfinclude template="../../../sif/portlets/pNavegacionCG.cfm">
            <table width="100%" cellpadding="2" cellspacing="0">
            <cfoutput>                        
				<tr>
					<td width="50%">
						<table width="80%" align="center" cellpadding="2" cellspacing="0">
							<tr><td>
								<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Eliminar operaciones Interempresas">
									Esta opci&oacute;n permite la eliminaci&oacute;n de operaciones intermpresa, generando
									la  p&oacute;liza contable de las cuentas parametrizadas de las empresas a consolidar,
                                    considerando los saldos por moneda origen de cada cuenta a eliminar.
								<cf_web_portlet_end>
							</td></tr>
						</table>
					</td>
                    
					<td width="50%">
						<form name="form1" method="post" action="SQLeliminarOperacionInter.cfm" style="margin:0;" onSubmit="javascript: return funcValidar(#periodo_actual.Pvalor#,#mes_contable.Pvalor#)">  
							<table width="100%" cellpadding="2" cellspacing="0">
                               <tr>
                                    <td align="right" nowrap><strong>Empresa a Consolidar:&nbsp;</strong> </td>	
                                    <td>		
                                        <select name="Empresa" id="Empresa" tabindex="1" onchange="document.location.href='EliminarOperInterempresa.cfm?Empresa='+this.value;">
                                            <cfloop query="rsEmpresas">
                                                <option value="#rsEmpresas.Ecodigo#"<cfif rsEmpresas.Ecodigo EQ EmpresaCons>selected</cfif>>#rsEmpresas.Edescripcion# </option>
                                            </cfloop>
                                        </select>
                                    </td>	
                                </tr>                            
								<tr>
									<td width="42%" align="right" nowrap="nowrap">Per&iacute;odo:&nbsp;</td>
                                    <td>
                                        <select name="periodo" id=Periodo tabindex="2" onchange="document.location.href='EliminarOperInterempresa.cfm?Periodo='+this.value+'&Empresa='+document.form1.Empresa.value ;">
                                            <option value="#periodo_actual.Pvalor#" <cfif periodo_actual.Pvalor EQ PeriodoSel>selected</cfif>>#periodo_actual.Pvalor#</option>
                                            <cfloop step="-1" from="#periodo_actual.Pvalor-1#" to="#periodo_actual.Pvalor-3#" index="i"  >
                                                <option value="#i#" <cfif i EQ PeriodoSel>selected</cfif>>#i#</option>
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
									<td colspan="2" align="center"><input type="submit" class="btnAplicar" name="Aplicar" value="Procesar"></td>
								</tr>
							</table>
						</form>
					</td>
				</tr>
				<cfif IsDefined ("url.errorCta") and url.errorCta is 1>
                    <tr>
                        <cfquery name="rsEmpresa" datasource="#session.DSN#">
							select Edescripcion from Empresas where Ecodigo = #session.Ecodigo#
						</cfquery>	
<!---                   <cfset MensError ="">	
                        <cfif url.errorCta is 1>
                        	<cfset MensError = "La cuenta de eliminaci&oacute;n #form.Cuenta# no se pudo crear para la empresa de consolidaci&oacute;n #rsEmpresa.Edescripcion#." >
                        </cfif>--->
                      	<td colspan="4" style="color:red;font-weight:bold;"> #form.Cuenta# </td>
                    </tr>                    
                </cfif> 
            </cfoutput>                            
			</table>
            
			<script language="JavaScript1.2" type="text/javascript">
            function funcValidar(PeriodoC,MesC){
                if ((document.form1.mes.value > MesC) && (document.form1.periodo.value == PeriodoC))
                {
                    alert("La empresa no ha cerrado para el periodo "+document.form1.periodo.value+" mes "+document.form1.mes.value);
                    return false
                }
                return true
            }	
            </script>
			<table>
                <tr>
					<td>
						<p>Hasta el momento se ha cargado la siguiente informaci&oacute;n:</p>
                      	<cfquery datasource="#session.dsn#" name="resumen">
                            select i.Emes, e.Edescripcion as Empresa, count(1) as Registros
                            from Cons_SaldosXCuenta i
                                join Empresas e
                                    on e.Ecodigo = i.Ecodigo
                            where i.Eperiodo= <cfqueryparam cfsqltype="cf_sql_integer" value="#PeriodoSel#">
                            and i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaCons#">
                            group by e.Edescripcion, i.Emes
                            order by e.Edescripcion, i.Emes
                      	</cfquery>
                        <cfquery datasource="#session.dsn#" name="rsEmpresa">
                        	select Edescripcion as Empresa 
                            from Empresas
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaCons#">
                        </cfquery>
                        <table cellspacing="0" cellpadding="4" style="border:1px solid black">
                            <tr class="engris"><td>Periodo</td><td colspan="12">&nbsp;</td></tr>
                            <tr class="engris"><td><cfoutput>#PeriodoSel#</cfoutput></td><td colspan="12" align="center">Mes</td></tr>
                            <tr class="engris"><td>Empresa</td>
                            <cfloop from="1" to="12" index="mescol"><td><cfoutput>#mescol#</cfoutput></td></cfloop></tr>
                            
                            <cfoutput>
							<!---<cfoutput query ="resumen" group="Empresa" >--->
                                <tr >
                                    <td>#HTMLEditFormat(rsEmpresa.Empresa)#</td>
                                    <!---<cfset mescol=0>--->
                                    <cfloop from="1" to="12" step="1" index="m">
                                    	<cfquery dbtype="query" name="rsMesProceso">
                                        	select Emes, Registros 
                                            from resumen
                                            where Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#m#">
                                        </cfquery>
                                        <cfif rsMesProceso.recordcount GT 0>
                                        	<td align="center" title="#HTMLEditFormat(rsMesProceso.Registros)# Registros Eliminacion">P</td>
                                        <cfelse>
                                            <cfif m LT mes_contable.Pvalor or PeriodoSel LT periodo_actual.Pvalor>
                                            	<cfquery datasource="#session.dsn#" name="rsCierre">
                                                	select *
                                                    from BitacoraCierres
                                                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaCons#">
                                                    and BCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#PeriodoSel#">
                                                    and BCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#m#">
                                                </cfquery>
                                                <cfif rsCierre.recordcount GT 0>
                                                	<td title="Mes Cerrado 0 Registros Eliminación">C</td>
                                                <cfelse>
                                                	<td title="-">&loz;</td>
                                                </cfif>    
                                            <cfelse>
                                            	<td title="Mes Abierto">&nbsp;</td>
                                            </cfif>    
                                        </cfif>
                                    </cfloop>
                                    <!---<cfoutput>
                                    	<cfset mescol=mescol+1>
										<!--- Rellenar los meses faltantes --->
                                        <cfloop condition="mescol LT Emes">
											<cfset mescol=mescol+1>
                                            <td align="center" title="0 registros">C</td>
                                        </cfloop>
                                        <td align="center" title="#HTMLEditFormat(Registros)# registros">X</td>
                                    </cfoutput>
                                    <!--- Rellenar los meses faltantes --->
                                    <cfloop condition="mescol LT 12">
                                        <cfset mescol=mescol+1>
                                        <td>&nbsp;</td>
                                    </cfloop>--->
                                </tr>
							<!---</cfoutput>---> 
                        	</cfoutput>
                   		</table>
                    </td>
                </tr>
            </table>                                              
		<cf_web_portlet_end>
	<cf_templatefooter>	
