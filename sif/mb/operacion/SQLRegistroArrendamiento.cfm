<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: Arrendamiento                                           --->
<!--- Fecha:  28/03/2014                                              --->
<!--- Última Modificación: 16/04/2014                                 --->
<!--- =============================================================== --->

<cfparam name="form.IDArrend"     default="0">
<cfparam name="Form.Folio"        default="0">
<cfparam name="existeEnc"         default="NO">
<cfparam name="existearrend"         default="NO">
<cfparam name="existeDet"         default="NO">
<cfparam name="existeTab"         default="NO">

<!--- =============================================================== --->
<!---                   AGREGAR ENCABEZADO                            --->
<!--- =============================================================== --->
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
<cfif isDefined("Form.AgregarE") || isDefined("Form.BorrarA")>
    <!--  Valida que el documento no exista  -->
    <cfquery name="rsExisteEncab" datasource="#Session.DSN#">
        SELECT COUNT(1) AS valor
          FROM EncArrendamiento 
         WHERE Ecodigo   =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
           AND Documento = <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.Documento#">
           AND SNcodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">                
    </cfquery>
    <cfif rsExisteEncab.valor NEQ 0>
        <cfset existeEnc = "YES">
    </cfif>
    <cfquery name="rsExisteArrend" datasource="#Session.DSN#">
        SELECT COUNT(1) AS valor
          FROM EncArrendamiento 
         WHERE Ecodigo   =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
           AND IDCatArrend = <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.NombreArrend#">
           AND SNcodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
           AND Estado = 0             
    </cfquery>
        <cfif rsExisteArrend.valor NEQ 0>
        <cfset existeArrend = "YES">
    </cfif>
</cfif>        
<cfif isDefined("Form.AgregarE") && !existeEnc && !existeArrend>
    <cfquery name="nombreArrend" datasource="#session.dsn#">
        SELECT      ArrendNombre
          FROM      CatalogoArrend
         WHERE      Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
           AND      IDCatArrend = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.NombreArrend#">
    </cfquery>
    <!---   INSERTA ENCABEZADO   --->
    <cftransaction>  
        <cfquery name="rsInsertEArrend" datasource="#session.DSN#">
            INSERT INTO EncArrendamiento (Ecodigo, SNcodigo, Documento, Folio, Mcodigo, TipoCambio, IDCatArrend, ArrendNombre, Observaciones, Fecha, Periodo, Mes,
                                        BMUsucodigo)
            VALUES     (#Session.Ecodigo# ,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.SNcodigo#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Documento#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Folio#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Form.Mcodigo#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_float"    value="#Form.TipoCambio#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.NombreArrend#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#nombreArrend.ArrendNombre#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Observaciones#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_date"     value="#Form.Fecha#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#periodo.pvalor#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#mes.pvalor#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#session.Usucodigo#">
                    )
            <cf_dbidentity1 datasource="#session.DSN#">
        </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsertEArrend" returnvariable="IDArrend">
        <cfset modo     = "CAMBIO">
        <cfset modoDet  = "ALTA">
    </cftransaction>
    <cflocation url="Arrendamiento.cfm?&idarrend=#idarrend#&modo=#modo#&mododet=#mododet#&urlira=#urlira#&tipocambio=#form.tipocambio#">
<cfelseif isDefined("Form.AgregarE") && existeEnc>
    <script>alert("El documento ya existe");history.back();</script>
<cfelseif isDefined("Form.AgregarE") && existeArrend>
    <script>alert("El Arrendamiento ya existe");history.back();</script>
</cfif>
<!--- =============================================================== --->
<!---                        BORRAR ENCABEZADO                        --->
<!--- =============================================================== --->

<cfif isDefined("Form.BorrarA") && existeEnc>
    <cftransaction>  
        <cfquery name="rsDeleteEArrend" datasource="#session.DSN#">
            DELETE  EncArrendamiento  
            WHERE   IDArrend = #form.IDArrend#
            AND     Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
        <cfset modo     = "ALTA">
        <cfset modoDet  = "ALTA">
    </cftransaction>
    <cflocation url="Arrendamiento.cfm?&idarrend=#idarrend#&modo=#modo#&mododet=#mododet#&urlira=#urlira#&tipocambio=#form.tipocambio#">
<cfelseif isDefined("Form.BorrarA") && !existeEnc>
    <script>alert("No existe el documento"); history.back();</script>
</cfif>

<!--- =============================================================== --->
<!---                   AGREGAR DETALLE                               --->
<!--- =============================================================== --->  
<cfif isdefined("Form.AgregarD") || isdefined("Form.ModificarD") || isDefined("Form.BorrarD")>
    <cfquery name="rsExisteDet" datasource="#Session.DSN#">
        SELECT      COUNT(1) AS valor
        FROM        DetArrendamiento 
        WHERE       Ecodigo     =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        AND         IDArrend = <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.IDArrend#">      
    </cfquery>
    <!---   EXISTE DETALLE   --->
    <cfif rsExisteDet.valor NEQ 0> 
        <cfset existeDet= "YES">
    </cfif>
