<cfif session.EcodigoSDC is 0>
  <cflocation url="index.cfm" addtoken="no">
</cfif>
<cfif isdefined("url.seleccionar_EcodigoSDC")>
  <cfset session.menues.Ecodigo = session.Ecodigo>
</cfif>
<cfset session.menues.SScodigo = "">
<cfset session.menues.SMcodigo = "">
<cfset session.menues.SPcodigo = "">
<cfset session.menues.SMNcodigo = "-1">
<cfset session.menues.Sistema1=false>
<cfset session.menues.Modulo1=false>
<cfquery name="rsIdioma" datasource="sifcontrol">
	select Iid
	from Idiomas
	where Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Idioma#">
</cfquery>
<cfquery name="rsContents" datasource="asp" cachedwithin="#CreateTimeSpan(0,0,0,0)#">
	select 
	  rtrim(s.SScodigo) as SScodigo,
	  rtrim(m.SMcodigo) as SMcodigo,
	  s.SSdescripcion, 
	  s.SShablada,
	  s.SShomeuri,
	  m.SMdescripcion as SMdescripcionOriginal,
		coalesce( (	select VSdesc
					from VSidioma
					where Iid = <cfif len(trim(rsIdioma.Iid))>#rsIdioma.Iid#<cfelse>0</cfif>
					  and VSgrupo = 102
					  and VSvalor =  {fn concat({fn concat(rtrim(s.SScodigo), '.' )}, rtrim(m.SMcodigo))}   ), m.SMdescripcion) as SMdescripcion,
	  m.SMhomeuri,
	  SSlogo, s.ts_rversion SStimestamp,
	  SMlogo, m.ts_rversion SMtimestamp
	from SModulos m, SSistemas s
	where m.SScodigo = s.SScodigo
	  and  (
	  		select count(1) 
			from vUsuarioProcesos up
			   inner join SProcesos p
				on up.SScodigo = p.SScodigo
			   and up.SMcodigo = p.SMcodigo
			   and up.SPcodigo = p.SPcodigo
			   and p.SPmenu = 1 
		where up.Usucodigo = #Session.Usucodigo#
		  and up.Ecodigo   = #Session.EcodigoSDC#
		  and up.SScodigo = m.SScodigo
		  and up.SMcodigo = m.SMcodigo
		  ) > 0
	  and s.SSmenu = 1
	  and m.SMmenu = 1
	order by s.SSorden, upper( s.SSdescripcion ), coalesce (m.SMorden, 9999), upper( m.SMdescripcion )
</cfquery>

<cfquery name="rsSistema" dbtype="query">
	select distinct SScodigo
	from rsContents
</cfquery>
<cfif rsSistema.RecordCount EQ 1>
  <cfset session.menues.Sistema1=true>
  <cfif Len(Trim(rsContents.SShomeuri))>
    <cfset session.menues.SScodigo = trim(rsContents.SScodigo)>
    <cfset session.menues.SMcodigo = "">
    <cfset session.menues.SPcodigo = "">
    <cfset url.s = rsContents.SScodigo>
    <cfinclude template="pagina.cfm">
    <cfabort>
    <cflocation url="pagina.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#">
  </cfif>
</cfif>
<cfif rsContents.RecordCount EQ 1>
  <cfset session.menues.Modulo1=true>
  <cfset session.menues.SScodigo = trim(rsContents.SScodigo)>
  <cfset session.menues.SMcodigo = trim(rsContents.SMcodigo)>
  <cfset session.menues.SPcodigo = "">
  <cfif Len(Trim(rsContents.SMhomeuri))>
    <!--- <cflocation url="/cfmx#Trim(rsContents.SMhomeuri)#"> --->
    <cfset url.s = rsContents.SScodigo>
    <cfset url.m = rsContents.SMcodigo>
    <cfinclude template="pagina.cfm">
    <cfabort>
    <cflocation url="pagina.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&m=#URLEncodedFormat(rsContents.SMcodigo)#">
    <cfelse>
    <cfset url.s = rsContents.SScodigo>
    <cfset url.m = rsContents.SMcodigo>
    <cfinclude template="modulo.cfm">
    <cfabort>
    <cflocation url="modulo.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&m=#URLEncodedFormat(rsContents.SMcodigo)#">
  </cfif>
