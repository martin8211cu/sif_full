<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 24-1-2006.
		Motivo: Actualizar. Utilización del componente de listas, cf_botones, cf_qforms.
 --->

<!-- Establecimiento del modo -->
<cfset modo = 'ALTA'>
<cfif isdefined('form.persona') and LEN(TRIM(form.persona))>
	<cfset modo = 'CAMBIO'>
</cfif>

<!--- Consultas --->

<!--- 1. Form  --->

<cfif modo EQ "CAMBIO" >
	<cfquery datasource="#Session.Edu.DSN#" name="rsForm">
		Select convert(varchar,persona) as persona, convert(varchar,CEcodigo) as CEcodigo, a.Pnombre, Papellido1, Papellido2, a.Ppais, b.Pnombre, a.TIcodigo, TInombre, Pid, convert(varchar,Pnacimiento,103) Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Poficina, Pcelular, Pfax, Ppagertel, Ppagernum, Pfoto, PfotoType, PfotoName, Pemail1validado
		from PersonaEducativo a, Pais b, TipoIdentificacion c
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
		and a.Ppais=b.Ppais
		and a.TIcodigo=c.TIcodigo
	</cfquery>
	<!---  Para el check de Asistente  --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsAsist">
		Select convert(varchar,Acodigo) as Acodigo, autorizado
		from Asistente
		where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	</cfquery>	
	<!---  Para el check de Staff o Docente  --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsStaff">
		Select convert(varchar,Splaza) as Splaza, autorizado, retirado
		from Staff
		where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	</cfquery>
	<!---  Para el check de Encargado  --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsEncar">
		Select convert(varchar,EEcodigo) as EEcodigo, autorizado
		from Encargado
		where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
	</cfquery>
	<!---  Para el check de Director  --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsDirec">
		Select convert(varchar,Dcodigo) as Dcodigo, convert(varchar,Ncodigo) as Ncodigo, autorizado
		from Director
		where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
	</cfquery>

</cfif>

<!--- Para el combo de tipos de Identificacion  --->
<cfquery datasource="#Session.Edu.DSN#" name="rsTipoIdentif">
	select TIcodigo,TInombre from TipoIdentificacion
</cfquery>

<!---  Para el combo de paises  --->
<cfquery datasource="#Session.Edu.DSN#" name="rsPaises">
	select Ppais,Pnombre from Pais 
</cfquery>


<!---  Para el combo de Niveles  --->
<cfquery datasource="#Session.Edu.DSN#" name="rsNivel">
	select convert(varchar,Ncodigo) as Ncodigo,Ndescripcion
	from Nivel
	where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
</cfquery>



<!--- ------------------------------------------------------------------------------- --->

<script language="JavaScript" type="text/JavaScript">
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
		
	function doConlisAplicaNivelesDirector() {
		//alert(Hcodigo);
		popUpWindow("ConlisAplicaNivelesDirector.cfm?Dcodigo="+document.formRH.Dcodigo.value,250,250,500,350);
		window.onfocus=closePopUp; 
	}

	function closePopUp() {
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
		popUpWin = 0;
	  }
	}