</cfif>
<cfif isdefined("Form.AgregarD")>
    <cfif !existeDet>
        <cftransaction> 
            <!---   INSERTA DETALLE  --->
            <cfquery name="rsInsertDArrend" datasource="#session.DSN#">
                INSERT INTO DetArrendamiento (IDArrend, Ecodigo, FechaInicio, SaldoInicial, SaldoInsoluto, TasaAnual, IVA, FormaPago, TasaMensual, 
                            RentaDiaria, NumMensualidades, BMUsucodigo)
                VALUES  (   
                            <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.IDArrend#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_date"     value="#Form.FechaInicio#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.SaldoInicial#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.SaldoInsoluto#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.TasaAnual#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.Iva#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.FormaPago#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.TasaMensual#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.RentaDiariaNoIva#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.NumMensualidades#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Session.Usucodigo#">
                        )
            </cfquery>
            <cfset modo     = "CAMBIO">
            <cfset modoDet  = "CAMBIO">
        </cftransaction>
        <cflocation url="Arrendamiento.cfm?&idarrend=#idarrend#&modo=#modo#&mododet=#mododet#&urlira=#urlira#&tipocambio=#form.tipocambio#">
    <cfelse>
        <script>alert("El detalle ya existe");history.back();</script>
    </cfif>
</cfif>

<!--- =============================================================== --->
<!---                   MODIFICAR DETALLE                               --->
<!--- =============================================================== --->  
<cfif isdefined("Form.ModificarD") && existeDet> 
    <cftransaction>
        <cfquery name="rsUpdateDArrend" datasource="#session.DSN#">
            UPDATE      DetArrendamiento SET
                        FechaInicio = <cf_jdbcquery_param cfsqltype="cf_sql_date"     value="#LSDateFormat(Form.FechaInicio,'mm/dd/yyyy')#">,
                        SaldoInicial = <cf_jdbcquery_param cfsqltype="cf_sql_money"   value="#Form.SaldoInicial#">, 
                        SaldoInsoluto = <cf_jdbcquery_param cfsqltype="cf_sql_money"  value="#Form.SaldoInsoluto#">,
                        TasaAnual = <cf_jdbcquery_param cfsqltype="cf_sql_money"      value="#Form.TasaAnual#">,
                        IVA = <cf_jdbcquery_param cfsqltype="cf_sql_money"            value="#Form.Iva#">,
                        FormaPago = <cf_jdbcquery_param cfsqltype="cf_sql_integer"    value="#Form.FormaPago#">,
                        TasaMensual = <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.TasaMensual#">,
                        RentaDiaria = <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.RentaDiariaNoIva#">,
                        NumMensualidades = <cf_jdbcquery_param cfsqltype="cf_sql_integer"    value="#Form.NumMensualidades#">
            WHERE       Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer"      value="#Session.Ecodigo#"> 
            AND         IDArrend = <cf_jdbcquery_param cfsqltype="cf_sql_integer"     value="#Form.IDArrend#">
        </cfquery>
        <cfset modo     = "CAMBIO">
        <cfset modoDet  = "CAMBIO">
    </cftransaction>
    <cflocation url="Arrendamiento.cfm?&idarrend=#idarrend#&modo=#modo#&mododet=#mododet#&urlira=#urlira#&tipocambio=#form.tipocambio#">
</cfif>
<!--- =============================================================== --->
<!---                     BORRAR    DETALLE                           --->
<!--- =============================================================== --->
<cfif isDefined("Form.BorrarD") && existeDet>
    <cftransaction>  
        <cfquery name="rsDeleteDArrend" datasource="#session.DSN#">
            DELETE DetArrendamiento  WHERE IDArrend = #form.IDArrend#
            AND     Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
        <cfset modo     = "CAMBIO">
        <cfset modoDet  = "ALTA">
    </cftransaction>
    <cflocation url="Arrendamiento.cfm?&idarrend=#idarrend#&modo=#modo#&mododet=#mododet#&urlira=#urlira#&tipocambio=#form.tipocambio#">
<cfelseif isDefined("Form.BorrarD") && !existeDet>
    <script>alert("No Tiene Detalle"); history.back();</script>
</cfif>             

<!--- =============================================================== --->
<!---                   BORRAR TABLA AMORTIZACIÓN                     --->
<!--- =============================================================== --->
<cfif isDefined("Form.BorrarT") || isDefined("Form.AceptarArr") || isDefined("Form.CalcularTab") || isDefined("Form.RegCobro")>
    <cfquery name="rsExisteTab" datasource="#Session.DSN#">
        SELECT  count(1) AS valor
        FROM    TablaAmort 
        WHERE   Ecodigo     =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        AND     IDArrend = <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.IDArrend#">      
    </cfquery>
    <cfif rsExisteTab.valor NEQ 0>
        <cfset existeTab= "YES">
    </cfif>
