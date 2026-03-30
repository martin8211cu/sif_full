<cf_templateheader title="Monitor de interfaces">
<cf_web_portlet_start titulo="Mensajes de interfaces">
<cfparam name="url.IBid" default="">
<cfquery datasource="#session.dsn#" name="ISBinterfazBitacora">
	select
		b.IBid,
		b.BMUsucodigo, b.BMUsulogin,
		b.interfaz, i.nombreInterfaz,
		b.S02CON, b.origen, b.args, b.args_text,
		b.ip, b.fecha,
		b.asunto,
		b.resuelto_fecha, b.resuelto_por, b.resuelto_login,
		i.severidad_reenvio
	from ISBinterfazBitacora b
		left join ISBinterfaz i
			on i.interfaz = b.interfaz
	where b.IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IBid#" null="#Len(url.IBid) Is 0#">
	</cfquery>
	
	<cfif Len(ISBinterfazBitacora.S02CON) and ISBinterfazBitacora.S02CON NEQ 0>
		<cfinvoke component="saci.ws.intf.SSXS02" method="getTarea"
			S02CON="#ISBinterfazBitacora.S02CON#" returnvariable="SSXS02" />
	</cfif>
<cfquery datasource="#session.dsn#" name="ISBinterfazDetalle">
	select
		b.IBlinea,
		b.codMensaje, m.mensaje, 
			case 
				when m.severidad = 0 then 'info'
				when m.severidad = -10 then 'debug'
				when m.severidad = 10 then 'warning'
				when m.severidad = 20 then 'error'
			end as sevicon,
		b.BMUsucodigo, b.BMUsulogin,
		b.errorid, m.severidad,
		b.servicio, b.msg, b.fecha
	from ISBinterfazDetalle b
		left join ISBinterfazMensaje m
			on m.codMensaje = b.codMensaje
	where b.IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IBid#" null="#Len(url.IBid) Is 0#">
	order by IBlinea desc
	</cfquery>

<cfoutput>

<form action="ISBinterfazBitacora-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
	<table align="center" width="812" cellpadding="1" cellspacing="0" border="0">
	<tr>
	  <td width="15"></td>
	  <td colspan="4"></td>
	  </tr>
	<tr>
	  <td colspan="5" class="formButtons">
	      <input type="button" name="Regresar" class="btnAnterior" value="Regresar"
			 onclick="location.href='ISBinterfazBitacora-lista.cfm';" tabindex="1" />
	    <cfset onclick = "">
		<cfif Len(ISBinterfazDetalle.severidad) and ISBinterfazDetalle.severidad LE 0>
			<cfset onclick="return confirm(&quot;&iquest;Desea reenviar la interfaz? La &uacute;ltima vez que se ejecut&oacute; no dio error.&quot;)">
		</cfif>
		  <cfif Len(ISBinterfazBitacora.resuelto_fecha) is 0>
		    <input name="btnResolver" type="submit" class="btnAplicar" 
		  	value='Marcar resuelto' />
			<cfif ISBinterfazBitacora.severidad_reenvio LE ISBinterfazDetalle.severidad>
				<input name="btnReenviar" type="submit" class="btnPublicar" 
					onclick="#onclick#" value='Reintentar ahora' />
			</cfif>
		  </cfif>
		  <cfif Len(ISBinterfazBitacora.S02CON) and ISBinterfazBitacora.S02CON NEQ 0>
		<input name="btnSSXS02" type="submit" class="btnPublicar" 
			onclick="#onclick#"
		  	value='Reenviar a SSXS02' /></cfif>		  </td>
	  </tr>
	<tr onclick="showHide('imgcall','divcall')" style="cursor:pointer">
	  <td valign="middle" class="subTitulo"><img src="arrow_d.gif" alt="Mostrar/Ocultar" width="7" height="7" border="0" id="imgcall" /></td>
      <td colspan="4" valign="middle" class="subTitulo">&nbsp;Interfaz #HTMLEditFormat(ISBinterfazBitacora.interfaz)#
        #HTMLEditFormat(ISBinterfazBitacora.nombreInterfaz)# </td>
	  </tr>
	<tr>
	  <td colspan="5" valign="top"><table border="0" cellspacing="0" cellpadding="0" id="divcall" width="790">
            <tr>
              <td width="340" valign="top"><table border="0" cellspacing="0" cellpadding="2" width="340">
                  <tr>
                    <td width="151" valign="top">Servicio</td>
                    <td width="181" valign="top"><cfif Len(ISBinterfazDetalle.servicio)>
                      #HTMLEditFormat(ISBinterfazDetalle.servicio)#
                      <cfelse>
                      N.D.
                    </cfif></td>
                  </tr>
                  <tr>
                    <td valign="top">Origen</td>
                    <td valign="top"> #HTMLEditFormat(ISBinterfazBitacora.origen)#</td>
                  </tr>
				  <cfif Len(ISBinterfazBitacora.S02CON) and ISBinterfazBitacora.S02CON neq 0><tr>
                    <td valign="top"> &nbsp; &nbsp; &nbsp; S02CON</td>
                    <td valign="top"> #HTMLEditFormat(ISBinterfazBitacora.S02CON)#</td>
                  </tr><tr>
                    <td valign="top"> &nbsp; &nbsp; &nbsp; S02ACC</td>
                    <td valign="top"> #HTMLEditFormat(SSXS02.S02ACC)#</td>
                  </tr><tr>
                    <td valign="top"> &nbsp; &nbsp; &nbsp; S02VA1</td>
                    <td valign="top"> #HTMLEditFormat(Replace(SSXS02.S02VA1, '*', '* ', 'all'))#</td>
                  </tr><tr>
                    <td valign="top"> &nbsp; &nbsp; &nbsp; S02VA2</td>
                    <td valign="top"> #HTMLEditFormat(SSXS02.S02VA2)#</td>
                  </tr></cfif>
                  <tr>
                    <td>Asunto</td>
                    <td>#HTMLEditFormat(ISBinterfazBitacora.asunto)#</td>
                  </tr>
                  <tr>
                    <td valign="top">Usuario que ejecuta </td>
                    <td valign="top">#HTMLEditFormat(ISBinterfazBitacora.BMUsulogin)# - #HTMLEditFormat(ISBinterfazBitacora.BMUsucodigo)#</td>
                  </tr>
                  <tr>
                    <td valign="top">IP de usuario </td>
                    <td valign="top">#HTMLEditFormat(ISBinterfazBitacora.ip)# </td>
                  </tr>
                  <tr>
                    <td valign="top">Fecha de invocación </td>
                    <td valign="top"> #DateFormat(ISBinterfazBitacora.fecha,'dd/mm/yyyy')#
                    #TimeFormat(ISBinterfazBitacora.fecha,'HH:mm:ss')# </td>
                  </tr>
                  
                  <tr>
                    <td valign="top" class="subTitulo">Resuelto por</td>
                    <td valign="top"><cfif Not Len(ISBinterfazBitacora.resuelto_por) And Not Len(ISBinterfazBitacora.resuelto_login)>
                      (aún no)
                    </cfif>
                      #HTMLEditFormat(ISBinterfazBitacora.resuelto_login)#
  <cfif Len(ISBinterfazBitacora.resuelto_login)>
    -
  </cfif>
                      #HTMLEditFormat(ISBinterfazBitacora.resuelto_por)#</td>
                  </tr>
                  
                  <tr>
                    <td valign="top">&nbsp;</td>
                    <td valign="top">#DateFormat(ISBinterfazBitacora.resuelto_fecha,'dd/mm/yyyy')#
                      #TimeFormat(ISBinterfazBitacora.resuelto_fecha,'HH:mm:ss')# </td>
                  </tr>
              </table></td>
              <td width="40" valign="top">&nbsp;</td>
              <td width="410" align="left" valign="top">
			  
			  <div class="subTitulo" onclick="showHide('imgargs','divargs')" style="cursor:pointer;width:400px">
