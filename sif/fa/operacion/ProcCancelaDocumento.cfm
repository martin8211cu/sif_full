<!------
	Proceso de Aplicacion de cotizaciones
	Creado 4 septiembre 2008
	por ABG
------->
<cfset varControlFlujo = true>
<cfset varPosteo = false>

<cfif isdefined("form.btnCancelar_Documento")>
	<cfquery name="rsPFTcodigo" datasource="#session.DSN#">
		select CCTcodigoCan 
        from FAPreFacturaE a 
        	inner join FAPFTransacciones b
            on a.Ecodigo = b.Ecodigo
            and a.PFTcodigo = b.PFTcodigo
        where a.DdocumentoREF =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DdocumentoC#">
        and a.CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigoC#">
        and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    </cfquery>
    <cfset varCCTcodigoCan = rsPFTcodigo.CCTcodigoCan>
	<!--- Manda llamar al proceso de Cancelacion de Documentos --->
    <cfinvoke 
		component="sif.fa.operacion.CancelacionDocFact" 
		debug="false"
		CCTcodigo="#Form.CCTcodigoC#"
		CCTcodigoCan="#varCCTcodigoCan#"
		Ddocumento="#Form.DdocumentoC#"
        method="Cancelacion"
	/> 
    <!--- Guarda Registro en Bitacora de Movimientos PF --->
    <cfquery datasource="#session.DSN#">
       	insert FABitacoraMovPF (Ecodigo, IDpreFactura, DdocumentoREF, CCTcodigoREF, SNcodigoREF, 
       		FechaAplicacion, TipoMovimiento, BMUsucodigo)
        select  <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
      		a.IDprefactura,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DdocumentoC#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigoC#">,
            a.SNcodigo, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
            'C', <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
        from FAPreFacturaE a
        where a.DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DdocumentoC#">
	    and a.CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigoC#">
        and a.TipoDocumentoREF = 2
        and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">   
    </cfquery>
	<!--- Actualiza las Prefacturas MArcandolas como Pendientes y Borrando el DocREF--->
    <cfquery datasource="#session.DSN#">
    	update FAPreFacturaE
        set DdocumentoREF = null,
        CCTcodigoREF = null,
        TipoDocumentoREF = null,
        Estatus = 'P'
        where DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DdocumentoC#">
	    and CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigoC#">
        and TipoDocumentoREF = 2
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    </cfquery>
</cfif>

<cfif isdefined("form.btnCancelar")>
	<cfif (isdefined("Form.chk"))>
    	<cfset chequeados = ListToArray(Form.chk,",")>
        <cfset limiteU = ArrayLen(chequeados)>
		<cfloop from="1" to="#limiteU#" index="idx">
        	<cfset datos = ListToArray(chequeados[idx],"|")>
			<cfquery name="rsPFTcodigo" datasource="#session.DSN#">
				select CCTcodigoCan 
		        from FAPreFacturaE a 
        			inner join FAPFTransacciones b
            		on a.Ecodigo = b.Ecodigo
		            and a.PFTcodigo = b.PFTcodigo
    		    where a.DdocumentoREF =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos[1]#">
	    	    and a.CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos[2]#">
        		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    		</cfquery>
		    <cfset varCCTcodigoCan = rsPFTcodigo.CCTcodigoCan>
			<!--- Manda llamar al proceso de Cancelacion de Documentos --->
    		<cfinvoke 
				component="sif.fa.operacion.CancelacionDocFact"
				debug="false"
				CCTcodigo="#datos[2]#"
				CCTcodigoCan="#varCCTcodigoCan#"
				Ddocumento="#datos[1]#"
		        method="Cancelacion"
			/> 
	        <!--- Guarda Registro en Bitacora de Movimientos PF --->
		    <cfquery datasource="#session.DSN#">
       			insert FABitacoraMovPF (Ecodigo, IDpreFactura, DdocumentoREF, CCTcodigoREF, SNcodigoREF, 
		       		FechaAplicacion, TipoMovimiento, BMUsucodigo)
        		select  <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		      		a.IDprefactura,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos[1]#">,
        		    <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos[2]#">,
		            a.SNcodigo, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
        		    'C', <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		        from FAPreFacturaE a
        		where a.DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos[1]#">
			    and a.CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos[2]#">
        		and a.TipoDocumentoREF = 2
		        and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">   
		    </cfquery>
			<!--- Actualiza las Prefacturas MArcandolas como Pendientes y Borrando el DocREF--->
		    <cfquery datasource="#session.DSN#">
		    	update FAPreFacturaE
		        set DdocumentoREF = null,
		        CCTcodigoREF = null,
		        TipoDocumentoREF = null,
		        Estatus = 'P'
		        where DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos[1]#">
			    and CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos[2]#">
		        and TipoDocumentoREF = 2
		        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		    </cfquery>
		</cfloop>
    </cfif>
</cfif>    	

<cfif isdefined("form.DdocumentoREF") and len(trim(form.DdocumentoREF)) and isdefined("form.CCTcodigoREF") and len(trim(form.CCTcodigoREF)) and not isdefined("form.btnCancelar") and not isdefined("form.btnCancelar_Documento")>
	<cfinclude template="formCancelaDocumento.cfm">
<cfelse>
	<cfinclude template="ListaCancelaDocumento.cfm">
</cfif>


