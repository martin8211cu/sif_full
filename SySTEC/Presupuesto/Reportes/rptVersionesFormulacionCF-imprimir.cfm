<cf_htmlReportsHeaders 
	title="Formulación Presupuestales" 
	filename="Formulacion_Presupuestales_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls"
	irA="/cfmx/SySTEC/Presupuesto/Reportes/rptVersionesFormulacionCF.cfm" 
	>
<cfsetting enablecfoutputonly="no" requesttimeout="3600">
<cfflush interval="1000">
<cf_templatecss>
<cfif not isdefined("form.chkAprobadas")>
	<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera"
		method="sbCreaCPresupuestoDeVersion"
		Lprm_CVid="#form.CVid#"
	/>
</cfif>
<cfswitch expression="#form.ID_REPORTE#">
	<cfcase value="1">
		<cfset FiltroCuentas = "and rtrim(cp.CPformato) like '#trim(form.CPformato)#%'">
	</cfcase>
	<cfcase value="2">
		<cfset ArregloCuentas = ListToArray(form.cuentaidlist,',')>
		<cfif ArregloCuentas[2] EQ "">
			<cfset ArregloCuentas[2] = ArregloCuentas[1]>
		</cfif>
		<cfset FiltroCuentas = "and rtrim(cp.CPformato) between '#ListGetAt(ArregloCuentas[1],1,'|')#' and '#trim(ArregloCuentas[2])#'">
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
			<cfset FiltroCuentas &= " rtrim(cp.CPformato) like '#ArregloCuentas[ind]#'">
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

<cf_dbtemp name="tempCentrosF_v1" returnvariable="CFuncionales">
	<cf_dbtempcol name="CFid"      		type="numeric" 		mandatory="yes">			
	<cf_dbtempcol name="CFcodigo"       type="char(10)" 	mandatory="yes">
	<cf_dbtempcol name="CFdescripcion"	type="char(60)" 	mandatory="yes">
	<cf_dbtempcol name="CPformato"	    type="char(100)"	mandatory="yes">	
	<cf_dbtempkey cols="CFid,CPformato">
	<cf_dbtempindex cols="CFid">
</cf_dbtemp>
<cfquery datasource="#session.dsn#">
	insert into #CFuncionales# (CFid, CFcodigo, CFdescripcion, CPformato)
	select cf.CFid, cf.CFcodigo, cf.CFdescripcion, smp.CPSMascaraP
	  from CFuncional cf
		inner join CPSeguridadMascarasCtasP smp
			on smp.CFid = cf.CFid 
	 where cf.Ecodigo = #session.Ecodigo#
		and smp.CPSMconsultar = 1
		and smp.CPSMformulacion = 1
</cfquery>
<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
<cfquery name="rsVersiones" datasource="#Session.DSN#">
	select CVdescripcion <cfif isdefined("form.chkAprobadas")>#_CAT#'(Aprobada)'</cfif> as CVdescripcion
	from CVersion
	where Ecodigo = #Session.Ecodigo#
		and CVid = #form.CVid#
</cfquery>
<cf_dbtemp name="tempCtasPresupuesto_v1" returnvariable="CPresupuesto">
	<cf_dbtempcol name="CPcuenta"      type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="CVPcuenta"     type="numeric" 		mandatory="yes">				
	<cf_dbtempcol name="Ecodigo"       type="int" 			mandatory="yes">
	<cf_dbtempcol name="CPformato"     type="varchar(100)" 	mandatory="yes">
	<cf_dbtempcol name="tipo"	       type="char(1)"		mandatory="yes">
	<cf_dbtempcol name="CFid"	       type="numeric"		mandatory="yes">
	<cf_dbtempkey cols="CFid,CPcuenta">
	<cf_dbtempindex cols="CPcuenta">
</cf_dbtemp>

<cfquery datasource="#session.DSN#">
	insert into #CPresupuesto#
		(	
			CPcuenta,
			CVPcuenta,
			Ecodigo,
			CPformato,
			tipo,
			CFid
		)
	select distinct
			cp.CPcuenta,
			cp.CVPcuenta,
			cp.Ecodigo,
			cp.CPformato,
			cm.Ctipo,
			cf.CFid
	from CVPresupuesto cp
		
		inner join CtasMayor cm
			on cm.Ecodigo = cp.Ecodigo
		 	  and cm.Cmayor  = cp.Cmayor
		
		inner join #CFuncionales# cf
			on cp.CPformato like cf.CPformato
			
		where cp.Ecodigo  = #session.Ecodigo#
		 and CVid = #form.CVid#
		 #preservesinglequotes(FiltroCuentas)#
		  and (select count(1)
			  from CVFormulacionTotales vft
			 where vft.Ecodigo   = cp.Ecodigo
			   and vft.CVid 	   = cp.CVid
			   and vft.CVPcuenta = cp.CVPcuenta
			   #preservesinglequotes(FiltroOficinas)#
			) > 0
