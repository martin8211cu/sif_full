<cfswitch expression="#form.ID_REPORTE#">
	<cfcase value="1">
    	<cfset ArregloCuentas = ListToArray(form.CPformato,',')>
		<cfset FiltroCuentas = "and rtrim(cp.CPformato) like '#trim(form.CPformato)#'">
        <cfset TipoReporte = "Cuenta presupuestal">
	</cfcase>
	<cfcase value="2">
		<cfset ArregloCuentas = ListToArray(form.cuentaidlist,',')>
		<cfif ArregloCuentas[2] EQ "">
			<cfset ArregloCuentas[2] = ArregloCuentas[1]>
		</cfif>
		<cfset FiltroCuentas = "and rtrim(cp.CPformato) between '#ArregloCuentas[1]#' and '#trim(ArregloCuentas[2])#'">
        <cfset TipoReporte = "Rango de cuentas presupuestales">
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
            <cfset TipoReporte = "Lista de cuentas presupuestales">
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
		<cfset Agrupador 	  = 'Oficina:'&rsOficinas.Oficodigo&'-'&rsOficinas.Odescripcion>
		<cfset FiltroOficinas = " and cpc.Ocodigo = #arrayOfi[2]#">
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
		<cfset Agrupador 	  = "Grupo de Oficinas: #ValueList(rsGO.GOnombre)#">
		<cfset FiltroOficinas = "and cpc.Ocodigo in (#ValueList(rsGODet.Ocodigo)#)">
	</cfcase>		
</cfswitch>
<!---=========Catalogo Columnar================--->
<cfquery name="rsCatColumn" datasource="#Session.DSN#">
	select PCEcatid,PCEcodigo,PCEdescripcion 
		from PCECatalogo 
	where PCEcatid = #form.PCEcatid#
      and CEcodigo = #session.CEcodigo# 
</cfquery>
<cfparam name="LvarPCECatalogo" default="Catalogo Columnar: #rsCatColumn.PCEcodigo#-#rsCatColumn.PCEdescripcion#">

