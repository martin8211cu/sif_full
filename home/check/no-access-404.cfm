<cfsetting enablecfoutputonly="no">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>No autorizado</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<style type="text/css">
body {
	padding:10px;
}
</style>
<script type="text/javascript">
<!--


function showHide( targetName, imgObjName ) {
    var target;
    var imgObj;
    if( imgObjName ) { 
        imgObj = eval("document." + imgObjName); 
    }
    
    if( document.getElementById ) { // NS6+
        target = document.getElementById(targetName);
    } else if( document.all ) { // IE4+
        target = document.all[targetName];
    }
    if( target ) {
        if( target.style.display == "none" ) {
            target.style.display = "block";
        } else {
            target.style.display = "none";
        }
    }
    if( imgObj ) {
        var imgPath = imgObj.src;
        if( imgPath ) {
            imgPath = imgPath.substring(0,imgPath.lastIndexOf("/")) + "/";
            if( imgObj.src == imgPath + "close.gif" ) {
                imgObj.src = imgPath + "open.gif";
            } else {
                imgObj.src = imgPath + "close.gif";
            }
        }
    }
} // showHide
//-->
</script>
</head>
<body>
<cfoutput>
  <div style="font-size:16px;font-family:Verdana, Arial, Helvetica, sans-serif; font-weight:bold">No autorizado</div>
  No est&aacute; autorizado a ver este contenido.<br>
  #HTMLEditFormat(cgi.SCRIPT_NAME)#<br>
  Por favor comun&iacute;quese con el administrador de seguridad para verificar esta situaci&oacute;n.<br>
  <br>
