
<cfif url.tipo EQ 1><!--- Antiguedad reconocida --->
	
	<cf_dbfunction name="to_date" args="'#url.fecha#'" returnvariable="LvarDate">	
	<cf_dbfunction name="datediff" args="ev.EVfantig|#LvarDate#|yy" returnvariable="LvarDateDiff" delimiters="|">
	<cfquery name="reporte" datasource="#Session.DSN#">
		select 
			<cf_dbfunction name="to_number" args="(#preservesinglequotes(LvarDateDiff)#/ #url.rango_corte#) * #url.rango_corte#" delimiters="|">  as corte ,
			 {fn concat({fn concat({fn concat({fn concat({fn concat({fn concat(de.DEidentificacion ,' ' )} ,de.DEnombre )},' ')},de.DEapellido1 )}, ' ' )},de.DEapellido2 )}  as empleado, 
			  <cf_dbfunction name="to_number" args="#LvarDateDiff#"> as antiguedad
			 ,'<cf_translate key="LB_PorAntiguedadReconocida">Por Antiguedad Reconocida</cf_translate>' as subtitulo
		from LineaTiempo lt
			 inner join EVacacionesEmpleado ev
				  on ev.DEid = lt.DEid
				  <cfif isdefined("url.antiguedad_min") and len(trim(url.antiguedad_min)) neq 0><!--- /*Antiguedad mínima*/ --->
				  and 	<cf_dbfunction name="to_number" args="#preservesinglequotes(LvarDateDiff)#"> >=
				  		<cfqueryparam cfsqltype="cf_sql_integer" value="#url.antiguedad_min#">
				  </cfif>
				  
				  <cfif isdefined("url.antiguedad_max") and len(trim(url.antiguedad_max)) neq 0><!--- /*Antiguedad máxima*/ --->
				  and 	<cf_dbfunction name="to_number" args="#preservesinglequotes(LvarDateDiff)#"> <=
				  		<cfqueryparam cfsqltype="cf_sql_integer" value="#url.antiguedad_max#">
				  </cfif>
			 inner join DatosEmpleado de
				  on de.Ecodigo = lt.Ecodigo
				  and de.DEid = lt.DEid 
				  
			<cfif isdefined("url.radio") and url.radio eq 2>	<!--- /*opcion de centro y centro.... si es por centro funcional*/ --->
			 inner join  RHPlazas pl   		
				  on pl.Ecodigo = lt.Ecodigo
				  and pl.RHPid = lt.RHPid
				  <cfif isdefined("url.CFid") and len(trim(url.CFid)) neq 0>
				  and pl.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
				  </cfif>
			</cfif>
		where
			 lt.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
			 and <cfqueryparam value="#url.fecha#" cfsqltype="cf_sql_timestamp"> between lt.LTdesde and lt.LThasta
			 
			 <cfif isdefined("url.radio") and url.radio eq 1 and isdefined("url.Ocodigo") and len(trim(url.Ocodigo)) neq 0><!--- /*opcion de oficina y la Oficina.... si es por Oficinas*/ --->
			 and lt.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">      
			 </cfif>
		order by corte DESC,
				 ev.EVfantig ASC , 
				 de.DEidentificacion,de.DEnombre, de.DEapellido1 ,de.DEapellido2 ASC
	</cfquery>

