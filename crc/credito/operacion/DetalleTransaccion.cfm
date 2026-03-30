<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Corte" default = "Corte" returnvariable="LB_Corte" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoReq" default = "MontoReq" returnvariable="LB_MontoReq" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoPagar" default = "MontoPagar" returnvariable="LB_MontoPagar" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descuento" default = "Descuento" returnvariable="LB_Descuento" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Pagado" default = "Pagado" returnvariable="LB_Pagado" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Intereses" default = "Intereses" returnvariable="LB_Intereses" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_SaldoVencido" default = "SaldoVencido" returnvariable="LB_SaldoVencido" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Condonaciones" default = "Condonaciones" returnvariable="LB_Condonaciones" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" default = "Descripcion" returnvariable="LB_Descripcion" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Convenio" default = "Convenio" returnvariable="LB_Convenio" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Status" default = "Status" returnvariable="LB_Status" xmlfile = "DetalleTransaccion.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Cliente" default = "Cliente" returnvariable="LB_Cliente" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CURP" default = "CURP" returnvariable="LB_CURP" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Observaciones" default = "Observaciones" returnvariable="LB_Observaciones" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TipoTransaccion" default = "Tipo Transaccion" returnvariable="LB_TipoTransaccion" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fecha" default = "Fecha" returnvariable="LB_Fecha" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Parcialidades" default = "Parcialidades" returnvariable="LB_Parcialidades" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TipoMov" default = "Tipo Movimiento" returnvariable="LB_TipoMov" xmlfile = "DetalleTransaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Monto" default = "Monto" returnvariable="LB_Monto" xmlfile = "DetalleTransaccion.xml">


