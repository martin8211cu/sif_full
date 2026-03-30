
<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>

	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		<cfset ffiltro = "">
		<cfset f_nuevo = false>		
		<cfset navegacion = "">

		<!---  VARIABLE LAVE PARA CUANDO VIENE DEL SQL --->
		<cfif isdefined("url.CTid") and len(trim(url.CTid))>
			<cfset form.CTid = url.CTid>
		</cfif>
		
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
		<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
			<cfset form.Pagina = url.Pagina>
		</cfif>					
		
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
		<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
			<cfset form.Pagina = url.PageNum_Lista>
			<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
			<cfset form.CTid = 0>
		</cfif>					
		<cfif isdefined("url.AGidp_Agente") and len(trim(url.AGidp_Agente))>
			<cfset form.AGidp_Agente = url.AGidp_Agente>
		</cfif>	
		<cfif isdefined("url.filtro_propietario") and Len(Trim(url.filtro_propietario))>
			<cfset form.filtro_propietario = url.filtro_propietario>
		</cfif>			
				
		
		<cfoutput>
			<cfif isdefined("form.AGidp_Agente") and len(trim(form.AGidp_Agente))>
				<cfset ffiltro = ffiltro & " and c.Vid in (
													Select Vid
													from ISBvendedor
													where AGid=" & form.AGidp_Agente & ")">
				<cfset navegacion = navegacion & "&AGidp_Agente=#trim(form.AGidp_Agente)#">
			</cfif>
			<cfif isdefined('form.AGidp_Agente') and form.AGidp_Agente NEQ ''
				and isdefined('form.hAGidp_Agente') and form.hAGidp_Agente NEQ ''
				and form.AGidp_Agente NEQ form.hAGidp_Agente>
					<cfset f_nuevo = true>
			</cfif>
			
			<cfif isdefined("form.filtro_propietario") and len(trim(form.filtro_propietario))>
				<cfset ffiltro = ffiltro & " and upper(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || rtrim(b.Papellido2)) like upper('%" & form.filtro_propietario & "%')">
				<cfset navegacion = navegacion & "&filtro_propietario=#trim(form.filtro_propietario)#">
			</cfif>
			<cfif isdefined('form.filtro_propietario') and form.filtro_propietario NEQ ''
				and isdefined('form.hfiltro_propietario') and form.hfiltro_propietario NEQ ''
				and form.filtro_propietario NEQ form.hfiltro_propietario>
					<cfset f_nuevo = true>
			</cfif>			
			
			<cfif isdefined("form.filtro_identif") and len(trim(form.filtro_identif))>
				<cfset ffiltro = ffiltro & " and upper(b.Pid) like upper('%" & form.filtro_identif & "%')">
				<cfset navegacion = navegacion & "&filtro_identif=#trim(form.filtro_identif)#">
			</cfif>
			<cfif isdefined('form.filtro_identif') and form.filtro_identif NEQ ''
				and isdefined('form.hfiltro_identif') and form.hfiltro_identif NEQ ''
				and form.filtro_identif NEQ form.hfiltro_identif>
					<cfset f_nuevo = true>
			</cfif>			
						

			
		</cfoutput>							
		
		<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN--->
		<cfparam name="form.Pagina" default="1">				

		<form name="listaAprob" action="aprobacion-redirect.cfm" method="post" style="margin:0;">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			  <tr>
				<td nowrap>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="7%" align="right"><label>Agente:</label></td>
						<td width="20%">	
							<cfset llaveAgente = "">
							<cfif isdefined('form.AGidp_Agente') and form.AGidp_Agente NEQ ''>
								<cfset llaveAgente = form.AGidp_Agente>
							</cfif>
							
							<cf_agenteId form="listaAprob" sufijo="_Agente" id_agente="#llaveAgente#">
						</td>
						<td width="73%">
							  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
								  <td align="right" nowrap><label>Nombre Propietario:</label></td>
								  <td><input name="filtro_propietario" type="text" size="50" maxlength="140" value="<cfif isdefined('form.filtro_propietario') and form.filtro_propietario NEQ ''><cfoutput>#form.filtro_propietario#</cfoutput></cfif>"></td>								
								</tr>								
								<tr>
								  <td align="right" nowrap><label>Identificaci&oacute;n Propietario:</label></td>
								  <td><input name="filtro_identif" type="text" size="20" maxlength="20" value="<cfif isdefined('form.filtro_identif') and form.filtro_identif NEQ ''><cfoutput>#form.filtro_identif#</cfoutput></cfif>"></td>								
								</tr>
							  </table>						
						</td>	
					  </tr>
					</table>
					<hr>
				</td>			
			  </tr>				
			  <tr>
				<td>
					<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO CUECUE--->
					<cfquery datasource="#session.dsn#" name="rsCUECUE">
							select '' as value, '-- todos --' as description, '0' as ord
						union
							select 'A' as value, '(Acceso Agente) ' as description, '1' as ord
						union
							select 'U' as value, '(Acceso Usuario) ' as description, '2' as ord
						union
							select 'F' as value, '(Facturación Agente) ' as description, '3' as ord
						order by 3,2
					</cfquery>
					
					<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaRH">
						<cfinvokeargument name="tabla" value="							
															ISBcuenta a
																inner join ISBpersona b
																	on  b.Pquien = a.Pquien
																														
																inner join ISBproducto c
																	on  a.CTid = c.CTid
																		and CTcondicion = '0' 																		
																#ffiltro#
																inner join ISBpaquete p
																	on p.PQcodigo=c.PQcodigo"/>

						<cfinvokeargument name="columnas" value="distinct a.CTid
																, c.Contratoid
																, p.PQcodigo
																, p.PQnombre																						
																, (case a.CTtipoUso 
																		when 'A' then '(Acceso Agente) ' 
																		when 'F' then '(Facturación Agente) ' 
																		when 'U' then '(Acceso Usuario) '
																	end
																		) || (
																		case a.CUECUE 
																			when 0 then 'Por Asignar' 
																			else convert(varchar,a.CUECUE)
																			end)
																	 as CUECUE
																, b.Pquien
																, rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido) || ' ' || b.Papellido2) as dueno
																, c.CNapertura
																, 1 as paso "/> 
					 	<cfinvokeargument name="desplegar" value="CUECUE,CNapertura,PQnombre"/>
						<cfinvokeargument name="etiquetas" value="Núm.Cuenta,Apertura,Paquete"/>
						<cfinvokeargument name="filtro" value="b.Ecodigo = #Session.Ecodigo#			
																order by dueno,CNapertura,a.CUECUE"/>
						<cfinvokeargument name="align" value="left,left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="aprobacion.cfm"/>
						<cfinvokeargument name="conexion" value="#Session.DSN#"/>
						<cfinvokeargument name="keys" value="CTid"/>
						<cfinvokeargument name="formname" value="listaAprob"/>
						<cfinvokeargument name="formatos" value="S,D,S"/>
						<cfinvokeargument name="maxrows" value="9"/>
						<cfinvokeargument name="Cortes" value="dueno"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="rsCUECUE" value="#rsCUECUE#"/>
						<cfinvokeargument name="incluyeForm" value="false"/>
						<cfinvokeargument name="filtro_nuevo" value="#f_nuevo#"/>	
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="filtrar_por" value="a.CTtipoUso
																	, CNapertura 
																	, PQnombre"/>
					</cfinvoke>	
				</td>
			  </tr>
			</table>
		</form>
	<cf_web_portlet_end> 
<cf_templatefooter>

<!---
<cfif isdefined("url.Activo") and len(trim(url.Activo))>
	<cfif url.Activo EQ 1>
		<script language="javascript" language="javascript">
			alert("Se aprobó el contrato con éxito");
		</script>
	<cfelseif url.Activo EQ 2>
		<script language="javascript" language="javascript">
			alert("Se rechazo el contrato con éxito");
		</script>	
	</cfif>
</cfif>--->

