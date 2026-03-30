
	<cfsilent>
	<!--- VARIABLES DE TRADUCCION --->
	<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
	<cfinvoke key="LB_AutomatriculaDeCursos" default="Automatrícula de Cursos" returnvariable="LB_AutomatriculaDeCursos" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_Curso" default="Curso" returnvariable="LB_Curso" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_Inicia" default="Inicia" returnvariable="LB_Inicia" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_Termina" default="Termina" returnvariable="LB_Termina" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_Eliminar" default="Eliminar" returnvariable="LB_Eliminar" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_CupoDisponible" default="Cupo Disponible" returnvariable="LB_CupoDisponible" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_CupoActual" default="Matriculados" returnvariable="LB_CupoActual" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="MSG_NOSEHANREGISTRADOCURSOS" default="NO SE HAN REGISTRADO CURSOS"returnvariable="MSG_NOSEHANREGISTRADOCURSOS" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="MSG_DeseaInscribirseEnEsteCurso" default="Desea inscribirse en este curso" returnvariable="MSG_DeseaInscribirseEnEsteCurso" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="MSG_DeseaDesinscribirEsteCurso" default="Desea desinscribir este curso" returnvariable="MSG_DeseaDesinscribirEsteCurso" component="sif.Componentes.Translate" method="Translate"/>
	<!--- FIN VARIABLES DE TRADUCCION --->
	﻿<cfset request.autogestion=1>
		<cfinvoke component="home.Componentes.Seguridad" returnvariable="datosemp"
			method="getUsuarioByCod" tabla="DatosEmpleado" 
			usucodigo="#session.Usucodigo#" ecodigo="#session.EcodigoSDC#"
			/>
		<cfset DEid = datosemp.llave>
		<cfif Len(Trim(DEid)) EQ 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				key="MSG_LaAutomatriculaEsExclusivaParaLosEmpleadosDeLaEmpresa"
				default="La automatrícula es exclusiva para los empleados de la empresa"
				returnvariable="MSG_LaAutomatriculaEsExclusivaParaLosEmpleadosDeLaEmpresa"/>
			<cf_throw message="#MSG_LaAutomatriculaEsExclusivaParaLosEmpleadosDeLaEmpresa#." errorcode="10065">
		</cfif>
	<cfparam name="form.RHIAid" default="">
	<cfparam name="form.filtro_Mnombre" default="">
	<cfparam name="form.filtro_RHCfdesde" default="">

	<cfparam name="form.filtro_RHCfhasta" default="">
	<cfparam name="form.filtro_disponible" default="">

	<cfif LSIsDate(form.filtro_RHCfdesde)>
		<cftry>
			<cfset form.filtro_RHCfdesde = LSDateFormat(LSParseDateTime(form.filtro_RHCfdesde),'DD/MM/YYYY')>
		<cfcatch type="any"><cfset form.filtro_RHCfdesde = "">
			</cfcatch></cftry>
	<cfelse>
		<cfset form.filtro_RHCfdesde = "">
	</cfif>
	<cfif LSIsDate(form.filtro_RHCfhasta)>
		<cftry>
			<cfset form.filtro_RHCfhasta = LSDateFormat(LSParseDateTime(form.filtro_RHCfhasta),'DD/MM/YYYY')>
		<cfcatch type="any"><cfset form.filtro_RHCfhasta = "">
			</cfcatch></cftry>
	<cfelse>
		<cfset form.filtro_RHCfhasta = "">
	</cfif>
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2109" default="" returnvariable="LvarAM"/>
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2117" default="" returnvariable="UsaFiltro"/>
	<cfif UsaFiltro eq 1>
		<cfquery name="rsDEid" datasource="#session.dsn#">
			select llave from UsuarioReferencia 
			where Usucodigo=#session.Usucodigo#
			and STabla='DatosEmpleado'
		</cfquery>
	</cfif>
