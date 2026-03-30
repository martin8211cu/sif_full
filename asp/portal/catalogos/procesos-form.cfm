<script language="javascript1.2" type="text/javascript">
	// ===========================================================================================
	//								Conlis de Articulos
	// ===========================================================================================
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis() {
		popUpWindow("ConlisHomeUri.cfm?SScodigo=" + document.form1.SScodigo.value + "&SMcodigo=" + document.form1.SMcodigo.value + "&SPcodigo=" + document.form1.SPcodigo.value ,250,200,650,350);
	}

	function doConlisProcesos() {
		if ( document.form2.SSdestino.value != '' && document.form2.SMdestino.value != '' ){
			popUpWindow("conlisProcesosRelacionados.cfm?SScodigo="+document.form2.SSdestino.value+"&SMcodigo="+document.form2.SMdestino.value,250,200,650,400);
		}
		else{
			alert(' - Debe seleccionar el sistema y módulo antes de seleccionar el proceso.')
		}
	}

	// ===========================================================================================
</script>

<!--- Modo --->
<cfif isdefined("form.SPcodigo") and len(trim(form.SPcodigo)) gt 0>
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<!--- codigos que ya existen --->
<cfquery name="rsCodigos" datasource="asp">
	select SPcodigo, SMcodigo, SScodigo 
	from SProcesos
	<cfif modo neq 'ALTA'>
		where SPcodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">
	</cfif>
	order by SPcodigo, SMcodigo, SScodigo
</cfquery>

<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="asp">
		select SScodigo, SMcodigo, SPcodigo, SPdescripcion, SPhomeuri, SPmenu, SPorden, SPhablada, SPanonimo, SPpublico, SPinterno, SPlogo, ts_rversion
		from SProcesos
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
		  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
		  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">
		order by SPcodigo, SPdescripcion
	</cfquery>

	<cfquery name="pro_rol" datasource="asp">
		select pr.SScodigo, r.SRcodigo, r.SRdescripcion
		from SRoles r
		left outer join SProcesosRol pr
		   on pr.SRcodigo = r.SRcodigo
		  and pr.SScodigo = r.SScodigo
		  and pr.SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#" null="#Not IsDefined('form.SScodigo')#">
		  and pr.SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#" null="#Not IsDefined('form.SMcodigo')#">
		  and pr.SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#" null="#Not IsDefined('form.SPcodigo')#">
		where  r.SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#" null="#Not IsDefined('form.SScodigo')#">
		order by r.SScodigo, r.SRcodigo, r.SRdescripcion
	</cfquery>

	<cfquery name="SMNcodigoPadre" datasource="asp">
		select SMNcodigoPadre
		from SMenues
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#" null="#Not IsDefined('form.SScodigo')#">
		  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#" null="#Not IsDefined('form.SMcodigo')#">
		  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#" null="#Not IsDefined('form.SPcodigo')#">
		order by SMNcodigoPadre
	</cfquery>
	<cfset SMNcodigoPadre = SMNcodigoPadre.SMNcodigoPadre>
<cfelse>
	<cfset SMNcodigoPadre = ''>
</cfif>

<SCRIPT src="/cfmx/sif/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script type="text/javascript" language="javascript1.2">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>