</cfoutput>
<cfif IsDefined('Request.RestriccionAccesoRemoto')>
  <hr>
  <div style="font-size:16px;font-family:Verdana, Arial, Helvetica, sans-serif; font-weight:bold">
    <cfif Request.PoliticasEmpresariales.auth.validar.horario is 1 And Request.PoliticasEmpresariales.auth.validar.ip is 1>
      Acceso fuera del horario y direcciones permitidos
      <cfelseif Request.PoliticasEmpresariales.auth.validar.horario is 1>
      Acceso fuera del horario permitidos
      <cfelseif Request.PoliticasEmpresariales.auth.validar.ip is 1>
      Acceso fuera las direcciones permitidas
    </cfif>
  </div>
  <p>Ha intentado acceder una funci&oacute;n de sistema para la que no est&aacute; autorizado
	<cfoutput><br>
    Su direcci&oacute;n IP es #session.sitio.ip#, y la hora del
		acceso es #TimeFormat(Now(), 'HH:mm')#, #DateFormat(Now(), 'ddd dd mmm yyyy')# 
		</cfoutput>
	</p>
  <cfquery datasource="asp" name="acceso_valido">
		select distinct ar.acceso, a.ARnombre, ar.SScodigo, ar.SRcodigo
		from UsuarioRol ur
			join SProcesosRol pr
				on ur.SScodigo = pr.SScodigo
				and ur.SRcodigo = pr.SRcodigo
			join AccesoRol ar
				on ar.SScodigo = pr.SScodigo
				and ar.SRcodigo = pr.SRcodigo
			join AccesoRemoto a
				on a.acceso = ar.acceso
			<cfif Request.PoliticasEmpresariales.auth.validar.ip is 1>
				left join AccesoIP ai
					on ai.acceso = ar.acceso
			</cfif>
			<cfif Request.PoliticasEmpresariales.auth.validar.horario is 1>
				left join AccesoHorario ah
					on ah.acceso = ar.acceso
			</cfif>
		where ur.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and pr.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Request.RestriccionAccesoRemoto.SScodigo#">
		  and pr.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Request.RestriccionAccesoRemoto.SMcodigo#">
		  and pr.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Request.RestriccionAccesoRemoto.SPcodigo#">
		order by a.ARnombre
	</cfquery>
	<cfif Request.PoliticasEmpresariales.auth.validar.horario is 1>
	  <table border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td><img name="img_perfiles" src="/cfmx/CFIDE/debug/images/open.gif" alt="" 
			onclick="showHide('div_perfiles', this.name);" border="0" height="9" hspace="4" vspace="4" width="9"> </td>
		<td><a href="javascript:showHide('div_perfiles', 'img_perfiles')"> Consultar los horarios de acceso</a></td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td><div id="div_perfiles" style="display:none;">
			<cfset linea = 0>
			<cfloop query="acceso_valido">
			  <table border="0" cellpadding="0" cellspacing="0">
			  <tr>
				  <td><cfoutput> <img name="img_acceso#acceso#" src="/cfmx/CFIDE/debug/images/open.gif" alt="" 
				onclick="showHide('div_acceso#acceso#', this.name);" border="0" height="9" hspace="4" vspace="4" width="9"> </cfoutput> </td>
				  <td><cfoutput><a href="javascript:showHide('div_acceso#acceso#', 'img_acceso#acceso#')"> 
				  <strong>#  HTMLEditFormat( ARnombre ) #</strong>, Grupo #HTMLEditFormat(Trim(SScodigo))#.#HTMLEditFormat(Trim(SRcodigo))#</a> 
				  </cfoutput></td>
				</tr>
			  <tr>
				  <td></td>
				  <td><div id="<cfoutput>div_acceso#acceso#</cfoutput>" style="display:none;">
					<table border="0" cellpadding="0" cellspacing="0">
					  <tr>
						<cfif Request.PoliticasEmpresariales.auth.validar.horario is 1>
						  <td valign="top">
						  
							<cfquery datasource="asp" name="dias">
								select dia,desde,hasta from AccesoHorario
								where acceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#acceso_valido.acceso#">
							</cfquery>
						  <table border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray">
							  <tr>
								<td colspan="2" class="tituloListas">Horario:</td>
							  </tr>
							<cfoutput query="dias" group="dia"> 
							  <tr class="#ListGetAt('listaPar,listaNon',CurrentRow mod 2+1)#">
								<td valign="top">#ListGetAt('Dom,Lun,Mar,Mié,Jue,Vie,Sáb',dia)#</td>
								<td valign="top"><cfoutput> 
								#Left(desde,2)#:#Right(desde,2)#-#Left(hasta,2)#:#Right(hasta,2)# <br> </cfoutput> </td>
							  </tr></cfoutput> 
							</table>
								 
							</td>
						</cfif><!---
						<cfif Request.PoliticasEmpresariales.auth.validar.ip is 1>
						  <td valign="top">
							<cfquery datasource="asp" name="ips">
								select ipdesde,iphasta from AccesoIP
								where acceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#acceso_valido.acceso#">
							</cfquery>
							<table border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray"><tr>
								<td class="tituloListas">Direcciones:</td>
							  </tr>
								<cfoutput query="ips">
							  <tr class="#ListGetAt('listaPar,listaNon',CurrentRow mod 2+1)#">
								<td># HTMLEditFormat(ipdesde) #
								  <cfif ipdesde neq iphasta>
									- # HTMLEditFormat(iphasta) #
								  </cfif></td>
							  </tr>
								</cfoutput> 
							</table>
						</td>
						</cfif>--->
					  </tr>
					</table></div></td>
				</tr>
			  </table>
			</cfloop>
		  </div></td>
	  </tr>
	  </table></cfif>
