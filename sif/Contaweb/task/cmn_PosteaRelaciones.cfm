<!--- 
Tipo de Proceso
1.Plantas y Centrales
2.Inmovilizados
3.Relaciones
--->

<cfif isdefined ("sqldemon.id")>
	<cfset url.LLAVE = #trim(sqldemon.id)#>
</cfif> 
<cfif isdefined ("sqldemon.usuario")>
	<cfset url.USER = #trim(sqldemon.usuario)#>
</cfif> 
<cfif isdefined ("sqldemon.tipo_proceso")>
	<cfset url.TIPO_PROCESO = #trim(sqldemon.tipo_proceso)#>
</cfif> 

<cfset LLAVE = #trim(url.LLAVE)#>
<cfset USER = #trim(url.USER)#>

<!--- 
<cfif isdefined ("url.IRALISTA")>
	<cfheader name="Content-Disposition" value="attachment; filename=#trim(USER)#_#LLAVE#">
	<cfcontent type="text/plain">
</cfif> 
<cfoutput> Creando el archivo #trim(USER)#_#LLAVE#<br></cfoutput> --->
<cfsetting requesttimeout="14000">
<cfsetting enablecfoutputonly="yes">

<cfset TIPO_PROCESO = #trim(url.TIPO_PROCESO)#>

		<!--- Cambia el estado --->
		<cfquery datasource="#session.Conta.dsn#"  name="sqlup" >	
		update tbl_transaccionescf
		set estado = <cfqueryparam cfsqltype="cf_sql_varchar"  value="E">
		where id = #LLAVE#
		</cfquery>
		
		
		<cfif TIPO_PROCESO eq 1><!--- Depresiacion de Plantas y Centrales --->
		
			<cfset nomproceso = "DEPRESIACION DE PLANTAS Y CENTRALES">
			<cfset detalle = "">
			
			<cfquery datasource="#session.Conta.dsn#"  name="DepPC">
			Select B.* , A.fecha
			from tbl_transaccionescf A, tbl_depreciacioncf B
			where A.id = B.id
			  and A.id = <cfqueryparam  cfsqltype="cf_sql_integer"  value="#LLAVE#">
			</cfquery>
		
			<cfoutput query="DepPC">
		
			<cftry>
		
				<cfquery datasource="#session.Conta.dsn#" name="DepPC">
					declare @error int
					/******************************************/
					/*  Depreciasion de Plantas y Centrales   */
					/******************************************/					
					
					exec @error = ICE_SIF..sp_AF_Depreciacion
						@Cat1		=	'#categoriainicial#',
						@Cat2		=	'#categoriafinal#',
						@Fec		=	'#fecha#',
						@Dep_Adq	=	#dep_adquisicion#,
						@Dep_Mej	=	#dep_Mejora#,
						@Dep_Rev	=	#dep_Revaluacion#,
						@tipo		=	1
						
					if @error != 0 begin
						raiserror 40000 'Error en el Proceso de Depreciasion de Plantas y Centrales'	
						return
					end	
				</cfquery>	
				
				<cfcatch type="any">

					<cfquery datasource="#session.Conta.dsn#">
					Update tbl_transaccionescf
					set estado = 'C'
					where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#llave#">
					</cfquery>

					<!--- Incluye el error en unatabla de errores --->
					<cfquery datasource="#session.Conta.dsn#">
					Insert into tbl_AFerrorescf(id,Proceso,Mensaje,Detalle)
					values(#LLAVE#,'#nomproceso#','#Mid(trim(cfcatch.Detail),41,len(trim(cfcatch.Detail)))#','#categoriainicial#')
					</cfquery>
						
				</cfcatch> 
				
			</cftry> 						
			
			</cfoutput>
		
		</cfif>
		
		<cfif TIPO_PROCESO eq 2><!--- Depresiacion de Inmovilizados --->
		
			<cfset nomproceso = "DEPRESIACION DE INMOVILIZADOS">
					
			<cfquery datasource="#session.Conta.dsn#"  name="DepCat">
			Select B.* , A.fecha, A.Detalle
			from tbl_transaccionescf A, tbl_depreciacioncf B
			where A.id = B.id
			  and A.id = <cfqueryparam  cfsqltype="cf_sql_integer"  value="#LLAVE#">
			</cfquery>
			
			<cfoutput query="DepCat">
				
			<cftry>
			
				<cfset detalleimv = #Detalle#>
							
				<cfquery datasource="#session.Conta.dsn#" name="TPA">
					
					declare @error int
					/******************************************/
					/*    Postea las Relaciones  			  */						
					/******************************************/
						
					exec @error = ICE_SIF..sp_AF_Depreciacion
						@Cat1		=	'#categoriainicial#',
						@Cat2		=	'#categoriafinal#',
						@Fec		=	'#fecha#',
						@Dep_Adq	=	#dep_adquisicion#,
						@Dep_Mej	=	#dep_Mejora#,
						@Dep_Rev	=	#dep_Revaluacion#,
						@tipo		=	2	
													
					if @error != 0 begin
						raiserror 40000 'Error en el Proceso de Depreciasion'	
						return
					end						
										
				</cfquery>	
			<!--- 
				<cfquery datasource="#session.Conta.dsn#">
				INSERT CATEGO(AF2CAT,ESTADO) values('#categoriainicial#','PASO BIEN')
				</cfquery>	 --->
			
				<cfcatch type="any">
					
					<cfset errores = 1>
					<!--- 
					<cfquery datasource="#session.Conta.dsn#">
					INSERT CATEGO(AF2CAT,ESTADO) values('#categoriainicial#','ERROR')
					</cfquery>	 --->									
										
					<!--- Incluye el error en unatabla de errores --->
					<cfquery datasource="#session.Conta.dsn#">
					Insert into tbl_AFerrorescf(id,Proceso,Mensaje,Detalle)
					values(#LLAVE#,'#nomproceso#','#Mid(trim(cfcatch.Detail),41,len(trim(cfcatch.Detail)))#','#categoriainicial#')
					</cfquery>
						
				</cfcatch> 
				
			</cftry> 				
			
			</cfoutput>
			
			<cfif isdefined("errores") and errores eq 1>
				
				<cfquery datasource="#session.Conta.dsn#">
				Update tbl_transaccionescf
				set estado = 'C'
				where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#llave#">
				</cfquery>
			
			</cfif>	
			<!--- Se generan los reportes de las categorias depreciadas --->
			<cfinclude template="cmn_CreaArchivoRelaciones.cfm">
					
		</cfif>
		
		<cfif TIPO_PROCESO eq 3><!--- Posteo de Relaciones --->
		
			<cfset nomproceso = "POSTEO DE RELACIONES">			 
			
			<cfquery datasource="#session.Conta.dsn#"  name="sqlrelaciones">
			Select B.numero_relacion, B.resumido, B.asiento_nuevo, B.tipo 
			from tbl_transaccionescf A, tbl_det_relaciones B 
			where A.id = B.id
			  and A.id = <cfqueryparam  cfsqltype="cf_sql_integer"  value="#LLAVE#">
			</cfquery>
									
			<cfoutput query="sqlrelaciones">
			
			<cftry>
			 				 
				<cfif tipo neq "T">
					
					<cfquery datasource="#session.Conta.dsn#" name="TPA">
						
						declare @error int
						/******************************************/
						/*    Postea las Relaciones  			  */						
						/******************************************/
						
						exec @error = ICE_SIF..sp_Posteo_AF_BCR
										@Rel_Num  = #numero_relacion#,
										@RESUMIDO = '#resumido#',					
										@Asiento_Nuevo = #asiento_nuevo#
													
						if @error != 0 begin
						raiserror 40000 'Error en el Posteo de las Relaciones'	
						return
						end
					
					</cfquery>
								
				<cfelse>
															
					<cfquery datasource="#session.Conta.dsn#" name="TPA">
						
						declare @error int
						/******************************************/
						/*    Postea las Relaciones  			  */						
						/******************************************/
						
						exec @error = ICE_SIF..af_Posteo_TransDeptoBCR						
										@Rel_Num  = #numero_relacion#,
										@RESUMIDO = '#resumido#',					
										@Asiento_Nuevo = #asiento_nuevo#
													
						if @error != 0 begin
						raiserror 40000 'Error en el Posteo de las Relaciones'	
						return
						end	 
												
					</cfquery>
							
				</cfif> 
				
				<cfcatch type="any">
					
					<cfquery datasource="#session.Conta.dsn#">
					Update tbl_transaccionescf
					set estado = 'C'
					where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#llave#">
					</cfquery>
					
					<!--- Incluye el error en una tabla de errores --->
					<cfquery datasource="#session.Conta.dsn#">
					Insert into tbl_AFerrorescf(id,Proceso,Mensaje,Detalle)
					values(#LLAVE#,'#nomproceso#','#Mid(trim(cfcatch.Detail),41,len(trim(cfcatch.Detail)))#','#numero_relacion#')
					</cfquery>
					
											
				</cfcatch> 
				
			</cftry> 				
			
			</cfoutput>
		
		</cfif>

		<cfquery datasource="#session.Conta.dsn#"  name="sql" >	
		set nocount on
		update  tbl_transaccionescf
		set estado = <cfqueryparam cfsqltype="cf_sql_varchar"  value="L">,
			horafinal = getdate()			
			where id = <cfqueryparam  cfsqltype="cf_sql_integer"  value="#LLAVE#">
		set nocount off
		</cfquery> 	 