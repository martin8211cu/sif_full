<cfset LvarConS = false>	
<cfset LvarDato = false>	
<cfset LvarImprimir = false>
<cfset Cons = ''>	

	<cfsetting requesttimeout="3600">
	<cfif not isdefined('form.AFRid') and isdefined('url.AFRid')>
		<cfset form.AFRid = url.AFRid>
	</cfif>
	
	<cfif not isdefined('form.DEid') and isdefined('url.DEid')>
		<cfset form.DEid = url.DEid>
	</cfif>
	
	<cfif not isdefined('form.DEidT') and isdefined('url.DEidT')>
		<cfset form.DEidT = url.DEidT>
	</cfif> 
	
	<cfif not isdefined('form.Aplaca') and isdefined('url.Aplaca')>
		<cfset form.Aplaca = url.Aplaca>
	</cfif> 
	
	<cfif not isdefined('form.AFTRid') and isdefined('url.AFTRid')>
		<cfset form.AFTRid = url.AFTRid>
	</cfif> 

<cfif isDefined("Form.Consecutivo") and len(Trim(Form.Consecutivo))>
	<cfset LvarConS = true>
	<script language="javascript" type="text/javascript">
	opener.document.location.reload();
	</script>
</cfif>

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
	 <cfif isdefined ('LvarConS') and  #LvarConS# eq 'true'>
		<cflock name="consecutivo" timeout="3" type="exclusive">
			<cfquery name="newLista" datasource="#session.dsn#">
				select coalesce(max(TConsecutivo),0)as Consecutivo
				from TransConsecutivo
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			
			<cfif newLista.Consecutivo neq ''>
				<cfset Cons = newLista.Consecutivo + 1>
			<cfelse>
				<cfset Cons = 1>
			</cfif>
			
			<cfquery name="VerificaDatoInsetado" datasource="#session.dsn#">
				select count(1) as cantidad
					from TransConsecutivo a 
					inner join AFTResponsables b
					on b.AFTRid = a.AFTRid
				where a.AFTRid = #form.AFTRid#
			</cfquery>

			<cfif #VerificaDatoInsetado.cantidad# eq 0>
				<cfquery name="insertConsecutivo" datasource="#session.dsn#">
					insert into TransConsecutivo 
					(
						TConsecutivo, 
						Ecodigo, 
						BMfecha, 
						BMUsucodigo,
						AFTRid
					)
					values
					(
						#Cons#,
						#session.Ecodigo#,
						#now()#,
						#session.Usucodigo#,
						#form.AFTRid#
					)
				</cfquery>
			</cfif>
		</cflock>	
	</cfif>
	
	<cfquery name="VerificaDato" datasource="#session.dsn#">
		select count(1) as cantidad
			from TransConsecutivo a 
			inner join AFTResponsables b
			on b.AFTRid = a.AFTRid
		where a.AFTRid = #form.AFTRid#
	</cfquery>

	<cfif VerificaDato.cantidad gt 0>
		<cfset LvarDato = 'true'>
		<cfset LvarImprimir = 'true'>
		<cfset LvarConS = 'false'>	
	<cfelse>
		<cfset LvarConS = 'true'>
		<cfset LvarDato = 'false'>
		<cfset LvarImprimir = 'false'>
	</cfif>	
	
 <cfif  #LvarImprimir# eq 'true'>
		 <cf_htmlreportsheaders
			  title="Transferencia de Activos " 
			  filename="Transferencia-Activos#session.Usulogin##LSDateFormat(now(),'yyyymmdd')#.xls" 
			  back="no"
			  Download="no"
			  irA="" >
	</cfif>
 
	<cfquery datasource="#session.DSN#" name="rsEmpresa">
		select 
			Edescripcion,ts_rversion,
			Ecodigo
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cf_dbfunction name="now" returnvariable="hoy">
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select 
			con.TConsecutivo,
			cat.ACcodigo,
			act.Aplaca,
			act.Adescripcion,
			cf.CFuresponsable,
			CFOri.CFdescripcion,
			CFOri.CFid,
			cf.CFid as centFun,
			aftr.DEid,
			act.Adescripcion as Descripcion,
			mar.AFMdescripcion as marca ,
			mod.AFMMdescripcion as modelo ,
			act.Aserie,
			CCORI.CRCCcodigo #_Cat# ' - ' #_Cat# CCORI.CRCCdescripcion  as CentroCustodia,
			empCC.DEidentificacion  #_Cat# ' - ' #_Cat# empCC.DEnombre #_Cat# ' ' #_Cat# empCC.DEapellido1 #_Cat# ' ' #_Cat# empCC.DEapellido2 as NombreCC,
			EMPORI.DEidentificacion  #_Cat# ' - ' #_Cat# EMPORI.DEnombre #_Cat# ' ' #_Cat# EMPORI.DEapellido1 #_Cat# ' ' #_Cat# EMPORI.DEapellido2 as CedOri
		from 
		AFTResponsables aftr
				inner join Usuario usu
					on usu.Usucodigo = aftr.BMUsucodigo	
				inner join AFResponsables afr
					on afr.AFRid = aftr.AFRid
					
				left outer join TransConsecutivo con
					on con.AFTRid = aftr.AFTRid
					
				left outer join DatosEmpleado EMPORI 
					on afr.DEid = EMPORI.DEid 
					
					and afr.Ecodigo = EMPORI.Ecodigo 
					
				inner join Activos act
					on act.Aid = afr.Aid
					
				inner join AClasificacion cl
					on cl.Ecodigo= act.Ecodigo
					and  cl.ACid = act.ACid
					and cl.ACcodigo  = act.ACcodigo
				
				inner join ACategoria cat
					on cat.Ecodigo = cl.Ecodigo
					and cat.ACcodigo = cl.ACcodigo					
					
				inner join AFMarcas mar
					on act.AFMid = mar.AFMid
					and act.Ecodigo = mar.Ecodigo
				inner join AFMModelos mod
					on  mod.AFMMid =act.AFMMid 
					and mod.Ecodigo = act.Ecodigo
				inner join CRCentroCustodia CCORI 
					on   CCORI.Ecodigo = afr.Ecodigo
					and CCORI.CRCCid = afr.CRCCid 
				inner join DatosEmpleado empCC 
					on CCORI.DEid = empCC.DEid 
				inner join CFuncional CFOri 
					on afr.Ecodigo = CFOri.Ecodigo 
					and afr.CFid =CFOri.CFid 
				inner join CFuncional cf
					on cf.CFid = afr.CFid
				inner join DatosEmpleado de
					on de.DEid = aftr.DEid
				left outer join CRTipoDocumento crtd
					on crtd.CRTDid = aftr.CRTDid
			where aftr.Usucodigo = #Session.Usucodigo# 
				and aftr.AFTRid = #form.AFTRid#
				and act.Aplaca = <cf_jdbcquery_param value="#form.Aplaca#" cfsqltype="cf_sql_varchar">
			order by aftr.AFTRfini
		</cfquery>
		
		<cfquery name="rsCategoria" datasource="#session.dsn#">
			select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 4200
		</cfquery>
		
	<cfquery name="rsEmpleado" datasource="#session.dsn#">
		select cf.CFid, cf.CFdescripcion,
			e.DEidentificacion #_Cat# ' - ' #_Cat#	e.DEnombre #_Cat# ' ' #_Cat# e.DEapellido1 #_Cat# ' ' #_Cat# e.DEapellido2 as nombre 
		from EmpleadoCFuncional eaf
		inner join DatosEmpleado e on e.DEid = eaf.DEid 
		inner join CFuncional cf on cf.CFid = eaf.CFid
		where eaf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and eaf.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.DEid#">
		and <cf_dbfunction name="today"> between ECFdesde and ECFhasta
	</cfquery>
	
	<cfif len(trim(rsEmpleado.CFid))>
		<cfset LvarCF = rsEmpleado.CFid>
		<cfset centro_funcional_actual = LvarCF>
	<cfelse>
		<cfset LvarCF = rsDatos.centFun>
		<cfset centro_funcional_actual = LvarCF>
	</cfif>
		
	<!--- Busca al Jefe de mi centro funcional--->
		<cfquery datasource="#session.dsn#" name="buscar_cf">
			select cf.Ecodigo, 
				case
					when cf.CFuresponsable is not null then
						coalesce(
							(
								select <cf_dbfunction name="to_number" args="b.llave">
								  from UsuarioReferencia b
								 where b.Usucodigo	= cf.CFuresponsable
									and b.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
									and b.STabla		= <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
							)
						,0)
					else
						coalesce(
									(
										select lt.DEid
										  from LineaTiempo lt
										 where lt.RHPid = cf.RHPid
											and <cf_dbfunction name="now"> between LTdesde and LThasta
									)
								,-1)
				end as DEid_jefe
			 from CFuncional cf
			where 
			cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#centro_funcional_actual#">
			  and cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
	<!---Busca el jefe en Datos Empleado--->	
		<cfquery name="rsConsultaJEFE" datasource="#session.dsn#">
			select 
			a.DEidentificacion #_Cat# ' - ' #_Cat#	 a.DEnombre #_Cat# ' ' #_Cat# a.DEapellido1 #_Cat# ' ' #_Cat# a.DEapellido2 as nombre
				from  DatosEmpleado a
			where a.DEid  = #buscar_cf.DEid_jefe#
		</cfquery>
		
		
	<!---persona que recibe el traslado--->
		<cfquery datasource="#session.dsn#" name="cf">
			select 
			d.Pnombre #_Cat# ' ' #_Cat# d.Papellido1 #_Cat# ' ' #_Cat# d.Papellido2 as nombre , cf.CFid
			from CFuncional cf
			inner join Usuario u 
				on u.Usucodigo = cf.CFuresponsable
			inner join DatosPersonales d
				on u.datos_personales = d.datos_personales
			where Ecodigo = #session.Ecodigo#
			<cfif isdefined('rsDatos.CFuresponsable') and len(trim(rsDatos.CFuresponsable))>
			and u.Usucodigo = #rsDatos.CFuresponsable#
			</cfif>
			and CFid = #rsDatos.centFun#
		</cfquery>
		
		<cfif cf.recordcount neq 0>
			<cfquery datasource="#session.dsn#" name="buscar_cfx">
				select cf.Ecodigo, 
					case
						when cf.CFuresponsable is not null then
							coalesce(
								(
									select <cf_dbfunction name="to_number" args="b.llave">
									  from UsuarioReferencia b
									 where b.Usucodigo	= cf.CFuresponsable
										and b.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
										and b.STabla		= <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
								)
							,0)
						else
							coalesce(
										(
											select lt.DEid
											  from LineaTiempo lt
											 where lt.RHPid = cf.RHPid
												and <cf_dbfunction name="now"> between LTdesde and LThasta
										)
									,-1)
					end as DEid_jefe
				 from CFuncional cf
				where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cf.CFid#">
				  and cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>

		
		<!---Busca el jefe en Datos Empleado--->	
			<cfquery name="rsConsultaJEFET" datasource="#session.dsn#">
				select 
				a.DEidentificacion #_Cat# ' - ' #_Cat#	 a.DEnombre #_Cat# ' ' #_Cat# a.DEapellido1 #_Cat# ' ' #_Cat# a.DEapellido2 as nombre
					from  DatosEmpleado a
				where a.DEid  = #buscar_cfx.DEid_jefe#
			</cfquery>	
		</cfif>
