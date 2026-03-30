<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="C&eacute;dula" returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Jornada" Default="Jornada" returnvariable="LB_Jornada"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Puesto" Default="Puesto" returnvariable="LB_Puesto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Escuela" Default="Escuela/Departamento" returnvariable="LB_Escuela"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Sede" Default="Sede" returnvariable="LB_Sede"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteFuncXPuesto" Default="Reporte de Funcionarios por Puesto" returnvariable="LB_ReporteFuncXPuesto"/>
<cfinvoke key="LB_ListaDePuestos" default="Lista de Puestos" returnvariable="LB_ListaDePuestos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>

<cfoutput>			
	<cfset LvarFileName = "FuncionariosXProfesor#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" colspan="6">
	<tr>
			<td align="center">
			<cf_htmlReportsHeaders 
				title= "#LB_ReporteFuncXPuesto#"
				filename="#LvarFileName#"
				irA="RepFuncProfesor-filtro.cfm"
				back="no"
				back2="yes">
					
				<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0" colspan="6">
					<tr>	
						<cfsavecontent variable="ENCABEZADO_IMP">
						<td align="center" colspan="6"><strong><font size="2">
						<cf_EncReporte
							Titulo="#LB_ReporteFuncXPuesto#"							
						>
						<tr class="tituloListas">
							<td><b>#LB_Identificacion#</b></td>														
							<td><b>#LB_Nombre#</b></td>		
							<td><b>#LB_Jornada#</b></td>		
							<td><b>#LB_Puesto#</b></td>		
							<td><b>#LB_Escuela#</b></td>	
							<td><b>#LB_Sede#</b></td>		
												
						</tr>
						</cfsavecontent>
						#ENCABEZADO_IMP#
					</tr>			
						<cfif rsConPorcenM50.RecordCount NEQ 0>
							<cfset actual = ''>							
							<cfloop query="rsConPorcenM50">
								<tr <cfif rsConPorcenM50.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
									<cfif actual NEQ rsConPorcenM50.DEidentificacion>
										<td><font  style="font-size:11px; font-family:'Arial'">#DEidentificacion#</font></td>
										<td><font  style="font-size:11px; font-family:'Arial'">#Nombre#</font></td>
										<td><font  style="font-size:11px; font-family:'Arial'">#jornada#</font></td>
										<td><font  style="font-size:11px; font-family:'Arial'">#puesto#</font></td>
										<td><font  style="font-size:11px; font-family:'Arial'">#escuela#</font></td>										<td><font  style="font-size:11px; font-family:'Arial'">#sede#</font></td>                      										 								
										<cfset actual = rsConPorcenM50.DEidentificacion>
									<cfelse>									
										<cfset actual = rsConPorcenM50.DEidentificacion>
									</cfif>								
								</tr>
							</cfloop>							
							<tr><td colspan="6" align="center" class="letra">--- <cf_translate key="MGS_FinDelReporte" xmlfile="/rh/generales.xml">Fin del Reporte</cf_translate> ---</td></tr>
						<cfelse>
							<tr><td colspan="6" align="center"><b>----- #LB_NoSeEncontraronRegistros# -----</b></td></tr>
						</cfif>		
				</table>			
			</td>
		</tr>
	</table>
</cfoutput>




