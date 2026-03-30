<cfset Session.Params.ModoDespliegue = 1>
<cfset TamGrafico = 200>

<cfinclude template="/rh/Utiles/params.cfm">
<cfinclude template="../../../expediente/consultas/consultas-frame-header.cfm">

<cfinvoke component="rh.capacitacion.expediente.expediente" method="init" returnvariable="exp">

<cfquery datasource="#session.dsn#" name="puesto_actual">
	select lt.RHPcodigo, pu.RHPdescpuesto
	from LineaTiempo lt
		inner join RHPuestos pu
			on pu.Ecodigo = lt.Ecodigo
			and pu.RHPcodigo = lt.RHPcodigo
	where lt.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
	  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between lt.LTdesde and lt.LThasta
</cfquery>

<cfquery datasource="#session.dsn#" name="puesto_sucesion">
	select ep.RHPcodigo, ps.PSporcreq, pu.RHPdescpuesto
	from RHEmpleadosPlan ep
		inner join RHPlanSucesion ps
			on ps.Ecodigo = ep.Ecodigo
			and ps.RHPcodigo = ep.RHPcodigo
		join RHPuestos pu
			on pu.Ecodigo = ep.Ecodigo
			and pu.RHPcodigo = ep.RHPcodigo
	where ep.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
	  and ep.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and ep.RHPcodigo <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto_actual.RHPcodigo#">
</cfquery>

<cfquery datasource="#session.dsn#" name="cursos">
	select distinct h.RHHdescripcion as descripcion, m.Mnombre, em.RHEMnota, m.Msiglas
	from RHEmpleadoCurso em
	join RHMateria m
		on em.Mcodigo = m.Mcodigo
		and em.Ecodigo = m.Ecodigo
	left join RHHabilidadesMaterias cm
		on cm.Mcodigo = m.Mcodigo
		and em.Ecodigo = m.Ecodigo
	left join RHHabilidades h
		on h.Ecodigo = cm.Ecodigo
		and h.RHHid = cm.RHHid
	where em.DEid    = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
	  and em.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and em.RHECfhasta = (select max(b.RHECfhasta) from RHEmpleadoCurso b where em.Mcodigo = b.Mcodigo and em.DEid = b.DEid)

	union all

	select distinct h.RHCdescripcion as descripcion, m.Mnombre, em.RHEMnota, m.Msiglas
	from RHEmpleadoCurso em
	join RHMateria m
		on em.Mcodigo = m.Mcodigo
		and em.Ecodigo = m.Ecodigo
	left join RHConocimientosMaterias cm
		on cm.Mcodigo = m.Mcodigo
		and cm.Ecodigo = m.Ecodigo
	left join RHConocimientos h
		on h.Ecodigo = cm.Ecodigo
		and h.RHCid = cm.RHCid
	where em.DEid    = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
	  and em.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and em.RHECfhasta = (select max(b.RHECfhasta) from RHEmpleadoCurso b where em.Mcodigo = b.Mcodigo and em.DEid = b.DEid)

	order by 2,1
</cfquery>

