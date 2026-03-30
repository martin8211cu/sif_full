<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: Arrendamiento                                           --->
<!--- Fecha:  28/03/2014                                              --->
<!--- Última Modificación: 16/04/2014                                 --->
<!--- =============================================================== --->
<cfprocessingdirective pageencoding="utf-8"/>
<cfparam name="modo"          default="ALTA">
<cfparam name="Folio"         default="">
<cfparam name="Fecha"         default="">
<cfparam name="FechaInicio"   default="">
<cfparam name="SaldoInicial"  default="">
<cfparam name="SaldoInsoluto" default="">
<cfparam name="TasaAnual"     default="">
<cfparam name="IVA"           default="">
<cfparam name="FormaPago"     default="0">
<cfparam name="TasaMensual"   default="">
<cfparam name="RentaDiaria"   default=""> 
<cfparam name="NumMensualidades" default="">
<cfparam name="Documento"     default="">
<cfparam name="readonly"      default="">
<cfparam name="caja"          default="">
<cfparam name="cajadet"          default="">
<cfparam name="readonlyDet"   default="">
<cfparam name="tabla"         default="NO">
<cfparam name="ModoUlt"       default="NO">

<cfif len(trim(Fecha)) EQ 0>
  <cfset Fecha= "#dateformat(now())#">
</cfif>
<cfif isdefined("URL.ModoULt")>
  <cfset modoult = #URL.ModoUlt#>
</cfif>

<!--- TRANSLATE --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SocioNegocios" default="Socio de Negocios:" returnvariable="LB_SocioNegocios" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CodDocto" default="Codigo de Documento" returnvariable="LB_CodDocto" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SocioNegocios" default="Socio de Negocios:" returnvariable="LB_SocioNegocios" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DefArrend" default="Definición del Arrendamiento" returnvariable="LB_DefArrend" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_EncDocto" default="Encabezado del Documento" returnvariable="LB_EncDocto" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" returnvariable="LB_Documento" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Folio" default="Folio" returnvariable="LB_Folio" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tipo_De_Cambio" default="Tipo de cambio:" returnvariable="LB_Tipo_De_Cambio" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Agregar" default="Agregar" returnvariable="BTN_Agregar" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Regresar" default="Regresar" returnvariable="BTN_Regresar" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Saldo_Inicial" default="Saldo Inicial: " returnvariable="LB_Saldo_Inicial" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tasa_Anual" default="Tasa Anual %: " returnvariable="LB_Tasa_Anual" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Forma_de_Pago" default="Forma de Pago: " returnvariable="LB_Forma_de_Pago" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tasa_Mensual" default="Tasa Mensual %: " returnvariable="LB_Tasa_Mensual" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Renta_Diaria_No_IVA" default="Renta Diaria sin IVA: " returnvariable="LB_Renta_Diaria_No_IVA" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Importar" default="Carga de Arrendamiento" returnvariable="BTN_Importar" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Saldo_Insoluto" default="Saldo Insoluto: " returnvariable="LB_Saldo_Insoluto" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Num_Mensualidades" default="Número de Pagos: " returnvariable="LB_Num_Mensualidades" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_AgregarD" default="Agregar" returnvariable="BTN_AgregarD" xmlfile="Arrendamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_ModificarD" default="Modificar" returnvariable="BTN_ModificarD" xmlfile="Arrendamiento.xml"/>
<cfset LB_Letras_Numeros= t.translate('LB_Letras_Numeros','Solo letras y números','Arrendamiento.xml')>
<cfset LB_Numeros= t.translate('LB_Numeros','Solo números','Arrendamiento.xml')>
<cfset BTN_Calcular_Arrendamiento= t.translate('BTN_Calcular_Arrendamiento','Calcular Arrendamiento','Arrendamiento.xml')>
<cfset LB_Tabla_Amort= t.translate('LB_Tabla_Amort','Tabla de Amortización','Arrendamiento.xml')>
<cfset BTN_Borr_Det= t.Translate('BTN_Borr_Det','Borrar Detalle','Arrendamiento.xml')>
<cfset BTN_Borr_Arrend= t.Translate('BTN_Borr_Arrend','Borrar Arrendamiento','Arrendamiento.xml')>
<cfset LB_btnLimpiar= t.Translate('LB_btnLimpiar','Limpiar','/sif/generales.xml')>
<cfset LB_BTN_Regresar= t.Translate('LB_BTN_Regresar','Regresar','Arrendamiento.xml')>
<cfset LB_Fecha_Inicio= t.Translate('LB_Fecha_Inicio','Fecha Inicio: ','Arrendamiento.xml')>
<cfset LB_Observaciones= t.Translate('LB_Observaciones','Observaciones:','Arrendamiento.xml')>
<cfset BTN_Cobro= t.Translate('BTN_Cobro','Registro de Intereses','Arrendamiento.xml')>
<!--- mes auxiliar --->
<cfquery name="mes" datasource="#session.DSN#">
    select Pvalor
    from Parametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and Pcodigo = 60
</cfquery>
<!--- periodo auxiliar --->
<cfquery name="periodo" datasource="#session.DSN#">
    select Pvalor
    from Parametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and Pcodigo = 50
</cfquery>
<!---   TRAE MONEDA LOCAL  --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
  SELECT    Mcodigo 
  FROM      Empresas
  WHERE     Ecodigo = #Session.Ecodigo#
</cfquery>

<!---   TRAE TIPO DE CAMBIO SUGERIDO   --->
<cfquery name="TCsug" datasource="#Session.DSN#">
  SELECT    tc.Mcodigo, tc.TCcompra as TCcompra, tc.TCventa AS TCventa
  FROM      Htipocambio tc
  WHERE     tc.Ecodigo = #Session.Ecodigo#
    AND     tc.Hfecha <= getdate()
    AND     tc.Hfechah > getdate()
