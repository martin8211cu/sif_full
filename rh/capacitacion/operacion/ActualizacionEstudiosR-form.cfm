<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfset LB_Educacion = t.Translate('LB_Educacion','Educación','/rh/capacitacion/operacion/ActualizacionEstudiosR.xml')>
<cfset LB_EstudiosRealizados = t.Translate('LB_EstudiosRealizados','Estudios realizados','/rh/capacitacion/operacion/ActualizacionEstudiosR.xml')>
<cfset LB_TituloObtenido = t.Translate('LB_TituloObtenido','Título obtenido','/rh/capacitacion/operacion/ActualizacionEstudiosR.xml')>
<cfset LB_InstitucionEnQueEstudio = t.Translate('LB_InstitucionEnQueEstudio','Institución en que estudió','/rh/capacitacion/operacion/ActualizacionEstudiosR.xml')>
<cfset LB_OtraInstitucion = t.Translate('LB_OtraInstitucion','Otra institución','/rh/capacitacion/operacion/ActualizacionEstudiosR.xml')>
<cfset LB_FechaDeIngreso = t.Translate('LB_FechaDeIngreso','Fecha de ingreso','/rh/capacitacion/operacion/ActualizacionEstudiosR.xml')>
<cfset LB_FechaDeFinalizacion = t.Translate('LB_FechaDeFinalizacion','Fecha de finalización','/rh/capacitacion/operacion/ActualizacionEstudiosR.xml')>
<cfset LB_NivelAlcanzado = t.Translate('LB_NivelAlcanzado','Nivel alcanzado','/rh/capacitacion/operacion/ActualizacionEstudiosR.xml')>
<cfset LB_SinTerminar = t.Translate('LB_SinTerminar','Sin terminar','/rh/capacitacion/operacion/ActualizacionEstudiosR.xml')>
<cfset LB_SinDefinir = t.Translate('LB_SinDefinir','Sin definir','/rh/capacitacion/operacion/ActualizacionEstudiosR.xml')>
<cfset MSG_DeseaAprobarElEstudioRealizado = t.Translate('MSG_DeseaAprobarElEstudioRealizado','Desea aprobar el Estudio Realizado?','/rh/capacitacion/operacion/ActualizacionEstudiosR.xml')>
<cfset LB_Aprobar = t.Translate('LB_Aprobar','Aprobar','/rh/generales.xml')>
<cfset LB_Rechazar = t.Translate('LB_Rechazar','Rechazar','/rh/generales.xml')>
<cfset LB_Regresar = t.Translate('Regresar','Regresar','/rh/generales.xml')>
<cfset LB_Aprobado = t.Translate('LB_Aprobado','Aprobado','/rh/generales.xml')>


<cfif isdefined("fromAprobacionCV")>
	<style type="text/css">
		.btnAnterior{display:none;}
	</style>
</cfif>
<cfset modoEducacion = "ALTA">
<cfif isdefined("form.RHEElinea") and len(trim(form.RHEElinea))>
	<cfset modoEducacion = "CAMBIO">
</cfif>
<!--- Querys previos ---->
<cf_translatedata name="get" tabla="GradoAcademico" col="GAnombre" returnvariable="LvarGAnombre">
<cfquery name="rsGrados" datasource="#session.DSN#">
	select GAcodigo,#LvarGAnombre# as GAnombre  
	from GradoAcademico
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsInstituciones" datasource="#session.DSN#">
	select RHIAid, (case when len(RHIAnombre) > 50 then {fn concat(substring(RHIAnombre,1,50),'...')}  else RHIAnombre end) as RHIAnombre
	from RHInstitucionesA
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	order by RHIAnombre
</cfquery>
<cfif modoEducacion neq 'ALTA'>
	<cf_translatedata name="get" tabla="GradoAcademico" col="GAnombre" returnvariable="LvarGAnombre">
	<cfquery name="data" datasource="#session.DSN#">		
		select 	RHEElinea, a.RHIAid, a.GAcodigo, RHEotrains, RHEtitulo,
				RHEfechaini, RHEfechafin, RHEsinterminar, a.ts_rversion,
				(case when len(RHIAnombre) > 50 then {fn concat(substring(RHIAnombre,1,50),'...')}  else RHIAnombre end) as RHIAnombre,
				#LvarGAnombre# as GAnombre,a.RHEestado
		from RHEducacionEmpleado a
		left outer join RHInstitucionesA c
			on c.RHIAid = a.RHIAid
		left outer join GradoAcademico d
			on d.GAcodigo = a.GAcodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and RHEElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEElinea#">
	</cfquery>
</cfif>
<cfset consulta = 1>
<cfset consulta2 = 1>


<cfif isdefined("fromAprobacionCV")><!----- si se trabaja desde aprobacion de curriculum vitae---->
	<cfset destino = "AprobacionCV-sql.cfm" >	
	<cfset self="AprobacionCV.cfm?tab=4">
<cfelse>
	<cfset destino = "ActualizacionEstudiosR-sql.cfm" >	
	<cfset self="ActualizacionEstudiosR.cfm">
</cfif>


<cfif not isDefined("fromAprobacionCV")>
	<table width="100%" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td colspan="2"><cfinclude template="../expediente/info-empleado.cfm"></td>
		</tr>
	</table>
</cfif>
<cf_dbfunction name="op_concat" returnvariable="concat">
 

