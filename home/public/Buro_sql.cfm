<cfset Session.Ecodigo = 2>
<cfset Session.Dsn = "minisif">

<cfset crcCuenta = createObject("component","crc.Componentes.CRCCuentas")>

<cfset VERSION = "14"> <!--- Version ---> 
<cfset CLVUSU = "DS27530001"> <!--- Clave de Usuario --->
<cfset USU = fill("GRAN BAZAR",16)> <!--- Nombre de Usuario --->
<cfset INFOA = fill("",98)> <!--- Informacion Adicional --->

<cfset intf = "">
<!--- Segmento de Nombre de Encabezado - INTF --->
<cfset intf &="INTF#VERSION##CLVUSU##USU##fill("",2)#">

<!--- Segmento de Nombre de Encabezado - INTF ---> <!--- Ver duda de fecha --->
<cfset intf &="#DateFormat(now(),'DDMMYYY')##fill("0",10)##INFOA#">

<!--- Segmento de Nombre del Cliente o Acreditado - PN --->
<cfquery name="rsCuentas" datasource="#Session.Dsn#">
    select top 1 s.id_direccion,
        s.SNnombre, s.SNFechaNacimiento, s.SNidentificacion , isnull(s.Ppais, 'MX') Ppais,
		d.direccion1, isnull(d.Colonia,d.direccion2) Colonia, d.ciudad, d.estado, d.codPostal, isnull(d.Ppais, 'MX') Dpais,
        c.MontoAprobado, isnull(c.MontoAprobado,0) ctaMontoAprobado, isnull(c.SaldoActual,0) ctaSaldoActual, isnull(c.SaldoVencido,0) ctaSaldoVencido,
		c.Numero CtaNum, c.Tipo CtaTipo, c.createdat CtaFechaApertura, ic.MontoAPagar CtaMontoAPagar, ic.FechaFinCorte,
		up.fechaUltimoPago, uc.fechaUltimaCompra, up.Monto MontoUltimoPago, up.cantidad PagosVencidos,
        up.FechaPrimerIncumplimiento, si.SaldoInsoluto
    from CRCCuentas c
	inner join SNegocios s
        on c.SNegociosSNid = s.SNid
	inner join DireccionesSIF d
		on s.id_direccion = d.id_direccion
	inner join (
		select mcc.CRCCuentasid, mcc.Corte, c.FechaFin FechaFinCorte, 
            mcc.MontoAPagar - (mcc.MontoPagado + mcc.Descuentos + mcc.Condonaciones) MontoAPagar
		from CRCMovimientoCuentaCorte mcc
		inner join CRCCortes c
			on c.Codigo = mcc.Corte
		where c.status = 1
	) ic 
		on c.id = ic.CRCCuentasid
	left join (	
        select up.id CRCCuentasid, up.Tipo, up.Monto,
            cr.Codigo, up.Fecha FechaUltimoPago, , dateadd(day,1,cr.FechaFin) FechaPrimerIncumplimiento
            cc.Codigo CorteHasta, isnull(mcc.MontoPagado,0) MontoPagado,
            cantidad = (select count(1) -1 from CRCCortes where Codigo between cr.Codigo and cc.Codigo)
        from 
        (
            select c.id, c.Tipo, t.Monto, 
                isnull(max(t.Fecha) , (
                    select min(FechaInicioPago) 
                    from CRCTransaccion 
                    where TipoMov = 'C' and CRCCuentasid = c.id)
                ) Fecha
            from CRCCuentas c
            left join CRCTransaccion t  on t.CRCCuentasid = c.id and TipoTransaccion = 'PG'
            where c.SaldoActual > 0 and c.Tipo <> 'TM'
            and c.CRCEstatusCuentasid != (select Pvalor from CRCParametros where Pcodigo = '30100501' and Ecodigo = 2)
            group by c.id, c.Tipo, t.Monto
        ) up
        inner join CRCCortes cr on up.Fecha between cr.FechaInicio and cr.FechaFin and up.Tipo = cr.Tipo
        inner join (
            select Codigo, Tipo from CRCCortes where status = 1
        ) cc on cr.Tipo = cc.Tipo
        inner join (
                select t.CRCCuentasid, mc.Corte, isnull(sum(mc.Pagado),0) MontoPagado
                from CRCMovimientoCuenta mc 
                inner join CRCTransaccion t on mc.CRCTransaccionid = t.id 
                where mc.CRCConveniosid is null and mc.status = 1
                group by t.CRCCuentasid,mc.Corte
        ) mcc on up.id = mcc.CRCCuentasid 
        where ( select sum(MontoPagado) - sum(SaldoVencido)  
                from CRCMovimientoCuentaCorte 
                where CRCCuentasid = up.id and Corte BETWEEN cr.Codigo AND cc.Codigo
        ) <= 0
	) up
		on c.id = up.CRCCuentasid
	left join (
		select t.CRCCuentasid, max(Fecha) fechaUltimaCompra
		from CRCTransaccion t 
		where t.TipoTransaccion in ('VC','TC','TM')
		group by t.CRCCuentasid
	) uc
		on c.id = uc.CRCCuentasid
    left join (
        select t.CRCCuentasid,
            sum(mc.MontoRequerido) MontoRequerido, sum(mc.Pagado + mc.Descuento - mc.Intereses) PagadoNeto,
            case when sum(mc.MontoRequerido) - sum(mc.Pagado + mc.Descuento - mc.Intereses) > 0 
                then sum(mc.MontoRequerido) - sum(mc.Pagado + mc.Descuento - mc.Intereses)
                else 0
            end SaldoInsoluto
        from CRCTransaccion t
        inner join CRCMovimientoCuenta mc
        on t.id = mc.CRCTransaccionid
        where t.afectaCompras = 1
        group by t.CRCCuentasid
    ) si
    on c.id = si.CRCCuentasid
    where (s.TarjH = 1 or s.disT = 1 )
        and c.Ecodigo = #Session.Ecodigo#
        and s.SNnombre like '%,%'
