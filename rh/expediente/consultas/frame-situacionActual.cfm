<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Semanal"
Default="Semanal"	
returnvariable="LB_Semanal"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Bisemanal"
Default="Bisemanal"	
returnvariable="LB_Bisemanal"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Quincenal"
Default="Quincenal"	
returnvariable="LB_Quincenal"/>

<!--- <cf_dump var="#rsEmpleado#"> --->

<cfquery name="rsSituacionActual" datasource="#Session.DSN#">
	select 	a.LTid, 
			rtrim(a.Tcodigo) as Tcodigo, 
		   	a.RVid, 
			a.Ocodigo, 
		   	a.Dcodigo, 
			a.RHPid, 
		   	rtrim(a.RHPcodigo) as RHPcodigo, 
		   	a.RHJid,
		   	a.LTporcplaza, 
			a.LTporcsal, 
			a.LTsalario,
		   	b.Tdescripcion, 
			c.Descripcion as RegVacaciones, 
			d.Odescripcion, 
			e.Ddescripcion, 
		   	f.RHPdescripcion, 
			rtrim(f.RHPcodigo) as CodPlaza, 
			rtrim(g.RHPcodigo) as CodPuesto, 
		   	f.Dcodigo as CodDepto, 
			f.Ocodigo as CodOfic,
			{fn concat({fn concat(rtrim(f.RHPcodigo) , ' - ' )},  f.RHPdescripcion )} as Plaza,
		   	g.RHPdescpuesto, 
			{fn concat({fn concat(coalesce(ltrim(rtrim(g.RHPcodigoext)),ltrim(rtrim(g.RHPcodigo))) , ' - ' )},  g.RHPdescpuesto)}  as Puesto,
		   	{fn concat({fn concat(rtrim(j.RHJcodigo) , ' - ' )},  j.RHJdescripcion )} as Jornada,
		   	cf.CFcodigo, 
			cf.CFdescripcion

	from LineaTiempo a
	
	inner join TiposNomina b
	on a.Tcodigo = b.Tcodigo
	and a.Ecodigo = b.Ecodigo	<!---=====09/01/2008======--->
	
	inner join RegimenVacaciones c
	on a.RVid = c.RVid
	
	inner join Oficinas d
	on a.Ocodigo = d.Ocodigo
	and a.Ecodigo = d.Ecodigo
	
	inner join Departamentos e
	on a.Dcodigo = e.Dcodigo
	and a.Ecodigo = e.Ecodigo

	inner join RHPlazas f
	on a.RHPid = f.RHPid
	and a.Ecodigo = f.Ecodigo

	inner join RHPuestos g
	on a.RHPcodigo = g.RHPcodigo
	and a.Ecodigo = g.Ecodigo

	inner join RHJornadas j
	on a.Ecodigo = j.Ecodigo
	and a.RHJid = j.RHJid

	inner join CFuncional cf
	on f.CFid = cf.CFid

	where <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between a.LTdesde and a.LThasta
	  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">

</cfquery>

