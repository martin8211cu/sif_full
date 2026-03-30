<cfinvoke key="El_Puesto_no_puede_ser_eliminado_debido_a_que_posee_registros_asociados" default="El Puesto no puede ser eliminado debido a que posee registros asociados. " returnvariable="LB_ErrorPuesto" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Error_El_codigo_de_registro_que_desea_insertar_ya_existe"
Default="Error. El c&oacute;digo de registro que desea insertar ya existe."
returnvariable="MG_CodigoExiste"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Error_inactivando_puesto_No_se_puede_inactivar_el_puesto_porque_existen_empleados_nombrados_actualmente_utilizando_una_plaza_que_utiliza_este_puesto."
Default="Error inactivando puesto #form.RHPcodigo# - #form.RHPdescpuesto#. No se puede inactivar el puesto porque existen empleados nombrados actualmente utilizando una plaza que utiliza este puesto."
returnvariable="MG_InactivandoPuesto"/> 


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Error_inactivando_puesto_No_se_puede_inactivar_el_puesto_porque_existe_un_concurso_activo_en_el_proceso_de_Reclutamiento_y_Seleccion_para_este_puesto"
Default="Error inactivando puesto #form.RHPcodigo# - #form.RHPdescpuesto#. No se puede inactivar el puesto porque existe un concurso activo en el proceso de Reclutamiento y Seleccion para este puesto"
returnvariable="MG_InactivandoPuestoConcurso"/> 


<cfparam name="action" default="Puestos.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>

<!----Verificar parámetro de planillapresupuestaria---->
<cfquery name="rsVerificaPP" datasource="#session.DSN#">
	select Pvalor from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 540
</cfquery>
<cfset vb_planillap = rsVerificaPP.Pvalor>

