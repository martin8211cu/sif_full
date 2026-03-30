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
							</td>
						</tr>	
						<cfif isdefined('form.btnFiltrar')>
							<tr>
								<td>
									<cfinclude template="repRetiro-lista.cfm">
								</td>
							</tr>	
						</cfif>
					</table>
				<cf_web_portlet_end>
			<cf_templatefooter>						
	<cfelse>
		<cfset param = "">
		<cfset filtro = "">
		<cfset navegacion = "">								
		<table width="100%" border="0">
			<tr>
				<td>&nbsp;</td>
				<td>							
					<cfif isdefined('form.AGTPid') and form.AGTPid NEQ ''>
						<cfset param = param & "&AGTPid=#form.AGTPid#">
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "AGTPid=" & Form.AGTPid>
					</cfif>
					<cfinclude template="repRetiro-form.cfm">
				</td>
				<td>&nbsp;</td>
			</tr>						
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
		</table>
	</cfif>
<cfelse>
 <cfset  LvarFiles="">
<cfloop index="AGTPid" list="#form.chk#">
	<cfquery name="rsDatos" datasource="#session.dsn#">
			select 
				rtrim(b.Aplaca) as LAplaca, 
				rtrim(b.Adescripcion) as LAdescripcion,
				Clas.ACgastodep as Complemento, 
				
			(select ac.ACcodigodesc
					from ACategoria ac
					where ac.Ecodigo = b.Ecodigo
						and ac.ACcodigo = b.ACcodigo
					) as Categoria,
				(select cl.ACcodigodesc
					from AClasificacion cl
					where cl.Ecodigo = b.Ecodigo
						and cl.ACcodigo = b.ACcodigo
						and cl.ACid = b.ACid
					) as Clasificacion,
					(select {fn concat({fn concat(rtrim(ltrim(cf.CFcodigo)),' - ')},rtrim(ltrim(cf.CFdescripcion)))}
					from CFuncional cf
						where cf.CFid = a.CFid
					) as CFdescripcion,
					
				TAmontolocadq as LTAmontolocadq, 
				TAmontolocmej as LTAmontolocmej, 
				TAmontolocrev as LTAmontolocrev, 
				
				TAmontodepadq,
				TAmontodepmej,
				TAmontodeprev,
	
				TAmontolocadq + TAmontolocmej + TAmontolocrev -
				TAmontodepadq - TAmontodepmej - TAmontodeprev as LTAmontoloctot,
	
				<cf_dbfunction name="concat" args="ltrim(rtrim(o.Oficodigo)); '-';ltrim(rtrim(o.Odescripcion))" delimiters= ";"> as Oficina,
				afrr.AFRdescripcion	as Motivo,
				agt.AGTPrazon as Justificacion,
				{fn concat( rtrim(crcc.CRCCcodigo), {fn concat('-' , rtrim(crcc.CRCCdescripcion) )} )} as Centro_Custodia,
				
				(select	Cuent.Cformato
				from CContables Cuent
					where Cuent.Ccuenta = Clas.ACcadq
					and b.Ecodigo=Cuent.Ecodigo) as Cuenta_Costo,
					
				(select	Cuent2.Cformato
				from CContables Cuent2
					where Cuent2.Ccuenta = Clas.ACcdepacum
					and b.Ecodigo=Cuent2.Ecodigo) as Cuenta_Depreciacion_Ac,
					
				coalesce(cf.CFcuentagastoretaf, cf.CFcuentaaf, cf.CFcuentac) as CuentaGasto
									
			
			from ADTProceso a 
				inner join Activos b 
					on a.Aid = b.Aid 
						and a.Ecodigo = b.Ecodigo
						
				inner join AClasificacion Clas
					on b.Ecodigo=Clas.Ecodigo
					and b.ACcodigo=Clas.ACcodigo
					and Clas.ACid=b.ACid
					
				inner join ACategoria Cate
					on b.Ecodigo=Cate.Ecodigo
					and b.ACcodigo=Cate.ACcodigo
						
				inner join AFResponsables afr
					on b.Aid = afr.Aid
				   and b.Ecodigo = afr.Ecodigo

			inner join CRCentroCustodia crcc
					on crcc.CRCCid = afr.CRCCid
				   and crcc.Ecodigo = afr.Ecodigo					
						
				inner join CFuncional cf
					on cf.CFid = a.CFid
				   and cf.Ecodigo = b.Ecodigo
		
				inner join Oficinas o
					on o.Ocodigo = cf.Ocodigo
				   and o.Ecodigo = cf.Ecodigo  
		
				inner join AGTProceso agt
					on agt.AGTPid  = a.AGTPid 
					  and agt.Ecodigo = a.Ecodigo
		
				inner join AFRetiroCuentas afrr
					on afrr.AFRmotivo = agt.AFRmotivo
					  and afrr.Ecodigo = agt.Ecodigo						
						
			where a.Ecodigo = #session.Ecodigo#
			and a.AGTPid = #AGTPid#
			and afr.AFRffin =(	 Select Max(afr1.AFRffin)
												 from AFResponsables afr1
												 where afr1.Aid = afr.Aid
												   and afr1.Ecodigo = afr.Ecodigo )
		union all
		
			select 
				rtrim(b.Aplaca) as Placa, 
				rtrim(b.Adescripcion) as Activo,
				Acl.ACgastodep as Complemento,
				(select ac.ACcodigodesc
				from ACategoria ac
				where ac.Ecodigo = b.Ecodigo
					and ac.ACcodigo = b.ACcodigo
				) as Categoria,
			(select cl.ACcodigodesc
				from AClasificacion cl
				where cl.Ecodigo = b.Ecodigo
					and cl.ACcodigo = b.ACcodigo
					and cl.ACid = b.ACid
				) as Clasificacion,
				
			(select {fn concat({fn concat(rtrim(ltrim(cf.CFcodigo)),' - ')},rtrim(ltrim(cf.CFdescripcion)))}
				from CFuncional cf
					where cf.CFid = a.CFid
				) as DescripcionCentroF,
				
				TAmontolocadq as MontoLocalAdq, 
				TAmontolocmej as MontoLocalMej, 
				TAmontolocrev as MontoLocalRev, 
				
				
				TAmontodepadq as MontoDepreAdq,
				TAmontodepmej as MontoDepreMej,
				TAmontodeprev as MontoDepreRev,
				
				(TAmontolocadq + TAmontolocmej + TAmontolocrev -
				TAmontodepadq - TAmontodepmej - TAmontodeprev) as LTAmontoloctot,
				
				<cf_dbfunction name="concat" args="ltrim(rtrim(o.Oficodigo)); '-';ltrim(rtrim(o.Odescripcion))" delimiters= ";"> as Oficina,
				afrr.AFRdescripcion as Motivo,
				a.ADTPrazon as Justificacion,
				{fn concat( rtrim(crcc.CRCCcodigo), {fn concat('-' , rtrim(crcc.CRCCdescripcion) )} )} as Centro_Custodia,
				
				(select	Cont.Cformato
				from CContables Cont
					where Cont.Ccuenta = Acl.ACcadq
					and Cont.Ecodigo=b.Ecodigo) 		as Cuenta_Costo,
					
				(select	Cont2.Cformato
				from CContables Cont2
					where Cont2.Ccuenta = Acl.ACcdepacum
					and Cont2.Ecodigo=b.Ecodigo) 		as Cuenta_Depreciacion_Ac,
					
				(coalesce(cf.CFcuentagastoretaf, cf.CFcuentaaf, cf.CFcuentac)) as CuentaGasto
				
								
			
			from TransaccionesActivos a 
				inner join Activos b 
					on a.Aid = b.Aid 
				   and a.Ecodigo = b.Ecodigo
				
					inner join AClasificacion Acl
						on Acl.Ecodigo=b.Ecodigo
						and Acl.ACcodigo=b.ACcodigo
						and Acl.ACid=b.ACid
					
					inner join ACategoria cat
						on cat.Ecodigo=b.Ecodigo
						and cat.ACcodigo=b.ACcodigo
					   
					inner join AFResponsables afr
						on b.Aid = afr.Aid
					   and b.Ecodigo = afr.Ecodigo

						inner join CRCentroCustodia crcc
							on crcc.CRCCid = afr.CRCCid
						   and crcc.Ecodigo = afr.Ecodigo
									
				inner join CFuncional cf
					on cf.CFid = a.CFid
				   and cf.Ecodigo = b.Ecodigo
		
					inner join Oficinas o
						on o.Ocodigo = cf.Ocodigo
					   and o.Ecodigo = cf.Ecodigo  
		
				inner join AGTProceso agt
					on agt.AGTPid  = a.AGTPid 
					  and agt.Ecodigo = a.Ecodigo						
		
					inner join AFRetiroCuentas afrr
						on afrr.AFRmotivo = agt.AFRmotivo
						  and afrr.Ecodigo = agt.Ecodigo					
						
			where a.Ecodigo = #session.Ecodigo#
			and a.AGTPid = #AGTPid#
		 and afr.AFRffin =(	 Select Max(afr1.AFRffin)
													 from AFResponsables afr1
													 where afr1.Aid = afr.Aid
													   and afr1.Ecodigo = afr.Ecodigo )
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
    <cfquery name="nombre" datasource="#session.DSN#">
		select 	 AGTPdescripcion
        from AGTProceso
    	where AGTPid = #AGTPid#
    </cfquery>
		<cf_exportQueryToFile query="#rsDatos#" separador="#chr(9)#" filename="#nombre.AGTPdescripcion#.txt" download="false">
	    <cfset  LvarFiles=listAppend(LvarFiles,"#nombre.AGTPdescripcion#.txt")>
</cfloop>

    <cfset objZip = CreateObject( "component", "ZipUtility" ).Init() />
		<cfloop list="#LvarFiles#" index="LvarFile">
			<cfset objZip.AddFileEntry(  "#GetTempDirectory()#/#LvarFile#") />
        </cfloop>
    
     <cfset objOutputStream = CreateObject("java","java.io.ByteArrayOutputStream").Init()/>
 

<cfset objZip.Compress(objOutputStream) />
 
<cfheader name="content-disposition" value="attachment; filename=archivos_retiros.zip"/>

<cfcontent type="application/zip" variable="#objOutputStream.ToByteArray()#"/>
    
    
    <cfloop list="#LvarFiles#" index="LvarFile">
    	<cffile action="delete" file="#GetTempDirectory()#/#LvarFile#">
	</cfloop>
<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
<cfheader name="Content-Disposition"	value="attachment;filename=RetiroRetroactivo.zip">
<cfcontent type="application/zip" reset="yes" file="#GetTempDirectory()#/RetiroRetroactivo.zip" deletefile="yes">
<cfabort>

</cfif>
