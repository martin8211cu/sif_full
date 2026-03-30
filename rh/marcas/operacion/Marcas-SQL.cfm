<cfset modo = "ALTA">
<!--- Verificacion de si el usuario actual tiene derechos para generar marcas --->
<cfquery name="rsPermisoGenMarca" datasource="#Session.DSN#">
	select 1
	from DatosEmpleado a, LineaTiempo lt, RHPlazas r, RHProcesamientoMarcas b, RHUsuariosMarcas um
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and a.Ecodigo = lt.Ecodigo
		and a.DEid = lt.DEid
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta
		and lt.Ecodigo = r.Ecodigo
		and lt.RHPid = r.RHPid
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and b.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
		and b.Ecodigo = r.Ecodigo
		and b.CFid = r.CFid
		and b.Ecodigo = um.Ecodigo
		and b.CFid = um.CFid
		and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		and um.RHUMtmarcas = 1
</cfquery>

<cfif rsPermisoGenMarca.recordCount GT 0>
	<cfif not isdefined("Form.btnNuevo")>
		<cftransaction>
			<!--- Agregar Control de Marca --->
			<cfif isdefined("Form.Alta")>
				<!--- Averiguar Jornada del Empleado --->
				<cfquery name="rsJornada1" datasource="#Session.DSN#">
					select RHJid
					from RHPlanificador
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHCMfcapturada)#"> between RHPJfinicio and RHPJffinal
				</cfquery>
				<cfif rsJornada1.recordCount GT 0>
					<cfset jornada = rsJornada1.RHJid>
				<cfelse>
					<cfquery name="rsJornada2" datasource="#Session.DSN#">
						select RHJid
						from LineaTiempo
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHCMfcapturada)#"> between LTdesde and LThasta
					</cfquery>
					<cfset jornada = rsJornada2.RHJid>
				</cfif>
				
				<cfif isdefined("jornada") and Len(Trim(jornada))>
					<!-----=================== Hora de entrada ===================---->
					<cfif Form.RHCMhoraentradac3 eq 'PM' and Form.RHCMhoraentradac1 neq 12>
						<cfset Form.RHCMhoraentradac1 = Form.RHCMhoraentradac1 + 12 >
					</cfif>
					<cfif Form.RHCMhoraentradac3 eq 'AM' and form.RHCMhoraentradac1 eq 12>
						<cfset form.RHCMhoraentradac1 = 0 >
					</cfif>		
					<cfset vHEntrada = CreateDateTime(year(form.RHCMfcapturada),month(form.RHCMfcapturada), day(form.RHCMfcapturada), Form.RHCMhoraentradac1, Form.RHCMhoraentradac2, 0)>
					<!-----=================== Hora de salida ===================---->
					<cfif Form.RHCMhorasalidac3 eq 'PM' and Form.RHCMhorasalidac1 neq 12>
						<cfset Form.RHCMhorasalidac1 = Form.RHCMhorasalidac1 + 12 >
					</cfif>
					<cfif Form.RHCMhorasalidac3 eq 'AM' and form.RHCMhorasalidac1 eq 12>
						<cfset form.RHCMhorasalidac1 = 0 >
					</cfif>		
					<cfset vHSalida = CreateDateTime(year(form.RHCMfcapturada),month(form.RHCMfcapturada), day(form.RHCMfcapturada), Form.RHCMhorasalidac1, Form.RHCMhorasalidac2, 0)>					
					<cfif datecompare(vHEntrada, vHSalida) eq 1>
						<cfset vHSalida = dateadd('d', 1, vHSalida ) >
					</cfif>
					<cfquery name="ABC_ControlMarca" datasource="#Session.DSN#">
						<!----
						declare @hentrada varchar(100), @hsalida varchar(100)
						select @hentrada = convert(varchar, convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCMfcapturada#">, 103), 106) || ' #Form.RHCMhoraentradac1#:#Form.RHCMhoraentradac2##Form.RHCMhoraentradac3#',
							   @hsalida = convert(varchar, convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCMfcapturada#">, 103), 106) || ' #Form.RHCMhorasalidac1#:#Form.RHCMhorasalidac2##Form.RHCMhorasalidac3#'
						if convert(datetime, @hentrada) > convert(datetime, @hsalida) select @hsalida = dateadd(dd, 1, @hsalida)
						----->
						insert RHControlMarcas (RHPMid, DEid, RHCMfcapturada, RHJid, RHCMhoraentradac, RHCMhorasalidac, RHCMtiempoefect, RHCMusuario, RHCMjustificacion, RHCMusuarioautor, RHCMhorasadicautor, RHCMhorasrebajar, RHCMdialibre, RHASid, BMUsucodigo, BMfecha, BMfmod)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHCMfcapturada)#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#jornada#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vHEntrada#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vHSalida#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#DateDiff('n',vHEntrada,vHSalida)#">,
							<!---@hentrada,
							@hsalida,
							datediff(mi, @hentrada, @hsalida),---->
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCMjustificacion#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfif isdefined("Form.RHCMhorasadicautor") and Len(Trim(Form.RHCMhorasadicautor))>
								<cfqueryparam cfsqltype="cf_sql_float" value="#Form.RHCMhorasadicautor#">,
							<cfelse>
								null,
							</cfif>
							<cfif isdefined("Form.RHCMhorasrebajar") and Len(Trim(Form.RHCMhorasrebajar))>
								<cfqueryparam cfsqltype="cf_sql_float" value="#Form.RHCMhorasrebajar#">,
							<cfelse>
								null,
							</cfif>
							<cfif isdefined("Form.RHCMdialibre")>1<cfelse>0</cfif>,
							<cfif isdefined("Form.RHASid") and Len(Trim(Form.RHASid))>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">,
							<cfelse>
								null,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)
						<cf_dbidentity1 datasource="#Session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_ControlMarca">

					<cfif isdefined('ABC_ControlMarca')>
						<cfset form.RHCMid = ABC_ControlMarca.identity>					
					</cfif>
				<cfelse>
					<!--- Enviar Error porque el Empleado no está nombrado --->
				</cfif>
			<!--- Actualizar Accion a Seguir --->
			<cfelseif isdefined("Form.Cambio")>															
				<!--- Averiguar Jornada del Empleado --->
				<cfquery name="rsJornada1" datasource="#Session.DSN#">
					select RHJid
					from RHPlanificador
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.RHCMfcapturada#"> between RHPJfinicio and RHPJffinal
				</cfquery>
				<cfif rsJornada1.recordCount GT 0>
					<cfset jornada = rsJornada1.RHJid>
				<cfelse>
					<cfquery name="rsJornada2" datasource="#Session.DSN#">
						select RHJid
						from LineaTiempo
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.RHCMfcapturada#"> between LTdesde and LThasta
					</cfquery>
					<cfset jornada = rsJornada2.RHJid>
				</cfif>
								
				<!-----=================== Hora de entrada ===================---->
				<cfif Form.RHCMhoraentradac3 eq 'PM' and Form.RHCMhoraentradac1 neq 12>
					<cfset Form.RHCMhoraentradac1 = Form.RHCMhoraentradac1 + 12 >
				</cfif>
				<cfif Form.RHCMhoraentradac3 eq 'AM' and form.RHCMhoraentradac1 eq 12>
					<cfset form.RHCMhoraentradac1 = 0 >
				</cfif>		
				<cfset vHEntrada = CreateDateTime(year(form.RHCMfcapturada),month(form.RHCMfcapturada), day(form.RHCMfcapturada), Form.RHCMhoraentradac1, Form.RHCMhoraentradac2, 0)>
				<!-----=================== Hora de salida ===================---->
				<cfif Form.RHCMhorasalidac3 eq 'PM' and Form.RHCMhorasalidac1 neq 12>
					<cfset Form.RHCMhorasalidac1 = Form.RHCMhorasalidac1 + 12 >
				</cfif>
				<cfif Form.RHCMhorasalidac3 eq 'AM' and form.RHCMhorasalidac1 eq 12>
					<cfset form.RHCMhorasalidac1 = 0 >
				</cfif>		
				<cfset vHSalida = CreateDateTime(year(form.RHCMfcapturada),month(form.RHCMfcapturada), day(form.RHCMfcapturada), Form.RHCMhorasalidac1, Form.RHCMhorasalidac2, 0)>					
				<cfif datecompare(vHEntrada, vHSalida) eq 1>
					<cfset vHSalida = dateadd('d', 1, vHSalida ) >
				</cfif>			
					
				<cfquery name="ABC_ControlMarca" datasource="#Session.DSN#">
					<!----
					declare @hentrada varchar(100), @hsalida varchar(100)
					select @hentrada = convert(varchar, convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCMfcapturada#">, 103), 106) || ' #Form.RHCMhoraentradac1#:#Form.RHCMhoraentradac2##Form.RHCMhoraentradac3#',
						   @hsalida = convert(varchar, convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCMfcapturada#">, 103), 106) || ' #Form.RHCMhorasalidac1#:#Form.RHCMhorasalidac2##Form.RHCMhorasalidac3#'
					if convert(datetime, @hentrada) > convert(datetime, @hsalida) select @hsalida = dateadd(dd, 1, @hsalida)
					----->					
					update RHControlMarcas set 
						RHCMfcapturada = convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCMfcapturada#">, 103), 
						RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#jornada#">,
						RHCMhoraentradac = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vHEntrada#">,	<!----@hentrada,---->
						RHCMhorasalidac = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vHSalida#">,	<!----@hsalida,----->
						RHCMtiempoefect = <cfqueryparam cfsqltype="cf_sql_integer" value="#DateDiff('n',vHEntrada,vHSalida)#">,	<!----datediff(mi, @hentrada, @hsalida),---->
						RHCMusuario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						RHCMjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCMjustificacion#">,
						RHCMusuarioautor = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfif isdefined("Form.RHCMhorasadicautor") and Len(Trim(Form.RHCMhorasadicautor))>
							RHCMhorasadicautor = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.RHCMhorasadicautor#">,
						<cfelse>
							RHCMhorasadicautor = null,
						</cfif>
						<cfif isdefined("Form.RHCMhorasrebajar") and Len(Trim(Form.RHCMhorasrebajar))>
							RHCMhorasrebajar = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.RHCMhorasrebajar#">,
						<cfelse>
							RHCMhorasrebajar = null,
						</cfif>
						<cfif isdefined("Form.RHCMdialibre")>
							RHCMdialibre = 1
						<cfelse>
							RHCMdialibre = 0
						</cfif>,
						<cfif isdefined("Form.RHCMinconsistencia")>
							RHCMinconsistencia = 1
						<cfelse>
							RHCMinconsistencia = 0
						</cfif>,
						<cfif isdefined("Form.RHASid") and Len(Trim(Form.RHASid))>
							RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">,
						<cfelse>
							RHASid = null,
						</cfif>
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						BMfmod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					where RHPMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
					  and RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
					  and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				</cfquery>

	<!----********************************* MODIFICACIONES 09-02-2006 *************************************---->
	<!---====================================================================================  
			Archivo para verificar y generar incidencias por excepciones
	 ========================================================================================  ---->
		<!----<cfinclude template="verificaExcepciones.cfm">--->
		<cfinclude template="GenerarDetalle.cfm">
		<cfinclude template="modificaResultado.cfm">	<!----==== Consume las incidencias generadas según la cantidad de horas adicionales o a rebajar ======= --->
	<!---====================================================================================  
								INCIDENCIAS POR DIA EXTRA 
			Siempre y cuando se haya quitado el check de inconsistencia y 
			se hayan indicado horas adicionales para la marca.  Si las horas 
			adicionales son menos que las trabajadas se asignan las adicionales
			o viceversa.
		==================================================================================== ---->		
		<cfif not isdefined("form.RHCMinconsistencia") and isdefined("form.RHCMhorasadicautor") and form.RHCMhorasadicautor GT 0>
			<cfquery name="rsDiaExtra" datasource="#session.DSN#">
				insert into RHDetalleIncidencias (RHCMid, 
												RHPMid, 
												CIid, 
												RHDMhorascalc, 
												RHDMhorasautor, 
												BMUsucodigo, 
												BMfecha, 
												BMfmod)
				select 	b.RHCMid, 
						b.RHPMid,
						c.CIid,												
						(datediff(mi, convert(varchar,b.RHCMhoraentradac, 108), convert(varchar,b.RHCMhorasalidac, 108))/60) as RHDMhorascalc,
						case when (datediff(mi, convert(varchar,b.RHCMhoraentradac, 108), convert(varchar,b.RHCMhorasalidac, 108))/60) < <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHCMhorasadicautor#"> then
							 (datediff(mi, convert(varchar,b.RHCMhoraentradac, 108), convert(varchar,b.RHCMhorasalidac, 108))/60)
						else
					 		<cfqueryparam cfsqltype="cf_sql_float" value="#form.RHCMhorasadicautor#">
						end as RHDMhorasautor,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				
				from RHJornadas a
					inner join RHControlMarcas b
						on b.RHJid = a.RHJid
					
					inner join RHExcepcionesJornada c
						on b.RHJid = c.RHJid		
						and substring(convert(varchar, c.RHEJdomingo)+
								convert(varchar, c.RHEJlunes)+
								convert(varchar, c.RHEJmartes)+
								convert(varchar, c.RHEJmiercoles)+
								convert(varchar, c.RHEJjueves)+
								convert(varchar, c.RHEJviernes)+
								convert(varchar, c.RHEJsabado), 
								datepart(dw, b.RHCMfcapturada), 1) = '1'
						and convert(varchar,b.RHCMhoraentradac,108) >= convert(varchar,c.RHEJhorainicio,108)
						and convert(varchar,b.RHCMhoraentradac,108) <= convert(varchar,c.RHEJhorafinal,108)
				
				where b.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
					and b.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and substring(convert(varchar, RHJsun)+
								convert(varchar, RHJmon)+
								convert(varchar, RHJtue)+
								convert(varchar, RHJwed)+
								convert(varchar, RHJthu)+
								convert(varchar, RHJfri)+
								convert(varchar, RHJsat), datepart(dw, b.RHCMfregistro), 1) = '0'
			</cfquery>				
		</cfif>
	<!---****************************************************************************----->				
	
			<!--- Borrar una Jornada --->
			<cfelseif isdefined("Form.Baja")>
				<cfquery name="eliminaInconsistencias" datasource="#session.DSN#">
					delete from RHInconsistencias
					where RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
				</cfquery>
				<cfquery name="eliminaInconsistencias" datasource="#session.DSN#">
					delete from RHDetalleIncidencias
					where RHPMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
					  and RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
				</cfquery>
				<cfquery name="ABC_ControlMarca" datasource="#Session.DSN#">
					delete from RHControlMarcas
					where RHPMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
					  and RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
					  and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				</cfquery>
			</cfif>
		</cftransaction>
	</cfif>	
</cfif>

<cfoutput>
<form action="Marcas.cfm" method="post" name="sql">
	<cfif isdefined("Form.RHPMid") and Len(Trim(Form.RHPMid))>
		<input name="RHPMid" type="hidden" value="#Form.RHPMid#">
	</cfif>
	<cfif isdefined("Form.RHCMid") and Len(Trim(Form.RHCMid)) and not isdefined('form.Baja') and not isdefined('form.Nuevo')>
		<input name="RHCMid" type="hidden" value="#Form.RHCMid#">
	</cfif>	
	
	<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
		<input name="DEid" type="hidden" value="#Form.DEid#">
	</cfif>
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