</cfquery>

<!---   TRAE ARRENDAMIENTOS  --->
<cfquery name="rsArrendamientos" datasource="#Session.DSN#">
  SELECT    IDCatArrend, ArrendNombre, SNcodigo
  FROM      CatalogoArrend
  WHERE     Ecodigo = #Session.Ecodigo#
</cfquery>

<cfif modo NEQ "ALTA">
  <!--- TRAE ENCABEZADO SI EL MODO NO ES ALTA --->
  <cfquery name="rsDocumento" datasource="#Session.DSN#">
    SELECT    IDArrend, Ecodigo, SNcodigo, Documento, Folio, Mcodigo, TipoCambio, Observaciones, IDCatArrend, ArrendNombre, Fecha
      FROM    EncArrendamiento
     WHERE    IDArrend = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#IDArrend#">
       AND    Ecodigo = #Session.Ecodigo#
  </cfquery>

  <!---   TRAE CUENTAS   --->
  <cfquery name="rsCuentas" datasource="#Session.DSN#">
    SELECT    b.Cformato, b.Cmayor, b.Cdescripcion, b.Ccuenta AS CcuentaIDif, c.Cformato, c.Cmayor, c.Cdescripcion, c.Ccuenta AS CcuentaIGan, cfigan.CFcuenta as CFcuentaIGan, cfidif.CFcuenta as CFcuentaIDif
      FROM    CatalogoArrend a INNER JOIN CContables b ON a.CcuentaIDif = b.Ccuenta AND a.Ecodigo = b.Ecodigo
              INNER JOIN CContables c ON a.CcuentaIGan = c.Ccuenta AND a.Ecodigo = b.Ecodigo
              INNER JOIN CFinanciera cfigan ON cfigan.Ccuenta = a.CcuentaIGan AND a.Ecodigo = cfigan.Ecodigo
              INNER JOIN CFinanciera cfidif ON cfidif.Ccuenta = a.CcuentaIDif AND a.Ecodigo = cfidif.Ecodigo
     WHERE    a.Ecodigo = #Session.Ecodigo#
       AND    a.IDCatArrend = #rsDocumento.IDCatArrend#
  </cfquery>

  <!---   TRAE CUENTA IVA  --->
  <cfquery name="rsCuentaIVA" datasource="#Session.DSN#">
    SELECT    b.Cformato AS CformatoI, b.Cmayor as CmayorI, b.Cdescripcion as CdescripcionI, b.Ccuenta as CcuentaI
      FROM    Conceptos a INNER JOIN CContables b
              ON a.Cformato = b.Cformato and a.Ecodigo = b.Ecodigo
     WHERE    a.Ecodigo = #Session.Ecodigo#
       AND    a.Ccodigo = '132'
  </cfquery>

  <!---   TRAE SOCIO DE NEGOCIOS   --->
  <cfquery name="rsNombreSocio" datasource="#Session.DSN#">
    SELECT    SNid, SNcodigo, SNidentificacion, SNnombre, SNcuentacxc, Cdescripcion, Cmayor
    FROM      SNegocios a LEFT OUTER JOIN CContables b
                ON a.Ecodigo = b.Ecodigo  AND a.SNcuentacxc = b.Ccuenta
    WHERE     a.Ecodigo = #Session.Ecodigo#
      AND     SNcodigo = #rsDocumento.SNcodigo#
  </cfquery>

  <!---   VARIABLES DEL ENCABEZADO   --->
  <cfset LvarSNid =     rsNombreSocio.SNid>
  <cfset Documento=     rsDocumento.Documento>
  <cfset Folio=         rsDocumento.Folio>
  <cfset Fecha=         rsDocumento.Fecha>
  <cfset Moneda=        rsDocumento.Mcodigo>
  <cfset SocioNegocio=  rsDocumento.SNcodigo>
  <cfset TipoCambio=    rsDocumento.TipoCambio>
  <cfset caja=          "class='cajasinborde'">
  <cfset readonly=      "readonly">
</cfif>

<!---   CSS ENCABEZADO   --->
<style type="text/css">
  input{text-align: right;}
  select{text-align: right;}
  .sn{text-align: left;}
  .btn{text-align: center; width: 300px;}
  .tdsized{width: 105px;}
  .tdsizedbtn{width: 303px;}
  .tdspace{width: 490px;}
</style>

