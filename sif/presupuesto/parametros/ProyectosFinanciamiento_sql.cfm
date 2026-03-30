<cfset modo = "ALTA">
<cfif isdefined("form.CPPFid") and form.CPPFid NEQ "">
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select count(1) as cantidad from CPproyectosFinanciadosCFs where CPPFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPFid#">
	</cfquery>
	<cfif rsSQL.cantidad GT 0>
		<cfset Form.CPPFporCF="1">
	<cfelse>
		<cfparam name="Form.CPPFporCF" default="0">
	</cfif>
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select count(1) as cantidad from CPproyectosFinanciados where CPPFid_padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPFid#">
	</cfquery>
	<cfif rsSQL.cantidad GT 0>
		<cfset Form.CPPFconSubproyectos="1">
	<cfelse>
		<cfparam name="Form.CPPFconSubproyectos" default="0">
	</cfif>
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select CPPFid_padre from CPproyectosFinanciados where CPPFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPFid#">
	</cfquery>
	<cfif rsSQL.CPPFid_padre EQ "">
		<cfset form.CPPFconFinanciamiento = 1>
	<cfelse>
		<cfparam name="form.CPPFconFinanciamiento" default="0">
	</cfif>
</cfif>

<cfif isdefined("Form.Nuevo")>
	<cflocation url="ProyectosFinanciamiento.cfm?Nuevo&btnNuevo">
