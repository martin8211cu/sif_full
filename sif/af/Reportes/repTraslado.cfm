<!--- cuando viene descargar aquí mismo se hace la descarga, está abajo --->
<cfif not isdefined('form.btnDescargar')>
	<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
	<cfif isdefined("Url.btnFiltrar") and not isdefined("Form.btnFiltrar")>
		<cfparam name="Form.btnFiltrar" default="#Url.btnFiltrar#">
	</cfif>
	<cfif isdefined('url.AGTPid') and not isdefined('form.AGTPid')>
		<cfset form.AGTPid = url.AGTPid>
	</cfif>					
	<cfif not isdefined('form.AGTPid') or  (isdefined('url.AGTPid') and len(trim(url.AGTPid)) eq  0)>
		<cf_templateheader title="#nav__SPdescripcion#">
				<cfinclude template="/sif/portlets/pNavegacion.cfm">
				<cfoutput>#pNavegacion#</cfoutput>
			<cf_web_portlet_start titulo="#nav__SPdescripcion#">
						<table width="100%" border="0">
							<tr>
								<td align="center">
									<cfset filtro = "">
									<cfset navegacion = "">	
									
									<cfif isdefined("Form.btnFiltrar") and Len(Trim(Form.btnFiltrar)) NEQ 0>
										<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "btnFiltrar=" & Form.btnFiltrar>
									</cfif>
									
									<cfinclude template="agtProceso_filtroGrupos.cfm">
									<cfif isdefined('form.btnFiltrar')>
										<cfinclude template="repTraslado-lista.cfm">
									</cfif>									
								</td>
							</tr>							
						</table>
					<cf_web_portlet_end>
			<cf_templatefooter>
	<cfelse>
		<cfset param = "">
		<cfset filtro = "">
		<cfset navegacion = "">								
		<cfset param = param & "&AGTPid=#form.AGTPid#">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "AGTPid=" & Form.AGTPid>
		<cfinclude template="repTraslado-form.cfm">
		<p class="style2"><br>
		<strong class="style6">Nota:</strong> La leyenda <strong class="style6">ND</strong> indica que el campo aun no está definido. (Esto se presenta en Activos nuevos)
		</p>
	</cfif>