<cfoutput>
<form style="margin:0;" name="form1" method="post" action="procesos-sql.cfm" enctype="multipart/form-data">
	<cfif isdefined("form.fSScodigo") and len(trim(form.fSScodigo)) gt 0><input type="hidden" name="fSScodigo" value="#form.fSScodigo#"></cfif>
	<cfif isdefined("form.fSMcodigo") and len(trim(form.fSMcodigo)) gt 0><input type="hidden" name="fSMcodigo" value="#form.fSMcodigo#"></cfif>
	<cfif isdefined("form.fProceso" ) and len(trim(form.fProceso )) gt 0><input type="hidden" name="fProceso" value="#form.fProceso#"></cfif>
	
	<table width="100%" cellpadding="0" cellspacing="2" border="0">
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'>
					<input type="submit" name="Guardar" 	value="Guardar" 	class="btnGuardar">
					<input type="submit" name="Eliminar" 	value="Eliminar"    class="BtnEliminar" onClick="deshabilitarValidacion();">
					<input type="button" name="Nuevo" 		value="Nuevo" 	    class="BtnNuevo"    onClick="location.href='procesos.cfm?SScodigo='+escape(filtro.fSScodigo.value)+'&fSScodigo='+escape(filtro.fSScodigo.value)+'&SMcodigo='+escape(filtro.fSMcodigo.value)+'&fSMcodigo='+escape(filtro.fSMcodigo.value)">
					<input type="submit" name="Componentes" value="Componentes" class="btnNormal"   onClick="deshabilitarValidacion()">
				<cfelse>
					<input type="submit" name="Agregar"     value="Agregar"     class="btnGuardar">
				</cfif>
			</td>
		</tr>
		<!--- Sistema --->
		<tr>
		  <td align="right" class="etiquetaCampo">&nbsp;</td>
		  <td align="left"><span class="etiquetaCampo">Sistema:&nbsp;</span></td>
	  </tr>
		<tr>
			<td align="right" class="etiquetaCampo">&nbsp;</td>
			<td align="left">
			<cfif IsDefined("form.fSScodigo") and not isdefined("form.SScodigo")>
				<cfset form.SScodigo = form.fSScodigo>
			</cfif>
			<cfif IsDefined("form.fSMcodigo") and not isdefined("form.SMcodigo")>
				<cfset form.SMcodigo = form.fSMcodigo>
			</cfif>
				<cfif modo eq 'ALTA'>
					<cfset defaultSScodigo="">
				 <cfif isdefined("form.SScodigo")><cfset defaultSScodigo=form.SScodigo>
				 <cfelseif isdefined("form.fSScodigo")><cfset defaultSScodigo=form.fSScodigo>
				 </cfif>
				 <select name="SScodigo" onChange="javascript:change_sistema(this, document.form1);change_modulo(this.form);">
						<cfloop query="rsSistemas">
							<option value="#rsSistemas.SScodigo#" <cfif Trim(defaultSScodigo) eq Trim(rsSistemas.SScodigo) >selected</cfif> >#rsSistemas.SSdescripcion#</option>
						</cfloop>
					</select>
				<cfelse>	
					<cfloop query="rsSistemas">
						<cfif Trim(rsSistemas.SScodigo) EQ Trim(form.SScodigo)>
							<b>#rsSistemas.SScodigo# - #rsSistemas.SSdescripcion#</b>
						</cfif>
					</cfloop>
					<input name="SScodigo" type="hidden" value="#form.SScodigo#">
				</cfif>
			</td>
		</tr>

		<!--- Modulo --->
		<tr>
		  <td align="right" class="etiquetaCampo" >&nbsp;</td>
		  <td align="left"><span class="etiquetaCampo">M&oacute;dulo:&nbsp;</span></td>
	  </tr>
		<tr>
			<td align="right" class="etiquetaCampo" >&nbsp;</td>
			<td align="left">
				<cfif modo eq 'ALTA'>
					<select name="SMcodigo" onChange="javascript:change_modulo(document.form1);">
					</select>
				<cfelse>
					<cfloop query="rsModulos">
						<cfif Trim(rsModulos.SScodigo) EQ Trim(form.SScodigo) And Trim(rsModulos.SMcodigo) EQ Trim(form.SMcodigo)>
							<b>#rsModulos.SMcodigo# - #rsModulos.SMdescripcion#</b>
						</cfif>
					</cfloop>
					<input name="SMcodigo" type="hidden" value="#form.SMcodigo#">
				</cfif>	
			</td>
		</tr>
	
		<!--- Codigo --->
		<tr>
		  <td align="right" class="etiquetaCampo" >&nbsp;</td>
		  <td align="left"><span class="etiquetaCampo">C&oacute;digo:</span></td>
	  </tr>
		<tr>
			<td align="right" class="etiquetaCampo" >&nbsp;</td>
			<td align="left">
				<input type="text" name="SPcodigo" size="17" maxlength="10" onBlur="codigos(this);" onFocus="this.select();" value="<cfif modo neq 'ALTA'>#rsForm.SPcodigo#</cfif>" >
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="SPcodigo2" value="#rsForm.SPcodigo#" >
				</cfif>
			</td>
		</tr>

		<!--- Menu asociado --->
		<tr>
		  <td align="right" class="etiquetaCampo" >&nbsp;</td>
		  <td align="left"><span class="etiquetaCampo">Men&uacute;:&nbsp;</span></td>
	  </tr>
		<tr>
			<td align="right" class="etiquetaCampo" >&nbsp;</td>
			<td align="left">
				<select name="SMNcodigo">
					<option value="">-Ninguno-</option>
					<cfset defaultSScodigo = "">
					<cfset defaultSMcodigo = "">
					<cfif modo neq 'ALTA'>
						<cfset defaultSScodigo = form.SScodigo>
						<cfset defaultSMcodigo = form.SMcodigo>
					<cfelse>
						<cfif isdefined("form.fSScodigo")>
							<cfset defaultSScodigo = form.fSScodigo></cfif>
						<cfif isdefined("form.fSMcodigo")>
							<cfset defaultSMcodigo = form.fSMcodigo></cfif>
					</cfif>
					<cfloop query="rsMenues">
						<cfif Trim(defaultSScodigo) is Trim(rsMenues.SScodigo) and Trim(defaultSMcodigo) is Trim(rsMenues.SMcodigo)>
						<option value="#SMNcodigo#" <cfif SMNcodigoPadre is rsMenues.SMNcodigo>selected</cfif>>#SMNtitulo#</option>
						</cfif>
					</cfloop>
				</select>
			</td>
		</tr>
	
		<!--- Descripcion --->
		<tr>
		  <td align="right" class="etiquetaCampo" >&nbsp;</td>
		  <td align="left"><span class="etiquetaCampo">Descripci&oacute;n:&nbsp;</span></td>
	  </tr>
		<tr>
			<td align="right" class="etiquetaCampo" >&nbsp;</td>
			<td align="left"><input type="text" name="SPdescripcion" size="40" maxlength="100" onFocus="this.select();" value="<cfif modo neq 'ALTA'>#trim(rsForm.SPdescripcion)#</cfif>" ></td>
		</tr>

		<!--- Pagina de Inicio --->
		<tr>
		  <td align="right" class="etiquetaCampo" nowrap>&nbsp;</td>
		  <td align="left" nowrap><span class="etiquetaCampo">P&aacute;gina Inicial:</span></td>
	  </tr>
		<tr>
			<td align="right" class="etiquetaCampo" nowrap>&nbsp;</td>
			<td align="left" nowrap>
				<input type="text" name="SPhomeuri" size="40" maxlength="255" onBlur="javascript:pagina(this);" onFocus="this.select();" value="<cfif modo neq 'ALTA'>#trim(rsForm.SPhomeuri)#</cfif>" >
				<cfif modo neq 'ALTA'>
					<a href="##">
						<img src="../../imagenes/home.gif" alt="Lista de Componentes" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis();">
					</a> 
				</cfif>
				<a href="javascript:conlisFiles()" ><img width="16" height="16" src="foldericon.png" border="0"></a>
			</td>
		</tr>

		<tr>
		  <td>&nbsp;</td>
		  <td align="left">
		  <table border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td valign="top"><input style="border:0;" type="checkbox" id="SPinterno" name="SPinterno" value="" <cfif modo neq 'ALTA' and rsForm.SPinterno eq 1 >checked</cfif>></td>
              <td valign="top"><div align="justify">
                <label for="SPinterno"><strong>Uso interno</strong>. Seleccione esta opci&oacute;n para evitar  que el proceso aparezca entre la lista de los permisos asignables a los usuarios empresariales.
				El acceso a estos procesos se asignar&aacute; &uacute;nicamente a trav&eacute;s de los grupos de procesos autorizados. </label>
              </div></td>
            </tr>
          </table></td></tr>
		<tr>
			<td>&nbsp;</td>
			<td align="left">
			  <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign="top">
				  	<input style="border:0;" type="checkbox" id="SPmenu" name="SPmenu" value="" 
							<cfif modo eq 'ALTA' or rsForm.SPmenu eq 1 >checked</cfif>>
				  </td>
                  <td><div align="justify">
                    <label for="SPmenu"><strong>Mostrar en men&uacute;.</strong></label>
                  </div></td>
                </tr>
              </table></td>
		</tr>

		<tr>
			<td>&nbsp;</td>
		    <td align="left" nowrap>
		      <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign="top"><input style="border:0;" type="checkbox" id="SPanonimo"  name="SPanonimo" value="" <cfif modo neq 'ALTA' and rsForm.SPanonimo eq 1 >checked</cfif>></td>
                  <td valign="middle"><div align="justify">
                    <label for="SPanonimo"><strong>Acceso an&oacute;nimo. </strong>El acceso a este proceso estar&aacute; siempre abierto, incluso si no se ha iniciado una sesi&oacute;n con el portal. Utilice esta opci&oacute;n con mucho cuidado, ya que  podr&iacute;a estar abriendo una brecha en la seguridad si la l&oacute;gica del proceso tuviera alguna falla. <br>