</cfif>
<cf_templateheader title="Sistemas de una Empresa" pnavegacion = "false">
	<cfinclude template="navegacion.cfm">
    <!---<cfoutput>#navegacion_cfm#</cfoutput>--->
    <cfset MostrarHablada = true>
    <cfinclude template="usuarioempresa.cfm">
		<cfset numsistemas = 0>
		<cfoutput query="rsContents" group="SScodigo">
			<cfset numsistemas = numsistemas+1>
		</cfoutput>
		<cfif numsistemas EQ 1>
			<cfset ancho_sistema = 650>
			<cfset ancho_modulo = 320>
		<cfelse>
			<cfset ancho_sistema = 482>
			<cfset ancho_modulo = 214>
		</cfif>
    <cfif rsContents.RecordCount gt 0 >
      <table width="968" border="0" cellpadding="2" cellspacing="0" align="center" >
        <cfset i = 1 >
        <cfset fila = 0 >
        <cfoutput query="rsContents" group="SScodigo">
          <cfif i mod 2 >
            <tr>
            <cfset fila = fila+1 >
          </cfif>
          <cfset columna = abs((i mod 2)-2) >
			<cfinvoke component="sif.Componentes.TranslateDB"
			method="Translate"
			VSvalor="#rsContents.SScodigo#"
			Default="#rsContents.SSdescripcion#"
			VSgrupo="101"
			returnvariable="translated_Sistema"/> 
          <tr  ><td width="#ancho_sistema#" valign="top"><cf_web_portlet_start border="true" width="#ancho_sistema-32#" skin="Gray" tituloalign="left" titulo='#translated_Sistema#'>
                <table width="100%" cellpadding="3" cellspacing="0" border="0" >
                  <tr>
                    <td align="center" colspan="4"><cfif Len(rsContents.SSlogo) GT 1>
                        <cfinvoke 
							 component="sif.Componentes.DButils"
							 method="toTimeStamp"
							 returnvariable="tsurl"
							 arTimeStamp="#rsContents.SStimestamp#">
                        </cfinvoke>
                        <img align="middle" src="../public/logo_sistema.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&amp;ts=#tsurl#" border="0" alt="" >
                        <cfelse>
                        <img align="middle" src="../public/imagen.cfm?f=/home/menu/imagenes/sistema_default.jpg" border="0" alt="" >
                      </cfif>
                    </td>
                  </tr>
                  <cfset j = 1 >
                  <cfoutput group="SMcodigo">
                    <!--- ///////////////////////////////////////////////////////////// --->
                    <cfif Len(Trim(rsContents.SShomeuri))>
                      <!--- <cfset uri = '/cfmx' & Trim(rsContents.SShomeuri)> --->
                      <cfset uri = 'pagina.cfm?s=' & URLEncodedFormat(rsContents.SScodigo)>
                      <cfelse>
                      <!--- <cfset uri = 'sistema.cfm?s=' & URLEncodedFormat(rsContents.SScodigo)> --->
                      <cfset uri = "">
                    </cfif>
                    <cfif Len(Trim(rsContents.SMhomeuri))>
                      <!--- <cfset uri = '/cfmx' & Trim(rsContents.SMhomeuri)> --->
                      <cfset uri = 'pagina.cfm?s=' & URLEncodedFormat(rsContents.SScodigo) & '&amp;m=' & URLEncodedFormat(rsContents.SMcodigo)>
                      <cfelse>
                      <cfset uri = 'modulo.cfm?s=' & URLEncodedFormat(rsContents.SScodigo) & '&amp;m=' & URLEncodedFormat(rsContents.SMcodigo)>
                    </cfif>
                    <!--- ///////////////////////////////////////////////////////////// --->
                    <cfif j mod 2>
                      <tr>
                    </cfif>
                    <!---<a class="menutitulo plantillaMenutitulo" href="#uri#">--->
                    <td valign="top" width="14" align="right"><cfif Len(rsContents.SMlogo) GT 1>
                        <cfinvoke 
													 component="sif.Componentes.DButils"
													 method="toTimeStamp"
													 returnvariable="tsurl">
                        <cfinvokeargument name="arTimeStamp" value="#rsContents.SMtimestamp#"/>
                        </cfinvoke>
                        <!---<img src="../public/logo_modulo.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&amp;m=#URLEncodedFormat(rsContents.SMcodigo)#&amp;ts=#tsurl#" border="0" alt="">--->
                        <a class="menutitulo plantillaMenutitulo" href="#uri#"> <img align="top" src="../imagenes/bl-bullet.gif" border="0" height="8" width="2" alt="">
                        <!---<img src="../imagenes/role_1005.gif" border="0">--->
                        </a>
                        <cfelse>
                        <img align="top" src="../imagenes/bl-bullet.gif" border="0" height="8" width="2" alt="">
                      </cfif>
                    </td>
                    <tr  ><td valign="middle" width="#ancho_modulo#"><a class="fbox" href="#uri#"><cfif len(trim(rsContents.SMdescripcion))>#rsContents.SMdescripcion#<cfelse>#rsContents.SMdescripcionOriginal#</cfif></a></td>
                      <cfif not j mod 2>
                        </tr>
                      </cfif>
                      <cfset j = j+1 >
                  </cfoutput>
                  <!--- cierra el ultimo tr, si hay uno abierto --->
                  <cfif not j mod 2>
                    <td colspan="2">&nbsp;</td>
                    </tr>
                  </cfif>
				  
                </table>
              <cf_web_portlet_end>
            </td>
            <cfif (not i mod 2) >
              </tr>
            </cfif>
            <cfset i = i+1 >
        </cfoutput>
        <!--- cierra el ultimo tr abierto --->
        <cfif (i eq 2) and (numsistemas NEQ 1)>
          <tr  ><td></td>
        </cfif>
        <cfif (not i mod 2) >
          </tr>
        </cfif>
      </table>
      <cfelse>
      <cfoutput>A&uacute;n no ha sido afiliado a ning&uacute;n m&oacute;dulo </cfoutput>
    </cfif>
    <cfinclude template="footer.cfm">
<cf_templatefooter>
