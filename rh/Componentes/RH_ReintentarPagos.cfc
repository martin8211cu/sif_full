<cfcomponent>
	<cffunction name="ReintentarPagos" access="public" output="true" >
		<cfargument name="conexion"		type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="ERNid"   		type="numeric" 	required="yes">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="debug" 		type="boolean"  default="no">

		
		<!--- 	Genera una Relación de Pago nueva a partir de una existente   --->
		<cfset DRNlinea 	= -1 >
		<cfset newERNid 	= -1 >
		<cfset newDRNlinea 	= -1 >
		<cfset estutus 	    = -1 >
	
		<!--- LISTA DE ERRORES --->
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_SeGeneroUnErrorAlCrearLaNuevaRelacionDePago"
		Default="Error! Se generó un error al crear la nueva relación de Pago. Procreso Cancelado!"
		returnvariable="MSG_SeGeneroUnErrorAlCrearLaNuevaRelacionDePago"/>
	
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_SeGeneroUnErrorAlCrearLosDetallesDeLaNuevaRelacionDePago"
		Default="Error! Se generó un error al crear los detalles de la nueva relación de Pago. Procreso Cancelado!"
		returnvariable="MSG_SeGeneroUnErrorAlCrearLosDetallesDeLaNuevaRelacionDePago"/>
	
		<cftransaction>
			<cfquery  name="RSInsertaERNomina" datasource="#arguments.conexion#">
				insert ERNomina (
					Bid, 
					Ecodigo,
					Tcodigo, 
					ERNfcarga, 
					ERNfdeposito, 
					ERNfinicio,
					ERNffin, 
					ERNdescripcion, 
					ERNestado, 
					Usucodigo,
					Ulocalizacion, 
					ERNusuverifica, 
					ERNfverifica, 
					ERNusuautoriza,
					ERNfautoriza, 
					ERNfechapago, 
					ERNsistema, 
					CBcc,
					ERNcuenta, 
					CBTcodigo, 
					Mcodigo,
					ERNcapturado, 
					ERNfprogramacion, 
					RCNid)
				select
					Bid, 
					Ecodigo,
					Tcodigo, 
					ERNfcarga, 
					ERNfdeposito, 
					ERNfinicio,
					ERNffin, 
					ERNdescripcion, 
					2, 
					Usucodigo,
					Ulocalizacion, 
					ERNusuverifica, 
					ERNfverifica, 
					ERNusuautoriza,
					ERNfautoriza, 
					ERNfechapago, 
					ERNsistema, 
					CBcc,
					ERNcuenta, 
					CBTcodigo, 
					Mcodigo,
					ERNcapturado, 
					ERNfprogramacion, 
					RCNid
				from ERNomina
				where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ERNid#">
				<cf_dbidentity1 datasource="#arguments.conexion#">
			</cfquery>
			<cf_dbidentity2 datasource="#arguments.conexion#" name="RSInsertaERNomina">
			<cfif not isdefined("RSInsertaERNomina.identity")>
				<cfthrow message="#MSG_SeGeneroUnErrorAlCrearLaNuevaRelacionDePago#">
				<cfabort>
			</cfif>
			<cfset newERNid = RSInsertaERNomina.identity>
			
			<cfquery  name="RSDetalleERNomina" datasource="#arguments.conexion#">
				select 
					 DRNlinea, NTIcodigo, 
					 DRIdentificacion, Bid, DRNcuenta, CBcc, 
					 CBTcodigo, Mcodigo, DRNnombre, DRNapellido1, 
					 DRNapellido2, DRNtipopago, DRNperiodo, DRNnumdias, 
					 DRNsalbruto, DRNsaladicional, DRNreintegro, DRNrenta, 
					 DRNobrero, DRNpatrono, DRNotrasdeduc, DRNliquido, 
					 DRNpuesto, DRNocupacion, DRNotrospatrono, DRNfondopen, 
					 DRNfondocap, DRNinclexcl, DRNfinclexcl, 
					 DEid, DRNmes, DRNper
				from DRNomina 
				where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ERNid#">		
				order by DRNlinea
			</cfquery>
			<cfloop query="RSDetalleERNomina">
				<cfset newDRNlinea 	= -1 >
				<cfquery  name="RSInsertaDetalleERNomina" datasource="#arguments.conexion#">
					insert DRNomina (
							 ERNid, 
							 NTIcodigo, 
							 DRIdentificacion, 
							 Bid, 
							 DRNcuenta, 
							 CBcc, 
							 CBTcodigo, 
							 Mcodigo, 
							 DRNnombre, 
							 DRNapellido1, 
							 DRNapellido2, 
							 DRNtipopago, 
							 DRNperiodo, 
							 DRNnumdias, 
							 DRNsalbruto, 
							 DRNsaladicional, 
							 DRNreintegro, 
							 DRNrenta, 
							 DRNobrero, 
							 DRNpatrono, 
							 DRNotrasdeduc, 
							 DRNliquido, 
							 DRNpuesto, 
							 DRNocupacion, 
							 DRNotrospatrono, 
							 DRNfondopen, 
							 DRNfondocap, 
							 DRNinclexcl, 
							 DRNfinclexcl, 
							 DEid, 
							 DRNmes, 
							 DRNper)
						values (
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#newERNid">, 
							 RSDetalleERNomina.NTIcodigo, 
							 RSDetalleERNomina.DRIdentificacion, 
							 RSDetalleERNomina.Bid, 
							 RSDetalleERNomina.DRNcuenta, 
							 RSDetalleERNomina.CBcc, 
							 RSDetalleERNomina.CBTcodigo, 
							 RSDetalleERNomina.Mcodigo, 
							 RSDetalleERNomina.DRNnombre, 
							 RSDetalleERNomina.DRNapellido1, 
							 RSDetalleERNomina.DRNapellido2, 
							 RSDetalleERNomina.DRNtipopago, 
							 RSDetalleERNomina.DRNperiodo, 
							 RSDetalleERNomina.DRNnumdias, 
							 RSDetalleERNomina.DRNsalbruto, 
							 RSDetalleERNomina.DRNsaladicional, 
							 RSDetalleERNomina.DRNreintegro, 
							 RSDetalleERNomina.DRNrenta, 
							 RSDetalleERNomina.DRNobrero, 
							 RSDetalleERNomina.DRNpatrono, 
							 RSDetalleERNomina.DRNotrasdeduc, 
							 RSDetalleERNomina.DRNliquido, 
							 RSDetalleERNomina.DRNpuesto,
							 RSDetalleERNomina.DRNocupacion, 
							 RSDetalleERNomina.DRNotrospatrono, 
							 RSDetalleERNomina.DRNfondopen, 
							 RSDetalleERNomina.DRNfondocap, 
							 RSDetalleERNomina.DRNinclexcl, 
							 RSDetalleERNomina.DRNfinclexcl, 
							 RSDetalleERNomina.DEid, 
							 RSDetalleERNomina.DRNmes, 
							 RSDetalleERNomina.DRNper )
						<cf_dbidentity1 datasource="#arguments.conexion#">
				</cfquery>
				<cf_dbidentity2 datasource="#arguments.conexion#" name="RSInsertaDetalleERNomina">
				<cfif not isdefined("RSInsertaDetalleERNomina.identity")>
					<cfthrow message="#MSG_SeGeneroUnErrorAlCrearLosDetallesDeLaNuevaRelacionDePago#">
					<cfabort>
				</cfif>
				<cfset newDRNlinea = RSInsertaDetalleERNomina.identity>
				
				<cfquery  name="RSInsertaDeduccionesEmpleado" datasource="#arguments.conexion#">
					insert DDeducPagos(
						DRNlinea, 
						Bid, 
						DDdescripcion, 
						DDmonto,
						CBcc, 
						DDnombre, 
						DDidbeneficiario, 
						DDpago,
						DDpagopor, 
						CBTcodigo, 
						Mcodigo, 
						DDcuenta)
					select 
						#newDRNlinea#,
						Bid, 
						DDdescripcion, 
						DDmonto, 
						CBcc, 
						DDnombre, 
						DDidbeneficiario, 
						DDpago,
						DDpagopor, 
						CBTcodigo, 
						Mcodigo, 
						DDcuenta
					from DDeducPagos
					where DRNlinea = RSDetalleERNomina.DRNlinea
				</cfquery>
				
				<cfquery  name="RSIncidencias" datasource="#arguments.conexion#">
					insert DRIncidencias(
						DRNlinea, 
						CIid, 
						ICfecha, 
						ICvalor,
						ICfechasis, 
						ICcalculo, 
						ICbatch, 
						ICmontoant,
						ICmontores, 
						Usucodigo, 
						Ulocalizacion)
					select 
						#newDRNlinea#,
						CIid, 
						ICfecha, 
						ICvalor,
						ICfechasis, 
						ICcalculo, 
						ICbatch, 
						ICmontoant,
						ICmontores, 
						Usucodigo, 
						Ulocalizacion
					from DRIncidencias
					where DRNlinea = RSDetalleERNomina.DRNlinea
				</cfquery>			
	
			</cfloop>
	
			<cfquery  name="DELETE_DDeducPagos" datasource="#arguments.conexion#">
				delete from DDeducPagos  
				from DRNomina
				where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ERNid#">
				and DDeducPagos.DRNlinea = DRNomina.DRNlinea
			</cfquery>	
	
			<cfquery  name="DELETE_DRIncidencias" datasource="#arguments.conexion#">
				delete from DRIncidencias  
				from DRNomina
				where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ERNid#">
				and DRIncidencias.DRNlinea = DRNomina.DRNlinea
			</cfquery>	
			
			<cfquery  name="DELETE_DRNomina" datasource="#arguments.conexion#">
				delete from DRNomina where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ERNid#">
			</cfquery>	
			
			<cfquery  name="DELETE_ERNomina" datasource="#arguments.conexion#">
				delete from ERNomina  where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ERNid#">
			</cfquery>
			<cfset estutus = 0 >
		</cftransaction>
		<cfreturn estutus >   <!---  0 Es correcto el proceso  -1 con errores--->
	</cffunction>
</cfcomponent>