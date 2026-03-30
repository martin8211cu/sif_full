<cfinclude template="EmpresaCaches_qry.cfm">

<cfif isdefined("url.cliente_empresarial") and not isdefined("form.cliente_empresarial") >
	<cfset form.cliente_empresarial = url.cliente_empresarial >
</cfif>

<cfif (isdefined("url.fnombre_comercial") and not isdefined("form.fnombre_comercial"))>
	<cfset form.fnombre_comercial = url.fnombre_comercial>
</cfif>
<cfif (isdefined("url.fsistema") and not isdefined("form.fsistema"))>
	<cfset form.fsistema = url.fsistema>
</cfif>
<cfif (isdefined("url.fnombre_cache") and not isdefined("form.fnombre_cache"))>
	<cfset form.fnombre_cache = url.fnombre_cache>
</cfif>
<cfif (isdefined("url.fnasignado") and not isdefined("form.fnasignado"))>
	<cfset form.fnasignado = 1 >
</cfif>

<!--- <cfdump var="#form#"> --->

<cfset navegacion = "">
<cfset filtro = "">

<cfif (isdefined("form.fnombre_comercial") and len(trim(form.fnombre_comercial)))>
	<cfset filtro = filtro & " and upper(e.nombre_comercial) like '%" & UCase(form.fnombre_comercial) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fnombre_comercial=" & form.fnombre_comercial>
</cfif>
<cfif (isdefined("form.fsistema") and len(trim(form.fsistema)))>
	<cfset filtro = filtro & " and upper(sis.sistema) like '%" & UCase(form.fsistema) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fsistema=" & form.fsistema>
</cfif>
<cfif (isdefined("form.fnombre_cache") and len(trim(form.fnombre_cache)))>
	<cfset filtro = filtro & " and upper(eid.nombre_cache) like '%" & Ucase(form.fnombre_cache) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fnombre_cache=" & form.fnombre_cache>
</cfif>
<cfif  isdefined("form.fnAsignado") >
	<cfset filtro = filtro & " and eid.nombre_cache is null ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fnasignado=1">
</cfif>
<cfif (isdefined("form.Ecodigo2") and len(trim(form.Ecodigo2)))>
	<cfset filtro = filtro & " and e.Ecodigo = #form.Ecodigo2#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "e.Ecodigo=" & form.Ecodigo2>
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtro.fnombre_comercial.value = "";
		document.filtro.fsistema.value  = "";
		document.filtro.fnombre_cache.value  = "";
		document.filtro.fnAsignado.checked  = false;
	}
</script>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<cfoutput>
			<form name="filtro" style="margin:0;" action="CuentaPrincipal_tabs.cfm" method="post">
				<input type="hidden" name="Ecodigo2" value="#form.Ecodigo2#" >
								
				  <table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
					<tr> 
					  <td align="right" nowrap> <b>Empresa:</b> </td>
					  <td colspan="2"> <input name="fnombre_comercial" type="text" size="40" maxlength="30" value="<cfif isdefined("form.fnombre_comercial") and len(trim(form.fnombre_comercial)) gt 0>#form.fnombre_comercial#</cfif>" onFocus="this.select();" >	
					  </td>
					  <td colspan="3"><b>&nbsp; 
						<input class="areaCheck" type="checkbox" name="fnAsignado" <cfif isdefined("form.fnAsignado")>checked</cfif> >
						solo sin asignar</b><b>&nbsp; </b></td>
					  <td align="right">&nbsp;</td>
					</tr>
					<tr> 
					  <td align="right"><b>Sistema:</b></td>
					  <td valign="middle"><b> 
						<input name="fsistema" type="text" size="15" maxlength="15" value="<cfif isdefined("form.fsistema") and len(trim(form.fsistema)) gt 0>#form.fsistema#</cfif>" onFocus="this.select();" >
						</b> </td>
					  <td><b>Cache:</b></td>
					  <td><b> 
						<select name="fnombre_cache">
						  <option value="">--- Todos ---</option>
						  <cfloop from="1" to="#ArrayLen(datasources)#" index="i">
							<option value="#datasources[i]#" <cfif (isdefined("form.fnombre_cache") and len(trim(form.fnombre_cache)) gt 0 and form.fnombre_cache eq datasources[i] )>selected</cfif> >#datasources[i]#</option>
						  </cfloop>
						</select>
						</b></td>
					  <td align="center" colspan="2" > <input type="submit" name="Filtrar" value="Filtrar"> 
						<input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();"> 
					  </td>
					</tr>
				  </table>
			<input type="hidden" name="cliente_empresarial" value="<cfoutput>#form.cliente_empresarial#</cfoutput>">
			</form>
			</cfoutput>

		</td>
		<td>&nbsp;</td>
		<td width="40%" valign="top" rowspan="2">
		  <cfif isdefined("form.sdcSistema") AND form.sdcSistema NEQ "">
			<cfinclude template="EmpresaCaches_form.cfm">
		  </cfif>
		</td>
	</tr>
	<tr>
		<td>
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="CuentaClienteEmpresarial cce, Empresa e, Sistema sis, EmpresaID eid"/>
				<cfinvokeargument name="columnas" value="cce.cliente_empresarial, cce.nombre as ccenombre, cce.razon_social, e.nombre_comercial as enombre, e.razon_social,
															upper(sis.sistema) as sistema, sis.nombre, convert(varchar,e.Ecodigo) as sdcEcodigo, convert(varchar,e.Ecodigo) as Ecodigo2, eid.sistema as sdcSistema,
															isnull(eid.nombre_cache,'-') as nombre_cache" />
				<cfinvokeargument name="desplegar" value="sistema, nombre_cache"/>
				<cfinvokeargument name="cortes" value="enombre"/>
				<cfinvokeargument name="etiquetas" value="Sistema, Cache"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="filtro" value="cce.cliente_empresarial = #form.cliente_empresarial# and cce.activo = 1 and e.activo = 1 and sis.activo = 1 and eid.activo = 1 #filtro#
															and  cce.cliente_empresarial = e.cliente_empresarial
															and  e.Ecodigo = eid.Ecodigo and  sis.sistema = eid.sistema
															order by cce.nombre, enombre, sistema, nombre_cache"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="CuentaPrincipal_tabs.cfm"/>
				<cfinvokeargument name="MaxRows" value="30"/>
<!--- 										<cfinvokeargument name="cortes" value="ccenombre"/> --->
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
			</cfinvoke>
		</td>
	</tr>						
</table>
