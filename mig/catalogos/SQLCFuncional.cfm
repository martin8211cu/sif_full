﻿<!--- 
	SQLCFuncional.cfm (SQL DE Actualización de CFuncional)
	----------------------------------------------------------------------------------------------------------------------------
	Modificación: 29 de novimebre de 2006 - Se corrige modificación del campo RHPid -plaza responsable- porque siempre se borra, 
	aun cuando no este definido el usuario responsable. En cuyo caso si se debe borrar, dado que los conceptos son excluyentes. 
	- Realizado por Dorian Abarca G. - Cambio requerido por Freddy Leiva - Consultado con Marcel de Mezerville L. -
	----------------------------------------------------------------------------------------------------------------------------
--->
<!--- ========================================================================= --->
<!--- Esto solo aplica para la empresa corporativa. 
	  Se puede marcar el CF como corporativo, solo si su padre es corporativo
--->

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MG_Error_Hay_centros_Funcionales_desligados"
Default="Error: Hay centros funcionales desligados"
returnvariable="MG_Error_Hay_centros_Funcionales_desligados"/> 

<cfset es_corporativo = false >
<cfset vEcodigoCorp = 0 >
<cfset marcar_corporativo = false >
<cfif isdefined("form.Alta") or isdefined("form.Cambio")>
	<cfquery name="rsCorporativa" datasource="asp">
		select coalesce(e.Ereferencia, 0) as Ecorporativa
		from CuentaEmpresarial c
			join Empresa e
			on e.Ecodigo = c.Ecorporativa
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>
	<cfif rsCorporativa.recordcount gt 0 and len(trim(rsCorporativa.Ecorporativa))>
		<cfset vEcodigoCorp = rsCorporativa.Ecorporativa >
	</cfif>

	<cfif session.Ecodigo eq vEcodigoCorp >
		<cfset es_corporativo = true >
		<cfif isdefined("form.CFcorporativo") and isdefined("Form.CFpkresp") and len(trim(Form.CFpkresp))>
			<cfquery name="rsPadreCorp" datasource="#session.DSN#">
				select CFcorporativo
				from CFuncional
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
				and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpkresp#" >
			</cfquery>
			<cfif rsPadreCorp.CFcorporativo eq 1 >
				<cfset marcar_corporativo = true >
			</cfif>
		</cfif>
	</cfif>
</cfif>
<!--- ========================================================================= ---> 
 
<cfset respPlaza = false >	<!--- la plaza solo existe si el parametro de planilla presupuestaria esta activo --->
<cfset respUsuario = true > <!--- el usuario siempre existe --->
<cfif isdefined("form.radioResponsable") and form.radioResponsable eq 'P' >
	<cfset respPlaza = true >
	<cfset respUsuario = false >
</cfif>