<cfoutput>
    <cfif isDefined('url.id')>
        <cfquery name="detalleT" datasource="#session.DSN#">
            select *, case Status when 1 then 'Por Pagar' when 2 then 'Saldo Vencido' when 3 then 'Cerrado' else 'Abierto' end as Estado 
            from CRCMovimientoCuenta where CRCTransaccionid = #url.id# and Ecodigo = #session.ecodigo#;
        </cfquery>
        <cfquery name="q_transaccion" datasource="#session.DSN#">
            select * from CRCTransaccion where id = #url.id# and Ecodigo = #session.ecodigo#;
        </cfquery>
        <cfset counter = 0>
        <cfset tdStyle = "background-color:##ccc;">
        <HTML style="overflow-y: scroll;">
            <body bgcolor="##dee7e5">
                <div align="center" style="border-radius: 25px; border: 2px solid ##626463; padding: 20px;">
                    <table width="80%" border="0" cellspacing="5" cellpadding="0" align="center" style="font-family:arial;font-size:12px;">
                        <tr>
                            <td>#LB_CURP#</td>
                            <td><input type="text" value="#q_transaccion.CURP#" readonly tabindex="-1" style="border:none; font-weight:bold; width:250px"></td>
                            <td>#LB_Cliente#</td>
                            <td><input type="text" value="#q_transaccion.Cliente#" readonly tabindex="-1" style="border:none; font-weight:bold; width:250px"></td>
                        </tr>
                        <tr>
                            <td>#LB_Fecha#</td>
                            <td><input type="text" value="#q_transaccion.Fecha#" readonly tabindex="-1" style="border:none; font-weight:bold; width:250px"></td>
                            <td>#LB_TipoTransaccion#</td>
                            <td><input type="text" value="#q_transaccion.TipoTransaccion#" readonly tabindex="-1" style="border:none; font-weight:bold; width:250px"></td>
                        </tr>
                        <tr>
                            <td>#LB_TipoMov#</td>
                            <td><input type="text" value="#q_transaccion.TipoMov#" readonly tabindex="-1" style="border:none; font-weight:bold; width:250px"></td>
                            <td>#LB_Observaciones#</td>
                            <td><input type="text" value="#q_transaccion.Observaciones#" readonly tabindex="-1" style="border:none; font-weight:bold; width:250px"></td>
                        </tr>
                        <tr>
                            <td>#LB_Parcialidades#</td>
                            <td><input type="text" value="#q_transaccion.Parciales#" readonly tabindex="-1" style="border:none; font-weight:bold; width:250px"></td>
                            <td>#LB_Monto#</td>
                            <td><input type="text" value="#LSCurrencyFormat(q_transaccion.Monto)#" readonly tabindex="-1" style="border:none; font-weight:bold; width:250px"></td>
                        </tr>
                    </table>
                    </br>
                    <cfset V_MontoReq = 0>
                    <cfset V_MontoPagar = 0>
                    <cfset V_Descuento = 0>
                    <cfset V_Pagado = 0>
                    <cfset V_Intereses = 0>
                    <cfset V_SaldoVencido = 0>
                    <cfset V_Condonaciones = 0>
                    <table width="98%" border="0" cellspacing="1" cellpadding="0" align="center" style="font-family:arial;font-size:12px;">
                        <tr>
                            <th style="#tdStyle#">#LB_Corte#</th>
                            <th style="#tdStyle#">#LB_Descripcion#</th>
                            <th style="#tdStyle#">#LB_MontoReq#</th>
                            <th style="#tdStyle#">#LB_MontoPagar#</th>
                            <th style="#tdStyle#">#LB_Descuento#</th>
                            <th style="#tdStyle#">#LB_Pagado#</th>
                            <th style="#tdStyle#">#LB_Intereses#</th>
                            <th style="#tdStyle#">#LB_SaldoVencido#</th>
                            <th style="#tdStyle#">#LB_Condonaciones#</th>
                            <th style="#tdStyle#">#LB_Status#</th>
                        </tr>
                        <cfset counter = 1>
                        <cfloop query = 'detalleT'>
                            <cfif counter eq 0>
                                <cfset tdStyle = "background-color:##ccc;">
                                <cfset counter = 1>
                            <cfelse>
                                <cfset counter = 0>
                                <cfset tdStyle = "background-color:##f1f1f1;">
                            </cfif>
                            <tr>
                                <td align="center" style="#tdStyle#">#detalleT.Corte#</td>
                                <td align="center" style="#tdStyle#">#detalleT.Descripcion#</td>
                                <td align="center" style="#tdStyle#">#LSCurrencyFormat(detalleT.MontoRequerido)#</td>
                                <td align="center" style="#tdStyle#">#LSCurrencyFormat(detalleT.MontoAPagar)#</td>
                                <td align="center" style="#tdStyle#">#LSCurrencyFormat(detalleT.Descuento)#</td>
                                <td align="center" style="#tdStyle#">#LSCurrencyFormat(detalleT.Pagado)#</td>
                                <td align="center" style="#tdStyle#">#LSCurrencyFormat(detalleT.Intereses)#</td>
                                <td align="center" style="#tdStyle#">#LSCurrencyFormat(detalleT.SaldoVencido)#</td>
                                <td align="center" style="#tdStyle#">#LSCurrencyFormat(detalleT.Condonaciones)#</td>
                                <td align="center" style="#tdStyle#">#detalleT.Estado#</td>
                            </tr>
                            <cfset V_MontoReq += detalleT.MontoRequerido>
                            <cfset V_MontoPagar += detalleT.MontoAPagar>
                            <cfset V_Descuento += detalleT.Descuento>
                            <cfset V_Pagado += detalleT.Pagado>
                            <cfset V_Intereses += detalleT.Intereses>
                            <cfset V_SaldoVencido += detalleT.SaldoVencido>
                            <cfset V_Condonaciones += detalleT.Condonaciones>
                        </cfloop>
                        <cfif counter eq 0>
                            <cfset tdStyle = "background-color:##ccc;">
                            <cfset counter = 1>
                        <cfelse>
                            <cfset counter = 0>
                            <cfset tdStyle = "background-color:##f1f1f1;">
                        </cfif>
                        <tr>
                            <th align="center" style="#tdStyle#" colspan="2">Total</th>
                            <th align="center" style="#tdStyle#">#LSCurrencyFormat(V_MontoReq)#</th>
                            <th align="center" style="#tdStyle#">#LSCurrencyFormat(V_MontoPagar)#</th>
                            <th align="center" style="#tdStyle#">#LSCurrencyFormat(V_Descuento)#</th>
                            <th align="center" style="#tdStyle#">#LSCurrencyFormat(V_Pagado)#</th>
                            <th align="center" style="#tdStyle#">#LSCurrencyFormat(V_Intereses)#</th>
                            <th align="center" style="#tdStyle#">#LSCurrencyFormat(V_SaldoVencido)#</th>
                            <th align="center" style="#tdStyle#">#LSCurrencyFormat(V_Condonaciones)#</th>
                            <th align="center" style="#tdStyle#"></th>
                        </tr>
                    </table>
                </div>
            </body>
        <html>
    <cfelse>
        <p align="center"><font color="red"><br/><br/><br/><b>No existe detalle de transaccion asociado</b></font> </p>
    </cfif>
</cfoutput>