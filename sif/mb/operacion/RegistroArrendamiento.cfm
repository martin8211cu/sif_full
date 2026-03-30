<!--- =============================================================== --->
<!---   Autor:  Rodrigo Rivera                                        --->
<!---   Nombre: Arrendamiento                                         --->
<!---   Fecha:  28/03/2014                                            --->
<!---   Última Modificación: 16/04/2014                               --->
<!--- =============================================================== --->
<!--- =============================================================== --->
<!---                   INICIALIZACION  VARIABLES                     --->
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
<cf_navegacion name="IDArrend"      default=-1>
<cf_navegacion name="Linea"         default="">
<cf_navegacion name="TipoCambio"    default="0">

<cfif Len(Trim(Form.IDArrend)) EQ 0>
    <cfset form.IDArrend=-1>
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfif isdefined("url.urlira")>
    <cfset urlira='url.urlira'>
</cfif>

<!--- =============================================================== --->
<!---                   MANEJO DE MODOS                               --->
<!--- =============================================================== --->
<cfif isDefined("Form.MODO")>
    <cfset modo    = FORM.MODO>
</cfif>

<cfif isDefined("Form.BTNNuevo")>
    <cfset modo = "ALTA">
    <cfset modoDet = "ALTA">
</cfif> 


<!--- ACTUALIZA MODODET  --->
<cfquery name="rsExisteDet" datasource="#Session.DSN#">
    select count(1) as valor
    from DetArrendamiento 
    where Ecodigo     =  #Session.Ecodigo# 
        and IDArrend = <cfqueryparam cfsqltype="cf_sql_char"    value=#Form.IDArrend#>      
</cfquery>

<cfif isdefined("Form.MODODET")>
    <cfset modoDet = FORM.MODODET>
</cfif>

<cfif rsExisteDet.valor EQ "1">
    <cfset modoDet="CAMBIO">
<cfelse>
    <cfset modoDet="ALTA">
</cfif>

<!---   VERIFICA EXISTENCIA DE TABLA     --->
<cfquery name="rsExisteTabla" datasource="#Session.DSN#">
    SELECT      count(1) AS valor
    FROM        TablaAmort        
    WHERE       IDArrend = <cfqueryparam cfsqltype="cf_sql_numeric" value=#Form.IDArrend#>
      AND       Ecodigo = #session.Ecodigo#
</cfquery>
<cfif rsExisteTabla.valor NEQ "0">
    <cfset tabla="YES">
</cfif>
<!--- =============================================================== --->
<!---                   Paso de Parametros                            --->
<!--- =============================================================== --->

<!---►► MANEJO DE LOS ID DE ENCABEZADO Y LINEA, LO ENVIA    ◄◄--->
<cfif not isDefined("Form.NuevoE") and NOT isDefined("Form.btnNuevo") and NOT isdefined('SNNumero')>
    <cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
        <cfset arreglo = ListToArray(Form.datos,"|")>
        <cfset IDArrend = Trim(arreglo[1])>
    <cfelseif IDArrend EQ -1>
        <cflocation url="#URLira#" addtoken="no">
    </cfif> 
</cfif>
<cfif isDefined("Linea") and Len(Trim(Linea)) GT 0 >
    <cfset seleccionado = Linea >
<cfelse>
    <cfset seleccionado = "" >
</cfif>

<cfif modo NEQ 'ALTA'>

</cfif> 
<!doctype html>
<html lang="en">
<head>

  <meta charset="UTF-8">
  <title></title>
</head>
<body>
 <cf_templateheader title="SIF - Bancos">     
    <cfinclude template="/sif/portlets/pNavegacionCP.cfm">           
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#titulo#'>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">

  <form name="form1" id="form1" action="SQLRegistroArrendamiento.cfm" method="POST" >
    <input name="URLira"      id="URLira"     form="form1"  type="hidden" value="<cfoutput>#URLira#</cfoutput>">
    <input name="modo"      id="modo"     form="form1"  type="hidden" value="<cfoutput>#modo#</cfoutput>">
            <!---►►Encabezado◄◄--->
            <tr>
                <td>
                    <cfinclude template="formRegistroArrendamiento.cfm">
                </td>
            </tr>
        </table>
    <cf_web_portlet_end>
<cf_templatefooter>

</form>
  </body>
</html>

<cf_qforms form='form1'>
<script type='text/javascript' src='/cfmx/cfide/scripts/wddx.js'></script>
<script type='text/javascript'>

