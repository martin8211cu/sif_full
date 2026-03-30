<cfset showForm = true>
<cfset crcCuenta = createObject("component","crc.Componentes.CRCCuentas")>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Buro de Credito" returnvariable="LB_Title"/>
<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		<!--- <cfdump var="#form#"> --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td>
					<cfinclude template="/home/menu/pNavegacion.cfm">
				</td>
			</tr>
			<tr>
				<td align="center">
					<cfif structKeyExists(variables, "errors")>
						<cfoutput>
						<p>
						<b>Error: #variables.errors#</b>
						</p>
						</cfoutput>
					</cfif>
					<br>
					<form action="" enctype="multipart/form-data" method="post">
                          <cfquery name="rsaAnho" datasource="#session.dsn#">
                            select distinct year(FechaFin) anno 
                            from CRCCortes 
                            where Ecodigo = #session.ecodigo# 
                                and year(FechaFin) <= year(getdate()) and year(getdate()) - year(FechaFin) between 0 and 1
                            order by year(FechaFin) desc
                          </cfquery>
                          <label>A&ntilde;o</label>
                          <select name="year">
                            <cfoutput query="rsaAnho">
                                <option value="#anno#">#anno#</option>
                            </cfoutput>
                          </select> 
                          <label>Mes</label>
                          <select name="month">
                            <option <cfif month(now()) eq "2"> selected </cfif> value="01">Enero</option>
                            <option <cfif month(now()) eq "3"> selected </cfif> value="02">Febrero</option>
                            <option <cfif month(now()) eq "4"> selected </cfif> value="03">Marzo</option>
                            <option <cfif month(now()) eq "5"> selected </cfif> value="04">Abril</option>
                            <option <cfif month(now()) eq "6"> selected </cfif> value="05">Mayo</option>
                            <option <cfif month(now()) eq "7"> selected </cfif> value="06">Junio</option>
                            <option <cfif month(now()) eq "8"> selected </cfif> value="07">Julio</option>
                            <option <cfif month(now()) eq "9"> selected </cfif> value="08">Agosto</option>
                            <option <cfif month(now()) eq "10"> selected </cfif> value="09">Septiembre</option>
                            <option <cfif month(now()) eq "11"> selected </cfif> value="10">Octubre</option>
                            <option <cfif month(now()) eq "12"> selected </cfif> value="11">Noviembre</option>
                            <option <cfif month(now()) eq "1"> selected </cfif> value="12">Diciembre</option>
                          </select>
						  <br>
						  <br>
						  <input type="submit" class="btnImprimir" value="Generar">
						  <input type="reset" class="btnLimpiar" value="Limpiar">
						  
					</form>
				</td>
			</tr>
			<tr>
				<td>
					&nbsp;
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
    