<!--- ======================================================================= --->
<!---                            Tabla Encabezado                             --->
<!--- ======================================================================= --->
<!------------- FORM ------------------->
<table width="100%" border="0" cellpadding="2" cellspacing="0">
  <tr>
    <td colspan="8" class="tituloAlterno">
      <div align="center">
        <cfoutput><strong>#LB_EncDocto#</strong></cfoutput>
      </div>
    </td>
  </tr>
  <!---►► DOCUMENTO  ◄◄--->
  <tr>
    <td width="8%">
      <div align="right">
        <cfoutput><strong>#LB_Documento#:&nbsp;</strong></cfoutput>
      </div>
    </td>
    <td width="30%">
    <cfoutput>
      <input name="Documento" id="Documento" value="#Documento#" title="#LB_Letras_Numeros#" tabindex="1" type="text" size="30" maxlength="20" #caja# #readonly# onkeypress=" return isNumberLetter(event);" >
    </td>
      <!---►► FOLIO  ◄◄--->
    <td align="center" width="5%">
      <strong>#Lb_Folio#:</strong></td>
      <td width="15%"><input name="Folio" id="Folio" value="#Folio#" title="#LB_Numeros#" tabindex="1" type="text" size="10" maxlength="20" align="right" #caja# #readonly# onkeypress="return isNumberKey(event);">
    </cfoutput> 
    </td>
    <!--- FECHA  --->
    <td nowrap><strong><cfoutput>#LB_Fecha#: </cfoutput></strong></td>
    <td>
      <cf_sifcalendario name="Fecha" id="Fecha" value=#dateformat(fecha,'dd/mm/yyyy')# tabindex="3" readOnly >
    </td>
    <!---►► MONEDA ◄◄--->
    <td>
      <div align="right"><cfoutput><strong>#LB_Moneda#:&nbsp;</strong></cfoutput>
      </div>
    </td>
    <td>
      <cfquery name="rsMonedas" datasource="#session.DSN#">
        SELECT     Mcodigo, Mnombre
        FROM       Monedas
        WHERE      Ecodigo = #Session.Ecodigo#
        </cfquery>
      <cfif modo NEQ "ALTA">
        <cfquery name="rsMonedas" datasource="#session.DSN#">
          SELECT     Mcodigo, Mnombre
          FROM       Monedas
          WHERE      Ecodigo = #Session.Ecodigo#
            AND      Mcodigo = #rsDocumento.Mcodigo#
        </cfquery>
        <select id="Mcodigo" name="Mcodigo" >
          <cfoutput><option value="#rsMonedas.Mcodigo#" selected class="cajasinborde">#rsMonedas.Mnombre#</option></cfoutput>
        </select>
      <cfelse> 
        <select id="Mcodigo" name="Mcodigo" tabindex="1" onchange="cambioTC(this);">
          <option value=""></option>
          <cfloop query="rsMonedas">
            <cfoutput><option value="#rsMonedas.Mcodigo#" >#rsMonedas.Mnombre#</option></cfoutput>
          </cfloop>
        </select>
      </cfif> 
    </td> 
  </tr>
  <!---►► SOCIO DE NEGOCIOS  ◄◄--->
  <tr>
    <td nowrap="nowrap">
      <div align="right"><cfoutput><strong>#LB_SocioNegocios#&nbsp;</strong></cfoutput></div>
    </td>
    <td  align="left" colspan="2" width="5%">
    <cfoutput>
      <cfif modo NEQ "ALTA">
        <input name="SNnombre" type="text" readonly class="cajasinborde sn" tabindex="-1" value="#rsNombreSocio.SNnombre#" size="45" maxlength="25">
        <input type="hidden" name="SNcodigo" value="#rsDocumento.SNcodigo#">
        <input type="hidden" name="SNid" value="#rsNombreSocio.SNid#">
      <cfelse>
        <cfif isdefined('form.SNnumero') and LEN(trim(form.SNnumero))>
          <cf_sifsociosnegocios2 tabindex="1" size="25" idquery="#rsSociosN.SNcodigo#">
        <cfelse>
          <cf_sifsociosnegocios2 tabindex="1" size="25" frame="frame1">
        </cfif>
      </cfif>
    </cfoutput>
    </td>
    <td></td>
    <td></td>
    <td></td>
   <!---►►  TIPO DE CAMBIO  ◄◄--->            
    <td nowrap="nowrap"><div align="right"><cfoutput><strong>#LB_Tipo_de_Cambio#&nbsp;</strong></div></td>
    <td>
      <cfif modo NEQ 'ALTA'>
      <cf_monto name="TipoCambio" value="#TipoCambio#" modificable="false" tabindex="1" decimales="4" size="11" class="cajasinborde">
      <cfelse>
        <input name="TipoCambio" id="TipoCambio" style="width: 80px;" readonly>
      </cfif>
    </td></cfoutput>
  </tr>
  <tr>
  <cfoutput>
  <!---   OBSERVACIONES  --->
    <td><strong><div align="right">#LB_Observaciones#&nbsp;</strong></div></td>
    <td>
      <textarea cols="30" rows="3" name="Observaciones" tabindex="1" #caja# #readonly#><cfif modo NEQ "ALTA">#rsDocumento.Observaciones#</cfif></textarea>
    </td>
    <!---   NOMBRE ARRENDAMIENTO   --->
    <td colspan="4">
      <div align="center">
      <cfif modo EQ "ALTA">
        <strong>&nbsp;Nombre&nbsp;Arrendamiento:&nbsp;</strong>
        <select type="text" name="NombreArrend" id="NombreArrend" tabindex="1" onfocus="options(this);">
        <option value="">Seleccionar Arrendamiento</option>
      </select>
      <cfelse>
        <input type="hidden" name="NombreArrend" id="NombreArrend" style="text-align:center;" value="#rsDocumento.IDCatArrend#" #caja# #readonly#>
        <input type="text" name="NombreA" id="NombreA" style="text-align:center;" value="#rsDocumento.ArrendNombre#" #caja# #readonly#>
      </cfif>
      </div>
    </td>
  </tr>
  </cfoutput>
  <tr>
    <td><br></td>
  </tr>
  <tr>
    <td colspan="8"><div align="center"></div>
      <cfif modo EQ "ALTA">
      <cfoutput>  
        <div align="center">
          <input name="AgregarE" class="btnGuardar"  tabindex="1" type="submit" value="#BTN_Agregar#" >
          <input name="Regresar" class="btnAnterior" tabindex="1" type="button" value="#BTN_Regresar#" onclick="window.location='Arrendamiento.cfm'" />
        </div>
      </cfoutput>  
      </cfif>
    </td>
  </tr>
</table>

