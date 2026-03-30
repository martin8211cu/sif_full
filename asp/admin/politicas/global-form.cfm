<style type="text/css">
<!--
.section {
	font-family: Geneva, Arial, Helvetica, sans-serif;
	font-weight: bold;
}
.flat {
	border:1px solid #7f9db9;
	text-align:right;
}
-->
</style>

<!--- El combo de cache para demos depende de la cuenta empresarial, por eso se usa este query --->
<cfquery name="caches" datasource="asp">
	select b.CEcodigo, b.CEClinea, b.Cid, a.Ccache,a.Cexclusivo
		from CECaches b, Caches a
		where b.Cid = a.Cid
		  and b.CEcodigo != 1
	order by CEcodigo
</cfquery>

<cfinvoke component="home.Componentes.aspmonitor" method="GetHostName" returnvariable="localhostname"/>

<cfquery datasource="aspmonitor" name="hosts" maxrows="240">
	select distinct hostname, upper(hostname) as hostupper, max (last_access) as last_accessed
	from MonServerProcess
	where last_access > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',-30,Now())#">
	group by upper(hostname), hostname
	order by hostupper, hostname
</cfquery>

<script type="text/javascript">
<!--
	function factory_presets(){
		if (confirm("¿Está seguro de que desea restablecer todo a los valores predeterminados?")) {
			location.href = 'global-apply.cfm?action=factory_presets';
		}
	}

	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function funcvalidar(){
		if (trim(document.form1.demo_vigencia.value) == ''){
			alert("Debe ingresar una vigencia para el usuario de las demostraciones")
			return false;
		}		
		return true;
	}

	function cache(cuenta, seleccionado){
		var c = document.form1.demo_cache;
		var cuenta_asp = '';
		c.options.length = 0;

		if ( cuenta != '' ){
			<cfoutput query="caches">
				cuenta_asp = #caches.CEcodigo#;
				if ( cuenta_asp == cuenta ){
					c.options.length++;
					c.options[c.options.length-1].text = '#caches.Ccache#';
					c.options[c.options.length-1].value = '#caches.Ccache#';
					
					if ( seleccionado == '#caches.Ccache#'){
						c.options[c.options.length-1].selected = true;
					}
					
				}
			</cfoutput>
		}	
	}
//-->
</script>


<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
<cfset data = StructNew()>

<cfset data.pass_expira_default      = Politicas.trae_parametro_global("pass.expira.default")>
<cfset data.pass_expira_max          = Politicas.trae_parametro_global("pass.expira.max")>
<cfset data.pass_expira_min          = Politicas.trae_parametro_global("pass.expira.min")>
<cfset data.pass_expira_recordatorio = Politicas.trae_parametro_global("pass.expira.recordatorio")>
<cfset data.pass_long_max            = Politicas.trae_parametro_global("pass.long.max")>
<cfset data.pass_long_min            = Politicas.trae_parametro_global("pass.long.min")>
<cfset data.pass_valida_digitos      = Politicas.trae_parametro_global("pass.valida.digitos")>
<cfset data.pass_valida_letras       = Politicas.trae_parametro_global("pass.valida.letras")>
<cfset data.pass_valida_lista        = Politicas.trae_parametro_global("pass.valida.lista")>
<cfset data.pass_valida_simbolos     = Politicas.trae_parametro_global("pass.valida.simbolos")>
<cfset data.pass_valida_diccionario  = Politicas.trae_parametro_global("pass.valida.diccionario")>
<cfset data.pass_valida_usuario      = Politicas.trae_parametro_global("pass.valida.usuario")>
<cfset data.sesion_bloqueo_cant      = Politicas.trae_parametro_global("sesion.bloqueo.cant")>
<cfset data.sesion_bloqueo_duracion  = Politicas.trae_parametro_global("sesion.bloqueo.duracion")>
<cfset data.sesion_bloqueo_periodo   = Politicas.trae_parametro_global("sesion.bloqueo.periodo")>
<cfset data.sesion_duracion_default  = Politicas.trae_parametro_global("sesion.duracion.default")>
<cfset data.sesion_duracion_max      = Politicas.trae_parametro_global("sesion.duracion.max")>
<cfset data.sesion_duracion_min      = Politicas.trae_parametro_global("sesion.duracion.min")>
<cfset data.sesion_duracion_modo     = Politicas.trae_parametro_global("sesion.duracion.modo")>
<cfset data.sesion_multiple          = Politicas.trae_parametro_global("sesion.multiple")>
<cfset data.monitor_historia         = Politicas.trae_parametro_global("monitor.historia")>