<title>
	Detalle del traslado de vales
</title>

<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
		<form name="form1" method="post" action="TraspasoActivosF.cfm">
		<table width="100%"  cellpadding="0" cellspacing="0" border="0">
			<tr align="right"> 
		 	<td>
			<cfoutput>
			<cfif LvarConS eq 'true'>
				<input type="submit" style=" font-size:11px" name="Consecutivo" value="Generar Consecutivo">
			</cfif>
				<cfif isdefined('url.AFTRid') and len(trim(url.AFTRid))>
					<input type="hidden" name="AFTRid" value="#url.AFTRid#">
				</cfif>
				<cfif isdefined('url.Aplaca') and len(trim(url.Aplaca))>
					<input type="hidden" name="Aplaca" value="#url.Aplaca#">
				</cfif>
			</cfoutput>
			</td>
		 </tr>

	<tr>
	
		<td>
		<cfoutput><fieldset style="background-color:##F3F4F8; border-top: none; border-left: 1px solid ##CCCCCC; border-right: 1px solid ##CCCCCC; border-bottom: 1px solid ##CCCCCC;"></cfoutput>
			<table width="100%"  cellpadding="2" cellspacing="2" border="0">
				<tr>
					<td colspan="2"align="center">&nbsp;</td>
				</tr>	
		
				<tr>
					<td width="14%">
					  <cfinvoke
							 component="sif.Componentes.DButils"
							 method="toTimeStamp"
							 returnvariable="tsurl" arTimeStamp="#rsEmpresa.ts_rversion#"> </cfinvoke>
							
				 	 <cfoutput><img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&amp;ts=#tsurl#" alt="logo" width="190" height="110" border="0" class="iconoEmpresa"/></cfoutput>
				  </td>
				</tr>
				
				<tr>
				   <td colspan="5" align="center"><font size="3"><strong>Form-0060-00-08-40.4.6</strong></font></td>   
			  	</tr>					
				
				<tr>
     			  <td colspan="5" align="center"><font size="3"><strong>TRASPASO Y/O DESCARGO DE BIENES - N° <cfoutput><cfif isdefined ('LvarConS') and  #LvarConS# eq 'true'>#rsDatos.TConsecutivo#</cfoutput></cfif></strong></font></tr>					
				</tr>
     			  
				<tr>
					<td align="center" colspan="5"><font size="4"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></font></td>
			  	</tr>					
  
				<tr>
					<td colspan="5" align="center"><font size="2"><strong>Fecha de la Transferencia:&nbsp;</strong><cfoutput>#LSDateFormat(now(),'dd/mm/yyyy')#</cfoutput>&nbsp;<strong>Hora:&nbsp;</strong><cfoutput>#TimeFormat(Now(),'medium')#</cfoutput></font></td>
			  </tr>		
				<tr>
					<td colspan="5" align="center"><font size="2"><strong>(Dirección Administrativa Financiera - Contabilidad)</strong></font></td>
			  </tr>	
				<tr>
					<td colspan="5" align="center"><font size="2"><strong>M&oacute;dulo: (Control de Responsables)</strong></font></td>
			  </tr>	
			  
			  <tr>
				 <!---  <td colspan="2"align="center">&nbsp;</td>--->
			  </tr>	
			  <tr>
				   <td colspan="2"align="center">&nbsp;</td>
			  </tr>	
			  <tr>
				 <td colspan="5" align="center">
			       <table width="200" border="0">
                     <tr>
                       <td nowrap="nowrap"><font size="2"><strong>Clase de Movimiento:</strong></font></td>
                       <td nowrap="nowrap"><font size="2"><strong>Traspaso: (           )</strong></font></td>
                       <td nowrap="nowrap"><font size="2"><strong>Descargo: (           )</strong></font></td>
                     </tr>   
                   </table>	
				   </td>		       
			  </tr>					
				
			  <tr>
				   <td height="30" colspan="2"align="center">&nbsp;</td>
			  </tr>	
					
					<cfoutput>		
				  <tr nowrap="nowrap"  align="center" class="tituloListas">
						<td height="12"   align="left"><font size="2"><strong>Placa</strong></font></td>
						<td width="55%"  align="left"><font size="2"><strong>Descripci&oacute;n</strong></font></td>
						<td width="18%"  align="left"><font size="2"><strong>Marca</strong></font></td>
						<td width="14%"  align="left"><font size="2"><strong>Modelo</strong></font></td>
						<td width="13%"  align="left"><font size="2"><strong>Serie</strong></font></td>
				  </tr>
					<tr>
						<!---<td colspan="2"align="center">&nbsp;</td>--->
					</tr>	
					</cfoutput>
					
    			<cfloop query="rsDatos">
					<cfoutput>
						<tr class="<cfif rsDatos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td align="left">&nbsp;#rsDatos.Aplaca#</td>
							<td align="left">&nbsp;#rsDatos.Descripcion#</td>	
							<td align="left">&nbsp;#rsDatos.marca#</td>
							<td align="left">&nbsp;#rsDatos.modelo#</td>	
							<td align="left">&nbsp;#rsDatos.Aserie#</td>	
						</tr>
					</cfoutput>
				</cfloop>
				</table>
			</fieldset>	
		</td>
	</tr>
	<tr>
		<td colspan="2"align="center">&nbsp;</td>
	</tr>		
	
	<tr>
		<td>
			<fieldset style="background-color:##F3F4F8; border-top: none; border-left: 1px solid ##CCCCCC; border-right: 1px solid ##CCCCCC; border-bottom: 1px solid ##CCCCCC; ">
				<legend align="center" style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">
				Origen: <cfoutput>#rsDatos.CFdescripcion#</cfoutput>
				</legend>				
				<table width="100%"  cellpadding="2" cellspacing="2" border="0">
					<tr>
						<td colspan="2"align="center">&nbsp;</td>
					</tr>
					<tr>
						<td align="right"><b>Encargado:__________________________________</b></td>
						<td align="right"><b>Jefe CF.Encargado:__________________________________</b></td>
					</tr>	
							
					<tr><cfoutput>
						<td align="right">#rsDatos.CedOri#</td>
						<cfif cf.recordcount neq 0><td align="right">#rsConsultaJEFET.nombre#</td></cfif>
					</tr></cfoutput>	
				</table>
			</fieldset>	
		</td>
	</tr>

	<tr>
		<td colspan="2"align="center">&nbsp;</td>
	</tr>							
					
	<tr>
		<td>
			<fieldset style="background-color:##F3F4F8; border-top: none; border-left: 1px solid ##CCCCCC; border-right: 1px solid ##CCCCCC; border-bottom: 1px solid ##CCCCCC; ">
				<legend align="center" style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">
				Destino: <cfoutput>#rsEmpleado.CFdescripcion#</cfoutput>
				</legend>
				<table width="100%"  cellpadding="2" cellspacing="2" border="0">
					<tr>
						<td colspan="2"align="center">&nbsp;</td>
					</tr>
					<tr>
						<td align="right"><b>Encargado:__________________________________</b></td>
						<td align="right"><b>Jefe CF.Encargado:__________________________________</b></td>
					</tr>	
							
					<tr><cfoutput>
						<td align="right">#rsEmpleado.nombre#</td>
						<td align="right">#rsConsultaJEFE.nombre#</td>
					</tr></cfoutput>	
				</table>
			</fieldset>	
		</td>
	</tr>	
	
	<tr>
		<td colspan="2"align="center">&nbsp;</td>
	</tr>							

	<tr>
		<td colspan="2"align="center">&nbsp;</td>
	</tr>							

	<tr>
		<td>
			<fieldset style="background-color:##F3F4F8; border-top: none; border-left: 1px solid ##CCCCCC; border-right: 1px solid ##CCCCCC; border-bottom: 1px solid ##CCCCCC; ">
				<legend align="center" style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">
				Centro Custodia: <cfoutput>#rsDatos.CentroCustodia#</cfoutput>
				</legend>
				<table width="100%"  cellpadding="2" cellspacing="2" border="0">
					<tr>
						<td colspan="2"align="center">&nbsp;</td>
					</tr>
					<tr>
						<td align="right"><b>Encargado:__________________________________</b></td>
						<td align="right"><b><cfif #rsDatos.ACcodigo# eq #rsCategoria.Pvalor#>Encargado de Informática:__________________________________</b></cfif></td>
					</tr>	
							
					<tr><cfoutput>
						<td align="right">#rsDatos.NombreCC#</td>
						<td align="right"></td>
					</tr></cfoutput>	
				</table>
			</fieldset>	
		</td>
	</tr>	
	
	<tr>
		<td colspan="2"align="center">&nbsp;</td>
	</tr>	
	
	<table width="100%"  cellpadding="2" cellspacing="2" border="0">
		<tr>
			<td align="left"><strong>Original: Contabilidad</strong></td>
			<td align="right"><strong>S e l l o:</strong></td>

		</tr>	
				
		<tr>
			<td align="left"><strong>Copias: Funcionario Solicitante</strong></td>
		</tr>		
	</table>
</table>
</form>


