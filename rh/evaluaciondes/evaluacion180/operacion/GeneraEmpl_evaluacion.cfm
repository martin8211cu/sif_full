<!--- VARIABLES DE TRADUCCION --->
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
	Key="LB_Empleado"
	Default="Empleado"
	returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Evaluador"
	Default="Evaluador"
	returnvariable="LB_Evaluador"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TipoEvaluacion"
	Default="Tipo Evaluaci&oacute;n"
	returnvariable="LB_TipoEvaluacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeJefesParaEvaluar"
	Default="Lista de Jefes para Evaluar"
	returnvariable="LB_ListaDeJefesParaEvaluar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NoSeEvalua"
	Default="No se eval&uacute;a"
	returnvariable="LB_NoSeEvalua"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EvaluacionAplicada"
	Default="Evaluaci&oacute;n Aplicada"
	returnvariable="LB_EvaluacionAplicada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SeEvalua"
	Default="Se eval&uacute;a"
	returnvariable="LB_SeEvalua"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EvaluacionNoAplicada"
	Default="Evaluaci&oacute;n no Aplicada"
	returnvariable="LB_EvaluacionNoAplicada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Jefe"
	Default="Jefe"
	returnvariable="LB_Jefe"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Autogestion"
	Default="Autogesti&oacute;n"
	returnvariable="LB_Autogestion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeEmpleados"
	Default="Lista de empleados"	
	returnvariable="LB_ListaDeEmpleados"/>
	
<!--- FIN VARIABLES DE TRADUCCION --->

<!--- PROCESO DE ACTUALIZACIÓN DEL JEFE PARA CADA UNO DE LOS EMPLEADOS 
	VERIFICA CUAL ES EL JEFE DEL EMPLEADO Y SI ESTA ASIGNADO COMO JEFE 
	EN LA RELACION, SI ES ASI ENTONCES ACTUALIZA EL JEFE DEL EMPLEADO
	EN LA RELACION SI NO LO DEJA EN NULL
--->
<cfif isdefined("form.REid") and len(trim(form.REid))>
	<cfquery name="rsAplicaJefe" datasource="#session.DSN#">
		select REaplicajefe as AplicaJefe 
		from RHRegistroEvaluacion a
		where a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>


<!--- FIN DE PROCESO DE ACTUALIZACIÓN DEL JEFE PARA CADA UNO DE LOS EMPLEADOS --->

<cfset ffiltro = "">
<cfset ffiltro2 = "">
<cfset f_nuevo = false>	
<cfset navegacion = "&REid=#form.REid#&SEL=6&Estado=#form.Estado#">
<cfif isdefined("url.DEidlista") and not isdefined("form.DEidlista")>
	<cfset form.DEidlista = url.DEidlista >
</cfif>

<!--- Simula que variables que vienen por get vienen por post --->
<!--- Variables de Filtro --->
<cfif isdefined("url.DEidFILTRO") and len(trim(url.DEidFILTRO))>
	<cfset form.DEidFILTRO = url.DEidFILTRO>
</cfif>	
<cfif isdefined("url.DEIDFILTRO2") and len(trim(url.DEIDFILTRO2))>
	<cfset form.DEIDFILTRO2 = url.DEIDFILTRO2>
</cfif>	
<cfif isdefined("url.Indicadores") and len(trim(url.Indicadores))>
	<cfset form.Indicadores = url.Indicadores>
</cfif>	
<!--- Variables de Paginación --->
<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
	<cfset form.pagina2 = url.Pagina2>
</cfif>	
<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
	<cfset form.pagina2 = url.PageNum_Lista2>
</cfif>	
<cfif isdefined('form.btnBuscar')>
	<cfset form.pagina2 = 1>
</cfif>



<cfparam name="form.pagina2" default="1">
<cfparam name="form.DEidFILTRO" default="">
<cfparam name="form.DEIDFILTRO2" default="">
<cfparam name="form.Indicadores" default="">

