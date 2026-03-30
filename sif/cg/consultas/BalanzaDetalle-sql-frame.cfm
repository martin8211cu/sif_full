<cfsetting requesttimeout="36000">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="TituloBigHTML" default="Reporte de balanza a detalle" 
returnvariable="LB_TituloBigHTML" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Reporte de balanza a detalle 2" 
returnvariable="LB_Titulo" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="TotalCuenta" default="Total Cuenta:" 
returnvariable="LB_TotalCuenta" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="TotalMayor" default="Total Mayor:" 
returnvariable="LB_TotalMayor" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Mayor" default="Mayor" 
returnvariable="LB_Mayor" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Cuenta" default="Cuenta" 
returnvariable="LB_Cuenta" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="DesdeCuenta" default="Desde la cuenta" 
returnvariable="LB_DesdeCuenta" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="HastaCuenta" default="Hasta la cuenta" 
returnvariable="LB_HastaCuenta" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Periodo" default="Periodo" 
returnvariable="LB_Periodo" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Fecha" default="Fecha" 
returnvariable="LB_Fecha" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="FechaAsiento" default="FechaAsiento" 
returnvariable="LB_FechaA" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Lote" default="Lote" 
returnvariable="LB_Lote" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Poliza" default="Póliza" 
returnvariable="LB_Poliza" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Oficina" default="Oficina" 
returnvariable="LB_Oficina" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Documento" default="Documento" 
returnvariable="LB_Documento" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="DocumentoAsiento" default="DocumentoAsiento" 
returnvariable="LB_DocumentoA" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Descripcion" default="Descripción" 
returnvariable="LB_Descripcion" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="DescripcionCuenta" default="DescripciónCuenta" 
returnvariable="LB_DescripcionCuenta" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Ref" default="Ref" 
returnvariable="LB_Ref" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Monto" default="Monto" 
returnvariable="LB_Monto" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Moneda" default="Moneda" 
returnvariable="LB_Moneda" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Debitos" default="Débitos" 
returnvariable="LB_Debitos" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Creditos" default="Créditos" 
returnvariable="LB_Creditos" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Movimiento" default="Movimiento" 
returnvariable="LB_Movimiento" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Acumulado" default="Acumulado" 
returnvariable="LB_Acumulado" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="TotalFecha" default="Total Fecha:" 
returnvariable="LB_TotalFecha" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Empresa" default="Empresa" 
returnvariable="LB_Empresa" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Mes" default="Mes" 
returnvariable="LB_Mes" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Concepto" default="Concepto" 
returnvariable="LB_Concepto" xmlfile="BalanzaDetalle-sql-frame.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Origen" default="Origen" 
returnvariable="LB_Origen" xmlfile="BalanzaDetalle-sql-frame.xml"/>

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

<cfoutput>
	<cfset Desde = #LB_DesdeCuenta#>
    <cfset Hasta = #LB_HastaCuenta#>
</cfoutput>

<cfif Len(Trim(lvarCformato1)) or  Len(Trim(lvarCformato2))>
	<cfif len(trim(lvarCformato1)) GT 0>
		<cfset rangotipos = "#Desde# " & lvarCformato1>
	<cfelse>
		<cfset rangotipos = "">
	</cfif>		
	<cfif len(trim(lvarCformato2)) GT 0>
		<cfset rangotipos = rangotipos & " #Hasta# " & lvarCformato2>
	</cfif>		
</cfif>

