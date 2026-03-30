<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Pendiente" default="Pendiente" returnvariable="LB_Pendiente"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Finalizada" default="Finalizada" returnvariable="LB_Finalizada"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Jefe" default="Jefe" returnvariable="LB_Jefe"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Subordinado" default="Subordinado" returnvariable="LB_Subordinado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Companero" default="Compa&ntilde;ero" returnvariable="LB_Companero"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Autoevaluacion" default="Autoevaluaci&oacute;n" returnvariable="LB_Autoevaluacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_JefeAlterno" default="Jefe alterno" returnvariable="LB_JefeAlterno"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Competencia" default="Competencia" returnvariable="LB_Competencia"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Objetivo" default="Objetivo" returnvariable="LB_Objetivo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Anterior" default="Anterior" returnvariable="BTN_Anterior"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Creada" default="Creada" returnvariable="LB_Creada"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Publicada" default="Publicada" returnvariable="LB_Publicada"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_FinalizarEvaluacion" default="Finalizar Evaluación" returnvariable="BTN_Cerrar"/>
<cfinvoke component="sif.Componentes.Translate"	method="Translate" Key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion"
	Default="¡Debe seleccionar al menos un registro para relizar esta acción!"
	returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion"/>
<cfinvoke component="sif.Componentes.Translate"	method="Translate" Key="MSG_EstaSeguroQueDeseaFinalizarLasEvaluacionesSeleccionadas"
	Default="Esta seguro que desea finalizar las evaluaciones seleccionadas"
	returnvariable="MSG_EstaSeguroQueDeseaFinalizarLasEvaluacionesSeleccionadas"/>

<!----===================== Cerrado de la evaluacion =====================----->
<cfif isdefined("form.btnCerrar") and isdefined("form.chk") and len(trim(form.chk))>
	<cfinvoke component="rh.admintalento.Componentes.RH_FinalizarRelacion" method="init" returnvariable="cerrar"/>			
	<cfloop list="#form.chk#" index="RHRDid">
		<cfset cerrar.funcCierraPublicacion(form.RHRSid,RHRDid)>
	</cfloop>		
</cfif>
<!----====================================================================----->