<form action="registro_evaluacion.cfm" method="post" name="lista">
	<cfoutput>
		<input type="hidden" name="BOTON" value="">
		<input type="hidden" name="SEL" value="6">	
		<input type="hidden" name="REID" value="#form.REID#">	
		<input type="hidden" name="Estado" value="<cfif isdefined("form.Estado") and form.Estado EQ 1>#form.Estado#<cfelse>0</cfif>">	
		<input type="hidden" name="pagina2" value="#form.pagina2#">
		
		<cfif isdefined("form.DEidlista") and len(trim(form.DEidlista))>
			<input type="hidden" name="DEID" value="#form.DEidlista#">
			<cfquery name="rsDatos" datasource="#session.DSN#">
				select  ere.DEid,
						ere.DEidjefe,
						de.DEidentificacion ,
						{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombreEmpl,
						dejefe.DEidentificacion  idjefe,
						{fn concat({fn concat({fn concat({fn concat(dejefe.DEnombre , ' ' )}, dejefe.DEapellido1 )}, ' ' )}, dejefe.DEapellido2 )} as nombrejefe,
						EREnoempleado,EREnojefe,
						case when 
							(select   1
							 from RHRegistroEvaluadoresE a
							 where a.DEid = ere.DEid
							   and ere.REid = a.REid
							   and REEfinalj = 1
							 ) = 1 then
								1
							else					
								0 
							end as Calificado,
						EREjefeEvaluador
				from RHEmpleadoRegistroE  ere
				inner join DatosEmpleado de 
					on de.Ecodigo= ere.Ecodigo 
					and de.DEid= ere.DEid 
					and ere.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEidlista#">
				left outer join DatosEmpleado dejefe 
					on dejefe.Ecodigo= ere.Ecodigo 
					and dejefe.DEid= ere.DEidjefe
				where ere.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ere.REid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
			</cfquery>
			
		<cfelse>
			<input type="hidden" name="DEID" value="">
			<input type="hidden" name="POSICION" value="">	
		</cfif>
		<cfif isdefined("form.DEidFILTRO") and len(trim(form.DEidFILTRO))>
			<cfset ffiltro  = ffiltro  & " and ere.DEid = " & trim(form.DEidFILTRO)>
			<cfset ffiltro2 = ffiltro2 & " and ere.DEid = " & trim(form.DEidFILTRO)>
			
			<cfset navegacion = navegacion & "&DEidFILTRO=#trim(form.DEidFILTRO)#">
		</cfif>
		<cfif isdefined("form.DEIDFILTRO2") and len(trim(form.DEIDFILTRO2))>
			<cfset ffiltro  = ffiltro  & " and ere.DEidjefe = " & form.DEIDFILTRO2>
			<cfset ffiltro2 = ffiltro2 & " and ere.DEidjefe = " & form.DEIDFILTRO2>
			<cfset navegacion = navegacion & "&DEidFILTRO2=#form.DEidFILTRO2#">
		</cfif>		
		<cfif isdefined("form.Indicadores") and len(trim(form.Indicadores))>
			<cfset ffiltro  = ffiltro  & " and ere.EREnoempleado = " & form.Indicadores>
			<cfset ffiltro2 = ffiltro2 & " and ere.EREnojefe = " & form.Indicadores>
			<cfset navegacion = navegacion & "&Indicadores=#form.Indicadores#">
		</cfif>
	</cfoutput>
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		<tr><td colspan="3" >&nbsp;</td></tr>
	  	<tr>
			<td><strong><cfoutput>#LB_Empleado#</cfoutput>:</strong></td>
			<td>
				<cfif isdefined("form.DEidlista") and len(trim(form.DEidlista))>
					<cfoutput>#rsDatos.DEidentificacion#&nbsp;#rsDatos.nombreEmpl#</cfoutput>
					<input name="Calif" type="hidden" value="<cfoutput>#rsDatos.Calificado#</cfoutput>">
				</cfif>
			</td>
			<td   nowrap="nowrap">
				<input type="checkbox" name="EREnoempleado" tabindex="1" id="EREnoempleado" <cfif isdefined("rsDatos") and rsDatos.EREnoempleado eq 1>checked</cfif>/>
				<label for="EREnoempleado"><cf_translate key="CHK_NoEvaluarEmpleado">No evaluar (Empleado)</cf_translate></label>
			</td>
		</tr>	  
		<tr>
			<td align="right">
				<cfif isdefined("rsAplicaJefe") and len(trim(rsAplicaJefe.AplicaJefe)) and rsAplicaJefe.AplicaJefe EQ 1>
					<strong><cf_translate key="LB_Jefe" XmlFile="/rh/generales.xml">Jefe</cf_translate>:</strong>
				<cfelseif isdefined("rsAplicaJefe") and len(trim(rsAplicaJefe.AplicaJefe)) and rsAplicaJefe.AplicaJefe EQ 0>
					&nbsp;
				<cfelse>	
					<strong><cf_translate key="LB_Jefe" XmlFile="/rh/generales.xml">Jefe</cf_translate>:</strong>
				</cfif>
			</td>
			<td >		
				<cfset valuesArray = ArrayNew(1)>
				<cfif isdefined("form.DEidlista") and len(trim(form.DEidlista)) and rsDatos.DEidjefe GT 0>
					<cfquery name="rsJDEid" datasource="#session.DSN#">
						select DEid, DEidentificacion,
							{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombreEmpl
						from DatosEmpleado 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.DEidjefe#">
					</cfquery>
					<cfset ArrayAppend(valuesArray, rsJDEid.DEid)>
					<cfset ArrayAppend(valuesArray, rsJDEid.DEidentificacion)>
					<cfset ArrayAppend(valuesArray, rsJDEid.nombreEmpl)>
					
				</cfif>
					<cf_conlis 
						valuesArray="#valuesArray#" 
						campos="DEidjefe,DEidentificacionjefe,nombreEmpl"
						size="0,10,60"
						desplegables="N,S,S"
						modificables="N,S,N"
						title="#LB_ListaDeJefesParaEvaluar#"
						tabla="RHEmpleadoRegistroE ere 
							inner join DatosEmpleado de
								on de.DEid = ere.DEid"
						columnas="ere.DEid as DEidjefe,DEidentificacion as DEidentificacionjefe,{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombreEmpl"
						filtro="REid=#form.REid#
							and EREjefeEvaluador = 1"
						filtrar_por="DEidentificacion|{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}"
						filtrar_por_delimiters="|"
						desplegar="DEidentificacionjefe,nombreEmpl"
						etiquetas="#LB_Identificacion#,#LB_Nombre#"
						formatos="S,S"
						align="left,left"
						asignar="DEidjefe,DEidentificacionjefe,nombreEmpl"
						asignarFormatos="I,S,S"
						form="lista"
						showEmptyListMsg="true"
						tabindex="1"
						alt="id,#LB_Identificacion#,#LB_Nombre#"/>	
			</td>
			<td nowrap="nowrap">
				<cfif isdefined("rsAplicaJefe") and len(trim(rsAplicaJefe.AplicaJefe)) and rsAplicaJefe.AplicaJefe EQ 1>
					<input type="checkbox" name="EREnojefe" id="EREnojefe" tabindex="1" <cfif isdefined("rsDatos") and rsDatos.EREnojefe eq 1>checked</cfif>/>
					<label for="EREnojefe"><cf_translate key="CHK_NoEvaluarJefe">No evaluar (Jefe)</cf_translate></label>
				<cfelseif isdefined("rsAplicaJefe") and len(trim(rsAplicaJefe.AplicaJefe)) and rsAplicaJefe.AplicaJefe EQ 0>
					&nbsp;
				<cfelse>
					<input type="checkbox" name="EREnojefe" tabindex="1" id="EREnojefe" <cfif isdefined("rsDatos") and rsDatos.EREnojefe eq 1>checked</cfif>/>
					<label for="EREnojefe"><cf_translate key="CHK_NoEvaluarJefe">No evaluar (Jefe)</cf_translate></label>
					&nbsp;
				</cfif>
			</td>
		</tr>	  
		<tr><td colspan="3" align="center"><cf_botones values="Modificar" names="ModificarEmp" tabindex="1"></td></tr>	 
		<tr><td colspan="3" align="center"><hr></td></tr>
		<tr class="areaFiltro">
			<td align="right" nowrap><strong><cfoutput>#LB_Empleado#</cfoutput>:</strong></td>
			<td>
				<cfset valuesArrayemp = ArrayNew(1)>
				<cfif (isdefined('form.DEidFILTRO') and len(trim(form.DEidFILTRO)))
					and (isdefined('form.DEIDENTIFICACIONFILTRO') and len(trim(form.DEIDENTIFICACIONFILTRO)))
					and (isdefined('form.nombreEmplFILTRO') and len(trim(form.nombreEmplFILTRO)))>
					<cfset ArrayAppend(valuesArrayemp, form.DEIDFILTRO)>
					<cfset ArrayAppend(valuesArrayemp, form.DEIDENTIFICACIONFILTRO)>
					<cfset ArrayAppend(valuesArrayemp, form.nombreEmplFILTRO)>
				<cfelseif (isdefined('form.DEidFILTRO') and len(trim(form.DEidFILTRO)))>
					<cfquery name="rsEmplFILTRO" datasource="#session.dsn#">
						select DEid, DEidentificacion, {fn concat(DEapellido1,{fn concat(' ', {fn concat(DEapellido2, {fn concat(' ', DEnombre)})})})} as nombreEmpl
						from DatosEmpleado
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEidFILTRO#">
					</cfquery>
					<cfset ArrayAppend(valuesArrayemp, rsEmplFILTRO.DEID)>
					<cfset ArrayAppend(valuesArrayemp, rsEmplFILTRO.DEIDENTIFICACION)>
					<cfset ArrayAppend(valuesArrayemp, rsEmplFILTRO.nombreEmpl)>
				</cfif>
				<cf_conlis 
						valuesArray="#valuesArrayemp#" 
						campos="DEidFILTRO,DEidentificacionFILTRO,nombreEmplFILTRO"
						size="0,10,60"
						desplegables="N,S,S"
						modificables="N,S,N"
						title="#LB_ListaDeEmpleados#"
						tabla="RHEmpleadoRegistroE  ere 
									inner join DatosEmpleado de 
									on de.Ecodigo= ere.Ecodigo 
									and de.DEid= ere.DEid"
									
						columnas="ere.DEid as DEidFILTRO,
									de.DEidentificacion as DEidentificacionFILTRO,
									{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombreEmplFILTRO"
						filtro="ere.Ecodigo = #session.Ecodigo#
									and ere.REid = #form.REid#
									order by DEidentificacion"
						filtrar_por="DEidentificacion|{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}"
						filtrar_por_delimiters="|"
						desplegar="DEidentificacionFILTRO,nombreEmplFILTRO"
						etiquetas="#LB_Identificacion#,#LB_Nombre#"
						formatos="S,S"
						align="left,left"
						asignar="DEidFILTRO,DEidentificacionFILTRO,nombreEmplFILTRO"
						asignarFormatos="I,S,S"
						form="lista"
						showEmptyListMsg="true"
						tabindex="1"
						alt="nada,#LB_Identificacion#,#LB_Nombre#"/>					
			</td>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td align="right" nowrap="true"><strong><cf_translate key="LB_Indicadores">Indicadores</cf_translate></strong>:&nbsp;</td>
						<td>
							<select name="Indicadores" tabindex="1">
								<option value=""><cf_translate key="LB_Todos">Todos</cf_translate></option>
								<option value="1" <cfif isdefined("form.Indicadores") and len(trim(form.Indicadores)) and form.Indicadores EQ 1>selected</cfif>><cf_translate key="LB_NoEvaluables">No evaluables</cf_translate></option>
							</select>
						</td>
					</tr>
				</table>
			</td>
		</tr>	  
		<tr class="areaFiltro">
			<td align="right" nowrap><strong><cf_translate key="LB_Jefe" XmlFile="/rh/generales.xml">Jefe</cf_translate>:</strong></td>
			<td colspan="1">
				<cfset valuesArrayjefe = ArrayNew(1)>
				<cfif (isdefined('form.DEidFILTRO2') and len(trim(form.DEidFILTRO2)))
					and (isdefined('form.DEIDENTIFICACIONFILTRO2') and len(trim(form.DEIDENTIFICACIONFILTRO2)))
					and (isdefined('form.nombreEmplFILTRO2') and len(trim(form.nombreEmplFILTRO2)))>
					<cfset ArrayAppend(valuesArrayjefe, form.DEIDFILTRO2)>
					<cfset ArrayAppend(valuesArrayjefe, form.DEIDENTIFICACIONFILTRO2)>
					<cfset ArrayAppend(valuesArrayjefe, form.nombreEmplFILTRO2)>
				<cfelseif (isdefined('form.DEidFILTRO2') and len(trim(form.DEidFILTRO2)))>
					<cfquery name="rsEmplFILTRO2" datasource="#session.dsn#">
						select DEid, DEidentificacion, {fn concat(DEapellido1,{fn concat(' ', {fn concat(DEapellido2, {fn concat(' ', DEnombre)})})})} as nombreEmpl
						from DatosEmpleado
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEidFILTRO2#">
					</cfquery>
					<cfset ArrayAppend(valuesArrayjefe, rsEmplFILTRO2.DEID)>
					<cfset ArrayAppend(valuesArrayjefe, rsEmplFILTRO2.DEIDENTIFICACION)>
					<cfset ArrayAppend(valuesArrayjefe, rsEmplFILTRO2.nombreEmpl)>
				</cfif>		
				<cf_conlis 
						valuesArray="#valuesArrayjefe#" 
						campos="DEidFILTRO2,DEidentificacionFILTRO2,nombreEmplFILTRO2"
						size="0,10,60"
						desplegables="N,S,S"
						modificables="N,S,N"
						title="Lista de jefes"
						tabla="RHEmpleadoRegistroE  ere 
									inner join DatosEmpleado de 
									on de.Ecodigo= ere.Ecodigo 
									and de.DEid= ere.DEidjefe"
						columnas=" distinct ere.DEidjefe as DEidFILTRO2,
									de.DEidentificacion as DEidentificacionFILTRO2,
									{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombreEmplFILTRO2"
						filtro="ere.Ecodigo = #session.Ecodigo#
									and ere.REid = #form.REid#
									union
									select ere1.DEid as DEidFILTRO2, de1.DEidentificacion as DEidentificacionFILTRO2,
										{fn concat({fn concat({fn concat({fn concat(de1.DEnombre , ' ' )}, de1.DEapellido1 )}, ' ' )}, de1.DEapellido2 )} as nombreEmplFILTRO2
									from RHEmpleadoRegistroE ere1
										inner join DatosEmpleado de1
											on ere1.DEid = de1.DEid
									where ere1.REid = #form.REid#
									  and ere1.EREjefeEvaluador = 1
									order by DEidentificacion"
						filtrar_por="DEidentificacion|{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}"
						filtrar_por_delimiters="|"
						desplegar="DEidentificacionFILTRO2,nombreEmplFILTRO2"
						etiquetas="#LB_Identificacion#,#LB_Nombre#"
						formatos="S,S"
						align="left,left"
						asignar="DEidFILTRO2,DEidentificacionFILTRO2,nombreEmplFILTRO2"
						asignarFormatos="I,S,S"
						form="lista"
						showEmptyListMsg="true"
						tabindex="1"
						alt="id,#LB_Identificacion#,#LB_Nombre#"/>					
			</td>
			<td width="42%" align="center" style="vertical-align:middle ">
				<cfoutput>
					<input name="btnBuscar" type="submit" id="btnBuscar" value="#BTN_Filtrar#" tabindex="1">
					<input name="btnLimpiar" type="button" id="btnLimpiar" value="#BTN_Limpiar#" tabindex="1" onclick="javascript: funcLimpiar();">
				</cfoutput>
			</td>
		</tr>	  	    
		<tr>
			<td colspan="3" align="center">
				<!--- Lista --->
				<cfquery  name="rsrelacion" datasource="#Session.DSN#">
					select REaplicajefe,REaplicaempleado from RHRegistroEvaluacion
					where REid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				</cfquery>
		
				<cf_dbfunction name="to_char" args="de.DEid" returnvariable="Lvar_to_char_DEid">
				<cfif not (rsrelacion.REaplicajefe eq 0 and rsrelacion.REaplicaempleado eq 0)>
		
					<cf_dbtemp name="datos" returnvariable="datos" datasource="#session.DSN#">
						<cf_dbtempcol name="DEidlista"			type="numeric"			mandatory="no" >
						<cf_dbtempcol name="DEidentificacion"	type="varchar(255)"		mandatory="no" >
						<cf_dbtempcol name="nombreEmpl"			type="varchar(255)"		mandatory="no" > 
						<cf_dbtempcol name="DEidevaluador"		type="numeric"			mandatory="no" >
						<cf_dbtempcol name="IDEvaluador"		type="varchar(255)"		mandatory="no" >
						<cf_dbtempcol name="Evaluador"			type="varchar(255)"		mandatory="no" >
						<cf_dbtempcol name="posicion"			type="varchar(100)"		mandatory="no" >
						<cf_dbtempcol name="imag"				type="varchar(255)"		mandatory="no" >
						<cf_dbtempcol name="Evalua"				type="varchar(255)"		mandatory="no" >
						<cf_dbtempcol name="Finalizado"			type="varchar(255)"		mandatory="no" >
					</cf_dbtemp>
		
					<cfquery name="rsLista" datasource="#session.dsn#">
						insert into ##datos( DEidlista, 
											DEidentificacion, 
											nombreEmpl, 
											DEidevaluador, 
											IDEvaluador, 
											Evaluador, 
											posicion, 
											imag, 
											Finalizado, 
											Evalua )
						<cfif rsrelacion.REaplicajefe eq 1 and rsrelacion.REaplicaempleado eq 1 >
		
							select 
								ere.DEid as DEidlista,
								de.DEidentificacion ,
								{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombreEmpl,
								de.DEid as DEidevaluador,
								de.DEidentificacion as IDEvaluador,
								{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as Evaluador,
								'#LB_Autogestion#' as posicion,	
								case when 
								(select   1
								 from RHRegistroEvaluadoresE a
								 where a.DEid = ere.DEid
								   and ere.REid = a.REid
								   and REEfinale = 1 
								 ) = 1 then
								 	{fn concat('<a href="javascript: Eliminar(1,''',{fn  concat(#Lvar_to_char_DEid#,''',0);"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>')})}
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
								end as imag,
								case when 
										(select   1
										from RHRegistroEvaluadoresE a
											inner join RHEmpleadoRegistroE b
											on b.REid = a.REid
											and b.DEid = a.DEid
											and b.EREnoempleado = 0
											<!--- and b.EREnojefe = 0 --->
										where a.DEid = ere.DEid
											and ere.REid = a.REid
											and REEfinale = 1
											) = 1 then
									'<img src="/cfmx/rh/imagenes/checked.gif"  alt="#LB_EvaluacionAplicada#" border="0">'
								else
									'<img src="/cfmx/rh/imagenes/unchecked.gif" alt="#LB_EvaluacionNoAplicada#" border="0">'
								end as Finalizado,
								case  ere.EREnoempleado when 1 then
									'<img src="/cfmx/rh/imagenes/chequeado.gif"  alt="#LB_NoSeEvalua#" border="0">'
								else
									'<img src="/cfmx/rh/imagenes/sinchequear.gif" alt="#LB_SeEvalua#" border="0">'
								end as Evalua
							 
							from RHEmpleadoRegistroE  ere
								inner join DatosEmpleado de 
									on de.Ecodigo= ere.Ecodigo 
									and de.DEid= ere.DEid 
								left outer  join DatosEmpleado dEval
									on dEval.Ecodigo= ere.Ecodigo 
									and dEval.DEid= ere.DEidjefe
								where ere.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and ere.REid =    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
								#ffiltro#
							union
							<!---Trae los evaluadores (Jefes)---->
							select 
								ere.DEid as DEidlista,
								de.DEidentificacion ,
								{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombreEmpl,
								dEval.DEid as DEidevaluador,
								dEval.DEidentificacion as IDEvaluador,
								{fn concat({fn concat({fn concat({fn concat(dEval.DEnombre , ' ' )}, dEval.DEapellido1 )}, ' ' )}, dEval.DEapellido2 )} as Evaluador,
								'#LB_Jefe#' as posicion ,						
								case when 
								(select   1
								from RHRegistroEvaluadoresE a
								where a.REEevaluadorj  = ere.DEidjefe
									and ere.DEid = a.DEid
									and ere.REid = a.REid
									and REEfinalj = 1
								 ) = 1 then
								 	{fn concat('<a href="javascript: Eliminar(1,''',{fn concat(#Lvar_to_char_DEid#,''',0);"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>')})}
								else					
									{fn concat('<a href="javascript: Eliminar(0,''',{fn concat(#Lvar_to_char_DEid#,''',0);"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>')})}
							end as imag,
								case when 
										(select   1
										from RHRegistroEvaluadoresE a
										inner join RHEmpleadoRegistroE b
											on b.REid = a.REid
											and b.DEid = a.DEid
											<!--- and b.EREnoempleado = 0 --->
											and b.EREnojefe = 0 
										where a.REEevaluadorj  = ere.DEidjefe
											and ere.DEid = a.DEid
											and ere.REid = a.REid
											and REEfinalj = 1
											) = 1 then
									'<img src="/cfmx/rh/imagenes/checked.gif"  alt="#LB_EvaluacionAplicada#" border="0">'
								else
									'<img src="/cfmx/rh/imagenes/unchecked.gif" alt="#LB_EvaluacionNoAplicada#" border="0">'
								end as Finalizado,
								case  ere.EREnojefe when 1 then
									'<img src="/cfmx/rh/imagenes/chequeado.gif" alt="#LB_NoSeEvalua#" border="0">'
								else
									'<img src="/cfmx/rh/imagenes/sinchequear.gif" alt="#LB_SeEvalua#" border="0">'
								end as Evalua
							
							from RHEmpleadoRegistroE   ere
								inner join DatosEmpleado de 
									on de.Ecodigo= ere.Ecodigo 
									and de.DEid= ere.DEid 
								left outer  join DatosEmpleado dEval
									on dEval.Ecodigo= ere.Ecodigo 
									and dEval.DEid= ere.DEidjefe
								where ere.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and ere.REid =    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
								#ffiltro2#				
						<cfelseif rsrelacion.REaplicajefe eq 0 and rsrelacion.REaplicaempleado eq 1 >
						<!--- solo empleados --->
							select 
								ere.DEid as DEidlista,
								de.DEidentificacion ,
								{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombreEmpl,
								de.DEid as DEidevaluador,
								de.DEidentificacion as IDEvaluador,
								{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as Evaluador,
								'#LB_Autogestion#' as posicion,						
								case when 
								(select   1
								 from RHRegistroEvaluadoresE a
								 where a.DEid = ere.DEid
								   and ere.REid = a.REid
								   and REEfinale = 1 
								 ) = 1 then
								 	{fn concat('<a href="javascript: Eliminar(1,''',{fn concat(#Lvar_to_char_DEid#,''',0);"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>')})}
							  	else					
							  		{fn concat('<a href="javascript: Eliminar(0,''',{fn concat(#Lvar_to_char_DEid#,''',0);"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>')})}
								end as imag,
								case when 
										(select   1
										from RHRegistroEvaluadoresE a
										inner join RHEmpleadoRegistroE b
											on b.REid = a.REid
											and b.DEid = a.DEid
											and b.EREnoempleado = 0
											<!--- and b.EREnojefe = 0 --->
										where a.DEid = ere.DEid
											and ere.REid = a.REid
											and REEfinale = 1
											) = 1 then
									'<img src="/cfmx/rh/imagenes/checked.gif"  alt="#LB_EvaluacionAplicada#" border="0">'
								else
									'<img src="/cfmx/rh/imagenes/unchecked.gif"  alt="#LB_EvaluacionNoAplicada#" border="0">'
								end as Finalizado,
								case  ere.EREnoempleado when 1 then
									'<img src="/cfmx/rh/imagenes/chequeado.gif" alt="#LB_NoSeEvalua#" border="0">'
								else
									'<img src="/cfmx/rh/imagenes/sinchequear.gif" alt="#LB_SeEvalua#" border="0">'
								end as Evalua
							
							from RHEmpleadoRegistroE   ere
								inner join DatosEmpleado de 
									on de.Ecodigo= ere.Ecodigo 
									and de.DEid= ere.DEid 
								left outer  join DatosEmpleado dEval
									on dEval.Ecodigo= ere.Ecodigo 
									and dEval.DEid= ere.DEidjefe
							where ere.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and ere.REid =    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
								#ffiltro#						
						<cfelseif rsrelacion.REaplicajefe eq 1 and rsrelacion.REaplicaempleado eq 0 >
						<!--- solo jefes --->
							select 
								ere.DEid as DEidlista,
								de.DEidentificacion ,
								{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombreEmpl,
								dEval.DEid as DEidevaluador,
								dEval.DEidentificacion as IDEvaluador,
								{fn concat({fn concat({fn concat({fn concat(dEval.DEnombre , ' ' )}, dEval.DEapellido1 )}, ' ' )}, dEval.DEapellido2 )} as Evaluador,
								'#LB_Jefe#' as posicion ,						
								case when 
								(select   1
								 from RHRegistroEvaluadoresE a
								 where a.DEid = ere.DEid
								   and ere.REid = a.REid
								   and REEfinalj = 1
								 ) = 1 then
								 	{fn concat('<a href="javascript: Eliminar(1,''',{fn concat(#Lvar_to_char_DEid#,''',0);"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>')})}
								else
									{fn concat('<a href="javascript: Eliminar(0,''',{fn concat(#Lvar_to_char_DEid#,''',0);"><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>')})}				
								end as imag,
								case when 
										(select   1
										from RHRegistroEvaluadoresE a
											inner join RHEmpleadoRegistroE b
											on b.REid = a.REid
											and b.DEid = a.DEid
											and b.EREnojefe = 0
										where a.REEevaluadorj  = ere.DEidjefe
											and ere.REid = a.REid
											and ere.DEid = a.DEid
											and REEfinalj = 1
											) = 1 then
									'<img src="/cfmx/rh/imagenes/checked.gif" alt="#LB_EvaluacionAplicada#" border="0">'
								else
									'<img src="/cfmx/rh/imagenes/unchecked.gif" alt="#LB_EvaluacionNoAplicada#" border="0">'
								end as Finalizado,
								case  ere.EREnojefe when 1 then
									'<img src="/cfmx/rh/imagenes/chequeado.gif" alt="#LB_NoSeEvalua#" border="0">'
								else
									'<img src="/cfmx/rh/imagenes/sinchequear.gif"  alt="#LB_SeEvalua#" border="0">'
								end as Evalua			
								
							from RHEmpleadoRegistroE   ere
								inner join DatosEmpleado de 
									on de.Ecodigo= ere.Ecodigo 
									and de.DEid= ere.DEid 
								left outer  join DatosEmpleado dEval
									on dEval.Ecodigo= ere.Ecodigo 
									and dEval.DEid= ere.DEidjefe
							where ere.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and ere.REid =    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
								#ffiltro2#	
						</cfif>				
						order by ere.DEid,posicion	
					</cfquery>
					
					<cfquery name="rsLista" datasource="#session.dsn#">
						select  a.DEidlista, 
								a.DEidentificacion, 
								a.nombreEmpl, 
								a.DEidevaluador,
								a.IDEvaluador, 
								a.Evaluador, 
								a.posicion, 
								a.imag, 
								a.Finalizado, 
								a.Evalua,							
								case when a.DEidlista != DEidevaluador then ( 	select min({fn concat(rtrim(CFcodigo),{fn concat(' - ',CFdescripcion)})})
																				from LineaTiempo lt
																			
																				inner join RHPlazas p
																				on p.RHPid=lt.RHPid
																			
																				inner join CFuncional cf
																				on cf.CFid=p.CFid
																			
																				where lt.DEid=a.DEidlista
																				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta )
																				
									 else	( 	select min({fn concat(rtrim(CFcodigo),{fn concat(' - ',CFdescripcion)})})
												from LineaTiempo lt
											
												inner join RHPlazas p
												on p.RHPid=lt.RHPid
											
												inner join CFuncional cf
												on cf.CFid=p.CFid
											
												where lt.DEid=a.DEidevaluador
												and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta )
								end as CFcodigo
		
						from ##datos a
						order by CFcodigo, a.DEidentificacion, a.posicion
					</cfquery>
					<!--- SE ELIMINA EL BOTON DE GENERAR PARA QUE EL USUARIO NI PIERDA LA INFORMACION. --->				
					<!--- <cfif isdefined("form.Estado") and form.Estado EQ 1> --->
						<cfset vs_botones='Anterior,Siguiente'>
		<!--- 				<cfelse>
							<cfset vs_botones='Anterior,Generar,Siguiente'>
						</cfif>
		 --->				<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="DEidentificacion,nombreEmpl,IDEvaluador,Evaluador,posicion,imag,Finalizado,Evalua"/>
							<cfinvokeargument name="etiquetas" value="#LB_Empleado#,&nbsp;,#LB_Evaluador#,&nbsp;,#LB_TipoEvaluacion#,&nbsp;,&nbsp;,&nbsp;"/>
							<cfinvokeargument name="formatos" value="S,S,S,S,S,U,V,V"/>
							<cfinvokeargument name="align" value="left,left,left,left,left,center,center,center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="irA" value="registro_evaluacion.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="DEidlista,posicion"/>
							<cfinvokeargument name="botones" value="#vs_botones#"/>
							<cfinvokeargument name="incluyeForm" value="false"/>
							<cfinvokeargument name="PageIndex" value="2"/>
							<cfinvokeargument name="filtro_nuevo" value="#isdefined('form.btnBuscar')#"/>
							<cfinvokeargument name="Cortes" value="CFcodigo"/>
						</cfinvoke>
				<cfelse>
					<strong>
						<cf_translate key="MSG_DebeSeleccionarAlgunoDeLosIndicadoresAplicaSoloJefeOAplicaAFuncionarioEnElPasoNo1">
						---- Debe seleccionar alguno de los indicadores: "Aplica solo jefe" o 
								"Aplica a funcionario", en el paso No.1 ----
						</cf_translate>
					</strong>
				</cfif>
			</td>
		</tr>
	</table>
</form>
<!--- VARIABLES DE TRADUCCION PARA EL SCRIPT --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElEmpleadoYaHaSidoCalificadoQuitarEvaluacionPorJefe"
	Default="El Empleado ya ha sido calificado, Quitar evaluaci&oacute;n por jefe ?"
	returnvariable="MSG_ElEmpleadoYaHaSidoCalificadoQuitarEvaluacionPorJefe"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_QuitarEvaluacionPorJefe"
	Default="Quitar evaluaci&oacute;n por jefe ?"
	returnvariable="MSG_QuitarEvaluacionPorJefe"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElEmpleadoYaHaSidoCalificadoQuitarEvaluacionPorEmpleado"
	Default="El Empleado ya ha sido calificado, Quitar evaluaci&oacute;n por empleado ?"
	returnvariable="MSG_ElEmpleadoYaHaSidoCalificadoQuitarEvaluacionPorEmpleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_QuitarEvaluacionPorEmpleado"
	Default="Quitar evaluaci&oacute;n por empleado ?"
	returnvariable="MSG_QuitarEvaluacionPorEmpleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarUnEmpleado"
	Default="Debe seleccionar un empleado"
	returnvariable="MSG_DebeSeleccionarUnEmpleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElEmpleadoYaHaSidoCalificadoPorElJefeDeseaModificarLosDatos"
	Default="El empleado ya ha sido calificado por el jefe, desea modificar los datos?"
	returnvariable="MSG_ElEmpleadoYaHaSidoCalificadoPorElJefeDeseaModificarLosDatos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaModificarLosDatos"
	Default="Desea modificar los datos?"
	returnvariable="MSG_DeseaModificarLosDatos"/>

<!--- FIN VARIABLES DE TRADUCCION PARA EL SCRIPT --->
<script language="javascript" type="text/javascript">
	function funcFiltrar(){
		document.lista.REID.value = "<cfoutput>#form.REid#</cfoutput>";
		return true;
	}
	function Eliminar(calif,param,pos){
		var mensaje ="";

		if (pos ==1){
			if (calif == 1){
				mensaje ="<cfoutput>#MSG_ElEmpleadoYaHaSidoCalificadoQuitarEvaluacionPorJefe#</cfoutput>";
			}else{
				mensaje ="<cfoutput>#MSG_QuitarEvaluacionPorJefe#</cfoutput>";
			}
		}
		else{
			if (calif == 1){
				mensaje ="<cfoutput>#MSG_ElEmpleadoYaHaSidoCalificadoQuitarEvaluacionPorEmpleado#</cfoutput>";
			}else{
				mensaje ="<cfoutput>#MSG_QuitarEvaluacionPorEmpleado#</cfoutput>";
			}
		}
		if (confirm(mensaje)) {
			document.lista.BOTON.value = 'Borrar';		
			document.lista.action = "GeneraEmpl_evaluacion_sql.cfm";
			document.lista.DEID.value = param;
			document.lista.POSICION.value = pos;
			document.lista.submit();
			return true;
		}
	}
	
	function funcModificarEmp(){
		<cfif isdefined("form.DEidlista") and len(trim(form.DEidlista))>
		var calificado = document.lista.Calif.value;
		</cfif>
		var mensaje = "";
		if (document.lista.DEID) {
			if (document.lista.DEID.value =="") {
				alert("<cfoutput>#MSG_DebeSeleccionarUnEmpleado#</cfoutput>")	
				return false;			
			}
			else{
				<cfif isdefined("form.DEidlista") and len(trim(form.DEidlista))>
				if (calificado == 1){
					mensaje = "<cfoutput>#MSG_ElEmpleadoYaHaSidoCalificadoPorElJefeDeseaModificarLosDatos#</cfoutput>";
				}else{
					mensaje = "<cfoutput>#MSG_DeseaModificarLosDatos#</cfoutput>";
				}
				</cfif>
				if (confirm(mensaje)) {
					document.lista.BOTON.value = 'Modificar';	
					document.lista.action = "GeneraEmpl_evaluacion_sql.cfm";
					document.lista.submit();
					return true;
				}else{
					return false;
				}
			}
		}
		else{
			alert("<cfoutput>#MSG_DebeSeleccionarUnEmpleado#</cfoutput>")	
			return false;	
		}	
	}	
	
	
	function funcGenerar(){
		if (confirm("Desea generar los evaluadores ?")) {
			document.lista.BOTON.value ="GENERAR";
			document.lista.action = "GeneraEmpl_evaluacion_sql.cfm";
			document.lista.submit();
		}
		return false;		
	}	
	function funcAnterior(){
		document.lista.REID.value = "<cfoutput>#form.REid#</cfoutput>";	
		document.lista.SEL.value = 5;
//		document.lista.submit();
		return true;	
	}
	function funcSiguiente(){
		document.lista.REID.value = "<cfoutput>#form.REid#</cfoutput>";	
		document.lista.SEL.value = 7;
//		document.lista.submit();
		return true;	
	}		
	function funcLimpiar(){
		document.lista.DEidFILTRO.value='';
		document.lista.DEidentificacionFILTRO.value='';
		document.lista.nombreEmplFILTRO.value='';
		document.lista.DEidFILTRO2.value='';
		document.lista.DEidentificacionFILTRO2.value='';
		document.lista.nombreEmplFILTRO2.value='';
		document.lista.Indicadores.value = '';
		return true;
	}
</script>
<cffunction name="jefe_usuario" access="package" output="false" returntype="any">
	<cfargument name="DEid" type="numeric" required="yes">
	<cfquery datasource="#session.dsn#" name="cf">
		select cf.CFid as CFpk, cf.CFidresp as CFpkresp, lt.RHPid as plaza_usuario, cf.RHPid as plaza_jefe_cf
		from LineaTiempo lt
			join RHPlazas pl
				on pl.RHPid = lt.RHPid
				and pl.Ecodigo = lt.Ecodigo
			join CFuncional cf
				on cf.CFid = pl.CFid
		where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and lt.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DEid#">
		  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between lt.LTdesde and lt.LThasta
	</cfquery>
	<cfif cf.RecordCount>
	    <cfif (cf.plaza_usuario Is cf.plaza_jefe_cf) And Len(cf.CFpkresp)>
			<cfset real_users = jefe_cf(cf.CFpkresp)>
		<cfelse>
			<cfset real_users = jefe_cf(cf.CFpk)>
		</cfif>
		<cfreturn real_users>
	</cfif>
	
	<cfset real_users = "">

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_NoSeEncontroElUsuario"
		Default="no se encontró el usuario"
		returnvariable="MSG_NoSeEncontroElUsuario"/>	
	<cflog file="workflow" text="jefe_usuario(): #MSG_NoSeEncontroElUsuario#">
	<cfreturn real_users>
</cffunction>
<cffunction name="jefe_cf" access="package" output="false" returntype="any">
	<cfargument name="centro_funcional" type="numeric" required="yes">
	
	<cfset centro_funcional_actual = Arguments.centro_funcional>
	<cfloop condition="Len(centro_funcional_actual)">
		<cfquery datasource="#session.dsn#" name="buscar_cf">
			select cf.Ecodigo, CFuresponsable, lt.DEid as DEid_jefe, CFidresp
			from CFuncional cf
			left join RHPlazas pl
				on cf.RHPid = pl.RHPid
			left join LineaTiempo lt
				on lt.RHPid = pl.RHPid
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between LTdesde and LThasta
			where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#centro_funcional_actual#">
			and cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif buscar_cf.RecordCount>
			<cfif buscar_cf.RecordCount and len(trim(buscar_cf.DEid_jefe))>
				<cfreturn buscar_cf.DEid_jefe>
			</cfif>
			<cfif Len(buscar_cf.CFuresponsable)>
				<cfquery datasource="#session.dsn#" name="real_users">
					select ur.llave as jefe
					from Usuario u
					join UsuarioReferencia ur
						on ur.Usucodigo = u.Usucodigo
						and ur.STabla = 'DatosEmpleado'
					join DatosPersonales dp
						on dp.datos_personales = u.datos_personales
					where ur.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#buscar_cf.CFuresponsable#">
					and ur.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
				</cfquery>
				<cfif real_users.RecordCount and len(trim(real_users.jefe))>
					<cfreturn real_users.jefe> 
				</cfif>
			</cfif>
		</cfif>
		<cfset centro_funcional_actual = buscar_cf.CFidresp>
	</cfloop>
	<cfset real_users = "">
	<cfreturn real_users>
</cffunction>
