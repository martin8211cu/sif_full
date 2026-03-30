<cfparam name="url.id_item" default="">
<cfparam name="url.root">
<cfparam name="url.padre" default="">
<cfparam name="url.estereotipo" default="">

<cfif Len(url.padre) is 0>
	<cfset url.padre = url.root>
</cfif>

<cfquery datasource="asp" name="data">
	select   *
	from  SMenuItem
	where id_item = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_item#" null="#Len(url.id_item) Is 0#">	
</cfquery>
<cfquery datasource="asp" name="dataPos">
	select id_padre, posicion
	from  SRelacionado
	where id_hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_item#" null="#Len(url.id_item) Is 0#">	
</cfquery>
<cfquery datasource="asp" name="dataPadre">
	select id_padre
	from  SRelacionado
	where id_hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_item#" null="#Len(url.id_item) Is 0#">	
	  and profundidad = 1
</cfquery>

<cfquery datasource="asp" name="padres">
	select a.id_item, a.etiqueta_item, b.profundidad,
		<cfif Len(url.id_item)>
		( select count(1) from SRelacionado c
			where c.id_padre = a.id_item 
			  and c.id_hijo = 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_item#" null="#Len(url.id_item) Is 0#"> 
			  and c.profundidad = 1
		) <cfelse>0</cfif> as es_padre
	from SMenuItem a
		join SRelacionado b
		  on b.id_hijo = a.id_item
	where b.id_padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.root#">
	<cfif Len(url.id_item)>
	  and not exists (
	  	select *
		from SRelacionado e
		where a.id_item = e.id_hijo
		  and e.id_padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_item#">
	  )
	  and a.id_item != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_item#">
	</cfif>
	order by b.ruta, a.etiqueta_item
</cfquery>

<cfquery name="rsSistemas" datasource="asp">
	select SScodigo, SSdescripcion
	from SSistemas
	order by SScodigo
</cfquery>

<cfquery name="rsModulos" datasource="asp">
	select SScodigo, SMcodigo, SMdescripcion
	from SModulos
	order by SMdescripcion
</cfquery>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: SMenuItem - Submenú del portal
		
			
		
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
//-->

	// ===========================================================================================
	//								Conlis de Procesos
	// ===========================================================================================
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	/*	
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  */
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis() {
		
		if ( document.form1.SScodigo.value != '' && document.form1.SMcodigo.value != '' ){
			popUpWindow("conlisProcesos.cfm?SScodigo="+document.form1.SScodigo.value+"&SMcodigo="+document.form1.SMcodigo.value,250,200,650,400);
		}
		else{
			alert(' - Debe seleccionar el sistema y módulo antes de seleccionar el proceso.')
		}
	}
	// ===========================================================================================

</script>

<script language="javascript1.2" type="text/javascript" src="utilesMonto.js"></script>
<form action="SMenuItem-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
<input type="hidden" name="root" value="#HTMLEditFormat(url.root)#">
	<table summary="Tabla de entrada">
	<tr><td colspan="2" class="subTitulo">
	Submenú del portal
	</td></tr>
	
	
		
		
			
		
	
		
		
		<tr><td valign="top">Etiqueta
		</td><td valign="top">
		
			<input name="etiqueta_item" id="etiqueta_item" type="text" value="#HTMLEditFormat(data.etiqueta_item)#" 
				maxlength="60"
				size="55"
				onfocus="this.select()"  >
		
		</td></tr>
		
	
		
