<!--- Se determina el proceso que se esta ejecutando (Relaciones o Depreciasion) --->
<!--- 
Tipo de Proceso
1.Plantas y Centrales
2.Inmovilizados
3.Relaciones
--->
<cfif proceso eq 1><!--- Depresiacion --->

	<!--- Se verifica si es para plantas y centrales, o para inmovilizados --->
	<cfif txt_tipodep eq 1><!--- Plantas y Centrales --->


		<cftransaction>
		<cftry>
		
			<cfif PMAM eq "PM">
				<cfset HORA = #Val(HORA)# + 12>		
			</cfif>
		
			<cfset horagen = #dateformat(createtime(HORA,MINUTOS,0),"yyyy/mm/dd HH:mm:ss")#>
			<cfset fecha_hoy=#dateformat(Now(),"yyyy/mm/dd")#>
		
			<cfset cat1=0>
			<cfset cat2=0>		
			<cfset Chk_ADQ = 1>
			<cfset Chk_MEJ = 1>
			<cfset Chk_REV = 1>
			<cfset tipo = 1>
			
			<!--- Insertar los datos en alguna tabla para que el demonio deprecie según la hora --->
			
			<!--- Inclusion del Encabezado --->
			<cfquery datasource="#session.Conta.dsn#">
			Insert tbl_transaccionescf(
										tipo_proceso,
										fecha,
										horageneracion,
										usuario,									
										estado,
										Detalle)
								values(
										1,
										'#fecha_hoy#',
										'#horagen#',
										'#trim(session.usuario)#',
										'P',
										'Plantas y Centrales'
									   )
			</cfquery>
			
			<cfquery datasource="#session.Conta.dsn#" name="nuevoid">
			select max(id) as nid from tbl_transaccionescf
			</cfquery>		
			
			<cfoutput query="nuevoid">
			<cfset nid=#nid#>
			</cfoutput>
			
			<!--- Inclusion del detalle --->
			<cfquery datasource="#session.Conta.dsn#">
				Insert tbl_depreciacioncf(  
											id,
											categoriainicial,
											categoriafinal,										
											dep_adquisicion,
											dep_Mejora,
											dep_Revaluacion
										 )
				values(						#nid#,
											'#cat1#',
											'#cat2#',										
											#Chk_ADQ#,
											#Chk_MEJ#,
											#Chk_REV#
										)
			</cfquery>		
			
			<cftransaction action="commit"/>
	
			<cfcatch type="any">
				<cftransaction action="rollback"/>
				<script language="JavaScript">
				var  mensaje = "<cfoutput>#trim(cfcatch.Detail)#</cfoutput>"
				mensaje = mensaje.substring(40,300)
				alert(mensaje)
				history.back()
				</script>
				<cfabort>
			</cfcatch>
			
		</cftry>		
		</cftransaction> 		
	
	<cfelse><!--- Inmovilizados --->

		<cftransaction>
		<cftry>

			<cfif PMAM eq "PM">
				<cfset HORA = #Val(HORA)# + 12>		
			</cfif>
			<cfset horagen = #dateformat(createtime(HORA,MINUTOS,0),"yyyy/mm/dd HH:mm:ss")#>
			<cfset fecha_hoy=dateformat(#Now()#,"yyyy/mm/dd")>
							
			<cfset Chk_ADQ = 1>
			<cfset Chk_MEJ = 1>
			<cfset Chk_REV = 1>
			<cfset tipo = 2>	

			<!--- Inclusion del Encabezado --->
			<cfquery datasource="#session.Conta.dsn#">
			Insert tbl_transaccionescf(
										tipo_proceso,
										fecha,
										horageneracion,
										usuario,									
										estado,
										Detalle)
								values(
										2,
										'#fecha_hoy#',
										'#horagen#',
										'#trim(session.usuario)#',
										'P',
										'#chktran#'
									   )
			</cfquery>
			
			<cfquery datasource="#session.Conta.dsn#" name="nuevoid">
			select max(id) as nid from tbl_transaccionescf
			</cfquery>
			
			<cfoutput query="nuevoid">
			<cfset nid=#nid#>
			</cfoutput>
			
	
			<!--- Recorre todas las categorias que seleccionó para incluirlas en la tabla --->
			<cfloop list="#chktran#" delimiters="," index="chk">
				<cfoutput>
					<cfset cat1=#chk#>
					<cfset cat2=#chk#>
					
					<!--- Insertar los datos en alguna tabla para que el demonio deprecie según la hora --->
					<cfquery datasource="#session.Conta.dsn#">
					Insert tbl_depreciacioncf(  id,
												categoriainicial,
												categoriafinal,											
												dep_adquisicion,
												dep_Mejora,
												dep_Revaluacion
											 )										 	
					values(						#nid#,
												'#cat1#',
												'#cat2#',											
												#Chk_ADQ#,
												#Chk_MEJ#,
												#Chk_REV#
											)
					</cfquery>
									
				</cfoutput>
			</cfloop>
		
			<cftransaction action="commit"/>
	
			<cfcatch type="any">
				<cftransaction action="rollback"/>
				<script language="JavaScript">
				var  mensaje = "<cfoutput>#trim(cfcatch.Detail)#</cfoutput>"
				mensaje = mensaje.substring(40,300)
				alert(mensaje)
				history.back()
				</script>
				<cfabort>
			</cfcatch>
			
		</cftry>		
		</cftransaction> 		
		
	</cfif>
	
<cfelse><!--- Relaciones --->

	<cftransaction>
	<cftry>
	
		<!--- Se verifica si se desea generar un nuevo asiento --->
		<cfif isdefined("chk_asiento")>
			<cfset asiento_nuevo = 1>
		<cfelse>
			<cfset asiento_nuevo = 0>
		</cfif>
		
		<cfif PMAM eq "PM">
			<cfset HORA = #Val(HORA)# + 12>
		</cfif>
	
		<cfset horagen = #dateformat(createtime(HORA,MINUTOS,0),"yyyy/mm/dd HH:mm:ss")#>		
		<cfset fecha_hoy=dateformat(#Now()#,"yyyy/mm/dd")>

		<!--- Inclusion del Encabezado --->
		<cfquery datasource="#session.Conta.dsn#">
			Insert tbl_transaccionescf(
										tipo_proceso,
										fecha,
										horageneracion,
										usuario,									
										estado,
										Detalle)
								values(
										3,
										'#fecha_hoy#',
										'#horagen#',
										'#trim(session.usuario)#',
										'P',
										'#chktran#'
									   )
		</cfquery>				

	
		<cfquery datasource="#session.Conta.dsn#" name="nuevoid">
		select max(id) as nid from tbl_transaccionescf
		</cfquery>
		
		<cfoutput query="nuevoid">
			<cfset nid = #nid#>
		</cfoutput>
	
		<cfloop list="#chktran#" delimiters="," index="NRel">
			
			<cfquery datasource="#session.Conta.dsn#" name="tiporel">
			select AF8TIP
			from af_relaciones
			where AF8NUM = #NRel#
			</cfquery>
						
			<cfoutput query="tiporel">				
				<cfset tipo=#AF8TIP#>
			</cfoutput>
		
			<cfif tipo eq "S">
				<cfquery datasource="#session.Conta.dsn#" name="TPA">
				Select AF8TPA from AFM008 where AF8NUM = #NRel#
				</cfquery>
				
				<cfoutput query="TPA">
					<cfif AF8TPA neq "G">
						<script>
						alert("DEBE GENERAR PRIMERO EL ARCHIVO DE TRASLADO ENTRE SECTORES")
						document.location = "cmn_Activos.cfm"
						</script>
						<cfabort>
					</cfif>
				</cfoutput>
			</cfif>	
			
			<cfquery datasource="#session.Conta.dsn#">
					Insert tbl_det_relaciones(  id,
												numero_relacion,
												resumido,
												asiento_nuevo,
												tipo)
					values(						#nid#,
												#NRel#,
												'S',
												#asiento_nuevo#,
												'#tipo#')
												<!--- 
												<cfif isdefined("chk_astres")>
													'S',
												<cfelse>
													'N',
												</cfif> --->									
			</cfquery>		
			
		</cfloop>

		<cftransaction action="commit"/>

		<cfcatch type="any">
			<cftransaction action="rollback"/>
			<script language="JavaScript">
			var  mensaje = "<cfoutput>#trim(cfcatch.Detail)#</cfoutput>"
			mensaje = mensaje.substring(40,300)
			alert(mensaje)
			history.back()
			</script>
			<cfabort>
		</cfcatch>
		
	</cftry>		
	</cftransaction>  
<!--- 
	<cfif tipo neq "T">
		
		<cfquery datasource="#session.Conta.dsn#" name="TPA">
			sp_Posteo_AF_BCR
			  	@Rel_Num  = #AF8NUM#,
				<cfif isdefined("chk_astres")>
  					@RESUMIDO = 'S',
				<cfelse>
					@RESUMIDO = 'N',
				</cfif>
  				@Asiento_Nuevo = #asiento_nuevo#
		</cfquery>	
					
	<cfelse>
		
		<cfquery datasource="#session.Conta.dsn#" name="TPA">
			af_Posteo_TransDeptoBCR
			  	@Rel_Num  = #AF8NUM#,
				<cfif isdefined("chk_astres")>
  					@RESUMIDO = 'S',
				<cfelse>
					@RESUMIDO = 'N',
				</cfif>
  				@Asiento_Nuevo = #asiento_nuevo#   				 
		</cfquery>	
				
	</cfif> --->
        
</cfif>
<cflocation addtoken="no" url="cmn_ProcesosAF.cfm">