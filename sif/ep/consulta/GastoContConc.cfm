<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 08-01-2013.
	Reporte Concentrado Gastos Contables
 --->

<cfinvoke key="CMB_Enero" 			default="Enero" 	returnvariable="CMB_Enero" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"	returnvariable="CMB_Febrero"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 	returnvariable="CMB_Marzo" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"		returnvariable="CMB_Abril"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"		returnvariable="CMB_Mayo"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 	returnvariable="CMB_Junio" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"		returnvariable="CMB_Julio"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 	returnvariable="CMB_Agosto" 	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"	returnvariable="CMB_Setiembre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"	returnvariable="CMB_Octubre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" returnvariable="CMB_Noviembre" 	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"	returnvariable="CMB_Diciembre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mes" 			default="Mes" 		returnvariable="CMB_Mes" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="LB_Nivel" 			default="Nivel"		returnvariable="LB_Nivel"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_Periodo" 		default="Periodo"	returnvariable="MSG_Periodo"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Formato" 		default="Formato"	returnvariable="MSG_Formato"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_TipoImpresion" 	default="Tipo de Impresi&oacute;n "	returnvariable="MSG_TipoImpresion"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_TipoGasto" 	default="Tipo de Gasto "	returnvariable="MSG_TipoGasto"	component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="MSG_Area" 			default="Area de Responsabilidad"				returnvariable="MSG_Area"	 				component="sif.Componentes.Translate"	method="Translate"/>
<cfinvoke key="MSG_Cuenta_Inicial"		default="Cuenta Inicial"					returnvariable="MSG_Cuenta_Inicial"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Cuenta_Final" 		default="Cuenta Final"						returnvariable="MSG_Cuenta_Final"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Consultar" 			default="Consultar"							returnvariable="MSG_Consultar"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Limpiar" 			default="Limpiar"							returnvariable="MSG_Limpiar"				component="sif.Componentes.Translate" method="Translate"/>



<cfinclude template="../../cg/consultas/Funciones.cfm">
<cfset Lvartitulo = 'Concentrado de Gastos Contables'>
<!--- Variables --->
<cfset fnGeneraConsultasBD()>
<cfset periodo="#get_val(30).Pvalor#">
<cfset mes="#get_val(40).Pvalor#">


