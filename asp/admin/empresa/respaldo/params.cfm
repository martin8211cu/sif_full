<cfif url.accion is 'respaldar'>
<cfset title="Respaldo de empresas">
<cfelseif url.accion is 'cargar'>
<cfset title="Carga de datos">
<cfelse> action inválido: #  HTMLEditFormat(url.action)#
</cfif>
<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>

<cf_templateheader title="#title#">

<cfparam name="url.ctae" default="">
<cfparam name="url.emp" default="">
<cfparam name="url.accion" default="">
<cfset _Enombre = url.emp>
<cfset activar_submit = false>
<cfif session.CEcodigo NEQ 1>
	<cfset url.ctae = session.CEcodigo>
<cfelseif Len(url.ctae) is 0>
	<cfset url.ctae = session.CEcodigo>
</cfif>

<cfquery datasource="asp" name="ctae_q">
	select CEcodigo, CEnombre
	from CuentaEmpresarial
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ctae#">
</cfquery>

<cfquery datasource="asp" name="emp_q">
	select e.Ecodigo, e.Enombre, c.Ccache, e.Ereferencia,
			coalesce (nullif(ce.CEaliaslogin, ''), convert(varchar, ce.CEcodigo)) as CEaliaslogin
	from Empresa e
			join Caches c
				on e.Cid = c.Cid
			join CuentaEmpresarial ce
				on ce.CEcodigo = e.CEcodigo
		where e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ctae#">
		  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.emp#">
</cfquery>

<cfset Respaldo_Path = Politicas.trae_parametro_global('respaldo.path', '/tmp/')>
<cfset DirCuenta = LCase(emp_q.CEaliaslogin)& '-' & LCase(REReplace( _Enombre, '[^A-Za-z0-9]', '', 'all'))>
<cfset ArchivoZIP = DateFormat(Now(),'YYYY-MM-DD') & '-' & TimeFormat(Now(), 'HH-MM')>


