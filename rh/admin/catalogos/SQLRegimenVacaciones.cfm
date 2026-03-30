<!--- Consultas Originales
insert into RegimenVacaciones (Ecodigo, RVcodigo, Descripcion, RVfecha, Usucodigo, Ulocalizacion) values (Ecodigo, RVcodigo, Descripcion, RVfecha, Usucodigo, Ulocalizacion)
insert into DRegimenVacaciones (RVid, DRVcant, DRVdias, Usucodigo, Ulocalizacion) values (RVid, DRVcant, DRVdias, Usucodigo, Ulocalizacion)

update RegimenVacaciones set RVcodigo = RVcodigo, Descripcion = Descripcion, RVfecha = RVfecha, Usucodigo = Usucodigo, Ulocalizacion = Ulocalizacion where RVid = 9999
update DRegimenVacaciones set RVid = RVid, DRVcant = DRVcant, DRVdias = DRVdias, Usucodigo = Usucodigo, Ulocalizacion = Ulocalizacion where DRVlinea = 9999

delete from RegimenVacaciones where RVid = 9999
delete from DRegimenVacaciones where DRVlinea = 9999

select convert(varchar,RVid) as RVid, Ecodigo, RVcodigo, Descripcion, RVfecha, Usucodigo, Ulocalizacion, ts_rversion from RegimenVacaciones where RVid = 9999
select convert(varchar,DRVlinea) as DRVlinea, RVid, DRVcant, DRVdias, Usucodigo, Ulocalizacion, ts_rversion from DRegimenVacaciones where DRVlinea = 9999
--->

<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 12 de diciembre del 2005
	Motivo: agregar un nuevo campo en el catalogo, dias de verificacion de compensacion.
 --->

<cfinvoke key="LB_Existen_datos_asociados_a_este_tipo_de_regimen_de_vacaciones,_por_lo_tanto_no_puede_ser_borrado." default="Existen datos asociados a este tipo de regimen de vacaciones, por lo tanto no puede ser borrado. " returnvariable="LB_ErrorRV" component="sif.Componentes.Translate" method="Translate"/>	

<cfif not isdefined("Form.Nuevo")>
	<cftry>
	<cftransaction>
