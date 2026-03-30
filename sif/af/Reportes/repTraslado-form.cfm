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
	font-family: "Times New Roman", Times, serif;
	font-size: 11px;
	font-weight: bolder;

}
-->
</style>

<cfquery name="rsQuery" datasource="#session.dsn#" maxrows="5001">
	select 
		
		b.Aid as LAid, rtrim(b.Aplaca) as LAplaca, rtrim(b.Adescripcion) as LAdescripcion, 
		bb.Aid as LAiddestino, coalesce(rtrim(bb.Aplaca), rtrim(a.Aplacadestino)) as LAplacadestino, 
		coalesce(rtrim(bb.Adescripcion),rtrim(b.Adescripcion)) as LAdescripciondestino,
			
		AGTPid as LAGTPid,
		
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
		
		<cf_dbfunction name="concat" args="ltrim(rtrim(o.Oficodigo)),'-',ltrim(rtrim(o.Odescripcion))"> as Oficodigo,
		coalesce(  (Select <cf_dbfunction name="concat" args="ltrim(rtrim(ofd.Oficodigo)),'-',ltrim(rtrim(ofd.Odescripcion))">
				from AFSaldos afsd
						inner join Oficinas ofd
						     on ofd.Ocodigo  = afsd.Ocodigo
						   and ofd.Ecodigo  = afsd.Ecodigo

				where bb.Aid = afsd.Aid
				   and bb.Ecodigo = afsd.Ecodigo
				   and afsd.AFSperiodo = a.TAperiodo 
				   and afsd.AFSmes = a.TAmes
				) ,'ND') as Oficodigodest,		
		
		<cf_dbfunction name="concat" args="rtrim(ltrim(acat.ACcodigodesc)),'-',rtrim(ltrim(acat.ACdescripcion))">  as CategoriaOrg,
		<cf_dbfunction name="concat" args="rtrim(ltrim(acla.ACcodigodesc)),'-',rtrim(ltrim(acla.ACdescripcion))">  as ClaseOrg,
		
		coalesce( (Select  <cf_dbfunction name="concat" args="rtrim(ltrim(catd.ACcodigodesc)),'-',rtrim(ltrim(catd.ACdescripcion))"> 
		from  ACategoria catd
  	    	where catd.ACcodigo = bb.ACcodigo
		    and catd.Ecodigo  = bb.Ecodigo
		 )   ,'ND') as CategoriaDst,


		coalesce( (Select <cf_dbfunction name="concat" args="rtrim(ltrim(clsd.ACcodigodesc)),'-',rtrim(ltrim(clsd.ACdescripcion))"> 
		from AClasificacion clsd
  	    	where clsd.ACid     = bb.ACid
		   and clsd.Ecodigo  = bb.Ecodigo		
		   and clsd.ACcodigo = bb.ACcodigo) ,'ND') as ClaseDst
	
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
	where IDtrans = 8
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
	<cfif isdefined('form.AGTPid') and  len(trim(form.AGTPid)) gt 0 and form.AGTPid gt 0>
		and a.AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
	<cfelseif isdefined('form.Periodo') and  len(trim(form.Periodo)) gt 0 and form.Periodo gt 0
		and isdefined('form.Mes') and  len(trim(form.Mes)) gt 0 and form.Mes gt 0>
		and TAperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Periodo#">
		and TAmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mes#">
	<cfelse>
		<cf_errorCode	code = "50108" msg = "Se requiere Transacción o Periodo / Mes para ver el Reporte. Proceso Cancelado!">
	</cfif>
	
	union all
	
	select 

	b.Aid as LAid, rtrim(b.Aplaca) as LAplaca, rtrim(b.Adescripcion) as LAdescripcion, 
	bb.Aid as LAiddestino, rtrim(bb.Aplaca) as LAplacadestino, rtrim(bb.Adescripcion) as LAdescripciondestino,
		
	AGTPid as LAGTPid, 
	
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
	
	<cf_dbfunction name="concat" args="ltrim(rtrim(o.Oficodigo)),'-',ltrim(rtrim(o.Odescripcion))"> as Oficodigo,
	<cf_dbfunction name="concat" args="ltrim(rtrim(ofd.Oficodigo)),'-',ltrim(rtrim(ofd.Odescripcion))"> as Oficodigodest,
	
	<cf_dbfunction name="concat" args="rtrim(ltrim(acat.ACcodigodesc)),'-',rtrim(ltrim(acat.ACdescripcion))"> as CategoriaOrg,
	<cf_dbfunction name="concat" args="rtrim(ltrim(acla.ACcodigodesc)),'-',rtrim(ltrim(acla.ACdescripcion))"> as ClaseOrg,
	
	<cf_dbfunction name="concat" args="rtrim(ltrim(catd.ACcodigodesc)),'-',rtrim(ltrim(catd.ACdescripcion))"> as CategoriaDst,
	<cf_dbfunction name="concat" args="rtrim(ltrim(clsd.ACcodigodesc)),'-',rtrim(ltrim(clsd.ACdescripcion))"> as ClaseDst	
	
	from TransaccionesActivos a 
		inner join Activos b 
			on a.Aid = b.Aid 
			and a.Ecodigo = b.Ecodigo
			<cfif isdefined('form.ACcodigodesde') and len(trim(form.ACcodigodesde)) gt 0 and form.ACcodigodesde gt 0>
				and b.ACcodigo >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigodesde#">
			</cfif>
			<cfif isdefined('form.ACcodigohasta') and len(trim(form.ACcodigohasta)) gt 0 and form.ACcodigohasta gt 0>
				and b.ACcodigo <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigohasta#">
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
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
	<cfif isdefined('form.AGTPid') and  len(trim(form.AGTPid)) gt 0 and form.AGTPid gt 0>
		and a.AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
	<cfelseif isdefined('form.Periodo') and  len(trim(form.Periodo)) gt 0 and form.Periodo gt 0
		and isdefined('form.Mes') and  len(trim(form.Mes)) gt 0 and form.Mes gt 0>
		and TAperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Periodo#">
		and TAmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mes#">
	<cfelse>
		<cf_errorCode	code = "50108" msg = "Se requiere Transacción o Periodo / Mes para ver el Reporte. Proceso Cancelado!">
	</cfif>