<cfelse>
	<cfif isdefined("Form.Alta")>
		<cfparam name="Form.CPPFporCF" default="0">
		<cfparam name="Form.CPPFconSubproyectos" default="0">
		<cfparam name="form.CPPFconFinanciamiento" default="0">
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into CPproyectosFinanciados(Ecodigo, CPPFcodigo, CPPFdescripcion, CPPFporCF, CPPFconSubproyectos, CPPFconFinanciamiento) 
			values ( <cfqueryparam cfsqltype="cf_sql_integer"	value="#session.ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char"		value="#Form.CPPFcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Form.CPPFdescripcion#">,
					 <cfqueryparam cfsqltype="cf_sql_bit"		value="#Form.CPPFporCF#">,
					 <cfqueryparam cfsqltype="cf_sql_bit"		value="#Form.CPPFconSubproyectos#">,
					 1
				   )
		</cfquery>		   
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="rsDatos" datasource="#Session.DSN#">
			select count(1) as cantidad 
			  from CPproyectosFinanciadosCtas
			where Ecodigo  = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
			  and CPPFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPFid#">
		</cfquery>
		<cfif rsDatos.cantidad gt 0>	
			<cfthrow message="No se puede eliminar el registro ya que tiene Cuentas definidas">
		</cfif>	

		<cftransaction>
			<cfquery name="delete" datasource="#session.DSN#">
				delete from CPproyectosFinanciadosCFs
				 where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
				   and  CPPFid = <cfqueryparam value="#form.CPPFid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfquery name="delete" datasource="#session.DSN#">
				delete from CPproyectosFinanciados
				 where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
				   and  CPPFid = <cfqueryparam value="#form.CPPFid#" cfsqltype="cf_sql_numeric">
			</cfquery>
		</cftransaction>
		<cfset modo="BAJA">

	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="update" datasource="#Session.DSN#">
			update CPproyectosFinanciados
			   set
				   CPPFcodigo			= <cfqueryparam value="#Form.CPPFcodigo#" 			cfsqltype="cf_sql_char">,
				   CPPFdescripcion		= <cfqueryparam value="#Form.CPPFdescripcion#" 		cfsqltype="cf_sql_varchar">,
				   CPPFporCF			= <cfqueryparam value="#Form.CPPFporCF#" 			cfsqltype="cf_sql_bit">,
				   CPPFconSubproyectos	= <cfqueryparam value="#Form.CPPFconSubproyectos#" 	cfsqltype="cf_sql_bit">,
				   CPPFconFinanciamiento = case when CPPFid_padre is null then 1 else <cfqueryparam value="#Form.CPPFconFinanciamiento#" 	cfsqltype="cf_sql_bit"> end
			 where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
			   and  CPPFid = <cfqueryparam value="#form.CPPFid#" cfsqltype="cf_sql_numeric">
		</cfquery> 
		<cfset modo="CAMBIO">
		<cflocation url="ProyectosFinanciamiento.cfm?CPPFid=#form.CPPFid#">

	<cfelseif isdefined("url.btnVerificar")>
		<cfquery name="rsSQL1" datasource="#Session.DSN#">
			select distinct CPformato as Cuenta_Presupuesto, CPPFcodigo as Proyecto
			  from CPproyectosFinanciadosCtas pc1
			  	inner join CPproyectosFinanciados pr1
					 on pr1.CPPFid = pc1.CPPFid
			  	inner join CPresupuesto cp1 
					 on cp1.Ecodigo	= pc1.Ecodigo
				    and cp1.CPmovimiento = 'S'
					and <cf_dbfunction name="like" args="cp1.CPformato like pc1.CPPFCmascara">
			 where pc1.Ecodigo	= #session.Ecodigo#
			   and pc1.CPPid		= #session.CPPid#
			   and (
						select count(1)
						  from CPproyectosFinanciadosCtas s1
							inner join CPproyectosFinanciados s2
								on s2.CPPFid = s1.CPPFid
						 where s1.Ecodigo		= pc1.Ecodigo
						   and s1.CPPid			= pc1.CPPid
						   and s2.CPPFid_padre 	= pc1.CPPFid
						   and <cf_dbfunction name="like" args="cp1.CPformato like CPPFCmascara">
					) = 0
			   and (
			   		select count(1)
					  from CPproyectosFinanciadosCtas pc
						inner join CPresupuesto cp 
							 on cp.Ecodigo	= pc.Ecodigo
							and cp.CPmovimiento = 'S'
							and <cf_dbfunction name="like" args="cp.CPformato like pc.CPPFCmascara">
					 where pc.Ecodigo	= #session.Ecodigo#
					   and pc.CPPid		= #session.CPPid#
					   and (
								select count(1)
								  from CPproyectosFinanciadosCtas s1
									inner join CPproyectosFinanciados s2
										on s2.CPPFid = s1.CPPFid
								 where s1.Ecodigo		= pc.Ecodigo
								   and s1.CPPid			= pc.CPPid
								   and s2.CPPFid_padre 	= pc.CPPFid
								   and <cf_dbfunction name="like" args="cp.CPformato like CPPFCmascara">
							) = 0
					   and cp.CPcuenta	= cp1.CPcuenta
					 group by CPformato
					 having count(distinct pc.CPPFid) > 1
					) > 0
			order by 1
		</cfquery> 
		<cfquery name="rsSQL2" datasource="#Session.DSN#">
			select CPformato as Cuenta_Presupuesto
			  from CPresupuesto cp 
			 where cp.Ecodigo	= #session.Ecodigo#
			   and cp.CPmovimiento = 'S'
			   and (
						select count(1)
						  from CPproyectosFinanciadosCtas
						 where Ecodigo	= cp.Ecodigo
						   and CPPid	= #session.CPPid#
						   and <cf_dbfunction name="like" args="cp.CPformato like CPPFCmascara">
					) = 0
			order by 1
		</cfquery>
		<cfoutput>
		<cfif isdefined("url.det")>
			<cfif rsSQL1.recordCount+rsSQL2.recordCount GT 0>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" value="Atrás" onclick="location.href='ProyectosFinanciamiento.cfm';">
			</cfif>
			<cfif rsSQL1.recordCount GT 0>
				<BR><BR>
				<strong>Cuentas que se encuentran en más de un proyecto</strong>
				<cf_dump query="rsSQL1" abort="no">
			</cfif>
			<cfif rsSQL2.recordCount GT 0>
				<BR><BR>
				<strong>Cuentas que no se encuentran en ningún proyecto</strong>
				<cf_dump query="rsSQL2" abort="no">
			</cfif>
		<cfelse>
			<cfif rsSQL1.recordCount GT 0>
				Existen Cuentas definidas en más de un proyecto
			</cfif>
			<cfif rsSQL2.recordCount GT 0>
				<BR>
				Existen Cuentas que no se encuentran en ningún proyecto
			</cfif>
			<cfif rsSQL1.recordCount+rsSQL2.recordCount GT 0>
				<BR><BR>
				<input type="button" value="Ver Detalle" onclick="location.href='ProyectosFinanciamiento_sql.cfm?btnVerificar&det';">
				<input type="button" value="Atrás" onclick="location.href='ProyectosFinanciamiento.cfm';">
			</cfif>
		</cfif>
		</cfoutput>
		<cfif rsSQL1.recordCount+rsSQL2.recordCount EQ 0>
			Todas las Cuentas se encuentran en algún proyecto
				<BR><BR>
			<input type="button" value="Atrás" onclick="location.href='ProyectosFinanciamiento.cfm';">
		</cfif>
		<cfabort>
	<cfelseif isdefined("url.btnAdd_CF")>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select count(1) as cantidad
			  from CPproyectosFinanciadosCFs
			 where  CPPFid = <cfqueryparam value="#url.CPPFid#" cfsqltype="cf_sql_numeric">
			   and  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
			   and  CPPid = <cfqueryparam value="#session.CPPid#" cfsqltype="cf_sql_numeric"> 
			   and  CFid = <cfqueryparam value="#url.CFid#" cfsqltype="cf_sql_numeric">
		</cfquery> 
		<cfif rsSQL.cantidad EQ 0>
			<cftransaction>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					insert into CPproyectosFinanciadosCFs
						(CPPFid, CFid, Ecodigo, CPPid)
					values (
						<cfqueryparam value="#url.CPPFid#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#url.CFid#" cfsqltype="cf_sql_numeric">,
						#session.Ecodigo#, #session.CPPid#
					)
				</cfquery>
				<cfset sbSyncronizar(url.CPPFid,url.CFid)>
			</cftransaction>
		</cfif>
		<cflocation url="ProyectosFinanciamiento.cfm?CPPFid=#url.CPPFid#&tab=2">
	<cfelseif isdefined("url.btnDel_CF")>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			delete from CPproyectosFinanciadosCFs
			 where  CPPFid 	= <cfqueryparam value="#url.CPPFid#" cfsqltype="cf_sql_numeric">
			   and  Ecodigo	= <cfqueryparam value="#session.Ecodigo#"	cfsqltype="cf_sql_integer"> 
			   and  CPPid	= <cfqueryparam value="#session.CPPid#"		cfsqltype="cf_sql_numeric"> 
			   and  CFid	= <cfqueryparam value="#url.CFid#" cfsqltype="cf_sql_numeric">
		</cfquery> 
		<cflocation url="ProyectosFinanciamiento.cfm?CPPFid=#url.CPPFid#&tab=2">
	<cfelseif isdefined("url.btnSyn_CF")>
		<cftransaction>
			<cfquery name="rsSQL" datasource="#Session.DSN#">
				delete from CPproyectosFinanciadosCtas
				 where  CPPFid = <cfqueryparam value="#url.CPPFid#" cfsqltype="cf_sql_numeric">
				   and  Ecodigo	= <cfqueryparam value="#session.Ecodigo#"	cfsqltype="cf_sql_integer"> 
				   and  CPPid	= <cfqueryparam value="#session.CPPid#"		cfsqltype="cf_sql_numeric"> 
				   and  CPPFCesCF = 1
			</cfquery> 
			<cfset sbSyncronizar(url.CPPFid,"")>
		</cftransaction>
		<cflocation url="ProyectosFinanciamiento.cfm?CPPFid=#url.CPPFid#&tab=1">
	<cfelseif isdefined("url.btnAdd_Cta")>
		<cfset url.msk = trim(replace(url.msk,"?","_","ALL"))>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select count(1) as cantidad
			  from CPproyectosFinanciadosCtas
			 where  CPPFid 			= <cfqueryparam value="#url.CPPFid#" cfsqltype="cf_sql_numeric">
			   and  Ecodigo 		= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
			   and  CPPid 			= <cfqueryparam value="#session.CPPid#" cfsqltype="cf_sql_numeric"> 
			   and  CPPFCmascara	= <cfqueryparam value="#url.msk#"	cfsqltype="cf_sql_varchar">
		</cfquery> 
		<cfif rsSQL.cantidad EQ 0>
			<cftransaction>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					insert into CPproyectosFinanciadosCtas
						(CPPFid, Ecodigo, CPPid, CPPFCmascara, CPPFCdescripcion, CPPFCesCF)
					values (
						<cfqueryparam value="#url.CPPFid#"		cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#session.Ecodigo#"	cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#session.CPPid#"	cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#url.msk#"			cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#url.dsc#"			cfsqltype="cf_sql_varchar">,
						0
					)
				</cfquery>
			</cftransaction>
		</cfif>
		<cflocation url="ProyectosFinanciamiento.cfm?CPPFid=#url.CPPFid#&tab=1">
	<cfelseif isdefined("url.btnDel_Cta")>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			delete from CPproyectosFinanciadosCtas
			 where  CPPFid 			= <cfqueryparam value="#url.CPPFid#" cfsqltype="cf_sql_numeric">
			   and  Ecodigo			= <cfqueryparam value="#session.Ecodigo#"	cfsqltype="cf_sql_integer"> 
			   and  CPPid			= <cfqueryparam value="#session.CPPid#"		cfsqltype="cf_sql_numeric"> 
			   and  CPPFCmascara	= <cfqueryparam value="#url.msk#"			cfsqltype="cf_sql_varchar">
		</cfquery> 
		<cflocation url="ProyectosFinanciamiento.cfm?CPPFid=#url.CPPFid#&tab=1">
	<cfelseif isdefined("url.btnAdd_SPry")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into CPproyectosFinanciados(Ecodigo, CPPFcodigo, CPPFdescripcion, CPPFid_padre, CPPFporCF, CPPFconSubproyectos, CPPFconFinanciamiento) 
			values ( <cfqueryparam cfsqltype="cf_sql_integer"	value="#session.ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char"		value="#url.cod#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar"	value="#url.dsc#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric"	value="#url.CPPFid#">,
					 0, 0, <cfqueryparam cfsqltype="cf_sql_bit"	value="#url.conFin#">
				   )
		</cfquery>		   
		<cflocation url="ProyectosFinanciamiento.cfm?CPPFid=#url.CPPFid#&tab=3">
	</cfif>