<img src="arrow_d.gif" alt="Mostrar/Ocultar" width="7" height="7" border="0" id="imgargs" />
Argumentos de la invocaci&oacute;n</div>

                <table width="400" cellpadding="2" cellspacing="0" id="divargs" style="">
                  <tr class="tituloListas">
                    <td width="120"><strong>Par&aacute;metro</strong></td>
                    <td width="276"><strong>Valor</strong></td>
                  </tr>
                  <cfset n = 0>
				  <cfif Len(ISBinterfazBitacora.args_text)>
				  	<cfset args_real = ISBinterfazBitacora.args_text>
				<cfelse>
				  	<cfset args_real = ISBinterfazBitacora.args>
				  </cfif>
                  <cfloop list="#args_real#" index="pair">
                    <cfset n=n+1>
					<cfset argname = ListFirst(pair, '=')>
					<cfset argvalue = URLDecode( ListRest(pair, '=') )>
					<cfset arglargo = Len(argvalue) GT 50>
                    <tr class="lista#ListGetAt('Par,Non', 1+(n mod 2))#">
                      <td valign="top" onclick="<cfif arglargo>showHide2('imgarg_#argname#','divarg_#argname#')</cfif>" style="<cfif arglargo>cursor:pointer</cfif>">
					  <cfif arglargo>
					  <img src="arrow_r.gif" alt="Mostrar/Ocultar" width="7" height="7" border="0" id="imgarg_#argname#" />
					  </cfif>
					  # URLDecode( argname )#</td>
                      <td><cfif FindNoCase('clave', argname ) Or FindNoCase('pwd', argname ) Or FindNoCase('pass', argname )>
                          *********
                          <cfelse>
						  <div style="width:259px;<cfif arglargo>overflow:hidden;height:30px;border:1px solid gray</cfif>" id="divarg_#argname#">
                          # HTMLEditFormat( argvalue )#</div>
                      </cfif></td>
                    </tr>
                  </cfloop>
              </table>			  </td>
            </tr>
            </table></td>
      </tr>
	
	<tr>
	  <td >&nbsp;</td>
	  <td width="49" >&nbsp;</td>
	  <td >&nbsp;</td>
	  <td >&nbsp;</td>
	  <td >&nbsp;</td>
	  </tr>
