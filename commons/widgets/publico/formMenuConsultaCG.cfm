<!---
	Modificado por: Ana Villavicencio
	Fecha: 4 de agosto del 2005
	Motivo: Se documentó el desplieque del total del estado de Resultados, a petición de Marcel. Linea 165.
			Se condición el despliegue de el total de cada rubro, no se tiene que desplegar para el rubro
			de Utilidad Antes de impuestos. Solamente para el resto del los rubros.
 --->
<!--- ************************************* --->
<cfif rsProc.recordcount>
	<table width="100%" border="0" cellspacing="0" align="center">
		<tr>
		<cfoutput>
			<td 	   class="LbTottomline"   colspan="2" bgcolor="lightgrey">&nbsp;</td>
			<td nowrap class="LbTottomline"   align="right" bgcolor="lightgrey"><b >#ListGetAt(meses, Mes, ',')#&nbsp;#Periodo#</b></td>
			<td nowrap class="LbTottomline"   align="right" bgcolor="lightgrey"><b >#ListGetAt(meses, MesAnt, ',')#&nbsp;#PeriodoAnt#</b></td>
			<td nowrap class="RLTbottomline"   align="right" bgcolor="lightgrey"><b >#ListGetAt(meses, MesPer, ',')#&nbsp;#Periodo1#</b></td>
		</cfoutput>
		</tr>
		<cfif rsMayor.recordcount gt 0>
			<cfloop query="rsMayor">
				<cfif rsMayor.corte NEQ corteR>
					<cfset corteCtaMayor = 0>
					<cfif rsMayor.currentRow NEQ 1>
						<cfif corteR EQ 35 or corteR EQ 55 or corteR EQ 85 or lineascorte LT 2>
							<cfoutput>
							<tr>
								<td  class="Lbottomline" colspan="2" bgcolor="##E8E8E8">&nbsp;</td>
								<td nowrap class="Lbottomline" align="right" bgcolor="##FBD8A4" ><font style=" color:##FF0000;">&nbsp;</font></td>
								<td nowrap class="Lbottomline" align="right" bgcolor="##FFFFCC"><font style=" color:##FF0000">&nbsp;</font></td>
								<td nowrap class="RLbottomline" align="right" bgcolor="##FFFFFF"><font style=" color:##FF0000">&nbsp;</font></td>
							</tr>
							</cfoutput>
						<cfelse>
							<cfoutput>
							<tr>
								<td        class="Lbottomline" colspan="2" bgcolor="##E8E8E8">&nbsp;</td>
								<td nowrap class="Lbottomline" align="right" bgcolor="##FBD8A4" ><font style=" color:##FF0000;"><b>#LSNumberFormat(Tsaldofin / Factor,'999,999,999,999,999')#</b></font></td>
								<td nowrap class="Lbottomline" align="right" bgcolor="##FFFFCC"><font style=" color:##FF0000;"><b>#LSNumberFormat(TsaldofinAnt / Factor,'999,999,999,999,999')#</b></font></td>
								<td nowrap class="RLbottomline" align="right" bgcolor="##FFFFFF"><font style=" color:##FF0000;"><b>#LSNumberFormat(TsaldofinAnno1 / Factor,'999,999,999,999,999')#</b></font></td>
							</tr>
							</cfoutput>
						</cfif>
					</cfif>
					<cfset Tsaldofin = 0>
					<cfset TsaldofinAnt = 0>
					<cfset TsaldofinAnno1 = 0>
					<cfset corteR = rsMayor.corte>
					<cfset lineascorte = 0>
					<cfoutput>
					<tr>
						<td  class="leftline" colspan="2" bgcolor="##E8E8E8"><b >#rsMayor.ntipo#</b></td>
						<td nowrap class="leftline" align="right" bgcolor="##FBD8A4">&nbsp;</td>
						<td nowrap class="leftline" align="right" bgcolor="##FFFFCC">&nbsp;</td>
						<td nowrap class="RLline" align="right" bgcolor="##FFFFFF">&nbsp;</td>
					</tr>
					</cfoutput>
				</cfif>
				<cfoutput>
				<tr>
					<td        class="leftline" colspan="2" bgcolor="<cfif varNivel NEQ 1>lightgrey<cfelse>##E8E8E8</cfif>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="##000000" >#rsMayor.descrip#</font></td>
					<td nowrap class="leftline" align="right" bgcolor="##FBD8A4"><cfif varNivel NEQ 1><b></cfif><font color="<cfif varNivel NEQ 1>##0000FF<cfelse>##000000</cfif>" >#LSNumberFormat(rsMayor.saldofin / Factor,'999,999,999,999,999')#</font><cfif varNivel NEQ 1></b></cfif></td>
					<td nowrap class="leftline" align="right" bgcolor="##FFFFCC"><cfif varNivel NEQ 1><b></cfif><font color="<cfif varNivel NEQ 1>##0000FF<cfelse>##000000</cfif>" >#LSNumberFormat(rsMayor.saldofinAnt / Factor,'999,999,999,999,999')#</font><cfif varNivel NEQ 1></b></cfif></td>
					<td nowrap class="RLline"   align="right" bgcolor="##FFFFFF"><cfif varNivel NEQ 1><b></cfif><font color="<cfif varNivel NEQ 1>##0000FF<cfelse>##000000</cfif>" >#LSNumberFormat(rsMayor.saldofinAnno1 / Factor,'999,999,999,999,999')#</font><cfif varNivel NEQ 1></b></cfif></td>
				</tr>
				</cfoutput>
				<cfset corteCtaMayor = rsMayor.mayor>
				<cfquery name="rsSubCuenta" dbtype="query">
					select *
					from rsProc
					where corte = #corteR#
					and mayor = '#corteCtaMayor#'
					and nivel <> 0
					order by formato
				</cfquery>
				<cfif varNivel NEQ 1 and rsSubCuenta.recordcount gt 0>
					<cfoutput query="rsSubCuenta">
						<tr>
							<td        class="leftline" colspan="2" bgcolor="##E8E8E8" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#rsSubCuenta.descrip#</td>
							<td nowrap class="leftline" align="right" bgcolor="##FBD8A4"><font color="##000000">#LSNumberFormat(rsSubCuenta.saldofin / Factor,'999,999,999,999,999')#</font></td>
							<td nowrap class="leftline" align="right" bgcolor="##FFFFCC"><font color="##000000">#LSNumberFormat(rsSubCuenta.saldofinAnt / Factor,'999,999,999,999,999')#</font></td>
							<td nowrap class="RLline"   align="right" bgcolor="##FFFFFF"><font color="##000000">#LSNumberFormat(rsSubCuenta.saldofinAnno1 / Factor,'999,999,999,999,999')#</font></td>
						</tr>
					</cfoutput>
				</cfif>
				<cfif rsMayor.currentRow EQ rsMayor.recordcount >
					<cfoutput>
					<tr>
						<td class="Lbottomline" bgcolor="##E8E8E8" colspan="2">&nbsp;</td>
						<td nowrap class="Lbottomline" align="right" bgcolor="##FBD8A4"><font style=" color:##FF0000" >&nbsp;</font></td>
						<td nowrap class="Lbottomline" align="right" bgcolor="##FFFFCC"><font style=" color:##FF0000">&nbsp;</font></td>						<td nowrap class="RLbottomline" align="right" bgcolor="##FFFFFF"><font style=" color:##FF0000">&nbsp;</font></td>
					</tr>
					</cfoutput>
				</cfif>
				<cfset Tsaldofin 	= Tsaldofin 	 + rsMayor.saldofin >
				<cfset TsaldofinAnt 	= TsaldofinAnt   + rsMayor.saldofinAnt >
				<cfset TsaldofinAnno1 	= TsaldofinAnno1 + rsMayor.saldofinAnno1 >
				<cfset lineascorte = lineascorte + 1>
			</cfloop>
		<cfelse>
			No hay definidas Cuentas de Mayor
		</cfif>
	</table>
</cfif>