<em><strong>N.B.: </strong>No aparecer&aacute; en el men&uacute; para los usuarios, a menos que tambi&eacute;n lo tengan asignado por permisos.</em>
</label>
                  </div></td>
                </tr>
              </table></td>
		</tr>
		
		<tr>
			<td>&nbsp;</td>
			<td align="left">
				<table align="left" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top"><input style="border:0;" type="checkbox" id="SPpublico" name="SPpublico" value="" <cfif modo neq 'ALTA' and rsForm.SPpublico eq 1 >checked</cfif>></td>
						<td align="left" valign="top"><div align="justify">
						  <label for="SPpublico"><strong>P&uacute;blico.</strong> Cualquier usuario que haya iniciado sessi&oacute;n en el portal tendr&aacute; acceso a este proceso. <br>
<em><strong>N.B.: </strong>No aparecer&aacute; en el men&uacute; para los usuarios, a menos que tambi&eacute;n lo tengan asignado por permisos.</em>
</label>
					    </div></td>
					</tr>
				</table>
			</td>
		</tr>
	
<cfif modo neq 'ALTA'>
		<tr>
		  <td align="right" valign="top" class="etiquetaCampo">&nbsp;</td>
		  <td><span class="etiquetaCampo">Grupos de Procesos Autorizados:</span></td>
	    </tr>
		<tr>
		  <td align="right" valign="top" class="etiquetaCampo">&nbsp;</td>
		  <td>