</cfif>
<cfif isDefined("Form.BorrarT") && existeTab>
    <cftransaction>  
        <cfquery name="rsDeleteTArrend" datasource="#session.DSN#">
            DELETE TablaAmort  WHERE IDArrend = #form.IDArrend#
        </cfquery>
        <cfquery name="detTabla" datasource="#Session.DSN#">
            UPDATE          DetArrendamiento
            SET             DetEstado = 0
            WHERE           Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#"> AND 
                        IDArrend = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.IDArrend#">
        </cfquery>
        <cfset modo     = "CAMBIO">
        <cfset modoDet  = "CAMBIO">
    </cftransaction>
    <cflocation url="Arrendamiento.cfm?&idarrend=#idarrend#&modo=#modo#&mododet=#mododet#&urlira=#urlira#&tipocambio=#form.tipocambio#">
<cfelseif isDefined("Form.BorrarT") && rsExisteDet.valor EQ 0>
    <script>alert("No Existe Tabla"); history.back();</script>
</cfif>     


<!--- =============================================================== --->
<!---                   ACEPTAR TABLA AMORTIZACIÓN                    --->
<!--- =============================================================== --->

<cfif isDefined("Form.AceptarArr") && existeTab>
    <cftransaction>  
        <cfquery name="AceptTabla" datasource="#Session.DSN#">
            UPDATE          DetArrendamiento
            SET             DetEstado = 2
            WHERE           Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#"> AND 
                            IDArrend = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.IDArrend#">
        </cfquery>
        <cfset modo     = "CAMBIO">
        <cfset modoDet  = "CAMBIO">
    </cftransaction>
    <cflocation url="Arrendamiento.cfm?&idarrend=#idarrend#&modo=#modo#&mododet=#mododet#&urlira=#urlira#&tipocambio=#form.tipocambio#">
<cfelseif isDefined("Form.BorrarT") && rsExisteTab.valor EQ 0>
    <script>alert("No Existe Tabla"); history.back();</script>
</cfif>
<!--- =============================================================== --->
<!---                  CALCULAR TABLA AMORTIZACIÓN                    --->
<!--- =============================================================== --->

<cfif isDefined("Form.CalcularTab") && !existeTab >

<cfset monto = LSParseNumber(Form.SaldoInicial)>
<cfset tasa = (form.TasaAnual/12/100)>
<cfset factorAnualidad = Round((tasa/(1-(1+tasa)^-form.nummensualidades))*10000000000000000)/10000000000000000>
<cfset mensualidad = Round((factorAnualidad*monto)*100000000)/100000000>
<cfset iva = form.IVA/100>
<cfset fechaInicio = form.FechaInicio>
<cfset capital = monto>


