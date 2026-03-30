<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AutomatriculaDeCursos"
	Default="Automatrícula de Cursos"
	returnvariable="LB_AutomatriculaDeCursos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Curso"
	Default="Curso"
	returnvariable="LB_Curso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Inicia"
	Default="Inicia"
	returnvariable="LB_Inicia"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Termina"
	Default="Termina"
	returnvariable="LB_Termina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Eliminar"
	Default="Eliminar"
	returnvariable="LB_Eliminar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estado"
	Default="Estado"
	returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CupoDisponible"
	Default="Cupo Disponible"
	returnvariable="LB_CupoDisponible"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NOSEHANREGISTRADOCURSOS"
	Default="NO SE HAN REGISTRADO CURSOS"
	returnvariable="MSG_NOSEHANREGISTRADOCURSOS"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaInscribirseEnEsteCurso"
	Default="Desea inscribirse en este curso"
	returnvariable="MSG_DeseaInscribirseEnEsteCurso"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaDesinscribirEsteCurso"
	Default="Desea desinscribir este curso"
	returnvariable="MSG_DeseaDesinscribirEsteCurso"/>

<!--- FIN VARIABLES DE TRADUCCION --->
﻿<cfset request.autogestion=1>
	<cfinvoke component="home.Componentes.Seguridad" returnvariable="datosemp"
		method="getUsuarioByCod" tabla="DatosEmpleado" 
		Usucodigo="#session.Usucodigo#" Ecodigo="#session.EcodigoSDC#"
		/>
	<cfset DEid = datosemp.llave>
	<cfif Len(Trim(DEid)) EQ 0>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_LaAutomatriculaEsExclusivaParaLosEmpleadosDeLaEmpresa"
			Default="La automatrícula es exclusiva para los empleados de la empresa"
			returnvariable="MSG_LaAutomatriculaEsExclusivaParaLosEmpleadosDeLaEmpresa"/>
		<cf_throw message="#MSG_LaAutomatriculaEsExclusivaParaLosEmpleadosDeLaEmpresa#" errorcode="10065">
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

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2117" default="0" returnvariable="UsaFiltro"/>
<cfif UsaFiltro eq 1>
	<cfquery name="rsDEid" datasource="#session.dsn#">
		select llave from UsuarioReferencia 
		where Usucodigo=#session.Usucodigo#
		and STabla='DatosEmpleado'
	</cfquery>
</cfif>

<cfquery datasource="#session.dsn#" name="cursos">
	select c.RHCid, c.Mcodigo, m.Mnombre, i.RHIAnombre,
		c.RHCfdesde,
		c.RHCfhasta,
		c.RHCcupo, c.RHCid,
		c.RHCcupo - (select count(1) from RHEmpleadoCurso ec
			where ec.RHCid = c.RHCid) as disponible
	from RHCursos c
	<cfif UsaFiltro eq 1>
		inner join RHEmpleadosporCurso exc
		on exc.RHCid=c.RHCid
		and DEid=#rsDEid.llave#
	</cfif>
	join RHMateria m
		on m.Mcodigo = c.Mcodigo
	join RHInstitucionesA i
		on i.RHIAid = c.RHIAid
	where c.RHCfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	  <!--- and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> --->
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

<cfquery datasource="#session.dsn#" name="inst">
	select RHIAid, RHIAnombre
	from RHInstitucionesA
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	order by RHIAnombre
</cfquery>

<cf_dbfunction name="to_char" args="c.RHCid" returnvariable="vRHCid">
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2109" default="" returnvariable="valP"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Aprobado_Jefe" 	Default="Aprobado Jefe" 	returnvariable="LB_Aprobado_Jefe"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Rechazada_Jefe" 	Default="Rechazada Jefe" 	returnvariable="LB_Rechazada_Jefe"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Aprobado_RH" 	Default="Aprobado RH" 		returnvariable="LB_Aprobado_RH"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Rechazado_RH" 	Default="Rechazado RH" 		returnvariable="LB_Rechazado_RH"/>

