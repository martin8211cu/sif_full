<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo NEQ "ALTA">
	<cfquery name="rsPadre" datasource="asp">
		select 
			 mn.SMNcodigoPadre
			<cfif isdefined('form.SMNcodigoPadre') and form.SMNcodigoPadre NEQ ''>
				, mnPadre.SMNtitulo as nombrePadre
			</cfif> 
			, mn.SScodigo
			, mn.SMcodigo
			, mn.SMNnivel
			, mn.SPcodigo
			,mn.SMNtipoMenu
			, mn.SMNtitulo
			, mn.SMNexplicativo
			, mn.SMNorden
			, mn.SMNcolumna
			, mn.SMNtipo
			, mn.SMNimagenGrande
			, mn.SMNimagenPequena
			, SSdescripcion
			, SMdescripcion
			, mn.SMNenConstruccion
			, coalesce(mn.opcionprin,0) as opcionprin
			, coalesce(mn.siempreabierto,0) as siempreabierto
			, mn.SMNimagenGrande
			, mn.SMNimagenPequena
			, mn.ts_rversion MNtimestamp
		  from SMenues mn
			, SModulos m
			, SSistemas s
			<cfif isdefined('form.SMNcodigoPadre') and form.SMNcodigoPadre NEQ ''>
				, SMenues mnPadre
			</cfif>
		 where mn.SMNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SMNcodigo#">
		   and m.SScodigo = mn.SScodigo
		   and m.SMcodigo = mn.SMcodigo
		   and s.SScodigo = mn.SScodigo
			<cfif isdefined('form.SMNcodigoPadre') and form.SMNcodigoPadre NEQ ''>
					and mn.SMNcodigoPadre=mnPadre.SMNcodigo
			</cfif>
		  order by mn.SMNcodigoPadre
	</cfquery>
	
	<cfif isdefined('rsPadre') and CompareNoCase(Trim(rsPadre.SMNtipo),'M') EQ 0>
		<cfset varTipo="Men&uacute;">
	<cfelse>	<!--- SMNtipo EQ 'P' --->
		<cfset varTipo="Proceso">	
		<cfif isdefined('rsPadre') and rsPadre.recordCount GT 0>
			<cfquery name="rsProceso" datasource="asp">
				Select SPcodigo,SPdescripcion
				from SProcesos p
					, SModulos sm
					, SSistemas ss
				where SPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rsPadre.SPcodigo#">
					and p.SScodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
					and p.SMcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
					and p.SMcodigo=sm.SMcodigo
					and p.SScodigo=sm.SScodigo
					and sm.SScodigo=ss.SScodigo		
				order by SPcodigo,SPdescripcion
			</cfquery>
		</cfif>
	</cfif>
<cfelse>
	<cfquery name="rsPadre" datasource="asp">
		select 
			SMNtitulo as nombrePadre
			, SSdescripcion
			, SMdescripcion
			, <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.SMNtipo#"> as SMNtipo
		from SMenues mn
			, SModulos m
			, SSistemas s
		where SMNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SMNcodigoPadre#">
		 	and mn.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
			and mn.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
			and mn.SScodigo = m.SScodigo
			and mn.SMcodigo = m.SMcodigo
			and m.SScodigo = s.SScodigo
		order by SMNtitulo
	</cfquery>
	
	<cfif isdefined('form.SMNtipo') and CompareNocase(Trim(form.SMNtipo),'M') EQ 0>
		<cfset varTipo="Men&uacute;">
	<cfelse>	<!--- SMNtipo EQ 'P' --->
		<cfset varTipo="Proceso">	
	</cfif>	
</cfif>
<cfif isdefined('rsPadre') and CompareNoCase(Trim(rsPadre.SMNtipo),'P') EQ 0>
	<cfquery name="rsProcSinMenu" datasource="asp">
		select 	{fn RTRIM(SPcodigo)} as SPcodigo,
				SPdescripcion
		 from SProcesos p
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
		  and not exists (select * from SMenues m
			 					  where m.SScodigo = p.SScodigo
								    and m.SMcodigo = p.SMcodigo
								    and m.SPcodigo = p.SPcodigo)
		order by SPcodigo, SPdescripcion
	</cfquery>
</cfif>

<script language="javascript">
function fnAjustarOrden (pOrdenOriginal, pText)
{
	var LvarNuevo = parseInt(pText.value);
	var LvarViejo = parseInt(pOrdenOriginal);
	
	if (LvarNuevo > LvarViejo) 
		pText.value = LvarNuevo+1;
}
</script>

