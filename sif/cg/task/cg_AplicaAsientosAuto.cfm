<!---  
	Aplica los asientos contables que:
		1. Vienen de Auxiliar
		2. Corresponden al mes en proceso
		3. ECfechacreacion debe indicar que se genero hace mas de 30 minutos ( para evitar bloqueos o asientos incompletos )
		4. ECauxiliar = 'S'
		5. ECtipo = 0
		6. Eperiodo = convert(int, p1.Pvalor)
		7. Emes = convert(int, p2.Pvalor)		

	Debe ejecutar nocturno en las instalaciones que lo requieran asi

--->
<cfsetting requesttimeout="3600">
<cfset LvarDetener = true>
<cfoutput>  Inicio del Proceso #now()# <br /> </cfoutput>
<cfflush interval="12">
<cflock scope="application" timeout="1" type="readonly" throwontimeout="no">
	<cfif not isdefined("application.TrasladoEContablesBandera")>
		<cfset application.TrasladoEContablesBandera = 0>
		<cfset application.TrasladoEContablesHora = now()>
	</cfif>
	
	<cfif application.TrasladoEContablesBandera eq 0 or datediff("n", application.TrasladoEContablesHora, now()) gt 90>
		<cfset LvarDetener = false>
		<cfset application.TrasladoEContablesBandera = 1>
		<cfset application.TrasladoEContablesHora = now()>
	</cfif>
</cflock>

<cfif LvarDetener>
	<cfoutput>  Proceso detenido! Revisar los atributos en el scope application #application.TrasladoEContablesBandera#  #application.TrasladoEContablesHora#<br /> </cfoutput>
	<cfabort>
</cfif>
<cfoutput>  inicia el ciclo! <br /> </cfoutput>

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
		<cfset LvarfnProcesaAsientos = fnProcesaAsientos()>
	</cfif>
</cfloop>

<cflock scope="application" timeout="1" type="readonly" throwontimeout="no">
	<cfset application.TrasladoEContablesBandera = 0>
</cflock>
<cfoutput><br /><br /> finaliza proceso de traslado de asientos : #Now()#  #application.TrasladoEContablesBandera#<br></cfoutput>

<cffunction name="fnProcesaAsientos" access="private" returntype="boolean" output="yes">
	<!--- 
        Se procesan UNICAMENTE los asientos que han llegado generados como "auxiliar" que tengan al menos 30 minutos de haberse grabado 
        y que no sean intercompany o de meses anteriores.
    --->

    <cfset LvarFechaProcesamiento = dateadd("s", -1800, now())>
    <cfset LvarContinuar = true>
    <cftry>
        <cftransaction isolation="read_uncommitted">
            <cfquery datasource="#session.dsn#"  name="RSDoc">
                select e.IDcontable, e.Ecodigo, e.Eperiodo, e.Emes, e.ECusuario, e.ECusucodigo, e.ECipcrea, p1.Pvalor as PeriodoParam, p2.Pvalor as MesParam
                from EContables e
                    inner join Parametros p1
                    on p1.Ecodigo = e.Ecodigo
                    and p1.Pcodigo = 30
                    
                    inner join Parametros p2
                    on p2.Ecodigo = e.Ecodigo
                    and p2.Pcodigo = 40
                where e.ECfechacreacion < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaProcesamiento#">
                  and e.ECauxiliar = 'S'
                  and e.ECtipo = 0
                  and e.Eperiodo = convert(int, p1.Pvalor)
                  and e.Emes = convert(int, p2.Pvalor)
                order by e.Ecodigo, e.IDcontable
            </cfquery>
        </cftransaction>
        <cfcatch type="any">
            <cfoutput> Se presento un problema al procesar el query. Revisar el query <br /> </cfoutput>
            <cfset LvarContinuar = false>
        </cfcatch>
    </cftry>

    <cfif LvarContinuar>
        <cfloop query="RSDoc">
            <cfif RSDoc.Eperiodo EQ RSDoc.PeriodoParam and RSDoc.Emes eq RSDoc.MesParam> 
                <cfset LvarIDcontable   = RSDoc.IDcontable>
                <cfset session.Ecodigo  = RSDoc.Ecodigo>
                <cfset session.Usucodigo = RSDoc.ECusucodigo>
                <cfset session.Usulogin = "Automatico">
                <cfset session.sitio.ip  = RSDoc.ECipcrea>
                <cfoutput><br />Asiento No:#LvarIDcontable# ... Procesando ...! <br /></cfoutput>
                <cftry>
                    <cfinvoke component="sif.Componentes.CG_AplicaAsiento" method="CG_AplicaAsiento">
                        <cfinvokeargument name="IDcontable" value="#LvarIDcontable#">
                    </cfinvoke>
                <cfcatch type="any">
					<cfif cfcatch.message eq "LvarMensajeDescuadre">
                    	<cfoutput>El asiento se encuentra desbalanceado <br /></cfoutput>
                    <cfelse>
						<cfinvoke 
							 component		= "sif.Componentes.CG_AplicaAsiento"
							 method			= "fnCFcatchFuenteLinea"
							 returnvariable	= "LvarError"
							 objCFcatch		= "#cfcatch#"
						>
						<p align="left"><cfoutput>#cfcatch.Message# #cfcatch.Detail# #LvarError#</cfoutput></p>
					</cfif>
                    <cfoutput>No se Proceso el Asiento. Ver error anterior...<br /></cfoutput>
                </cfcatch>
                </cftry>
            <cfelse>
                <cfoutput>  No encontro igual periodo:  #RSDoc.EPeriodo# #RSDoc.PeriodoParam# #RSDoc.Emes# #RSDoc.MesParam#<br /></cfoutput>
            </cfif>
        </cfloop>	
    </cfif>
    <cfreturn 1>
</cffunction>
