<cfif isdefined("url.CFpkdesde") and not isdefined("form.CFpkdesde")>
	<cfset form.CFpkdesde = url.CFpkdesde >
</cfif>
<cfif isdefined("url.CFpkhasta") and not isdefined("form.CFpkhasta")>
	<cfset form.CFpkhasta = url.CFpkhasta >
</cfif>
<cfif isdefined("url.mostrarplazas") and not isdefined("form.mostrarplazas")>
	<cfset form.mostrarplazas = url.mostrarplazas >
</cfif>
<cfif isdefined("url.desplegarnombre") and not isdefined("form.desplegarnombre")>
	<cfset form.desplegarnombre = url.desplegarnombre >
</cfif>
<!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->
<cfif isdefined("url.mostrardependencia") and not isdefined("form.mostrardependencia")>
	<cfset form.mostrardependencia = url.mostrardependencia >
</cfif>
<!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->

<cfif len(trim(form.CFpkdesde)) eq 0 >
	<cfquery name="data_desde" datasource="#session.DSN#">
		select min(CFid) as CFpk
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFpath = ( select min(CFpath) 
		  				 from CFuncional 
						 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
	</cfquery>
	<cfset form.CFpkdesde = data_desde.CFpk >
</cfif>
<cfif len(trim(form.CFpkhasta)) eq 0 >
	<cfquery name="data_hasta" datasource="#session.DSN#">
		select max(CFid) as CFpk
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFpath = ( select max(CFpath) 
		  				 from CFuncional 
						 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
	</cfquery>
	<cfset form.CFpkhasta = data_hasta.CFpk >
</cfif>

<cfif len(trim(form.CFpkdesde))>
	<cfquery name="data_desde" datasource="#session.DSN#">
		select CFcodigo, CFdescripcion, CFpath
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpkdesde#">
	</cfquery>
</cfif>
<cfif len(trim(form.CFpkhasta))>
	<cfquery name="data_hasta" datasource="#session.DSN#">
		select CFcodigo, CFdescripcion, CFpath
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpkhasta#">
	</cfquery>
</cfif>


<cfsavecontent variable="myquery">
	<cfoutput>
	select 	cf.CFpath,
			cf.CFnivel, 
			p.CFid, 
			cf.CFcodigo, 
			cf2.CFpath as papa,
			cf.CFdescripcion,
			cf.CFnivel,
			p.RHPid, 
			p.RHPcodigo, 
			p.RHPdescripcion, 
			p.RHPpuesto, 
			coalesce(ltrim(rtrim(pu.RHPcodigoext)),ltrim(rtrim(pu.RHPcodigo))) as RHpuestocodigo, 
			pu.RHPdescpuesto as RHpuestodesc
			<cfif isdefined("form.mostrarplazas") and  ListContains('O,T', form.mostrarplazas )>
				, <cf_dbfunction name="date_format" args="ev.EVfantig,dd/mm/yyyy"> as LTdesde
				
				, coalesce(de.DEidentificacion, '--VACANTE--') as DEidentificacion
				
				<cfif isdefined("form.desplegarnombre") and form.desplegarnombre eq 'NA'>
					<!---, DEnombre || ' ' || DEapellido1 || ' ' || DEapellido2 as Empleado--->
					, {fn concat({fn concat({fn concat({fn concat(DEnombre ,' ') }, DEapellido1)}, ' ')}, DEapellido2)}  as Empleado
				<cfelse>	
					<!---, DEapellido1 || ' ' || DEapellido2 || ' ' || DEnombre as Empleado--->
					, {fn concat({fn concat({fn concat({fn concat(DEapellido1 ,' ') }, DEapellido2)}, ' ')}, DEnombre)}  as Empleado
				</cfif>
				
				, lt.LTsalario
			</cfif>	
	
	from RHPlazas p
	
	inner join CFuncional cf
	on cf.CFid=p.CFid
		and cf.Ecodigo=p.Ecodigo
		and cf.CFpath between '#data_desde.CFpath#' and '#data_hasta.CFpath#'
	
	inner join CFuncional cf2
	on cf2.CFid=coalesce(cf.CFidresp, cf.CFid)
	
	inner join RHPuestos pu
	on pu.RHPcodigo=p.RHPpuesto
	and pu.Ecodigo=p.Ecodigo
	
	<cfif isdefined("form.mostrarplazas")>
		<cfif form.mostrarplazas eq 'T' >
			left join LineaTiempo lt
			on lt.RHPid=p.RHPid
			and lt.Ecodigo=p.Ecodigo
			and <cf_dbfunction name="to_date" args="'#LSDateFormat(now(), "dd/mm/yyyy")#'"> between LTdesde and LThasta
			
			left join DatosEmpleado de 
			on de.DEid=lt.DEid
			and de.Ecodigo=lt.Ecodigo
			
			left join EVacacionesEmpleado ev
				on ev.DEid = de.DEid 
				
		<cfelseif form.mostrarplazas eq 'O' >
			inner join LineaTiempo lt
			on lt.RHPid=p.RHPid
			and lt.Ecodigo=p.Ecodigo
			and <cf_dbfunction name="to_date" args="'#LSDateFormat(now(), "dd/mm/yyyy")#'"> between LTdesde and LThasta
			
			inner join DatosEmpleado de 
			on de.DEid=lt.DEid
			and de.Ecodigo=lt.Ecodigo
			
			inner join EVacacionesEmpleado ev
				on ev.DEid = de.DEid 

		</cfif>
	</cfif>	
	
	where p.Ecodigo = #session.Ecodigo#
	
	<!--- plazas vacantes --->
	<cfif isdefined("form.mostrarplazas") and form.mostrarplazas eq 'V' >
		and not exists( select 1
						from LineaTiempo lt
				
						inner join DatosEmpleado de		
						  on de.DEid=lt.DEid	
		
						where <cf_dbfunction name="to_date" args="'#LSDateFormat(now(), "dd/mm/yyyy")#'"> between lt.LTdesde and lt.LThasta
						  and lt.RHPid = p.RHPid
						  and lt.Ecodigo=p.Ecodigo )
	</cfif>
	
	order by cf.CFpath, p.RHPcodigo, pu.RHPcodigo <cfif isdefined("form.mostrarplazas") and  ListContains('O,T', form.mostrarplazas )>
													, ev.EVfantig
													, de.DEidentificacion
													, Empleado
												  </cfif>	
	</cfoutput>
</cfsavecontent>

<br>





 <!---<cf_htmlreportsheaders
			title="Empleados por Plaza" 
			filename="EmpleadosPlaza#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls" 
			ira="plazas-filtro.cfm">
			--->

<cfoutput>
<table width="90%" cellpadding="2" cellspacing="0" align="center">
	<tr>
		<td>
			<cfinvoke key="LB_Reporte_de_Empleado_por_Plaza" default="Reporte de Empleado por Plaza" returnvariable="LB_Reporte_de_Empleado_por_Plaza" component="sif.Componentes.Translate"  method="Translate"/>			
			<cfinvoke key="LB_CentroFuncionalDesde" default="Centro Funcional Desde" returnvariable="LB_CentroFuncionalDesde" component="sif.Componentes.Translate"  method="Translate"/>
			<cfinvoke key="LB_Hasta" default="Hasta" returnvariable="LB_Hasta" component="sif.Componentes.Translate"  method="Translate"/>
			<cfinvoke key="LB_MostrarPlazas" default="Mostrar plazas" returnvariable="LB_MostrarPlazas" component="sif.Componentes.Translate"  method="Translate"/>
			<cfinvoke key="LB_DesplegarNombre" default="Desplegar nombre" returnvariable="LB_DesplegarNombre" component="sif.Componentes.Translate"  method="Translate"/>
			<cfset filtro1 = '<b>#LB_CentroFuncionalDesde#:</b> #data_desde.CFcodigo# - #data_desde.CFdescripcion#   <b>#LB_Hasta#:</b> #data_hasta.CFcodigo# - #data_hasta.CFdescripcion#'> 
			<cfset filtro2 = '<b>#LB_MostrarPlazas#:</b> '>
			<cfset filtro3 = '<b>#LB_DesplegarNombre#:</b> '>			
			<cfif isdefined("form.mostrarplazas")>
				<cfif form.mostrarplazas eq 'T'>					
					<cfinvoke key="LB_Todas" default="Todas" returnvariable="LB_Todas" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro2 = filtro2&LB_Todas>
				<cfelseif form.mostrarplazas eq 'O'>
					<cfinvoke key="LB_Ocupadas" default="Ocupadas" returnvariable="LB_Ocupadas" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro2 = filtro2&LB_Ocupadas>
				<cfelse>					
					<cfinvoke key="LB_Vacantes" default="Vacantes" returnvariable="LB_Vacantes" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro2 = filtro2&LB_Vacantes>
				</cfif> 
			</cfif>
			<cfif isdefined("form.desplegarnombre")>
				<cfif form.desplegarnombre eq 'AN'>
					<cfinvoke key="LB_ApellidoNombre" default="Apellido - Nombre" returnvariable="LB_ApellidoNombre" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro3 = filtro3&LB_ApellidoNombre>
				<cfelse>
					<cfinvoke key="LB_NombreApellido" default="Nombre - Apellido" returnvariable="LB_NombreApellido" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro3 = filtro3&LB_NombreApellido>
				</cfif> 
			</cfif>
			<cf_EncReporte
				Titulo="#LB_Reporte_de_Empleado_por_Plaza#"
				Color="##E3EDEF"
				filtro1="#filtro1#"
				filtro2="#filtro2#"
				filtro3="#filtro3#"
			>
			
		</td>
	</tr>
</table>
<!---===================== ENCABEZADO ANTERIOR =====================
<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td align="center" ><strong><span class="empresa">#session.Enombre#</span></strong></td></tr>
	<tr><td align="center"><strong><span class="reporte"><cf_translate  key="LB_Reporte_de_Empleado_por_Plaza">Reporte de Empleado por Plaza</cf_translate></span></strong></td></tr>
	<tr><td align="center"><strong><cf_translate  key="LB_Centro_Funcional_Desde">Centro Funcional Desde</cf_translate>:</strong> #data_desde.CFcodigo# - #data_desde.CFdescripcion# <strong><cf_translate  key="LB_Hasta">Hasta</cf_translate>:</strong> #data_hasta.CFcodigo# - #data_hasta.CFdescripcion#</td></tr>	
	<tr><td align="center"><strong><cf_translate  key="LB_Mostrar_plazas">Mostrar plazas</cf_translate>:</strong> <cfif isdefined("form.mostrarplazas")><cfif form.mostrarplazas eq 'T'><cf_translate  key="LB_Todas">Todas</cf_translate><cfelseif form.mostrarplazas eq 'O'><cf_translate  key="LB_Ocupadas">Ocupadas</cf_translate><cfelse><cf_translate  key="LB_Vacantes">Vacantes</cf_translate></cfif> </cfif></td></tr>		
	<tr><td align="center"><strong><cf_translate  key="LB_Desplegar_nombre">Desplegar nombre</cf_translate>:</strong> <cfif isdefined("form.desplegarnombre")><cfif form.desplegarnombre eq 'AN'><cf_translate  key="LB_Apellido_Nombre">Apellido-Nombre</cf_translate><cfelse><cf_translate  key="LB_Nombre_Apellido">Nombre-Apellido</cf_translate></cfif> </cfif></td></tr>
</table>
----->
<br>
</cfoutput>

<table width="90%" align="center" cellpadding="2" cellspacing="0" border="0">

<!---<cfset cf_pintados = structnew() >--->
<cfset cf_indentado = structnew() >

<cftry>
	<cfflush interval="8000">
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#preservesinglequotes(myquery)#</cfoutput>
	</cf_jdbcquery_open>

	<cfset cuantos = 0 >
	<cfset indentar = 0 >
	<cfset indentar_constante = 20 >
	<cfoutput query="data" group="CFpath">
		<!---<cfset structInsert(cf_pintados, CFpath, CFnivel) >--->
		<tr>
			<cfif structKeyExists(cf_indentado, papa ) >
				<cfset indentar = cf_indentado[papa] + 1 >
			<cfelse>
				<!--- buscar alguno de los ancestros para indentarlo segun su posicion.
				      Ej: Tengo el CF RAIZ(1) y el CF RAIZ/01/02(2), el problema es cuando esta el CF (1) y (2) y no esta el papa de (2)
					  	  en este caso no esta RAIZ/01, papa de (2), entonces el pintado se desordena pues pinta (2) sin indentar, 
						  mi idea es pintarlo segun el nivel del ancestro que este pintado, en este ejemplo esta pintado RAIZ, 
						  entonces pintaria (2) segun la posicion de RAIZ(1)
				--->
				<cfset tmp_path = listtoarray(CFpath, "/") >
				<cfset indentar = 0 >
				<cfloop from="1" to="#arraylen(tmp_path)#" index="i">
					<cfset tmp_ruta = '' >
					<cfloop from="1" to="#arraylen(tmp_path)-i#" index="j">
						<cfif j eq 1 >
							<cfset tmp_ruta = tmp_ruta & tmp_path[j] >
						<cfelse>
							<cfset tmp_ruta = tmp_ruta & '/' & tmp_path[j] >
						</cfif>
					</cfloop>
					<cfif structKeyExists(cf_indentado, tmp_ruta ) >
						<cfset indentar = cf_indentado[tmp_ruta] + 1 >
						<cfbreak>
					</cfif>	
				</cfloop>
			</cfif>
			<cfset structInsert(cf_indentado, CFpath, indentar) >
			
            <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'><!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->
			<cfloop from="1" to="#indentar#" index="i">
				<td width="5%">&nbsp;</td>
			</cfloop>
            </cfif>
			<td colspan="<cfif isdefined("form.mostrarplazas") and  ListContains('O,T', form.mostrarplazas )>#(indentar_constante*7)+indentar#<cfelse>#(indentar_constante*4)+indentar#</cfif>" bgcolor="##CCCCCC" style="padding:4px;"><strong><cf_translate  key="LB_Centro_Funcional">Centro Funcional</cf_translate>:&nbsp;</strong>#trim(CFcodigo)# - #CFdescripcion#</td>
		</tr>
		<tr>
        	<cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'><!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->
			<cfloop from="1" to="#indentar#" index="i">
				<td width="5%">&nbsp;</td>
			</cfloop>
            </cfif>
			<td class="tituloListas" <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif>><cf_translate  key="LB_Codigo_Plaza">C&oacute;digo Plaza</cf_translate></td>
			<td class="tituloListas"  <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif>><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
			<td class="tituloListas"  <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif>><cf_translate  key="LB_Puesto">Puesto</cf_translate></td>			
			<cfif isdefined("form.mostrarplazas") and  ListContains('O,T', form.mostrarplazas )>
				<td class="tituloListas"  <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif>><cf_translate  key="LB_Fecha_Desde">Fecha Desde</cf_translate></td>
				<td class="tituloListas" <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif>><cf_translate  key="LB_Empleado">Empleado</cf_translate></td>
				<td class="tituloListas" <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif>>&nbsp;</td>
				<td class="tituloListas" align="right"  <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif>><cf_translate  key="LB_Salario">Salario</cf_translate></td>
			<cfelse>
				<td class="tituloListas"  <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif>>&nbsp;</td>
			</cfif>
		</tr>

		<cfoutput>
			<tr>
                <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'><!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->
				<cfloop from="1" to="#indentar#" index="i">
					<td width="5%">&nbsp;</td>
				</cfloop>
                </cfif>
				<td <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif><!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.---> >#trim(RHPcodigo)#</td>
				<td <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif><!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->>#RHPdescripcion#</td>
				<td <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif><!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->>#trim(RHpuestocodigo)#-#trim(RHpuestodesc)#</td>
				<cfif isdefined("form.mostrarplazas") and  ListContains('O,T', form.mostrarplazas )>
					<td <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif><!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->><cfif len(trim(LTdesde)) eq 10 >#LSDateFormat(trim(LTdesde), 'dd/mm/yyyy')#</cfif></td>
					<td <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif><!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->>#DEidentificacion#</td>
					<td <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif><!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->>#Empleado#</td>
					<td align="right" <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif><!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->><cfif len(trim(LTsalario)) >#LSNumberFormat(LTsalario,',9.00')#</cfif></td>
				<cfelse>
					<td <cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>colspan="#indentar_constante#"</cfif><!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->>#RHpuestodesc#</td>				
				</cfif>	
			</tr>
			<cfset cuantos = cuantos + 1 >
		</cfoutput>
		
		<tr><td>&nbsp;</td></tr>
	</cfoutput>
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfthrow object="#cfcatch#">
</cfcatch>
</cftry>
	<cf_jdbcquery_close>

</table>

<cfif cuantos gt 0 >
	<table width="100%" cellpadding="0" cellspacing="0"><tr><td align="center">----- <cf_translate  key="LB_Fin_del_reporte">Fin del reporte</cf_translate> ------</td></tr></table>
<cfelse>
	<table width="100%" cellpadding="0" cellspacing="0"><tr><td align="center">----- <cf_translate  key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate> ------</td></tr></table>
</cfif>