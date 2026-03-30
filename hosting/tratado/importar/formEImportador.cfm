<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="sifcontrol">
		select
			upper(rtrim(EIcodigo)) as EIcodigo, EImodulo, Ecodigo, EIdescripcion,
			EIdelimitador, EIusatemp, EItambuffer,
			EIparcial, EIverificaant, EIimporta, EIexporta, b.EIsql, b.EIsqlexp,
			EIcfimporta, EIcfexporta,EIcfparam 
		from EImportador a
			left outer join EISQL b
				on a.EIid = b.EIid
		where a.EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
	</cfquery>
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="sifcontrol">
	select rtrim(EIcodigo) as EIcodigo
	from EImportador
	<cfif modo neq 'ALTA'>
	where EIid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
	</cfif>
</cfquery>
<!---<cfquery name="rsModulos" datasource="sifcontrol">
	select modulo, nombre from sdc..Modulo
	where sistema in ('sif','rh')
	and activo=1
	order by sistema, modulo, nombre
</cfquery>--->
<cfquery name="rsModulos" datasource="asp">
	select SScodigo, SMcodigo, SMdescripcion nombre
	from SModulos
	where SScodigo in ('SIF','RH','SACI','TLC')
	order by SScodigo, SMcodigo, SMdescripcion
</cfquery>
<cfoutput>
	<table border="0" width="980" cellpadding="0" cellspacing="0" align="center">

		<tr><td colspan="5" class="tituloAlterno"><cf_translate  key="LB_Encabezado de Formato">Encabezado de Formato</cf_translate></td></tr>

		<tr>
			<td width="6%">&nbsp;</td>
			<td width="29%" colspan="2"><cf_translate  key="LB_Codigo">C&oacute;digo</cf_translate>:<br>
			<cfset EIcodigoInputValue="">
			<cfif modo neq 'ALTA'>
				<cfset EIcodigoInputValue=Trim(rsForm.EIcodigo)>
			</cfif>
			<input name="EIcodigo" type="text" tabindex="1"
				 value="#EIcodigoInputValue#" size="15" maxlength="12"
				 onblur="codigos(this)" 
				 onKeyPress="event.keyCode= String.fromCharCode(event.keyCode).toUpperCase().charCodeAt(0)"
				 onfocus="this.select();" alt="El C&oacute;digo" ></td>

			<td width="29%"><cf_translate  key="LB_Modulo">M&oacute;dulo</cf_translate>:<br>
				<select name="EImodulo" tabindex="1">
					<option value="">-Seleccione uno-</option>
					<cfloop query="rsModulos">
						<cfset modulo = LCase(Trim(rsModulos.SScodigo) & '.' & Trim(rsModulos.SMcodigo))>
						<option value="#modulo#"
							 <cfif modo neq 'ALTA' and trim(rsForm.EImodulo) eq trim(modulo) >selected</cfif> >
							 #modulo# - #rsModulos.nombre#</option>
					</cfloop>
				</select>
			</td>

			<td width="36%"><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate>:<br>
				<input type="text" name="EIdescripcion" size="40" maxlength="40" tabindex="1" value="<cfif modo neq 'ALTA'>#trim(rsForm.EIdescripcion)#</cfif>" onfocus="this.select();" >
			</td>

		</tr>

		<tr>
			<td rowspan="2">&nbsp;</td>

			<td><cf_translate  key="LB_Delimitador">Delimitador</cf_translate>:<br>
			</td>

		  <td><br>              </td>
			<td rowspan="2" valign="top"><input type="checkbox" id="EIparcial" value="1" name="EIparcial" tabindex="1" <cfif modo neq 'ALTA' and rsForm.EIparcial eq 1>checked</cfif> >
