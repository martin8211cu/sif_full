<!---  Parametros JS REPORTS  --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','SIF - JS Reports')>
<cfset TIT_ReptP	= t.Translate('','Parametros de Configuraci&oacute;n JS Reports')>
<cfset LB_Url		= t.Translate('LB_Url','URL')>
<cfset LB_ExcelId		= t.Translate('LB_ExcelId','Id Excel Template')>
<cfset LB_PDFFacturaId		= t.Translate('LB_PDFFacturaId','Id PDF Template Factura')>
<cfset LB_PDFSimpleId		= t.Translate('LB_PDFSimpleId','Id PDF Template Simple')>
<cfset LB_PDFAgrupadoId		= t.Translate('LB_PDFAgrupadoId','Id PDF Template Agrupado')>
<cfset LB_User		= t.Translate('LB_User','Usuario')>
<cfset LB_Pass		= t.Translate('LB_Pass','Password')>
<cfset LB_Activate_JSREPORTS		= t.Translate('LB_Activate_JSREPORTS','Activar JS REPORTS')>
<cfset BTN_Agregar   = t.Translate('BTN_Agregar','Agregar')>

<cfset modo  = "ALTA">
<cfparam name="URLRep"     default="">
<cfparam name="usuarioRep"     default="">
<cfparam name="passRep"     default="">
<cfparam name="idExcelRep"     default="">
<cfparam name="idPDFFacturaRep"     default="">
<cfparam name="idPDFSimpleRep"     default="">
<cfparam name="idPDFGrouperRep"     default="">
<cfparam name="activateJSREPORTS" default="">

<cfquery name="rsUrl" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20000
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsusr" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20001
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rspass" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20002
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsidexcel" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20003
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsidpdffactura" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20004
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsidpdfsimple" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20005
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsidpdfgrouper" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20006
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20007
	and Ecodigo = #Session.Ecodigo#
</cfquery>

<cfif rsusr.recordCount gt 0>
    <cfset modo = "CAMBIO">

    <cfset URLRep = "#rsUrl.valParam#">
    <cfset usuarioRep = #rsusr.valParam#>
    <cfset passRep = #rspass.valParam#>
    <cfset idExcelRep = #rsidexcel.valParam#>
    <cfset idPDFFacturaRep = #rsidpdffactura.valParam#>
    <cfset idPDFSimpleRep = #rsidpdfsimple.valParam#>
    <cfset idPDFGrouperRep = #rsidpdfgrouper.valParam#>
    <cfset activateJSREPORTS = #rsactivatejsreports.valParam#>
</cfif>

<cf_templateheader title="#LB_TituloH#">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_ReptP#'>

<form name="form1" method="get" action="SQLRegistroJSRepParam.cfm" onsubmit="return validaOption();">
    <table width="100%" cellpadding="2" cellspacing="0">
        <tr>
            <td valign="top">
                <table  width="80%" cellpadding="5" cellspacing="0" border="0">
                    <tr>
                        <td colspan="8">&nbsp;</td>
                    </tr>
                    <tr>
                        <cfoutput>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td align="right"><strong>#LB_Url#:</strong></td>
                        <td>
                        <cfoutput><input name="UrlRep" tabindex="1" type="text" title="Solo Letras y Numeros" value="#URLRep#" size="80" maxlength="100" /></cfoutput>
                        </td>
                        </cfoutput>
                    </tr>
                    <tr>
                        <cfoutput>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td align="right"><strong>#LB_User#:</strong></td>
                        <td>
                        <cfoutput><input name="usuarioRep" tabindex="1" type="text" title="Solo Letras y Numeros" value="#usuarioRep#" size="15" maxlength="15" /></cfoutput>
                        </td>
                        </cfoutput>
                    </tr>
                    <tr>
                        <cfoutput>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td align="right"><strong>#LB_Pass#:</strong></td>
                        <td>
                        <cfoutput><input name="passRep" tabindex="1" type="text" title="Solo Letras y Numeros" value="#passRep#" size="15" maxlength="15" /></cfoutput>
                        </td>
                        </cfoutput>
                    </tr>
                    <tr>
                        <cfoutput>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td align="right"><strong>#LB_ExcelId#:</strong></td>
                        <td>
                        <cfoutput><input name="idExcelRep" tabindex="1" type="text" title="Solo Letras y Numeros" value="#idExcelRep#" size="15" maxlength="15" /></cfoutput>
                        </td>
                        </cfoutput>
                    </tr>
                    <tr>
                        <cfoutput>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td align="right"><strong>#LB_PDFFacturaId#:</strong></td>
                        <td>
                        <cfoutput><input name="idPDFFacturaRep" tabindex="1" type="text" title="Solo Letras y Numeros" value="#idPDFFacturaRep#" size="15" maxlength="15" /></cfoutput>
                        </td>
                        </cfoutput>
                    </tr>
                    <tr>
                        <cfoutput>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td align="right"><strong>#LB_PDFSimpleId#:</strong></td>
                        <td>
                        <cfoutput><input name="idPDFSimpleRep" tabindex="1" type="text" title="Solo Letras y Numeros" value="#idPDFSimpleRep#" size="15" maxlength="15" /></cfoutput>
                        </td>
                        </cfoutput>
                    </tr>
                    <tr>
                        <cfoutput>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td align="right"><strong>#LB_PDFAgrupadoId#:</strong></td>
                        <td>
                        <cfoutput><input name="idPDFGrouperRep" tabindex="1" type="text" title="Solo Letras y Numeros" value="#idPDFGrouperRep#" size="15" maxlength="15" /></cfoutput>
                        </td>
                        </cfoutput>
                    </tr>
                    <tr>
                        <cfoutput>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td align="right"><strong>#LB_Activate_JSREPORTS#:</strong></td>
                        <td>
                        <cfif activateJSREPORTS EQ "1">
                            <cfoutput><input name="activateJSREPORTS" tabindex="1" type="checkbox"
                                checked/></cfoutput>
                        <cfelse>
                            <cfoutput><input name="activateJSREPORTS" tabindex="1" type="checkbox"/></cfoutput>
                        </cfif>
                        </td>
                        </cfoutput>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="6">
                            <div align="center">
                            <cfif modo EQ "ALTA">
                            <cfoutput>
                                <input name="Agregar" class="btnGuardar"  tabindex="1" type="submit" value="#BTN_Agregar#" >
                            </cfoutput>
                            <cfelse>
                                <input name="Modificar" class="btnGuardar"  tabindex="1" type="submit" value="Modificar">
                                <input name="Borrar" class="btnEliminar"  tabindex="1" type="submit" value="Eliminar">
                                <input name="Replicar" class="btnReplicar"  tabindex="1" type="submit" value="Replicar Datos">
                            </cfif>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</form>

<script type = "text/javascript">

    function validaOption(){
        mensa = "";

        if(document.form1.UrlRep.value == ""){
            mensa = "\n- Es necesario indicar el URL";
        }

        if(document.form1.usuarioRep.value == ""){
            mensa =mensa + "\n- Es necesario indicar el Usuario";
        }

        if(document.form1.passRep.value == ""){
            mensa =mensa + "\n- Es necesario indicar el Password";
        }

        if(document.form1.idExcelRep.value == ""){
            mensa =mensa + "\n- Es necesario indicar el id de template de excel";
        }

        if(mensa != ""){
            alert("Se presentaron los siguientes errores: \n" + mensa);
            return false;
        }
    }

</script>


<cf_web_portlet_end>
<cf_templatefooter>