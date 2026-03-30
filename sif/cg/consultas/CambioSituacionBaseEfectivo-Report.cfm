<cf_htmlReportsHeaders title="#LvarTitle#" filename="#LvarFileName#" irA="#LvarIrA#?Back">
<table width="87%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 10px" align="center">
    <!---►►Titulo◄◄--->
    <tr><td colspan="2" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td></tr>
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr><td colspan="2" align="center"><b><font size="2"><cfoutput>#LvarTitle#</cfoutput></font></b></td></tr>
    <tr>
        <td colspan="2" align="center" style="padding-right: 20px">
            <b><cfoutput>#CMB_Mes#:</b>&nbsp;#ListGetAt(meses, Form.mes, ',')#<b>#MSG_Periodo#:</b> &nbsp;#Form.periodo#</cfoutput>
        </td>
    </tr>
		<cfif Oficina neq 'Todas'>
			<tr>
				<td colspan="2" align="center" style="padding-right: 20px">
					<b><cfoutput>#MSG_Oficina#:</cfoutput></b> &nbsp;<cfoutput>#OficinaSelected#</cfoutput>
				</td>
			</tr>
        </cfif>
		<cfif rsGruposOficina.recordCount eq 1>
			<tr>
				<td colspan="2" align="center" style="padding-right: 20px">
					<b><cfoutput>#MSG_GrupoOficinas#:</cfoutput></b> &nbsp;<cfoutput>#rsGruposOficina.GOnombre#</cfoutput>
				</td>
			</tr>
        </cfif>
		<tr>
			<td colspan="2" align="center" style="padding-right: 20px">
				<b><cfoutput>#monedaSelected#</cfoutput></b>
			</td>
		</tr>
