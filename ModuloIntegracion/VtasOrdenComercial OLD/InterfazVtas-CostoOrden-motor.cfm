<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Saldos por volumen de Ventas'>

<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">
<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>


<cfset GvarConexion  = Session.Dsn>
<cfset GvarEcodigo   = Session.Ecodigo>	
<cfset GvarUsuario   = Session.Usuario>
<cfset GvarUsucodigo = Session.Usucodigo>
<cfset varError = false>	
	
<cf_navegacion name="fltPeriodo" 		navegacion="" session default="-1">
<cf_navegacion name="fltMes" 		    navegacion="" session default="-1">

<cfset LvarNavegacion = ""> 

<cfif Form.fltPeriodo NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltPeriodo=#Form.fltPeriodo#">
</cfif>

<cfif Form.fltMes NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltMes=#Form.fltMes#">
</cfif>

<cftransaction action="begin">
<cftry>	

<cfquery name="rsUtilidad" datasource="#GvarConexion#">
   	select Ecodigo, #form.fltPeriodo# as Periodo, #form.fltMes# as Mes, Clas_Venta, Orden_Comercial, Moneda, Imp_Ingreso,    Imp_Costo, Usuario
	from UtilidadBruta
	where Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
</cfquery>	

<cfloop query="rsUtilidad">			
	<cfquery datasource="#GvarConexion#">
		if exists (select 1 from SaldosUtilidad
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsUtilidad.Ecodigo#">
		    and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsUtilidad.Periodo#">
			and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsUtilidad.Mes#">
			and Clas_Venta = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUtilidad.Clas_Venta#">))
    		and Orden_Comercial = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUtilidad.Orden_Comercial#">))
			and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUtilidad.Moneda#">
			and Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">)
			update SaldosUtilidad set Imp_Ingreso = Imp_Ingreso + <cfqueryparam cfsqltype="cf_sql_float" value=    	    "#rsUtilidad.Imp_Ingreso#">,
			Imp_Ingreso_Actual = 0,
			Imp_Costo = Imp_Costo + <cfqueryparam cfsqltype="cf_sql_float" value="#rsUtilidad.Imp_Costo#">,<!---???--->
			Imp_Costo_Actual = 0
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsUtilidad.Ecodigo#">
		    and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsUtilidad.Periodo#">
			and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsUtilidad.Mes#">
			and Clas_Venta = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUtilidad.Clas_Venta#">))
    		and Orden_Comercial = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUtilidad.Orden_Comercial#">))
			and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUtilidad.Moneda#">
			and Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
		else
			insert into SaldosUtilidad
			(Ecodigo,
			Periodo,
			Mes, 
			Clas_Venta,
			Orden_Comercial,
			Imp_Ingreso,
			Imp_Ingreso_Actual,
			Imp_Costo,
			Imp_Costo_Actual,
			Moneda,
			Usuario)
			values
			(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsUtilidad.Ecodigo#">,
		    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsUtilidad.Periodo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsUtilidad.Mes#">,
			ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUtilidad.Clas_Venta#">)),
    		ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUtilidad.Orden_Comercial#">)),
			<cfqueryparam cfsqltype="cf_sql_float" value="#rsUtilidad.Imp_Ingreso#">,
			0,
			<cfqueryparam cfsqltype="cf_sql_float" value="#rsUtilidad.Imp_Costo#">,
			0,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUtilidad.Moneda#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">)
		</cfquery>
</cfloop>
		
	   <cfquery name="rsValores" datasource="#GvarConexion#">
                 	select  Ecodigo, #form.fltPeriodo# as Periodo, #form.fltMes# as Mes, Orden_Comercial, 		                    Moneda, sum(Imp_Ingreso) as Ingreso,  sum(Imp_Costo) as Costo, Usuario  
<!---					Costo = (select distinct(Imp_Costo) from UtilidadBruta where Ecodigo = U.Ecodigo and Moneda = U.Moneda                    and Periodo = U.Periodo and Mes = U.Mes and Orden_Comercial = U.Orden_Comercial)--->					
					from UtilidadBruta U
					where Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
					group by Ecodigo, Periodo, Mes, Orden_Comercial, Moneda, Usuario
		</cfquery>
													
		<cfif isdefined("rsValores") and rsValores.recordcount GT 0>
			<cfloop query="rsValores">
				<!--- FUNCION GETCECODIGO --->
				<cfquery name="rsCEcodigo" datasource="#GvarConexion#">
        			select CEcodigo, Ecodigo 
					from Empresa E
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Ecodigo#">
			    </cfquery>
					
				<cfif rsCEcodigo.recordcount EQ 0>
					<cfthrow message="No existe el codigo para la empresa">
				</cfif>
				
				<!----Valida si la variable ya existe--->
				<cfquery name="rsVarUtilidad" datasource="#GvarConexion#">
					select ID_Utilidad from UtilidadVar 
					where Orden_Comercial = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Orden_Comercial#">))
				</cfquery>

					<!----Inserta a la tabla de UtilidadVar---->
					<cfif rsVarUtilidad.recordcount EQ 0>
						<cfquery name="insEncR" datasource="#GvarConexion#">
							insert into UtilidadVar
							(CEcodigo,
							Orden_Comercial,          	    	                                                        
							BMUsucodigo)
							values
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCEcodigo.CEcodigo#">,
							ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Orden_Comercial#">)),
							<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">)
							<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
						</cfquery>
						
						<cf_dbidentity2 name="insEncR" verificar_transaccion="false" datasource="#GvarConexion#">
					</cfif>	

					<cfquery datasource="#GvarConexion#">
						if exists (select 1 from UtilidadVarValor 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
 			    		<cfif rsVarUtilidad.recordcount GT 0>
						   and ID_Utilidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarUtilidad.ID_Utilidad#">
						<cfelse>
							and ID_Utilidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncR.identity#">								 						</cfif>
						and Uano = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Periodo#">
						and Umes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Mes#">
						and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Moneda#">)
						update UtilidadVarValor set Imp_Ingreso = Imp_Ingreso + 
						<cfqueryparam  cfsqltype="cf_sql_float" value="#rsValores.Ingreso#">, 
						Imp_Costo = Imp_Costo + 
						<cfqueryparam  cfsqltype="cf_sql_float" value="#rsValores.Costo#"> 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#"> 					                     	<cfif rsVarUtilidad.recordcount GT 0>
						   and ID_Utilidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarUtilidad.ID_Utilidad#">
					    <cfelse>
					  		and ID_Utilidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncR.identity#">								 				        </cfif>														 	 							   	                        and Uano = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Periodo#">
						and Umes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Mes#">
						else insert into UtilidadVarValor
								(ID_Utilidad,
								 Ecodigo,
								 Uano,
								 Umes,
								 Moneda,                                                                  
								 Imp_Ingreso,                                                                  
								 Imp_Costo,
								 BMfecha,
								 BMUsucodigo)
								values
								(<cfif rsVarUtilidad.recordcount GT 0>
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarUtilidad.ID_Utilidad#">,	
							   	 <cfelse>
								 	 <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncR.identity#">,								 							     </cfif>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Mes#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Moneda#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#rsValores.Ingreso#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#rsValores.Costo#">,
								getdate(),
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">)   
					</cfquery>
				</cfloop>
			</cfif>	

											
		<cfquery datasource="#GvarConexion#">
			delete UtilidadBruta where Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value=            "#GvarUsucodigo#">
		</cfquery>		
						
		<!---Actualización de la tabla intermedia de registros contabilizados--->
		<!----Ventas---->
		<cfquery name="rsIDIntermedia" datasource="#GvarConexion#">
			select E.ID_DocumentoV
			from #sifinterfacesdb#..ESIFLD_Facturas_Venta E
			inner join #sifinterfacesdb#..DSIFLD_Facturas_Venta D on E.ID_DocumentoV = D.ID_DocumentoV
			inner join #sifinterfacesdb#..int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
			where E.Periodo is not null and E.Mes is not null and Utilidad_Reg = 0 and I.Ecodigo = 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and ((Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
			Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
			or  (Periodo < <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
			Mes <= 12))
		</cfquery>
					
		<cfif rsIDIntermedia.recordcount GT 0>
			<cfloop query="rsIDIntermedia">
			  <cfquery datasource="#GvarConexion#">
				update #sifinterfacesdb#..ESIFLD_Facturas_Venta set Utilidad_Reg = 1, Mes_Utilidad_Reg = <cfqueryparam                cfsqltype= "cf_sql_integer" value="#form.fltMes#"> where ID_DocumentoV = <cfqueryparam cfsqltype=                "cf_sql_integer" value="#rsIDIntermedia.ID_DocumentoV#">
			  </cfquery>
			</cfloop>
		</cfif>
		
		<!---Costo--->
		<cfquery name="rsIDIntermediaC" datasource="#GvarConexion#">
			select C.ID_Mov_Costo
			from #sifinterfacesdb#..SIFLD_Costo_Venta C
			inner join #sifinterfacesdb#..int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),C.Ecodigo) 
			where C.Periodo is not null and C.Mes is not null and Costo_Reg = 0 and I.Ecodigo = 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and ((Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
			Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
			or  (Periodo < <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
			Mes <= 12))
		</cfquery>
					
		<cfif rsIDIntermediaC.recordcount GT 0>
			<cfloop query="rsIDIntermediaC">
			  <cfquery datasource="#GvarConexion#">
				update #sifinterfacesdb#..SIFLD_Costo_Venta set Costo_Reg = 1, Mes_Costo_Reg = <cfqueryparam                cfsqltype= "cf_sql_integer" value="#form.fltMes#"> where ID_Mov_Costo = <cfqueryparam cfsqltype=                "cf_sql_integer" value="#rsIDIntermediaC.ID_Mov_Costo#">
			  </cfquery>
			</cfloop>
		</cfif>

<!---Consulta registros NOFACT del mes anterior---->
		<cfquery name="rsNOFACT" datasource="#GvarConexion#">
			select ID_Saldo, Moneda, Ecodigo, Clas_Venta, Periodo, Mes, Orden_Comercial, Imp_Ingreso, Imp_Ingreso_Actual, 			  			Imp_Costo_Actual
			from SaldosUtilidad
			where Reversado = 0	
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			<cfif form.fltMes EQ 1>
				and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> - 1
				and Mes = 12
			<cfelse>
				and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
				and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#"> - 1
			</cfif>
			and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRNF">
		</cfquery>		
				
		<cfif rsNOFACT.recordcount GT 0>
			<cfloop query="rsNOFACT">
				<!----Obtiene el ID de la Utilidad--->
				<cfquery name="rsVarUtilidadNF" datasource="#GvarConexion#">
					select ID_Utilidad from UtilidadVar 
					where Orden_Comercial = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" 
					value= "#rsNOFACT.Orden_Comercial#">))
				</cfquery>
				
				<cfquery name="rsVarUtilidadValor" datasource="#GvarConexion#">
					if exists (select 1 from UtilidadVarValor where ID_Utilidad = <cfqueryparam cfsqltype="cf_sql_integer" 						value= "#rsVarUtilidadNF.ID_Utilidad#"> 
						and Uano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> 
						and Umes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">			                        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNOFACT.Ecodigo#">
						and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNOFACT.Moneda#">)
                    	update UtilidadVarValor set Imp_Ingreso = Imp_Ingreso - 	
						(<cfqueryparam cfsqltype="cf_sql_float" value="#rsNOFACT.Imp_Ingreso#"> + 
	 		        	<cfqueryparam cfsqltype="cf_sql_float" value="#rsNOFACT.Imp_Ingreso_Actual#">),
						Imp_Costo = Imp_Costo -
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsNOFACT.Imp_Costo_Actual#">
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNOFACT.Ecodigo#"> 					                    	and ID_Utilidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarUtilidadNF.ID_Utilidad#">														 	 					and Uano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
						and Umes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
						and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNOFACT.Moneda#">
					else 
					 	insert into UtilidadVarValor
							(ID_Utilidad,
							 Ecodigo,
							 Uano,
							 Umes,
							 Moneda,
							 Imp_Ingreso,
							 Imp_Costo,
							 BMfecha,
							 BMUsucodigo)
							values
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarUtilidadNF.ID_Utilidad#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNOFACT.Ecodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNOFACT.Moneda#">,
							 0 - <cfqueryparam cfsqltype="cf_sql_float" value="#rsNOFACT.Imp_Ingreso_Actual#">,
							 0 - <cfqueryparam cfsqltype="cf_sql_float" value="#rsNOFACT.Imp_Costo_Actual#">,<!---???--->
							 getdate(),
							<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">)
						</cfquery>
						
					<cfquery datasource="#GvarConexion#">
						update SaldosUtilidad  set Reversado = 1 
						where ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNOFACT.ID_Saldo#">
					</cfquery>					
			</cfloop>
	</cfif>
	
<!---<!---SUMA EL VOLUMEN DEL MES ANTERIOR----->
<cfquery name="rsVolAnt" datasource="#GvarConexion#">
	select AVid, Ecodigo, convert (float,AVvalor) as Vol_Barriles, AVano as Periodo, AVmes as Mes
	from AnexoVarValor where Ecodigo 
	<cfif rsEquivA.recordcount GT 0>
		in (<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">, #Ecodigo#)
	<cfelse>
		= <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
	</cfif>
	and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
	and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#"> - 1	
</cfquery>

<cfif rsVolAnt.recordcount GT 0>
	<cfloop query="rsVolAnt">
		<cfquery datasource="#GvarConexion#">
			if exists (select 1 from AnexoVarValor 
			   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVolAnt.Ecodigo#">
 			   and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVolAnt.AVid#">
			   and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
		       and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
			update AnexoVarValor set AVvalor = 
			convert (varchar(50),(convert(float,AVvalor) + 								        	            		       		<cfqueryparam cfsqltype="cf_sql_float" value="#rsVolAnt.Vol_Barriles#">)) 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVolAnt.Ecodigo#"> 						           	and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVolAnt.AVid#">
			and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
			and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
	  		else insert into AnexoVarValor
				 (AVid,
				 AVano,
				 AVmes,
				 Ecodigo,                                                                  
				 Ocodigo,                                                                  
				 AVvalor,
				 BMfecha,
				 BMUsucodigo,                                                              
				 GOid,
				 GEid)
				values
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsVolAnt.AVid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsVolAnt.Ecodigo#">,
				-1,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVolAnt.Vol_Barriles#">,
				getdate(),
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
				-1,
				-1)   
		</cfquery>	
	</cfloop>
</cfif>
--->				
	<cftransaction action="commit"/>
		<cfcatch>
		<cftransaction action="rollback"/>
   		<cfset varError = true>			
		<cfif isdefined("cfcatch.Message")>
			<cfset Mensaje="#cfcatch.Message#">
       	<cfelse>
 	       <cfset Mensaje="">
        </cfif>
        <cfif isdefined("cfcatch.Detail")>
	       <cfset Detalle="#cfcatch.Detail#">
    	<cfelse>
            <cfset Detalle="">
        </cfif>
        <cfif isdefined("cfcatch.sql")>
           	<cfset SQL="#cfcatch.sql#">
	    <cfelse>
    	    <cfset SQL="">
        </cfif>
        <cfif isdefined("cfcatch.where")>
            <cfset PARAM="#cfcatch.where#">
	    <cfelse>
    	    <cfset PARAM="">
        </cfif>
        <cfif isdefined("cfcatch.StackTrace")>
            <cfset PILA="#cfcatch.StackTrace#">
	    <cfelse>
    	   <cfset PILA="">
        </cfif>
           <cfset MensajeError= #Mensaje# & #Detalle#>
		<cfthrow message="#MensajeError#">
		</cfcatch>
	</cftry>
</cftransaction>	
							
<cfif not varError>
	<cflocation url="/cfmx/ModuloIntegracion/VtasOrdenComercial/InterfazVtas-CostoOrden-form.cfm"> <!----cambiar--->
<cfelse>
	<form name="form1" action="InterfazVtas_CostoOrden-form.cfm" method="post">
    	<center>
        	<table border="1" align="center">
            	<tr>
                	<td width="100%" align="center">
                    	<strong> SE PRESENTARON ERRORES AL GUARDAR LOS REGISTROS</strong>
                    </td>
                </tr>
                <tr>
	               	<td width="100%" align="center">
                    	<input type="submit" name="btnRegresa" value="Regresar" />
                    </td>
                </tr>
            </table>
        </center>
    </form>
</cfif>


<cf_templatefooter>