<cfquery datasource="#session.dsn#" name="cursos">
	select c.RHIAid, c.RHCid, c.Mcodigo, m.Mnombre, i.RHIAnombre,
			c.RHCfdesde,
			c.RHCfhasta,
			c.RHCcupo, c.RHCid,c.RHCdisponible,
		c.RHCcupo - (select count(1) from RHEmpleadoCurso ec
			where ec.RHCid = c.RHCid  <cfif LvarAM eq 1>and RHECestado not in (20)</cfif>)  as disponible
	from RHCursos c
		join RHMateria m
			on m.Mcodigo = c.Mcodigo
		join RHInstitucionesA i
			on i.RHIAid = c.RHIAid
		<cfif UsaFiltro eq 1>
		inner join RHEmpleadosporCurso exc
		on exc.RHCid=c.RHCid
		and exc.DEid=#rsDEid.llave#
		</cfif>
		where c.RHCfdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
		  and m.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and c.RHCautomat = 1
		  and not exists (select 1
							from RHEmpleadoCurso ec
							where ec.RHCid = c.RHCid
							  and ec.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> )
		  and (c.RHCcupo - (select count(1) from RHEmpleadoCurso ec
							where ec.RHCid = c.RHCid <cfif LvarAM eq 1>and RHECestado not in (20)</cfif>) ) > 0 <!--- cupo_disponible --->
		  <cfif Len(form.RHIAid)>
		  and c.RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#">
		  </cfif>
		  <cfif Len(form.filtro_Mnombre)>
		  and upper(m.Mnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(form.filtro_Mnombre)#%">
		  </cfif>
		  <cfif Len(form.filtro_RHCfdesde)>
		  and c.RHCfdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(form.filtro_RHCfdesde)#">
		  </cfif>
		  <cfif Len(form.filtro_RHCfhasta)>
		  and c.RHCfhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(form.filtro_RHCfhasta)#">
	  </cfif>
	order by i.RHIAnombre, m.Mnombre, c.RHCfdesde
	</cfquery>

	<cfquery  dbtype="query"  name="inst2">
		select distinct RHIAid from cursos 
	</cfquery>

	<cfset listaInst = "">
	<cfloop query="inst2">
	  <cfif inst2.recordCount eq inst2.currentRow>
			<cfset listaInst = listaInst & inst2.RHIAid>
		<cfelse>
			<cfset listaInst = listaInst & inst2.RHIAid & ','>
	  </cfif>	
	</cfloop>

	<cfquery datasource="#session.dsn#" name="inst">
		select RHIAid, RHIAnombre
		from RHInstitucionesA
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	    <cfif isdefined("listaInst") and len(trim(listaInst))>
			and RHIAid in (#PreserveSingleQuotes(listaInst)#)
	    </cfif>
	    order by RHIAnombre
	</cfquery>

	<cf_dbfunction name="to_char" args="c.RHCid" returnvariable="vRHCid">
	<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
	<cfset imgAction  = '<img src="/cfmx/rh/imagenes/Borrar01_S.gif" width="20" height="18" onClick="Eliminar('' #_Cat# #vRHCid# #_Cat# '')">'>
<cfquery datasource="#session.dsn#" name="cursos_matriculados">
	select c.RHCid, c.Mcodigo, m.Mnombre, i.RHIAnombre,
			c.RHCfdesde,
			c.RHCfhasta,
			c.RHCcupo, c.RHCid, 
			(
				case when c.RHCautomat = 1
					and not exists (select 1 from RHRelacionCap rc, RHDRelacionCap rd
									where rc.RHCid = c.RHCid
									  and rc.RHRCestado = 40
									  and rc.RHRCid = rd.RHRCid
									  and rd.DEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> )
					and ec.RHEMestado = 0
				then '#PreserveSingleQuotes(imgAction)#'
				else '' end
			) as removible
		from RHCursos c
		join RHMateria m
			on m.Mcodigo = c.Mcodigo
		join RHInstitucionesA i
			on i.RHIAid = c.RHIAid
		<cfif UsaFiltro eq 1>
		inner join RHEmpleadosporCurso exc
		on exc.RHCid=c.RHCid
		and exc.DEid=#rsDEid.llave#
		</cfif>
	join RHEmpleadoCurso ec
			on ec.RHCid = c.RHCid
			  and ec.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> 
			  <cfif LvarAM eq 1>
			  	and RHECestado = 60
			  </cfif>
		where c.RHCfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	  and ec.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by i.RHIAnombre, m.Mnombre, c.RHCfdesde
	</cfquery>

	<cfif LvarAM eq 1>
	<cfquery name="cursos_rechazados" datasource="#session.dsn#">
		select c.RHCid, c.Mcodigo, m.Mnombre, i.RHIAnombre,ec.DEid,
			c.RHCfdesde,
			c.RHCfhasta,
			c.RHCcupo, c.RHCid
	from RHCursos c
		join RHMateria m
			on m.Mcodigo = c.Mcodigo
		join RHInstitucionesA i
			on i.RHIAid = c.RHIAid
		join RHEmpleadoCurso ec
			on ec.RHCid = c.RHCid
			  and ec.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			  and ec.RHECestado in (20,40) 
		where c.RHCfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	  and ec.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by i.RHIAnombre, m.Mnombre, c.RHCfdesde
		</cfquery>
	</cfif>
</cfsilent><body  bgcolor="#e6eef5">
<style type="text/css">
table {
	color: -webkit-text;
	font-size: 12px;	font-style: normal;	font-variant: normal;
	font-weight: normal;
	line-height: normal;
	text-align: start;
	white-space: normal;
}
table .table-striped{
cursor:pointer;
}

table tr td,th{
     padding:0 !important;
 }
</style>
<body  bgcolor="#e6eef5">
	<cf_importlibs> 
 	<!---- pínta las cursos matriculados---->
 	<h4><cf_translate key="LB_CursosMatriculadosActualmente">Cursos Matriculados Actualmente</cf_translate></h4>  
	    <cfoutput>
		    <form action="." method="post" name="listaMat" id="listaMat" >
		    	<cfset  Var_RHIAnombre = "">            
		    	<div class="bs-example table-responsive">
					<table class="table table-striped table-bordered table-hover" border="0">
						<thead>
							<tr>
								<th>#LB_Curso#</th>
								<th align="center">#LB_Inicia#</th>
								<th align="center">#LB_Termina#</th>
								<th>#LB_Eliminar#</th>
							</tr>
						</thead>
						<tbody>
							<cfif cursos_matriculados.recordCount GT 0>
								<cfloop query="cursos_matriculados">
									<cfif Var_RHIAnombre neq  cursos_matriculados.RHIAnombre>
										<cfset  Var_RHIAnombre = #cursos_matriculados.RHIAnombre#>
										<tr>
											<td colspan="4"  bgcolor="##add5f8">#Var_RHIAnombre#</td>
										</tr>
									</cfif>
									<tr>
										<td>#cursos_matriculados.Mnombre#</td>
										<td align="center"><cf_locale name="date" value="#cursos_matriculados.RHCfdesde#"/></td>
										<td><cf_locale name="date" value="#cursos_matriculados.RHCfhasta#"/></td>
										<td  align="center"><cfif len(trim(cursos_matriculados.removible))>#cursos_matriculados.removible#<cfelse>&nbsp;</cfif></td>
									</tr>
								</cfloop>
							<cfelse>
								<tr><td colspan="6" align="center">--- <cf_translate key="LB_No_se_encontraron_registros" xmlFile="/rh/generales.xml">No se encontraron registros</cf_translate> ---</td></tr>
							</cfif>
							
						</tbody>
					</table>
				</div>	
		    </form> 
	    </cfoutput>


	<h4><cf_translate key="CursosAdicionalesDisponiblesParaAutomatricula">Cursos Adicionales disponibles para automatr&iacute;cula</cf_translate></h4>
	
		<cfoutput>
		<form style="margin:0" action="pantalla.cfm" method="post" name="listaMat" id="listaMat" >
				<cfset  Var_RHIAnombre = "">  
				<div class="bs-example table-responsive">
					<table class="table table-striped table-bordered table-hover" border="0">
						<thead>
			                <cfif isdefined("listaInst") and len(trim(listaInst))>
			                    <tr>
			                        <th colspan="4">
			                            <font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:11px"><cf_translate key="MostrarCursosDisponiblesEn">Mostrar cursos disponibles en</cf_translate></font> 
			                            <select  name="RHIAid"  onChange="this.form.submit()" style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px" tabindex="1" >
			                                <option style="font-size:10px;" value="">-<cf_translate key="CualquierInstitucion">Cualquier Instituci&oacute;n</cf_translate>-</option>
			                                <cfloop query="inst">
			                                    <option style="font-size:10px;" value="#HTMLEditFormat(inst.RHIAid)#" <cfif inst.RHIAid eq form.RHIAid>selected</cfif>>#HTMLEditFormat(inst.RHIAnombre)#</option>
			                                </cfloop> 
			                            </select>
			                       </th>
			                    </tr>
			                </cfif>
							<tr>
								<th>&nbsp;</th>
				                <th><b>#LB_Curso#</b></th>
				                <th  align="center"><b>#LB_Inicia#</b></th>
				                <th  align="center"><b>#LB_Termina#</b></th>
				                <th><b>#LB_CupoDisponible#</b></th>
								<th><b>#LB_CupoActual#</b></th> 
							</tr>
						</thead>
						<tbody>
							<cfif cursos.recordCount GT 0>
					            <cfloop query="cursos">
									<cfquery name="rsDisp" datasource="#session.dsn#">
										 select coalesce(count(1),0) as cantidad,RHCid from RHEmpleadoCurso
										 where RHCid=#cursos.RHCid#
										  <cfif LvarAM eq 1>and RHECestado not in (20)</cfif>
										 group by RHCid
									</cfquery>
									<cfif rsDisp.recordcount gt 0 and len(trim(rsDisp.cantidad)) gt 0>
										<cfset LvarMatri=#rsDisp.cantidad#>
									<cfelse>
										<cfset LvarMatri=0>
									</cfif>
					                <cfif Var_RHIAnombre neq  cursos.RHIAnombre>
					                    <cfset  Var_RHIAnombre = #cursos.RHIAnombre#>
					                    <tr>
											<td>&nbsp;</td>
					                        <td colspan="5"  bgcolor="##add5f8">#Var_RHIAnombre#</td>
					                    </tr>
					                </cfif>
					                <tr>
										<td><img src="/cfmx/rh/imagenes/findsmall.gif" border="0" onClick="javascript: funcReporte(#cursos.RHCid#)"></td>
					                    <td style="cursor:pointer" 
					                		onClick="javascript: seleccionar_curso(#cursos.RHCid#,'#cursos.Mnombre#');"
					                        onMouseOver="style.backgroundColor='##b6d4ef';" 
					                        onMouseOut="style.backgroundColor='##e5eef7';">#cursos.Mnombre#</td>
					                    <td align="center" style="cursor:pointer" 
					                		onClick="javascript: seleccionar_curso(#cursos.RHCid#,'#cursos.Mnombre#');"
					                        onMouseOver="style.backgroundColor='##b6d4ef';" 
					                        onMouseOut="style.backgroundColor='##e5eef7';"><cf_locale name="date" value="#cursos.RHCfdesde#"/></td>
					                    <td align="center" <cfif cursos.RHCdisponible gt 0>class="LTtopline"<cfelse>class="Completoline"</cfif> style="cursor:pointer" 
					                		onClick="javascript: seleccionar_curso(#cursos.RHCid#,'#cursos.Mnombre#');"
					                        onMouseOver="style.backgroundColor='##b6d4ef';" 
					                        onMouseOut="style.backgroundColor='##e5eef7';"><cf_locale name="date" value="#cursos.RHCfhasta#"/></td>
										<cfif cursos.RHCdisponible gt 0>
					                    <td class="Completoline" style="cursor:pointer" 
					                		onClick="javascript: seleccionar_curso(#cursos.RHCid#,'#cursos.Mnombre#');"
					                        onMouseOver="style.backgroundColor='##b6d4ef';" 
					                        onMouseOut="style.backgroundColor='##e5eef7';"><cfif cursos.RHCdisponible gt 0>#cursos.disponible#<cfelse>N/A</cfif></td>
										<td class="Completoline" style="cursor:pointer" 
					                		onClick="javascript: seleccionar_curso(#cursos.RHCid#,'#cursos.Mnombre#');"
					                        onMouseOver="style.backgroundColor='##b6d4ef';" 
					                        onMouseOut="style.backgroundColor='##e5eef7';"><cfif cursos.RHCdisponible gt 0>#LvarMatri#<cfelse>N/A</cfif></td>
										</cfif>
					                </tr>
					            </cfloop>
				            <cfelse>
								<tr><td colspan="6" align="center">--- <cf_translate key="LB_No_se_encontraron_registros" xmlFile="/rh/generales.xml">No se encontraron registros</cf_translate> ---</td></tr>
							</cfif>
						</tbody>
					</table>
				</div>	
		</form> 
		</cfoutput> 
	<!---Cursos Rechazados--->
	<h4><cf_translate key="LB_CursosRechazados">Cursos Rechazados</cf_translate></h4>
	<cfif LvarAM eq 1>
	        <cfoutput>
		        <form action="." method="post" name="listaMat" id="listaMat" >
		            <cfset  Var_RHIAnombre = "">    
		            <div class="bs-example table-responsive">
						<table class="table table-striped table-bordered table-hover" border="0">
							<thead>
								<tr>
									<th><b>#LB_Curso#</b></th>
									<th align="center"><b>#LB_Inicia#</b></th>
									<th align="center"><b>#LB_Termina#</b></th>
								</tr>
							</thead>
							<tbody>
								<cfif cursos_rechazados.recordCount GT 0>
									<cfloop query="cursos_rechazados">
				                      <tr 	onMouseOver="style.backgroundColor='##b6d4ef';" 
				                            onMouseOut="style.backgroundColor='##e5eef7';"
											onClick="javascript: mostrar_rechazo(#cursos_rechazados.RHCid#,'#cursos_rechazados.DEid#');">
				                        <td>#cursos_rechazados.Mnombre#</td>
				                            <td><cf_locale name="date" value="#cursos_rechazados.RHCfdesde#"/> </td>
				                            <td><cf_locale name="date" value="#cursos_rechazados.RHCfhasta#"/></td>
				                        </tr>
									</cfloop>
							  	<cfelse>
							  		<tr><td colspan="3" align="center">--- <cf_translate key="LB_No_se_encontraron_registros" xmlFile="/rh/generales.xml">No se encontraron registros</cf_translate> ---</td></tr>
							  	</cfif>
							</tbody>
						</table>
					</div>	
		        </form> 
	        </cfoutput> 
	</cfif>
 

<form  style="display:none" name="formadd" action="automatricular_sql.cfm" method="post">
	<input type="hidden" name="RHCid" value="">
	<input type="hidden" name="op" value="">
    <input type="hidden" name="AUT" value="">
</form>
<script type="text/javascript" defer>
	<!--
	function seleccionar_curso(RHCid,Mnombre){
		if (confirm('¿<cfoutput>#MSG_DeseaInscribirseEnEsteCurso#</cfoutput>: ' + Mnombre + '?')){
			document.formadd.RHCid.value = RHCid;
			document.formadd.op.value = 'add';
			document.formadd.submit();
		}
	}
	function Eliminar(RHCid){
		if (confirm('¿<cfoutput>#MSG_DeseaDesinscribirEsteCurso#</cfoutput>?')){
			document.formadd.RHCid.value = RHCid;
			document.formadd.op.value = 'del';
			document.formadd.submit();
		}
	}
	
	 var popUpWinCursos = 0;
	 function popUpWindowCursos(URLStr, left, top, width, height){
	  if(popUpWinCursos){
	   if(!popUpWinCursos.closed) popUpWinCursos.close();
	  }
	  popUpWinCursos = open(URLStr, 'popUpWinCursos', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	 }
	 
	 function funcProgramarMaterias(parDEid,parMcodigo){
		//Si la descripcion es vacia se programara una instancia de curso (RHCursos)/Si trae algo se programa un curso adicional (RHMateria)		
			popUpWindowCursos("/cfmx/rh/capacitacion/expediente/ProgramInstaciaCurso-form.cfm?DEid="+parDEid+"&Mcodigo="+parMcodigo+"&tab=7&auto=true",100,150,800,350);
		/*}
		else{
			popUpWindowCursos("curProgramados-form.cfm?DEid="+parDEid,100,150,800,350);
		}*/
	 }
	 function funcProgramarCursos(parDEid){
		var params = '';
		params = "&puesto="+document.formVariables.puesto.value+"&cf="+document.formVariables.cf.value	
		popUpWindowCursos("/cfmx/rh/capacitacion/expediente/curProgramados-form.cfm?DEid="+parDEid+"&tab=7"+params,100,150,800,350);
	 }	
	 
	function funcReporte(RHCid){	
		 var PARAM  = "/cfmx/rh/capacitacion/operacion/automatricula/infoCursos.cfm?RHCid=" + RHCid;
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=500,height=280')  
	} 
	
	function mostrar_rechazo(RHCid,DEid){	
		 var PARAM  = "/cfmx/rh/capacitacion/operacion/automatricula/infoCursosR.cfm?RHCid=" + RHCid+"&DEid="+DEid;
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=500,height=250')  
	} 
	//-->
</script>