<cfelse>
	<cfif not isdefined('form.AGTPid') or  Len(Trim(form.AGTPid)) EQ 0>
		<cfset Form.AGTPid = form.chk>
	</cfif>
	<cfparam name="AGTPid">
	
	<cfquery name="rsDatos" datasource="#session.dsn#">
		select 
			rtrim(b.Aplaca) as Placa, rtrim(b.Adescripcion) as Activo, 
			coalesce(rtrim(bb.Aplaca), rtrim(a.Aplacadestino)) as PlacaDestino, 
			coalesce(rtrim(bb.Adescripcion),rtrim(b.Adescripcion)) as DescripcionDestino,
			Acl.ACgastodep as Complemento,
			TAmontolocadq as MontoLocalAdq, 
			TAmontolocmej as MontoLocalMej, 
			TAmontolocrev as MontoLocRev, 
			TAmontolocadq + TAmontolocmej + TAmontolocrev as MontoLocalTot,
			
			TAmontodepadq as MontoDepreAdq, 
			TAmontodepmej as MontoDepreMej, 
			TAmontodeprev as MontoDepreRev, 
		
			TAmontodepadq + TAmontodepmej + TAmontodeprev as MontoDepreTot,
		
			TAmontolocadq + TAmontolocmej + TAmontolocrev -
			TAmontodepadq - TAmontodepmej - TAmontodeprev as ValorLibros,
		
			TAvaladq as ValorAdq, 
			TAvalmej as ValorMej, 
			TAvalrev as ValorRev, 
			TAvaladq + TAvalmej + TAvalrev as ValorTotal,
			
			TAdepacumadq as DepreAcumAdq, 
			TAdepacummej as DepreAcumMej, 
			TAdepacumrev as DepreAcumRev, 
			TAdepacumadq + TAdepacummej + TAdepacumrev as DepreAcumTotal,
			coalesce(  (Select <cf_dbfunction name="concat" args="ltrim(rtrim(ofd.Oficodigo)),'-',ltrim(rtrim(ofd.Odescripcion))">
					from AFSaldos afsd
							inner join Oficinas ofd
								 on ofd.Ocodigo  = afsd.Ocodigo
							   and ofd.Ecodigo  = afsd.Ecodigo
	
					where bb.Aid = afsd.Aid
					   and bb.Ecodigo = afsd.Ecodigo
					   and afsd.AFSperiodo = a.TAperiodo 
					   and afsd.AFSmes = a.TAmes
					) ,'ND') as Oficina_dest,
			coalesce(  (Select AFSvutiladq 
					from AFSaldos afsd2
					where bb.Aid = afsd2.Aid
					   and bb.Ecodigo = afsd2.Ecodigo
					   and afsd2.AFSperiodo = a.TAperiodo 
					   and afsd2.AFSmes = a.TAmes
					) ,0) as Vida_Util_dest,
			coalesce(  (Select AFSsaldovutiladq 
					from AFSaldos afsd3
					where bb.Aid = afsd3.Aid
					   and bb.Ecodigo = afsd3.Ecodigo
					   and afsd3.AFSperiodo = a.TAperiodo 
					   and afsd3.AFSmes = a.TAmes
					) ,0) as Saldo_VU_dest,
			
			(select	Cont.Cformato
			from CContables Cont
		 		where Cont.Ccuenta = Acl.ACcadq
		 		and Cont.Ecodigo=b.Ecodigo) as Cuenta_Costo,
				
			(select	Cont2.Cformato
			from CContables Cont2
		 		where Cont2.Ccuenta = Acl.ACcdepacum
		 		and Cont2.Ecodigo=b.Ecodigo) as Cuenta_Depreciacion_Ac,
				
			(coalesce(cf.CFcuentagastoretaf, cf.CFcuentaaf, cf.CFcuentac)) as CuentaGasto
				
		from TransaccionesActivos a 
			inner join Activos b 
				on a.Aid = b.Aid 
				and a.Ecodigo = b.Ecodigo
			<cfif isdefined('form.ACcodigodesde') and len(trim(form.ACcodigodesde)) gt 0 and form.ACcodigodesde gt 0>
				and b.ACcodigo > #form.ACcodigodesde#
			</cfif>
			<cfif isdefined('form.ACcodigohasta') and len(trim(form.ACcodigohasta)) gt 0 and form.ACcodigohasta gt 0>
				and b.ACcodigo < #form.ACcodigohasta#
			</cfif>
			
			inner join CFuncional cf
					on cf.CFid = a.CFid
				   and cf.Ecodigo = b.Ecodigo
				   
			inner join AClasificacion Acl
				on Acl.Ecodigo=b.Ecodigo
            	and Acl.ACcodigo=b.ACcodigo
            	and Acl.ACid=b.ACid
				
			inner join ACategoria cat
            	on cat.Ecodigo=b.Ecodigo
            	and cat.ACcodigo=b.ACcodigo
				
			left outer join Activos bb
				on a.Aiddestino = bb.Aid 
				and a.Ecodigo = bb.Ecodigo
		where IDtrans = 8
				and a.Ecodigo = #session.ecodigo#
			<cfif isdefined('form.AGTPid') and  len(trim(form.AGTPid)) gt 0 and form.AGTPid gt 0>
				and a.AGTPid = #form.AGTPid#
			<cfelseif isdefined('form.Periodo') and  len(trim(form.Periodo)) gt 0 and form.Periodo gt 0
				and isdefined('form.Mes') and  len(trim(form.Mes)) gt 0 and form.Mes gt 0>
				and TAperiodo = #form.Periodo#
				and TAmes = #form.Mes#
			<cfelse>
				<cf_errorCode	code = "50108" msg = "Se requiere Transacción o Periodo / Mes para ver el Reporte. Proceso Cancelado!">
			</cfif>
			
	    	union all
			select 
			rtrim(b.Aplaca) as Placa, rtrim(b.Adescripcion) as Activo, 
			coalesce(rtrim(bb.Aplaca), rtrim(a.Aplacadestino)) as PlacaDestino, 
			coalesce(rtrim(bb.Adescripcion),rtrim(b.Adescripcion)) as DescripcionDestino,
			Acl.ACgastodep as Complemento,
				
			TAmontolocadq as MontoLocalAdq, 
			TAmontolocmej as MontoLocalMej, 
			TAmontolocrev as MontoLocRev, 
			TAmontolocadq + TAmontolocmej + TAmontolocrev as MontoLocalTot,
			
			TAmontodepadq as MontoDepreAdq, 
			TAmontodepmej as MontoDepreMej, 
			TAmontodeprev as MontoDepreRev, 
		
			TAmontodepadq + TAmontodepmej + TAmontodeprev as MontoDepreTot,
		
			TAmontolocadq + TAmontolocmej + TAmontolocrev -
			TAmontodepadq - TAmontodepmej - TAmontodeprev as ValorLibros,
		
			TAvaladq as ValorAdq, 
			TAvalmej as ValorMej, 
			TAvalrev as ValorRev, 
			TAvaladq + TAvalmej + TAvalrev as ValorTotal,
			
			TAdepacumadq as DepreAcumAdq, 
			TAdepacummej as DepreAcumMej, 
			TAdepacumrev as DepreAcumRev, 
			TAdepacumadq + TAdepacummej + TAdepacumrev as DepreAcumTotal,
			coalesce(  (Select <cf_dbfunction name="concat" args="ltrim(rtrim(ofd.Oficodigo)),'-',ltrim(rtrim(ofd.Odescripcion))">
					from AFSaldos afsd
							inner join Oficinas ofd
								 on ofd.Ocodigo  = afsd.Ocodigo
							   and ofd.Ecodigo  = afsd.Ecodigo
	
					where bb.Aid = afsd.Aid
					   and bb.Ecodigo = afsd.Ecodigo
					   and afsd.AFSperiodo = a.TAperiodo 
					   and afsd.AFSmes = a.TAmes
					) ,'ND') as Oficina_dest,
			coalesce(  (Select AFSvutiladq 
					from AFSaldos afsd2
					where bb.Aid = afsd2.Aid
					   and bb.Ecodigo = afsd2.Ecodigo
					   and afsd2.AFSperiodo = a.TAperiodo 
					   and afsd2.AFSmes = a.TAmes
					) ,0) as Vida_Util_dest,
			coalesce(  (Select AFSsaldovutiladq 
					from AFSaldos afsd3
					where bb.Aid = afsd3.Aid
					   and bb.Ecodigo = afsd3.Ecodigo
					   and afsd3.AFSperiodo = a.TAperiodo 
					   and afsd3.AFSmes = a.TAmes
					) ,0) as Saldo_VU_dest,
			
			(select	Cont.Cformato
			from CContables Cont
		 		where Cont.Ccuenta = Acl.ACcadq
		 		and Cont.Ecodigo=b.Ecodigo) as Cuenta_Costo,
				
			(select	Cont2.Cformato
			from CContables Cont2
		 		where Cont2.Ccuenta = Acl.ACcdepacum
		 		and Cont2.Ecodigo=b.Ecodigo) as Cuenta_Depreciacion_Ac,
				
			(coalesce(cf.CFcuentagastoretaf, cf.CFcuentaaf, cf.CFcuentac)) as CuentaGasto
			
		from ADTProceso a 
			inner join Activos b 
				on a.Aid = b.Aid 
				and a.Ecodigo = b.Ecodigo
			<cfif isdefined('form.ACcodigodesde') and len(trim(form.ACcodigodesde)) gt 0 and form.ACcodigodesde gt 0>
				and b.ACcodigo > #form.ACcodigodesde#
			</cfif>
			<cfif isdefined('form.ACcodigohasta') and len(trim(form.ACcodigohasta)) gt 0 and form.ACcodigohasta gt 0>
				and b.ACcodigo < #form.ACcodigohasta#
			</cfif>
			
			inner join CFuncional cf
					on cf.CFid = a.CFid
				   and cf.Ecodigo = b.Ecodigo
				   
			inner join AClasificacion Acl
				on Acl.Ecodigo=b.Ecodigo
            	and Acl.ACcodigo=b.ACcodigo
            	and Acl.ACid=b.ACid
				
			inner join ACategoria cat
            	on cat.Ecodigo=b.Ecodigo
            	and cat.ACcodigo=b.ACcodigo
				
			left outer join Activos bb
				on a.Aiddestino = bb.Aid 
				and a.Ecodigo = bb.Ecodigo
				
		where a.IDtrans = 8
				and a.Ecodigo = #session.ecodigo#
			<cfif isdefined('form.AGTPid') and  len(trim(form.AGTPid)) gt 0 and form.AGTPid gt 0>
				and a.AGTPid = #form.AGTPid#
			<cfelseif isdefined('form.Periodo') and  len(trim(form.Periodo)) gt 0 and form.Periodo gt 0
				and isdefined('form.Mes') and  len(trim(form.Mes)) gt 0 and form.Mes gt 0>
				and TAperiodo = #form.Periodo#
				and TAmes = #form.Mes#
			<cfelse>
				<cf_errorCode	code = "50108" msg = "Se requiere Transacción o Periodo / Mes para ver el Reporte. Proceso Cancelado!">
			</cfif>
	</cfquery>
	
	<cfobject component="sif.Componentes.AplicarMascara" name="LvarOBJ">
	<cfloop query="rsDatos">
		<cfset LvarCuentaAComplementar = rsDatos.CuentaGasto>
		<cfset LvarComplemento = rsDatos.Complemento>
		<cfif len(trim(LvarCuentaAComplementar)) and len(trim(LvarComplemento))>
			<!--- Pasar por la máscara --->
			<cfset QuerySetCell(rsDatos, "CuentaGasto", LvarOBJ.AplicarMascara(LvarCuentaAComplementar, LvarComplemento), rsDatos.currentrow)>
		</cfif>
	</cfloop>
	<cfflush interval="64">
	<cftry>
		<cf_exportQueryToFile query="#rsDatos#" separador="#chr(9)#" filename="Retiro_#session.Usucodigo##LSDateFormat(Now(),'ddmmyyyy')##LSTimeFormat(Now(),'hh:mm:ss')#.txt">
	<cfcatch type="any">
		<cfrethrow>
	</cfcatch>
	</cftry>
</cfif>


