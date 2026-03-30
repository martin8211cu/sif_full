<!---  
	Aplica los asientos contables importados:

	Debe ejecutar nocturno en las instalaciones que lo requieran asi

--->
<cfsetting requesttimeout="3600">
<cfset LvarDetener = true>
<cfoutput>  Inicio del Proceso #now()# <br /> </cfoutput>
<cfflush interval="12">
<cflock scope="application" timeout="1" type="readonly" throwontimeout="no">
	<cfif not isdefined("application.ImportacionEContablesBandera")>
		<cfset application.ImportacionEContablesBandera = 0>
		<cfset application.ImportacionEContablesHora = now()>
	</cfif>
	
	<cfif application.ImportacionEContablesBandera eq 0 or datediff("n", application.ImportacionEContablesHora, now()) gt 90>
		<cfset LvarDetener = false>
		<cfset application.ImportacionEContablesBandera = 1>
		<cfset application.ImportacionEContablesHora = now()>
	</cfif>
</cflock>

<cfif LvarDetener>
	<cfoutput>  Proceso detenido! Revisar los atributos en el scope application #application.ImportacionEContablesBandera#  #application.ImportacionEContablesHora#<br /> </cfoutput>
	<cfabort>
</cfif>
<cfoutput>  inicia el ciclo! Procesando los asientos importados <br /> </cfoutput>

<cfoutput>inicia proceso de traslado de asientos : #Now()#<br></cfoutput>
<cfflush interval="32">
<cftransaction isolation="read_uncommitted">
    <cfquery name="rs_Caches" datasource="asp">
        select distinct e.Cid, c.Ccache
        from Empresa e
            inner join Caches c
            on c.Cid = e.Cid
        where exists(
            select 1
            from ModulosCuentaE me
            where me.SScodigo = 'SIF'
              and me.SMcodigo = 'CG'
              and me.CEcodigo = e.CEcodigo
            )
    </cfquery>
</cftransaction> 

<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo">
	<cfinvokeargument name="refresh" value="no">
</cfinvoke>
<cfif not isdefined("session.usuario")>
	<cfset session.usuario = 1>
</cfif>
<cfif not isdefined("session.Usulogin")>
	<cfset session.Usulogin ="automatico">
</cfif>
<cfloop query="rs_Caches">
	<cfset LvarConexion = rs_Caches.Ccache>
	<cfset session.dsn = LvarConexion>
	<cfoutput> #Lvarconexion# .....................................<br /> </cfoutput>
	<cfif StructKeyExists(Application.dsinfo, Lvarconexion)>
	    <cfset session.DSinfo = Application.DSinfo['#lvarConexion#']>
		<cfset LvarfnProcesaAsientos = fnProcesaAsientos(LvarConexion)>
	</cfif>
</cfloop>

<cflock scope="application" timeout="1" type="readonly" throwontimeout="no">
	<cfset application.ImportacionEContablesBandera = 0>
</cflock>
<cfoutput><br /><br /> finaliza proceso de Aplicacion de Asientos Importados : #Now()#  #application.ImportacionEContablesBandera#<br></cfoutput>

<cffunction name="fnProcesaAsientos" access="private" returntype="boolean" output="yes">
	<cfargument name="Conexion" type="string" required="yes">
	<!--- 
		Se procesan UNICAMENTE los asientos que han llegado por la interfaz que tengan al menos 10 minutos de haberse grabado 
		También, se controla que solamente se procese una vez el registro, esto en el campo ASTPorProcesar
	--->

	<cfset LvarFechaProcesamiento = dateadd("s", -600, now())>

	<cfset LvarContinuar = true>
	<cftry>
		<cftransaction isolation="read_uncommitted">
		<cfquery datasource="#Arguments.Conexion#"  name="RSDoc">
			select a.ECIid, a.Edescripcion, a.Ecodigo 
			from EContablesImportacion a
				inner join EContablesInterfaz18 b
				on b.ECIid = a.ECIid
			where b.ImpFecha < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaProcesamiento#">
			  and b.ASTPorProcesar = 1
		</cfquery>
        </cftransaction>
        <cfcatch type="any">
            <cfoutput> Se presento un problema al procesar el query. Revisar el query <br /> </cfoutput>
            <cfset LvarContinuar = false>
        </cfcatch>
    </cftry>

    <cfif LvarContinuar>
		<cfoutput>&nbsp;Por Procesar:&nbsp;#RSDoc.recordcount# Asientos Importados......</cfoutput>
        <cfloop query="RSDoc">
			<cfset LvarECIid = RSDoc.ECIid>
			<cfset LvarEdescripcion = RSDoc.Edescripcion>
	
			<cfset session.Ecodigo  = RSDoc.Ecodigo>
			<cfset session.Usucodigo = 1>
			<cfset session.Usulogin = "Automatico">
			<cfset session.sitio.ip  = " ">
			<cfoutput><br />Asiento No:#LvarECIid# ... Procesando ...! <br /></cfoutput>
	
			<!--- Se ajusta la bandera del registro para evitar que se procese más de una vez --->
			<cfquery datasource="#Arguments.Conexion#">
				update EContablesInterfaz18
				set ASTPorProcesar = 0
				where ECIid = #LvarECIid#
			</cfquery>
			<cftry>
			
				<cfinvoke component="sif.Componentes.CG_AplicaImportacionAsiento" method="CG_AplicaImportacionAsiento">
					<cfinvokeargument name="ECIid" value="#LvarECIid#">
				</cfinvoke>
				<cfcatch type="any">
					<cfoutput> 
						NO SE PUDO PROCESAR  #LvarEdescripcion#<br>
						#cfcatch.message # #cfcatch.detail#
					</cfoutput>
				</cfcatch>
			</cftry>	
		</cfloop>	
    </cfif>
    <cfreturn 1>
</cffunction>
