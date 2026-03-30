<cfinvoke key="LB_Nivel" 			default="Nivel"		returnvariable="LB_Nivel"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="LB_SoloCtasDet" 	default="Solo - Cuentas Detalle"		returnvariable="LB_SoloCtasDet"		component="sif.Componentes.Translate" method="Translate" xmlfile="BalCompR.xml"/>
<cfinvoke key="LB_MayorCtasDet" 	default="Mayor - Cuentas Detalle"		returnvariable="LB_MayorCtasDet"		component="sif.Componentes.Translate" method="Translate" xmlfile="BalCompR.xml"/>

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
	where Ecodigo in (Select Ecodigo from AnexoGEmpresaDet where GEid=#gpoElimina.Pvalor#)
	order by Ecodigo
</cfquery>			
<cfif isdefined('url.Empresa') >
	<cfset EmpresaCons = url.Empresa>
<cfelse>
	<cfset EmpresaCons = #rsEmpresas.Ecodigo#>
</cfif>
<cfquery datasource="#Session.DSN#" name="rsNivelDef">
    select ltrim(rtrim(Pvalor)) as valor
    from Parametros 
    where Ecodigo = #Session.Ecodigo# 
    and Pcodigo = 10 
</cfquery>
<cfset nivelDef="#ArrayLen(ListtoArray(rsNivelDef.valor, '-'))#">
<cfset LvarNiveles = nivelDef>
<cfset nivelDef = 1><cfset periodo_actual = ObtenerDato(#EmpresaCons#,30)>
<cfset mes_contable = ObtenerDato(#EmpresaCons#,40)>

	<cf_templateheader title="Eliminaci&oacute;n de operaciones Interempresas">
    <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
    
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Balance de Comprobaci&oacute;n Convertido x Moneda Origen">
			<cfinclude template="../../../sif/portlets/pNavegacionCG.cfm">
            <cfoutput>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td>
						<form name="form1" method="post" action="SQLBalCompConvXMonLO.cfm" style="margin:0;" onSubmit="javascript: return funcValidar(#periodo_actual.Pvalor#,#mes_contable.Pvalor#)">                        
							<table width="100%" cellpadding="2" cellspacing="0">
                               <tr>
                                    <td align="right" nowrap><strong>Empresa:&nbsp;</strong> </td>	
                                    <td>		
                                        <select name="Empresa" id="Empresa" tabindex="1" 
                                        onchange="document.location.href='BalCompConvXMonLO.cfm?Empresa='+this.value;">
                                            <cfloop query="rsEmpresas">
                                                <option value="#rsEmpresas.Ecodigo#"<cfif rsEmpresas.Ecodigo EQ EmpresaCons>selected</cfif>>#rsEmpresas.Edescripcion# </option>
                                            </cfloop>
                                        </select>
                                    </td>	
                                </tr>    
                                <tr>
                                      <td nowrap><div align="right"><cfoutput>#LB_Nivel#</cfoutput>:&nbsp;&nbsp;</div></td>
                                      <td><select name="nivel" size="1" id="nivel"tabindex="3">
                                        <cfloop index="i" from="1" to="#LvarNiveles#">
                                          <option value="<cfoutput>#i#</cfoutput>"<cfif nivelDef EQ i>selected</cfif>><cfoutput>#i#</cfoutput></option>
                                        </cfloop>
                                      </select>
                                      </td>
                                </tr>                        
								<tr>
									<td width="42%" align="right" nowrap="nowrap">Per&iacute;odo:&nbsp;</td>
                                    <td>
                                        <select name="periodo" id=Periodo tabindex="2">
                                            <option value="#periodo_actual.Pvalor#" >#periodo_actual.Pvalor#</option>
                                            <cfloop step="-1" from="#periodo_actual.Pvalor-1#" to="#periodo_actual.Pvalor-3#" index="i"  >
                                                <option value="#i#" >#i#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>  
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
			</table>
			<script language="JavaScript1.2" type="text/javascript">
            function funcValidar(PeriodoC,MesC){
                if ((document.form1.mes.value > MesC) && (document.form1.periodo.value == PeriodoC))
                {
                    alert("La Empresa no ha cerrado para el periodo "+document.form1.periodo.value+" mes "+document.form1.mes.value);
                    return false
                }
                return true
            }	
            </script>
            </cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>	
