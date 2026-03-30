<cfapplication sessionmanagement="YES" name="SIF_ASP">
<cfquery name="Caches" datasource="asp">
	select distinct c.Ccache
	from Empresa e, ModulosCuentaE m, Caches c
	where e.CEcodigo = m.CEcodigo
	  and c.Cid = e.Cid
	  and m.SScodigo = 'SIF'
	  and m.SMcodigo = 'AN'
	  and e.Ereferencia is not null
	  and c.Ccache in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyList(Application.dsinfo)#" list="yes">)
</cfquery>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Actualizacion del IMP_VALE</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<cfflush interval="64">
	<cfloop query="Caches">
		<cfset datasource = Caches.Ccache>
		Procensando el Cache <cfoutput><strong>#Caches.Ccache#</strong></cfoutput><br>
        
		<cfquery datasource="#datasource#" name="rsRequisiciones" maxrows="250">
		 select 
         	er.ERid,
         	dr.DRlinea,						 <!---Linea de la Requisicion--->
			null as NumLote, 				 <!---Numero del Lote--->
			er.ERdescripcion,  			 	 <!---Descripción de Relación--->
			er.ERdocumento,			 	 	 <!---Número de Documento--->
			dep.Deptocodigo,    			 <!---Codigo del Departamento--->
            cf.CFcodigo,					 <!---Codigo del Centro Funcional--->
            cf.CFdescripcion,				 <!---Centro Funcional--->
			dep.Ddescripcion, 				 <!---Descripcion del Departamento--->
			cmp.CMScodigo as codSolicitante, <!---Codigo Solicitante--->
			cmp.CMSnombre as NomSolicitante, <!---Nombre del Solicitante--->
			er.ERFecha,					 	 <!---Fecha de la Requisicion--->
			alm.Almcodigo,					 <!---Codigo del Almacen--->
			alm.Bdescripcion,				 <!---Descripción del Almacen--->	
			null as OrdenProd,  			 <!---Orden de Produccion--->
			er.EReferencia,				 	 <!---Referencia--->
			null as lineaReq, 				 <!---Linea del Detalle de la Requisicion--->
			art.Acodigo, 					 <!---Codigo del Articulo--->
			art.Adescripcion,   			 <!---Descripcion del Articulo--->
			abs(dr.DRcantidad) as DRcantidad,<!---Cantidad de Artículo--->
			ext.Ecostou as DRcosto,		 <!---Costo Unitario--->
			de.DEidentificacion as  UsuAutoriza, 				 <!---Usuario Autorizador--->
			de.DEnombre + ' ' + de.DEapellido1 + ' ' + de.DEapellido2 as NomAutoriza, <!---Nombre del Usuario autorizador--->
			ds.ESnumero, 					 <!---Número de Solicitud---> 
            abs(dr.DRcantidad) * ext.Ecostou as totalReq,  <!---Monto total de la requisicion--->
			null sector, 					 <!---Sector---> 
			ext.Eestante,					 <!---Estante--->
			ext.Ecasilla,					 <!---Casilla--->
			Usu.Usulogin, 					 <!---Login de usuario que confecciona la SC--->
            ds.DSobservacion,				 <!---Observaciones--->
			er.ERFechaA as FechaAprob,		 <!---Fecha de aprobacion--->
			ds.Ucodigo, 					 <!---Unidad de Medida--->
            es.ESfechaAplica,				 <!---Fecha y Hora de Aplicacion--->
			null as NomNotificar			 <!---Persona a notificar--->
			
			from ERequisicion er
				INNER JOIN DRequisicion dr
					on dr.ERid = er.ERid
				LEFT OUTER JOIN Departamentos dep
					  on dep.Ecodigo = er.Ecodigo
					 and dep.Dcodigo = er.Dcodigo
                LEFT OUTER JOIN CFuncional cf
                	on cf.CFid = dr.CFid
				LEFT OUTER JOIN Almacen alm
					on alm.Aid = er.Aid
				LEFT OUTER JOIN Articulos art
					on art.Aid = dr.Aid
				LEFT OUTER JOIN Existencias ext
					 on ext.Aid 	= art.Aid
					and ext.Alm_Aid = alm.Aid
				LEFT OUTER JOIN DSolicitudCompraCM ds
					on ds.DSlinea = dr.DSlinea
				LEFT OUTER JOIN Usuario Usu
					on Usu.Usucodigo = ds.BMUsucodigo
                LEFT OUTER JOIN ESolicitudCompraCM es
                	on es.ESidsolicitud = ds.ESidsolicitud
                LEFT OUTER JOIN CMSolicitantes cmp
                	on cmp.CMSid = es.CMSid
                <!---Aprobador--->    
                LEFT OUTER JOIN UsuarioReferencia ur
                    LEFT OUTER JOIN DatosEmpleado de
                        on convert(varchar(255), de.DEid) = ur.llave
                    on ur.Usucodigo = er.UsucodigoA
                   and ur.STabla    = 'DatosEmpleado'
             
             where er.Impreso =  0 
                   
             <!---  where er.Estado in (1)--->
             
                order by er.ERid <!---NUNCA QUITAR ESTA LINEA--->
		</cfquery>
        Requisiciones pediente de procesar <cfoutput>#rsRequisiciones.RecordCount#</cfoutput></br>
        <cfset catImpresiones = 0>
        <cfset ERidAnterior = -1>
		<cfloop query="rsRequisiciones">
        	
        	<CFSET catImpresiones = catImpresiones + 1>
            <CFIF ERidAnterior NEQ rsRequisiciones.ERid and ERidAnterior NEQ -1>
            	<cfquery datasource="#datasource#">
                	UPDATE ERequisicion SET Impreso = 1 where ERid = #ERidAnterior#
                </cfquery>
				<CFIF catImpresiones GTE 50>
                	Se hace Break al procesar la linea <cfoutput>#catImpresiones#</cfoutput><br>
            		<cfbreak>
                </CFIF>
            </CFIF>
            <CFSET ERidAnterior = rsRequisiciones.ERid>
            
          		<cfquery datasource="NACION_WEB" name="Existe">
                	select count(1) cantidad
                                from ImpVale_ERP 
                              where DRlinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#rsRequisiciones.DRlinea#" voidnull>
                </cfquery>
                <cfif NOT Existe.cantidad>
                    <cfquery datasource="NACION_WEB">
                        insert into ImpVale_ERP (
                            DRlinea,
                            I20NUM,  <!---Numero de Lote--->
                            I20DES,  <!---Descripción de Relación--->
                            I23NU1,  <!---Número de Documento--->
                            I04COD,  <!---Codigo del Departamento--->
                            I04NOM,  <!---Descripcion del Departamento--->
                            CP9COD,  <!---Código de Solicitante--->
                            CP9DES,  <!---Nombre del Solicitante--->
                            I23FEC,  <!---Fecha de Requisición--->
                            I02COD,  <!---Codigo del Almacen--->
                            I02DES,  <!---Descripción del Almacen--->	
                            I23ORD,  <!---Orden de produccion--->
                            I110REF, <!---Referencia--->
                            I24LIN,  <!---Linea del Detalle de la Requisicion--->
                            I01COD,  <!---Codigo del Articulo--->
                            I01DES,  <!---Descripcion del Articulo--->
                            I24CAN,  <!---Cantidad de Artículo--->
                            I24COS,  <!---Costo Unitario--->
                            CM4UUA,  <!---Usuario Autorizador--->
                            AUTORI,  <!---Nombre del Usuario autorizador--->
                            CM4NUM,  <!---Número de Solicitud---> 
                            COSTOT,  <!---Monto total de la requisicion--->
                            I03SEC,  <!---Sector--->
                            I03EST,  <!---Estante---> 
                            I03CAS,	 <!---Casilla--->
                            CMMLOG,  <!---Login de usuario que confecciona la SC--->
                            I23OBS,  <!---Observaciones--->
                            CM4FAP,  <!---Fecha de APLICACION--->
                            I11COD,  <!---Unidad de Medida--->
                            CM4NOT   <!---Persona a notificar--->
                            )   	 <!---Fecha de aprobacion--->
                            values (                  
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#rsRequisiciones.DRlinea#" 		voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#rsRequisiciones.NumLote#" 		voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="NULL" 							voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.ERdocumento#" 	voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.CFcodigo#" 		voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.CFdescripcion#" voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.codSolicitante#"voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.NomSolicitante#"voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_date"    		value="#rsRequisiciones.ERFecha#" 		voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.Almcodigo#" 	voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.Bdescripcion#" 	voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.OrdenProd#" 	voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.EReferencia#" 	voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#rsRequisiciones.lineaReq#" 		voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.Acodigo#" 		voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.Adescripcion#" 	voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#rsRequisiciones.DRcantidad#" 	voidnull>,		
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#rsRequisiciones.DRcosto#" 		voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.UsuAutoriza#" 	voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.NomAutoriza#" 	voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#rsRequisiciones.ESnumero#" 		voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#rsRequisiciones.totalReq#" 		voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#rsRequisiciones.sector#" 		voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.Eestante#" 		voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.Ecasilla#" 		voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.Usulogin#" 		voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.ERdescripcion#" voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#rsRequisiciones.ESfechaAplica#" voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.Ucodigo#" 		voidnull>,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rsRequisiciones.NomNotificar#"	voidnull>
                          )                      
                    </cfquery>
			</cfif>
        </cfloop>
        <cfquery datasource="#datasource#">
            UPDATE ERequisicion SET Impreso = 1 where ERid = #ERidAnterior#
        </cfquery>
	</cfloop>
    Fin Proceso
</body>
</html>