<cfoutput>
<cf_web_portlet_start titulo="#title#">
<form name="form1" method="post" action="respaldo.cfm" onsubmit="return verificar_si_acepto(this);">
  <table border="0" cellspacing="0" cellpadding="2" width="807">
  <tr>
    <td colspan="4" class="subTitulo">Empresa por respaldar </td>
    </tr>
  <tr>
    <td width="3">&nbsp;</td>
    <td width="228">Cuenta empresarial</td>
    <td colspan="2">#HTMLEditFormat(ctae_q.CEnombre)#
		<input type="hidden" name="ctae" value="# HTMLEditFormat( ctae_q.CEcodigo ) #">	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Empresa</td>
    <td colspan="2">#HTMLEditFormat(emp_q.Enombre)#
		<input type="hidden" name="emp" value="# HTMLEditFormat( emp_q.Ecodigo ) #">	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="4" class="subTitulo">Datos de origen </td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>DBMS </td>
    <td colspan="2">
	<cfif StructKeyExists(Application.dsinfo, emp_q.Ccache) And
		StructKeyExists(Application.dsinfo[emp_q.Ccache], 'type')>
		<cfset activar_submit = true>
	#Application.dsinfo[emp_q.Ccache].type#
	<cfelse>N.D.
	</cfif></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Datasource</td>
    <td colspan="2"><input type="text" value="# HTMLEditFormat( emp_q.Ccache ) #" name="Ccache" size="20" readonly="readonly" />
	<cfif Not StructKeyExists(Application.dsinfo, emp_q.Ccache)>
	<span class="errormsg">* datasource no está definido</span>
	<cfelse>
		<cfset DSURL = ListFirst(Application.dsinfo[emp_q.Ccache].url,';')>
		<cfif ListLen(DSURL,':') GE 5>
			<cfoutput> (#REReplace( ListGetAt(DSURL,4,':'), '//', '')#:#ListGetAt(DSURL,5,':')#) </cfoutput>
		</cfif>
	</cfif>	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Código de empresa </td>
    <td colspan="2"><input type="text" value="# HTMLEditFormat( emp_q.Ereferencia) #" name="Ereferencia" size="20" readonly="readonly" /></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Servidor según SQL.INI </td>
    <td colspan="2"><input type="text" value="#Politicas.trae_parametro_global('respaldo.bcp.server', 'MINISIF')#" name="dbserver" size="20" onfocus="this.select()" /></td>
  </tr>
  <cfif StructKeyExists(Application.dsinfo, emp_q.Ccache)>
  <tr>
    <td>&nbsp;</td>
    <td>Estadísticas</td>
    <td colspan="2">
	<cftry>
  <cfquery datasource="#emp_q.Ccache#" name="emp">
  	select count(1) as cnt from DatosEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#emp_q.Ereferencia#">
  </cfquery>
  <cfquery datasource="#emp_q.Ccache#" name="cta">
  	select count(1) as cnt from CContables where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#emp_q.Ereferencia#">
  </cfquery>
  <cfquery datasource="#emp_q.Ccache#" name="cfn">
  	select count(1) as cnt from CFuncional where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#emp_q.Ereferencia#">
  </cfquery>
  #emp.cnt# Empleados,
  #cta.cnt# Cuentas,
  #cfn.cnt# Centros Funcionales
  <cfcatch type="any">Error consultando estadísticas: #cfcatch.Message# #cfcatch.Detail#</cfcatch>
  </cftry></td>
  </tr></cfif>
  <tr>
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="4" class="subTitulo">Directorio de respaldos </td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Directorio (servidor)</td>
    <td colspan="2"><input type="text" value="#HTMLEditFormat(Respaldo_Path)#" name="destdir" size="60" readonly="readonly" /></td>
  </tr>
  <cfif url.accion is 'respaldar'>
  <tr>
    <td>&nbsp;</td>
    <td>Subdirectorio</td>
    <td colspan="2"><input type="text" value="#DirCuenta#/#ArchivoZIP#/" name="destsub" size="60" <cfif accion neq 'cargar'>readonly="readonly" </cfif> />	</td>
  </tr>
<cfelseif url.accion is 'cargar'>
  	<cfif Not DirectoryExists(Respaldo_Path & DirCuenta)>
	<tr><td>&nbsp;</td><td colspan="3">El directorio <strong>#HTMLEditFormat(Respaldo_Path & DirCuenta)#</strong>
	no existe ! Seguramente no hay respaldos disponibles</td></tr>
	<cfelse>
  <cfdirectory action="list" directory="#Respaldo_Path##DirCuenta#" name="archivos" filter="*.zip">
  <tr>
    <td>&nbsp;</td>
    <td>Archivo</td>
    <td colspan="2"><select name="destsub"><cfloop query="archivos"><option value="#DirCuenta#/#HTMLEditFormat( REReplace(name, '\.[^\\/]+$', ''))#/">#HTMLEditFormat(name)#</option></cfloop></select></td>
  </tr></cfif>
<cfelse> action inválido: #  HTMLEditFormat(url.action)#
</cfif>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td width="20">
	<input type="checkbox" name="acepto" value="1" id="acepto" /></td>
    <td width="540"><label for="acepto"> Acepto desconectar los usuarios mientras se ejecute este proceso</label></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2">&nbsp;</td>
  </tr>
  <cfif activar_submit>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2">
	<cfif url.accion is 'respaldar'>
	<input name="respaldar" type="submit" id="respaldar" value="Crear respaldo"  class="btnGuardar" />
	<cfelseif url.accion is 'cargar'>
      <input name="borrar" type="submit" id="borrar" value="Borrar datos"  class="btnEliminar" />
      <input name="cargar" type="submit" id="cargar" value="Cargar datos respaldados"  class="btnRefresh" />
	<cfelse> action inválido: #  HTMLEditFormat(url.action)#
	</cfif>
	<input name="regresar" type="button" id="regresar" value="Cancelar" class="btnLimpiar" onclick="this.disabled=true;window.open('../empresas.cfm','_self')"/>	</td>
  </tr></cfif>
</table>
</form>
<cf_web_portlet_end>
<script type="text/javascript">
<!--
function change_ctae(ctae){
	location.href = 'params.cfm?ctae=' + escape(ctae);
}
function change_emp(ctae,emp){
	location.href = 'params.cfm?ctae=#JSStringFormat(url.ctae)#&emp=' + escape(emp);
}
function verificar_si_acepto(f){
	if (!f.acepto.checked) {
		alert('Debe aceptar la desconexión de los usuarios mientras se ejecute el proceso solicitado');
		return false;
	}
	return true;
}
//-->
</script>
</cfoutput>

<cf_templatefooter>