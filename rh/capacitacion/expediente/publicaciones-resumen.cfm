<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2692" default="0" returnvariable="LvarAprobarPublicacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_PendienteDeAprobacionRH" returnvariable="MSG_PendienteDeAprobacionRH" default="Pendiente de aprobación por RH" xmlFile="/rh/generales.xml">
<cf_translatedata name="get" tabla="RHPublicacionTipo" col="RHPT.RHPTDescripcion" returnvariable="LvarRHPTDescripcion">
<cfquery name="rsCUVitae" datasource="#session.DSN#">
	select RHP.RHPid, RHP.RHPTid, #LvarRHPTDescripcion# as TipoPublicacion, RHP.RHPTitulo as TituloPublicacion, RHP.RHPAnoPub as AnoPublicacion, RHP.RHPPublicadoEn as PublicadoEn, RHP.RHPEditorial as Editorial, RHP.RHPLugar as Lugar, RHP.RHPEnlaceWebPub as EnlaceWebPub, RHP.RHPCoautores as Coautores,RHP.RHPEstado
	from RHPublicaciones RHP
	inner join RHPublicacionTipo RHPT   
		on RHP.RHPTid = RHPT.RHPTid
	where RHP.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		<cfif not isdefined("LvarAuto") and LvarAprobarPublicacion><!---- mientras no sea autogestion se muestra unicamente los items aprobados---->
		 	and RHP.RHPEstado=1
		</cfif>
</cfquery>

<cfset t=createObject("component", "sif.Componentes.Translate")>
<cfset LB_NoSeEncontraronRegistros = t.translate('LB_NoSeEncontraronRegistros','No se encontraron registros','/rh/generales.xml')>
<cfset LB_Publicaciones = t.translate('LB_Publicaciones','Publicaciones','/rh/generales.xml')>
<cfset LB_TipoPublicacion = t.translate('LB_TipoPublicacion','Tipo de Publicación','/rh/generales.xml')>
<cfset LB_TituloPublicacion = t.translate('LB_TituloPublicacion','Título de la Publicación','/rh/generales.xml')>
<cfset LB_Ano = t.translate('LB_Ano','Año','/rh/generales.xml')>
<cfset LB_PublicadoEn = t.translate('LB_PublicadoEn','Publicado en','/rh/generales.xml')>
<cfset LB_Editorial = t.translate('LB_Editorial','Editorial','/rh/generales.xml')>
<cfset LB_Lugar = t.translate('LB_Lugar','Lugar','/rh/generales.xml')>
<cfset LB_EnlaceWebPublicacion = t.translate('LB_EnlaceWebPublicacion','Enlace web de la Publicación','/rh/generales.xml')>
<cfset LB_PublicadoCooperacion = t.translate('LB_PublicadoCooperacion','Publicado en cooperación con','/rh/generales.xml')>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="5" align="center">
	<tr>
		<td class="lbTitulos" width="30%">#LB_TituloPublicacion#</td>
		<td class="lbTitulos" width="14%">#LB_TipoPublicacion#</td>								
		<td class="lbTitulos" width="10%">#LB_Ano#</td>
		<td class="lbTitulos" width="18%">#LB_PublicadoEn#</td>
		<td class="lbTitulos" width="12%">#LB_Editorial#</td>
		<td class="lbTitulos" width="16%">#LB_Lugar#</td>	
	</tr>	
	<cfif rsCUVitae.recordcount>
		<cfloop query='rsCUVitae'>
			<tr>
				<td><strong>#TituloPublicacion#</strong></td>
				<td>#TipoPublicacion#</td>
				<td><cfif len(trim(AnoPublicacion))>#int(AnoPublicacion)#</cfif></td>
				<td>#PublicadoEn#</td>
				<td>#Editorial#</td>
				<td>#Lugar#</td>
				<cfif rsCUVitae.RHPEstado neq 1 and LvarAprobarPublicacion>
					<td><cf_notas link="<img src='/cfmx/rh/imagenes/Excl16.gif' class='imgNoAprobado'>" titulo="" pageindex="2" msg="#MSG_PendienteDeAprobacionRH#"></td>
				</cfif>
			</tr>
			<tr>
				<td class="detail" colspan="6">#LB_EnlaceWebPublicacion#</td>
			</tr>
			<tr><td class="detail" colspan="6">
				<cfif trim(len(EnlaceWebPub))>#trim(EnlaceWebPub)#</cfif>
				</td>
			</tr>
			<tr>	
				<td class="detail" colspan="6">#LB_PublicadoCooperacion#</td>
			</tr>
			<tr>	
				<td class="detail" colspan="6">
					<cfif trim(len(Coautores))>
						#trim(rsCUVitae.Coautores)#
					</cfif>
				</td>
			</tr>
			<tr><td colspan="6">&nbsp;</td></tr>
		</cfloop>	
	<cfelse>
		<tr>
			<td colspan="6" align="center">#LB_NoSeEncontraronRegistros#</td>
		</tr>			
	</cfif>		
</table>
</cfoutput>