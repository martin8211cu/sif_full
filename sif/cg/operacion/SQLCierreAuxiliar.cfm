<cfset Request.debug = false> 
<cfset LvarTerminado = false>
<cfset LvarVerifica = 0>
<cfset LvarMensaje = "">
<cfset LvarLvarDetail = "">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Procesando Cierre de Mes" 
returnvariable="LB_Titulo" xmlfile="SQLCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mensaje" default="Un momento por favor.... Realizando el Cierre de Mes de Auxiliares...." returnvariable="LB_Mensaje" xmlfile="SQLCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mensaje1" default="No se ha realizado el Cierre de Auxiliares" returnvariable="LB_Mensaje1" xmlfile="SQLCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mensaje2" default="Por favor Verifique el proceso de cierre" returnvariable="LB_Mensaje2" xmlfile="SQLCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mensaje3" default="Se está Procesando otro proceso de Cierre" returnvariable="LB_Mensaje3" xmlfile="SQLCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mensaje4" default="Por Favor Espere" 
returnvariable="LB_Mensaje4" xmlfile="SQLCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mensaje5" default="Hora del Proceso de Cierre" 
returnvariable="LB_Mensaje5" xmlfile="SQLCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mensaje6" default="Hora Actual" 
returnvariable="LB_Mensaje6" xmlfile="SQLCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mensaje7a" default="Existen " 
returnvariable="LB_Mensaje7a" xmlfile="SQLCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mensaje7b" default="documentos en  proceso de concili&oacute;n" 
returnvariable="LB_Mensaje7b" xmlfile="SQLCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mensaje8" default="Por Favor complete el proceso antes de continuar con el Cierre de Auxiliares" returnvariable="LB_Mensaje8" xmlfile="SQLCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CierreExitoso" default="Cierre de Auxiliares Finalizado Exitosamente" returnvariable="LB_CierreExitoso" xmlfile="formCierreMes.xml"/>

<html><head><title="#LB_Titulo#..."></title></head>
<body>
<p><center>
<img src="/cfmx/sif/imagenes/esperese.gif" alt="#LB_Mensaje#" width="320" height="90" border="0">
</center></p>

<cfif isdefined("url.btnTCH")>
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select Pvalor
		  from Parametros
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   and Pcodigo = 50
	</cfquery>
	<cfset LvarPerAux = rsSQL.Pvalor>
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select Pvalor
		  from Parametros
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   and Pcodigo = 60
	</cfquery>
	<cfset LvarMesAux = rsSQL.Pvalor>
	<cfset LvarFecha  = createDate(LvarPerAux,LvarMesAux,1)>
	<cfset LvarFecha  = createDate(LvarPerAux,LvarMesAux,DaysInMonth(LvarFecha))>
	<cfquery datasource="#Session.DSN#">
		delete from TipoCambioEmpresa
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPerAux#">
		   and Mes = <cfqueryparam cfsqltype="cf_sql_integer" 	  value="#LvarMesAux#">
		   and (TCEtipocambio=0 OR TCEtipocambioventa = 0)
	</cfquery>
	<cfquery name="ABC_CierreAuxiliar1" datasource="#Session.DSN#">
		insert into TipoCambioEmpresa (Ecodigo, Periodo, Mes, Mcodigo, TCEtipocambio, TCEtipocambioventa, TCEtipocambioprom)
		select Ecodigo, #LvarPerAux#, #LvarMesAux#, Mcodigo, TCcompra, TCventa, coalesce(TCpromedio, (TCcompra+TCventa)/2)
		  from Htipocambio tc
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   and Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">
		   and Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">
		   and (
		   		select count(1)
				  from TipoCambioEmpresa
				 where Ecodigo	= tc.Ecodigo
				   and Periodo	= #LvarPerAux#
				   and Mes		= #LvarMesAux#
				   and Mcodigo	= tc.Mcodigo
				) = 0
	</cfquery>
    
	<cflocation url="CierreAuxiliar.cfm?_">
</cfif>

<cfflush interval="32">
<cfif isdefined("Form.btnCierre")>
	<cflock name="LockCierreMes" type="exclusive" timeout="20" throwontimeout="no">
		<cfif not isdefined("application.LockCierreMes")>
			<cfset application.LockCierreMes = 0>
			<cfset application.LockCierreMesHora = dateadd("m", -1, now())>
		</cfif>
		<cfif application.LockCierreMes eq 1 and datediff('n', application.lockCierreMesHora, now()) LT 60>
			<cfset LvarVerifica = -1>
		<cfelse>
			<cfset application.LockCierreMes = 1>
			<cfset application.LockCierreMesHora = now()>
		</cfif>
	</cflock>

	<cfif LvarVerifica eq 0>
		<cfset LvarVerifica = fnVerificaDocumentos()>
	</cfif>

</cfif>

<form action="/cfmx/home/menu/modulo.cfm?s=SIF&m=CG" method="post" name="sql">
  <cfif isdefined("showMessage")>
		<cfinvoke component="home.Componentes.Notifier" method="insertFlashMeesage"
			message="#LB_CierreExitoso#"
			type="sucess"
			closeOnClick="true">
		</cfinvoke>
		<input name="showMessage" type="hidden" value="true">
    <input name="showMessage" type="hidden" value="true">
  </cfif>
  <input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
</form>

<cfif LvarVerifica EQ 0>
	<cfset LvarTerminado = fnProcesaCierreMes()>
</cfif>

