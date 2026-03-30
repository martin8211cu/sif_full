<cfsetting requesttimeout="1800">
<cfapplication name="SIF_ASP" sessionmanagement="Yes" clientmanagement="No" setclientcookies="Yes" sessiontimeout="#CreateTimeSpan(0,10,0,0)#">
<cfset res = setLocale("English (Canadian)")>
<cfheader name="Expires" value="0">
<cfheader name="Cache-control" value="no-cache">
<cfparam name="Session.Idioma" default="es_CR">

<cfset GvarUsuario 				    = 'nelsonb'>


<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
INICIO de la interfaz 719.<br />
<cfflush interval="10">

<cfquery name="rsDatos" datasource="minisif" maxrows="500">
	select 
    (select SNnumero from SNegocios sn where sn.SNcodigo = a.SNcodigo and sn.Ecodigo  = a.Ecodigo) as SNnumero ,
     b.* 
    	from Pagos a 
    	inner join DPagos b
        on a.Ecodigo = b.Ecodigo
        and a.CCTcodigo=b.CCTcodigo
        and a.Pcodigo= b.Pcodigo
    where a.Pcodigo = '226'
</cfquery>



<!---<cfloop query="rsDatos">
	 Procesando <cfoutput>#rsDatos.Nombre#</cfoutput><br />--->
	<cfset LvarProcesar = true>
    
   
	<cfset LvarID = LobjColaProcesos.fnSiguienteIdProceso()>
	
   <cftransaction>
    <cfquery datasource="sifinterfaces">
        insert into IE719 (
            ID,
            SecFac,
            Ddocumento,
            CCTcodigo,
            Ecodigo,
            SNnumero,
            MontoAbono,
            IndComVol,
            IndComAge,
            IndComPP,
            Estado,
            BMUsucodigo,
            TipoPago
			)
            values (
        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarID#">,
        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="1">,
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsDatos.Ddocumento#">,
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsDatos.Doc_CCTcodigo#">,
        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDatos.Ecodigo#">,
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsDatos.SNnumero#">,
       <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDatos.DPtotal#">,
       <!--- <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="338000">,--->
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="S">,
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="S">,
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="S">,
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="R">,
        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
		<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="A">
                    )
	</cfquery>
	
    <!---Se inserta las cuentas por cobrar como excepciones --->
    <cfquery datasource="sifinterfaces">
        insert into ID719 (ID,IDD,SecFac,FormaPago,MontoFP, Miso4217, Dfechaexpedido) 
         select 
        	 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarID#">,
             1,
             1,
        	<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsDatos.Doc_CCTcodigo#">,
        	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDatos.DPtotal#">,
        <!---<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="338000">,--->
			'CRC',
			 getDate()
         from dual
           
    </cfquery>
    
    	<cfset LvarMSG = LobjColaProcesos.fnProcesoNuevoExterno (719, LvarID, GvarUsuario)>
		<cfif LvarMSG NEQ "OK">
			<cfthrow message="#LvarMSG#">
		</cfif>

	</cftransaction>

<cfoutput>
FIN de  ID:#LvarID#
</cfoutput>
