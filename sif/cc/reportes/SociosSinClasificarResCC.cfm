<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 09 de marzo del 2006
	Motivo: Agregar el filtro de Clasificación por dirección.
			El encabezado del reporte cambia la etiqueta de Clasificacion General o Clasificacion por direccion

	Creado  por Ana Villavicencio
	Fecha: 09 de diciembre del 2005
	Motivo: Nuevo reporte de Socios sin Clasificar.
--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfif isdefined("url.SNCEID1") and not isdefined('form.SNCEID1')>
	<cfset form.SNCEID1 = url.SNCEID1>
</cfif>
<cfif isdefined("url.SNCEID2") and not isdefined('form.SNCEID2')>
	<cfset form.SNCEID2 = url.SNCEID2>
</cfif>
<cfif isdefined("url.SNnumero") and not isdefined('form.SNnumero')>
	<cfset form.SNnumero = url.SNnumero>
</cfif>
<cfif isdefined("url.SNnumerob2") and not isdefined('form.SNnumerob2')>
	<cfset form.SNnumerob2 = url.SNnumerob2>
</cfif>
<cfif isdefined("url.SC") and not isdefined('form.SC')>
	<cfset form.SC = url.SC>
</cfif>
<cfif isdefined("url.TClasif") and not isdefined('form.TClasif')>
	<cfset form.TClasif = url.TClasif>
</cfif>
<cfif isdefined("url.SP") and not isdefined('form.SP')>
	<cfset form.SP = url.SP>
</cfif>
<cfif isdefined("url.SA") and not isdefined('form.SA')>
	<cfset form.SA = url.SA>
</cfif>
<cfif isdefined("url.Empresa") and not isdefined('form.Empresa')>
	<cfset form.Empresa = url.Empresa>
</cfif>
<cfif isdefined("url.Cobrador") and not isdefined('form.Cobrador')>
	<cfset form.Cobrador = url.Cobrador>
</cfif>
<cfif isdefined("url.DEidCobrador") and not isdefined('form.DEidCobrador')>
	<cfset form.DEidCobrador = url.DEidCobrador>
</cfif>

