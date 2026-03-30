<cfcomponent>
	<cffunction name='VALIDA_CXP' access='public' output='true' > 
		<cfargument name='Ecodigo' type='numeric' required='true'>		
		<cfargument name='debug' type="boolean" required='false' default='false'>
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		<cfargument name='periodo' type='numeric' required='yes'>
		<cfargument name='mes' type='numeric' required='yes'>
		
		<!--- Validaciones de CxP --->
		
		<!--- Parámetros Generales --->
		<cfset lin = 1>
		<cfset Periodo = -1>
		<cfset Mes = -1>				
		<cfset Fecha = Now()>		
		<cfset descripcion = 'CxP: Diferencial Cambiario Mensual'>		
		<cfset Ocodigo = 0>
		<cfset DescMoneda = ''>		
		<cfset Monloc = 0>		
		<cfset descerror = ''>		
		<cfset error = 0>	
		
		<cfquery name="rs_Monloc" datasource="#arguments.conexion#">
			select Mcodigo 
			from Empresas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>

		<cfif isdefined('rs_Monloc') and rs_Monloc.recordCount GT 0 and rs_Monloc.Mcodigo NEQ ''>
			<cfset Monloc = rs_Monloc.Mcodigo>
		</cfif>

		<cfquery name="rs_Periodo" datasource="#arguments.conexion#">
			select <cf_dbfunction name="to_number" datasource="#arguments.conexion#" args="Pvalor"> as Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Mcodigo = 'GN'
			  and Pcodigo = 50
		</cfquery>
		
		<cfif isdefined('rs_Periodo') and rs_Periodo.recordCount GT 0 and rs_Periodo.Pvalor NEQ ''>
			<cfset Periodo = rs_Periodo.Pvalor>
		</cfif>

		<cfquery name="rs_Mes" datasource="#arguments.conexion#">
			Select <cf_dbfunction name="to_number" datasource="#arguments.conexion#" args="Pvalor"> as Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
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
		
		
		<cfquery name="rsValidaDocsABorrar" datasource="#arguments.conexion#">
			select d.Ecodigo, d.CPTcodigo, d.Ddocumento
			from EDocumentosCP d
			where d.Ecodigo = #arguments.Ecodigo#
			  and d.EDsaldo = 0.00
			  and exists(
				select 1
				from EAplicacionCP ef
				where ef.ID         = d.IDdocumento
				  )
		</cfquery>
		<cfif rsValidaDocsABorrar.recordcount gt 0>
			<cf_errorCode	code = "51089" msg = "Existen documentos sin aplicar que hacen referencia a una Aplicación de Documentos a Favor (CxP)">
		</cfif>	
	</cffunction>
	
	<cffunction name='VALIDA_REMISIONES' access='public' output='true' > 
		<cfargument name='Ecodigo' type='numeric' required='true'>		
		<cfargument name='debug' type="boolean" required='false' default='false'>
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		<cfargument name='periodo' type='numeric' required='yes'>
		<cfargument name='mes' type='numeric' required='yes'>

    <!--- Parámetros Generales --->
		<cfset lin = 1>
		<cfset Periodo = -1>
		<cfset Mes = -1>				
		<cfset Fecha = Now()>		
		<cfset descripcion = 'Remisiones: Diferencial Cambiario Mensual'>		
		<cfset Ocodigo = 0>
		<cfset DescMoneda = ''>		
		<cfset Monloc = 0>		
		<cfset descerror = ''>		
		<cfset error = 0>	
		
		<cfquery name="rs_Monloc" datasource="#arguments.conexion#">
			select Mcodigo 
			from Empresas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>

		<cfif isdefined('rs_Monloc') and rs_Monloc.recordCount GT 0 and rs_Monloc.Mcodigo NEQ ''>
			<cfset Monloc = rs_Monloc.Mcodigo>
		</cfif>

		<cfquery name="rs_Periodo" datasource="#arguments.conexion#">
			select <cf_dbfunction name="to_number" datasource="#arguments.conexion#" args="Pvalor"> as Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Mcodigo = 'GN'
			  and Pcodigo = 50
		</cfquery>
		
		<cfif isdefined('rs_Periodo') and rs_Periodo.recordCount GT 0 and rs_Periodo.Pvalor NEQ ''>
			<cfset Periodo = rs_Periodo.Pvalor>
		</cfif>

		<cfquery name="rs_Mes" datasource="#arguments.conexion#">
			Select <cf_dbfunction name="to_number" datasource="#arguments.conexion#" args="Pvalor"> as Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Mcodigo = 'GN'
			  and Pcodigo = 60
		</cfquery>
		
		<cfif isdefined('rs_Mes') and rs_Mes.recordCount GT 0 and rs_Mes.Pvalor NEQ ''>
			<cfset Mes = rs_Mes.Pvalor>
		</cfif>	

		<!--- VALIDACIONES --->
		<cfif Periodo EQ -1 and Mes EQ -1>
			<cf_errorCode	code = "52090" msg = "No se ha definido el parámetro de Período o Mes para los sistemas Auxiliares! Proceso Cancelado !">
		</cfif>
	
    <cfquery name="rsValidaRemisiones" datasource="#arguments.conexion#">
			select * from EDocumentosCPR
      where CPTcodigo = 'RM' and EVestado = 0
			and Ecodigo = #arguments.Ecodigo#
			and MONTH(EDfecha) = #Mes#
		</cfquery>
		<cfif rsValidaRemisiones.recordcount gt 0>
			<cf_errorCode	code = "52091" msg = "Existen documentos de remision sin aplicar">
		</cfif>	

		<cfquery name="rsValidaRemisionesDev" datasource="#arguments.conexion#">
			select * from EDocumentosCPR
      where CPTcodigo = 'DR' and EVestado = 0
			and Ecodigo = #arguments.Ecodigo#
			and MONTH(EDfecha) = #Mes#
		</cfquery>
		<cfif rsValidaRemisionesDev.recordcount gt 0>
			<cf_errorCode	code = "52092" msg = "Existen documentos de devolución de remision sin aplicar">
		</cfif>	

	</cffunction>
	
	<cffunction name='VALIDA_CXC' access='public' output='true'>
		<cfargument name='Ecodigo' type='numeric' required='true'>		
		<cfargument name='debug' type="boolean" required='false' default='false'>
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">

			<!--- Validaciones de CxC para que no se disparen en el componente --->
			<!--- Parametros para los periodos de vencimiento --->

			<cfquery name="rsParametros" datasource="#arguments.conexion#">
				select Pvalor as p1
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and Pcodigo = 310
			</cfquery>

			<cfif not isdefined("rsParametros") or rsParametros.recordcount eq 0>
				<cf_errorCode	code = "50178" msg = "Debe definir el primer período en los parámetros.">
			</cfif>
			
			<cfquery name="rsParametros" datasource="#arguments.conexion#">
				select Pvalor as p2
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and Pcodigo = 320
			</cfquery>
		
			<cfif not isdefined("rsParametros") or rsParametros.recordcount eq 0>
				<cf_errorCode	code = "50179" msg = "Debe definir el segundo período en los parámetros.">
			</cfif>
			
			<cfquery name="rsParametros" datasource="#arguments.conexion#">
				select Pvalor as p3
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and Pcodigo = 330
			</cfquery>

			<cfif not isdefined("rsParametros") or rsParametros.recordcount eq 0>
				<cf_errorCode	code = "50180" msg = "Debe definir el tercer período en los parámetros.">
			</cfif>

			<cfquery name="rsParametros" datasource="#arguments.conexion#">
				select Pvalor as p4
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and Pcodigo = 340
			</cfquery>
			<cfif not isdefined("rsParametros") or rsParametros.recordcount eq 0>
				<cf_errorCode	code = "50181" msg = "Debe definir el cuarto período en los parámetros.">
			</cfif>
			<!---JARR 13ENERO 2020 Borra Documentos con saldo 0 ---->
			<cfquery datasource="#arguments.conexion#">
				delete ef from EFavor ef
				where ef.Ecodigo = #arguments.Ecodigo#
				       and exists(
				                    select d.Ecodigo, d.CCTcodigo, d.Ddocumento
				                           from Documentos d
				                           where ef.Ecodigo    = d.Ecodigo
				                                    and ef.CCTcodigo  = d.CCTcodigo
				                                    and ef.Ddocumento = d.Ddocumento
				                                    and d.Dsaldo = 0.00
				       )
			</cfquery>



			<cfquery name="rsValidaDocsABorrar" datasource="#arguments.conexion#">
				select d.Ecodigo, d.CCTcodigo, d.Ddocumento
				from Documentos d
				where d.Ecodigo = #arguments.Ecodigo#
				  and d.Dsaldo = 0.00
				  and exists(
				  	select 1
					from EFavor ef
					where ef.Ecodigo    = d.Ecodigo
					  and ef.CCTcodigo  = d.CCTcodigo
					  and ef.Ddocumento = d.Ddocumento
					  )
			</cfquery>
			<cfif rsValidaDocsABorrar.recordcount gt 0>
				<cf_errorCode	code = "51090" msg = "Existen documentos sin aplicar que hacen referencia a una Aplicación de Documentos a Favor (Encabezado) (CxC)">
			</cfif>	

			<cfquery name="rsValidaDocsABorrar" datasource="#arguments.conexion#">
				select d.Ecodigo, d.CCTcodigo, d.Ddocumento
				from Documentos d
				where d.Ecodigo = #arguments.Ecodigo#
				  and d.Dsaldo = 0.00
				  and exists(
				  	select 1
					from DFavor ef
					where ef.Ecodigo     = d.Ecodigo
					  and ef.CCTRcodigo  = d.CCTcodigo
					  and ef.DRdocumento = d.Ddocumento
					  )
			</cfquery>
			<cfif rsValidaDocsABorrar.recordcount gt 0>
				<cf_errorCode	code = "51091" msg = "Existen documentos sin aplicar que hacen referencia a una Aplicación de Documentos a Favor (Detalles) (CxC)">
			</cfif>	
			<!--- Fin de Validaciones de CxC --->
	</cffunction>	
	
	<cffunction name='VALIDA_AF' access='public' output='true'>
		<cfargument name='Ecodigo' type='numeric' required='true'>		
		<cfargument name='debug' type="boolean" required='false' default='false'>
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		<cfargument name='periodo' type='numeric' required='yes'>
		<cfargument name='mes' type='numeric' required='yes'>
		
			<!--- Valida que no existan transacciones (depreciacion, revaluacion , mejora, retiro) sin aplicar--->
			<cfquery name="rsVerifica" datasource="#arguments.conexion#">
				select count(1) as Cantidad
				from AGTProceso 
				where AGTProceso.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				and AGTProceso.AGTPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodo#">
				and AGTProceso.AGTPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
				and AGTPestadp < 4
				and (select count(1) from ADTProceso b where AGTProceso.AGTPid = b.AGTPid) > 0
			</cfquery>
	
			<cfif rsVerifica.recordcount gt 0 and rsVerifica.Cantidad GT 0>
				<cf_errorCode	code = "51092" msg = "Existen transacciones de Activos Fijos, para este Periodo Mes, sin Aplicar!, Proceso Cancelado!">
			</cfif>
	</cffunction>
    
    <cffunction name='VALIDA_MB' access='public' output='true'>
		<cfargument name='Ecodigo' type='numeric' required='true'>		
		<cfargument name='debug' type="boolean" required='false' default='false'>
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
        
       <!--- SML. Modificacion para obtener solo movimientos del mes de auxiliares en curso--->
        <cfquery name="rs_Mes" datasource="#arguments.conexion#">
			Select <cf_dbfunction name="to_number" datasource="#arguments.conexion#" args="Pvalor"> as Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Mcodigo = 'GN'
			  and Pcodigo = 60
		</cfquery>
	
		<!--- Valida que no existan transacciones Bancarias sin aplicar--->
		<cfquery name="rsVerifica" datasource="#arguments.conexion#">
			select count(1) as Cantidad
			from EMovimientos  
			where Ecodigo = #arguments.Ecodigo#
            	and month(EMfecha) = #rs_Mes.Pvalor#
		</cfquery>
	
		<cfif rsVerifica.recordcount gt 0 and rsVerifica.Cantidad GT 0>
			<cfthrow message="Existen transacciones de Bancos, sin Aplicar!, Proceso Cancelado!">
		</cfif>
	</cffunction>	

</cfcomponent>