<cfelse>			<!--- Última accion de nombramiento --->
	<cfquery name="reporte" datasource="#Session.DSN#">
		select 
			 <cf_dbfunction name="datediff" args="dl.DLfvigencia,'#url.fecha#',yy" returnvariable="LvarDateDiff">
			 <cf_dbfunction name="to_number" args="(#preservesinglequotes(LvarDateDiff)#/ #url.rango_corte#) * #url.rango_corte#"> as corte,
			 {fn concat({fn concat({fn concat({fn concat({fn concat({fn concat(de.DEidentificacion ,' ' )} ,de.DEnombre )},' ')},de.DEapellido1 )}, ' ' )},de.DEapellido2 )}
  as empleado, 
			 <cf_dbfunction name="to_number" args="#preservesinglequotes(LvarDateDiff)#"> as antiguedad    
			,'<cf_translate key="LB_PorUltimaAccionDeNombramiento">Por Última Acción de Nombramiento</cf_translate>' as subtitulo
		from 
			LineaTiempo lt
		   	inner join DLaboralesEmpleado dl
				  on dl.Ecodigo = lt.Ecodigo
				  and dl.DEid = lt.DEid
				  <cfif isdefined("url.antiguedad_min") and len(trim(url.antiguedad_min)) neq 0><!--- /*Antiguedad mínima*/ --->
				  and <cf_dbfunction name="to_number" args="#preservesinglequotes(LvarDateDiff)#"> >=
																	<cfqueryparam cfsqltype="cf_sql_integer" value="#url.antiguedad_min#"> 
				  </cfif>                                                
				  <cfif isdefined("url.antiguedad_max") and len(trim(url.antiguedad_max)) neq 0><!--- /*Antiguedad máxima*/ --->
				  and <cf_dbfunction name="to_number" args="#preservesinglequotes(LvarDateDiff)#">   <=  
																	<cfqueryparam cfsqltype="cf_sql_integer" value="#url.antiguedad_max#"> 
				  </cfif> 
				  and dl.DLfvigencia = (select  max(dx.DLfvigencia) 
				 						from DLaboralesEmpleado dx
										where	dx.Ecodigo = lt.Ecodigo
												and dx.DEid = lt.DEid)                                              
				
			 inner join RHTipoAccion ta
				  on ta.Ecodigo = lt.Ecodigo
				  and ta.RHTid = dl.RHTid
				  and ta.RHTcomportam =1
		  
			 inner join DatosEmpleado de
				  on de.Ecodigo = lt.Ecodigo
				  and de.DEid = lt.DEid 
		
			 <cfif isdefined("url.radio") and url.radio eq 2>	<!--- /*opcion de centro y centro.... si es por centro funcional*/ --->
			 inner join  RHPlazas pl   		
				  on pl.Ecodigo = lt.Ecodigo
				  and pl.RHPid = lt.RHPid
				  <cfif isdefined("url.CFid") and len(trim(url.CFid)) neq 0>
				  and pl.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
				  </cfif>
			</cfif>
		where
			 lt.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
			 and <cfqueryparam value="#url.fecha#" cfsqltype="cf_sql_timestamp"> between lt.LTdesde and lt.LThasta
			 
			 <cfif isdefined("url.radio") and url.radio eq 1 and isdefined("url.Ocodigo") and len(trim(url.Ocodigo)) neq 0><!--- /*opcion de oficina y la Oficina.... si es por Oficinas*/ --->
			 and lt.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">      
			 </cfif>
			                                                                                                      
		order by corte DESC, dl.DLfvigencia ASC, de.DEidentificacion,de.DEnombre, de.DEapellido1 ,de.DEapellido2 ASC
	</cfquery>
	
</cfif>

 <cfif reporte.recordCount gt 0 >
	
		<cfreport format="#url.formato#" template= "EmpleadosAntiguedad.cfr" query="reporte">
			<cfreportparam name="Edescripcion" value="#Session.Enombre#">
			<cfreportparam name="Radio" value="#url.radio#">
			<cfreportparam name="Tipo" value="#url.tipo#">
		</cfreport>
<cfelse>
	<cfdocument format="flashpaper" marginleft="0" marginright="0" marginbottom="0" margintop="0" unit="in">
	<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" style="margin:0; " >
		<tr>
			<td>
				<table width="100%" cellpadding="3px" cellspacing="0">
					<tr bgcolor="##E3EDEF" style="padding-left:100px; "><td width="2%">&nbsp;</td><td align="center"><font size="1" color="##6188A5">#session.Enombre#</font></td></tr>
					<tr bgcolor="##E3EDEF"><td width="2%">&nbsp;</td><td  align="center"><font size="+1"> <cf_translate key="LB_ReporteDeEmpleadosPorAnnosLaborados">Reporte de Empleados por Años Laborados</cf_translate></font></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" style=" font-family:Helvetica; font-size:8; padding:8px;" align="center">-- <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> --</td>
		</tr>
	</table>
	</cfoutput>
	</cfdocument>
</cfif>
