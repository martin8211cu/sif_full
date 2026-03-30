<cf_templateheader title="Activos Fijos">
		<cf_web_portlet_start titulo="Clasificaci&oacute;n de Centro Funcional">
		<br>

		<!--- <cf_endesarrollo ip="10.7.7.25"> --->
		<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="60%" valign="top">
					<!--- Variables de Categorías y Clasificaciones --->
					<cfif isDefined("Url.Padre_ACid") and not isDefined("form.Padre_ACid")>
					  <cfset form.Padre_ACid = Url.Padre_ACid>
					</cfif>		
					<cfif isDefined("Url.Padre_ACcodigo") and not isDefined("form.Padre_ACcodigo")>
					  <cfset form.Padre_ACcodigo = Url.Padre_ACcodigo>
					</cfif>
					<!--- Variables para Navegación --->
					<cfif isdefined("url.Filtro_Placa") and len(trim(url.Filtro_Placa))>
						<cfset form.Filtro_Placa = url.Filtro_Placa>
					</cfif>					
					<cfif isdefined("url.Filtro_Descripcion") and len(trim(url.Filtro_Descripcion))>
						<cfset form.Filtro_Descripcion = url.Filtro_Descripcion>
					</cfif>
					<!-- Aqui van los campos Llave Definidos para la tabla -->
					<cfif isdefined("url.CCFid") and len(trim(url.CCFid)) and not isdefined("form.CCFid")>
						<cfset form.CCFid = url.CCFid>
					</cfif>
					<cf_dbfunction name="concat" args="rtrim(b.ACcodigodesc),' ',b.ACdescripcion" returnvariable="Categoria" >
					<cf_dbfunction name="concat" args="rtrim(b.ACcodigodesc),' ',c.ACdescripcion" returnvariable="Clasificacion" >
					<cf_dbfunction name="concat" args="rtrim(d.CFcodigo)	,' ',d.CFdescripcion" returnvariable="CFuncional" >
					<cf_dbfunction name="concat" args="rtrim(e.Oficodigo)	,' ',e.Odescripcion"  returnvariable="Oficina" >
					<cfset navegacion = "">
					<cfquery name="rsLista" datasource="#session.dsn#">
						select 	a.CCFid,
								a.ACcodigo,
								#PreserveSingleQuotes(Categoria)# as Categoria,
								a.ACid, 
								#PreserveSingleQuotes(Clasificacion)# as Clasificacion,
								a.CFid, 
								coalesce(#PreserveSingleQuotes(CFuncional)#,' ')  as CFuncional,
								a.Ocodigo,
								coalesce(#PreserveSingleQuotes(Oficina)#,' ') as Oficina,				
								a.CCFvutil
								<cfif isdefined("form.Padre_ACid") and len(trim(form.Padre_ACid))>
									,#form.Padre_ACid# as Padre_ACid
								</cfif>
								<cfif isdefined("form.Padre_ACcodigo") and len(trim(form.Padre_ACcodigo))>
									,#form.Padre_ACcodigo# as Padre_ACcodigo
								</cfif>
						from  ClasificacionCFuncional a
							inner join ACategoria b 
								on a.Ecodigo 	= b.Ecodigo
								and a.ACcodigo 	=  b.ACcodigo
							inner join AClasificacion c 
								on a.Ecodigo 	= c.Ecodigo
								and a.ACcodigo 	= c.ACcodigo
								and a.ACid 	= c.ACid
							left outer join CFuncional d
								on a.Ecodigo 	= d.Ecodigo
								and a.CFid 	= d.CFid
							left outer join Oficinas e
								on a.Ecodigo 	= e.Ecodigo
								and a.Ocodigo 	=  e.Ocodigo																
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							<cfif isdefined("form.Padre_ACid") and len(trim(form.Padre_ACid))>
								and a.ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Padre_ACid#">
								<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "Padre_ACid=" & form.Padre_ACid>
							</cfif>
							<cfif isdefined("form.Padre_ACcodigo") and len(trim(form.Padre_ACcodigo))>
								and a.ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Padre_ACcodigo#">
								<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "Padre_ACcodigo=" &form.Padre_ACcodigo>
							</cfif> 
							<!--- <cfif isdefined("form.Filtro_Categoria") and len(trim(form.Filtro_Categoria))>
								and (lower(b.ACcodigodesc) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.Filtro_Categoria)#%">
									or 	lower(b.ACdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.Filtro_Categoria)#%">)
									<cfset navegacion = "&Filtro_Categoria="&form.Filtro_Categoria>
							</cfif>
							<cfif isdefined("form.Filtro_Clasificacion") and len(trim(form.Filtro_Clasificacion))>
								and (lower(c.ACcodigodesc) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.Filtro_Clasificacion)#%">
									or lower(c.ACdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.Filtro_Clasificacion)#%">)
									<cfset navegacion = "&Filtro_Clasificacion="&form.Filtro_Clasificacion>
							</cfif> --->
							<cfif isdefined("form.Filtro_CFuncional") and len(trim(form.Filtro_CFuncional))>
								and (lower(d.CFcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.Filtro_CFuncional)#%">
									or lower(d.CFdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.Filtro_CFuncional)#%">)
									<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "Filtro_CFuncional="&form.Filtro_CFuncional>								
							</cfif>
							<cfif isdefined("form.Filtro_Oficina") and len(trim(form.Filtro_Oficina))>
								and (lower(e.Oficodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.Filtro_Oficina)#%">
									or lower(e.Odescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.Filtro_Oficina)#%">)
									<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "Filtro_Oficina="&form.Filtro_Oficina>																
							</cfif>
							<cfif isdefined("form.Filtro_CCFvutil") and len(trim(form.Filtro_CCFvutil))>
								and a.CCFvutil >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Filtro_CCFvutil#">
									<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "Filtro_CCFvutil="&form.Filtro_CCFvutil>										
							</cfif>
							order by CFuncional
 					</cfquery>
					<cfoutput>
					<form action="" method="post" name="filtro" style="margin:0px;">
					<cfif isdefined("form.Padre_ACid") and len(trim(form.Padre_ACid))>
						<input type="hidden" name="Padre_ACid" value="#form.Padre_ACid#">
					</cfif>
					<cfif isdefined("form.Padre_ACcodigo") and len(trim(form.Padre_ACcodigo))>
						<input type="hidden" name="Padre_ACcodigo" value="#form.Padre_ACcodigo#">
					</cfif>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
						<tr>
							<td class="titulolistas"><strong>Centro Funcional&nbsp;</strong></td>
							<td class="titulolistas"><strong>Oficina&nbsp;</strong></td>
							<td class="titulolistas"><strong>Vida &Uacute;til&nbsp;</strong></td>
							<td class="titulolistas"><strong>&nbsp;</strong></td>
						</tr>
						<tr>
							<td class="titulolistas"><input type="text" name="filtro_CFuncional"  tabindex="1" value="<cfif isdefined('form.filtro_CFuncional')>#form.filtro_CFuncional#</cfif>"></td>
							<td class="titulolistas"><input type="text" name="filtro_Oficina" tabindex="1" value="<cfif isdefined('form.filtro_Oficina')>#form.filtro_Oficina#</cfif>"></td>
							<td class="titulolistas"><input type="text" name="filtro_CCFvutil" tabindex="1" value="<cfif isdefined('form.filtro_CCFvutil')>#form.filtro_CCFvutil#</cfif>"></td>
							<td class="titulolistas"><input type="submit" name="filtro_boton" tabindex="1"value="Filtrar"></td>
						</tr>
						<tr><td colspan="4"><hr></td></tr>
					</table> 
					</form>	
					</cfoutput>
 					<cfinvoke
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="rsLista"
						query="#rsLista#"
						desplegar="CFuncional,Oficina,CCFvutil"
						etiquetas="Centro Funcional,Oficina,Vida &Uacute;til"
						formatos="S,S,S"
						align="left,left,left"
						ajustar="S"
						irA="ClasificacionCF.cfm"
						Cortes="Categoria,Clasificacion"
						keys="CCFid"
						maxrows="5"
						pageindex="3"
						navegacion="#navegacion#" 				 
						showEmptyListMsg= "true"
						/>
 				</td>
				<td width="5%">&nbsp;</td>
				<td width="55%" valign="top">
					<cfinclude template="ClasificacionCF-form.cfm"> 
				</td>			
			</tr>
		</table>
		<br>
		<cf_web_portlet_end>
	<cf_templatefooter>