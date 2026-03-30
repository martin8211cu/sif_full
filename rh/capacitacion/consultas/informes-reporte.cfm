<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cf_templatecss>
	<cf_htmlReportsHeaders
		irA="informes.cfm"
		FileName="Evaluacion.xls"
		title="evalCuestionario">

<cfoutput>
	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<cfinvoke key="Fdesde" default="<b>Fecha Desde</b>" returnvariable="Fdesde" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="Fhasta" default="<b>Fecha Hasta</b>" returnvariable="Fhasta" component="sif.Componentes.Translate"  method="Translate"/>
				<cfset filtro1 = Fdesde&': #form.fdesde#'>
				<cfset filtro2 = Fhasta&':  #form.fhasta#'>
					<cf_EncReporte
					Titulo="Informes"
					Color="##E3EDEF"
					filtro1="#filtro1#"
					filtro2="#filtro2#"
					Cols= 11>
			</td>
		</tr>
	</table>
</cfoutput>
<!---                                            Actividades de Capacitación por área                                                    --->
<cfif form.radio1 eq 0>
		<cf_dbtemp name="temp_Cursos" returnvariable="datos" datasource="#session.dsn#">
			<cf_dbtempcol name="RHCid"					type="numeric"  	mandatory="no">
			<cf_dbtempcol name="RHCnombre"				type="varchar(255)"  	mandatory="no">
			<cf_dbtempcol name="RHACdescripcion"		type="varchar(255)"  	mandatory="no">
			<cf_dbtempcol name="RHACid"			        type="numeric"		mandatory="no">
			<cf_dbtempcol name="matriculados"		    type="numeric"		mandatory="no">
			<cf_dbtempcol name="reprobados"		        type="numeric"		mandatory="no">
			<cf_dbtempcol name="aprobados"				type="numeric"	    mandatory="no">
			<cf_dbtempcol name="duracion"				type="numeric"	    mandatory="no">
			<cf_dbtempcol name="Mcodigo"				type="numeric"	    mandatory="no">
	</cf_dbtemp>	
	
	<cf_dbtemp name="temp_Cursos4" returnvariable="datos2" datasource="#session.dsn#">
			<cf_dbtempcol name="RHCid"			        type="numeric"		mandatory="no">
			<cf_dbtempcol name="reprobados"		        type="varchar"		mandatory="no">
			<cf_dbtempcol name="aprobados"				type="varchar"	    mandatory="no">
	</cf_dbtemp>
	<cfquery name="rsCursosxArea" datasource="#session.dsn#"><!---Area--->
		insert into #datos#(RHCid,RHACid,RHACdescripcion,matriculados,RHCnombre,duracion,Mcodigo)
		 select c.RHCid,a.RHACid,a.RHACdescripcion,count(1),c.RHCnombre,duracion,c.Mcodigo
		from RHCursos c 
		inner join RHEmpleadoCurso e 
		   inner join LineaTiempo lt
			on lt.DEid=e.DEid    
		on e.RHCid=c.RHCid 
		and e.RHEMestado in (10,20) 
		and e.RHECestado=50
		and c.RHCfdesde between lt.LTdesde and lt.LThasta  
			inner join RHMateria m 
				inner join RHAreasCapacitacion a 
				on a.RHACid=m.RHACid 
			on m.Mcodigo=c.Mcodigo
		 and m.Mcodigo=c.Mcodigo 
		 where 1=1 
		 <cfif isdefined('form.fdesde') and len(trim(form.fdesde)) gt 0>
		and c.RHCfdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fdesde#">
		</cfif>
		<cfif isdefined('form.fhasta') and len(trim(form.fhasta)) gt 0>
		and c.RHCfhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fhasta#">
		</cfif>	
		group by a.RHACid,a.RHACdescripcion,a.RHACcodigo,c.RHCid,c.RHCnombre,duracion,c.Mcodigo	
		