</cfif>
<a href="javascript:history.back()" >Regresar</a>
<hr>
<cfif acceso_uri('/home/check/no-access-add.cfm')>
  <cfset defaultSS = Trim(session.monitoreo.SScodigo)>
  <cfset defaultSM = Trim(session.monitoreo.SMcodigo)>
  <cfset defaultSP = Trim(session.monitoreo.SPcodigo)>
  <cfif IsDefined("session.menues.SScodigo") and len(session.menues.SScodigo) Neq 0>
    <cfset defaultSS = Trim(session.menues.SScodigo)>
  </cfif>
  <cfif IsDefined("session.menues.SMcodigo") and len(session.menues.SMcodigo) Neq 0>
    <cfset defaultSM = Trim(session.menues.SMcodigo)>
  </cfif>
  <cfif IsDefined("session.menues.SPcodigo") and len(session.menues.SPcodigo) Neq 0>
    <cfset defaultSP = Trim(session.menues.SPcodigo)>
  </cfif>
  <cfquery datasource="asp" name="procs">
		select s.SScodigo, s.SSdescripcion,
			m.SMcodigo, m.SMdescripcion,
			p.SPcodigo, p.SPdescripcion
		from SSistemas s, SModulos m, SProcesos p
		where m.SScodigo = s.SScodigo
		  and p.SScodigo = m.SScodigo
		  and p.SMcodigo = m.SMcodigo
		order by s.SSdescripcion, s.SScodigo,
			m.SMdescripcion, m.SMcodigo,
			p.SPdescripcion, p.SPcodigo
	</cfquery>
  <cfset SCuri = Replace(cgi.SCRIPT_NAME,'/cfmx','')>
  <cfquery datasource="asp" name="mycomps">
		select *
		from SComponentes
		where SCuri = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SCuri#">
	</cfquery>
  <cfquery datasource="asp" name="myroles">
		select sr.SScodigo, sr.SRcodigo, sr.SRdescripcion
		from UsuarioRol ur
			join SRoles sr
				on ur.SScodigo = sr.SScodigo
				and ur.SRcodigo = sr.SRcodigo
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
  <cfquery datasource="asp" name="requiredroles">
		select sr.SScodigo, sr.SRcodigo, sr.SRdescripcion
		from SComponentes a
			join SProcesosRol b
				on b.SScodigo = a.SScodigo
				and b.SMcodigo = a.SMcodigo
				and b.SPcodigo = a.SPcodigo
			join SRoles sr
				on b.SScodigo = sr.SScodigo
				and b.SRcodigo = sr.SRcodigo
		where a.SCuri = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SCuri#">
	</cfquery>
  <cfoutput>
    <script type="text/javascript">