<!---		
		<tr><td valign="top">Estereotipo
		</td><td valign="top">
		
			
			<cfif Len(data.id_item)>
				<cfset el_estereotipo = data.estereotipo>
			  <cfelse>
				<cfset el_estereotipo = url.estereotipo>
			  </cfif>

			<select name="estereotipo" id="estereotipo">
			<cfif Len(el_estereotipo) And Not ListFind('root,menu,item,link', el_estereotipo)>
			<option value="#HTMLEditFormat(el_estereotipo)#" selected>#HTMLEditFormat(el_estereotipo)#</option>
			</cfif>
			<option value="" <cfif el_estereotipo is ''>selected</cfif>>-ninguno-</option>
			<option value="root" <cfif el_estereotipo is 'root'>selected</cfif>>root</option>
			<option value="menu" <cfif el_estereotipo is 'menu'>selected</cfif>>menu</option>
			<option value="item" <cfif el_estereotipo is 'item'>selected</cfif>>item</option>
			<option value="link" <cfif el_estereotipo is 'link'>selected</cfif>>link</option>
			</select>
		
		</td></tr>
--->		
		
		<tr>
		  <td valign="top">Colocar bajo </td>
		  <td valign="top">
		  	<select name="padre">
				<cfloop query="padres">
					<cfif Len(data.id_item)>
						<cfset is_selected = padres.es_padre>
					<cfelse>
						<cfset is_selected = padres.id_item is url.padre>
					</cfif>
					<option value="#HTMLEditFormat(padres.id_item)#" <cfif is_selected>selected</cfif>>
					#RepeatString('&nbsp;', padres.profundidad*2)#
					#HTMLEditFormat(padres.etiqueta_item)#</option>
				</cfloop>
		  	</select>
			<cfif isdefined("dataPadre") and dataPadre.recordCount gt 0 >
				<input type="hidden" name="_padre" value="#dataPadre.id_padre#">
			</cfif>
		</td>
	  </tr>

		<tr>
			<td valign="top">Posici&oacute;n</td>
			<td valign="top">
				<input type="text" name="posicion" value="<cfif len(trim(dataPos.posicion))>#dataPos.posicion#</cfif>" tabindex="1" size="7" maxlength="7" style="text-align: right;" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
			</td>
		</tr>

		<tr><td valign="top">Sistema
		</td><td valign="top">
		
			<!---<input name="SScodigo" id="SScodigo" type="text" value="#HTMLEditFormat(data.SScodigo)#" 
				maxlength="10"
				onfocus="this.select()"  >--->
				
			<select name="SScodigo" onChange="javascript:change_sistema(this, document.form1, 0);">
				<option value="" >-ninguno-</option>
				<cfloop query="rsSistemas">
					<option value="#Trim(rsSistemas.SScodigo)#" <cfif data.recordCount gt 0 and trim(data.SScodigo) eq trim(rsSistemas.SScodigo)>selected<cfelseif isdefined("url.SScodigo") and trim(rsSistemas.SScodigo) eq trim(url.SScodigo) >selected</cfif> >#rsSistemas.SScodigo# - #rsSistemas.SSdescripcion#</option>
				</cfloop>
			</select>
		</td></tr>
		
		<tr><td valign="top">Módulo
		</td><td valign="top">
				<select name="SMcodigo" onChange="javascript:limpiarProceso(this.form);"  ></select>

			<!---<input name="SMcodigo" id="SMcodigo" type="text" value="#HTMLEditFormat(data.SMcodigo)#" 
				maxlength="10"
				onfocus="this.select()"  >--->
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">Proceso
		</td><td valign="top">
				<cfif data.recordcount gt 0 and len(trim(data.SPcodigo))>
					<cfquery name="dataProceso" datasource="asp">
						select SPcodigo,SPdescripcion
						from SProcesos
						where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(data.SScodigo)#">
						  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(data.SMcodigo)#">
						  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(data.SPcodigo)#">
					</cfquery>
				</cfif>
				
				<input type="hidden" name="SPcodigo" value="<cfif data.recordcount gt 0 and len(trim(data.SPcodigo))>#trim(dataProceso.SPcodigo)#</cfif>">
				<input type="text" name="SPproceso" readonly size="55" maxlength="255" onFocus="this.select();" value="<cfif data.recordcount gt 0  and len(trim(data.SPcodigo))>#trim(dataProceso.SPdescripcion)#</cfif>" >
				<a href="##">
					<img src="../../imagenes/Description.gif" alt="Lista de Procesos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis();">
				</a> 


			<!---
			<input name="SPcodigo" id="SPcodigo" type="text" value="#HTMLEditFormat(data.SPcodigo)#" 
				maxlength="10"
				onfocus="this.select()"  >
				--->
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">P&aacute;gina
		</td><td valign="top">
			<cfquery name="dataPagina" datasource="asp">
				select id_pagina, nombre_pagina 
				from SPagina
			</cfquery>
			
			<select name="id_pagina">
				<option value="" >-ninguno-</option>
				<cfloop query="dataPagina">
					<option value="#dataPagina.id_pagina#" <cfif data.recordCount gt 0 and data.id_pagina eq datapagina.id_pagina>selected</cfif> >#dataPagina.nombre_pagina#</option>
				</cfloop>
			</select>
			
			<!---
			<input name="id_pagina" id="id_pagina" type="text" value="#HTMLEditFormat(data.id_pagina)#" 
				maxlength=""
				onfocus="this.select()"  >
			--->	
		
		</td></tr>
		
	
	<tr><td colspan="2" class="formButtons">
		<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1">
		<cfif data.RecordCount>
			<!---<cf_botones modo='CAMBIO'>--->
			<input type="submit" name="Cambio" value="Modificar" onClick="javascript: if (window.funcCambio) return funcCambio();if (window.habilitarValidacion) habilitarValidacion();" tabindex="0">
			<input type="submit" name="Baja" value="Eliminar" onClick="javascript: if (window.funcBaja) return funcBaja();if ( confirm('¿Desea Eliminar el Registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}" tabindex="0">
			<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: if (window.funcNuevo) return funcNuevo();if (window.deshabilitarValidacion) deshabilitarValidacion();" tabindex="0">
		<cfelse>
			<!---<cf_botones modo='ALTA'>--->
			<input type="submit" name="Alta" value="Agregar" onClick="javascript: if (window.funcAlta) return funcAlta();if (window.habilitarValidacion) habilitarValidacion();if (1==2)alert('No haga nada');" tabindex="0">
			<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: if (window.funcLimpiar) return funcLimpiar();" tabindex="0">
		</cfif>
		<input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='SMenu.cfm'" tabindex="0">
	</td></tr>
	</table>
	
			<input type="hidden" name="id_menu" value="#form.id_menu#">
			<input type="hidden" name="id_item" value="#HTMLEditFormat(data.id_item)#">
		
	
		
			<input type="hidden" name="BMfecha" value="#HTMLEditFormat(data.BMfecha)#">
		
	
		
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
		
	
		
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		
	