<!---		select c.RHCid,a.RHACid,a.RHACdescripcion,count(1),c.RHCnombre,duracion,c.Mcodigo
		from RHCursos c
			  inner join RHEmpleadoCurso e
				on e.RHCid=c.RHCid
				and e.RHEMestado in (10,20)
			inner join RHRelacionCap r
				   inner join RHMateria m
							inner join RHAreasCapacitacion a
							 on a.RHACid=m.RHACid
				  on m.Mcodigo=r.Mcodigo
			on r.RHCid=c.RHCid
			and r.Mcodigo=c.Mcodigo
		where 1=1
		<cfif isdefined('form.fdesde') and len(trim(form.fdesde)) gt 0>
		and c.RHCfdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fdesde#">
		</cfif>
		<cfif isdefined('form.fhasta') and len(trim(form.fhasta)) gt 0>
		and c.RHCfhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fhasta#">
		</cfif>		
		group by a.RHACid,a.RHACdescripcion,a.RHACcodigo,c.RHCid,c.RHCnombre,duracion,c.Mcodigo--->
	</cfquery>

		<cfquery name="rsOtros" datasource="#session.dsn#">
			insert into #datos2#(RHCid,aprobados,reprobados)
				select c.RHCid,
				case  RHEMestado  when 10  then 'A' end as aprobados,
				case  RHEMestado  when 20  then 'R' end as reprobados
				from RHCursos c
					inner join RHEmpleadoCurso e
					on e.RHCid=c.RHCid
					and e.RHEMestado in (20,10)
					--and e.RHEMnota is not null
						   inner join RHMateria m
									inner join RHAreasCapacitacion a
									 on a.RHACid=m.RHACid
						  on m.Mcodigo=c.Mcodigo			
					
		</cfquery>

	<cfquery name="rsAP" datasource="#session.dsn#">
		select count(1) as cant,RHCid from #datos2#
		where aprobados='A'
		group by RHCid
	</cfquery>

	<cfloop query="rsAP">
		<cfquery name="rsUP" datasource="#session.dsn#">
			update #datos# set aprobados=coalesce(#rsAP.cant#,0) where RHCid=#rsAP.RHCid#
		</cfquery>
	</cfloop>
	
	<cfquery name="rsRP" datasource="#session.dsn#">
		select count(1) as cant,RHCid from #datos2#
		where reprobados='R'
		group by RHCid
	</cfquery>
	
	<cfloop query="rsRP">
		<cfquery name="rsUP" datasource="#session.dsn#">
			update #datos# set reprobados=coalesce(#rsRP.cant#,0) where RHCid=#rsRP.RHCid#
		</cfquery>
	</cfloop>
	<cfquery name="rsAPT" datasource="#session.dsn#">
		select count(1) as cant from #datos2#
		where aprobados='A'
	</cfquery>

	<cfquery name="rsCursosxArea" datasource="#session.dsn#">
		select a.RHACid,a.RHACcodigo,a.RHACdescripcion,count(1) as cantidad 
		from RHCursos c
			inner join RHEmpleadoCurso e
					on e.RHCid=c.RHCid
					and e.RHEMestado in (20,10)
	
				   inner join RHMateria m
							inner join RHAreasCapacitacion a
							 on a.RHACid=m.RHACid
				  on m.Mcodigo=c.Mcodigo

		where 1=1
		<cfif isdefined('form.fdesde') and len(trim(form.fdesde)) gt 0>
		and c.RHCfdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fdesde#">
		</cfif>
		<cfif isdefined('form.fhasta') and len(trim(form.fhasta)) gt 0>
		and c.RHCfhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fhasta#">
		</cfif>		
		group by a.RHACid,a.RHACdescripcion,a.RHACcodigo
	</cfquery>
	<cfoutput>
	<table width="80%" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center" colspan="7" style="font-size:16px">An&aacute;lisis de funcionarios capacitados por &aacute;rea</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td bgcolor="cee3e7" align="left" colspan="7">&Aacute;rea</td>
		</tr>
		<cfset total=0>
		<cfset LvarPorc=0>
		<cfset subMatT=0>
		<cfset porcT=0>
		<cfset porcTT=0>
		<cfset subHorasT=0>
		<cfset subMatT=0>
		<cfset subAproT=0>
		<cfset subRepT=0>
		
		<cfquery name="rs" datasource="#session.dsn#">
			select sum(aprobados) as aprobados from #datos#
		</cfquery>
			
		<cfloop query="rsCursosxArea">
		<tr>
			<td colspan="7" bgcolor="e3edef">#rsCursosxArea.RHACdescripcion#</td>
		</tr>
		<tr bgcolor="CCCCCC">
			<cfquery name="rsDatos" datasource="#session.dsn#">
				select c.RHCid,RHCnombre,matriculados,reprobados,aprobados,duracion
					from #datos# c
							   inner join RHMateria m
										inner join RHAreasCapacitacion a
										 on a.RHACid=m.RHACid
							  on m.Mcodigo=c.Mcodigo
					where 1=1
					and a.RHACid=#rsCursosxArea.RHACid#
					group by c.RHCid,RHCnombre,matriculados,reprobados,aprobados,duracion
			</cfquery>		
			
			<td>Curso</td>
			<td>Horas</td>
			<td>Matriculados</td>
			<td>Aprobados</td>
			<td>Reprobados</td>
			<td>Total</td>
			<td>%</td>
		</tr>
		<cfset subHoras=0>
		<cfset subMat=0>
		<cfset subApro=0>
		<cfset subRep=0>
						
			<cfloop query="rsDatos">	
				<tr>					
					<cfset porc=0>
					<cfif len(trim(rsDatos.aprobados)) gt 0>
						<cfset porc=rsDatos.aprobados*100/rs.aprobados>
					</cfif>
					<td>&nbsp;&nbsp;&nbsp;#rsDatos.RHCnombre#</td>
					<td>#rsDatos.duracion#</td>
						<cfif len(trim(rsDatos.duracion)) gt 0>
							<cfset subHoras=subHoras+#rsDatos.duracion#>
							<cfset subHorasT=subHorasT+#rsDatos.duracion#>
						</cfif>
					<td>#rsDatos.matriculados#</td>
						<cfif len(trim(rsDatos.matriculados)) gt 0>
							<cfset subMat=subMat+#rsDatos.matriculados#>
							<cfset subMatT=subMatT+#rsDatos.matriculados#>
						</cfif>
					<td>#rsDatos.aprobados#</td>
						<cfif len(trim(rsDatos.aprobados)) gt 0>							
							<cfset subApro=subApro+#rsDatos.aprobados#>							
						</cfif>
					<td>#rsDatos.reprobados#</td>
						<cfif len(trim(rsDatos.reprobados)) gt 0>
							<cfset subRep=subRep+#rsDatos.reprobados#>
							<cfset subRepT=subRepT+#rsDatos.reprobados#>
						</cfif>
					<td>#rsDatos.matriculados#</td>
					<td>#LSNumberFormat(porc,",0.00")#%</td>
				</tr>
			</cfloop>
		<tr><td colspan="7"><hr /></td></tr>
		<tr>	
			<cfset porcT=subApro*100/rsAPT.cant>
			<cfset porcTT=porcTT+porcT>
			<td><strong>Subtotal #rsCursosxArea.RHACdescripcion#:</strong></td>
			<td>#subHoras#</td>
			<td>#subMat#</td>
			<td>#subApro#</td>
			<td>#subRep#</td>
			<td>#subMat#</td>
			<td>#LSNumberFormat(porcT,",0.00")#%</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		</cfloop>
		<tr><td colspan="7"><hr /></td></tr>
		<tr>	
			<td><strong>Total:</strong></td>
			<td>#subHorasT#</td>
			<td>#subMatT#</td>
			<td>#rs.aprobados#</td>
			<td>#subRepT#</td>
			<td>#subMatT#</td>
			<td>#LSNumberFormat(porcTT,",0.00")#%</td>
		</tr>
	</table>
	</cfoutput>


