<!--- =============================================================== --->
<!---   Autor:  Rodrigo Rivera                                        --->
<!---   Nombre: Arrendamiento                                         --->
<!---   Fecha:  28/03/2014                                            --->
<!--- =============================================================== --->
<!---  Modificado por: Andres Lara                						  --->
<!---	Nombre: Financiamiento                                         --->
<!---	Fecha: 	02/04/2014              	                          --->
<!--- =============================================================== --->
<!---                   Inicializacion  Variables                     --->
<!--- =============================================================== --->


<cf_navegacion name="Fecha">
<cf_navegacion name="datos">
<cf_navegacion name="modo"          default="ALTA">
<cf_navegacion name="modoDet"       default="ALTA">
<cf_navegacion name="Documento"     default="">
<cf_navegacion name="Usuario"       default="">
<cf_navegacion name="Moneda"        default="-1">
<cf_navegacion name="Registros"     default="20">
<cf_navegacion name="pageNum_lista" default="1">
<cf_navegacion name="IDFinan"      default="-1">
<cf_navegacion name="Linea"         default="">
<cf_navegacion name="TipoCambio"    default="0">

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfif isdefined("url.urlira")>
    <cfset urlira='url.urlira'>
</cfif>

<!--- =============================================================== --->
<!---                   Manejo de modos                               --->
<!--- =============================================================== --->
<cfif isDefined("Form.NuevoE")>
    <cfset modo    = "ALTA">
    <cfset modoDet = "ALTA">
</cfif>
<cfif isdefined("Form.Nuevo")>
    <cfset modo = "ALTA">
</cfif>
<cfif isdefined("Form.CAMBIO")>
    <cfset modo = "CAMBIO">
</cfif>
<cfif (isDefined("Form.datos") and Form.datos NEQ "")>
    <cfset modo    = "CAMBIO">
    <cfset modoDet = "ALTA">
</cfif>
<cfif modoDet EQ 'ALTA'>
    <cfset form.linea = "">
    <cfset url.linea  = "">
    <cfset linea      = "">
</cfif>
<!--- =============================================================== --->
<!---                   Paso de Parametros                            --->
<!--- =============================================================== --->
<cfset params = ''>
<cfif isdefined('form.fecha')           and len(trim(form.fecha))><cfset params = params & '&fecha=#form.fecha#' ></cfif>
<cfif isdefined('form.transaccion')     and len(trim(form.transaccion))><cfset params = params & '&transaccion=#form.transaccion#' ></cfif>
<cfif isdefined('form.documento')       and len(trim(form.documento))><cfset params = params & '&documento=#form.documento#' ></cfif>
<cfif isdefined('form.usuario')         and len(trim(form.usuario))><cfset params = params & '&usuario=#form.usuario#' ></cfif>
<cfif isdefined('form.moneda')          and len(trim(form.moneda))><cfset params = params & '&moneda=#form.moneda#' ></cfif>
<cfif isdefined('form.pageNum_lista')   and len(trim(form.pageNum_lista))><cfset params = params & '&pageNum_lista=#form.pageNum_lista#' ></cfif>
<cfif isdefined('form.registros')       and len(trim(form.registros))><cfset params = params & '&registros=#form.registros#' ></cfif>

<!---►►Manejo de los ID de Encabezado y Linea, lo envia ◄◄--->
<cfif not isDefined("Form.NuevoE") and NOT isDefined("Form.btnNuevo") and NOT isdefined('SNNumero')>
    <cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
        <cfset arreglo = ListToArray(Form.datos,"|")>
        <cfset IDFinan = Trim(arreglo[1])>
    <cfelseif IDFinan EQ -1>
        <cflocation url="#URLira#" addtoken="no">
    </cfif>
</cfif>
<cfif isDefined("Linea") and Len(Trim(Linea)) GT 0 >
    <cfset seleccionado = Linea >
<cfelse>
    <cfset seleccionado = "" >
</cfif>

<!---►►Accion de Aplicar ◄◄--->

<!---►►Se obtienen cada una de las lineas ◄◄--->
<cfif modo NEQ 'ALTA'>

</cfif>

<cfset LB_linea = t.Translate('LB_linea','Línea')>
<cfset LB_descripcion = t.Translate('LB_DESCRIPCION','Descripci&oacute;n','/sif/generales.xml')>
<cfset LB_Item = t.Translate('LB_Item','Item')>
<cfset LB_CenFunc = t.Translate('LB_CenFunc','Centro Funcional')>
<cfset LB_Cuenta    = t.Translate('LB_Cuenta','Cuenta','/sif/generales.xml')>
<cfset LB_cantidad = t.Translate('LB_cantidad','Cantidad')>
<cfset LB_Precio = t.Translate('LB_Precio','Precio')>
<cfset LB_Subtotal = t.Translate('LB_Subtotal','Subtotal')>
<cfset LB_OrdenCMLin = t.Translate('LB_OrdenCMLin','OrdenCM-Lin.')>
<cfset LB_Imp = t.Translate('LB_Imp','Imp.')>
<cfset LB_Descuento = t.Translate('LB_Descuento','Descuento')>
<cfset MSG_Borrar = t.Translate('MSG_Borrar','¿Desea borrar esta línea del documento?')>

 <cf_templateheader title="SIF - Bancos">
    <cfinclude template="/sif/portlets/pNavegacionCP.cfm">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#titulo#'>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <!---►►Encabezado◄◄--->
            <tr>
                <td>
                    <cfinclude template="formRegistroFinanciamiento.cfm">
                </td>
            </tr>
            <!---►►Detalle◄◄--->
            <tr>
                <td class="subTitulo">
                  <cfif modo NEQ 'ALTA'>



                  </cfif>
                </td>
            </tr>
        </table>
    <cf_web_portlet_end>
<cf_templatefooter>
<script language="JavaScript1.2">
    function Editar(data) {
        if (data!="" && document.form2.nosubmit.value == "false") {
            document.form2.action=<cfoutput>'#URLira#'</cfoutput>;
            document.form2.datos.value=data;
            document.form2.submit();
        }
        return false;
    }
    //FUNCION PARA BORRAR UN REGISTRO
    <cfoutput>
    function borrar(documento, linea){
        if ( confirm('#MSG_Borrar#') ) {
            document.form2.action            = "SQLRegistroDocumentosCP.cfm";
            document.form2.IDFinan.value = documento;
            document.form2.Linea.value       = linea;
            document.form2.nosubmit.value    = 'true';
            document.form2.submit();
        }else
        document.form2.nosubmit.value = 'false';
    }
    </cfoutput>
</script>