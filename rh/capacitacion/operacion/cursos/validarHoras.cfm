<cf_web_portlet_start border="true" titulo="Evaluación de Cuestionarios" skin="#Session.Preferences.Skin#">
	<cf_templatecss>
	<cfinvoke component="rh.Componentes.RH_ProgramacionCursos" method="init" returnvariable="curso">
	<cfset rs_datoscurso = curso.obtenerCurso(url.RHCid, session.DSN, session.Usucodigo)>
	<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">

		<cfquery name="rs" datasource="#session.dsn#">
			select sum(RHAChoras) as horas, de.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# de.DEapellido2#LvarCNCT# ' '#LvarCNCT# de.DEnombre as nombre, ec.DEid
			from RHEmpleadoCurso ec 
			inner join RHAsistenciaCurso a
						on a.RHCid=ec.RHCid
						and a.DEid=ec.DEid
			inner join RHCursos c 
			on c.RHCid=ec.RHCid 
			inner join RHDiasCurso dc 
			on dc.RHCid=c.RHCid 
			and dc.RHDCactivo=1 
			and dc.RHDCid=a.RHDCid
			inner join DatosEmpleado de 
			on de.DEid=ec.DEid
			where ec.RHCid=#url.RHCid# 
			and ec.RHEMestado in (0, 10, 20, 30) 
			and ec.Ecodigo = #session.Ecodigo#
			and ec.RHECestado = 50
			group by de.DEnombre, de.DEapellido1, de.DEapellido2, ec.DEid,RHECjust
			order by de.DEapellido1, de.DEapellido2, de.DEnombre
		</cfquery>
		
	<cfoutput>
	<table width="100%">
		<tr bgcolor="999999">
			<td><strong>Nombre</strong></td>
			<td><strong>Horas Totales</strong></td>
			<td><strong>Justificación</strong></td>
		</tr>
		<cfloop query="rs">
		<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
			<td>#rs.nombre#</td>
			<td>#rs.horas#</td>
			<td><img src="/cfmx/rh/imagenes/iindex.gif" border="0" onclick="javascript: funcReporteJus(#rs.DEid#,#url.RHCid#)"></td>
		</tr>
		</cfloop>
		<tr>
			<td align="center" colspan="3">
				<input type="submit" name="Cerrar" class="btnAgregar" value="Cerrar" onclick="javascript: return cerrar();">
			</td>
		</tr>
	</table>
	</cfoutput>
	
	<script language="javascript">
		function funcReporteJus(DEid,RHCid){						
			 var PARAM  = "/cfmx/rh/capacitacion/operacion/cursos/calificacion_justificacion.cfm?DEid="+ DEid + "&RHCid=" + RHCid;
			open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=150')  
				} 
				
		function cerrar(){
			window.close();
				}
	</script>
 <cf_web_portlet_end>