<cfset params = "">
<cfif isdefined("FORM.FILTRO_AFRFINI") and len(trim(FORM.FILTRO_AFRFINI))>
	<cfset params = listAppend(params,"FILTRO_AFRFINI="&FORM.FILTRO_AFRFINI,'&')>
</cfif>
<cfif isdefined("FORM.HFILTRO_AFRFINI") and len(trim(FORM.HFILTRO_AFRFINI))>
	<cfset params = listAppend(params,"HFILTRO_AFRFINI="&FORM.HFILTRO_AFRFINI,'&')>
</cfif>
<cfif isdefined("FORM.Filtro_FechasMayores") and len(trim(FORM.Filtro_FechasMayores))>
	<cfset params = listAppend(params,"Filtro_FechasMayores="&FORM.Filtro_FechasMayores,'&')>
</cfif>
	<cfset params = listAppend(params,"FILTRO_APLACA="&FORM.FILTRO_APLACA,'&')>
	<cfset params = listAppend(params,"FILTRO_DESCRIPCION="&FORM.FILTRO_DESCRIPCION,'&')>
	<cfset params = listAppend(params,"HFILTRO_APLACA="&FORM.HFILTRO_APLACA,'&')>
	<cfset params = listAppend(params,"HFILTRO_DESCRIPCION="&FORM.HFILTRO_DESCRIPCION,'&')>
	<cfset params = listAppend(params,"PageNum_Lista="&FORM.PageNum_Lista,'&')>
	<cfset params = listAppend(params,"o="&FORM.o,'&')>

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif isdefined("FORM.BTNTRANSFERIR")>
		<cfquery datasource="#session.dsn#" name="cf">
			select cf.CFid , cf.CFdescripcion,
					e.DEidentificacion #_Cat# ' - ' #_Cat#	e.DEnombre #_Cat# ' ' #_Cat# e.DEapellido1 #_Cat# ' ' #_Cat# e.DEapellido2 as nombre 
			  from EmpleadoCFuncional eaf
				inner join DatosEmpleado e on e.DEid = eaf.DEid 
				left outer join UsuarioReferencia ue on ue.Ecodigo = #session.EcodigoSDC# and ue.STabla = 'DatosEmpleado' and <cf_dbfunction name="to_number" args="llave"> = e.DEid
				inner join CFuncional cf on cf.CFid = eaf.CFid
			 where eaf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and eaf.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				and <cf_dbfunction name="today"> between ECFdesde and ECFhasta
		</cfquery>
	<cfif cf.recordcount neq 0>
	<cfif isdefined("FORM.CHK")>
		<!--- Verifica mediante el parametro de la aplicación si se sigue la jerarquía
		de jefes de centros funcionales, o se hace la aprobación por medio del encargado
		del centro de custodia --->	
		<cfquery name="rsTipoAprobacion" datasource="#session.dsn#">
			select Pvalor as TAprob
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 990
				and Mcodigo = 'AF'
		</cfquery>					
		<cfif rsTipoAprobacion.recordcount eq 0>
			<cfset TAprob = 0>
		<cfelse>
			<cfset TAprob = rsTipoAprobacion.TAprob>
		</cfif>		
		<cfquery name="rsAproDirecta" datasource="#session.dsn#">
			select Pvalor as AproDirecta
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 4400
				and Mcodigo = 'AF'
		</cfquery>
		<cfif rsAproDirecta.recordcount eq 0>
			<cfset ApbDirecta = 0>
		<cfelse>
			<cfset ApbDirecta = rsAproDirecta.AproDirecta>		
		</cfif>	
		<cfloop list="#FORM.CHK#" index="CHKi">
			<cfinvoke 
				component="sif.Componentes.AF_CambioResponsable" 
				method="Transferir" 
				returnvariable="AFTRid"
				AFRid="#CHKi#"
				DEid="#Form.DEid#"
				Fecha="#Form.Fecha#"
				Estado="10"/>
				
			<cfif isdefined("TAprob") and TAprob eq 1>
				<!--- Verifica si el empleado que tiene el activo es el responsable
				del centro de custodia --->
				<cfquery datasource="#session.DSN#" name="verResp">
				Select count(1) as total
				from AFTResponsables a
				
						inner join AFResponsables b
							 on a.AFRid = b.AFRid
														
						inner join CRCentroCustodia c
							 on c.CRCCid  = b.CRCCid
							
				where c.DEid = b.DEid
				  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"> 
				  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and a.AFTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AFTRid#">
				</cfquery>
				
				<!--- Si el responsable del centro de custodia es quien hace la transferencia
				pasa el traslado de una vez --->
				<cfif verResp.total gt 0 and ApbDirecta eq 1>
					<cfinvoke 
							component="sif.Componentes.AF_CambioResponsable"
							method="ProcesarMasivo"
							AFTRidlist="#AFTRid#"
							Estado="10"/>	
				</cfif>	
			</cfif>				
		</cfloop>	
		
		<cflock name="consecutivo" timeout="3" type="exclusive">
			<cfquery name="newLista" datasource="#session.dsn#">
				select coalesce(max(TConsecutivo),0)as Consecutivo
				from TransConsecutivo
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			
			<cfif newLista.Consecutivo neq ''>
				<cfset Cons = newLista.Consecutivo + 1>
			<cfelse>
				<cfset Cons = 1>
			</cfif>
		
			<cfquery name="insertConsecutivo" datasource="#session.dsn#">
				insert into TransConsecutivo 
				(
					TConsecutivo, 
					Ecodigo, 
					BMfecha, 
					BMUsucodigo,
					AFTRid
				)
				values
				(
					#Cons#,
					#session.Ecodigo#,
					#now()#,
					#session.Usucodigo#,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#AFTRid#">
				)
			</cfquery>
		</cflock>	
			
	<cfelse>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ErrorDebeDefinirCualesDocumentosDeseaTrasladarProcesoCancelado"
			Default="Error, debe definir cuales documentos desea trasladar, Proceso Cancelado"
			returnvariable="MSG_ErrorDebeDefinirCualesDocumentosDeseaTrasladarProcesoCancelado"/>
			
		<cfthrow message="#MSG_ErrorDebeDefinirCualesDocumentosDeseaTrasladarProcesoCancelado#">
		</cfif>
	</cfif>
