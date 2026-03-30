<cfsetting enablecfoutputonly="yes">
<cfquery name="header__rsEmpresasU" datasource="asp" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
	select Ecodigo, count(1) as rsEmpresasU_cantidad
	from vUsuarioProcesos up
	where up.Usucodigo = #Session.Usucodigo#
	group by Ecodigo
</cfquery>
<cfset LvarEmpresasUsuario = "">
<cfoutput query="header__rsEmpresasU">
	<cfset LvarEmpresasUsuario=LvarEmpresasUsuario & header__rsEmpresasU.Ecodigo & ",">
</cfoutput>
<cfset LvarEmpresasUsuario = LvarEmpresasUsuario & "-1">
<cfquery name="header__rsEmpresas" datasource="asp" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
	select 
		  e.Enombre
		, e.Ecodigo
		, e.Ereferencia as Ereferencia
		, upper( e.Enombre ) as Enombre_upper
		, ((select min(c.Ccache)
			from Caches c
			where c.Cid = e.Cid
		)) as Ccache
		, e.ts_rversion as ts_rversion
	from Empresa e
	where e.Ecodigo   in (#LvarEmpresasUsuario#)
	  and e.CEcodigo   = #Session.CEcodigo#
	<cfif Len(session.sitio.Ecodigo) and session.sitio.Ecodigo neq 0>
	  and e.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.sitio.Ecodigo#">
	<cfelse>
	  order by e.Enombre
	</cfif>
</cfquery>
<cfsetting enablecfoutputonly="no">
<script type="text/javascript">
function header__empresas(v) {
	var f = document.forms.header__formempresas;
	var a = document.all?document.all.header__aempresas:document.getElementById('header__aempresas');
	f.style.display=v?'inline':'none';
	a.style.display=v?'none':'inline';
}
</script>
<cfset header__rsContents_count = 0>
<table border="0" cellspacing="0" cellpadding="0" width="980" class="iconoTop" align="center">
  <!--DWLayoutTable-->
  <tr>
    <td width="171" rowspan="3" valign="top" class="logoTop"><img src="/cfmx/plantillas/soinasp01/images/spacer.gif" alt="MiGestion.net" width="163" height="71"></td>
    <td width="6" height="41" rowspan="2">&nbsp;</td>
    <td width="46" rowspan="2" valign="bottom" class="iconoSistema"><a href="/cfmx/home/"
			onmouseover="document.getElementById('header__inicio').style.display = 'inline'"
			onmouseout="document.getElementById('header__inicio').style.display = 'none'"
			style="background-image:url(/cfmx/plantillas/soinasp01/images/home.gif);">
			</a></td>
	<cfif IsDefined('session.Usucodigo') And Len(session.Usucodigo) and Session.Usucodigo NEQ 0>
		<cfset Obtieneheader__rsContents()>		
		<cfoutput query="header__rsContents" group="SScodigo">
		<cfset header__rsContents_count = header__rsContents_count + 1>
		<td width="46" rowspan="2" valign="bottom" class="iconoSistema" align="center">
				<a href="/cfmx/home/menu/sistema.cfm?s=#URLEncodedFormat( Trim (SScodigo) )#"
				onmouseover="document.getElementById('header__sist_#CurrentRow#').style.display = 'inline'"
				onmouseout="document.getElementById('header__sist_#CurrentRow#').style.display = 'none'"
				style="background-image:url(/cfmx/plantillas/soinasp01/images/sistemas/#HTMLEditFormat( LCase (SScodigo) )#.gif);">
				</a>
			</td>
		</cfoutput> 
    </cfif>

    <td width="6" rowspan="2">&nbsp;</td>
    <td width="47" rowspan="2">
      <div align="center"><cfloop query="header__rsEmpresas">
        <cfif Ecodigo EQ session.EcodigoSDC>
          <cfinvoke 
					 component="sif.Componentes.DButils"
					 method="toTimeStamp"
					 returnvariable="tsurl" arTimeStamp="#ts_rversion#"> </cfinvoke>
          <cfoutput> <img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&amp;ts=#tsurl#" class="iconoEmpresa" alt="logo" border="0" height="53" /></cfoutput>
        </cfif>
      </cfloop></div></td>
    <td width="272" align="left" valign="middle" nowrap="nowrap" class="iconoUsuario"><cfif IsDefined('session.Usucodigo') And Len(session.Usucodigo) and Session.Usucodigo NEQ 0>
        <cfoutput>
          <cfif (header__rsEmpresas.RecordCount GT 1)>
            <a href="javascript:header__empresas(true)" id="header__aempresas" style="display:none;"> # HTMLEditFormat( REReplace(session.Enombre, '<[^>]+>', '', 'all'))#</a>
            <form style="display:inline;" name="header__formempresas" id="header__formempresas" action="/cfmx/home/menu/index.cfm">
              <select name="seleccionar_EcodigoSDC" onChange="this.form.submit()">
                <cfloop query="header__rsEmpresas">
                  <option value="#Ecodigo#" <cfif Ecodigo EQ session.EcodigoSDC>selected="selected"</cfif>>#HTMLEditFormat( REReplace( Enombre, '<[^>]+>', '', 'all') )#</option>
                </cfloop>
              </select>
              <noscript>
              <input type="submit" value="Ir" class="btnSiguiente">
              </noscript>
            </form>
            <script type="text/javascript">
		  	header__empresas(false);
		  </script>
            <cfelse>
            #HTMLEditFormat(session.enombre)#
          </cfif>
        </cfoutput>
      </cfif></td>
    <td width="7">&nbsp;</td>
    <td width="96"><div align="center"><a href="/cfmx/home/menu/micuenta/"><img src="/cfmx/plantillas/soinasp01/images/Preferences.gif" alt="Preferences" width="27" height="21" border="0"></a></div></td>
    <td width="7">&nbsp;</td>
    <td width="34"><div align="center"><a href="/cfmx/home/public/logout.cfm"><img src="/cfmx/plantillas/soinasp01/images/Logout.gif" alt="Logout" width="27" height="21" border="0"></a></div></td>
    <td width="18">&nbsp;</td>
  </tr>
  <tr>
    <td width="272" align="left" valign="top" rowspan="2" class="iconoUsuario"><cfif IsDefined('session.Usucodigo') And Len(session.Usucodigo) and Session.Usucodigo NEQ 0 and IsDefined('session.datos_personales')>
        <cfoutput>#HTMLEditFormat(session.datos_personales.nombre)# #HTMLEditFormat(session.datos_personales.apellido1)# #HTMLEditFormat(session.datos_personales.apellido2)#</cfoutput>
      </cfif></td>
    <td>&nbsp;</td>
    <td class="iconoPreferencias"><a href="/cfmx/home/menu/micuenta/"><cf_translate key="LB_Preferencias" XmlFile="/sif/plantillas.xml">Preferencias</cf_translate></a></td>
    <td>&nbsp;</td>
    <td class="iconoPreferencias"><a href="/cfmx/home/public/logout.cfm"><cf_translate key="LB_Salir" XmlFile="/sif/plantillas.xml">Salir</cf_translate></a></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td height="16">&nbsp;</td>
      <cfoutput>
        <td valign="top" class="iconoSistema" align="center" nowrap="nowrap" colspan="#1+header__rsContents_count#"><div style="height:16px;width:#46+46*header__rsContents_count#px;overflow:hidden;" align="center">
		<a href="/cfmx/home/" id="header__inicio" style="display:none;" ><cf_translate key="LB_Inicio" XmlFile="/sif/plantillas.xml">Inicio</cf_translate></a>
	  </cfoutput>

      <cfif IsDefined('session.Usucodigo') And Len(session.Usucodigo) and Session.Usucodigo NEQ 0>
            <cfloop query="header__rsContents">
				<cfinvoke component="sif.Componentes.TranslateDB"
					method="Translate"
					VSvalor="#SScodigo#"
					Default="#SSdescripcion#"
					VSgrupo="101"
					returnvariable="nav_SSdesc"/>
              <cfoutput>
			  <a id="header__sist_#CurrentRow#" style="display:none;" href="/cfmx/home/menu/sistema.cfm?s=#URLEncodedFormat( Trim (SScodigo) )#">#HTMLEditFormat( nav_SSdesc )#</a></cfoutput>
            </cfloop>
      </cfif>

      <cfoutput>
	  </div></td>
	  </cfoutput>
    <td>&nbsp;</td>
    <td colspan="1" class="iconoUsuario" align="left"><!--DWLayoutEmptyCell-->&nbsp;</td>
    <td colspan="5" class="iconoUsuario" align="left"><!--DWLayoutEmptyCell-->&nbsp;</td>
  </tr>
</table>

<cffunction name="Obtieneheader__rsContents">
	<cfquery name="header__rsContents" datasource="asp" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
		select 
			rtrim(s.SScodigo) as SScodigo
		  , s.SSdescripcion
		  , s.SSlogo
		  , s.ts_rversion SStimestamp
		from SSistemas s
		where s.SSmenu = 1
		and ( 
			select count(1)
			from vUsuarioProcesos up
			where up.SScodigo = s.SScodigo
			   and up.Usucodigo = #Session.Usucodigo#
			   and up.Ecodigo = #Session.EcodigoSDC#
			) > 0
		order by s.SSorden, s.SSdescripcion
	</cfquery>
</cffunction>