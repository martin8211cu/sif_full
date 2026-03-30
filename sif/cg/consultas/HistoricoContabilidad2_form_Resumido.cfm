<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 5-4-2006.
		Motivo: Se agrega el tag de impresión y un link de regresar, al hacer click en regresar conserva los valores de los filtros. 
--->
<cfset debug = "false">
<cfset fnPreparaDatosHistConRes()>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="Consulta Hist&oacute;rico de Contabilidad General" 
returnvariable="LB_Titulo" xmlfile="HistoricoContabilidad2_form_Resumido.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ArchivoR" Default="Historico_Contabilidad_Resumido" 
returnvariable="LB_ArchivoR"/>
<cfif isDefined('form.chkdownload') and isDefined("form.chkResumido")>
	<cf_exportQueryToFile query="#rsReporte#" separador="#chr(9)#" filename="#LB_ArchivoR#_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="false">
</cfif>
	
<table width="980" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td align="right" style="width:100%">
		<cf_htmlreportsheaders title="#LB_Titulo#" 
		filename="#LB_ArchivoR##Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls" 
		ira="HistoricoContabilidad.cfm">
		</td>
	</tr>
</table>
<cfflush interval="64">
<table width="980"  border="0" cellspacing="0" cellpadding="2">
	<cfoutput>
	<tr>
		<td colspan="2"> #DateFormat(Now(),'dd-mm-yyyy')#</td>
		<td colspan="6" align="center" style="font-size:18px">#HTMLEditFormat(session.Enombre)#</td>
		<td align="right">#TimeFormat(Now(), 'HH:mm:ss')#</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
		<td colspan="6" align="center" style="font-size:16px">#LB_Titulo#</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
		<td colspan="6" align="center" style="font-size:12px"><cf_translate key=LB_ResumidoPorOficina>Resumido&nbsp;por&nbsp;Oficina</cf_translate>: &nbsp;#NombreOficina#</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
		<td colspan="6" align="center"><cf_translate key=LB_Desde>Desde</cf_translate>: #form.periodo#&nbsp;#Lvarmes#&nbsp;&nbsp;&nbsp;<cf_translate key=LB_Hasta>Hasta</cf_translate>: #form.periodo2#&nbsp;#Lvarmes2#</td>
		<td colspan="2">&nbsp;</td>
	</tr>
	</cfoutput>
	<tr>
		<td colspan="2">&nbsp;</td>
		<td colspan="6">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<cfoutput query="rsReporte" group="FormatoCuenta">
		<cfset TotalSaldosI= 0>
		<cfset TotalDebitos = 0>
		<cfset TotalCreditos = 0>
		<cfset TotalMovimientos = 0>
		<cfset TotalSaldosF = 0>
		<cfset HayRegistros = True>
		<tr>
			<td colspan="9"><strong><cf_translate key=LB_Cuenta>Cuenta</cf_translate>: #FormatoCuenta#</strong><strong> - #Descripción#</strong></td>
		</tr>
		<tr>
			<td>&nbsp;&nbsp;</td>
			<td align="left" colspan="3" rowspan><strong><cf_translate key=LB_Oficina>Oficina</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key=LB_SaldoIni>Saldo Inicial</cf_translate> </strong></td>
			<td align="right"><strong><cf_translate key=LB_Debitos>D&eacute;bitos</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key=LB_Creditos>Cr&eacute;ditos</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key=LB_Movimiento>Movimiento</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key=LB_SaldoFin>Saldo Final</cf_translate> </strong></td>
		</tr>
		<cfoutput>
			<tr class="<cfif (CurrentRow-1) Mod 4 gt 1>listaPar<cfelse>listaNon</cfif>">
				<td>&nbsp;&nbsp;</td>
				<td align="left" colspan="3" rowspan>#Oficina#</td>
				<td align="right">#NumberFormat(saldoinicial, '(,0.00)')#</td>
				<td align="right">#NumberFormat(debitos, ',0.00')#</td>
				<td align="right">#NumberFormat(creditos, ',0.00')#</td>
				<td align="right">#NumberFormat(movimientos, ',0.00')#</td>
				<td align="right">#NumberFormat(saldofinal, '(,0.00)')#</td>
			</tr>
			<cfset TotalSaldosI = TotalSaldosI + saldoinicial>
			<cfset TotalDebitos = TotalDebitos + debitos>
			<cfset TotalCreditos = TotalCreditos + creditos>
			<cfset TotalMovimientos = TotalMovimientos + movimientos>
			<cfset TotalSaldosF = TotalSaldosF + saldofinal>
		</cfoutput>
		<!--- Corte por oficina --->
		<tr class="listaCorte">
			<td valign="bottom" colspan="4"><strong><cf_translate key=LB_Totales>Totales</cf_translate>:</strong>&nbsp;</td>
			<td align="right"><hr><strong>#NumberFormat(TotalSaldosI, ',0.00')#</strong></td>
			<td align="right" valign="top"><hr><strong>#NumberFormat(TotalDebitos, ',0.00')#</strong></td>
			<td align="right" valign="top"><hr><strong>#NumberFormat(TotalCreditos, ',0.00')#</strong></td>
			<td align="right" valign="top"><hr><strong>#NumberFormat(TotalMovimientos, ',0.00')#</strong></td>
			<td align="right" valign="top"><hr><strong>#NumberFormat(TotalSaldosF, ',0.00')#</strong></td>
		</tr>
	</cfoutput> 
	<cfoutput>
		<cfif IsDefined('HayRegistros')>
		<tr><td colspan="14" align="center">----------------------------------- <cf_translate key = LB_FinConsulta>Fin de la Consulta</cf_translate> -----------------------------------</td></tr>
		<cfelse>
		<tr><td colspan="14" align="center">----------------------------------- <cf_translate key = LB_SinRegistros>No hay resultados</cf_translate> -----------------------------------</td></tr>
		</cfif>
	</cfoutput>
