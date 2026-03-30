<!---============== TRADUCCION ============--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_BorrarMasivo"
	Default="Borrar Masivo"
	returnvariable="BTN_BorrarMasivo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_AgregarMasivo"
	Default="Agregar Masivo"
	returnvariable="BTN_AgregarMasivo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"
	returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaBorrarTodosLosEmpleadosDeEsteGrupo"
	Default="Desea borrar todos los empleados de este grupo?"
	returnvariable="MSG_ConfirmaBorrado"/>
	
<cfquery name="rsGrupo" datasource="#session.DSN#">
	select {fn concat(ltrim(rtrim(a.Gcodigo)),{fn concat(' ',a.Gdescripcion)})} as Grupo
	from  RHCMGrupos  a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gid#">
</cfquery>

<cfset navegacion = ''>
<cfif isdefined("url.Identificacion") and len(trim(url.Identificacion)) and not isdefined("form.Identificacion")>
	<cfset form.Identificacion = url.Identificacion>	
</cfif>
<cfif isdefined("url.Empleado") and len(trim(url.Empleado)) and not isdefined("form.Empleado")>
	<cfset form.Empleado = url.Empleado>	
</cfif>
<cfif isdefined("form.Empleado") and len(trim(form.Empleado))>
	<cfset navegacion = Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Empleado=" & Form.Empleado>
</cfif>
<cfif isdefined("form.Identificacion") and len(trim(form.Identificacion))>
	<cfset navegacion = navegacion & "&Identificacion=#form.Identificacion#">
</cfif>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<form name="formEmpleados" method="post" action="Supervisores-Empleados-sql.cfm">
		<input type="hidden" name="Gid" value="<cfif isdefined("form.Gid") and len(trim(form.Gid))>#form.Gid#</cfif>">
		<input type="hidden" name="EGid" value=""><!---Campo oculto para guardar la llave del registro que se eliminara---->
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td width="7%" align="right"><strong><cf_translate key="LB_Grupo">Grupo</cf_translate>:&nbsp;</strong></td>
			<td width="93%"><strong>#rsGrupo.Grupo#</strong></td>
		</tr>
		<tr>
			<td colspan="2" align="right">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="84%" align="right">
							<input type="submit" name="btnBorrarMasivo" tabindex="1" value="#BTN_BorrarMasivo#" onClick="if ( confirm('#MSG_ConfirmaBorrado#') ){return true;} return false;">
						</td>
						<td width="16%" align="right">
							<input type="button" name="btnAgregarMasivo" tabindex="1" value="#BTN_AgregarMasivo#" onClick="javascript: funcAgregaMasivo();">
						</td>
					</tr>	
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>		
		<tr>
			<td colspan="2">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="10%" align="right"><strong>#LB_Empleado#:&nbsp;</strong></td>
						<td width="71%">
							 <cf_rhempleado tabindex="1" size = "60" form="formEmpleados">
						</td>
						<td width="19%">
							<input type="submit" name="btnAgregar" value="#BTN_Agregar#" tabindex="1" onClick="javascript: funcAgregar();">
						</td>
					</tr>
				</table>
			</td>
		</tr>	
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="2%">&nbsp;</td>
						<td width="29%"><strong>#LB_Identificacion#&nbsp;</strong></td>
						<td width="56%"><strong>#LB_Empleado#&nbsp;</strong></td>						
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td width="29%"><input type="text" name="Identificacion" tabindex="1" value="<cfif isdefined("form.Identificacion") and len(trim(form.Identificacion))>#form.Identificacion#</cfif>" size="30"></td>
						<td width="56%"><input type="text" name="Empleado" tabindex="1" value="<cfif isdefined("form.Empleado") and len(trim(form.Empleado))>#form.Empleado#</cfif>" size="80"></td>						
						<td width="13%" rowspan="2" valign="bottom"><input type="button" tabindex="1" name="btnFiltrar" value="#BTN_Filtrar#" onClick="javascript: funcFiltrar();"></td>
					</tr>
				</table>
			</td>
		</tr>	
		<tr> 
			<td  colspan="2"> 										
				<cfquery name="rsLista" datasource="#session.DSN#">
					select 	b.EGid, c.DEidentificacion,
							{fn concat(c.DEnombre,{fn concat(' ',{fn concat(c.DEapellido1,{fn concat(' ',c.DEapellido2 )})})})} as Empleado,
							{fn concat({fn concat({fn concat('<img border=''0'' style=''cursor:hand;'' src=''/cfmx/rh/imagenes/Borrar01_S.gif'' onClick="javascript: funcEliminar(', '''')}, <cf_dbfunction name="to_char" args="b.EGid"> )}, ''');">') }  as borrar
					from RHCMEmpleadosGrupo b															
						inner join DatosEmpleado c
							on b.DEid = c.DEid
							and b.Ecodigo = c.Ecodigo
							<cfif isdefined("form.Empleado") and len(trim(form.Empleado))>
								and upper({fn concat(c.DEnombre,{fn concat(' ',{fn concat(c.DEapellido1,{fn concat(' ',c.DEapellido2 )})})})}) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Empleado)#%">
							</cfif>
							<cfif isdefined("form.Identificacion") and len(trim(form.Identificacion))>
								and upper(c.DEidentificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Identificacion)#%">
							</cfif>
					where 	b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and b.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gid#">
					order by c.DEidentificacion,c.DEnombre,c.DEapellido1,c.DEapellido2
				</cfquery>
				<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaQuery"
				  returnvariable="pListaEmpl">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="DEidentificacion, Empleado, borrar"/>
					<cfinvokeargument name="etiquetas" value="&nbsp;,&nbsp;,&nbsp;"/>
					<cfinvokeargument name="formatos" value="V,V,V"/>
					<cfinvokeargument name="align" value="left,left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="irA" value="Supervisores-tabs.cfm?tab=2"/>
					<cfinvokeargument name="keys" value="EGid"/>
					<cfinvokeargument name="maxRows" value="10"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="incluyeForm" value="false"/>
					<cfinvokeargument name="formName" value="formEmpleados"/>				
				</cfinvoke>	
			</td>		
		</tr>	
	</form>	
</table>
</cfoutput>

<cf_qforms form="formEmpleados">
<script type="text/javascript" language="javascript1.2">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	//Carga la llave del registro a eliminar
	function funcEliminar(prn_EGid){
		document.formEmpleados.EGid.value = prn_EGid;
		document.formEmpleados.submit();
	}
	//Validar el empleado, que es requerido para agregar	
	function funcAgregar(){
		objForm.DEid.required = true;
		objForm.DEid.description="<cfoutput>#LB_Empleado#</cfoutput>";
	}
	//PopUp para agregar masivamente
	function funcAgregaMasivo(){
		var params ="?Gid="+document.formEmpleados.Gid.value;
		popUpWindow("/cfmx/rh/marcas/catalogos/Supervisores-PopUpEmpleadosMasivos.cfm"+params,200,180,600,300);		
	}	
	
	function funcFiltrar(){
		document.formEmpleados.action = '';
		document.formEmpleados.submit();
	}
</script>