<cfquery datasource="#session.dsn#" name="cursos_matriculados">
	select c.RHCid, c.Mcodigo, m.Mnombre, i.RHIAnombre,
		c.RHCfdesde,
		c.RHCfhasta,
		c.RHCcupo, c.RHCid, 
		<cfif valP gt 0>
			case 
			when ec.RHECestado=30 then '#LB_Aprobado_Jefe#'
			when ec.RHECestado=20 then '#LB_Rechazada_Jefe#'
			when ec.RHECestado=50 then '#LB_Aprobado_RH#'
			when ec.RHECestado=40 then '#LB_Rechazado_RH#'
			else 'En Proceso' end as estado,
		</cfif>
			(
				case when c.RHCautomat = 1
					and not exists 
							(select 1 from RHRelacionCap rc, RHDRelacionCap rd,RHEmpleadoCurso ec						
							where rc.RHCid = c.RHCid
							  and rc.RHRCestado = 40
							  and rc.RHRCid = rd.RHRCid
							  and rd.DEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">							  
							  and rc.RHCid  = ec.RHCid
							  and rd.DEid   = ec.DEid 
							  and ec.RHECestado in (20,30,40,50)
							 )
					and ec.RHEMestado = 0
					<cfif valP eq 1>
						and ec.RHECestado=10
					</cfif>
				then {fn concat('<img src="/cfmx/rh/imagenes/Borrar01_S.gif" width="20" height="18" onclick="Eliminar(&quot;',{fn concat(#vRHCid#,'&quot;)">')})}
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

<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_web_portlet_start border="true" titulo="#LB_AutomatriculaDeCursos#" skin="#Session.Preferences.Skin#">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		
		<table width="100%" border="0">
			<tr>
			    <td width="8%">&nbsp;</td>
			    <td width="81%"><strong style=" font-size:small"><cf_translate key="LB_CursosMatriculadosActualmente">Cursos Matriculados Actualmente</cf_translate></strong> </td>
			    <td width="11%">&nbsp;</td>
		  	</tr>
		  	<tr>
			    <td valign="top">&nbsp;</td>
			    <td valign="top">
					<form style="margin:0" action="." method="post" name="listaMat" id="listaMat" >
						<cfset navegacion="">
						<cfif valP gt 0>
						<cfinvoke 
							 component="rh.Componentes.pListas"
							 method="pListaQuery" 
							 mostrar_filtro="no" >
							<cfinvokeargument name="query" value="#cursos_matriculados#"/>
							<cfinvokeargument name="desplegar" value="Mnombre, RHCfdesde, RHCfhasta, removible,estado"/>
							<cfinvokeargument name="etiquetas" value="#LB_Curso#,#LB_Inicia#,#LB_Termina#,#LB_Eliminar#,#LB_Estado#"/>
							<cfinvokeargument name="formatos" value="S, D, D, S,S"/>
							<cfinvokeargument name="align" value="left, center, center, right,center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="funcion" value="void(0)"/>
							<cfinvokeargument name="fparams" value=""/>
							<cfinvokeargument name="checkboxes" value="N">
							<cfinvokeargument name="keys" value="RHCid">
							<cfinvokeargument name="formName" value="listaMat">
							<cfinvokeargument name="incluyeform" value="no">
							<cfinvokeargument name="cortes" value="RHIAnombre">
							<cfinvokeargument name="showEmptyListMsg" value="true">
							<cfinvokeargument name="EmptyListMsg" value="*** #MSG_NOSEHANREGISTRADOCURSOS# ***">
							<cfinvokeargument name="navegacion" value="#navegacion#">
					  </cfinvoke>¨
					  <cfelse>
					  <cfinvoke 
							 component="rh.Componentes.pListas"
							 method="pListaQuery" 
							 mostrar_filtro="no" >
							<cfinvokeargument name="query" value="#cursos_matriculados#"/>
							<cfinvokeargument name="desplegar" value="Mnombre, RHCfdesde, RHCfhasta, removible"/>
							<cfinvokeargument name="etiquetas" value="#LB_Curso#,#LB_Inicia#,#LB_Termina#,#LB_Eliminar#"/>
							<cfinvokeargument name="formatos" value="S, D, D, S"/>
							<cfinvokeargument name="align" value="left, center, center, right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="funcion" value="void(0)"/>
							<cfinvokeargument name="fparams" value=""/>
							<cfinvokeargument name="checkboxes" value="N">
							<cfinvokeargument name="keys" value="RHCid">
							<cfinvokeargument name="formName" value="listaMat">
							<cfinvokeargument name="incluyeform" value="no">
							<cfinvokeargument name="cortes" value="RHIAnombre">
							<cfinvokeargument name="showEmptyListMsg" value="true">
							<cfinvokeargument name="EmptyListMsg" value="*** #MSG_NOSEHANREGISTRADOCURSOS# ***">
							<cfinvokeargument name="navegacion" value="#navegacion#">
					  </cfinvoke>
					  </cfif>
		  			</form>
				</td>
		    	<td valign="top">&nbsp;</td>
		  	</tr>
		  	<tr>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td valign="top">&nbsp;</td>
		  	</tr>
		  	<tr>
			    <td width="8%">&nbsp;</td>
			    <td width="81%"><strong style=" font-size:small"><cf_translate key="CursosAdicionalesDisponiblesParaAutomatricula">Cursos Adicionales disponibles para automatr&iacute;cula</cf_translate></strong> </td>
			    <td valign="top">&nbsp;</td>
		  	</tr>
		  	<tr>
		    	<td align="left">&nbsp;</td>
		    	<td align="left">      
			    	<form style="margin:0" action="." method="post" name="listaCursos" id="listaCursos" >
		      			<cf_translate key="MostrarCursosDisponiblesEn">Mostrar cursos disponibles en</cf_translate> 
						<select name="RHIAid"  onChange="this.form.submit()">
						    <option value="">-<cf_translate key="CualquierInstitucion">Cualquier Instituci&oacute;n</cf_translate>-</option>
						    <cfoutput query="inst">
						      <option value="#HTMLEditFormat(inst.RHIAid)#" <cfif inst.RHIAid eq form.RHIAid>selected</cfif>>#HTMLEditFormat(inst.RHIAnombre)#</option>
						    </cfoutput>
						</select> 
				        <cfset navegacion="">

						 <cfinvoke 
							 component="rh.Componentes.pListas"
							 method="pListaQuery" 
							 mostrar_filtro="yes" >
					        <cfinvokeargument name="query" value="#cursos#"/>
					        <cfinvokeargument name="desplegar" value="Mnombre, RHCfdesde, RHCfhasta, disponible"/>
					        <cfinvokeargument name="etiquetas" value="#LB_Curso#,#LB_Inicia#,#LB_Termina#,#LB_CupoDisponible#"/>
					        <cfinvokeargument name="formatos" value="S, D, D, I"/>
					        <cfinvokeargument name="align" value="left, center, center, right"/>
					        <cfinvokeargument name="ajustar" value="N"/>
					        <cfinvokeargument name="funcion" value="seleccionar_curso"/>
					        <cfinvokeargument name="fparams" value="RHCid,Mnombre"/>
					        <cfinvokeargument name="checkboxes" value="N">
					        <cfinvokeargument name="keys" value="RHCid">
					        <cfinvokeargument name="formName" value="listaCursos">
					        <cfinvokeargument name="incluyeform" value="no">
					        <cfinvokeargument name="cortes" value="RHIAnombre">
					        <cfinvokeargument name="showEmptyListMsg" value="true">
					        <cfinvokeargument name="EmptyListMsg" value="*** #MSG_NOSEHANREGISTRADOCURSOS# ***">
					        <cfinvokeargument name="navegacion" value="#navegacion#">
				        </cfinvoke>
				
		           	</form>
				</td>
		    	<td valign="top">&nbsp;</td>
		  	</tr>
		</table>
		
		
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
		//-->
		</script>
		
		<form name="formadd" action="automatricular_sql.cfm" method="post">
			<input type="hidden" name="RHCid" value="">
			<input type="hidden" name="op" value="">
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>