</cfif>
<cflocation url="ProyectosFinanciamiento.cfm">

<cffunction name="sbSyncronizar" output="false">
	<cfargument name="CPPFid">
	<cfargument name="CFid">

	<cfquery name="rsCF" datasource="#Session.DSN#">
		select 	CFcodigo,
				CFcuentac, CFcuentaingreso,
				CFcuentaaf, CFcuentainversion, CFcuentainventario, CFcuentagastoretaf, CFcuentaingresoretaf,
				CFcuentaobras, CFcuentaPatri, 
				CFComplemento
		<cfif Arguments.CFid NEQ "">
		  from CFuncional
		 where CFid = <cfqueryparam value="#Arguments.CFid#" cfsqltype="cf_sql_numeric">
		<cfelse>
		  from CPproyectosFinanciadosCFs p
		  	inner join CFuncional cf
				on cf.CFid = p.CFid
		 where p.CPPFid		= <cfqueryparam value="#Arguments.CPPFid#"	cfsqltype="cf_sql_numeric">
		   and p.Ecodigo	= <cfqueryparam value="#session.Ecodigo#"	cfsqltype="cf_sql_integer"> 
		   and p.CPPid		= <cfqueryparam value="#session.CPPid#"		cfsqltype="cf_sql_numeric"> 
		</cfif>
	</cfquery>
	<cfloop query="rsCF">
		<cfset sbSyncronizarCta(Arguments.CPPFid, rsCF.CFcuentaingreso, 	 "CF=#trim(rsCF.CFcodigo)#: Cuenta de Ingresos")>
		<cfset sbSyncronizarCta(Arguments.CPPFid, rsCF.CFcuentac, 			 "CF=#trim(rsCF.CFcodigo)#: Cuenta de Gastos")>
		<cfset sbSyncronizarCta(Arguments.CPPFid, rsCF.CFcuentainversion,	 "CF=#trim(rsCF.CFcodigo)#: Cuenta de Compras Inversion")>
		<cfset sbSyncronizarCta(Arguments.CPPFid, rsCF.CFcuentainventario,	 "CF=#trim(rsCF.CFcodigo)#: Cuenta de Consumo de Inventario")>
		<cfset sbSyncronizarCta(Arguments.CPPFid, rsCF.CFcuentaobras,		 "CF=#trim(rsCF.CFcodigo)#: Cuenta de Obras en Proceso")>

		<cfset sbSyncronizarCta(Arguments.CPPFid, rsCF.CFcuentaaf,			 "CF=#trim(rsCF.CFcodigo)#: Cuenta de Depreciación de Activos Fijos")>
		<cfset sbSyncronizarCta(Arguments.CPPFid, rsCF.CFcuentagastoretaf,	 "CF=#trim(rsCF.CFcodigo)#: Cuenta de Gasto Retiro de Activos Fijos")>
		<cfset sbSyncronizarCta(Arguments.CPPFid, rsCF.CFcuentaingresoretaf, "CF=#trim(rsCF.CFcodigo)#: Cuenta de Ingreso Retiro de Activos Fijos")>
		<cfset sbSyncronizarCta(Arguments.CPPFid, rsCF.CFcuentaPatri, 		 "CF=#trim(rsCF.CFcodigo)#: Cuenta de Ingreso Patrimonio")>
	</cfloop>