<cfquery datasource="#session.dsn#" name="rsPCDCatalogo">
	select pcd.PCDcatid,pcd.PCEcatid,pcd.PCDvalor,pcd.PCDdescripcion, (select count(1) from PCDCatalogo where PCEcatid = pcd.PCEcatid and  PCDvalor = pcd.PCDvalor and (Ecodigo is null OR Ecodigo = #session.Ecodigo#)) cantidad 
		from PCDCatalogo pcd
	where PCEcatid = #form.PCEcatid#
      and (Ecodigo is null OR Ecodigo = #session.Ecodigo#)
	order by pcd.PCDdescripcion
</cfquery>
<cfloop query="rsPCDCatalogo">
	<cfif rsPCDCatalogo.cantidad GT 1>
		<cfthrow message="Error en el Catalogo #rsPCDCatalogo.PCDdescripcion# tienen valores repetidos (#rsPCDCatalogo.PCDvalor#)">
	</cfif>
</cfloop>
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

<cf_dbtemp name="tempCts_V1" returnvariable="CPresupuesto">
	<cf_dbtempcol name="CPcuenta"      type="numeric" 		mandatory="yes">			
	<cf_dbtempcol name="Ecodigo"       type="int" 			mandatory="yes">
	<cf_dbtempcol name="CPformato"     type="varchar(100)" 	mandatory="yes">
	<cf_dbtempcol name="tipo"	       type="char(1)"		mandatory="yes">
	<cf_dbtempcol name="fuente"        type="numeric" 		mandatory="no">			
</cf_dbtemp>
<cfquery datasource="#session.DSN#">
	insert into #CPresupuesto#
		(	
			CPcuenta,
			Ecodigo,
			CPformato,
			tipo,
			fuente
		)
	select distinct
			cp.CPcuenta,
			cp.Ecodigo,
			cp.CPformato,
		
			cm.Ctipo,
			(select coalesce(min(PCDcatid),-1) from PCDCatalogoCuentaP where CPcuenta = cp.CPcuenta and PCEcatid = #form.PCEcatid#)
	from CPresupuesto cp
		inner join CtasMayor cm
		  on cm.Ecodigo = cp.Ecodigo
		 and cm.Cmayor  = cp.Cmayor
		where cp.Ecodigo  = #session.Ecodigo#
		 #preservesinglequotes(FiltroCuentas)#
		 and cp.CPmovimiento = 'S'
</cfquery>

<cf_dbtemp name="tempCtsaplirec_V1" returnvariable="Cuentas">
			<cf_dbtempcol name="CPcuenta"  				    type="numeric" 	     mandatory="yes">			
			<cf_dbtempcol name="Ecodigo"  				    type="int" 		     mandatory="yes">
			<cf_dbtempcol name="CPformato" 				    type="varchar(100)"  mandatory="yes">
			<cf_dbtempcol name="nivel"    				    type="int"		     mandatory="yes"> 
			<cf_dbtempcol name="tipo"	  				    type="char(1)"	     mandatory="yes">
			<cf_dbtempcol name="CPdescripcion"              type="varchar(80)" 	 mandatory="yes">
			<cf_dbtempcol name="TOTAL"	  				    type="money"		 mandatory="no">
			<cf_dbtempcol name="OTROS"	  				    type="money"		 mandatory="no">
	<cfif isdefined('form.chkColGO')>
		<cfloop query="rsGO">
			<cf_dbtempcol name="GO#rsGO.CurrentRow#"	  		type="money"		 mandatory="no">	
		</cfloop>
	</cfif>
	<cfloop query="rsPCDCatalogo">
			<cf_dbtempcol name="MT#rsPCDCatalogo.PCDvalor#" type="money"		 mandatory="no">	
	</cfloop>
</cf_dbtemp>
<cfset ofis = "">
<cfif isdefined('form.chkColGO')>
	<cfloop query="rsGO">
		<cfquery name="rsOficinas" datasource="#session.DSN#">
			select Ocodigo from AnexoGOficinaDet where GOid = #rsGO.GOid#
			union all
			select -1 as Ocodigo from dual
		</cfquery>
		<cfset ofis &= ValueList(rsOficinas.Ocodigo)>
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
					,TOTAL
					,OTROS
			<cfif isdefined('form.chkColGO')>
				<cfloop query="rsGO">
					,GO#rsGO.CurrentRow#
				</cfloop>
			</cfif>
			<cfloop query="rsPCDCatalogo">
					,MT#rsPCDCatalogo.PCDvalor#
			</cfloop>
		)
	select 
			cp.CPcuenta
			,cp.Ecodigo
			,cp.CPformato
			,cp.CPdescripcion
			,cu.PCDCniv
			,cm.Ctipo
			,sum(cpc.CPCejecutado + cpc.CPCejecutadoNC) #suf#
			,sum(case when fuente not in (#ValueList(rsPCDCatalogo.PCDcatid)#) then (cpc.CPCejecutado + cpc.CPCejecutadoNC) #suf# else 0 end)
			<cfif isdefined('form.chkColGO')>
				<cfloop query="rsGO">
					,sum(case when cpc.Ocodigo in (#ListGetAt(ofis,rsGO.currentRow,"|")#) then (cpc.CPCejecutado + cpc.CPCejecutadoNC) #suf# else 0 end)
				</cfloop>
			</cfif>
			<cfloop query="rsPCDCatalogo">
			,sum(case when fuente=#rsPCDCatalogo.PCDcatid# then (cpc.CPCejecutado + cpc.CPCejecutadoNC) #suf# else 0 end)
			</cfloop>
			
			
	from #CPresupuesto# tp
		inner join PCDCatalogoCuentaP cu 
		   on cu.CPcuenta = tp.CPcuenta

		inner join CPresupuesto cp
		  on cp.CPcuenta = cu.CPcuentaniv

		inner join CtasMayor cm
		  on cm.Ecodigo = cp.Ecodigo
		 and cm.Cmayor  = cp.Cmayor
		   inner join CPresupuestoControl cpc
				 on cpc.Ecodigo  = cm.Ecodigo
				and cpc.CPPid	 = #form.CPPid#
				and cpc.CPcuenta = cu.CPcuenta
				#preservesinglequotes(FiltroOficinas)#
		   
		where cm.Ecodigo  = #session.Ecodigo#
		  and cu.PCDCniv <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.nivelDet#">
	group by cp.CPcuenta,cp.Ecodigo,cp.CPformato,cp.CPdescripcion,cu.PCDCniv, cm.Ctipo
</cfquery>
<cfquery name="Datos" datasource="#session.DSN#">
	select *
		from #Cuentas# order by tipo,CPformato
</cfquery>