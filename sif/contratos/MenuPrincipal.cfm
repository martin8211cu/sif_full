<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Contratos"
    returnvariable="LB_Titulo" xmlfile="MenuPrincipal.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo1" default="Men&uacute; Principal de Contratos"
    returnvariable="LB_Titulo1" xmlfile="MenuPrincipal.xml"/>
<cf_templateheader title="SIF - #LB_Titulo#">
	<cfinclude template="../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_titulo1#">
        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
             <tr>
                <td  rowspan="2" valign="top"  width="20%" >
                    <cf_menu sscodigo="SIF" smcodigo="CONTRA">
                </td>
             </tr>
        </table>
	<cf_web_portlet_end>
<cf_templatefooter>