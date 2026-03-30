<cfcomponent>
<!--- 	Balance General	--->

	<cffunction name="CreaCuentas" access="public" output="false" returntype="string">
        <cf_dbtemp name="cuenta1" returnvariable="cuentas">
			<cf_dbtempcol name="CGARid"  		type="numeric"			mandatory="yes">
			<cf_dbtempcol name="ccuenta"  		type="numeric"			mandatory="yes">
			<cf_dbtempcol name="nivel"  		type="integer"    		mandatory="no">
			<cf_dbtempcol name="periodo"  		type="integer"    		mandatory="yes">
			<cf_dbtempcol name="mes"  			type="integer"    		mandatory="yes">
			<cf_dbtempcol name="saldoini"  		type="money"    		mandatory="yes">
			<cf_dbtempcol name="saldofin"  		type="money"    		mandatory="yes">
			<cf_dbtempcol name="movmes"  		type="money"    		mandatory="yes">
			<cf_dbtempcol name="pmensual"  		type="money"    		mandatory="yes">
			<cf_dbtempcol name="pfinal"  		type="money"    		mandatory="yes">
			<cf_dbtempcol name="cmayor"  		type="varchar(4)"  		mandatory="no">
			<cf_dbtempcol name="csubtipo"  		type="integer"  		mandatory="no">
			<cf_dbtempcol name="descrip"  		type="varchar(80)" 		mandatory="no">
			<cf_dbtempcol name="ntipo"  	    type="varchar(100)"		mandatory="no">
			<cf_dbtempcol name="ctipo"  	    type="varchar(1)"		mandatory="no">
			<cf_dbtempcol name="corte"  	    type="int"				mandatory="no">
			<cf_dbtempcol name="cbalancen"  	type="char(1)"          mandatory="no">
			<cf_dbtempcol name="formato"  	    type="varchar(100)"     mandatory="no">
			<cf_dbtempcol name="ccuentadet"     type="numeric"		    mandatory="no">
		</cf_dbtemp>
		
		<cfreturn cuentas>		
	</cffunction>
	
	<cffunction name='estadoResultados' access='public' output='true' returntype="query">
		<cfargument name='Ecodigo' type='numeric' required="yes">
		<cfargument name='periodo' type='numeric' required="yes">
		<cfargument name='mes' type='numeric' required="yes">
		<cfargument name='nivel' type='numeric' default="0">
		<cfargument name='CGARid' type='numeric' default="0" required="yes">
		<cfargument name='CGARepid' type='numeric' default="0" required="yes">
		<cfargument name='moneda' type="string" default="-1" required="no">
		<cfargument name='tipo' type="string" default="I" required="no">
		<cfargument name='debug' type='string' default="N">								
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		
		<!--- Creacion de la tabla temporal de Cuentas --->
		<cfset cuentas = this.CreaCuentas()>

		<cfset LvarTipo = "G">

		<cfif Arguments.CGARepid EQ 2>
			<cfset LvarTipo = "I">
		</cfif>

		<!--- 2. INSERTA LAS CUENTAS --->	
		<cfsetting requesttimeout="36000">
		<cfquery datasource="#session.DSN#" >
			insert into #cuentas# (	
									CGARid,
									ccuenta,
									nivel,
									periodo,
									mes,
									corte,
									cmayor,
									csubtipo,
									descrip,
									cbalancen,
									formato,
									ctipo,
									saldoini,
									saldofin,
									movmes,
									pmensual,
									pfinal,
									ccuentadet)
			select
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARid#">
				, dc2.Ccuentaniv
				, dc2.PCDCniv
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
				, 0
				, c.Cmayor
				, 0
				, c.Cdescripcion
				, 'D'
				, c.Cformato
				, 'G'
				, 0.00 as saldoini
				, 0.00 as saldofin
				, 0.00 as movmes
				, 0.00 as pmensual
				, 0.00 as pfinal
				, dc2.Ccuenta

			from CGAreaResponsabilidad ar

				inner join CGAreaResponsabilidadD dar <cf_dbforceindex name="CGAreaResponsabilidadD01">  <!--- Valores del Catalogo a utilizar para definir el Area de Responsabilidad --->
					on dar.CGARid = ar.CGARid

				inner join PCDCatalogoCuenta dc1				 										 <!--- Cuentas que cumplen con los valores de catalogo del Area de Responsabilidad --->
					on dc1.PCDcatid = dar.PCDcatid

				inner join PCDCatalogoCuenta dc2				 										 <!--- Cuentas al nivel seleccionado --->
					on dc2.Ccuenta = dc1.Ccuenta
				   and dc2.PCDCniv <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.nivel#">

				inner join CContables c <cf_dbforceindex name="PK_CCONTABLES">							 <!--- Cuentas Contables --->
					on c.Ccuenta = dc2.Ccuentaniv

				inner join CtasMayor cm
					 on cm.Ecodigo = c.Ecodigo
					and cm.Cmayor = c.Cmayor
		
			where ar.CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARid#">				
			  and cm.Cmayor in ( 
			  		select ctr.CGARCtaMayor 
					from CGAreasTipoRepCtas ctr
			  		where CGARepid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARepid#">
					  and CGARctaTipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTipo#">
					  )
		</cfquery>

		<cfif LvarTipo EQ "I">
			<cfquery datasource="#session.DSN#" >
			insert into #cuentas# (	
									CGARid,
									ccuenta,
									nivel,
									periodo,
									mes,
									corte,
									cmayor,
									csubtipo,
									descrip,
									cbalancen,
									formato,
									ctipo,
									saldoini,
									saldofin,
									movmes,
									pmensual,
									pfinal,
									ccuentadet)
			select
				distinct
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARid#">
				, dc2.Ccuentaniv
				, dc2.PCDCniv
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
				, 0
				, c.Cmayor
				, 0
				, c.Cdescripcion
				, 'D'
				, c.Cformato
				, 'G'
				, 0.00 as saldoini
				, 0.00 as saldofin
				, 0.00 as movmes
				, 0.00 as pmensual
				, 0.00 as pfinal
				, dc2.Ccuenta

			from CGAreaResponsabilidad ar

				inner join CGAreaResponsabilidadD dar <cf_dbforceindex name="CGAreaResponsabilidadD01"> <!--- Valores del Catalogo a utilizar para definir el Area de Responsabilidad --->
					on dar.CGARid = ar.CGARid

				inner join PCDCatalogoCuenta dc1 														<!--- Cuentas que cumplen con los valores de catalogo del Area de Responsabilidad --->
					on dc1.PCDcatid = dar.PCDcatid

				inner join PCDCatalogoCuenta dc2														<!--- Cuentas al nivel seleccionado --->
					on dc2.Ccuenta = dc1.Ccuenta
				   and dc2.PCDCniv <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.nivel#">

				inner join CContables c <cf_dbforceindex name="PK_CCONTABLES"> 							<!--- Cuentas Contables --->
					on c.Ccuenta = dc2.Ccuentaniv

				inner join CtasMayor cm
					on cm.Ecodigo = c.Ecodigo
					and cm.Cmayor = c.Cmayor
		
			where ar.CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARid#">				
			  and cm.Cmayor in ( 
			  		select ctr.CGARCtaMayor 
					from CGAreasTipoRepCtas ctr
			  		where CGARepid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARepid#">
					  and CGARctaTipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="G">
					  )
			</cfquery>
		</cfif>

		<!--- Actualizar los saldos de las cuentas --->
		<cfquery datasource="#session.DSN#" >
			update #cuentas#
			set saldoini = coalesce((
					select sum(s.SLinicial)
					from CGAreaResponsabilidadO oar, SaldosContables s
						 <cfif len(trim(arguments.moneda)) GT 0 and arguments.moneda NEQ '-1'>
						 	inner join Monedas mon 
								 on mon.Mcodigo = s.Mcodigo
								and mon.Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moneda#">
						 </cfif>
					where oar.CGARid = #cuentas#.CGARid
					  and s.Ccuenta  = #cuentas#.ccuentadet
					  and s.Speriodo = #cuentas#.periodo
					  and s.Smes	 = #cuentas#.mes
					  and s.Ocodigo  = oar.Ocodigo
  					  and s.Ecodigo  = oar.Ecodigo
					  and not exists (select 1 
								from CGAreasTipoRepCtasEliminar rcte
								where rcte.Ccuenta = s.Ccuenta
								  and rcte.Ocodigo = s.Ocodigo
								  and rcte.Ecodigo = s.Ecodigo
								  and CGARepid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARepid#">
							)

					  ), 0.00) 
		</cfquery>

		<cfquery datasource="#session.DSN#" >
			update #cuentas#
			set saldofin = coalesce((
					select sum(s.SLinicial + s.DLdebitos - s.CLcreditos)
					from CGAreaResponsabilidadO oar, SaldosContables s
						 <cfif len(trim(arguments.moneda)) GT 0 and arguments.moneda NEQ '-1'>
						 	inner join Monedas mon 
								 on mon.Mcodigo = s.Mcodigo
								and mon.Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moneda#">
						 </cfif>
					where oar.CGARid = #cuentas#.CGARid
					  and s.Ccuenta  = #cuentas#.ccuentadet
					  and s.Speriodo = #cuentas#.periodo
					  and s.Smes	 = #cuentas#.mes
					  and s.Ocodigo  = oar.Ocodigo
					  and s.Ecodigo  = oar.Ecodigo
					  and not exists (select 1 
								from CGAreasTipoRepCtasEliminar rcte
								where rcte.Ccuenta = s.Ccuenta
								  and rcte.Ocodigo = s.Ocodigo
								  and rcte.Ecodigo = s.Ecodigo
								  and CGARepid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARepid#">
							)

					  ), 0.00) 
		</cfquery>

		<cfquery datasource="#session.DSN#" >
			update #cuentas#
			set movmes = coalesce((
					select sum(s.DLdebitos - s.CLcreditos)
					from CGAreaResponsabilidadO oar, SaldosContables s
						 <cfif len(trim(arguments.moneda)) GT 0 and arguments.moneda NEQ '-1'>
						 	inner join Monedas mon 
								 on mon.Mcodigo = s.Mcodigo
								and mon.Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moneda#">
						 </cfif>
					where oar.CGARid = #cuentas#.CGARid
					  and s.Ccuenta  = #cuentas#.ccuentadet
					  and s.Speriodo = #cuentas#.periodo
					  and s.Smes	 = #cuentas#.mes
					  and s.Ocodigo  = oar.Ocodigo
  					  and s.Ecodigo  = oar.Ecodigo
					  and not exists (select 1 
								from CGAreasTipoRepCtasEliminar rcte
								where rcte.Ccuenta = s.Ccuenta
								  and rcte.Ocodigo = s.Ocodigo
								  and rcte.Ecodigo = s.Ecodigo
								  and CGARepid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARepid#">
							)

					  ), 0.00) 
		</cfquery>

		<cfquery datasource="#session.DSN#" >
			update #cuentas#
			set pmensual = coalesce((
					select sum(s.MLmonto)
					from CGAreaResponsabilidadO oar, SaldosContablesP s
					where oar.CGARid = #cuentas#.CGARid
					  and s.Ccuenta  = #cuentas#.ccuentadet
					  and s.Speriodo = #cuentas#.periodo
					  and s.Smes	 = #cuentas#.mes
					  and s.Ocodigo  = oar.Ocodigo
					  and s.Ecodigo  = oar.Ecodigo
					  and not exists (select 1 
								from CGAreasTipoRepCtasEliminar rcte
								where rcte.Ccuenta = s.Ccuenta
								  and rcte.Ocodigo = s.Ocodigo
								  and rcte.Ecodigo = s.Ecodigo
								  and CGARepid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARepid#">
							)

					  ), 0.00) 
		</cfquery>

		<cfquery datasource="#session.DSN#" >
			update #cuentas#
			set pfinal = coalesce((
					select sum(s.SPfinal)
					from CGAreaResponsabilidadO oar, SaldosContablesP s
					where oar.CGARid = #cuentas#.CGARid
					  and s.Ccuenta  = #cuentas#.ccuentadet
					  and s.Speriodo = #cuentas#.periodo
					  and s.Smes	 = #cuentas#.mes
					  and s.Ocodigo  = oar.Ocodigo
					  and s.Ecodigo  = oar.Ecodigo
					  and not exists (select 1 
								from CGAreasTipoRepCtasEliminar rcte
								where rcte.Ccuenta = s.Ccuenta
								  and rcte.Ocodigo = s.Ocodigo
								  and rcte.Ecodigo = s.Ecodigo
								  and CGARepid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARepid#">
							)

					  ), 0.00) 
		</cfquery>


		<!--- ==================================================================================== --->
		<!--- ==================================================================================== --->

		<!--- borra datos en cero --->
		<cfquery datasource="#session.DSN#">
			delete from #cuentas#
			where saldoini  = 0.00 
			  and saldofin  = 0.00 
			  and movmes    = 0.00 
			  and pmensual  = 0.00 
			  and pfinal    = 0.00 
		</cfquery>

		<cfquery datasource="#session.DSN#">
			update #cuentas#
			set corte = ((
					select ctr.CGARctaGrupo
					from CGAreasTipoRepCtas ctr
					where ctr.CGARepid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARepid#">
					  and ctr.CGARCtaMayor = #cuentas#.cmayor
					  ))
		</cfquery>

		<cfquery datasource="#session.DSN#">
			update #cuentas#
			set ctipo = ((
					select ctr.CGARctaTipo
					from CGAreasTipoRepCtas ctr
					where ctr.CGARepid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARepid#">
					  and ctr.CGARCtaMayor = #cuentas#.cmayor
					  ))
		</cfquery>
		
		<cfquery datasource="#session.DSN#">
			update #cuentas#
			set cbalancen = ((
					select case when ctr.CGARctaBalance  > 0 then 'D' else 'C' end
					from CGAreasTipoRepCtas ctr
					where ctr.CGARepid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARepid#">
					  and ctr.CGARCtaMayor = #cuentas#.cmayor
					  ))
		</cfquery>


		<cfquery datasource="#session.DSN#">
			update #cuentas#
			set csubtipo = corte * 10
		</cfquery>

		<cfquery datasource="#session.DSN#">
			update #cuentas#
				set     pmensual  = -pmensual 
			  		  , pfinal    = -pfinal
			where cbalancen = 'C'
		</cfquery>

		<cfif arguments.CGARepid eq 2 >
			<cfquery name="rsCuenta" datasource="#session.DSN#">
				select coalesce(max(ccuenta), 0) + 1 as ccuenta
				from #cuentas#
			</cfquery>
	
			<cfif rsCuenta.recordCount>
				<cfset next_cuenta = rsCuenta.ccuenta>
			<cfelse>
				<cfset next_cuenta = 1>
			</cfif>
	
			<!--- INSERTAR UTILIDAD BRUTA LA CTA MAYOR APARECE CON UN 0 ASI QUE NO DEBE PINTARSE EN PANTALLA --->
			<cfquery name="rsUtil1" datasource="#Arguments.conexion#">
				insert INTO #cuentas# (CGARid, nivel, cmayor, descrip, ccuenta, saldoini, saldofin, movmes, pmensual, pfinal, csubtipo, corte, ctipo, ntipo, cbalancen, periodo, mes)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARepid#">, 
							 0,
							'0', 
							'',
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#next_cuenta#">,
							0.00, 
							0.00,
							0.00, 
							0.00,
							0.00, 
							35,
							35,
							'I',
							'UTILIDAD BRUTA',
							'C', 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
							 )
			</cfquery>
			<cfset next_cuenta = next_cuenta + 1>
	
			<!--- INSERTAR UTILIDAD ANTES DE IMPUESTOS LA CTA MAYOR APARECE CON UN 0 ASI QUE NO DEBE PINTARSE EN PANTALLA --->
			<cfquery name="rsUtil2" datasource="#Arguments.conexion#">
				insert INTO #cuentas# (CGARid, nivel, cmayor, descrip, ccuenta, saldoini, saldofin, movmes, pmensual, pfinal, csubtipo, corte, ctipo, ntipo, cbalancen, periodo, mes)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARepid#">, 
							0,
							'0', 
							'',
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#next_cuenta#">,
							0.00, 
							0.00,
							0.00,
							0.00,
							0.00, 
							55,
							55,
							'I',
							'UTILIDAD ANTES DE IMPUESTOS',
							'C', 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
							)
			</cfquery>
			<cfset next_cuenta = next_cuenta + 1>
	
			<!--- INSERTAR UTILIDAD ANTES DE IMPUESTOS LA CTA MAYOR APARECE CON UN 0 ASI QUE NO DEBE PINTARSE EN PANTALLA --->
			<cfquery name="rsUtil3" datasource="#Arguments.conexion#">
				insert INTO #cuentas# (CGARid, nivel, cmayor, descrip, ccuenta, saldoini, saldofin, movmes, pmensual, pfinal, csubtipo, corte, ctipo, ntipo, cbalancen, periodo, mes)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CGARepid#">, 
							0,
							'0', 
							'',
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#next_cuenta#">,
							0.00, 
							0.00,
							0.00, 
							0.00,
							0.00, 
							85,
							85,
							'I',
							'UTILIDAD NETA',
							'C', 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.periodo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
							)
			</cfquery>
		</cfif>	
		
		<!--- Actualiza las descripciones de las cuentas que estan en null --->
		<cfquery datasource="#session.DSN#">
			update #cuentas#
			set descrip = ((select min(Cdescripcion)
							from CContables
							where CContables.Ccuenta = #cuentas#.ccuenta))
			where #cuentas#.descrip is null
		</cfquery>


		<!--- 5. Esto esta en el sp de estado de resultados --->
		<!--- ==================================================================================== --->
		<!--- ==================================================================================== --->
		<!--- Actualizar UTILIDAD BRUTA --->
		<cfquery datasource="#arguments.conexion#">
			update #cuentas# 
				set saldofin = coalesce((
					select sum(saldofin)
					from #cuentas#
					where nivel = 0
					and csubtipo < 35
					and csubtipo in (10, 20, 30)
				), 0.00),
				
				movmes = coalesce((
					select sum(movmes)
					from #cuentas#
					where nivel = 0
					and csubtipo < 35
					and csubtipo in (10, 20, 30)
				), 0.00),				

				pmensual = coalesce((
					select sum(pmensual)
					from #cuentas#
					where nivel = 0
					and csubtipo < 35
					and csubtipo in (10, 20, 30)
				), 0.00),				

				pfinal = coalesce((
					select sum(pfinal)
					from #cuentas#
					where nivel = 0
					and csubtipo < 35
					and csubtipo in (10, 20, 30)
				), 0.00)				
				
			where csubtipo = 35
		</cfquery>

		<!--- Actualizar UTILIDAD ANTES DE IMPUESTOS --->
		<cfquery datasource="#arguments.conexion#">
			update #cuentas# 
				set saldofin = coalesce((
					select sum(saldofin)
					from #cuentas#
					where nivel = 0
					and csubtipo < 55
					and csubtipo in (10, 20, 30, 40, 50)
				),0),
				
				movmes = coalesce((
					select sum(movmes)
					from #cuentas#
					where nivel = 0
					and csubtipo < 55
					and csubtipo in (10, 20, 30, 40, 50)
				), 0.00),
				
				pmensual = coalesce((
					select sum(pmensual)
					from #cuentas#
					where nivel = 0
					and csubtipo < 55
					and csubtipo in (10, 20, 30, 40, 50)
				), 0.00),				

				pfinal = coalesce((
					select sum(pfinal)
					from #cuentas#
					where nivel = 0
					and csubtipo < 55
					and csubtipo in (10, 20, 30, 40, 50)
				), 0.00)				
				
			where csubtipo = 55
		</cfquery>

		<!--- Actualizar UTILIDAD NETA --->
		<cfquery datasource="#arguments.conexion#">
			update #cuentas# 
				set saldofin = coalesce((
					select sum(saldofin)
					from #cuentas#
					where nivel = 0
					and csubtipo < 85
					and csubtipo in (10, 20, 30, 40, 50, 60, 70, 80)
				),0),
				
				movmes = coalesce((
					select sum(movmes)
					from #cuentas#
					where nivel = 0
					and csubtipo < 85
					and csubtipo in (10, 20, 30, 40, 50, 60, 70, 80)
				), 0.00),
				
				pmensual = coalesce((
					select sum(pmensual)
					from #cuentas#
					where nivel = 0
					and csubtipo < 85
					and csubtipo in (10, 20, 30, 40, 50, 60, 70, 80)
				), 0.00),				

				pfinal = coalesce((
					select sum(pfinal)
					from #cuentas#
					where nivel = 0
					and csubtipo < 85
					and csubtipo in (10, 20, 30, 40, 50, 60, 70, 80)
				), 0.00)				
				
							
			where csubtipo = 85
		</cfquery>

		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set saldofin = (saldofin * -1), 
				    movmes = (movmes * -1),
				    pmensual = (pmensual * -1),
				    pfinal = (pfinal * -1)
			where cbalancen = 'C'
		</cfquery>

		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 10, ntipo = 'INGRESOS'
			where ctipo = 'I' and csubtipo = 10
		</cfquery>		

		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 20, ntipo = 'COSTOS DE OPERACION'
			where ctipo = 'G' and csubtipo = 20
		</cfquery>		
		    
		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 30, ntipo = 'GASTOS ADMINISTRATIVOS'
			where ctipo = 'G' and csubtipo = 30
		</cfquery>		

		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 40, ntipo = 'OTROS INGRESOS GRAVABLES'
			where ctipo = 'I' and csubtipo = 40
		</cfquery>		

		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 50, ntipo = 'OTROS GASTOS DEDUCIBLES'
			where ctipo = 'G' and csubtipo = 50
		</cfquery>		
	    
		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 60, ntipo = 'OTROS INGRESOS NO GRAVABLES'
			where ctipo = 'I' and csubtipo = 60
		</cfquery>		

		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 70, ntipo = 'OTROS GASTOS NO DEDUCIBLES'
			where ctipo = 'G' and csubtipo = 70
		</cfquery>		
	    
		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set corte = 80, ntipo = 'IMPUESTOS'
			where ctipo = 'G' and csubtipo = 80
		</cfquery>	
		<!--- ==================================================================================== --->
		<!--- ==================================================================================== --->
		<cfquery name="datos" datasource="#session.DSN#">
			select  
				min(c1.descrip) as descrip, 
				c1.formato, 
				c1.nivel, 
				c1.cmayor as mayor, 
				c1.csubtipo as subtipo, 
				c1.ntipo, 
				c1.ctipo as tipo, 
				c1.corte as corte,
				c1.cbalancen,
				sum(c1.saldoini) as saldoini,
				sum(c1.saldofin) as saldofin,
				sum(c1.movmes) as movmes,
				sum(c1.pmensual) as pmensual,
				sum(c1.pfinal)  as pfinal
			from #cuentas# c1
			where nivel <= #arguments.nivel#
			group by c1.corte, c1.cmayor, c1.formato, c1.nivel, c1.csubtipo, c1.ntipo, c1.ctipo, c1.cbalancen
			order by c1.corte, c1.cmayor, c1.formato
		</cfquery>
		<cfreturn datos >
	</cffunction>
</cfcomponent>

