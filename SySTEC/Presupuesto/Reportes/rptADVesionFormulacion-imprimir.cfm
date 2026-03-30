<cf_htmlReportsHeaders 
	title="Formulación Presupuestales" 
	filename="Formulacion_Presupuestales_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls"
	irA="/cfmx/SySTEC/Presupuesto/Reportes/rptADVesionFormulacion.cfm" 
	>
<cfsetting enablecfoutputonly="no" requesttimeout="3600">
<cfflush interval="1000">

<cfswitch expression="#form.ID_REPORTE#">
	<cfcase value="1">
		<cfset FiltroCuentas = "and rtrim(cp.CPformato) like '#trim(form.CPformato)##chr(127)#'">
	</cfcase>
	<cfcase value="2">
		<cfset ArregloCuentas = ListToArray(form.cuentaidlist,',')>
		<cfif ArregloCuentas[2] EQ "">
			<cfset ArregloCuentas[2] = ArregloCuentas[1]>
		</cfif>
		<cfset FiltroCuentas = "and rtrim(cp.CPformato) between '#ArregloCuentas[1]#' and '#trim(ArregloCuentas[2])#'">
	</cfcase>
	<cfcase value="3">
			<cfset Lstfinal = "">
			<cfset ArregloCuentas = ListToArray(form.CuentaidList,',')>
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
<cfset arrayOfi = #ListToArray(form.ubicacion,',')#>

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
		<cfset Agrupador 	  = '<strong>Oficina:</strong>'&rsOficinas.Oficodigo&'-'&rsOficinas.Odescripcion>
		<cfset FiltroOficinas = " and dd.Ocodigo = #arrayOfi[2]#">
		<cfset esOficina = "true">
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
				select GOid,GOcodigo, GOnombre
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
		<cfset Agrupador 	  = "<strong>Grupo de Oficinas:</strong> #ValueList(rsGO.GOnombre)#">
		<cfset FiltroOficinas = "and dd.Ocodigo in (#ValueList(rsGODet.Ocodigo)#)">
		<cfset esOficina = "false">
	</cfcase>		
</cfswitch>
<cfset estado = "">
<cfif form.Estado eq '1'>
	<cfset estado = " and ((de.CPDEenAprobacion = 0 and de.CPDEaplicado = 0 and de.CPDErechazado = 0) 
					or (de.CPDEenAprobacion = 1 and de.CPDAEestado in (0,9)))">
	<cfset msgEstado = "<strong>Estado Documento:</strong> Pendiente">
<cfelseif form.Estado eq '2'>
	<cfset estado = "and ((de.CPDEenAprobacion = 1 and de.CPDAEestado = 10) or de.CPDEaplicado = 1)">
	<cfset msgEstado = "<strong>Estado Documento:</strong> Aplicado">
<cfelse>
	<cfset estado = "">
	<cfset msgEstado = "<strong>Estado Documento:</strong> Pendiente/Aplicado">
</cfif>
<cfquery datasource="#session.dsn#" name="RsMlocal">
	select Mnombre 
		from Empresa e
			inner join Monedas m
				on m.Mcodigo = e.Mcodigo
		where e. Ecodigo = #session.Ecodigosdc#
</cfquery>
<cfif form.Format EQ 'M'>
	<cfset suf = "/1000">
	<cfset FormatoCurrent = "Montos en Miles de #RsMlocal.Mnombre#">
<cfelse>
	<cfset suf = "">
	<cfset FormatoCurrent = "Montos en #RsMlocal.Mnombre#">
</cfif>

<cf_dbtemp name="tempCtasPAD_V1"	returnvariable="CPresupuesto">
	<cf_dbtempcol name="CPcuenta"      type="numeric" 		mandatory="yes">		
	<cf_dbtempcol name="Ecodigo"       type="int" 			mandatory="yes">
	<cf_dbtempcol name="CPformato"     type="varchar(100)" 	mandatory="yes">
	<cf_dbtempcol name="tipo"	       type="char(1)"		mandatory="yes">
</cf_dbtemp>

