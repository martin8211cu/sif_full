<cfsilent>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_RecursosHumanos"
	default="Recursos Humanos"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_AutomatriculaDeCursos"
	default="Automatrícula de Cursos"
	returnvariable="LB_AutomatriculaDeCursos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Curso"
	default="Curso"
	returnvariable="LB_Curso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Inicia"
	default="Inicia"
	returnvariable="LB_Inicia"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Termina"
	default="Termina"
	returnvariable="LB_Termina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Eliminar"
	default="Eliminar"
	returnvariable="LB_Eliminar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_CupoDisponible"
	default="Cupo Disponible"
	returnvariable="LB_CupoDisponible"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_NOSEHANREGISTRADOCURSOS"
	default="NO SE HAN REGISTRADO CURSOS"
	returnvariable="MSG_NOSEHANREGISTRADOCURSOS"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_DeseaInscribirseEnEsteCurso"
	default="Desea inscribirse en este curso"
	returnvariable="MSG_DeseaInscribirseEnEsteCurso"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_DeseaDesinscribirEsteCurso"
	default="Desea desinscribir este curso"
	returnvariable="MSG_DeseaDesinscribirEsteCurso"/>

<!--- FIN VARIABLES DE TRADUCCION --->
?<cfset request.autogestion=1>
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

