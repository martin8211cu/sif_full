<cf_templateheader title="Conciliación de pagos no referenciados">
    <table width="100%" cellpadding="2" cellspacing="0">
        <tr>
            <td valign="top">
                <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Conciliación de pagos no referenciados'>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr><td><cfinclude template="/sif/portlets/pNavegacionFA.cfm"></td></tr>
                        <cfset conciliaPagos =  createObject("component","crc.cobros.operacion.ConciliacionPagosNRef")>
                        <form style="margin: 0" name="formList" method="post" id="formList" action="ConciliacionPagosNRef_form.cfm">
                            <!--- Tag para loading --->
						    <cf_loadingSIF>
                            <cfset rsGetData = conciliaPagos.obtieneDatosLista(1,0,0)>
                            <input type="hidden" name="Aprobador" id="Aprobador" hidden value="0">
                            <cfinvoke 
                            component="rh.Componentes.pListas"
                            method="pListaQuery"
                            returnvariable="pLista">
                                <cfinvokeargument name="query" value="#rsGetData#"/>
                                <cfinvokeargument name="desplegar" value="PNRFecha, PNRReferencias,Numero, SNnombre, PNRMonto "/>
                                <cfinvokeargument name="etiquetas" value="Fecha, Referencias,Cuenta, Cliente, Monto"/>
                                <cfinvokeargument name="align" value="left, left,left, left, left"/>
                                <cfinvokeargument name="formatos" value="D,S,S,S,M"/>
                                <cfinvokeargument name="ajustar" value=""/>
                                <cfinvokeargument name="checkboxes" value="S"/>
                                <cfinvokeargument name="checkall" value="S"/>
                                <cfinvokeargument name="showLink" value="yes"/>
                                <cfinvokeargument name="formName" value="formList"/>
                                <cfinvokeargument name="irA" value="ConciliacionPagosNRef_form.cfm"/>
                                <cfinvokeargument name="MaxRows" value="20"/>
                                <cfinvokeargument name="keys" value="PNRId"/>
                                <cfinvokeargument name="Botones" value="Nuevo, Aplicar"/>
                            </cfinvoke>
                        </form>
                    </table>
                <cf_web_portlet_end>
            </td>	
        </tr>
    </table>	
<cf_templatefooter>
<script>
    $( document ).ready(function() {
		hideLoading();
	});
    function funcAplicar(){
		if (!ValidaMarcado()){
			alert("Debe seleccionar al menos un registro para aplicar");
			return false;
		}else{
            if (window.confirm("¿Desea aplicar el registro?")) {
                showLoading();
			    document.formList.action= "ConciliacionPagosNRef_sql.cfm";
			    return true;
            }
		}
    }
    function ValidaMarcado() {
        var obj = document.formList.chk;
        if(typeof obj == 'undefined') return false;
        var correcto = false;
        if (obj.length != undefined) {
            for (var i = 0; i < obj.length; i++) {
                if (!obj[i].disabled && obj[i].checked) {
                    correcto = true;
                    break;
                }
            }
        }else{ if (obj.checked )
                    correcto = true;
        }
        return(correcto);
    }
</script>