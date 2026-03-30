<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif isdefined('url.imprimir')>
	<cfif isdefined('url.AGTPid') and not isdefined('form.AGTPid')>
		<cfset form.AGTPid = url.AGTPid>
	</cfif>					
	<cfif isdefined('url.Periodo') and not isdefined('form.Periodo')>
		<cfset form.Periodo = url.Periodo>
	</cfif>
	<cfif isdefined('url.Mes') and not isdefined('form.Mes')>
		<cfset form.Mes = url.Mes>
	</cfif>
	<cfif isdefined('url.ACcodigodesde') and not isdefined('form.ACcodigodesde')>
		<cfset form.ACcodigodesde = url.ACcodigodesde>
	</cfif>
	<cfif isdefined('url.ACcodigohasta') and not isdefined('form.ACcodigohasta')>
		<cfset form.ACcodigohasta = url.ACcodigohasta>
	</cfif>
</cfif>

<style type="text/css">
<!--
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
}
.style2 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style3 {font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; }

.style4 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
}
.style5 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
}
.style6 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 7px;
	font-weight: bold;
}
-->
</style>

<cfquery name="rsQuery" datasource="#session.dsn#" maxrows="3001">
	select 
		
		b.Aid as LAid, rtrim(b.Aplaca) as LAplaca, rtrim(b.Adescripcion) as LAdescripcion, 
		bb.Aid as LAiddestino, coalesce(rtrim(bb.Aplaca), rtrim(a.Aplacadestino)) as LAplacadestino, 
		coalesce(rtrim(bb.Adescripcion),rtrim(b.Adescripcion)) as LAdescripciondestino,
			
		AGTPid as LAGTPid, <!--- ADTPlinea as LADTPlinea, ---> 
		
		TAmontolocadq as LTAmontolocadq, TAmontolocmej as LTAmontolocmej, TAmontolocrev as LTAmontolocrev, 
		TAmontolocadq + TAmontolocmej + TAmontolocrev as LTAmontoloctot,
		
		TAmontodepadq as LTAmontodepadq, TAmontodepmej as LTAmontodepmej, TAmontodeprev as LTAmontodeprev, 
		TAmontodepadq + TAmontodepmej + TAmontodeprev as LTAmontodeptot,
	
		TAmontolocadq + TAmontolocmej + TAmontolocrev -
		TAmontodepadq - TAmontodepmej - TAmontodeprev as LTAvallibros,
	
		
		TAvaladq as LTAvaladq, TAvalmej as LTAvalmej, TAvalrev as LTAvalrev, 
		TAvaladq + TAvalmej + TAvalrev as LTAvaltot,
		
		TAdepacumadq as LTAdepacumadq, TAdepacummej as LTAdepacummej, TAdepacumrev as LTAdepacumrev, 
		TAdepacumadq + TAdepacummej + TAdepacumrev as LTAdepacumtot,
		
		(ltrim(rtrim(o.Oficodigo)) #_Cat# '-' #_Cat# ltrim(rtrim(o.Odescripcion))) as Oficodigo,
		(ltrim(rtrim(ofd.Oficodigo)) #_Cat# '-' #_Cat# ltrim(rtrim(ofd.Odescripcion))) as Oficodigodest,
	
		rtrim(ltrim(acat.ACcodigodesc)) #_Cat# '-' #_Cat# rtrim(ltrim(acat.ACdescripcion)) as CategoriaOrg,
		rtrim(ltrim(acla.ACcodigodesc)) #_Cat# '-' #_Cat# rtrim(ltrim(acla.ACdescripcion)) as ClaseOrg,
		
		rtrim(ltrim(catd.ACcodigodesc)) #_Cat# '-' #_Cat# rtrim(ltrim(catd.ACdescripcion)) as CategoriaDst,
		rtrim(ltrim(clsd.ACcodigodesc)) #_Cat# '-' #_Cat# rtrim(ltrim(clsd.ACdescripcion)) as ClaseDst
	
	from ADTProceso a 
		inner join Activos b 
			on a.Aid = b.Aid 
			and a.Ecodigo = b.Ecodigo
		<cfif isdefined('form.ACcodigodesde') and len(trim(form.ACcodigodesde)) gt 0 and form.ACcodigodesde gt 0>
			and b.ACcodigo > <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigodesde#">
		</cfif>
		<cfif isdefined('form.ACcodigohasta') and len(trim(form.ACcodigohasta)) gt 0 and form.ACcodigohasta gt 0>
			and b.ACcodigo < <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigohasta#">
		</cfif>
		left outer join Activos bb
			on a.Aiddestino = bb.Aid 
			and a.Ecodigo = bb.Ecodigo
			
		inner join CFuncional cf
			on cf.CFid = a.CFid
		   and cf.Ecodigo = b.Ecodigo

		inner join Oficinas o
			on o.Ocodigo = cf.Ocodigo
		   and o.Ecodigo = cf.Ecodigo
		   
  	    inner join ACategoria acat
  	    	on acat.ACcodigo = b.ACcodigo
		   and acat.Ecodigo  = b.Ecodigo
		
		inner join AClasificacion acla
  	    	on acla.ACid     = b.ACid
		   and acla.Ecodigo  = b.Ecodigo		
		   and acla.ACcodigo = acat.ACcodigo
		   
		<!--- Saldos de Activo Destino --->
		inner join AFSaldos afsd
			on bb.Aid = afsd.Aid
		   and bb.Ecodigo = afsd.Ecodigo
		   and afsd.AFSperiodo = a.TAperiodo 
		   and afsd.AFSmes = a.TAmes

		<!--- Oficina Destino --->										
		inner join Oficinas ofd
			on ofd.Ocodigo  = afsd.Ocodigo
		   and ofd.Ecodigo  = afsd.Ecodigo			   
					   
		<!--- Categoria Destino --->								   
  	    inner join ACategoria catd
  	    	on catd.ACcodigo = bb.ACcodigo
		   and catd.Ecodigo  = bb.Ecodigo
		
		<!--- Clase Destino --->					
		inner join AClasificacion clsd
  	    	on clsd.ACid     = bb.ACid
		   and clsd.Ecodigo  = bb.Ecodigo		
		   and clsd.ACcodigo = catd.ACcodigo			  
			  
	where IDtrans = 8
		and a.Ecodigo = #session.ecodigo# 
	<cfif isdefined('form.AGTPid') and  len(trim(form.AGTPid)) gt 0 and form.AGTPid gt 0>
		and a.AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
	<cfelseif isdefined('form.Periodo') and  len(trim(form.Periodo)) gt 0 and form.Periodo gt 0
		and isdefined('form.Mes') and  len(trim(form.Mes)) gt 0 and form.Mes gt 0>
		and TAperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Periodo#">
		and TAmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mes#">
	<cfelse>
		<cf_errorCode	code = "50108" msg = "Se requiere Transaccin o Periodo / Mes para ver el Reporte. Proceso Cancelado!">
	</cfif>
	
	union all
	
	select 

	b.Aid as LAid, rtrim(b.Aplaca) as LAplaca, rtrim(b.Adescripcion) as LAdescripcion, 
	bb.Aid as LAiddestino, rtrim(bb.Aplaca) as LAplacadestino, rtrim(bb.Adescripcion) as LAdescripciondestino,
		
	AGTPid as LAGTPid, <!--- ADTPlinea as LADTPlinea, ---> 
	
	TAmontolocadq as LTAmontolocadq, TAmontolocmej as LTAmontolocmej, TAmontolocrev as LTAmontolocrev, 
	TAmontolocadq + TAmontolocmej + TAmontolocrev as LTAmontoloctot,
	
	TAmontodepadq as LTAmontodepadq, TAmontodepmej as LTAmontodepmej, TAmontodeprev as LTAmontodeprev, 
	TAmontodepadq + TAmontodepmej + TAmontodeprev as LTAmontodeptot,

	TAmontolocadq + TAmontolocmej + TAmontolocrev -
	TAmontodepadq - TAmontodepmej - TAmontodeprev as LTAvallibros,

	
	TAvaladq as LTAvaladq, TAvalmej as LTAvalmej, TAvalrev as LTAvalrev, 
	TAvaladq + TAvalmej + TAvalrev as LTAvaltot,
	
	TAdepacumadq as LTAdepacumadq, TAdepacummej as LTAdepacummej, TAdepacumrev as LTAdepacumrev, 
	TAdepacumadq + TAdepacummej + TAdepacumrev as LTAdepacumtot,
	
	(ltrim(rtrim(o.Oficodigo)) #_Cat# '-' #_Cat# ltrim(rtrim(o.Odescripcion))) as Oficodigo,
	(ltrim(rtrim(ofd.Oficodigo)) #_Cat# '-' #_Cat# ltrim(rtrim(ofd.Odescripcion))) as Oficodigodest,
	
	rtrim(ltrim(acat.ACcodigodesc)) #_Cat# '-' #_Cat# rtrim(ltrim(acat.ACdescripcion)) as CategoriaOrg,
	rtrim(ltrim(acla.ACcodigodesc)) #_Cat# '-' #_Cat# rtrim(ltrim(acla.ACdescripcion)) as ClaseOrg,
	
	rtrim(ltrim(catd.ACcodigodesc)) #_Cat# '-' #_Cat# rtrim(ltrim(catd.ACdescripcion)) as CategoriaDst,
	rtrim(ltrim(clsd.ACcodigodesc)) #_Cat# '-' #_Cat# rtrim(ltrim(clsd.ACdescripcion)) as ClaseDst	
	
	from TransaccionesActivos a 
		inner join Activos b 
			on a.Aid = b.Aid 
			and a.Ecodigo = b.Ecodigo
			<cfif isdefined('form.ACcodigodesde') and len(trim(form.ACcodigodesde)) gt 0 and form.ACcodigodesde gt 0>
				and b.ACcodigo > <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigodesde#">
			</cfif>
			<cfif isdefined('form.ACcodigohasta') and len(trim(form.ACcodigohasta)) gt 0 and form.ACcodigohasta gt 0>
				and b.ACcodigo < <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigohasta#">
			</cfif>
		inner join Activos bb
			on a.Aiddestino = bb.Aid 
			and a.Ecodigo = bb.Ecodigo
		
		<!--- Oficina Origen --->	
		inner join CFuncional cf
			on cf.CFid    = a.CFid
		   and cf.Ecodigo = a.Ecodigo

		inner join Oficinas o
			on o.Ocodigo = cf.Ocodigo
		   and o.Ecodigo = cf.Ecodigo			
		   
  	    inner join ACategoria acat
  	    	on acat.ACcodigo = b.ACcodigo
		   and acat.Ecodigo  = b.Ecodigo
		
		inner join AClasificacion acla
  	    	on acla.ACid     = b.ACid
		   and acla.Ecodigo  = b.Ecodigo		
		   and acla.ACcodigo = acat.ACcodigo		   
		   
		<!--- Saldos de Activo Destino --->
		inner join AFSaldos afsd
			on bb.Aid = afsd.Aid
		   and bb.Ecodigo = afsd.Ecodigo
		   and afsd.AFSperiodo = a.TAperiodo 
		   and afsd.AFSmes = a.TAmes

		<!--- Oficina Destino --->										
		inner join Oficinas ofd
			on ofd.Ocodigo  = afsd.Ocodigo
		   and ofd.Ecodigo  = afsd.Ecodigo			   
		   
		<!--- Categoria Destino --->								   
  	    inner join ACategoria catd
  	    	on catd.ACcodigo = bb.ACcodigo
		   and catd.Ecodigo  = bb.Ecodigo
		
		<!--- Clase Destino --->					
		inner join AClasificacion clsd
  	    	on clsd.ACid     = bb.ACid
		   and clsd.Ecodigo  = bb.Ecodigo		
		   and clsd.ACcodigo = catd.ACcodigo				   
			
	where IDtrans = 8
		and a.Ecodigo = #session.ecodigo# 
	<cfif isdefined('form.AGTPid') and  len(trim(form.AGTPid)) gt 0 and form.AGTPid gt 0>
		and a.AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
	<cfelseif isdefined('form.Periodo') and  len(trim(form.Periodo)) gt 0 and form.Periodo gt 0
		and isdefined('form.Mes') and  len(trim(form.Mes)) gt 0 and form.Mes gt 0>
		and TAperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Periodo#">
		and TAmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mes#">
	<cfelse>
		<cf_errorCode	code = "50108" msg = "Se requiere Transaccin o Periodo / Mes para ver el Reporte. Proceso Cancelado!">
	</cfif>

</cfquery>


<cfif isdefined('form.AGTPid') and  len(trim(form.AGTPid)) gt 0 and form.AGTPid gt 0>
	<cfquery name="rsAGTProceso" datasource="#session.dsn#">
		select AGTPdescripcion
		from AGTProceso
		where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
	</cfquery>
</cfif>
<cfset grupodesc = "">
<cfif isdefined('rsAGTProceso') and rsAGTProceso.recordCount GT 0>
	<cfset grupodesc = rsAGTProceso.AGTPdescripcion>
</cfif>

<table width="100%"  border="0" cellspacing="0" cellpadding="0"> 
	<tr>
    	<td colspan="4">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr class="areaFiltro">
					<td colspan="4" align="center"><cfoutput><span class="style3">#Session.Enombre#</span></cfoutput></td>
			  	</tr>			
			  	<tr>
					<td colspan="4" align="center">&nbsp;</td>
			  	</tr>				  
			  	<tr>
					<td colspan="4" align="center"><span class="style1">Lista de Transacciones de Traslado</span></td>
			  	</tr>
  				<cfif isdefined('grupodesc') and  len(trim(grupodesc)) gt 0 and grupodesc gt 0>
			  		<tr>
						<td colspan="4" align="center"><span class="style1"><cfoutput>del grupo #grupodesc#</cfoutput></span></td>
			  		</tr>
				<cfelseif isdefined('form.Periodo') and  len(trim(form.Periodo)) gt 0 and form.Periodo gt 0
					and isdefined('form.Mes') and  len(trim(form.Mes)) gt 0 and form.Mes gt 0>
				  	<tr>
						<td colspan="4" align="center"><span class="style1"><cfoutput>Periodo #form.Periodo# / Mes #form.Mes#</cfoutput></span></td>
				  	</tr>
				</cfif>
				<!--- Validacion de la Categoria Inical --->
				<cfif isdefined('form.ACcodigodesde') and len(trim(form.ACcodigodesde)) gt 0 and form.ACcodigodesde gt 0>
					<cfquery name="rsCategoriadesde" datasource="#session.dsn#">
						select ACcodigodesc, ACdescripcion 
						from ACategoria 
						where Ecodigo = #session.ecodigo# 
							and ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigodesde#">
					</cfquery>
					<tr>
						<td colspan="4" align="center"><span class="style1"><cfoutput>Desde la Categor&iacute;a #rsCategoriadesde.ACcodigodesc# - #rsCategoriadesde.ACdescripcion#</cfoutput></span></td>
					</tr>
				</cfif>
				<!--- Validacion de la Categoria Final --->
				<cfif isdefined('form.ACcodigohasta') and len(trim(form.ACcodigohasta)) gt 0 and form.ACcodigohasta gt 0>
					<cfquery name="rsCategoriahasta" datasource="#session.dsn#">
						select ACcodigodesc, ACdescripcion 
						from ACategoria 
						where Ecodigo = #session.ecodigo# 
						and ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigohasta#">
					</cfquery>
					<tr>
						<td colspan="4" align="center"><span class="style1"><cfoutput>Hasta la Categor&iacute;a #rsCategoriahasta.ACcodigodesc# - #rsCategoriahasta.ACdescripcion#</cfoutput></span></td>
					</tr>
				</cfif>
			  	<tr>
					<td colspan="4" align="center"><cfoutput><font size="2"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(Now(),'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(Now(),'medium')#</font></cfoutput></td>
			  	</tr>		
			  	<tr><td colspan="4">&nbsp;</td></tr>					
			  	<tr>
			  		<td colspan="4">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Placa</strong></td>
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Descripci&oacute;n</strong></td>
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Oficina</strong></td>
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Categoria</strong></td>
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Clase</strong></td>
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Placa Dest.</strong></td>
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Descripci&oacute;n Dest.</strong></td>
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Oficina Dest.</strong></td>
							 	<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Categoria Dest.</strong></td>
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Clase Dest.</strong></td>
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Adquisici&oacute;n</strong></td> 
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Mejoras </strong></td>
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Revaluaci&oacute;n</strong></td> 
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Dep. Adquisici&oacute;n</strong></td> 
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Dep. Mejoras</strong></td>
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Dep. Revaluaci&oacute;n</strong></td> 
								<td style="background-color:#CCCCCC; "><strong style="font-size:9px">Valor En Libros</strong></td>
							</tr>
							<!--- Variables para sumar los montos de las columnas --->
							<cfset _LTAmontolocadq = 0>
							<cfset _LTAmontolocmej = 0>
							<cfset _LTAmontolocrev = 0>
							<cfset _LTAmontodepadq = 0>
							<cfset _LTAmontodepmej = 0>
							<cfset _LTAmontodeprev = 0>
							<cfset _LTAvallibros = 0>
							
							<cfloop query="rsQuery">
								<tr>
									<td style="font-size:9px"><cfoutput>#LAplaca#</cfoutput></td>
									<td style="font-size:9px"><cfoutput>#LAdescripcion#</cfoutput></td>
									<td style="font-size:9px"><cfoutput>#Oficodigo#</cfoutput></td>
									<td style="font-size:9px"><cfoutput>#CategoriaOrg#</cfoutput></td>
									<td style="font-size:9px"><cfoutput>#ClaseOrg#</cfoutput></td>
									<td style="font-size:9px"><cfoutput>#LAplacadestino#</cfoutput></td>
									<td style="font-size:9px"><cfoutput>#LAdescripciondestino#</cfoutput></td>
									<td style="font-size:9px"><cfoutput>#Oficodigodest#</cfoutput></td>
									<td style="font-size:9px"><cfoutput>#CategoriaDst#</cfoutput></td>
									<td style="font-size:9px"><cfoutput>#ClaseDst#</cfoutput></td>
									<td style="font-size:9px" align="right"><cfoutput>#LSNumberFormat(LTAmontolocadq, ',9.00')#</cfoutput></td> 
									<td style="font-size:9px" align="right"><cfoutput>#LSNumberFormat(LTAmontolocmej, ',9.00')#</cfoutput></td>
									<td style="font-size:9px" align="right"><cfoutput>#LSNumberFormat(LTAmontolocrev, ',9.00')#</cfoutput></td> 
									<td style="font-size:9px" align="right"><cfoutput>#LSNumberFormat(LTAmontodepadq, ',9.00')#</cfoutput></td> 
									<td style="font-size:9px" align="right"><cfoutput>#LSNumberFormat(LTAmontodepmej, ',9.00')#</cfoutput></td>
									<td style="font-size:9px" align="right"><cfoutput>#LSNumberFormat(LTAmontodeprev, ',9.00')#</cfoutput></td> 
									<td style="font-size:9px" align="right"><cfoutput>#LSNumberFormat(LTAvallibros, ',9.00')#</cfoutput></td>
								</tr>
								<cfset _LTAmontolocadq = _LTAmontolocadq + LTAmontolocadq>
								<cfset _LTAmontolocmej = _LTAmontolocmej + LTAmontolocmej>
								<cfset _LTAmontolocrev = _LTAmontolocrev + LTAmontolocrev>
								<cfset _LTAmontodepadq = _LTAmontodepadq + LTAmontodepadq>
								<cfset _LTAmontodepmej = _LTAmontodepmej + LTAmontodepmej>
								<cfset _LTAmontodeprev = _LTAmontodeprev + LTAmontodeprev>
								<cfset _LTAvallibros = _LTAvallibros + LTAvallibros>
							</cfloop>
							
							<tr>
								<td style="background-color:#CCCCCC; " colspan="10">&nbsp;</td>
								<td style="background-color:#CCCCCC; " align="right"><strong style="font-size:9px"><cfoutput>#LSNumberFormat(_LTAmontolocadq, ',9.00')#</cfoutput></strong></td> 
								<td style="background-color:#CCCCCC; " align="right"><strong style="font-size:9px"><cfoutput>#LSNumberFormat(_LTAmontolocmej, ',9.00')#</cfoutput></strong></td>
								<td style="background-color:#CCCCCC; " align="right"><strong style="font-size:9px"><cfoutput>#LSNumberFormat(_LTAmontolocrev, ',9.00')#</cfoutput></strong></td> 
								<td style="background-color:#CCCCCC; " align="right"><strong style="font-size:9px"><cfoutput>#LSNumberFormat(_LTAmontodepadq, ',9.00')#</cfoutput></strong></td> 
								<td style="background-color:#CCCCCC; " align="right"><strong style="font-size:9px"><cfoutput>#LSNumberFormat(_LTAmontodepmej, ',9.00')#</cfoutput></strong></td>
								<td style="background-color:#CCCCCC; " align="right"><strong style="font-size:9px"><cfoutput>#LSNumberFormat(_LTAmontodeprev, ',9.00')#</cfoutput></strong></td> 
								<td style="background-color:#CCCCCC; " align="right"><strong style="font-size:9px"><cfoutput>#LSNumberFormat(_LTAvallibros, ',9.00')#</cfoutput></strong></td>
							</tr>
						</table>
						<cfif isdefined("url.imprimir")>
							<table width="100%" border="0">
						  		<tr><td>&nbsp;</td></tr>
						  		<tr>
									<td align="center">-- Fin del Reporte --</td>
								</tr>
							</table>
						</cfif>
						
					</td>
				</tr>
			</table>		
		</td>
  	</tr>
</table>

