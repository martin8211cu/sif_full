<cfswitch expression="#form.ID_REPORTE#">
	<!---Filtro por una sola cuenta--->
	<cfcase value="1">
		<cfset FiltroCuentas = "and rtrim(cp.CPformato) like '#trim(form.CPformato)##chr(127)#'">
	</cfcase>
	<!---Filtro para un Rango de cuentas--->
	<cfcase value="2">
		<cfset ArregloCuentas = ListToArray(form.cuentaidlist,',')>
		<cfif ArregloCuentas[2] EQ "">
			<cfset ArregloCuentas[2] = ArregloCuentas[1]>
		</cfif>
		<cfset FiltroCuentas = "and rtrim(cp.CPformato) between '#ArregloCuentas[1]#' and '#trim(ArregloCuentas[2])#'">
	</cfcase>
	<!---Filtro para un listado de Cuentas--->
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
		<!---Filtro para un listado de Oficinas--->
		<cfif isdefined('form.list') and len(trim('form.list'))>
			<cfquery datasource="#session.dsn#" name="rsOficinas">
				select Ocodigo, Oficodigo, Odescripcion 
					from Oficinas 
				where Ocodigo in (#form.list#)
				  and Ecodigo = #session.Ecodigo#
			</cfquery>
			<cfset Agrupador 	  = 'Oficinas: '& ValueList(rsOficinas.Odescripcion)>
			<cfset FiltroOficinas = " and cpc.Ocodigo in (#form.list#)">
		<cfelse>
		<!---Filtro para un una Oficina--->
			<cfquery datasource="#session.dsn#" name="rsOficinas">
				select Oficodigo, Odescripcion 
					from Oficinas 
				where Ocodigo = #arrayOfi[2]#
				  and Ecodigo = #session.Ecodigo#
			</cfquery>
			<cfif rsOficinas.Recordcount EQ 0>
				<cfthrow message="La Oficina especificada en los Filtros de Entrada no existe.">
			</cfif>
			<cfset Agrupador 	  = 'Oficina:'&rsOficinas.Oficodigo&'-'&rsOficinas.Odescripcion>
			<cfset FiltroOficinas = " and cpc.Ocodigo = #arrayOfi[2]#">
		</cfif>
	</cfcase>
	<cfcase value="go">
		<cfif isdefined('form.list') and len(trim('form.list'))>
			<cfquery name="rsGO" datasource="#session.DSN#">
				select GO.GOid, GO.GOcodigo, GO.GOnombre, (select count(1) from AnexoGOficina where Ecodigo = GO.Ecodigo and GOcodigo = GO.GOcodigo) cantidad
					from AnexoGOficina GO
				where GO.GOid in (#form.list#)
				  and GO.Ecodigo = #session.Ecodigo#
				 order by GO.GOcodigo
			</cfquery>
			<cfloop query="rsGO">
				<cfif rsGO.cantidad GT 1>
					<cfthrow message="Existe en la empresa #rsGO.cantidad# Catalogos de Oficinas con el mismo codigo ('#trim(rsGO.GOcodigo)#')">
				</cfif>
			</cfloop>
			<cfquery name="rsGODet" datasource="#session.DSN#">
				select Ocodigo from AnexoGOficinaDet where GOid in (#form.list#)
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
		<cfset Agrupador 	  = "Grupo de Oficinas: "& ValueList(rsGO.GOnombre)>
		<cfset FiltroOficinas = "and cpc.Ocodigo in (#ValueList(rsGODet.Ocodigo)#)">
	</cfcase>		
</cfswitch>

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

<cf_dbtemp name="SysTecRpt3_V1" returnvariable="CPresupuesto">
	<cf_dbtempcol name="CPcuenta"      type="numeric" 		mandatory="yes">	
	<cf_dbtempcol name="CVPcuenta"     type="numeric" 		mandatory="yes">			
	<cf_dbtempcol name="Ecodigo"       type="int" 			mandatory="yes">
	<cf_dbtempcol name="CPformato"     type="varchar(100)" 	mandatory="yes">
	<cf_dbtempcol name="tipo"	       type="char(1)"		mandatory="yes">	
</cf_dbtemp>
<cfquery datasource="#session.DSN#">
	insert into #CPresupuesto#
		(	
			CPcuenta,
			CVPcuenta,
			Ecodigo,
			CPformato,
			tipo
		)
	select distinct
			cp.CPcuenta,
			cp.CVPcuenta,
			cp.Ecodigo,
			cp.CPformato,
			cm.Ctipo
	from CVPresupuesto cp
		inner join CtasMayor cm
		  on cm.Ecodigo = cp.Ecodigo
		 and cm.Cmayor  = cp.Cmayor
		where cp.Ecodigo  = #session.Ecodigo#
		 #preservesinglequotes(FiltroCuentas)#
		 and cp.CVid = #form.CVid#
		 and (
			   	select count(1)
					 from CVFormulacionTotales f
				where f.Ecodigo   = cp.Ecodigo
				  and f.CVid 	  = cp.CVid
				  and f.CVPcuenta = cp.CVPcuenta
			) > 0
</cfquery>

<cf_dbtemp name="tempCtsaplirec_V1" returnvariable="Cuentas">
			<cf_dbtempcol name="CPcuenta"  				    	type="numeric" 	     mandatory="yes">			
			<cf_dbtempcol name="Ecodigo"  				    	type="int" 		     mandatory="yes">
			<cf_dbtempcol name="CPformato" 				    	type="varchar(100)"  mandatory="yes">
			<cf_dbtempcol name="nivel"    				    	type="int"		     mandatory="yes"> 
			<cf_dbtempcol name="tipo"	  				    	type="char(1)"	     mandatory="yes">
			<cf_dbtempcol name="CPdescripcion"              	type="varchar(80)" 	 mandatory="yes">
			<cf_dbtempcol name="ResumenA"	  					type="money"		 mandatory="no">
			<cf_dbtempcol name="ResumenD"	  					type="money"		 mandatory="no">
			<cf_dbtempcol name="ResumenN"	  					type="money"		 mandatory="no">
	<cfif isdefined('rsGO')>
		<cfloop query="rsGO">
			<cf_dbtempcol name="GO#rsGO.CurrentRow#A"	    	type="money"		 mandatory="no">
			<cf_dbtempcol name="GO#rsGO.CurrentRow#D"	    	type="money"		 mandatory="no">
			<cf_dbtempcol name="GO#rsGO.CurrentRow#N"	    	type="money"		 mandatory="no">	
		</cfloop>
	</cfif>
	<cfif isdefined('rsOficinas')>
		<cfloop query="rsOficinas">
			<cf_dbtempcol name="Ofi#rsOficinas.CurrentRow#A"	type="money"		 mandatory="no">
			<cf_dbtempcol name="Ofi#rsOficinas.CurrentRow#D"	type="money"		 mandatory="no">	
			<cf_dbtempcol name="Ofi#rsOficinas.CurrentRow#N"	type="money"		 mandatory="no">		
		</cfloop>
	</cfif>
</cf_dbtemp>
<cfset ofis = "">
<cfif isdefined('rsGO')>
	<cfloop query="rsGO">
		<cfquery name="rsGODet" datasource="#session.DSN#">
			select Ocodigo from AnexoGOficinaDet where GOid = #rsGO.GOid#
			union all
			select -1 as Ocodigo from dual
		</cfquery>
		<cfset ofis &= ValueList(rsGODet.Ocodigo)>
		<cfif rsGO.currentrow NEQ rsGO.recordcount>
			<cfset ofis &= '|'>
		</cfif>
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
					,ResumenA
					,ResumenD
					,ResumenN
			<cfif isdefined('rsGO')>
				<cfloop query="rsGO">
					,GO#rsGO.CurrentRow#A
					,GO#rsGO.CurrentRow#D
					,GO#rsGO.CurrentRow#N
				</cfloop>
			</cfif>
			<cfif isdefined('rsOficinas')>
				<cfloop query="rsOficinas">
					,Ofi#rsOficinas.CurrentRow#A
					,Ofi#rsOficinas.CurrentRow#D
					,Ofi#rsOficinas.CurrentRow#N
				</cfloop>
			</cfif>
		)
	select 
			cp.CPcuenta
			,cp.Ecodigo
			,cp.CPformato
			,cp.CPdescripcion
			,cu.PCDCniv
			,cm.Ctipo
			,sum(case when cpc.CVFTmontoAplicar > 0 then cpc.CVFTmontoAplicar #suf# else 0 end)
			,sum(case when cpc.CVFTmontoAplicar < 0 then cpc.CVFTmontoAplicar #suf# else 0 end)
			,sum(cpc.CVFTmontoAplicar #suf#)

			<cfif isdefined('rsGO')>
				<cfloop query="rsGO">
					,sum(case when cpc.Ocodigo in (#ListGetAt(ofis,rsGO.currentRow,"|")#) and cpc.CVFTmontoAplicar > 0 then cpc.CVFTmontoAplicar #suf# else 0 end)
					,sum(case when cpc.Ocodigo in (#ListGetAt(ofis,rsGO.currentRow,"|")#) and cpc.CVFTmontoAplicar < 0 then cpc.CVFTmontoAplicar #suf# else 0 end)
					,sum(case when cpc.Ocodigo in (#ListGetAt(ofis,rsGO.currentRow,"|")#) then cpc.CVFTmontoAplicar #suf# else 0 end)
				</cfloop>
			</cfif>
			<cfif isdefined('rsOficinas')>
				<cfloop query="rsOficinas">
					,sum(case when cpc.Ocodigo = #rsOficinas.Ocodigo# and cpc.CVFTmontoAplicar > 0 then cpc.CVFTmontoAplicar #suf# else 0 end)
					,sum(case when cpc.Ocodigo = #rsOficinas.Ocodigo# and cpc.CVFTmontoAplicar < 0 then cpc.CVFTmontoAplicar #suf# else 0 end)
					,sum(case when cpc.Ocodigo = #rsOficinas.Ocodigo# then cpc.CVFTmontoAplicar #suf# else 0 end)
				</cfloop>
			</cfif>

	from #CPresupuesto# tp
		inner join PCDCatalogoCuentaP cu 
		   on cu.CPcuenta = tp.CPcuenta

		inner join CPresupuesto cp
		  on cp.CPcuenta = cu.CPcuentaniv

		inner join CtasMayor cm
		  on cm.Ecodigo = cp.Ecodigo
		 and cm.Cmayor  = cp.Cmayor
		   inner join CVFormulacionTotales cpc
				 on cpc.Ecodigo   = cm.Ecodigo
				and cpc.CVid 	  = #form.CVid#
				and cpc.CVPcuenta = tp.CVPcuenta
				#preservesinglequotes(FiltroOficinas)#
		   
		where cm.Ecodigo  = #session.Ecodigo#
		  and cu.PCDCniv <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.nivelDet#">
	group by cp.CPcuenta,cp.Ecodigo,cp.CPformato,cp.CPdescripcion,cu.PCDCniv, cm.Ctipo
</cfquery>
<cfquery name="Datos" datasource="#session.DSN#">
	select *
		from #Cuentas# order by tipo,CPformato
</cfquery>