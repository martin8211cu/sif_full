<!---============== TRADUCCION ============--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Usuario"
	Default="Usuario"
	returnvariable="LB_Usuario"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>
	
<cfquery name="rsGrupo" datasource="#session.DSN#">
	select {fn concat(ltrim(rtrim(a.Gcodigo)),{fn concat(' ',a.Gdescripcion)})} as Grupo
	from  RHCMGrupos  a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gid#">
</cfquery>

<cfset navegacion = ''>
<cfif isdefined("url.Usuario") and len(trim(url.Usuario)) and not isdefined("form.Usuario")>
	<cfset form.Usuario = url.Usuario>	
</cfif>
<cfif isdefined("url.Identificacion") and len(trim(url.Identificacion)) and not isdefined("form.Identificacion")>
	<cfset form.Identificacion = url.Identificacion>	
</cfif>
<cfif isdefined("form.Usuario") and len(trim(form.Usuario))>
	<cfset navegacion = Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Usuario=" & Form.Usuario>
</cfif>
<cfif isdefined("form.Identificacion") and len(trim(form.Identificacion))>
	<cfset navegacion = navegacion & "&Identificacion=#form.Identificacion#">
</cfif>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<form name="formAutorizadores" method="post" action="Supervisores-Autorizadores-sql.cfm">
		<input type="hidden" name="Gid" value="<cfif isdefined("form.Gid") and len(trim(form.Gid))>#form.Gid#</cfif>">
		<input type="hidden" name="AGid" value=""><!---Campo oculto para guardar la llave del registro que se eliminara---->
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td width="7%" align="right"><strong><cf_translate key="LB_Grupo">Grupo</cf_translate>:&nbsp;</strong></td>
			<td width="93%"><strong>#rsGrupo.Grupo#</strong></td>
		</tr>		
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="16%" align="right"><strong>#LB_Usuario#:&nbsp;</strong></td>
						<td width="66%">
							 <cf_sifusuario roles="" form="formAutorizadores" size="60" tabindex="1">
						</td>
						<td width="18%">
							<input type="submit" name="btnAgregar" value="#BTN_Agregar#" tabindex="1"
								onClick="javascript: funcAgregar();">
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
						<td width="23%"><strong>#LB_Usuario#&nbsp;</strong></td>
						<td width="57%"><strong>#LB_Identificacion#&nbsp;</strong></td>						
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td width="23%"><input type="text" name="Identificacion" tabindex="1" value="<cfif isdefined("form.Identificacion") and len(trim(form.Identificacion))>#form.Identificacion#</cfif>" size="20"></td>
						<td width="57%"><input type="text" name="Usuario" tabindex="1" value="<cfif isdefined("form.Usuario") and len(trim(form.Usuario))>#form.Usuario#</cfif>" size="80"></td>						
						<td width="18%" rowspan="2" valign="bottom"><input type="button" tabindex="1" name="btnFiltrar" value="#BTN_Filtrar#" onClick="javascript: funcFiltrar();"></td>
					</tr>
				</table>
			</td>
		</tr>	
		<tr> 
			<td  colspan="2"> 						
				<cfquery name="rsLista" datasource="#session.DSN#">
					select 	a.AGid, b.Usulogin as Identificacion,
							{fn concat(c.Pnombre,{fn concat(' ',{fn concat(c.Papellido1,{fn concat(' ',c.Papellido2 )})})})} as Usuario,
							{fn concat({fn concat({fn concat('<img border=''0'' style=''cursor:hand;'' src=''/cfmx/rh/imagenes/Borrar01_S.gif'' onClick="javascript: funcEliminar(', '''')}, <cf_dbfunction name="to_char" args="a.AGid"> )}, ''');">') }  as borrar
					from RHCMAutorizadoresGrupo a
						inner join Usuario b
							on a.Usucodigo = b.Usucodigo			
							<cfif isdefined("form.Identificacion") and len(trim(form.Identificacion))>
								and upper(b.Usulogin) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Identificacion)#%">
							</cfif>			
							inner join DatosPersonales c
								on b.datos_personales = c.datos_personales
								<cfif isdefined("form.Usuario") and len(trim(form.Usuario))>
									and upper({fn concat(c.Pnombre,{fn concat(' ',{fn concat(c.Papellido1,{fn concat(' ',c.Papellido2 )})})})}) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Usuario)#%">
								</cfif>								
					where a.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gid#">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					order by c.Pnombre,c.Papellido1,c.Papellido2
				</cfquery>
				<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaQuery"
				  returnvariable="pListaEmpl">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="Identificacion, Usuario, borrar"/>
					<cfinvokeargument name="etiquetas" value="&nbsp;,&nbsp;"/>
					<cfinvokeargument name="formatos" value="V,V,V"/>
					<cfinvokeargument name="align" value="left,left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="irA" value="Supervisores-tabs.cfm?tab=3"/>
					<cfinvokeargument name="keys" value="AGid"/>
					<cfinvokeargument name="maxRows" value="10"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="incluyeForm" value="false"/>
					<cfinvokeargument name="formName" value="formAutorizadores"/>				
				</cfinvoke>	
			</td>		
		</tr>	
	</form>	
</table>
</cfoutput>

<cf_qforms form="formAutorizadores">
<script type="text/javascript" language="javascript1.2">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	//Carga la llave del registro a eliminar
	function funcEliminar(prn_AGid){
		document.formAutorizadores.AGid.value = prn_AGid;
		document.formAutorizadores.submit();
	}
	//Validar el empleado, que es requerido para agregar	
	function funcAgregar(){
		objForm.Usucodigo.required = true;
		objForm.Usucodigo.description="<cfoutput>#LB_Usuario#</cfoutput>";
	}

	function funcFiltrar(){
		document.formAutorizadores.action = '';
		document.formAutorizadores.submit();
	}
	
</script>