</cfquery>
<cf_dbtemp name="CtasPresupuestoCF_v1" returnvariable="CtasPCF">
	<cf_dbtempcol name="Ocodigo"  		type="numeric"		mandatory="yes">
	<cf_dbtempcol name="Oficodigo"  	type="char(10)"		mandatory="yes">
	<cf_dbtempcol name="Odescripcion"  	type="char(60)"		mandatory="yes">
	<cf_dbtempcol name="CFid"  			type="numeric"		mandatory="yes">
	<cf_dbtempcol name="CFcodigo"  		type="char(10)"		mandatory="yes">
	<cf_dbtempcol name="CFdescripcion"  type="char(60)"		mandatory="yes">
	<cf_dbtempcol name="CPcuenta"  		type="numeric"		mandatory="yes">
	<cf_dbtempcol name="CPformato"  	type="char(100)"	mandatory="yes">
	<cf_dbtempcol name="CPdescripcion"  type="varchar(80)"	mandatory="yes">
	<cf_dbtempcol name="Total"  		type="money"		mandatory="yes">
	<cf_dbtempcol name="Porcentaje"  	type="float"		mandatory="yes">
	<cf_dbtempcol name="EsMayor"  		type="bit" 			mandatory="yes">
	
	<cf_dbtempkey cols="Ocodigo,CFid,CPcuenta">
	<cf_dbtempindex cols="Ocodigo,CFid,CPcuenta">
</cf_dbtemp>
<cfquery  name="RsMlocal" datasource="#session.dsn#">
	select Mnombre, Miso4217, Msimbolo
		from Empresa e
			inner join Monedas m
				on m.Mcodigo = e.Mcodigo
		where e. Ecodigo = #session.EcodigoSDC#
</cfquery>
<cfif form.Formato EQ 'M'>
	<cfset suf = "/1000">
	<cfset FormatoCurrent = "Montos en Miles de #RsMlocal.Mnombre#(#RsMlocal.Miso4217#)">
<cfelse>
	<cfset suf = "">
	<cfset FormatoCurrent = "Montos en #RsMlocal.Mnombre#(#RsMlocal.Miso4217#)">
</cfif>
<cfquery datasource="#session.DSN#">
	insert into #CtasPCF#
		(	Ocodigo,	Oficodigo,	Odescripcion,
			CFid,		CFcodigo,	CFdescripcion,
			CPcuenta,	CPformato,	CPdescripcion,
			Total,		Porcentaje,	EsMayor
		)
	select 	o.Ocodigo, 		o.Oficodigo, 		o.Odescripcion,
			cf.CFid,		cf.CFcodigo,		cf.CFdescripcion,
			cp.CPcuenta,	cp.CPformato,		cp.CPdescripcion,
			
			sum(vft.CVFTmontoAplicar) #suf#,0, 
			case when <cf_dbfunction name="length"	args="rtrim(cp.CPformato)"> = 4 then 1 else 0 end
			
	from #CPresupuesto# tcp
	
		inner join CFuncional cf
			on cf.CFid = tcp.CFid
			
		inner join PCDCatalogoCuentaP ccp 
		   on ccp.CPcuenta = tcp.CPcuenta

		inner join CPresupuesto cp
		  on cp.CPcuenta = ccp.CPcuentaniv 
			
		inner join CtasMayor cm
		  on cm.Ecodigo = cp.Ecodigo 
		  and cm.Cmayor = cp.Cmayor
		  
		 inner join CVFormulacionTotales vft
				 on vft.Ecodigo   = cm.Ecodigo
				and vft.CVid 	  = #form.CVid#
				and vft.CVPcuenta = tcp.CVPcuenta
				#preservesinglequotes(FiltroOficinas)#
					
		inner join Oficinas o
			on o.Ocodigo = vft.Ocodigo 
			and o.Ecodigo = vft.Ecodigo

		where tcp.Ecodigo  = #session.Ecodigo#
			<cfif form.nivelDetalle neq -1>
				and ccp.PCDCniv <= #form.nivelDetalle#
			</cfif>
			
	group by  o.Ocodigo, 	o.Oficodigo, 	o.Odescripcion,
			cf.CFid,		cf.CFcodigo,	cf.CFdescripcion,
			cp.CPcuenta,	cp.CPformato,	cp.CPdescripcion