<cfset modo = "ALTA">
<cfset irA = 'CFuncional.cfm' >
<cfif not isdefined("Form.Nuevo") and not isDefined("Form.Filtrar")>
	<cftry>	
		<cfset existe = false>			
		<cfset tieneSubordinados = false>		
		<cfset puedeSerJefe = true>

		<cfquery name="rsExiste" datasource="#Session.DSN#">
			select 1 from CFuncional  
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CFcodigo = <cfqueryparam value="#Trim(Form.CFcodigo)#" cfsqltype="cf_sql_char">
		</cfquery>				

		<cfif isdefined('rsExiste')	and rsExiste.recordCount GT 0 and isdefined("Form.Alta")> 
			<cfset existe = true> 
			<script>alert("Ya existe un centro funcional con ese código");</script> 			
		</cfif>		

		<cfif rsExiste.recordCount GT  0 and isdefined("form.CFpk") and len(trim(form.CFpk)) > 
			<cfquery name="rsTieneSubordinados" datasource="#Session.DSN#">
				select 1 
				from CFuncional  
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and ( case CFnivel when 0 then null else CFidresp end ) = <cfqueryparam value="#Form.CFpk#" cfsqltype="cf_sql_numeric">
				  and CFid != ( case CFnivel when 0 then null else CFidresp end )
			</cfquery>				
			
			<cfif isdefined('rsTieneSubordinados') and rsTieneSubordinados.recordCount GT 0 and isdefined("Form.Baja")> 
				<cfset tieneSubordinados = true> 
				<script>alert("El centro funcional no se puede eliminar debido a que tiene centros funcionales dependientes");</script> 			
			</cfif>
		</cfif>		

		<cfif isdefined("Form.Cambio")> 
			
			<cfif Form.Cambio EQ "Guardar">
				<cfset tab=2>
			<cfelse>
				<cfset tab=1>
			</cfif>
			
			<cfset CFpk = form.CFpk>		<!--- Id del Centro Funcional a cambiarle su jefe --->
			<cfset NuevoJefe = "">
			<cfset NuevoJefeInicial = "">			
			<cfset n = 0>			
			<cfset Jefe = "">			
			<cfset varPuedeSerJefe = false>			
		
			<cfif len(trim(Form.CFpkresp)) GT 0>
				<cfset NuevoJefe = Form.CFpkresp>		<!--- Id del posible responsable del Centro Funcional --->
			</cfif>		
			<cfset NuevoJefeInicial = NuevoJefe>

			<cfloop condition = "n LESS THAN 50">
				<cfset n = n + 1>

				<cfquery name="rsJefe" datasource="#Session.DSN#">
					select ( case CFnivel when 0 then null else CFidresp end ) as CFidresp
					from CFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
					<cfif NuevoJefe NEQ ''>
						and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NuevoJefe#">
					<cfelse>
						and CFid = null
					</cfif>
				</cfquery>
					
				<cfif isdefined('rsJefe') and rsJefe.recordCount GT 0>
					<cfset Jefe = rsJefe.CFidresp>
				</cfif>
				
				<cfif Jefe EQ CFpk>
					<cfset varPuedeSerJefe = false>
					<cfbreak>
				</cfif>
				
				<cfif NuevoJefeInicial EQ ''>
					<cfif Jefe EQ ''>
						<cfset varPuedeSerJefe = true>
						<cfbreak>
					</cfif>				
				<cfelse>
					<cfif Jefe EQ '' or Jefe EQ NuevoJefeInicial>
						<cfset varPuedeSerJefe = true>
						<cfbreak>
					</cfif>				
				</cfif>

				<cfset NuevoJefe = Jefe>
			</cfloop>

			<cfif varPuedeSerJefe EQ false> 
				<cfset puedeSerJefe = false> 
				<script>alert("No se puede asignar el centro funcional como responsable ya que depende del mismo");</script> 			
			</cfif>
		</cfif>

		<cfset CFcuentac = "">
		<cfif isdefined("form.Cmayor") and len(trim(form.Cmayor)) gt 0 and isdefined("form.Cformato") and len(trim(form.Cformato)) gt 0 >
			<cfset CFcuentac = trim(form.Cmayor) & "-" & trim(form.Cformato) >
		</cfif>		

		<cfset CFcuentaaf = "">
		<cfif isdefined("form.Cmayor_CFcuentaafform") and len(trim(form.Cmayor_CFcuentaafform)) gt 0 and isdefined("form.CFcuentaafform") and len(trim(form.CFcuentaafform)) gt 0 >
			<cfset CFcuentaaf = trim(form.Cmayor_CFcuentaafform) & "-" & trim(form.CFcuentaafform) >
		</cfif>

		<cfset CFcuentainventario = "">
		<cfif isdefined("form.Cmayor_CFCIformato") and len(trim(form.Cmayor_CFCIformato)) gt 0 and isdefined("form.CFCIformato") and len(trim(form.CFCIformato)) gt 0 >
			<cfset CFcuentainventario = trim(form.Cmayor_CFCIformato) & "-" & trim(form.CFCIformato) >
		</cfif>

		<cfset CFcuentainversion = "">
		<cfif isdefined("form.Cmayor_CFAFformato") and len(trim(form.Cmayor_CFAFformato)) gt 0 and isdefined("form.CFAFformato") and len(trim(form.CFAFformato)) gt 0 >
			<cfset CFcuentainversion = trim(form.Cmayor_CFAFformato) & "-" & trim(form.CFAFformato) >
		</cfif>
		
		<cfset CFcuentaingreso = "">
		<cfif isdefined("form.Cmayor_CFINformato") and len(trim(form.Cmayor_CFINformato)) gt 0 and isdefined("form.CFINformato") and len(trim(form.CFINformato)) gt 0 >
			<cfset CFcuentaingreso = trim(form.Cmayor_CFINformato) & "-" & trim(form.CFINformato) >
		</cfif>		
		<cfif isdefined("Form.Alta")>		
		 	
			<cfif not existe>
				<cfset my_path = Trim(form.CFcodigo)>
				<cfset my_nivel = 0>
				<cfif len(trim(Form.CFpkresp))>
					<cfquery name="path_papa" datasource="#session.dsn#">
						select CFpath, CFnivel
						from CFuncional
						where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpkresp#">
					</cfquery>
					<cfif path_papa.RecordCount>
						<cfset my_path = Trim(path_papa.CFpath) & '/' & my_path>
						<cfset my_nivel = path_papa.CFnivel + 1>
					</cfif>
				</cfif>
				
				<cfset fnPeriodoMes()>
               
				<cftransaction>
					<cfquery name="CFuncional" datasource="#Session.DSN#">
						insert into CFuncional( Ecodigo, 
												CFcodigo, 
												Dcodigo, 
												Ocodigo, 
												<!--- RHPid,  --->
												CFdescripcion, 
												CFidresp, 
												CFcuentac, 
												CFuresponsable, 
												CFcomprador, 
												CFautoccontrato, 
												CFpath, 
												CFnivel, 
												CFcuentainventario, 
												CFcuentainversion, 
												CFcorporativo, 
												CFcuentaaf, 
												CFcuentaingreso,
												CFcuentaingresoretaf,
												CFcuentagastoretaf )
						values (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">, 
							<!--- <cfif not respPlaza >null<cfelse><cfif isdefined("Form.RHPid") and Len(Trim(Form.RHPid)) GT 0 ><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPid#"><cfelse>null</cfif></cfif>, --->
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFdescripcion#">, 
							<cfif isdefined("Form.CFpkresp") and Len(Trim(Form.CFpkresp)) GT 0 ><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpkresp#"><cfelse>null</cfif>,
							<cfif isdefined("form.CFcuentac") and len(trim(form.CFcuentac))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentac#"><cfelse>null</cfif>,
							<cfif not respUsuario >null<cfelse><cfif isdefined("form.CFuresponsable") and len(trim(form.CFuresponsable))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFuresponsable#"><cfelse>null</cfif></cfif>,
							<cfif isdefined("form.CFcomprador") and len(trim(form.CFcomprador))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcomprador#"><cfelse>null</cfif>,
							<cfif isdefined("form.CFautoccontrato") and len(trim(form.CFautoccontrato))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFautoccontrato#"><cfelse>null</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#my_path#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#my_nivel#">,
							<cfif isdefined("form.CFcuentainventario") and len(trim(form.CFcuentainventario))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentainventario#"><cfelse>null</cfif>,
							<cfif isdefined("form.CFcuentainversion") and len(trim(form.CFcuentainversion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentainversion#"><cfelse>null</cfif>,
							<cfif isdefined("marcar_corporativo") and marcar_corporativo>1<cfelse>0</cfif>,
							<cfif isdefined("form.CFcuentaaf") and len(trim(form.CFcuentaaf))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentaaf#"><cfelse>null</cfif>,
							<cfif isdefined("form.CFcuentaingreso") and len(trim(form.CFcuentaingreso))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentaingreso#"><cfelse>null</cfif>,
							<cfif isdefined("form.CFcuentaingresoretaf") and len(trim(form.CFcuentaingresoretaf))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentaingresoretaf#"><cfelse>null</cfif>,
							<cfif isdefined("form.CFcuentagastoretaf") and len(trim(form.CFcuentagastoretaf))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentagastoretaf#"><cfelse>null</cfif>
						)
					  <cf_dbidentity1 datasource="#Session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#Session.DSN#" name="CFuncional">

                    <cfquery datasource="#session.DSN#">
                    	insert into AFBDepartamentos 
                            (
                                Ecodigo, 
                                CFid, 
                                Usucodigo, 
                                Dcodigo, 
                                Ocodigo, 
                                AFBDperiodo, 
                                AFBDmes, 
                                AFBDpermesdesde, 
                                AFBDpermeshasta, 
                                BMUsucodigo
                            )
                        values 
                        	(
                            	#session.Ecodigo#,
                                #CFuncional.identity#,
                                #session.Usucodigo#,
                                #Form.Dcodigo#,
                                #Form.Ocodigo#,
                                #LvarPeriodo#,
                                #LvarMes#,
                                #LvarPeriodoMes#,
                                610001,
                                #session.Usucodigo#
                            )
                    </cfquery>
				</cftransaction>
				
				<cfset Form.CFpk = CFuncional.identity>
				<cfset tab=2>
				<cfset modo="ALTA">
			</cfif>
		<cfelseif isdefined ("form.Exportar")>
			<cflocation url="CFExporta.cfm?CFpk=#form.CFpk#&tab=1&CFpath=#form.CFpath#">
		<cfelseif isdefined ("form.Importar")>	
			<cflocation url="CFImporta.cfm">
		<cfelseif isdefined("Form.Baja") and not tieneSubordinados>
			<cfquery datasource="#Session.DSN#">
				delete RHPlazas 
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and CFid = <cfqueryparam value="#Form.CFpk#" cfsqltype="cf_sql_numeric">
			</cfquery>
				  
			<cfquery datasource="#Session.DSN#">				  
				delete from CFuncional
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and CFid = <cfqueryparam value="#Form.CFpk#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cf_sifcomplementofinanciero action='delete'
					tabla="CFuncional"
					form = "form1_2"
					llave="#form.CFpk#" />					
			<cfset modo="BAJA">
			<cfset irA = 'CFuncional-lista.cfm' >

		<cfelseif isdefined("Form.Cambio") and puedeSerJefe >
			<cftransaction>
				<cfif Form.Cambio EQ "Guardar">
					<cfset tab=2>
				<cfelse>
					<cfset tab=1>
				</cfif>
				
				<cfquery datasource="#session.dsn#" name="valores_anteriores">
					select CFcodigo, CFidresp, Ocodigo, Dcodigo
					from CFuncional
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and CFid = <cfqueryparam value="#Form.CFpk#" cfsqltype="cf_sql_numeric">
				</cfquery>
						
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="CFuncional"
					redirect="CFuncional.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo,integer,#session.Ecodigo#"
					field2="CFid,numeric,#form.CFpk#">						
				
				<cfquery name="CFuncional" datasource="#Session.DSN#">
					update CFuncional set
						CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFcodigo#">, 
						Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">, 
						Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">, 
						CFdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFdescripcion#">, 
						CFcuentac = <cfif isdefined("form.CFcuentac") and  len(trim(form.CFcuentac))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentac#"><cfelse>null</cfif>,
						CFcuentainventario = <cfif isdefined("form.CFcuentainventario") and  len(trim(form.CFcuentainventario))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentainventario#"><cfelse>null</cfif>,
						CFcuentainversion = <cfif isdefined("form.CFcuentainversion") and  len(trim(form.CFcuentainversion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentainversion#"><cfelse>null</cfif>,
	
						<cfif isdefined("form.CFuresponsable") and len(trim(form.CFuresponsable))>RHPid = null,</cfif>
						CFuresponsable = <cfif not respUsuario >null<cfelse><cfif isdefined("form.CFuresponsable") and len(trim(form.CFuresponsable))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFuresponsable#"><cfelse>null</cfif></cfif>,
	
						CFcomprador = <cfif isdefined("form.CFcomprador") and len(trim(form.CFcomprador))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcomprador#"><cfelse>null</cfif>,
						CFautoccontrato = <cfif isdefined("form.CFautoccontrato") and len(trim(form.CFautoccontrato))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFautoccontrato#"><cfelse>null</cfif>,
						CFcuentaaf = <cfif isdefined("form.CFcuentaaf") and len(trim(form.CFcuentaaf))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentaaf#"><cfelse>null</cfif>,
						CFcorporativo = <cfif isdefined("marcar_corporativo") and marcar_corporativo>1<cfelse>0</cfif>,
						CFcuentaingreso = <cfif isdefined("form.CFcuentaingreso") and len(trim(form.CFcuentaingreso))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentaingreso#"><cfelse>null</cfif>,
						CFcuentaingresoretaf = <cfif isdefined("form.CFcuentaingresoretaf") and len(trim(form.CFcuentaingresoretaf))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentaingresoretaf#"><cfelse>null</cfif>,
						CFcuentagastoretaf = <cfif isdefined("form.CFcuentagastoretaf") and len(trim(form.CFcuentagastoretaf))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentagastoretaf#"><cfelse>null</cfif>,	
						
					<!--- si se el jefe a cambiar es él mismo, entonces lo pone en nulo --->
					<cfif isdefined("Form.CFpkresp") and Len(Trim(Form.CFpkresp)) GT 0>									
						<cfif Compare(Trim(Form.CFpkresp),Trim(Form.CFpk)) EQ 0>
							CFidresp = null
						<cfelse>		
							<cfif len(trim(Form.CFpkresp)) GT 0>
							CFidresp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpkresp#">
							<cfelse>
							CFidresp = null
							</cfif>				
						</cfif>										
					<cfelse>
						CFidresp = null
					</cfif>
	
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and CFid = <cfqueryparam value="#Form.CFpk#" cfsqltype="cf_sql_numeric">
				</cfquery>

                <cfset fnPeriodoMes()>
                
                <!--- Verifica si cambió el CFcodigo, Ocodigo o Dcodigo --->
                <cfif valores_anteriores.CFcodigo neq Form.CFcodigo or valores_anteriores.Ocodigo neq Form.Ocodigo or valores_anteriores.Dcodigo neq Form.Dcodigo>

                	<!--- Obtiene el maximo id para el Centro funcional, empresa  --->
                	<cfquery name="rsPeridoMes" datasource="#session.DSN#">
                    	select max(AFBDid) as AFBDid
                        from AFBDepartamentos
                        where CFid = #Form.CFpk#
						  and Ecodigo = #session.Ecodigo#
                    </cfquery>
                    <cfset LvarAFBDid = rsPeridoMes.AFBDid>
                    
                    <cfquery name="rsPeridoMes" datasource="#session.DSN#">
                    	select AFBDpermesdesde
                        from AFBDepartamentos
                        where AFBDid = #LvarAFBDid#
                    </cfquery>
                    
                    <cfif isdefined("rsPeridoMes") and rsPeridoMes.recordcount gt 0>
                    	<cfset LvarPerMesAFBD = rsPeridoMes.AFBDpermesdesde>
                    </cfif>

                    <!--- si el permes es el actual, actualiza si es otro, inserta  --->
                    <cfif LvarPerMesAFBD eq LvarPeriodoMes>
                    	<cfquery datasource="#session.DSN#">
                        	update AFBDepartamentos
                            	set CFid = #Form.CFpk#,
                                	Ocodigo = #Form.Ocodigo#,
                                    Dcodigo = #Form.Dcodigo#
                            where AFBDid 	= #LvarAFBDid#
                        </cfquery>
                    <cfelse>
                    	<!--- Corta Permeshasta --->
                    	<cfquery datasource="#session.DSN#">
                        	update AFBDepartamentos
                            	set AFBDpermeshasta = #LvarPeriodoMes -1#
                            where AFBDid = #LvarAFBDid#
                        </cfquery>
                    	<cfquery datasource="#session.DSN#">
                            insert into AFBDepartamentos 
                                (
                                    Ecodigo, 
                                    CFid, 
                                    Usucodigo, 
                                    Dcodigo, 
                                    Ocodigo, 
                                    AFBDperiodo, 
                                    AFBDmes, 
                                    AFBDpermesdesde, 
                                    AFBDpermeshasta, 
                                    BMUsucodigo
                                )
                            values 
                                (
                                    #session.Ecodigo#,
                                    #Form.CFpk#,
                                    #session.Usucodigo#,
                                    #Form.Dcodigo#,
                                    #Form.Ocodigo#,
                                    #LvarPeriodo#,
                                    #LvarMes#,
                                    #LvarPeriodoMes#,
                                    610001,
                                    #session.Usucodigo#
                                )
                        </cfquery>
                    </cfif>
                </cfif>
                
                
				<!---<cf_sifcomplementofinanciero action='update'
						tabla="CFuncional"
						form = "form1_2"
						llave="#form.CFpk#" />	--->		
						
				<!--- Si se quita la marca de corporativo a un CF, le quita la marca de corporativo a todos sus CF's dependiente --->
				<cfif es_corporativo >
					<cfif not marcar_corporativo >
						<cfquery name="rsTieneHijos" datasource="#session.DSN#">
							select 1
							from CFuncional
							where ( case CFnivel when 0 then null else CFidresp end ) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
						</cfquery>
						<cfif rsTieneHijos.recordcount gt 0>
							<cfquery datasource="#session.DSN#">
								update CFuncional 
								set CFcorporativo = 0
								where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and CFpath like '#form.CFpath#%'
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
						
				<cfif Trim(valores_anteriores.CFcodigo) neq Trim(form.CFcodigo) or Trim(valores_anteriores.CFidresp) neq Trim(form.CFpkresp)>
					<!--- reordenar todo el arbol pues ha cambiado la estructura del arbol --->
					<!---
					<cfquery datasource="#session.dsn#">
						update CFuncional
						  set CFpath =  ltrim(rtrim(CFcodigo)),
							  CFnivel = case when CFidresp is null then 0 else -1 end
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					</cfquery>
					--->
					<cfquery datasource="#session.dsn#">
						update CFuncional
						  set CFpath =  ltrim(rtrim(CFcodigo)),
							  CFnivel = ( case CFnivel when 0 then 0 else -1 end )
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					</cfquery>
	
					<cfset nivel = 0>
					<cfloop from="0" to="100" index="nivel">
						<cfif nivel is 100>
							<cf_throw message="#MG_Error_Hay_centros_Funcionales_desligados#" errorcode="2080">
						</cfif>
						
						<cf_dbupdate table="CFuncional" datasource="#session.DSN#">
							<cf_dbupdate_join table="CFuncional p">
								on CFuncional.CFidresp = p.CFid
									and CFuncional.Ecodigo = p.Ecodigo
									and CFuncional.CFnivel = -1
							</cf_dbupdate_join>
							
							<cf_dbupdate_set name='CFpath' 
								expr="{fn concat( {fn concat( p.CFpath , '/' )}, ltrim(rtrim(CFuncional.CFcodigo)) )}" />
							<cf_dbupdate_set name='CFnivel' type="integer" value="#nivel + 1#"/>
							
							<cf_dbupdate_where>
								where CFuncional.Ecodigo = <cf_dbupdate_param type="integer" value="#session.Ecodigo#">
								  and p.Ecodigo = <cf_dbupdate_param type="integer" value="#session.Ecodigo#">
								  and p.CFnivel = <cf_dbupdate_param type="numeric" value="#nivel#">
							</cf_dbupdate_where>						
						</cf_dbupdate>
						
						<cfquery datasource="#session.dsn#" name="hay_mas">
							select count(1) as cuantos
							from CFuncional h, CFuncional p
						   where h.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							 and h.CFnivel = -1
						</cfquery>
						<cfif isdefined('hay_mas') and hay_mas.cuantos is 0><cfbreak></cfif>
					</cfloop>
					
					<!--- OJO: SEGURIDAD DE PRESUPUESTO --->
					<!--- NO SE COMO FUNCIONA ESTO, CUANDO ES EL CF RAIZ, YA QUE EL RESP DE LA RAIZ PUEDE SER NULO --->
					<cfif not len(trim(Form.CFpkresp))>
						<cfset Form.CFpkresp = 0 >
					</cfif>
					<cfset sbActualizaSeguridadPresupuesto(Form.CFpk, Form.CFpkresp)>
		
				</cfif>
			</cftransaction>
			<cfset modo="ALTA">
		</cfif>
	<cfcatch type="database">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="<cfoutput>#irA#</cfoutput>" method="post" name="sql">
	
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
		
		<cfif isdefined("Form.CFpk") and Len(Trim(Form.CFpk))neq 0>
			<input name="CFpk_papa" type="hidden" value="<cfoutput>#Form.CFpk#</cfoutput>">
		</cfif>
		
		<cfif isdefined("Form.CFpkresp") and Len(Trim(Form.CFpkresp))neq 0>
			<input name="CFpkresp_papa" type="hidden" value="<cfoutput>#Form.CFpkresp#</cfoutput>">
		</cfif>
	
	</cfif>
	
	<cfif isDefined("Form.Filtrar")>
		<cfset tab = 3>	
		<cfset modo = "CAMBIO" >
		<input name="fRHPcodigo" type="hidden" value="<cfif isdefined("Form.fRHPcodigo")><cfoutput>#Form.fRHPcodigo#</cfoutput></cfif>">	
		<input name="fRHPdescripcion" type="hidden" value="<cfif isdefined("Form.fRHPdescripcion")><cfoutput>#Form.fRHPdescripcion#</cfoutput></cfif>">	
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif not isdefined("Form.Nuevo") and isdefined("Form.CFpk") and Len(Trim(Form.CFpk)) and isdefined("modo") and modo NEQ "BAJA">
		<input name="CFpk" type="hidden" value="<cfoutput>#Form.CFpk#</cfoutput>">
	</cfif>
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
	
	<cfif isdefined("tab") and len(trim(tab)) NEQ 0>
        <input name="tab" type="hidden" value="<cfoutput>#tab#</cfoutput>" />
    </cfif>
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>

<!--- ACTUALIZA LA SEGURIDAD DE PRESUPUESTO PARA USUARIOS QUE TIENEN CENTROS FUNCIONALES HIJOS Y CAMBIO EL PADRE --->
<cffunction name="sbActualizaSeguridadPresupuesto" output="false">
	<cfargument name="CForigen"	type="numeric" required="yes">
	<cfargument name="CFpadre" 	type="numeric" required="yes">
	
	<cftry>
		<cfquery datasource="#session.dsn#" name="rsSeguridadPresupuesto">
			select count(1) as cantidad
			  from CPSeguridadUsuario su
			 where su.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			   and su.CFid = <cfqueryparam value="#CForigen#" cfsqltype="cf_sql_numeric">
			   and su.Usucodigo is not null
		</cfquery>
	<cfcatch></cfcatch>
	</cftry>
	<cfif isdefined("rsSeguridadPresupuesto")>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select CFpath
			  from CFuncional
			 where CFid = <cfqueryparam value="#CForigen#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset LvarPath = trim(rsSQL.CFpath)>

		<!--- Cuando Existe un usuario que tenga asignado el CForigen --->
		<cfif rsSeguridadPresupuesto.cantidad GT 0>
			<!--- 1. Si un usuario tiene asignado el CForigen como hijo y no tiene asignado el CFpadre: 
						Borra la estructura funcional del CForigen --->
			<cfquery datasource="#session.dsn#">
				delete from CPSeguridadUsuario
				 where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				   and CFid in
					(	<!--- jerarquia funcional a partir del CForigen --->
						select jo.CFid
						  from CFuncional jo
						 where jo.Ecodigo 	= CPSeguridadUsuario.Ecodigo
						   and substring(jo.CFpath,1,#len(LvarPath)#) = '#LvarPath#'
					)
				   and Usucodigo is not null
				   and not exists 
					(	<!--- NO Tiene asignado el CFpadre --->
						select 1
						  from CPSeguridadUsuario sp
						 where sp.Ecodigo 	= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						   and sp.CFid 		= <cfqueryparam value="#CFpadre#" cfsqltype="cf_sql_numeric">
						   and sp.Usucodigo = CPSeguridadUsuario.Usucodigo
						   and 
								(		<!--- El CFpadre es hijo --->
									sp.CPSUidOrigen is not null 
								OR
									exists
									(	<!--- El CFpadre tiene hijos --->
										select CPSUidOrigen
										  from CPSeguridadUsuario spp
										 where spp.CPSUidOrigen	= sp.CPSUid
									)
								)
					)
			</cfquery>

			<!--- 2. Si un usuario tiene asignado el CFpadre como hijo: 
						Actualiza la estructura funcional del CForigen: CPSUidOrigen = CPSUidOrigen del CFpadre --->
			<!--- 3. Si un usuario tiene asignado el CFpadre como raiz: 
						Actualiza la estructura funcional del CForigen: CPSUidOrigen = CPSUid del CFpadre --->
			<!--- 4. Si un usuario no tiene asignado el CFpadre (pero el CForigen no es hijo, puesto que ya se borraron): 
						No actualiza la estructura funcional del CForigen: CPSUidOrigen = CPSUidOrigen --->
			<cfquery datasource="#session.dsn#" name="hay_mas">
				update CPSeguridadUsuario
				   set CPSUidOrigen = 
						coalesce (
							(	<!--- CFpadre --->
								select coalesce(sp.CPSUidOrigen, sp.CPSUid)
								  from CPSeguridadUsuario sp
								 where sp.Ecodigo 	= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
								   and sp.CFid 		= <cfqueryparam value="#CFpadre#" cfsqltype="cf_sql_numeric">
								   and sp.Usucodigo = CPSeguridadUsuario.Usucodigo
							)
						, -1)
				 where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				   and CFid in
					(	<!--- jerarquia funcional a partir del CForigen --->
						select jo.CFid
						  from CFuncional jo
						 where jo.Ecodigo 	= CPSeguridadUsuario.Ecodigo
						   and substring(jo.CFpath,1,#len(LvarPath)#) = '#LvarPath#'
					)
				   and Usucodigo is not null
			</cfquery>
		</cfif>

		<!--- 5. Si un usuario no tiene asignado el CForigen pero tiene asignado el CFpadre como hijo: 
					Incluye la Estructura Funcional del CForigen: CPSUidOrigen = CPSUidOrigen del CFpadre --->
		<!--- 6. Si un usuario no tiene asignado el CForigen pero tiene asignado el CFpadre como padre (tiene hijos): 
					Incluye la Estructura Funcional del CForigen: CPSUidOrigen = CPSUid del CFpadre --->

		<cfquery datasource="#session.dsn#">
			insert into CPSeguridadUsuario 
				  (Ecodigo, CFid, Usucodigo, CPSUconsultar, CPSUtraslados, CPSUreservas, CPSUformulacion, CPSUaprobacion, BMUsucodigo, CPSUidOrigen)
			select jo.Ecodigo, jo.CFid, sp.Usucodigo, sp.CPSUconsultar, sp.CPSUtraslados, sp.CPSUreservas, sp.CPSUformulacion, sp.CPSUaprobacion, sp.BMUsucodigo, 
					coalesce(sp.CPSUidOrigen, sp.CPSUid)
			  from CPSeguridadUsuario sp
				inner join CFuncional jo	<!--- jerarquia funcional a partir del CForigen --->
					 on jo.Ecodigo 	= sp.Ecodigo
					and substring(jo.CFpath,1,#len(LvarPath)#) = '#LvarPath#'
			 where sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			   and sp.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFpadre#">
			   and sp.Usucodigo is not null		<!--- Un Usuario tiene asignado el CFpadre --->
			   and 
			   		(		<!--- El CFpadre es hijo --->
						sp.CPSUidOrigen is not null 
					OR
						exists
						(	<!--- El CFpadre tiene hijos --->
							select CPSUidOrigen
							  from CPSeguridadUsuario spp
							 where spp.CPSUidOrigen	= sp.CPSUid
						)
					)
			   and not exists
					(		<!--- No tiene asignado el CForigen --->
						select 1
						  from CPSeguridadUsuario so
						 where so.Ecodigo 	= jo.Ecodigo
						   and so.CFid		= jo.CFid
						   and so.Usucodigo = sp.Usucodigo
					)
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="fnPeriodoMes" access="private" output="no" returntype="void">
	<cfquery name="rsPeriodoAux" datasource="#session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo = #session.Ecodigo#
        and Pcodigo = 50
    </cfquery>
    <cfif rsPeriodoAux.recordcount eq 1>
        <cfset LvarPeriodo = rsPeriodoAux.Pvalor>
    <cfelse>
        <cfthrow message="No se ha definido el Parametro Período Auxiliares" detail="Favor definir este parámetro en Administración del Sistema, Período Auxiliares.">
    </cfif>
    
    <cfquery name="rsMesAux" datasource="#session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo = #session.Ecodigo#
        and Pcodigo = 60
    </cfquery>
    <cfif rsMesAux.recordcount eq 1>
        <cfset LvarMes = rsMesAux.Pvalor>
    <cfelse>
        <cfthrow message="No se ha definido el Parametro Mes Auxiliares" detail="Favor definir este parámetro en Administración del Sistema, Mes Auxiliares.">
    </cfif>
    
    <cfset LvarPeriodoMes = LvarPeriodo * 100 + LvarMes>
</cffunction>
