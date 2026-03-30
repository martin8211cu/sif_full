<cfinvoke key="LB_Titulo" default="Excluir cuentas sin mapear" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate" xmlfile="SQLCuentSinMapearExcluidasCEGE.xml"/>

<cfquery name="nivel" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE'
</cfquery>
<cfquery name="valOrden" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200081 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfif #nivel.Pvalor# neq '-1'>
	<cfset LvarFiltro = 'and (select PCDCniv from PCDCatalogoCuenta where Ccuentaniv = cco.Ccuenta GROUP BY PCDCniv ) <= #nivel.Pvalor - 1#'>
<cfelse>
<cfset LvarFiltro = "and cco.Cmovimiento = 'S'">
</cfif>

<cfset LvarOrden = ''>
<cfif #valOrden.RecordCount# eq 0>
<cfset LvarOrden = "">
<cfelse>
	<cfif #valOrden.Pvalor# eq 'N'>
		<cfset LvarOrden = " and m.Ctipo <> 'O' ">
	</cfif>
</cfif>

<cfset listErrores = "">
<cfset navegacion = "">

<cfif isdefined("url.sltmostrar") and len(trim(url.sltmostrar)) and not isdefined("form.sltmostrar")>
	<cfset form.sltmostrar = url.sltmostrar >
</cfif>
<cfif isdefined("form.sltmostrar") and form.sltmostrar NEQ "">
	<cfset navegacion = navegacion & "&sltmostrar=#form.sltmostrar#">
</cfif>
<cfif isdefined("url.CAgrupador") and len(trim(url.CAgrupador)) and not isdefined("form.CAgrupador")>
	<cfset form.CAgrupador = url.CAgrupador >
</cfif>
<cfif isdefined("form.CAgrupador") and form.CAgrupador NEQ "">
	<cfset navegacion = navegacion & "&CAgrupador=#form.CAgrupador#">
</cfif>
<cfif isdefined("url.mes") and len(trim(url.mes)) and not isdefined("form.mes")>
	<cfset form.mes = url.mes >
</cfif>
<cfif isdefined("form.mes") and form.mes NEQ "">
	<cfset navegacion = navegacion & "&mes=#form.mes#">
</cfif>
<cfif isdefined("url.periodo") and len(trim(url.periodo)) and not isdefined("form.periodo")>
	<cfset form.periodo = url.periodo >
</cfif>
<cfif isdefined("form.periodo") and form.periodo NEQ "">
	<cfset navegacion = navegacion & "&periodo=#form.periodo#">
</cfif>
<cfif isdefined("url.FILTRO_CDESCRIPCION") and len(trim(url.FILTRO_CDESCRIPCION)) and not isdefined("form.FILTRO_CDESCRIPCION")>
	<cfset form.FILTRO_CDESCRIPCION = url.FILTRO_CDESCRIPCION >
</cfif>
<cfif isdefined("form.FILTRO_CDESCRIPCION") and form.FILTRO_CDESCRIPCION NEQ "">
	<cfset navegacion = navegacion & "&FILTRO_CDESCRIPCION=#form.FILTRO_CDESCRIPCION#">
</cfif>
<cfif isdefined("url.FILTRO_CFORMATO") and len(trim(url.FILTRO_CFORMATO)) and not isdefined("form.FILTRO_CFORMATO")>
	<cfset form.FILTRO_CFORMATO = url.FILTRO_CFORMATO >
</cfif>
<cfif isdefined("form.FILTRO_CFORMATO") and form.FILTRO_CFORMATO NEQ "">
	<cfset navegacion = navegacion & "&FILTRO_CFORMATO=#form.FILTRO_CFORMATO#">
</cfif>
<cfif isdefined("url.FILTRO_DESCRIPCIONTIPO") and len(trim(url.FILTRO_DESCRIPCIONTIPO)) and not isdefined("form.FILTRO_DESCRIPCIONTIPO")>
	<cfset form.FILTRO_DESCRIPCIONTIPO = url.FILTRO_DESCRIPCIONTIPO >