</cfquery>

<cfif rsQuery.recordcount GT 5000>
	<cf_errorCode	code = "50109" msg = "La cantidad de activos a desplegar sobrepasa los 5000 registros. Reduzca los rangos en los filtros ó descargue archivo. ">
	<cfabort>
</cfif>

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

<cfset LvarIrA = 'repTraslado.cfm?AGTPid='>
<cfif isdefined('LvarReporte') and len(trim(LvarReporte))>
	<cfset form.periodo =''>
	<cfset LvarIrA = '/cfmx/sif/af/Reportes/rptTrasladosMes.cfm'>
</cfif>

<cf_htmlReportsHeaders 
	title="Impresion de Traslado" 
	filename="RepTraslado.xls"
	irA="#LvarIrA#"
	download="no"
	preview="no">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr class="areaFiltro">
		<td colspan="4" align="center"  bgcolor="#E4E4E4"><cfoutput><span class="style3">#Session.Enombre#</span></cfoutput></td>
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
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
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
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
			and ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigohasta#">
		</cfquery>
		<tr>
			<td colspan="4" align="center"><span class="style1"><cfoutput>Hasta la Categor&iacute;a #rsCategoriahasta.ACcodigodesc# - #rsCategoriahasta.ACdescripcion#</cfoutput></span></td>
		</tr>
	</cfif>
	<tr>
		<td colspan="4" align="center"><cfoutput><font size="2"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(Now(),'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(Now(),'medium')#</font></cfoutput></td>
	</tr>		
	<tr>
		<td colspan="4">
			<table width="100%"  border="0" cellspacing="3" cellpadding="0">
				<tr class="style6"><td colspan="17">&nbsp;</td></tr>
				<tr class="style6">
					<td >Placa</td>
					<td >Descripci&oacute;n</td>
					<td >Oficina</td>
					<td >Categoria</td>
					<td >Clase</td>
					<td >Placa Dest.</td>
					<td >Descripci&oacute;n Dest.</td>
					<td >Oficina Dest.</td>
					<td >Categoria Dest.</td>
					<td >Clase Dest.</td>
					<td >Adquisici&oacute;n</td> 
					<td >Mejoras
					<td >Revaluaci&oacute;n</td> 
					<td >Dep. Adquisici&oacute;n</td> 
					<td >Dep. Mejoras</td>
					<td >Dep. Revaluaci&oacute;n</td> 
					<td >Valor En Libros</td>
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
					<tr class="style2">
						<td><cfoutput>#LAplaca#</cfoutput></td>
						<td><cfoutput>#LAdescripcion#</cfoutput></td>
						<td><cfoutput>#Oficodigo#</cfoutput></td>
						<td><cfoutput>#CategoriaOrg#</cfoutput></td>
						<td><cfoutput>#ClaseOrg#</cfoutput></td>
						<td><cfoutput>#LAplacadestino#</cfoutput></td>
						<td><cfoutput>#LAdescripciondestino#</cfoutput></td>
						<td><cfoutput>#Oficodigodest#</cfoutput></td>
						<td><cfoutput>#CategoriaDst#</cfoutput></td>
						<td><cfoutput>#ClaseDst#</cfoutput></td>
						<td align="right"><cfoutput>#LSNumberFormat(LTAmontolocadq, ',9.00')#</cfoutput></td> 
						<td align="right"><cfoutput>#LSNumberFormat(LTAmontolocmej, ',9.00')#</cfoutput></td>
						<td align="right"><cfoutput>#LSNumberFormat(LTAmontolocrev, ',9.00')#</cfoutput></td> 
						<td align="right"><cfoutput>#LSNumberFormat(LTAmontodepadq, ',9.00')#</cfoutput></td> 
						<td align="right"><cfoutput>#LSNumberFormat(LTAmontodepmej, ',9.00')#</cfoutput></td>
						<td align="right"><cfoutput>#LSNumberFormat(LTAmontodeprev, ',9.00')#</cfoutput></td> 
						<td align="right"><cfoutput>#LSNumberFormat(LTAvallibros, ',9.00')#</cfoutput></td>
					</tr>
					<cfset _LTAmontolocadq = _LTAmontolocadq + LTAmontolocadq>
					<cfset _LTAmontolocmej = _LTAmontolocmej + LTAmontolocmej>
					<cfset _LTAmontolocrev = _LTAmontolocrev + LTAmontolocrev>
					<cfset _LTAmontodepadq = _LTAmontodepadq + LTAmontodepadq>
					<cfset _LTAmontodepmej = _LTAmontodepmej + LTAmontodepmej>
					<cfset _LTAmontodeprev = _LTAmontodeprev + LTAmontodeprev>
					<cfset _LTAvallibros = _LTAvallibros + LTAvallibros>
				</cfloop>
				
				<tr class="style5">
					<td colspan="10"><strong>Totales</strong>&nbsp;</td>
					<td align="right"><cfoutput>#LSNumberFormat(_LTAmontolocadq, ',9.00')#</cfoutput></td> 
					<td align="right"><cfoutput>#LSNumberFormat(_LTAmontolocmej, ',9.00')#</cfoutput></td>
					<td align="right"><cfoutput>#LSNumberFormat(_LTAmontolocrev, ',9.00')#</cfoutput></td> 
					<td align="right"><cfoutput>#LSNumberFormat(_LTAmontodepadq, ',9.00')#</cfoutput></td> 
					<td align="right"><cfoutput>#LSNumberFormat(_LTAmontodepmej, ',9.00')#</cfoutput></td>
					<td align="right"><cfoutput>#LSNumberFormat(_LTAmontodeprev, ',9.00')#</cfoutput></td> 
					<td align="right"><cfoutput>#LSNumberFormat(_LTAvallibros, ',9.00')#</cfoutput></td>
				</tr>
			</table>
		</td>
  	</tr>
</table>


