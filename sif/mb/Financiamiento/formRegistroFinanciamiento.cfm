<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: Arrendamiento                                           --->
<!--- Fecha:  28/03/2014                                              --->
<!--- =============================================================== --->
<!---  Modificado por: Andres Lara                						  --->
<!---	Nombre: Financiamiento                                         --->
<!---	Fecha: 	02/04/2014              	                          --->
<!--- =============================================================== --->
<cfprocessingdirective pageencoding="utf-8"/>

<cfparam name="modo"          default="ALTA">
<cfparam name="SaldoInicial"  default="">
<cfparam name="SaldoInsoluto" default="">
<cfparam name="TasaAnual"     default="">
<cfparam name="IVA"     		  default="">
<cfparam name="FormaPago"     default="">
<cfparam name="TasaMensual"   default="">
<cfparam name="RentaDiaria"   default="">
<cfparam name="PeriodoPAgo"   default="">
<cfparam name="NumPagos" default="">
<cfparam name="Documento"     default="">
<cfparam name="SaldoInsoluto" default="">
<cfparam name="Fecha"         default="">
<cfparam name="Moneda"        default="">
<cfparam name="Banco"  default="">
<cfparam name="TipoCambio"    default="">
<cfparam name="Selected1"     default="">
<cfparam name="StsInstFin"     default="">


<!--- translate --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Banco" default="Banco:" returnvariable="LB_Banco" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CodDocto" default="Codigo de Documento" returnvariable="LB_CodDocto" xmlfile="Financiamiento.xml"/>
<!---cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SocioNegocios" default="Socio de Negocios:" returnvariable="LB_SocioNegocios" xmlfile="Financiamiento.xml"/--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DefFinan" default="Definición del Financiamiento" returnvariable="LB_DefFinan" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_EncDocto" default="Encabezado de Documento" returnvariable="LB_EncDocto" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" returnvariable="LB_Documento" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_LineaC" default="Linea de Cr&eacute;dito" returnvariable="LB_LineaC" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tipo_De_Cambio" default="Tipo de cambio" returnvariable="LB_Tipo_De_Cambio" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Agregar" default="Agregar" returnvariable="BTN_Agregar" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Regresar" default="Regresar" returnvariable="BTN_Regresar" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Saldo_Inicial" default="Saldo Inicial" returnvariable="LB_Saldo_Inicial" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tasa_Anual" default="Tasa Anual" returnvariable="LB_Tasa_Anual" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Forma_de_Pago" default="Forma de Pago" returnvariable="LB_Forma_de_Pago" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tasa_Mensual" default="Tasa Mensual" returnvariable="LB_Tasa_Mensual" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Renta_Diaria_No_IVA" default="Renta Diaria sin IVA" returnvariable="LB_Renta_Diaria_No_IVA" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Importar" default="Importar Tabla TBS" returnvariable="BTN_Importar" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_ImportarA" default="Importar Archivo" returnvariable="BTN_ImportarA" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Saldo_Insoluto" default="Saldo Insoluto" returnvariable="LB_Saldo_Insoluto" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Periodo_De_Pago" default="Periodo de Pago" returnvariable="LB_Periodo_De_Pago" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Num_Pagos" default="Numero de Pagos" returnvariable="LB_Num_Pagos" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Buq" default="Buque" returnvariable="LB_Buq" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechI" default="Fecha Inicio" returnvariable="LB_FechI" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechP" default="Fecha de Pago Banco" returnvariable="LB_FechP" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechC" default="Fecha de Cierre" returnvariable="LB_FechC" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechFP" default="Fecha Final de Pago Empresa" returnvariable="LB_FechFP" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NoP" default="No. Pago" returnvariable="LB_NoP" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DP" default="D&iacute;as del Periodo" returnvariable="LB_DP" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SaldIN" default="Saldo Insoluto" returnvariable="LB_SaldIN" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Capt" default="Capital" returnvariable="LB_Capt" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Int" default="Intereses" returnvariable="LB_Int" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PaMen" default="Pago Mensual" returnvariable="LB_PaMen" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_IVA" default="I.V.A." returnvariable="LB_IVA" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_EST" default="Estatus" returnvariable="LB_EST" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_IDNC" default="Interes DevenNoPag" returnvariable="LB_IDNC" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_InstFin" default="Instrumento Financiero" returnvariable="LB_InstFin" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_GastInstF" default="Gasto Instrumento Finaciero" returnvariable="LB_GastInstF" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MTMP" default="MTM Principal" returnvariable="LB_MTMP" xmlfile="Financiamiento.xml"/>
<!-- TITULOS DEL MODAL LAYER -->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Banco" default="Banco:" returnvariable="LB_Banco" xmlfile="Financiamiento.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PGB" default="Pago del Banco" returnvariable="LB_PGB" xmlfile="Financiamiento.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Interes" default="Intereses" returnvariable="LB_Interes" xmlfile="Financiamiento.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Gasto" default="Gasto" returnvariable="LB_Gasto" xmlfile="Financiamiento.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PagPres" default="Pago por Prestamo" returnvariable="LB_PagPres" xmlfile="Financiamiento.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_RINTF" default="Registro Instrumento Financiero" returnvariable="LB_RINTF" xmlfile="Financiamiento.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_InstFD" default="Instrumentos financieros por pagar" returnvariable="LB_InstFD" xmlfile="Financiamiento.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PerdNR" default="Perdida no realizada /Resultados" returnvariable="LB_PerdNR" xmlfile="Financiamiento.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_IntDevNoC" default="Interes Devengado no Pagado" returnvariable="LB_IntDevNoC" xmlfile="Financiamiento.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Swap" default="Interes Devengado no" returnvariable="LB_Swap" xmlfile="Financiamiento.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Swap2" default="pagado por Instrumento Financiero" returnvariable="LB_Swap2" xmlfile="Financiamiento.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Swap3" default="Interes Devengado no pagado por Instrumento Financiero" returnvariable="LB_Swap3" xmlfile="Financiamiento.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_IntPP" default="Interes por Prestamos" returnvariable="LB_IntPP" xmlfile="Financiamiento.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_GPIF" default="Gasto por Int Financiero" returnvariable="LB_GPIF" xmlfile="Financiamiento.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_GPInF" default="Gasto por Instrumento Financiero" returnvariable="LB_GPInF" xmlfile="Financiamiento.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DAC" default="Dias al cierre" returnvariable="LB_DAC" xmlfile="Financiamiento.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_IDNP" default="Interes devengado no pagado" returnvariable="LB_IDNP" xmlfile="Financiamiento.xml">
<!--  -->
<cfset modoDet  = "ALTA">
<cfset modoTbl  = "NOK">
<cfset UltP  = "NOK">
<!--- Trae El tipo de cambio --->


<cfset TC = "TCventa">
<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	Select Mcodigo,Mnombre,Miso4217
	from Monedas m
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
    order by Mnombre
</cfquery>
<cfquery name="TCsug" datasource="#Session.DSN#">
	select tc.Mcodigo, tc.TCcompra, tc.TCventa
	from Htipocambio tc
	where tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	  and tc.Hfecha <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	  and tc.Hfechah >  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
</cfquery>

<!--- Trae Encabezado si el modo no es alta --->
<cfif modo NEQ "ALTA">
  <cfquery name="rsDocumento" datasource="#Session.DSN#">
    select  IDFinan, Ecodigo, Bid, Documento, LineaC, Mcodigo, TipoCambio, Fecha, Descripcion
    from EncFinanciamiento
    where IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#IDFinan#">
	and Ecodigo = #session.Ecodigo#
  </cfquery>

<cfif rsDocumento.recordCount gt 0>
<cfquery name="rsNombreBanco" datasource="#Session.DSN#">
		select Bid, Bdescripcion
		from Bancos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Bid=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocumento.Bid#">
		order by Bdescripcion