</cfquery>

<cfloop query="rsCuentas">
    
    <!--- Segmento de Datos del Cliente - PN --->    
    <cfset aNombre  = listToArray(rsCuentas.SNnombre,",")>
    <cfset _nombre = left(trim(listToArray(aNombre[1]," ")[1]),26)>
    <cfset _nombre2 = arrayLen(listToArray(aNombre[1]," ")) gt 1 ? left(trim(listToArray(aNombre[1]," ")[2]),26) : "">
    <cfset _ape1 = left(trim(aNombre[2]),26)>
    <cfif arrayLen(aNombre) gt 2>
        <cfset _ape2 = left(trim(aNombre[3]),26)>
    <cfelse>
        <cfset _ape2 = "">
    </cfif>
    <cfset _fnacimiento = dateformat(rsCuentas.SNFechaNacimiento,"DDMMYYYY")>
    <cfset _rfc = left(trim(rsCuentas.SNidentificacion),13)>
    <cfset _nacionalidad = left(trim(rsCuentas.Ppais),2)>

    <cfset intf &=PValue("PN",_ape1)> <!--- Apellido paterno --->
    <cfset intf &=PValue("00",_ape2)> <!--- Apellido materno --->
    <cfset intf &=PValue("02",_nombre)> <!--- Primer Nombre --->
    <cfset intf &=PValue("03",_nombre2)> <!--- Segundo Nombre --->
    <cfset intf &=PValue("04",_fnacimiento)> <!--- FechaNacimiento --->
    <cfset intf &=PValue("05",_rfc)> <!--- FechaNacimiento --->
    <cfset intf &=PValue("08",_nacionalidad)> <!--- Nacionalidad --->

    <!--- Segmento de Dirección del Cliente - PA --->
    <cfset _dir = left(trim(rsCuentas.direccion1),40)>
    <cfset _colonia = left(trim(rsCuentas.Colonia),40)>
    <cfset _ciudad = left(trim(rsCuentas.Ciudad),40)>
    <cfset _estado = left(trim(rsCuentas.Estado),4)>
    <cfset _codPostal = left(trim(rsCuentas.codPostal),5)>
    <cfset _dpais = left(trim(rsCuentas.Dpais),2)>

    <cfset intf &=PValue("PA",_dir)> <!--- Direccion --->
    <cfset intf &=PValue("01",_colonia)> <!--- Colonia --->
    <cfset intf &=PValue("03",_ciudad)> <!--- Ciudad --->
    <cfset intf &=PValue("04",_estado)> <!--- Estado --->
    <cfset intf &=PValue("05",_codPostal)> <!--- codPostal --->
    <cfset intf &=PValue("12",_dpais)> <!--- pais --->

    <!--- Segmento de Empleo del Cliente – PE --->
    <!--- |  TODO  | --->

    <!--- Segmento de Cuenta o Crédito del Cliente - TL --->
    <cfset _ctaNum = trim(rsCuentas.CtaNum)>
    <cfset _ctaTipo = trim(rsCuentas.CtaTipo)>
    <cfset _fpagos = "Z"> <!--- Mensual --->
    <cfif _ctaTipo eq "D"> <cfset _fpagos = "S"> </cfif> <!--- Quincenal --->
    <cfset _ctaFechaApertura = DateFormat(rsCuentas.CtaFechaApertura,"DDMMYYYY")>
    <cfset _ctaMontoAPagar = trim(rsCuentas.CtaMontoAPagar)>
    <cfif _ctaTipo eq "TC"> 
        <cfset _ctaMontoAPagar = crcCuenta.getPagoMinino(_ctaMontoAPagar)> 
    <cfelseif _ctaTipo eq "D"> 
        <cfset _ctaMontoAPagar *= 2> 
    </cfif>
    <cfset _fechaUltimoPago = DateFormat(rsCuentas.fechaUltimoPago,"DDMMYYYY")>
    <cfset _fechaUltimaCompra = DateFormat(rsCuentas.fechaUltimaCompra,"DDMMYYYY")>
    <cfset _fechaFinCorte = DateFormat(rsCuentas.FechaFinCorte,"DDMMYYYY")>
    <cfset _ctaMontoAprobado = rsCuentas.ctaMontoAprobado>
    <cfset _ctaSaldoActual = rsCuentas.ctaSaldoActual>
    <cfset _ctaSaldoVencido = rsCuentas.ctaSaldoVencido>
    <cfset _ctaPagosVencidos = rsCuentas.PagosVencidos>
    <cfset _mop = "00">
    <cfif _ctaPagosVencidos neq 0>
        <cfset _mop = "02">
    </cfif>
    <cfset _fpi = "01011900">
    <cfif _ctaPagosVencidos neq 0>
        <cfset _fpi = DateFormat(rsCuentas.FechaPrimerIncumplimiento,"DDMMYYYY")>
    </cfif>
    <cfset _ctaMontoUltimoPago = rsCuentas.MontoUltimoPago>
    <cfset _ctaSaldoInsoluto = rsCuentas.SaldoInsoluto>

    <cfset intf &=PValue("TL","TL")> <!--- TL --->
    <cfset intf &=PValue("01",CLVUSU)> <!--- Clave de Usuario --->
    <cfset intf &=PValue("02",USU)> <!--- Nombre de Usuario --->
    <cfset intf &=PValue("04",_ctaNum)> <!--- Cuenta Numero --->
    <cfset intf &=PValue("05","I")> <!--- Responsabilidad de Cuenta --->      <!--- |  TODO  | --->
    <cfset intf &=PValue("06","R")> <!--- Tipo de Cuenta --->                 <!--- |  TODO  | --->
    <cfset intf &=PValue("07","TJ")> <!--- Tipo Contrato o Producto --->      <!--- |  TODO  | --->
    <cfset intf &=PValue("08","MX")> <!--- Moneda del Credito --->
    
    <!---
        <cfset intf &=PValue("09","MX")> <!--- Importe Avaluo --->
        <cfset intf &=PValue("10","MX")> <!--- Numero de Pagos --->
    --->
    <cfset intf &=PValue("11",_fpagos)> <!--- Frecuencias ed Pagos --->
    <cfset intf &=PValue("12",LSNumberFormat(_ctaMontoAPagar,"9.99"))> <!--- Monto a Pagar --->
    <cfset intf &=PValue("13",_ctaFechaApertura)> <!--- Cuenta Fecha Apertura --->
    <cfset intf &=PValue("14",_fechaUltimoPago)> <!--- Cuenta Fecha Ultimo Pago --->
    <cfset intf &=PValue("15",_fechaUltimaCompra)> <!--- Cuenta Fecha Ultima Compra --->
    <cfset intf &=PValue("16",_fechaFinCorte)> <!--- Fecha Cierre --->
    <cfset intf &=PValue("17",DateFormat(now(),'DDMMYYY'))> <!--- Fecha Reporte --->
    <cfset intf &=PValue("21",LSNumberFormat(_ctaMontoAprobado,'9.99'))> <!--- Monto Aprobado --->
    <cfset intf &=PValue("22",LSNumberFormat(_ctaSaldoActual,'9.99'))> <!--- Saldo Actual --->
    <cfset intf &=PValue("23",LSNumberFormat(_ctaMontoAprobado,'9.99'))> <!--- Limite Credito --->
    <cfset intf &=PValue("24",LSNumberFormat(_ctaSaldoVencido,'9.99'))> <!--- Saldo Vencido --->
    <cfset intf &=PValue("25",_ctaPagosVencidos)> <!--- Pagos Vencidos --->
    <cfset intf &=PValue("26",_mop)> <!--- TODO FORMA DE PAGO ACTUAL (MOP) --->
    <cfset intf &=PValue("43",_fpi)> <!--- Fecha primer incumplimiento--->
    <cfset intf &=PValue("44",LSNumberFormat(_ctaSaldoInsoluto,'9.99'))> <!--- Saldo Insoluto --->
    <cfset intf &=PValue("45",LSNumberFormat(_ctaMontoUltimoPago,'9.99'))> <!--- Monto ultimo pago --->
    <cfset intf &=PValue("46",_fpi)> <!--- Fecha Ingreso Cartera Vencida --->

    <cfset intf &=PValue("99","FIN")> <!--- FIN TL --->

