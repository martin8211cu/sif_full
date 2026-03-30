<cfsilent>

<cfif isdefined("url.btnFiltrar")>
	<cfset form.btnFiltrar = url.btnFiltrar>
</cfif>
<cfif isdefined("url.visualizar") and len(trim(url.visualizar)) and not isdefined("form.visualizar")>
	<cfset form.visualizar = url.visualizar>	
</cfif>
<cfif isdefined("url.DEid") and len(trim(url.DEid)) and not isdefined("form.DEid")>
	<cfset form.DEid = url.DEid>	
</cfif>
<cfif isdefined("url.RHJid") and len(trim(url.RHJid)) and not isdefined("form.RHJid")>
	<cfset form.RHJid = url.RHJid>	
</cfif>
<cfif isdefined("url.Grupo") and len(trim(url.Grupo)) and not isdefined("form.Grupo")>
	<cfset form.Grupo = url.Grupo>				
</cfif>
<cfif isdefined("url.ver") and len(trim(url.ver)) and not isdefined("form.ver")>
	<cfset form.ver = url.ver>	
</cfif>
<cfif isdefined("url.fechaInicio") and len(trim(url.fechaInicio)) and not isdefined("form.fechaInicio")>
	<cfset form.fechaInicio = url.fechaInicio>	
</cfif>
<cfif isdefined("url.fechaFinal") and len(trim(url.fechaFinal)) and not isdefined("form.fechaFinal")>
	<cfset form.fechaFinal = url.fechaFinal>	
</cfif>



<!--- Esta pantalla requiere el Form.CAMid --->
<cfif isdefined('url.CAMid') and not isdefined('form.CAMid')>
	<cfset form.CAMid = url.CAMid>
</cfif>
<cfparam name="Form.CAMid" type="numeric">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	returnvariable="LB_RecursosHumanos"
	XmlFile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Feriado"
	Default="Feriado"
	returnvariable="LB_Feriado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Modificacion_de_Marcas_del_Reloj"
	Default="Modificaci&oacute;n de Marcas del Reloj"
	returnvariable="LB_Modificacion_de_Marcas_del_Reloj"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MontoDeFeriado"
	Default="Monto de feriado"
	returnvariable="LB_MontoDeFeriado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_HorasExtraB"
	Default="Horas extra B"
	returnvariable="LB_HorasExtraB"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_HorasExtraA"
	Default="Horas extra A"
	returnvariable="LB_HorasExtraA"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_HorasNormales"
	Default="Horas normales"
	returnvariable="LB_HorasNormales"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_HorasARebajar"
	Default="Horas a  rebajar"
	returnvariable="LB_HorasARebajar"/>
<cfquery name="rsEmpleado" datasource="#session.DSN#">
	select 	{fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)} as Empleado, 
			a.CAMfdesde, a.CAMfhasta, a.CAMid,
			case when a.RHJid is not null then 
				c.RHJdescripcion
			else
				'#LB_Feriado#'
			end as Jornada,
			c.RHJid,
			coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMtotminutos,1)">/60.00, 2),0) as HorasTotales,
			coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMociominutos,1)">/60.00, 2),0) as TiempoOcio,
			coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMtotminlab,1)">/60.00, 2),0) as HorasLaboradas,
			coalesce(a.CAMcanthorasreb,0) as CAMcanthorasreb,
			coalesce(a.CAMcanthorasjornada,0) as CAMcanthorasjornada,
			coalesce(a.CAMcanthorasextA,0) as CAMcanthorasextA,
			coalesce(a.CAMcanthorasextB,0) as CAMcanthorasextB,
			coalesce(a.CAMmontoferiado,0) as CAMmontoferiado,
			a.DEid
	from RHCMCalculoAcumMarcas a
		inner join DatosEmpleado b
			on a.DEid = b.DEid
			and a.Ecodigo = b.Ecodigo
		left outer join RHJornadas c
			on a.RHJid = c.RHJid
			and a.Ecodigo = c.Ecodigo
		inner join RHCMEmpleadosGrupo d
				on a.DEid = d.DEid
				and a.Ecodigo = d.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CAMid#">
