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
			<cfif isdefined("url.Filtro_RHnombre") and not isdefined("form.Filtro_RHnombre")>
				<cfset "form.Filtro_RHnombre"  ="#url.Filtro_RHnombre#">
			</cfif>
			<cfif isdefined("url.Filtro_RHPid") and not isdefined("form.Filtro_RHPid")>
				<cfset "form.Filtro_RHPid"  ="#trim(url.Filtro_RHPid)#">
			</cfif>		
			<cfif isdefined("url.filtrado") and not isdefined("form.filtrado")>
				<cfset "form.filtrado"  ="#url.filtrado#">
			</cfif>	
			<cfif isdefined("url.btnFiltrar") and not isdefined("form.btnFiltrar")>
				<cfset "form.btnFiltrar"  ="#url.btnFiltrar#">
			</cfif>
			
			<cfif isdefined("url.Filtro_Tipo") and not isdefined("form.Filtro_Tipo")>
				<cfset "form.Filtro_Tipo"  ="#url.Filtro_Tipo#">
			</cfif>
			<cfif isdefined("url.Filtro_Pmail1") and not isdefined("form.Filtro_Pmail1")>
				<cfset "form.Filtro_Pmail1"  ="#trim(url.Filtro_Pmail1)#">
			</cfif>		
			<cfif isdefined("url.Filtro_Pcasa") and not isdefined("form.Filtro_Pcasa")>
				<cfset "form.Filtro_Pcasa"  ="#url.Filtro_Pcasa#">
			</cfif>	
			
			<cfif isdefined("url.Filtro_Poficina") and not isdefined("form.Filtro_Poficina")>
				<cfset "form.Filtro_Poficina"  ="#url.Filtro_Poficina#">
			</cfif>
			<cfif isdefined("url.Filtro_Pcelular") and not isdefined("form.Filtro_Pcelular")>
				<cfset "form.Filtro_Pcelular"  ="#trim(url.Filtro_Pcelular)#">
			</cfif>		
			<cfif isdefined("url.Filtro_Pmail2") and not isdefined("form.Filtro_Pmail2")>
				<cfset "form.Filtro_Pmail2"  ="#url.Filtro_Pmail2#">
			</cfif>	
			
			<cfif isdefined("url.Filtro_Pagertel") and not isdefined("form.Filtro_Pagertel")>
				<cfset "form.Filtro_Pagertel"  ="#url.Filtro_Pagertel#">
			</cfif>
			<cfif isdefined("url.Filtro_Pagernum") and not isdefined("form.Filtro_Pagernum")>
				<cfset "form.Filtro_Pagernum"  ="#trim(url.Filtro_Pagernum)#">
			</cfif>		
			<cfif isdefined("url.Filtro_Pfax") and not isdefined("form.Filtro_Pfax")>
				<cfset "form.Filtro_Pfax"  ="#url.Filtro_Pfax#">
			</cfif>	
			
			<cfif isdefined("url.persona") and not isdefined("form.persona")>
				<cfset "form.persona"  ="#url.persona#">
			</cfif>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr class="titulolistas"><td>&nbsp;</td></tr>
				<tr style="display: ;" id="verformFiltroListaPers">
					<td>
						<cfinclude template="filtros/filtroRh.cfm">
					</td>
				</tr>
			</table>
			
			<cfset navegacion = "">
			<cfif isdefined('Form.persona') and LEN(TRIM(Form.persona))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "persona=" & Form.persona>
			</cfif>
			<cfif isdefined('Form.sel') and LEN(TRIM(Form.sel))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & Form.sel>
			</cfif>
			<cfif isdefined('Form.Filtro_RHnombre') and LEN(TRIM(Form.Filtro_RHnombre))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_RHnombre=" & Form.Filtro_RHnombre>
			</cfif>
			<cfif isdefined('Form.Filtro_RhPid') and LEN(TRIM(Form.Filtro_RhPid))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_RhPid=" & Form.Filtro_RhPid>
			</cfif>
			<cfif isdefined('Form.Filtro_Tipo') and LEN(TRIM(Form.Filtro_Tipo))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Tipo=" & Form.Filtro_Tipo>
			</cfif>
			<cfif isdefined('Form.Filtro_Pmail1') and LEN(TRIM(Form.Filtro_Pmail1))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Pmail1=" & Form.Filtro_Pmail1>
			</cfif>
			<cfif isdefined('Form.Filtro_Pcasa') and LEN(TRIM(Form.Filtro_Pcasa))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Pcasa=" & Form.Filtro_Pcasa>
			</cfif>
			<cfif isdefined('Form.Filtro_Poficina') and LEN(TRIM(Form.Filtro_Poficina))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Poficina=" & Form.Filtro_Poficina>
			</cfif>
			<cfif isdefined('Form.Filtro_Pcelular') and LEN(TRIM(Form.Filtro_Pcelular))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Pcelular=" & Form.Filtro_Pcelular>
			</cfif>
			<cfif isdefined('Form.Filtro_Pmail2') and LEN(TRIM(Form.Filtro_Pmail2))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Pmail2=" & Form.Filtro_Pmail2>
			</cfif>
			<cfif isdefined('Form.Filtro_Pagertel') and LEN(TRIM(Form.Filtro_Pagertel))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Pagertel=" & Form.Filtro_Pagertel>
			</cfif>
			<cfif isdefined('Form.Filtro_Pagernum') and LEN(TRIM(Form.Filtro_Pagernum))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Pagernum=" & Form.Filtro_Pagernum>
			</cfif>
			<cfif isdefined('Form.Filtro_Pfax') and LEN(TRIM(Form.Filtro_Pfax))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Pfax=" & Form.Filtro_Pfax>
			</cfif>

			
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.Filtro_Tipo" default="-1">
			
			
			<cfquery name="rsLista" datasource="#session.Edu.DSN#">
				<cfif isdefined('form.Filtro_Tipo') and (form.Filtro_Tipo EQ 'D' or form.Filtro_Tipo EQ '-1')>
					select distinct 
						a.persona,( Papellido1 + ' ' + Papellido2 + ' ' + a.Pnombre ) as nombre,
						b.Pnombre,
						convert(varchar,Pnacimiento,103) as Pnacimiento, 
						Pid, 
						1 as parametro, 
						'Docente' as Rol, 
						Splaza as IDRol
					from PersonaEducativo a, Pais b, Staff s 
					where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					  and a.Ppais=b.Ppais 
					  and a.persona = s.persona 
					  and a.persona not in 
							( select persona from Alumnos where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
							   and persona not in (select persona from Asistente where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> ) 
							   and persona not in (select persona from Staff where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> ) 
							   and persona not in (select a.persona from Encargado a, PersonaEducativo b 
													where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> and a.persona=b.persona) 
							   and persona not in (select a.persona from Director a, PersonaEducativo b 
													where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> and a.persona=b.persona)
							) 
					<cfif isdefined('form.Filtro_RHnombre') and LEN(TRIM(form.Filtro_RHnombre))>
					  and upper((a.Pnombre + ' ' + Papellido1 + ' ' + Papellido2)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_RHnombre)#%">
					</cfif>
					<cfif isdefined("form.Filtro_RHPid") and len(trim(form.Filtro_RHPid))>
					  and upper(ltrim(rtrim(Pid))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_RHPid)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pmail1") and len(trim(form.Filtro_Pmail1))>
					  and upper(ltrim(rtrim(Pemail1))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pmail1)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pcasa") and len(trim(form.Filtro_Pcasa))>
					  and upper(ltrim(rtrim(Pcasa))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pcasa)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Poficina") and len(trim(form.Filtro_Poficina))>
					  and upper(ltrim(rtrim(Poficina))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Poficina)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pcelular") and len(trim(form.Filtro_Pcelular))>
					  and upper(ltrim(rtrim(Pcelular))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pcelular)#%">
					</cfif>							
					<cfif isdefined("form.Filtro_Pmail2") and len(trim(form.Filtro_Pmail2))>
					  and upper(ltrim(rtrim(Pemail2))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pmail2)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pagertel") and len(trim(form.Filtro_Pagertel))>
					  and upper(ltrim(rtrim(Ppagertel))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pagertel)#%">
					</cfif>		
					<cfif isdefined("form.Filtro_Pagernum") and len(trim(form.Filtro_Pagernum))>
					  and upper(ltrim(rtrim(Ppagernum))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pagernum)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pfax") and len(trim(form.Filtro_Pfax))>
					  and upper(ltrim(rtrim(Pfax))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pfax)#%">
					</cfif>					
				</cfif>
				<cfif isdefined('form.Filtro_Tipo') and form.Filtro_Tipo EQ '-1'>
				union all
				</cfif>
				<cfif isdefined('form.Filtro_Tipo') and (form.Filtro_Tipo EQ 'A' or form.Filtro_Tipo EQ '-1')>
					select distinct 
						a.persona,
						( Papellido1 + ' ' + Papellido2 + ' ' + a.Pnombre ) as nombre,
						b.Pnombre,
						convert(varchar,Pnacimiento,103) as Pnacimiento, 
						Pid, 
						1 as parametro, 
						'Asistente' as Rol, 
						Acodigo as IDRol
					from PersonaEducativo a, Pais b, Asistente asist 
					where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">  
					  and a.Ppais=b.Ppais 
					  and a.persona = asist.persona 
					  and a.persona not in 
						( select persona 
						  from Alumnos 
						  where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">  
							and persona not in (select persona from Asistente where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">  ) 
							and persona not in (select persona from Staff where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">  ) 
							and persona not in (select a.persona 
												from Encargado a, PersonaEducativo b 
												where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
												  and a.persona=b.persona) 
							and persona not in (select a.persona 
												from Director a, PersonaEducativo b 
												where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
												  and a.persona=b.persona)
						) 
					<cfif isdefined('form.Filtro_RHnombre') and LEN(TRIM(form.Filtro_RHnombre))>
					  and upper((a.Pnombre + ' ' + Papellido1 + ' ' + Papellido2)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_RHnombre)#%">
					</cfif>
					<cfif isdefined("form.Filtro_RHPid") and len(trim(form.Filtro_RHPid))>
					  and upper(ltrim(rtrim(Pid))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_RHPid)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pmail1") and len(trim(form.Filtro_Pmail1))>
					  and upper(ltrim(rtrim(Pemail1))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pmail1)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pcasa") and len(trim(form.Filtro_Pcasa))>
					  and upper(ltrim(rtrim(Pcasa))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pcasa)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Poficina") and len(trim(form.Filtro_Poficina))>
					  and upper(ltrim(rtrim(Poficina))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Poficina)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pcelular") and len(trim(form.Filtro_Pcelular))>
					  and upper(ltrim(rtrim(Pcelular))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pcelular)#%">
					</cfif>							
					<cfif isdefined("form.Filtro_Pmail2") and len(trim(form.Filtro_Pmail2))>
					  and upper(ltrim(rtrim(Pemail2))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pmail2)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pagertel") and len(trim(form.Filtro_Pagertel))>
					  and upper(ltrim(rtrim(Ppagertel))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pagertel)#%">
					</cfif>		
					<cfif isdefined("form.Filtro_Pagernum") and len(trim(form.Filtro_Pagernum))>
					  and upper(ltrim(rtrim(Ppagernum))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pagernum)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pfax") and len(trim(form.Filtro_Pfax))>
					  and upper(ltrim(rtrim(Pfax))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pfax)#%">
					</cfif>

				</cfif>
				<cfif isdefined('form.Filtro_Tipo') and form.Filtro_Tipo EQ '-1'>
				union all
				</cfif>
				<cfif isdefined('form.Filtro_Tipo') and (form.Filtro_Tipo EQ 'DR' or form.Filtro_Tipo EQ '-1')>
					select distinct 
						a.persona,
						( Papellido1 + ' ' + Papellido2 + ' ' + a.Pnombre ) as nombre,
						b.Pnombre,
						convert(varchar,Pnacimiento,103) as Pnacimiento, 
						Pid, 
						1 as parametro, 
						'Director' as Rol, 
						Dcodigo as IDRol
					from PersonaEducativo a, Pais b, Director dir 
					where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
					  and a.Ppais=b.Ppais 
					  and a.persona = dir.persona 
					  and a.persona not in 
						(select persona 
						 from Alumnos 
						 where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
						   and persona not in (select persona from Asistente where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> ) 
						   and persona not in (select persona from Staff where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> ) 
						   and persona not in (select a.persona 
											   from Encargado a, PersonaEducativo b 
											   where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
												 and a.persona=b.persona) 
						   and persona not in (select a.persona 
											   from Director a, PersonaEducativo b
											   where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
												 and a.persona=b.persona)
							) 
					<cfif isdefined('form.Filtro_RHnombre') and LEN(TRIM(form.Filtro_RHnombre))>
					  and upper((a.Pnombre + ' ' + Papellido1 + ' ' + Papellido2)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_RHnombre)#%">
					</cfif>
					<cfif isdefined("form.Filtro_RHPid") and len(trim(form.Filtro_RHPid))>
					  and upper(ltrim(rtrim(Pid))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_RHPid)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pmail1") and len(trim(form.Filtro_Pmail1))>
					  and upper(ltrim(rtrim(Pemail1))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pmail1)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pcasa") and len(trim(form.Filtro_Pcasa))>
					  and upper(ltrim(rtrim(Pcasa))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pcasa)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Poficina") and len(trim(form.Filtro_Poficina))>
					  and upper(ltrim(rtrim(Poficina))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Poficina)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pcelular") and len(trim(form.Filtro_Pcelular))>
					  and upper(ltrim(rtrim(Pcelular))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pcelular)#%">
					</cfif>							
					<cfif isdefined("form.Filtro_Pmail2") and len(trim(form.Filtro_Pmail2))>
					  and upper(ltrim(rtrim(Pemail2))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pmail2)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pagertel") and len(trim(form.Filtro_Pagertel))>
					  and upper(ltrim(rtrim(Ppagertel))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pagertel)#%">
					</cfif>		
					<cfif isdefined("form.Filtro_Pagernum") and len(trim(form.Filtro_Pagernum))>
					  and upper(ltrim(rtrim(Ppagernum))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pagernum)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pfax") and len(trim(form.Filtro_Pfax))>
					  and upper(ltrim(rtrim(Pfax))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pfax)#%">
					</cfif>
				</cfif>
				<cfif isdefined('form.Filtro_Tipo') and form.Filtro_Tipo EQ '-1'>
				union all
				</cfif>
				<cfif isdefined('form.Filtro_Tipo') and (form.Filtro_Tipo EQ 'E' or form.Filtro_Tipo EQ '-1')>
					select distinct 
						a.persona,
						( Papellido1 + ' ' + Papellido2 + ' ' + a.Pnombre ) as nombre,
						b.Pnombre,
						convert(varchar,Pnacimiento,103) as Pnacimiento, 
						Pid, 
						1 as parametro, 
						'Encargado' as Rol, 
						EEcodigo as IDRol
					from PersonaEducativo a, Pais b, Encargado e 
					where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
					  and a.Ppais=b.Ppais 
					  and a.persona = e.persona 
					  and a.persona not in 
						( select persona 
						  from Alumnos 
						  where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
							and persona not in (select persona from Asistente where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> ) 
							and persona not in (select persona from Staff where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> ) 
							and persona not in (select a.persona 
												from Encargado a, PersonaEducativo b 
												where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
												  and a.persona=b.persona) 
							and persona not in (select a.persona 
												from Director a, PersonaEducativo b 
												where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
												  and a.persona = b.persona)
						)
						<cfif isdefined('form.Filtro_RHnombre') and LEN(TRIM(form.Filtro_RHnombre))>
					  and upper((a.Pnombre + ' ' + Papellido1 + ' ' + Papellido2)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_RHnombre)#%">
					</cfif>
					<cfif isdefined("form.Filtro_RHPid") and len(trim(form.Filtro_RHPid))>
					  and upper(ltrim(rtrim(Pid))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_RHPid)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pmail1") and len(trim(form.Filtro_Pmail1))>
					  and upper(ltrim(rtrim(Pemail1))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pmail1)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pcasa") and len(trim(form.Filtro_Pcasa))>
					  and upper(ltrim(rtrim(Pcasa))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pcasa)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Poficina") and len(trim(form.Filtro_Poficina))>
					  and upper(ltrim(rtrim(Poficina))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Poficina)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pcelular") and len(trim(form.Filtro_Pcelular))>
					  and upper(ltrim(rtrim(Pcelular))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pcelular)#%">
					</cfif>							
					<cfif isdefined("form.Filtro_Pmail2") and len(trim(form.Filtro_Pmail2))>
					  and upper(ltrim(rtrim(Pemail2))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pmail2)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pagertel") and len(trim(form.Filtro_Pagertel))>
					  and upper(ltrim(rtrim(Ppagertel))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pagertel)#%">
					</cfif>		
					<cfif isdefined("form.Filtro_Pagernum") and len(trim(form.Filtro_Pagernum))>
					  and upper(ltrim(rtrim(Ppagernum))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pagernum)#%">
					</cfif>
					<cfif isdefined("form.Filtro_Pfax") and len(trim(form.Filtro_Pfax))>
					  and upper(ltrim(rtrim(Pfax))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Pfax)#%">
					</cfif>
					</cfif>
			</cfquery>
			<form name="lista" method="post" action="rh.cfm" style="margin:0">
				<cfoutput>
				<input name="Pagina" type="hidden" value="#form.Pagina#">
				<input name="Filtro_RHnombre" type="hidden" value="<cfif isdefined('form.Filtro_RHnombre')>#form.Filtro_RHnombre#</cfif>">
				<input name="Filtro_RhPid" type="hidden" value="<cfif isdefined('form.Filtro_RhPid')>#form.Filtro_RhPid#</cfif>">
				<input name="Filtro_Tipo" type="hidden" value="<cfif isdefined('form.Filtro_Tipo')>#form.Filtro_Tipo#<cfelse>-1</cfif>">
				<input name="Filtro_Pmail1" type="hidden" value="<cfif isdefined('form.Filtro_Pmail1')>#form.Filtro_Pmail1#</cfif>">
				<input name="Filtro_Pcasa" type="hidden" value="<cfif isdefined('form.Filtro_Pcasa')>#form.Filtro_Pcasa#</cfif>">
				<input name="Filtro_Poficina" type="hidden" value="<cfif isdefined('form.Filtro_Poficina')>#form.Filtro_Poficina#</cfif>">
				<input name="Filtro_Pcelular" type="hidden" value="<cfif isdefined('form.Filtro_Pcelular')>#form.Filtro_Pcelular#</cfif>">
				<input name="Filtro_Pmail2" type="hidden" value="<cfif isdefined('form.Filtro_Pmail2')>#form.Filtro_Pmail2#</cfif>">
				<input name="Filtro_Pagertel" type="hidden" value="<cfif isdefined('form.Filtro_Pagertel')>#form.Filtro_Pagertel#</cfif>">
				<input name="Filtro_Pagernum" type="hidden" value="<cfif isdefined('form.Filtro_Pagernum')>#form.Filtro_Pagernum#</cfif>">
				<input name="Filtro_Pfax" type="hidden" value="<cfif isdefined('form.Filtro_Pfax')>#form.Filtro_Pfax#</cfif>">
				</cfoutput>
			<cfinvoke 
				 component="edu.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaPlanEvalDet">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="columnas" value="distinct a.persona,( Papellido1 + ' ' + Papellido2 + ' ' + a.Pnombre  ) as nombre,b.Pnombre,convert(varchar,Pnacimiento,103) as Pnacimiento, Pid, Rol"/> 
					<cfinvokeargument name="desplegar" value="nombre,Pnombre, Pid, Pnacimiento"/>
					<cfinvokeargument name="etiquetas" value="Nombre,Pa&iacute;s,N. Identificaci&oacute;n,Fecha de Nacimiento"/>
					<cfinvokeargument name="formatos" value="S,S,S,S"/>
					<cfinvokeargument name="align" value="left,center,center,center"/>
					<cfinvokeargument name="ajustar" value="S"/>
					<cfinvokeargument name="formName" value="lista"/>
					<cfinvokeargument name="incluyeForm" value="false"/>
					<cfinvokeargument name="keys" value="persona"/>
					<cfinvokeargument name="checkboxes" value="n"/>
					<cfinvokeargument name="botones" value="Nuevo"/>
					<cfinvokeargument name="irA" value="rh.cfm"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="conexion" value="#Session.Edu.DSN#"/>
					<cfinvokeargument name="debug" value="N"/>
				</cfinvoke>	
			</form>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>

