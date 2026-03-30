<html>
<head>
<title>Seleccionar fuente de datos</title>
</head>
<body>
<h1>Seleccionar fuente de datos</h1>
<cfoutput>
  <form action="index.cfm" method="get" onSubmit="return checkform(this);">
    <table>
      <tr>
        <td valign="top"><table>
            <tr>
              <td align="right" valign="top"> Usuario (sólo sybase/sqlserver) </td>
              <td align="right" valign="top">&nbsp;</td>
              <td valign="top">
                <input type="text" name="username" value="#url.username#" onChange="propaga_user(this.form)" onFocus="this.select()">              </td>
            </tr>
            <tr>
              <td align="right" valign="top"> Contraseña </td>
              <td align="right" valign="top">&nbsp;</td>
              <td valign="top">
                <input type="password" name="password" value="#url.password#">              </td>
            </tr>
            <tr>
              <td align="right" valign="top"> Servidor </td>
              <td align="right" valign="top">&nbsp;</td>
              <td valign="top">
                <input type="text" name="host" value="#url.host#">              </td>
            </tr>
            <tr>
              <td align="right" valign="top"> Puerto </td>
              <td align="right" valign="top">&nbsp;</td>
              <td valign="top">
                <input type="text" name="port" value="#url.port#">              </td>
            </tr>
            <tr>
              <td align="right" valign="top"> SID 
              (sólo oracle)</td>
              <td align="right" valign="top">&nbsp;</td>
              <td valign="top">
                <input type="text" name="sid" value="#url.sid#">              </td>
            </tr>
            <tr>
			  <td align="right" valign="top">Tipo</td>
			  <td align="right" valign="top"></td>
			  <td valign="top"><input type="radio" name="type" value="sybase" id="type_sybase" 
					onclick='setvalues(this.value,this.form)'
					<cfif url.type eq 'sybase'>checked</cfif>
					>
                <label for="type_sybase">Sybase</label>              
                <a href="?syb=1">defaults</a></td>
            </tr>
            <tr>
              <td align="right" valign="top"></td>
              <td align="right" valign="top"></td>
              <td valign="top"><input type="radio" name="type" value="oracle" id="type_oracle" 
						onclick='setvalues(this.value,this.form)'
						<cfif url.type eq 'oracle'>checked</cfif>
						>
                <label for="type_oracle">Oracle</label>              
                <a href="?ora=1">defaults</a></td>
            </tr>
            <tr>
              <td align="right" valign="top"></td>
              <td align="right" valign="top"></td>
              <td valign="top"><input type="radio" name="type" value="sqlserver" id="type_sqlserver" 
						onclick='setvalues(this.value,this.form)'
						<cfif url.type eq 'sqlserver'>checked</cfif>
						>
                <label for="type_oracle">MS Sql Server</label>              
                <a href="?mss=1">defaults</a></td>
            </tr>
          </table></td>
        <td  valign="top"><table border="0" cellpadding="3" cellspacing="0">
            <cfset onchange="this.checked">
            <!---<cfloop list="#ListSort( StructKeyList( dsources ), 'text' )#" index="ds1">--->
            <cfloop list="#ListSort( url.ds, 'text' )#" index="ds1">
              <cfset onchange="this.form.ds#ds1#.checked=" & onchange>
            </cfloop>
            <tr bgcolor="##CCCCCC">
              <td><input type="checkbox" id="ds_selall" onChange="#onchange#"></td>
              <td><label for="ds_selall">datasource</label></td>
              <td>user</td>
              <td>db</td>
              <td>type</td>
            </tr>
            <!---<cfloop list="#ListSort( StructKeyList( dsources ), 'text' )#" index="ds1">--->
            
            <cfloop list="#ListSort( url.ds , 'text' )#" index="ds1">
              <tr>
                <td><input type="checkbox" <cfif ListFind(url.ds,ds1) >checked="checked"</cfif> value="#ds1#" name="ds" id="ds#ds1#"></td>
                <td><label for="ds#ds1#">#ds1#</label></td>
                <td>
				<cfif StructKeyExists(dsources,ds1)>
					<cfset usernamedefault = dsources[ds1].username>
				<cfelse>
					<cfset usernamedefault = ''>
				</cfif>
                <cftry>
				<cfparam name="url.user_#ds1#" default="#usernamedefault#">
				<input type="text" name="user_#ds1#" value="#url['user_' & ds1]#" onFocus="this.select()"></td>
                <td>
				<cfparam name="url.db_#ds1#" default="#dsources[ds1].urlmap.database#">
				<input type="text" name="db_#ds1#" value="#url['db_' & ds1]#" onFocus="this.select()"></td>
                <td>#dsources[ds1].driver#</td>
                <cfcatch type="any">
					<td>&nbsp;</td><td>&nbsp;</td>	
                </cfcatch>
                </cftry>
              </tr>
            </cfloop>
          </table></td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2"><input type="submit" name="ok" value="Actualizar servidor local">
        <input type="submit" name="verify" value="Probar conexiones">
        <input type="submit" name="connect" value="Ingresar al sistema"></td>
      </tr>
    </table>
  </form>
</cfoutput>
<script type="text/javascript">
function propaga_user(f){
	if(f.type_sybase.checked || f.type_sqlserver.checked){
		f.user_asp.value=f.username.value;
		f.user_aspmonitor.value=f.username.value;
		f.user_isb.value=f.username.value;
		f.user_minisif.value=f.username.value;
		f.user_sifcontrol.value=f.username.value;
		f.user_sifinterfaces.value=f.username.value;
		f.user_sifpublica.value=f.username.value;
	}
}
function setvalues(t,f){
	if(t=='sybase'){
		propaga_user(f);
		f.host.value='10.7.7.198';
		f.port.value='5000';
		f.sid.value='';
		f.db_asp.value='asp';
		f.db_aspmonitor.value='aspmonitor';
		f.db_isb.value='isb';
		f.db_minisif.value='minisif';
		f.db_sifcontrol.value='sif_control';
		f.db_sifinterfaces.value='sif_interfaces';
		f.db_sifpublica.value='sif_publica';
	} else if(t=='oracle'){
		f.user_asp.value='asp_cert',
		f.user_aspmonitor.value='aspmonitor_cert',
		f.user_isb.value='minisif2_isb',
		f.user_minisif.value='minisif2_cert',
		f.user_sifcontrol.value='sifcontrol_oracle',
		f.user_sifinterfaces.value='interfaces',
		f.user_sifpublica.value='sifpublica_oracle',
		f.host.value='10.7.7.201';
		f.port.value='1521';
		f.sid.value='asp';
	}
}
function checkform(f){
	var msg = '',ctl=0;
	if (f.type_sybase.checked) {
		if (f.username.value == '' || f.username.value == '(usuario)') {
			msg += '\n- Indique su usuario de base de datos';
			ctl = f.username;
		}
	} else if (f.type_oracle.checked) {
	} 
	if (f.password.value == '') {
		msg += '\n- Indique su contraseña';
		ctl = f.password;
	}
	if (msg != ''){
		alert("Verifique lo siguiente:"+msg);
		ctl.focus();
		ctl.select();
		return false;
	}
	return true;
}
</script>
</body>
</html>