<cfinclude template="../../../Utiles/sifConcat.cfm">

<cf_htmlReportsHeaders
	title="Reporte de NAPs por cuenta" 
	filename="rptNapsCta.xls"
	irA="NapsXCta.cfm">
<!--- ****************** PARAMS ****************** --->
<cfif isdefined("url.CtaPres")>
	<cfset form.CtaPres=url.CtaPres>
</cfif>
<cfif isdefined("url.CPPid")>
	<cfset form.CPPid=url.CPPid>
</cfif>
<cfif isdefined("url.txtDesdeNap")>
	<cfset form.txtDesdeNap=url.txtDesdeNap>
</cfif>
<cfif isdefined("url.txtHastaNap")>
	<cfset form.txtHastaNap=url.txtHastaNap>
</cfif>
<cfif isdefined("url.FechaNapD")>
	<cfset form.FechaNapD=url.FechaNapD>
</cfif>
<cfif isdefined("url.FechaNapH")>
	<cfset form.FechaNapH=url.FechaNapH>
</cfif>
<cfif isdefined("url.FechaOriD")>
	<cfset form.FechaOriD=url.FechaOriD>
</cfif>
<cfif isdefined("url.FechaOriH")>
	<cfset form.FechaOriH=url.FechaOriH>
</cfif>
<cfif isdefined("url.txtDocument")>
	<cfset form.txtDocument=url.txtDocument>
</cfif>
<cfif isdefined("url.txtReferencia")>
	<cfset form.txtReferencia=url.txtReferencia>
</cfif>
<cfif isdefined("url.LModulos")>
	<cfset form.LModulos=url.LModulos>
</cfif>


<cfset LvarContL = 5>
<cfset LvarLineasPagina = 45>
<cfset LvarPAg = 1>  
<!--- <cfdump var="#form.CtaPres#"> --->
<!--- <cfdump var="#form.CPPid#"> --->


<!--- ****************** QUERYS ****************** --->
<!--- QUERY MODULOS --->
<cfquery name="rsModulos" datasource="#Session.DSN#">
	select Oorigen, Odescripcion 
	from Origenes
	where Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#form.LModulos#">
</cfquery>

<!--- QUERY PERIODOS --->
<cfquery name="rsPeriodo" datasource="#Session.DSN#">
			select CPPid, 
				   CPPtipoPeriodo, 
				   CPPfechaDesde, 
				   CPPfechaHasta, 
				   CPPfechaUltmodif, 
				   CPPestado,
				   'Presupuesto ' #_Cat#
						case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
							#_Cat# ' de ' #_Cat# 
							case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
							#_Cat# ' a ' #_Cat# 
							case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
					as CPPdescripcion
			from CPresupuestoPeriodo p
			where p.Ecodigo = #Session.Ecodigo#
			  and p.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
		</cfquery>
<!--- CREACION DE TABLA TEMPORAL --->
<cf_dbtemp name="tblNapsXCta" returnvariable="NAPS">
	<cf_dbtempcol name="Linea"  				type="numeric">
	<cf_dbtempcol name="CPcuenta"     			type="numeric">
	<cf_dbtempcol name="Ecodigo"  	    		type="int">
	<cf_dbtempcol name="CPformato"    	    	type="char(100)">
	<cf_dbtempcol name="CPNAPnum"     	    	type="numeric">
	<cf_dbtempcol name="CPNAPDlinea"  	    	type="int">
	<cf_dbtempcol name="CPCano"       	    	type="int">
	<cf_dbtempcol name="CPCmes"       	    	type="int">
	<cf_dbtempcol name="CPNAPmoduloOri"	    	type="char(4)">
	<cf_dbtempcol name="CPNAPdocumentoOri"  	type="varchar(20)">
	<cf_dbtempcol name="CPNAPDtipoMov"      	type="char(2)">
	<cf_dbtempcol name="CPNAPDmontoOri"     	type="money">
	<cf_dbtempcol name="CPNAPDtipoCambio"   	type="float(15)">
	<cf_dbtempcol name="CPNAPDdisponibleAntes"  type="money">
	<cf_dbtempcol name="CPNAPDmonto"         	type="money">
	<cf_dbtempcol name="DisponibleGenerado"    	type="money">
	<cf_dbtempcol name="Original"    	        type="money">
	<cf_dbtempcol name="Modificado"    	        type="money">
	<cf_dbtempcol name="Trasladado"    	        type="money">
	<cf_dbtempcol name="Autorizado"    	        type="money">
	<cf_dbtempcol name="Reservado"    	        type="money">
	<cf_dbtempcol name="Comprometido"    	    type="money">
	<cf_dbtempcol name="Ejecutado"    	        type="money">
	<cf_dbtempcol name="Consumido"    	        type="money">
	<cf_dbtempcol name="Ejercido"    	        type="money">
	<cf_dbtempcol name="Pagado"    	            type="money">
	<cf_dbtempcol name="Disponible"    	        type="money">
			
	<cf_dbtempkey cols="Linea">
