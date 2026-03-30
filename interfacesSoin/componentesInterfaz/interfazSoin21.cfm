<!--- 
La oprecion del proceso es la siguiente:
	
	- Se van a validar que los datos de las obras referentes a proyectos existan y esten correctos
	
--->

<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cftransaction isolation="read_uncommitted">

	<!--- ******************************************** --->
	<!--- **Inicia el proceso de validacion de datos** --->
	<!--- ******************************************** --->

	<!--- Verifica el proyecto --->
	<cfquery name="rsVerificaProy" datasource="sifinterfaces">
		Select count(1) as total
		from IE21 a
		where not exists (	Select 1
							from <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto b">
							where a.OBPcodigo = b.OBPcodigo
							  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">)
		  and a.ID = #GvarID#
	</cfquery>
	
	<cfif rsVerificaProy.total gt 0>
		<cfset LvarMsg="ERROR: Hay códigos de proyecto que no existen o no están definidos.">
		<cfquery name="rsListaObras" datasource="sifinterfaces">
			UPDATE IE21 
			set Status = 4, 
				MsgError = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMsg#"> 
			where ID = #GvarID#
		</cfquery>			
		<cfthrow message="#LvarMsg#">
	</cfif>
		
	<!--- Verifica si la oficina existe en el catálogo de oficinas --->
	<cfquery name="rsVerificaOf" datasource="sifinterfaces">
		Select count(1) as total
		from IE21 a
		where not exists(Select 1
						 from <cf_dbdatabase datasource="#session.DSN#" table="Oficinas b">
						 where a.Oficodigo = b.Oficodigo
						   and b.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">)
		  and a.ID = #GvarID#
	</cfquery>
	
	<cfif rsVerificaOf.total gt 0>
		<cfset LvarMsg="ERROR: Hay códigos de oficina que no existen o no están definidos.">
		<cfquery name="rsListaObras" datasource="sifinterfaces">
			UPDATE IE21 
			set Status = 4, 
				MsgError = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMsg#"> 
			where ID = #GvarID#
		</cfquery>			
		<cfthrow message="#LvarMsg#">
	</cfif>
	
	<!--- 
		  Verifica que las obras que traen la información para generar 
		  una nueva, sea la misma información para todas las etapas 
	
	<cfquery name="rsVerificaInfoObr" datasource="sifinterfaces">
		Select 	ID, 
				OBPcodigo,
				OBOcodigo,
				OBOdescripcion, 
				OBOfechaInicio, 
				OBOfechaFinal, 
				count(1) as total
		from IE21 a
		where 	(OBOdescripcion is not null
				or OBOdescripcion is not null 
				or OBOfechaInicio is not null
				or OBOfechaFinal is not null) 			
		group by 	ID, 
					OBPcodigo, 
					OBOcodigo, 
					OBOdescripcion, 
					OBOfechaInicio, 
					OBOfechaFinal 					
		having count(1) > 1
	</cfquery>
	
	<cfif rsVerificaInfoObr.total gt 1>
		<cfthrow message="ERROR: Se estan tratando de crear obras nuevas con información diferente en la descripción y el mismo código de obra y proyecto.">		
	</cfif>	--->
	
	<cfquery name="rsVerificaObr" datasource="sifinterfaces">
		Select a.OBOcodigo ,a.OBPcodigo, b.PCEcatidObr
		from IE21 a
				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto b"> 
					on a.OBPcodigo = b.OBPcodigo
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		where a.ID = #GvarID#
	</cfquery>
	
	<!--- El valor del catálogo de obras debe ser hijo del PCEcatid en PCDCatalogo --->
	<cfloop query="rsVerificaObr">
	
		<cfset LvarPCEcatidObr = rsVerificaObr.PCEcatidObr>
		<cfset LvarOBOcodigo = rsVerificaObr.OBOcodigo>
		<cfset LvarOBPcodigo = rsVerificaObr.OBPcodigo>
		
		<!--- Verifica que el código de la obra sea correcto --->		
		<cfquery name="rsVerificaCodObr" datasource="sifinterfaces">
			Select count(1) as total
			From <cf_dbdatabase datasource="#session.DSN#" table="PCDCatalogo d"> 
			Where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCEcatidObr#">
				and ((select PCEempresa 
						from <cf_dbdatabase datasource="#session.DSN#" table="PCECatalogo"> 
						where PCEcatid=d.PCEcatid) = 0 
					OR coalesce(Ecodigo,-1) = 1)
					
				and PCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarOBOcodigo#">
				
				<!--- 
				and not exists(select 1 
						from <cf_dbdatabase datasource="#session.DSN#" table="OBobra">
						where PCDcatidObr=d.PCDcatid)
	
				and not exists(select 1 
						from <cf_dbdatabase datasource="#session.DSN#" table="P_OBobra">
						where PCDcatidObr=d.PCDcatid)					
								
				--->
				
		</cfquery>
	
		<cfif rsVerificaCodObr.total eq 0>
			<cfoutput>
			<cfset LvarMensaje = "El código de obra: #LvarOBOcodigo# es inválido para el proyecto #LvarOBPcodigo#">
			</cfoutput>
		</cfif>
	
	</cfloop>
	
	<!--- Verifica si se estan enviando cuentas contables por etapa --->
	<cfquery name="rsVerificaCtas" datasource="sifinterfaces">
	Select count(1) as total
	from ID21 a
	where ID =  #GvarID#
	</cfquery>
	
	<cfif rsVerificaCtas.total gt 0>

		<cfquery name="rsVerificaProy" datasource="sifinterfaces">
			Select count(1) as total
			from ID21 a
			where not exists (	Select 1
								from <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto b">
								where a.OBPcodigo = b.OBPcodigo
								  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">)
			  and a.ID = #GvarID#
		</cfquery>
	
		<cfif rsVerificaProy.total gt 0>
			<cfset LvarMsg="ERROR: Hay códigos de proyecto que no existen o no están definidos (Cuentas Contables x Etapa).">
			<cfquery name="rsListaObras" datasource="sifinterfaces">
				UPDATE IE21 
				set Status = 4, 
					MsgError = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMsg#"> 
				where ID = #GvarID#
			</cfquery>			
			<cfthrow message="#LvarMsg#">
		</cfif>	
	
		<!--- Verifica que exista la cuenta contable y que sea válida --->
		<cfquery name="rsVerificaCta" datasource="sifinterfaces">
			Select count(1) as total
			from ID21 a
			where a.ID = #GvarID#
			  and not exists(Select 1
			  				 from <cf_dbdatabase datasource="#session.DSN#" table="CFinanciera b">
							 where a.Cformato = b.CFformato
							   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">)
		</cfquery>
		
		<cfif rsVerificaCta.total gt 0>

			<cfset LvarMsg="ERROR: Existen cuentas que no existen en el catálogo de cuentas contables">
			<cfquery name="rsListaObras" datasource="sifinterfaces">
				UPDATE IE21 
				set Status = 4, 
					MsgError = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMsg#"> 
				where ID = #GvarID#
			</cfquery>			
			<cfthrow message="#LvarMsg#">
			
		<cfelse>

			<!--- Verifica que la cuenta de mayor sea valida para las obras --->
			<cfquery name="rsVerificaCta" datasource="sifinterfaces">
				Select count(1) as total
				from ID21 a
				where a.ID = #GvarID#
				  and not exists (Select 1
				  				  from <cf_dbdatabase datasource="#session.DSN#" table="OBctasMayor b">
								  where Cmayor = substring(a.Cformato,1,4)
								    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">)
			</cfquery>
			
			<cfif rsVerificaCta.total gt 0>

				<cfset LvarMsg="ERROR: Las cuentas suministradas, pertenecen a cuentas de mayor no parametrizadas para obras">
				<cfquery name="rsListaObras" datasource="sifinterfaces">
					UPDATE IE21 
					set Status = 4, 
						MsgError = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMsg#"> 
					where ID = #GvarID#
				</cfquery>			
				<cfthrow message="#LvarMsg#">				
				
			<cfelse>
			
				<!--- Verifica que las cuentas de mayor correspondan al proyecto - tipo proyecto --->
				<cfquery name="rsVerificaCta" datasource="sifinterfaces">
				Select count(1) as total
				from ID21 a
						inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto b">
							 on a.OBPcodigo = b.OBPcodigo
							and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
						inner join <cf_dbdatabase datasource="#session.DSN#" table="OBtipoProyecto c">
							 on b.OBTPid = c.OBTPid
				where a.ID = #GvarID#
				  and c.Cmayor != ltrim(rtrim(substring(a.Cformato,1,4)))
				</cfquery>
				
				<cfif rsVerificaCta.total gt 0>
					
					<cfset LvarMsg="ERROR: Las cuentas contables no corresponden con la cuenta mayor definida en el tipo de proyecto.">
					<cfquery name="rsListaObras" datasource="sifinterfaces">
						UPDATE IE21 
						set Status = 4, 
							MsgError = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMsg#"> 
						where ID = #GvarID#
					</cfquery>			
					<cfthrow message="#LvarMsg#">					

				</cfif>
			
			</cfif>
		
		</cfif>
		
		<!--- Verificacion de las cuentas, de acuerdo a la parametrización del proyecto --->
		<cfquery name="rsDatosCtas" datasource="sifinterfaces">
			Select 	count(1) as total
			from ID21 a
					inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto b">
						 on a.OBPcodigo = b.OBPcodigo
						and b.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
						
					inner join <cf_dbdatabase datasource="#session.DSN#" table="OBtipoProyecto c">
						 on b.OBTPid  = c.OBTPid
						and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#"> 
						
			where a.ID = #GvarID#
			  and not exists (Select 1
			  				  from <cf_dbdatabase datasource="#session.DSN#" table="OBobra d">
							  where substring(a.Cformato,1,datalength(ltrim(rtrim(d.CFformatoObr)))) like d.CFformatoObr
								and d.OBPid 	= b.OBPid
								and d.OBOcodigo = a.OBOcodigo
								and d.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">)
		</cfquery>
		
		<cfif rsDatosCtas.total gt 0>
			
			<cfset LvarMsg="ERROR: Existen cuentas que no son válidas para la etapa que se está asignando de acuerdo al Proyecto y a la Obra">
			<cfquery name="rsListaObras" datasource="sifinterfaces">
				UPDATE IE21 
				set Status = 4, 
					MsgError = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMsg#"> 
				where ID = #GvarID#
			</cfquery>			
			<cfthrow message="#LvarMsg#">					
			
		</cfif>
		
		
		<!--- Verifica que las cuentas sean nuevas y no existan ya definidas para la etapa --->
		<cfquery name="revCuentas" datasource="#session.dsn#">
		Select count(1) as total
		from ID21 a
				inner join IE21 b
					on a.ID = b.ID

				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto p">
					 on p.OBPcodigo = b.OBPcodigo
					and p.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
				
				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBobra o">
					 on o.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
					and o.OBPid		= p.OBPid
					and o.OBOcodigo	= b.OBOcodigo
		
				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBetapa e">
					 on Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#"> 
					and e.OBPid 	= p.OBPid
					and e.OBOid 	= o.OBOid
					and a.OBEcodigo = e.OBEcodigo

		where a.ID = #GvarID#
		  and exists(Select 1
					 from <cf_dbdatabase datasource="#session.DSN#" table="OBetapaCuentas c">
					 where c.OBEid 		= e.OBEid
					   and c.CFformato 	= a.Cformato)
		</cfquery>
		
		<cfif revCuentas.total gt 0>
			
			<cfset LvarMsg="ERROR: Existen cuentas que ya se encuentran definidas para algunas de las etapas enviadas">
			<cfquery name="rsListaObras" datasource="sifinterfaces">
				UPDATE IE21 
				set Status = 4, 
					MsgError = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMsg#"> 
				where ID = #GvarID#
			</cfquery>			
			<cfthrow message="#LvarMsg#">			

		</cfif>
		
		<!--- Verifica si la cuenta de mayor requerie control de cuentas:
		En caso de requeriri control de cuentas debe verificarse que las cuentas que se 
		estan mandando para una etapa, no pertenecen a otra etapa abierta que use dicha 
		cuenta.
		 --->
		<cfquery name="revCuentasEtp" datasource="#session.dsn#">
		Select count(1) as total
		from ID21 a
				inner join IE21 b
					on a.ID = b.ID

				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto p">
					 on p.OBPcodigo = b.OBPcodigo
					and p.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
					
				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBtipoProyecto c">
					 on p.OBTPid  = c.OBTPid
					and p.Ecodigo = c.Ecodigo
						
				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBctasMayor cm">
					 on cm.Cmayor  = c.Cmayor
					and cm.Ecodigo = c.Ecodigo
 					and cm.OBCcontrolCuentas = 1

		where a.ID = #GvarID#
		  and exists(Select 1		  
					 from <cf_dbdatabase datasource="#session.DSN#" table="OBetapa e">
								 inner join <cf_dbdatabase datasource="#session.DSN#" table="OBetapaCuentas ec">
										 on ec.OBEid   = e.OBEid
										and ec.Ecodigo = e.Ecodigo										
					 where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#"> 
					   and a.OBEcodigo != e.OBEcodigo
					   and ec.CFformato	= a.Cformato
   					   and e.OBestado = 1)
		</cfquery>
		
		<cfif revCuentasEtp.total gt 0>
			
			<cfset LvarMsg="ERROR: Existen cuentas contables que no pueden utilizarse porque estan siendo utilizadas en otras etapas abiertas">
			<cfquery name="rsListaObras" datasource="sifinterfaces">
				UPDATE IE21 
				set Status = 4, 
					MsgError = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMsg#"> 
				where ID = #GvarID#
			</cfquery>			
			<cfthrow message="#LvarMsg#">				

		</cfif>
		
		<!--- Verifica las reglas definidas en el proyecto --->
		<cfquery name="revCuentasReglas" datasource="#session.dsn#">
		Select count(1) as total
		from ID21 a
				inner join IE21 b
					on a.ID = b.ID

				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto p">
					 on p.OBPcodigo = b.OBPcodigo
					and p.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">

				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBobra o">
					 on o.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
					and o.OBPid		= p.OBPid
					and o.OBOcodigo	= b.OBOcodigo
					
		where a.ID = #GvarID#
		  and exists
					(
						select 1
						  from <cf_dbdatabase datasource="#session.DSN#" table="OBproyectoReglas pr1">
							inner join <cf_dbdatabase datasource="#session.DSN#" table="OBetapa e1">
							   on e1.OBPid = pr1.OBPid
						where e1.OBPid = p.OBPid
						  and e1.OBOid = o.OBOid
						  and e1.OBEcodigo = a.OBEcodigo
					)		
		
		  and not exists
					(
						select 1
						  from <cf_dbdatabase datasource="#session.DSN#" table="OBproyectoReglas pr">
							inner join <cf_dbdatabase datasource="#session.DSN#" table="OBetapa e">
							   on e.OBPid = pr.OBPid							  
							  and a.CFformato like pr.CFformatoRegla
							  and coalesce(pr.Ocodigo, e.Ocodigo) = e.Ocodigo
						where e.OBPid = p.OBPid
						  and e.OBOid = o.OBOid
						  and e.OBEcodigo = a.OBEcodigo
					)						
		</cfquery>
		
		<cfif revCuentasReglas.total gt 0>
			
			<cfset LvarMsg="La Cuenta Financiera no cumple con las Reglas de Validación definidas para el Proyecto">
			<cfquery name="rsListaObras" datasource="sifinterfaces">
				UPDATE IE21 
				set Status = 4, 
					MsgError = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMsg#"> 
				where ID = #GvarID#
			</cfquery>			
			<cfthrow message="#LvarMsg#">				

		</cfif>
		
	</cfif>

	<!--- *********************************************************************** --->
	<!--- *********************************************************************** --->
	<!--- ***** INCLUSION DE DATOS EN LA PANTALLA PRELIMINAR DE APROBACION. ***** --->
	<!--- *********************************************************************** --->
	<!--- *********************************************************************** --->
		

	<!--- Verifica que las obras que no existen, pueden asociarse al proyecto indicado,
		  según el catálogo de obras que se indica en el proyecto 
	--->
	<cfquery name="rsVerificaCtlg" datasource="sifinterfaces">
	Select count(1) as total
	from IE21 a 
	where ID = #GvarID#
	  and not exists (Select 1 
					  from <cf_dbdatabase datasource="#session.DSN#" table="PCDCatalogo p">
								inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto b">
									 on p.PCEcatid = b.PCEcatidObr										
					  where b.OBPcodigo = a.OBPcodigo
						and p.PCDvalor  = a.OBOcodigo
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
						and (	
								(select PCEempresa 
								from <cf_dbdatabase datasource="#session.DSN#" table="PCECatalogo"> 
								where PCEcatid=p.PCEcatid) = 0 
							OR 
								coalesce(p.Ecodigo,-1) = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
							)
					 )
	</cfquery>

	<cfif rsVerificaCtlg.total gt 0>
		
		<cfset LvarMsg="ERROR: Hay datos inconsistentes entre las obras y los proyectos a los que estan asociados. Los valores de la obra no son válidos según el catálogo asociado al proyecto.">
		<cfquery name="rsListaObras" datasource="sifinterfaces">
			UPDATE IE21 
			set Status = 4, 
				MsgError = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMsg#"> 
			where ID = #GvarID#
		</cfquery>			
		<cfthrow message="#LvarMsg#">			

	</cfif>	

	<!--- *************************************************************** --->
	<!--- *************************************************************** --->
	<!--- *** INSERTA LA INFORMACION DE LA OBRA EN CASO DE NO EXISTIR *** --->
	<!--- *************************************************************** --->
	<!--- *************************************************************** --->	
	
	<cf_dbtemp name="OB_NUEVASOBRAS" returnvariable="OB_NUEVASOBRAS" datasource="sifinterfaces">
		<cf_dbtempcol name="OBOcodigo" 		type="char(10)"    	mandatory="yes">
		<cf_dbtempcol name="OBPid"    		type="numeric"     	mandatory="yes">
		<cf_dbtempcol name="OBexiste"  		type="integer"     	mandatory="yes">	
		<cf_dbtempcol name="OBOfechaInicio"	type="datetime"		mandatory="no">
		<cf_dbtempcol name="OBOfechaFinal"	type="datetime"		mandatory="no">
		<cf_dbtempcol name="OBOtexto"		type="text"			mandatory="no">
		<cf_dbtempcol name="OBOdescripcion"	type="varchar(40)"  mandatory="no">
		<cf_dbtempcol name="OBOid"  		type="numeric"      mandatory="no">
	</cf_dbtemp>

	<cfquery name="rsInsertaObra" datasource="sifinterfaces">
		INSERT #OB_NUEVASOBRAS#(OBOcodigo, 
								OBPid, 
								OBexiste,							
								OBOdescripcion,
								OBOfechaInicio,
								OBOfechaFinal								
								)
		SELECT distinct a.OBOcodigo, 
						b.OBPid, 
						0 as OBexiste,

						coalesce(OBOdescripcion,'Obra Generada por Interfaz') as OBOdescripcion,
						
						coalesce(OBOfechaInicio, (Select Min(OBEfechaInicio)
												 from IE21
												 where IE21.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
												   and OBPcodigo = a.OBPcodigo
												   and OBOcodigo = a.OBOcodigo)) as OBOfechaInicio,
												 
						coalesce(OBOfechaFinal, (Select Max(OBEfechaFinal)
												 from IE21 
												 where IE21.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
												   and OBPcodigo = a.OBPcodigo
												   and OBOcodigo = a.OBOcodigo)) as OBOfechaFinal
		from IE21 a
				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto b">
					 on a.OBPcodigo = b.OBPcodigo
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		
		where ID = #GvarID#
		  and not exists (	Select 1
							from <cf_dbdatabase datasource="#session.DSN#" table="OBobra ob">
									inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto pr">
										on ob.OBPid = pr.OBPid
							where ob.OBOcodigo = a.OBOcodigo
							  and ob.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
							  and pr.OBPcodigo = a.OBPcodigo)			
	</cfquery>
	
	<cfquery name="rsInsertaObra" datasource="sifinterfaces">
		UPDATE #OB_NUEVASOBRAS#
		set OBOtexto = coalesce(convert(varchar(255),a.OBOtexto), 'Obra Generada por Interfaz'	)
		from IE21 a
				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto b">
					 on a.OBPcodigo = b.OBPcodigo
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
				
		where ID = #GvarID#
		   and not exists (	Select 1
						from <cf_dbdatabase datasource="#session.DSN#" table="OBobra ob">
								inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto pr">
									on ob.OBPid = pr.OBPid
						where ob.OBOcodigo = a.OBOcodigo
						  and ob.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
						  and pr.OBPcodigo = a.OBPcodigo)	
	</cfquery>	
	
	
	<cfquery name="rsInsertaObra" datasource="sifinterfaces">
		INSERT #OB_NUEVASOBRAS#(OBOcodigo, OBPid, OBexiste)
		SELECT distinct a.OBOcodigo, b.OBPid, 1 as OBexiste
		from IE21 a
				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto b">
					 on a.OBPcodigo = b.OBPcodigo
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		
		where ID = #GvarID#
		  and  exists (		Select 1
							from <cf_dbdatabase datasource="#session.DSN#" table="OBobra ob">
									inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto pr">
										on ob.OBPid = pr.OBPid
							where ob.OBOcodigo = a.OBOcodigo
							  and ob.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
							  and pr.OBPcodigo = a.OBPcodigo)			
	</cfquery>		
	
	<cfquery name="rsInsertaObra" datasource="sifinterfaces">
		INSERT <cf_dbdatabase datasource="#session.DSN#" table="P_OBobra">
		(
			ID,
			Ecodigo,
			OBPid,
			OBOcodigo,
			
			PCDcatidObr,
			PCEcatidOG,
			OBOdescripcion,
			<!---OBOtexto,--->
			
			OBOfechaInicio,
			OBOfechaFinal,
			OBOresponsable,
			CFformatoObr,
			
			OBOfechaInclusion,
			UsucodigoInclusion,
			OBOavance,
			
			BMUsucodigo,
			Modificable,
			Status,
			datosinterfaz
		)

		Select
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">,
				b.OBPid,
				a.OBOcodigo,
				
				(Select Max(pcn.PCDcatid)
				 from <cf_dbdatabase datasource="#session.DSN#" table="PCDCatalogo pcn">
				 where pcn.PCEcatid = b.PCEcatidObr
				   and pcn.PCDvalor = a.OBOcodigo) as PCDcatidObr,
								   
				(Select Max(pcn.PCEcatid)
				 from <cf_dbdatabase datasource="#session.DSN#" table="PCNivelMascara pcn">
				 where pcn.PCEMid = c.PCEMid
				   and pcn.PCNid  = c.OBTPnivelObjeto) as PCEcatidOG,
				   
				a.OBOdescripcion,
				<!--- convert(varchar(255),a.OBOtexto),	--->			
				a.OBOfechaInicio,										 
				a.OBOfechaFinal,										 
				'Interfaz21' as OBOresponsable,
				'' as CFformatoObr,
				
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				0 as OBOavance,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				0,2,1
				
		from #OB_NUEVASOBRAS# a
				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto b">
					 on a.OBPid = b.OBPid
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">

				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBtipoProyecto c">
					 on c.OBTPid = b.OBTPid
					 
		where a.OBexiste = 0
		  <!--- Verifica que no exista en la pantalla de predefinicion ---> 
		  and not exists(	
		  				  Select 1
		  				  from <cf_dbdatabase datasource="#session.DSN#" table="P_OBobra po">		  
		  				  where po.OBOcodigo =  a.OBOcodigo
				  			and po.OBPid = a.OBPid	
						)
		union 
		
		Select 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">,
			ob.Ecodigo,
			ob.OBPid,
			ob.OBOcodigo,
			
			ob.PCDcatidObr,
			ob.PCEcatidOG,
			ob.OBOdescripcion,
			<!--- convert(varchar(255),ob.OBOtexto), --->
			
			ob.OBOfechaInicio,
			ob.OBOfechaFinal,
			ob.OBOresponsable,
			ob.CFformatoObr,
			
			ob.OBOfechaInclusion,
			coalesce(ob.UsucodigoInclusion, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">),
			coalesce(ob.OBOavance,0),
			
			coalesce(ob.BMUsucodigo,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">),
			0 as Modificable,
			2 as Status,
			1 as datosinterfaz
						
		from #OB_NUEVASOBRAS# a
				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto b">
					 on a.OBPid = b.OBPid
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">

				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBtipoProyecto c">
					 on c.OBTPid = b.OBTPid
				
				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBobra ob">						 						 
					 on ob.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
					and ob.OBPid    = a.OBPid
					and ob.OBOcodigo= a.OBOcodigo

		where a.OBexiste = 1
		  <!--- Verifica que no exista en la pantalla de predefinicion ---> 
		  and not exists(	
		  				  Select 1
		  				  from <cf_dbdatabase datasource="#session.DSN#" table="P_OBobra po">		  
		  				  where po.OBOcodigo = a.OBOcodigo
				  			and po.OBPid = a.OBPid	
						)
	</cfquery>
		
	<cfquery name="rsInsertaObra" datasource="sifinterfaces">		
		UPDATE <cf_dbdatabase datasource="#session.DSN#" table="P_OBobra">
		set OBOtexto = a.OBOtexto,
			OBOdescripcion = (	Select PCDdescripcion 
								from <cf_dbdatabase datasource="#session.DSN#" table="PCDCatalogo">
								where PCDcatid = <cf_dbdatabase datasource="#session.DSN#" table="P_OBobra">.PCDcatidObr)
		from #OB_NUEVASOBRAS# a
		where <cf_dbdatabase datasource="#session.DSN#" table="P_OBobra">.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
		  and <cf_dbdatabase datasource="#session.DSN#" table="P_OBobra">.OBOcodigo =  a.OBOcodigo
		  and <cf_dbdatabase datasource="#session.DSN#" table="P_OBobra">.OBPid = a.OBPid	
	</cfquery>	
	
	<!--- Actualiza el formato de Obra --->
	<cfquery name="rsObrasNuevas" datasource="sifinterfaces">
		Select  a.OBOcodigo, 
				b.OBPcodigo,
				b.OBPid,
				c.PCEMid, 
				c.OBTPnivelProyecto,
				c.OBTPnivelObra, 
				substring(b.CFformatoPry,6,datalength(b.CFformatoPry)) as CFformatoPry, 
				c.Cmayor,
				c.OBTPcodigo
		from #OB_NUEVASOBRAS# a
				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto b">
					 on a.OBPid = b.OBPid
					 
				inner join <cf_dbdatabase datasource="#session.DSN#" table="OBtipoProyecto c">
					 on c.OBTPid = b.OBTPid
	</cfquery>

	<cfloop query="rsObrasNuevas">
	
		<cfset codObra = rsObrasNuevas.OBOcodigo>
		<cfset codPry = rsObrasNuevas.OBPcodigo>
		<cfset codPryID = rsObrasNuevas.OBPid>
		<cfset codNivPry = rsObrasNuevas.OBTPnivelProyecto>
		<cfset codNivObra = rsObrasNuevas.OBTPnivelObra>
		<cfset LvarPCEMid = rsObrasNuevas.PCEMid>
		<cfset LvarMayor = rsObrasNuevas.Cmayor>
		<cfset LvarOBTPcodigo = rsObrasNuevas.OBTPcodigo>
		
		<cfquery name="rsMascara" datasource="sifinterfaces">
			Select 	case when PCNid = #codNivPry# then
							'#codPry#'
						when PCNid = #codNivObra# then
							'#codObra#'
						else
							replicate('X',PCNlongitud) 
						end as nivel, PCNlongitud
			from <cf_dbdatabase datasource="#session.DSN#" table="PCNivelMascara a">
					inner join  <cf_dbdatabase datasource="#session.DSN#" table="OBtipoProyecto b">
						on a.PCEMid = b.PCEMid
			where a.PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCEMid#">
				and b.OBTPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarOBTPcodigo#">
				and a.PCNid <= <cfqueryparam cfsqltype="cf_sql_integer" value="#codNivObra#">
			order by PCNid
		</cfquery>

		<cfset LvarMascara = trim(LvarMayor)>
		<cfloop query="rsMascara">
				<cfset LvarMascara = trim(LvarMascara) & "-" & trim(rsMascara.nivel)>								
		</cfloop>
		
		<cfquery name="ActFrmObra" datasource="sifinterfaces">
			UPDATE <cf_dbdatabase datasource="#session.DSN#" table="P_OBobra">
			set CFformatoObr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMascara#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
			  and OBPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codPryID#"> 
			  and OBOcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#codObra#"> 				
			  and CFformatoObr is not null
		</cfquery>
		
	</cfloop>

	<!--- INSERCION DE LAS ETAPAS --->
	<cfquery datasource="sifinterfaces">
		UPDATE #OB_NUEVASOBRAS#
		set OBOid = OBconsecutivo
		from <cf_dbdatabase datasource="#session.DSN#" table="P_OBobra a">
		where #OB_NUEVASOBRAS#.OBOcodigo = a.OBOcodigo
		  and #OB_NUEVASOBRAS#.OBPid = a.OBPid
	</cfquery>
	
	<cfquery name="rsListaObras" datasource="sifinterfaces">
		Select * 
		from #OB_NUEVASOBRAS#
	</cfquery>
	
	<cfloop query="rsListaObras">
	
		<cfset LvarOBPid = rsListaObras.OBPid>
		<cfset LvarOBOid = rsListaObras.OBOid>	
		<cfset LvarOBOcodigo = rsListaObras.OBOcodigo>	
	
		<cfquery name="rsListaEtapas" datasource="sifinterfaces">
			Select				
				b.OBPid,
				c.Ocodigo,
				a.OBOcodigo,
				a.OBEcodigo,
				a.OBEdescripcion,
				a.OBEtexto,
				
				a.OBEfechaInicio,
				a.OBEfechaFinal,
				a.OBEresponsable,
				a.Usucodigo
	
			from IE21 a
					
					inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto b">
						on a.OBPcodigo = b.OBPcodigo
					   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	
					inner join <cf_dbdatabase datasource="#session.DSN#" table="Oficinas c">
						on c.Oficodigo = a.Oficodigo
					   and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">					
	
			where a.ID = #GvarID#
			  and a.OBOcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarOBOcodigo#">
			  and a.OBPcodigo = b.OBPcodigo
			  and b.OBPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarOBPid#">
			  and not exists (
			  					Select 1
								from <cf_dbdatabase datasource="#session.DSN#" table="P_OBetapa pe">
								where pe.OBOcodigo = a.OBOcodigo
								  and pe.OBEcodigo = a.OBEcodigo
			  				 )	
		</cfquery>
	
		<cfloop query="rsListaEtapas">
	
			<!--- INSERTA LAS ETAPAS DE LA OBRA --->
			<cfquery datasource="sifinterfaces" name="rsInsEtapa">
				insert into <cf_dbdatabase datasource="#session.DSN#" table="P_OBetapa"> (			
					ID,
					Ecodigo,
					OBPid,
					OBOcodigo,
					OBOid,
					Ocodigo,
					OBEcodigo,
					OBEdescripcion,
					OBEtexto,
					
					OBEfechaInicio,
					OBEfechaFinal,
					OBEresponsable,
					BMUsucodigo)

				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsListaEtapas.OBPid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsListaEtapas.OBOcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarOBOid#">,		
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsListaEtapas.Ocodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsListaEtapas.OBEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsListaEtapas.OBEdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsListaEtapas.OBEtexto#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsListaEtapas.OBEfechaInicio#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsListaEtapas.OBEfechaFinal#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsListaEtapas.OBEresponsable#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsListaEtapas.Usucodigo#">
					  )
				<cf_dbidentity1 name="rsInsEtapa" datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 name="rsInsEtapa" datasource="#session.dsn#" returnVariable="LvarOBEconsecutivo">

			<!--- INSERTA LAS CUENTAS --->
			<cfquery datasource="sifinterfaces" name="rsInsEtapa">
				insert into <cf_dbdatabase datasource="#session.DSN#" table="P_OBetapaCuentas"> (
							ID,
							OBEconsecutivo,
							OBPid,
							CFformato,
							CFcuenta,
							OBECmsgGeneracion							
							)
				Select 		<cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarOBEconsecutivo#">,
							b.OBPid,
							Cformato,
							(Select Min(CFcuenta) 
							 from <cf_dbdatabase datasource="#session.DSN#" table="CFinanciera">
							 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
							   and CFformato = a.Cformato) as CFcuenta,
							null
				from ID21 a
						inner join IE21 c
							 on c.OBPcodigo = a.OBPcodigo
							and c.OBOcodigo = a.OBOcodigo
							and c.OBEcodigo = a.OBEcodigo
							and c.ID = a.ID				
				
						inner join <cf_dbdatabase datasource="#session.DSN#" table="OBproyecto b">
							 on a.OBPcodigo = b.OBPcodigo				
							and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
				where a.ID = #GvarID#
				  and not exists(
				  				 Select 1
				  				 from <cf_dbdatabase datasource="#session.DSN#" table="P_OBetapaCuentas pc">
								 where pc.OBEconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarOBEconsecutivo#">
								   and pc.CFformato = a.Cformato
								 )
			</cfquery>
			
		</cfloop>
	
	</cfloop>
	<!--- 
	Status: 
	1- En proceso de aprobación (Se encuentra en la pantalla de aprobación)
	2- Procesado (El autorizador decidió pasar la información)
	3- Rechazado (El autorizador decidió rechazar la información)
	4- Errores (Se presentó algun erro a la hora de enviar la información)
	--->
	<cfquery name="rsListaObras" datasource="sifinterfaces">
		UPDATE IE21 
		set Status = 1
		where ID = #GvarID#
	</cfquery>	
	
</cftransaction>