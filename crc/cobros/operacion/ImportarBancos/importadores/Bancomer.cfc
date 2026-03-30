<cfcomponent output="false" displayname="ParseBancomer" extends="crc.cobros.operacion.ImportarBancos.ImportarBancosBase">


    <!---
        Patron de digestion
        Ex. 
            
            17091801546481CCT0998321620200000000000001219823                              00000001.00

            [Tipo de Dato]						[Longitud]
                Fecha									6
                Convenio							    8
                Tipo de Pago							3
                Oficina							        4
                GuiaCIE			                        7
                Referencia                              20
                Importe									11

    --->

    <cfinclude template="/crc/credito/reportes/EstadosCuenta_css.cfm"/>
    <cffunction  name="ParseFile">
        <cfargument  name="file">

        <cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
        <cfset _convenio = objParams.GetParametroInfo('30300102').Valor>

        <cfscript>
            montoTotal = 0;
            pagos =  [];
            myfile = FileOpen(arguments.file, "read"); 
            while(NOT FileisEOF(myfile)) { 
                x = FileReadLine(myfile);
                x = replace(x, " ", "");
                _impConvenio = mid(x,7,8);
                
                if (_convenio == _impConvenio) {

                    pago = StructNew();
                    pago.nombreUsuario = mid(x,33,7);
                    _day = mid(x,1,2);
                    _month = mid(x,3,2);
                    _year = mid(x,5,2);
                    pago.fecha  = CreateDateTime(_year,_month,_day);
                    pago.cuenta = mid(x,33,7);
                    _monto  = LSParseNumber(right(x,11));
                    pago.monto  = _monto;
                    
                    arrayAppend(pagos, pago);
                    montoTotal  += _monto;
                } else {
                    throw(type = "Convenio_Invalido", message = "Existen Pagos que no corresponden al Convenio de la Empresa (#_impConvenio#)")
                }
            } 
            FileClose(myfile); 

            result.pagos = pagos;
            result.montoTotal = montoTotal;
            return result;
        </cfscript>	


    </cffunction>
    
    <cffunction  name="PintaReferenciaPago">
        <cfargument  required="false" name="EmisorDeposito" type="string">
        <cfargument  required="false" name="SNnombre" type="string">
        <cfargument  required="false" name="fechafin" type="string">
        <cfargument  required="false" name="CodCorte" type="string">
        <cfargument  required="false" name="Numero" type="string">
        <cfargument  required="false" name="MontoAPagar" type="string">
        <cfargument  required="false" name="Convenio" type="string">
    
        <cfoutput>
        
            <cfset componentPath = "crc.Componentes.CRCBarcodeGenerator">
	        <cfset objBarcode = createObject("component","#componentPath#")>
            <cfset _ref = objBarcode.CreateRefBBVAD(
                        NumCuenta="#arguments.Numero#"
                    , FechaLimite=arguments.fechafin
                )>

                <div style=" padding-left: 1cm;">
                    <span><img src="/crc/images/logo_bancomer.png" height="40px" width="auto"></span>
                </div>
                <div style=" padding-left: 1cm;">
                    <span>Convenio: #arguments.Convenio#</span>
                </div>
                <div style=" padding-left: 1cm;">
                    <span>Referencia: #_ref#</span>
                </div>
                <!--- <div style=" padding-left: 1cm;">
                    <img src="/crc/images/BBVA_#arguments.Numero#.jpg" height="80px" width="auto">
                </div> --->
            <!---
            <table #noBorder#  width="100%">
                <tr >
                    <td colspan="7">
                        ···························································································································································································
                        <br> <p style="#letter9#"> <b>Favor de pagar en <span><img src="/crc/images/logo_bancomer.png" height="20px" width="auto"></span></b></p> 
                    </td>
                </tr>
                <tr>
                    <td style="#resumenE_td# text-align: left;">Convenio:&nbsp;</td>
                    <td style="#resumenE_td# text-align: left;">#arguments.Convenio#</td>
                    <td style="#resumenE_td# text-align: left;">Nombre del Cliente:&nbsp;</td>
                    <td style="#resumenE_td# text-align: left;">#uCase(arguments.SNnombre)#</td>
                    <td style="#resumenE_td# text-align: left;">Fecha de Vencimiento:&nbsp;</td>
                    <td style="#resumenE_td# text-align: left;">#DateFormat(arguments.fechafin,'yyyy.mm.dd')#</td>
                    <td rowspan="2" style="#resumenE_td# text-align: left;">
                        <img src="/crc/images/BBVA_#arguments.Numero#.jpg" height="100px" width="auto">
                    </td>
                </tr>
                <tr>
                    <td style="#resumenE_td# text-align: left;">Numero de Corte:&nbsp;</td>
                    <td style="#resumenE_td# text-align: left;">#arguments.CodCorte#</td>
                    <td style="#resumenE_td# text-align: left;">Numero del Cliente:&nbsp;</td>
                    <td style="#resumenE_td# text-align: left;">#arguments.Numero#</td>
                    <td style="#resumenE_td# text-align: left;">Importe:&nbsp;</td>
                    <td style="#resumenE_td# text-align: left;">$#LSCurrencyFormat(arguments.MontoAPagar, "none")#</td>
                </tr>
            </table>
        --->
        </cfoutput>

    </cffunction>
    
</cfcomponent>