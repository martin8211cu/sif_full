<cf_templateheader title="Activos Fijos">
		<cf_web_portlet_start titulo="Porcentajes de aplicaci&oacute;n Fiscal">
		<br>

		<!--- <cf_endesarrollo ip="10.7.7.25"> --->
		<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="60%" valign="top">
					<!---Para saber si viene de la lista de Clasificaciones --->
                    <cfif isDefined("Url.VieneClas") and url.VieneClas EQ 1 and not isdefined("form.VieneClas")>
                    	<cfset form.Vieneclas = true>
                    <cfelseif not isdefined("form.VieneClas")>
                    	<cfset form.Vieneclas = false>
                    </cfif>

					<!--- Variables de Categorías y Clasificaciones --->
					<cfif isDefined("Url.Padre_ACid") and not isDefined("form.Padre_ACid")>
					  <cfset form.Padre_ACid = Url.Padre_ACid>
					</cfif>		
					<cfif isDefined("Url.Padre_ACcodigo") and not isDefined("form.Padre_ACcodigo")>
					  <cfset form.Padre_ACcodigo = Url.Padre_ACcodigo>
					</cfif>
                    
                    <!--- Variables Categorias y Clasificaciones, cuando vienen del Form --->
                    <cfif isDefined("form.ACid") and form.VieneClas and not isDefined("form.Padre_ACid")>
					  <cfset form.Padre_ACid = form.ACid>
					</cfif>		
					<cfif isDefined("form.ACcodigo") and form.VieneClas and not isDefined("form.Padre_ACcodigo")>
					  <cfset form.Padre_ACcodigo = form.ACcodigo>
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
					<cf_dbfunction name="concat" args="rtrim(c.ACcodigodesc),' ',c.ACdescripcion" returnvariable="Clasificacion" >
					<cf_dbfunction name="concat" args="rtrim(d.CFcodigo)	,' ',d.CFdescripcion" returnvariable="CFuncional" >
					<cf_dbfunction name="concat" args="rtrim(e.Oficodigo)	,' ',e.Odescripcion"  returnvariable="Oficina" >
					<cfset navegacion = "">
					<cfquery name="rsLista" datasource="#session.dsn#">
						select	<cfqueryparam cfsqltype="cf_sql_bit" value="#form.VieneClas#"> as VieneClas,
                        		a.Ecodigo,
                        		a.ACcodigo,
								#PreserveSingleQuotes(Categoria)# as Categoria,
								a.ACid, 
								#PreserveSingleQuotes(Clasificacion)# as Clasificacion,
								a.PRFid,
                                a.PRAnoDesde, 
                                a.PRAnoHasta,
                                a.PRPorcentaje
						from  AFPorcentajeRetiroFiscal a
							inner join ACategoria b 
								on a.Ecodigo 	= b.Ecodigo
								and a.ACcodigo 	=  b.ACcodigo
							inner join AClasificacion c 
								on a.Ecodigo 	= c.Ecodigo
								and a.ACcodigo 	= c.ACcodigo
								and a.ACid 	= c.ACid
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							<cfif isdefined("form.Padre_ACid") and len(trim(form.Padre_ACid))>
								and a.ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Padre_ACid#">
								<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "Padre_ACid=" & form.Padre_ACid>
							</cfif>
							<cfif isdefined("form.Padre_ACcodigo") and len(trim(form.Padre_ACcodigo))>
								and a.ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Padre_ACcodigo#">
								<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) & "Padre_ACcodigo=" &form.Padre_ACcodigo>
							</cfif> 
                        order by Categoria,Clasificacion
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
							<td class="titulolistas"><strong>Años Desde</strong></td>
							<td class="titulolistas"><strong>Años Hasta</strong></td>
                            <td class="titulolistas"><strong>Porcentaje Aplicaci&oacute;n</strong></td>
                            <td class="titulolistas"><strong>&nbsp;</strong></td>
						</tr>
						<tr>
							<td class="titulolistas"><input type="text" name="filtro_AnoD"  tabindex="1" value="<cfif isdefined('form.filtro_AnoD')>#form.filtro_AnoD#</cfif>"></td>
                            <td class="titulolistas"><input type="text" name="filtro_AnoH"  tabindex="1" value="<cfif isdefined('form.filtro_AnoH')>#form.filtro_AnoH#</cfif>"></td>
							<td class="titulolistas"><input type="text" name="filtro_Porcentaje" tabindex="1" value="<cfif isdefined('form.filtro_Porcentaje')>#form.filtro_Porcentaje#</cfif>"></td>
                            <td class="titulolistas"><input type="submit" name="filtro_boton" tabindex="1"value="Filtrar"></td>
						</tr>
						<tr>
                        	<td colspan="4">
                                <input type="hidden" name="VieneClas" id="VieneClas" value="#form.VieneClas#" />
                                <hr>
                             </td>
                        </tr>
					</table> 
					</form>	
					</cfoutput>
 					<cfinvoke
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="rsLista"
						query="#rsLista#"
						desplegar="PRAnoDesde,PRAnoHasta,PRPorcentaje"
						etiquetas="Años Desde,Años Hasta,Porcentaje Aplicaci&oacute;n"
						formatos="I,I,N"
						align="left,left,left"
						ajustar="S"
						irA="PorcentajeRetiroFiscal.cfm"
						Cortes="Categoria,Clasificacion"
						keys="PRFid"
						maxrows="10"
						pageindex="3"
						navegacion="#navegacion#" 				 
						showEmptyListMsg= "true"
						/>
 				</td>
				<td width="5%">&nbsp;</td>
				<td width="55%" valign="top">
					<cfinclude template="PorcentajeRetiroFiscal-form.cfm"> 
				</td>			
			</tr>
		</table>
		<br>
		<cf_web_portlet_end>
	<cf_templatefooter>