<cfloop query="ISBinterfazDetalle">
	<tr onclick="showHide('imgdet#ISBinterfazDetalle.IBlinea#','divdet#ISBinterfazDetalle.IBlinea#')" style="cursor:pointer"
	onmouseover="this.className='listaParSel'"
	onmouseout="this.className='listaPar'"
	class="listaPar">
	  <td valign="middle" class="subTitulo"><img src="<cfif CurrentRow is 1>arrow_d.gif<cfelse>arrow_r.gif</cfif>" alt="Mostrar/Ocultar"
	   width="7" height="7" border="0" id="imgdet#ISBinterfazDetalle.IBlinea#" /></td>
      <td valign="middle" class="subTitulo">&nbsp; #RecordCount - CurrentRow + 1#.		  </td>
	  <td width="111" valign="middle" class="subTitulo"><img align="top" src="#LCase(sevicon)#16.png" width="16" height="16" border="0" /> #HTMLEditFormat(ISBinterfazDetalle.codMensaje)#</td>
	  <td width="419" valign="middle" class="subTitulo">#HTMLEditFormat(ISBinterfazDetalle.mensaje)#</td>
	  <td width="208" valign="middle" class="subTitulo">#DateFormat(ISBinterfazDetalle.fecha,'dd/mm/yyyy')#
		  #TimeFormat(ISBinterfazDetalle.fecha,'HH:mm:ss')#</td>
	</tr>
	<tr>
	  <td valign="top"></td>
      <td colspan="4" valign="top">
	  <div id="divdet#ISBinterfazDetalle.IBlinea#" style="margin:4px;display:<cfif CurrentRow is 1>block<cfelse>none</cfif>;">
	  <cfif Len(ISBinterfazDetalle.errorid)>
	  <div class="errormsg">
	  Ocasionado por el reporte de error número #HTMLEditFormat( REReplace( ISBinterfazDetalle.errorid, "([0-9]{3})([0-9])", "\1-\2", "all" ) )#</div>
	  </cfif>
	  #HTMLEditFormat(ISBinterfazDetalle.msg)#
	  
	  <cfif Len(ISBinterfazDetalle.errorid)>
			<cfquery datasource="aspmonitor" name="MonErrores">
				select detalle_extra from MonErrores
				where errorid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBinterfazDetalle.errorid#">
			</cfquery>
	  	<table border="0" cellpadding="2" cellspacing="0">
				<tr onclick="showHide('imgerr#ISBinterfazDetalle.IBlinea#','diverr#ISBinterfazDetalle.IBlinea#')" style="cursor:pointer">
					<td width="762" colspan="2" valign="middle" class="subTitulo"><img src="arrow_r.gif" alt="Mostrar/Ocultar" name="imgerr#ISBinterfazDetalle.IBlinea#"
					 width="7" height="7" border="0" id="imgerr#ISBinterfazDetalle.IBlinea#" />&nbsp;Detalle de error n&uacute;mero
					 	 # HTMLEditFormat( REReplace( ISBinterfazDetalle.errorid, "([0-9]{3})([0-9])", "\1-\2", "all" ) )# en el portal </td>
				</tr>
				<tr><td valign="middle" colspan="2"><div style="width:720px;height:200px;display:none;overflow:auto;border:1px solid black;" id="diverr#ISBinterfazDetalle.IBlinea#">
				#MonErrores.detalle_extra#</div></td>
				</tr></table>
		</cfif></div></td>
	  </tr></cfloop>
		
		<tr>
		  <td colspan="5" valign="top">&nbsp;</td>
	    </tr>
	</table>
			<input type="hidden" name="IBid" value="#HTMLEditFormat(ISBinterfazBitacora.IBid)#">
</form>

</cfoutput>
<script type="text/javascript">
function showHide(imgid, divid) {
	var imgobj = document.getElementById ? document.getElementById(imgid) : document.all[imgid];
	var divobj = document.getElementById ? document.getElementById(divid) : document.all[divid];
	if (divobj.style.display == 'none') {
		imgobj.src = 'arrow_d.gif';
		divobj.style.display = 'block';
	} else {
		imgobj.src = 'arrow_r.gif';
		divobj.style.display = 'none';
	}
}
function showHide2(imgid, divid) {
	var imgobj = document.getElementById ? document.getElementById(imgid) : document.all[imgid];
	var divobj = document.getElementById ? document.getElementById(divid) : document.all[divid];
	if (divobj.style.height == '30px') {
		imgobj.src = 'arrow_d.gif';
		divobj.style.height = '';
	} else {
		imgobj.src = 'arrow_r.gif';
		divobj.style.height = '30px';
	}
}
</script>
<!---
	esto es para que el scroll aparezca siempre
	y no se descuajiringue cuando se muestren/oculten
	secciones con showHide()
--->
<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
<cf_web_portlet_end>
<cf_templatefooter>