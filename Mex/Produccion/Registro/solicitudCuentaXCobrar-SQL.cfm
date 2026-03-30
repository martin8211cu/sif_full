<!---<cfdump var="#Form#">--->

<cfquery name="rsProdOTDatos" datasource="#Session.DSN#">
    select OTcodigo, SNcodigo, OTdescripcion, OTfechaRegistro, OTfechaCompromiso, OTobservacion, OTstatus, ts_rversion  
    from Prod_OT 
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
      and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">
</cfquery>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo =  #Session.Ecodigo#  	
</cfquery>

<cfquery name="rsExisteEncab" datasource="#Session.DSN#">
    select count(1) as cantidad 
      from EDocumentosCxC 
     where Ecodigo =  #Session.Ecodigo# 
       and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
       and EDdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.OTcodigo#">
</cfquery>
<cfif rsExisteEncab.cantidad GT 0> 
    <cflocation url="../../../sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('El documento ya existe registrado en Documentos sin Aplicar!')#" >
</cfif>

<cfquery name="rsCCTransaccion" datasource="#Session.DSN#">
    select CCTtipo
    from CCTransacciones
    where Ecodigo =  #Session.Ecodigo# 
    and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
</cfquery>


<cfquery name="rsExisteEncabEnBitacora" datasource="#Session.DSN#">
    select count(1) as cantidad 
      from BMovimientos 
     where Ecodigo =  #Session.Ecodigo# 
       and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">	
       and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.OTcodigo#">
</cfquery>
<cfif rsExisteEncabEnBitacora.cantidad GT 0> 
    <cflocation url="../../../sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('El Documento ya existe en los Documentos Históricos!')#" >
</cfif>	

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Top 1 Ocodigo, Odescripcion from Oficinas 
	where Ecodigo =  #Session.Ecodigo# 
	order by Ocodigo                      
</cfquery>
<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
    select Top 1 Aid, Bdescripcion from Almacen 
    where Ecodigo =  #Session.Ecodigo# 
    order by Bdescripcion                                                                   
</cfquery>


<cfquery name="rsCuentaCaja" datasource="#Session.DSN#">
	select Pvalor as Ccuenta
	  from Parametros 
 	 where Ecodigo = #session.Ecodigo#
	   and Pcodigo = 350
</cfquery>


<cfset Form.EDtipocambio= 1>
<cfset Form.EDdescuento = 0>
<cfset Form.EDimpuesto  = 0>
<cfset Form.EDtotal   	= 0>
<cfset Form.DEobservacion 	  = "">
<cfset Form.id_direccionEnvio = "">
<cfset Form.id_direccionFact  = "">
<cfset Form.DEdiasVencimiento = 30>
<cftransaction>	
    <cfquery name="ABC_DocumentosCC" datasource="#Session.DSN#" >
        insert into EDocumentosCxC 
            (Ecodigo, CCTcodigo, EDdocumento, SNcodigo, Mcodigo, EDtipocambio, EDdescuento, EDporcdesc, 
            EDimpuesto, EDtotal, Ocodigo, Ccuenta, EDfecha, Rcodigo, EDusuario, EDselect, EDdocref, EDtref,
            EDvencimiento, DEidVendedor, DEdiasVencimiento, DEordenCompra, DEnumReclamo, DEobservacion, BMUsucodigo,
            id_direccionEnvio, id_direccionFact
            ,TESRPTCid
            ,TESRPTCietu
            )
        values (
             #Session.Ecodigo# ,
            <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">,
            <cfqueryparam cfsqltype="cf_sql_char" value="#replace(trim(Form.OTcodigo),'|','')#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProdOTDatos.SNcodigo#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedaLocal.Mcodigo#">,
            <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Form.EDtipocambio,',','','all')#">,
            <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.EDdescuento,',','','all')#">,
            0.00,
            <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.EDimpuesto,',','','all')#">,
            <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.EDtotal,',','','all')#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOficinas.Ocodigo#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaCaja.Ccuenta#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.fechaIni)#">,
            <cfif isDefined("Form.Rcodigo") and Trim(Form.Rcodigo) NEQ "-1">
                <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Rcodigo#">,
            <cfelse>
                null,
            </cfif>
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
            0,
            <cfif isDefined("Form.EDdocref") and Trim(Form.EDdocref) NEQ "">
                <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EDdocref#">,
            <cfelse>
                null,
            </cfif>										
            <cfif isDefined("Form.CCTcodigoConlis") and Trim(Form.CCTcodigoConlis) NEQ "">
                <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigoConlis#">,
            <cfelse>
                null,
            </cfif>
            
            <cfif rsCCTransaccion.CCTtipo EQ 'C'>
                <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
                null,0,null,null,
            <cfelse>
                <cfif isdefined('Form.FechaVencimiento') and LEN(trim(Form.FechaVencimiento))>
                    <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaVencimiento)#">,
                <cfelse>
                    <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
                </cfif>
              <cfif isdefined ('Form.DEid') and len(Form.DEid)>
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
               <cfelse>
               null,
               </cfif> 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEdiasVencimiento#">,
                <cfif isdefined('Form.DEordenCompra') and LEN(Form.DEordenCompra) GT 0 >
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEordenCompra#">,
                <cfelse>
                    null,
                </cfif>
                <cfif isdefined('Form.DEnumReclamo') and LEN(Form.DEnumReclamo) GT 0>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEnumReclamo#">,
                <cfelse>
                    null,
                </cfif>
            </cfif>
            
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobservacion#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
            
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_direccionEnvio#" null="#Len(Form.id_direccionEnvio) EQ 0#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_direccionFact#" null="#Len(Form.id_direccionFact) EQ 0#">
            <cfif isdefined ('form.TESRPTCid') and len(trim(form.TESRPTCid)) gt 0>
                ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">
            <cfelse>
                ,null
            </cfif>
            <cfif rsCCTransaccion.CCTtipo EQ 'C'>	<!--- 1=Documento Normal DB, 0=Documento Contrario CR --->
            ,0
            <cfelse>				
            ,1
            </cfif>
            )
        <cf_dbidentity1 datasource="#session.DSN#">
    </cfquery>
    <cf_dbidentity2 datasource="#session.DSN#" name="ABC_DocumentosCC">
    <cfset Form.EDid = ABC_DocumentosCC.identity>