<cfif LvarVerifica GTE 0>
	<cflock name="LockCierreMes" type="exclusive" timeout="20" throwontimeout="no">
		<cfset application.LockCierreMes = 0>
	</cflock>
</cfif>

<cfif LvarTerminado>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
<cfelseif LvarVerifica EQ 0>
	<p align="center"><cfoutput>#LB_Mensaje1#</cfoutput>! </p>
	<p align="center"><cfoutput>#LB_Mensaje2#</cfoutput>! </p>
	<p align="center"> <strong><cfoutput>#LVarMensaje#</cfoutput></strong></p>
	<p align="center"> <strong><cfoutput>#LVarDetail#</cfoutput></strong></p>
<cfelseif LVarVerifica EQ -1>
	<cfoutput>
	<p align="center">#LB_Mensaje3#! </p>
	<p align="center">#LB_Mensaje4#! </p>
	<p align="center">#LB_Mensaje5#: #application.LockCierreMesHora# #LB_Mensaje6#: #now()#</cfoutput></p>
<cfelse>
	<p align="center"> <cfoutput>#LB_Mensaje7a# #LvarVerifica# #LB_Mensaje7a#! </p>
	<p align="center"> #LB_Mensaje8#! </cfoutput></p>
</cfif>
</body></HTML>

<cffunction name="fnVerificaDocumentos" access="private" output="no" returntype="numeric">

    <cfquery name="rsVerificaConciliacion" datasource="#session.dsn#">
        select count(1) as Cantidad
        from EAadquisicion
        where Ecodigo  = #session.Ecodigo#
        and EAstatus = -1                                                 
    </cfquery>

    <cfif rsVerificaConciliacion.Cantidad GT 0>
        <cfreturn rsVerificaConciliacion.Cantidad>
    </cfif> 

    <cftransaction>
        <cfquery name="ABC_CierreAuxiliar1" datasource="#Session.DSN#">
            delete from TipoCambioEmpresa
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.anno#">
            and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.mes#">
        </cfquery>
    
		<cfif isdefined("Form.MON") and isdefined("Form.TC")>
			<cfset monedas  = ListtoArray(Form.MON)>
            <cfset cambio   = ListtoArray(Form.TC)>
            <cfset venta    = ListtoArray(Form.TCcambioventa)>
            <cfset promedio = ListtoArray(Form.TCcambioprom)>
            <cfloop index="i" from="1" to="#ArrayLen(monedas)#">
                <cfquery name="ABC_CierreAuxiliar2" datasource="#Session.DSN#">
                    insert INTO TipoCambioEmpresa (Ecodigo,Mcodigo,Periodo,Mes,TCEtipocambio,TCEtipocambioventa,TCEtipocambioprom)
                    values ( 
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#monedas[i]#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.anno#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.mes#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#replace(cambio[i],',','','all')#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#replace(venta[i],',','','all')#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#replace(promedio[i],',','','all')#"> 
                        )
                </cfquery>
            </cfloop>
        </cfif>
        
        <cfif Request.debug>
            <cftransaction action="rollback"/>
            <cfabort>
        </cfif>
    </cftransaction>
	<cfreturn 0>
</cffunction>

<cffunction name="fnProcesaCierreMes" access="private" output="no" returntype="any">
    <!---  Cierre de Auxiliares --->
	<cftry>
        <cfinvoke component="sif.Componentes.CG_CierreAuxiliares" method="CierreAuxiliares"
          Ecodigo="#Session.Ecodigo#"
          conexion="#session.dsn#"
          debug="#Request.debug#"/>
		<cfcatch type="any">
			<cfset LvarMensaje = cfcatch.message>
            <cfset LvarDetail  = cfcatch.Detail>
			<cfif isdefined("cfcatch.TagContext")>
				<cfset LvarError = "<BR>" & cfcatch.TagContext[1].Template & ": " & cfcatch.TagContext[1].Line & "<BR>">
				<cfif find(expandPath("/"),LvarError)>
					<cfset LvarError = mid(LvarError,find(expandPath("/"),LvarError),1000)>
					<cfset LvarError = Replace(LvarError,expandPath("/"),"CFMX/")>
					<cfset LvarError = REReplace(LvarError,"[/\\]","/ ","ALL")>
				</cfif>
            	<cfset LvarDetail  = LvarDetail & '  ' & LvarError>
			</cfif>
            <cfif isdefined('cfcatch.Sql')>
            	<cfset LvarDetail  = LvarDetail & '  ' & cfcatch.sql>
            </cfif>
            <cflock name="LockCierreMes" type="exclusive" timeout="20" throwontimeout="no">
                <cfset application.LockCierreMes = 0>
            </cflock>
        	<cfreturn false>
        </cfcatch>      
    </cftry>

	<!--- 
		Actualiza el parámetro en 2, para que el componente de procesamiento
		mande a ejecutar las transacciones en cola.
	--->
	<cfquery datasource="#Session.DSN#">
        UPDATE Parametros 
        set Pvalor = '2'
        where Pcodigo=970 
          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">	
          and Pvalor = '1'
	</cfquery>

	<!--- Llama al componente de procesamiento de la cola --->
	<cfinvoke
		component="sif.Componentes.AF_ControldeCola"
		method="ProcesarCola">
		<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
		<cfinvokeargument name="DSN" value="#session.dsn#"/>
		<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#"/>
	</cfinvoke>
	
  <cfset showMessage="true">
  <cfreturn true>
</cffunction>