</table>
<br />
<table align="center" cellpadding="0" border="0" cellspacing="1" width="80%">
	<TR><TD class="encabReporte" colspan="2">FUENTES DE EFECTIVO</TD></TR>
    <TR class="Titulolistas"><TD colspan="2">EFECTIVO GENERADO EN LA OPERACIÓN</TD></TR>
    <TR>
    	<cfoutput query="rsCuentasOperacion">
    	<cfif chkNivelSeleccionado EQ 1>
        	<cfif rsCuentasOperacion.nivel EQ (varNivel - 1) or (esHoja(rsCuentasOperacion.CCUENTA) EQ "S")>
                <TR>
                    <td width="50%" nowrap>#rsCuentasOperacion.descrip#</td>
                    <td align="right">
                    	<cfif rsCuentasOperacion.saldofin LT rsCuentasOperacion.saldofinA>
                            #LSNumberFormat(rsCuentasOperacion.saldofinA - rsCuentasOperacion.saldofin,'999,999,999,999,999.00()')#
                        <cfelse>
                           #LSNumberFormat(rsCuentasOperacion.saldofin - rsCuentasOperacion.saldofinA,'999,999,999,999,999.00()')#
                        </cfif>
                    </td>
                </TR>
            </cfif>
        <cfelse>
        	<cfif nivel EQ 0 and varNivel GT 1><tr><td colspan="5">&nbsp;</td></tr></cfif>
            	<TR style="padding:2px; " <cfif rsCuentasOperacion.nivel EQ 0>class="tituloListas"</cfif>> 
                    <td width="50%" nowrap> 
                    	 <cfif rsCuentasOperacion.nivel EQ 0>
                            <font size="2">#rsCuentasOperacion.descrip#</font>
                        <cfelse>
                            <cfset LvarCont = rsCuentasOperacion.nivel>
                            <cfloop condition="LvarCont NEQ 0">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <cfset LvarCont = LvarCont - 1>
                            </cfloop>
                            #descrip#
                        </cfif>
                    </td>
                    <td align="right">
                    	<cfif rsCuentasOperacion.saldofin LT rsCuentasOperacion.saldofinA>
                            #LSNumberFormat(rsCuentasOperacion.saldofinA - rsCuentasOperacion.saldofin,'999,999,999,999,999.00()')#
                        <cfelse>
                           #LSNumberFormat(rsCuentasOperacion.saldofin - rsCuentasOperacion.saldofinA,'999,999,999,999,999.00()')#
                        </cfif>
                    </td>
                </TR>
        </cfif>
	</cfoutput>
    </TR>
    <TR><TD colspan="2">&nbsp;</TD></TR>   
    <TR>
    	<TD class="topline"><b>TOTAL EFECTIVO GENERADO  EN LA OPERACIÓN (1)</b></TD>
    	<TD class="topline" align="right">
        	<b>
            	<cfif sumrsCuentasOperacion.RecordCount>
					<cfoutput>
                        <cfif sumrsCuentasOperacion.total LT sumrsCuentasOperacion.totalA>
                            #LSNumberFormat(sumrsCuentasOperacion.totalA - sumrsCuentasOperacion.total,'999,999,999,999,999.00()')#
                        <cfelse>
                           #LSNumberFormat(sumrsCuentasOperacion.total - sumrsCuentasOperacion.totalA,'999,999,999,999,999.00()')#
                        </cfif>
                    </cfoutput>
                <cfelse>
                	0.00
                </cfif>
            </b>
        </TD>
    </TR> 
    <TR><TD colspan="2">&nbsp;</TD></TR>   
    <TR><TD class="Titulolistas" colspan="2">FINANCIAMIENTO Y OTRAS FUENTES DE EFECTIVO</TD></TR>
    <cfoutput query="rsCuentasA">
    	<cfif chkNivelSeleccionado EQ 1>
        	<cfif rsCuentasA.nivel EQ (varNivel - 1) or (esHoja(rsCuentasA.CCUENTA) EQ "S")>
                <TR>
                    <td width="50%" nowrap>#rsCuentasA.descrip#</td>
                    <td align="right">
                    	<cfif rsCuentasA.saldofin LT rsCuentasA.saldofinA>
                            #LSNumberFormat(rsCuentasA.saldofinA - rsCuentasA.saldofin,'999,999,999,999,999.00()')#
                        <cfelse>
                           #LSNumberFormat(rsCuentasA.saldofin - rsCuentasA.saldofinA,'999,999,999,999,999.00()')#
                        </cfif>
                    </td>
                </TR>
            </cfif>
        <cfelse>
        	<cfif nivel EQ 0 and varNivel GT 1><tr><td colspan="5">&nbsp;</td></tr></cfif>
            	<TR style="padding:2px; " <cfif rsCuentasA.nivel EQ 0>class="tituloListas"</cfif>> 
                    <td width="50%" nowrap> 
                    	 <cfif rsCuentasA.nivel EQ 0>
                            <font size="2">#rsCuentasA.descrip#</font>
                        <cfelse>
                            <cfset LvarCont = rsCuentasA.nivel>
                            <cfloop condition="LvarCont NEQ 0">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <cfset LvarCont = LvarCont - 1>
                            </cfloop>
                            #descrip#
                        </cfif>
                    </td>
                    <td align="right">
                    	<cfif rsCuentasA.saldofin LT rsCuentasA.saldofinA>
                            #LSNumberFormat(rsCuentasA.saldofinA - rsCuentasA.saldofin,'999,999,999,999,999.00()')#
                        <cfelse>
                           #LSNumberFormat(rsCuentasA.saldofin - rsCuentasA.saldofinA,'999,999,999,999,999.00()')#
                        </cfif>
                    </td>
                </TR>
        </cfif>
	</cfoutput>
    
    <TR><TD colspan="2">&nbsp;</TD></TR>
    <TR>
    	<TD class="topline"><b>TOTAL FINANCIAMIENTO Y OTRAS FUENTES DE EFECTIVO</b></TD>
    	<TD align="right" class="topline">
        	<b>
				<cfif sumA.RecordCount>
                    <cfoutput>
                        <cfif sumA.total LT sumA.totalA>
                            #LSNumberFormat(sumA.totalA - sumA.total,'999,999,999,999,999.00()')#
                        <cfelse>
                           #LSNumberFormat(sumA.total - sumA.totalA,'999,999,999,999,999.00()')#
                        </cfif>
                    </cfoutput>
                <cfelse>
                    0.00
                </cfif>
            </b>
        </TD>    
    </TR>
   	<TR><TD colspan="2">&nbsp;</TD></TR>   
    <TR>
    	<TD class="topline"><b>TOTAL FUENTES DE EFECTIVO</b></TD>
    	<TD align="right" class="topline">
        	<cfset TotalFuenteEfectivo = 0>
            <cfif sumA.RecordCount>
				<cfif sumA.total LT sumA.totalA>
                    <cfset TotalFuenteEfectivo = sumA.totalA - sumA.total>
                <cfelse>
                    <cfset TotalFuenteEfectivo = sumA.total  - sumA.totalA>
                </cfif>
            </cfif>
            <cfif sumrsCuentasOperacion.recordCount>
				<cfif sumrsCuentasOperacion.total LT sumrsCuentasOperacion.totalA>
                    <cfset TotalFuenteEfectivo = TotalFuenteEfectivo + sumrsCuentasOperacion.totalA - sumrsCuentasOperacion.total>
                <cfelse>
                    <cfset TotalFuenteEfectivo = TotalFuenteEfectivo + sumrsCuentasOperacion.total - sumrsCuentasOperacion.totalA>
                </cfif>
            </cfif>
        	<b>
            	<cfoutput>
                	#LSNumberFormat(TotalFuenteEfectivo,'999,999,999,999,999.00()')#
                </cfoutput>
            </b>
        </TD>
    </TR>
        <TR><TD colspan="2">&nbsp;</TD></TR>
   	<TR><TD class="encabReporte" colspan="2">APLICACIONES DE EFECTIVO</TD></TR>
    <TR><TD class="Titulolistas" colspan="2"><strong>APLICACIÓN DE FONDOS</strong></TD></TR>
    <!---►►Pasivo◄◄--->
	<cfoutput query="rsCuentasP">
    	<cfif chkNivelSeleccionado EQ 1>
        	<cfif rsCuentasP.nivel EQ (varNivel - 1) or (esHoja(rsCuentasP.CCUENTA) EQ "S")>
                <TR>
                    <td width="50%" align="left" nowrap>#rsCuentasP.descrip#</td>
                    <td align="right">
                    	<cfif rsCuentasP.saldofin LT rsCuentasP.saldofinA>
                            #LSNumberFormat(rsCuentasP.saldofinA - rsCuentasP.saldofin,'999,999,999,999,999.00()')#
                        <cfelse>
                           #LSNumberFormat(rsCuentasP.saldofin - rsCuentasP.saldofinA,'999,999,999,999,999.00()')#
                        </cfif>
                    </td>
                </TR>
            </cfif>
        <cfelse>
        	<cfif nivel EQ 0 and varNivel GT 1><tr><td colspan="5">&nbsp;</td></tr></cfif>
            	<TR style="padding:2px; " <cfif rsCuentasP.nivel EQ 0>class="tituloListas"</cfif>> 
                    <td width="50%" align="left" nowrap> 
                    	 <cfif rsCuentasP.nivel EQ 0>
                            <font size="2"><strong>#rsCuentasP.descrip#</strong></font>
                        <cfelse>
                            <cfset LvarCont = rsCuentasP.nivel>
                            <cfloop condition="LvarCont NEQ 0">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <cfset LvarCont = LvarCont - 1>
                            </cfloop>
                            #rsCuentasP.descrip#
                        </cfif>
                    </td>
                    <td align="right">
                    	<cfif rsCuentasP.saldofin LT rsCuentasP.saldofinA>
                            #LSNumberFormat(rsCuentasP.saldofinA - rsCuentasP.saldofin,'999,999,999,999,999.00()')#
                        <cfelse>
                           #LSNumberFormat(rsCuentasP.saldofin - rsCuentasP.saldofinA,'999,999,999,999,999.00()')#
                        </cfif>
                    </td>
                </TR>
        </cfif>
	</cfoutput>
    <cfoutput query="rsCuentasC">
    	<cfif chkNivelSeleccionado EQ 1>
        	<cfif rsCuentasC.nivel EQ (varNivel - 1) or (esHoja(rsCuentasC.CCUENTA) EQ "S")>
                <TR>
                    <td width="50%" align="left" nowrap>#rsCuentasC.descrip#</td>
                    <td align="right">
                    	<cfif rsCuentasC.saldofin LT rsCuentasC.saldofinA>
                            #LSNumberFormat(rsCuentasC.saldofinA - rsCuentasC.saldofin,'999,999,999,999,999.00()')#
                        <cfelse>
                           #LSNumberFormat(rsCuentasC.saldofin - rsCuentasC.saldofinA,'999,999,999,999,999.00()')#
                        </cfif>
                    </td>
                </TR>
            </cfif>
        <cfelse>
        	<cfif nivel EQ 0 and varNivel GT 1><tr><td colspan="5">&nbsp;</td></tr></cfif>
            	<TR style="padding:2px; " <cfif rsCuentasC.nivel EQ 0>class="tituloListas"</cfif>> 
                    <td width="50%" align="left" nowrap> 
                    	 <cfif rsCuentasC.nivel EQ 0>
                            <font size="2"><strong>#rsCuentasC.descrip#</strong></font>
                        <cfelse>
                            <cfset LvarCont = rsCuentasC.nivel>
                            <cfloop condition="LvarCont NEQ 0">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <cfset LvarCont = LvarCont - 1>
                            </cfloop>
                            #rsCuentasC.descrip#
                        </cfif>
                    </td>
                    <td align="right">
                    	<cfif rsCuentasC.saldofin LT rsCuentasC.saldofinA>
                            #LSNumberFormat(rsCuentasC.saldofinA - rsCuentasC.saldofin,'999,999,999,999,999.00()')#
                        <cfelse>
                           #LSNumberFormat(rsCuentasC.saldofin - rsCuentasC.saldofinA,'999,999,999,999,999.00()')#
                        </cfif>
                    </td>
                </TR>
        </cfif>
	</cfoutput>
    <TR><TD colspan="2">&nbsp;</TD></TR>
    <TR>
    	<TD class="topline"><b>TOTAL APLICACIÓN DE FONDOS</b></TD>
    	<TD align="right" class="topline"> <b>       	
			<cfset LvarTotalAplicacionFondos = 0>
            <cfif sumP.RecordCount>
				<cfif sumP.total LT sumP.totalA>
                   <cfset LvarTotalAplicacionFondos  = sumP.totalA - sumP.total>
                <cfelse>
                    <cfset LvarTotalAplicacionFondos = sumP.total - sumP.totalA>
                </cfif>
            </cfif>
            <cfif sumC.RecordCount>
				<cfif sumC.total LT sumC.totalA>
                   <cfset LvarTotalAplicacionFondos  = LvarTotalAplicacionFondos + sumC.totalA - sumC.total>
                <cfelse>
                    <cfset LvarTotalAplicacionFondos = LvarTotalAplicacionFondos + sumC.total - sumC.totalA>
                </cfif>
            </cfif>
            
			<cfoutput>#LSNumberFormat(LvarTotalAplicacionFondos,'999,999,999,999,999.00()')#</cfoutput></b>
        </TD>
    </TR>
    <TR><TD colspan="2">&nbsp;</TD></TR>
    <TR>
    	<TD class="topline"><b>SUPERAVIT O DEFICIT DE EFECTIVO</b></TD>
    	<TD align="right" class="topline"><b>
        	<cfset LvarSuperavit = TotalFuenteEfectivo - LvarTotalAplicacionFondos> 
        	<cfoutput>#LSNumberFormat(LvarSuperavit,'999,999,999,999,999.00()')#</b></cfoutput>
        </TD>
    </TR>
</table>