<!--- 		<cfquery name="rsRV" datasource="#Session.DSN#"> --->
			<cfset modo = "CAMBIO"><!--- modo default después del Alta, solo es diferente en Nuevo. --->
			<cfset dmodo = "ALTA"><!--- dmodo default, solo es diferente al click en la lista y no pasa por aquí. --->
			<cfif Form.Accion eq 'Alta'>
				<cfquery name="InsertRegimenVacaciones" datasource="#session.DSN#">
					insert into RegimenVacaciones( Ecodigo, RVcodigo, Descripcion, RVfecha, Usucodigo, Ulocalizacion )
					values 
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RVcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">, 
						<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">)
						<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="InsertRegimenVacaciones">
				<cfset form.RVid = InsertRegimenVacaciones.identity>
				<cfset modo = "CAMBIO">
			<cfelseif Form.Accion eq 'Baja'>
				<cftry>
				
						<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
									<cfinvokeargument  name="nombreTabla" value="DRegimenVacaciones">		
									<cfinvokeargument name="condicion" value="RVid = #form.RVid#">
									<cfinvokeargument name="necesitaTransaccion" value="false">
						</cfinvoke>
						
						<cfquery name="DeleteDRegimenVacaciones" datasource="#session.DSN#">
							delete from DRegimenVacaciones 
							where RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RVid#">
						</cfquery>
						
						<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
									<cfinvokeargument  name="nombreTabla" value="RegimenVacaciones">		
									<cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo# and RVid = #form.RVid#">
									<cfinvokeargument name="necesitaTransaccion" value="false">
						</cfinvoke>
						
						<cfquery name="DeleteRegimenVacaciones"	datasource="#session.DSN#">
							delete from RegimenVacaciones 
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RVid#">				
						</cfquery>
						<cfcatch type="any">
						<cf_throw message="#LB_ErrorRV#" errorcode="56">
					 </cfcatch>
				</cftry>
				
				<cfset modo = "ALTA">
			<cfelseif Form.Accion eq 'Cambio'>
				<cf_dbtimestamp
					datasource="#session.DSN#"
					table="RegimenVacaciones"
					redirect="formRegimeVacaciones.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo" type1="numeric" value1="#session.Ecodigo#"
					field2="RVid" type2="numeric" value2="#Form.RVid#">

				<cfquery name="UpdateRegimenVacaciones" datasource="#session.DSN#">
					update RegimenVacaciones 
						set RVcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RVcodigo#">,  
						Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">, 
						RVfecha = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">, 
						Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#"> 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RVid#">
				</cfquery>
			<cfelseif Form.Accion eq 'AltaDetalle'>
				<cf_dbtimestamp
					datasource="#session.DSN#"
					table="RegimenVacaciones"
					redirect="formRegimeVacaciones.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo" type1="numeric" value1="#session.Ecodigo#"
					field2="RVid" type2="numeric" value2="#Form.RVid#">			
				<cfquery name="UpdateRegimenVacaciones" datasource="#session.DSN#">
					update RegimenVacaciones 
						set Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">,
							RVcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RVcodigo#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RVid#">
				</cfquery>
				<cfquery name="InsertDRegimenVacaciones" datasource="#session.DSN#">
					insert into DRegimenVacaciones 
						(RVid, DRVcant, DRVdias, DRVdiasadic, DRcantcomp, DRVdiasenf, DRVdiasvericomp, DRVdiasgratifica, DRVdiasprima, Usucodigo, Ulocalizacion) 
					values 
						(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RVid#">, 
						<cfqueryparam cfsqltype="cf_sql_float" value="#Form.DRVcant#">, 
						<cfqueryparam cfsqltype="cf_sql_float" value="#Form.DRVdias#">, 
						<cfqueryparam cfsqltype="cf_sql_float" value="#Form.DRVdiasadic#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DRcantcomp#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DRVdiasenf#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#Form.DRVdiasvericomp#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#Form.DRVdiasgratifica#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#Form.DRVdiasprima#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">)
				</cfquery>
			<cfelseif Form.Accion eq 'BajaDetalle'>
				<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
							<cfinvokeargument  name="nombreTabla" value="DRegimenVacaciones">		
							<cfinvokeargument name="condicion" value="RVid = #form.RVid# and DRVlinea = #Form.DRVlinea#">
							<cfinvokeargument name="necesitaTransaccion" value="false">
				</cfinvoke>
				<cfquery name="DeleteDRegimenVacaciones" datasource="#session.DSN#">
					delete from DRegimenVacaciones 
					where RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RVid#">
					and DRVlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DRVlinea#">
				</cfquery>
			<cfelseif Form.Accion eq 'CambioDetalle'>
				<cf_dbtimestamp
					datasource="#session.DSN#"
					table="RegimenVacaciones"
					redirect="formRegimeVacaciones.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo" type1="numeric" value1="#session.Ecodigo#"
					field2="RVid" type2="numeric" value2="#Form.RVid#">								
				<cfquery name="UpdateRegimenVacaciones" datasource="#session.DSN#">
					update RegimenVacaciones 
						set Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">,
							RVcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RVcodigo#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RVid#">
				</cfquery>
				<cfquery name="UpdateDRegimenVacaciones" datasource="#session.DSN#">
					update DRegimenVacaciones 
						set DRVcant = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DRVcant#">, 
						DRVdias = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DRVdias#">, 
						DRVdiasadic = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DRVdiasadic#">, 
						DRcantcomp = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DRcantcomp#">,
						DRVdiasenf = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DRVdiasenf#">,
						DRVdiasvericomp = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DRVdiasvericomp#">,
						DRVdiasgratifica = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DRVdiasgratifica#">,
						DRVdiasprima = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DRVdiasprima#">,
						Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#"> 
					where RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RVid#">
					and DRVlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DRVlinea#">
				</cfquery>
			</cfif>
<!--- 		</cfquery> --->
	</cftransaction>
	<cfcatch type="database">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="RegimenVacaciones.cfm" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	<cfelse>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
		<input name="RVid" type="hidden" value="<cfif isdefined("Form.RVid")><cfoutput>#Form.RVid#</cfoutput></cfif>">
	</cfif>
	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>