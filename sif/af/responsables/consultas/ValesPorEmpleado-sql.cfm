<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfparam name="form.TipoVale" type="numeric" default="-1">
<cfset registrosxcontext = 500>
<cfset titulodoc = "">
<cf_dbfunction name="now" returnvariable="hoy">
<cfif isdefined("form.TipoVale") and form.TipoVale neq -1>
	<cfquery name="rsTipoDocumento" datasource="#session.DSN#">
		select CRTDid, CRTDdescripcion 
		  from CRTipoDocumento
		where Ecodigo = #Session.Ecodigo#
		  and CRTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoVale#">
	</cfquery>
	<cfif rsTipoDocumento.recordcount gt 0>
		<cfset titulodoc = rsTipoDocumento.CRTDdescripcion>
	</cfif>
</cfif>

<cfif isdefined("form.DEid") and len(trim(form.DEid)) gt 0>
	<cfset nDEid = #LSParseNumber(form.DEid)#>
<cfelse>
	<cfset nDEid = ''>
</cfif>


<cfquery name="rsReporte" datasource="#session.DSN#">
	select  
		a.AFRffin,
		a.CRCCid,		
		ltrim(rtrim(b.CRCCcodigo)) #_Cat# '-' #_Cat# ltrim(rtrim(b.CRCCdescripcion)) as CentroCustodia,
		c.Aplaca as Placa,
		a.AFRfini as Fecha,
		coalesce(a.CRDRdescripcion,'-') as Descripcion,
		coalesce(CRDRdescdetallada,'-') as DescripcionDet, 
		a.CRTDid,
		rtrim(d.CRTDdescripcion) as TipoDocumento,
		e.ACdescripcion as Categoria,
		f.ACdescripcion as Clase,
		c.Aserie as Serie,
		g.DEidentificacion  as Cedula,
		g.DEnombre #_Cat# ' ' #_Cat# g.DEapellido1 #_Cat# ' ' #_Cat# g.DEapellido2 as Nombre,
		ltrim(rtrim(CFACT.CFcodigo)) #_Cat# ' - ' #_Cat# ltrim(rtrim(CFACT.CFdescripcion)) as CFactivo,
		case when (#hoy# >= a.AFRfini and #hoy# <= a.AFRffin) then 'Activo' else 'Inactivo' end as descEstado,
		case when (#hoy# >= a.AFRfini and #hoy# <= a.AFRffin) then 'A' else 'I' end as idEstado,
		(select min(HIS.CRBfecha) 
			from CRBitacoraTran  HIS
			where  HIS.Ecodigo = c.Ecodigo
		       and HIS.CRBPlaca = c.Aplaca
		       and HIS.CRBid = (select max(BITC.CRBid) 
						           from CRBitacoraTran BITC 
						        where BITC.Ecodigo = c.Ecodigo
						          and BITC.CRBPlaca = c.Aplaca) 
		) as UltimaMofic,
		h.Usulogin
		
	from AFResponsables a
	  inner join CRCentroCustodia b
		on b.Ecodigo = a.Ecodigo 
		and b.CRCCid = a.CRCCid
	  inner join Activos c
		on c.Aid = a.Aid 
		and c.Ecodigo = a.Ecodigo
	  left outer join CRTipoDocumento d 
	    on d.Ecodigo = a.Ecodigo 
		and d.CRTDid =a.CRTDid 
	  left outer join ACategoria e 
		on e.Ecodigo = c.Ecodigo 
		and e.ACcodigo =c.ACcodigo
	  left outer join AClasificacion f 
		on f.Ecodigo = e.Ecodigo 
		and f.ACcodigo =e.ACcodigo
		and f.ACid =c.ACid
	  left outer join DatosEmpleado  g
		 on a.DEid 	= g.DEid
	  left outer join CFuncional CFACT
		on CFACT.CFid = a.CFid	
	  left outer join Usuario h 
		on a.Usucodigo = h.Usucodigo

	where 
	<cfif len(trim(nDEid)) gt 0>
    	a.DEid = #nDEid#
    <cfelse>
    	1 = 1
    </cfif>
	  and a.Ecodigo =  #Session.Ecodigo#
	<cfif isdefined("form.TipoVale") and form.TipoVale neq -1>
		and a.CRTDid = #form.TipoVale#
	</cfif>
	<cfif form.VER eq 'A'or form.VER eq "A,T">
		and (#hoy# >= a.AFRfini and #hoy# <= a.AFRffin)
	<cfelseif form.VER eq 'I'>
		and #hoy# > a.AFRffin
	</cfif> 		
	union all
		select   
		<CF_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null"> as AFRffin,
			a.CRCCid,
			<cf_dbfunction name="concat" args="ltrim(rtrim(b.CRCCcodigo)) ,'-', ltrim(rtrim(b.CRCCdescripcion))"> as CentroCustodia,
			a.CRDRplaca as Placa,
			CRDRfdocumento as Fecha,
			coalesce(a.CRDRdescripcion,'-') as Descripcion,
			coalesce(CRDRdescdetallada,'-') as DescripcionDet, 
			a.CRTDid,
			rtrim(d.CRTDdescripcion) as TipoDocumento,
			e.ACdescripcion as Categoria,
			f.ACdescripcion as Clase,
			a.CRDRserie as Serie,
			g.DEidentificacion  as Cedula,
		    <cf_dbfunction name="concat" args="g.DEnombre,' ',g.DEapellido1,' ',g.DEapellido2"> as Nombre,
		    <cf_dbfunction name="concat" args="CFACT.CFcodigo,' ',' ',CFACT.CFdescripcion"> as CFActivo,			
			'Tránsito' as descEstado,
			'T' as idEstado,
			(select min(HIS.CRBfecha) 
				from CRBitacoraTran HIS 
			  where HIS.Ecodigo  = a.Ecodigo
			    and HIS.CRBPlaca = a.CRDRplaca 
			    and HIS.CRBid = (select  max(BITC.CRBid) 
						 	   from CRBitacoraTran BITC 
						     where BITC.Ecodigo = a.Ecodigo
						   	   and BITC.CRBPlaca = a.CRDRplaca)
			)as UltimaMofic,
			h.Usulogin
							
		from CRDocumentoResponsabilidad a
		  inner join CRCentroCustodia b
			 on b.Ecodigo = a.Ecodigo 
			and b.CRCCid = a.CRCCid
		  left outer join CRTipoDocumento d 
			 on d.Ecodigo = a.Ecodigo 
			and d.CRTDid =a.CRTDid 
		  left outer join ACategoria e 
			 on e.Ecodigo = a.Ecodigo 
			and e.ACcodigo =a.ACcodigo
		  left outer join AClasificacion f 
			 on f.Ecodigo = a.Ecodigo 
			and f.ACcodigo = a.ACcodigo
			and f.ACid = a.ACid
		  inner join DatosEmpleado  g
			 on a.DEid 	= g.DEid
		  left outer join CFuncional CFACT
			 on CFACT.CFid = a.CFid	
		  left outer join Usuario h 
		     on a.BMUsucodigo = h.Usucodigo
					
		where
	        <cfif len(trim(nDEid)) gt 0>
                a.DEid = #nDEid#
            <cfelse>
                1 = 1
            </cfif>
			and a.Ecodigo =  #Session.Ecodigo#
		<cfif isdefined("form.TipoVale") and form.TipoVale neq -1>
			and a.CRTDid = #form.TipoVale#
		</cfif>
	order by 2,8
</cfquery>

<cfquery name="rsEmpleado" datasource="#session.DSN#">
	select  
		g.DEidentificacion  as Cedula,
		g.DEnombre #_Cat# ' ' #_Cat# g.DEapellido1 #_Cat# ' ' #_Cat# g.DEapellido2 as Nombre
	  from DatosEmpleado  g
	where 
	  	g.DEid = #nDEid#
    
</cfquery>

<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<cfset CORTE1 = "">
<cfset CORTE2 = "">
<cfset Contadorlineas = 1>
<cfset LvarFileName = "DocumentosPorEmpleado#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<cf_htmlReportsHeaders 
		title="Documentos Por Empleado" 
		filename="#LvarFileName#"
		irA="ValesPorEmpleado.cfm" 
		>
	<style>
		H1.Corte_Pagina
		{
		PAGE-BREAK-AFTER: always
		}
		<!--table
		{mso-displayed-decimal-separator:"\.";
			mso-displayed-thousand-separator:"\,";}
		@page
			{margin:1.0in .75in 1.0in .75in;
			mso-header-margin:.5in;
			mso-footer-margin:.5in;}
		tr
			{mso-height-source:auto;}
		col
			{mso-width-source:auto;}
		br
			{mso-data-placement:same-cell;}
		.style0
			{mso-number-format:General;
			text-align:general;
			vertical-align:bottom;
			mso-rotate:0;
			mso-background-source:auto;
			mso-pattern:auto;
			color:windowtext;
			font-size:10.0pt;
			font-weight:400;
			font-style:normal;
			text-decoration:none;
			font-family:Arial;
			mso-generic-font-family:auto;
			mso-font-charset:0;
			border:none;
			mso-protection:locked visible;
			mso-style-name:Normal;
			mso-style-id:0;}
		.xl24
			{mso-style-parent:style0;
			mso-number-format:Standard;}
		.xl25
			{mso-style-parent:style0;
			font-size:8.0pt;
			font-weight:700;
			text-align:center;
			background:silver;
			mso-pattern:auto none;
			white-space:normal;}
		.xl25L
			{mso-style-parent:style0;
			font-size:7.0pt;
			font-weight:700;
			text-align:left;
			background:silver;
			mso-pattern:auto none;
			white-space:normal;}
		.xl25R
			{mso-style-parent:style0;
			font-size:7.0pt;
			font-weight:700;
			text-align:right;
			background:silver;
			mso-pattern:auto none;
			mso-number-format:Fixed;
			white-space:normal;} 
		.xl26
			{mso-style-parent:style0;
			font-size:8.0pt;
			font-weight:700;
			text-align: center;
			font-family:Arial, sans-serif;
			mso-font-charset:0;}
		.xl27
			{mso-style-parent:style0;
			font-size:7.5pt;
			font-weight:bold;
			text-align:right;
			font-family:Arial, sans-serif;
			mso-font-charset:0;}
		.xl28_R
			{mso-style-parent:style0;
			font-size:7.5pt;
			text-align:right;
			font-family:Arial, sans-serif;
			mso-font-charset:0;}
		.xl28R
			{mso-style-parent:style0;
			font-size:7.0pt;
			font-family:Arial, sans-serif;
			mso-font-charset:0;
			mso-number-format:Fixed;
			text-align:right;}
		.xl28LX
			{mso-style-parent:style0;
			font-size:8.0pt;
			text-align: left;
			font-weight:700;
			font-family:Arial, sans-serif;
			mso-number-format:"\@";}		
		.xl28L
			{mso-style-parent:style0;
			font-size:7.5pt;
			text-align: left;
			font-family:Arial, sans-serif;
			mso-number-format:"\@";}
		.xl28LS
			{mso-style-parent:style0;
			font-size:7.5pt;
			text-align: left;
			font-family:Arial, sans-serif;
			mso-number-format:"\@";}	
		.xl29
			{mso-style-parent:style0;
			font-size:7.5pt;
			font-family:Arial, sans-serif;
			mso-number-format:"\@";}
		.xl30
			{mso-style-parent:style0;
			font-size:8.0pt;
			font-weight:bold;
			text-align:left;
			mso-pattern:auto none;
			white-space:normal;}
		-->
	</style>
		
	<cfset Vcolspan = "2">
	<cfif isdefined("chkverdres")>
		<cfset Vcolspan = Vcolspan + 1>
	</cfif>
	<cfif isdefined("chkverddet")>
		<cfset Vcolspan = Vcolspan + 1>
	</cfif>
	<cfif isdefined("chkverserie")>
		<cfset Vcolspan = Vcolspan + 1>
	</cfif>								
	<cfif isdefined("chkvercategoria")>
		<cfset Vcolspan = Vcolspan + 1>
	</cfif>
	<cfif isdefined("chkverclase")>
		<cfset Vcolspan = Vcolspan + 1>
	</cfif>
	<cfif isdefined("chkvercf")>
		<cfset Vcolspan = Vcolspan + 1>
	</cfif>
	<cfif isdefined("chkveringreso")>
		<cfset Vcolspan = Vcolspan + 1>
	</cfif>	
	<cfif isdefined("chkverfultran")>
		<cfset Vcolspan = Vcolspan + 1>
	</cfif>
	<cfif isdefined("chkverestado")>
		<cfset Vcolspan = Vcolspan + 1>
	</cfif>		
	<cfif isdefined("chkverusuario")>
		<cfset Vcolspan = Vcolspan + 1>
	</cfif>	
	
	<cfset estadoD = " Todos">
	<cfif form.VER eq "A">
		<cfset estadoD = " Activos">
	<cfelseif form.VER eq "I">
		<cfset estadoD = " Inactivos">	
	<cfelseif form.VER eq "T">
		<cfset estadoD = " En Tr&aacute;nsito">		
	<cfelseif form.VER eq "A,T">
		<cfset estadoD = " Activos y En Tr&aacute;nsito">		
	</cfif>
	
	<cfoutput>
		<table  width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
			<tr><td align="center" class="" colspan="#Vcolspan#" ><cfinclude template="RetUsuario.cfm"></td></tr>
			<tr><td align="center" class="" colspan="#Vcolspan#" ><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
			<tr><td align="center" class="" colspan="#Vcolspan#" ><font size="2"><strong>Documentos Por Empleado</strong></font></td></tr>
			
			<cfif rsReporte.recordcount eq 0>
				<tr><td align="center" class="" colspan="#Vcolspan#" ><strong>[#rsEmpleado.cedula#]-#rsEmpleado.Nombre#</strong></td></tr>
				<tr><td align="center" class="" colspan="#Vcolspan#" >--- No se encontraron registros ---</td></tr>
			<cfelse>
				<tr><td align="center" class="" colspan="#Vcolspan#" ><strong>[#rsReporte.cedula#]-#rsReporte.Nombre#</strong></td></tr>			
				<tr><td align="center" class="" colspan="#Vcolspan#" ><strong>Tipo de Documentos: <cfif titulodoc neq "">#titulodoc#<cfelse>Todos</cfif></strong></td></tr>						
				<tr><td align="center" class="" colspan="#Vcolspan#" ><strong>Centro Funcional #rsReporte.CFActivo#</strong></td></tr>
				<tr><td align="center" class="" colspan="#Vcolspan#" ><strong>Estado: #estadoD#</strong></td></tr>
			</cfif>
	</cfoutput>

<cfif rsReporte.recordcount neq 0>
	<cfset Ciclos = rsReporte.recordcount \ registrosxcontext>
	<cfset Ciclos = Ciclos + 1>
		
	<cfloop  index="Cont_Reg" from="1" to="#Ciclos#">
		<cfset startrow = (Cont_Reg-1) * registrosxcontext + 1>
		<cfset endrow = (Cont_Reg * registrosxcontext)>
		<cfif endrow gt rsReporte.recordcount >
			<cfset endrow = rsReporte.recordcount>
		</cfif>
			
		<cfloop query="rsReporte" startrow="#startrow#" endrow="#endrow#">
				<cfoutput>
					<cfset bEntra = false>
					<cfif #rsReporte.idEstado# eq 'A' and form.VER eq 'A'>
						<cfset bEntra = true>
					<cfelseif #rsReporte.idEstado# eq 'I' and form.VER eq 'I'>
						<cfset bEntra = true>
					<cfelseif #rsReporte.idEstado# eq 'T' and form.VER eq 'T'>
						<cfset bEntra = true>				
					<cfelseif (#rsReporte.idEstado# eq 'T' or #rsReporte.idEstado# eq 'A') and form.VER eq 'A,T'>
						<cfset bEntra = true>
					<cfelseif form.VER eq ''>
						<cfset bEntra = true>
					</cfif>
					
					<cfif bEntra>
						<cfif Contadorlineas gte 70>
							<!--- hace un corte de página y pinta los encabezados --->
							<tr><td align="center" colspan="#Vcolspan#"><H1 class=Corte_Pagina></H1></td></tr>
							<tr><td align="center" class="" colspan="#Vcolspan#" ><cfinclude template="RetUsuario.cfm"></td></tr>							
							<tr><td align="center" class="" colspan="#Vcolspan#" ><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
							<tr><td align="center" class="" colspan="#Vcolspan#" ><font size="2"><strong>Documentos Por Empleado</strong></font></td></tr>
							<tr><td align="center" class="" colspan="#Vcolspan#" ><strong>[#rsReporte.cedula#]-#rsReporte.Nombre#</strong></td></tr>
							<tr><td align="center" class="" colspan="#Vcolspan#" ><strong>Tipo de Documentos: <cfif titulodoc neq "">#titulodoc#<cfelse>Todos</cfif></strong></td></tr>								
							<tr><td align="center" class="" colspan="#Vcolspan#" ><strong>Centro Funcional #rsReporte.CFActivo#</strong></td></tr>					
							<tr><td align="center" class="" colspan="#Vcolspan#" ><strong>Estado: #estadoD#</strong></td></tr>			
							<cfset CORTE1 = "">
							<cfset CORTE2 = "">	
							<cfset Contadorlineas = 1>
						</cfif>
						
						<cfset Vcolspan1 = Vcolspan-1 >						
						<cfif trim(rsReporte.CRCCid) neq trim(CORTE1)>
							<cfset CORTE1 = #trim(rsReporte.CRCCid)#>
							<cfset CORTE2 = "">
							<cfset Contadorlineas = Contadorlineas+1>
							<tr><td colspan="#Vcolspan#" nowrap="nowrap"><hr></td></tr>
							<tr>
								<td colspan="#Vcolspan1#+1" class="xl25L" nowrap="nowrap">
									Centro de Custodia:&nbsp;#rsReporte.CentroCustodia#
								</td>
							</tr>
						</cfif>
							
						<cfif trim(rsReporte.CRTDid) neq trim(CORTE2)>
							<cfset CORTE2 = #trim(rsReporte.CRTDid)#>
							<cfset Contadorlineas = Contadorlineas+2>
							<tr>
								<td colspan="#Vcolspan1#+1" class="xl25L" nowrap="nowrap">
									Tipo de Documento:&nbsp;#rsReporte.TipoDocumento#
								</td>
							</tr>		
							<tr>
								<td width="10%" class="xl25L" nowrap="nowrap"><strong>&nbsp;Placa</strong></td>
								<cfif isdefined("chkverdres")>
									<td width="35%" class="xl25L" nowrap="nowrap"><strong>&nbsp;Descripción</strong></td>
								</cfif>
								<cfif isdefined("chkverddet")>
									<td width="35%" class="xl25L" nowrap="nowrap"><strong>&nbsp;Descripción Detallada</strong></td>
								</cfif>
								<cfif isdefined("chkverserie")>
									<td width="10%" class="xl25L" nowrap="nowrap"><strong>&nbsp;Serie</strong></td>
								</cfif>								
								<cfif isdefined("chkvercategoria")>
									<td width="10%" class="xl25L" nowrap="nowrap"><strong>&nbsp;Categoría</strong></td>
								</cfif>
								<cfif isdefined("chkverclase")>
									<td width="10%" class="xl25L" nowrap="nowrap"><strong>&nbsp;Clase</strong></td>
								</cfif>
								<cfif isdefined("chkvercf")>
									<td width="10%" class="xl25L" nowrap="nowrap"><strong>Centro Funcional</strong></td>
								</cfif>
								<cfif isdefined("chkveringreso")>
									<td width="10%" class="xl25L" align="center" nowrap="nowrap"><strong>Fecha Ingreso</strong></td>
								</cfif>
								<cfif isdefined("chkverfultran")>
									<td width="10%" class="xl25L" align="center" nowrap="nowrap"><strong>Fecha Ult. Modificaci&oacute;n</strong></td>
								</cfif>		
								<cfif isdefined("chkverestado")>
									<td width="5%" class="xl25L" nowrap="nowrap"><strong>&nbsp;Estado</strong></td>
								</cfif>
								<cfif isdefined("chkverusuario")>
									<td width="5%" class="xl25L" nowrap="nowrap"><strong>&nbsp;Usuario</strong></td>
								</cfif>
							</tr>					
							<tr><td colspan="11"><hr></td></tr>
						</cfif>
						
						<cfset notransito=1>
						<cfquery name="rsEsTransito" datasource="#session.DSN#">
							select count(1) as total
							from CRDocumentoResponsabilidad
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							  and CRDRplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReporte.Placa#">
						</cfquery>
						<cfif rsEsTransito.total gt 0>
							<cfset notransito=0>
						</cfif>						
							
						<tr>
							<td valign="top" class="xl28LS" nowrap="nowrap">#rsReporte.Placa# </td>
							<cfif isdefined("chkverdres")>
								<td valign="top" class="xl28L" nowrap="nowrap">#trim(Descripcion)#</td>
							</cfif>
							<cfif isdefined("chkverddet")>
								<td valign="top" class="xl28L" nowrap="nowrap">#trim(DescripcionDet)#</td>
							</cfif>
							<cfif isdefined("chkverserie")>
								<td valign="top" class="xl28L" nowrap="nowrap">#trim(Serie)#  </td>
							</cfif>
							<cfif isdefined("chkvercategoria")>
								<td valign="top" class="xl28L" nowrap="nowrap">#trim(Categoria)#  </td>
							</cfif>
							<cfif isdefined("chkverclase")>
								<td valign="top" class="xl28L" nowrap="nowrap">#trim(Clase)# </td>
							</cfif>
							<cfif isdefined("chkvercf")>
								<td valign="top" class="xl28L" nowrap="nowrap">#trim(CFActivo)# </td>
							</cfif>
							<cfif isdefined("chkveringreso")>
								<td valign="top" class="xl28L" align="center" nowrap="nowrap">
									<cfif isdefined("notransito") and notransito eq 1>
										#LSDateFormat(rsReporte.Fecha,'dd/mm/yyyy')#
									<cfelse>	
										&nbsp;									
									</cfif>									
								</td>									
							</cfif>	
							<cfif isdefined("chkverfultran")>
								<td valign="top" class="xl28L" align="center" nowrap="nowrap">#LSDateFormat(rsReporte.UltimaMofic,'dd/mm/yyyy')#</td>
							</cfif>															
							<cfif isdefined("chkverestado")>
								<td valign="top" class="xl26L" nowrap="nowrap">#rsReporte.descEstado#</td>
							</cfif>
							<cfif isdefined("chkverusuario")>
								<td valign="top" class="xl26L" nowrap="nowrap">#rsReporte.Usulogin#</td>
							</cfif>							
						</tr>
						<cfset Contadorlineas = Contadorlineas+1>		
					</cfif>	
				</cfoutput>
		</cfloop>
	</cfloop>
</cfif>	
	
	<!--- Fin del Reporte  --->
	<tr><td align="center"  colspan="<cfoutput>#Vcolspan#</cfoutput>">&nbsp;</td></tr>
	<tr><td colspan="<cfoutput>#Vcolspan#</cfoutput>" align="center"><strong> --- Fin de la Consulta --- </strong></td></tr>
</table>

<!--- ***Valida y concatena los parametros**** --->
<cfset params = "?1=1">
<cfif isdefined("form.chkvercategoria")>
	<cfset params = params & "&chkvercategoria=#form.chkvercategoria#">
</cfif>
<cfif isdefined("form.chkvercf")>
	<cfset params = params & "&chkvercf=#form.chkvercf#">
</cfif>
<cfif isdefined("form.chkverclase")>
	<cfset params = params & "&chkverclase=#form.chkverclase#">
</cfif>
<cfif isdefined("form.chkverserie")>
	<cfset params = params & "&chkverserie=#form.chkverserie#">
</cfif>
<cfif isdefined("form.chkverestado")>
	<cfset params = params & "&chkverestado=#form.chkverestado#">
</cfif>
<cfif isdefined("form.chkverddet")>
	<cfset params = params & "&chkverddet=#form.chkverddet#">
</cfif>
<cfif isdefined("form.chkverdres")>
	<cfset params = params & "&chkverdres=#form.chkverdres#">
</cfif>
<cfif isdefined("form.chkverusuario")>
	<cfset params = params & "&chkverusuario=#form.chkverusuario#">
</cfif>
<cfif isdefined("form.chkveringreso")>
	<cfset params = params & "&chkveringreso=#form.chkveringreso#">
</cfif>
<cfif isdefined("form.chkverfultran")>
	<cfset params = params & "&chkverfultran=#form.chkverfultran#">
</cfif>

<cfoutput>
	<form name="form1" method="get" action="ValesPorEmpleado.cfm#params#">
		<input type="hidden" name="reporte" value="ok">
		<cfif isdefined("form.chkvercategoria")><input type="hidden" name="chkvercategoria" value=""></cfif>
		<cfif isdefined("form.chkvercf")><input type="hidden" name="chkvercf" value=""></cfif>
		<cfif isdefined("form.chkverclase")><input type="hidden" name="chkverclase" value=""></cfif>
		<cfif isdefined("form.chkverserie")><input type="hidden" name="chkverserie" value=""></cfif>
		<cfif isdefined("form.chkverestado")><input type="hidden" name="chkverestado" value=""></cfif>
		<cfif isdefined("form.chkverddet")><input type="hidden" name="chkverddet" value=""></cfif>
		<cfif isdefined("form.chkverdres")><input type="hidden" name="chkverdres" value=""></cfif>
		<cfif isdefined("form.chkverusuario")><input type="hidden" name="chkverusuario" value=""></cfif>
		<cfif isdefined("form.chkveringreso")><input type="hidden" name="chkveringreso" value=""></cfif>
		<cfif isdefined("form.chkverfultran")><input type="hidden" name="chkverfultran" value=""></cfif>
	</form>
</cfoutput>