</script>
<form action="SQLRh.cfm" method="post" enctype="multipart/form-data" id="formRH" name="formRH" style="margin:0"> <!---  onsubmit="return TieneTipo();"  --->
	<cfoutput>
	<input name="Pagina" type="hidden" value="<cfif isdefined('form.Pagina')>#form.Pagina#<cfelse>1</cfif>">
   	<input name="persona" id="persona" value="<cfif modo NEQ 'ALTA'>#rsForm.persona#</cfif>" type="hidden"> 
	<input name="Filtro_RHnombre" type="hidden" value="<cfif isdefined('form.Filtro_RHnombre')>#form.Filtro_RHnombre#</cfif>">
	<input name="Filtro_RhPid" type="hidden" value="<cfif isdefined('form.Filtro_RhPid')>#form.Filtro_RhPid#</cfif>">
	<input name="Filtro_Tipo" type="hidden" value="<cfif isdefined('form.Filtro_Tipo')>#form.Filtro_Tipo#<cfelse>-1</cfif>">
	<input name="Filtro_Pmail1" type="hidden" value="<cfif isdefined('form.Filtro_Pmail1')>#form.Filtro_Pmail1#</cfif>">
	<input name="Filtro_Pcasa" type="hidden" value="<cfif isdefined('form.Filtro_Pcasa')>#form.Filtro_Pcasa#</cfif>">
	<input name="Filtro_Poficina" type="hidden" value="<cfif isdefined('form.Filtro_Poficina')>#form.Filtro_Poficina#</cfif>">
	<input name="Filtro_Pcelular" type="hidden" value="<cfif isdefined('form.Filtro_Pcelular')>#form.Filtro_Pcelular#</cfif>">
	<input name="Filtro_Pmail2" type="hidden" value="<cfif isdefined('form.Filtro_Pmail2')>#form.Filtro_Pmail2#</cfif>">
	<input name="Filtro_Pagertel" type="hidden" value="<cfif isdefined('form.Filtro_Pagertel')>#form.Filtro_Pagertel#</cfif>">
	<input name="Filtro_Pagernum" type="hidden" value="<cfif isdefined('form.Filtro_Pagernum')>#form.Filtro_Pagernum#</cfif>">
	<input name="Filtro_Pfax" type="hidden" value="<cfif isdefined('form.Filtro_Pfax')>#form.Filtro_Pfax#</cfif>">
	</cfoutput>
   <cfif isdefined ("form.persona") and len(trim(form.persona))>
   	  <input name="sel" type="hidden" value="1">
   </cfif>
   
