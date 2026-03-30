
<style type="text/css">
	.detailCoautor { margin-top: 25px; }  
	.detailCoautor table { margin-bottom: 15px; }
	.botones { padding-top: 15px;}
</style>

<!----- Etiquetas de traduccion------>
<cfset LB_Publicacion = t.translate('LB_Publicacion','Publicación','/rh/generales.xml')>
<cfset LB_TipoPublicacion = t.translate('LB_TipoPublicacion','Tipo de Publicación','/rh/generales.xml')>
<cfset LB_TituloPublicacion = t.translate('LB_TituloPublicacion','Título de la Publicación','/rh/generales.xml')>
<cfset LB_AnoPublicacion = t.translate('LB_AnoPublicacion','Año de la Publicación','/rh/generales.xml')>
<cfset LB_PublicadoEn = t.translate('LB_PublicadoEn','Publicado en','/rh/generales.xml')>
<cfset LB_Editorial = t.translate('LB_Editorial','Editorial','/rh/generales.xml')>
<cfset LB_Lugar = t.translate('LB_Lugar','Lugar','/rh/generales.xml')>
<cfset LB_EnlaceWebPublicacion = t.translate('LB_EnlaceWebPublicacion','Enlace web de la Publicación','/rh/generales.xml')>
<cfset LB_PublicadoCooperacion = t.translate('LB_PublicadoCooperacion','Publicado en cooperación con','/rh/generales.xml')>
<cfset MSG_DeseaAprobarLaPublicacionRealizada = t.translate('MSG_DeseaAprobarLaPublicacionRealizada','Desea aprobar la Publicación Realizada?','/rh/capacitacion/operacion/ActualizacionPublicaciones.xml')>
<cfset LB_Aprobado = t.Translate('LB_Aprobado','Aprobado','/rh/generales.xml')>

<cfif isdefined("fromAprobacionCV")><!----- si se trabaja desde aprobacion de curriculum vitae---->
	<cfset destino = "AprobacionCV-sql.cfm" >	
<cfelse>
	<cfset destino = "ActualizacionPublicaciones-sql.cfm" >	
</cfif>


<cf_dbfunction name="op_concat" returnvariable="concat"/>
<cfquery name="rsListPublicPend" datasource="#session.DSN#">
	select RHP.RHPid, RHP.DEid, RHP.RHPTitulo #concat# case when RHP.RHPAnoPub is not null then ' (' #concat# convert(varchar,RHP.RHPAnoPub) #concat# ')' else '' end as Publicacion,RHP.RHPEstado
	,case when RHP.RHPEstado = 1 then 'X' else '' end as estado
	from RHPublicaciones RHP
	where RHP.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>

<cfif isdefined("form.RHPid") and len(trim(form.RHPid)) gt 0 >
	<cfset modo = 'Cambio'>	
	<cfquery name="rsPublicacion" datasource="#session.DSN#">
		select RHP.RHPid, RHP.RHPTid, RHPT.RHPTDescripcion, RHP.RHPTitulo, RHP.RHPAnoPub, RHP.RHPPublicadoEn, RHP.RHPEditorial, RHP.RHPLugar, RHP.RHPEnlaceWebPub, RHP.RHPCoautores, RHP.RHPEstado
		from RHPublicaciones RHP
		inner join RHPublicacionTipo RHPT   
			on RHP.RHPTid = RHPT.RHPTid
		where RHP.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPid#">
	</cfquery>
<cfelse>
	<cfset modo = 'Alta'>	
</cfif>

