<cfparam name="url.Scodigo" default="">
<cfparam name="form.Scodigo" default="#url.Scodigo#">
<cfparam name="url.srch" default="">
<cfparam name="form.srch" default="#url.srch#">
<cfparam name="url.srty" default="">
<cfparam name="form.srty" default="#url.srty#">
<cfif Not IsNumeric(form.Scodigo)>
	<cfset form.Scodigo = "">
</cfif>

<cfif IsDefined("form.fromform")>
	<cfset data = form>
	<cfparam name="data.Scodigo" default="">
	<cfparam name="data.Snombre" default="">
	<cfparam name="data.CEcodigo" default="">
<cfelse>
	<cfquery datasource="asp" name="data">
		select
			a.Scodigo, a.Snombre, a.CEcodigo
		from Sitio a
		where a.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Scodigo#" null="#Len(form.Scodigo) IS 0#">
	</cfquery>
</cfif>

<cfquery datasource="asp" name="ctaemp">
	select CEcodigo, CEnombre, CEaliaslogin
	from CuentaEmpresarial
	order by CEnombre
</cfquery>
<cfif Len(data.CEcodigo) GT 0>
	<cfquery datasource="asp" name="empresa">
		select Ecodigo, Enombre
		from Empresa
		where CEcodigo = #data.CEcodigo#
		order by Enombre
	</cfquery>
</cfif>
<cfquery datasource="asp" name="procs">
	select rtrim(v.SScodigo) as SScodigo, rtrim(v.SMcodigo) as SMcodigo, rtrim(v.SPcodigo) as SPcodigo, v.SPdescripcion
	from SProcesos v
	order by 1,2,3,4
</cfquery>
<cfquery datasource="asp" name="mods">
	select rtrim(m.SScodigo) as SScodigo, rtrim(m.SMcodigo) as SMcodigo, s.SSdescripcion, m.SMdescripcion
	from SModulos m, SSistemas s
	where s.SScodigo = m.SScodigo
	order by upper(s.SSdescripcion), s.SScodigo, upper(m.SMdescripcion), m.SMcodigo
</cfquery>

<cfquery datasource="asp" name="apariencia">
	select id_apariencia, descripcion, template, home, login
	from MSApariencia a
	order by a.descripcion
</cfquery>
<cfquery datasource="asp" name="doms">
	select id_dominio, dominio, MSDaliases, Scodigo, CEcodigo, Ecodigo,
		rtrim(SScodigo) as SScodigo, rtrim(SMcodigo) as SMcodigo, rtrim(SPcodigo) as SPcodigo,
		id_apariencia,home,login,css,ssl_login,ssl_todo,ssl_home,ssl_dominio
	from MSDominio
	where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Scodigo#" null="#Len(form.Scodigo) IS 0#">
	order by case when dominio = '*' then 0 else 1 end, dominio
</cfquery>
<cfquery datasource="asp" name="domdefault">
	select ssl_login, ssl_todo, ssl_home, ssl_dominio, id_apariencia
	from MSDominio
	where dominio = '*'
</cfquery>

<style type="text/css">
.fullwidth{width:100%;}
.style1 {font-weight: bold}
</style>
<cfoutput>
<form action="dominio-sql.cfm" method="post" id="form1" name="form1" onSubmit="return validate(this);" style="margin:0">

