<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha 16-2-2006.
		Motivo: Se cambia: cfsqltype="integer" por cfsqltype="cf_sql_integer" en 8 puntos de este fuente.
 --->

<cfcomponent>
<!--- 	Balance General	--->

	<cffunction name="CreaCuentas" access="public" output="false" returntype="string">
		<cf_dbtemp name="cuentas">
			<cf_dbtempcol name="ccuenta"  		type="numeric"	mandatory="yes">
			<cf_dbtempcol name="nivel"  		type="integer"    		mandatory="no">
			<cf_dbtempcol name="ocodigo"  		type="integer"    		mandatory="yes">
			<cf_dbtempcol name="ecodigo"  		type="integer"    		mandatory="yes">
			<cf_dbtempcol name="saldoini"  		type="money"    		mandatory="yes">
			<cf_dbtempcol name="saldofin"  		type="money"    		mandatory="yes">
			<cf_dbtempcol name="debitos"  		type="money"    		mandatory="yes">
			<cf_dbtempcol name="creditos"  		type="money"    		mandatory="yes">
			<cf_dbtempcol name="cmayor"  		type="varchar(4)"  		mandatory="no">
			<cf_dbtempcol name="csubtipo"  		type="integer"  		mandatory="no">
			<cf_dbtempcol name="descripcion"  	type="varchar(80)" 		mandatory="no">
			<cf_dbtempcol name="ntipo"  	    type="varchar(100)"		mandatory="no">
			<cf_dbtempcol name="ctipo"  	    type="varchar(1)"		mandatory="no">
			<cf_dbtempcol name="corte"  	    type="int"				mandatory="no">
			<cf_dbtempcol name="cbalancen"  	type="char(1)"          mandatory="no">
			
			<cf_dbtempkey cols="ccuenta,ocodigo,ecodigo">
		</cf_dbtemp>
		
		<cfreturn temp_table>		
	</cffunction>
	
	<cffunction name="CreaCF" access="public" output="false" returntype="string">
		<cf_dbtemp name="cf">
			<cf_dbtempcol name="cfid" 				type="numeric" mandatory="yes">
			<cf_dbtempcol name="cfcuentac"			type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="cfcuentaaf" 		type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="cfcuentainversion" 	type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="cfcuentainventario" type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="cfcuentaingreso" 	type="varchar(100)" mandatory="no">

			<cf_dbtempkey cols="cfid">
		</cf_dbtemp>
		<cfreturn temp_table>		
	</cffunction>		
	
	<cffunction name='estadoResultados' access='public' output='true' returntype="query">
		<cfargument name='Ecodigo' type='numeric' required="yes">
		<cfargument name='periodo' type='numeric' required="yes">
		<cfargument name='mes' type='numeric' required="yes">
		<cfargument name='nivel' type='numeric' default="0">
		<cfargument name='Mcodigo' type='numeric' default="-2">
		<cfargument name='CFid' type='numeric' default="0" required="yes">
		<cfargument name='dependencias' type='boolean' default='false' required="yes">
		<cfargument name='ceros' type='string' default="S">
		<cfargument name='debug' type='string' default="N">								
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		
		<!--- Creacion de la tabla temporal de Cuentas --->
		<cfset cuentas = this.CreaCuentas()>

		<!--- 1. CENTROS FUNCIONALES --->
		<!--- 1.1 crea tabla de centros funcionales --->
		<cfset cf = this.CreaCF()>

		<!--- 1.2 Inserta centro funcional seleccionado --->
		<cfquery datasource="#session.DSN#">
			insert into #cf#(cfid, cfcuentac, cfcuentaaf, cfcuentainversion, cfcuentainventario, cfcuentaingreso )
			select cf.CFid, cf.CFcuentac, cf.CFcuentaaf, cf.CFcuentainversion, cf.CFcuentainventario, cf.CFcuentaingreso 
			from CFuncional cf
			where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">
		</cfquery>
		
		<!--- 1.3 Inserta centros funcionales asociados al seleccionado --->
		<cfif arguments.dependencias >
        	<cfinclude template="../Utiles/sifConcat.cfm">
			<cfquery datasource="#session.DSN#">
				insert into #cf#(cfid, cfcuentac, cfcuentaaf, cfcuentainversion, cfcuentainventario, cfcuentaingreso )
				select cf.CFid, cf.CFcuentac, cf.CFcuentaaf, cf.CFcuentainversion, cf.CFcuentainventario, cf.CFcuentaingreso 
				from CFuncional cf1, CFuncional cf
				where cf1.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFid#">
				  and cf.Ecodigo = cf1.Ecodigo
				  and cf.CFpath like cf1.CFpath #_Cat# '%'
				  and cf.CFid <> cf1.CFid
			</cfquery>
		</cfif>
		
		<!--- 2. INSERTA LAS CUENTAS --->
		<cfobject component="sif.Componentes.AplicarMascara" name="mascara">

		<cfquery name="cfs"  datasource="#Arguments.Conexion#">
			select cfid, cfcuentac, cfcuentaaf, cfcuentainversion, cfcuentainventario, cfcuentaingreso
			from #cf#
		</cfquery>
		
		<!--- insertar las cuentas por cada centro funcional  --->
		<cfloop query="cfs">
			<!--- 2.1 CFcuentac --->
			<cfif len(trim(cfs.CFcuentac))>
				<cfset LvarMascaraCuenta = mascara.AplicarMascara(cfs.CFcuentac, '_', '?')>
				<cfquery datasource="#session.DSN#">
					insert into #cuentas# (ccuenta, ocodigo, ecodigo, saldoini, saldofin, debitos, creditos, descripcion, ctipo, cbalancen)
					select c.Ccuenta, cf.Ocodigo, c.Ecodigo, 0.00, 0.00, 0.00, 0.00, c.Cdescripcion, cm.Ctipo, cm.Cbalancen
					from CFuncional cf, CContables c, CtasMayor cm
					where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cfs.cfid#">
					  and c.Cformato like <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMascaraCuenta#">
					  and c.Cmovimiento = 'S'
					  and cm.Cmayor = c.Cmayor
					  and cm.Ecodigo = c.Ecodigo
					  and cm.Ctipo in ('I', 'G')
		  			  and cm.Csubtipo is not null
					  and not exists(select 1 from #cuentas# c2 where c2.ccuenta = c.Ccuenta and c2.ocodigo = cf.Ocodigo)
				</cfquery>
			</cfif>
			
			<!--- 2.2 CFcuentaaf --->
			<cfif len(trim(cfs.CFcuentaaf))>
				<cfset LvarMascaraCuenta = mascara.AplicarMascara(cfs.CFcuentaaf, '_', '?')>
				<cfquery datasource="#session.DSN#">
					insert into #cuentas# (ccuenta, ocodigo, ecodigo, saldoini, saldofin, debitos, creditos, descripcion, ctipo, cbalancen)
					select c.Ccuenta, cf.Ocodigo, c.Ecodigo, 0.00, 0.00, 0.00, 0.00, c.Cdescripcion, cm.Ctipo, cm.Cbalancen
					from CFuncional cf, CContables c, CtasMayor cm
					where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cfs.cfid#">
					  and c.Cformato like <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMascaraCuenta#">
					  and c.Cmovimiento = 'S'
					  and cm.Cmayor = c.Cmayor
					  and cm.Ecodigo = c.Ecodigo
					  and cm.Ctipo in ('I', 'G')
		  			  and cm.Csubtipo is not null
					  and not exists(select 1 from #cuentas# c2 where c2.ccuenta = c.Ccuenta and c2.ocodigo = cf.Ocodigo)
				</cfquery>
			</cfif>	

			<!--- 2.3 CFcuentainversion --->
			<cfif len(trim(cfs.CFcuentainversion))>
				<cfset LvarMascaraCuenta = mascara.AplicarMascara(cfs.CFcuentainversion, '_', '?')>
				<cfquery datasource="#session.DSN#">
					insert into #cuentas# (ccuenta, ocodigo, ecodigo, saldoini, saldofin, debitos, creditos, descripcion, ctipo, cbalancen)
					select c.Ccuenta, cf.Ocodigo, c.Ecodigo, 0.00, 0.00, 0.00, 0.00, c.Cdescripcion, cm.Ctipo, cm.Cbalancen
					from CFuncional cf, CContables c, CtasMayor cm
					where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cfs.cfid#">
					  and c.Cformato like <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMascaraCuenta#">
					  and c.Cmovimiento = 'S'
					  and cm.Cmayor = c.Cmayor
					  and cm.Ecodigo = c.Ecodigo
					  and cm.Ctipo in ('I', 'G')
		  			  and cm.Csubtipo is not null
					  and not exists(select 1 from #cuentas# c2 where c2.ccuenta = c.Ccuenta and c2.ocodigo = cf.Ocodigo)
				</cfquery>
			</cfif>	

			<!--- 2.4 CFcuentainventario --->
			<cfif len(trim(cfs.CFcuentainventario))>
				<cfset LvarMascaraCuenta = mascara.AplicarMascara(cfs.CFcuentainventario, '_', '?')>
				<cfquery datasource="#session.DSN#">
					insert into #cuentas# (ccuenta, ocodigo, ecodigo, saldoini, saldofin, debitos, creditos, descripcion, ctipo, cbalancen)
					select c.Ccuenta, cf.Ocodigo, c.Ecodigo, 0.00, 0.00, 0.00, 0.00, c.Cdescripcion, cm.Ctipo, cm.Cbalancen
					from CFuncional cf, CContables c, CtasMayor cm
					where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cfs.cfid#">
					  and c.Cformato like <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMascaraCuenta#">
					  and c.Cmovimiento = 'S'
					  and cm.Cmayor = c.Cmayor
					  and cm.Ecodigo = c.Ecodigo
					  and cm.Ctipo in ('I', 'G')
		  			  and cm.Csubtipo is not null
					  and not exists(select 1 from #cuentas# c2 where c2.ccuenta = c.Ccuenta and c2.ocodigo = cf.Ocodigo)
				</cfquery>
			</cfif>	
				
			<!--- 2.5 CFcuentaingreso --->
			<cfif len(trim(cfs.CFcuentaingreso))>
				<cfset LvarMascaraCuenta = mascara.AplicarMascara(cfs.CFcuentaingreso, '_', '?')>
				<cfquery datasource="#session.DSN#">
					insert into #cuentas# (ccuenta, ocodigo, ecodigo, saldoini, saldofin, debitos, creditos, descripcion, ctipo, cbalancen)
					select c.Ccuenta, cf.Ocodigo, c.Ecodigo, 0.00, 0.00, 0.00, 0.00, c.Cdescripcion, cm.Ctipo, cm.Cbalancen
					from CFuncional cf, CContables c, CtasMayor cm
					where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cfs.cfid#">
					  and c.Cformato like <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMascaraCuenta#">
					  and c.Cmovimiento = 'S'
					  and cm.Cmayor = c.Cmayor
					  and cm.Ecodigo = c.Ecodigo
					  and cm.Ctipo in ('I', 'G')
		  			  and cm.Csubtipo is not null
					  and not exists(select 1 from #cuentas# c2 where c2.ccuenta = c.Ccuenta and c2.ocodigo = cf.Ocodigo)
				</cfquery>
			</cfif>	
		</cfloop>

		<!---
		<cfquery name="datos" datasource="#session.DSN#">
			select c.Cmayor, c.Cformato, c1.ccuenta, c1.nivel, c1.ocodigo, c1.ecodigo, c1.cmayor, c1.csubtipo, c1.saldoini, c1.debitos, c1.creditos
			from #cuentas# c1
				inner join CContables c
					on c.Ccuenta = c1.ccuenta
			order by c.Cformato
		</cfquery>
		--->
		
		<!--- 3. ACTUALIZAR NIVEL DE LAS CUENTAS --->
		<cfquery datasource="#session.DSN#"	>
			update #cuentas#
			set nivel = coalesce((
					select max(n.PCDCniv)
					from PCDCatalogoCuenta n
					where n.Ccuenta = #cuentas#.ccuenta), 0)
		</cfquery>	
				
		<cfquery datasource="#session.DSN#"	>
			update #cuentas#
				set cmayor = Cmayor
			from CContables c
			where c.Ccuenta = #cuentas#.ccuenta
		</cfquery>

		<cfquery datasource="#session.DSN#"	>
			update #cuentas#
				set csubtipo = Csubtipo * 10
				from CtasMayor cm
				where cm.Cmayor = #cuentas#.cmayor
				  and cm.Ecodigo = #cuentas#.ecodigo
		</cfquery>

		<!--- Actualizacion de saldo inicial --->
		<cfquery datasource="#session.DSN#"	>
			update #cuentas#
			set saldoini = coalesce((
					select sum(SLinicial) 
					from SaldosContables 
					where Ccuenta = #cuentas#.ccuenta 
					  and Ocodigo = #cuentas#.ocodigo 
					  and Ecodigo = #cuentas#.ecodigo
					  and Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#"> 
					  and Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">), 0.00)
		</cfquery>			  

		<!--- Actualizacion de debitos --->
		<cfquery datasource="#session.DSN#"	>
			update #cuentas#
			set debitos = coalesce((
					select sum(DLdebitos) 
					from SaldosContables 
					where Ccuenta = #cuentas#.ccuenta 
					  and Ocodigo = #cuentas#.ocodigo 
					  and Ecodigo = #cuentas#.ecodigo
					  and Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#"> 
					  and Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">), 0.00)
		</cfquery>		  

		<!--- Actualizacion de creditos --->
		<cfquery datasource="#session.DSN#"	>
			update #cuentas#
			set creditos = coalesce((
					select sum(CLcreditos) 
					from SaldosContables 
					where Ccuenta = #cuentas#.ccuenta 
					  and Ocodigo = #cuentas#.ocodigo 
					  and Ecodigo = #cuentas#.ecodigo
					  and Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#"> 
					  and Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">), 0.00)
		</cfquery>

		<!--- 4. Sumarizacion / Mayorizacion de las cuentas a las cuentas padre --->		
		<cfquery datasource="#session.DSN#" name="x">
			insert into #cuentas#(ccuenta, nivel, ocodigo, ecodigo, cmayor, csubtipo, saldoini, saldofin, debitos, creditos)
			select n.Ccuentaniv, n.PCDCniv, c.ocodigo, c.ecodigo, c.cmayor, c.csubtipo, sum(saldoini), sum(saldofin), sum(debitos), sum(creditos)
			from #cuentas# c, PCDCatalogoCuenta n
			where n.Ccuenta = c.ccuenta
			  and n.Ccuentaniv <> c.ccuenta
			group by n.Ccuentaniv, n.PCDCniv, c.ocodigo, c.ecodigo, c.cmayor, c.csubtipo
		</cfquery>


		<!--- ==================================================================================== --->
		<!--- ==================================================================================== --->
		<!--- insert de los cortes  sin ccuenta valida o en cero ?????? --->
		<!--- Ni IDEA, supongo que es esto..... --->
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
			insert INTO #cuentas# (ecodigo, nivel, cmayor, descripcion, ccuenta, saldoini, saldofin, debitos, creditos, csubtipo, corte, ctipo, ntipo, cbalancen, ocodigo)
			values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
						0,
						'0', 
						'',
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#next_cuenta#">,
						0.00, 
						0.00,
						0.00, 
						0.00, 
						35,
						35,
						'I',
						'UTILIDAD BRUTA',
						'C',
						0 )
		</cfquery>
		<cfset next_cuenta = next_cuenta + 1>

		<!--- INSERTAR UTILIDAD ANTES DE IMPUESTOS LA CTA MAYOR APARECE CON UN 0 ASI QUE NO DEBE PINTARSE EN PANTALLA --->
		<cfquery name="rsUtil2" datasource="#Arguments.conexion#">
			insert INTO #cuentas# (ecodigo, nivel, cmayor, descripcion, ccuenta, saldoini, saldofin, debitos, creditos, csubtipo, corte, ctipo, ntipo, cbalancen, ocodigo)
			values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
						0,
						'0', 
						'',
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#next_cuenta#">,
						0.00, 
						0.00,
						0.00, 
						0.00, 
						55,
						55,
						'I',
						'UTILIDAD ANTES DE IMPUESTOS',
						'C',
						0 )
		</cfquery>
		<cfset next_cuenta = next_cuenta + 1>

		<!--- INSERTAR UTILIDAD ANTES DE IMPUESTOS LA CTA MAYOR APARECE CON UN 0 ASI QUE NO DEBE PINTARSE EN PANTALLA --->
		<cfquery name="rsUtil3" datasource="#Arguments.conexion#">
			insert INTO #cuentas# (ecodigo, nivel, cmayor, descripcion, ccuenta, saldoini, saldofin, debitos, creditos, csubtipo, corte, ctipo, ntipo, cbalancen, ocodigo)
			values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
						0,
						'0', 
						'',
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#next_cuenta#">,
						0.00, 
						0.00,
						0.00, 
						0.00, 
						85,
						85,
						'I',
						'UTILIDAD NETA',
						'C',
						0 )
		</cfquery>
		<!--- ==================================================================================== --->
		<!--- ==================================================================================== --->
		
		<!--- Actualizacion de cortes desde #cuentas ?????????? --->
		<!--- insertar los saldos de las cuentas de mayor ????????? --->

		<!--- borra datos en cero --->
		<cfquery datasource="#session.DSN#">
			delete from #cuentas#
			where saldoini = 0 
			  and debitos = 0 
			  and creditos = 0
			  <cfif isdefined("rsCuenta") and len(Trim(rsCuenta.ccuenta)) >
				  and #cuentas#.ccuenta < #rsCuenta.ccuenta#
			  </cfif>
		</cfquery>
		

<!---
<cfquery name="x" datasource="#Arguments.Conexion#">
	select * from #cuentas#
</cfquery>
<cfdump var="#x#">
--->


		<!--- Actualiza las descripciones de las cuentas que estan en null --->
		<cfquery datasource="#session.DSN#">
			update #cuentas#
			set descripcion = Cdescripcion
			from CContables
			where CContables.Ccuenta = #cuentas#.ccuenta
			and #cuentas#.descripcion is null
		</cfquery>


		<!--- 5. Esto esta en el sp de estado de resultados --->
		<!--- ==================================================================================== --->
		<!--- ==================================================================================== --->
		<!--- Esto va antes de 4 (linea 345) o despues (aqui) --->
		<cfquery datasource="#arguments.conexion#">
			update #cuentas# set saldofin = (saldoini + debitos - creditos)
		</cfquery>

		<!--- Actualizar UTILIDAD BRUTA --->
		<cfquery datasource="#arguments.conexion#">
			update #cuentas# 
				set saldofin = coalesce((
					select sum(saldofin)
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
				),0)
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
				),0)
			where csubtipo = 85
		</cfquery>
		


		<!--- ************ esto???? --->
		<!--- Cbalancen, Ctipo y Ntipo estan vacios no deberian llegar asi --->
		<cfquery datasource="#session.DSN#">
			update #cuentas#
			set cbalancen=CtasMayor.Cbalancen,
			    ctipo=CtasMayor.Ctipo,
				corte = csubtipo
			from CtasMayor 
			where #cuentas#.cmayor=CtasMayor.Cmayor
			and #cuentas#.cbalancen is null
			and #cuentas#.ctipo is null
		</cfquery>
		
		
		<cfquery datasource="#arguments.conexion#">
			update #cuentas#
				set saldofin = (saldofin * -1)
			where cbalancen = 'C'
		</cfquery>
		
		<cfquery datasource="#arguments.conexion#">
			delete from #cuentas# 
			where saldofin = 0.00
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
	
		<!---
		<cfquery name="datos" datasource="#session.DSN#">
			select  c1.descripcion as descrip, 
					c.Cformato as formato, 
					c1.ccuenta, 
					c1.nivel, 
					c1.ecodigo, 
					c1.cmayor as mayor, 
					c1.csubtipo as subtipo, 
					coalesce(c1.ntipo, 'Ingresos') as ntipo, 
					coalesce(c1.ctipo, 'I') as tipo, 
					coalesce(c1.corte, 10) as corte,
					coalesce(c1.cbalancen, 'C') as cbalancen,
					sum(c1.saldoini) as saldoini,
					sum(c1.saldofin) as saldofin, 
					sum(c1.debitos) as debitos, 
					sum(c1.creditos) as creditos
			from #cuentas# c1
				inner join CContables c
					on c.Ccuenta = c1.ccuenta
					
			where nivel <= #arguments.nivel#		
			group by c1.descripcion, c.Cformato, c1.ccuenta, c1.nivel, c1.ecodigo, c1.cmayor, c1.csubtipo, c1.ntipo, c1.ctipo, c1.corte, c1.cbalancen
			order by corte, cmayor, Cformato
		</cfquery>
		--->

		<cfquery name="datos" datasource="#session.DSN#">
			select  c1.descripcion as descrip, 
				c.Cformato as formato, 
				c1.nivel, 
				c1.ecodigo, 
				c1.cmayor as mayor, 
				c1.csubtipo as subtipo, 
				c1.ntipo, 
				c1.ctipo as tipo, 
				c1.corte,
				c1.cbalancen,
				sum(c1.saldoini) as saldoini,
				sum(c1.saldofin) as saldofin, 
				sum(c1.debitos) as debitos, 
				sum(c1.creditos) as creditos
			from #cuentas# c1
				inner join CContables c
					on c.Ccuenta = c1.ccuenta
					
			where nivel <= #arguments.nivel#		
			group by c1.corte, c1.cmayor, c.Cformato, c1.descripcion, c1.nivel, c1.ecodigo, c1.csubtipo, c1.ntipo, c1.ctipo, c1.cbalancen
			order by c1.corte, c1.cmayor, c.Cformato
		</cfquery>
		<cfreturn datos >
	</cffunction>
</cfcomponent>