</cfif>
<!---                            Análisis de funcionarios capacitados por área de capacitación                                     --->
<cfif form.radio1 eq 1>

	<cf_dbtemp name="temp_Cursos" returnvariable="datos" datasource="#session.dsn#">
			<cf_dbtempcol name="RHCid"					type="numeric"  	mandatory="no">
			<cf_dbtempcol name="RHACdescripcion"		type="varchar(255)"  	mandatory="no">
			<cf_dbtempcol name="RHACid"			        type="numeric"		mandatory="no">
			<cf_dbtempcol name="matriculados"		    type="numeric"		mandatory="no">
			<cf_dbtempcol name="reprobados"		        type="numeric"		mandatory="no">
			<cf_dbtempcol name="aprobados"				type="numeric"	    mandatory="no">
	</cf_dbtemp>	
	
	<cf_dbtemp name="temp_Cursos3" returnvariable="datos2" datasource="#session.dsn#">
			<cf_dbtempcol name="RHACid"			        type="numeric"		mandatory="no">
			<cf_dbtempcol name="reprobados"		        type="varchar"		mandatory="no">
			<cf_dbtempcol name="aprobados"				type="varchar"	    mandatory="no">
	</cf_dbtemp>		
		
	<cfquery name="rsCursosxArea" datasource="#session.dsn#"><!---Area--->
	insert into #datos#(RHACid,RHACdescripcion,matriculados)
		select a.RHACid,a.RHACdescripcion,count(1) 
		from RHCursos c 
		inner join RHEmpleadoCurso e 
		   inner join LineaTiempo lt
			on lt.DEid=e.DEid    
		on e.RHCid=c.RHCid 
		and e.RHEMestado in (10,20) 
		and e.RHECestado=50
		and c.RHCfdesde between lt.LTdesde and lt.LThasta  
			inner join RHMateria m 
				inner join RHAreasCapacitacion a 
				on a.RHACid=m.RHACid 
			on m.Mcodigo=c.Mcodigo
		 and m.Mcodigo=c.Mcodigo 
		 where 1=1 
		<cfif isdefined('form.fdesde') and len(trim(form.fdesde)) gt 0>
		and c.RHCfdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fdesde#">
		</cfif>
		<cfif isdefined('form.fhasta') and len(trim(form.fhasta)) gt 0>
		and c.RHCfhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fhasta#">
		</cfif>		
		group by a.RHACid,a.RHACdescripcion,a.RHACcodigo
	</cfquery>
	

	<cfquery name="rsOtros" datasource="#session.dsn#">
	insert into #datos2#(RHACid,reprobados,aprobados)
		select a.RHACid,
		case  RHEMestado  when 20  then 'R' end as reprobados,
		case  RHEMestado  when 10  then 'A' end as aprobados
				from RHCursos c
					inner join RHEmpleadoCurso e
					on e.RHCid=c.RHCid
					and e.RHEMestado in (20,10)
						   inner join RHMateria m
									inner join RHAreasCapacitacion a
									 on a.RHACid=m.RHACid
						  on m.Mcodigo=c.Mcodigo
	</cfquery>
	
	<cfquery name="rsAP" datasource="#session.dsn#">
		select count(1) as cant,RHACid from #datos2#
		where aprobados='A'
		group by RHACid
	</cfquery>

	<cfloop query="rsAP">
		<cfquery name="rsUP" datasource="#session.dsn#">
			update #datos# set aprobados=coalesce(#rsAP.cant#,0) where RHACid=#rsAP.RHACid#
		</cfquery>
	</cfloop>
	
	<cfquery name="rsRP" datasource="#session.dsn#">
		select count(1) as cant,RHACid from #datos2#
		where reprobados='R'
		group by RHACid
	</cfquery>
	
	<cfloop query="rsRP">
		<cfquery name="rsUP" datasource="#session.dsn#">
			update #datos# set reprobados=coalesce(#rsRP.cant#,0) where RHACid=#rsRP.RHACid#
		</cfquery>
	</cfloop>
	
	<cfquery name="rs" datasource="#session.dsn#">
		select RHACdescripcion,coalesce(aprobados,0) as aprobados,coalesce(matriculados,0) as matriculados,coalesce(reprobados,0) as reprobados from #datos#
	</cfquery>
	
	<cfoutput>
	<table width="80%" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center" colspan="3" style="font-size:16px">Actividades de Capacitaci&oacute;n por &aacute;rea</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td class="tituloListas" align="left" width="50%">&Aacute;rea</td>
			<td class="tituloListas" align="left" width="10%">Matriculados</td>
			<td class="tituloListas" align="center" width="10%">Aprobados</td>
			<td class="tituloListas" align="center" width="10%">Reprobados</td>
			<td class="tituloListas" align="center" width="10%">Cantidad Funcionarios</td>
			<td class="tituloListas" align="center" width="10%">Porcentaje</td>
		</tr>
		<cfset total=0>
		<cfset totalT=0>
		
		<cfloop query="rs">
			<cfset total=total+rs.aprobados>
			<cfset totalT=totalT+rs.matriculados>
		</cfloop>
		<cfset LvarPorc=0>
		<cfloop query="rs">
		<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
			<td>#rs.RHACdescripcion#</td>
			<td align="center">#rs.matriculados#</td>
			<td align="center">#rs.aprobados#</td>
			<td align="center">#rs.reprobados#</td>
			<td align="center">#rs.matriculados#</td>
			<td align="center"><cfif rs.matriculados gt 0><cfset por=rs.aprobados*100/#total#>#LSNumberFormat(por,',0.00')#%<cfelse>0%</cfif></td>
			<cfset LvarPorc=LvarPorc+por>
		</tr>
		
		</cfloop>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="6"><hr /></td></tr>
		<tr bgcolor="CCCCCC">
			<td colspan="4">Total de Funcionarios</td>
			<td align="center">#totalT#</td>
			<td align="center">#LSNumberFormat(LvarPorc,'0,0')#%</td>
		</tr>
	</table>
	</cfoutput>