<form name="formMenues" method="post" action="menues-sql.cfm" enctype="multipart/form-data"
<cfoutput> 
	<cfif modo EQ "CAMBIO">onSubmit="javascript:fnAjustarOrden('#rsPadre.SMNorden#', document.formMenues.SMNorden);"</cfif>>

	<cfif modo neq "ALTA">
		<input type="hidden" name="SMNcodigo" id="SMNcodigo" value="#Form.SMNcodigo#">	
		<input type="hidden" name="SScodigo" id="SScodigo" value="<cfif isdefined("rsPadre") and len(trim(rsPadre.SScodigo)) neq 0>#rsPadre.SScodigo#</cfif>">	
		<input type="hidden" name="SMcodigo" id="SMcodigo" value="<cfif isdefined("rsPadre") and len(trim(rsPadre.SMcodigo)) neq 0>#rsPadre.SMcodigo#</cfif>">	
		<input type="hidden" name="SMNcodigoPadre" id="SMNcodigoPadre" value="<cfif isdefined("rsPadre") and len(trim(rsPadre.SMNcodigoPadre)) neq 0>#rsPadre.SMNcodigoPadre#</cfif>">	
		<input type="hidden" name="SMNtipo" id="SMNtipo" value="<cfif isdefined("rsPadre") and len(trim(rsPadre.SMNtipo)) neq 0>#rsPadre.SMNtipo#</cfif>">		
	<cfelse>
		<input type="hidden" name="SScodigo" id="SScodigo" value="<cfif isdefined("form.SScodigo") and len(trim(form.SScodigo)) neq 0>#Form.SScodigo#</cfif>">	
		<input type="hidden" name="SMcodigo" id="SMcodigo" value="<cfif isdefined("form.SMcodigo") and len(trim(form.SMcodigo)) neq 0>#Form.SMcodigo#</cfif>">	
		<input type="hidden" name="SMNcodigoPadre" id="SMNcodigoPadre" value="<cfif isdefined("form.SMNcodigoPadre") and len(trim(form.SMNcodigoPadre)) neq 0>#Form.SMNcodigoPadre#</cfif>">	
		<input type="hidden" name="SMNtipo" id="SMNtipo" value="<cfif isdefined("form.SMNtipo") and len(trim(form.SMNtipo)) neq 0>#Form.SMNtipo#</cfif>">		
	</cfif>
	
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
		<tr>
			<td class="tituloMantenimiento" colspan="3" align="center">
			<strong><font size="3">
				<cfif modo eq "ALTA">
					Nueva
					  <cfelse>
					Modificar 
				</cfif>
				Opcion de Menu</font></strong>
				<cf_sifayuda width="650" height="450" name="imgAyuda" tip="false">
				</font>
			</td>
		</tr>
		<tr> 
        	<td width="26%" align="right" nowrap class="fileLabel"><strong>Sistema</strong>:</td>
			<td nowrap>#rsPadre.SSdescripcion#</td>
		</tr>
		<tr> 
        	<td width="26%" align="right" nowrap class="fileLabel"><strong>Módulo</strong>:</td>
			<td>#rsPadre.SMdescripcion#</td>
		</tr>
		<cfif isdefined('form.SMNcodigoPadre') and form.SMNcodigoPadre NEQ ''>
			<tr> 
				<td width="26%" align="right" nowrap class="fileLabel"><strong>Menú Anterior:</strong></td>
				<td>#rsPadre.nombrePadre#</td>
			</tr>
		</cfif>
		<tr> 
        	<td width="26%" align="right" nowrap class="fileLabel"><strong>Tipo de Opción:</strong></td>
			<td>#varTipo#</td>
		</tr>			
		<tr> 
        	<td colspan="2" align="right" nowrap class="fileLabel"><hr></td>
		</tr>		
		<cfif isdefined('rsPadre') and CompareNoCase(TRIM(rsPadre.SMNtipo),'M') eq 0>
		  <tr>
			<td align="right" class="fileLabel" nowrap><strong>Tipo de Men&uacute;&nbsp;</strong>:</td>
			<td colspan="2"><select name="SMNtipoMenu" id="SMNtipoMenu">
              <option value="1" <cfif modo NEQ 'ALTA' and #rsPadre.SMNtipoMenu# EQ '1'>selected</cfif>>Mostrar Titulo y Opciones</option>
              <option value="3" <cfif modo NEQ 'ALTA' and #rsPadre.SMNtipoMenu# EQ '3'>selected</cfif>>Mostrar Titulo y Opciones con Explicaci&oacute;n</option>			  
              <option value="2" <cfif modo NEQ 'ALTA' and #rsPadre.SMNtipoMenu# EQ '2'>selected</cfif>>Mostrar Opciones y SubOpciones hacia abajo</option>
              <option value="4" <cfif modo NEQ 'ALTA' and #rsPadre.SMNtipoMenu# EQ '4'>selected</cfif>>Mostrar Opciones y SubOpciones Columnar</option>
            </select></td>
		  </tr>
		  <tr>
			<td align="right" class="fileLabel" nowrap><strong>Titulo</strong>:</td>
			<td colspan="2">
				<input name="SMNtitulo" type="text" id="SMNtitulo" value="<cfif modo NEQ 'ALTA' and rsPadre.SMNtitulo NEQ ''>#rsPadre.SMNtitulo#</cfif>" size="60" maxlength="60">
			</td>
		  </tr>		  
		  <tr>
			<td align="right" class="fileLabel" nowrap valign="top"><strong>Explicaci&oacute;n</strong>:</td>
			<td colspan="2">
				<textarea name="SMNexplicativo" cols="30" rows="4" id="SMNexplicativo"><cfif modo NEQ 'ALTA' and rsPadre.SMNexplicativo NEQ ''>#rsPadre.SMNexplicativo#</cfif></textarea>			
			</td>
		  </tr>
		  <cfif modo neq "ALTA">
			  <tr>
				<td align="right" class="fileLabel" nowrap><strong>Orden</strong>:</td> 
				<td colspan="2">
					<input name="SMNorden" type="text" id="SMNorden" tabindex="3" size="10" maxlength="6"  value="<cfif rsPadre.SMNorden NEQ ''>#rsPadre.SMNorden#</cfif>" style="text-align: right;" onblur="javascript:fm(this,-1); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}">			
				</td>
			  </tr>
		  </cfif>
			  <tr>
				<td align="right" class="fileLabel" nowrap><strong>Columna</strong>:</td> 
				<td colspan="2">
					<input name="SMNcolumna" type="text" id="SMNcolumna" tabindex="3" size="10" maxlength="6"  value="<cfif modo neq "ALTA">#rsPadre.SMNcolumna#<cfelse>1</cfif>" style="text-align: right;" onblur="javascript:fm(this,-1); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}">			
					Si menú padre es tipo "Opciones/SubOpciones Columnar"
				</td>
			  </tr>
		  <tr>
			<td align="right" class="fileLabel" nowrap><strong>Men&uacute; en Construcci&oacute;n</strong>:</td>
			<td colspan="2"><input name="SMNenConstruccion" type="checkbox" id="SMNenConstruccion" <cfif modo neq "ALTA" and rsPadre.SMNenConstruccion NEQ 0> checked</cfif> value="1"></td>
		  </tr>
		  <tr>
			<td align="right" class="fileLabel" nowrap><strong>Mostrar Procesos Como Opciones Principales</strong>:</td>
			<td colspan="2"><input name="opcionprin" type="checkbox" id="opcionprin" <cfif modo neq "ALTA" and rsPadre.opcionprin NEQ 0>checked</cfif> value="1"></td>
		  </tr>
		  <tr>
			<td align="right" class="fileLabel" nowrap><strong>Mostrar Men&uacute; Siempre Abierto</strong>:</td>
			<td colspan="2"><input name="siempreabierto" type="checkbox" id="siempreabierto" <cfif modo neq "ALTA" and rsPadre.siempreabierto NEQ 0>checked</cfif> value="1"></td>
		  </tr>
		  <tr>
			<td align="right" class="fileLabel" nowrap><strong>Imagen Grande</strong>:</td>
			<td colspan="2"><input type="file" name="PfotoG"></td>
		  </tr>
		  <tr>
			<td align="right" class="fileLabel" nowrap><strong>Imagen Peque&ntilde;a</strong>:</td>     
			<td colspan="2"><input type="file" name="PfotoP"></td>
		  </tr>
		<cfelse>
			<tr>
			<td align="right" class="fileLabel" nowrap><strong>Proceso: </strong></td>     
			<td colspan="2">
			<cfif modo EQ 'ALTA'>
				<select name="SPcodigo" id="SPcodigo">
					<cfloop query="rsProcSinMenu">
						<option value="#rsProcSinMenu.SPcodigo#">#rsProcSinMenu.Spdescripcion#</option>
					</cfloop>
            	</select>
			<cfelse>
				<cfif isdefined('rsProceso') and rsProceso.recordCount GT 0>
					<select name="SPcodigo" id="SPcodigo">
						<option value="#rsProceso.SPcodigo#" selected>#rsProceso.SPdescripcion#</option>					
						<cfif isdefined('rsProcSinMenu') and rsProcSinMenu.recordCount GT 0>
							<cfloop query="rsProcSinMenu">
								<option value="#rsProcSinMenu.SPcodigo#">#rsProcSinMenu.Spdescripcion#</option>
							</cfloop>
						</cfif>
					</select>					
				</cfif>
			</cfif>
			</td>
		  </tr>	
		  <cfif modo neq "ALTA">
			  <tr>
				<td align="right" class="fileLabel" nowrap><strong>Orden</strong>:</td>     
				<td colspan="2">
					<input name="SMNorden" type="text" id="SMNorden" tabindex="3" size="10" maxlength="6"  value="<cfif rsPadre.SMNorden NEQ ''>#rsPadre.SMNorden#</cfif>" style="text-align: right;" onblur="javascript:fm(this,-1); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}">			
				</td>
			  </tr>
		  </cfif>
			  <tr>
				<td align="right" class="fileLabel" nowrap><strong>Columna</strong>:</td> 
				<td colspan="2">
					<input name="SMNcolumna" type="text" id="SMNcolumna" tabindex="3" size="10" maxlength="6"  value="<cfif modo neq "ALTA">#rsPadre.SMNcolumna#<cfelse>1</cfif>" style="text-align: right;" onblur="javascript:fm(this,-1); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}">			
				</td>
			  </tr>
		  <tr>
			<td align="right" class="fileLabel" nowrap><strong>Men&uacute; en Construcci&oacute;n</strong>:</td>
			<td colspan="2"><input type="checkbox" name="SMNenConstruccion" value="1" <cfif modo neq "ALTA" and rsPadre.SMNenConstruccion NEQ 0> checked</cfif>></td>
		  </tr> 		  		  		  		  
		</cfif>
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>			
	  </tr>		
      <tr>
        <td align="center" colspan="2">
          <cfset mensajeDelete = "¿Desea Eliminar este Men&uacute;?">
         <cfinclude template="../../../sif/portlets/pBotones.cfm"> 
		</td> 
      </tr>

		<cfif modo neq "ALTA" and isdefined('rsPadre') and rsPadre.SMNtipo EQ 'M'>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>			
		  </tr>
		  <tr>
			<td><strong>Imagen Grande</strong></td>
			<td><input name="ckBorrarImgG" type="checkbox" id="ckBorrarImgG" value="1">
		  Eliminar                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       </td>
			<td>&nbsp;</td>			
		  </tr>			  
		  <tr>
			<td colspan="3" align="center">
				<!--- <cf_leerimagen imgname="imgGde" autosize="true" border="false" tabla="SMenues" campo="SMNimagenGrande" condicion="SMNcodigo=#form.SMNcodigo# and datalength(SMNimagenGrande) > 1" conexion="asp">  --->
				<cfif Len(rsPadre.SMNimagenGrande) GT 1>
				<cfinvoke 
					component="sif.Componentes.DButils"
					method="toTimeStamp"
					returnvariable="tsurl">
					<cfinvokeargument name="arTimeStamp" value="#rsPadre.MNtimestamp#"/>
				</cfinvoke>
				<img src="/cfmx/home/public/logo_menu.cfm?g=1&n=#URLEncodedFormat(Form.SMNcodigo)#&ts=#tsurl#" border="0" width="245" height="155">
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td><strong>Imagen Peque&ntilde;a</strong></td>
			<td><input name="ckBorrarImgP" type="checkbox" id="ckBorrarImgP" value="1">
		  Eliminar                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       </td>
			<td>&nbsp;</td>			
		  </tr>
		  <tr>
			<td colspan="3" align="center">
				<!--- <cf_leerimagen imgname="imgPeq" autosize="true" border="false" tabla="SMenues" campo="SMNimagenPequena" condicion="SMNcodigo=#form.SMNcodigo# and datalength(SMNimagenPequena) > 1" conexion="asp">   --->
				<cfif Len(rsPadre.SMNimagenPequena) GT 1>
				<cfinvoke 
					component="sif.Componentes.DButils"
					method="toTimeStamp"
					returnvariable="tsurl">
					<cfinvokeargument name="arTimeStamp" value="#rsPadre.MNtimestamp#"/>
				</cfinvoke>
				<img src="/cfmx/home/public/logo_menu.cfm?n=#URLEncodedFormat(Form.SMNcodigo)#&ts=#tsurl#" border="0" width="245" height="155">
				</cfif>
			</td>
		  </tr>		  			  		  
		</cfif>	  
	 </table>
</cfoutput>
</form>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<script language="JavaScript">
	function deshabilitarValidacion() {
		objForm.SScodigo.required = false;
		objForm.SMcodigo.required = false;
		objForm.SMNtipo.required = false;	
		<cfif modo NEQ "ALTA">
			objForm.SMNcodigo.required = false;	
		</cfif>
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.SScodigo.required = true;
		objForm.SMcodigo.required = true;
		objForm.SMNtipo.required = true;	
		<cfif modo NEQ "ALTA">
			objForm.SMNcodigo.required = true;	
		</cfif>
	}
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formMenues");
//---------------------------------------------------------------------------------------
	objForm.SScodigo.required = true;
	objForm.SMcodigo.required = true;
	objForm.SMNtipo.required = true;	
	<cfif modo NEQ "ALTA">
		objForm.SMNcodigo.required = true;	
	</cfif>	
</script>