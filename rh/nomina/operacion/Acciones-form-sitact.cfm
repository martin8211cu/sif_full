<style type="text/css">
	.Completo { 
		background:#F5F5F5;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
</style>
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
	  <tr>
		<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="LB_Situacion_Actual">Situaci&oacute;n Actual</cf_translate></div></td>
	  </tr>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Empresa">Empresa</cf_translate></td>
		<td height="25" nowrap>#Session.Enombre#</td>
	  </tr>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Plaza">Plaza</cf_translate></td>
		<!----<td height="25" nowrap>#rsEstadoActual.Plaza#</td>---->
		<td height="25" nowrap>#rsEstadoActual.RHPPcodigo# -  #rsEstadoActual.RHPPdescripcion#</td>
	  </tr>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate></td>
		<td height="25" nowrap>#rsEstadoActual.Odescripcion#</td>
	  </tr>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Departamento">Departamento</cf_translate></td>
		<td height="25" nowrap>#rsEstadoActual.Ddescripcion#</td>
	  </tr>
	  <tr>
	  	<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Centro_Funcional">Centro Funcional</cf_translate></td>
		<td>#rsEstadoActual.Ctrofuncional#</td>
	  </tr>
	  <cfif usaEstructuraSalarial EQ 1>		 
		  <cf_rhcategoriapuesto form="form1" query="#rsEstadoActual#" tablaReadonly="true" 
		  categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false"
		  index="1">
	  </cfif>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Puesto_RH">Puesto RH</cf_translate></td>
		<td height="25" nowrap>#rsEstadoActual.Puesto#</td>
	  </tr>	
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Jornada">Jornada</cf_translate></td>
		<td height="25" nowrap>#rsEstadoActual.Jornada#</td>
	  </tr>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Porcentaje_de_Plaza">Porcentaje de Plaza</cf_translate></td>
		<td height="25" nowrap><cfif rsEstadoActual.LTporcplaza NEQ "">#LSCurrencyFormat(rsEstadoActual.LTporcplaza,'none')# %<cfelse>0.00 %</cfif></td>
	  </tr>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Porcentaje_de_Salario_Fijo">Porcentaje de Salario Fijo</cf_translate></td>
		<td height="25" nowrap><cfif rsEstadoActual.LTporcsal NEQ "">#LSCurrencyFormat(rsEstadoActual.LTporcsal,'none')# %<cfelse>0.00 %</cfif></td>
	  </tr>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Tipo_de_Nomina">Tipo de N&oacute;mina</cf_translate></td>
		<td height="25" nowrap>#rsEstadoActual.Tdescripcion#</td>
	  </tr>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Regimen_de_Vacaciones">R&eacute;gimen de Vacaciones</cf_translate></td>
		<td height="25" nowrap>#rsEstadoActual.RegVacaciones#</td>
	  </tr>	  	  
	  <cfif rsAccion.RHTcomportam EQ 3>
			<cfquery name="rsFechaIngreso" datasource="#session.DSN#">
				select EVfantig as ingreso,
					coalesce(EVfecha, EVfantig) as cortevacaciones
					,coalesce(EVfecha,EVfantig) as fechaUltimaVaca
				from EVacacionesEmpleado 
				where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DEid#">
			</cfquery>	
			<cfset vFecha = ListToArray(LSDateFormat(rsFechaIngreso.ingreso,'dd/mm/yyyy'),'/')>
			<cfset fecha_ingreso = Createdate(vFecha[3],vFecha[2],vfecha[1]) >
			<cfset anno = DateDiff('yyyy', fecha_ingreso, rsAccion.DLfvigencia)>
			<cfset fecha_corte = rsFechaIngreso.cortevacaciones>
			<cfset meses = DateDiff('d', fecha_corte, rsAccion.DLfvigencia)>
			<cfset meses = meses  / 30.0>			
			
			<cfquery name="rsVacaciones" datasource="#Session.DSN#">
				select 	coalesce(sum(b.DVEdisfrutados+b.DVEcompensados),0) as Disponibles
				from EVacacionesEmpleado a
				left outer join DVacacionesEmpleado b
				   on a.DEid = b.DEid
				   and b.DVEfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.DLfvigencia#">
				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DEid#">
			</cfquery>	  
			<!--- <cf_dump var="#rsAccion.RVid#"> --->
		  <cfquery name="rsDias" datasource="#session.DSN#">
				select coalesce(rv.DRVdias, 0) as DRVdias
				from DRegimenVacaciones rv 
				where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.RVid#">
				  and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
									 from DRegimenVacaciones rv2 
									 where rv2.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.RVid#">
									   and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_float" value="#anno+1#"> )
			</cfquery>
			<!--- calcula el saldo corriente de vacaciones --->
			<cfif rsDias.recordCount GT 0 and Len(Trim(rsDias.DRVdias))>
				<cfset saldo_corriente = (rsDias.DRVdias*meses)/12.0>
			</cfif>
			<cfif isdefined("rsVacaciones") and  Len(Trim(rsVacaciones.Disponibles)) >
				<cfset disponibles = rsVacaciones.Disponibles + saldo_corriente >
			<cfelse>
				<cfset disponibles = saldo_corriente >
			</cfif>
	  		 <tr>
			 	<td  class="Completo" colspan="2" height="50" valign="top">
					<!--- <fieldset><legend><cf_translate key="LB_Saldo_Vacaciones">Saldo Vacaciones (D&iacute;as)</cf_translate></legend> --->
						<table width="100%" border="0" cellpadding="1" cellspacing="1">
							<tr>
								<td height="25" colspan="4" class="fileLabel">
									<cf_translate key="LB_Saldo_Vacaciones">Saldo Vacaciones</cf_translate>
								</td>
							</tr>
							<tr>
								<td height="20"  width="25%" nowrap><cf_translate key="Proyectado">Proyectado</cf_translate></td>
								<td height="20"  width="25%" nowrap>#LSNumberFormat(disponibles,'.00')#</td>
								<td height="20"  width="25%" nowrap><cf_translate key="Asignado">Asignado</cf_translate></td>
								<td height="20"  width="25%" nowrap>#LSNumberFormat(rsVacaciones.disponibles,'.00')#</td>
							</tr>					
						
						</table>
					<!--- </fieldset> --->
				
				</td>
			 </tr>
	  
		  <!--- <tr>
			<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Saldo_Proyectado">Saldo Proyectado (D&iacute;as)</cf_translate></td>
			<td height="25" nowrap>#LSNumberFormat(disponibles,'.00')#</td>
			</tr>
		  <tr>
			<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Saldo_Asignado">Saldo Asignado (D&iacute;as)</cf_translate></td>
			<td height="25" nowrap>#LSNumberFormat(rsVacaciones.disponibles,'.00')#</td>
			</tr> --->
	  </cfif>	 
	  
		<!--- Desarrollo DHC - Baroda --->
		<!--- Si la accion es de incapacidad y la empresa proceso dias de enfermedad (p. 960 = 1), se pinta esa seccion de codigo --->
		<cfif rsAccion.RHTcomportam EQ 5>
			<cfquery name="rs_p960" datasource="#session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Pcodigo = 960
			</cfquery>

			<cfif trim(rs_p960.Pvalor) eq 1>
				<cfquery name="rs_saldodiasenf" datasource="#session.DSN#">
					select DEid, sum(DVEenfermedad) as dias
					from DVacacionesEmpleado
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DEid#">
					group by DEid				
				</cfquery>
				<tr>
					<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Saldo_Dias_de_Enfermedad">Saldo D&iacute;as de Enfermedad</cf_translate></td>
					<td height="25" nowrap>#LSNumberFormat(rs_saldodiasenf.dias,'.00')#</td>
				</tr>	
			</cfif>
		</cfif>	  
	  
	  <!---
	  <cfif usaEstructuraSalarial EQ 1>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="CategoriaACP">Categor&iacute;a / Paso</cf_translate></td>
		<td height="25" nowrap>
			<cfif Len(Trim(rsEstadoActual.Categoria)) and Len(Trim(rsEstadoActual.Paso))>
				#rsEstadoActual.Categoria# - #rsEstadoActual.Paso#
			<cfelse>
				&nbsp;
			</cfif>
		</td>
		</tr>
	  <tr>
		<td height="25" class="fileLabel" nowrap><cf_translate key="TpoTablaACP">Tipo de Tabla</cf_translate></td>
		<td height="25" nowrap>
			<cfif Trim(rsEstadoActual.TipoTabla) NEQ "-">
				#rsEstadoActual.TipoTabla#
			<cfelse>
				&nbsp;
			</cfif>
		</td>
		</tr>
	  </cfif>
	  --->
	</table>
</cfoutput>