</cfif>



<!---                                     Cantidad de horas por área de capacitación                                              --->
<cfif form.radio1 eq 2>
	<cfquery name="rsCurso" datasource="#session.dsn#">
		select u.RHCid,u.RHCfdesde,u.RHCfhasta,u.RHCnombre,u.duracion,c.RHEMnotamin,
		coalesce(i.RHInombre,'') #LvarCNCT# ' ' #LvarCNCT# coalesce(i.RHIapellido1,'')#LvarCNCT# ' '#LvarCNCT# coalesce(i.RHIapellido2,'') as Nombre,RHCtipo
		from RHCursos u
		inner join RHInstructores i
		on i.RHIid=u.RHIid
			inner join RHEmpleadoCurso c
				inner join LineaTiempo lt
				on lt.DEid=c.DEid    
			on c.RHCid=u.RHCid 
			and c.RHEMestado in (10,20) 
			and c.RHECestado=50
			and u.RHCfdesde between lt.LTdesde and lt.LThasta 
		where 1=1
		<cfif isdefined('form.fdesde') and len(trim(form.fdesde)) gt 0>
		and u.RHCfdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fdesde#">
		</cfif>
		<cfif isdefined('form.fhasta') and len(trim(form.fhasta)) gt 0>
		and u.RHCfhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fhasta#">
		</cfif>	
		<cfif isdefined ('form.RHCid') and len(trim(form.RHCid)) gt 0>
		and u.RHCid=#form.RHCid#
		</cfif>	
		and u.Ecodigo=#session.Ecodigo#
		and c.RHEMestado in (10,20)
		group by  u.RHCid,u.RHCfdesde,u.RHCfhasta,u.RHCnombre,u.duracion,i.RHInombre,i.RHIapellido1,i.RHIapellido2,c.RHEMnotamin,RHCtipo
	</cfquery>

	<cfoutput>
	<table width="45%" align="center">
	<tr><td>&nbsp;</td></tr>
		<tr><td align="center" colspan="3" style="font-size:16px">Promedio de calificaci&oacute;n por curso</td></tr>
		<tr><td>&nbsp;</td></tr>
	<cfloop query="rsCurso">
	<tr>
	<td width="75%" align="center" >
		<table border="1" bordercolor="666666" width="100%" align="center">
		<tr class="tituloListas"><td colspan="2"><strong>Nombre del Curso: </strong>#rsCurso.RHCnombre#</td></tr>
		<tr class="tituloListas"><td colspan="2"><strong>Instructor: </strong>#rsCurso.Nombre#</td></tr>
		<tr class="tituloListas"><td colspan="2"><strong>Fechas:&nbsp;</strong><cf_locale name="date" value="#rsCurso.RHCfdesde#"/>&nbsp;-&nbsp;<cf_locale name="date" value="#rsCurso.RHCfhasta#"/>
		<strong>&nbsp;Cantidad de Horas: </strong>#rsCurso.duracion#
		<strong><cfif rsCurso.RHCtipo eq 'P'>&nbsp;Porcentaje M&iacute;nimo de asistencia:&nbsp<cfelse>&nbsp;Nota M&iacute;nima:&nbsp </cfif></strong>#rsCurso.RHEMnotamin#</td></tr>
		    <cfquery name="emp" datasource="#session.dsn#">
				select c.RHEMnota,c.DEid,
				coalesce(d.DEapellido1,'')#LvarCNCT# ' '#LvarCNCT# coalesce(d.DEapellido2,'') #LvarCNCT# ' ' #LvarCNCT# coalesce(d.DEnombre,'') as Nombre				
				from RHEmpleadoCurso c
				inner join DatosEmpleado d
				on d.DEid=c.DEid
				where c.RHCid=#rsCurso.RHCid#
				and c.RHEMestado in (10,20)	
				and c.RHECestado=50			
				order by d.DEapellido1,d.DEapellido2,d.DEnombre asc
			</cfquery>
			<tr class="listaPar">
				<td>Participantes</td>
				<td><cfif rsCurso.RHCtipo eq 'P'>Porcentaje de Asistencia<cfelse>Calificaci&oacute;n</cfif></td>
			</tr>
				<cfset LvarP=0>
				<cfset LvarN=0>
				<cfset LvaTot=0>				
				<cfloop query="emp">
					<tr>
						<td>#emp.Nombre#</td>
						<td>#emp.RHEMnota#</td>
					</tr>
					<cfset LvarP=LvarP+1>
					<cfif isdefined('emp.RHEMnota') and emp.RHEMnota gt 0>
						<cfset LvarN=LvarN+#emp.RHEMnota#>
					</cfif>
				</cfloop>
			<tr>
				<td>Promedio de Calificaci&oacute;n</td>
				<td><cfif isdefined ('LvarN') and LvarN gt 0 and isdefined ('LvarP') and LvarP gt 0><cfset LvaTot=LvarN/LvarP></cfif>#LSNumberFormat(LvaTot,',0.00')#</td>
			</tr>
		</table>
	</td>
	</tr>
		<tr><td>&nbsp;</td></tr>
	</cfloop>
	</table>
	</cfoutput>
