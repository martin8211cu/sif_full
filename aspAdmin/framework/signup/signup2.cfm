<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html >
<head><title>MiGesti&oacute;n</title>
<link href="login.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<script type="text/javascript" language="JavaScript" src="signup2.js">//</script>
</head>
<body>
<center><table border="0" width="585" cellspacing="0" cellpadding="0">
<tr>
      <td width="1%"><a href="/"><img src="login-migestion.gif" alt="MiGestion" border="0" /></a></td>
      <td><table border="0" cellspacing="0" cellpadding="0" width="100%"><tr>
            <td align="right" valign="bottom" class="e"><a href="signon-ayuda.cfm">Ayuda</a> 
              - <a href="../../logout/logout.cfm">Iniciar 
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
      <td colspan="2">Bienvenido,<cfoutput>#session.logoninfo.Pnombre#</cfoutput> </td>
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
	  	<cfelseif IsDefined("url.error") AND url.error EQ 3>
	    </cfif></td>
    </tr>
      <tr> 
        <td height="30" rowspan="2" valign="top" class="t"> <p>Seleccione un
                nombre de usuario:</p></td>
        <td valign="top" class="e"> 
			<cfscript>
				s = ListToArray( LCase( session.logoninfo.Pnombre ), " ");
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
			<cfquery datasource="sdc" name="repetidos">
				select Usulogin
				from Usuario
				where Usulogin in (''
					<cfloop from="1" to="#ArrayLen(set)#" index="i">,<cfqueryparam
						cfsqltype="cf_sql_varchar" value="#set[i]#"></cfloop>)
				  and (Usucodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				    or Ulocalizacion != <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">) 
			</cfquery>
			<cfset reps = ValueList(repetidos.Usulogin)>
			<select name="login" onChange="document.f.logintext.value = this.value;document.f.logintext.style.visibility=this.value==''?'visible':'hidden';" >
				<cfloop from="1" to="#ArrayLen(set)#" index="i">
					<cfoutput>
						<cfif i EQ 1 OR set[i] NEQ set[i-1] and ListFind(reps, set[i]) EQ 0>
							<option value="#set[i]#">#set[i]#</option>
						</cfif>
					</cfoutput>
				</cfloop>
				<option value="" selected>Especificar...</option>
			</select>
        </td>
      </tr>
      <tr>
          <td valign="top" class="e"><input type="text" name="logintext" value="" size="30" onFocus="this.select()" /></td>
      </tr>
      <tr valign="top">
          <td colspan="2" class="t"><p>Si ya posee una cuenta activa que desea utilizar,
                haga clic <a href="signup_j1.cfm">aqu&iacute;</a>.</p></td>
      </tr>
      <tr> 
        <td colspan="2" align="center"><p> 
            <input type="button" value="Cancelar" onClick="self.location.href='../../logout/logout.cfm'" />
            <input type="submit" value="Continuar &gt; " />
          </p></td>
      </tr>
    </table>
  </form></center>
		<script type="text/javascript">
		<!--
			document.f.logintext.focus();
		//-->
		</script>
</body>
</html>