<!---se saco del cftransaction para que funcione bien el mensaje de error--->
<cfquery name="rsValidaCodigo" datasource="#session.dsn#">
	select 1 
	from RHPuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	and ((RHPcodigoext is not null and RHPcodigoext = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">)) or 
	(RHPcodigoext is null and RHPcodigo = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#" >)))
</cfquery>
<!---Si el código ya existe envia un mensaje de error--->
<cfif rsValidaCodigo.recordcount gt 0 and isdefined("form.Alta")> 
	<cf_throw message="#MG_CodigoExiste#" errorcode="2115">
</cfif>

<cftransaction>
	<cftry>
		<cfif isdefined("form.Alta")>			
			<!---===================== Si no usa planilla presupuestaria crear puesto presupuestario asociado =================------>
			<cfif not vb_planillap and not (isdefined("form.RHMPPid") and len(trim(form.RHMPPid)))><!---Si tampoco selecciono un puesto presupuestario---->
				<cfquery name="rsCategoria" datasource="#session.DSN#">
					select max(RHCid) as RHCid 
					from RHCategoria 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfoutput>
					<cfset RHPcodigo = 'PP-' & form.RHPcodigo>
					<cfset RHPdescripcion = 'Puesto presupuestario - ' & form.RHPdescpuesto>
				</cfoutput>
				<cfquery name="insertaPuestoP" datasource="#session.DSN#">
					insert into RHMaestroPuestoP (RHCid, 
												Ecodigo, 
												RHMPPcodigo, 
												RHMPPdescripcion, 
												BMfecha, 
												BMUsucodigo, 
												Complemento)
					values (<cfif isdefined("rsCategoria") and rsCategoria.RecordCount NEQ 0 and len(trim(rsCategoria.RHCid))>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCategoria.RHCid#">
							<cfelse>
								null
							</cfif>,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#RHPcodigo#" >,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#RHPdescpuesto#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							null
							)
					<cf_dbidentity1 datasource="#session.DSN#">												
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insertaPuestoP">
			</cfif>
			<!---maikelv--->
			<!---Verifica si el código ya existe--->
			<!---<cfquery name="rsValidaCodigo" datasource="#session.dsn#">
				select 1 
				from RHPuestos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				and ((RHPcodigoext is not null and RHPcodigoext = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">)) or 
				(RHPcodigoext is null and RHPcodigo = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#" >)))
	        </cfquery>
			<!---Si el código ya existe envia un mensaje de error--->
			<cfif rsValidaCodigo.recordcount gt 0>
		    	<cf_throw message="#MG_CodigoExiste#" errorcode="2115">
			</cfif>--->
			<!---maikelv--->
			<cfquery name="RHPuestosInsert" datasource="#session.DSN#">
				insert into RHPuestos 
					(Ecodigo, RHPcodigo,RHPcodigoext, RHPEid, RHTPid, RHPdescpuesto, RHOcodigo, 
					 BMusuario, BMfecha, DEidaprueba, RHPfechaaprob, RHPactivo, CFid, RHGMid, RHMPPid, RHDDVlinea, RHDDVlineaFidelidad,HE2,HE3 )
				values(	<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">,
						<cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">,
						<cfif isdefined("form.RHPEid") and len(trim(form.RHPEid))>
							<cfqueryparam value="#form.RHPEid#" cfsqltype="cf_sql_numeric">
						<cfelse>null</cfif>,
						<cfif len(trim(form.RHTPid)) gt 0>
							<cfqueryparam value="#form.RHTPid#" cfsqltype="cf_sql_numeric">
						<cfelse>null</cfif>,
						<cfqueryparam value="#form.RHPdescpuesto#" cfsqltype="cf_sql_varchar">,
						<cfif len(trim(form.RHOcodigo)) gt 0>
							<cfqueryparam value="#form.RHOcodigo#" cfsqltype="cf_sql_char">
						<cfelse>null</cfif>,
						<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
						<cfif isdefined("form.DEid") and len(trim(form.DEid))>
							<cfqueryparam value="#form.DEid#" cfsqltype="cf_sql_numeric">
						<cfelse>null</cfif>,
						<cfif isdefined("form.RHPfechaaprob") and len(trim(form.RHPfechaaprob))>
							<cfqueryparam value="#LSParseDateTime(form.RHPfechaaprob)#" cfsqltype="cf_sql_timestamp">
						<cfelse>null</cfif>,
						<cfif isdefined("form.RHPuestoA")> 0 <cfelse> 1 </cfif>,
						<cfif isdefined("form.CFid") and isNumeric(form.CFid)><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#"><cfelse>null</cfif>,
						<cfif isdefined("form.RHGMid") and len(trim(form.RHGMid)) and form.RHGMid NEQ '-1'>
							<cfqueryparam value="#form.RHGMid#" cfsqltype="cf_sql_numeric">
						<cfelse>null</cfif>,					
						<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">
						<cfelseif isdefined("insertaPuestoP.identity") and len(trim(insertaPuestoP.identity))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertaPuestoP.identity#">
						<cfelse>	
							null
						</cfif>,
						<cfif isdefined("form.RHDDVlinea") and len(trim(form.RHDDVlinea ))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDDVlinea #">
						<cfelse>	
							null
						</cfif>,
						<cfif isdefined("form.RHDDVlineaFidelidad") and len(trim(form.RHDDVlineaFidelidad ))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDDVlineaFidelidad#">
						<cfelse>	
							null
						</cfif>
						,#(IsDefined('form.txtHE2') and form.txtHE2 gt 0 ? form.txtHE2 : 0)#
						,#(IsDefined('form.txtHE3') and form.txtHE3 gt 0 ? form.txtHE3 : 0)#
						)
				<!---cf_dbidentity1 datasource="#session.DSN#"--->
			</cfquery>				
			<!---cf_dbidentity2 datasource="#session.DSN#" name="RHPuestosInsert"--->
			<cfset modo = 'CAMBIO'>
			
		<cfelseif isdefined("form.Cambio")>
			<!--- Validación del Timestamp --->
			<cf_dbtimestamp
			 datasource="#session.dsn#"
			 table="RHPuestos"
			 redirect="SQLPuestos-frinfo.cfm"
			 timestamp="#form.ts_rversion#"
			 field1="Ecodigo" type1="numeric" value1="#session.Ecodigo#"
			 field2="RHPcodigo" type2="char" value2="#form.RHPcodigo#">

			<!--- Validación de la inactivación --->
			<cfset inactivar = false>
			<cfset activar = false>
			<cfif isdefined("form.RHPactivo") and form.RHPactivoanterior EQ 1>
				<!--- Se pretende inactivar --->
				<cfquery name="rsTest1" datasource="#session.dsn#">
					select count(1) as test
					from LineaTiempo a
						inner join RHPlazas b
							on b.RHPid = a.RHPid
							and b.Ecodigo = a.Ecodigo
						inner join RHPuestos c
							on c.RHPcodigo = b.RHPpuesto
							and c.Ecodigo = b.Ecodigo
							and c.RHPcodigo = <cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">
					where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between LTdesde and LThasta
					  and a.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif rsTest1.test gt 0>
					<cf_throw message="#MG_InactivandoPuesto#" errorcode="2120">
				</cfif>
				<cfquery name="rsTest2" datasource="#session.dsn#">
					select count(1) as test
					from RHConcursos
					where RHPcodigo = <cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">
					  and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHCestado not in (20,30)
				</cfquery>
				<cfif rsTest2.test gt 0>
						<cf_throw message="#MG_InactivandoPuestoConcurso#" errorcode="2125">
				</cfif>
				<cfset inactivar = true>
			<cfelseif not isdefined("form.RHPactivo") and form.RHPactivoanterior EQ 0>
				<!--- Se pretende activar --->
				<cfset activar = true>				
			</cfif>

			<!----======= Si no usa planilla presupuestaria insertarle cualquier puesto presupuestario que encuentre =====---->
			<cfif not vb_planillap and not (isdefined("form.RHMPPid") and len(trim(form.RHMPPid)))>
				<cfquery name="rsPuestoP" datasource="#session.DSN#">
					select max(RHMPPid) as RHMPPid from RHMaestroPuestoP
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">					
				</cfquery>
			</cfif>
			<!---maikelv--->
			<!---Verifica si es el codigoext lo que intenta modificar--->
			<cfif trim(form.RHPcodigoextanterior) NEQ trim(form.RHPcodigoext)>
			    <!---Verifica si el código ya existe--->
				<cfquery name="rsValidaCodigo" datasource="#session.dsn#">
					select 1
					from RHPuestos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					and ((RHPcodigoext is not null and RHPcodigoext = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigoext#">)) or 
					(RHPcodigoext is null and RHPcodigo = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigoext#" >)))
				</cfquery>
				<!---Si el código ya existe envia un mensaje de error--->
				<cfif rsValidaCodigo.recordcount gt 0>
					<cf_throw message="#MG_CodigoExiste#" errorcode="2115">
				<cfelse>
				<!---Inserta en la bitacora de cambios de codigo de puestos---> 
				<cfquery name="RHBitPuestosInsert" datasource="#session.DSN#">
				insert into RHBitPuestos 
					(RHPcodigo, RHPcodigoext, Ecodigo, BMUsucodigo, BMfecha)
				values(<cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">,
				       <cfqueryparam value="#form.RHPcodigoext#" cfsqltype="cf_sql_char">,
					   <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
					   <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
					   <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">)
				</cfquery>
				</cfif>
			</cfif>
			<!---maikelv--->
			<cfquery name="RHPuestosUpdate" datasource="#session.DSN#">
				update RHPuestos
				set RHPdescpuesto = <cfqueryparam value="#form.RHPdescpuesto#" cfsqltype="cf_sql_varchar">,
					RHTPid = <cfif len(trim(form.RHTPid))>
								<cfqueryparam value="#form.RHTPid#" cfsqltype="cf_sql_numeric">
							<cfelse>null</cfif>,
					RHPEid = <cfif isdefined("form.RHPEid") and len(trim(form.RHPEid))>
								<cfqueryparam value="#form.RHPEid#" cfsqltype="cf_sql_numeric">
							<cfelse>null</cfif>,
					RHOcodigo = <cfif len(trim(form.RHOcodigo)) gt 0>
									<cfqueryparam value="#form.RHOcodigo#" cfsqltype="cf_sql_char">
								<cfelse>null</cfif>,
					<!---maikelv--->
					RHPcodigoext = <cfif len(trim(form.RHPcodigoext)) gt 0>
									<cfqueryparam value="#form.RHPcodigoext#" cfsqltype="cf_sql_char">
								<cfelse>null</cfif>,
					<!---maikelv--->
					BMusumod = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
					BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,					
					DEidaprueba = <cfif isdefined("form.DEid") and len(trim(form.DEid))>
								  	<cfqueryparam value="#form.DEid#" cfsqltype="cf_sql_numeric">
								  <cfelse>null</cfif>,
					RHPfechaaprob =	<cfif isdefined("form.RHPfechaaprob") and len(trim(form.RHPfechaaprob))>
										<cfqueryparam value="#LSParseDateTime(form.RHPfechaaprob)#" cfsqltype="cf_sql_timestamp">
									<cfelse>null</cfif>,
					<cfif inactivar>
						RHPactivo = 0,
						RHPfactiva = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfelseif activar>
						RHPactivo = 1,
						RHPfactiva = null,
					</cfif>
					CFid = <cfif isdefined("form.CFid") and isNumeric(form.CFid)><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#"><cfelse>null</cfif>
					
					<cfif isdefined("form.RHGMid") and len(trim(form.RHGMid)) and form.RHGMid NEQ '-1'>
						, RHGMid=<cfqueryparam value="#form.RHGMid#" cfsqltype="cf_sql_numeric">
					<cfelse>, RHGMid = null</cfif>	
					
					<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
						, RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">
					<cfelseif isdefined("rsPuestoP") and rsPuestoP.RecordCount NEQ 0 and len(trim(rsPuestoP.RHMPPid))>
						, RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPuestoP.RHMPPid#">
					<cfelse>	
						, RHMPPid = null
					</cfif>
					<cfif isdefined("form.RHDDVlinea") and len(trim(form.RHDDVlinea ))>
						, RHDDVlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDDVlinea #">
					<cfelse>	
						, RHDDVlinea = null
					</cfif>												
					<cfif isdefined("form.RHDDVlineaFidelidad") and len(trim(form.RHDDVlineaFidelidad ))>
						, RHDDVlineaFidelidad = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDDVlineaFidelidad #">
					<cfelse>	
						, RHDDVlineaFidelidad = null
					</cfif>	
					,HE2 = #form.txtHE2#
					,HE3 = #form.txtHE3#									
											
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHPcodigo =  '#trim(form.RHPcodigo)#'
			</cfquery>
			
			<cfset modo = 'CAMBIO'>
		<cfelseif isdefined("form.Baja")>

			<cfquery name="RHPlazasConsulta" datasource="#session.DSN#">
				select 1 from RHPlazas
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHPcodigo =  <cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfif isdefined("RHPlazasConsulta") and RHPlazasConsulta.RecordCount GT 0>
				raiserror 40000 'No se puede eliminar el registro porque posee referencias en la tabla RHPlazas.'
			</cfif>
			<!--- if exists ( 
				select 1 from RHPlazas
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHPcodigo =  <cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">)
			raiserror 40000 'No se puede eliminar el registro porque posee referencias en la tabla RHPlazas.' --->
			<cfquery name="LineaTiempoConsulta" datasource="#session.DSN#">
				select 1 from LineaTiempo
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHPcodigo =  <cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfif isdefined("LineaTiempoConsulta") and LineaTiempoConsulta.RecordCount GT 0>
				raiserror 40000 'No se puede eliminar el registro porque posee referencias en la tabla LineaTiempo.'
			</cfif>
			
<!--- 			if exists ( 
				select 1 from LineaTiempo
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHPcodigo =  <cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">)
			raiserror 40000 'No se puede eliminar el registro porque posee referencias en la tabla LineaTiempo.'
 --->
			<cfquery name="SalarioPuestoConsulta" datasource="#session.DSN#">
				select 1 from SalarioPuesto
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHPcodigo =  <cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">			
			</cfquery>
			<cfif isdefined("SalarioPuestoConsulta") and SalarioPuestoConsulta.RecordCount GT 0>
				raiserror 40000 'No se puede eliminar el registro porque posee referencias en la tabla SalarioPuesto.'
			</cfif>
<!--- 			if exists ( 
				select 1 from SalarioPuesto
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHPcodigo =  <cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">)
			raiserror 40000 'No se puede eliminar el registro porque posee referencias en la tabla SalarioPuesto.' --->
			<cfquery name="DLaboralesEmpleadoConsulta" datasource="#session.DSN#">
				select 1 from DLaboralesEmpleado
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHPcodigo =  <cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfif isdefined("DLaboralesEmpleadoConsulta") and DLaboralesEmpleadoConsulta.REcordCount GT 0>
				raiserror 40000 'No se puede eliminar el registro porque posee referencias en la tabla DLaboralesEmpleado.'
			</cfif>
<!--- 			if exists ( 
				select 1 from DLaboralesEmpleado
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHPcodigo =  <cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">)
			raiserror 40000 'No se puede eliminar el registro porque posee referencias en la tabla DLaboralesEmpleado.'
 --->
			<cfquery name="RHDescPuestoDelete" datasource="#session.DSN#">
				delete from RHDescriptivoPuesto
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHPcodigo =  '#trim(form.RHPcodigo)#'
			</cfquery>
			<cfquery name="RHHabPuestoDelete" datasource="#session.DSN#">
				delete from RHHabilidadesPuesto
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHPcodigo =  '#trim(form.RHPcodigo)#'
			</cfquery>
			<cfquery name="RHConPuestoDelete" datasource="#session.DSN#">
				delete from RHConocimientosPuesto
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHPcodigo =  '#trim(form.RHPcodigo)#'
			</cfquery>
			<cfquery name="RHValPuestoDelete" datasource="#session.DSN#">			  
				delete from RHValoresPuesto
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHPcodigo =  '#trim(form.RHPcodigo)#'
			</cfquery>
			<cfquery name="RHBitPuestoDelete" datasource="#session.DSN#">	
			delete from RHBitPuestos 
            where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and RHPcodigo =  '#trim(form.RHPcodigo)#'	  
			</cfquery>
			
			<cftry>
				<cfquery name="RHPuestoDelete" datasource="#session.DSN#">			  
					delete from RHPuestos
					where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHPcodigo =  '#trim(form.RHPcodigo)#'
				 </cfquery>
				 
				 <cfcatch type="any">
				 <cf_throw message="#LB_ErrorPuesto#" errorcode="380">
				 </cfcatch>
			</cftry>
			
			
		</cfif>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cftransaction>	
</cfif>	

<cfif isdefined("form.Baja")>
	<cflocation url="Puestos-lista.cfm">
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="sel"    type="hidden" value="1">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'>
		<cfset LRHPcodigo = "">
		<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo)) gt 0>
			<cfset LRHPcodigo = form.RHPcodigo>
		<cfelseif isdefined("ABC_puestos.idretlyins") and len(trim(ABC_puestos.idretlyins)) gt 0>
			<cfset LRHPcodigo = ABC_puestos.idretlyins>
		</cfif>
		<input name="RHPcodigo" type="hidden" value="#LRHPcodigo#">
	</cfif>
</form>
</cfoutput>

<HTML>
<head>
</head>
<body bgcolor="#FFFFFF" text="#996666" link="#FF0000" vlink="#663333" alink="#FF9999">
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>