<cfif isdefined("form.RHRSid") and len(trim(form.RHRSid)) and form.RHRSid NEQ -1>
	<cfquery name="rsEmpleado" datasource="#session.DSN#">
		select DEid , RHEid
		from RHEvaluados 
		where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
	</cfquery>
	<cfquery name="rsRelacionM" datasource="#session.DSN#">
		select RHRStipo
		from RHRelacionSeguimiento
		where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
	</cfquery>
	<cfquery name="rsRelaciones" datasource="#session.DSN#">
		select 	a.RHDRid
				,b.DEid
				,c.DEid	
				,a.RHDRfinicio
				,a.RHDRffin
				,<cf_dbfunction name="concat" args="d.DEidentificacion,' - ',d.DEapellido1 ,' ',d.DEapellido2,' ',d.DEnombre"> as Evaluador
				,case c.RHEVtipo 	when 'S' then '#LB_Subordinado#'
									when 'C' then '#LB_Companero#'
									when 'J' then '#LB_Jefe#'
									when 'A' then '#LB_Autoevaluacion#'
									when 'E' then '#LB_JefeAlterno#'
				end as tipoeval				
				,case e.RHRSEestado when 20 then '#LB_Finalizada#'
									else '#LB_Pendiente#' 
				end as avance	
				,e.RHRSEid 	
				,case a.RHDRestado 	when 10 then '#LB_Creada#'
									when 20 then '#LB_Publicada#'
									when 30 then '#LB_Finalizada#'
				end as estadoinstancia			
				,a.RHDRestado		
		from RHDRelacionSeguimiento a
			inner join RHEvaluados b
				on a.RHRSid = b.RHRSid
			inner join RHEvaluadores c
				on b.RHEid = c.RHEid
			inner join DatosEmpleado d
				on c.DEid = d.DEid	
			inner join RHRSEvaluaciones e
				on a.RHDRid = e.RHDRid	
				and c.DEid = e.DEideval				
		where a.RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
		order by a.RHDRid
	</cfquery>
	
	<cfset form.DEid = rsEmpleado.DEid>
	
	<form name="formpaso5" method="post" action="" onSubmit="javascript: return hayMarcados();">
	<table width="98%" cellpadding="0" cellspacing="0">
		<tr><td><cfinclude template="/rh/portlets/pEmpleado.cfm"></td></tr>
		<tr>
			<td>
				<table width="98%" cellpadding="1" cellspacing="0" border="0">
					<tr>
						<tr style="background-color:#CCCCCC;">						
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td><b><cf_translate key="LB_Evaluador">Evaluador</cf_translate></b></td>
							<td><b><cf_translate key="LB_Tipo">Tipo</cf_translate></b></td>
							<td><b><cf_translate key="LB_Avance">Avance</cf_translate></b></td>
							<td>&nbsp;</td>
						</tr>
						<cfoutput query="rsRelaciones" group="RHDRid">
							<tr>
								<td colspan="7" valign="top"><b>
									<input type="checkbox" name="chk" value="#rsRelaciones.RHDRid#" <cfif rsRelaciones.RHDRestado NEQ 20>disabled</cfif>>
									<cf_translate key="LB_Del">Del</cf_translate>:&nbsp;#LSDateFormat(rsRelaciones.RHDRfinicio,'dd/mm/yyyy')#
									<cf_translate key="LB_al">al</cf_translate>:&nbsp;#LSDateFormat(rsRelaciones.RHDRffin,'dd/mm/yyyy')#
									[#rsRelaciones.estadoinstancia#]								
								</b></td>							
							</tr>	
							<cfoutput>
								<tr <cfif rsRelaciones.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>#rsRelaciones.Evaluador#</td>
									<td>#rsRelaciones.tipoeval#</td>
									<td>#rsRelaciones.avance#</td>
									<td>
										<a href="javascript: funcDetalle('#rsRelaciones.RHRSEid#','#rsRelaciones.tipoeval#');"><img src="/cfmx/rh/imagenes/findsmall.gif" border="0"></a>
									</td>
								</tr>
							</cfoutput>
						</cfoutput>	
					</tr>
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<cfoutput>
				<td align="center">
					<table>
						<tr>
							<td><input type="button" name="btnAnterior" class="btnAnterior" value="#BTN_Anterior#" onClick="javascript: funcAnterior();"></td>
							<td><input type="submit" name="btnCerrar" value="#BTN_Cerrar#" class="btnAplicar"></td>
						</tr>
					</table>					
				</td>
			</cfoutput>
		</tr>
	</table>
	<cfoutput><input type="hidden" name="RHRSid" value="#form.RHRSid#"></cfoutput>
	<input type="hidden" name="SEL" value="5">
	</form>
	<cfoutput>
		<script type="text/javascript" language="javascript1.3">
			function funcDetalle(RHRSEid,tipo){
				var PARAM  = "/cfmx/rh/admintalento/evaluacion/evaluacion-respuestas.cfm?RHRSEid="+ RHRSEid+ '&tipo='+tipo;
				open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=500')  
			}
			function funcAnterior(){
				location.href = 'registro_evaluacion.cfm?SEL=4&RHRSid=#form.RHRSid#';
			}
			function hayMarcados(){
				var form = document.formpaso5;
				var result = false;
				if (form.chk!=null) {
					if (form.chk.length){
						for (var i=0; i<form.chk.length; i++){
							if (form.chk[i].checked)
								result = true;
						}
					}
					else{
						if (form.chk.checked)
							result = true;
					}
				}
				if (!result) {
					alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion#</cfoutput>');
					return result;
				}
				else{
					if(confirm('#MSG_EstaSeguroQueDeseaFinalizarLasEvaluacionesSeleccionadas#')){
						return result;
					}
					return false;
				}					
				//return result;
			}			
		</script>
	</cfoutput>
</cfif>