</cfquery>


  <!---cfset LvarBid = rsNombreBanco.Bid--->
  <cfset LvarBid = rsNombreBanco.Bid>
  <cfset Documento="#rsDocumento.Documento#">
  <cfset LineaC="#rsDocumento.LineaC#">
  <cfset Fecha="#rsDocumento.Fecha#">
  <cfset Moneda="#rsDocumento.Mcodigo#">
  <cfset Banco="#rsDocumento.Bid#">
  <cfset TipoCambio="#rsDocumento.TipoCambio#">
  <cfset Descripcion="#rsDocumento.Descripcion#">
</cfif>

  <!--- Trae Detalle si el modoDet no es alta --->



    <cfquery name="rsLinea" datasource="#Session.DSN#">
      select
        IDFinan, Ecodigo, SaldoInicial, SaldoInsoluto, TasaAnual, IVA, FormaPago, TasaMensual, RentaDiaria, NumPagos, BMUsucodigo, StatusD,StsInstFin
      from DetFinanciamiento
      where IDFinan = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDFinan#">
    </cfquery>


<cfif rsLinea.recordCount GT 0>
 <cfset modoDet  = "CAMBIO">
</cfif>

    <cfset SaldoInicial="#rslinea.SaldoInicial#">
    <cfset SaldoInsoluto="#rslinea.SaldoInsoluto#">
    <cfset TasaAnual="#rslinea.TasaAnual#">
    <cfset IVA="#rslinea.IVA#">
    <cfset FormaPago="#rslinea.FormaPago#">
    <cfset TasaMensual="#rslinea.TasaMensual#">
    <cfset RentaDiaria="#rslinea.RentaDiaria#">
    <cfset NumPagos="#rslinea.NumPagos#">
	<cfset StsInstFin="#rsLinea.StsInstFin#">

    <cfswitch expression="#rsLinea.FormaPago#">
      <cfcase value="M">
        <cfset selected1="selected">
      </cfcase>
    </cfswitch>

</cfif>

<html lang="en">
<head>
  <style type="text/css">
    input{text-align: right;}
    select{text-align: right;}
  </style>
  <meta charset="UTF-8">
  <title></title>
</head>
<body>
<cfif modo EQ "ALTA">
  <cfset readonly="">
<cfelse>
  <cfset readonly="readonly">
</cfif>

<cfif modoDet eq "CAMBIO">

	<cfquery name="ConsultEmp" datasource="sifinterfaces">
		select CodICTS
        from int_ICTS_SOIN
        where Ecodigo = #Session.Ecodigo#
	</cfquery>

<cfquery name="TablaAmort" datasource="#session.DSN#">
		select *
        from TablaAmortFinanciamiento
        where Ecodigo = #Session.Ecodigo#
		and IDFinan = #IDFinan#
</cfquery>
<cfquery name="TablaAux" datasource="#session.DSN#">
		select count(1) UltimoP
        from TablaAmortFinanciamiento
        where Ecodigo = #Session.Ecodigo#
		and IDFinan = #IDFinan#
		and Estado = 1
</cfquery>

<cfquery name="TablaAux2" datasource="#session.DSN#">
		select *
        from TablaAmortFinanciamiento
        where Ecodigo = #Session.Ecodigo#
		and IDFinan = #IDFinan#
		and NumPago = #TablaAux.UltimoP# + 1
</cfquery>

<cfquery name="TablaAux3" datasource="#session.DSN#">
		select *
        from TablaAmortFinanciamiento
        where Ecodigo = #Session.Ecodigo#
		and IDFinan = #IDFinan#
		and NumPago = #TablaAux.UltimoP# + 2
</cfquery>

<cfif TablaAux3.RecordCount gt 0>

	<cfif Month(TablaAux3.FechaInicio) eq 1 || Month(TablaAux3.FechaInicio) eq 3 ||Month(TablaAux3.FechaInicio) eq 5 ||Month(TablaAux3.FechaInicio) eq 7 ||
		Month(TablaAux3.FechaInicio) eq 8 ||Month(TablaAux3.FechaInicio) eq 10 ||Month(TablaAux3.FechaInicio) eq 12>
			<cfset FechaCorte = DateAdd("d",(31 - (Day(TablaAux3.FechaInicio))),TablaAux3.FechaInicio)>
	</cfif>

		<cfif Month(TablaAux3.FechaInicio) eq 4 ||Month(TablaAux3.FechaInicio) eq 6 ||Month(TablaAux3.FechaInicio) eq 9 ||	Month(TablaAux3.FechaInicio) eq 11>
			<cfset FechaCorte = DateAdd("d",(30 - (Day(TablaAux3.FechaInicio))),TablaAux3.FechaInicio)>
		</cfif>

		<cfif Month(TablaAux3.FechaInicio) eq 2>
		  <cfset FechaCorte = DateAdd("d",(29 - (Day(TablaAux3.FechaInicio))),TablaAux3.FechaInicio)>
			<cfif Month(FechaCorte) neq 2>
				<cfset FechaCorte = DateAdd("d",-1,FechaCorte)>
			</cfif>
		</cfif>


	<cfset DiasDCorte=FechaCorte - TablaAux3.FechaInicio>
</cfif>

<cfset filtro = "Ecodigo = #Session.Ecodigo# and IDFinan = #IDFinan#">


<cfif TablaAmort.RecordCount gt 0>
	<cfset modoTbl = "OK">
</cfif>

<cfif rsLinea.StatusD eq '2'>
  <cfset modoTbl = "OKCH">
</cfif>

</cfif>



  <!--- ======================================================================= --->
  <!---                            Tabla Encabezado                             --->
  <!--- ======================================================================= --->
<!------------- FORM ------------------->

  <form name="form1" id="form1" action="SQLRegistroFinanciamiento.cfm" method="POST" novalidate onsubmit=" var xa='';

		if(form1.Documento.value == '' || form1.Documento.value == null ){
			xa = xa + '\n -El campo Buque es requerido.';
		}

		if(form1.LineaC.value == '' || form1.LineaC.value == null ){
			xa = xa + '\n -El campo Linea de Credito es requerido.';
		}

		if(form1.Bid.value == '' && form1.SaldoInsoluto == undefined){
			xa = xa + '\n -El campo Banco es requerido.';
		}

		if(form1.Descripcion.value == '' || form1.Descripcion.value == null || form1.LineaC.value == '0' ){
			xa = xa + '\n -El campo Documento es requerido.';
		}

		if(xa .length>0){
		alert('Se presentaron los siguientes errores: \n' + xa);
		return false;
		}else{
		return true;
		}
