<cfinclude template="/rh/Utiles/params.cfm">
<cfset Session.Params.ModoDespliegue = 1>
<cfset Session.cache_empresarial = 0>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificación"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"	
	returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Marca"
	Default="Marca"	
	returnvariable="LB_Marca"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha"
	Default="Fecha"	
	returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Entrada"
	Default="Entrada"	
	returnvariable="LB_Entrada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Salida"
	Default="Salida"	
	returnvariable="LB_Salida"/>
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso"
		Default="Usted no tiene grupos asociados. No puede acceder este proceso."
		returnvariable="MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso"/>
<cfquery name="rsGrupos" datasource="#session.DSN#">
	select  b.Gid, b.Gdescripcion
	from RHCMAutorizadoresGrupo a
		inner join RHCMGrupos b
			on a.Gid = b.Gid
			and a.Ecodigo = b.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Usucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>
<cfif rsGrupos.recordcount eq 0>
	<cf_throw message="#MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso#" errorcode="5110">
<cfelseif rsGrupos.recordcount eq 1>
	<cfparam name="Form.FAGrupo" default="#rsGrupos.Gid#">
</cfif>
<!--- DAG 04/06/2007: SE ESTANDARIZA PARA DBMSS: ORACLE, MSSQLSERVER, SYBASE --->
<!--- Date Part de fecha hora marca --->
<cf_dbfunction name="date_part" args="hh, d.fechahoramarca" returnvariable="Lvar_fechahoramarca_hh">
<cf_dbfunction name="date_part" args="mi, d.fechahoramarca" returnvariable="Lvar_fechahoramarca_mi">
<!--- To char del Date Part de fecha hora marca --->
<cf_dbfunction name="to_char" args="#Lvar_fechahoramarca_hh#" returnvariable="Lvar_to_char_fechahoramarca_hh">
<cf_dbfunction name="to_char" args="#Lvar_fechahoramarca_hh#-12" returnvariable="Lvar_to_char_fechahoramarca_hh_m12">
<cf_dbfunction name="to_char" args="#Lvar_fechahoramarca_mi#" returnvariable="Lvar_to_char_fechahoramarca_mi">
<cfquery name="rsLista" datasource="#session.DSN#">
	select	d.fechahoramarca,
			d.RHCMid,
			d.DEid,
			d.grupomarcas,
			d.tipomarca,
			c.DEidentificacion as idEmpleado,
			{fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)} as Empleado,
				case when d.tipomarca = 'E' or d.tipomarca = 'EB' then 
					case 	when ((#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#)) > 12 then 
								{fn concat((#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_hh_m12)#),
									{fn concat(':',{fn concat(case len((#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#))	when 1 then
																	{fn concat('0',(#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#))}
																else
																	(#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#)
																end, 
													{fn concat(' ',case when ((#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#)) < 12 then 'AM' else 'PM' 	end	)})}
									)}
								)}													
							when ((#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#)) = 0 then 
								{fn concat('12',{fn concat(':',
												{fn concat(case len((#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#))	when 1 then
																{fn concat('0',(#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#))}
															else
																(#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#)
															end,{fn concat(' ',case when ((#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#)) < 12 then 'AM' else 'PM' end)}
													)}
												)}
								)}																										
							else 
								{fn concat((#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_hh)#),
									{fn concat(':',
										{fn concat(case len((#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#))	when 1 then
														{fn concat('0',(#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#))}
													else
														(#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#)
													end,{fn concat(' ',case when ((#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#)) < 12 then 'AM' else 'PM' 	end	)}
										)}
									)}
								)}													
					end 
				else
					'&nbsp;'
				end as Entrada,
				case when d.tipomarca = 'S' or d.tipomarca = 'SB' then 
					case 	when ((#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#)) > 12 then 
								{fn concat((#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_hh_m12)#),
									{fn concat(':',{fn concat(case len((#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#))	when 1 then
																	{fn concat('0',(#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#))}
																else
																	(#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#)
																end, 
													{fn concat(' ',case when ((#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#)) < 12 then 'AM' else 'PM' 	end	)})}
									)}
								)}													
							when ((#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#)) = 0 then 
								{fn concat('12',{fn concat(':',
												{fn concat(case len((#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#))	when 1 then
																{fn concat('0',(#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#))}
															else
																(#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#)
															end,{fn concat(' ',case when ((#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#)) < 12 then 'AM' else 'PM' end)}
													)}
												)}
								)}																										
							else 
								{fn concat((#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_hh)#),
									{fn concat(':',
										{fn concat(case len((#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#))	when 1 then
														{fn concat('0',(#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#))}
													else
														(#PreserveSingleQuotes(Lvar_to_char_fechahoramarca_mi)#)
													end,{fn concat(' ',case when ((#PreserveSingleQuotes(Lvar_fechahoramarca_hh)#)) < 12 then 'AM' else 'PM' 	end	)}
										)}
									)}
								)}													
					end 
				else
					'&nbsp;'
				end as Salida
	from RHCMAutorizadoresGrupo a
		inner join RHCMEmpleadosGrupo b
			on a.Gid = b.Gid
			and a.Ecodigo = b.Ecodigo
		inner join RHControlMarcas d
			on b.DEid = d.DEid
			and b.Ecodigo = d.Ecodigo
			and d.registroaut = 1															
			and d.numlote is null
			and d.grupomarcas is null
		inner join DatosEmpleado c
			on b.DEid = c.DEid
			and b.Ecodigo = c.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		and a.Gid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsGrupos.Gid)#" list="true">)
	order by {fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)}, d.fechahoramarca asc
</cfquery>
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Encabezado"
Default="Reporte De Marcas Sin Agrupar por Usuario"
returnvariable="LB_Encabezado"/> 

<cf_htmlReportsHeaders 
	irA="RevMarcas-AgruparReporte-PopUp.cfm"
	FileName="ReporteDeMarcasSinAgrupar.xls"
	title="#LB_Encabezado#"
	back=false
	close=true>
<!--- <cf_templatecss> --->
<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
	<cfoutput>
	<tr><td colspan="5" align="center">
	<cf_EncReporte
		Titulo   ="#LB_Encabezado#" 
		MostrarPagina="false">
    <!--- <strong><cf_translate key="LB_ReporteDeMarcasSinAgrupar">Reporte De Marcas Sin Agrupar</cf_translate></strong> --->
    </td></tr>
	
	<tr>
		<td nowrap width="6%"><strong>#LB_Identificacion#</strong>&nbsp;</td>
		<td nowrap width="40%"><strong>#LB_Empleado#</strong>&nbsp;</td>
		<td nowrap width="13%" align="center"><strong>#LB_Marca#</strong>&nbsp;</td>
		<td nowrap width="16%" align="center"><strong>#LB_Fecha#</strong>&nbsp;</td>
		<td nowrap width="11%"><strong>#LB_Entrada#</strong>&nbsp;</td>
		<td nowrap width="11%"><strong>#LB_Salida#</strong>&nbsp;</td>
	</tr>
	</cfoutput>
	<cfoutput query="rsLista">
		<tr class="<cfif rsLista.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td nowrap width="6%">#rsLista.idEmpleado#</td>
			<td nowrap width="40%">#rsLista.Empleado#</td>
			<td nowrap width="13%" align="center">#rsLista.tipomarca#</td>
			<td nowrap width="16%" align="center">#LSDateFormat(rsLista.fechahoramarca,'dd/mm/yyyy')#</td>
			<td nowrap width="11%">#rsLista.Entrada#</td>
			<td nowrap width="11%">#rsLista.Salida#</td>
		</tr>
	</cfoutput>
	<tr><td colspan="5" align="center"><strong><cf_translate key="LB_FinDelReporte">--Fin Del Reporte--</cf_translate></strong></td></tr>
</table>