<cfoutput>
<cfparam name="url.AUTO" default="N">
<cfparam name="url.fecha" default="">
<cfif REFind('^[0-9]{2}/[0-9]{2}/[0-9]{4}$', url.fecha) is 0>
	<cfset url.fecha = DateFormat(Now(), 'DD/MM/YYYY')>
</cfif>
<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
<cfset CodigoAgenda = ComponenteAgenda.MiAgenda() >
<cfset Info = ComponenteAgenda.InfoAgenda(CodigoAgenda)>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Calendario"
Default="Calendario"
returnvariable="LB_Calendario"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Horario"
Default="Horario"
returnvariable="LB_Horario"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Mi_Agenda"
Default="Mi Agenda"
returnvariable="LB_Mi_Agenda"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RecursosHumanos"
Default="Recursos Humanos"
XmlFile="/sif/rh/generales.xml"
returnvariable="LB_RecursosHumanos"/>

<cfif isdefined("URL.AUTO") AND URL.AUTO EQ 'N'>
    <cf_templateheader title="#LB_RecursosHumanos#">
        <cfinclude template="/home/menu/pNavegacion.cfm">
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <script language="javascript1.2" type="text/javascript" src="agenda.js"></script>
                        <table width="100%" border="0" cellpadding="2" cellspacing="0">
                            <tr>
                                <td width="162">&nbsp;</td>
                                <td width="631">&nbsp;</td>
                                <td width="162">&nbsp;</td>
                            </tr>
    
                            <tr>
                                <td valign="top" align="center" width="162">
                                    <table width="162" cellpadding="0" cellspacing="0" align="center">
                                        <tr>
                                            
                                            <td>
                                                <br>
                                                <cf_web_portlet_start skin="portlet" titulo="#LB_Calendario#">
                                                    <cf_calendario value="#LSParseDateTime(url.fecha)#"  fontSize="10" onChange="window.document.getElementById('agenda').src='agenda-form.cfm?fecha='+escape(dmy)" >
                                                <cf_web_portlet_end>
                                                <br>
                                                <cf_web_portlet_start skin="portlet" titulo="#LB_Horario#">
                                                    <table width="100%" cellpadding="6" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                                <table width="20%" cellpadding="0" cellspacing="0">
                                                                    <td width="1%" align="right" valign="middle"><a href="Horario.cfm" target="_top" title="Modificar mi Horario"><img border="0" src="ftv4doc.gif" alt="Modificar mi Horario"></a></td>
                                                                    <td align="left" nowrap valign="middle"><a href="Horario.cfm" target="_top" title="Modificar mi Horario"><strong>Modificar mi Horario</strong></a></td>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                <cf_web_portlet_end>
                                            </td>
                                        </tr>
                                       
                                        <tr><td>&nbsp;</td></tr>
                                        <tr>
                                            <td width="162">
                                                &nbsp;
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <iframe name="agenda" id="agenda" height="450" width="750" frameborder="0" src="agenda-form.cfm?fecha=#url.fecha#" style="margin:0; border:0;"></iframe>
                                </td>
                            </tr>
                        </table>
                        <iframe name="guardar" id="guardar" height="0" width="0" frameborder="0" ></iframe>
                    </td>
                </tr>
            </table>
            <form name="guardaagenda" id="guardaagenda" action="agendaSQL.cfm" method="post" target="guardar" style=" margin:0">
                <input type="hidden" name="txt">
                <input type="hidden" name="citaid">
                <input type="hidden" name="fecha">
                <input type="hidden" name="hora">
                <input type="hidden" name="indice">
                <input type="hidden" name="formulario">
            </form>
    <cf_templatefooter>
<cfelse>
    <cf_web_portlet_start skin="portlet" titulo="#LB_Mi_Agenda#">
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <script language="javascript1.2" type="text/javascript" src="agenda.js"></script>
                <table width="100%" border="0" cellpadding="2" cellspacing="0">
                    <tr>
                        <td width="162">&nbsp;</td>
                        <td width="631">&nbsp;</td>
                        <td width="162">&nbsp;</td>
                    </tr>

                    <tr>
                        <td valign="top" align="center" width="162">
                            <table width="162" cellpadding="0" cellspacing="0" align="center">
                                <tr>
                                    
                                    <td>
                                        <br>
                                        <cf_web_portlet_start skin="portlet" titulo="#LB_Calendario#">
                                            <cf_calendario value="#LSParseDateTime(url.fecha)#"  fontSize="10" onChange="window.document.getElementById('agenda').src='agenda-form.cfm?Auto=S&fecha='+escape(dmy)" >
                                        <cf_web_portlet_end>
                                        <br>
                                    </td>
                                </tr>
                               
                                <tr><td>&nbsp;</td></tr>
                                <tr>
                                    <td width="162">
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td>
                            <iframe name="agenda" id="agenda" height="450" width="750" frameborder="0" src="agenda-form.cfm?Auto=S&fecha=#url.fecha#" style="margin:0; border:0;"></iframe>
                        </td>
                    </tr>
                </table>
                <iframe name="guardar" id="guardar" height="0" width="0" frameborder="0" ></iframe>
            </td>
        </tr>
    </table>
    <cf_web_portlet_end>
    <form name="guardaagenda" id="guardaagenda" action="agendaSQL.cfm" method="post" target="guardar" style=" margin:0">
        <input type="hidden" name="txt">
        <input type="hidden" name="citaid">
        <input type="hidden" name="fecha">
        <input type="hidden" name="hora">
        <input type="hidden" name="indice">
        <input type="hidden" name="formulario">
    </form>
    <script type="text/javascript">
	    function refrescar() {
		opener.document.location.reload();
		}
	</script>
</cfif>
</cfoutput>





