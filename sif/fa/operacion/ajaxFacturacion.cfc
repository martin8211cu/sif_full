<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfreturn true>
	</cffunction>
	
	<!--- Querys AFGM CONTROL DE VERSIONES--->
	<cfquery name="rsPCodigoOBJImp" datasource = "#Session.DSN#">
		select Pvalor 
		from Parametros
		where Pcodigo = '17200'
			and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset value = "#rsPCodigoOBJImp.Pvalor#">
	<!--- Querys AFGM CONTROL DE VERSIONES--->
	
	<!--- Elimina Documento Relacionado --->
	<cffunction name="deleteDoc" access="remote" returntype="struct">
		<cfargument name="idDocR" required="yes" type="string">
		<cfargument name="OImpresionID" required="yes" type="string">
		<cftransaction>
			<cftry>
				<cfquery name="rsGetNC" datasource="#Session.dsn#">
					DELETE FA_CFDI_Relacionado
					WHERE IdCFDIRel = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDocR#">
					AND OImpresionID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OImpresionID#">
				</cfquery>
				<cftransaction action="commit" />
				<cfset Local.obj = {MSG='DeleteOK'}>
				<cfcatch type="any">
					<cftransaction action="rollback" />
					<cfset Local.obj = {MSG='Ha ocurrido un error al eliminar el Documento.'}>
				</cfcatch>
			</cftry>
		</cftransaction>
		<cfreturn  Local.obj>
	</cffunction>
	
	<!--- Elimina Todos los Documentos Relacionados --->
	<cffunction name="deleteAllDocs" access="remote" returntype="struct">
		<cfargument name="OImpresionID" required="yes" type="string">
		<cftransaction>
			<cftry>
				<cfquery name="rsGetNC" datasource="#Session.dsn#">
					DELETE FA_CFDI_Relacionado
					WHERE OImpresionID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OImpresionID#">
				</cfquery>
				<cftransaction action="commit" />
				<cfset Local.obj = {MSG='DeleteOK'}>
				<cfcatch type="any">
					<cftransaction action="rollback" />
					<cfset Local.obj = {MSG='Ha ocurrido un error al eliminar el Documento.'}>
				</cfcatch>
			</cftry>
		</cftransaction>
		<cfreturn  Local.obj>
	</cffunction>
	
	
	<!--- Inserta Documento Relacionado --->
	<cffunction name="insertDoc" access="remote" returntype="struct">
		<cfargument name="docsRel" required="yes" type="any">
		<cfargument name="SNcodigo" required="yes" type="string">
		<cfargument name="OImpresionID" required="yes" type="string">
		<cfargument name="CmbTipoRel" required="yes" type="string">
	
		<cftransaction>
			<cftry>
				<cfset fol = ListToArray(arguments.docsRel,'|')>
				<cfset folios = ArrayToList(fol)>
				<cfquery name="docsSelec" datasource="#session.dsn#">
					select *
					from Documentos
					where
					<cfif value eq '3.3'> 
					CCTcodigo = 'FC' and
					</cfif> 
					Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and Dsaldo > 0.0
					 and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SNcodigo#">
					 and Ddocumento in (<cfqueryparam list="yes" cfsqltype="cf_sql_varchar" value="#folios#">)
					order by Dfecha desc
				</cfquery>
	
				<cfloop query="docsSelec">
					<cfquery datasource="#session.dsn#">
						insert into FA_CFDI_Relacionado(Ecodigo,OImpresionID,Serie,Folio,Documento,TipoRelacion,DocumentoRelacionado,TimbreDocRel)
						values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.OImpresionID#">,
						'',
						<cfqueryparam cfsqltype="cf_sql_numeric" value="0">,
						'',
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CmbTipoRel#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Ddocumento#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#TimbreFiscal#">
						)
					</cfquery>
				</cfloop>
				<cftransaction action="commit" />
				<cfset Local.obj = {MSG='InsertOK'}>
				<cfcatch type="any">
					<cftransaction action="rollback" />
					<cfset Local.obj = {MSG='Ha ocurrido un error al insertar el Documento.'}>
				</cfcatch>
			</cftry>
		</cftransaction>
		<cfreturn  Local.obj>
	</cffunction>
	
	<cffunction name="refreshDocs" access="remote" returntype="boolean">
		<cfargument name="OImpresionID" required="yes" type="string">
	
		<cfquery name="rsDocsRel" datasource="#session.dsn#">
			SELECT DocumentoRelacionado,
				   c.Dsaldo,
				   dr.TimbreDocRel,
				   '<img width = "18px" height = "18" border="0" src="/cfmx/sif/imagenes/delete.small.png" title="Eliminar" style="cursor:pointer" onclick = "javascript:eliminarDoc(' + cast(dr.IdCFDIRel as varchar) +','+  cast(dr.OImpresionID as varchar) +');"/>' AS Eliminar
			FROM FA_CFDI_Relacionado dr
			INNER JOIN Documentos c ON dr.DocumentoRelacionado = c.Ddocumento
			WHERE dr.OImpresionID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OImpresionID#">
		</cfquery>
	
		<cfif rsDocsRel.recordCount GT 0>
			<cfoutput>
				<div id="scrollD" <cfif rsDocsRel.recordCount gt 6> style="height: 150px; overflow-y: scroll;"</cfif>>
				<table border="0" align="left" cellspacing="3" width="95%">
					<!--- Encabezados --->
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr>
						<td><strong>&nbsp;Documento</strong></td>
						<td><strong>&nbsp;Saldo</strong></td>
						<td width="50%"><strong>&nbsp;Timbre</strong></td>
						<td width="9%">&nbsp;</td>
					</tr>
					<cfloop query="rsDocsRel">
						<tr>
							<td>&nbsp;#rsDocsRel.DocumentoRelacionado#</td>
							<td align="right">#LSNumberFormat(rsDocsRel.Dsaldo,',9.00')#</td>
							<td nowrap="true">&nbsp;&nbsp;#rsDocsRel.TimbreDocRel#</td>
							<td align="center">#rsDocsRel.Eliminar#</td>
						</tr>
					</cfloop>
					<cfif rsDocsRel.recordCount gt 10>
						<tr><td colspan="4" align="center"></br><a><img width = "18px" height = "18" border="0" src="/cfmx/sif/imagenes/delete.small.png" title="Eliminar Todos" style="cursor:pointer" onclick = "javascript:eliminarTodos();"/></a>&nbsp;Quitar todos</td></tr>
					</cfif>
				</table>
				</div>
			</cfoutput>
		</cfif>
		<cfreturn  true>
	</cffunction>
	<cffunction name="getMet_Pago"access="remote" hint="Funcion para obtener el metodo de pago con base a la forma de pago" returnformat="json" secureJSON="false">
		<cfargument name="TipoPago"             type="numeric"  required="yes"/>
	
		 <cfscript>
			var resultado = structnew();
		</cfscript>
	
		<cfquery name="rsMet_Pago" datasource="#session.dsn#" result="myResult">
		   Select top 1 isnull(CSATcodigo,-1) as Codigo
			from FATipoPago tp
				inner join CSATMetPago mp
				on mp.MPid = tp.MPid
				where tp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and tp.codigo_TipoPago=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.TipoPago#">
		</cfquery>
	
		<cfif isdefined("rsMet_Pago") and rsMet_Pago.recordCount gt  0>
			<cfscript>
				resultado.Codigo = rsMet_Pago.Codigo;
			</cfscript>
		<cfelse>
			<cfscript>
				resultado.Codigo = -1;
			</cfscript>
		</cfif>
		
	
		<cfreturn  SerializeJSON(resultado,true)>
	</cffunction>
	
	<cffunction name="getRel_Documento" access="remote" output="true">
		<cfargument name="Sustitucion"        type="numeric"  required="yes"/>
		<cfargument name="TipoMovimiento"     type="string"   required="yes"/>
		<cfargument name="OImpresionID"       type="numeric"  required="yes"/>
		<cfargument name="SNcodigo"           type="string"   required="yes"/>
		<cfargument name="Ecodigo"            type="numeric"  default = "#session.Ecodigo#"/>
		<cfargument name="DSN"                type="string"  default = "#session.DSN#"/>
	
		<!---<cfset resultado = ArrayNew(1)>
		<cfset facturas = structnew() >--->
	
		<!---<cfquery name="rsRel_Documento" datasource="#session.dsn#" result="myResult" >
			select Ddocumento,Dsaldo,TimbreFiscal
			from Documentos a 
				inner join FA_CFDI_Emitido fae on a.TimbreFiscal = fae.timbre
				inner join FAPreFacturaE fpe on fae.Folio = fpe.foliofacele
				inner join FAPFTransacciones t on fpe.PFTcodigo = t.PFTcodigo and fpe.Ecodigo = t.Ecodigo
				inner join Monedas m on a.Mcodigo = m.Mcodigo
				inner join SNegocios s on a.SNcodigo = s.SNcodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#"> 
				<cfif Arguments.Sustitucion EQ 0>
					<cfif Arguments.TipoMovimiento EQ 'C'>
						and t.PFTtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="D"> 
					<cfelse>
						and t.PFTtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="C"> 
					</cfif>
				<cfelse>
					and t.PFTtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TipoMovimiento#"> 
				</cfif>
				and a.Dsaldo > 0.0
				and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SNcodigo#">
				and a.Dsaldo >= a.Dtotal
		</cfquery>
	
	
		<cfif isdefined("rsRel_Documento") and rsRel_Documento.recordCount gt 0>
			<cfloop query="#rsRel_Documento#">
				<cfset facturas.Ddocumento = rsRel_Documento.Ddocumento>
				<cfset facturas.Dsaldo = rsRel_Documento.Dsaldo>
				<cfset facturas.TimbreFiscal = rsRel_Documento.TimbreFiscal>
				<cfset ArrayAppend(resultado,facturas)>
			</cfloop>
		<cfelse>
	
		</cfif>--->
	
		<cfquery name="rsDocsRel" datasource="#Arguments.DSN#">
			SELECT count(*) CantDocsRel
			FROM FA_CFDI_Relacionado dr
			INNER JOIN Documentos c ON dr.DocumentoRelacionado = c.Ddocumento
			WHERE c.Ecodigo = #Arguments.Ecodigo#
			AND dr.OImpresionID = #Arguments.OImpresionID#
		</cfquery>
	
		<cfif Arguments.Sustitucion EQ 0>
			<cfif Arguments.TipoMovimiento EQ 'C'>
				<cfset filtrar = "a.Ecodigo = #Arguments.Ecodigo# and a.Dsaldo > 0.0
								  and a.SNcodigo = #Arguments.SNCODIGO# and t.PFTtipo = 'D'">
			<cfelse>
				<cfset filtrar = "a.Ecodigo = #Arguments.Ecodigo# and a.Dsaldo > 0.0
								  and a.SNcodigo = #Arguments.SNCODIGO# and t.PFTtipo = 'C'">
			</cfif>
		<cfelse>
			<cfset filtrar = "a.Ecodigo = #Arguments.Ecodigo# and a.Dsaldo > 0.0
							  and a.SNcodigo = #Arguments.SNCODIGO# and a.Dsaldo >= a.Dtotal and t.PFTtipo = '#Arguments.TipoMovimiento#'">
		</cfif>
	
		<script type="text/javascript" language="JavaScript" src="/cfmx/commons/js/pLista1.js"></script>
	
		<table width="100%">
			<tr>
				<td align="right" <cfif isdefined("rsDocsRel") and rsDocsRel.CantDocsRel GT 0> style="display: none;" </cfif>>
					<strong>Agregar Documentos:</strong>
				</td>
				
				<td <cfif isdefined("rsDocsRel") and rsDocsRel.CantDocsRel GT 0> style="display: none;" </cfif>>
					<cf_conlis
						campos="Ddocumento,Dsaldo,TimbreFiscal"
						size="20"
						desplegables="S,N,N"
						modificables="S,N,N"
						title="Documentos"
						tabla="Documentos a 
							inner join FAPFTransacciones t on a.Ecodigo = t.Ecodigo and a.CCTcodigo = t.CCTcodigoRef
							inner join Monedas m on a.Mcodigo = m.Mcodigo
							inner join SNegocios s on a.SNcodigo = s.SNcodigo AND a.Ecodigo = s.Ecodigo"
						columnas="Ddocumento,Dsaldo,TimbreFiscal"
						filtrar_por="Ddocumento"
						desplegar="Ddocumento,Dsaldo,TimbreFiscal"
						etiquetas="Documento,Saldo,Timbre"
						formatos="S,S,S"
						align="left,left,left"
						form="form1"
						showEmptyListMsg="true"
						EmptyListMsg=" --- No hay registros --- "
						alt="Documento,Saldo"
						funcion="funcAgregar"
						fparams="Ddocumento"
						filtro="#filtrar#" 
					/>
				</td>
			</tr>
		</table>
	</cffunction>
	
	</cfcomponent>