<cftransaction>
	<cf_dbtemp name="SociosNoClasif" returnvariable="SociosNoClasif" datasource="#session.DSN#">
	  <cf_dbtempcol name="SNid" type="numeric"> 
	  <cf_dbtempcol name="SNCEid" type="numeric">
	  <cf_dbtempcol name="id_direccion" type="numeric">
	</cf_dbtemp>
	
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert into #SociosNoClasif# (SNid, SNCEid,id_direccion)
			select s.SNid, e.SNCEid, 
			<cfif isdefined('form.TClasif') and form.TClasif EQ 0>0 as id_direccion<cfelse>d.id_direccion</cfif>
			from SNegocios s
			<cfif isdefined('form.TClasif') and form.TClasif EQ 0>
				inner join SNClasificacionE e
				   on s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<cfif isdefined("form.SNnumero") and len(trim(form.SNnumero)) and isdefined("form.SNnumerob2") and len(trim(form.SNnumerob2))>
						<cfif form.SNnumero gt SNnumerob2><!--- si el primero es mayor que el segundo. --->
								and s.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumerob2#"> 
													and <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
						<cfelse>
								and s.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#"> 
													and <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumerob2#">
						</cfif>											
					<cfelseif isdefined("form.SNnumero") and len(trim(form.SNnumero))>
						and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#"> 
					<cfelseif isdefined("form.SNcodigob2") and len(trim(form.SNcodigob2))>
						and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumerob2#">
					</cfif>
					and s.SNinactivo = 0
					<!--- --- Parametro.  Si desean únicamente los de la empresa.  No usar si se desean todas las clasificaciones ---> 
					 <cfif isdefined('form.SC')>
						and s.SNtiposocio in ('C', 'A')
					 <cfelseif isdefined('form.SP')>
						and s.SNtiposocio in ('P', 'A')
					 </cfif>
				where 
					<!---Clasificación --->
					<cfif isdefined("form.SNCEID1") and len(trim(form.SNCEID1)) and isdefined("form.SNCEID2") and len(trim(form.SNCEID2))>
					<cfif form.SNCEID1 gt form.SNCEID2> <!--- si el primero es mayor que el segundo. --->
						e.SNCEid between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEID2#">
										 and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEID1#">
					<cfelse>
						e.SNCEid between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEID1#"> 
										 and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEID2#">
					</cfif>
					<cfelseif isdefined("form.SNCEID1") and len(trim(form.SNCEID1))>
					e.SNCEid >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEID1#"> 
					<cfelseif isdefined("form.SNCEID2") and len(trim(form.SNCEID2))>
					e.SNCEid <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEID2#"> 
					</cfif>
					and e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					<!--- Solo Catalogos Activos. (Siempre) --->
					and e.PCCEactivo = 1                				  
					<!--- --- Parametro.  Si desean únicamente los de la empresa.  No usar si se desean todas las clasificaciones --->
					<cfif isdefined('form.Empresa')>
					 and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfif>
					<!---and e.PCCEobligatorio = 1  --->
			 <cfelse>
			 	inner join SNDirecciones d
				   on s.Ecodigo = d.Ecodigo
				  and s.SNcodigo = d.SNcodigo
				  and s.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<cfif isdefined("form.SNnumero") and len(trim(form.SNnumero)) and isdefined("form.SNnumerob2") and len(trim(form.SNnumerob2))>
						<cfif form.SNnumero gt SNnumerob2><!--- si el primero es mayor que el segundo. --->
								and s.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumerob2#"> 
													and <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
						<cfelse>
								and s.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#"> 
													and <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumerob2#">
						</cfif>											
					<cfelseif isdefined("form.SNnumero") and len(trim(form.SNnumero))>
						and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#"> 
					<cfelseif isdefined("form.SNcodigob2") and len(trim(form.SNcodigob2))>
						and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumerob2#">
					</cfif>
					  and s.SNinactivo = 0
					 <!--- --- Parametro.  Si desean únicamente los de la empresa.  No usar si se desean todas las clasificaciones ---> 
					 <cfif isdefined('form.SC')>
					  and s.SNtiposocio in ('C', 'A')
					 <cfelseif isdefined('form.SP')>
					   and s.SNtiposocio in ('P', 'A')
					 </cfif> 
					inner join SNClasificacionE e
						<!---Clasificación --->
						<cfif isdefined("form.SNCEID1") and len(trim(form.SNCEID1)) and isdefined("form.SNCEID2") and len(trim(form.SNCEID2))>
							<cfif form.SNCEID1 gt form.SNCEID2> <!--- si el primero es mayor que el segundo. --->
								on e.SNCEid between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEID2#">
												 and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEID1#">
							<cfelse>
								on e.SNCEid between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEID1#"> 
												 and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEID2#">
							</cfif>
						<cfelseif isdefined("form.SNCEID1") and len(trim(form.SNCEID1))>
							on e.SNCEid >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEID1#"> 
						<cfelseif isdefined("form.SNCEID2") and len(trim(form.SNCEID2))>
							on e.SNCEid <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEID2#"> 
						</cfif>
						  and e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
						  <!--- Solo Catalogos Activos. (Siempre) --->
						  and e.PCCEactivo = 1                				  
						  <!--- --- Parametro.  Si desean únicamente los de la empresa.  No usar si se desean todas las clasificaciones --->
						  <cfif isdefined('form.Empresa')>
							  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">                                   
						  </cfif>
			 </cfif> 
	</cfquery>
	<cfquery name="datos" datasource="#session.DSN#">
		select *
		from #SociosNoClasif#
	</cfquery>
	
	<cfquery name="delete" datasource="#session.DSN#">
		delete from #SociosNoClasif#
		where exists (
			select 1 
			<cfif isdefined('form.TClasif') and form.TClasif EQ 0>
			from SNClasificacionSN cs
			<cfelse>
			from SNClasificacionSND cs
			</cfif>
			inner join SNClasificacionD d
				on d.SNCDid = cs.SNCDid
				
			where cs.SNid = #SociosNoClasif#.SNid
			  and d.SNCEid = #SociosNoClasif#.SNCEid)
	</cfquery>
	
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
		<cfif isdefined('form.TClasif') and form.TClasif EQ 0>
			select 
				s.SNnumero as Numero, 
				s.SNidentificacion as Cedula, 
				substring(s.SNnombre, 1, 60) as Nombre, 
				e.SNCEid,
				e.SNCEcodigo, 
				e.SNCEdescripcion,
				e.PCCEobligatorio
			from #SociosNoClasif# nc
				inner join SNegocios s
					on s.SNid = nc.SNid
				inner join SNClasificacionE e
					on e.SNCEid = nc.SNCEid
				<cfif isdefined("form.DEidCobrador") and len(trim(form.DEidCobrador))>
				   inner join DatosEmpleado g
						on g.DEid = s.DEidCobrador
				 </cfif>
				 <cfif isdefined("form.DEidCobrador") and len(trim(form.DEidCobrador))>
						where g.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEidCobrador#">
				</cfif>
			order by 4
		<cfelse>
			select 
				coalesce(ds.SNDcodigo, s.SNnumero) as Numero,
				coalesce(ds.SNnombre, s.SNnombre) as Nombre,
				s.SNidentificacion as Cedula, 
				s.SNnumero as NumSoc, 
				s.SNnombre as Socio,
				e.SNCEid,
				e.SNCEcodigo, 
				e.SNCEdescripcion,
				e.PCCEobligatorio
			from #SociosNoClasif# nc
			inner join SNDirecciones ds
			   on ds.SNid = nc.SNid
			  and ds.id_direccion = nc.id_direccion
			inner join SNegocios s
			   on ds.SNid = s.SNid
			  and ds.Ecodigo = s.Ecodigo
			  and ds.SNcodigo = s.SNcodigo
			inner join SNClasificacionE e
			   on e.SNCEid = nc.SNCEid
		   <cfif isdefined("form.DEidCobrador") and len(trim(form.DEidCobrador))>
				inner join DatosEmpleado g
					on g.DEid = ds.DEidCobrador 
		   </cfif>
		   <cfif isdefined("form.DEidCobrador") and len(trim(form.DEidCobrador))>
				where g.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEidCobrador#">
		   </cfif>
		  order by e.SNCEid
		</cfif>
	</cfquery>
</cftransaction>



<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
	<cfset MSG_RegLim = t.Translate('MSG_RegLim','Se han generado mas de 5000 registros para este reporte.')>
	<cf_errorCode	code = "50196" msg = "#MSG_RegLim#">
	<cfabort>
</cfif>

<!--- Busca la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
	<cfset vparams ="">
	<cfif isdefined("form.SNCEID1") and len(trim(form.SNCEID1))>
		<cfset vparams = vparams & "&SNCEID1=" & trim(form.SNCEID1)>
	</cfif>
	<cfif isdefined("form.SNCEID2") and len(trim(form.SNCEID2))>
		<cfset vparams = vparams & "&SNCEID2=" & trim(form.SNCEID2)>
	</cfif>
	<cfif isdefined("form.SNnumero") and len(trim(form.SNnumero))>
		<cfset vparams = vparams & "&SNnumero=" & form.SNnumero>
	</cfif>
	<cfif isdefined("form.SNnumerob2") and len(trim(form.SNnumerob2))>
		<cfset vparams = vparams & "&SNnumerob2=" & form.SNnumerob2>
	</cfif>
	<cfif isdefined('form.SC')>
		<cfset vparams = vparams & "&SC=" & form.SC>
	</cfif>
	<cfif isdefined('form.SP')>
		<cfset vparams = vparams & "&SP=" & form.SP>
	</cfif>
	<cfif isdefined('form.SA')>
		<cfset vparams = vparams & "&SA=" & form.SA>
	</cfif>
	<cfif isdefined('form.TClasif')>
		<cfset vparams = vparams & "&TClasif=" & form.TClasif>
	</cfif>
	<cfif isdefined('form.Empresa')>
		<cfset vparams = vparams & "&Empresa=" & form.Empresa>
	</cfif>
	<cfif isdefined('form.Cobrador')>
		<cfset vparams = vparams & "&Cobrador=" & form.Cobrador>
	</cfif>
	<cfif isdefined('form.DEidCobrador')>
		<cfset vparams = vparams & "&DEidCobrador=" & form.DEidCobrador>
	</cfif>
	
	<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<!--- Encabezado --->
		<cfif not isdefined("url.imprimir")>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cf_rhimprime datos="/sif/cc/reportes/SociosSinClasificarResCC.cfm" paramsuri="#vparams#"  regresar="/cfmx/sif/cc/reportes/SociosSinClasificar.cfm">
					</td>	
				</tr>
			</table>
		</cfif>
        
        
<cfset TIT_SocsClasGral	= t.Translate('TIT_SocsClasGral','Socios sin Clasificaci&oacute;n General')>
<cfset TIT_DirSocsClas	= t.Translate('TIT_DirSocsClas','Direcci&oacute;n de Socios sin Clasificaci&oacute;n')>
<cfset LB_Todos 		= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Cobrador 		= t.Translate('LB_Cobrador','Cobrador')>
<cfset LB_Clasif 		= t.Translate('LB_Clasif','Clasificaci&oacute;n')>
<cfset LB_Obligatorio 	= t.Translate('LB_Obligatorio','Obligatorio')>
<cfset LB_NoObligatorio = t.Translate('LB_NoObligatorio','No Obligatorio')>
<cfset MSG_Codigo 		= t.Translate('MSG_Codigo','Código','/sif/generales.xml')>
<cfset LB_Direccion 	= t.Translate('LB_Direccion','Direcci&oacute;n','/sif/generales.xml')>
<cfset LB_Nombre 		= t.Translate('LB_Nombre','Nombre','/sif/generales.xml')>
<cfset LB_Socio 		= t.Translate('LB_Socio','Socio')>
<cfset LB_RegTotal 		= t.Translate('LB_RegTotal','Registros en total')>
        
		<table cellpadding="0" cellspacing="0" border="0" width="90%" align="center">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<cfoutput>
				<td><font size="4"><strong>#rsEmpresa.Edescripcion#</strong></font></td>
				<td align="right"><font size="2">#LSDateFormat(Now(),'dd/mm/yyyy')#</font></td>
				</cfoutput>
			</tr>
			<tr>
				<cfoutput>
				<td>
					<font size="3 ">
						<strong>
						<cfif isdefined('form.TClasif') and form.TClasif EQ 0>
							#TIT_SocsClasGral#
						<cfelse>
							#TIT_DirSocsClas#
						</cfif>
						</strong>
					</font>
				</td>
				</cfoutput>
			</tr>
		</table>
	<cfset totalRegistros = rsReporte.RecordCount>
		<table cellpadding="0" cellspacing="0" border="0" width="90%" align="center">
			<cfoutput>
			<tr>
				<cfif isdefined("form.Cobrador") and len(trim(form.Cobrador)) eq 0>
					<cfset form.Cobrador = '#LB_Todos#'>
				</cfif>
				<td><strong>#LB_Cobrador#:</strong>&nbsp;<cfoutput>#form.Cobrador#</cfoutput></td>
			</tr>
            </cfoutput>
			<tr>
				<td>
					<cfoutput>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<cfif rsReporte.RecordCount GT 0>
							<cfset clasificacion = ''>
							<cfset ClasAnterior = ''>
							<cfloop query="rsReporte">
								<cfif clasificacion NEQ SNCEcodigo>
									<tr><td colspan="5">&nbsp;</td></tr>
									<tr bgcolor="EFEFEF">
										<td colspan="5" align="left">
											<span style="font-size:12px;">
												<strong>#LB_Clasif#:&nbsp;#SNCEcodigo# - #SNCEdescripcion# (#iif(PCCEobligatorio,DE('#LB_Obligatorio#'),DE('#LB_NoObligatorio#'))#)</strong>
											</span>
										</td>
									</tr>
									<tr class="subTitulo" bgcolor="E2E2E2"> 
										<td ><strong>&nbsp;#MSG_Codigo#</strong></td>
										<td >
											<cfif isdefined('form.TClasif') and form.TClasif EQ 1>
												<strong>#LB_Direccion#</strong>
											<cfelse>
											<strong>#LB_Nombre#</strong></td>
											</cfif>
										<cfif isdefined('form.TClasif') and form.TClasif EQ 1>
										<td><strong>#LB_Socio#</strong></td>
										</cfif>
									</tr>
									<cfset clasificacion = SNCEcodigo>
									<cfset ClasAnterior = SNCEdescripcion>
								</cfif>
								<tr <cfif rsReporte.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
									<td>&nbsp;&nbsp;
										#Numero#
									</td>
									<td nowrap>#Nombre#</td>
									<cfif isdefined('form.TClasif') and form.TClasif EQ 1>
									<td>#NumSoc# - #Socio#</td>
									</cfif>
								</tr>
								<cfif isdefined("url.imprimir")>
									<cfif rsReporte.RecordCount mod 35 EQ 1>??
										<cfif rsReporte.RecordCount NEQ 1>
											<tr class="pageEnd"><td colspan="7">&nbsp;</td></tr>
											<tr class="subTitulo"> 
												<td><strong>#MSG_Codigo#</strong></td>
												<td >
													<cfif isdefined('form.TClasif') and form.TClasif EQ 1>
														<strong>#LB_Direccion#</strong>
													<cfelse>
													<strong>#LB_Nombre#</strong></td>
													</cfif>
												<cfif isdefined('form.TClasif') and form.TClasif EQ 1>
												<td><strong>#LB_Socio#</strong></td>
												</cfif>
												
											</tr>
										</cfif>
									</cfif>	
								</cfif>
							</cfloop>
							<tr><td>&nbsp;</td></tr>
						<tr><td><strong><font size="2">#LB_RegTotal#: #totalRegistros#</font></strong></td></tr>
						<table width="100%" align="center">
							<cfif isdefined("url.imprimir")>
								<cfset MSG_FinRep = t.Translate('MSG_FinRep','Fin del Reporte')>
								<tr><td><h6>&nbsp;</h6></td></tr>
								<tr align="center"><td> --------------------------- #MSG_FinRep# --------------------------- </td></tr>
							</cfif>
						</table>
						<cfelse>
							<cfset MSG_NoDatRel = t.Translate('MSG_NoDatRel','No hay datos relacionados')>
							<tr align="center"><td> --------------------------- #MSG_NoDatRel# --------------------------- </td></tr>
						</cfif>
						<tr><td colspan="4">&nbsp;</td></tr>
					</table>
				</td>
			</tr>
			
		</table>
	</cfoutput>

