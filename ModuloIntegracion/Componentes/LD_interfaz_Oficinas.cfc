<!--- IRR: Sincronizacion de Oficinas - Sucursales a LDCOM Interfaz SIF - LD  Ver. 1.0 --->
<!--- Este componente crea  la informacion de las Oficinas  de SIF como  Sucursales en el sistema LDCOM--->


<cfcomponent extends="Interfaz_Base">
<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
	
 
	<!--- Obtiene las empresas a sincronizar --->
	<cfquery name="rsEmpresas" datasource="sifinterfaces">
		select EQUcodigoOrigen,EQUidSIF, EQUdescripcion
		from SIFLD_Equivalencia
		where CATcodigo like 'CADENA'
		and SIScodigo like 'LD'
	</cfquery>
	<cfif isdefined("rsEmpresas") and rsEmpresas.recordcount GT 0>
	<cfloop query="rsEmpresas"> <!---Abre loop empresa--->
		<!--- Obtiene el Id de empresa para la cadena --->
		<!---<cfquery name="rsEquivalencia" datasource="ldcom">
			select Emp_Id
			from Cadena
			where Cadena_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresas.EQUcodigoOrigen#">
		</cfquery>--->
		<!---<cfif len(rsEquivalencia.Emp_Id) GT 0>
			<cfset LvarEmpId = rsEquivalencia.Emp_Id>
		<cfelse>--->
			<cfset session.dsn = getConexion(rsEmpresas.EQUidSIF)>
		<!---</cfif>--->

		<!--- Extrae las oficinas --->
		<cfquery name="rsOficinas" datasource="#session.dsn#">
			select Ecodigo, Ocodigo, Odescripcion,  getdate() as fecha,  coalesce(IntfazLD,0) as IntfazLD
            from Oficinas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						
		</cfquery>
		
		<cfif isdefined("rsOficinas") and rsOficinas.recordcount GT 0 >
        
		<cfloop query="rsOficinas"> <!---Abre loop oficinas--->
       	  <cftry>
             <cfif  rsOficinas.IntfazLD EQ 0 and rsOficinas.Ocodigo GT 0 >
                <cfquery name="insSucLD" datasource="ldcom">
                    insert into INTRSucursal (Empresa_Id,Cadena_Id,Suc_Id,Suc_Nombre,Suc_Activo,Estatus_proceso,
                    Error,Sucursal_Fecha,Sucursal_Fecha_Aplicado)
                    values(
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOficinas.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOficinas.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOficinas.Ocodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOficinas.Odescripcion#">,
                    1,0,' ',  
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOficinas.fecha#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOficinas.fecha#">)
                </cfquery>		
                <cfquery name="updOfi"  datasource="#session.dsn#">
                    update Oficinas
                    set intfazLD=1
                    where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOficinas.Ecodigo#">
                    and Ocodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOficinas.Ocodigo#">
                </cfquery>
             </cfif>   
			<cfcatch type="any">
			<cfoutput>
				<table>
					<tr>
						<td>
							Error: #cfcatch.message#
						</td>
					</tr>
					<cfif isdefined("cfcatch.detail") AND len(cfcatch.detail) NEQ 0>
						<tr>
							<td>
								Detalles: #cfcatch.detail#
							</td>
						</tr>
					</cfif>
					<cfif isdefined("cfcatch.sql") AND len(cfcatch.sql) NEQ 0>
						<tr>
							<td>
								SQL: #cfcatch.sql#
							</td>
						</tr>
					</cfif>
					<cfif isdefined("cfcatch.queryError") AND len(cfcatch.queryError) NEQ 0>
						<tr>
							<td>
								QUERY ERROR: #cfcatch.queryError#
							</td>
						</tr>
					</cfif>
					<cfif isdefined("cfcatch.where") AND len(cfcatch.where) NEQ 0>
						<tr>
							<td>
								Parametros: #cfcatch.where#
							</td>
						</tr>
					</cfif>
				</table>
			</cfoutput>

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

			<cfquery datasource="sifinterfaces">
				insert into SIFLD_Errores 
				(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila,Ecodigo)
				values 
				('Sinc_Oficinas', 
				'Oficinas',
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOficinas.Ocodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
                		<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOficinas.Ecodigo#">) 
			</cfquery>
		</cfcatch>    
		</cftry>
		</cfloop> <!---Cierra loop Oficinas--->
		</cfif>

		
		
	</cfloop> <!---Cierra loop empresa--->
	</cfif>
</cffunction>
</cfcomponent>