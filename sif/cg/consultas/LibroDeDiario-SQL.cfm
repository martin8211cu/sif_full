 <!---
 Modificado Por Israel Rodríguez Fecha 25-04-2012
 Se realiza Adecuación  para que tenga la funcionalidad de  cambiar la traduccion de las etiquetas
 --->
 
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Reporte Libro de Diario" 
returnvariable="LB_Titulo" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mayor" default="Mayor" 
returnvariable="LB_Mayor" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default="Cuenta" 
returnvariable="LB_Cuenta" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Periodo" default="Periodo" 
returnvariable="LB_Periodo" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" 
returnvariable="LB_Fecha" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Lote" default="Lote" 
returnvariable="LB_Lote" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Poliza" default="Póliza" 
returnvariable="LB_Poliza" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Oficina" default="Oficina" 
returnvariable="LB_Oficina" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" 
returnvariable="LB_Documento" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripción" 
returnvariable="LB_Descripcion" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Ref" default="Ref" 
returnvariable="LB_Ref" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Monto" default="Monto" 
returnvariable="LB_Monto" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" 
returnvariable="LB_Moneda" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Debitos" default="Débitos" 
returnvariable="LB_Debitos" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Creditos" default="Créditos" 
returnvariable="LB_Creditos" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Movimiento" default="Movimiento" 
returnvariable="LB_Movimiento" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Acumulado" default="Acumulado" 
returnvariable="LB_Acumulado" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalCuenta" default="Total Cuenta" 
returnvariable="LB_TotalCuenta" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalMayor" default="Total Mayor" 
returnvariable="LB_TotalMayor" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DesdeCuenta" default="Desde Cuenta" 
returnvariable="LB_DesdeCuenta" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_HastaCuenta" default="Hasta Cuenta" 
returnvariable="LB_HastaCuenta" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalFecha" default="Total Fecha" 
returnvariable="LB_TotalFecha" xmlfile="LibroDeDiario-SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SaldoIni" default="SALDO INICIAL" 
returnvariable="LB_SaldoIni" xmlfile="LibroDeDiario-SQL.xml"/>
<cfsetting requesttimeout="36000">

<cfif isdefined("url.mcodigoopt") and url.mcodigoopt EQ "0">
	<cfset varMcodigo = url.Mcodigo>
<cfelse>
	<cfset varMcodigo = -1>
</cfif>

<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20007
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
<cfset typeRep = 1>
<cfif url.formato EQ "pdf">
	<cfset typeRep = 2>
</cfif>

