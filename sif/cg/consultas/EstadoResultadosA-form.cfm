	<cfinclude template="Funciones.cfm">
	<cfquery datasource="#Session.DSN#" name="rsEmpresa">
		select Edescripcion from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

	<cfif isdefined("url.periodo")>
		<cfparam name="Form.periodo" default="#url.periodo#">
	</cfif>
	<cfif isdefined("url.mes")>
		<cfparam name="Form.mes" default="#url.mes#">
	</cfif>
	<cfif isdefined("url.nivel")>
		<cfparam name="Form.nivel" default="#url.nivel#">
	</cfif>
	<cfif isdefined("url.CGARepid")>
		<cfparam name="Form.CGARepid" default="#url.CGARepid#">
	</cfif>
	<cfif isdefined("url.CGARid")>
		<cfparam name="Form.CGARid" default="#url.CGARid#">
	</cfif>

	<cfif isdefined("Form.Nivel") and Form.Nivel neq "-1">
		<cfset varNivel = Form.Nivel>
	<cfelse>
		<cfset varNivel = "0">
	</cfif>

	<!--- <cftransaction>	--->
		<cfinvoke returnvariable="rsProc" component="sif.Componentes.CG_EstadoResultadosAR" method="estadoResultados" 
			Ecodigo="#Session.Ecodigo#"
			periodo="#Form.periodo#"
			mes="#Form.mes#"
			nivel = "#varNivel#"
			CGARepid="#form.CGARepid#"
			CGARid="#form.CGARid#"
			moneda="#form.moneda#" >
		</cfinvoke>	
	<!--- </cftransaction>  --->

<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">

<cfif isDefined("form.toExcel") and rsProc.recordcount lt 20000 >
	<cfcontent type="application/vnd.ms-excel">
	<cfheader 	name="Content-Disposition" 
			value="attachment;filename=estadoRA#session.Usucodigo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
</cfif>

<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 2px;
		padding-bottom: 2px;
		font-size:12px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
</style>

<cfquery name="rsMayor" dbtype="query">
	select *
	from rsProc
	where nivel = 0
	order by corte, mayor, formato
</cfquery>

<cfif isdefined("form.CGARid") and len(trim(CGARid))>
	<cfquery name="area" datasource="#session.DSN#">
		select CGARdescripcion as descripcion
		from CGAreaResponsabilidad
		where CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGARid#">
	</cfquery>
</cfif>

