
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
			<cfif isdefined('url.NoMatr') and not isdefined('form.NoMatr')>
				<cfset form.NoMatr = url.NoMatr>
			</cfif>
			<cfif isdefined('url.Filtro_Grado') and not isdefined('form.Filtro_Grado')>
				<cfset form.Filtro_Grado = url.Filtro_Grado>
			</cfif>
			<!--- query´s para lista--->
			<cfquery datasource="#Session.Edu.DSN#" name="rsNiveles">
				select  -1  as value, 'Todos' as description
				union
				select Ncodigo as value, Ndescripcion as description
				from Nivel 
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				order by value
			</cfquery>
			<cfquery datasource="#Session.Edu.DSN#" name="rsGrado">
				select  -1  as value, 'Todos' as description, -1 as Ncodigo
				union
				select b.Gcodigo as value, 
					   b.Gdescripcion as description, a.Ncodigo
				from Nivel a, Grado b
				where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and a.Ncodigo = b.Ncodigo 
				order by value
			</cfquery>
			<cfquery name="rsEstado" datasource="#session.Edu.DSN#">
				select -1 as value, 'Todos' as description
				union
				select 0 as value, 'Activo' as description
				union
				select 1 as value, 'Retirado' as description
				union
				select 2 as value, 'Graduado' as description
				order by value
			</cfquery>

			<cfparam name="form.Pagina" default="1">
			<form name="form1" action="alumno.cfm" method="post">
			<cfoutput>
				<input name="Pagina" type="hidden" value="#form.Pagina#">
			</cfoutput>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						
						<!--- ============================================================== --->
						<!--- ============================================================== --->
												
						<tr>
							<td align="right" class="titulolistas">
								<input name="NoMatr" type="checkbox" class="areaFiltro" id="NoMatr" 
									onClick="javascript: noMatr(this);" 
									value="1" <cfif isdefined("Form.NoMatr") and Form.NoMatr EQ '1'>checked</cfif>>
								<label for="NoMatr">No matriculados en este per&iacute;odo</label>
							</td>
						</tr>
						<!--- ============================================================== --->
						<!---  Creacion del filtro --->
						<!--- ============================================================== --->
						<!--- Filtra solo los alumnos NO matriculados en el periodo actual --->
						<cfset filtro="">
						<cfset navegacion="">
						<cfset filtroRetirados ="">
						<cfif isdefined("Form.NoMatr") and Form.NoMatr EQ '1'>
							<cfset f6 = Form.NoMatr>
							 <cfset filtro = " and a.persona not in (
															select distinct a.persona
															from PersonaEducativo a
															inner join Alumnos b
															   on a.persona = b.persona 
															  and a.CEcodigo = b.CEcodigo 
															inner join Estudiante c
															   on b.persona = c.persona
															  and b.Ecodigo = c.Ecodigo
															inner join Promocion d
															   on b.PRcodigo = d.PRcodigo
															inner join PeriodoVigente e
															   on d.PEcodigo = e.PEcodigo
															  and d.Ncodigo = e.Ncodigo
															inner join Grupo f
															   on e.Ncodigo = f.Ncodigo
															  and e.PEcodigo = f.PEcodigo
															  and e.SPEcodigo = f.SPEcodigo
															where a.CEcodigo = #Session.Edu.CEcodigo#)">
								<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "NoMatr=1">																						
						</cfif>
						<tr>
							<td>
								<cfinvoke 
								 component="edu.Componentes.pListas"
								 method="pListaEdu"
								 returnvariable="pListaPlanEvalDet">
									<cfinvokeargument name="tabla" value="PersonaEducativo a
																			inner join Pais b
																			   on a.Ppais = b.Ppais
																			inner join Alumnos c
																			   on a.persona = c.persona
																			  and a.CEcodigo = c.CEcodigo
																			inner join Estudiante d
																			   on c.persona = d.persona
																			  and c.Ecodigo = d.Ecodigo 
																			inner join Promocion e
																			   on c.PRcodigo = e.PRcodigo
																			  and e.PRactivo = 1
																			inner join Grado f
																			   on e.Gcodigo = f.Gcodigo
																			  and e.Ncodigo = f.Ncodigo
																			inner join Nivel g
																			   on f.Ncodigo = g.Ncodigo "/>
									<cfinvokeargument name="columnas" value="
										convert(varchar,a.persona) as persona,
										1 as o, 
										a.Papellido1 + ' ' + a.Papellido2 + ',' + a.Pnombre as nombre,
										 b.Pnombre,
										convert(varchar,a.Pnacimiento,103) as Pnacimiento, 
										a.Pid,
										f.Gdescripcion as Grado,
										e.Ncodigo,
										g.Ndescripcion,
										case when c.Aretirado=0 then 'Activo' when c.Aretirado=1 then 'Retirado' when c.Aretirado=2 then 'Graduado' end as Estado
																			 "/> 
									<cfinvokeargument name="desplegar" 		value="nombre,Pid,Ndescripcion,Grado,Estado"/>
									<cfinvokeargument name="etiquetas" 		value="Nombre,Identificaci&oacute;n, Nivel, Grado,Estado"/>
									<cfinvokeargument name="formatos" 		value="S,S,S,S,S"/>
									<cfinvokeargument name="filtrar_por" 	value="a.Papellido1 || ' ' || a.Papellido2 || ' ' || a.Pnombre,Pid,e.Ncodigo,f.Gcodigo,c.Aretirado"/>
									<cfinvokeargument name="filtro" 		value="a.CEcodigo = #Session.Edu.CEcodigo#
																					#filtroRetirados# #filtro#
																				order by g.Norden,f.Gorden,e.Gcodigo,c.nombre"/>
									<cfinvokeargument name="align" 			value="left,left,left,left,left"/>
									<cfinvokeargument name="ajustar" 		value="N"/>
									<cfinvokeargument name="irA" 			value="alumno.cfm"/>
									<cfinvokeargument name="cortes" 		value="Grado"/>
									<cfinvokeargument name="navegacion" 	value="#navegacion#"/>
									<cfinvokeargument name="conexion" 		value="#Session.Edu.DSN#"/>
									<cfinvokeargument name="debug" 			value="N"/>
									<cfinvokeargument name="formName" 		value="form1"/>
									<cfinvokeargument name="botones"		value="Nuevo"/>
									<cfinvokeargument name="incluyeForm" 	value="false"/>
									<cfinvokeargument name="mostrar_filtro" value="true"/>
									<cfinvokeargument name="filtrar_automatico" value="true"/>
									<cfinvokeargument name="rsNdescripcion" value="#rsNiveles#"/>
									<cfinvokeargument name="rsGrado" 		value="#rsGrado#"/>
									<cfinvokeargument name="rsEstado" 		value="#rsEstado#"/>
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
									<cfinvokeargument name="keys"			value="persona"/>
								</cfinvoke>
								<cf_qforms>
								<script>
									objForm.filtro_Ndescripcion.addEvent('onChange', 'llenarGrados(this.value);', true);
									function llenarGrados(v){
										var combo = objForm.filtro_Grado.obj;
										var cont = 0;
										combo.length=1;
										combo.options[cont].value='-1';
										combo.options[cont].text='Todos';
										<cfoutput query="rsGrado">
											if (#rsGrado.Ncodigo#==v)
											{
												cont++;
												combo.length=cont+1;
												combo.options[cont].value='#rsGrado.value#';
												combo.options[cont].text='#rsGrado.description#';
												
												<cfif isdefined("form.Filtro_Grado") and len(trim(form.Filtro_Grado))>
													if (#form.Filtro_Grado#==#rsGrado.value#) combo.options[cont].selected = true;
												</cfif>
											};
										</cfoutput>
									}
									llenarGrados(objForm.filtro_Ndescripcion.getValue());
								</script>
						</td>
					</tr>
				</table>
			</form>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
<script>
	function noMatr(obj){
		if(obj.checked){
			//obj.form.FAretirado.checked = false;
			obj.form.NoMatr.value = 1;
			obj.form.NoMatr.checked = true;
		}else{
			obj.form.NoMatr.value= 0;
			obj.form.NoMatr.checked = false;
		}
	}
</script>