" >
    <input name="URLira"      id="URLira"     form="form1"  type="hidden" value="<cfoutput>#URLira#</cfoutput>">
    <table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr>
            <td colspan="6" class="tituloAlterno">
              <div align="center">
                <cfoutput><strong>#LB_EncDocto#</strong></cfoutput>
              </div>
            </td>
          </tr>
          <tr>
          <!---►►Documento◄◄--->
            <td width="13%">
              <div align="right">
                <cfoutput><strong>#LB_Buq#:&nbsp;</strong></cfoutput>
              </div>
            </td>
            <td width="39%">
              <cfoutput>
                  <input name="Documento" id="Documento" tabindex="1" type="text" title="Solo Letras y Numeros" value="#Documento#" size="20" maxlength="30"<cfif modoTbl neq "NOK">readonly</cfif> />
          <!---►►LineaC◄◄--->
          &nbsp;<strong>#LB_LineaC#:&nbsp;</strong>
                <cfset LvarModifica = ''> <!--- mover --->
                <cfset LvarValue = ''>      <!--- mover --->
                <cfif isdefined('Form.LineaC')>
                  <cfset LvarValue = form.LineaC>
                </cfif>
                <cfif isdefined('url.LineaC')>
                  <cfset LvarValue = url.LineaC>
                </cfif>
                <cfif modo NEQ "ALTA">
          <cfset LvarModifica = 'readonly'>
                  <cfset LvarValue = rsDocumento.LineaC>
                </cfif>
                  <input name="LineaC" value="#LvarValue#" maxlength="7" align="right" tabindex="1" title="Solo Numeros" <cfif modoTbl neq "NOK">readonly</cfif>>
                  <input name="LineaCaux" value="#LvarValue#" type="hidden">
              </cfoutput>
            </td>
            <!--- Fecha --->
            <td nowrap><strong><cfoutput>#LB_Fecha#:</cfoutput></strong></td>
            <td>
              <cfif modo neq "ALTA">
                <cfset fecha =  LSDateFormat(rsDocumento.Fecha,'dd/mm/yyyy')>
              <cfelse>
                <cfset fecha = LSDateFormat(Now(),'dd/mm/yyyy')>
              </cfif>
			<cfif modo neq "ALTA">
              <cf_sifcalendario name="Fecha" value="#LSDateFormat(Fecha,'dd/mm/yyyy')#" tabindex="3" readonly>
			<cfelse>
			  <cf_sifcalendario name="Fecha" value="#Fecha#" tabindex="3">
			</cfif>
            </td>
            <!---►►Moneda◄◄--->
            <td>
              <div align="right"><cfoutput><strong>#LB_Moneda#:&nbsp;</strong></cfoutput>
              </div>
            </td>
            <td>
            <cfif modo NEQ "ALTA">

			<cfquery name="rsQuitar" datasource="#session.DSN#">
                select Mcodigo
                from Monedas
                where Ecodigo = #Session.Ecodigo#
                and Mcodigo <>  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumento.Mcodigo#">
              </cfquery>

              <cfset LvarQuitar = ValueList(rsQuitar.Mcodigo, ",")>
              <cf_sifmonedas2 query="#rsDocumento#" frame="frame2" valueTC="#rsDocumento.TipoCambio#" quitar="#LvarQuitar#"
                onChange="obtenerTC(this);" tabindex="1">
            <cfelse>
              <cf_sifmonedas2 frame="frame2" onChange="obtenerTC(this);" tabindex="1">
            </cfif>
            </td>
          </tr>
          <tr>
            <!---►►Banco��◄--->

            <td nowrap="nowrap">
              <div align="right"><cfoutput><strong>#LB_Banco#&nbsp;</strong></cfoutput></div>
            </td>

            <td  align="left"  colspan="1" width="48%">
                <cfif modo NEQ "ALTA">
                   <input name="Bdescripcion" type="text" class="cajasinborde" tabindex="-1"
                            value="<cfoutput>#rsNombreBanco.Bdescripcion#</cfoutput>" size="30" maxlength="200" width="28%" >
                    <input type="hidden" name="Bid" value="<cfoutput>#rsDocumento.Bid#</cfoutput>" />
                <cfelse>
                      <cf_sifbancos tabindex="1" size="55" frame="frame1">
                </cfif>
            </td>
            <td></td>
            <td></td>
           <!---►►Tipo de Cambio◄◄--->
            <!--- <cfif modo EQ "ALTA">
              <cfset tcvalue="0.00">
            <cfelse>
              <cfset tcvalue="#url.tipocambio#">
            </cfif> --->

            <td nowrap="nowrap"><div align="right"><cfoutput><strong>#LB_Tipo_de_Cambio#:&nbsp;</strong></div></td>
            <td>
              <cfif modo NEQ 'ALTA'>
              <cf_monto name="TipoCambio" value="#TipoCambio#" modificable="false" tabindex="1" decimales="4" size="16">
              <cfelse>
                <!---<cfquery name="rsTipoCambio" datasource="#session.dsn#">
                   select top 1 TCcompra
                  from Htipocambio
                  where Hfechah < GETDATE()
                  order by Hfechah desc
                </cfquery>--->
                <input name="TipoCambio" style="width: 100px;" pattern="^[1-9][0-9]*(\.[0-9]+)?|0+\.[0-9][1-9]*$" tabindex="1" readonly value = "#LSNumberFormat(1,',9.00')#">
              </cfif></cfoutput>
            </td>
          </tr>
			<tr>
            <!---►►Banco��◄--->

            <td nowrap="nowrap">
              <div align="right"><cfoutput><strong>#LB_Documento#:&nbsp;</strong></cfoutput></div>
            </td>
			 <td  align="left"  colspan="1" width="48%">

                   <input name="Descripcion" type="text" maxlength="30" <cfif modoTbl neq "NOK">readonly</cfif><cfif modo NEQ 'Alta'> value="<cfoutput>#Descripcion#</cfoutput>"<cfelse> value=""</cfif>/>
            </td>
			</tr>
          <tr>
            <td><br><br><br>

         <cfif modo NEQ "ALTA">
                  <input type="hidden" name="Bid" value="<cfoutput>#rsNombreBanco.Bid#</cfoutput>" />
        </cfif>
            </td>
          </tr>
          <tr>
            <td colspan="6">
                <div align="center">
			<cfif modoTbl eq "NOK">
				  <cfif modo EQ "ALTA">
                  <cfoutput>
                    <input name="AgregarE" class="btnGuardar"  tabindex="1" type="submit" value="#BTN_Agregar#" >
                  </cfoutput>
				  <cfelse>
				    <input name="ModificarE" class="btnGuardar"  tabindex="1" type="submit" value="Modificar" onclick="return validaE();">
                    <input name="BorrarE" class="btnEliminar"  tabindex="1" type="submit" value="Eliminar">
                  </cfif>
			</cfif>
				<input type="button"   class="btnAnterior" tabindex="1" name="RegresarD" value="Regresar" onclick="window.location='Financiamiento.cfm'" />

				</div>
            </td>
          </tr>
    </table>
