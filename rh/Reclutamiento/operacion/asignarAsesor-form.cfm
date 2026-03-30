<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined('form.RHPid') and len(trim(form.RHPid)) gt 0>
	<cfset modo = 'Cambio'>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select  RHPid,
				RHPfecha,
				RHPporc,
				RHPcodigo,
				RHMid,
				RHPjustificacion,
				RHPfunciones,
				RHPestado,
				Justif,
				RHPaccion,
				RHPasesor
		from RHPedimentos where RHPid=#form.RHPid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
<cfelse>
	<cfset modo='Alta'>
</cfif>

<script type="text/javascript" src="/cfmx/sif/js/FCKeditor/fckeditor.js"></script>

<form name="pedimento" action="asignarAsesor-sql.cfm" method="post" onSubmit="return validacion(this);">
<cfoutput>
<cfif isdefined ('form.RHPid') and len(trim(form.RHPid)) gt 0>
	<input type="hidden" name="RHPid" value="#form.RHPid#" />
</cfif>
	<table border="0">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
				<table border="0">
					<tr>				
						<td>
							<strong><cf_translate key="LB_Fecha_Solicitud">Fecha de Solicitud:</cf_translate></strong>
						</td>
						<td >
							<cfif modo eq 'Alta'>
								<cfset fechahasta=DateFormat(Now(),'DD/MM/YYYY')>
							<cfelse>
								<cfset fechahasta=DateFormat(#rsSQL.RHPfecha#,'DD/MM/YYYY')>
							</cfif>
							<cf_sifcalendario form="pedimento" value="#fechahasta#" name="fecha" tabindex="1">
						</td>
						<td align="right" nowrap="nowrap">
							<strong><cf_translate key="LB_Puesto_Solicitado">Puesto Solicitado:</cf_translate></strong>
						</td>
						<td>
	
							<cfif modo eq 'Alta'>
								<cf_rhpuesto form="pedimento">
							<cfelse>
								<cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto"/>
								<cfquery name="rsPuestos" datasource="#session.dsn#">
									select RHPcodigo,#LvarRHPdescpuesto# as RHPdescpuesto,RHPcodigoext from RHPuestos where RHPcodigo='#rsSQL.RHPcodigo#'
								</cfquery>
								<cf_rhpuesto form="pedimento" query="#rsPuestos#">
							</cfif>
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap">
							<strong><cf_translate key="LB_Porcentaje_ocupacion">Porcentaje de ocupación:</cf_translate></strong>
						</td>
						<td>
							<cfif modo eq 'Alta'>
								<cfset valor=0>
							<cfelse>
								<cfset valor=#rsSQL.RHPporc#>
							</cfif>
							<cf_inputNumber name="montoPor" value="#valor#" size="5" enteros="13" decimales="2" >
						</td>
						<td align="right">
							<strong><cf_translate key="LB_Motivo_Pedimento">Motivo:</cf_translate></strong>
						</td>
						<td>
                        				<cf_translatedata name="get" tabla="RHMotivos" col="RHMdescripcion" returnvariable="LvarRHMdescripcion">
							<cfquery name="rsMot" datasource="#session.dsn#">
								select RHMid,RHMcodigo, #LvarRHMdescripcion# as RHMdescripcion from RHMotivos
								where Ecodigo=#session.Ecodigo#
							</cfquery>
							<select name="mot" id="mot">  
									<cfloop query="rsMot">
										<option value="#rsMot.RHMid#" <cfif modo neq "ALTA" and rsMot.RHMid  eq rsSQL.RHMid>selected="selected"</cfif>>#rsMot.RHMcodigo#-#rsMot.RHMdescripcion#</option>
									</cfloop>
							</select>
						</td>
					</tr>
					<tr>						
						<td>
							<strong><cf_translate key="LB_Justificacion" xmlFile="/rh/generales.xml">Justificación</cf_translate>:</strong>
						</td>
						<td>
							<input type="text" size="40" maxlength="255" name="txtJust" value="<cfif modo neq 'Alta'>#rsSQL.RHPjustificacion#</cfif>" />
						</td>
						<cfif isdefined('rsAseV') and rsAseV.recordcount gt 0 and len(trim(rsAseV.Usucodigo)) gt 0>
							<td align="right">
								<strong><cf_translate key="LB_Finalizacion" xmlFile="/rh/generales.xml">Finalización</cf_translate>:</strong>
							</td>
							<td>
							
								<select name="finAcc" id="finAcc" onChange="funcImporte(this.value)">  
									<option value="1" <cfif isdefined('rsSQL') and rsSQL.RHPaccion eq 1> selected="selected"</cfif> ><cf_translate key="LB_AccionDePersonal" xmlFile="/rh/generales.xml">Acción de Personal</cf_translate></option>
									<option value="2" <cfif isdefined('rsSQL') and rsSQL.RHPaccion eq 2> selected="selected"</cfif> ><cf_translate key="LB_CrearConcurso">Crear Concurso</cf_translate></option>
									<option value="3" <cfif isdefined('rsSQL') and rsSQL.RHPaccion eq 3> selected="selected"</cfif> ><cf_translate key="LB_ListadoDePersonal">Listado de Personal</cf_translate></option>
									<option value="4" <cfif isdefined('rsSQL') and rsSQL.RHPaccion eq 4> selected="selected"</cfif> >N/A</option>
								</select>
							</td>
						<cfelse>
							<td>&nbsp;</td><td>&nbsp;</td>
						</cfif>	
						<!---<td align="right">
							<strong>Tipo de Acción:</strong>
						</td>
						<cfquery name="rsTA" datasource="#session.dsn#">
							select RHTid, RHTcodigo,RHTdesc from RHTipoAccion
							where RHTcomportam = 1
							and Ecodigo=#session.Ecodigo#
						</cfquery>
						<td>
							<select name="tipoA" id="mot">  
									<cfloop query="rsTA">
										<option value="#rsTA.RHTid#" <cfif modo neq "ALTA" and rsTA.RHTid  eq rsSQL.RHTid>selected="selected"</cfif>>#rsTA.RHTcodigo#-#rsTA.RHTdesc#</option>
									</cfloop>
							</select>
						</td>--->
					</tr>
					<tr>
						<td>
							<strong><cf_translate key="LB_Asesor">Asesor</cf_translate>:</strong>
						</td>
							<cfset valuesArraySN = ArrayNew(1)>
							<cfif modo neq 'Alta'>						
								<cfif isdefined("rsSQL.RHPasesor") and len(trim(rsSQL.RHPasesor))>	
									<cfquery name="rsForm" datasource="#session.DSN#">
										select ta.Usucodigo,dp.Pid,de.DEidentificacion,de.DEid, DEnombre #LvarCNCT# ' ' #LvarCNCT# DEapellido1 #LvarCNCT# ' ' #LvarCNCT# DEapellido2 as Nombre
										from RHAsesor ta
											inner join Usuario u
											on u.Usucodigo=ta.Usucodigo
												inner join DatosPersonales dp
												on dp.datos_personales =u.datos_personales
											inner join UsuarioReferencia r
													inner join DatosEmpleado de
														on <cf_dbfunction name="to_char" args="de.DEid">=r.llave
														and r.STabla='DatosEmpleado'
												on r.Usucodigo=ta.Usucodigo			
										where ta.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and ta.Usucodigo=#rsSQL.RHPasesor#
									</cfquery>									
									<cfset ArrayAppend(valuesArraySN, rsForm.Usucodigo)>
									<cfset ArrayAppend(valuesArraySN, rsForm.DEidentificacion)>
									<cfset ArrayAppend(valuesArraySN, rsForm.Nombre)>
								</cfif>
							</cfif>
						<td>	
							<cfinvoke component="sif.Componentes.Translate" method="translate" key="LB_Identificacion" default="Identificación" xmlFile="/rh/generales.xml" returnvariable="LB_Identificacion">
							<cfinvoke component="sif.Componentes.Translate" method="translate" key="LB_Nombre" default="Nombre" xmlFile="/rh/generales.xml" returnvariable="LB_Nombre">
							<cfinvoke component="sif.Componentes.Translate" method="translate" key="LB_ListaDeAsesores" default="Lista de asesores" xmlFile="/rh/generales.xml" returnvariable="LB_ListaDeAsesores">

							<cf_dbfunction name="to_char" args="de.DEid" returnvariable="Lvar_DEid">					
							<cf_conlis title="#LB_ListaDeAsesores#"
							campos = "Usucodigo,DEidentificacion,Nombre" 
							desplegables = "N,S,S" 
							modificables = "N,S,S" 
							size = "0,10,35"
							asignar="Usucodigo,DEidentificacion, Nombre"
							asignarformatos="S,S,S"
							tabla="RHAsesor ta
									inner join Usuario u
									on u.Usucodigo=ta.Usucodigo
										inner join DatosPersonales dp
										on dp.datos_personales =u.datos_personales
									inner join UsuarioReferencia r
											inner join DatosEmpleado de
												on #PreserveSingleQuotes(Lvar_DEid)#=r.llave
												and r.STabla='DatosEmpleado'
										on r.Usucodigo=ta.Usucodigo"
							columnas="ta.Usucodigo,de.DEidentificacion, DEnombre #LvarCNCT# ' ' #LvarCNCT# DEapellido1 #LvarCNCT# ' ' #LvarCNCT# DEapellido2 as Nombre"
							filtro="ta.Ecodigo=#session.Ecodigo#"
							desplegar="DEidentificacion, Nombre"
							etiquetas="#LB_Identificacion#,#LB_Nombre#"
							formatos="S,S"
							align="left,left"
							showEmptyListMsg="true"
							EmptyListMsg=""
							form="pedimento"
							width="800"
							height="500"
							left="70"
							top="20"
							valuesArray="#valuesArraySN#"/>    
						</td>		
						<cfif isdefined('rsSQL') and rsSQL.RHPaccion eq 4>
						<td align="right" id="trJust" ><strong>><cf_translate key="LB_Justificacion" xmlFile="/rh/generales.xml">Justificación</cf_translate>:</strong></td>
						<td id="txJust" ><input type="text" name="justext" id="justext" size="50" maxlength="255"value=" <cfif modo neq 'Alta'>#rsSQL.Justif#</cfif>" /></td>	
						<cfelse>
						<td align="right" id="trJust" style="display:none"><strong>><cf_translate key="LB_Justificacion" xmlFile="/rh/generales.xml">Justificación</cf_translate>:</strong></td>
						<td id="txJust" style="display:none"><input type="text" name="justext" id="justext" size="50" maxlength="255"value=" <cfif modo neq 'Alta'>#rsSQL.Justif#</cfif>" /></td>				
						</cfif>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<strong><cf_translate key="LB_RequisitosGenerales">Requisitos generales</cf_translate>: </strong>
			</td>
		</tr>
		<tr>
			<td><!---value="<cfif modo eq 'Cambio'>#trim(rsSQL.RHPfunciones)#</cfif>"--->
			<cfif modo neq 'ALTA'>
				<cf_rheditorhtml name="txtfunciones" value="#trim(rsSQL.RHPfunciones)#">
			<cfelse>
				<cf_rheditorhtml name="txtfunciones" height="150" >
			</cfif>
				
			</td>
		</tr>
		<cfif rsSQL.RHPestado eq 40>
		<tr><td>&nbsp;</td></tr>
		<cfelse>
		<tr>
			<td>
				<cfif modo eq 'Alta'>
					<cf_botones modo="Alta" include="Regresar" exclude="Nuevo">
				<cfelse>
					<cfif isdefined('rsAseV') and rsAseV.recordcount gt 0 and len(trim(rsAseV.Usucodigo)) gt 0>
						<cf_botones modo="Cambio" include="Aplicar,Regresar" exclude="Nuevo,Baja">
					<cfelse>
						<cf_botones modo="Cambio" include="Regresar" exclude="Nuevo,Baja">
					</cfif>
				</cfif>
			</td>
		</tr>
		</cfif>
	</table>
</cfoutput>
</form>

<script language="JavaScript1.2" type="text/javascript">
	
function validacion(form){
		var mensaje = 'Se presentaron los siguientes problemas:\n';
		var error = false;
		
		if (!btnSelected('Nuevo',form) && !btnSelected('Baja',form) && !btnSelected('Regresar',form) && !btnSelected('Aplicar',form)){		
			if ( trim(form.fecha.value) == '' ){
				mensaje = mensaje + ' - El campo Fecha es requerido\n' 
				form.fecha.style.backgroundColor = '#FFFFCC';
				error = true;
			}
	
			if ( trim(form.RHPcodigo.value) == '' ){
				mensaje = mensaje + ' - El campo Puesto es requerido\n' 
				form.RHPcodigo.style.backgroundColor = '#FFFFCC';
				error = true;
			}
			
			if ( trim(form.montoPor.value) == '' ){
				mensaje = mensaje + ' - El campo Porcentaje es requerido\n' 
				form.montoPor.style.backgroundColor = '#FFFFCC';
				error = true;
			}
			
			if (form.montoPor.value == 0){
				mensaje = mensaje + ' - El campo Porcentaje debe ser mayor que cero\n' 
				form.montoPor.style.backgroundColor = '#FFFFCC';
				error = true;
			}
			
			if (trim(form.DEidentificacion.value) == 0){
				mensaje = mensaje + ' - El campo Asesor es requerido' 
				form.montoPor.style.backgroundColor = '#FFFFCC';
				error = true;
			}
			
			if (form.montoPor.value < 0){
				mensaje = mensaje + ' - El campo Porcentaje debe ser mayor que cero\n' 
				form.montoPor.style.backgroundColor = '#FFFFCC';
				error = true;
			}
			if (form.montoPor.value > 100){
				mensaje = mensaje + ' - El campo Porcentaje debe ser menor que cien\n' 
				form.montoPor.style.backgroundColor = '#FFFFCC';
				error = true;
			}

			if ( trim(form.txtJust.value) == '' ){
				mensaje = mensaje + ' - El campo Justificación es requerido\n' 
				form.txtJust.style.backgroundColor = '#FFFFCC';
				error = true;
			}
			
		}
		if (error){
			alert(mensaje);
			return false;
		}

		return true;
	
		}
		
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
	
	function restaurar_color(obj){
		obj.style.backgroundColor = '#FFFFFF';
	}

	function limpiar() {
		objForm.reset();
	}
	function funcImporte(LvarI){
			var objDA = document.getElementById('trJust');	
			var objDA2 = document.getElementById('txJust');		
			if (LvarI==4){
			  objDA.style.display = '';				
				objDA2.style.display='';
			}
			if (LvarI!=4){
			  objDA.style.display = 'none';				
				objDA2.style.display='none';
			}
	}


</script> 