<!--
siss = new Object();
</cfoutput><cfoutput query="procs" group="SScodigo">
sis = new Object();
mods = new Object();
<cfoutput group="SMcodigo">
mod = new Object();
mod.code = '#JSStringFormat(Trim(SMcodigo))#';
mod.desc = '#JSStringFormat(Trim(SMdescripcion))#';
pros = new Object();
<cfoutput>
pro = new Object();
pro.code = '#JSStringFormat(Trim(SPcodigo))#';
pro.desc = '#JSStringFormat(Trim(SPdescripcion))#';
pros['#JSStringFormat(Trim(SPcodigo))#'] = pro;
</cfoutput>
mod.pros = pros;
mods['#JSStringFormat(Trim(SMcodigo))#'] = mod;
</cfoutput>
sis.mods = mods;
siss['#JSStringFormat(Trim(SScodigo))#'] = sis;
</cfoutput><cfoutput>
	function SSchange(SScodigo,SMselect){
		while (SMselect.options.length != 0) {
			SMselect.remove(0);
		}
		var thmods = siss[SScodigo].mods;
		window.status = SScodigo;
		var sel = null;
		for (i in thmods) {
			var opt = document.createElement("option");
			opt.value = thmods[i].code;
			opt.text  = thmods[i].desc + ' (' + thmods[i].code + ')';
			if (sel == null) {
				sel = thmods[i].code;
				opt.selected = true;
			}
			if (document.all) {
				SMselect.add(opt);
			} else {
				SMselect.add(opt,null);
			}
		}
		SMchange(SScodigo, sel, SMselect.form.SPcodigo);
	}
	function SMchange(SScodigo,SMcodigo,SPselect){
		while (SPselect.options.length != 0) {
			SPselect.remove(0);
		}
		var thpros = siss[SScodigo].mods[SMcodigo].pros;
		window.status = SScodigo;
		for (i in thpros) {
			var opt = document.createElement("option");
			opt.value = thpros[i].code;
			opt.text  = thpros[i].desc + ' (' + thpros[i].code + ')';
			if (document.all) {
				SPselect.add(opt);
			} else {
				SPselect.add(opt,null);
			}
		}
	}


	</script>
    <form action="/cfmx/home/check/no-access-add.cfm" method="post" target="mystatus" style="margin:0 ">
    <div style="font-size:16px;font-family:Verdana, Arial, Helvetica, sans-serif; font-weight:bold">Definir acceso a p&aacute;gina </div>
    <table width="700"  border="0" cellpadding="0" cellspacing="1">
    <tr>
      <td width="15" class="text1">&nbsp;</td>
      <td width="125">&nbsp;</td>
      <td colspan="2" >&nbsp;</td>
    </tr>
    <tr>
      <td class="text1">&nbsp;</td>
      <td colspan="3" style="font-size:12px;font-family:Arial, Helvetica, sans-serif;">Usted ha sido autorizado a definir accesos a las p&aacute;ginas que no cuenten con una definici&oacute;n de permisos. Por favor verifique que la p&aacute;gina que se muestra a continuaci&oacute;n concuerde con el sistema, m&oacute;dulo y proceso especificados. </td>
    </tr>
    <tr>
      <td class="text1">&nbsp;</td>
      <td><label for="SCuri">P&aacute;gina</label></td>
      <td colspan="2" class="text1"><cfoutput>
          <input name="SCuri" type="hidden" id="SCuri" value="#HTMLEditFormat(Replace(cgi.SCRIPT_NAME,'/cfmx',''))#" size="40" maxlength="10">
          #HTMLEditFormat(SCuri)#</cfoutput></td>
    </tr>
    <tr>
      <td class="text1">&nbsp;</td>
      <td class="text1">&nbsp;</td>
      <td colspan="2"><label>Procesos asociados a esta p&aacute;gina:</label></td>
    </tr>
    <tr>
      <td class="text1">&nbsp;</td>
      <td class="text1">&nbsp;</td>
      <td class="text1">&nbsp;</td>
      <td class="text1"><cfloop query="mycomps">
          #Trim(mycomps.SScodigo)#.#Trim(mycomps.SMcodigo)#.#Trim(mycomps.SPcodigo)#<br>
        </cfloop>
        <cfif mycomps.RecordCount is 0>
          Ninguno
        </cfif>
      </td>
    </tr>
    <tr>
      <td class="text1">&nbsp;</td>
      <td class="text1">&nbsp;</td>
      <td colspan="2"><label>Grupos activos en esta sesi&oacute;n:</label></td>
    </tr>
    <tr>
      <td class="text1">&nbsp;</td>
      <td class="text1">&nbsp;</td>
      <td width="28" class="text1">&nbsp;</td>
      <td width="532" class="text1"><div style="overflow:auto;height:100px;width:530px;border:1px solid gray">
          <cfloop query="myroles">
            <cfif myroles.CurrentRow gt 1>
              ,
            </cfif>
            <span style="text-decoration:none;cursor:pointer" onMouseOver="this.style.backgroundColor='##cdf'" onMouseOut="this.style.backgroundColor='##fff'" title="#HTMLEditFormat(myroles.SRdescripcion)#"> #Trim(myroles.SScodigo)#.#Trim(myroles.SRcodigo)#</span>
          </cfloop>
          <cfif myroles.RecordCount is 0>
            Ninguno
          </cfif>
        </div></td>
    </tr>
    <tr>
      <td class="text1">&nbsp;</td>
      <td class="text1">&nbsp;</td>
      <td colspan="2"><label>Grupos con acceso a esta p&aacute;gina:</label></td>
    </tr>
    <tr>
      <td class="text1">&nbsp;</td>
      <td class="text1">&nbsp;</td>
      <td class="text1">&nbsp;</td>
      <td class="text1"><cfloop query="requiredroles">
          <cfif requiredroles.CurrentRow gt 1>
            ,
          </cfif>
          <span style="text-decoration:none;cursor:pointer" onMouseOver="this.style.backgroundColor='##cdf'" onMouseOut="this.style.backgroundColor='##fff'" title="#HTMLEditFormat(requiredroles.SRdescripcion)#"> #Trim(requiredroles.SScodigo)#.#Trim(requiredroles.SRcodigo)#</span>
        </cfloop>
        <cfif requiredroles.RecordCount is 0>
          No hay grupos que tengan acceso a esta p&aacute;gina
        </cfif>
      </td>
    </tr>
    <tr>
    <td class="text1">&nbsp;</td>
    <td><label for="SScodigo">Sistema</label></td>
    <td colspan="2">
    <select name="SScodigo" class="text1" id="SScodigo" onChange="SSchange(this.value,form.SMcodigo)">
  </cfoutput><cfoutput query="procs" group="SScodigo">
    <option value="#HTMLEditFormat(Trim(SScodigo))#" <cfif Trim(procs.SScodigo) is defaultSS>selected</cfif>  >#HTMLEditFormat(SSdescripcion)#</option>
  </cfoutput><cfoutput>
    </select>
    </td>
    </tr>
    <tr>
    <td class="text1">&nbsp;</td>
    <td><label for="SMcodigo">M&oacute;dulo</label></td>
    <td colspan="2" class="text1">
    <select class="text1" name="SMcodigo" id="SMcodigo" onChange="SMchange(form.SScodigo.value,this.value,form.SPcodigo)">
  </cfoutput><cfoutput query="procs" group="SScodigo">
    <cfif Trim(procs.SScodigo) is defaultSS>
      <cfoutput group="SMcodigo">
        <option value="#HTMLEditFormat(Trim(SMcodigo))#" <cfif Trim(procs.SMcodigo) is defaultSM>selected</cfif>  >#HTMLEditFormat(SMdescripcion)#</option>
      </cfoutput>
    </cfif>
  </cfoutput><cfoutput>
    </select>
    </td>
    </tr>
    <tr>
    <td class="text1">&nbsp;</td>
    <td><label for="SPcodigo">Proceso</label></td>
    <td colspan="2" class="text1">
    <select class="text1" name="SPcodigo" id="SPcodigo">
  </cfoutput> <cfoutput query="procs" group="SScodigo">
    <cfif Trim(procs.SScodigo) is defaultSS>
      <cfoutput group="SMcodigo">
        <cfif Trim(procs.SMcodigo) is defaultSM>
          <cfoutput>
            <option value="#HTMLEditFormat(Trim(SPcodigo))#" <cfif Trim(procs.SPcodigo) is defaultSP>selected</cfif>  >#HTMLEditFormat(SPdescripcion)#</option>
          </cfoutput>
        </cfif>
      </cfoutput>
    </cfif>
  </cfoutput> <cfoutput>
    </select>
    </td>
    </tr>
    <tr>
      <td class="text1">&nbsp;</td>
      <td><label for="autoriza">Usuario que autoriza</label></td>
      <td colspan="2"><input name="autoriza" type="text" class="text1" id="autoriza" value="#session.Usuario#" size="10" maxlength="10" readonly></td>
    </tr>
    <tr>
      <td class="text1">&nbsp;</td>
      <td class="text1">&nbsp;</td>
      <td colspan="2" class="text1"><input type="checkbox" name="actualizar" id="actualizar" checked>
        <label for="actualizar">Continuar trabajando</label></td>
    </tr>
    <tr>
      <td colspan="4"><input name="Submit" type="submit" class="text1" value="Permitir acceso"></td>
    </tr>
    </table>
    </form>
    Status:<br>
    <iframe name="mystatus" id="mystatus" src="about:blank" width="700" height="100"></iframe>
    <br>
  </cfoutput>
</cfif>
<cfoutput>
</body>
</html>
</cfoutput>