<cf_templateheader title="#Lvartitulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#Lvartitulo#'>
		<cfinclude template="../../portlets/pNavegacion.cfm">
	
		<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		<form name="form1" method="get" action="GastoContConc_SQL.cfm" style="margin:0; " onsubmit="return sinbotones()">
			<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
			<tr>
                <td nowrap>&nbsp;</td>
                <td nowrap> <div align="right"><cfoutput>#MSG_Area#:</cfoutput>&nbsp;</div></td>
                <td> 
                	<cfquery name="rsArea" datasource="#Session.DSN#">
                        select c.ID_EstrCtaVal, c.EPCPdescripcion  
                        from CGEstrProgVal c
                        inner join CGReEstrProg r
                            on r.ID_Estr=c.ID_Estr
                        where r.SPcodigo='EPCGASTCON'
                    </cfquery>
                    <select name="Area"  tabindex="1">
                    	<option value="T" selected> TODAS </option>
							<cfoutput query="rsArea">
                                <option value="#rsArea.ID_EstrCtaVal#">  #rsArea.EPCPdescripcion# </option>
                            </cfoutput>
       				</select>
                </td>
			</tr>
			<tr> 
			  <td nowrap>&nbsp;</td>
			  <td nowrap width="25%"> <div align="right"><cfoutput>#MSG_Cuenta_Inicial#</cfoutput>:&nbsp;</div></td>
			  <td nowrap width="25%"> 
              	<cfquery name="rsListaCtaI" datasource="#Session.DSN#">
                    select c.CGEPCtaMayor as Cuenta ,m.Cdescripcion as Descripcion
                    from CGEstrProgCtaM c
                    inner join CGReEstrProg r
                    on r.ID_Estr=c.ID_Estr
                    inner join CtasMayor m
                    on c.CGEPCtaMayor = m.Cmayor
                    where r.SPcodigo='EPCGASTCON'
                </cfquery>
                <select name="CmayorI" tabindex="2">
                	<option value=""></option>
					<cfoutput query="rsListaCtaI">
                        <option value="#rsListaCtaI.Cuenta#">#rsListaCtaI.Cuenta# - #rsListaCtaI.Descripcion#</option>
                    </cfoutput>
              	</select>							  
				<!---<cf_sifCuentasMayor form="form1" Cmayor="cmayor_ccuenta1" Cdescripcion="Cdescripcion1" size="60" tabindex="3">--->
			  </td>
              <td nowrap width="5%"><div align="right"><cfoutput>#MSG_Periodo#</cfoutput>:&nbsp;</div></td>
              <td> 
                <select name="periodo" tabindex="3">
                    <cfloop query = "rsPeriodos">
                        <option value="<cfoutput>#rsPeriodos.Speriodo#</cfoutput>" <cfif periodo EQ "#rsPeriodos.Speriodo#"> selected </cfif>> <cfoutput>#rsPeriodos.Speriodo#</cfoutput> </option>
                    </cfloop>
                </select>
              </td>
			</tr>
			<tr> 
			  <td nowrap>&nbsp;</td>
			  <td nowrap width="25%"> <div align="right"><cfoutput>#MSG_Cuenta_Final#:</cfoutput>&nbsp;</div></td>
			  <td nowrap width="25%">
                <select name="CmayorF" tabindex="4">
                	<option value=""></option>                
					<cfoutput query="rsListaCtaI">
                        <option value="#rsListaCtaI.Cuenta#">#rsListaCtaI.Cuenta# - #rsListaCtaI.Descripcion#</option>
                    </cfoutput>
              	</select>							  
				<!---<cf_sifCuentasMayor form="form1" Cmayor="cmayor_ccuenta2" Cdescripcion="Cdescripcion2" size="60" tabindex="5">--->					
			  </td>
              
              <td nowrap width="5%"><div align="right"><cfoutput>#CMB_Mes#</cfoutput>:&nbsp;</div></td>
              <td> 
                <select name="mes" size="1" tabindex="6">
                    <option value="1"  <cfif mes EQ 1>selected</cfif>><cfoutput>#CMB_Enero#</cfoutput></option>
                    <option value="2"  <cfif mes EQ 2>selected</cfif>><cfoutput>#CMB_Febrero#</cfoutput></option>
                    <option value="3"  <cfif mes EQ 3>selected</cfif>><cfoutput>#CMB_Marzo#</cfoutput></option>
                    <option value="4"  <cfif mes EQ 4>selected</cfif>><cfoutput>#CMB_Abril#</cfoutput></option>
                    <option value="5"  <cfif mes EQ 5>selected</cfif>><cfoutput>#CMB_Mayo#</cfoutput></option>
                    <option value="6"  <cfif mes EQ 6>selected</cfif>><cfoutput>#CMB_Junio#</cfoutput></option>
                    <option value="7"  <cfif mes EQ 7>selected</cfif>><cfoutput>#CMB_Julio#</cfoutput></option>
                    <option value="8"  <cfif mes EQ 8>selected</cfif>><cfoutput>#CMB_Agosto#</cfoutput></option>
                    <option value="9"  <cfif mes EQ 9>selected</cfif>><cfoutput>#CMB_Setiembre#</cfoutput></option>
                    <option value="10" <cfif mes EQ 10>selected</cfif>><cfoutput>#CMB_Octubre#</cfoutput></option>
                    <option value="11" <cfif mes EQ 11>selected</cfif>><cfoutput>#CMB_Noviembre#</cfoutput></option>
                    <option value="12" <cfif mes EQ 12>selected</cfif>><cfoutput>#CMB_Diciembre#</cfoutput></option>
                </select>
              </td>
			</tr>
			<tr>
           	<td nowrap>&nbsp;</td>