<cfquery datasource="#session.DSN#">
	insert into #CPresupuesto#
		(	
			CPcuenta,
			Ecodigo,
			CPformato,
			tipo
		)
	select distinct
			cp.CPcuenta,
			cp.Ecodigo,
			cp.CPformato,
			cm.Ctipo
			
	from CPDocumentoE de
	
		inner join CPDocumentoD dd
			on dd.CPDEid = de.CPDEid
		
		inner join CPresupuesto cp
			on cp.CPcuenta = dd.CPcuenta
		
		inner join CtasMayor cm
			on cm.Ecodigo = cp.Ecodigo and cm.Cmayor  = cp.Cmayor
		
		inner join CPDocumentoAE dae
			on dae.CPDAEid = de.CPDAEid
		
		where de.Ecodigo  = #session.Ecodigo#
			#preservesinglequotes(FiltroCuentas)#
		 	and de.CPDAEid = #form.CPDAEid#
			and de.CPDEtipoDocumento = 'E'
			#preservesinglequotes(estado)#
</cfquery>

<cf_dbtemp name="tempCtsAD_V1" returnvariable="Cuentas">
			<cf_dbtempcol name="CPcuenta"  				    type="numeric" 	     mandatory="yes">			
			<cf_dbtempcol name="Ecodigo"  				    type="int" 		     mandatory="yes">
			<cf_dbtempcol name="CPformato" 				    type="varchar(100)"  mandatory="yes">
			<cf_dbtempcol name="nivel"    				    type="int"		     mandatory="yes"> 
			<cf_dbtempcol name="tipo"	  				    type="char(1)"	     mandatory="yes">
			<cf_dbtempcol name="CPdescripcion"              type="varchar(80)" 	 mandatory="yes">
	<cfif isdefined('form.chkColGO')>
		<cfloop query="rsGO">
			<cf_dbtempcol name="TA#trim(rsGO.GOcodigo)#"	  		type="money"		 mandatory="no">
			<cf_dbtempcol name="TD#trim(rsGO.GOcodigo)#"	  		type="money"		 mandatory="no">	
		</cfloop>
	<cfelse>
			<cf_dbtempcol name="TGA"	  					type="money"		 mandatory="no">	
			<cf_dbtempcol name="TGD"	  					type="money"		 mandatory="no">	
	</cfif>
</cf_dbtemp>
<cfset ofis = "">
<cfif isdefined('form.chkColGO')>
	<cfset lvarGruposO = StructNew()>
	<cfloop query="rsGO">
		<cfquery name="rsOficinas" datasource="#session.DSN#">
			select Ocodigo from AnexoGOficinaDet where GOid = #rsGO.GOid#
			union all
			select -1 as Ocodigo from dual
		</cfquery>
		<cfset lvarGruposO[trim(rsGO.GOcodigo)] = valueList(rsOficinas.Ocodigo)>
	</cfloop>
</cfif>