</cfif>
	
	
<!---                                     Personal capacitado por Escuela / Departamento/ Programa                                              --->
<cfif form.radio1 eq 3>
	<cfif isdefined ('form.CFid') and len(trim(form.CFid))>
		<cfquery name="rsCF" datasource="#session.dsn#">
			select CFdescripcion,CFcodigo from CFuncional where CFid=#form.CFid#
		</cfquery>
	</cfif>

	<cfquery name="rsCurso" datasource="#session.dsn#">		    
		select  l.DEid,a.RHCid,a.RHCnombre,a.RHCfdesde,a.RHCfhasta,a.duracion,c.RHEMnota,a.RHCtipo,RHEMnotamin,
		coalesce(sum(ec.RHAChoras),0) as horas,
		case when RHCtipo = 'A'
		then c.RHEMnotamin
		else
		a.duracion* c.RHEMnotamin/100
		end as nota,
		case when c.RHEMnota < c.RHEMnotamin
		then '(*)'
		else
		''
		end as estado,
		coalesce(d.DEapellido1,'')#LvarCNCT# ' '#LvarCNCT# coalesce(d.DEapellido2,'') #LvarCNCT# ' ' #LvarCNCT# coalesce(d.DEnombre,'') as Nombre		
		from LineaTiempo l
		
			inner join RHPlazas p   
				inner join CFuncional f
				on f.CFid=p.CFid
			on p.RHPid=l.RHPid
			<cfif  len(trim(form.fhasta)) eq 0 and  len(trim(form.fdesde)) eq 0>
			and #now()# between l.LTdesde and l.LThasta
			</cfif>
			
			inner join RHEmpleadoCurso c
				
				inner  join RHAsistenciaCurso ec
				on c.RHCid=ec.RHCid
				and c.DEid=ec.DEid
				
				inner join RHCursos a
				on a.RHCid=ec.RHCid
				
			on c.DEid=l.DEid
			and c.RHEMestado in (10,20)
			and l.Ecodigo=#session.Ecodigo#
			<cfif  len(trim(form.fhasta)) eq 0 and  len(trim(form.fdesde)) eq 0>
			and #now()# between l.LTdesde and l.LThasta
			</cfif>
			
			<cfif isdefined ('form.CFid') and len(trim(form.CFid))>
			and f.CFid=#form.CFid#
			</cfif>
			
			inner join DatosEmpleado d
			on d.DEid=l.DEid
			<cfif  len(trim(form.fhasta)) eq 0 and  len(trim(form.fdesde)) eq 0>
			and #now()# between l.LTdesde and l.LThasta
			</cfif>
			
		where 1=1
		and c.RHECestado=50		
		and a.RHCfdesde between l.LTdesde and l.LThasta	  		
		<cfif isdefined('form.fdesde') and len(trim(form.fdesde)) gt 0>
		and l.LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fdesde#">
		</cfif>
		<cfif isdefined('form.fhasta') and len(trim(form.fhasta)) gt 0>
		and l.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fhasta#">
		</cfif>	
			
		<cfif  len(trim(form.fhasta)) eq 0 and  len(trim(form.fdesde)) eq 0>
		and #now()# between l.LTdesde and l.LThasta
		</cfif>
		group by  a.RHCnombre,a.RHCfdesde,a.RHCfhasta,a.duracion,c.RHEMnota,c.RHEMnotamin,a.RHCtipo,RHEMnota,DEapellido1,DEapellido2,DEnombre,
		l.DEid,a.RHCid
		order by RHCtipo,d.DEapellido1,d.DEapellido2,d.DEnombre,a.RHCfdesde asc
		
	</cfquery>

	<cfoutput>
	<table width="75%" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center" colspan="6" style="font-size:16px">Personal capacitado por Centro Funcional</td></tr>
		<tr><td align="center" colspan="6" style="font-size:16px"><cfif isdefined('rsCF')>#rsCF.CFcodigo#-#rsCF.CFdescripcion#<cfelse></cfif></td></tr>		
		<tr><td>&nbsp;</td></tr>
		<tr class="tituloListas">
			<td><strong>Participante</strong></td>
			<td><strong>Nombre del Curso</strong></td>
			<td><strong>Fecha de Inicio</strong></td>
			<td><strong>Fecha de T&eacute;rmino</strong></td>
			<td><strong>Cantidad de Horas</strong></td>
			<td><strong>Horas Asistencia</strong></td>
			<td><strong>Nota M&iacute;nima</strong></td>
			<td><strong>Nota</strong></td>
			<td><strong>&nbsp;</strong></td>
			
			
		</tr>
	<cfloop query="rsCurso">
		<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
			<td>#rsCurso.Nombre#</td>
			<td>#rsCurso.RHCnombre#</td>
			<td><cf_locale name="date" value="#rsCurso.RHCfdesde#"/></td>
			<td><cf_locale name="date" value="#rsCurso.RHCfhasta#"/></td>
			<td align="center">#rsCurso.duracion#</td>
			<td align="center">#rsCurso.horas#</td>
			<td align="center">#rsCurso.nota#</td>
			<cfif len(trim(rsCurso.estado)) gt 0>
				<cfif len(trim(rsCurso.RHCtipo)) gt 0 and rsCurso.RHCtipo eq 'A'>
					<td align="right"><font color="FF0000">#rsCurso.RHEMnota#</font></td>
				<cfelseif len(trim(rsCurso.RHCtipo)) gt 0 and rsCurso.RHCtipo eq 'P'>
					<td align="left"><font color="FF0000">P</font></td>
				<cfelse>
					<td align="right"><font color="FF0000">#rsCurso.RHEMnota#</font></td>
				</cfif>
			<td><font color="FF0000">#rsCurso.estado#</font></td>
			<cfelse>
				<cfif len(trim(rsCurso.RHCtipo)) gt 0 and rsCurso.RHCtipo eq 'A'>
					<td align="right">#rsCurso.RHEMnota#</td>
				<cfelseif len(trim(rsCurso.RHCtipo)) gt 0 and rsCurso.RHCtipo eq 'P'>
					<td align="left">P</td>
				<cfelse>
					<td align="right">#rsCurso.RHEMnota#</td>
				</cfif>
			<td>&nbsp;</td>
			</cfif>
		</tr>
	</cfloop>
	</table>
	</cfoutput>
