<cf_htmlReportsHeaders 
	title="Presupuesto Ordinario, Extraordinario y Modificaciones (Aplicado a Formulación)" 
	filename="Formulacion_Presupuestales_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls"
	irA="/cfmx/SySTEC/Presupuesto/Reportes/rptLiquidacionPresupuestaria.cfm" 
	>
<cfsetting enablecfoutputonly="no" requesttimeout="3600">
<cfflush interval="1000">
<cf_templatecss>
<cfswitch expression="#form.ID_REPORTE#">
	<cfcase value="1">
		<cfset FiltroCuentas = "and rtrim(cp.CPformato) like '#trim(form.CPformato)#%'">
	</cfcase>
	<cfcase value="2">
		<cfset ArregloCuentas = ListToArray(form.cuentaidlist,',')>
		<cfif ArregloCuentas[2] EQ "">
			<cfset ArregloCuentas[2] = ArregloCuentas[1]>
		</cfif>
		<cfset FiltroCuentas = "and rtrim(cp.CPformato) between '#ListGetAt(ArregloCuentas[1],1,'|')#' and '#trim(ArregloCuentas[2])#%'">
	</cfcase>
	<cfcase value="3">
		<cfset Lstfinal = "">
		<cfset ArregloCuentas = ListToArray(form.CuentaidList)>
		<cfset fin = ArrayLen(ArregloCuentas)>	
		<cfset FiltroCuentas = "">
		<cfloop from="1" to="#fin#" step="1" index="ind">
			<cfif FiltroCuentas EQ "">
				<cfset FiltroCuentas &= " and ( ">
			<cfelse>
				<cfset FiltroCuentas &= " or ">
			</cfif>
			<cfset FiltroCuentas &= " rtrim(cp.CPformato) like '#ArregloCuentas[ind]#%'">
		</cfloop>
		<cfset FiltroCuentas &= " ) ">
	</cfcase>
</cfswitch>
<cfset arrayOfi = ListToArray(form.ubicacion,',')>