<cfoutput>
	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
		<td colspan="6">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
			  <td width="10%" rowspan="5" align="center" valign="top" style="padding-left: 10px; padding-right: 10px; padding-top: 10px;" nowrap><cf_sifleerimagen autosize="false" border="false" tabla="RHImagenEmpleado" campo="foto" condicion="DEid = #rsEmpleado.DEid#" conexion="#Session.DSN#" width="75" height="100"></td>
			  <td class="fileLabel" width="10%" nowrap><cf_translate key="NombreExp">Nombre Completo</cf_translate>: </td>
			  <td nowrap><b><font size="3">#rsEmpleado.DEnombre# #rsEmpleado.DEapellido1# #rsEmpleado.DEapellido2#</font></b></td>
			  <td class="fileLabel" nowrap><cf_translate key="CedulaExp">#rsEmpleado.NTIdescripcion#</cf_translate>:</td>
			  <td nowrap>#rsEmpleado.DEidentificacion#</td>
			</tr>
			<tr>
			  <td class="fileLabel" nowrap><cf_translate key="SexExp">Sexo</cf_translate>:</td>
			  <td>#rsEmpleado.Sexo#</td>
			  <td class="fileLabel" nowrap><cf_translate key="FecNacExp">Fecha de Nacimiento</cf_translate>:</td>
			  <td><cf_locale name="date" value="#rsEmpleado.FechaNacimiento#"/></td>
			</tr>
			<tr>
			  <td class="fileLabel" nowrap><cf_translate key="EstadoCivilExp">Estado Civil</cf_translate>:</td>
			  <td>#rsEmpleado.EstadoCivil#</td>
			  <td class="fileLabel" nowrap><cf_translate key="NDependietesExp">No. de Dependientes</cf_translate>:</td>
			  <td>#rsEmpleado.DEcantdep#</td>
			</tr>
			<tr>
			  <td class="fileLabel" nowrap><cf_translate key="DireccionExp">Direcci&oacute;n</cf_translate>:</td>
			  <td colspan="3">#rsEmpleado.DEdireccion#</td>
		    </tr>
			<tr>
			  <td class="fileLabel" nowrap><cf_translate key="BancoExp">Banco</cf_translate>:</td>
			  <td>#rsEmpleado.Bdescripcion#</td>
			  <td class="fileLabel" nowrap><cf_translate key="CuentaCExp">Cuenta Cliente</cf_translate>:</td>
			  <td>#rsEmpleado.CBcc# (#rsEmpleado.Mnombre#)</td>
			</tr>
		  </table>
		</td>
	  </tr>

	  <!--- PUESTO ACTUAL --->
	  <cfset competenciasreq = exp.notasObtenidas(session.Ecodigo, Form.DEid, puesto_actual.RHPcodigo)>
	  <cfquery name="rsTotalCompetencias" dbtype="query">
	  	select sum(pesoObtenido) as sumPesoObtenido, sum(peso) as sumPeso
		from competenciasreq
	  </cfquery>
	  <cfif Len(Trim(rsTotalCompetencias.sumPeso)) and rsTotalCompetencias.sumPeso GT 0>
	  	  <cfif Len(Trim(rsTotalCompetencias.sumPesoObtenido))>
			  <cfset tiene = (100 * rsTotalCompetencias.sumPesoObtenido) / rsTotalCompetencias.sumPeso>
			  <cfset falta = 100 - tiene>
		  <cfelse>
			  <cfset tiene = 0>
			  <cfset falta = 100>
		  </cfif>
	  <cfelse>
	  	  <cfif Len(Trim(rsTotalCompetencias.sumPesoObtenido))>
			  <cfset tiene = (100 * rsTotalCompetencias.sumPesoObtenido) >
			  <cfset falta = 0 >
		  <cfelse>
			  <cfset tiene = 0>
			  <cfset falta = 100>
		  </cfif>
	  </cfif>
	  <tr>
		<td colspan="5" class="tituloListas" style="font-weight:bold; ">Puesto Actual: #HTMLEditFormat(puesto_actual.RHPdescpuesto)#</td>
		<td rowspan="#Iif((competenciasreq.recordCount LT 8),3,2)+competenciasreq.recordCount#" valign="top" align="center" width="10%">
			<cfchart format="png" chartwidth="#TamGrafico#" chartheight="#TamGrafico#" show3d="yes" showBorder="yes">
				  <cfchartseries type="pie" colorlist="##00CC99,##3399CC" >
					<cfchartdata item="Porcentaje que posee" value="#NumberFormat(tiene, '9.00')#">
					<cfchartdata item="Porcentaje que falta" value="#NumberFormat(falta, '9.00')#">
				  </cfchartseries>
			</cfchart>
		</td>
	  </tr>
	  <tr>
		<td class="tituloListas" nowrap><strong>Competencia Requerida</strong></td>
		<td class="tituloListas" align="center" nowrap><strong>Nota Req.</strong></td>
		<td class="tituloListas" align="center" nowrap><strong>Peso</strong></td>
		<td class="tituloListas" align="center" nowrap><strong>Nota Obt.</strong></td>
		<td class="tituloListas" align="center" nowrap><strong>Peso Obt.</strong></td>
	  </tr>
	  <cfloop query="competenciasreq">
		  <tr>
			<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>>#HTMLEditFormat(Trim(competenciasreq.codigo))# - #HTMLEditFormat(competenciasreq.descripcion)#</td>
			<td align="center" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>>
				<cfif Len(competenciasreq.notaRequerida)>
					#LSNumberFormat(competenciasreq.notaRequerida,',9.00')#
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<td align="center" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>>
				<cfif Len(competenciasreq.peso)>
					#LSNumberFormat(competenciasreq.peso,',9.00')#
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<td align="center" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>>
				<cfif Len(competenciasreq.notaObtenida)>
					#LSNumberFormat(competenciasreq.notaObtenida,',9.00')#
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<td align="center" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>>
				<cfif Len(competenciasreq.pesoObtenido)>
					#LSNumberFormat(competenciasreq.pesoObtenido,',9.00')#
				<cfelse>
					&nbsp;
				</cfif>
			</td>
		  </tr>
		  <!--- 
		  	Cantidad de Lineas por grafico es de 10 ya que 10 * 20 = 200 el cual es el tamaño del gráfico
			Cuando hay menos de 10 lineas la separación entre línea es demasiado gruesa, por ello se coloca un relleno
			Abajo se compara contra 8 porque hay 2 lineas de encabezados
		  --->
		  <cfif competenciasreq.recordCount LT 8>
		  	  <tr>
			  	<td colspan="5" height="#20*(8-competenciasreq.recordCount)#">&nbsp;</td>
			  </tr>
		  </cfif>
	  </cfloop>
	
	  <tr>
		<td colspan="6" class="tituloListas" style="font-weight:bold;" height="20">Planes de Sucesi&oacute;n</td>
	  </tr>
	  <!--- PLANES DE SUCESION --->
	  <cfloop query="puesto_sucesion">
		  <cfset competenciasreq = exp.notasObtenidas(session.Ecodigo, Form.DEid, puesto_sucesion.RHPcodigo)>
		  <cfquery name="rsTotalCompetencias" dbtype="query">
			select sum(pesoObtenido) as sumPesoObtenido, sum(peso) as sumPeso
			from competenciasreq
		  </cfquery>
		  <cfif Len(Trim(rsTotalCompetencias.sumPeso)) and rsTotalCompetencias.sumPeso GT 0>
			  <cfif Len(Trim(rsTotalCompetencias.sumPesoObtenido))>
				  <cfset tiene = (100 * rsTotalCompetencias.sumPesoObtenido) / rsTotalCompetencias.sumPeso>
				  <cfset falta = 100 - tiene>
			  <cfelse>
				  <cfset tiene = 0>
				  <cfset falta = 100>
			  </cfif>
		  <cfelse>
			  <cfif Len(Trim(rsTotalCompetencias.sumPesoObtenido))>
				  <cfset tiene = (100 * rsTotalCompetencias.sumPesoObtenido) >
				  <cfset falta = 0 >
			  <cfelse>
				  <cfset tiene = 0>
				  <cfset falta = 100>
			  </cfif>
		  </cfif>
		  <tr>
			<td colspan="5" style="border-top: 1px solid gray; border-bottom: 1px solid gray; font-weight:bold; font-variant:small-caps; font-size:12px; color:##000066" height="20">#HTMLEditFormat(puesto_sucesion.RHPdescpuesto)#</td>
			<!--- Cuando la cantidad de registros es menor a 8 se agrega una linea de tabla adicional para el relleno --->
			<td rowspan="#Iif((competenciasreq.recordCount LT 8),3,2)+competenciasreq.recordCount#" valign="top" align="center" width="10%">
				<cfchart format="png" chartwidth="#TamGrafico#" chartheight="#TamGrafico#" show3d="yes" showBorder="yes">
					  <cfchartseries type="pie" colorlist="##00CC99,##3399CC" >
						<cfchartdata item="Porcentaje que posee" value="#NumberFormat(tiene, '9.00')#">
						<cfchartdata item="Porcentaje que falta" value="#NumberFormat(falta, '9.00')#">
					  </cfchartseries>
				</cfchart>
			</td>
		  </tr>
		  <tr>
			<td class="tituloListas" height="20"><strong>Competencia Requerida</strong></td>
			<td class="tituloListas" align="center"><strong>Nota Req.</strong></td>
			<td class="tituloListas" align="center"><strong>Peso</strong></td>
			<td class="tituloListas" align="center"><strong>Nota Obt.</strong></td>
			<td class="tituloListas" align="center"><strong>Peso Obt.</strong></td>
		  </tr>
		  <cfloop query="competenciasreq">
			  <tr>
				<td height="20" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>>#HTMLEditFormat(Trim(competenciasreq.codigo))# - #HTMLEditFormat(competenciasreq.descripcion)#</td>
				<td align="center" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>>
					<cfif Len(competenciasreq.notaRequerida)>
						#LSNumberFormat(competenciasreq.notaRequerida,',9.00')#
					<cfelse>
						&nbsp;
					</cfif>
				</td>
				<td align="center" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>>
					<cfif Len(competenciasreq.peso)>
						#LSNumberFormat(competenciasreq.peso,',9.00')#
					<cfelse>
						&nbsp;
					</cfif>
				</td>
				<td align="center" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>>
					<cfif Len(competenciasreq.notaObtenida)>
						#LSNumberFormat(competenciasreq.notaObtenida,',9.00')#
					<cfelse>
						&nbsp;
					</cfif>
				</td>
				<td align="center" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>>
					<cfif Len(competenciasreq.pesoObtenido)>
						#LSNumberFormat(competenciasreq.pesoObtenido,',9.00')#
					<cfelse>
						&nbsp;
					</cfif>
				</td>
			  </tr>
		  </cfloop>
		  <!--- 
		  	Cantidad de Lineas por grafico es de 10 ya que 10 * 20 = 200 el cual es el tamaño del gráfico
			Cuando hay menos de 10 lineas la separación entre línea es demasiado gruesa, por ello se coloca un relleno
			Abajo se compara contra 8 porque hay 2 lineas de encabezados
		  --->
		  <cfif competenciasreq.recordCount LT 8>
		  	  <tr>
			  	<td colspan="5" height="#20*(8-competenciasreq.recordCount)#">&nbsp;</td>
			  </tr>
		  </cfif>
	  </cfloop>
	  <tr>
	    <td colspan="6">&nbsp;</td>
      </tr>
	</table>