<cftransaction>
    <cfloop from="1" to="#form.nummensualidades#" index="i">
        <cfset interes=(tasa*capital)>
        <cfset amortizacion=(mensualidad-interes)>
        <cfset saldoInsoluto=(capital-amortizacion)>
        <cfset cantIva=mensualidad*iva>
        <!---   CALCULO DE FECHA DE INICIO    --->
        <cfif i GT 1>
            <cfset fechaInicio= DateAdd("m", 1, fechaInicio)>
        <cfelse>
            <cfset fechaInicio= DateAdd("m", 0, fechaInicio)><!---   CONVIERTE Y VALIDA EL FORMATO DE LA FECHA    --->
        </cfif>
        <cfif DayOfWeek(fechaInicio) EQ 1>
            <cfset fechIn= DateAdd("d", 1, fechaInicio)>
        <cfelseif DayOfWeek(fechaInicio) EQ 7>
            <cfset fechIn= DateAdd("d", 2, fechaInicio)>
        <cfelse>
            <cfset fechIn= fechaInicio>
        </cfif>
        <!---   CALCULO FECHA CIERRE DE CADA MES     --->
        <cfset fechaCierre = fechIn + (DaysInMonth(fechIn)-Day(fechIn))>
        <!---   CALCULO DE DIAS QUE ABARCA EL CIERRE     --->
        <cfset diasCierre = DateDiff("d", fechIn, fechaCierre)>
        <!---   CALCULO DE FECHA DE PAGO AL BANCO    --->
        <cfset fechaPagoB= fechaInicio +DaysInMonth(fechaInicio)>
        <cfif DayOfWeek(fechaPagoB) EQ 1>
            <cfset fechaPagoB= DateAdd("d", 1, fechaPagoB)>
        <cfelseif DayOfWeek(fechaPagoB) EQ 7>
            <cfset fechaPagoB= DateAdd("d", 2, fechaPagoB)>
        </cfif>
        <!---   CALCULA FECHA PAGO EMPRESA   --->
        <cfset fechaPagoE = fechIn +30>
        <cfif DayOfWeek(fechaPagoE) EQ 1>
            <cfset fechaPagoE= DateAdd("d", -2, fechaPagoE)>
        <cfelseif DayOfWeek(fechaPagoE) EQ 7>
            <cfset fechaPagoE= DateAdd("d", -1, fechaPagoE)>
        </cfif>
        <!---   CALCULA DIAS DEL PERIODO     --->
        <cfset diasPeriodo = DateDiff("d", fechIn, fechaPAgoE)>
        <!---   CALCULA INTERES DEVENGADO    --->
        <cfset IntDeveng = (interes/diasPeriodo) * diasCierre>
        <!---   CALCULO INTERES RESTANTE   --->
        <cfset IntRest = interes-IntDeveng>
        <cfoutput>
        <cfquery name="rsCargaAmort" datasource="#Session.DSN#">
            INSERT INTO    TablaAmort (IDArrend, Ecodigo, NumPago, FechaCierreMes, DiasAbarcaCierre, FechaInicio, FechaPagoBanco, FechaPagoEmpresa, DiasPeriodo, SaldoInsoluto, Capital, Intereses, PagoMensual, IVA, Mcodigo, TipoCambio, IntDevengNoCob, InteresRestante, Estado, BMUsucodigo)
            VALUES        (<cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.IDArrend#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#">, 
                           <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#i#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_date"     value="#LSDateFormat(fechaCierre,'mm/dd/yyyy')#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#diasCierre#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_date"     value="#LSDateFormat(fechIn,'mm/dd/yyyy')#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_date"     value="#LSDateFormat(fechaPagoB,'mm/dd/yyyy')#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_date"     value="#LSDateFormat(fechaPagoE,'mm/dd/yyyy')#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#diasPeriodo#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#saldoInsoluto#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#amortizacion#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#interes#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#mensualidad#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#cantIva#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.Mcodigo#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.TipoCambio#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#intDeveng#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#intRest#">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="0">,
                           <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#session.usucodigo#">)
        </cfquery>

        </cfoutput>
        <cfset capital=round(saldoInsoluto*10000000)/10000000>
    </cfloop>
        <cfquery name="detTabla" datasource="#Session.DSN#">
            UPDATE          DetArrendamiento
            SET             DetEstado = 1
            WHERE           Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#"> AND 
                            IDArrend = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#form.IDArrend#">
        </cfquery>
        <cfset modo     = "CAMBIO">
        <cfset modoDet  = "CAMBIO">
</cftransaction>
    <cflocation url="Arrendamiento.cfm?&idarrend=#idarrend#&modo=#modo#&mododet=#mododet#&urlira=#urlira#&tipocambio=#form.tipocambio#">
<cfelseif isDefined("Form.CalcularTab") && existeTab>
    <script>alert("Ya Existe una Tabla"); history.back();</script>
</cfif>
<!--- =============================================================== --->
<!---                  REGISTRO CONTABLE                              --->
<!--- =============================================================== --->

<!---   REGISTRA EL INTERES    --->
<cfif isDefined("Form.RegCobro") && existetab>
    <cfparam name="cobroDoc" Default="">
    <!---   VALIDA COBRO     --->
    <cfquery name="rsExisteCob" datasource="#session.dsn#">
       SELECT  count(1)
         FROM  TablaAmort
        WHERE  Ecodigo = #session.Ecodigo# AND IDArrend = #Form.IDArrend#
            AND NumPago = #Form.NumPago# AND Estado = 0
    </cfquery>
    <!---   TRAE CODIGO CONCEPTO ACTUAL  --->
    <cfquery name="rsCid" datasource="#session.dsn#">
        SELECT Cid 
        FROM CatalogoArrend 
        WHERE IDCatArrend = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.NombreArrend#"> 
        AND Ecodigo = #Session.Ecodigo#
    </cfquery>
    <!---   BUSCA FACTURA    --->
    <cfset total = replace(#Form.PagoMensual#, ",","")+replace(#Form.IVACant#,",","")>
    <cfquery name="rsBuscaCobro" datasource="#session.dsn#">
        SELECT  a.Ddocumento as Documento, a.Dfecha as fecha, EDtipocambioFecha as TCfecha,IDcontable
          FROM  HDocumentos a INNER JOIN HDDocumentos b on a.HDid = b.HDid
         WHERE  a.Ecodigo = #session.Ecodigo# 
           AND  a.EDperiodo = #periodo.Pvalor# 
           AND  a.EDmes = #mes.Pvalor# 
           AND  b.DDcodartcon = #rsCid.Cid# AND Dtotal = <cf_jdbcquery_param cfsqltype="cf_sql_money"  value="#Total#">
           order by fecha asc
    </cfquery>
    <cfparam name="rsBusHPol.valor" default ="0">
    <cfparam name="rsBusPol.valor" default ="0">

    <cfif LEN(TRIM(rsBuscaCobro.Documento)) GT 0 && (year(rsBuscaCobro.fecha) EQ periodo.Pvalor && month(rsBuscaCobro.fecha) EQ mes.Pvalor)>
        <!---   BUSCA POLIZA     --->
        <cfquery name="rsBusHPol" datasource="#session.dsn#">
            SELECT Count(1) as valor
            FROM   HEContables hec
            inner join HDContables hdc  on hec.Ecodigo=hdc.Ecodigo and hec.IDcontable=hdc.IDcontable 
            WHERE   hec.Ecodigo =#Session.Ecodigo#
              AND   hdc.Ddocumento = '#rsBuscaCobro.Documento#'
              and  	hec.IDcontable = '#rsBuscaCobro.IDcontable#'
        </cfquery>
        <cfquery name="rsBusPol" datasource="#session.dsn#">
            SELECT Count(1) as valor
            FROM   EContables ec
            inner join DContables dc  on ec.Ecodigo=dc.Ecodigo and ec.IDcontable=dc.IDcontable 
            WHERE   ec.Ecodigo =#Session.Ecodigo#
              AND   dc.Ddocumento = '#rsBuscaCobro.Documento#'
              and  	ec.IDcontable = '#rsBuscaCobro.IDcontable#'
        </cfquery>

    <cfelseif LEN(TRIM(rsBuscaCobro.Documento)) EQ 0 or year(rsBuscaCobro.fecha) NEQ periodo.Pvalor or month(rsBuscaCobro.fecha) NEQ mes.Pvalor>
            <script type="text/javascript">
                <cfoutput>alert('No existe el cobro en el sistema');</cfoutput>
                history.back();
            </script>
    </cfif>
        <cfif (rsBusPol.valor GT 0 or rsBusHPol.valor GT 0) or form.NumPago EQ 1>
            <!---   TRAE TIPO CAMBIO     --->
            <cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
              SELECT    Mcodigo 
              FROM      Empresas
              WHERE     Ecodigo = #Session.Ecodigo#
            </cfquery>
            <cfquery name="TCsug" datasource="#Session.DSN#">
              SELECT    tc.Mcodigo, tc.TCcompra as TCcompra, tc.TCventa AS TCventa
              FROM      Htipocambio tc
              WHERE     tc.Ecodigo = #Session.Ecodigo#
                AND     Mcodigo = #Form.Mcodigo#
              <cfif form.NumPago eq 1>
                AND     tc.Hfecha <= GETDATE()
                AND     tc.Hfechah > GETDATE()
              <cfelse>
                AND     tc.Hfecha <= <cf_jdbcquery_param cfsqltype="cf_sql_char"    value="#rsBuscaCobro.TCfecha#">
                AND     tc.Hfechah > <cf_jdbcquery_param cfsqltype="cf_sql_char"    value="#rsBuscaCobro.TCfecha#">
              </cfif>
            </cfquery>
            <cfif form.mcodigo EQ rsMonedaLocal.Mcodigo>
                <cfset TCcompra = 1>
            <cfelse>
                <cfset TCcompra = TCsug.TCcompra>
            </cfif>


            <cfinvoke component="sif.Componentes.CG_GeneraAsiento" Conexion="#session.dsn#" method="CreaIntarc" returnvariable="INTARC"/>
            <cfset intereses= #Form.IntDeveng.replace(",","")# * #TCcompra#>
            
            <!---   INTARC C     --->
            <cfquery name="rsDatos" datasource="#Session.DSN#">
            INSERT INTO #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
            VALUES      (<cf_jdbcquery_param cfsqltype="cf_sql_char"    value="CCAR">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="1">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Documento#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Documento#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Intereses#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="C">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Observaciones#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#year(form.fechaPagoEmpresa)##DateFormat(form.fechaPagoEmpresa,"MM")##day(form.fechaPagoEmpresa)#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#TCcompra#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#periodo.Pvalor#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#mes.Pvalor#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#form.CcuentaIGan#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.Mcodigo#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="0">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.IntDeveng#">
                        )
            </cfquery>
            <!---   INTARC D     --->
            <cfquery name="rsDatos" datasource="#Session.DSN#">
            INSERT INTO #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
            VALUES      (<cf_jdbcquery_param cfsqltype="cf_sql_char"    value="CCAR">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="1">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Documento#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Documento#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Intereses#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="D">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Observaciones#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#year(form.fechaPagoEmpresa)##DateFormat(form.fechaPagoEmpresa,"MM")##day(form.fechaPagoEmpresa)#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#TCcompra#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#periodo.Pvalor#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#mes.Pvalor#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#form.CcuentaIDif#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.Mcodigo#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="0">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.IntDeveng#">
                        )
            </cfquery>
            <cftransaction>
    <cfinvoke component="sif.Componentes.CG_GeneraAsiento" 
                Conexion="#session.dsn#" 
                method="GeneraAsiento" 
                returnvariable="IDcontable" 
                Ecodigo="#session.ecodigo#" 
                Usuario="#session.Usulogin#" 
                Oorigen="CCAR" 
                debug="false"
                Eperiodo="#periodo.Pvalor#" 
                Emes="#mes.Pvalor#" 
                Efecha="#Form.fechaPagoEmpresa#" 
                Edescripcion="Asiento reversible Arrendamiento #Form.NombreA#: #Form.fechaPagoEmpresa#." 
                Ereferencia="ESTIMAC.INCOBRABLES"
                Edocbase="#Form.fecha#"/>
        
    <!--- lo marca con un asiento reversible--->  
    <cfquery name="rsDatos" datasource="#session.dsn#">
        Update EContables
        Set ECreversible = 1
        Where IDcontable = #IDcontable#
    </cfquery> 

    <cfquery name="rsCobro" datasource="#Session.DSN#">
        UPDATE          TablaAmort
        SET             Estado = 1
        WHERE           Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#"> AND 
                        IDArrend = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.IDArrend#">  AND 
                        NumPago = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.cobrochk#">
    </cfquery>
    <cfset modo     = "CAMBIO">
    <cfset modoDet  = "CAMBIO">
    <cfif form.NumPago NEQ 1>
        <cfquery name="rsRef" datasource="#session.dsn#">
                    Update  TablaAmort
            set     RefCobro = '#rsBuscaCobro.Documento#'
            where   Ecodigo = #session.Ecodigo#
            AND     IDArrend = #Form.IDArrend#
            AND     NumPago=#Form.NumPago#
        </cfquery>
    </cfif>
</cftransaction>

<cfif Form.NumPago NEQ 1>
<!---   TRAE TIPO CAMBIO     --->
    <cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
        SELECT    Mcodigo 
        FROM      Empresas
        WHERE     Ecodigo = #Session.Ecodigo#
    </cfquery>
    <cfquery name="TCsug" datasource="#Session.DSN#">
      SELECT    tc.Mcodigo, tc.TCcompra as TCcompra, tc.TCventa AS TCventa
      FROM      Htipocambio tc
      WHERE     tc.Ecodigo = #Session.Ecodigo#
        AND     Mcodigo = #Form.Mcodigo#
        AND     tc.Hfecha <= <cf_jdbcquery_param cfsqltype="cf_sql_char"    value="#rsBuscaCobro.TCfecha#">
        AND     tc.Hfechah > <cf_jdbcquery_param cfsqltype="cf_sql_char"    value="#rsBuscaCobro.TCfecha#">
    </cfquery>
    <cfif form.mcodigo EQ rsMonedaLocal.Mcodigo>
        <cfset TCcompra = 1>
    <cfelse>
        <cfset TCcompra = TCsug.TCcompra>
    </cfif>
<cfinvoke component="sif.Componentes.CG_GeneraAsiento" Conexion="#session.dsn#" method="CreaIntarc" returnvariable="INTARC"/>
<cfquery name="rsIntereses2" datasource="#session.dsn#">
    SELECT Intereses FROM TablaAmort WHERE Ecodigo = #Session.Ecodigo# AND IDArrend = #Form.IDArrend# AND NumPago = #Form.NumPago#
</cfquery>
            <cfset intereses2= rsIntereses2.Intereses * #TCcompra#>
            
            <!---   INTARC C     --->
            <cfquery name="rsDatos" datasource="#Session.DSN#">
            INSERT INTO #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
            VALUES      (<cf_jdbcquery_param cfsqltype="cf_sql_char"    value="CCFC">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="1">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Documento#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Documento#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Intereses2#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="C">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Observaciones#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#year(rsBuscaCobro.fecha)##DateFormat(rsBuscaCobro.fecha,"MM")##day(rsBuscaCobro.fecha)#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#TCcompra#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#periodo.Pvalor#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#mes.Pvalor#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#form.CcuentaIGan#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.Mcodigo#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="0">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#rsIntereses2.Intereses#">
                        )
            </cfquery>
            <!---   INTARC D     --->
            <cfquery name="rsDatos" datasource="#Session.DSN#">
            INSERT INTO #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
            VALUES      (<cf_jdbcquery_param cfsqltype="cf_sql_char"    value="CCFC">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="1">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Documento#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Documento#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Intereses2#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="D">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Observaciones#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#year(rsBuscaCobro.fecha)##DateFormat(rsBuscaCobro.fecha,"MM")##day(rsBuscaCobro.fecha)#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#TCcompra#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#periodo.Pvalor#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#mes.Pvalor#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#form.CcuentaIDif#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.Mcodigo#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="0">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#rsIntereses2.Intereses#">
                        )
            </cfquery>
            <cftransaction>
    <cfinvoke component="sif.Componentes.CG_GeneraAsiento" 
                Conexion="#session.dsn#" 
                method="GeneraAsiento" 
                returnvariable="IDcontable" 
                Ecodigo="#session.ecodigo#" 
                Usuario="#session.Usulogin#" 
                Oorigen="CCFC" 
                debug="false"
                Eperiodo="#periodo.Pvalor#" 
                Emes="#mes.Pvalor#" 
                Efecha="#Form.fechaPagoEmpresa#" 
                Edescripcion="Documento de CxC: #rsBuscaCobro.Documento#." 
                Ereferencia="FS"
                Edocbase="#rsBuscaCobro.fecha#"/>

    <cfquery name="rsTCTabla" datasource="#session.dsn#">
        update TablaAmort set TipoCambio = #TCcompra#
        WHERE   IDArrend= #Form.IDArrend# AND Ecodigo = #Session.Ecodigo# AND NumPago= #Form.NumPago#-1
    </cfquery>
</cftransaction>
</cfif>
                <cflocation url="Arrendamiento.cfm?&idarrend=#idarrend#&modo=#modo#&mododet=#mododet#&urlira=#urlira#&tipocambio=#form.tipocambio#">
        <cfelseif rsBusPol.valor EQ 0 && rsBusHPol.valor EQ 0>
            <script type="text/javascript">
                <cfoutput>alert('No existe el cobro en el sistema');</cfoutput>
                history.back();
            </script>
        </cfif>
</cfif>

<!---   REGISTRA EL COBRO    --->
<cfif isDefined("form.RegUltCobro")>
    <cfquery name="rsExisteCob" datasource="#session.dsn#">
       SELECT  count(1)
         FROM  TablaAmort
        WHERE  Ecodigo = #session.Ecodigo# AND IDArrend = #Form.IDArrend#
            AND NumPago = #Form.NumMensualidades# AND Estado = 0
    </cfquery>
    <!---   TRAE CODIGO CONCEPTO ACTUAL  --->
    <cfquery name="rsCid" datasource="#session.dsn#">
        SELECT Cid 
        FROM CatalogoArrend 
        WHERE IDCatArrend = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.NombreArrend#"> 
        AND Ecodigo = #Session.Ecodigo#
    </cfquery>
    <!---   BUSCA FACTURA    --->
    <cfquery name="rsIntereses2" datasource="#session.dsn#">
        SELECT Intereses, PagoMensual as PagoMensual, IVA as IVA FROM TablaAmort WHERE Ecodigo = #Session.Ecodigo# AND IDArrend = #Form.IDArrend# AND NumPago = #Form.NumMensualidades#
    </cfquery>
    <cfset PagoMensual = LSnumberFormat(rsIntereses2.PagoMensual, "9,999.99")>
    <cfset IVA = LSnumberFormat(rsIntereses2.IVA, "9,999.99")>
    <cfset total = LSnumberFormat(replace(#PagoMensual#, ",","")+replace(#IVA#,",",""),"9.999.99")>

    <cfquery name="rsBuscaCobro" datasource="#session.dsn#">
        SELECT  a.Ddocumento as Documento, a.Dfecha as fecha
          FROM  HDocumentos a INNER JOIN HDDocumentos b on a.HDid = b.HDid
         WHERE  a.Ecodigo = #session.Ecodigo# 
           AND  a.EDperiodo = #periodo.Pvalor# 
           AND  a.EDmes = #mes.Pvalor# 
           AND  b.DDcodartcon = #rsCid.Cid# AND Dtotal = <cf_jdbcquery_param cfsqltype="cf_sql_money"  value="#Total#">
    </cfquery>

    <cfparam name="rsBusHPol.valor" default ="0">
    <cfparam name="rsBusPol.valor" default ="0">
    <cfquery name="rsCid" datasource="#session.dsn#">
        SELECT Cid 
        FROM CatalogoArrend 
        WHERE IDCatArrend = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.NombreArrend#"> 
        AND Ecodigo = #Session.Ecodigo#
    </cfquery>
    <cfquery name="rsBuscaCobro" datasource="#session.dsn#">
        SELECT  a.Ddocumento as Documento, a.Dfecha as fecha, EDtipocambioFecha as TCfecha
          FROM  HDocumentos a INNER JOIN HDDocumentos b on a.HDid = b.HDid
         WHERE  a.Ecodigo = #session.Ecodigo# 
           AND  a.EDperiodo = #periodo.Pvalor# 
           AND  a.EDmes = #mes.Pvalor# 
           AND  b.DDcodartcon = #rsCid.Cid# AND Dtotal = <cf_jdbcquery_param cfsqltype="cf_sql_money"  value="#Total#">
    </cfquery>
    <!---   TRAE TIPO CAMBIO     --->
    <cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
        SELECT    Mcodigo 
        FROM      Empresas
        WHERE     Ecodigo = #Session.Ecodigo#
    </cfquery>
    <cfquery name="TCsug" datasource="#Session.DSN#">
      SELECT    tc.Mcodigo, tc.TCcompra as TCcompra, tc.TCventa AS TCventa
      FROM      Htipocambio tc
      WHERE     tc.Ecodigo = #Session.Ecodigo#
        AND     Mcodigo = #Form.Mcodigo#
        AND     tc.Hfecha <= <cf_jdbcquery_param cfsqltype="cf_sql_char"    value="#rsBuscaCobro.TCfecha#">
        AND     tc.Hfechah > <cf_jdbcquery_param cfsqltype="cf_sql_char"    value="#rsBuscaCobro.TCfecha#">
    </cfquery>
    <cfif form.mcodigo EQ rsMonedaLocal.Mcodigo>
        <cfset TCcompra = 1>
    <cfelse>
        <cfset TCcompra = TCsug.TCcompra>
    </cfif>
    <cfinvoke component="sif.Componentes.CG_GeneraAsiento" Conexion="#session.dsn#" method="CreaIntarc" returnvariable="INTARC"/>
        <cfset intereses2= rsIntereses2.Intereses * #TCcompra#>
    <!---   INTARC C     --->
    <cfquery name="rsDatos" datasource="#Session.DSN#">
    INSERT INTO #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
    VALUES      (<cf_jdbcquery_param cfsqltype="cf_sql_char"    value="CCFC">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="1">,
                <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Documento#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Documento#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Intereses2#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="C">,
                <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Observaciones#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#year(rsBuscaCobro.fecha)##DateFormat(rsBuscaCobro.fecha,"MM")##day(rsBuscaCobro.fecha)#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#TCcompra#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#periodo.Pvalor#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#mes.Pvalor#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#form.CcuentaIGan#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.Mcodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="0">,
                <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#rsIntereses2.Intereses#">
                )
    </cfquery>
    <!---   INTARC D     --->
    <cfquery name="rsDatos" datasource="#Session.DSN#">
    INSERT INTO #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
    VALUES      (<cf_jdbcquery_param cfsqltype="cf_sql_char"    value="CCFC">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="1">,
                <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Documento#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Documento#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Intereses2#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="D">,
                <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Observaciones#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#year(rsBuscaCobro.fecha)##DateFormat(rsBuscaCobro.fecha,"MM")##day(rsBuscaCobro.fecha)#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#TCcompra#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#periodo.Pvalor#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#mes.Pvalor#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#form.CcuentaIDif#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.Mcodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="0">,
                <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#rsIntereses2.Intereses#">
                )
    </cfquery>
    <cftransaction>
        <cfinvoke component="sif.Componentes.CG_GeneraAsiento" 
                    Conexion="#session.dsn#" 
                    method="GeneraAsiento" 
                    returnvariable="IDcontable" 
                    Ecodigo="#session.ecodigo#" 
                    Usuario="#session.Usulogin#" 
                    Oorigen="CCFC" 
                    debug="false"
                    Eperiodo="#periodo.Pvalor#" 
                    Emes="#mes.Pvalor#" 
                    Efecha="#rsBuscaCobro.fecha#" 
                    Edescripcion="Documento de CxC: #rsBuscaCobro.Documento#." 
                    Ereferencia="FS"
                    Edocbase="#rsBuscaCobro.fecha#"/>
    <cfset modo     = "CAMBIO">
    <cfset modoDet  = "CAMBIO">
    <cfset modoUlt = "fin">
    <cfquery name="rsTCTabla" datasource="#session.dsn#">
        update TablaAmort set TipoCambio = #TCcompra#
        WHERE   IDArrend= #Form.IDArrend# AND Ecodigo = #Session.Ecodigo# AND NumPago= #Form.NumMensualidades#
    </cfquery>
    </cftransaction>
    <!---   FINALIZA ARRENDAMIENTO   --->
    <cfquery name="rsFinArr" datasource="#Session.DSN#">
        Update EncArrendamiento
        Set Estado = 1
        Where Ecodigo = #session.Ecodigo#
        And IDArrend = #form.IDArrend#
    </cfquery>

    <cflocation url="Arrendamiento.cfm?&idarrend=#idarrend#&modo=#modo#&mododet=#mododet#&urlira=#urlira#&tipocambio=#form.tipocambio#&modoUlt=#ModoUlt#">

</cfif>