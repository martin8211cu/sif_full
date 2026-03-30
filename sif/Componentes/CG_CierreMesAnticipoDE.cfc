<cfcomponent output="no">

	<!--- Funcion almacena los anticipos pagados en 'x' periodo por medio de tesoreria --->
	<cffunction name="DetalleanticipoEmpleadoFinalizado" access='public' output='no'>
		<cfargument name='Ecodigo' type='numeric' required='true'>		
		<cfargument name='debug' type="boolean" required='false' default='false'>	
		
		<cfquery name="rs_Periodo" datasource="#Session.DSN#">
			select Pvalor as Pvalor
			from Parametros
			where Ecodigo = #arguments.Ecodigo#
			and Mcodigo = 'GN'
			and Pcodigo = 50
		</cfquery>

		<cfif isdefined('rs_Periodo') and rs_Periodo.recordCount GT 0 and rs_Periodo.Pvalor NEQ ''>
			<cfset Periodo = rs_Periodo.Pvalor>
		</cfif>

		<cfquery name="rs_Mes" datasource="#Session.DSN#">
			Select Pvalor as Pvalor
			from Parametros
			where Ecodigo = #arguments.Ecodigo#
			and Mcodigo = 'GN'
			and Pcodigo = 60
		</cfquery>

		<cfif isdefined('rs_Mes') and rs_Mes.recordCount GT 0 and rs_Mes.Pvalor NEQ ''>
			<cfset Mes = rs_Mes.Pvalor>
		</cfif>				

		<!---  1) Validaciones Generales --->
		<cfif Periodo EQ -1 and Mes EQ -1>
			<cf_errorCode	code = "51088" msg = "No se ha definido el parámetro de Período o Mes para los sistemas Auxiliares! Proceso Cancelado !">
		</cfif>
		
		<cfquery datasource="#session.dsn#" name="rsDatosConf">
			Select 
				CCHCdiasvencAnti,
				CCHCdiasvencAntiViat
			from 
				CCHconfig
			where Ecodigo = #session.Ecodigo#
		</cfquery>
				
		<!--- insertar anticipos pagados pero no liquidados --->
		<cfquery name="rsInsertAnticipo" datasource="#Session.DSN#">
			INSERT INTO GEanticipoDetEmpleado
			(GEAid, GEDEnsolicitud, GEDEidempleado, GEDEidmoneda, GEDEmontototal, GEDEperiodo, GEDEmes, Ecodigo)		
			SELECT DISTINCT a.GEAid, a.GEAnumero, a.TESBid, a.Mcodigo, a.GEAtotalOri, #Periodo#, #Mes#, #arguments.Ecodigo#
			from GEanticipo a
			where a.Ecodigo = #session.Ecodigo#
				and GEAestado =4 <!--- in (2,4)  aprobada y pagada --->   		    
		  	    and coalesce(a.TESSPid,0) <> 0 
		        and coalesce(a.CCHid,0) = 0 
				and (	<!----- Cuando todavia existan detalles que no estan por liquidar: cantidadXliquidar < cantidadAnticipoD--->
						(
							select count(1)
							  from GEliquidacionAnts d
								inner join GEliquidacion e
								 on e.GELid 		= d.GELid
								and e.GELestado 	in (2,4,5)
							 where d.GEAid = a.GEAid
						) <
						(
							select count(1)
							  from GEanticipoDet f
							 where f.GEAid = a.GEAid
							   and f.GEADmonto - f.GEADutilizado - f.TESDPaprobadopendiente > 0
						) 
				)		 
		
			
		</cfquery>		
		<!--- Agregar liquidaciones pendientes en cierre de mes --->
		<cfquery name="rsInsertLiquidacion" datasource="#Session.DSN#">
			INSERT INTO GEanticipoDetEmpleado
				(GELid, GEDEnsolicitud, GEDEidempleado, GEDEidmoneda, GEDEmontototal, GEDEperiodo, GEDEmes, Ecodigo, GEDEreembolso)
			
			SELECT  l.GELid, l.GELnumero, l.TESBid, l.Mcodigo, l.GELtotalGastos,#Periodo#, #Mes#,#arguments.Ecodigo#, l.GELreembolso
			FROM GEliquidacion l inner join TESsolicitudPago  sp on sp.TESSPid = l.TESSPid_Adicional
			WHERE 
				Ecodigo = #arguments.Ecodigo#
				AND l.GELestado in (2,  4, 5)
				AND l.TESSPid_Adicional IS NOT NULL
				AND sp.TESSPestado IN (2, 10)
		
		</cfquery>
	
	<!--- fin de la funcion DetalleanticipoEmpleadoFinalizado --->
	</cffunction>


<!--- fin del componente --->
</cfcomponent>