<!---             
			  	<td align="right" nowrap><div align="right"><cfoutput>#MSG_Formato#</cfoutput>:</div></td>
			  	<td>
                    <select name="formato" tabindex="8">
                        <option value="HTML">HTML</option>
                        <option value="FlashPaper">FlashPaper</option>					
                        <option value="PDF">PDF</option>
                     </select>
			  	</td>
--->                
				<td><div align="right"><cfoutput>#MSG_TipoImpresion#</cfoutput>:</div></td>
                <td>
                    <select name="TipoFormato"  tabindex="9">
                            <option value="1">Resumido</option>
                            <option value="2">Detallado</option>
                    </select>
                </td>
            </tr>
            <tr>  
            	<td nowrap>&nbsp;</td>  
                <td><div align="right"><cfoutput>#MSG_TipoGasto#</cfoutput>:</div></td>
                <td>
                	<cfquery name="rsTipoGasto" datasource="#Session.DSN#">
                        select distinct cc.PCCDclaid, cd.PCCDvalor, cd.PCCDdescripcion from PCECatalogo e
                        inner join PCDCatalogoCuenta c on e.PCEcatid = c.PCEcatid
                        inner join PCDClasificacionCatalogo cc on c.PCDcatid = cc.PCDcatid
                        inner join PCClasificacionD cd on cd.PCCEclaid = cc.PCCEclaid and cc.PCCDclaid = cd.PCCDclaid
                        where c.PCEcatid = (
                        select ep.PCEcatidClasificado from CGEstrProg ep
                                inner join CGReEstrProg r
                                on ep.ID_Estr= r.ID_Estr
                                    where r.SPcodigo=<!---'EPCGASTCON'---> '#session.menues.SPCODIGO#')                	
            		</cfquery>
                    <select name="TGasto" tabindex="4">
                        <option value="T" selected> TODOS </option>                
                        <cfoutput query="rsTipoGasto">
                            <option value="#rsTipoGasto.PCCDclaid#">#rsTipoGasto.PCCDvalor# - #rsTipoGasto.PCCDdescripcion#</option>
                        </cfoutput>
                    </select>							  
				</td>
			</tr>				
			<tr> 
                <td colspan="5"> 
                    <div align="center"> 
                    <cfoutput>
                      <input type="submit" name="Submit"  value="#MSG_Consultar#" tabindex="10" class="btnNormal">&nbsp;
                      <input type="Reset"  name="Limpiar" value="#MSG_Limpiar#"   tabindex="11" class="btnLimpiar">
                    </cfoutput>  
                    </div>
                </td>
			</tr>
			</table>
		</form>
        <cf_qforms form="form1">
            <cf_qformsRequiredField name="periodo" 	 description="Periodo">
		</cf_qforms>
		<script language="javascript1.2" type="text/javascript">
			function fnValidarMovMes(valor){
				if(valor == -4){
					document.form1.CHKMensual.checked = false;
					document.form1.CHKMensual.disabled  = true;
				}
				else{
					document.form1.CHKMensual.disabled = false;
				}
				
			}
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>

<cffunction name="fnGeneraConsultasBD" access="private" output="no" returntype="any">
	<!--- consultas --->
	<cfquery datasource="#Session.DSN#" name="rsNivelDef">
		select ltrim(rtrim(Pvalor)) as valor
		from Parametros 
		where Ecodigo = #Session.Ecodigo# 
		and Pcodigo = 10 
	</cfquery>
	
	<cfquery name="rsPeriodos" datasource="#Session.DSN#">
		select distinct Speriodo
		from CGPeriodosProcesados
		where Ecodigo = #session.Ecodigo#
		order by Speriodo desc
	</cfquery>
    
	<cfquery name="rsParam" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		and Pcodigo = 660
	</cfquery>
</cffunction>
