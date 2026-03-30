<!---

Este componente permite dale Mantenimiento a todos los documentos de responsabilidad (Activos o en transito):
FUNCIONES:

1- BajaDocTransito: Elimina Documentos de responsabilidad y los datos Variables asociados al mismo
2- AltaDocTransito: Crea un Documento de Responsabilida en modo en transito

Nota: la idea es ir sacando los procesos poco a poco a este componentes, pues se esta trabajando desde muchos lugares y en formas Distintas
--->
<cfcomponent>
	<cffunction name="BajaDocTransito" access="public">

		<cfargument name="CRDRid" type="numeric" required="true">
		<!---<cftransaction>--->
			<cfinvoke component="sif.Componentes.DatosVariables" method="BAJAVALOR">
				<cfinvokeargument name="DVTcodigoValor" value="AF">
				<cfinvokeargument name="DVVidTablaVal"  value="#Arguments.CRDRid#">
				<cfinvokeargument name="DVVidTablaSec"  value="1">
			</cfinvoke>
			<cfquery name="rs_update" datasource="#session.dsn#">
				delete from CRDocumentoResponsabilidad
				where CRDRid = #Arguments.CRDRid#
			</cfquery>
		<!---</cftransaction>--->
	</cffunction>

	<cffunction name="AltaDocTransito" access="public" returntype="numeric">
		<cfargument name="Conexion" 			type="string"  	required="false">
		<cfargument name="Ecodigo"  			type="numeric" 	required="false">
		<cfargument name="Usucodigo"  			type="numeric" 	required="false">
		<cfargument name="CRDRfalta"  			type="date"    	required="false" default="#now()#">
		<cfargument name="CRDRfdocumento"  		type="date"   	required="false" default="#now()#">
		<cfargument name="CRDRestado"  			type="numeric"  required="no" 	 default="10">
		<cfargument name="CRDRutilaux"  		type="numeric"  required="no" 	 default="0">
		
		<cfargument name="CRTDcodigo"  			type="string"	required="yes">
		<cfargument name="DEidentificacion"		type="string" 	required="yes">
		<cfargument name="Categoria"  			type="string"   required="yes">
		<cfargument name="Clase"  				type="string"   required="yes">
		<cfargument name="AFMcodigo"  			type="string"   required="yes">
		<cfargument name="AFMMcodigo"  			type="string"   required="yes">
		<cfargument name="CFcodigo"  			type="string"   required="yes">
		<cfargument name="CRDRplaca"  			type="string"   required="yes">
		<cfargument name="CRCCid"  			    type="numeric"  required="yes" default="0">
        <cfargument name="CRCCcodigo"  			type="string"   required="no">
		<cfargument name="AFCcodigoclas"  		type="string"   required="yes">
		<cfargument name="CRDRdescripcion"  	type="string"   required="yes">
		<cfargument name="CRDRdescdetallada"	type="string"   required="yes">
		<cfargument name="CRDRserie"  			type="string"   required="yes">
		<cfargument name="Monto"  				type="numeric"  required="yes">
		<cfargument name="CRTCcodigo"  			type="string"   required="yes">
		<cfargument name="CRDRdocori"  			type="string"   required="no" default="">
		<cfargument name="DDlineas"  			type="string"   required="no" default="">
        <cfargument name="EOidorden"  			type="numeric"  required="no" default="0">
        <cfargument name="DOlineas"  			type="string"   required="no" default="">
        <cfargument name="CRorigen"  			type="string"   required="no">
        <cfargument name="AFCMejora"  		    type="boolean" required="no" default="false">   
        <cfargument name="AFCMid"  		        type="numeric" required="no" default="-1"> 
            
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo') or not len(trim(Arguments.Ecodigo))>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usucodigo') or not len(trim(Arguments.Usucodigo))>
			<cfset Arguments.Usucodigo = session.Usucodigo>
		</cfif>
		<!--- <cfif NOT LEN(TRIM(Arguments.CRDRserie))>
			<cfthrow message="La serie del Activos Fijo es requerida.">
		</cfif> comentado eliminado por cambio de alvaro chaves conavi--->
		<cfif isdefined("arguments.DDlineas") and len(trim(arguments.DDlineas)) and NOT LEN(TRIM(Arguments.CRDRdocori))>
			<cfthrow message="El Documento que Origino la Adquisición es requerida.">
		</cfif>
		
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_TipoDocumento"  returnvariable="rsTipoDocumento" CRTDcodigo="#Arguments.CRTDcodigo#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Empleado" 		returnvariable="rsEmpleado"		 DEidentificacion="#Arguments.DEidentificacion#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Categoria" 		returnvariable="rsCategoria" 	 ACcodigodesc="#Arguments.Categoria#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Clase" 			returnvariable="rsClase" 		 clase="#Arguments.Clase#" 			 categoria="#Arguments.Categoria#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Marca" 			returnvariable="rsMarcas" 		 AFMcodigo="#Arguments.AFMcodigo#"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Modelo" 		returnvariable="rsModelo" 		 AFMMcodigo="#Arguments.AFMMcodigo#" AFMcodigo="#Arguments.AFMcodigo#"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_CFuncional" 	returnvariable="rsCFuncional" 	 CFcodigo="#Arguments.CFcodigo#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_TCompra" 	    returnvariable="rsTCompra" 	     CRTCcodigo="#Arguments.CRTCcodigo#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Transito" 	   	Aplaca="#Arguments.CRDRplaca#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_TipoAF" 		returnvariable="rsTipoAF"  	 	 AFCcodigoclas="#Arguments.AFCcodigoclas#"/> 
		<cfif isdefined("Arguments.CRCCcodigo")> 
        	<cfif Arguments.CRCCcodigo gt 0>
			
            <cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_ExisteAF"		returnvariable="Aid"  			 Aplaca="#Arguments.CRDRplaca#" Ecodigo="#session.Ecodigo#" DebeExistir="false"/>
            <cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_CentroCustodia" returnvariable="rsCentroC"  	 CRCCcodigo="#Arguments.CRCCcodigo#"/>
            
            </cfif>
        </cfif>
        <cfif isdefined("rsCentroC.CRCCid")>
	        <cfif Arguments.CRCCcodigo gt 0>
        		<cfset Arguments.CRCCid = rsCentroC.CRCCid>
            </cfif>
        </cfif>
		<cfquery name="rs_insert" datasource="#Arguments.Conexion#">
			insert into CRDocumentoResponsabilidad 
					(	
						Ecodigo, 
						CRTDid, 
						DEid, 
						CFid, 
						ACcodigo, 
						ACid, 
						CRCCid, 
						AFMid, 
						AFMMid, 
						CRDRplaca, 
						CRDRdescripcion, 
						CRDRdescdetallada, 
						CRDRfdocumento, 
						CRTCid, 
						AFCcodigo, 
						CRDRfalta, 
						BMUsucodigo, 
						CRDRestado, 
						CRDRserie, 
						Monto, 
						CRDRutilaux,
						CRDRdocori,
                        DDlineas,
                        DOlineas,
                        CRorigen,
                        AFCMejora,
                        EOidorden        
					)
				values 
				(
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">,			 <!---Empresa--->
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#rsTipoDocumento.CRTDid#">,		 <!---Tipo de Documento--->
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#rsEmpleado.DEid#">,			 	 <!---Empleado--->
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#rsCFuncional.CFid#">,			 <!---Centro Funcional--->
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#rsCategoria.ACcodigo#">,		 <!---Categoria--->
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#rsClase.ACid#">,				 <!---Clase--->
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CRCCid#">,			 <!---Centro de Custodia--->
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#rsMarcas.AFMid#">,				 <!---Marca--->
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#rsModelo.AFMMid#">,				 <!---Modelo--->
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.CRDRplaca#" null="#Len(trim(Arguments.CRDRplaca)) eq 0#">,  		 <!---Placa--->
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.CRDRdescripcion#">,	 <!---Descripcion--->
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.CRDRdescdetallada#">,  <!---Descripcion detallada--->
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.CRDRfdocumento#">,  	 <!---Fecha del Documento--->
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#rsTCompra.CRTCid#">,	  		 <!---Tipo de Compra--->
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#rsTipoAF.AFCcodigo#">,		 	 <!---Clasificacion(Tipo)--->
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.CRDRfalta#">,		 	 <!---Fecha de Alta del Registro--->	
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Usucodigo#">,     	 <!---Usucodigo para Log del Portal--->
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CRDRestado#">,		 <!---Estado--->
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.CRDRserie#">,		 	 <!---Serie--->
				<cf_jdbcquery_param cfsqltype="cf_sql_money" 	value="#Arguments.Monto#">,			 	 <!---Monto de Adquisicion--->
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#Arguments.CRDRutilaux#">,     	 <!---Proveniente de un Sistema Auxiliar--->
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.CRDRdocori#">,      	 <!---Documento que Origino la Adquisicion(CXP)--->
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar"    value="#Arguments.DDlineas#"       null="#Len(trim(Arguments.DDlineas)) eq 0#">, 
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar"    value="#Arguments.DOlineas#"       null="#Len(trim(Arguments.DOlineas)) eq 0#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_char"       value="#Arguments.CRorigen#"       null="#Len(trim(Arguments.CRorigen)) eq 0#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_bit"        value="#Arguments.AFCMejora#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#"      null="#Arguments.EOidorden eq 0#">
                )
                <cf_dbidentity1 datasource="#Arguments.Conexion#" name="rs_insert">
		</cfquery>
		<cf_dbidentity2 datasource="#Arguments.Conexion#" name="rs_insert" returnvariable="CRDRid">
        <cfreturn CRDRid>
	</cffunction>
    
    <cffunction name="GetDocTransito" access="public" returntype="query">
    <cfargument name="CRDRid" 			type="numeric"  required="true">
    <cfargument name="CRCCid"  			type="numeric" 	required="false">
        
		<cfquery name="rs" datasource="#Session.DSN#">
			select isnull(Pvalor,1) as Pvalor
			from Parametros
			where Ecodigo = #Session.Ecodigo#  
			  and Pcodigo = 200060
		</cfquery>
		<cfset TipoPlaca = rs.Pvalor>
		
    	<cf_dbfunction name="concat" args="d.DEapellido1 + ' ' + d.DEapellido2 + ' ' + d.DEnombre" delimiters="+" returnvariable="LvarNombre">
		<cfset LvarNombre = "(( select min(#LvarNombre#) from DatosEmpleado d where d.DEid = a.DEid ))">
        <cfquery name="rsForm" datasource="#session.dsn#">
            select 
                g.ACatId,
                (( select min(h1.AClaId)
                    from AClasificacion h1
                    where h1.Ecodigo 	= a.Ecodigo
                      and h1.ACid 		= a.ACid
                      and h1.ACcodigo 	= a.ACcodigo
                )) as idClase,
                a.CRDRid, 
                a.CRTDid, 
                a.CRTCid, 
                a.DEid, 
                a.CFid, 
                a.CRDRdescripcion, 
                a.CRDRfdocumento, 
                a.CRCCid, 
                a.CRDRplaca, 
                a.CRDRdescdetallada, 
                a.CRDRserie, 
                a.CRDRtipodocori, 
                a.CRDRdocori, 
                a.CRDRlindocori, 
                a.Monto,
                a.EOidorden, 
                a.DOlinea, 
                case when a.EOidorden is not null or a.DOlineas is not null then 2<!---Asociar a una Orden de Compra--->
                when a.CRDRdocori is not null then 1<!---Asociar a una Factura CXP--->
                else 0 end as TipoOrigen,<!---Sin asociacion--->
                a.ts_rversion, 
                a.CRorigen,
    			a.DOlineas, 
                a.DDlineas, 
                a.AFCMejora,
                a.AFCMid,
                ((select min(b1.CRTDcodigo)
                    from CRTipoDocumento b1
                    where b1.CRTDid = a.CRTDid
                    )) as CRTDcodigo,
                
                ((select min(b2.CRTDdescripcion)
                    from CRTipoDocumento b2
                    where b2.CRTDid = a.CRTDid
                    )) as CRTDdescripcion,
    
                ((select c1.CRTCcodigo
                    from CRTipoCompra c1 
                    where c1.CRTCid = a.CRTCid
                    )) as CRTCcodigo, 
                ((select c2.CRTCdescripcion
                    from CRTipoCompra c2 
                    where c2.CRTCid = a.CRTCid
                    )) as CRTCdescripcion, 
    
                (( select min(d.DEidentificacion) from DatosEmpleado d where d.DEid = a.DEid )) as DEidentificacion, 
                #preservesinglequotes(LvarNombre)# as DEnombrecompleto, 
    
                ((select min(e1.CFcodigo)
                    from CFuncional e1
                    where e1.CFid = a.CFid
                    )) as CFcodigo, 
                ((select min(e2.CFdescripcion)
                    from CFuncional e2
                    where e2.CFid = a.CFid
                    )) as CFdescripcion,
    
                ((select f1.CRCCcodigo
                    from CRCentroCustodia f1
                    where f1.CRCCid = a.CRCCid
                    )) as CRCCcodigo, 
                ((select f2.CRCCdescripcion
                    from CRCentroCustodia f2
                    where f2.CRCCid = a.CRCCid
                    )) as CRCCdescripcion,
    
                g.ACcodigo      as ACcodigo, 
                g.ACcodigodesc  as ACcodigodesc,
                g.ACdescripcion as ACdescripcion,
				<cfif TipoPlaca EQ 2>
					h.ACmascara     as ACmascara, 
				<cfelse>
					g.ACmascara     as ACmascara, 
				</cfif> 
                (( select min(h1.ACid)
                    from AClasificacion h1
                    where h1.Ecodigo 	= a.Ecodigo
                      and h1.ACid 		= a.ACid
                      and h1.ACcodigo 	= a.ACcodigo
                )) as ACid,
                
                (( select min(h2.ACcodigodesc)
                    from AClasificacion h2
                    where h2.Ecodigo	= a.Ecodigo
                      and h2.ACid 		= a.ACid
                      and h2.ACcodigo 	= a.ACcodigo
                )) as Cat_ACcodigodesc,
                
                (( select min(h3.ACdescripcion)
                    from AClasificacion h3
                    where h3.Ecodigo 	= a.Ecodigo
                      and h3.ACid 		= a.ACid
                      and h3.ACcodigo 	= a.ACcodigo
                )) as Cat_ACdescripcion,
    
                i.AFCcodigo,
                i.AFCcodigoclas,
                i.AFCdescripcion,
    
                j.AFMid,
                j.AFMcodigo,
                j.AFMdescripcion,
    
                k.AFMMid,
                k.AFMMcodigo,
                k.AFMMdescripcion,
    
                ((select l1.EOnumero
                    from DOrdenCM l1
                    where l1.DOlinea = a.DOlinea
                    )) as EOnumero, 
                    
                ((select l2.DOconsecutivo
                    from DOrdenCM l2
                    where l2.DOlinea = a.DOlinea
                    )) as DOconsecutivo
            from CRDocumentoResponsabilidad a 
                    left outer join ACategoria g on
                        g.Ecodigo = a.Ecodigo
                        and g.ACcodigo = a.ACcodigo
					left outer join AClasificacion h on
                        g.Ecodigo = a.Ecodigo
                        and g.ACcodigo = a.ACcodigo
                    left outer join AFClasificaciones i on
                        i.Ecodigo = a.Ecodigo
                        and i.AFCcodigo = a.AFCcodigo
                    left outer join AFMarcas j on
                        j.AFMid = a.AFMid
                    left outer join AFMModelos k on
                        k.AFMMid = a.AFMMid
                where a.CRDRid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CRDRid#">
            <cfif isdefined("Arguments.CRCCid") and Arguments.CRCCid gt 0>
                and a.CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CRCCid#">	
            </cfif>	
         </cfquery>
         <cfreturn rsForm>
    </cffunction>
    
    <cffunction name="CambioDocTransito" access="public">

		<cfargument name="CRDRid"  			 type="numeric" required="yes">
        <cfargument name="CRTDid"  			 type="numeric" required="yes">
       	<cfargument name="DEid"	             type="numeric" required="yes">
        <cfargument name="CFid"  		     type="numeric" required="yes">
		<cfargument name="ACcodigo"  	     type="numeric" required="yes">
        <cfargument name="ACid"  	         type="numeric" required="yes">
        <cfargument name="CRCCid"  	         type="numeric" required="no">
        <cfargument name="AFMid"  	         type="numeric" required="no" default="0">
        <cfargument name="AFMMid"  	         type="numeric" required="no" default="0">
        <cfargument name="CRDRdescripcion"   type="string"  required="no">
        <cfargument name="CRDRplaca"  		 type="string"  required="no" default="">
        <cfargument name="CRDRdescdetallada" type="string"  required="no">
		<cfargument name="CRDRserie"  		 type="string"  required="no" default="" > 
        <cfargument name="CRDRfdocumento"  	 type="date"   	required="false" default="#now()#">
        <cfargument name="CRTCid"  	         type="numeric" required="no">
        <cfargument name="AFCcodigo"  	     type="numeric" required="no">
        <cfargument name="CRDRtipodocori"  	 type="string"  required="no" default="">
        <cfargument name="CRDRdocori"  		 type="string"  required="no" default="">
        <cfargument name="EOidorden"  	     type="numeric" required="no" default="0">
        <cfargument name="DDlineas"  		 type="string"  required="no" default="">
        <cfargument name="DOlineas"  		 type="string"  required="no" default="">
        <cfargument name="CRorigen"  		 type="string"  required="no">   
        <cfargument name="Monto"  		     type="numeric" required="no">         
        <cfargument name="AFCMejora"  		 type="boolean" required="no" default="false">   
        <cfargument name="AFCMid"  		     type="numeric" required="no" default="-1">   
        
        <cfargument name="Conexion" 		 type="string"  required="false" default="#session.dsn#">
		<cfargument name="Ecodigo"  		 type="numeric" required="false" default="#session.Ecodigo#">
		<cfargument name="Usucodigo"  		 type="numeric" required="false" default="#session.usucodigo#">
    <!---  <cf_dump vaR="#arguments#"> --->
        <cfquery name="rs_update" datasource="#session.dsn#">
            update CRDocumentoResponsabilidad
            set CRTDid	 		  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#Arguments.CRTDid#">,
                <cfif isdefined ("Arguments.DEid") and Arguments.DEid gt 0> 
                DEid              = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.DEid#">, 
                </cfif>
                CFid	 		  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#Arguments.CFid#">, 
                ACcodigo 		  = <cf_jdbcquery_param cfsqltype="cf_sql_integer" 	 value="#Arguments.ACcodigo#">, 
                ACid	 		  = <cf_jdbcquery_param cfsqltype="cf_sql_integer" 	 value="#Arguments.ACid#">, 
                CRCCid	 		  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#Arguments.CRCCid#">, 
                <cfif isdefined ("Arguments.AFMid") and Arguments.AFMid gt 0> 
                AFMid             = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.AFMid#"          voidnull>, 
                </cfif>
                <cfif isdefined ("Arguments.AFMMid") and Arguments.AFMMid gt 0> 
                AFMMid            = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.AFMMid#"             voidnull>,      
                </cfif>
                <cfif isdefined ("#Arguments.CRDRplaca#")>
                CRDRplaca		  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#Arguments.CRDRplaca#" 		voidnull>, 
                </cfif>
                CRDRdescripcion   = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#Arguments.CRDRdescripcion#" 	voidnull>, 
                CRDRdescdetallada = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#Arguments.CRDRdescdetallada#" voidnull>, 
                CRDRserie		  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#Arguments.CRDRserie#" 		voidnull>, 
                CRDRfdocumento    = <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Arguments.CRDRfdocumento#"   voidnull>,
                CRTCid			  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CRTCid#"         null="#Len(Arguments.CRTCid) eq 0#">, 
                AFCcodigo         = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AFCcodigo#"      null="#Len(Arguments.AFCcodigo) eq 0#">, 
                CRDRtipodocori    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CRDRtipodocori#" null="#Len(trim(Arguments.CRDRtipodocori)) eq 0#">, 
                CRDRdocori        = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CRDRdocori#"     null="#Len(trim(Arguments.CRDRdocori)) eq 0#">, 
                EOidorden         = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#"      null="#Arguments.EOidorden eq 0#">, 
			
                DDlineas          = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DDlineas#"       null="#Len(trim(Arguments.DDlineas)) eq 0#">, 
				DOlineas          = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DOlineas#"       null="#Len(trim(Arguments.DOlineas)) eq 0#">, 
                CRorigen          = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CRorigen#"       null="#Len(trim(Arguments.CRorigen)) eq 0#">, 
                Monto             = <cfqueryparam cfsqltype="cf_sql_money"   value="#Replace(Arguments.Monto,',','','all')#">, 
            
                BMUsucodigo       = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                <cfif Arguments.AFCMejora>
                    AFCMejora     = <cfqueryparam cfsqltype="cf_sql_bit"     value="1">,
                    AFCMid        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFCMid#">
                <cfelse>
                	AFCMejora     = <cfqueryparam cfsqltype="cf_sql_bit"     value="0">,
                    AFCMid        = <cfqueryparam cfsqltype="cf_sql_numeric" value="-1">
                </cfif>
            where CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CRDRid#">
        </cfquery>
    </cffunction>
     
</cfcomponent>
