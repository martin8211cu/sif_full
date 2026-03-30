<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2721" default="0" returnvariable="LvarAprobarConocimiento"/>
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2722" default="0" returnvariable="LvarAprobarHabilidad"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_PendienteDeAprobacionRH" returnvariable="MSG_PendienteDeAprobacionRH" default="Pendiente de aprobación por RH" xmlFile="/rh/generales.xml">
	<cf_translatedata name="get" tabla="RHHabilidades" col="RHHdescripcion" returnvariable="LvarRHHdescripcion">
	<cfquery name="rsH" datasource="#session.dsn#">
		select RHCEid,tipo,idcompetencia,#LvarRHHdescripcion# as descripcion, H.RHHcodigo as codigo,RHCEdominio , RHCestado 
		from RHCompetenciasEmpleado A, RHHabilidades H
			where DEid  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEID#">	
			and   A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and  tipo = 'H'
			and idcompetencia = RHHid
			and A.Ecodigo = H.Ecodigo
			and A.RHCEfdesde >= (select max(B.RHCEfdesde) from RHCompetenciasEmpleado B 
								where B.DEid    =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEID#"> 
								and   B.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and   B.Ecodigo = A.Ecodigo 
								and   B.tipo = 'H' 
								and   B.idcompetencia = A.idcompetencia )		
			 <cfif not isdefined("LvarAuto") and LvarAprobarHabilidad><!---- mientras no sea autogestion se muestra unicamente los items aprobados---->
			 	and A.RHCestado=1
			 </cfif>
		order by idcompetencia
	</cfquery>
	<!--- Se agrega para realizar la consulta desde autogestion --->
	<cf_translatedata name="get" tabla="RHPuestos" col="p.RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
		<cf_translatedata name="get" tabla="CFuncional" col="cf.CFdescripcion" returnvariable="LvarCFdescripcion">
	<cfquery datasource="#Session.DSN#" name="otrosdatos">
		select coalesce(p.RHPcodigoext,p.RHPcodigo) as RHPcodigo, #LvarRHPdescpuesto# as RHPdescpuesto, pl.CFid, cf.CFcodigo, #LvarCFdescripcion# as CFdescripcion
		from LineaTiempo lt
		
		inner join RHPuestos p
		on lt.Ecodigo=p.Ecodigo
		and lt.RHPcodigo=p.RHPcodigo
	
		inner join RHPlazas pl
		on lt.Ecodigo=pl.Ecodigo
		and lt.RHPid=pl.RHPid	
	
		inner join CFuncional cf
		on pl.Ecodigo=cf.Ecodigo
		and pl.CFid=cf.CFid
		
		where lt.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta
	</cfquery>	
	<!--- ************* --->

	<cf_translatedata name="get" tabla="RHConocimientos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
	<cfquery name="rsC" datasource="#session.dsn#">
		select RHCEid ,tipo,idcompetencia,#LvarRHCdescripcion# as descripcion, c.RHCcodigo as codigo, RHCEdominio, RHCestado
		from RHCompetenciasEmpleado a
		inner join RHConocimientosPuesto b
			on b.RHCid = a.idcompetencia
		inner join RHConocimientos c
			on c.RHCid = b.RHCid
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEID#">
		  and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#otrosdatos.RHPcodigo#">
		  and tipo = 'C'
		  and a.RHCEfdesde >= (select max(d.RHCEfdesde) 
								from RHCompetenciasEmpleado d
										where d.DEid    =  a.DEid
										  and d.Ecodigo = a.Ecodigo 
										  and d.tipo = 'C' 
										  and d.idcompetencia = a.idcompetencia )
			 <cfif not isdefined("LvarAuto") and LvarAprobarConocimiento><!---- mientras no sea autogestion se muestra unicamente los items aprobados---->
			 	and a.RHCestado=1
			 </cfif>
		order by idcompetencia
	</cfquery>
	
	<!--- CONOCIMIENTOS EVAVUALDOS Y HAN ESTAN OBSOLETOS --->
	<cf_translatedata name="get" tabla="RHConocimientos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
	<cfquery name="rsCO" datasource="#session.DSN#">
		select RHCEid ,tipo,idcompetencia,#LvarRHCdescripcion# as descripcion, b.RHCcodigo as codigo, RHCEdominio , RHCestado  
		from RHCompetenciasEmpleado a
		inner join RHConocimientos b
			on b.RHCid = a.idcompetencia
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEID#">
		  and tipo = 'C'
		  and idcompetencia not in (select RHCid
									from RHConocimientosPuesto c
									where c.Ecodigo = a.Ecodigo
									  and c.RHPcodigo =  <cfqueryparam cfsqltype="cf_sql_char" value="#otrosdatos.RHPcodigo#">)
		  and a.RHCEfdesde >= (select max(d.RHCEfdesde) 
								from RHCompetenciasEmpleado d
								where d.DEid    =  a.DEid
								  and d.Ecodigo = a.Ecodigo 
								  and d.tipo = 'C' 
								  and d.idcompetencia = a.idcompetencia )
		 <cfif not isdefined("LvarAuto") and LvarAprobarConocimiento><!---- mientras no sea autogestion se muestra unicamente los items aprobados---->
		 	and a.RHCestado=1
		 </cfif>
	</cfquery>
	
