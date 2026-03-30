<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined("url.CMTid") and len(trim(url.CMTid)) and not isdefined("form.CMTid")>
	<cfset form.CMTid = url.CMTid>
</cfif>
<cfif isdefined("url.MesIni") and len(trim(url.MesIni)) and not isdefined("form.MesIni")>
	<cfset form.MesIni = url.MesIni>
</cfif>
<cfif isdefined("url.MesFin") and len(trim(url.MesFin)) and not isdefined("form.MesFin")>
	<cfset form.MesFin = url.MesFin>
</cfif>
<cfif isdefined("url.AnnoIni") and len(trim(url.AnnoIni)) and not isdefined("form.AnnoIni")>
	<cfset form.AnnoIni = url.AnnoIni>
</cfif>
<cfif isdefined("url.AnnoFin") and len(trim(url.AnnoFin))  and not isdefined("form.AnnoFin")>
	<cfset form.AnnoFin = url.AnnoFin>
</cfif>
<cfif isdefined("url.AgruparPor") and len(trim(url.AgruparPor)) and not isdefined("form.AgruparPor")>
	<cfset form.AgruparPor = url.AgruparPor>
</cfif>
<cfif isdefined("url.CMCid1") and len(trim(url.CMCid1)) and not isdefined("form.CMCid1")>
	<cfset form.CMCid1 = url.CMCid1>
</cfif>
<cfif isdefined("url.Ccodigo") and len(trim(url.Ccodigo)) and not isdefined("form.Ccodigo")>
	<cfset form.Ccodigo = url.Ccodigo>
</cfif>
<cfif isdefined("url.CCid") and len(trim(url.CCid)) and not isdefined("form.CCid")>
	<cfset form.CCid = url.CCid>
</cfif>

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

<script type="text/javascript" language="javascript1.2">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function funcDetalle(parmMes,parAnno,parCriterio) {
		var params ="?Mes="+parmMes+"&Anno="+parAnno+"&Criterio="+parCriterio+"&Socio="+<cfoutput>#form.SNcodigo#</cfoutput>+"&AgruparPor="+<cfoutput>#form.AgruparPor#</cfoutput>;
		<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
			params = params + "&CMCid1=" + <cfoutput>#form.CMCid1#</cfoutput>;
		</cfif>
		<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0>
			params = params + "&Ccodigo=" + <cfoutput>#form.Ccodigo#</cfoutput>;
		</cfif>
		<cfif isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
			params = params + "&CCid=" + <cfoutput>#form.CCid#</cfoutput>;
		</cfif>
		params = params + "&MesIni=" + <cfoutput>#form.MesIni#</cfoutput> + "&AnnoIni=" + <cfoutput>#form.AnnoIni#</cfoutput> + "&MesFin=" + <cfoutput>#form.MesFin#</cfoutput> + "&AnnoFin=" + <cfoutput>#form.AnnoFin#</cfoutput>;

		popUpWindow("RepCmAnalisisProvDetalle-vista.cfm"+params,90,60,800,550);
	}