<cfquery datasource="#session.DSN#">
	insert into #Cuentas#
		(	
					CPcuenta
					,Ecodigo
					,CPformato
					,CPdescripcion
					,nivel
					,tipo
			<cfif isdefined('form.chkColGO')>
				<cfloop query="rsGO">
					,TA#trim(rsGO.GOcodigo)#, TD#trim(rsGO.GOcodigo)#
				</cfloop>
			<cfelse>
					,TGA, TGD
			</cfif>
		)
	select cp.CPcuenta
			,cp.Ecodigo
			,cp.CPformato
			,cp.CPdescripcion
			,cu.PCDCniv
			,cm.Ctipo
			<cfif isdefined('form.chkColGO')>
				<cfloop query="rsGO">
					,   sum(case when dd.CPDDtipo = 1 and dd.Ocodigo in (#lvarGruposO[trim(rsGO.GOcodigo)]#)
							then CPDDmonto 
							else 0 
						end) #suf#
					, - sum(case when dd.CPDDtipo = -1 and dd.Ocodigo in (#lvarGruposO[trim(rsGO.GOcodigo)]#) 
							then CPDDmonto 
							else 0 
						end) #suf#
				</cfloop>
			<cfelse>
					,   sum(case when dd.CPDDtipo = 1
							then CPDDmonto 
							else 0 
						end) #suf#
					, - sum(case when dd.CPDDtipo = -1
							then CPDDmonto 
							else 0 
						end) #suf#
			</cfif>

	from #CPresupuesto# tp
	
		inner join PCDCatalogoCuentaP cu 
		   	on cu.CPcuenta = tp.CPcuenta
			
		inner join CPDocumentoD dd
			on dd.CPcuenta = cu.CPcuenta
		
		inner join CPDocumentoE de
			on dd.CPDEid = de.CPDEid

		inner join CPresupuesto cp
		  	on cp.CPcuenta = cu.CPcuentaniv

		inner join CtasMayor cm
			on cm.Ecodigo = cp.Ecodigo and cm.Cmayor  = cp.Cmayor
		   
		where cm.Ecodigo  = #session.Ecodigo#
		<cfif form.nivelDetalle neq -1>
		  and cu.PCDCniv <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.nivelDetalle#">
		</cfif>
		  and de.CPDAEid = #form.CPDAEid#
		  and de.CPDEtipoDocumento = 'E'
		  #preservesinglequotes(estado)# 
		  #preservesinglequotes(FiltroOficinas)#
	group by cp.CPcuenta,cp.Ecodigo,cp.CPformato,cp.CPdescripcion,cu.PCDCniv, cm.Ctipo
</cfquery>
<cfquery name="Datos" datasource="#session.DSN#">
	select CPcuenta, Ecodigo, CPformato, CPdescripcion, nivel, tipo
	<cfif isdefined('form.chkColGO')>
		<cfloop query="rsGO">
			,TA#trim(rsGO.GOcodigo)#,TD#trim(rsGO.GOcodigo)#,  (TA#trim(rsGO.GOcodigo)# + TD#trim(rsGO.GOcodigo)#) as TG#trim(rsGO.GOcodigo)#
		</cfloop>
		<cfif rsGO.recordcount gt 0>
			,(<cfloop query="rsGO">
				TA#trim(rsGO.GOcodigo)#
				<cfif rsGO.recordcount neq rsGO.currentrow>
					+
				</cfif>
			</cfloop>
			) as TGA
			,(<cfloop query="rsGO">
				TD#trim(rsGO.GOcodigo)#
				<cfif rsGO.recordcount neq rsGO.currentrow>
					+
				</cfif>
			</cfloop>
			) as TGD
			,(<cfloop query="rsGO">
				TA#trim(rsGO.GOcodigo)# + TD#trim(rsGO.GOcodigo)#
				<cfif rsGO.recordcount neq rsGO.currentrow>
					+
				</cfif>
			</cfloop>
			) as TG
		</cfif>
		<cfset lvarColspan = (rsGO.recordcount * 3) + 3>
	<cfelse>
			,TGA, TGD, (TGA + TGD) as TG
		<cfset lvarColspan = 3>
	</cfif> 
	from #Cuentas# 
	order by tipo,CPformato
</cfquery>
<cfquery name="rsEmpresa" datasource="#Session.DSN#">
	select Edescripcion 
	from Empresas
	where Ecodigo = #Session.Ecodigo#
</cfquery>
<!---===========Docs Traslados===============--->
<cfquery name="rsDocTrasSel" datasource="#Session.DSN#">
	select CPDAEid, CPDAEcodigo, CPDAEdescripcion
	from CPDocumentoAE
	where Ecodigo = #Session.Ecodigo# and CPDAEid = #form.CPDAEid#
</cfquery>
<cfquery name="Totales" datasource="#session.dsn#">
	select 
	<cfif isdefined('form.chkColGO')>
		<cfif rsGO.recordcount gt 0>
			sum(<cfloop query="rsGO">
				TA#trim(rsGO.GOcodigo)#
				<cfif rsGO.recordcount neq rsGO.currentrow>
					+
				</cfif>
			</cfloop>
			) as TGA
			,sum(<cfloop query="rsGO">
				TD#trim(rsGO.GOcodigo)#
				<cfif rsGO.recordcount neq rsGO.currentrow>
					+
				</cfif>
			</cfloop>
			) as TGD
			,sum(<cfloop query="rsGO">
				TA#trim(rsGO.GOcodigo)# + TD#trim(rsGO.GOcodigo)#
				<cfif rsGO.recordcount neq rsGO.currentrow>
					+
				</cfif>
			</cfloop>
			) as TG
		</cfif>
		<cfloop query="rsGO">
			,sum(TA#trim(rsGO.GOcodigo)#) as TA#trim(rsGO.GOcodigo)#, sum(TD#trim(rsGO.GOcodigo)#) as TD#trim(rsGO.GOcodigo)#, sum(TA#trim(rsGO.GOcodigo)# + TD#trim(rsGO.GOcodigo)#) as TG#trim(rsGO.GOcodigo)#
		</cfloop>
	<cfelse>
			sum(TGA) as TGA, sum(TGD) as TGD, sum(TGA + TGD) as TG
	</cfif> 
	from #Cuentas#
		where nivel = 0
</cfquery>
<cfoutput>
<table width="100%"  border="0" cellspacing="1" cellpadding="1">
	<tr>
		<td colspan="<cfoutput>#3 + lvarColspan#</cfoutput>" align="center"><strong><font size="4"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></font></strong></td>
	</tr>
	<tr>
		<td colspan="<cfoutput>#3 + lvarColspan#</cfoutput>" align="center"><font size="3"><strong>Grupo de Doc. Traslado Externo:</strong><cfoutput>#rsDocTrasSel.CPDAEcodigo#-#rsDocTrasSel.CPDAEdescripcion#</cfoutput></font></td>
	</tr>
	<tr>
		<td colspan="<cfoutput>#3 + lvarColspan#</cfoutput>" align="center"><font size="3"><cfoutput>#msgEstado#</cfoutput></font></td>
	</tr>
	<tr>
		<td colspan="<cfoutput>#3 + lvarColspan#</cfoutput>" align="center"><font size="3"><strong><cfoutput>#FormatoCurrent#</cfoutput></strong></font></td>
	</tr>
	
	<cfswitch expression="#form.ID_REPORTE#">
		<cfcase value="1"><!---2 - CP x RANGO            --->
			<tr>
				<td colspan="<cfoutput>#3 + lvarColspan#</cfoutput>" align="center"><strong>Cuenta:</strong>&nbsp;<cfoutput>#form.CPformato#</cfoutput></td>
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
				<td colspan="<cfoutput>#3 + lvarColspan#</cfoutput>" align="center"><strong>Cuenta Inicial:</strong>&nbsp;<cfoutput>#FormatoDesde#</cfoutput>&nbsp;<strong>&nbsp;Cuenta Final:</strong>&nbsp;<cfoutput>#FormatoHasta#</cfoutput></td>
			</tr>
		</cfcase>
		<cfcase value="3"><!---3 - CP x LISTA DE CUENTAS --->
			<cfset LarrCuentas  = ListToarray(cuentaidlist)>
			<tr>
				<td colspan="<cfoutput>#3 + lvarColspan#</cfoutput>" align="center"><strong>Lista de cuentas:</strong></td>
			</tr>
			<tr>
				<td colspan="<cfoutput>#3 + lvarColspan#</cfoutput>" align="center">
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
		<td colspan="<cfoutput>#3 + lvarColspan#</cfoutput>" align="center"><strong>Nivel de cuenta utilizado:</strong>&nbsp; <cfoutput><cfif form.nivelDetalle neq -1>#form.nivelDetalle#<cfelse>Último Nivel</cfif></cfoutput></td>
	</tr>
	<tr>
		<td colspan="<cfoutput>#3 + lvarColspan#</cfoutput>" align="center"><cfoutput>#Agrupador# <cfif not isdefined('form.chkColGO') and not esOficina>(NO VISUALIZADO EN COLUMNAS)</cfif></cfoutput></td>
	</tr>
	<tr>
		<td><strong>Usuario:</strong>&nbsp;<cfoutput>#Session.Usuario#</cfoutput></td>
		<td>&nbsp;</td>
		<td colspan="<cfoutput>#1 + lvarColspan#</cfoutput>" nowrap><strong>Fecha:</strong>&nbsp;<cfoutput>#DateFormat(Now(),'DD/MM/YYYY')# #TimeFormat(Now(),'medium')#</cfoutput></td>
	</tr>
	<tr><td colspan="<cfoutput>#3 + lvarColspan#</cfoutput>">&nbsp;</td></tr>
	<tr bgcolor="##0099CC" >
		<td nowrap align="center"><font color="##FFFFFF"><strong>Cuenta Presupuesto</strong></font></td>
		<td nowrap align="center"><strong><font color="##FFFFFF">Descripción</font></strong></td>
		<td nowrap colspan="3" align="center"><strong><font color="##FFFFFF">Resumen</font></strong></td>
		<cfif isdefined('form.chkColGO')>
			<cfloop query="rsGO">
				<td nowrap colspan="3" align="center"><strong><font color="##FFFFFF">#rsGO.GOcodigo#-#rsGO.GOnombre#</font></strong></td>
			</cfloop>
		</cfif>
	</tr>
	<tr bgcolor="##0099CC" >
		<td colspan="2"></td>
		<td nowrap align="center"><strong><font color="##FFFFFF">AUMENTO</font></strong></td>
		<td nowrap align="center"><strong><font color="##FFFFFF">DISMINUCION</font></strong></td>
		<td nowrap align="center"><strong><font color="##FFFFFF">TOTAL EFECTO NETO</font></strong></td>
		<cfif isdefined('form.chkColGO')>
			<cfloop query="rsGO">
				<td nowrap align="center"><strong><font color="##FFFFFF">AUMENTO</font></strong></td>
				<td nowrap align="center"><strong><font color="##FFFFFF">DISMINUCION</font></strong></td>
				<td nowrap align="center"><strong><font color="##FFFFFF">TOTAL EFECTO NETO</font></strong></td>
			</cfloop>
		</cfif>
	</tr>
	<cfset Lvarcontador = 0>
	<cfloop query="Datos">
		<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>">
			<td nowrap>#Datos.CPformato#</td>
			<td nowrap>#Datos.CPdescripcion#</td>
			<td align="right" nowrap>#numberFormat(Datos.TGA,',9.00')#</td>
			<td align="right" nowrap>#numberFormat(Datos.TGD,',9.00')#</td>
			<td align="right" nowrap>#numberFormat(Datos.TG,',9.00')#</td>
			<cfif isdefined('form.chkColGO')>
				<cfloop query="rsGO">
					<td align="right" nowrap>#numberFormat(evaluate('Datos.TA' & rsGO.GOcodigo),',9.00')#</td>
					<td align="right" nowrap>#numberFormat(evaluate('Datos.TD' & rsGO.GOcodigo),',9.00')#</td>
					<td align="right" nowrap>#numberFormat(evaluate('Datos.TG' & rsGO.GOcodigo),',9.00')#</td>
				</cfloop>
			</cfif>
		</tr>
		<cfset Lvarcontador += 1>
	</cfloop>
	<cfif Datos.recordcount eq 0>
		<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>"><td colspan="5">&nbsp;</td></tr>
		<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>">
			<td colspan="#3 + lvarColspan#" align="center"><strong>No existen lineas de detalle que corresponda con los filtros ingresados.</strong></td>
		</tr>
		<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>"><td colspan="#3 + lvarColspan#">&nbsp;</td></tr>
	<cfelse>
		<tr><td colspan="#3 + lvarColspan#" align="center">&nbsp;</td></tr>
		<tr>
			<td colspan="2" nowrap><strong>TOTAL GENERAL</strong></td>
			<td align="right" nowrap>#numberFormat(Totales.TGA,',9.00')#</td>
			<td align="right" nowrap>#numberFormat(Totales.TGD,',9.00')#</td>
			<td align="right" nowrap>#numberFormat(Totales.TG,',9.00')#</td>
			<cfif isdefined('form.chkColGO')>
				<cfloop query="rsGO">
					<td align="right" nowrap>#numberFormat(evaluate('Totales.TA' & rsGO.GOcodigo),',9.00')#</td>
					<td align="right" nowrap>#numberFormat(evaluate('Totales.TD' & rsGO.GOcodigo),',9.00')#</td>
					<td align="right" nowrap>#numberFormat(evaluate('Totales.TG' & rsGO.GOcodigo),',9.00')#</td>
				</cfloop>
			</cfif>
		</tr>
	</cfif>
	<tr>
		<td colspan="#3 + lvarColspan#" align="center">---------- FIN DEL REPORTE ----------</td>
	</tr>
	<tr>
		<td colspan="#3 + lvarColspan#" align="center">&nbsp;</td>
	</tr>
</table>
</cfoutput>