<label for="EIparcial"><cf_translate  key="CHK_PermiteImportacionParcial">Permite Importaci&oacute;n Parcial</cf_translate> </label></td>

			<td rowspan="2" valign="middle">
				<input type="checkbox" value="1" id="EIusatemp" name="EIusatemp" tabindex="1" <cfif modo neq 'ALTA' and rsForm.EIusatemp eq 1>checked</cfif> >
				<label for="EIusatemp"><cf_translate  key="CHK_UsaTablaTemporal">Usa tabla Temporal</cf_translate></label>
			</td>

		</tr>
		<tr>
		  <td><select name="EIdelimitador" tabindex="1">
            <option value="C" <cfif modo neq 'ALTA' and rsForm.EIdelimitador eq 'C'>selected</cfif> ><cf_translate  key="CMB_Coma">Coma</cf_translate></option>
            <option value="T" <cfif modo neq 'ALTA' and rsForm.EIdelimitador eq 'T'>selected</cfif> ><cf_translate  key="CMB_Coma">Tab</cf_translate>Tab</option>
            <option value="L" <cfif modo neq 'ALTA' and rsForm.EIdelimitador eq 'L'>selected</cfif> ><cf_translate  key="CMB_Linea">L&iacute;nea</cf_translate></option>
            <option value="P" <cfif modo neq 'ALTA' and rsForm.EIdelimitador eq 'P'>selected</cfif> ><cf_translate  key="CMB_Pipe">Pipe</cf_translate></option>
          </select></td>
		  <td>&nbsp;</td>
	  </tr>
	
		<tr>
			<td rowspan="2">&nbsp;</td>
			<td colspan="3"><cf_translate  key="LB_TamanoDelBufer">Tama&ntilde;o del B&uacute;fer</cf_translate>:</td>
			<td><cf_translate  key="LB_VerificaImportacionesAnteriores">Verifica Importaciones Anteriores</cf_translate>:
			</td>
		</tr>
		<tr>
		  <td colspan="3"><input type="text" name="EItambuffer" size="6" maxlength="6" tabindex="1" value="<cfif dmodo neq 'ALTA'>#rsForm.EItambuffer#<cfelse>0</cfif>" style="text-align: right;" onBlur="javascript:fm(this,0); " 
				onFocus="javascript:this.value=qf(this); this.select();" 
				onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>
	      <td><select name="EIverificaant" tabindex="1">
            <option value="0" <cfif modo neq 'ALTA' and rsForm.EIverificaant eq 0>selected</cfif> ><cf_translate  key="CMB_NoVerifica">No verifica</cf_translate></option>
            <option value="1" <cfif modo neq 'ALTA' and rsForm.EIverificaant eq 1>selected</cfif> ><cf_translate  key="CMB_NombreDeArchivo">Nombre de Archivo</cf_translate></option>
            <option value="2" <cfif modo neq 'ALTA' and rsForm.EIverificaant eq 2>selected</cfif> ><cf_translate  key="CMB_Contenido">Contenido</cf_translate></option>
            <option value="3" <cfif modo neq 'ALTA' and rsForm.EIverificaant eq 3>selected</cfif> ><cf_translate  key="CMB_Ambos">Ambos</cf_translate></option>
          </select></td>
	  </tr>

		<tr>
			<td>&nbsp;</td>
			<td colspan="4">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="middle">
							<input type="checkbox" value="1" id="EIimporta" name="EIimporta" tabindex="1" onClick="javascript:habilita(this, objForm.EIsql.obj); <cfif modo neq 'ALTA'>combo();</cfif>" <cfif modo neq 'ALTA' and rsForm.EIimporta eq 1>checked</cfif> >
							<label for="EIimporta"><cf_translate  key="CHK_Importa">Importa</cf_translate></label>						</td>
						<td valign="middle">
							<input type="checkbox" value="1" id="EIexporta" name="EIexporta" tabindex="1" onClick="javascript:habilita(this, objForm.EIsqlexp.obj); <cfif modo neq 'ALTA'>combo();</cfif>" <cfif modo neq 'ALTA' and rsForm.EIexporta eq 1>checked</cfif> >
							<label for="EIexporta"><cf_translate  key="CHK_Exporta">Exporta</cf_translate></label>
						</td>
					</tr>	
					<tr>
						<td width="50%" valign="top" ><cf_translate  key="LB_SQLImportacion">SQL Importaci&oacute;n</cf_translate>
							<a tabindex="-1" href="javascript:switchSize(document.form1.EIsql, 8, 40)" shape="rect">[<cf_translate  key="LB_AgrandarEncoger">agrandar / encoger</cf_translate>]</a>
							<br clear="none">
							<textarea name="EIsql" wrap="off" tabindex="1" <cfif modo neq 'ALTA'><cfif rsForm.EIimporta eq 0 >disabled</cfif><cfelse>disabled</cfif> rows="8" cols="60" style="color: black; width:83%; background: white;font: 10px verdana;"><cfif modo neq 'ALTA'>#trim(rsForm.EIsql)#</cfif></textarea>
						</td>
						<td width="50%" valign="top" ><cf_translate  key="LB_SQLImportacion">SQL Exportaci&oacute;n</cf_translate>
							<a tabindex="-1" href="javascript:switchSize(document.form1.EIsqlexp, 8, 40)" shape="rect">[<cf_translate  key="LB_AgrandarEncoger">agrandar / encoger</cf_translate>]</a>
							<br clear="none">
							<textarea wrap="off"  name="EIsqlexp" tabindex="1" <cfif modo neq 'ALTA'><cfif rsForm.EIexporta eq 0 >disabled</cfif><cfelse>disabled</cfif>  rows="8" cols="60" style="color: black; width:83%; background: white;font: 10px verdana;"><cfif modo neq 'ALTA'>#trim(rsForm.EIsqlexp)#</cfif></textarea>
							<input type="hidden" name="hEIsqlexp" value="<cfif modo neq 'ALTA'>#trim(rsForm.EIsqlexp)#</cfif>" >
						</td>
					</tr>
					<tr>
					  <td valign="top">
		
				<cf_translate  key="AYUDA_EnEstaConsultaDeImportacionPodraUtilizarEnSybaseOColdfusionPeroNoEnOracle">
					En esta consulta de importaci&oacute;n podr&aacute; utilizar (en sybase o coldfusion, pero no en oracle) las siguientes variables <strong>predefinidas</strong>:
					<ul style="margin-top:0;" >
					  <li>@es_parcial    bit (coldfusion: variable boolean es_parcial ) </li>
						<li>@Ecodigo       int (coldfusion: session.Ecodigo ) </li>
						<li>@Usulogin      varchar(30) (coldfusion: session.Ecodigo ) </li>
						<li>@Usucodigo     numeric (coldfusion: session.Usucodigo ) </li>
						<li>La columna &quot;id&quot; es un campo identity autogenenerado. <br>				  
						  <p>Las fechas deben tener el formato YYYYMMDD, ej: 20021012 (12/10/2003)</p>
						</li>
					</ul>
				</cf_translate>	
					  </td>
					  <td valign="top">
					  			  <cf_translate  key="AYUDA_EnEstaConsultaDeExportacionPodraUtilizarLasSiguientesVariablesPredefinidas">
								  En esta consulta de exportaci&oacute;n podr&aacute; utilizar las siguientes variables <strong>predefinidas</strong>:
                                  <ul style="margin-top:0;" >
                                    <li>@Ecodigo int</li>
                                    <li>@Usulogin varchar(30)</li>
                                    <li>@Usucodigo numeric </li>
                                </ul>
								</cf_translate> </td></tr>
					<tr>
					  <td valign="top"><cf_translate  key="LB_ScriptDeColdfusionParaLaImportacionEnVezDeEjecutarElSQL">Script de coldfusion para la importaci&oacute;n (en vez de ejecutar el SQL)</cf_translate> </td>
					  <td valign="top"><cf_translate  key="LB_ScriptDeColdfusionParaLaImportacionEnVezDeEjecutarElSQL">Script de coldfusion para la importaci&oacute;n (en vez de ejecutar el SQL)</cf_translate> </td>
				  </tr>
					<tr>
					  <td valign="top"><input name="EIcfimporta" onBlur="pagina(this)" type="text" id="EIcfimporta" tabindex="1" onFocus="this.select();" value="<cfif modo neq 'ALTA'>#trim(rsForm.EIcfimporta)#</cfif>" size="60" maxlength="255" >
                        <a href="javascript:conlisFiles()"><img src="foldericon.gif" width="16" height="16" border="0"></a></td>
					  <td valign="top"><input name="EIcfexporta" onBlur="pagina(this)" type="text" id="EIcfexporta" tabindex="1" onFocus="this.select();" value="<cfif modo neq 'ALTA'>#trim(rsForm.EIcfexporta)#</cfif>" size="60" maxlength="255" >
                          <a href="javascript:conlisFilesEX()"><img src="foldericon.gif" width="16" height="16" border="0"></a></td>
				  </tr>
				  <tr>
					  <td  colspan="2" valign="top"><cf_translate  key="LB_ScriptDeColdfusionParaParametros">Script de coldfusion para la parámetros</cf_translate> </td>
				  </tr>	
				  <tr>
					  <td valign="top"><input name="EIcfparam" onBlur="pagina(this)" type="text" id="EIcfparam" tabindex="1" onFocus="this.select();" value="<cfif modo neq 'ALTA'>#trim(rsForm.EIcfparam)#</cfif>" size="60" maxlength="255" >
                        <a href="javascript:conlisFilesPARAM()"><img src="foldericon.gif" width="16" height="16" border="0"></a>
						<!--- <cf_sifayudaRoboHelp --->
						<cf_sifayuda
							name="imAyuda" 
							width="800"
							height ="500"
							imagen="3" 
							tip="false"
							scrollbars="yes"
							url="/cfmx/hosting/tratado/importar/Ayuda_Exportador.cfm">	
						</td>
				  </tr>				  			  
				</table>
			</td>
		</tr>

		<cfif modo neq 'ALTA'>
			<input type="hidden" name="EIid" value="#form.EIid#">
		</cfif>
	
  </table>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function switchSize(txt, size1, size2){
		if ( !txt.disabled ){
			txt.rows = txt.rows == size1 ? size2 : size1;
			txt.focus();
		}	
	}
	
	function codigos(obj){
		if (obj.value != "") {
			obj.value = obj.value.toUpperCase();
			var dato  = obj.value;
			var temp  = new String();
			var found = false;
			<cfloop query="rsCodigos">
			found |= (dato == '<cfoutput>#UCase(Trim(rsCodigos.EIcodigo))#</cfoutput>');
			</cfloop>
			if (found){
				alert('El Código ya existe.');
				obj.value = "<cfif modo neq 'ALTA'><cfoutput>#UCase(Trim(rsForm.EIcodigo))#</cfoutput></cfif>";
				obj.focus();
				return false;
			}
		}	
		return true;
	}
	
	function validaEncabezado(value){
		objForm.EIcodigo.obj.disabled = value;
	}
	
	function habilita(checkObj, areaObj){
		areaObj.disabled = !checkObj.checked;
	}
	
	habilita(document.form1.EIimporta, document.form1.EIsql);
	habilita(document.form1.EIexporta, document.form1.EIsqlexp);
	
	
	
	function closePopup() {
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
			window.gPopupWindow = null;
		}
	}
	
	function conlisFiles(){
		closePopup();
		window.gPopupWindow = window.open('files.cfm?c=1&p='+escape(document.form1.EIcfimporta.value),'_blank',
			'left=50,top=50,width=300,height=400,status=no,toolbar=no,title=no');
		window.onfocus = closePopup;
	}
	
	function conlisFilesSelect(filename){
		document.form1.EIcfimporta.value = filename;
		closePopup();
		window.focus();
		document.form1.EIcfimporta.focus();
	}

	function conlisFilesEX(){
		closePopup();
		window.gPopupWindow = window.open('files.cfm?c=2&p='+escape(document.form1.EIcfexporta.value),'_blank',
			'left=50,top=50,width=300,height=400,status=no,toolbar=no,title=no');
		window.onfocus = closePopup;
	}
	
	function conlisFilesSelectEX(filename){
		document.form1.EIcfexporta.value = filename;
		closePopup();
		window.focus();
		document.form1.EIcfexporta.focus();
	}
	
	function conlisFilesPARAM(){
		closePopup();
		window.gPopupWindow = window.open('files.cfm?c=3&p='+escape(document.form1.EIcfparam.value),'_blank',
			'left=50,top=50,width=300,height=400,status=no,toolbar=no,title=no');
		window.onfocus = closePopup;
	}
	
	function conlisFilesSelectPARAM(filename){
		document.form1.EIcfparam.value = filename;
		closePopup();
		window.focus();
		document.form1.EIcfparam.focus();
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
</script>