<table cellpadding="0" cellspacing="0" border="0">
<cfloop query="pro_rol">
<tr><td valign="top">
<input type="checkbox" name="SRcodigo" id="SRcodigo#CurrentRow#" value="#SRcodigo#" style="border:0 " <cfif Len(Trim(pro_rol.SScodigo))>checked</cfif>>
</td><td valign="top">
<label for="SRcodigo#CurrentRow#">
#HTMLEditFormat(pro_rol.SRcodigo)# - #HTMLEditFormat(pro_rol.SRdescripcion)#</label>
</td></tr>
</cfloop>
</table>
</td>
	  </tr></cfif>
		<tr>
		  <td align="right" class="etiquetaCampo">&nbsp;</td>
		  <td align="left"><span class="etiquetaCampo">Orden:&nbsp;</span></td>
	  </tr>
		<tr>
			<td align="right" class="etiquetaCampo">&nbsp;</td>
			<td align="left">
				<input name="SPorden" type="text" style="text-align: right;" onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'>#rsForm.SPorden#</cfif>" size="5" maxlength="4" >
			</td>
		</tr>
	
		<tr>
		  <td align="right" class="etiquetaCampo">&nbsp;</td>
		  <td align="left"><span class="etiquetaCampo">Modificar Logo:&nbsp;</span></td>
	  </tr>
		<tr>
			<td align="right" class="etiquetaCampo">&nbsp;</td>
			<td align="left">
				<input name="logo" type="file" id="logo" onChange="previewLogo(this.value)">
				<!---
				<cfif modo neq 'ALTA'>
					<cf_leerimagen autosize="true" border="false" tabla="SProcesos" campo="SPlogo" condicion="SPcodigo = '#form.SPcodigo#' and datalength(SPlogo) > 1" conexion="asp" imgname="img" >
				</cfif>
				--->
			</td>
		</tr>

	    <tr>
	      <td align="right" valign="top" class="etiquetaCampo">&nbsp;</td>
	      <td align="left"><span class="etiquetaCampo">Informaci&oacute;n:&nbsp;</span></td>
      </tr>
      <tr>
		<td align="right" valign="top" class="etiquetaCampo">&nbsp;</td>
		<td align="left">
			<textarea name="SPhablada" cols="33" rows="8" onFocus="this.select();"><cfif modo neq 'ALTA'>#rsForm.SPhablada#</cfif></textarea>
			<br><b>El texto ingresado aqu&iacute;, ser&aacute; mostrado en el men&uacute;.</b>
		</td>
	</tr>

		<tr>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
	  </tr>
		<tr><td>&nbsp;</td><td>&nbsp;</td></tr>
		<!--- Botones --->
		<tr><td>&nbsp;</td><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'>
					<input type="submit" name="Guardar" value="Guardar">
					<input type="submit" name="Eliminar" value="Eliminar" onClick="deshabilitarValidacion();">
					<input type="button" name="Nuevo" value="Nuevo" onClick="location.href='procesos.cfm?SScodigo='+escape(filtro.fSScodigo.value)+'&fSScodigo='+escape(filtro.fSScodigo.value)+'&SMcodigo='+escape(filtro.fSMcodigo.value)+'&fSMcodigo='+escape(filtro.fSMcodigo.value)">
					<input type="submit" name="Componentes" value="Componentes" onClick="deshabilitarValidacion()">
				<cfelse>
					<input type="submit" name="Agregar" value="Agregar">
				</cfif>
			</td>
		</tr>

	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="2" align="center" valign="top">
			<!--- <cf_leerimagen autosize="true" border="false" tabla="SSistemas" campo="SSlogo" condicion="SScodigo = '#form.SScodigo#' and datalength(SSlogo) > 1" conexion="asp" imgname="img" > --->
		  <cfset imagesrc = "blank.gif">
		  <cfif (modo neq 'ALTA') and Len(rsForm.SPlogo) GT 1>
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="tsurl">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<cfset imagesrc = "/cfmx/home/public/logo_proceso.cfm?s="&URLEncodedFormat(rsForm.SScodigo)&"&m="&URLEncodedFormat(rsForm.SMcodigo)&"&p="&URLEncodedFormat(rsForm.SPcodigo)&"&ts="&tsurl>
			<img src="#imagesrc#" name="logo_preview" id="logo_preview" border="0" width="245" height="155">
		</cfif>
		</td>
	</tr>
	</table>
