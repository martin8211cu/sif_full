 <cfif  isdefined("Form.DEid")>
	 <cfif  isdefined("form.ext") and  form.ext  eq 1 >
		<!--- <cfset form.RHPcodigo = 'ANP1'> --->
		<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
		<cfset Gpaso = 4>
		
		<cfquery name="rsEmpresa" datasource="#session.DSN#">
			select Edescripcion from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	</cfif>
	
	<!---*******************************--->
	<!---  inicialización de variables  --->
	<!---*******************************--->
	<cfset form.TIENE = "S">
	<!---*******************************--->
	<!---  área de consultas            --->
	<!---*******************************--->
	<cfquery name="rsPuesto" datasource="#session.DSN#">
		select coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigoext,a.RHPcodigo,RHPdescpuesto , b.PSporcreq
			from RHPuestos  a
			left outer join RHPlanSucesion b   
					on a.Ecodigo = b.Ecodigo
					and a.RHPcodigo = b.RHPcodigo
		where a.Ecodigo  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHPcodigo  =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	</cfquery>

	<cfquery name="empleado" datasource="#session.DSN#">       
	  select b.DEid,
	  DEidentificacion as identificacion,
	  <cf_dbfunction name="concat" args="b.DEnombre,' ',b.DEapellido1,'  ',b.DEapellido2"> as NombreEmp,
	  p.RHPcodigo,
	  coalesce(p.RHPcodigoext,p.RHPcodigo) as RHPcodigoext,
	  p.RHPdescpuesto
	  from DatosEmpleado b, LineaTiempo lt, RHPuestos p
	  where b.DEid    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEid#">
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and lt.DEid = b.DEid
		and lt.Ecodigo = b.Ecodigo
		and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between lt.LTdesde and lt.LThasta
		and lt.Ecodigo = p.Ecodigo
		and lt.RHPcodigo = p.RHPcodigo
  </cfquery>
	
	<cfinvoke component="home.Componentes.Seguridad" method="getUsuarioByRef" returnvariable="usu"
		referencia="#form.deid#" Ecodigo="#session.EcodigoSDC#" tabla="DatosEmpleado"></cfinvoke>
	
	<cfinvoke component="home.Componentes.Seguridad" method="getUsuarioByCod" returnvariable="alu"
		Usucodigo="#usu.Usucodigo#" Ecodigo="#session.EcodigoSDC#" tabla="PersonaEducativo"></cfinvoke>

	<cfquery name="hab" datasource="#session.DSN#">							
		select rhh.RHHdescripcion as descripcion, notas.RHCEdominio, hp.RHHpeso as peso, (hp.RHHpeso * notas.RHCEdominio) as resultado,
				m.Mnombre,
					(
						select count(1)
						from CursoAlumno ca join Curso cu on ca.Ccodigo = cu.Ccodigo
						where cu.Mcodigo = m.Mcodigo
						  and ca.Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#alu.llave#">
					) as llevado
			from RHHabilidadesPuesto hp
				left join RHCompetenciasEmpleado notas
				   on notas.idcompetencia = hp.RHHid
				   and notas.tipo  = 'H'
				   and notas.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEid#">
				   and notas.Ecodigo    =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				join RHHabilidades rhh
					on rhh.RHHid = hp.RHHid
				left join RHHabilidadesMaterias cm
					on cm.RHHid = rhh.RHHid
					and cm.Ecodigo = rhh.Ecodigo
				left join Materia m
					on cm.Mcodigo = m.Mcodigo
			where hp.RHPcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
			  and hp.Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			order by descripcion, Mnombre, notas.RHCEfdesde desc
	</cfquery>

	<cfquery name="con" datasource="#session.DSN#">							
		select rhh.RHCdescripcion as descripcion, notas.RHCEdominio, hp.RHCpeso as peso, (hp.RHCpeso * notas.RHCEdominio) as resultado,
			m.Mnombre,
			(
				select count(1)
				from CursoAlumno ca join Curso cu on ca.Ccodigo = cu.Ccodigo
				where cu.Mcodigo = m.Mcodigo
				  and ca.Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#alu.llave#">
			) as llevado
		from RHConocimientosPuesto hp
			left join RHCompetenciasEmpleado notas
				on notas.idcompetencia =hp.RHCid
				and notas.tipo  = 'C'
				and notas.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEid#">
				and notas.Ecodigo    =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			join RHConocimientos rhh
				on rhh.RHCid = hp.RHCid
			left join RHConocimientosMaterias cm
				on cm.RHCid = rhh.RHCid
				and cm.Ecodigo = rhh.Ecodigo
			left join Materia m
				on cm.Mcodigo = m.Mcodigo
		where hp.RHPcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
		and hp.Ecodigo    =   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		order by descripcion, Mnombre, notas.RHCEfdesde desc
	</cfquery>
	
	
	<cfset NotaTotal_resultado = 0>
	<cfset NotaTotal_peso = 0>
	<cfoutput query="hab" group="descripcion"><!--- porque la primera que sale es la mas reciente --->
		<cfif Len(resultado)><cfset NotaTotal_resultado = NotaTotal_resultado + resultado></cfif>
		<cfif Len(peso)><cfset NotaTotal_peso = NotaTotal_peso + peso></cfif>
	</cfoutput>
	<cfoutput query="con" group="descripcion"><!--- porque la primera que sale es la mas reciente --->
		<cfif Len(resultado)><cfset NotaTotal_resultado = NotaTotal_resultado + resultado></cfif>
		<cfif Len(peso)><cfset NotaTotal_peso = NotaTotal_peso + peso></cfif>
	</cfoutput>
	
	<cfquery name="habextra" datasource="#session.DSN#">
		select rhh.RHHdescripcion as descripcion, notas.RHCEdominio, notas.RHCEdominio as promedio
		from RHCompetenciasEmpleado notas
		join RHHabilidades rhh
			on rhh.RHHid  = notas.idcompetencia	
		where notas.DEid  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEid#">
		and notas.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 and notas.tipo  = 'H'
		  and not exists ( select 1 from RHHabilidadesPuesto hp where notas.idcompetencia = hp.RHHid
				and hp.RHPcodigo  =  <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
				and hp.Ecodigo    =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
		order by descripcion, notas.RHCEfdesde  desc
	</cfquery>
	
	<cfquery name="conextra" datasource="#session.DSN#">							
		select rhh.RHCdescripcion as descripcion, notas.RHCEdominio, notas.RHCEdominio as promedio
		from RHCompetenciasEmpleado  notas
		join RHConocimientos rhh
				on rhh.RHCid = notas.idcompetencia	
		where notas.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEid#">
		   and notas.Ecodigo    =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and notas.tipo  = 'C'
		   and not exists ( select 1 from RHConocimientosPuesto hp where notas.idcompetencia = hp.RHCid
				and hp.RHPcodigo  =  <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
				and hp.Ecodigo    =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
		order by descripcion, notas.RHCEfdesde  desc
	</cfquery>	
	
	<!---*******************************--->
	<!--- Información del Concurso      --->
	<!---*******************************--->
	<cfif  isdefined("Form.ext") and form.ext  eq 1>
	<table  width="100%"  align="center"border="0">
		<tr>
			<td  align="center" colspan="5"><font size="2"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></font></td>
		</tr>
		<tr>
			<td  align="center" colspan="5"><font size="2"><strong>Detalle de progreso</strong></font></td>
		</tr>
			<tr>
				<td width="20%" align="left" >C&oacute;d. Puesto:</td>
				<td width="80%"><strong><cfoutput>#rsPuesto.RHPcodigoext#</cfoutput></strong></td>
			</tr>
			<tr>
				<td align="left">Descripci&oacute;n:</td>
				<td><strong><cfoutput>#rsPuesto.RHPdescpuesto#</cfoutput></strong></td>
			</tr>	
			<tr>
				<td align="left">Porcentaje Requerido:</td>
				<td><strong><cfoutput>#rsPuesto.PSporcreq#</cfoutput>&nbsp;%</strong></td>
			</tr>	
<tr>
                    <td align="left">Candidato</td>
                    <td><strong><cfoutput>#HTMLEditFormat(empleado.identificacion)# - #HTMLEditFormat(empleado.NombreEmp)#</cfoutput></strong></td>
                  </tr>
                  <tr>
                    <td align="left">Puesto Actual </td>
                    <td><cfoutput><strong>#empleado.RHPcodigoext# - #empleado.RHPdescpuesto#</strong></cfoutput></td>
                  </tr>
                  <tr>
                    <td valign="top">Calificacion</td>
                    <td><cfoutput><strong><cfif NotaTotal_peso>
						#NumberFormat(NotaTotal_resultado/NotaTotal_peso,',0.00')#
						<cfelse>0.00</cfif>
						</strong></cfoutput> %</td>
                  </tr>			
	</table>
	
	<cfelse>
		<table  width="75%"  align="center"border="0">
			<tr>
				<td width="72%" valign="top"><table width="100%"  border="0">
                  <tr>
                    <td align="left" >C&oacute;d. Puesto:</td>
                    <td><strong><cfoutput>#rsPuesto.RHPcodigoext#</cfoutput></strong></td>
                  </tr>
                  <tr>
                    <td align="left">Descripci&oacute;n:</td>
                    <td><strong><cfoutput>#rsPuesto.RHPdescpuesto#</cfoutput></strong></td>
                  </tr>
                  <tr>
                    <td align="left">Porcentaje Requerido:</td>
                    <td><strong><cfoutput>#rsPuesto.PSporcreq#</cfoutput>&nbsp;%</strong></td>
                  </tr>
                  <tr>
                    <td align="left">Candidato</td>
                    <td><strong><cfoutput>#HTMLEditFormat(empleado.identificacion)# - #HTMLEditFormat(empleado.NombreEmp)#</cfoutput></strong></td>
                  </tr>
                  <tr>
                    <td align="left">Puesto Actual </td>
                    <td><cfoutput><strong>#empleado.RHPcodigoext# - #empleado.RHPdescpuesto#</strong></cfoutput></td>
                  </tr>
                  <tr>
                    <td valign="top">Calificacion</td>
                    <td><cfoutput><strong><cfif NotaTotal_peso>
						#NumberFormat(NotaTotal_resultado/NotaTotal_peso,',0.00')#
						<cfelse>0.00</cfif>
						</strong></cfoutput> %</td>
                  </tr>
                  <tr>
                    <td align="left">&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                </table></td>
			    <td valign="top">&nbsp;</td>
		    </tr>
		</table>
</cfif>
	<!---*******************************--->
	<!--- aréa de pintado               --->
	<!---*******************************--->
	<form action="<cfoutput>#CurrentPage#</cfoutput>" method="post" name="form1" style="margin:0" >
		<input type="hidden" name="paso" value="<cfoutput>#Gpaso#</cfoutput>">
		<input type="hidden" name="RHPcodigo"  	
		value="<cfif isdefined("rsPuesto.RHPcodigo")and (rsPuesto.RHPcodigo GT 0)><cfoutput>#rsPuesto.RHPcodigo#</cfoutput></cfif>">
		
	<!---*******************************--->
	<!--- Información del botones       --->
	<!---*******************************--->
	
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center"> 
					<cfif not isdefined("form.ext")>
						<input type="hidden" name="botonSel" value="">
						<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1">
						<input type="submit" name="Anterior" 
						value="<< Anterior" 
						onClick="javascript: this.form.botonSel.value = this.name; if (window.funcAnterior) return funcAnterior();" tabindex="0">
						<input type="reset" name="Limpiar" value="Limpiar" 
						onClick="javascript: this.form.botonSel.value = this.name; if (window.funcLimpiar) return funcLimpiar();" tabindex="0">
					</cfif>
					
	
				</td>
			</tr>
	  </table>
	
	</form>
	
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
	<tr>
	<td valign="top" width="50%">
		<cfif hab.RecordCount gt 0>
			<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
				<tr><td colspan="3" align="center">&nbsp;</td></tr>
				  <td colspan="3"  align="center"   bgcolor="#CCCCCC" valign="top"><strong>Habilidades para el puesto y sus cursos correspondientes </strong></td>
				<cfoutput query="hab" group="descripcion">
				<cfset rowspan = 20>
				<tr>
				  <td width="10%" rowspan="#rowspan+1#" valign="top"><cfif Len(RHCEdominio) is 0 Or RHCEdominio Is 0><img src="x-negro.gif" width="50" height="56" border="0" title="No cumple" alt="No"> <cfelseif RHCEdominio GE rsPuesto.PSporcreq><img src="check-verde.gif" width="50" height="56" border="0" title="Cumple" alt="Si"> 
				  <cfelse><img src="check-negro.gif" width="50" height="56" border="0" title="" alt=""></cfif></td>
				  <td colspan="2"><strong>#HTMLEditFormat(DESCRIPCION)#</strong> <cfif Len(RHCEdominio)>( #NumberFormat(RHCEdominio,',0.0')#% ) </cfif></td>
				</tr><cfoutput group="Mnombre"><cfset rowspan=rowspan-1>
				<tr>
				  <td width="3%"><cfif llevado neq 0><img src="check-negro-12px.gif" width="12" height="13" border="0">
				  <cfelse><img src="blank.gif" width="12" height="13" border="0">
				  </cfif> </td>
				  <td width="87%"><cfif Len(Mnombre) Is 0>No hay cursos disponibles<cfelse>#HTMLEditFormat(Mnombre)#</cfif></td>
			  </tr></cfoutput>
			  <cfif rowspan GT 0><cfloop from="1" to="#rowspan#" index="i"><tr><td colspan="2"></td></tr></cfloop></cfif>
			  </cfoutput>
			</table>
		</cfif>
	</td>
	<td valign="top" width="50%">
		<cfif con.RecordCount gt 0>
			<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
				<tr><td colspan="3" align="center">&nbsp;</td></tr>
				  <td colspan="3"  align="center"   bgcolor="#CCCCCC" valign="top"><strong>Conocimientos para el puesto y sus cursos correspondientes </strong></td>
				<cfoutput query="con" group="descripcion">
				<cfset rowspan = 20>
				<tr>
				  <td width="10%" rowspan="#rowspan+1#" valign="top"><cfif Len(RHCEdominio) is 0 Or RHCEdominio Is 0><img src="x-negro.gif" width="50" height="56" border="0" title="No cumple" alt="No"> <cfelseif RHCEdominio GE rsPuesto.PSporcreq><img src="check-verde.gif" width="50" height="56" border="0" title="Cumple" alt="Si"> 
				  <cfelse><img src="check-negro.gif" width="50" height="56" border="0" title="" alt=""></cfif></td>
				  <td colspan="2"><strong>#HTMLEditFormat(DESCRIPCION)#</strong> <cfif Len(RHCEdominio)>( #NumberFormat(RHCEdominio,',0.0')#% ) </cfif></td>
				</tr><cfoutput group="Mnombre"><cfset rowspan=rowspan-1>
				<tr>
				  <td width="3%"><cfif llevado neq 0><img src="check-negro-12px.gif" width="12" height="13" border="0">
				  <cfelse><img src="blank.gif" width="12" height="13" border="0">
				  </cfif> </td>
				  <td width="87%"><cfif Len(Mnombre) Is 0>No hay cursos disponibles<cfelse>#HTMLEditFormat(Mnombre)#</cfif></td>
			  </tr></cfoutput>
			  <cfif rowspan GT 0><cfloop from="1" to="#rowspan#" index="i"><tr><td colspan="2"> </td></tr></cfloop></cfif>
			  </cfoutput>
			</table>
		</cfif>
	</td>
	</tr>
	
		
	<cfif hab.RecordCount is 0 and con.RecordCount is 0>
		<tr><td colspan="2" valign="top">
			<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
				<tr><td colspan="3" align="center">&nbsp;</td></tr>
				  <td colspan="3"  align="center"   bgcolor="#CCCCCC" valign="top"><strong>No se han definido habilidades ni conocimientos para este puesto </strong></td>
			</table>
		</td></tr>
	</cfif>
	<tr><td valign="top">
		<cfif (habextra.RecordCount gt 0)>
			<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
				<tr><td colspan="3" align="center">&nbsp;</td></tr>
				  <td colspan="3"  align="center"   bgcolor="#CCCCCC" valign="top"><strong>Habilidades adicionales que posee el empleado</strong></td>
				
				<cfoutput query="habextra" group="descripcion">
				<tr>
				  <td width="10%"></td>
				  <td width="57%">#HTMLEditFormat(DESCRIPCION)# </td>
				  <td width="33%"> #NumberFormat(promedio,',0.0')#%</td>
				</tr></cfoutput>
			</table>
		</cfif>
	</td><td valign="top">
		<cfif (conextra.RecordCount gt 0)>
			<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
				<tr><td colspan="3" align="center">&nbsp;</td></tr>
				  <td colspan="3"  align="center"   bgcolor="#CCCCCC" valign="top"><strong>Conocimientos adicionales que posee el empleado</strong></td>
				<cfoutput query="conextra" group="descripcion">
				<tr>
				  <td width="10%"></td>
				  <td width="57%">#HTMLEditFormat(DESCRIPCION)# </td>
				  <td width="33%"> #NumberFormat(promedio,',0.0')#%</td>
				</tr></cfoutput>
			</table>
		</cfif>
	</td></tr>
	<tr><td colspan="2">
	
		<table width="100%" border="0" cellpadding="2" cellspacing="0">
			  <tr><td colspan="4" align="center">&nbsp;</td></tr>
				  <td colspan="4"  align="center"   bgcolor="#CCCCCC" valign="top"><strong>Detalle de la calificaci&oacute;n asignada</strong></td>
				<tr>
				<td><strong>Habilidades y conocimientos</strong></td>
				<td align="right"><strong>Peso</strong></td>
				<td align="right"><strong>Nota</strong></td>
				<td align="right"><strong>Puntos</strong></td>
			  </tr>
			  <cfoutput query="hab" group="descripcion"><!--- porque la primera que sale es la mas reciente --->
			  <tr>
				<td>#HTMLEditFormat(descripcion)#&nbsp;</td>
				<td align="right">#NumberFormat(peso,',0.00')#</td>
				<td align="right"><cfif Len(RHCEdominio)>#NumberFormat(RHCEdominio,',0.00')#<cfelse>-</cfif></td>
				<td align="right"><cfif Len(RHCEdominio)>#NumberFormat(resultado,',0.00')#<cfelse>-</cfif></td>
			  </tr></cfoutput>
			  <cfoutput query="con" group="descripcion"><!--- porque la primera que sale es la mas reciente --->
			  <tr>
				<td>#HTMLEditFormat(descripcion)#&nbsp;</td>
				<td align="right">#NumberFormat(peso,',0.00')#</td>
				<td align="right"><cfif Len(RHCEdominio)>#NumberFormat(RHCEdominio,',0.00')#<cfelse>-</cfif></td>
				<td align="right"><cfif Len(RHCEdominio)>#NumberFormat(resultado,',0.00')#<cfelse>-</cfif></td>
			  </tr></cfoutput>
			  <tr>
				<td style="border-top:3px double black;">Total</td>
				<td style="border-top:3px double black;"align="right"><cfoutput>#NumberFormat(NotaTotal_peso,',0.00')#</cfoutput></td>
				<td style="border-top:3px double black;"align="right">&nbsp;</td>
				<td style="border-top:3px double black;" align="right"><cfoutput><cfif NotaTotal_peso>
						#NumberFormat(NotaTotal_resultado/NotaTotal_peso,',0.00')#
						<cfelse>0.00</cfif></cfoutput></td>
			  </tr>
		</table>
	</td></tr>
	</table>
	
<cfelse>
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr><td colspan="3" align="center"><strong>Debe selecionar un empleado de la lista</strong></td></tr>

	</table>
</cfif>