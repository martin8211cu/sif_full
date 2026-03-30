
<!--- 
<cfdump var="#form#">
<cfdump var="#url#"> 
--->

<!--- form1 --->
<cfif isdefined("url.RHJMUfecha") and len(trim(url.RHJMUfecha))NEQ 0>
	<cfset form.RHJMUfecha = url.RHJMUfecha>
</cfif> 

<cfif isdefined("url.RHJMUsituacion") and len(trim(url.RHJMUsituacion))NEQ 0>
	<cfset form.RHJMUsituacion = url.RHJMUsituacion>
</cfif>

<!--- form2 --->
<cfif isdefined("url.RHJMUfecha2") and len(trim(url.RHJMUfecha2))NEQ 0>
	<cfset form.RHJMUfecha2 = url.RHJMUfecha2>
</cfif> 

<cfif isdefined("url.RHJMUsituacion2") and len(trim(url.RHJMUsituacion2))NEQ 0>
	<cfset form.RHJMUsituacion2 = url.RHJMUsituacion2>
</cfif>

<!--- navegacion --->
<cfset navegacion = "">
<cfif isdefined("form.RHJMUfecha2")>
	<cfset navegacion = navegacion & "RHJMUfecha2="& form.RHJMUfecha2>	
</cfif>
<cfif isdefined("form.RHJMUsituacion2")>
	<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "RHJMUsituacion2="&form.RHJMUsituacion2>	
</cfif>


<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>