<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:0">
	<tr> 
    	<td colspan="5" class="tituloAlterno"> 
			<cfif modo EQ 'CAMBIO'>
        		Modificacion de Recurso Humano 
          	<cfelse>
          		Ingreso de Recurso Humano 
			</cfif> 
		</td>
    </tr>
	<tr><td colspan="5">&nbsp;</td></tr>
    <tr> 
      	<td width="27%" rowspan="6" valign="middle" align="center"> 
	  		<table width="108" height="159" border="1" cellspacing="3">
				<tr> 
					<td width="102" align="center" valign="middle"> 
						<cfif modo NEQ 'ALTA'>
							<cfif Len(rsForm.Pfoto) EQ 0>
								  Fotograf&iacute;a no disponible 
							<cfelse>
								  <cf_LoadImage tabla="PersonaEducativo" columnas="Pfoto as contenido, persona as codigo" condicion="persona=#rsForm.persona#" imgname="Foto" width="109" height="154" alt="#rsForm.Pnombre#  #rsForm.Papellido1#  #rsForm.Papellido2#">
							</cfif>
						<cfelse>
							Fotograf&iacute;a 
						</cfif> 
					</td>
				</tr>
	        </table>
		</td>
      	<td width="15%"><strong>Nombre</strong>&nbsp;</td>
		<td width="18%"><strong>Primer&nbsp;Apellido&nbsp;</strong></td>
		<td width="25%"><strong>Segundo&nbsp;Apellido&nbsp;</strong></td>
		<td width="15%"align="center" valign="top" rowspan="6"> 
			<table width="100%" border="0">
				<tr> 
            		<td colspan="2"><strong>Tipos</strong></td>
            		<td><strong>Autorizado</strong></td>
          		</tr>
          		<tr> 
            		<td> 
						<input name="Acodigo" type="checkbox" id="Acodigo" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsAsist.Acodigo#</cfoutput></cfif>"  <cfif modo NEQ 'ALTA' and #rsAsist.Acodigo# NEQ "">checked</cfif> onClick="javascript: this.form.autorizadoast.checked = this.checked;">
					</td>
            		<td width="38%"><label for="Acodigo">Asistente</label></td>
            		<td align="center"> 
						<input name="autorizadoast" type="checkbox" id="autorizadoast" <cfif modo NEQ 'ALTA' and #rsAsist.autorizado# EQ 1>checked</cfif>>
					</td>
          		</tr>
				<tr> 
					<td>
						<input name="EEcodigo" type="checkbox" id="EEcodigo" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEncar.EEcodigo#</cfoutput></cfif>" <cfif modo NEQ 'ALTA' and #rsEncar.EEcodigo# NEQ "">checked</cfif> onClick="javascript: this.form.autorizadoenc.checked = this.checked;"> 
					</td>
					
					<td><label for="EEcodigo">Encargado</label></td>
					<td align="center"> 
						<input name="autorizadoenc" type="checkbox" id="autorizadoenc" <cfif modo NEQ 'ALTA' and #rsEncar.autorizado# EQ 1>checked</cfif>> 
					</td>
				</tr>
				<tr> 
					<td> 
						<input name="Splaza" type="checkbox" id="Splaza" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsStaff.Splaza#</cfoutput></cfif>" <cfif modo NEQ 'ALTA' and #rsStaff.Splaza# NEQ "">checked</cfif> onClick="javascript: this.form.autorizadodoc.checked = this.checked;"> 
					</td>
					<td><label for="Splaza">Docente</label></td>
					<td width="49%" align="center"> 
						<input name="autorizadodoc" type="checkbox" id="autorizadodoc" <cfif modo NEQ 'ALTA' and #rsStaff.autorizado# EQ 1>checked</cfif>>
					</td>
				</tr>
				<tr> 
					<td width="13%"> 
						<input name="Dcodigo" type="checkbox" id="Dcodigo" onClick="javascript: Nivel(this); this.form.autorizadodir.checked = this.checked;" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsDirec.Dcodigo#</cfoutput></cfif>" <cfif modo NEQ 'ALTA' and #rsDirec.Dcodigo# NEQ "">checked</cfif>> 
					</td>
					<td><label for="Dcodigo">Director</label></td>
					<td width="49%" align="center"> 
						<input name="autorizadodir" type="checkbox" id="autorizadodir" <cfif modo NEQ 'ALTA' and #rsDirec.autorizado# EQ 1>checked</cfif>>
					</td>
				</tr>
				<tr> 
					<td colspan="3"> 
						<div style="display: ;" id="verNiveles"> 
						<table width="96%" border="0" cellpadding="0" cellspacing="2">
							<cfif modo EQ 'ALTA' >
								<tr><td><strong>Nivel</strong></td></tr>
								<tr> 
									<td> 
										<select name="Ncodigo" id="Ncodigo">
											<cfoutput query="rsNivel"> 
												<cfif modo NEQ 'ALTA' >
													<cfif #rsDirec.Ncodigo# EQ #rsNivel.Ncodigo#>
														<option value="#rsNivel.Ncodigo#" selected>#rsNivel.Ndescripcion#</option>
													<cfelse>
														<option value="#rsNivel.Ncodigo#">#rsNivel.Ndescripcion#</option>
													</cfif>
												<cfelse>
													<option value="#rsNivel.Ncodigo#">#rsNivel.Ndescripcion#</option>
												</cfif>
											</cfoutput> 
										</select> 
									</td>
								</tr>
							<cfelse>
								<cfif rsDirec.Dcodigo NEQ "">	<!--- Es un director --->
									<tr><td>&nbsp;</td></tr>
									<tr> 
										<td> 
                                          <input name="btnNivelesAplica" type="button" value="Asociar a Niveles" 
										  	onClick="javascript:doConlisAplicaNivelesDirector();">
										</td>
									</tr>						
								<cfelse>
									<tr><td><strong>Nivel</strong></td></tr>
									<tr> 
										<td> 
											<select name="Ncodigo" id="Ncodigo">
												<cfoutput query="rsNivel"> 
													<cfif modo NEQ 'ALTA' >
														<cfif #rsDirec.Ncodigo# EQ #rsNivel.Ncodigo#>
															<option value="#rsNivel.Ncodigo#" selected>#rsNivel.Ndescripcion#</option>
														<cfelse>
															<option value="#rsNivel.Ncodigo#">#rsNivel.Ndescripcion#</option>
														</cfif>
													<cfelse>
														<option value="#rsNivel.Ncodigo#">#rsNivel.Ndescripcion#</option>
													</cfif>
												</cfoutput> 
											</select> 
										</td>
									</tr>						
								</cfif>					
							</cfif>
						</table>
						</div>
					</td>
				</tr>
        	</table>
		</td>
	</tr>
    <tr> 
		<td> 
			<input name="Pnombre" type="text" id="Pnombre" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pnombre#</cfoutput></cfif>"> 
		</td>
		<td> 
			<input name="Papellido1" type="text" id="Papellido1" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Papellido1#</cfoutput></cfif>"> 
		</td>
		<td> 
			<input name="Papellido2" type="text" id="Papellido2" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Papellido2#</cfoutput></cfif>"> 
		</td>
    </tr>
    <tr> 
		<td><strong>Identificaci&oacute;n</strong></td>
		<td><strong>Tipo Identificaci&oacute;n</strong></td>
		<td><strong>Sexo</strong></td>
    </tr>
    <tr> 
		<td> 
			<input name="Pid" type="text" id="Pid" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pid#</cfoutput></cfif>"> 
		</td>
		<td> 
			<select name="TIcodigo" id="TIcodigo">
				<cfoutput query="rsTipoIdentif"> 
					<cfif modo EQ 'CAMBIO' and #rsForm.TIcodigo# EQ #rsTipoIdentif.TIcodigo#>
						<option value="#rsTipoIdentif.TIcodigo#" selected>#rsTipoIdentif.TInombre#</option>
					<cfelse>
						<option value="#rsTipoIdentif.TIcodigo#">#rsTipoIdentif.TInombre#</option>
					</cfif>
				</cfoutput> 
			</select> 
		</td>
		<td> 
			<select name="Psexo" id="Psexo">
				<cfif modo EQ 'CAMBIO' and #rsForm.Psexo# EQ 'M'>
					<option value="M" selected>Masculino</option>
				<cfelse>
					<option value="M">Masculino</option>
				</cfif>
				<cfif modo EQ 'CAMBIO' and #rsForm.Psexo# EQ 'F'>
					<option value="F" selected>Femenino</option>
				<cfelse>
					<option value="F">Femenino</option>
				</cfif>
			</select> 
		</td>
    </tr>
    <tr> 
		<td><strong>Fecha Nacimiento</strong></td>
		<td><strong>Direcci&oacute;n</strong></td>
		<td>&nbsp;</td>
    </tr>
    <tr> 
		<td valign="top"> 
			<!--- <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar1','','/cfmx/edu/Imagenes/date_d.gif',1)"> 
				<input name="Pnacimiento" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfif isdefined("form.Pnacimiento")><cfoutput>#rsForm.Pnacimiento#</cfoutput><cfelse><cfoutput>#DateFormat(Now(),'DD/MM/YYYY')#</cfoutput></cfif>" size="12" maxlength="10" >
				<img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.formRH.Pnacimiento');"> 
			</a>  --->
			<cfif modo NEQ 'ALTA'> 
					<cf_sifcalendario name="Pnacimiento" value="#LSDateFormat(rsForm.Pnacimiento,'dd/mm/yyyy')#" 
						tabindex="1" form="formRH">
				<cfelse>
				
					<cfif isdefined('form.Pnacimiento') and len(form.Pnacimiento)>
						<cf_sifcalendario name="Pnacimiento" value="#LSDateFormat(form.Pnacimiento,'dd/mm/yyyy')#" 
							tabindex="1" form="formRH">
					<cfelse>
						<cf_sifcalendario name="Pnacimiento" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" 
							tabindex="1" form="formRH">
					</cfif>
				</cfif>
		</td>
		<td valign="top" colspan="2">
			<textarea name="Pdireccion" id="Pdireccion2" onFocus="this.select()" style="width: 100%"><cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pdireccion#</cfoutput></cfif></textarea>
		</td>

    </tr>
    <tr> 
		<td>&nbsp;</td>
		<td><strong>Tel&eacute;fono Casa</strong></td>
		<td><strong>Tel&eacute;fono Oficina</strong></td>
		<td><strong>Tel&eacute;fono Celular</strong></td>
		<td><strong>Fax</strong></td>
    </tr>
    <tr> 
		<td>&nbsp;</td>
		<td> 
			<input name="Pcasa" type="text" id="Pcasa" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pcasa#</cfoutput></cfif>"> 
		</td>
		<td> 
			<input name="Poficina" type="text" id="Poficina" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Poficina#</cfoutput></cfif>"> 
		</td>
		<td> 
			<input name="Pcelular" src="../../Imagenes/delete.small.png" type="text" onFocus="this.select()" id="Pcelular" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pcelular#</cfoutput></cfif>"> 
		</td>
		<td valign="top"> 
			<input name="Pfax" type="text" id="Pfax2" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pfax#</cfoutput></cfif>"> 
		</td>
    </tr>
    <tr>
		<td>&nbsp;</td>
      <td><strong>N&uacute;mero Pager</strong></td>
	  <td><strong>Tel&eacute;fono Pager</strong></td>
      <td><strong>Mail Principal</strong></td>
      <td><strong>Mail Secundario</strong></td>
    </tr>
    <tr> 
		<td>&nbsp;</td>
		<td> 
			<input name="Ppagernum" type="text" onFocus="this.select()" id="Ppagernum" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Ppagernum#</cfoutput></cfif>"> 
		</td>
		<td valign="top"> 
			<input name="Ppagertel" type="text" id="Ppagertel"  onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Ppagertel#</cfoutput></cfif>">
		</td>
		<td> 
			<input name="Pemail1" type="text" id="Pemail1"  onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pemail1#</cfoutput></cfif>" size="30"> 
		</td>
		<td> 
			<input name="Pemail2" type="text" id="Pemail2"  onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pemail2#</cfoutput></cfif>" size="30"> 
		</td>
    </tr> 
	<tr>
		<td>&nbsp;</td>
		<td><strong>Pa&iacute;s</strong></td>
		<td colspan="3"><strong>Ruta de Imagen</strong></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<select name="Ppais" id="select">
				<cfoutput query="rsPaises"> 
					<cfif modo EQ 'CAMBIO' and #rsForm.Ppais# EQ #rsPaises.Ppais#>
						<option value="#rsPaises.Ppais#" selected>#rsPaises.Pnombre#</option>
					<cfelse>
						<cfif #rsPaises.Ppais# EQ 'CR'>
							<option value="#rsPaises.Ppais#" selected>#rsPaises.Pnombre#</option>
						<cfelse>
							<option value="#rsPaises.Ppais#">#rsPaises.Pnombre#</option>
						</cfif>
					</cfif>
				</cfoutput> 
			</select> 
		</td>
		<td><input type="file" name="Pfoto"></td>
	</tr>
	<tr><td colspan="5">&nbsp;</td></tr>
    <tr> 
		<td colspan="5" align="center"> 
			<!-- Alta -->
			<cf_botones modo="#modo#" incluyeForm="true" formName="formbtn">
			<!--- <cfif modo EQ 'ALTA'>
				
				<input type="button"  name="btnLimpiar"  value="Limpiar" onClick="javascript: limpiar()" >
				<input name="btnAgregar" type="submit" id="btnAgregar" value="Agregar"> 
				<input name="btnBuscar" type="submit" id="btnBuscar" value="Buscar" onClick="javascript: setBtn(this); deshabilitarValidacion()"> 
			 <cfelse>
				
				<input type="submit" name="btnCambiar" id="btnCambiar"  value="Cambiar" onClick="habilitarValidacion();" >
				<input type="submit" name="btnBorrar"   id="btnBorrar" value="Borrar" onClick="deshabilitarValidacion(); return confirm('Esta seguro(a) que desea borrar esta persona?')" >
				<input type="submit" name="btnNuevo"   id="btnNuevo" value="Nueva Persona" onClick="deshabilitarValidacion()" >
				<input type="button"  name="btnLimpiar"   value="Limpiar"  onClick="javascript: limpiar()" >
			</cfif>  --->
		</td>
    </tr>
    
