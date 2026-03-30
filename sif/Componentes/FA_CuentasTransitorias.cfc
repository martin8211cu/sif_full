<cfcomponent>
	<cffunction name='FA_cuentastransitorias' access='public' output='true' returntype="string">
		<cfargument name='Ecodigo' 			type="numeric" 	required='false'    default="#Session.Ecodigo#">		
		<cfargument name='conexion' 		type='string' 	required='false' 	default="#Session.DSN#">
		<cfargument name='SNid' 	        type='numeric' 	required='true' 	default="-1">
        <cfargument name='incos' 	        type='string' 	required='true' 	>
        <cfargument name='TIPO' 	        type='string' 	required='true' 	>
        <cfargument name='ETtc' 	        type='string' 	required='true' 	>    
        <cfargument name='Monloc' 	        type='string' 	required='true' 	>
        <cfargument name='CCTcodigo' 	    type='string' 	required='true' 	>
        <cfargument name='Pcodigo' 	        type='string' 	required='true' 	>
        <cfargument name='Ddocumento'       type='string' 	required='true' 	>     
        <cfargument name='INTARC' 	        type='string' 	required='true' 	> 
        
        <cf_dbfunction name="OP_concat"	returnvariable="_Cat">         
        
        <cfif isdefined('arguments.INTARC') and len(trim(arguments.INTARC)) gt 0>
 	       <cfset INTARC = arguments.INTARC>
     	</cfif>  
        
		<cfif arguments.SNid eq -1>
			<cfthrow message="Se debe indicar un Socio de Negocio correcto">
		</cfif>	
                
        <cfquery name="rsPeriodo" datasource="#session.dsn#">
            select  <cf_dbfunction name="to_char"	args="Pvalor"> as Periodo
            from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
              and Mcodigo = 'GN'
              and Pcodigo = 50
        </cfquery>  
    
   		<cfset LvarPeriodo =  rsPeriodo.Periodo>

        <cfquery name="rsMes" datasource="#session.dsn#">
        select <cf_dbfunction name="to_char"	args="Pvalor"> as Mes
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
          and Mcodigo = 'GN'
          and Pcodigo = 60
        </cfquery>      
   		 <cfset LvarMes = rsMes.Mes>        
                     
        <cfquery name="rsDocumentos" datasource="#session.dsn#">
         select  Doc_CCTcodigo, dp.CCTcodigo ,dp.Ddocumento from Pagos p
				inner join DPagos dp
					on dp.Ecodigo = p.Ecodigo
						and dp.CCTcodigo = p.CCTcodigo
						and dp.Pcodigo  = p.Pcodigo  
			where p.Ecodigo = #Session.Ecodigo#
				and p.CCTcodigo =  <cfqueryparam cfsqltype="cf_sql_char"  value="#arguments.CCTcodigo#" >
				and p.Pcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#arguments.Pcodigo#" >
        </cfquery>              
		<cfloop query="rsDocumentos">                                         
		        <cfquery name="rsDPtotal" datasource="#session.dsn#">
		         select  sum(dp.DPtotal)  as totalpago from Pagos p
						inner join DPagos dp
							on dp.Ecodigo = p.Ecodigo
								and dp.CCTcodigo = p.CCTcodigo
								and dp.Pcodigo  = p.Pcodigo  
					where p.Ecodigo = #Session.Ecodigo#
						and p.CCTcodigo =  <cfqueryparam cfsqltype="cf_sql_char"  value="#arguments.CCTcodigo#" >
						and p.Pcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#arguments.Pcodigo#" >
		                and Doc_CCTcodigo      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocumentos.Doc_CCTcodigo#"> 
		                and Ddocumento   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocumentos.Ddocumento#"> 
		        </cfquery> 
		       <cfquery name="rsDTotal" datasource="#session.dsn#">
		          	select sum(DPtotal) as totaldoc
		            from DPagos
		            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#"> 
		            and CCTcodigo      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocumentos.CCTcodigo#"> 
		            and Ddocumento   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocumentos.Ddocumento#"> 
		       </cfquery>
               <!----Cuenta transitoria general ---->
               <cfquery name="rsCuentaTransitoria" datasource="#session.dsn#">
                select  <cf_dbfunction name="to_char"	args="Pvalor"> as Cuenta
                from Parametros
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
                  and Mcodigo = 'CG'
                  and Pcodigo = 565
                </cfquery>        
                <cfset LvarCuentaTransitoriaGeneral = rsCuentaTransitoria.Cuenta> 
                <cfif isdefined('LvarCuentaTransitoriaGeneral') and len(trim(#LvarCuentaTransitoriaGeneral#)) eq 0>   
                    <cfthrow message="No se ha definido la Cuenta Transitoria en Parametros Adicionales / Facturacion.!">   
                </cfif>
		        <cfquery name="rsMonedaLoc" datasource="#session.dsn#">
                  select  Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                </cfquery>    
               <cfset LvarMonloc = rsMonedaLoc.Mcodigo>               
		 
				<!---- ********************************* --->
                <!---- Insercion de cuentas transitorias --->
				<!----1.a Articulos----->
                <cfquery name="rsInsert" datasource="#session.dsn#">
			        insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
			        select
			            'FAFC',
			            1,
			            a.Ddocumento,
			            '#Arguments.CCTcodigo#', 
			            case when #LvarMonloc# != a.Mcodigo then round(round((#rsDPtotal.totalpago#*((b.DDtotal+coalesce(b.DDdesclinea,0.00))/ #rsDTotal.totaldoc#)),2) * a.Dtipocambio,2) else round((#rsDPtotal.totalpago#*((b.DDtotal+coalesce(b.DDdesclinea,0.00))/ #rsDTotal.totaldoc#)),2) end,
			            case when c.CCTtipo = 'D' then 'D' else 'C' end,
			            'Cuenta transitoria: ' #_Cat# coalesce(DDescripcion, DDdescalterna), 
			            <cf_dbfunction name="to_char"	args="getdate(),112">,
			            a.Dtipocambio,
			            #LvarPeriodo#,
			            #LvarMes#,
			            coalesce(d.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral#),
			            a.Mcodigo,
			            d.Ocodigo,
			            round((#rsDPtotal.totalpago#*((b.DDtotal+coalesce(b.DDdesclinea,0.00))/ #rsDTotal.totaldoc#)),2) as total			
                      from Documentos a, DDocumentos b, CCTransacciones c, CFuncional d
                      where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                        and a.CCTcodigo      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocumentos.Doc_CCTcodigo#"> 
		                and a.Ddocumento   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddocumento#">                          
                        and a.CCTcodigo = c.CCTcodigo
                        and a.Ecodigo = c.Ecodigo
                        and b.CCTcodigo = c.CCTcodigo                              
                        and a.Ecodigo = b.Ecodigo
                        and a.CCTcodigo = b.CCTcodigo
                        and a.Ddocumento = b.Ddocumento
                        and b.CFid = d.CFid
                        and b.Ecodigo = d.Ecodigo
                        and b.DDtipo = 'A'
                        and b.DDtotal != 0 
                        and b.DesTransitoria = 1
		         </cfquery> 		          
		        <!-----1.b Conceptos--->
		        <cfquery name="rsInsert" datasource="#session.dsn#">
		    insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
			        select
			            'FAFC',
			            1,
			            a.Ddocumento,
			            '#Arguments.CCTcodigo#', 
			            case when #LvarMonloc# != a.Mcodigo then round(round((#rsDPtotal.totalpago#*((b.DDtotal+coalesce(b.DDdesclinea,0.00))/ #rsDTotal.totaldoc#)),2) * a.Dtipocambio,2) else round((#rsDPtotal.totalpago#*((b.DDtotal+coalesce(b.DDdesclinea,0.00))/ #rsDTotal.totaldoc#)),2) end,
			            case when c.CCTtipo = 'D' then 'D' else 'C' end,
			            'Cuenta transitoria: ' #_Cat# coalesce(DDescripcion, DDdescalterna), 
			            <cf_dbfunction name="to_char"	args="getdate(),112">,
			            a.Dtipocambio,
			            #LvarPeriodo#,
			            #LvarMes#,
			            coalesce(d.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral#),
			            a.Mcodigo,
			             d.Ocodigo,
			            round((#rsDPtotal.totalpago#*((b.DDtotal+coalesce(b.DDdesclinea,0.00))/ #rsDTotal.totaldoc#)),2) as total		
                      from Documentos a, DDocumentos b, CCTransacciones c, CFuncional d
                      where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                        and a.CCTcodigo      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocumentos.Doc_CCTcodigo#"> 
		                and a.Ddocumento   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddocumento#">                          
                        and a.CCTcodigo = c.CCTcodigo  
                        and a.Ecodigo = c.Ecodigo
                        and b.CCTcodigo = c.CCTcodigo    
                        and a.Ecodigo = b.Ecodigo
                        and a.CCTcodigo = b.CCTcodigo
                        and a.Ddocumento = b.Ddocumento
                        and b.CFid = d.CFid
                        and b.Ecodigo = d.Ecodigo
                        and b.DDtipo = 'S'
                        and b.DDtotal != 0 
                        and b.DesTransitoria = 1
		        </cfquery>  

                <!----- **************************************** ---->
				<!----- Contra parte de las cuentas transitorias ---->
                
				<!---2.a Articulos----->
                <cfquery name="rsInsert" datasource="#session.dsn#">
			        insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
			        select
			            'FAFC',
			            1,
			            a.Ddocumento,
			            '#Arguments.CCTcodigo#', 
			            case when #LvarMonloc# != a.Mcodigo then round(round((#rsDPtotal.totalpago#*((b.DDtotal+coalesce(b.DDdesclinea,0.00))/ #rsDTotal.totaldoc#)),2) * a.Dtipocambio,2) else round((#rsDPtotal.totalpago#*((b.DDtotal+coalesce(b.DDdesclinea,0.00))/ #rsDTotal.totaldoc#)),2) end,
			            case when c.CCTtipo = 'D' then 'C' else 'D' end,
			            coalesce(DDescripcion, DDdescalterna), 
			            <cf_dbfunction name="to_char"	args="getdate(),112">,
			            a.Dtipocambio,
			            #LvarPeriodo#,
			            #LvarMes#,
			            b.Ccuenta,
			            a.Mcodigo,
			            d.Ocodigo,
			            round((#rsDPtotal.totalpago#*((b.DDtotal+coalesce(b.DDdesclinea,0.00))/ #rsDTotal.totaldoc#)),2) as total			
                      from Documentos a, DDocumentos b, CCTransacciones c, CFuncional d
                      where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                        and a.CCTcodigo      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocumentos.Doc_CCTcodigo#"> 
		                and a.Ddocumento   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddocumento#">  
                        and a.CCTcodigo = c.CCTcodigo   
                        and a.Ecodigo = c.Ecodigo
                        and b.CCTcodigo = c.CCTcodigo   
                        and a.Ecodigo = b.Ecodigo
                        and a.CCTcodigo = b.CCTcodigo
                        and a.Ddocumento = b.Ddocumento
                        and b.CFid = d.CFid
                        and b.Ecodigo = d.Ecodigo
                        and b.DDtipo = 'A'
                        and b.DDtotal != 0 
                        and b.DesTransitoria = 1
		         </cfquery> 		          
		        <!-----2.b Conceptos--->
		        <cfquery name="rsInsert" datasource="#session.dsn#">
		    insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
			        select
			            'FAFC',
			            1,
			            a.Ddocumento,
			            '#Arguments.CCTcodigo#', 
			            case when #LvarMonloc# != a.Mcodigo then round(round((#rsDPtotal.totalpago#*((b.DDtotal+coalesce(b.DDdesclinea,0.00))/ #rsDTotal.totaldoc#)),2) * a.Dtipocambio,2) else round((#rsDPtotal.totalpago#*((b.DDtotal+coalesce(b.DDdesclinea,0.00))/ #rsDTotal.totaldoc#)),2) end,
			            case when c.CCTtipo = 'D' then 'C' else 'D' end,
			            coalesce(DDescripcion, DDdescalterna), 
			            <cf_dbfunction name="to_char"	args="getdate(),112">,
			            a.Dtipocambio,
			            #LvarPeriodo#,
			            #LvarMes#,
			            b.Ccuenta,
			            a.Mcodigo,
			            d.Ocodigo,
			            round((#rsDPtotal.totalpago#*((b.DDtotal+coalesce(b.DDdesclinea,0.00))/ #rsDTotal.totaldoc#)),2) as total		
                      from Documentos a, DDocumentos b, CCTransacciones c, CFuncional d
                      where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                        and a.CCTcodigo      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocumentos.Doc_CCTcodigo#"> 
		                and a.Ddocumento   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddocumento#">                          
                        and a.CCTcodigo = c.CCTcodigo  
                        and a.Ecodigo = c.Ecodigo
                        and b.CCTcodigo = c.CCTcodigo   
                        and a.Ecodigo = b.Ecodigo
                        and a.CCTcodigo = b.CCTcodigo
                        and a.Ddocumento = b.Ddocumento
                        and b.CFid = d.CFid
                        and b.Ecodigo = d.Ecodigo
                        and b.DDtipo = 'S'
                        and b.DDtotal != 0 
                        and b.DesTransitoria = 1
		        </cfquery>        		   
		</cfloop>
		<!---Fin del rsDocumentos--->   
    <!---<cfquery name="rsJJ" datasource="#session.dsn#">
    	select * from #INTARC#
    </cfquery>
    <cf_dump var="#rsJJ#">--->   
        <cfreturn incos>     
	</cffunction>
</cfcomponent>