<cfoutput>
	<cfif form.nivel eq 0 >
		<cfset form.nivel = 1 >
	</cfif>

	<cfset colspan = (form.nivel * 6)+5 > 
	
	<table width="99%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
    	<tr><td colspan="#colspan#" align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="4"><strong>#session.Enombre#</strong></font></td></tr>
    	<tr><td colspan="#colspan#" align="center"><b><font face="Times New Roman, Times, serif" size="4">Estado de Resultados</font></b></td></tr>
		<cfif isdefined("area")>
			<tr><td colspan="#colspan#" align="center"><b><font face="Times New Roman, Times, serif" size="3">Area de Responsabilidad: #area.descripcion#</font></b></td></tr>
		</cfif>
    	<tr>
			<td colspan="#colspan#" align="center" style="padding-right: 20px">
				<b>Mes:</b>&nbsp;
          		#ListGetAt(meses, Form.mes, ',')#&nbsp;
				<b>Período:</b>&nbsp;
				#Form.periodo#
			</td>
    	</tr>

		<tr><td colspan="#colspan#">&nbsp;</td></tr>
			<tr bgcolor="##CCCCCC" > 
				<td align="left" nowrap ></td>
				<td colspan="#form.nivel*2+1#"  align="center"><strong>Contabilidad<br>(Mensual|Acumulado) </strong></td>
				<td >&nbsp;</td>
				<td colspan="#form.nivel*2#" align="center" ><strong>Presupuesto<br>(Mensual|Acumulado)</strong></td>
				<td >&nbsp;</td>
				<td colspan="#form.nivel*2#" align="center" ><strong>Diferencias<br>(Mensual|Acumulado)</strong></td>
				<td colspan=""  align="right">
				</td>
			</tr>
		
		<cfset corteR = 0>
		<cfset corteCtaMayor = 0>
		
		<cfloop query="rsMayor"> 
			<!--- PINTAR EL CORTE POR SUBTIPO --->
			<cfif rsMayor.corte NEQ corteR>
				<cfset corteR = rsMayor.corte>
				<cfset corteCtaMayor = 0>

				<cfif rsMayor.currentRow NEQ 1>
				<tr><td colspan="#colspan#" class="bottomline">&nbsp;</td></tr>
				</cfif>
				<cfquery name="rsSaldo" dbtype="query">
					select sum(saldofin) as total,
						   sum(movmes) as total_mes,
						   sum(pmensual) as total_pmes,
						   sum(pfinal) as total_pfinal
					from rsProc
					where corte = <cfqueryparam cfsqltype="cf_sql_integer" value="#corteR#">
					and nivel = 0
				</cfquery>
				<tr> 
					<td align="left" nowrap class="encabReporte">#rsMayor.ntipo#</td>
					<td colspan="#form.nivel#" nowrap class="encabReporte" align="right">#LSNumberFormat(rsSaldo.total_mes, ',9.00()')#</td>

					<!--- contabilidad --->
					<td class="encabReporte">&nbsp;</td>
					<td colspan="#form.nivel#" nowrap class="encabReporte" align="right">#LSNumberFormat(rsSaldo.total, ',9.00()')#</td>

					<!--- presupuesto --->
					<td class="encabReporte">&nbsp;</td>
					<td colspan="#form.nivel#" nowrap align="right" class="encabReporte">#LSNumberFormat(rsSaldo.total_pmes, ',9.00()')#</td>
					<td colspan="#form.nivel#" nowrap class="encabReporte" align="right">#LSNumberFormat(rsSaldo.total_pfinal, ',9.00()')#</td>

					<!--- diferencias --->
					<td class="encabReporte">&nbsp;</td>
					<td nowrap colspan="#form.nivel#" align="right" class="encabReporte">#LSNumberFormat(rsSaldo.total_mes-rsSaldo.total_pmes, ',9.00()')#</td>
					<td nowrap colspan="#form.nivel#" class="encabReporte" align="right">#LSNumberFormat(rsSaldo.total-rsSaldo.total_pfinal, ',9.00()')#</td>

					<!---<td class="encabReporte" colspan="#colspan-2#">&nbsp;</td>--->

					<td class="encabReporte" align="right">
					</td>
				</tr>
			</cfif>

			<!--- PINTAR EL CORTE POR CUENTA DE MAYOR EXCEPTO QUE SEA IGUAL A 0 O IGUAL A UNA CUENTA MAYOR ANTERIOR --->
			<cfif corteCtaMayor NEQ rsMayor.mayor>
				<cfset corteCtaMayor = rsMayor.mayor>
				<cfquery name="rsSaldo" dbtype="query">
					select 	formato, 
							descrip, 
							saldofin as total,
							movmes,
						   	pmensual,
						   	pfinal
					from rsProc
					where corte = <cfqueryparam cfsqltype="cf_sql_integer" value="#corteR#">
					and mayor = '#corteCtaMayor#'
					and nivel = 0
				</cfquery>
				<!---
				<tr bgcolor="##CCCCCC" > 
					<td align="left" nowrap ><font size="2"><strong>#rsSaldo.formato# - #rsSaldo.descrip#</strong></font></td>
					<td colspan="#form.nivel*2+1#"  align="center"></td>
					<td >&nbsp;</td>
					<td colspan="#form.nivel*2#" align="center" ></td>
					<td colspan=""  align="right">***
						<font size="2" <cfif rsSaldo.total LT 0>color="##FF0000"</cfif>>
						<strong>#LSNumberFormat(rsSaldo.total, ',9.00()')#</strong>
						</font>
					</td>
				</tr>
				--->
				<tr bgcolor="##CCCCCC" > 
					<td align="left" nowrap ><font size="2"><strong>#rsSaldo.descrip#</strong></font></td>

					<!--- ================================================================ --->
					<!--- CONTABILIDAD --->
					<!--- ================================================================ --->
					<td colspan="#form.nivel#" align="right"  align="center">
						<font size="2" <cfif rsSaldo.movmes LT 0>color="##FF0000"</cfif>>
						<strong>#LSNumberFormat(rsSaldo.movmes, ',9.00()')#</strong>
						</font>
					</td>
					<td >&nbsp;</td>			
					<td colspan="#form.nivel#"  align="right">
						<font size="2" <cfif rsSaldo.total LT 0>color="##FF0000"</cfif>>
						<strong>#LSNumberFormat(rsSaldo.total, ',9.00()')#</strong>
						</font>
					</td>

					<!--- ================================================================ --->
					<!--- Presupuesto --->
					<!--- *** SE les dio vuelta porque parece que estaban al revez, viene asi de la bd.
							   Parece qu eviene asi de la base de datos, lo correcto es lo siguiente para el pintado: 
							  (pfinal==> Presupuesto Mensual) 
							  (pmensual==> Presupuesto Final) 
					--->
					<!--- ================================================================ --->
					<td >&nbsp;</td>
					<td colspan="#form.nivel#" align="right" >
						<font size="2" <cfif rsSaldo.pmensual LT 0>color="##FF0000"</cfif>>
						<strong>#LSNumberFormat(rsSaldo.pmensual, ',9.00()')#</strong>
						</font>
					</td>
					<td colspan="#form.nivel#"  align="right">
						<font size="2" <cfif rsSaldo.pfinal LT 0>color="##FF0000"</cfif>>
						<strong>#LSNumberFormat(rsSaldo.pfinal, ',9.00()')#</strong>
						</font>
					</td>
					<!--- ================================================================ --->

					<!--- ================================================================ --->
					<!--- DIFERENCIAS *** FALTA CALCULO--->
					<!--- ================================================================ --->
					<td >&nbsp;</td>
					<td align="right" colspan="#form.nivel#">
						<font size="2" <cfif (rsSaldo.movmes-rsSaldo.pmensual) LT 0>color="##FF0000"</cfif>>
						<strong>#LSNumberFormat( (rsSaldo.movmes-rsSaldo.pmensual), ',9.00()')#</strong>
						</font>
					</td>
					<td align="right" colspan="#form.nivel#">
						<font size="2" <cfif (rsSaldo.total-rsSaldo.pfinal) LT 0>color="##FF0000"</cfif>>
						<strong>#LSNumberFormat((rsSaldo.total-rsSaldo.pfinal), ',9.00()')#</strong>
						</font>
					</td>
					<!--- ================================================================ --->					
					
					<td colspan=""  align="right">
					</td>
				</tr>				
				
				
			</cfif>
			
			<!--- OBTENER TODAS LAS SUBCUENTAS DE LA CUENTA MAYOR --->
			<cfquery name="rsSubCuenta" dbtype="query">
				select *
				from rsProc
				where corte = <cfqueryparam cfsqltype="cf_sql_integer" value="#corteR#">
				and mayor = '#corteCtaMayor#'
				and nivel <> 0
				order by formato
			</cfquery>

			<cfset tienesubcuentas = false >
			<cfloop query="rsSubCuenta"> 
				<cfset tienesubcuentas = true >
				<tr <cfif rsSubCuenta.nivel EQ 0>class="tituloListas"</cfif>> 
					<td align="left" nowrap style="border-left: 1px solid ##CCCCCC; padding-left:2; border-right: 1px solid ##CCCCCC; padding-left:2">  
						<cfif rsSubCuenta.nivel EQ 0>
							<font size="2"><strong>#descrip#</strong></font>
						<cfelse>
							<cfset LvarCont = rsSubCuenta.nivel>
							<cfloop condition="LvarCont NEQ 0">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<cfset LvarCont = LvarCont - 1>
							</cfloop>
							#descrip#
						</cfif>
					</td>

					<!--- los loops para pintar tr/td's es un REMIENDO a lo que estaba, pues  
						  al mandar un vivel de 3 no pintaba correctaente los niveles
					--->
					
					<!--- ======================================================================= --->
					<!--- Movimientos del mes --->
					<!--- ======================================================================= --->
					<cfset intNivel = form.nivel >
					<cfset cs1 = intNivel - rsSubCuenta.nivel >
					<cfset cs2 = intNivel - cs1 - 1 >

					<cfloop from="1" to="#cs1#" index="i">
						<td bgcolor="##F5f5f5">&nbsp;</td>
					</cfloop>
					<td align="right" nowrap="nowrap" bgcolor="##F5f5f5">
						<cfif rsSubCuenta.movmes GTE 0>#LSNumberFormat(rsSubCuenta.movmes,'999,999,999,999,999.00')# 
						<cfelse><font color="##FF0000">#LSNumberFormat(rsSubCuenta.movmes,'999,999,999,999,999.00()')#</font> 
						</cfif>
					</td>

					<cfloop from="1" to="#cs2#" index="i">
						<td bgcolor="##F5f5f5">&nbsp;</td>
					</cfloop>
					<!--- ======================================================================= --->

					<td  >&nbsp;</td>

					<!--- ======================================================================= --->
					<!--- Acumulado actual --->
					<!--- ======================================================================= --->
					<cfset intNivel = form.nivel >
					<cfset cs1 = intNivel - rsSubCuenta.nivel >
					<cfset cs2 = intNivel - cs1 - 1 >

					<cfloop from="1" to="#cs1#" index="i">
						<td >&nbsp;</td>
					</cfloop>
					<td align="right" nowrap="nowrap"  >
						<cfif rsSubCuenta.saldofin GTE 0>#LSNumberFormat(rsSubCuenta.saldofin,'999,999,999,999,999.00')# 
						<cfelse><font color="##FF0000">#LSNumberFormat(rsSubCuenta.saldofin,'999,999,999,999,999.00()')#</font> 
						</cfif>
					</td>

					<cfloop from="1" to="#cs2#" index="i">
						<td >&nbsp;</td>
					</cfloop>
					<!--- ======================================================================= --->


					<!--- ======================================================================= --->
					<!--- SEPARADOR --->
					<!--- ======================================================================= --->
					<td style="border-right: 1px solid ##CCCCCC; " >&nbsp;</td>
					<!--- ======================================================================= --->

					<!--- ======================================================================= --->
					<!--- Presupuesto del mes --->
					<!--- ======================================================================= --->
					<cfset intNivel = form.nivel >
					<cfset cs1 = intNivel - rsSubCuenta.nivel >
					<cfset cs2 = intNivel - cs1 - 1 >

					<cfloop from="1" to="#cs1#" index="i">
						<td bgcolor="##F5f5f5">&nbsp;</td>
					</cfloop>
					<td bgcolor="##F5f5f5" align="right" nowrap="nowrap" >
						<cfif rsSubCuenta.pmensual GTE 0>#LSNumberFormat(rsSubCuenta.pmensual,'999,999,999,999,999.00')# 
						<cfelse><font color="##FF0000">#LSNumberFormat(rsSubCuenta.pmensual,'999,999,999,999,999.00()')#</font> 
						</cfif>
					</td>

					<cfloop from="1" to="#cs2#" index="i">
						<td bgcolor="##F5f5f5">&nbsp;</td>
					</cfloop>
					<!--- ======================================================================= --->

					<!--- ======================================================================= --->
					<!--- Presupuesto acumulado  --->
					<!--- ======================================================================= --->
					<cfset intNivel = form.nivel >
					<cfset cs1 = intNivel - rsSubCuenta.nivel >
					<cfset cs2 = intNivel - cs1 - 1 >

					<cfloop from="1" to="#cs1#" index="i">
						<td>&nbsp;</td>
					</cfloop>
					<td align="right" nowrap="nowrap" >
						<cfif rsSubCuenta.pfinal GTE 0>#LSNumberFormat(rsSubCuenta.pfinal,'999,999,999,999,999.00')# 
						<cfelse><font color="##FF0000">#LSNumberFormat(rsSubCuenta.pfinal,'999,999,999,999,999.00()')#</font> 
						</cfif>
					</td>

					<cfloop from="1" to="#cs2#" index="i">
						<td>&nbsp;</td>
					</cfloop>
					<!--- ======================================================================= --->

					<!--- ======================================================================= --->
					<!--- SEPARADOR --->
					<!--- ======================================================================= --->
					<td style="border-right: 1px solid ##CCCCCC; " >&nbsp;</td>
					<!--- ======================================================================= --->

					<!--- ======================================================================= --->
					<!--- DIFERENCIAS MES_CONTA|MES_PRES --->
					<!--- ======================================================================= --->
					<cfset intNivel = form.nivel >
					<cfset cs1 = intNivel - rsSubCuenta.nivel >
					<cfset cs2 = intNivel - cs1 - 1 >
					<cfloop from="1" to="#cs1#" index="i">
						<td bgcolor="##F5f5f5">&nbsp;</td>
					</cfloop>

					<td bgcolor="##F5f5f5" align="right" nowrap="nowrap" >
						<cfif (rsSubCuenta.movmes-rsSubCuenta.pmensual) GTE 0>#LSNumberFormat((rsSubCuenta.movmes-rsSubCuenta.pmensual),'999,999,999,999,999.00')# 
						<cfelse><font color="##FF0000">#LSNumberFormat((rsSubCuenta.movmes-rsSubCuenta.pmensual),'999,999,999,999,999.00()')#</font> 
						</cfif>
					</td>
					<cfloop from="1" to="#cs2#" index="i">
						<td bgcolor="##F5f5f5">&nbsp;</td>
					</cfloop>
					<!--- ======================================================================= --->

					<!--- ======================================================================= --->
					<!--- DIFERENCIAS ACUM_CONTA|ACUM_PRES --->
					<!--- ======================================================================= --->
					<cfset intNivel = form.nivel >
					<cfset cs1 = intNivel - rsSubCuenta.nivel >
					<cfset cs2 = intNivel - cs1 - 1 >
					<cfloop from="1" to="#cs1#" index="i">
						<td >&nbsp;</td>
					</cfloop>

					<td align="right" nowrap="nowrap" >
						<cfif (rsSubCuenta.saldofin-rsSubCuenta.pfinal) GTE 0>#LSNumberFormat((rsSubCuenta.saldofin-rsSubCuenta.pfinal),'999,999,999,999,999.00')# 
						<cfelse><font color="##FF0000">#LSNumberFormat((rsSubCuenta.saldofin-rsSubCuenta.pfinal),'999,999,999,999,999.00()')#</font> 
						</cfif>
					</td>
					<cfloop from="1" to="#cs2#" index="i">
						<td >&nbsp;</td>
					</cfloop>


					<!--- ======================================================================= --->



					<!--- completa el total de columnas --->
					<td style=" border-right: 1px solid ##CCCCCC; " >&nbsp;</td>
				</tr>
			</cfloop>
			<cfif tienesubcuentas >
				<tr>
					<td style="border-left: 1px solid ##CCCCCC; padding-left:2; border-right: 1px solid ##CCCCCC; padding-left:2; border-bottom: 1px solid ##CCCCCC; padding-left:2">&nbsp;</td>  
					<td colspan="#form.nivel#" bgcolor="##F5f5f5" style="border-bottom: 1px solid ##CCCCCC; ">&nbsp;</td>  					
					<td style="border-bottom: 1px solid ##CCCCCC; ">&nbsp;</td>
					<td colspan="#form.nivel#" style="border-bottom: 1px solid ##CCCCCC; ">&nbsp;</td>  					
					<td style="border-right: 1px solid ##CCCCCC;  border-bottom: 1px solid ##CCCCCC; ">&nbsp;</td>  					
					<td bgcolor="##f5f5f5" colspan="#form.nivel#" style=" border-bottom: 1px solid ##CCCCCC; ">&nbsp;</td>  					
					<td colspan="#form.nivel#" style="  border-bottom: 1px solid ##CCCCCC; ">&nbsp;</td>  					

					<td style="border-right: 1px solid ##CCCCCC;  border-bottom: 1px solid ##CCCCCC; ">&nbsp;</td>  					
					<td bgcolor="##f5f5f5" colspan="#form.nivel#" style=" border-bottom: 1px solid ##CCCCCC; ">&nbsp;</td>  					
					<td colspan="#form.nivel#" style="  border-bottom: 1px solid ##CCCCCC; ">&nbsp;</td>  					
					
					
					<td style="border-right: 1px solid ##CCCCCC;  border-bottom: 1px solid ##CCCCCC; ">&nbsp;</td>  										
				</tr>
			</cfif>

		</cfloop>
    <tr> 
      <td colspan="#colspan#">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="#colspan#"><div align="center">------------------ Fin del Reporte ------------------</div></td>
    </tr>

  </table>
  <br />
</cfoutput>