</cffunction>

<cffunction name="sbSyncronizarCta" output="false">
	<cfargument name="CPPFid">
	<cfargument name="msk">
	<cfargument name="dsc">

	<cfset Arguments.msk = trim(Replace(Arguments.msk,'?','_','all'))>

	<!--- Convierte la mascara financiera en mascara presupuesto --->
	<cfset LvarCmayor = mid (Arguments.msk,1,4)>
	<cfif find("_",LvarCmayor) GT 0>
		<cfreturn>
	</cfif>

	<cfset LvarMascara = "">
	<cfset LvarIni = 6>
	<cfquery name="rsMascara" datasource="#session.dsn#">
		select m.PCNlongitud, m.PCNpresupuesto
		from PCNivelMascara m, CPVigencia v
		where v.Ecodigo = #Session.Ecodigo#
		  and v.Cmayor  = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarCmayor#">
		  and (
				(select CPPanoMesDesde from CPresupuestoPeriodo where CPPid=#session.CPPid#) between v.CPVdesdeAnoMes and v.CPVhastaAnoMes
				OR
				(select CPPanoMesHasta from CPresupuestoPeriodo where CPPid=#session.CPPid#) between v.CPVdesdeAnoMes and v.CPVhastaAnoMes
			)
		  and m.PCEMid = v.PCEMid
		order by m.PCNid
	</cfquery>
	<cfloop query="rsMascara">
		<cfif mid(Arguments.msk,LvarIni-1,1) NEQ "-" or LvarIni+rsMascara.PCNlongitud-1 GT len(Arguments.msk) or find("-",mid(Arguments.msk,LvarIni,rsMascara.PCNlongitud)) GT 0>
			<cfset LvarError = "1">
			<cfset LvarMascara = "">
			<cfbreak>
		</cfif>
		<cfif PCNpresupuesto EQ 1>
			<cfif LvarMascara EQ "">
				<cfset LvarMascara = LvarCmayor>
			</cfif>
			<cfset LvarMascara = LvarMascara & "-" & mid(Arguments.msk,LvarIni,rsMascara.PCNlongitud)>
		</cfif>
		<cfset LvarIni = LvarIni + rsMascara.PCNlongitud + 1>
	</cfloop>
	<!------------------------------------------------------------------------->

	<cfif LvarMascara EQ "">
		<cfreturn>
	</cfif>

	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select count(1) as cantidad
		  from CPproyectosFinanciadosCtas
		 where  CPPFid			= <cfqueryparam value="#Arguments.CPPFid#"	cfsqltype="cf_sql_numeric">
		   and  Ecodigo			= <cfqueryparam value="#session.Ecodigo#"	cfsqltype="cf_sql_integer"> 
		   and  CPPid			= <cfqueryparam value="#session.CPPid#"		cfsqltype="cf_sql_numeric"> 
		   and  CPPFCmascara	= <cfqueryparam value="#LvarMascara#"		cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfif rsSQL.cantidad EQ 0>
		<cfquery datasource="#Session.DSN#">
			insert into CPproyectosFinanciadosCtas
				(CPPFid, Ecodigo, CPPid, CPPFCmascara, CPPFCdescripcion, CPPFCesCF)
			values (
				<cfqueryparam value="#Arguments.CPPFid#"	cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#session.Ecodigo#"		cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#session.CPPid#"		cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#LvarMascara#"			cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Arguments.dsc#"		cfsqltype="cf_sql_varchar">,
				1
			)
		</cfquery> 
	</cfif>
</cffunction>