<cfif modoDet NEQ "ALTA">
<!--- TRAE DETALLE SI EL MODODET NO ES ALTA --->
  <cfquery name="rsLinea" datasource="#Session.DSN#">
    SELECT    IDArrend, Ecodigo, FechaInicio, SaldoInicial, SaldoInsoluto, TasaAnual, IVA, FormaPago, TasaMensual, RentaDiaria, NumMensualidades, DetEstado, BMUsucodigo
      FROM    DetArrendamiento         
     WHERE    IDArrend = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDArrend#">
       AND    Ecodigo = #session.Ecodigo#
  </cfquery>
  <cfquery name="rsSaldoIns" datasource="#session.dsn#">
    SELECT    MIN(SaldoInsoluto) as SaldoInsoluto
      FROM    TablaAmort 
     WHERE    Estado = 1
       AND    Ecodigo = #Session.Ecodigo# AND IDArrend = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDArrend#">
  </cfquery>
  <!---   VARIABLES DEL DETALLE  --->
  <cfset FechaInicio=     rsLinea.FechaInicio>
  <cfset SaldoInicial=    "#NumberFormat(rslinea.SaldoInicial,"0,000.00")#">
  <cfif rsSaldoIns.saldoinsoluto NEQ ''>
    <cfset SaldoInsoluto=   "#lsNumberFormat(rsSaldoIns.saldoinsoluto,"9,999.99")#">
  <cfelse>
    <cfset SaldoInsoluto=   "#lsNumberFormat(rslinea.SaldoInsoluto,"9,999.99")#">
  </cfif>
  <cfset TasaAnual=       "#lsNumberFormat(rslinea.TasaAnual,"9.99")#">
  <cfset IVA=             "#lsNumberFormat(rslinea.IVA,"9.99")#">
  <cfset FormaPago=       "#lsNumberFormat(rslinea.FormaPago)#">
  <cfset TasaMensual=     "#lsNumberFormat(rslinea.TasaMensual,"9.9999")#">
  <cfset RentaDiaria=     "#lsNumberFormat(rslinea.RentaDiaria,"9,999.99")#"> 
  <cfset NumMensualidades="#lsNumberFormat(rslinea.NumMensualidades)#">
</cfif>