</cf_dbtemp>

<!--- QUERY PRINCIPAL --->
<cfquery name="rsListReportNaps" datasource="#Session.DSN#">
	 drop table #NAPS#
	select 0 as Linea, c.CPcuenta, c.Ecodigo, c.CPformato, b.CPNAPnum, b.CPNAPDlinea,
	b.CPCano, b.CPCmes, a.CPNAPmoduloOri, a.CPNAPdocumentoOri, b.CPNAPDtipoMov,
	b.CPNAPDmontoOri, b.CPNAPDtipoCambio,
	b.CPNAPDdisponibleAntes, b.CPNAPDmonto, b.CPNAPDdisponibleAntes + (b.CPNAPDmonto * b.CPNAPDsigno) as DisponibleGenerado,
	round(convert(money, case b.CPNAPDtipoMov when 'A' then b.CPNAPDmonto else 0.00 end),2) as Original,
	round(convert(money, case b.CPNAPDtipoMov when 'M' then b.CPNAPDmonto else 0.00 end),2) as Modificado,
	round(convert(money, case b.CPNAPDtipoMov when 'T' then b.CPNAPDmonto when 'TE' then b.CPNAPDmonto else 0.00 end),2) as Trasladado,
	0.00 as Autorizado,
	round(convert(money, case b.CPNAPDtipoMov when 'RC' then b.CPNAPDmonto when 'RP' then b.CPNAPDmonto else 0.00 end),2) as Reservado,
	round(convert(money, case b.CPNAPDtipoMov when 'CC' then b.CPNAPDmonto else 0.00 end),2) as Comprometido,
	round(convert(money, case b.CPNAPDtipoMov when 'E' then b.CPNAPDmonto else 0.00 end),2) as Ejecutado,
	0.00 as Consumido,
	round(convert(money, case b.CPNAPDtipoMov when 'EJ' then b.CPNAPDmonto else 0.00 end),2) as Ejercido,
	round(convert(money, case b.CPNAPDtipoMov when 'P' then b.CPNAPDmonto else 0.00 end),2) as Pagado,
	0.00 as Disponible
	into #NAPS#
	from CPNAP a 
	inner join CPNAPdetalle b
		inner join CPresupuesto c
		on b.Ecodigo = c.Ecodigo and b.CPcuenta = c.CPcuenta
		and c.CPformato like '#TRIM(form.CtaPres)#'
	on a.Ecodigo = b.Ecodigo and a.CPNAPnum = b.CPNAPnum
	where a.CPPid = #TRIM(form.CPPid)# 
	<cfif isDefined("form.LModulos") AND  #form.LModulos# NEQ "">
		and UPPER(a.CPNAPmoduloOri) like '%#UCase(TRIM(form.LModulos))#%'
	</cfif>
	<cfif isDefined("form.txtDocument") AND  #form.txtDocument# NEQ "">
		and UPPER(a.CPNAPdocumentoOri) like ('%#UCase(TRIM(form.txtDocument))#%')
	</cfif>
	<cfif isDefined("form.txtReferencia") AND  #form.txtReferencia# NEQ "">
		and UPPER(a.CPNAPreferenciaOri) like ('%#UCase(TRIM(form.txtReferencia))#%')
	</cfif>
	<cfif isDefined("form.txtDesdeNap") AND  #form.txtDesdeNap# NEQ "">
	    and a.CPNAPnum >= #form.txtDesdeNap#
	</cfif>
	<cfif isDefined("form.txtHastaNap") AND  #form.txtHastaNap# NEQ "">
	    and a.CPNAPnum <= #form.txtHastaNap#
	</cfif>
	<cfif isDefined("form.FechaNapD") AND  #form.FechaNapD# NEQ "">
	    and a.CPNAPfecha >= '#LSDateFormat(TRIM(form.FechaNapD),'yyyy-mm-dd')#'
	</cfif>
	<cfif isDefined("form.FechaNapH") AND  #form.FechaNapH# NEQ "">
	    and a.CPNAPfecha <= '#LSDateFormat(TRIM(form.FechaNapH),'yyyy-mm-dd')#'
	</cfif>
	<cfif isDefined("form.FechaOriD") AND  #form.FechaOriD# NEQ "">
	    and a.CPNAPfechaOri >= '#LSDateFormat(TRIM(form.FechaOriD),'yyyy-mm-dd')#'
	</cfif>
	<cfif isDefined("form.FechaOriH") AND  #form.FechaOriH# NEQ "">
	    and a.CPNAPfechaOri <= '#LSDateFormat(TRIM(form.FechaOriH),'yyyy-mm-dd')#'
	</cfif>
	
	order by b.CPCano, b.CPCmes, b.CPNAPnum, b.CPNAPnumRef desc, b.CPNAPDsigno*b.CPNAPDmonto desc, b.CPNAPDlinea

	alter table #NAPS# alter column Autorizado money null
	alter table #NAPS# alter column Consumido money null
	alter table #NAPS# alter column Disponible money null

	Declare @Cont as Integer
	select @Cont = 0
	update #NAPS# set Linea = @Cont, @Cont = @Cont+1

	update #NAPS# SET
	Autorizado = Original + Modificado + Trasladado, 
	Consumido = Reservado + Comprometido + Ejecutado,
	Disponible = (Original +  Modificado + Trasladado) -
				(Reservado + Comprometido + Ejecutado) 
	where Linea = 1	

	update #NAPS# SET
	Original = Original +
	(select sum(b.Original) from #NAPS#  b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Modificado = Modificado +
	(select sum(b.Modificado) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Trasladado = Trasladado +
	(select sum(b.Trasladado) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Autorizado = Original + Modificado + Trasladado +
	(select sum(b.Original + b.Modificado + b.Trasladado) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Reservado = Reservado +
	(select sum(b.Reservado) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Comprometido = Comprometido +
	(select sum(b.Comprometido) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Ejecutado = Ejecutado +
	(select sum(b.Ejecutado) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Consumido = Reservado + Comprometido + Ejecutado +
	(select sum(b.Reservado + b.Comprometido + b.Ejecutado) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Ejercido = Ejercido +
	(select sum(b.Ejercido) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Pagado = Pagado +
	(select sum(b.Pagado) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Disponible = (Original +  Modificado + Trasladado) -
				(Reservado + Comprometido + Ejecutado) +
	(select sum((b.Original +  b.Modificado + b.Trasladado) -
				(b.Reservado + b.Comprometido + b.Ejecutado)) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea)
	where Linea > 1			

	select * from #NAPS# 
	</cfquery>

<!--- <cf_dump var="#rsListReportNaps#"> --->

<!--- ****************** CREACION DE REPORTE ****************** --->

<cfoutput>
	<cfset sbGeneraEstilos()>
	<cfset Encabezado()>
	<cfif #rsListReportNaps.recordcount# GT 0>
		<cfset Creatabla()>
    <cfset titulos()>
	<cfflush interval="512">
	<cfset LvarCtaAnt = "">
	<cfloop query="rsListReportNaps" >
		<cfset sbCortePagina()>
		<tr>
			<td align="center" class="Datos">#rsListReportNaps.CPformato#</td>
			<td align="center" class="Datos">#rsListReportNaps.CPNAPnum#</td>
			<td align="center" class="Datos">#rsListReportNaps.CPNAPDlinea#</td>
			<td align="center" class="Datos">#rsListReportNaps.CPCano#</td>
			<td align="center" class="Datos">#rsListReportNaps.CPCmes#</td>
			<td align="center" class="Datos">#rsListReportNaps.CPNAPmoduloOri#</td>
			<td align="center" class="Datos">#rsListReportNaps.CPNAPdocumentoOri#</td>
			<td align="center" class="Datos">#rsListReportNaps.CPNAPDtipoMov#</td>
			<td align="right"  class="Datos">#LSNumberFormat(rsListReportNaps.CPNAPDmontoOri,',9.00')#</td>
			<td align="center" class="Datos">#rsListReportNaps.CPNAPDtipoCambio#</td>
			<td align="right"  class="Datos">#LSNumberFormat(rsListReportNaps.CPNAPDdisponibleAntes,',9.00')#</td>
			<td align="right"  class="Datos">#LSNumberFormat(rsListReportNaps.CPNAPDmonto,',9.00')#</td>
			<td align="right"  class="Datos">#LSNumberFormat(rsListReportNaps.DisponibleGenerado,',9.00')#</td>
			<td align="right"  class="Datos">#LSNumberFormat(rsListReportNaps.Original,',9.00')#</td>
			<td align="right"  class="Datos">#LSNumberFormat(rsListReportNaps.Modificado,',9.00')#</td>
			<td align="right"  class="Datos">#LSNumberFormat(rsListReportNaps.Trasladado,',9.00')#</td>
			<td align="right"  class="Datos">#LSNumberFormat(rsListReportNaps.Trasladado,',9.00')#</td>
			<td align="right"  class="Datos">#LSNumberFormat(rsListReportNaps.Reservado,',9.00')#</td>
			<td align="right"  class="Datos">#LSNumberFormat(rsListReportNaps.Comprometido,',9.00')#</td>
			<td align="right"  class="Datos">#LSNumberFormat(rsListReportNaps.Ejecutado,',9.00')#</td>
			<td align="right"  class="Datos">#LSNumberFormat(rsListReportNaps.Consumido,',9.00')#</td>
			<td align="right"  class="Datos">#LSNumberFormat(rsListReportNaps.Ejercido,',9.00')#</td>
			<td align="right"  class="Datos">#LSNumberFormat(rsListReportNaps.Pagado,',9.00')#</td>
			<td align="right"  class="Datos">#LSNumberFormat(rsListReportNaps.Disponible,',9.00')#</td>
		</tr>
	</cfloop>
	<cfset Cierratabla()>
	</body>
	</html>
	</cfif>
	<cfif #rsListReportNaps.recordcount# EQ 0>
		<br><br><br>
		<div align="center" style="font-size:15px">-- No existe informaci&oacute;n que coincida con los filtros proporcionados --</div>
		<div align="center" style="font-size:15px">-- Haga clic en el bot&oacute;n <strong>Regresar</strong> y modifique los filtros --</div>
		<br>
	</cfif>
</cfoutput>



<!--- ****************** FUNCION TITULOS ****************** --->
<cffunction name="titulos" output="true">
	<tr>
		<td align="center" class="ColHeader" colspan="1"></td>
		<td align="center" class="ColHeader" colspan="4">NAP</td>
		<td align="center" class="ColHeader" colspan="8"></td>
		<td align="center" class="ColHeader" colspan="11">Saldos Acumulados</td>
	</tr>
	<tr>
		<td align="center" class="ColHeader">Cuenta</td>
		<td align="center" class="ColHeader">NAP</td>
		<td align="center" class="ColHeader">NAP-Linea</td>
		<td align="center" class="ColHeader">Periodo</td>
		<td align="center" class="ColHeader">Mes</td>
		<td align="center" class="ColHeader">Origen</td>
		<td align="center" class="ColHeader">Documento</td>
		<td align="center" class="ColHeader">Tipo<br>Movimiento</td>
		<td align="center" class="ColHeader">Monto<br>Origen</td>
		<td align="center" class="ColHeader">Tipo<br>Cambio</td>
		<td align="center" class="ColHeader">Disponible<br>Antes</td>
		<td align="center" class="ColHeader">Movimiento<br>Autorizado</td>
		<td align="center" class="ColHeader">Disponible<br>Generado</td>
		<td align="center" class="ColHeader">Autorizado</td>
		<td align="center" class="ColHeader">Ordinario</td>
		<td align="center" class="ColHeader">Trasladado</td>
		<td align="center" class="ColHeader">Autorizado</td>
		<td align="center" class="ColHeader">Reservado</td>
		<td align="center" class="ColHeader">Comprometido</td>
		<td align="center" class="ColHeader">Devengado</td>
		<td align="center" class="ColHeader">Consumido<br>Total</td>
		<td align="center" class="ColHeader">Ejercido</td>
		<td align="center" class="ColHeader">Pagado</td>
		<td align="center" class="ColHeader">Disponible</td>
	</tr>
</cffunction>

<cffunction name="sbGeneraEstilos" output="true">
	<style type="text/css">
		H1.Corte_Pagina
		{
		PAGE-BREAK-AFTER: always
		}
		
		.ColHeader 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		9px;
			font-weight: 	bold;
			padding-left: 	0px;
			border:		1px solid ##CCCCCC;
			background-color:##CCCCCC
		}
	
		.Header 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		12px;
			font-weight: 	bold;
			padding-left: 	0px;
			text-align:	center;
		}
	
		.Header1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		14px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
		.Corte1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		12px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
	
		.Datos 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	none;
			white-space:nowrap;
		}
	
		body
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		11px;
		}
	</style>
</cffunction>
<!--- ***************** FUNCION ENCABEZADO ****************** --->
<cffunction name="Encabezado" output="true">
	<table width="100%" border="0">
		<tr>
			<td  class="Header1" colspan="24" align="center">
				<strong>#ucase(session.Enombre)#</strong>
			</td>
		</tr>
		<tr>
			<td  class="Header1" colspan="24" align="center"><strong>REPORTE DE NAPS POR CUENTA</strong></td>
		</tr>
		<tr>
			<td class="Header" colspan="24" align="center"><strong>#ucase(rsPeriodo.CPPDESCRIPCION)#</strong></td>
		</tr>
		<cfif isDefined("form.CtaPres") AND  #form.CtaPres# NEQ "">
			<tr>
			<td class="Header" colspan="25" align="center">
				<strong>CUENTA: #form.CtaPres#</strong>
			</td>
			</tr>
		</cfif>
		<cfif #rsModulos.recordcount# GT 0>
			<tr>
			<td class="Header" colspan="24" align="center">
				<strong>M&Oacute;DULO: #rsModulos.Oorigen# - #rsModulos.Odescripcion#</strong>
			</td>
			</tr>
		</cfif>
		<cfif isDefined("form.txtDesdeNap") AND  #form.txtDesdeNap# NEQ ""
		  AND isDefined("form.txtHastaNap") AND  #form.txtHastaNap# NEQ "">
			<tr>
			<td class="Header" colspan="24" align="center">
				<strong>DESDE NAP: #form.txtDesdeNap# HASTA NAP: #form.txtHastaNap#</strong>
			</td>
			</tr>
		</cfif>
		<cfif isDefined("form.txtDocument") AND  #form.txtDocument# NEQ "">
			<tr>
			<td class="Header" colspan="25" align="center">
				<strong>DOCUMENTO: #form.txtDocument#</strong>
			</td>
			</tr>
		</cfif>
		<cfif isDefined("form.txtReferencia") AND  #form.txtReferencia# NEQ "">
			<tr>
			<td class="Header" colspan="24" align="center">
				<strong>REFERENCIA: #form.txtReferencia#</strong>
			</td>
			</tr>
		</cfif>
		<cfif isDefined("form.FechaNapD") AND  #form.FechaNapD# NEQ ""
		  AND isDefined("form.FechaNapH") AND  #form.FechaNapH# NEQ "">
			<tr>
			<td class="Header" colspan="24" align="center">
				<strong>PERIODO DE FECHAS NAP: #form.FechaNapD# - #form.FechaNapH#</strong>
			</td>
			</tr>
		</cfif>
		<cfif isDefined("form.FechaOriD") AND  #form.FechaOriD# NEQ ""
		  AND isDefined("form.FechaOriH") AND  #form.FechaOriH# NEQ "">
			<tr>
			<td class="Header" colspan="24" align="center">
				<strong>PERIODO DE FECHAS DOCUMENTO: #form.FechaOriD# - #form.FechaOriH#</strong>
			</td>
			</tr>
		</cfif>
		<tr></tr>
	</table>
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="Creatabla" output="true">
	<table width="100%" border="0">
</cffunction>


<!--- ****************** FUNCION CIERRE TABLA ****************** --->
<cffunction name="Cierratabla" output="true">
	</table>
</cffunction>


<!--- ***************** FUNCION CORTE ****************** --->
<cffunction name="sbCortePagina" output="true">
	<cfif isdefined("LvarNoCortes")>
		<cfreturn>
	</cfif>
	<cfif LvarContL GTE LvarLineasPagina>
		<tr><td><H1 class=Corte_Pagina></H1></td></tr>
		<cfset Cierratabla()>
		<cfset LvarPAg   = LvarPAg + 1>
		<cfset LvarContL = 5> 
		<cfset Encabezado()>
		<cfset Creatabla()>
		<cfset titulos()>
	</cfif>
	<cfset LvarContL = LvarContL + 1>  
</cffunction>