<table width="100%" cellpadding="0" cellspacing="0" align="center">
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td width="50%" valign="top">
			<cfset LvarFormatData = 'dd/mm/yyyy'>
			<cfif findNoCase("en", session.idioma)>
				<cfset LvarFormatData = 'mm/dd/yyyy'>
			</cfif>
			<cfquery name="rsLista" datasource="#session.DSN#">
				select  a.RHEElinea,
						a.RHEtitulo #concat#' - '#concat# 
							(case  when a.RHEotrains is null then 
								(case when b.RHIAnombre is null then 
								' ' else b.RHIAnombre end)
							else a.RHEotrains end) #concat# ' - ' #concat# <cf_dbfunction name="date_format" args="RHEfechafin,#LvarFormatData#">
						as descripcion,	
						a.RHEfechaini, 
						a.RHEfechafin
						,'#form.DEid#' as DEid
						,(case when a.RHEestado = 1 then 'X' else '' end) as estado
				from RHEducacionEmpleado a
					left outer join RHInstitucionesA b
						on a.RHIAid= b.RHIAid
						and a.Ecodigo = b.Ecodigo
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and  a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">	
				order by a.RHEfechafin desc
			</cfquery>

			<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="descripcion,estado"/>
				<cfinvokeargument name="etiquetas" value="#LB_EstudiosRealizados#,#LB_Aprobado#"/>
				<cfinvokeargument name="formatos" value="V,V"/>
				<cfinvokeargument name="align" value="left,center"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="RHEElinea"/>
				<cfinvokeargument name="irA" value="#self#"/>
				<cfinvokeargument name="formName" value="formEducacionLista"/>
			</cfinvoke>
		</td>
		<td width="50%" valign="top">
			<cfoutput>
			<form name="formEducacion" action="#destino#" method="post">
				<input type="hidden" name="DEid" value="<cfif isdefined("form.DEid") and len(trim(form.DEid))>#form.DEid#</cfif>">
				<input type="hidden" name="RHEElinea" value="<cfif isdefined('data')>#data.RHEElinea#</cfif>">
				<cfif isdefined("fromAprobacionCV")><!----- si se trabaja desde aprobacion de curriculum vitae---->
					<input type="hidden" name="tab" value="4">
				</cfif>
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td width="20%" align="right"><strong>#LB_TituloObtenido#:&nbsp;</strong></td>
						<td width="32%"><cfif modoEducacion neq 'ALTA'>#data.RHEtitulo#</cfif></td>
					</tr>
					<tr>
						<td align="right" nowrap><strong>#LB_InstitucionEnQueEstudio#:&nbsp;</strong></td>
						<td><cfif modoEducacion neq 'ALTA'>#data.RHIAnombre#</cfif></td>
					</tr>
					<tr>
						<td align="right"><strong>#LB_OtraInstitucion#:&nbsp;</strong></td>
						<td><cfif modoEducacion neq 'ALTA'>#data.RHEotrains#</cfif></td>
					</tr>
					<tr>
						<td align="right"><strong>#LB_FechaDeIngreso#:&nbsp;</strong></td>
						<td>
							<table>
								<tr>
									<td>
										<cfif modoEducacion neq 'ALTA'>
										<cfset v_mes = '' >
										<cfset lista_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >
										<cfset v_mes = listgetat(lista_meses, month(data.RHEfechaini)) >
										#v_mes#
										</cfif> 

									</td>
									<td>&nbsp;</td>
									<td><cfif modoEducacion neq 'ALTA'>#year(data.RHEfechaini)#</cfif></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td nowrap align="right"><strong>#LB_FechaDeFinalizacion#:&nbsp;</strong></td>
						<td width="32%">
							<table>
								<tr>
									<td>
										<cfif modoEducacion neq 'ALTA'>
										<cfset v_mes = '' >
										<cfset lista_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >
										<cfset v_mes = listgetat(lista_meses, month(data.RHEfechafin)) >
										#v_mes#
										</cfif>
									</td>
									<td>&nbsp;</td>
									<td><cfif modoEducacion neq 'ALTA'>#year(data.RHEfechafin)#</cfif></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td align="right" valign="top"><strong>#LB_NivelAlcanzado#:&nbsp;</strong></td>
						<td nowrap><cfif modoEducacion neq 'ALTA' and LEN(TRIM(data.GAnombre))>#data.GAnombre#<cfelse>#LB_SinDefinir#</cfif>&nbsp;&nbsp;&nbsp;<cfif modoEducacion neq 'ALTA' and data.RHEsinterminar EQ 1><strong>#LB_SinTerminar#</strong></cfif>
						</td>
					</tr>
					<tr>
						<td colspan="4" align="center">
							<cfif modoEducacion neq 'ALTA'>
                                <cfif data.RHEestado eq 1>
                                    <cf_botones values="#LB_Rechazar#,#LB_Regresar#" names="btnRechazar,btnRegresar">
                                <cfelse>    
                                    <cf_botones values="#LB_Aprobar#,#LB_Regresar#" names="btnAprobar,btnRegresar">
                                </cfif>

							<cfelse>
								<cf_botones values="Regresar">
							</cfif>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
				</table>
				<cfif modoEducacion neq 'ALTA'>
					<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
						<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
					</cfinvoke>
					<input type="hidden" name="ts_rversion" value="#ts#">
				</cfif>
			</form>
			</cfoutput>
		</td>
	</tr>
</table>


<script type="text/javascript">
	function funcRegresar(){
		document.formEducacion.DEid.value = '';
		document.formEducacion.RHEElinea.value = '';
		document.formEducacion.action = "ActualizacionEstudiosR.cfm";
	}
	
	function funcAprobar(){
		if (confirm('<cfoutput>#MSG_DeseaAprobarElEstudioRealizado#</cfoutput>')){
			return true;
		}else{
			return false;
		}
	}
</script>