<table width="614" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="4"></td>
        <td width="12"></td>
        <td width="65"></td>
        <td width="70"></td>
        <td width="179"></td>
        <td width="17"></td>
        <td width="53"></td>
        <td colspan="2"></td>
      </tr>
      <tr>
        <td class="subTitulo tituloListas">&nbsp;</td>
        <td colspan="8" class="subTitulo  tituloListas">
          <cfif Len(form.Scodigo) eq 0>
			Nuevo sitio 
			  <cfelse>
			Editar sitio 
          </cfif>        </td>
    </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td colspan="2" nowrap><strong>Nombre </strong></td>
        <td colspan="5"><input name="Snombre" type="text" class="fullwidth" id="Snombre2" tabindex="1" onFocus="select()"
				onKeyUp="" value="#data.Snombre#" maxlength="255"></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td colspan="2" nowrap>
          <input type="hidden" name="Scodigo" value="#data.Scodigo#">
          <input type="hidden" name="fromform" value="1">
          <input type="hidden" name="srty" value="#form.srty#">
        <input type="hidden" name="srch" value="#form.srch#"></td>
        <td colspan="5">Especifique un nombre para identificar este sitio. No es necesariamente el nombre del dominio, sino un recordatorio para que usted lo pueda identificar, especialemente si comprende varios dominios. </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;&nbsp;&nbsp;</td>
        <td colspan="2" nowrap><strong>Cuenta empresarial </strong></td>
        <td colspan="5"><select tabindex="2" name="CEcodigo" class="fullwidth" onChange="setce()">
          <option value="">-ninguna-</option>
          <cfloop query="ctaemp">
            <option value="#ctaemp.CEcodigo#" <cfif 
		ctaemp.CEcodigo IS data.CEcodigo
		>selected</cfif> >#ctaemp.CEnombre#
            <cfif len(Trim(ctaemp.CEaliaslogin))>
      [ #Trim(ctaemp.CEaliaslogin)# ]
            </cfif>
            </option>
          </cfloop>
        </select></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td colspan="2" nowrap>&nbsp;</td>
        <td colspan="5">Solamente se debe especificar cuando el sitio es espec&iacute;fico para una sola cuenta empresarial, es decir, no debe aplicar para el sitio default. </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td colspan="2" nowrap><span class="style1">
          <label for="ssl_dominio">Dominio seguro</label>
        </span></td>
        <td colspan="5"><cfset isDomDefault = doms.dominio neq '*' and ( domdefault.ssl_dominio is doms.ssl_dominio or len(trim(doms.ssl_dominio)) is 0 )>
        <input name="ssl_dominio" id="ssl_dominio2" type="text" class="fullwidth" tabindex="3" onFocus="select()"
				onKeyUp="this.style.color=valid_domain(this.value)?'black':'red';" 
				value="<cfif isDomDefault>#domdefault.ssl_dominio#<cfelse>#doms.ssl_dominio#</cfif>" size="60" <cfif isDomDefault>disabled</cfif>></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td colspan="2" nowrap>&nbsp;
        </td>
        <td colspan="5"><cfif doms.dominio neq '*'>
          <input type="checkbox" name="ssl_domdefault" id="ssl_domdefault2" <cfif isDomDefault>checked</cfif> 
		  	onClick="this.form.ssl_dominio.disabled = this.checked">
          <label for="ssl_domdefault2">Usar valor predeterminado</label>
          <cfelse>
          <strong>Nota: Este es el dominio default para SSL</strong>
        </cfif><br>
Este dominio ser&aacute; utilizado por los procesos que requieran SSL, como el login y otras pantallas que manejen informaci&oacute;n sensible que deba codificarse.</td>
      </tr>
<cfset NumRowDominio=0>
<cffunction name="RowDominio">
	<cfargument name="id_dominio" default="">
	<cfargument name="dominio" default="">
	<cfargument name="aliases" default="">
	<cfargument name="Ecodigo" default="">
	<cfargument name="id_apariencia" default="">
	<cfargument name="SMcodigo" default="">
	<cfargument name="SPcodigo" default="">
	<cfargument name="home" default="">
	<cfargument name="login" default="">
	<cfargument name="css"   default="">
	<cfargument name="ssl_login" type="boolean">
	<cfargument name="ssl_todo"  type="boolean">
	<cfargument name="ssl_home"  type="boolean">
		<cfset NumRowDominio = NumRowDominio + 1>
		<cfif StructKeyExists(form,"dominio"&NumRowDominio)>
			<cfset arguments.dominio       = form["dominio"&NumRowDominio]>
			<cfset arguments.aliases       = form["aliases"&NumRowDominio]>
			<cfset arguments.Ecodigo       = form["Ecodigo"&NumRowDominio]>
			<cfset arguments.id_apariencia = form["id_apariencia"&NumRowDominio]>
			<cfset arguments.SMcodigo      = form["SMcodigo"&NumRowDominio]>
			<cfset arguments.SPcodigo      = form["SPcodigo"&NumRowDominio]>
			<cfset arguments.home          = form["home"&NumRowDominio]>
			<cfset arguments.login         = form["login"&NumRowDominio]>
			<cfset arguments.css           = form["css"&NumRowDominio]>
			<cfset arguments.ssl_login     = StructKeyExists(form,"ssl_login"&NumRowDominio)>
			<cfset arguments.ssl_todo      = StructKeyExists(form,"ssl_todo"&NumRowDominio)>
			<cfset arguments.ssl_home      = StructKeyExists(form,"ssl_home"&NumRowDominio)>
		</cfif>
          <tr style="border-top:1px solid">
            <td class="subTitulo tituloListas">&nbsp;</td>
            <td colspan="8" class="subTitulo tituloListas">
			
			<cfif Len(arguments.id_dominio) EQ 0>
				Agregar dominio
			<cfelse>
			Dominio n&uacute;mero #NumRowDominio#
			</cfif>
			</td>
          </tr>
          <tr style="border-top:1px solid">
            <td></td>
            <td></td>
            <td> 
            Dominio </td>
            <td colspan="2">
              <input name="dominio#NumRowDominio#" id="dominio#NumRowDominio#" type="text" tabindex="#-3+NumRowDominio*7#" onFocus="select()"
				onKeyUp="this.style.color=valid_domain(this.value)?'black':'red';" value="#arguments.dominio#" maxlength="255" class="fullwidth">
            </td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td width="20"><input type="checkbox" name="ssl_login#NumRowDominio#" id="ssl_login#NumRowDominio#" <cfif isdefined('Arguments.ssl_login') and Arguments.ssl_login>checked</cfif>></td>
            <td width="194"><label for="ssl_login#NumRowDominio#"> Login seguro (SSL) </label></td>
          </tr>
          <tr>
            <td></td>
            <td></td>
            <td> 
            Aliases </td>
            <td colspan="2">
              <input name="aliases#NumRowDominio#" id="aliases#NumRowDominio#" type="text" tabindex="#-3+NumRowDominio*7#" onFocus="select()"
				onKeyUp="this.style.color=valid_aliases(this.value)?'black':'red';" value="#arguments.aliases#" maxlength="255" class="fullwidth">
            </td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><input type="checkbox" name="ssl_home#NumRowDominio#" id="ssl_home#NumRowDominio#" <cfif isdefined('Arguments.ssl_home') and Arguments.ssl_home>checked</cfif>></td>
            <td><label for="ssl_home#NumRowDominio#">
SSL en p&aacute;gina de inicio p&uacute;blica </label></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td nowrap><input type="checkbox" name="ssl_todo#NumRowDominio#" id="ssl_todo#NumRowDominio#" <cfif isdefined('Arguments.ssl_todo') and Arguments.ssl_todo>checked</cfif>></td>
            <td nowrap><label for="ssl_todo#NumRowDominio#">
Requerir SSL en todo</label></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>Empresa</td>
            <td colspan="2"><select name="Ecodigo#NumRowDominio#" class="fullwidth" tabindex="#-2+NumRowDominio*7#">
              <option value="">-ninguna-</option>
              <cfif Len(data.CEcodigo) GT 0>
                <cfoutput query="empresa">
                  <option value="#empresa.Ecodigo#" <cfif 
		empresa.Ecodigo IS arguments.Ecodigo
		>selected</cfif> >#empresa.Enombre#</option>
                </cfoutput>
              </cfif>
            </select></td>
            <td>&nbsp;</td>
            <td>Plantilla</td>
            <td colspan="2" nowrap><select tabindex="#1+NumRowDominio*7#" name="id_apariencia#NumRowDominio#" id="id_apariencia#NumRowDominio#" >
              <cfoutput query="apariencia">
                <option value="#apariencia.id_apariencia#" <cfif apariencia.id_apariencia is arguments.id_apariencia>selected</cfif>>#apariencia.descripcion#</option>
              </cfoutput>
            </select><a href="javascript:location.href='apariencia.cfm?id_apariencia='+escape(document.form1.id_apariencia#NumRowDominio#.value)">
            <img src="edit.gif" alt="Editar Plantilla" width="19" height="17" border="0"></a></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>M&oacute;dulo</td>
            <td colspan="2">
			<select name="SMcodigo#NumRowDominio#" class="fullwidth" id="select3" tabindex="#-1+NumRowDominio*7#" onChange="setmod(value,form.SPcodigo#NumRowDominio#)">
              <option value="">-ninguno-</option>
              <cfoutput query="mods" group="SScodigo">
                <optgroup label="#mods.SSdescripcion#"> <cfoutput>
                  <option value="#mods.SScodigo#$#mods.SMcodigo#" <cfif mods.SScodigo & '$' & mods.SMcodigo is arguments.SMcodigo>selected</cfif> >#mods.SMdescripcion#</option>
                </cfoutput></optgroup>
              </cfoutput>
            </select></td>
            <td>&nbsp;</td>
            <td>Home</td>
            <td colspan="2" nowrap>
              <input type="text" tabindex="#2+NumRowDominio*7#" name="home#NumRowDominio#" value="#arguments.home#" onFocus="select()">
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;<input type="hidden" name="id_dominio#NumRowDominio#" value="#arguments.id_dominio#"></td>
            <td>
              
			  Servicio </td>
            <td colspan="2"><select name="SPcodigo#NumRowDominio#" class="fullwidth" id="SPcodigo#NumRowDominio#" tabindex="#0+NumRowDominio*7#">
              <option value="">-ninguno-</option>
              <cfoutput query="procs">
                <cfif procs.SScodigo & '$' & procs.SMcodigo is arguments.SMcodigo>
                  <option value="#procs.SPcodigo#" <cfif procs.SPcodigo is arguments.SPcodigo>selected</cfif> >#procs.SPdescripcion#</option>
                </cfif>
              </cfoutput>
            </select></td>
            <td>&nbsp;</td>
            <td>Login</td>
            <td colspan="2" nowrap>
              <input type="text" tabindex="#3+NumRowDominio*7#" name="login#NumRowDominio#" value="#arguments.login#" onFocus="select()"></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2">&nbsp;</td>
            <td>&nbsp;</td>
            <td>CSS</td>
            <td colspan="2" nowrap><input name="css#NumRowDominio#" type="text" id="css#NumRowDominio#" tabindex="#3+NumRowDominio*7#" onFocus="select()" value="#arguments.css#">            </td>
          </tr>
</cffunction>

          <cfloop query="doms">
		  #RowDominio(
		  		doms.id_dominio, doms.dominio, doms.MSDaliases, doms.Ecodigo, doms.id_apariencia,
				doms.SScodigo & '$' & doms.SMcodigo, doms.SPcodigo, doms.home, doms.login, doms.css,
				doms.ssl_login, doms.ssl_todo, doms.ssl_home)#
		  </cfloop>
		  #RowDominio('','','','',domdefault.id_apariencia,
		  	'','','','','',
			true, false, false)#
      <tr>
        <td colspan="9">&nbsp;</td>
      </tr>
  <tr align="left">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="7"><a name="botones" id="botones"></a>
    <input tabindex="101" name="btnOk" type="submit" value="Aceptar">
	<input tabindex="102" name="btnApply" type="submit" value="Aplicar">
	<cfif Len(form.Scodigo)>
	<input tabindex="103" name="btnDelete" type="submit" value="Eliminar">
	<input tabindex="104" name="btnNew" type="button" value="Nuevo" onClick="location.href='dominio-edit.cfm?srch=#form.srch#&srty=#form.srty#'"></cfif>
      <input tabindex="105" name="btnCancel" type="button" value="Cancelar" onClick="location.href='dominio.cfm?srch=#form.srch#&srty=#form.srty#'">
  </td>
    </tr>
  <tr align="left">
    <td colspan="9">&nbsp;</td>
    </tr><tr><td height="1"></td><td></td><td></td><td></td><td></td>
      <td></td>
      <td></td><td colspan="2"></td></tr>
