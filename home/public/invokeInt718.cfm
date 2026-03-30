<cfsetting requesttimeout="1800">
<cfapplication name="SIF_ASP" sessionmanagement="Yes" clientmanagement="No" setclientcookies="Yes" sessiontimeout="#CreateTimeSpan(0,10,0,0)#">
<cfset res = setLocale("English (Canadian)")>
<cfheader name="Expires" value="0">
<cfheader name="Cache-control" value="no-cache">
<cfparam name="Session.Idioma" default="es_CR">

<cfset GvarUsuario = 'bmora'>


<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
INICIO de la interfaz 718.<br />
<cfflush interval="10">

<cfquery name="rsDatos" datasource="minisif" maxrows="500">
	select 
    (select SNnumero from SNegocios sn where sn.SNcodigo = a.SNcodigo and sn.Ecodigo = a.Ecodigo) as SNnumero ,
     b.* 
    	from Pagos a 
    	inner join DPagos b
        on a.Ecodigo = b.Ecodigo
        and a.CCTcodigo=b.CCTcodigo
        and a.Pcodigo= b.Pcodigo
    where a.Pcodigo = '49'
</cfquery>



<!---<cfloop query="rsDatos">
	 Procesando <cfoutput>#rsDatos.Nombre#</cfoutput><br />--->
	<cfset LvarProcesar = true>
    
   
	<cfset LvarID = LobjColaProcesos.fnSiguienteIdProceso()>
        
   <cftransaction>
    <cfquery datasource="sifinterfaces">
        insert into IE718 (
            ID,
            IndContado,
            Ecodigo,
            CCTcodigo,
            Ddocumento,
            Miso4217,
            Dfecha,
            AliasRol,
            Subtotal,
            Total,
           <!--- FAM01COD,
            FAX01NTR,--->
            Dvencimiento,
            SNcodigoext,
            SecCom
			)
            values (
        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarID#">,
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="N">,
        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDatos.Ecodigo#">,
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsDatos.Doc_CCTcodigo#">,
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsDatos.Ddocumento#">,
        'CRC',
        '2013/12/12',
        'GarnierBBDO',
        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDatos.DPtotal#">,
        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDatos.DPtotal#">,
        '2014/12/12',
		'554',<!---este salio del panzoti campo sncodigoexterno--->
        1
                    )
	</cfquery>
	


<!---        <FAX01ESIS>Prueba = &quot;</FAX01ESIS>
        <FAX01ENUMDOC>Prueba </FAX01ENUMDOC>
        <FAX04ELIN>-1234567890</FAX04ELIN>--->

    <!---Se inserta las cuentas por cobrar como excepciones --->
    <cfquery datasource="sifinterfaces">
        insert into ID718 (ID,IDD,SecCom,Subtotal,Total,codEmpresa,codProducto,codSeccion) 
         select 
        	 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarID#">,
             1,
             1,
            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDatos.DPtotal#">,
            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDatos.DPtotal#">,
            '24',
            '24',
            'DEPO'            
         from dual
           
    </cfquery>
    
    	<cfset LvarMSG = LobjColaProcesos.fnProcesoNuevoExterno (718, LvarID, GvarUsuario)>
		<cfif LvarMSG NEQ "OK">
			<cfthrow message="#LvarMSG#">
		</cfif>

	</cftransaction>



<cfoutput>
FIN de  ID:#LvarID#
</cfoutput>
