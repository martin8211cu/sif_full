<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2724" default="0" returnvariable="LvarAprobarEducacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_PendienteDeAprobacionRH" returnvariable="MSG_PendienteDeAprobacionRH" default="Pendiente de aprobación por RH" xmlFile="/rh/generales.xml">
<cfquery name="rsEducacion" datasource="#session.DSN#">
	select  coalesce(a.RHEtitulo,a.RHEOtrotitulo) as RHEtitulo,
			case  when a.RHEotrains is not null then a.RHEotrains
				else b.RHIAnombre end as institucion,	
			a.RHEfechaini, 
			a.RHEfechafin,
			a.RHEsinterminar,
			a.RHEestado					
	from RHEducacionEmpleado a
		left outer join RHInstitucionesA b
			on a.RHIAid= b.RHIAid
			and a.Ecodigo = b.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("RHOid") and len(trim(RHOid))>
			and a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#">	
		<cfelse>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">	
		</cfif>		
		 <cfif not isdefined("LvarAuto") and LvarAprobarEducacion><!---- mientras no sea autogestion se muestra unicamente los items aprobados---->
		 	and a.RHEestado=1
		 </cfif>
	order by a.RHEfechafin desc
</cfquery>	
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr>
		<td class="listaCorte"><cf_translate key="LB_Institucion">Instituci&oacute;n</cf_translate></td>
		<td class="listaCorte"><cf_translate key="LB_TituloObtenido">T&iacute;tulo obtenido</cf_translate></td>
		<td class="listaCorte"><cf_translate key="LB_FechaFinalizacion" xmlFile="Expediente.xml">Fecha finalizaci&oacute;n</cf_translate></td>
	</tr>
	<cfif rsEducacion.recordcount gt 0>
		<cfoutput query="rsEducacion">
			<tr class="<cfif rsEducacion.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
				<td>#rsEducacion.institucion#</td>
				<td>#rsEducacion.RHEtitulo#</td>
				<td>
					<cfif rsEducacion.RHEsinterminar EQ 1>
						<cf_translate key="LB_SinTerminar">Sin terminar</cf_translate>
					<cfelse>
						<cf_locale name="date" value="#rsEducacion.RHEfechafin#"/>
					</cfif>
				</td>
		        <cfif rsEducacion.RHEestado neq 1 and LvarAprobarEducacion>
                	<td><cf_notas link="<img src='/cfmx/rh/imagenes/Excl16.gif' class='imgNoAprobado'>" titulo="" pageindex="4#currentrow#" msg="#MSG_PendienteDeAprobacionRH#"></td>
                </cfif>
			</tr>	
			</cfoutput>
	<cfelse>
		<tr><td colspan="3" align="center">-<cf_translate key="LB_ElColaboradorNoTieneEducacionRegistrada">El colaborador no tiene educación registrada</cf_translate>-</td></tr>
	</cfif>
</table>
