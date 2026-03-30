<cfcomponent>
<!--- Variables Globales --->
<cfset GvarConexion  = Session.Dsn>
<cfset GvarEcodigo   = Session.Ecodigo>	
<cfset GvarUsuario   = Session.Usuario>
<cfset GvarUsucodigo = Session.Usucodigo>
<cfset GvarEcodigoSDC= Session.EcodigoSDC>
<cfset GvarEnombre   = Session.Enombre>
<cfset GvarMinFecha  = DateAdd('yyyy',-50,Now())>
<cfset GvarCuentaManual = true> 
	
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cffunction name="Valida_CompromisosObligatorios" access="public"  output="no">
	<cfargument name="Num_Nomina" required="yes" type="string">
	<cfargument name="Periodo" required="yes" type="numeric">
	<cfargument name="Mes" required="yes" type="numeric">
	<cfargument name="ID" required="yes" type="numeric">
	<cfargument name="Ocodigo" required="yes" type="numeric">
	<cfargument name="Oficodigo" required="yes" type="string">
	<cfargument name="Fecha_Nom" required="yes" type="date">		
														
	<!--- Variables Validadas de Solicitud de Pago que se generará --->
	<cfset ValidAux			= getValidAux(#GvarEcodigo#)>	
							
	<cftry>
		<!----Valida de existan un compromiso para todas las cuentas del catálogo de cuentas con compromiso obligatorio--->	
		<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjControl.CreaTablaIntPresupuesto(#GvarConexion#,true)>

		<cfset PerMes = #Arguments.Periodo#*100+#Arguments.Mes#>
	
		<cfquery name="rsPeriodoPres" datasource="#GvarConexion#">
			select CPPid, CPPestado, Ecodigo, Mcodigo, CPPanoMesDesde, CPPanoMesHasta,
			case CPPtipoPeriodo when 1 then 1 
				when 2 then 2 
				when 3 then 3 
				when 4 then 4 
				when 6 then 6 
				when 12 then 12 
				else 0 end as Num_Meses, 
			left(CPPanoMesDesde,4) as Periodo, 
			right(CPPanoMesDesde,2)as Mes
			from CPresupuestoPeriodo  
			where CPPanoMesDesde <= <cfqueryparam cfsqltype="cf_sql_integer" value="#PerMes#"> 
			and CPPanoMesHasta >= <cfqueryparam cfsqltype="cf_sql_integer" value="#PerMes#"> 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">  
		</cfquery>
		 
		<cfset Meses = 	rsPeriodoPres.Num_Meses>
		<cfset CPPid = 	rsPeriodoPres.CPPid>
		<cfset PerIni = rsPeriodoPres.Periodo>
		<cfset MesIni = rsPeriodoPres.Mes>
	
		<cfquery name="rsCtasObligatoriasComp" datasource="#GvarConexion#"> 
			SELECT distinct a.CPcuenta, a.CPformato, a.CPdescripcion, c.CPCCmascara, a.Cmayor, CPCPtipoControl, CPCPcalculoControl
                from CPresupuesto a
                inner join(
                    SELECT  d.CPcuenta, d.CPformato
                         from #sifinterfacesdb#..ID925 a
                         inner join CFinanciera b
                            on a.CFformato = b.CFformato
                         inner join CPresupuesto d
                            on b.CPcuenta = d.CPcuenta
                         where a.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ID#">
                         and d.CPmovimiento = 'S'
                         and a.Gasto = 1
                     ) g
                     on g.CPcuenta = a.CPcuenta
                inner join  CPresupuestoObligatorias b
                    on a.CPformato LIKE b.CPCCmascara
                    AND LEN(a.CPformato) = LEN(b.CPCCmascara)
                    AND a.Ecodigo = b.Ecodigo
				inner join(
					select i.CPcuenta,
						min(p.CPCPtipoControl) as CPCPtipoControl,
						min(p.CPCPcalculoControl) as CPCPcalculoControl                        
                    from CPresupuesto i
					inner join CPCuentaPeriodo p
						on p.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">  
					    and p.CPPid         = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPPid#">
						and p.CPcuenta    = i.CPcuenta
					group by
                        i.CPcuenta
					) f
                  on f.CPcuenta = a.CPcuenta
                left join (SELECT CPPid,CPCCmascara,Ecodigo
                            from CPresupuestoComprAut) c
                    on b.Ecodigo = c.Ecodigo
                    and b.CPPid = c.CPPid
                    AND a.CPformato = c.CPCCmascara
                where c.CPCCmascara IS null
                AND b.CPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CPPid#">
		</cfquery>
	
		<cfquery name="rsSQLNAP" datasource="#GvarConexion#">
		    select count(*) as ultimo 
    		  from CPNAP
		      where Ecodigo 				=  <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">  
    		  and EcodigoOri		 	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">  
       		  and CPNAPmoduloOri 		= 'PRFO'
	       	  and left(CPNAPdocumentoOri,2)	= 'CC'
		</cfquery>

		<cfif rsSQLNAP.ultimo EQ "">
    		<cfset LvarDocumentoAprobo = 1>
		<cfelse>
    		<cfset LvarDocumentoAprobo = rsSQLNAP.ultimo + 1>
		</cfif>
		<cfset LvarDocumentoAprobo = "CC-"&#LvarDocumentoAprobo#>
		<cfset temp = "">
		<cfloop query="rsCtasObligatoriasComp">
			<cfquery name ="rsSQLinsert" datasource="#GvarConexion#"> 
				insert into CPresupuestoComprAut(CPPid, CPcuenta, Ecodigo, Cmayor, CPCCmascara, CPCCdescripcion, CPcambioAplicado, BMUsucodigo) 
				values ( 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#CPPid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCtasObligatoriasComp.CPcuenta#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,                        
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCtasObligatoriasComp.Cmayor#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCtasObligatoriasComp.CPformato#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCtasObligatoriasComp.CPdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="1">, <!----CHECAR SI SE DEJA ASI---->
    	        <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">
				)
				<cf_dbidentity1 datasource="#GvarConexion#">
			</cfquery>
        
			<cf_dbidentity2 datasource="#GvarConexion#" name="rsSQLinsert">
        	<cfset CPCCid = rsSQLinsert.identity>
            
	         <cfloop index= i from = "1" to ="#Meses#">
    	     	<cfquery name ="rsSQLinsert" datasource="#GvarConexion#"> 
        	    	insert into CPresupuestoComprAutD
            	    (CPPid, CPCCid, CPperiodo, CPmes, CPComprOri, CPComprMod, BMUsucodigo)
                	values
	                (<cfqueryparam cfsqltype="cf_sql_numeric" value="#CPPid#">,
    	            <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPCCid#">,
        	        <cfqueryparam cfsqltype="cf_sql_numeric" value="#PerIni#">,
            	    <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesIni#">,
	                0,0,
    	            <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">
        	        )
            	</cfquery>
			
				<cfset PerMesNAP = #PerIni#*100+#MesIni#>
				<cfif MesIni GE MesAux>
					<cfquery name="rsInsertintPresupuesto" datasource="#GvarConexion#">
		    			insert into #request.intPresupuesto#
	    	             (
	        	          ModuloOrigen,
	            	      NumeroDocumento,
	                	  NumeroReferencia,
		                  FechaDocumento,
		                  AnoDocumento,
	    	              MesDocumento,
	        	          NumeroLinea,
	            	      CPPid, 
		                  CPCano, CPCmes, CPCanoMes,
		                  CPcuenta, Ocodigo,
	    	              CuentaPresupuesto, CodigoOficina,
	        	          TipoControl, CalculoControl, SignoMovimiento,	
		                  TipoMovimiento,
		                  Mcodigo, 	MontoOrigen, 
	    	              TipoCambio, Monto, NAPreferencia,LINreferencia
	        	          )
		           		values ('PRFO', '#LvarDocumentoAprobo#', 'MODIFICACION', 
		                  <cf_dbfunction name="now">,
	    	     		  <cfqueryparam cfsqltype="cf_sql_numeric" value="#PerIni#">,
            	   		  <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesIni#">,
						  abs(coalesce((select max(NumeroLinea) from #request.intPresupuesto#),0)+1),
		                  <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPPid#">,
	    	              #PerIni#, #MesIni#, #PerMesNAP#,
	        	          <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCtasObligatoriasComp.CPcuenta#">,
		                  <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Arguments.Ocodigo#">,
						  '#rsCtasObligatoriasComp.CPformato#', 
   			  			  '#Arguments.Oficodigo#',
						  #rsCtasObligatoriasComp.CPCPtipoControl#,
	            	      #rsCtasObligatoriasComp.CPCPcalculoControl#, +1,
	                	  'CC', 
		                  #rsPeriodoPres.Mcodigo#, 	
		                  0,
	    	              1, 0,
	        	          NULL,NULL
	            	      )
		   			</cfquery>
				</cfif>
						
				<cfset 	MesIni = #MesIni# + 1>
				<cfif MesIni GT 12>
					<cfset MesIni = 1>
				<!---	<cfset PerIni = #PerIni# + 1>--->
				</cfif>
			</cfloop>		
	
			<cfset temp = ListAppend(temp,#CPCCid#)>	
		</cfloop>

	
		<cfquery name="rs_regporCompr" datasource="#GvarConexion#">
			select * from #request.intPresupuesto#
		</cfquery>
		
		<cfif rs_regporCompr.recordCount NEQ 0>
    		<cfset LvarNAP = LobjControl.ControlPresupuestario("PRFO", LvarDocumentoAprobo, "MODIFICACION", #Arguments.Fecha_Nom#, #Arguments.Periodo#, #Arguments.Mes#) />
	    <cfelse>
    		<cfset LvarNAP = -1 />
	    </cfif>
		
		<cfif LvarNAP GT 0>
			<cfquery name="insCPresupuestoComprometidasNAPs" datasource="#GvarConexion#">
	    	   	insert into CPresupuestoComprometidasNAPs
		        	(
	        	     Ecodigo, 
	            	 CPPid, 
		             CPcuenta, Ocodigo, CPCano, CPCmes,
		             CPNAPnum, CPNAPDlinea
	    	         )
	        	     SELECT <cfqueryparam  cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
					 <cfqueryparam  cfsqltype="cf_sql_numeric" value="#CPPid#">,	
					 cpnapd.CPcuenta, cpnapd.Ocodigo,
					 cpnapd.CPCano,cpnapd.CPCmes,
					 cpnapd.CPNAPnum, cpnapd.CPNAPDlinea
		             from CPNAPdetalle cpnapd
			         left join CPresupuestoComprometidasNAPs compnaps
						 	on compnaps.Ecodigo 	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		        	        and compnaps.CPPid	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#CPPid#">
		            	    and compnaps.CPcuenta	= cpnapd.CPcuenta
			                and compnaps.Ocodigo	= cpnapd.Ocodigo
			                and compnaps.CPCano 	= cpnapd.CPCano
			                and compnaps.CPCmes		= cpnapd.CPCmes
		    	    where cpnapd.Ecodigo			= <cfqueryparam  cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			        	and cpnapd.CPNAPnum			= #LvarNAP#
			            and cpnapd.CPNAPDtipoMov	= 'CC'
			           <!--- and cpnapd.CPNAPDmonto		> 0--->
		    	        and compnaps.CPcuenta	is null
		        	    and compnaps.Ocodigo is null
		            	and compnaps.CPCano is null
			            and compnaps.CPCmes	is null
			</cfquery>
			
			<cfquery datasource="#Gvarconexion#">
				update CPresupuestoComprAutD
				set CPNAPnum = #LvarNAP#
				where CPCCid in (#temp#)
			</cfquery>
			
		</cfif>
		
	<cfset CompromisoValido	= Valida_CompromisoSuficiente(#Arguments.ID#, #CPPid#, #Arguments.Num_Nomina#, #Arguments.Fecha_Nom#, #PerMes#, #Periodo#, #Mes#)>
			
	<cfcatch>
		<cfif isdefined("CPCCid") and CPCCid GT 0>
			<cfquery datasource="#GvarConexion#">
				delete CPresupuestoComprAutD 
				where CPCCid = #CPCCid#
			</cfquery>
			<cfquery datasource="#GvarConexion#">
				delete CPresupuestoComprAut
				where CPCCid = #CPCCid#
			</cfquery>
		</cfif>
		<cfif isdefined ("LvarNAP") and LvarNAP GT 0>
			<cfquery datasource="#GvarConexion#">
				delete  CPresupuestoComprometidasNAPs 
				where CPNAPnum = #LvarNAP#
			</cfquery>
			<cfquery datasource="#GvarConexion#">
				delete  CPNAPdetalle 
				where CPNAPnum = #LvarNAP#
			</cfquery>
			<cfquery datasource="#GvarConexion#">
				delete  CPNAP 
				where CPNAPnum = #LvarNAP#
			</cfquery>
		</cfif>
		<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
		<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
		<cfthrow message="Error al insertar los registros de NRC de la Nómina: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
	</cfcatch>
	</cftry>
</cffunction>

<!----Valida que por Programa, Rubro y Subrubro se tenga el suficiente comprometido--->
<cffunction name="Valida_CompromisoSuficiente" access="public" output="no">
	<cfargument name="ID" required="yes" type="numeric">
	<cfargument name="CPPid" required="no" type="numeric">
	<cfargument name="Num_Nomina" required="yes" type="string">
	<cfargument name="Fecha_Nom" required="yes" type="date">		
	<cfargument name="PerMes" required="no" type="numeric">
	<cfargument name="Periodo" required="no" type="numeric">
	<cfargument name="Mes" required="no" type="numeric">
	
	<cftry>	
		<cfif isdefined("Arguments.CPPid") and Arguments.CPPid NEQ 0>
			<cfset CPPid = #Arguments.CPPid#>
		<cfelse>
			<cfquery name="rsPeriodoPres" datasource="#GvarConexion#">
				select CPPid, CPPestado, Ecodigo, Mcodigo, CPPanoMesDesde, CPPanoMesHasta,
				case CPPtipoPeriodo when 1 then 1 
					when 2 then 2 
					when 3 then 3 
					when 4 then 4 
					when 6 then 6 
					when 12 then 12 
					else 0 end as Num_Meses, 
				left(CPPanoMesDesde,4) as Periodo, 
				right(CPPanoMesDesde,2)as Mes
				from CPresupuestoPeriodo  
				where CPPanoMesDesde <= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerMes#"> 
				and CPPanoMesHasta >= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerMes#"> 
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">  
			</cfquery>
			<cfif rsPeriodoPres.recordcount GT 0>
				<cfset CPPid = #rsPeriodoPres.CPPid#>	
			</cfif>
		</cfif>
		<cfset LobjControlV = createObject( "component","sif.presupuesto.Componentes.PRES_GeneraTablaValidaPPTO")>
		<cfset tValPres = LobjControlV.CreaTablaValPresupuesto(#GvarConexion#)>
		
		<cfquery name="rsNRCAnteriores" datasource="sifinterfaces">
  			select count(*) as NRC_Anteriores 
			from  NRCE_Nomina
			where NRC_NumNomina = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Num_Nomina#">))
  		</cfquery>
			
		<cfif rsNRCAnteriores.NRC_Anteriores GT 0>
			<cfquery name="rsMaxNRC" datasource="sifinterfaces">
  				delete NRCD_Nomina 
				from NRCD_Nomina d
				inner join NRCE_Nomina e on d.NRC_Id = e.NRC_Id
				where ltrim(rtrim(NRC_NumNomina)) = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Num_Nomina#">))							
	  		</cfquery>
			<cfquery name="rsMaxNRC" datasource="sifinterfaces">
  				delete NRCE_Nomina
				where ltrim(rtrim(NRC_NumNomina)) = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Num_Nomina#">))
	  		</cfquery>					
		</cfif>
		
		<cfquery name="rsConfig" datasource="#GvarConexion#">
   			select b.CPVid, REPLACE(b.Descripcion,' ','_') Descripcion, a.PCEcatid as Catalogo, a.Valor
	  	 	from CPValidacionConfiguracion a
   			inner join CPValidacionValores b
    		on a.CPVid = b.CPVid
	   		Where b.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
 		</cfquery>

	 	<cfset mystring = "'-'"> 
 		<cfquery name="rsValComp" datasource="#GvarConexion#">
	  		select CPperiodo, CPmes, CPComprMod, Total_Linea, cc.Grupo 
   				from  (
    					select a.CPperiodo, a.CPmes, sum(a.SaldosNAP) as CPComprMod, t.Grupo
	 					 from(
							select a.CPcuenta, a.Ecodigo, b.CPperiodo, b.CPmes, sum(n.CPNAPDmonto - n.CPNAPDutilizado) SaldosNAP
								from CPresupuestoComprAut a
								inner join CPresupuestoComprAutD b
								on a.CPPid = b.CPPid
								and a.CPCCid = b.CPCCid
							inner join CPresupuestoComprometidasNAPs cn
								on cn.CPcuenta = a.CPcuenta
								and cn.CPCano = b.CPperiodo
								and cn.CPCmes = b.CPmes     	
								and b.CPNAPnum = cn.CPNAPnum  				
							inner join CPNAPdetalle n
								on n.CPcuenta = cn.CPcuenta
								and n.CPCano = cn.CPCano
								and n.CPCmes = cn.CPCmes    
								and n.CPNAPnum = cn.CPNAPnum
								and n.CPNAPDlinea = cn.CPNAPDlinea   	  			
							where a.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
							and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPPid#">
							and b.CPmes = #Arguments.Mes#
							and b.CPperiodo = #Arguments.Periodo#
						group by a.CPcuenta, a.Ecodigo, b.CPperiodo, b.CPmes
						) a
				inner join 			
     					#tValPres# t
	     				on a.CPcuenta = t.CPcuenta
    	 			<!---	) cpr
						on a.CPcuenta = cpr.CPcuenta--->			
		 			group by a.CPperiodo, a.CPmes , t.Grupo)cc
			inner join (	
				select t.Grupo, sum(b.Total_Linea) as Total_Linea 
				from (select  p.CPcuenta, p.CPformato, sum(i.Total_Linea) as Total_Linea
       				from #sifinterfacesdb#..ID925 i
	       			inner join CFinanciera f
    	       		  	on i.CFformato = f.CFformato
      				inner join CPresupuesto p
            			on f.CPcuenta = p.CPcuenta            			
		        	where i.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ID#">
	       		    and p.CPmovimiento = 'S'
			       	and i.Gasto = 1
			       	group by  p.CPcuenta, p.CPformato) b
			     inner join #tValPres# t
	     				on b.CPcuenta = t.CPcuenta
    	 			group by t.Grupo)cn
				on cn.Grupo = cc.Grupo			
			group by CPperiodo, CPmes, CPComprMod, Total_Linea, cc.Grupo 
			having Total_Linea > CPComprMod 			 
		 </cfquery>
		 
	 	 <cfif rsValComp.recordcount GT 0>
			<cfloop query="rsValComp">
 				<cfquery name="rsValPorCta" datasource="#GvarConexion#">
					select CPperiodo, CPmes, sum(CPComprMod) as CPComprMod, sum(Total_Linea) as Total_Linea, cc.Grupo, cc.CPCCmascara, cc.CPcuenta
   						from  (
    						select a.CPperiodo, a.CPmes, a.SaldosNAP as CPComprMod, t.Grupo, a.CPcuenta, a.CPCCmascara
	 					 	from(
								select a.CPcuenta, a.Ecodigo, b.CPperiodo, b.CPmes, (n.CPNAPDmonto - n.CPNAPDutilizado) SaldosNAP, a.CPCCmascara
								from CPresupuestoComprAut a
								inner join CPresupuestoComprAutD b
									on a.CPPid = b.CPPid
									and a.CPCCid = b.CPCCid
								inner join CPresupuestoComprometidasNAPs cn
									on cn.CPcuenta = a.CPcuenta
									and cn.CPCano = b.CPperiodo
									and cn.CPCmes = b.CPmes     	
									and b.CPNAPnum = cn.CPNAPnum  				
								inner join CPNAPdetalle n
									on n.CPcuenta = cn.CPcuenta
									and n.CPCano = cn.CPCano
									and n.CPCmes = cn.CPCmes    
									and n.CPNAPnum = cn.CPNAPnum
									and n.CPNAPDlinea = cn.CPNAPDlinea   	  			
								where a.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
								and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPPid#">
								and b.CPmes = #Arguments.Mes#
								and b.CPperiodo = #Arguments.Periodo#
							<!---group by a.CPcuenta, a.Ecodigo, b.CPperiodo, b.CPmes, a.CPCCmascara--->
							) a
						inner join 			
    	 					#tValPres# t
	    	 				on a.CPcuenta = t.CPcuenta
    	 		 			<!---group by a.CPperiodo, a.CPmes , t.Grupo, a.CPCCmascara, a.CPcuenta--->
							)cc
					Inner join (	
						select t.Grupo, t.CPcuenta, b.Total_Linea 
							from (select  p.CPcuenta, p.CPformato, sum(i.Total_Linea) as Total_Linea
       							from #sifinterfacesdb#..ID925 i
			    	   			inner join CFinanciera f
    			    	   		  	on i.CFformato = f.CFformato
      							inner join CPresupuesto p
			            			on f.CPcuenta = p.CPcuenta            			
					        	where i.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ID#">
	    	   				    and p.CPmovimiento = 'S'
						       	and i.Gasto = 1
					       	group by  p.CPcuenta, p.CPformato
							) b
				    	 inner join #tValPres# t
	     					on b.CPcuenta = t.CPcuenta
	    	 			<!---group by t.Grupo--->
						)cn
					on cn.CPcuenta = cc.CPcuenta and cn.Grupo = cc.Grupo	
					where cc.Grupo = '#rsValComp.Grupo#'
					group by CPperiodo, CPmes, cc.Grupo, cc.CPCCmascara, cc.CPcuenta
			 	</cfquery> 
 	
 				<cfif rsValPorCta.recordCount GT 0>
					<cfset agrup = ValueList(rsConfig.Descripcion,",")>
									
					<cfquery name="rsMaxNRC" datasource="sifinterfaces">
  						select count(*) 
						from NRCE_Nomina
						where NRC_NumNomina = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Num_Nomina#">))
  					</cfquery>
					
		   			<cfquery name="rsMaxNRC" datasource="sifinterfaces">
  						select coalesce(max(NRC_Id),0) + 1 as NRC_Id from NRCE_Nomina
  					</cfquery>
	  				<cfset NRC_Id = rsMaxNRC.NRC_Id>
  	
 		 			<cfquery datasource="sifinterfaces">
       					insert NRCE_Nomina (NRC_Id, 
	   							 Ecodigo,
								 NRC_NumNomina, 
								 NRC_FechaNomina,
								 NRC_Grupo,
								 MontoComprometido,
								 MontoEjecutar,
								 BMUsucodigo)
         				  values(<cfqueryparam  cfsqltype="cf_sql_integer" value="#NRC_Id#">,			
						  		 <cfqueryparam  cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
								 ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Num_Nomina#">)),
							     <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha_Nom#">,
								 ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValComp.Grupo#">)),
								 <cfqueryparam cfsqltype="cf_sql_money" value="#rsValComp.CPComprMod#">, 
								 <cfqueryparam cfsqltype="cf_sql_money" value="#rsValComp.Total_Linea#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">)
					</cfquery>
	  
					<cfloop query="rsValPorCta">
						<cfquery name="rsMaxNRCD" datasource="sifinterfaces">
		  					select coalesce(max(NRCD_Id),0) + 1 as NRCD_Id 
							from NRCD_Nomina 
							<!---where NRC_Id = <cfqueryparam  cfsqltype="cf_sql_integer" value="#NRC_Id#">--->
	  					</cfquery>
  						<cfset NRCD_Id = rsMaxNRCD.NRCD_Id>
		
				    	<cfquery datasource="sifinterfaces">
							insert NRCD_Nomina (NRCD_Id,
								NRC_Id,
								CPcuenta,
								NRCD_Periodo,
								NRCD_Mes,
								<!---MontoComprometido,
								MontoEjecutar,--->
								BMUsucodigo)
	         			 values(<cfqueryparam cfsqltype="cf_sql_integer" value="#NRCD_Id#">,
						 		<cfqueryparam cfsqltype="cf_sql_integer" value="#NRC_Id#">,
							  	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValPorCta.CPcuenta#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValPorCta.CPperiodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValPorCta.CPmes#">,
								<!---<cfqueryparam cfsqltype="cf_sql_money" value="#rsValPorCta.CPComprMod#">,
								<cfqueryparam cfsqltype="cf_sql_money" value="#rsValPorCta.Total_Linea#">,--->
							    <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">)
						</cfquery>
	  				</cfloop>
				</cfif>
			</cfloop>	
			
			<!--- <cf_dumptofile select = "select * from sif_interfaces..NRCE_Nomina">--->
		</cfif>			
	<cfcatch>
			<cfquery name="rsMaxNRC" datasource="sifinterfaces">
  				delete NRCD_Nomina 
				from NRCD_Nomina d
				inner join NRCE_Nomina e on d.NRC_Id = e.NRC_Id
				where ltrim(rtrim(NRC_NumNomina)) = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Num_Nomina#">))							
	  		</cfquery>
			<cfquery name="rsMaxNRC" datasource="sifinterfaces">
  				delete NRCE_Nomina
				where ltrim(rtrim(NRC_NumNomina)) = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Num_Nomina#">))
	  		</cfquery>		
		<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
		<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
		<cfthrow message="Error al insertar los registros de NRC de la Nómina: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
	</cfcatch>
	</cftry>
</cffunction>
							
				
	<!----Validaciones--->			
	<cffunction name="getValidAux" access="private" returntype="numeric" output="no">
		<cfargument name="Ecodigo" required="true" type="numeric">
		
		<!----Obtienes mes abierto en auxiliares--->
		<cfquery name="rsMesAux" datasource="#GvarConexion#">
			select Pvalor 
			from Parametros
			where Pcodigo = 60
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
			
		<cfif  isdefined("rsMesAux") and rsMesAux.recordcount EQ 0>
			<cfthrow message="No se ha parametrizado el mes auxiliar para la empresa">
		<cfelse>
			<cfset MesAux = #rsMesAux.Pvalor#>
		</cfif>	
		
		<cfreturn MesAux>
	</cffunction>	
		
</cfcomponent>

