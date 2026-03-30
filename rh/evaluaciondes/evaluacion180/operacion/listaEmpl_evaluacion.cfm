<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDePuestosActivos"
	Default="Lista de Puestos Activos"
	returnvariable="LB_ListaDePuestosActivos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeCentrosFuncionales"
	Default="Lista de Centros Funcionales"
	returnvariable="LB_ListaDeCentrosFuncionales"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeEmpleados"
	Default="Lista de Empleados"
	returnvariable="LB_ListaDeEmpleados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSeEncontraronCentrosFuncionales"
	Default="No se encontraron centros funcionales"
	returnvariable="MSG_NoSeEncontraronCentrosFuncionales"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSeEncontraronEmpleados"
	Default="No se encontraron empleados"
	returnvariable="MSG_NoSeEncontraronEmpleados"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_empleados"
	Default="Lista de empleados"	
	returnvariable="LB_Lista_de_empleados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_JefeEvaluador"
	Default="Jefe Evaluador"	
	returnvariable="LB_JefeEvaluador"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"	
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NombreCompleto"
	Default="Nombre Completo"	
	returnvariable="LB_NombreCompleto"/>
		
	
<cfset ffiltro = "">
<cfset f_nuevo = false>		
<cfset navegacion = "&REid=#form.REid#&sel=5">
<cfif isdefined("form.Estado") and form.Estado EQ 1>
	<cfset navegacion = navegacion & '&Estado=#form.Estado#' >
<cfelse>
	<cfset navegacion = navegacion & '&Estado=0' >
</cfif>
<cfif isdefined('url.DEid') and not isdefined('form.DEid')>
	<cfset form.DEid = url.DEid>
</cfif>