</cfloop>
<cfdump  var="#intf#" abort>
<!--- Validacion y creacion de carpetar para almacenar Facturas --->
<cf_foldersFacturacion>
<cffile action = "write" file = "C:\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\Buro\B201811.txt" output = "#intf#">

<cfheader name="Content-Disposition" value="attachment; filename=C:\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\Buro\B201811.txt">
<cfcontent type="text/html" file="C:\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\Buro\B201811.txt" deletefile="no" reset="yes">



<cffunction name="PValue" returntype = "string">
    <cfargument  name="code" type="string" required="true">
    <cfargument  name="value" type="string" required="true">

    <cfset result="">
    <cfset result &="#arguments.code#">
    <cfif len(arguments.value) gt 0 >
        <cfset result &="#right("00"&len(trim(arguments.value)),2)#"> 
    </cfif>
    <cfset result &="#trim(arguments.value)#">
    <cfreturn result>

</cffunction>

<cffunction  name="fill" returntype = "string">
    <cfargument  name="expresion" type="string" required="true">
    <cfargument  name="fillTo" type="numeric" required="true">
    <cfargument  name="char" type="string" required="false" default=" ">
    <cfargument  name="fillRight" type="boolean" required="false" default="true">

    <cfset result = (trim(arguments.expresion) eq "" ? "<>" : arguments.expresion)>
    <cfset _fill = "">
    <cfloop index="index" from="1" to="#arguments.fillTo#">
        <cfset _fill &= arguments.char>
    </cfloop>

    <cfif arguments.fillRight>
        <cfset result = left(replace(result&_fill,"<>"," ","all"),arguments.fillTo)>
    </cfif>
    <cfset result = right(replace(_fill&result,"<>"," ","all"),arguments.fillTo)>

    <cfreturn result>
</cffunction>