</cfquery>
</cfsilent>
<cf_templateheader title="Procesamiento de Marcas">
<cf_web_portlet_start titulo="#LB_Modificacion_de_Marcas_del_Reloj#">
<!--- Problema DEid: DEid Es el Filtro de la pantalla anterior por lo que cuando no viene en el form significa que no está
definido el filtro, y es deseable que se mantengan las condiciones del filtro, por lo que no lo podemos definir 
arbitrariamente solo para invocar el pEmpleado, entronces vamos a definirlo de manera temporal con la información de 
rsEmpleado y lo redefinimos con su valor original después --->
<cfset Lvar_tempDEid = "">
<cfif isdefined("form.DEid") and len(trim(form.DEid))>
<cfset Lvar_tempDEid = form.DEid>
</cfif>
<cfset form.DEid = rsEmpleado.DEid>
<cfinclude template="/rh/portlets/pEmpleado.cfm">
<cfset form.DEid = Lvar_tempDEid>
<!--- Fin de Problema DEid --->
<cfoutput>
	<form name="form1" method="post" action="ProcesaMarcas-Cambio-sql.cfm">
		<!---Parametro me sirve para indicar que viene de Aprobacion de horas extra y no de procesamiento--->
		<cfif isdefined ('url.Band') and len(trim(url.Band)) gt 0>
			<input type="hidden" name="Band" value="#url.Band#" />
		</cfif>
		<input type="hidden" name="CAMid" value="#Form.CAMid#">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td width="31%" align="right" nowrap><strong><cf_translate key="LB_FechaDesde">Fecha desde</cf_translate>:&nbsp;</strong></td>
					<td width="25%">#LSDateFormat(rsEmpleado.CAMfdesde,'dd/mm/yyyy')#</td>
					<td width="16%" align="right" nowrap><strong>#LB_HorasARebajar#:&nbsp;</strong></td>
					<td width="28%">
						<cf_inputNumber name="CAMcanthorasreb" value="#LSCurrencyFormat(rsEmpleado.CAMcanthorasreb,'none')#" enteros="2" decimales="2" tabindex="1">
					</td>
				</tr>
				<tr>
					<td align="right" nowrap><strong><cf_translate key="LB_FechaHasta">Fecha hasta</cf_translate>:&nbsp;</strong></td>
					<td>#LSDateFormat(rsEmpleado.CAMfhasta,'dd/mm/yyyy')#</td>
					<td align="right" nowrap><strong>#LB_HorasNormales#:&nbsp;</strong></td>
					<td>
						<cf_inputNumber name="CAMcanthorasjornada" value="#LSCurrencyFormat(rsEmpleado.CAMcanthorasjornada,'none')#" enteros="2" decimales="2" tabindex="1">
					</td>
				</tr>
				<tr>
</cfoutput>
				<cfif isdefined ('url.Band') and len(trim(url.Band)) gt 0>
					<cfquery name="rsJor" datasource="#session.dsn#">
						select RHJid, RHJcodigo,RHJdescripcion from RHJornadas where Ecodigo=#session.Ecodigo#
					</cfquery>
					
					<td align="right" nowrap><strong><cf_translate key="LB_Jornada">Jornada</cf_translate>:&nbsp;</strong></td>
					<td>
						<select name="jornada" id="jornada">
							<option value="" >Seleccionar</option>
							<!---<option value="0" <cfif rsForm.GEAtipoP Neq 0 and rsForm.CCHid eq 0> selected= "selected" </cfif>>Tesoreria</option>--->
								<cfif rsJor.RecordCount>
									<cfoutput query="rsJor" group="RHJid">
										<option value="#rsJor.RHJid#" <cfif rsJor.RHJid  eq rsEmpleado.RHJid> selected="selected" </cfif>>#rsJor.RHJcodigo#-#rsJor.RHJdescripcion#</option>									
									</cfoutput>
								</cfif>                       
						</select>		
					</td>
				<cfelse>
					<td align="right" nowrap><strong><cf_translate key="LB_Jornada">Jornada</cf_translate>:&nbsp;</strong></td>
					<td ><cfoutput>#rsEmpleado.Jornada#</cfoutput></td>
				</cfif>