<form action="registro_evaluacion.cfm" method="post" name="lista">
	<cfoutput>
		<input type="hidden" name="SEL" value="5">
		<input type="hidden" name="BOTON" value="">
		<input type="hidden" name="REID" value="#form.REID#">
		<input type="hidden" name="Estado" value="<cfif isdefined("form.Estado") and form.Estado EQ 1>#form.Estado#<cfelse>0</cfif>">

		<cfif isdefined("form.FRHPcodigo") and len(trim(form.FRHPcodigo))>
			<cfset ffiltro = ffiltro & " and rtrim(rhpu.RHPcodigo) = '" & trim(form.FRHPcodigo) & "'">
			<cfset navegacion = navegacion & "&RHPcodigo=#trim(form.FRHPcodigo)#">
		</cfif>
		<cfif isdefined("form.FCFcodigo") and len(trim(form.FCFcodigo))>
			<cfset ffiltro = ffiltro & " and cf.CFid = " & form.FCFid>
			<cfset navegacion = navegacion & "&FCFid=#form.FCFid#">
		</cfif>	
		
	</cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<cfoutput>
		<tr><td>&nbsp;</td><td colspan="2">&nbsp;</td></tr>
		<tr>
			
			<td align="right"><strong><cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;</strong></td>
			<td colspan="2">
				<cfif isdefined('form.DEid') and form.DEid GT 0>
					<cfquery name="rsEmpleado" datasource="#session.DSN#">
						select de.DEid, DEidentificacion,
							{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombreEmpl,
							EREjefeEvaluador
						from DatosEmpleado de 
						inner join RHEmpleadoRegistroE ere
							on ere.DEid = de.DEid
							and ere.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
						where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and de.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
					</cfquery>
					<input type="hidden" name="LDEid" value="<cfif isdefined('rsEmpleado')>#rsEmpleado.DEid#</cfif>">
					#rsEmpleado.DEidentificacion# - #rsEmpleado.nombreEmpl#
				<cfelse>
					<input type="hidden" name="LDEid" value="<cfif isdefined('rsEmpleado')>#rsEmpleado.DEid#</cfif>">
					<input type="text" name="LDEidentificacion" id="LDEidentificacion" value="<cfif isdefined('rsEmpleado')>#rsEmpleado.DEidentificacion#</cfif>" tabindex="1" size="10" onBlur="javascript: funcTraerEmpleado(this.value,'#form.REid#','L');"><input type="text" name="LNombre" id="LNombre" value="<cfif isdefined('rsEmpleado')>#rsEmpleado.nombreEmpl#</cfif>" tabindex="-1" size="50" disabled style="border:solid 1px ##CCCCCC; background:inherit;"><a href="javascript: doConlisEmpleados('L');" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_empleados#" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>					</td>
				</cfif>
	  	</tr>	  
	  	<tr>
		  	<td>&nbsp;</td>
			<td   nowrap="nowrap">
				<input type="checkbox" name="EREjefeEvaluador" tabindex="1" id="EREjefeEvaluador" <cfif isdefined("rsEmpleado") and rsEmpleado.EREjefeEvaluador eq 1>checked</cfif>/>
				<label for="EREjefeEvaluador"><cf_translate key="CHK_JefeEvaluador">Jefe Evaluador</cf_translate></label>
			</td>

		</tr>
	  <tr>
		<td colspan="3" align="center">
<!--- 		   <input name="Agregar" type="button" id="Agregar" value="#BTN_Agregar#" tabindex="1" onclick="javascript: funcbtnAgregar();"> --->
			<cfif isdefined('form.DEid') and form.DEid GT 0>
			<cf_botones values="Modificar,Nuevo" names="Modificar,Nuevo" tabindex="1">
			<cfelse>
			<cf_botones values="Agregar" names="Agregar" tabindex="1">
			</cfif>
		</td>
	  </tr>	 
	  </cfoutput>
	  <tr>
		<td colspan="3" align="center"><hr></td>
	  </tr>	
	  <tr class="areaFiltro">
		<td align="right"><strong><cf_translate key="LB_Puesto" XmlFile="/rh/generales.xml">Puesto</cf_translate>:</strong></td>
		<td  colspan="2">
			<cfset valuesArray = ArrayNew(1)>
			<cfif isdefined('form.FRHPcodigo') and FRHPcodigo GT 0>
				<cfquery name="rsPuestoA" datasource="#session.DSN#">
					select RHPcodigo,coalesce(RHPcodigoext,RHPcodigo) as RHPcodigoext, RHPdescpuesto
					from RHPuestos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FRHPcodigo#">
				</cfquery>
				<cfset ArrayAppend(valuesArray, rsPuestoA.RHPcodigo)>
				<cfset ArrayAppend(valuesArray, rsPuestoA.RHPcodigoext)>
				<cfset ArrayAppend(valuesArray, rsPuestoA.RHPdescpuesto)>
				
			</cfif>
			<cf_conlis title="#LB_ListaDePuestosActivos#"
				campos = "FRHPcodigo,FRHPcodigoext, FRHPdescpuesto" 
				desplegables = "N,S,S" 
				modificables = "N,S,N"
				size = "0,10,50"
				valuesArray="#valuesArray#" 
				tabla="RHEmpleadoRegistroE  a
						inner join LineaTiempo lt 
							on lt.DEid = a.DEid	
							and lt.Ecodigo = a.Ecodigo
							and getDate() between lt.LTdesde and lt.LThasta
						inner join RHPlazas p 
							on p.Ecodigo = lt.Ecodigo 
							and p.RHPid = lt.RHPid 
						inner join RHPuestos pp 
							on pp.RHPcodigo = p.RHPpuesto 
							and pp.Ecodigo = p.Ecodigo"
				columnas="distinct pp.RHPcodigo as FRHPcodigo,coalesce(pp.RHPcodigoext,pp.RHPcodigo) as FRHPcodigoext,pp.RHPdescpuesto as FRHPdescpuesto"
				filtro="lt.Ecodigo = #Session.Ecodigo# 
						and a.REid = #form.REid#"
				desplegar="FRHPcodigoext, FRHPdescpuesto"
				etiquetas="#LB_Codigo#, #LB_Descripcion#"
				formatos="S,S"
				align="left,left"
				asignar="FRHPcodigo,FRHPcodigoext, FRHPdescpuesto"
				asignarformatos="S,S"
				filtrar_por="pp.RHPcodigoext,pp.RHPdescpuesto"
				tabindex="1"
				form="lista"
				alt="ID,#LB_Codigo#, #LB_Descripcion#">
		</td>
	  </tr>	  
	  <tr class="areaFiltro">
		<td align="right"><strong><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:</strong></td>
		<td colspan="2">
				<cfset vCFuncional = arraynew(1) >

				<cfif isdefined('form.FCFcodigo') and form.FCFcodigo NEQ ''>
					<cfquery name="rsCFuncional" datasource="#session.DSN#">
						Select CFid
							, CFcodigo
							, CFdescripcion
						from CFuncional
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and CFcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.FCFcodigo#">
						order by CFdescripcion
					</cfquery>
					<cfif isdefined('rsCFuncional') and rsCFuncional.recordCount GT 0>
						<cfset vCFuncional[1] = rsCFuncional.CFid>
						<cfset vCFuncional[2] = rsCFuncional.CFcodigo>
						<cfset vCFuncional[3] = rsCFuncional.CFdescripcion>						
					</cfif>
				</cfif>	
				<cf_conlis
					campos="FCFid,FCFcodigo,FCFdescripcion"
					desplegables="N,S,S"
					modificables="N,S,N"
					size="0,10,50"
					title="#LB_ListaDeCentrosFuncionales#"					
					tabla="RHGruposRegistroE a
							inner join RHCFGruposRegistroE b
							on b.GREid = a.GREid
							inner join CFuncional cf
							   on cf.CFid = b.CFid
							  and cf.Ecodigo = a.Ecodigo"
					columnas="b.CFid as FCFid,CFcodigo as FCFcodigo,CFdescripcion as FCFdescripcion"
					filtro="a.Ecodigo = #session.Ecodigo#
							and a.REid = #form.REid#
							order by CFdescripcion"

					desplegar="FCFcodigo,FCFdescripcion"
					filtrar_por="CFcodigo|CFdescripcion"
					filtrar_por_delimiters="|"
					etiquetas="#LB_Codigo#,#LB_Descripcion#"
					formatos="S,S"
					align="left,left"
					asignar="FCFid,FCFcodigo,FCFdescripcion"
					asignarformatos="I,S,S"
					showEmptyListMsg="true"
					EmptyListMsg="-- #MSG_NoSeEncontraronCentrosFuncionales# --"
					tabindex="1"
					form="lista"
					valuesArray="#vCFuncional#"
					alt="ID,#LB_Codigo#, #LB_Descripcion#">				
		</td>
	  </tr>
	  <cfoutput>
			<cfif isdefined('form.FDEid') and form.FDEid GT 0>
				<cfquery name="rsEmpleadoF" datasource="#session.DSN#">
					select DEid, DEidentificacion, 
					{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombreEmpl
					from DatosEmpleado
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FDEid#">
				</cfquery>
			</cfif>
		<tr class="areaFiltro">
				<td align="right"><strong><cf_translate key="LB_Empleado">Empleado</cf_translate>:</strong></td>
			<td colspan="2">
				<input type="hidden" name="FDEid" value="<cfif isdefined('form.FDEid') and isdefined('rsEmpleadoF')>#rsEmpleadoF.DEid#</cfif>">
				<input type="text" name="FDEidentificacion" id="FDEidentificacion" value="<cfif isdefined('form.FDEid') and isdefined('rsEmpleadoF')>#rsEmpleadoF.DEidentificacion#</cfif>" tabindex="1" size="10" onBlur="javascript: funcTraerEmpleado(this.value,'#form.REid#','F');"><input type="text" name="FNombre" id="FNombre" value="<cfif isdefined('form.FDEid') and isdefined('rsEmpleadoF')>#rsEmpleadoF.nombreEmpl#</cfif>" tabindex="-1" size="50" disabled style="border:solid 1px ##CCCCCC; background:inherit;"><a href="javascript: doConlisEmpleados('F');" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_empleados#" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>					</td>
		</tr>
	  	<tr class="areaFiltro">
		 <td  colspan="3" align="center">
		   <input name="btnBuscar" type="submit" id="btnBuscar" value="#BTN_Filtrar#" tabindex="1">
		   <input name="btnLimpiar" type="button" id="btnLimpiar" value="#BTN_Limpiar#" tabindex="1" onclick="javascript: funcLimpiar();">
		</td>
	 </tr>
	 </cfoutput>	
	  <tr>
		<td colspan="3" align="center">
			<!--- Lista --->
			<cf_dbfunction name="to_char" args="de.DEid" returnvariable="Lvar_to_char_DEid">
			<cfquery name="rsLista" datasource="#session.dsn#">
					select cf.CFcodigo
					, cf.CFdescripcion
					, {fn concat(ltrim(rtrim(cf.CFcodigo)),{fn concat(' - ',cf.CFdescripcion)})} as CFcodigocorte
					, de.DEid
					, de.DEidentificacion
					, {fn concat(de.DEnombre,{fn concat(' ',{fn concat(de.DEapellido1,{fn concat(' ',de.DEapellido2)})})})} as nombreEmpl
					,case when 
							(select   1
							 from RHRegistroEvaluadoresE a
							 where a.DEid = ere.DEid
							   and ere.REid = a.REid
							   and REEfinale = 1 
							 ) = 1 then
							 	{fn concat('<a href="javascript: Eliminar(1,''',{fn concat(#Lvar_to_char_DEid#,''',0);"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>')})}
						   when 
							(select   1
							 from RHRegistroEvaluadoresE a
							 where a.DEid = ere.DEid
							   and ere.REid = a.REid
							   and REEfinalj = 1
							 ) = 1 then
							 	{fn concat('<a href="javascript: Eliminar(1,''',{fn concat(#Lvar_to_char_DEid#,''',0);"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>')})}
							else
								{fn concat('<a href="javascript: Eliminar(0,''',{fn concat(#Lvar_to_char_DEid#,''',0);"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>')})}
							end as imag
					,rhpu.RHPcodigo
					,case when 1 = 
						coalesce((select 1 
								  from LineaTiempo lt2 
								  where re.REhasta between lt2.LTdesde and lt2.LThasta 
								  	and lt.DEid = lt2.DEid),0) 
						then '' 
						else '<img src=''/cfmx/rh/imagenes/Web_Stop_2.gif''title=''El empleado ya ha sido cesado para la fecha hasta de la relaci&oacute;n'' border=''0''>' end as Cesado
					,case  ere.EREjefeEvaluador when 1 then
						'<img src="/cfmx/rh/imagenes/checked.gif" border="0" title="Jefe Evaluador">'
					else
						'<img src="/cfmx/rh/imagenes/unchecked.gif" border="0" title="No es Jefe Evaluador">'
					end as JefeEvaluador
					,EREjefeEvaluador
				from RHGruposRegistroE gr
					inner join RHCFGruposRegistroE gcf
						on gcf.Ecodigo=gr.Ecodigo
							and gcf.GREid=gr.GREid
				
					inner join RHPlazas rhp
						on rhp.Ecodigo=gcf.Ecodigo
							and rhp.CFid=gcf.CFid	
				
					inner join CFuncional cf
						on cf.Ecodigo=rhp.Ecodigo
							and cf.CFid=rhp.CFid
				
					inner join LineaTiempo lt
						on lt.Ecodigo=rhp.Ecodigo
							and lt.RHPid=rhp.RHPid
							and getDate() between lt.LTdesde and lt.LThasta
				
					inner join RHPuestos rhpu
						on rhpu.Ecodigo=lt.Ecodigo
							and rhpu.RHPcodigo=lt.RHPcodigo
				
					inner join DatosEmpleado de
						on de.Ecodigo=rhpu.Ecodigo
							and de.DEid=lt.DEid

					inner join RHEmpleadoRegistroE ere
						on ere.Ecodigo=de.Ecodigo
							and ere.REid=gr.REid
							and ere.DEid=de.DEid
					inner join RHRegistroEvaluacion re
						on ere.REid = re.REid
				where 	
				gr.Ecodigo=		<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and gr.REid =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				#preserveSingleQuotes(ffiltro)#
				<cfif isdefined("form.FDEidentificacion") and len(trim(form.FDEidentificacion))NEQ 0>
					and ltrim(rtrim(upper(de.DEidentificacion))) like '%#trim(ucase(form.FDEidentificacion))#%'
				</cfif>
				union 
				select
					cf.CFcodigo
					, cf.CFdescripcion
					, {fn concat(ltrim(rtrim(cf.CFcodigo)),{fn concat(' - ',cf.CFdescripcion)})} as CFcodigocorte
					, de.DEid
					, de.DEidentificacion
					, {fn concat(de.DEnombre,{fn concat(' ',{fn concat(de.DEapellido1,{fn concat(' ',de.DEapellido2)})})})} as nombreEmpl
					,case when 
							(select   1
							 from RHRegistroEvaluadoresE a
							 where a.DEid = ere.DEid
							   and ere.REid = a.REid
							   and REEfinale = 1 
							 ) = 1 then
							 	{fn concat('<a href="javascript: Eliminar(1,''',{fn concat(#Lvar_to_char_DEid#,''',0);"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>')})}
						   when 
							(select   1
							 from RHRegistroEvaluadoresE a
							 where a.DEid = ere.DEid
							   and ere.REid = a.REid
							   and REEfinalj = 1
							 ) = 1 then
							 	{fn concat('<a href="javascript: Eliminar(1,''',{fn concat(#Lvar_to_char_DEid#,''',0);"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>')})}
							else
								{fn concat('<a href="javascript: Eliminar(0,''',{fn concat(#Lvar_to_char_DEid#,''',0);"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>')})}
							end as imag
					,rhpu.RHPcodigo
					,case when 1 = 
						coalesce((select 1 
								  from LineaTiempo lt2 
								  where re.REhasta between lt2.LTdesde and lt2.LThasta 
								  	and lt.DEid = lt2.DEid),0) 
						then '' 
						else '<img src=''/cfmx/rh/imagenes/stop.gif'' title=''El empleado ya ha sido cesado para la fecha hasta de la relaci&oacute;n'' border=''0''>' end as Cesado
					,case  ere.EREjefeEvaluador when 1 then
						'<img src="/cfmx/rh/imagenes/checked.gif" border="0" title="Jefe Evaluador">'
					else
						'<img src="/cfmx/rh/imagenes/unchecked.gif" border="0" title="No es Jefe Evaluador">'
					end as JefeEvaluador
					,EREjefeEvaluador						
				from RHEmpleadoRegistroE ere
					inner join DatosEmpleado de
						on de.DEid = ere.DEid
					inner join LineaTiempo lt
						on lt.Ecodigo=de.Ecodigo
						and lt.DEid=de.DEid
						and lt.LTid = (select max(lt3.LTid) from LineaTiempo lt3 where lt3.DEid = lt.DEid and lt3.LTdesde = (select max(lt4.LTdesde) from LineaTiempo lt4 where lt4.DEid = lt3.DEid))
					inner join RHPlazas rhp
						on rhp.Ecodigo=lt.Ecodigo
						and lt.RHPid=rhp.RHPid
					inner join CFuncional cf
						on cf.Ecodigo=rhp.Ecodigo
						and cf.CFid=rhp.CFid
					inner join RHPuestos rhpu
						on rhpu.Ecodigo=lt.Ecodigo
						and rhpu.RHPcodigo=lt.RHPcodigo
					inner join RHRegistroEvaluacion re
						on ere.REid = re.REid
				where ere.Ecodigo=	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ere.REid =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				#preserveSingleQuotes(ffiltro)#
				<cfif isdefined("form.FDEidentificacion") and len(trim(form.FDEidentificacion))NEQ 0>
					and ltrim(rtrim(upper(de.DEidentificacion))) like '%#trim(ucase(form.FDEidentificacion))#%'
				</cfif>
				order by cf.CFcodigo, nombreEmpl				
			</cfquery>

			<cfset vs_botones='Anterior,Generar,Siguiente'>
			<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="DEidentificacion,nombreEmpl,imag,Cesado,JefeEvaluador"/>
					<cfinvokeargument name="etiquetas" value="Identificaci&oacute;n,Nombre Completo,&nbsp;,&nbsp;,#LB_JefeEvaluador#"/>
					<cfinvokeargument name="formatos" value="S,S,U,U,U"/>
					<cfinvokeargument name="align" value="left,left,center,center,center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="showLink" value="true"/>
					<cfinvokeargument name="irA" value="registro_evaluacion.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="botones" value="#vs_botones#"/>
					<cfinvokeargument name="incluyeForm" value="false"/>
					<cfinvokeargument name="Cortes" value="CFcodigocorte"/>
				</cfinvoke> 
		</td>
	  </tr>
	</table>
	<iframe id="fr_empleados" name="fr_empleados" marginheight="0" marginwidth="0" frameborder="0" height="300" width="300" scrolling="auto" src=""></iframe>
</form>

<script language="javascript" type="text/javascript">
	function funcFiltrar(){
		document.lista.REID.value = "<cfoutput>#form.REid#</cfoutput>";
//		document.lista.submit();
		return true;
	}
	function Eliminar(calif,param){
		var mensaje = "";
		if (calif == 1){
			mensaje = "El empleado ya ha sido calificado desea eliminarlo?";
		}else{
			mensaje = "Desea eliminar el empleado ?";
		}
		if ( confirm(mensaje) ){		
			document.lista.BOTON.value = 'Borrar';		
			document.lista.action = "listaEmpl_evaluacion_sql.cfm";
			document.lista.DEID.value = param;
			document.lista.REID.value = "<cfoutput>#form.REid#</cfoutput>";
			document.lista.submit();
		}
	}
	function funcGenerar(){
		if (confirm("Desea generar los empleados ?")) {
			document.lista.BOTON.value = 'Generar';		
			document.lista.action = "listaEmpl_evaluacion_sql.cfm";
			document.lista.REID.value = "<cfoutput>#form.REid#</cfoutput>";
			document.lista.submit();
		}
		return false;		
	}
	
	//FUNCION PARA AGREGAR UN EMPLEADO EVALUAR
	function funcAgregar(){
		var empl = document.lista.LDEidentificacion.value;
		if (empl != ''){
			if (confirm("Desea agregar este Empleado?")) {
				document.lista.BOTON.value = 'Agregar';		
				document.lista.action = "listaEmpl_evaluacion_sql.cfm";
				document.lista.REID.value = "<cfoutput>#form.REid#</cfoutput>";
				document.lista.submit();
			}
			return false;	
		}else{
			alert('Debe seleccionar un empleado.');
			return false;
		}
	}
	function funcModificar(){
		document.lista.BOTON.value = 'Modificar';		
		document.lista.action = "listaEmpl_evaluacion_sql.cfm";
		document.lista.REID.value = "<cfoutput>#form.REid#</cfoutput>";
		//document.lista.submit();
	}
	
	function funcAnterior(){
		document.lista.SEL.value = 4;
		return true;	
	}
	function funcSiguiente(){
		document.lista.SEL.value = 6;
		return true;	
	}	
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisEmpleados(prefijo){
		var params = '';
		params = params + '?po_form=lista';
		<cfoutput>
			params = params + '&REid=#form.REid#' + '&prefijo='+prefijo;
		</cfoutput>
		popUpWindow("/cfmx/rh/evaluaciondes/evaluacion180/operacion/ConlisEmpleados.cfm"+params,200,180,650,400);		
	}
	
	function funcTraerEmpleado(prn_DEidentificacion,REid,prefijo){
		var params = '';
		if (prn_DEidentificacion!=''){	
	   		document.getElementById("fr_empleados").src = '/cfmx/rh/evaluaciondes/evaluacion180/operacion/EmpleadosQuery.cfm?DEidentificacion='+prn_DEidentificacion+'&REid='+REid+'&po_form=lista'+'&prefijo='+prefijo;
	  	}
	 	else{
	 		if (prefijo == 'F'){
	   		document.lista.FDEid.value = '';
			document.lista.FDEidentificacion.value = '';
	   		document.lista.FNombre.value = '';
	 		}else{
	   		document.lista.LDEid.value = '';
			document.lista.LDEidentificacion.value = '';
	   		document.lista.LNombre.value = '';
	 		}
	  	}
	}
	function funcLimpiar(){
		document.lista.FDEid.value = '';
		document.lista.FDEidentificacion.value = '';
   		document.lista.FNombre.value = '';
   		document.lista.FCFid.value = '';
   		document.lista.FCFcodigo.value = '';
   		document.lista.FCFdescripcion.value = '';
   		document.lista.FRHPcodigo.value = '';
   		document.lista.FRHPcodigoext.value = '';
   		document.lista.FRHPdescpuesto.value = '';
	}
</script>