<div class="row">
	<div class="col-sm-5">
		<cfinvoke 
			component="rh.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsListPublicPend#"/>
			<cfinvokeargument name="desplegar" value="Publicacion,estado"/>
			<cfinvokeargument name="etiquetas" value="#LB_Publicacion#,#LB_Aprobado#"/>
			<cfinvokeargument name="formatos" value="V,V"/>
			<cfinvokeargument name="align" value="left,center"/>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="keys" value="RHPid"/>
			<cfinvokeargument name="irA" value=""/>
			<cfinvokeargument name="formName" value="formEducacionLista"/>
			<cfinvokeargument name="PageIndex" value="1"/>
		</cfinvoke>
	</div>	
	<div class="col-sm-7">
		<cfoutput>
			<form name="formPublicacion" method="post" action="#destino#">
				<cfif isdefined("fromAprobacionCV")><!----- si se trabaja desde aprobacion de curriculum vitae---->
					<input type="hidden" name="tab" value="5">
				</cfif>
				<table width="100%" cellpadding="7" cellspacing="0">
					<cfif isdefined('form.RHPid') and len(trim(form.RHPid)) gt 0 ><input type="hidden" name="RHPid" value="#form.RHPid#"></cfif>
					<cfif isdefined('form.DEid') and len(trim(form.DEid)) gt 0 ><input type="hidden" name="DEid" value="#form.DEid#"></cfif>

					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td class="col-sm-4" align="left"><strong>#LB_TipoPublicacion#:</strong></td>
						<td align="left"><cfif modo eq 'Cambio'>#trim(rsPublicacion.RHPTDescripcion)#</cfif></td>
					</tr>
					<tr>
						<td class="col-sm-4" align="left"><strong>#LB_TituloPublicacion#:</strong></td>
						<td align="left"><cfif modo eq 'Cambio'>#trim(rsPublicacion.RHPTitulo)#</cfif></td>
					</tr>
					<tr>
						<td class="col-sm-4" align="left"><strong>#LB_AnoPublicacion#:</strong></td>
						<td align="left"><cfif modo eq 'Cambio'>#trim(rsPublicacion.RHPAnoPub)#</cfif></td>	
					</tr>	
					<tr>
						<td class="col-sm-4" align="left"><strong>#LB_PublicadoEn#:</strong></td>
						<td align="left"><cfif modo eq 'Cambio'>#trim(rsPublicacion.RHPPublicadoEn)#</cfif></td>
					</tr>	
					<tr>
						<td class="col-sm-4" align="left"><strong>#LB_Editorial#:</strong></td>
						<td align="left"><cfif modo eq 'Cambio'>#trim(rsPublicacion.RHPEditorial)#</cfif></td>	
					</tr>	
					<tr>
						<td class="col-sm-4" align="left"><strong>#LB_Lugar#:</strong></td>
						<td align="left"><cfif modo eq 'Cambio'>#trim(rsPublicacion.RHPLugar)#</cfif></td>	
					</tr>	
					<tr>
						<td class="col-sm-4" align="left"><strong>#LB_EnlaceWebPublicacion#:</strong></td>
						<td align="left"><cfif modo eq 'Cambio'>#trim(rsPublicacion.RHPEnlaceWebPub)#</cfif></td>
					</tr>	
					<tr>
						<td class="col-sm-4" align="left"><strong>#LB_PublicadoCooperacion#:</strong></td>
						<td align="left" <cfif modo neq 'Cambio' or (isdefined('rsPublicacion') and len(trim(rsPublicacion.RHPCoautores)) eq 0 )> style="display:none;"</cfif>>
								<cfif modo eq 'Cambio' and len(trim(rsPublicacion.RHPCoautores)) gt 0 >
									<cfset listCoautor = valueList(rsPublicacion.RHPCoautores)>
									<cfloop list="#listCoautor#" index="i">
										#i#<cfif listLast(listCoautor) neq i >, </cfif>
									</cfloop>
								</cfif>	
						</td>	
					</tr>		
					<tr>
						<td class="botones" colspan="2"> 
							<cfif isdefined("fromAprobacionCV")><!---- si se encuentra en el prceso de aprobacion de idiomas no puede editar---->
								<cfif isdefined('form.RHPid') and len(trim(form.RHPid))>
									<cfif rsPublicacion.RHPEstado eq 1>
										<cf_botones values="Rechazar"> 	
									<cfelse>	
										<cf_botones values="Aprobar"> 	
									</cfif>
									
								</cfif>	
							<cfelse>
									<cfif modo eq 'Cambio'>
										<cf_botones values="Aprobar,Regresar"> 	
									<cfelse>
										<cf_botones values="Regresar">		
									</cfif>
							</cfif>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
				</table>	
			</form>	
		</cfoutput>	
	</div>
</div>

<script type="text/javascript">
	function funcRegresar(){
		document.formPublicacion.RHPid.value = '';
		<cfif modo neq 'Cambio'>
			document.formPublicacion.DEid.value = '';
		</cfif>	
		document.formPublicacion.action = "ActualizacionPublicaciones.cfm";
	}
	
	function funcAprobar(){
		return true;
	}
</script>