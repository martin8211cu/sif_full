<cfsetting requesttimeout="1800">
<cfapplication name="SIF_ASP" sessionmanagement="Yes" clientmanagement="No" setclientcookies="Yes" sessiontimeout="#CreateTimeSpan(0,10,0,0)#">
<cfset res = setLocale("English (Canadian)")>
<cfheader name="Expires" value="0">
<cfheader name="Cache-control" value="no-cache">
<cfparam name="Session.Idioma" default="es_CR">

<cfset GvarUsuario 				    = 'nelsonb'>


<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
INICIO de la interfaz 750.<br />
<cfflush interval="10">


<!--- Insertar la información para probar la Interface 750 --->

	<cfset LvarProcesar = true>
    
	<cfset LvarID = LobjColaProcesos.fnSiguienteIdProceso()>

	

	<cfquery datasource="sifinterfaces">
        insert into IE750 (
            ID,
            Ecodigo,
            Ocodigo,
            SNcodigoext,
            Movimiento
			)
            values (
        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarID#">,
        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value=1>,
        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value=1>,
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="554">,
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="">
                    )

  	</cfquery>

    	<cfset LvarMSG = LobjColaProcesos.fnProcesoNuevoExterno (750, LvarID, GvarUsuario)>
		<cfif LvarMSG NEQ "OK">
			<cfthrow message="#LvarMSG#">
		</cfif>




<cfoutput>
FIN de  ID:#LvarID#
</cfoutput>


<!--- Prueba del componente de forma directa --->
<!---
<cfinvoke component="sif.Componentes.BL_PocesoBloqueo" method="AutorizacionIndicadorDisponibles" returnvariable="lvarResult">
            <cfinvokeargument name="Ocodigo"                value=1>
            <cfinvokeargument name="Cliente"                value=10020>
            <cfinvokeargument name="SNnumero"               value=554> 
            <cfinvokeargument name="Movimiento"             value=""> 
            <cfinvokeargument name="Ecodigo"                value=1> 
            <cfinvokeargument name="Conexion"               value="#session.dsn#"> 
    </cfinvoke>


<cfoutput>
	<br>
	#lvarResult#
</cfoutput>

-->



  
<!--- Viejo
<cfset LvarXML_IE = "
<resultset>
    <row>
        <Ecodigo>1</Ecodigo>
        <OCodigo>1</OCodigo>
        <Sncodigoext>554</Sncodigoext>
        <Movimiento></Movimiento>
    </row>
</resultset>">
 
<cfset LvarXML_ID = "">

<cfset LvarXML_IS = "">

<cfinvoke
	webservice="http://localhost:8500/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
	username	= "soin"
	password	= "sup3rman"
	method		= "sendToSoinXML"
	returnvariable	= "LvarXML"
	Empresa			= "soin"
	EcodigoSDC		= "2"
	Num_Interfaz	= "750"
	XML_IE			= "#LvarXML_IE#"
	XML_ID			= "#LvarXML_ID#"
	XML_IS			= "#LvarXML_IS#"
	XML_OUT 		= "0"
 >
	 
<cfoutput>
	MSG		= #LvarXML.MSG#<br>
	ID 		= #LvarXML.ID#<br>
	XML_OE 	= #LvarXML.XML_OE#<br>
	XML_OD 	= #LvarXML.XML_OD#<br>
	XML_OS 	= #LvarXML.XML_OS#<br>
</cfoutput>
 --->