<cfset data.correo_cuenta         	 = Politicas.trae_parametro_global("correo.cuenta")>
<cfset data.demo_CuentaEmpresarial   = Politicas.trae_parametro_global("demo.CuentaEmpresarial")>
<cfset data.demo_vigencia         	 = Politicas.trae_parametro_global("demo.vigencia")>
<cfset data.demo_cache         	     = Politicas.trae_parametro_global("demo.cache")>

<cfset data.servidor_principal       = Politicas.trae_parametro_global("servidor.principal")>

<cfquery name="rsCuentasEmpresariales" datasource="asp">
	select CEcodigo,CEnombre
	from CuentaEmpresarial
	where CEcodigo != 1
	order by CEnombre
</cfquery>

<form name="form1" method="post" action="global-apply.cfm" onSubmit="javascript: return funcvalidar()"><cfoutput>
  <table border="0" cellpadding="2" cellspacing="2">
    <tr>
      <td width="313" valign="top"><table border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="10">&nbsp;</td>
            <td width="17">&nbsp;</td>
            <td width="20">&nbsp;</td>
            <td width="104">&nbsp;</td>
            <td width="146">&nbsp;</td>
            <td width="12">&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4" class="subTitulo"><strong>Expiraci&oacute;n de contrase&ntilde;as en d&iacute;as </strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;&nbsp;&nbsp;</td>
            <td colspan="2"><label for="pass_expira_default">Valor general </label></td>
            <td><input name="pass_expira_default" type="text" class="flat" id="pass_expira_default" onFocus="this.select()" value="#data.pass_expira_default#" size="6" maxlength="6">
                <label for="pass_expira_default">d&iacute;as</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2"><label for="pass_expira_recordatorio">Recordatorio</label></td>
            <td><input name="pass_expira_recordatorio" type="text" class="flat" id="pass_expira_recordatorio" onFocus="this.select()" value="#data.pass_expira_recordatorio#" size="6" maxlength="6">
                <label for="pass_expira_recordatorio"> d&iacute;as</label></td>
            <td >&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2"><label for="pass_expira_min">Rango v&aacute;lido &dagger;</label></td>
            <td><input name="pass_expira_min" type="text" class="flat" id="pass_expira_min" onFocus="this.select()" value="#data.pass_expira_min#" size="6" maxlength="6">
                <label for="pass_expira_max"> a </label>
                <input name="pass_expira_max" type="text" class="flat" id="pass_expira_max" onFocus="this.select()" value="#data.pass_expira_max#" size="6" maxlength="6">
            </td>
            <td bgcolor="">&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4" class="subTitulo"><strong>Expiraci&oacute;n de la sesi&oacute;n</strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2"><label for="sesion_duracion_default">Valor general </label></td>
            <td><input name="sesion_duracion_default" type="text" class="flat" id="sesion_duracion_default" onFocus="this.select()" value="#data.sesion_duracion_default#" size="6" maxlength="6">
                <label for="sesion_duracion_default">minutos</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2"><label for="sesion_duracion_min">Rango v&aacute;lido &dagger;</label></td>
            <td><input name="sesion_duracion_min" type="text" class="flat" id="sesion_duracion_min" onFocus="this.select()" value="#data.sesion_duracion_min#" size="6" maxlength="6">
                <label for="sesion_duracion_max"> a </label>
                <input name="sesion_duracion_max" type="text" class="flat" id="sesion_duracion_max" onFocus="this.select()" value="#data.sesion_duracion_max#" size="6" maxlength="6">
            </td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td valign="middle"><input id="sesion_duracion_modo_1" name="sesion_duracion_modo" type="radio" value="1" <cfif data.sesion_duracion_modo neq '2'>checked</cfif>>
            </td>
            <td colspan="2" valign="middle"><label for="sesion_duracion_modo_1">Contar desde el inicio de la sesi&oacute;n </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td valign="middle"><input id="sesion_duracion_modo_2" name="sesion_duracion_modo" type="radio" value="2" <cfif data.sesion_duracion_modo eq '2'>checked</cfif>>
            </td>
            <td colspan="2" valign="middle"><label for="sesion_duracion_modo_2">Contar solamente tiempo inactivo </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4" class="subTitulo"><strong>Bloqueo de usuarios</strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3"><label for="sesion_bloqueo_cant">Si falla el login</label>
                  <input name="sesion_bloqueo_cant" type="text" class="flat" id="sesion_bloqueo_cant" onFocus="this.select()" value="#data.sesion_bloqueo_cant#" size="6" maxlength="6">
            <label for="sesion_bloqueo_cant">veces, el usuario: </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><input name="sesion_bloqueo_reactivar" id="sesion_bloqueo_reactivar_0" type="radio" value="0" onClick="with(form.sesion_bloqueo_duracion){disabled = false;focus()}" <cfif data.sesion_bloqueo_duracion > checked </cfif>>
            </td>
            <td colspan="2"><label for="sesion_bloqueo_reactivar_0">se bloquea por</label>
                <input name="sesion_bloqueo_duracion" type="text" class="flat" id="sesion_bloqueo_duracion" onFocus="this.select()" value="<cfif data.sesion_bloqueo_duracion is 0>#data.sesion_bloqueo_periodo#<cfelse>#data.sesion_bloqueo_duracion#</cfif>" size="6" maxlength="6" <cfif data.sesion_bloqueo_duracion is 0 >disabled</cfif>>
                <label for="sesion_bloqueo_duracion"> minutos, o</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><input name="sesion_bloqueo_reactivar" id="sesion_bloqueo_reactivar_1" type="radio" value="1" onClick="form.sesion_bloqueo_duracion.disabled = this.checked" <cfif data.sesion_bloqueo_duracion is 0 > checked </cfif>>
            </td>
            <td colspan="2"><label for="sesion_bloqueo_reactivar_1">requerir&aacute; reactivaci&oacute;n. </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3"><label for="sesion_bloqueo_periodo">Borrar contador despu&eacute;s de</label>
                  <input name="sesion_bloqueo_periodo" type="text" class="flat" id="sesion_bloqueo_periodo" onFocus="this.select()" value="#data.sesion_bloqueo_periodo#" size="6" maxlength="6">
            <label for="sesion_bloqueo_periodo">minutos.</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4" class="subTitulo"><strong>Bit&aacute;coras para auditor&iacute;a</strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><input name="monitor_historia_auto" id="monitor_historia_0" type="radio" value="0" <cfif data.monitor_historia is 0>checked</cfif>   onClick="form.monitor_historia.disabled = true;"  >
            </td>
            <td colspan="2"><label for="monitor_historia_0">Borrado manual </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><input name="monitor_historia_auto" id="monitor_historia_1" type="radio" value="1" <cfif data.monitor_historia neq 0>checked</cfif>  onClick="with(form.monitor_historia){disabled = false;focus()}"  >
            </td>
            <td colspan="2"><label for="monitor_historia_1">Conservar informaci&oacute;n por</label>
                <input name="monitor_historia" type="text" class="flat" id="monitor_historia" onFocus="this.select()" value="<cfif data.monitor_historia>#data.monitor_historia#<cfelse>90</cfif>" <cfif data.monitor_historia is 0>disabled</cfif> size="6" maxlength="6">
                <label for="monitor_historia">d&iacute;as.</label>
            </td>
            <td>&nbsp;</td>
          </tr>
      </table></td>
      <td width="429" valign="top"><table border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="32">&nbsp;</td>
            <td>&nbsp;</td>
            <td width="27">&nbsp;</td>
            <td width="180">&nbsp;</td>
            <td width="153">&nbsp;</td>
            <td width="10">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="5" class="subTitulo"><strong>Gesti&oacute;n de contrase&ntilde;as <strong>&Dagger;</strong></strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;&nbsp;&nbsp;</td>
            <td colspan="3"><label for="pass_long_min">Longitud m&iacute;nima </label></td>
            <td><input name="pass_long_min" type="text" class="flat" id="pass_long_min" onFocus="this.select()" value="#data.pass_long_min#" size="6" maxlength="6"></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="3"><label for="pass_long_max">Longitud m&aacute;xima</label></td>
            <td><input name="pass_long_max" type="text" class="flat" id="pass_long_max" onFocus="this.select()" value="#data.pass_long_max#" size="6" maxlength="6"></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4">La contrase&ntilde;a debe contener caracteres de los siguientes grupos:</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4">
                <input name="pass_valida_digitos" type="checkbox" id="pass_valida_digitos" value="1" <cfif data.pass_valida_digitos is 1>checked</cfif>>
                <label for="pass_valida_digitos">D&iacute;gitos</label>
                <input name="pass_valida_letras" type="checkbox" id="pass_valida_letras" value="1" <cfif data.pass_valida_letras is 1>checked</cfif>>
                <label for="pass_valida_letras">Letras</label>
                <input name="pass_valida_simbolos" type="checkbox" id="pass_valida_simbolos" value="1" <cfif data.pass_valida_simbolos is 1>checked</cfif>>
                <label for="pass_valida_simbolos">S&iacute;mbolos</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td width="27"><input name="pass_valida_usuario" type="checkbox" id="pass_valida_usuario" value="1" <cfif data.pass_valida_usuario is 1>checked</cfif>>
            </td>
            <td colspan="3"><label for="pass_valida_usuario">Comparar contrase&ntilde;a con usuario. </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top"><input name="pass_valida_diccionario" type="checkbox" id="pass_valida_diccionario" value="1" <cfif data.pass_valida_diccionario is 1>checked</cfif>>
            </td>
            <td colspan="3" valign="top"><label for="pass_valida_diccionario">Validar la contrase&ntilde;a contra un diccionario</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top"><input name="pass_valida_lista_0" type="checkbox" id="pass_valida_lista_0" value="1" <cfif data.pass_valida_lista neq 0>checked</cfif> onClick="this.form.pass_valida_lista.disabled=!this.checked;">
                <label for="pass_valida_lista_0"></label></td>
            <td colspan="3" valign="top"><label for="pass_valida_lista_0">Evitar que se repitan las &uacute;ltimas</label>
                <select name="pass_valida_lista" id="pass_valida_lista" <cfif data.pass_valida_lista is 0>disabled</cfif>>
                  <cfloop from="1" to="40" index="i">
                    <option <cfif data.pass_valida_lista is i or data.pass_valida_lista is 0 and i is 10>selected</cfif>>#i#</option>
                  </cfloop>
                </select>
            <label for="pass_valida_lista_0">contrase&ntilde;as</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="5" class="subTitulo"><strong>M&uacute;ltiples sesiones por usuario</strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top"><input id="sesion_multiple_1" name="sesion_multiple" type="radio" value="1" <cfif data.sesion_multiple is 1>checked</cfif>></td>
            <td colspan="3" valign="top"><label for="sesion_multiple_1"><strong>Permitir m&uacute;ltiples sesiones por usuario. <br>
                    <br>
            </strong></label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top"><label>
              <input id="sesion_multiple_2" name="sesion_multiple" type="radio" value="2" <cfif data.sesion_multiple is 2>checked</cfif>>
            </label></td>
            <td colspan="3" valign="top"><label for="sesion_multiple_2" ><strong>Desconectar sesiones anteriores.</strong><br>
            Si se realiza una segunda conexi&oacute;n por el mismo<br>
            usuario, se desconectar&aacute;n la sesiones anteriores. <br>
            <br>
            </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top"><input id="sesion_multiple_3" name="sesion_multiple" type="radio" value="3" <cfif data.sesion_multiple is 3>checked</cfif>></td>
            <td colspan="3" valign="top"><label for="sesion_multiple_3"><strong>Permitir s&oacute;lo una sesi&oacute;n por usuario. </strong><br>
            No se realizar&aacute;n nuevas conexiones para el <br>
            mismo usuario mientras las anteriores no <br>
            finalicen o expiren. </label></td>
            <td>&nbsp;</td>
          </tr>
      </table>
        </td>