<cfswitch expression="#arrayOfi[1]#">
	<cfcase value="of">
		<cfquery datasource="#session.dsn#" name="rsOficinas">
			select Oficodigo, Odescripcion 
				from Oficinas 
			where Ocodigo = #arrayOfi[2]#
				and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfif rsOficinas.Recordcount EQ 0>
			<cfthrow message="La Oficina especificada en los Filtros de Entrada no existe.">
		</cfif>
		<cfset Agrupador = '<strong>Oficina:</strong>&nbsp;'&rsOficinas.Oficodigo&' - '&rsOficinas.Odescripcion>
		<cfset FiltroOficinas = " and vft.Ocodigo = #arrayOfi[2]#">
	</cfcase>
	<cfcase value="go">
		<cfif isdefined('form.listGO') and len(trim('form.listGO'))>
			<cfquery name="rsGO" datasource="#session.DSN#">
				select GO.GOid, GO.GOcodigo, GO.GOnombre, (select count(1) from AnexoGOficina where Ecodigo = GO.Ecodigo and GOcodigo = GO.GOcodigo) cantidad
					from AnexoGOficina GO
				where GO.GOid in (#form.listGO#)
				  and GO.Ecodigo = #session.Ecodigo#
				 order by GO.GOcodigo
			</cfquery>
			<cfloop query="rsGO">
				<cfif rsGO.cantidad GT 1>
					<cfthrow message="Existe en la empresa #rsGO.cantidad# Catalogos de Oficinas con el mismo codigo ('#trim(rsGO.GOcodigo)#')">
				</cfif>
			</cfloop>
			<cfquery name="rsGODet" datasource="#session.DSN#">
				select Ocodigo from AnexoGOficinaDet where GOid in (#form.listGO#)
					union all
				select -1 as Ocodigo from dual
			</cfquery>
		<cfelse>
			<cfquery name="rsGO" datasource="#session.DSN#">
				select GOcodigo, GOnombre
					from AnexoGOficina
				where GOid = #arrayOfi[2]#
			</cfquery>
			<cfif rsGO.Recordcount EQ 0>
				<cfthrow message="El grupo de empresas especificado en los Filtros de Entrada no existe.">
			</cfif>
			<cfquery name="rsGODet" datasource="#session.DSN#">
				select Ocodigo from AnexoGOficinaDet where GOid = #arrayOfi[2]#
					union all
				select -1 as Ocodigo from dual
			</cfquery>
		</cfif>
		<cfset Agrupador = '<strong>Grupo de Oficinas:</strong>&nbsp;#ValueList(rsGO.GOnombre)#'>
		<cfset FiltroOficinas = "and vft.Ocodigo in (#ValueList(rsGODet.Ocodigo)#)">
	</cfcase>
</cfswitch>
<!---Presupuesto Ordinario, Extraordinario--->
<cfquery name="rsColumnasP" datasource="#session.DSN#">
	 select  anf.ANFid, anf.ANFcodigo, anf.ANFdescripcion
		from ANformulacion anf
	 where anf.Ecodigo= #session.Ecodigo#
	 	and exists(select 1 from ANformulacionVersion anfv
			 where anfv.ANFid = anf.ANFid
			 	and anfv.Ecodigo = anf.Ecodigo
			   	and anfv.CPPid = #form.CPPid#)
	 order by anf.ANFcodigo
</cfquery>
<cf_dbtemp name="tempVersiones_V1" returnvariable="Versiones">
	<cf_dbtempcol name="ANFid"      type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="CVid"     	type="numeric" 		mandatory="yes">	
	<cf_dbtempcol name="Columna"  	type="char(10)" 	mandatory="yes">	
	<cf_dbtempcol name="Ecodigo"    type="int" 			mandatory="yes">	
</cf_dbtemp>
<cfquery datasource="#session.DSN#">
	insert into #Versiones# (ANFid, CVid, Columna, Ecodigo)
	 select  anf.ANFid, anfv.CVid, anf.ANFcodigo, anf.Ecodigo
		from ANformulacion anf
			inner join ANformulacionVersion anfv
			 on anfv.ANFid = anf.ANFid
			 	and anfv.Ecodigo = anf.Ecodigo
			   	and anfv.CPPid = #form.CPPid#
	 where anf.Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery name="rsVersiones" datasource="#session.DSN#">
	 select  ANFid, CVid, Columna, Ecodigo
		from #Versiones#
	union
	select  -1 ANFid, -1 CVid, '' Columna, -1 Ecodigo
		from dual
</cfquery>

<!---Modificaciones--->
<cfquery name="rsColumnasM" datasource="#session.DSN#">
	 select  tae.CPTAEid, tae.CPTAEcodigo, tae.CPTAEdescripcion 
		from CPtipoAutExterna tae
	 where tae.Ecodigo= #session.Ecodigo#
	 	and exists(select 1 from CPDocumentoAE dae
			 where dae.CPTAEid = tae.CPTAEid
			   	and dae.CPPid = #form.CPPid#)
	 order by tae.CPTAEcodigo
</cfquery>
<cf_dbtemp name="tempModificaciones_V1" returnvariable="Modificaciones">
	<cf_dbtempcol name="CPTAEid"    type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="CPDAEid"    type="numeric" 		mandatory="yes">	
	<cf_dbtempcol name="Columna"  	type="char(10)" 	mandatory="yes">	
	<cf_dbtempcol name="Ecodigo"    type="int" 			mandatory="yes">	
</cf_dbtemp>
<cfquery datasource="#session.DSN#">
	insert into #Modificaciones# (CPTAEid, CPDAEid, Columna, Ecodigo)
	 select tae.CPTAEid, dae.CPDAEid, tae.CPTAEcodigo, tae.Ecodigo
		from CPtipoAutExterna tae
			inner join CPDocumentoAE dae
				on dae.CPTAEid = tae.CPTAEid
				and dae.CPPid = #form.CPPid#
	 where tae.Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery name="rsModificaciones" datasource="#session.DSN#">
	 select  CPTAEid, CPDAEid, Columna, Ecodigo
		from #Modificaciones#
	union 
	select  -1 CPTAEid, -1 CPDAEid, '' Columna, -1 Ecodigo
		from dual
</cfquery>

<cfquery datasource="#session.dsn#" name="RsMlocal">
	select Mnombre 
		from Empresa e
			inner join Monedas m
				on m.Mcodigo = e.Mcodigo
		where e. Ecodigo = #session.Ecodigosdc#
</cfquery>
<cfquery name="rsEmpresa" datasource="#Session.DSN#">
	select Edescripcion 
	from Empresas
	where Ecodigo = #Session.Ecodigo#
</cfquery>
<cfif form.Formato EQ 'M'>
	<cfset suf = "/1000">
	<cfset FormatoCurrent = "Montos en Miles de #RsMlocal.Mnombre#">
<cfelse>
	<cfset suf = "">
	<cfset FormatoCurrent = "Montos en #RsMlocal.Mnombre#">
</cfif>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery name="rsPeriodoPres" datasource="#session.dsn#">
	select  CPPid, 
		case CPPtipoPeriodo 
			when 1 then 'Mensual' 
			when 2 then 'Bimestral' 
			when 3 then 'Trimestral' 
			when 4 then 'Cuatrimestral' 
			when 6 then 'Semestral' 
			when 12 then 'Anual' 
			else '' 
		end
		#_Cat# ' de ' #_Cat# 
       	case <cf_dbfunction name="date_part" args="MM,CPPfechaDesde">
	        when 1 then 'Enero' 
			when 2 then 'Febrero' 
			when 3 then 'Marzo' 
			when 4 then 'Abril' 
			when 5 then 'Mayo' 
			when 6 then 'Junio' 
			when 7 then 'Julio' 
			when 8 then 'Agosto' 
			when 9 then 'Setiembre' 
			when 10 then 'Octubre' 
			when 11 then 'Noviembre' 
			when 12 then 'Diciembre'
			else '' 
		end
		#_Cat# ' ' #_Cat# 
		case 
			when <cf_dbfunction name="date_format" args="CPPfechaDesde,YYYY"> <> <cf_dbfunction name="date_format" args="CPPfechaHasta,YYYY"> 
			then <cf_dbfunction name="date_format" args="CPPfechaDesde,YYYY">
			else ''
		end
			#_Cat# ' a ' #_Cat# 
		case <cf_dbfunction name="date_part" args="MM,CPPfechaHasta">
			when 1 then 'Enero' 
			when 2 then 'Febrero' 
			when 3 then 'Marzo' 
			when 4 then 'Abril' 
			when 5 then 'Mayo' 
			when 6 then 'Junio' 
			when 7 then 'Julio' 
			when 8 then 'Agosto' 
			when 9 then 'Setiembre' 
			when 10 then 'Octubre' 
			when 11 then 'Noviembre' 
			when 12 then 'Diciembre' else '' end
			#_Cat# ' ' #_Cat# <cf_dbfunction name="date_format" args="CPPfechaHasta,YYYY">  as descripcion
		from CPresupuestoPeriodo
		where Ecodigo = #session.Ecodigo#
		and CPPid = #form.CPPid#
</cfquery>
<cf_dbtemp name="tempCtasVP_V1" returnvariable="CPresupuesto">
	<cf_dbtempcol name="CPcuenta"      type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="CVPcuenta"     type="numeric" 		mandatory="no">			
	<cf_dbtempcol name="Ecodigo"       type="int" 			mandatory="yes">
	<cf_dbtempcol name="CPformato"     type="varchar(100)" 	mandatory="yes">
	<cf_dbtempcol name="tipo"	       type="char(1)"		mandatory="yes">
	<cf_dbtempcol name="CVid"	       type="numeric"		mandatory="no">
</cf_dbtemp>
<cfquery datasource="#session.DSN#">
	insert into #CPresupuesto#
		(	
			CPcuenta,
			CVPcuenta,
			Ecodigo,
			CPformato,
			tipo,
			CVid
		)
	select distinct
			cp.CPcuenta,
			cp.CVPcuenta,
			cp.Ecodigo,
			cp.CPformato,
			cm.Ctipo,
			cp.CVid
	from CVPresupuesto cp
		inner join CtasMayor cm
			on cm.Ecodigo = cp.Ecodigo
			and cm.Cmayor  = cp.Cmayor
		inner join  #Versiones# v
			on v.CVid = cp.CVid
		where cp.Ecodigo  = #session.Ecodigo#
			#preservesinglequotes(FiltroCuentas)#
		 	and (
			   	select count(1)
					 from CVFormulacionTotales f
				where f.Ecodigo   = cp.Ecodigo
				  and f.CVid 	  = cp.CVid
				  and f.CVPcuenta = cp.CVPcuenta
			) > 0
</cfquery>
<cfset lvarVersiones = StructNew()>
<cfloop query="rsColumnasP">
	<cfquery name="rsV" datasource="#session.DSN#">
		select CVid from #Versiones# where ANFid = #rsColumnasP.ANFid#
		union all
		select -1 as CVid from dual
	</cfquery>
	<cfset lvarVersiones[rsColumnasP.ANFcodigo] = valueList(rsV.CVid)>
</cfloop>
<cfset lvarModificaciones = StructNew()>
<cfloop query="rsColumnasM">
	<cfquery name="rsM" datasource="#session.DSN#">
		select CPDAEid from #Modificaciones# where CPDAEid = #rsColumnasM.CPTAEid#
		union all
		select -1 as CPDAEid from dual
	</cfquery>
	<cfset lvarModificaciones[rsColumnasM.CPTAEcodigo] = valueList(rsM.CPDAEid)>
</cfloop>
<cf_dbtemp name="tempCtasV_V1" returnvariable="Cuentas">
		<cf_dbtempcol name="CPcuenta"  				    type="numeric" 	     mandatory="yes">			
		<cf_dbtempcol name="CPformato" 				    type="varchar(100)"  mandatory="yes">
		<cf_dbtempcol name="CPdescripcion"              type="varchar(80)" 	 mandatory="yes">
		<cf_dbtempcol name="nivel"    				    type="int"		     mandatory="yes"> 
		<cf_dbtempcol name="tipo"	  				    type="char(1)"	     mandatory="yes">
		<cf_dbtempcol name="total"	  				    type="money"		 mandatory="no" default="0">
		<cf_dbtempcol name="Ecodigo"  				    type="int" 		     mandatory="yes">
	<cfloop query="rsColumnasP">
		<cf_dbtempcol name="MTP#rsColumnasP.ANFcodigo#" 	type="money"		 mandatory="no" default="0">	
	</cfloop>
	<cfloop query="rsColumnasM">
		<cf_dbtempcol name="MTM#rsColumnasM.CPTAEcodigo#" 	type="money"		 mandatory="no" default="0">	
	</cfloop>
</cf_dbtemp>
<cf_dbfunction name="to_float" args="vft.CVFTmontoAplicar" dec="2" returnvariable="LvarRedondearTotalP">
<cf_dbfunction name="to_float" args="dd.CPDDmonto" dec="2" returnvariable="LvarRedondearTotalM">
<cfquery datasource="#session.DSN#">
	insert into #Cuentas#
			(CPcuenta ,Ecodigo, CPformato, CPdescripcion, nivel, tipo
			<cfloop query="rsColumnasP">
				,MTP#rsColumnasP.ANFcodigo#
			</cfloop>
			<cfloop query="rsColumnasM">
				,MTM#rsColumnasM.CPTAEcodigo#	
			</cfloop>
			) 
	select 	cp.CPcuenta, cp.Ecodigo, cp.CPformato, cp.CPdescripcion, cu.PCDCniv, cm.Ctipo
		<cfloop query="rsColumnasP">
			,sum(case when vft.CVid in(#lvarVersiones[rsColumnasP.ANFcodigo]#) then #LvarRedondearTotalP# #suf# else 0 end)
		</cfloop>
		<cfloop query="rsColumnasM">
			,(select sum(case when dd.CPDDtipo = 1 then #LvarRedondearTotalM# else  - #LvarRedondearTotalM#  end #suf#)
			 from PCDCatalogoCuentaP cuS
			 	
				inner join CPDocumentoD dd 
		 			on dd.CPcuenta = cuS.CPcuenta	
				
				inner join CPDocumentoE de
					on de.CPDEid = dd.CPDEid
				 
			 where de.CPDAEid in(#lvarModificaciones[rsColumnasM.CPTAEcodigo]#)
			   and de.CPDEtipoDocumento = 'E'
			   and ((de.CPDEenAprobacion = 1 and de.CPDEestadoDAE = 10) or de.CPDEaplicado = 1)
			   and cuS.CPcuentaniv = cp.CPcuenta)
		</cfloop>
	from #CPresupuesto# tp
	
		 inner join PCDCatalogoCuentaP cu 
		 	on cu.CPcuenta = tp.CPcuenta
			
		 inner join CPresupuesto cp
		 	on cp.CPcuenta = cu.CPcuentaniv

		 inner join CtasMayor cm
		 	on cm.Ecodigo = cp.Ecodigo
			and cm.Cmayor  = cp.Cmayor

	  	 inner join CVFormulacionTotales vft
			 on vft.Ecodigo   = cm.Ecodigo
			and vft.CVid 	  = tp.CVid
			and vft.CVPcuenta = tp.CVPcuenta
			#preservesinglequotes(FiltroOficinas)#
	
		where cm.Ecodigo  = #session.Ecodigo#
		<cfif form.nivelDetalle neq -1>
		  and cu.PCDCniv <= #form.nivelDetalle#
		</cfif>
		and tp.CVid in (#ValueList(rsVersiones.CVid)#) 
	group by cp.CPcuenta, cp.Ecodigo, cp.CPformato, cp.CPdescripcion, cu.PCDCniv, cm.Ctipo
</cfquery>
<cfquery name="rsDatos" datasource="#session.dsn#">
	update #Cuentas# 
		set total = 0
	<cfloop query="rsColumnasP">
			+ MTP#rsColumnasP.ANFcodigo#
	</cfloop>
	<cfloop query="rsColumnasM">
			+ MTM#rsColumnasM.CPTAEcodigo#	
	</cfloop>
</cfquery>
<cfquery name="rsDatos" datasource="#session.dsn#">
	select 	CPcuenta
			,Ecodigo
			,CPformato
			,CPdescripcion
			,nivel
			,tipo
			,total
	<cfloop query="rsColumnasP">
			,MTP#rsColumnasP.ANFcodigo#
	</cfloop>
	<cfloop query="rsColumnasM">
			,MTM#rsColumnasM.CPTAEcodigo#	
	</cfloop>
	from #Cuentas#
	order by CPformato
</cfquery>
<cfquery name="rsTotales" datasource="#session.dsn#">
	select 	sum(total) total
	<cfloop query="rsColumnasP">
			,sum(MTP#rsColumnasP.ANFcodigo#) MTP#rsColumnasP.ANFcodigo#
	</cfloop>
	<cfloop query="rsColumnasM">
			,sum(MTM#rsColumnasM.CPTAEcodigo#) MTM#rsColumnasM.CPTAEcodigo#
	</cfloop>
	from #Cuentas#
		where nivel = 0
</cfquery>
<table width="100%"  border="0" cellspacing="1" cellpadding="1">
	<tr>
		<td colspan="<cfoutput>#3 + rsColumnasP.recordcount + rsColumnasM.recordcount#</cfoutput>" align="center"><strong><font size="4"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></font></strong></td>
	</tr>
	<tr>
		<td colspan="<cfoutput>#3 + rsColumnasP.recordcount + rsColumnasM.recordcount#</cfoutput>" align="center"><font size="3"><strong>Periodo Presupestal:&nbsp;</strong><cfoutput>#rsPeriodoPres.descripcion#</cfoutput></font></td>
	</tr>
	<tr>
		<td colspan="<cfoutput>#3 + rsColumnasP.recordcount + rsColumnasM.recordcount#</cfoutput>" align="center"><font size="3"><strong><cfoutput>#FormatoCurrent#</cfoutput></strong></font></td>
	</tr>
	
	<cfswitch expression="#form.ID_REPORTE#">
		<cfcase value="1"><!---2 - CP x RANGO            --->
			<tr>
				<td colspan="<cfoutput>#3 + rsColumnasP.recordcount + rsColumnasM.recordcount#</cfoutput>" align="center"><strong>Cuenta:</strong>&nbsp;<cfoutput>#form.CPformato#</cfoutput></td>
			</tr>
		</cfcase>
		<cfcase value="2"><!---2 - CP x RANGO            --->
			<cfset LarrCuentas  = ListToarray(cuentaidlist)>
			<cfset cuentadesde  = Mid(trim(LarrCuentas[1]),1,4)> 
			<cfset cuentahasta  = Mid(trim(LarrCuentas[2]),1,4)>
			<cfset FormatoDesde = listtoarray(LarrCuentas[1],"|")>	
			<cfset FormatoDesde = FormatoDesde[1]>
			<cfset FormatoHasta = listtoarray(LarrCuentas[2],"|")>	
			<cfset FormatoHasta = FormatoHasta[1]>
			<tr>
				<td colspan="<cfoutput>#3 + rsColumnasP.recordcount + rsColumnasM.recordcount#</cfoutput>" align="center"><strong>Cuenta Inicial:</strong>&nbsp;<cfoutput>#FormatoDesde#</cfoutput>&nbsp;<strong>&nbsp;Cuenta Final:</strong>&nbsp;<cfoutput>#FormatoHasta#</cfoutput></td>
			</tr>
		</cfcase>
		<cfcase value="3"><!---3 - CP x LISTA DE CUENTAS --->
			<cfset LarrCuentas  = ListToarray(cuentaidlist)>
			<tr>
				<td colspan="<cfoutput>#3 + rsColumnasP.recordcount + rsColumnasM.recordcount#</cfoutput>" align="center"><strong>Lista de cuentas:</strong></td>
			</tr>
			<tr>
				<td colspan="<cfoutput>#3 + rsColumnasP.recordcount + rsColumnasM.recordcount#</cfoutput>" align="center">
				<cfloop index="i"  from="1" to="#ArrayLen(LarrCuentas)#">
					<cfset arreglo = listtoarray(LarrCuentas[i],"|")>	
					<cfset cuenta = "#arreglo[1]#">
					<cfoutput>#cuenta#</cfoutput><br>
				</cfloop>
				</td>
			</tr>
		</cfcase>
	</cfswitch>
	<tr>
		<td colspan="<cfoutput>#3 + rsColumnasP.recordcount + rsColumnasM.recordcount#</cfoutput>" align="center"><strong>Nivel de cuenta utilizado:</strong>&nbsp; <cfoutput><cfif form.nivelDetalle neq -1>#form.nivelDetalle#<cfelse>Último Nivel</cfif></cfoutput></td>
	</tr>
	<tr>
		<td colspan="<cfoutput>#3 + rsColumnasP.recordcount + rsColumnasM.recordcount#</cfoutput>" align="center"><cfoutput>#Agrupador#</cfoutput></td>
	</tr>
	<tr>
		<td><strong>Usuario:</strong>&nbsp;<cfoutput>#Session.Usuario#</cfoutput></td>
		<td>&nbsp;</td>
		<td colspan="<cfoutput>#1 + rsColumnasP.recordcount + rsColumnasM.recordcount#</cfoutput>" nowrap><strong>Fecha:</strong>&nbsp;<cfoutput>#DateFormat(Now(),'DD/MM/YYYY')# #TimeFormat(Now(),'medium')#</cfoutput></td>
	</tr>
	<tr><td colspan="<cfoutput>#3 + rsColumnasP.recordcount + rsColumnasM.recordcount#</cfoutput>">&nbsp;</td>
	</tr>
	<tr bgcolor="#0099CC" >
		<td nowrap><font color="#FFFFFF"><strong>Cuenta Presupuesto</strong></font></td>
		<td nowrap><strong><font color="#FFFFFF">Descripción</font></strong></td>
		<cfloop query="rsColumnasP">
			<td nowrap align="right"><strong><font color="#FFFFFF"><cfoutput>#rsColumnasP.ANFdescripcion#</cfoutput></font></strong></td>
		</cfloop>
		<cfloop query="rsColumnasM">
			<td nowrap align="right"><strong><font color="#FFFFFF"><cfoutput>#rsColumnasM.CPTAEdescripcion#</cfoutput></font></strong></td>
		</cfloop>
		<td nowrap align="right"><strong><font color="#FFFFFF">Total</font></strong></td>
	</tr>
	
	<cfset Lvarcontador = 0>
	<cfoutput query="rsDatos">
		<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>">
			<td nowrap>#rsDatos.CPformato#</td>
			<td nowrap>#rsDatos.CPdescripcion#</td>
			<cfloop query="rsColumnasP">
				<td align="right" nowrap>#numberFormat(evaluate('rsDatos.MTP' & rsColumnasP.ANFcodigo),',9.00')#</td>
			</cfloop>
			<cfloop query="rsColumnasM">
				<td align="right" nowrap>#numberFormat(evaluate('rsDatos.MTM' & rsColumnasM.CPTAEcodigo),',9.00')#</td>
			</cfloop>
			<td align="right" nowrap>#numberFormat(rsDatos.total,',9.00')#</td>
		</tr>
		<cfset Lvarcontador += 1>
	</cfoutput>
	<cfif rsDatos.recordcount eq 0>
		<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>"><td colspan="5">&nbsp;</td></tr>
		<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>">
			<td colspan="<cfoutput>#3 + rsColumnasP.recordcount + rsColumnasM.recordcount#</cfoutput>" align="center"><strong>No existen lineas de detalle que corresponda con los filtros ingresados.</strong></td>
		</tr>
		<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>"><td colspan="5">&nbsp;</td></tr>
	<cfelse>
		<tr><td colspan="<cfoutput>#3 + rsColumnasP.recordcount#</cfoutput>" align="center">&nbsp;</td></tr>
		<tr>
			<cfoutput>
			<tr><td colspan="2" nowrap><strong>TOTAL GENERAL</strong></td>
			<cfloop query="rsColumnasP">
				<td align="right" nowrap><strong>#numberFormat(evaluate('rsTotales.MTP' & rsColumnasP.ANFcodigo),',9.00')#</strong></td>
			</cfloop>
			<cfloop query="rsColumnasM">
				<td align="right" nowrap><strong>#numberFormat(evaluate('rsTotales.MTM' & rsColumnasM.CPTAEcodigo),',9.00')#</strong></td>
			</cfloop>
			<td align="right" nowrap><strong>#numberFormat(rsTotales.total,',9.00')#</strong></td>
			</tr></cfoutput>
		
	</cfif>
	<tr>
		<td colspan="<cfoutput>#3 + rsColumnasP.recordcount + rsColumnasM.recordcount#</cfoutput>" align="center">---------- FIN DEL REPORTE ----------</td>
	</tr>
	<tr>
		<td colspan="<cfoutput>#3 + rsColumnasP.recordcount + rsColumnasM.recordcount#</cfoutput>" align="center">&nbsp;</td>
	</tr>
</table>
