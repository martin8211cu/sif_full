<cfcomponent>
    <cffunction  name="getDSN" returnType="string">
        <cfargument  name="Ecodigo" type="string" required="true">
        <cfquery name="rsDSN" datasource="asp">
            
        </cfquery>
        <cfreturn rsDSN.dsn>
    </cffunction>

    <cffunction  name="getSocioNegocio" returnType="query">
        <cfargument  name="Ecodigo" type="string" required="true">
        <cfargument  name="SNidentificacion" type="string" required="true">
        <cfargument  name="dsn" type="string" required="true">
        <cfquery name="rsSocioNegocio" datasource="#dsn#">
            select SNid,SNcodigo,SNnumero,SNnombre from SNegocios 
            where Ecodigo='#arguments.Ecodigo#' and SNidentificacion='#arguments.SNidentificacion#' and SNinactivo = 0
        </cfquery>
    <cfif rsSocioNegocio.RecordCount gt 0>
        <cfreturn rsSocioNegocio>
    <cfelse>
        <cfthrow type="SocioNOTFound" message="No se encontro el socio de negocio">
    </cfif>
   
    </cffunction>

    <cffunction  name="getOficina" returnType="query">
        <cfargument  name="Ecodigo" type="string" required="true">
        <cfargument  name="dsn" type="string" required="true">
        <cfquery name="rsOficina" datasource="#dsn#">
            select top 1 * from Oficinas where Ecodigo=#arguments.Ecodigo#
        </cfquery>
        <cfif rsOficina.RecordCount gt 0 >
            <cfreturn rsOficina>
        <cfelse>
            <cfthrow type="OficinaNOTFound" message="No se encontro Oficina">
        </cfif>
        
    </cffunction>

    <cffunction  name="getCuenta" returnType="query">
        <cfargument  name="Ecodigo" type="string" required="true">
        <cfargument  name="SNcodigo" type="string" required="true">
        <cfargument  name="dsn" type="string" required="true">
        <cfquery name="rsCuenta" datasource="#dsn#">
            select a.SNcuentacxp as Ccuenta, a.CFcuentaCxP as CFcuenta, b.CFdescripcion, b.CFformato
		  from SNegocios a
			inner join CFinanciera b
				on b.CFcuenta = 
					case when a.CFcuentaCxP is null 
						then (select min(CFcuenta) from CFinanciera where Ccuenta = a.SNcuentacxp)
						else a.CFcuentaCxP
					end
		 where a.Ecodigo = '#arguments.Ecodigo#'
		   and a.SNcodigo = '#arguments.SNcodigo#'
        </cfquery>
        <cfif rsCuenta.RecordCount gt 0>
            <cfreturn rsCuenta>
        <cfelse>
            <cfthrow type="CuentaNOTFound" message="No se encontro cuenta para el socio de negocio">
        </cfif>
        
    </cffunction>

    <cffunction  name="getEmpresa" returnType="query">
        <cfargument  name="Ecodigo" type="string" required="true">
        <cfargument  name="dsn" type="string" required="true">
        <cfquery name="rsEmpresa" datasource="#dsn#">
            select *
	            from Empresas
	            where Ecodigo = '#arguments.Ecodigo#'
        </cfquery>
        <cfif rsEmpresa.RecordCount gt 0 >
            <cfreturn rsEmpresa>
        <cfelse>
            <cfthrow type="EmpresaNOTFound" message="No se encontro la empresa">
        </cfif>
        
    </cffunction>
    
    <cffunction  name="getDireccion" returnType="query">
        <cfargument  name="Ecodigo" type="string" required="true">
        <cfargument  name="SNid" type="string" required="true">
        <cfargument  name="dsn" type="string" required="true">
        <cfquery name="rsDireccion" datasource="#dsn#">
            select * from SNDirecciones 
	            where Ecodigo = '#arguments.Ecodigo#' and SNid='#arguments.SNid#'
        </cfquery>
        <cfif rsDireccion.RecordCount gt 0 >
            <cfreturn rsDireccion>
        <cfelse>
            <cfthrow type="DireccionNOTFound" message="No se encontro direccion asociada al socio de negocio">
        </cfif>
        
    </cffunction>

    <cffunction name="insertDocumentoCxP">
        <cfargument  name="Ecodigo"       type="numeric" required="true">
        <cfargument  name="CPTcodigo"     type="string" required="true">
        <cfargument  name="EDdocumento"   type="string" required="true">
        <cfargument  name="Mcodigo"       type="numeric" required="true">
        <cfargument  name="SNcodigo"      type="numeric" required="true">
        <cfargument  name="Ocodigo"       type="numeric" required="true">
        <cfargument  name="Ccuenta"       type="numeric">
        <cfargument  name="id_direccion"  type="numeric">
        <cfargument  name="EDtipocambio"  type="numeric" required="true">
        <cfargument  name="EDfecha"       type="string" required="true">
        <cfargument  name="EDusuario"     type="string" required="true">
        <cfargument  name="EDselect"      type="string" required="true">
        <cfargument  name="interfaz"      type="string" required="true">
        <cfargument  name="EDvencimiento" type="string">
        <cfargument  name="TESRPTCietu"   type="numeric" required="true">
        <cfargument  name="EDAdquirir"    type="numeric" required="true">
        <cfargument  name="EDexterno"     type="numeric" required="true">
        <cfargument  name="dsn"           type="string" required="true">
        
        <cftransaction>
            <cfquery name="insertEDocCP" datasource="#dsn#">
                insert into EDocumentosCxP (Ecodigo,CPTcodigo,EDdocumento,Mcodigo,SNcodigo,Ocodigo,Ccuenta,id_direccion,EDtipocambio,EDfecha,
                                            EDusuario,EDselect,interfaz,EDvencimiento,EDfechaarribo,TESRPTCietu,EDAdquirir,EDexterno,
                                            EDimpuesto,EDporcdescuento,EDdescuento,EDtotal)
                values ( 
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.Ecodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar"   value="#arguments.CPTcodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar"   value="#arguments.EDdocumento#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.Mcodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.SNcodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.Ocodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.Ccuenta#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.id_direccion#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.EDtipocambio#">,
                         <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.EDfecha#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar"   value="#arguments.EDusuario#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.EDselect#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.interfaz#">,
                         <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.EDvencimiento#">,
                         <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.TESRPTCietu#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.EDAdquirir#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.EDexterno#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="0">,
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="0">,
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="0">,
                         <cfqueryparam cfsqltype="cf_sql_numeric"   value="0">
                       )
            </cfquery>  
        </cftransaction>
        <cfquery name="rsEDocCP" datasource="#dsn#">
            select IDdocumento,EDdocumento from EDocumentosCxP where EDdocumento='#arguments.EDdocumento#';
        </cfquery>
        <cfreturn rsEDocCP>
    </cffunction>

    <cffunction  name="insertRepoTMP">
        <cfargument  name="Ecodigo"         type="numeric" required="true">
        <cfargument  name="TimbreFiscal"    type="string">
        <cfargument  name="ID_Documento"    type="numeric" required="true">
        <cfargument  name="Documento"       type="string" required="true">
        <cfargument  name="Origen"          type="string" required="true">
        <cfargument  name="NomArchXML"      type="string" >
        <cfargument  name="TotalCFDI"       type="numeric" required="true">
        <cfargument  name="TipoComprobante" type="numeric" >
        <cfargument  name="BMUsucodigo"     type="numeric" required="true">
        <cfargument  name="Mcodigo"         type="numeric" required="true">
        <cfargument  name="TipoCambio"      type="numeric" required="true">
        <cfargument  name="dsn"             type="string" required="true">
        
        <cftransaction>
            <cfquery name="insertCERepoTMP" datasource="#dsn#">
				insert into CERepoTMP (Ecodigo,TimbreFiscal,ID_Documento,Documento,Origen,NomArchXML,TotalCFDI,TipoComprobante,BMUsucodigo,Mcodigo,TipoCambio)
				values (
                        <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.Ecodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar"   value="#arguments.TimbreFiscal#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.ID_Documento#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar"   value="#arguments.Documento#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar"   value="#arguments.Origen#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar"   value="#arguments.NomArchXML#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.TotalCFDI#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.TipoComprobante#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.BMUsucodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.Mcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.TipoCambio#">
                      )
            </cfquery>
        </cftransaction>
        <cfquery name="rsCERepoTMP" datasource="#dsn#">
            select * from CERepoTMP where ID_Documento='#arguments.ID_Documento#';
        </cfquery>
        <cfreturn rsCERepoTMP>
    </cffunction>

    <cffunction  name="getEdocumento" returnType="string">
        <cfargument  name="Ecodigo" type="string" required="true">
        <cfargument  name="code" type="string" required="true">
        <cfargument  name="date" type="string" required="true">
        <cfargument  name="dsn" type="string" required="true">
        <cfquery name="rsEdocumento" datasource="#dsn#">
			 select FORMAT (max(SUBSTRING( EDdocumento,11,4))+1 , '0000') as nextEDdocumento from EDocumentosCxP where EDdocumento like '%#arguments.code##arguments.date#%' and Ecodigo='#arguments.Ecodigo#'
        </cfquery>
        <cfreturn '#arguments.code##arguments.date##rsEdocumento.nextEDdocumento eq ''?'0001':rsEdocumento.nextEDdocumento#'>
    </cffunction>
</cfcomponent>