</cfif>
<cfif isdefined("form.FILTRO_DESCRIPCIONTIPO") and form.FILTRO_DESCRIPCIONTIPO NEQ "-1">
	<cfset navegacion = navegacion & "&FILTRO_DESCRIPCIONTIPO=#form.FILTRO_DESCRIPCIONTIPO#">
</cfif>

<!--- Se eliminan las Cuentas seleccinadas --->
<cfif isdefined("form.btnExcluir")>
<!--- <cfdump var="#form.chk#">
<cfabort> --->
	<cfif isdefined("form.chk") and len(trim(form.chk)) GT 0>
		<cfquery name="rsinsInactivas" datasource="#Session.DSN#">
	        select Ccuenta,Cformato,Cdescripcion,
	        	#Session.Ecodigo#,#Session.Usucodigo#,
	        	GETDATE()
	        from (
			 select
				Cformato,Cdescripcion,Ccuenta,
			       case Ctipo
					when 'A' then 'Activo'
					when 'P' then 'Pasivo'
					when 'C' then 'Capital'
					when 'I' then 'Ingreso'
					when 'G' then 'Gasto'
					when 'O' then 'Orden'
					else 'N/A'
				end as DescripcionTipo
		     from (	select Cformato,Cdescripcion,Ctipo,ctasSaldos.Ccuenta
		       from (
		            SELECT	distinct ctas.Ccuenta, ctas.Cformato, ctas.Cdescripcion, ctas.Ecodigo,ctas.Cmayor, ctas.PCDCniv,ctas.Ctipo
		            from (
		            			select distinct a.Ccuenta, a.Cformato, a.Cdescripcion, a.Ecodigo,a.Cmayor, b.PCDCniv, cm.Ctipo
		                    	from CContables a
								inner join CtasMayor cm
									on a.Cmayor = cm.Cmayor and a.Ecodigo = cm.Ecodigo
		                    	INNER JOIN PCDCatalogoCuenta b
		                     		on a.Ccuenta = b.Ccuentaniv
		                    	<cfif isdefined('nivel.Pvalor') and #nivel.Pvalor# EQ -1>
									and a.Cmovimiento = 'S'
								<cfelse>
		                        	and b.PCDCniv <= (
		                        						select isnull(Pvalor,2) Pvalor
		                                            	from Parametros
		                                            	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		                                                	and Pcodigo = 200080) -1
		                    	</cfif>
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								and not exists (select 1 from CEInactivas e
												where a.Ccuenta = e.Ccuenta
												and a.Ecodigo = e.Ecodigo
												and e.GEid = (SELECT  m.GEid FROM AnexoGEmpresa m
																inner join AnexoGEmpresaDet b
																	on m.GEid = b.GEid
																where b.Ecodigo = #Session.Ecodigo#))
					) ctas
					INNER JOIN (
		            			select Ccuenta, Ecodigo from SaldosContables
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								<cfif isdefined("form.periodo") and form.periodo neq "-1" and isdefined("form.mes") and form.mes neq "-1">
					            	and Speriodo*100+Smes <= #form.periodo*100+form.mes#
								</cfif>
					) c
		               	on ctas.Ccuenta = c.Ccuenta
						and ctas.Ecodigo = c.Ecodigo
					where ctas.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				 ) ctasSaldos
		         left join CEMapeoSAT cSAT
		             on ctasSaldos.Ccuenta = cSAT.Ccuenta
		             and cSAT.CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CAgrupador#">
		             and cSAT.Ecodigo = #Session.Ecodigo#
					 and cSAT.GEid = (SELECT  a.GEid FROM AnexoGEmpresa a
									inner join AnexoGEmpresaDet b
										on a.GEid = b.GEid
									where b.Ecodigo = #Session.Ecodigo#)
		         where cSAT.Ccuenta is null
				 <cfif #valOrden.Pvalor# eq 'N'>
					and ctasSaldos.Ctipo <> 'O'
				 </cfif>
			) ctaNomap
			UNION ALL
			select
				Cformato,Cdescripcion,Ccuenta,
			       case Ctipo
					when 'A' then 'Activo'
					when 'P' then 'Pasivo'
					when 'C' then 'Capital'
					when 'I' then 'Ingreso'
					when 'G' then 'Gasto'
					when 'O' then 'Orden'
					else 'N/A'
				end as DescripcionTipo
			FROM (
				select distinct a.Ccuenta, a.Cformato, a.Cdescripcion, a.Ecodigo,a.Cmayor, b.PCDCniv, cm.Ctipo
		        from CContables a
				inner join CtasMayor cm
					on a.Cmayor = cm.Cmayor
					and a.Ecodigo = cm.Ecodigo
		        INNER JOIN PCDCatalogoCuenta b
		            on a.Ccuenta = b.Ccuentaniv
		        <cfif isdefined('nivel.Pvalor') and #nivel.Pvalor# EQ -1>
					and a.Cmovimiento = 'S'
				<cfelse>
		            and b.PCDCniv <= (
		                select isnull(Pvalor,2) Pvalor
		                from Parametros
		                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		                	and Pcodigo = 200080) -1
		        </cfif>
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and not exists (select 1 from CEInactivas e
						where a.Ccuenta = e.Ccuenta
							and a.Ecodigo = e.Ecodigo
							and e.GEid = (SELECT  m.GEid FROM AnexoGEmpresa m
											inner join AnexoGEmpresaDet b
												on m.GEid = b.GEid
											where b.Ecodigo = #Session.Ecodigo#))
				and not exists (select 1 from CEMapeoSAT cst
						where a.Ccuenta = cst.Ccuenta
						and a.Ecodigo = cst.Ecodigo
						and cst.CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CAgrupador#">
						and cst.GEid = (SELECT  m.GEid FROM AnexoGEmpresa m
							inner join AnexoGEmpresaDet b
								on m.GEid = b.GEid
							where b.Ecodigo = #Session.Ecodigo#))
				<cfif #valOrden.Pvalor# eq 'N'>
					and cm.Ctipo <> 'O'
				</cfif>
			) a
			where not exists (
					select 1 from SaldosContables b where a.Ecodigo = b.Ecodigo and a.Ccuenta = b.Ccuenta
				)
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		) result
		where not exists (select 1 from  (select distinct a.Ccuenta, a.Cformato, a.Cdescripcion, a.Ecodigo,a.Cmayor, b.PCDCniv, cm.Ctipo
							from CContables a
							inner join CtasMayor cm on a.Cmayor = cm.Cmayor and a.Ecodigo = cm.Ecodigo
							INNER JOIN PCDCatalogoCuenta b on a.Ccuenta = b.Ccuentaniv
							where b.PCDCniv = 0 and not exists (select 1 from CContables cc where a.Ccuenta = cc.Cpadre and a.Ecodigo = cc.Ecodigo)) cmns
						where result.Ccuenta = cmns.Ccuenta)
				and Ccuenta in (#form.chk#)
		</cfquery>

		<!--- <cfdump var="#rsinsInactivas.Ccuenta#"> --->
		<!--- <cfabort> --->
		<!--- Se obtiene las empresas que pertencen al grupo --->
		<cfquery name="rsGrpEmp" datasource="#Session.DSN#">
			SELECT  Ecodigo,GEid
			FROM AnexoGEmpresaDet
		    where GEid = (SELECT  GEid
		        		 FROM AnexoGEmpresaDet
		        		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
		</cfquery>
		<cftransaction  action="begin">
		<cftry>
		<!--- <cfdump var="#rsGrpEmp#"> --->
		<!--- Iteramos por cada empresa del grupo --->
		<cfloop query="rsGrpEmp">
			<cfloop query="rsinsInactivas"><!--- Iteramos por cada cuenta seleccionada --->
				<cfquery name="rsCuenta" datasource="#Session.DSN#"> <!--- se verfica si existe la cuenta --->
					SELECT Ccuenta FROM  CContables
					WHERE Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsinsInactivas.Cformato#">
					and Ecodigo = #rsGrpEmp.Ecodigo#
				</cfquery>
				<!--- <cfdump var="#rsCuenta#"> --->

				<cfset LvarCcuenta = -1>

				<cfif rsCuenta.recordcount GT 0> <!--- si la cuenta existe--->
					<!--- Validamos que no exista antes de insertarla --->
					<cfquery name="rsvalinactiva1" datasource="#Session.DSN#">
						select Ccuenta
						from CEInactivas
						where Ccuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuenta.Ccuenta#">
						and Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsinsInactivas.Cformato#">
						and Ecodigo = #rsGrpEmp.Ecodigo#
						and GEid = #rsGrpEmp.GEid#
					</cfquery>
					<!--- <cfdump var="#rsvalinactiva1#"> --->
					<cfif rsvalinactiva1.recordcount GT 0> <!--- si existe actualizamos--->
						<!--- Actualizamos el cuenta  --->
						<cfquery name ="rsup" datasource="#Session.DSN#">
							UPDATE CEInactivas SET GEid =  #rsGrpEmp.GEid#
							where Ccuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuenta.Ccuenta#">
							and Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsinsInactivas.Cformato#">
							and Ecodigo = #rsGrpEmp.Ecodigo#
						</cfquery>
					<cfelse>
						<cfquery datasource="#Session.DSN#">
							INSERT INTO CEInactivas(Ccuenta,Cformato,Cdescripcion,Ecodigo,BMUsucodigo,FechaGeneracion,GEid)
				           	values(#rsCuenta.Ccuenta#,'#rsinsInactivas.Cformato#','#rsinsInactivas.Cdescripcion#',#rsGrpEmp.Ecodigo#,#Session.Usucodigo#,(select GETDATE()),#rsGrpEmp.GEid#)
						</cfquery>
						<cfquery datasource="#Session.DSN#">
							DELETE CEInactivas
				           	WHERE GEid = -1
							AND Ecodigo in (SELECT Ecodigo
											FROM AnexoGEmpresaDet
											where GEid = (
											      SELECT  GEid
											      FROM AnexoGEmpresaDet
											      where Ecodigo = #Session.Ecodigo#)
											)
						</cfquery>
					</cfif>
				 <cfelse><!--- Si no existe la cuenta --->
					<!--- Consulta parametro de cuentas mapeadas en las empresas del grupo --->
					<cfquery name="rsrsvalParam" datasource="#Session.DSN#">
						SELECT Pvalor FROM Parametros WHERE Pcodigo = 200088 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
					</cfquery>

					<cfif rsrsvalParam.recordcount GT 0 and rsrsvalParam.Pvalor EQ 'S'> <!--- Validamos si el parametro esta activo --->
						<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
							<cfinvokeargument name="Lprm_CFformato" 		value="#rsinsInactivas.Cformato#"/>
							<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
							<cfinvokeargument name="Lprm_DSN" 				value="#Session.DSN#"/>
							<cfinvokeargument name="Lprm_Ecodigo" 			value="#rsGrpEmp.Ecodigo#"/>
						</cfinvoke>
						<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
							<cfset mensaje="ERROR">
							<cfquery name="rsEmpresa" datasource="#session.dsn#">
								SELECT  Edescripcion FROM Empresas where Ecodigo = #rsGrpEmp.Ecodigo#
							</cfquery>
							<cfquery name="insError" datasource="#session.dsn#">
								INSERT INTO ErrorProceso
							    (Ecodigo,Spcodigo,Usucodigo,Valor,Descripcion)
							   	Values (
							   		#Session.Ecodigo#,
							   		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SPcodigo#">,
							   		#Session.Usucodigo#,
							   		<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsEmpresa.Edescripcion)#">,
							   		<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarError)#">
							   	)
							</cfquery>
						</cfif>
						<cfset LvarCcuenta = request.PC_GeneraCFctaAnt.Ccuenta>
					</cfif>
				</cfif>
				<!--- <cfdump var="#LvarCcuenta#"> --->
				<cfif  LvarCcuenta NEQ -1 and LvarCcuenta NEQ "">
					<!--- Validamos que no exista antes de insertarla --->
					<cfquery name="rsvalinactiva1" datasource="#Session.DSN#">
						select Ccuenta
						from CEInactivas
						where Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsinsInactivas.Cformato#">
						and Ecodigo = #rsGrpEmp.Ecodigo#
						and GEid = #rsGrpEmp.GEid#
					</cfquery>
					<cfif rsvalinactiva1.recordcount GT 0> <!--- si existe actualizamo --->
						<!--- Actualizamos la cuenta  --->
						<cfquery datasource="#Session.DSN#">
							UPDATE CEInactivas SET GEid = #rsGrpEmp.GEid#
							where Ccuenta = #LvarCcuenta#
							and Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsinsInactivas.Cformato#">
							and Ecodigo = #rsGrpEmp.Ecodigo#
						</cfquery>
					<cfelse>
						<cfquery datasource="#Session.DSN#">
							INSERT INTO CEInactivas(Ccuenta,Cformato,Cdescripcion,Ecodigo,BMUsucodigo,FechaGeneracion,GEid)
					          values(#LvarCcuenta#,'#rsinsInactivas.Cformato#','#rsinsInactivas.Cdescripcion#',#rsGrpEmp.Ecodigo#,#Session.Usucodigo#,(select GETDATE()),#rsGrpEmp.GEid#)
						</cfquery>
						<cfquery datasource="#Session.DSN#">
							DELETE CEInactivas
				           	WHERE GEid = -1
							AND Ecodigo in (SELECT Ecodigo
											FROM AnexoGEmpresaDet
											where GEid = (
											      SELECT  GEid
											      FROM AnexoGEmpresaDet
											      where Ecodigo = #Session.Ecodigo#)
											)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfloop>
			<cfcatch>
				<cftransaction action="rollback"/>
			</cfcatch>
		</cftry>
		</cftransaction>
	</cfif>
</cfif>

<!--- 	Query ---><!--- <cf_dump var="#form#"> --->
<cfquery name="rsReporte" datasource="#session.DSN#">
	select * from (
	 select
		Cformato,Cdescripcion,Ccuenta,
	       case Ctipo
			when 'A' then 'Activo'
			when 'P' then 'Pasivo'
			when 'C' then 'Capital'
			when 'I' then 'Ingreso'
			when 'G' then 'Gasto'
			when 'O' then 'Orden'
			else 'N/A'
		end as DescripcionTipo
     from (	select Cformato,Cdescripcion,Ctipo,ctasSaldos.Ccuenta
       from (
            SELECT	distinct ctas.Ccuenta, ctas.Cformato, ctas.Cdescripcion, ctas.Ecodigo,ctas.Cmayor, ctas.PCDCniv,ctas.Ctipo
            from (
            			select distinct a.Ccuenta, a.Cformato, a.Cdescripcion, a.Ecodigo,a.Cmayor, b.PCDCniv, cm.Ctipo
                    	from CContables a
						inner join CtasMayor cm
							on a.Cmayor = cm.Cmayor and a.Ecodigo = cm.Ecodigo
                    	INNER JOIN PCDCatalogoCuenta b
                     		on a.Ccuenta = b.Ccuentaniv
                    	<cfif isdefined('nivel.Pvalor') and #nivel.Pvalor# EQ -1>
							and a.Cmovimiento = 'S'
						<cfelse>
                        	and b.PCDCniv <= (
                        						select isnull(Pvalor,2) Pvalor
                                            	from Parametros
                                            	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                                                	and Pcodigo = 200080) -1
                    	</cfif>
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and not exists (select 1 from CEInactivas e
										where a.Ccuenta = e.Ccuenta
										and a.Ecodigo = e.Ecodigo
										and e.GEid = (SELECT  m.GEid FROM AnexoGEmpresa m
														inner join AnexoGEmpresaDet b
															on m.GEid = b.GEid
														where b.Ecodigo = #Session.Ecodigo#))
			) ctas
			INNER JOIN (
            			select Ccuenta, Ecodigo from SaldosContables
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						<cfif isdefined("form.periodo") and form.periodo neq "-1" and isdefined("form.mes") and form.mes neq "-1">
			            	and Speriodo*100+Smes <= #form.periodo*100+form.mes#
						</cfif>
			) c
               	on ctas.Ccuenta = c.Ccuenta
				and ctas.Ecodigo = c.Ecodigo
			where ctas.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		 ) ctasSaldos
         left join CEMapeoSAT cSAT
             on ctasSaldos.Ccuenta = cSAT.Ccuenta
			 and cSAT.Ecodigo = #Session.Ecodigo#
			 and cSAT.GEid = (SELECT  a.GEid FROM AnexoGEmpresa a
							inner join AnexoGEmpresaDet b
								on a.GEid = b.GEid
							where b.Ecodigo = #Session.Ecodigo#)
             and cSAT.CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CAgrupador#">
         where cSAT.Ccuenta is null
		 <cfif #valOrden.Pvalor# eq 'N'>
			and ctasSaldos.Ctipo <> 'O'
		 </cfif>
	) ctaNomap
	UNION ALL
	select
		Cformato,Cdescripcion,Ccuenta,
	       case Ctipo
			when 'A' then 'Activo'
			when 'P' then 'Pasivo'
			when 'C' then 'Capital'
			when 'I' then 'Ingreso'
			when 'G' then 'Gasto'
			when 'O' then 'Orden'
			else 'N/A'
		end as DescripcionTipo
	FROM (
		select distinct a.Ccuenta, a.Cformato, a.Cdescripcion, a.Ecodigo,a.Cmayor, b.PCDCniv, cm.Ctipo
        from CContables a
		inner join CtasMayor cm
			on a.Cmayor = cm.Cmayor
			and a.Ecodigo = cm.Ecodigo
        INNER JOIN PCDCatalogoCuenta b
            on a.Ccuenta = b.Ccuentaniv
        <cfif isdefined('nivel.Pvalor') and #nivel.Pvalor# EQ -1>
			and a.Cmovimiento = 'S'
		<cfelse>
            and b.PCDCniv <= (
                select isnull(Pvalor,2) Pvalor
                from Parametros
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                	and Pcodigo = 200080) -1
        </cfif>
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and not exists (select 1 from CEInactivas e
						where a.Ccuenta = e.Ccuenta
							and a.Ecodigo = e.Ecodigo
							and e.GEid = (SELECT  m.GEid FROM AnexoGEmpresa m
											inner join AnexoGEmpresaDet b
												on m.GEid = b.GEid
											where b.Ecodigo = #Session.Ecodigo#))
		and not exists (select 1 from CEMapeoSAT cst
						where a.Ccuenta = cst.Ccuenta
						and a.Ecodigo = cst.Ecodigo
						and cst.CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CAgrupador#">
						and cst.GEid = (SELECT  m.GEid FROM AnexoGEmpresa m
							inner join AnexoGEmpresaDet b
								on m.GEid = b.GEid
							where b.Ecodigo = #Session.Ecodigo#))
		<cfif #valOrden.Pvalor# eq 'N'>
			and cm.Ctipo <> 'O'
		</cfif>
	) a
	where not exists (
			select 1 from SaldosContables b where a.Ecodigo = b.Ecodigo and a.Ccuenta = b.Ccuenta
		)
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
) result
where not exists (select 1 from  (select distinct a.Ccuenta, a.Cformato, a.Cdescripcion, a.Ecodigo,a.Cmayor, b.PCDCniv, cm.Ctipo
					from CContables a
					inner join CtasMayor cm on a.Cmayor = cm.Cmayor and a.Ecodigo = cm.Ecodigo
					INNER JOIN PCDCatalogoCuenta b on a.Ccuenta = b.Ccuentaniv
					where b.PCDCniv = 0 and not exists (select 1 from CContables cc where a.Ccuenta = cc.Cpadre and a.Ecodigo = cc.Ecodigo)) cmns
				where result.Ccuenta = cmns.Ccuenta)
order by result.Cformato
</cfquery>


<!--- Se empieza a pintar --->
<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<cfinclude template="../../../portlets/pNavegacionCG.cfm">
		<cfset filtro = "">
		<cfset navegacion = "">
		<cfset IRA = 'SQLCuentSinMapearExcluidasCEGE.cfm?CAgrupador=#form.CAgrupador#&mes=#form.mes#&periodo=#form.periodo#'>
		<cfoutput>
		<form action="#IRA#" method="post" name="form1" id="form1">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="tituloListas" align="left" valign="bottom"><strong>Mostrar</strong></td>
							<td class="tituloListas" align="left" valign="bottom"><strong>Formato</strong></td>
							<td class="tituloListas" align="left" valign="bottom"><strong  >Descripcion</strong>
							</td>
							<td class="tituloListas" align="left" valign="bottom"><strong  >Tipo Cuenta</strong></td>
						</tr>
						<tr>
							<td class="tituloListas" align="left">
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="100%" align="left">
											 <select name="sltmostrar" id="sltmostrar" onchange="form1.submit()">
											  <option value="20" <cfif isdefined('form.sltmostrar') and form.sltmostrar EQ '20'> selected</cfif>>20</option>
											  <option value="50" <cfif isdefined('form.sltmostrar') and form.sltmostrar EQ '50'> selected</cfif>>50</option>
											  <option value="100" <cfif isdefined('form.sltmostrar') and form.sltmostrar EQ '100'> selected</cfif>>100</option>
											</select>
										</td>
									</tr>
								</table>
							</td>
							<td class="tituloListas" align="left">
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="100%" align="left">
											<input 	type="text" size="6" maxlength="30" style="width:100%" onfocus="this.select()"
												name="filtro_Cformato" value="<cfif isdefined('form.filtro_Cformato')>#form.filtro_Cformato#</cfif>">
											<input type="hidden" name="hfiltro_Cformato" value="<cfif isdefined('form.hfiltro_Cformato')>#form.hfiltro_Cformato#</cfif>">
										</td>
									</tr>
								</table>
							</td>
							<td class="tituloListas" align="left">
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="100%" align="left">
											<input 	type="text" size="6" maxlength="30" style="width:100%" onfocus="this.select()"
												name="filtro_Cdescripcion" value="<cfif isdefined('form.filtro_Cdescripcion')>#form.filtro_Cdescripcion#</cfif>">
											<input type="hidden" name="hfiltro_Cdescripcion" value="<cfif isdefined('form.hfiltro_Cdescripcion')>#form.hfiltro_Cdescripcion#</cfif>">
										</td>
									</tr>
								</table>
							</td>
							<td class="tituloListas" align="left">
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="100%" align="left">
											<input 	type="text" size="6" maxlength="30" style="width:100%" onfocus="this.select()"
												name="filtro_DescripcionTipo" value="<cfif isdefined('form.filtro_DescripcionTipo')>#form.filtro_DescripcionTipo#</cfif>">
											<input type="hidden" name="hfiltro_DescripcionTipo" value="<cfif isdefined('form.hfiltro_DescripcionTipo')>#form.hfiltro_DescripcionTipo#</cfif>">
										</td>
										<td>
											<table cellspacing="1" cellpadding="0" >
												<tr>
													<td>
														<input type="submit" value="Filtrar" class="btnFiltrar" onclick="javascript:return filtrar_Plista();">
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td valign="top" width="100%">
					<cfset FILTRO_CFORMATO = "">
					<cfset FILTRO_CDESCRIPCION = "">
					<cfset FILTRO_DESCRIPCIONTIPO = "">
					<cfset sltmostrar = "20">
					<cfif isdefined('form.sltmostrar')>
						<cfset sltmostrar = "&sltmostrar=#form.sltmostrar#">
					</cfif>
					<cfif isdefined('form.FILTRO_CFORMATO')>
						<cfset FILTRO_CFORMATO = "&FILTRO_CFORMATO=#form.FILTRO_CFORMATO#">
					</cfif>
					<cfif isdefined('form.FILTRO_CDESCRIPCION')>
						<cfset FILTRO_CDESCRIPCION = "&FILTRO_CDESCRIPCION=#form.FILTRO_CDESCRIPCION#">
					</cfif>
					<cfif isdefined('form.FILTRO_DESCRIPCIONTIPO')>
						<cfset FILTRO_DESCRIPCIONTIPO = "&FILTRO_DESCRIPCIONTIPO=#form.FILTRO_DESCRIPCIONTIPO#">
					</cfif>
					<cfif not isdefined('form.sltmostrar')><cfset form.sltmostrar = 20></cfif>
					<cfset navegacion = navegacion & "&CAgrupador=#form.CAgrupador#&mes=#form.mes#&periodo=#form.periodo##FILTRO_CFORMATO##FILTRO_CDESCRIPCION##FILTRO_DESCRIPCIONTIPO##sltmostrar#">
						<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsReporte#"/>
								<cfinvokeargument name="desplegar" value="Cformato,Cdescripcion,DescripcionTipo"/>
								<cfinvokeargument name="etiquetas" value="Formato,Descripcion,Tipo Cuenta"/>
								<cfinvokeargument name="formatos" value="S,S,S"/>
                                <cfinvokeargument name="align" value="left,left,left"/>
								<cfinvokeargument name="ajustar" value="N,N,N"/>
								<cfinvokeargument name="irA" value="#IRA#"/>
								<cfinvokeargument name="keys" value="Ccuenta"/>
								<cfinvokeargument name="showlink" value="false"/>
								<cfinvokeargument name="includeForm" value="false"/>
								<cfinvokeargument name="formName" value="form1"/>
								<cfinvokeargument name="MaxRows" value="#form.sltmostrar#"/>
								<!--- <cfinvokeargument name="mostrar_filtro" value="true"/> --->
								<cfinvokeargument name="showemptylistmsg" value="true"/>
								<cfinvokeargument name="navegacion" value="#navegacion#"/>
								<cfinvokeargument name="checkboxes" value="S">
								<cfinvokeargument name="botones" value="Excluir"/>
								<cfinvokeargument name="checkall" value="S"/>
						</cfinvoke>
				</td>
		 	</tr>
		 	<tr>
				<cfif isdefined("form.btnExcluir")>
					<!--- verificando si no hubo errores --->
					<cfquery name="rsError" datasource="#session.dsn#">
						Select Valor,Descripcion
						from ErrorProceso
					    Where Ecodigo = #Session.Ecodigo#
					   		and Spcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SPcodigo#">
					   		and Usucodigo = #Session.Usucodigo#
					</cfquery>
					<cfif isdefined("rsError") and rsError.recordCount GT 0>
						<cfloop query="rsError">
						<td>Los sigientes errores ocurrieron: #rsError.Valor#, #rsError.Descripcion# </td>
						</cfloop>
					</cfif>
				</cfif>
			</tr>
		 	<input type="hidden" name="mes" id="mes" value="#form.mes#">
			<input type="hidden" name="periodo" id="periodo" value="#form.periodo#">
			<input type="hidden" name="CAgrupador" id="CAgrupador" value="#form.CAgrupador#">
			</cfoutput>
		</table>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>