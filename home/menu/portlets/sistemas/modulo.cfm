<cfif isdefined("url.n")>
<cfelseif isdefined("url.s")>
</cfif>
<cfparam name="session.menues.Ecodigo" type="string" default="">
<cfparam name="session.menues.SScodigo" type="string" default="">
<cfparam name="session.menues.SMcodigo" type="string" default="">
<cfset session.menues.SPcodigo = "">
<cfset session.menues.SMNcodigo = -1>
<cfparam name="url.s" default="#session.menues.SScodigo#">
<cfparam name="url.m" default="#session.menues.SMcodigo#">
<cfparam name="url.n" default="#session.menues.SMNcodigo#">

<cfset LvarCont = 0>
<cfset LvarCFMXpath = expandPath("/")>
<cfset LvarBASEpath = expandPath("")>
<cfset LvarCURRpath = mid(LvarBASEpath,len(LvarCFMXpath),1000)>

<cfquery name="rsContents" datasource="asp">
	select 	mn.SScodigo,
			mn.SMcodigo,
			mn.SMNcodigo, 
			mn.SMNcodigoPadre, 
			mn.SMNtipoMenu, mn.SMNnivel
	  from SMenues mn
 	 where
	   <cfif url.n EQ -1>
	   mn.SMNnivel = 0
	   and mn.SScodigo = '#url.s#'
	   and mn.SMcodigo = '#url.m#'
	   <cfelse>
	   mn.SMNcodigo = #url.n#
	   </cfif>
</cfquery>

<cfif url.n EQ -1>
	<cfset session.menues.SScodigo = trim(url.s)>
	<cfset session.menues.SMcodigo = trim(url.m)>
	<cfset session.menues.SMNcodigo = "-1">
<cfelse>
	<cfset session.menues.SScodigo = trim(rsContents.SScodigo)>
	<cfset session.menues.SMcodigo = trim(rsContents.SMcodigo)>
	<cfset session.menues.SMNcodigo = trim(url.n)>
</cfif>
<cfif rsContents.recordCount EQ 0>
	<cfset rsContents.SMNnivel = 0>
<cfelse>
	<cfquery name="rsContents1" datasource="asp">
		select 	mn.SMNcodigo, mn.SMNtipo,
				case when mn.SMNtipo = 'P' then p.SPdescripcion else mn.SMNtitulo end as SMNtitulo,
				mn.SMNexplicativo, p.SPhablada,
				SMNimagenGrande,   p.SPlogo,
				p.SPhomeuri,
				case when mn.SMNtipo = 'P' then p.ts_rversion else mn.ts_rversion end as ts_rversion,
				SMNcolumna
		  from SMenues mn left outer join SProcesos p
		    on mn.SScodigo = p.SScodigo
		   and mn.SMcodigo = p.SMcodigo
		   and mn.SPcodigo = p.SPcodigo
		   and p.SPmenu = 1 
		  , SSistemas s, SModulos m
		 where mn.SScodigo = s.SScodigo
		   and mn.SScodigo = m.SScodigo
		   and mn.SMcodigo = m.SMcodigo
		   and s.SSmenu = 1 
		   and m.SMmenu = 1 
		<cfif rsContents.SMNtipoMenu EQ "1" OR rsContents.SMNtipoMenu EQ "3">
		   and mn.SMNcodigo = #rsContents.SMNcodigo#
		<cfelseif rsContents.SMNtipoMenu EQ "2" OR rsContents.SMNtipoMenu EQ "4">
		   and mn.SMNcodigoPadre = #rsContents.SMNcodigo#
		</cfif>
		   and exists (
				select 1
				  from SMenues mnp, vUsuarioProcesos up
				 where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				   and up.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigosdc#">
				   and up.SScodigo = mnp.SScodigo
				   and up.SMcodigo = mnp.SMcodigo
				   and up.SPcodigo = mnp.SPcodigo
				   and mn.SScodigo = mnp.SScodigo
				   and mn.SMcodigo = mnp.SMcodigo
				   <!---and mnp.SMNpath like mn.SMNpath || '%'--->
				   and mnp.SMNpath >= mn.SMNpath
				   and mnp.SMNpath < {fn concat(mn.SMNpath, '~')}
			)
	<cfif rsContents.SMNtipoMenu EQ 4>
	order by SMNcolumna, mn.SMNpath asc
	<cfelse>
	order by mn.SMNpath asc
	</cfif>
	</cfquery>