</cfif>
<!--- <cf_dump var="#form#"> --->
<!---                                     Personal capacitado por Puesto                                              --->
<cfif form.radio1 eq 4>
	<cfquery name="rsP" datasource="#session.dsn#">
		select RHPcodigo,RHPdescpuesto from RHPuestos where RHPcodigo='#form.RHPcodigo#'
	</cfquery>
	<cfquery name="rsCurso" datasource="#session.dsn#">		    
		select  a.RHCnombre,a.RHCfdesde,a.RHCfhasta,a.duracion,s.RHTScodigo,s.RHTSdescripcion,
		coalesce(i.RHInombre,'') #LvarCNCT# ' ' #LvarCNCT# coalesce(i.RHIapellido1,'')#LvarCNCT# ' '#LvarCNCT# coalesce(i.RHIapellido2,'') as NombreI,RHCdirigido		
		from  RHCursos a						
				 left outer join RHTiposServ s
					on s.RHTSid=a.RHTSid
				inner join RHInstructores i					
		   		on i.RHIid=a.RHIid
			and i.Ecodigo=a.Ecodigo					
		where 1=1 
		and a.Ecodigo=#session.Ecodigo#
		<cfif isdefined('form.fdesde') and len(trim(form.fdesde)) gt 0>
		and a.RHCfdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fdesde#">
		</cfif>
		<cfif isdefined('form.fhasta') and len(trim(form.fhasta)) gt 0>
		and a.RHCfhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fhasta#">
		</cfif>		
		<cfif isdefined('form.RHIid') and len(trim(form.RHIid)) gt 0>
		and a.RHIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid#">
		</cfif>
		order by a.RHCfdesde asc
	</cfquery>

	<cfoutput>
	<table width="75%" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center" colspan="6" style="font-size:16px">Certificaci&oacute;n cursos impartidos por instructor</td></tr>
		<cfif isdefined('form.RHIid') and len(trim(form.RHIid)) gt 0>
		<tr><td align="center" colspan="6" style="font-size:16px"><strong>Instructor:</strong>#rsCurso.NombreI#</td></tr>
		</cfif>		
		<tr><td>&nbsp;</td></tr>
		<tr class="tituloListas">
			<td><strong>Nombre del Curso</td>	
			<td><strong>Fecha de Inicio</td>
			<td><strong>Fecha de T&eacute;rmino</td>		
			<td><strong>Cantidad de Horas</td>
			<td><strong>Tipo de Servicio</td>
			<td><strong>Dirigido</td>
			<cfif not isdefined('form.RHIid') or len(trim(form.RHIid)) eq 0>
			<td><strong>Instructor</strong></td>
			</cfif>
		</tr>
	<cfloop query="rsCurso">
		<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>

			<td>#rsCurso.RHCnombre#</td>
			<td><cf_locale name="date" value="#rsCurso.RHCfdesde#"/></td>
			<td><cf_locale name="date" value="#rsCurso.RHCfhasta#"/></td>
			<td align="center">#rsCurso.duracion#</td>
			<td align="center">#rsCurso.RHTScodigo#-#rsCurso.RHTSdescripcion#</td>
			<td align="center">#rsCurso.RHCdirigido#</td>
			<cfif not isdefined('form.RHIid') or len(trim(form.RHIid)) eq 0>
			<td align="left">#rsCurso.NombreI#</td>
			</cfif>
		</tr>
	</cfloop>
	</table>
	</cfoutput>
