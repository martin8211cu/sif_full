<cfcomponent>

    <!--- 1. Validacion para ver si no hay otra balanza de comprobacion SAT en el mismo mes a generar--->
	<cffunction name="ValidaBalCompSAT" access="public">
    	<cfargument name="Periodo" 	type="numeric" required="true">
        <cfargument name="Mes" 		type="numeric" required="true">
        <cfargument name="Ecodigo"	type="numeric" default="#session.Ecodigo#">
		<cfargument name="GEid"		type="numeric" default="-1">


    	<cfquery name="rsValidaBalCompSAT" datasource="#session.DSN#">
    		SELECT COUNT(1) as CantBalanza
			FROM CEBalanzaSAT
			WHERE CEBperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Periodo#">
				and CEBmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mes#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                and CEBestatus >= 1
		and GEid = #Arguments.GEid#
    	</cfquery>

        <cfif isdefined('rsValidaBalCompSAT') and rsValidaBalCompSAT.CantBalanza GTE 1>
			<cf_errorCode code = "80000" msg  = "Ya existe una balanza de comprobacion">
    	</cfif>
  	</cffunction>

    <cffunction name="ConBalCompSAT" access="public" returntype="numeric">
    	<cfargument name="Periodo" 	type="numeric" required="true">
        <cfargument name="Mes" 		type="numeric" required="true">
        <cfargument name="Ecodigo"	type="numeric" default="#session.Ecodigo#">
		<cfargument name="GEid"		type="numeric" default="-1">


    	<cfquery name="ConBalCompSAT" datasource="#session.DSN#">
    		SELECT top 1 CEBalanzaId
			FROM CEBalanzaSAT
			WHERE CEBperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Periodo#">
				and CEBmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mes#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                and CEBestatus >= 1
		and GEid = #Arguments.GEid#
    	</cfquery>

        <cfif isdefined('ConBalCompSAT') and ConBalCompSAT.RecordCount EQ 1>
			<cfreturn #ConBalCompSAT.CEBalanzaId#>
        <cfelse>
        	<cfreturn -1>
    	</cfif>
  	</cffunction>

    <cffunction name="EstBalCompSAT" access="public" returntype="numeric">
    	<cfargument name="Periodo" 	type="numeric" required="true">
        <cfargument name="Mes" 		type="numeric" required="true">
        <cfargument name="Ecodigo"	type="numeric" default="#session.Ecodigo#">
		<cfargument name="GEid"		type="numeric" default="-1">


    	<cfquery name="EstBalCompSAT" datasource="#session.DSN#">
    		SELECT CEBalanzaId,CEBestatus
			FROM CEBalanzaSAT
			WHERE CEBperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Periodo#">
				and CEBmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mes#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                and CEBestatus > 0
		and GEid = #Arguments.GEid#
    	</cfquery>

        <cfif isdefined('EstBalCompSAT') and EstBalCompSAT.RecordCount GT 0>
			<cfreturn #EstBalCompSAT.RecordCount#>
        <cfelse>
        	<cfreturn 0>
    	</cfif>
  	</cffunction>

    <!--- 2. Validacion para ver si existe una balanza de comprobacion SAT en el mes anterior a generar--->
    <cffunction name="ValidaBalCompSATMesAnt" access="public">
    	<cfargument name="Periodo" 	type="numeric" required="true">
        <cfargument name="Mes" 		type="numeric" required="true">
        <cfargument name="Ecodigo"	type="numeric" default="#session.Ecodigo#">
		<cfargument name="GEid"		type="numeric" default="-1">

    	<cfquery name="rsValidaBalCompSATMesAnt" datasource="#session.DSN#">
    		SELECT COUNT(1) as CantBalanza
			FROM CEBalanzaSAT
			WHERE CEBperiodo = <cfif isdefined('Mes') and Mes EQ 1>
        				   	   	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Periodo#"> - 1
                           	   <cfelse>
                           		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Periodo#">
                           	   </cfif>
				and CEBmes = <cfif isdefined('Mes') and Mes EQ 1>
            					<cfqueryparam cfsqltype="cf_sql_numeric" value="12">
            			 	 <cfelse>
            			 		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mes#"> - 1
                         	 </cfif>
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and GEid = #Arguments.GEid#
    	</cfquery>

        <cfif isdefined('rsValidaBalCompSATMesAnt') and rsValidaBalCompSATMesAnt.CantBalanza EQ 0>
            <cf_errorCode code = "80001" msg  = "No existe ninguna balanza de comprobacion anterior al mes a generar">
        </cfif>
    </cffunction>

    <!--- 3. Validacion para ver si existe una balanza de comprobacion SAT en el mes posterior a generar--->
    <cffunction name="ValidaBalCompSATMesPost" access="public">
    	<cfargument name="Periodo" 	type="numeric" required="true">
        <cfargument name="Mes" 		type="numeric" required="true">
        <cfargument name="Ecodigo"	type="numeric" default="#session.Ecodigo#">
		<cfargument name="GEid"		type="numeric" default="-1">

         <cfset FechaVal = CreateDate(#Periodo#,#Mes#,01)>

        <cfquery name="rsValidaBalCompSATMesPost" datasource="#session.DSN#">
    		SELECT DATEDIFF(MONTH,(cast(cast(CEBperiodo as varchar) + '-' + RIGHT('00' + cast(CEBmes as varchar),2) + '-01' as datetime))
               ,<cfqueryparam cfsqltype="cf_sql_date" value="#FechaVal#">) as MesTrans
            FROM(
                    SELECT MAX(CEBalanzaId) AS idBalCompSAT
                    FROM CEBalanzaSAT
                    WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and GEid = #Arguments.GEid#
	    ) as BalCompSAT
            inner JOIN CEBalanzaSAT a
                on BalCompSAT.idBalCompSAT= a.CEBalanzaId
        	WHERE a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and a.GEid = #Arguments.GEid#
    	</cfquery>

        <cfif isdefined('rsValidaBalCompSATMesPost') and rsValidaBalCompSATMesPost.MesTrans LT 0 and rsValidaBalCompSATMesPost.RecordCount GT 0>
        	<cf_errorCode code = "80002" msg  = "Ya existe una balanza de comprobacion posterior al mes a generar">
        </cfif>
     </cffunction>


     <cffunction name="GenerarBalCompSAT" access="public" returntype="numeric">
    	<cfargument name="idBalComp" 	type="numeric" 		required="true">
        <cfargument name="Nivel" 	 	type="numeric" 		required="true" 	default="-1">
        <cfargument name="Periodo" 		type="numeric" 		required="true">
        <cfargument name="Mes" 			type="numeric" 		required="true">
        <cfargument name="idAgrupador" 	type="string">
        <cfargument name="Mcodigo" 		type="numeric">
        <cfargument name="TipoMoneda" 	type="string">
		<cfargument name="idBalCompAnt"	type="string" 		required="false"	default="-1">
		<cfargument name="GEid"		type="numeric" default="-1">

		 <cfquery datasource="#session.DSN#" name="rsTipo">
			SELECT  isnull(max(isnull(CEBTipo,-1)+1),0) CEBTipo
			FROM    CEBalanzaSAT
			WHERE CEBperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Periodo#">
				and CEBmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mes#">
    			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and CEBestatus > 0
                and CETipoMoneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TipoMoneda#">
				and GEid = #Arguments.GEid#
		</cfquery>

		<!--- eliminar balanzas que no se han preparado --->
		<cfquery name="delBalCompSAT" datasource="#session.DSN#">
        	DELETE
            FROM CEBalanzaDetSAT
            WHERE CEBalanzaId IN(
							SELECT CEBalanzaId
							FROM CEBalanzaSAT
							WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								AND CEBestatus = 0
								and GEid = #Arguments.GEid#
						)
    	</cfquery>
        <cfquery name="delBalCompSAT" datasource="#session.DSN#">
        	DELETE
            FROM CEBalanzaSAT
            WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            	AND CEBestatus = 0
				and GEid = #Arguments.GEid#
    	</cfquery>

        <cfquery datasource="#session.DSN#" name="rsCtasOrden">
			select isnull(Pvalor,'N') as Pvalor
			from Parametros
			where Pcodigo = 200081
    			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<cfquery name="rsBalDif" datasource="#Session.DSN#">
			SELECT Pvalor FROM Parametros WHERE Pcodigo = 200084 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfset balDif = "N">
		<cfif #rsBalDif.RecordCount#  neq 0>
			<cfset balDif = rsBalDif.Pvalor>
		</cfif>

		<cfset hayCambio = "N">
		<cfif rsTipo.CEBTipo GT 0>
			<!--- verificando si hay cambios --->
	    	<cfquery name="rsCambios" datasource="#session.DSN#">
		    	select Ccuenta,SLinicial,DLdebitos,CLcreditos
		    	from (
					select  bd.Ccuenta,bal.saldoini SLinicial,bal.debitos DLdebitos,bal.creditos CLcreditos
					from CEBalanzaSAT b
					inner join CEBalanzaDetSAT bd
						on b.CEBalanzaId = bd.CEBalanzaId
					inner join (
						select <!--- <cfqueryparam cfsqltype="cf_sql_numeric" value="#insBalCompSAT.identity#">, --->
							min(a.Ecodigo) as Ecodigo,
							min(a.Ccuenta) as Ccuenta,
							min(#Arguments.Periodo#) as Periodo,
							min(#Arguments.Mes#) as Mes,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#"> Mcodigo,
							sum(a.saldoini) as saldoini,
			            	sum(a.debitos) as debitos,
			            	sum(a.creditos) as creditos,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> Usucodigo
						from DCGRBalanceComprobacion a
			        		inner join CContables b
			        			on a.Ccuenta = b.Ccuenta
			        			and a.Ecodigo = b.Ecodigo
			            <cfif isdefined('rsCtasOrden') and rsCtasOrden.RecordCount GT 0 and rsCtasOrden.Pvalor EQ 'N'>
			                inner join CtasMayor c
			                	on c.Cmayor = b.Cmayor
			                	and c.Ecodigo = b.Ecodigo
			                	and c.Ctipo <> 'O'
			            </cfif>
			            	left join CEInactivas d on
			                	d.Ccuenta = b.Ccuenta and
			                    d.Ecodigo = b.Ecodigo
						where CGRBCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalComp#">
			        	<cfif isdefined('Arguments.Nivel') and #Arguments.Nivel# EQ -1>
			        		and b.Cmovimiento = 'S'
			      		</cfif>
			            	and d.Ccuenta is null
			                and d.Ecodigo is null
						group by
							a.corte,a.nivel,a.tipo,a.ntipo,a.mayor,a.descrip,a.formato,
							a.rango,a.totdebitos,a.totcreditos,a.totmovmes,a.totsaldofin,b.Cmovimiento
					) bal
						on bal.Ccuenta = bd.Ccuenta
						and bal.Ecodigo = bd.Ecodigo
					where b.CEBperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Periodo#">
						and b.CEBmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Mes#">
						and b.CEBTipo = 0
                        and b.CETipoMoneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TipoMoneda#">
						and (bd.SLinicial <> bal.saldoini
							or bd.DLdebitos <> bal.debitos
							or bd.CLcreditos <> bal.creditos)
							and b.GEid = #Arguments.GEid#
				) bald
				union all
				select  bal2.Ccuenta, bal2.saldoini SLinicial, bal2.debitos DLdebitos, bal2.creditos CLcreditos
				from (
			 		select b2.CEBalanzaId, b2.CEBTipo, bd2.Ccuenta from CEBalanzaSAT b2
			 		inner join CEBalanzaDetSAT bd2 on b2.CEBalanzaId = bd2.CEBalanzaId
			 		where b2.CEBTipo = 0
                    	and b2.CETipoMoneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TipoMoneda#">
			 			and b2.CEBperiodo = #Arguments.Periodo# and b2.CEBmes = #Arguments.Mes#
			 			and b2.GEid = #Arguments.GEid#
			 	) bal1
				right join (
					select <!--- <cfqueryparam cfsqltype="cf_sql_numeric" value="#insBalCompSAT.identity#">, --->
						min(a.Ecodigo) as Ecodigo,
						min(a.Ccuenta) as Ccuenta,
						min(#Arguments.Periodo#) as Periodo,
						min(#Arguments.Mes#) as Mes,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#"> Mcodigo,
						sum(a.saldoini) as saldoini,
		            	sum(a.debitos) as debitos,
		            	sum(a.creditos) as creditos,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> Usucodigo
					from DCGRBalanceComprobacion a
		        		inner join CContables b on
		                	a.Ccuenta = b.Ccuenta and
		                    a.Ecodigo = b.Ecodigo
		            <cfif isdefined('rsCtasOrden') and rsCtasOrden.RecordCount GT 0 and rsCtasOrden.Pvalor EQ 'N'>
		                inner join CtasMayor c on
		                	c.Cmayor = b.Cmayor and
		                    c.Ecodigo = b.Ecodigo and
		                    c.Ctipo <> 'O'
		            </cfif>
		            	left join CEInactivas d on
		                	d.Ccuenta = b.Ccuenta and
		                    d.Ecodigo = b.Ecodigo
					where CGRBCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalComp#">
		        	<cfif isdefined('Arguments.Nivel') and #Arguments.Nivel# EQ -1>
		        		and b.Cmovimiento = 'S'
		      		</cfif>
		            	and d.Ccuenta is null
		                and d.Ecodigo is null
					group by
						a.corte,a.nivel,a.tipo,a.ntipo,a.mayor,a.descrip,a.formato,
						a.rango,a.totdebitos,a.totcreditos,a.totmovmes,a.totsaldofin,b.Cmovimiento
				) bal2
					on bal2.Ccuenta = bal1.Ccuenta
				where bal2.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Periodo#">
					and bal2.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Mes#">
					and bal2.Ecodigo = #Session.Ecodigo#
					and bal1.Ccuenta is null
			</cfquery>
           <!--- <cf_dump var = "#rsCambios#">--->
			<cfif rsCambios.recordCount GT 0>
				<cfset hayCambio = "S">
			</cfif>
		<cfelse>
			<cfset hayCambio = "S">
		</cfif>
		<!---SML 16042015. Se agrego un nuevo campo llamado CETipoMoneda en la tabla CEBalanzaSAT, para que se registre el tipo de moneda que se utilizo para generar la Balanza de Comprobación para el SAT. Este será de Tipo char para que se especifique la letra inicial del Tipo de Moneda. Los valores que hasta ahorita se utilizarán serán los siguientes:
		'L' para moneda Local
		'I' para moneda Informe--->
		<cfif hayCambio EQ "S">
	        <cfquery name="insBalCompSAT" datasource="#session.DSN#">
	            insert into CEBalanzaSAT (Ecodigo,CEBperiodo,CEBmes,CAgrupador,CEBestatus,FechaGenera,BMUsucodigo,CEBTipo,CETipoMoneda,GEid)
	            values  (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
	                     <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Periodo#">,
	                     <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Mes#">,
	                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idAgrupador#">,
	                     <cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
	                     <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(now(),"YYYY/MM/DD")#">,
	                     <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">,
			 			 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTipo.CEBTipo#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TipoMoneda#">,
			 			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEid#">)
	           <cf_dbidentity1 datasource="#session.DSN#">
	    	</cfquery>
	    	<cf_dbidentity2 datasource="#session.DSN#" name="insBalCompSAT">
	    	<cfset idBalCompSAT = #insBalCompSAT.identity#>

	        <cfquery name="insBalDetCompSAT" datasource="#session.DSN#">
	            <!--- insert into CEBalanzaDetSAT(CEBalanzaId,Ecodigo,Ccuenta,CEBperiodo,CEBmes,Mcodigo,SLinicial,
	                                            DLdebitos,CLcreditos,BMUsucodigo) --->
				select
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#insBalCompSAT.identity#">,
					#Session.Ecodigo# as Ecodigo,
					Ccuenta,
					#Arguments.Periodo# as Periodo,
					#Arguments.Mes# as Mes,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">,
					SLinicial,
	            	DLdebitos,
	            	CLcreditos,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
   				from (
					select  bal.Ccuenta,bal.saldoini SLinicial,bal.debitos DLdebitos,bal.creditos CLcreditos
					from CEBalanzaSAT b
					inner join CEBalanzaDetSAT bd
						on b.CEBalanzaId = bd.CEBalanzaId
					right join (
						select <!--- <cfqueryparam cfsqltype="cf_sql_numeric" value="#insBalCompSAT.identity#">, --->
							min(a.Ecodigo) as Ecodigo,
							min(a.Ccuenta) as Ccuenta,
							min(#Arguments.Periodo#) as Periodo,
							min(#Arguments.Mes#) as Mes,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#"> Mcodigo,
							sum(a.saldoini) as saldoini,
			            	sum(a.debitos) as debitos,
			            	sum(a.creditos) as creditos,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> Usucodigo
						from DCGRBalanceComprobacion a
			        		inner join CContables b
			        			on a.Ccuenta = b.Ccuenta
			        			<cfif Arguments.GEid EQ -1>
			        				and a.Ecodigo = b.Ecodigo
			        			</cfif>
			            <cfif isdefined('rsCtasOrden') and rsCtasOrden.RecordCount GT 0 and rsCtasOrden.Pvalor EQ 'N'>
			                inner join CtasMayor c on
			                	c.Cmayor = b.Cmayor and
			                    c.Ecodigo = b.Ecodigo and
			                    c.Ctipo <> 'O'
			            </cfif>
			            	left join CEInactivas d
			            		on d.Ccuenta = b.Ccuenta
			            		and d.Ecodigo = b.Ecodigo
			                    and d.GEid = #Arguments.GEid#
						where CGRBCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalComp#">
			        	<cfif isdefined('Arguments.Nivel') and #Arguments.Nivel# EQ -1>
			        		and b.Cmovimiento = 'S'
			      		</cfif>
			            	and d.Ccuenta is null
			                and d.Ecodigo is null
						group by
							a.corte,a.nivel,a.tipo,a.ntipo,a.mayor,a.descrip,a.formato,
							a.rango,a.totdebitos,a.totcreditos,a.totmovmes,a.totsaldofin,b.Cmovimiento
					) bal
						on bal.Ccuenta = bd.Ccuenta
						and bal.Ecodigo = bd.Ecodigo
					where b.CEBperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Periodo#">
						and b.CEBmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Mes#">
						and b.CEBTipo = 0
						and exists (select 1 from CEMapeoSAT a where bd.Ccuenta = a.Ccuenta and bd.Ecodigo = a.Ecodigo and a.CAgrupador = '#Arguments.idAgrupador#')
						<cfif (balDif EQ "S" and rsTipo.CEBTipo GT 0)>
						and (bd.SLinicial <> bal.saldoini
							or bd.DLdebitos <> bal.debitos
							or bd.CLcreditos <> bal.creditos)
						</cfif>
				) bald
				union all
				select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#insBalCompSAT.identity#">,
					#Session.Ecodigo# as Ecodigo,
					bal2.Ccuenta,
					#Arguments.Periodo# as Periodo,
					#Arguments.Mes# as Mes,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">,
					bal2.saldoini SLinicial,
	            	bal2.debitos DLdebitos,
	            	bal2.creditos CLcreditos,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				from (
			 		select b2.CEBalanzaId, b2.CEBTipo, bd2.Ccuenta from CEBalanzaSAT b2
			 		inner join CEBalanzaDetSAT bd2 on b2.CEBalanzaId = bd2.CEBalanzaId
			 		where b2.CEBTipo = 0
			 			and b2.CEBperiodo = #Arguments.Periodo# and b2.CEBmes = #Arguments.Mes#
			 	) bal1
				right join (
					select <!--- <cfqueryparam cfsqltype="cf_sql_numeric" value="#insBalCompSAT.identity#">, --->
						min(a.Ecodigo) as Ecodigo,
						min(a.Ccuenta) as Ccuenta,
						min(#Arguments.Periodo#) as Periodo,
						min(#Arguments.Mes#) as Mes,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#"> Mcodigo,
						sum(a.saldoini) as saldoini,
		            	sum(a.debitos) as debitos,
		            	sum(a.creditos) as creditos,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> Usucodigo
					from DCGRBalanceComprobacion a
		        		inner join CContables b on
		                	a.Ccuenta = b.Ccuenta and
		                    a.Ecodigo = b.Ecodigo
		            <cfif isdefined('rsCtasOrden') and rsCtasOrden.RecordCount GT 0 and rsCtasOrden.Pvalor EQ 'N'>
		                inner join CtasMayor c on
		                	c.Cmayor = b.Cmayor and
		                    c.Ecodigo = b.Ecodigo and
		                    c.Ctipo <> 'O'
		            </cfif>
		            	left join CEInactivas d on
		                	d.Ccuenta = b.Ccuenta and
		                    d.Ecodigo = b.Ecodigo
					where CGRBCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalComp#">
		        	<cfif isdefined('Arguments.Nivel') and #Arguments.Nivel# EQ -1>
		        		and b.Cmovimiento = 'S'
		      		</cfif>
		            	and d.Ccuenta is null
		                and d.Ecodigo is null
					group by
						a.corte,a.nivel,a.tipo,a.ntipo,a.mayor,a.descrip,a.formato,
						a.rango,a.totdebitos,a.totcreditos,a.totmovmes,a.totsaldofin,b.Cmovimiento
				) bal2
					on bal2.Ccuenta = bal1.Ccuenta
				where bal2.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Periodo#">
					and bal2.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Mes#">
					and bal2.Ecodigo = #Session.Ecodigo#
					and bal1.Ccuenta is null
					and exists (select 1 from CEMapeoSAT a where bal2.Ccuenta = a.Ccuenta and bal2.Ecodigo = a.Ecodigo and a.CAgrupador = '#Arguments.idAgrupador#' and a.GEid = #Arguments.GEid#)
					and not exists
						(select 1
						from CContables cm
						where cm.Cformato = cm.Cmayor
						and not exists (select 1 from CContables ccm where ccm.Cpadre = cm.Ccuenta)
						and cm.Ecodigo = bal2.Ecodigo
						and cm.Ccuenta = bal2.Ccuenta)
	        </cfquery>
<cf_dump var="#insBalDetCompSAT#">
	    <cfelse>
			<cfquery name="insBalCompSAT" datasource="#session.DSN#">
				select  max(b.CEBalanzaId) CEBalanzaId
				from CEBalanzaSAT b
				where b.CEBperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Periodo#">
					and b.CEBmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Mes#">
					and b.GEid = #Arguments.GEid#
			</cfquery>
			<cfif Arguments.idBalCompAnt NEQ "-1">
				<cfset idBalCompSAT = #Arguments.idBalCompAnt#>
			<cfelse>
			<cfset idBalCompSAT = #insBalCompSAT.CEBalanzaId#>
		</cfif>

		</cfif>
        <cfreturn #idBalCompSAT#>
     </cffunction>

      <cffunction name="BalCompSAT" access="public" returntype="query">
    	<cfargument name="idBalComp" 	type="numeric" 		required="true">
        <cfargument name="Periodo" 		type="numeric">
        <cfargument name="Mes" 			type="numeric">

        <cfquery name="rsReporte" datasource="#session.DSN#">
            SELECT a.Ccuenta,b.Cformato as formato,b.Cdescripcion as descrip,SLinicial as saldoini,DLdebitos as debitos,
                    CLcreditos as creditos,(SLinicial+DLdebitos-CLcreditos) as saldofin, CONVERT(VARCHAR(10),FechaGenera,126) as FechaGenera,
                    CASE WHEN coalesce(c.CEBTipo,0) = 0 THEN 'N'
                    	 WHEN coalesce(c.CEBTipo,0) > 0 THEN 'C'
					END as CEBTipo,c.Sello,c.CodCertificado,c.Certificado
            FROM CEBalanzaDetSAT a
            	inner join CEBalanzaSAT c on c.CEBalanzaId = a.CEBalanzaId and c.Ecodigo = a.Ecodigo
                inner JOIN CContables b on a.Ccuenta = b.Ccuenta AND a.Ecodigo = b.Ecodigo
            where a.CEBalanzaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalComp#">
            	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                <cfif isdefined('Arguments.Mes') and len(trim(Arguments.Mes)) GT 0>
                and a.CEBmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mes#">
                </cfif>
                <cfif isdefined('Arguments.Periodo') and len(trim(Arguments.Periodo)) GT 0>
                and a.CEBperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Periodo#">
                </cfif>
                ORDER BY b.Cmayor, b.Cformato
		</cfquery>

        <cfreturn #rsReporte#>
     </cffunction>

     <cffunction name="PrepararBalCompSAT" access="public" returntype="void">
    	<cfargument name="idBalComp" 	type="numeric" 		required="true">

        <cfquery name="insBalCompSAT" datasource="#session.DSN#">
        	UPDATE CEBalanzaSAT
				SET CEBestatus = 1
			WHERE Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				AND CEBalanzaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalComp#">
    	</cfquery>
     </cffunction>

     <cffunction name="EliminarBalCompSAT" access="public" returntype="void">
    	<cfargument name="Periodo" 	type="numeric" required="true">
        <cfargument name="Mes" 		type="numeric" required="true">
        <cfargument name="Ecodigo"	type="numeric" default="#session.Ecodigo#">
		<cfargument name="GEid"		type="numeric" default="-1">

        <cfquery name="delBalCompSAT" datasource="#session.DSN#">
        	DELETE
            FROM CEBalanzaDetSAT
            WHERE CEBalanzaId IN(
							SELECT CEBalanzaId
							FROM CEBalanzaSAT
							WHERE CEBperiodo >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Periodo#">
								AND CEBmes >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mes#">
								AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								AND CEBestatus = 0
								and GEid = #Arguments.GEid#
							)
    	</cfquery>

        <cfquery name="delBalCompSAT" datasource="#session.DSN#">
        	DELETE
            FROM CEBalanzaSAT
            WHERE CEBperiodo >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Periodo#">
	            AND CEBmes >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mes#">
	            AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	            AND CEBestatus = 0
		    and GEid = #Arguments.GEid#
    	</cfquery>
     </cffunction>

     <cffunction name="ValPreBalCompSATA" access="public">
    	<cfargument name="idBalComp" 	type="numeric" 		required="true">
        <cfargument name="Periodo" 		type="numeric">
        <cfargument name="Mes" 			type="numeric">

        <cfquery name="rsValBalCompSATA" datasource="#session.DSN#">
        	SELECT top 1 a.CEBestatus
            FROM
             CEBalanzaSAT a,
                (SELECT CEBmes,CEBperiodo,CEBalanzaId,CETipoMoneda
                 FROM CEBalanzaSAT
                 WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                 <cfif isdefined('Arguments.idBalComp') and len(trim(#Arguments.idBalComp#)) GT 0>
                 	and CEBalanzaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idBalComp#">
                 </cfif>
                 <cfif isdefined('Arguments.Periodo') and len(trim(#Arguments.Periodo#)) GT 0>
                 	and CEBperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Periodo#">
                 </cfif>
                 <cfif isdefined('Arguments.Mes') and len(trim(#Arguments.Mes#)) GT 0>
                 	and CEBmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mes#">
                 </cfif> ) as BalComSAT
            WHERE a.CEBmes = ( CASE WHEN BalComSAT.CEBmes = 1
                                      THEN 12
                               ELSE BalComSAT.CEBmes - 1
                               END)
                and a.CEBperiodo <= BalComSAT.CEBperiodo
                and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    	</cfquery>

        <cfif isdefined('rsValBalCompSATA') and ((rsValBalCompSATA.RecordCount GT 0 and rsValBalCompSATA.CEBestatus EQ 0) or rsValBalCompSATA.RecordCount EQ 0)>
        	<cf_errorCode code = "80004" msg  = "No se ha preparado la balanza de comprobaci&oacute;n del mes anterior">
        </cfif>
     </cffunction>

     <cffunction name="ValPreBalCompSATP" access="public">
    	<cfargument name="idBalComp" 	type="numeric">
        <cfargument name="Periodo" 		type="numeric">
        <cfargument name="Mes" 			type="numeric">

        <cfquery name="rsValBalCompSATP" datasource="#session.DSN#">
        	SELECT top 1 a.CEBestatus
            FROM
             CEBalanzaSAT a,
                (SELECT CEBmes,CEBperiodo,CEBalanzaId,CETipoMoneda
                 FROM CEBalanzaSAT
                 WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                 <cfif isdefined('Arguments.idBalComp') and len(trim(#Arguments.idBalComp#)) GT 0>
                 	and CEBalanzaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idBalComp#">
                 </cfif>
                 <cfif isdefined('Arguments.Periodo') and len(trim(#Arguments.Periodo#)) GT 0>
                 	and CEBperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Periodo#">
                 </cfif>
                 <cfif isdefined('Arguments.Mes') and len(trim(#Arguments.Mes#)) GT 0>
                 	and CEBmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mes#">
                 </cfif>
                    ) as BalComSAT
            WHERE a.CEBmes = ( CASE WHEN BalComSAT.CEBmes = 12
                                      THEN 1
                               ELSE BalComSAT.CEBmes + 1
                               END)
                and a.CEBperiodo >= BalComSAT.CEBperiodo
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    	</cfquery>

        <cfif isdefined('rsValBalCompSATP') and rsValBalCompSATP.RecordCount GT 0 and rsValBalCompSATP.CEBestatus GTE 1>
        	<cf_errorCode code = "80005" msg  = "Existen balanzas de comprobaci&oacute;n en estado de preparaci&oacute;n para meses posteriores">
        </cfif>
     </cffunction>

</cfcomponent>