</form>

</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function limpiarProceso(form){
		form.SPcodigo.value = ''; 
		form.SPproceso.value = ''; 
	}
	
	function change_sistema(obj, form, origen){
		if (origen == 0 ){
			limpiarProceso(form);
		}
		
		combo = form.SMcodigo;
		combo.length = 0;

		var cont = 0;

		//if ( obj.value == '' ){
			combo.length = cont+1;
			combo.options[cont].value = '';
			combo.options[cont].text = '-ninguno-';	
			cont = 1;
		//}
		
		<cfloop query="rsModulos">
		if ( obj.value == '<cfoutput>#Trim(rsModulos.SScodigo)#</cfoutput>' ) {
			combo.length = cont+1;
			combo.options[cont].value = '<cfoutput>#Trim(rsModulos.SMcodigo)#</cfoutput>';
			combo.options[cont].text = '<cfoutput>#rsModulos.SMdescripcion#</cfoutput>';	
			
			<cfif data.recordCount gt 0 and rsModulos.SMcodigo eq data.SMcodigo >
				combo.options[cont].selected = true;
			<cfelseif isdefined("url.SMcodigo") and trim(rsModulos.SMcodigo) eq trim(url.SMcodigo) >
				combo.options[cont].selected = true;
			</cfif>

			cont = cont + 1;
		}
		</cfloop>
	}

	// sistemas/modulos del mantenimiento
	change_sistema(document.form1.SScodigo, document.form1, 1);


</script>

