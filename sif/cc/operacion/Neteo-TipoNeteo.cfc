<cfcomponent>
	<cffunction name="DeterminarTipoNeteoDocs" returntype="numeric">
		<cfargument name="idDoc" type="numeric">
		<cfargument name="Ecodigo" type="string" default="#session.Ecodigo#">
		<cfargument name="conexion" type="string" default="#session.dsn#">

		<!--- Periodo/Mes de Auxiliares --->
		<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
			select Pvalor
			  from Parametros 
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 50
		</cfquery>
		<cfquery name="rsMes" datasource="#Arguments.Conexion#">
			select Pvalor
			  from Parametros 
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 60
		</cfquery>
		<cfset LvarAnoMesAux = rsPeriodo.Pvalor * 100 + rsMes.Pvalor>
		
		<!--- Periodo de Presupuesto --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select CPPid, CPPestado
			  from CPresupuestoPeriodo
			 where Ecodigo = #Arguments.Ecodigo#
			   and #LvarAnoMesAux# between CPPanoMesDesde and CPPanoMesHasta
		</cfquery>

		<!--- Sin Presupuesto no hay restricciones --->
		<cfif rsSQL.CPPid EQ "" OR rsSQL.CPPestado EQ "5">
			<cfreturn 0>
		</cfif>

		<!--- En alta se indica que puede ser cualquiera con restricciones --->
		<cfif Arguments.idDoc EQ "-1">
			<cfreturn 1>
		</cfif>
		
		<cfset sbQueryDocs(Arguments.idDoc)>
		
		<cfif rsDocs.CxCs+rsDocs.CxPs EQ 0>
			<!--- Sin Documentos puede ser cualquiera con restricciones --->
			<cfreturn 1>
		<cfelseif rsDocs.cxcANTs+rsDocs.cxpANTs EQ 0>
			<!--- Sin Anticipos es Neteo Documentos --->
			<cfset LvarTipo = 1>
		<cfelseif rsDocs.cxcANTs GT 0 AND rsDocs.cxcFAVs EQ 0 AND rsDocs.CxPs EQ 0>
			<!--- Anticipos CxC sin CxC a favor ni CxP es Aplicacion Anticipos CxC --->
			<cfset LvarTipo = 2>
		<cfelseif rsDocs.cxpANTs GT 0 AND rsDocs.cxpFAVs EQ 0 AND rsDocs.CxCs EQ 0>
			<!--- Anticipos CxP sin CxP a favor ni CxC es Aplicacion Anticipos CxP --->
			<cfset LvarTipo = 3>
		<cfelseif rsDocs.cxcDOCs+rsDocs.cxcFAVs EQ 0 AND rsDocs.cxpDOCs+rsDocs.cxpFAVs EQ 0>
			<!--- Sólo Anticipos es Neteo Anticipos --->
			<cfset LvarTipo = 4>
		<cfelse>
			<!--- ERROR --->
			<cfreturn -1>
		</cfif>
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			update DocumentoNeteo
			   set TipoNeteoDocs = #LvarTipo#
			 where idDocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDoc#">
			   and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfreturn LvarTipo>
	</cffunction>

	<cffunction name="VerificarTipoNeteoDocs" returntype="string">
		<cfargument name="idDoc" type="numeric">
		<cfargument name="Ecodigo" type="string" default="#session.Ecodigo#">
		<cfargument name="conexion" type="string" default="#session.dsn#">

		<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
		<cfset MSG_NeteoDoct = t.Translate('MSG_NeteoDoct','Neteo de Documentos de CxC y CxP: No se permiten Anticipos de Efectivo','/sif/cc/operacion/Neteo1.xml')>
		<cfset MSG_AplAntCxC1 = t.Translate('MSG_AplAntCxC1','Aplicación de Anticipos de CxC: No se permiten Documentos de CxP','/sif/cc/operacion/Neteo1.xml')>
		<cfset MSG_AplAntCxC2 = t.Translate('MSG_AplAntCxC2','Aplicación de Anticipos de CxC: No se permiten Documentos a favor de CxC que no sean de Anticipos','/sif/cc/operacion/Neteo1.xml')>
		<cfset MSG_AplAntCxP1 = t.Translate('MSG_AplAntCxP1','Aplicación de Anticipos de CxP: No se permiten Documentos de CxC','/sif/cc/operacion/Neteo1.xml')>
		<cfset MSG_AplAntCxP2 = t.Translate('MSG_AplAntCxP2','Aplicación de Anticipos de CxP: No se permiten Documentos a favor que no sean de Anticipos','/sif/cc/operacion/Neteo1.xml')>
		<cfset MSG_NeteoAnt = t.Translate('MSG_NeteoAnt','Neteo de Anticipos de CxC y CxP: No se permiten Documentos que no son Anticipos de Efectivo','/sif/cc/operacion/Neteo1.xml')>
        
        
		<cfset sbQueryDocs(Arguments.idDoc)>
		
		<cfif rsDocs.CxCs+rsDocs.CxPs EQ 0>
			<!--- Sin Documentos puede ser cualquiera --->
			<cfreturn "">
		<cfelseif rsDocs.TipoNeteoDocs EQ 1 AND NOT (rsDocs.cxcANTs+rsDocs.cxpANTs EQ 0)>
			<!--- Sin Anticipos es Neteo Documentos --->
			<cfreturn "#MSG_NeteoDoct#">
		<cfelseif rsDocs.TipoNeteoDocs EQ 2 AND NOT (rsDocs.cxcANTs GTE 0 AND rsDocs.CxPs EQ 0)>
			<!--- Anticipos CxC sin CxP es Aplicacion Anticipos CxC --->
			<cfreturn "#MSG_AplAntCx1#">
		<cfelseif rsDocs.TipoNeteoDocs EQ 2 AND NOT (rsDocs.cxcANTs GTE 0 AND rsDocs.cxcFAVs EQ 0)>
			<!--- Anticipos CxC sin CxP es Aplicacion Anticipos CxC --->
			<cfreturn "#MSG_AplAntCxC2#">
		<cfelseif rsDocs.TipoNeteoDocs EQ 3 AND NOT (rsDocs.cxpANTs GTE 0 AND rsDocs.CxCs EQ 0)>
			<!--- Anticipos CxP sin CxC es Aplicacion Anticipos CxP --->
			<cfreturn "#MSG_AplAntCxP1#">
		<cfelseif rsDocs.TipoNeteoDocs EQ 3 AND NOT (rsDocs.cxpANTs GTE 0 AND rsDocs.cxpFAVs EQ 0)>
			<!--- Anticipos CxP sin CxC es Aplicacion Anticipos CxP --->
			<cfreturn "#MSG_AplAntCxP2#">
		<cfelseif rsDocs.TipoNeteoDocs EQ 4 AND NOT (rsDocs.cxcDOCs+rsDocs.cxcFAVs EQ 0 AND rsDocs.cxpDOCs+rsDocs.cxpFAVs EQ 0)>
			<!--- Sólo Anticipos es Neteo Anticipos --->
			<cfreturn "#MSG_NeteoAnt#">
		</cfif>
		<cfreturn "">
	</cffunction>

	<cffunction name="sbQueryDocs" returntype="void"> 
		<cfargument name="idDoc" type="numeric">
		<cfargument name="Ecodigo" type="string" default="#session.Ecodigo#">
		<cfargument name="conexion" type="string" default="#session.dsn#">

		<cfif isdefined("rsDocs")>
			<cfreturn>
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#">
			delete from DocumentoNeteoDCxC
			 where (
					select count(1)
					  from Documentos d
					 where d.Ddocumento	= DocumentoNeteoDCxC.Ddocumento
					   and d.CCTcodigo	= DocumentoNeteoDCxC.CCTcodigo
					   and d.Ecodigo	= DocumentoNeteoDCxC.Ecodigo
					) = 0
		</cfquery>
		
		<cfquery datasource="#Arguments.Conexion#">
			delete from DocumentoNeteoDCxP
			 where (
					select count(1)
					  from EDocumentosCP d
					 where d.IDdocumento = DocumentoNeteoDCxP.idDocumento
					) = 0
		</cfquery>
		
		<cfquery name="rsDocs" datasource="#Arguments.Conexion#">
			select	TipoNeteoDocs,
					coalesce(
						(
							select count(1)
							  from DocumentoNeteoDCxC b
							 where b.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
						)
					,0) as CXCs,
					coalesce(
						(
							select count(1)
							  from DocumentoNeteoDCxC b
								inner join CCTransacciones t
									 on t.CCTcodigo	= b.CCTcodigo
									and t.Ecodigo 	= DocumentoNeteo.Ecodigo
							 where b.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
							   and t.CCTtipo = 'D'
						)
					,0) as cxcDOCs,
					coalesce(
						(
							select count(1)
							  from DocumentoNeteoDCxC b
								inner join CCTransacciones t
									 on t.CCTcodigo	= b.CCTcodigo
									and t.Ecodigo 	= b.Ecodigo
							 where b.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
							   and t.CCTtipo = 'C'
							   and (
							   		select count(1)
									  from DDocumentos d
									 where d.Ddocumento	= b.Ddocumento
									   and d.CCTcodigo	= b.CCTcodigo
									   and d.Ecodigo	= b.Ecodigo
									) > 0
						)
					,0) as cxcFAVs,
					coalesce(
						(
							select count(1)
							  from DocumentoNeteoDCxC b
								inner join CCTransacciones t
									 on t.CCTcodigo	= b.CCTcodigo
									and t.Ecodigo 	= b.Ecodigo
							 where b.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
							   and t.CCTtipo = 'C'
							   and (
							   		select count(1)
									  from DDocumentos d
									 where d.Ddocumento	= b.Ddocumento
									   and d.CCTcodigo	= b.CCTcodigo
									   and d.Ecodigo	= b.Ecodigo
									) = 0
						)
					,0) as cxcANTs,
					coalesce(
						(
							select count(1)
							  from DocumentoNeteoDCxP b
							 where b.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
						)
					,0) as CxPs,
					coalesce(
						(
							select count(1)
							  from DocumentoNeteoDCxP b
								inner join CPTransacciones t
									 on t.CPTcodigo	= b.CPTcodigo
									and t.Ecodigo 	= DocumentoNeteo.Ecodigo
							 where b.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
							   and t.CPTtipo = 'C'
						)
					,0) as cxpDOCs,
					coalesce(
						(
							select count(1)
							  from DocumentoNeteoDCxP b
								inner join CPTransacciones t
									 on t.CPTcodigo	= b.CPTcodigo
									and t.Ecodigo 	= DocumentoNeteo.Ecodigo
							 where b.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
							   and t.CPTtipo = 'D'
							   and (
							   		select count(1)
									  from DDocumentosCP d
									 where d.IDdocumento	= b.idDocumento
									) > 0
						)
					,0) as cxpFAVs,
					coalesce(
						(
							select count(1)
							  from DocumentoNeteoDCxP b
								inner join CPTransacciones t
									 on t.CPTcodigo	= b.CPTcodigo
									and t.Ecodigo 	= DocumentoNeteo.Ecodigo
							 where b.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
							   and t.CPTtipo = 'D'
							   and (
							   		select count(1)
									  from DDocumentosCP d
									 where d.IDdocumento	= b.idDocumento
									) = 0
						)
					,0) as cxpANTs
			  from DocumentoNeteo
			 where idDocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDoc#">
			   and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
	</cffunction>
</cfcomponent>