//////////////////////////////////
// VALIDA CAMPOS DEL FORMULARIO //
//////////////////////////////////
<cfif modo EQ "ALTA">
objForm.Documento.required = true;
objForm.Documento.validateAlphaNumeric("Documento: Solo Letras y Numeros");
objForm.Folio.required=true;
objForm.Folio.validateNumeric("Folio: Solo Numeros");
objForm.SNcodigo.required=true;
objForm.TipoCambio.required=true;
objForm.NombreArrend.required=true;
objForm.URLira.required=true;
<cfelse>
  objForm.FechaInicio.required=true;
  objForm.SaldoInicial.required=true;
  objForm.SaldoInsoluto.required=true;
  objForm.TasaAnual.required=true;
  objForm.FormaPago.required=true;
  objForm.IVA.required=true;
  objForm.TasaMensual.required=true;
  objForm.RentaDiariaNoIVA.required=true;
  objForm.NumMensualidades.required=true;
</cfif>
////////////////////////////////////////////
// QUITA VALIDACIONES PARA BORRAR DETALLE //
////////////////////////////////////////////
function deshabValidacion(){
  objForm.FechaInicio.required=false;
  objForm.SaldoInicial.required=false;
  objForm.SaldoInsoluto.required=false;
  objForm.TasaAnual.required=false;
  objForm.FormaPago.required=false;
  objForm.IVA.required=false;
  objForm.TasaMensual.required=false;
  objForm.RentaDiariaNoIVA.required=false;
  objForm.NumMensualidades.required=false;
}
//////////////////////////////////////////////////////////
// REDIRECCIONA EL FORM PARA CARGAR O EXPORTAR LA TABLA //
//////////////////////////////////////////////////////////
function cargaTabla(){  
  form1.action="ImportarArrendamiento.cfm";
}
function exportaTabla(){  
  form1.action="exportaTabArrendXls.cfm";
}
//////////////////////////////////////////////////////////
// SOLO ACEPTA CAMPOS NUMERICOS Y "." EN CAJAS DE TEXTO //
//////////////////////////////////////////////////////////
function isNumberKey(evt) 
{
   evt = evt || window.event;
   var charCode = (evt.which) ? evt.which : event.keyCode;
   if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57))
    return false;
    return true;
}
/////////////////////////////////////////////////////////////
// SOLO ACEPTA CAMPOS NUMERICOS Y LETRAS EN CAJAS DE TEXTO //
/////////////////////////////////////////////////////////////
function isNumberLetter(evt) 
{
   evt = evt || window.event;
   var charCode = (evt.which) ? evt.which : event.keyCode;
   if (charCode > 31 && (charCode < 48 || charCode > 57) && (charCode < 65 || charCode > 122))
    return false;
    return true;
}
////////////////////////////////////////////
// FUNCION PARA LIMPIAR TODOS LOS FILTROS //
////////////////////////////////////////////
function LimpiarFiltros(f) {
  f.SaldoInicial.value="";
  f.SaldoInsoluto.value="";
  f.TasaAnual.value="";
  f.FormaPago.value="";
  f.IVA.value="";
  f.TasaMensual.value="";
  f.RentaDiariaNoIVA.value="";
  f.NumMensualidades.value="";
}

function calcTasaMen(t){
  document.form1.TasaMensual.value=Math.round((t.value/12)*100)/100;
}
//////////////////////////////////////////////
// AJUSTA EL TIPO DE CAMBIO SEGUN LA MONEDA //
//////////////////////////////////////////////
<cfoutput>
function cambioTC(t){
  if(t.value == #rsMonedaLocal.Mcodigo#){
    document.form1.TipoCambio.value = "1.00";
    document.form1.TipoCambio.readOnly = true;
  }else{
    <cfwddx action="cfml2js" input="#TCsug#" topLevelVariable="rsTCsug"> 
    var nRows = rsTCsug.getRowCount();
    if (nRows > 0) {
      for (row = 0; row < nRows; ++row) {
        if (rsTCsug.getField(row, "Mcodigo") == t.value) {
          document.form1.TipoCambio.value = rsTCsug.getField(row, "TCcompra");
          document.form1.TipoCambio.disabled = false;
          row = nRows;
        }else{
          document.form1.TipoCambio.value = "0.00";         
        }
      }                 
    }else{
      document.form1.TipoCambio.value = "0.00";     
    }
  }
}
</cfoutput>
</script>