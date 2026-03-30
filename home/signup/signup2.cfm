<cfset Request.PNAVEGACION_SHOWN = 1>
<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta" returnvariable="dataPoliticas" CEcodigo="#session.CEcodigo#"/>
<cfinvoke component="home.Componentes.ValidarPassword" method="javascript" data="#dataPoliticas#"/>
<cfinvoke component="home.Componentes.ValidarPassword" method="reglas" data="#dataPoliticas#" returnvariable="reglas"/>
<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Login
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">

<cfhtmlhead text='<link href="signup.css" rel="stylesheet" type="text/css" />'>
<cfhtmlhead text='<script type="text/javascript" language="JavaScript" src="signup2.js">//</script>'>
<center><table border="0" width="585" cellspacing="0" cellpadding="0">
<tr>
      <td width="1%">&nbsp;</td>
      <td><table border="0" cellspacing="0" cellpadding="0" width="100%"><tr>
            <td align="right" valign="bottom" class="e"><a href="signon-ayuda.cfm">Ayuda</a> 
              - <a href="../public/logout.cfm">Iniciar 
              sesi&oacute;n </a></td>
          </tr></table>
        <hr size="1" /></td></tr></table>
  <form method="post" name="f" action="signup2-apply.cfm" >
    <table width="585" cellspacing="4" cellpadding="4" border="0" class="g" >
      <!--DWLayoutTable-->
      <tr > 
        <td colspan="2" class="h">Seleccione su usuario</td>
      </tr>
    <tr class="h"> 
      <td colspan="2">Bienvenido,<cfoutput>#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#</cfoutput> </td>
    </tr>
      <tr> 
        <td height="3" colspan="2" valign="top" class="t"> <p>Ahora usted podr&aacute;
                seleccionar el nombre del usuario que utilizar&aacute; en adelante para
                identificarse con el portal. Puede seleccionar el nombre de una
                lista de sugerencias seg&uacute;n su nombre, o bien puede capturar el
                nombre que usted desee.</p>        </td>
      </tr>
    <tr>
      <td class="err" colspan="2">
	  	<cfif IsDefined("url.error") AND url.error EQ 1>
          Por favor, seleccione uno de los nombres 
            de usuario disponibles, o especifique otro.
	  	    <cfelseif IsDefined("url.error") AND url.error EQ 2>
		  	El usuario ya ha sido asignado a otra persona
	  	<cfelseif IsDefined("url.error") AND url.error EQ 5>
			<cfparam name="session.erruser" default="Usuario inválido">
			<cfoutput>#session.erruser#</cfoutput><cfset StructDelete(session, 'erruser')>
	    </cfif></td>
    </tr>
      <tr> 
        <td height="30" rowspan="2" valign="top" class="t"> <p>Seleccione un
                nombre de usuario:</p></td>
        <td valign="top" class="e"> 
			<cfscript>
				s = ListToArray( LCase( session.datos_personales.nombre & " " 
					& session.datos_personales.apellido1 & " " 
					& session.datos_personales.apellido2), " ");
				set = ArrayNew(1); // new TreeSet()
				year = Year(Now());
				sug = ArrayToList(s,"");
				ArrayAppend(set, sug);
				ArrayAppend(set, sug & year);
				for (i = 1; i LE ArrayLen(s); i = i + 1) {
					sug = "";
					for (j = 1; j LE ArrayLen(s); j = j + 1) {
						sug = sug & IIf(i EQ j, "s[j]", "Left(s[j], 1)" );
						if (Len( sug) GT 2) {
							ArrayAppend(set, sug);
						}
						ArrayAppend(set, sug & year);
					}
				}
				ArraySort(set, "Text", "asc");
			</cfscript>

			<cfquery datasource="asp" name="repetidos">
				select Usulogin
				from Usuario
				where Usulogin in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayToList(set)#" list="yes">)
				  and Usucodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				  and CEcodigo = #session.CEcodigo#
			</cfquery>
			<cfset reps = ValueList(repetidos.Usulogin)>
            <cfset size=1>
            
		    <cfset validChars="ABCDEFGHIJKLMNOPQRSTUVWXYZ">
            <cfset validDGIT="0123456789">
		
		<cfset SALT_DIGITS = validChars.toCharArray()>
		<cfset ch = "">
		<cfloop from="1" to="#size#" index="n">
			<cfset ch = ch & SALT_DIGITS[Rand() * ArrayLen(SALT_DIGITS) + 1] >
		</cfloop>
        <cfset SALT_DIGI = validDGIT.toCharArray()>
        <cfset dg = "">
		<cfloop from="1" to="#size#" index="n">
			<cfset dg = dg & SALT_DIGI[Rand() * ArrayLen(SALT_DIGI) + 1] >
		</cfloop>
			<select name="login" onChange="document.f.logintext.value = this.value;obid('div_logintext').style.visibility=this.value==''?'':'hidden'; fnhabilita(this.value)" >
				<cfloop from="1" to="#ArrayLen(set)#" index="i">
					<cfoutput>
						<cfif i EQ 1 OR set[i] NEQ set[i-1] and ListFind(reps, set[i]) EQ 0>	
                        	<cfset usuario = set[i]>
							<cfif dataPoliticas.user.valida.letras eq 1>
                            	<cfset usuario = usuario & ch>
                            </cfif>
                            <cfif dataPoliticas.user.valida.digitos eq 1>	
                           		<cfset usuario = usuario & dg>
                            </cfif>					
							<option value="#usuario#">#usuario# </option>
						</cfif>
					</cfoutput>
				</cfloop>
				<option value="" selected>Especificar...</option>
			</select>        </td>
      </tr>
      <tr>
          <td valign="top" class="e">
		  <div id="div_logintext">
		  <input type="text" name="logintext" value="" size="30" onFocus="this.select()"   onkeyup="valid_usuario( this.value)"/>
			<img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_user_ok" width="13" height="12" id="img_user_ok" longdesc="Usuario aceptado" style="display:none" />
			<img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_user_mal" width="13" height="12" id="img_user_mal" longdesc="Usuario rechazado" />
			</div></td>
      </tr>
      <tr>
      	<td>
        Reglas para la creación del Usuario.
        </td>
      </tr>
      <tr>
      	<td colspan="2">
         <cfif ArrayLen(reglas.erruser)>
        <ul>
        <li><cfoutput>#ArrayToList( reglas.erruser, '</li><li>')#</cfoutput></li>
        </ul>
        </cfif>
        </td>
      </tr>
      
      <tr valign="top">
          <td colspan="2" class="t"><p>Si ya posee una cuenta activa que desea utilizar,
                haga clic <a href="signup_j1.cfm">aqu&iacute;</a>.</p></td>
      </tr>
      <tr> 
        <td colspan="2" align="center"><p> 
            <input type="button" value="Cancelar" onClick="self.location.href='../public/logout.cfm'" />
            <input type="submit" value="Continuar &gt; " id="continuar" disabled="disabled"  />
          </p></td>
      </tr>
    </table>
  </form></center>


<script type="text/javascript">
<!--
	document.f.logintext.focus();

	function obid(s) {
		return document.all ? document.all[s] : document.getElementById(s);
	}
	function valid_usuario(u ) {
		var valida = validarPassword(u, '');
		obid('img_user_ok').style.display = !valida.erruser.length ? '' : 'none';
		obid('img_user_mal').style.display = valida.erruser.length ? '' : 'none';
		if(valida.erruser.length==0){
			f.continuar.disabled="";
		}
		else{
			f.continuar.disabled="disabled";
		}
	}
	function fnhabilita(value){
		if(value!=""){
			f.continuar.disabled="";
		}
		else{
			f.continuar.disabled="disabled";
		}
	}
			
//-->
</script>

</cf_templatearea>
</cf_template>