<cfoutput>
					<td align="right" nowrap><strong>#LB_HorasExtraA#:&nbsp;</strong></td>
					<td>
						<cf_inputNumber name="CAMcanthorasextA" value="#LSCurrencyFormat(rsEmpleado.CAMcanthorasextA,'none')#" enteros="2" decimales="2" tabindex="1">
					</td>
				</tr>
				<tr>
					<td align="right" nowrap><strong><cf_translate key="LB_HorasTotales">Horas totales</cf_translate>:&nbsp;</strong></td>
					<td >#NumberFormat(rsEmpleado.HorasTotales,",0.00")#</td>
					<td align="right" nowrap><strong>#LB_HorasExtraB#:&nbsp;</strong></td>
					<td>
						
						<cf_inputNumber name="CAMcanthorasextB" value="#LSCurrencyFormat(rsEmpleado.CAMcanthorasextB,'none')#" enteros="2" decimales="2" tabindex="1">
					</td>
				</tr>
				<tr>
					<td align="right" nowrap><strong><cf_translate key="LB_TiempoOcioso">Tiempo Ocioso</cf_translate>:&nbsp;</strong></td>
					<td >#NumberFormat(rsEmpleado.TiempoOcio,",0.00")#</td>
					<td align="right" nowrap><strong>#LB_MontoDeFeriado#:&nbsp;</strong></td>
					<td>
						<cf_inputNumber name="CAMmontoferiado" value="#LSCurrencyFormat(rsEmpleado.CAMmontoferiado,'none')#" enteros="2" decimales="2" tabindex="1">
					</td>
				</tr>
				<tr>
					<td align="right" nowrap><strong><cf_translate key="LB_HorasLaboradas">Horas laboradas</cf_translate>:&nbsp;</strong></td>
					<td >#NumberFormat(rsEmpleado.HorasLaboradas,",0.00")#</td>
				</tr>
			</table>
			<cf_botones modo="CAMBIO" include="Recalcular,Regresar" exclude="Nuevo">
			<!----Campos de los filtros recibidos de la pantalla anterior----->
			<input type="hidden" name="btnFiltrar" value="btnFiltrar">	
			<cfif isdefined("form.chk") and len(trim(form.chk)) gt 0>
			<input type="hidden" name="chk" value="#form.chk#">	
			</cfif>
			<cfif isdefined("form.visualizar") and len(trim(form.visualizar))>
			<input type="hidden" name="visualizar" value="#form.visualizar#">		
			</cfif>
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
			<input type="hidden" name="DEid" value="#form.DEid#">		
			</cfif>
			<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
			<input type="hidden" name="Grupo" value="#form.Grupo#">
			</cfif>
			<cfif isdefined("form.ver") and len(trim(form.ver))>
			<input type="hidden" name="ver" value="#form.ver#">
			</cfif>
			<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>
			<input type="hidden" name="fechaInicio" value="#form.fechaInicio#">
			</cfif>
			<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
			<input type="hidden" name="fechaFinal" value="#form.fechaFinal#">
			</cfif>
			<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>
			<input type="hidden" name="RHJid" value="#form.RHJid#">	
			</cfif>
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
			<input type="hidden" name="Pagina" value="#url.Pagina#">	
			</cfif>
			<cfif isdefined("form.Pagina") and len(trim(form.Pagina))>
			<input type="hidden" name="Pagina" value="#form.Pagina#">	
			</cfif>
	</form>
	<cf_qforms>
		<cf_qformsrequiredfield args="CAMcanthorasreb,#LB_HorasARebajar#"/>
		<cf_qformsrequiredfield args="CAMcanthorasjornada,#LB_HorasNormales#"/>
		<cf_qformsrequiredfield args="CAMcanthorasextA,#LB_HorasExtraA#"/>
		<cf_qformsrequiredfield args="CAMcanthorasextB,#LB_HorasExtraB#"/>
		<cf_qformsrequiredfield args="CAMmontoferiado,#LB_MontoDeFeriado#"/>
	</cf_qforms>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>