</cfquery>
<cfquery name="rsEmpresa" datasource="#Session.DSN#">
	select Edescripcion 
	from Empresas
	where Ecodigo = #Session.Ecodigo#
</cfquery>
<cf_dbfunction name="to_float" args="sum(Total)" dec="2" returnvariable="LvarRedondearTotal">
<cfquery name="rsQueryT" datasource="#Session.DSN#">
	select sum(Total) total
	from #CtasPCF#
	where EsMayor = 1
</cfquery>
<cfif rsQueryT.total gt 0>
	<cfset tt = rsQueryT.total>
<cfelse>
	<cfset tt = "1">
</cfif>

<cf_dbfunction name="to_float" args="Total / #tt# * 100" dec="2" returnvariable="LvarRedondearPorcentaje">
<cfquery datasource="#Session.DSN#">
	update #CtasPCF# set Porcentaje = #LvarRedondearPorcentaje# 
</cfquery>

<cfquery name="rsQueryT" datasource="#Session.DSN#">
	select sum(Total) total, sum(Porcentaje) porcentaje
	from #CtasPCF#
	where EsMayor = 1
</cfquery>

<cfquery name="rsQuery" datasource="#Session.DSN#">
	select 
		Ocodigo, 	Oficodigo, 	Odescripcion, 
		CFid, 		CFcodigo, 	CFdescripcion,
		CPcuenta,	CPformato,	CPdescripcion,
		Total,		Porcentaje,	EsMayor 
	from #CtasPCF#
	order by Oficodigo, CFcodigo, CPformato
