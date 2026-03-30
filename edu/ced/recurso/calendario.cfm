<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 31 de enero del 2006
	Motivo: Actualización de fuentes de educación a nuevos estándares de Pantallas y Componente de Listas.
 ---> 
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_template template="#session.sitio.template#">
	
	<cf_templatearea name="title">
		<cfoutput>#nav__SPdescripcion#</cfoutput>
	</cf_templatearea> 
	
	<cf_templatearea name="body">
		<cf_web_portlet titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->		
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>		
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfset form.Pagina = url.PageNum_Lista>
			</cfif>	
			
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
				<cfset form.Pagina = form.PageNum>
			</cfif>

			<cfif isdefined("Url.CDcodigo") and not isdefined("Form.CDcodigo")>
				<cfparam name="Form.CDcodigo" default="#Url.CDcodigo#">
			</cfif>
				
			<cfif isdefined("Url.FechaIni") and not isdefined("Form.FechaIni")>
				<cfparam name="Form.FechaIni" default="#Url.FechaIni#">
			</cfif>
			<cfif isdefined("Url.FechaFin") and not isdefined("Form.FechaFin")>
				<cfparam name="Form.FechaFin" default="#Url.FechaFin#">
			</cfif>
			<cfif isdefined("Url.Filtro_CDfecha") and not isdefined('Form.Filtro_CDfecha') >
				<cfparam name="Form.Filtro_CDfecha" default="#Url.Filtro_CDfecha#">
			</cfif>
			<cfif isdefined("Url.Filtro_CDferiadoIcono")and not isdefined('Form.Filtro_CDferiadoIcono')>
				<cfparam name="Form.Filtro_CDferiadoIcono" default="#Url.Filtro_CDferiadoIcono#">
			</cfif>
			<cfif isdefined("Url.Filtro_CDabsolutoIcono") and not isdefined('Form.Filtro_CDabsolutoIcono')>
				<cfparam name="Form.Filtro_CDabsolutoIcono" default="#Url.Filtro_CDabsolutoIcono#">
			</cfif>
			<cfif isdefined("Url.Filtro_CDtitulo") and not isdefined('Form.Filtro_CDtitulo')>
				<cfparam name="Form.Filtro_CDtitulo" default="#Url.Filtro_CDtitulo#">
			</cfif>
			<cfif isdefined("Url.Filtro_FechasMayores") and not isdefined('Form.Filtro_FechasMayores')>
				<cfparam name="Form.Filtro_FechasMayores" default="#Url.Filtro_FechasMayores#">
			</cfif>
			<cfparam name="form.FechaIni" default="">
			<cfparam name="form.FechaFin" default="">
			<cfparam name="form.Filtro_CDfecha" default="">
			<cfparam name="form.Filtro_CDabsolutoIcono" default="-1">
			<cfparam name="form.Filtro_CDferiadoIcono" default="-1">
			<cfparam name="form.Filtro_CDtitulo" default="">
			<cfparam name="form.Pagina" default="1">
            <!--- Consultas --->
            <cfquery name="rsCalendario" datasource="#Session.Edu.DSN#" >
            	Select convert(varchar,Ccodigo) as Ccodigo 
				from CentroEducativo 
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
            </cfquery>
			 <cfquery datasource="#Session.Edu.DSN#" name="rsAnio">
				select distinct(Datepart(yy,CDfecha)) as anio
				from sdc..CalendarioDia
				where Ccodigo=(
							Select Ccodigo 
							from CentroEducativo 
							where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">)
				union
				select datepart(yy,getdate()) as anio	
			</cfquery>
			<table width="100%" border="0" cellspacing="0" cellpadding="2" style="margin:0 ">
            	<tr> 
                	<td valign="top">
					<form name="lista" action="calendario.cfm" method="post" style="margin:0;">
						<cfparam name="form.MaxRows" default="15">
						<input type="hidden" name="MaxRows" value="<cfoutput>#form.MaxRows#</cfoutput>">
						<input name="Pagina" type="hidden" value="<cfif isdefined('form.Pagina')><cfoutput>#form.Pagina#</cfoutput></cfif>">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:0 ">
							<tr class="tituloListas"><td colspan="5">&nbsp;</td></tr>
							<tr class="tituloListas"> 
								<td>&nbsp;</td>
								<td align="right">Fecha Inicio:&nbsp;</td>
								<td>
									<cfif isdefined('form.FechaIni')><cfset fechaI= form.FechaIni><cfelse><cfset fechaI= ''></cfif>
									<cf_sifcalendario name="FechaIni" value="#fechaI#" form="lista">
								</td>
								<td align="right">Fecha Final:&nbsp;</td>
								<td>
									<cfif isdefined('form.FechaFin')><cfset fechaF= form.FechaFin><cfelse><cfset fechaF= ''></cfif>
									<cf_sifcalendario name="FechaFin" value="#fechaF#" form="lista">
								</td>
							</tr>
							<tr class="tituloListas"><td colspan="5">&nbsp;</td></tr>
							<tr> 
								<td colspan="5"> 
									<cfset filtro = "">
									<cfset navegacion = ""> 
									<cfif isdefined("Form.FechaIni") AND #Form.FechaIni# NEQ "" >
										<cfset filtro = #filtro# & " and CDfecha >= convert(datetime,'" & #form.FechaIni# &"',103)">
										<cfset navegacion = navegacion & "&FechaIni=" & Form.FechaIni>
									</cfif> 
									<cfif isdefined("Form.FechaFin") AND #Form.FechaFin# NEQ "" >
										<cfset filtro = #filtro# & " and CDfecha <= convert(datetime,'" & #form.FechaFin# &"',103)">
										<cfset navegacion = navegacion & "&FechaFin=" & Form.FechaFin>
									</cfif> 
									
									<cfset rsFeriado = QueryNew("value,description")>
									<cfset QueryAddRow(rsFeriado,1)>
									<cfset QuerySetCell(rsFeriado,"value", "-1",rsFeriado.RecordCount)>
									<cfset QuerySetCell(rsFeriado,"description", "Todos",rsFeriado.RecordCount)>
									<cfset QueryAddRow(rsFeriado,1)>
									<cfset QuerySetCell(rsFeriado,"value", "1",rsFeriado.RecordCount)>
									<cfset QuerySetCell(rsFeriado,"description", "Feriados",rsFeriado.RecordCount)>
									<cfset QueryAddRow(rsFeriado,1)>
									<cfset QuerySetCell(rsFeriado,"value", "0",rsFeriado.RecordCount)>
									<cfset QuerySetCell(rsFeriado,"description", "Regular",rsFeriado.RecordCount)>
									
									<cfset rsRecurrente = QueryNew("value,description")>
									<cfset QueryAddRow(rsRecurrente,1)>
									<cfset QuerySetCell(rsRecurrente,"value", "-1",rsRecurrente.RecordCount)>
									<cfset QuerySetCell(rsRecurrente,"description", "Todos",rsRecurrente.RecordCount)>
									<cfset QueryAddRow(rsRecurrente,1)>
									<cfset QuerySetCell(rsRecurrente,"value", "1",rsRecurrente.RecordCount)>
									<cfset QuerySetCell(rsRecurrente,"description", "Rec.",rsRecurrente.RecordCount)>
									<cfset QueryAddRow(rsRecurrente,1)>
									<cfset QuerySetCell(rsRecurrente,"value", "0",rsRecurrente.RecordCount)>
									<cfset QuerySetCell(rsRecurrente,"description", "Único",rsRecurrente.RecordCount)>

									<cfinvoke 
										component="edu.Componentes.pListas"
										method="pListaEdu"
										returnvariable="pListaCalendarioDia">
											<cfinvokeargument name="tabla" value="CalendarioDia"/>
											<cfinvokeargument name="columnas" value="convert(varchar,CDcodigo) as CDcodigo,
																					 case CDabsoluto when 1 then '<img border=''0'' src=''../../Imagenes/completa.gif''>' 
																					 	when 0 then '<img border=''0'' src=''../../Imagenes/unchecked.gif''>' else '' end as CDabsolutoIcono, 
																					 CDabsoluto,
																					 case CDferiado 
																					 when 1 then '<img border=''0'' src=''../../Imagenes/completa.gif''>' 
																					 when 0 then '<img border=''0'' src=''../../Imagenes/unchecked.gif''>' else '' end as CDferiadoIcono, 
																					 CDfecha,
																					 substring(CDtitulo,1,25) as CDtitulo,
																					 datepart(dd,CDfecha) as DiaOrden, datepart(mm,CDfecha) as MesOrden, 
																					 CDferiado,
																					 case CDabsoluto 
																					 when 0 then datepart(yy,getDate()) 
																					 else datepart(yy,CDfecha) end as AnoOrden, '' as e"/>
											<cfinvokeargument name="desplegar" value="CDFecha,CDtitulo,CDferiadoIcono,CDabsolutoIcono, e"/>
											<cfinvokeargument name="etiquetas" value="Fecha,T&iacute;tulo,Feriado, Recurrente, "/>
											<cfinvokeargument name="formatos" value="D,S,S,S,U"/>
											<cfinvokeargument name="filtrar_por" value="CDfecha,CDtitulo,CDferiado,CDabsoluto,''"/>
											<cfinvokeargument name="filtro" value="Ccodigo = #rsCalendario.Ccodigo# #filtro# order by CDfecha" />
											<cfinvokeargument name="align" value="left,left,center,center,left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="irA" value="calendario.cfm"/>
											<cfinvokeargument name="navegacion" value="#navegacion#"/>
											<cfinvokeargument name="debug" value="N"/>
											<cfinvokeargument name="conexion" value="#session.Edu.DSN#"/>
											<cfinvokeargument name="mostrar_filtro"		value="true"/>
											<cfinvokeargument name="filtrar_automatico"	value="true"/>
											<cfinvokeargument name="incluyeForm" value="false"/>
											<cfinvokeargument name="formName" value="lista"/>
											<cfinvokeargument name="keys" value="CDcodigo"/>
											<cfinvokeargument name="rsCDferiadoIcono" value="#rsFeriado#"/>
											<cfinvokeargument name="rsCDabsolutoIcono" value="#rsRecurrente#"/>
											<cfinvokeargument name="MaxRows"		value="#form.MaxRows#"/>
									</cfinvoke>
								</td>
							</tr>					
						</table>
					</form>
					</td>
					<td valign="top"> <cfinclude template="formCalendario.cfm"> </td>
				</tr>
			</table>
		
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>