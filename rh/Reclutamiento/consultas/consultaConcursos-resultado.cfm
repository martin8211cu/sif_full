<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">

<cfinvoke key="LB_Concursos" default="Concursos" returnvariable="LB_Concursos" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Puesto" default="Puesto" returnvariable="LB_Puesto" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_FechaDesde" default="Fecha Desde" returnvariable="LB_FechaDesde" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Informes" default="Informes" returnvariable="LB_Informes" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Cedula" default="Cédula" returnvariable="LB_Cedula"  component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Nombramiento" default="Nombramiento" returnvariable="LB_Nombramiento" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_NotaObtenida" default="Nota Obtenida" returnvariable="LB_NotaObtenida" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_NombreDelConcurso" default="Nombre del Curso" returnvariable="LB_NombreDelConcurso" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_ReporteDeCalificaciones" default="Reporte de Calificaciones" returnvariable="LB_ReporteDeCalificaciones" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_FechasNombramiento" default="Fechas de Nombramiento" returnvariable="LB_FechasNombramiento" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_FechaApertura" default="Fechas de Apertura" returnvariable="LB_FechaApertura"   component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Externo" default="Externo" returnvariable="LB_Externo" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Interno" default="Interno" returnvariable="LB_Interno" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>


<cf_templatecss>
	<cf_htmlReportsHeaders
		irA="consultaConcursos.cfm"
		FileName="Concursos.xls"
		title="Concursos">
		
<cfoutput>
	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<cfinvoke key="Puesto" default="<b>#LB_Puesto#</b>" returnvariable="Puesto" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="Fdesde" default="<b>#LB_FechaDesde#</b>" returnvariable="Fdesde" component="sif.Componentes.Translate"  method="Translate"/>
				<cfset filtro1 = Puesto&': #form.RHPcodigo#'>
				<cfset filtro2 = Fdesde&':  #form.fecha#'>
					<cf_EncReporte
					Titulo="#LB_Informes#"
					Color="##E3EDEF"
					filtro1="#filtro1#"
					filtro2="#filtro2#"
					Cols= 11>
			</td>
		</tr>
	</table>
</cfoutput>
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2114" default="" returnvariable="LvarNota"/>
<cf_translatedata tabla="RHConcursos" col="RHCdescripcion" name="get" returnvariable="LvarRHCdescripcion"/>
<cfquery name="rsSQL" datasource="#session.dsn#">
	select DEidentificacion,RHOidentificacion,d.DEid,o.RHOid,
	coalesce(DEnombre,' ')#LvarCNCT# ' ' #LvarCNCT# coalesce(DEapellido1, ' ')  #LvarCNCT# ' ' #LvarCNCT# coalesce(DEapellido2,' ') as NombreE,
	coalesce(RHOnombre,' ')#LvarCNCT# ' ' #LvarCNCT# coalesce(RHOapellido1, ' ')  #LvarCNCT# ' ' #LvarCNCT# coalesce(RHOapellido2,' ') as NombreO,
	r.RHCconcurso,RHCPpromedio,RHCcodigo,#LvarRHCdescripcion# as RHCdescripcion,c.RHCPid,r.RHPcodigo,r.RHCfapertura
	from RHConcursantes c 
	inner join RHConcursos r 
	on r.RHCconcurso=c.RHCconcurso 
	and r.RHCestado=70 
	
	left outer join DatosEmpleado d 
	on d.DEid=c.DEid 
	
	left outer join DatosOferentes o 
	on o.RHOid=c.RHOid 

	where 1=1
	<cfif isdefined('LvarNota') and LvarNota gt 0>
	 and RHCPpromedio>=#LvarNota#
	</cfif>
	<cfif isdefined('form.RHPcodigo') and len(trim(form.RHPcodigo)) gt 0>
		and r.RHPcodigo='#form.RHPcodigo#'
	</cfif>
	<cfif isdefined('form.fecha') and len(trim(form.fecha)) gt 0>
		and r.RHCfapertura > = <cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
	</cfif>
	order by RHCPpromedio desc
</cfquery>

	<table width="100%" align="center" cellpadding="5" cellspacing="5" border="0">
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center" colspan="3" style="font-size:16px"><cf_translate key="LB_ListadeConcursantes">Lista de Concursantes</cf_translate> </td></tr>
		<tr><td>&nbsp;</td></tr>
	</table> 

<table bordercolor="000000"  align="center" width="100%">
<cfoutput>
<tr>
	<td><strong>#LB_Cedula#</strong></td>
	<td><strong>#LB_Nombre#</strong></td>						
	<td><strong>#LB_Tipo#</strong></td>
	<td><strong>#LB_Nombramiento#</strong></td>
	<td><strong>#LB_NotaObtenida#</strong></td>
	<td><strong>#LB_NombreDelConcurso#</strong></td>
	<td><strong>#LB_ReporteDeCalificaciones#</strong></td>
	<td><strong>#LB_FechasNombramiento#</strong></td>
	<td><strong>#LB_FechaApertura#</strong></td>
</tr>
</cfoutput>
<tr>
	<td colspan="9"><hr /></td>