<!--- ======================================================================= --->
<!---                              Tabla Detalle                              --->
<!--- ======================================================================= --->
<cfif modo NEQ "ALTA">
  <cfoutput><input style="display:none" name="IDFinan" value="#IDFinan#"></cfoutput>
    <table style="width:100%" border="0" cellpadding="1" cellspacing="1">
          <tr>
            <td style="width:100%" colspan="9" class="tituloAlterno"><div align="center"><cfoutput><strong>#LB_DefFinan#</strong></cfoutput></div></td>
          </tr>

		 <tr>
            <div align="right">
              <cfoutput>
              <td><strong>&nbsp;#LB_Saldo_Inicial#</strong></td>
              <td>
			       <input name="SaldoInicial" type="text" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rslinea.SaldoInicial,',9.0000')#"<cfelse> value="#SaldoInicial#"</cfif><cfif modoTbl neq "NOK">disabled</cfif> style="text-align: right" size="20" maxlength="12" tabindex="26" onChange="form1.SaldoInsoluto.value= form1.SaldoInicial.value;" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,4); form1.SaldoInsoluto.value= form1.SaldoInicial.value;" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}"/>
              </td>
			  <td>&nbsp;&nbsp;&nbsp;</td>
			  <cfif modoTbl eq "NOK" && modoDet NEQ "ALTA">
              	<td align="left"  colspan="1" width="48%"><input type="submit" class="btnNuevo" name="Importar" value="#BTN_Importar#"></td>
			  <cfelse>
			    <td align="left"  colspan="1" width="48%">&nbsp;&nbsp;&nbsp;</td>
			  </cfif>
              </cfoutput>
            </div>
          </tr>

		 <tr>
            <div align="right">
              <cfoutput>
              <td><strong>&nbsp;#LB_Saldo_Insoluto#</strong></td>
              <td>
			<input name="SaldoInsoluto" type="text" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rslinea.SaldoInsoluto,',9.0000')#"<cfelse> value="#SaldoInsoluto#"</cfif><cfif modoTbl neq "NOK">disabled</cfif> readonly style="text-align: right" size="20" maxlength="12" tabindex="26" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,4);" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}"/>
              </td>
			<td>&nbsp;&nbsp;&nbsp;</td>
			<cfif modoTbl eq "NOK" && modoDet NEQ "ALTA">
              <td align="left"  colspan="1" width="48%"><input type="submit" class="btnNuevo" name="ImportarTA" value="#BTN_ImportarA#" onclick="form1.action='formImportarFinanciamiento.cfm;'"/></td>
			<cfelse>
				<td align="left"  colspan="1" width="48%">&nbsp;&nbsp;&nbsp;</td>
			</cfif>
              </cfoutput>
            </div>
          </tr>
          <tr>
            <div align="right">
              <cfoutput>
              <td><strong>&nbsp;#LB_Tasa_Anual#&nbsp;%</strong></td>
			  <td>
				  <!---input type="number" name="TasaAnual" tabindex="1" value="#TasaAnual#"--->
				  <input name="TasaAnual" type="text" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rslinea.TasaAnual,',9.000')#"<cfelse> value="#TasaAnual#"</cfif><cfif modoTbl neq "NOK">disabled</cfif> style="text-align: right" size="20" maxlength="12" tabindex="26" onFocus="this.value=qf(this); this.select();" onChange="validaPorcentaje(); form1.TasaMensual.value = form1.TasaAnual.value/12;" onBlur="fm(this,3); form1.TasaMensual.value = form1.TasaAnual.value/12;" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}"/>
			  </td>
              </cfoutput>
            </div>
          </tr>
          <tr>
            <div align="right">
              <td><cfoutput><strong>&nbsp;#LB_Forma_de_pago#</strong></td>
                <td>
                <select name="FormaPago" tabindex="1" style="width:145px"<cfif modoTbl neq "NOK">disabled</cfif> >
                <option value=""></option>
                <option value="M" #selected1#>Mensual</option>
                </select>
              </td>
              </cfoutput>
            </div>
          </tr>
          <tr>
            <div align="right">
              <cfoutput>
              <td><strong>&nbsp;IVA&nbsp;%</strong></td>
			  <td>
				  <!---input type="number" name="IVA" id="IVA" tabindex="1" value="#IVA#" onchange="isNumeric()"--->
				  <input name="IVA" type="text" id="IVA" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rslinea.IVA,',9.00')#"<cfelse> value="#IVA#"</cfif><cfif modoTbl neq "NOK">disabled</cfif> style="text-align: right" size="20" maxlength="12" tabindex="26" onFocus="this.value=qf(this); this.select();" onChange="validaPorcentaje();" onBlur="fm(this,2);" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}"/>
			  </td>
              </cfoutput>
            </div>
          </tr>
          <tr>
            <div align="right"><cfoutput>
            <td><strong>&nbsp;#LB_Tasa_Mensual#&nbsp;%</strong></td>
			<td>
				<!---input type="text" name="TasaMensual" tabindex="1" value="#TasaMensual#"--->
				<input name="TasaMensual" type="text" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rslinea.TasaMensual,',9.000')#"<cfelse> value="#TasaMensual#"</cfif><cfif modoTbl neq "NOK">disabled</cfif> readonly style="text-align: right" size="20" maxlength="12" tabindex="26" onFocus="this.value=qf(this); this.select();" onChange="validaPorcentaje();" onBlur="fm(this,3);" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"/>
			</td>

              </cfoutput>
            </div>
          </tr>
          <tr>
          <tr>
          <!--- Periodo Pago --->
            <div align="right">
              <cfoutput>
              <td><strong>&nbsp;#LB_Renta_Diaria_No_IVA#</strong></td>
			  <td>
				  <!---input type="number" name="RentaDiariaNoIVA" tabindex="1" value="#RentaDiaria#"--->
				  <input name="RentaDiariaNoIVA" type="text" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(RentaDiaria,',9.00')#"<cfelse> value="#LSNumberFormat(RentaDiaria,',9.00')#"</cfif><cfif modoTbl neq "NOK">disabled</cfif> style="text-align: right" size="20" maxlength="12" tabindex="26" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,4);" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}"/>
			  </td>
              </cfoutput>
            </div>
          </tr>
          <tr>
            <div align="right">
            <cfoutput>
              <td>
                <strong>&nbsp;#LB_Num_Pagos#</strong></td><td><input type="text" name="NumPagos" tabindex="1" value="#NumPagos#" <cfif modoTbl neq "NOK">disabled="true"</cfif>style="text-align: right" size="20" maxlength="3" tabindex="26" onFocus="this.value=qf(this); this.select();" onChange="if(this.value <1){this.value=0}" onBlur="fm(this);" onKeyUp="if(snumber(this,event)){ if(Key(event)=='13') {this.blur();}"/></td>
            </cfoutput>
            </div>
          </tr>
		 <tr>
            <div align="right">
            <cfoutput>
              <td>
                <strong>&nbsp;#LB_InstFin#</strong></td><td><input type="Checkbox" name="StsInstFin"  <cfif #StsInstFin# eq 1>checked="true"</cfif> tabindex="1"<cfif modoTbl neq "NOK">disabled</cfif>></td>
            	<cfif #StsInstFin# eq 1><input type="hidden" name="InstrumentoF" value="1"></cfif>
			</cfoutput>
            </div>
          </tr>

		<tr>
            <div align="right">
            <cfoutput>
              <td>
                <strong>&nbsp;</td>
            </cfoutput>
            </div>
        </tr>
 <cfif #StsInstFin# eq 1 && modoTbl eq "OKCH">
		<tr>
				<cfoutput>
			<td><strong>#LB_GastInstF#:</strong></td>
			<td>
				<input type="text" name="GastInsF" style="text-align: right" value="#LSNumberFormat('0',',9.0000')#" vasize="20" maxlength="15" tabindex="26" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,4);" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}"/>
			</td>

			<td><strong>#LB_MTMP#:</strong></td>
			<td>
				<input type="text" name="MTMPrin" style="text-align: right" value="#LSNumberFormat('0',',9.0000')#" vasize="20" maxlength="15" tabindex="26" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,4);" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}"/>
			</td>
			</cfoutput>
		</tr>
</cfif>
<table>
		<tr>

			<cfoutput>
	<cfif #StsInstFin# eq 1 && modoTbl eq "OKCH">
			<td><strong>#LB_Swap#</strong></td>


		</tr>

		<tr>
			<td><strong>#LB_Swap2#:</strong></td>
			<td>
				<input type="text" name="Swap" style="text-align: right" value="#LSNumberFormat('0',',9.0000')#" vasize="20" maxlength="15" tabindex="26" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,4);" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}"/>
			</td>
	</cfif>
			<cfif modoTbl eq "OKCH" and isdefined("DIASDCORTE")>
			<td><strong>#LB_IDNP#:</strong></td>
			<td>
				<input type="text" name="InteresDNoC" readonly style="text-align: right" value="#LSNumberFormat('#TablaAux2.IntDevengNoPag#',',9.0000')#" vasize="20" maxlength="15" tabindex="26" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,4);" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}"/>
			<strong>#LB_DAC#:</strong>
				<input type="text" name="DiasCorte" style="text-align: right" value="#LSNumberFormat('#DiasDCorte#')#" vasize="20" onchange="ModifInt();" size="5" maxlength="4" tabindex="26" onFocus="this.value=qf(this); this.select();" onBlur="fm(this);" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}"/>
			</td>
			</cfif>
			</cfoutput>
		</tr>