<!--- etiquetas de traduccion--->
<cfinvoke component="sif.Componentes.Translate" method="Translate"
	Default="Competencias del Empleado" Key="LB_Competencias_del_Empleado" returnvariable="LB_Competencias_del_Empleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate"
	Default="Habilidades" Key="LB_Habilidades" returnvariable="LB_Habilidades"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate"
	Default="Dominio" Key="LB_Dominio" returnvariable="LB_Dominio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate"
	Default="No hay habilidades para este empleado" Key="LB_No_hay_habilidades_para_este_empleado" returnvariable="LB_No_hay_habilidades_para_este_empleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate"
	Default="Conocimientos (relacionados al puesto)" Key="LB_Conocimientos" returnvariable="LB_Conocimientos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate"
	Default="Dominio" Key="LB_Dominio" returnvariable="LB_Dominio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate"
	Default="No hay conocimientos para este empleado" Key="LB_No_hay_conocimientos_para_este_empleado" returnvariable="LB_No_hay_conocimientos_para_este_empleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate"
	Default="Otros Conocimientos Personales" Key="LB_Conocimientos_Obsoletos" returnvariable="LB_Conocimientos_Obsoletos"/>	

	
	<form name="formlista2" method="post">
		<table width="100%" cellpadding="1" cellspacing="0" border="0">
			<tr>
			<td colspan="3"><strong><cfoutput>#LB_Competencias_del_Empleado#</cfoutput></strong></td>
			</tr>
			<tr>
				<td  class="listaCorte" colspan="2" align="left"><strong><cfoutput>#LB_Habilidades#</cfoutput></strong></td>
				<td class="listaCorte" align="right"><strong><cfoutput>#LB_Dominio#</cfoutput></strong></td>
				<td class="listaCorte" align="left" width="18" height="17" nowrap>&nbsp;</td>
			</tr> 
			<cfif rsH.recordcount gt 0>
				<cfoutput query="rsH">
					<tr class="<cfif rsH.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td>&nbsp;</td>
						<td >#trim(rsH.codigo)# - #rsH.descripcion#</td>
						<td  align="right">#LSNumberFormat(rsH.RHCEdominio,'____.__')#%</td>
                        <cfif not isdefined("LvarAuto")>
							<td onclick="javascript:Historia(#rsH.idcompetencia#,'#rsH.tipo#',#form.DEID#);"><img border="0" src="/cfmx/rh/imagenes/findsmall.gif" ></td>
                        </cfif>
                        <cfif rsH.RHCestado neq 1 and LvarAprobarHabilidad>
                        	<td><cf_notas link="<img src='/cfmx/rh/imagenes/Excl16.gif' class='imgNoAprobado'>" titulo="" pageindex="5#currentrow#" msg="#MSG_PendienteDeAprobacionRH#"></td>
                        </cfif>
					</tr>
				</cfoutput>
			<cfelse>
					<tr>
						<td  nowrap colspan="5" align="center"><cfoutput>#LB_No_hay_habilidades_para_este_empleado#</cfoutput></td>
					</tr>
			</cfif>
			<tr>
				<td  class="listaCorte" colspan="2" align="left"><strong><cfoutput>#LB_Conocimientos#</cfoutput></strong></td>
				<td class="listaCorte" align="right"><strong><cfoutput>#LB_Dominio#</cfoutput></strong></td>
				<td class="listaCorte" align="left" width="18" height="17" nowrap>&nbsp;</td>

			</tr>
			<cfif rsC.recordcount gt 0>
				<cfoutput query="rsC">
					<tr class="<cfif rsC.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td>&nbsp;</td>
						<td>#trim(rsC.codigo)# - #rsC.descripcion#</td>
						<td align="right" ><cfif rsC.RHCEdominio GTE 0>#LSNumberFormat(rsC.RHCEdominio,'____.__')#&nbsp;%<cfelse>NA</cfif></td>
                        <cfif not isdefined("LvarAuto")>
							<td onclick="javascript:Historia(#rsC.idcompetencia#,'#rsC.tipo#',#form.DEID#);"><cfif rsC.RHCEdominio GTE 0><img border="0" src="/cfmx/rh/imagenes/findsmall.gif" ></cfif></td>
                        </cfif>
                        <cfif rsC.RHCestado neq 1 and LvarAprobarConocimiento>
                        	<td><cf_notas link="<img src='/cfmx/rh/imagenes/Excl16.gif' class='imgNoAprobado'>" titulo="" pageindex="6#currentrow#" msg="#MSG_PendienteDeAprobacionRH#"></td>
                        </cfif>
					</tr>
				</cfoutput>
			<cfelse>
					<tr>
						<td  nowrap colspan="5" align="center"><cfoutput>#LB_No_hay_conocimientos_para_este_empleado#</cfoutput></td>
					</tr>
			</cfif>	
			<cfif  rsCO.recordcount GT 0>
				<tr>
					<td  class="listaCorte" colspan="2" align="left"><strong> <cfoutput> #LB_Conocimientos_Obsoletos# </cfoutput></strong></td>
					<td class="listaCorte" align="right"><strong> <cfoutput>#LB_Dominio#</cfoutput></strong></td>
					<td class="listaCorte" align="left" width="18" height="17" nowrap>&nbsp;</td>
				</tr>
				<cfoutput query="rsCO">
					<tr class="<cfif rsC.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td>&nbsp;</td>
						<td>#trim(rsCO.codigo)# - #rsCO.descripcion#</td>
						<td align="right" >#LSNumberFormat(rsCO.RHCEdominio,'____.__')#&nbsp;%</td>
                        <cfif not isdefined("LvarAuto")>
							<td onclick="javascript:Historia(#rsCO.idcompetencia#,'#rsCO.tipo#',#form.DEID#);"><img border="0" src="/cfmx/rh/imagenes/findsmall.gif" ></td>
                        </cfif>  
                        <cfif rsCO.RHCestado neq 1 and LvarAprobarConocimiento>
                        	<td><cf_notas link="<img src='/cfmx/rh/imagenes/Excl16.gif' class='imgNoAprobado'>" titulo="" pageindex="7#currentrow#" msg="#MSG_PendienteDeAprobacionRH#"></td>
                        </cfif>
					</tr>
				</cfoutput>
			</cfif>
		</table>
		<!----
		<table width="100%">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td class="listaCorte" colspan="6"><b>Simbología</b>:<br><img src="/cfmx/rh/imagenes/Excl16.gif">: <i>Pendiente de aprobación por RH</i></td>
			</tr>
		</table>
		----->
	</form>
	
	<script type="text/javascript" language="javascript1.2" >
		function Historia(idcompetencia,tipo,DEid){
			var PARAM  = "CompetenciaHistoria.cfm?idcompetencia="+ idcompetencia + "&tipo=" + tipo+ "&DEid=" + DEid
			open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
		}
	</script>
