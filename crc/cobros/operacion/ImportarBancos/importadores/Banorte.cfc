<cfcomponent output="false" displayname="ParseBancomer" extends="crc.cobros.operacion.ImportarBancos.ImportarBancosBase">

    <!---
        Patron de digestion
        Ex. 
            
            2014878052727416004494V10100000000001944000000027216D00000000001671840000000000000000000000000000000000000260000000000000000000000000000000000000339TORRES RIVAS SILVIA MARGARITA                                                                    201802191487091022A00020180221**00000000000000                                       004494

            [Tipo de Dato]						[Longitud]
                Folio									21
                Medio de Pago							2
                Forma de Pago							2
                Importe Bruto							16
                Importe de Descuento / Recargo			10
                Identificador Descuento / Recargo		1
                Importe Neto							16
                Referencia 1							40           <-- Posible numero de cuenta
                Referencia 2							40
                Referencia 3							40
                Referencia 4							40
                Fecha de Vencimiento					8
                Sucursal								4
                Hora									6
                Estatus								1
                Codigo de Rechazo						2
                Tipo de Movimiento						1
                Fecha de Pago							8
                Descripción Forma de Pago				6
                Clave de Banco							3
                Número de Cheque						7
                Filler									<55
                Número de Empresa						6

    --->

    <cfinclude template="/crc/credito/reportes/EstadosCuenta_css.cfm"/>

    <cffunction  name="ParseFile">
        <cfargument  name="file">

        <cfscript>
            montoTotal = 0;
            pagos =  [];
            myfile = FileOpen(arguments.file, "read"); 
            while(NOT FileisEOF(myfile)) { 
                x = FileReadLine(myfile);
                if (mid(x,1,1) == '2' && mid(x,248,1) == 'A'){ 
                    pago = StructNew();
                    pago.nombreUsuario = mid(x,150,40);
                    pago.fecha  = CreateDateTime(mid(x,252,4),mid(x,256,2),mid(x,258,2),mid(x,242,2),mid(x,244,2),mid(x,246,2));
                    pago.cuenta = LSParseNumber(mid(x,70,40));
                    pago.monto  = LSParseNumber("#mid(x,54,14)#.#mid(x,68,2)#");
                    arrayAppend(pagos, pago);
                }
                if (mid(x,1,1) == 4){ 
                    montoTotal  = LSParseNumber("#mid(x,8,14)#.#mid(x,22,2)#"); 
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
        
            <table #noBorder#  width="100%">
                <tr >
                    <td colspan="6">
                        ···························································································································································································
                        <br> <p style="#letter9#"> <b>Favor de pagar en <span><img src="/crc/images/logo_banorte.png" height="20px" width="auto"></span></b></p> 
                    </td>
                </tr>
                <tr>
                    <td style="#resumenE_td# text-align: left;">Emisora:&nbsp;</td>
                    <td style="#resumenE_td# text-align: left;">#arguments.EmisorDeposito#</td>
                    <td style="#resumenE_td# text-align: left;">Nombre del Cliente:&nbsp;</td>
                    <td style="#resumenE_td# text-align: left;">#uCase(arguments.SNnombre)#</td>
                    <td style="#resumenE_td# text-align: left;">Fecha de Vencimiento:&nbsp;</td>
                    <td style="#resumenE_td# text-align: left;">#DateFormat(arguments.fechafin,'yyyy.mm.dd')#</td>
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
        </cfoutput>

    </cffunction>


</cfcomponent>