</table>
		<tr>
            <div align="right"><cfoutput>
            <td><strong>&nbsp;</td>
			</cfoutput></div>
        </tr>


            <td colspan="6"><div align="center"></div>
                <cfif modo NEQ "ALTA">
                <cfoutput>
                  <div align="center">
			<cfif modoTbl eq "NOK">
				 <cfif modoDet EQ "ALTA">
                    <input name="AgregarD" class="btnGuardar"  tabindex="1" type="submit" value="Agregar" onclick="return validaD();">
					<input name="Limpiar" class="btnLimpiar"  tabindex="1" type="button" value="Limpiar" onclick="return LimpiaD();">
				 <cfelse>
					<input name="ModificarD" class="btnGuardar"  tabindex="1" type="submit" value="Modificar" onclick="return validaD();">
					<input name="BorrarD" class="btnEliminar"  tabindex="1" type="submit" value="Eliminar">
					<input name="CalcularT" class="btnNuevo"  tabindex="1" type="submit" value="CalcularTabla">
				 </cfif>
			 <cfelse>
				 <cfif modoTbl eq "OKCH">

					<input name="ConfirmaP" class="btnGuardar"  tabindex="1" value="Registrar Pago" disabled="true" type="button" onclick="overlay();">
					<input name="Origen" type="hidden" value="#TablaAmort.Origen#">
				 <cfelse>
					<input name="AgregarT" class="btnGuardar"  tabindex="1" type="submit" value="Aceptar Tabla" >
					<input name="BorrarT" class="btnEliminar"  tabindex="1" type="submit" value="Rechazar Tabla">
					<input name="btnExportar" class="btnNuevo"  tabindex="1" type="submit" value="Exportar">
				 </cfif>
			 </cfif>
                  </div>
          </cfoutput>
         </cfif>
            </td>
          </tr>


<style>
	.cfmenu_submenu{padding-left: 3px; padding-right: 3px; font-family: Segoe WP; font-size: 10px; text-align: center;}
      .trh:hover td { background: #f0f0f0;}
	  .pagatd: td { background: #f0f0f0;}
      .align{text-align: center;}
      .scroll{overflow-x:hidden; overflow-y:scroll;}
      .listaNon {padding: 2px; padding-left:4px; padding-right:4px;}
	  .listaPar {padding: 2px;padding-left:4px; padding-right:4px;}

	  #overlay{
			visibility:hidden;
			position:absolute;
			left:50px;
			top:300px;
			width:100%;
			height:100%;
			text-align:center;
			z-index:1000;
			}

#overlay div{
			width:530px;
			margin:100px auto;
			background-color:#fff;
			border:1px solid #000;
			padding:15px;
			text-align:center;
			}
</style>

<!--- DESDE AQUI EMPIEZA LA TABLA DE IMPORTACION O CALCULO--->
		<cfif modoTbl eq "OK" || modoTbl eq "OKCH">
		  </tr>
<!--- FIN DE LA TABLA DE PRUEBA --->

        <table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">
    	  <tr>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="left" width="3%"></div><cfoutput>
			      <div align="center"><strong>#LB_NoP#</strong></div>
            </cfoutput></td>

            <td class="tituloListas cfmenu_submenu" align="center" width="6%"></div><cfoutput>
			      <div align="center"><strong>#LB_FechI#</strong></div>
            </cfoutput></td>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="center" width="8%"></div><cfoutput>
			      <div align="center" ><strong>#LB_FechP#</strong></div>
            </cfoutput></td>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="center" width="9%"></div><cfoutput>
			      <div align="center"><strong>#LB_FechFP#</strong></div>
            </cfoutput></td>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="left" width="6%"></div><cfoutput>
			      <div align="center"><strong>#LB_FechC#</strong></div>
            </cfoutput></td>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="center" width="5%"></div><cfoutput>
			      <div align="center"><strong>#LB_DP#</strong></div>
            </cfoutput></td>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="right" width="8%"></div><cfoutput>
			      <div align="center"><strong>#LB_SaldIN#</strong></div>
            </cfoutput></td>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="center" width="6%"></div><cfoutput>
			      <div align="left"><strong>#LB_Capt#</strong></div>
            </cfoutput></td>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="center" width="5%"></div><cfoutput>
			      <div align="center"><strong>#LB_Int#</strong></div>
            </cfoutput></td>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="center" width="7%"></div><cfoutput>
			      <div align="center"><strong>#LB_IDNC#</strong></div>
            </cfoutput></td>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="center" width="5%"></div><cfoutput>
			      <div align="center"><strong>#LB_PaMen#</strong></div>
            </cfoutput></td>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="center" width="5%"></div><cfoutput>
			      <div align="center"><strong>#LB_IVA#</strong></div>
            </cfoutput></td>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="center" width="5%"></div><cfoutput>
			      <div align="center"><strong>#LB_EST#</strong></div>
            </cfoutput></td>

          </tr>
</table>
<div id="table" class="scroll" style="height:400px;">
<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">

	<cfset colores = "1">
        <cfloop query="TablaAmort">

<tr class="trh">
			<td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif>  width="3%" align="left"><cfoutput>
			      <div align="center">#TablaAmort.NumPago#</div>
            </cfoutput></td>
            <td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="9%" align="center"><cfoutput>
			      <div align="center">#TablaAmort.FechaInicio#</div>
            </cfoutput></td>

			<td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="9%" align="center"><cfoutput>
			      <div align="center">#TablaAmort.FechaPagoBanco#</div>
            </cfoutput></td>

			<td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="10%" align="center"><cfoutput>
			      <div align="center">#TablaAmort.FechaPagoPMI#</div>
            </cfoutput></td>

			<td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="9%" align="center"><cfoutput>
			      <div align="center">#TablaAmort.FechaCierre#</div>
            </cfoutput></td>

			<td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="5%" align="center"><cfoutput>
			      <div align="center">#TablaAmort.DiasPeriodo#</div>
            </cfoutput></td>

			<td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="7%" align="center"><cfoutput>
			      <div align="center">#numberformat(TablaAmort.SaldoInsoluto, ",9.00")#</div>
            </cfoutput></td>

			<td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="8%" align="center"><cfoutput>
			      <div align="center">#numberformat(TablaAmort.Capital, ",9.00")#</div>
            </cfoutput></td>

			<td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="5%" align="center"><cfoutput>
			      <div align="center">#numberformat(TablaAmort.Intereses, ",9.00")#</div>
            </cfoutput></td>

			<td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="5%" align="center"><cfoutput>
			      <div align="center">#numberformat(TablaAmort.IntDevengNoPag, ",9.00")#</div>
            </cfoutput></td>

			<td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="5%" align="center"><cfoutput>
			      <div align="center">#numberformat(TablaAmort.PagoMensual, ",9.00")#</div>
            </cfoutput></td>

			<td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="5%" align="center"><cfoutput>
			      <div align="center">#numberformat(TablaAmort.IVA, ",9.00")#</div>
            </cfoutput></td>

			<cfif TablaAmort.Estado neq 1>
			<cfif UltP eq "NOK" and modoTbl eq "OKCH">
				<td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="5%" align="center"><cfoutput>
			      <div align="left"><input type="checkbox" name="Estado" value="#TablaAmort.NumPago#" onClick="ValidaCh();"></div>
			      <cfset Estado=#TablaAmort.NumPago#>
            </cfoutput></td>
			<cfset UltP = "OK">
			<cfelse>
				<td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="5%" align="left"><cfoutput>
			      <div align="left"><input type="checkbox" value="#TablaAmort.NumPago#" disabled></div>
            </cfoutput></td>
			</cfif>
			<cfelse>
			    <td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="3%" align="center"><cfoutput>
			      <div align="center"><input type="checkbox" value="#TablaAmort.NumPago#" disabled checked="true">OK</div></font>
            </cfoutput></td>
			</cfif>

   <cfif colores eq "1">
	  <cfset colores = "2">
	<cfelse>
		<cfset colores = "1">
	</cfif>