</cfif>

<!---                                     Personal capacitado por Puesto                                              --->
<cfif form.radio1 eq 5>
	<cfquery name="rsP" datasource="#session.dsn#">
		select RHPcodigo,RHPdescpuesto from RHPuestos where RHPcodigo='#form.RHPcodigo#'
	</cfquery>
	<cfquery name="rsCurso" datasource="#session.dsn#">		
		select  ec.DEid,a.RHCnombre,a.RHCfdesde,a.RHCfhasta,a.duracion,c.RHEMnota,p.RHPcodigo,p.RHPdescpuesto,c.RHEMnotamin,RHCtipo,coalesce(sum(ec.RHAChoras),0) as horas,
		case when c.RHEMnota < c.RHEMnotamin
		then '(*)'
		else
		''
		end as estado,
		case when RHCtipo = 'A'
		then c.RHEMnotamin
		else
		a.duracion* c.RHEMnotamin/100
		end as nota,
		coalesce(d.DEapellido1,'')#LvarCNCT# ' '#LvarCNCT# coalesce(d.DEapellido2,'') #LvarCNCT# ' ' #LvarCNCT# coalesce(d.DEnombre,'') as Nombre
		
		 from LineaTiempo l 
		 
		 inner join RHPuestos p 
		 on p.RHPcodigo=l.RHPcodigo 
		 and p.Ecodigo=l.Ecodigo 
		 <cfif isdefined('form.RHPcodigo') and len(trim(form.RHPcodigo)) gt 0>
		and p.RHPcodigo='#form.RHPcodigo#'
		</cfif>
		<cfif  len(trim(form.fhasta)) eq 0 and  len(trim(form.fdesde)) eq 0>
		and #now()# between l.LTdesde and l.LThasta
		</cfif>
		 
		 inner join RHEmpleadoCurso c 
			inner join RHAsistenciaCurso ec 
			on c.RHCid=ec.RHCid 
			and c.DEid=ec.DEid 
			   inner join RHCursos a 
				on a.RHCid=c.RHCid 
		 on c.DEid=l.DEid 

		
		 inner join DatosEmpleado d 
		 on d.DEid=l.DEid 
		 where 1=1 
		 
		 and l.Ecodigo=#session.Ecodigo# 
		and c.RHEMestado in (10,20)
		
		and a.RHCfdesde between l.LTdesde and l.LThasta
		<cfif isdefined('form.fdesde') and len(trim(form.fdesde)) gt 0>
		and a.RHCfdesde >=<cfqueryparam cfsqltype="cf_sql_date" value="#form.fdesde#">
		</cfif>
		<cfif isdefined('form.fhasta') and len(trim(form.fhasta)) gt 0>
		and a.RHCfhasta <=<cfqueryparam cfsqltype="cf_sql_date" value="#form.fhasta#"> 
		</cfif>	
		 group by a.RHCnombre,a.RHCfdesde,a.RHCfhasta,a.duracion,c.RHEMnota,p.RHPcodigo,p.RHPdescpuesto,c.RHEMnotamin,RHCtipo,ec.DEid, d.DEapellido1,d.DEapellido2,d.DEnombre 
		 order by RHCtipo,d.DEapellido1,d.DEapellido2,d.DEnombre,a.RHCfdesde asc 
		 
 
 <!--- and c.RHECestado=50		
		from LineaTiempo l
			inner join RHPuestos p   
			on p.RHPcodigo=l.RHPcodigo
			and p.Ecodigo=l.Ecodigo
			<cfif isdefined('form.RHPcodigo') and len(trim(form.RHPcodigo)) gt 0>
			and p.RHPcodigo='#form.RHPcodigo#'
			</cfif>
			<cfif  len(trim(form.fhasta)) eq 0 and  len(trim(form.fdesde)) eq 0>
			and #now()# between a.RHCfdesde and a.RHCfhasta
			</cfif>
			
		inner join RHEmpleadoCurso c
				inner  join RHAsistenciaCurso ec
				on c.RHCid=ec.RHCid
				and c.DEid=ec.DEid	
				
				inner join RHCursos a
				on a.RHCid=c.RHCid			 
		on c.DEid=l.DEid
		
		inner join DatosEmpleado d
		on d.DEid=l.DEid
		
		where 1=1 
		and l.Ecodigo=#session.Ecodigo# 
		and c.RHEMestado in (10,20)
		and c.RHECestado=50		
		and a.RHCfdesde between l.LTdesde and l.LThasta
		<cfif isdefined('form.fdesde') and len(trim(form.fdesde)) gt 0>
		and a.RHCfdesde >=<cfqueryparam cfsqltype="cf_sql_date" value="#form.fdesde#">
		</cfif>
		<cfif isdefined('form.fhasta') and len(trim(form.fhasta)) gt 0>
		and a.RHCfhasta <=#form.fhasta#
		</cfif>		

		group by a.RHCnombre,a.RHCfdesde,a.RHCfhasta,a.duracion,c.RHEMnota,p.RHPcodigo,p.RHPdescpuesto,c.RHEMnotamin,RHCtipo,ec.DEid,
		d.DEapellido1,d.DEapellido2,d.DEnombre	
		order by RHCtipo,d.DEapellido1,d.DEapellido2,d.DEnombre,a.RHCfdesde asc--->
	</cfquery>

	<cfoutput>
	<table width="100%" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center" colspan="6" style="font-size:16px">Personal capacitado por Puesto</td></tr>
		<tr><td align="center" colspan="6" style="font-size:16px">#rsP.RHPcodigo#-#rsP.RHPdescpuesto#</td></tr>		
		<tr><td>&nbsp;</td></tr>
		<tr class="tituloListas">
			<td><strong>Puesto</td>
			<td><strong>Participante</td>
			<td><strong>Nombre del Curso</td>
			<td align="center"><strong>Fecha de Inicio</td>
			<td align="center"><strong>Fecha de T&eacute;rmino</td>
			<td align="center"><strong>Cantidad de Horas</td>
			<td align="center"><strong>Nota M&iacute;nima</td>
			<td align="center"><strong>Horas Asistidas</td>
			<td align="center"><strong>Nota Obtenida</td>
			<td align="center"><strong>&nbsp;</td>			
		</tr>
	<cfloop query="rsCurso">
		<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
			<td>#rsCurso.RHPcodigo#-#rsCurso.RHPdescpuesto#</td>
			<td>#rsCurso.Nombre#</td>
			<td>#rsCurso.RHCnombre#</td>
			<td><cf_locale name="date" value="#rsCurso.RHCfdesde#"/></td>
			<td><cf_locale name="date" value="#rsCurso.RHCfhasta#"/></td>
			<td align="center">#rsCurso.duracion#</td>
			<td align="center">#rsCurso.nota#</td>
			<td align="center">#rsCurso.horas#</td>
			<!---<cfif len(trim(rsCurso.estado)) gt 0>
			<td align="right"><font color="FF0000">#rsCurso.nota#</font></td>
			<td><font color="FF0000">#rsCurso.estado#</font></td>
			<cfelse>
			<td align="right">#rsCurso.nota#</td>
			<td>&nbsp;</td>
			</cfif>--->			
			
			<cfif len(trim(rsCurso.estado)) gt 0><!---Si es mayor que = indica que se quedo--->
				<cfif len(trim(rsCurso.RHCtipo)) gt 0 and rsCurso.RHCtipo eq 'A'>
					<td align="right"><font color="FF0000">#rsCurso.RHEMnota#</font></td>
				<cfelseif len(trim(rsCurso.RHCtipo)) gt 0 and rsCurso.RHCtipo eq 'P'>
					<td align="center"><font color="FF0000">P</font></td>
				<cfelse>
					<td align="right"><font color="FF0000">#rsCurso.RHEMnota#</font></td>
				</cfif>
			<td><font color="FF0000">#rsCurso.estado#</font></td>
			<cfelse>
				<cfif len(trim(rsCurso.RHCtipo)) gt 0 and rsCurso.RHCtipo eq 'A'>
					<td align="right">#rsCurso.RHEMnota#</td>
				<cfelseif len(trim(rsCurso.RHCtipo)) gt 0 and rsCurso.RHCtipo eq 'P'>
					<td align="center">P</td>
				<cfelse>
					<td align="right">#rsCurso.RHEMnota#</td>
				</cfif>
			<td>&nbsp;</td>
			</cfif>
		</tr>
	</cfloop>
	</table>
	</cfoutput>
</cfif>
	
	
	
	