</table>
<cfoutput>
	</body> 
	</html> 
</cfoutput>

<cffunction name="fnPreparaDatosHistConRes" access="private" output="no">	
	<cf_dbtemp name="saldosHCRv1" returnvariable="saldos" datasource="#session.dsn#">
    	<cf_dbtempcol name="cdescripcion"		type="varchar(100)"	mandatory="no">
		<cf_dbtempcol name="ccuenta"  			type="numeric" 		mandatory="no">
		<cf_dbtempcol name="ecodigo"  			type="integer"  	mandatory="no">
		<cf_dbtempcol name="ocodigo"		    type="integer"	 	mandatory="no">		
		<cf_dbtempcol name="speriododesde"		type="integer"	 	mandatory="no">
		<cf_dbtempcol name="smesdesde"  		type="integer" 		mandatory="no">
		<cf_dbtempcol name="speriodohasta"		type="integer"  	mandatory="no">
		<cf_dbtempcol name="smeshasta" 			type="integer"  	mandatory="no">
		<cf_dbtempcol name="cformato"  			type="varchar(100)"	mandatory="no">
		<cf_dbtempcol name="mcodigo"    		type="numeric"	 	mandatory="no">
		<cf_dbtempcol name="saldoinicial"  		type="Money"	 	mandatory="no">
		<cf_dbtempcol name="debitos"	  		type="Money"	 	mandatory="no">
		<cf_dbtempcol name="creditos"  			type="Money"	 	mandatory="no">
		<cf_dbtempcol name="movimientos"  		type="Money"	 	mandatory="no">
		<cf_dbtempcol name="saldofinal"  		type="Money"	 	mandatory="no">
	</cf_dbtemp>

	<cfset LvarCondicionSaldos = "">
		<cfif form.periodo eq form.periodo2>
			<cfset LvarCondicionSaldos = " and s.Speriodo = #form.periodo# ">
			<cfif form.mes eq form.mes2>
				<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and s.Smes = #form.mes# ">
			<cfelse>
				<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and s.Smes between #form.mes# and #form.mes2#">
			</cfif>
		<cfelse>
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and  s.Speriodo between #form.periodo# and #form.periodo2#">
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and (s.Speriodo >  #form.periodo# or s.Smes >= #form.mes#)">
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and (s.Speriodo <  #form.periodo2# or s.Smes <= #form.mes2#)">
		</cfif>
		
		<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and s.Mcodigo = #varMcodigo#">
		</cfif>
		<cfif isdefined("varOcodigo") and Len(varOcodigo) and varOcodigo NEQ -1>
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and s.Ocodigo = #varOcodigo#">
		</cfif>
		<cfset lvarCondicionSaldos = lvarCondicionSaldos & " and (s.SLinicial <> 0  or s.DLdebitos <> 0 or s.CLcreditos <> 0) ">
	
	<cfquery datasource="#session.DSN#">
		insert into #saldos# (
			cdescripcion, ccuenta, ecodigo, ocodigo, 
			cformato, 
			mcodigo, 
			speriododesde, smesdesde, 
			speriodohasta, smeshasta, 
			saldoinicial, debitos, creditos, movimientos, saldofinal)
		select distinct 
			c.Cdescripcion, c.Ccuenta, c.Ecodigo, s.Ocodigo, 
			c.Cformato, 
			<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
				#varMcodigo#,
			<cfelse>
				-1,
			</cfif>
			#form.periodo#, #form.mes#, #form.periodo2#, #form.mes2#, 
			0.00, 0.00, 0.00, 0.00, 0.00
		from CContables c
			inner join SaldosContables s
			on s.Ccuenta = c.Ccuenta
		where c.Ecodigo = #session.Ecodigo#
		<cfif Len(form.Cmayor_Ccuenta1) And Len(form.Cformato1)>
			and c.Cformato >= '#form.Cmayor_Ccuenta1#-#form.Cformato1#'
		<cfelseif Len(form.Cmayor_Ccuenta1) And Len(trim(form.Cformato1)) eq 0>
			and c.Cmayor >= '#form.Cmayor_Ccuenta1#'
		<cfelseif Len(form.Cmayor_Ccuenta1) And not isdefined("form.Cformato1") eq 0>
			and c.Cmayor >= '#form.Cmayor_Ccuenta1#'
		</cfif>
		
		<cfif Len(form.Cmayor_Ccuenta2) And Len(form.Cformato2)>
			and c.Cformato <= '#form.Cmayor_Ccuenta2#-#form.Cformato2#'
		<cfelseif Len(form.Cmayor_Ccuenta2) And Len(trim(form.Cformato2)) eq 0>
			and c.Cmayor <= '#form.Cmayor_Ccuenta2#'
		<cfelseif Len(form.Cmayor_Ccuenta2) And not isdefined("form.Cformato2") eq 0>
			and c.Cmayor <= '#form.Cmayor_Ccuenta2#'
		</cfif>

		<cfif isdefined("form.txtCmascara") and Len(form.txtCmascara)>
			and <cf_dbfunction name="like" args="c.Cformato LIKE '#form.txtCmascara#'">
		</cfif>

		and c.Cmovimiento = 'S'
		#LvarCondicionSaldos#
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		update #saldos#
		set saldoinicial = coalesce
			((	
				select sum(SLinicial)
				from SaldosContables s
				where s.Ccuenta    	= #saldos#.ccuenta
				  and s.Speriodo   	= #saldos#.speriododesde
				  and s.Smes       	= #saldos#.smesdesde
				  and s.Ocodigo  	= #saldos#.ocodigo
				  <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
					  and s.Mcodigo = #saldos#.mcodigo
				  </cfif>
			), 0.00)
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		update #saldos#
		set debitos = coalesce
			((
			select sum(DLdebitos)
			from SaldosContables s
			where s.Ccuenta    = #saldos#.ccuenta
			and s.Speriodo >= #saldos#.speriododesde
			and s.Speriodo <= #saldos#.speriodohasta
			and s.Ecodigo   = #saldos#.ecodigo
			and s.Ocodigo  = #saldos#.ocodigo
			<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
				and s.Mcodigo = #saldos#.mcodigo
			</cfif>
			and s.Speriodo * 12 + s.Smes between #saldos#.speriododesde * 12 + #saldos#.smesdesde and #saldos#.speriodohasta * 12 + #saldos#.smeshasta
		), 0.00)
	</cfquery>

	<cfquery datasource="#session.DSN#">
		update #saldos#
			set creditos = coalesce
			((
			select sum(CLcreditos)
			from SaldosContables s
			where s.Ccuenta    = #saldos#.ccuenta
			and s.Speriodo >= #saldos#.speriododesde
			and s.Speriodo <= #saldos#.speriodohasta
			and s.Ecodigo   = #saldos#.ecodigo
			and s.Ocodigo  = #saldos#.ocodigo
			<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
			and s.Mcodigo = #saldos#.mcodigo
			</cfif>
			and s.Speriodo * 12 + s.Smes between #saldos#.speriododesde * 12 + #saldos#.smesdesde and #saldos#.speriodohasta * 12 + #saldos#.smeshasta
		), 0.00)
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		delete from #saldos#
		where saldoinicial = 0.00 and debitos = 0.00 and creditos = 0.00
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		update #saldos#
		set movimientos = debitos - creditos, 
		saldofinal = saldoinicial + debitos - creditos
	</cfquery>
	
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select 
        	d.cdescripcion as Descripción,
			d.cformato as FormatoCuenta,
			o.Oficodigo,
			o.Odescripcion as Oficina,
			d.saldoinicial,
			d.debitos,
			d.creditos,
			d.movimientos,
			d.saldofinal
		from #saldos# d
			inner join Oficinas o
			on o.Ecodigo = d.ecodigo
			and o.Ocodigo = d.ocodigo
		where 1 = 1
		<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
			and d.mcodigo = #varMcodigo#
		</cfif>
		<cfif isdefined("varOcodigo") and Len(varOcodigo) and varOcodigo NEQ -1>
			and d.ocodigo = #varOcodigo#
		</cfif>
		order by 1, 2
	</cfquery>
	
	<cfswitch expression="#form.mes#">
		<cfcase value="1"><cfset Lvarmes='Enero'></cfcase>
		<cfcase value="2"><cfset Lvarmes='Febrero'></cfcase>
		<cfcase value="3"><cfset Lvarmes='Marzo'></cfcase>
		<cfcase value="4"><cfset Lvarmes='Abril'></cfcase>
		<cfcase value="5"><cfset Lvarmes='Mayo'></cfcase>
		<cfcase value="6"><cfset Lvarmes='Junio'></cfcase>
		<cfcase value="7"><cfset Lvarmes='Julio'></cfcase>
		<cfcase value="8"><cfset Lvarmes='Agosto'></cfcase>
		<cfcase value="9"><cfset Lvarmes='Septiembre'></cfcase>
		<cfcase value="10"><cfset Lvarmes='Octubre'></cfcase>
		<cfcase value="11"><cfset Lvarmes='Noviembre'></cfcase>
		<cfcase value="12"><cfset Lvarmes='Diciembre'></cfcase>
	</cfswitch>
	
	<cfswitch expression="#form.mes2#">
		<cfcase value="1"><cfset Lvarmes2='Enero'></cfcase>
		<cfcase value="2"><cfset Lvarmes2='Febrero'></cfcase>
		<cfcase value="3"><cfset Lvarmes2='Marzo'></cfcase>
		<cfcase value="4"><cfset Lvarmes2='Abril'></cfcase>
		<cfcase value="5"><cfset Lvarmes2='Mayo'></cfcase>
		<cfcase value="6"><cfset Lvarmes2='Junio'></cfcase>
		<cfcase value="7"><cfset Lvarmes2='Julio'></cfcase>
		<cfcase value="8"><cfset Lvarmes2='Agosto'></cfcase>
		<cfcase value="9"><cfset Lvarmes2='Septiembre'></cfcase>
		<cfcase value="10"><cfset Lvarmes2='Octubre'></cfcase>
		<cfcase value="11"><cfset Lvarmes2='Noviembre'></cfcase>
		<cfcase value="12"><cfset Lvarmes2='Diciembre'></cfcase>
	</cfswitch>

	<cfquery datasource="#session.DSN#">
		delete from #saldos#
	</cfquery>
</cffunction>