</table>  
 </form>
 
<script language="JavaScript" type="text/javascript" src="../../js/calendar.js" >//</script>
<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/javascript" src="js/formRh.js">//</script> 

 
<cf_qforms form="formRH">
<script language="JavaScript" type="text/javascript" >
//------------------------------------------------------------------------------------------						
	function deshabilitarValidacion() {
		objForm.Pnombre.required = false;
		<cfif modo EQ "ALTA">
			objForm.Ncodigo.required = false;
		</cfif>
		objForm.Pid.required = false;
		objForm.Papellido1.required = false;								
		objForm.Ppais.required = false;			
	}
//------------------------------------------------------------------------------------------						
	function habilitarValidacion() {
		objForm.Pnombre.required = true;
		<cfif modo EQ "ALTA">
			if (objForm.Dcodigo.obj.checked) {
				//objForm.Ncodigo.required = true;
				objForm.Ncodigo.required = false; //Para que no valide el combo, solo el conlis puede cambiar los niveles del Director
			}
		</cfif>
		objForm.Pid.required = true;
		objForm.Papellido1.required = true;								
		objForm.Ppais.required = true;			
			
	}	
//------------------------------------------------------------------------------------------							
	
	function TieneTipo() {
	
		// Valida que por lo menos se seleccione un tipo
		var bandera = false;
		
		if (objForm.Acodigo.obj.checked) {
			bandera = true;
		}else{
			if (objForm.EEcodigo.obj.checked) {
				bandera = true;
			}else{
				if (objForm.Splaza.obj.checked) {
					bandera = true;
				}else{
					if (objForm.Dcodigo.obj.checked) {
						bandera = true;
					}					
				}				
			}			
		}
		
		if (!bandera){
			alert("Error, debe seleccionar al menos uno de los tipos para el recurso humano");
			//this.error = "Error, debe seleccional al menos uno de los tipos para el recurso humano";
			//objForm.Acodigo.focus();
			return false;
		}
		else{
			return true;
		}
	}	
	
	function funcCambio(){
		if(!TieneTipo()){
			return false;
		}
		
		if(TieneTipo()){
			habilitarValidacion();
			return true;
		}
	}
	
	function funcAlta(){
		if(!TieneTipo()){
			return false;
		}
		
		if(TieneTipo()){
			habilitarValidacion();
			return true;
		}
	}

	function funcBaja(){
		if(confirm('Desea eliminar el registro?')){
			deshabilitarValidacion();
			return true;
		}else{return false;}			
	}
	
	<cfif modo EQ "ALTA">
		objForm.Pnombre.required = true;
		objForm.Pnombre.description = "nombre";
		objForm.Ncodigo.required = true;
		objForm.Ncodigo.description = "nivel";								
		objForm.Pid.required = true;
		objForm.Pid.description = "Identificacin";		
		objForm.Papellido1.required = true;
		objForm.Papellido1.description = "Primer Apellido";
		objForm.Ppais.required = true;
		objForm.Ppais.description = "Pas";		
	<cfelse>
		objForm.Pnombre.required = true;
		objForm.Pnombre.description = "nombre";								
		//objForm.Ncodigo.required = true;
		//objForm.Ncodigo.description = "nivel";		
		objForm.Pid.required = true;
		objForm.Pid.description = "Identificacin";		
		objForm.Papellido1.required = true;
		objForm.Papellido1.description = "Primer Apellido";
		objForm.Ppais.required = true;
		objForm.Ppais.description = "Pas";		
	</cfif> 
	
	
//------------------------------------------------------------------------------------------		
	inicio();
</script>

