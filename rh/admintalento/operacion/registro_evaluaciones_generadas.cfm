<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NoSeEncontraronRegistros" default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_NoHaSeleccionadoLaRelacion" default="No ha seleccionado la relaci&oacute;n" returnvariable="MSG_NoHaSeleccionadoLaRelacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaInicio" default="Fecha Inicio" returnvariable="LB_FechaInicio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaFinaliza" default="Fecha Finaliza" returnvariable="LB_FechaFinaliza"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Estado" default="Estado" returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Creada" default="Creada" returnvariable="LB_Creada"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Publicada" default="Publicada" returnvariable="LB_Publicada"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cerrada" default="Cerrada" returnvariable="LB_Cerrada"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Publicar" default="Publicar" returnvariable="BTN_Publicar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Cerrar" default="Cerrar" returnvariable="BTN_Cerrar"/>
<cfinvoke component="sif.Componentes.Translate" xmlfile="/rh/generales.xml" method="Translate" key="BTN_Eliminar" default="Eliminar" returnvariable="BTN_Eliminar"/>
<cfinvoke component="sif.Componentes.Translate" xmlfile="/rh/generales.xml" method="Translate" key="MSG_DeseaEliminarElRegistro" default="Desea eliminar el registro?" returnvariable="MSG_Eliminar"/>
<cfinvoke component="sif.Componentes.Translate" xmlfile="/rh/generales.xml" method="Translate" key="BTN_Regresar" default="Regresar" returnvariable="BTN_Regresar"/>
<cfinvoke component="sif.Componentes.Translate" xmlfile="/rh/generales.xml" method="Translate" key="BTN_Siguiente" default="Siguiente" returnvariable="BTN_Siguiente"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_GenerarSiguienteEvaluacion" default="Generar siguiente evaluaci&oacute;n" returnvariable="LB_siguienteeval"/>

