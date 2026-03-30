<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="Hist&oacute;rico de Contabilidad" 
returnvariable="LB_Titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ArchivoG" Default="HistoricoDeContabilidadGeneral" 
returnvariable="LB_ArchivoG"/>

<cfset fnGeneraParamsHistContDet()>
<cfif isdefined("form.chkdownload")>
	<cfset fnProcesaDownloadHistContDet()>
<cfelse>
	<cfset fnPreparaDatosHistContDet()>
	<cfset fnProcesaHistContDet()>
</cfif>

<cffunction name="fnGeneraParamsHistContDet" access="private" output="no">
	<cfset LvarCondicionSaldos = "">
		<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and s.Mcodigo = #varMcodigo#">
		</cfif>
		<cfif isdefined("varOcodigo") and Len(varOcodigo) and varOcodigo NEQ -1>
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and s.Ocodigo = #varOcodigo#">
		</cfif>

		<cfif form.periodo eq form.periodo2>
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and s.Speriodo = #form.periodo# ">
			<cfif form.mes eq form.mes2>
				<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and s.Smes = #form.mes# ">
			<cfelse>
				<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and s.Smes >= #form.mes# and s.Smes <= #form.mes2#">
			</cfif>
		<cfelse>
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and   s.Speriodo >= #form.periodo#">
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and   s.Speriodo <= #form.periodo2#">
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and ((s.Speriodo * 12) + s.Smes >=  #form.periodo  * 12 + form.mes# )">
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and ((s.Speriodo * 12) + s.Smes <=  #form.periodo2 * 12 + form.mes2#)">
		</cfif>
		
		<cfset lvarCondicionSaldos = lvarCondicionSaldos & " and (s.SLinicial <> 0  or s.DLdebitos <> 0 or s.CLcreditos <> 0) ">
	
	<cfset LvarCondicion = "">
		<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
			<cfset LvarCondicion = LvarCondicion & " and hd.Mcodigo = #varMcodigo#">
		</cfif>
		<cfif isdefined("varOcodigo") and Len(varOcodigo) and varOcodigo NEQ -1>
			<cfset LvarCondicion = LvarCondicion & " and hd.Ocodigo = #varOcodigo#">
		</cfif>

		<cfif form.periodo eq form.periodo2>
			<cfset LvarCondicion = LvarCondicion & " and hd.Eperiodo = #form.periodo# ">
			<cfif form.mes eq form.mes2>
				<cfset LvarCondicion = LvarCondicion & " and hd.Emes = #form.mes# ">
			<cfelse>
				<cfset LvarCondicion = LvarCondicion & " and hd.Emes >= #form.mes# ">
				<cfset LvarCondicion = LvarCondicion & " and hd.Emes <= #form.mes2#">
			</cfif>
		<cfelse>
			<cfset LvarCondicion = LvarCondicion & " and  hd.Eperiodo >= #form.periodo#">
			<cfset LvarCondicion = LvarCondicion & " and  hd.Eperiodo <= #form.periodo2#">
			<cfset LvarCondicion = LvarCondicion & " and ((hd.Eperiodo * 12) + hd.Emes >=  #form.periodo  * 12 + form.mes#)">
			<cfset LvarCondicion = LvarCondicion & " and ((hd.Eperiodo * 12) + hd.Emes <=  #form.periodo2 * 12 + form.mes2#)">
		</cfif>
	
	<cfset LvarCondicionContable = "">
		<cfif Len(form.Cmayor_Ccuenta1) And Len(form.Cformato1)>
			  <cfset LvarCondicionContable = LvarCondicionContable & " and c.Cformato >= '#form.Cmayor_Ccuenta1#-#form.Cformato1#'">
		<cfelseif Len(form.Cmayor_Ccuenta1) And Len(trim(form.Cformato1)) eq 0>
			  <cfset LvarCondicionContable = LvarCondicionContable & " and c.Cmayor >= '#form.Cmayor_Ccuenta1#'">
		<cfelseif Len(form.Cmayor_Ccuenta1) And not isdefined("form.Cformato1") eq 0>
			  <cfset LvarCondicionContable = LvarCondicionContable & " and c.Cmayor >= '#form.Cmayor_Ccuenta1#'">
		</cfif>
	
		<cfif Len(form.Cmayor_Ccuenta2) And Len(form.Cformato2)>
			  <cfset LvarCondicionContable = LvarCondicionContable & " and c.Cformato <= '#form.Cmayor_Ccuenta2#-#form.Cformato2#'">
		<cfelseif Len(form.Cmayor_Ccuenta2) And Len(trim(form.Cformato2)) eq 0>
			  <cfset LvarCondicionContable = LvarCondicionContable & " and c.Cmayor <= '#form.Cmayor_Ccuenta2#'">
		<cfelseif Len(form.Cmayor_Ccuenta2) And not isdefined("form.Cformato2") eq 0>
			  <cfset LvarCondicionContable = LvarCondicionContable & " and c.Cmayor <= '#form.Cmayor_Ccuenta2#'">
		</cfif>
	
		<cfif isdefined("form.txtCmascara") and Len(form.txtCmascara)>
			  <cf_dbfunction name="like" args="c.Cformato LIKE '#form.txtCmascara#'" returnvariable="LvarLike">
			  <cfset LvarCondicionContable = LvarCondicionContable & " and #LvarLike#">
		</cfif>

	<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t" />
	<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
	<cfset LvarFileName = "#LB_ArchivoG##Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	
	<cfquery name="rsCuentas" datasource="#session.dsn#">
		select c.Cformato, c.Ccuenta, c.Cdescripcion
		from CContables c
		where c.Ecodigo = #session.Ecodigo#
		  and c.Cmovimiento = 'S'
		  and c.Cformato <> c.Cmayor
		#PreserveSingleQuotes(LvarCondicionContable)#
		  and ((
				select count(1)
				from SaldosContables s
				where s.Ccuenta = c.Ccuenta
				  and s.Ecodigo = #session.Ecodigo#
				#LvarCondicionSaldos#
				) > 0 )
		order by c.Cformato
	</cfquery>

	<cfset Lvarmes=''>
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
	
	<cfset Lvarmes2=''>
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
</cffunction>

<cffunction name="fnProcesaDownloadHistContDet" access="private" output="yes">
	<!--- Exporta excel --->
	<cfif findnocase('MSIE ',CGI.HTTP_USER_AGENT,1) neq 0>
		<cfcontent type="application/vnd.ms-excel">
	<cfelse>
		<cfcontent type="application/msexcel">
	</cfif>
	<cfheader name="Content-Disposition" value="attachment; filename=#LvarFileName#">
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
	<cfflush interval="64">
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
			<td align="left"><strong><cf_translate key=LB_Empresa >Empresa</cf_translate></strong></td>
			<td align="left"><strong><cf_translate key=LB_Cuenta>Cuenta</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key=LB_Periodo>Per&iacute;odo</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key=LB_Mes>Mes</cf_translate></strong></td>
			<td align="left"><strong><cf_translate key=LB_DescripcionC>Descripci&oacute;nCuenta</cf_translate></strong></td>
			<td align="left"><strong><cf_translate key=LB_Concepto>Concepto</cf_translate></strong></td>
			<td align="left"><strong><cf_translate key=LB_Poliza>P&oacute;liza</cf_translate></strong></td>
			<td align="left"><strong><cf_translate key=LB_DocumentoAsiento>DocumentoAsiento</cf_translate></strong></td>
			<td align="left"><strong><cf_translate key=LB_FechAsiento>FechaAsiento</cf_translate></strong></td>
			<td align="left"><strong><cf_translate key=LB_Oficina>Oficina</cf_translate></strong></td>
			<td align="left"><strong><cf_translate key=LB_Origen>Origen</cf_translate></strong></td>
			<td align="left"><strong><cf_translate key=LB_Documento>Documento</cf_translate></strong></td>
			<td align="left"><strong><cf_translate key=LB_Referencia>Referencia</cf_translate></strong></td>
			<td align="left"><strong><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key=LB_MontoOriginal>MontoOriginal</cf_translate></strong></td>
			<td align="left"><strong><cf_translate key=LB_Moneda>Moneda</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key=LB_Debitos>D&eacute;bitos</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key=LB_Creditos>Cr&eacute;ditos</cf_translate></strong></td>
		</tr>
		<cfloop query="rsCuentas">
			<cfset _LvarCcuenta = rsCuentas.Ccuenta>
			<cfquery name="data" datasource="#session.dsn#">
				select			
					hd.Eperiodo, hd.Emes, he.Efecha, hd.Ddocumento,
					he.Edocbase as docAsiento,
					hd.Edocumento as poliza,
					he.Oorigen,
					hd.Doriginal,
					m.Miso4217,
					hd.Ddescripcion, hd.Dreferencia, he.Ereferencia,
					hd.Dlocal, hd.Dmovimiento,
					hd.Cconcepto, hd.Ocodigo,
					o.Oficodigo
				from HDContables hd
					inner join HEContables he
						on he.IDcontable = hd.IDcontable
					inner join Oficinas o
						on  o.Ecodigo = hd.Ecodigo
						and o.Ocodigo = hd.Ocodigo
					inner join Monedas m
						on m.Mcodigo = hd.Mcodigo
				where hd.Ccuenta = #_LvarCcuenta#
				  #LvarCondicion#
				<cfif not LvarCHKMesCierre>
					and he.ECtipo <> 1
				<cfelse>
					and he.ECtipo = 1
				</cfif>
				<cfif isdefined("form.ckOrdenXMonto") and form.ckOrdenXMonto EQ 1>
					order by o.Oficodigo, hd.Eperiodo, hd.Emes, hd.Dlocal desc, he.Efecha, hd.Ddescripcion 
				<cfelse>
					order by o.Oficodigo, hd.Eperiodo, hd.Emes, he.Efecha, hd.Ddescripcion 
				</cfif>
			</cfquery>
			<cfoutput query="data">
				<tr>
					<td align="left">#session.Enombre#</td>
					<td align="left">#rsCuentas.Cformato#</td>
					<td align="right">#Eperiodo#</td>
					<td align="right">#Emes#</td>
					<td align="left">#rsCuentas.Cdescripcion#</td>
					<td align="left">#Cconcepto#</td>
					<td align="left">#poliza#</td>
					<td align="left">#docAsiento#</td>
					<td align="left">#DateFormat(Efecha,'yyyy-mm-dd')#</td>
					<td align="left">#ofiCodigo#</td>
					<td align="left">#Oorigen#</td>
					<td align="left">#Ddocumento#</td>
					<td align="left">#Dreferencia#</td>
					<td align="left">#Ddescripcion#</td>
					<td align="right">#NumberFormat(dOriginal, ',0.00')#</td>
					<td align="left">#Miso4217#</td>
					<td align="right"><cfif Dmovimiento is 'D'>#NumberFormat(Dlocal, ',0.00')#</cfif></td>
					<td align="right"><cfif Dmovimiento is 'C'>#NumberFormat(Dlocal, ',0.00')#</cfif></td>
				</tr>
			</cfoutput>
		</cfloop>
	</table>
</cffunction>

<cffunction name="fnPreparaDatosHistContDet" access="private" output="no" hint="Prepara la Informacion para Procesar el Reporte">
	<!---Tabla temporal para guardar las sumatorias por oficina ------>
	<cf_dbtemp name="saldosHCDv1" returnvariable="saldos" datasource="#session.dsn#">
		<cf_dbtempcol name="ccuenta"  			type="numeric" 		mandatory="yes">
		<cf_dbtempcol name="ecodigo"  			type="integer" 		mandatory="yes">
		<cf_dbtempcol name="ocodigo"		    type="integer"	 	mandatory="yes">		
		<cf_dbtempcol name="mcodigo"    		type="numeric"	 	mandatory="yes">
		
		<!--- ---------Local --------------------------------------------------------------->
        <cf_dbtempcol name="saldoinicial"  		type="Money"	 	mandatory="no">		<!--- Saldo Inicial Local --->
        <cf_dbtempcol name="saldofinal"  		type="Money"	 	mandatory="no">			<!--- Saldo Final Local --->
        <cf_dbtempcol name="debitos"	  		type="Money"	 	mandatory="no">			<!--- Débitos Local--->
        <cf_dbtempcol name="creditos"  			type="Money"	 	mandatory="no">		<!--- Creditos Local--->
		<cf_dbtempcol name="movimientos"  		type="Money"	 	mandatory="no">  <!--- Movimientos Local--->

		<!--- ---------Original--------------------------------------------------------------->
        <cf_dbtempcol name="saldoinicialOri"  		type="Money"	 	mandatory="no">	<!--- Saldo Inicial Original--->
        <cf_dbtempcol name="saldofinalOri"  		type="Money"	 	mandatory="no">		<!--- Saldo Final Original--->
        <cf_dbtempcol name="debitosOri"	  		type="Money"	 	mandatory="no">		<!--- Débitos Original--->
        <cf_dbtempcol name="creditosOri"  			type="Money"	 	mandatory="no">	<!--- Creditos Original--->
        <cf_dbtempcol name="movimientosOri"  		type="Money"	 	mandatory="no"><!--- Movimientos Local--->
        
		<cf_dbtempkey cols="ccuenta,ocodigo,mcodigo">
	</cf_dbtemp>


	<!---Cargar tabla temporal con todas las cuentas que se requieren en la consulta---->
	<cfquery datasource="#session.DSN#">
		insert into #saldos# (	
        									ccuenta, 
                                            ecodigo, 
                                            ocodigo, 
                                            mcodigo,
											saldoinicial,
                                            saldoinicialOri, 
                                            debitos, 
                                            debitosOri, 
                                            creditos,
                                            creditosOri, 
                                            movimientos,
                                            movimientosOri, 
                                            saldofinal,
                                            saldofinalOri)
		select 	distinct 
        			s.Ccuenta, 
                    s.Ecodigo, 
                    s.Ocodigo,
				<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
					 #varMcodigo#,
				<cfelse>
					-1,
				</cfif>			
				0.00,
                0.00,
                0.00, 
                0.00, 
                0.00, 
                0.00,
                0.00,
                0.00,
                0.00, 
                0.00
		from SaldosContables s
			inner join CContables c
				on c.Ccuenta = s.Ccuenta
		where s.Ecodigo = #session.Ecodigo#
		  #LvarCondicionSaldos#
		  and c.Cmovimiento = 'S'
		  and c.Cmayor <> c.Cformato
		  #PreserveSingleQuotes(LvarCondicionContable)#
	</cfquery>

	<!----Actualizar saldos ----->
	<cfquery datasource="#session.DSN#"><!---Saldo Inicial ---->
		update #saldos#
		<!--- Actualizacion Saldo inicial Local--->
        set saldoinicial = coalesce
			((select sum(SLinicial)
				from SaldosContables s
				where s.Ccuenta    	= #saldos#.ccuenta
				   and s.Speriodo   = #form.periodo#
				   and s.Smes       = #form.mes#
				   and s.Ocodigo  	= #saldos#.ocodigo
					<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
					   and s.Mcodigo = #saldos#.mcodigo
					</cfif>		  
			), 0.00)
            
         <!--- Actualizacion Saldo inicial Origen--->   
         ,saldoinicialOri = coalesce
			((select sum(SOinicial)
				from SaldosContables s
				where s.Ccuenta    	= #saldos#.ccuenta
				   and s.Speriodo   = #form.periodo#
				   and s.Smes       = #form.mes#
				   and s.Ocodigo  	= #saldos#.ocodigo
					<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
					   and s.Mcodigo = #saldos#.mcodigo
					</cfif>		  
			), 0.00)
	</cfquery>
	
	<cfif not LvarCHKMesCierre>
    <!---------------Debitos --------------->
		<cfquery datasource="#session.DSN#">
			update #saldos#
			set debitos = coalesce  <!---Debitos Local---->
				((select sum(DLdebitos)
					from SaldosContables s
					where s.Ccuenta    = #saldos#.ccuenta
					   and s.Speriodo >= #form.periodo#
					   and s.Speriodo <= #form.periodo2#
					   and s.Ecodigo   = #session.Ecodigo#
					   and s.Ocodigo  = #saldos#.ocodigo
						<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
							and s.Mcodigo = #saldos#.mcodigo
						</cfif>			  
					   and s.Speriodo * 12 + s.Smes between #form.periodo * 12 + form.mes# and #form.periodo2 * 12 + form.mes2#
				), 0.00)
                
                ,debitosOri = coalesce   <!---Debitos Origen---->
				((select sum(DOdebitos)
					from SaldosContables s
					where s.Ccuenta    = #saldos#.ccuenta
					   and s.Speriodo >= #form.periodo#
					   and s.Speriodo <= #form.periodo2#
					   and s.Ecodigo   = #session.Ecodigo#
					   and s.Ocodigo  = #saldos#.ocodigo
						<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
							and s.Mcodigo = #saldos#.mcodigo
						</cfif>			  
					   and s.Speriodo * 12 + s.Smes between #form.periodo * 12 + form.mes# and #form.periodo2 * 12 + form.mes2#
				), 0.00)
		</cfquery>
        
        <!---------------Creditos --------------->
		<cfquery datasource="#session.DSN#">
			update #saldos#
			set creditos = coalesce <!---Creditos  Local----->
				((select sum(CLcreditos)
					from SaldosContables s
					where s.Ccuenta    = #saldos#.ccuenta
					   and s.Speriodo >= #form.periodo#
					   and s.Speriodo <= #form.periodo2#
					   and s.Ecodigo   = #session.Ecodigo#
					   and s.Ocodigo  = #saldos#.ocodigo	
					   <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
						 and s.Mcodigo = #saldos#.mcodigo
					   </cfif>		  
					   and s.Speriodo * 12 + s.Smes between #form.periodo * 12 + form.mes# and #form.periodo2 * 12 + form.mes2#
				), 0.00)
               
               ,creditosOri = coalesce <!---Creditos  Origen----->
				((select sum(COcreditos)
					from SaldosContables s
					where s.Ccuenta    = #saldos#.ccuenta
					   and s.Speriodo >= #form.periodo#
					   and s.Speriodo <= #form.periodo2#
					   and s.Ecodigo   = #session.Ecodigo#
					   and s.Ocodigo  = #saldos#.ocodigo	
					   <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
						 and s.Mcodigo = #saldos#.mcodigo
					   </cfif>		  
					   and s.Speriodo * 12 + s.Smes between #form.periodo * 12 + form.mes# and #form.periodo2 * 12 + form.mes2#
				), 0.00) 
		</cfquery>
	<cfelse>
    <!---Debitos Cierre Anual --->
		<cfquery datasource="#session.DSN#">
        <!---Debitos Cierre Anual Local---->
			update #saldos#
				set debitos =
					coalesce((
							select sum(Dlocal) 
							from HDContables h 
									inner join HEContables e
										on e.IDcontable = h.IDcontable
							where h.Ccuenta  	= #saldos#.ccuenta
							  and h.Ocodigo 	= #saldos#.ocodigo
							  and h.Eperiodo 	= #form.Periodo#
							  and h.Emes     	= #form.mes#
							  <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
								and h.Mcodigo 	= #saldos#.mcodigo
							  </cfif>	
							  and h.Dmovimiento = 'D'
							  and e.ECtipo = 1
							), 0.00)
                            
			<!---Debitos Cierre Anual Origen---->            
                  ,debitosOri =
                        coalesce((
                                select sum(Doriginal) 
                                from HDContables h 
                                        inner join HEContables e
                                            on e.IDcontable = h.IDcontable
                                where h.Ccuenta  	= #saldos#.ccuenta
                                  and h.Ocodigo 	= #saldos#.ocodigo
                                  and h.Eperiodo 	= #form.Periodo#
                                  and h.Emes     	= #form.mes#
                                  <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
                                    and h.Mcodigo 	= #saldos#.mcodigo
                                  </cfif>	
                                  and h.Dmovimiento = 'D'
                                  and e.ECtipo = 1
                                ), 0.00)  
		</cfquery>
        <!---Creditos Cierre Anual  --->
		<cfquery datasource="#session.DSN#">
        <!---Creditos Cierre Anual  Local----->
			update #saldos#
				set creditos =
					coalesce((
							select sum(Dlocal) 
							from HDContables h 
									inner join HEContables e
										on e.IDcontable = h.IDcontable
							where h.Ccuenta  	= #saldos#.ccuenta
							  and h.Ocodigo 	= #saldos#.ocodigo
							  and h.Eperiodo 	= #form.Periodo#
							  and h.Emes     	= #form.mes#
							  <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
								and h.Mcodigo 	= #saldos#.mcodigo
							  </cfif>	
							  and h.Dmovimiento = 'C'
							  and e.ECtipo = 1
							), 0.00)
		<!---Creditos Cierre Anual  Origen----->                            
                   ,creditosOri =
					coalesce((
							select sum(Doriginal) 
							from HDContables h 
									inner join HEContables e
										on e.IDcontable = h.IDcontable
							where h.Ccuenta  	= #saldos#.ccuenta
							  and h.Ocodigo 	= #saldos#.ocodigo
							  and h.Eperiodo 	= #form.Periodo#
							  and h.Emes     	= #form.mes#
							  <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
								and h.Mcodigo 	= #saldos#.mcodigo
							  </cfif>	
							  and h.Dmovimiento = 'C'
							  and e.ECtipo = 1
							), 0.00)         
		</cfquery>
	</cfif>
    <!---- Movimientos ---->
	<cfquery datasource="#session.DSN#">
    <!---- Movimientos  Local---->
		update #saldos#
		set movimientos = debitos - creditos, 
		saldofinal = saldoinicial + debitos - creditos
	
	<!---- Movimientos  original---->
        ,movimientosOri = debitosOri - creditosOri
		,saldofinalOri = saldoinicialOri + debitosOri - creditosOri
	</cfquery>
</cffunction>

<cffunction name="fnLecturaCtaHistContDet" access="private" output="no" returntype="numeric">
	<cfargument name="Ccuenta" type="numeric" required="yes">
	<!---- Totales  Local---->
	<cfset TotalDebitos = 0>
	<cfset TotalCreditos = 0>
    <!---- Totales  Original---->
   <cfset TotalDebitosOri = 0>
	<cfset TotalCreditosOri = 0>
    
    <!--- ---------------------Saldos Iniciales ---------------------------->
	<cfquery name="rsSaldosCuentaI" datasource="#session.DSN#">
		select 
        			sum(s.saldoinicial) as SaldoInicial					<!--- Saldo unicial Local --->
                    ,sum(s.saldoinicialOri) as SaldoInicialOri		<!--- Saldo unicial Original--->
		from #saldos# s
		where s.ccuenta = #Arguments.Ccuenta#
		<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
		  and s.mcodigo = #varMcodigo#
		</cfif>
		<cfif isdefined("varOcodigo") and Len(varOcodigo) and varOcodigo NEQ -1>
		  and s.ocodigo = #varOcodigo#
		</cfif>
	</cfquery>
    <!--- ---------------------Saldos Finales ---------------------------->
	<cfquery name="rsSaldosCuentaF" datasource="#session.DSN#">
		select 
        			sum(s.saldoinicial + s.debitos - s.creditos) as SaldoFinal 						<!--- Saldo unicial Local --->
                    ,sum(s.saldoinicialOri + s.debitosOri - s.creditosOri) as SaldoFinalOri <!--- Saldo unicial Original--->
		from #saldos# s
		where s.ccuenta = #Arguments.Ccuenta#
		<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
		  and s.mcodigo = #varMcodigo#
		</cfif>
		<cfif isdefined("varOcodigo") and Len(varOcodigo) and varOcodigo NEQ -1>
		  and s.ocodigo = #varOcodigo#
		</cfif>
	</cfquery>
    
	<cfif isdefined("rsSaldosCuentaI") and rsSaldosCuentaI.Recordcount GT 0>
		<cfset LvarSLinicial = rsSaldosCuentaI.SaldoInicial>
        <cfset LvarSLinicialOri = rsSaldosCuentaI.SaldoInicialOri>
	</cfif>

	<cfif isdefined("rsSaldosCuentaF") and rsSaldosCuentaF.Recordcount GT 0>
		<cfset LvarSLfinal = rsSaldosCuentaF.SaldoFinal>
        <cfset LvarSLfinalOri = rsSaldosCuentaF.SaldoFinalOri>
	</cfif>
    
	<cfquery name="rsOficinasCuenta" datasource="#session.dsn#">
		select 
			o.Oficodigo, 
			o.Ocodigo,
			min(o.Odescripcion) as Odescripcion,
			sum(saldoinicial) as saldoinicial, 			<!--- Local --->
            sum(saldoinicialOri) as saldoinicialOri, <!--- origen --->
             <!--- Local --->
			sum(debitos) as debitos, 
			sum(creditos) as creditos, 
            <!--- origen --->
            sum(debitosOri) as debitosOri, 
			sum(creditosOri) as creditosOri, 
            
			sum(saldofinal) as saldofinal,
            sum(saldofinalOri) as saldofinalOri
            
		from #saldos# s
			inner join Oficinas o
			on o.Ecodigo = s.ecodigo
			and o.Ocodigo = s.ocodigo
		where s.ccuenta = #Arguments.Ccuenta#
		group by o.Oficodigo, o.Ocodigo
		order by o.Oficodigo
	</cfquery>
	<cfreturn rsOficinasCuenta.recordcount>
</cffunction>

<cffunction name="fnProcessLineHistContDet" access="private" output="no" hint="Procesa los registros de una Oficina - Cuenta">
	<cfargument name="Ccuenta"  type="numeric" required="yes">
	<cfargument name="Ocodigo" type="numeric" required="yes">

	<cfset _LvarOcodigo 			= Arguments.Ocodigo>
    <!--- Local --->
	<cfset TotalDebitos 				= TotalDebitos + rsOficinasCuenta.debitos>
	<cfset TotalCreditos 	 			= TotalCreditos + rsOficinasCuenta.creditos>
	<cfset _LvarDebitos 				= rsOficinasCuenta.debitos>
	<cfset _LvarCreditos 			= rsOficinasCuenta.Creditos>s
	<cfset _LvarSaldoFinal			= rsOficinasCuenta.saldofinal>
	<cfset _LvarSaldoInicial			= rsOficinasCuenta.saldoinicial>
    <!--- Origen--->
	<cfset TotalDebitosOri 			= TotalDebitosOri + rsOficinasCuenta.debitosOri>
	<cfset TotalCreditosOri 		= TotalCreditosOri + rsOficinasCuenta.creditosOri>
	<cfset _LvarDebitosOri 			= rsOficinasCuenta.debitosOri>
	<cfset _LvarCreditosOri 		= rsOficinasCuenta.CreditosOri>
	<cfset _LvarSaldoFinalOri		= rsOficinasCuenta.saldofinalOri>
	<cfset _LvarSaldoInicialOri		= rsOficinasCuenta.saldoinicialOri>
    
	<cfset _LvarOdescripcion 	= rsOficinasCuenta.Odescripcion>
	
	<cfquery name="data" datasource="#session.dsn#">
		select			
			hd.Eperiodo, 			hd.Emes,				he.Efecha, 		
			m.Miso4217, 			hd.Ddescripcion, 	hd.Dreferencia, 
			he.Oorigen,  			hd.Doriginal,			he.Ereferencia,
			hd.Dlocal, 				hd.Dmovimiento, 	hd.Cconcepto,
			hd.Ddocumento, 	m.Msimbolo, hd.Dtipocambio,	
			hd.Edocumento as poliza, 					m.Mnombre,
			he.Edocbase as docAsiento
		from HDContables hd
			inner join HEContables he
				on he.IDcontable = hd.IDcontable
			inner join Monedas m
				on m.Mcodigo = hd.Mcodigo
		where hd.Ccuenta = #Arguments.Ccuenta#
		  and hd.Ocodigo = #Arguments.Ocodigo#
		  #LvarCondicion#
		<cfif not LvarCHKMesCierre>
			and he.ECtipo <> 1
		<cfelse>
			and he.ECtipo = 1
		</cfif>
		<cfif isdefined("form.ckOrdenXMonto") and form.ckOrdenXMonto EQ 1>
			order by hd.Eperiodo, hd.Emes, hd.Dlocal desc, he.Efecha, hd.Ddescripcion 
		<cfelse>
			order by hd.Eperiodo, hd.Emes, he.Efecha, hd.Ddescripcion 
		</cfif>
	</cfquery>
</cffunction>


<cffunction name="fnProcesaHistContDet" access="private" output="yes">
	<style type="text/css">
		* { font-size:11px; font-family:Verdana, Arial, Helvetica, sans-serif }
		.niv1 { font-size: 18px; }
		.niv2 { font-size: 16px; }
		.niv3 { font-size: 12px; }
		.niv4 { font-size: 10px; }
	</style>	
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
			<td colspan="17" align="right">
				<cf_htmlreportsheaders
					title="#LB_Titulo#" 
					filename="#LvarFileName#" 
					ira="HistoricoContabilidad.cfm">
			</td>
		</tr>
	</table>
	<cfflush interval="64">
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<cfoutput>
	<tr>
		<td colspan="<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>12<cfelse>6</cfif>"> #DateFormat(Now(),'dd-mm-yyyy')#</td>
		<td colspan="5">&nbsp;</td>
		<td colspan="6" align="right">#TimeFormat(Now(), 'HH:mm:ss')#</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
		<td colspan="<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>22<cfelse>14</cfif>" align="center" style="font-size:18px">#HTMLEditFormat(session.Enombre)#</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
		<td colspan="<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>22<cfelse>14</cfif>" align="center" style="font-size:16px"><cf_translate key=LB_Titulo>Consulta Hist&oacute;rico de Contabilidad General</cf_translate></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;&nbsp;</td>
		<td colspan="<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>22<cfelse>14</cfif>" align="center" style="font-size:12px"><cf_translate key=LB_Oficina>Oficina</cf_translate>: &nbsp;#NombreOficina#</td>
		<td>&nbsp;</td>
	</tr>
	
	<tr>
		<td colspan="3">&nbsp;</td>
		<td colspan="<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>22<cfelse>14</cfif>" align="center"><cf_translate key = LB_Desde>Desde</cf_translate>: #form.periodo#&nbsp;#Lvarmes#&nbsp;&nbsp;&nbsp;<cf_translate key = LB_Hasta>Hasta</cf_translate>: #form.periodo2#&nbsp;#Lvarmes2#</td>
		<td colspan="1">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="17">&nbsp;</td>
	</tr>
	</cfoutput>
	<cfloop query="rsCuentas">
		<cfset _LvarCcuenta      = rsCuentas.Ccuenta> 
		<cfset _LvarCdescripcion = rsCuentas.Cdescripcion> 
		<cfset _LvarCformato     = rsCuentas.Cformato>
		<cfset _LvarCantidadReg	 = fnLecturaCtaHistContDet(_LvarCcuenta)>
		<tr>
			<cfoutput>
			<td colspan="<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>20<cfelse>14</cfif>">
            	<strong><cf_translate key=LB_Cuenta>Cuenta</cf_translate>: #_LvarCformato# #_LvarCdescripcion# </strong>
			</td>		 
			<td align="right" ><strong><cf_translate key=LB_SaldoIni>Saldo Inicial</cf_translate>:</strong></td>
			<td>&nbsp;&nbsp;</td>
			<td align="right" nowrap="nowrap"><strong>#NumberFormat(LvarSLinicial, '(,0.00)')#</strong></td>
			</cfoutput>
		</tr>
		<cfloop query="rsOficinasCuenta">
			<cfset fnProcessLineHistContDet(_LvarCcuenta, rsOficinasCuenta.Ocodigo)>
			<cfoutput>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>&nbsp;</td><td>&nbsp;&nbsp;&nbsp;</td>
                <td colspan="<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>18<cfelse>12</cfif>">
                	<strong><cf_translate key=LB_Oficina>Oficina</cf_translate>: #_LVarOdescripcion# </strong>
				</td>
				<td align="right"><strong><cf_translate key=LB_SaldoIni>Saldo Inicial</cf_translate> <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>Local</cfif>:</strong></td>
                 <td>&nbsp;&nbsp;</td>
				<td align="right">#NumberFormat(_Lvarsaldoinicial, '(,0.00)')#</td>
			</tr>
            <!--- Saldo Inicial Origen --->
            <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
                <tr>
                    <td align="right" colspan="21"><strong><cf_translate key =LB_SaldoIni>Saldo Inicial</cf_translate> <cf_translate key=LB_Origen> Origen</cf_translate>:</strong></td> 
                    <td>&nbsp;&nbsp;</td>
                    <td align="right">#NumberFormat(_LvarsaldoinicialOri, '(,0.00)')#</td>
                </tr>
			</cfif>  
			   <tr><td>&nbsp;</td></tr>       
			<tr>
				<td>&nbsp;</td> <td>&nbsp;</td> <td>&nbsp;&nbsp;&nbsp;</td>
				<td align="center"><strong><cf_translate key=LB_Anio>A&ntilde;o</cf_translate></strong></td>
				<td align="center"><strong><cf_translate key=LB_Mes>Mes</cf_translate></strong></td>
				<td align="center"><strong><cf_translate key=LB_Fecha>Fecha</cf_translate></strong></td>
				<td align="center">&nbsp;</td>
				<td ><strong><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate></strong></td>
				<td>&nbsp;</td>
				<td><strong><cf_translate key=LB_Referencia>Referencia</cf_translate></strong></td>
				<td>&nbsp;</td>
				<td><strong><cf_translate key=LB_Documento>Documento</cf_translate></strong></td>
				<td align="right">&nbsp;<strong><cf_translate key = LB_Lote>Lote</cf_translate></strong>&nbsp;</td>
				<td align="right"><strong><cf_translate key=LB_Poliza>#PolizaE#</cf_translate>&nbsp;</strong></td>
                
                <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
					<!--- Moneda --->
	                <td align="center"><strong><cf_translate key=LB_Moneda>Moneda</cf_translate></strong></td>
					<!--- Tipo de Cambio--->
                     <td align="right"><strong><cf_translate key=LB_TipoCambio>Tipo de Cambio</cf_translate></strong></td> 
                    
                    <td align="right" ><strong><cf_translate key=LB_Debitos> D&eacute;bitos&nbsp;</cf_translate> <cf_translate key=LB_Origen> Origen</cf_translate></strong></td>
                     <td>&nbsp;&nbsp;</td> 
                    <td align="right"><strong>Cr&eacute;ditos&nbsp; Origen</strong></td>
                    <td>&nbsp;&nbsp;</td> 
                </cfif>
                
                <td align="right"><strong><cf_translate key=LB_Debitos>D&eacute;bitos&nbsp;</cf_translate> <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1> Local</cfif></strong></td>
				 <td>&nbsp;&nbsp;</td> 
				<td align="right"><strong><cf_translate key=LB_Creditos>Cr&eacute;ditos&nbsp;</cf_translate> <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1> Local</cfif></strong></td>
			</tr>
			</cfoutput>
			<cfoutput query="data">
				<tr class="<cfif (CurrentRow) Mod 2>listaPar<cfelse>listaNon</cfif>">
				<td>&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;</td>
				<td align="center" class="niv4">#Eperiodo#</td>
				<td align="center"  class="niv4">#Emes#</td>
				<td align="center" class="niv4">#DateFormat(Efecha,'dd/mm/yyyy')#</td>
				<td>&nbsp;</td>
				<td class="niv4">#HTMLEditFormat(Ddescripcion)#</td>
				<td  class="niv4">&nbsp;</td>
				<td class="niv4">#HTMLEditFormat(Dreferencia)#</td>
				<td>&nbsp;</td>
				<td class="niv4">#HTMLEditFormat(Ddocumento)#</td>
				<td align="right" class="niv4">#Cconcepto#&nbsp;</td>
				<td align="right" class="niv4">#poliza#</td>

			<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>                
					<!--- Moneda --->
                    <td align="center" class="niv4">#Miso4217#</td>    
                    <!--- Tipo de Cambio --->
                     <td align="center" class="niv4">#Dtipocambio#</td> 
                    
                    <td align="right" class="niv4"><cfif Dmovimiento is 'D'>#NumberFormat(Doriginal, ',0.00')#</cfif></td>
                     <td>&nbsp;&nbsp;</td> 
                    <td align="right" class="niv4"><cfif Dmovimiento is 'C'>#NumberFormat(Doriginal, ',0.00')#</cfif></td>
                    <td>&nbsp;&nbsp;</td> 
                </cfif>
                
				<td align="right" class="niv4"><cfif Dmovimiento is 'D'>#NumberFormat(Dlocal, ',0.00')#</cfif></td>
				 <td>&nbsp;&nbsp;</td> 
				<td align="right" class="niv4"><cfif Dmovimiento is 'C'>#NumberFormat(Dlocal, ',0.00')#</cfif></td>
				</tr>
			</cfoutput>
			<!--- Total por Oficina dentro de una Cuenta --->
			<cfoutput>
			<tr>
				<td valign="bottom">&nbsp;&nbsp;&nbsp;</td>
				<td valign="bottom">&nbsp;&nbsp;&nbsp;</td>
				<td valign="bottom">&nbsp;&nbsp;&nbsp;</td>
                <td valign="bottom">&nbsp;&nbsp;</td>
                
				<td colspan="<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>12<cfelse>10</cfif>" valign="bottom">
                	<strong>Total #_LvarOdescripcion#: </strong>
				</td>

				<!--- Debitos y creditos moneda Origen --->
                <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
                    <td align="right" valign="bottom"><hr>#NumberFormat(_LvardebitosOri, '(,0.00)')#</td>
                     <td valign="bottom">&nbsp;&nbsp;</td> 
                    <td align="right" valign="bottom"><hr>#NumberFormat(_LvarcreditosOri, '(,0.00)')#</td>
                    <td valign="bottom">&nbsp;&nbsp;</td> 
                </cfif>
                
                <td align="right" valign="bottom"><hr>#NumberFormat(_Lvardebitos, '(,0.00)')#</td>
				 <td valign="bottom">&nbsp;&nbsp;</td> 
				<td align="right" valign="bottom"><hr>#NumberFormat(_Lvarcreditos, '(,0.00)')#</td>
			</tr>
			<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
                <tr>
                    <td valign="bottom">&nbsp;&nbsp;&nbsp;</td>
                    <td valign="bottom">&nbsp;&nbsp;&nbsp;</td>
                    <td valign="bottom">&nbsp;&nbsp;&nbsp;</td>
                    <td colspan="19" valign="bottom"><strong> <cf_translate key=LB_SaldoFin>Saldo Final</cf_translate>  <cf_translate key=LB_Origen>Origen </cf_translate>#_LvarOdescripcion#: </strong></td>
                    <td align="right" valign="bottom">#NumberFormat(_LvarsaldofinalOri, '(,0.00)')#</td>
                </tr>
            </cfif>
            <tr>
           		 <td valign="bottom">&nbsp;&nbsp;&nbsp;</td>
				<td valign="bottom">&nbsp;&nbsp;&nbsp;</td>
				<td valign="bottom">&nbsp;&nbsp;&nbsp;</td>
                <td colspan="<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>19<cfelse>13</cfif>" valign="bottom">
                <strong><cf_translate key=LB_SaldoFin> Saldo Final</cf_translate> Local #_LvarOdescripcion#: </strong>
                </td>
				<td align="right" valign="bottom">#NumberFormat(_Lvarsaldofinal, '(,0.00)')#</td>
            </tr>    
			</cfoutput>
		</cfloop>
		<!--- Total por Cuenta --->
		<cfoutput>
			<tr>
				<td colspan="<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>16<cfelse>13</cfif>" valign="bottom">
                	<strong><cf_translate key=LB_TotalCuenta>Total Cuenta</cf_translate> #_LvarCformato# #_LvarCdescripcion#: </strong>
				</td>
				
				<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
                    <td align="right" valign="bottom"><hr><strong>#NumberFormat(TotalDebitosOri, '(,0.00)')#</strong></td>
                     <td valign="bottom">&nbsp;&nbsp;</td> 
                    <td align="right" valign="bottom"><hr><strong>#NumberFormat(TotalCreditosOri, '(,0.00)')#</strong></td>
                    <td valign="bottom">&nbsp;&nbsp;</td> 
                </cfif>
                
                <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo EQ -1>
	                <td valign="bottom">&nbsp;&nbsp;</td>
                </cfif>
                
                <td align="right" valign="bottom"><hr><strong>#NumberFormat(TotalDebitos, '(,0.00)')#</strong></td>
				 <td valign="bottom">&nbsp;&nbsp;</td> 
				<td align="right" valign="bottom"><hr><strong>#NumberFormat(TotalCreditos, '(,0.00)')#</strong></td>
                
			</tr>
			<tr>
				<td colspan="<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>22<cfelse>16</cfif>" valign="bottom">
                	<strong><cf_translate key=LB_SaldoFin>Saldo Final</cf_translate> #_LvarCformato# #_LvarCdescripcion#:</strong>
				</td>
				<td align="right" valign="bottom"><strong>#NumberFormat(LvarSLfinal, '(,0.00)')#</strong></td>
			</tr>
			<tr>
				<td colspan="<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>20<cfelse>17</cfif>" valign="bottom">&nbsp;</td>
			</tr>
		</cfoutput>
	</cfloop>
		<tr><td colspan="<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>24<cfelse>17</cfif>" align="center">----------------------------------- Fin de la Consulta -----------------------------------</td></tr>
	</table>
</cffunction>