</cfoutput>

<!--- CURSOS --->
<table width="99%"  border="0" cellspacing="0" cellpadding="2" align="center">
  <tr>
    <td colspan="4" class="tituloListas"><strong>Cursos</strong></td>
    <td class="tituloListas"><strong>Nota obtenida</strong> </td>
  </tr>
<cfoutput query="cursos" group="Mnombre">
  <tr>
    <td>&nbsp;</td>
    <td colspan="3" class="tituloListas">#Msiglas#- #Mnombre#</td>
    <td class="tituloListas"><cfif Len(RHEMnota) and RHEMnota NEQ 0>#NumberFormat(RHEMnota,',0.00')# %<cfelse><cf_translate key="en_progreso">En proceso</cf_translate></cfif></td>
  </tr><cfset el_primero=true>
  <cfif Len(Trim(descripcion))>
  <cfif el_primero><cfset el_primero=false>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4">Competencias que Afecta:</td>
    </tr>
  </cfif>
  <cfoutput>
  <tr>
    <td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>>&nbsp;</td>
    <td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>>&nbsp;</td>
    <td colspan="3" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> width="65%">#HTMLEditFormat(descripcion)#</td>
    </tr>
  </cfoutput>
  </cfif>
</cfoutput>
  <tr>
	<td colspan="5">&nbsp;</td>
  </tr>
  <tr>
	<td colspan="5" align="center"><strong>--- Fin del Reporte ---</strong></td>
  </tr>
  <tr>
	<td colspan="5">&nbsp;</td>
  </tr>
</table>