<cfif structKeyExists(form, "year")>
    <cfset VERSION = "14"> <!--- Version ---> 
    <cfset CLVUSU = "DS27530001"> <!--- Clave de Usuario --->
    <cfset USU = fill("COMARCA FULL",16)> <!--- Nombre de Usuario --->
    <cfset INFOA = fill("",98)> <!--- Informacion Adicional --->

    <cfset intf = "">
    <!--- Segmento de Nombre de Encabezado - INTF --->
    <cfset intf &="INTF#VERSION##CLVUSU##USU#  ">

    <cfset myDate=CreateDate(form.year,form.month,1)>
    <cfset DaysInMonth1= DaysInMonth(myDate)>

    <cfset _day= right('#DaysInMonth1#',2)>   
    <cfset _month= right('00#form.month#',2)>   

    <!--- Segmento de Nombre de Encabezado - INTF ---> <!--- Ver duda de fecha --->
    <cfset intf &="#fill("#_day##_month##form.year#",18,"0",true)##INFOA#">
    
    <!--- Ultima fecha mes seleccionado --->
    <cfset fechaMesSel = CreateDate(#form.year#, #form.month#, 1)>
    <cfset utmFechaMesSelec = CreateDate(#form.year#, #form.month#, #DaysInMonth(fechaMesSel)#)>

    <!--- Segmento de Nombre del Cliente o Acreditado - PN --->
    <cfquery name="rsCuentas" datasource="#Session.Dsn#">
         SELECT c.id,
                s.id_direccion,
                s.SNnombre,
                s.SNFechaNacimiento,
                s.SNidentificacion,
                isnull(s.Ppais, 'MX') Ppais,
                replace(d.direccion1, '##', '') direccion1,
                isnull(d.Colonia, d.direccion2) Colonia,
                d.ciudad,
                d.estado,
                d.codPostal,
                isnull(d.Ppais, 'MX') Dpais,
                c.MontoAprobado,
                ic.Corte,
                isnull(c.MontoAprobado, 0) ctaMontoAprobado,
                CASE
                    WHEN TblSaldos.SaldoActual > 0
                            AND TblSaldos.SaldoActual < 1 THEN CAST((ROUND(TblSaldos.SaldoActual, 0, 0)) AS INT)
                    WHEN TblSaldos.SaldoActual < 0
                            AND TblSaldos.SaldoActual < 1 THEN 0
                    ELSE TblSaldos.SaldoActual
                END AS ctaSaldoActual,
                CASE
                    WHEN TblSaldos.SaldoVencido > 0
                            AND TblSaldos.SaldoVencido < 1 THEN CAST((ROUND(TblSaldos.SaldoVencido, 0, 0)) AS INT)
                    WHEN TblSaldos.SaldoVencido < 0
                            AND TblSaldos.SaldoVencido < 1 THEN 0
                    ELSE TblSaldos.SaldoVencido
                END AS ctaSaldoVencido,
                c.Numero CtaNum,
                c.Tipo CtaTipo,
                c.createdat CtaFechaApertura,
                isnull(CASE
                    WHEN ic.MontoAPagar > 0 AND ic.MontoAPagar < 1 THEN CAST((ROUND(ic.MontoAPagar, 0, 0)) AS INT)
                    WHEN ic.MontoAPagar < 0 AND ic.MontoAPagar < 1 THEN 0
                    ELSE  ic.MontoAPagar
                END,0) AS CtaMontoAPagar,
                ic.FechaFinCorte,
                up.fechaUltimoPago,
                CASE
                    WHEN TblSaldos.SaldoActual > 0
                            AND uc.fechaUltimaCompra IS NULL THEN '#DateFormat(utmFechaMesSelec,"YYYY-MM-DD")#'
                    ELSE uc.fechaUltimaCompra
                END AS fechaUltimaCompra,
                /* uc.fechaUltimaCompra, */
                isnull(up.Monto, 0) MontoUltimoPago,
                ISNULL(up.cantidad, 0) PagosVencidos,
                up.FechaPrimerIncumplimiento,
                ISNULL(si.SaldoInsoluto, 0) SaldoInsoluto,
                TransaccionesMes.NumTr,
                CtaNueva.NumCortes
            FROM CRCCuentas c
            INNER JOIN SNegocios s ON c.SNegociosSNid = s.SNid
            INNER JOIN DireccionesSIF d ON s.id_direccion = d.id_direccion
            LEFT JOIN
            (SELECT COUNT(1) NumTr,
                    CRCCuentasid
            FROM CRCTransaccion
            WHERE YEAR(Fecha) = #form.year#
                AND MONTH(Fecha) = #form.month#
            GROUP BY CRCCuentasid)TransaccionesMes ON TransaccionesMes.CRCCuentasid = c.id
            LEFT JOIN
            (SELECT COUNT(1) NumCortes,
                    CRCCuentasid
            FROM CRCMovimientoCuentaCorte
            WHERE cerrado = 1
            GROUP BY CRCCuentasid)CtaNueva ON CtaNueva.CRCCuentasid = c.id
            LEFT JOIN
            (SELECT mcc.CRCCuentasid,
                    mcc.Corte,
                    c.FechaFin FechaFinCorte,
                    mcc.MontoAPagar - (mcc.MontoPagado + mcc.Descuentos + mcc.Condonaciones) MontoAPagar
            FROM CRCMovimientoCuentaCorte mcc
            INNER JOIN CRCCortes c ON c.Codigo = mcc.Corte
            WHERE c.status >= 1
                AND (c.Codigo = 'D#form.year##form.month#02' AND c.Tipo = 'D') 
                 OR (c.Codigo = CONCAT(LTRIM(RTRIM(c.Tipo)),'#form.year##form.month#')  AND c.Tipo <> 'D'))ic ON c.id = ic.CRCCuentasid
            LEFT JOIN
            (SELECT up.id CRCCuentasid,
                    up.Tipo,
                    up.Monto,
                    cr.Codigo,
                    up.Fecha FechaUltimoPago,
                    dateadd(DAY, 1, cr.FechaFin) FechaPrimerIncumplimiento,
                    cc.Codigo CorteHasta,
                    isnull(mcc.MontoPagado, 0) MontoPagado,
                    cantidad =
                (SELECT count(1) -1
                FROM CRCCortes
                WHERE Codigo BETWEEN cr.Codigo AND cc.Codigo)
            FROM
                (SELECT c.id,
                        c.Tipo,
                        Monto =
                    (SELECT TOP 1 T.Monto
                    FROM CRCTransaccion t
                    WHERE TipoTransaccion = 'PG'
                    AND t.CRCCuentasid = c.id
                    ORDER BY Fecha DESC),
                        Fecha = (isnull(
                                        (SELECT MAX(Fecha)
                                            FROM CRCTransaccion t
                                            WHERE t.CRCCuentasid = c.id
                                            AND TipoTransaccion = 'PG') ,
                                        (SELECT MIN(FechaInicioPago)
                                            FROM CRCTransaccion t
                                            WHERE t.CRCCuentasid = c.id
                                            AND TipoMov = 'C')))
                FROM CRCCuentas c
                WHERE c.SaldoActual > 0
                    AND c.Tipo <> 'TM'
                    AND c.CRCEstatusCuentasid !=
                    (SELECT Pvalor
                    FROM CRCParametros
                    WHERE Pcodigo = '30100501'
                        AND Ecodigo = 2)
                GROUP BY c.id,
                        c.Tipo) up
            INNER JOIN CRCCortes cr ON up.Fecha BETWEEN cr.FechaInicio AND cr.FechaFin
            AND up.Tipo = cr.Tipo
            INNER JOIN
                (SELECT Codigo,
                        Tipo
                FROM CRCCortes
                WHERE status >= 1
                    AND (Codigo = 'D#form.year##form.month#02' AND Tipo = 'D') 
	                 OR (Codigo = CONCAT(LTRIM(RTRIM(Tipo)),'#form.year##form.month#'))) cc ON cr.Tipo = cc.Tipo
            INNER JOIN
                (SELECT t.CRCCuentasid,
                        mc.Corte,
                        isnull(sum(mc.Pagado), 0) MontoPagado
                FROM CRCMovimientoCuenta mc
                INNER JOIN CRCCortes c ON c.Codigo = mc.Corte
                INNER JOIN CRCTransaccion t ON mc.CRCTransaccionid = t.id
                WHERE mc.CRCConveniosid IS NULL
                    AND mc.status >= 1
                    AND (c.Codigo = 'D#form.year##form.month#02' AND c.Tipo = 'D') 
	                 OR (c.Codigo = CONCAT(LTRIM(RTRIM(c.Tipo)),'#form.year##form.month#')  AND c.Tipo <> 'D')
                GROUP BY t.CRCCuentasid,
                        mc.Corte) mcc ON up.id = mcc.CRCCuentasid
                        AND mcc.Corte = cc.Codigo
            WHERE
                (SELECT sum(MontoPagado) - sum(SaldoVencido)
                    FROM CRCMovimientoCuentaCorte
                    WHERE CRCCuentasid = up.id
                    AND Corte BETWEEN cr.Codigo AND cc.Codigo ) <= 0 
            AND CONVERT(VARCHAR(10),up.Fecha,23) <= <cfqueryparam cfsqltype="cf_sql_date" value="#utmFechaMesSelec#">) up ON c.id = up.CRCCuentasid
            AND up.CorteHasta = ic.Corte
            LEFT JOIN
            (SELECT t.CRCCuentasid,
                    max(Fecha) fechaUltimaCompra
            FROM CRCTransaccion t
            WHERE t.TipoMov = 'C'
              AND t.TipoTransaccion IN ('VC',
                                        'TC',
                                        'TM',
                                        'IN',
                                        'GC')
                /* Se condiciona la fecha, porque no puede ser mayor a la fecha de la generacion del reporte */
                AND CONVERT(VARCHAR(10),t.Fecha,23) <= <cfqueryparam cfsqltype="cf_sql_date" value="#utmFechaMesSelec#">
            GROUP BY t.CRCCuentasid) uc ON c.id = uc.CRCCuentasid
            LEFT JOIN
            (SELECT t.CRCCuentasid,
                    sum(mc.MontoRequerido) MontoRequerido,
                    sum(mc.Pagado + mc.Descuento - mc.Intereses) PagadoNeto,
                    CASE
                        WHEN sum(mc.MontoRequerido) - sum(mc.Pagado + mc.Descuento - mc.Intereses) > 0 THEN sum(mc.MontoRequerido) - sum(mc.Pagado + mc.Descuento - mc.Intereses)
                        ELSE 0
                    END SaldoInsoluto
            FROM CRCTransaccion t
            INNER JOIN CRCMovimientoCuenta mc ON t.id = mc.CRCTransaccionid
            WHERE t.afectaCompras = 1
            GROUP BY t.CRCCuentasid) si ON c.id = si.CRCCuentasid
            LEFT JOIN
            (SELECT CRCCuentasid,
                    MontoAPagar AS SaldoActual,
                    SaldoVencido,
                    Corte
            FROM CRCMovimientoCuentaCorte
            WHERE Corte LIKE '%#form.year##form.month#%')TblSaldos ON c.id = TblSaldos.CRCCuentasid
            AND ic.Corte = TblSaldos.Corte                
            WHERE (s.TarjH = 1
                OR s.disT = 1)
            AND c.Ecodigo = #Session.Ecodigo#
            AND s.SNnombre LIKE '%,%'
            AND (up.fechaUltimoPago IS NOT NULL
                OR uc.fechaUltimaCompra IS NOT NULL)
            /* AND s.SNnombre like '%RODRIGUEZ%'
	        AND s.SNnombre like '%FLAVIO%' */
    </cfquery>
    
    <cfset intf = "#intf##chr(13)##chr(10)#">

<!--- <cfdump  var="#rsCuentas#"> --->

    <!--- totales --->
    <cfset tSaldoActual = 0>
    <cfset tSaldoVencido = 0>
    
    <cfloop query="rsCuentas">
        
        <!--- Segmento de Datos del Cliente - PN --->    
        <cfset aNombre  = listToArray(rsCuentas.SNnombre,",")>
        <cfset _nombre = left(trim(listToArray(aNombre[1]," ")[1]),26)>
        <cfset _nombre2 = arrayLen(listToArray(aNombre[1]," ")) gt 1 ? left(trim(listToArray(aNombre[1]," ")[2]),26) : "00">
        <cfset _ape1 = arrayLen(listToArray(aNombre[2],",")) gt 1 ? left(trim(listToArray(aNombre[2]," ")[ArrayLen(aNombre)]),26) : left(trim(aNombre[2]),26)>
        <cfset _ape1 = left(trim(aNombre[2]),26)>
        <cfif arrayLen(aNombre) gt 2>
            <cfset _ape2 = left(trim(aNombre[3]),26)>
        <cfelse>
            <cfset _ape2 = "NO PROPORCIONADO">
        </cfif>
        <cfset _fnacimiento = dateformat(rsCuentas.SNFechaNacimiento,"DDMMYYYY")>
        <cfset _rfc = left(trim(rsCuentas.SNidentificacion),13)>
        <cfset _nacionalidad = left(trim(rsCuentas.Ppais),2)>

        <cfset intf &=PValue("PN",_ape1)> <!--- Apellido paterno --->
        <cfset intf &=PValue("00",_ape2)> <!--- Apellido materno --->
        <cfset intf &=PValue("02",_nombre)> <!--- Primer Nombre --->
		<cfif _nombre2 EQ '00'>
			<cfset intf &=PValue("03",_nombre2,false)> <!--- Segundo Nombre --->
		<cfelse>
            <cfset intf &=PValue("03",_nombre2)> <!--- Segundo Nombre --->
        </cfif>
        <cfset intf &=PValue("04",_fnacimiento)> <!--- FechaNacimiento --->
        <cfset intf &=PValue("05",_rfc)> <!--- FechaNacimiento --->
        <cfset intf &=PValue("08",_nacionalidad)> <!--- Nacionalidad --->

        <!--- Segmento de Dirección del Cliente - PA --->
        <cfset _dir = left(trim(rsCuentas.direccion1),40)>
        <cfset _colonia = left(trim(rsCuentas.Colonia),40)>
        <cfset _ciudad = left(trim(rsCuentas.Ciudad),40)>
        <cfif FindNoCase("COA",rsCuentas.Estado) NEQ 0>
            <cfset _estado = 'COA'>
        <cfelseif FindNoCase("DGO",rsCuentas.Estado) NEQ 0>
            <cfset _estado = 'DGO'>
        </cfif>
        <cfset _codPostal = NumberFormat(left(trim(rsCuentas.codPostal),5),'00000')>
        <cfset _dpais = left(trim(rsCuentas.Dpais),2)>

        <cfset intf &=PValue("PA",_dir)> <!--- Direccion --->
        <cfset intf &=PValue("01",_colonia)> <!--- Colonia --->
        <cfset intf &=PValue("02",_ciudad)> <!--- DELEGACION O MUNICIPIO --->
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
        
        <!--- No puede existir pagos vencidos en 0, con saldo vencido --->
        <cfif _ctaPagosVencidos EQ 0>
            <cfset _ctaSaldoVencido = 0>
        </cfif>

        <cfif rsCuentas.NumCortes eq 0>
            <cfset _mop = "00"> <!--- Para creditos nuevos --->
        <cfelseif _ctaPagosVencidos eq 0 OR _ctaSaldoVencido EQ 0>
            <cfset _mop = "01"> <!--- Cuenta al corriente, 0 días de atraso de su fecha límite de pago (1 a 29 días transcurridos de su fecha de facturación --->
        <cfelseif _ctaPagosVencidos GT 0 AND rsCuentas.NumCortes GT 0 AND _ctaSaldoVencido GT 0>
            <cfset _mop = "02"> <!--- ATRASADO ---> <!--- 1 a 29 dias de atraso de su fecha limite de pago (30 a 59 dias transcurridos de su fecha de facturación --->
        <cfelseif rsCuentas.NumCortes EQ 0 AND _ctaSaldoActual GT 0 AND _ctaSaldoVencido EQ 0>
            <cfset _mop = "UR">
        </cfif>

        <cfset _fpi = "01011900">
        <cfif _ctaPagosVencidos neq 0>
            <cfset _fpi = DateFormat(rsCuentas.FechaPrimerIncumplimiento,"DDMMYYYY")>
        </cfif>
        <cfset _ctaMontoUltimoPago = rsCuentas.MontoUltimoPago>
        <cfset _ctaSaldoInsoluto = rsCuentas.SaldoInsoluto>

        <cfif _ctaMontoAPagar EQ 0>
            <!--- Si _ctaMontoAPagar es 0, el saldo actual se manda en 00,
                  Por lo tanto el saldo insoluto no puede ser mayor,
                  entonces se pone en 0 --->
            <cfset _ctaSaldoInsoluto = 0>
        </cfif>

        <!---<cfset intf = "#intf##chr(13)##chr(10)#">--->
        <cfset intf &=PValue("TL","TL")> <!--- TL --->
        <cfset intf &=PValue("01",CLVUSU)> <!--- Clave de Usuario --->
        <cfset intf &=PValue("02",USU)> <!--- Nombre de Usuario --->
        <cfset intf &=PValue("04",_ctaNum)> <!--- Cuenta Numero --->
        <cfset intf &=PValue("05","I")> <!--- Responsabilidad de Cuenta --->      <!--- |  TODO  | --->
        <cfset intf &=PValue("06","R")> <!--- Tipo de Cuenta I = Pagos Fijos, M = Hipoteca, O = Sin Limite Pre-establecido, R = Revolvente --->                 <!--- |  TODO  | --->
        <!--- Tipo Contrato o Producto --->
        <cfif _ctaTipo EQ 'D'>
            <cfset intf &=PValue("07","CL")> <!--- Linea de Crédito --->
        <cfelseif _ctaTipo EQ 'TC'>
            <cfset intf &=PValue("07","CC")> <!--- Tarjeta de Crédito --->
        </cfif>
        
        <cfset intf &=PValue("08","MX")> <!--- Moneda del Credito --->
        
        <!--- NUMERO DE PAGOS  CON VALOR [10010]--->
        <cfset intf &=PValue("10","0")> <!--- Numero de Pagos --->
        <!---
            <cfset intf &=PValue("09","MX")> <!--- Importe Avaluo --->
            <cfset intf &=PValue("10","MX")> <!--- Numero de Pagos --->
        --->
        <cfset intf &=PValue("11",_fpagos)> <!--- Frecuencias ed Pagos --->
        <cfset intf &=PValue("12",Round(_ctaMontoAPagar))> <!--- Monto a Pagar --->
        <cfset intf &=PValue("13",_ctaFechaApertura)> <!--- Cuenta Fecha Apertura --->
        
        <cfif _fechaUltimaCompra EQ ''>
            <!--- Se reporta la FECHA DE ULTIMO PAGO, cuando no se cuente con la fecha de ultima compra --->
            <cfset intf &=PValue("14",_fechaUltimoPago)> <!--- Cuenta Fecha Ultimo Pago --->            
            <cfset intf &=PValue("1500", "")> <!--- Cuenta Fecha Ultima Compra 00--->
        <cfelseif _fechaUltimoPago EQ ''>
            <cfset intf &=PValue("1400","")> <!--- Cuenta Fecha Ultimo Pago en 00--->
            <!--- Se reporta la FECHA DE ULTIMA COMPRA, cuando no se cuente con la fecha de ultimo pago --->
            <cfset intf &=PValue("15",_fechaUltimaCompra)> <!--- Cuenta Fecha Ultima Compra --->
        <cfelse>
            <!--- SI NO ESTA VACIA NINGUNA, SE AGREGAN LAS DOS --->
            <cfset intf &=PValue("14",_fechaUltimoPago)> <!--- Cuenta Fecha Ultimo Pago --->
            <cfset intf &=PValue("15",_fechaUltimaCompra)> <!--- Cuenta Fecha Ultima Compra --->
        </cfif>
        
        <!--- <cfset intf &=PValue("16",_fechaFinCorte)> Fecha Cierre SOLO PARA INDICAR QUE ES CIERRE DE CREDITO--->
        <cfset intf &=PValue("17",DateFormat(utmFechaMesSelec,'DDMMYYY'))> <!--- Fecha Reporte --->
        <cfset intf &=PValue("21",Round(_ctaMontoAprobado))> <!--- Monto Aprobado --->
        <!--- Saldo Actual --->
        <cfif _ctaMontoAPagar EQ 0>
            <cfset intf &=PValue("2200","")>
        <cfelse>
            <cfif _ctaSaldoActual LT _ctaSaldoInsoluto>
                <cfset intf &=PValue("22",Round(_ctaSaldoInsoluto))> 
                <cfset tSaldoActual += Round(_ctaSaldoInsoluto)>
            <cfelse>
                <cfset intf &=PValue("22",Round(_ctaSaldoActual))>
                <cfset tSaldoActual += Round(_ctaSaldoActual)>
            </cfif>            
        </cfif>
        <cfset intf &=PValue("23",Round(_ctaMontoAprobado))> <!--- Limite Credito --->
        <!--- Saldo Vencido --->
        <cfif _ctaSaldoVencido EQ 0>
            <cfset intf &=PValue("2400","")> <!--- 00 --->
        <cfelse>
            <cfset intf &=PValue("24",Round(_ctaSaldoVencido))>
        </cfif>
        <cfset tSaldoVencido += Round(_ctaSaldoVencido)>
        <cfset intf &=PValue("25",_ctaPagosVencidos)> <!--- Pagos Vencidos --->
        <cfset intf &=PValue("26",_mop)> <!--- TODO FORMA DE PAGO ACTUAL (MOP) --->
        <cfset intf &=PValue("43",_fpi)> <!--- Fecha primer incumplimiento--->
        
        <!--- Saldo Insoluto --->
        <cfset intf &=PValue("44",Round(_ctaSaldoInsoluto))>      
        <cfset intf &=PValue("45",Round(_ctaMontoUltimoPago))> <!--- Monto ultimo pago --->
        <cfset intf &=PValue("46",_fpi)> <!--- Fecha Ingreso Cartera Vencida --->
        <cfset intf &=PValue("50","0")> <!--- PLAZO EN MESES, CUANDO NO APLIQUE ES CERO, SOLO APLICA PARA (TAG 06: M o I) --->
        <cfset intf &=PValue("51",Round(_ctaMontoAprobado))> <!--- MONTO DE CRÉDITO A LA ORIGINACIÓN: Pagos fijos o hipotecarios: Monto del Crédito. Revolventes: Limite de Crédito Y Abiertos(Sin limite): Se omite Etiqueta  --->
        <cfset intf &=PValue("99","FIN")> <!--- FIN TL --->
    </cfloop>

    <!--- SEGMENTO DE CIERRE --->

    <cfset intf &= "#chr(13)##chr(10)#">
    <cfset intf &= "TRLR"> 
    <cfset intf &= "#fill(tSaldoActual,14,0,false)#"> 
    <cfset intf &= "#fill(tSaldoVencido,14,0,false)#"> 
    <cfset intf &= "#fill(1,3,0,false)#"> <!--- total de segmentos INTF --->
    <cfset intf &= "#fill(rsCuentas.recordCount,9,0,false)#"> <!--- total de segmentos PN --->
    <cfset intf &= "#fill(rsCuentas.recordCount,9,0,false)#"> <!--- total de segmentos PA --->
    <cfset intf &= "#fill(0,9,0,false)#"> <!--- total de segmentos PE --->
    <cfset intf &= "#fill(rsCuentas.recordCount,9,0,false)#"> <!--- total de segmentos TL --->
    <!---<cfset intf &= "#chr(13)##chr(10)#">--->
    <cfset intf &= "#fill(0,6,0,false)#"> <!--- Contador de bloques --->
    <cfset intf &= "#fill("COMARCA FULL",16)#"> <!--- Nombre usuario devolucion --->
    <cfset intf &= "#UCASE(fill("Calzada Rodriguez Sur 2988 Colonia Centro Torreon Coahuila",160))#"> <!--- Direccion validacion --->
	
    <cfset NL = Chr(13)&Chr(10)>

    <cfset intf = replace(intf, NL, '', 'All')>
	<cfif rsCuentas.RecordCount GT 0>
		<cffile action = "write" file = "C:\Enviar\Buro\INFT_#form.year##form.month#.txt" output = "#intf#">
		<cfheader name="Content-Disposition" value="attachment; filename=INFT_#form.year##form.month#.txt">
		<cfcontent type="text/html" file="C:\Enviar\Buro\INFT_#form.year##form.month#.txt" deletefile="no" reset="yes">
	</cfif>
    

</cfif>

<cffunction name="PValue" returntype = "string">
    <cfargument  name="code" type="string" required="true">
    <cfargument  name="value" type="string" required="true">
    <cfargument  name="withLen" type="string" default="true" required="false">

    <cfset result="">
	<cfset result &="#arguments.code#">
    <cfset cleanText = generateSlug(arguments.value)>
    <cfif len(arguments.value) gt 0 AND arguments.withLen EQ true>
        <cfset result &="#right('00#len(trim(cleanText))#',2)#"> 
    </cfif>
    <cfset result &="#trim(cleanText)#">
    <cfreturn result>

</cffunction>

<cffunction name="generateSlug" output="false" returnType="string">
    <cfargument name="str" default="">

    <cfset ret = ReplaceList(str, 
    "À,Á,Â,Ã,Ä,Å,Æ,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,Ø,Ù,Ú,Û,Ü,Ý,à,á,â,ã,ä,å,æ,è,é,ê,ë,ì,i,î,ï,Ñ,ñ,ò,ó,ô,õ,ö,ø,ù,ú,û,ü,ý", 
    "A,A,A,A,A,A,AE,E,E,E,E,I,I,I,I,D,N,O,O,O,O,O,0,U,U,U,U,Y,a,a,a,a,a,a,ae,e,e,e,e,i,i,i,i,N,n,o,o,o,o,o,0,u,u,u,u,y")>
    
<cfsavecontent variable="toclean"><cfoutput>
#ret#
</cfoutput></cfsavecontent>

    <cfset strText = REReplace(toclean,"[^0-9A-Za-z ]","","all")>
    
    <cfreturn strText>
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