</tr>
		</cfloop>
		</table>
</div>
		</tr>

       </cfif>

    </table>

  </cfif>
<!--- AQUI FINALIZA LA INSERCION DE LA TABLA--->
  <cfoutput>

  <input type="hidden" name="pageNum_lista" value="<cfif isdefined('form.pageNum_lista') >#form.pageNum_lista#</cfif>" />

  </cfoutput>
  <!--- ======================================================================= --->
  <!--- ======================================================================= --->

<!--- MODAL  --->
<cfif modo NEQ "ALTA">
<cfif isdefined("Estado")>
<cfquery name="CCuenta1" datasource="#session.DSN#">
		select CPBanco as CCuenta, Month(FechaPagoBanco) as Mes, b.CFcuenta as CFcuenta, b.CFformato
        from TablaAmortFinanciamiento a inner join CFinanciera b
		on a.CPBanco = b.Ccuenta
        where a.Ecodigo = #Session.Ecodigo#
		and IDFinan = #IDFinan#
		and NumPago = #Estado# - 1
</cfquery>
<cfquery name="CCuenta2" datasource="#session.DSN#">
		select CIntP as CCuenta, Month(FechaPagoBanco) as Mes, b.CFcuenta as CFcuenta, b.CFformato
        from TablaAmortFinanciamiento a inner join CFinanciera b
		on a.CIntP = b.Ccuenta
        where a.Ecodigo = #Session.Ecodigo#
		and IDFinan = #IDFinan#
		and NumPago = #Estado# - 1
</cfquery>
<cfquery name="CCuenta3" datasource="#session.DSN#">
		select CGastP as CCuenta, Month(FechaPagoBanco) as Mes, b.CFcuenta as CFcuenta, b.CFformato
        from TablaAmortFinanciamiento a inner join CFinanciera b
		on a.CGastP = b.Ccuenta
        where a.Ecodigo = #Session.Ecodigo#
		and IDFinan = #IDFinan#
		and NumPago = #Estado# - 1
</cfquery>
<cfquery name="CCuenta4" datasource="#session.DSN#">
		select CBanco as CCuenta, Month(FechaPagoBanco) as Mes, b.CFcuenta as CFcuenta, b.CFformato
        from TablaAmortFinanciamiento a inner join CFinanciera b
		on a.CBanco = b.Ccuenta
        where a.Ecodigo = #Session.Ecodigo#
		and IDFinan = #IDFinan#
		and NumPago = #Estado# - 1
</cfquery>
<cfquery name="CCuenta5" datasource="#session.DSN#">
		select CMTMPrinD as CCuenta, Month(FechaPagoBanco) as Mes, b.CFcuenta as CFcuenta, b.CFformato
        from TablaAmortFinanciamiento a inner join CFinanciera b
		on a.CMTMPrinD = b.Ccuenta
        where a.Ecodigo = #Session.Ecodigo#
		and IDFinan = #IDFinan#
		and NumPago = #Estado# - 1
</cfquery>
<cfquery name="CCuenta6" datasource="#session.DSN#">
		select CMTMPrinC as CCuenta, Month(FechaPagoBanco) as Mes, b.CFcuenta as CFcuenta, b.CFformato
        from TablaAmortFinanciamiento a inner join CFinanciera b
		on a.CMTMPrinC = b.Ccuenta
        where a.Ecodigo = #Session.Ecodigo#
		and IDFinan = #IDFinan#
		and NumPago = #Estado# - 1
</cfquery>
 <cfquery name="CCuenta7" datasource="#session.DSN#">
		select CIntDNCD as CCuenta, Month(FechaPagoBanco) as Mes, b.CFcuenta as CFcuenta, b.CFformato
        from TablaAmortFinanciamiento a inner join CFinanciera b
		on a.CIntDNCD = b.Ccuenta
        where a.Ecodigo = #Session.Ecodigo#
		and IDFinan = #IDFinan#
		and NumPago = #Estado# - 1
</cfquery>
<cfquery name="CCuenta8" datasource="#session.DSN#">
		select CSwapD as CCuenta, Month(FechaPagoBanco) as Mes, b.CFcuenta as CFcuenta, b.CFformato
        from TablaAmortFinanciamiento a inner join CFinanciera b
		on a.CSwapD = b.Ccuenta
        where a.Ecodigo = #Session.Ecodigo#
		and IDFinan = #IDFinan#
		and NumPago = #Estado# - 1
</cfquery>
 <cfquery name="CCuenta9" datasource="#session.DSN#">
		select CIntDNCC as CCuenta, Month(FechaPagoBanco) as Mes, b.CFcuenta as CFcuenta, b.CFformato
        from TablaAmortFinanciamiento a inner join CFinanciera b
		on a.CIntDNCC = b.Ccuenta
        where a.Ecodigo = #Session.Ecodigo#
		and IDFinan = #IDFinan#
		and NumPago = #Estado# - 1
</cfquery>
<cfquery name="CCuenta10" datasource="#session.DSN#">
		select CSwapC as CCuenta, Month(FechaPagoBanco) as Mes, b.CFcuenta as CFcuenta, b.CFformato
        from TablaAmortFinanciamiento a inner join CFinanciera b
		on a.CSwapC = b.Ccuenta
        where a.Ecodigo = #Session.Ecodigo#
		and IDFinan = #IDFinan#
		and NumPago = #Estado# - 1
</cfquery>
</cfif>
<div id="overlay">
	<div>
		<!-- <p>Ejemplo de Modal</p> -->
	<table>
		 <tr>
            <td style="width:100%" colspan="9" class="tituloAlterno"><cfoutput><strong>#LB_PagPres#</strong></cfoutput></td>
        </tr>

		<tr>
            <cfoutput>
            <td><strong>&nbsp;</td>
			</cfoutput>
        </tr>

		<tr>
			<td align="right"><strong><cfoutput>#LB_PGB#:</cfoutput></strong></td>
			<td colspan="3">
				<cfif isdefined("CCuenta1") and CCuenta1.CCuenta NEQ ''>
                	<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#CCuenta1#" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="CuentaPBanco" cdescripcion="CdescripcionD1"  cmayor="CmayorD1" cformato="CformatoD1" form="form1"
					tabindex="22">
				<cfelse>
				   <cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" descwidth="20"
				   ccuenta="CuentaPBanco" cdescripcion="CdescripcionD1"  cmayor="CmayorD1" cformato="CformatoD1" form="form1"
				   tabindex="22">
				</cfif>
		     </td>
		</tr>

		<tr>
			<td align="right"><strong><cfoutput>#LB_Interes#:</cfoutput></strong></td>
			<td colspan="3">
				<cfif isdefined("Estado") and CCuenta2.CCuenta NEQ ''>
                	<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#CCuenta2#" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="CuentaInteres" cdescripcion="CdescripcionD2"  cmayor="CmayorD2" cformato="CformatoD2" form="form1"
					tabindex="22">
				<cfelse>
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="CuentaInteres" cdescripcion="CdescripcionD2"  cmayor="CmayorD2" cformato="CformatoD2" form="form1"
					tabindex="22">
				</cfif>
	     	</td>
		</tr>

	<cfif #StsInstFin# eq 1>
		<tr>
			<td align="right"><strong><cfoutput>#LB_Gasto#:</cfoutput></strong></td>
			<td colspan="3">
				<cfif isdefined("Estado") and CCuenta3.CCuenta NEQ ''>
                	<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#CCuenta3#" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="CuentaGasto" cdescripcion="CdescripcionD3"  cmayor="CmayorD3" cformato="CformatoD3" form="form1"
					tabindex="22">
				<cfelse>
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="CuentaGasto" cdescripcion="CdescripcionD3"  cmayor="CmayorD3" cformato="CformatoD3" form="form1"
					tabindex="22">
				</cfif>
	    	</td>
		</tr>
    </cfif>
		<tr>
		     <td align="right"><strong><cfoutput>#LB_Banco#</cfoutput></strong></td>
			 <td colspan="3">
				<cfif isdefined("Estado") and CCuenta4.CCuenta NEQ ''>
                	<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#CCuenta4#" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="CuentaBanco" cdescripcion="CdescripcionD4"  cmayor="CmayorD4" cformato="CformatoD4" form="form1"
					tabindex="22">
				<cfelse>
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="CuentaBanco" cdescripcion="CdescripcionD4"  cmayor="CmayorD4" cformato="CformatoD4" form="form1"
					tabindex="23">
				</cfif>
     		 </td>
		</tr>

		<tr>
            <cfoutput>
            <td><strong>&nbsp;</td>
			</cfoutput>
        </tr>
