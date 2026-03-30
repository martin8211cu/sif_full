<cf_templateheader title="Habilitar empresas">

<cfparam name="url.ctae" default="">
<cfparam name="url.emp" default="">
<cfparam name="url.accion" default="">
<cfset _Enombre = url.emp>

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
	select e.Ecodigo, e.Enombre, c.Ccache, e.Ereferencia, Eactiva, EactivaMotivo
	from Empresa e
			join Caches c
				on e.Cid = c.Cid
			join CuentaEmpresarial ce
				on ce.CEcodigo = e.CEcodigo
		where e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ctae#">
		  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.emp#">
</cfquery>

<cfoutput>
<cf_web_portlet_start titulo="Habilitar empresas">
<form name="form1" method="post" action="habilitar-sql.cfm" onsubmit="return validar(this);">
  <table border="0" cellspacing="0" cellpadding="2" width="700">
  <tr>
    <td colspan="3" class="subTitulo">Empresa por respaldar </td>
    </tr>
  <tr>
    <td width="20">&nbsp;</td>
    <td width="172">Cuenta empresarial</td>
    <td width="488">#HTMLEditFormat(ctae_q.CEnombre)#
		<input type="hidden" name="ctae" value="# HTMLEditFormat( ctae_q.CEcodigo ) #">	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Empresa</td>
    <td>#HTMLEditFormat(emp_q.Enombre)#
		<input type="hidden" name="emp" value="# HTMLEditFormat( emp_q.Ecodigo ) #">	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Estado</td>
    <td><cfif emp_q.Eactiva is 1>Activa<cfelse>Inactiva</cfif>
	<cfif Len(Trim(emp_q.EactivaMotivo))>
	 (#HTMLEditFormat(emp_q.EactivaMotivo)#)
	</cfif>	</td>
  </tr>
  <tr>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3" class="subTitulo">
	<cfif emp_q.Eactiva is 1>Motivo por el cual quiere inhabilitar <cfelse>Motivo por el cual quiere habilitar </cfif></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td><table border="0" cellspacing="0" cellpadding="2">
	<cfif emp_q.Eactiva is 1>
		<cfset motivo = ListToArray('Falta de pago,Respaldo de información,Carga de respaldo')>
	<cfelse>
		<cfset motivo = ListToArray('Pago recibido,Respaldo terminado,Carga terminada')>
	</cfif>
	<cfloop from="1" to="#ArrayLen(motivo)#" index="i">
      <tr>
        <td width="24">
            <input type="radio" id="motivo#i#" name="motivo" value="#HTMLEditFormat(motivo[i])#" />        </td>
        <td width="390"><label for="motivo#i#">#HTMLEditFormat(motivo[i])#</label></td>
      </tr></cfloop>
      <tr>
        <td><input type="radio" id="motivo_otro" name="motivo" value="otro" checked="checked" /></td>
        <td><label for="motivo_otro">Otro, especifique:</label> </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td><textarea name="otromotivo" cols="60" rows="3"></textarea></td>
      </tr>
    </table>      </td>
  </tr>
  <tr>
    <td colspan="3">&nbsp;</td>
    </tr>
  <cfif Len(url.emp)>
  <tr>
    <td colspan="3" class="subTitulo">Datos de la empresa </td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>DBMS </td>
    <td>
	<cfif StructKeyExists(Application.dsinfo, emp_q.Ccache) And
		StructKeyExists(Application.dsinfo[emp_q.Ccache], 'type')>
	#Application.dsinfo[emp_q.Ccache].type#
	<cfelse>N.D.
	</cfif></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Datasource</td>
    <td># HTMLEditFormat( emp_q.Ccache ) #
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
    <td># HTMLEditFormat( emp_q.Ereferencia) #</td>
  </tr>
  
  <cfif StructKeyExists(Application.dsinfo, emp_q.Ccache)>
  <tr>
    <td>&nbsp;</td>
    <td>Estadísticas</td>
    <td>
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
  </cfif>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>
        <cfif emp_q.Eactiva is 1>
          <input name="inhabilitar" type="submit" id="inhabilitar" value="Inhabilitar" class="btnGuardar" />
          <cfelse>
          <input name="habilitar" type="submit" id="habilitar" value="Habilitar" class="btnGuardar" />
          </cfif>
		  <input name="regresar" type="button" id="regresar" value="Cancelar" class="btnLimpiar" onclick="this.disabled=true;window.open('../empresas.cfm','_self')"/>
          </td>
  </tr>
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
function validar(f){
	if (f.motivo_otro.checked && f.otromotivo.value.match(/^\s*$/)){
		alert('Especifique el motivo');
		f.otromotivo.focus();
		return false;
	};
	return true;
}
//-->
</script>
</cfoutput>

<cf_templatefooter>