<cfif isdefined("form.RHRSid") and len(trim(form.RHRSid)) and form.RHRSid NEQ -1>
	
	<cfquery name="rs_estado" datasource="#session.DSN#">
		select RHRSestado as estado, RHRSfin as fin
		from RHRelacionSeguimiento
		where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
	</cfquery>
	
	<cfif rs_estado.estado eq 10 >
		<cfoutput>
		<form name="formpaso4" method="post" action="registro_evaluaciones_generadas-sql.cfm" >
			<br />
			<table border="0" class="areaFiltro" width="98%" cellpadding="6" cellspacing="0">
				<tr><td align="center"><cf_translate key="MSG_LaRelacionDeSeguimientoNoHaSidoPublicada">La Relaci&oacute;n de Seguimiento no ha sido publicada</cf_translate>.<br> <cf_translate key="MSG_ParaGenerarInstanciasDeLeRelacionDebeSerPublicada">Para generar instancias de le relaci&oacute;n, debe ser publicada</cf_translate>.</td></tr>
				<tr><td align="center"><input class="btnPublicar" type="submit" name="publicar" value="#BTN_Publicar#" /></td></tr>
			</table>
			<input type="hidden" name="RHRSid" value="#form.RHRSid#">
			<input type="hidden" name="sel" value="#form.sel#">		
		</form>
		</cfoutput>
	<cfelse>
			<cfquery name="rsLista" datasource="#session.DSN#">
				select 	a.RHDRid,
						a.RHDRfinicio, a.RHDRffin, 
						a.RHDRestado,
						case a.RHDRestado 	when 10 then '#LB_Creada#'
											when 20 then '#LB_Publicada#'
											when 30 then '#LB_Cerrada#'
						end as Estado					
				from RHDRelacionSeguimiento a
				where a.RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
			</cfquery>	
			<cfoutput>
		
			<form name="formpaso4" method="post" action="registro_evaluaciones_generadas-sql.cfm" >
				<table width="98%" border="0" cellpadding="0" cellspacing="0">
					<tr><td>&nbsp;</td></tr>						
					<tr><td colspan="6">
						<table width="100%" border="0" id="tabla_contenedor" cellpadding="0" cellspacing="0">
							<tr style="background-color:##F1F1F1;">
								<td><b>#LB_FechaInicio#</b></td>
								<td><b>#LB_FechaFinaliza#</b></td>
								<td align="left"><b>#LB_Estado#</b></td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
		
						<cfloop query="rsLista">
							<tr id="tr_contenedor_#rsLista.RHDRid#" <cfif rsLista.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
								<td>#LSDateFormat(rsLista.RHDRfinicio,'dd/mm/yyyy')#</td>
								<td>#LSDateFormat(rsLista.RHDRffin,'dd/mm/yyyy')#</td>
								<td id="id_estado_#rsLista.RHDRid#">#Estado#</td>
								<td align="center">
									<cfif rsLista.RHDRestado EQ 10>
										<img id="id_img_#rsLista.RHDRid#" onClick="javascript: funcPublicar('#rsLista.RHDRid#');" src="/cfmx/rh/imagenes/edita.gif" title="#BTN_Publicar#" border="0"style="cursor:pointer;">
									</cfif>
								</td>
								<td align="center">
									<cfif rsLista.RHDRestado NEQ 30>
										<img id="id_img_cerrar_#rsLista.RHDRid#" onClick="javascript: funcCerrar('#rsLista.RHDRid#');" src="/cfmx/rh/imagenes/lock.gif" title="#BTN_Cerrar#" border="0" style="cursor:pointer;">
									</cfif>	
								</td>
								<td align="center" >
									<cfif rsLista.RHDRestado EQ 10>
										<img onClick="javascript: funcEliminar('#rsLista.RHDRid#');" src="/cfmx/rh/imagenes/Borrar01_S.gif" border="0" title="#BTN_Eliminar#" style="cursor:pointer;">						
									</cfif>
								</td>
							</tr>
						</cfloop>
						<cfif rsLista.recordcount eq 0 >
							<tr><td align="center" colspan="3" style="padding:3px;"><strong>-<cf_translate xmlfile="/rh/generales.xml" key="MSG_NoSeEncontraronRegistros">No se encontraron registros</cf_translate>-</strong></td></tr>
						</cfif>
						
						</table>			
					</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td colspan="6" align="center">
						<script language="JavaScript" type="text/javascript">
							// Funciones para Manejo de Botones
							botonActual = "";
						
							function setBtn(obj) {
								botonActual = obj.name;
							}
							function btnSelected(name, f) {
								if (f != null) {
									return (f["botonSel"].value == name)
								} else {
									return (botonActual == name)
								}
							}
						</script>
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
						  <tr>
							<td align="center">
									<input type="hidden" name="botonSel" value="">
									<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1" style="visibility:hidden;">
									<input type="submit" name="Regresar" class="btnAnterior" value="#BTN_Regresar#" onclick="javascript: document.formpaso4.sel.value = #form.sel-1#;" tabindex="0">

									<cfif rs_estado.estado eq 20 and datecompare(now(), rs_estado.fin) lt 1>
										<input class="btnAplicar" type="submit" name="ALTA" value="#LB_siguienteeval#" />
									</cfif>

									<input type="submit" name="Siguiente" class="btnSiguiente" value="#BTN_Siguiente#" onclick="javascript: document.formpaso4.sel.value = #form.sel+1#;" tabindex="0">
							</td>
						  </tr>
						
						</table>
					</td></tr>
		
				</table>
				<input type="hidden" name="RHRSid" value="#form.RHRSid#">
				<input type="hidden" name="sel" value="#form.sel#">		
			</form>
		
			<script type="text/javascript" language="javascript1.3">
				function ajaxFunction(id,action)
				{
					var xmlHttp;
					try
					{
						// Firefox, Opera 8.0+, Safari
						  xmlHttp=new XMLHttpRequest();
					}
					catch (e)
					{
						// Internet Explorer
						try
						{
							xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
						}
						catch (e)
						{
							try
							{
								xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
							}
							catch (e)
							{
								alert("Your browser does not support AJAX!");
								return false;
							}
						}
					}
				  
					xmlHttp.onreadystatechange=function()
					{
						if(xmlHttp.readyState==4)
						{
							//document.myForm.time.value=xmlHttp.responseText;
							var resultado = parseInt(xmlHttp.responseText)
							if (resultado == 1 ){
								if (action == 'publicar'){
									var tr = document.getElementById('id_estado_'+id);
									var img = document.getElementById('id_img_'+id);
									tr.innerHTML = '<cfoutput>#LB_Publicada#</cfoutput>';
									img.style.display = 'none';
								}
								if (action == 'cerrar'){
									var tr = document.getElementById('id_estado_'+id);
									var img = document.getElementById('id_img_cerrar_'+id);
									tr.innerHTML = '<cfoutput>#LB_Cerrada#</cfoutput>';
									img.style.display = 'none';
								}
								if (action == 'eliminar'){
									var table = document.getElementById('tabla_contenedor');
									var tr = document.getElementById('tr_contenedor_'+id);
									table.deleteRow(tr.rowIndex);
								}
							}
						}
					}
					
					xmlHttp.open("GET","registro_evaluaciones_generadas-ajax.cfm?id="+id+"&action="+action,true);
					xmlHttp.send(null);
				}
		
				function funcPublicar(prn_llave){
					ajaxFunction(prn_llave, 'publicar');
				}
		
				function funcCerrar(prn_llave){
					ajaxFunction(prn_llave, 'cerrar');
				}
		
				function funcEliminar(prn_llave){
					if ( confirm('#MSG_Eliminar#') ){
						ajaxFunction(prn_llave, 'eliminar');
					}
				}
			</script>
			</cfoutput>
	</cfif>
<cfelse>
	<cfoutput><p><b>---#MSG_NoHaSeleccionadoLaRelacion#---</b></p></cfoutput>
</cfif>