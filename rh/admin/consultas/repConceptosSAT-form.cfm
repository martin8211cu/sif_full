<!--- Modified with Notepad --->
<cfinvoke key="MSG_ConceptoSAT" default="Concepto SAT" returnvariable="MSG_ConceptoSAT" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_TIPO"
Default="Tipo"
XmlFile="/rh/generales.xml"
returnvariable="LB_TIPO"/>

<cfoutput>
<form name="form1" method="get" action="repConceptosSAT-rep.cfm" style="margin:0;">
	<table cellpadding="2" cellspacing="0" border="0" align="center">
    	<tr>
            <td width="40%" valign="top">
                <table width="100%">
                    <tr>
                        <td valign="top">
                            <cf_web_portlet_start border="true" titulo="#MSG_ConceptoSAT#" skin="info1">
                                <div align="justify">
                                    <p>
                                    <cf_translate key="AYUDA_ConceptoSAT">
                                    Reporte de relaci&oacute;n de Conceptos SAT-Conceptos N&oacute;mina
                                    </cf_translate></p>
                                </div>
                            <cf_web_portlet_end>
                        </td>
                    </tr>
                </table>  
            </td>
            <td valign="top">
                <table width="100%" cellpadding="2" cellspacing="2" align="center">
        		<tr>
                    <td align="left" class="fileLabel"><strong>#MSG_ConceptoSAT#:</strong></td>
                    <td> 
                        <cfquery name="rsConceptoSAT" datasource="#session.DSN#">
                            select RHCSATid,RHCSATcodigo,RHCSATdescripcion from dbo.RHCFDIConceptoSAT
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                            order by RHCSATcodigo,RHCSATtipo
                        </cfquery>
                        <select name="ConceptoSAT" id="ConceptoSAT">
                            <option value=0>-<cf_translate key="LB_seleccionar" xmlfile="/rh/generales.xml">Todos</cf_translate> -</option>
                            <cfloop query="rsConceptoSAT">
                                <option value="#rsConceptoSAT.RHCSATid#">#rsConceptoSAT.RHCSATcodigo# #rsConceptoSAT.RHCSATdescripcion#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td align="right"><strong>#LB_TIPO#&nbsp;:&nbsp;</strong></td>
                    <td>                       
                    	 <select name="TipoConceptoSAT" id="TipoConceptoSAT">
                            <option value="X">-<cf_translate key="LB_seleccionar" xmlfile="/rh/generales.xml">Todos</cf_translate> -</option>
                            <option value="D">-<cf_translate key="LB_deduccion" xmlfile="/rh/generales.xml">Deducción</cf_translate> -</option>
                            <option value="P">-<cf_translate key="LB_percepcion" xmlfile="/rh/generales.xml">Percepcion</cf_translate> -</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td align="right"><strong><cf_translate key="LB_Formato">Formato</cf_translate>:&nbsp;</strong></td>
                    <td>
                        <select name="formato">
                            <option value="flashpaper"><cf_translate key="CMB_Flashpaper">Flashpaper</cf_translate></option>
                            <option value="pdf"><cf_translate key="CMB_PDF">PDF</cf_translate></option>
                            <option value="excel"><cf_translate key="CMB_Excel">Excel</cf_translate></option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td nowrap align="center" colspan="2">
                        <cfinvoke component="sif.Componentes.Translate"
                        method="Translate"
                        Key="BTN_Consultar"
                        Default="Consultar"
                        XmlFile="/rh/generales.xml"
                        returnvariable="BTN_Consultar"/>	
                
                        <cfinvoke component="sif.Componentes.Translate"
                        method="Translate"
                        Key="BTN_Limpiar"
                        Default="Limpiar"
                        XmlFile="/rh/generales.xml"
                        returnvariable="BTN_Limpiar"/>		
                        <input type="submit" name="btnFiltrar" id="btnFiltrar" value="#BTN_Consultar#">
                        <input type="reset" name="btnLimpiar" id="btnLimpiar" value="#BTN_Limpiar#">
                    </td>
                 </tr>
        		 </table>
        	</td>
     	</tr>
	</table>
</form>
</cfoutput>