</cfquery>
<table width="100%"  border="0" cellspacing="1" cellpadding="1">
	<tr>
		<td colspan="5" align="center"><strong><font size="4"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></font></strong></td>
	</tr>
	<tr>
		<td colspan="5" align="center"><font size="3"><strong>Versión de Formulación:&nbsp;</strong><cfoutput>#rsVersiones.CVdescripcion#</cfoutput></font></td>
	</tr>
	<tr>
		<td colspan="5" align="center"><font size="3"><strong><cfoutput>#FormatoCurrent#</cfoutput></strong></font></td>
	</tr>
	
	<cfset LarrCuentas  = ListToarray(cuentaidlist)>
	<cfswitch expression="#form.ID_REPORTE#">
		<cfcase value="1"><!---2 - CP x RANGO            --->
			<tr>
				<td colspan="5" align="center"><strong>Cuenta:</strong>&nbsp;<cfoutput>#form.CPformato#</cfoutput></td>
			</tr>
		</cfcase>
		<cfcase value="2"><!---2 - CP x RANGO            --->
			<cfset cuentadesde  = Mid(trim(LarrCuentas[1]),1,4)> 
			<cfset cuentahasta  = Mid(trim(LarrCuentas[2]),1,4)>
			<cfset FormatoDesde = listtoarray(LarrCuentas[1],"|")>	
			<cfset FormatoDesde = FormatoDesde[1]>
			<cfset FormatoHasta = listtoarray(LarrCuentas[2],"|")>	
			<cfset FormatoHasta = FormatoHasta[1]>
			<tr>
				<td colspan="5" align="center"><strong>Cuenta Inicial:</strong>&nbsp;<cfoutput>#FormatoDesde#</cfoutput>&nbsp;<strong>&nbsp;Cuenta Final:</strong>&nbsp;<cfoutput>#FormatoHasta#</cfoutput></td>
			</tr>
		</cfcase>
		<cfcase value="3"><!---3 - CP x LISTA DE CUENTAS --->
			<tr>
				<td colspan="5" align="center"><strong>Lista de cuentas:</strong></td>
			</tr>
			<tr>
				<td colspan="5" align="center">
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
		<td colspan="5" align="center"><strong>Nivel de cuenta utilizado:</strong>&nbsp; <cfoutput><cfif form.nivelDetalle neq -1>#form.nivelDetalle#<cfelse>Último Nivel</cfif></cfoutput></td>
	</tr>
	<tr>
		<td colspan="5" align="center"><cfoutput>#Agrupador#</cfoutput></td>
	</tr>
	<tr>
		<td><strong>Usuario:</strong>&nbsp;<cfoutput>#Session.Usuario#</cfoutput></td>
		<td>&nbsp;</td>
		<td colspan="2" nowrap><strong>Fecha:</strong>&nbsp;<cfoutput>#DateFormat(Now(),'DD/MM/YYYY')# #TimeFormat(Now(),'medium')#</cfoutput></td>
	</tr>
	<tr><td colspan="5">&nbsp;</td>
	</tr>
	<tr bgcolor="#0099CC" >
		<td nowrap>&nbsp;</td>
		<td nowrap><font color="#FFFFFF"><strong>Cuenta Presupuesto</strong></font></td>
		<td nowrap><strong><font color="#FFFFFF">Descripción</font></strong></td>
		<td nowrap align="right"><strong><font color="#FFFFFF">Total</font></strong></td>
		<td nowrap align="right"><strong><font color="#FFFFFF">Porcentaje</font></strong></td>
	</tr>
	
	<cfset Lvarcontador = 0>
	<cfset LvarO = "">
	<cfset LvarCF = "">
	<cfset Lvartotal = 0>
	<cfset Lvarporcentaje = 0>
	<cfoutput query="rsQuery">
		<cfif LvarO neq rsQuery.Oficodigo>
			<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>">
				<td colspan="5"><strong>#rsQuery.Oficodigo#-#rsQuery.Odescripcion#</strong></td>
			</tr>
			<cfset Lvarcontador += 1>
			<cfset LvarO = rsQuery.Oficodigo>
			<cfset LvarCF = "">
		</cfif>
		<cfif LvarCF neq rsQuery.CFcodigo>
			<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>"><td colspan="5">&nbsp;</td></tr>
		</cfif>
		<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>">
			<cfif LvarCF neq rsQuery.CFcodigo>
				<td nowrap>&nbsp;&nbsp;&nbsp;#rsQuery.CFcodigo#-#rsQuery.CFdescripcion#</td>
				<cfset LvarCF = rsQuery.CFcodigo>
			<cfelse>
				<td nowrap>&nbsp;</td>
			</cfif>
			<td nowrap>#rsQuery.CPformato#</td>
			<td nowrap>#rsQuery.CPdescripcion#</td>
			<td align="right" nowrap>#numberFormat(rsQuery.total,',9.00')#</td>
			<td nowrap align="right">#numberFormat(rsQuery.Porcentaje,',9.00')#</td>
		</tr>
		<cfset Lvarcontador += 1>
		<cfset Lvarporcentaje += rsQuery.Porcentaje>
	</cfoutput>
	<cfif rsQuery.recordcount eq 0>
		<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>"><td colspan="5">&nbsp;</td></tr>
		<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>">
			<td colspan="5" align="center"><strong>No existen lineas de detalle que corresponda con los filtros ingresados.</strong></td>
		</tr>
		<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>"><td colspan="5">&nbsp;</td></tr>
	<cfelse>
		<tr><td colspan="5" align="center">&nbsp;</td></tr>
		<tr>
			<cfoutput>
			<tr><td colspan="3" nowrap><strong>TOTAL</strong></td>
			<td align="right" nowrap><strong>#numberFormat(rsQueryT.total,',9.00')#</strong></td>
			<td align="right" nowrap><strong>#numberFormat(rsQueryT.porcentaje,',9.00')#</strong></td>
			</tr></cfoutput>
		
	</cfif>
	<tr>
		<td colspan="5" align="center">---------- FIN DEL REPORTE ----------</td>
	</tr>
	<tr>
		<td colspan="5" align="center">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="5"><strong>Notas:&nbsp;</strong><br />*&nbsp;Cuando el total del porcetaje no especifica el 100%, se debe al redondeo de las lineas de detalle, debido que alguna o algunas de ellas tiene un porcentanje tan bajo que al redondear a dos dígitos este pasa a ser 0.00<br />*&nbsp; El porcentaje esta basado con con total general.</td>
	</tr>
</table>
<cffunction name="fnComodinToMascara" access="private" output="no">
	<cfargument name="Comodin" type="string" required="yes">

	<cfset var LvarComodines = "?,*,!">

	<cfset var LvarMascara = Arguments.Comodin>
	<cfloop index="LvarChar" list="#LvarComodines#">
		<cfset LvarMascara = replace(LvarMascara,mid(LvarChar,1,1),"_","ALL")>
	</cfloop>

	<cfreturn LvarMascara>
</cffunction>