<cfquery datasource="#session.dsn#" name="cursos">
	select c.RHIAid, c.RHCid, c.Mcodigo, m.Mnombre, i.RHIAnombre,
		c.RHCfdesde,
		c.RHCfhasta,
		c.RHCcupo, c.RHCid,
		c.RHCcupo - (select count(1) from RHEmpleadoCurso ec
			where ec.RHCid = c.RHCid) as disponible
	from RHCursos c
	join RHMateria m
		on m.Mcodigo = c.Mcodigo
	join RHInstitucionesA i
		on i.RHIAid = c.RHIAid
	where c.RHCfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	  and m.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and c.RHCautomat = 1
	  and not exists (select 1
	  	from RHEmpleadoCurso ec
		where ec.RHCid = c.RHCid
		  and ec.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> )
	  and (c.RHCcupo - (select count(1) from RHEmpleadoCurso ec
			where ec.RHCid = c.RHCid) ) > 0 <!--- cupo_disponible --->
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
				then {fn concat('<img src="/cfmx/rh/imagenes/Borrar01_S.gif" width="20" height="18" onClick="Eliminar(&quot;',{fn concat(#vRHCid#,'&quot;)">')})}
				else '' end
			) as removible
	from RHCursos c
	join RHMateria m
		on m.Mcodigo = c.Mcodigo
	join RHInstitucionesA i
		on i.RHIAid = c.RHIAid
	join RHEmpleadoCurso ec
		on ec.RHCid = c.RHCid
		  and ec.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> 
	where c.RHCfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	  and ec.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by i.RHIAnombre, m.Mnombre, c.RHCfdesde
</cfquery>
</cfsilent><body  bgcolor="#e6eef5">
<style type="text/css">
	.RLTtopline {
		border-bottom-width: none;
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
	
	.LTtopline {
		border-bottom-width: none;
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	.LRTtopline {
		border-bottom-width: none;
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
	
	.RTtopline {
		border-bottom-width: none;
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	.Completoline {
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
	.topline {
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000;
			border-right-style: none;
			border-bottom-style: none;
			border-left-style: none;
		}
	.bottonline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-right-style: none;
			border-top-style: none;
			border-left-style: none;
		}
	.RLTbottomline {
		border-top-width: none;
		border-left-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}	
	.RLTbottomline2 {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}
	.RLline {
		border-top-width: none;
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
	}
	.LTbottomline {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}		
</style>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <cfif cursos_matriculados.recordCount GT 0>
        <cfoutput>
        <form action="." method="post" name="listaMat" id="listaMat" >
          <tr>
            <td width="2%">&nbsp;</td>
                <td width="96%"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:11px"><b><cf_translate key="LB_CursosMatriculadosActualmente">Cursos Matriculados Actualmente</cf_translate></b></font></td>
                <td width="2%">&nbsp;</td>
            </tr>  
            <cfset  Var_RHIAnombre = "">            
          <tr>
            <td valign="top">&nbsp;</td>
                <td valign="top">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td class="LTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px"><b>#LB_Curso#</b></font></td>
                        <td align="center" class="LTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px"><b>#LB_Inicia#</b></font></td>
                        <td align="center" class="LTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px"><b>#LB_Termina#</b></font></td>
                        <td class="RLTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px"><b>#LB_Eliminar#</b></font></td>
                      </tr>
                    <cfloop query="cursos_matriculados">
                      <cfif Var_RHIAnombre neq  cursos_matriculados.RHIAnombre>
                            <cfset  Var_RHIAnombre = #cursos_matriculados.RHIAnombre#>
                        <tr>
                          <td colspan="4"  class="RLTtopline" bgcolor="##cce4f9"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px">#Var_RHIAnombre#</font></td>
                            </tr>
                      </cfif>
                      <tr 	onMouseOver="style.backgroundColor='##b7d7f1';" 
                                onMouseOut="style.backgroundColor='##e6eef5';">
                        <td class="LTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px">#cursos_matriculados.Mnombre#</font></td>
                            <td align="center" class="LTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px">#LSDateFormat(cursos_matriculados.RHCfdesde, "dd/mm/yyyy")# </font></td>
                            <td class="LTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px">#LSDateFormat(cursos_matriculados.RHCfhasta, "dd/mm/yyyy")#</font></td>
                            <td  align="center" class="RLTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px"><cfif len(trim(cursos_matriculados.removible))>#cursos_matriculados.removible#<cfelse>&nbsp;</cfif></font></td>
                        </tr>
                    </cfloop>
                    <tr>
                      <td colspan="4"  class="topline" ><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px">&nbsp;</font></td>
                    </tr>
                  </table>
                </td>
                <td valign="top">&nbsp;</td>
          </tr>
        </form> 
        </cfoutput> 
  </cfif>
<cfif cursos.recordCount GT 0>
        <cfoutput>
        <form style="margin:0" action="pantalla.cfm" method="post" name="listaMat" id="listaMat" >

            <tr>
                <td width="2%">&nbsp;</td>
                <td width="96%"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:11px"><b><cf_translate key="CursosAdicionalesDisponiblesParaAutomatricula">Cursos Adicionales disponibles para automatr&iacute;cula</cf_translate></b></font> </td>
                <td width="2%" valign="top">&nbsp;</td>
            </tr>  
            <cfset  Var_RHIAnombre = "">            
            <tr>
                <td valign="top">&nbsp;</td>
                <td valign="top">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <cfif isdefined("listaInst") and len(trim(listaInst))>
                            <tr>
                                <td colspan="4">
                                    <font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:11px"><cf_translate key="MostrarCursosDisponiblesEn">Mostrar cursos disponibles en</cf_translate></font> 
                                    <select  name="RHIAid"  onChange="this.form.submit()" style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px" tabindex="1" >
                                        <option style="font-size:10px;" value="">-<cf_translate key="CualquierInstitucion">Cualquier Instituci&oacute;n</cf_translate>-</option>
                                        <cfloop query="inst">
                                            <option style="font-size:10px;" value="#HTMLEditFormat(inst.RHIAid)#" <cfif inst.RHIAid eq form.RHIAid>selected</cfif>>#HTMLEditFormat(inst.RHIAnombre)#</option>
                                        </cfloop> 
                                    </select>
                               </td>
                            </tr>
                        </cfif>
                      <tr>
                        <td class="LTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px"><b>#LB_Curso#</b></font></td>
                        <td  align="center" class="LTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px"><b>#LB_Inicia#</b></font></td>
                        <td  align="center" class="LTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px"><b>#LB_Termina#</b></font></td>
                        <td class="RLTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px"><b>#LB_CupoDisponible#</b></font></td>
                      </tr>
                    <cfloop query="cursos">
                        <cfif Var_RHIAnombre neq  cursos.RHIAnombre>
                            <cfset  Var_RHIAnombre = #cursos.RHIAnombre#>
                            <tr>
                                <td colspan="4"  class="RLTtopline" bgcolor="##cce4f9"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px">#Var_RHIAnombre#</font></td>
                            </tr>
                        </cfif>
                        <tr 	 style="cursor:pointer" 
                        		onClick="javascript: seleccionar_curso(#cursos.RHCid#,'#cursos.Mnombre#');"
                                onMouseOver="style.backgroundColor='##b7d7f1';" 
                                onMouseOut="style.backgroundColor='##e6eef5';"
                        >
                            <td class="LTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px">#cursos.Mnombre#</font></td>
                            <td align="center" class="LTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px">#LSDateFormat(cursos.RHCfdesde, "dd/mm/yyyy")#</font></td>
                            <td align="center" class="LTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px">#LSDateFormat(cursos.RHCfhasta, "dd/mm/yyyy")#</font></td>
                            <td class="RLTtopline"><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px">#cursos.disponible#</font></td>
                        </tr>
                    </cfloop>
                    <tr>
                        <td colspan="4"  class="topline" ><font  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px">&nbsp;</font></td>
                    </tr>
                    </table>
                </td>
                <td valign="top">&nbsp;</td>
            </tr>
        </form> 
        </cfoutput> 
    </cfif>
</table>
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
//-->
</script>