</tr>
<cfloop query="rsSQL">

	<cfoutput>
	<cfif isdefined('rsSQL.DEid') and len(trim(rsSQL.DEid)) gt 0>
		<cfquery name="rsDEid" datasource="#session.dsn#">
			select max(LThasta) as fecha 
			from LineaTiempo where DEid=#rsSQL.DEid#
		</cfquery>
		<cfset LvarFecha=#LSDateFormat(rsDEid.fecha,'DD-MM-YYYY')#>
			<cfif LvarFecha neq '01-01-6100'>
				<cfquery name="rsNom" datasource="#session.dsn#">
					select 0 as nom, LTdesde,LThasta
					from LineaTiempo 
					where DEid=#rsSQL.DEid#
					and #now()# between LTdesde and LThasta
				</cfquery>
				<cfif rsNom.recordcount eq 0 >
					<cfquery name="rsNom" datasource="#session.dsn#">
					select 1 as nom, max(LTdesde) as LTdesde, max(LThasta) as LThasta
					from LineaTiempo 
					where DEid=#rsSQL.DEid#
				</cfquery>
				</cfif>
				<cfquery name="rsTipo" datasource="#session.dsn#">
					select max(RHOid) as RHOid
					from RHConcursantes c 
					inner join RHConcursos r 
					on r.RHCconcurso=c.RHCconcurso 
					and r.RHCestado=70 
					and r.RHCconcurso=#rsSQL.RHCconcurso#
				</cfquery>
				<cfquery name="rsTipo" datasource="#session.dsn#">
					select max(RHOid) as RHOid
					from RHConcursantes c 
					inner join RHConcursos r 
					on r.RHCconcurso=c.RHCconcurso 
					and r.RHCestado=70 
					and r.RHCconcurso=#rsSQL.RHCconcurso#
				</cfquery>
				<tr <cfif CurrentRow MOD 2> class="listaPar"<cfelse>class="listaNon"</cfif>>
						<td>#rsSQL.DEidentificacion#</td>
						<td>#rsSQL.NombreE#</td>				
						<td>
							<cfif len(trim(rsTipo.RHOid)) gt 0>
								#LB_Externo#
							<cfelse>
								#LB_Interno#
							</cfif>
						</td>
						<td>
							<cfif rsNom.nom eq 1>
								<img src="../../imagenesdd/w-check.gif" />
							<cfelse>
								<img src="../../imagenesdd/Borrar01_12x12.gif" />
							</cfif>
						</td>
						<td>#rsSQL.RHCPpromedio#</td>
						<td>#rsSQL.RHCcodigo#-#rsSQL.RHCdescripcion#</td>
						<td><img border="0" onClick="javascript: informe(#rsSQL.RHCPid#,#rsSQL.RHCconcurso#);" src="/cfmx/rh/imagenes/iindex.gif" alt="Calificaciones de Participante">	</td>
						<td>#LSDateFormat(rsNom.LTdesde,'DD/MM/YYYY')#&nbsp;-&nbsp;#LSDateFormat(rsNom.LThasta,'DD/MM/YYYY')#</td>
						<td>#LSDateFormat(RHCfapertura,'DD/MM/YYYY')#</td>
					</tr>
				</cfif>		
		</cfif>
		<cfif len(trim(rsSQL.RHOid)) gt 0>				
					<tr>
						<td>#rsSQL.RHOidentificacion#</td>
						<td>#rsSQL.NombreO#</td>
						
						<cfquery name="rsTipo" datasource="#session.dsn#">
							select max(RHOid) as RHOid
							from RHConcursantes c 
							inner join RHConcursos r 
							on r.RHCconcurso=c.RHCconcurso 
							and r.RHCestado=70 
							and r.RHCconcurso=#rsSQL.RHCconcurso#
						</cfquery>
						<td>
							<cfif len(trim(rsTipo.RHOid)) gt 0>
								#LB_Externo#
							<cfelse>
								#LB_Interno#
							</cfif>
						</td>
						<td>N/A</td>
						<td>#rsSQL.RHCPpromedio#</td>
						<td>#rsSQL.RHCcodigo#-#rsSQL.RHCdescripcion#</td>
						<td><img border="0" onClick="javascript: informe(#rsSQL.RHCPid#,#rsSQL.RHCconcurso#);" src="/cfmx/rh/imagenes/iindex.gif" alt="Calificaciones de Participante">						</td>
						<td>N/A</td>
						<td>#LSDateFormat(RHCfapertura,'DD/MM/YYYY')#</td>
					</tr>				
		</cfif>
	</cfoutput>
</cfloop>
</table>

<script language="javascript">
	var popUpWin2 = 0;
	function popUpWindow2(URLStr, left, top, width, height){
		if(popUpWin2){
			if(!popUpWin2.closed) popUpWin2.close();
		}
			popUpWin2 = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}	
	//Popup con info
	function informe(llave,concurso){	 	
		var param =''
		param = '?RHCPid='+llave+'&RHCconcurso='+concurso
		popUpWindow2("RH_infCalificaciones.cfm"+param,120,150,750,400);
	}
</script>

