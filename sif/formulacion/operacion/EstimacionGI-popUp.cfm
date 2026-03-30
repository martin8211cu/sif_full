<cfparam name="url.FPE" default="false"><!---  Formulación de Presupuesto Extraordinario --->
<cfparam name="url.RolAdmin" default="false">
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}" returnvariable="CPPfechaDesde">
<cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}" returnvariable="CPPfechaHasta">
<cfif isdefined('form.bntGuardar')>
	<cfparam name="form.individual" default="false">
	<cfquery name="Periodo" datasource="#session.dsn#">
		select CPPid, case a.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				#_Cat# ' de ' #_Cat# 
			case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaDesde)#
				#_Cat# ' a ' #_Cat# 
			case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaHasta)#
			as Pdescripcion
		from CPresupuestoPeriodo a
		where Ecodigo = #Session.Ecodigo#
		and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">	
		order by CPPanoMesDesde,CPPfechaDesde,CPPfechaHasta
	</cfquery>
	<cfif form.FPE>
		<cfquery name="presupuestosOrdinarioFinalizado" datasource="#session.dsn#">
			select count(1) as existe
				from FPEEstimacion a
					inner join TipoVariacionPres TV 
						on TV.FPTVid = a.FPTVid
			where a.Ecodigo = #Session.Ecodigo#
				and TV.FPTVTipo = -1 
				and a.FPEEestado in (6)
				and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		</cfquery>
		<cfif presupuestosOrdinarioFinalizado.existe eq 0>
			<script type="text/javascript">
				alert('El Periódo <cfoutput>#Periodo.Pdescripcion#</cfoutput> no ha finalizado su periódo ordinario. Una vez finalizado este proceso podrá continuar con las variaciones o periódos extraordinarios.');
				window.opener.location.reload();
				window.close();
			</script>
			<cfreturn>
		</cfif>
	</cfif>
	<cfquery name="existePeriodoPresupuestos" datasource="#session.dsn#">
		select count(1) as existe
			from FPEEstimacion a
				inner join TipoVariacionPres b 
					on b.FPTVid = a.FPTVid
		where a.Ecodigo = #Session.Ecodigo#
			and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
			<cfif form.individual eq 'on' and isdefined('form.CFid') and len(trim(form.CFid))>
				and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			</cfif>
			<cfif form.FPE>
				and FPEEestado in (0,1,2,3,4,5)
			<cfelse>
				and b.FPTVTipo = -1 
				and not FPEEestado in (0,1,2,3,4,5)
			</cfif>
	</cfquery>
	<cfif form.FPE and form.RolAdmin and form.individual eq 'on' and isdefined('form.CFid') and len(trim(form.CFid))>
		<cfif isdefined('form.FPTVid')>
			<cfquery name="rsExistenVariaciones" datasource="#session.dsn#">
				select count(1) as existe
					from FPEEstimacion a 
						inner join TipoVariacionPres b 
							on b.FPTVid = a.FPTVid
				where a.Ecodigo = #Session.Ecodigo#
					and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
					and FPEEestado in (0,1,2,3,4,5)
					and b.FPTVTipo <> -1
					and b.FPTVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPTVid#">
			</cfquery>
			<cfif rsExistenVariaciones.existe eq 0>
				<cfquery name="rsExistenVariaciones" datasource="#session.dsn#">
					select count(1) as existe
						from FPEEstimacion a 
							inner join TipoVariacionPres b 
								on b.FPTVid = a.FPTVid
					where a.Ecodigo = #Session.Ecodigo#
						and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
						and FPEEestado in (0,1,2,3,4,5)
						and b.FPTVTipo <> -1
						and b.FPTVid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPTVid#">
				</cfquery>
				<cfif rsExistenVariaciones.existe gt 0>
					<cfset msg = 'EL tipo de variación debe de concidir con las variaciones actuales.'>
					<script type="text/javascript">
						alert('<cfoutput>#msg#</cfoutput>');
						window.close();
					</script>
					<cfreturn>
				</cfif>
			</cfif>
			<cfquery name="existePeriodoPresupuestos" datasource="#session.dsn#">
				select count(1) as existe
					from FPEEstimacion a 
						inner join TipoVariacionPres b 
							on b.FPTVid = a.FPTVid
				where a.Ecodigo = #Session.Ecodigo#
					and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
					<cfif form.individual eq 'on' and isdefined('form.CFid') and len(trim(form.CFid))>
					and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
					</cfif>
					and FPEEestado in (0,1,2,3,4,5)
					and b.FPTVTipo <> -1
					and b.FPTVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPTVid#">
			</cfquery>
		<cfelse>
			<cfquery name="existePeriodoPresupuestos" datasource="#session.dsn#">
				select count(1) as existe
					from FPEEstimacion a 
						inner join TipoVariacionPres b 
							on b.FPTVid = a.FPTVid
				where a.Ecodigo = #Session.Ecodigo#
					and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
					<cfif form.individual eq 'on' and isdefined('form.CFid') and len(trim(form.CFid))>
					and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
					</cfif>
					and FPEEestado in (0,1,2,3,4,5)
					and b.FPTVTipo <> -1
			</cfquery>
		</cfif>
	</cfif>
	<cfif existePeriodoPresupuestos.existe gt 0>
		<script type="text/javascript">
			<cfif form.FPE and form.RolAdmin>
				<cfset msg = 'El Periódo #Periodo.Pdescripcion# ya posee un Variaciones en proceso, hasta que este sea aprobado podra crear un nuevo Periódo Extraordinario.\nSi desea crearlo para un centro funcional en especifico con el Periódo Extraordinario actual deberá generarlo de forma individual.'>
			<cfelseif form.FPE>
				<cfset msg = 'El Periódo #Periodo.Pdescripcion# posee variaciones en estado no aprobadas, hasta que estas sean aprobadas no podra crear una nueva variación.'>
			<cfelseif not form.FPE and form.individual eq 'on'>
				<cfquery name="CFuncional" datasource="#session.dsn#">
					select CFid, CFcodigo #_Cat# ' - ' #_Cat# CFdescripcion as CF
						from CFuncional
					where Ecodigo = #Session.Ecodigo#
					and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
					order by CFcodigo, CFdescripcion
				</cfquery>
				<cfset msg = 'El Periódo #Periodo.Pdescripcion# ya contiene el Centro Funcional: #CFuncional.CF#.'>
			<cfelse>
				<cfset msg = 'El Periódo #Periodo.Pdescripcion# ya posee datos que se estan procesando, debe de incluir de forma individual el centro funcional.'>
			</cfif>
			alert('<cfoutput>#msg#</cfoutput>');
			window.close();
		</script>
		<cfreturn>
	</cfif>
	<cfset FPRES_EstimacionGI = createobject("component","sif.Componentes.FPRES_EstimacionGI")>	
	<cfquery name="rsCentrosFuncionales" datasource="#session.dsn#">
		select a.Usucodigo,c.CFcodigo, CFid as id, CFdescripcion, coalesce(Pemail1, Pemail2) as email, Pnombre #_Cat# ' ' #_Cat# Papellido1 #_Cat# ' ' #_Cat# Papellido2 as nombre, Psexo
			from Usuario a
            right outer join DatosPersonales b
            	on a.datos_personales = b.datos_personales
            right outer join CFuncional c
                on c.CFuresponsable = a.Usucodigo
		where Ecodigo = #Session.Ecodigo#
		<cfif form.individual eq 'on' and isdefined('form.CFid') and len(trim(form.CFid))>
			and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		</cfif>
		<cfif form.FPE and form.individual eq 'false'>
			and exists(
				select 1
				from PCGDplanCompras pcgd
					inner join PCGplanCompras pcge
						on pcge.PCGEid = pcgd.PCGEid
				where pcgd.CFid = c.CFid
				and pcge.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
			)
		</cfif>
			and rtrim(c.CFcodigo) <> 'RAIZ'
		order by a.datos_personales
	</cfquery>
	<cfset cfs = ''>
	<cfset usu = -1>
	<cfset nombreEnvio = ''>
	<cfset emailEnvio = ''>
	<cfset versionEnvio = ''>
	<cfset sexoEnvio = ''>
	<cfset Tipo = "Presupuesto Ordinario">
	<cfif form.FPE and not form.RolAdmin>
		<cfset form.fecha = "No Posee fecha limite">
	</cfif>
	<cfif form.FPE>
		<cfquery name="Variaciones" datasource="#session.dsn#">
			select FPTVTipo, FPTVDescripcion 
				from TipoVariacionPres
			where FPTVid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPTVid#">
			  and Ecodigo = #Session.Ecodigo#
			  and FPTVTipo <> -1
			  and FPTVTipo <> 4
			order by FPTVid desc, FPTVCodigo, FPTVDescripcion
		</cfquery>
		<cfset Tipo = Variaciones.FPTVDescripcion>
	</cfif>
	<cfloop query="rsCentrosFuncionales">
		<cfif form.FPE>
			<cfquery name="ultimaEstimacion" datasource="#session.dsn#">
				select FPEEid, FPEEVersion 
				from FPEEstimacion a
				where a.Ecodigo = #Session.Ecodigo# 
				   and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#"> 
				   and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
				   and a.FPEEVersion= (select max(coalesce(b.FPEEVersion,0))
									 from FPEEstimacion b 
								  where  b.Ecodigo = a.Ecodigo  
								   and b.CFid = a.CFid 
								and b.CPPid = a.CPPid )
			</cfquery>
		</cfif>
		<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="AltaEncabezadoEstimacion">
			<cfinvokeargument name="CFid" 	    		value="#id#">
			<cfinvokeargument name="CPPid"  			value="#form.CPPid#">
			<cfif not (form.FPE and not form.RolAdmin) and isdefined('form.fecha') and len(trim(form.fecha))>
			<cfinvokeargument name="FPEEFechaLimite" 	value="#LSparsedatetime(form.fecha)#">
			</cfif>
			<cfinvokeargument name="FPEEestado" 	    value="0">
			<cfif isdefined('form.FPTVid') and len(trim(form.FPTVid))>
				<cfinvokeargument name="FPTVid" 	    	value="#form.FPTVid#">
			</cfif>
		</cfinvoke>
		<cfset hora=now()>
		<cfset remitente = "gestion@soin.co.cr">
		<cfif usu neq -1>
			<cfif Usucodigo eq usu>
				<cfset cfs &= '<tr><td align="center"><strong>#CFdescripcion#</strong></td><td align="center"><strong>#form.fecha#</strong></td></tr>'>
			<cfelse>
				<cfset texto = '<table border="0" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
				<tr bgcolor="##999999"><td colspan="2" height="8"></td></tr>
				<tr bgcolor="##003399"><td colspan="2" height="24"></td></tr>
				<tr bgcolor="##999999"><td colspan="2"> <strong>Información sobre Estimación de Fuentes de Financiamiento y Egresos(#Tipo#) en #session.Enombre# </strong> </td></tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr><td colspan="2">
				<strong>#sexoEnvio##nombreEnvio#,</strong></p></td></tr>
					<tr><td colspan="2"><p align="justify">Este correo a sido enviado para informale del inicio de la apertura para  la Estimación de Fuentes de Financiamiento y Egresos con el Peri&oacute;do Presupuestario <strong>#periodoEnvio#</strong> y para el Centro Funcional:</p>
						<p align="justify"><table border="1" width="100%"><tr align="center" bgcolor="##99CC33"><td><strong>Centro Funcional</strong></td><td><strong>Fecha Lim&iacute;te</strong></td></tr>
								#cfs#
						</table></p>
						<p align="justify">Se le indica que la fecha l&iacute;mite para realizar este proceso y enviarlo a su respectivo encargado ser&aacute; el <strong>#form.fecha#</strong>, si por alguna raz&oacute;n no podr&aacute; enviar la formulaci&oacute;n a m&aacute;s tardar de la fecha limite deber&aacute; de informar al admistrador del presupuesto sobre su situaci&oacute;n.</p>
						<p align="justify">Pasada la fecha limit&eacute; sera imposible enviar la formulaci&oacute;n para su respectivo centro funcional.</p>
						<p align="justify"><strong>* No responder a este correo.<br><strong>* Si este correo a llegado por equivocaci&oacute;n le solicitamos   eliminarlo.</strong></strong></p>
						</td>
					</tr>
				</table>'>
				<cfif len(trim(emailEnvio))>
					<cfset FPRES_EstimacionGI.InsertarEmail(remitente,emailEnvio,'Apertura de Formulación Presupuestal: #periodoEnvio#',texto)>
				</cfif>
				<cfset cfs = '<tr><td align="center"><strong>#CFdescripcion#</strong></td><td align="center"><strong>'>
				<cfif (isdefined('form.fecha') and len(trim(form.fecha)))>
					<cfset cfs &= '#form.fecha#</strong></td></tr>'>
				<cfelse>
					<cfset cfs &= '</strong></td></tr>'>
				</cfif>
			</cfif>
		<cfelse>
			<cfset cfs = '<tr><td align="center"><strong>#CFdescripcion#</strong></td><td align="center"><strong>#form.fecha#</strong></td></tr>'>
		</cfif>
		<cfset usu = Usucodigo>
		<cfset nombreEnvio = nombre>
		<cfif len(trim(email))>
			<cfset emailEnvio = email>
		</cfif>
		<cfset periodoEnvio = '#Periodo.Pdescripcion#'>
		<cfif len(trim(Psexo)) and Psexo eq 'F'>
			<cfset sexoEnvio = 'Srta. '>
		<cfelse>
			<cfset sexoEnvio = 'Sr. '>
		</cfif>
		<cfif rsCentrosFuncionales.currentRow eq rsCentrosFuncionales.RecordCount>
			<cfset texto = '<table border="0" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
			<tr bgcolor="##999999"><td colspan="2" height="8"></td></tr>
			<tr bgcolor="##003399"><td colspan="2" height="24"></td></tr>
			<tr bgcolor="##999999"><td colspan="2"> <strong>Información sobre Estimación de Fuentes de Financiamiento y Egresos(#Tipo#) en #session.Enombre# </strong> </td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2">
			<strong>#sexoEnvio##nombreEnvio#,</strong></p></td></tr>
				<tr><td colspan="2"><p align="justify">Este correo a sido enviado para informale del inicio de la apertura para  la Estimación de Fuentes de Financiamiento y Egresos con el Peri&oacute;do Presupuestario <strong>#periodoEnvio#</strong> y para el Centro Funcional:</p>
					<p align="justify"><table border="1" width="100%"><tr align="center" bgcolor="##99CC33"><td><strong>Centro Funcional</strong></td><td><strong>Fecha Lim&iacute;te</strong></td></tr>
							#cfs#
					</table></p>
					<p align="justify">Se le indica que la fecha l&iacute;mite para realizar este proceso y enviarlo a su respectivo encargado ser&aacute; el '>
					<cfif (isdefined('form.fecha') and len(trim(form.fecha)))>
						<cfset texto &= '<strong>#form.fecha#</strong>'>
					<cfelse>
						<cfset texto &= '<strong>NO TIENE FECHA LIMITE</strong>'>
					</cfif>
					<cfset texto &= ', si por alguna raz&oacute;n no podr&aacute; enviar la formulaci&oacute;n a m&aacute;s tardar de la fecha limite deber&aacute; de informar al admistrador del presupuesto sobre su situaci&oacute;n.</p>
					<p align="justify">Pasada la fecha limit&eacute; sera imposible enviar la formulaci&oacute;n para su respectivo centro funcional.</p>
					<p align="justify"><strong>* No responder a este correo.<br><strong>* Si este correo a llegado por equivocaci&oacute;n le solicitamos   eliminarlo.</strong></strong></p>
					</td>
				</tr>
			</table>'>
			<cfif len(trim(emailEnvio))>
				<cfset asunto = 'Apertura de Formulación Presupuestal(#Tipo#): #periodoEnvio#'>
				<cfset FPRES_EstimacionGI.InsertarEmail(remitente,emailEnvio,asunto,texto)>
			</cfif>
		</cfif>
	</cfloop>
	<script type="text/javascript">
		window.opener.location.reload();
		window.close();
	</script>
</cfif>
<cfset filtroCF = ''>
<cfif url.FPE and not url.RolAdmin>
	<cfset path = fnGetPath()>
	<cfif len(trim(path)) gt 0>
		<cfset path = mid(path,1,len(path)-1)>
		<cfloop list="#path#" index="i">
			<cfset filtroCF &= "#i#,">
		</cfloop>
		<cfset filtroCF = 'and CFid in(' & mid(filtroCF,1,len(filtroCF)-1) & ')'>
	<cfelse>
		<cfset filtroCF = 'and 0 != 0'>
	</cfif>
</cfif>
<cfif url.FPE>
	<cfset filtro = "">
	<cfset msg = "No hay ningun Periódo Presupuestario Extraordinario Disponible">
<cfelse>
	<cfset filtro = "and (select count(1) from FPEEstimacion b where b.Ecodigo = a.Ecodigo and b.CPPid  = a.CPPid) <= 0">
	<cfset msg = "No hay ninguna Versión de Formulación de Presupuesto Disponible">
</cfif>
<cfquery name="Periodos" datasource="#session.dsn#">
	select a.CPPid, case a.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
			#_Cat# ' de ' #_Cat# 
		case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
			#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaDesde)#
			#_Cat# ' a ' #_Cat# 
		case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
			#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaHasta)#
		as Pdescripcion
	from CPresupuestoPeriodo a
	where a.Ecodigo = #Session.Ecodigo#
		<cfif url.FPE>
		and a.CPPestado = 1
		<cfelse>
		and a.CPPestado = 0
		</cfif>
	order by a.CPPanoMesDesde,a.CPPfechaDesde,a.CPPfechaHasta
</cfquery>
<cfif Periodos.recordcount EQ 0>
	<script type="text/javascript">
		alert('No existen Periódos Presupuestarios vigentes');
		window.close();
	</script>
<cfelse>
	<cfif not url.FPE>
		<cfquery name="Variaciones" datasource="#session.dsn#">
			select FPTVid
				from TipoVariacionPres
			where FPTVTipo = - 1
			  and Ecodigo = #Session.Ecodigo#
			order by FPTVid desc, FPTVCodigo, FPTVDescripcion
		</cfquery>
		<cfif Variaciones.recordcount eq 0>
			<script type="text/javascript">
				alert('No existe un tipo "Presupuesto Ordinario" en "Tipos de Variaciones Presupuestales", para proceder con este proceso debe de ingresarlo en el catálogo.');
				window.close();
			</script>
		</cfif>
	</cfif>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Nueva Estimación de Fuentes de Financiamiento y Egresos">
		<cf_templatecss>
		<cfoutput>
			<form action="EstimacionGI-popUp.cfm" method="post" name="form1">
				<input name="FPE" type="hidden" value="#url.FPE#"/>
				<input name="RolAdmin" type="hidden" value="#url.RolAdmin#"/>
				<table border="0" width="100%" align="center">
					<tr align="center">
						<td>
							
							<strong>Peri&oacute;dos Presupuestarios<cfif url.FPE> Extraordinario</cfif>:</strong>
						</td>
					</tr>
					<tr align="center">
						<td>
							<select name="CPPid">
							  <cfloop query="Periodos">
								  <option value="#Periodos.CPPid#">#Periodos.Pdescripcion#</option>
							  </cfloop>
							</select>
						</td>
					</tr>
					<cfquery name="CFuncionales" datasource="#session.dsn#">
						select CFid, CFcodigo #_Cat# ' - ' #_Cat# CFdescripcion as CF
							from CFuncional
						where Ecodigo = #Session.Ecodigo#
							and rtrim(CFcodigo) <> 'RAIZ'
						<cfif (url.FPE and not url.RolAdmin) or ( not url.FPE and url.RolAdmin)>
							#filtroCF#
						</cfif>
						order by CFcodigo, CFdescripcion
					</cfquery>
					<cfif url.FPE>
						<cfquery name="Variaciones" datasource="#session.dsn#">
							select FPTVid, FPTVCodigo, FPTVDescripcion , FPTVTipo
								from TipoVariacionPres
							where FPTVTipo <cfif url.RolAdmin> in(0,4)<cfelse> in(1,2,3)</cfif>
							  and Ecodigo = #Session.Ecodigo#
							order by FPTVid desc, FPTVCodigo, FPTVDescripcion
						</cfquery>
						<cfif not url.RolAdmin>
							<tr align="center">
								<td>
									<strong>Centros Funcionales asignados:</strong>
								</td>
							</tr>
							<tr align="center">
								<td>
									<select name="CFid">
									  <cfloop query="CFuncionales">
										  <option value="#CFid#">#CF#</option>
									  </cfloop>
									</select>
									<input name="individual" value="on" type="hidden"/>
								</td>
							</tr>
						</cfif>
						<tr align="center">
							<td>
								<strong>Tipos de Variaciones Presupuestables:</strong>
							</td>
						</tr>
						<tr align="center">
							<td>
								<select name="FPTVid" <cfif url.FPE and url.RolAdmin>onchange="fnOcultarFecha(this.value);"</cfif>>
								  <cfloop query="Variaciones">
									  <option value="#Variaciones.FPTVid#">#Variaciones.FPTVDescripcion#</option>
								  </cfloop>
								</select>
							</td>
						</tr>
					<!---<cfelse>
						<input name="FPTVid" type="hidden" value="#Variaciones.FPTVid#">--->
					</cfif>
					<cfif (url.FPE and url.RolAdmin) or (not url.FPE and  url.RolAdmin) >
					<tr align="center" id="trFecha">
						<td colspan="2">Fecha l&iacute;mite:&nbsp;<cf_sifcalendario name="fecha">
							
						</td>
					</tr>
					</cfif>
					<cfif (not url.FPE and not url.RolAdmin) or (url.FPE and url.RolAdmin)>
						<tr align="center">
							<td colspan="2" nowrap>
								<input name="individual" id="individual" type="checkbox" onchange="mostrarCFs(this.form)"/><strong>Agregar Centro Funcional Individual</strong>
							</td>
						</tr>
						<tr id="centrosF" align="center" style="display:none">
							<td colspan="2">
								<select name="CFid">
								 <option value="">-- Selecione C. Funcional --</option>
								  <cfloop query="CFuncionales">
									  <option value="#CFid#">#CF#</option>
								  </cfloop>
								</select>
							</td>
						</tr>
					</cfif>
					<tr align="center">
						<td>
							<input type="submit" name="bntGuardar" value="Agregar Nueva Estimación" class="btnGuardar" />
						</td>
					</tr>
				</table>
			</form>
		<cf_qforms>
			<cfif (url.FPE and url.RolAdmin) or (not url.FPE and  url.RolAdmin) >
				<cf_qformsRequiredField name="fecha" 	description="Fecha Límite">
			</cfif>
			<cfif url.FPE>
				<cfif url.RolAdmin>
					<cf_qformsRequiredField name="CPPid" 	description="Periódo">
				</cfif>
				<cf_qformsRequiredField name="FPTVid" 		description="Variación">
			<cfelse>
				<cf_qformsRequiredField name="CPPid" 		description="Periódo">
			</cfif>
			<cfif (not url.FPE and not url.RolAdmin) or (url.FPE and url.RolAdmin)>
				<cf_qformsRequiredField name="CFid" 	description="CF Individual">
			</cfif>
		</cf_qforms>
		<cfif url.FPE and url.RolAdmin>
		<script type="text/javascript" language="javascript" src="/cfmx/sif/js/Macromedia/wddx.js"></script>
		</cfif>
		<script language="javascript1.2" type="text/javascript">
		<cfwddx action="cfml2js" input="#Variaciones#" topLevelVariable="Variaciones">
		<cfif (not url.FPE and not url.RolAdmin) or (url.FPE and url.RolAdmin)>
				objForm.CFid.required = false;
				function mostrarCFs(form){
					if(form.individual.checked){
						document.getElementById('centrosF').style.display = "block";
						objForm.CFid.required = true;
					}else{
						document.getElementById('centrosF').style.display = "none";
						objForm.CFid.required = false;
					}
				}
		</cfif>
		<cfif url.FPE and url.RolAdmin>
		function fnOcultarFecha(id){
			document.getElementById('trFecha').style.display = "block";
			objForm.fecha.required = true;
			var nRows = Variaciones.getRowCount();
			if(nRows > 0){
				for(row = 0; row < nRows; ++row){
					if (Variaciones.getField(row, "FPTVid") == id && Variaciones.getField(row, "FPTVTipo") == 4){
						document.getElementById('trFecha').style.display = "none";
						objForm.fecha.required = false;
						break;				
					}
				}
			}
		}
		fnOcultarFecha(document.form1.FPTVid.value);
		</cfif>
		</script>
		</cfoutput>
	<cf_web_portlet_end>	
</cfif>

<cffunction name="fnGetHijos" returntype="string" access="private">
  	<cfargument name='idPadre'		type='numeric' 	required='yes'>
	<cfargument name="Conexion" 	type="string"   required="no">
	<cfargument name="Ecodigo" 		type="numeric"  required="no">
	
	<cfif not isdefined('Arguments.Conexion')>
		<cfset Arguments.Conexion = "#session.dsn#">
	</cfif> 
	<cfif not isdefined('Arguments.Ecodigo')>
		<cfset Arguments.Ecodigo = "#session.Ecodigo#">
	</cfif> 

	<cfparam name="path" default="">		
   	<cfquery datasource="#Arguments.Conexion#" name="rsSQL">
		select 
		c.CFid, 
		c.CFnivel as nivel,  
		(
			select count(1) from CFuncional c2
			where c2.CFidresp = c.CFid
			and c2.Ecodigo = c.Ecodigo
		) as  hijos
		from CFuncional c
		where c.Ecodigo = #Arguments.Ecodigo#
		  and c.CFidresp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idPadre#">
		order by c.CFpath
	</cfquery>
	<cfloop query="rsSQL">
		<cfset path &= CFid & ','>
		<cfif hijos>
			<cfset fnHijos = fnGetHijos(CFid,Arguments.Conexion,Arguments.Ecodigo)>
		</cfif>
	</cfloop>
	<cfreturn path>
</cffunction>

<cffunction name="fnGetPath" 			returntype="string" access="private">
	<cfargument name="Conexion" 	    type="string"   	required="no">
	<cfargument name="Ecodigo" 		    type="numeric"  	required="no">
	<cfargument name="Usucodigo" 		type="numeric"  	required="no">
	
	<cfif not isdefined('Arguments.Conexion')>
		<cfset Arguments.Conexion = "#session.dsn#">
	</cfif> 
	<cfif not isdefined('Arguments.Ecodigo')>
		<cfset Arguments.Ecodigo = "#session.Ecodigo#">
	</cfif> 
	<cfif not isdefined('Arguments.Usucodigo')>
		<cfset Arguments.Usucodigo = "#session.Usucodigo#">
	</cfif>
	
	<cfparam name="path" default="">
	
	<cfquery name="ResponableCentrosFuncionales" datasource="#Arguments.Conexion#">
		select count(1) as responsable
			from CFuncional
		where CFuresponsable = #Arguments.Usucodigo#
		 and Ecodigo = #Arguments.Ecodigo#
	</cfquery>
	
	<cfif ResponableCentrosFuncionales.responsable gt 0>
		<cfquery name="CentrosFuncionalesResponsable" datasource="#Arguments.Conexion#">
			select CFid,
				(
					select count(1) from CFuncional c2
					where c2.CFidresp = c.CFid
					and c2.Ecodigo = c.Ecodigo
				) as  hijos
				from CFuncional c
			where c.CFuresponsable = #Arguments.Usucodigo#
			and c.Ecodigo = #Arguments.Ecodigo#
			union
			select b.CFid, 0 as hijos
			from FPSeguridadUsuario a
				inner join CFuncional b
					on b.CFid = a.CFid
			where a.Usucodigo = #Arguments.Usucodigo#
				and a.Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfloop query="CentrosFuncionalesResponsable">
			<cfset path &= CFid & ','>
			<cfif hijos>
				<cfset fnHijos = fnGetHijos(CFid,Arguments.Conexion,Arguments.Ecodigo)>
			</cfif>
		</cfloop>
	<cfelse>
		<cfquery name="CentrosFuncionalesAutorizados" datasource="#Arguments.Conexion#">
			 select b.CFid, b.CFcodigo, b.CFdescripcion
				from FPSeguridadUsuario a
					inner join CFuncional b
						on b.CFid = a.CFid
			where a.Usucodigo = #Arguments.Usucodigo#
			 and a.Ecodigo = #Arguments.Ecodigo#
			 order by CFcodigo,CFdescripcion
		</cfquery>
		<cfloop query="CentrosFuncionalesAutorizados">
			<cfset path &= CFid & ','>
		</cfloop>
	</cfif>
	<cfreturn path>
</cffunction>