<!---*/*/**/*/*/*/*/---->      
	  	<td width="205" valign="top"><table width="313" border="0" cellpadding="0" cellspacing="0">
          	<tr>
				<td width="1%">&nbsp;</td>
				<td width="15%">&nbsp;</td>
				<td width="81%">&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td class="subTitulo" colspan="2"><strong>Demostraciones</strong></td>
          	</tr>
		  	<tr>
		  		<td>&nbsp;</td>
				<td colspan="2" valign="top"><label for="demo_vigencia">Vigencia</label>				  <label for="demo_vigencia">en días</label></td>
			</tr>

			<tr>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
		      <td><input  name="demo_vigencia" type="text" id="demo_vigencia" onfocus="this.select()" value="#data.demo_vigencia #" size="6" maxlength="6" /></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2"><label for="demo_CuentaEmpresarial">Cuenta Empresarial demos&nbsp;</label></td>
			</tr>

			<tr>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td><label for="demo_CuentaEmpresarial">
                 <select name="demo_CuentaEmpresarial" id="demo_CuentaEmpresarial" onChange="javascript:cache(this.value,'#data.demo_cache#');" <cfif data.demo_CuentaEmpresarial is 0>disabled</cfif>>
					  <cfloop query="rsCuentasEmpresariales">
						<option value="#rsCuentasEmpresariales.CEcodigo#" <cfif trim(rsCuentasEmpresariales.CEcodigo) EQ trim(data.demo_CuentaEmpresarial)>selected</cfif>>#trim(rsCuentasEmpresariales.CEnombre)#</option>
					  </cfloop>                
				  </select> 
            	</label></td>
		    </tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2"><label for="demo_cache">Cache demos&nbsp;</label></td>
			</tr>

			<tr>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td><label for="demo_cache">
                 <select name="demo_cache" id="demo_cache" >
				  </select> 
            	</label>
				<script type="text/javascript" language="javascript1.2">
					cache(document.form1.demo_CuentaEmpresarial.value, '#data.demo_cache#');
				</script></td>
		    </tr>
			<tr>
				<td width="1%">&nbsp;</td>
				<td width="15%">&nbsp;</td>
				<td width="81%">&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td class="subTitulo" colspan="2"><strong>Correo</strong></td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
				<td colspan="2" valign="top" >Cuenta origen de los correos de salida del portal&nbsp;</td>
		    </tr>
			<tr>
				<td>&nbsp;</td>
			  <td valign="top" >&nbsp;</td>
				<td><label for="correo_cuenta">
                  <input name="correo_cuenta" type="text" class="flat" id="correo_cuenta" onFocus="this.select()" value="#data.correo_cuenta#" size="25" maxlength="60" style="text-align:left ">
            	</label></td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td valign="top" >&nbsp;</td>
			  <td>&nbsp;</td>
		    </tr>
			<tr>
			  <td>&nbsp;</td>
			  <td class="subTitulo" colspan="2"><strong>Múltiples servidores </strong></td>
			</tr>
			<tr>
              <td>&nbsp;</td>
			  <td colspan="2" valign="top" >Servidor principal </td>
		    </tr>
			<tr>
			  <td>&nbsp;</td>
			  <td valign="top" >&nbsp;</td>
			  <td><label for="servidor_principal">
				<select name="servidor_principal">
				<option value="">(sin especificar)</option>
				<cfloop query="hosts">
				<option value="# HTMLEditFormat(Trim(hostname)) #" <cfif Trim(hostname) EQ data.servidor_principal >selected</cfif>># HTMLEditFormat(hostname) #
					<cfif hostname EQ localhostname>[local]</cfif>
				 </option>
				</cfloop>
				</select>
				</label></td>
		    </tr>
			<tr>
			  <td>&nbsp;</td>
			  <td valign="top" >&nbsp;</td>
			  <td>El servidor principal es el encargado de realizar las tareas programadas comunes, como envío de correos, mantenimiento de la historia, etcétera. Si hay más de un servidor de aplicaciones conectado a las mismas bases de datos de asp, indique cuál de ellos es el servidor principal. Este parámetro puede estar en blanco</td>
		    </tr>
      	</table></td>

<!---*/*/**/*/*/*/*/---->	  
    </tr>
    <tr>
      <td colspan="2" align="left" class="subTitulo"><input type="submit" name="Submit" value="Aplicar">
          <input type="reset" name="Reset" value="Cancelar">
      </td>
    </tr>
    <tr>
      <td colspan="2" align="left"> (&dagger;) Estas opciones restringen la modificaci&oacute;n de pol&iacute;ticas por cuenta empresarial <br>
      (<strong>&Dagger;</strong>) Estas opciones no est&aacute;n activadas en este servidor </td>
    </tr>
  </table>
</cfoutput>
</form>