<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#nav__SPdescripcion#</cfoutput>
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="50%" valign="top"><!--- Lista de Justificaciones --->
					
					<form name="form2" action="justificacionAdelantadaMarca.cfm" method="post">
						<table width="100%" class="areaFiltro">
							<tr valign="top">
								<td width="23%"  class="fileLabel" align="left">Fecha</td>
								<td width="66%"  class="fileLabel" align="left">Situación</td>
							</tr>
							<tr valign="top">
								<td nowrap>
									<cfif isdefined('form.RHJMUfecha2') and len(trim(form.RHJMUfecha2))NEQ 0>
										<cfset RHJMUfecha = LSDateFormat(form.RHJMUfecha2,'dd/mm/yyyy')>
										<cf_sifcalendario  form="form2" name="RHJMUfecha2" value="#RHJMUfecha#">
									<cfelse>
										<cfset RHJMUfecha = ''>
										<cf_sifcalendario  form="form2" name="RHJMUfecha2" value="">
									</cfif>
									
								</td>
								<td>
									 <select name="RHJMUsituacion2">
									 	<option value="" <cfif isdefined('form.RHJMUsituacion2')> <cfif form.RHJMUsituacion2 EQ 0> selected </cfif></cfif>>Todas</option>
										<option value="1" <cfif isdefined('form.RHJMUsituacion2')> <cfif form.RHJMUsituacion2 EQ 1> selected</cfif></cfif>>Omición de marca de entrada</option>
										<option value="2" <cfif isdefined('form.RHJMUsituacion2')> <cfif form.RHJMUsituacion2 EQ 2> selected </cfif></cfif>>Omición de marca de entrada</option>
										<option value="3" <cfif isdefined('form.RHJMUsituacion2')> <cfif form.RHJMUsituacion2 EQ 3> selected </cfif></cfif>>Llegada Tardía</option>
										<option value="4" <cfif isdefined('form.RHJMUsituacion2')> <cfif form.RHJMUsituacion2 EQ 4> selected </cfif></cfif>>Salida Anticipada</option>
										<option value="5" <cfif isdefined('form.RHJMUsituacion2')> <cfif form.RHJMUsituacion2 EQ 5> selected </cfif></cfif>>Horas extras antes de la marca</option>
										<option value="6" <cfif isdefined('form.RHJMUsituacion2')> <cfif form.RHJMUsituacion2 EQ 6> selected </cfif></cfif>>Horas extras después de la marca</option>
										<option value="7" <cfif isdefined('form.RHJMUsituacion2')> <cfif form.RHJMUsituacion2 EQ 7> selected </cfif></cfif>>Día libre</option>
									</select>
								</td>
								<td><input name="btnFiltrar" type="submit" value="Filtrar">
									<input name="btnLimpiar" type="button"  value="Limpiar">
								</td>
							</tr>
						</table>
					</form>
					<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
					<cfset UsuDEid = sec.getUsuarioByCod (session.Usucodigo, session.EcodigoSDC, 'DatosEmpleado')>
					

					<cfquery name="rsJustificaciones" datasource="#session.DSN#">
						select 
							RHJMUid,
							DEid,
							Ecodigo,
							RHJMUsituacion,
							case RHJMUsituacion
								when 0 then 'Todas'
								when 1 then 'Omisión de marca de entrada'
								when 2 then 'Omisión de marca de salida'
								when 3 then 'Llegada Tardía'
								when 4 then 'Salida Anticipada'
								when 5 then 'Horas extras antes de la marca'
								when 6 then 'Horas extras después de la marca'
								when 7 then 'Día Libre' end
							as RHJMUsituacionx,
							RHJMUfecha,
							RHJMUjustificacion,
							RHJMUprocesada
							
							<cfif isdefined('form.RHJMUfecha2') and len(trim(form.RHJMUfecha2))NEQ 0>
							,'#form.RHJMUfecha2#' as RHJMUfecha2
							</cfif>
							
							<cfif isdefined('form.RHJMUsituacion2') and len(trim(form.RHJMUsituacion2))NEQ 0>
							,'#form.RHJMUsituacion2#' as RHJMUsituacion2
							</cfif> 
							 
						from RHJustificacionMarcasUsuario 
						where  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#UsuDEid.llave#"> 
							and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							and RHJMUprocesada =0

							<cfif isdefined('form.RHJMUfecha2') and len(trim(form.RHJMUfecha2))NEQ 0>
								and RHJMUfecha = <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#LSDateFormat(LSParseDateTime(form.RHJMUfecha2), 'yyyy-mm-dd 00:00:00')#">
							</cfif>
							<cfif isdefined('form.RHJMUsituacion2') and len(trim(form.RHJMUsituacion2))NEQ 0>
								and RHJMUsituacion =<cfqueryparam value="#LSParseNumber(LSNumberFormat(form.RHJMUsituacion2,"_"))#" cfsqltype="cf_sql_integer">
							</cfif>
					</cfquery>
					
					<cfinvoke
						Component= "rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaEmpl">
							<cfinvokeargument name="query" value="#rsJustificaciones#"/>
							<cfinvokeargument name="desplegar" value="RHJMUfecha,RHJMUsituacionx"/>
							<cfinvokeargument name="etiquetas" value="Fecha,Situación"/>
							<cfinvokeargument name="formatos" value="D,V"/>
							<cfinvokeargument name="align" value="left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="justificacionAdelantadaMarca.cfm"/>
							<cfinvokeargument name="keys" value="RHJMUid"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>	
							<cfinvokeargument name="maxrows" value="10"/> 	
					</cfinvoke>
					
				</td>
				<td width="50%" valign="top">
					<!--- Form Justificaciones --->
				 	<cfinclude template="justificacionAdelantadaMarca-form.cfm">
				</td>
			  </tr>
			  
			  <tr  valign="top"  style=" border-top-color:#CCCCCC" >
			  	
				<td width="100%" align="center" colspan="2">
					
					<center>
						<table width="70%"><tr><td valign="top">
							<center><label>Lista de Justificaciones que se encuentran en proceso</label></center>
							<!--- Lista de Justificaciones q estan actualmente en un lote --->
							<cfquery name="rsJustificaciones2" datasource="#session.DSN#">
								select b.RHCMfregistro,b.RHCMhoraentrada, b.RHCMhorasalida, b.RHCMjustificacion  
								from  RHControlMarcas b, RHJustificacionMarcasUsuario a
									where a.DEid = b.DEid
									and a.RHJMUfecha = b.RHCMfregistro
									and a.RHJMUprocesada = 1
									and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#UsuDEid.llave#">  
							</cfquery>
							
							<cfinvoke
								Component= "rh.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaEmpl">
									<cfinvokeargument name="query" value="#rsJustificaciones2#"/>
									<cfinvokeargument name="desplegar" value="RHCMfregistro,RHCMhoraentrada, RHCMhorasalida, RHCMjustificacion"/>
									<cfinvokeargument name="etiquetas" value="Fecha,Hora Entrada,Hora Salida,Justificación"/>
									<cfinvokeargument name="formatos" value="D,D,D,V"/>
									<cfinvokeargument name="align" value="left,left,left,left"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="showLink" value="false"/>
									<cfinvokeargument name="irA" value="justificacionAdelantadaMarca.cfm"/>
									<cfinvokeargument name="keys" value="RHJMUid"/>
									<cfinvokeargument name="navegacion" value="#navegacion#"/>	
									<cfinvokeargument name="maxrows" value="10"/> 	
							</cfinvoke>
						</td></tr></table>	
					</center>
				</td>
			  </tr>
			</table>
			<br>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>

