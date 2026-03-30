<!---Primer periodo--->
	<cfquery name="rsParametros1" datasource="#session.DSN#">
		select Pvalor as p1
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 310
	</cfquery>
	<cfif isdefined("rsParametros1") and rsParametros1.recordcount gt 0>
		<cfset p1 = rsParametros1.p1>
	<cfelse>
		<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('Debe definir el primer período en los parámetros.')#&errDet=#URLEncodedFormat('No se ha definido el valor del primer periódo en los parámetros.')#" >
	</cfif>
<!---Segundo periodo--->	
	<cfquery name="rsParametros2" datasource="#session.DSN#">
		select Pvalor as p2
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 320
	</cfquery>
	<cfif isdefined("rsParametros2") and rsParametros2.recordcount gt 0>
		<cfset p2 = rsParametros2.p2>
	<cfelse>
		<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('Debe definir el segundo período en los parámetros.')#&errDet=#URLEncodedFormat('No se ha definido el valor del segundo periódo en los parámetros.')#" >
	</cfif>
<!---Tercer periodo--->		
	<cfquery name="rsParametros3" datasource="#session.DSN#">
		select Pvalor as p3
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 330
	</cfquery>
	<cfif isdefined("rsParametros3") and rsParametros3.recordcount gt 0>
		<cfset p3 = rsParametros3.p3>
	<cfelse>
		<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('Debe definir el tercer período en los parámetros.')#&errDet=#URLEncodedFormat('No se ha definido el valor del tercer periódo en los parámetros.')#" >	
	</cfif>
<!---cuarto periodo--->	
	<cfquery name="rsParametros4" datasource="#session.DSN#">
		select Pvalor as p4
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 340
	</cfquery>
	<cfif isdefined("rsParametros4") and rsParametros4.recordcount gt 0>
		<cfset p4 = rsParametros4.p4>
	<cfelse>
		<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('Debe definir el cuarto período en los parámetros.')#&errDet=#URLEncodedFormat('No se ha definido el valor del cuarto periódo en los parámetros.')#" >	
	</cfif>
	
<cfquery name="rsReporte" datasource="#session.DSN#">
	select sn.SNidentificacion, coalesce(snd.SNnombre,sn.SNnombre) as SNnombre,
		coalesce(snd.id_direccion,sn.id_direccion) as id_direccion,sn.SNcodigo, t.CCTdescripcion, 
		d.Ddocumento, d.Dvencimiento, 
		d.Dtotal, 'D' as tipo, 
		d.Dsaldo,
		o.Ocodigo,
		o.Odescripcion,
		m.Mnombre,m.Mcodigo, d.CCTcodigo
	from Documentos d <cf_dbforceindex name="Documentos_FK1">
	inner join SNegocios sn
		on sn.Ecodigo = d.Ecodigo
		and sn.SNcodigo = d.SNcodigo
		<cfif isdefined('form.SNnumero') and Len(trim(form.SNnumero)) and not isdefined('form.SNnumero2')>
			and sn.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumero#">
		</cfif>
		<cfif isdefined('form.SNnumero2') and Len(trim(form.SNnumero2)) and not isdefined('form.SNnumero')>
			and sn.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumero2#">
		</cfif>
		<cfif isdefined('form.SNnumero') and Len(trim(form.SNnumero)) and isdefined('form.SNnumero2') and Len(trim(form.SNnumero2))>
			<cfif form.SNnumero LTE form.SNnumero2>
			   and sn.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumero#">
			   and sn.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumero2#">
			<cfelse>
			   and sn.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumero#">
			   and sn.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumero2#">
			</cfif>
		</cfif>
	
	inner join SNClasificacionSND cs
		on cs.SNid = sn.SNid
	inner join SNDirecciones snd
		on snd.SNid = cs.SNid
		and snd.id_direccion = cs.id_direccion
		and snd.id_direccion = d.id_direccionFact	
		
	inner join SNClasificacionD cd
		on cd.SNCDid = cs.SNCDid
		<cfif isdefined('form.SNCEid') and form.SNCEid GT 0>
		and cd.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEid#">
			<cfif isdefined('form.SNCDid1') and form.SNCDid1 GT 0>
			and cd.SNCDvalor between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCDvalor1#"> 
								 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCDvalor2#">
			</cfif>
		</cfif>
	inner join CCTransacciones t
		on t.Ecodigo = d.Ecodigo
		and t.CCTcodigo = d.CCTcodigo
		and t.CCTtipo =  'D'
	
	inner join Monedas 	 m
		on m.Ecodigo = d.Ecodigo
		and m.Mcodigo = d.Mcodigo
	inner join Oficinas o
		on o.Ecodigo = d.Ecodigo
		and o.Ocodigo = d.Ocodigo

	where d.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Ddocref is null 
	  and Dsaldo > 0 
	  and not exists(select * 
				from DPagos 
				where Ecodigo = d.Ecodigo 
				  and Ddocumento= d.Ddocumento) 
	  and <cf_dbfunction name="dateadd" args="d.DEdiasMoratorio+sn.SNdiasMoraCC, d.Dvencimiento"> < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.Corte)#">  <!--- parametro --->
	  <cfif isdefined('form.CCTcodigoE') and LEN(TRIM(form.CCTcodigoE))>
	  and d.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigoE#">
	  </cfif>
	order by sn.SNnombre, m.Mnombre, o.Ocodigo, d.Dvencimiento asc
