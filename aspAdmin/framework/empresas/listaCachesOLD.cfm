<!--- Pantalla de Filtro y Modificación de un campo en la misma pantalla. --->
<!--- Secciones: 1. Definición de Variables, 2. Consultas 3. JavaScripts--->
<!---	Si vienen definidos sistema y Ecodigo se asume que viene de una selección en la lista 
		y que quiere modificar el nombre_cache correspondiente.
		Si además viene definido el nombre_cache se asume que acaba de modificar un cache, 
		y se verifica con btnModificar.
		Si viene btnCancelar o no viene nada de lo anterior se muestra simplemente la lista.
--->
<cfset modo = "">
<cfif not isdefined("form.btnCancelar")>
	<cfif (isdefined("form.pk1") and len(trim(form.pk1))) and (isdefined("form.pk2") and len(trim(form.pk2)))>
		<cfif (isdefined("form.mnombre_cache") and len(trim(form.mnombre_cache)) and isdefined("btnModificar"))>
			<cftry>
			<cfquery name="ABC_UpdateCache" datasource="#Session.DSN#">
				update EmpresaID
				set nombre_cache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mnombre_cache#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pk1#">
				and sistema = <cfqueryparam cfsqltype="cf_sql_char" value="#form.pk2#">
			</cfquery>
			<cfcatch type="any">
				<cfinclude template="../../errorPages/BDerror.cfm">
				<cfabort>
			</cfcatch>
			</cftry>
		<cfelse>
			<cfset modo = "cambio">
		</cfif>
	</cfif>
</cfif>

<cfif (isdefined("url.fcliente_empresarial") and not isdefined("form.fcliente_empresarial"))>
	<cfset form.fcliente_empresarial = url.fcliente_empresarial>
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

<!--- <cfdump var="#form#"> --->

<cfset navegacion = "">
<cfset filtro = "">

<cfif (isdefined("form.fcliente_empresarial") and len(trim(form.fcliente_empresarial)))>
	<cfset filtro = filtro & " and cce.cliente_empresarial =" & form.fcliente_empresarial>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fcliente_empresarial=" & form.fcliente_empresarial>
</cfif>
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

<cfquery name="rsCuentas" datasource="sdc">
	select cliente_empresarial, nombre from CuentaClienteEmpresarial
	where (agente = 1
	  and agente_loc = '00')
	  or exists (select id from UsuarioPermiso
	  where rol = 'sys.pso'
	  and Usucodigo = 1
	  and Ulocalizacion = '00')
	  and rtrim(nombre) != ' '
	  and activo = 1
	order by upper(nombre)
</cfquery>

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtro.fcliente_empresarial.value  = "";
		document.filtro.fnombre_comercial.value = "";
		document.filtro.fsistema.value  = "";
		document.filtro.fnombre_cache.value  = "";
	}
	function go(pk1,pk2){
		<cfif modo eq 'cambio'>
			<cfoutput>
				if (pk1==#form.pk1#&&pk2=='#form.pk2#')
					return;
			</cfoutput>
		</cfif>
		document.lista.PK1.value = pk1;
		document.lista.PK2.value = pk2;
		document.lista.submit()
		return true;
	}
	<cfif modo eq 'cambio'>
	function funcModificar(){
		<cfoutput>
			document.lista.PK1.value = #form.pk1#;
			document.lista.PK2.value = '#form.pk2#';
			<!--- alert(document.lista.mnombre_cache.value); --->
		</cfoutput>
		document.lista.submit()
		return true;
	}
	</cfif>
</script>

<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">

<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr class="itemtit"><td colspan="2"><font size="2"><b>Lista de Empresas</b></font></td></tr>
	<tr>				
		<td valign="top">
			<cfoutput>
			<form name="filtro" style="margin:0;" action="Caches.cfm" method="post">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
					<tr>
						<td align="right" nowrap><b>Cuenta Empresarial:&nbsp;</b></td>
						<td>
							<select name="fcliente_empresarial">
								<option value="" selected>--- Todas ---</option>
								<cfloop query="rsCuentas">
									<option value="#rsCuentas.cliente_empresarial#" <cfif isdefined("form.fcliente_empresarial") and form.fcliente_empresarial eq rsCuentas.cliente_empresarial>selected</cfif> >#rsCuentas.nombre#</option>
								</cfloop>
							</select>
						</td>

						<td align="right"><b>Empresa:&nbsp;</b></td>
						<td><input name="fnombre_comercial" type="text" size="40" maxlength="30" value="<cfif isdefined("form.fnombre_comercial") and len(trim(form.fnombre_comercial)) gt 0>#form.fnombre_comercial#</cfif>" ></td>
						<td align="right"><b>Sistema:&nbsp;</b></td>
						<td><input name="fsistema" type="text" size="15" maxlength="15" value="<cfif isdefined("form.fsistema") and len(trim(form.fsistema)) gt 0>#form.fsistema#</cfif>" ></td>
						<td align="right"><b>Cache:&nbsp;</b></td>
						<td><input name="fnombre_cache" type="text" size="15" maxlength="15" value="<cfif isdefined("form.fnombre_cache") and len(trim(form.fnombre_cache)) gt 0>#form.fnombre_cache#</cfif>" ></td>
						<td><input type="submit" name="Filtrar" value="Filtrar"></td>
						<td><input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();"></td>
					</tr>
				</table>
			</form>
			</cfoutput>
			
			<cfif modo eq 'cambio'>
				<cfset botones = "Modificar">
				<cfset precampo = "'</a><input type=''text'' name=''mnombre_cache'' value='''+rtrim(">
				<cfset poscampo = ")+''' maxlength=''30''><a>'">
				<cfset precase = "case when eid.Ecodigo = #pk1# and eid.sistema = '#pk2#' then #precampo#">
				<cfset poscase = "#poscampo# else isnull(eid.nombre_cache,'no definido') end">
			<cfelse>
				<cfset botones = "">
				<cfset precase = "">
				<cfset poscase = "">
			</cfif>
			
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="CuentaClienteEmpresarial cce, 
															Empresa e, 
															Sistema sis,	
															EmpresaID eid"/>
				<cfinvokeargument name="columnas" value="cce.nombre as ccenombre,
															cce.descripcion,
															e.nombre_comercial as enombre,
															e.razon_social,
															sis.sistema,
															sis.nombre,
															convert(varchar,eid.Ecodigo) as pk1,
															eid.sistema as pk2,
															#precase# isnull(eid.nombre_cache,'no definido') #poscase# as nombre_cache"/>
				<cfinvokeargument name="desplegar" value="enombre, sistema, nombre_cache"/>
				<cfinvokeargument name="etiquetas" value="Empresa, Sistema, Cache"/>
				<cfinvokeargument name="formatos" value="S, S, S"/>
				<cfinvokeargument name="filtro" value="cce.activo = 1
															and e.activo = 1
															and sis.activo = 1
															and eid.activo = 1
															#filtro#
															and  cce.cliente_empresarial = e.cliente_empresarial
															and  e.Ecodigo = eid.Ecodigo
															and  sis.sistema = eid.sistema
															order by cce.nombre, enombre, sistema, nombre_cache"/>
				<cfinvokeargument name="align" value="left, left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="Caches.cfm"/>
				<cfinvokeargument name="funcion" value="go"/>
				<cfinvokeargument name="fparams" value="pk1,pk2"/>				
				<cfinvokeargument name="MaxRows" value="15"/>
				<cfinvokeargument name="cortes" value="ccenombre"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="botones" value="#botones#"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
			</cfinvoke>
		</td>
	</tr>
</table>