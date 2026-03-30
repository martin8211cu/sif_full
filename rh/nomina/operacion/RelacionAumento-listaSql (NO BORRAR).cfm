<cfif isdefined("Form.btnAplicar")>
	<cfset action = "RelacionAumento-lista.cfm">
<cfelseif isdefined("Form.btnImportar")>
	<cfset action = "RelacionAumento-import.cfm">
<cfelse>
	<cfset action = "RelacionAumento.cfm">
</cfif>

<cfif isdefined("Form.btnAplicar")>
	<cftry>
		<cfif isdefined("Form.chk") and Len(Trim(Form.chk)) NEQ 0>
			<cfset lotesid = ListToArray(Replace(Form.chk,' ', '', 'all'),',')>
			<cfloop index="i" from="1" to="#ArrayLen(lotesid)#">
				<cfset lote = lotesid[i]>
				<!--- Chequea que no haya mas de un aumento para un empleado en el mismo lote --->
				<cfquery name="rsChequear" datasource="#Session.DSN#">
					select count(count(1)) as cant
					from RHDAumentos x, RHEAumentos y
					where x.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and x.RHAid = y.RHAid
					and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					group by x.DEidentificacion
					having count(1) > 1
				</cfquery>
				<!--- Chequear saldos válidos --->
				<cfquery name="rsChequearSaldos" datasource="#Session.DSN#">
					select 
						x.DEidentificacion as Identificacion, 
						e.DEapellido1 || ' ' || e.DEapellido2 || ', ' || e.DEnombre as Nombre, 
						x.RHDvalor
					from RHDAumentos x, RHEAumentos y, DatosEmpleado e
					where x.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and y.RHAid = x.RHAid
					and e.DEidentificacion = x.DEidentificacion
					and e.Ecodigo = y.Ecodigo
					and x.RHDvalor < 0
				</cfquery>
				<cfif rsChequear.cant GT 0>
					<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('Existen mas de 1 aumento para el mismo empleado en el Lote #lote#. Proceso cancelado a partir de este lote.')#" addtoken="no">
					<cfabort>
				<cfelseif rsChequearSaldos.recordCount GT 0>
					<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('Los saldos no pueden ser negativos')#" addtoken="no">
					<cfabort>
				<cfelse>
					<!--- Ejecutar el código de la aplicación de los lotes de aumentos salariales --->
					<cfquery name="rsAplicar" datasource="#Session.DSN#">
						-- Inserción de Encabezado de Linea del Tiempo
						insert LineaTiempo (DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, RHJid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal, CPid)
						select d.DEid, d.Ecodigo, d.Tcodigo, d.RHTid, d.Ocodigo, d.Dcodigo, d.RHPid, d.RHPcodigo, d.RVid, d.RHJid, a.RHAfdesde, d.LThasta, d.LTporcplaza, d.LTsalario, d.LTporcsal, null
						from RHEAumentos a, RHDAumentos b, DatosEmpleado c, LineaTiempo d
						where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.RHAid = b.RHAid
						and a.Ecodigo = c.Ecodigo
						and b.NTIcodigo = c.NTIcodigo
						and b.DEidentificacion = c.DEidentificacion
						and c.DEid = d.DEid
						and c.Ecodigo = d.Ecodigo
						and a.RHAfdesde between d.LTdesde and d.LThasta
						and not exists(
						select 1
						from LineaTiempo l
						where l.Ecodigo = a.Ecodigo
						and l.LTdesde = a.RHAfdesde
						and l.DEid = c.DEid
						)
						
						-- Insercion del detalle de la Linea del Tiempo
						insert DLineaTiempo (LTid, CSid, DLTmonto, DLTunidades, DLTtabla)
						select e.LTid, f.CSid, f.DLTmonto, f.DLTunidades, f.DLTtabla
						from RHEAumentos a, RHDAumentos b, DatosEmpleado c, LineaTiempo d, LineaTiempo e, DLineaTiempo f
						where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.RHAid = b.RHAid
						and a.Ecodigo = c.Ecodigo
						and b.NTIcodigo = c.NTIcodigo
						and b.DEidentificacion = c.DEidentificacion
						and c.DEid = d.DEid
						and c.Ecodigo = d.Ecodigo
						and a.RHAfdesde between d.LTdesde and d.LThasta
						and a.RHAfdesde != d.LTdesde
						and c.DEid = e.DEid
						and c.Ecodigo = e.Ecodigo
						and a.RHAfdesde between e.LTdesde and e.LThasta
						and a.RHAfdesde = e.LTdesde
						and d.LTid = f.LTid
						
						-- Actualizacion de la fecha hasta en los cortes anteriores al insertado en la linea del tiempo
						update LineaTiempo
						set LThasta = dateadd(dd, -1, a.RHAfdesde)
						from RHEAumentos a, RHDAumentos b, DatosEmpleado c, LineaTiempo d
						where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.RHAid = b.RHAid
						and a.Ecodigo = c.Ecodigo
						and b.NTIcodigo = c.NTIcodigo
						and b.DEidentificacion = c.DEidentificacion
						and c.DEid = d.DEid
						and c.Ecodigo = d.Ecodigo
						and a.RHAfdesde between d.LTdesde and d.LThasta
						and a.RHAfdesde != d.LTdesde
						
						-- Insercion en DLaboralesEmpleado
						insert DLaboralesEmpleado (
								DLconsecutivo, DEid, RHTid, Ecodigo, RHPid, RHPcodigo, Tcodigo, RVid, Dcodigo, Ocodigo, RHJid, 
								DLfvigencia, DLffin, DLsalario, DLobs, DLfechaaplic, Usucodigo, Ulocalizacion, DLporcplaza, DLporcsal,
								Dcodigoant, Ocodigoant, RHPidant, RHPcodigoant, Tcodigoant, DLsalarioant, RVidant, DLporcplazaant, DLporcsalant, RHJidant)
						select -1, d.DEid, d.RHTid, d.Ecodigo, d.RHPid, d.RHPcodigo, d.Tcodigo, d.RVid, d.Dcodigo, d.Ocodigo, d.RHJid, 
								d.LTdesde, (case when d.LThasta != '61000101' then d.LThasta else null end), d.LTsalario + b.RHDvalor, 
								'Aumento Salarial', getDate(), <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, d.LTporcplaza, d.LTporcsal,
								d.Dcodigo, d.Ocodigo, d.RHPid, d.RHPcodigo, d.Tcodigo, d.LTsalario, d.RVid, d.LTporcplaza, d.LTporcsal, d.RHJid
						from RHEAumentos a, RHDAumentos b, DatosEmpleado c, LineaTiempo d
						where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.RHAid = b.RHAid
						and a.Ecodigo = c.Ecodigo
						and b.NTIcodigo = c.NTIcodigo
						and b.DEidentificacion = c.DEidentificacion
						and c.DEid = d.DEid
						and c.Ecodigo = d.Ecodigo
						and a.RHAfdesde between d.LTdesde and d.LThasta
						and a.RHAfdesde = d.LTdesde
						
						-- Insercion en DDLaboralesEmpleado
						insert DDLaboralesEmpleado (DLlinea, CSid, DDLtabla, DDLunidad, DDLmontobase, DDLmontores, Usucodigo, Ulocalizacion, DDLunidadant, DDLmontobaseant, DDLmontoresant)
						select f.DLlinea, e.CSid, e.DLTtabla, e.DLTunidades, 
								e.DLTmonto + (case when g.CSsalariobase = 1 then b.RHDvalor else 0.00 end),
								e.DLTmonto + (case when g.CSsalariobase = 1 then b.RHDvalor else 0.00 end),
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
								e.DLTunidades, e.DLTmonto, e.DLTmonto
						from RHEAumentos a, RHDAumentos b, DatosEmpleado c, LineaTiempo d, DLineaTiempo e, DLaboralesEmpleado f, ComponentesSalariales g
						where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.RHAid = b.RHAid
						and a.Ecodigo = c.Ecodigo
						and b.NTIcodigo = c.NTIcodigo
						and b.DEidentificacion = c.DEidentificacion
						and c.DEid = d.DEid
						and c.Ecodigo = d.Ecodigo
						and a.RHAfdesde between d.LTdesde and d.LThasta
						and a.RHAfdesde = d.LTdesde
						and d.LTid = e.LTid
						and c.DEid = f.DEid
						and c.Ecodigo = f.Ecodigo
						and f.DLconsecutivo = -1
						and e.CSid = g.CSid
						
						-- Actualizacion del Consecutivo en DLaboralesEmpleado
						declare @cont numeric
						select @cont = isnull(max(DLconsecutivo)+1, 1)
						from DLaboralesEmpleado
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						
						update DLaboralesEmpleado
						set DLconsecutivo = @cont, @cont = @cont + 1
						where DLconsecutivo = -1
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						
						-- Actualizacion del calendario de pago y monto de los salarios en la linea del tiempo a partir de la fecha en que rige el aumento
						update LineaTiempo
						   set CPid = e.CPid,
								LTsalario = LTsalario + b.RHDvalor
						from RHEAumentos a, RHDAumentos b, DatosEmpleado c, LineaTiempo d, CalendarioPagos e
						where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.RHAid = b.RHAid
						and a.Ecodigo = c.Ecodigo
						and b.NTIcodigo = c.NTIcodigo
						and b.DEidentificacion = c.DEidentificacion
						and c.DEid = d.DEid
						and c.Ecodigo = d.Ecodigo
						and a.RHAfdesde <= d.LTdesde
						and d.Ecodigo = e.Ecodigo
						and d.Tcodigo = e.Tcodigo
						and e.CPfcalculo is null
						and e.CPdesde = (
							select min(CPdesde) 
							from CalendarioPagos z
							where e.Ecodigo = z.Ecodigo
							and e.Tcodigo = z.Tcodigo
							and z.CPfcalculo is null
						)
						
						-- Actualizacion del salario base en los componentes a partir de la fecha en que rige el aumento
						update DLineaTiempo
						   set DLTmonto = DLTmonto + b.RHDvalor
						from RHEAumentos a, RHDAumentos b, DatosEmpleado c, LineaTiempo d, DLineaTiempo e, ComponentesSalariales f
						where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.RHAid = b.RHAid
						and a.Ecodigo = c.Ecodigo
						and b.NTIcodigo = c.NTIcodigo
						and b.DEidentificacion = c.DEidentificacion
						and c.DEid = d.DEid
						and c.Ecodigo = d.Ecodigo
						and a.RHAfdesde <= d.LTdesde
						and d.LTid = e.LTid
						and e.CSid = f.CSid
						and f.CSsalariobase = 1
						
						-- Actualizacion del estado del lote de aumentos
						update RHEAumentos
						set RHAestado = 1
						where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>

	<cfcatch type="any">
		<cftransaction action="rollback">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>

</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Form.RHAid") and Len(Trim(Form.RHAid)) NEQ 0>
		<input name="RHAid" type="hidden" value="<cfoutput>#Form.RHAid#</cfoutput>"> 
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
