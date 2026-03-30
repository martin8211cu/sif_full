<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PorFavorSeleccioneLosConocimientosOHabilidadesDeLaListaParaElegirCursos"
	Default="Por Favor Seleccione los conocimientos o habilidades de la lista para elegir cursos"
	returnvariable="LB_PorFavorSeleccioneLosConocimientosOHabilidadesDeLaListaParaElegirCursos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CursosRelacionadosActualmente"
	Default="Cursos Relacionados Actualmente"
	returnvariable="LB_CursosRelacionadosActualmente"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NoHayCursosRelacionadas"
	Default="No hay Cursos Relacionadas"
	returnvariable="LB_NoHayCursosRelacionadas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SeleccionDeCursos"
	Default="Selecci&oacute;n de Cursos"
	returnvariable="LB_SeleccionDeCursos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Institucion"
	Default="Instituci&oacute;n"
	returnvariable="LB_Institucion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RelacionarCursos"
	Default="Relacionar Cursos"
	returnvariable="LB_RelacionarCursos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Siglas"
	Default="Siglas"
	returnvariable="LB_Siglas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Peso"
	Default="Peso"
	returnvariable="LB_Peso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	returnvariable="BTN_Limpiar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Buscar"
	Default="Buscar"
	returnvariable="BTN_Buscar"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined("ckMat")>
	<cfloop list="#ckMat#" delimiters="," index="codmat">
		<!--- Relaciona las materias a la habilidad o conocimiento segun corresponda --->
		<cfif isdefined("Tipo") and Tipo eq "C">
			<!----  INSERTAR PESO ---->						
			<cfquery datasource="#session.dsn#" name="rsInclusioncon">
			Insert into RHConocimientosMaterias(Ecodigo, Mcodigo, RHCid, Usucodigo, RHCMfalta, RHCMestado)
			values(#Session.Ecodigo#,#codmat#,#RHcodigo#,#Session.Usucodigo#,getdate(),1)
			</cfquery>
		<cfelse>
			<!----  INSERTAR PESO ---->
			<cfquery datasource="#session.dsn#" name="rsInclusionhab">
			Insert into RHHabilidadesMaterias(Ecodigo, Mcodigo, RHHid, Usucodigo, RHHMfalta, RHHMestado)
			values(#Session.Ecodigo#,#codmat#,#RHcodigo#,#Session.Usucodigo#,getdate(),1)
			</cfquery>
		</cfif>
	</cfloop>
	<!----<script>alert("Los Cursos han sido relacionadas")</script>---->
</cfif>
<cfif isdefined("bandBorrar")>
	<cfif isdefined("B_Tipo") and B_Tipo eq "C">
		<cfquery datasource="#session.dsn#" name="rsBorrarcon">
			Delete from RHConocimientosMaterias
			where Ecodigo = #Session.Ecodigo#
			  and Mcodigo = #B_Mcodigo#
			  and RHCid   = #B_RHcodigo#
		</cfquery> 
	<cfelse>
		<cfquery datasource="#session.dsn#" name="rsBorrarhab">
			Delete from RHHabilidadesMaterias
			where Ecodigo = #Session.Ecodigo#
			  and Mcodigo = #B_Mcodigo#
			  and RHHid   = #B_RHcodigo#
		</cfquery> 
	</cfif>
	<!---<script>alert("El Curso ha sido eliminado")</script>--->
</cfif>
<cfif isdefined("codigo")>
	<cfif isdefined("Tipo") and Tipo eq "C">
		<!--- Se seleccionan todas las materias que estan relacionadas a una habilidad --->
		<cfquery datasource="#session.dsn#" name="rsM_conocimientos">
			Select C.Mcodigo, C.Mnombre, C.Msiglas, B.RHCid, A.Tipo
			from RHCompetencias A, RHConocimientosMaterias B, RHMateria C
			where  A.id 	 	= B.RHCid
			   and B.Mcodigo 	= C.Mcodigo
			   and A.Tipo 	 	= 'C'
			   and B.RHCMestado = 1
			   and C.Mactivo 	= 1
			   and A.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			   and A.codigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#codigo#">
			Order by C.Mnombre  
		</cfquery>
		<cfset nombreqry = "rsM_conocimientos">
		<cfset Matlista= "">
		<cfoutput query="rsM_conocimientos">
			<cfif Matlista eq "">
				<cfset Matlista= #Mcodigo#>
			<cfelse>
				<cfset Matlista= Matlista & "," & #Mcodigo#>
			</cfif>
		</cfoutput>
	<cfelse>
		<!--- Se seleccionan todas las materias que estan relacionadas a un conocimiento --->
		<cfquery datasource="#session.dsn#" name="rsM_habilidades">
			Select C.Mcodigo, C.Mnombre, C.Msiglas, B.RHHid, A.Tipo
			from RHCompetencias A, RHHabilidadesMaterias B, RHMateria C
			where  A.id 	 	= B.RHHid
			   and B.Mcodigo 	= C.Mcodigo
			   and A.Tipo 	 	= 'H'
			   and B.RHHMestado = 1
			   and C.Mactivo 	= 1
			   and A.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			   and A.codigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#codigo#">
			   Order by C.Mnombre  
		</cfquery>
		<cfset nombreqry = "rsM_habilidades">
		<cfset Matlista= "">
		<cfoutput query="rsM_habilidades">
			<cfif Matlista eq "">
				<cfset Matlista= #Mcodigo#>
			<cfelse>
				<cfset Matlista= Matlista & "," & #Mcodigo#>
			</cfif>
		</cfoutput>
	</cfif>
	<!--- Instituciones que realizaron Oferta Academica --->
	<cfquery datasource="#session.dsn#" name="rsInstituciones">
		Select A.RHIAid, A.RHIAcodigo, A.RHIAnombre 
		from RHInstitucionesA A 
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and exists (Select 1 from RHOfertaAcademica B where A.RHIAid = B.RHIAid)
	</cfquery>
	
	<cfif not isdefined("F_RHIAid")>
		<cfoutput query="rsInstituciones" startrow="1" maxrows="1">
		<cfset F_RHIAid = #RHIAid#>
		</cfoutput>
	</cfif>
	
	<cfquery datasource="#session.dsn#" name="rsMaterias">
		Select A.Mcodigo, A.Mnombre, A.Msiglas
		from RHMateria A, RHOfertaAcademica B, RHInstitucionesA C
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and A.Mcodigo = B.Mcodigo
		  and B.RHIAid  = C.RHIAid
		  <cfif isdefined("F_Mcodigo") and F_Mcodigo neq "">
			  and upper(A.Msiglas) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(F_Mcodigo)#%">
		  </cfif>
		  <cfif isdefined("F_RHIAid") and F_RHIAid neq "">
			  and C.RHIAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#F_RHIAid#">
		  </cfif>
		  <cfif isdefined("F_Mnombre") and F_Mnombre neq "">
			  and upper(A.Mnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(F_Mnombre)#%">
		  </cfif>	  	  
		  <cfif Matlista neq "">
			and A.Mcodigo not in (#Matlista#)
		  </cfif>
	</cfquery>
</cfif>

<form name="frm_FiltroMaterias" action="RHCompetencias.cfm" method="post">
	<input type="hidden" name="F_RHIAid">
	<input type="hidden" name="F_Mcodigo">	
	<input type="hidden" name="F_Mnombre">	
	<input type="hidden" name="btnBuscar">
	<!--- Para que el com entre recargado --->
	<input type="hidden" name="codigo" value="<cfif isdefined("Form.codigo")><cfoutput>#codigo#</cfoutput></cfif>">
	<input type="hidden" name="descripcion" value="<cfif isdefined("Form.descripcion")><cfoutput>#descripcion#</cfoutput></cfif>">
	<input type="hidden" name="id" value="<cfif isdefined("Form.id")><cfoutput>#id#</cfoutput></cfif>">
	<input type="hidden" name="tipo" value="<cfif isdefined("Form.Tipo")><cfoutput>#Form.Tipo#</cfoutput></cfif>">								
</form>

<form name="frm_Materias" action="RHCompetencias.cfm" method="post">
<table summary="Tabla de entrada" cellpadding="0" cellspacing="0" width="100%">
	<tr><td colspan="4">&nbsp;</td></tr>
	<cfoutput>
	<tr>
		<td>&nbsp;</td>
		<td class="tituloListas" colspan="3" align="center"><strong>#LB_Codigo#:&nbsp;<cfif isdefined("form.codigo") and len(trim(form.codigo))>#form.codigo#</cfif></strong>
	</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td class="tituloListas" colspan="3" align="center"><strong>#LB_Descripcion#:&nbsp;<cfif isdefined("form.descripcion") and len(trim(form.descripcion))>#form.descripcion#</cfif></strong></td>
	</tr>
	</cfoutput>
	<tr><td colspan="4">&nbsp;</td></tr>
	<cfif not isdefined("codigo")>
		<tr><td colspan="4" align="center"><cfoutput>#LB_PorFavorSeleccioneLosConocimientosOHabilidadesDeLaListaParaElegirCursos#</cfoutput></td></tr>
	<cfelse>		
		<tr>
			<td colspan="4">
				<table align="center" summary="Tabla de entrada" cellpadding="0" cellspacing="0" width="90%">
				<tr><td colspan="4" class="subTitulo" align="center"><cfoutput>#LB_CursosRelacionadosActualmente#</cfoutput></td></tr>
				<tr>&nbsp;</tr>			
				<cfif evaluate(#nombreqry# & ".recordcount") gt 0>
					<cfoutput query="#nombreqry#">
					<tr>
						<td>#Msiglas#</td>
						<td>#Mnombre#</td> 
						<td>
							<cfif isdefined("RHCid")>
								<cfset rhc=#RHCid#>
							</cfif>
							<cfif isdefined("RHHid")>
								<cfset rhc=#RHHid#>
							</cfif>
							<a href="javascript: borrarCurso('#Mcodigo#','#rhc#','#Tipo#');">
							<img border="0" src="/cfmx/rh/imagenes/Borrar01_S.gif" alt="Eliminar este grupo">
							</a>						
						</td>
					</tr>
					</cfoutput>			
				<cfelse>
					<tr><td colspan="2" align="center"><cfoutput>#LB_NoHayCursosRelacionadas#</cfoutput></td></tr>
				</cfif>
				</table>
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>		
		<tr>
			<td colspan="4">
				<table align="center" border="0" summary="Tabla de entrada" cellpadding="0" cellspacing="0" width="90%" ><!---class="areaFiltro"--->
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="5">
						<table border="0" align="center" summary="Tabla de entrada" cellpadding="0" cellspacing="0" width="100%" ><!---class="areaFiltro"--->
						<tr><td colspan="4" class="subTitulo" align="center"><cfoutput>#LB_SeleccionDeCursos#</cfoutput></td></tr>						
						<!--- Filtros --->
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="right" width="15%"><strong><cfoutput>#LB_Institucion#</cfoutput>:&nbsp;</strong></td>
							<td colspan="2">
								<select name="F_RHIAid" ><!---style="width:100%"--->
								<option value="">--- Todas ---</option>
									<cfoutput query="rsInstituciones">
										<cfif F_RHIAid eq RHIAid>
											<option value="#RHIAid#" selected>#RHIAnombre#</option>
										<cfelse>
											<option value="#RHIAid#">#RHIAnombre#</option>
										</cfif>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td align="right"><strong><cfoutput>#LB_Codigo#</cfoutput>:&nbsp;</strong></td>
							<td colspan="2"><input type="text" name="F_Mcodigo" size="15" maxlength="15" value="<cfif isdefined("F_Mcodigo")><cfoutput>#F_Mcodigo#</cfoutput></cfif>"></td>					
						</tr>
						<tr>
							<td align="right"><strong><cfoutput>#LB_Descripcion#</cfoutput>:&nbsp;</strong></td>
							<td width="65%"><input type="text" name="F_Mnombre" size="50"  maxlength="50" value="<cfif isdefined("F_Mnombre")><cfoutput>#F_Mnombre#</cfoutput></cfif>"></td>					
							<td width="20%" align="right"><input name="btnFiltrar" type="button" id="btnFiltrar" value="<cfoutput>#BTN_Buscar#</cfoutput>"  onClick="javascript:FiltrarCur(document.frm_Materias.F_RHIAid.value,document.frm_Materias.F_Mcodigo.value,document.frm_Materias.F_Mnombre.value);"></td>
						</tr>
						</table>
					</td>
				</tr>
				<cfif rsMaterias.recordcount gt 15>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="3" align="center">
						<input type="submit" name="sbm_materias" value="<cfoutput>#LB_RelacionarCursos#</cfoutput>" style="width:100px">
						<input type="reset" name="rst_materias" value="<cfoutput>#BTN_Limpiar#</cfoutput>" style="width:100px">
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				</cfif>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<cfif isdefined("form.btnBuscar")>
					<cfoutput>
					<tr class="titulolistas">
						<td align="right">&nbsp;</td>
						<td><strong>#LB_Siglas#</strong></td>
						<td><strong>#LB_Descripcion#</strong></td>
						<td><strong>#LB_Peso#</strong></td> 
					</tr>
					</cfoutput>			
					<cfif rsMaterias.recordcount gt 0>
						<cfoutput query="rsMaterias">
						<tr>
							<td align="right"><input style="border: '0'" type="checkbox" name="ckMat" value="#rsMaterias.Mcodigo#"></td><!---class="areaFiltro" ---->
							<td>#rsMaterias.Msiglas#</td>
							<td>#rsMaterias.Mnombre#</td>
							<td><input type="text" name="RHPeso" value="" size="4"></td> 
						</tr>
						</cfoutput>			
					
					<cfelse>
						<tr><td colspan="3" align="center">No hay cursos para seleccionar</td></tr>				
					</cfif>
				</cfif>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="3" align="center">
						<input type="submit" name="sbm_materias" value="Relacionar Cursos" >
						<input type="reset" name="rst_materias" value="Limpiar" style="width:100px">
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				</table>		
			</td>
		</tr>	
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center" colspan="4">
				<cfif nombreqry eq "rsM_conocimientos">
					<cfset codigocomp = evaluate(#nombreqry# & ".RHCid")> 
				<cfelse>
					<cfset codigocomp = evaluate(#nombreqry# & ".RHHid")> 
				</cfif>

				<!--- Para que el com entre recargado --->
				<input type="hidden" name="codigo" value="<cfif isdefined("Form.codigo")><cfoutput>#codigo#</cfoutput></cfif>">
				<input type="hidden" name="descripcion" value="<cfif isdefined("Form.descripcion")><cfoutput>#descripcion#</cfoutput></cfif>">
				<input type="hidden" name="id" value="<cfif isdefined("Form.id")><cfoutput>#id#</cfoutput></cfif>">
				<input type="hidden" name="tipo" value="<cfif isdefined("Form.Tipo")><cfoutput>#Form.Tipo#</cfoutput></cfif>">				
				
				<input type="hidden" name="RHfalta" value="<cfoutput>#dateformat(Now(),'yyyymmdd')#</cfoutput>">
				<input type="hidden" name="RHcodigo" value="<cfif isdefined("Form.id")><cfoutput>#id#</cfoutput></cfif>">				
				<!---
				<input type="submit" name="sbm_materias" value="Relacionar Cursos" style="width:120px">
				<input type="reset" name="rst_materias" value="Limpiar" style="width:120px">
				--->
			</td>
		</tr>
	</cfif>
</table>
</form>

<form action="RHCompetencias.cfm" method="post" name="form1">
	<!--- Para que el com entre recargado --->
	<input type="hidden" name="codigo" value="<cfif isdefined("Form.codigo")><cfoutput>#codigo#</cfoutput></cfif>">
	<input type="hidden" name="descripcion" value="<cfif isdefined("Form.descripcion")><cfoutput>#descripcion#</cfoutput></cfif>">
	<input type="hidden" name="id" value="<cfif isdefined("Form.id")><cfoutput>#id#</cfoutput></cfif>">
	<input type="hidden" name="tipo" value="<cfif isdefined("Form.Tipo")><cfoutput>#Form.Tipo#</cfoutput></cfif>">								

	<input name="B_Mcodigo" type="hidden">
	<input name="B_RHcodigo" type="hidden">
  	<input name="B_Tipo" type="hidden">
	<input name="bandBorrar" type="hidden">
</form>

<script>
	function FiltrarCur(f_rh,f_mc,f_mn)
	{
		document.frm_FiltroMaterias.F_RHIAid.value  = f_rh;
		document.frm_FiltroMaterias.F_Mcodigo.value = f_mc;
		document.frm_FiltroMaterias.F_Mnombre.value = f_mn;
		document.frm_FiltroMaterias.submit();
	}
	function borrarCurso(cod,rhc,tip){
		if ( confirm('¿Desea eliminar el registro?') ) {
			document.form1.B_Mcodigo.value  = cod;
			document.form1.B_RHcodigo.value = rhc;
			document.form1.B_Tipo.value     = tip;
			document.form1.bandBorrar.value = 1;
			document.form1.submit();
		}		
	}
</script>