<!---   CSS DEL DETALLE  --->
<style type="text/css">
  .btnPublicar{background-color: #FFFFFF; font-weight: normal; }
  .btnSize{width: 250px;}
  .cajareadonly[readonly], cajareadonly[readonly="readonly"]{background-color: #F5F5F5; padding: 3px; border: 0px;}
  .tablaCuentas{border:1px solid #c8c8c8;}
</style>

<!--- ======================================================================= --->
<!---                              TABLA DETALLE                              --->
<!--- ======================================================================= --->
<cfif modo NEQ "ALTA">
  <cfif tabla EQ "YES">
    <cfset readonlyDet="readonly">
    <cfset cajadet ="class='cajasinborde'">
  </cfif>
  <cfoutput><input style="display:none" name="IDArrend" value=#IDArrend#></cfoutput>
  <table style="width:100%" border="0" cellpadding="1" cellspacing="1">
    <tr>
      <td style="width:100%" colspan="9" class="tituloAlterno">
        <div align="center"><cfoutput><strong>#LB_DefArrend#</strong></cfoutput></div>
      </td>
    </tr>
    <!---  FECHA INICIO  --->
    <tr>
      <div align="right">
        <cfoutput>
        <td><strong>&nbsp;#LB_Fecha_Inicio#</strong></td>
        <td class="tdsized">
          <cfif modoDet NEQ "ALTA">
            <cf_sifcalendario name="FechaInicio" id="FechaInicio" value="#LSDateFormat(FechaInicio,'dd/mm/yyyy')#" tabindex="1" readonly>
          <cfelse>
            <cf_sifcalendario name="FechaInicio" id="FechaInicio" value="" tabindex="1" >
          </cfif>
          <td class="tdspace">&nbsp;&nbsp;&nbsp;</td>
          <td align="center" class="tdsizedbtn">
          <cfif modoDet NEQ "ALTA" && tabla NEQ "YES">
            <input type="submit" tabindex="2" name="Importar" value="#BTN_Importar#" class="btnGuardar btnSize" onclick='cargaTabla();'>
          </cfif>
          </td>
        </td>
        </cfoutput>
      </div>
    </tr>
    <!--- SALDO INICIAL --->
    <tr>
      <div align="right">
        <cfoutput>
        <td><strong>&nbsp;#LB_Saldo_Inicial#</strong></td>
        <td class="tdsizedbtn">
          <input name="SaldoInicial" id="SaldoInicial" tabindex="1" type="text" value="#SaldoInicial#" onkeypress="return isNumberKey(event);" style="width:145px" #readonlyDet# #cajadet#>
        </td>
        <td>&nbsp;&nbsp;&nbsp;</td>
        <td align="center">
        <cfif modoDet NEQ "ALTA" && tabla NEQ "YES">
          <input type="submit" tabindex="2" name="CalcularTab" value="#BTN_Calcular_Arrendamiento#" class="btnPublicar btnSize" >
        </cfif>
        </td>
        </cfoutput>
      </div>
    </tr>
    <!--- SALDO INSOLUTO --->
    <tr>
      <div align="right">
        <cfoutput>
        <td><strong>&nbsp;#LB_Saldo_Insoluto#</strong></td>
        <td class="tdsized"><input name="SaldoInsoluto" tabindex="1" type="text" value="#SaldoInsoluto#" onkeypress=" return isNumberKey(event);" style="width:145px" #readonlyDet# #cajadet#>
        </td>
        </cfoutput>
      </div>
    </tr>
    <!---   TASA ANUAL   --->
    <tr>
      <div align="right">
        <cfoutput>
        <td><strong>&nbsp;#LB_Tasa_Anual#</strong></td><td class="tdsized">
          <input type="text" name="TasaAnual" id="TasaAnual" tabindex="1" value="#TasaAnual#" style="width:145px" onChange="calcTasaMen(this);" onkeypress=" return isNumberKey(event);" #readonlyDet# #cajadet#>
        </td>
        </cfoutput>
      </div>
    </tr>
    <!---   FORMA DE PAGO  --->
    <tr>
      <div align="right" >
        <td ><cfoutput><strong>&nbsp;#LB_Forma_de_pago#</strong></td>
          <td class="tdsized" >
          <select  name="FormaPago" id="FormaPago" tabindex="1" style="width:149px" #readonlyDet# #cajadet#>
          <option value="" <cfif (FormaPago NEQ 0)>disabled</cfif>></option>
          <option value="1" <cfif (FormaPago EQ 1)>selected</cfif>>Mensual</option>
          </select>
        </td>
      <cfif tabla EQ "YES" && rsLinea.DetEstado EQ 2>
        <td colspan="2" rowspan="4">
        <table style="width:100%" border="0" cellpadding="1" cellspacing="1" class="tablaCuentas">
          <tr><td nowrap class="tituloAlterno" colspan="3" align="left"><strong>&nbsp;&nbsp;&nbsp;Cuentas </strong></td>
          </tr>
          <tr>
            <td nowrap><strong>&nbsp;&nbsp;&nbsp;Ingreso Diferido: </strong></td>
            <td style="width:60%"><cf_cuentas tabindex="2" Conexion="#Session.DSN#" query="#rsCuentas#" Conlis="S" auxiliares="N" movimiento="S" 
                  Ccuenta="CcuentaIDif" Cmayor="CmayorIDif" Cdescripcion="CdescripcionIDif" cformato="CformatoIDif" CFcuenta="CFcuentaIDif" igualTabFormato="S" descwidth="34"></td>
            <td nowrap style="width:100%"><input type="checkbox" name="habCuentas" id="habCuentas" onclick="changeAcc();">&nbsp;Modificar&nbsp;Cuentas</td>
          </tr>
          <tr>
            <td nowrap><strong>&nbsp;&nbsp;&nbsp;Intereses Ganados: </strong></td>
            <td style="width:60%"><cf_cuentas tabindex="2" Conexion="#Session.DSN#" query="#rsCuentas#" Conlis="S" auxiliares="N" movimiento="S" 
                  Ccuenta="CcuentaIGan" Cmayor="CmayorIGan" Cdescripcion="CdescripcionIGan" cformato="CformatoIGan" CFcuenta="CFcuentaIGan" igualTabFormato="S" descwidth="34"></td>
          </tr>
        </table>
        
          <script type="text/javascript">
          function lockAcc(){
              document.getElementById('CmayorIDif').readOnly     = true;
              document.getElementById('CmayorIDif').className = "cajareadonly";
              document.getElementById('CformatoIDif').readOnly     = true;
              document.getElementById('CformatoIDif').className = "cajareadonly";
              document.getElementById('CdescripcionIDif').readOnly = true;
              document.getElementById('CmayorIGan').readOnly       = true;
              document.getElementById('CmayorIGan').className = "cajareadonly";
              document.getElementById('CformatoIGan').readOnly     = true;
              document.getElementById('CformatoIGan').className = "cajareadonly";
              document.getElementById('CdescripcionIGan').readOnly = true;
              if (document.getElementById("hhref_CcuentaI"))
                document.getElementById("hhref_CcuentaI").style.visibility = "hidden";
              if (document.getElementById("hhref_CcuentaIDif"))
                document.getElementById("hhref_CcuentaIDif").style.visibility = "hidden";
              if (document.getElementById("hhref_CcuentaIGan"))
                document.getElementById("hhref_CcuentaIGan").style.visibility = "hidden";
          }
          window.onload = lockAcc;
          </script>
          </cfif>
        </td>
        </cfoutput>
      </div>
    </tr>
    <!---   IVA  --->
    <tr>
      <div align="right">
        <cfoutput>
        <td><strong>&nbsp;IVA %: </strong></td><td class="tdsized"><input type="text" name="IVA" id="IVA" tabindex="1" value="#IVA#" onkeypress=" return isNumberKey(event)" style="width:145px" #readonlyDet# #cajadet#></td>
        </cfoutput>
      </div>
    </tr>
    <tr>
      <div align="right"><cfoutput>
      <td><strong>&nbsp;#LB_Tasa_Mensual#</strong></td>
      <td class="tdsized"><input type="text" name="TasaMensual" id="TasaMensual" tabindex="1" value="#TasaMensual#" onkeypress=" return isNumberKey(event)" style="width:145px" #readonlyDet# #cajadet#></td>     
      </div></cfoutput>
    </tr>
    <!---   RENTA DIARIA NO IVA  --->
    <tr>
      <div align="right">
        <cfoutput>
        <td nowrap>
          <strong>&nbsp;#LB_Renta_Diaria_No_IVA#</strong>
        </td>
        <td><input type="text" name="RentaDiariaNoIVA" tabindex="1" value="#RentaDiaria#" style="width:145px" onkeypress=" return isNumberKey(event)" #readonlyDet# #cajadet#></td>
        </cfoutput>
      </div>
    </tr>
    <!---   NUMERO DE MENSUALIDADES  --->
    <tr>
      <div align="right">
      <cfoutput>
        <td nowrap=""><strong>&nbsp;#LB_Num_Mensualidades#</strong></td>
          <td><input type="number" name="NumMensualidades" tabindex="1" value="#NumMensualidades#" onkeypress=" return isNumberKey(event)" style="width:145px" #readonlyDet# #cajadet#></td>
          <td>

          </td>
      </cfoutput>
      </div>
    </tr>
    <!---   BOTONES DETALLE  --->
    <tr>
      <td><br></td>
    </tr>
      <td colspan="5">
        <div align="center">
        <cfoutput>
          <cfif modo NEQ "ALTA" && tabla NEQ "YES">
           
            <cfif modoDet EQ "ALTA">
              <input name="AgregarD"    class="btnGuardar"  tabindex="1" type="submit" value="#BTN_AgregarD#">
              <input name="BorrarA"     class="btnEliminar" tabindex="1" type="submit" value="#BTN_Borr_Arrend#" onclick="deshabValidacion();">
            <cfelseif modoDet EQ "CAMBIO">
              <input name="ModificarD"  class="btnGuardar"  tabindex="1" type="submit" value="#BTN_ModificarD#">
              <input name="BorrarD"     class="btnEliminar" tabindex="1" type="submit" value="#BTN_Borr_Det#">
            </cfif>
            <input name="RegresarD"   class="btnAnterior" tabindex="1" type="button" value="#BTN_Regresar#"   onclick="window.location='Arrendamiento.cfm'" >
            <input name="Limpiar"     class="btnLimpiar"  tabindex="2" type="button" value="#LB_btnLimpiar#"  onClick="javascript: LimpiarFiltros(this.form);"> 
          </cfif>
          <cfif modo NEQ "ALTA" && tabla EQ "YES">
            <cfquery name="rsTabAmort" datasource="#session.dsn#">
              SELECT NumPago, Estado FROM TablaAmort where Ecodigo=#Session.Ecodigo# And IDArrend =#Form.IDArrend# AND NumPago =#NumMensualidades#
            </cfquery>
            <cfif rsTabAmort.Estado EQ 1 && modoULT NEQ "FIN">
              <input name="RegUltCobro" id ="RegultCobro" class="btnGuardar" style="float:right" tabindex="1" type="submit" value="Registrar Ultimo Cobro" onclick="deshabValidacion();">
            <cfelse>
              <input name="RegCobro" id ="RegCobro" class="btnGuardar" style="float:right" tabindex="1" type="submit" value="#BTN_Cobro#" onclick="deshabValidacion();" disabled>
            </cfif>
          </cfif>
        </cfoutput>
        </div>
      </td>
    </tr>
  </table>
<!--- ======================================================================= --->
<!---                            TABLA AMORTIZACIÓN                           --->
<!--- ======================================================================= --->
  <cfif tabla EQ "YES">
    <cfset readonlyDet="readonly">
    <!---   TRAE TABLA SI EXISTE   --->
    <cfquery name="tablaAmort" datasource="#Session.DSN#">
      SELECT    FechaCierreMes, DiasAbarcaCierre, NumPago, FechaInicio, FechaPagoBanco, 
                FechaPagoEmpresa, DiasPeriodo, SaldoInsoluto, Capital, Intereses, PagoMensual, 
                IVA, IntDevengNoCob, InteresRestante, Estado
      FROM      TablaAmort        
      WHERE     IDArrend = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDArrend#">
        AND     Ecodigo = #session.Ecodigo#
    </cfquery>
    <!---   EVALUA EL ESTADO DE LA TABLA   --->
    <cfquery name="rsEstadoDet" datasource="#Session.DSN#">
      SELECT    DetEstado
      FROM      DetArrendamiento
      WHERE     Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#"> 
        AND     IDArrend = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#form.IDArrend#">
    </cfquery>
    <!--- TRAE EL SIGUIENTE COBRO --->
    <cfquery name="SigCob" datasource="#Session.DSN#">
      SELECT    TOP 1 NumPago
      FROM      TablaAmort        
      WHERE     IDArrend = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDArrend#">
        AND     Ecodigo = #session.Ecodigo# AND Estado = 0
    </cfquery>
    <!---   CSS TABLA DE AMORTIZACION  --->
    <style type="text/css">
      .TablaAmort { border-collapse: collapse; }
      .td2 {padding:7px; font-family: verdana; font-size: 9px;}
      .listaPar {padding:7px; font-family: verdana; font-size: 9px;}
      .btnNormal {background-position: left center; margin: 2px 5px; padding-left: 18px; text-align: center;}
      .cfmenu_submenu{padding-left: 5px; padding-right: 5px; font-family: Verdana; font-size: 10px; text-align: center;}
      .trh:hover td { background: #f0f0f0;}
      .align{text-align: center;}
      .scroll{overflow-x:hidden; overflow-y:scroll;}
      .hasborder { background: #D6D6D6; border-bottom:1px solid #000000;}
      .tablaInput{width: 100%; background: none; border:0px; font-family: verdana; font-size: 9px;}
    </style>
 
    <table class="TablaAmort" style="width:1300px" border="0" cellpadding="1" cellspacing="0">
      <tr>
        <td style="width:100%" colspan="15" class="tituloAlterno">
          <cfoutput><strong>#LB_Tabla_Amort#</strong></cfoutput>
        </td>
      </tr>    
      <tr>
        <th style="width: 7%" class="cfmenu_submenu">FECHA&nbsp;CIERRE DE&nbsp;CADA&nbsp;MES</th>
        <th style="width: 6%" class="cfmenu_submenu">DÍAS&nbsp;QUE ABARCA&nbsp;EL CIERRE</th>
        <th style="width: 6%" class="cfmenu_submenu">NUMERO&nbsp;DE PAGO</th>
        <th style="width: 7%" class="cfmenu_submenu">FECHA&nbsp;INICIO</th>
        <th style="width: 7%" class="cfmenu_submenu">FECHA&nbsp;PAGO BANCO</th>
        <th style="width: 7%" class="cfmenu_submenu">FECHA&nbsp;PAGO EMPRESA</th>
        <th style="width: 5%" class="cfmenu_submenu">DÍAS&nbsp;DEL PERIODO</th>
        <th style="width: 8%" class="cfmenu_submenu">SALDO INSOLUTO</th>
        <th style="width: 7%" class="cfmenu_submenu">CAPITAL</th>
        <th style="width: 7%" class="cfmenu_submenu">INTERESES</th>
        <th style="width: 7%" class="cfmenu_submenu">PAGO MENSUAL</th>
        <th style="width: 6%" class="cfmenu_submenu">IVA</th>
        <th style="width: 7%" class="cfmenu_submenu">INTERES DEVENGADO NO&nbsp;COBRADO DEL MES</th>
        <th style="width: 7%" class="cfmenu_submenu">INTERES RESTANTE</th>
        <cfif rsEstadoDet.DetEstado EQ 2>
          <cfoutput><th style="width: 5%" class="cfmenu_submenu">ESTATUS</th></cfoutput>
        <cfelse>
          <cfoutput><th style="width: 1%" class="cfmenu_submenu">&nbsp;</th></cfoutput>
        </cfif>
      </tr>
    </table>
    <div id="tabla" class="scroll" style="height:400px; width:1300px;">
    <table class="TablaAmort" style="width:1300px" border="0" cellpadding="1" cellspacing="0">
    <cfloop query="tablaAmort">
      <cfset linMod = #tablaAmort.NumPago# mod 2>
      

      <cfif tablaAmort.NumPago EQ SigCob.NumPago && rsEstadoDet.DetEstado EQ 2>
       <tr id="tA" class="trh hasborder">
         <cfoutput>
         <td style="width: 7%" class="align td2">#tablaAmort.FechaCierreMes#</td>
         <td style="width: 6%" class="align td2">#tablaAmort.DiasAbarcaCierre#</td>
         <td style="width: 6%" class="align td2"><input id="NumPago" class="tablaInput align" name="NumPago" type="text" style="text-align:center;" readonly value=#tablaAmort.NumPago#></td>
         <td style="width: 7%" class="align td2">#tablaAmort.FechaInicio#</td>
         <td style="width: 7%" class="align td2">#tablaAmort.FechaPagoBanco#</td>
         <td style="width: 7%" class="td2"><input id="FechaPagoEmpresa" class="tablaInput align" name="FechaPagoEmpresa" type="text" style="text-align:center;" readonly value=#tablaAmort.FechaPagoEmpresa#></td>
         <td style="width: 5%" class="align td2">#tablaAmort.DiasPeriodo#</td>
         <td style="width: 8%" class="td2" align="right">#LSNumberFormat(tablaAmort.SaldoInsoluto,"9,999.99")#</td>
         <td style="width: 7%" class="td2" align="right">#LSNumberFormat(tablaAmort.Capital,"9,999.99")#</td>
         <td style="width: 7%" class="td2" align="right">#LSNumberFormat(tablaAmort.Intereses,"9,999.99")#</td>
         <td style="width: 7%" class="td2" align="right"><input id="PagoMensual" class="tablaInput align" name="PagoMensual" type="text" style="text-align:center;" readonly value=#LSNumberFormat(tablaAmort.PagoMensual,"9,999.99")#></td>
         <td style="width: 6%" class="td2" align="right"><input id="IVACant" class="tablaInput align" name="IVACant" type="text" style="text-align:center;" readonly value=#LSNumberFormat(tablaAmort.IVA,"9,999.99")#></td>
         <td style="width: 7%" class="td2" align="right"><input id="IntDeveng" type="text" class="tablaInput" name="IntDeveng" readonly value=#LSNumberFormat(tablaAmort.IntDevengNoCob,"9,999.99")#></td>
         <td style="width: 7%" class="td2" align="right">#LSNumberFormat(tablaAmort.InteresRestante,"9,999.99")#</td>
         <cfif (rsEstadoDet.DetEstado EQ 2)>
            <td style="width: 5%" class="td2" align="left">
            <cfif year(FechaPagoEmpresa) EQ periodo.Pvalor && month(FechaPAgoEmpresa) EQ mes.Pvalor>
            <input type="checkbox" id="cobrochk" name="cobrochk" value=#tablaAmort.NumPago# onclick="EnableSubmit(this);">
            <cfelse>
            <input type="checkbox" id="cobrochk" name="cobrochk" value=#tablaAmort.NumPago# onclick="EnableSubmit(this);" disabled="">
            </cfif>
         <cfelse>
          <td style="width: 1%" align="left" <cfif linMod EQ 0>class="listaPar"<cfelse>class="td2"</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;
         </cfif>
         </cfoutput>
       </tr>
      <cfelse>
       <tr id="tA" class="trh" >
         <cfoutput>
         <td style="width: 7%" <cfif linMod EQ 0>class="listaPar align"<cfelse>class="td2 align"</cfif>>#tablaAmort.FechaCierreMes#</td>
         <td style="width: 6%" <cfif linMod EQ 0>class="listaPar align"<cfelse>class="td2 align"</cfif>>#tablaAmort.DiasAbarcaCierre#</td>
         <td style="width: 6%" <cfif linMod EQ 0>class="listaPar align"<cfelse>class="td2 align"</cfif>>#tablaAmort.NumPago#</td>
         <td style="width: 7%" <cfif linMod EQ 0>class="listaPar align"<cfelse>class="td2 align"</cfif>>#tablaAmort.FechaInicio#</td>
         <td style="width: 7%" <cfif linMod EQ 0>class="listaPar align"<cfelse>class="td2 align"</cfif>>#tablaAmort.FechaPagoBanco#</td>
         <td style="width: 7%" <cfif linMod EQ 0>class="listaPar align"<cfelse>class="td2 align"</cfif>>#tablaAmort.FechaPagoEmpresa#</td>
         <td style="width: 5%" <cfif linMod EQ 0>class="listaPar align"<cfelse>class="td2 align"</cfif>>#tablaAmort.DiasPeriodo#</td>
         <td style="width: 8%" <cfif linMod EQ 0>class="listaPar"<cfelse>class="td2"</cfif> align="right" >#LSNumberFormat(tablaAmort.SaldoInsoluto,"9,999.99")#</td>
         <td style="width: 7%" <cfif linMod EQ 0>class="listaPar"<cfelse>class="td2"</cfif> align="right" >#LSNumberFormat(tablaAmort.Capital,"9,999.99")#</td>
         <td style="width: 7%" <cfif linMod EQ 0>class="listaPar"<cfelse>class="td2"</cfif> align="right" >#LSNumberFormat(tablaAmort.Intereses,"9,999.99")#</td>
         <td style="width: 7%" <cfif linMod EQ 0>class="listaPar"<cfelse>class="td2"</cfif> align="right" >#LSNumberFormat(tablaAmort.PagoMensual,"9,999.99")#</td>
         <td style="width: 6%" <cfif linMod EQ 0>class="listaPar"<cfelse>class="td2"</cfif> align="right" >#LSNumberFormat(tablaAmort.IVA,"9,999.99")#</td>
         <td style="width: 7%" <cfif linMod EQ 0>class="listaPar"<cfelse>class="td2"</cfif> align="right" >#LSNumberFormat(tablaAmort.IntDevengNoCob,"9,999.99")#</td>
         <td style="width: 7%" <cfif linMod EQ 0>class="listaPar"<cfelse>class="td2"</cfif> align="right" >#LSNumberFormat(tablaAmort.InteresRestante,"9,999.99")#</td>
         <cfif (rsEstadoDet.DetEstado EQ 2)>
            <td style="width: 5%" align="left" <cfif linMod EQ 0>class="listaPar"<cfelse>class="td2"</cfif>>
            <input type="checkbox" id="cobrochk" name="cobrochk" value=#tablaAmort.NumPago# onclick="EnableSubmit(this);" <cfif tablaAmort.Estado EQ 1>checked disabled>OK<cfelseif tablaAmort.NumPago GT SigCob.NumPago>disabled><cfelse>></cfif>
         <cfelse>
          <td style="width: 1%" align="left" <cfif linMod EQ 0>class="listaPar"<cfelse>class="td2"</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;
         </cfif>
         </cfoutput>
       </tr>
      </cfif>


    </cfloop>
      <tr>
        <td><br></td>
      </tr>
    </table>
    </div>
    <table align="center">   
      <tr> 
        <td align="center" colspan="14">
          <cfif rsEstadoDet.DetEstado NEQ 2>    <!--- 2 = TABLA ACEPTADA, NO MAS CAMBIOS --->
            <cfquery name="rsTablaCompleta" datasource="#Session.DSN#">
              SELECT      count(1) AS valor
              FROM        TablaAmort
              WHERE       IDArrend = #form.idarrend# AND Ecodigo=#session.ecodigo# AND (FechaCierreMes IS NOT NULL 
                          OR DiasAbarcaCierre IS NOT NULL OR FechaInicio IS NOT NULL OR FechaPagoBanco IS NOT NULL OR 
                          FechaPagoEmpresa IS NOT NULL OR [DiasPeriodo] IS NOT NULL OR IntDevengNoCob IS NOT NULL OR 
                          InteresRestante IS NOT NULL)
            </cfquery>
            <cfif rsEstadoDet.DetEstado NEQ 2>
              <cfoutput>
              <input name="AceptarArr" class="btnGuardar" tabindex="1" type="submit" value="Aceptar">
              <input name="ExportaTabla"  type="submit" class="btnNormal" tabindex="1" value="Exportar" onclick="exportaTabla();">
              </cfoutput>
            </cfif>
            <cfoutput>
            <input name="BorrarT"   class="btnEliminar" tabindex="1" type="submit" value="Borrar Tabla" >
            </cfoutput>
          </cfif>
          <cfoutput>
          <input name="RegresarT" class="btnAnterior" tabindex="1" type="button" value="#LB_BTN_Regresar#" onclick="window.location='Arrendamiento.cfm'" />
          </cfoutput>
        </td>
      </tr>    
    </table>
  </cfif>  
</cfif>

<script type="text/javascript">

function EnableSubmit(t){
  var btn = document.getElementById('RegCobro');
    if(t.checked == true)
      btn.disabled = false;
    else
      btn.disabled = true;
}

<cfoutput>
function options(t){
  var sn = document.form1.SNcodigo.value;
  <cfwddx action="cfml2js" input="#rsArrendamientos#" topLevelVariable="rsjArrendamientos"> 
  var nRows = rsjArrendamientos.getRowCount();
  if (nRows > 0) {
    t.options.length = 1;
    for (row = 0; row < nRows; ++row) {
      if (rsjArrendamientos.getField(row, "SNcodigo") == sn){
        var opt = document.createElement("OPTION");
        opt.value = rsjArrendamientos.getField(row, "IDCatArrend");
        opt.text = rsjArrendamientos.getField(row, "ArrendNombre");
        t.options.add(opt);
      }
    }
  }
}
</cfoutput>

function changeAcc(){
  var t = document.getElementById('habCuentas');
  if(t.checked ==true){
    if (document.getElementById("hhref_CcuentaIDif")){
      document.getElementById("hhref_CcuentaIDif").style.visibility = "visible";
      document.getElementById('CmayorIDif').className = "";
      document.getElementById('CformatoIDif').className = "";
    }
    if (document.getElementById("hhref_CcuentaIDif")){
      document.getElementById("hhref_CcuentaIGan").style.visibility = "visible";
      document.getElementById('CmayorIGan').className = "";
      document.getElementById('CformatoIGan').className = "";
    }
  }else{
    if (document.getElementById("hhref_CcuentaIDif")){
      document.getElementById("hhref_CcuentaIDif").style.visibility = "hidden";
      document.getElementById('CmayorIDif').className = "cajareadonly";
      document.getElementById('CformatoIDif').className = "cajareadonly";
    }
    if (document.getElementById("hhref_CcuentaIGan")){
      document.getElementById("hhref_CcuentaIGan").style.visibility = "hidden";
      document.getElementById('CmayorIGan').className = "cajareadonly";
      document.getElementById('CformatoIGan').className = "cajareadonly";
    }
  }
}
</script>