</script>

	<!--- Información de relleno para el reporte --->
	
	<cfswitch expression="#form.MesIni#">
		<cfcase value="1"><cfset vsMesIni = 'Enero'></cfcase>
		<cfcase value="2"><cfset vsMesIni = 'Febrero'></cfcase>
		<cfcase value="3"><cfset vsMesIni = 'Marzo'></cfcase>
		<cfcase value="4"><cfset vsMesIni = 'Abril'></cfcase>
		<cfcase value="5"><cfset vsMesIni = 'Mayo'></cfcase>
		<cfcase value="6"><cfset vsMesIni = 'Junio'></cfcase>
		<cfcase value="7"><cfset vsMesIni = 'Julio'></cfcase>
		<cfcase value="8"><cfset vsMesIni = 'Agosto'></cfcase>
		<cfcase value="9"><cfset vsMesIni = 'Setiembre'></cfcase>
		<cfcase value="10"><cfset vsMesIni = 'Octubre'></cfcase>
		<cfcase value="11"><cfset vsMesIni = 'Noviembre'></cfcase>
		<cfcase value="12"><cfset vsMesIni = 'Diciembre'></cfcase>
	</cfswitch>
	<cfswitch expression="#form.MesFin#">
		<cfcase value="1"><cfset vsMesFin = 'Enero'></cfcase>
		<cfcase value="2"><cfset vsMesFin = 'Febrero'></cfcase>
		<cfcase value="3"><cfset vsMesFin = 'Marzo'></cfcase>
		<cfcase value="4"><cfset vsMesFin = 'Abril'></cfcase>
		<cfcase value="5"><cfset vsMesFin = 'Mayo'></cfcase>
		<cfcase value="6"><cfset vsMesFin = 'Junio'></cfcase>
		<cfcase value="7"><cfset vsMesFin = 'Julio'></cfcase>
		<cfcase value="8"><cfset vsMesFin = 'Agosto'></cfcase>
		<cfcase value="9"><cfset vsMesFin = 'Setiembre'></cfcase>
		<cfcase value="10"><cfset vsMesFin = 'Octubre'></cfcase>
		<cfcase value="11"><cfset vsMesFin = 'Noviembre'></cfcase>
		<cfcase value="12"><cfset vsMesFin = 'Diciembre'></cfcase>
	</cfswitch>
	
	<!--- Tipo de análisis con el que se generó el reporte --->
	<cfquery name="rsTipos" datasource="#session.DSN#">
		select CMTdesc, CMTentregaefec, CMTgestiorec, CMTeestiorecp, CMTefecentrega 
		from CMTipoAnalisis 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CMTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMTid#">
	</cfquery>
	
	<!--- Socio de negocios del filtro --->
	<cfquery name="rsSocio" datasource="#session.DSN#">
		select SNidentificacion, SNnombre
		from SNegocios
		where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">	
			and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
	</cfquery>
	
	<!--- Comprador en el filtro --->
	<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
		<cfquery name="rsComprador" datasource="#session.DSN#">
			select CMCnombre, CMCcodigo
			from CMCompradores
			where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
	
	<!--- Empresa de la sesión --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
	<!--- Busca todas las ordenes que cumplan con los filtros --->
	<cfquery name="rsOrdenes" datasource="#session.DSN#">
		select EOidorden
		from EOrdenCM
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and EOestado = 10
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
			and (<cf_dbfunction name="date_part" args="YY,EOfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,EOfecha"> - 1) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AnnoIni * 12 + form.MesIni - 1#">
			and (<cf_dbfunction name="date_part" args="YY,EOfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,EOfecha"> - 1) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AnnoFin * 12 + form.MesFin - 1#">
			<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
				and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
			</cfif>
	</cfquery>
	
	<cfoutput>
		<table  width="98%"  align="center" border="0" cellpadding="0" cellspacing="0">
		
			<!--- Encabezado del reporte --->
			<tr><td align="center" colspan="7" class="tituloAlterno"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></td></tr>
			<tr><td align="center" colspan="7" style="font-size:13px"><strong>An&aacute;lisis de proveedores</strong></td></tr>
			<tr><td align="center" colspan="7"><strong>Proveedor:&nbsp;<cfoutput>#rsSocio.SNidentificacion#&nbsp;-&nbsp;#rsSocio.SNnombre#</cfoutput></strong></td></tr>
			<cfif isdefined("rsComprador") and rsComprador.RecordCount gt 0>
				<tr><td align="center" colspan="7"><strong>Comprador:&nbsp;<cfoutput>#rsComprador.CMCcodigo#&nbsp;-&nbsp;#rsComprador.CMCnombre#</cfoutput></strong></td></tr>
			</cfif>
			<tr><td align="center" colspan="7"><strong><cfoutput>Tipo de an&aacute;lisis:&nbsp;#rsTipos.CMTdesc# como evaluador </cfoutput></strong></td></tr>
			<tr><td align="center" colspan="7"><strong><cfoutput>Desde #vsMesIni#-#form.AnnoIni# a #vsMesFin#-#form.AnnoFin#</cfoutput></strong></td></tr>
			<tr><td align="center" colspan="7">&nbsp;</td></tr>
			<tr><td align="center" colspan="7">&nbsp;</td></tr>

		<cfif rsOrdenes.recordcount gt 0>
		
			
			<!--- Crea tabla temporal --->
			<cf_dbtemp name="ORDENES_TEMP" returnvariable="ORDENES_TEMP" datasource="#session.DSN#">
				 <cf_dbtempcol name="Orden"       		type="numeric" 		mandatory="no">
				 <cf_dbtempcol name="Linea"       		type="numeric" 		mandatory="no">
				 <cf_dbtempcol name="CantLinea"     	type="float" 		mandatory="no">
				 <cf_dbtempcol name="CantSurt"    		type="float" 		mandatory="no">
				 <cf_dbtempcol name="fechareqOL"    	type="datetime" 	mandatory="no"> 
				 <cf_dbtempcol name="Recep"     		type="numeric"   	mandatory="no">	<!--- Llave de recepcion (EDRid) --->
				 <cf_dbtempcol name="fechaRecep"     	type="datetime"		mandatory="no">
				 <cf_dbtempcol name="DOcantexceso"     	type="float"   		mandatory="no">
				 <cf_dbtempcol name="CantFaturada"    	type="float"   		mandatory="no">	<!--- Cantidad facturada --->
				 <cf_dbtempcol name="CantRecep"     	type="float"   		mandatory="no">	<!--- Cantidad recibida (recepción) en la unidad de la orden de compra --->
				 <cf_dbtempcol name="TotalRecep"     	type="float"   		mandatory="no">
				 <cf_dbtempcol name="NotaLinOrden"     	type="float"   		mandatory="no">
				 <cf_dbtempcol name="NotaOrden"     	type="float"   		mandatory="no">
				 <cf_dbtempcol name="Notatotal"     	type="float"   		mandatory="no">
				 <cf_dbtempcol name="reclamosLP"     	type="float"   		mandatory="no">	<!--- Nota de reclamos por precio --->
				 <cf_dbtempcol name="reclamosLC"     	type="float"   		mandatory="no">	<!--- Nota de reclamos por cantidad --->
				 <cf_dbtempcol name="Total_reclamosP"   type="float"   		mandatory="no">
				 <cf_dbtempcol name="Total_reclamosC"   type="float"   		mandatory="no">
				 <cf_dbtempcol name="Mes"     			type="integer"   	mandatory="no">
				 <cf_dbtempcol name="Anno"     			type="integer"   	mandatory="no">
			</cf_dbtemp>
			
			<cftransaction>

			<!--- Inserta para cada orden encontrada, las líneas de la orden de compra y líneas de recepción asociadas --->
			<cfloop query="rsOrdenes">
				<cfquery name="Rsactualiza" datasource="#session.DSN#">
					insert into #ORDENES_TEMP#(
							Orden,
							Linea,
							DOcantexceso,
							CantLinea,
							CantSurt,
							fechareqOL,
							Recep,
							fechaRecep,
							CantFaturada,
							CantRecep,
							reclamosLP,
							reclamosLC,
							Mes,
							Anno
					)
					select 
						a.EOidorden,
						a.DOlinea,
						coalesce(a.DOcantexceso,0),
						a.DOcantidad,
						a.DOcantsurtida,
						a.DOfechaes,
						e.EDRid,
						e.EDRfecharec,
						c.DDRcantorigen,
						(c.DDRcantrec * c.DDRcantordenconv) / c.DDRcantorigen as DDRcantrec,
						<!--- Reclamos por condiciones de orden de compra mejores que las de la recepción --->
                        #LvarOBJ_PrecioU.enSQL_AS(<!--- (" para brincarme la verificación automática ")# --->"			
							case when c.DDRgenreclamo is null then 100
								 when c.DDRgenreclamo = 0 then 100
								 when (cmto.CMTgeneratracking = 1 and cmto.CMTOimportacion = 1) then 100
								 when ((10 * ((c.DDRpreciou * c.DDRcantorigen) / coalesce(c.DDRcantordenconv, c.DDRcantorigen))) * ((100 - coalesce(c.DDRdescporclin, 0.00)) / 100.00) * ((100 + coalesce(c.DDRimptoporclin, 0.00)) / 100.00))
									  > ((10 * a.DOpreciou * case when b.Mcodigo = e.Mcodigo then 1.00 else (b.EOtc / e.EDRtc) end) * ((100 - coalesce(a.DOporcdesc, 0.00)) / 100.00) * ((100 + imp.Iporcentaje) / 100.00))
									  then 0
								 else 100
							end", "RPrecio")#,
						<!--- Reclamos por cantidad (por tolerancia o porque la cantidad recibida es menor que la facturada) --->
						case when c.DDRgenreclamo is null then 100
							 when c.DDRgenreclamo = 0 then 100
							 when c.DDRcantorigen > c.DDRcantrec then 0
							 when clas.Ctolerancia is null then 100
							 when c.DDRcantordenconv > (a.DOcantidad - a.DOcantsurtida + (clas.Ctolerancia / 100.00) * a.DOcantidad) then 0
							 else 100
						end as Rcantidades,
						<cf_dbfunction name="date_part" args="MM,b.EOfecha">,
						<cf_dbfunction name="date_part" args="YY,b.EOfecha">

					from DOrdenCM a
						inner join EOrdenCM b
							 on b.Ecodigo = a.Ecodigo
							and b.EOidorden	= a.EOidorden
						inner join CMTipoOrden cmto
							on cmto.CMTOcodigo = b.CMTOcodigo
							and cmto.Ecodigo = b.Ecodigo
						left outer join DDocumentosRecepcion c
							inner join EDocumentosRecepcion e
								on e.EDRid = c.EDRid
								and e.Ecodigo = c.Ecodigo
								and e.EDRestado = 10
						on c.Ecodigo = a.Ecodigo
						and c.DOlinea = a.DOlinea
						
						left outer join Articulos art
							on art.Aid = a.Aid
							and art.Ecodigo = a.Ecodigo
				
							left outer join Clasificaciones clas
								on clas.Ccodigo = art.Ccodigo
								and clas.Ecodigo = art.Ecodigo
								
						left outer join Conceptos conc
							on conc.Cid = a.Cid
						
						inner join Impuestos imp
							on imp.Icodigo = a.Icodigo
							and imp.Ecodigo = a.Ecodigo
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrdenes.EOidorden#">
						<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0 and isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
							and (art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
									or conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
								)
						<cfelseif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0>
							and art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
						<cfelseif isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
							and	conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
						</cfif>
				</cfquery>
			</cfloop>
			
			<!--- Calcula el total surtido para una linea (las que se encuentra en una recepcion) --->
			<cfquery name="RSCantRecep" datasource="#session.DSN#">
				select Orden, Linea, sum(CantRecep) as CantRecep , max(fechaRecep) as fechaRecep
				from #ORDENES_TEMP#
				where Recep is not null
				group by Orden, Linea
			</cfquery>
			
			<!--- Actualiza la cantidad por linea de una recepcion --->
			<cfloop query="RSCantRecep">
				<cfquery name="UPdateCantRecep" datasource="#session.DSN#">
					update #ORDENES_TEMP#
					set TotalRecep = <cfqueryparam cfsqltype="cf_sql_float" value="#RSCantRecep.CantRecep#">
					where Recep is not null
						and Orden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSCantRecep.Orden#">
						and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSCantRecep.Linea#">
				</cfquery>
			</cfloop>
			
			<!--- Calcula la nota a las líneas que se han entregado (total o parcialmente) a tiempo --->
			<cfquery name="UPdateNotaLinOrden" datasource="#session.DSN#">
				update #ORDENES_TEMP#
				set NotaLinOrden = ((TotalRecep * 100) / CantLinea)
				where fechaRecep <= fechareqOL
					and CantSurt <> 0
					and Recep is not null
			</cfquery>
			
			<!--- Pone nota cero si entrega despues de la fecha requerida  --->
			<cfquery name="UPdateNotaLinOrden" datasource="#session.DSN#">
				update #ORDENES_TEMP#
				set NotaLinOrden = 0
				where fechaRecep > fechareqOL
					and Recep is not null
			</cfquery>
			
			<!--- Pone nota cero si no tiene recepcion  --->
			<cfquery name="UPdateNotaLinOrden" datasource="#session.DSN#">
				update #ORDENES_TEMP#
				set NotaLinOrden = 0
				where Recep is null
			</cfquery>
			
			<!--- Pone nota 100 si por alguna razon la nota es superior a 100  --->
			<cfquery name="UPdateNotaLinOrden" datasource="#session.DSN#">
				update #ORDENES_TEMP#
				set NotaLinOrden = 100
				where NotaLinOrden > 100
			</cfquery>
			
			<!--- Calcula la nota promedio por linea de orden  --->
			<cfquery name="RSNotaLinOrden" datasource="#session.DSN#">
				select avg(NotaLinOrden) as NotaLinOrden, Orden, Linea
				from #ORDENES_TEMP#
				group by Orden, Linea
			</cfquery>
			
			<!--- Actualiza todas las notas por la nota promedio por linea de orden  --->
			<cfloop query="RSNotaLinOrden">
				<cfquery name="UPdateNotaLinOrden" datasource="#session.DSN#">
					update #ORDENES_TEMP#
					set NotaLinOrden = <cfqueryparam cfsqltype="cf_sql_float" value="#RSNotaLinOrden.NotaLinOrden#">
					where Orden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSNotaLinOrden.Orden#">
						and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSNotaLinOrden.Linea#">
				</cfquery>
			</cfloop>
			
			<!--- Calcula la nota total por orden --->
			<cfquery name="RSNotaOrden" datasource="#session.DSN#">
				select avg(NotaLinOrden) as NotaOrden, Orden 
				from #ORDENES_TEMP#
				group by Orden
			</cfquery>
			
			<!--- Actualiza nota de la orden --->
			<cfloop query="RSNotaOrden">
				<cfquery name="UPdateNotaOrden" datasource="#session.DSN#">
					update #ORDENES_TEMP#
					set NotaOrden = <cfqueryparam cfsqltype="cf_sql_float" value="#RSNotaOrden.NotaOrden#">
					where Orden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSNotaOrden.Orden#">
				</cfquery>
			</cfloop>
			
			<cfset divisorAgrupar = 1>	<!--- Variables usadas en los group by. Por default usa meses --->
			<cfset factorAgrupar = 12>
			
			<!--- Agrupar por mes --->
			<cfif form.AgruparPor eq 1>
				<cfset divisorAgrupar = 1>
				<cfset factorAgrupar = 12>
			<!--- Agrupar por trimestre --->
			<cfelseif form.AgruparPor eq 2>
				<cfset divisorAgrupar = 3>
				<cfset factorAgrupar = 4>
			<!--- Agrupar por semestre --->
			<cfelseif form.AgruparPor eq 3>
				<cfset divisorAgrupar = 6>
				<cfset factorAgrupar = 2>
			<!--- Agrupar por año --->
			<cfelseif form.AgruparPor eq 4>
				<cfset divisorAgrupar = 12>
				<cfset factorAgrupar = 1>
			</cfif>
			
			<!--- Actualiza nota del proveedor en base a 100 por el parámetro de agrupación --->
			<cfquery name="RSNotatotal" datasource="#session.DSN#">
				select (Anno * #factorAgrupar# + floor((Mes - 1) / #divisorAgrupar#)) as numeroAgrupar, avg(NotaOrden) as Notatotal, avg(coalesce(reclamosLP, 100.00)) as reclamosLP, avg(coalesce(reclamosLC, 100.00)) as reclamosLC
				from #ORDENES_TEMP#
				group by (Anno * #factorAgrupar# + floor((Mes - 1) / #divisorAgrupar#))
			</cfquery>
			<cfloop query="RSNotatotal">
				<cfquery name="UPdateNotatotal" datasource="#session.DSN#">
					update #ORDENES_TEMP#
					set Notatotal = <cfqueryparam cfsqltype="cf_sql_float" value="#RSNotatotal.Notatotal#">,
						Total_reclamosP = <cfqueryparam cfsqltype="cf_sql_float" value="#RSNotatotal.reclamosLP#">,
						Total_reclamosC  = <cfqueryparam cfsqltype="cf_sql_float" value="#RSNotatotal.reclamosLC#">
					where (Anno * #factorAgrupar# + floor((Mes - 1) / #divisorAgrupar#)) = <cfqueryparam cfsqltype="cf_sql_integer" value="#RSNotatotal.numeroAgrupar#">
				</cfquery>
			</cfloop>
		
			<cfquery name="RSReporte" datasource="#session.DSN#">
				select distinct (Anno * #factorAgrupar# + floor((Mes - 1) / #divisorAgrupar#)) as numeroAgrupar,
					   (Notatotal * <cfqueryparam cfsqltype="cf_sql_float" value="#rsTipos.CMTentregaefec#">) / 100.00 as Notatotal,
					   (Total_reclamosP * <cfqueryparam cfsqltype="cf_sql_float" value="#rsTipos.CMTeestiorecp#">) / 100.00 as Total_reclamosP,
					   (Total_reclamosC * <cfqueryparam cfsqltype="cf_sql_float" value="#rsTipos.CMTgestiorec#">) / 100.00 as Total_reclamosC
				from #ORDENES_TEMP#
				order by (Anno * #factorAgrupar# + floor((Mes - 1) / #divisorAgrupar#)) asc
			</cfquery>
			
			</cftransaction>
			
			<!--- Declaración de variables --->
			<cfset finicial = createdate(form.AnnoIni, form.MesIni, 1)>	<!--- Fecha de inicialización del rango del reporte --->
			<cfset ffinal = createdate(form.AnnoFin, form.MesFin, 1)>	<!--- Fecha de finalización del rango del reporte --->
			<cfset corte = ''>
			<cfset vnCont = 0>
			
			<!--- Encabezado de las columnas --->
			<tr>
				<td>&nbsp;</td>
				<td class="listaCorte">&nbsp;</td>
				<td valign="bottom" class="listaCorte"><strong>Criterio Evaluador:</strong></td>
				<td align="center" class="listaCorte"><strong>Entregas Efectivas&nbsp;#rsTipos.CMTentregaefec#% </strong></td>
				<td align="center" class="listaCorte"><strong>Gesti&oacute;n de reclamos (Cantidades) &nbsp;#rsTipos.CMTgestiorec#% </strong></td>
				<td align="center" class="listaCorte"><strong>Gesti&oacute;n de reclamos (Precios) &nbsp;#rsTipos.CMTeestiorecp#%</strong></td>
				<td align="center" class="listaCorte"><strong>Nota Final</strong></td>
			</tr>
			
			<cfif RSReporte.recordcount gt 0>

				<cfloop condition="finicial lte ffinal">
					<cfset vnAnno = datepart('yyyy',finicial)>	<!--- año inicial --->
					<cfset vnMeses = datepart('m',finicial)>	<!--- mes inicial --->
					<cfif corte NEQ vnAnno and form.AgruparPor neq 4>
						<tr>
							<td width="5">&nbsp;</td>
							<td colspan="6" bgcolor="##999999"><strong>Año:&nbsp;#vnAnno#</strong></td>
						</tr>
						<cfset corte = vnAnno>
					</cfif>
					<cfset vnCont = vnCont + 1>
					<tr style="cursor:pointer "
						class="<cfif vnCont mod 2>listaPar<cfelse>listaNon</cfif>"
						onmouseover="this.className='listaParSel';" onmouseout="this.className='listaNon';">
						<td width="5">&nbsp;</td>
						<td>&nbsp;</td>
						
						<cfif form.AgruparPor eq 1>
							<cfswitch expression="#vnMeses#">
								<cfcase value="1"><cfset vsMes = 'Enero'></cfcase>
								<cfcase value="2"><cfset vsMes  = 'Febrero'></cfcase>
								<cfcase value="3"><cfset vsMes  = 'Marzo'></cfcase>
								<cfcase value="4"><cfset vsMes  = 'Abril'></cfcase>
								<cfcase value="5"><cfset vsMes  = 'Mayo'></cfcase>
								<cfcase value="6"><cfset vsMes  = 'Junio'></cfcase>
								<cfcase value="7"><cfset vsMes  = 'Julio'></cfcase>
								<cfcase value="8"><cfset vsMes  = 'Agosto'></cfcase>
								<cfcase value="9"><cfset vsMes  = 'Setiembre'></cfcase>
								<cfcase value="10"><cfset vsMes  = 'Octubre'></cfcase>
								<cfcase value="11"><cfset vsMes  = 'Noviembre'></cfcase>
								<cfcase value="12"><cfset vsMes  = 'Diciembre'></cfcase>
							</cfswitch>
							<td>#vsMes#</td>
						<cfelseif form.AgruparPor eq 2>
							<cfset numeroTrimestre = Int((vnMeses - 1) / divisorAgrupar)>
							<cfset nombreTrimestre = "">
							<cfswitch expression="#numeroTrimestre#">
								<cfcase value="0"><cfset nombreTrimestre = "Primer Trimeste"></cfcase>
								<cfcase value="1"><cfset nombreTrimestre = "Segundo Trimeste"></cfcase>
								<cfcase value="2"><cfset nombreTrimestre = "Tercer Trimeste"></cfcase>
								<cfcase value="3"><cfset nombreTrimestre = "Cuarto Trimeste"></cfcase>
							</cfswitch>
							<td>#nombreTrimestre#</td>
						<cfelseif form.AgruparPor eq 3>
							<cfset numeroSemestre = Int((vnMeses - 1) / divisorAgrupar)>
							<cfset nombreSemestre = "">
							<cfswitch expression="#numeroSemestre#">
								<cfcase value="0"><cfset nombreSemestre = "Primer Semestre"></cfcase>
								<cfcase value="1"><cfset nombreSemestre = "Segundo Semestre"></cfcase>
							</cfswitch>
							<td>#nombreSemestre#</td>
						<cfelseif form.AgruparPor eq 4>
							<td>Año:&nbsp;#vnAnno#</td>
						</cfif>

						<cfquery name="rsExiste" dbtype="query">
							select *
							from RSReporte
							where numeroAgrupar = <cfqueryparam cfsqltype="cf_sql_integer" value="#(vnAnno * factorAgrupar + Int((vnMeses - 1) / divisorAgrupar))#">
						</cfquery>
						
						<cfif rsExiste.RecordCount NEQ 0>
							<!---A la funcion funcDetalle que muestra el popup se le envia el mes y año seleccionado mas un parametro para saber que criterio es 1:Entregas,2:Gestion reclamos por cantidad,3:Gestion reclamos por precio--->
							<cfif isdefined("url.imprimir")>
								<td align="center">#LSNumberFormat(rsExiste.Notatotal,'____.__')#%</td>
								<td align="center">#LSNumberFormat(rsExiste.Total_reclamosC,'____.__')#%</td>
								<td align="center">#LSNumberFormat(rsExiste.Total_reclamosP,'____.__')#%</td>
							<cfelse>
								<td align="center"><a href="javascript: funcDetalle('#vnMeses#','#vnAnno#',1);">#LSNumberFormat(rsExiste.Notatotal,'____.__')#%</a></td>
								<td align="center"><a href="javascript: funcDetalle('#vnMeses#','#vnAnno#',2);">#LSNumberFormat(rsExiste.Total_reclamosC,'____.__')#%</a></td>
								<td align="center"><a href="javascript: funcDetalle('#vnMeses#','#vnAnno#',3);">#LSNumberFormat(rsExiste.Total_reclamosP,'____.__')#%</a></td>
							</cfif>
							<td align="center">#LSNumberFormat(rsExiste.Notatotal + rsExiste.Total_reclamosC + rsExiste.Total_reclamosP,'____.__')#%</td>
						<cfelse>
							<td align="center"> ---- </td>
							<td align="center"> ---- </td>
							<td align="center"> ---- </td>
							<td align="center"> ---- </td>
						</cfif>
					</tr>
	
					<cfset finicial =  dateadd('m', divisorAgrupar, finicial)>
				</cfloop>
			<cfelse>
				<tr>
					<td  align="center" colspan="7">------------   No hay informaci&oacute;n   ------------</td>
				</tr>
			</cfif>
		<cfelse>
			<tr>
				<td  align="center" colspan="7">------------   No hay informaci&oacute;n   ------------</td>
			</tr>
		</cfif>
		</table>
	</cfoutput>