<cfif rsSituacionActual.recordCount GT 0>
	<cfquery name="rsComponentesActual" datasource="#Session.DSN#">
		select b.CSid, 
			   c.CScodigo, 
			   c.CSdescripcion,
			   coalesce(b.DLTmonto, 0.00) as DLTmonto, 
			   coalesce(b.DLTunidades, 0.00) as DLTunidades, 
			   b.DLTtabla, 
			   c.CSdescripcion,
			   b.CIid
		from DLineaTiempo b
		
		inner join ComponentesSalariales c
		on b.CSid = c.CSid
		
		where b.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSituacionActual.LTid#">

		order by c.CScodigo, c.CSdescripcion
	</cfquery>
	<cfif rsComponentesActual.recordCount GT 0>
		<cfquery name="rsSumComponentesActual" dbtype="query">
			select sum(DLTmonto) as Total 
			from rsComponentesActual
			where CIid is null
		</cfquery>
	</cfif>

	<cfoutput>
	<cfif isdefined("rsEmpleado.DEporcAnticipo") and len(trim(rsEmpleado.DEporcAnticipo)) >
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
		<tr>
			<td colspan="2" class="#Session.Preferences.Skin#_thcenter"><cf_translate key="LB_AnticipoDeSalario">Anticipo de Salario</cf_translate></td>
		</tr>
		<tr>
			<td width="27%" height="25" class="fileLabel" nowrap><cf_translate key="PorcentejeDelAnticipo">Porcentaje del Anticipo</cf_translate></td>
			<td> #LSCurrencyFormat(rsEmpleado.DEporcAnticipo,'none')#%</td>
		</tr>
	</table>
	</cfif>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td width="55%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
			  <tr>
				<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="SituacionActual">Situaci&oacute;n Actual</cf_translate></div>
				</td>
			  </tr>
			  <tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="TipoNomina">Tipo de N&oacute;mina</cf_translate></td>
				<td height="25" nowrap>#rsSituacionActual.Tdescripcion#</td>
			  </tr>
			  <tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="RegimenDeVacaciones">R&eacute;gimen de Vacaciones</cf_translate></td>
				<td height="25" nowrap>#rsSituacionActual.RegVacaciones#</td>
			  </tr>
			  <tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate></td>
				<td height="25" nowrap>#rsSituacionActual.Odescripcion#</td>
			  </tr>
			  <tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="Departamento">Departamento</cf_translate></td>
				<td height="25" nowrap>#rsSituacionActual.Ddescripcion#</td>
			  </tr>
			  <tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="CentroFuncional">Centro Funcional</cf_translate></td>
				<td height="25" nowrap>#rsSituacionActual.CFcodigo# - #rsSituacionActual.CFdescripcion#</td>
			  </tr>
			  <tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="Puesto">Puesto</cf_translate></td>
				<td height="25" nowrap>#rsSituacionActual.Puesto#</td>
			  </tr>
			  <tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="Plaza">Plaza</cf_translate></td>
				<td height="25" nowrap>#rsSituacionActual.Plaza#</td>
			  </tr>
			  <tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="PorcentajeDePlaza">Porcentaje de Plaza</cf_translate></td>
				<td height="25" nowrap><cfif rsSituacionActual.LTporcplaza NEQ "">
					#LSCurrencyFormat(rsSituacionActual.LTporcplaza,'none')# %
						<cfelse>
						0.00 %
				  </cfif>
				</td>
			  </tr>
			  <tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="PorcentajeDeSalarioFijo">Porcentaje de Salario Fijo</cf_translate></td>
				<td height="25" nowrap><cfif rsSituacionActual.LTporcsal NEQ "">
					#LSCurrencyFormat(rsSituacionActual.LTporcsal,'none')# %
						<cfelse>
						0.00 %
				  </cfif>
				</td>
			  </tr>
			  <tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="Jornada">Jornada</cf_translate></td>
				<td height="25" nowrap>#rsSituacionActual.Jornada#</td>
			  </tr>
			</table>
		</td>
		<td width="45%" valign="top" style="padding-left: 5px;">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
			  <cfif isdefined("rsComponentesActual") and rsComponentesActual.recordCount GT 0>
				<cfquery name="rsMostrarSalarioNominal" datasource="#session.DSN#">
					select coalesce(Pvalor,'0') as  Pvalor
					from RHParametros
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Pcodigo = 1040
				</cfquery>
				
				
				
				<tr>
				  <td class="#Session.Preferences.Skin#_thcenter" colspan="3"><div align="center"><cf_translate key="ComponentesActuales">Componentes Actuales</cf_translate></div>
				  </td>
				</tr>
				<tr>
				  <td class="tituloListas" colspan="2" nowrap><cf_translate key="SalarioTotal">Salario Total</cf_translate>: </td>
				  <td class="tituloListas" align="right" nowrap>#LSCurrencyFormat(rsSumComponentesActual.Total,'none')#</td>
				</tr>
				<cfif rsMostrarSalarioNominal.Pvalor eq 1>
						<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
							select 
								Ttipopago,
								case Ttipopago when 0 then '#LB_Semanal#'
								when 1 then '#LB_Bisemanal#'
								when 2 then '#LB_Quincenal#'
								else ''
								end as   descripcion
							from TiposNomina 
							where 
							Ecodigo 	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSituacionActual.Tcodigo#">
						</cfquery>		
						<cfif rsTiposNomina.Ttipopago neq 3>
							<cfinvoke component="rh.Componentes.RH_Funciones" 
								method="salarioTipoNomina"
								salario = "#rsSumComponentesActual.Total#"
								Tcodigo = "#rsSituacionActual.Tcodigo#"
								returnvariable="var_salarioTipoNomina">
							  <tr>
								<td class="tituloListas" colspan="2" nowrap><cf_translate key="LB_Salario">Salario</cf_translate>&nbsp;#rsTiposNomina.descripcion#:</td>
								<td class="tituloListas" align="right" nowrap>#LSNumberFormat(var_salarioTipoNomina,',9.00')#</td>
							  </tr>
												  
					  </cfif>
				  </cfif>
				
				
				<tr>
				  <td colspan="3" height="25">&nbsp;</td>
				</tr>
				<tr>
				  <td class="tituloListas" nowrap><cf_translate key="Componente">Componente</cf_translate></td>
				  <td class="tituloListas" align="center" nowrap><!--- Cantidad --->
				  </td>
				  <td class="tituloListas" align="right" nowrap><cf_translate key="Monto">Monto</cf_translate></td>
				</tr>
				<cfloop query="rsComponentesActual">
				  <cfif Len(Trim(rsComponentesActual.CIid))>
					<cfset color = ' style="color: ##FF0000;"'>
				  <cfelse>
					<cfset color = ''>
				  </cfif>
				  <tr>
					<td height="25" class="fileLabel"#color# nowrap>#rsComponentesActual.CSdescripcion#</td>
					<td height="25" align="center"#color# nowrap>
					  <!--- NO BORRAR PORQUE PUEDE SER UTILIZADO POSTERIORMENTE
										#LSCurrencyFormat(rsComponentesActual.DLTunidades,'none')# --->&nbsp;
					</td>
					<td height="25" align="right"#color# nowrap>#LSCurrencyFormat(rsComponentesActual.DLTmonto,'none')#</td>
				  </tr>
				</cfloop>
				  <tr>
					<td colspan="3" align="center" style="color: ##FF0000; border-top: 1px solid gray; ">
						<cf_translate key="MSG_LosComponentesQueAparecenEnColorRojoSePaganEnFormaIncidente">Los componentes que aparecen en color rojo se pagan en forma incidente.</cf_translate>
					</td>
				  </tr>
			  </cfif>
			</table>
		</td>
	  </tr>
	</table>
	</cfoutput>
<cfelse>
	<div>
		<font color="#FF0000"><b>
			<cf_translate key="MSG_EsteEmpleadoNoSeEncuentaNombradoEnEsteMomento">Este empleado no se encuentra nombrado en este momento</cf_translate>
		</b></font>	
	</div>
</cfif>