</form> 

<!--- Procesos Relacionados --->
<cfif modo neq 'ALTA'>
	<cfinclude template="procesos-relacionados.cfm">
</cfif>

</cfoutput>

<script language="javascript1.2" type="text/javascript">
	// ****************************************
	//              QForms  
	// ****************************************
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	<cfif modo eq 'ALTA'>
		objForm.SScodigo.required = true;
		objForm.SScodigo.description = "Sistema";
	
		objForm.SMcodigo.required = true;
		objForm.SMcodigo.description = "Módulo";
	
		objForm.SPcodigo.required = true;
		objForm.SPcodigo.description = "Código";
	</cfif>	

	objForm.SPdescripcion.required = true;
	objForm.SPdescripcion.description = "Descripción";
	
	objForm.SPhomeuri.required = true;
	objForm.SPhomeuri.description = "Página Inicial";

	function deshabilitarValidacion() {
		objForm.SPhomeuri.required = false;
		objForm.SPdescripcion.required = false;
	}
	
	function codigos(obj){
		if (obj.value != "") {
			var dato    = obj.value + '|' + document.form1.SMcodigo.value + '|' + document.form1.SScodigo.value;
			var temp    = new String();
	
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#rsCodigos.SPcodigo#|#rsCodigos.SMcodigo#|#rsCodigos.SScodigo#</cfoutput>';
				if (dato.toUpperCase() == temp.toUpperCase()){
					alert('El Código de Proceso ya existe.');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}	
		return true;
	}
	
	function pagina(obj){
		obj.value = obj.value.
				replace(/\\/g, '/').
				replace(/^https?:\/\/([A-Za-z0-9._]+)(:[0-9]{1,5})?/,'').
				replace(/^\/cfmx/, '').
				replace(/^[A-Za-z]:/,'');
		if (trim(obj.value) != '' && obj.value.charAt(0) != '/') {
			obj.value = "/" + obj.value;
		}
	}

	
	function previewLogo(value) {
		var logo = document.all ? document.all.logo_preview : document.getElementById('logo_preview');
		logo.src = value;
	}
	
	function closePopup() {
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
			window.gPopupWindow = null;
		}
	}
	
	function conlisFiles(){
		closePopup();
		window.gPopupWindow = window.open('files.cfm?p='+escape(document.form1.SPhomeuri.value),'_blank',
			'left=50,top=50,width=300,height=400,status=no,toolbar=no,title=no');
		window.onfocus = closePopup;
	}
	
	function conlisFilesSelect(filename){
		document.form1.SPhomeuri.value = filename;
		closePopup();
		window.focus();
		document.form1.SPhomeuri.focus();
	}
</script>