</cfif>	

<cfquery name="empresa" datasource="asp">
	select Enombre
	from Empresa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>

<cfquery name="sistema" datasource="asp">
	select rtrim(SScodigo) as SScodigo, SSdescripcion
	from SSistemas
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
</cfquery>

<cfquery name="modulo" datasource="asp">
	select distinct SScodigo, SMcodigo
	  from vUsuarioProcesos
	 where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigosdc#">
	   and SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
</cfquery>
<cfif modulo.RecordCount is 0>

<cfelseif modulo.RecordCount is 1>
	<cfset session.menues.Modulo1 = true>
<cfelse>
	<cfset session.menues.Modulo1 = false>
</cfif>
<cfquery name="modulo" datasource="asp">
	select SMdescripcion
	from SModulos
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
	  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">
</cfquery>

<!--- ver sif_login02.css <cfhtmlhead text='<link href="/cfmx/home/menu/menu.css" rel="stylesheet" type="text/css">'> --->

<table width="510" border="0" cellspacing="0" cellpadding="0">
<cfset LvarMenues=false>
<cfif rsContents.recordCount NEQ 0>
	<cfoutput>
	<cfif rsContents.SMNtipoMenu EQ 4>
		<tr><td><table border="0" cellpadding="0" cellspacing="0" width="100%">
			<td width="5%">&nbsp;</td>
			<td valign="top" width="40%"><table border="0" cellpadding="0" cellspacing="0">
		<cfset LvarColumna = rsContents1.SMNcolumna>
	</cfif>
	<cfloop query="rsContents1">
		<cfset LvarMenues=true>
		<cfif rsContents.SMNtipoMenu EQ 4 AND LvarColumna NEQ rsContents1.SMNcolumna>
			</table></td>
			<td width="10%">&nbsp;</td>
			<td valign="top" width="40%"><table border="0" cellpadding="0" cellspacing="0">
			<cfset LvarColumna = rsContents1.SMNcolumna>
		</cfif>
		<cfif rsContents1.SMNtipo EQ "P">
			<cfset fnTitulo ("#rsContents1.SMNtitulo#","#rsContents1.SPhablada#")>
			<cfset fnOpcion ("#rsContents1.SMNtitulo#","pagina.cfm?n=#URLEncodedFormat(rsContents1.SMNcodigo)#",#rsContents1.SPlogo#,"logo_menu.cfm?n=#URLEncodedFormat(rsContents1.SMNcodigo)#",#rsContents1.ts_rversion#)>
		<cfelse>
			<cfset fnTitulo ("#rsContents1.SMNtitulo#","#rsContents1.SMNexplicativo#","#rsContents1.SMNimagenGrande#","logo_menu.cfm?n=#URLEncodedFormat(rsContents1.SMNcodigo)#&g=1",#rsContents1.ts_rversion#)>
			<cfquery name="rsContents2" datasource="asp">
				select 	mn.SMNcodigo, 
						case when mn.SMNtipo = 'P' then p.SPdescripcion else mn.SMNtitulo end as SMNtitulo,
						mn.SMNimagenPequena,
						mn.SMNtipo, 
						mn.SMNnivel, SMNenConstruccion,
						case when mn.SMNtipo = 'P' then p.ts_rversion else mn.ts_rversion end as ts_rversion,
						p.SPhomeuri, p.SPlogo
				  from SMenues mn left outer join SProcesos p
					on mn.SScodigo = p.SScodigo
				   and mn.SMcodigo = p.SMcodigo
				   and mn.SPcodigo = p.SPcodigo
				   and p.SPmenu = 1 
				  , SSistemas s, SModulos m
				 where mn.SScodigo = s.SScodigo
				   and mn.SScodigo = m.SScodigo
				   and mn.SMcodigo = m.SMcodigo
				   and s.SSmenu = 1 
				   and m.SMmenu = 1 
				   and mn.SMNcodigoPadre = #rsContents1.SMNcodigo#
				   and exists (
						select *
						  from SMenues mnp, vUsuarioProcesos up
						 where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
						   and up.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigosdc#">
						   and up.SScodigo = mnp.SScodigo
						   and up.SMcodigo = mnp.SMcodigo
						   and up.SPcodigo = mnp.SPcodigo
						   and mn.SScodigo = mnp.SScodigo
						   and mn.SMcodigo = mnp.SMcodigo
						   <!---and mnp.SMNpath like mn.SMNpath || '%'--->
						   and mnp.SMNpath >= mn.SMNpath
						   and mnp.SMNpath < mn.SMNpath || '~'
					)
				order by s.SSorden, s.SScodigo, m.SMorden, m.SMcodigo, mn.SMNpath
			</cfquery>
			<cfloop query="rsContents2">
				<cfif rsContents2.SMNenConstruccion EQ "1" OR (rsContents2.SMNtipo EQ "P" AND fnUri(rsContents2.SPhomeuri) EQ "/cfmx/")>
				<cfset fnOpcion ("#rsContents2.SMNtitulo#","javascript:alert('La Opción no está disponible en este momento');")>
				<cfelseif rsContents2.SMNtipo EQ "P">
				<cfset fnOpcion ("#rsContents2.SMNtitulo#","pagina.cfm?n=#URLEncodedFormat(rsContents2.SMNcodigo)#",#rsContents2.SPlogo#,"logo_menu.cfm?n=#URLEncodedFormat(rsContents2.SMNcodigo)#",#rsContents2.ts_rversion#)>
				<cfelse>
				<cfset fnOpcion ("#rsContents2.SMNtitulo#","modulo.cfm?n=#rsContents2.SMNcodigo#&p=#url.n#",#rsContents2.SMNimagenPequena#,"logo_menu.cfm?n=#URLEncodedFormat(rsContents2.SMNcodigo)#",#rsContents2.ts_rversion#)>
				</cfif>
			</cfloop>
		</cfif>
		<tr><td colspan="6" style="border-bottom:solid 1px">&nbsp;</td></tr>
	</cfloop>
	<cfif rsContents.SMNtipoMenu EQ 4>
		</table></td>
		<td width="5%"></td>
	</table></td></tr>
	</cfif>
	</cfoutput>
</cfif>
<cfif rsContents.SMNnivel EQ "0" or rsContents.recordCount EQ 0>
	<cfoutput>
	<cfquery name="rsContentsP" datasource="asp">
		select 	p.SPcodigo, 
				p.SPdescripcion,
				p.ts_rversion ts_rversion,
				p.SPhomeuri, p.SPlogo
		from vUsuarioProcesos up, SSistemas s, SModulos m, SProcesos p
		where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		  and up.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigosdc#">
		  and s.SSmenu = 1 
		  and m.SMmenu = 1 
		  and p.SPmenu = 1 
		  and up.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
		  and up.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">
		  and up.SScodigo = s.SScodigo
		  and up.SScodigo = m.SScodigo
		  and up.SMcodigo = m.SMcodigo
		  and up.SScodigo = p.SScodigo
		  and up.SMcodigo = p.SMcodigo
		  and up.SPcodigo = p.SPcodigo
		  and not exists (
				select *
				  from SMenues mnp
				 where up.SScodigo = mnp.SScodigo
				   and up.SMcodigo = mnp.SMcodigo
				   and up.SPcodigo = mnp.SPcodigo
			)
		order by s.SSorden, s.SScodigo, m.SMorden, m.SMcodigo, SPorden
	</cfquery>
	<cfif rsContentsP.recordCount EQ 1 AND (NOT isdefined("rsContents2") OR rsContents2.recordCount EQ 0)>
		<cfset url.p = Trim(rsContentsP.SPcodigo)>
		<cfset StructDelete(url, 'n')>
		<cfinclude template="pagina.cfm"><cfreturn>
	<cfelseif rsContentsP.recordCount GT 0>
		</table><table width="50%" align="center" border="0" cellspacing="0" cellpadding="0">
		<cfif rsContents.recordCount GT 0 AND rsContents.SMNtipoMenu NEQ "1">
			<cfset fnTitulo ("Otras Opciones en #modulo.SMdescripcion#","")>
		<cfelse>
			<cfset fnTitulo ("Opciones en #modulo.SMdescripcion#","")>
		</cfif>
		<cfloop query="rsContentsP">
			<cfif fnUri(rsContentsP.SPhomeuri) EQ "/cfmx/">
				<cfset fnOpcion ("#rsContentsP.SPdescripcion#","javascript:alert('La Opción no está disponible');",#rsContentsP.SPlogo#,"logo_proceso.cfm?s=#URLEncodedFormat(url.s)#&m=#URLEncodedFormat(url.m)#&p=#URLEncodedFormat(Trim(rsContentsP.SPcodigo))#",#rsContentsP.ts_rversion#)>
			<cfelse>
				<cfset fnOpcion ("#rsContentsP.SPdescripcion#","pagina.cfm?s=#URLEncodedFormat(url.s)#&m=#URLEncodedFormat(url.m)#&p=#URLEncodedFormat(rsContentsP.SPcodigo)#",#rsContentsP.SPlogo#,"logo_proceso.cfm?s=#URLEncodedFormat(url.s)#&m=#URLEncodedFormat(url.m)#&p=#URLEncodedFormat(Trim(rsContentsP.SPcodigo))#",#rsContentsP.ts_rversion#)>
			</cfif>
		</cfloop>
		<tr><td colspan="6" style="border-bottom:solid 1px">&nbsp;</td></tr>
	</cfif>
	</cfoutput>
</cfif>
<cfif isdefined("rsContents2")>
	<cfif rsContents1.recordCount EQ 1 AND rsContents2.recordCount EQ 1 AND (not isdefined("rsContentsP") OR rsContentsP.recordCount EQ 0)>
		<cfif rsContents2.SMNenConstruccion EQ "1" OR (rsContents2.SMNtipo EQ "P" AND fnUri(rsContents2.SPhomeuri) EQ "/cfmx/")>
		<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td align="left" class="menutitulo plantillaMenutitulo" valign="top" colspan="6">
			La Opción no está disponible en este momento
		</td>
		</tr>
		<cfelseif rsContents2.SMNtipo EQ "P">
			<cfset url.n=rsContents2.SMNcodigo>
			<cfinclude template="pagina.cfm">
		<cfelseif rsContents.SMNtipoMenu EQ "2" or rsContents.SMNtipoMenu EQ "4">
			<cfparam name="url.p" default="-1">
			<cfif url.p EQ "-1">
				<cfset url.p=''>
				<cfset url.n=rsContents2.SMNcodigo>
				<cfoutput> MENU DE SUBMODULO EN CONSTRUCCION </cfoutput>
				<!---
				<cfinclude template="modulo.cfm">
				--->
			<cfelse>
				<cfset url.n=rsContents2.SMNcodigo>
				<cfoutput> MENU DE SUBMODULO EN CONSTRUCCION </cfoutput>
				<!---
				<cfinclude template="modulo.cfm">
				--->
			</cfif>
		</cfif>
	</cfif>
</cfif>
</table>

<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<cfif isdefined("url.p")>
		<tr><td>&nbsp;</td></tr>
		<tr><td class="menuanterior plantillaMenuAnterior"><a class="menuanterior plantillaMenuAnterior" href="modulo.cfm?n=#url.p#">Menú Anterior</a></td></tr>
	</cfif>
	<cfif isdefined("session.menues.Modulo1") and NOT session.menues.Modulo1>
		<tr><td>&nbsp;</td></tr>
		<cfif isdefined("session.menues.Sistema1") and session.menues.Sistema1>
		<tr><td class="menuanterior plantillaMenuAnterior"><a class="menuanterior plantillaMenuAnterior" href="sistema.cfm?s=#session.menues.SScodigo#">Cambiar Módulo</a></td></tr>
		<cfelse>
		<tr><td class="menuanterior plantillaMenuAnterior"><a class="menuanterior plantillaMenuAnterior" href="empresa.cfm">Cambiar Módulo/Sistema</a></td></tr>
		</cfif>
	<cfelseif isdefined("session.menues.Sistema1") and NOT session.menues.Sistema1>
	<tr><td>&nbsp;</td></tr>
	<tr><td class="menuanterior plantillaMenuAnterior"><a class="menuanterior plantillaMenuAnterior" href="empresa.cfm">Cambiar Sistema</a></td></tr>
	</cfif>
	<cfif isdefined("session.menues.Empresa1") and NOT session.menues.Empresa1>
	<tr><td>&nbsp;</td></tr>
	<tr><td class="menuanterior plantillaMenuAnterior"><a class="menuanterior plantillaMenuAnterior" href="index.cfm">Cambiar Empresa</a></td></tr>
	</cfif>
	<tr><td>&nbsp;</td></tr>
</table>
</cfoutput>	

<cffunction name="fnTitulo" output="true" displayname="fnTitulo" hint="fnTitulo">
	<cfargument name="Titulo" type="string">
	<cfargument name="Explicacion" type="string">
	<cfargument name="Imagen" type="any">
	<cfargument name="ImagenUrl" type="string">
	<cfargument name="ts" type="any">
	<tr> 
		<td width="10">&nbsp;</td>
		<td width= "1">&nbsp;</td>
		<td width= "1">&nbsp;</td>
		<td width="95">&nbsp;</td>
		<td width="10">&nbsp;</td>
		<td width="1000">&nbsp;</td>
	</tr> 

	<cfif rsContents.SMNtipoMenu EQ "4">
		<tr> 
			<td rowspan="2">&nbsp;</td>
			<td valign="top" colspan="5" class="menuhead plantillaMenuhead"> 
			<cfif isdefined("Imagen") AND isBinary("#Imagen#")>
				<cfset fnDesplegarImg (Imagen,ImagenUrl,ts)>
				<BR>
			</cfif>
				#titulo#
			</td>
		</tr>
		<tr> 
			<td valign="middle" colspan="5" class="menuhablada plantillaMenuhablada"> 
				#explicacion#
			</td>
		</tr>
	<cfelseif isdefined("Imagen") AND isBinary("#Imagen#")>
		<tr> 
			<td height="70" rowspan="2">&nbsp;</td>
			<td height="70" rowspan="2" colspan="3" valign="top" align="center">
				<cfset fnDesplegarImg (Imagen,ImagenUrl,ts)>
			</td>
			<td height="70" rowspan="2">&nbsp;</td>
			<td height="1" valign="top" class="menuhead plantillaMenuhead"> 
				#titulo#
			</td>
		</tr>
		<tr> 
			<td height="69" valign="middle" class="menuhablada plantillaMenuhablada">
				#explicacion#
			</td>
		</tr>
	<cfelse>
		<tr> 
			<td rowspan="2">&nbsp;</td>
			<td valign="top" colspan="5" class="menuhead plantillaMenuhead"> 
				#titulo#
			</td>
		</tr>
		<tr> 
			<td valign="middle" colspan="5" class="menuhablada plantillaMenuhablada"> 
				#explicacion#
			</td>
		</tr>
	</cfif>
	<tr><td style="height:5px;">&nbsp;</td></tr>
</cffunction>

<cffunction name="fnOpcion" output="true" displayname="fnOpcion" hint="fnOpcion">
	<cfargument name="Titulo" type="string">
	<cfargument name="Pagina" type="string">
	<cfargument name="Imagen" type="any">
	<cfargument name="ImagenUrl" type="string">
	<cfargument name="ts" type="any">
	<tr> 
	<cfif Titulo EQ "">
		<td colspan=2>&nbsp;</td>
	<cfelse>
		<td>&nbsp;</td>
		<td class="" align="left" valign="top">
			<a target="_parent" href="#Pagina#">
			<cfif isdefined("Imagen") AND isBinary("#Imagen#")>
				<cfset fnDesplegarImg (Imagen, ImagenUrl, ts)>
			<cfelse>
				<img src="../public/imagen.cfm?f=/home/menu/imagenes/option_arrow.gif" border="0" width="12" height="17">
			</cfif>
			</a>
		</td>
		<td>&nbsp;</td>
		<td class="" align="left" valign="top" colspan="3">
			<a target="_parent" href="#Pagina#" class="menutitulo plantillaMenutitulo">#Titulo#</a><BR>
		</td>
	</cfif>
	</tr>
</cffunction>
<cffunction name="fnUri" output="false" returntype="string">
	<cfargument name="pUri" type="string">
	<cfif mid(pUri, 1, 6) NEQ "/cfmx/">
		<cfif mid(pUri, 1, 1) EQ "/">
			<cfreturn "/cfmx" & pUri>
		<cfelse>
			<cfreturn "/cfmx/" & pUri>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="fnDesplegarImg" output="true">
	<cfargument name="Imagen" type="binary">
	<cfargument name="ImagenUrl" type="string">
	<cfargument name="ts" type="any">
	<!--- Procesar el BLOB --->
	<cfinvoke 
	 component="sif.Componentes.DButils"
	 method="toTimeStamp"
	 returnvariable="ts2">
		<cfinvokeargument name="arTimeStamp" value="#ts#"/>
	</cfinvoke>

	<cfoutput>
	<img src="../public/#ImagenUrl#&amp;ts=#ts2#" border="0">
	</cfoutput>
</cffunction>