</cftransaction>

<cfloop from="1" to="#form.NumArt#" index="id">
<cfset idArt = 'idArticulo#id#'>
<cfset desArt = 'descArticulo#id#'>
<cfset Form.DDdescalterna="">
<cfset cantArt = 'PTcantidad#id#'>
<cfset precioU = 'Precio#id#'>
<cfset Form.DDdesclinea 	= 0>
<cfset Form.DDporcdesclin 	= 0>
<cfset Form.DDtotallinea = #form['#cantArt#']# * #form['#precioU#']#>
<cfset form.DDtipo ="A">
<cfset Form.Icodigo="">
<cftransaction>
    <cfquery name="insertD" datasource="#Session.DSN#" >
        insert INTO DDocumentosCxC 
            (Ecodigo, EDid, Aid, Cid, DDdescripcion, DDdescalterna, Dcodigo, DDcantidad, DDpreciou, 
             DDdesclinea, DDporcdesclin, DDtotallinea, 
             DDtipo, 
             Ccuenta, 
             Alm_Aid, 
             Icodigo, 
             CFid,
             OCid,
             OCTid,
             OCIid,
             BMUsucodigo)
        values (
             #Session.Ecodigo# ,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDid#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['#idArt#']#">,
            null,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['#desArt#']#">,
            <cfif len(trim(Form.DDdescalterna)) GT 0>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescalterna#">,
            <cfelse>
                null,
            </cfif>
            
<!---            <cfif isDefined("rsCFuncional.Dcodigo") and rsCFuncional.recordcount EQ 1> 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCFuncional.Dcodigo#">,
            <cfelse>	
               null, 
            </cfif>	
---> 		null,
				
            <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form['#cantArt#'],',','','all')#">,
            <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['#precioU#'],',','','all')#">,
            <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.DDdesclinea,',','','all')#">,
            <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Form.DDporcdesclin,',','','all')#">,
            <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.DDtotallinea,',','','all')#">,

            <cfqueryparam cfsqltype="cf_sql_char" value="#mid(form.DDtipo,1,1)#">,

<!---            <cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor EQ 'N'>
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCuentas.Ccuenta#">,
            <cfelseif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor NEQ 'N'>
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaD#">,
            </cfif>
--->        null,    
            <cfif  isDefined("Form.DDtipo") and listFind("A,OV",Form.DDtipo)>
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAlmacenes.Aid#">,
            <cfelse>	
                null,
            </cfif>		
            <cfif isDefined("Form.Icodigo") and Len(Trim(Form.Icodigo)) GT 0 > 
                <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">,
            <cfelse>	
                null,
            </cfif>
<!---            <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
--->        null,    
            <cfif  isDefined("Form.DDtipo") and listFind("O,OV",Form.DDtipo)>
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCTid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OCIid#">,
            <cfelse>	
                null,
                null,
                null,
            </cfif>	
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
        ) 
        <cf_dbidentity1 datasource="#session.DSN#">
    </cfquery>
</cftransaction>
</cfloop>
