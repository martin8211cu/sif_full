<table width="100%">
	<tr>
		<td>
			<!--- ============================================================== --->
			<!---  Creacion del filtro --->
			<!--- ============================================================== --->
			 <cfset f1 = "">
			 <cfset f2 = "">
			 <cfset f3 = "-1">
			 <cfset f4 = "0">
			 <cfset f5 = "-1">
			 <cfset f6 = "0">
			 <cfset filtro = "">
			 <cfset navegacion = "">

			<!--- Filtra solo los alumnos NO matriculados en el periodo actual --->
			<cfif isdefined("Form.NoMatr") and Form.NoMatr EQ '1'>
				<cfset f6 = Form.NoMatr>
				 <cfset filtro = " and a.persona not in (
								select distinct a.persona
								from PersonaEducativo a,Alumnos b,Estudiante c,Promocion d, PeriodoVigente e, Grupo f
								where a.CEcodigo = #Session.Edu.CEcodigo#
									and a.persona=b.persona	
									and a.CEcodigo=b.CEcodigo 
									and b.persona=c.persona 
									and b.Ecodigo=c.Ecodigo
									and b.PRcodigo=d.PRcodigo
									and d.Ncodigo=e.Ncodigo
									and d.PEcodigo=e.PEcodigo
									and e.Ncodigo=f.Ncodigo
									and e.PEcodigo=f.PEcodigo
									and e.SPEcodigo=f.SPEcodigo)">
					)
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "NoMatr=1">																						
			</cfif>

			<cfif isdefined("Form.fRHnombre") AND Form.fRHnombre NEQ "" >
				<cfset filtro = filtro &" and upper((a.Pnombre + ' ' + Papellido1 + ' ' + Papellido2)) like upper('%" & #Form.fRHnombre# & "%')">							
				<cfset f1 = Form.fRHnombre>
				<cfset navegacion = "fRHnombre=" & Form.fRHnombre>						
			</cfif>
			<cfif isdefined("Form.filtroRhPid") AND Form.filtroRhPid NEQ "">	
				<cfset filtro = filtro &" and upper(Pid) like upper('%" & Form.filtroRhPid & "%')">
				<cfset f2 = Form.filtroRhPid>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtroRhPid=" & Form.filtroRhPid>						
			</cfif>
										
			<cfif isdefined("Form.FAretirado") and Form.FAretirado EQ '1'>	
				<cfset filtro = filtro &" and Aretirado=1">
				<cfset f4 = Form.FAretirado>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAretirado=1">														
			</cfif>
			<cfif isdefined("Form.FNcodigo") AND Form.FNcodigo NEQ "-1" >
				<cfset filtro = filtro & " and e.Ncodigo=" & Form.FNcodigo>
				<cfset f3 = Form.FNcodigo>							
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FNcodigo=" & Form.FNcodigo>						
			</cfif>
			<cfif isdefined("Form.FGcodigo") AND Form.FGcodigo NEQ "-1">							
				<cfset filtro = filtro &" and e.Gcodigo=" & Form.FGcodigo>																																																																							
				<cfset f5 = Form.FGcodigo>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FGcodigo=" & Form.FGcodigo>						
			</cfif>
			
			<cfif isdefined("Form.Busca") AND Form.Busca NEQ "">  <!--- Parametros pasados cuando se busca desde  --->								
				<cfif isdefined("Form.Pnombre") AND Form.Pnombre NEQ "">	
					<cfset filtro = filtro &" and upper(a.Pnombre) like upper('%" & Form.Pnombre & "%')">														
				</cfif>
				<cfif isdefined("Form.Papellido1") AND #Form.Papellido1# NEQ "">	
					<cfset filtro = #filtro# &" and upper(Papellido1) like upper('%" & #Form.Papellido1# & "%')">																					
				</cfif>							
				<cfif isdefined("Form.Papellido2") AND #Form.Papellido2# NEQ "">	
					<cfset filtro = #filtro# &" and upper(Papellido2) like upper('%" & #Form.Papellido2# & "%')">																												
				</cfif>								
				<cfif isdefined("Form.Pid") AND #Form.Pid# NEQ "">	
					<cfset filtro = #filtro# &" and upper(Pid) like upper('%" & #Form.Pid# & "%')">							
				</cfif>								
				<cfif isdefined("Form.Pdireccion") AND #Form.Pdireccion# NEQ "">	
					<cfset filtro = #filtro# &" and upper(Pdireccion) like upper('%" & #Form.Pdireccion# & "%')">															
				</cfif>								
				<cfif isdefined("Form.Pcasa") AND #Form.Pcasa# NEQ "">	
					<cfset filtro = #filtro# &" and upper(Pcasa) like upper('%" & #Form.Pcasa# & "%')">																							
				</cfif>								
				<cfif isdefined("Form.Poficina") AND #Form.Poficina# NEQ "">	
					<cfset filtro = #filtro# &" and upper(Poficina) like upper('%" & #Form.Poficina# & "%')">
				</cfif>								
				<cfif isdefined("Form.Pcelular") AND #Form.Pcelular# NEQ "">	
					<cfset filtro = #filtro# &" and upper(Pcelular) like upper('%" & #Form.Pcelular# & "%')">
				</cfif>								
				<cfif isdefined("Form.Pfax") AND #Form.Pfax# NEQ "">	
					<cfset filtro = #filtro# &" and upper(Pfax) like upper('%" & #Form.Pfax# & "%')">																																															
				</cfif>								
				<cfif isdefined("Form.Ppagertel") AND #Form.Ppagertel# NEQ "">	
					<cfset filtro = #filtro# &" and upper(Ppagertel) like upper('%" & #Form.Ppagertel# & "%')">																																																							
				</cfif>								
				<cfif isdefined("Form.Ppagernum") AND #Form.Ppagernum# NEQ "">	
					<cfset filtro = #filtro# &" and upper(Ppagernum) like upper('%" & #Form.Ppagernum# & "%')">																																																															
				</cfif>								
				<cfif isdefined("Form.Pemail1") AND #Form.Pemail1# NEQ "">	
					<cfset filtro = #filtro# &" and upper(Pemail1) like upper('%" & #Form.Pemail1# & "%')">																																																							
				</cfif>								
				<cfif isdefined("Form.Pemail2") AND #Form.Pemail2# NEQ "">	
					<cfset filtro = #filtro# &" and upper(Pemail2) like upper('%" & #Form.Pemail2# & "%')">																																																																							
				</cfif>								
			</cfif>							
			<!--- ============================================================== --->
			<!--- ============================================================== --->
			  <tr>
				<td>
					<cfif isdefined("Form.FAretirado")>	
						<cfset filtroRetirados = "">
					<cfelse>
						<cfset filtroRetirados = " and c.Aretirado = 0 ">
					</cfif>
					<cfinvoke 
					 component="edu.Componentes.pListas"
					 method="pListaEdu"
					 returnvariable="pListaPlanEvalDet">
						<cfinvokeargument name="tabla" value="PersonaEducativo a, Pais b, Alumnos c, Estudiante d, Grado f, Promocion e, Nivel g "/>
 						<cfinvokeargument name="columnas" value="rtrim('#f1#') as fRHnombre,rtrim('#f2#') as filtroRhPid,'#f3#' as FNcodigo,'#f4#' as FAretirado,'#f5#' as FGcodigo,'#f6#' as NoMatr,
							a.persona,
							(a.Papellido1 + ' ' + a.Papellido2 + ',' + a.Pnombre) as nombre,
							 b.Pnombre,
							convert(varchar,a.Pnacimiento,103) as Pnacimiento, 
							a.Pid,
							f.Gdescripcion as Grado,
							case when c.Aretirado=0 then 'Activo' when c.Aretirado=1 then 'Retirado' when c.Aretirado=2 then 'Graduado' end as estado
																 "/> 
						<cfinvokeargument name="desplegar" value="nombre,Pnombre,Pid,Pnacimiento"/>
						<cfinvokeargument name="etiquetas" value="Nombre,Pa&iacute;s,N. Identificaci&oacute;n,Fecha de Nacimiento"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="filtro" value="
												a.CEcodigo = #Session.Edu.CEcodigo#
												  and e.PRactivo = 1 
												  and a.Ppais=b.Ppais 
												  and a.persona=c.persona 
												  and a.CEcodigo=c.CEcodigo 
												  and c.persona=d.persona 
												  and c.Ecodigo=d.Ecodigo 
												  and c.PRcodigo=e.PRcodigo 
												  and e.Gcodigo=f.Gcodigo 
												  and e.Ncodigo=f.Ncodigo 
												  and f.Ncodigo=g.Ncodigo #filtroRetirados# #filtro#
												order by g.Norden,f.Gorden,e.Gcodigo,c.nombre
												  
															   " />
						<cfinvokeargument name="align" value="left,center,center,center"/>

						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="alumno.cfm"/>
						<cfinvokeargument name="cortes" value="Grado"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>						
						<cfinvokeargument name="debug" value="N"/>						
					</cfinvoke>
				</td>
			  </tr>
			</table>