<cfset lvarCformato1 = "">
<cfset lvarCformato2 = "">
<!---
<cfif isdefined('url.CMAYOR_CCUENTA1') and len(trim(url.CMAYOR_CCUENTA1)) GT 0>
	<cfset lvarCformato1 = trim(#url.CMAYOR_CCUENTA1#)>
	<cfif isdefined('url.Cformato1') and len(trim(url.Cformato1)) GT 0>
		<cfset lvarCformato1 = lvarCformato1 & "-" & trim(url.Cformato1)>
		
	</cfif>
</cfif>
<cfif isdefined('url.CMAYOR_CCUENTA2') and len(trim(url.CMAYOR_CCUENTA2)) GT 0>
	<cfset lvarCformato2 = trim(#url.CMAYOR_CCUENTA2#)>
	<cfif isdefined('url.Cformato2') and len(trim(url.Cformato2)) GT 0>
		<cfset lvarCformato2 = lvarCformato2 & "-" & trim(url.Cformato2)>
	</cfif>
</cfif>
--->
<cfif isdefined('url.Ccuenta1') and len(trim(url.Ccuenta1)) GT 0>
	<cfquery datasource="#session.dsn#" name="rsSQL">
		select Cformato
		from CContables
		where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ccuenta1#">
	</cfquery>
	<cfset lvarCformato1 = rsSQL.Cformato>
</cfif>
<cfif isdefined('url.Ccuenta2') and len(trim(url.Ccuenta2)) GT 0>
	<cfquery datasource="#session.dsn#" name="rsSQL">
		select Cformato
		from CContables
		where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ccuenta2#">
	</cfquery>
	<cfset lvarCformato2 = rsSQL.Cformato>
</cfif>
<cfif isdefined('url.CMAYOR_CCUENTA1') and len(trim(url.CMAYOR_CCUENTA1)) GT 0>
	<cfset lvarCformato1 = trim(#url.CMAYOR_CCUENTA1#)>
	<cfif isdefined('url.Cformato1') and len(trim(url.Cformato1)) GT 0>
		<cfquery datasource="#session.dsn#" name="Ccontables">
			select a.Cformato
				from CContables a
				 inner join CFinanciera b
				 	on a.Ccuenta = b.Ccuenta
				where b.CFformato = '#lvarCformato1 & "-" & trim(url.Cformato1)#'
				  and b.Ecodigo = #session.Ecodigo#
		</cfquery>	
		<cfset lvarCformato1 = Ccontables.Cformato>
	</cfif>
</cfif>
<cfif isdefined('url.CMAYOR_CCUENTA2') and len(trim(url.CMAYOR_CCUENTA2)) GT 0>
	<cfset lvarCformato2 = trim(#url.CMAYOR_CCUENTA2#)>
	<cfif isdefined('url.Cformato2') and len(trim(url.Cformato2)) GT 0>
		<cfquery datasource="#session.dsn#" name="Ccontables">
			select a.Cformato
				from CContables a
				 inner join CFinanciera b
				 	on a.Ccuenta = b.Ccuenta
				where b.CFformato = '#lvarCformato2 & "-" & trim(url.Cformato2)#'
				  and b.Ecodigo = #session.Ecodigo#
		</cfquery>	
		<cfset lvarCformato2 = Ccontables.Cformato>
	</cfif>
</cfif>

<cfparam name="url.CHKMesCierre" default="0">
<cfinvoke returnvariable="rs_Res" component="sif.Componentes.CG_BalanzaDetalle" method="balanzaDetalle">
	<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
	<cfinvokeargument name="periodo1" value="#url.periodo1#">
	<cfinvokeargument name="mes1" value="#url.mes1#">
	<cfinvokeargument name="periodo2" value="#url.periodo2#">
	<cfinvokeargument name="mes2" value="#url.mes2#">
	<cfinvokeargument name="cuentaini" value="#lvarCformato1#">
	<cfinvokeargument name="cuentafin" value="#lvarCformato2#">
	<cfif isdefined("url.fechaini") and Len(Trim(url.fechaini))>
		<cfinvokeargument name="fechaini" value="#LSParseDateTime(url.fechaini)#">
	</cfif>
	<cfif isdefined("url.fechafin") and Len(Trim(url.fechafin))>
		<cfinvokeargument name="fechafin" value="#LSParseDateTime(url.fechafin)#">
	</cfif>
	<cfinvokeargument name="Ocodigo" value="#url.Ocodigo#">
	<cfinvokeargument name="Mcodigo" value="#varMcodigo#">
	<cfinvokeargument name="ordenamiento" value="#url.Ordenamiento#">
	<cfinvokeargument name="mescierre" value="#url.CHKMesCierre#">
	<!---
	<cfinvokeargument name="calcularAcumulado" value="# url.formato EQ 'ExcelColumnar' #">
	--->
	<cfinvokeargument name="calcularAcumulado" value="false">
	<cfif isdefined('url.CHKMovimientos') and url.CHKMovimientos>
		<cfinvokeargument name="sinMovimientos" value="false">
	</cfif>
</cfinvoke>	
	
<cfset ErrorNum = 0>
<cfset ErrorMsg = "">
<cfquery datasource="#session.dsn#" name="contar">
	select count(1) as cantidad
	from DCGRBalanzaDetalle a
	where a.CGRBDid = #rs_Res#
</cfquery>
<cfif contar.cantidad GT 5000>
	<cfif contar.cantidad GT 65000>
		<cfif ListFindNoCase('bightml',url.formato) EQ 0>
			<cfset ErrorNum = 1>
			<cfset ErrorMsg = "El Reporte devolverá #contar.cantidad# registros, mas de 65000, debe pedirlo en formato Descarga de HTML.">
		</cfif>
	<cfelse>
		<cfif ListFindNoCase('bightml,ExcelColumnar',url.formato) EQ 0>
			<cfset ErrorNum = 2>
			<cfset ErrorMsg = "El Reporte devolverá #contar.cantidad# registros, mas de 5000, debe pedirlo en formato Descarga de HTML o Excel Columnar.">
		</cfif>
	</cfif>
</cfif>

<cfif ErrorNum GT 0>
	<cfquery datasource="#Session.DSN#">
		delete from DCGRBalanzaDetalle
		where CGRBDid = #rs_Res#
	</cfquery>

	<cfquery datasource="#Session.DSN#">
		delete from CGRBalanzaDetalle
		where CGRBDid = #rs_Res#
	</cfquery>
	<cf_errorCode	code = "50234"
					msg  = "@errorDat_1@ Proceso Cancelado!"
					errorDat_1="#ErrorMsg#"
	>
</cfif>

<cfset rangotipos = ''>
<cfif lvarCformato1 EQ '' and lvarCformato2 EQ ''>
	<cfset rangotipos = " ">
</cfif>


<cfif Len(Trim(lvarCformato1)) or  Len(Trim(lvarCformato2))>
	<cfif len(trim(lvarCformato1)) GT 0>
		<cfset rangotipos = "#LB_DesdeCuenta# " & lvarCformato1>
	<cfelse>
		<cfset rangotipos = "">
	</cfif>		
	<cfif len(trim(lvarCformato2)) GT 0>
		<cfset rangotipos = rangotipos & " #LB_HastaCuenta# " & lvarCformato2>
	</cfif>		
</cfif>

<cfif url.formato EQ 'ExcelColumnar'>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select 
				em.Edescripcion as Empresa,
				b.Cformato as Cuenta, 
				a.Eperiodo as Periodo,
				a.Emes as Mes,
				b.Cdescripcion as DescripcionCuenta,
				hd.Cconcepto as Concepto, 
				hd.Edocumento Poliza, 
				he.Edocbase as DocumentoAsiento,
				a.Efecha as FechaAsiento,
				o.Oficodigo as Oficina, 
				coalesce(he.Oorigen,'') as Origen,
				case a.IDcontable when -10 then '#LB_SaldoIni#' else coalesce(hd.Ddocumento, '  N / A') end as Documento, 
				coalesce(hd.Dreferencia,'') as Referencia,
				hd.Ddescripcion as Descripcion,
				coalesce(a.montoorigen, 0.00) as MontoOriginal,
				m.Miso4217 as Moneda,
				coalesce(a.debitos, 0.00) as Debitos, 
				coalesce(a.creditos, 0.00) as Creditos
		from DCGRBalanzaDetalle a
			inner join CContables b
			on b.Ccuenta = a.Ccuenta

			left outer join Oficinas o
			on o.Ecodigo = a.Ecodigo
			and o.Ocodigo = a.Ocodigo

			left outer join HDContables hd
					inner join HEContables he
					on he.IDcontable = hd.IDcontable

					inner join ConceptoContableE c
					on  c.Ecodigo      = hd.Ecodigo
					and c.Cconcepto    = hd.Cconcepto

					inner join Monedas m
					on m.Mcodigo = hd.Mcodigo

			on hd.IDcontable = a.IDcontable
			and hd.Dlinea         = a.Dlinea

			inner join  Empresas em
			on em.Ecodigo = a.Ecodigo
		where a.CGRBDid = #rs_Res#
		<cfif isdefined("url.Ordenamiento")>
				<cfif url.Ordenamiento GT 1>
				and a.montoorigen is not null
				</cfif>
		</cfif>
		order by 
			b.Cmayor, 
			b.Cformato, 
			<cfif isdefined("url.Ordenamiento")>
				<cfif url.Ordenamiento EQ 1>
					a.Efecha, a.Cconcepto, he.Edocumento,
				</cfif>

				<cfif url.Ordenamiento EQ 2>
					a.Efecha, a.montoorigen desc, a.Cconcepto, he.Edocumento,
				</cfif>

				<cfif url.Ordenamiento EQ 3>
					a.montoorigen desc, a.Cconcepto, he.Edocumento,
				</cfif>
			</cfif>
			a.DCGRBDlinea
	</cfquery>

	<cfquery datasource="#Session.DSN#">
		delete from DCGRBalanzaDetalle
		where CGRBDid = #rs_Res#
	</cfquery>

	<cf_QueryToFile query="#rsReporte#" filename="BalanzaDetalle.xls">

<cfelse>
	<cf_dbfunction name='to_char' args="a.Eperiodo" returnvariable='LvarEperiodo'>
    <cf_dbfunction name='to_char' args="a.Emes" returnvariable='LvarEmes'>
    <cfset LvarFecha = dateformat(now(), 'DD/MM/YYYY HH:MM:SS')>
	<cfsavecontent variable="myquery">
	<cfoutput>
		select 
				b.Cmayor as Mayor, 
				b.Cformato as Formato, 
				b.Cdescripcion as DescCuenta,
				a.Eperiodo as Periodo,
				a.Emes as Mes,
                <cf_dbfunction name='concat' args="#LvarEperiodo# + ' - ' + #LvarEmes#" delimiters='+'> as PeriodoMes,
				coalesce(he.Edescripcion,'') as DescEnca,
				he.Edocumento as Edocumento,
				coalesce(he.Oorigen,'') as Origen,
                a.Efecha as Efecha ,
				hd.Cconcepto as Concepto, 
				hd.Edocumento Poliza, 
				case a.IDcontable when -10 then '#LB_SaldoIni#' else coalesce(hd.Ddocumento, '  N / A') end as Documento, 
				coalesce(hd.Dreferencia,'') as Dreferencia,
				a.montoorigen as MontoOriginal,
				m.Miso4217 as Moneda,
				coalesce(a.saldoini,0) as SaldoInicial, 
				coalesce(a.debitos,0) as Debitos, 
				coalesce(a.creditos,0) as Creditos, 
				coalesce(a.acumulado, 0) as Acumulado,
                '#LvarFecha#' as fecha_hora, 
				o.Oficodigo as Oficina, hd.Dtipocambio as TipoCambio,
				em.Edescripcion,
				hd.Ddescripcion
		from DCGRBalanzaDetalle a
			inner join CContables b
			on b.Ccuenta = a.Ccuenta

			left outer join Oficinas o
			on o.Ecodigo = a.Ecodigo
			and o.Ocodigo = a.Ocodigo

			left outer join HDContables hd
				inner join HEContables he
				on he.IDcontable = hd.IDcontable

				inner join ConceptoContableE c
				on  c.Ecodigo      = hd.Ecodigo
				and c.Cconcepto    = hd.Cconcepto

				inner join Monedas m
				on m.Mcodigo = hd.Mcodigo

			on hd.IDcontable = a.IDcontable
			and hd.Dlinea    = a.Dlinea

			inner join  Empresas em
			on em.Ecodigo = a.Ecodigo
		where a.CGRBDid = #rs_Res#
		<cfif isdefined("url.Ordenamiento")>
				<cfif url.Ordenamiento GT 0>
				and a.montoorigen is not null
				</cfif>
		</cfif>
		order by 
			b.Cmayor, 
			b.Cformato, 
			<cfif isdefined("url.Ordenamiento")>
				<cfif url.Ordenamiento EQ 1>
					a.Efecha, a.Cconcepto, he.Edocumento,
				</cfif>

				<cfif url.Ordenamiento EQ 2>
					a.Efecha, a.montoorigen desc, a.Cconcepto, he.Edocumento,
				</cfif>

				<cfif url.Ordenamiento EQ 3>
					a.montoorigen desc, a.Cconcepto, he.Edocumento,
				</cfif>
			</cfif>
			a.DCGRBDlinea
	</cfoutput>
	</cfsavecontent>
	
	<cfif url.formato eq 'bightml'>
        <cfheader name="Content-Disposition" value="attachment;filename=BalanzaDetalle.htm" >
        <cfflush interval="32">
        <cfquery name="rsReporte" datasource="#session.DSN#">
            #PreserveSingleQuotes(myquery)#
        </cfquery>

		<cfquery datasource="#Session.DSN#">
			delete from DCGRBalanzaDetalle
			where CGRBDid = #rs_Res#
		</cfquery>
        <html>
        <head>
            <meta http-equiv="content-type" content="text/html; charset=utf-8" />
            <style type="text/css">
            * { font-size:11px; font-family:Verdana, Arial, Helvetica, sans-serif }
            .niv1 { font-size: 18px; }
            .niv2 { font-size: 16px; }
            .niv3 { font-size: 14px; }
            </style>
        </head>
		<body>
			<table cellpadding="2" cellspacing="0">
			<tr style="font-weight:bold">
			  <td colspan="14" align="center" class="niv1"><cfoutput>#session.Enombre#</cfoutput></td>
			  </tr>
			<tr style="font-weight:bold">
			  <td colspan="14" align="center" class="niv2" ><cfoutput>#LB_Titulo#</cfoutput></td>
			  </tr>
			<tr style="font-weight:bold">
			  <td colspan="14" align="center" class="niv2"><cfoutput>#rangotipos#</cfoutput></td>
			  </tr>
			<tr style="font-weight:bold">
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td align="right">&nbsp;</td>
			  <td>&nbsp;</td>
			  <td align="right">&nbsp;</td>
			  <td align="right">&nbsp;</td>
			  <td align="right">&nbsp;</td>
			  <td>&nbsp;</td>
			  </tr>
			<cfoutput query="rsReporte" group="Mayor">
				<cfset total_mayor_deb = 0>
                <cfset total_mayor_cre = 0>
                <tr style="font-weight:bold;font-size:large">
                <td colspan="2" class="niv3">#LB_Mayor#</td>
                <td colspan="12" class="niv3">#Mayor#</td>
                </tr>
                <cfoutput group="Formato">
					<cfset total_cuenta_deb = 0>
                    <cfset total_cuenta_cre = 0>
                    <cfset total_cuenta_acu = Acumulado>
                    <tr style="font-weight:bold;font-size:large;">
                      <td colspan="2" style="border-top:2px solid black" class="niv3">#LB_Cuenta#</td>
                      <td colspan="4" class="niv3" style="border-top:2px solid black">#Formato#</td>
                      <td colspan="8" class="niv3" style="border-top:2px solid black">#DescCuenta#</td>
                      </tr>
                    <tr style="font-weight:bold"><td>#LB_Periodo#</td><td>#LB_Fecha#</td><td align="right">#LB_Lote#</td>
                    <td align="right">#LB_Poliza#</td><td align="center">#LB_Oficina#</td>
                    <td>#LB_Documento#</td><td>#LB_Descripcion#</td><td>#LB_Ref#</td><td align="right">#LB_Monto#</td>
                    <td>#LB_Moneda#</td><td align="right">#LB_Debitos#</td><td align="right">#LB_Creditos#</td>
                    <td align="right">#LB_Movimiento#</td><td>#LB_Acumulado#</td>
                    </tr>
                    <cfoutput group="Efecha">
                        <cfset total_fecha_deb = 0>
                        <cfset total_fecha_cre = 0>
                        <cfset total_mayor_deb = total_mayor_deb + Debitos>
                        <cfset total_mayor_cre = total_mayor_cre + Creditos>
                        <cfset total_cuenta_deb = total_cuenta_deb + Debitos>
                        <cfset total_cuenta_cre = total_cuenta_cre + Creditos>
                        <cfset total_cuenta_acu = total_cuenta_acu + Debitos - Creditos>
                        <cfset total_fecha_deb = total_fecha_deb + Debitos>
                        <cfset total_fecha_cre = total_fecha_cre + Creditos>
                        <cfparam name="curr_periodo" default="*">
                        <cfoutput>
                            <tr><td><cfif curr_periodo neq PeriodoMes>#PeriodoMes#<cfset curr_periodo=PeriodoMes><cfelse>&nbsp;</cfif></td><td>#dateformat(Efecha,"DD/MM/YYYY")#</td><td align="right">#Concepto#</td>
                            <td align="right">#Edocumento#</td><td align="center">#Oficina#</td>
                            <td>#Documento#</td><td>#Ddescripcion#</td><td>#Dreferencia#</td>
                            <td align="right" nowrap>#LSNumberFormat(MontoOriginal, ",_.__")#</td>
                            <td>&nbsp;#Moneda#</td>
                            <td align="right" nowrap>#LSNumberFormat(Debitos, ",_.__")#</td>
                            <td align="right" nowrap>#LSNumberFormat(Creditos, ",_.__")#</td>
                            <td align="right" nowrap>#LSNumberFormat(Debitos-Creditos, ",_.__")#</td>
                            <td align="right" nowrap>#LSNumberFormat(total_cuenta_acu, ",_.__")#</td>
                            </tr>
                        </cfoutput>
                        <cfif isdefined("url.chkTotalFecha")>
                            <tr style="background-color:##f0f0f0"><td colspan="10">Total Fecha</td>
                              <td align="right" nowrap>#LSNumberFormat( total_fecha_deb, ",_.__" ) #</td>
                              <td align="right" nowrap>#LSNumberFormat( total_fecha_cre, ",_.__" )#</td>
                              <td align="right" nowrap>#LSNumberFormat( total_fecha_deb - total_fecha_cre, ",_.__" )#</td>
                              <td>&nbsp;</td>
                            </tr>
                        </cfif>
                    </cfoutput>		
                    <tr style="background-color:##e0e0e0"><td colspan="3">Total Cuenta</td>
                      <td colspan="2">#Formato#</td>
                      <td colspan="5">&nbsp;</td>
                      <td align="right" nowrap>#LSNumberFormat( total_cuenta_deb, ",_.__" ) #</td>
                      <td align="right" nowrap>#LSNumberFormat( total_cuenta_cre, ",_.__" )#</td>
                      <td align="right" nowrap>#LSNumberFormat( total_cuenta_deb - total_cuenta_cre, ",_.__" )#</td>
                      <td>&nbsp;</td>
                    </tr>
				</cfoutput>		
                <tr style="background-color:##cccccc"><td colspan="3">Total Mayor </td>
                  <td colspan="2">#Mayor#</td>
                  <td colspan="5">&nbsp;</td>
                  <td align="right" nowrap>#LSNumberFormat( total_mayor_deb, ",_.__" ) #</td>
                  <td align="right" nowrap>#LSNumberFormat( total_mayor_cre, ",_.__" )#</td>
                  <td align="right" nowrap>#LSNumberFormat( total_mayor_deb - total_mayor_cre, ",_.__" )#</td>
                  <td>&nbsp;</td>
                </tr>
			</cfoutput>
			</table>
        </body>
        </html>
		<cfquery datasource="#Session.DSN#">
			delete from DCGRBalanzaDetalle
			where CGRBDid = #rs_Res#
		</cfquery>

	<cfelse>
		<cfquery name="rsReporte" datasource="#session.DSN#">
			#PreserveSingleQuotes(myquery)#
		</cfquery>

		<cfquery datasource="#Session.DSN#">
			delete from DCGRBalanzaDetalle
			where CGRBDid = #rs_Res#
		</cfquery>
	
		<cfquery datasource="#Session.DSN#">
			delete from CGRBalanzaDetalle
			where CGRBDid = #rs_Res#
		</cfquery>

		<cfif isdefined("url.chkTotalFecha")>
		<!--- INVOCA EL REPORTE --->
		  <cfset NombreReporteJR = "">
			<cfif not isdefined ("url.chkMontoOrigen")>
				<cfset NombreReporte='BalDetFecSinMontoMoneda.cfr'>
				<cfset NombreReporteJR = "BalDetFecSinMontoMoneda">
			<cfelse>
				<cfset NombreReporte='BalDetFechas.cfr'>
				<cfset NombreReporteJR = "BalDetFechas">
			</cfif>

      <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
			  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
					isLink = False 
					typeReport = #typeRep#
					fileName = "cg.consultas.#NombreReporteJR#"
					headers = "title:#LB_Titulo#"/>
			<cfelse>
				<cfreport format="#url.formato#" template= "#NombreReporte#" query="rsReporte">
					<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
					<cfreportparam name="LabelRango" value="#trim(rangotipos)#"><cfoutput>
					<cfreportparam name="titulo" value="#LB_Titulo#"></cfoutput>
					<cfif isdefined("url.Ordenamiento")>
						<cfreportparam name="ordenamiento" value="#url.Ordenamiento#">
					</cfif>
									<cfreportparam name="TotalCuenta" value="#LB_TotalCuenta#">
									<cfreportparam name="TotalMayor" value="#LB_TotalMayor#">
									<cfreportparam name="Mayor" value="#LB_Mayor#">
									<cfreportparam name="Cuenta" value="#LB_Cuenta#">
									<cfreportparam name="DesdeCuenta" value="#LB_DesdeCuenta#">
									<cfreportparam name="HastaCuenta" value="#LB_HastaCuenta#">
									<cfreportparam name="Periodo" value="#LB_Periodo#">
									<cfreportparam name="Fecha" value="#LB_Fecha#">
									<cfreportparam name="Lote" value="#LB_Lote#">
									<cfreportparam name="Poliza" value="#LB_Poliza#">
									<cfreportparam name="Oficina" value="#LB_Oficina#">
									<cfreportparam name="Documento" value="#LB_Documento#">
									<cfreportparam name="Descripcion" value="#LB_Descripcion#">
									<cfreportparam name="Ref" value="#LB_Ref#">
									<cfreportparam name="Monto" value="#LB_Monto#">
									<cfreportparam name="Moneda" value="#LB_Moneda#">
									<cfreportparam name="Debitos" value="#LB_Debitos#">
									<cfreportparam name="Creditos" value="#LB_Creditos#">
									<cfreportparam name="Movimiento" value="#LB_Movimiento#">
									<cfreportparam name="Acumulado" value="#LB_Acumulado#">
									<cfreportparam name="TotalFecha" value="#LB_TotalFecha#"> 
				</cfreport>
			</cfif>
		<cfelse>
		  <cfset NombreReporteJR = "">
			<cfif not isdefined ("url.chkMontoOrigen")>
				<cfset NombreReporte='BalDetSinMontoMoneda.cfr'>
				<cfset NombreReporteJR = "BalDetSinMontoMoneda">
			<cfelse>
				<cfset NombreReporte='BalDet.cfr'>
				<cfset NombreReporteJR = "BalDet">
			</cfif>

			<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
			  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
					isLink = False 
					typeReport = #typeRep#
					fileName = "cg.consultas.#NombreReporteJR#"
					headers = "title:#LB_Titulo#"/>
			<cfelse>
				<cfreport format="#url.formato#" template= "#NombreReporte#" query="rsReporte">
					<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
					<cfreportparam name="LabelRango" value="#trim(rangotipos)#"><cfoutput>
					<cfreportparam name="titulo" value="#LB_Titulo#"></cfoutput>
					<cfif isdefined("url.Ordenamiento")>
						<cfreportparam name="ordenamiento" value="#url.Ordenamiento#">
					</cfif>
									<cfreportparam name="TotalCuenta" value="#LB_TotalCuenta#">
									<cfreportparam name="TotalMayor" value="#LB_TotalMayor#">
									<cfreportparam name="Mayor" value="#LB_Mayor#">
									<cfreportparam name="Cuenta" value="#LB_Cuenta#">
									<cfreportparam name="DesdeCuenta" value="#LB_DesdeCuenta#">
									<cfreportparam name="HastaCuenta" value="#LB_HastaCuenta#">
									<cfreportparam name="Periodo" value="#LB_Periodo#">
									<cfreportparam name="Fecha" value="#LB_Fecha#">
									<cfreportparam name="Lote" value="#LB_Lote#">
									<cfreportparam name="Poliza" value="#LB_Poliza#">
									<cfreportparam name="Oficina" value="#LB_Oficina#">
									<cfreportparam name="Documento" value="#LB_Documento#">
									<cfreportparam name="Descripcion" value="#LB_Descripcion#">
									<cfreportparam name="Ref" value="#LB_Ref#">
									<cfreportparam name="Monto" value="#LB_Monto#">
									<cfreportparam name="Moneda" value="#LB_Moneda#">
									<cfreportparam name="Debitos" value="#LB_Debitos#">
									<cfreportparam name="Creditos" value="#LB_Creditos#">
									<cfreportparam name="Movimiento" value="#LB_Movimiento#">
									<cfreportparam name="Acumulado" value="#LB_Acumulado#">
									<cfreportparam name="TotalFecha" value="#LB_TotalFecha#"> 
				</cfreport>
			</cfif>
		</cfif>
	</cfif>
</cfif>