<cfif #StsInstFin# eq 1>
		<tr>
            <td style="width:100%" colspan="9" class="tituloAlterno"><cfoutput><strong>#LB_RINTF#</strong></cfoutput></td>
        </tr>

		<tr>
            <cfoutput>
            <td><strong>&nbsp;</td>
			</cfoutput>
        </tr>

		<tr>
		     <td align="right"><strong><cfoutput>#LB_PerdNR#</cfoutput></strong></td>
			 <td colspan="3">
				 <cfif isdefined("Estado") and CCuenta5.CCuenta NEQ ''>
                	<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#CCuenta5#" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="EfectEvalInst" cdescripcion="CdescripcionD5"  cmayor="CmayorD5" cformato="CformatoD5" form="form1"
					tabindex="22">
				<cfelse>
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="EfectEvalInst" cdescripcion="CdescripcionD5"  cmayor="CmayorD5" cformato="CformatoD5" form="form1"
					tabindex="23">
				</cfif>
     		 </td>
		</tr>

		<tr>
		     <td align="right"><strong><cfoutput>#LB_InstFD#</cfoutput></strong></td>
			 <td colspan="3">
				  <cfif isdefined("Estado") and CCuenta6.CCuenta NEQ ''>
                	<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#CCuenta6#" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="InstFD" cdescripcion="CdescripcionD6"  cmayor="CmayorD6" cformato="CformatoD6" form="form1"
					tabindex="22">
				<cfelse>
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="InstFD" cdescripcion="CdescripcionD6"  cmayor="CmayorD6" cformato="CformatoD6" form="form1"
					tabindex="23">
				</cfif>
     		 </td>
		</tr>

		<tr>
            <cfoutput>
            <td><strong>&nbsp;</td>
			</cfoutput>
        </tr>
</cfif>
<cfif isdefined("DIASDCORTE")>
		<tr>
            <td style="width:100%" colspan="9" class="tituloAlterno"><cfoutput><strong>#LB_IntDevNoC#</strong></cfoutput></td>
        </tr>

		<tr>
            <cfoutput>
            <td><strong>&nbsp;</td>
			</cfoutput>
        </tr>

		 <tr>
		     <td align="right"><strong><cfoutput>#LB_IntPP#</cfoutput></strong></td>
			 <td colspan="3">
				  <cfif isdefined("Estado") and CCuenta7.CCuenta NEQ ''>
                	<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#CCuenta7#" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="IntPPD" cdescripcion="CdescripcionD7"  cmayor="CmayorD7" cformato="CformatoD7" form="form1"
					tabindex="22">
				<cfelse>
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="IntPPD" cdescripcion="CdescripcionD7"  cmayor="CmayorD7" cformato="CformatoD7" form="form1"
					tabindex="23">
				</cfif>
     		 </td>
		</tr>
</cfif>
<cfif #StsInstFin# eq 1 && modoTbl eq "OKCH">
		<tr>
		     <td align="right"><strong><cfoutput>#LB_Swap3#</cfoutput></strong></td>
			 <td colspan="3">
				  <cfif isdefined("Estado") and CCuenta8.CCuenta NEQ ''>
                	<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#CCuenta8#" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="CCSwapD" cdescripcion="CdescripcionD8"  cmayor="CmayorD8" cformato="CformatoD8" form="form1"
					tabindex="22">
				<cfelse>
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="CCSwapD" cdescripcion="CdescripcionD8"  cmayor="CmayorD8" cformato="CformatoD8" form="form1"
					tabindex="23">
				</cfif>
     		 </td>
		</tr>
</cfif>
<cfif isdefined("DIASDCORTE")>
		<tr>
		     <td align="right"><strong><cfoutput>#LB_IntDevNoC#</cfoutput></strong></td>
			 <td colspan="3">
				  <cfif isdefined("Estado") and CCuenta9.CCuenta NEQ ''>
                	<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#CCuenta9#" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="IntPPC" cdescripcion="CdescripcionD9" cmayor="CmayorD9" cformato="CformatoD9" form="form1"
					tabindex="22">
				<cfelse>
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="IntPPC" cdescripcion="CdescripcionD9"  cmayor="CmayorD9" cformato="CformatoD9" form="form1"
					tabindex="23">
				</cfif>
     		 </td>
		</tr>
</cfif>
<cfif #StsInstFin# eq 1 && modoTbl eq "OKCH">
		<tr>
		     <td align="right"><strong><cfoutput>#LB_GPInF#</cfoutput></strong></td>
			 <td colspan="3">
				  <cfif isdefined("Estado") and CCuenta10.CCuenta NEQ ''>
                	<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#CCuenta10#" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="CCSwapC" cdescripcion="CdescripcionD10"  cmayor="CmayorD10" cformato="CformatoD10" form="form1"
					tabindex="22">
				<cfelse>
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="CCSwapC" cdescripcion="CdescripcionD10"  cmayor="CmayorD10" cformato="CformatoD10" form="form1"
					tabindex="23">
				</cfif>
     		 </td>
		</tr>
</cfif>

		<tr>
            <cfoutput>
            <td><strong>&nbsp;</td>
			</cfoutput>
        </tr>

	</table>
		<input name="RegistroPago" type="submit" class="btnGuardar" value="Confirmar" onclick="return ValidaCuentas();">
		<input type="button" class="btnEliminar" value="Cancelar" onclick="overlay();">
	</div>
</div>
</cfif>
<!--- FIN DEL MODAL --->

  </form>
  </body>



</html>

<cf_qforms form='form1'>
<script type='text/javascript'>

<cfif modo eq "CAMBIO">

			if (<cfoutput>#rsDocumento.Mcodigo#</cfoutput> == <cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>){
				document.form1.TipoCambio.value = "1.00";
			}else{
				<cfwddx action="cfml2js" input="#TCsug#" topLevelVariable="rsTCsug">
				//Verificar si existe en el recordset
				var nRows = rsTCsug.getRowCount();
				if (nRows > 0) {
					for (row = 0; row < nRows; ++row) {
						if (rsTCsug.getField(row, "Mcodigo") == <cfoutput>#rsDocumento.Mcodigo#</cfoutput>) {

							document.form1.TipoCambio.value = rsTCsug.getField(row, "<cfoutput>#TC#</cfoutput>");
							row = nRows;
						                                                  }else{
							                                                   document.form1.TipoCambio.value = "0.00";
							                                                    }
					                                  }
				             }else{
					              document.form1.TipoCambio.value = "0.00";
				                  }
			     }
</cfif>

function ModifInt(){
<cfoutput>
	<cfif modoDet eq "CAMBIO">
	var #toScript(TablaAux3.Intereses,"interM")#;
	var #toScript(TablaAux3.DiasPeriodo,"DPeriodo")#;
	</cfif>
</cfoutput>
    var diasp = form1.DiasCorte.value;
	var interesDNC = (interM /DPeriodo)*diasp;
form1.InteresDNoC.value = interesDNC.toFixed(4);
}