</table>
<input type="hidden" name="maxline" value="#NumRowDominio#">
</form>
</cfoutput>
<script type="text/javascript">
<!--
_mods = new Object();
<cfoutput query="procs" group="SMcodigo">
serv=new Object();
<cfoutput>
serv["#SPcodigo#"] = "#SPdescripcion#";
</cfoutput>
_mods["#SScodigo#$#SMcodigo#"] = serv;
</cfoutput>

homepg = new Array(<!---
<cfoutput query="home">
new Object({home:"#JSStringFormat(home)#", login:"#JSStringFormat(login)#", template:"#JSStringFormat(template)#"}),
</cfoutput> 0--->);
NumRowDominio = <cfoutput>#NumRowDominio#</cfoutput>;
function setmod(mod,srv){
	while(srv.length > 1) {
		srv.remove(srv.length-1);
	}
	serv = _mods[mod];
	for (servicio in serv){
		opt = document.createElement("option");
		opt.value = servicio;
		opt.text = serv[servicio];
		document.all ?
		srv.add ( opt ) :
		srv.add ( opt, null);
	}
}
function setce() {
	f = document.form1;
	f.action = "";
	f.submit();
}
function valid_domain(s){
	if (s == '*') {
		return true;
	} else {
		return s.match(/^(\w+(-\w+)*)(\.\w+(-\w+)*)+\.?$/);
	}
}
function valid_aliases(s){
	if (s == '*') {
		return true;
	} else {
		return s.match(/^((\w+(-\w+)*)(\.\w+(-\w+)*)+\.?)(,(\w+(-\w+)*)(\.\w+(-\w+)*)+\.?)*$/);
	}
}
function validate(f){
	var not_domain = '';
	var invalid_ctl = null;
	if (f.ssl_dominio.value.length != 0 && !valid_domain(f.ssl_dominio.value)){
		not_domain = '    ' + f.ssl_dominio.value;
		invalid_ctl = f.ssl_dominio;
	}
	for (i=1;i<=NumRowDominio;i++){
		ctl = f["dominio"+i];
		if (ctl.value.length != 0 && !valid_domain(ctl.value)) {
			not_domain = (not_domain == null ? '' : not_domain + '\r\n') + '    ' + ctl.value;
			if (invalid_ctl == null) invalid_ctl = ctl;
		}
	}
	if (invalid_ctl != null) {
		if (!window.confirm("Los siguientes dominios parecen estar mal escritos:\r\n\r\n"+not_domain+"\r\n\r\nDesea continuar con estos datos?")) {
			invalid_ctl.focus();
			return false;
		}
	}

	return true;
}
-->
</script>