<cfif url.formato EQ 'ExcelColumnar'>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select <cfoutput>
				em.Edescripcion as #LB_Empresa#,
				b.Cformato as #LB_Cuenta#, 
				a.Eperiodo as #LB_Periodo#,
				a.Emes as #LB_Mes#,
				b.Cdescripcion as #LB_DescripcionCuenta#,
				hd.Cconcepto as #LB_Concepto#, 
				hd.Edocumento #LB_Poliza#, 
				he.Edocbase as #LB_DocumentoA#,
				a.Efecha as #LB_FechaA#,
				o.Oficodigo as #LB_Oficina#, 
				coalesce(he.Oorigen,'') as #LB_Origen#,
				case a.IDcontable when -10 then 'SALDO INICIAL' else coalesce(hd.Ddocumento, '  N / A') end as #LB_Documento#, 
				coalesce(hd.Dreferencia,'') as #LB_Ref#,
				hd.Ddescripcion as #LB_Descripcion#,
				coalesce(a.montoorigen, 0.00) as #LB_Monto#,
				m.Miso4217 as #LB_Moneda#,
				coalesce(a.debitos, 0.00) as #LB_Debitos#, 
				coalesce(a.creditos, 0.00) as #LB_Creditos#</cfoutput>
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
				case a.IDcontable when -10 then 'SALDO INICIAL' else coalesce(hd.Ddocumento, '  N / A') end as Documento, 
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
			  <td colspan="14" align="center" class="niv2" ><cfoutput>#LB_TituloBigHTML#</cfoutput></td>
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
                        <cfparam name="curr_periodo" default="*">
                        <cfset total_fecha_deb = 0>
						<cfset total_fecha_cre = 0>
                    	<cfoutput>
                        	<cfset total_mayor_deb = total_mayor_deb + Debitos>
                            <cfset total_mayor_cre = total_mayor_cre + Creditos>
                            <cfset total_cuenta_deb = total_cuenta_deb + Debitos>
                            <cfset total_cuenta_cre = total_cuenta_cre + Creditos>
                            <cfset total_cuenta_acu = total_cuenta_acu + Debitos - Creditos>
                            <cfset total_fecha_deb = total_fecha_deb + Debitos>
 		                    <cfset total_fecha_cre = total_fecha_cre + Creditos>
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
                            <tr style="background-color:##f0f0f0"><td colspan="10"><strong>#LB_TotalFecha#</strong></td>
                              <td align="right" nowrap><strong>#LSNumberFormat( total_fecha_deb, ",_.__" )#</strong></td>
                              <td align="right" nowrap><strong>#LSNumberFormat( total_fecha_cre, ",_.__" )#</strong></td>
                              <td align="right" nowrap><strong>#LSNumberFormat( total_fecha_deb - total_fecha_cre, ",_.__" )#</strong></td>
                              <td>&nbsp;</td>
                            </tr>
                        </cfif>
                    </cfoutput>		
                    <tr style="background-color:##e0e0e0;"><td colspan="3"><strong style="font-size: 13px">#LB_TotalCuenta#</strong></td>
                      <td colspan="2">#Formato#</td>
                      <td colspan="5">&nbsp;</td>
                      <td align="right" nowrap><strong style="font-size: 13px">#LSNumberFormat( total_cuenta_deb, ",_.__" )#</strong></td>
                      <td align="right" nowrap><strong style="font-size: 13px">#LSNumberFormat( total_cuenta_cre, ",_.__" )#</strong></td>
                      <td align="right" nowrap><strong style="font-size: 13px">#LSNumberFormat( total_cuenta_deb - total_cuenta_cre, ",_.__" )#</strong></td>
                      <td>&nbsp;</td>
                    </tr>
				</cfoutput>		
                <tr style="background-color:##cccccc"><td colspan="3"><strong style="font-size: 13px">#LB_TotalMayor#</strong></td>
                  <td colspan="2">#Mayor#</td>
                  <td colspan="5">&nbsp;</td>
                  <td align="right" nowrap><strong style="font-size: 13px">#LSNumberFormat( total_mayor_deb, ",_.__" )#</strong></td>
                  <td align="right" nowrap><strong style="font-size: 13px">#LSNumberFormat( total_mayor_cre, ",_.__" )#</strong></td>
                  <td align="right" nowrap><strong style="font-size: 13px">#LSNumberFormat( total_mayor_deb - total_mayor_cre, ",_.__" )#</strong></td>
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
        
        <cfoutput>
			<cfset Titulo = "#LB_Titulo#">
			<cfset LvarTotalCuenta="#LB_TotalCuenta#">
            <cfset LvarTotalMayor="#LB_TotalMayor#">
            <cfset LvarMayor="#LB_Mayor#">
            <cfset LvarCuenta="#LB_Cuenta#">
            <cfset LvarDesdeCuenta="#LB_DesdeCuenta#">
            <cfset LvarHastaCuenta="#LB_HastaCuenta#">
            <cfset LvarPeriodo="#LB_Periodo#">
            <cfset LvarFecha="#LB_Fecha#">
            <cfset LvarLote="#LB_Lote#">
            <cfset LvarPoliza="#LB_Poliza#">
            <cfset LvarOficina="#LB_Oficina#">
            <cfset LvarDocumento="#LB_Documento#">
            <cfset LvarDescripcion="#LB_Descripcion#">
            <cfset LvarRef="#LB_Ref#">
            <cfset LvarMonto="#LB_Monto#">
            <cfset LvarMoneda="#LB_Moneda#">
            <cfset LvarDebitos="#LB_Debitos#">
            <cfset LvarCreditos="#LB_Creditos#">
            <cfset LvarMovimiento="#LB_Movimiento#">
            <cfset LvarAcumulado="#LB_Acumulado#">
            <cfset LvarTotalFecha="#LB_TotalFecha#">                
        </cfoutput>
		<cfif isdefined("url.chkTotalFecha")>
		<!--- INVOCA EL REPORTE --->
		  <cfset NombreReporteJR=''>
			<cfif not isdefined ("url.chkMontoOrigen")>
				<cfset NombreReporte='BalDetFecSinMontoMoneda.cfr'>
				<cfset NombreReporteJR='BalDetFecSinMontoMoneda'>
			<cfelse>
				<cfset NombreReporte='BalDetFechas.cfr'>
				<cfset NombreReporteJR='BalDetFechas'>
			</cfif>
			<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 AND
			  typeRep EQ 1>
				<cf_js_reports_service_tag queryReport = "#rsReporte#" 
					isLink = False 
					typeReport = #typeRep#
					fileName = "cg.consultas.#NombreReporteJR#"
					headers = "title:#Titulo#"/>
			<cfelse>
				<cfreport format="#url.formato#" template= "#NombreReporte#" query="rsReporte">
					<cfreportparam name="Ecodigo" 		value="#session.Ecodigo#">
					<cfreportparam name="LabelRango" 	value="#trim(rangotipos)#">
					<cfreportparam name="titulo" 		value= "#Titulo#">   
									<cfreportparam name="TotalCuenta" 	value="#LvarTotalCuenta#">
									<cfreportparam name="TotalMayor" 	value="#LvarTotalMayor#">
									<cfreportparam name="Mayor" 		value="#LvarMayor#">
									<cfreportparam name="Cuenta" 		value="#LvarCuenta#">
									<cfreportparam name="DesdeCuenta" 	value="#LvarDesdeCuenta#">
									<cfreportparam name="HastaCuenta" 	value="#LvarHastaCuenta#">
									<cfreportparam name="Periodo" 		value="#LvarPeriodo#">
									<cfreportparam name="Fecha" 		value="#LvarFecha#">
									<cfreportparam name="Lote" 			value="#LvarLote#">
									<cfreportparam name="Poliza"		value="#LvarPoliza#">
									<cfreportparam name="Oficina" 		value="#LvarOficina#">
									<cfreportparam name="Documento" 	value="#LvarDocumento#">
									<cfreportparam name="Descripcion" 	value="#LvarDescripcion#">
									<cfreportparam name="Ref" 			value="#LvarRef#">
									<cfreportparam name="Monto" 		value="#LvarMonto#">
									<cfreportparam name="Moneda" 		value="#LvarMoneda#">
									<cfreportparam name="Debitos"		value="#LvarDebitos#">
									<cfreportparam name="Creditos" 		value="#LvarCreditos#">
									<cfreportparam name="Movimiento"	value="#LvarMovimiento#">
									<cfreportparam name="Acumulado" 	value="#LvarAcumulado#">
									<cfreportparam name="TotalFecha" 	value="#LvarTotalFecha#">                
					<cfif isdefined("url.Ordenamiento")>
						<cfreportparam name="ordenamiento" value="#url.Ordenamiento#">
					</cfif>
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
      <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 AND
			  typeRep EQ 1>
			  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
					isLink = False 
					typeReport = #typeRep#
					fileName = "cg.consultas.#NombreReporteJR#"
					headers = "title:#Titulo#"/>
			<cfelse>
				<cfreport format="#url.formato#" template= "#NombreReporte#" query="rsReporte">
									<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
									<cfreportparam name="LabelRango" value="#trim(rangotipos)#">
									<cfreportparam name="titulo" value= "#Titulo#">
									
									<cfreportparam name="TotalCuenta" value="#LvarTotalCuenta#">
									<cfreportparam name="TotalMayor" value="#LvarTotalMayor#">
									<cfreportparam name="Mayor" value="#LvarMayor#">
									<cfreportparam name="Cuenta" value="#LvarCuenta#">
									<cfreportparam name="DesdeCuenta" value="#LvarDesdeCuenta#">
									<cfreportparam name="HastaCuenta" value="#LvarHastaCuenta#">
									<cfreportparam name="Periodo" value="#LvarPeriodo#">
									<cfreportparam name="Fecha" value="#LvarFecha#">
									<cfreportparam name="Lote" value="#LvarLote#">
									<cfreportparam name="Poliza" value="#LvarPoliza#">
									<cfreportparam name="Oficina" value="#LvarOficina#">
									<cfreportparam name="Documento" value="#LvarDocumento#">
									<cfreportparam name="Descripcion" value="#LvarDescripcion#">
									<cfreportparam name="Ref" value="#LvarRef#">
									<cfreportparam name="Monto" value="#LvarMonto#">
									<cfreportparam name="Moneda" value="#LvarMoneda#">
									<cfreportparam name="Debitos" value="#LvarDebitos#">
									<cfreportparam name="Creditos" value="#LvarCreditos#">
									<cfreportparam name="Movimiento" value="#LvarMovimiento#">
									<cfreportparam name="Acumulado" value="#LvarAcumulado#">
									<cfreportparam name="TotalFecha" value="#LvarTotalFecha#">                
					<cfif isdefined("url.Ordenamiento")>
						<cfreportparam name="ordenamiento" value="#url.Ordenamiento#">
					</cfif>
				</cfreport>
			</cfif>
		</cfif>
	</cfif>
</cfif>