function ValidaCuentas(){
	var xa='';
	<cfoutput>
	var #toScript(StsInstFin,"variable")#;
	</cfoutput>



    if(form1.CuentaPBanco.value == null || form1.CuentaPBanco.value == '' ||form1.CuentaPBanco.value == '0'){
		xa = xa + '\n -Se debe indicar la Cuenta Pago del Banco';
	}

	if(form1.CuentaInteres.value == null || form1.CuentaInteres.value == '' ||form1.CuentaInteres.value == '0'){
		xa = xa + '\n -Se debe indicar la Cuenta de Intereses';
	}

if(variable == 1){
	if(form1.CuentaGasto.value == null || form1.CuentaGasto.value == '' ||form1.CuentaGasto.value == '0'){
		xa = xa + '\n -Se debe indicar la Cuenta de Gasto';
	}
				}

	if(form1.CuentaBanco.value == null || form1.CuentaBanco.value == '' ||form1.CuentaBanco.value == '0'){
		xa = xa + '\n -Se debe indicar la Cuenta del Banco';
	}


	if(form1.IntPPC.value == null || form1.IntPPC.value == '' ||form1.IntPPC.value == '0'){
		xa = xa + '\n -Se debe indicar la Cuenta del Interes Devengado no Pagado';
	}

	if(form1.IntPPD.value == null || form1.IntPPD.value == '' ||form1.IntPPD.value == '0'){
		xa = xa + '\n -Se debe indicar la Cuenta de Interes por Prestamos';
	}

if(variable == 1){
	if(form1.EfectEvalInst.value == null || form1.EfectEvalInst.value == '' ||form1.EfectEvalInst.value == '0'){

		xa = xa + '\n -Se debe indicar la Cuenta de Perdida no realizada';
	}

	if(form1.InstFD.value == null || form1.InstFD.value == '' ||form1.InstFD.value == '0'){
		xa = xa + '\n -Se debe indicar la Cuenta de Instrumentos Financieros';
	}

	if(form1.CCSwapD.value == null || form1.CCSwapD.value == '' ||form1.CCSwapD.value == '0'){
		xa = xa + '\n -Se debe indicar la Cuenta Interes Devengado no pagado por Instrumento Financiero';
	}

	if(form1.CCSwapC.value == null || form1.CCSwapC.value == '' ||form1.CCSwapC.value == '0'){
		xa = xa + '\n -Se debe indicar la Cuenta del Gasto por Instrumento Financiero';
	}
			}

	if(xa.length>0 || xa !=''){
 	 alert('Se presentaron los siguientes errores: \n' + xa);
  		return false;
	}else{
		  return true;
		 }

}

function overlay() {


	if(validaInstrumentos() == true){
				el = document.getElementById("overlay");
				el.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
								    }
	}

function validaInstrumentos(){
<cfoutput>
	var #toScript(StsInstFin,"variable")#;
	</cfoutput>
var vacio='';
	if(variable==1){


				if(form1.GastInsF.value == null || form1.GastInsF.value == '' ||form1.GastInsF.value <=0){
					vacio = vacio + '\n -El valor de Gasto Instrumento Finaciero debe ser menor a 0';
				}

				if(form1.MTMPrin.value == null || form1.MTMPrin.value == '' ||form1.MTMPrin.value <=0){
					vacio = vacio + '\n -El valor de MTM Principal debe ser menor a 0';
				}

				if(form1.Swap.value == null || form1.Swap.value == '' ||form1.Swap.value <=0){
					vacio = vacio + '\n -El valor de Interes Devengado no pagado por Instrumento Financiero debe ser menor a 0';
				}
		}


				if(vacio !=''){
			 	 alert('Se presentaron los siguientes errores: \n' + vacio);
			  		return false;
				}else{
					  return true;
					 }

}
<cfoutput>
function obtenerTC(cb){
			if (cb.value == #rsMonedaLocal.Mcodigo#){
				document.form1.TipoCambio.value = "1.00";
			}else{
				<cfwddx action="cfml2js" input="#TCsug#" topLevelVariable="rsTCsug">
				//Verificar si existe en el recordset
				var nRows = rsTCsug.getRowCount();
				if (nRows > 0) {
					for (row = 0; row < nRows; ++row) {
						if (rsTCsug.getField(row, "Mcodigo") == cb.value) {
							document.form1.TipoCambio.value = rsTCsug.getField(row, "<cfoutput>#TC#</cfoutput>");
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
/////////////////////////////////////////
//    START VALIDATIONS                //
/////////////////////////////////////////
function validaPorcentaje(){

if((document.form1.TasaAnual.value)>100 || (document.form1.TasaAnual.value)<0){
   alert('El Campo no puede ser Mayor a 100, ni menor a 0');
   document.form1.TasaAnual.value='';
 }

 if((document.form1.IVA.value)>100 || (document.form1.IVA.value)<0){
   alert('El Campo no puede ser Mayor a 100, ni menor a 0');
   document.form1.IVA.value='';
 }

 if((document.form1.TasaMensual.value)>100){
   alert('El Campo no puede ser Mayor a 100, ni menor a 0');
   document.form1.TasaMensual.value='';
 }
}

function validaE(){
var men='';

if(document.form1.Documento.value == ''){
		men = men+ '\n - El Campo Buque es requerido'
	}


	if (isNaN(document.form1.LineaC.value)){
		men = men+ '\n - Linea de Credito: Solo Numeros'
		document.form1.LineaC.value='';
	}else{

	if(document.form1.LineaC.value <= 0 || document.form1.Linea.value == ' '){
		men = men+ '\n - El campo Linea de Credito es requerido'
	}}

	if(men!=''){
		alert('Se presentaron los siguientes errores: \n' + men)
           return false;
		}else{return true;}
}

function LimpiaD(){
document.form1.SaldoInicial.value='0.0000';
document.form1.SaldoInsoluto.value='0.0000';
document.form1.TasaAnual.value='0.00';
document.form1.FormaPago.value='';
document.form1.IVA.value='0.00';
document.form1.TasaMensual.value='0.00';
document.form1.RentaDiariaNoIVA.value='0.0000';
document.form1.NumPagos.value='';
document.form1.StsInstFin.value='';
		}

function ValidaCh(){

	if(document.form1.ConfirmaP.disabled){
		document.form1.ConfirmaP.disabled = false
										 }else{
		document.form1.ConfirmaP.disabled=true

	                                           }
					}


function validaD(){
var men='';

	if(document.form1.SaldoInicial.value <= 0){
		men = men+ '\n - El Campo Saldo Inicial debe ser Mayor a 0'
											  }
	if(document.form1.SaldoInsoluto.value <= 0){
		men = men+ '\n - El Campo Saldo Insoluto debe ser Mayor a 0'
	}
	if(document.form1.TasaAnual.value < 0){
		men = men+ '\n - El Campo Tasa Anual debe ser Mayor a 0'
	}
	if(document.form1.FormaPago.value < 1){
		men = men+ '\n - El Campo Forma de Pago es requerido'
	}
	if(document.form1.TasaMensual.value < 0){
		men = men+ '\n - El Campo Tasa Mensual debe ser Mayor a 0'
	}

	if(document.form1.RentaDiariaNoIVA.value <= 0){
		men = men+ '\n - El Campo Renta Diaria sin IVA debe ser Mayor a 0'
	}

	if(document.form1.NumPagos.value == ''){
		men = men+ '\n - El Campo Numero de Pagos es requerido'
	}

	if(men!=''){
		alert('Se presentaron los siguientes errores: \n' + men)
           return false;
		}else{return true;}
}

<cfif modo eq 'ALTA'>
objForm.LineaC.validateNumeric("Linea de Credito: Solo Numeros");
objForm.PeriodoPago=true;
objForm.URLira.required=true;
</cfif>

</script>