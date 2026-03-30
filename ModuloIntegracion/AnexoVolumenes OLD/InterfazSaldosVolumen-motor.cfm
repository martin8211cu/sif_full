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

<cfquery name="rsAnexoVolumen" datasource="#GvarConexion#">
   	select Ecodigo, #form.fltPeriodo# as Periodo, #form.fltMes# as Mes, Clas_Venta_Lin, Cod_Item, Clas_Venta, Volumen, Usuario
	from AnexoVolumen
	where Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
</cfquery>	

<cfquery name="rsAnexoVar" datasource="#GvarConexion#">
	select AVid from AnexoVar where AVnombre like 'TER%' or AVnombre like 'IMP%' or AVnombre like 'EXP%' or AVnombre like   	'VTA%' or AVnombre like 'VTM%' or AVnombre like 'VNA%' or AVnombre like 'VTN%' or AVnombre like 'VAE%'
</cfquery>

<cfloop query="rsAnexoVar">
	<cfquery datasource="#GvarConexion#">
		if not exists (select 1 from AnexoVarValor 
		   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
 		   and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVar.AVid#">
		   and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
		   and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
		   insert into AnexoVarValor
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
				 (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVar.AVid#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
				  -1,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
      			  getdate(),
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
				  -1,
				  -1)
	</cfquery>				 
</cfloop>

<cfloop query="rsAnexoVolumen">			
	<cfquery datasource="#GvarConexion#">
		if exists (select 1 from SaldosVolumen 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumen.Ecodigo#">
		    and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumen.Periodo#">
			and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumen.Mes#">
			and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumen.Clas_Venta_Lin#">
    		and Producto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumen.Cod_Item#">
			and Tipo_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumen.Clas_Venta#">)
			update SaldosVolumen set Volumen_Documento = Volumen_Documento + <cfqueryparam cfsqltype="cf_sql_float" value=    	    "#rsAnexoVolumen.Volumen#">,
			Volumen_Actual = Volumen_Actual + <cfqueryparam cfsqltype="cf_sql_float" value="#rsAnexoVolumen.Volumen#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumen.Ecodigo#">
		    and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumen.Periodo#">
			and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumen.Mes#">
			and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumen.Clas_Venta_Lin#">
    		and Producto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumen.Cod_Item#">
			and Tipo_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumen.Clas_Venta#">
		else
			insert into SaldosVolumen
			(Ecodigo,
			Periodo,
			Mes, 
			Clas_Venta,
			Producto,
			Tipo_Documento,
			Volumen_Documento,
			Volumen_Actual,
			Usuario)
			values
			(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumen.Ecodigo#">,
		    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumen.Periodo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumen.Mes#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumen.Clas_Venta_Lin#">,
    		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumen.Cod_Item#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumen.Clas_Venta#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#rsAnexoVolumen.Volumen#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#rsAnexoVolumen.Volumen#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumen.Usuario#">)
		</cfquery>
</cfloop>
		
	   <cfquery name="rsValores" datasource="#GvarConexion#">
                 	select Ecodigo, sum(Volumen) as Vol_Barriles,#form.fltPeriodo# as Periodo, #form.fltMes# as Mes, 				                    Clas_Venta_Lin, Cod_Item  
					from AnexoVolumen
					where Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
					group by Ecodigo, Periodo, Mes, Clas_Venta_Lin, Cod_Item
		</cfquery>
													
		<cfif isdefined("rsValores") and rsValores.recordcount GT 0>
			<cfloop query="rsValores">
				<!----Obtiene valore para la clave---->
				<cfset Clave = rsValores.Clas_Venta_Lin & rsValores.Cod_Item>
								
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
				<cfquery name="rsVarAnexo" datasource="#GvarConexion#">
					select AVid from AnexoVar 
					where AVnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Clave#">
				</cfquery>

					<!----Inserta a la tabla de AnexoVar---->
					<cfif rsVarAnexo.recordcount EQ 0>
						<cfquery name="insEncR" datasource="#GvarConexion#">
							insert into AnexoVar
							(CEcodigo,
							Ecodigo,                                                                       
							AVnombre,
            	    	    AVdescripcion,                                                                 
							AVtipo,  
							BMfecha,                                                                  
							BMUsucodigo,
							AVusar_oficina,          
							AVvalor_anual,       
							AVvalor_arrastrar)
							values
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCEcodigo.CEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Clave#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Clave#">,
							'F',
							getdate(),
							<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
							0,
							0,
							0)   
							<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
						</cfquery>
						
						<cf_dbidentity2 name="insEncR" verificar_transaccion="false" datasource="sifinterfaces">
					</cfif>	

					<cfquery datasource="#GvarConexion#">
						if exists (select 1 from AnexoVarValor 
								   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
 			    				   <cfif rsVarAnexo.recordcount GT 0>
									 and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexo.AVid#">
								   <cfelse>
								     and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncR.identity#">								 							       </cfif>
								   and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Periodo#">
						           and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Mes#">)
						           update AnexoVarValor set AVvalor = 
									convert (varchar(50),(convert(float,AVvalor) + 								                        			<cfqueryparam  cfsqltype="cf_sql_float" value="#rsValores.Vol_Barriles#">)) 
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#"> 					                     				<cfif rsVarAnexo.recordcount GT 0>
									  and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexo.AVid#">
								    <cfelse>
								  	  and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncR.identity#">								 							        </cfif>														 	 							   	                                and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Periodo#">
									and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Mes#">
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
								(<cfif rsVarAnexo.recordcount GT 0>
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexo.AVid#">,	
							   	 <cfelse>
								 	 <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncR.identity#">,								 							     </cfif>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Mes#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
								-1,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Vol_Barriles#">,
								getdate(),
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
								-1,
								-1)   
					</cfquery>
				</cfloop>
			</cfif>	

					<!---Inserta variable de tipo de cambio ???? Tambien se deben insertar en saldos y saldos mov--->
					<!---Obtener el tipo de cambio--->
					<cfquery name="rsTipoCambio" datasource="#GvarConexion#">	
						select tce.Ecodigo, tce.Periodo, tce.Mes, m.Miso4217, m.Mnombre, tce.TCEtipocambio 
						from TipoCambioEmpresa  tce	 
						inner join Monedas m
						on m.Mcodigo=tce.Mcodigo
						and m.Ecodigo=tce.Ecodigo	
						where tce.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
						and tce.Periodo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltPeriodo#">
						and tce.Mes= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltMes#">
						and m.Miso4217=<cfqueryparam cfsqltype="cf_sql_varchar" value="USD">
					</cfquery>
		
					<!----Obtiene valore para la clave del tipo de cambio---->
					<cfset ClaveTC = "TC-" & rsTipoCambio.Miso4217>
								
					<!---Obtiene la descripción del registro--->
					<cfset DescripcionTC = rsTipoCambio.Mnombre>
			
					<!--- FUNCION GETCECODIGO --->
					<cfquery name="rsCEcodigo" datasource="#GvarConexion#">
    	    			select CEcodigo, Ecodigo 
						from Empresa E
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			    	</cfquery>
			
					<!----Valida si la variable ya existe--->
					<cfquery name="rsVarAnexoTC" datasource="#GvarConexion#">
						select AVid from AnexoVar 
						where AVnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveTC#">
					</cfquery>
	
					<!---Inserta variable y valor en las tablas de Anexos---->
					<cfif rsVarAnexoTC.recordcount EQ 0>
						<cfquery name="insEncTC"datasource="#GvarConexion#">
							insert into AnexoVar
							(CEcodigo,
							Ecodigo,                                                                       
							AVnombre,
					   	    AVdescripcion,                                                                 
							AVtipo,  
							BMfecha,                                                                  
							BMUsucodigo,
							AVusar_oficina,          
							AVvalor_anual,       
							AVvalor_arrastrar)
							values
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCEcodigo.CEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveTC#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#DescripcionTC#">,
							'F',
							getdate(),
							<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
							0,
							0,	
							0)   
							<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
               			</cfquery>
                     
			   	    	<cf_dbidentity2 name="insEncTC" verificar_transaccion="false" datasource="sifinterfaces">
					</cfif>
					
					<cfquery datasource="#GvarConexion#">
						if exists (select 1 from AnexoVarValor 
								   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
 			    				   <cfif rsVarAnexoTC.recordcount GT 0>
									 and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoTC.AVid#">
								   <cfelse>
								     and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncTC.identity#">								 							       </cfif>
								   and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltPeriodo#">
						           and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltMes#">)
						           update AnexoVarValor set AVvalor = 
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTipoCambio.TCEtipocambio#"> 
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#"> 					                     				<cfif rsVarAnexoTC.recordcount GT 0>
									 and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoTC.AVid#">
								   <cfelse>
								     and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncTC.identity#">								 							       </cfif>
									and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltPeriodo#">
									and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltMes#">
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
							(<cfif rsVarAnexoTC.recordcount GT 0>
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoTC.AVid#">,
							 <cfelse>
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncTC.identity#">,								 							 </cfif>
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltPeriodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltMes#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
							 -1,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTipoCambio.TCEtipocambio#">,
 							 getdate(),
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
 							 -1,
							 -1)   						
						</cfquery>						
										
		<cfquery datasource="#GvarConexion#">
			delete AnexoVolumen where Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value=            "#GvarUsucodigo#">
		</cfquery>		
						
		<!----Inserta Ventas para NASA---->
		<cfquery name="rsNasa" datasource = "#GvarConexion#">
			select  I.Ecodigo, sum(Vol_Barriles) as Vol_Barriles, E.Periodo, E.Mes,
			Clas_Venta_Lin, Clas_Item, E.Clas_Venta, CCTtipo 
			from #sifinterfacesdb#..ESIFLD_Facturas_Venta E
			inner join #sifinterfacesdb#..DSIFLD_Facturas_Venta D on E.ID_DocumentoV = D.ID_DocumentoV
			inner join #sifinterfacesdb#..int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
			inner join CCTransacciones T on T.CCTcodigo = E.Tipo_Documento and T.Ecodigo = I.Ecodigo
			where E.Periodo is not null and E.Mes is not null and E.Contabilizado = 0 and Estatus = 2 and I.Ecodigo = 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and ((Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
			Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
			or  (Periodo < <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
			Mes <= 12))
			and Cliente = '716'
			group by E.Periodo, E.Mes, Clas_Venta_Lin, D.Clas_Item, I.Ecodigo, E.Clas_Venta, T.CCTtipo
		</cfquery>
		
		<cfif rsNasa.recordcount GT 0>
			<cfloop query="rsNasa">
				<cfquery name="rsVerifica" datasource="#GvarConexion#">
	    			select Ecodigo, Periodo, Mes, CCTtipo, Cod_Item, Clas_Venta_Lin from AnexoVolumen
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNasa.Ecodigo#">
					and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNasa.Periodo#"> 
					and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNasa.Mes#"> 
					and Cod_Item = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNasa.Clas_Item#">
					and Clas_Venta_Lin = <cfqueryparam cfsqltype="cf_sql_varchar" value="VNA"> <!----Tipo de Vta Nasa--->			    			    and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNasa.Clas_Venta#">
					and Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
				</cfquery>
				
				<cfif rsVerifica.recordcount EQ 0>		
					<cfquery datasource="#GvarConexion#">
					insert into AnexoVolumen
					(Ecodigo, Periodo, Mes, Clas_Venta, Cod_Item, CCTtipo, Clas_Venta_Lin, Volumen, Usuario)
					values
					(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsNasa.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsNasa.Periodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsNasa.Mes#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNasa.Clas_Venta#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNasa.Clas_Item#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNasa.CCTtipo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="VNA">,
					<cfif rsNasa.CCTtipo EQ 'D'>
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsNasa.Vol_Barriles#">,
					<cfelse>
						-1 * <cfqueryparam cfsqltype="cf_sql_float" value="#rsNasa.Vol_Barriles#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">) 
					</cfquery>						
				<cfelse>
					<cfquery datasource="#GvarConexion#">
					    update AnexoVolumen
					    set 
						<cfif rsNasa.CCTtipo EQ 'D'>
						   	Volumen = Volumen + <cfqueryparam cfsqltype="cf_sql_float" value="#rsNasa.Vol_Barriles#">
						<cfelse>
							Volumen = Volumen - <cfqueryparam cfsqltype="cf_sql_float" value="#rsNasa.Vol_Barriles#">
						</cfif>
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNasa.Ecodigo#">
						and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNasa.Periodo#"> 
						and	Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNasa.Mes#"> 
						and Cod_Item = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNasa.Clas_Item#">
						and Clas_Venta_Lin = <cfqueryparam cfsqltype="cf_sql_varchar" value="VNA">
		   				and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNasa.Clas_Venta#">
					</cfquery>
				</cfif>
			</cfloop>
		
		<!----Inserta registros de SaldosVolumen--->
		<cfquery name="rsAnexoVolumenN" datasource="#GvarConexion#">
   			select Ecodigo, #form.fltPeriodo# as Periodo, #form.fltMes# as Mes, Clas_Venta_Lin, Cod_Item, Clas_Venta, 																            Volumen, Usuario
			from AnexoVolumen
			where Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
		</cfquery>	
			
		<cfloop query="rsAnexoVolumenN">			
			<cfquery datasource="#GvarConexion#">
				if exists (select 1 from SaldosVolumen 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenN.Ecodigo#">
			    and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenN.Periodo#">
				and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenN.Mes#">
				and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenN.Clas_Venta_Lin#">
    			and Producto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenN.Cod_Item#">
				and Tipo_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenN.Clas_Venta#">)
				update SaldosVolumen set Volumen_Documento = Volumen_Documento + <cfqueryparam cfsqltype="cf_sql_float" 			               value= "#rsAnexoVolumenN.Volumen#">,
			   Volumen_Actual = Volumen_Actual + <cfqueryparam cfsqltype="cf_sql_float" value="#rsAnexoVolumenN.Volumen#">
			   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenN.Ecodigo#">
 	  	       and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenN.Periodo#">
			   and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenN.Mes#">
			   and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenN.Clas_Venta_Lin#">
    		   and Producto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenN.Cod_Item#">
			   and Tipo_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenN.Clas_Venta#">
		   else
			   insert into SaldosVolumen
			   (Ecodigo,
			   Periodo,
			   Mes, 
			   Clas_Venta,
			   Producto,
			   Tipo_Documento,
			   Volumen_Documento,
			   Volumen_Actual,
			   Usuario)
			   values
			  (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenN.Ecodigo#">,
		       <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenN.Periodo#">,
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenN.Mes#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenN.Clas_Venta_Lin#">,
    		   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenN.Cod_Item#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenN.Clas_Venta#">,
			   <cfqueryparam cfsqltype="cf_sql_float" value="#rsAnexoVolumenN.Volumen#">,
			   <cfqueryparam cfsqltype="cf_sql_float" value="#rsAnexoVolumenN.Volumen#">,
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenN.Usuario#">)
		   </cfquery>
        </cfloop>
			<cfquery name="rsValoresN" datasource="#GvarConexion#">
             	select Ecodigo, sum(Volumen) as Vol_Barriles, #form.fltPeriodo# as Periodo, #form.fltMes# as Mes,                Clas_Venta_Lin, Cod_Item  from AnexoVolumen
			  	where Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
			  	group by Ecodigo, Periodo, Mes, Clas_Venta_Lin, Cod_Item
			</cfquery>
		
			<cfif rsValoresN.recordcount GT 0>
				<cfloop query="rsValoresN">	
				<!----Obtiene valore para la clave---->
				<cfset ClaveN = rsValoresN.Clas_Venta_Lin & rsValoresN.Cod_Item>
									
				<!----Valida si la variable ya existe--->
				<cfquery name="rsVarAnexoN" datasource="#GvarConexion#">
					select AVid from AnexoVar 
					where AVnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveN#">
				</cfquery>
			
				<cfif rsVarAnexoN.recordcount EQ 0>
					<!---Inserta variable para NASA---->
					<cfquery name="insEncNA" datasource="#GvarConexion#">
						insert into AnexoVar
						(CEcodigo,
						Ecodigo,                                                                       
						AVnombre,
					    AVdescripcion,                                                                 
						AVtipo,  
						BMfecha,                                                                  
						BMUsucodigo,
						AVusar_oficina,          
						AVvalor_anual,       
						AVvalor_arrastrar)
						values
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCEcodigo.CEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveN#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveN#">,
						'F',
						getdate(),
						<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
						0,
						0,	
						0)   
						<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
        		   	</cfquery>
				</cfif>				
									
					<cf_dbidentity2 name="insEncNA" verificar_transaccion="false" datasource="#GvarConexion#">			
					<cfquery datasource="#GvarConexion#">
						if exists (select 1 from AnexoVarValor 
					    	   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
 				    		   <cfif rsVarAnexoN.recordcount GT 0>
									and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoN.AVid#">
							   <cfelse>
								 	and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncNA.identity#">
 	 					   	   </cfif>
							   and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresN.Periodo#">
							   and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresN.Mes#">)
							   update AnexoVarValor set AVvalor = 
   								convert (varchar(50),(convert(float,AVvalor) + 								        	                		        <cfqueryparam cfsqltype="cf_sql_float" value="#rsValoresN.Vol_Barriles#">)) 
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#"> 					                    	 		<cfif rsVarAnexoN.recordcount GT 0>
									and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoN.AVid#">
							    <cfelse>
								 	and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncNA.identity#">
 	 					   	    </cfif>	
								and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresN.Periodo#">
								and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresN.Mes#">
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
								(<cfif rsVarAnexoN.recordcount GT 0>
								 	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoN.AVid#">,
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#insEncNA.identity#">,														 		 						</cfif>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresN.Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresN.Mes#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
								-1,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValoresN.Vol_Barriles#">,
								getdate(),
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
								-1,
								-1)   
						</cfquery>
					</cfloop>
			</cfif>	
			<cfquery datasource="#GvarConexion#">
     			delete AnexoVolumen where Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value=                "#GvarUsucodigo#">
			</cfquery>
		</cfif> <!---IF DE NASA--->
		
<!----Inserta Venta para MEXPAN---->
<!---Se obtienen la(s) empresas intercompañia de las equivalencias--->
<cfquery name="rsEquiv" datasource="#GvarConexion#">
	select EQUcodigoOrigen, EQUcodigoSIF, EQUdescripcion, EQUidSIF 
    from #sifinterfacesdb#..SIFLD_Equivalencia
    where SIScodigo = 'ICTS'
    and CATcodigo = 'SOCIO_ANEX'
	and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
</cfquery>

	<cfif rsEquiv.recordcount GT 0>
			<cfloop query="rsEquiv">
				<cfquery name="rsInter" datasource = "#GvarConexion#">
					select  I.Ecodigo, sum(Vol_Barriles) as Vol_Barriles, E.Periodo, E.Mes,
					Clas_Venta_Lin, Clas_Item, E.Clas_Venta, CCTtipo 
					from #sifinterfacesdb#..ESIFLD_Facturas_Venta E
					inner join #sifinterfacesdb#..DSIFLD_Facturas_Venta D on E.ID_DocumentoV = D.ID_DocumentoV
					inner join #sifinterfacesdb#..int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
					inner join CCTransacciones T on T.CCTcodigo = E.Tipo_Documento and T.Ecodigo = I.Ecodigo
					where E.Periodo is not null and E.Mes is not null and E.Contabilizado = 0 and Estatus = 2 and 													                    I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
					and ((Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
					Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
					or  (Periodo < <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
					Mes <= 12))
					and Cliente = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEquiv.EQUcodigoOrigen#">
					group by E.Periodo, E.Mes, Clas_Venta_Lin, D.Clas_Item, I.Ecodigo, E.Clas_Venta, T.CCTtipo
				</cfquery>
				
				<cfif rsInter.recordcount GT 0>
					<cfloop query="rsInter">
					<cfquery name="rsVerifica" datasource="#GvarConexion#">
	    				select Ecodigo, Periodo, Mes, CCTtipo, Cod_Item, Clas_Venta_Lin from AnexoVolumen
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquiv.EQUidSIF#">
						and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsInter.Periodo#"> 
						and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsInter.Mes#"> 
						and Cod_Item = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInter.Clas_Item#">
						and Clas_Venta_Lin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInter.Clas_Venta_Lin#"> 
						and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInter.Clas_Venta#">
						and Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
					</cfquery>
				
					<cfif rsVerifica.recordcount EQ 0>		
						<cfquery datasource="#GvarConexion#">
						insert into AnexoVolumen
						(Ecodigo, Periodo, Mes, Clas_Venta, Cod_Item, CCTtipo, Clas_Venta_Lin, Volumen, Usuario)
						values
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquiv.EQUidSIF#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsInter.Periodo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsInter.Mes#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInter.Clas_Venta#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInter.Clas_Item#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInter.CCTtipo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInter.Clas_Venta_Lin#">,
						<cfif rsInter.CCTtipo EQ 'D'>
							-1 * <cfqueryparam cfsqltype="cf_sql_float" value="#rsInter.Vol_Barriles#">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_float" value="#rsInter.Vol_Barriles#">,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">) 
						</cfquery>						
					<cfelse>
						<cfquery datasource="#GvarConexion#">
					    update AnexoVolumen
					    set 
						<cfif rsInter.CCTtipo EQ 'D'>
						   	Volumen = Volumen - <cfqueryparam cfsqltype="cf_sql_float" value="#rsInter.Vol_Barriles#">
						<cfelse>
							Volumen = Volumen + <cfqueryparam cfsqltype="cf_sql_float" value="#rsInter.Vol_Barriles#">
						</cfif>
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquiv.EQUidSIF#">
						and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsInter.Periodo#"> 
						and	Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsInter.Mes#"> 
						and Cod_Item = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInter.Clas_Item#">
						and Clas_Venta_Lin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInter.Clas_Venta_Lin#">
		   				and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInter.Clas_Venta#">
						</cfquery>
					</cfif>
				</cfloop>
			</cfif>
				
			
		<!----Inserta registros de SaldosVolumen--->
		<cfquery name="rsAnexoVolumenI" datasource="#GvarConexion#">
   			select Ecodigo, #form.fltPeriodo# as Periodo, #form.fltMes# as Mes, Clas_Venta_Lin, Cod_Item, Clas_Venta,            Volumen, Usuario
			from AnexoVolumen
			where Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
		</cfquery>	

		<cfloop query="rsAnexoVolumenI">			
			<cfquery datasource="#GvarConexion#">
				if exists (select 1 from SaldosVolumen 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenI.Ecodigo#">
			    and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenI.Periodo#">
				and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenI.Mes#">
				and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenI.Clas_Venta_Lin#">
    			and Producto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenI.Cod_Item#">
				and Tipo_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenI.Clas_Venta#">)
				update SaldosVolumen set Volumen_Documento = Volumen_Documento + <cfqueryparam cfsqltype="cf_sql_float" 			               value= "#rsAnexoVolumenI.Volumen#">,
			   Volumen_Actual = Volumen_Actual + <cfqueryparam cfsqltype="cf_sql_float" value="#rsAnexoVolumenI.Volumen#">
			   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenI.Ecodigo#">
 	  	       and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenI.Periodo#">
			   and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenI.Mes#">
			   and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenI.Clas_Venta_Lin#">
    		   and Producto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenI.Cod_Item#">
			   and Tipo_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenI.Clas_Venta#">
		   else
			   insert into SaldosVolumen
			   (Ecodigo,
			   Periodo,
			   Mes, 
			   Clas_Venta,
			   Producto,
			   Tipo_Documento,
			   Volumen_Documento,
			   Volumen_Actual,
			   Usuario)
			   values
			  (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenI.Ecodigo#">,
		       <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenI.Periodo#">,
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenI.Mes#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenI.Clas_Venta_Lin#">,
    		   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenI.Cod_Item#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnexoVolumenI.Clas_Venta#">,
			   <cfqueryparam cfsqltype="cf_sql_float" value="#rsAnexoVolumenI.Volumen#">,
			   <cfqueryparam cfsqltype="cf_sql_float" value="#rsAnexoVolumenI.Volumen#">,
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAnexoVolumenI.Usuario#">)
		   </cfquery>
        </cfloop>
			
			<cfquery name="rsValoresI" datasource="#GvarConexion#">
           		select Ecodigo, sum(Volumen) as Vol_Barriles, #form.fltPeriodo# as Periodo, #form.fltMes# as Mes,                Clas_Venta_Lin, Cod_Item  from AnexoVolumen
			  	where Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
			  	group by Ecodigo, Periodo, Mes, Clas_Venta_Lin, Cod_Item
			</cfquery>
		
			<cfif rsValoresI.recordcount GT 0>
				<cfloop query="rsValoresI">	
				<!----Obtiene valores para la clave---->
				<cfset ClaveI = rsValoresI.Clas_Venta_Lin & rsValoresI.Cod_Item>
								
			
				<!--- FUNCION GETCECODIGO --->
				<cfquery name="rsCEcodigo" datasource="#GvarConexion#">
        			select CEcodigo, Ecodigo 
					from Empresa E
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresI.Ecodigo#">
			    </cfquery>
					
				<cfif rsCEcodigo.recordcount EQ 0>
					<cfthrow message="No existe el codigo para la empresa">
				</cfif>
			
				<!----Valida si la variable ya existe--->
				<cfquery name="rsVarAnexoI" datasource="#GvarConexion#">
					select AVid from AnexoVar 
					where AVnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveI#">
				</cfquery>
		
				<cfif rsVarAnexoI.recordcount EQ 0>
					<cfquery name="insEncI" datasource="#GvarConexion#">
						insert into AnexoVar
						(CEcodigo,
						Ecodigo,                                                                       
						AVnombre,
					    AVdescripcion,                                                                 
						AVtipo,  
						BMfecha,                                                                  
						BMUsucodigo,
						AVusar_oficina,          
						AVvalor_anual,       
						AVvalor_arrastrar)
						values
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCEcodigo.CEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresI.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveI#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveI#">,
						'F',
						getdate(),
						<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
						0,
						0,	
						0)   
						<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
    	       		</cfquery>
						<cf_dbidentity2 name="insEncI" verificar_transaccion="false" datasource="#GvarConexion#">										
				</cfif>
				
				<cfquery datasource="#GvarConexion#">
					if exists (select 1 from AnexoVarValor 
				    	   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresI.Ecodigo#">
 			    		   <cfif rsVarAnexoI.recordcount GT 0>
								and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoI.AVid#">
						   <cfelse>
								and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncI.identity#">
						   </cfif>
						   and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresI.Periodo#">
						   and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresI.Mes#">)
						   update AnexoVarValor set AVvalor = 
						   convert (varchar(50),(convert(float,AVvalor) + 								        	            		       <cfqueryparam cfsqltype="cf_sql_float" value="#rsValoresI.Vol_Barriles#">)) 
						   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresI.Ecodigo#"> 						               	 		  <cfif rsVarAnexoI.recordcount GT 0>
								and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoI.AVid#">
						   <cfelse>
								and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncI.identity#">
						   </cfif>																 	 					                           and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresI.Periodo#">
						   and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresI.Mes#">
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
								(<cfif rsVarAnexoI.recordcount GT 0>
								 	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoI.AVid#">,
								 <cfelse>
								 	<cfqueryparam cfsqltype="cf_sql_integer" value="#insEncI.identity#">,
								 </cfif>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresI.Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresI.Mes#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValoresI.Ecodigo#">,
								-1,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValoresI.Vol_Barriles#">,
								getdate(),
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
								-1,
								-1)   
						</cfquery>										
    	        </cfloop>
			</cfif>	
		</cfloop>
	</cfif>
		
		<!---Actualización de la tabla intermedia de registros contabilizados--->
		<cfquery name="rsIDIntermedia" datasource="#GvarConexion#">
			select E.ID_DocumentoV
			from #sifinterfacesdb#..ESIFLD_Facturas_Venta E
			inner join #sifinterfacesdb#..DSIFLD_Facturas_Venta D on E.ID_DocumentoV = D.ID_DocumentoV
			inner join #sifinterfacesdb#..int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
			where E.Periodo is not null  and E.Mes is not null  and E.Contabilizado = 0 and I.Ecodigo = 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and ((Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
			Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
			or  (Periodo < <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
			Mes <= 12))
		</cfquery>
					
		<cfif rsIDIntermedia.recordcount GT 0>
			<cfloop query="rsIDIntermedia">
			  <cfquery datasource="#GvarConexion#">
				update #sifinterfacesdb#..ESIFLD_Facturas_Venta set Contabilizado = 1, Mes_Contabilizado = <cfqueryparam                cfsqltype= "cf_sql_integer" value="#form.fltMes#"> where ID_DocumentoV = <cfqueryparam cfsqltype=                "cf_sql_integer" value="#rsIDIntermedia.ID_DocumentoV#">
			  </cfquery>
			</cfloop>
		</cfif>

<!---Obtiene Ecodigo de las Equivalencias--->		
<cfquery name="rsEquivA" datasource="#GvarConexion#">
	select distinct(EQUidSIF) 
    from #sifinterfacesdb#..SIFLD_Equivalencia
   	where SIScodigo = 'ICTS'
    and CATcodigo = 'SOCIO_ANEX'
	and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
</cfquery>

<cfif rsEquivA.recordcount GT 1>
	<cfset Ecodigo = ''>
	<cfloop query="rsEquivA">
		<cfif Ecodigo EQ "">
			<cfset Ecodigo = rsEquivA.EQUidSIF>
		<cfelse>
			<cfset Ecodigo = Ecodigo & ', ' & rsEquivA.EQUidSIF>
		</cfif>		
	</cfloop>
<cfelseif rsEquivA.recordcount EQ 1 >
	<cfset Ecodigo = rsEquivA.EQUidSIF>
</cfif>
		
	<!---Consulta registros NOFACT del mes anterior---->
		<cfquery name="rsNOFACT" datasource="#GvarConexion#">
			select ID_Saldo, Ecodigo, Clas_Venta, Periodo, Mes, Producto, Volumen_Actual
			from SaldosVolumen
			where Reversado = 0	
			and Ecodigo 
			<cfif rsEquivA.recordcount GT 0>
				in (<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">, #Ecodigo#)
			<cfelse>
				= <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfif>
			<cfif form.fltMes EQ 1>
				and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> - 1
				and Mes = 12
			<cfelse>
				and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
				and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#"> - 1
			</cfif>
			and Tipo_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRNF">
		</cfquery>		
				
		<cfif rsNOFACT.recordcount GT 0>
			<cfloop query="rsNOFACT">
				<!----Obtiene la variable del anexo--->
				<cfquery name="rsVarAnexoNF" datasource="#GvarConexion#">
					select AVid from AnexoVar 
					where AVnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value=                    "#rsNOFACT.Clas_Venta##rsNOFACT.Producto#">
				</cfquery>
				
				<cfquery name="rsVarAnexoValor" datasource="#GvarConexion#">
					if exists (select 1 from AnexoVarValor where AVid = <cfqueryparam cfsqltype="cf_sql_integer" value= 							                	    "#rsVarAnexoNF.AVid#"> 
						and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> 
						and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">			                        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNOFACT.Ecodigo#">)
                    	update AnexoVarValor set AVvalor =  convert (varchar(50),(convert(float,AVvalor) - 	
	 		        	<cfqueryparam cfsqltype="cf_sql_float" value="#rsNOFACT.Volumen_Actual#">)) 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNOFACT.Ecodigo#"> 					                    	and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoNF.AVid#">														 	 					and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
						and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
					else 
					 	insert into AnexoVarValor
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
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoNF.AVid#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsNOFACT.Ecodigo#">,
							-1,
							convert(varchar(50),(0 - <cfqueryparam cfsqltype="cf_sql_float" value="#rsNOFACT.Volumen_Actual#">)),
							getdate(),
							<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
							-1,
							-1)   
					</cfquery>
					
					<cfquery datasource="#GvarConexion#">
						update SaldosVolumen set Reversado = 1 where ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNOFACT.ID_Saldo#">
					</cfquery>
			</cfloop>
	</cfif>
	
<!---SUMA EL VOLUMEN DEL MES ANTERIOR----->
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
	<cflocation url="/cfmx/ModuloIntegracion/AnexoVolumenes/InterfazSaldosVolumen-form.cfm"> <!----cambiar--->
<cfelse>
	<form name="form1" action="InterfazSaldosVolumen-form.cfm" method="post">
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