</cfquery>

<cfquery name="rsSocios" dbtype="query">
	select distinct SNCodigo, id_direccion, Mcodigo
	from rsReporte
	order by  id_direccion,SNcodigo, Mcodigo	
</cfquery>


<cfquery name="rsReporteSaldos" datasource="#session.DSN#" maxrows="3001">
	select
	 min(ec.SNCEid) as SNCEid,
	 min(ec.SNCEcodigo) as SNCEcodigo,
	 min(ec.SNCEdescripcion) as SNCEdescripcion,
	 m.Mnombre,min(d.Mcodigo) as Mcodigo,
	 min(dc.SNCDvalor) as SNCDvalor,
	 min(dc.SNCDid) as SNCDid,
	 min(dc.SNCDdescripcion) as SNCDdescripcion,
	 min(snd.SNnombre) as SNnombre, 
	 min(snd.SNDcodigo) as SNnumero,
	 min(snd.id_direccion) as id_direccion,
	 min(s.SNcodigo) as SNcodigo,	
	 sum(d.Dtotal * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) as Total,  
	 sum(d.Dsaldo * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) as Saldo,
	  
	 sum(case when 
		  	d.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			and <cf_dbfunction name="date_part"   args="MM,d.Dfecha"> = <cf_dbfunction name="date_part" args="MM,#now()#">
		  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
		  as Corriente,
	 sum(case when 
		  	d.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			and <cf_dbfunction name="date_part"   args="MM,d.Dfecha"> <> <cf_dbfunction name="date_part" args="MM,#now()#">
		  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
		  as SinVencer,		  
	 sum(case when 
		  	<cf_dbfunction name="datediff" args="d.Dvencimiento, #now()#"> 
		    between 0 and <cfqueryparam cfsqltype="cf_sql_integer" value="#p1#"> 
		  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
		  as P1,
	 sum(case when 
		  <cf_dbfunction name="datediff" args="d.Dvencimiento, #now()#">
		    between <cfqueryparam cfsqltype="cf_sql_integer" value="#p1 + 1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#p2#"> 
		  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
		  as P2,
	 sum(case when 
		  <cf_dbfunction name="datediff" args="d.Dvencimiento, #now()#">
		    between <cfqueryparam cfsqltype="cf_sql_integer" value="#p2 + 1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#p3#"> 
		  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
		  as P3,
	 sum(case when 
		  <cf_dbfunction name="datediff" args="d.Dvencimiento, #now()#">
		  	between <cfqueryparam cfsqltype="cf_sql_integer" value="#p3 + 1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#p4#"> 
		  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
		  as P4,
	 sum(case when 
		  <cf_dbfunction name="datediff" args="d.Dvencimiento, #now()#"> >= <cfqueryparam cfsqltype="cf_sql_integer" value="#p4 + 1#"> 
		  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
		  as P5,
	 sum(case when 
			<cf_dbfunction name="datediff" args="d.Dvencimiento, #now()#"> >= 0 
			and
			(
		   		<cf_dbfunction name="date_part"   args="MM,d.Dvencimiento"> <> <cf_dbfunction name="date_part"   args="MM,#now()#">
			or
				<cf_dbfunction name="date_part"   args="YY,d.Dvencimiento"> <> <cf_dbfunction name="date_part"   args="YY,#now()#">
			)
		  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
		  as Morosidad 

		from SNClasificacionE ec
		inner join SNClasificacionD dc
			inner join SNClasificacionSND cs
				inner join SNDirecciones snd
					inner join SNegocios s
						on s.SNid = snd.SNid
					inner join Documentos d
					   on d.Ecodigo = snd.Ecodigo 
					  and d.SNcodigo = snd.SNcodigo 
					  and d.id_direccionFact = snd.id_direccion   
				   on cs.SNid = snd.SNid
				  and cs.id_direccion = snd.id_direccion
			   on cs.SNCDid = dc.SNCDid
		   on dc.SNCEid = ec.SNCEid
		inner join Monedas m
		   on m.Mcodigo = d.Mcodigo 
		  and m.Ecodigo = d.Ecodigo 
		inner join CCTransacciones t
		   on t.CCTcodigo = d.CCTcodigo 
		  and t.Ecodigo = d.Ecodigo 
 	where s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<!--- Clasificación --->
		and ec.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEid#">
		<!--- Valores de Clasificación --->
		<cfif isdefined("form.SNCDvalor1") and len(trim(form.SNCDvalor1)) and isdefined("form.SNCDvalor2") and len(trim(form.SNCDvalor2))>
			<cfif form.SNCDvalor1 gt form.SNCDvalor2> <!--- si el primero es mayor que el segundo. --->
				and dc.SNCDvalor between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCDvalor2#">
								 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCDvalor1#">
			<cfelse>
				and dc.SNCDvalor between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCDvalor1#"> 
								 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCDvalor2#">
			</cfif>
		<cfelseif isdefined("form.SNCDvalor1") and len(trim(form.SNCDvalor1))>
			and dc.SNCDvalor >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCDvalor1#"> 
		<cfelseif isdefined("form.SNCDvalor2") and len(trim(form.SNCDvalor2))>
			and rtrim(ltrim(dc.SNCDvalor)) <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNCDvalor2)#"> 
		</cfif>
		<!---and s.SNcodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_ListaSocios#">) --->
		<!--- Socio de negocios --->
		<cfif isdefined("form.SNnumero") and len(trim(form.SNnumero)) and isdefined("form.SNnumero2") and len(trim(form.SNnumero2))>
			<cfif form.SNnumero gt SNnumero2><!--- si el primero es mayor que el segundo. --->
					and s.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero2#"> 
										and <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
			<cfelse>
					and s.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#"> 
										and <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero2#">
			</cfif>											
		<cfelseif isdefined("form.SNnumero") and len(trim(form.SNnumero))>
			and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#"> 
		<cfelseif isdefined("form.SNnumero2") and len(trim(form.SNnumero2))>
			and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero2#">
		</cfif>
		
	  	and d.Dsaldo <> 0.00 
		group by  ec.SNCEid, dc.SNCDid,snd.id_direccion, s.SNcodigo, snd.SNnombre, snd.SNDcodigo, m.Mnombre
		order by  ec.SNCEid, dc.SNCDid, snd.id_direccion,s.SNcodigo, snd.SNnombre, snd.SNDcodigo, m.Mnombre
</cfquery>

<cf_templateheader title="Registro de Interés Moratorio">
		<cfinclude template="../../portlets/pNavegacionIV.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Registro de Intereses Moratorios">
			<form name="form1" method="post" action="DatosCalculoDocIntMCxC.cfm">				
				<cfoutput>
				<input name="SNCEid" type="hidden" value="#form.SNCEid#" tabindex="-1">
				<input name="SNCDid1" type="hidden" value="#form.SNCDid1#" tabindex="-1">
				<input name="SNCDid2" type="hidden" value="#form.SNCDid2#" tabindex="-1">
				<input name="SNCDvalor1" type="hidden" value="#form.SNCDvalor1#" tabindex="-1">
				<input name="SNCDvalor2" type="hidden" value="#form.SNCDvalor2#" tabindex="-1">
				<input name="SNcodigo" type="hidden" value="#form.SNcodigo#" tabindex="-1">
				<input name="SNnumero" type="hidden" value="#form.SNnumero#" tabindex="-1">
				<input name="SNcodigo2" type="hidden" value="#form.SNcodigo2#" tabindex="-1">
				<input name="SNnumero2" type="hidden" value="#form.SNnumero2#" tabindex="-1">
				<input name="CCTcodigoE" type="hidden" value="#form.CCTcodigoE#" tabindex="-1">
				<input name="Corte" type="hidden" value="#form.Corte#" tabindex="-1">
				<input name="Generar" type="hidden" value="#form.Generar#" tabindex="-1">
				<cfif isdefined('form.chk_AgrupaxCliente')>
				<input name="chk_AgrupaxCliente" type="hidden" tabindex="-1">
				</cfif>
				</cfoutput>

				<cfif isdefined('form.Agregar')><input name="Agregar" type="hidden" value="Agregar"></cfif>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr><td colspan="11" nowrap class="TituloAlterno" align="center" style="text-transform:uppercase ">Lista de Documentos</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td colspan="12"><cf_botones values="Anterior,Seleccionar"></td></tr>
					<tr><td>&nbsp;</td></tr>
					<cfoutput query="rsSocios">
						<cfset Lvar_Socio = rsSocios.SNcodigo>
						<cfset Lvar_dir	= rsSocios.id_direccion>
						<cfset Lvar_mon = rsSocios.Mcodigo>
						<cfquery name="rsSaldoSocio" dbtype="query">
							select *
							from rsReporteSaldos
							where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Socio#">
							  and id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_dir#">
							  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_mon#">
						</cfquery>
						<tr class="tituloListas" height="25">
							<td>&nbsp;</td>
							<td colspan="11"><span style="font-size:13px">Moneda: #rsSaldoSocio.Mnombre#</span></td>
						</tr>
						<!--- Encabezado --->
						<tr class="tituloListas">
							<td>
								<input name="chk_TodosDocCliente" type="checkbox" tabindex="1" 
								<cfif isdefined('form.chk_TodosDocCliente') and ListContains(form.chk_TodosDocCliente,'#Mcodigo#|#SNcodigo#|#id_direccion#')>checked</cfif>
								onClick="javascript:Marcar(this);" value="#Mcodigo#|#SNcodigo#|#id_direccion#">
							</td>
							<td nowrap>&nbsp;&nbsp;#rsSaldoSocio.SNnombre#</td>
							<td align="center" nowrap>Corriente</td>
							<td align="center" nowrap>Sin Vencer</td>
							<td align="center" nowrap>De 0 a 30</td>
							<td align="center" nowrap>De 31 a 60</td>
							<td align="center" nowrap>De 61 a 90</td>
							<td align="center" nowrap>De 91 a 120</td>
							<td align="center" nowrap>De 121 o m&aacute;s</td>
							<td align="center" nowrap>Morosidad</td>
							<td align="center" nowrap>Saldo</td>
						</tr>
						<tr class="listapar" height="25">
							<td>&nbsp;</td>
							<td>&nbsp;&nbsp;<strong>C&oacute;digo:</strong>&nbsp;#rsSaldoSocio.SNnumero#</td>
							<td align="right">#LSCurrencyFormat(rsSaldoSocio.Corriente,'none')#</td>
							<td align="right">#LSCurrencyFormat(rsSaldoSocio.Sinvencer,'none')#</td>
							<td align="right">#LSCurrencyFormat(rsSaldoSocio.P1,'none')#</td>
							<td align="right">#LSCurrencyFormat(rsSaldoSocio.P2,'none')#</td>
							<td align="right">#LSCurrencyFormat(rsSaldoSocio.P3,'none')#</td>
							<td align="right">#LSCurrencyFormat(rsSaldoSocio.P4,'none')#</td>
							<td align="right">#LSCurrencyFormat(rsSaldoSocio.P5,'none')#</td>
							<td align="right">#LSCurrencyFormat(rsSaldoSocio.Morosidad,'none')#</td>
							<td align="right">#LSCurrencyFormat(rsSaldoSocio.Saldo,'none')#</td>
						</tr>
						<tr><td colspan="12">&nbsp;</td></tr>
						
														
						<!--- Detalle --->
						<tr>
							<td colspan="12">
								<table width="95%" cellpadding="0" cellspacing="0" align="center"	>
									<tr class="tituloListas">
										<td>&nbsp;</td>
										<td>Transacci&oacute;n</td>
										<td>Documento</td>
										<td>Fecha de Vencimiento</td>
										<td>Moneda</td>
										<td align="right">Saldo</td>
									</tr>
									<cfset Lvar_TotalCliente = 0>
									<cfloop query="rsReporte">
										<cfset LvarListaNon = (CurrentRow MOD 2)>
										<cfif Lvar_Socio EQ rsReporte.SNcodigo 
											and Lvar_mon EQ rsReporte.Mcodigo
											and Lvar_dir EQ rsReporte.id_direccion>
											<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>
												<td>
													<input name="chk_DocCliente" type="checkbox" tabindex="1" 
													<cfif isdefined('form.chk_DocCliente') and ListContainsNoCase(form.chk_DocCliente, '#rsReporte.Mcodigo#|#rsReporte.SNcodigo#|#rsReporte.id_direccion#|#rsReporte.CCTcodigo#|#rsReporte.CCTdescripcion#|#rsReporte.Ddocumento#|#rsReporte.Dsaldo#|#rsReporte.Dvencimiento#|#rsReporte.Ocodigo#') GT 0>checked</cfif>
														value="#rsReporte.Mcodigo#|#rsReporte.SNcodigo#|#rsReporte.id_direccion#|#rsReporte.CCTcodigo#|#rsReporte.CCTdescripcion#|#rsReporte.Ddocumento#|#rsReporte.Dsaldo#|#rsReporte.Dvencimiento#|#rsReporte.Ocodigo#">
												</td>
												<td>#rsReporte.CCTdescripcion#</td>
												<td>#rsReporte.Ddocumento#</td>
												<td>#LSDateFormat(rsReporte.Dvencimiento,'mm/dd/yyyy')#</td>
												<td>#rsReporte.Mnombre#</td>
												<td align="right">#LSCurrencyFormat(Dsaldo,'none')#</td>
											</tr>
											<cfset Lvar_TotalCliente = Lvar_TotalCliente + Dsaldo>
										</cfif>
									</cfloop>
									<tr>
										<td align="right" colspan="5"><strong>Total</strong></td>
										<td align="right" height="25">#LSCurrencyFormat(Lvar_TotalCliente,'none')#</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td colspan="12">&nbsp;</td></tr>
					</cfoutput>
					<tr><td colspan="12">&nbsp;</td></tr>
					<tr><td colspan="12"><cf_botones values="Anterior,Seleccionar"></td></tr>
				</table>
			</form>
		<cf_web_portlet_end> 
	<cf_templatefooter>
<script language="JavaScript" type="text/javascript">
	function funcAplicar(){
		if (document.form1.DocIntMora.value == ""){
			alert('Debe digitar la informacion de Documento. Verifique.');
			return false;
		}else if (document.form1.Tasa.value == "" || document.form1.Tasa.value == 0){
			alert('La tasa de Interés debe ser mayor a cero. Verifique.');
			return false;
		}else if (document.form1.Cid.value == ""){
			alert('Debe seleccionar un concepto. Verifique.');
			return false;
		}else if (document.form1.chk != null) {
			if (document.form1.chk.value != null) {
				if (!document.form1.chk.checked) { 
					alert("Debe escoger un documento de pago para aplicar. Verifique");
					return false;
				}
			} else {
				for (var i=0; i<document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) {
						return true;
					}
				}
				alert("Debe escoger un documento de pago para aplicar. Verifique.");
				return false;
			}
		} 
	}
	
	function Marcar(c) {
		var Soc = c.value;
			llave1 = Soc.split('|');
		
		if (c.checked) {
			for (counter = 0; counter < document.form1.chk_DocCliente.length; counter++)
			{
				var Doc = document.form1.chk_DocCliente[counter].value;
					llave2 = Doc.split('|');
					
				if ((!document.form1.chk_DocCliente[counter].checked) && (!document.form1.chk_DocCliente[counter].disabled)
					&& (llave1[0] == llave2[0] && llave1[1] == llave2[1] && llave1[2] == llave2[2]))
					{  document.form1.chk_DocCliente[counter].checked = true;}
			}
			if ((counter==0)  && (!document.form1.chk_DocCliente.disabled)
				&& (llave1[0] == llave2[0] && llave1[1] == llave2[1] && llave1[2] == llave2[2])) {
				document.form1.chk_DocCliente.checked = true;
			}
		}
		else {
			for (var counter = 0; counter < document.form1.chk_DocCliente.length; counter++)
			{
				var Doc = document.form1.chk_DocCliente[counter].value;
					llave2 = Doc.split('|');
				if ((document.form1.chk_DocCliente[counter].checked) && (!document.form1.chk_DocCliente[counter].disabled)
					&& (llave1[0] == llave2[0] && llave1[1] == llave2[1] && llave1[2] == llave2[2]))
					{  document.form1.chk_DocCliente[counter].checked = false;}
			};
			if ((counter==0) && (!document.form1.chk_DocCliente.disabled)
				&& (llave1[0] == llave2[0] && llave1[1] == llave2[1] && llave1[2] == llave2[2])) {
				document.form1.chk_DocCliente.checked = false;
			}
		};
	}			
	function funcAnterior(){

		<cfoutput>
		document.form1.action = 'RegistroInteresMoratorioCxC.cfm';
		</cfoutput>
	}	
	function funcSeleccionar() {
		if (validaChecks()) 
			return true;	
		return false;
	}
	function validaChecks() {
		var bandera = false;
		var i;
		for (i = 0; i < document.form1.chk_DocCliente.length; i++) {
			if (document.form1.chk_DocCliente[i].checked) bandera = true;						
		}
		if (bandera)
			return true;
		else
			alert("Debe seleccionar al menos un documento.");											
		return false;
	}

</script>	
