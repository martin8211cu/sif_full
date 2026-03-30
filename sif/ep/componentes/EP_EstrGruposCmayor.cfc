<cfcomponent output="no">
	<cffunction name="CG_EstructuraGrupo" access="public" output="no" returntype="string">
		<cfargument name="IDEstrPro" 	type="numeric" 	required="yes">
		<cfargument name="GvarConexion" type="string"   required="yes">
		<cfargument name="tipoCuenta" 	type="string" 	default="contable"> <!--- valores(contable,presupuesto) --->
		<cfargument name="agrupaCmayor" 	type="string" 	default="S"> <!--- valores(N,S) agrupa por cuentas de mayor o por clasificadores--->
		<cfargument name="incluyeCuentas" 	type="string" 	default="S"> <!--- valores(N,S) va hasta el nivel de cuenta o de Mayor solo cuando agrupaCmayor = "S"--->


		<cfset FechaCreacion = #dateFormat(now(),"DDMMYYYYHHMMSSSS")#>
		<cfset TablaTem = 'GruposEstr'&#FechaCreacion#>

 		<cf_dbtemp name="#TablaTem#" returnVariable="GruposEstr" datasource="#GvarConexion#">
			<cf_dbtempcol name="ID_Grupo"			type="int" >
			<cf_dbtempcol name="EPCodigo"    		type="varchar(100)" >
			<cf_dbtempcol name="EPGdescripcion"    	type="varchar(100)" >
			<cf_dbtempcol name="EPCPcodigoref"	    	type="varchar(100)" >
			<cf_dbtempcol name="EPCPnota"	    	type="varchar(100)" >
			<cf_dbtempcol name="Nivel"    			type="int" >
			<cf_dbtempcol name="Orden"  			type="varchar(100)" >
			<cf_dbtempcol name="Cuenta"  			type="int" >
			<cf_dbtempcol name="Cmayor"				type="int">
			<cf_dbtempcol name="ClasCta"			type="int">
			<cf_dbtempcol name="DescripcionCmayor"	type="varchar(100)" >
			<cf_dbtempcol name="PCDcatid"    		type="int">
			<cf_dbtempcol name="PCDcatidH"    		type="int">
		</cf_dbtemp>


		<cfquery name="rsMaxIdGCM" datasource="#Arguments.GvarConexion#">
			select max(ID_GrupoPadre) + 1 idGen
			from CGGrupoPadreCtas
			where Ecodigo = #Session.Ecodigo#
		</cfquery>

        <cfquery name="rsMaxIdGCC" datasource="#Arguments.GvarConexion#">
			select max(ID_EstrCtaVal) + 1 idGen
			from CGEstrProgVal
			where ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
		</cfquery>
			<cfquery name="rsArbol" datasource="#Arguments.GvarConexion#">
				WITH CTEGrupo(ID_GrupoPadre,ID_Grupo_Ref,EPCodigo,EPGdescripcion,EPCPcodigoref,EPCPnota,NIVEL,Sort,Cuenta,Cmayor,ClasCta) AS
				(
				    SELECT ID_GrupoPadre,cast(ID_Grupo_Ref as int) ID_Grupo_Ref,cast(EPGcodigo as varchar),EPGdescripcion,EPCPcodigoref,EPCPnota, 0 AS NIVEL,
						CAST(EPGcodigo AS VARCHAR(128)) Sort, NULL Cuenta, NULL Cmayor,NULL ClasCta
				    FROM CGGrupoPadreCtas
				    WHERE ID_Grupo_Ref IS NULL
						AND ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
				    UNION ALL
				    SELECT e.ID_GrupoPadre,cast(e.ID_Grupo_Ref as int) ID_Grupo_Ref,cast(e.EPGcodigo as varchar),e.EPGdescripcion,e.EPCPcodigoref,e.EPCPnota, NIVEL + 1,
						CAST(d.Sort + '/' + CAST(e.EPGcodigo AS VARCHAR) AS VARCHAR(128)), cast(e.Cuenta as int), cast(e.Cmayor as int), cast(e.ClasCta as int)
					FROM (
							select e.ID_GrupoPadre,e.ID_Grupo_Ref,e.EPGcodigo,e.EPGdescripcion,e.EPCPcodigoref,e.EPCPnota, NULL Cuenta, NULL Cmayor, NULL ClasCta
							from CGGrupoPadreCtas e
							where e.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
								and ID_Grupo_Ref IS not NULL
							union all
							select -1*cgm.ID_Grupo ID_GrupoPadre, cgm.ID_GrupoPadre ID_Grupo_Ref,cgm.EPGcodigo,cgm.EPGdescripcion,cgm.EPCPcodigoref,cgm.EPCPnota,
								NULL Cuenta, NUll Cmayor, NULL ClasCta
							from CGGrupoCtasMayor cgm
							INNER JOIN CGGrupoPadreCtas cgpm
								ON cgm.ID_GrupoPadre = cgpm.ID_GrupoPadre
							where cgm.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">

							<cfif Arguments.agrupaCmayor NEQ "S">
							union all
							select ID_EstrCtaVal, ID_Grupo , EPCPcodigo,EPCPdescripcion,EPCPcodigoref,EPCPnota,NULL,NULL,ID_EstrCtaVal-#rsMaxIdGCM.idGen#
							from (
								select  cast(#rsMaxIdGCM.idGen#+ID_EstrCtaVal as int) ID_EstrCtaVal,-1*ID_Grupo ID_Grupo,EPCPcodigo,EPCPdescripcion,EPCPcodigoref,EPCPnota
								from CGEstrProgVal
								where ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
							)cla
							</cfif>

							<cfif (Arguments.incluyeCuentas EQ "S")>
									union all
									select idCuenta,
									<cfif Arguments.agrupaCmayor EQ "S">tCuentas.ID_Grupo<cfelse>X.ID_Grupo</cfif> ,
									Cformato,Cdescripcion,NULL,NULL,Ccuenta, Cmayor, X.ID_Grupo-#rsMaxIdGCM.idGen# ClasCta from (
										select cast(#rsMaxIdGCC.idGen#+#rsMaxIdGCM.idGen#+Ccuenta as int) idCuenta, cast(-1*ID_Grupo as int) ID_Grupo, cast(Cformato as varchar) Cformato,Cdescripcion,
												Ccuenta,Cmayor
										from (
											select
												<cfif Arguments.tipoCuenta EQ "presupuesto"> cc.CPformato <cfelse> cc.Cformato </cfif> Cformato,
												<cfif Arguments.tipoCuenta EQ "presupuesto"> cc.CPcuenta <cfelse> cc.Ccuenta </cfif> Ccuenta,
												cge.CGEPCtaMayor, cge.CGEPInclCtas, cge.ID_Grupo,
												cge.CGEPctaTipo, cge.CGEPctaGrupo, cge.CGEPctaBalance, cge.ID_Estr,
												<cfif Arguments.tipoCuenta EQ "presupuesto"> cc.CPdescripcion <cfelse> cc.Cdescripcion </cfif> Cdescripcion,
												cc.Cmayor
											from CGEstrProgCtaM cge
											inner join <cfif Arguments.tipoCuenta EQ "presupuesto"> CPresupuesto <cfelse> CContables </cfif> cc
												on cc.Cmayor = cge.CGEPCtaMayor
											where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
												and cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
												and cge.CGEPInclCtas in (1,3)
												and cc.<cfif Arguments.tipoCuenta EQ "presupuesto">CPmovimiento <cfelse>Cmovimiento </cfif> = 'S'
											union all
											select
												<cfif Arguments.tipoCuenta EQ "presupuesto"> cc.CPformato <cfelse> cc.Cformato </cfif> Cformato,
												<cfif Arguments.tipoCuenta EQ "presupuesto"> epc.CPcuenta <cfelse> cc.Ccuenta </cfif> Ccuenta,
												cge.CGEPCtaMayor, cge.CGEPInclCtas, cge.ID_Grupo,
												cge.CGEPctaTipo, cge.CGEPctaGrupo, cge.CGEPctaBalance, cge.ID_Estr,
												<cfif Arguments.tipoCuenta EQ "presupuesto"> cc.CPdescripcion <cfelse> cc.Cdescripcion </cfif> Cdescripcion,
												cc.Cmayor
											from CGEstrProgCtaM cge
											inner join (select ID_Estr, cp.Cmayor,
														<cfif Arguments.tipoCuenta EQ "presupuesto"> cp.CPcuenta <cfelse> cp.Ccuenta </cfif>
														from CGEstrProgCtaD d
														inner join <cfif Arguments.tipoCuenta EQ "presupuesto"> CPresupuesto <cfelse> CContables </cfif> cp
											    			on <cfif Arguments.tipoCuenta EQ "presupuesto"> cp.CPformato <cfelse> cp.Cformato </cfif> like replace(d.FormatoP,'X','_')
											    	) epc
												on epc.ID_Estr = cge.ID_Estr

											inner join <cfif Arguments.tipoCuenta EQ "presupuesto"> CPresupuesto <cfelse> CContables </cfif> cc
												on epc.<cfif Arguments.tipoCuenta EQ "presupuesto">CPcuenta<cfelse>Ccuenta </cfif> = cc.<cfif Arguments.tipoCuenta EQ "presupuesto">CPcuenta<cfelse>Ccuenta </cfif>
												and cc.Cmayor = cge.CGEPCtaMayor
											where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
												and cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
												and cge.CGEPInclCtas = 2
												and cc.<cfif Arguments.tipoCuenta EQ "presupuesto">CPmovimiento<cfelse>Cmovimiento </cfif> = 'S'
										) incluye
										except
										select cast(#rsMaxIdGCM.idGen#+Ccuenta as int), cast(ID_Grupo as int) ID_Grupo, cast(Cformato as varchar),Cdescripcion,
												Ccuenta,Cmayor
										from (
										select
												<cfif Arguments.tipoCuenta EQ "presupuesto"> cc.CPformato <cfelse> cc.Cformato </cfif> Cformato,
												<cfif Arguments.tipoCuenta EQ "presupuesto"> cc.CPcuenta <cfelse> cc.Ccuenta </cfif> Ccuenta,
												cge.CGEPCtaMayor, cge.CGEPInclCtas, cge.ID_Grupo,
												cge.CGEPctaTipo, cge.CGEPctaGrupo, cge.CGEPctaBalance, cge.ID_Estr,
												<cfif Arguments.tipoCuenta EQ "presupuesto"> cc.CPdescripcion <cfelse> cc.Cdescripcion </cfif> Cdescripcion,
												cc.Cmayor
										from CGEstrProgCtaM cge
										inner join (select ID_Estr, cp.Cmayor,
														<cfif Arguments.tipoCuenta EQ "presupuesto"> cp.CPcuenta <cfelse> cp.Ccuenta </cfif>
														from CGEstrProgCtaD d
														inner join <cfif Arguments.tipoCuenta EQ "presupuesto"> CPresupuesto <cfelse> CContables </cfif> cp
											    			on <cfif Arguments.tipoCuenta EQ "presupuesto"> cp.CPformato <cfelse> cp.Cformato </cfif> like replace(d.FormatoP,'X','_')
											    	) epc
											on epc.ID_Estr = cge.ID_Estr
										inner join <cfif Arguments.tipoCuenta EQ "presupuesto"> CPresupuesto <cfelse> CContables </cfif> cc
											on epc.<cfif Arguments.tipoCuenta EQ "presupuesto">CPcuenta<cfelse>Ccuenta </cfif> = cc.<cfif Arguments.tipoCuenta EQ "presupuesto">CPcuenta<cfelse>Ccuenta </cfif>
											and cc.Cmayor = cge.CGEPCtaMayor
										where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
											and cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
											and cge.CGEPInclCtas = 3
											and cc.<cfif Arguments.tipoCuenta EQ "presupuesto">CPmovimiento<cfelse>Cmovimiento </cfif> = 'S'
										) excluye
									) tCuentas
							</cfif>
							<cfif Arguments.agrupaCmayor EQ "S">
										union all
										select  Cast(#rsMaxIdGCM.idGen#+cc.Cmayor as int), -cge.ID_Grupo ID_Grupo, cc.Cmayor EPGcodigo, cc.Cdescripcion,NULL,NULL,
												NULL Cuenta, cc.Cmayor, NULL ClasCta
											from CGEstrProgCtaM cge
											inner join CtasMayor cc
												on cc.Cmayor = cge.CGEPCtaMayor
											where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
												and cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
							<cfelse>
								<cfif Arguments.incluyeCuentas EQ "S">
										inner join (
                                            select <cfif Arguments.tipoCuenta EQ "presupuesto"> c.CPcuenta <cfelse> c.Ccuenta </cfif>  XCcuenta, #rsMaxIdGCM.idGen#+epCtas.ID_EstrCtaVal ID_Grupo
                                            from (
                                                select a.ID_EstrCtaVal,<cfif Arguments.tipoCuenta EQ "presupuesto"> b.CPcuenta <cfelse> b.Ccuenta </cfif> Cuenta
                                                from CGDDetEProgVal a
                                                inner join CGEstrProgVal e
                                                    on a.ID_EstrCtaVal=e.ID_EstrCtaVal
                                                inner join <cfif Arguments.tipoCuenta EQ "presupuesto"> PCDCatalogoCuentaP <cfelse> PCDCatalogoCuenta </cfif> b on a.PCDcatidref = b.PCDcatid
<!---                                                inner join <cfif Arguments.tipoCuenta EQ "presupuesto"> PCDCatalogoCuentaP <cfelse> PCDCatalogoCuenta </cfif> cc on cc.PCDcatid = b.PCDcatid--->
                                                where e.ID_Estr  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
                                                    and e.SoloHijos = 1
                                            ) epCtas
                                            inner join (
                                                    select <cfif Arguments.tipoCuenta EQ "presupuesto"> c.CPcuenta <cfelse> c.Ccuenta </cfif>, c.CPmovimiento from CGEstrProgCtaM cge
                                                    inner join <cfif Arguments.tipoCuenta EQ "presupuesto"> CPresupuesto <cfelse> CContables </cfif> c
                                                        on cge.CGEPCtaMayor = c.Cmayor
                                                        and cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
                                            ) c
                                                on epCtas.Cuenta = <cfif Arguments.tipoCuenta EQ "presupuesto"> c.CPcuenta <cfelse> c.Ccuenta </cfif>
                                            where c.<cfif Arguments.tipoCuenta EQ "presupuesto">CPmovimiento <cfelse>Cmovimiento </cfif> = 'S'
                                            union all
                                            select <cfif Arguments.tipoCuenta EQ "presupuesto"> c.CPcuenta <cfelse> c.Ccuenta </cfif>  XCcuenta, #rsMaxIdGCM.idGen#+epCtas.ID_EstrCtaVal ID_Grupo
                                            from (
                                                    select a.ID_EstrCtaVal,<cfif Arguments.tipoCuenta EQ "presupuesto"> b.CPcuenta <cfelse> b.Ccuenta </cfif> Cuenta
                                                    from CGDEstrProgVal a
                                                    inner join CGEstrProgVal e
                                                        on a.ID_EstrCtaVal=e.ID_EstrCtaVal
                                                    inner join <cfif Arguments.tipoCuenta EQ "presupuesto"> PCDCatalogoCuentaP <cfelse> PCDCatalogoCuenta </cfif> b on a.PCDcatid = b.PCDcatid
                                                    where e.ID_Estr  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
                                                        and e.SoloHijos = 0
                                            ) epCtas
                                            inner join (
                                                    select <cfif Arguments.tipoCuenta EQ "presupuesto"> c.CPcuenta <cfelse> c.Ccuenta </cfif>, c.CPmovimiento, c.CPformato from CGEstrProgCtaM cge
                                                    inner join <cfif Arguments.tipoCuenta EQ "presupuesto"> CPresupuesto <cfelse> CContables </cfif> c
                                                        on cge.CGEPCtaMayor = c.Cmayor
                                                        and cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
                                            ) c
                                                on epCtas.Cuenta = <cfif Arguments.tipoCuenta EQ "presupuesto"> c.CPcuenta <cfelse> c.Ccuenta </cfif>
                                            where c.<cfif Arguments.tipoCuenta EQ "presupuesto">CPmovimiento <cfelse>Cmovimiento </cfif> = 'S'
                                        ) as X
                                            on X.XCcuenta = tCuentas.Ccuenta
								</cfif>
							</cfif>

						) e
					INNER JOIN CTEGrupo d
						ON e.ID_Grupo_Ref = d.ID_GrupoPadre

				)
				INSERT INTO #GruposEstr# (ID_Grupo,EPCodigo,EPGdescripcion,EPCPcodigoref,EPCPnota,Nivel,Orden,Cuenta,Cmayor,ClasCta,DescripcionCmayor,PCDcatid,PCDcatidH)
				SELECT distinct CTEGrupo.ID_GrupoPadre,CTEGrupo.EPCodigo,
					CTEGrupo.EPGdescripcion,CTEGrupo.EPCPcodigoref,CTEGrupo.EPCPnota,CTEGrupo.NIVEL,CTEGrupo.Sort,
					CTEGrupo.Cuenta,CTEGrupo.Cmayor,CTEGrupo.ClasCta, cm.Cdescripcion,X.PCDcatid,Y.PCDcatidref
				FROM CTEGrupo
				left join (select distinct c.Cmayor, c.CPformato, c.CPcuenta, cc.PCDvalor, cc.PCDdescripcion, epvd.ID_EstrCtaVal,
								case when isnull(epvd.SaldoInv,0) = 0 then 1 else -1 end SaldoInv,
												epvd.PCDcatid, epv.ID_Grupo, epv.SoloHijos
					 			    from CGEstrProgCtaM cge

								    inner join CPresupuesto c on cge.CGEPCtaMayor = c.Cmayor
									inner join PCDCatalogoCuentaP nm on nm.CPcuenta = c.CPcuenta
									inner join CGDEstrProgVal epvd on epvd.PCDcatid = nm.PCDcatid
									inner join CGEstrProgVal epv on epv.ID_EstrCtaVal = epvd.ID_EstrCtaVal
								   	and epv.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
					 				inner join PCDCatalogo cc on cc.PCDcatid = epvd.PCDcatid
									where cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
									and c.CPmovimiento = 'S'
					) as X on X.CPcuenta = CTEGrupo.Cuenta
					left join (select distinct c.Cmayor, c.CPformato, c.CPcuenta, cc.PCDvalor, cc.PCDdescripcion, epvd.PCDcatidref
								    from CGEstrProgCtaM cge
								    inner join CPresupuesto  c on cge.CGEPCtaMayor = c.Cmayor
									inner join PCDCatalogoCuentaP nm on nm.CPcuenta = c.CPcuenta
									inner join CGDDetEProgVal epvd on epvd.PCDcatidref = nm.PCDcatid
									inner join CGEstrProgVal epv on epv.ID_EstrCtaVal = epvd.ID_EstrCtaVal
									and epv.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
									inner join PCDCatalogo cc on cc.PCDcatid = epvd.PCDcatidref
									where cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
									and c.CPmovimiento = 'S'
					) as Y on Y.CPcuenta = CTEGrupo.Cuenta
				LEFT JOIN CGGrupoPadreCtas
					ON CTEGrupo.ID_Grupo_Ref = CGGrupoPadreCtas.ID_GrupoPadre
				Left join CtasMayor cm
					on CTEGrupo.Cmayor = cm.Cmayor
				left join  ( select distinct a.PCDcatid from (
							select count(isnull(b.PCDcatid,0)) cantidad, isnull(b.PCDcatid,0) PCDcatid
										 from CGEstrProgVal c
											inner join CGDEstrProgVal b
												 on b.ID_EstrCtaVal = c.ID_EstrCtaVal and c.SoloHijos = 1
											inner join CGDDetEProgVal a
												on a.ID_DEstrCtaVal = b.ID_DEstrCtaVal
									where c.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
									and convert(varchar,coalesce(b.PCDcatid,'0')) <> '0'
							group by  isnull(b.PCDcatid,0)
							having isnull(b.PCDcatid,0) > 0
						) a
				) R
					on X.PCDcatid = R.PCDcatid
				left join (
						select distinct convert(varchar,coalesce(b.PCDcatid,'0')) + '-' + convert(varchar,coalesce(a.PCDcatidref,'0')) Concepto
									 from CGEstrProgVal c
										inner join CGDEstrProgVal b
											 on b.ID_EstrCtaVal = c.ID_EstrCtaVal and c.SoloHijos = 1
										inner join CGDDetEProgVal a
											on a.ID_DEstrCtaVal = b.ID_DEstrCtaVal
								where c.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEStrPro#">
				) SR
					on convert(varchar,coalesce(X.PCDcatid,'0')) + '-' + convert(varchar,coalesce(Y.PCDcatidref,'0')) = SR.Concepto
 				<!--- where (
 						X.PCDcatid is not null and SR.Concepto is not null
 					)
 					or (
 						X.PCDcatid is null
 					) --->
				order by Sort

			</cfquery>

<!--- <cfquery name="rsArbol" datasource="#Arguments.GvarConexion#">
	select top 100  * from #GruposEstr#
</cfquery>
<cf_dump var="#rsArbol#"> --->

		<cfreturn GruposEstr>
	</cffunction>
</cfcomponent>