<cfoutput>

	<table width="100%" cellpadding="2" cellspacing="0" style="border: 1px solid ##e5e5e5;">
		<form name="form2" action="registro_evaluacion_grupos_cf-sql.cfm" method="post" style="margin:0;">
			<input type="hidden" name="REid" value="#form.REid#">
			<input type="hidden" name="GREid" value="#form.GREid#">
			<input type="hidden" name="calificado" value="0">
			<input type="hidden" name="Estado" value="#form.Estado#">
			<tr><td colspan="2" bgcolor="##e5e5e5"><strong>Centros Funcionales asociados al grupo</strong></td></tr>
			<tr>
				<td><strong>Centro Funcional:</strong>&nbsp;</td>
				<td><cf_rhcfuncional id="CFpk" size="25" form="form2" tabindex="10"></td>
			</tr>
	
			<tr>
				<td></td>
				<td>
					<table width="100%" cellpadding="2" cellspacing="0">
						<tr>
							<td width="1%"><input type="checkbox" name="dependencias" id="dependencias" tabindex="20"></td>
							<td><label for="dependencias">Incluir dependencias</label></td>
						</tr>
					</table>
				</td>
			</tr>			
			<tr><td colspan="2" align="center">
				<!--- <cfif isdefined("form.Estado") and form.Estado EQ 1>
					&nbsp;
				<cfelse> --->
					<input type="submit" name="ALTACF" class="btnGuardar" value="Agregar" onclick="javascript: if (window.funcAltaCF) return funcAltaCF();" tabindex="30">
				<!--- </cfif> --->
			</td></tr>
		</form>	

		<tr>
			<td colspan="2">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td class="tituloListas">Listado de Centros Funcionales asociados</td></tr>
					<tr><td>

						<cf_dbfunction name="to_char" args="a.CFid" returnvariable="vCFid">
						<cfset navegacion = '&REid=#form.REid#&GREid=#form.GREid#&sel=4' >
						<cfinvoke 	component="rh.Componentes.pListas"
									method="pListaRH"
									returnvariable="pListaRHRet">
							<cfinvokeargument name="tabla" value="RHCFGruposRegistroE a
																	inner join CFuncional cf
																	   on cf.CFid = a.CFid
																	  and cf.Ecodigo = a.Ecodigo "/>
							<cfinvokeargument name="columnas" value	="a.CFid as CFpk,cf.CFcodigo,cf.CFdescripcion,4 as sel,
									case when 
									(select distinct 1
									   from RHRegistroEvaluadoresE ree
									   	inner join RHEmpleadoRegistroE ere 
											on ere.REid = ree.REid 
											and ere.DEid = ree.DEid 
										inner join LineaTiempo lt 
											on lt.Ecodigo = ree.Ecodigo 
											and lt.DEid = ree.DEid 
											and getDate() between lt.LTdesde and lt.LThasta 
										inner join RHPlazas p 
										   on p.RHPid = lt.RHPid 
										  and p.CFid = a.CFid
										where ree.REid = #form.REid#
										  and REEfinale = 1 
 
									 ) = 1 then
									 	'1'
								   when 
									(select distinct 1
									   from RHRegistroEvaluadoresE ree
									   	inner join RHEmpleadoRegistroE ere 
											on ere.REid = ree.REid 
											and ere.DEid = ree.DEid 
										inner join LineaTiempo lt 
											on lt.Ecodigo = ree.Ecodigo 
											and lt.DEid = ree.DEid 
											and getDate() between lt.LTdesde and lt.LThasta 
										inner join RHPlazas p 
										   on p.RHPid = lt.RHPid 
										  and p.CFid = a.CFid
										where ree.REid = #form.REid#
										  and REEfinalj = 1 
									 ) = 1 then
									 	'2'
									else
										'3'
									end as borrar"/>
							
							<!--- <cfinvokeargument name="columnas" value	="a.CFid as CFpk,cf.CFcodigo,cf.CFdescripcion,4 as sel,
									case when 
									(select distinct 1
									   from RHRegistroEvaluadoresE ree
									   	inner join RHEmpleadoRegistroE ere 
											on ere.REid = ree.REid 
											and ere.DEid = ree.DEid 
										inner join LineaTiempo lt 
											on lt.Ecodigo = ree.Ecodigo 
											and lt.DEid = ree.DEid 
											and getDate() between lt.LTdesde and lt.LThasta 
										inner join RHPlazas p 
										   on p.RHPid = lt.RHPid 
										  and p.CFid = a.CFid
										where ree.REid = #form.REid#
										  and REEfinale = 1 
 
									 ) = 1 then
									 	{fn concat('<img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' onclick=''javascript: eliminar(1,""',{fn concat(#vCFid#,'"");'' />')})}
								   when 
									(select distinct 1
									   from RHRegistroEvaluadoresE ree
									   	inner join RHEmpleadoRegistroE ere 
											on ere.REid = ree.REid 
											and ere.DEid = ree.DEid 
										inner join LineaTiempo lt 
											on lt.Ecodigo = ree.Ecodigo 
											and lt.DEid = ree.DEid 
											and getDate() between lt.LTdesde and lt.LThasta 
										inner join RHPlazas p 
										   on p.RHPid = lt.RHPid 
										  and p.CFid = a.CFid
										where ree.REid = #form.REid#
										  and REEfinalj = 1 
									 ) = 1 then
									 	{fn concat('<img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' onclick=''javascript: eliminar(1,""',{fn concat(#vCFid#,'"");'' />' )})}
									else
										{fn concat('<img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' onclick=''javascript: eliminar(0,""',{fn concat(#vCFid#,'"");'' />')})}
									end as borrar"/>									
									 --->
									
							<cfinvokeargument name="desplegar" value="CFcodigo, CFdescripcion, borrar"/>
							<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n,&nbsp;"/>
							<cfinvokeargument name="formatos" value="S,S,S"/>
							<cfinvokeargument name="filtro" value="	a.Ecodigo=#session.Ecodigo#
																	and a.GREid=#form.GREid#
																	order by cf.CFcodigo "/>
							<cfinvokeargument name="align" value="left,left,center"/>
							<cfinvokeargument name="ajustar" value="N,N,N"/>
							<cfinvokeargument name="irA" value="registro_evaluacion.cfm"/>
							<cfinvokeargument name="keys" value="CFpk">
							<cfinvokeargument name="formName" value="listaGruposCf">
							<cfinvokeargument name="showEmptyListMsg" value="true">
							<cfinvokeargument name="EmptyListMsg" value="No se encontraron registros">
							<cfinvokeargument name="showlink" value="false">
							<cfinvokeargument name="navegacion" value="#navegacion#">
							<cfinvokeargument name="maxrows" value="15">
							<cfinvokeargument name="Pageindex" value="2">
						</cfinvoke>
					</td></tr>	
				</table>
			</td>
		</tr>

	</table>

</cfoutput>

<cf_qforms form="form2" objForm="objForm2">

<form name="form3" method="post" action="registro_evaluacion_grupos_cf-sql.cfm">
	<cfoutput>
		<input type="hidden" name="btnEliminar" value="Eliminar" />
		<input type="hidden" name="REid" value="#form.REid#" />	
		<input type="hidden" name="GREid" value="#form.GREid#" />	
		<input type="hidden" name="CFpk" value="" />	
		<input type="hidden" name="Estado" value="#form.Estado#">
	</cfoutput>
</form>

<script type="text/javascript">
	objForm2.CFpk.required = true;
	objForm2.CFpk.description = 'Centro Funcional';
	
/*	function funcBaja(){
		objForm2.CFpk.required = false;
	}*/
	
	function eliminar(calif,CFid){
		var mensaje = "";
		if (calif == 1){
			mensaje = "El Centro Funcional tiene empleados calificados desea eliminarlo?";
		}else{
			mensaje = "Desea elmiminar al Centro Funcional?";
		}
		if ( confirm(mensaje)){
			document.form3.CFpk.value = CFid;
			document.form3.submit();
		}
	}
	
	
</script>