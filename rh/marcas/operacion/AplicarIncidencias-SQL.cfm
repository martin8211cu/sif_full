<!--- Parametros Generales --->
<cfquery name="verifica_Parametro" datasource="#session.dsn#">
	select 1 from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 480
	and Pvalor = '1'
</cfquery>

<cfif isdefined("Form.RHPMid") and Len(Trim(Form.RHPMid))>
	<cfsetting requesttimeout="#3600*24#">
	<!--- Verificacion de si el usuario actual tiene derechos para aplicar incidencias --->
	<cfquery name="rsPermisoGenIncidencias" datasource="#Session.DSN#">
		select  b.CFid	
			, um.RHTidtramite
			, um.Usucodigo
		from RHProcesamientoMarcas b
			inner join RHUsuariosMarcas um
				on 	um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					and um.RHUMgincidencias = 1
					and um.Ecodigo = b.Ecodigo
					and b.CFid = um.CFid

		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and b.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	</cfquery>
	
	<cfif rsPermisoGenIncidencias.recordCount GT 0>
		<cftransaction>
			<!--- Chequear que todas las marcas hayan sido revisadas antes de continuar --->
			<!--- Deberia chequearse que todas las horas autorizadas hayan sido agregadas en el detalle --->
			<cfquery name="rsCheck" datasource="#Session.DSN#">
				select count(1) as cant
				from RHControlMarcas a
				where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
				and a.RHCMinconsistencia = 1
			</cfquery>

			<cfif rsCheck.cant EQ 0>
				<cfset fecha = Now()>
				
				<cfif verifica_parametro.recordcount GT 0>
					<cfquery name="rsGeneracion" datasource="#Session.DSN#">
						insert IncidenciasMarcas
							(DEid, CIid, Ifecha,
						 	Ivalor, Ifechasis, Usucodigo,
						 	Ulocalizacion, RHCMid, RHPMid, RHDMid)
						select
							b.DEid, c.CIid, b.RHCMfcapturada,
							c.RHDMhorasautor, 
							<cfqueryparam cfsqltype="cf_sql_date" value="#fecha#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							 '00', c.RHCMid, c.RHPMid, c.RHDMid
						from RHProcesamientoMarcas a, RHControlMarcas b, RHDetalleIncidencias c
						where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
							and b.RHPMid = a.RHPMid
							and b.RHCMinconsistencia = 0
							and c.RHCMid = b.RHCMid
					</cfquery>							
					
					<cfquery datasource="#Session.DSN#">
						update RHProcesamientoMarcas
						set RHPMfcierre = <cfqueryparam cfsqltype="cf_sql_date" value="#fecha#">
						where RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
					</cfquery>
				<cfelse>
					<!--- Iniciar trámite solamente si no ha sido iniciado --->
					<cfif rsPermisoGenIncidencias.RHTidtramite NEQ ''>
						<cfset fecha = Now()>
						<!--- 	Este Insert es para poder ver la lista de incidencias de los empleados del Lote de marcas
								para poder aprobar o no cada uno de los tipos de horas incidentes en el boton del detalle del tramite --->
						<cfquery name="rsGeneracion" datasource="#Session.DSN#">
							insert IncidenciasMarcas
								(DEid, CIid, Ifecha,
								Ivalor, Ifechasis, Usucodigo,
								Ulocalizacion, RHCMid, RHPMid, RHDMid)
							select
								b.DEid, c.CIid, b.RHCMfcapturada,
								c.RHDMhorasautor, 
								<cfqueryparam cfsqltype="cf_sql_date" value="#fecha#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								 '00', c.RHCMid, c.RHPMid, c.RHDMid
							from RHProcesamientoMarcas a, RHControlMarcas b, RHDetalleIncidencias c
							where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
								and b.RHPMid = a.RHPMid
								and b.RHCMinconsistencia = 0
								and c.RHCMid = b.RHCMid
						</cfquery>						
					
						<cfset dataItems = StructNew()>
						<cfset dataItems.RHPMid        	= Form.RHPMid>
						<cfset dataItems.Ecodigo       	= session.Ecodigo>
						<cfset descripcion_tramite     = "Aprobaci&oacute;n de Lote de Marcas N° " &  Form.RHPMid>

						<!--- estas dos acciones tienen que estar en una transaccion --->
						<cfinvoke component="sif.Componentes.Workflow.Management" method="startProcess" returnvariable="processInstanceId"
							ProcessId="#rsPermisoGenIncidencias.RHTidtramite#"
							RequesterId="#session.usucodigo#"
							SubjectId="#rsPermisoGenIncidencias.Usucodigo#"
							Description="#descripcion_tramite#"
							DataItems="#dataItems#"
							TransaccionActiva="yes">
						</cfinvoke>
		
						<cfquery datasource="#Session.DSN#">
							update RHProcesamientoMarcas
							set RHPMfcierre = <cfqueryparam cfsqltype="cf_sql_date" value="#fecha#">
							where RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
						</cfquery>
					<cfelse>	<!--- Si el Usuario NO tiene tramite asociado --->
						<cfquery name="rsGeneracion" datasource="#Session.DSN#">
							insert IncidenciasMarcas
								(DEid, CIid, Ifecha,
								Ivalor, Ifechasis, Usucodigo,
								Ulocalizacion, RHCMid, RHPMid, RHDMid)
							select
								b.DEid, c.CIid, b.RHCMfcapturada,
								c.RHDMhorasautor, 
								<cfqueryparam cfsqltype="cf_sql_date" value="#fecha#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								 '00', c.RHCMid, c.RHPMid, c.RHDMid
							from RHProcesamientoMarcas a, RHControlMarcas b, RHDetalleIncidencias c
							where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
								and b.RHPMid = a.RHPMid
								and b.RHCMinconsistencia = 0
								and c.RHCMid = b.RHCMid
						</cfquery>							
						
						<cfquery datasource="#Session.DSN#">
							update RHProcesamientoMarcas
							set RHPMfcierre = <cfqueryparam cfsqltype="cf_sql_date" value="#fecha#">
							where RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
						</cfquery>						
					</cfif>
				</cfif>
			</cfif>
		</cftransaction>
	</cfif>
	
</cfif>

<cfoutput>
<form action="ProcesamientoMarcas.cfm" method="post" name="sql">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
