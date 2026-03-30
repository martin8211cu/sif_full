<cfquery name="rspuestosActivos" datasource="#session.DSN#">
	select RHPcodigo from RHPuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
	and RHPactivo = 1
</cfquery>

<cfoutput>
	HAY <cfdump  var="#rspuestosActivos.recordCount#"> PUESTOS ACTIVOS <BR>
	INICIA PROCESO DE RESPALDO. <BR>
</cfoutput>
<cfset form.RHPcodigo =''>
<cfif rspuestosActivos.recordCount GT 0>
	<cfloop query="rspuestosActivos">
		<cfset form.RHPcodigo = rspuestosActivos.RHPcodigo>
		<cftransaction>
			<cfquery name="rsInsert" datasource="#session.DSN#">
				insert into RHDescripPuestoP(
					RHPcodigo,
					Ecodigo,
					RHDPmision,
					RHDPobjetivos,
					Estado,
					UsuarioAsesor,
					FechaModAsesor,
					BMusumod,     	 
					BMfechamod,
					Observaciones		
					)
				select 
					'#form.RHPcodigo#' as RHPcodigo, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> as Ecodigo ,
					RHDPmision,
					RHDPobjetivos,
					50,
					<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
					<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
					 <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
					 'Respaldo del descriptivo del puesto'
				from RHPuestos a
				left outer join RHDescriptivoPuesto b
					on  a.RHPcodigo = b.RHPcodigo
					and a.Ecodigo = b.Ecodigo
				where a.RHPcodigo = '#form.RHPcodigo#'
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 name="rsInsert" datasource="#session.DSN#">
			<cfset Form.RHDPPid = rsInsert.identity>
			<!--- Inserta los datos variables del perfil actual del puesto --->
			<cfquery name="rsInsert" datasource="#session.DSN#">
				insert into RHDVPuestoP (RHDPPid,RHEDVid,RHDDVlinea,RHDDVvalor,RHDVPorden,BMUsucodigo,fechaalta)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">,
						RHEDVid,
						RHDDVlinea,
						RHDDVvalor,
						RHDVPorden,
						<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
				from  RHDVPuesto
				where RHPcodigo = '#form.RHPcodigo#'
				and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			 </cfquery>
			<!--- Inserta las habilidades del perfil actual del puesto --->
			<cfquery name="rsInsert" datasource="#session.DSN#">
				insert into RHHabilidadPuestoP (RHHid,RHDPPid,RHNid,RHNnotamin,RHHtipo,RHHpeso,PCid,ubicacionB,BMUsucodigo) 
				select 
					RHHid,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#"> as RHDPPid,
					RHNid,
					RHNnotamin,
					RHHtipo,
					RHHpeso,
					PCid,
					ubicacionB,
					<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
				from  RHHabilidadesPuesto 
				where RHPcodigo = '#form.RHPcodigo#'
					and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			 </cfquery>	
			<!--- Inserta los conicimientos del perfil actual del puesto --->
			 <cfquery name="rsInsert" datasource="#session.DSN#">
				insert into RHConocimientoPuestoP (RHDPPid,RHCid,RHNid,RHCnotamin,RHCtipo,RHCpeso,BMUsucodigo)
				select 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#"> as RHDPPid,
					RHCid,RHNid,RHCnotamin,RHCtipo,RHCpeso,
					<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
				from RHConocimientosPuesto				
				where RHPcodigo = '#form.RHPcodigo#'
					and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			 </cfquery>		 
			<!--- Inserta los valores del perfil actual del puesto --->
			 <cfquery name="rsInsert" datasource="#session.DSN#">
				insert into RHValorPuestoP(RHDPPid,RHDCGid,RHECGid,RHVPtipo,BMUsucodigo)
				select 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#"> as RHDPPid,
					RHDCGid,RHECGid,RHVPtipo,
					<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
				from RHValoresPuesto				
				where RHPcodigo = '#form.RHPcodigo#'
					and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			 </cfquery>
		</cftransaction>
	</cfloop>
</cfif>	
<cfoutput>
	
	Respaldo ejecutad con exito <BR>
</cfoutput>