<cfelseif isdefined("FORM.BTNRECIBIR")>
	<cfif isdefined("FORM.CHK")>
		<cfinvoke 
				component="sif.Componentes.AF_CambioResponsable"
				method="ProcesarMasivo"
				AFTRidlist="#form.chk#"
				Estado="10"/>
	<cfelse>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ErrorDebeDefinirCualesDocumentosDeseaRecibirProcesoCancelado"
			Default="Error, debe definir cuales documentos desea recibir, Proceso Cancelado"
			returnvariable="MSG_ErrorDebeDefinirCualesDocumentosDeseaRecibirProcesoCancelado"/>
		
		<cfthrow message="#MSG_ErrorDebeDefinirCualesDocumentosDeseaRecibirProcesoCancelado#">
	</cfif>
<cfelseif isdefined("FORM.BTNRECHAZAR")>
	<cfif isdefined("FORM.CHK")>
		<cfinvoke 
				component="sif.Componentes.AF_CambioResponsable"
				method="RechazarMasivo"
				AFTRidlist="#form.chk#"
				Estado="20"/>
	<cfelse>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ErrorDebeDefinirCualesDocumentosDeseaRechazarProcesoCancelado"
			Default="Error, debe definir cuales documentos desea rechazar, Proceso Cancelado"
			returnvariable="MSG_ErrorDebeDefinirCualesDocumentosDeseaRechazarProcesoCancelado"/>

		<cfthrow message="#MSG_ErrorDebeDefinirCualesDocumentosDeseaRechazarProcesoCancelado#">
	</cfif>
<cfelseif isdefined("FORM.ELIMINAR") AND LEN(TRIM(FORM.ELIMINAR)) GT 0 AND ISNUMERIC(FORM.ELIMINAR)>
	<cfquery datasource="#session.dsn#">
		delete from AFTResponsables
		where AFTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.ELIMINAR#">
		and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		and AFTRestado = 20
	</cfquery>
</cfif>
<cflocation url="traspaso_resposable-auto.cfm?#params#">

